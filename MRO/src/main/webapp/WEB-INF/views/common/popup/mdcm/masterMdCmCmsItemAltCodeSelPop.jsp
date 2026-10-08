<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>상품정보 조회 및 관리 > 상세 팝업 > [요청] > 상태변경 팝업 > 대체코드
* 화면 : (팝업) 대체코드 조회
* 기능 : 상품상태를 [미사용 / 중복존재] 로 바꿀 때 대체할 상품정보코드를 검색해 고른다.
*        - 상단 : 기존 상품 정보 1행(읽기전용)
*        - 조회조건·검증은 바깥 화면(상품정보 조회 및 관리)의 규칙을 그대로 따른다
*          (필수조건 4택1 · 품목명/모델번호/규격 2글자 · 카테고리/상세분류/제조사/코드대량입력 팝업)
*        - [적용] 불가 3조건 : 1) 기존과 동일코드 2) 상품상태 미사용 3) 일회성 상품
*          그리드에는 보이고 [적용] 이 막는다
*        - 반환 : opener.setPopupReturn(상품정보코드, 품목명)
* 담당자 : 홍준우
* 착수일 : 2026-09-09
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.Map"%>
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

	@SuppressWarnings("unchecked")
	Map<String,String> _base = (Map<String,String>) request.getAttribute("data");

	String _baseId    = (_base == null) ? st_catlg_id : CommonUtil.nvl(_base.get("CMS_CATLG_ID"), "");
	String _baseName  = (_base == null) ? "" : CommonUtil.nvl(_base.get("DESCRIPTION_LOC"), "");
	String _baseModel = (_base == null) ? "" : CommonUtil.nvl(_base.get("MODEL_INFO"), "");
	String _baseSpec  = (_base == null) ? "" : CommonUtil.nvl(_base.get("SPECIFICATION"), "");
	String _baseMaker = (_base == null) ? "" : CommonUtil.nvl(_base.get("MAKER_NAME"), "");
	String _baseOrgn  = (_base == null) ? "" : CommonUtil.nvl(_base.get("ORIGIN_CODE_NAME"), "");
	String _baseUnit  = (_base == null) ? "" : CommonUtil.nvl(_base.get("ORDER_MEASURE"), "");
%>
<script type="text/javascript">
var mySheet    = new ibsheetObject();
var pagingMode = "Y";	// Y: 번호 페이징
var popupSel   = "";	// 자식 팝업 반환값 분기용

var BASE_ID = "<%=_baseId%>";	// 기존 상품정보코드 - 적용 불가 조건 1)

function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,	Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus"}
		,{ Align:"Center",	Width:34,	Edit:true,	EditLen:1,					Type:"DummyCheck",	Header:"",				SaveName:"SELECTED",	Sort:0}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:20,					Type:"Text",		Header:"상품정보코드",	SaveName:"CMS_CATLG_ID"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:10,					Type:"Text",		Header:"상품상태",		SaveName:"STATUS_NM"}
		,{ Align:"Left",	Width:160,	Edit:false,	EditLen:300,				Type:"Text",		Header:"품목명",			SaveName:"DESCRIPTION_LOC"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:4000,				Type:"Text",		Header:"모델번호",		SaveName:"MODEL_INFO"}
		,{ Align:"Left",	Width:160,	Edit:false,	EditLen:2000,				Type:"Text",		Header:"규격",			SaveName:"SPECIFICATION"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:200,				Type:"Text",		Header:"제조사",			SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,				Type:"Text",		Header:"원산지",			SaveName:"ORIGIN_CODE_NAME"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:8,					Type:"Text",		Header:"단위",			SaveName:"ORDER_MEASURE"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:10,					Type:"Text",		Header:"일회성구분",		SaveName:"ONETIME_NM"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:1,	Hidden:true,	Type:"Text",		Header:"일회성원값",		SaveName:"ONETIME_YN"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:2,	Hidden:true,	Type:"Text",		Header:"상품상태원값",	SaveName:"STATUS"}
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0, UseNoDataRow:1};
	IBS_InitSheet(mySheet, initsheet, pagingMode);
}

