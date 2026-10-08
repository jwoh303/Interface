<%--
**********************************************
* 메뉴 : I/F 관리>I/F진행현황>품목정보I/F현황
* 화면 : 품목정보I/F현황
* 기능 :
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 :
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	String searchYn		= CommonUtil.nvl((String)request.getParameter("search_yn"));
	String buyerCode	= CommonUtil.nvl((String)request.getParameter("st_buyer_code"));
	String buyerName	= CommonUtil.nvl((String)request.getParameter("st_buyer_name"));
	String st_user_check = CommonUtil.nvl((String)request.getParameter("st_user_check"));
	String st_user_dept = CommonUtil.nvl((String)request.getParameter("st_user_dept"));
	String processYN = CommonUtil.nvl((String)request.getParameter("processYN"));
%>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var imageG="/resources/images/icon_g.gif";
var imageY="/resources/images/icon_y.gif";
var imageR="/resources/images/icon_r.gif";
var imagePrifC="/resources/images/icon_prif_c.gif";
var imagePrifR="/resources/images/icon_prif_r.gif";
var imagePrifCancel="/resources/images/icon_prif_cancel.gif";
var imagePrifDelete="/resources/images/icon_prif_delete.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var cancelRemarkOn="/resources/images/but_icon01.gif";
var cancelRemarkOff="/resources/images/but_icon02.gif";
var searchYn = "<%=searchYn%>";
var processYN ="<%=processYN%>";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var unit = KepSheetComboQueryIdData("getUnitMeasureInfo", "");
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 2};
	initsheet.HeaderMode = {			ColMove : 1,			ColResize : 1		};
	initsheet.Cols = [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,	Hidden:true,	Type:"Status",				Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",			Header:"",						SaveName:"SELECTED"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Image",				Header:"처리결과",			SaveName:"RESULT_FLAG_IMG"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"담당자",			SaveName:"PURCHASE_PIC"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"SITE",			SaveName:"COMPANY_CODE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"VENDOR",			SaveName:"VENDOR"}
		,{ Align:"Center",	Width:130,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"프로세스구분",			SaveName:"PROCESS_TYPE"}
		,{ Align:"Center",	Width:180,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"BQMS요청번호",			SaveName:"REQ_NO"}
		,{ Align:"Center",	Width:130,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"대행사요청번호",			SaveName:"VENDOR_REQ_NO"}
		,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사품목코드",			SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Center",	Width:130,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"BQMS품목코드",			SaveName:"ITEM_CODE"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"카테고리",	SaveName:"CATEGORY_TEXT", BackColor:"${notnullColor}"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"품명",			SaveName:"ITEM_NAME"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"규격",			SaveName:"SPECIFICATION"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"모델번호",			SaveName:"MODEL_NO"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"제조사명",			SaveName:"MAKER_NAME", BackColor:"${notnullColor}"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"표준카탈로그코드",	SaveName:"CMS_CATLG_ID", BackColor:"${notnullColor}"}
		,{ Align:"Center",	Width:70,	Edit:true,	EditLen:110,	Hidden:false,	SaveName:"UNIT_MEASURE",		Header:"단위",			Type:"Combo", ComboText:unit.ComboText, ComboCode:unit.ComboCode, BackColor:"${notnullColor}"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"견적취소사유",	SaveName:"CANCEL_REMARK_IMG", Sort:0}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"견적취소사유",	SaveName:"CANCEL_REMARK"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	SaveName:"IMGFILE_NAME_IMG",	Header:"이미지첨부(M)",	Type:"Image", BackColor:"${notnullColor}"}
		,{ Align:"Center",	Width:90,	Edit:false, EditLen:110,	Hidden:false,	SaveName:"IMGFILE_DIR",			Header:"이미지경로",		Type:"Text"}
		,{ Align:"Center",	Width:90,	Edit:false, EditLen:110,	Hidden:false,	SaveName:"IMGFILE_NAME",		Header:"이미지파일",		Type:"Text"}		
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Float",				Header:"발주배수",			SaveName:"ORDER_UNIT"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Float",				Header:"최소주문수량",			SaveName:"MOQ"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"세율",			SaveName:"VAT"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"환율",			SaveName:"ITEM_COL08"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"화폐단위",			SaveName:"CURRENCY"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Float",				Header:"매출단가",			SaveName:"UNIT_PRICE"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Float",				Header:"매입단가",			SaveName:"ITEM_COL01"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Date",				Header:"계약시작일",			SaveName:"PRICE_START_DT"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Date",				Header:"계약종료일",			SaveName:"PRICE_END_DT"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"단종여부",			SaveName:"CLOSE_YN"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Date",				Header:"단종일시",			SaveName:"CLOSE_DT"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Float",				Header:"납기소요일",			SaveName:"LEAD_TIME"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"과세여부",			SaveName:"TAXABLE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Date",				Header:"IF생성일",			SaveName:"CREATE_DATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"IF처리구분",			SaveName:"IF_FLAG"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Date",				Header:"IF처리일",			SaveName:"IF_DATE"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"IF메세지",			SaveName:"IF_MSG"}
		,{ Align:"Left",	Width:250,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"BQMS회신내용",			SaveName:"RESULT_MSG"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Image",				Header:"품목이미지",			SaveName:"PREVIEW_IMG"}
		// 히든필드 시작...
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"고객사코드",	SaveName:"BUYER"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"견적번호",	SaveName:"QUOTATION_NO"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"순번",	SaveName:"QUOTATION_SEQ"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"차수(B)",	SaveName:"REVISION"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"CATEGORY_NO",			SaveName:"CATEGORY_NO"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"MAIN_IMAGE_URL",			SaveName:"MAIN_IMAGE_URL"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"IMAGE_URL",		SaveName:"IMAGE_URL"}

		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"제조사코드",		SaveName:"MAKER_CODE"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"원산지코드",		SaveName:"ORIGIN_CODE"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"원산지명",			SaveName:"ORIGIN_NAME"}

		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"품의구분",		SaveName:"PM_GUBUN"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"품의코드",		SaveName:"PM_BUYER"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"품의번호",		SaveName:"PM_NO"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"품의항번",		SaveName:"PM_SEQ"}
	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);

	// 상태이미지설정
	mySheet.SetImageList(0, imageG);
	mySheet.SetImageList(1, imageY);
	mySheet.SetImageList(2, imageR);

	mySheet.SetImageList(3, imagePrifC);
	mySheet.SetImageList(4, imagePrifR);
	mySheet.SetImageList(5, imagePrifCancel);
	mySheet.SetImageList(6, imagePrifDelete);
	mySheet.SetImageList(7, diskOff);
	mySheet.SetImageList(8, diskOn);
	mySheet.SetImageList(9, cancelRemarkOn);
	mySheet.SetImageList(10, cancelRemarkOff);

	// 하이퍼링크 설정
	setLinkCol(mySheet, "CMS_CATLG_ID");
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "CATEGORY_TEXT");
	setLinkCol(mySheet, "IMGFILE_NAME_IMG");
	setLinkCol(mySheet, "PREVIEW_IMG");
	setLinkCol(mySheet, "MAKER_NAME");
	setLinkCol(mySheet, "CANCEL_REMARK_IMG"); // 취소
	
	mySheet.SetCellFontUnderline(0, "CANCEL_REMARK_IMG", true);	
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");

	// 초기화 설정
	resetValue();
	
	$("#st_buyer_code").val("<%=buyerCode%>");
	$("#st_buyer_name").val("<%=buyerName%>");
	var st_user_check = "<%=st_user_check%>";
	
	// 콤보데이터 셋팅
	kepAjaxCommonQueryIdSearchTwoCombo('st_suser_id','common.masterDepartmentUserList','PG_10_M_006_00','','ALL','${sessionInfo.userId}'); // 조회조건 : 담당자
	
	if(st_user_check== "Y"){
		$('#st_user_check').prop('checked',true);
	}
	if(processYN == "Y"){
		kepAjaxCommonQueryIdCombo('st_user_dept','getKepDeptList','','<%=st_user_dept%>');
		doAction("search");
	}
}

