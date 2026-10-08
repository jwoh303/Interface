<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>구매정보 조회 및 관리 > 구매정보 양식 업로드 시 팝업
* 화면 : (팝업) 일괄 업로드 **결과 확인** (구매정보 일괄등록)
* 기능 : 양식 다운로드/업로드는 **목록 화면(masterMdCmCmsBuyInfoList) 하단 바**가 맡는다.
*        이 팝업은 목록이 엑셀을 파싱한 뒤에만 열리며, 결과 확인만 한다.
*        - 목록이 파싱해 둔 행(`opener.mdcmRegRows`)을 받아 → 상품·협력사·중복 서버조회 → 검증 → 결과 표시
*        - 유형선택조회(타일 탭) + 결과/오류항목/오류사유 + 전체·오류 건 다운로드
*        - 그리드 컬럼 정의는 목록과 공유 : /resources/js/mdcm/cmsBuyInfoRegForm.js
* 담당자 : 홍준우
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
<!-- 구매정보 등록 그리드 컬럼·엑셀 열 정의 (목록 화면과 공유) -->
<script src="/resources/js/mdcm/cmsBuyInfoRegForm.js" type="text/javascript"></script>
</head>
<script type="text/javascript">
var sheetReg = new ibsheetObject();	// 구매정보 일괄등록 결과 그리드
var pagingMode = "N";	// Y: 번호 페이징, N : 스크롤
var curTab = "ALL";		// 선택된 유형 타일
var regColNames = [];	// 그리드 컬럼(SaveName) 순서 — 다운로드 컬럼 지정용
var cnt = {all:0, ok:0, err:0};

var ERR_BG = "#FDECEA";	// 오류 항목 셀 배경

// 서버에서 받아온 조회 결과 — 업로드 직후 1회만 채운다.
var itemByCode   = {};	// 상품정보코드 → 상품 기본정보
var agentNameBy  = {};	// 협력사코드 → 협력사명
var dupKeySet    = {};	// 이미 등록된 구매정보의 중복 판정 키
var makeTypeSet  = {};	// 품목구분 코드 실재 여부 (ICOMCOD1 M132)
var whCodeByName = {};	// 입고TR 센터명 → 센터코드 (ICOMCOD1 W001)
var whCodeSet    = {};	// 센터코드 실재 여부 — 이름 대신 코드를 직접 적어도 받는다
var regColSet    = {};	// 그리드에 실제로 있는 컬럼(SaveName)

function kep_onload_view() {
	initSheetReg();
	loadFromOpener();
}

/* 목록 화면(masterMdCmCmsBuyInfoList)이 LoadExcel 로 읽어 둔 행을 넘겨받는다.
 * 팝업은 **업로드 이후에만** 열리므로 여기가 유일한 진입 경로다.
 * ⚠ 파일을 창 사이로 넘길 수 없어 파싱은 목록이 하고, 이쪽은 같은 출처 창의 JS 배열을 그대로 읽는다. */
function loadFromOpener() {
	var rows = null;
	try { rows = opener.mdcmRegRows; } catch (e) { rows = null; }

	if (!rows || rows.length == 0) {
		alert("업로드할 데이터가 없습니다.");
		self.close();
		return;
	}

	sheetReg.RemoveAll();
	for (var i = 0; i < rows.length; i++) {
		var r = sheetReg.DataInsert(-1);
		for (var c = 0; c < MDCM_REG_EXCEL_COLS.length; c++) {
			var col = MDCM_REG_EXCEL_COLS[c];
			if (!regColSet[col]) { continue; }
			var v = rows[i][col];
			sheetReg.SetCellValue(r, col, (v == null) ? "" : v, 0);
		}
	}

	afterLoadExcel(true, sheetReg);
}

function initSheetReg() {
	var initsheet = {};
	initsheet.Cols = mdcmRegCols();		// 정의는 cmsBuyInfoRegForm.js (목록 화면과 공유)
	initsheet.Cfg  = {MergeSheet:msHeaderOnly, FrozenCol:0, UseNoDataRow:1};

	regColNames = mdcmRegColNames();
	regColSet = {};
	for (var i = 0; i < regColNames.length; i++) { regColSet[regColNames[i]] = true; }

	IBS_InitSheet(sheetReg, initsheet, pagingMode);
}

