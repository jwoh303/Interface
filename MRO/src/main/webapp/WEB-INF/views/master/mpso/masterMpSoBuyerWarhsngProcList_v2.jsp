<%--
**********************************************
* 메뉴 : 주문관리>고객사 입고처리
* 화면 : 고객사 입고처리
* 기능 : 고객사 입고처리를 대행한다.
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-09-15
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
					 { Align:"Center",	SaveName:"SELECTED",		Header:" ", 			Type:"DummyCheck",	Width:60,	Edit:true}
					,{ Align:"Left",	SaveName:"BUYER_COM_NAME", 	Header:"고객사",		Type:"Text",		Width:130,	Edit:false}
					,{ Align:"Left",	SaveName:"AGENT_COM_NAME", 	Header:"협력사",		Type:"Text",		Width:130,	Edit:false}
					,{ Align:"Left",	SaveName:"PO_NO", 			Header:"발주번호",		Type:"Text",		Width:100,	Edit:false}
					,{ Align:"Center",	SaveName:"PO_SEQ", 			Header:"발주항번",		Type:"Text",		Width:80,	Edit:false}
					,{ Align:"Center",	SaveName:"REF_PR_NO", 		Header:"관리번호",		Type:"Text",		Width:100,	Edit:false}
					,{ Align:"Left",	SaveName:"BUYER_ITEM_NO", 	Header:"품목코드",		Type:"Text",		Width:100,	Edit:false}
					,{ Align:"Left",	SaveName:"DESCRIPTION", 	Header:"품목명",		Type:"Text",		Width:150,	Edit:false}
					,{ Align:"Left",	SaveName:"SPECIFICATION", 	Header:"규격",			Type:"Text",		Width:150,	Edit:false}
					,{ Align:"Center",	SaveName:"UNIT_MEASURE", 	Header:"단위",			Type:"Text",		Width:60,	Edit:false}
					,{ Align:"Right",	SaveName:"ITEM_QTY", 		Header:"발주수량",		Type:"Float",	 Format:"${priceFormat}",			Width:80,	Edit:false}
					,{ Align:"Right",	SaveName:"GR_QTY", 			Header:"기입고수량",	Type:"Float",	 Format:"${priceFormat}",			Width:80,	Edit:false}
					,{ Align:"Right",	SaveName:"AVAIL_GR_QTY", 	Header:"입고가능수량",	Type:"Float",	 Format:"${priceFormat}",			Width:80,	Edit:false}
					,{ Align:"Center",	SaveName:"DELIVERY_DATE", 		Header:"실적등록일",		Type:"Date",		Width:100,	Edit:false}
					,{ Align:"Center",	SaveName:"INV_DATE", 		Header:"입고일",		Type:"Date",		Width:100,	Edit:true, BackColor:"${notnullColor}"}
					,{ Align:"Right",	SaveName:"UNIT_PRICE", 		Header:"판매단가",		Type:"Float",	 Format:"${priceFormat}",			Width:80,	Edit:false}
					,{ Align:"Right",	SaveName:"INV_UNIT_AMT", 	Header:"금액",			Type:"Float",	 Format:"${priceFormat}",			Width:80,	Edit:false}
					,{ Align:"Center",	SaveName:"INV_NO", 			Header:"송장번호",		Type:"Text",		Width:100,	Edit:false}
					,{ Align:"Center",	SaveName:"INV_SEQ", 		Header:"송장항번",		Type:"Text",		Width:80,	Edit:false}
					,{ Align:"Center",	SaveName:"CARD_USE_FLAG", 	Header:"카드사용여부",	Type:"Text",		Width:80,	Edit:false}
					,{ Align:"Center",	SaveName:"CARD_CONFIRM_NO", Header:"카드승인번호",	Type:"Text",		Width:100,	Edit:false}
					
					,{ Align:"Center",	SaveName:"PARCEL_COM_NAME", Header:"택배사",		Type:"Text",		Width:100,	Edit:false}
					,{ Align:"Center",	SaveName:"PARCEL_INV_NO",	Header:"운송장번호",	Type:"Text",		Width:100,	Edit:false}
					
					,{ SaveName:"BUYER",			Header:"BUYER",				Hidden:true}
					,{ SaveName:"AGENT",			Header:"AGENT",				Hidden:true}
					,{ SaveName:"IV_QTY",			Header:"IV_QTY",			Hidden:true}
					,{ SaveName:"AGENT_PRICE",		Header:"AGENT_PRICE",		Hidden:true}
					,{ SaveName:"REF_IF_NO",		Header:"REF_IF_NO",			Hidden:true}
					,{ SaveName:"BYIT_COMORG_CODE",	Header:"BYIT_COMORG_CODE",	Hidden:true}
					,{ SaveName:"TR_BUYER",			Header:"TR_BUYER",			Hidden:true}
					,{ SaveName:"INV_QTY",			Header:"INV_QTY",			Hidden:true}
					,{ SaveName:"CONTRACT_NO",		Header:"CONTRACT_NO",		Hidden:true}
					,{ SaveName:"CONTRACT_SEQ",		Header:"CONTRACT_SEQ",		Hidden:true}
					,{ SaveName:"CLOSE_DATE",		Header:"CLOSE_DATE",		Hidden:true}
					
					,{ SaveName:"PARCEL_COM_CODE",	Header:"PARCEL_COM_CODE",	Hidden:true}
					,{ SaveName:"REAL_INV_NO_URL",	Header:"REAL_INV_NO_URL",	Hidden:true}
					,{ SaveName:"MAIL_SEND_FLAG",		Header:"MAIL_SEND_FLAG",		Hidden:true}
					,{ SaveName:"PGM_VARIABLE",		Header:"PGM_VARIABLE",		Hidden:true}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"통화단위",	SaveName:"EXP_CUR"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"환율",	SaveName:"EXP_CUR_PRICE"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"외화매출단가",	SaveName:"EXP_FOR_UNIT_PRICE"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"외화매출금액",	SaveName:"EXP_FOR_ITEM_AMT"}
					,{ Align:"Left",	SaveName:"LEGACY_PO_NO", 			Header:"I/F발주번호",		Type:"Text",		Width:120,	Edit:false}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"최근 메일\n발송일시",	SaveName:"MAIL_SEND_DATE"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"결재번호",	SaveName:"LEGACY_IV_SERIAL_DT"}
					,{ SaveName:"PROCESS_TYPE",	Header:"PROCESS_TYPE",	Hidden:true}
					,{ SaveName:"WAREHOUSE_CODE",	Header:"WAREHOUSE_CODE",	Hidden:true}
					,{ SaveName:"WAREHOUSE_BUYER_YN",	Header:"WAREHOUSE_BUYER_YN",	Hidden:true}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:150,	Hidden:true,	Type:"Text",		Header:"AP_BILL_FLAG",		SaveName:"AP_BILL_FLAG"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	initsheet.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_COM_NAME");	//고객사
	setLinkCol(mySheet, "AGENT_COM_NAME");	//협력사
	setLinkCol(mySheet, "PO_NO");			//발주번호
	setLinkCol(mySheet, "BUYER_ITEM_NO");	//품목코드
	setLinkCol(mySheet, "INV_NO");			//송장번호
	setLinkCol(mySheet, "CARD_CONFIRM_NO");	//카드승인번호
	
	setLinkCol(mySheet, "PARCEL_COM_NAME");	//택배사
	setLinkCol(mySheet, "PARCEL_INV_NO");	//운송장번호
	
	mySheet.SetCellFontUnderline(0, "INV_DATE", true);
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));

	//$("#st_from_date").val("2014/02/01");
	
	//$("#st_buyer_code").val("KRCOWA0001");
	//$("#st_buyer_name").val("코웨이(주)");
	
	//$("#st_buyer_code").val("KRKOLO0031");	// 코오롱베니트
	//$("#st_buyer_name").val("코오롱베니트 주식회사");	// 코오롱베니트
	
	//$("#st_agent_code").val("KRBEST0003");	// 오피스디포
	//$("#st_agent_name").val("오피스디포");	// 오피스디포
}
	
