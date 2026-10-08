<%--
**********************************************
* 메뉴 : 납품관리>납품실적등록 ,납품완료
* 화면 : 납품실적등록
* 기능 : 기 생성된 거래명세서 목록을 조회하고 선택하여 납품실적을 등록한다. 남품완료 된 데이터를 조회한다.
* 프로그램 ID : SU0504001
* 담당자 : 최찬규
* 착수일 : 2026-09-22
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
 </head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	String menuId = (String) request.getParameter("menuId");
	String user_id      = _sessionInfo.getUserId();
	String com_code 	= _sessionInfo.getComCode();

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
var today = kepGetNowTimeStr("YYYYMMDD","");
//var fromDate = kepToDateAdd("7","M","noslash");
//var toDate = kepToDateAdd("7","P","noslash");

var mySheet0 = new ibsheetObject();
var mySheet1 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var parcelComCodeGbn = KepSheetComboData("C019","SEL");
var comboInfo = {ComboCode: parcelComCodeGbn.ComboCode, ComboText:parcelComCodeGbn.ComboText};

var currIndex=0;
var Sheet;
//최초 화면 함수 
function kep_onload_view(){
Sheet = mySheet0; //첫화면에선 mySheet0;
	
	//초기 날짜 셋팅
	var indexLength = $("input[name=st_from_date]").length;
	for(var i = 0; i<indexLength; i++){
		if($("input[name=st_from_date]").eq(i).val() ==  ""){
			$("input[name=st_from_date]").eq(i).val(kepToMonthAdd("3","M"));
			$("input[name=st_to_date]").eq(i).val(kepGetNowTimeStr('YYYYMMDD','/'));
		}
	}
	
	var initsheet0 = {};
	initsheet0.Cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge,PrevColumnMergeMode:0,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet0.Cols = [
						{ Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true,ColMerge:0}
						,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,	EditLen:100,	Hidden:false,ColMerge:0}
						,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",				Type:"Text", FontColor:"#3a72c7", Cursor:"Pointer",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,ColMerge:0}
						,{ Align:"Center",	SaveName:"BUYER",				Header:"고객사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true,ColMerge:0}
						,{ Align:"Center",	SaveName:"BUYER2",				Header:"BUYER2",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true,ColMerge:0}
						,{ Align:"Center",	SaveName:"PROCESS_TYPE_TEXT",	Header:"거래유형",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,ColMerge:0}
						,{ Align:"Center",	SaveName:"INV_NO",				Header:"거래명세서번호",			Type:"Button",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type02',ColMerge:1}
						,{ Align:"Center",	SaveName:"PO_NO",				Header:"발주번호",				Type:"Button",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type02',ColMerge:0}
						,{ Align:"Left",	SaveName:"DESCRIPTION_INFO",	Header:"품목명",				Type:"Text",			Width:200,	Edit:false,	 	Hidden:false,ColMerge:0}
						,{ Align:"Right",	SaveName:"INV_AMT",			Header:"납품금액",				Type:"Float",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}",ColMerge:0}
						,{ Align:"Center",	SaveName:"PARCEL_TYPE_GUBUN",	Header:"배송유형",				Type:"CheckBox",	Width:120,	Edit:true,	EditLen:100,	Hidden:false, ItemText:"택배|자차",  ItemCode:"택배|자차", MaxCheck:1, RadioIcon:1,ColMerge:0}
						,{ Align:"Center",	SaveName:"PARCEL_YN",			Header:"PARCEL_YN",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true,ColMerge:0}
						,{ Align:"Center",	SaveName:"PARCEL_COM_CODE",		Header:"택배사",				Type:"Combo",		Width:128,	Edit:true,	EditLen:100, 	Hidden:false,ColMerge:0}
						,{ Align:"Center",	SaveName:"PARCEL_INV_NO",		Header:"택배송장번호",			Type:"Text",		Width:150,	Edit:true, EditLen:100,Hidden:false,ColMerge:0}
						,{ Align:"Center",	SaveName:"PARCEL_REAL_URL_BUTTON",		Header:"택배송장조회",			Type:"Button",		Width:100,	Edit:false, Hidden:false,ClassName:'Type02',ColMerge:0}
						,{ Align:"Center",	SaveName:"PARCEL_REAL_URL",		Header:"택배송장조회",			Type:"Text",		Width:150,	Edit:false, Hidden:true,ColMerge:0}
						
						,{ Align:"Center",	SaveName:"IMAGE_KEY_INV_CNT",	Header:"배송완료증빙",			Type:"Image", Cursor:"Pointer",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,ColMerge:0}
						,{ Align:"Center",	SaveName:"IMAGE_KEY_INV",		Header:"배송완료증빙",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true,ColMerge:0}
						,{ Align:"Center",	SaveName:"INVOICE_DATE_ORG",	Header:"납품일",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,Format:"yyyy-MM-dd",ColMerge:0}
						,{ Align:"Center",	SaveName:"INVOICE_DATE",		Header:"고객수령일",			Type:"Date",		Width:110,	Edit:true,	EditLen:10,	Hidden:false,Format:"yyyy-MM-dd",ColMerge:0}
						,{ Align:"Center",	SaveName:"BFRE_STCK_YN",		Header:"선입고여부",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd",ColMerge:0}
						,{ Align:"Left",	SaveName:"KEP_USER_INFO",		Header:"KeP담당자",			Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,ColMerge:0}
						,{ Align:"Center",	SaveName:"DS_DATE",				Header:"납품예정일",			Type:"Date",		Width:150,	Edit:false,	EditLen:100,	Hidden:true,Format:"yyyy-MM-dd",ColMerge:0}
						
						,{ Align:"Center",	SaveName:"PARCEL_TYPE_TEXT",		Header:"배송유형",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
						
						
						,{ Align:"Center",	SaveName:"LEGACY_IV_SERIAL",		Header:"LEGACY_IV_SERIAL",		Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"TR_BUYER",		Header:"TR_BUYER",		Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
						
						,{ Align:"Center",	SaveName:"AUTO_GR_FLAG",		Header:"AUTO_GR_FLAG",		Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"DS_QTY",			Header:"DS_QTY",		Type:"Float",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"PARCEL_COM_NAME",		Header:"PARCEL_COM_NAME",		Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"거래유형",				Type:"Combo",		Width:90,	Edit:false,	EditLen:100,	Hidden:true,	ComboText:"직납|TR",	ComboCode:"0|2"}
						,{ Align:"Center",	SaveName:"P070000029_YN",			Header:"P070000029_YN",			Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"SELLER",				Header:"SELLER",			Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
	];
	
	var initsheet1 = {};
	initsheet1.Cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge,PrevColumnMergeMode:0,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet1.Cols = [
					{ Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true,ColMerge:0}
						,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,	EditLen:100,	Hidden:false,ColMerge:0}
						,{ Align:"Center",	SaveName:"INVOICE_DATE",		Header:"납품일",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,Format:"yyyy-MM-dd",ColMerge:0}
						,{ Align:"Center",	SaveName:"DELIVERY_DATE",		Header:"납품실적등록일",		Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd",ColMerge:0}
						,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",				Type:"Text", FontColor:"#3a72c7", Cursor:"Pointer",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,ColMerge:0}
						,{ Align:"Center",	SaveName:"BUYER",				Header:"고객사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true,ColMerge:0}
						,{ Align:"Center",	SaveName:"BUYER2",				Header:"BUYER2",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true,ColMerge:0}
						,{ Align:"Center",	SaveName:"PROCESS_TYPE_TEXT",	Header:"거래유형",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false, ColMerge:0}
						,{ Align:"Center",	SaveName:"INV_NO",				Header:"거래명세서번호",			Type:"Button",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type02',ColMerge:1}
						,{ Align:"Center",	SaveName:"PO_NO",				Header:"발주번호",				Type:"Button",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type02',ColMerge:0}
						,{ Align:"Left",	SaveName:"DESCRIPTION_INFO",	Header:"품목명",				Type:"Text",			Width:200,	Edit:false,	 	Hidden:false,ColMerge:0}
						,{ Align:"Right",	SaveName:"INV_AMT",				Header:"납품금액",				Type:"Float",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}",ColMerge:0}
						,{ Align:"Center",	SaveName:"PARCEL_YN_TEXT",		Header:"배송유형",				Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:false,ColMerge:0}
						,{ Align:"Center",	SaveName:"PARCEL_COM_NAME",		Header:"택배사",				Type:"Text",		Width:128,	Edit:false,	EditLen:100, 	Hidden:false,ColMerge:0}
						,{ Align:"Center",	SaveName:"PARCEL_INV_NO",		Header:"택배송장번호",			Type:"Text",		Width:150,	Edit:false, Hidden:false,ColMerge:0}
						,{ Align:"Center",	SaveName:"PARCEL_REAL_URL_BUTTON",		Header:"택배송장조회",			Type:"Button",		Width:100,	Edit:false, Hidden:false,ClassName:'Type01',ColMerge:0}
						,{ Align:"Center",	SaveName:"PARCEL_REAL_URL",		Header:"택배송장조회",			Type:"Text",		Width:150,	Edit:false, Hidden:true,ColMerge:0}
						
						,{ Align:"Center",	SaveName:"IMAGE_KEY_INV_CNT",	Header:"배송완료증빙",			Type:"Button",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type03',ColMerge:0}
						,{ Align:"Center",	SaveName:"IMAGE_KEY_INV",		Header:"배송완료증빙",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true,ColMerge:0}
						,{ Align:"Center",	SaveName:"BFRE_STCK_YN",		Header:"선입고여부",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd",ColMerge:0}
						,{ Align:"Left",	SaveName:"KEP_USER_INFO",		Header:"KeP담당자",			Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,ColMerge:0}
						,{ Align:"Center",	SaveName:"DS_DATE",				Header:"납품예정일",			Type:"Date",		Width:150,	Edit:false,	EditLen:100,	Hidden:true,Format:"yyyy-MM-dd",ColMerge:0}
						
						,{ Align:"Center",	SaveName:"GR_QTY",			Header:"GR_QTY",		Type:"Float",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"LEGACY_IV_SERIAL",		Header:"LEGACY_IV_SERIAL",		Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"TR_BUYER",		Header:"TR_BUYER",		Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"거래유형",				Type:"Combo",		Width:90,	Edit:false,	EditLen:100,	Hidden:true,	ComboText:"직납|TR",	ComboCode:"0|2"}
						,{ Align:"Center",	SaveName:"SELLER",				Header:"SELLER",			Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"AP_BILL_FLAG",				Header:"AP_BILL_FLAG",			Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
	];

	IBS_InitSheet(mySheet0, initsheet0, pagingMode);
	IBS_InitSheet(mySheet1, initsheet1, pagingMode);
	
	mySheet0.SetHighlightAfterSort(2);
	mySheet1.SetHighlightAfterSort(2);
	
	mySheet0.SetColProperty("PARCEL_COM_CODE", parcelComCodeGbn);
	
	mySheet0.SetCountFormat(" 총  ROWCOUNT 건 ");
	mySheet1.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet0.SetHeaderBackColor("#f2f7ff");
	mySheet1.SetHeaderBackColor("#f2f7ff");
	
	mySheet0.SetTheme("DB", "DeepBlue");
	mySheet1.SetTheme("DB", "DeepBlue");
	
// 	var datePickerInstance = new IBSheetDatePicker(mySheet0, {
// 	    columns: ['INVOICE_DATE'],  // 달력을 적용할 컬럼들
// 	    dateFormat: '-',                         // 날짜 구분자 (YYYY.MM.DD)
// 	    displayFormat:'YYYY-MM-DD',
// 	    saveFormat: 'YYYYMMDD',               // 저장 형식
// 	    yearFirst: true,                         // 년도를 월 앞에 표시
// 	    autoClose: false,                        // 날짜 선택 후 자동 닫기 비활성화
// 	    autoInit: true,                          // 자동 초기화
// 	    onChange: function(data) {
// 	        console.log('[사용자 콜백] 날짜 변경:', data);
// 	    }
// 	});
	
	doAction('search');
}

//조회 후처리
function mySheet0_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	for(var i = 1; i<=Sheet.RowCount();i++){
		if(Sheet.GetCellValue(i,"PARCEL_YN") == "Y"){
			Sheet.SetCellValue(i,"PARCEL_TYPE_GUBUN","택배:1|자차:0");
			Sheet.SetCellEditable(i,"PARCEL_COM_CODE",true);
			Sheet.SetCellEditable(i,"PARCEL_INV_NO",true);
			Sheet.SetCellEditable(i,"INVOICE_DATE",false);
			Sheet.SetCellBackColor(i, "PARCEL_COM_CODE", "${optColor}");
			Sheet.SetCellBackColor(i, "PARCEL_INV_NO", "${optColor}");
			Sheet.SetCellBackColor(i, "INVOICE_DATE", "");
			Sheet.SetCellValue(i,"INVOICE_DATE","");
		}else{
			Sheet.SetCellValue(i,"PARCEL_TYPE_GUBUN","택배:0|자차:1");
			Sheet.SetCellValue(i,"PARCEL_COM_CODE","");
			Sheet.SetCellValue(i,"PARCEL_INV_NO","");
			Sheet.SetCellEditable(i,"PARCEL_COM_CODE",false);
			Sheet.SetCellEditable(i,"PARCEL_INV_NO",false);
			Sheet.SetCellEditable(i,"INVOICE_DATE",true);
			Sheet.SetCellBackColor(i, "PARCEL_COM_CODE", "");
			Sheet.SetCellBackColor(i, "PARCEL_INV_NO", "");
			Sheet.SetCellBackColor(i, "INVOICE_DATE", "${optColor}");
		}
		
		if(Sheet.GetCellValue(i,"PARCEL_INV_NO") != ""){ //택배사 입력해서 처리한 건
			Sheet.SetCellEditable(i,"PARCEL_TYPE_GUBUN",false);
			Sheet.SetCellBackColor(i, "PARCEL_TYPE_GUBUN", "");
		}else{
			Sheet.SetCellBackColor(i, "PARCEL_TYPE_GUBUN", "${optColor}");
		}
	}
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
//조회 후처리
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
//그리드 셀클릭 이벤트
function mySheet0_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_buyer = Sheet.GetCellValue(Row, "BUYER");
	var st_buyer2 = Sheet.GetCellValue(Row, "BUYER2");
	var st_po_no = Sheet.GetCellValue(Row, "PO_NO");
	var st_inv_no = Sheet.GetCellValue(Row, "INV_NO");
	var st_seller = Sheet.GetCellValue(Row, "SELLER");
	var st_legacy_iv_serial = Sheet.GetCellValue(Row,"LEGACY_IV_SERIAL");
	var st_tr_buyer = Sheet.GetCellValue(Row,"TR_BUYER");
	var st_process_type = Sheet.GetCellValue(Row, "PROCESS_TYPE");
	var st_image_key_inv = Sheet.GetCellValue(Row,"IMAGE_KEY_INV");
	
	if(column == "SELECTED"){
		var inv_no = Sheet.GetCellValue(Row,"INV_NO");
		var buyer = Sheet.GetCellValue(Row,"BUYER");
		for(var i = 1; i<=Sheet.RowCount(); i++){
			if(Sheet.GetCellValue(i,"BUYER") == buyer && Sheet.GetCellValue(i,"INV_NO") == inv_no){
				Sheet.SetCellValue(i,"SELECTED",Value);
			}
		}
	}
	if(column == "BUYER_NAME"){
		var src = "/common/agentInfoDisplayPop.do?st_com_code="+st_buyer2; 
		openLayerPop(src,"825px","700px");
		
// 		openSearchPopup("/common/agentInfoDisplayPop.do", '?st_com_code='+st_buyer2, "825,700,no");
	}
	if(column == "PO_NO"){
		var src = "/mpiv/commonMpIvOrderInfoPop_v2.do?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status=납품실적 등록대상"; 
		openLayerPop(src,"1240px","800px");
		
// 		openSearchPopup("/mpiv/commonMpIvOrderInfoPop_v2.do", "?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status=납품실적 등록대상", "1240,770,no");
	}
	if(column == "INV_NO"){
		var param = "";
		param  = "?st_buyer="+st_buyer;
		param += "&st_po_no="+st_po_no;
		param += "&st_inv_no="+st_inv_no;
		param += "&st_seller="+st_seller;
		param += "&st_legacy_iv_serial="+st_legacy_iv_serial;
		param += "&st_tr_buyer="+st_tr_buyer;
		param += "&st_user_id="+$("#st_user_id"+currIndex).val();
		var src = "/mpiv/commonMpIvTranStatementDetailIVPop_v2.do"+param;
		openLayerPop(src,"1240px","880px");
		
// 		openSearchPopup("/mpiv/commonMpIvTranStatementDetailIVPop_v2.do", param, "1240,850,no");
	}
	if(column == "IMAGE_KEY_INV_CNT"){
		popupSel = "setImageKey";
		var src = '/common/fileUploadPop_v2.do?DOC_NO='+st_image_key_inv+'&viewType=W&TYPE=IV';
		openLayerPop(src,"600px","510px");
		
// 		openSearchPopup("/common/fileUploadPop_v2.do", '?DOC_NO='+st_image_key_inv+'&viewType=W&TYPE=IV', "600,490,no");
	}
	if(column == "PARCEL_TYPE_GUBUN"){
		if(!Sheet.GetCellEditable(Row, "PARCEL_TYPE_GUBUN")){
			return;
		}
		if(Sheet.GetCellValue(Row, "PARCEL_TYPE_GUBUN") == "택배:1|자차:0"){ //택배선택
			var inv_no = Sheet.GetCellValue(Row,"INV_NO");
			var buyer = Sheet.GetCellValue(Row,"BUYER");
			for(var i = 1; i<=Sheet.RowCount(); i++){
				if(Sheet.GetCellValue(i,"BUYER") == buyer && Sheet.GetCellValue(i,"INV_NO") == inv_no){
					Sheet.SetCellValue(i, "PARCEL_TYPE_GUBUN","택배:1|자차:0");
					Sheet.SetCellValue(i,"PARCEL_YN","Y");
					Sheet.SetCellValue(i,"PARCEL_COM_CODE","");
					Sheet.SetCellValue(i,"PARCEL_INV_NO","");
					Sheet.SetCellEditable(i,"PARCEL_COM_CODE",true);
					Sheet.SetCellEditable(i,"PARCEL_INV_NO",true);
					Sheet.SetCellEditable(i,"INVOICE_DATE",false);
					Sheet.SetCellValue(i,"INVOICE_DATE","");
					Sheet.SetCellBackColor(i, "INVOICE_DATE", "");
					Sheet.SetCellBackColor(i, "PARCEL_COM_CODE", "${optColor}");
					Sheet.SetCellBackColor(i, "PARCEL_INV_NO", "${optColor}");
					Sheet.SetCellValue(i,"IMAGE_KEY_INV_CNT","/resources/imgs/Btn_RegIng.gif");
				}
			}
			
		}
		if(Sheet.GetCellValue(Row, "PARCEL_TYPE_GUBUN") == "택배:0|자차:1"){ //자차선택
			var inv_no = Sheet.GetCellValue(Row,"INV_NO");
			var buyer = Sheet.GetCellValue(Row,"BUYER");
			for(var i = 1; i<=Sheet.RowCount(); i++){
				if(Sheet.GetCellValue(i,"BUYER") == buyer && Sheet.GetCellValue(i,"INV_NO") == inv_no){
					Sheet.SetCellValue(i, "PARCEL_TYPE_GUBUN","택배:0|자차:1");
					Sheet.SetCellValue(i,"PARCEL_COM_CODE","");
					Sheet.SetCellValue(i,"PARCEL_INV_NO","");
					Sheet.SetCellValue(i,"PARCEL_YN","N");
					Sheet.SetCellEditable(i,"INVOICE_DATE",true);
					Sheet.SetCellEditable(i,"PARCEL_COM_CODE",false);
					Sheet.SetCellEditable(i,"PARCEL_INV_NO",false);
					Sheet.SetCellValue(i,"INVOICE_DATE",Sheet.GetCellValue(i,"INVOICE_DATE_ORG"));
					Sheet.SetCellBackColor(i, "INVOICE_DATE", "${optColor}");
					Sheet.SetCellBackColor(i, "PARCEL_COM_CODE", "");
					Sheet.SetCellBackColor(i, "PARCEL_INV_NO", "");
					if(Sheet.GetCellValue(i,"IMAGE_KEY_INV") == ""){
						if((Sheet.GetCellValue(i,"AUTO_GR_FLAG") == "Y" && Sheet.GetCellValue(i,"PROCESS_TYPE") == "0") || (Sheet.GetCellValue(i,"P070000029_YN") == "Y" && Sheet.GetCellValue(i,"PROCESS_TYPE") == "0")){
							Sheet.SetCellValue(i,"IMAGE_KEY_INV_CNT","/resources/imgs/Btn_RegR.gif");
						}else{
							Sheet.SetCellValue(i,"IMAGE_KEY_INV_CNT","/resources/imgs/Btn_RegIng.gif");
						}
					}
				}
			}
		}
	}
	if(column == "PARCEL_REAL_URL_BUTTON"){
		if(Sheet.GetCellValue(Row,"PARCEL_REAL_URL") != ""){
			window.open(Sheet.GetCellValue(Row,"PARCEL_REAL_URL"));
		}
	}
	return;
} 
//그리드 셀클릭 이벤트
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_buyer = Sheet.GetCellValue(Row, "BUYER");
	var st_buyer2 = Sheet.GetCellValue(Row, "BUYER2");
	var st_po_no = Sheet.GetCellValue(Row, "PO_NO");
	var st_inv_no = Sheet.GetCellValue(Row, "INV_NO");
	var st_seller = Sheet.GetCellValue(Row, "SELLER");
	var st_legacy_iv_serial = Sheet.GetCellValue(Row,"LEGACY_IV_SERIAL");
	var st_tr_buyer = Sheet.GetCellValue(Row,"TR_BUYER");
	var st_process_type = Sheet.GetCellValue(Row, "PROCESS_TYPE");
	var st_image_key_inv = Sheet.GetCellValue(Row,"IMAGE_KEY_INV");
	
	if(column == "SELECTED"){
		var inv_no = Sheet.GetCellValue(Row,"INV_NO");
		var buyer = Sheet.GetCellValue(Row,"BUYER");
		for(var i = 1; i<=Sheet.RowCount(); i++){
			if(Sheet.GetCellValue(i,"BUYER") == buyer && Sheet.GetCellValue(i,"INV_NO") == inv_no){
				Sheet.SetCellValue(i,"SELECTED",Value);
			}
		}
	}
	if(column == "BUYER_NAME"){
		var src = "/common/agentInfoDisplayPop.do?st_com_code="+st_buyer2; 
		openLayerPop(src,"825px","700px");
		
// 		openSearchPopup("/common/agentInfoDisplayPop.do", '?st_com_code='+st_buyer2, "825,700,no");
	}
	if(column == "PO_NO"){
		var src = "/mpiv/commonMpIvOrderInfoPop_v2.do?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status=납품완료"; 
		openLayerPop(src,"1240px","800px");
// 		openSearchPopup("/mpiv/commonMpIvOrderInfoPop_v2.do", "?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status=납품완료", "1240,770,no");
	}
	if(column == "INV_NO"){
		var param = "";
		param  = "?st_buyer="+st_buyer;
		param += "&st_po_no="+st_po_no;
		param += "&st_inv_no="+st_inv_no;
		param += "&st_seller="+st_seller;
		param += "&st_legacy_iv_serial="+st_legacy_iv_serial;
		param += "&st_tr_buyer="+st_tr_buyer;
		param += "&st_user_id="+$("#st_user_id"+currIndex).val();
		
		var src = "/mpiv/commonMpIvTranStatementDetailIVPop_v2.do"+param;
		openLayerPop(src,"1240px","880px");
// 		openSearchPopup("/mpiv/commonMpIvTranStatementDetailIVPop_v2.do", param, "1240,850,no");
	}
	if(column == "IMAGE_KEY_INV_CNT"){
		if(st_image_key_inv != ""){
			var src = '/common/fileUploadPop_v2.do?DOC_NO='+st_image_key_inv+'&viewType=R&TYPE=IV';
			openLayerPop(src,"600px","490px");
			
// 			openSearchPopup("/common/fileUploadPop_v2.do", '?DOC_NO='+st_image_key_inv+'&viewType=R&TYPE=IV', "600,490,no");
		}
	}
	if(column == "PARCEL_REAL_URL_BUTTON"){
		if(Sheet.GetCellValue(Row,"PARCEL_REAL_URL") != ""){
			window.open(Sheet.GetCellValue(Row,"PARCEL_REAL_URL"));
		}
	}
	return;
} 


function mySheet0_OnChange(Row, Col, Value, OldValue, RaiseFlag){
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var inv_no = Sheet.GetCellValue(Row,"INV_NO");
	var buyer = Sheet.GetCellValue(Row,"BUYER");
	
	if(column == "PARCEL_TYPE_GUBUN"){
		//이전꺼랑 비교해서 checkbox 해제 안되도록
		if(OldValue == "택배:1|자차:0" && Value == "택배:0|자차:0"){  
			Sheet.SetCellValue(Row,"PARCEL_TYPE_GUBUN","택배:1|자차:0");
		}
		if(OldValue == "택배:0|자차:1" && Value == "택배:0|자차:0"){
			Sheet.SetCellValue(Row,"PARCEL_TYPE_GUBUN","택배:0|자차:1");
		}
	}
	if(column =="PARCEL_COM_CODE"){
		for(var i = 1; i<=Sheet.RowCount(); i++){
			if(Sheet.GetCellValue(i,"BUYER") == buyer && Sheet.GetCellValue(i,"INV_NO") == inv_no){
				Sheet.SetCellValue(i,"PARCEL_COM_CODE",Value);
			}
		}
	}
	if(column == "PARCEL_INV_NO"){
		for(var i = 1; i<=Sheet.RowCount(); i++){
			if(Sheet.GetCellValue(i,"BUYER") == buyer && Sheet.GetCellValue(i,"INV_NO") == inv_no){
				Sheet.SetCellValue(i,"PARCEL_INV_NO",Value);
			}
		}
	}
	if(column == "INVOICE_DATE"){
		for(var i = 1; i<=Sheet.RowCount(); i++){
			if(Sheet.GetCellValue(i,"BUYER") == buyer && Sheet.GetCellValue(i,"INV_NO") == inv_no){
				Sheet.SetCellValue(i,"INVOICE_DATE",Value);
			}
		}
	}
}
function doAction(str) {
	switch (str) {
		case "search":	 //조회
			if (kep_dateSearchCheck($("#st_from_date_"+currIndex).val(),$("#st_to_date_"+currIndex).val()) == false) return;
			var diff = kepGetDateDiff('st_from_date_'+currIndex,'st_to_date_'+currIndex,'D');
			if (eval(diff)>372){
// 				alert("1년 이내 조회만 가능합니다.");
				var text = "1년 이내 조회만 가능합니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
		
			if(currIndex == 0){
				kepSearch(document.searchCondition0, Sheet, "/mpiv/getSellerMpIvDeliveryRecordRegList_v3.do" , pagingMode);
			}else if(currIndex == 1){
				kepSearch(document.searchCondition1, Sheet, "/mpiv/getSellerMpIvDeliveryRecordRegEndList_v3.do" , pagingMode);
			}
			break;
			
		case "reload":	//초기화
			kepReload_v2('searchCondition'+currIndex);
			kepMonth_v2('st_from_date_'+currIndex,'st_to_date_'+currIndex,'3');
			if(currIndex == 0){
				$("#st_parcel_inv_no_yn").val("N");
			}
			Sheet.RemoveAll();
			
			// hidden값은 공통에서 처리안됨.
			$("#st_buyer_code_"+currIndex).val("");
			break;

		case "excelDown": // 엑셀다운로드
			excelDownload();
			break;
		case "saveParcel":	//택배사정보 저장
			if(parcelInvNoCheck()){
				setParcel();
			}
			break;
			
		case "setDeliveryRsltCreate":	//납품완료
			setDeliveryRsltCreate();
			break;	
		case "setInvoiceDelete": //거래명세서 취소
			setInvoiceDelete();
			break;
		case "setDeliveryRsltDelete": //납품실적 삭제
			setDeliveryRsltDelete();
			break;
	}
}

function setBuyerChoiceReturn(buyer, com_name){
	$("#st_buyer_code_"+currIndex).val(buyer);
	$("#st_buyer_name_"+currIndex).val(com_name);
}


//납품실적등록
function setDeliveryRsltCreate(){
	var query   = "";
	
	var buyer           = "";
	var po_no           = "";
	var po_seq          = "";
	var inv_no          = "";
	var inv_seq         = "";
	var delivery_date   = "";
	var delivery_qty    = "";
	var invoice_date    = "";
	//자동입고 여부. 고객사옵션
	var st_gr_auto_flag = "";
	var db_parcel_com_name = "";
	var st_image_key = "";
	var db_buyer_nm = "";
	var db_process_type = "";
	//자동입고처리 FLAG
	var exe_gr_auto_flag = "N"
	var cur_date        = kepGetNowTimeStr("YYYYMMDD", "");		// 현재날짜
	var avail_date      = kepToDateAdd("2","M","noslash");		// 현재날짜 -2일
	var st_parcel_com_code_2 = "";
	var st_parcel_inv_no_2 = "";
	var p070000029_YN = "N";
	var st_parcel_yn = "";
	var st_parcel_changed="N";
	
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	if(checkRows.length == 0){
// 		alert("선택된 항목이 없습니다.");
		var text = "선택된 항목이 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var invStr = "";
	
	for(var idx = 0; idx<arrRow.length; idx++){
		if(invStr.indexOf(Sheet.GetCellValue(arrRow[idx],"BUYER")+Sheet.GetCellValue(arrRow[idx],"INV_NO")) <0){ //같은 고객사+inv_no는 안합쳐도됨
			buyer = Sheet.GetCellValue(arrRow[idx],"BUYER");
			inv_no = Sheet.GetCellValue(arrRow[idx],"INV_NO");
			invStr = invStr + buyer+inv_no + ",";
		}else{
			continue;
		}
		po_no = Sheet.GetCellValue(arrRow[idx],"PO_NO");
		invoice_date = Sheet.GetCellValue(arrRow[idx],"INVOICE_DATE_ORG");
		st_gr_auto_flag = Sheet.GetCellValue(arrRow[idx],"AUTO_GR_FLAG");
		db_parcel_com_name = Sheet.GetCellValue(arrRow[idx],"PARCEL_COM_NAME");
		db_buyer_nm = Sheet.GetCellValue(arrRow[idx],"BUYER_NAME");
		st_image_key = Sheet.GetCellValue(arrRow[idx],"IMAGE_KEY_INV");
		db_process_type = Sheet.GetCellValue(arrRow[idx],"PROCESS_TYPE");
		st_parcel_com_code_2 = Sheet.GetCellValue(arrRow[idx],"PARCEL_COM_CODE");
		st_parcel_inv_no_2 = Sheet.GetCellValue(arrRow[idx],"PARCEL_INV_NO");
		p070000029_YN = Sheet.GetCellValue(arrRow[idx],"P070000029_YN");
		st_parcel_yn = Sheet.GetCellValue(arrRow[idx],"PARCEL_YN");
		
		if(st_parcel_yn == "Y"){ // 택배건은 납품완료 버튼 진행하되 택배사정보만 업데이트
			if((st_parcel_com_code_2 == "" || st_parcel_inv_no_2 == "")){
// 				alert("택배사정보를 입력해주세요.");
				var text = "택배사정보를 입력해주세요.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			if(!alphaNumChk(st_parcel_inv_no_2)){
// 				alert("택배송장번호는 영문, 숫자만 입력가능합니다.");
				var text = "택배송장번호는 영문, 숫자만 입력가능합니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			
			//택배건은 자동입고 불가능
			if(st_gr_auto_flag == "Y"){
				exe_gr_auto_flag = "N";	
			}
		}else{
			delivery_date = Sheet.GetCellValue(arrRow[idx],"INVOICE_DATE"); //고객수령일
			
			if(delivery_date == ""){
// 				alert("고객 수령일을 입력해 주십시요");
				var text = "고객 수령일을 입력해주세요.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			
			if(invoice_date > cur_date){
// 				alert("납품일("+invoice_date+") 이 후 부터 실적등록이 가능합니다.\n\n※ 납품 완료 후 실적을 등록해 주십시요");
				var text = "납품일("+invoice_date+") 이 후 부터 실적등록이 가능합니다.</br>※ 납품 완료 후 실적을 등록해주세요.";
				openLayerPopText2(text,but1text,but1func,but1width);
				Sheet.SetCellValue(arrRow[idx],"SELECTED",false);
				return;
			}
			
			// 납품확정일 >= 거래명세서 작성일 인경우에만 실적등록 가능
			if(delivery_date < invoice_date){
// 				alert( "고객수령일(납품확정일)은 납품일 이후 날짜만 입력 가능합니다.\n\n*납품일 : 거래명세서 작성 시 등록한 납품일자");
				var text = "고객수령일(납품확정일)은 납품일 이후 날짜만 입력 가능합니다.</br>*납품일 : 거래명세서 작성 시 등록한 납품일자";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			/*
			고객사 옵션이 자동입고 로직
			1. 직납일때만 첨부기능.(협력사)
			2. 택배송장번호 입력건은 배송증빙처리 불필요
			3. 택번거 이외 모든건 배송증빙 처리 해야함
			*/
			
			//택배 아닐 때 배송증빙 필수
			if(st_image_key == "" || st_image_key == null){
//					alert("고객사: "+db_buyer_nm+ ", 거래명세서번호: "+inv_no+"\n배송완료 증빙 처리 바랍니다.");
				var text = "고객사: "+db_buyer_nm+ ", 거래명세서번호: "+inv_no+"</br>배송완료 증빙 처리 바랍니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			
			//직납건은 자동 입고 가능
			if(st_gr_auto_flag == "Y"){
				exe_gr_auto_flag = "Y";	
			}
// 			if(st_gr_auto_flag == "Y"&&db_process_type == "0"){
// 				exe_gr_auto_flag = "Y";	
// 				if(st_parcel_com_code_2 == "" || st_parcel_com_code_2 == null){
// 					if(st_image_key == "" || st_image_key == null){
// 						var text = "고객사: "+db_buyer_nm+ ", 거래명세서번호: "+inv_no+"</br>배송완료 증빙 처리 바랍니다.";
// 						openLayerPopText2(text,but1text,but1func,but1width);
// 						return;
// 					}
// 				}else{
// 					//택배건은 자동입고 처리 안함.
// 					exe_gr_auto_flag = "N";	
// 				}
// 			}

			// 해당 고객사 직납 납품실적 등록 시 택배 or 배송증빙 필수
// 			if(p070000029_YN == "Y"){
// 				if(db_process_type == "0"){
// 					if(st_parcel_com_code_2 == "" && st_image_key == ""){
// 						var text = "고객사: "+db_buyer_nm+ ", 거래명세서번호: "+inv_no+"</br>택배송장번호 or 배송완료증빙 등록바랍니다.";
// 						openLayerPopText2(text,but1text,but1func,but1width);
// 						return;
// 					}
// 				}
// 			}
		}
		
		
		query +=  buyer         + "@@";
		query +=  inv_no        + "@@";
		query +=  delivery_date + "@@";
		query +=  st_image_key + "@@";
		query +=  exe_gr_auto_flag+ "@@";
		query +=  st_parcel_com_code_2+ "@@";
		query +=  st_parcel_inv_no_2 + "@@";
		query +=  st_parcel_yn+ "@@";
		query +=  st_parcel_changed;
		query +=  "^||^" ; 
	}
	document.forms["searchCondition0"].st_query0.value  = query;
	
	
// 	if(!confirm("납품실적을 등록 하시겠습니까?")) return;
	var text = "납품실적을 등록 하시겠습니까?";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:saveSellerMpIvDeliveryRecordRegList_v2(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "110px";
	var but2widthC = "110px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
	
	
// 	kepAjaxFormCall("/mpiv/saveSellerMpIvDeliveryRecordRegList_v2.do","searchCondition0","btnCreate");
	
	/*
	
	document.forms[0].target = "work";
	document.forms[0].method = "post";
	document.forms[0].action = "/kr/agent/delivery/agent_delivery_rslt_cre_reg.jsp";
	document.forms[0].submit();
	*/

}
function saveSellerMpIvDeliveryRecordRegList_v2(){
	closePopText1();
	kepAjaxFormCall("/mpiv/saveSellerMpIvDeliveryRecordRegList_v3.do","searchCondition0","btnCreate");
}
function setInvoiceDelete(){
	var query       = "";
	var buyer		= "";
	var inv_no      = "";
	var ds_date		= "";
	var seller		= "";
	
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	if(checkRows.length == 0){
// 		alert("선택된 항목이 없습니다.");
		var text = "선택된 항목이 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var invStr = "";
	
	for(var idx = 0; idx<arrRow.length; idx++){
		if(invStr.indexOf(Sheet.GetCellValue(arrRow[idx],"BUYER")+Sheet.GetCellValue(arrRow[idx],"INV_NO")) <0){ //같은 고객사+inv_no는 안합쳐도됨
			buyer = Sheet.GetCellValue(arrRow[idx],"BUYER");
			inv_no = Sheet.GetCellValue(arrRow[idx],"INV_NO");
			invStr = invStr + buyer+inv_no + ",";
		}else{
			continue;
		}
		ds_date = Sheet.GetCellValue(arrRow[idx],"DS_DATE");
		seller = Sheet.GetCellValue(arrRow[idx],"SELLER");
		
		query +=  buyer         + "@@";
		query +=  inv_no		+ "@@";
		query +=  ds_date		+ "@@";
		query +=  seller;
		query +=  "^||^" ; 
	}
	document.forms["searchCondition0"].st_query0.value  = query;
	
// if(!confirm("거래명세서를 취소 하시겠습니까?")) return;
	var text = "거래명세서를 취소 하시겠습니까?";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:delSellerMpIvDeliveryRecordInvoiceList_v2(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "110px";
	var but2widthC = "110px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
	
// 	kepAjaxFormCall("/mpiv/delSellerMpIvDeliveryRecordInvoiceList_v2.do","searchCondition0","delInvoice");
}
function delSellerMpIvDeliveryRecordInvoiceList_v2(){
	closePopText1();
	kepAjaxFormCall("/mpiv/delSellerMpIvDeliveryRecordInvoiceList_v2.do","searchCondition0","delInvoice");
}
function setDeliveryRsltDelete(){
	var query       = "";
	var buyer		= "";
	var inv_no      = "";
	
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	if(checkRows.length == 0){
// 		alert("선택된 항목이 없습니다.");
		var text = "선택된 항목이 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	var invStr = "";
	
	for(var idx = 0; idx<arrRow.length; idx++){
		if(invStr.indexOf(Sheet.GetCellValue(arrRow[idx],"BUYER")+Sheet.GetCellValue(arrRow[idx],"INV_NO")) <0){ //같은 고객사+inv_no는 안합쳐도됨
			buyer = Sheet.GetCellValue(arrRow[idx],"BUYER");
			inv_no = Sheet.GetCellValue(arrRow[idx],"INV_NO");
			invStr = invStr + buyer+inv_no + ",";
		}else{
			continue;
		}
		gr_qty = Sheet.GetCellValue(arrRow[idx],"GR_QTY");
		
		var ap_bill_flag = Sheet.GetCellValue(arrRow[idx],"AP_BILL_FLAG");
		if(ap_bill_flag == "Y"){
			var text = "매입마감 완료된 건은 납품실적등록 취소할 수 없습니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		if(gr_qty >0){
// 			alert("고객사 입고처리건이므로 납품실적 취소가 불가능 합니다.");
			var text = "고객사 입고처리건이므로 납품실적 취소가 불가능 합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		query +=  buyer			+ "@@";
		query +=  inv_no;
		query +=  "^||^" ;
	}
	
	document.forms["searchCondition1"].st_query1.value  = query;
// 	if(!confirm("납품실적을 취소 하시겠습니까?")) return;
	var text = "납품실적을 취소 하시겠습니까?";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:saveSellerMpIvDeliveryRecordDeleteList_v2(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "110px";
	var but2widthC = "110px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
	
// 	kepAjaxFormCall("/mpiv/saveSellerMpIvDeliveryRecordDeleteList_v2.do","searchCondition1","btnDelete");
	
}
function saveSellerMpIvDeliveryRecordDeleteList_v2(){
	closePopText1();
	kepAjaxFormCall("/mpiv/saveSellerMpIvDeliveryRecordDeleteList_v2.do","searchCondition1","btnDelete");
}
function excelDownload(){
	if(Sheet.RowCount() == 0){
// 		alert("조회된 데이터가 없습니다.");
		var text = "조회된 데이터가 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	// 선택된 항목 유무 체크
	if (checkRows.length == 0) {
// 		alert("상품을 선택해주세요.");
		var text = "항목을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	Sheet.SetWaitImageVisible(true);
	
	var downRow = "|0";
	for(var i=1; i<=Sheet.RowCount(); i++) {
		if(Sheet.GetCellValue(i,"SELECTED"))
			downRow += "|"+i;
	}
	
	var downCol = "";
	for(var i=0; i<=Sheet.LastCol(); i++){
		if(!Sheet.GetColHidden(i) && Sheet.ColSaveName(i) !="SELECTED" && Sheet.GetCellProperty(1, i, "Type") != "Image" && Sheet.GetCellProperty(1, i, "Type") != "CheckBox" ){
			downCol += "|"+i;
		}
	}
	downCol = downCol+"|BUYER|PROCESS_TYPE";
	if(currIndex == 0){
		downCol = downCol+"|PARCEL_TYPE_TEXT";
	}
	
	if(downRow == "|0"){
		downRow = "";
	}
	var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
	
	var fileName = "";
	if(currIndex == 0){
		fileName = "납품실적_등록대상_";
	}else if(currIndex == 1){
		fileName = "납품완료_";
	}
	var param = {FileName:fileName+nowTime, SheetName:fileName, DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
	Sheet.Down2Excel(param);
}

//택배송장번호 영문과 숫자만 사용
function alphaNumChk(text) {
	
	var input = text; 	
    var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    
    for (var inx = 0; inx < input.length; inx++) {
        if (chars.indexOf(input.charAt(inx)) == -1){
            return false;
        }
     }
     return true;
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	if(pMethod == "btnCreate"){
// 		alert("납품실적등록이  정상적으로 완료 되었습니다.");
		var text = "납품실적등록이  정상적으로 완료 되었습니다.";
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
// 		doAction("search");
	    //setQuery();   
	}else if(pMethod == "delInvoice"){
// 		alert("거래명세서가 정상적으로 취소되었습니다.");
		var text = "거래명세서가 정상적으로 취소되었습니다.";
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
// 		doAction("search");
	    //setQuery();   
	}else if(pMethod == "btnDelete"){
// 		alert("납품실적취소가  정상적으로 완료 되었습니다.");
		var text = "납품실적취소가  정상적으로 완료 되었습니다.";
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
// 		doAction("search");
	    //setQuery();   
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
var gridIndex = "";
var popupSel= "";
// 팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5, value6) {
	switch (str) {
		case "commonMpIvTranBuyerChoicePop": // 고객사선택
			openSearchPopup("/mpiv/getCommonMpIvTranBuyerChoicePop.do", "?st_com_code="+$("#st_com_code"+currIndex).val(), "750,530,no");
			break;
			
		case "excelUpload": 
			var src = "/mpiv/showSellerMpIvExcelUploadPop.do";
			openLayerPop(src,"740px","620px");
			
// 			openSearchPopup('/mpiv/showSellerMpIvExcelUploadPop.do','','740,620,no');
			break;
		case "insertMulti": //일괄등록
			popupSel = "insertMulti";
			var checkRows = Sheet.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			if(checkRows.length == 0){
// 				alert("선택된 항목이 없습니다.");
				var text = "선택된 항목이 없습니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			var src = "/mpiv/showSellerMpIvDeliveryRecordRegMultiPop_v2.do";
			openLayerPop(src,"480px","450px");
			
// 			openSearchPopup("/mpiv/showSellerMpIvDeliveryRecordRegMultiPop_v2.do", "", "480,450,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5){	
	
	if(popupSel == "setImageKey") {	//배송증빙
		Sheet.SetCellValue(grbRow, 'IMAGE_KEY_INV', value1);
		Sheet.SetCellValue(grbRow, 'IMAGE_KEY_INV_CNT', "/resources/imgs/Btn_RegEnd.gif");
	}else if(popupSel == "insertMulti"){
		var checkRows = Sheet.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		if(checkRows.length == 0){
// 			alert("선택된 항목이 없습니다.");
			var text = "선택된 항목이 없습니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		for(var idx = 0; idx<arrRow.length; idx++){
			if(value1 != ""){ //배송유형
				Sheet.SetCellValue(arrRow[idx],"PARCEL_YN",value1);
				if(value1 == "Y"){
					Sheet.SetCellValue(arrRow[idx], "PARCEL_TYPE_GUBUN","택배:1|자차:0");
					Sheet.SetCellValue(arrRow[idx],"PARCEL_COM_CODE","");
					Sheet.SetCellValue(arrRow[idx],"PARCEL_INV_NO","");
					Sheet.SetCellEditable(arrRow[idx],"PARCEL_COM_CODE",true);
					Sheet.SetCellEditable(arrRow[idx],"PARCEL_INV_NO",true);
					Sheet.SetCellEditable(arrRow[idx],"INVOICE_DATE",false);
					Sheet.SetCellValue(arrRow[idx],"INVOICE_DATE","");
					Sheet.SetCellBackColor(arrRow[idx], "INVOICE_DATE", "");
					Sheet.SetCellBackColor(arrRow[idx], "PARCEL_COM_CODE", "${optColor}");
					Sheet.SetCellBackColor(arrRow[idx], "PARCEL_INV_NO", "${optColor}");
					Sheet.SetCellValue(arrRow[idx],"IMAGE_KEY_INV_CNT","/resources/imgs/Btn_RegIng.gif");
				}else if(value1 == "N"){
					Sheet.SetCellValue(arrRow[idx], "PARCEL_TYPE_GUBUN","택배:0|자차:1");
					Sheet.SetCellValue(arrRow[idx],"PARCEL_COM_CODE","");
					Sheet.SetCellValue(arrRow[idx],"PARCEL_INV_NO","");
					Sheet.SetCellValue(arrRow[idx],"PARCEL_YN","N");
					Sheet.SetCellEditable(arrRow[idx],"INVOICE_DATE",true);
					Sheet.SetCellEditable(arrRow[idx],"PARCEL_COM_CODE",false);
					Sheet.SetCellEditable(arrRow[idx],"PARCEL_INV_NO",false);
					Sheet.SetCellValue(arrRow[idx],"INVOICE_DATE",Sheet.GetCellValue(arrRow[idx],"INVOICE_DATE_ORG"));
					Sheet.SetCellBackColor(arrRow[idx], "INVOICE_DATE", "${optColor}");
					Sheet.SetCellBackColor(arrRow[idx], "PARCEL_COM_CODE", "");
					Sheet.SetCellBackColor(arrRow[idx], "PARCEL_INV_NO", "");
					if(Sheet.GetCellValue(arrRow[idx],"IMAGE_KEY_INV") == ""){
						if((Sheet.GetCellValue(arrRow[idx],"AUTO_GR_FLAG") == "Y" && Sheet.GetCellValue(arrRow[idx],"PROCESS_TYPE") == "0") || (Sheet.GetCellValue(arrRow[idx],"P070000029_YN") == "Y" && Sheet.GetCellValue(arrRow[idx],"PROCESS_TYPE") == "0")){
							Sheet.SetCellValue(arrRow[idx],"IMAGE_KEY_INV_CNT","/resources/imgs/Btn_RegR.gif");
						}else{
							Sheet.SetCellValue(i,"IMAGE_KEY_INV_CNT","/resources/imgs/Btn_RegIng.gif");
						}
					}
				}
			}
			if(value2 != ""){ //택배사
				if(Sheet.GetCellValue(arrRow[idx],"PARCEL_YN") =="Y" ){ //택배인 경우에만 수정
					Sheet.SetCellValue(arrRow[idx],"PARCEL_COM_CODE",value2);
				}
			}
			if(value3 != ""){ //고객수령일
				if(Sheet.GetCellValue(arrRow[idx],"PARCEL_YN") =="N" ){ //자차인 경우에만 수정
					Sheet.SetCellValue(arrRow[idx],"INVOICE_DATE",value3);
				}
			}
		}
		
	}
	
	grbRow = "";
}

function thisPopClose(){
	closePopText2();
	doAction("search");
}
</script>
<body onload="kep_onload_view()">
<div id="wrapper"> 
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
<div class="containerBoxSub" >
	  
      <div class="PDleft50"><!--padding-left:50px; 시작 -->    
		<div class="SubTit">
          <%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star"></button>
     	<%} %>
     	 납품실적등록
          <div class="SummaryGuide">
      	    <ul>
        	  <li><img src="/resources/imgs/Icon_Home.png" /></li>
              <li>납품관리</li>
              <li>납품실적등록</li>
            </ul>
          </div>
        </div>
        <div class="SubSearchTab">
         <button class="TabTit active" data-tab="Search1">납품실적 등록대상</button>
         <button class="TabTit" data-tab="Search2">납품완료</button> 
        </div>
        <form id="searchCondition0" name="searchCondition0" method="post">
        <input type="hidden" name="s_SAVENAME" />
        <input type="hidden" name="st_query" id="st_query0" value="">
		<input type="hidden" name="st_com_code" id="st_com_code0" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id0" value="${sessionInfo.userId}">
        <div id="Search1" class="SearchContent active">
          <div class="Importance">
            <img src="/resources/imgs/Icon_Importance.png" />택배는 택배사·송장번호 입력, 자차는 증빙 첨부 및 고객수령일 입력 후 납품실적을 등록해 주세요.
          </div>
          <table class="TabSearchTable" >
            <colgroup>
              <col width="80px" />
              <col width="600px" /> 
              <col width="100px" />
              <col width="220px" />
              <col width="90px" />
              <col width="170px" />
            </colgroup>            	
            <tr>
              <th>기간</th>
              <td >
                <select name="st_date_type" class="Select" style=" float:left;width:130px; margin-right:5px">
                  <option value="st_po_create_date" selected>발주일</option>
                  <option value="st_iv_add_date">거래명세서생성일</option>
                </select>
                <div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date_0" name="st_from_date" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_0" name="st_to_date" readonly /><span></span></div>
                </div>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','1'); return false;">1개월</button> 
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','2'); return false;">2개월</button>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','3'); return false;">3개월</button>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','12'); return false;">1년</button>            
              </td>
              <th>고객사</th>
              <td><div class="SearchBuyer" style="width:190px " >
                  <input type="text" placeholder=" " id="st_buyer_name_0"  name="st_buyer_name" style=" width:85%; " onKeyDown="kepEnter_v2();" >
<!--                   <input type="hidden" name="st_buyer_code" id="st_buyer_code_0" value=""> -->
<!--                   <button type="button" onclick="javascript:doPop('commonMpIvTranBuyerChoicePop'); return false;">고객사명</button> -->
                </div>
			  </td> 
		      <th>선입고여부</th>
              <td><select name="st_bfre_stck_yn" class="Select" style="width:168px;">
                  <option value="" selected>전체</option>
                  <option value="S">Y</option>
                  <option value="N">N</option>
                </select> </td>
            </tr>
            <tr>           
              <th>발주번호</th>
              <td><input class="input30" style="width:514px" name="st_po_no" type="text" placeholder="여러 개의 발주번호로 조회 가능하며 띄어쓰기 없이 콤마(,)로 구분해서 입력해주세요." onKeyDown="kepEnter_v2();" /></td>
              <th>거래명세서번호</th>
              <td><input class="input30" style="width:170px" name="st_inv_no" type="text" onKeyDown="kepEnter_v2();"/></td>  
              <th>택배송장 등록여부</th>
              <td><select name="st_parcel_inv_no_yn" id="st_parcel_inv_no_yn" class="Select" style="width:168px;">
                  <option value="">전체</option>
                  <option value="Y">등록</option>
                  <option value="N" selected>미등록</option>
                </select> </td>                                                    
            </tr>
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="doAction('search');return false;">조회</button>
          </div>
          <div class="ListBtnBox">
            <div class="left">
              <button class="But_ExcelDown40" onclick="javascript:excelDownload(); return false;">엑셀다운로드</button>
              <button class="But_ExcelDown40" onclick="javascript:doPop('excelUpload'); return false;">택배송장 업로드</button>
              <button class="ButOutline_Medium" onclick="javascript:doPop('insertMulti'); return false;">일괄등록</button>
            </div>
            <div class="right">
<!--               <button class="ButOutline_Medium" onclick="javascript:doAction('setInvoiceDelete'); return false;">거래명세서 취소</button> -->
              <button class="ButPrimary_Medium" onclick="javascript:doAction('setDeliveryRsltCreate'); return false;">납품실적등록</button>
            </div>
          </div>
          <div class="IBSheet">
            <script type="text/javascript">
          		createIBSheet("mySheet0", "", "100%");
          	</script>         
          </div><!--IBSheet 끝 --> 
          <div class="h50" style="height: 50px;"></div>              
        </div><!--id="Search1" 수거래명세서수(PO별) 끝 -->
        </form>
        <form id="searchCondition1" name="searchCondition1" method="post">
        <input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_com_code" id="st_com_code1" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id1" value="${sessionInfo.userId}">   
		<input type="hidden" name="st_query" id="st_query1" value="${sessionInfo.userId}">    
        <div id="Search2" class="SearchContent">
          <table class="TabSearchTable" >
            <colgroup>
              <col width="90px" />
              <col width="440px" /> 
              <col width="110px" />
              <col width="300px" />
              <col width="80px" />
              <col width="240px" />
            </colgroup>            	
            <tr>
              <th>납품실적등록일</th>
              <td >
                <div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date_1" name="st_from_date" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_1" name="st_to_date" readonly /><span></span></div>
                </div>
                <button class="But_MonthSmall" style="width:55px;" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','1'); return false;">1개월</button> 
                <button class="But_MonthSmall" style="width:55px;" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','2'); return false;">2개월</button>
                <button class="But_MonthSmall" style="width:55px;" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','3'); return false;">3개월</button>
                <button class="But_MonthSmall" style="width:55px;" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','12'); return false;">1년</button>               
              </td>
              <th>고객사</th>
              <td><div class="SearchBuyer" style="width:270px " >
                  <input type="text" placeholder=" " id="st_buyer_name_1" name="st_buyer_name" style=" width:85%; " onKeyDown="kepEnter_v2();">
<!--                   <input type="hidden" name="st_buyer_code" id="st_buyer_code_1" value=""> -->
<!--                   <button type="button" onclick="javascript:doPop('commonMpIvTranBuyerChoicePop'); return false;">고객사명</button> -->
                </div>
			  </td> 
              <th>선입고여부</th>
              <td><select name="st_bfre_stck_yn" class="Select" style="width:242px;">
                  <option value="" selected>전체</option>
                  <option value="S">Y</option>
                  <option value="N">N</option>
                </select> </td>   
            </tr>
            <tr>           
              <th>발주번호</th>
              <td><input class="input30" style="width:448px" name="st_po_no" type="text" placeholder="여러 개의 발주번호로 조회 가능하며 띄어쓰기 없이 콤마(,)로 구분해서 입력해주세요."  onKeyDown="kepEnter_v2();"/></td>
		      <th>거래명세서번호</th>
              <td><input class="input30" style="width:250px" name="st_inv_no" type="text" onKeyDown="kepEnter_v2();"/></td>
              <th>증빙여부</th>
              <td><select name="st_image_key_inv" class="Select" style="width:242px;">
                  <option value="">전체</option>
                  <option value="Y">Y</option>
                  <option value="N">N</option>
                </select> </td>                                                        
            </tr>
            <tr>           
              <th>택배송장번호</th>
              <td><input class="input30" style="width:448px" name="st_parcel_inv_no" type="text" onKeyDown="kepEnter_v2();"/></td>               
              <th>배송유형</th>
              <td><select name="st_parcel_type" class="Select" style="width:272px;">
                  <option value="">전체</option>
                  <option value="Y">택배</option>
                  <option value="N">자차</option>
                </select> </td>  
		      <th>택배사</th>
              <td><select name="st_parcel_com_code" id="st_parcel_com_code" class="Select" style="width:242px;">
                </select> </td>  
            </tr>            
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="doAction('search');return false;">조회</button>
          </div>
          <div class="ListBtnBox">
            <div class="left">
              <button class="But_ExcelDown40" onclick="javascript:excelDownload(); return false;">엑셀다운로드</button>
            </div>
            <div class="right">
              <button class="ButOutline_Medium" onclick="javascript:doAction('setDeliveryRsltDelete'); return false;">납품실적등록 취소</button> 
            </div>
          </div>
          <div class="IBSheet">
            <script type="text/javascript">
          		createIBSheet("mySheet1", "", "100%");
          	</script>           
          </div><!--IBSheet 끝 --> 
          <div class="h50" style="height: 50px;"></div>    
        </div><!--id="Search2" 거래명세서(품목별) 끝 -->
       </form>       
         
		<!-- 탭 스크립트 -->     
		<script>
		const tabLinks = document.querySelectorAll(".TabTit");
        const tabContents = document.querySelectorAll(".SearchContent");
        
        tabLinks.forEach(function(link,index) {
          link.addEventListener("click", function() {
            // 모든 탭 버튼, 컨텐츠 비활성화
            tabLinks.forEach(function(btn) {btn.classList.remove("active")});
            tabContents.forEach(function(content){ content.classList.remove("active")});
      
            // 클릭한 탭 활성화
            link.classList.add("active");
            document.getElementById(link.dataset.tab).classList.add("active");
            currIndex = index; //현재 탭 index를 저장
            if(currIndex == 0){
          	  Sheet = mySheet0;
            }else if(currIndex == 1){
          	  Sheet = mySheet1;
          	  kepAjaxCommonComboDataValue("st_parcel_com_code", "C019", "ALL", "");
            }
            
            doAction('search');
          });
        });
          
          const inputs = document.querySelectorAll("input[name=st_po_no],input[name=st_inv_no],input[name=st_parcel_inv_no]");
          inputs.forEach(function(input){
          	  input.addEventListener("input",function(){
          		  this.value = this.value.trimStart();
          	  });
            });
        </script>
      </div> <!--padding-left:50px; 끝 -->
    </div><!--containerBoxSub--> 

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter_sub_v2.jsp" %>
</div>
</body>
</html>
