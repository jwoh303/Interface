<%--
**********************************************
* 메뉴 : 결재
* 화면 : 결재
* 기능 : 결재
* 프로그램 ID : 
* 담당자 : 최찬규 
* 착수일 : 2026-02-02
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="java.sql.Timestamp"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")

	List<Map<String,String>> tab_data = (List<Map<String,String>>) request.getAttribute("tab_data"); // 탭
	String menuId = CommonUtil.nvl((String) request.getParameter("menuId"),""); // 메뉴아이디
	String tabIndex = CommonUtil.nvl((String) request.getParameter("tabIndex"),"1"); // tab Index
	
	if(myMenuListHeader != null){ //null이 아닌 경우에만 체크
		for(int i = 0; i<myMenuListHeader.size(); i++){
			if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
				myMenuFlag = true;
				break;
			}
		}
	}
	
	String getMultiApprFlag = CommonUtil.nvl((String)request.getAttribute("getMultiApprFlag"),"N"); // 복수 결재 가능 여부
	
	String st_status = CommonUtil.nvl((String) request.getParameter("st_status"),"1"); // 조회조건
	String st_gubun = CommonUtil.nvl((String) request.getParameter("st_gubun"),""); // 조회조건
	String st_appr_gbn = CommonUtil.nvl((String) request.getParameter("st_appr_gbn"),""); // 조회조건 결재상신조건
	if(!st_appr_gbn.equals("")){
		st_gubun =st_appr_gbn;
	}
	String st_subject = CommonUtil.nvl((String) request.getParameter("st_subject"),""); // 조회조건
	String st_po_user_id = CommonUtil.nvl((String) request.getParameter("st_po_user_id"),""); // 조회조건
	String st_po_user_dept = CommonUtil.nvl((String) request.getParameter("st_po_user_dept"),""); // 조회조건
	String startDate = CommonUtil.nvl((String) request.getParameter("startDate"),""); // 조회조건
	String endDate = CommonUtil.nvl((String) request.getParameter("endDate"),""); // 조회조건
	String moveToBuyer = CommonUtil.nvl((String) request.getParameter("moveToBuyer"),""); // 조회조건
	String st_appr_yn = CommonUtil.nvl((String) request.getParameter("st_appr_yn"),"Y"); // 조회조건
	
	
	//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
	//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
	String session_st_gw_no = CommonUtil.nvl((String)request.getSession().getAttribute("session_st_gw_no"),""); // 결재상신 메일 관련 sso 처리를 위한 결재번호 리턴
	String mailOpen = CommonUtil.nvl((String) request.getParameter("mailOpen"),""); // 조회조건 메일	 결재바로보기에서 왔을경우에만  결재대상조회 
	String userGwNoFlag = CommonUtil.nvl((String) request.getParameter("userGwNoFlag"),""); // 조회조건 메일	 결재바로보기에서 왔을경우에만  결재대상조회 
	
	
	String buyer = "";
	String userid = "";
	String businessCond = "";
	String rowCnt = "30";
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId()); 
		businessCond = CommonUtil.nvl((String)_sessionInfo.getBusinessCond());
		rowCnt = CommonUtil.nvl((String)_sessionInfo.getRowCnt(),"30");
		String pageString = "30,50,100,200,500,1000";
		if(!Arrays.asList(pageString.split(",")).contains(rowCnt)){
			rowCnt = "30";
		}
	} 
%>  
<body onload="kepOnload()">
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerHeader_v2"/>
<c:param name="part" value="buyerHeader_v2"/>
</c:import>   
<div id="container2">
		<!--서브타이틀-->  
  <div class="SubPageTit">
    <%=CommonLang.get("HTITLE1039")%><!--결재관리--><%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star_off"></button>
     	<%} %> 
    <div class="SubPageGuide">
      <ul>
        <li><img src="/resources/imgs/Icon_Home.png" /></li>
        <li><%=CommonLang.get("HTITLE1039")%><!--결재관리--></li>
      </ul>
    </div>   
  </div>
  <div class="container">
    <div class="SubSearchTab">
     <%for(int i = 0; i<tab_data.size(); i++){ %>
     	<%=tab_data.get(i).get("MENU_BUTTON") %>
     <%} %>
    </div>
    
    <c:forEach items="${tab_data }" var="item">
    	<jsp:include page="${item.MENU_JSP }" >
    		<jsp:param name="user_id" value="<%=userid %>" />
    		<jsp:param name="getMultiApprFlag" value="<%=getMultiApprFlag %>" />
    		<jsp:param name="rowCnt" value="<%=rowCnt %>" />
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
          tabs["buyerNewPass_"+link.id]["search"]();
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
function kepOnload() {
	//초기 날짜 셋팅
	var indexLength = $("input[name=st_from_date]").length;
	for(var i = 0; i<indexLength; i++){
		if($("input[name=st_from_date]").eq(i).val() ==  ""){
			$("input[name=st_from_date]").eq(i).val(kepToMonthAdd("1","M"));
			$("input[name=st_to_date]").eq(i).val(kepGetNowTimeStr('YYYYMMDD','/'));
		}
	}
	
	var tabIndex = "<%=tabIndex%>";
	
	//버튼에 active
	document.querySelectorAll('button[data-tab]').forEach(function(btn){
		btn.classList.toggle('active',btn.dataset.tab === 'Search'+tabIndex);
		tabs["buyerNewPass_"+btn.id]["init"](); // 각 탭의 init() 함수 실행
	})
	
	//div에 active
	document.getElementById("Search"+tabIndex).classList.add("active");

	//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
	//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
	<% if ("Y".equals(mailOpen) && !"".equals(session_st_gw_no) && "Y".equals(userGwNoFlag)){%>
		tabs["buyerNewPass_tab"+tabIndex]["doPop"]("myPage",'<%=buyer%>','<%=session_st_gw_no%>','1','RECV');
<%-- 		openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do','?COMPANY=<%=buyer%>&DOCU_NO=<%=session_st_gw_no%>&PASS_TP=1&FLAG=RECV' ,'1200,700,no'); --%>
	<%}%> 
	var st_appr_gbn = "<%=st_appr_gbn%>";//메인 구매요청, 구매발주 타입일 경우 자동 조회
	if(st_appr_gbn=="PR"||st_appr_gbn=="PX"){
// 		kepSearch(1);
	}
	tabs["buyerNewPass_tab"+tabIndex]["search"]();
}

function setPopupReturn(value1,value2,value3){
	location.href=value1;
}
</script>
