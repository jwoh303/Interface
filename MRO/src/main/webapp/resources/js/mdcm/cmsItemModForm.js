/**********************************************
 * 표준DB > 상품정보 일괄수정 양식 — 그리드 컬럼·엑셀 열 정의 (공용)
 *
 * 두 화면이 같은 정의를 써야 한다 :
 *   - 목록  masterMdCmCmsItemList.jsp        → 양식 다운로드 요청(서버 POI 생성) · 업로드(LoadExcel)
 *   - 팝업  masterMdCmCmsItemExcelUploadPop  → 업로드 결과 표시·검증
 * 한쪽에만 컬럼을 추가하면 엑셀 열 번호와 그리드가 조용히 어긋난다.
 * → 정의는 여기 한 곳에만 두고 양쪽이 include 한다.
 **********************************************/

// 엑셀 양식의 열 순서(58열). **여기 있는 컬럼만 엑셀에 존재**하고 나머지 그리드 컬럼은 표시·검증용이다.
// 배열 순서 = 엑셀 A~BF 열 순서. 업로드 ColumnMapping 과 서버 생성 열 순서가 같이 이 배열을 따른다.
// ⚠ 제조사·원산지는 [변경]"명"이 아니라 [변경]"코드"가 반영 축이다(양식 2행 '▼미반영').
// ⚠ 규격은 [변경] 열이 없다 — 속성값을 고치면 규격이 재조립된다(mdcmBuildSpec).
var MDCM_MOD_EXCEL_COLS = [
	 "CMS_CATLG_ID"																	//  1 A
	,"STATUS_BEFORE",      "STATUS_AFTER",       "CHG_REASON",     "ALT_CODE"		//  2~5  B~E
	,"DESCRIPTION_BEFORE", "DESCRIPTION_AFTER",  "DESCRIPTION_REASON"				//  6~8  F~H
	,"MODEL_BEFORE",       "MODEL_AFTER",        "MODEL_REASON"						//  9~11 I~K
	,"MAKER_BEFORE",       "MAKER_CODE_BEFORE"										// 12~13 L~M
	,"MAKER_CODE_AFTER",   "MAKER_REASON"											// 15~16 O~P
	,"ORIGIN_BEFORE",      "ORIGIN_CODE_BEFORE"									// 15~16 O~P
	,"ORIGIN_CODE_AFTER",  "ORIGIN_REASON"											// 20~21 T~U
	,"MEASURE_BEFORE",     "MEASURE_AFTER",      "MEASURE_REASON"					// 22~24 V~X
	,"ITEM_GUBUN_BEFORE",  "ITEM_GUBUN_AFTER",   "ITEM_GUBUN_REASON"				// 25~27 Y~AA
	,"TR_BEFORE",          "TR_AFTER",           "TR_REASON"						// 28~30 AB~AD
	,"SPEC_BEFORE",        "SPEC_REASON"											// 31~32 AE~AF
	// 33~58 AG~BF : 속성1~13 × (속성명, 값)
	,"ATTR1_NM","ATTR1_VAL",   "ATTR2_NM","ATTR2_VAL",   "ATTR3_NM","ATTR3_VAL"
	,"ATTR4_NM","ATTR4_VAL",   "ATTR5_NM","ATTR5_VAL",   "ATTR6_NM","ATTR6_VAL"
	,"ATTR7_NM","ATTR7_VAL",   "ATTR8_NM","ATTR8_VAL",   "ATTR9_NM","ATTR9_VAL"
	,"ATTR10_NM","ATTR10_VAL", "ATTR11_NM","ATTR11_VAL", "ATTR12_NM","ATTR12_VAL"
	,"ATTR13_NM","ATTR13_VAL"
];

// 양식 헤더는 4행(안내문/반영표시/그룹명/기존·변경·변경사유) → 데이터는 5행부터.
// ⚠ 서버가 거는 D열 종속 드롭다운 수식 INDIRECT(C5) 의 5 와 한 몸이다.
//   시작행을 바꾸면 MasterMdCmCmsItemModFormExcel.DATA_START_ROW 도 같이 바꿔야 한다.
var MDCM_MOD_DATA_START_ROW = "5";

/* 양식 머리글 [그룹명(3행), 소제목(4행)] - 올린 파일이 이 양식인지 대조한다(excelFormCheck.js).
 * 배열 순서 = MDCM_MOD_EXCEL_COLS. 병합된 칸은 빈 값으로 두어 대조에서 뺀다.
 * ⚠ 서버 MasterMdCmCmsItemModFormExcel.COLS 의 그룹명·소제목과 같아야 한다. */
