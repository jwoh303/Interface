<%--
**********************************************
* 메뉴 : 입고관리 > 입고집계표 > 상세팝업
* 화면 : 부서별 입고 상세
* 기능 : 
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-08-13
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
</head>

<%
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList  = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	
	String p_buyer = CommonUtil.nvl((String)request.getParameter("buyer"));
	String p_req_dept = CommonUtil.nvl((String)request.getParameter("req_dept"));
	String p_from_date = CommonUtil.nvl((String)request.getParameter("fromDate"));
	String p_to_date = CommonUtil.nvl((String)request.getParameter("toDate"));
	String p_closing_yn = CommonUtil.nvl((String)request.getParameter("closing_yn"));
%>

<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1funcReload = "javascript:thisPopReload(); return false;";
var but1width = "120px";

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

//최초 화면 함수 
function kep_onload_view(){
// 	var sum_price = document.forms.buyerWmGrWarehousingDetailPop.display_item_amt_sum.value;
//     document.forms.buyerWmGrWarehousingDetailPop.s_display_item_amt_sum.value = kepCommaNum(sum_price);
    
//     var tot_cnt = document.forms.buyerWmGrWarehousingDetailPop.total_cnt.value;
//     document.forms.buyerWmGrWarehousingDetailPop.st_total_cnt.value = kepCommaNum(tot_cnt);
    
    var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
		 {Align:"Center",	SaveName:"PX_NO",				Header:"<%=CommonLang.get("HTITLE186") %>",		Type:"Text",	Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*주문번호*/
		,{Align:"Center",		SaveName:"PO_NO",		Header:"<%=CommonLang.get("HTITLE203")%>",		Type:"Text",	Width:100,	Edit:false,	EditLen:20,		Hidden:false}/*발주번호*/
		,{Align:"Center",	SaveName:"PO_CREATE_DATE",		Header:"<%=CommonLang.get("HTITLE208")%>",		Type:"Date",	Width:100,	Edit:false,	EditLen:200,	Hidden:false, Format:"yyyy-MM-dd"}/*발주일*/
		,{Align:"Center",		SaveName:"GR_NO",			Header:"<%=CommonLang.get("HTITLE286")%>",		Type:"Text",	Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*입고번호*/
		,{Align:"Center",	SaveName:"GR_DATE",		Header:"<%=CommonLang.get("HTITLE283")%>",		Type:"Date",	Width:100,	Edit:false,	EditLen:100,	Hidden:false, Format:"yyyy-MM-dd"}/*입고일*/
		,{Align:"Left",		SaveName:"BUYER_ITEM_NO",	Header:"<%=CommonLang.get("HTITLE12")%>",		Type:"Text",	Width:100,	Edit:false,	EditLen:30,		Hidden:false}/*품목코드*/
		,{Align:"Left",	SaveName:"REF_PR_NO",			Header:"<%=CommonLang.get("HTITLE18")%>",		Type:"Text",	Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*관리번호*/
		,{Align:"Left",	SaveName:"DESCRIPTION",		Header:"<%=CommonLang.get("HTITLE565")%>",		Type:"Text",	Width:120,	Edit:false,	EditLen:100,	Hidden:false}/*품명*/
		,{Align:"Left",	SaveName:"SPECIFICATION",			Header:"<%=CommonLang.get("HTITLE14")%>",		Type:"Text",	Width:150,	Edit:false,	EditLen:100,	Hidden:false}/*규격*/
		,{Align:"Center",		SaveName:"UNIT_MEASURE",	Header:"<%=CommonLang.get("HTITLE52")%>",		Type:"Text",	Width:80,	Edit:false,	EditLen:30,		Hidden:false}/*단위*/
		,{Align:"Right",	SaveName:"UNIT_PRICE",			Header:"<%=CommonLang.get("HTITLE174")%>",		Type:"Float",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,Format:"${priceFormat}"}/*단가*/
		,{Align:"Right",	SaveName:"PO_ITEM_QTY",			Header:"<%=CommonLang.get("HTITLE217")%>",		Type:"Float",	Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*발주수량*/
		,{Align:"Right",	SaveName:"GR_ITEM_QTY",			Header:"<%=CommonLang.get("HTITLE211")%>",		Type:"Float",	Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*입고수량*/
		,{Align:"Right",	SaveName:"ITEM_AMT",		Header:"<%=CommonLang.get("HTITLE287")%>",		Type:"Float",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,Format:"${priceFormat}"}/*입고금액*/
		,{Align:"Center",		SaveName:"ADD_USER_NAME",			Header:"<%=CommonLang.get("HTITLE133")%>",		Type:"Text",	Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*요청자*/
		,{Align:"Center",	SaveName:"PO_CREATOR",			Header:"<%=CommonLang.get("HTITLE187")%>",		Type:"Text",	Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*발주자*/
		,{Align:"Left",	SaveName:"REQ_DEPT_NAME",			Header:"<%=CommonLang.get("HTITLE293")%>",		Type:"Text",	Width:120,	Edit:false,	EditLen:100,	Hidden:false}/*요청부서명*/
		,{Align:"Left",	SaveName:"AGENT_NAME",			Header:"<%=CommonLang.get("HTITLE567")%>",		Type:"Float",	Width:120,	Edit:false,	EditLen:100,	Hidden:false}/*협력사명*/
		,{Align:"Center",	SaveName:"ACCOUNT_TYPE",			Header:"<%=CommonLang.get("HTITLE386")%>",		Type:"Text",	Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*계정코드*/
		,{Align:"Left",		SaveName:"ACCOUNT_NAME",	Header:"<%=CommonLang.get("HTITLE267")%>",		Type:"Text",	Width:120,	Edit:false,	EditLen:30,		Hidden:false}/*계정명*/
		,{Align:"Center",	SaveName:"BUDGET_DEPT",				Header:"<%=CommonLang.get("HTITLE568")%>",		Type:"Float",	Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*예산부서코드*/
		,{Align:"Left",		SaveName:"BUDGET_DEPT_NAME",	Header:"<%=CommonLang.get("HTITLE420")%>",		Type:"Text",	Width:120,	Edit:false,	EditLen:30,		Hidden:false}/*예산부서명*/
		
];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	mySheet.SetHighlightAfterSort(2);
	mySheet.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetTheme("DB", "DeepBlue");
	doAction("search");
}
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		alert(msg);
	}
}
//기능함수
function doAction(str) {
	switch (str) {
	
	case "search":
		kepSearch_v2(document.buyerWmGrWarehousingDetailPop, mySheet, "/wmgr/getBuyerWmGrWarehousingPopList_v2.do", pagingMode);
		break;
	case "excelDown": // 엑셀다운로드
		document.forms.buyerWmGrWarehousingDetailPop.action = "/wmgr/excelBuyerWmGrWarehousingDetailPop.do";
		document.forms.buyerWmGrWarehousingDetailPop.submit();
		break;
	}
}

</script> 
<body onload="kep_onload_view()">
<form name="buyerWmGrWarehousingDetailPop" id="buyerWmGrWarehousingDetailPop" method=post >
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
<input type="hidden" name="buyer" id="buyer" value="<%=p_buyer%>">
<input type="hidden" name="req_dept" id="req_dept" value="<%=p_req_dept%>">
<input type="hidden" name="fromDate" id=""fromDate"" value="<%=p_from_date%>">
<input type="hidden" name="toDate" id="toDate" value="<%=p_to_date%>">
<input type="hidden" name="closing_yn" id="closing_yn" value="<%=p_closing_yn%>">
<input type="hidden" name="s_SAVENAME" />

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE713") %><!-- 부서별 입고 상세 --><span><a href="javascript:self.close();" class="closePopup"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="ScrollBox mt20" style="height:332px">
  	<script type="text/javascript">
		createIBSheet("mySheet", "100%", "100%");
  	</script>
  </div>
  <div class="ArraySub mt10 mb10" style="width:150px;">
        <div class="buttonLeft">
          <button class="But_ExcelDown40"  onclick="javascript:doAction('excelDown'); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
        </div>
        <div class="buttonRight"><span class="allprice" id="tot_amt"></span></div>
	  </div>
  <div class="PagingCenter mt10" id="pageindex"></div>
</div><!-- wrapPopup 끝--> 
</form> 
</body>
</html>
