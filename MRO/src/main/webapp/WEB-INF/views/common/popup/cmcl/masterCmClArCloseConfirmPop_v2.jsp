<%--
**********************************************
* 메뉴 : 마감관리 > 마감현황 > 확정마감 > 월별 마감확정내역(매출) > 제출확인 팝업
* 화면 : 제출 확인 팝업
* 기능 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ page import="java.text.SimpleDateFormat"%> 
<%@ page import="java.util.Date"%> 
<%@ page import="java.util.Locale"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>

<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("_data"); // 조회된 결과 
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_user_id = "";
if (sessionInfo != null){
	st_user_id = sessionInfo.getUserId();
}
String st_from_date = request.getParameter("st_from_date");
String st_type = request.getParameter("st_type");


%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [					 
			 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus"}			
			,{ Align:"Center",	Width:140,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"사업팀명",		SaveName:"KEP_DEPT_NAME"}
			
		<% if(st_type.equals("AR")) { %>
			,{ Align:"Center",	Width:80,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"담당자명",		SaveName:"KEP_USER_NAME"}
			,{ Align:"Left",	Width:220,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"고객사",		SaveName:"BUYER_NAME"}
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:170,	Hidden:true,	Type:"Text",		Header:"고객사코드",		SaveName:"BUYER"}
			,{ Align:"Center",	Width:80,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"발행유형",		SaveName:"CLOSE_TYPE"}
			,{ Align:"Center",	Width:110,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"추가제출일시",		SaveName:"CHANGE_DATE"}
		<%} else {%>
			,{ Align:"Center",	Width:120,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"담당자명",		SaveName:"KEP_USER_NAME"}
			,{ Align:"Left",	Width:220,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"협력사",		SaveName:"AGENT_NAME"}
			,{ Align:"Left",	Width:220,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"고객사",		SaveName:"BUYER_NAME"}
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:170,	Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:170,	Hidden:true,	Type:"Text",		Header:"고객사코드",		SaveName:"BUYER"}
			,{ Align:"Center",	Width:110,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"추가제출일시",		SaveName:"CHANGE_DATE"}
		<%}%>
			
			
			
					
					
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	kepSearch(document.searchCondition, mySheet, "/cmcl/getMasterCmClArCloseConfirmPop_v2.do", pagingMode );
	
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	

	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/cmcl/getMasterCmClArCloseConfirmPop_v2.do" , pagingMode );
			break;
	}
}


//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}


function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
}



</script>
</head>
<body onload="kep_onload_view()">
<form name = "searchCondition" method = "post" onsubmit="return false" >
<input type="hidden" name="s_SAVENAME">
<input type="hidden" id="st_from_date" name="st_from_date" value="<%=st_from_date%>">
<input type="hidden" id="st_type" name="st_type" value="<%=st_type%>">

	<div id="popWrapper" style="height:650px;">
    	<div id="popHeader">
        	<h1 class="title">마감제출여부 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"> 
            <!--조회영역-->
            <h3>마감 미제출자</h3>            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "750px");
				</script>
			</div>      
          
    </div>        
</div>   
</form>              
</body>
</html>
