<%--
**********************************************
* 메뉴 : 
* 화면 : 견적단가이력
* 기능 : 견적번호에 대한 견적단가 이력 조회-(추가요구:품목명,규격,수량추가) 
* 프로그램 ID : PG_04_M_006_03
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-06-16
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;

var areaOn = "/resources/images/icon.gif";
var areaOff = "/resources/images/icon2.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	      			  {Align : "Center",SaveName : "sStatus",				Header : "상태",		Type : "Status",	Width : 60,	Hidden : 1}
	    			, {Align : "Center",SaveName : "SELECTED",				Header : "",		Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:true}
	    			, {Align : "Center",SaveName : "REVISION",				Header : "차수",		Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "QUOTATION_NO",			Header : "견적번호",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "QUOTATION_SEQ",			Header : "순번",		Type : "Text",	Width : 60,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "BUYER_ITEM_NO",			Header : "품목코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Left",	SaveName : "DESCRIPTION",			Header : "품목명",	Type : "Text",	Width : 150,	EditLen : 110,	Hidden:false, Edit : false}
	    			, {Align : "Left",	SaveName : "KEP_DESCRIPTION",		Header : "품목명(고)",	Type : "Text",	Width : 150,	EditLen : 110,	Hidden:false, Edit : false}
	    			, {Align : "Left",	SaveName : "SPECIFICATION",			Header : "규격",		Type : "Text",	Width : 200,	EditLen : 110,	Hidden:false, Edit : false}
	    			, {Align : "Left",	SaveName : "KEP_SPECIFICATION",		Header : "규격(고)",	Type : "Text",	Width : 200,	EditLen : 110,	Hidden:false, Edit : false}
	    			, {Align : "Left",	SaveName : "MAKER_NAME",			Header : "제조사",	Type : "Text",	Width : 150,	EditLen : 110,	Hidden:false, Edit : false}
	    			, {Align : "Left",	SaveName : "KEP_MAKER_NAME",		Header : "제조사(고)",	Type : "Text",	Width : 150,	EditLen : 110,	Hidden:false, Edit : false}
	    			, {Align : "Right",	SaveName : "ITEM_QTY",				Header : "수량",		Type : "Float",  Format:"${qtyFormat}",	Width : 60,	EditLen : 110,	Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "ATOB_DATE",				Header : "견적제출일",	Type : "Date",	Width : 90,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Right",	SaveName : "BTOA_NEGO_PRICE",		Header : "Nego 단가",	Type:"Float",	 Format:"${priceFormat}",	Width : 80,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Right",	SaveName : "ATOB_UNIT_PRICE",		Header : "견적제출단가",Type:"Float",	 Format:"${priceFormat}",	Width : 80,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Right",	SaveName : "BUYER_TARGET_PRICE",	Header : "요청단가",	Type:"Float",	 Format:"${priceFormat}", 	Width : 80, EditLen : 110,	Edit : false, Hidden : false}
	    			, {Align : "Right",	SaveName : "ADMIN_TARGET_PRICE",	Header : "목표단가",	Type:"Float",	 Format:"${priceFormat}", 	Width : 80,	EditLen : 110,	Edit : false}
	    			, {Align : "Left",	SaveName : "REJECT_REMARK",			Header : "NEGO요청사유",	Type : "Text",	Width : 130,	EditLen : 110,	Edit : false}
	    			, {Align : "Left",	SaveName : "BUYER_NAME",			Header : "고객사명",	Type : "Text",	Width : 130,	EditLen : 110,	Edit : false,Hidden:true}
	    			, {Align : "Center",SaveName : "CHANGE_DATE",			Header : "최종실적일자",	Type : "Date",	Width : 90,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Right",	SaveName : "UNIT_PRICE",			Header : "최종실적단가",	Type:"Float",	 Format:"${priceFormat}", 	Width : 80,	EditLen : 110,	Edit : false}
	    			, {Align : "Left",	SaveName : "BUYER_ASSIGN_AGENT_CODE",Header : "지정협력사(B)",	Type : "Text",	Width : 150,	EditLen : 100,	Edit : false}
	    			, {Align : "Center",SaveName : "IMAGE_KEY_IMG",			Header : "첨부파일",	Type : "Image",	Width : 60,	EditLen : 100,	Edit : false,	Hidden:false}
	    			, {Align : "Center",SaveName : "IMAGE_KEY",				Header : "첨부파일키",	Type : "Text",	Width : 100,	EditLen : 100,	Edit : false,	Hidden:true}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4);//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	
	var initsheet2 = {};
	
	initsheet2.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}
	    			, {Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:true}
	    			, {Align : "Center",SaveName : "AGENT_REVISION",		Header : "차수",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "QUOTATION_NO",		Header : "견적번호",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "QUOTATION_SEQ",		Header : "순번",	Type : "Text",	Width : 60,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 150,	EditLen : 110,	Hidden:false, Edit : false}
	    			, {Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 200,	EditLen : 110,	Hidden:false, Edit : false}
	    			, {Align : "Right",SaveName : "ITEM_QTY",		Header : "수량",	Type : "Float",  Format:"${qtyFormat}",	Width : 60,	EditLen : 110,	Hidden:false, Edit : false}
	    			, {Align : "Left",SaveName : "AGENT_NAME",		Header : "기제출협력사",	Type : "Text",	Width : 110,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "ATOS_DATE",		Header : "견적요청일",	Type : "Date",	Width : 90,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "ADD_USER_NM",		Header : "견적요청자",	Type : "Text",	Width : 90,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "ATOS_DATE2",		Header : "견적요청일",	Type : "Text",	Width : 90,	EditLen : 110,Hidden:true, Edit : false}
	    			, {Align : "Right",SaveName : "LEAD_TIME",		Header : "조달일수",	Type:"Int",	 Format:"${qtyFormat}",	Width : 60,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "ATOS_END_DATE",		Header : "견적마감일",	Type : "Text",	Width : 100,	EditLen : 115,Hidden:false, Edit : false}
	    			, {Align : "Right",SaveName : "STOA_LIST_PRICE",		Header : "매입단가",	Type:"Text",	Width : 80,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Right",SaveName : "STOA_LIST_PRICE2",		Header : "제시단가",	Type:"Text",	Width : 80,	EditLen : 110,Hidden:true, Edit : false}
	    			, {Align : "Right",SaveName : "ATOB_UNIT_PRICE",		Header : "매출단가",	Type:"Text",	 	Width : 80, EditLen : 110,	Edit : false, Hidden : false}
	    			, {Align : "Left",SaveName : "STOA_REMARK",		Header : "협력사기재비고",	Type : "Text",	Width : 200,	EditLen : 110,	Edit : false}
	    			, {Align : "Left",SaveName : "ATOS_REMARK",		Header : "운영사기재비고",	Type : "Text",	Width : 200,	EditLen : 110,	Edit : false}
	    			, {Align : "Left",SaveName : "ATOS_REMARK2",		Header : "운영사기재비고이력",	Type : "Text",	Width : 200,	EditLen : 110,	Edit : false}
	    			, {Align : "Left",SaveName : "BUYER",		Header : "고객사",	Type : "Text",	Width : 200,	EditLen : 110,	Hidden:true, Edit : false}
	    			, {Align : "Left",SaveName : "END_TIME_FLAG",		Header : "END_TIME_FLAG",	Type : "Text",	Width : 50,	EditLen : 110,	Hidden:true, Edit : false}
	    			, {Align : "Left",SaveName : "SEND_FLAG",		Header : "SEND_FLAG",	Type : "Text",	Width : 50,	EditLen : 110,	Hidden:true, Edit : false}
	    			, {Align : "Left",SaveName : "BID_SUCCESS_FLAG",		Header : "BID_SUCCESS_FLAG",	Type : "Text",	Width : 50,	EditLen : 110,	Hidden:true, Edit : false}
	    			, {Align : "Left",SaveName : "STOA_LIST_FLAG",		Header : "STOA_LIST_FLAG",	Type : "Text",	Width : 50,	EditLen : 110,	Hidden:true, Edit : false}
	    			, {Align : "Left",SaveName : "AGENT_SEND_FLAG",		Header : "AGENT_SEND_FLAG",	Type : "Text",	Width : 50,	EditLen : 110,	Hidden:true, Edit : false}
	    			, {Align : "Left",SaveName : "STATUS",		Header : "STATUS",	Type : "Text",	Width : 50,	EditLen : 110,	Hidden:true, Edit : false}
	    			, {Align : "Left",SaveName : "AGENT",		Header : "AGENT",	Type : "Text",	Width : 50,	EditLen : 110,	Hidden:true, Edit : false}
	    			, {Align : "Left",SaveName : "OPEN_FLAG",		Header : "OPEN_FLAG",	Type : "Text",	Width : 50,	EditLen : 110,	Hidden:true, Edit : false}
	    			, {Align : "Right",SaveName : "MIN_ORDER_QTY",	Header : "MOQ",		Type:"Int",	Format:"${qtyFormat}",	Width : 50,	EditLen : 10,Hidden:false, Edit : false}
	    			, {Align : "Right",SaveName : "PUR_UNIT_QTY",		Header : "발주배수",	Type:"Int",	Format:"${qtyFormat}",	Width : 60,	EditLen : 10,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "SELLER_AREA_IMG",	Header : "납품지역",	Type : "Image",	Width : 60,	EditLen : 110,	Edit : false}
	    			, {Align : "Center",SaveName : "SELLER_AREA",		Header : "납품지역",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true}
	    			, {Align : "Center",SaveName : "PROCESS_NM",		Header : "거래유형",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:false}
	    			, {Align : "Center",SaveName : "SELLER_IMAGE_KEY",	Header : "첨부파일",	Type : "Text",	Width : 100,	EditLen : 100,	Edit : false,	Hidden:true}
	    			, {Align : "Center",SaveName : "IMAGE_KEY_IMG",	Header : "첨부파일",	Type : "Image",	Width : 60,	EditLen : 100,	Edit : false,	Hidden:false}
	];
	
	IBS_InitSheet(mySheet2, initsheet2,pagingMode);
	mySheet2.SetCountPosition(4);//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	
	var initsheet3 = {};
	initsheet3.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}
	    			, {Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:true}
	    			, {Align : "Center",SaveName : "NEGO_SEQ",		Header : "네고순번",	Type : "Text",	Width : 70,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "QUOTATION_NO",		Header : "견적번호",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "QUOTATION_SEQ",		Header : "순번",	Type : "Text",	Width : 60,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "REVISION",		Header : "차수",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Right",SaveName : "NEGO_PRICE",		Header : "Nego단가",	Type:"Float",	 Format:"${priceFormat}",	Width : 100,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Right",SaveName : "BTOA_NEGO_PRICE",		Header : "고객사Nego단가",	Type:"Float",	 Format:"${priceFormat}",	Width : 100,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "NEGO_DATE",		Header : "Nego일자",	Type : "Date",	Width : 90,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Left",SaveName : "BTOA_NEGO_REMARK",		Header : "Nego사유",	Type : "Text",	Width : 180,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "CREATE_USER_ID",		Header : "생성자",	Type : "Text",	Width : 90,	EditLen : 110,Hidden:false, Edit : false}
	];
	
	IBS_InitSheet(mySheet3, initsheet3,pagingMode);
	mySheet3.SetCountPosition(4);//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqQuotationUnitpriceHistoryPop.do" , pagingMode );
	kepSearch(document.searchCondition ,  mySheet2 , "/mprq/getMasterMpRqQuotationUnitpriceHistoryPop2.do" , pagingMode );
	kepSearch(document.searchCondition ,  mySheet3 , "/mprq/getMasterMpRqQuotationUnitpriceHistoryPop3.do" , pagingMode );
	//하이퍼링크 설정
	setLinkCol(mySheet, "IMAGE_KEY_IMG"); // 첨부파일
	setLinkCol(mySheet2, "AGENT_REVISION");
	setLinkCol(mySheet2, "SELLER_AREA_IMG");
	setLinkCol(mySheet2, "IMAGE_KEY_IMG"); // 첨부파일
	
	mySheet.SetImageList(2, diskOff);
	mySheet.SetImageList(3, diskOn);
	mySheet2.SetImageList(3, diskOn);
	mySheet2.SetImageList(2, diskOff);
	mySheet2.SetImageList(5, areaOn);
	mySheet2.SetImageList(4, areaOff);
	
	mySheet.SetFocusAfterProcess(0);
}

