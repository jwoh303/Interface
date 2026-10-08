<%--
**********************************************
* 메뉴 : 구매대행>견적관리>데일리소싱(DB관리)

* 화면 : 데일리소싱(DB관리)
* 기능 : DB관리파트 중복코드검증 목록 (견적TF 2차)
* 프로그램 ID :
* 담당자 : 홍준우
* 착수일 : 2026-09-30
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	String st_user_id = _sessionInfo.getUserId();
%>

<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<script src="/resources/js/jquery.multiple.select.js"></script>
<script src="/resources/js/common.js"></script>
<style>
.btnArea02 { overflow:hidden; }
.tool_box { margin:0 0 5px 0; padding:4px 8px; background:#f7f7f7; border:1px solid #d5d5d5; }
.tool_box .btnArea02.sort-line { display:flex; align-items:center; justify-content:space-between; height:auto; }
.tool_box .sort-line > span { float:none; display:flex; align-items:center; gap:4px; }
.tool_box .sort-line img, .tool_box .sort-line select { vertical-align:middle; }
#cont_searchA td { white-space:nowrap; }
#cont_searchA .ms-drop { width:auto; min-width:100%; white-space:nowrap; }
#st_date_type { width:95%; height:25px; font-family:돋움; font-size:12px; }
#st_status { width:190px; height:25px; font-family:돋움; font-size:12px; }
</style>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N";
var popupSel = "";
var current_page = -1;
var MAX_DETAIL_CNT = 50;

function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,	Hidden:true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,	Edit:true,	EditLen:100,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
		,{ Align:"Left",	Width:160,	Edit:false,	EditLen:100,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME",	FontColor:"#1e90ff"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER"}
		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:100,	Type:"Text",	Header:"견적번호",	SaveName:"QUOTATION_NO",	FontColor:"#1e90ff"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Type:"Text",	Header:"순번",	SaveName:"QUOTATION_SEQ"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"차수",	SaveName:"REVISION"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Type:"Text",	Header:"견적Key",	SaveName:"QUOTATION_KEY",	FontColor:"#1e90ff"}
		,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Type:"Text",	Header:"진행상태",	SaveName:"SOURCING_STATUS"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"진행상태코드",	SaveName:"SOURCING_STATUS_CODE"}
		,{ Align:"Center",	Width:20,	Edit:false,	EditLen:100,	Type:"Image",	Header:"품목코드",	SaveName:"ITEM_GUBUN"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Left",	Width:220,	Edit:false,	EditLen:100,	Type:"Text",	Header:"상세분류",	SaveName:"CATEG_PATH"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",	Header:"카테고리",	SaveName:"SG_NAME"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",	Header:"모델번호",	SaveName:"MAKER_PART_NO"}
		,{ Align:"Left",	Width:220,	Edit:false,	EditLen:2000,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NAME"}
		,{ Align:"Right",	Width:55,	Edit:false,	EditLen:100,	Type:"Float",	Header:"수량",	SaveName:"ITEM_QTY"}
		,{ Align:"Center",	Width:45,	Edit:false,	EditLen:100,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Type:"Text",	Header:"요청자",	SaveName:"BTOA_USER_NAME",	FontColor:"#1e90ff"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"URL",	SaveName:"REMARK_URL"}
		,{ Align:"Left",	Width:180,	Edit:false,	EditLen:4000,	Type:"Text",	Header:"고객사비고",	SaveName:"BTOA_REMARK"}
		,{ Align:"Center",	Width:55,	Edit:false,	EditLen:100,	Type:"Image",	Header:"첨부(B)",	SaveName:"IMAGE_KEY_IMG"}
		,{ Align:"Left",	Width:140,	Edit:false,	EditLen:100,	Type:"Text",	Header:"지정협력사(B)",	SaveName:"BUYER_ASSIGN_AGENT_NAME"}
		,{ Align:"Center",	Width:45,	Edit:false,	EditLen:100,	Type:"DummyCheck",	Header:"선입고",	SaveName:"PRE_GR_FLAG"}
		,{ Align:"Left",	Width:140,	Edit:false,	EditLen:100,	Type:"Text",	Header:"지정협력사(운)",	SaveName:"ASSIGN_AGENT_NAME"}
		,{ Align:"Center",	Width:55,	Edit:false,	EditLen:100,	Type:"Image",	Header:"운영\n특이사항",	SaveName:"NOTE_MNG_IMG"}
		,{ Align:"Left",	Width:180,	Edit:false,	EditLen:4000,	Type:"Text",	Header:"운영사비고",	SaveName:"ATOA_REMARK"}
		,{ Align:"Left",	Width:160,	Edit:false,	EditLen:4000,	Type:"Text",	Header:"견적지연사유",	SaveName:"DELAY_REASON"}
		,{ Align:"Center",	Width:55,	Edit:false,	EditLen:100,	Type:"Text",	Header:"재진행\n요청",	SaveName:"REPROC_REQ_YN"}
		,{ Align:"Center",	Width:115,	Edit:false,	EditLen:100,	Type:"Text",	Header:"재진행\n요청일시",	SaveName:"REPROC_REQ_DATM"}
		,{ Align:"Center",	Width:85,	Edit:false,	EditLen:100,	Type:"Text",	Header:"DB관리담당자",	SaveName:"DB_MNG_USER_NM"}
		,{ Align:"Center",	Width:75,	Edit:false,	EditLen:100,	Type:"Text",	Header:"구매담당자",	SaveName:"SM_MNG_NM"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Type:"Text",	Header:"매입가제출자",	SaveName:"STOA_SUBMIT_USER_NM"}
		,{ Align:"Center",	Width:115,	Edit:false,	EditLen:100,	Type:"Text",	Header:"매입가제출일시",	SaveName:"STOA_SUBMIT_DATM"}
		,{ Align:"Center",	Width:85,	Edit:false,	EditLen:100,	Type:"Date",	Header:"견적의뢰일",	SaveName:"BTOA_DATE"}
		,{ Align:"Center",	Width:85,	Edit:false,	EditLen:100,	Type:"Date",	Header:"회신요청일",	SaveName:"BTOA_END_DATE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"사업팀",	SaveName:"BIZ_TEAM_NM"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"요청자ID",	SaveName:"BTOA_USER_ID"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"첨부키",	SaveName:"IMAGE_KEY"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"견적지연사유코드",	SaveName:"DELAY_REASON_CODE"}
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	initsheet.HeaderMode = {Sort:1, ColMove:0, ColResize:1, HeaderCheck:1};
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetImageList(0, "/resources/images/icon_y.gif");
	mySheet.SetImageList(1, "/resources/images/icon_r.gif");
	mySheet.SetImageList(2, "/resources/images/disk_off.gif");
	mySheet.SetImageList(3, "/resources/images/disk_on.gif");
	mySheet.SetImageList(4, "/resources/images/rd_pin.gif");
	mySheet.SetImageList(5, "/resources/images/but_icon02.gif");
	mySheet.SetImageList(6, "/resources/images/but_icon01.gif");

	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val( kepToMonthAdd("1","M") );
	$("#st_to_date").val( kepGetNowTimeStr("YYYYMMDD","/") );

	$("#st_biz_team_spare").multipleSelect({
		placeholder : "전체",
		selectAllText : "전체선택",
		maxHeight : 300,
		onClose : function() {
			$("#st_biz_team").val($("#st_biz_team_spare").multipleSelect("getSelects"));
		}
	});
}

function doAction(str) {
	switch (str) {
	case "search":
		if ($("#st_period_ignore").is(":checked")) {
			if ($.trim($("#st_quotation_no").val()) == "" && $.trim($("#st_quotation_key").val()) == "") {
				alert("기간무시 조회는 견적번호, 견적Key 중 하나를 입력해야 합니다.");
				return;
			}
		} else {
			if (kep_dateSearchCheck($("#st_from_date").val(), $("#st_to_date").val()) == false) return;
			if (kepGetDateDiff('st_from_date', 'st_to_date', 'D') > 93) {
				alert("조회기간을 3개월 단위로 조회가 가능합니다.");
				return;
			}
		}
		current_page = -1;
		kepSearch(document.searchCondition, mySheet, "/mprq/searchMasterMpRqDailySourcingDbManageList.do", pagingMode);
		break;

	case "reload":
		kepReload('searchCondition');
		$("#st_buyer_code").val("");
		$("#st_buyer_name").val("");
		$("#st_quotation_no_multi").val("");
		$("#st_quotation_key_multi").val("");
		$("#st_maker_code").val("");
		$("#st_maker_name").val("");
		$("#st_from_date").val( kepToMonthAdd("1","M") );
		$("#st_to_date").val( kepGetNowTimeStr("YYYYMMDD","/") );
		$("#st_period_ignore").prop("checked", false);
		$("#st_status").val("");
		init_multiCombo("st_biz_team");
		$("#st_biz_team").val("");
		mySheet.RemoveAll();
		break;

	default:
		kepNotYet();
		break;
	}
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if (!checkedSession(stCode)) return;
	makePageIndex2(mySheet, (current_page == -1) ? 1 : current_page, document.searchCondition.onepagerow.value);
	if (msg != "") alert(msg);
}

function mySheet_OnClick(Row, Col, Value) {
	if (Row < mySheet.HeaderRows() || Value == "") return;
	switch (mySheet.ColSaveName(Col)) {
		case "QUOTATION_KEY":
			var rows = kepSheetCheckedRows(mySheet, "SELECTED");
			if ($.inArray(Row, rows) < 0) {
				rows.push(Row);
				rows.sort(function(a, b) { return a - b; });
			}
			openDetailPop(rows, $.inArray(Row, rows));
			break;
		case "BUYER_NAME":
			openSearchPopup("/mdct/showMasterMdCtBuyerJoinAlterRequestApprovalPop.do", "?com_code=" + mySheet.GetCellValue(Row, "BUYER"), "900,700,no");
			break;
		case "QUOTATION_NO":
			popupSel = "quotationReDetailPop";
			openSearchPopup("/common/mprq/quotationReDetailPop.do", "?st_buyer=" + mySheet.GetCellValue(Row, "BUYER") + "&st_quotation_no=" + Value + "&st_revision=" + mySheet.GetCellValue(Row, "REVISION"), "1020,500,no");
			break;
		case "BTOA_USER_NAME":
			var id = mySheet.GetCellValue(Row, "BTOA_USER_ID");
			if (id == "") {
				alert("요청자ID 정보가 없습니다.");
				return;
			}
			openSearchPopup("/common/userDisplayPop.do", "?user_id=" + id, "800,500,no");
			break;
	}
}

function openDetailPop(rows, idx) {
	var x = screen.availLeft || 0;
	var y = screen.availTop || 0;
	var w = screen.availWidth;
	var h = screen.availHeight;
	if (rows.length > MAX_DETAIL_CNT) {
		alert("상세는 한 번에 " + MAX_DETAIL_CNT + "건까지 열 수 있습니다.");
		return;
	}
	var keys = [];
	for (var i = 0; i < rows.length; i++) {
		var r = rows[i];
		keys.push([mySheet.GetCellValue(r, "BUYER"), mySheet.GetCellValue(r, "QUOTATION_NO"), mySheet.GetCellValue(r, "QUOTATION_SEQ"), mySheet.GetCellValue(r, "REVISION")].join("^"));
	}
	var popName = "showMasterMpRqDailySourcingDbManageDetailPop";
	var pop = window.open("", popName,
		"left=" + x + ",top=" + y + ",width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=0,location=0,titlebar=0,menubar=0");
	if (pop == null) return;
	var $f = $("<form>", {method: "post", action: "/mprq/showMasterMpRqDailySourcingDbManageDetailPop.do", target: popName}).css("display", "none");
	$f.append($("<input>", {type: "hidden", name: "nav_keys", value: keys.join(",")}));
	$f.append($("<input>", {type: "hidden", name: "nav_idx", value: idx}));
	$f.appendTo("body").submit().remove();
	try {
		pop.moveTo(x, y);
		pop.resizeTo(w, h);
	} catch (e) {}
	pop.focus();
}

function pageSearch(param) {
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/mprq/searchMasterMpRqDailySourcingDbManageList.do?page=" + current_page, pagingMode);
}

function doPop(str) {
	popupSel = str;
	switch (str) {
		case "buyerMulti":
			openSearchPopup("/mprq/showMasterMpRqDailySourcingBuyerSelPop.do", "?st_buyer_code=" + $("#st_buyer_code").val(), "960,603,no");
			break;
		case "quotNoMulti":
			openSearchPopup("/common/multiSearchCondPop.do", "?header_text=견적번호", "300,371,no");
			break;
		case "quotKeyMulti":
			openSearchPopup("/common/multiSearchCondPop.do", "?header_text=견적Key", "300,371,no");
			break;
		case "maker":
			openSearchPopup("/common/agentRegMakerCodePop.do", "?st_alias_yn=Y", "820,464,no");
			break;
	}
}

function setPopupReturn(value1, value2, value3, value4, value5, value6){
	switch (popupSel) {
		case "buyerMulti":
			$("#st_buyer_code").val(value1);
			$("#st_buyer_name").val(kepMultiName(value2, "@"));
			break;
		case "quotNoMulti":
			var quotNos = kepCleanMultiCode(value1);
			$("#st_quotation_no_multi").val(quotNos);
			$("#st_quotation_no").val(kepMultiName(quotNos, "@"));
			break;
		case "quotKeyMulti":
			var quotKeys = kepCleanMultiCode(value1);
			$("#st_quotation_key_multi").val(quotKeys);
			$("#st_quotation_key").val(kepMultiName(quotKeys, "@"));
			break;
		case "maker":
			$("#st_maker_code").val(value1);
			$("#st_maker_name").val(value2);
			break;
	}
	popupSel = "";
}
	</script>
</head>
<body onload="kep_onload_view()">
		<div id="searchBtnA">
			<h3>데일리소싱(DB관리)</h3>
			<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
			<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
		</div>
		<form name="searchCondition" method="post">
			<div id="cont_searchA">
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<input type="hidden" name="st_user_id" id="st_user_id" value="<%=st_user_id%>">

				<table class="cont_t_list01" style="width:100%">
					<caption>데일리소싱(DB관리)</caption>
					<colgroup>
						<col width="8%" />
						<col width="30%" />
						<col width="6%" />
						<col width="16%" />
						<col width="6%" />
						<col width="16%" />
						<col width="6%" />
						<col width="12%" />
					</colgroup>
					<tbody>
						<tr>
							<th>
								<select name="st_date_type" id="st_date_type">
									<option value="REQ" selected="selected">견적의뢰일</option>
									<option value="RES">회신요청일</option>
								</select>
							</th>
							<td>
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:85px; text-align:center;" value=""> -
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:85px; text-align:center;" value="">
								<span class="btn_month"><a href="javascript:kepFromMonth('st_from_date','st_to_date','1')">-1개월</a></span>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
								<input type="checkbox" class="Noborder" style="vertical-align:middle;" name="st_period_ignore" id="st_period_ignore" value="Y"> 기간무시
							</td>
							<th>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:60%;" value="" readonly onclick="javascript:doPop('buyerMulti');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
								<a href="javascript:doPop('buyerMulti');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>견적번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_quotation_no" name="st_quotation_no" style="width:60%;" value="" onkeydown="kepEnter()" onKeyUp="kepClear('st_quotation_no_multi');">
								<input type="hidden" name="st_quotation_no_multi" id="st_quotation_no_multi" value="">
								<a href="javascript:doPop('quotNoMulti');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_quotation_no_multi','st_quotation_no');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>사업팀</th>
							<td>
								<select id="st_biz_team_spare" multiple="multiple" style="width:150px;">
									<option value="수도권사업팀">수도권사업팀</option>
									<option value="중부사업팀">중부사업팀</option>
									<option value="남부사업팀">남부사업팀</option>
									<option value="Bio Lab사업팀">Bio Lab사업팀</option>
								</select>
								<input type="hidden" name="st_biz_team" id="st_biz_team" value="">
							</td>
						</tr>
						<tr>
							<th></th>
							<td></td>
							<th>진행상태</th>
							<td>
								<select name="st_status" id="st_status">
									<option value="" selected="selected">전체</option>
									<option value="중복코드검증">중복코드검증</option>
									<option value="중복코드검증(재진행)">중복코드검증(재진행)</option>
								</select>
							</td>
							<th>견적Key</th>
							<td>
								<input type="text" class="input_type_text" id="st_quotation_key" name="st_quotation_key" style="width:60%;" value="" onkeydown="kepEnter()" onKeyUp="kepClear('st_quotation_key_multi');">
								<input type="hidden" name="st_quotation_key_multi" id="st_quotation_key_multi" value="">
								<a href="javascript:doPop('quotKeyMulti');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_quotation_key_multi','st_quotation_key');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>제조사</th>
							<td>
								<input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:60%;" value="" readonly onclick="javascript:doPop('maker');">
								<input type="hidden" name="st_maker_code" id="st_maker_code" value="">
								<a href="javascript:doPop('maker');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_maker_code','st_maker_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="tool_box">
			<div class="btnArea02 sort-line">
				<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수"/>
					<label for="onepagerow" class="hidden">정렬개수선택</label>
					<select name="onepagerow" id="onepagerow" style="width:70px;">
						<option value="50">50건</option>
						<option value="100">100건</option>
						<option value="200" selected>200건</option>
					</select>
					<img src="/resources/images/rd_pin.gif" style="margin-left:6px;"> 기등록코드
				</span>
				<span class="fr">
					<span class="btn_03"><a href="javascript:doAction('dupSearch');">중복검색</a></span>
				</span>
			</div>
			</div>
		</form>

		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>

		<div class="btnArea02">
			<span class="fl">
				<span class="btn_04 mr04"><a href="javascript:doAction('excel');">엑셀다운로드</a></span>
			</span>
			<span class="fr">
				<span class="btn_04 mr04"><a href="javascript:doAction('reprocReq');">재진행요청</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('submit');">제출</a></span>
			</span>
		</div>

</body>
</html>
