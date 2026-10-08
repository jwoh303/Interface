/**********************************************
 * 표준DB > 구매정보 고객사 매핑변경 양식 — 그리드 컬럼·엑셀 열 정의 (공용)
 *
 * 두 화면이 같은 정의를 써야 한다 :
 *   - 목록  masterMdCmCmsBuyInfoList.jsp    → 양식 다운로드 요청(서버 POI 생성) · 업로드(LoadExcel)
 *   - 팝업  masterMdCmCmsBuyInfoMapPop      → 업로드 결과 표시·검증
 * 한쪽에만 컬럼을 추가하면 엑셀 열 번호와 그리드가 조용히 어긋난다.
 * → 정의는 여기 한 곳에만 두고 양쪽이 include 한다. (형제 : cmsBuyInfoRegForm.js · cmsBuyInfoModForm.js).
 **********************************************/

// 엑셀 양식의 열 순서(10열). 배열 순서 = 엑셀 A~J 열 순서.
// ⚠ 서버 MasterMdCmCmsBuyInfoMapFormExcel.COLS 와 같은 순서여야 한다.
var MDCM_MAP_EXCEL_COLS = [
	 "CMS_CATLG_ID"			//  1 A  기존 상품정보코드
	,"BUY_INFO_SEQ"		//  2 B  기존 구매정보 순번
	,"GROUP_CODE"			//  3 C
	,"GROUP_NAME"			//  4 D
	,"BUYER_CODE"			//  5 E
	,"BUYER_NAME"			//  6 F
	,"BUYER_ITEM_NO"		//  7 G
	,"CSV_YN"			//  8 H
	,"NEW_CMS_CATLG_ID"		//  9 I  ← 입력
	,"NEW_BUY_INFO_SEQ"	// 10 J  ← 입력 (순번. 전체코드를 적어도 받는다)
];

// 양식 헤더는 3행(안내문/그룹명/소제목) → 데이터는 4행부터.
// ⚠ 서버 MasterMdCmCmsBuyInfoMapFormExcel.DATA_START_ROW 와 같은 값이어야 한다.
var MDCM_MAP_DATA_START_ROW = "4";

/* 양식 머리글 [그룹명(2행), 소제목(3행)] - 올린 파일이 이 양식인지 대조한다(excelFormCheck.js).
 * 배열 순서 = MDCM_MAP_EXCEL_COLS. 병합된 칸은 빈 값으로 두어 대조에서 뺀다.
 * ⚠ 서버 MasterMdCmCmsBuyInfoMapFormExcel.COLS 의 그룹명·소제목과 같아야 한다. */
var MDCM_MAP_FORM_HEAD = [
	 ["기존 표준DB", "상품정보코드"], ["", "구매정보코드"]
	,["매핑 고객사DB", "그룹사코드"], ["", "그룹사명"], ["", "고객사코드"], ["", "고객사명"]
	,["", "고객사 품목코드"], ["", "고객사지정여부"]
	,["변경 표준DB", "*상품정보코드"], ["", "*구매정보코드"]
];

/* 매핑변경 결과 그리드 컬럼 정의. **호출할 때마다 새 배열**을 만든다 —
 * IBSheet 가 넘겨받은 객체를 손대기 때문에 상수 배열을 두 시트가 나눠 쓰면 두 번째 초기화가 어긋난다. */
