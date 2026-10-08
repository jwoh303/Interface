<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>구매정보 조회 및 관리 > 구매정보 수정 양식 업로드 시 팝업
* 화면 : (팝업) 일괄 업로드 **결과 확인** (구매정보 일괄수정)
* 기능 : 양식 다운로드/업로드는 **목록 화면(masterMdCmCmsBuyInfoList) 하단 바**가 맡는다.
*        이 팝업은 목록이 엑셀을 파싱한 뒤에만 열리며, 결과 확인만 한다.
*        - 목록이 파싱해 둔 행(`opener.mdcmModbRows`)을 받아 → [기존]값·코드 서버조회 → 검증 → 결과 표시
*        - 유형선택조회(타일 탭) + 인상/인하 · 변동율 + 결과/오류항목/오류사유 + 전체·오류 건 다운로드
*        - 그리드 컬럼 정의는 목록과 공유 : /resources/js/mdcm/cmsBuyInfoModForm.js
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
<!-- 구매정보 수정 그리드 컬럼·엑셀 열 정의 (목록 화면과 공유) -->
<script src="/resources/js/mdcm/cmsBuyInfoModForm.js" type="text/javascript"></script>
<script src="/resources/js/mdcm/buyInfoCode.js" type="text/javascript"></script>
</head>
<script type="text/javascript">
var sheetMod = new ibsheetObject();	// 구매정보 일괄수정 결과 그리드
var pagingMode = "N";	// Y: 번호 페이징, N : 스크롤
var curTab = "ALL";		// 선택된 유형 타일
var modColNames = [];	// 그리드 컬럼(SaveName) 순서 — 다운로드 컬럼 지정용
var cnt = {all:0, ok:0, err:0, up:0};	// up = 매입단가 인상 = 품의 대상

var UP_TXT   = "#C0392B";	// 인상 — 빨강
var DOWN_TXT = "#1F6FB2";	// 인하 — 파랑
var ERR_BG   = "#FDECEA";	// 오류 항목 셀 배경

// 서버에서 받아온 조회 결과 — 업로드 직후 1회만 채운다.
var beforeByCode = {};	// 구매정보코드 → [기존] 행
var codeExists   = {};	// 구매정보코드 실재 여부
var altExists    = {};	// 대체코드(상품정보코드) 실재 여부
var reasonInfo   = {};	// 사유명 → {direction, altRequired}
var makeTypeSet  = {};	// 품목구분 명칭 실재 여부
var taxTypeSet   = {};	// 과세구분 명칭 실재 여부
var modColSet    = {};	// 그리드에 실제로 있는 컬럼(SaveName)

function kep_onload_view() {
	initSheetMod();
	loadFromOpener();
}

/* 목록 화면(masterMdCmCmsBuyInfoList)이 LoadExcel 로 읽어 둔 행을 넘겨받는다.
 * 팝업은 **업로드 이후에만** 열리므로 여기가 유일한 진입 경로다.
 * ⚠ 파일을 창 사이로 넘길 수 없어 파싱은 목록이 하고, 이쪽은 같은 출처 창의 JS 배열을 그대로 읽는다. */
function loadFromOpener() {
	var rows = null;
	try { rows = opener.mdcmModbRows; } catch (e) { rows = null; }

	if (!rows || rows.length == 0) {
		alert("업로드할 데이터가 없습니다.");
		self.close();
		return;
	}

	sheetMod.RemoveAll();
	for (var i = 0; i < rows.length; i++) {
		var r = sheetMod.DataInsert(-1);
		for (var c = 0; c < MDCM_MODB_EXCEL_COLS.length; c++) {
			var col = MDCM_MODB_EXCEL_COLS[c];
			if (!modColSet[col]) { continue; }
			var v = rows[i][col];
			sheetMod.SetCellValue(r, col, (v == null) ? "" : v, 0);
		}
	}

	/* 양식 B열은 순번만 담는다 - A열 상품정보코드와 합쳐 키(BUY_INFO_ID)를 되돌린다.
	   예전 양식처럼 전체코드가 적혀 있으면 그대로 쓴다. */
	for (var k = sheetMod.HeaderRows(); k <= sheetMod.LastRow(); k++) {
		sheetMod.SetCellValue(k, "BUY_INFO_ID"
			, mdcmBuyInfoFull(sheetMod.GetCellValue(k, "CMS_CATLG_ID"), sheetMod.GetCellValue(k, "BUY_INFO_SEQ")), 0);
	}

	afterLoadExcel(true, sheetMod);
}

