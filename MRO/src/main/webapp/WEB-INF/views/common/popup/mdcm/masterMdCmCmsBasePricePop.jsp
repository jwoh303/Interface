<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>상품정보 조회 및 관리 > 기준가 양식 업로드 시 팝업
* 화면 : (팝업) 일괄 업로드 **결과 확인** (기준가 일괄수정)
* 기능 : 양식 다운로드/업로드는 **목록 화면(masterMdCmCmsItemList) 하단 바**가 맡는다.
*        이 팝업은 목록이 엑셀을 파싱한 뒤에만 열리며, 결과 확인만 한다.
*        - 목록이 파싱해 둔 행(`opener.mdcmPriceRows`)을 받아 → [기존]값 서버조회 → 검증 → 결과 표시
*        - 유형선택조회(타일 탭) + 인상/인하 · 변동률 + 결과/오류사유 + 전체·오류 건 다운로드
*        - 그리드 컬럼 정의는 목록과 공유 : /resources/js/mdcm/cmsBasePriceForm.js
* 담당자 : 홍준우
* 착수일 : 2026-09-01
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
<!-- 기준가 그리드 컬럼·엑셀 열 정의 (목록 화면과 공유) -->
<script src="/resources/js/mdcm/cmsBasePriceForm.js" type="text/javascript"></script>
</head>
<script type="text/javascript">
var sheetPrice = new ibsheetObject();	// 기준가 일괄수정 결과 그리드
var pagingMode = "N";	// Y: 번호 페이징, N : 스크롤
var curTab = "ALL";		// 선택된 유형 타일
var priceColNames = [];	// 그리드 컬럼(SaveName) 순서 — 다운로드 컬럼 지정용
var cnt = {all:0, ok:0, err:0, down:0};	// 유형별 건수 (down = 기준가 인하 = 품의 대상)

var UP_TXT   = "#C0392B";	// 인상 — 빨강
var DOWN_TXT = "#1F6FB2";	// 인하 — 파랑

// 서버에서 받아온 조회 결과 — 업로드 직후 1회만 채운다.
var codeExists    = {};	// 상품정보코드 실재 여부
var beforeByCode  = {};	// 코드 → [기존] 행
var priceTypeSet  = {};	// 기준가유형 명칭 실재 여부 (ICOMCOD1 M183)
var priceTypeList = [];	// 안내 문구용 원본 목록
var priceColSet   = {};	// 그리드에 실제로 있는 컬럼(SaveName)

function kep_onload_view() {
	initSheetPrice();
	loadFromOpener();
}

/* 목록 화면(masterMdCmCmsItemList)이 LoadExcel 로 읽어 둔 행을 넘겨받는다.
 * 팝업은 **업로드 이후에만** 열리므로 여기가 유일한 진입 경로다.
 * ⚠ 파일을 창 사이로 넘길 수 없어 파싱은 목록이 하고, 이쪽은 같은 출처 창의 JS 배열을 그대로 읽는다. */
function loadFromOpener() {
	var rows = null;
	try { rows = opener.mdcmPriceRows; } catch (e) { rows = null; }

	if (!rows || rows.length == 0) {
		alert("업로드할 데이터가 없습니다.");
		self.close();
		return;
	}

	sheetPrice.RemoveAll();
	for (var i = 0; i < rows.length; i++) {
		var r = sheetPrice.DataInsert(-1);
		for (var c = 0; c < MDCM_PRICE_EXCEL_COLS.length; c++) {
			var col = MDCM_PRICE_EXCEL_COLS[c];
			var v = rows[i][col];
			sheetPrice.SetCellValue(r, col, (v == null) ? "" : v, 0);
		}
	}

	afterLoadExcel(true, sheetPrice);
}

function initSheetPrice() {
	var initsheet = {};
	initsheet.Cols = mdcmPriceCols();		// 정의는 cmsBasePriceForm.js (목록 화면과 공유)
	initsheet.Cfg  = {MergeSheet:msHeaderOnly, FrozenCol:0, UseNoDataRow:1};

	priceColNames = mdcmPriceColNames();
	IBS_InitSheet(sheetPrice, initsheet, pagingMode);
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
		case "reg": // 확인 — 정상 건만 반영. 인하 건은 품의 상신
			doApply();
			break;
	}
}

