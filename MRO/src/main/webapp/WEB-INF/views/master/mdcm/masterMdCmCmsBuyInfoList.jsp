<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>구매정보 조회 및 관리
* 화면 : 구매정보 조회 및 관리
* 기능 : 상품정보 + 구매정보 통합 조회/관리. 구매정보코드 클릭 시 구매정보 상세 팝업
* 담당자 : 홍준우
* 착수일 : 2026-06-25 (개편 2026-08-06 · 2026-09-08 · 2026-09-11)
**********************************************
--%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String userId         = sessionInfo.getUserId();
%>

<script src="/resources/js/common.js"></script>
<!-- 구매정보 등록 양식 컬럼·엑셀 열 정의 (결과 팝업과 공유) -->
<script src="/resources/js/mdcm/cmsBuyInfoRegForm.js"></script>
<!-- 구매정보 수정 양식 컬럼·엑셀 열 정의 (결과 팝업과 공유) -->
<script src="/resources/js/mdcm/cmsBuyInfoModForm.js"></script>
<!-- 고객사 매핑변경 양식 컬럼·엑셀 열 정의 (결과 팝업과 공유) -->
<script src="/resources/js/mdcm/cmsBuyInfoMapForm.js"></script>
<!-- 구매정보코드 순번↔전체코드 변환 -->
<script src="/resources/js/mdcm/buyInfoCode.js"></script>
<!-- 양식 대조 : 올린 파일이 그 화면의 양식이 맞는지 확인 -->
<script src="/resources/js/mdcm/excelFormCheck.js"></script>
<script>
var mySheet = new ibsheetObject();
var regSheet = new ibsheetObject();	// 화면에 안 보이는 시트 — 등록양식 업로드 전담
var modSheet = new ibsheetObject();	// 화면에 안 보이는 시트 — 수정양식 업로드 전담
var mapSheet = new ibsheetObject();	// 화면에 안 보이는 시트 — 매핑변경양식 업로드 전담
var mdcmRegRows = null;				// LoadExcel 로 읽은 행. 결과 팝업이 opener 로 읽어 간다
var mdcmModbRows = null;			// 수정양식에서 읽은 행. 수정 결과 팝업이 opener 로 읽어 간다
var mdcmMapRows  = null;			// 매핑변경양식에서 읽은 행. 매핑변경 결과 팝업이 opener 로 읽어 간다
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";		// 조회조건 팝업 분기값 (setPopupReturn 에서 사용)

/* 양식 1회 다운로드 상한. 서버가 POI(XSSF)로 워크북을 통째로 메모리에 만든다.
 * ⚠ 이 값을 올릴 때는 서버(MasterMdCmCmsBuyInfoExcelUploadController.REG_FORM_MAX_ROWS)도 같이 올려야 한다. */
var REG_FORM_MAX_ROWS = 1000;

/* 양식 업로드 1회 상한. 화면에서만 막는다 — 서버(LoadExcel.jsp setMaxRows)는 30000 이라 여기를 풀면 그대로 통과한다. */
var EXCEL_UP_MAX_ROWS = 5000;

/* 조회결과 엑셀다운로드 1회 상한. 화면에서만 막는다 — 서버 라우트는 열려 있다. */
var EXCEL_DOWN_MAX_ROWS = 5000;

/* ── 양식 다운로드 로딩바 ──
 * 다운로드는 숨은 iframe 으로 받기 때문에 공통 ajax 로더(loader_obj)가 자동으로 걸리지 않는다.
 * 게다가 attachment 응답은 iframe 을 이동시키지 않아 onload 도 오지 않는다.
 * → 1회용 토큰을 같이 보내고, 서버가 응답에 심어 주는 쿠키(mroDownToken)가 그 토큰이 되면 내린다. */
var FORM_DOWN_TOKEN  = null;
var formDownTimer    = null;
var formDownGiveUp   = null;
var FORM_DOWN_LIMIT  = 300 * 1000;

function formDownStart() {
	FORM_DOWN_TOKEN = "t" + new Date().getTime() + "" + Math.floor(Math.random() * 100000);
	// 등록양식·수정양식·매핑변경양식이 같은 iframe·쿠키 규약을 쓴다 — 어느 쪽이 submit 되든 토큰은 하나다
	$("#regFormToken").val(FORM_DOWN_TOKEN);
	$("#modFormToken").val(FORM_DOWN_TOKEN);
	$("#mapFormToken").val(FORM_DOWN_TOKEN);

	loader_obj("Y");
	formDownTimer  = setInterval(formDownCheck, 300);
	formDownGiveUp = setTimeout(function() {
		formDownEnd();
		alert("양식 생성이 지연되고 있습니다. 잠시 후 다시 시도하거나, 선택 건수를 줄여 주세요.");
	}, FORM_DOWN_LIMIT);
}

function formDownCheck() {
	if (FORM_DOWN_TOKEN == null) { return; }
	if (document.cookie.indexOf("mroDownToken=" + FORM_DOWN_TOKEN) < 0) { return; }
	formDownEnd();
}

function formDownEnd() {
	if (formDownTimer  != null) { clearInterval(formDownTimer);  formDownTimer  = null; }
	if (formDownGiveUp != null) { clearTimeout(formDownGiveUp);  formDownGiveUp = null; }
	FORM_DOWN_TOKEN = null;
	// 다음 다운로드가 이전 신호를 보고 바로 끝났다고 착각하지 않도록 쿠키를 지운다
	document.cookie = "mroDownToken=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT";
	loader_obj("N");
}

/* 등록양식 업로드 전용 숨은 시트. 화면에 안 보이지만 LoadExcel 이 시트를 요구하므로 실체가 있어야 한다.
 * 컬럼 정의는 결과 팝업과 공유한다(cmsBuyInfoRegForm.js) — 한쪽만 고치면 엑셀 열이 어긋난다. */
function initRegSheet() {
	var initsheet = {};
	initsheet.Cols = mdcmRegCols();
	initsheet.Cfg  = {MergeSheet:msHeaderOnly, FrozenCol:0, UseNoDataRow:1};
	IBS_InitSheet(regSheet, initsheet, "N");
}