/* 필수 조회조건 - 상품정보코드 · 품목명 · 모델번호 · 제조사 중 1개 이상.
 * 바깥 화면(상품정보 조회 및 관리)의 사업팀 규칙과 같은 축이다. 여기는 기간 조건이 없어
 * 조건이 비면 233만 행이 후보가 되므로 예외 없이 강제한다.
 * 상품정보코드는 대량입력(hidden) 쪽으로만 들어올 수 있어 둘 다 본다. */
function hasCondition(){
	return ($.trim($("#st_cmscatlg").val())       != "")
	    || ($.trim($("#st_cmscatlg_multi").val()) != "")
	    || ($.trim($("#st_item_name").val())      != "")
	    || ($.trim($("#st_model_info").val())     != "")
	    || ($.trim($("#st_maker_code").val())     != "");
}

function doAction(str){
	switch(str){
		case "search":
			// 품목명/모델번호/규격은 각각 2글자 이상 입력 시에만 조회 (바깥 화면과 같은 규칙)
			var itemName      = $.trim($("#st_item_name").val());
			var modelInfo     = $.trim($("#st_model_info").val());
			var specification = $.trim($("#st_specification").val());
			if (itemName != "" && itemName.length < 2) {
				alert("품목명은 2글자 이상 입력하세요.");
				return;
			}
			if (modelInfo != "" && modelInfo.length < 2) {
				alert("모델번호는 2글자 이상 입력하세요.");
				return;
			}
			if (specification != "" && specification.length < 2) {
				alert("규격은 2글자 이상 입력하세요.");
				return;
			}
			if (!hasCondition()) {
				alert("상품정보코드, 품목명, 모델번호, 제조사 중 1개 이상 입력하세요.");
				return;
			}
			current_page = -1;
			kepSearch(document.searchForm, mySheet, "/mdcm/getMasterMdCmCmsItemAltCodeSelPopList.do", pagingMode);
			break;

		case "reload":	// 초기화 - kepReload 는 체크박스를 전부 켜므로 쓰지 않고 직접 비운다
			$("#st_cmscatlg").val("");
			$("#st_cmscatlg_multi").val("");
			$("#st_item_name").val("");
			$("#st_model_info").val("");
			$("#st_specification").val("");
			$("#st_maker_code").val("");
			$("#st_maker_name").val("");
			$("#st_order_measure").val("");
			$("#st_sg_id_multi").val("");
			$("#st_sg_name").val("");
			$("#st_categ_id_multi").val("");
			$("#st_categ_name_multi").val("");
			$("#st_category_path").val("");
			mySheet.RemoveAll();
			break;

		case "apply":
			doApply();
			break;
	}
}

/* 검색조건 팝업 호출 - 바깥 화면이 쓰는 팝업을 그대로 재사용한다.
 * ⚠ 팝업 위의 팝업이라 자식의 opener 는 이 창이다. 자식이 부르는 setPopupReturn 은 아래 것이고,
 *   이 창이 상태변경 팝업으로 결과를 올릴 때 쓰는 것은 opener.setPopupReturn 이다(서로 다른 창의 함수). */
function doPop(str){
	popupSel = str;
	switch (str) {
		case "categChoice":	// 상세분류 복수선택
			openSearchPopup("/mdcm/showMasterMdCmCmsItemCategoryMultiSelPop.do", "?st_categ_id_multi=" + $("#st_categ_id_multi").val(), "1000,509,no");
			break;
		case "sgChoice":	// 카테고리(=SG) 복수선택
			openSearchPopup("/mdcm/showMasterMdCmCmsItemSgSelPop.do", "?st_sg_id_multi=" + $("#st_sg_id_multi").val(), "950,521,no");
			break;
		case "maker":		// 제조사 (유사명 포함 컬럼 5개라 700px에서는 헤더가 줄바꿈된다)
			openSearchPopup("/common/agentRegMakerCodePop.do", "?st_alias_yn=Y", "820,464,no");
			break;
		case "catlgMulti":	// 상품정보코드 대량입력
			openSearchPopup("/common/multiSearchCondPop.do", "?header_text=상품정보코드", "300,371,no");
			break;
	}
}

