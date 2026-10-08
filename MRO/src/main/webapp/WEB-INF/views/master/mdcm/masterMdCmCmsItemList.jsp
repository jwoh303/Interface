<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>상품정보 조회 및 관리

* 화면 : 상품정보 조회 및 관리
* 기능 : 상품정보 조회 및 관리
* 프로그램 ID : 
* 담당자 :  홍준우
* 착수일 : 2026-06-12
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
	
	// MSDS(물질정보) 담당자 여부. 'Y' 일 때만 매핑/해제 아이콘을 낸다 - 조회는 전원 가능
	String st_msds_user_yn = CommonUtil.getCodeCheckReturn("CM10", userId) ? "Y" : "N";

	//소싱부서 여부
	String st_user_dept = CommonUtil.nvl(sessionInfo.getDepartment());
	String st_sour_dept_yn = "";
	boolean st_sour_dept = CommonUtil.getCodeCheckReturn("SOURDEPT", st_user_dept);
	// ⚠ 임시 : 개발자 계정(부서 095 = SOURDEPT 아님) 확인용 예외. 상세팝업(masterMdCmCmsItemDetailPop)과 같은 줄이 있다 — 뺄 때 둘 다 뺀다.
	if("KEP2239016".equals(userId)){ st_sour_dept = true; }
	if(st_sour_dept == true){
		st_sour_dept_yn = "Y";
	}else{
		st_sour_dept_yn = "N";
	}
%>

<script src="/resources/js/common.js"></script>
<!-- 일괄수정 양식 컬럼·엑셀 열 정의 (결과 팝업과 공유) -->
<script src="/resources/js/mdcm/cmsItemModForm.js"></script>
<!-- 기준가 일괄수정 양식 컬럼·엑셀 열 정의 (결과 팝업과 공유) -->
<script src="/resources/js/mdcm/cmsBasePriceForm.js"></script>
<!-- 양식 대조 : 올린 파일이 그 화면의 양식이 맞는지 확인 -->
<script src="/resources/js/mdcm/excelFormCheck.js"></script>
<script>
var mySheet = new ibsheetObject();
var modSheet = new ibsheetObject();	// 화면에 안 보이는 시트 — 수정양식 다운로드/업로드 전담
var priceSheet = new ibsheetObject();	// 화면에 안 보이는 시트 — 기준가양식 업로드 전담
var mdcmUploadRows = null;			// LoadExcel 로 읽은 행. 결과 팝업이 opener 로 읽어 간다
var mdcmPriceRows  = null;			// 기준가 양식에서 읽은 행. 기준가 결과 팝업이 opener 로 읽어 간다
/* 양식 1회 다운로드 상한.
 * 서버가 POI(XSSF)로 워크북을 통째로 메모리에 만든다 — XSSF 는 셀당 약 1KB 를 쓰므로
 * 58열 × 1,000행이면 이미 60MB 수준이다. 3,000행이면 170MB 를 넘어 OOM 위험이 실질적이고,
 * 이 앱은 OOM 을 catch(Error) 로 삼켜 조용히 실패한다.
 * ⚠ 이 값을 올릴 때는 서버(MasterMdCmCmsItemExcelUploadController.MOD_FORM_MAX_ROWS)도 같이 올려야 한다. */
var MOD_FORM_MAX_ROWS = 1000;

/* 조회결과 엑셀다운로드 1회 상한. 화면에서만 막는다 - 서버 라우트는 열려 있다.
 * 다운로드는 pageflag=0 으로 페이징을 풀어 조회 전건을 내려받는다 - 조건을 넓게 잡으면 274만 행이 후보다.
 * 목록이 40열이고 워크북을 메모리에 통째로 만들기 때문에 행수가 곧 힙이다(위 양식 다운로드와 같은 이유). */
var EXCEL_DOWN_MAX_ROWS = 5000;

/* 양식 업로드 1회 상한. 화면에서만 막는다.
 * 메모리가 아니라 등록 단계의 DB 왕복이 병목이다 - 상품 1건마다 채번 2회 + 헤더 1회 + 변경항목 수만큼 INSERT 가 돈다.
 * 채번이 ICOMSQMT 를 SELECT 후 UPDATE 하는 방식이라 건수가 늘수록 그 행을 잡았다 놨다 하는 시간도 같이 는다.
 * ⚠ 서버(LoadExcel.jsp setMaxRows)는 30000 이라 여기를 풀면 그대로 통과한다. */
var EXCEL_UP_MAX_ROWS = 5000;

/* 화면 권한 - 구매팀(SOURDEPT 소속) / 그 외 = 사업팀.
 *   구매 : 엑셀다운로드 가능
 *   사업 : 상품정보코드·품목명·모델번호·제조사 중 1개 이상 입력해야 조회 · 엑셀다운로드 불가
 *  */
var SOUR_DEPT_YN   = "<%=st_sour_dept_yn%>";

/* ── 수정양식 다운로드 로딩바 ──────────────────────────────────────────
 * 다운로드는 숨은 iframe 으로 받기 때문에 공통 ajax 로더(loader_obj)가 자동으로 걸리지 않는다.
 * 게다가 attachment 응답은 iframe 을 이동시키지 않아 onload 도 오지 않는다.
 * → 1회용 토큰을 같이 보내고, 서버가 응답에 심어 주는 쿠키(mroDownToken)가 그 토큰이 되면 내린다.
 *   서버: MasterMdCmCmsItemExcelUploadController → IBSheetUtil.setDownTokenCookie */
var MOD_FORM_DOWN_TOKEN  = null;
var modFormDownTimer     = null;
var modFormDownGiveUp    = null;
var MOD_FORM_DOWN_LIMIT  = 300 * 1000;	// 1000건까지 만드는 화면이라 넉넉히 5분

