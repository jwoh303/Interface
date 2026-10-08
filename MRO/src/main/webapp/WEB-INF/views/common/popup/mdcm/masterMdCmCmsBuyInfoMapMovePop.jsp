<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>구매정보 조회 및 관리 > 구매정보 상세 팝업 > [매핑이관]
* 화면 : (팝업) 고객사 매핑 이관
* 기능 : 구매정보에 매핑된 고객사 정보를 다른 표준DB코드로 옮긴다.
*        - 상단 좌 : 기존 표준DB 정보 / 우 : 변경 표준DB 정보 ([표준DB 조회] 로 채운다)
*        - 하단   : 기존 표준DB코드에 매달린 고객사 매핑정보 (체크박스 + 'N건 선택')
*        - [초기화] : 변경 표준DB 란만 비운다
*        - [매핑이관] : 체크한 고객사를 변경 표준DB코드로 이관
*          ★ 고객사 지정여부가 Y인 항목은 동일한 협력사인 경우만 변경 가능하다(화면·서버 양쪽에서 막는다)
*        - 반환 수신 : setPopupReturn(구매정보코드, 품목명)
* 담당자 : 홍준우
* 착수일 : 2026-09-14
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
</head>
<%
	String st_catlg_id = CommonUtil.nvl((String) request.getParameter("st_catlg_id"), "");
	String st_buy_info = CommonUtil.nvl((String) request.getParameter("st_buy_info"), "");
%>
<script type="text/javascript">
var mySheet    = new ibsheetObject();
var pagingMode = "N";	// 한 구매정보에 달린 고객사라 스크롤

var FROM_BUY_INFO = "<%=st_buy_info%>";
var TO_BUY_INFO   = "";		// [표준DB 조회] 로 고른 변경 표준DB코드
var popupSel      = "";	// 자식 팝업 반환값 분기용

// 자식 팝업(s34)이 상단 참고행에 쓰려고 읽어 간다
var mdcmMapFromInfo = {};
var mdcmMapToInfo   = {};

// 두 패널의 표시 항목. 라벨 순서가 곧 표 순서다.
var PANEL_FIELDS = [
	 ["BUY_INFO_ID",    "표준DB코드"]
	,["DESCRIPTION_LOC","품목명"]
	,["MODEL_INFO",     "모델번호"]
	,["SPECIFICATION",  "규격"]
	,["MAKER_NAME",     "제조사"]
	,["ORIGIN_NAME",    "원산지"]
	,["MEASURE",        "단위"]
	,["VENDOR_NAME",    "협력사"]
	,["BUY_PRICE",      "매입단가"]
	,["MIN_ORDER_QTY",  "최소주문수량"]
	,["PUR_UNIT_QTY",   "주문배수단위"]
	,["PROCESS_TYPE",   "거래유형"]
	,["DELIVERY_TYPE",  "배송유형"]
	,["WAREHOUSE_NAME", "입고TR"]
];

function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,	Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus"}
		,{ Align:"Center",	Width:34,	Edit:true,	EditLen:1,					Type:"DummyCheck",	Header:"",				SaveName:"SELECTED",	Sort:0}
		,{ Align:"Center",	Width:130,	Edit:false,	EditLen:40,					Type:"Text",		Header:"그룹사코드",		SaveName:"GROUP_CODE"}
		,{ Align:"Left",	Width:240,	Edit:false,	EditLen:100,				Type:"Text",		Header:"그룹사명",		SaveName:"GROUP_NAME"}
		,{ Align:"Center",	Width:130,	Edit:false,	EditLen:20,					Type:"Text",		Header:"고객사코드",		SaveName:"BUYER_CODE"}
		,{ Align:"Left",	Width:290,	Edit:false,	EditLen:200,				Type:"Text",		Header:"고객사명",		SaveName:"BUYER_NAME"}
		,{ Align:"Center",	Width:160,	Edit:false,	EditLen:50,					Type:"Text",		Header:"품목코드",		SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:1,					Type:"Text",		Header:"고객사\n지정여부",	SaveName:"CSV_YN"}
		,{ Align:"Left",	Width:160,	Edit:false,	EditLen:600,	Hidden:true,	Type:"Text",		Header:"품목명",			SaveName:"DESCRIPTION"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:20,	Hidden:true,	Type:"Text",		Header:"단위",			SaveName:"MEASURE"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"협력사",			SaveName:"VENDOR_NAME"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:1,	Hidden:true,	Type:"Text",		Header:"피베이스\n여부",	SaveName:"FEE_BASE_YN"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:10,	Hidden:true,	Type:"Text",		Header:"피베이스율",		SaveName:"FEE_BASE_RATE"}
		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:25,	Hidden:true,	Type:"Text",		Header:"매출단가",		SaveName:"UNIT_PRICE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:8,	Hidden:true,	Type:"Text",		Header:"유효기간\n시작일",	SaveName:"FROM_DATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:8,	Hidden:true,	Type:"Text",		Header:"유효기간\n종료일",	SaveName:"TO_DATE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:20,	Hidden:true,	Type:"Text",		Header:"계약번호",		SaveName:"CONTRACT_NO"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:6,	Hidden:true,	Type:"Text",		Header:"계약순번",		SaveName:"CONTRACT_SEQ"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:20,	Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0, UseNoDataRow:1};
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	loadStdInfo(FROM_BUY_INFO, "from");
	renderPanel({}, "to");
	doAction("search");
}

