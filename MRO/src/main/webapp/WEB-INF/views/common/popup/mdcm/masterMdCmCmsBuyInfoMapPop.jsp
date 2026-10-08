<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>구매정보 조회 및 관리 > 고객사 매핑변경 양식 업로드 시 팝업
* 화면 : (팝업) 일괄 업로드 **결과 확인** (고객사 매핑변경)
* 기능 : 양식 다운로드/업로드는 **목록 화면(masterMdCmCmsBuyInfoList) 하단 바**가 맡는다.
*        이 팝업은 목록이 엑셀을 파싱한 뒤에만 열리며, 결과 확인만 한다.
*        - 목록이 파싱해 둔 행(`opener.mdcmMapRows`)을 받아 → 현재 매핑·변경 대상 서버조회 → 검증 → 결과 표시
*        - 유형선택조회(타일 탭) + 결과/오류항목/오류사유 + 전체·오류 건 다운로드
*        - [확인] : 오류를 뺀 정상 건만 이관한다
*        ★ 고객사지정여부 Y + 협력사 불일치는 오류로 잡는다 — 화면 매핑이관(s33)과 같은 규칙이다
*        - 그리드 컬럼 정의는 목록과 공유 : /resources/js/mdcm/cmsBuyInfoMapForm.js
* 담당자 : 홍준우
* 착수일 : 2026-09-14
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<!-- IBSheet 라이브러리 (head_pop.jspf 에는 미포함이라 직접 로드) -->
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/js/common.js" type="text/javascript"></script>
<!-- 매핑변경 그리드 컬럼·엑셀 열 정의 (목록 화면과 공유) -->
<script src="/resources/js/mdcm/cmsBuyInfoMapForm.js" type="text/javascript"></script>
<script src="/resources/js/mdcm/buyInfoCode.js" type="text/javascript"></script>
</head>
<script type="text/javascript">
var sheetMap   = new ibsheetObject();	// 매핑변경 결과 그리드
var pagingMode = "N";	// Y: 번호 페이징, N : 스크롤
var curTab     = "ALL";
var mapColNames = [];
var mapColSet   = {};
var cnt = {all:0, ok:0, err:0};

var ERR_BG = "#FDECEA";	// 오류 항목 셀 배경

// 서버에서 받아온 조회 결과 — 업로드 직후 1회만 채운다.
var curMapByKey = {};	// 기존구매정보코드|고객사코드 → 현재 매핑 행
var toInfoByCode = {};	// 변경 구매정보코드 → {AGENT, STATUS, CMS_CATLG_ID}

function kep_onload_view() {
	initSheetMap();
	loadFromOpener();
}

/* 목록 화면이 LoadExcel 로 읽어 둔 행을 넘겨받는다. 팝업은 업로드 이후에만 열린다. */
function loadFromOpener() {
	var rows = null;
	try { rows = opener.mdcmMapRows; } catch (e) { rows = null; }

	if (!rows || rows.length == 0) {
		alert("업로드할 데이터가 없습니다.");
		self.close();
		return;
	}

	sheetMap.RemoveAll();
	for (var i = 0; i < rows.length; i++) {
		var r = sheetMap.DataInsert(-1);
		for (var c = 0; c < MDCM_MAP_EXCEL_COLS.length; c++) {
			var col = MDCM_MAP_EXCEL_COLS[c];
			if (!mapColSet[col]) { continue; }
			var v = rows[i][col];
			sheetMap.SetCellValue(r, col, (v == null) ? "" : v, 0);
		}
	}

	/* 양식의 구매정보코드 2열은 순번만 담는다 - 같은 쪽 상품정보코드와 합쳐 키를 되돌린다.
	   예전 양식처럼 전체코드가 적혀 있으면 그대로 쓴다. */
	for (var k = sheetMap.HeaderRows(); k <= sheetMap.LastRow(); k++) {
		sheetMap.SetCellValue(k, "BUY_INFO_ID"
			, mdcmBuyInfoFull(sheetMap.GetCellValue(k, "CMS_CATLG_ID"), sheetMap.GetCellValue(k, "BUY_INFO_SEQ")), 0);
		sheetMap.SetCellValue(k, "NEW_BUY_INFO_ID"
			, mdcmBuyInfoFull(sheetMap.GetCellValue(k, "NEW_CMS_CATLG_ID"), sheetMap.GetCellValue(k, "NEW_BUY_INFO_SEQ")), 0);
	}

	afterLoadExcel();
}

