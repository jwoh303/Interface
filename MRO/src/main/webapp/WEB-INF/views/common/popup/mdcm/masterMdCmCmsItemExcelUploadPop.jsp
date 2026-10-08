<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>상품정보 조회 및 관리 > 일괄업로드 버튼 클릭 시 팝업
* 화면 : (팝업) 일괄 업로드 **결과 확인** (상품정보 일괄수정)
* 기능 : 양식 다운로드/업로드는 **목록 화면(masterMdCmCmsItemList) 하단 바**가 맡는다.
*        이 팝업은 목록이 엑셀을 파싱한 뒤에만 열리며, 결과 확인만 한다.
*        - 목록이 파싱해 둔 행(`opener.mdcmUploadRows`)을 받아 → [기존]값 서버조회 → 검증 → 결과 표시
*        - 유형선택조회(타일 탭) + 결과/오류항목/오류사유 + 전체·오류 건 다운로드
*        - 그리드 컬럼 정의는 목록과 공유 : /resources/js/mdcm/cmsItemModForm.js
* 담당자 : 홍준우
* 착수일 : 2026-06-24 (개편 2026-08-05 · 결과전용 전환 2026-08-31)
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
<!-- 일괄수정 그리드 컬럼·엑셀 열 정의 (목록 화면과 공유) -->
<script src="/resources/js/mdcm/cmsItemModForm.js" type="text/javascript"></script>
</head>
<script type="text/javascript">
var sheetMod = new ibsheetObject();		// 일괄수정 결과 그리드
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var current_page = -1;
var uploadKind = "MOD";		// 결과 종류. 이 팝업은 일괄수정 전용이지만, 문구·다운로드 분기가 이 값을 읽는다.
var curTab = "ALL";			// 선택된 유형 타일
var modColNames = [];		// 수정 그리드 컬럼(SaveName) 순서 — ColumnMapping 생성용
var cnt = {all:0, ok:0, err:0};	// 유형별 건수

// 양식 열 순서·대상 항목은 목록 화면과 공유한다 (cmsItemModForm.js) — 한쪽만 고치면 어긋난다.
var MOD_TARGETS = MDCM_MOD_TARGETS;

// 서버에서 받아온 [기존]값 조회 결과 — 업로드 직후 1회만 채운다.
var codeExists   = {};	// 상품정보코드 실재 여부 (업로드한 코드 → true)
var altCodeExists = {};	// 대체코드 실재 여부 (입력된 대체코드 → true)
var makerExists   = {};	// 제조사 변경코드 실재 여부 (ICOMCOD1 M104)
var makerNameMap  = {};	// 제조사 변경코드 → 명칭 (ICOMCOD1 M104 TEXT1)
var originExists  = {};	// 원산지 변경코드 실재 여부 (ICOMCOD1 M001)
var modColSet     = {};	// 그리드에 실제로 있는 컬럼(SaveName) — 서버 응답을 꽂기 전에 확인한다
var usedAttrCount = 0;	// 이번 업로드에서 쓰인 속성 쌍 개수 (뒤쪽 빈 속성 열을 접는 데 쓴다)

// 서버 [기존]값 컬럼 → 그리드 좌측 기본정보 컬럼. 16p 좌측 블록도 같은 조회로 함께 채운다.
var BEFORE_TO_BASE = { "DESCRIPTION_BEFORE":"DESCRIPTION_LOC", "MODEL_BEFORE":"MODEL_INFO"
                     , "SPEC_BEFORE":"SPECIFICATION",          "MAKER_BEFORE":"MAKER_NAME"
                     , "ORIGIN_BEFORE":"ORIGIN_CODE_NAME",     "MEASURE_BEFORE":"ORDER_MEASURE" };

// 항목별 사용 여부(MOD_TARGETS 와 같은 순서) — validateRows 가 채우고 applyModColFold 가 읽는다.
var modUsed     = [];
var showAllCols = false;	// [전체 항목 보기] 체크 상태

// 변경사유별 부가입력 규칙 — 대체코드가 필수인 사유는 '중복존재'(M182 DUP) 하나다.
// 양식 안내문도 `▶D열 "중복존재"일 경우 기재必` 로 이것만 지목한다.
var REASON_NEED_ALT = ["중복존재"];

// 창 크기는 **목록 화면이 팝업을 열 때** 정한다(openSearchPopup 인자, 고정값).
// 이 팝업은 열린 뒤 크기를 바꾸지 않는다 — 본문·그리드를 그 창에 맞출 뿐이다.
var curStep = "UPLOAD";		// 현재 단계 (창을 수동으로 늘렸을 때 본문 폭 재계산용)

// 그리드 높이 환산에 쓰는 상수
var GRID_HEADER_H = 26;		// 헤더 1행 높이 (수정 그리드는 2단 헤더)
var GRID_ROW_H    = 23;		// 데이터 1행 높이 (IBSheet 기본)
var GRID_HSCROLL  = 18;		// 가로 스크롤바 몫 — 폭 고정이라 항상 생긴다고 본다
var GRID_MIN_H    = 120;	// 데이터가 적어도 이보다 납작해지지 않게
var NON_GRID_H    = 250;	// 그리드 밖이 쓰는 세로 몫 — 기본값. RESULT 에서는 nonGridHeight()가 실측으로 대체한다
var SCREEN_MARGIN = 60;		// 창이 화면 밖으로 나가지 않게 남기는 여백
var BODY_MARGIN   = 8;		// 본문 우측 여유(세로 스크롤바 몫)
var FILL_MARGIN   = 6;		// 세로로 꽉 채울 때 스크롤바가 생기지 않게 남기는 여유

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	initSheetMod();
	loadFromOpener();		// 목록 화면이 파싱해 둔 행을 받아 곧바로 결과 확인으로 간다
}