/* 표준DB 단건 정보 조회 후 패널에 그린다. which = from | to */
function loadStdInfo(code, which){
	if ($.trim(code) == "") { renderPanel({}, which); return; }

	$.ajax({
		 type		: "POST"
		,url		: "/mdcm/getMasterMdCmCmsBuyInfoMapStdInfo.do"
		,headers	: { 'X-Requested-With': 'XMLHttpRequest' }
		,data		: { st_buy_info : code }
		,dataType	: "json"
		,success	: function(res){
			var d = (res && res.data) ? res.data : {};
			if (which == "from") { mdcmMapFromInfo = d; } else { mdcmMapToInfo = d; }
			renderPanel(d, which);
			if (which == "from") { syncPanelHeight(); }
		}
		,error		: function(){
			alert("표준DB 정보를 불러오지 못했습니다.");
		}
	});
}

/* 패널 표를 노드로 조립한다 — 명칭에 따옴표가 섞여도 안 깨진다. */
function renderPanel(d, which){
	var $body = $(which == "from" ? "#fromBody" : "#toBody").empty();

	var isEmpty = true;
	for (var k in d) { if (d.hasOwnProperty(k)) { isEmpty = false; break; } }

	if (isEmpty) {
		var $td = $('<td colspan="2" class="emptyPanel">');
		$td.append($('<b>').text("아직 선택된 표준DB가 없습니다."));
		$td.append($('<span>').text("[표준DB 조회] 로 이관할 표준DB를 선택하세요."));
		$body.append($('<tr>').append($td));
		markDiff();
		syncPanelHeight();
		return;
	}

	for (var i = 0; i < PANEL_FIELDS.length; i++) {
		var key = PANEL_FIELDS[i][0];
		var lbl = PANEL_FIELDS[i][1];
		var val = (d && d[key] != null) ? d[key] : "";

		var $tr = $('<tr>');
		$tr.append($('<th scope="row" class="center">').text(lbl));
		$tr.append($('<td class="left">').attr("data-key", key).text(val));
		$body.append($tr);
	}

	markDiff();
}

/* 기존·변경 패널을 항목별로 대조해 달라진 값칸을 표시한다 - 표시는 오른쪽(변경) 패널에만 둘러준다.
   한쪽이 비어 있으면(변경 표준DB 미선택·초기화) 표시할 것이 없으므로 전부 지운다. */
function markDiff(){
	$("#toBody td.diffVal").removeClass("diffVal");

	var to = mdcmMapToInfo;
	var isEmpty = true;
	for (var k in to) { if (to.hasOwnProperty(k)) { isEmpty = false; break; } }
	if (isEmpty) { return; }

	for (var i = 0; i < PANEL_FIELDS.length; i++) {
		var key  = PANEL_FIELDS[i][0];
		var from = $.trim((mdcmMapFromInfo && mdcmMapFromInfo[key] != null) ? String(mdcmMapFromInfo[key]) : "");
		var next = $.trim((to[key] != null) ? String(to[key]) : "");
		if (from == next) { continue; }

		$('#toBody td[data-key="' + key + '"]').addClass("diffVal");
	}
}

