<%--
**********************************************
* 메뉴 : 견적요청접수
* 화면 : 견적요청접수
* 기능 : 
* 프로그램 ID : 
* 담당자 : 한승준
* 착수일 : 
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
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>
<%
	//공통
	@SuppressWarnings (value="unchecked")

	// 협력사 품목코드 입력 필수
	boolean p03302303 = CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P03-3023-03");
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var magnifyOn="/resources/images/icon.gif";
var magnifyOff="/resources/images/icon2.gif";

var productGbn = KepSheetComboData("M132","SEL");
var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 6};
	initsheet.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:60,	Edit:true,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}							
			,{ Align:"Center",	SaveName:"QUOTATION_NO",		Header:"견적번호",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ATOS_END_DATE",		Header:"견적마감일",			Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"품목명",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"SOURCING_STATUS",		Header:"진행상태",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"QUOTATION_SEQ",		Header:"견적항번",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ATOS_DATE",			Header:"견적요청일",			Type:"Date",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"MAKER_NAME",			Header:"제조사",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"ORIGIN_NAME",			Header:"원산지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"SELLER_ITEM_NO",		Header:"협력사품목코드",		Type:"Text",		Width:100,	Edit:true,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"MAKER_PART_NO",		Header:"모델번호",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ITEM_QTY",			Header:"수량",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"STOA_LIST_PRICE",		Header:"제출단가\n(VAT별도)",	Type:"Float",		Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Format:"${priceFormat}",	BackColor:"${optColor}"}
			,{ Align:"Right",	SaveName:"STOA_VAT_LIST_PRICE",	Header:"제출단가\n(VAT포함)",	Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"STOA_LIST_PRICE_AMT",		Header:"제출금액\n(VAT별도)",	Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"STOA_VAT_LIST_PRICE_AMT",	Header:"제출금액\n(VAT포함)",	Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ITEM_MAKE_TYPE",		Header:"품목구분",				Type:"Combo",		Width:120,	Edit:true,	EditLen:100,	Hidden:false, 	BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"LEAD_TIME",			Header:"조달일수",				Type:"Int",			Width:60,	Edit:true,	EditLen:3,		Hidden:false,	BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"RFQ_IMG_FLAG",		Header:"이미지필수",			Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"IMGFILE_NAME_YN",		Header:"이미지첨부",			Type:"Image",		Width:70,	Edit:false,	EditLen:100,	Hidden:false,	BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"MSDS_YN",				Header:"MSDS",				Type:"Combo",		Width:60,	Edit:false,	EditLen:100,	Hidden:true,	ComboText:"Y|N",	ComboCode:"Y|N",	BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"QTDT_PRE_GR_FLAG",	Header:"선입고",				Type:"Combo",		Width:60,	Edit:true,	EditLen:100,	Hidden:false,	ComboText:"Y|N",	ComboCode:"Y|N",	BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"SELLER_IMAGE_KEY_YN",	Header:"첨부",				Type:"Image",		Width:70,	Edit:false,	EditLen:100,	Hidden:false,	BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"SELLER_AREA_YN",		Header:"납품지역",				Type:"Image",		Width:70,	Edit:false,	EditLen:200,	Hidden:false}
			,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"거래유형",				Type:"Combo",		Width:60,	Edit:true,	EditLen:100,	Hidden:false,	ComboText:"직납|TR",	ComboCode:"0|2"}
			,{ Align:"Center",	SaveName:"MIN_ORDER_QTY",		Header:"MOQ",				Type:"Int",			Width:60,	Edit:true,	EditLen:100,	Hidden:false,	BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"PUR_UNIT_QTY",		Header:"발주배수",				Type:"Int",			Width:60,	Edit:true,	EditLen:100,	Hidden:false,	BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"TAX_TYPE",			Header:"과세구분",				Type:"Combo",		Width:60,	Edit:true,	EditLen:100,	Hidden:false,	ComboText:"과세|면세",	ComboCode:"11|12",	BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"KEP_USER_NAME",		Header:"KeP담당자",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"KEP_USER_PHONE",		Header:"담당자연락처",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"DELY_TO_LOCATION",	Header:"예상 도착지",			Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ATOS_REMARK",			Header:"운영사비고",			Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"IMAGE_KEY_YN",		Header:"운영사첨부",			Type:"Image",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"STOA_REMARK_YN",		Header:"협력사비고",			Type:"Image",		Width:70,	Edit:false,	EditLen:100,	Hidden:false,	BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"SAFETY_FLAG_TEXT",	Header:"안전인증서상태",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			
			,{ Align:"Center",	SaveName:"BUYER",				Header:"고객사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
			,{ Align:"Center",	SaveName:"REVISION",			Header:"고객사차수",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"AGENT_REVISION",		Header:"협력사차수",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"IMGFILE_NAME",		Header:"이미지첨부",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"IMGFILE_DIR",			Header:"이미지첨부",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SELLER_IMAGE_KEY",	Header:"첨부",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"IMAGE_KEY",			Header:"운영사첨부",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_REMARK",			Header:"협력사비고",			Type:"Text",		Width:80,	Edit:false,	EditLen:500,	Hidden:true}
			,{ Align:"Center",	SaveName:"SELLER_AREA",			Header:"납품지역",				Type:"Text",		Width:80,	Edit:false,	EditLen:200,	Hidden:true}
			,{ Align:"Center",	SaveName:"KEP_USER_ID",			Header:"KeP담당자ID",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"REF_NO",				Header:"관리번호",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"AGENT",				Header:"협력사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SAFETY_FLAG",			Header:"안전인증서상태",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_DATE",			Header:"협력사제출일",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_TIME",			Header:"협력사제출시간",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PLANT",				Header:"PLANT",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"DELI_AREA_USE_FLAG",	Header:"AREA_USE_FLAG",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"MOQ_USE_FLAG",		Header:"MOQ_USE_FLAG",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PROCESS_TYPE_FLAG",	Header:"PROCESS_TYPE_FLAG",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"GIVEUP_REMARK",		Header:"GIVEUP_REMARK",		Type:"Text",		Width:80,	Edit:false,	EditLen:500,	Hidden:true}
			,{ Align:"Center",	SaveName:"VAT_FLAG",			Header:"VAT_FLAG",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SG_ID",				Header:"SG_ID",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	//이미지 설정
	//비고이미지설정
	mySheet.SetImageList(0, remarkOff);
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(2, diskOff);
	mySheet.SetImageList(3, diskOn);
	mySheet.SetImageList(4, magnifyOff);
	mySheet.SetImageList(5, magnifyOn);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "SOURCING_STATUS");
	setLinkCol(mySheet, "QUOTATION_NO");
	setLinkCol(mySheet, "KEP_USER_NAME");
	setLinkCol(mySheet, "IMGFILE_NAME_YN");
	setLinkCol(mySheet, "SELLER_IMAGE_KEY_YN");
	setLinkCol(mySheet, "SELLER_AREA_YN");
	setLinkCol(mySheet, "ATOS_REMARK");
	setLinkCol(mySheet, "IMAGE_KEY_YN");
	setLinkCol(mySheet, "STOA_REMARK_YN");
	
	mySheet.SetColProperty("ITEM_MAKE_TYPE", comboInfo);

	doAction('search');
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str != "search" && str != "reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mprq/getSellerMpRqQuotReqList.do" , pagingMode);
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case "agentHandout":
			$('#st_giveup_yn').val("N");
			agentHandout(str);
			break;
		case "cancel":
			$('#st_giveup_yn').val("Y");
			agentHandout(str);
			break;
		case "reqSourcing"://견적요청서 목록
			ReqSourcingList(str);
			break;
	}
}