/* 목록 화면(masterMdCmCmsItemList)이 LoadExcel 로 읽어 둔 행을 넘겨받는다.
 * 팝업은 이제 **업로드 이후에만** 열리므로 여기가 유일한 진입 경로다.
 * ⚠ 파일을 창 사이로 넘길 수 없어 파싱은 목록이 하고, 이쪽은 같은 출처 창의 JS 배열을 그대로 읽는다. */
function loadFromOpener() {
	uploadKind = "MOD";

	var rows = null;
	try { rows = opener.mdcmUploadRows; } catch (e) { rows = null; }

	if (!rows || rows.length == 0) {
		alert("업로드할 데이터가 없습니다.");
		self.close();
		return;
	}

	// 그리드에 적재 — 엑셀에 있던 열(MDCM_MOD_EXCEL_COLS)만 채우고 나머지는 검증 단계에서 채워진다.
	sheetMod.RemoveAll();
	for (var i = 0; i < rows.length; i++) {
		var r = sheetMod.DataInsert(-1);
		for (var c = 0; c < MDCM_MOD_EXCEL_COLS.length; c++) {
			var col = MDCM_MOD_EXCEL_COLS[c];
			var v = rows[i][col];
			sheetMod.SetCellValue(r, col, (v == null) ? "" : v, 0);
		}
	}

	afterLoadExcel(true, sheetMod);
}

function initSheetMod() {
	var initsheet = {};
	var cols = mdcmModCols();		// 정의는 cmsItemModForm.js (목록 화면과 공유)

	modColNames = mdcmModColNames();

	initsheet.Cols = cols;
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0, UseNoDataRow:1};
	IBS_InitSheet(sheetMod, initsheet, pagingMode);
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
		case "reg": // 확인(수정) — 정상 건만 수정요청으로 등록
			doRegRequest();
			break;
	}
}

/* ── 단계 전환 ─────────────────────────────────────────────
 * UPLOAD : 안내 + 4버튼 (목업엔 이 단계에 그리드가 없다)
 * RESULT : 요약문구 + 유형 타일 + 결과 그리드 + 다운로드/등록
 * ⚠ 숨겨진 시트에 Render()를 호출하지 않는다 — 호출당 헤더/푸터 사본이 누적된다.
 *   보이게 된 쪽에만 1회 호출한다. */
function showStep(step) {
	curStep = "RESULT";		// 이 팝업은 결과 확인 전용이다(업로드 단계 없음)

	// ⚠ 본문 높이를 재기 **전에** 그리드 밖 내용을 먼저 채운다 — 요약문구·타일이 비어 있을 때 재면
	//   그리드 밖 높이가 실제보다 작게 나와 그리드가 모자라게 잡힌다(nonGridHeight 가 DOM 실측이라서).
	drawTiles();

	fitBodyWidth();		// 창은 opener 가 열 때 정한 크기 그대로 — 본문을 그 창에 맞춘다
	fitGridHeight();
	curSheet().Render();
}

/* 그리드 밖(팝업헤더·요약문구·타일·안내문·버튼·여백)이 실제로 쓰는 세로 몫을 DOM 에서 잰다.
 * ⚠ 상수로 박아두면 요약 문구가 줄바꿈되거나 타일이 한 줄 더 접힐 때 그 만큼 그리드가 창 밖으로 밀린다.
 *   본문 전체 높이에서 그리드 박스 높이를 빼면, 그리드가 어떤 높이든 나머지 몫이 그대로 나온다. */
function nonGridHeight() {
	var wrap = document.getElementById("popWrapper");
	var box  = gridBoxEl();
	if (!wrap || !box) { return NON_GRID_H; }

	var h = wrap.offsetHeight - box.offsetHeight;
	if (isNaN(h) || h < 120) { return NON_GRID_H; }		// 아직 레이아웃 전이면 기본값
	return h;
}

function gridBoxEl() {
	return document.getElementById("DIV_sheetMod");
}

/* 결과 그리드에 필요한 높이 = 헤더 + 데이터 행 + 가로 스크롤바.
 * ⚠ 화면 높이를 넘지 않게 자른다 — 넘치는 행은 그리드 세로 스크롤로 남는다.
 * 행 수는 유형 타일 필터와 무관하게 **전체 기준**으로 잡는다(타일 클릭마다 창이 뛰지 않게). */
function wantGridHeight() {
	var headerRows = 2;		// 수정 그리드는 2단 헤더
	var rows = curSheet().RowCount();
	if (isNaN(rows) || rows < 0) { rows = 0; }

	var h = headerRows * GRID_HEADER_H + rows * GRID_ROW_H + GRID_HSCROLL;

	var max = screen.availHeight - SCREEN_MARGIN - nonGridHeight();
	if (isNaN(max) || max < GRID_MIN_H) { max = 520; }	// screen 정보를 못 읽는 환경 보호

	if (h < GRID_MIN_H) { h = GRID_MIN_H; }
	if (h > max)        { h = max; }
	return h;
}

