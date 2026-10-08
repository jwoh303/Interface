<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>구매정보 조회 및 관리 > 상세 팝업 > [매핑이관] > [표준DB 조회]
* 화면 : (팝업) 변경 표준DB 조회
* 기능 : 고객사 매핑을 옮겨 붙일 표준DB(구매정보)를 검색해 고른다.
*        - 상단 : 기존 표준DB 정보 1행(읽기전용 참고값). opener 가 들고 있는 값을 그대로 받는다
*        - [적용] : 체크한 1건을 이관 팝업의 [변경 표준DB 정보] 란에 반영한다
*        - 기존 구매정보코드 자기 자신은 조회 결과에서 빠진다
*        - 반환 : opener.setPopupReturn(구매정보코드, 품목명)
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
	// 기존 구매정보코드 - 참고 표시 + 조회 결과에서 제외
	String st_from_buy_info = CommonUtil.nvl((String) request.getParameter("st_from_buy_info"), "");
%>
<script type="text/javascript">
var mySheet    = new ibsheetObject();
var pagingMode = "Y";
var popupSel   = "";

var FROM_BUY_INFO = "<%=st_from_buy_info%>";

function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,	Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus"}
		,{ Align:"Center",	Width:34,	Edit:true,	EditLen:1,					Type:"DummyCheck",	Header:"",				SaveName:"SELECTED",	Sort:0}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:20,					Type:"Text",		Header:"상품정보코드",	SaveName:"CMS_CATLG_ID"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:26,	Hidden:true,	Type:"Text",		Header:"구매정보코드(키)",	SaveName:"BUY_INFO_ID"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:5,					Type:"Text",		Header:"구매정보코드",	SaveName:"BUY_INFO_SEQ"}
		,{ Align:"Left",	Width:160,	Edit:false,	EditLen:300,				Type:"Text",		Header:"품목명",			SaveName:"DESCRIPTION_LOC"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:4000,				Type:"Text",		Header:"모델번호",		SaveName:"MODEL_INFO"}
		,{ Align:"Left",	Width:150,	Edit:false,	EditLen:2000,				Type:"Text",		Header:"규격",			SaveName:"SPECIFICATION"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:200,				Type:"Text",		Header:"제조사",			SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,				Type:"Text",		Header:"원산지",			SaveName:"ORIGIN_NAME"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:8,					Type:"Text",		Header:"단위",			SaveName:"MEASURE"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:200,				Type:"Text",		Header:"협력사",			SaveName:"VENDOR_NAME"}
		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:25,					Type:"Text",		Header:"매입단가",		SaveName:"BUY_PRICE"}
		,{ Align:"Right",	Width:90,	Edit:false,	EditLen:20,					Type:"Text",		Header:"최소주문수량",	SaveName:"MIN_ORDER_QTY"}
		,{ Align:"Right",	Width:90,	Edit:false,	EditLen:20,					Type:"Text",		Header:"주문배수단위",	SaveName:"PUR_UNIT_QTY"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:20,					Type:"Text",		Header:"거래유형",		SaveName:"PROCESS_TYPE"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:20,					Type:"Text",		Header:"배송유형",		SaveName:"DELIVERY_TYPE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:40,					Type:"Text",		Header:"입고TR",			SaveName:"WAREHOUSE_NAME"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:20,	Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0, UseNoDataRow:1};
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	renderBase();
}

/* 하단 기존 표준DB 참고표 - opener(이관 팝업)가 들고 있는 값을 그대로 읽는다. */
var BASE_FIELDS = ["CMS_CATLG_ID","CATLG_SEQ","DESCRIPTION_LOC","MODEL_INFO","SPECIFICATION"
                  ,"MAKER_NAME","ORIGIN_NAME","MEASURE","VENDOR_NAME","BUY_PRICE"
                  ,"MIN_ORDER_QTY","PUR_UNIT_QTY","PROCESS_TYPE","DELIVERY_TYPE"];

