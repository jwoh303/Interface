<%--
**********************************************
* 메뉴 : 중앙대 전용 결재대상조회
* 화면 : 결재대상조회
* 기능 : 결재대상조회
* 프로그램 ID : 
* 담당자 : HSJ  
* 착수일 : 2022-03-15
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="page" uri="/WEB-INF/tld"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@include file="../../common/include/head.jspf" %>
</head>
<%
@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
	String _CRUD =  CommonUtil.nvl((String)request.getAttribute("CRUD")); // 조회된결과	
	String total_cnt = CommonUtil.nvl((String)request.getAttribute("total_cnt"),"0"); // 조회된결과
	
	if (_dataList == null || _dataList.size() == 0) {
		total_cnt = "0";
	}
	
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String st_status = CommonUtil.nvl((String) request.getParameter("st_status"),"1"); // 조회조건
	String st_gubun = CommonUtil.nvl((String) request.getParameter("st_gubun"),""); // 조회조건
	String st_appr_gbn = CommonUtil.nvl((String) request.getParameter("st_appr_gbn"),""); // 조회조건 결재상신조건
	if(!st_appr_gbn.equals("")){
		st_gubun =st_appr_gbn;
	}
	String st_subject = CommonUtil.nvl((String) request.getParameter("st_subject"),""); // 조회조건
	String startDate = CommonUtil.nvl((String) request.getParameter("startDate"),""); // 조회조건
	String endDate = CommonUtil.nvl((String) request.getParameter("endDate"),""); // 조회조건
	String moveToBuyer = CommonUtil.nvl((String) request.getParameter("moveToBuyer"),""); // 조회조건
	
	//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
	//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
	String session_st_gw_no = CommonUtil.nvl((String)request.getSession().getAttribute("session_st_gw_no"),""); // 결재상신 메일 관련 sso 처리를 위한 결재번호 리턴
	String mailOpen = CommonUtil.nvl((String) request.getParameter("mailOpen"),""); // 조회조건 메일	 결재바로보기에서 왔을경우에만  결재대상조회 
	String userGwNoFlag = CommonUtil.nvl((String) request.getParameter("userGwNoFlag"),""); // 조회조건 메일	 결재바로보기에서 왔을경우에만  결재대상조회 
	
	String buyer = "";
	String userid = "";
	String businessCond = "";
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId()); 
		businessCond = CommonUtil.nvl((String)_sessionInfo.getBusinessCond());
	} 
	
	String SESSION_COWAY_FLAG = (String)request.getSession().getAttribute("SESSION_COWAY_FLAG"); // 코웨이구분
	Map<String, String> _map = new HashMap<String, String>();
	
	String req_dept_name = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),"");
    String req_dept_code = CommonUtil.nvl((String) request.getParameter("st_req_dept_code"),"");
    String pr_no = CommonUtil.nvl((String) request.getParameter("st_pr_no"),"");
    String drafter = CommonUtil.nvl((String) request.getParameter("st_drafter"),""); // 조회조건
%>  
<body onload="kepOnload()">
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%if(!"Y".equals(moveToBuyer) ){%>
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   
<%} %>
<%if(!"Y".equals(moveToBuyer) ){%>
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<%} %>
<!--내용 시작 고객사, 운영사에 따라 디자인 상이.-->		
<%if("M".equals(businessCond) ){%>
	<div id="container3">
<%}else{%>
    <div id="container2">
<%} %>
<%if(!"Y".equals(moveToBuyer) ){%>
	<div id="ContArea">
<%}else{%>
    <div id="ContArea2">
<%} %>    
      	
      	<!--버튼영역-->