/* 본문 폭 = **창 폭**. 본문을 컬럼 폭에 맞춰 늘리지 않는다 —
 * 늘리면 헤더·요약·버튼까지 함께 밀려 창 전체가 좌우로 움직인다.
 * 컬럼이 창보다 넓을 때는 그리드 안쪽 가로 스크롤로만 남는다. */
function fitBodyWidth() {
	var avail = document.documentElement.clientWidth - BODY_MARGIN;
	if (isNaN(avail) || avail < 320) { return; }
	document.getElementById("popWrapper").style.width = avail + "px";
}

/* 결과 그리드 높이 = **창에 남는 세로 공간을 전부 채운다**(그리드 밖 몫을 뺀 나머지).
 * ⚠ 폭과 같은 이유로 뒤집었다 — 행 수가 요구하는 높이를 상한으로 쓰면 3건짜리 결과에서
 *   창 아래쪽이 통째로 회색으로 남는다. 창 크기는 고정값이라 행 수는 이제 크기 계산에 쓰지 않는다. */
function fitGridHeight() {
	var box = gridBoxEl();
	if (!box) { return; }

	var avail = document.documentElement.clientHeight - nonGridHeight() - FILL_MARGIN;
	if (isNaN(avail) || avail < GRID_MIN_H) { avail = wantGridHeight(); }

	box.style.height = Math.max(GRID_MIN_H, avail) + "px";
}

/* 사용자가 창을 직접 늘리거나, 위 resizeTo 가 뒤늦게 반영돼도 본문 폭이 따라오게 한다.
 * 본문만 넓어지면 그리드는 옛 폭 그대로라 창 안에서 붕 뜬다 → 보이는 시트에 Render 로 폭을 다시 태운다.
 * ⚠ 숨은 시트에는 절대 호출하지 않는다(헤더/푸터 사본 누적) — RESULT 단계에서만 돈다. */
window.onresize = function() {
	fitBodyWidth();
	if (curStep == "RESULT") {
		fitGridHeight();
		curSheet().Render();
	}
};

function curSheet() { return sheetMod; }

/* ── [기존] 값 채우기 (일괄수정 전용) ────────────────────────
 * 업로드 직후 **1회만** 서버에 묻는다(행마다 부르지 않는다). 조회 전용 요청이다.
 *   - 업로드한 상품정보코드 → CMSCATLG 현재값을 *_BEFORE 와 좌측 기본정보 블록에 꽂는다
 *   - 입력된 대체코드      → 실재 여부만 받아 '대체코드 미존재' 판정에 쓴다
 * 검증(validateRows)이 이 결과에 의존하므로 async:false 로 순서를 지킨다(선례 : 상세분류 팝업 drillDown).
 */
function fillBeforeValues(sheet) {
	codeExists = {}; altCodeExists = {}; makerExists = {}; originExists = {};
	makerNameMap = {};

	// 서버 응답 키를 그리드에 꽂기 전에 실제 컬럼인지 확인한다(없는 SaveName 에 쓰면 조용히 어긋난다).
	modColSet = {};
	for (var i = 0; i < modColNames.length; i++) { modColSet[modColNames[i]] = true; }

	var codes = [], alts = [], makers = [], origins = [];
	for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
		var code   = kepTrimStr(sheet.GetCellValue(r, "CMS_CATLG_ID"));
		var alt    = kepTrimStr(sheet.GetCellValue(r, "ALT_CODE"));
		var maker  = kepTrimStr(sheet.GetCellValue(r, "MAKER_CODE_AFTER"));
		var origin = kepTrimStr(sheet.GetCellValue(r, "ORIGIN_CODE_AFTER"));
		if (code   != "") { codes.push(code); }
		if (alt    != "" && alt != "-") { alts.push(alt); }
		if (maker  != "") { makers.push(maker); }
		if (origin != "") { origins.push(origin); }
	}
	if (codes.length == 0 && alts.length == 0) { return true; }

	var ok = false;
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mdcm/getMasterMdCmCmsItemExcelUploadBeforeList.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: { codes: codes.join("@"), altCodes: alts.join("@")
		      , makerCodes: makers.join("@"), originCodes: origins.join("@") },
		async: false,
		success: function( response ) {
			var rows = (response && response.data) ? response.data : [];
			var map  = {};
			for (var i = 0; i < rows.length; i++) {
				var id = kepTrimStr(rows[i].CMS_CATLG_ID);
				map[id] = rows[i];
				codeExists[id] = true;
			}
			markExists(altCodeExists, response ? response.alt    : null);
			markExists(makerExists,   response ? response.maker  : null);
			markExists(originExists,  response ? response.origin : null);
			var mn = (response && response.makerName) ? response.makerName : [];
			for (var m = 0; m < mn.length; m++) { makerNameMap[kepTrimStr(mn[m].CODE)] = kepTrimStr(mn[m].NAME); }

			// 각 행에 현재값을 꽂는다. 없는 코드(codeExists 미등록)는 공백 그대로 두고 검증이 잡는다.
			// 서버가 돌려주는 키는 *_BEFORE(기존값) · ATTRn_NM(속성명) · ATTRn_BVAL(기존 속성값) 이다.
			for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
				var row = map[kepTrimStr(sheet.GetCellValue(r, "CMS_CATLG_ID"))];
				if (!row) { continue; }
				for (var key in row) {
					if (!row.hasOwnProperty(key) || !modColSet[key]) { continue; }
					if (key == "CMS_CATLG_ID") { continue; }
					sheet.SetCellValue(r, key, (row[key] == null) ? "" : row[key], 0);
				}
				// 좌측 기본정보 블록에도 현행값을 같이 채운다
				for (var beforeCol in BEFORE_TO_BASE) {
					if (!BEFORE_TO_BASE.hasOwnProperty(beforeCol)) { continue; }
					var v = (row[beforeCol] == null) ? "" : row[beforeCol];
					sheet.SetCellValue(r, BEFORE_TO_BASE[beforeCol], v, 0);
				}
				if (modColSet["MAKER_AFTER"]) {
					var mcode = kepTrimStr(sheet.GetCellValue(r, "MAKER_CODE_AFTER"));
					sheet.SetCellValue(r, "MAKER_AFTER", (mcode == "") ? "" : (makerNameMap[mcode] || ""), 0);
				}
				applySpecAfter(sheet, r);
			}
			ok = true;
		},
		error: function( response ) {
			alert("기존 값을 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.");
		}
	});
	return ok;
}