/* 수정양식 업로드 전용 숨은 시트. regSheet 와 같은 이유로 실체가 있어야 한다.
 * 컬럼 정의는 수정 결과 팝업과 공유한다(cmsBuyInfoModForm.js). */
function initModSheet() {
	var initsheet = {};
	initsheet.Cols = mdcmModbCols();
	initsheet.Cfg  = {MergeSheet:msHeaderOnly, FrozenCol:0, UseNoDataRow:1};
	IBS_InitSheet(modSheet, initsheet, "N");
}

/* 매핑변경양식 업로드 전용 숨은 시트. regSheet 와 같은 이유로 실체가 있어야 한다. */
function initMapSheet() {
	var initsheet = {};
	initsheet.Cols = mdcmMapCols();
	initsheet.Cfg  = {MergeSheet:msHeaderOnly, FrozenCol:0, UseNoDataRow:1};
	IBS_InitSheet(mapSheet, initsheet, "N");
}

function mapSheet_OnLoadFileCancel() {
	loader_obj("N");
}

/* 매핑변경양식 업로드(LoadExcel) 후처리 — 등록·수정 양식과 같은 규약이다. */
function mapSheet_OnLoadExcel(result) {
	loader_obj("N");
	if (!result) {
		alert("엑셀 로딩 중 오류가 발생하였습니다.");
		return;
	}
	if (mapSheet.RowCount() == 0) {
		alert("업로드할 데이터가 없습니다.");
		return;
	}

	if (!mdcmFormCheck(mapSheet, MDCM_MAP_DATA_START_ROW, MDCM_MAP_EXCEL_COLS, MDCM_MAP_FORM_HEAD, "구매정보 고객사 매핑변경")) {
		mapSheet.RemoveAll();
		return;
	}

	/* 엑셀 사용범위에는 값을 지운 자리가 빈 행으로 남는다 - 그대로 읽으면 오류로 잡힌다.
	   모든 열이 빈 행은 담지 않는다. */
	var rows = [];
	for (var r = mdcmFormFirstDataRow(mapSheet, MDCM_MAP_DATA_START_ROW); r <= mapSheet.LastRow(); r++) {
		var row = {};
		var filled = false;
		for (var c = 0; c < MDCM_MAP_EXCEL_COLS.length; c++) {
			var col = MDCM_MAP_EXCEL_COLS[c];
			var v = mapSheet.GetCellValue(r, col);
			row[col] = v;
			if (!filled && $.trim((v == null) ? "" : ("" + v)) != "") { filled = true; }
		}
		if (filled) { rows.push(row); }
	}

	if (rows.length == 0) {
		alert("업로드할 데이터가 없습니다.");
		mapSheet.RemoveAll();
		return;
	}
	if (rows.length > EXCEL_UP_MAX_ROWS) {
		alert("한 번에 " + kepCommaNum(EXCEL_UP_MAX_ROWS) + "건까지 올릴 수 있습니다.");
		mapSheet.RemoveAll();
		return;
	}

	mdcmMapRows = rows;
	mapSheet.RemoveAll();

	popupSel = "";	// 이 팝업은 setPopupReturn 을 쓰지 않는다
	openSearchPopup("/mdcm/showMasterMdCmCmsBuyInfoMapPop.do", "", "1200,640,no");
}

// 그리드에서 체크된 행의 구매정보코드. 수정양식은 구매정보 1건이 1행이다.
function checkedBuyInfoCodes() {
	var codes = [];
	var seen = {};
	for (var r = mySheet.HeaderRows(); r <= mySheet.LastRow(); r++) {
		if (mySheet.GetCellValue(r, "SELECTED") != 1) { continue; }
		var code = mySheet.GetCellValue(r, "BUY_INFO_ID");
		if (code == null || ("" + code) == "" || seen[code]) { continue; }
		seen[code] = true;
		codes.push(code);
	}
	return codes;
}

function modSheet_OnLoadFileCancel() {
	loader_obj("N");
}

/* 수정양식 업로드(LoadExcel) 후처리 — 등록양식과 같은 규약이다. */
function modSheet_OnLoadExcel(result) {
	loader_obj("N");
	if (!result) {
		alert("엑셀 로딩 중 오류가 발생하였습니다.");
		return;
	}
	if (modSheet.RowCount() == 0) {
		alert("업로드할 데이터가 없습니다.");
		return;
	}

	if (!mdcmFormCheck(modSheet, MDCM_MODB_DATA_START_ROW, MDCM_MODB_EXCEL_COLS, MDCM_MODB_FORM_HEAD, "구매정보 일괄수정")) {
		modSheet.RemoveAll();
		return;
	}

	/* 엑셀 사용범위에는 값을 지운 자리가 빈 행으로 남는다 - 그대로 읽으면 '구매정보코드 미입력' 오류로 잡힌다.
	   모든 열이 빈 행은 담지 않는다. */
	var rows = [];
	for (var r = mdcmFormFirstDataRow(modSheet, MDCM_MODB_DATA_START_ROW); r <= modSheet.LastRow(); r++) {
		var row = {};
		var filled = false;
		for (var c = 0; c < MDCM_MODB_EXCEL_COLS.length; c++) {
			var col = MDCM_MODB_EXCEL_COLS[c];
			var v = modSheet.GetCellValue(r, col);
			row[col] = v;
			if (!filled && $.trim((v == null) ? "" : ("" + v)) != "") { filled = true; }
		}
		if (filled) { rows.push(row); }
	}

	if (rows.length == 0) {
		alert("업로드할 데이터가 없습니다.");
		modSheet.RemoveAll();
		return;
	}
	if (rows.length > EXCEL_UP_MAX_ROWS) {
		alert("한 번에 " + kepCommaNum(EXCEL_UP_MAX_ROWS) + "건까지 올릴 수 있습니다.\n\n"
			+ "올린 파일이 " + kepCommaNum(rows.length) + "건입니다. 나눠서 올려 주세요.");
		modSheet.RemoveAll();
		return;
	}

	mdcmModbRows = rows;
	modSheet.RemoveAll();

	popupSel = "";	// 이 팝업은 setPopupReturn 을 쓰지 않는다
	openSearchPopup("/mdcm/showMasterMdCmCmsBuyInfoModPop.do", "", "1200,640,no");
}

