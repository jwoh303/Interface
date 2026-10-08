<%--
**********************************************
* 메뉴 : 
* 화면 : 견적제출단가이력 
* 기능 : 견적제출단가이력
* 프로그램 ID : SU0401008
* 담당자 : 최찬규
* 착수일 : 2025-09-02
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%
@SuppressWarnings (value="unchecked")
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)  
String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");  //  (조회조건)  
String st_quotation_seq = CommonUtil.nvl((String) request.getParameter("st_quotation_seq"),"");  //  (조회조건)  
String st_revision = CommonUtil.nvl((String) request.getParameter("st_revision"),"");  //  (조회조건)  
String st_agent = CommonUtil.nvl((String) request.getParameter("st_agent"),"");  //  (조회조건)  
%>

<%@ include file="../../include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			{ Align:"Center",	SaveName:"NO",					Header:"차수",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"QUOTATION_NO",		Header:"견적번호",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"QUOTATION_SEQ",		Header:"순번",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"STOA_LIST_PRICE",		Header:"견적제출단가",			Type:"Float",		Width:100,	Edit:false,	EditLen:100, 	Hidden:false, Format:"${priceFormat}"}
			,{ Align:"Center",	SaveName:"STOA_DATE",			Header:"견적제출일",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}							
			,{ Align:"Center",	SaveName:"STOA_REMARK",			Header:"비고",				Type:"Text",		Width:190,	Edit:false,	EditLen:100,	Hidden:false}
			
	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet.SetTheme("DB", "DeepBlue");
	
	doAction('search');
}

// 기능함수
function doAction(str) {
	

	switch (str) {
		case "search":	 // 조회
			kepSearch(document.searchCondition, mySheet, "/mprq/getSellerMpRqUnitPriceHistoryPop_v2.do" , pagingMode);
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
</head>
<body onload="kep_onload_view();">
<form name="searchCondition" id="searchCondition" method=post >
	<input type="hidden" name="s_SAVENAME" />
	<input type="hidden" name="st_buyer" id="st_buyer" size=20 value="<%=st_buyer%>" >
	<input type="hidden" name="st_quotation_no" id="st_quotation_no" value="<%=st_quotation_no%>" >
	<input type="hidden" name="st_quotation_seq" id="st_quotation_seq" value="<%=st_quotation_seq%>" >
	<input type="hidden" name="st_revision" id="st_revision" value="<%=st_revision%>" >
	<input type="hidden" name="st_agent" id="st_agent" value="<%=st_agent%>" >
	
<div class="wrapPopup"  >
  <div class="PopupTit">견적제출 단가 이력<span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  	<div  style="height:200px; width: 780px;">
        	<script type="text/javascript">
				createIBSheet("mySheet", "100%", "100%");
			</script>
		</div>
  <div class="h30"></div>
  <div class="PopupListBtnBox_Center">
    <button class="ButPrimary_large" onclick="javascript:parent.closePop();">확인</button>
  </div>  
</div><!-- warp 끝-->

</form> 
</body>
</html>
