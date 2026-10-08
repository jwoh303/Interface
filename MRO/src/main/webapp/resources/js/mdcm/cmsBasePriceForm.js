/**********************************************
 * 표준DB > 기준가 일괄수정 양식 — 그리드 컬럼·엑셀 열 정의 (공용)
 *
 * 두 화면이 같은 정의를 써야 한다 :
 *   - 목록  masterMdCmCmsItemList.jsp     → 양식 다운로드 요청(서버 POI 생성) · 업로드(LoadExcel)
 *   - 팝업  masterMdCmCmsBasePricePop     → 업로드 결과 표시·검증
 * 한쪽에만 컬럼을 추가하면 엑셀 열 번호와 그리드가 조용히 어긋난다.
 * → 정의는 여기 한 곳에만 두고 양쪽이 include 한다. (형제 : cmsItemModForm.js).
 **********************************************/

// 엑셀 양식의 열 순서(13열). 배열 순서 = 엑셀 A~M 열 순서.
// 업로드 ColumnMapping 과 서버 생성 열 순서가 같이 이 배열을 따른다.
// ⚠ 구매정보코드(B)는 참고 열이다 — 기준가는 **상품정보코드 단위**로 반영한다).
var MDCM_PRICE_EXCEL_COLS = [
	 "CMS_CATLG_ID"			//  1 A
	,"BUY_INFO_SEQ"		//  2 B  참고(미반영). 순번만 담는다
	,"DESCRIPTION_LOC"		//  3 C
	,"MODEL_INFO"			//  4 D
	,"SPECIFICATION"		//  5 E
	,"MAKER_NAME"			//  6 F
	,"ORIGIN_NAME"			//  7 G
	,"MEASURE"				//  8 H
	,"PRICE_BEFORE"			//  9 I  기존 기준가
	,"PRICE_TYPE_BEFORE"	// 10 J  기존 기준가유형
	,"PRICE_AFTER"			// 11 K  변경 기준가
	,"PRICE_TYPE_AFTER"		// 12 L  변경 기준가유형
	,"CHG_REASON"			// 13 M  변경사유
];

// 양식 헤더는 4행(안내문/반영표시/그룹명/기존·변경) → 데이터는 5행부터.
// ⚠ 서버 MasterMdCmCmsBasePriceFormExcel.DATA_START_ROW 와 같은 값이어야 한다.
var MDCM_PRICE_DATA_START_ROW = "5";

/* 양식 머리글 [그룹명(3행), 소제목(4행)] - 올린 파일이 이 양식인지 대조한다(excelFormCheck.js).
 * 배열 순서 = MDCM_PRICE_EXCEL_COLS. 병합된 칸은 빈 값으로 두어 대조에서 뺀다.
 * ⚠ 서버 MasterMdCmCmsBasePriceFormExcel.COLS 의 그룹명·소제목과 같아야 한다. */
var MDCM_PRICE_FORM_HEAD = [
	 ["상품정보코드", ""]
	,["구매정보코드", ""]
	,["품목명", ""]
	,["모델번호", ""]
	,["규격", ""]
	,["제조사", ""]
	,["원산지", ""]
	,["단위", ""]
	,["기존", "기준가"], ["", "기준가유형"]
	,["변경", "기준가"], ["", "기준가유형"], ["", "변경사유"]
];

/* 기준가 일괄수정 그리드 컬럼 정의. **호출할 때마다 새 배열**을 만든다 —
 * IBSheet 가 넘겨받은 객체를 손대기 때문에 상수 배열을 두 시트가 나눠 쓰면 두 번째 초기화가 어긋난다. */
function mdcmPriceCols() {
	return [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태|상태",						SaveName:"sStatus"}
		,{ Align:"Center",	Width:40,	Edit:false,	EditLen:10,		Sort:0,			Type:"Seq",		Header:"No|No",							SaveName:"NO"}

		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:25,		Type:"Text",	Header:"상품정보|상품정보코드",			SaveName:"CMS_CATLG_ID"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:5,		Type:"Text",	Header:"상품정보|구매정보코드",			SaveName:"BUY_INFO_SEQ"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:300,		Type:"Text",	Header:"상품정보|품목명",					SaveName:"DESCRIPTION_LOC"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:4000,		Type:"Text",	Header:"상품정보|모델번호",				SaveName:"MODEL_INFO"}
		,{ Align:"Left",	Width:180,	Edit:false,	EditLen:2000,	Type:"Text",	Header:"상품정보|규격",					SaveName:"SPECIFICATION"}
		,{ Align:"Left",	Width:90,	Edit:false,	EditLen:200,		Type:"Text",	Header:"상품정보|제조사",					SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,		Type:"Text",	Header:"상품정보|원산지",					SaveName:"ORIGIN_NAME"}
		,{ Align:"Center",	Width:55,	Edit:false,	EditLen:10,		Type:"Text",	Header:"상품정보|단위",					SaveName:"MEASURE"}

		,{ Align:"Right",	Width:90,	Edit:false,	EditLen:15,		Type:"Text",	Header:"기존|기준가",						SaveName:"PRICE_BEFORE"}
		,{ Align:"Left",	Width:170,	Edit:false,	EditLen:100,		Type:"Text",	Header:"기존|기준가유형",					SaveName:"PRICE_TYPE_BEFORE"}

		,{ Align:"Right",	Width:90,	Edit:false,	EditLen:15,		Type:"Text",	Header:"변경|기준가",						SaveName:"PRICE_AFTER"}
		,{ Align:"Left",	Width:170,	Edit:false,	EditLen:100,		Type:"Text",	Header:"변경|기준가유형",					SaveName:"PRICE_TYPE_AFTER"}
		,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Type:"Text",	Header:"변경|변경사유",					SaveName:"CHG_REASON"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:10,		Type:"Text",	Header:"변경|인상/인하",					SaveName:"UPDOWN"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:10,		Type:"Text",	Header:"변경|변동률",						SaveName:"CHG_RATE"}

		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:10,		Type:"Text",	Header:"결과|결과",						SaveName:"RESULT"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:200,	Type:"Text",	Header:"오류사유|오류사유",				SaveName:"ERR_REASON"}
	];
}

// 컬럼 SaveName 목록 (선언 순서 그대로)
function mdcmPriceColNames() {
	var cols = mdcmPriceCols();
	var arr = [];
	for (var i = 0; i < cols.length; i++) { arr.push(cols[i].SaveName); }
	return arr;
}

/* 업로드용 ColumnMapping : 그리드 컬럼 순서대로 엑셀 열 번호를 지정, 빈칸은 읽지 않는다.
 * ⚠ 헤더가 4행이고 '기준가'가 기존·변경에 중복돼 HeaderMatch 를 쓸 수 없다 → 위치 기반 매핑 */
function mdcmPriceColMapping() {
	var names = mdcmPriceColNames();
	var arr = [];
	for (var i = 0; i < names.length; i++) {
		var idx = -1;
		for (var j = 0; j < MDCM_PRICE_EXCEL_COLS.length; j++) {
			if (MDCM_PRICE_EXCEL_COLS[j] == names[i]) { idx = j; break; }
		}
		arr.push(idx < 0 ? "" : (idx + 1));
	}
	return arr.join("|");
}