function initSheetMap() {
	var initsheet = {};
	initsheet.Cols = mdcmMapCols();	// 정의는 cmsBuyInfoMapForm.js (목록 화면과 공유)
	initsheet.Cfg  = {MergeSheet:msHeaderOnly, FrozenCol:0, UseNoDataRow:1};

	mapColNames = mdcmMapColNames();
	mapColSet = {};
	for (var i = 0; i < mapColNames.length; i++) { mapColSet[mapColNames[i]] = true; }

	IBS_InitSheet(sheetMap, initsheet, pagingMode);
}

function afterLoadExcel() {
	loader_obj("N");
	if (sheetMap.RowCount() == 0) {
		alert("업로드할 데이터가 없습니다.");
		return;
	}
	// 서버 조회가 실패하면 실재·협력사를 판정할 수 없다 — 결과화면으로 넘어가지 않는다.
	if (!fillServerInfo()) { return; }
	validateRows();

	curTab = "ALL";
	setResultTab("ALL");
	sheetMap.Render();
}

/* 검증에 필요한 자료를 한 번에 받아 온다(행마다 부르지 않는다). */
function fillServerInfo() {
	var fromCodes = [], toCodes = [], seenF = {}, seenT = {};

	for (var r = sheetMap.HeaderRows(); r <= sheetMap.LastRow(); r++) {
		var f = kepTrimStr(sheetMap.GetCellValue(r, "BUY_INFO_ID"));
		var t = kepTrimStr(sheetMap.GetCellValue(r, "NEW_BUY_INFO_ID"));
		if (f != "" && !seenF[f]) { seenF[f] = true; fromCodes.push(f); }
		if (t != "" && !seenT[t]) { seenT[t] = true; toCodes.push(t); }
	}

	var ok = false;
	loader_obj("Y");
	$.ajax({
		 type		: "POST"
		,url		: "/mdcm/getMasterMdCmCmsBuyInfoMapCheckList.do"
		,headers	: { 'X-Requested-With': 'XMLHttpRequest' }
		,async		: false		// 이 값이 없으면 검증 자체가 불가능하다
		,data		: { fromCodes : fromCodes.join("@"), toCodes : toCodes.join("@") }
		,dataType	: "json"
		,success	: function(res){
			curMapByKey  = {};
			toInfoByCode = {};

			var from = (res && res.from) ? res.from : [];
			for (var i = 0; i < from.length; i++) {
				curMapByKey[mapKey(from[i].BUY_INFO_ID, from[i].BUYER_CODE)] = from[i];
			}
			var to = (res && res.to) ? res.to : [];
			for (var i = 0; i < to.length; i++) {
				toInfoByCode[to[i].BUY_INFO_ID] = to[i];
			}
			ok = true;
		}
		,error		: function(){
			alert("검증 자료를 불러오지 못했습니다.\n\n관리자에게 문의 바랍니다.");
		}
	});
	loader_obj("N");
	return ok;
}

function mapKey(buyInfo, buyer) {
	return kepTrimStr(buyInfo) + "|" + kepTrimStr(buyer);
}