// 자식 팝업의 선택 반환 콜백 (popupSel 로 분기 - 바깥 화면과 같은 규약)
function setPopupReturn(value1, value2){
	if (popupSel == "categChoice") {					// 상세분류 복수선택 ("A@B@" 한 덩어리)
		$("#st_categ_id_multi").val(value1);
		$("#st_categ_name_multi").val(value2);			// 원본 명칭 - 팝업 재진입 시 바구니 복원용
		$("#st_category_path").val(kepMultiName(value2, "@"));
	} else if (popupSel == "sgChoice") {				// 카테고리 = SG 복수선택
		$("#st_sg_id_multi").val(value1);
		$("#st_sg_name").val(kepMultiName(value2, "@"));
	} else if (popupSel == "maker") {					// 제조사 (maker_code, maker_name)
		$("#st_maker_code").val(value1);
		$("#st_maker_name").val(value2);
	} else if (popupSel == "catlgMulti") {				// 상품정보코드 대량입력
		var codes = kepCleanMultiCode(value1);
		$("#st_cmscatlg_multi").val(codes);
		$("#st_cmscatlg").val(kepMultiName(codes, "@"));
	}
}

/* [적용] - 불가 3조건을 여기서 막는다. */
function doApply(){
	var checked = mySheet.FindCheckedRow("SELECTED");
	if (checked == "") {
		alert("대체코드로 사용할 상품을 선택하세요.");
		return;
	}

	var rows = checked.split("|");
	if (rows.length > 1) {
		alert("대체코드는 1건만 선택할 수 있습니다.");
		return;
	}

	var row     = rows[0];
	var code    = $.trim(mySheet.GetCellValue(row, "CMS_CATLG_ID"));
	var name    = $.trim(mySheet.GetCellValue(row, "DESCRIPTION_LOC"));
	var status  = $.trim(mySheet.GetCellValue(row, "STATUS"));
	var onetime = $.trim(mySheet.GetCellValue(row, "ONETIME_YN"));

	// 1) 기존과 동일코드
	if (code == BASE_ID) {
		alert("대체코드는 기존 상품정보코드와 같을 수 없습니다.");
		return;
	}
	// 2) 상품상태 미사용
	if (status == "D") {
		alert("상품상태가 [미사용] 인 상품은 대체코드로 사용할 수 없습니다.");
		return;
	}
	// 3) 일회성 상품
	if (onetime == "Y") {
		alert("일회성 상품은 대체코드로 사용할 수 없습니다.");
		return;
	}

	opener.setPopupReturn(code, name);
	self.close();
}

/* 체크는 1건만 - 새로 체크한 행만 남기고 나머지를 끈다.
 * ⚠ 되돌리는 SetCellValue 의 RaiseFlag 는 0 이어야 한다. 1 이면 이 핸들러가 다시 불려 재귀한다. */
function mySheet_OnChange(Row, Col, Value){
	if (mySheet.ColSaveName(Col) != "SELECTED") { return; }
	if (Value != "1") { return; }

	var last = mySheet.LastRow();
	for (var i = mySheet.HeaderRows(); i <= last; i++) {
		if (i != Row) { mySheet.SetCellValue(i, "SELECTED", "0", 0); }
	}
}

function mySheet_OnLoadData(DATA){ return DATA; }

function mySheet_OnSearchEnd(code, msg, stCode){
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if(msg != ""){ alert(msg); }
}

function pageSearch(param){
	current_page = param.page;
	kepSearch(document.searchForm, mySheet, "/mdcm/getMasterMdCmCmsItemAltCodeSelPopList.do?page="+current_page, pagingMode);
}
</script>

