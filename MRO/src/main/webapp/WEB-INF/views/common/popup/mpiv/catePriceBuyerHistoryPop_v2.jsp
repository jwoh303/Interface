<%--
**********************************************
* 메뉴 :  단가정보팝업
* 화면 : 단가정보팝업
* 기능 : 단가정보팝업
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-02-26
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
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   
 
String byca_comorg_code = CommonUtil.nvl((String) request.getParameter("st_byca_comorg_code"),"");  //  (조회조건)  
String buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  //  (조회조건) 
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건) 
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			{ Align:"Center",	SaveName:"BELOW_COMORG_CODE",	Header:"<%=CommonLang.get("HTITLE1109") %>",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*구매사코드*/
			,{ Align:"Center",	SaveName:"BELOW_COMORG_NM",		Header:"<%=CommonLang.get("HTITLE1110") %>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*구매사명*/
			,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"<%=CommonLang.get("HTITLE12") %>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}/*품목코드*/
			,{ Align:"Center",	SaveName:"MAKER_NAME",			Header:"<%=CommonLang.get("HTITLE15") %>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*제조사*/
			,{ Align:"Center",	SaveName:"CONTRACT_NO",			Header:"<%=CommonLang.get("HTITLE1107")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100, 	Hidden:false}/*계약번호*/
			,{ Align:"Center",	SaveName:"CONTRACT_SEQ",		Header:"<%=CommonLang.get("HTITLE1108") %>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*계약항번*/					
			,{ Align:"Center",	SaveName:"UNIT_PRICE",			Header:"<%=CommonLang.get("HTITLE174") %>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*단가*/
			
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
			kepSearch(document.catePriceHistoryPop, mySheet, "/common/commonFolderList_v2.do" , pagingMode);
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
</script>
<body onload="kep_onload_view();">
	 <form name=catePriceHistoryPop id=catePriceHistoryPop method=post >
	 <input type="hidden" name="s_SAVENAME" />
	 <input type="hidden" name="folder" id="folder"  value="mpiv"> 
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="catePriceBuyerHistoryPop"> 
	 <input type="hidden" name="byca_comorg_code" id="byca_comorg_code"  value="<%=byca_comorg_code%>"> 
	 <input type="hidden" name="buyer_item_no" id="buyer_item_no"  value="<%=buyer_item_no%>">
	  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE1113") %><!-- 단가정보 --><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  	<div  style="height:240px; width: 700px;">
        	<script type="text/javascript">
				createIBSheet("mySheet", "100%", "100%");
			</script>
		</div>
</div><!-- warp 끝-->
</form> 
</body>
</html>