// 그리드에서 체크된 행의 상품정보코드(중복 제거). 양식 A열에 채워 내릴 값이다.
function checkedCatlgCodes() {
	var codes = [];
	var seen = {};
	for (var r = mySheet.HeaderRows(); r <= mySheet.LastRow(); r++) {
		if (mySheet.GetCellValue(r, "SELECTED") != 1) { continue; }
		var code = mySheet.GetCellValue(r, "CMS_CATLG_ID");
		if (code == null || ("" + code) == "" || seen[code]) { continue; }
		seen[code] = true;
		codes.push(code);
	}
	return codes;
}

/* 파일선택 대화상자를 취소하면 OnLoadExcel 이 오지 않는다 — IBSheet 가 부르는 이 훅에서 로딩바를 내린다. */
function regSheet_OnLoadFileCancel() {
	loader_obj("N");
}

/* 등록양식 업로드(LoadExcel) 후처리.
 * 파일은 창 사이로 넘길 수 없어 파싱은 여기서 하고, 팝업은 opener.mdcmRegRows 를 읽는다. */
function regSheet_OnLoadExcel(result) {
	loader_obj("N");
	if (!result) {
		alert("엑셀 로딩 중 오류가 발생하였습니다.");
		return;
	}
	if (regSheet.RowCount() == 0) {
		alert("업로드할 데이터가 없습니다.");
		return;
	}

	if (!mdcmFormCheck(regSheet, MDCM_REG_DATA_START_ROW, MDCM_REG_EXCEL_COLS, MDCM_REG_FORM_HEAD, "구매정보 일괄등록")) {
		regSheet.RemoveAll();
		return;
	}

	/* 엑셀 사용범위에는 값을 지운 자리가 빈 행으로 남는다 - 그대로 읽으면 '필수값 누락' 오류로 잡힌다.
	   모든 열이 빈 행은 담지 않는다. 한 칸이라도 값이 있으면 실제 입력으로 보고 검증에 맡긴다. */
	var rows = [];
	for (var r = mdcmFormFirstDataRow(regSheet, MDCM_REG_DATA_START_ROW); r <= regSheet.LastRow(); r++) {
		var row = {};
		var filled = false;
		for (var c = 0; c < MDCM_REG_EXCEL_COLS.length; c++) {
			var col = MDCM_REG_EXCEL_COLS[c];
			var v = regSheet.GetCellValue(r, col);
			row[col] = v;
			if (!filled && $.trim((v == null) ? "" : ("" + v)) != "") { filled = true; }
		}
		if (filled) { rows.push(row); }
	}

	if (rows.length == 0) {
		alert("업로드할 데이터가 없습니다.");
		regSheet.RemoveAll();
		return;
	}
	if (rows.length > EXCEL_UP_MAX_ROWS) {
		alert("한 번에 " + kepCommaNum(EXCEL_UP_MAX_ROWS) + "건까지 올릴 수 있습니다.\n\n"
			+ "올린 파일이 " + kepCommaNum(rows.length) + "건입니다. 나눠서 올려 주세요.");
		regSheet.RemoveAll();
		return;
	}

	mdcmRegRows = rows;
	regSheet.RemoveAll();

	popupSel = "";	// 이 팝업은 setPopupReturn 을 쓰지 않는다
	openSearchPopup("/mdcm/showMasterMdCmCmsBuyInfoRegPop.do", "", "1200,640,no");
}

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		// ★ Cols[0].Header 가 빈문자("")면 IBS_InitSheet(ibsheetinfo.js:553)가 헤더행 생성을 스킵 → 컬럼 헤더명 미표시.
		//    숨김 상태(Status) 컬럼을 맨 앞에 두어(=truthy Header) 헤더가 정상 노출되게 함.
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,	Hidden:true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
		,{ Align:"Center",	Width:40,	Edit:true,	EditLen:100,	Type:"DummyCheck",	Header:"",			SaveName:"SELECTED"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Hidden:true,	Type:"Text",	Header:"TCODE",	SaveName:"TCODE"}

		/* ── 밴드1 : 상품 · 협력사 · 단가 ─────────────── */
		,{ Align:"Center",	Width:95,	Edit:false,	EditLen:25,	Type:"Text",	Header:"상품정보코드",		SaveName:"CMS_CATLG_ID"}
		,{ Align:"Center",	Width:105,	Edit:false,	EditLen:25,	Hidden:true,	Type:"Text",	Header:"구매정보코드(키)",	SaveName:"BUY_INFO_ID"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:5,	Type:"Text",	Header:"구매정보코드",		SaveName:"BUY_INFO_SEQ"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:25,	Type:"Text",	Header:"공급상태",			SaveName:"SUPPLY_STATUS"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:25,	Type:"Text",	Header:"만료여부",			SaveName:"EXPIRE_YN"}
		,{ Align:"Left",	Width:140,	Edit:false,	EditLen:25,	Type:"Text",	Header:"품목명",				SaveName:"DESCRIPTION_LOC"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:25,	Type:"Text",	Header:"모델번호",			SaveName:"MODEL_INFO"}
		,{ Align:"Left",	Width:140,	Edit:false,	EditLen:25,	Type:"Text",	Header:"규격",				SaveName:"SPECIFICATION"}
		,{ Align:"Left",	Width:90,	Edit:false,	EditLen:25,	Type:"Text",	Header:"제조사",				SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:25,	Type:"Text",	Header:"원산지",				SaveName:"ORIGIN_CODE_NAME"}
		,{ Align:"Center",	Width:55,	Edit:false,	EditLen:25,	Type:"Text",	Header:"단위",				SaveName:"ORDER_MEASURE"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:25,	Type:"Text",	Header:"협력사명",			SaveName:"AGENT_NAME"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:25,	Type:"Text",	Header:"협력사코드",			SaveName:"AGENT_CODE"}
		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"매입단가\n(VAT별도)",	SaveName:"LIST_PRICE"}
		,{ Align:"Center",	Width:85,	Edit:false,	EditLen:25,	Type:"Text",	Header:"최소주문\n수량",		SaveName:"MOQ"}

		/* ── 밴드2 : 거래조건 · 유효기간 · 매핑 ─────────────── */
		,{ Align:"Center",	Width:85,	Edit:false,	EditLen:25,	Type:"Text",	Header:"주문배수\n수량",		SaveName:"PUR_UNIT_QTY"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:25,	Type:"Text",	Header:"거래유형",			SaveName:"PROCESS_TYPE"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:25,	Type:"Text",	Header:"배송유형",			SaveName:"DELIVERY_TYPE"}
		,{ Align:"Center",	Width:105,	Edit:false,	EditLen:25,	Type:"Text",	Header:"입고TR",				SaveName:"TR_NAME"}
		,{ Align:"Center",	Width:65,	Edit:false,	EditLen:25,	Type:"Text",	Header:"배송일수",			SaveName:"LEADTIME"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:25,	Type:"Text",	Header:"품목구분",			SaveName:"ITEM_TYPE"}
		,{ Align:"Center",	Width:65,	Edit:false,	EditLen:25,	Type:"Text",	Header:"과세구분",			SaveName:"TAX_TYPE"}
		,{ Align:"Center",	Width:95,	Edit:false,	EditLen:25,	Type:"Text",	Header:"협력사\n품목코드",	SaveName:"SELLER_ITEM_NO"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:25,	Type:"Text",	Header:"매입단가\n시작일",	SaveName:"BUY_OPEN_DATE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:25,	Type:"Text",	Header:"매입단가\n종료일",	SaveName:"BUY_CLOSE_DATE"}
		,{ Align:"Center",	Width:85,	Edit:false,	EditLen:25,	Type:"Text",	Header:"매핑\n고객사수",		SaveName:"MAP_BUYER_CNT"}
		,{ Align:"Center",	Width:85,	Edit:false,	EditLen:25,	Type:"Text",	Header:"지정\n고객사수",		SaveName:"DESIG_BUYER_CNT"}

		/* ── 밴드3 : 분류 · 기준가 ─────────────── */
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:25,	Type:"Text",	Header:"상품구분",			SaveName:"ITEM_GUBUN_NM"}
		,{ Align:"Center",	Width:75,	Edit:false,	EditLen:25,	Type:"Text",	Header:"일회성구분",			SaveName:"ONETIME_NM"}
		,{ Align:"Center",	Width:85,	Edit:false,	EditLen:25,	Type:"Text",	Header:"TR취급\n가능여부",	SaveName:"TR_HANDLE_NM"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:25,	Type:"Text",	Header:"카테고리",			SaveName:"SG_NAME"}
		,{ Align:"Center",	Width:95,	Edit:false,	EditLen:25,	Type:"Text",	Header:"상세분류코드",		SaveName:"CMS_CATEG_ID"}
		,{ Align:"Left",	Width:140,	Edit:false,	EditLen:25,	Type:"Text",	Header:"상세분류",			SaveName:"CMS_CATEG_NAME"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:25,	Type:"Text",	Header:"구매담당자",			SaveName:"KEP_USER_NAME"}
		,{ Align:"Right",	Width:90,	Edit:false,	EditLen:25,	Type:"Text",	Header:"기준가",				SaveName:"BASE_PRICE"}
		,{ Align:"Right",	Width:85,	Edit:false,	EditLen:25,	Type:"Text",	Header:"기준가\n매익율",		SaveName:"BASE_MARGIN"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:25,	Type:"Text",	Header:"기준가유형",			SaveName:"BASE_PRICE_TYPE"}
		,{ Align:"Right",	Width:85,	Edit:false,	EditLen:25,	Type:"Text",	Header:"유형별\n매익율",		SaveName:"TYPE_MARGIN"}

		/* ── 밴드4 : 불가사유 · 이력 ─────────────── */
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:25,	Type:"Text",	Header:"불가\n변경사유",		SaveName:"UNAVAIL_REASON"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"대체코드",			SaveName:"ALT_CODE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:25,	Type:"Text",	Header:"구매정보\n등록일",	SaveName:"ADD_DATE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:25,	Type:"Text",	Header:"변경\n이력",			SaveName:"HISTORY"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:25,	Type:"Text",	Header:"최종변경일",			SaveName:"CHANGE_DATE"}
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	//하이퍼링크 설정 : 구매정보코드 / 상세분류 / 협력사명 / 매핑고객사수
	setLinkCol(mySheet, "BUY_INFO_SEQ");
	setLinkCol(mySheet, "CMS_CATEG_NAME");
	setLinkCol(mySheet, "AGENT_NAME");

	//조회일자 검색 입력칸에 표준 달력(datepicker) 부착
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");

	//조회일자 기본값: 이전 1개월 ~ 오늘
	$("#st_from_date").val( kepToMonthAdd("1","M") );          // 당일 -1개월
	$("#st_to_date").val( kepGetNowTimeStr("YYYYMMDD","/") );  // 오늘

	initRegSheet();
	initModSheet();
	initMapSheet();
}