var MDCM_MOD_FORM_HEAD = [
	 ["상품정보코드", ""]
	,["상품상태", "기존"], ["", "변경"], ["", "변경사유"], ["", "대체코드"]
	,["품목명", "기존"], ["", "변경"], ["", "변경사유"]
	,["모델번호", "기존"], ["", "변경"], ["", "변경사유"]
	,["제조사", "기존"], ["", "기존코드"], ["", "변경코드"], ["", "변경사유"]
	,["원산지", "기존"], ["", "기존코드"], ["", "변경코드"], ["", "변경사유"]
	,["단위", "기존"], ["", "변경"], ["", "변경사유"]
	,["상품구분", "기존"], ["", "변경"], ["", "변경사유"]
	,["TR취급가능여부", "기존"], ["", "변경"], ["", "변경사유"]
	,["규격", "기존"], ["", "변경사유"]
];

// 속성 열은 그룹 "속성N" · 소제목 "속성명"/"값" 으로 이어진다.
function mdcmModFormHead() {
	var head = MDCM_MOD_FORM_HEAD.slice(0);
	for (var i = 1; i <= MDCM_MOD_ATTR_COUNT; i++) {
		head.push(["속성" + i, "속성명"]);
		head.push(["", "값"]);
	}
	return head;
}

// 양식이 담는 속성 쌍 개수(양식 13칸). DB(CMSCATTR)는 20개까지라 14번째부터는 양식에 실리지 않는다.
var MDCM_MOD_ATTR_COUNT = 13;

/* 일괄수정 대상 항목 : [변경 후 컬럼, 오류항목 표기명, 함께 접을 컬럼군, 동일값 비교 기준(기존) 컬럼].
 * 변경 후 컬럼 -'변경' 열이 전부 비면 변경 값 미존재로 본다.
 * 동일값 비교 기준(기존)컬럼 - 은 반드시 명시한다 — 제조사·원산지는 반영 축이 "코드"라 비교 대상도 코드 열이다.
 */
var MDCM_MOD_TARGETS = [
	 ["STATUS_AFTER",		"상품상태",			["STATUS_BEFORE","STATUS_AFTER","CHG_REASON","ALT_CODE"],					"STATUS_BEFORE"]
	,["DESCRIPTION_AFTER",	"품목명",			["DESCRIPTION_BEFORE","DESCRIPTION_AFTER","DESCRIPTION_REASON"],			"DESCRIPTION_BEFORE"]
	,["MODEL_AFTER",		"모델번호",			["MODEL_BEFORE","MODEL_AFTER","MODEL_REASON"],								"MODEL_BEFORE"]
	,["MAKER_CODE_AFTER",	"제조사",			["MAKER_BEFORE","MAKER_CODE_BEFORE","MAKER_AFTER","MAKER_CODE_AFTER","MAKER_REASON"],		"MAKER_CODE_BEFORE"]
	,["ORIGIN_CODE_AFTER",	"원산지",			["ORIGIN_BEFORE","ORIGIN_CODE_BEFORE","ORIGIN_AFTER","ORIGIN_CODE_AFTER","ORIGIN_REASON"],	"ORIGIN_CODE_BEFORE"]
	,["MEASURE_AFTER",		"단위",				["MEASURE_BEFORE","MEASURE_AFTER","MEASURE_REASON"],						"MEASURE_BEFORE"]
	,["ITEM_GUBUN_AFTER",	"상품구분",			["ITEM_GUBUN_BEFORE","ITEM_GUBUN_AFTER","ITEM_GUBUN_REASON"],				"ITEM_GUBUN_BEFORE"]
	,["TR_AFTER",			"TR취급가능여부",		["TR_BEFORE","TR_AFTER","TR_REASON"],										"TR_BEFORE"]
	,["SPEC_AFTER",			"규격",				["SPEC_BEFORE","SPEC_AFTER","SPEC_REASON"],									"SPEC_BEFORE"]
];