//기능함수
function doAction(str){
	switch(str){
		case "resultDownAll": // 전체 다운로드
			downResult(false);
			break;
		case "resultDownErr": // 오류 건 다운로드
			downResult(true);
			break;
		case "reg": // 확인 — 정상 건만 등록
			doApply();
			break;
	}
}

/* 확인 — 오류 행을 뺀 정상 건만 서버로 보낸다. */
function doApply() {
	if (cnt.ok == 0) {
		alert("등록할 정상 건이 없습니다.");
		return;
	}

	var msg = "오류 " + cnt.err + " 건을 제외한 " + cnt.ok + " 건을 등록합니다.\n\n진행하시겠습니까?";
	if (!confirm(msg)) { return; }

	var param = collectApplyRows();
	if (param == null) { return; }

	loader_obj("Y");
	$.ajax({
		 type		: "POST"
		,url		: "/mdcm/saveMasterMdCmCmsBuyInfoRegBulk.do"
		,headers	: { 'X-Requested-With': 'XMLHttpRequest' }
		,traditional: true
		,data		: param
		,dataType	: "json"
		,success	: function( res ) {
			loader_obj("N");

			// 서버가 실패하면 ExceptionController 가 HTTP 200 + {Message:"시스템 처리 중…"} 로 응답한다.
			// 성공 응답에만 Result.Code 가 있으므로 그것으로 가른다.
			if (!res || !res.Result || res.Result.Code != 1) {
				alert("구매정보 등록 처리 중 오류가 발생하였습니다.\n\n"
				    + ((res && res.Message) ? res.Message : "관리자에게 문의 바랍니다."));
				return;
			}

			alert("구매정보 " + ((res.Message == null) ? "" : res.Message) + " 건이 등록되었습니다.");
			try { opener.doAction('search'); } catch (e) {}
			self.close();
		}
		,error		: function() {
			loader_obj("N");
			alert("구매정보 등록 처리 중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
		}
	});
}

/* 정상 행만 배열로 묶는다. 유형선택조회로 숨겨진 행도 대상이므로 표시 여부는 보지 않는다.
 * ⚠ 금액·수량은 콤마를 턴 숫자문자열로, 배송유형은 코드(PCL/CAR)로, 날짜는 YYYYMMDD 8자리로 보낸다. */
function collectApplyRows() {
	var sheet = sheetReg;
	var names = ["CMS_CATLG_ID","AGENT","BUY_PRICE","MIN_ORDER_QTY","PUR_UNIT_QTY","PROCESS_TYPE"
	            ,"DELIVERY_TYPE","WAREHOUSE_CODE","DELIVERY_LT","ITEM_MAKE_TYPE","TAX_TYPE"
	            ,"SELLER_ITEM_NO","BUY_OPEN_DATE","BUY_CLOSE_DATE"];

	var param = { s_SAVENAME : names.join("|") };
	for (var i = 0; i < names.length; i++) { param[names[i]] = []; }

	for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
		if (kepTrimStr(sheet.GetCellValue(r, "RESULT")) != "정상") { continue; }
		for (var i = 0; i < names.length; i++) {
			param[names[i]].push(applyValue(sheet, r, names[i]));
		}
	}

	if (param.CMS_CATLG_ID.length == 0) {
		alert("등록할 정상 건이 없습니다.");
		return null;
	}
	return param;
}

function applyValue(sheet, r, name) {
	var v = kepTrimStr(sheet.GetCellValue(r, name));
	if (name == "BUY_PRICE" || name == "MIN_ORDER_QTY" || name == "PUR_UNIT_QTY" || name == "DELIVERY_LT") {
		var n = kepParseNum(v);
		return isNaN(n) ? "" : ("" + n);
	}
	if (name == "DELIVERY_TYPE") {
		return (MDCM_REG_DELIVERY_TYPE[v] == null) ? "" : MDCM_REG_DELIVERY_TYPE[v];
	}
	if (name == "BUY_OPEN_DATE" || name == "BUY_CLOSE_DATE") {
		return kepToDate8(v);
	}
	if (name == "WAREHOUSE_CODE") {
		return warehouseCodeOf(v);
	}
	return v;
}