<%if(!"Y".equals(moveToBuyer) ){%>
         <h3><%=CommonLang.get("HTITLE947") %><!-- 결재문서 접수 --></h3>
         <div id="searchBtnA">
<%}else{%>
         <div id="searchBtnA" style="position:relative;  text-align:right; width:950px; height:32px; border: solid 0px; margin-top:5px; ">
         <h3 style="position:absolute; width:500px; font-family:맑은 고딕; font-weight:bold; font-size:18px; color:#333333; text-align:left; letter-spacing:-1px "><%=CommonLang.get("HTITLE295") %><!-- 결재대상조회 --></h3>
<%} %>     
<%if("M".equals(businessCond) ){%> 
         	<span class="Mbtn_search" title="조회"><a href="javascript:kepSearch(1);"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>
         	<span class="Mbtn_reset" title="초기화"><a href="javascript:reload();"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></a></span>
<%}else{%>
         	<span class="btn_search" title="조회"><a href="javascript:kepSearch(1);"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>
         	<span class="btn_reset" title="초기화"><a href="javascript:reload();"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></a></span>
<%}%>
         </div>
            <!--조회영역-->
            <form name = "searchForm"  id="searchForm" method = "post">
            <input type="hidden" id="BUYER"  name="BUYER" value="<%=buyer%>">
            <input type="hidden" id="USERID"  name="USERID" value="<%=userid%>">
            <input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
            <input type="hidden" id="moveToBuyer"  name="moveToBuyer" value="<%=moveToBuyer%>">
            <input type="hidden" id="st_status"  name="st_status" value="<%=st_status%>">
            <div id="cont_searchA">        	
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
			<table class="cont_t_list01" >
				<caption><%=CommonLang.get("HTITLE7") %><!-- 조회 --></caption>
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
							<th><%=CommonLang.get("HTITLE220") %><!-- 요청일 --></th>
							<td colspan="5">			
							<input type="text" id="startDate"  class="input_type_text" name="startDate" value="<%=startDate%>"  style="width:10%; text-align:center;" >
							-
							<input type="text" id="endDate" class="input_type_text"  name="endDate" value="<%=endDate%>"  style="width:10%; text-align:center;" >
							<span class="btn_month"><a href="javascript:kepMonth('startDate','endDate','1')">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>  
							<span class="btn_month"><a href="javascript:kepMonth('startDate','endDate','3')">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>			
							<span class="btn_month"><a href="javascript:kepMonth('startDate','endDate','6')">6<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>
							<span class="btn_month"><a href="javascript:setCurMonth('startDate','endDate')">당월</a></span>						
                            </td>
                      </tr>
                      <tr>
							<th><%=CommonLang.get("HTITLE299") %><!-- 결재구분 --></th>
							<td>			 
				              <select name="st_gubun" id="st_gubun" style="width: 90%">
								<option value="" <%if ("".equals(st_gubun)) {%>selected<%} %>>전체</option>
								<option value="PR" <%if ("PR".equals(st_gubun)) {%>selected<%} %>>구매요청</option>
								<option value="PX" <%if ("PX".equals(st_gubun)) {%>selected<%} %>>구매발주</option>
					            </select>
                            </td>
                            <th><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --></th>
							<td>
								<input type="text" class="input_type_text" name="st_req_dept_name" id="st_req_dept_name" style="width:70%;ime-mode:active" value="<%=req_dept_name%>" READONLY>
								<input type="hidden" name="st_req_dept_code" id="st_req_dept_code" value="<%=req_dept_code%>">
								<a href="javascript:getDepartmentCode();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
								<a href="javascript:kepEraser('st_req_dept_code','st_req_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
	                       	<th><%=CommonLang.get("HTITLE216") %><!-- 요청번호 --></th>
							<td>
								<input type="text" class="input_type_text" name="st_pr_no" id="st_pr_no" style="width:87%;" value="<%=pr_no%>" onkeyup="kepToUpper('st_pr_no')" onKeyDown="kepEnter()">
							</td>
                       </tr>
                            <tr>
						    <th><%=CommonLang.get("HTITLE948") %><!-- 구매요청 제목 --></th>
							<td>		
							<input type="text" name="st_subject"  class="input_type_text" style="width:87%;ime-mode:active" value="<%=(st_subject.equals("ALL") ? "" : st_subject)%>"  onKeyDown="kepEnter()">
                             </td> 

                             <th><%=CommonLang.get("HTITLE133") %><!-- 요청자 --></th>
                             <td>
                              <input type="text" name="st_drafter"  id="st_drafter" value="<%=drafter%>" class="input_type_text" style="width:87%;ime-mode:active" onKeyDown="kepEnter()">
                             </td>
						</tr> 						
					</tbody>
				</table>
            </div>
   <div>