// 서버가 돌려준 '실재하는 코드' 배열 → 조회용 map
function markExists(target, list) {
	if (!list) { return; }
	for (var i = 0; i < list.length; i++) { target[kepTrimStr(list[i])] = true; }
}

/* 규격[변경] 파생 — 양식에 '규격 변경' 열이 없다. 속성값을 하나라도 고쳤을 때만 규격을 재조립한다.
 * 조합 규칙은 mdcmBuildSpec (cmsItemModForm.js) : 빈 값 제외, "; " 로 연결, 끝에 ";".
 * ⚠ 기존 속성값(ATTRn_BVAL)은 fillBeforeValues 가 먼저 꽂아야 성립한다 — 같은 루프에서 부른다. */
function applySpecAfter(sheet, r) {
	var changed = false;
	var vals = [];
	for (var i = 1; i <= MDCM_MOD_ATTR_COUNT; i++) {
		var v = kepTrimStr(sheet.GetCellValue(r, "ATTR" + i + "_VAL"));
		var b = kepTrimStr(sheet.GetCellValue(r, "ATTR" + i + "_BVAL"));
		if (v != b) { changed = true; }
		vals.push(v);
	}
	sheet.SetCellValue(r, "SPEC_AFTER", changed ? mdcmBuildSpec(vals) : "", 0);
}

/* ── 검증 ──────────────────────────────────────────────────
 * 일괄수정은 fillBeforeValues 가 채운 [기존]값·대체코드 실재 여부까지 보고 판정한다(오류사유 7종 전부).
 * 신규등록은 여전히 클라이언트 규칙(필수항목 누락)만 본다 — 상세분류별 필수값 대조는 후속. */
function validateRows() {
	var sheet = curSheet();
	cnt = {all:0, ok:0, err:0};

	var seen = {};	// 수정 : 상품정보코드 중복 판정용 (코드 → 최초 등장 No.)
	var no = 0;

	// 항목별 사용 여부는 이 루프에서 함께 모은다 — 접기 때문에 행을 다시 순회하지 않으려고.
	modUsed = [];
	for (var i = 0; i < MOD_TARGETS.length; i++) { modUsed.push(false); }
	usedAttrCount = 0;

	for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
		no++;
		var err = checkModRow(sheet, r, seen, no);

		sheet.SetCellValue(r, "RESULT",     (err.msg == "") ? "정상" : "오류", 0);
		sheet.SetCellValue(r, "ERR_REASON", err.msg, 0);
		sheet.SetCellValue(r, "ERR_COL", err.col, 0);

		if (err.msg == "") {
			cnt.ok++;
		} else {
			cnt.err++;
		}
		cnt.all++;

		for (var i = 0; i < MOD_TARGETS.length; i++) {
			if (!modUsed[i] && kepTrimStr(sheet.GetCellValue(r, MOD_TARGETS[i][0])) != "") { modUsed[i] = true; }
		}

		// 속성은 상품(상세분류)마다 개수가 달라 상수로 못 박는다 — 실제로 쓰인 마지막 쌍까지만 보여준다.
		for (var i = MDCM_MOD_ATTR_COUNT; i > usedAttrCount; i--) {
			if (kepTrimStr(sheet.GetCellValue(r, "ATTR" + i + "_NM")) != ""
			 || kepTrimStr(sheet.GetCellValue(r, "ATTR" + i + "_VAL")) != "") { usedAttrCount = i; break; }
		}
	}
}

/* ── 컬럼 접기 ─────────────────────────────────────────────
 * 가로 폭을 줄이려고 기본 상태에서 두 가지를 접는다. [전체 컬럼 보기] 로 한 번에 되돌린다.
 *   (1) 이번 업로드에 입력이 없는 항목 → [기존]·[변경] 쌍을 통째로
 *   (2) 모든 항목의 [기존] 열 → 현행값은 좌측 기본정보 블록(품목명~단위)에서 본다
 * ⚠ 여기서 Render() 를 부르지 않는다 — 호출 시점에 그리드가 아직 display:none 이고,
 *   숨김 상태 Render 는 헤더/푸터 사본이 누적된다.
 *   뒤이어 오는 showStep("RESULT") 이 보이게 만든 뒤 Render 1회를 책임진다.
 *   (SetColHidden 자체는 안전 — "헤더 어긋남" 진단은 반증됐다.) */