function modFormDownStart(rowCount) {
	MOD_FORM_DOWN_TOKEN = "t" + new Date().getTime() + "" + Math.floor(Math.random() * 100000);
	// 수정양식·기준가양식이 같은 iframe·쿠키 규약을 쓴다 — 어느 쪽이 submit 되든 토큰은 하나다
	$("#modFormToken").val(MOD_FORM_DOWN_TOKEN);
	$("#priceFormToken").val(MOD_FORM_DOWN_TOKEN);

	loader_obj("Y");
	modFormDownTimer  = setInterval(modFormDownCheck, 300);
	modFormDownGiveUp = setTimeout(function() {
		modFormDownEnd();
		alert("양식 생성이 지연되고 있습니다. 잠시 후 다시 시도하거나, 선택 건수를 줄여 주세요.");
	}, MOD_FORM_DOWN_LIMIT);
}

function modFormDownCheck() {
	if (MOD_FORM_DOWN_TOKEN == null) { return; }
	if (document.cookie.indexOf("mroDownToken=" + MOD_FORM_DOWN_TOKEN) < 0) { return; }
	modFormDownEnd();
}

function modFormDownEnd() {
	if (modFormDownTimer  != null) { clearInterval(modFormDownTimer);  modFormDownTimer  = null; }
	if (modFormDownGiveUp != null) { clearTimeout(modFormDownGiveUp);  modFormDownGiveUp = null; }
	MOD_FORM_DOWN_TOKEN = null;
	// 다음 다운로드가 이전 신호를 보고 바로 끝났다고 착각하지 않도록 쿠키를 지운다
	document.cookie = "mroDownToken=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT";
	loader_obj("N");
}
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var current_page = -1;	// 현재 페이지 번호 (-1 : 조회 직후 1페이지)
var popupSel = "";		// 어떤 팝업의 콜백인지 구분
var gridCategoryRow = 0;	// 그리드 상세분류 셀 클릭으로 팝업을 연 행 번호
var msdsRow = 0;			// MSDS 매핑 아이콘을 누른 행 번호

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
		,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"상품정보코드",	SaveName:"CMS_CATLG_ID"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Type:"Text",	Header:"상품상태",	SaveName:"STATUS_NM"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Hidden:true,	Type:"Text",	Header:"상품상태코드",	SaveName:"STATUS"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:25,	Type:"Text",	Header:"품목명",		SaveName:"DESCRIPTION_LOC" }
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"모델번호",		SaveName:"MODEL_INFO"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:25,	Type:"Text",	Header:"규격",		SaveName:"SPECIFICATION" }
		,{ Align:"Left",	Width:90,	Edit:false,	EditLen:25,	Type:"Text",	Header:"제조사",		SaveName:"MAKER_NAME"}
		,{ Align:"Left",	Width:90,	Edit:false,	EditLen:25,	Hidden:true, 	Type:"Text",	Header:"제조사코드",		SaveName:"MAKER_CODE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:25,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_CODE_NAME"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:25,	Hidden:true,	Type:"Text",	Header:"원산지코드",	SaveName:"ORIGIN_CODE"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:25,	Type:"Text",	Header:"단위",		SaveName:"ORDER_MEASURE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Type:"Text",	Header:"상품구분",	SaveName:"ITEM_GUBUN_NM"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Hidden:true,	Type:"Text",	Header:"상품구분코드",	SaveName:"ITEM_GUBUN"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Type:"Text",	Header:"일회성\n구분",	SaveName:"ONETIME_NM"}
		,{ Align:"Center",	Width:150,	Edit:false,	EditLen:25,	Type:"Text",	Header:"TR가능여부",	SaveName:"TR_HANDLE_NM"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:25,	Type:"Text",	Header:"카테고리",	SaveName:"SG_NAME"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Hidden:true,	Type:"Text",	Header:"카테고리코드",	SaveName:"SG_ID"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"상세분류\n코드",	SaveName:"CMS_CATEG_ID"  }
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:25,	Type:"Text",	Header:"상세분류",		SaveName:"CMS_CATEG_NAME"  }
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"구매담당자",	SaveName:"KEP_USER_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Hidden:true,	Type:"Text",	Header:"구매담당자ID",	SaveName:"KEP_USER_NO"}
		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:25,	Type:"Float",	Format:"${priceFormat}",	Header:"기준가",	SaveName:"BASE_PRICE"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:25,	Type:"Text",	Header:"기준가유형",	SaveName:"BASE_PRICE_TYPE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"미사용\n변경사유",	SaveName:"UNUSE_REASON"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"대체코드",	SaveName:"ALT_CODE"}
	<%if(st_msds_user_yn.equals("Y")){%>
		,{ Align:"Center",	Width:28,	Edit:false,	EditLen:25,	Type:"Image",	Header:"화학물질정보\nNo.",	SaveName:"PRINT"}
	<%}%>
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:25,	Type:"Text",	Header:"화학물질정보\nNo.",	SaveName:"CHEM_INFO_NO"}
	<%if(st_msds_user_yn.equals("Y")){%>
		,{ Align:"Center",	Width:28,	Edit:false,	EditLen:25,	Type:"Image",	Header:"화학물질정보\nNo.",	SaveName:"ERASE_MSDS_NO"}
	<%}%>
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Hidden:true,	Type:"Text",	Header:"MSDS No.",	SaveName:"MSDS_NO"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Hidden:true,	Type:"Text",	Header:"AC No.",	SaveName:"AC_NO"}
		,{ Align:"Center",	Width:30,	Edit:true,	EditLen:100,	Hidden:true,	Type:"DummyCheck",	Header:"",	SaveName:"MSDS_CHK"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Type:"Text",	Header:"유해화학\n물질",		SaveName:"HARMFUL_YN"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Type:"Text",	Header:"안전인증\n여부",	SaveName:"SAFE_STATUS_NM"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Type:"Text",	Header:"안전인증\n구분",	SaveName:"SAFE_TYPE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"상품정보\n등록일",	SaveName:"ADD_DATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Type:"Text",	Header:"변경\n이력",	SaveName:"HISTORY"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"최종변경일",	SaveName:"CHANGE_DATE"}

	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	//하이퍼링크 설정 (상품정보코드 → 상세 팝업 / 상세분류 → 카테고리·속성 팝업)
	setLinkCol(mySheet, "CMS_CATLG_ID");
	setLinkCol(mySheet, "CMS_CATEG_NAME");
	setLinkCol(mySheet, "CHEM_INFO_NO");
