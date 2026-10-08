/**********************************************
 * 표준DB > 구매정보 일괄등록 양식 — 그리드 컬럼·엑셀 열 정의 (공용)
 *
 * 두 화면이 같은 정의를 써야 한다 :
 *   - 목록  masterMdCmCmsBuyInfoList.jsp   → 양식 다운로드 요청(서버 POI 생성) · 업로드(LoadExcel)
 *   - 팝업  masterMdCmCmsBuyInfoRegPop     → 업로드 결과 표시·검증
 * 한쪽에만 컬럼을 추가하면 엑셀 열 번호와 그리드가 조용히 어긋난다.
 * → 정의는 여기 한 곳에만 두고 양쪽이 include 한다. (형제 : cmsItemModForm.js · cmsBasePriceForm.js).
 **********************************************/

// 엑셀 양식의 열 순서(14열). 배열 순서 = 엑셀 A~N 열 순서.
// ⚠ 서버 MasterMdCmCmsBuyInfoRegFormExcel.COLS 와 같은 순서여야 한다.
var MDCM_REG_EXCEL_COLS = [
	 "CMS_CATLG_ID"		//  1 A
	,"AGENT"			//  2 B
	,"BUY_PRICE"		//  3 C
	,"MIN_ORDER_QTY"	//  4 D
	,"PUR_UNIT_QTY"		//  5 E
	,"PROCESS_TYPE"		//  6 F
	,"DELIVERY_TYPE"	//  7 G
	,"WAREHOUSE_CODE"	//  8 H
	,"DELIVERY_LT"		//  9 I
	,"ITEM_MAKE_TYPE"	// 10 J
	,"TAX_TYPE"			// 11 K
	,"SELLER_ITEM_NO"	// 12 L
	,"BUY_OPEN_DATE"	// 13 M
	,"BUY_CLOSE_DATE"	// 14 N
];

// 양식 헤더는 3행(안내문/항목명/소제목) → 데이터는 4행부터.
// ⚠ 서버 MasterMdCmCmsBuyInfoRegFormExcel.DATA_START_ROW 와 같은 값이어야 한다.
var MDCM_REG_DATA_START_ROW = "4";

/* 양식 머리글 [항목명(2행), 소제목(3행)] - 올린 파일이 이 양식인지 대조한다(excelFormCheck.js).
 * 배열 순서 = MDCM_REG_EXCEL_COLS. 병합된 칸은 빈 값으로 두어 대조에서 뺀다.
 * ⚠ 서버 MasterMdCmCmsBuyInfoRegFormExcel.COLS 의 항목명·소제목과 같아야 한다. */
var MDCM_REG_FORM_HEAD = [
	 ["상품정보코드", ""]
	,["협력사코드", ""]
	,["매입단가 (VAT별도)", ""]
	,["최소주문수량", ""]
	,["주문배수수량", ""]
	,["거래유형", ""]
	,["배송유형", ""]
	,["입고TR", ""]
	,["배송일수", ""]
	,["품목구분", ""]
	,["과세구분", ""]
	,["협력사 품목코드", ""]
	,["매입단가 유효기간", "시작일"], ["", "종료일"]
];

// 중복 판정 키 — 상품정보코드 + 협력사코드 + 거래유형 + 최소주문수량 + 주문배수수량
var MDCM_REG_DUP_KEY_COLS = ["CMS_CATLG_ID", "AGENT", "PROCESS_TYPE", "MIN_ORDER_QTY", "PUR_UNIT_QTY"];

// 값이 없으면 구매정보를 만들 수 없는 열. 하나라도 비면 '필수값 누락'.
var MDCM_REG_REQUIRED_COLS = [
	 {name:"CMS_CATLG_ID",  label:"상품정보코드"}
	,{name:"AGENT",         label:"협력사코드"}
	,{name:"BUY_PRICE",     label:"매입단가"}
	,{name:"MIN_ORDER_QTY", label:"최소주문수량"}
	,{name:"PUR_UNIT_QTY",  label:"주문배수수량"}
	,{name:"PROCESS_TYPE",  label:"거래유형"}
	,{name:"BUY_OPEN_DATE", label:"유효기간 시작일"}
	,{name:"BUY_CLOSE_DATE",label:"유효기간 종료일"}
];

// 배송유형 : 양식은 명칭, 저장은 코드(ICOMCOD1 M186)
var MDCM_REG_DELIVERY_TYPE = {"택배":"PCL", "자차":"CAR"};

/* 구매정보 일괄등록 결과 그리드 컬럼 정의. **호출할 때마다 새 배열**을 만든다 —
 * IBSheet 가 넘겨받은 객체를 손대기 때문에 상수 배열을 두 시트가 나눠 쓰면 두 번째 초기화가 어긋난다. */