//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		alert(msg);
	}
	var totRow = mySheet.RowCount();
	
	for(var i=1; i<=totRow;i++){
		var DELI_AREA_USE_FLAG = mySheet.GetCellValue(i, 'DELI_AREA_USE_FLAG');
		var PROCESS_TYPE_FLAG = mySheet.GetCellValue(i, 'PROCESS_TYPE_FLAG');
		
		if(DELI_AREA_USE_FLAG == "Y"){
			mySheet.SetCellBackColor(i, "SELLER_AREA_YN", "${optColor}");
		}else{
			mySheet.SetCellValue(i, "SELLER_AREA_YN", "");
		}
		
		if(PROCESS_TYPE_FLAG == "Y"){
			mySheet.SetCellBackColor(i, "PROCESS_TYPE", "${optColor}");
		}else{
			mySheet.SetCellValue(i, "PROCESS_TYPE", "");
			mySheet.SetCellEditable(i, "PROCESS_TYPE", 0);
		}
		
		if(<%=p03302303%> == true){
			mySheet.SetCellBackColor(i, "SELLER_ITEM_NO", "${optColor}");
		}
	}

	if(current_page==-1){
		makePageIndex2(mySheet, 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2(mySheet, current_page , document.searchCondition.onepagerow.value);	
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getSellerMpRqQuotReqList.do?page="+current_page , pagingMode );
}

//팝업함수호출
function doPop(str, val1, val2) {
	popupSel = str;
	
	switch (str) {
	case "deliAreaPopMulti": // 납품지역 일괄선정
		var checkRows = mySheet.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		var BUYER_BF = "";
		var PLANT_BF = "";
		var mod_yn = "Y";
		
		if(arrRow.length <= 0){
			alert("선택된 항목이 없습니다.");
			return;
		}else if(arrRow.length < 2){
			alert("일괄선정은 2건 이상 선택이 필요합니다.");
			return;
		}
		
		for(var idx=0; idx<arrRow.length; idx++){ // 정합성 체크
			var BUYER = mySheet.GetCellValue(arrRow[idx], "BUYER");
			var PLANT = mySheet.GetCellValue(arrRow[idx], "PLANT");
			var STOA_DATE = mySheet.GetCellValue(arrRow[idx], "STOA_DATE");
			var STOA_TIME = mySheet.GetCellValue(arrRow[idx], "STOA_TIME");
			var DELI_AREA_USE_FLAG = mySheet.GetCellValue(arrRow[idx], 'DELI_AREA_USE_FLAG');
			
			if(idx != 0 && BUYER_BF != BUYER){
				alert("동일한 고객사들만 선택 가능합니다.");
				return;
			}
			
			if(idx != 0 && PLANT_BF != PLANT){
				alert("동일한 플랜트들만 선택 가능합니다.");
				return;
			}
			
			if(STOA_DATE != "" || STOA_TIME != ""){
				alert("미제출건에 대해서만 납품지역 설정이 가능합니다.");
				return;
			}
			
			if(DELI_AREA_USE_FLAG != "Y"){
				alert("선택 고객사는 납품지역 일괄선정을 할 수 없습니다.");
				return;
			}
			
			BUYER_BF = BUYER;
			PLANT_BF = PLANT;
		}
		
		if(confirm("선택된 항목들에 일괄적용됩니다. 진행하시겠습니까?")){
			openSearchPopup("/common/getDeliveryAreaPop.do", '?st_com_code='+BUYER_BF+'&mod_yn='+mod_yn+'&plant_code='+PLANT_BF, "400,270,no");	
		}
		
		break;
	}
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_sourcing_status = mySheet.GetCellValue(Row, "SOURCING_STATUS");
	var st_buyer = mySheet.GetCellValue(Row, "BUYER");
	var st_quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
	var st_quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
	var st_revision = mySheet.GetCellValue(Row, "REVISION");
	var st_agent_revision = mySheet.GetCellValue(Row, "AGENT_REVISION");
	var st_agent = mySheet.GetCellValue(Row, "AGENT");
	var st_kep_user_id = mySheet.GetCellValue(Row, "KEP_USER_ID");
	var st_ref_no = mySheet.GetCellValue(Row, "REF_NO");
	var st_atos_remark = mySheet.GetCellValue(Row, "ATOS_REMARK");
	var st_stoa_remark = mySheet.GetCellValue(Row, "STOA_REMARK");
	var st_imgfile_dir = mySheet.GetCellValue(Row, "IMGFILE_DIR");
	var st_imgfile_name = mySheet.GetCellValue(Row, "IMGFILE_NAME");
	var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
	var st_image_key = mySheet.GetCellValue(Row, "IMAGE_KEY");
	var st_seller_image_key = mySheet.GetCellValue(Row, "SELLER_IMAGE_KEY");
	var st_seller_area = mySheet.GetCellValue(Row, "SELLER_AREA");
	var st_plant = mySheet.GetCellValue(Row, "PLANT");
	var st_seller_area_flag = mySheet.GetCellValue(Row, "DELI_AREA_USE_FLAG");
	
	if(column == "SOURCING_STATUS"){
		if(st_sourcing_status != "신규견적"){
			openSearchPopup("/mprq/showSellerMpRqUnitPriceHistoryPop.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_agent='+st_agent, "800,300,no");	
		}else{
			alert("재견적요청이 아닙니다.");
			return;
		}
	}
	
	if(column == "QUOTATION_NO"){
		req_print(st_buyer, st_quotation_no, st_quotation_seq, st_revision, st_kep_user_id, st_ref_no);
	}
	
	if(column == "KEP_USER_NAME"){
		openSearchPopup("/common/kepManagerPop.do", '?st_user_id='+st_kep_user_id, "430,194,no");
	}
	
	if(column == "ATOS_REMARK"){
		popupSel = "remarkStoA";
		st_atos_remark = st_atos_remark.replaceAll(/&/g, "%26");
		if(st_atos_remark != ""){
			openSearchPopup("/common/remarkStoAPop.do", '?st_atos_remark='+st_atos_remark+'&st_stoa_remark='+st_stoa_remark, "500,310,no");
		}else{
			alert("운영사비고 내용이 없습니다.");
			return;
		}
	}
	
	if(column == "STOA_REMARK_YN"){
		popupSel = "remarkStoA";
		
		openSearchPopup("/common/remarkStoAPop.do", '?st_atos_remark='+st_atos_remark+'&st_stoa_remark='+st_stoa_remark, "500,310,no");
	}
	
	if(column == "IMGFILE_NAME_YN"){
		popupSel = "addImgPop";
		
		var mod_yn = "Y"; //수정여부
		var st_type = "S"; //협력사일경우
		
		openSearchPopup("/common/addImagePop.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_agent_revision='+st_agent_revision+'&st_agent='+st_agent+'&st_imgfile_dir='+st_imgfile_dir+'&st_imgfile_name='+st_imgfile_name+'&st_buyer_item_no='+st_buyer_item_no+'&mod_yn='+mod_yn+'&st_type='+st_type, "590,670,no");
	}
	
	if(column =="IMAGE_KEY_YN"){
		popupSel = "attach";
		
		var type="RFQ";
		var viewType="R";
		
		if(st_image_key != ""){
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+st_image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		}else{
			alert("운영사 첨부파일이 없습니다.");
			return;
		}
	}
	
	if(column =="SELLER_IMAGE_KEY_YN"){
		popupSel = "seller_attach";
		
		var type="RFQ";
		var viewType="VI";
		
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+st_seller_image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}
	
	if(column =="SELLER_AREA_YN"){
		popupSel = "seller_area";
		
		var stoa_date = "";
		var stoa_time = "";
		var mod_yn = "Y";
		
		stoa_date = mySheet.GetCellValue(Row, "STOA_DATE");
		stoa_time = mySheet.GetCellValue(Row, "STOA_TIME");
		
		if(stoa_date != "" || stoa_time != ""){
			mod_yn = "N";
		}
		
		if(st_seller_area_flag == "Y"){
			openSearchPopup("/common/getDeliveryAreaPop.do", '?st_com_code='+st_buyer+'&st_area_list='+st_seller_area+'&mod_yn='+mod_yn+'&plant_code='+st_plant, "400,270,no");	
		}else{
			alert("해당 고객사는 납품지역 선택이 불필요합니다.");
			return;
		}
	}
	
	return;
}

function mySheet_OnChange(Row, Col, Value) {

	if ( Row  < 1) return;

	var column = mySheet.ColSaveName(Col);
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if(column =="STOA_LIST_PRICE"){//VAT별도 금액
		var st_list_price = mySheet.GetCellValue(Row, "STOA_LIST_PRICE");
		var st_tax_type = mySheet.GetCellValue(Row, "TAX_TYPE");
		var st_vat_list_price = 0;
		var st_vat_list_price_amt = 0;
		var item_qty = mySheet.GetCellValue(Row,"ITEM_QTY");
		
		if(st_tax_type =="12"){//면세일경우 부가세 제외 처리
			mySheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE",st_list_price);
			mySheet.SetCellValue(Row, "STOA_LIST_PRICE_AMT",st_list_price * item_qty);
			mySheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE_AMT",st_list_price * item_qty);
		}else{//과세일경우 부가세 처리 st_tax_type ="11"
			st_vat_list_price = kepGetRound2(st_list_price*1.1,1);
			mySheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE",st_vat_list_price);
			mySheet.SetCellValue(Row, "STOA_LIST_PRICE_AMT",st_list_price * item_qty);
			st_vat_list_price_amt = kepGetRound2(st_list_price*1.1*item_qty,1);
			mySheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE_AMT",st_vat_list_price_amt);
		}
		
	}else if(column =="TAX_TYPE"){
		var st_list_price = mySheet.GetCellValue(Row, "STOA_LIST_PRICE");
		var item_qty = mySheet.GetCellValue(Row,"ITEM_QTY");
		
		//제출단가가 들어갈 경우만 해당 됨.
		if(st_list_price != ""){
			var st_tax_type = mySheet.GetCellValue(Row, "TAX_TYPE");
			var st_vat_list_price = 0;
			var st_vat_list_price_amt = 0;
			
			if(st_tax_type =="12"){//면세일경우 부가세 제외 처리
				mySheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE",st_list_price);
				mySheet.SetCellValue(Row, "STOA_LIST_PRICE_AMT",st_list_price * item_qty);
				mySheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE_AMT",st_list_price * item_qty);
			}else{//과세일경우 부가세 처리 st_tax_type ="11"
				st_vat_list_price = kepGetRound2(st_list_price*1.1,1);
				mySheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE",st_vat_list_price);
				mySheet.SetCellValue(Row, "STOA_LIST_PRICE_AMT",st_list_price * item_qty);
				st_vat_list_price_amt = kepGetRound2(st_list_price*1.1*item_qty,1);
				mySheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE_AMT",st_vat_list_price_amt);
			}				
		}
	}else if(column =="ITEM_MAKE_TYPE"){//품목구분
		var st_item_make_type = mySheet.GetCellValue(Row, "ITEM_MAKE_TYPE");
		var st_lead_time = mySheet.GetCellValue(Row, "LEAD_TIME");
		var new_lead_time = 0;
		if( st_item_make_type == "ST"){
			new_lead_time = 3;
		}else if( st_item_make_type == "MK"){
			new_lead_time = 7;
		}else if( st_item_make_type == "SI" || st_item_make_type == "MI"){
			new_lead_time = 30;
		}
		
		if(st_lead_time != ""){
			alert("기본 조달일수로 설정되었습니다. 조달일수를 확인하시기 바랍니다.");
		}
		mySheet.SetCellValue(Row, "LEAD_TIME", new_lead_time);
		mySheet.SelectCell(Row, "LEAD_TIME");
	}	
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg.msg);
	}
	if ( code > 0 ) {
		//저장 성공시 처리
		doAction("search");
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
}

// ajax 공통 호출후 에러시 처리 함수
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction("search");
	}
}