/* ── 검증에 필요한 값 채우기 ────────────────────────────────
 * 업로드 직후 **1회만** 서버에 묻는다(행마다 부르지 않는다). 조회 전용 요청이다.
 *   - 상품정보코드 → CMSCATLG 의 품목명·모델번호·규격·제조사·단위. 실재 판정도 겸한다
 *   - 협력사코드   → 실재하는 협력사의 명칭
 *   - 중복 키      → 그 상품에 이미 달린 구매정보
 * 검증(validateRows)이 이 결과에 의존하므로 async:false 로 순서를 지킨다. */
function fillCheckData(sheet) {
	itemByCode = {}; agentNameBy = {}; dupKeySet = {}; makeTypeSet = {};
	whCodeByName = {}; whCodeSet = {};

	var codes  = [];
	var agents = [];
	for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
		var code  = kepTrimStr(sheet.GetCellValue(r, "CMS_CATLG_ID"));
		var agent = kepTrimStr(sheet.GetCellValue(r, "AGENT"));
		if (code  != "") { codes.push(code); }
		if (agent != "") { agents.push(agent); }
	}
	if (codes.length == 0 && agents.length == 0) { return true; }

	var ok = false;
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mdcm/getMasterMdCmCmsBuyInfoRegCheckList.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: { codes: codes.join("@"), agents: agents.join("@") },
		async: false,
		success: function( response ) {
			var items = (response && response.data) ? response.data : [];
			for (var i = 0; i < items.length; i++) {
				itemByCode[kepTrimStr(items[i].CMS_CATLG_ID)] = items[i];
			}

			var ags = (response && response.agents) ? response.agents : [];
			for (var i = 0; i < ags.length; i++) {
				agentNameBy[kepTrimStr(ags[i].AGENT)] = kepTrimStr(ags[i].AGENT_NAME);
			}

			var dups = (response && response.dups) ? response.dups : [];
			for (var i = 0; i < dups.length; i++) {
				dupKeySet[dupKeyOfRow(dups[i])] = true;
			}

			var types = (response && response.makeTypes) ? response.makeTypes : [];
			for (var i = 0; i < types.length; i++) { makeTypeSet[kepTrimStr(types[i]).toUpperCase()] = true; }

			var whs = (response && response.warehouses) ? response.warehouses : [];
			for (var i = 0; i < whs.length; i++) {
				var whCode = kepTrimStr(whs[i].CODE);
				whCodeByName[kepTrimStr(whs[i].WAREHOUSE_NAME)] = whCode;
				whCodeSet[whCode.toUpperCase()] = true;
			}

			/* 각 행에 상품 기본정보·협력사명을 꽂는다. 없는 코드는 공백 그대로 두고 검증이 잡는다.
			 * ⚠ 품목명~단위는 엑셀에 없는 열이라 전부 DB 현재값이다. */
			for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
				var row = itemByCode[kepTrimStr(sheet.GetCellValue(r, "CMS_CATLG_ID"))];
				if (row) {
					for (var key in row) {
						if (!row.hasOwnProperty(key) || !regColSet[key]) { continue; }
						if (key == "CMS_CATLG_ID") { continue; }
						sheet.SetCellValue(r, key, (row[key] == null) ? "" : row[key], 0);
					}
				}
				var name = agentNameBy[kepTrimStr(sheet.GetCellValue(r, "AGENT"))];
				sheet.SetCellValue(r, "AGENT_NAME", (name == null) ? "" : name, 0);
			}
			ok = true;
		},
		error: function( response ) {
			alert("검증에 필요한 자료를 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.");
		}
	});
	return ok;
}

// 서버가 돌려준 중복 키 행 → 키 문자열
function dupKeyOfRow(row) {
	return mdcmRegDupKey(function(col) { return row[col]; });
}