function applyModColFold() {
	// 안전장치 : 전 항목 미입력(전 행이 '변경 값 미존재' 오류)이면 항목 접기는 건너뛴다. 휑한 그리드 방지.
	var anyUsed = false;
	for (var i = 0; i < modUsed.length; i++) { if (modUsed[i]) { anyUsed = true; break; } }

	var specUsed = false;
	for (var i = 0; i < MOD_TARGETS.length; i++) {
		var foldItem = (!showAllCols && anyUsed && !modUsed[i]);
		var group    = MOD_TARGETS[i][2];
		for (var j = 0; j < group.length; j++) {
			var col  = group[j];
			var hide = foldItem || (!showAllCols && isBeforeCol(col));
			sheetMod.SetColHidden(col, hide);
		}
		if (MOD_TARGETS[i][0] == "SPEC_AFTER") { specUsed = modUsed[i]; }
	}

	/* 속성 열은 26개(13쌍)라 전부 펼치면 그리드가 화면을 크게 넘는다.
	 * 규격이 바뀐 업로드일 때만, 그중에서도 실제로 쓰인 쌍까지만 보여준다.
	 * ⚠ ATTRn_BVAL(기존 속성값)은 판정용 내부 컬럼이라 **어떤 경우에도 펼치지 않는다.** */
	for (var i = 1; i <= MDCM_MOD_ATTR_COUNT; i++) {
		var showAttr = showAllCols ? (i <= Math.max(usedAttrCount, 1))
		                           : (specUsed && i <= usedAttrCount);
		sheetMod.SetColHidden("ATTR" + i + "_NM",  !showAttr);
		sheetMod.SetColHidden("ATTR" + i + "_VAL", !showAttr);
	}

	var wrap = document.getElementById("foldToggleWrap");
	if (wrap) { wrap.style.display = "inline-block"; }
}

// [기존] 열 판별 — 컬럼군의 SaveName 접미사가 _BEFORE 인 것들(STATUS_BEFORE 포함)
function isBeforeCol(col) { return /_BEFORE$/.test(col); }

/* 접힌 항목명 목록 — 안내 문구용. 접기 조건은 applyModColFold 와 같아야 한다. */
function foldedNames() {
	var arr = [];
	if (showAllCols) { return arr; }

	var anyUsed = false;
	for (var i = 0; i < modUsed.length; i++) { if (modUsed[i]) { anyUsed = true; break; } }
	if (!anyUsed) { return arr; }

	for (var i = 0; i < MOD_TARGETS.length; i++) {
		if (!modUsed[i]) { arr.push(MOD_TARGETS[i][1]); }
	}
	return arr;
}

/* [전체 항목 보기] 토글 — 접기를 되돌리고 본문·그리드를 다시 맞춘다(창 크기는 건드리지 않는다).
 * 이 시점엔 결과 그리드가 보이는 상태라 Render() 가 안전하다. */
function toggleShowAllCols() {
	var chk = document.getElementById("chkShowAllCols");
	showAllCols = (chk && chk.checked);

	applyModColFold();
	drawTiles();

	fitBodyWidth();
	fitGridHeight();
	sheetMod.Render();
}

/* ── [확인] : 정상 행을 수정요청으로 등록 ─────────────
 * 상품 1건 = 요청 1건. 행에서 [변경] 이 채워진 항목만 골라 변경항목으로 만든다.
 * ★ JOB_COLUMN 은 CMSCATLG 컬럼명 그대로다 - 승인 처리가 UPDATE CMSCATLG SET <JOB_COLUMN> 으로 쓴다.
 * ★ 제조사·원산지는 반영 축이 **코드**라 코드 열을 보낸다(양식 2행 '▼미반영').
 * ★ 상품상태·상품구분·TR·상품상태 변경사유는 그리드가 **명칭**만 들고 있다 - 코드 복원은 서버가 한다
 *   (DaoImpl#insertChangeReqFromExcel). 화면에서 접으면 규칙이 두 곳으로 갈린다.
 * ★ 파라미터는 JSON 문자열 하나로 보낸다 - 항목마다 펼치면 1,000행에서 파라미터 수 상한에 걸린다. */
var MDCM_REG_MAP = [
	 ["STATUS_AFTER",		"STATUS",			"STATUS_BEFORE",		"CHG_REASON"]
	,["DESCRIPTION_AFTER",	"DESCRIPTION_LOC",	"DESCRIPTION_BEFORE",	"DESCRIPTION_REASON"]
	,["MODEL_AFTER",		"MODEL_INFO",		"MODEL_BEFORE",			"MODEL_REASON"]
	,["MAKER_CODE_AFTER",	"MAKER_CODE",		"MAKER_CODE_BEFORE",	"MAKER_REASON"]
	,["ORIGIN_CODE_AFTER",	"ORIGIN_CODE",		"ORIGIN_CODE_BEFORE",	"ORIGIN_REASON"]
	,["MEASURE_AFTER",		"ORDER_MEASURE",	"MEASURE_BEFORE",		"MEASURE_REASON"]
	,["ITEM_GUBUN_AFTER",	"ITEM_GUBUN",		"ITEM_GUBUN_BEFORE",	"ITEM_GUBUN_REASON"]
	,["TR_AFTER",			"TR_HANDLE_TYPE",	"TR_BEFORE",			"TR_REASON"]
	,["SPEC_AFTER",			"SPECIFICATION",	"SPEC_BEFORE",			"SPEC_REASON"]
];