/* 행마다 검증하고 결과·오류항목·오류사유를 채운다. */
function validateRows() {
	cnt = {all:0, ok:0, err:0};

	for (var r = sheetMap.HeaderRows(); r <= sheetMap.LastRow(); r++) {
		cnt.all++;

		var get = function(name){ return kepTrimStr(sheetMap.GetCellValue(r, name)); };
		var bad = checkRow(get);

		clearErrColor(r);

		if (bad == null) {
			cnt.ok++;
			sheetMap.SetCellValue(r, "RESULT",  "정상", 0);
			sheetMap.SetCellValue(r, "ERR_COL", "", 0);
			sheetMap.SetCellValue(r, "ERR_MSG", "", 0);
		} else {
			cnt.err++;
			sheetMap.SetCellValue(r, "RESULT",  "오류", 0);
			sheetMap.SetCellValue(r, "ERR_COL", bad.column, 0);
			sheetMap.SetCellValue(r, "ERR_MSG", bad.reason, 0);
			for (var i = 0; i < bad.cols.length; i++) {
				if (mapColSet[bad.cols[i]]) { sheetMap.SetCellBackColor(r, bad.cols[i], ERR_BG); }
			}
		}
	}
	drawTiles();
}

function clearErrColor(r) {
	var cols = ["BUY_INFO_SEQ", "CMS_CATLG_ID", "BUYER_CODE", "NEW_CMS_CATLG_ID", "NEW_BUY_INFO_SEQ"];
	for (var i = 0; i < cols.length; i++) {
		if (mapColSet[cols[i]]) { sheetMap.SetCellBackColor(r, cols[i], "#FFFFFF"); }
	}
}

/* 오류사유. 한 행에 여러 건이 걸리면 **전부** 모아 " / " 로 이어 붙인다
 * — [오류항목]·[오류사유]가 같은 순서로 짝을 이룬다. 오류가 없으면 null 을 돌려준다.
 * ⚠ 앞 4건(기존 코드·고객사코드 미입력, 변경 값 미존재·미입력, 형식 오류)만은 그 자리에서 끊는다 —
 *   뒤 판정이 그 값으로 상품정보코드를 떼어내고 매핑을 찾기 때문이다. */
function checkRow(get) {
	var from    = get("BUY_INFO_ID");		// 키 - 순번과 상품정보코드로 되돌려 둔 값
	var fromSeq = get("BUY_INFO_SEQ");
	var buyer   = get("BUYER_CODE");
	var to      = get("NEW_BUY_INFO_ID");
	var toSeq   = get("NEW_BUY_INFO_SEQ");
	var toCat   = get("NEW_CMS_CATLG_ID");

	var errCols = [], errMsgs = [], errCells = [];
	var addErr = function(column, reason, cols) {
		errCols.push(column);
		errMsgs.push(reason);
		for (var j = 0; j < cols.length; j++) { errCells.push(cols[j]); }
	};
	var done = function() {
		if (errMsgs.length == 0) { return null; }
		return err(errMsgs.join(" / "), errCols.join(" / "), errCells);
	};

	// 기존 키 2열 — 둘 다 비어 있을 수 있으므로 함께 모은다
	if (fromSeq == "")   { addErr("구매정보코드", "기존 구매정보코드 미입력", ["BUY_INFO_SEQ"]); }
	else if (from == "") { addErr("상품정보코드", "기존 상품정보코드 미입력", ["CMS_CATLG_ID"]); }
	if (buyer == "") { addErr("고객사코드", "고객사코드 미입력", ["BUYER_CODE"]); }
	if (errMsgs.length > 0) { return done(); }

	// 변경 표준DB 2열이 둘 다 비면 '바꿀 것이 없는 행'이다
	if (toSeq == "" && toCat == "") { return err("변경 값 미존재", "변경 표준DB", ["NEW_CMS_CATLG_ID", "NEW_BUY_INFO_SEQ"]); }
	if (toSeq == "") { return err("변경 구매정보코드 미입력", "구매정보코드", ["NEW_BUY_INFO_SEQ"]); }
	// 순번만으로는 어느 상품의 구매정보인지 알 수 없다 - 같은 행의 상품정보코드가 있어야 키가 선다
	if (to == "") { return err("변경 상품정보코드 미입력", "상품정보코드", ["NEW_CMS_CATLG_ID"]); }

	if (!mdcmMapIsBuyInfoCode(to)) {
		return err("구매정보코드 형식 오류(ex. 00001)", "구매정보코드", ["NEW_BUY_INFO_SEQ"]);
	}

	// 순번이 아니라 전체코드를 적었다면 그 앞부분이 같은 행의 상품정보코드와 같아야 한다
	if (toCat != "" && toCat != mdcmMapCatlgOf(to)) {
		addErr("변경 표준DB", "상품정보코드-구매정보코드 불일치", ["NEW_CMS_CATLG_ID", "NEW_BUY_INFO_SEQ"]);
	}
	if (to == from) { addErr("구매정보코드", "기존과 동일한 구매정보코드", ["NEW_BUY_INFO_SEQ"]); }

	var cur = curMapByKey[mapKey(from, buyer)];
	if (cur == null) { addErr("고객사코드", "현재 매핑 미존재(기존 구매정보코드-고객사)", ["BUY_INFO_SEQ", "BUYER_CODE"]); }

	var toInfo = toInfoByCode[to];
	if (toInfo == null) { addErr("구매정보코드", "변경 구매정보코드 미존재", ["NEW_BUY_INFO_SEQ"]); }

	/* ★ 화면 매핑이관(s33)과 같은 규칙. 설계서 오류사유 목록에는 없지만 여기서 막지 않으면
	 *   엑셀로 지정여부 Y 를 우회할 수 있다. 양쪽을 다 찾았을 때만 따진다. */
	if (cur != null && toInfo != null
	 && kepTrimStr(cur.CSV_YN) == "Y" && kepTrimStr(cur.AGENT) != kepTrimStr(toInfo.AGENT)) {
		addErr("고객사지정여부", "고객사 지정여부가 Y인 항목은 동일한 협력사만 가능합니다", ["CSV_YN", "NEW_BUY_INFO_SEQ"]);
	}

	return done();
}

