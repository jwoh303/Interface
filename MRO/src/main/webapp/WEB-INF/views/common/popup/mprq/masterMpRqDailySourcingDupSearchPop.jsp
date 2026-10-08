<%--
**********************************************
* 메뉴 : 구매대행>견적관리>데일리소싱(구매)
* 화면 : (팝업) 중복검색
* 기능 : 매입가제출 상세의 [중복검색]에서 연다. 고객사 카탈로그 · 표준DB 에서 요청 품목과 같은 상품을 찾는다.
* 프로그램 ID :
* 담당자 : 홍준우
* 착수일 : 2026-09-29
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<style type="text/css">
html, body{overflow:hidden;}
body{background-color:#e8e9ee;}
#popHeader, #popContainer{font-family:'Pretendard', sans-serif;}
#popWrapper #popHeader{height:40px;}
#popHeader h1.title{top:9px; font-size:18px; letter-spacing:0px;}
#popHeader .popClose{top:11px;}
#popContainer{padding:6px 10px 0 10px; background-color:#e8e9ee;}

input:focus, select:focus{outline:none;}
.input30{height:22px; line-height:22px; padding:0 5px; color:#1b1b1b; font-size:12px; letter-spacing:-0.2px; font-weight:500; border:1px solid #DEDEDE; border-radius:4px; vertical-align:middle; box-sizing:border-box; background-color:#fff;}
.input30[readonly]{background-color:#f3f3f5;}
.Select{height:22px; line-height:20px; color:#24252B; font-size:12px; font-weight:500; cursor:pointer; vertical-align:middle; border:1px solid #DEDEDE; border-radius:4px; background-color:#fff; box-sizing:border-box;}
.Btn-Searchimg{flex:none; width:22px; height:22px; cursor:pointer; vertical-align:middle; background:url(/resources/imgs/btn_search_new.gif) no-repeat center; background-size:14px 14px; border:1px solid #DEDEDE; border-radius:4px;}
.Btn-eraser{flex:none; width:22px; height:22px; cursor:pointer; vertical-align:middle; background:url(/resources/imgs/btn_eraser_new.gif) no-repeat center; background-size:14px 14px; border:1px solid #DEDEDE; border-radius:4px;}
.ButOutline{height:26px; line-height:24px; padding:0 10px; font-size:12.5px; font-weight:500; letter-spacing:-0.5px; color:#404046; background-color:#fff; border:1px solid #DEDEDE; border-radius:6px; cursor:pointer; vertical-align:middle; white-space:nowrap;}
.ButOutline:hover{color:#fff; border:1px solid #595D7E; background:#595D7E;}
.ButOutline-on{height:26px; line-height:24px; padding:0 10px; font-size:12.5px; font-weight:500; letter-spacing:-0.5px; color:#fff; background-color:#595D7E; border:1px solid #595D7E; border-radius:6px; cursor:pointer; vertical-align:middle; white-space:nowrap;}
.titBtn{height:22px; line-height:20px; padding:0 10px; font-size:12px; font-weight:500; color:#404046; background-color:#fff; border:1px solid #DEDEDE; border-radius:4px; cursor:pointer; vertical-align:middle;}
.titBtn:hover{background-color:#f6f6f6;}
.tip{vertical-align:middle; cursor:help;}

.dup-wrap{display:grid; grid-template-columns:minmax(0, 1fr) 330px; gap:6px;}
.box{border:1px solid #c4c7ce; background-color:#fff;}
.box-title{display:flex; align-items:center; gap:6px; height:22px; padding:0 10px; font-size:13px; font-weight:600; letter-spacing:-0.3px; color:#000; background-color:#dfe1e6; border-bottom:1px solid #c4c7ce;}
.tool-line{display:flex; align-items:center; gap:6px; height:30px; padding:0 8px; font-size:12px; color:#1b1b1b; background-color:#f1f2f4; border-bottom:1px solid #c4c7ce; white-space:nowrap;}
.tool-line .right{margin-left:auto; display:flex; align-items:center; gap:4px;}
.tool-line input[type=checkbox]{width:14px; height:14px; margin:0; vertical-align:middle;}

.info-table{width:100%; border-collapse:collapse; table-layout:fixed; font-size:12px; color:#1b1b1b;}
.info-table th{height:21px; font-weight:500; letter-spacing:-0.5px; text-align:center; background-color:#e4e5ea; border:1px solid #cbcbcb;}
.info-table td{height:22px; text-align:center; border:1px solid #e1e1e1; background-color:#fff;}
.top-btns{display:flex; align-items:center; justify-content:flex-end; gap:4px; padding:0 8px; height:100%;}

.IBsheetScroll{height:180px; overflow:auto; background-color:#fff; scrollbar-width:thin; scrollbar-color:#acadb3 #ebecf2;}
.IBsheet-table{font-size:12px; color:#1b1b1b; background-color:#fff; border-collapse:collapse; table-layout:fixed;}
.IBsheet-table th{position:sticky; top:0; z-index:1; height:34px; padding:0 3px; font-weight:500; letter-spacing:-0.5px; line-height:14px; text-align:center; border:1px solid #cbcbcb; background-color:#e4e5ea; white-space:normal;}
.IBsheet-table td{height:22px; padding:0 4px; border:1px solid #e1e1e1; overflow:hidden; white-space:nowrap; text-overflow:ellipsis;}
.IBsheet-table td.empty{text-align:left; padding-left:20px; color:#888888;}
.IBsheet-table input[type=checkbox]{width:13px; height:13px; margin:0; vertical-align:middle;}
.grid-count{height:24px; line-height:24px; text-align:center; font-size:12px; color:#404046; border-top:1px solid #e1e1e1;}
.grid-count a{padding:0 4px; color:#404046; cursor:pointer; text-decoration:none;}
.grid-count a.on{font-weight:700; color:#000;}
.sheet-slot{flex:1 1 auto; background-color:#fff;}

.srch-target{display:flex; align-items:center; gap:14px; padding:6px 10px; font-size:12px; border-bottom:1px solid #e1e1e1;}
.srch-target label{display:flex; align-items:center; gap:4px; cursor:pointer;}
.srch-target input[type=checkbox]{width:14px; height:14px; margin:0;}
.form-table{width:100%; border-collapse:collapse; table-layout:fixed; font-size:12px; color:#1b1b1b;}
.form-table th{height:28px; padding-left:10px; text-align:left; font-weight:500; letter-spacing:-0.5px; white-space:nowrap;}
.form-table td{height:28px; padding-right:10px;}
.form-table td .input30{width:100%;}
.form-table td .fx{display:flex; align-items:center; gap:3px;}
.form-table td .fx .input30{flex:1; min-width:0;}
.req-table th, .req-table td{height:26px;}
.box-foot{display:flex; justify-content:flex-end; padding:4px 10px 6px 10px;}
.fill-col{display:flex; flex-direction:column;}
.fill-col .box-foot{margin-top:auto;}
.fill-col .IBsheetScroll{flex:1 1 auto;}
.map-btns{gap:3px; padding:4px 6px 6px 6px;}
.map-btns button{padding:0 6px; font-size:12px;}
</style>
</head>
<body onload="kep_onload_view();">
<div id="popWrapper">
	<div id="popHeader"><h1 class="title">중복검색</h1><p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p></div>
	<div id="popContainer">
		<div class="dup-wrap">
			<div class="box">
				<table class="info-table">
					<colgroup><col width="*" /><col width="9%" /><col width="9%" /><col width="9%" /><col width="9%" /><col width="12%" /><col width="12%" /></colgroup>
					<tr><th>고객사</th><th>TR</th><th>간선여부</th><th>택배</th><th>직접방문</th><th>비딩내역공개</th><th>필수참여업체수</th></tr>
					<tr><td id="hdBuyerName"></td><td id="hdTr"></td><td id="hdTrunk"></td><td id="hdParcel"></td><td id="hdVisit"></td><td id="hdBidOpen"></td><td id="hdMinAgentCnt"></td></tr>
				</table>
			</div>
			<div class="box">
				<div class="top-btns">
					<button type="button" class="ButOutline" onclick="doReset();">초기화</button>
					<button type="button" class="ButOutline-on" onclick="doSearch();">조회</button>
				</div>
			</div>
		</div>

		<div class="dup-wrap" style="margin-top:6px;">
			<div class="box fill-col">
				<div class="tool-line">
					정렬개수 <select class="Select" id="catRowCnt" style="width:70px;"><option value="50">50건</option><option value="100">100건</option><option value="150">150건</option><option value="200">200건</option></select>
					<span style="margin-left:10px;">그룹카탈로그 조회</span> <input type="checkbox" id="catGroupYn">
					<span class="right">품목코드 <input type="text" class="input30" id="catItemNo" style="width:170px;"> <button type="button" class="titBtn" onclick="doSearch('CAT');">조회</button></span>
				</div>
				<div class="box-title">중복조회-고객사 카탈로그</div>
				<div class="sheet-slot"><script type="text/javascript">createIBSheet("catSheet", "100%", "180px");</script></div>
				<div class="grid-count" id="catPager">[총 0 건]</div>
			</div>

			<div class="box fill-col">
				<div class="box-title">검색 <img src="/resources/images/but_query.png" class="tip" title="▶ 규격은 검색어 사이에 ^^ 를 넣으면 이어지지 않은 값도 검색합니다.&#10;예) 40^^VITON → 40x50x8T; VITON 조회"></div>
				<div class="srch-target">
					<label><input type="checkbox" name="srchTarget" value="ALL" checked onclick="pickTarget(this);">전체</label>
					<label><input type="checkbox" name="srchTarget" value="CAT" onclick="pickTarget(this);">고객사 카탈로그</label>
					<label><input type="checkbox" name="srchTarget" value="STD" onclick="pickTarget(this);">표준DB</label>
				</div>
				<table class="form-table" id="srchForm">
					<colgroup><col width="78" /><col width="*" /></colgroup>
					<tr><th>품목명</th><td><input type="text" class="input30" id="st_description" onkeydown="enterSearch();"></td></tr>
					<tr><th>모델번호</th><td><input type="text" class="input30" id="st_maker_part_no" onkeydown="enterSearch();"></td></tr>
					<tr><th>규격</th><td><input type="text" class="input30" id="st_specification" onkeydown="enterSearch();"></td></tr>
					<tr><th>제조사</th><td><input type="text" class="input30" id="st_maker_name" onkeydown="enterSearch();"></td></tr>
					<tr><th>단위</th><td><input type="text" class="input30" id="st_unit_measure" onkeydown="enterSearch();"></td></tr>
					<tr><th>카테고리</th><td><div class="fx"><input type="text" class="input30" id="st_sg_name" style="cursor:pointer;" onclick="openSgPop();" readonly><input type="hidden" id="st_sg_id_multi"><button type="button" class="Btn-Searchimg" onclick="openSgPop();"></button><button type="button" class="Btn-eraser" onclick="clearCateg();"></button></div></td></tr>
				</table>
				<div class="box-foot"><button type="button" class="ButOutline" onclick="kepNotYet();">정비요청</button></div>
			</div>

			<div class="box fill-col">
				<div class="tool-line">
					정렬개수 <select class="Select" id="stdRowCnt" style="width:70px;"><option value="50">50건</option><option value="100">100건</option><option value="150">150건</option><option value="200">200건</option></select>
					<span style="margin-left:10px;">매핑 표준DB코드</span> <input type="text" class="input30" id="mapCmsCode" style="width:170px;" readonly>
					<span class="right">표준DB코드 <input type="text" class="input30" id="stdCmsCode" style="width:170px;"> <button type="button" class="titBtn" onclick="doSearch('STD');">조회</button></span>
				</div>
				<div class="box-title">중복조회-표준DB</div>
				<div class="sheet-slot"><script type="text/javascript">createIBSheet("stdSheet", "100%", "180px");</script></div>
				<div class="grid-count" id="stdPager">[총 0 건]</div>
			</div>

			<div class="box fill-col">
				<div class="box-title">요청정보</div>
				<table class="form-table req-table">
					<colgroup><col width="78" /><col width="*" /></colgroup>
					<tr><th>품목코드</th><td><input type="text" class="input30" id="rq_buyer_item_no" readonly></td></tr>
					<tr><th>품목명</th><td><input type="text" class="input30" id="rq_description" readonly></td></tr>
					<tr><th>모델번호</th><td><input type="text" class="input30" id="rq_maker_part_no" readonly></td></tr>
					<tr><th>규격</th><td><input type="text" class="input30" id="rq_specification" readonly></td></tr>
					<tr><th>제조사</th><td><input type="text" class="input30" id="rq_maker_name" readonly></td></tr>
					<tr><th>원산지</th><td><input type="text" class="input30" id="rq_origin_name" readonly></td></tr>
					<tr><th>수량</th><td><input type="text" class="input30" id="rq_item_qty" readonly></td></tr>
					<tr><th>단위</th><td><input type="text" class="input30" id="rq_unit_measure" readonly></td></tr>
				</table>
				<div class="box-foot map-btns">
					<button type="button" class="ButOutline" onclick="doMapping('ITEM');">상품정보-매핑</button>
					<button type="button" class="ButOutline" onclick="doMapping('BUY');">구매정보-매핑</button>
					<button type="button" class="ButOutline" onclick="kepNotYet();">매핑취소</button>
					<button type="button" class="ButOutline-on" onclick="kepNotYet();">구매정보-제출</button>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
var reqInfo = {};
var grids = {
	CAT: {sheet: null, url: "/mprq/searchMasterMpRqDailySourcingDupCatList.do", rowCnt: "catRowCnt", pager: "catPager", cond: null, page: 1},
	STD: {sheet: null, url: "/mprq/searchMasterMpRqDailySourcingDupStdList.do", rowCnt: "stdRowCnt", pager: "stdPager", cond: null, page: 1}
};

function kep_onload_view() {
	var initCat = {};
	initCat.Cols = [
		 { Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,	Edit:true,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
		,{ Align:"Left",	Width:120,	Edit:false,	Type:"Text",	Header:"고객사명",	SaveName:"BUYER_NAME"}
		,{ Align:"Center",	Width:90,	Edit:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Center",	Width:50,	Edit:false,	Type:"Text",	Header:"상태",	SaveName:"ITEM_STATUS_NM"}
		,{ Align:"Center",	Width:90,	Edit:false,	Type:"Text",	Header:"링크코드\n(표준DB)",	SaveName:"CMS_CATLG_ID"}
		,{ Align:"Left",	Width:130,	Edit:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
		,{ Align:"Left",	Width:90,	Edit:false,	Type:"Text",	Header:"모델번호",	SaveName:"MAKER_PART_NO"}
		,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
		,{ Align:"Center",	Width:45,	Edit:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
		,{ Align:"Left",	Width:90,	Edit:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NAME"}
		,{ Align:"Left",	Width:110,	Edit:false,	Type:"Text",	Header:"협력사명",	SaveName:"AGENT_NAME"}
		,{ Align:"Right",	Width:75,	Edit:false,	Type:"Text",	Header:"매입단가\n(VAT별도)",	SaveName:"LIST_PRICE"}
		,{ Align:"Right",	Width:75,	Edit:false,	Type:"Text",	Header:"매출단가\n(VAT별도)",	SaveName:"UNIT_PRICE"}
		,{ Align:"Right",	Width:75,	Edit:false,	Type:"Text",	Header:"매입단가\n(VAT포함)",	SaveName:"LIST_PRICE_VAT"}
		,{ Align:"Right",	Width:75,	Edit:false,	Type:"Text",	Header:"매출단가\n(VAT포함)",	SaveName:"UNIT_PRICE_VAT"}
		,{ Align:"Right",	Width:60,	Edit:false,	Type:"Text",	Header:"최소주문\n수량",	SaveName:"MIN_ORDER_QTY"}
		,{ Align:"Right",	Width:60,	Edit:false,	Type:"Text",	Header:"주문배수\n수량",	SaveName:"PUR_UNIT_QTY"}
		,{ Align:"Center",	Width:65,	Edit:false,	Type:"Text",	Header:"배송조건",	SaveName:"PROCESS_TYPE_NM"}
		,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",	Header:"입고TR",	SaveName:"WAREHOUSE_NAME"}
		,{ Align:"Right",	Width:55,	Edit:false,	Type:"Text",	Header:"배송일수",	SaveName:"DELIVERY_LT"}
		,{ Align:"Center",	Width:85,	Edit:false,	Type:"Date",	Header:"매입단가\n유효일",	SaveName:"BUY_CLOSE_DATE"}
		,{ Align:"Center",	Width:85,	Edit:false,	Type:"Date",	Header:"매출단가\n유효일",	SaveName:"SELL_CLOSE_DATE"}
		,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",	Header:"안전인증\n여부",	SaveName:"SAFETY_FLAG"}
		,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",	Header:"안전인증번호",	SaveName:"SAFE_NO"}
		,{ Align:"Left",	Width:260,	Edit:false,	Type:"Text",	Header:"KeP 카테고리",	SaveName:"CATEG_PATH"}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:true,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER"}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:true,	Type:"Text",	Header:"협력사코드",	SaveName:"AGENT"}
	];
	initCat.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	initCat.HeaderMode = {Sort:0, ColMove:0, ColResize:1, HeaderCheck:1};
	IBS_InitSheet(catSheet, initCat, "N");

	var initStd = {};
	initStd.Cols = [
		 { Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,	Edit:true,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
		,{ Align:"Center",	Width:90,	Edit:false,	Type:"Text",	Header:"상품정보\n코드",	SaveName:"CMS_CATLG_ID"}
		,{ Align:"Center",	Width:70,	Edit:false,	Type:"Text",	Header:"구매정보\n코드",	SaveName:"BUY_INFO_SEQ"}
		,{ Align:"Center",	Width:50,	Edit:false,	Type:"Text",	Header:"공급\n상태",	SaveName:"SUPPLY_STATUS"}
		,{ Align:"Left",	Width:130,	Edit:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
		,{ Align:"Left",	Width:90,	Edit:false,	Type:"Text",	Header:"모델번호",	SaveName:"MODEL_INFO"}
		,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
		,{ Align:"Center",	Width:45,	Edit:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
		,{ Align:"Left",	Width:90,	Edit:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NAME"}
		,{ Align:"Left",	Width:110,	Edit:false,	Type:"Text",	Header:"협력사명",	SaveName:"AGENT_NAME"}
		,{ Align:"Right",	Width:75,	Edit:false,	Type:"Text",	Header:"매입단가\n(VAT별도)",	SaveName:"BUY_PRICE"}
		,{ Align:"Right",	Width:60,	Edit:false,	Type:"Text",	Header:"최소주문\n수량",	SaveName:"MIN_ORDER_QTY"}
		,{ Align:"Right",	Width:60,	Edit:false,	Type:"Text",	Header:"주문배수\n수량",	SaveName:"PUR_UNIT_QTY"}
		,{ Align:"Center",	Width:55,	Edit:false,	Type:"Text",	Header:"거래유형",	SaveName:"PROCESS_TYPE_NM"}
		,{ Align:"Center",	Width:55,	Edit:false,	Type:"Text",	Header:"배송유형",	SaveName:"DELIVERY_TYPE_NM"}
		,{ Align:"Right",	Width:75,	Edit:false,	Type:"Text",	Header:"매입단가\n(VAT포함)",	SaveName:"BUY_PRICE_VAT"}
		,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",	Header:"입고TR",	SaveName:"WAREHOUSE_NAME"}
		,{ Align:"Right",	Width:55,	Edit:false,	Type:"Text",	Header:"배송일수",	SaveName:"DELIVERY_LT"}
		,{ Align:"Center",	Width:85,	Edit:false,	Type:"Date",	Header:"매입단가\n유효일",	SaveName:"BUY_CLOSE_DATE"}
		,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",	Header:"안전인증\n여부",	SaveName:"SAFE_STATUS_NM"}
		,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",	Header:"안전인증번호",	SaveName:"SAFE_NO"}
		,{ Align:"Left",	Width:260,	Edit:false,	Type:"Text",	Header:"KeP 카테고리",	SaveName:"CATEG_PATH"}
		,{ Align:"Center",	Width:120,	Edit:false,	Hidden:true,	Type:"Text",	Header:"구매정보코드(키)",	SaveName:"BUY_INFO_ID"}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:true,	Type:"Text",	Header:"협력사코드",	SaveName:"AGENT"}
	];
	initStd.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	initStd.HeaderMode = {Sort:0, ColMove:0, ColResize:1, HeaderCheck:1};
	IBS_InitSheet(stdSheet, initStd, "N");

	grids.CAT.sheet = catSheet;
	grids.STD.sheet = stdSheet;
	catSheet.SetUserAgent("XMLHttpRequest");
	stdSheet.SetUserAgent("XMLHttpRequest");
	catSheet.SetWaitImageVisible(false);
	stdSheet.SetWaitImageVisible(false);

	try {
		if (opener && opener.getReqInfo) reqInfo = opener.getReqInfo();
	} catch (e) {}
	$("#hdBuyerName").text(kepTrimStr(reqInfo.BUYER_NAME));
	$("#rq_buyer_item_no").val(kepTrimStr(reqInfo.BUYER_ITEM_NO));
	$("#rq_description").val(kepTrimStr(reqInfo.DESCRIPTION));
	$("#rq_maker_part_no").val(kepTrimStr(reqInfo.MAKER_PART_NO));
	$("#rq_specification").val(kepTrimStr(reqInfo.SPECIFICATION));
	$("#rq_maker_name").val(kepTrimStr(reqInfo.MAKER_NAME));
	$("#rq_origin_name").val(kepTrimStr(reqInfo.ORIGIN_NAME));
	$("#rq_item_qty").val(kepTrimStr(reqInfo.ITEM_QTY));
	$("#rq_unit_measure").val(kepTrimStr(reqInfo.UNIT_MEASURE));
	$("#mapCmsCode").val(kepTrimStr(reqInfo.CMS_CODE));
	$("#catGroupYn").prop("checked", true);

	$("#catRowCnt").change(function() { if (grids.CAT.cond) runSearch("CAT", 1); });
	$("#stdRowCnt").change(function() { if (grids.STD.cond) runSearch("STD", 1); });

	var itemNo = kepTrimStr(reqInfo.BUYER_ITEM_NO);
	if (itemNo != "" && itemNo.toUpperCase() != "NO_CODE") {
		$("#catItemNo").val(itemNo);
		doSearch("CAT");
	}
}

function searchCond() {
	return {
		st_description: $.trim($("#st_description").val()),
		st_maker_part_no: $.trim($("#st_maker_part_no").val()),
		st_specification: $.trim($("#st_specification").val()),
		st_maker_name: $.trim($("#st_maker_name").val()),
		st_unit_measure: $.trim($("#st_unit_measure").val()),
		st_sg_id_multi: $("#st_sg_id_multi").val()
	};
}

function doSearch(target) {
	if (kepTrimStr(reqInfo.BUYER) == "") {
		alert("고객사 정보가 없습니다. 매입가제출 화면에서 다시 열어 주세요.");
		return;
	}
	if (target == "CAT") {
		if ($.trim($("#catItemNo").val()) == "") {
			alert("품목코드를 입력하세요.");
			return;
		}
		grids.CAT.cond = {st_item_no: $.trim($("#catItemNo").val())};
		runSearch("CAT", 1);
		return;
	}
	if (target == "STD") {
		if ($.trim($("#stdCmsCode").val()) == "") {
			alert("표준DB코드를 입력하세요.");
			return;
		}
		grids.STD.cond = {st_cms_code: $.trim($("#stdCmsCode").val())};
		runSearch("STD", 1);
		return;
	}
	if (!hasCondition()) {
		alert("품목명, 모델번호, 규격, 제조사 중 하나 이상 입력하세요.");
		return;
	}
	var t = $("input[name=srchTarget]:checked").val();
	if (t == "ALL" || t == "CAT") {
		grids.CAT.cond = searchCond();
		runSearch("CAT", 1);
	}
	if (t == "ALL" || t == "STD") {
		grids.STD.cond = searchCond();
		runSearch("STD", 1);
	}
}

function runSearch(kind, page) {
	var g = grids[kind];
	g.page = page;
	var p = $.extend({}, g.cond, {
		st_buyer: kepTrimStr(reqInfo.BUYER),
		st_group_yn: $("#catGroupYn").is(":checked") ? "Y" : "N",
		pageflag: "1",
		page: page,
		onepagerow: $("#" + g.rowCnt).val()
	});
	$("#" + g.pager).text("조회 중...");
	g.sheet.DoSearch(g.url, $.param(p));
}

function catSheet_OnSearchEnd(code, msg, stCode) {
	afterSearch("CAT", msg);
}

function stdSheet_OnSearchEnd(code, msg, stCode) {
	afterSearch("STD", msg);
}

function afterSearch(kind, msg) {
	drawPager(kind);
	if (msg != null && msg != "") alert(msg);
}

function drawPager(kind) {
	var g = grids[kind];
	var total = g.sheet.RowCount() > 0 ? Number(g.sheet.GetTotalRows()) : 0;
	var size = Number($("#" + g.rowCnt).val());
	var last = Math.max(1, Math.ceil(total / size));
	var $p = $("#" + g.pager).empty();
	if (total > size) {
		var from = Math.floor((g.page - 1) / 5) * 5 + 1;
		var to = Math.min(last, from + 4);
		if (from > 1) $p.append(pageLink(kind, from - 1, "<"));
		for (var i = from; i <= to; i++) $p.append(pageLink(kind, i, String(i)).toggleClass("on", i == g.page));
		if (to < last) $p.append(pageLink(kind, to + 1, ">"));
		$p.append(" ");
	}
	$p.append(document.createTextNode("[총 " + total + " 건]"));
}

function pageLink(kind, page, label) {
	return $("<a>").text(label).click(function() { runSearch(kind, page); });
}

function doMapping(type) {
	var s = stdSheet.FindCheckedRow("SELECTED");
	var rows = (s == "") ? [] : s.split("|");
	if (rows.length == 0) {
		alert("중복조회-표준DB 에서 매핑할 행을 선택하세요.");
		return;
	}
	var code = "";
	var ids = [];
	for (var i = 0; i < rows.length; i++) {
		var c = stdSheet.GetCellValue(rows[i], "CMS_CATLG_ID");
		if (code != "" && code != c) {
			alert("하나의 상품정보코드만 매핑할 수 있습니다.");
			return;
		}
		code = c;
		if (type == "BUY") {
			var id = stdSheet.GetCellValue(rows[i], "BUY_INFO_ID");
			if (id == "") {
				alert("구매정보가 없는 행은 구매정보-매핑할 수 없습니다.");
				return;
			}
			ids.push(id);
		}
	}
	var typeName = (type == "ITEM") ? "상품정보-매핑" : "구매정보-매핑";
	var msg = code + " 으로 " + typeName + " 하시겠습니까?";
	if (type == "BUY") msg = code + " 의 구매정보 " + ids.length + "건으로 " + typeName + " 하시겠습니까?";
	if (!confirm(msg)) return;
	var ok = false;
	try {
		ok = opener.applyDupMapping({
			type: type,
			typeName: typeName,
			cmsCatlgId: code,
			buyInfoIds: ids,
			buyer: kepTrimStr(reqInfo.BUYER),
			quotationNo: kepTrimStr(reqInfo.QUOTATION_NO),
			quotationSeq: kepTrimStr(reqInfo.QUOTATION_SEQ)
		});
	} catch (e) {
		alert("매입가제출 화면을 찾을 수 없습니다.");
		return;
	}
	if (ok) self.close();
}

function pickTarget(el) {
	$("input[name=srchTarget]").not(el).prop("checked", false);
	el.checked = true;
}

function hasCondition() {
	var c = searchCond();
	return c.st_description != "" || c.st_maker_part_no != "" || c.st_specification != "" || c.st_maker_name != "";
}

function doReset() {
	$("#srchForm input").val("");
	$("#catItemNo, #stdCmsCode").val("");
	pickTarget($("input[name=srchTarget][value=ALL]")[0]);
	catSheet.RemoveAll();
	stdSheet.RemoveAll();
	grids.CAT.cond = null;
	grids.STD.cond = null;
	$("#catPager, #stdPager").text("[총 0 건]");
}

function openSgPop() {
	openSearchPopup("/mdcm/showMasterMdCmCmsItemSgSelPop.do", "?st_sg_id_multi=" + $("#st_sg_id_multi").val(), "950,521,no");
}

function setPopupReturn(value1, value2) {
	$("#st_sg_id_multi").val(value1);
	$("#st_sg_name").val(kepMultiName(value2, "@"));
}

function clearCateg() {
	$("#st_sg_name, #st_sg_id_multi").val("");
}

function enterSearch() {
	if (event.keyCode == 13) doSearch();
}
</script>
</body>
</html>