function renderBase(){
	var b = {};
	try { b = opener.mdcmMapFromInfo || {}; } catch (e) { b = {}; }

	/* 구매정보코드는 BUY_INFO_ID 의 뒷자리(LPAD 된 순번)를 쓴다 - 목록·그리드와 표기를 맞춘다 */
	var code = (b.BUY_INFO_ID == null) ? FROM_BUY_INFO : b.BUY_INFO_ID;
	var seq  = (code.indexOf("-") > -1) ? code.substring(code.indexOf("-") + 1) : "";
	if (seq == "" && b.CATLG_SEQ != null) { seq = b.CATLG_SEQ; }

	for (var i = 0; i < BASE_FIELDS.length; i++) {
		var key = BASE_FIELDS[i];
		var val = (b[key] == null) ? "" : b[key];
		if (key == "CMS_CATLG_ID" && val == "") { val = (code.indexOf("-") > -1) ? code.substring(0, code.indexOf("-")) : code; }
		if (key == "CATLG_SEQ") { val = seq; }
		$("#base_" + key).text(val);
	}
}

/* 필수 조회조건 - 구매정보코드·품목명·모델번호·제조사·카테고리·상세분류 중 1개 이상.
 * 조건이 비면 CMSPRICE 전건이 후보가 된다. */
function hasCondition(){
	return ($.trim($("#st_buy_code").val())   != "")
	    || ($.trim($("#st_item_name").val())  != "")
	    || ($.trim($("#st_model_no").val())   != "")
	    || ($.trim($("#st_maker_code").val()) != "")
	    || ($.trim($("#st_sg_id_multi").val())    != "")
	    || ($.trim($("#st_categ_id_multi").val()) != "");
}

function doAction(str){
	switch(str){
		case "search":
			var itemName = $.trim($("#st_item_name").val());
			var modelNo  = $.trim($("#st_model_no").val());
			var spec     = $.trim($("#st_spec").val());
			if (itemName != "" && itemName.length < 2) { alert("품목명은 2글자 이상 입력하세요."); return; }
			if (modelNo  != "" && modelNo.length  < 2) { alert("모델번호는 2글자 이상 입력하세요."); return; }
			if (spec     != "" && spec.length     < 2) { alert("규격은 2글자 이상 입력하세요."); return; }
			if (!hasCondition()) {
				alert("구매정보코드, 품목명, 모델번호, 제조사, 카테고리, 상세분류 중 1개 이상 입력하세요.");
				return;
			}
			current_page = -1;
			kepSearch(document.searchForm, mySheet, "/mdam/getMasterMdCmCmsBuyInfoMapStdSelList.do", pagingMode);
			break;

		case "reload":	// 초기화 - kepReload 는 체크박스를 전부 켜므로 쓰지 않고 직접 비운다
			$("#st_buy_code").val("");
			$("#st_item_name").val("");
			$("#st_model_no").val("");
			$("#st_spec").val("");
			$("#st_maker_code").val("");
			$("#st_maker_name").val("");
			$("#st_sg_id_multi").val("");
			$("#st_sg_name").val("");
			$("#st_categ_id_multi").val("");
			$("#st_categ_name_multi").val("");
			$("#st_category_path").val("");
			$("#st_process_type").val("");
			$("#st_delivery_type").val("");
			$("#st_measure").val("");
			mySheet.RemoveAll();
			$("#totCnt").text("0");
			break;

		case "apply":
			doApply();
			break;
	}
}

/* [적용] - 체크한 1건을 이관 팝업의 [변경 표준DB 정보] 란에 반영한다. */
function doApply(){
	/* ⚠ FindCheckedRow 는 행번호를 '|' 로 이어 돌려준다(';' 가 아니다) - ';' 로 자르면 "1|2" 가 한 덩어리로 남아 다중선택이 그대로 통과한다. */
	var rows = mySheet.FindCheckedRow("SELECTED").split(/[|;]/);
	var picked = [];
	for (var i = 0; i < rows.length; i++) {
		if ($.trim(rows[i]) != "") { picked.push(rows[i]); }
	}

	if (picked.length == 0) { alert("적용할 표준DB를 선택해 주세요."); return; }
	if (picked.length > 1)  { alert("한 건만 선택할 수 있습니다."); return; }

	var r    = picked[0];
	var code = $.trim(mySheet.GetCellValue(r, "BUY_INFO_ID"));

	if (code == FROM_BUY_INFO) {
		alert("기존 표준DB와 동일한 구매정보코드입니다.");
		return;
	}

	var name = $.trim(mySheet.GetCellValue(r, "DESCRIPTION_LOC"));
	try { opener.setPopupReturn(code, name); } catch (e) { }
	self.close();
}