// 초기화 설정
function resetValue() {
	// 조회일자 설정
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));

}

var st;
var mt;

// 그리드 표시후 처리
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {

	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search": // 조회
			// 조회조건 체크
	
			var process_type = document.searchCondition.st_process_type.value;
			
			var obj1	= document.getElementById("btnRegistItem");
			var obj2	= document.getElementById("btnUpdateItem");
			var obj3	= document.getElementById("btnRequotItem");
			var obj4	= document.getElementById("btnDeleteItem");
			var obj5	= document.getElementById("btnCancelItem");
			var obj6	= document.getElementById("btnResendPrice");
		
			//alert(obj.style.visibility);
			if (process_type == "REGIST_ITEM") {
				obj1.style.display = "inline-block";
				obj2.style.display = "none";
				obj3.style.display = "none";
				obj4.style.display = "inline-block";
				obj5.style.display = "none";
				obj6.style.display = "none";
			} else if (process_type == "RETURN_NEW_ITEM") {
				obj1.style.display = "none";
				obj2.style.display = "inline-block";
				obj3.style.display = "inline-block";
				obj4.style.display = "none";
				obj5.style.display = "inline-block";
				obj6.style.display = "none";
			} else if (process_type == "CHANGE_PRICE") {
				obj1.style.display = "none";
				obj2.style.display = "none";
				obj3.style.display = "none";
				obj4.style.display = "inline-block";
				obj5.style.display = "none";
				obj6.style.display = "inline-block";
			} else if (process_type == "ALL") {
				obj1.style.display = "none";
				obj2.style.display = "none";
				obj3.style.display = "none";
				obj4.style.display = "none";
				obj5.style.display = "none";
				obj6.style.display = "none";
			} else {
				obj1.style.display = "none";
				obj2.style.display = "none";
				obj3.style.display = "none";
				obj4.style.display = "inline-block";
				obj5.style.display = "none";
				obj6.style.display = "none";
			}
			
			// 기간 무시 checkbox
			var isCheckDate = $("#st_date_flag").is(":checked");

			if ( isCheckDate ) {
				$("#st_date_flag_value").val("Y");
			} else {
				$("#st_date_flag_value").val("N");
			}
			
			var suser_name = document.searchCondition.st_suser_id[document.searchCondition.st_suser_id.selectedIndex].text;
			
			document.searchCondition.st_suser_name.value = suser_name;
			
			if ( !searchValidate() )
				return;
			current_page = -1;
			$("#job_kind").val("");
			kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpIfSecItemInfoList.do", pagingMode);
			break;

		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;

		case "excelDown": // 엑셀다운로드
			var pxNum = TrimCommon(document.forms.searchCondition.st_pm_no.value);
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 31 ){ // 조회기간 한달 초과
				if(pxNum == null || pxNum == '' ){
					alert("품의번호는 필수입력 항목 입니다.");
					return;
				}				
			}
		
		    $("#pageflag").val('0');
			var param = {FileName:"삼성IF오류_품목.xlsx",Merge:1,SheetDesign:1,DownCols:"RESULT_FLAG_IMG|COMPANY_CODE|PROCESS_TYPE|REQ_NO|VENDOR_REQ_NO|ITEM_CODE|CATEGORY_TEXT|ITEM_NAME|SPECIFICATION|MODEL_NO|MAKER_NAME|CMS_CATLG_ID|UNIT_MEASURE|IMGFILE_NAME_IMG|IMGFILE_DIR|IMGFILE_NAME|ORDER_UNIT|MOQ|VAT|UNIT_PRICE|PRICE_START_DT|PRICE_END_DT|CLOSE_YN|CLOSE_DT|LEAD_TIME|TAXABLE|IF_FLAG|IF_DATE|IF_MSG|RESULT_MSG|PREVIEW_IMG|BUYER|QUOTATION_NO|QUOTATION_SEQ|REVISION|BUYER_ITEM_NO|CATEGORY_NO|MAIN_IMAGE_URL|IMAGE_URL|MAKER_CODE|ORIGIN_CODE|ORIGIN_NAME|PURCHASE_PIC|CURRENCY|ITEM_COL01|ITEM_COL08|PM_GUBUN|PM_BUYER|PM_NO|PM_SEQ"};
			kepDownExcel(document.searchCondition ,mySheet , "/mpif/excelMasterMpIfSecItemInfoList.do", param);
			$("#pageflag").val('1');
			break;

		case "delete": // 상태값 삭제로 변경.
			if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mpif/deleteEventMasterMpIfSecItemInfo.do" , "SELECTED" );
			break;
			
		case "cancel": // 견적 취소.
			var arrRow     = selectedGrid.split("|");
			for (var i=0; i<arrRow.length; i++){
				var CANCEL_REMARK    = mySheet.GetCellValue(arrRow[i],"CANCEL_REMARK");
				if(CANCEL_REMARK == ""){
					alert("견적 취소 사유를 입력하여 주십시요");
					return;
				}
			}
			if (!confirm('선택한 항목을 견적취소 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mpif/cancelQuotationMasterMpIfSecItemInfo.do" , "SELECTED" );
			break;

		case "update": // 품목정보 수정.
			if (!confirm('선택한 항목을 수정 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mpif/updateItemMasterMpIfSecItemInfo.do" , "SELECTED" );
			break;

		case "reQuotation": // 재견적
			if (!confirm('선택한 항목을 재견적 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mpif/requotationMasterMpIfSecItemInfo.do" , "SELECTED" );
			break;
			
		case "resendPrice": // 단가재전송
			if (!confirm('선택한 항목을 단가재전송 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mpif/resendPriceMasterMpIfSecItemInfo.do" , "SELECTED" );
			break;

		case "registItem": // BQMS등록
			if (!confirm('선택한 항목을 재등록 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mpif/registItemMasterMpIfSecItemInfo.do" , "SELECTED" );
			break;
	
	}
}
function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

}
// 조회조건 체크
function searchValidate() {
	var start_date = $("#st_from_date").val().replace(/[/]/gi,"");
	var end_date = $("#st_to_date").val().replace(/[/]/gi,"");

	if ( start_date > end_date ) {
		alert("I/F 종료일은 시작일보다 작을 수 없습니다");
		return false;
	}

	return true;
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}


	if (msg != "") {
		alert(msg);
	}

	if ( current_page == -1 ) {
		makePageIndex2(mySheet, 1, document.searchCondition.onepagerow.value);
	}
	else {
		makePageIndex2(mySheet, current_page, document.searchCondition.onepagerow.value);
	}

}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if ( msg != "" ) {
		alert(msg);
	}

	if ( code >= 0 ) {
		doAction("search");
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param) {
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpIfSecItemInfoList.do?page="+current_page , pagingMode);
}

function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	if (checkRows.length == 0){
		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	var arrRow = checkRows.split("|");
	
	if (mySheet.ColSaveName(Col) == "CANCEL_REMARK_IMG"){ // 견적취소
		var value1 = mySheet.GetCellValue(arrRow[0], "CANCEL_REMARK");
		if(kepIsValueNull(value1)){
			alert("복사할 견적 취소사유를 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "CANCEL_REMARK", value1);
			mySheet.SetCellValue(arrRow[idx], "CANCEL_REMARK_IMG", (value1!="")? cancelRemarkOn : cancelRemarkOff);
		}
	}
}
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;

	var cms_categ_id = mySheet.GetCellValue(Row,"CMS_CATEG_ID"); // 카테고리ID
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == "CMS_CATLG_ID" ){ 
		popupSel = "stndCatlg";
		
		var st_buyer = mySheet.GetCellValue(Row, "BUYER");
		var st_quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
		var st_quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
		var st_revision = mySheet.GetCellValue(Row, "REVISION");

		openSearchPopup("/mprq/showMasterMpRqStndCatalgListPop.do","?st_buyer="+st_buyer+"&st_quotation_no="+st_quotation_no+"&st_quotation_seq="+st_quotation_seq+"&st_revision="+st_revision+"&st_type=RCMD&st_row_no="+Row,"900,800,no");
	} else if (column == 'CATEGORY_TEXT') { // 카테고리
		popupSel = "commonCoCoBuyerCategoryChoicePop";
		openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoicePop.do",'?st_buyer=KRSAMS0123',"728,510,no");
	} else if (column == 'PREVIEW_IMG') {
		var st_img_url = mySheet.GetCellValue(Row, "MAIN_IMAGE_URL");
		
		if (st_img_url != "X") {
			window.open(st_img_url, "previewPop", "width=500, height=500, toolbar=no, menubar=no, scrollbars=no, resizable=yes");			
		}
	} else if(column == "IMGFILE_NAME_IMG"){
		popupSel = "addImgPop";
		var st_imgfile_dir = mySheet.GetCellValue(Row, "IMGFILE_DIR");
		var st_imgfile_name = mySheet.GetCellValue(Row, "IMGFILE_NAME");
		var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
		var st_agent = document.searchCondition.st_user_id.value;
		var mod_yn = "Y"; //수정여부`
		var st_type = "S"; //협력사일경우
		openSearchPopup("/common/addImagePop.do", '?st_agent='+st_agent+'&st_imgfile_dir='+st_imgfile_dir+'&st_imgfile_name='+st_imgfile_name+'&st_buyer_item_no='+st_buyer_item_no+'&mod_yn='+mod_yn+'&st_type='+st_type, "590,670,no");
	} else if(column == "MAKER_NAME"){ 
		popupSel = "maker";
		var st_del_name = mySheet.GetCellValue(Row, "MAKER_NAME");
		openSearchPopup("/common/agentRegMakerCodePop.do", "?st_del_name="+st_del_name, "500,500,no");
	} else if(column == "BUYER_ITEM_NO"){
		popupSel = "item_code";
		var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
		var st_process_type = mySheet.GetCellValue(Row, "PROCESS_TYPE");
		if(st_process_type == 'RETURN_NEW_ITEM'){
			alert("견적제출에서는 카탈로그 변경을 할 수 없습니다.");
		}
		else if( st_buyer_item_no != "" && (st_process_type == "CHANGE_PRICE" || st_process_type == "CHANGE_ITEM" || st_process_type == "REGIST_ITEM")){
			openSearchPopup("/mdcm/showMasterMdCmBuyerCatalogAlterPop.do","?st_buyer_code=KRSAMS0123&st_catalog_com_code=KRSAMS0123&st_buyer_item_no="+st_buyer_item_no,"988,710,no");	
		}
	} else if(column == "CANCEL_REMARK_IMG"){	
		popupSel = "cancelRemark";
		var viewType="R";
		var cancel_remark = mySheet.GetCellValue(Row, "CANCEL_REMARK");
		openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType,"500,230,no");
	}

	return;
}

function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
		,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
		,value21,value22,value23,value24,value25,value26,value27,value28,value29,value30){

	if (popupSel == "stndCatlg"){
		mySheet.SetCellValue(grbRow, 'CMS_CATLG_ID', value1);
	} else if (popupSel == "commonCoCoBuyerCategoryChoicePop") {	// 카테고리팝업
		mySheet.SetCellValue(grbRow, 'CATEGORY_NO', value1);
		mySheet.SetCellValue(grbRow, 'CATEGORY_TEXT', value2);
	} else if(popupSel == "addImgPop") {	// 이미지첨부
		mySheet.SetCellValue(grbRow, 'IMGFILE_DIR', value1);
		mySheet.SetCellValue(grbRow, 'IMGFILE_NAME', value2);
		mySheet.SetCellValue(grbRow, 'IMGFILE_NAME_IMG', (value1!="")? diskOn : diskOff);
	} else if(popupSel == "maker") {
		$("#st_maker_code").val(value1);
		$("#st_maker_name").val(value2);
		$("#st_origin_code").val(value3);
		$("#st_origin_name").val(value4);
		
		mySheet.SetCellValue(grbRow, 'MAKER_CODE', value1);
		mySheet.SetCellValue(grbRow, 'MAKER_NAME', value2);
		mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value3);
		mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value4);
	} else if(popupSel == "cancelRemark") {	//견적 취소
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK_IMG', (value1!="")? cancelRemarkOn : cancelRemarkOff);
	}
	
	grbRow="";	//초기화
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>품목정보 I/F현황</h3>
		<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
	    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	</div>

	<!--조회영역-->
    <form name = "searchCondition" method = "post" onsubmit="return false" >
		<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_name_loc" name="st_user_name_loc"  value="${sessionInfo.userNameLoc}">
			<input type="hidden" id="job_kind" name="job_kind" value="">
			<input type="hidden" id="st_cancel_remark" name="st_cancel_remark" value="">
			<input type="hidden" id="st_suser_name" name="st_suser_name" value="">
			<input type="hidden" id="USR_ID" name="USR_ID"  value="${sessionInfo.userId}">

           	<table  class="cont_t_list01">
				<caption>품목정보I/F</caption>
				<colgroup>
					<col width="10%" />
					<col width="23%" />
					<col width="9%" />
					<col width="25%" />
					<col width="8%" />
                       <col width="23%" />
				</colgroup>

				<tbody>
					<tr>
						<th>I/F 일자</th>
						<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								-
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
								<input type="checkbox" class="Noborder" id="st_date_flag" name="st_date_flag" value="N" style="vertical-align:middle;text-align:center;"> 기간 무시
								<input type="hidden" id="st_date_flag_value" name="st_date_flag_value" value="N">
						</td>
						<th>처리결과</th>
						<td>
							<select id="st_result" name="st_result">
								<option value="">전체</option>
								<option value="Y">승인</option>
								<option value="N">거절</option>
								<option value="T">요청</option>
								<option value="E">오류</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>프로세스구분</th>
						<td>
							<select id="st_process_type" name="st_process_type" onchange="javascript:doAction('search');">
								<option value="ALL">전체</option>
								<option value="REGIST_ITEM">품목등록</option>
								<option value="CHANGE_ITEM">품목변경</option>
								<option value="CHANGE_PRICE">단가변경</option>
								<option value="RETURN_NEW_ITEM" selected>견적제출</option>
							</select>
						</td>
						<th>담당자</th>
						<td>
							<select id="st_suser_id" name="st_suser_id"></select>
						</td>
						<th>표준품목코드</th>
						</th>
						<td><input type="text" id="st_cms_catlg_id" name="st_cms_catlg_id" style="width:87%;" value="" onKeyDown="kepEnter()"></td>						
					</tr>
					<tr>
						<th>BQMS요청번호</th>
						</th>
						<td><input type="text" id="st_req_no" name="st_req_no" style="width:87%;" value="" onKeyDown="kepEnter()"></td>
						<th>고객사품목코드</th>
						</th>
						<td><input type="text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:87%;" value="" onKeyDown="kepEnter()"></td>

						<th>대행사요청번호
						</th>
						<td><input type="text" id="st_vendor_req_no" name="st_vendor_req_no" style="width:87%;" value="" onKeyDown="kepEnter()">
							<input type="hidden" class="Noborder" id="st_if_flag" name="st_if_flag" checked> 
							<input type="hidden" id="st_if_flag_value" name="st_if_flag_value" value="Y">
						</td>
					</tr>
					<tr>
						<th>SITE</th>
						<td>
							<input type="text" id="st_company_code" name="st_company_code"" style="width:87%"  value="" onKeyUp="kepToUpper('st_company_code')" onkeydown="kepEnter()">
						</td>
						<th>품의번호</th>
						<td>
							<input type="text" id="st_pm_no" name="st_pm_no"" style="width:87%"  value="" onKeyUp="kepToUpper('st_pm_no')" onkeydown="kepEnter()">
						</td>
						<th></th>
						<td></td>
					</tr>
				</tbody>
			</table>
		</div>

		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
        	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" style="width: 70px;" >
				<option value="10" selected>10건</option>
				<option value="50">50건</option>
				<option value="100">100건</option>
				<option value="200">200건</option>
			</select>
		</span>
		<span class="fl">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
		<span class="fl">
			<img src="/resources/images/icon_y.gif" style="padding-top:3px;"/>&nbsp;요청&nbsp;&nbsp;
			<img src="/resources/images/icon_g.gif" style="padding-top:3px;"/>&nbsp;승인&nbsp;&nbsp;
			<img src="/resources/images/icon_r.gif" style="padding-top:3px;"/>&nbsp;거절&nbsp;&nbsp;
		</span>
		<br>
	</form>

    <!--grid-->
   	<div class="ib_product" style="border-top:2px solid #3c639c">
		<script type="text/javascript">
			createIBSheet("mySheet", "100%", "333px");
		</script>
  	</div>
  	<p class="paging" id="pageindex"></p>

	<!--버튼영역-->
	<div class="btnArea">
  		<span class="fl">
  			<span class="btn_05 mr04" ><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  		</span>

  		<span class="fr">
  			<span class="btn_02" id="btnRegistItem" name="btnRegistItem" style="display:none;"><a href="javascript:doAction('registItem');">재등록</a></span>
  			<span class="btn_02" id="btnUpdateItem" name="btnUpdateItem" style="display:none;"><a href="javascript:doAction('update');">수정</a></span>
  			<span class="btn_02" id="btnRequotItem" name="btnRequotItem" style="display:none;"><a href="javascript:doAction('reQuotation');">재견적</a></span>
  			<span class="btn_02" id="btnResendPrice" name="btnResendPrice" style="display:none;"><a href="javascript:doAction('resendPrice');">단가재전송</a></span>
  			<span class="btn_02" id="btnDeleteItem" name="btnDeleteItem" style="display:none;"><a href="javascript:doAction('delete');">삭제</a></span>
  			<span class="btn_02" id="btnCancelItem" name="btnCancelItem" style="display:none;"><a href="javascript:doAction('cancel');">견적취소</a></span>
  		</span>
	</div>


<form name="catlgFlow" id="catlgFlow" method="post" action ="">
    <input type="hidden" name="catlg_desc_flow" id="catlg_desc_flow" value="">
    <input type="hidden" name="catlg_spec_flow" id="catlg_spec_flow" value="">
    <input type="hidden" name="catlg_maker_flow" id="catlg_maker_flow" value="">
    <input type="hidden" name="catlg_model_flow" id="catlg_model_flow" value="">
    <input type="hidden" name="catlg_row_num" id="catlg_row_num" value="">
    
    <input type="hidden" name="catlg_buyer" id="catlg_buyer" value="">
    <input type="hidden" name="catlg_quotation_no" id="catlg_quotation_no" value="">
    <input type="hidden" name="catlg_quotation_seq" id="catlg_quotation_seq" value="">
    <input type="hidden" name="catlg_revision" id="catlg_revision" value="">
    <input type="hidden" name="catlg_type" id="catlg_type" value="RQDT">
</form>
<!--내용 종료-->

</body>
</html>