/* 확인 — 오류 행을 뺀 정상 건만 서버로 보낸다.
 * 인상·기준가유형 단독 변경은 즉시 반영, 인하는 신청(KEPMGPHD/KEPMGPDT)만 만들고
 * 채번된 PM_NO 로 결재 팝업(DOC_TYPE=BPM)을 띄운다. 한 번의 상신에 인하 건 전부가 묶인다. */
function doApply() {
	if (cnt.ok == 0) {
		alert("반영할 정상 건이 없습니다.");
		return;
	}

	var msg = "오류 " + cnt.err + " 건을 제외한 " + cnt.ok + " 건을 반영합니다.\n";
	if (cnt.down > 0) {
		msg += "이 중 " + cnt.down + " 건(기준가 인하)은 품의가 상신됩니다.\n";
	}
	msg += "\n진행하시겠습니까?";
	if (!confirm(msg)) { return; }

	var param = collectApplyRows();
	if (param == null) { return; }

	loader_obj("Y");
	$.ajax({
		 type		: "POST"
		,url		: "/mdcm/saveMasterMdCmCmsItemBasePriceBulk.do"
		,headers	: { 'X-Requested-With': 'XMLHttpRequest' }
		,traditional: true
		,data		: param
		,dataType	: "json"
		,success	: function( res ) {
			loader_obj("N");

			// 서버가 실패하면 ExceptionController 가 HTTP 200 + {Message:"시스템 처리 중…"} 로 응답한다.
			// 성공 응답에만 Result.Code 가 있으므로 그것으로 가른다 —
			// 이 검사가 없으면 에러문이 그대로 PM_NO 로 쓰여 결재 KEY_1 에 박힌다(ORA-12899).
			if (!res || !res.Result || res.Result.Code != 1) {
				alert("기준가 반영 처리 중 오류가 발생하였습니다.\n\n"
				    + ((res && res.Message) ? res.Message : "관리자에게 문의 바랍니다."));
				return;
			}

			var pm_no = (res && res.Message) ? res.Message : "";

			if (pm_no != "") {
				openApproval(pm_no);
			} else {
				alert("기준가가 반영되었습니다.");
				self.close();
			}
		}
		,error		: function() {
			loader_obj("N");
			alert("기준가 반영 처리 중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
		}
	});
}

/* 정상 행만 배열로 묶는다. 유형선택조회로 숨겨진 행도 대상이므로 표시 여부는 보지 않는다.
 * ⚠ 기준가는 콤마를 턴 숫자문자열로 보낸다 — 이력 함수가 문자열 비교라 '4,800' 이면 안 바뀌었는데 이력이 쌓인다.
 * ⚠ 기준가유형·변경사유는 그리드에 **명칭**이 들어 있다. 코드 복원은 서버 SQL 이 맡는다. */
function collectApplyRows() {
	var sheet = sheetPrice;
	var param = {
		 s_SAVENAME		: "CMS_CATLG_ID|PRICE_AFTER|PRICE_TYPE_AFTER|CHG_REASON|UPDOWN"
		,CMS_CATLG_ID		: []
		,PRICE_AFTER		: []
		,PRICE_TYPE_AFTER	: []
		,CHG_REASON			: []
		,UPDOWN				: []
	};

	for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
		if (kepTrimStr(sheet.GetCellValue(r, "RESULT")) != "정상") { continue; }
		param.CMS_CATLG_ID.push(kepTrimStr(sheet.GetCellValue(r, "CMS_CATLG_ID")));
		param.PRICE_AFTER.push(priceRaw(sheet.GetCellValue(r, "PRICE_AFTER")));
		param.PRICE_TYPE_AFTER.push(kepTrimStr(sheet.GetCellValue(r, "PRICE_TYPE_AFTER")));
		param.CHG_REASON.push(kepTrimStr(sheet.GetCellValue(r, "CHG_REASON")));
		param.UPDOWN.push(kepTrimStr(sheet.GetCellValue(r, "UPDOWN")));
	}

	if (param.CMS_CATLG_ID.length == 0) {
		alert("반영할 정상 건이 없습니다.");
		return null;
	}
	return param;
}