function doRegRequest() {
	var sheet = curSheet();
	var items = [];
	var rows  = 0;

	for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
		if (kepTrimStr(sheet.GetCellValue(r, "RESULT")) != "정상") { continue; }

		var code = kepTrimStr(sheet.GetCellValue(r, "CMS_CATLG_ID"));
		if (code == "") { continue; }

		var picked = 0;
		for (var i = 0; i < MDCM_REG_MAP.length; i++) {
			var after = kepTrimStr(sheet.GetCellValue(r, MDCM_REG_MAP[i][0]));
			if (after == "") { continue; }

			items.push({
				 c : code
				,k : MDCM_REG_MAP[i][1]
				,o : kepTrimStr(sheet.GetCellValue(r, MDCM_REG_MAP[i][2]))
				,n : after
				,r : kepTrimStr(sheet.GetCellValue(r, MDCM_REG_MAP[i][3]))
				// 대체코드는 상품상태 행에만 붙는다(변경사유가 '중복존재'일 때만 값이 있다)
				,a : ("STATUS" == MDCM_REG_MAP[i][1]) ? kepTrimStr(sheet.GetCellValue(r, "ALT_CODE")) : ""
			});
			picked++;
		}
		if (picked > 0) { rows++; }
	}

	if (rows == 0) { alert("등록할 정상 건이 없습니다."); return; }
	if (!confirm(rows + "건을 수정요청으로 등록합니다. 진행할까요?")) { return; }

	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mdcm/saveMasterMdCmCmsItemChangeReqBulk.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: { st_items: JSON.stringify(items) },
		success: function( response ) {
			alert(response.Message);
			if (response.Result && response.Result.Code == 1) {
				// 목록 화면을 다시 조회해 요청 상태를 반영한다(그 화면에 함수가 있을 때만)
				try { if (opener && opener.doAction) { opener.doAction('search'); } } catch (e) { }
				window.close();
			}
		},
		error: function( response ) {
			alert("수정요청 등록에 실패하였습니다. 잠시 후 다시 시도해 주세요.");
		}
	});
}

/* 판정 결과 : col = [오류항목] 컬럼에 찍을 항목명, msg = [오류사유] 문구 */
function errAt(col, msg) { return {col:col, msg:msg}; }

/* 수정 : 오류사유 7종. 한 행에 여러 건이 걸리면 **전부** 모아 " / " 로 이어 붙인다.
 * (2026-09-15 : 종전에는 먼저 걸린 것 하나만 돌려줘 뒤 판정이 가려졌다 —
 *  제조사코드 미존재가 대체코드 미입력보다 앞 순서라 대체코드 쪽이 보이지 않았다.)
 * 판정 순서는 '행 자체가 무효 → 입력 누락 → 값 규칙' 순이다.
 * ⚠ 앞 4건(코드 미입력·미존재·중복, 변경 값 미존재)만은 그 자리에서 끊는다 —
 *   뒤 판정의 전제라, 실재하지 않는 코드나 아무것도 안 고친 행에 동일값·대체코드를 따질 수 없다.
 * ⚠ 기존값 대조(동일값)·대체코드 실재 확인은 fillBeforeValues 가 먼저 돌아야 성립한다. */