//견적요청서
function req_print(buyer,quotation_no,quotation_seq,revision,kep_user_id,ref_no){
	//SLOGIC-BEGIN(P04-4040-05)
	var param = "";
	var fileName = "";
	var rfq_gubun = ref_no;
	if(buyer == "KRDOOD0001"){
	    if(rfq_gubun == "RFQ"){
	    	fileName = "RD_04_M_005_02";
	    	param =  "["+quotation_no+"]["+revision+"]["+buyer+"]";
	    }else{
	    	fileName = "RD_04_M_006_02"; //견적번호기준으로 품목 나오도록 수정.2015.1.15 현업 협의완료.
	    	param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+kep_user_id+"]["+"${sessionInfo.comCode}"+"]";	
	    }
    }else if(buyer == "KRSAMS0123" || buyer == "KRSAMS0192"){ //삼성전자 관리번호 필드 추가 
    	fileName = "RD_04_M_006_03";
    	param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+kep_user_id+"]["+"${sessionInfo.comCode}"+"]";
    }else {
    	fileName = "RD_04_M_006_01";
    	param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+kep_user_id+"]["+"${sessionInfo.comCode}"+"]";
    }
	reportOpen(fileName,param);
	//SLOGIC-END
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	if(popupSel == "addImgPop") {	// 이미지첨부
		mySheet.SetCellValue(grbRow, 'IMGFILE_DIR', value1);
		mySheet.SetCellValue(grbRow, 'IMGFILE_NAME', value2);
		
		mySheet.SetCellValue(grbRow, 'IMGFILE_NAME_YN', (value1!="")? magnifyOn : magnifyOff);
	}else if(popupSel == "remarkStoA") {	// 운영사비고, 협력사비고
		mySheet.SetCellValue(grbRow, 'STOA_REMARK', value1);
		
		mySheet.SetCellValue(grbRow, 'STOA_REMARK_YN', (value1!="")? remarkOn : remarkOff);
	}else if(popupSel == "seller_attach"){
		mySheet.SetCellValue(grbRow, 'SELLER_IMAGE_KEY', value1);
		
		mySheet.SetCellValue(grbRow, 'SELLER_IMAGE_KEY_YN', (value1!="")? diskOn : diskOff);
	}else if(popupSel == "seller_area"){
		mySheet.SetCellValue(grbRow, 'SELLER_AREA', value1);
		
		mySheet.SetCellValue(grbRow, 'SELLER_AREA_YN', (value1!="")? magnifyOn : magnifyOff);
	}else if(popupSel == "deliAreaPopMulti") {	// 납품지역 일괄선정
		var checkRows = mySheet.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], 'SELLER_AREA', value1);
			
			mySheet.SetCellValue(arrRow[idx], 'SELLER_AREA_YN', (value1!="")? magnifyOn : magnifyOff);
		}
	}
	grbRow = "";	//초기화
}
function agentHandout(btnEvent){ // 견적 제출, 포기
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	if(btnEvent == "agentHandout"){
		var sg_alert_flag = false;
		
		for(var idx=0; idx<arrRow.length; idx++){
			var RFQ_IMG_FLAG = mySheet.GetCellValue(arrRow[idx], "RFQ_IMG_FLAG");
			var IMGFILE_NAME = mySheet.GetCellValue(arrRow[idx], "IMGFILE_NAME");
			var SELLER_IMAGE_KEY = mySheet.GetCellValue(arrRow[idx], "SELLER_IMAGE_KEY");
			var LEAD_TIME = mySheet.GetCellValue(arrRow[idx], "LEAD_TIME");
			var STOA_LIST_PRICE = mySheet.GetCellValue(arrRow[idx], "STOA_LIST_PRICE");
			var DELI_AREA_USE_FLAG = mySheet.GetCellValue(arrRow[idx], 'DELI_AREA_USE_FLAG');
			var PROCESS_TYPE_FLAG = mySheet.GetCellValue(arrRow[idx], 'PROCESS_TYPE_FLAG');
			var MIN_ORDER_QTY = mySheet.GetCellValue(arrRow[idx], 'MIN_ORDER_QTY');
			var PUR_UNIT_QTY = mySheet.GetCellValue(arrRow[idx], 'PUR_UNIT_QTY');
			var SELLER_AREA = mySheet.GetCellValue(arrRow[idx], 'SELLER_AREA');
			var PROCESS_TYPE = mySheet.GetCellValue(arrRow[idx], 'PROCESS_TYPE');
			var ITEM_MAKE_TYPE = mySheet.GetCellValue(arrRow[idx], 'ITEM_MAKE_TYPE');
			var SELLER_ITEM_NO = mySheet.GetCellValue(arrRow[idx], 'SELLER_ITEM_NO');
			var SG_ID = mySheet.GetCellValue(arrRow[idx], 'SG_ID');
			
			if(RFQ_IMG_FLAG == "Y" && kepIsValueNull(IMGFILE_NAME)){
        		alert("해당 품목 이미지첨부가 필요합니다.");
        		mySheet.SelectCell(arrRow[idx], "IMGFILE_NAME_YN");
        		return;
        	}
			
			if(ITEM_MAKE_TYPE == "" || kepIsValueNull(ITEM_MAKE_TYPE) ){
				alert("품목구분을 선택하여 주십시요.");
				mySheet.SelectCell(arrRow[idx], "ITEM_MAKE_TYPE");
				return;
			}
			
			if(LEAD_TIME < 1){
				alert("조달일수는 0보다 큰 숫자로 입력하세요.");
				mySheet.SelectCell(arrRow[idx], "LEAD_TIME");
				return;
			}
			
			if(kepIsValueNull(LEAD_TIME)) {
				 alert("조달일수(숫자형식)를 입력하여 주십시요.");
				 mySheet.SelectCell(arrRow[idx], "LEAD_TIME");
                 return;
			}
			
			if(kepIsValueNull(STOA_LIST_PRICE)) {
				 alert("제출단가(숫자형식)를 입력하여 주십시요.");
				 mySheet.SelectCell(arrRow[idx], "STOA_LIST_PRICE");
                return;
			}
			
			if(STOA_LIST_PRICE <= 1) {
				alert("유효하지 않는 견적단가입니다.");
				return;
			}
			
			if(kepIsValueNull(MIN_ORDER_QTY) || MIN_ORDER_QTY < 1 || !kepIsNumChkStr(MIN_ORDER_QTY,2)){
				alert("MOQ(숫자형식)를 입력하여 주십시요.");
				mySheet.SelectCell(arrRow[idx], "MIN_ORDER_QTY");
				return;
			}
			if(kepIsValueNull(PUR_UNIT_QTY) || PUR_UNIT_QTY < 1 || !kepIsNumChkStr(PUR_UNIT_QTY,2)){
				alert("발주배수(숫자형식)를 입력하여 주십시요.");
				mySheet.SelectCell(arrRow[idx], "PUR_UNIT_QTY");
				return;
			}
			if( MIN_ORDER_QTY < PUR_UNIT_QTY ){
				alert("MOQ는 발주배수보다 작을 수 없습니다.");
				mySheet.SelectCell(arrRow[idx], "MIN_ORDER_QTY");
				return;
			}
			
			if(DELI_AREA_USE_FLAG == "Y"){
				if(kepIsValueNull(SELLER_AREA)){
					alert("납품지역을 선택하여 주십시요.");
					mySheet.SelectCell(arrRow[idx], "SELLER_AREA_YN");
					return;
				}
			}
			
			if(PROCESS_TYPE_FLAG == "Y"){
				if(kepIsValueNull(PROCESS_TYPE)){
					alert("거래유형을 선택하여 주십시요.");
					mySheet.SelectCell(arrRow[idx], "PROCESS_TYPE");
					return;
				}
			}
			
			if(<%=p03302303%> == true){
				if(SELLER_ITEM_NO == "" || kepIsValueNull(SELLER_ITEM_NO)){
					alert("협력사품목코드를 입력하여 주십시요.");
					mySheet.SelectCell(arrRow[idx], "SELLER_ITEM_NO");
					return;
				}
			}
			
			if(SG_ID == "SG118" || SG_ID == "SG120" || SG_ID == "SG153" || SG_ID == "SG163"){
				sg_alert_flag = true;
			}
		}
		
		if(sg_alert_flag) {
			alert("냉장 / 냉동 품목은 TR(물류센터) 거래 불가능합니다.\n견적 제출 전 협력사비고란에 품목 보관조건을 꼭 기재하여 제출 부탁드립니다.");
		}
		
		//Confirm 처리 방식.
		g_confirm_type = "agentHandout"; // Confirm 타입 선언
		$("#confirmMsgDiv").text("견적을 제출하시겠습니까?"); //Confirm 문구 입력
		$("#confirmAreaDiv").show(); //Confirm 창 확인.
	}else{
		if(arrRow.length > 1){
			alert("한번에 하나의 견적만 포기 가능 합니다.");
			return;	
		}
		//Confirm 처리 방식.
		g_confirm_type = "giveup"; // Confirm 타입 선언
		$("#confirmMsgDiv").text("견적을 포기하시겠습니까?"); //Confirm 문구 입력
		$("#confirmAreaDiv").show(); //Confirm 창 확인.
	}
}
//Confrim창 확인처리
function confirmAreaDivSearch(){
	$("#confirmAreaDiv").hide();	
	if(g_confirm_type == "agentHandout"){ //견적제출
		kepSave(document.searchCondition, mySheet, "/mprq/saveSellerMpRqQuotReqList.do", "SELECTED");
	}else if(g_confirm_type == "giveup"){ //견적포기
		openSearchPopup("/common/mprq/estimateAbandonmentReasonPop.do", "", "410,400,no");
	}
}
/*
 * 견적요청서 목록
 */
