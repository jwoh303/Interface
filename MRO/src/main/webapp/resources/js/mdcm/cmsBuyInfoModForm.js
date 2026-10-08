/**********************************************
 * 표준DB > 구매정보 일괄수정 양식 — 그리드 컬럼·엑셀 열 정의 (공용)
 *
 * 두 화면이 같은 정의를 써야 한다 :
 *   - 목록  masterMdCmCmsBuyInfoList.jsp   → 양식 다운로드 요청(서버 POI 생성) · 업로드(LoadExcel)
 *   - 팝업  masterMdCmCmsBuyInfoModPop     → 업로드 결과 표시·검증
 * 한쪽에만 컬럼을 추가하면 엑셀 열 번호와 그리드가 조용히 어긋난다.
 * → 정의는 여기 한 곳에만 두고 양쪽이 include 한다. (형제 : cmsBuyInfoRegForm.js).
 **********************************************/

// 엑셀 양식의 열 순서(38열). 배열 순서 = 엑셀 A~AL 열 순서.
// ⚠ 서버 MasterMdCmCmsBuyInfoModFormExcel.COLS 와 같은 순서여야 한다.
var MDCM_MODB_EXCEL_COLS = [
	 "CMS_CATLG_ID"			//  1 A
	,"BUY_INFO_SEQ"			//  2 B  순번만 담는다(상품정보코드는 A열)
	,"DESCRIPTION_LOC"		//  3 C
	,"MODEL_INFO"			//  4 D
	,"SPECIFICATION"		//  5 E
	,"MAKER_NAME"			//  6 F
	,"ORIGIN_CODE_NAME"			//  7 G
	,"ORDER_MEASURE"				//  8 H
	,"MIN_ORDER_QTY"		//  9 I
	,"PUR_UNIT_QTY"			// 10 J
	,"PROCESS_TYPE"			// 11 K
	,"DELIVERY_TYPE"		// 12 L
	,"AGENT_NAME"			// 13 M
	,"AGENT"				// 14 N

	,"STATUS_BEFORE"		// 15 O
	,"STATUS_AFTER"			// 16 P
	,"STATUS_REASON"		// 17 Q
	,"ALT_CODE"				// 18 R

	,"BUY_PRICE_BEFORE"			// 19 S
	,"BUY_PRICE_AFTER"			// 20 T
	,"BUY_PRICE_REASON"			// 21 U

	,"BUY_OPEN_DATE_BEFORE"	// 22 V
	,"BUY_CLOSE_DATE_BEFORE"		// 23 W
	,"BUY_OPEN_DATE_AFTER"		// 24 X
	,"BUY_CLOSE_DATE_AFTER"		// 25 Y
	,"BUY_DATE_REASON"			// 26 Z

	,"DELIVERY_LT_BEFORE"			// 27 AA
	,"DELIVERY_LT_AFTER"				// 28 AB
	,"DELIVERY_LT_REASON"			// 29 AC

	,"ITEM_MAKE_TYPE_BEFORE"			// 30 AD
	,"ITEM_MAKE_TYPE_AFTER"			// 31 AE
	,"ITEM_MAKE_TYPE_REASON"			// 32 AF

	,"TAX_TYPE_BEFORE"			// 33 AG
	,"TAX_TYPE_AFTER"			// 34 AH
	,"TAX_TYPE_REASON"			// 35 AI

	,"SELLER_ITEM_NO_BEFORE"		// 36 AJ
	,"SELLER_ITEM_NO_AFTER"			// 37 AK
	,"SELLER_ITEM_NO_REASON"		// 38 AL
];

// 양식 헤더는 4행(안내문/반영표시/그룹명/기존·변경) → 데이터는 5행부터.
// ⚠ 서버 MasterMdCmCmsBuyInfoModFormExcel.DATA_START_ROW 와 같은 값이어야 한다.
var MDCM_MODB_DATA_START_ROW = "5";

/* 양식 머리글 [그룹명(3행), 소제목(4행)] - 올린 파일이 이 양식인지 대조한다(excelFormCheck.js).
 * 배열 순서 = MDCM_MODB_EXCEL_COLS. 병합된 칸은 빈 값으로 두어 대조에서 뺀다.
 * ⚠ 서버 MasterMdCmCmsBuyInfoModFormExcel.COLS 의 그룹명·소제목과 같아야 한다. */
var MDCM_MODB_FORM_HEAD = [
	 ["상품정보코드", ""]
	,["구매정보코드", ""]
	,["품목명", ""]
	,["모델번호", ""]
	,["규격", ""]
	,["제조사", ""]
	,["원산지", ""]
	,["단위", ""]
	,["최소주문수량", ""]
	,["주문배수수량", ""]
	,["거래유형", ""]
	,["배송유형", ""]
	,["협력사명", ""]
	,["협력사코드", ""]
	,["공급상태", "기존"], ["", "변경"], ["", "변경사유"], ["", "대체코드"]
	,["매입단가(VAT별도)", "기존"], ["", "변경"], ["", "변경사유"]
	,["매입단가 유효기간", "기존 시작일"], ["", "기존 종료일"], ["", "변경 시작일"], ["", "변경 종료일"], ["", "변경사유"]
	,["배송일수", "기존"], ["", "변경"], ["", "변경사유"]
	,["품목구분", "기존"], ["", "변경"], ["", "변경사유"]
	,["과세구분", "기존"], ["", "변경"], ["", "변경사유"]
	,["협력사 품목코드", "기존"], ["", "변경"], ["", "변경사유"]
];