// 기능함수
function doAction(str) {
	switch (str) {
	case "search":	 // 조회
		/* 기간무시 체크 시 - 상품정보코드 · 카테고리 · 상세분류 · 협력사명 · 구매담당자 중 1개 이상 필수.
		   조건 없이 전체를 훑으면 목록이 통째로 풀스캔이 된다(상품정보 목록과 같은 가드). */
		if($("#st_checkbox").is(":checked")){
			var hasKey =  ($.trim($("#st_catlg_id").val())      != "")		// 상품정보코드
				       || ($.trim($("#st_catlg_id_multi").val()) != "")		// 상품정보코드(대량입력)
				       || ($.trim($("#st_sg_id_multi").val())    != "")		// 카테고리(SG, 복수)
				       || ($.trim($("#st_categ_id_multi").val()) != "")		// 상세분류(복수)
				       || ($.trim($("#st_agent_code").val())   != "")		// 협력사
				       || ($.trim($("#st_kep_user_no").val())   != "")		// 구매담당자(사번)
				       || ($.trim($("#st_kep_user_name").val()) != "");		// 구매담당자(이름)
			if(!hasKey){
				alert("기간무시 조회 시 상품정보코드, 카테고리, 상세분류, 협력사, 구매담당자 중 1개 이상 입력하세요.");
				return;
			}
		}
		current_page = -1;
		kepSearch(document.searchCondition, mySheet, "/mdam/getMasterMdCmCmsBuyInfoList.do", pagingMode);
		break;

	case "reload":	// 초기화
		kepReload('searchCondition');
		//돋보기로 채운 hidden 은 kepReload 대상이 아니라 직접 비운다
		$("#st_catlg_id_multi").val("");
		$("#st_sg_id_multi").val("");
		$("#st_sg_name").val("");
		$("#st_categ_id_multi").val("");
		$("#st_categ_name_multi").val("");
		$("#st_category_path").val("");
		$("#st_agent_code").val("");
		$("#st_agent_name_multi").val("");
		$("#st_agent_name").val("");
		$("#st_maker_code").val("");
		$("#st_maker_name").val("");
		$("#st_kep_user_no").val("");
		$("#st_kep_user_name").val("");
		//기간무시 기본값 = 체크 상태
		$("#st_checkbox").prop("checked", true);
		//조회일자는 기본값(이전 1개월 ~ 오늘)으로 복원
		$("#st_from_date").val( kepToMonthAdd("1","M") );
		$("#st_to_date").val( kepGetNowTimeStr("YYYYMMDD","/") );
		mySheet.RemoveAll();
		break;

	case "excelDown": // 엑셀다운로드 - 체크한 행이 있으면 그 행만, 없으면 조회조건 전건
		if(mySheet.RowCount() <= 0){
			alert("조회된 내역이 없습니다.");
			return;
		}
		/* 체크된 행이 있으면 서버를 다시 타지 않고 화면 그리드에서 바로 만든다. */
		var downRow = "";
		for (var r = mySheet.HeaderRows(); r <= mySheet.LastRow(); r++) {
			if (mySheet.GetCellValue(r, "SELECTED") == 1) { downRow += "|" + r; }
		}
		if (downRow != "") {
			var headRow = "";
			for (var h = 0; h < mySheet.HeaderRows(); h++) { headRow += "|" + h; }
			downRow = headRow + downRow;
			/* ⚠ 확장자는 xls 다 — Down2Excel 은 xlsx 를 지원하지 않는다. 전건 다운로드도 같은 확장자로 맞춘다(아래). */
			mySheet.Down2Excel({ FileName:"구매정보리스트.xls", SheetName:"구매정보리스트"
			                   , DownRows:downRow, DownCols:kepSheetExcelDownCols(mySheet)
			                   , DownHeader:1
			                   , Merge:1, SheetDesign:1 });
			break;
		}

		/* 화면에 보이는 건 현재 페이지뿐이라 RowCount 로는 못 잰다 - 전체 건수는 GetTotalRows(TOTNUM). */
		var excelRows = mySheet.GetTotalRows();
		if(excelRows > EXCEL_DOWN_MAX_ROWS){
			alert("엑셀다운로드는 한 번에 " + kepCommaNum(EXCEL_DOWN_MAX_ROWS) + "건까지 받을 수 있습니다.\n\n"
				+ "조회 결과가 " + kepCommaNum(excelRows) + "건입니다. 조회조건을 좁혀 주세요.");
			return;
		}
		$("#pageflag").val('0');
		/* ⚠ 제외의 주체는 DownCols 다. HiddenColumn 은 "숨긴 상태로 포함"이라 제외 옵션이 아니다. */
		var param = {FileName:"구매정보리스트.xls", HiddenColumn:0, DownCols:kepSheetExcelDownCols(mySheet)};
		kepDownExcel(document.searchCondition, mySheet , "/mdam/getMasterMdCmCmsBuyInfoExcelList.do", param);
		$("#pageflag").val('1');
		break;

	case "catelist": // 카테고리조회 - 지정값 없이 빈 상태로 팝업 오픈
		popupSel = "";
		openSearchPopup("/mdcm/showMasterMdCmCmsItemCategorySelPop.do", "", "810,509,no");
		break;

	case "dailyQuote": // 데일리견적생성 - 체크한 상품의 추가 구매정보용 견적 신규생성
		alert("화면 레이아웃 단계입니다. 데일리견적생성은 후속 작업에서 연결됩니다.");
		break;

	case "formDown": // 양식 다운로드 - 종류는 st_form_type 셀렉트로 고른다
		if ($("#st_form_type").val() == "REG") { doAction("regFormDown"); return; }
		if ($("#st_form_type").val() == "MOD") { doAction("modFormDown"); return; }
		doAction("mapFormDown");
		break;

	case "formUp":   // 양식 업로드
		if ($("#st_form_type").val() == "REG") { doAction("regFormUp"); return; }
		if ($("#st_form_type").val() == "MOD") { doAction("modFormUp"); return; }
		doAction("mapFormUp");
		break;

	case "regFormDown": // 구매정보 등록 양식 다운로드 — 체크한 상품이 있으면 상품정보코드를 채워 받는다
		var regCodes = checkedCatlgCodes();
		if (regCodes.length > REG_FORM_MAX_ROWS) {
			alert("양식은 한 번에 " + REG_FORM_MAX_ROWS + "건까지 받을 수 있습니다.\n선택 : " + regCodes.length + "건");
			return;
		}
		// 응답이 파일이라 AJAX 로는 못 받는다 → 숨은 iframe 을 대상으로 form submit 한다(화면 이동 없음).
		$("#regFormCodes").val(regCodes.join("@"));
		formDownStart();
		document.regFormDownload.submit();
		break;

	case "modFormDown": // 구매정보 수정 양식 다운로드 — 체크한 구매정보의 현재값이 채워진 양식
		var modCodes = checkedBuyInfoCodes();
		if (modCodes.length == 0) {
			alert("양식을 받을 구매정보를 선택하세요.");
			return;
		}
		if (modCodes.length > REG_FORM_MAX_ROWS) {
			alert("양식은 한 번에 " + REG_FORM_MAX_ROWS + "건까지 받을 수 있습니다.\n선택 : " + modCodes.length + "건");
			return;
		}
		$("#modFormCodes").val(modCodes.join("@"));
		formDownStart();
		document.modFormDownload.submit();
		break;

	case "modFormUp": // 구매정보 수정 양식 업로드
		modSheet.RemoveAll();
		mdcmModbRows = null;
		modSheet.SetWaitImageVisible(false);
		loader_obj("Y");
		// ⚠ StartRow 는 1 이다 - 머리글까지 읽어 와 양식을 대조한다(mdcmFormCheck). 데이터는 그 뒤부터 담는다.
		modSheet.LoadExcel({Mode:"NoHeader", ColumnMapping:mdcmModbColMapping(), StartRow:"1"});
		break;

	case "mapFormDown": // 고객사 매핑변경 양식 다운로드 — 체크한 구매정보의 고객사 매핑을 전개해 받는다
		var mapCodes = checkedBuyInfoCodes();
		if (mapCodes.length == 0) {
			alert("양식을 받을 구매정보를 선택하세요.");
			return;
		}
		if (mapCodes.length > REG_FORM_MAX_ROWS) {
			alert("양식은 한 번에 " + REG_FORM_MAX_ROWS + "건까지 받을 수 있습니다.\n선택 : " + mapCodes.length + "건");
			return;
		}
		$("#mapFormCodes").val(mapCodes.join("@"));
		formDownStart();
		document.mapFormDownload.submit();
		break;

	case "mapFormUp": // 고객사 매핑변경 양식 업로드
		mapSheet.RemoveAll();
		mdcmMapRows = null;
		mapSheet.SetWaitImageVisible(false);
		loader_obj("Y");
		// ⚠ StartRow 는 1 이다 - 머리글까지 읽어 와 양식을 대조한다(mdcmFormCheck). 데이터는 그 뒤부터 담는다.
		mapSheet.LoadExcel({Mode:"NoHeader", ColumnMapping:mdcmMapColMapping(), StartRow:"1"});
		break;

	case "regFormUp": // 구매정보 등록 양식 업로드
		regSheet.RemoveAll();
		mdcmRegRows = null;
		regSheet.SetWaitImageVisible(false);	// IBSheet 자체 대기이미지 대신 공통 로딩바를 쓴다
		loader_obj("Y");
		/* ⚠ Mode:"NoHeader" 를 빼면 IBSheet 가 StartRow 부터 그리드 헤더행 수만큼을
		   헤더로 먹어치워 앞 행이 조용히 사라진다. ColumnMapping 업로드는 예외 없이 NoHeader 를 넘긴다. */
		// ⚠ StartRow 는 1 이다 - 머리글까지 읽어 와 양식을 대조한다(mdcmFormCheck). 데이터는 그 뒤부터 담는다.
		regSheet.LoadExcel({Mode:"NoHeader", ColumnMapping:mdcmRegColMapping(), StartRow:"1"});
		break;
	}
}

