<%--
**********************************************
* 메뉴 : 
* 화면 : CI 등록 팝업
* 기능 : 
* 프로그램 ID :
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/wms_tr_sheet.js"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
</head>
<%
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),""); // 고객사코드
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var searchOn = "/resources/images/btn_search03.gif";
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
		      			{Align : "Center", SaveName :"SELECTED",          Header:"|",				Type : "DummyCheck",     Width : 30,  SaveName:"SELECTED",  Edit : true},
		      			{Align : "Center",SaveName : "sStatus",	Header : "상태|상태",	Type : "Status",	Width : 60,	Hidden : 1},
		    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명|품목명",	Type : "Text",	Width : 140, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드|품목코드",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden:false},
		    			{Align : "Right",SaveName : "PKG_GR_QTY",		Header : "입고수량|입고수량",	Type:"Float", Format:"${qtyFormat}", Width : 60, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "GI_PKG_CI_QTY",		Header : "기출고수량|기출고수량",	Type:"Float", Format:"${qtyFormat}", Width : 60, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "PKG_CI_QTY",		Header : "Enter per packing unit|Qty",	Type:"Float", Format:"${qtyFormat}", Width : 70, EditLen : 110,	Edit : true, Hidden : false, BackColor:"${notnullColor}"},
		    			{Align : "Right",SaveName : "N_WEIGHT",		Header : "Enter per packing unit|Net Weight",	Type:"Float", Format:"${qtyFormat}", Width : 55, EditLen : 110,	Edit : true, Hidden : false, BackColor:"${notnullColor}"},
		    			{Align : "Right",SaveName : "G_WEIGHT",		Header : "Enter per packing unit|Gross Weight",	Type:"Float", Format:"${qtyFormat}", Width : 85, EditLen : 110,	Edit : true, Hidden : false, BackColor:"${notnullColor}"},
		    			{Align : "Right",SaveName : "CBM",		Header : "Enter per packing unit|CBM",	Type:"Float", Format:"${qtyFormat}", Width : 70, EditLen : 100,	Edit : true, Hidden : false, BackColor:"${notnullColor}"},
		    			{Align : "Right",SaveName : "CTN_FROM",		Header : "Enter per packing unit|CTNNo.From",	Type:"Float", Format:"${qtyFormat}", Width : 70, EditLen : 110,	Edit : true, Hidden : false, BackColor:"${notnullColor}"},
		    			{Align : "Right",SaveName : "CTN_TO",		Header : "Enter per packing unit|CTNNo.To",	Type:"Float", Format:"${qtyFormat}", Width : 70, EditLen : 110,	Edit : true, Hidden : false, BackColor:"${notnullColor}"},
		    			{Align : "Center",SaveName : "LOT_IMG",		Header : "Enter per packing unit|Lot",	Type:"Image",  Width : 50, EditLen : 110,	Edit : false, Hidden : false, BackColor:"${optColor}"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"BUYER"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"INV_SEQ"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"PROCESS_TYPE"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"LOT"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"PKG_CI_QTY_2"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"AGENT"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"EXP_CUR"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float",		Header:"", SaveName:"EXP_FOR_UNIT_PRICE"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"LEGACY_PO_NO"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"LEGACY_PO_SEQ"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"SPECIFICATION"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"UNIT_MEASURE"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"MAKER_NAME"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"INV_NO"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"PO_NO"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"PO_SEQ"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"OVERSEA_TO_LOCATION"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float",		Header:"", SaveName:"TOTAL_CI_QTY"}
						
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetImageList(1, searchOn);
	// mySheet2
	var initsheet2 = {};
	initsheet2.Cols = [ 
					{ Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:30,	Edit : true,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Left",	Width:250,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주부서", SaveName:"PURCHASE_DEPT"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
					,{ Align:"Left",	Width:180,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
					,{ Align:"Left",	Width:220,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"Integer",  Header:"입고수량", 	SaveName:"PKG_GR_QTY"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"Integer",  Header:"기출고수량", 	SaveName:"GI_PKG_CI_QTY"}
					,{ Align:"Right",	Width:85,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"Integer",  Header:"출고가능수량", 	SaveName:"PKG_CI_QTY"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"INV_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"INV_SEQ"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"PO_NO"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"PO_SEQ"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"PURCHASER_DEPT_CD"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"EXP_CUR"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float",		Header:"", SaveName:"EXP_FOR_UNIT_PRICE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"PROCESS_TYPE"}
					
	];
	
	IBS_InitSheet(mySheet2, initsheet2,pagingMode);
	
	kepAjaxCommonQueryIdSearchTwoCombo('st_forwarder','getSrsysTypeList','EP01','','SEL','');
	kepAjaxCommonQueryIdSearchTwoCombo('st_ship_method','getSrsysTypeList','EP02','','SEL','');
	kepAjaxCommonQueryIdSearchTwoCombo('st_incoterms','getSrsysTypeList','EP03','','SEL','');
	kepAjaxCommonQueryIdSearchTwoCombo('st_incoterms_dealy','getSrsysTypeList','EP04','','SEL','');
	kepAjaxCommonQueryIdSearchTwoCombo('st_packing','getSrsysTypeList','EP05','','SEL','');
	kepAjaxCommonQueryIdSearchTwoCombo('st_packing_weight','getSrsysTypeList','EP06','','SEL','');
	kepAjaxCommonQueryIdSearchTwoCombo('st_payment_term','getSrsysTypeList','EP08','','SEL','');
	
	setLinkCol(mySheet, "LOT_IMG");
	//하이퍼링크 설정
	kepSetCalender("st_inv_date");
	kepSetCalender("st_etd_date");
	//초기값 셋팅.
	$("#st_incoterms").val("FOB");
	$("#st_incoterms_dealy").val("KR");
	kepSearch(document.searchCondition ,  mySheet , "/exiv/getExportExIvExportCiProcDetail.do" ,pagingMode );
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "ciCheck": // CI 체크
			// 중복 확인 시 C/I번호 공백제거
			var st_ci_no = $("#st_ci_no").val();			
			$("#st_ci_no").val(st_ci_no.trim());			
			if (isEmpty($("#st_ci_no").val())) {
				alert("C/I No를 입력해 주십시요");
				$("#st_ci_no").focus();				
				return;
			} else {
				kepAjaxFormCall("/exiv/getExportExIvExporCICheck.do","searchCondition","ciCheck");
			}	
			break;
		case "search":	 // 조회
			kepSearch(document.searchCondition,  mySheet2 , "/exiv/getExportExIvExportCiItemList.do" , pagingMode );
			break;
		case "save": // 저장
			//C/I, P/L 데이터 체크
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow = selectedGrid.split("|");
			if (selectedGrid.length == 0){
				alert("선택한 행이 없습니다.");
				return;
			}else{
				//행추가시 데이터 셋팅.
				for(var i=0; i<arrRow.length; i++){
					var st_inv_no = mySheet.GetCellValue(arrRow[i],"INV_NO");
					var st_buyer = mySheet.GetCellValue(arrRow[i],"BUYER");
					var st_inv_qty = 0;
					var st_gi_qty = 0;
					var total_ci_qty = 0; 
					for(var j=0; j<arrRow.length; j++){
						if(st_inv_no == mySheet.GetCellValue(arrRow[j],"INV_NO")){
							//INVOICE 기준 TOTAL 출고수량
							total_ci_qty = total_ci_qty+mySheet.GetCellValue(arrRow[j],"PKG_CI_QTY");
							st_gi_qty =st_gi_qty+ mySheet.GetCellValue(arrRow[j],"GI_PKG_CI_QTY");
							st_inv_qty =st_inv_qty+ mySheet.GetCellValue(arrRow[j],"PKG_GR_QTY");
						}
					}
					//INVOICE 기준 출고수량 체크
					if(total_ci_qty+st_gi_qty > st_inv_qty){
						alert(st_inv_no+" 납품수량 초과하여 출고수량을 입력 했습니다.");
						return;
					}
					//INVOICE 기준 TOTAL 출고수량 셋팅
					mySheet.SetCellValue(arrRow[i], 'TOTAL_CI_QTY', total_ci_qty);
				}
			}
			// 저장 시 C/I번호 공백제거
			var st_ci_no = $("#st_ci_no").val();			
			$("#st_ci_no").val(st_ci_no.trim());
			
			//필수값 체크.
			if ($("#ci_check_flag").val() == "N") {
				alert("C/I No 중복 검사를 먼저 해 주십시요");
				return;
			}
			if($("#st_inv_date").val() ==""){
				alert("C/I Date 입력 바랍니다.");
				$("#st_inv_date").focus();
				return;
			}
			if($("#st_shipper").val() ==""){
				alert("Shipper / Exporter 입력 바랍니다.");
				$("#st_shipper").focus();
				return;
			}
			if(st_buyer == "KRSAMS0123") {
				if($("#st_notify_party").val() ==""){
					alert("Notify Party 입력 바랍니다.");
					$("#st_notify_party").focus();
					return;
				}
			}
			if($("#st_forwarder").val() ==""){
				alert("Forwarder 입력 바랍니다.");
				$("#st_forwarder").focus();
				return;
			}
			if($("#st_ship_method").val() ==""){
				alert("Ship method 입력 바랍니다.");
				$("#st_ship_method").focus();
				return;
			}
			if($("#st_incoterms").val() ==""){
				alert("Incoterms 입력 바랍니다.");
				$("#st_incoterms").focus();
				return;
			}
			if($("#st_incoterms_dealy").val() ==""){
				alert("Incoterms 입력 바랍니다.");
				$("#st_incoterms_dealy").focus();
				return;
			}
			if (!kepIsNumberString(kepTrimStr($("#st_packing_qty").val()))) {
				alert("Packing Qty는 숫자만 입력 가능합니다.");
				$("#st_packing_qty").focus();
				return;
			}
			if($("#st_packing_qty").val() ==""){
				alert("Packing Qty 입력 바랍니다.");
				$("#st_packing_qty").focus();
				return;
			}
			if($("#st_packing").val() ==""){
				alert("Packing Unit 입력 바랍니다.");
				$("#st_packing").focus();
				return;
			}
			if($("#st_packing_weight").val() ==""){
				alert("Weight 입력 바랍니다.");
				$("#st_packing_weight").focus();
				return;
			}
			if($("#st_payment_term").val() ==""){
				alert("Payment Terms 입력 바랍니다.");
				$("#st_payment_term").focus();
				return;
			}
			if($("#st_port").val() =="" || $("#st_port").val() == null){
				alert("Port of Loading 입력 바랍니다.");
				$("#st_departure").focus();
				return;
			}
			if($("#st_destination").val() =="" || $("#st_destination").val() == null){
				alert("Final Destination 입력 바랍니다.");
				$("#st_destination").focus();
				return;
			}
	 	   kepSaveAll(document.searchCondition ,  mySheet , "/exiv/saveExportExIvExportReceipt.do");
			break;			
	}

}
/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	if (pMethod == "ciCheck") {
		if (sMsg == 'OK') {
			alert("사용가능한 C/I No 입니다.");
			$("#ci_check_flag").val("Y");
			return;
		} else {
			alert("이미 사용하고 있는 C/I No 입니다. 다른 C/I No를 입력하세요.");
			$("#ci_check_flag").val("N");
			$("#st_ci_no").val("");
			$("#st_ci_no").focus();
			return;
		}
	}
}
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
function mySheet2_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
function mySheet_OnSearchEnd(code, msg, stCode) {
	//해외배송처 셋팅
	$("#st_notify_party").val(mySheet.GetCellValue(2,"OVERSEA_TO_LOCATION"));
	loader_obj("N");

}
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");

}
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	//입고정상 등록
	if(msg == "OK"){
		alert("C/I, P/L 생성 되었습니다.");
		opener.doAction("search");
		this.close();
	}else{
		if (msg != "") {
			alert(msg);
			doAction('search');
		}		
	}
}
//트랜젝션(저장,삽입등) 후처리
function mySheet2_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
}
//페이지 인덱스 눌렀을 경우 조회