/* 빈 패널 칸을 반대쪽 표 높이에 맞춘다 (좌우 박스 높이 정렬) */
function syncPanelHeight(){
	var $cell = $("#toBody .emptyPanel");
	if ($cell.length == 0) { return; }

	var $from = $("#fromBody").closest("table");
	var $to   = $("#toBody").closest("table");
	if ($from.outerHeight() <= 0) { return; }

	/* 행 수가 달라 테두리 개수도 다르다 — 높이를 계산하지 말고 차이만큼 밀어 맞춘다 */
	$cell.css("height", "");
	var gap = $from.outerHeight() - $to.outerHeight();
	if (gap > 0) { $cell.height($cell.height() + gap); }
}

function doAction(str){
	switch(str){
		case "search":	// 고객사 매핑정보 조회
			current_page = -1;
			kepSearch(document.searchForm, mySheet, "/mdam/getMasterMdCmCmsBuyInfoMapCustList.do", pagingMode);
			break;

		case "reset":	// 변경 표준DB 란만 비운다 (조회한 고객사 목록은 그대로 둔다)
			TO_BUY_INFO   = "";
			mdcmMapToInfo = {};
			renderPanel({}, "to");
			$("#guideTo").text("");
			break;

		case "move":
			doMove();
			break;
	}
}

/* [표준DB 조회] */
function doPop(){
	popupSel = "stdSel";
	openSearchPopup("/mdcm/showMasterMdCmCmsBuyInfoMapStdSelPop.do"
	               ,"?st_from_buy_info=" + FROM_BUY_INFO
	               ,"1420,713,no");
}

/* 자식 팝업의 선택 반환 콜백 (popupSel 로 분기 - 다른 화면과 같은 관례) */
function setPopupReturn(value1, value2){
	if (popupSel != "stdSel") { return; }

	TO_BUY_INFO = $.trim(value1);
	loadStdInfo(TO_BUY_INFO, "to");
	$("#guideTo").text("선택한 고객사 매핑을 아래 표준DB코드로 이관합니다.");
}

/* 체크한 행. 'N건 선택' 표시도 여기서 갱신한다. */
function checkedRows(){
	var rows = mySheet.FindCheckedRow("SELECTED").split(";");
	var out  = [];
	for (var i = 0; i < rows.length; i++) {
		if ($.trim(rows[i]) != "") { out.push(rows[i]); }
	}
	return out;
}

function refreshSelCnt(){
	$("#selCnt").text(checkedRows().length);
}

/* 체크 반영 시점 = OnChange. OnClick 은 값이 뒤집히기 전에 와서 한 박자 늦은 수가 잡힌다.
   헤더 전체선택은 OnCheckAllEnd 로 따로 온다. */
function mySheet_OnChange(Row, Col, Value, OldValue){ refreshSelCnt(); }
function mySheet_OnCheckAllEnd(Col, Value){ refreshSelCnt(); }

