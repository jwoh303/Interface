<%--
**********************************************
* 메뉴 : I/F 관리>오류현황>오류현황 발주
* 화면 : 협력사 변경 팝업
* 기능 : 
* 프로그램 ID : PG_11_M_002_05
* 담당자 : 최명진 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	String buyer = request.getParameter("BUYER");
	String buyerItemNo = request.getParameter("BUYER_ITEM_NO");
	String purchaserUserDept = request.getParameter("PURCHASER_USER_DEPT");
	String byitComorgCode = request.getParameter("BYIT_COMORG_CODE");
	String comorgLevel = request.getParameter("COMORG_LEVEL");
	String gubun = request.getParameter("GUBUN");
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태",			SaveName:"sStatus"}
		,{ Align:"Center",	Width:40,		Edit:true,	EditLen:30,	Hidden:false,	Type:"Radio",		Header:"선택",			SaveName:"SELECTED"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",		Header:"품목코드",		SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",		Header:"품목명",			SaveName:"DESCRIPTION"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",		Header:"규격",			SaveName:"SPECIFICATION"}
		,{ Align:"Center",	Width:70,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",		Header:"유형",			SaveName:"PROCESS_TYPE"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",		Header:"협력사코드",	SaveName:"AGENT"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",		Header:"계약서번호",	SaveName:"CONTRACT_NO"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",		Header:"계약서순번",	SaveName:"CONTRACT_SEQ"}
		,{ Align:"Center",	Width:60,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",		Header:"단위",			SaveName:"UNIT_MEASURE"}
		,{ Align:"Right",	Width:90,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Float",		Header:"단가",			SaveName:"TARGET_PRICE"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",		Header:"물류관련협력사",		SaveName:"ORIGIN_AGENT"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",		Header:"적용구매사",	SaveName:"BELOW_COMORG_NAME"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	doAction("search");
}

var st;
var mt;

function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {
	st = new Date();
	
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpIfOrderStatusPop.do", pagingMode);
			break;
	}

}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	
	if ( mySheet.RowCount() <= 0 ) return;
	
	// 한 건 일때 자동 선택 처리
	if ( mySheet.RowCount() == 1 ) {
		mySheet.SetCellValue(1, "SELECTED", 1);
	}
	
	if ( msg != "" ) {
		alert(msg);
	}
}

// 확인
function kepConfirm()
{
	if ( mySheet.RowCount() > 0 ) {
		var selectedRow= mySheet.FindCheckedRow("SELECTED");
		
		if ( selectedRow.length == 0 ) {
			alert("협력사를 선택하여 주십시요.");
			return;
		}
		
		var value1 = mySheet.GetCellValue(selectedRow, "AGENT");
		var value2 = mySheet.GetCellValue(selectedRow, "AGENT_NAME");
		var value3 = mySheet.GetCellValue(selectedRow, "CONTRACT_NO");
		var value4 = mySheet.GetCellValue(selectedRow, "CONTRACT_SEQ");
		var value5 = mySheet.GetCellValue(selectedRow, "TARGET_PRICE");
		var value6 = mySheet.GetCellValue(selectedRow, "PROCESS_TYPE");
		var value7 = mySheet.GetCellValue(selectedRow, "ORIGIN_AGENT");
		var value8 = mySheet.GetCellValue(selectedRow, "TARGET_PRICE");

		var value9 =  "Y";
		
		opener.setPopupReturn(value1, value2, value3, value4, value5, value6, value7, value8, value9);
	}
	
	
	this.close();
}
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=buyer%>">
	<input type="hidden" id="st_buyer_item_no"  name="st_buyer_item_no" value="<%=buyerItemNo%>">
	<input type="hidden" id="st_user_dept"  name="st_user_dept" value="<%=purchaserUserDept%>">
	<input type="hidden" id="st_byca_comorg_code"  name="st_byca_comorg_code" value="<%=byitComorgCode%>">
	<input type="hidden" id="st_byca_comorg_level"  name="st_byca_comorg_level" value="<%=comorgLevel%>">
	<input type="hidden" id="st_gubun"  name="st_gubun" value="<%=gubun%>">
	
	<div id="popWrapper" style="height:350px;">
    	<div id="popHeader">
        	<h1 class="title">협력사 선택</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           <div class="contArea" style="height:270px;" > 
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "225px");
				</script>
			</div>
			
			
        <!--버튼영역-->
        <div class="btnArea mt10">
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:kepConfirm()">확인</a></span>
			</span>
       </div>
       </div>
        </div>
    </div>
</form> 
</body>
</html>