function doPop(str){
	popupSel = str;
	switch (str) {
		case "sgChoice":	// 카테고리(=SG) 복수선택 - 구매정보 목록화면과 같은 팝업
			openSearchPopup("/mdcm/showMasterMdCmCmsItemSgSelPop.do", "?st_sg_id_multi=" + $("#st_sg_id_multi").val(), "950,521,no");
			break;
		case "categChoice":	// 상세분류 복수선택 - 구매정보 목록화면과 같은 팝업
			openSearchPopup("/mdcm/showMasterMdCmCmsItemCategoryMultiSelPop.do", "?st_categ_id_multi=" + $("#st_categ_id_multi").val(), "1000,509,no");
			break;
		case "maker":		// 제조사
			openSearchPopup("/common/agentRegMakerCodePop.do", "?st_alias_yn=Y", "820,464,no");
			break;
	}
}

// 자식 팝업의 선택 반환 콜백
function setPopupReturn(value1, value2){
	if (popupSel == "sgChoice") {				// 카테고리 = SG 복수선택 ("A@B@" 한 덩어리)
		$("#st_sg_id_multi").val(value1);
		$("#st_sg_name").val(kepMultiName(value2, "@"));	// 표시는 "○○ 외 N건"
	} else if (popupSel == "categChoice") {		// 상세분류 복수선택 ("A@B@" 한 덩어리)
		$("#st_categ_id_multi").val(value1);
		$("#st_categ_name_multi").val(value2);			// 원본 명칭 - 팝업 재진입 시 바구니 복원용
		$("#st_category_path").val(kepMultiName(value2, "@"));	// 표시는 "○○ 외 N건"
	} else if (popupSel == "maker") {
		$("#st_maker_code").val(value1);
		$("#st_maker_name").val(value2);
	}
}

/* 검색결과 건수 - 페이징 바의 [총 N건] 과 같은 값(전체 건수)을 쓴다 */
function refreshTotCnt(){
	var n = 0;
	try { n = mySheet.GetTotalRows(); } catch (e) { n = 0; }
	$("#totCnt").text(n);
}

//그리드 표시후 처리
function mySheet_OnLoadData(DATA){ return DATA; }

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode){
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if(msg != ""){ alert(msg); }
	refreshTotCnt();
}

/* 페이징 바(ibsheetinfo.js) 가 전역으로 호출한다 - 없으면 페이지 이동이 에러로 끝난다 */
function pageSearch(param){
	current_page = param.page;
	kepSearch(document.searchForm, mySheet, "/mdam/getMasterMdCmCmsBuyInfoMapStdSelList.do?page=" + current_page, pagingMode);
}
</script>