function initSheetMod() {
	var initsheet = {};
	initsheet.Cols = mdcmModbCols();	// 정의는 cmsBuyInfoModForm.js (목록 화면과 공유)
	initsheet.Cfg  = {MergeSheet:msHeaderOnly, FrozenCol:0, UseNoDataRow:1};

	modColNames = mdcmModbColNames();
	modColSet = {};
	for (var i = 0; i < modColNames.length; i++) { modColSet[modColNames[i]] = true; }

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
		case "reg": // 확인 — 정상 건만 반영
			doApply();
			break;
	}
}

/* 확인 — 오류 행을 뺀 정상 건만 서버로 보낸다.
 * ★ 매입단가는 **인상이 결재 대상**이다(기준가와 반대). 품의 배선이 아직 없어 인상분 매입단가는 보내지 않는다 —
 *   같은 행의 다른 항목은 그대로 반영되고, 매입단가만 보류된다. */
function doApply() {
	if (cnt.ok == 0) {
		alert("반영할 정상 건이 없습니다.");
		return;
	}

	var msg = "오류 " + cnt.err + " 건을 제외한 " + cnt.ok + " 건을 반영합니다.\n";
	if (cnt.up > 0) {
		msg += "\n※ 매입단가 인상 " + cnt.up + " 건은 바로 반영되지 않고 품의가 상신됩니다.\n"
			+ "   (같은 행의 다른 항목은 먼저 반영됩니다.)\n";
	}
	msg += "\n진행하시겠습니까?";
	if (!confirm(msg)) { return; }

	var param = collectApplyRows();
	if (param == null) { return; }

	loader_obj("Y");
	$.ajax({
		 type		: "POST"
		,url		: "/mdcm/saveMasterMdCmCmsBuyInfoModBulk.do"
		,headers	: { 'X-Requested-With': 'XMLHttpRequest' }
		,traditional: true
		,data		: param
		,dataType	: "json"
		,success	: function( res ) {
			loader_obj("N");

			// 서버가 실패하면 ExceptionController 가 HTTP 200 + {Message:"시스템 처리 중…"} 로 응답한다.
			// 성공 응답에만 Result.Code 가 있으므로 그것으로 가른다.
			if (!res || !res.Result || res.Result.Code != 1) {
				alert("구매정보 반영 처리 중 오류가 발생하였습니다.\n\n"
				    + ((res && res.Message) ? res.Message : "관리자에게 문의 바랍니다."));
				return;
			}

			var done = "구매정보 " + ((res.Message == null) ? "" : res.Message) + " 건이 반영되었습니다.";

			// 매입단가 인상은 결재 대상이다 — 미리보기 화면 없이 곧바로 상신한다.
			// 결재대상 목록은 결재자가 보는 화면(approvalSpListPop)에서 협력사별로 노출된다.
			if (cnt.up > 0) {
				mdcmBuyUpRows = collectUpRows();
				if (mdcmBuyUpRows.length > 0) {
					alert(done + "\n\n이어서 매입단가 인상 " + mdcmBuyUpRows.length + " 건의 품의를 상신합니다.");
					doPriceUpRequest();
					return;
				}
			}

			alert(done);
			try { opener.doAction('search'); } catch (e) {}
			self.close();
		}
		,error		: function() {
			loader_obj("N");
			alert("구매정보 반영 처리 중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
		}
	});
}

/* 매입단가 인상 일괄 상신 — 신청 1건(KEPMGPHD) + 디테일 N건(KEPMGPDT) 을 만들고
 * 공통 결재 팝업(DOC_TYPE=SPM)을 띄운다. 미리보기 화면은 두지 않는다. */
function doPriceUpRequest(){
	var rows  = mdcmBuyUpRows;
	var names = ["BUY_INFO_ID","AGENT","PRICE_BEFORE","PRICE_AFTER","PRICE_REASON"];
	var param = { s_SAVENAME : names.join("|") };
	var i;
	for (i = 0; i < names.length; i++) { param[names[i]] = []; }

	for (i = 0; i < rows.length; i++) {
		param.BUY_INFO_ID.push(kepTrimStr(rows[i].buyInfo));
		param.AGENT.push(kepTrimStr(rows[i].agent));
		param.PRICE_BEFORE.push(String(kepTrimStr(rows[i].before)).replace(/,/g, ""));
		param.PRICE_AFTER.push(String(kepTrimStr(rows[i].after )).replace(/,/g, ""));
		param.PRICE_REASON.push(kepTrimStr(rows[i].reason));
	}

	loader_obj("Y");
	$.ajax({
		 type		: "POST"
		,url		: "/mdcm/requestMasterMdCmCmsBuyInfoPriceUpBulk.do"
		,headers	: { 'X-Requested-With': 'XMLHttpRequest' }
		,traditional: true
		,data		: param
		,dataType	: "json"
		,success	: function(res){
			loader_obj("N");

			// 실패 응답에는 Result.Code 가 없다 — 이 검사가 없으면 에러문이 PM_NO 로 박힌다.
			if (!res || !res.Result || res.Result.Code != 1) {
				alert("품의 상신 처리 중 오류가 발생하였습니다.\n\n"
				    + ((res && res.Message) ? res.Message : "관리자에게 문의 바랍니다."));
				return;
			}
			var pm_no = (res.Message == null) ? "" : res.Message;
			if (pm_no == "") {
				alert("품의번호 채번에 실패하였습니다.\n\n관리자에게 문의 바랍니다.");
				return;
			}
			openApproval(pm_no);
		}
		,error		: function(){
			loader_obj("N");
			alert("품의 상신 처리 중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
		}
	});
}

/* 공통 결재 팝업 호출. PARAM1 = 회사코드, PARAM2 = 상신자(서버가 KEY_2/KEY_3 로 옮긴다). */
function openApproval(pm_no){
	var t = "매입단가 인상 품의 - " + mdcmBuyUpRows.length + "건";
	openSearchPopup("/common/approval/buyerCommonApprovalPop.do"
		, '?DOC_TYPE=SPM&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO=' + pm_no
		+ '&PARAM1=' + $("#st_com_code").val()
		+ '&PARAM2=' + $("#st_login_id").val()
		+ '&st_title=' + t
		+ '&st_cont='
		, "1000,500,no");
}

/* 결재 팝업이 상신을 마치면 이 함수를 부른다(공통 계약). */
function kepApprovalReturn(flag, docu_no){
	alert("품의가 상신되었습니다.");
	try { if (opener && !opener.closed && typeof opener.doAction == "function") { opener.doAction("search"); } } catch (e) { }
	self.close();
}

/* 정상 행만 배열로 묶는다. 유형선택조회로 숨겨진 행도 대상이므로 표시 여부는 보지 않는다.
 * ⚠ 금액·수량은 콤마를 턴 숫자문자열로, 날짜는 YYYYMMDD 8자리로 보낸다.
 * ⚠ 매입단가 인상 행은 BUY_PRICE_AFTER 를 비워 보낸다 — 품의 전에는 반영하지 않는다. */
function collectApplyRows() {
	var sheet = sheetMod;
	var names = ["BUY_INFO_ID","STATUS_AFTER","STATUS_REASON","BUY_PRICE_AFTER","BUY_PRICE_REASON"
	            ,"BUY_OPEN_DATE_AFTER","BUY_CLOSE_DATE_AFTER","BUY_DATE_REASON","DELIVERY_LT_AFTER","DELIVERY_LT_REASON"
	            ,"ITEM_MAKE_TYPE_AFTER","ITEM_MAKE_TYPE_REASON","TAX_TYPE_AFTER","TAX_TYPE_REASON","SELLER_ITEM_NO_AFTER","SELLER_ITEM_NO_REASON"];

	var param = { s_SAVENAME : names.join("|") };
	for (var i = 0; i < names.length; i++) { param[names[i]] = []; }

	for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
		if (kepTrimStr(sheet.GetCellValue(r, "RESULT")) != "정상") { continue; }
		for (var i = 0; i < names.length; i++) {
			param[names[i]].push(applyValue(sheet, r, names[i]));
		}
	}

	if (param.BUY_INFO_ID.length == 0) {
		alert("반영할 정상 건이 없습니다.");
		return null;
	}
	return param;
}

/* 결재요청 화면(일괄)이 opener 로 읽어 간다. */
var mdcmBuyUpRows = [];

/* 정상 행 중 매입단가 인상만 뽑아 결재요청 화면이 쓸 모양으로 만든다. */
function collectUpRows() {
	var sheet = sheetMod;
	var out   = [];

	for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
		if (kepTrimStr(sheet.GetCellValue(r, "RESULT")) != "정상") { continue; }
		if (kepTrimStr(sheet.GetCellValue(r, "UPDOWN")) != "인상")  { continue; }

		out.push({
			 catlg   : kepTrimStr(sheet.GetCellValue(r, "CMS_CATLG_ID"))
			,buyInfo : kepTrimStr(sheet.GetCellValue(r, "BUY_INFO_ID"))
			,name    : kepTrimStr(sheet.GetCellValue(r, "DESCRIPTION_LOC"))
			,model   : kepTrimStr(sheet.GetCellValue(r, "MODEL_INFO"))
			,spec    : kepTrimStr(sheet.GetCellValue(r, "SPECIFICATION"))
			,maker   : kepTrimStr(sheet.GetCellValue(r, "MAKER_NAME"))
			,measure : kepTrimStr(sheet.GetCellValue(r, "ORDER_MEASURE"))
			,agent   : kepTrimStr(sheet.GetCellValue(r, "AGENT"))
			,vendor  : kepTrimStr(sheet.GetCellValue(r, "AGENT_NAME"))
			,before  : kepTrimStr(sheet.GetCellValue(r, "BUY_PRICE_BEFORE"))
			,after   : kepTrimStr(sheet.GetCellValue(r, "BUY_PRICE_AFTER"))
			,rate    : kepTrimStr(sheet.GetCellValue(r, "CHG_RATE"))
			,reason  : kepTrimStr(sheet.GetCellValue(r, "BUY_PRICE_REASON"))
		});
	}
	return out;
}

