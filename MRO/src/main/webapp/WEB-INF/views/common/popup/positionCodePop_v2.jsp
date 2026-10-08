<%--
**********************************************
* 메뉴 : 직급 팝업
* 화면 : 직급 팝업
* 기능 : 직급 팝업
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-03-12
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
String com_code = CommonUtil.nvl((String) request.getParameter("com_code"),"");  //  (조회조건) 
String type = CommonUtil.nvl((String) request.getParameter("type"),"");  //  (조회조건) 
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			{ Align:"Center",	SaveName:"CODE",		Header:"<%=CommonLang.get("HTITLE376") %>",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*직급코드*/
			,{ Align:"Left",	SaveName:"TEXT1",			Header:"<%=CommonLang.get("HTITLE377") %>",				Type:"Text",		Width:250,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*직급명*/
	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
	
	mySheet.SetTheme("DB", "DeepBlue");
	
	doAction('search');
}

// 기능함수
function doAction(str) {
	

	switch (str) {
		case "search":	 // 조회
			kepSearch(document.positionCodePop, mySheet, "/common/getPositionCodePop_v2.do" , pagingMode);
			break;
	}
}

// 조회 후처리
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
	
	var value1 = mySheet.GetCellValue(Row,"CODE");
	var value2 = mySheet.GetCellValue(Row,"TEXT1");
	if(column == "TEXT1" || column == "CODE"){
		opener.setPopupReturn(value1,value2);
		this.close();
	}
}
</script>

<body onload="kep_onload_view();">
	 <form name=positionCodePop id=positionCodePop method=post >
	 <input type="hidden" name="s_SAVENAME" />
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="positionCodePop">
	 <input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
	 <input type="hidden" name="type" id="type"  value="<%=type%>"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE476") %><!-- 직급 --><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  	<div style="height:350px; width: 450px;">
        	<script type="text/javascript">
				createIBSheet("mySheet", "100%", "100%");
			</script>
		</div>
</div><!-- warp 끝-->
</form> 
</body>
</html>