// 콤마 없는 숫자문자열. 유형만 바꾼 행은 공백이며 서버가 기존 기준가를 유지한다.
function priceRaw(v) {
	var n = kepParseNum(v);
	return isNaN(n) ? "" : ("" + n);
}

/* 결재 팝업 호출. 단건 변경 팝업과 같은 계약이고 DOC_TYPE 만 BPM 이다. */
function openApproval(pm_no) {
	var t = "기준가 인하 품의 - " + cnt.down + "건";
	openSearchPopup("/common/approval/buyerCommonApprovalPop.do"
		, '?DOC_TYPE=BPM&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO=' + pm_no
		+ '&PARAM1=' + $.trim($("#st_com_code").val())
		+ '&PARAM2=' + $.trim($("#st_login_id").val())
		+ '&st_title=' + t
		+ '&st_cont='
		, "1000,500,no");
}

/* 결재 팝업이 상신을 마치면 이 함수를 부른다(공통 계약). */
function kepApprovalReturn(flag, docu_no) {
	alert("품의가 상신되었습니다.");
	self.close();
}

/* ── [기존] 값 채우기 ────────────────────────────────────────
 * 업로드 직후 **1회만** 서버에 묻는다(행마다 부르지 않는다). 조회 전용 요청이다.
 *   - 업로드한 상품정보코드 → CMSCATLG 의 현재 기준가·기준가유형·기본정보를 꽂는다
 *   - 기준가유형 목록      → 입력값이 실재하는 유형인지 판정하는 데 쓴다
 * 검증(validateRows)이 이 결과에 의존하므로 async:false 로 순서를 지킨다. */
function fillBeforeValues(sheet) {
	codeExists = {}; beforeByCode = {}; priceTypeSet = {}; priceTypeList = [];

	priceColSet = {};
	for (var i = 0; i < priceColNames.length; i++) { priceColSet[priceColNames[i]] = true; }

	var codes = [];
	for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
		var code = kepTrimStr(sheet.GetCellValue(r, "CMS_CATLG_ID"));
		if (code != "") { codes.push(code); }
	}
	if (codes.length == 0) { return true; }

	var ok = false;
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mdcm/getMasterMdCmCmsBasePriceBeforeList.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: { codes: codes.join("@") },
		async: false,
		success: function( response ) {
			var rows = (response && response.data) ? response.data : [];
			for (var i = 0; i < rows.length; i++) {
				var id = kepTrimStr(rows[i].CMS_CATLG_ID);
				beforeByCode[id] = rows[i];
				codeExists[id] = true;
			}
			priceTypeList = (response && response.types) ? response.types : [];
			for (var i = 0; i < priceTypeList.length; i++) { priceTypeSet[kepTrimStr(priceTypeList[i])] = true; }

			/* 각 행에 현재값을 꽂는다. 없는 코드(codeExists 미등록)는 공백 그대로 두고 검증이 잡는다.
			 * ⚠ 상품 기본정보(품목명~단위)는 **엑셀 값이 아니라 DB 현재값**으로 덮는다 —
			 *   양식에서 손댔더라도 결과 화면은 실제 대상 상품을 보여 줘야 한다. */
			for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
				var row = beforeByCode[kepTrimStr(sheet.GetCellValue(r, "CMS_CATLG_ID"))];
				if (!row) { continue; }
				for (var key in row) {
					if (!row.hasOwnProperty(key) || !priceColSet[key]) { continue; }
					if (key == "CMS_CATLG_ID") { continue; }
					sheet.SetCellValue(r, key, (row[key] == null) ? "" : row[key], 0);
				}
			}
			ok = true;
		},
		error: function( response ) {
			alert("기존 값을 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.");
		}
	});
	return ok;
}