// 검색조건 팝업 호출
// ⚠ openSearchPopup 이 내부에서 encodeURI 를 걸므로 쿼리는 날것으로 넘긴다(미리 인코딩하면 이중 인코딩).
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "sgChoice": // 카테고리(=SG) 복수선택
			openSearchPopup("/mdcm/showMasterMdCmCmsItemSgSelPop.do", "?st_sg_id_multi=" + $("#st_sg_id_multi").val(), "950,521,no");
			break;
		case "categChoice": // 상세분류 복수선택
			openSearchPopup("/mdcm/showMasterMdCmCmsItemCategoryMultiSelPop.do", "?st_categ_id_multi=" + $("#st_categ_id_multi").val(), "1000,509,no");
			break;
		case "vendor": // 협력사 복수선택
			openSearchPopup("/mdcm/showMasterMdCmSellerCmpyMultiSelPop.do", "?st_agent_code_multi=" + $("#st_agent_code").val(), "1000,494,no");
			break;
		case "maker": // 제조사 (유사명 포함 컬럼 5개라 700px에서는 헤더가 줄바꿈된다)
			openSearchPopup("/common/agentRegMakerCodePop.do", "?st_alias_yn=Y", "820,464,no");
			break;
		case "mngrChoice": // 구매담당자
			openSearchPopup("/mdcm/showMasterMdCmCmsItemMngrSelPop.do", "", "640,464,no");
			break;
		case "catlgMulti": // 상품정보코드 대량입력
			openSearchPopup("/common/multiSearchCondPop.do", "?header_text=상품정보코드", "300,371,no");
			break;
	}
}