//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;
	if(column =="LOT_IMG"){
		var st_lot = mySheet.GetCellValue(Row,"LOT");
		var params= "?st_lot_info="+st_lot;
		doPop("lotPop", params);
	}

	return;
}
//팝업함수호출
function doPop(str, params) {
	popupSel = str;
	switch (str) {
		case "lotPop": // LOT 정보
			openSearchPopup("/exiv/showExportExIvCiLotRegPop.do", params, "450,300,no");
			break;
		case "acc": //Acc
			var params= "?st_com_code="+document.searchCondition.st_buyer.value+"&st_type=EP01&st_title=ForAcc/RiskofMessrs";
			openSearchPopup("/exiv/exportExIvIcomCodPop.do", params, "500,450,no");
			break;
	}
}


//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	if(popupSel == "lotPop") {	//Lot 정보입력
		mySheet.SetCellValue(grbRow, "LOT", value1);
	}else if(popupSel == "acc") {	//Acc
			document.searchCondition.st_acc_code.value = value1;
			document.searchCondition.st_acc_name.value = value2;
	}
}
//C/I, P/L행삭제
function delCheckedItem(){
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	if (selectedGrid.length == 0){
		alert("선택한 행이 없습니다.");
		return;
	}else{
		for ( var i = mySheet.RowCount()+2; i >= 2; i--) {
			  if (mySheet.GetCellValue(i,'SELECTED') == '1') {
				  mySheet.RowDelete(i);
			  }
			}		
	}
}
//C/I, P/L행추가
function addCheckedItem(){
	var selectedGrid = mySheet2.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	if (selectedGrid.length == 0){
		alert("선택한 행이 없습니다.");
		return;
	}else{
		//행추가시 데이터 셋팅.
		for(var i=0; i<arrRow.length; i++){
			var st_buyer = mySheet2.GetCellValue(arrRow[i],"BUYER");
			var st_dec = mySheet2.GetCellValue(arrRow[i],"DESCRIPTION");
			var st_inv_no = mySheet2.GetCellValue(arrRow[i],"INV_NO");
			var st_inv_qty = mySheet2.GetCellValue(arrRow[i],"PKG_GR_QTY");
			var st_gi_qty = mySheet2.GetCellValue(arrRow[i],"GI_PKG_CI_QTY");
			var st_ci_qty = mySheet2.GetCellValue(arrRow[i],"PKG_CI_QTY");
			var st_inv_seq = mySheet2.GetCellValue(arrRow[i],"INV_SEQ");
			var st_po_no = mySheet2.GetCellValue(arrRow[i],"PO_NO");
			var st_po_seq = mySheet2.GetCellValue(arrRow[i],"PO_SEQ");
			var st_process_type = mySheet2.GetCellValue(arrRow[i],"PROCESS_TYPE");
			var st_exp_unit_price = mySheet2.GetCellValue(arrRow[i],"EXP_FOR_UNIT_PRICE");
			var st_exp_cur = mySheet2.GetCellValue(arrRow[i],"EXP_CUR");
			var st_buyer_item_no = mySheet2.GetCellValue(arrRow[i],"BUYER_ITEM_NO");
			
			var rows = mySheet.DataInsert(-1);
			mySheet.SetCellValue(rows, 'SELECTED', "1");
			mySheet.SetCellValue(rows, 'LOT_IMG', "1");
			mySheet.SetCellValue(rows, 'DESCRIPTION', st_dec);
			mySheet.SetCellValue(rows, 'INV_NO', st_inv_no);
			mySheet.SetCellValue(rows, 'PKG_GR_QTY', st_inv_qty);
			mySheet.SetCellValue(rows, 'GI_PKG_CI_QTY', st_gi_qty);
			mySheet.SetCellValue(rows, 'PKG_CI_QTY', st_ci_qty);
			mySheet.SetCellValue(rows, 'BUYER', st_buyer);
			mySheet.SetCellValue(rows, 'INV_SEQ', st_inv_seq);
			mySheet.SetCellValue(rows, 'PO_NO', st_po_no);
			mySheet.SetCellValue(rows, 'PO_SEQ', st_po_seq);
			mySheet.SetCellValue(rows, 'PROCESS_TYPE', st_process_type);
			mySheet.SetCellValue(rows, 'EXP_FOR_UNIT_PRICE', st_exp_unit_price);
			mySheet.SetCellValue(rows, 'EXP_CUR', st_exp_cur);
			mySheet.SetCellValue(rows, 'BUYER_ITEM_NO', st_buyer_item_no);
		}
	}
}
function setDepartDestPort(){
	var st_buyer = $("#st_pkg_cmpy_no").val();
	var st_ship_method = kepSelectOptionVal('st_ship_method');
	var st_ship_method_substr = st_ship_method.substring(0,3);
	
	if(st_ship_method_substr == ''){
		kepAjaxCommonQueryIdSearchThreeCombo('st_port','comCodeIljinPopSearchAct',st_buyer,'POTD','XXX','');
		kepAjaxCommonQueryIdSearchThreeCombo('st_destination','comCodeIljinPopSearchAct',st_buyer,'POTA','XXX','');
	}else{
		kepAjaxCommonQueryIdSearchThreeCombo('st_port','comCodeIljinPopSearchAct',st_buyer,'POTD',st_ship_method_substr,'');
		kepAjaxCommonQueryIdSearchThreeCombo('st_destination','comCodeIljinPopSearchAct',st_buyer,'POTA',st_ship_method_substr,'');	
	}
}
</script> 
<body onload="kep_onload_view();">
<form name="searchCondition" id="searchCondition" method = "post">
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_pkg_cmpy_no" name="st_pkg_cmpy_no"  value="${sessionInfo.comCode}">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=CommonUtil.nvl((String) request.getParameter("st_buyer"),"") %>">
	<input type="hidden" id="st_po_no"  name="st_po_no" value="<%=CommonUtil.nvl((String) request.getParameter("st_po_no"),"") %>">
	<input type="hidden" id="st_po_seq"  name="st_po_seq" value="<%=CommonUtil.nvl((String) request.getParameter("st_po_seq"),"") %>">
	<input type="hidden" id="st_inv_no"  name="st_inv_no" value="<%=CommonUtil.nvl((String) request.getParameter("st_inv_no"),"") %>">
	<input type="hidden" id="st_inv_seq"  name="st_inv_seq" value="<%=CommonUtil.nvl((String) request.getParameter("st_inv_seq"),"") %>">
	<input type="hidden" id="st_dept"  name="st_dept" value="<%=CommonUtil.nvl((String) request.getParameter("st_dept"),"") %>">
	<input type="hidden" id="st_eta_date"  name="st_eta_date" value="">
	<input type="hidden" id="ci_check_flag" name="ci_check_flag" value="N" />
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">C/I, P/L 등록</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"   style="height:448px;">
        	<!--버튼영역-->
            <!--조회영역-->
            	<table class="cont_t_list07" style="width:100%;">
						<caption>조회</caption>
						<colgroup>
							<col width="20%" />
							<col width="30%" />
							<col width="20%" />
							<col width="30%" />
						</colgroup>
						<tbody>
						<tr>
							<th><font color="#FF6600">*</font>C/I No</th>
							<td>
								<input type="text" name="st_ci_no"  id="st_ci_no" class="al"   onkeyup="kepToUpper('st_ci_no');" value =""  style="width:60%;"/>
								<a href="javascript:doAction('ciCheck');"><span class="TJoinbtn" title="중복검사">중복확인</span></a></td>
							</td>
							<th><font color="#FF6600">*</font>C/I Date</th>
							<td >
								<input type="text" class="al" name="st_inv_date" id="st_inv_date" readOnly  />
								<a href="javascript:kepCalendar('st_inv_date')"></a>
							</td>
						 </tr>
						<tr>
							<th>Sailing on or about</th>
							<td>
								<input type="text" class="al" name="st_etd_date" id="st_etd_date" readOnly  />
								<a href="javascript:kepCalendar('st_etd_date')"></a>
							</td>
							<th><font color="#FF6600">*</font>Ship method</th>
							<td >
								<select id="st_ship_method" name="st_ship_method"  style="width:80%;" onChange="setDepartDestPort();"/></select>
							</td>
						 </tr>
						<tr>
                  			<th >Port of Loading</th>
					  		<td >
					  			<select id="st_port"  name="st_port" style="width:80%;height:20px">
					  		</td>
							<th>Final Destination</th>
							<td >
							<select id="st_destination"  name="st_destination" style="width:80%;height:20px">
							</td>
						 </tr>
						<tr>
							<th>For Acc & Risk of Messrs</th>
							<td >
								<input type="text" name="st_acc_name" id="st_acc_name" class="input_type_text" title="" style="width:70%;"/>
								<input type="hidden" name="st_acc_code" id="st_acc_code" style="width:80%" value="">
		                        <a href="javascript:doPop('acc');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_acc_code','st_acc_name');"><img src="/resources/images/btn_eraser2.gif"></a>	
							</td>
                  			<th >
                  			<%if(st_buyer.equals("KRSAMS0123")) { %>
                  			<font color="#FF6600">*</font>
                  			<% } else {%>
                  			<% } %>
                  			Notify Party</th>
					  		<td >
								<input type="text" name="st_notify_party"  id="st_notify_party" class="al"   value =""  style="width:90%;"/>
					  		</td>
						 </tr>
						<tr>
							<th>Carrier</th>
							<td >
								<input type="text" name="st_carrier"  id="st_carrier" class="al"   value =""  style="width:90%;"/>
							</td>
                  			<th ><font color="#FF6600">*</font>Forwarder</th>
					  		<td >
								<select id="st_forwarder" name="st_forwarder"  style="width:80%;"/></select>
					  		</td>
						 </tr>
						<tr>
                  			<th ><font color="#FF6600">*</font>Shipper / Exporter</th>
					  		<td >
					  			<input type="text" name="st_shipper"  id="st_shipper" class="al"   value ="KOREA E PLATFORM CO., LTD."  style="width:90%;"/>
					  		</td>
                  			<th ><font color="#FF6600">*</font>Incoterms</th>
					  		<td >
					  			<select id="st_incoterms" name="st_incoterms"  style="width:40%;"/></select>
					  			<select id="st_incoterms_dealy" name="st_incoterms_dealy"  style="width:40%;"/></select>
					  		</td>
						 </tr>
							<th ><font color="#FF6600">*</font>Packing Unit</th>
							<td>
								<input type="text" name="st_packing_qty"  id="st_packing_qty" class="al"   value =""  style="width:30%;"/>
								<select id="st_packing" name="st_packing"  style="width:30%;"/></select>
							</td>
							<th ><font color="#FF6600">*</font>Payment Terms</th>
							<td>
								<select id="st_payment_term" name="st_payment_term"  style="width:80%;"/></select>
							</td>
						 </tr>
						<tr>
							<th ><font color="#FF6600">*</font>Weight</th>
							<td>
								<select id="st_packing_weight" name="st_packing_weight"  style="width:80%;"/></select>
							</td>
							<th >Remark</th>
							<td>
								<input type="text" name="st_remark"  id="st_remark" class="al"   value =""  style="width:90%;"/>
							</td>
						 </tr>
					</tbody>
				</table>
		<!--조회영역-->
		<div id="searchMode">
			<!-- 버튼영역 -->
	       	<div id="searchBtnA" style="width:100%;">
	        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
	   		</div>    
			<div id="cont_searchA">
			<!--HIDDEN-->
	          	<table  class="cont_t_list01" style="width:100%;">
				<caption>품목추가</caption>
				<colgroup>
					<col width="90px" />
					<col width="25%" />
					<col width="90px" />
					<col width="25%" />
					<col width="90px" />
					<col width="25%" />
				</colgroup>
					
				<tbody>
					<tr>
						<th>발주일</th>
						<td colspan="3">
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_from_date')"></a> - 
							<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_to_date')"></a>
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>					
						</td>	
						<th>납품서번호</th>
						<td>
							<input type="text" class="input_type_text" name="st_inv_no2" id="st_inv_no2" style="width:90%" value="" onkeydown="javascript:kepEnter();">
						</td>
					</tr>
					<tr>
						<th>품목명</th>
						<td>
							<input type="text" class="input_type_text" name="st_desc" id="st_desc" style="width:90%" value="" onkeydown="javascript:kepEnter();"> 
						</td>
						<th></th>
						<td>
						</td>
						<th></th>
						<td>
						</td>
					</tr>
				</tbody>
			</table>
			</div>
   		</div>
            <!--grid-->
 			<div style="border-top:2px solid #3c639c; height:150px;">
				<script type="text/javascript"> 
					createIBSheet("mySheet2", "", "150px");
				</script>
			</div>
			<br>
			<div style="text-align:center;width:100%">
				<a href="javascript:addCheckedItem();"><img src="/resources/images/icn_arrowdown02.gif"></a>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="javascript:delCheckedItem();"><img src="/resources/images/icn_arrowup02.gif"></a>
			</div>
            <!--grid-->
 			<div style="border-top:2px solid #3c639c; height:150px;">
				<script type="text/javascript"> 
					createIBSheet("mySheet", "", "150px");
				</script>
			</div>
			<div id="pageindex"></div>
			        <!--버튼영역-->
			<span class="fr">
  				<table border="0" cellspacing="0" cellpadding="0">
  					<TR>
  						<td>
  							  <span class="btn_06"><a href="javascript:doAction('save');" style="text-align:center;cursor:hand">C/I,P/L 생성</a></span>
  						</td>
  					</TR>
  				</table>
			</span>
		</div>	

    </div>
</form> 
</body>
</html>