/* ── 검증 ──────────────────────────────────────────────────
 * 오류사유 4종 + 행 자체가 무효인 경우(코드 미입력·미존재)를 앞에 둔다.
 * ⚠ [기존]값 대조는 fillBeforeValues 가 먼저 돌아야 성립한다. */
function validateRows() {
	var sheet = sheetPrice;
	cnt = {all:0, ok:0, err:0, down:0};

	var seen = {};	// 상품정보코드 중복 판정용 (코드 → 최초 등장 No.)
	var no = 0;

	for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
		no++;
		applyRate(sheet, r);					// 인상/인하·변동률은 판정과 무관하게 먼저 채운다
		var msg = checkPriceRow(sheet, r, seen, no);

		sheet.SetCellValue(r, "RESULT",     (msg == "") ? "정상" : "오류", 0);
		sheet.SetCellValue(r, "ERR_REASON", msg, 0);

		if (msg == "") {
			cnt.ok++;
			if (kepTrimStr(sheet.GetCellValue(r, "UPDOWN")) == "인하") { cnt.down++; }
		} else {
			cnt.err++;
		}
		cnt.all++;
	}
}

/* 인상/인하 · 변동률.
 * 변동률(%) = (변경기준가 - 기존기준가) / 기존기준가 × 100, 소수점 한자리 반올림.
 * + 는 '↑' 빨강, - 는 '↓' 파랑으로 표기한다(기호 대신 화살표).
 * ⚠ 기준가유형만 바꾼 행은 변동률이 없다 — 인상도 인하도 아니므로 즉시 반영 대상이다. */
function applyRate(sheet, r) {
	var before = sheet.GetCellValue(r, "PRICE_BEFORE");
	var after  = sheet.GetCellValue(r, "PRICE_AFTER");

	// 금액 표시는 콤마로 맞춘다(엑셀에서 6110 으로 와도 화면은 6,110)
	sheet.SetCellValue(r, "PRICE_BEFORE", kepNumToComma(before), 0);
	if (kepTrimStr(after) != "") { sheet.SetCellValue(r, "PRICE_AFTER", kepNumToComma(after), 0); }

	var res = kepRateChange(before, after);
	sheet.SetCellValue(r, "UPDOWN",   (res.up == null) ? "" : (res.up ? "인상" : "인하"), 0);
	sheet.SetCellValue(r, "CHG_RATE", res.text, 0);
	if (res.up != null) {
		sheet.SetCellFontColor(r, "CHG_RATE", res.up ? UP_TXT : DOWN_TXT);
		sheet.SetCellFontColor(r, "UPDOWN",   res.up ? UP_TXT : DOWN_TXT);
	}
}

/* 오류사유 4종. 먼저 걸린 것 하나만 돌려준다(행당 오류 1건).
 * 판정 순서는 '행 자체가 무효 → 입력 누락 → 값 규칙' 순이다(수정양식 checkModRow 와 같은 규약). */