function mdcmMapCols() {
	return [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태|상태",						SaveName:"sStatus"}
		,{ Align:"Center",	Width:40,	Edit:false,	EditLen:10,		Sort:0,			Type:"Seq",		Header:"No|No",							SaveName:"NO"}

		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,		Type:"Text",	Header:"기존 표준DB|상품정보코드",		SaveName:"CMS_CATLG_ID"}
		,{ Align:"Center",	Width:115,	Edit:false,	EditLen:26,		Hidden:true,	Type:"Text",	Header:"기존 구매정보코드(키)",	SaveName:"BUY_INFO_ID"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:5,		Type:"Text",	Header:"기존 표준DB|구매정보코드",		SaveName:"BUY_INFO_SEQ"}

		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:40,		Type:"Text",	Header:"매핑 고객사DB|그룹사코드",		SaveName:"GROUP_CODE"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",	Header:"매핑 고객사DB|그룹사명",			SaveName:"GROUP_NAME"}
		,{ Align:"Center",	Width:95,	Edit:false,	EditLen:20,		Type:"Text",	Header:"매핑 고객사DB|고객사코드",		SaveName:"BUYER_CODE"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:200,	Type:"Text",	Header:"매핑 고객사DB|고객사명",			SaveName:"BUYER_NAME"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:50,		Type:"Text",	Header:"매핑 고객사DB|고객사 품목코드",	SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:1,		Type:"Text",	Header:"매핑 고객사DB|고객사지정여부",	SaveName:"CSV_YN"}

		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,		Type:"Text",	Header:"변경 표준DB|상품정보코드",		SaveName:"NEW_CMS_CATLG_ID"}
		,{ Align:"Center",	Width:115,	Edit:false,	EditLen:26,		Hidden:true,	Type:"Text",	Header:"변경 구매정보코드(키)",	SaveName:"NEW_BUY_INFO_ID"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:26,		Type:"Text",	Header:"변경 표준DB|구매정보코드",		SaveName:"NEW_BUY_INFO_SEQ"}

		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:4,		Type:"Text",	Header:"결과|결과",						SaveName:"RESULT"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:100,	Type:"Text",	Header:"결과|오류항목",					SaveName:"ERR_COL"}
		,{ Align:"Left",	Width:220,	Edit:false,	EditLen:300,	Type:"Text",	Header:"결과|오류사유",					SaveName:"ERR_MSG"}

		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:20,		Hidden:true,	Type:"Text",	Header:"계약번호|계약번호",	SaveName:"CONTRACT_NO"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:6,		Hidden:true,	Type:"Text",	Header:"계약순번|계약순번",	SaveName:"CONTRACT_SEQ"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:20,		Hidden:true,	Type:"Text",	Header:"협력사코드|협력사코드",	SaveName:"AGENT"}
	];
}

function mdcmMapColNames() {
	var cols = mdcmMapCols();
	var arr = [];
	for (var i = 0; i < cols.length; i++) { arr.push(cols[i].SaveName); }
	return arr;
}

/* 업로드용 ColumnMapping : 그리드 컬럼 순서대로 엑셀 열 번호를 지정, 빈칸은 읽지 않는다.
 * ⚠ 헤더가 3행이고 그룹명이 병합돼 HeaderMatch 를 쓸 수 없다 → 위치 기반 매핑 */
function mdcmMapColMapping() {
	var names = mdcmMapColNames();
	var arr = [];
	for (var i = 0; i < names.length; i++) {
		var idx = -1;
		for (var j = 0; j < MDCM_MAP_EXCEL_COLS.length; j++) {
			if (MDCM_MAP_EXCEL_COLS[j] == names[i]) { idx = j; break; }
		}
		arr.push(idx < 0 ? "" : (idx + 1));
	}
	return arr.join("|");
}

/* 구매정보코드 형식인가. `상품정보코드-순번5자리` (ex. M000012345-00001) */
function mdcmMapIsBuyInfoCode(v) {
	var s = $.trim((v == null) ? "" : ("" + v));
	return /^[A-Za-z0-9]+-\d{5}$/.test(s);
}


/* 구매정보코드에서 앞의 상품정보코드만 떼어낸다. 형식이 아니면 빈 문자열. */
function mdcmMapCatlgOf(v) {
	var s = $.trim((v == null) ? "" : ("" + v));
	var i = s.indexOf("-");
	return (i <= 0) ? "" : s.substring(0, i);
}
