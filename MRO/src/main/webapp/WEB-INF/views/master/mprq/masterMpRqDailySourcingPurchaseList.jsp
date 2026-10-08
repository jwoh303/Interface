<%--
**********************************************
* 메뉴 : 구매대행>견적관리>데일리소싱(구매)

* 화면 : 데일리소싱(구매)
* 기능 : 구매팀 견적 진행 목록 (견적TF 2차)
* 프로그램 ID :
* 담당자 : 홍준우
* 착수일 : 2026-09-28
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
	String st_user_id       = _sessionInfo.getUserId();
	String st_user_dept     = _sessionInfo.getDepartment();
	String st_sour_dept_yn  = CommonUtil.getCodeCheckReturn("SOURDEPT", st_user_dept) ? "Y" : "N";
	String st_sour_supl_yn  = CommonUtil.getCodeCheckReturn("SOURSUPL", st_user_id) ? "Y" : "N";
	String st_mro_dept_yn   = CommonUtil.getCodeCheckReturn("MRODEPT", st_user_dept) ? "Y" : "N";
	String st_sg_req_dept_yn = CommonUtil.getCodeCheckReturn("SGRQDEPT", st_user_dept) ? "Y" : "N";
	String st_sg_d_falg = "Y".equals(st_sour_supl_yn) ? "N" : ("Y".equals(st_sg_req_dept_yn) ? "Y" : "");
%>