/* [매핑이관] */
function doMove(){
	if (TO_BUY_INFO == "") {
		alert("변경할 표준DB를 조회해 선택해 주세요.");
		return;
	}
	if (TO_BUY_INFO == FROM_BUY_INFO) {
		alert("기존 표준DB와 동일한 구매정보코드입니다.");
		return;
	}

	var picked = checkedRows();
	if (picked.length == 0) {
		alert("이관할 고객사를 선택해 주세요.");
		return;
	}

	/* ★ 고객사 지정여부 Y 는 동일 협력사일 때만 이관할 수 있다.
	 *   서버도 같은 검사를 하지만, 먼저 화면에서 걸러 어떤 행이 걸렸는지 보여 준다. */
	var toAgent = (mdcmMapToInfo && mdcmMapToInfo.AGENT != null) ? $.trim(mdcmMapToInfo.AGENT) : "";
	var blocked = [];
	for (var i = 0; i < picked.length; i++) {
		var r = picked[i];
		if ($.trim(mySheet.GetCellValue(r, "CSV_YN")) != "Y") { continue; }
		if ($.trim(mySheet.GetCellValue(r, "AGENT")) != toAgent) {
			blocked.push($.trim(mySheet.GetCellValue(r, "BUYER_NAME")));
		}
	}
	if (blocked.length > 0) {
		alert("고객사 지정여부가 Y인 항목은 동일한 협력사인 경우만 변경 가능합니다.\n\n"
		    + "대상 : " + blocked.join(", "));
		return;
	}

	if (!confirm("선택한 고객사 " + picked.length + " 건을 아래 표준DB코드로 이관합니다.\n\n"
	           + FROM_BUY_INFO + "  ->  " + TO_BUY_INFO + "\n\n"
	           + "변경 시 기존 표준DB와의 매핑은 해제됩니다. 진행하시겠습니까?")) { return; }

	var names = ["BUYER_CODE","CONTRACT_NO","CONTRACT_SEQ"];
	var param = { s_SAVENAME : names.join("|")
	            , st_from_buy_info : FROM_BUY_INFO
	            , st_to_buy_info   : TO_BUY_INFO };
	for (var i = 0; i < names.length; i++) { param[names[i]] = []; }

	for (var i = 0; i < picked.length; i++) {
		for (var j = 0; j < names.length; j++) {
			param[names[j]].push($.trim(mySheet.GetCellValue(picked[i], names[j])));
		}
	}

	/* 부모(상세팝업)에서 걷어낼 행 식별키 — 상세팝업 <tr data-mapkey> 와 같은 규약이다. */
	var movedKeys = [];
	for (i = 0; i < picked.length; i++) {
		movedKeys.push($.trim(mySheet.GetCellValue(picked[i], "BUYER_CODE"))
		             + "|" + $.trim(mySheet.GetCellValue(picked[i], "CONTRACT_NO"))
		             + "|" + $.trim(mySheet.GetCellValue(picked[i], "CONTRACT_SEQ")));
	}

	loader_obj("Y");
	$.ajax({
		 type		: "POST"
		,url		: "/mdcm/saveMasterMdCmCmsBuyInfoMapMove.do"
		,headers	: { 'X-Requested-With': 'XMLHttpRequest' }
		,traditional: true
		,data		: param
		,dataType	: "json"
		,success	: function(res){
			loader_obj("N");

			// 실패 응답에는 Result.Code 가 없다(ExceptionController 가 HTTP 200 + Message 로 답한다)
			if (!res || !res.Result || res.Result.Code != 1) {
				alert("매핑 이관 처리 중 오류가 발생하였습니다.\n\n"
				    + ((res && res.Message) ? res.Message : "관리자에게 문의 바랍니다."));
				return;
			}
			alert("고객사 매핑 " + ((res.Message == null) ? "" : res.Message) + " 건이 이관되었습니다.");

			// 상세팝업을 통째로 다시 읽지 않는다 — 편집 중이던 값이 날아간다.
			// 이관된 고객사 행만 걷어내게 키를 넘긴다(이관 = 이 구매정보에서 빠지는 변경).
			try {
				if (opener && !opener.closed && typeof opener.removeMapRows == "function") { opener.removeMapRows(movedKeys); }
			} catch (e) { }
			self.close();
		}
		,error		: function(){
			loader_obj("N");
			alert("매핑 이관 처리 중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
		}
	});
}

//그리드 표시후 처리
function mySheet_OnLoadData(DATA){ refreshSelCnt(); return DATA; }

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode){
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if(msg != ""){ alert(msg); }
	refreshSelCnt();
}
</script>

