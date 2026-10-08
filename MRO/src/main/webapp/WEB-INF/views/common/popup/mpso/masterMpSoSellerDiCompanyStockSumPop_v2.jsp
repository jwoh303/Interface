<%--
**********************************************
* 메뉴 : 주문관리 > 협력사 실적등록 조회 > 업체별 재고금액 집계 팝업
* 화면 : 업체별 재고금액 현황(고객사 / 협력사)
* 프로그램 ID : 
* 담당자 : 최찬규
* 작성일 : 2026-10-06
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf" %>
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>   
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/js/common.js"></script>
<style type="text/css">
<!--
	table.ui-datepicker-calendar { display:none; }
-->
</style>
<%
	// 파라미터 수신 (B: 고객사 기준, S: 협력사 기준)
	String st_business_cond = CommonUtil.nvl(request.getParameter("BUSINESS_COND"), "B");
	String st_from_date     = CommonUtil.nvl(request.getParameter("st_from_date"), "");
	String st_to_date       = CommonUtil.nvl(request.getParameter("st_to_date"), "");
	String com_code         = CommonUtil.nvl(request.getParameter("com_code"), "");
	String com_name         = CommonUtil.nvl(request.getParameter("com_name"), "");
	String st_buyer_code    = CommonUtil.nvl(request.getParameter("st_buyer_code"), "");
	String st_buyer_name    = CommonUtil.nvl(request.getParameter("st_buyer_name"), "");
	String st_agent_code    = CommonUtil.nvl(request.getParameter("st_agent_code"), "");
	String st_agent_name    = CommonUtil.nvl(request.getParameter("st_agent_name"), "");

	if ("B".equals(st_business_cond) && "".equals(st_buyer_code) && !"".equals(com_code)) {
		st_buyer_code = com_code;
		st_buyer_name = com_name;
	} else if ("S".equals(st_business_cond) && "".equals(st_agent_code) && !"".equals(com_code)) {
		st_agent_code = com_code;
		st_agent_name = com_name;
	}

	String popTitle = "S".equals(st_business_cond) ? "협력사별 재고금액 현황" : "고객사별 재고금액 현황";
	
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤 (페이징 미사용)
var popupSel = "";

// 시트 초기화 함수
function kep_onload_view() {
	var businessCond = $("#st_business_cond").val();
	var codeHeader = (businessCond == "S") ? "협력사코드" : "고객사코드";
	var nameHeader = (businessCond == "S") ? "협력사명" : "고객사명";

	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center", Width:60,  Edit:false, Hidden:true,  Type:"Status", Header:"상태",      SaveName:"sStatus" }
		,{ Align:"Center", Width:110, Edit:false, Hidden:false, Type:"Text",   Header:codeHeader,  SaveName:"COM_CODE" }
		,{ Align:"Left",   Width:180, Edit:false, Hidden:false, Type:"Text",   Header:nameHeader,  SaveName:"COM_NAME_LOC" }
		,{ Align:"Right",  Width:120, Edit:false, Hidden:false, Type:"Float",  Header:"총재고금액", SaveName:"TOT_STOCK_AMT",   Format:"${priceFormat}" }
		,{ Align:"Right",  Width:100, Edit:false, Hidden:false, Type:"Float",  Header:"1M",        SaveName:"STOCK_AMT_1M",     Format:"${priceFormat}" }
		,{ Align:"Right",  Width:100, Edit:false, Hidden:false, Type:"Float",  Header:"2M",        SaveName:"STOCK_AMT_2M",     Format:"${priceFormat}" }
		,{ Align:"Right",  Width:100, Edit:false, Hidden:false, Type:"Float",  Header:"3M",        SaveName:"STOCK_AMT_3M",     Format:"${priceFormat}" }
		,{ Align:"Right",  Width:100, Edit:false, Hidden:false, Type:"Float",  Header:"4M",        SaveName:"STOCK_AMT_4M",     Format:"${priceFormat}" }
		,{ Align:"Right",  Width:100, Edit:false, Hidden:false, Type:"Float",  Header:"5M",        SaveName:"STOCK_AMT_5M",     Format:"${priceFormat}" }
		,{ Align:"Right",  Width:100, Edit:false, Hidden:false, Type:"Float",  Header:"6M",        SaveName:"STOCK_AMT_6M",     Format:"${priceFormat}" }
		,{ Align:"Right",  Width:110, Edit:false, Hidden:false, Type:"Float",  Header:"7M이전",    SaveName:"STOCK_AMT_7M_BF",  Format:"${priceFormat}" }
	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);

	kepSetCalenderYearMonth("st_from_date");
	kepSetCalenderYearMonth("st_to_date");
	
	var pFromDate = "<%=st_from_date%>";
	var pToDate = "<%=st_to_date%>";
	
	if(pFromDate != "" && pToDate != ""){
		$("#st_from_date").val(pFromDate);
		$("#st_to_date").val(pToDate);
	}else{
		kepYearMonth('st_from_date', 'st_to_date', 0);
	}
	

	// 자동 조회