<style>
.PopGuide{ display:block; margin:8px 0 6px; color:#444; font-size:13px; }
/* 조회버튼·지우개(각 24px)가 붙는 칸 - 입력폭을 아이콘 자리만큼 빼서 다음 줄로 밀리지 않게 한다 */
#cont_searchA td.hasBtn2{ white-space:nowrap; }
#cont_searchA td.hasBtn2 input{ width:calc(100% - 60px); }
.resultCnt{ display:block; margin:10px 2px 4px; font-size:12px; color:#333; }
.resultCnt b{ color:#c0392b; }
.baseTitle{ font-weight:bold; color:#3c639c; margin:14px 0 4px 2px; }
/* 하단 참고표는 14컬럼 - 컬럼명이 두 줄로 접히지 않게 한다 */
#popContainer .cont_t_list06 th{ white-space:nowrap; padding:5px 6px; }
#popContainer .cont_t_list06 td{ padding:5px 6px; }
</style>

<body onLoad="kep_onload_view()">
	<form name="searchForm" id="searchForm" method="post">
		<input type="hidden" id="st_exclude"     name="st_exclude"     value="<%=st_from_buy_info%>">
		<input type="hidden" id="st_maker_code"  name="st_maker_code"  value="">
		<input type="hidden" id="st_sg_id_multi"    name="st_sg_id_multi"    value="">
		<input type="hidden" id="st_categ_id_multi" name="st_categ_id_multi" value="">
		<!-- 팝업 재진입 시 바구니 명칭 복원용(원본 '명칭@명칭@'). 조회에는 쓰지 않는다. -->
		<input type="hidden" id="st_categ_name_multi" name="st_categ_name_multi" value="">
		<input type="hidden" id="s_SAVENAME" name="s_SAVENAME" />
		<input type="hidden" id="pageflag" name="pageflag" value="1" />
		<input type="hidden" name="onepagerow" id="onepagerow" value="100" />

	<div id="popWrapper" style="width:1400px;">
		<div id="popHeader">
			<h1 class="title">변경 표준DB 조회</h1>
			<p class="popClose"><a href="javascript:self.close()">
				<img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
			</a></p>
		</div>

		<!--팝업내용입니다-->
		<div id="popContainer">

			<!--조회영역-->
			<div class="fr">
				<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
				<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span>
			</div>
			<br>

			<div id="cont_searchA" class="mt10">
				<table class="cont_t_list01" style="width:100%">
				<caption>변경 표준DB 검색</caption>
				<colgroup>
					<col width="8%" /><col width="12%" /><col width="8%" /><col width="12%" /><col width="8%" /><col width="12%" />
					<col width="8%" /><col width="12%" /><col width="8%" /><col width="*" />
				</colgroup>
				<tbody>
				<tr>
					<td>표준DB 코드</td>
					<td><input type="text" id="st_buy_code" name="st_buy_code" style="width:92%" value="" onkeydown="kepEnter()" class="input_type_text"></td>
					<td>품목명</td>
					<td><input type="text" id="st_item_name" name="st_item_name" style="width:92%" value="" onkeydown="kepEnter()" class="input_type_text"></td>
					<td>모델번호</td>
					<td><input type="text" id="st_model_no" name="st_model_no" style="width:92%" value="" onkeydown="kepEnter()" class="input_type_text"></td>
					<td>규격</td>
					<td><input type="text" id="st_spec" name="st_spec" style="width:92%" value="" onkeydown="kepEnter()" class="input_type_text"></td>
					<td>제조사</td>
					<td class="hasBtn2">
						<input type="text" id="st_maker_name" name="st_maker_name" value="" readonly class="input_type_text">
						<a href="javascript:doPop('maker');"><img src="/resources/images/btn_search03.gif" alt="제조사 조회" align="absmiddle"></a>
						<a href="javascript:kepEraser('st_maker_code','st_maker_name');"><img src="/resources/images/btn_eraser2.gif" alt="제조사 지우기" align="absmiddle"></a>
					</td>
				</tr>
				<tr>
					<td>카테고리</td>
					<td class="hasBtn2">
						<input type="text" id="st_sg_name" name="st_sg_name" value="" readonly class="input_type_text">
						<a href="javascript:doPop('sgChoice');"><img src="/resources/images/btn_search03.gif" alt="카테고리 조회" align="absmiddle"></a>
						<a href="javascript:kepEraser('st_sg_id_multi','st_sg_name');"><img src="/resources/images/btn_eraser2.gif" alt="카테고리 지우기" align="absmiddle"></a>
					</td>
					<td>상세분류</td>
					<td class="hasBtn2">
						<input type="text" id="st_category_path" name="st_category_path" value="" readonly class="input_type_text">
						<a href="javascript:doPop('categChoice');"><img src="/resources/images/btn_search03.gif" alt="상세분류 조회" align="absmiddle"></a>
						<a href="javascript:kepEraser2('st_categ_id_multi','st_categ_name_multi','st_category_path');"><img src="/resources/images/btn_eraser2.gif" alt="상세분류 지우기" align="absmiddle"></a>
					</td>
					<td>거래유형</td>
					<td>
						<!-- ICOMCOD1 M034 (FLAG='Y') 코드 그대로. SQL 의 DECODE 는 이 값들을 그대로 통과시킨다 -->
						<select id="st_process_type" name="st_process_type" style="width:92%">
							<option value="">전체</option>
							<option value="0">직납</option>
							<option value="1">재고</option>
							<option value="2">TR</option>
							<option value="3">VMI</option>
						</select>
					</td>
					<td>배송유형</td>
					<td>
						<!-- ⚠ ALL 은 서버가 통과시킨다(값으로 비교하면 0건이 된다) -->
						<select id="st_delivery_type" name="st_delivery_type" style="width:92%">
							<option value="">전체</option>
							<option value="PCL">택배</option>
							<option value="CAR">자차</option>
						</select>
					</td>
					<td>단위</td>
					<td>
						<select id="st_measure" name="st_measure" style="width:92%">
							<%=CommonUtil.getCodeComboQueryIdList("getUnitMeasureInfo", "ALL", "") %>
						</select>
					</td>
				</tr>
				</tbody>
				</table>
			</div>

			<span class="PopGuide">※ 이관할 표준DB를 한 건만 선택해 [적용] 하세요. 기존 표준DB코드는 목록에서 제외됩니다.</span>

			<!--검색결과-->
			<span class="resultCnt">검색결과 <b id="totCnt">0</b>건</span>
			<div class="ib_product" style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "100%", "320px");
				</script>
			</div>

			<div class="btnArea mt05" style="text-align:right; padding:10px 0;">
				<span class="btn_02"><a href="javascript:doAction('apply');">적용</a></span>
			</div>

			<!--기존 표준DB 정보 (단순 참고값)-->
			<p class="baseTitle">기존 표준DB 정보</p>
			<table class="cont_t_list06" summary="기존 표준DB 정보" style="width:100%;">
				<caption>기존 표준DB 정보</caption>
				<thead>
					<tr>
						<th scope="col" class="center">상품정보코드</th>
						<th scope="col" class="center">구매정보코드</th>
						<th scope="col" class="center">품목명</th>
						<th scope="col" class="center">모델번호</th>
						<th scope="col" class="center">규격</th>
						<th scope="col" class="center">제조사</th>
						<th scope="col" class="center">원산지</th>
						<th scope="col" class="center">단위</th>
						<th scope="col" class="center">협력사</th>
						<th scope="col" class="center">매입단가</th>
						<th scope="col" class="center">최소주문수량</th>
						<th scope="col" class="center">주문배수단위</th>
						<th scope="col" class="center">거래유형</th>
						<th scope="col" class="center">배송유형</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="center" id="base_CMS_CATLG_ID"></td>
						<td class="center" id="base_CATLG_SEQ"></td>
						<td class="left" id="base_DESCRIPTION_LOC"></td>
						<td class="left" id="base_MODEL_INFO"></td>
						<td class="left" id="base_SPECIFICATION"></td>
						<td class="left" id="base_MAKER_NAME"></td>
						<td class="center" id="base_ORIGIN_NAME"></td>
						<td class="center" id="base_MEASURE"></td>
						<td class="left" id="base_VENDOR_NAME"></td>
						<td class="right" id="base_BUY_PRICE"></td>
						<td class="right" id="base_MIN_ORDER_QTY"></td>
						<td class="right" id="base_PUR_UNIT_QTY"></td>
						<td class="center" id="base_PROCESS_TYPE"></td>
						<td class="center" id="base_DELIVERY_TYPE"></td>
					</tr>
				</tbody>
			</table>
			<br>
		</div>
	</div>
	</form>
</body>
</html>