<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	<label for="b_no02" class="hidden">정렬개수선택</label>
<select name="onepagerow"  id="onepagerow" onchange="kepSearch(1);">
                   <option value="10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
					<option value="20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
					<option value="30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
					<option value="40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
					<option value="50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
</select></span> 
    </div>
</form>    
<br>

<form name = "contentForm" id="contentForm" method = "post">
<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />            	
                <table id="table_list" class="cont_t_list02">
                    <caption><%=CommonLang.get("HTITLE683") %><!-- 리스트 --></caption>
                    <colgroup>
                        <col width="6%" />
                        <col width="8%" />
                        <col width="30%" />
                        <col width="8%" /> 
                        <col width="8%" />
                        <col width="*" />
                        <col width="8%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE299") %><!-- 결재구분 --> </th>
                            <th scope="col"><%=CommonLang.get("HTITLE216") %><!-- 요청번호 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE133") %><!-- 요청자 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE220") %><!-- 요청일 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE304") %><!-- 제목 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE204") %><!-- 금액 --></th> 
                        </tr>                
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
                <tr bgcolor="#FFFFFF">
		            <td colspan="7" align="center" height = "50"> 
		            <span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
		            </td> 
           		</tr>
<%
     }else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%>                     
                    <tr>
                    	<td title="결재구분"><%=CommonUtil.nvl( rowData.get("EXTIF_TP_TEXT"))%></td>
                    	<td title="요청번호"><%=CommonUtil.nvl( rowData.get("KEY1"))%></td>
                    	<td title="요청부서"><%=CommonUtil.nvl( rowData.get("ORDER_DEPT"))%></td>
                    	<td title="요청자"><%=CommonUtil.nvl( rowData.get("USER_NM"))%></td>
                    	
                    	<td title="기안일시"><%=CommonUtil.nvl( rowData.get("START_DATE"))%></td>
                    	<td title="제목" class="left">
                    	<a class="hyperLink"  href="javascript:openSearchPopup('/common/approval/getBuyerCauCommonMyPagePop.do','?COMPANY=<%= CommonUtil.nvl( rowData.get("COMPANY"))%>&DOCU_NO=<%=CommonUtil.nvl( rowData.get("DOCU_NO")) %>&PASS_TP=<%=CommonUtil.nvl( rowData.get("PASS_TP")) %>&FLAG=RECV' ,'1200,700,no')">
                       <%=CommonUtil.nvl( rowData.get("DOCU_TITLE"))%>
                       </a>
                       </td>
                    	<td title="금액">
                    		<%=CommonUtil.formatNumber(rowData.get("ORDER_AMT"),true,0,3)%>
                    	</td>
                    </tr> 
<%
		} 
	}
%>                      
             </tbody>                       
  </table>
<%	if (_dataList != null && _dataList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_dataList.size() %>" >
<%	}	%>
 </form>    
<form name="processForm" id="processForm">
<input type=hidden name="PASS_KN" id="PASS_KN">  
</form>
<!--페이징-->
<p id="paging" class="paging">
<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
<span class="cl"><%=CommonLang.get("HTITLE598") %><!-- [ 총 --> <%=total_cnt %> <%=CommonLang.get("HTITLE599") %><!-- 건 ] --></span> 
</p> 
<%if(!buyer.equals("KRKORE0001")){  %>
	<!-- 버튼영역 -->
<div class="btnArea">

	<div class="fr">             
               <span class="btn_02 mr04" title="엑셀다운로드" ><a href="javascript:doAction('excelDown');"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></a></span>
     </div>     
  </div>
<%} %>
</div> 
<!--내용 종료-->	                  
<!--내용 종료-->	                 
<!--내용 종료-->	                 
</div>

