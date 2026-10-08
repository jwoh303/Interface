<%--
**********************************************
* 메뉴 : 발주관리>구매요청접수 
* 화면 : 구매요청접수전PR기준 조회
* 기능 : 구매요청 건을 조회하여 내용을 확인하고 구매발주 승인/반려/보류 처리 하기 위한 화면
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 2016-03-14
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/kep_buyer.js"></script> 
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)  
	  
	String tot_cnt_string = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;
    
 
    String curDate   = CommonUtil.formatDateNoDateGubun(new Date(),1);
    String st_from_date  = "";
    String st_to_date    = "";
    st_from_date        = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");
    if( st_from_date.equals("")){    	
    	st_from_date    = CommonUtil.addDate(new Date(),"M",-3,1);
    	st_from_date = CommonUtil.formatStrinigDate(st_from_date);
    }else{
    	st_from_date    = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");    	
    }
    
    
    st_to_date        = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");
    if( st_to_date.equals("")){    	
    	st_to_date    = CommonUtil.formatDateNoDateGubun(new Date(),1);
    	st_to_date = CommonUtil.formatStrinigDate(st_to_date);
    }else{
    	st_to_date    = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");    	
    } 
   
    		
    		
    		
    String buyer             = "";
    String SessionComCode             = "";
    String zip_code          = "";
    String SessionUserId            = "";
    String userName          = "";
    String SessionUserDept          = ""; 
    String userTel           = "";
    String email             = "";
    String fax_no            = "";
    String mobile            = "";

    String SessionComorgLevel = "";
    String SessionComorgCode  = "";
    String using_catal_type  = "";
    String location_code     = "";
    String location_name     = "";
    String purchaseDeptCode  = "";
    String purchaseDeptName  = ""; 
    
    String row_cnt  = ""; 
    String img_view_flag  = ""; 
    String budget_flag   = ""; 
    String SessionAgentOpenFlag = ""; 
    
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
      buyer             = sessionInfo.getComCode();      
      SessionComCode             = sessionInfo.getComCode();      
      SessionUserId            = sessionInfo.getUserId();
      userName          = sessionInfo.getUserNameLoc();
      SessionUserDept          = sessionInfo.getDepartment(); 
      userTel           = sessionInfo.getTel();
      email             = sessionInfo.getEmail();
      fax_no            = sessionInfo.getFax();
      mobile            = sessionInfo.getmPhone();
      using_catal_type  = sessionInfo.getUsingCatalType();
      
      zip_code          = sessionInfo.getZipCode();
      SessionComorgLevel = sessionInfo.getBycaComorgLevel();
      SessionComorgCode  = sessionInfo.getBycaComorgCode();      
      location_code     = CommonUtil.nvl(sessionInfo.getDelyToLocation());
      location_name     = CommonUtil.nvl(sessionInfo.getDelyToLocationName());
      purchaseDeptCode  = sessionInfo.getPurchaseDept();
      purchaseDeptName  = sessionInfo.getPurchaseDeptName();
      
  	  row_cnt = sessionInfo.getRowCnt(); //20070704 추가 페이지 기본 개수
      img_view_flag = sessionInfo.getImgViewFlag(); // 20070704 이미지보기 우선여부
       
      budget_flag           = sessionInfo.getBudgetFlag();
      SessionAgentOpenFlag  = sessionInfo.getAgentOpenFlag();
	}
    
	// 조회조건 S
    String req_dept_name        = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),"");
    String req_dept_code        = CommonUtil.nvl((String) request.getParameter("st_req_dept_code"),"");
    String pr_no        = CommonUtil.nvl((String) request.getParameter("st_pr_no"),"");
    String ref_no        = CommonUtil.nvl((String) request.getParameter("st_ref_no"),""); 
     
	// 조회조건 E
	
	
	String onepagerow  = "1000"; // 정렬갯수  