/* ── 검증 ──────────────────────────────────────────────────
 * 오류사유는 설계 2종(필수값 누락 / 동일 기준 중복)에, 그대로 두면 등록이 깨지는 것(미존재·형식)을 더했다.
 * 먼저 걸린 것 하나만 남긴다(행당 오류 1건). */
function validateRows() {
	var sheet = sheetReg;
	cnt = {all:0, ok:0, err:0};

	var seen = {};	// 파일 안에서의 중복 판정용 (키 → 최초 등장 No.)
	var no = 0;

	for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
		no++;
		formatRow(sheet, r);
		var err = checkRegRow(sheet, r, seen, no);

		sheet.SetCellValue(r, "RESULT",     (err.reason == "") ? "정상" : "오류", 0);
		sheet.SetCellValue(r, "ERR_COL",    err.column, 0);
		sheet.SetCellValue(r, "ERR_REASON", err.reason, 0);

		if (err.reason == "") {
			cnt.ok++;
		} else {
			cnt.err++;
			markError(sheet, r, err.cols);
		}
		cnt.all++;
	}
}

// 금액·수량 표시는 콤마로 맞춘다(엑셀에서 6110 으로 와도 화면은 6,110)
function formatRow(sheet, r) {
	var cols = ["BUY_PRICE", "MIN_ORDER_QTY", "PUR_UNIT_QTY"];
	for (var i = 0; i < cols.length; i++) {
		var v = kepTrimStr(sheet.GetCellValue(r, cols[i]));
		if (v != "") { sheet.SetCellValue(r, cols[i], kepNumToComma(v), 0); }
	}
}

// 오류 항목 셀에 색을 입힌다
function markError(sheet, r, cols) {
	if (!cols) { return; }
	for (var i = 0; i < cols.length; i++) {
		if (!regColSet[cols[i]]) { continue; }
		sheet.SetCellBackColor(r, cols[i], ERR_BG);
	}
}

/* 판정 순서는 '행 자체가 무효 → 입력 누락 → 값 규칙 → 중복' 순이다.
 * 한 행에 여러 건이 걸리면 **전부** 모아 " / " 로 이어 붙인다 — [오류항목]·[오류사유]가 같은 순서로 짝을 이룬다.
 * ⚠ 앞 3건(필수값 누락, 상품정보코드·협력사코드 미존재)만은 그 자리에서 끊는다 —
 *   뒤 판정의 전제라, 값이 비었거나 실재하지 않는 코드에 값 규칙·중복을 따질 수 없다.
 * 반환 {reason:"", column:"", cols:[]} — column 은 화면에 보일 오류항목 이름. */