function checkModRow(sheet, r, seen, no) {
	var code   = kepTrimStr(sheet.GetCellValue(r, "CMS_CATLG_ID"));
	var reason = kepTrimStr(sheet.GetCellValue(r, "CHG_REASON"));
	var alt    = kepTrimStr(sheet.GetCellValue(r, "ALT_CODE"));

	// 이 행에서 걸린 오류를 순서대로 쌓는다. [오류항목]·[오류사유] 두 컬럼이 같은 순서로 짝을 이룬다.
	var errCols = [], errMsgs = [];
	function addErr(col, msg) { errCols.push(col); errMsgs.push(msg); }

	// (a) 상품정보코드 미존재 — 7종에 없지만, 없는 코드를 '정상'으로 흘리면 안 되므로 먼저 막는다
	if (code == "")            { return errAt("상품정보코드", "상품정보코드 미입력"); }
	if (!codeExists[code])     { return errAt("상품정보코드", "상품정보코드 미존재"); }

	// 3. 동일한 상품정보코드
	if (seen[code]) { return errAt("상품정보코드", "동일한 상품정보코드 (No." + seen[code] + "과 동일)"); }
	seen[code] = no;

	// 제조사·원산지는 코드로만 받는다 - 양식에 [변경](명) 칸이 없다.
	var makerAfter  = kepTrimStr(sheet.GetCellValue(r, "MAKER_CODE_AFTER"));
	var originAfter = kepTrimStr(sheet.GetCellValue(r, "ORIGIN_CODE_AFTER"));

	// 2. 변경 값 미존재 — 수정 대상 항목의 [변경] 열이 하나도 채워지지 않은 경우
	var changed = false;
	for (var i = 0; i < MOD_TARGETS.length; i++) {
		if (kepTrimStr(sheet.GetCellValue(r, MOD_TARGETS[i][0])) != "") { changed = true; break; }
	}
	if (!changed) { return errAt("변경", "변경 값 미존재"); }

	// 1. 동일값(기존-변경) — 채워 넣은 [변경] 이 [기존] 과 같으면 그 항목은 무의미한 입력이다
	// ⚠ 비교 기준은 MOD_TARGETS[i][3] 이다 — 제조사·원산지는 반영 축이 "코드"라 비교도 코드 열끼리 한다.
	// ⚠ 규격은 재조립 결과에 끝 ';' 가 붙어 [기존](DB 실값)과 표기가 다르다 → mdcmNormSpec 으로 정규화 후 비교.
	for (var i = 0; i < MOD_TARGETS.length; i++) {
		var after = kepTrimStr(sheet.GetCellValue(r, MOD_TARGETS[i][0]));
		if (after == "") { continue; }
		var before = kepTrimStr(sheet.GetCellValue(r, MOD_TARGETS[i][3]));
		if (mdcmNormSpec(after) == mdcmNormSpec(before)) { addErr(MOD_TARGETS[i][1], "동일값(기존-변경)"); }
	}

	// 실재하지 않는 코드는 반영할 수 없다
	if (makerAfter  != "" && !makerExists[makerAfter])   { addErr("제조사", "제조사코드 미존재"); }
	if (originAfter != "" && !originExists[originAfter]) { addErr("원산지", "원산지코드 미존재"); }

	// 7. 변경사유 미입력 — 상품상태를 바꾸는 행에만 해당(13p : 상품상태 변경 시 사유 선택)
	var statusAfter = kepTrimStr(sheet.GetCellValue(r, "STATUS_AFTER"));
	if (statusAfter != "" && reason == "") { addErr("상품상태", "변경사유 미입력"); }

	// 대체코드 규칙은 상품상태 변경사유에만 걸린다
	var needAlt = false;
	for (var i = 0; i < REASON_NEED_ALT.length; i++) {
		if (REASON_NEED_ALT[i] == reason) { needAlt = true; break; }
	}
	// 4. 변경사유-대체코드 값 불일치 / 5. 대체코드 미입력 / 6. 대체코드 미존재
	if (needAlt && alt == "")                 { addErr("대체코드", "대체코드 미입력"); }
	if (!needAlt && alt != "" && alt != "-")  { addErr("대체코드", "변경사유-대체코드 값 불일치"); }
	if (needAlt && alt != "" && !altCodeExists[alt]) { addErr("대체코드", "대체코드 미존재"); }
	if (needAlt && alt == code)               { addErr("대체코드", "대체코드가 상품정보코드와 동일"); }

	// 오류가 없으면 두 배열 모두 비어 있어 join 결과가 "" 다 — 그대로 '정상' 판정으로 흘러간다.
	return errAt(errCols.join(" / "), errMsgs.join(" / "));
}

/* ── 유형 타일(탭) ────────────────────────────────────────── */
function drawTiles() {
	// 라벨·문구는 설계서 그대로 : 타일 '정상/오류' = 그리드 [결과] 값과 같은 말을 쓴다.
	var html = "";
	html += tileHtml("ALL", "전체", cnt.all);
	html += tileHtml("OK",  "정상", cnt.ok);
	html += tileHtml("ERR", "오류", cnt.err);
	document.getElementById("tileArea").innerHTML = html;

	document.getElementById("resultSummary").innerHTML =
		"전체 " + cnt.all + " 건 (정상 " + cnt.ok + " 건, 오류 " + cnt.err + " 건)";
	document.getElementById("resultAction").innerHTML  =
		"오류 " + cnt.err + " 건을 제외한 " + cnt.ok + " 건이 요청됩니다.";
	document.getElementById("resultAsk").innerHTML     = "아래 내용으로 변경 요청하시겠습니까?";
	document.getElementById("btnReg").innerHTML = "요청";

	// 무엇을 접었는지 알려준다 — 컬럼이 왜 안 보이는지 사용자가 알 수 있게
	var foldNote = document.getElementById("foldNote");
	if (foldNote) {
		var txt = "";
		if (!showAllCols) {
			var folded = foldedNames();
			txt = (folded.length == 0)
				? "※ 각 항목의 [기존] 열은 접었습니다."
				: "※ 각 항목의 [기존] 열과, 변경 값이 없는 [" + folded.join(", ") + "] 항목은 접었습니다.";
		}
		foldNote.innerHTML = txt;
	}
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
	var sheet = curSheet();
	for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
		sheet.SetRowHidden(r, matchKind(sheet, r, kind) ? 0 : 1);
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
	var sheet = curSheet();

	pendingTab = curTab;
	setResultTab(errOnly ? "ERR" : "ALL");
	loader_obj("Y");

	var opt = {
		 FileName : "상품정보_일괄수정_업로드결과" + (errOnly ? "_오류건" : "") + ".xls"
		,Merge : 1
		,SheetDesign : 1
		,DownRows : "Visible"
	};
	// 수정 : 화면에서 접은 컬럼도 파일엔 담는다 — 다운로드가 화면 축약에 끌려가지 않게.
	opt.DownCols = getModDownCols();

	sheet.Down2Excel(opt);
}

// 수정 결과 다운로드 컬럼 — 접힘과 무관하게 전 컬럼.
// 상태(sStatus)와 판정용 내부 컬럼(ATTRn_BVAL)은 뺀다.
function getModDownCols() {
	var arr = [];
	for (var i = 0; i < modColNames.length; i++) {
		var col = modColNames[i];
		if (col == "sStatus" || /_BVAL$/.test(col)) { continue; }
		arr.push(col);
	}
	return arr.join("|");
}