function err(reason, column, cols) {
	return {reason:reason, column:column, cols:cols};
}

/* ── 유형 타일(탭) ────────────────────────────────────────── */
function drawTiles() {
	var html = "";
	html += tileHtml("ALL", "전체", cnt.all);
	html += tileHtml("OK",  "정상", cnt.ok);
	html += tileHtml("ERR", "오류", cnt.err);
	document.getElementById("tileArea").innerHTML = html;

	document.getElementById("resultSummary").innerHTML =
		"전체 " + cnt.all + " 건 (정상 " + cnt.ok + " 건, 오류 " + cnt.err + " 건)";
	document.getElementById("resultAction").innerHTML =
		"오류 " + cnt.err + " 건을 제외한 " + cnt.ok + " 건이 이관됩니다.";
	document.getElementById("resultAsk").innerHTML = "아래 내용으로 시스템 반영하시겠습니까?";
}

function tileHtml(kind, label, count) {
	var cls = (curTab == kind) ? "resTile on" : "resTile";
	if (kind == "ERR" && count > 0) { cls += " err"; }
	return "<a href=\"javascript:setResultTab('" + kind + "');\" class=\"" + cls + "\">"
		 + "<span class=\"tileLabel\">" + label + "</span>"
		 + "<span class=\"tileCount\">" + count + "건</span></a>";
}

function setResultTab(kind) {
	curTab = kind;
	for (var r = sheetMap.HeaderRows(); r <= sheetMap.LastRow(); r++) {
		sheetMap.SetRowHidden(r, matchKind(r, kind) ? 0 : 1);
	}
	drawTiles();
}

function matchKind(r, kind) {
	if (kind == "ALL") { return true; }
	var result = kepTrimStr(sheetMap.GetCellValue(r, "RESULT"));
	if (kind == "ERR") { return (result == "오류"); }
	if (kind == "OK")  { return (result == "정상"); }
	return true;
}

/* 전체 / 오류 건 다운로드 — 오류 건은 오류만 보이게 필터한 뒤 보이는 행만 내려받는다
 * ⚠ Down2Excel 은 서버 왕복이라 즉시 원복하면 다운로드 도중 행 표시가 바뀐다 → 원복은 OnDownFinish 에서 한다. */
var pendingTab = "";