//그리드 표시후 처리
function mySheet_OnLoadData(DATA) {
	return DATA;
}
//엑셀 다운로드 후 처리
function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);
	}

	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;

	if (msg != "") {
		alert(msg);
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/mdam/getMasterMdCmCmsBuyInfoList.do?page="+current_page, pagingMode);
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	if(column == "BUY_INFO_SEQ"){ // 구매정보 상세
		var st_msds_no  = mySheet.GetCellValue(Row,"CMS_CATLG_ID");
		var st_buy_info = mySheet.GetCellValue(Row,"BUY_INFO_ID");
		var st_tcode    = mySheet.GetCellValue(Row,"TCODE"); // 단건 조회 유니크 키
		openSearchPopup("/mdcm/showMasterMdCmCmsBuyInfoDetailPop.do","?st_msds_no="+st_msds_no+"&st_buy_info="+st_buy_info+"&st_tcode="+st_tcode, "1300,800,no");
	}else if(column == "CMS_CATEG_NAME"){ // 상세분류 → 카테고리·속성 팝업(지정 분류 사전세팅)
		popupSel = "gridCategory";
		var st_pre_categ_id = mySheet.GetCellValue(Row,"CMS_CATEG_ID");
		openSearchPopup("/mdcm/showMasterMdCmCmsItemCategorySelPop.do","?st_pre_categ_id="+st_pre_categ_id, "810,509,no");
	}else if(column == "AGENT_NAME"){ // 협력사정보 팝업 (공용 회원사정보 팝업)
		var st_com_code = mySheet.GetCellValue(Row,"AGENT_CODE");
		if (st_com_code == null || ("" + st_com_code) == "") { return; }
		popupSel = "";	// 이 팝업은 setPopupReturn 을 쓰지 않는다
		openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+st_com_code, "800,550,no");
	}
	return;
}