<%if(st_msds_user_yn.equals("Y")){%>
	setLinkCol(mySheet, "PRINT");
	setLinkCol(mySheet, "ERASE_MSDS_NO");
	mySheet.SetImageList(1, "/resources/images/disk_on.gif");
	mySheet.SetImageList(5, "/resources/images/btn_eraser2.gif");
<%}%>
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M") );          // 당일 -1개월
	$("#st_to_date").val( kepGetNowTimeStr("YYYYMMDD","/") );  // 오늘

	setDeptAuth();

	initModSheet();
	initPriceSheet();
}

/* 화면 권한 2분기 적용 — 로딩 시 1회. 사업팀은 엑셀다운로드 버튼을 감춘다.
 * ⚠ 다운로드 차단은 화면에서만 막는다 — 서버 라우트(/mdam/getMasterMdCmCmsItemExcelList.do)는 그대로다. */
function setDeptAuth() {
	if (SOUR_DEPT_YN != "Y") {
		$("#btnExcelDown").hide();
	}
}

/* 사업팀 필수 조회조건 — 상품정보코드 · 품목명 · 모델번호 · 제조사 중 1개 이상
 * 상품정보코드는 대량입력(hidden) 쪽으로만 들어올 수 있어 둘 다 본다. */
function hasBusiDeptCond() {
	return ($.trim($("#st_cmscatlg").val())       != "")
		|| ($.trim($("#st_cmscatlg_multi").val()) != "")
		|| ($.trim($("#st_item_name").val())      != "")
		|| ($.trim($("#st_model_info").val())     != "")
		|| ($.trim($("#st_maker_code").val())     != "");
}

/* 수정양식 입출력 전용 숨은 시트.
 * 화면에 안 보이지만 Down2Excel/LoadExcel 이 시트를 요구하므로 실체가 있어야 한다.
 * 컬럼 정의는 결과 팝업과 공유한다(cmsItemModForm.js) — 한쪽만 고치면 엑셀 열이 어긋난다. */
function initModSheet() {
	var initsheet = {};
	initsheet.Cols = mdcmModCols();
	initsheet.Cfg  = {MergeSheet:msHeaderOnly, FrozenCol:0, UseNoDataRow:1};
	IBS_InitSheet(modSheet, initsheet, "N");
}

/* 기준가양식 업로드 전용 숨은 시트. modSheet 와 같은 이유로 실체가 있어야 한다
 * 컬럼 정의는 기준가 결과 팝업과 공유한다(cmsBasePriceForm.js). */
function initPriceSheet() {
	var initsheet = {};
	initsheet.Cols = mdcmPriceCols();
	initsheet.Cfg  = {MergeSheet:msHeaderOnly, FrozenCol:0, UseNoDataRow:1};
	IBS_InitSheet(priceSheet, initsheet, "N");
}

/* 그리드에서 체크된 행의 상품정보코드.
 * 양식 생성은 서버가 한다(POI) — 화면은 어떤 상품을 받을지만 넘긴다. 현재값은 서버가 채운다. */
function checkedModCodes() {
	var codes = [];
	for (var r = mySheet.HeaderRows(); r <= mySheet.LastRow(); r++) {
		if (mySheet.GetCellValue(r, "SELECTED") != 1) { continue; }
		var code = mySheet.GetCellValue(r, "CMS_CATLG_ID");
		if (code != null && ("" + code) != "") { codes.push(code); }
	}
	return codes;
}