function checkRegRow(sheet, r, seen, no) {
	var get = function(col) { return kepTrimStr(sheet.GetCellValue(r, col)); };

	// 1. 필수값 누락
	var miss = [];
	var missCols = [];
	for (var i = 0; i < MDCM_REG_REQUIRED_COLS.length; i++) {
		var req = MDCM_REG_REQUIRED_COLS[i];
		if (get(req.name) == "") { miss.push(req.label); missCols.push(req.name); }
	}
	if (miss.length > 0) { return err("필수값 누락", miss.join(", "), missCols); }

	// 2. 실재하지 않는 코드 — 없는 상품·협력사에 구매정보를 달 수 없다
	if (!itemByCode[get("CMS_CATLG_ID")]) { return err("상품정보코드 미존재", "상품정보코드", ["CMS_CATLG_ID"]); }
	if (agentNameBy[get("AGENT")] == null) { return err("협력사코드 미존재", "협력사코드", ["AGENT"]); }

	// 이 행에서 걸린 오류를 순서대로 쌓는다.
	var errCols = [], errMsgs = [], errCells = [];
	var addErr = function(column, reason, cols) {
		errCols.push(column);
		errMsgs.push(reason);
		for (var j = 0; j < cols.length; j++) { errCells.push(cols[j]); }
	};

	// 3. 값 규칙
	var num = [{name:"BUY_PRICE", label:"매입단가"}, {name:"MIN_ORDER_QTY", label:"최소주문수량"}
	          ,{name:"PUR_UNIT_QTY", label:"주문배수수량"}, {name:"DELIVERY_LT", label:"배송일수"}];
	for (var i = 0; i < num.length; i++) {
		var v = get(num[i].name);
		if (v == "") { continue; }		// 배송일수는 선택 항목이다
		var n = kepParseNum(v);
		if (isNaN(n)) { addErr(num[i].label, num[i].label + " 형식 오류(숫자만 입력)", [num[i].name]); }
		if (n <= 0)   { addErr(num[i].label, num[i].label + "는 0보다 커야 합니다",     [num[i].name]); }
	}

	if (!inList(get("PROCESS_TYPE"), ["0","1","2","3"])) { addErr("거래유형", "거래유형 값 오류(0/1/2/3)", ["PROCESS_TYPE"]); }

	var dlv = get("DELIVERY_TYPE");
	if (dlv != "" && MDCM_REG_DELIVERY_TYPE[dlv] == null) { addErr("배송유형", "배송유형 값 오류(택배/자차)", ["DELIVERY_TYPE"]); }

	var make = get("ITEM_MAKE_TYPE");
	if (make != "" && !makeTypeSet[make.toUpperCase()]) { addErr("품목구분", "품목구분 미존재", ["ITEM_MAKE_TYPE"]); }

	var tax = get("TAX_TYPE");
	if (tax != "" && !inList(tax, ["11","12"])) { addErr("과세구분", "과세구분 값 오류(11/12)", ["TAX_TYPE"]); }

	var wh = get("WAREHOUSE_CODE");
	if (wh != "" && warehouseCodeOf(wh) == "") { addErr("입고TR", "입고TR 미존재(물류센터명을 목록에서 선택)", ["WAREHOUSE_CODE"]); }

	var from = kepToDate8(get("BUY_OPEN_DATE"));
	var to   = kepToDate8(get("BUY_CLOSE_DATE"));
	if (from == "") { addErr("유효기간 시작일", "유효기간 시작일 형식 오류(YYYYMMDD)", ["BUY_OPEN_DATE"]); }
	if (to   == "") { addErr("유효기간 종료일", "유효기간 종료일 형식 오류(YYYYMMDD)", ["BUY_CLOSE_DATE"]); }
	if (from != "" && to != "" && from > to) { addErr("매입단가 유효기간", "유효기간이 거꾸로입니다", ["BUY_OPEN_DATE","BUY_CLOSE_DATE"]); }

	/* 4. 동일 기준 중복 — 상품정보코드 + 협력사코드 + 거래유형 + 최소주문수량 + 주문배수수량.
	 *    이미 등록된 구매정보와도, 같이 올린 파일 안에서도 본다. */
	var key = mdcmRegDupKey(get);
	if (dupKeySet[key])          { addErr("동일 기준", "동일 기준 중복 (등록된 구매정보와 동일)", MDCM_REG_DUP_KEY_COLS); }
	else if (seen[key])          { addErr("동일 기준", "동일 기준 중복 (No." + seen[key] + "과 동일)", MDCM_REG_DUP_KEY_COLS); }
	else                         { seen[key] = no; }

	// 오류가 없으면 두 배열 모두 비어 있어 join 결과가 "" 다 — 그대로 '정상' 판정으로 흘러간다.
	return err(errMsgs.join(" / "), errCols.join(" / "), errCells);
}

/* 입고TR 입력값 → 저장할 센터코드. 양식은 센터명을 고르게 하지만 코드를 직접 적어도 받는다.
 * 어느 쪽도 아니면 빈 문자열 — 검증이 '미존재'로 잡는다. */
function warehouseCodeOf(v) {
	var s = kepTrimStr(v);
	if (s == "") { return ""; }
	if (whCodeByName[s] != null) { return whCodeByName[s]; }
	if (whCodeSet[s.toUpperCase()]) { return s; }
	return "";
}

function err(reason, column, cols) {
	return {reason:reason, column:column, cols:cols};
}

function inList(v, list) {
	for (var i = 0; i < list.length; i++) { if (list[i] == v) { return true; } }
	return false;
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
		"오류 " + cnt.err + " 건을 제외한 " + cnt.ok + " 건이 등록됩니다.";
	document.getElementById("resultAsk").innerHTML = "아래 내용으로 시스템 등록하시겠습니까?";
}