var st;
var mt;
function doAction(str) {
	switch (str) {
	case "print":
// 		mySheet2.DoPrint();
		aaaa = mySheet2.GetSheetHtml();
		window.open("/mprq/showPop.do",'',"width=5,height=5,left=0,top=0");
		break;
	case "excelDown":
	    $("#pageflag").val('0');
		var param = {FileName:"견적단가이력.xlsx",Merge:1,SheetDesign:1,DownCols:"AGENT_REVISION|QUOTATION_NO|QUOTATION_SEQ|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|ITEM_QTY|AGENT_NAME|ATOS_DATE2|ATOS_END_DATE|STOA_LIST_PRICE2|ATOB_UNIT_PRICE|STOA_REMARK|MIN_ORDER_QTY|PUR_UNIT_QTY"};
// 		mySheet2.Down2Excel(param);
		kepDownExcel(document.searchCondition ,mySheet2 , "/mprq/excelMasterMpRqQuotationUnitpriceHistoryPop2.do", param);
		$("#pageflag").val('1');
		break;
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

function mySheet_OnSearchEnd(code, msg) {
	loader_obj("N","2");
   	if(mySheet.RowCount() <= 0) return;
   	
   	$('#st_buyer_name').val(mySheet.GetCellValue(1, "BUYER_NAME"));
   	
	if (msg != "") {
		alert(msg);
	}
}
function mySheet2_OnSearchEnd(code, msg) {
	loader_obj("N","2");
   	if(mySheet2.RowCount() <= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}
	var stoaListPrice = "";
	var atobUnitPrice = "";
	for(var i=1; i<=mySheet2.RowCount();i++){
		if ('KRDOOD0001,KRKEPB0004,KRPOON0010,KRDOOS0009,KRDOOS0006'.indexOf(mySheet2.GetCellValue(i, "BUYER"))>-1
				&& (mySheet2.GetCellValue(i, "END_TIME_FLAG") == "Y"||mySheet2.GetCellValue(i, "SEND_FLAG") == "Y")) {
			mySheet2.SetCellFontColor(i,"REVISION","#0100FF");
		} 
		
		if (mySheet2.GetCellValue(i, "BID_SUCCESS_FLAG") == "Y"){
			mySheet2.SetCellFontColor(i,"AGENT_NAME","#0100FF");
			mySheet2.SetCellFontBold(i,"AGENT_NAME",1);
		} 
		
		if (mySheet2.GetCellValue(i, "OPEN_FLAG") == "N"){
			if (mySheet2.GetCellValue(i, "END_TIME_FLAG") == "N" && mySheet2.GetCellValue(i, "SEND_FLAG") == "N"){
				 if (mySheet2.GetCellValue(i, "AGENT_SEND_FLAG") == "Y"){
					mySheet2.SetCellValue(i,"STOA_LIST_PRICE","******");
					mySheet2.SetCellValue(i,"STOA_LIST_PRICE2","******");
					mySheet2.SetCellValue(i,"ATOB_UNIT_PRICE","******");
				 } else {
					mySheet2.SetCellValue(i,"STOA_LIST_PRICE","0");
					mySheet2.SetCellValue(i,"STOA_LIST_PRICE2","0");
					mySheet2.SetCellValue(i,"ATOB_UNIT_PRICE","0");
				 }
			}
		} else {
			stoaListPrice = kepNumComma2(mySheet2.GetCellValue(i, "STOA_LIST_PRICE"));
			atobUnitPrice = kepNumComma2(mySheet2.GetCellValue(i, "ATOB_UNIT_PRICE"));
			mySheet2.SetCellValue(i,"STOA_LIST_PRICE",stoaListPrice);
			mySheet2.SetCellValue(i,"STOA_LIST_PRICE2",stoaListPrice);
			mySheet2.SetCellValue(i,"ATOB_UNIT_PRICE",atobUnitPrice);
		}
			
// 		if (mySheet2.GetCellValue(i, "OPEN_FLAG") == "N"){
// 			 mySheet2.SetCellValue(i,"STOA_LIST_PRICE","******");
// 			 mySheet2.SetCellValue(i,"STOA_LIST_PRICE2","******");
// 			 mySheet2.SetCellValue(i,"ATOB_UNIT_PRICE","******");
// 		} else {
// 			stoaListPrice = kepNumComma2(mySheet2.GetCellValue(i, "STOA_LIST_PRICE"));
// 			atobUnitPrice = kepNumComma2(mySheet2.GetCellValue(i, "ATOB_UNIT_PRICE"));
// 			mySheet2.SetCellValue(i,"STOA_LIST_PRICE",stoaListPrice);
// 			mySheet2.SetCellValue(i,"STOA_LIST_PRICE2",stoaListPrice);
// 			mySheet2.SetCellValue(i,"ATOB_UNIT_PRICE",atobUnitPrice);
			
// 		}
			 
		
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	if(column == "IMAGE_KEY_IMG"){
		popupSel = "fileUpload";
		var type="RFQ";
		var viewType="R";
		var image_key = mySheet.GetCellValue(Row, "IMAGE_KEY");
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}
	
	return;
}

function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "AGENT_REVISION" ){ 
		
		//SLOGIC-BEGIN(P04-4039-01)
		if ('KRDOOD0001,KRKEPB0004,KRPOON0010,KRDOOS0009,KRDOOS0006'.indexOf(mySheet2.GetCellValue(Row, "BUYER"))>-1
				&& (mySheet2.GetCellValue(Row, "END_TIME_FLAG") == "Y"||mySheet2.GetCellValue(Row, "SEND_FLAG") == "Y")) {
		// 출력물 연결
		var st_buyer = "${param.st_buyer}";
		var st_quotation_no = "${param.st_quotation_no}";
		var st_quotation_seq = "${param.st_quotation_seq}";
		var st_revision = "${param.st_revision}";
		var st_agent = mySheet2.GetCellValue(Row, "AGENT") ;
		var st_open_flag = "N";//"Y";
		var st_status = mySheet2.GetCellValue(Row, "STATUS") ;
		var st_agent_revision = mySheet2.GetCellValue(Row, "AGENT_REVISION") ;	
		
		var fileName = "RD_04_M_005_05";
		var param = "["+st_buyer+"]["+st_quotation_no+"]["+st_quotation_seq+"]["+st_revision+"]["+st_agent+"]["+st_open_flag+"]["+st_status+"]["+st_agent_revision+"]";
		reportOpen(fileName,param);
		//SLOGIC-END
		
// 			window.open("/kr/customer/new_sourcing/sheet/buyer/sysop_proxbuy_sourcing_print_buyer_report_doosan_sheet.jsp?
// 		st_buyer="+buyer+"&st_quotation_no="+quotation_no+"&st_quotation_seq="+quotation_seq+"&st_revision="+revision+"&st_agent="+agent+"&st_open_flag="+open_flag+"&st_status="+status+"&st_agent_revision="+agent_revison, "SheetWin","width=700,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
		 }

	}else if(column == "SELLER_AREA_IMG"){
		popupSel = "deliAreaPop";
		var buyer = "${param.st_buyer}";
		var seller_area = mySheet2.GetCellValue(Row, "SELLER_AREA");
		openSearchPopup("/common/getDeliveryAreaPop.do", '?st_com_code='+buyer+'&st_area_list='+seller_area+'&mod_yn=N', "400,270,no");
	}else if(column == "IMAGE_KEY_IMG"){
		popupSel = "fileUpload";
		var type="RFQ";
		var viewType="R";
		var image_key=mySheet2.GetCellValue(Row, "SELLER_IMAGE_KEY");
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}else if(column == "BUYER_IMAGE_KEY_IMG"){
		popupSel = "fileUpload";
		var type="RFQ";
		var viewType="R";
		var image_key=mySheet.GetCellValue(Row, "BUYER_IMAGE_KEY");
		alert("image_key " +image_key);
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}
	
	return;
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

function mySheet2_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

</script>
<title>코리아 e 플랫폼</title>
</head>

<body onload="kep_onload_view();">
<!--조회영역-->
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">	
	<input type="hidden" id="st_buyer_code"  name="st_buyer_code" value="${param.st_buyer}">	
	<input type="hidden" id="st_quotation_no"  name="st_quotation_no" value="${param.st_quotation_no}">	
	<input type="hidden" id="st_quotation_seq"  name="st_quotation_seq" value="${param.st_quotation_seq}">	
	<input type="hidden" id="st_revision"  name="st_revision" value="${param.st_revision}">	

	<!-- 500*350 -->
	<div id="popWrapper" style="height:502px;">
    	<div id="popHeader">
        	<h1 class="title">견적단가이력</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <div id="popContainer">
			<!--팝업내용입니다-->
			<div id="a" style="height:15px;padding-top:4px;">
				<span class="text10 ml20">고객사 :
				<input type="text" name="st_buyer_name" id="st_buyer_name" class="input_type_text" readonly="readonly" style="width:90%;height:15px;font-color:#FF0000;border:0;color:orange; font-weight:bold;" value="" />
				</span> 
			</div>
	        <div id="a" class="mt10">
	        	<!--grid-->
	 			<div style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "", "110px");
					</script>
				</div>
	<!-- 			<div id="pageindex"></div> -->
			</div>
			<div id="b" style="height:25px;">
				<span class="text10 ml20">협력사
					<input type="text" class="input_type_text" readonly="readonly" style="width:90%;height:15px;border:0;" value="                  ※ 파란색으로 표기된 협력사가 선정된 협력사입니다." />
				</span> 
			</div>
	        	<!--grid-->
	 			<div style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet2", "", "180px");
					</script>
				</div>
	<!-- 			<div id="pageindex"></div> -->
			<div id="b" style="height:25px;">
				<span class="text10 ml20">네고이력
<!-- 					<input type="text" class="input_type_text" readonly="readonly" style="width:90%;height:15px;border:0;" value="                  ※ 협력사명에 파란색은 선정된 협력사 입니다." /> -->
				</span> 
			</div>
	        <div id="b">
	        	<!--grid-->
	 			<div style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet3", "", "120px");
					</script>
				</div>
			</div>
			<!--버튼영역-->
	        <div class="mr25 mt10" style="height:24px">
				<span class="fr">
					<span class="btn_05 mr04"><a href="javascript:doAction('print')">협력사 이력출력</a></span>
					<!-- span class="btn_04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span -->
				</span>
	        </div>
        </div>
    </div>
</form>
		
</body>
</html>