/* 변경 세트 7묶음. 한 행에서 '변경 값이 하나라도 있는가'·'동일값인가'를 이 표로 돈다.
 *   after  : 변경 열 · before : 기존 열 · reason : 변경사유 열 · label : 오류항목에 쓸 이름
 *   kind   : num(숫자) · date(YYYYMMDD) · text
 * ⚠ 협력사 품목코드만 규약이 하나 더 있다 — 값 `DELETE` 는 '지운다'는 뜻이다(빈칸으로는 못 지운다). */
var MDCM_MODB_SETS = [
	 {label:"공급상태",          after:"STATUS_AFTER",     before:"STATUS_BEFORE",     reason:"STATUS_REASON", kind:"text"}
	,{label:"매입단가",          after:"BUY_PRICE_AFTER",      before:"BUY_PRICE_BEFORE",      reason:"BUY_PRICE_REASON",  kind:"num"}
	,{label:"유효기간 시작일",   after:"BUY_OPEN_DATE_AFTER", before:"BUY_OPEN_DATE_BEFORE", reason:"BUY_DATE_REASON",  kind:"date"}
	,{label:"유효기간 종료일",   after:"BUY_CLOSE_DATE_AFTER",   before:"BUY_CLOSE_DATE_BEFORE",   reason:"BUY_DATE_REASON",  kind:"date"}
	,{label:"배송일수",          after:"DELIVERY_LT_AFTER",         before:"DELIVERY_LT_BEFORE",         reason:"DELIVERY_LT_REASON",     kind:"num"}
	,{label:"품목구분",          after:"ITEM_MAKE_TYPE_AFTER",       before:"ITEM_MAKE_TYPE_BEFORE",       reason:"ITEM_MAKE_TYPE_REASON",   kind:"text"}
	,{label:"과세구분",          after:"TAX_TYPE_AFTER",        before:"TAX_TYPE_BEFORE",        reason:"TAX_TYPE_REASON",    kind:"text"}
	,{label:"협력사 품목코드",   after:"SELLER_ITEM_NO_AFTER",     before:"SELLER_ITEM_NO_BEFORE",     reason:"SELLER_ITEM_NO_REASON", kind:"text"}
];

// 협력사 품목코드를 지우는 규약. 양식에만 있는 장치다(3열 세트 구조로는 빈 값과 미변경을 구분할 수 없다).
var MDCM_MODB_DELETE_MARK = "DELETE";

// 대체코드를 요구하는 공급상태 변경사유. 서버가 목록을 내려주지만, 못 받았을 때의 최후 기준이다.
var MDCM_MODB_ALT_REASON = "중복존재";

/* 구매정보 일괄수정 결과 그리드 컬럼 정의. **호출할 때마다 새 배열**을 만든다 —
 * IBSheet 가 넘겨받은 객체를 손대기 때문에 상수 배열을 두 시트가 나눠 쓰면 두 번째 초기화가 어긋난다. */
