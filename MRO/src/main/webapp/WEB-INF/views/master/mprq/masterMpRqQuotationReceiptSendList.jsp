<%--
**********************************************
* 메뉴 : 견적관리>업체선정 및 견적제출(두중)>견적접수및견적제출 조회
* 화면 : 견적접수및견적제출 조회
* 기능 : 두산중공업 전용 견적접수 및 견적제출을 위한 상세정보화면
* 프로그램 ID : PG_04_M_008_01
* 담당자 : 견적개 ( 설계 : 권우재 )
* 착수일 : 2014-07-04
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var iconR="/resources/images/icon_r.gif";
var iconY="/resources/images/icon_y.gif";
var iconG="/resources/images/icon_g.gif";
var iconPrint="/resources/images/icon_print.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msPrevColumnMerge + msHeaderOnly, FrozenCol : 7};
	initsheet.Cols = [ 
	                  { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus",ColMerge:0}
						,{ Align:"Center",	Width:18,	Edit : true,	EditLen:100,	Hidden : false,	Type:"Image",	Header:"",	SaveName:"PRINT"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사",	SaveName:"BUYER"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"진행상태",	SaveName:"STATUS"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적번호",	SaveName:"QUOTATION_NO"}
						,{ Align:"Center",	Width:40,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED",ColMerge:0}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"순번",	SaveName:"QUOTATION_SEQ",ColMerge:0}
						,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"차수",	SaveName:"REVISION2",ColMerge:0}
						,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"차수",	SaveName:"REVISION",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"견적의뢰일",	SaveName:"BTOA_DATE",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"회신요청일",	SaveName:"BTOA_END_DATE",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적마감일",	SaveName:"ATOS_END_DATE_TIME",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"견적요청일",	SaveName:"ATOS_DATE",ColMerge:0}
						,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"접수건수",	SaveName:"BIDDING_COUNT",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"선정협력사",	SaveName:"AGENT",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"선정협력사",	SaveName:"PICK_AGENT_NAME",ColMerge:0}
						,{ Align:"Center",	Width:15,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"품목코드",	SaveName:"SIGNAL",ColMerge:0}
						,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO",ColMerge:0}
						,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	ToolTip:1,	Header:"품목명",	SaveName:"DESCRIPTION",ColMerge:0}
						,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	ToolTip:1,	Header:"규격",	SaveName:"SPECIFICATION",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME",ColMerge:0}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_CODE",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NAME",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_CODE",ColMerge:0}
						,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}", 	Header:"요청단가",	SaveName:"BUYER_TARGET_PRICE",ColMerge:0}
						,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}", 	Header:"목표단가",	SaveName:"ADMIN_TARGET_PRICE",ColMerge:0}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",	SaveName:"BTOA_USER_NAME",ColMerge:0}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자",	SaveName:"BTOA_USER_ID",ColMerge:0}
						,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"공개",	SaveName:"AGENT_OPEN_FLAG",ColMerge:0}
						,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"공개",	SaveName:"CP_AGENT_OPEN_FLAG",ColMerge:0}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고",	SaveName:"STOA_REMARK_IMG",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고",	SaveName:"STOA_REMARK",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고",	SaveName:"BTOA_REMARK",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고",	SaveName:"ATOS_REMARK",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고",	SaveName:"ATOB_REMARK",ColMerge:0}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"취소",	SaveName:"CANCEL_REMARK_IMG",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"취소사유",	SaveName:"CANCEL_REMARK",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"담당자",	SaveName:"RFQ_KEP_USER_NAME",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"담당자",	SaveName:"RFQ_KEP_USER",ColMerge:0}
						,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Format:"${rateFormat}", Header:"매익률",	SaveName:"RATE",ColMerge:0}
						,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float",  Format:"${qtyFormat}",	Header:"ITEM_QTY",	SaveName:"ITEM_QTY",ColMerge:0}
						,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}", 	Header:"매출단가",	SaveName:"ATOB_UNIT_PRICE",ColMerge:0}
						,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}", 	Header:"매입단가",	SaveName:"STOA_LIST_PRICE",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"매익률",	SaveName:"CP_AGENT_OPEN_FLAG",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"END_TIME_FLAG",	SaveName:"END_TIME_FLAG",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PM_FLAG",	SaveName:"PM_FLAG",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PASS_FLAG",	SaveName:"PASS_FLAG",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"DUTY_KEP",	SaveName:"DUTY_KEP",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SEND_FLAG",	SaveName:"SEND_FLAG",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"INIT_BELOW_COMORG_CODE",	SaveName:"INIT_BELOW_COMORG_CODE",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CONTRACT_NO",	SaveName:"CONTRACT_NO",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CONTRACT_SEQ",	SaveName:"CONTRACT_SEQ",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float",	Header:"BTOA_NEGO_PRICE",	SaveName:"BTOA_NEGO_PRICE",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"REJECT_REMARK",	SaveName:"REJECT_REMARK",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"UNIT_MEASURE",	SaveName:"UNIT_MEASURE",ColMerge:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"IMGFILE_NAME",	SaveName:"IMGFILE_NAME",ColMerge:0}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4);
	
	//비고이미지설정
	mySheet.SetImageList(1, iconR);
	mySheet.SetImageList(2, iconY);
	mySheet.SetImageList(3, iconG);
	mySheet.SetImageList(4, iconPrint);
	mySheet.SetImageList(5, remarkOn);
	mySheet.SetImageList(6, remarkOff);

	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL','');

	//하이퍼링크 설정
	setLinkCol(mySheet, "PRINT");
	setLinkCol(mySheet, "BUYER_NAME");
	setLinkCol(mySheet, "REVISION2");