function ReqSourcingList(btnEvent) {
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	var deli_query = "";
	
	// 선택된 항목 유무 체크
	if (checkRows.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	for(var idx=0; idx<arrRow.length; idx++){
		var BUYER = mySheet.GetCellValue(arrRow[idx], "BUYER");
		var QUOTATION_NO = mySheet.GetCellValue(arrRow[idx], "QUOTATION_NO");
		var QUOTATION_SEQ = mySheet.GetCellValue(arrRow[idx], "QUOTATION_SEQ");
		var REVISION = mySheet.GetCellValue(arrRow[idx], "REVISION");
		
		deli_query += BUYER;
        deli_query += QUOTATION_NO;
        deli_query += QUOTATION_SEQ;
        deli_query += REVISION;
        deli_query += "^||^";
	}
	
	var param =  "["+deli_query+"]["+"${sessionInfo.comCode}"+"]";
	var fileName = "RD_04_B_008_03";
	
	reportOpen(fileName,param);
}

function AgentGiveUp(reason) { 
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	for(var idx=0; idx<arrRow.length; idx++){
		mySheet.SetCellValue(arrRow[idx], 'GIVEUP_REMARK', reason);
	}
    
	$('#st_giveup_yn').val("Y");
	kepSave(document.searchCondition, mySheet, "/mprq/saveSellerMpRqQuotReqList.do", "SELECTED");
  
 }
</script>
</head>
<%
@SuppressWarnings (value="unchecked")
String userID = _sessionInfo.getUserId();
%>
<body onload="kep_onload_view()">
<div id="wrapper">
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>
<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="sellerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
	<!--내용 시작-->
<!--내용 시작-->
<div id="ContArea">
	
		<!--버튼영역-->
       	<div id="searchBtnA">
       		<h3>견적요청접수</h3>
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition" name="searchCondition" method="post" onsubmit="return false;" >
			<div>
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME" />
				<input type="hidden" id="pageflag" name="pageflag" value="1" />
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_user_id" name="st_user_id" value="${sessionInfo.userId}" />
				<input type="hidden" id="st_com_code" name="st_com_code" value="${sessionInfo.comCode}" />
				<input type="hidden" id="st_user_name" name="st_user_name" value="${sessionInfo.userNameLoc}">
				<input type="hidden" id="st_user_tel" name="st_user_tel" value="${sessionInfo.tel}">
				<input type="hidden" id="st_corp_code" name="st_corp_code" value="" />
				<input type="hidden" id="st_giveup_yn" name="st_giveup_yn" value="N">
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" onChange="doAction('search');">
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
				</select>
			</span>
			<br>
		</form>
					
      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "", "354px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>

  		<!--버튼영역-->
  		<div class="btnArea">
			<span class="fl" style="text-align:left">
				<font style="color: red; size: 12px;"><b>※단가/조달일수는 고객사 도착도 기준으로 입력해주세요.</b></font>
				<font style="color: black; size: 12px;">(그리드 내 노란색 배경 셀은 필수 입력 항목)</font>
				<br>
				<font style="color: black; size: 12px;">거래유형 : KeP물류센터 = TR 선택  <b>//</b>  MOQ : 최소발주수량  <b>//</b>  발주배수 : 주문 가능한 수량단위(예 : 발주배수 4 입력 시 구매수량 4, 8, 12, ... 4의 배수로 통제)</font>
			</span>
			<span class="fr">
				<span class="btn_08 mr04"><a href="javaScript:doPop('deliAreaPopMulti');">납품지역 일괄선정</a></span>
				<span class="btn_06 mr04"><a href="javaScript:doAction('reqSourcing');">견적요청서 목록</a></span>
				<span class="btn_04 mr04"><a href="javaScript:doAction('agentHandout');">견적제출</a></span>
				<span class="btn_04 "><a href="javaScript:doAction('cancel');">견적포기</a></span>
			</span>
		</div>
<!--내용 종료-->
</div>
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>
</div>
</body>
</html>