/* 규격 = 속성값 조합. 비어있지 않은 값만 순서대로 "; " 로 잇고 맨 뒤에 ";" 를 붙인다.
 * 예) ["", "40x50x8T", "VITON", "TC"] → "40x50x8T; VITON; TC;"
*/
function mdcmBuildSpec(values) {
	var parts = [];
	for (var i = 0; i < values.length; i++) {
		var v = (values[i] == null) ? "" : ("" + values[i]).replace(/^\s+|\s+$/g, "");
		if (v.length > 0) { parts.push(v); }
	}
	if (parts.length == 0) { return ""; }
	return parts.join("; ") + ";";
}

/* 규격 비교용 정규화 — 끝의 ';' 와 앞뒤 공백을 떼고, 구분자 주변 공백을 한 칸으로 맞춘다.
 * [기존] 규격(DB 실값)은 끝에 ';' 가 없어서, 이걸 거치지 않으면 안 바뀐 규격도 항상 달라 보인다. */
function mdcmNormSpec(v) {
	if (v == null) { return ""; }
	return ("" + v).replace(/\s*;\s*/g, "; ").replace(/^\s+/, "").replace(/[\s;]+$/, "");
}

/* 일괄수정 그리드 컬럼 정의. **호출할 때마다 새 배열**을 만든다 — IBSheet 가 넘겨받은 객체를 손대기 때문에
 * 상수 배열을 두 시트가 나눠 쓰면 두 번째 초기화가 어긋난다. */
