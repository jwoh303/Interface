<%--
**********************************************
* 메뉴 : 
* 화면 : 거래 고객사 선택
* 기능 : 
* 프로그램 ID : 
* 담당자 :  최찬규
* 착수일 : 2025-10-22
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
<%
	@SuppressWarnings (value="unchecked")
	
	String comCode = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  //  (조회조건)
	String buyerName = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");  //  (조회조건)
	String invoice_flag = CommonUtil.nvl((String) request.getParameter("invoice_flag"),"");  //  (조회조건)
%>

<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	$("#st_buyer_name").focus();
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			{ Align:"Center",	SaveName:"BUYER",				Header:"고객사코드",				Type:"Text",		Width:150,Cursor:"Pointer",	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"COM_NAME_LOC",		Header:"고객사명",				Type:"Text",		Cursor:"Pointer",Width:250,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"KEP_USER_NAME",		Header:"KeP담당자",			Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"KEP_USER_PHONE",		Header:"연락처",				Type:"Text",		Width:120,	Edit:false,	EditLen:100, 	Hidden:true}
			,{ Align:"Center",	SaveName:"KEP_USER_EMAIL",		Header:"이메일",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}							
			
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
	
	var buyer = mySheet.GetCellValue(Row,"BUYER");
	var com_name_loc = mySheet.GetCellValue(Row,"COM_NAME_LOC");
	
	if(column == "BUYER" || column == "COM_NAME_LOC"){ //협력사 비고
		parent.setBuyerChoiceReturn(buyer, com_name_loc);
		parent.closePop();
	}
	
	return;
}
//기능함수
function doAction(str) {

	switch (str) {
		case "search":	 // 조회
			kepSearch(document.commonMpIvTranBuyerChoicePop, mySheet, "/mpiv/getCommonMpIvTranBuyerChoicePopList.do" , pagingMode);
// 			$('#commonMpIvTranBuyerChoicePop').attr("action", "/mpiv/getCommonMpIvTranBuyerChoicePop.do").submit();
			break;
	
	}
}

function doPop(str, value1) {
	switch (str) {
		case "agent": // 고객사
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
			break;
	}
}

function setReturn(buyer, com_name){
	parent.setBuyerChoiceReturn(buyer, com_name);
	parent.closePop();
}


</script> 
 
<body onload="kep_onload_view()">
<form name="commonMpIvTranBuyerChoicePop" id="commonMpIvTranBuyerChoicePop" method="post">
<input type="hidden" name="s_SAVENAME" />
	<input type="hidden" name="st_com_code" value="<%=comCode%>" />
	<input type="hidden" name="invoice_flag" value="<%=invoice_flag%>" />
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup">
  <div class="PopupTit">고객사 조회<span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
<!--   <div class="Importance_Popup"  style="width:380px"><img src="/resources/imgs/Icon_Importance01.png" /> 거래중인 고객사를 확인하여 선택할 수 있습니다. </div> -->
  <div class="h10"  style="width:380px"></div> 
  <div class="SearchPopupInputBox"  style="width:400px">
    <div class="SearchPopupInput" onSubmit=" "  style="width:400px">
      <input type="text" placeholder="고객사명 " id="st_buyer_name" name="st_buyer_name" style=" width:95%; " onKeyDown="kepEnter_v2()">
      <button type="button" onclick="javascript:doAction('search'); return false;">고객사검색버튼</button>
    </div>    
  </div>
  <div class="PopTableThCTdL" style="width:405px; height: 300px;">
  	<script type="text/javascript">
		createIBSheet("mySheet", "100%", "100%");
	</script>
  </div>
  <!--div class="h30"></div-->
  <!--div class="PopupListBtnBox_Center">
    <button class="ButQuaternary_large" >취소</button>
    <button class="ButPrimary_large" >확인</button>
  </div-->  
</div><!-- warp 끝-->
 
</form> 
</body>
</html>