<%if(!"Y".equals(moveToBuyer) ){%>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
<%} %>
  
</div>
</div>
</body> 
<script type="text/javascript">

var PASS_KN = "";

var st;
//기능함수
function doAction(str) { 
	switch (str) {
	case "search":	 //조회
		kepSearch(1);
		break;
		
	case "excelDown": // 엑셀다운로드
		document.forms.searchForm.action = "/excelBuyerCauNewPassRecvList.do";
		document.forms.searchForm.submit();
		break;
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){	

	var text = "";
    if ($("#PASS_KN").val() == 1 ){
    	text = "<%=CommonLang.get("HTITLE310") %>";		//결재
    }else{
    	text = "<%=CommonLang.get("HTITLE238") %>";		//반려
    }
    alert("<%=CommonLang.msg("MSG260") %> "+text+" <%=CommonLang.msg("MSG391") %>");	//정상적으로 처리되었습니다. 
   	 // 처리후 재조회
   	 kepSearch($("#curPage").val()); 
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {	

	//오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
	 alert("<%=CommonLang.msg("MSG163") %>  ");  
} 

function kepOnload() {
	
	<% if ("".equals(_CRUD)){%>
	kepNoSetCalender("startDate","Y"); // 초기 시작하자마 해당 ID에 달력세팅
	kepNoSetCalender("endDate","Y"); // 초기 시작하자마 해당 ID에 달력세팅
	$("#startDate").val(kepToMonthAdd('1','M'));
	<%}else{%>	
	kepNoSetCalender("startDate",""); // 초기 시작하자마 해당 ID에 달력세팅
	kepNoSetCalender("endDate",""); // 초기 시작하자마 해당 ID에 달력세팅
	<%}%>

	//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
	//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
	<% if ("Y".equals(mailOpen) && !"".equals(session_st_gw_no) && "Y".equals(userGwNoFlag)){%>	
		openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do','?COMPANY=<%=buyer%>&DOCU_NO=<%=session_st_gw_no%>&PASS_TP=1&FLAG=RECV' ,'1200,700,no');
		kepSearch(1);
	<%}%> 
	var st_appr_gbn = "<%=st_appr_gbn%>";//메인 구매요청, 구매발주 타입일 경우 자동 조회
	if(st_appr_gbn=="PR"||st_appr_gbn=="PX"){
		kepSearch(1);
	}
}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	
	if (kep_dateSearchCheck($("#startDate").val(),$("#endDate").val()) == false) return;

	if (kepGetDateDiff('startDate','endDate','D') > 184 ){
		alert("조회기간을 6개월 단위로 조회가 가능합니다.");
		return;
	}
	//document.forms.searchForm.st_check.value = ser;
	if (curPage == ""){		
	}else{
	document.forms.searchForm.curPage.value = curPage;
	}
	
	$('#searchForm').attr("action", "/buyerNewPassRecvList.do").submit();
}

/**
 * FORM 을 초기화
 */
function reload(){
	kepReload("searchForm");
	kepEraser('st_req_dept_code','st_req_dept_name');
	document.forms.searchForm.st_gubun.value = "<%=st_gubun%>";
	kepNoSetCalender("startDate","Y"); // 초기 시작하자마 해당 ID에 달력세팅
	kepNoSetCalender("endDate","Y"); // 초기 시작하자마 해당 ID에 달력세팅
	$("#startDate").val(kepToMonthAdd('1','M'));
	
// 	kepSearch(-1);
	jspTableClean("table_list","8");
}
 
function getDepartmentCode(){ 
	openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code=<%=buyer%>", "500,500,no"); 
}

function setPopupReturn(code, text) { 
	document.forms.searchForm.st_req_dept_code.value = code;
	document.forms.searchForm.st_req_dept_name.value = text; 
}

</script>