// 기능함수
function doAction(str) {	
	
	
	switch (str) {
	case "search":	 // 조회
		// 품목명/모델번호/규격은 각각 2글자 이상 입력 시에만 조회
		var itemName = $.trim($("#st_item_name").val());
		var modelInfo = $.trim($("#st_model_info").val());
		var specification = $.trim($("#st_specification").val());
		if(itemName != "" && itemName.length < 2){
			alert("품목명은 2글자 이상 입력하세요.");
			return;
		}
		if(modelInfo != "" && modelInfo.length < 2){
			alert("모델번호는 2글자 이상 입력하세요.");
			return;
		}
		if(specification != "" && specification.length < 2){
			alert("규격은 2글자 이상 입력하세요.");
			return;
		}
		// 사업팀은 상품정보코드·품목명·모델번호·제조사 중 1개 이상을 넣어야 조회할 수 있다
		if(SOUR_DEPT_YN != "Y" && !hasBusiDeptCond()){
			alert("상품정보코드, 품목명, 모델번호, 제조사 중 1개 이상 입력하세요.");
			return;
		}
		/* 기간무시 체크 시 - 상품정보코드 · 카테고리 · 상세분류 · 구매담당자 중 1개 이상 필수.
		 * 날짜 조건이 빠지면 274만 행이 후보가 되므로, 인덱스로 대상을 먼저 줄이는 축만 허용한다
		 * (품목명·규격 같은 LIKE '%…%' 는 풀스캔이라 여기서 받지 않는다).
		 * 상품정보코드는 PK 라 단독으로도 즉시 나온다 - 대량입력(hidden) 쪽으로만 들어올 수 있어 둘 다 본다. */
		if($("#st_checkbox").is(":checked")){
			var hasCond = ($.trim($("#st_cmscatlg").val())       != "")		// 상품정보코드
					   || ($.trim($("#st_cmscatlg_multi").val()) != "")		// 상품정보코드(대량입력)
					   || ($.trim($("#st_sg_id_multi").val())    != "")		// 카테고리(SG, 복수)
					   || ($.trim($("#st_categ_id_multi").val()) != "")		// 상세분류(복수)
					   || ($.trim($("#st_kep_user_no").val())    != "")		// 구매담당자(사번)
					   || ($.trim($("#st_kep_user_name").val())  != "");		// 구매담당자(이름)
			if(!hasCond){
				alert("기간무시 조회 시 상품정보코드, 카테고리, 상세분류, 구매담당자 중 1개 이상 입력하세요.");
				return;
			}
		}
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdam/getMasterMdCmCmsItemList.do" , pagingMode );
		break;

	case "reload":	// 초기화
		kepReload('searchCondition');
		$("#st_cmscatlg").val("");
		$("#st_cmscatlg_multi").val("");
		$("#st_chem_no_multi").val("");
		$("#st_status").val("");
		$("#st_sg_id_multi").val("");
		$("#st_sg_name").val("");
		$("#st_categ_id_multi").val("");
		$("#st_categ_name_multi").val("");
		$("#st_category_path").val("");
		$("#st_item_name").val("");
		$("#st_model_info").val("");
		$("#st_specification").val("");
		$("#st_item_gubun").val("");
		$("#st_onetime_yn").val("");
		$("#st_maker_code").val("");
		$("#st_maker_name").val("");
		$("#st_kep_user_name").val("");
		$("#st_kep_user_no").val("");
		$("#st_chem_no").val("");
		$("#st_harmful_yn").val("");
		$("#st_checkbox").prop("checked", false);
		//조회일자는 기본값(이전 1개월 ~ 오늘)으로 복원
		$("#st_from_date").val( kepToMonthAdd("1","M") );
		$("#st_to_date").val( kepGetNowTimeStr("YYYYMMDD","/") );
		current_page = -1;
		mySheet.RemoveAll();
		$("#pageindex").html("");
		break;

	case "excelDown": //엑셀다운로드 - 조회결과 전건(pageflag=0 으로 페이징 해제)

		if(SOUR_DEPT_YN != "Y"){	// 사업팀은 다운로드 불가
			return;
		}
		if(mySheet.RowCount() <= 0){
			alert("조회된 내역이 없습니다.");
			return;
		}
		/* 체크된 행이 있으면 **그 행만** 내려받는다 — 서버를 다시 타지 않고 화면 그리드에서 바로 만든다.
		   체크가 하나도 없으면 종전대로 조회결과 전건을 서버에서 받는다(아래). */
		var downRow = "";
		for (var r = mySheet.HeaderRows(); r <= mySheet.LastRow(); r++) {
			if (mySheet.GetCellValue(r, "SELECTED") == 1) { downRow += "|" + r; }
		}
		if (downRow != "") {
			var headRow = "";
			for (var h = 0; h < mySheet.HeaderRows(); h++) { headRow += "|" + h; }
			downRow = headRow + downRow;
			/* ⚠ 확장자는 xls 다 — Down2Excel 은 xlsx 를 지원하지 않는다. 전건 다운로드도 같은 확장자로 맞춘다(아래). */
			mySheet.Down2Excel({ FileName:"상품정보리스트.xls", SheetName:"상품정보리스트"
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
		/* 화면에 그려진 컬럼만 내려받는다 — 종전엔 상품상태코드·MSDS_CHK 같은 내부 키까지 따라 나왔다.
		   ⚠ 제외의 주체는 DownCols 다. HiddenColumn 은 "숨긴 상태로 포함"이라 제외 옵션이 아니다
		      (ui/ibsheet.md §2). 체크 다운로드와 같은 컬럼 목록을 쓴다. */
		var param = {FileName:"상품정보리스트.xls", HiddenColumn:0, DownCols:kepSheetExcelDownCols(mySheet)};
		kepDownExcel(document.searchCondition, mySheet , "/mdam/getMasterMdCmCmsItemExcelList.do", param);
		$("#pageflag").val('1');
		break;

	case "formDown": // 양식 다운로드 - 종류는 st_form_type 셀렉트로 고른다
		doAction($("#st_form_type").val() == "PRICE" ? "priceFormDown" : "modFormDown");
		break;

	case "formUp":   // 양식 업로드
		doAction($("#st_form_type").val() == "PRICE" ? "priceFormUp" : "modFormUp");
		break;

	case "modFormDown": // 수정 양식 다운로드 — 체크한 상품의 현재값이 채워진 양식
		if (mySheet.RowCount() <= 0) {
			alert("조회된 내역이 없습니다.");
			return;
		}
		var modCodes = checkedModCodes();
		if (modCodes.length == 0) {
			alert("양식을 받을 상품을 선택하세요.");
			return;
		}
		if (modCodes.length > MOD_FORM_MAX_ROWS) {
			alert("양식은 한 번에 " + MOD_FORM_MAX_ROWS + "건까지 받을 수 있습니다.\n선택 : " + modCodes.length + "건");
			return;
		}
		// 응답이 파일이라 AJAX 로는 못 받는다 → 숨은 iframe 을 대상으로 form submit 한다(화면 이동 없음).
		// 파일 응답은 iframe 을 이동시키지 않아 onload 가 오지 않는다 → 서버가 심어 주는 쿠키로 끝을 안다.
		$("#modFormCodes").val(modCodes.join("@"));
		modFormDownStart(modCodes.length);
		document.modFormDownload.submit();
		break;

	case "modFormUp": // 수정 양식 업로드
		modSheet.RemoveAll();
		mdcmUploadRows = null;
		modSheet.SetWaitImageVisible(false);	// IBSheet 자체 대기이미지 대신 공통 로딩바를 쓴다
		loader_obj("Y");
		// ⚠ Mode:"NoHeader" 를 빼면 IBSheet 가 StartRow 부터 그리드 헤더행 수(2행)만큼을
		//   헤더로 먹어치워 **앞 2행이 조용히 사라진다**(2026-09-01 실측: 3행 → 1행).
		//   이 프로젝트의 ColumnMapping 업로드는 예외 없이 전부 NoHeader 를 넘긴다.
		// ⚠ StartRow 는 1 이다 - 머리글까지 읽어 와 양식을 대조한다(mdcmFormCheck). 데이터는 그 뒤부터 담는다.
		modSheet.LoadExcel({Mode:"NoHeader", ColumnMapping:mdcmModColMapping(), StartRow:"1"});
		break;

	case "priceFormDown": // 기준가 양식 다운로드 — 체크한 상품의 현재 기준가가 채워진 양식
		if (mySheet.RowCount() <= 0) {
			alert("조회된 내역이 없습니다.");
			return;
		}
		var priceCodes = checkedModCodes();
		if (priceCodes.length == 0) {
			alert("양식을 받을 상품을 선택하세요.");
			return;
		}
		if (priceCodes.length > MOD_FORM_MAX_ROWS) {
			alert("양식은 한 번에 " + MOD_FORM_MAX_ROWS + "건까지 받을 수 있습니다.\n선택 : " + priceCodes.length + "건");
			return;
		}
		$("#priceFormCodes").val(priceCodes.join("@"));
		modFormDownStart(priceCodes.length);	// 로딩바·완료 쿠키 규약은 수정양식과 공유한다
		document.priceFormDownload.submit();
		break;

	case "priceFormUp": // 기준가 양식 업로드
		priceSheet.RemoveAll();
		mdcmPriceRows = null;
		priceSheet.SetWaitImageVisible(false);	// IBSheet 자체 대기이미지 대신 공통 로딩바를 쓴다
		loader_obj("Y");		
		// ⚠ StartRow 는 1 이다 - 머리글까지 읽어 와 양식을 대조한다(mdcmFormCheck). 데이터는 그 뒤부터 담는다.
		priceSheet.LoadExcel({Mode:"NoHeader", ColumnMapping:mdcmPriceColMapping(), StartRow:"1"});
		break;

	case "catelist": // 상세분류조회 
		popupSel = "";
		gridCategoryRow = 0;
		openSearchPopup("/mdcm/showMasterMdCmCmsItemCategorySelPop.do", "", "810,509,no");
		break;
	}
}
//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {	
	return DATA;
}
//엑셀 다운로드 후 처리
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}	

/* 수정양식 업로드(LoadExcel) 후처리 — 읽은 행을 담아 두고 **결과 팝업을 연다**.
 * 파일은 창 사이로 넘길 수 없어 파싱은 여기서 하고, 팝업은 opener.mdcmUploadRows 를 읽는다.
 * ⚠ 팝업 크기는 팝업이 표시 컬럼 폭·행 수에 맞춰 스스로 다시 잡는다 — 여기 값은 첫 프레임용이다. */
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

	if (!mdcmFormCheck(modSheet, MDCM_MOD_DATA_START_ROW, MDCM_MOD_EXCEL_COLS, mdcmModFormHead(), "상품정보 일괄수정")) {
		modSheet.RemoveAll();
		return;
	}

	/* 엑셀 사용범위에는 값을 지운 자리가 빈 행으로 남는다 - 그대로 읽으면 '상품정보코드 미입력' 오류로 잡힌다.
	   모든 열이 빈 행은 담지 않는다. 한 칸이라도 값이 있으면 실제 입력으로 보고 검증에 맡긴다. */
	var rows = [];
	for (var r = mdcmFormFirstDataRow(modSheet, MDCM_MOD_DATA_START_ROW); r <= modSheet.LastRow(); r++) {
		var row = {};
		var filled = false;
		for (var c = 0; c < MDCM_MOD_EXCEL_COLS.length; c++) {
			var col = MDCM_MOD_EXCEL_COLS[c];
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

	mdcmUploadRows = rows;
	modSheet.RemoveAll();

	popupSel = "";	// 이 팝업은 setPopupReturn 을 쓰지 않는다
	openSearchPopup("/mdcm/showMasterMdCmCmsItemExcelUploadPop.do", "", "1200,640,no");
}

/* 파일선택 대화상자를 취소하면 OnLoadExcel 이 오지 않는다 — IBSheet 가 부르는 이 훅에서 로딩바를 내린다. */
function modSheet_OnLoadFileCancel() {
	loader_obj("N");
}

function priceSheet_OnLoadFileCancel() {
	loader_obj("N");
}

/* 기준가양식 업로드(LoadExcel) 후처리 — 수정양식과 같은 규약이다.
 * 파일은 창 사이로 넘길 수 없어 파싱은 여기서 하고, 팝업은 opener.mdcmPriceRows 를 읽는다. */
function priceSheet_OnLoadExcel(result) {
	loader_obj("N");
	if (!result) {
		alert("엑셀 로딩 중 오류가 발생하였습니다.");
		return;
	}
	if (priceSheet.RowCount() == 0) {
		alert("업로드할 데이터가 없습니다.");
		return;
	}

	if (!mdcmFormCheck(priceSheet, MDCM_PRICE_DATA_START_ROW, MDCM_PRICE_EXCEL_COLS, MDCM_PRICE_FORM_HEAD, "기준가 일괄수정")) {
		priceSheet.RemoveAll();
		return;
	}

	/* 엑셀 사용범위에는 값을 지운 자리가 빈 행으로 남는다 - 그대로 읽으면 '상품정보코드 미입력' 오류로 잡힌다.
	   모든 열이 빈 행은 담지 않는다. 한 칸이라도 값이 있으면 실제 입력으로 보고 검증에 맡긴다. */
	var rows = [];
	for (var r = mdcmFormFirstDataRow(priceSheet, MDCM_PRICE_DATA_START_ROW); r <= priceSheet.LastRow(); r++) {
		var row = {};
		var filled = false;
		for (var c = 0; c < MDCM_PRICE_EXCEL_COLS.length; c++) {
			var col = MDCM_PRICE_EXCEL_COLS[c];
			var v = priceSheet.GetCellValue(r, col);
			row[col] = v;
			if (!filled && $.trim((v == null) ? "" : ("" + v)) != "") { filled = true; }
		}
		if (filled) { rows.push(row); }
	}

	if (rows.length == 0) {
		alert("업로드할 데이터가 없습니다.");
		priceSheet.RemoveAll();
		return;
	}
	if (rows.length > EXCEL_UP_MAX_ROWS) {
		alert("한 번에 " + kepCommaNum(EXCEL_UP_MAX_ROWS) + "건까지 올릴 수 있습니다.\n\n"
			+ "올린 파일이 " + kepCommaNum(rows.length) + "건입니다. 나눠서 올려 주세요.");
		priceSheet.RemoveAll();
		return;
	}

	mdcmPriceRows = rows;
	priceSheet.RemoveAll();

	popupSel = "";	// 이 팝업은 setPopupReturn 을 쓰지 않는다
	openSearchPopup("/mdcm/showMasterMdCmCmsBasePricePop.do", "", "1200,640,no");
}
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if(current_page == -1){
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
	kepSearch(document.searchCondition ,  mySheet , "/mdam/getMasterMdCmCmsItemList.do?page="+current_page , pagingMode );
}

// 검색조건 팝업 호출
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "categChoice": // 상세분류 복수선택
			gridCategoryRow = 0;
			openSearchPopup("/mdcm/showMasterMdCmCmsItemCategoryMultiSelPop.do", "?st_categ_id_multi=" + $("#st_categ_id_multi").val(), "1000,509,no");
			break;
		case "sgChoice": // 카테고리(=SG) 복수선택
			openSearchPopup("/mdcm/showMasterMdCmCmsItemSgSelPop.do", "?st_sg_id_multi=" + $("#st_sg_id_multi").val(), "950,521,no");
			break;
		case "maker": // 제조사 (유사명 포함 컬럼 5개라 700px에서는 헤더가 줄바꿈된다)
			openSearchPopup("/common/agentRegMakerCodePop.do", "?st_alias_yn=Y", "820,464,no");
			break;
		case "mngrChoice": // 구매담당자
			openSearchPopup("/mdcm/showMasterMdCmCmsItemMngrSelPop.do", "", "640,464,no");
			break;		
		case "catlgMulti": // 상품정보코드
			openSearchPopup("/common/multiSearchCondPop.do", "?header_text=상품정보코드", "300,371,no");
			break;
		case "chemMulti": // 화학물질정보 No.
			openSearchPopup("/common/multiSearchCondPop.do", "?header_text=화학물질정보 No.", "300,371,no");
			break;
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	if(column == "CMS_CATLG_ID"){ // 상품정보 상세
		var st_msds_no = mySheet.GetCellValue(Row,"CMS_CATLG_ID");
		openSearchPopup("/mdcm/showMasterMdCmCmsItemDetailPop.do","?st_msds_no="+st_msds_no, "1300,800,no");
	} else if(column == "CMS_CATEG_NAME"){ // 상세분류 → 카테고리·속성 팝업(지정 분류 사전세팅)
		popupSel = "gridCategory";
		gridCategoryRow = Row;
		var st_pre_categ_id = mySheet.GetCellValue(Row,"CMS_CATEG_ID");
		openSearchPopup("/mdcm/showMasterMdCmCmsItemCategorySelPop.do","?st_pre_categ_id="+st_pre_categ_id, "810,509,no");
	} else if(column == "CHEM_INFO_NO"){ // 화학물질정보 No. → MSDS 상세 조회. AC No. 는 조회 팝업이 없어 무반응
		var msds_no = mySheet.GetCellValue(Row,"MSDS_NO");
		if(kepIsValueNull(msds_no)) return;
		openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+msds_no, "750,580,no");
<%if(st_msds_user_yn.equals("Y")){%>
	} else if(column == "PRINT"){ // MSDS 등록·매핑 - 검색팝업(p_return=CHEMICAL)이 번호만 돌려주고, 저장은 이 화면이 한다
		var msds_no = mySheet.GetCellValue(Row,"MSDS_NO");
		if(!kepIsValueNull(msds_no)){
			if(!confirm("이미 " + msds_no + " 가 매핑되어 있습니다. 다시 매핑하시겠습니까?")) return;
		}
		popupSel = "msdsMapping";
		msdsRow = Row;
		openSearchPopup("/coco/showCommonCoCoMsdsPop.do", "?p_return=CHEMICAL", "950,564,no");
	} else if(column == "ERASE_MSDS_NO"){ // MSDS 매핑해제
		var msds_no = mySheet.GetCellValue(Row,"MSDS_NO");
		if(kepIsValueNull(msds_no)){
			alert("매핑된 MSDS가 없습니다.");
			return;
		}
		if(!confirm("선택한 " + msds_no + " 매핑 해제하시겠습니까?")) return;
		setMsdsChk(Row);
		kepSave(document.searchCondition, mySheet, "/mdcm/saveMasterMdCmCmsItemMsdsClean.do", "MSDS_CHK");
<%}%>
	}
	return;
}