function applyValue(sheet, r, name) {
	var v = kepTrimStr(sheet.GetCellValue(r, name));
	if (name == "BUY_PRICE_AFTER") {
		if (kepTrimStr(sheet.GetCellValue(r, "UPDOWN")) == "인상") { return ""; }
		var n = kepParseNum(v);
		return isNaN(n) ? "" : ("" + n);
	}
	if (name == "DELIVERY_LT_AFTER") {
		var n2 = kepParseNum(v);
		return isNaN(n2) ? "" : ("" + n2);
	}
	if (name == "BUY_OPEN_DATE_AFTER" || name == "BUY_CLOSE_DATE_AFTER") {
		return kepToDate8(v);
	}
	return v;
}

/* ── [기존] 값·코드 채우기 ────────────────────────────────
 * 업로드 직후 **1회만** 서버에 묻는다(행마다 부르지 않는다). 조회 전용 요청이다.
 * 검증(validateRows)이 이 결과에 의존하므로 async:false 로 순서를 지킨다. */
function fillBeforeValues(sheet) {
	beforeByCode = {}; codeExists = {}; altExists = {};
	reasonInfo = {}; makeTypeSet = {}; taxTypeSet = {};

	var codes = [];
	var alts  = [];
	for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
		var code = kepTrimStr(sheet.GetCellValue(r, "BUY_INFO_ID"));
		var alt  = kepTrimStr(sheet.GetCellValue(r, "ALT_CODE"));
		if (code != "") { codes.push(code); }
		if (alt  != "") { alts.push(alt); }
	}
	if (codes.length == 0) { return true; }

	var ok = false;
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mdcm/getMasterMdCmCmsBuyInfoModBeforeList.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: { codes: codes.join("@"), altCodes: alts.join("@") },
		async: false,
		success: function( response ) {
			var rows = (response && response.data) ? response.data : [];
			for (var i = 0; i < rows.length; i++) {
				var id = kepTrimStr(rows[i].BUY_INFO_ID);
				beforeByCode[id] = rows[i];
				codeExists[id] = true;
			}

			var alt = (response && response.alt) ? response.alt : [];
			for (var i = 0; i < alt.length; i++) { altExists[kepTrimStr(alt[i])] = true; }

			var reasons = (response && response.reasons) ? response.reasons : [];
			for (var i = 0; i < reasons.length; i++) {
				reasonInfo[kepTrimStr(reasons[i].REASON_NAME)] = {
					 direction   : kepTrimStr(reasons[i].DIRECTION)
					,altRequired : (kepTrimStr(reasons[i].ALT_REQUIRED) == "Y")
				};
			}

			var makes = (response && response.makeTypes) ? response.makeTypes : [];
			for (var i = 0; i < makes.length; i++) { makeTypeSet[kepTrimStr(makes[i])] = true; }

			var taxes = (response && response.taxTypes) ? response.taxTypes : [];
			for (var i = 0; i < taxes.length; i++) { taxTypeSet[kepTrimStr(taxes[i].TAX_NAME)] = true; }

			/* 각 행에 현재값을 꽂는다. 없는 코드(codeExists 미등록)는 공백 그대로 두고 검증이 잡는다.
			 * ⚠ 상품 기본정보·[기존] 밴드는 **엑셀 값이 아니라 DB 현재값**으로 덮는다 —
			 *   양식에서 손댔더라도 결과 화면은 실제 대상의 현재값을 보여 줘야 한다. */
			for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
				var row = beforeByCode[kepTrimStr(sheet.GetCellValue(r, "BUY_INFO_ID"))];
				if (!row) { continue; }
				for (var key in row) {
					if (!row.hasOwnProperty(key) || !modColSet[key]) { continue; }
					if (key == "BUY_INFO_ID") { continue; }
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

/* ── 검증 ──────────────────────────────────────────────
 * 설계 오류사유에, 그대로 두면 반영이 깨지는 것(미존재·형식)을 더했다.
 * 먼저 걸린 것 하나만 남긴다(행당 오류 1건). */
function validateRows() {
	var sheet = sheetMod;
	cnt = {all:0, ok:0, err:0, up:0};

	var seen = {};	// 파일 안에서의 구매정보코드 중복 판정용 (코드 → 최초 등장 No.)
	var no = 0;

	for (var r = sheet.HeaderRows(); r <= sheet.LastRow(); r++) {
		no++;
		applyRate(sheet, r);					// 인상/인하·변동율은 판정과 무관하게 먼저 채운다
		var err = checkModRow(sheet, r, seen, no);

		sheet.SetCellValue(r, "RESULT",     (err.reason == "") ? "정상" : "오류", 0);
		sheet.SetCellValue(r, "ERR_COL",    err.column, 0);
		sheet.SetCellValue(r, "ERR_REASON", err.reason, 0);

		if (err.reason == "") {
			cnt.ok++;
			if (kepTrimStr(sheet.GetCellValue(r, "UPDOWN")) == "인상") { cnt.up++; }
		} else {
			cnt.err++;
			markError(sheet, r, err.cols);
		}
		cnt.all++;
	}
}

/* 매입단가 인상/인하 · 변동율.
 * ★ 매입단가는 인상이 결재 대상이다(기준가와 반대). */
function applyRate(sheet, r) {
	var before = sheet.GetCellValue(r, "BUY_PRICE_BEFORE");
	var after  = sheet.GetCellValue(r, "BUY_PRICE_AFTER");

	sheet.SetCellValue(r, "BUY_PRICE_BEFORE", kepNumToComma(before), 0);
	if (kepTrimStr(after) != "") { sheet.SetCellValue(r, "BUY_PRICE_AFTER", kepNumToComma(after), 0); }

	var res = kepRateChange(before, after);
	sheet.SetCellValue(r, "UPDOWN",   (res.up == null) ? "" : (res.up ? "인상" : "인하"), 0);
	sheet.SetCellValue(r, "CHG_RATE", res.text, 0);
	if (res.up != null) {
		sheet.SetCellFontColor(r, "CHG_RATE", res.up ? UP_TXT : DOWN_TXT);
		sheet.SetCellFontColor(r, "UPDOWN",   res.up ? UP_TXT : DOWN_TXT);
	}
}

// 오류 항목 셀에 색을 입힌다
function markError(sheet, r, cols) {
	if (!cols) { return; }
	for (var i = 0; i < cols.length; i++) {
		if (!modColSet[cols[i]]) { continue; }
		sheet.SetCellBackColor(r, cols[i], ERR_BG);
	}
}

/* 판정 순서는 '행 자체가 무효 → 변경 유무 → 값 규칙 → 동일값' 순이다.
 * 한 행에 여러 건이 걸리면 **전부** 모아 " / " 로 이어 붙인다 — [오류항목]·[오류사유]가 같은 순서로 짝을 이룬다.
 * ⚠ 앞 4건(코드 미입력·미존재·중복, 변경 값 미존재)만은 그 자리에서 끊는다 —
 *   뒤 판정의 전제라, 실재하지 않는 코드나 아무것도 안 고친 행에 값 규칙·동일값을 따질 수 없다.
 * 반환 {reason:"", column:"", cols:[]} — column 은 화면에 보일 오류항목 이름. */
function checkModRow(sheet, r, seen, no) {
	var get = function(col) { return kepTrimStr(sheet.GetCellValue(r, col)); };

	// (a) 행 자체가 무효
	var code = get("BUY_INFO_ID");
	if (get("BUY_INFO_SEQ") == "") { return err("구매정보코드 미입력", "구매정보코드", ["BUY_INFO_SEQ"]); }
	// 순번만으로는 어느 상품의 구매정보인지 알 수 없다 - 같은 행의 상품정보코드가 있어야 키가 선다
	if (code == "")        { return err("상품정보코드 미입력", "상품정보코드", ["CMS_CATLG_ID"]); }
	if (!codeExists[code]) { return err("구매정보코드 미존재", "구매정보코드", ["BUY_INFO_SEQ"]); }

	// ③ 동일한 구매정보코드
	if (seen[code]) { return err("동일한 구매정보코드 (No." + seen[code] + "과 동일)", "구매정보코드", ["BUY_INFO_SEQ"]); }
	seen[code] = no;

	// ② 변경 값 미존재 — 아무것도 안 고친 행에는 뒤 판정이 성립하지 않는다
	var filled = 0;
	var same   = 0;
	for (var i = 0; i < MDCM_MODB_SETS.length; i++) {
		var set = MDCM_MODB_SETS[i];
		var after = get(set.after);
		if (after == "") { continue; }
		filled++;
		if (isSameValue(set, after, get(set.before))) { same++; }
	}
	if (filled == 0) { return err("변경 값 미존재", "변경", []); }

	// 이 행에서 걸린 오류를 순서대로 쌓는다.
	var errCols = [], errMsgs = [], errCells = [];
	var addErr = function(column, reason, cols) {
		errCols.push(column);
		errMsgs.push(reason);
		for (var j = 0; j < cols.length; j++) { errCells.push(cols[j]); }
	};

	checkValues(get, addErr);	// (b) 값 규칙 — 변경 열에 값이 있을 때만 본다
	checkSupply(get, addErr);	// (c) 공급상태·대체코드 규약

	// ① 동일값(변경 전-변경 후)
	if (filled == same) { addErr("변경", "동일값(변경 전-변경 후)", []); }

	// 오류가 없으면 두 배열 모두 비어 있어 join 결과가 "" 다 — 그대로 '정상' 판정으로 흘러간다.
	return err(errMsgs.join(" / "), errCols.join(" / "), errCells);
}

// 값 형식·실재 검사. 변경 열이 비어 있으면 건너뛴다. 걸린 건 addErr 로 모두 쌓는다.
function checkValues(get, addErr) {
	var status = get("STATUS_AFTER");
	if (status != "" && status != "가능" && status != "불가") {
		addErr("공급상태", "공급상태 값 오류(가능/불가)", ["STATUS_AFTER"]);
	}

	var price = get("BUY_PRICE_AFTER");
	if (price != "") {
		var n = kepParseNum(price);
		if (isNaN(n)) { addErr("매입단가", "매입단가 형식 오류(숫자만 입력)", ["BUY_PRICE_AFTER"]); }
		if (n <= 0)   { addErr("매입단가", "매입단가는 0보다 커야 합니다",     ["BUY_PRICE_AFTER"]); }
	}

	var lt = get("DELIVERY_LT_AFTER");
	if (lt != "") {
		var n2 = kepParseNum(lt);
		if (isNaN(n2)) { addErr("배송일수", "배송일수 형식 오류(숫자만 입력)", ["DELIVERY_LT_AFTER"]); }
		if (n2 < 0)    { addErr("배송일수", "배송일수는 0보다 작을 수 없습니다", ["DELIVERY_LT_AFTER"]); }
	}

	var make = get("ITEM_MAKE_TYPE_AFTER");
	if (make != "" && !makeTypeSet[make]) { addErr("품목구분", "품목구분 미존재", ["ITEM_MAKE_TYPE_AFTER"]); }

	var tax = get("TAX_TYPE_AFTER");
	if (tax != "" && !taxTypeSet[tax]) { addErr("과세구분", "과세구분 미존재", ["TAX_TYPE_AFTER"]); }

	/* 유효기간 — 한쪽만 바꿔도 되므로 안 바꾼 쪽은 기존값으로 메워 앞뒤를 본다. */
	var from = get("BUY_OPEN_DATE_AFTER");
	var to   = get("BUY_CLOSE_DATE_AFTER");
	if (from != "" && kepToDate8(from) == "") { addErr("유효기간 시작일", "유효기간 시작일 형식 오류(YYYYMMDD)", ["BUY_OPEN_DATE_AFTER"]); }
	if (to   != "" && kepToDate8(to)   == "") { addErr("유효기간 종료일", "유효기간 종료일 형식 오류(YYYYMMDD)", ["BUY_CLOSE_DATE_AFTER"]); }
	if (from != "" || to != "") {
		var f = kepToDate8(from != "" ? from : get("BUY_OPEN_DATE_BEFORE"));
		var t = kepToDate8(to   != "" ? to   : get("BUY_CLOSE_DATE_BEFORE"));
		if (f != "" && t != "" && f > t) {
			addErr("매입단가 유효기간", "유효기간이 거꾸로입니다", ["BUY_OPEN_DATE_AFTER", "BUY_CLOSE_DATE_AFTER"]);
		}
	}
}

/* 공급상태 · 변경사유 · 대체코드 규약.
 * ★ 대체코드 필수 여부는 서버가 내려준 사유 목록(ALT_REQUIRED)이 정본이다 — 지금은 '중복존재'가 유일하다. */
function checkSupply(get, addErr) {
	var status = get("STATUS_AFTER");
	var reason = get("STATUS_REASON");
	var alt    = get("ALT_CODE");
	var before = get("STATUS_BEFORE");

	if (status != "" && reason == "") { addErr("변경사유", "공급상태 변경사유 미입력", ["STATUS_REASON"]); }
	if (reason != "" && status == "") { addErr("공급상태", "공급상태 미입력(변경사유만 입력)", ["STATUS_AFTER"]); }

	var info = (reason == "") ? null : reasonInfo[reason];
	if (reason != "" && info == null) { addErr("변경사유", "변경사유 미존재", ["STATUS_REASON"]); }

	/* 사유는 방향이 있다 — OUT(가능→불가) / IN(불가→가능). 방향이 어긋난 사유는 받지 않는다. */
	if (info != null && status != "" && before != "") {
		var want = (status == "불가") ? "OUT" : "IN";
		if (info.direction != "" && info.direction != want) {
			addErr("변경사유", "변경사유가 공급상태 방향과 맞지 않습니다", ["STATUS_REASON"]);
		}
	}

	var needAlt = (info != null) ? info.altRequired : (reason == MDCM_MODB_ALT_REASON);
	if (needAlt && alt == "") { addErr("대체코드", "대체코드 미입력", ["ALT_CODE"]); }
	if (!needAlt && alt != "") { addErr("대체코드", "변경사유-대체코드 값 불일치", ["ALT_CODE", "STATUS_REASON"]); }
	if (alt != "" && !altExists[alt]) { addErr("대체코드", "대체코드 미존재", ["ALT_CODE"]); }
}

/* 같은 값인가. 숫자·날짜는 표기가 달라도 같은 값일 수 있어 정규화해 본다.
 * ⚠ 협력사 품목코드의 `DELETE` 는 '지운다'는 뜻이라 기존값이 있으면 동일값이 아니다. */
function isSameValue(set, after, before) {
	if (set.after == "SELLER_ITEM_NO_AFTER" && after.toUpperCase() == MDCM_MODB_DELETE_MARK) {
		return (before == "");
	}
	if (set.kind == "num") {
		var a = kepParseNum(after), b = kepParseNum(before);
		if (!isNaN(a) && !isNaN(b)) { return (a == b); }
	}
	if (set.kind == "date") {
		return (kepToDate8(after) == kepToDate8(before));
	}
	return (after == before);
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
		"오류 " + cnt.err + " 건을 제외한 " + cnt.ok + " 건이 반영되며, "
		+ cnt.ok + " 건 중 " + cnt.up + " 건(매입단가 인상)은 품의가 상신됩니다.";
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
	for (var r = sheetMod.HeaderRows(); r <= sheetMod.LastRow(); r++) {
		sheetMod.SetRowHidden(r, matchKind(sheetMod, r, kind) ? 0 : 1);
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

	sheetMod.Down2Excel({
		 FileName : "구매정보_일괄수정_업로드결과" + (errOnly ? "_오류건" : "") + ".xls"
		,Merge : 1
		,SheetDesign : 1
		,DownRows : "Visible"
		,DownCols : getModDownCols()
	});
}

// 상태 컬럼(sStatus)과 숨긴 키 컬럼(전체 구매정보코드)은 뺀다 - 화면에 없는 값이 엑셀에만 나오면 안 된다.
function getModDownCols() {
	var arr = [];
	for (var i = 0; i < modColNames.length; i++) {
		if (modColNames[i] == "sStatus") { continue; }
		if (modColNames[i] == "BUY_INFO_ID") { continue; }
		arr.push(modColNames[i]);
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
	// [기존]값 조회가 실패하면 동일값·코드 실재를 판정할 수 없다 — 결과화면으로 넘어가지 않는다.
	if (!fillBeforeValues(sheet)) { return; }
	validateRows();

	curTab = "ALL";
	setResultTab("ALL");
	sheetMod.Render();
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
			<h1 class="title" id="popTitle">일괄 업로드 결과 확인 (구매정보 일괄수정)</h1>
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
							createIBSheet("sheetMod", "100%", "320px");
						</script>
					</div>
					<p class="resNote">※ 오류 행은 [결과] 컬럼이 '오류'로 표시되며, 해당 셀에 색이 입혀지고 [오류항목]·[오류사유] 컬럼에 사유가 노출됩니다. 매입단가 인하는 즉시 반영, 인상은 품의 상신 대상입니다.</p>
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