<style>
.PopGuide{ display:block; margin:8px 0 6px; color:#444; font-size:13px; }
.PopWarn{ display:block; margin:0 0 8px; color:#c0392b; font-size:12px; line-height:1.6; }
.panelWrap{ position:relative; width:100%; overflow:hidden; }
.panelBox{ float:left; width:47.5%; }
.panelBox.right{ float:right; }
.panelTitle{ font-weight:bold; color:#3c639c; margin:0 0 4px 2px; height:36px; line-height:36px; }
/* 제목줄 안의 버튼이 줄 높이를 밀어 좌우 패널 시작점이 어긋나던 것을 막는다.
   line-height 는 되돌린다 — 36px 이 버튼 <a> 로 상속되면 글자가 배경이미지 아래로 내려간다 */
.panelTitle .btn_05, .panelTitle .btn_02{ margin-top:0; vertical-align:middle; line-height:normal; }
.panelTitle .btn_05 a, .panelTitle .btn_02 a{ line-height:22px; }
/* 제목줄 버튼은 패널 오른쪽 끝에 붙인다 */
.panelTitle{ overflow:hidden; }
.panelTitle .titleBtns{ float:right; }
.panelTitle .titleBtns .btn_02{ margin-left:4px; }
/* 기존과 다른 항목은 변경 패널 쪽 값칸만 빨간색·굵게 */
.panelBox.right .cont_t_list06 td.diffVal{ color:#d00; font-weight:bold; }
.panelBox table td{ word-break:break-all; }
.panelArrow{ position:absolute; left:50%; top:50%; margin:-11px 0 0 -11px; width:22px; height:22px;
             line-height:22px; text-align:center; font-size:18px; font-weight:bold; color:#9aa5b1; }
.panelBox .cont_t_list06 td.emptyPanel{ text-align:center; vertical-align:middle; color:#999; padding:20px 10px; }
.emptyPanel b{ display:block; color:#666; font-size:13px; margin-bottom:6px; }
.emptyPanel span{ display:block; font-size:12px; }
.toGuide{ display:block; color:#3c639c; font-size:12px; margin:4px 0 0 2px; min-height:16px; }
.selCntRow{ margin:6px 2px 0; font-size:12px; color:#333; }
.mapHeadRow{ overflow:hidden; margin:6px 2px 4px; }
.mapHeadRow .selCntRow{ float:left; margin:0; }
.mapHeadRow .PopWarn{ float:right; margin:0; }
.selCntRow b{ color:#c0392b; }
</style>

<body onLoad="kep_onload_view()">
	<form name="searchForm" id="searchForm" method="post">
		<input type="hidden" id="st_catlg_id" name="st_catlg_id" value="<%=st_catlg_id%>">
		<input type="hidden" id="st_buy_info" name="st_buy_info" value="<%=st_buy_info%>">
		<input type="hidden" id="s_SAVENAME" name="s_SAVENAME" />
		<input type="hidden" id="pageflag" name="pageflag" value="1" />
		<input type="hidden" name="onepagerow" id="onepagerow" value="1000" />

	<div id="popWrapper" style="width:1140px;">
		<div id="popHeader">
			<h1 class="title">고객사 매핑 이관</h1>
			<p class="popClose"><a href="javascript:self.close()">
				<img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
			</a></p>
		</div>

		<!--팝업내용입니다-->
		<div id="popContainer">

			<span class="PopGuide">고객사 매핑을 이관할 표준DB를 조회하여 선택하세요.</span>
			<span class="PopWarn">변경 시 기존 표준DB와의 매핑은 해제되며, 변경된 표준DB로 매핑됩니다.</span>

			<!--상단 : 기존 / 변경 표준DB 정보-->
			<div class="panelWrap">
				<div class="panelBox">
					<p class="panelTitle">기존 표준DB 정보</p>
					<table class="cont_t_list06" summary="기존 표준DB 정보" style="width:100%;">
						<caption>기존 표준DB 정보</caption>
						<colgroup>
							<col width="32%" />
							<col width="*" />
						</colgroup>
						<tbody id="fromBody"></tbody>
					</table>
				</div>

				<div class="panelBox right">
					<p class="panelTitle">
						변경 표준DB 정보
						<span class="titleBtns">
							<span class="btn_05"><a href="javascript:doPop();">표준DB 조회</a></span>
							<span class="btn_02"><a href="javascript:doAction('reset');">초기화</a></span>
						</span>
					</p>
					<table class="cont_t_list06" summary="변경 표준DB 정보" style="width:100%;">
						<caption>변경 표준DB 정보</caption>
						<colgroup>
							<col width="32%" />
							<col width="*" />
						</colgroup>
						<tbody id="toBody"></tbody>
					</table>
					<span class="toGuide" id="guideTo"></span>
				</div>

				<span class="panelArrow">&rarr;</span>
			</div>

			<!--하단 : 고객사 매핑정보-->
			<div class="mt10">
				<p class="panelTitle">고객사 매핑정보</p>
				<div class="mapHeadRow">
					<p class="selCntRow"><b><span id="selCnt">0</span></b> 건 선택</p>
					<span class="PopWarn">고객사 지정여부가 Y인 항목은 동일한 협력사인 경우만 변경 가능합니다.</span>
				</div>
				<div class="ib_product" style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "100%", "260px");
					</script>
				</div>
			</div>

			<!--하단 버튼-->
			<div class="btnArea mt05" style="text-align:right; padding:10px 0;">
				<span class="btn_02"><a href="javascript:doAction('move');">매핑이관</a></span>
			</div>
			<br>
		</div>
	</div>
	</form>
</body>
</html>