function checkPriceRow(sheet, r, seen, no) {
	var code       = kepTrimStr(sheet.GetCellValue(r, "CMS_CATLG_ID"));
	var priceAfter = kepTrimStr(sheet.GetCellValue(r, "PRICE_AFTER"));
	var typeAfter  = kepTrimStr(sheet.GetCellValue(r, "PRICE_TYPE_AFTER"));
	var typeBefore = kepTrimStr(sheet.GetCellValue(r, "PRICE_TYPE_BEFORE"));
	var reason     = kepTrimStr(sheet.GetCellValue(r, "CHG_REASON"));

	// (a) 상품정보코드 미존재 — 4종에 없지만, 없는 코드를 '정상'으로 흘리면 안 되므로 먼저 막는다
	if (code == "")        { return "상품정보코드 미입력"; }
	if (!codeExists[code]) { return "상품정보코드 미존재"; }

	// 3. 동일한 상품정보코드
	if (seen[code]) { return "동일한 상품정보코드 (No." + seen[code] + "과 동일)"; }
	seen[code] = no;

	// 2. 변경 값 미존재 — 기준가·기준가유형 둘 다 비었으면 바꿀 것이 없다
	//    ⚠ 기준가유형은 '미입력 시 기존과 동일' 이라 단독 공란은 오류가 아니다(양식 2행 안내).
	if (priceAfter == "" && typeAfter == "") { return "변경 값 미존재"; }

	// (b) 금액 형식 — 숫자가 아니거나 0 이하면 반영할 수 없다
	if (priceAfter != "") {
		var n = kepParseNum(priceAfter);
		if (isNaN(n))  { return "기준가 형식 오류(숫자만 입력)"; }
		if (n <= 0)    { return "기준가는 0보다 커야 합니다"; }
	}

	// (c) 기준가유형 실재 — 드롭다운 밖의 값이 손입력될 수 있다
	if (typeAfter != "" && !priceTypeSet[typeAfter]) { return "기준가유형 미존재"; }

	// 1. 동일값(기존-변경) — 기준가·유형 어느 쪽도 실제로 바뀌지 않은 경우
	var priceSame = (priceAfter == "")
	             || (kepParseNum(priceAfter) == kepParseNum(kepTrimStr(sheet.GetCellValue(r, "PRICE_BEFORE"))));
	var typeSame  = (typeAfter == "") || (typeAfter == typeBefore);
	if (priceSame && typeSame) { return "동일값(기존-변경)"; }

	// 4. 변경사유 미입력
	// ⚠ 임시 해제 — 변경사유 List(ICOMCOD1 M184) 미수령이라 입력할 값이 없어 테스트가 막힌다.
	// List 를 받으면 아래 한 줄의 주석을 걷어낼 것.
	// if (reason == "") { return "변경사유 미입력"; }

	return "";
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
	// 오류·품의 상신 건이 있으면 그 사실을 문구로 알린다
	document.getElementById("resultAction").innerHTML =
		"오류 " + cnt.err + " 건을 제외한 " + cnt.ok + " 건이 반영되며, "
		+ cnt.ok + " 건 중 " + cnt.down + " 건(기준가 인하)은 품의가 상신됩니다.";
	document.getElementById("resultAsk").innerHTML = "아래 내용으로 시스템 반영하시겠습니까?";
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
	for (var r = sheetPrice.HeaderRows(); r <= sheetPrice.LastRow(); r++) {
		sheetPrice.SetRowHidden(r, matchKind(sheetPrice, r, kind) ? 0 : 1);
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

	sheetPrice.Down2Excel({
		 FileName : "기준가_일괄수정_업로드결과" + (errOnly ? "_오류건" : "") + ".xls"
		,Merge : 1
		,SheetDesign : 1
		,DownRows : "Visible"
		,DownCols : getPriceDownCols()
	});
}

// 상태 컬럼(sStatus)만 빼고 전 컬럼을 내려받는다.
function getPriceDownCols() {
	var arr = [];
	for (var i = 0; i < priceColNames.length; i++) {
		if (priceColNames[i] == "sStatus") { continue; }
		arr.push(priceColNames[i]);
	}
	return arr.join("|");
}

function restorePendingTab() {
	if (pendingTab == "") { return; }
	var keep = pendingTab;
	pendingTab = "";
	if (keep != curTab) { setResultTab(keep); }
}

function sheetPrice_OnDownFinish(downloadType, result) {
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
	// [기존]값 조회가 실패하면 동일값·기준가유형 실재를 판정할 수 없다 — 결과화면으로 넘어가지 않는다.
	if (!fillBeforeValues(sheet)) { return; }
	validateRows();

	curTab = "ALL";
	setResultTab("ALL");
	sheetPrice.Render();
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
			<h1 class="title" id="popTitle">일괄 업로드 결과 확인 (기준가 일괄수정)</h1>
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
							createIBSheet("sheetPrice", "100%", "320px");
						</script>
					</div>
					<p class="resNote">※ 오류 행은 [결과] 컬럼이 '오류'로 표시되며, [오류사유] 컬럼에 사유가 노출됩니다. 기준가 인상은 즉시 반영, 인하는 품의 상신 대상입니다.</p>
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
