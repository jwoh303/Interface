<%--
**********************************************
* 메뉴 : 납품관리>납품진행현황
* 화면 : 납품 진행현황
* 기능 : 납품진행현황을 조회 할 수 있다.
* 프로그램 ID : SU0501001
* 담당자 : 최찬규
* 착수일 : 2025-09-15
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	String userID = _sessionInfo.getUserId();
	String menuId = (String) request.getParameter("menuId");
	if(myMenuListHeader != null){ //null이 아닌 경우에만 체크
		for(int i = 0; i<myMenuListHeader.size(); i++){
			if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
				myMenuFlag = true;
				break;
			}
		}
	}
%> 

<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

//최초 화면 함수 
function kep_onload_view(){

	//초기 날짜 셋팅
	if($("#st_from_date").val() ==  ""){
		$("#st_from_date").val(kepToMonthAdd("1","M"));
		$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
	}
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"PO_CREATE_DATE",		Header:"발주일",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			,{ Align:"Center",	SaveName:"STATUS_BUTTON",		Header:"진행상태",				Type:"Image",		Cursor:"Pointer",Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"STATUS",				Header:"진행상태",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PMNG_STATUS",			Header:"요청상태",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",				Type:"Text", FontColor:"#3a72c7", Cursor:"Pointer",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}							
			,{ Align:"Center",	SaveName:"BUYER_CODE",			Header:"고객사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
			,{ Align:"Center",	SaveName:"PROCESS_TYPE_TEXT",	Header:"거래유형",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"PO_NO",				Header:"발주번호",				Type:"Button",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type02'}
			,{ Align:"Center",	SaveName:"INV_NO",				Header:"거래명세서번호",			Type:"Button",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type02'}
			,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text", FontColor:"#3a72c7", Cursor:"Pointer",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"품목명",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"AGENT_PRICE",			Header:"단가",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Format:"${priceFormat}"}
			,{ Align:"Right",	SaveName:"ITEM_QTY",			Header:"발주수량",				Type:"Float",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"AGENT_AMT",			Header:"주문금액",				Type:"Float",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}
			,{ Align:"Right",	SaveName:"CD_QTY",				Header:"납품예정수량",				Type:"Float",			Width:90,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"INV_QTY",				Header:"납품수량",				Type:"Float",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			
			,{ Align:"Center",	SaveName:"RD_DATE",				Header:"고객수령희망일",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			,{ Align:"Center",	SaveName:"ST_DATE",				Header:"표준납품일",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,Format:"yyyy-MM-dd"}
			,{ Align:"Center",	SaveName:"DS_DATE",				Header:"납품예정일",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			,{ Align:"Center",	SaveName:"DS_DELAY_DAY",		Header:"지연일수",				Type:"Text",			Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"INVOICE_DATE",		Header:"납품일",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			,{ Align:"Center",	SaveName:"PARCEL_YN_TEXT",		Header:"배송유형",				Type:"Text",		Width:65,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"BFRE_STCK_YN",		Header:"선입고일자",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			,{ Align:"Left",	SaveName:"KEP_USER_INFO",		Header:"KeP담당자",			Type:"Text",		Width:160,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"PO_REMARK",			Header:"품목비고",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"PO_REMARK_2",			Header:"비고",		Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"LEGACY_PO_NO",		Header:"고객사발주번호",		Type:"Text",		Width:130,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"CONTRACT_NO",			Header:"CONTRACT_NO",		Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"CONTRACT_SEQ",		Header:"CONTRACT_SEQ",		Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SELLER",				Header:"SELLER",			Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"LEGACY_IV_SERIAL",	Header:"LEGACY_IV_SERIAL",	Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"TR_BUYER",			Header:"TR_BUYER",			Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",	Header:"BYIT_COMORG_CODE",	Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PORS_DATE",			Header:"PORS_DATE",			Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"IVDT_DATE",			Header:"거래명세서생성일",		Type:"Text",		Width:130,	Edit:false,	EditLen:100,	Hidden:false, Format:"yyyy-MM-dd"}
			,{ Align:"Center",	SaveName:"DELIVERY_ADD_DATE",	Header:"DELIVERY_ADD_DATE",	Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"DELIVERY_DATE",		Header:"납품실적등록일",		Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false, Format:"yyyy-MM-dd"}
			
			,{ Align:"Center",	SaveName:"REQ_CNT",				Header:"REQ_CNT",			Type:"Int",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"INIT_ABLE_YN",		Header:"INIT_ABLE_YN",		Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"INFO_CHANGE_REQ_YN",	Header:"INFO_CHANGE_REQ_YN",Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"AGENT",				Header:"AGENT",		Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PR_NO",				Header:"PR_NO",		Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PR_SEQ",				Header:"PR_SEQ",		Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PO_SEQ",				Header:"발주항번",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"DS_SEQ",				Header:"DS_SEQ",		Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"HD_DELY_TO_LOCATION",				Header:"도착지주소",		Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Left",	SaveName:"DELY_TO_LOCATION",				Header:"도착지주소",		Type:"Text",		Width:300,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Left",	SaveName:"MAKER_NAME",				Header:"제조사",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Left",	SaveName:"MAKER_PART_NO",				Header:"모델번호",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"거래유형",				Type:"Combo",		Width:90,	Edit:false,	EditLen:100,	Hidden:true,	ComboText:"직납|TR",	ComboCode:"0|2"}
			,{ Align:"Left",	SaveName:"SELLER_ITEM_NO",				Header:"협력사품목코드",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
			
	]
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	mySheet.SetHighlightAfterSort(2);
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");
	mySheet.SetHeaderBackColor("#f2f7ff");	
	
	mySheet.SetTheme("DB", "DeepBlue");
	
	doAction('search');
	
}

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	
	for(var i = 1; i<=mySheet.RowCount(); i++){
		if(mySheet.GetCellValue(i,"PMNG_STATUS")== "Y"){
			mySheet.SetCellEditable(i,"SELECTED",false);
			mySheet.SetToolTipText(i,"SELECTED","협력사 요청 건은 KeP 운영자가 확인하기 전에는 수정이 제한됩니다.");
		}
	}
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_status = mySheet.GetCellValue(Row, "STATUS");
	var st_buyer = mySheet.GetCellValue(Row, "BUYER_CODE");
	var st_po_no = mySheet.GetCellValue(Row, "PO_NO");
	var st_po_seq = mySheet.GetCellValue(Row, "PO_SEQ");
	var st_inv_no = mySheet.GetCellValue(Row, "INV_NO");
	var st_inv_seq = mySheet.GetCellValue(Row, "INV_SEQ");
	var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
	var st_contract_no = mySheet.GetCellValue(Row, "CONTRACT_NO");
	var st_contract_seq = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
	var st_seller = mySheet.GetCellValue(Row, "SELLER");
	var st_legacy_iv_serial = mySheet.GetCellValue(Row, "LEGACY_IV_SERIAL");
	var st_tr_buyer = mySheet.GetCellValue(Row, "TR_BUYER");
	var st_byit_comorg_code = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
	var st_invoice_date = mySheet.GetCellValue(Row,"INVOICE_DATE");
	var st_pors_date = mySheet.GetCellValue(Row,"PORS_DATE");
	var st_ivdt_date = mySheet.GetCellValue(Row,"IVDT_DATE");
	var st_delivery_add_date = mySheet.GetCellValue(Row,"DELIVERY_ADD_DATE");
	var param = "";
	
	if(column == "STATUS_BUTTON"){
		param = "?st_status="+st_status
		param += "&st_po_no="+st_po_no;
		param += "&st_inv_no="+st_inv_no;
		param += "&st_pors_date="+st_pors_date;
		param += "&st_ivdt_date="+st_ivdt_date;
		param += "&st_invoice_date="+st_invoice_date;
		param += "&st_delivery_add_date="+st_delivery_add_date;
		
        var src = "/mpiv/sellerMpIvDeliveryProgressStatusPop.do"+param; 
		openLayerPop(src,"650px","350px");
        
// 		openSearchPopup("/mpiv/sellerMpIvDeliveryProgressStatusPop.do", param, "650,350,no");
	}
	if(column == "BUYER_NAME"){
		var src = "/common/agentInfoDisplayPop.do?st_com_code="+st_buyer; 
		openLayerPop(src,"825px","700px");
		
// 		openSearchPopup("/common/agentInfoDisplayPop.do", '?st_com_code='+st_buyer, "825,700,no");
	}
	if(column == "PO_NO"){
		var src = "/mpiv/commonMpIvOrderInfoPop_v2.do?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status="+st_status; 
		openLayerPop(src,"1240px","850px");
		
// 		openSearchPopup("/mpiv/commonMpIvOrderInfoPop_v2.do", "?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status="+st_status, "1240,800,no");
	}
	if(column == "INV_NO"){
		if(st_inv_no != ""){
			param  = "?st_buyer="+st_buyer;
			param += "&st_po_no="+st_po_no;
			param += "&st_inv_no="+st_inv_no;
			param += "&st_seller="+st_seller;
			param += "&st_legacy_iv_serial="+st_legacy_iv_serial;
			param += "&st_tr_buyer="+st_tr_buyer;
			param += "&st_user_id="+$("#st_user_id").val();
			
			var src = "/mpiv/commonMpIvTranStatementDetailIVPop_v2.do"+param;
			openLayerPop(src,"1240px","910px");
// 			openSearchPopup("/mpiv/commonMpIvTranStatementDetailIVPop_v2.do", param, "1240,850,no");
		}
	}
	if(column == "BUYER_ITEM_NO"){
		var src = "/common/catalogDetailPop.do?open=Y&BUYER="+st_byit_comorg_code+"&BUYER_ITEM_NO="+escape(st_buyer_item_no)+"&CONTRACT_NO="+st_contract_no+"&CONTRACT_SEQ="+st_contract_seq+"&popupCheck=N";
		openLayerPop(src,"650px","600px");
// 		openSearchPopup("/common/catalogDetailPop.do","?open=Y&BUYER="+st_byit_comorg_code+"&BUYER_ITEM_NO="+escape(st_buyer_item_no)+"&CONTRACT_NO="+st_contract_no+"&CONTRACT_SEQ="+st_contract_seq,"650,600,no");
	}
	
	return;
}

function doAction(str) {
	switch (str) {
		case "search":	 //조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			var diff = kepGetDateDiff('st_from_date','st_to_date','D');
			if (eval(diff)>372){
// 				alert("1년 이내 조회만 가능합니다.");
				var text = "1년 이내 조회만 가능합니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			kepSearch(document.searchForm, mySheet, "/mpiv/getSellerMpIvDeliveryProgressStateList_v2.do" , pagingMode);
			
			break;
			
		case "reload":	//초기화
			kepReload_v2("searchForm");
			
			// hidden값은 공통에서 처리안됨.
			$("#st_buyer_code").val("");
			kepMonth_v2('st_from_date','st_to_date','3');
			mySheet.RemoveAll();
			break;
			
		case "excelDownload": // 엑셀다운로드
			excelDownload();
			break;
			
		case "request": //납품예정일 변경 요청
			setDsDateChangeRequest();
			break;
		case "request2": //수주접수 초기화 요청
			setIvInfoChangeRequest();
			break;
	}
}
// 팝업 함수호출
function doPop(str,value1, value2, value3, value4) {
	switch (str) {
		case "commonMpIvTranBuyerChoicePop": // 고객사선택
			openSearchPopup("/mpiv/getCommonMpIvTranBuyerChoicePop.do", "?st_com_code="+$("#st_com_code").val(), "750,530,no");
			break;
		case "ivInfoChange": // 수주접수 초기화요청
			popupSel = "ivInfoChange";
			var src = "/mpiv/showSellerMpIvIvInfoChangePop.do?value1="+encodeURIComponent(value1); 
			openLayerPop(src,"690px","450px");
			
// 			openSearchPopup("/mpiv/showSellerMpIvIvInfoChangePop.do", "?value1="+value1, "690,450,no");
			break;
		case "dsDateChange": //납품예정일 변경 요청
			popupSel = "dsDateChange";
// 			var src = "/mpiv/showSellerMpIvIvInfoChangePop.do?value1="+value1; 
// 			openLayerPop(src,"700px","830px");
			openSearchPopupPost("/mpiv/showSellerMpIvDsDateChangePop.do","dsDateChangeForm","dsDateChangeForm", "width=700,height=830,resizable=no,scrollbars=no, top=100, left=200");
			break;
	}
}

function setPopupReturn(value1){
	if(popupSel == "ivInfoChange" || popupSel == "dsDateChange"){
		if(value1 == "1"){ // 납품이슈현황으로 페이지 이동
			location.href = "/mpiv/showSellerMpIvDeliChangeReqList.do?menuId=sr00405000000";
			return;
		}else{
			doAction("search");
		}
	}
}

function setBuyerChoiceReturn(buyer, com_name){
	$("#st_buyer_code").val(buyer);
	$("#st_buyer_name").val(com_name);
}

function excelDownload(){
	if(mySheet.RowCount() == 0){
// 		alert("조회된 데이터가 없습니다.");
		var text = "조회된 데이터가 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
// 	var checkRows = mySheet.FindCheckedRow("SELECTED");
// 	var arrRow = checkRows.split("|");
	
// 	// 선택된 항목 유무 체크
// 	if (checkRows.length == 0) {
// // 		alert("상품을 선택해주세요.");
// 		var text = "항목을 선택해주세요.";
// 		openLayerPopText2(text,but1text,but1func,but1width);
// 		return;
// 	}
	
	mySheet.SetWaitImageVisible(true);
	
	var downRow = "|0";
	for(var i=1; i<=mySheet.RowCount(); i++) {
// 		if(mySheet.GetCellValue(i,"SELECTED"))
			downRow += "|"+i;
	}
	
	var downCol = "";
	for(var i=0; i<=mySheet.LastCol(); i++){
		if(!mySheet.GetColHidden(i) && mySheet.ColSaveName(i) !="SELECTED" && mySheet.GetCellProperty(1, i, "Type") != "Image"){
			downCol += "|"+i;
		}
	}
	downCol = downCol+"|STATUS|PO_SEQ|DELY_TO_LOCATION|MAKER_NAME|MAKER_PART_NO|BUYER_CODE|PROCESS_TYPE|SELLER_ITEM_NO";
	
	
	if(downRow == "|0"){
		downRow = "";
	}
	var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
	
	var param = {FileName:"납품진행현황_"+nowTime, SheetName:"납품진행현황", DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
	mySheet.Down2Excel(param);
}
//납품예정일 변경요청
function setDsDateChangeRequest(){
	if(mySheet.RowCount() == 0){
// 		alert("조회한 데이터가 없습니다.");
		var text = "조회된 데이터가 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	// 선택된 항목 유무 체크
	if (checkRows.length == 0) {
// 		alert("[납품예정일]을 변경할 항목을 선택해주세요.");
		var text = "[납품예정일]을 변경할 항목을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var rowList = new Array();
	var rowJson = "";
	var gridJsonList = "";
	
	for(var idx = 0; idx<arrRow.length;idx++){
		if(mySheet.GetCellValue(arrRow[idx],"PMNG_STATUS") == "Y"){
// 			alert("협력사 요청 건은 KeP 운영자가 확인하기 전에는 수정이 제한됩니다.");
			var text = "협력사 요청 건은 KeP 운영자가 확인하기 전에는 수정이 제한됩니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		if(mySheet.GetCellValue(arrRow[idx],"INFO_CHANGE_REQ_YN") == "Y"){
// 			alert("이미 수주접수 초기화요청건으로 현재 KEP에서 확인중입니다.");
			var text = "이미 수주접수 초기화요청건으로 현재 KEP에서 확인중입니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		if(mySheet.GetCellValue(arrRow[idx],"STATUS") != "거래명세서 생성대상"){
// 			alert("납품예정일 변경은 진행상태가 [거래명세서 생성대상]인 경우에만 요청이 가능합니다.");
			var text = "납품예정일 변경은 진행상태가 [거래명세서 생성대상]인 경우에만 요청이 가능합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		if(mySheet.GetCellValue(arrRow[idx],"REQ_CNT") > 0){
// 			alert("납품예정일은 승인 기준 1회만 변경 가능합니다.");
			var text = "납품예정일은 승인 기준 1회만 변경 가능합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		var org_date = mySheet.GetCellValue(arrRow[idx],"DS_DATE");
		var org_date_slash = kepGetDateStr(org_date, "/");
		$("#st_org_ds_date_text").val(org_date_slash);
		
		var cur_date = kepGetNowTimeStr("YYYYMMDD","");
		var cur_date_slash = kepGetNowTimeStr("YYYYMMDD","/");
		$("#st_cur_date_text").val(cur_date_slash);
		
		var org_date_day = new Date(org_date_slash).getDay();
		var term = 0;
		if(org_date_day == 1){ // 기존 납품예정일이 월요일(1)이면 전주 금요일(D-4)도 불가
			term = 4;
		}else{ // 이 외 전일 체크
			term = 2;
		}
		
		if(kepGetDateDiff('st_cur_date_text','st_org_ds_date_text','D') < term){
// 			alert("영업일 기준 2일전까지만 변경요청이 가능합니다.");
			var text = "영업일 기준 2일전까지만 변경요청이 가능합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		var param = {
				"BUYER_NAME" : mySheet.GetCellValue(arrRow[idx],"BUYER_NAME")
				,"BUYER_CODE" : mySheet.GetCellValue(arrRow[idx],"BUYER_CODE")
				,"PO_NO" : mySheet.GetCellValue(arrRow[idx],"PO_NO")
				,"PO_SEQ" : mySheet.GetCellValue(arrRow[idx],"PO_SEQ")
				,"PR_NO" : mySheet.GetCellValue(arrRow[idx],"PR_NO")
				,"PR_SEQ" : mySheet.GetCellValue(arrRow[idx],"PR_SEQ")
				,"DS_SEQ" : mySheet.GetCellValue(arrRow[idx],"DS_SEQ")
				,"AGENT" : mySheet.GetCellValue(arrRow[idx],"AGENT")
				,"DS_DATE" : mySheet.GetCellValue(arrRow[idx],"DS_DATE")
				,"BUYER_ITEM_NO" : mySheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO")
				,"AGENT_AMT" : mySheet.GetCellValue(arrRow[idx],"AGENT_AMT")
			};
		rowJson = JSON.stringify(param);
		rowList.push(rowJson);
	}
	
	gridJsonList =  "[" + rowList.toString() + "]";
	
	popupSel = "dsDateChange";
	var url = "/mpiv/showSellerMpIvDsDateChangePop.do";
	openLayerPop3(url,gridJsonList,"","700px","830px");
}
//수주접수 초기화요청
function setIvInfoChangeRequest(){
	
	var query   = "";
	
	var buyer			= "";
	var po_no			= "";
	var agent			= "";
	var status			= "";
	var init_able		= "";
	var info_change_req_yn = "";

	if(mySheet.RowCount() == 0){
// 		alert("조회한 데이터가 없습니다.");
		var text = "조회한 데이터가 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	// 선택된 항목 유무 체크
	if (checkRows.length == 0) {
// 		alert("[수주접수 초기화]할 항목을 선택해주세요.");
		var text = "[수주접수 초기화]할 항목을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	for(var idx = 0; idx<arrRow.length; idx++){
		buyer           = mySheet.GetCellValue(arrRow[idx],"BUYER_CODE");
		po_no           = mySheet.GetCellValue(arrRow[idx],"PO_NO");
		agent			= mySheet.GetCellValue(arrRow[idx],"AGENT");
		status			= mySheet.GetCellValue(arrRow[idx],"STATUS");
		init_able		= mySheet.GetCellValue(arrRow[idx],"INIT_ABLE_YN");
		info_change_req_yn		= mySheet.GetCellValue(arrRow[idx],"INFO_CHANGE_REQ_YN");
		
		if(mySheet.GetCellValue(arrRow[idx],"PMNG_STATUS") == "Y"){
// 			alert("협력사 요청 건은 KeP 운영자가 확인하기 전에는 수정이 제한됩니다.");
			var text = "협력사 요청 건은 KeP 운영자가 확인하기 전에는 수정이 제한됩니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		if(info_change_req_yn == "Y"){
// 			alert("이미 수주접수 초기화요청건으로 현재 KEP에서 확인중입니다.");
			var text = "이미 수주접수 초기화요청건으로 현재 KEP에서 확인중입니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		if(init_able == "N" || status != "거래명세서 생성대상"){
// 			alert("수주접수 초기화는 발주번호 내 모든 항목의 진행상태가 [거래명세서 생성대상]인 경우에만 요청이 가능합니다.");
			var text = "수주접수 초기화는 발주번호 내 모든 항목의 진행상태가 [거래명세서 생성대상]인 경우에만 요청이 가능합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		query +=  buyer			+ "@@";
		query +=  po_no			+ "@@";
		query +=  agent;
		query +=  "^||^" ;
	}
			
	doPop('ivInfoChange', query);
	
}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "btnCreate"){
// 		alert("변경요청이  정상적으로 완료 되었습니다.");
		var text = "변경요청이  정상적으로 완료 되었습니다.";
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
// 		doAction("search");
	}
	
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
	return;
}
function thisPopClose(){
	closePopText2();
	doAction("search");
}
</script>
</head>
<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader_sub_v2"/>
<c:param name="part" value="header_v2"/>
</c:import>
<div id="container2">
<c:import charEncoding="utf-8" url="/main/leftMenuData.do">
<c:param name="page" value="sellerLeft_v2"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<!-- 컨텐츠 -->
	<div class="containerBoxSub" >
      <div class="PDleft50"><!--padding-left:50px; 시작 -->    
		<div class="SubTit">
		<%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star"></button>
     	<%} %>
          납품진행현황
          <div class="SummaryGuide">
      	    <ul>
        	  <li><img src="/resources/imgs/Icon_Home.png" /></li>
              <li>납품관리</li>
              <li>납품진행현황</li>
            </ul>
          </div>
        </div>
        <form id="searchForm" name="searchForm" method="post">
        <input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_org_ds_date_text" id="st_org_ds_date_text" value="">
		<input type="hidden" name="st_cur_date_text" id="st_cur_date_text" value="">
		
        <div class="containerSub"><!--margin-right:50px; 설정 -->  
          <div class="Importance01"><img src="/resources/imgs/Icon_Importance.png" /> 발주된 주문건의 진행현황을 확인하실 수 있습니다. 진행상태 플래그를 선택 하시면 현재 진행현황을 확인할 수 있습니다.  </div> 
          <table class="SearchTable03" >
            <colgroup>
              <col width="80px" />
              <col width="550px" />
              <col width="80px" />
              <col width="250px" />
              <col width="80px" />
              <col width="240px" />
            </colgroup>        	
            <tr>
              <th>기간</th>
              <td>
                <select name="st_date_type" class="Select" style=" float:left;width:130px; margin-right:5px">
                  <option value="st_po_create_date" selected>발주일</option>
                  <option value="st_rd_date" >고객수령희망일</option>
                  <option value="st_ds_date" >납품예정일</option>
                  <option value="st_ivdt_add_date">거래명세서생성일</option>
                  <option value="st_delivery_date">납품실적등록일</option>
                </select>
                <div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date" name="st_from_date" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date" name="st_to_date" readonly /><span></span></div>
                </div>
                <button class="But_MonthSmall" style="width: 58px;" data-group="tab0" onclick="javascript:kepMonth_v2('st_from_date','st_to_date','1'); return false;">1개월</button> 
                <button class="But_MonthSmall" style="width: 58px;" data-group="tab0" onclick="javascript:kepMonth_v2('st_from_date','st_to_date','2'); return false;">2개월</button>
                <button class="But_MonthSmall" style="width: 58px;" data-group="tab0" onclick="javascript:kepMonth_v2('st_from_date','st_to_date','3'); return false;">3개월</button>
                <button class="But_MonthSmall" style="width: 58px;" data-group="tab0" onclick="javascript:kepMonth_v2('st_from_date','st_to_date','12'); return false;">1년</button>
              </td>
              <th>진행상태</th>
              <td><select name="st_status" id="st_status" class="Select" style="width:220px;">
                  <option value="ALL" selected>전체</option>
                  <option value="수주접수대상">수주접수대상</option>
                  <option value="거래명세서 생성대상">거래명세서 생성대상</option>
                  <option value="납품실적 등록대상">납품실적 등록대상</option>
                  <option value="납품완료">납품완료</option>
                </select> 
              </td>
              <th>고객사</th>
              <td><div class="SearchBuyer" style="width:230px ">
                  <input type="text" placeholder=" " id="st_buyer_name" name="st_buyer_name" style=" width:85%; " onKeyDown="kepEnter_v2();">
<!--                   <input type="hidden" name="st_buyer_code" id="st_buyer_code" value=""> -->
<!--                   <button type="button" onclick="javascript:doPop('commonMpIvTranBuyerChoicePop'); return false;">고객사명</button> -->
                </div>
			  </td>
			</tr>
            <tr>
              <th>발주번호</th>
              <td>
              <select name="st_po_type" class="Select" style=" float:left;width:95px; margin-right:5px">
                  <option value="kep_po_no" selected>KEP</option>
                  <option value="legacy_po_no" >고객사</option>
                </select>
              <input class="input30" style="width:460px;" name="st_po_no" id="st_po_no" type="text" placeholder="여러 개의 발주번호로 조회 가능하며 띄어쓰기 없이 콤마(,)로 구분해서 입력해주세요."  onKeyDown="kepEnter_v2();"/></td>
              <th>배송유형</th>
              <td><select name="st_parcel_yn_text" id="st_parcel_yn_text" class="Select" style="width:220px;">
                  <option value="" selected>전체</option>
                  <option value="자차">자차</option>
                  <option value="택배">택배</option>
                </select> 
              </td>
              <th>지연여부</th>
              <td><select name="st_delay_yn" id="st_delay_yn" class="Select" style="width:232px;">
                  <option value="" selected>전체</option>
                  <option value="Y">Y</option>
                  <option value="N">N</option>
                </select> 
              </td>   
            </tr>
            <tr> 
              <th>품목명</th>
              <td><input class="input30" style="width:560px" name="st_description" id="st_description" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>품목코드</th>
              <td><input class="input30" style="width:198px" name="st_buyer_item_no" id="st_buyer_item_no" type="text" onKeyDown="kepEnter_v2()"/></td>                                                    
              <th>선입고여부</th>
              <td><select name="st_bfre_stck_yn" id="st_bfre_stck_yn" class="Select" style="width:232px;">
                  <option value="" selected>전체</option>
                  <option value="S">Y</option>
                  <option value="N">N</option>
                </select> 
              </td> 
            </tr>
          </table>
          <div class="SearchBtnBoxNoTab">
         	<button class="ButSmall_Outline" onclick="javascript:doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="javascript:doAction('search'); return false;">조회</button> 
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40" onclick="javascript:doAction('excelDownload'); return false;">엑셀다운로드</button>
            				<button class="ButOutline_Medium" onclick="javascript:doAction('request'); return false;">납품예정일 변경</button>
              				<button class="ButOutline_Medium" onclick="javascript:doAction('request2'); return false;">수주접수 초기화</button>
            </div>
            <div class="right"></div>
          </div>          
          <div class="IBSheet">
          	<script type="text/javascript">
          		createIBSheet("mySheet", "", "100%");
          	</script>
          </div><!--IBSheet 끝 --> 
          <div class="h50"></div>  
        </div><!-- containerSub 끝 -->
        </form>
        
        <form name="dsDateChangeForm" id="dsDateChangeForm" method="post">	
			<input type="hidden" name="info" id="info"  value="">
		</form> 
      </div> <!--padding-left:50px; 끝 -->
    </div><!--containerBoxSub-->
	<script>
    
    const inputs = document.querySelectorAll("input[name=st_po_no],input[name=st_description],input[name=st_buyer_item_no]");
    inputs.forEach(function(input){
    	  input.addEventListener("input",function(){
    		  this.value = this.value.trimStart();
    	  });
      });
    </script> 
<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter_sub_v2.jsp" %> 
</div>
</body>
</html>