// MSDS 저장 대상 행 지정. 사용자가 체크해 둔 SELECTED 를 건드리지 않도록 전용 컬럼(MSDS_CHK)을 쓴다
function setMsdsChk(Row) {
	var checked = mySheet.FindCheckedRow("MSDS_CHK");
	if (checked != "") {
		var arr = checked.split("|");
		for (var i = 0; i < arr.length; i++) {
			mySheet.SetCellValue(arr[i], "MSDS_CHK", 0);
		}
	}
	mySheet.SetCellValue(Row, "MSDS_CHK", 1);
}

// MSDS 매핑/해제 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if (msg != "") {
		alert(msg);
	}
	if (code > 0) {
		doAction('search');
	}
}

// 팝업 선택 반환 콜백 (popupSel로 분기)
function setPopupReturn(value1, value2, value3, value4, value5, value6){
	if (popupSel == "categChoice") {						// 조회조건 상세분류 복수선택 ("A@B@" 한 덩어리)
		$("#st_categ_id_multi").val(value1);
		$("#st_categ_name_multi").val(value2);				// 원본 명칭 - 팝업 재진입 시 바구니 복원용
		$("#st_category_path").val(kepMultiName(value2, "@"));	// 표시는 "○○ 외 N건"
	} else if (popupSel == "gridCategory") {				// 그리드 상세분류 셀 클릭 (조회 전용, 영속화 없음)
		gridCategoryRow = 0;
	} else if (popupSel == "sgChoice") {					// 카테고리 = SG 복수선택 ("A@B@" 한 덩어리)
		$("#st_sg_id_multi").val(value1);
		$("#st_sg_name").val(kepMultiName(value2, "@"));	// 표시는 "○○ 외 N건"
	} else if (popupSel == "maker") {						// 제조사 (maker_code, maker_name)
		$("#st_maker_code").val(value1);
		$("#st_maker_name").val(value2);
	} else if (popupSel == "mngrChoice") {					// 구매담당자 = 본사 사용자 (USER_ID, 담당자명)
		$("#st_kep_user_no").val(value1);
		$("#st_kep_user_name").val(value2);
	} else if (popupSel == "catlgMulti") {					// 상품정보코드 대량입력 ("A@B@C@" 한 덩어리)
		var codes = kepCleanMultiCode(value1);
		$("#st_cmscatlg_multi").val(codes);
		$("#st_cmscatlg").val(kepMultiName(codes, "@"));	// 표시는 "A 외 N건"
	} else if (popupSel == "chemMulti") {					// 화학물질정보 No. 대량입력
		var chems = kepCleanMultiCode(value1);
		$("#st_chem_no_multi").val(chems);
		$("#st_chem_no").val(kepMultiName(chems, "@"));
	} else if (popupSel == "msdsMapping") {					// MSDS 검색 팝업이 돌려준 MSDS No. (value2 = 유해화학물질 여부)
		// 팝업이 여러 건 체크된 상태로 반환하면 번호가 비어서 온다(팝업쪽 기존 동작)
		if (kepIsValueNull(value1)) {
			alert("MSDS를 1건만 선택해 주세요.");
		} else if (msdsRow > 0) {
			setMsdsChk(msdsRow);
			mySheet.SetCellValue(msdsRow, "MSDS_NO", value1);
			kepSave(document.searchCondition, mySheet, "/mdcm/saveMasterMdCmCmsItemMsdsMapping.do", "MSDS_CHK");
		}
		msdsRow = 0;
	}
	popupSel = "";	// 초기화
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>상품정보 조회 및 관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">

            	<table class="cont_t_list01" style="width:100%">
						<caption>상품정보 조회 및 관리</caption>
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
									<select name = "st_date_type" id="st_date_type" class="TitSelect">
							      		<option value="ADD" selected="selected">등록일</option>
										<option value="CHG" >최종변경일</option>
	                         		</select>
								</th>
								<td colspan="3">
									<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:85px; text-align:center;" value=""> -
									<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:85px; text-align:center;" value="">
									<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>
									<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
									<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox">&nbsp;기간무시
								</td>
								<th>상품정보코드</th>
								<td>
									<input type="text" class="input_type_text" id="st_cmscatlg" name="st_cmscatlg" style="width:60%;" value="" onkeydown="kepEnter()" onKeyUp="ToUpper(this); kepClear('st_cmscatlg_multi');">
									<input type="hidden" name="st_cmscatlg_multi" id="st_cmscatlg_multi" value ="">
			                        <a href="javascript:doPop('catlgMulti');"><img src="/resources/images/btn_search03.gif"></a>
			                        <a href="javascript:kepEraser('st_cmscatlg_multi','st_cmscatlg');"><img src="/resources/images/btn_eraser2.gif"></a>
								</td>
								<th>상품상태</th>
								<td>
									<select name="st_status" id="st_status" style="width:90%;">
										<option value="" selected="selected">전체</option>
										<option value="USE">사용</option>
										<option value="UNUSE">미사용</option>
									</select>
								</td>
								<th>카테고리</th>
								<td>
			                        <input type="text" class="input_type_text" name="st_sg_name" id="st_sg_name" style="width:65%;" value = "" readonly>
			                        <input type="hidden" name="st_sg_id_multi" id="st_sg_id_multi" value ="">
			                        <a href="javascript:doPop('sgChoice');"><img src="/resources/images/btn_search03.gif"></a>
			                        <a href="javascript:kepEraser('st_sg_id_multi','st_sg_name');"><img src="/resources/images/btn_eraser2.gif"></a>
								</td>
							</tr>
							<tr>
								<th>화학물질정보 No.</th>
								<td>
									<input type="text" class="input_type_text" id="st_chem_no" name="st_chem_no" style="width:60%;" value="" onkeydown="kepEnter()" onKeyUp="ToUpper(this); kepClear('st_chem_no_multi');">
									<input type="hidden" name="st_chem_no_multi" id="st_chem_no_multi" value ="">
			                        <a href="javascript:doPop('chemMulti');"><img src="/resources/images/btn_search03.gif"></a>
			                        <a href="javascript:kepEraser('st_chem_no_multi','st_chem_no');"><img src="/resources/images/btn_eraser2.gif"></a>
								</td>
								<th>표준품구분</th>
								<td>
									<select name="st_item_gubun" id="st_item_gubun" style="width:50%;">
										<option value="" selected="selected">전체</option>
										<option value="STD">표준품</option>
										<option value="NSTD">비표준품</option>
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
								<th>상세분류</th>
								<td>
			                        <input type="text" class="input_type_text" name="st_category_path" id="st_category_path" style="width:65%;" value = "" readonly>
			                        <input type="hidden" name="st_categ_id_multi" id="st_categ_id_multi" value ="">
			                        <!-- 팝업 재진입 시 바구니 명칭 복원용(원본 '명칭@명칭@'). 조회에는 쓰지 않는다. -->
			                        <input type="hidden" name="st_categ_name_multi" id="st_categ_name_multi" value ="">
			                        <a href="javascript:doPop('categChoice');"><img src="/resources/images/btn_search03.gif"></a>
			                        <a href="javascript:kepEraser2('st_categ_id_multi','st_categ_name_multi','st_category_path');"><img src="/resources/images/btn_eraser2.gif"></a>
								</td>
							</tr>
							<tr>
								<th>유해화학물질</th>
								<td>
									<select name="st_harmful_yn" id="st_harmful_yn" style="width:50%;">
										<option value="" selected="selected">전체</option>
										<option value="Y">Y</option>
										<option value="N">N</option>
									</select>
								</td>								
								<th>일회성구분</th>
								<td>									
									<select name="st_onetime_yn" id="st_onetime_yn" style="width:50%;">
										<option value="" selected="selected">전체</option>
										<option value="N">일반</option>
										<option value="Y">일회성</option>
									</select>
								</td>
								<th>규격</th>
								<td>
									<input type="text" class="input_type_text" id="st_specification" name="st_specification" style="width:90%;" value="" onkeydown="kepEnter()">
								</td>
								<th>제조사</th>
								<td>
			                        <input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:60%;" value = "" readonly>
			                        <input type="hidden" name="st_maker_code" id="st_maker_code" value ="">
			                        <a href="javascript:doPop('maker');"><img src="/resources/images/btn_search03.gif"></a>
			                        <a href="javascript:kepEraser('st_maker_code','st_maker_name');"><img src="/resources/images/btn_eraser2.gif"></a>
								</td>
								<th>구매담당자</th>
								<td>
									<input type="text" class="input_type_text" id="st_kep_user_name" name="st_kep_user_name" style="width:65%;" value="" onkeydown="kepEnter()" onKeyUp="kepClear('st_kep_user_no');">
									<input type="hidden" name="st_kep_user_no" id="st_kep_user_no" value ="">
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
  					<span class="btn_05 mr04" id="btnExcelDown"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('catelist');">상세분류조회</a></span>
  				</span>  				
  				<span class="fr">
  					<label for="st_form_type" class="hidden">양식 선택</label>
  					<select id="st_form_type" style="width:175px; height:28px; margin-top:5px; margin-right:4px; vertical-align:top;">
  						<option value="MOD" selected="selected">상품정보 일괄수정 양식</option>
  						<option value="PRICE">기준가 일괄수정 양식</option>
  					</select>
  					<span class="btn_05 mr04"><a href="javascript:doAction('formDown');">다운로드</a></span>
  					<span class="btn_05"><a href="javascript:doAction('formUp');">업로드</a></span>
  				</span>
  			 </div>
  			
  			<div style="position:absolute; left:-9999px; top:0; width:1px; height:1px; overflow:hidden;">
  				<script type="text/javascript">
  					createIBSheet("modSheet", "600px", "200px");
  					createIBSheet("priceSheet", "600px", "200px");
  				</script>
  			</div>

  			<!-- 수정양식 다운로드 : 파일 응답이라 숨은 iframe 을 대상으로 submit 한다 -->
  			<form name="modFormDownload" method="post" action="/mdcm/downMasterMdCmCmsItemModForm.do" target="modFormFrame">
  				<input type="hidden" id="modFormCodes" name="codes" value="" />
  				<input type="hidden" id="modFormToken" name="downToken" value="" />
  			</form>
  			<!-- 기준가양식 다운로드 : 수정양식과 같은 iframe·토큰 규약을 쓴다 -->
  			<form name="priceFormDownload" method="post" action="/mdcm/downMasterMdCmCmsBasePriceForm.do" target="modFormFrame">
  				<input type="hidden" id="priceFormCodes" name="codes" value="" />
  				<input type="hidden" id="priceFormToken" name="downToken" value="" />
  			</form>
  			<!-- onload : 서버가 안내(alert)를 돌려준 경우엔 iframe 이 실제로 로드되므로 여기서도 로딩바를 내린다 -->
  			<iframe name="modFormFrame" onload="modFormDownEnd();" style="display:none; width:0; height:0; border:0;"></iframe>

<!--내용 종료-->	                 

</body>
</html>