function mdcmModbCols() {
	return [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태|상태",					SaveName:"sStatus"}
		,{ Align:"Center",	Width:40,	Edit:false,	EditLen:10,		Sort:0,			Type:"Seq",		Header:"No|No",						SaveName:"NO"}

		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,		Type:"Text",	Header:"상품정보|상품정보코드",		SaveName:"CMS_CATLG_ID"}
		,{ Align:"Center",	Width:115,	Edit:false,	EditLen:25,		Hidden:true,	Type:"Text",	Header:"구매정보코드(키)",	SaveName:"BUY_INFO_ID"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:5,		Type:"Text",	Header:"상품정보|구매정보코드",		SaveName:"BUY_INFO_SEQ"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:300,	Type:"Text",	Header:"상품정보|품목명",			SaveName:"DESCRIPTION_LOC"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:4000,	Type:"Text",	Header:"상품정보|모델번호",			SaveName:"MODEL_INFO"}
		,{ Align:"Left",	Width:150,	Edit:false,	EditLen:2000,	Type:"Text",	Header:"상품정보|규격",				SaveName:"SPECIFICATION"}
		,{ Align:"Left",	Width:90,	Edit:false,	EditLen:200,	Type:"Text",	Header:"상품정보|제조사",			SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:55,	Edit:false,	EditLen:10,		Type:"Text",	Header:"상품정보|단위",				SaveName:"ORDER_MEASURE"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:200,	Type:"Text",	Header:"상품정보|협력사명",			SaveName:"AGENT_NAME"}

		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:10,		Type:"Text",	Header:"변경|공급상태",				SaveName:"STATUS_AFTER"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:100,	Type:"Text",	Header:"변경|변경사유",				SaveName:"STATUS_REASON"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,		Type:"Text",	Header:"변경|대체코드",				SaveName:"ALT_CODE"}
		,{ Align:"Right",	Width:90,	Edit:false,	EditLen:20,		Type:"Text",	Header:"변경|매입단가",				SaveName:"BUY_PRICE_AFTER"}
		,{ Align:"Center",	Width:65,	Edit:false,	EditLen:10,		Type:"Text",	Header:"변경|인상/인하",			SaveName:"UPDOWN"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:10,		Type:"Text",	Header:"변경|변동율",				SaveName:"CHG_RATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:8,		Type:"Text",	Header:"변경|유효기간 시작일",		SaveName:"BUY_OPEN_DATE_AFTER"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:8,		Type:"Text",	Header:"변경|유효기간 종료일",		SaveName:"BUY_CLOSE_DATE_AFTER"}
		,{ Align:"Center",	Width:65,	Edit:false,	EditLen:10,		Type:"Text",	Header:"변경|배송일수",				SaveName:"DELIVERY_LT_AFTER"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:40,		Type:"Text",	Header:"변경|품목구분",				SaveName:"ITEM_MAKE_TYPE_AFTER"}
		,{ Align:"Center",	Width:65,	Edit:false,	EditLen:10,		Type:"Text",	Header:"변경|과세구분",				SaveName:"TAX_TYPE_AFTER"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:200,	Type:"Text",	Header:"변경|협력사 품목코드",		SaveName:"SELLER_ITEM_NO_AFTER"}

		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:10,		Type:"Text",	Header:"결과|결과",					SaveName:"RESULT"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:200,	Type:"Text",	Header:"결과|오류항목",				SaveName:"ERR_COL"}
		,{ Align:"Left",	Width:210,	Edit:false,	EditLen:200,	Type:"Text",	Header:"결과|오류사유",				SaveName:"ERR_REASON"}

		/* 기존값은 화면에 열로 두지 않는다(38열을 다 깔면 못 읽는다) — 동일값 판정에만 쓰므로 숨겨서 들고 있는다. */
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:10,		Hidden:true,	Type:"Text",	Header:"기존|공급상태",			SaveName:"STATUS_BEFORE"}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:20,		Hidden:true,	Type:"Text",	Header:"기존|매입단가",			SaveName:"BUY_PRICE_BEFORE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:8,		Hidden:true,	Type:"Text",	Header:"기존|시작일",				SaveName:"BUY_OPEN_DATE_BEFORE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:8,		Hidden:true,	Type:"Text",	Header:"기존|종료일",				SaveName:"BUY_CLOSE_DATE_BEFORE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:10,		Hidden:true,	Type:"Text",	Header:"기존|배송일수",			SaveName:"DELIVERY_LT_BEFORE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:40,		Hidden:true,	Type:"Text",	Header:"기존|품목구분",			SaveName:"ITEM_MAKE_TYPE_BEFORE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:10,		Hidden:true,	Type:"Text",	Header:"기존|과세구분",			SaveName:"TAX_TYPE_BEFORE"}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",	Header:"기존|협력사품목코드",		SaveName:"SELLER_ITEM_NO_BEFORE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:20,		Hidden:true,	Type:"Text",	Header:"기존|협력사코드",			SaveName:"AGENT"}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",	Header:"변경|매입단가사유",		SaveName:"BUY_PRICE_REASON"}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",	Header:"변경|유효기간사유",		SaveName:"BUY_DATE_REASON"}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",	Header:"변경|배송일수사유",		SaveName:"DELIVERY_LT_REASON"}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",	Header:"변경|품목구분사유",		SaveName:"ITEM_MAKE_TYPE_REASON"}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",	Header:"변경|과세구분사유",		SaveName:"TAX_TYPE_REASON"}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",	Header:"변경|품목코드사유",		SaveName:"SELLER_ITEM_NO_REASON"}
	];
}

// 컬럼 SaveName 목록 (선언 순서 그대로)
function mdcmModbColNames() {
	var cols = mdcmModbCols();
	var arr = [];
	for (var i = 0; i < cols.length; i++) { arr.push(cols[i].SaveName); }
	return arr;
}

/* 업로드용 ColumnMapping : 그리드 컬럼 순서대로 엑셀 열 번호를 지정, 빈칸은 읽지 않는다.
 * ⚠ 헤더가 4행이고 '기존/변경/변경사유'가 묶음마다 되풀이돼 HeaderMatch 를 쓸 수 없다 → 위치 기반 매핑 */
function mdcmModbColMapping() {
	var names = mdcmModbColNames();
	var arr = [];
	for (var i = 0; i < names.length; i++) {
		var idx = -1;
		for (var j = 0; j < MDCM_MODB_EXCEL_COLS.length; j++) {
			if (MDCM_MODB_EXCEL_COLS[j] == names[i]) { idx = j; break; }
		}
		arr.push(idx < 0 ? "" : (idx + 1));
	}
	return arr.join("|");
}