function tileHtml(kind, label, count) {
	var cls = (curTab == kind) ? "resTile on" : "resTile";
	if (kind == "ERR" && count > 0) { cls += " err"; }
	return "<a href=\"javascript:setResultTab('" + kind + "');\" class=\"" + cls + "\">"
		 + "<span class=\"tileLabel\">" + label + "</span>"
		 + "<span class=\"tileCount\">" + count + "건</span></a>";
}

/* 유형선택조회 — 해당 유형만 남기고 나머지 행을 숨긴다 */
function setResultTab(kind) {
	curTab = kind;
	for (var r = sheetReg.HeaderRows(); r <= sheetReg.LastRow(); r++) {
		sheetReg.SetRowHidden(r, matchKind(sheetReg, r, kind) ? 0 : 1);
	}
	drawTiles();
}

function matchKind(sheet, r, kind) {
	if (kind == "ALL") { return true; }
	var result = kepTrimStr(sheet.GetCellValue(r, "RESULT"));
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

	sheetReg.Down2Excel({
		 FileName : "구매정보_일괄등록_업로드결과" + (errOnly ? "_오류건" : "") + ".xls"
		,Merge : 1
		,SheetDesign : 1
		,DownRows : "Visible"
		,DownCols : getRegDownCols()
	});
}

// 상태 컬럼(sStatus)만 빼고 전 컬럼을 내려받는다.
function getRegDownCols() {
	var arr = [];
	for (var i = 0; i < regColNames.length; i++) {
		if (regColNames[i] == "sStatus") { continue; }
		arr.push(regColNames[i]);
	}
	return arr.join("|");
}

function restorePendingTab() {
	if (pendingTab == "") { return; }
	var keep = pendingTab;
	pendingTab = "";
	if (keep != curTab) { setResultTab(keep); }
}

function sheetReg_OnDownFinish(downloadType, result) {
	restorePendingTab();
	loader_obj("N");
}

function afterLoadExcel(result, sheet) {
	loader_obj("N");
	if (!result) {
		alert("엑셀 로딩 중 오류가 발생하였습니다.");
		return;
	}
	if (sheet.RowCount() == 0) {
		alert("업로드할 데이터가 없습니다.");
		return;
	}
	// 상품·협력사·중복 조회가 실패하면 미존재·중복을 판정할 수 없다 — 결과화면으로 넘어가지 않는다.
	if (!fillCheckData(sheet)) { return; }
	validateRows();

	curTab = "ALL";
	setResultTab("ALL");
	sheetReg.Render();
}
</script>

<style>
/* 결과 유형 타일(탭) — 상품정보 일괄수정 결과 팝업과 같은 스킨을 쓴다 */
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
			<h1 class="title" id="popTitle">일괄 업로드 결과 확인 (구매정보 등록)</h1>
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
							createIBSheet("sheetReg", "100%", "320px");
						</script>
					</div>
					<p class="resNote">※ 오류 행은 [결과] 컬럼이 '오류'로 표시되며, 해당 셀에 색이 입혀지고 [오류항목]·[오류사유] 컬럼에 사유가 노출됩니다. 상품정보는 입력값이 아니라 현재 등록된 값입니다.</p>
				</div>

				<!--하단 버튼 : 좌(전체·오류 건 다운로드) / 우(확인·닫기)-->
				<div class="btnArea mt05">
					<span class="fl">
						<span class="btn_09 mr04"><a href="javascript:doAction('resultDownAll');">전체 다운로드</a></span>
						<span class="btn_09"><a href="javascript:doAction('resultDownErr');">오류 건 다운로드</a></span>
					</span>
					<!-- 결과 확인 후 다시 올리려면 창을 닫고 새로 연다(업로드 화면으로 되돌아가지 않음) -->
					<span class="fr">
						<span class="btn_02 mr04"><a href="javascript:doAction('reg');" id="btnReg">확인</a></span>
						<span class="btn_02"><a href="javascript:self.close();">닫기</a></span>
					</span>
				</div>
			</div>
			<br>
		</div>
	</div>
</body>
</html>