// 팝업 선택 반환 콜백 (popupSel 로 분기)
function setPopupReturn(value1, value2, value3, value4, value5, value6){
	if (popupSel == "sgChoice") {				// 카테고리 = SG 복수선택 ("A@B@" 한 덩어리)
		$("#st_sg_id_multi").val(value1);
		$("#st_sg_name").val(kepMultiName(value2, "@"));	// 표시는 "○○ 외 N건"
	} else if (popupSel == "categChoice") {		// 상세분류 복수선택 ("A@B@" 한 덩어리)
		$("#st_categ_id_multi").val(value1);
		$("#st_categ_name_multi").val(value2);			// 원본 명칭 - 팝업 재진입 시 바구니 복원용
		$("#st_category_path").val(kepMultiName(value2, "@"));	// 표시는 "○○ 외 N건"
	} else if (popupSel == "gridCategory") {	// 그리드 상세분류 셀 클릭 (조회 전용, 영속화 없음)
		popupSel = "";
	} else if (popupSel == "vendor") {			// 협력사 복수선택 ("A@B@" 한 덩어리)
		$("#st_agent_code").val(value1);
		$("#st_agent_name_multi").val(value2);		// 원본 명칭 - 팝업 재진입 시 바구니 복원용
		$("#st_agent_name").val(kepMultiName(value2, "@"));	// 표시는 "○○ 외 N건"
	} else if (popupSel == "maker") {			// 제조사 (maker_code, maker_name)
		$("#st_maker_code").val(value1);
		$("#st_maker_name").val(value2);
	} else if (popupSel == "mngrChoice") {		// 구매담당자 = 본사 사용자 (USER_ID, 담당자명)
		$("#st_kep_user_no").val(value1);
		$("#st_kep_user_name").val(value2);
	} else if (popupSel == "catlgMulti") {		// 상품정보코드 대량입력 ("A@B@C@" 한 덩어리)
		var codes = kepCleanMultiCode(value1);
		$("#st_catlg_id_multi").val(codes);
		$("#st_catlg_id").val(kepMultiName(codes, "@"));	// 표시는 "A 외 N건"
	}
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA">
		<h3 style="width:auto; white-space:nowrap;">구매정보 조회 및 관리
			<span style="font-size:13px; font-weight:normal; letter-spacing:0; color:#c0392b;">※ 해당 화면에서 변경된 세무구분은 카탈로그에도 자동 반영됩니다.</span>
		</h3>
		<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
		<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	</div>

	<!--조회영역-->
	<form name="searchCondition" method="post">
		<div id="cont_searchA">
			<!--HIDDEN-->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">

			<table class="cont_t_list01" style="width:100%">
				<caption>구매정보 조회 및 관리</caption>
				<colgroup>
					<col width="9%" />
					<col width="11%" />
					<col width="7%" />
					<col width="12%" />
					<col width="6%" />
					<col width="13%" />
					<col width="7%" />
					<col width="13%" />
					<col width="7%" />
					<col width="15%" />
				</colgroup>
				<tbody>
					<tr>
						<th>
							<select name="st_date_type" id="st_date_type" class="TitSelect">
								<option value="ADD" selected="selected">등록일</option>
								<option value="CHG">최종변경일</option>
								<option value="PVD">매입단가유효기간(종료일)</option>
							</select>
						</th>
						<td colspan="3">
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:85px; text-align:center;" value=""> -
							<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:85px; text-align:center;" value="">
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
							<input type="checkbox" class="Noborder" name="st_checkbox" id="st_checkbox" checked>&nbsp;기간무시
						</td>
						<th>상품정보코드</th>
						<td>
							<input type="text" class="input_type_text" id="st_catlg_id" name="st_catlg_id" style="width:60%;" value="" onkeydown="kepEnter()" onKeyUp="ToUpper(this); kepClear('st_catlg_id_multi');">
							<input type="hidden" name="st_catlg_id_multi" id="st_catlg_id_multi" value="">
							<a href="javascript:doPop('catlgMulti');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_catlg_id_multi','st_catlg_id');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th>공급상태</th>
						<td>
							<select name="st_supply_status" id="st_supply_status" style="width:90%;">
								<option value="" selected="selected">전체</option>
								<option value="AVAIL">가능</option>
								<option value="UNAVAIL">불가</option>
							</select>
						</td>
						<th>카테고리</th>
						<td>
							<input type="text" class="input_type_text" name="st_sg_name" id="st_sg_name" style="width:65%;" value="" readonly>
							<input type="hidden" name="st_sg_id_multi" id="st_sg_id_multi" value="">
							<a href="javascript:doPop('sgChoice');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_sg_id_multi','st_sg_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
					</tr>
					<tr>
						<th>거래유형</th>
						<td>
							<select name="st_process_type" id="st_process_type" style="width:90%;">
								<option value="" selected="selected">전체</option>
								<option value="0">직납</option>
								<option value="1">재고</option>
								<option value="2">TR</option>
								<option value="3">VMI</option>
							</select>
						</td>
						<th>품목명</th>
						<td>
							<input type="text" class="input_type_text" id="st_item_name" name="st_item_name" style="width:90%;" value="" onkeydown="kepEnter()">
						</td>
						<th>모델번호</th>
						<td>
							<input type="text" class="input_type_text" id="st_model_info" name="st_model_info" style="width:90%;" value="" onkeydown="kepEnter()">
						</td>
						<th>만료여부</th>
						<td>
							<select name="st_expire_yn" id="st_expire_yn" style="width:90%;">
								<option value="" selected="selected">전체</option>
								<option value="EXP">만료</option>
								<option value="EXPSOON">만료예정</option>
								<option value="NONE">공란</option>
							</select>
						</td>
						<th>상세분류</th>
						<td>
							<input type="text" class="input_type_text" name="st_category_path" id="st_category_path" style="width:65%;" value="" readonly>
							<input type="hidden" name="st_categ_id_multi" id="st_categ_id_multi" value="">
							<!-- 팝업 재진입 시 바구니 명칭 복원용(원본 '명칭@명칭@'). 조회에는 쓰지 않는다. -->
							<input type="hidden" name="st_categ_name_multi" id="st_categ_name_multi" value="">
							<a href="javascript:doPop('categChoice');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser2('st_categ_id_multi','st_categ_name_multi','st_category_path');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
					</tr>
					<tr>
						<th>배송유형</th>
						<td>
							<select name="st_delivery_type" id="st_delivery_type" style="width:90%;">
								<option value="ALL" selected="selected">전체</option>
								<option value="PCL">택배</option>
								<option value="CAR">자차</option>
							</select>
						</td>
						<th>규격</th>
						<td>
							<input type="text" class="input_type_text" id="st_specification" name="st_specification" style="width:90%;" value="" onkeydown="kepEnter()">
						</td>
						<th>제조사</th>
						<td>
							<input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:60%;" value="" readonly>
							<input type="hidden" name="st_maker_code" id="st_maker_code" value="">
							<a href="javascript:doPop('maker');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_maker_code','st_maker_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th>협력사</th>
						<td>
							<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:60%;" value="" readonly>
							<input type="hidden" name="st_agent_code" id="st_agent_code" value="">
							<!-- 팝업 재진입 시 바구니 명칭 복원용(원본 '명칭@명칭@'). 조회에는 쓰지 않는다. -->
							<input type="hidden" name="st_agent_name_multi" id="st_agent_name_multi" value="">
							<a href="javascript:doPop('vendor');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser2('st_agent_code','st_agent_name_multi','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th>구매담당자</th>
						<td>
							<input type="text" class="input_type_text" id="st_kep_user_name" name="st_kep_user_name" style="width:65%;" value="" onkeydown="kepEnter()" onKeyUp="kepClear('st_kep_user_no');">
							<input type="hidden" name="st_kep_user_no" id="st_kep_user_no" value="">
							<a href="javascript:doPop('mngrChoice');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_kep_user_no','st_kep_user_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
			<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" style="width: 70px;" onchange="doAction('search');">
				<option value="100">100건</option>
				<option value="300">300건</option>
				<option value="500">500건</option>
				<option value="1000" selected>1000건</option>
			</select>
		</span>
		<br>
	</form>

	<!--grid-->
	<div class="ib_product" style="border-top:2px solid #3c639c">
		<script type="text/javascript">
			createIBSheet("mySheet", "100%", "354px");
		</script>
	</div>
	<p class="paging" id="pageindex"></p>

	<!--버튼영역-->
	<div class="btnArea">
		<span class="fl">
			<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
			<span class="btn_05 mr04"><a href="javascript:doAction('catelist');">상세분류조회</a></span>
			<span class="btn_05 mr04"><a href="javascript:doAction('dailyQuote');">데일리견적생성</a></span>
		</span>
		<span class="fr">
			<label for="st_form_type" class="hidden">양식 선택</label>
			<select id="st_form_type" style="width:175px; height:28px; margin-top:5px; margin-right:4px; vertical-align:top;">
				<option value="REG" selected="selected">구매정보 등록 양식</option>
				<option value="MOD">구매정보 일괄수정 양식</option>
				<option value="MAP">고객사 매핑변경 양식</option>
			</select>
			<span class="btn_05 mr04"><a href="javascript:doAction('formDown');">다운로드</a></span>
			<span class="btn_05"><a href="javascript:doAction('formUp');">업로드</a></span>
		</span>
	</div>

	<div style="position:absolute; left:-9999px; top:0; width:1px; height:1px; overflow:hidden;">
		<script type="text/javascript">
			createIBSheet("regSheet", "600px", "200px");
			createIBSheet("modSheet", "600px", "200px");
			createIBSheet("mapSheet", "600px", "200px");
		</script>
	</div>

	<!-- 등록양식 다운로드 : 파일 응답이라 숨은 iframe 을 대상으로 submit 한다 -->
	<form name="regFormDownload" method="post" action="/mdcm/downMasterMdCmCmsBuyInfoRegForm.do" target="regFormFrame">
		<input type="hidden" id="regFormCodes" name="codes" value="" />
		<input type="hidden" id="regFormToken" name="downToken" value="" />
	</form>
	<!-- 수정양식 다운로드 : 등록양식과 같은 iframe·토큰 규약을 쓴다 -->
	<form name="modFormDownload" method="post" action="/mdcm/downMasterMdCmCmsBuyInfoModForm.do" target="regFormFrame">
		<input type="hidden" id="modFormCodes" name="codes" value="" />
		<input type="hidden" id="modFormToken" name="downToken" value="" />
	</form>
	<!-- 매핑변경양식 다운로드 : 위 둘과 같은 iframe·토큰 규약 -->
	<form name="mapFormDownload" method="post" action="/mdcm/downMasterMdCmCmsBuyInfoMapForm.do" target="regFormFrame">
		<input type="hidden" id="mapFormCodes" name="codes" value="" />
		<input type="hidden" id="mapFormToken" name="downToken" value="" />
	</form>
	<!-- onload : 서버가 안내(alert)를 돌려준 경우엔 iframe 이 실제로 로드되므로 여기서도 로딩바를 내린다 -->
	<iframe name="regFormFrame" onload="formDownEnd();" style="display:none; width:0; height:0; border:0;"></iframe>

<!--내용 종료-->
</body>
</html>