// 	setLinkCol(mySheet, "BUYER_ITEM_NO");	//품목코드
	setLinkCol(mySheet, "QUOTATION_NO");	//견적번호
	setLinkCol(mySheet, "PICK_AGENT_NAME");
	setLinkCol(mySheet, "STOA_REMARK_IMG");
	setLinkCol(mySheet, "CANCEL_REMARK_IMG");
	setLinkCol(mySheet, "BIDDING_COUNT");
	
	mySheet.SetCellFontUnderline(0, "STOA_REMARK_IMG", true);	
	mySheet.SetCellFontUnderline(0, "CANCEL_REMARK_IMG", true);	
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	mySheet.SetDataAlternateBackColor("#FFFFFF"); 
	
	HdQuery();
	doAction('search');
}
function HdQuery(){
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mprq/getMasterMpRqQuoSendHd.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { st_buyer: $("#st_buyer").val(),st_quotation_no: $("#st_quotation_no").val(),st_revision: $("#st_revision").val()},
	     async : false,
	     success:function( response ) {
		    	 if (response.data.length > 0){
		    		$("#buyer_name").text($.trim(eval("response.data[0].BUYER_NAME")));
		    		$("#quotation_no").text('${param.st_quotation_no}');
		    		$("#btoa_date").text($.trim(eval("response.data[0].BTOA_DATE")));
		    		$("#btoa_user_name").text($.trim(eval("response.data[0].BTOA_USER_NAME")));
		    		$("#btoa_user_tel").text($.trim(eval("response.data[0].BTOA_USER_TEL")));
		    		$("#btoa_user_fax").text($.trim(eval("response.data[0].BTOA_USER_FAX")));
		    	 }
		      },
		 error:function( response ) {  		    	   
	    	 alert("오류발생하였습니다.");
		      }	
	 }); 
}	
var st;
var mt;
var gubun = "";
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload"  && str != "back" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
			current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mprq/getMasterMpRqQuotationReceiptSendList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
			mySheet.RemoveAll();
		break;

	case "save": // 저장
		var buyer = mySheet.GetCellValue(arrRow[0], "BUYER");
		var st_quotation_list = "";
		for (var i=0; i<arrRow.length; i++){
			// (1)	견적제출하기 위해서 먼저 협력사로부터 모든 견적이 회신되어야 하고, 
			// 마감시간이 지나 마감처리를 해야하며 협력사 선정 및 매출단가(ATOB_UNIT_PRICE)가 지정 되어야 한다.
			if (mySheet.GetCellValue(arrRow[i], "END_TIME_FLAG") == "N"){
				if (mySheet.GetCellValue(arrRow[i], "SEND_FLAG") == "N"){
					alert("협력사로 부터 모든 견적이 회신후 견적제출 가능합니다.");
                    return;
				}
			}
			
			if (kepIsValueNull(mySheet.GetCellValue(arrRow[i], "STOA_LIST_PRICE")) || kepIsValueNull(mySheet.GetCellValue(arrRow[i], "ATOB_UNIT_PRICE"))){
				alert("협력사 지정이 되지 않은 품목은 구매사 제출을 할수 없습니다.\n\n협력사 및 매출단가 지정후 견적제출 바랍니다.");
                return;
			}
			
			// 견적제출건들이 동일한 고객사인지 고객사네고요청건이 아닌지 체크	
			if (buyer != mySheet.GetCellValue(arrRow[i], "BUYER")){
				alert("동일한 고객사를 선택하여 고객사 견적제출(카탈로그 등록)을 하여 주십시요.");
		        return;				
			}
			
			if(mySheet.GetCellValue(arrRow[i], "SIGNAL") =="/resources/images/icon_y.gif") { // 고객사 NEGO
	            alert("NEGO 요청건은 아래의 고객사 NEGO 견적제출 버튼을 클릭하여 주십시요.");
	            return;
	        }
			
			st_quotation_list += mySheet.GetCellValue(arrRow[i], "BUYER") + mySheet.GetCellValue(arrRow[i], "QUOTATION_NO") 
			+ mySheet.GetCellValue(arrRow[i], "QUOTATION_SEQ") + mySheet.GetCellValue(arrRow[i], "REVISION") +"@";
		}
		
		if (confirm('견적제출 하시겠습니까?')){
			location.href = "/mprq/showMasterMpRqBuyerQuotationSendPop.do?st_buyer="+buyer+"&st_quotation_list="+st_quotation_list+"&st_quotation_no="+"${param.st_quotation_no}"+"&st_revision="+"${param.st_revision}";
		}
		
		break;
	case "nego":
		gubun = "nego";
		//SLOGIC-BEGIN(P04-4037-02)
		var quotation_sum = 0;
		var margin_val = 0;
		var status = mySheet.GetCellValue(arrRow[0], "SIGNAL");
		var list_price = 0;
		var stoa_list_price = 0;
		var atob_unit_price = 0;
		for (var i=0; i<arrRow.length; i++){
			if (status != mySheet.GetCellValue(arrRow[i], "SIGNAL")){
				alert("품목코드의 상태가 다릅니다.\n\n같은 상태의 품목코드를 선택후 고객사 견적제출 하여 주십시요.");
		        return;				
			}
		}

		for (var i=0; i<arrRow.length; i++){
	        if(mySheet.GetCellValue(arrRow[i], "SIGNAL") =="/resources/images/icon_r.gif" || mySheet.GetCellValue(arrRow[i], "SIGNAL") == "/resources/images/icon_g.gif") { // 기등록,신규
	            alert("고객사 견적제출하여 주십시요.");
	            return;
	        }

	        atob_unit_price = mySheet.GetCellValue(arrRow[i],"ATOB_UNIT_PRICE");
			if(atob_unit_price == ""){
				alert("매출단가를 입력하여 주십시요");
				return;
			}
			
			if(!kepChkDecimal(atob_unit_price,3)){
				alert("매출단가(숫자형식)를 입력하여 주십시요.");
				return;
			}
			list_price = mySheet.GetCellValue(arrRow[i],"STOA_LIST_PRICE");
			item_qty = mySheet.GetCellValue(arrRow[i],"ITEM_QTY");
			margin_val = eval(atob_unit_price)-eval(stoa_list_price);
			quotation_sum = eval(item_qty) * eval(list_price);	// 두산중공업은 견적금액 50만원 이상시 내부 품의 승인
			
			if(eval(quotation_sum)>=500000 || eval(margin_val)<=0) {
				mySheet.SetCellValue(arrRow[i], 'PM_FLAG', "Y");
		   }else{
				mySheet.SetCellValue(arrRow[i], 'PM_FLAG', "N");
		   }
		}
		
		if (!confirm('Nego 제출을 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mprq/negoMasterMpRqQuotationReceiptSendList.do" , "SELECTED" );
		
		break;
		//SLOGIC-END	
	case "print": // 견적서출력
	//SLOGIC-BEGIN(P04-4037-01)
	
		var totRow = mySheet.RowCount();
		if( totRow<= 0) return;
		
		for(var i=1; i<=totRow;i++){
			if (mySheet.GetCellValue(i, "STATUS") != "협력사선정완료"){
				alert("협력사 선정 이후 견적서 출력이 가능합니다.");
				return;
			}	
		}	
		var buyer = "${param.st_buyer}";
		var quotation_no = "${param.st_quotation_no}";
		var revision = "${param.st_revision}";
		
		var param =  "["+buyer+"]["+quotation_no+"]["+revision+"][Y]";
		var fileName = "RD_04_M_005_00";
		reportOpen(fileName,param);
		
		break;
		//SLOGIC-END	
	case "cancel": // 취소
		gubun = "cancel";
		
		for (var i=0; i<arrRow.length; i++){
			var CANCEL_REMARK    = mySheet.GetCellValue(arrRow[i],"CANCEL_REMARK");
			if(CANCEL_REMARK == ""){
				alert("견적 취소 사유를 입력하여 주십시요");
				return;
			}
		}
		if (!confirm('선택한 항목을 견적취소 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mprq/delMasterMpRqQuotationReceiptSendList.do" , "SELECTED" );
		break;
	case "back": // 뒤로가기
		location.href = '/mprq/showMasterMpRqQuotationReceiptSendLis.do?gubun=search';
		break;
	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
		var param = {FileName:"견적접수및견적제출.xlsx",Merge:1,SheetDesign:1,DownCols:"BUYER_NAME|BUYER|STATUS|QUOTATION_NO|QUOTATION_SEQ|REVISION2|BUYER_ITEM_NODESCRIPTION|SPECIFICATION|MAKER_NAME|ORIGIN_NAME|BUYER_TARGET_PRICE|ADMIN_TARGET_PRICE|BTOA_DATE|BTOA_END_DATE|ATOS_END_DATE_TIME|BTOA_USER_NAME|AGENT_OPEN_FLAG|STOA_REMARK|CANCEL_REMARK|RFQ_KEP_USER_NAME|ATOS_DATE|BIDDING_COUNT|PICK_AGENT_NAME|RATE|ATOB_UNIT_PRICE|STOA_LIST_PRICE"};
		kepDownExcel(document.searchCondition ,mySheet , "/mprq/excelMasterMpRqQuotationReceiptSendList.do", param);
		$("#pageflag").val('1');
		break;
	case "init": // 견적초기화
		gubun = "init";
		var buyer = mySheet.GetCellValue(arrRow[0],"BUYER");
		for(var i=0; i<arrRow.length; i++){
			if (buyer != mySheet.GetCellValue(arrRow[i],"BUYER")){
				alert("동일한 고객사별로 진행가능합니다.");
				return;
			}
		}	
		
		if (!confirm('선택한 항목을 견적초기화 하시겠습니까?'))
			return;
		
		kepSave(document.searchCondition ,  mySheet , "/mprq/initMasterMpRqCmpySelQuotationSendList.do" , "SELECTED" );
		break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;
	
	for(var i=1; i<=totRow;i++){
		mySheet.SetCellValue(i, "SELECTED",1);
		//SLOGIC-BEGIN(P04-4037-03)
		if (mySheet.GetCellValue(i, "END_TIME_FLAG") == "Y"){
			mySheet.SetCellFontColor(i,"ATOS_END_DATE_TIME","#FF0000");
			mySheet.SetCellFontBold(i, "ATOS_END_DATE_TIME",1);
		}
		//SLOGIC-END
		
		if (mySheet.GetCellValue(i, "BUYER") == "KRSSAN0025"){ // 협력사 공개 여부
			mySheet.SetCellEditable(i,"AGENT_OPEN_FLAG",0);
		} 
		
		if(mySheet.GetCellValue(i, "SIGNAL") == "/resources/images/icon_r.gif") { // 기등록
			mySheet.SetCellFontColor(i,"BUYER_ITEM_NO","#0100FF");
		}
	}
	if (msg != "") {
		alert(msg);
	}

}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg.msg != "") {
		alert(msg.msg);
	}

	if(code == 1 && msg.usrmsg != "" && msg.usrmsg != "undefined" && msg.usrmsg != "N"){
		var type = "";
		if (gubun == "nego"){
			type = "SO";
		} else if (gubun == "init"){
			type = "RC";
		}
			var buyer = '${param.st_buyer}';
			openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg.usrmsg+'&PARAM1='+buyer, "1000,500,no");
	}
	if (gubun == "cancel" || gubun == "init" || (gubun == "nego" && msg.usrmsg == "N")){
		doAction('search');
	}
	gubun="";
}