<style>
.baseTitle{ display:block; font-weight:bold; color:#003399; margin:8px 0 4px; }
</style>

<body onLoad="kep_onload_view()">
	<form name="searchForm" id="searchForm" method="post">
		<input type="hidden" id="s_SAVENAME" name="s_SAVENAME" />
		<input type="hidden" id="pageflag" name="pageflag" value="1" />
		<input type="hidden" name="onepagerow" id="onepagerow" value="100" />

	<div id="popWrapper" style="width:1100px; max-width:calc(100% - 8px);">
		<div id="popHeader">
			<h1 class="title">대체코드 조회</h1>
			<p class="popClose"><a href="javascript:self.close()">
				<img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
			</a></p>
		</div>

		<!--팝업내용입니다-->
		<div id="popContainer">

			<!--기존 상품 정보 (읽기전용)-->
			<span class="baseTitle">기존 상품 정보</span>
			<table class="cont_t_list02" summary="기존 상품 정보" style="width:100%">
				<caption>기존 상품 정보</caption>
				<colgroup>
					<col width="12%" /><col width="20%" /><col width="14%" /><col width="20%" />
					<col width="12%" /><col width="12%" /><col width="*" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">상품정보코드</th>
						<th scope="col">품목명</th>
						<th scope="col">모델번호</th>
						<th scope="col">규격</th>
						<th scope="col">제조사</th>
						<th scope="col">원산지</th>
						<th scope="col">단위</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="center"><%=_baseId%></td>
						<td class="left"><%=_baseName%></td>
						<td class="left"><%=_baseModel%></td>
						<td class="left"><%=_baseSpec%></td>
						<td class="left"><%=_baseMaker%></td>
						<td class="center"><%=_baseOrgn%></td>
						<td class="center"><%=_baseUnit%></td>
					</tr>
				</tbody>
			</table>

			<div id="searchBtnA02">
				<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span>
				<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
			</div>

			<!--조회영역-->
			<div id="cont_searchA">
				<table class="cont_t_list01" style="width:100%">
					<caption>대체코드 검색</caption>
					<colgroup>
						<col width="9%" /><col width="16%" />
						<col width="9%" /><col width="16%" />
						<col width="9%" /><col width="16%" />
						<col width="9%" /><col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th>상품정보코드</th>
							<td>
								<!-- 대문자화는 kepToUpper - 팝업에는 common.js 가 없어 ToUpper 가 죽는다 -->
								<input type="text" class="input_type_text" id="st_cmscatlg" name="st_cmscatlg" style="width:60%;" value="" onkeydown="kepEnter()" onKeyUp="kepToUpper('st_cmscatlg');">
								<input type="hidden" name="st_cmscatlg_multi" id="st_cmscatlg_multi" value="">
								<a href="javascript:doPop('catlgMulti');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_cmscatlg_multi','st_cmscatlg');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>품목명</th>
							<td><input type="text" class="input_type_text" id="st_item_name" name="st_item_name" style="width:90%;" value="" onkeydown="kepEnter()"></td>
							<th>모델번호</th>
							<td><input type="text" class="input_type_text" id="st_model_info" name="st_model_info" style="width:90%;" value="" onkeydown="kepEnter()"></td>
							<th>규격</th>
							<td><input type="text" class="input_type_text" id="st_specification" name="st_specification" style="width:90%;" value="" onkeydown="kepEnter()"></td>
						</tr>
						<tr>
							<th>카테고리</th>
							<td>
								<input type="text" class="input_type_text" name="st_sg_name" id="st_sg_name" style="width:60%;" value="" readonly>
								<input type="hidden" name="st_sg_id_multi" id="st_sg_id_multi" value="">
								<a href="javascript:doPop('sgChoice');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_sg_id_multi','st_sg_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>상세분류</th>
							<td>
								<input type="text" class="input_type_text" name="st_category_path" id="st_category_path" style="width:60%;" value="" readonly>
								<input type="hidden" name="st_categ_id_multi" id="st_categ_id_multi" value="">
								<!-- 팝업 재진입 시 바구니 명칭 복원용(원본 '명칭@명칭@'). 조회에는 쓰지 않는다. -->
								<input type="hidden" name="st_categ_name_multi" id="st_categ_name_multi" value="">
								<a href="javascript:doPop('categChoice');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser2('st_categ_id_multi','st_categ_name_multi','st_category_path');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>제조사</th>
							<td>
								<input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:60%;" value="" readonly>
								<input type="hidden" name="st_maker_code" id="st_maker_code" value="">
								<a href="javascript:doPop('maker');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_maker_code','st_maker_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>단위</th>
							<td><input type="text" class="input_type_text" id="st_order_measure" name="st_order_measure" style="width:90%;" value="" onkeydown="kepEnter()"></td>
						</tr>
					</tbody>
				</table>
			</div>

			<!--검색결과 그리드-->
			<div class="mt10">
				<div class="ib_product" style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "100%", "280px");
					</script>
				</div>
			</div>

			<!--하단 버튼-->
			<div class="btnArea mt05" style="text-align:center; padding:10px 0;">
				<span class="btn_02 mr04"><a href="javascript:doAction('apply');">적용</a></span>
				<span class="btn_02"><a href="javascript:self.close();">닫기</a></span>
			</div>
			<br>
		</div>
	</div>
	</form>
</body>
</html>