%> 

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<div id="ContArea">
	<h3>구매요청접수(PR)</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search" title="조회"><a href="javascript:doAction('search');">조회</a></span> 
		<span class="btn_reset" title="초기화"><a href="javascript:doAction('kep_reload');">초기화</a></span>
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_department" id="st_department" value="${sessionInfo.department}">
		
 
			
		<div id="cont_searchA">	
			<table class="cont_t_list01"  >
				<caption>조회</caption>
				<colgroup>
                    <col width="8%" />
                    <col width="21%" />
                    <col width="8%" />
                    <col width="21%" />
                    <col width="8%" />
                    <col width="21%" />
				</colgroup>
				
				<tbody>
				
				<tr>
					<th>요청일</th>
					<td colspan="5">
						<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:10%; text-align:center;" value="<%=st_from_date%>">
							<a href="javascript:kepCalendar('st_from_date')"></a>
						 - 
						<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:10%; text-align:center;" value="<%=st_to_date%>">
							<a href="javascript:kepCalendar('st_to_date')"></a> 	
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>  
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>			
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','6')">6개월</a></span>	
							<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>						
					</td>                       
				</tr>
				<tr>
					<th>요청부서</th>
					<td>
						<input type="text" class="input_type_text" name="st_req_dept_name" id="st_req_dept_name" style="width:55%;ime-mode:active" value="<%=req_dept_name%>" READONLY>
						<input type="hidden" name="st_req_dept_code" id="st_req_dept_code" value="<%=req_dept_code%>">
						<a href="javascript:getDepartmentCode();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_req_dept_code','st_req_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
                       	<th>요청번호</th>
						<td>
							<input type="text" class="input_type_text" name="st_pr_no" id="st_pr_no" style="width:87%;" value="<%=pr_no%>" onkeyup="kepToUpper('st_pr_no')" onKeyDown="kepEnter()">
						</td>   
						<th></th>
						<td>
							
						</td>
					</tr>
				</tbody>
			</table>
		</div>
 		
   
               	<br>
	</form>  
	<input type="hidden" name="st_po_create_date" size="10" value="<%=curDate%>">
		<table class="cont_t_list02" >
			<colgroup>
	            <col width="10%" />
	            <col width="30%" />
	            <col width="15%" />
	            <col width="6%" />
	            <col width="6%" />
	            <col width="12%" />
	            <col width="12%" /> 
	        </colgroup>
	        <thead>
			<tr> 
                <th scope="col">요청번호</th>
                <th scope="col">품목정보</th> 
                <th scope="col">요청부서</th>
                <th scope="col">요청자ID</th>
                <th scope="col">요청자명</th> 
                <th scope="col">납기요청일</th> 
                <th scope="col">총금액</th> 
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        	total_cnt = "0";
        %>
                    <tr>
                        <td colspan="7" align="center" height = "50"> 
                        <span>조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
        <%
        }else{
        	total_cnt = String.valueOf(_gridList.size());
        	//Map<String,String> rtobj = _gridList.get(0);
            //tot_cnt = Integer.parseInt(rtobj.get("rtobj.searchForm"));
            //tot_cnt_string = rtobj.get("rtobj.searchForm");      	        	
			for (int j=0; j<_gridList.size(); j++) {				
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA"; 
				
				String item_list =""; 

				if(rowData.get("TOT_QTY").equals("0")){

					item_list = rowData.get("DESCRIPTION");

				}else{

					item_list = rowData.get("DESCRIPTION") +"외 "+rowData.get("TOT_QTY") +"종.";

					

				}
				
		%> 
				<tr align="center" bgcolor="<%=tclass%>"> 
						 <td><a class="hyperLink" href="javascript:getPrView('<%=rowData.get("PR_NO")%>')"><%=rowData.get("PR_NO")%></a></td>
						 <td class="left"><%=item_list%></td>
						 <td><%=rowData.get("REQ_DEPT")%></td>
						 <td><%=rowData.get("ADD_USER_ID")%></td>
						 <td><%=rowData.get("ADD_USER_NAME")%></td>
						 <td><%=CommonUtil.formatStrinigDate(rowData.get("ADD_DATE"))%></td>
						 <td class="right"><%=CommonUtil.formatNumber(rowData.get("TOT_AMT"),true,0,3)%></td>
 
				</tr>
            <%
                        } 
        			}
            %>
           		</tbody>
            </table>
<%	if (_gridList != null && _gridList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
<%	}	%>
				<!-- 페이징 -->
		<p id="paging" class="paging">
			<span class="cl">[ 총 <%=total_cnt %> 건 ]</span> 
		</p>  
<br>
		 

        </div>
        <br/>  
 
</div>
<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="curPage" id="curPage" value="" /> 
	<input type="hidden" name="st_check" id="st_check" value="" />     	 	
	<input type="hidden" name="st_pr_no" id="st_pr_no" value="" />     	 	
	<input type="hidden" name="st_from_date" id="st_from_date" value="" />     	 	
	<input type="hidden" name="st_to_date" id="st_to_date" value="" />     	 	
		<input type="hidden" name="st_buyer" id="st_buyer" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_buyer" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="comCode" id="comCode" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_com_code" id="userID" value="${sessionInfo.userId}">
		<input type="hidden" name="userDept" id="userDept" value="${sessionInfo.department}">
		<input type="hidden" name="st_ref_no" id="st_ref_no" value="">
		<input type="hidden" name="st_req_dept_code" id="st_req_dept_code" value="">
		<input type="hidden" name="st_sort_column" id="st_sort_column" value="ALL">  
		<input type="hidden" name="onepagerow" id="onepagerow" value="10">  
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
		<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="N">      	
</form>
<!--내용 종료-->	                  
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">
var popupSel = "";
var selectedRow = "";

// 최초 화면 함수 
function kep_onload_view(){
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");   
	
} 


var st;
//기능함수
function doAction(str) {
		
	switch (str) {
	case "search":	 //조회
		kepSearch();
		break; 
		 
	case "kep_reload":	 //초기화
		kep_reload();
		break; 
		
	}
}


function kep_reload(){
	 
	document.forms.searchForm.st_req_dept_code.value = ""; 
	document.forms.searchForm.st_req_dept_name.value = "";
	document.forms.searchForm.st_pr_no.value = ""; 
	
	
	$("#st_from_date").val( kepToMonthAdd("3","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));    
	 
	
}


//조회
function kepSearch(){
	
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;  
	 
	$('#searchForm').attr("action", "/mppo/getBuyerMpPoOrdePrReqReceiptList.do").submit();   
}
function getDepartmentCode(){ 
	openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code=<%=SessionComCode%>", "500,500,no"); 
} 
function setPopupReturn(code, text) { 
	document.forms.searchForm.st_req_dept_code.value = code;
	document.forms.searchForm.st_req_dept_name.value = text; 
}

function getPrView(pr_no){ 
	
    document.forms.processForm.curPage.value = "1";
    document.forms.processForm.st_check.value = "SEARCH"; 
    document.forms.processForm.st_pr_no.value = pr_no; 
    document.forms.processForm.st_from_date.value = document.forms.searchForm.st_from_date.value; 
    document.forms.processForm.st_to_date.value = document.forms.searchForm.st_to_date.value; 
    document.forms.processForm.target = "_self";
    document.forms.processForm.method = "post";
    document.forms.processForm.action = "/mppo/getBuyerMpPoOrderReqReceiptList.do";
    document.forms.processForm.submit();

}



</script>
</html>