function mdcmRegCols() {
	return [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태|상태",					SaveName:"sStatus"}
		,{ Align:"Center",	Width:40,	Edit:false,	EditLen:10,		Sort:0,			Type:"Seq",		Header:"No|No",						SaveName:"NO"}

		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:25,		Type:"Text",	Header:"상품정보|상품정보코드",		SaveName:"CMS_CATLG_ID"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:300,	Type:"Text",	Header:"상품정보|품목명",			SaveName:"DESCRIPTION_LOC"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:4000,	Type:"Text",	Header:"상품정보|모델번호",			SaveName:"MODEL_INFO"}
		,{ Align:"Left",	Width:150,	Edit:false,	EditLen:2000,	Type:"Text",	Header:"상품정보|규격",				SaveName:"SPECIFICATION"}
		,{ Align:"Left",	Width:90,	Edit:false,	EditLen:200,	Type:"Text",	Header:"상품정보|제조사",			SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:55,	Edit:false,	EditLen:10,		Type:"Text",	Header:"상품정보|단위",				SaveName:"MEASURE"}

		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:20,		Type:"Text",	Header:"협력사|협력사코드",			SaveName:"AGENT"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:200,	Type:"Text",	Header:"협력사|협력사명",			SaveName:"AGENT_NAME"}

		,{ Align:"Right",	Width:90,	Edit:false,	EditLen:20,		Type:"Text",	Header:"입력값|매입단가",			SaveName:"BUY_PRICE"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:20,		Type:"Text",	Header:"입력값|최소주문수량",		SaveName:"MIN_ORDER_QTY"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:20,		Type:"Text",	Header:"입력값|주문배수수량",		SaveName:"PUR_UNIT_QTY"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:10,		Type:"Text",	Header:"입력값|거래유형",			SaveName:"PROCESS_TYPE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:10,		Type:"Text",	Header:"입력값|배송유형",			SaveName:"DELIVERY_TYPE"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:20,		Type:"Text",	Header:"입력값|입고TR",				SaveName:"WAREHOUSE_CODE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:10,		Type:"Text",	Header:"입력값|배송일수",			SaveName:"DELIVERY_LT"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:40,		Type:"Text",	Header:"입력값|품목구분",			SaveName:"ITEM_MAKE_TYPE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:4,		Type:"Text",	Header:"입력값|과세구분",			SaveName:"TAX_TYPE"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:200,	Type:"Text",	Header:"입력값|협력사 품목코드",	SaveName:"SELLER_ITEM_NO"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:8,		Type:"Text",	Header:"입력값|유효기간 시작일",	SaveName:"BUY_OPEN_DATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:8,		Type:"Text",	Header:"입력값|유효기간 종료일",	SaveName:"BUY_CLOSE_DATE"}

		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:10,		Type:"Text",	Header:"결과|결과",					SaveName:"RESULT"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:200,	Type:"Text",	Header:"결과|오류항목",				SaveName:"ERR_COL"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:200,	Type:"Text",	Header:"결과|오류사유",				SaveName:"ERR_REASON"}
	];
}

// 컬럼 SaveName 목록 (선언 순서 그대로)
function mdcmRegColNames() {
	var cols = mdcmRegCols();
	var arr = [];
	for (var i = 0; i < cols.length; i++) { arr.push(cols[i].SaveName); }
	return arr;
}

/* 업로드용 ColumnMapping : 그리드 컬럼 순서대로 엑셀 열 번호를 지정, 빈칸은 읽지 않는다.
 * ⚠ 헤더가 3행이고 '매입단가 유효기간'이 두 열에 걸쳐 병합돼 HeaderMatch 를 쓸 수 없다 → 위치 기반 매핑 */
function mdcmRegColMapping() {
	var names = mdcmRegColNames();
	var arr = [];
	for (var i = 0; i < names.length; i++) {
		var idx = -1;
		for (var j = 0; j < MDCM_REG_EXCEL_COLS.length; j++) {
			if (MDCM_REG_EXCEL_COLS[j] == names[i]) { idx = j; break; }
		}
		arr.push(idx < 0 ? "" : (idx + 1));
	}
	return arr.join("|");
}

/* 중복 판정 키 한 줄. 수량은 숫자로 정규화한다 —
 * 엑셀은 "10", DB 는 "10.000" 으로 오기 때문에 문자열 그대로 비교하면 중복을 놓친다. */
function mdcmRegDupKey(getter) {
	var parts = [];
	for (var i = 0; i < MDCM_REG_DUP_KEY_COLS.length; i++) {
		var col = MDCM_REG_DUP_KEY_COLS[i];
		var v = ("" + (getter(col) == null ? "" : getter(col))).replace(/^\s+|\s+$/g, "");
		if (col == "MIN_ORDER_QTY" || col == "PUR_UNIT_QTY") {
			var n = kepParseNum(v);
			v = isNaN(n) ? v : ("" + n);
		}
		parts.push(v.toUpperCase());
	}
	return parts.join("");
}