function kepApprovalReturn(flag,docu_no){
	doAction('back');
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqQuotationReceiptSendList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	var buyer = mySheet.GetCellValue(Row, "BUYER");
	var buyer_name = mySheet.GetCellValue(Row, "BUYER_NAME");
	var quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
	var quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
	var revision = mySheet.GetCellValue(Row, "REVISION");
	var agent = mySheet.GetCellValue(Row,"AGENT");
	var openflag = mySheet.GetCellValue(Row,"AGENT_OPEN_FLAG");
	if (openflag == "1"){
		openflag = "Y";
	} else {
		openflag = "N";
	}

	if (column == 'BTOA_USER_NAME') { // 요청자
		var ID = mySheet.GetCellValue(Row,"BTOA_USER_ID");
		if (ID!=""){
			openSearchPopup("/common/userDisplayPop.do", '?user_id='+ID, "800,500,no");
		}
	}else if (column == "REVISION2" ){ 
		popupSel = "masterMpRqQuotationUnitpriceHistoryPop";
		openSearchPopup("/mprq/showMasterMpRqQuotationUnitpriceHistoryPop.do", '?st_buyer='+buyer+'&st_buyer_name='+buyer_name+'&st_quotation_no='+quotation_no+'&st_quotation_seq='+quotation_seq+'&st_revision='+revision, "900,600,no");
		
	} else if (column == 'BUYER_NAME') {
		// 협력사별 견적요청서 양식출력 팝업
		openSearchPopup('/mprq/showMasterMpRqSellerQuotationRequestFormPop.do','?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_quotation_seq='+quotation_seq+'&st_revision='+revision,"500,350,no");
	} else if (column == 'PRINT') { // 출력물
		if(kepIsValueNull(agent)){
			alert("협력사 선정이 되지 않았습니다.\n\n 협력사 선정후 견적서 출력 할수 있습니다.");
			return;
		}
		//SLOGIC-BEGIN(P04-4037-07)
		var param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+agent+"][N]";
		// 협력사 선정 이후 견적서 출력 가능
// 		if (mySheet.GetCellValue(Row,"STATUS") == "협력사선정완료"){
// 			if(buyer=="KRDOOS0015"||buyer=="KRHWAS0031"||buyer=="KRSSAN0025"||buyer=="KRSSAN0028") {
// 				var fileName = "RD_04_M_003_02";
// 				reportOpen(fileName,param);
// 				return;	
// 			}else {
				var fileName = "RD_04_M_005_01";
				reportOpen(fileName,param);
				return;	
// 			}
// 		}
		//SLOGIC-END
	} else if (column == 'PICK_AGENT_NAME') { // 협력사
		if(!kepIsValueNull(agent)) { 
			openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
		}
	
	} else if (column == 'BUYER_ITEM_NO') { // 품목코드
		if(mySheet.GetCellValue(Row, "SIGNAL") == "/resources/images/icon_r.gif") { // 기등록
			var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
			var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
			var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
			openSearchPopup('/common/catalogDetailPop.do','?BUYER='+buyer+'&BUYER_ITEM_NO='+buyerItemNo+'&CONTRACT_NO='+contractNo+'&CONTRACT_SEQ='+contractSeq,"800,290,no");
		}
	}else if (column == "QUOTATION_NO" ){ 
		popupSel = "quotationReDetailPop";
		openSearchPopup("/common/mprq/quotationReDetailPop.do", '?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_revision='+revision+'&viewflag=HANDOUT', "1020,500,no");

	} else if (column == 'BIDDING_COUNT') {
		//SLOGIC-BEGIN(P04-4037-05)
		var endTimeFlag = mySheet.GetCellValue(Row,"END_TIME_FLAG");
		
		if (endTimeFlag == "Y"){
			var rfq_kep_user = mySheet.GetCellValue(Row,"RFQ_KEP_USER"); 
			
			if (kepIsValueNull(mySheet.GetCellValue(Row,"RFQ_KEP_USER"))){
				rfq_kep_user = mySheet.GetCellValue(Row,"DUTY_KEP");
			}
			if (rfq_kep_user.indexOf('${sessionInfo.userId}') == -1){
				alert("해당 견적건에 대한 담당자가 아닙니다.");
				return;
			}

			popupSel = "masterMpRqSellerChoice3Pop";
			var end_time_flag = mySheet.GetCellValue(Row, "END_TIME_FLAG");
			var rcv_agent_flag = mySheet.GetCellValue(Row, "SEND_FLAG");
			
			openSearchPopup("/mprq/showMasterMpRqSellerChoice3Pop.do",'?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_quotation_seq='+quotation_seq+'&st_revision='+revision+'&st_end_time_flag='+end_time_flag+'&st_rcv_agent_flag='+rcv_agent_flag+'&st_rfq_kep_user='+'${sessionInfo.userId}',"1520,500,no");
			//SLOGIC-END
		}else {
			return;
		}
		
	}else if (column == "STOA_REMARK_IMG" ){ 
		if(kepIsValueNull(agent)){
			alert("협력사 선정이 되지 않았습니다.");
			return;
		}
		popupSel = "remarkBAS";
		var btoa_remark = mySheet.GetCellValue(Row, "BTOA_REMARK");
		var atos_remark = mySheet.GetCellValue(Row, "ATOS_REMARK");
		var stoa_remark = mySheet.GetCellValue(Row, "STOA_REMARK");
		var atob_remark = mySheet.GetCellValue(Row, "ATOB_REMARK");
		openSearchPopup("/common/remarkBASPop.do",'?st_btoa_remark='+btoa_remark+'&st_atos_remark='+atos_remark+'&st_stoa_remark='+stoa_remark+'&st_atob_remark='+atob_remark,"500,600,no");// 고객사 비고

	} else if(column == "CANCEL_REMARK_IMG"){
		popupSel = "cancelRemark";
		var viewType="R";
		var cancel_remark = mySheet.GetCellValue(Row, "CANCEL_REMARK");
		openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType,"500,230,no");
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 다중 고객사
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(text);
	
	} else if (popupSel == "country") {	// 원산지
		mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value1);
		mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value2);
	
	}else if (popupSel == "maker") {	// 제조사
		mySheet.SetCellValue(grbRow, 'MAKER_CODE', value1);
		mySheet.SetCellValue(grbRow, 'MAKER_NAME', value2);
		
	}else if(popupSel == "remarkBAS") {	//고객사 비고
		mySheet.SetCellValue(grbRow, 'ATOB_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'STOA_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
	
	}else if(popupSel == "remarkAtoS2") {	//고객사 비고
		mySheet.SetCellValue(grbRow, 'ATOS_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'ATOS_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
			
	}else if(popupSel == "cancelRemark") {	//견적 취소
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
			
	}
	grbRow="";	//초기화
}

function mySheet_OnMouseMove(Button, Shift, X, Y) { 
	var row = mySheet.MouseRow();
	var cellFont = mySheet.GetCellFontColor(row, "BUYER_ITEM_NO");
	if(cellFont == "#0100ff") {
		mySheet.SetDataLinkMouse("BUYER_ITEM_NO", true);
	} else {
		mySheet.SetDataLinkMouse("BUYER_ITEM_NO", false);
	}
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<form name = "searchCondition" method = "post" onsubmit="return false" >
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>업체선정 및 견적제출(두중)</h3>
<!--         	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>  -->
<!-- 		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span> -->
   		</div>        	
        <!--조회영역-->
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
			<input type="hidden" id="st_buyer"  name="st_buyer" value="${param.st_buyer}">	
			<input type="hidden" id="st_quotation_no"  name="st_quotation_no" value="${param.st_quotation_no}">	
			<input type="hidden" id="st_revision"  name="st_revision" value="${param.st_revision}">	
			
           	<table class="cont_t_list06" style="width:100%;">
				<caption>견적접수및견적제출 조회</caption>
				<colgroup>
					<col width="12%" />
					<col width="21%" />
					<col width="12%" />
					<col width="21%" />
					<col width="12%" />
                    <col width="21%" />
				</colgroup>
					
				<tbody>
					<tr>
						<th><font color="#FF6600">*</font>고객사</th>
						<td id="buyer_name" style="font-weight:bold;"></td>
						<th>견적번호</th>
						<td id="quotation_no" style="font-weight:bold;"></td>
						<th>견적작성일</th>
						<td id="btoa_date"></td>
					</tr>
					<tr> 
						<th>견적작성자</th>
						<td id="btoa_user_name"></td>
						<th>연락처</th>
						<td id="btoa_user_tel"></td>
						<th>Fax</th>
						<td id="btoa_user_fax"></td>
					</tr>
				</tbody>
			</table>
            <span class="fl">
				<img src="/resources/images/icon_r.gif"> 기등록
				<img src="/resources/images/icon_y.gif"> 고객사NEGO건
				<img src="/resources/images/icon_g.gif"> 신규
			</span>
			<br>
      		<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			
  			<!--버튼영역-->
            <div class="btnArea mt05">
	          	<span class="fl">
					<span class="btn_04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
				</span>
			
				<span class="fr">
					<span class="btn_03 mr04"><a href="javascript:doAction('print');">견적서출력</a></span>
					<span class="btn_08 mr04"><a href="javascript:doAction('nego');">고객사NEGO 견적제출</a></span>
					<span class="btn_05 mr04"><a href="javascript:doAction('save');">고객사 견적제출</a></span>
					<span class="btn_02 mr04"><a href="javascript:doAction('cancel');">견적취소</a></span>
					<span class="btn_03 mr04"><a href="javascript:doAction('init');">견적초기화</a></span>
					<span class="btn_02"><a href="javascript:doAction('back');">뒤로가기</a></span>
				</span>
	 		</div>

<!--내용 종료-->	                 
	</form>
</body>
</html>