// 	doAction('search');
}

// 동작 처리 함수
function doAction(str) {
	switch (str) {
		case "search":
			if ($("#st_to_date").val() == "") {
				alert("기준일자(실적등록월)를 입력해 주세요.");
				return;
			}
			kepSearch(document.searchCondition, mySheet, "/mpso/getMasterMpSoSellerDiStockSumPopList_v2.do", pagingMode);
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case "excelDown":
			if(mySheet.RowCount() == 0){
				alert("조회된 데이터가 없습니다.");
				return;
			}
			
			mySheet.SetWaitImageVisible(true);
			
			var downRow = "|0";
			for(var i = 1; i <= mySheet.RowCount(); i++) {
				downRow += "|"+i;
			}
			
			var downCol = "";
			for(var i=0; i<= mySheet.LastCol(); i++){
				if(!mySheet.GetColHidden(i) && mySheet.ColSaveName(i) !="SELECTED" && mySheet.GetCellProperty(1, i, "Type") != "Image"){
					downCol += "|"+i;
				}
			}
			
			if(downRow == "|0"){
				downRow = "";
			}
			var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
			
			var fileName = "<%=popTitle%>"+"_";
			
			var param = {FileName:fileName+nowTime, SheetName:fileName, DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
			mySheet.Down2Excel(param);
			break;
	}
}

// 검색 완료 후 콜백
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if (!checkedSession(stCode)) { return; }
	if (msg != "") {
		alert(msg);
	}
}

// 팝업 호출
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "buyer_single": // 고객사 검색 팝업
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
		case "agent": // 협력사 검색 팝업
			openSearchPopup('/common/icomcmpyPop.do', "?open=Y&BUSINESS_COND=S", "500,466,no");
			break;
	}
}

// 팝업 콜백 함수
function setPopupReturn(value1, value2) {
	if (popupSel == "buyer_single") {
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	} else if (popupSel == "agent") {
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
	}
	popupSel = "";
}

function kepEnter() {
	if (event.keyCode == 13) {
		doAction('search');
	}
}
</script>
</head>
<body onload="kep_onload_view();">
<form name="searchCondition" id="searchCondition" method="post" onsubmit="return false;">
	<!-- IBSheet 공통 파라미터 -->
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag" name="pageflag" value="1">

	<input type="hidden" id="st_business_cond" name="st_business_cond" value="<%=st_business_cond%>">

	<div id="popWrapper" style="width:100%; min-width:920px;">
		<div id="popHeader">
			<h1 class="title"><%=popTitle%></h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기" /></a></p>
		</div>

		<div id="popContainer">
			<!--버튼영역-->
			<div id="searchBtnA02">
				<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
				<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
			</div>

			<!--조회영역-->
			<div id="cont_searchA">
				<table class="cont_t_list01" style="width:100%;">
					<caption>조회조건</caption>
					<colgroup>
						<col width="12%" />
						<col width="38%" />
						<col width="12%" />
						<col width="38%" />
					</colgroup>
					<tbody>
						<tr>
							<th>실적등록월</th>
							<td>
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readonly style="width:75px; text-align:center;" value="<%=st_from_date%>">
								~
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readonly style="width:75px; text-align:center;" value="<%=st_to_date%>">
								<span class="btn_month"><a href="javascript:kepYearMonth('st_from_date','st_to_date',-1)">-1개월</a></span>
								<span class="btn_month"><a href="javascript:kepYearMonth('st_from_date','st_to_date',0)">당월</a></span>
							</td>
							<%if(st_business_cond.equals("B")) {%>
							<th>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:65%;" value="<%=st_buyer_name%>" readonly>
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="<%=st_buyer_code%>">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif" alt="검색"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif" alt="지우개"></a>
							</td>
							<%}else{ %>
							<th>협력사</th>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:65%;" value="<%=st_agent_name%>" readonly>
								<input type="hidden" name="st_agent_code" id="st_agent_code" value="<%=st_agent_code%>">
								<a href="javascript:doPop('agent');"><img src="/resources/images/btn_search03.gif" alt="검색"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif" alt="지우개"></a>
							</td>
							<%} %>
						</tr>
					</tbody>
				</table>
			</div>

			<!--그리드 영역-->
			<div class="ib_product" style="border-top:2px solid #3c639c; margin-top:10px;">
				<script type="text/javascript">
					createIBSheet("mySheet", "100%", "360px");
				</script>
			</div>

			<!--하단 버튼영역-->
			<div class="btnArea" style="margin-top:10px;">
				<span class="fl">
					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
				</span>
			</div>
		</div>
	</div>
</form>
</body>
</html>