function mdcmModCols() {
	var cols = [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태|상태",					SaveName:"sStatus"}
		,{ Align:"Center",	Width:40,	Edit:false,	EditLen:10,		Sort:0,			Type:"Seq",		Header:"No|No",						SaveName:"NO"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:25,		Type:"Text",	Header:"상품정보코드|상품정보코드",	SaveName:"CMS_CATLG_ID"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:300,		Type:"Text",	Header:"품목명|품목명",				SaveName:"DESCRIPTION_LOC"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:4000,		Type:"Text",	Header:"모델번호|모델번호",			SaveName:"MODEL_INFO"}
		,{ Align:"Left",	Width:140,	Edit:false,	EditLen:2000,	Type:"Text",	Header:"규격|규격",					SaveName:"SPECIFICATION"}
		,{ Align:"Left",	Width:90,	Edit:false,	EditLen:200,		Type:"Text",	Header:"제조사|제조사",				SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Type:"Text",	Header:"원산지|원산지",				SaveName:"ORIGIN_CODE_NAME"}
		,{ Align:"Center",	Width:55,	Edit:false,	EditLen:10,		Type:"Text",	Header:"단위|단위",					SaveName:"ORDER_MEASURE"}

		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:20,		Type:"Text",	Header:"상품상태|기존",				SaveName:"STATUS_BEFORE"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:20,		Type:"Text",	Header:"상품상태|변경",				SaveName:"STATUS_AFTER"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,		Type:"Text",	Header:"상품상태|변경사유",			SaveName:"CHG_REASON"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,		Type:"Text",	Header:"상품상태|대체코드",			SaveName:"ALT_CODE"}

		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:300,		Type:"Text",	Header:"품목명|기존",					SaveName:"DESCRIPTION_BEFORE"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:300,		Type:"Text",	Header:"품목명|변경",					SaveName:"DESCRIPTION_AFTER"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:200,	Type:"Text",	Header:"품목명|변경사유",				SaveName:"DESCRIPTION_REASON"}

		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:4000,		Type:"Text",	Header:"모델번호|기존",				SaveName:"MODEL_BEFORE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:4000,		Type:"Text",	Header:"모델번호|변경",				SaveName:"MODEL_AFTER"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:200,	Type:"Text",	Header:"모델번호|변경사유",			SaveName:"MODEL_REASON"}

		,{ Align:"Left",	Width:90,	Edit:false,	EditLen:200,		Type:"Text",	Header:"제조사|기존",					SaveName:"MAKER_BEFORE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:20,		Type:"Text",	Header:"제조사|기존코드",				SaveName:"MAKER_CODE_BEFORE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:20,		Type:"Text",	Header:"제조사|변경코드",				SaveName:"MAKER_CODE_AFTER"}
		,{ Align:"Left",	Width:90,	Edit:false,	EditLen:200,	Type:"Text",	Header:"제조사|변경",					SaveName:"MAKER_AFTER"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:200,	Type:"Text",	Header:"제조사|변경사유",				SaveName:"MAKER_REASON"}

		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,		Type:"Text",	Header:"원산지|기존",					SaveName:"ORIGIN_BEFORE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:10,		Type:"Text",	Header:"원산지|기존코드",				SaveName:"ORIGIN_CODE_BEFORE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:10,		Type:"Text",	Header:"원산지|변경코드",				SaveName:"ORIGIN_CODE_AFTER"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:200,	Type:"Text",	Header:"원산지|변경사유",				SaveName:"ORIGIN_REASON"}

		,{ Align:"Center",	Width:55,	Edit:false,	EditLen:10,		Type:"Text",	Header:"단위|기존",					SaveName:"MEASURE_BEFORE"}
		,{ Align:"Center",	Width:55,	Edit:false,	EditLen:10,		Type:"Text",	Header:"단위|변경",					SaveName:"MEASURE_AFTER"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:200,	Type:"Text",	Header:"단위|변경사유",				SaveName:"MEASURE_REASON"}

		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:20,		Type:"Text",	Header:"상품구분|기존",				SaveName:"ITEM_GUBUN_BEFORE"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:20,		Type:"Text",	Header:"상품구분|변경",				SaveName:"ITEM_GUBUN_AFTER"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:200,	Type:"Text",	Header:"상품구분|변경사유",			SaveName:"ITEM_GUBUN_REASON"}

		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,		Type:"Text",	Header:"TR취급가능여부|기존",			SaveName:"TR_BEFORE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,		Type:"Text",	Header:"TR취급가능여부|변경",			SaveName:"TR_AFTER"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:200,	Type:"Text",	Header:"TR취급가능여부|변경사유",		SaveName:"TR_REASON"}

		,{ Align:"Left",	Width:160,	Edit:false,	EditLen:2000,	Type:"Text",	Header:"규격|기존",					SaveName:"SPEC_BEFORE"}
		,{ Align:"Left",	Width:160,	Edit:false,	EditLen:2000,	Type:"Text",	Header:"규격|변경(속성 조합)",		SaveName:"SPEC_AFTER"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:200,	Type:"Text",	Header:"규격|변경사유",				SaveName:"SPEC_REASON"}
	];

	// 속성 13쌍(속성명·값) + 서버가 채우는 [기존] 속성값(숨김, 규격 변경 여부 판정용)
	for (var i = 1; i <= MDCM_MOD_ATTR_COUNT; i++) {
		cols.push({ Align:"Left",	Width:90,	Edit:false,	EditLen:200,	Type:"Text",	Header:"속성" + i + "|속성명",	SaveName:"ATTR" + i + "_NM"});
		cols.push({ Align:"Left",	Width:90,	Edit:false,	EditLen:600,	Type:"Text",	Header:"속성" + i + "|값",		SaveName:"ATTR" + i + "_VAL"});
		cols.push({ Align:"Left",	Width:90,	Edit:false,	EditLen:600,	Hidden:true,	Type:"Text",	Header:"속성" + i + "|기존값",	SaveName:"ATTR" + i + "_BVAL"});
	}

	cols.push({ Align:"Center",	Width:70,	Edit:false,	EditLen:10,		Type:"Text",	Header:"결과|결과",		SaveName:"RESULT"});
	cols.push({ Align:"Center",	Width:100,	Edit:false,	EditLen:50,		Type:"Text",	Header:"오류항목|오류항목",	SaveName:"ERR_COL"});
	cols.push({ Align:"Left",	Width:180,	Edit:false,	EditLen:200,	Type:"Text",	Header:"오류사유|오류사유",	SaveName:"ERR_REASON"});

	return cols;
}

// 컬럼 SaveName 목록 (선언 순서 그대로)
function mdcmModColNames() {
	var cols = mdcmModCols();
	var arr = [];
	for (var i = 0; i < cols.length; i++) { arr.push(cols[i].SaveName); }
	return arr;
}

/* 업로드용 ColumnMapping : 그리드 컬럼(숨김 포함) 순서대로 엑셀 열 번호를 지정, 빈칸은 읽지 않는다.
 * ⚠ 헤더가 4행이고 '기존/변경/변경사유' 가 반복돼 HeaderMatch 를 쓸 수 없다 → 위치 기반 매핑. */
function mdcmModColMapping() {
	var names = mdcmModColNames();
	var arr = [];
	for (var i = 0; i < names.length; i++) {
		var idx = -1;
		for (var j = 0; j < MDCM_MOD_EXCEL_COLS.length; j++) {
			if (MDCM_MOD_EXCEL_COLS[j] == names[i]) { idx = j; break; }
		}
		arr.push(idx < 0 ? "" : (idx + 1));
	}
	return arr.join("|");
}