// 기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			var buyer_code      = $("#st_buyer_code").val();
			var agent_code      = $("#st_agent_code").val();
			
			if(buyer_code == "" && agent_code == "") {
				alert("고객사 또는 협력사를 선택해 주십시요.");
				return;
			}
			
		
			current_page = -1;
			pagingMode = "N";
			
			$("#gr_sum").val("0");
			
			kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoBuyerWarhsngProcList_v2.do" , pagingMode );
			break;
	
		case "reload":	// 초기화
			kepReload('searchCondition');
		
			$("#st_buyer_code").val("");
			$("#st_agent_code").val("");
			
			mySheet.RemoveAll();
			
			$("#st_from_date").val( kepToMonthAdd("1","M") );
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
			
			break;

		case "save": // 저장

			SelectChack = SelectValue();  

			if (SelectChack == "OK"){
				kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoBuyerWarhsngProcList_v2.do" , "SELECTED" );
			}
			break;
		case "mail":
			//선택한 건 고객사 특수로직 체크
			for (var i=0; i<arrRow.length; i++){
				var atob_unit_price    = mySheet.GetCellValue(arrRow[i],"MAIL_SEND_FLAG");
				if(atob_unit_price == "N"){
					alert("메일전송 불가능한 고객사 입니다.");
					return;
				}
				
			}

			if (!confirm('선택한 항목을 고객사에게 메일 전송 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mpso/saveMpSoBuyerWarhsngMailList.do" , "SELECTED" );
			break;
		case "appReset": // 상신초기화
			if(arrRow.length >= 2){
				alert("결재번호 한건씩 처리 가능 하십니다.");
				return;
			}
			kepSave(document.searchCondition ,  mySheet , "/wmgr/resetGrWarehousingReg.do" , "SELECTED" );
		
		break;		
	}
}
	
