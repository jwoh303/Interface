<%--
**********************************************
* 메뉴 : 주문/배송조회
* 화면 : 주문/배송조회
* 기능 : 주문/배송조회
* 프로그램 ID : BU0101001
* 담당자 : 최찬규
* 착수일 : 2026-03-03
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf"  %>
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> tab_data = (List<Map<String,String>>) request.getAttribute("tab_data"); // 탭
	String menuId = CommonUtil.nvl((String) request.getParameter("menuId"),""); // 메뉴아이디
	String tabIndex = CommonUtil.nvl((String) request.getParameter("tabIndex"),"1"); // tab Index
	String selStatus = CommonUtil.nvl((String) request.getParameter("selStatus"),""); // selStatus
	
	if(myMenuListHeader != null){ //null이 아닌 경우에만 체크
		for(int i = 0; i<myMenuListHeader.size(); i++){
			if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
				myMenuFlag = true;
				break;
			}
		}
	}
	
	String buyer = "";
	String userid = "";
	String businessCond = "";
	String rowCnt = "30";
	String prMngFlag = "";
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId()); 
		businessCond = CommonUtil.nvl((String)_sessionInfo.getBusinessCond());
		prMngFlag = CommonUtil.nvl((String)_sessionInfo.getPrMngFlag());
		rowCnt = CommonUtil.nvl((String)_sessionInfo.getRowCnt(),"30");
		String pageString = "30,50,100,200,500,1000";
		if(!Arrays.asList(pageString.split(",")).contains(rowCnt)){
			rowCnt = "30";
		}
	}
	

	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수) 
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");	
	String budget_flag           = sessionInfo.getBudgetFlag();
	
    String fromDate  = "";
    String toDate    = "";
    String sortType = CommonUtil.nvl(request.getParameter("st_sortType"),"DESC");
    if (sortType == null ||  "".equals(sortType)){
    	sortType = "DESC";
    }
    fromDate        = CommonUtil.nvl((String) request.getParameter("fromDate"),"");
    if( fromDate.equals("")){
        toDate      =   CommonUtil.formatDateNoDateGubun(new Date(),1);
        fromDate    = CommonUtil.addDate(new Date(),"M",-1,1);
    }else{
        toDate    = CommonUtil.nvl((String) request.getParameter("toDate"),"");
    }    
    fromDate = fromDate.replace("/", "");
    toDate = toDate.replace("/", "");   
    String from_year   = fromDate.substring(0,4);
    String from_month  = fromDate.substring(4,6);
    String from_day    = fromDate.substring(6,8);
    String v_fromDate   = from_year+"/"+from_month+"/"+from_day;
    String to_year   = toDate.substring(0,4);
    String to_month  = toDate.substring(4,6);
    String to_day    = toDate.substring(6,8);
    String v_toDate   = to_year+"/"+to_month+"/"+to_day;
    String SessionComCode        = sessionInfo.getComCode();
    String SessionUserId         = sessionInfo.getUserId();
    String row_cnt = sessionInfo.getRowCnt();
    String img_view_flag = sessionInfo.getImgViewFlag(); // 20070704 이미지보기 우선여부
    String pr_no         = CommonUtil.nvl((String) request.getParameter("st_pr_no"),"ALL"); 
    String legacy_po_no = CommonUtil.nvl((String) request.getParameter("st_legacy_po_no"),"ALL");
    String ref_no        = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"ALL"); 
    String search_type   = CommonUtil.nvl((String) request.getParameter("st_search_type"),"");
    String user_search_type   = CommonUtil.nvl((String) request.getParameter("st_user_search_type"),"");
    String dept_search_type   = CommonUtil.nvl((String) request.getParameter("st_dept_search_type"),"");
    String search_no = CommonUtil.nvl((String) request.getParameter("st_search_no"),"");

    String st_pur_user_id = CommonUtil.nvl((String) request.getParameter("st_pur_user_id"),"");
    String st_pur_user_name = CommonUtil.nvl((String) request.getParameter("st_pur_user_name"),"");
    String st_pur_dept_code = CommonUtil.nvl((String) request.getParameter("st_pur_dept_code"),"");
    String st_pur_dept_name = CommonUtil.nvl((String) request.getParameter("st_pur_dept_name"),"");
    
    if(search_no.equals(""))
    {
       search_type = "BC";
       search_no = "ALL";
    }
    // 진행상태
    String status        = CommonUtil.nvl((String) request.getParameter("st_status"),"ALL");
 //파트유닛
    String unitPart        = CommonUtil.nvl((String) request.getParameter("st_unit_part"),"ALL");
    // HTML 리스트 조회시 공통사용
    String pg_row             = CommonUtil.nvl((String) request.getParameter("st_pg_row"),""); 
    String st_check           = CommonUtil.nvl((String) request.getParameter("st_check"),"SEARCH"); 
 
    String tot_cnt_string = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
 
    // HTML 리스트 조회시 공통사용
    //1개월
    String fromDate1  = "";
    String toDate1    = "";
    toDate1      =   CommonUtil.formatDateNoDateGubun(new Date(),1);
    fromDate1    =    CommonUtil.addDate(new Date(),"M",-1,1);
    //System.out.println("fromDate1 "+fromDate1);
    String from_year1   = fromDate1.substring(0,4);
    String from_month1  = fromDate1.substring(4,6);
    String from_day1    = fromDate1.substring(6,8);
    String v_fromDate1   = from_year1+"/"+from_month1+"/"+from_day1;
    String to_year1   = toDate1.substring(0,4);
    String to_month1  = toDate1.substring(4,6);
    String to_day1    = toDate1.substring(6,8);
    String v_toDate1   = to_year1+"/"+to_month1+"/"+to_day1; 
    

    
	  if ("".equals(curPage)){ 
		  v_fromDate = v_fromDate1;
		  v_toDate = v_toDate1;

	 } 
	
	boolean p060000043 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000043"); // KRCOLL0001 //삭제
	
	boolean p060000060 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000060"); //삭제
	
	boolean getCodeYn = CommonUtil.getCodeCheckReturn("M141",SessionUserId);
	/*
	장바구니 필드추가 제어 
	-TYPE1: 윈체  수량길이 필드 추가
	*/
	String p060000080 =  CommonUtil.getSpecialCheckReturn(buyer,"P06-0000080","COL01_DATA");
	
	boolean p060000091 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000091"); // IF 주문전송 고객사 리스트, 주문취소 불가
	String p060000091_str = String.valueOf(p060000091);
	
	boolean p170000001 = CommonUtil.getSpecialCheckReturn(buyer,"P17-0000001"); //엑셀다운로드 기능 통제
	String p170000001_str = String.valueOf(p170000001);
	
	//관리번호 팝업 연결
    Map<String, String> p060000029_map = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000029");
	String p060000029 = "";
    if (p060000029_map != null){
    	p060000029= CommonUtil.nvl(p060000029_map.get("COL01_DATA"),""); // 관리번호 팝업 연결
    }
    
    boolean p160000004 = CommonUtil.getSpecialCheckReturn(buyer,"P16-0000004");
    
    //검색조건 추가
    String p060000114 =  CommonUtil.nvl(CommonUtil.getSpecialCheckReturn(buyer,"P06-0000114","COL01_DATA"));
    String p060000114_search = "" ;
   if(p060000114.equals("TYPE01")){
	   p060000114_search = sessionInfo.getDepartment();//요청부서 검색조건 추가.
   }else{
	   p060000114_search= "";
   }