<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<script src="/resources/js/jquery.multiple.select.js"></script>
<script src="/resources/js/common.js"></script>
<style>
.btnArea02 { overflow:hidden; }
.tool_box { margin:0 0 5px 0; padding:0 8px 5px 8px; background:#f7f7f7; border:1px solid #d5d5d5; }
.tool_box .btnArea02.legend { height:auto; margin-top:5px; padding-top:5px; border-top:1px dashed #d5d5d5; }
#cont_searchA td { white-space:nowrap; }
#cont_searchA .ms-drop { width:auto; min-width:100%; white-space:nowrap; }
#st_date_type { width:95%; height:25px; font-family:돋움; font-size:12px; }
.lg_ok { color:#1a9c3e; font-weight:bold; }
.lg_no { color:#c0392b; font-weight:bold; }
.maint-mask { display:none; position:fixed; left:0; top:0; right:0; bottom:0; z-index:1000; background:rgba(0,0,0,0.3); }
.maint-layer { position:absolute; left:50%; top:50%; width:640px; margin:-120px 0 0 -320px; background:#f1f1f1; border:1px solid #9a9a9a; }
.maint-layer .maint-tit { height:30px; padding:0 10px; line-height:30px; background:#aaa6a6; color:#fff; font-size:14px; font-weight:bold; }
.maint-layer .maint-tit a { float:right; color:#fff; font-size:16px; text-decoration:none; }
.maint-layer .maint-sub { height:22px; padding:0 10px; line-height:22px; background:#d3d3d3; font-weight:bold; }
.maint-layer table { width:100%; margin:8px 0; }
.maint-layer th { width:70px; padding:4px 0 4px 14px; text-align:left; vertical-align:top; font-weight:normal; }
.maint-layer td { padding:4px 14px 4px 0; }
.maint-layer textarea { width:100%; height:100px; box-sizing:border-box; }
.maint-layer .maint-btn { padding:0 14px 12px 0; text-align:right; }
</style>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N";
var popupSel = "";
var MAX_DETAIL_CNT = 50;
var current_page = -1;
var gubun = "";

function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,	Hidden:true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,	Edit:true,	EditLen:100,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
		,{ Align:"Left",	Width:160,	Edit:false,	EditLen:100,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER"}
		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:100,	Type:"Text",	Header:"견적번호",	SaveName:"QUOTATION_NO"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Type:"Text",	Header:"순번",	SaveName:"QUOTATION_SEQ"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"차수",	SaveName:"REVISION"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Type:"Text",	Header:"견적Key",	SaveName:"QUOTATION_KEY",	FontColor:"#1e90ff"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",	Header:"진행상태",	SaveName:"SOURCING_STATUS"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"진행상태코드",	SaveName:"SOURCING_STATUS_CODE"}
		,{ Align:"Center",	Width:20,	Edit:false,	EditLen:100,	Type:"Image",	Header:"정비상태",	SaveName:"MAINT_STATUS_IMG"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Type:"Text",	Header:"정비상태",	SaveName:"MAINT_STATUS_NM"}
		,{ Align:"Center",	Width:55,	Edit:false,	EditLen:100,	Type:"Image",	Header:"운영\n특이사항",	SaveName:"NOTE_MNG_IMG"}
		,{ Align:"Center",	Width:20,	Edit:false,	EditLen:100,	Type:"Image",	Header:"품목코드",	SaveName:"ITEM_GUBUN"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Left",	Width:220,	Edit:false,	EditLen:100,	Type:"Text",	Header:"상세분류",	SaveName:"CATEG_PATH"}
		,{ Align:"Center",	Width:20,	Edit:false,	EditLen:100,	Type:"Text",	Header:"상세분류",	SaveName:"CATEG_DENY_IMG"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",	Header:"카테고리",	SaveName:"SG_NAME"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",	Header:"모델번호",	SaveName:"MAKER_PART_NO"}
		,{ Align:"Left",	Width:220,	Edit:false,	EditLen:2000,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:20,	Edit:false,	EditLen:100,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_DENY_IMG"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NAME"}
		,{ Align:"Right",	Width:55,	Edit:false,	EditLen:100,	Type:"Float",	Header:"수량",	SaveName:"ITEM_QTY"}
		,{ Align:"Center",	Width:45,	Edit:false,	EditLen:100,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Type:"Text",	Header:"요청자",	SaveName:"BTOA_USER_NAME"}
		,{ Align:"Center",	Width:55,	Edit:false,	EditLen:100,	Type:"Text",	Header:"자동견적",	SaveName:"AUTO_QUOT_YN"}
		,{ Align:"Center",	Width:55,	Edit:false,	EditLen:100,	Type:"Text",	Header:"추천\n협력사",	SaveName:"RECOM_AGENT_CNT"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"URL",	SaveName:"REMARK_URL"}
		,{ Align:"Left",	Width:180,	Edit:false,	EditLen:4000,	Type:"Text",	Header:"고객사비고",	SaveName:"BTOA_REMARK"}
		,{ Align:"Center",	Width:35,	Edit:false,	EditLen:100,	Type:"DummyCheck",	Header:"전달",	SaveName:"BTOA_REMARK_PASS_FLAG"}
		,{ Align:"Center",	Width:55,	Edit:false,	EditLen:100,	Type:"Image",	Header:"첨부(B)",	SaveName:"IMAGE_KEY_IMG"}
		,{ Align:"Center",	Width:35,	Edit:false,	EditLen:100,	Type:"DummyCheck",	Header:"전달",	SaveName:"IMAGE_PASS_FLAG"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Type:"Text",	Header:"TR취급\n가능여부",	SaveName:"TR_HANDLE_TYPE"}
		,{ Align:"Left",	Width:180,	Edit:false,	EditLen:4000,	Type:"Text",	Header:"운영사비고",	SaveName:"ATOA_REMARK"}
		,{ Align:"Left",	Width:140,	Edit:false,	EditLen:100,	Type:"Text",	Header:"지정협력사(B)",	SaveName:"BUYER_ASSIGN_AGENT_NAME"}
		,{ Align:"Center",	Width:45,	Edit:false,	EditLen:100,	Type:"DummyCheck",	Header:"선입고",	SaveName:"PRE_GR_FLAG"}
		,{ Align:"Left",	Width:140,	Edit:false,	EditLen:100,	Type:"Text",	Header:"지정협력사(운)",	SaveName:"ASSIGN_AGENT_NAME"}
		,{ Align:"Center",	Width:24,	Edit:false,	EditLen:100,	Type:"Image",	Header:"지정협력사(운)",	SaveName:"ERASE_ASSIGN_AGENT"}
		,{ Align:"Center",	Width:100,	Hidden:true,	Edit:false,	EditLen:100,	Type:"Text",	Header:"지정협력사코드(운)",	SaveName:"ASSIGN_AGENT_CODE"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",	Header:"표준DB코드",	SaveName:"CMS_CODE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Type:"Text",	Header:"DB매핑방식",	SaveName:"DB_MAPPING_TYPE_NM"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Type:"Text",	Header:"접수건수",	SaveName:"QUOTA_CNT"}
		,{ Align:"Center",	Width:85,	Edit:false,	EditLen:100,	Type:"Text",	Header:"견적요청일",	SaveName:"ATOS_DATE"}
		,{ Align:"Center",	Width:115,	Edit:false,	EditLen:100,	Type:"Text",	Header:"견적마감일",	SaveName:"ATOS_END_DATE",	FontColor:"#FF0000"}
		,{ Align:"Left",	Width:140,	Edit:false,	EditLen:100,	Type:"Text",	Header:"선정협력사",	SaveName:"PICK_AGENT_NAME"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Type:"Float",	Format:"#,##0",	Header:"매입단가",	SaveName:"STOA_LIST_PRICE"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Type:"Float",	Format:"#,##0",	Header:"요청단가",	SaveName:"BUYER_TARGET_PRICE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Type:"Text",	Header:"안전인증\n대상",	SaveName:"SAFETY_CERT_YN"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Type:"Text",	Header:"화학물질\n대상",	SaveName:"CHEMICAL_YN"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"MSDS\n진행상태",	SaveName:"CMC_REQ_STATUS"}
		,{ Align:"Center",	Width:75,	Edit:false,	EditLen:100,	Type:"Text",	Header:"구매담당자",	SaveName:"SM_MNG_NM"}
		,{ Align:"Center",	Width:75,	Edit:false,	EditLen:100,	Type:"Text",	Header:"견적요청자",	SaveName:"QTDT_ADD_USER_NM"}
		,{ Align:"Center",	Width:85,	Edit:false,	EditLen:100,	Type:"Date",	Header:"견적의뢰일",	SaveName:"BTOA_DATE"}
		,{ Align:"Center",	Width:85,	Edit:false,	EditLen:100,	Type:"Date",	Header:"회신요청일",	SaveName:"BTOA_END_DATE",	FontBold:1}
		,{ Align:"Left",	Width:180,	Edit:false,	EditLen:4000,	Type:"Text",	Header:"견적지연사유",	SaveName:"DELAY_REASON"}
		,{ Align:"Center",	Width:55,	Edit:false,	EditLen:100,	Type:"Text",	Header:"재진행\n요청",	SaveName:"REPROC_REQ_YN"}
		,{ Align:"Center",	Width:115,	Edit:false,	EditLen:100,	Type:"Text",	Header:"재진행\n요청일시",	SaveName:"REPROC_REQ_DATM"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"표준카탈로그코드",	SaveName:"CMS_CATLG_ID"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"구매담당",	SaveName:"SOUR_MNG"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"회신요청시간",	SaveName:"BTOA_END_TIME"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"지정협력사코드(B)",	SaveName:"BUYER_ASSIGN_AGENT_CODE"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"납품가능지역",	SaveName:"DELY_AREA"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"MSDS",	SaveName:"MSDS_YN"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"운영사비고(협력사)",	SaveName:"ATOS_REMARK"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"상세설명",	SaveName:"ITEM_DETAIL_DESC"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"첨부키",	SaveName:"IMAGE_KEY"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"ATOS_END_DATETIME",	SaveName:"ATOS_END_DATETIME"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"ADMIN_CLOSE_FLAG",	SaveName:"ADMIN_CLOSE_FLAG"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"EXTEND_FLAG",	SaveName:"EXTEND_FLAG"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"AGENT_REVISION",	SaveName:"AGENT_REVISION"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"TO_ATOS_END_DATE",	SaveName:"TO_ATOS_END_DATE"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"TO_ATOS_END_TIME",	SaveName:"TO_ATOS_END_TIME"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"BID_SUCCESS_FLAG",	SaveName:"BID_SUCCESS_FLAG"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"요청자연락처",	SaveName:"BTOA_USER_TEL"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"품목정비",	SaveName:"CMS_REJECT_YN"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"품목정비 제출일시",	SaveName:"ITEM_MD_DATE"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"정비구분",	SaveName:"ITEM_CHG_REQ_TYPE"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"품목정비 요청사유",	SaveName:"ITEM_CHG_REQ_NOTE"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"품목정비 첨부",	SaveName:"ITEM_CHG_REQ_IMAGE_KEY"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"품목정비 요청자",	SaveName:"ITEM_CHG_REQ_ID"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"DB클랜징일자",	SaveName:"CMS_RECV_DATE"}
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	initsheet.HeaderMode = {Sort:1, ColMove:0, ColResize:1, HeaderCheck:1};
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetImageList(0, "/resources/images/but_icon02.gif");
	mySheet.SetImageList(1, "/resources/images/but_icon01.gif");
	mySheet.SetImageList(2, "/resources/images/disk_off.gif");
	mySheet.SetImageList(3, "/resources/images/disk_on.gif");
	mySheet.SetImageList(4, "/resources/images/rd_pin.gif");
	mySheet.SetImageList(10, "/resources/images/icon_r.gif");
	mySheet.SetImageList(11, "/resources/images/icon_g.gif");
	mySheet.SetImageList(12,"/resources/images/btn_eraser2.gif");

	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val( kepToMonthAdd("1","M") );
	$("#st_to_date").val( kepGetNowTimeStr("YYYYMMDD","/") );

	$("#st_status_spare").multipleSelect({
		placeholder : "전체",
		selectAllText : "전체선택",
		maxHeight : 300,
		onClose : function() {
			$("#st_status").val($("#st_status_spare").multipleSelect("getSelects"));
		}
	});
}

function doAction(str) {
	switch (str) {
	case "search":
		if ($("#st_period_ignore").is(":checked")) {
			if ($.trim($("#st_quotation_no").val()) == "" && $.trim($("#st_quotation_key").val()) == "" && $("#st_quotation_key_multi").val() == "") {
				alert("기간무시 조회는 견적번호 또는 견적Key를 입력해야 합니다.");
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
		kepSearch(document.searchCondition, mySheet, "/mprq/searchMasterMpRqDailySourcingPurchaseList.do", pagingMode);
		break;

	case "purchasePrice":
		var chkRows = kepSheetCheckedRows(mySheet, "SELECTED");
		if (chkRows.length == 0) {
			alert("선택된 행이 없습니다.");
			return;
		}
		openDetailPop(chkRows, 0);
		break;

	case "quotInit":
		var initRows = kepSheetCheckedRows(mySheet, "SELECTED");
		if (initRows.length == 0) {
			alert("선택된 항목이 없습니다.");
			return;
		}
		var buyer = mySheet.GetCellValue(initRows[0], "BUYER");
		for (var i = 0; i < initRows.length; i++) {
			if (buyer != mySheet.GetCellValue(initRows[i], "BUYER")) {
				alert("동일한 고객사별로 진행가능합니다.");
				return;
			}
		}
		if (!confirm('선택한 항목을 견적초기화 하시겠습니까?'))
			return;
		gubun = "init";
		kepSave(document.searchCondition, mySheet, "/mprq/initMasterMpRqDailySourcingPurchase.do", "SELECTED");
		break;

	case "dbStandardCopy":
		var copyRows = kepSheetCheckedRows(mySheet, "SELECTED");
		if (copyRows.length < 2) {
			alert("둘 이상의 선택이 필요합니다.");
			return;
		}
		var st_categ_path_firstRow = mySheet.GetCellValue(copyRows[0], "CATEG_PATH");
		for (var i = 0; i < copyRows.length; i++) {
			if (st_categ_path_firstRow != mySheet.GetCellValue(copyRows[i], "CATEG_PATH")) {
				alert("동일한 표준카테고리만 가능합니다.");
				return;
			}
		}
		if (mySheet.GetCellValue(copyRows[0], "CMS_RECV_DATE") == "") {
			alert("체크된 첫 행의 DB클랜징이 안되어 있습니다.");
			return;
		}
		if (!confirm("체크된 첫 행의 DB클랜징(이미지포함)으로 모두 복사합니다.\n이대로 진행하시겠습니까?"))
			return;
		gubun = "copy";
		kepSave(document.searchCondition, mySheet, "/mprq/saveMasterMpRqDailySourcingPurchaseDbCleansingCopy.do", "SELECTED");
		break;

	case "maintReq":
		var maintRows = kepSheetCheckedRows(mySheet, "SELECTED");
		if (maintRows.length == 0) {
			alert("선택된 항목이 없습니다.");
			return;
		}
		for (var i = 0; i < maintRows.length; i++) {
			if (mySheet.GetCellValue(maintRows[i], "CMS_REJECT_YN") == "Y" && mySheet.GetCellValue(maintRows[i], "ITEM_MD_DATE") == "") {
				alert("이미 품목정비 요청중인 견적건입니다.[" + maintRows[i] + "번째]");
				return;
			}
		}
		openMaintLayer();
		break;

	case "msdsReq":
		var msdsRows = kepSheetCheckedRows(mySheet, "SELECTED");
		if (msdsRows.length == 0) {
			alert("선택된 항목이 없습니다.");
			return;
		}
		for (var i = 0; i < msdsRows.length; i++) {
			if (mySheet.GetCellValue(msdsRows[i], "BID_SUCCESS_FLAG") != "Y") {
				alert("협력사선정완료된 견적만 요청 가능합니다.");
				return;
			}
		}
		if (!confirm('선택한 항목을 협력사에 MSDS 요청 하시겠습니까?\n현재 매핑된 MSDS_NO는 해제됩니다.'))
			return;
		gubun = "msds";
		kepSave(document.searchCondition, mySheet, "/mprq/saveMasterMpRqDailySourcingPurchaseMsdsReq.do", "SELECTED");
		break;

	case "extendEndTime":
		if (kepSheetCheckedRows(mySheet, "SELECTED").length == 0) {
			alert("선택된 항목이 없습니다.");
			return;
		}
		popupSel = "masterMpRqQuotationStoATimePop";
		openSearchPopup("/mprq/showMasterMpRqDailySourcingEndTimePop.do", "", "420,150,no");
		break;

	case "reload":
		kepReload('searchCondition');
		$("#st_buyer_code").val("");
		$("#st_buyer_name").val("");
		$("#st_quotation_no_multi").val("");
		$("#st_quotation_key_multi").val("");
		$("#st_sg_id_multi").val("");
		$("#st_sg_name").val("");
		$("#st_from_date").val( kepToMonthAdd("1","M") );
		$("#st_to_date").val( kepGetNowTimeStr("YYYYMMDD","/") );
		$("#st_period_ignore").prop("checked", false);
		init_multiCombo("st_status");
		$("#st_status").val("");
		$("#st_maint_status").val("");
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
	for (var r = mySheet.HeaderRows(); r <= mySheet.LastRow(); r++) {
		var stoaPrice = mySheet.GetCellValue(r, "STOA_LIST_PRICE");
		var targetPrice = mySheet.GetCellValue(r, "BUYER_TARGET_PRICE");
		if (stoaPrice !== "" && Number(targetPrice) > 0 && Number(stoaPrice) >= Number(targetPrice)) {
			mySheet.SetCellFontColor(r, "STOA_LIST_PRICE", "#FF0000");
		}
	}
	if (msg != "") alert(msg);
}

function openMaintLayer() {
	var cb = KepSheetComboData("DM04", "SEL");
	var codes = cb.ComboCode.split("|");
	var texts = cb.ComboText.split("|");
	var $sel = $("#maint_req_type").empty();
	for (var i = 0; i < codes.length; i++) {
		$sel.append($("<option>").val(codes[i]).text(texts[i]));
	}
	$("#maint_req_note").val("");
	$("#maint_image_key").val("");
	$("#maint_file_img").attr("src", "/resources/images/disk_off.gif");
	$("#maintLayer").show();
}

function closeMaintLayer() {
	$("#maintLayer").hide();
}

function openMaintFile() {
	popupSel = "itemChgReqfileUpload";
	openSearchPopup('/common/fileUploadPop.do', '?DOC_NO=' + $("#maint_image_key").val() + '&TYPE=RFQ&viewType=VI', '500,430,no');
}

function saveMaintReq() {
	var arrRow = kepSheetCheckedRows(mySheet, "SELECTED");
	var st_req_type = $("#maint_req_type").val();
	var st_req_note = $("#maint_req_note").val();
	if (st_req_type == "") {
		alert("정비구분을 선택하여 주십시요.");
		$("#maint_req_type").focus();
		return;
	}
	if (st_req_note.length == 0) {
		alert("요청사유를 입력하여 주십시요.");
		$("#maint_req_note").focus();
		return;
	}
	if (!confirm("품목재정비를 요청하시겠습니까?"))
		return;
	for (var i = 0; i < arrRow.length; i++) {
		mySheet.SetCellValue(arrRow[i], "CMS_REJECT_YN", "Y");
		mySheet.SetCellValue(arrRow[i], "ITEM_CHG_REQ_ID", $("#st_user_id").val());
		mySheet.SetCellValue(arrRow[i], "ITEM_CHG_REQ_TYPE", st_req_type);
		mySheet.SetCellValue(arrRow[i], "ITEM_CHG_REQ_NOTE", st_req_note);
		mySheet.SetCellValue(arrRow[i], "ITEM_CHG_REQ_IMAGE_KEY", $("#maint_image_key").val());
	}
	closeMaintLayer();
	gubun = "maint";
	kepSave(document.searchCondition, mySheet, "/mprq/saveMasterMpRqDailySourcingPurchaseItemChgReq.do", "SELECTED");
}

function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if (!checkedSession(stCode)) return;
	if (gubun == "init") {
		if (msg != "") {
			if (code != 0) {
				alert(msg.msg);
			} else {
				alert(msg);
			}
		}
		if (code > 0) doAction('search');
	} else if (gubun == "atos" || gubun == "msds" || gubun == "maint" || gubun == "copy") {
		if (msg != "") alert(msg);
		if (code > 0) doAction('search');
	}
	gubun = "";
}

function pageSearch(param) {
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/mprq/searchMasterMpRqDailySourcingPurchaseList.do?page=" + current_page, pagingMode);
}

function mySheet_OnClick(Row, Col, Value) {
	if (Row < mySheet.HeaderRows()) return;
	if (mySheet.ColSaveName(Col) != "QUOTATION_KEY" || Value == "") return;
	var rows = kepSheetCheckedRows(mySheet, "SELECTED");
	if ($.inArray(Row, rows) < 0) {
		rows.push(Row);
		rows.sort(function(a, b) { return a - b; });
	}
	openDetailPop(rows, $.inArray(Row, rows));
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
	var popName = "showMasterMpRqDailySourcingPurchaseDetailPop";
	var pop = window.open("", popName,
		"left=" + x + ",top=" + y + ",width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=0,location=0,titlebar=0,menubar=0");
	if (pop == null) return;
	var $f = $("<form>", {method: "post", action: "/mprq/showMasterMpRqDailySourcingPurchaseDetailPop.do", target: popName}).css("display", "none");
	$f.append($("<input>", {type: "hidden", name: "nav_keys", value: keys.join(",")}));
	$f.append($("<input>", {type: "hidden", name: "nav_idx", value: idx}));
	$f.appendTo("body").submit().remove();
	try {
		pop.moveTo(x, y);
		pop.resizeTo(w, h);
	} catch (e) {}
	pop.focus();
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
		case "sgChoice":
			openSearchPopup("/mdcm/showMasterMdCmCmsItemSgSelPop.do", "?st_my_sg_yn=Y&st_sg_id_multi=" + $("#st_sg_id_multi").val(), "950,521,no");
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
		case "sgChoice":
			$("#st_sg_id_multi").val(value1);
			$("#st_sg_name").val(kepMultiName(value2, "@"));
			break;
		case "itemChgReqfileUpload":
			$("#maint_image_key").val(value1);
			$("#maint_file_img").attr("src", (value2 == "on") ? "/resources/images/disk_on.gif" : "/resources/images/disk_off.gif");
			break;
		case "masterMpRqQuotationStoATimePop":
			var arrRow = kepSheetCheckedRows(mySheet, "SELECTED");
			var toBe_atosDate = value1 + value2;
			for (var i = 0; i < arrRow.length; i++) {
				var atosDate = mySheet.GetCellValue(arrRow[i], "ATOS_END_DATETIME");
				var st_buyer = mySheet.GetCellValue(arrRow[i], "BUYER_NAME");
				var st_qutation_no = mySheet.GetCellValue(arrRow[i], "QUOTATION_NO");
				if (mySheet.GetCellValue(arrRow[i], "AGENT_REVISION") == "") {
					alert(st_buyer + "(" + st_qutation_no + ")건  협력사 견적요청 전 건은 견적마감 시간 연장 불가능 합니다.");
					popupSel = "";
					return;
				}
				if (mySheet.GetCellValue(arrRow[i], "EXTEND_FLAG") != "Y") {
					alert(st_buyer + "(" + st_qutation_no + ")건  견적마감 시간이 도래한 견적건은 연장 불가능 합니다.");
					popupSel = "";
					return;
				}
				if (mySheet.GetCellValue(arrRow[i], "ADMIN_CLOSE_FLAG") == "Y") {
					alert(st_buyer + "(" + st_qutation_no + ")건  조기마감건은 견적마감 시간 연장 불가능 합니다.");
					popupSel = "";
					return;
				}
				if (atosDate > toBe_atosDate) {
					alert(st_buyer + "(" + st_qutation_no + ")건 견적마감 시간 연장 대상건이 아닙니다.");
					popupSel = "";
					return;
				}
				mySheet.SetCellValue(arrRow[i], "TO_ATOS_END_DATE", value1);
				mySheet.SetCellValue(arrRow[i], "TO_ATOS_END_TIME", value2);
			}
			gubun = "atos";
			kepSave(document.searchCondition, mySheet, "/mprq/saveMasterMpRqDailySourcingPurchaseEndTime.do", "SELECTED");
			break;
	}
	popupSel = "";
}
	</script>
</head>
<body onload="kep_onload_view()">
		<div id="searchBtnA">
			<h3>데일리소싱(구매)</h3>
			<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
			<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
		</div>
		<form name="searchCondition" method="post">
			<div id="cont_searchA">
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<input type="hidden" name="st_user_id" id="st_user_id" value="<%=st_user_id%>">
			<input type="hidden" name="st_my_sg_only" id="st_my_sg_only" value="Y">
			<input type="hidden" name="st_sour_dept_yn" id="st_sour_dept_yn" value="<%=st_sour_dept_yn%>">
			<input type="hidden" name="st_sour_supl_yn" id="st_sour_supl_yn" value="<%=st_sour_supl_yn%>">
			<input type="hidden" name="st_mro_dept_yn" id="st_mro_dept_yn" value="<%=st_mro_dept_yn%>">
			<input type="hidden" name="st_sg_d_falg" id="st_sg_d_falg" value="<%=st_sg_d_falg%>">
			<input type="hidden" name="st_exits_item" id="st_exits_item" value="Y">

				<table class="cont_t_list01" style="width:100%">
					<caption>데일리소싱(구매)</caption>
					<colgroup>
						<col width="8%" />
						<col width="30%" />
						<col width="6%" />
						<col width="13%" />
						<col width="6%" />
						<col width="13%" />
						<col width="7%" />
						<col width="17%" />
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
							<th>정비여부</th>
							<td>
								<select name="st_maint_status" id="st_maint_status" style="width:60%;">
									<option value="">전체</option>
									<option value="N">정비미요청</option>
									<option value="S">정비제출</option>
								</select>
							</td>
						</tr>
						<tr>
							<th></th>
							<td></td>
							<th>진행상태</th>
							<td>
								<select id="st_status_spare" multiple="multiple" style="width:85%;">
									<option value="고객사견적의뢰">고객사견적의뢰</option>
									<option value="협력사견적요청">협력사견적요청</option>
									<option value="견적마감">견적마감</option>
									<option value="협력사선정완료">협력사선정완료</option>
									<option value="협력사재견적요청">협력사재견적요청</option>
									<option value="재진행요청(DB관리)">재진행요청(DB관리)</option>
									<option value="재진행요청(사업)">재진행요청(사업)</option>
								</select>
								<input type="hidden" name="st_status" id="st_status" value="">
							</td>
							<th>견적Key</th>
							<td>
								<input type="text" class="input_type_text" id="st_quotation_key" name="st_quotation_key" style="width:60%;" value="" onkeydown="kepEnter()" onKeyUp="kepClear('st_quotation_key_multi');">
								<input type="hidden" name="st_quotation_key_multi" id="st_quotation_key_multi" value="">
								<a href="javascript:doPop('quotKeyMulti');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_quotation_key_multi','st_quotation_key');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>카테고리</th>
							<td>
								<input type="text" class="input_type_text" name="st_sg_name" id="st_sg_name" style="width:60%;" value="" readonly onclick="javascript:doPop('sgChoice');">
								<input type="hidden" name="st_sg_id_multi" id="st_sg_id_multi" value="">
								<a href="javascript:doPop('sgChoice');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_sg_id_multi','st_sg_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="tool_box">
			<div class="btnArea02">
				<span class="fl">
					<span class="btn_04 mr04"><a href="javascript:doAction('imageCopy');">이미지복사</a></span>
					<%-- <span class="btn_05 mr04"><a href="javascript:doAction('dbStandardCopy');">DB표준화복사</a></span> --%>
					<span class="btn_04 mr04"><a href="javascript:doAction('bulkStandard');">일괄표준화</a></span>
					<span class="btn_05 mr04"><a href="javascript:doAction('bulkPrice');">일괄단가반영</a></span>
					<span class="btn_03 mr04"><a href="javascript:doAction('dupSearch');">중복검색</a></span>
				</span>
				<span class="fr">
					<span class="btn_06 mr04"><a href="javascript:doAction('categoryChgReq');">카테고리변경요청</a></span>
					<span class="btn_03 mr04"><a href="javascript:doAction('maintReq');">정비요청</a></span>
					<span class="btn_05 mr04"><a href="javascript:doAction('autoQuot');">자동견적요청</a></span>
					<span class="btn_04 mr04"><a href="javascript:doAction('agentSel');">협력사선택</a></span>
				</span>
			</div>
			<div class="btnArea02 legend">
				<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
					<label for="onepagerow" class="hidden">정렬개수선택</label>
					<select name="onepagerow" id="onepagerow" style="width:70px;">
						<option value="20">20건</option>
						<option value="30">30건</option>
						<option value="50" selected>50건</option>
					</select>
					&nbsp;<img src="/resources/images/icon_g.gif"> 정비미요청
					&nbsp;<img src="/resources/images/icon_r.gif"> 정비제출
					&nbsp;<img src="/resources/images/rd_pin.gif"> 기등록코드
					&nbsp;<span class="lg_ok">◎</span> 거래가능 상세분류, 제조사(고객사별)
					&nbsp;<span class="lg_no">⊘</span> 거래불가 상세분류, 제조사(고객사별)
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
				<span class="btn_04 mr04"><a href="javascript:doAction('quotInit');">견적초기화</a></span>
				<span class="btn_04 mr04"><a href="javascript:doAction('reQuot');">재견적요청</a></span>
				<span class="btn_05 mr04"><a href="javascript:doAction('msdsReq');">MSDS제출요청</a></span>
				<span class="btn_05 mr04"><a href="javascript:doAction('msdsMail');">MSDS독려메일</a></span>
			</span>
			<span class="fr">
				<span class="btn_05 mr04"><a href="javascript:doAction('extendEndTime');">마감시간연장</a></span>
				<span class="btn_05 mr04"><a href="javascript:doAction('quotMail');">견적독려메일</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
				<span class="btn_04 mr04"><a href="javascript:doAction('purchasePrice');">매입가제출</a></span>
			</span>
		</div>

		<div class="maint-mask" id="maintLayer">
			<div class="maint-layer">
				<div class="maint-tit">정비요청 <a href="javascript:closeMaintLayer();">✕</a></div>
				<div class="maint-sub">요청정보</div>
				<table>
					<tr>
						<th>정비구분</th>
						<td>
							<select id="maint_req_type" style="width:160px;"></select>
							<span style="margin-left:20px;">정비첨부</span>
							<a href="javascript:openMaintFile();"><img id="maint_file_img" src="/resources/images/disk_off.gif" style="vertical-align:middle;" alt="첨부"></a>
							<input type="hidden" id="maint_image_key" value="">
						</td>
					</tr>
					<tr>
						<th>요청사유</th>
						<td><textarea id="maint_req_note" maxlength="2000"></textarea></td>
					</tr>
				</table>
				<div class="maint-btn"><span class="btn_02"><a href="javascript:saveMaintReq();">요청</a></span></div>
			</div>
		</div>

</body>
</html>