// 그리드 표시후 처리	
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	


	if (!isEmpty(msg)){
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoBuyerWarhsngProcList_v2.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer";
			break;
		case "seller": // 협력사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			popupSel = "seller";
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	
	var column = mySheet.ColSaveName(Col);

	if(column=="INV_DATE" && Row == 0){
		// 선택한 목록 체크 
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow = selectedGrid.split("|");
		
		if(selectedGrid.length == 0){ 
			alert("선택된 목록이 없습니다.");
			return;
		}
		
		// 체크된것중 첫번째 입고일 가져오기
		var invDate = "";
		
		for(idx=0; idx<arrRow.length; idx++){
			if(idx == 0){
				invDate = mySheet.GetCellValue(arrRow[idx],"INV_DATE");
			} else {
				mySheet.SetCellValue(arrRow[idx],"INV_DATE",invDate); //입력값.
			} 
		}
	}
	
	if ( Row  < 1) return;
	//var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
 
	if (column == 'BUYER_COM_NAME') { // 고객사
		var ID = mySheet.GetCellValue(Row,"BUYER");
		getAgentDisplayPop(ID);
		
	} else if (column == 'AGENT_COM_NAME') { // 협력사
		var ID = mySheet.GetCellValue(Row,"AGENT");
		getAgentDisplayPop(ID);

	} else if (column == 'PO_NO') { // 발주번호
	
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		openSearchPopup("/common/mpso/poDetailPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO, "900,550,no");
		
	} else if (column == 'BUYER_ITEM_NO') { // 품목코드
		var BUYER = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
		var BUYER_ITEM_NO = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		var CONTRACT_NO = mySheet.GetCellValue(Row,"CONTRACT_NO");
		var CONTRACT_SEQ = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		
		getBuyerCatalogDisplayPop(BUYER, BUYER_ITEM_NO, CONTRACT_NO, CONTRACT_SEQ);
			
	}  else if (column == 'INV_NO') { // 송장번호		
		var INV_NO = mySheet.GetCellValue(Row,"INV_NO");
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		openSearchPopup("/common/mpiv/invoiceDisplayPop.do", '?INV_NO='+INV_NO+'&BUYER='+BUYER, "600,550,no");

	}  else if (column == 'CARD_CONFIRM_NO') { // 카드승인번호
		
		var bill_no = mySheet.GetCellValue(Row,"CARD_CONFIRM_NO");    
        var loc = 'https://admin8.kcp.co.kr/assist/bill.BillAction.do?cmd=card_bill&c_trade_no='+bill_no;
        var childWin1 = window.open(loc, "Navigate","width=470,height=815,resizable=no,scrollbars=no, top=0, left=0");

	} else if (column == 'SELECTED') { // 선택
		getCheckGrAmtSum();
	
	} else if (column == 'PARCEL_COM_NAME' || column == 'PARCEL_INV_NO') { // 택배사, 운송장번호
	
		var REAL_INV_NO_URL = mySheet.GetCellValue(Row,"REAL_INV_NO_URL");
		if(!isEmpty(REAL_INV_NO_URL)){
			
			//console.log("REAL_INV_NO_URL ==>> " + REAL_INV_NO_URL);
			//REAL_INV_NO_URL = "https://www.doortodoor.co.kr/parcel/doortodoor.do?fsp_action=PARC_ACT_002&fsp_cmd=retrieveInvNoACT&invc_no=684251903261";
			var openParcel = window.open(REAL_INV_NO_URL);
			//openParcel.location.href = REAL_INV_NO_URL;
			
		}
	}
	
	return;
 
}

//그리드 헤더 전체 체크박스 클릭 이벤트
function mySheet_OnCheckAllEnd(Col, Value) {
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	if (column == 'SELECTED') { // 선택
		getCheckGrAmtSum();
	} 
}


// 그리드 셀 변경시 이벤트
function mySheet_OnChange(Row, Col, Value) {

	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(Col);
	
	if (column == "AVAIL_GR_QTY") { // 입고가능수량
		iv_qty = mySheet.GetCellValue(Row,"ITEM_QTY");   //발주수량  
		gr_qty = mySheet.GetCellValue(Row,"GR_QTY");   //기입고수량   
		ch_gr_qty =  mySheet.GetCellValue(Row,"AVAIL_GR_QTY");   

		if(ch_gr_qty.length < 1){
			mySheet.SetCellValue(Row,"AVAIL_GR_QTY","0"); //입력값.
		}  
		grSum = eval(gr_qty + ch_gr_qty);
		tmSub = iv_qty - grSum;

		if(iv_qty < grSum){
			alert("입고수량은 송장수량보다 클 수 없습니다."); 
			//mySheet.SetCellValue(Row,"AVAIL_GR_QTY",iv_qty);
			//mySheet.SetCellValue(Row,"SELECTED","0");
			return;
		}else if(tmSub == 0){
			//mySheet.SetCellValue(Row,"SELECTED","0");
			return;
		} 
		mySheet.SetCellValue(Row,"SELECTED","1");
		
	}  else if(column=="INV_DATE"){  //입고일.  

		buyer_name =  mySheet.GetCellValue(Row,"BUYER_COM_NAME"); 
		close_date =  mySheet.GetCellValue(Row,"CLOSE_DATE"); 
		inv_date =   mySheet.GetCellValue(Row,"INV_DATE"); 

		//alert(column+"/"+close_date + "/" +inv_date+"/");
		
		if(parseInt(close_date) >= parseInt(inv_date)){
			alert("입력하신 입고일은 "+buyer_name+" 의 마감일보다 이전 날짜입니다. \n\n 마감일 이후로 다시 입력하시기 바랍니다. \n\n 최종 마감일은 "+ close_date.substr(0,4) +"년 "+ close_date.substr(4,2) +"월 " + close_date.substr(6,2) +"일 입니다." );
			mySheet.SetCellValue(Row,"INV_DATE","");  //입력값.
			mySheet.SetCellValue(Row,"SELECTED","0");
			getCheckGrAmtSum();
			return;
		} 
		mySheet.SetCellValue(Row,"SELECTED","1");
		getCheckGrAmtSum();  
	}
}

function getCheckGrAmtSum(){
	var sum_gr_amt    = 0;    // 입고금액 
	var max_index = mySheet.RowCount();   
	for(i=0; i<=max_index; i++) { 
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");   
		if(selectedGrid.length == 0){  
		}else{
			
			if (mySheet.GetCellValue(i,"SELECTED")=="1")
			{			
				sum_gr_amt += eval(mySheet.GetCellValue(i,"INV_QTY")*mySheet.GetCellValue(i,"UNIT_PRICE"));
			}
			//sum_gr_amt  += getRound(eval(eval(document.WiseGrid.GetCellValue("V_AVAIL_GR_QTY",i))*eval(document.WiseGrid.GetCellValue("V_UNIT_PRICE",i))),2) ;    // 금액
		}
	}
	$("#gr_sum").val(sum_gr_amt);
	$("#gr_sum").val(kepNumComma("gr_sum"));
} 


// 입고수량 체크 모듈 수정 2005/05/30
//
// IF 통해서 입고 잡히는 경우는 ICOMIVDT.GR_QTY 를 업데이트 하지 않으므로 ,
// 입고 등록시 ICOMPODT.GR_QTY + 입력한 입고수량합 을 비교해서 발주 수량을 초과하지 않도록 수정한다.

function  SelectValue(){

    var check_result		= "";
    var item_qty			= 0;	// 발주수량
	var gr_qty				= 0;	// 기입고수량
    var input_gr_qty		= 0;	// 입고수량
    var sum_input_gr_qty	= 0;	// 입고수량 합
	var inv_date			= "";	// 입고일
	var delivery_date   = "";   //실적등록일

	// 선택한 목록 체크 
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	
	if(selectedGrid.length == 0){ 
		alert(" 선택된 목록이 없습니다.");
		return "NO";
	}
 
	var po_no		= "";
	var po_seq		= ""; 

	// 입고일 validation (오늘월-1개월 초일 ~ 무한)
	var valid_chk_date = kepToMonthAdd("1","M","noslash").substr(0,6)+"01";
	
	var max_index = mySheet.RowCount();
	for(i=0; i<=max_index; i++) {
		check_result = mySheet.GetCellValue(i,"SELECTED");
		
		//console.log("check_result ==>> " + check_result);
		if(check_result == "1"){ 
			var PROCESS_TYPE = mySheet.GetCellValue(i, "PROCESS_TYPE");
        	var WAREHOUSE_BUYER_YN = mySheet.GetCellValue(i, "WAREHOUSE_BUYER_YN");
        	
        	if(PROCESS_TYPE == "1" && WAREHOUSE_BUYER_YN == "Y"){
        		alert("재고보충발주는 처리할 수 없습니다.");
        		return "NO";
        	}
        	
			po_no			= mySheet.GetCellValue(i,"PO_NO"); 		// 발주번호
			po_seq			= mySheet.GetCellValue(i,"PO_SEQ"); 	// 발주항번
			gr_qty			= mySheet.GetCellValue(i,"GR_QTY"); 	// 기입고수량
			inv_date		= mySheet.GetCellValue(i,"INV_DATE");	// 입고일
			item_qty		= mySheet.GetCellValue(i,"ITEM_QTY");	// 발주수량
			delivery_date = mySheet.GetCellValue(i,"DELIVERY_DATE"); //실적등록일
			
			sum_input_gr_qty = 0;

			for(k=0; k<=max_index; k++) {
				check_sub = mySheet.GetCellValue(k,"SELECTED");

				if(check_sub == "1"){
					var next_po_no		= mySheet.GetCellValue(k,"PO_NO"); 	// 발주번호
					var next_po_seq		= mySheet.GetCellValue(k,"PO_SEQ"); 	// 발주항번
					input_gr_qty		= mySheet.GetCellValue(k,"AVAIL_GR_QTY"); 	// 입력한 입고수량

					if( po_no == next_po_no && po_seq == next_po_seq ){
						sum_input_gr_qty += eval(input_gr_qty);
					}
				}
			}

			var tot_gr_qty = eval(sum_input_gr_qty) + eval(gr_qty);
			
			//console.log("item_qty	" +item_qty);
			//console.log("tot_gr_qty	" +tot_gr_qty);

			if(Math.abs(item_qty) < Math.abs(tot_gr_qty)){
				alert("발주번호 " + po_no + " 번의 입고 수량합("+tot_gr_qty+")이 발주수량("+item_qty+")을 초과 하였습니다.\n\n확인 후 다시 실행해 주시기 바랍니다.");
				return "NO";
			}

			if(input_gr_qty == "" || input_gr_qty == "null" || input_gr_qty == null){
				alert( i+ "번째 품목의 입고수량이 입력되지 않았습니다. ");
				return "NO";
			}

			//console.log("inv_date	" +inv_date);

			if(inv_date == "" || inv_date == "null" || inv_date == null){
				alert( i+ "번째 품목의 입고일이 입력되지 않았습니다. ");
				return "NO";
			}
			
			if(eval(inv_date) < eval(valid_chk_date)){
				alert( "입고일은 " + kepDateSlashAdd(valid_chk_date)+" 이후로 입력 가능합니다. \n" + i + "번째 품목의 입고일을 다시 입력해 주시기 바랍니다.");
				return "NO";
			}
			
			if(delivery_date > inv_date){ //실적등록일보다 빠른 날짜를 입고일로 할 수 없음
				alert("입고일은 실적등록일 이전 날짜로 할 수 없습니다.");
				return;
			}
		}
	}
 
    if(!confirm(" 선택하신 목록으로 입고처리 하시겠습니까?    ")){
    	return "NO";
    }

	return "OK";
}

	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer") {	// 구매회원사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);	
	} else if (popupSel == "seller") {	// 협력회원사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);	
	}

	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>고객사 입고처리</h3>
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
			
			<table  class="cont_t_list01" style="width:1024px;">
				<caption>고객사 입고처리</caption>
				<colgroup>
					<col width="10%" />
					<col width="23%" />
					<col width="10%" />
					<col width="23%" />
					<col width="10%" />
					<col width="23%" />
				</colgroup>
				<tbody>
					<tr>
						<th>발주일</th>
						<td colspan="3">
							<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" > - 
							<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" >
								&nbsp;&nbsp;
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
						</td>
						<th>I/F 발주번호</th>
						<td class ="font1_table_font">
							<input type="text" class="input_type_text" name="st_legacy_po_no" id="st_legacy_po_no" style="width:90%;" value ="" onKeyDown="kepEnter()">
						</td>
					</tr>
					<tr>
						<th><font color="red"><b>*</b></font>고객사</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:70%;" value = "" READONLY>
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:100px;" value ="">
							<a href="javascript:doPop('buyer');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th><font color="red"><b>*</b></font>협력사</th>
						<td>
							<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:70%;" value ="" READONLY>
							<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:100px;" value ="">
							<a href="javascript:doPop('seller');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th>발주번호</th>
						<td class ="font1_table_font">
							<input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:90%;" value ="" onKeyDown="kepEnter()">
						</td>
					</tr>
					<tr>
						<th>품목코드</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:80%;" value =""  onKeyDown="kepEnter()">
						</td>
						<th>관리번호</th>
						<td class ="font1_table_font" >
							<input type="text" class="input_type_text" name="st_ref_no" id="st_ref_no" style="width:90%;" value ="" onKeyDown="kepEnter()">
						</td> 
						<th>구분 </th>
						<td>
							<select name = "st_off_status"> 
								<option value="">전체</option>
								<option value="MR">MR자재</option>
								<option value="OFFICE">사무용품</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>대상금액</th>
						<td>
							<input type="text" style="border:0px;background:#f3f5f9;" name="gr_sum" id="gr_sum" align="right"  size = "20" value="0" READONLY>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
			<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" style="width: 70px;" >
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
			createIBSheet("mySheet", "100%", "324px");
		</script>
	</div>
	<p class="paging" id="pageindex"></p>

	<!--버튼영역-->
	<div class="btnArea mb0">
		<span class="fl">
			<font color="#666666">&nbsp;&nbsp;* 두산인프라코어는 운영자가 입고 잡으시면 안됩니다.(입고시 세금계산서 생성)</font>
		</span>
		<span class="fr">
			<span class="btn_04 mr04"><a href="javascript:doAction('appReset')">상신초기화</a></span>
			<span class="btn_04 mr04"><a href="javascript:doAction('mail')">메일발송</a></span>
			<span class="btn_02 mr04"><a href="javascript:doAction('save');">입고</a></span> 
		</span>
	</div>
<!--내용 종료-->
</body>
</html>