function downResult(errOnly) {
	pendingTab = curTab;
	setResultTab(errOnly ? "ERR" : "ALL");
	loader_obj("Y");

	sheetMap.Down2Excel({
		 FileName : "구매정보_매핑변경_업로드결과" + (errOnly ? "_오류건" : "") + ".xls"
		,Merge : 1
		,SheetDesign : 1
		,DownRows : "Visible"
		,DownCols : getMapDownCols()
	});
}

// 상태 컬럼(sStatus)과 숨긴 키 컬럼(전체 구매정보코드)은 뺀다 - 화면에 없는 값이 엑셀에만 나오면 안 된다.
function getMapDownCols() {
	var arr = [];
	for (var i = 0; i < mapColNames.length; i++) {
		if (mapColNames[i] == "sStatus") { continue; }
		if (mapColNames[i] == "BUY_INFO_ID" || mapColNames[i] == "NEW_BUY_INFO_ID") { continue; }
		arr.push(mapColNames[i]);
	}
	return arr.join("|");
}

function restorePendingTab() {
	if (pendingTab == "") { return; }
	var keep = pendingTab;
	pendingTab = "";
	if (keep != curTab) { setResultTab(keep); }
}

function sheetMap_OnDownFinish(downloadType, result) {
	restorePendingTab();
	loader_obj("N");
}

//기능함수
function doAction(str){
	switch(str){
		case "resultDownAll":
			downResult(false);
			break;
		case "resultDownErr":
			downResult(true);
			break;
		case "reg":
			doApply();
			break;
	}
}

/* [확인] — 오류 행을 뺀 정상 건만 서버로 보낸다.
 * 행마다 기존·변경 구매정보코드가 다르므로 그 두 값을 행에 실어 보낸다. */
