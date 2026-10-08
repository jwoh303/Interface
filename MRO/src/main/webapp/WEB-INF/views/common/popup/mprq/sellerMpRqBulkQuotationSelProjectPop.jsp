<%--
**********************************************
* 메뉴 : 
* 화면 : 프로젝트 견적 프로젝트 조회 팝업
* 기능 : 
* 프로그램 ID : 
* 담당자 :  
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
</head>

<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			{ Align:"Center",	SaveName:"BURQ_NO",				Header:"프로젝트 코드",				Type:"Text",		Width:210,Cursor:"Pointer",	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"PROJECT_NAME",		Header:"프로젝트명",				Type:"Text",		Width:210,Cursor:"Pointer",	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"CNT",					Header:"견적요청건수",				Type:"Int",			Width:100,Cursor:"Pointer",	Edit:false,	EditLen:100, 	Hidden:false}
			
	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet.SetTheme("DB", "DeepBlue");
	
	doAction('search');
}

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		alert(msg);
	}
}
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var burq_no = mySheet.GetCellValue(Row,"BURQ_NO");
	var project_name = mySheet.GetCellValue(Row,"PROJECT_NAME");
	
	if(column == "BURQ_NO" || column == "PROJECT_NAME" || column == "CNT"){
		parent.setPopupReturn(burq_no, project_name);
		parent.closePop();
	}
	
	return;
}
//기능함수
function doAction(str) {

	switch (str) {
		case "search":	 // 조회
			kepSearch(document.sellerMpRqBulkQuotationSelProjectPop, mySheet, "/mprq/getSellerProjectList.do" , pagingMode);
			break;
	
	}
}



</script> 
 
<body onload="kep_onload_view()">
<form name="sellerMpRqBulkQuotationSelProjectPop" id="sellerMpRqBulkQuotationSelProjectPop" method="post">
<input type="hidden" name="s_SAVENAME" />
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup">
  <div class="PopupTit">프로젝트 선택<span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  <div class="h10"  style="width:380px"></div> 
  <div class="PopTableThCTdL" style="width:530px; height: 250px;">
  	<script type="text/javascript">
		createIBSheet("mySheet", "100%", "100%");
	</script>
  </div>
</div><!-- warp 끝-->
 
</form> 
</body>
</html>