%>  
<body onLoad="kep_onload_view();">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerHeader_v2"/>
<c:param name="part" value="buyerHeader_v2"/>
</c:import>   
<div id="container2">
		<!--서브타이틀-->  
  <div class="SubPageTit">
    <%=CommonLang.get("HTITLE1178")%><!--주문/배송조회--><%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star_off"></button>
     	<%} %> 
    <div class="SubPageGuide">
      <ul>
        <li><img src="/resources/imgs/Icon_Home.png" /></li>
        <li><%=CommonLang.get("HTITLE197") %><!-- 주문 --></li>
        <li><%=CommonLang.get("HTITLE1178")%><!--주문/배송조회--></li>
      </ul>
    </div>   
  </div>
  <div class="container">
    <div class="SubSearchTab" style="display: none;"> <!-- 탭이 빠짐에 따라 탭 안보이게 수정 -->
     <%for(int i = 0; i<tab_data.size(); i++){ %>
     	<%=tab_data.get(i).get("MENU_BUTTON") %>
     <%} %>
    </div>
    
    <c:forEach items="${tab_data }" var="item">
    	<jsp:include page="${item.MENU_JSP }" >
    		<jsp:param name="rowCnt" value="<%=rowCnt %>" />
    		<jsp:param name="p170000001" value="<%=p170000001_str %>" />
    		<jsp:param name="p060000091" value="<%=p060000091_str %>" />
    		<jsp:param name="prMngFlag" value="<%=prMngFlag %>" />
    		<jsp:param name="p060000114" value="<%=p060000114 %>" />
    		<jsp:param name="p060000114_search" value="<%=p060000114_search %>" />
    		<jsp:param name="p060000080" value="<%=p060000080 %>" />
    		<jsp:param name="buyer" value="<%=buyer %>" />
    		<jsp:param name="userId" value="<%=userid %>" />
    	</jsp:include>
    </c:forEach>
    
    <script>
      const tabLinks = document.querySelectorAll(".TabTit");
      const tabContents = document.querySelectorAll(".SearchContent");
    
      tabLinks.forEach(function(link){
        link.addEventListener("click", function() {
          // 모든 탭 버튼, 컨텐츠 비활성화
          tabLinks.forEach(function(btn){btn.classList.remove("active")});
          tabContents.forEach(function(content) {content.classList.remove("active")});
    
          // 클릭한 탭 활성화
          link.classList.add("active");
          document.getElementById(link.dataset.tab).classList.add("active");
	      tabs["buyerMpSoOrderProgress_"+link.id]["search"]();
        });
      });
    </script>
  </div>
</div>
 
<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>
</div>
</div>
</body> 
<script type="text/javascript">

var PASS_KN = "";
var st;
var popupSel = "";
// var getMultiApprFlag = "";
function kep_onload_view() {
	var tabIndex = "<%=tabIndex%>";
	var selStatus = "<%=selStatus%>";
	var init = "";
	//버튼에 active
	document.querySelectorAll('button[data-tab]').forEach(function(btn){
		btn.classList.toggle('active',btn.dataset.tab === 'Search'+tabIndex);
		tabs["buyerMpSoOrderProgress_"+btn.id]["init"](); // 각 탭의 init() 함수 실행
	})
	
	if(selStatus != ""){
		init = "true";
	}
	//div에 active
	document.getElementById("Search"+tabIndex).classList.add("active");
	tabs["buyerMpSoOrderProgress_tab"+tabIndex]["search"](selStatus,init);
}
</script>
</html>