function doApply() {
	if (cnt.ok == 0) {
		alert("반영할 정상 건이 없습니다.");
		return;
	}
	if (!confirm("오류 " + cnt.err + " 건을 제외한 " + cnt.ok + " 건을 이관합니다.\n\n"
	           + "변경 시 기존 표준DB와의 매핑은 해제됩니다. 진행하시겠습니까?")) { return; }

	var names = ["BUYER_CODE","CONTRACT_NO","CONTRACT_SEQ","st_from_buy_info","st_to_buy_info"];
	var param = { s_SAVENAME : names.join("|") };
	for (var i = 0; i < names.length; i++) { param[names[i]] = []; }

	for (var r = sheetMap.HeaderRows(); r <= sheetMap.LastRow(); r++) {
		if (kepTrimStr(sheetMap.GetCellValue(r, "RESULT")) != "정상") { continue; }

		var from  = kepTrimStr(sheetMap.GetCellValue(r, "BUY_INFO_ID"));
		var buyer = kepTrimStr(sheetMap.GetCellValue(r, "BUYER_CODE"));
		var cur   = curMapByKey[mapKey(from, buyer)] || {};

		param.BUYER_CODE.push(buyer);
		param.CONTRACT_NO.push(cur.CONTRACT_NO == null ? "" : cur.CONTRACT_NO);
		param.CONTRACT_SEQ.push(cur.CONTRACT_SEQ == null ? "" : cur.CONTRACT_SEQ);
		param.st_from_buy_info.push(from);
		param.st_to_buy_info.push(kepTrimStr(sheetMap.GetCellValue(r, "NEW_BUY_INFO_ID")));
	}

	if (param.BUYER_CODE.length == 0) {
		alert("반영할 정상 건이 없습니다.");
		return;
	}

	loader_obj("Y");
	$.ajax({
		 type		: "POST"
		,url		: "/mdcm/saveMasterMdCmCmsBuyInfoMapBulk.do"
		,headers	: { 'X-Requested-With': 'XMLHttpRequest' }
		,traditional: true
		,data		: param
		,dataType	: "json"
		,success	: function( res ) {
			loader_obj("N");

			// 실패 응답에는 Result.Code 가 없다(ExceptionController 가 HTTP 200 + Message 로 답한다)
			if (!res || !res.Result || res.Result.Code != 1) {
				alert("매핑변경 반영 처리 중 오류가 발생하였습니다.\n\n"
				    + ((res && res.Message) ? res.Message : "관리자에게 문의 바랍니다."));
				return;
			}
			alert("고객사 매핑 " + ((res.Message == null) ? "" : res.Message) + " 건이 이관되었습니다.");
			try { opener.doAction('search'); } catch (e) {}
			self.close();
		}
		,error		: function() {
			loader_obj("N");
			alert("매핑변경 반영 처리 중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
		}
	});
}
</script>

<style>
/* 결과 유형 타일(탭) — 다른 업로드 결과 팝업과 같은 스킨을 쓴다 */
#tileArea{ margin:10px 0 2px; }
.resTile{ display:inline-block; min-width:110px; margin-right:8px; padding:8px 14px; text-align:center;
          border:1px solid #cdcdcd; border-radius:4px; background:#fff; color:#555; text-decoration:none; }
.resTile .tileLabel{ display:block; font-size:12px; }
.resTile .tileCount{ display:block; font-size:16px; font-weight:bold; margin-top:2px; }
.resTile.on{ border-color:#3c639c; background:#eef3fa; color:#1f4b8e; }
.resTile.err .tileCount{ color:#c0392b; }
.resSummary{ display:block; font-size:15px; font-weight:bold; color:#222; margin:2px 0 2px; }
.resAction{ display:block; font-size:13px; color:#555; }
.resAsk{ display:block; font-size:13px; color:#3c639c; margin-top:4px; }
.resBox{ background-color:#fff; border-radius:5px; padding:10px 12px; }
.resBox.mb{ margin-bottom:10px; }
.resNote{ margin:6px 0 0; color:#888; }
</style>

<body onLoad="kep_onload_view()">
	<div id="popWrapper" style="width:1160px;">
		<div id="popHeader">
			<h1 class="title" id="popTitle">일괄 업로드 결과 확인 (고객사 매핑변경)</h1>
			<p class="popClose"><a href="javascript:self.close()">
				<img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
			</a></p>
		</div>

		<!--팝업내용입니다-->
		<div id="popContainer" style="background-color:#f5f5f5">

			<!--AJAX 조회용 hidden form-->
			<form name="searchCondition" id="searchCondition" method="post">
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="st_com_code" name="st_com_code_view" value="<%=_sessionInfo == null ? "" : CommonUtil.nvl(_sessionInfo.getComCode())%>">
				<input type="hidden" id="st_login_id" name="st_login_id" value="<%=_sessionInfo == null ? "" : CommonUtil.nvl(_sessionInfo.getUserId())%>">
			</form>

			<!--============ 업로드 결과 확인 ============-->
			<div id="stepResult">

				<div class="resBox mb">
					<span class="resSummary" id="resultSummary"></span>
					<span class="resAction"  id="resultAction"></span>
					<span class="resAsk"     id="resultAsk"></span>
					<div id="tileArea"></div>
				</div>

				<div class="resBox">
					<div class="ib_product" style="border-top:2px solid #3c639c">
						<script type="text/javascript">
							createIBSheet("sheetMap", "100%", "320px");
						</script>
					</div>
					<p class="resNote">※ 오류 행은 [결과] 컬럼이 '오류'로 표시되며, 해당 셀에 색이 입혀지고 [오류항목]·[오류사유] 컬럼에 사유가 노출됩니다. 고객사 지정여부가 Y인 항목은 동일한 협력사인 경우만 이관됩니다.</p>

					<div class="btnArea mt05" style="text-align:center; padding:10px 0 4px;">
						<span class="btn_08 mr04"><a href="javascript:doAction('resultDownAll');">전체 내역 다운로드</a></span>
						<span class="btn_08 mr04"><a href="javascript:doAction('resultDownErr');">오류 항목 다운로드</a></span>
						<span class="btn_02 mr04"><a href="javascript:doAction('reg');">확인</a></span>
						<span class="btn_02"><a href="javascript:self.close();">닫기</a></span>
					</div>
				</div>
			</div>
			<br>
		</div>
	</div>
</body>
</html>