function restorePendingTab() {
	if (pendingTab == "") { return; }
	var keep = pendingTab;
	pendingTab = "";
	if (keep != curTab) { setResultTab(keep); }
}

function sheetMod_OnDownFinish(downloadType, result) {
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
	// [기존]값 조회가 실패하면 동일값·대체코드 미존재를 판정할 수 없다 — 결과화면으로 넘어가지 않는다.
	if (!fillBeforeValues(sheet)) { return; }
	validateRows();

	// 접기는 showStep 보다 **먼저** — 안내 문구(drawTiles)가 접힌 결과를 보고 정해진다.
	showAllCols = false;
	var chk = document.getElementById("chkShowAllCols");
	if (chk) { chk.checked = false; }
	applyModColFold();

	curTab = "ALL";
	showStep("RESULT");
	setResultTab("ALL");
}
</script>

<style>
.PopGuide{ display:block; margin:4px 0 6px; color:#444; font-size:13px; }
/* overflow:hidden 으로 fl/fr 플로트 버튼을 바 안에 가둠 */
.upBar{ background-color:#fff; border:1px solid #e0e0e0; border-radius:5px; padding:10px 12px; margin-bottom:8px; overflow:hidden; text-align:center; }
/* 좌우 대칭 여백이라야 두 묶음이 가운데 정렬됐을 때 균형이 맞는다 */
.upBar .formSet{ display:inline-block; margin:0 15px; vertical-align:top; }
.upBar .formSet .setTitle{ display:block; margin-bottom:4px; font-weight:bold; color:#333; }
/* 결과 유형 타일(탭). 본문이 창 폭을 채우므로 타일을 좁힐 이유가 없다 — 원래 크기를 쓴다. */
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
/* 결과화면 블록(요약 / 그리드) 공통 여백 */
.resBox{ background-color:#fff; border-radius:5px; padding:10px 12px; }
.resBox.mb{ margin-bottom:10px; }
.resNote{ margin:6px 0 0; color:#888; }
.foldBar{ margin:6px 0 0; font-size:12px; }
.foldBar label{ cursor:pointer; color:#444; vertical-align:middle; }
.foldBar input{ vertical-align:middle; margin:0 3px 2px 0; }
.foldNote{ margin-left:8px; color:#888; }
</style>

<body onLoad="kep_onload_view()">
	<!-- 결과 전용 팝업. 창 크기는 목록 화면이 열 때 정하고, 여기서는 본문을 그 창에 맞춘다 -->
	<div id="popWrapper" style="width:calc(100% - 8px);">
		<div id="popHeader">
			<h1 class="title" id="popTitle">일괄 업로드 결과 확인 (상품정보 일괄수정)</h1>
			<p class="popClose"><a href="javascript:self.close()">
				<img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
			</a></p>
		</div>

		<!--팝업내용입니다-->
		<div id="popContainer" style="background-color:#f5f5f5">

			<!--AJAX 조회용 hidden form-->
			<form name="searchCondition" id="searchCondition" method="post">
				<input type="hidden" name="s_SAVENAME">
			</form>

			<!--============ 업로드 결과 확인 ============-->
			<div id="stepResult">

				<div class="resBox mb">
					<span class="resSummary" id="resultSummary"></span>
					<span class="resAction"  id="resultAction"></span>
					<span class="resAsk"     id="resultAsk"></span>
					<div id="tileArea"></div>

					<!--수정 결과 : [기존] 열과 변경 값 없는 항목은 접혀 있다. 여기서 되돌린다-->
					<div class="foldBar">
						<label id="foldToggleWrap" style="display:none;">
							<input type="checkbox" id="chkShowAllCols" onclick="toggleShowAllCols();"> 전체 컬럼 보기
						</label>
						<span class="foldNote" id="foldNote"></span>
					</div>
				</div>

				<!--결과 그리드 : 신규 / 수정 중 해당하는 하나만 노출-->
				<div class="resBox">
					<div id="gridModBox">
						<div class="ib_product" style="border-top:2px solid #3c639c">
							<script type="text/javascript">
								createIBSheet("sheetMod", "100%", "280px");
							</script>
						</div>
					</div>
					<p class="resNote">※ 오류 행은 [결과] 컬럼이 '오류'로 표시되며, [오류항목]·[오류사유] 컬럼에 해당 항목과 사유가 함께 노출됩니다.</p>
				</div>

				<!--하단 버튼 : 좌(전체·오류 건 다운로드) / 우(이전으로·등록)-->
				<div class="btnArea mt05">
					<span class="fl">
						<span class="btn_09 mr04"><a href="javascript:doAction('resultDownAll');">전체 다운로드</a></span>
						<span class="btn_09"><a href="javascript:doAction('resultDownErr');">오류 건 다운로드</a></span>
					</span>
					<!-- 결과 확인 후 다시 올리려면 창을 닫고 새로 연다(업로드 화면으로 되돌아가지 않음) -->
					<span class="fr">
						<span class="btn_02 mr04"><a href="javascript:doAction('reg');" id="btnReg">요청</a></span>
						<span class="btn_02"><a href="javascript:self.close();">닫기</a></span>
					</span>
				</div>
			</div>
			<br>
		</div>
	</div>
</body>
</html>
