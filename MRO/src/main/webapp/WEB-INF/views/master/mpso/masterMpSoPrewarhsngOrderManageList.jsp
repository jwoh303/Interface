<%--
**********************************************
* 메뉴 : 주문관리>선입고 주문 관리
* 화면 : 선입고 주문 관리
* 기능 : 선입고 주문내역을 조회하고 관리한다.
* 프로그램 ID : PG_06_M_012_00
* 담당자 : 고영일 ( 설계 : 김지현 )
* 착수일 : 2014-07-28
**********************************************
--%>
<%@page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String kep_user_id			= _sessionInfo.getUserId();
String kep_user_name		= _sessionInfo.getUserNameLoc();
String sys_type = CommonUtil.nvl((String) request.getParameter("st_sys_type"), "KA");	// 관리 고객사 타입 설정 (KA : KOREAB2B 운영자 시스템, KM : KEPMRO 운영자 시스템)

%>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태",	SaveName:"STATUS_TEXT"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청번호",	SaveName:"BS_NO"}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"요청일",	SaveName:"BEFORE_GR_DATE"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주번호",	SaveName:"PO_NO_NM"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
					,{ Align:"Left",		Width:150,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
					,{ Align:"Left",		Width:250,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
					,{ Align:"Center",	Width:150,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NAME"}
					,{ Align:"Right",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"매출단가",	SaveName:"UNIT_PRICE"}
					,{ Align:"Right",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"매입단가",	SaveName:"AGENT_PRICE"}
					,{ Align:"Right",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"선입고요청수량",	SaveName:"ITEM_QTY"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"선입고발주수량",	SaveName:"CLOSE_ITEM_QTY"}
					,{ Align:"Center",	Width:50,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"거래유형",	SaveName:"PROCESS_NAME"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"물류센터",	SaveName:"WAREHOUSE_NAME"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",	SaveName:"REQ_USER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청부서",	SaveName:"REQ_USER_DEPT_NAME"}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자연락처",	SaveName:"REQ_USER_TEL_NO"}
					,{ Align:"Left",		Width:300,	Edit:true,	EditLen:160,	Hidden:false,	Type:"Text",	Header:"배송지",	SaveName:"DELY_TO_LOCATION"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사담당자",	SaveName:"AGENT_USER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사담당연락처",	SaveName:"AGENT_TEL_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"Kep담당자",	SaveName:"KEP_USER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"등록자",	SaveName:"ADD_USER_NAME"}
					,{ Align:"Left",		Width:300,	Edit:true,	EditLen:400,	Hidden:false,	Type:"Text",	Header:"비고",	SaveName:"REMARK"}
					
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"상태코드",	SaveName:"STATUS"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"발주번호코드",	SaveName:"PO_NO"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제조사코드",	SaveName:"MAKER_CODE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"원산지코드",	SaveName:"ORIGIN_CODE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER_CODE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자ID",	SaveName:"REQ_USER_ID"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청부서코드",	SaveName:"REQ_USER_DEPT_CODE"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사코드",	SaveName:"AGENT_CODE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사담당자ID",	SaveName:"AGENT_USER_ID"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"Kep담당자ID",	SaveName:"KEP_USER_ID"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서번호",	SaveName:"CONTRACT_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서항번",	SaveName:"CONTRACT_SEQ"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"배송상태",	SaveName:"DELIVERY_FLAG"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"거래유형코드",	SaveName:"PROCESS_TYPE"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"물류센터코드",	SaveName:"WAREHOUSE_CODE"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"송장번호",	SaveName:"INV_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"등록자ID",	SaveName:"ADD_USER_ID"}
	];
	
	initsheet.Cfg = {FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');

	//하이퍼링크 설정
	setLinkCol(mySheet, "STATUS_TEXT");					//상태
	setLinkCol(mySheet, "BS_NO");							//요청번호
	setLinkCol(mySheet, "PO_NO_NM");					//발주번호
	setLinkCol(mySheet, "BUYER_NAME");					//고객사
	setLinkCol(mySheet, "BUYER_ITEM_NO");				//품목코드
	setLinkCol(mySheet, "QUOTATION_NO");				//견적번호
	setLinkCol(mySheet, "REQ_USER_NAME");			//요청자
	setLinkCol(mySheet, "ORIGIN_NAME");				//원산지
	setLinkCol(mySheet, "AGENT_NAME");					//협력사
	setLinkCol(mySheet, "AGENT_USER_NAME");			//협력사담당자
	setLinkCol(mySheet, "DELY_TO_LOCATION");		//배송지
	setLinkCol(mySheet, "PROCESS_NAME");				//거래유형
	
	//콤보데이터 셋팅
	kepAjaxCommonQueryIdSearchCombo('st_status_code','getCnfrmStepCombo','C021','ALL', '');
	kepAjaxCommonTotalCombo("st_process_type", "M034", "ALL", "", "CODE", "TEXT2", "");
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}
	
	
var st;
var mt;
var grbRow;
// 기능함수 
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str != "copyRows" && str != "addrows" && str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		var buyer	= $("#st_buyer_code").val();
	    
    	if(buyer == "") {
			alert("고객사는 필수 선택사항입니다.");
			return;
		}
	
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoPrewarhsngOrderManageList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		
		// 조회조건 초기화
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		
		$("#st_buyer_code").val("");
		$("#st_buyer_name").val("");
		
		break;

	case "savePrewarhsngReq": // 선입고 요청 등록
		if(!checkPrewarhsngStatus(arrRow)){
			return;
		}
	
		if(!checkPrewarhsngReq(arrRow)){ return; }
		
		if(confirm("선택하신 항목에 대한 선입고 요청 등록을 하시겠습니까?  ")){
			kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoPrewarhsngOrderManageList.do" , "SELECTED" );
		}
		break;
		
	case "savePrewarhsngCancel": // 선입고 요청 취소
		for(var inx = 0 ; inx < arrRow.length ; inx++){
			if(mySheet.GetCellValue(arrRow[inx],"STATUS") != "BS10") {
				alert("요청 상태만 취소 가능합니다.");
				mySheet.SetSelectRow(arrRow[inx]);
				return;
			} else if(mySheet.GetCellValue(arrRow[inx],"sStatus") == "I"){
				alert("신규 추가된 행("+arrRow[inx]+"번째)은 선입고 요청을 취소 할 수 없습니다.");
				mySheet.SetSelectRow(arrRow[inx]);
				return;
			}
		}
		
		if(confirm("선택하신 항목에 대한 선입고 요청 취소를 하시겠습니까?  ")){
			kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoPrewarhsngReqCancel.do" , "SELECTED" );
		}
		break;
		
	case "savePrewarhsngMappingCancel": // 매핑 취소
		if(!checkPrewarhsngStatus(arrRow)){
			return;
		}
		
		for(var inx = 0 ; inx < arrRow.length ; inx++){
			if(mySheet.GetCellValue(arrRow[inx],"sStatus") == "I"){
				alert("신규 추가된 행("+arrRow[inx]+"번째)은 매핑 취소 할 수 없습니다.");
				mySheet.SetSelectRow(arrRow[inx]);
				return;
			}
			if(isEmpty(mySheet.GetCellValue(arrRow[inx], "PO_NO"))){
				alert(arrRow[inx]+"번째 행은 발주매핑 정보가 없어 취소 할 수 없습니다.");
				return;
			}
		}
	
		if(confirm("선택하신 항목에 대한 매핑취소를 하시겠습니까?")){
			kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoPrewarhsngMappingGrpCancelReg.do" , "SELECTED" );
		}
		break;
		
	case "addrows": // 행추가
		var buyer	= $("#st_buyer_code").val();
	    
    	if(buyer == "") {
			alert("고객사는 필수 선택사항입니다.");
			return;
		}
    	
    	var buyer_name = $("#st_buyer_name").val();
    	var array_buyer = buyer.split("@");
    	var array_buyer_name = buyer_name.split("@");
    	if (array_buyer.length > 2){
    		alert("검색조건의 고객사가 " + ( array_buyer.length - 1) + "건 이상 선택되었습니다.\n1건 선택 후 행 추가 할 수 있습니다.");
    		return;
    	}else{
    		buyer = array_buyer[0];
    		buyer_name = array_buyer_name[0];
    	}
    	
		var rows = mySheet.DataInsert(0);
		mySheet.SetCellValue(rows, 'SELECTED', 1);
		mySheet.SetCellValue(rows, 'BEFORE_GR_DATE', kepGetNowTimeStr('YYYYMMDD','/'));
		mySheet.SetCellValue(rows, 'BUYER_CODE', buyer);
		mySheet.SetCellValue(rows, 'BUYER_NAME', buyer_name);
		mySheet.SetCellValue(rows, 'KEP_USER_ID', $("#kep_user_id").val());
		mySheet.SetCellValue(rows, 'KEP_USER_NAME', $("#kep_user_name").val());
		break;
		
	case "deleteRows": // 행삭제
		for(var inx = 0 ; inx < arrRow.length ; inx++){
			if(mySheet.GetCellValue(arrRow[inx], "sStatus") != "I"){
				alert("행추가로 등록된 행만 삭제 할 수 있습니다.");
				return;
			}
		}
		mySheet.RowDelete(selectedGrid, 1);	
		break;
		
	case "copyRows": // 행복사
		if(mySheet.GetSelectRow() == -1){
			alert("선택된 항목이 없습니다.");
			return;
		}
		
		var Row;
		var copyRowCnt = $("#copy_row_cnt").val();
		
		for(var inx = 0 ; inx < copyRowCnt ; inx++){
			Row = mySheet.DataCopy();
			mySheet.SetCellValue(Row, "sStatus", "I");
			mySheet.SetCellValue(Row, 'SELECTED', 1);
			mySheet.SetCellValue(Row, 'STATUS_TEXT', "");
			mySheet.SetCellValue(Row, 'STATUS', "");
			mySheet.SetCellValue(Row, 'BS_NO', "");
			mySheet.SetCellValue(Row, 'BEFORE_GR_DATE', kepGetNowTimeStr('YYYYMMDD','/'));
			mySheet.SetCellValue(Row, 'PO_NO_NM', "");
			mySheet.SetCellValue(Row, 'PO_NO', "");
			mySheet.SetCellValue(Row, 'KEP_USER_ID', $("#kep_user_id").val());
			mySheet.SetCellValue(Row, 'KEP_USER_NAME', $("#kep_user_name").val());
			mySheet.DataMove(0, Row);
		}
		break;
		
	case "tranStatement": // 거래명세서
		if(!checkPrewarhsngStatus(arrRow)){
			return;
		}
	
		var st_before_gr_date = "";
		var st_agent_code = "";		
		for(var inx = 0 ; inx < arrRow.length ; inx++){
			if(mySheet.GetCellValue(arrRow[inx],"STATUS") == "BS20" || mySheet.GetCellValue(arrRow[inx],"STATUS") == "BS30" || mySheet.GetCellValue(arrRow[inx],"STATUS") == "BS40") {
				alert(arrRow[inx] +"번째 행은 이미 거래명세서를 생성 하였습니다.");
				mySheet.SetSelectRow(arrRow[inx]);
				return;
			} else if(mySheet.GetCellValue(arrRow[inx],"STATUS") == "BS99") {
				alert(arrRow[inx] +"번째 행의 선입고 취소 상태는 거래명세서를 생성 할 수 없습니다.");
				mySheet.SetSelectRow(arrRow[inx]);
				return;
			} else if(mySheet.GetCellValue(arrRow[inx],"sStatus") == "I"){
				alert("신규 추가된 행("+arrRow[inx]+"번째)은 거래명세서를 생성 할 수 없습니다.");
				mySheet.SetSelectRow(arrRow[inx]);
				return;
			}
			
			if(inx == 0){
				st_before_gr_date = mySheet.GetCellValue(arrRow[inx],"BEFORE_GR_DATE");
				st_agent_code = mySheet.GetCellValue(arrRow[inx],"AGENT_CODE");
			}
			if(st_before_gr_date != mySheet.GetCellValue(arrRow[inx],"BEFORE_GR_DATE") || st_agent_code != mySheet.GetCellValue(arrRow[inx],"AGENT_CODE")){
				alert("요청일과 협력사가 다르면 거래명세서를 생성 할 수 없습니다.");
				return;
			}
		}
	
		if(confirm("선택하신 항목에 대해 거래명세서를 생성 하시겠습니까?")){
			kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoPrewarhsngTranStatementReg.do" , "SELECTED" );
		}

		break;
		
	case "deliveryEnd": // 납품실적
		if(!checkPrewarhsngStatus(arrRow)){
			return;
		}
	
		for(var inx = 0 ; inx < arrRow.length ; inx++){
			if(mySheet.GetCellValue(arrRow[inx],"DELIVERY_FLAG") == "Y") {
				alert(arrRow[inx] +"번째 행은 이미 배송완료 처리된 건입니다.");
				mySheet.SetSelectRow(arrRow[inx]);
				return;
			} else if(mySheet.GetCellValue(arrRow[inx],"sStatus") == "I"){
				alert("신규 추가된 행("+arrRow[inx]+"번째)은 납품실적 처리를 할 수 없습니다.");
				mySheet.SetSelectRow(arrRow[inx]);
				return;
			}
		}
	
		if(confirm("선택하신 항목에 대해 배송완료 처리 하시겠습니까?")){
			kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoPrewarhsngDeliveryEndReg.do" , "SELECTED" );
		}

		break;

	case "excelDown": // 엑셀다운로드
		var buyer	= $("#st_buyer_code").val();
	    
    	if(buyer == "") {
			alert("고객사는 필수 선택사항입니다.");
			return;
		}
	
	    $("#pageflag").val('0');
		var param = {FileName:"선입고 주문 관리.xlsx",DownCols:"STATUS|STATUS_TEXT|BS_NO|BEFORE_GR_DATE|PO_NO|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|MAKER_CODE|MAKER_NAME|ORIGIN_CODE|ORIGIN_NAME|UNIT_PRICE|AGENT_PRICE|ITEM_QTY|CLOSE_ITEM_QTY|UNIT_MEASURE|PROCESS_TYPE|PROCESS_NAME|WAREHOUSE_CODE|WAREHOUSE_NAME|BUYER_CODE|BUYER_NAME|REQ_USER_ID|REQ_USER_NAME|REQ_USER_DEPT_CODE|REQ_USER_DEPT_NAME|REQ_USER_TEL_NO|DELY_TO_LOCATION|AGENT_CODE|AGENT_NAME|AGENT_USER_ID|AGENT_USER_NAME|AGENT_TEL_NO|KEP_USER_ID|KEP_USER_NAME|REMARK|"};
		kepDownExcel(document.searchCondition ,mySheet , "/mpso/excelMasterMpSoPrewarhsngOrderManageList.do", param);
		$("#pageflag").val('1');
		break;
	}
}

function checkPrewarhsngStatus(arrRow){
	for(var inx = 0 ; inx < arrRow.length ; inx++){
		if("BS99" == mySheet.GetCellValue(arrRow[inx],"STATUS")){
			alert(arrRow[inx] +"번째 행은 선입고취소 상태이므로 진행 할 수 없습니다.");
			return false;
		}
	}
	return true;
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

	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
	var po_no = "";
	var arry_po_no = "";
	var arry_po_no2 = "";
	var po_no_nm = "";
	var rowStatus = "";
	
	for( var i = 1; i <= mySheet.RowCount(); i++ ) {
		po_no = mySheet.GetCellValue(i, "PO_NO");
		if(!isEmpty(po_no)){
			arry_po_no = po_no.split("$$");
			arry_po_no2 = arry_po_no[0].split("||");
			if(arry_po_no.length > 2){
				po_no_nm = arry_po_no2[0] + "외 " + (arry_po_no.length - 2) + "개";
			} else {
				po_no_nm = arry_po_no2[0];
			}
			rowStatus = mySheet.GetCellValue(i, "sStatus");
			mySheet.SetCellValue(i, "PO_NO_NM", po_no_nm);
			mySheet.SetCellValue(i, "sStatus", rowStatus);
		}
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

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoPrewarhsngOrderManageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출 
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyerCompany": // 고객사 M
			openSearchPopup("/common/safetyCompanyCodePop.do", "?COM_TYPE=B&multi_flag=M", "880,450,no");
			popupSel = "buyerCompany";
			break;
		case "masterMpSoPrewarhsngRequestAllRegPop": // 선입고요청등록(일괄) 팝업
			popupSel = "masterMpSoPrewarhsngRequestAllRegPop";
			openSearchPopup("/mpso/showMasterMpSoPrewarhsngRequestAllRegPop.do", "?1=1", "800,500,no");
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'STATUS_TEXT') { // 상태 ( 송장 ) 레포트 팝업
		var inv_no = mySheet.GetCellValue(Row,"INV_NO");
		if( !isEmpty(inv_no) ){
			var fileName = "";
			var com_code = "KRKORE0001";
			var buyer_code= mySheet.GetCellValue(Row,"BUYER_CODE");
			var process_type = mySheet.GetCellValue(Row,"PROCESS_TYPE");
			var warehouse_code = mySheet.GetCellValue(Row,"WAREHOUSE_CODE");
			
			if(process_type == "2" && warehouse_code == "KRKORE0126" ){	// TR (인천HUB센터)
				fileName = "RD_06_S_003_19";
			} else if(process_type == "2" && warehouse_code != "KRKORE0126" ){	// TR (인천HUB센터)가 아니면
				fileName = "RD_06_S_003_20";
			} else {
				fileName = "RD_06_S_003_17";
			}
			
			var param =  "["+inv_no+"]["+com_code+"]["+buyer_code+"]";
			reportOpen(fileName,param);
		} else {
			alert("거래명세서가 생성 되지 않았습니다.");
			return;
		}
	} else if (column == 'BS_NO') { // 요청번호
		var bs_no = mySheet.GetCellValue(Row,"BS_NO");
		var buyer_code = mySheet.GetCellValue(Row,"BUYER_CODE");
		var s_status = mySheet.GetCellValue(Row,"sStatus");

		if(!isEmpty(bs_no) && s_status != "I"){
			openSearchPopup("/mpso/getMasterMpSoPrewarhsngRequestDetailInfoPop.do", "?st_buyer="+buyer_code+"&st_bs_no="+bs_no, "800,530,no");
		}else if(s_status == "I"){
			alert("선입고 요청 등록 이후 상세정보를 확인 하실 수 있습니다.");
		}
		return;
		
	} else if (column == 'PO_NO_NM') { // 발주번호
		var s_status = mySheet.GetCellValue(Row,"sStatus");
		
		if(s_status != "I"){
			var buyer_code = mySheet.GetCellValue(Row,"BUYER_CODE");
			var bs_no = mySheet.GetCellValue(Row,"BS_NO");
			var close_item_qty = mySheet.GetCellValue(Row,"CLOSE_ITEM_QTY");
			var item_qty = mySheet.GetCellValue(Row,"ITEM_QTY");
			var po_no = mySheet.GetCellValue(Row,"PO_NO");
			var st_buyer_item_no = isEmpty(mySheet.GetCellValue(Row,"BUYER_ITEM_NO")) ? "" : mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
			var st_desc_spec = isEmpty(mySheet.GetCellValue(Row,"DESCRIPTION")) ? "" : mySheet.GetCellValue(Row,"DESCRIPTION");
			
			popupSel = "masterMpSoPrewarhsngRequestOrderMapppingPop";
			openSearchPopup("/mpso/showMasterMpSoPrewarhsngRequestOrderMapppingPop.do", "?st_buyer="+buyer_code+"&st_bs_no="+bs_no+"&st_close_item_qty="+close_item_qty+"&st_item_qty="+item_qty + "&st_po_no=" + po_no + "&st_buyer_item_no=" + st_buyer_item_no + "&st_desc_spec=" + st_desc_spec, "800,600,no");
		}else if(s_status == "I"){
			alert("선입고 요청 등록 이후 발주번호를 입력 하실 수 있습니다.");
		}
		
		return;
	} else if (column == 'BUYER_ITEM_NO') { // 품목코드
		var buyer = mySheet.GetCellValue(grbRow, 'BUYER_CODE');
		if(isEmpty(buyer)){
			alert("고객사가 선택 되지 않았습니다.");
			return;
		}
		
		var buyer_name = mySheet.GetCellValue(grbRow, 'BUYER_NAME');
		popupSel = "commonCoCoExistingCatalogPop";
		openSearchPopup("/coco/showCommonCoCoExistingCatalogPop.do", "?st_buyer="+buyer+"&st_buyer_name="+buyer_name, "800,600,no");
		
		return;
	} else if (column == 'ORIGIN_NAME') { // 원산지
		popupSel = "country";
		openSearchPopup("/common/countryCodePop.do", "?1=1", "500,500,no");
		
		return;
	} else if (column == 'BUYER_NAME') { // 고객사
		popupSel = "icomcmpyPop";
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
		
		return;
	} else if (column == 'REQ_USER_NAME') { // 요청자
		var buyer = mySheet.GetCellValue(grbRow, 'BUYER_CODE');
		if(isEmpty(buyer)){
			alert("고객사가 선택 되지 않았습니다.");
			return;
		}
		
		popupSel = "masterMdCpUserChoicePop";
		openSearchPopup("/mdcp/getMasterMdCpUserChoicePop.do", "?st_buyer=" + buyer, "500,500,no");
		
		return;
	} else if (column == 'DELY_TO_LOCATION') { // 배송지(도착지 정보 팝업)
		var buyer = mySheet.GetCellValue(grbRow, 'BUYER_CODE');
		if(isEmpty(buyer)){
			alert("고객사가 선택 되지 않았습니다.");
			return;
		}
		
		popupSel = "location";
		openSearchPopup("/common/delLocationPop.do", "?com_code="+buyer+"&open=Y", "500,500,no");
		
		return;
	} else if (column == 'AGENT_NAME') { // 협력사
		popupSel = "icomcmpyPop_SN";
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
		
		return;
	} else if (column == 'AGENT_USER_NAME') { // 협력사담당자
		var agent = mySheet.GetCellValue(grbRow, 'AGENT_CODE');
		if(isEmpty(agent)){
			alert("협력사가 선택 되지 않았습니다.");
			return;
		}
		
		popupSel = "masterMdCpUserChoicePop_SN";
		openSearchPopup("/mdcp/getMasterMdCpUserChoicePop.do", "?st_buyer=" + agent, "500,500,no");
		
		return;
	} else if (column == "PROCESS_NAME" ){ // 거래유형
		popupSel = "commonCoCoGoodsDlvyClssifyPop";   
		openSearchPopup("/coco/getCommonCoCoGoodsDlvyClssifyPop.do",'' , "500,250,no"); 
	}
	
	
	return;
}

//그리드 셀 변경시 이벤트
function mySheet_OnChange(Row, Col, Value) {
	var column = mySheet.ColSaveName(Col);
	grbRow = Row; //현재 Row를 전역변수에 셋팅
	
	if(column == "BEFORE_GR_DATE"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "PO_NO"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "BUYER_ITEM_NO"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "DESCRIPTION"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "SPECIFICATION"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "ORIGIN_NAME"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "UNIT_PRICE"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "AGENT_PRICE"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "ITEM_QTY"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "CLOSE_ITEM_QTY"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "UNIT_MEASURE"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "PROCESS_NAME"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "BUYER_NAME"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "REQ_USER_NAME"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "REQ_USER_TEL_NO"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "DELY_TO_LOCATION"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "AGENT_NAME"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "AGENT_USER_NAME"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "AGENT_TEL_NO"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "KEP_USER_NAME"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14,value15){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyerCompany") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	} else if (popupSel == "country") {	// 원산지
		mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value1);
		mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value3);
	
	} else if (popupSel == "icomcmpyPop") {	// 고객사 
		mySheet.SetCellValue(grbRow, 'BUYER_CODE', value1);
		mySheet.SetCellValue(grbRow, 'BUYER_NAME', value2);
	
	} else if (popupSel == "masterMdCpUserChoicePop") {	// 요청자  
		mySheet.SetCellValue(grbRow, 'REQ_USER_ID', value1);
		mySheet.SetCellValue(grbRow, 'REQ_USER_NAME', value2);
		mySheet.SetCellValue(grbRow, 'REQ_USER_TEL_NO', value3);
		mySheet.SetCellValue(grbRow, 'REQ_USER_DEPT_CODE', value5);
		mySheet.SetCellValue(grbRow, 'REQ_USER_DEPT_NAME', value6);
	
	} else if (popupSel == "location") {	// 요청자  
		mySheet.SetCellValue(grbRow, 'DELY_TO_LOCATION', value2);
	
	} else if (popupSel == "icomcmpyPop_SN") {	// 협력사
		mySheet.SetCellValue(grbRow, 'AGENT_CODE', value1);
		mySheet.SetCellValue(grbRow, 'AGENT_NAME', value2);
	
	} else if (popupSel == "masterMdCpUserChoicePop_SN") {	// 협력사 담당
		mySheet.SetCellValue(grbRow, 'AGENT_USER_ID', value1);
		mySheet.SetCellValue(grbRow, 'AGENT_USER_NAME', value2);
		mySheet.SetCellValue(grbRow, 'AGENT_TEL_NO', value3);
	
	} else if (popupSel == "commonCoCoExistingCatalogPop") {	// 품목코드
		mySheet.SetCellValue(grbRow, 'BUYER_ITEM_NO', value1);
		mySheet.SetCellValue(grbRow, 'DESCRIPTION', value2);
		mySheet.SetCellValue(grbRow, 'SPECIFICATION', value3);
		mySheet.SetCellValue(grbRow, 'MAKER_NAME', value4);
		mySheet.SetCellValue(grbRow, 'MAKER_CODE', value5);
		mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value6);
		mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value7);
		mySheet.SetCellValue(grbRow, 'UNIT_MEASURE', value8);
		mySheet.SetCellValue(grbRow, 'UNIT_PRICE', value9);
		mySheet.SetCellValue(grbRow, 'AGENT_PRICE', value10);
		mySheet.SetCellValue(grbRow, 'AGENT_NAME', value11);
		mySheet.SetCellValue(grbRow, 'AGENT_CODE', value12);
		mySheet.SetCellValue(grbRow, 'CONTRACT_NO', value13);
		mySheet.SetCellValue(grbRow, 'CONTRACT_SEQ', value14);
		mySheet.SetCellValue(grbRow, 'PROCESS_TYPE', value15);
		
	} else if(popupSel == "commonCoCoGoodsDlvyClssifyPop"){
		mySheet.SetCellValue(grbRow, 'PROCESS_TYPE', value1);
		mySheet.SetCellValue(grbRow, 'PROCESS_NAME', value2);
		if(value1 == "0"){
			mySheet.SetCellValue(grbRow, 'WAREHOUSE_CODE', "");
			mySheet.SetCellValue(grbRow, 'WAREHOUSE_NAME', "");
		}else{
			mySheet.SetCellValue(grbRow, 'WAREHOUSE_CODE', value3);
			mySheet.SetCellValue(grbRow, 'WAREHOUSE_NAME', value4);
		}
	}
	grbRow="";	//초기화 
}

function checkPrewarhsngReq(arrRow){
	for(var inx = 0 ; inx < arrRow.length ; inx++){
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"BEFORE_GR_DATE"))) {
			alert(arrRow[inx] +"번째 행의 요청일을 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("BEFORE_GR_DATE");
			return false ;
		}
// 		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"BUYER_ITEM_NO"))) {
// 			alert(arrRow[inx] +"번째 행의 품목코드를 입력하여 주십시오.");
// 			mySheet.SetSelectRow(arrRow[inx]);
// 			mySheet.SetSelectCol("BUYER_ITEM_NO");
// 			return false ;
// 		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"DESCRIPTION"))) {
			alert(arrRow[inx] +"번째 행의 품목명을 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("DESCRIPTION");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"SPECIFICATION"))) {
			alert(arrRow[inx] +"번째 행의 규격을 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("SPECIFICATION");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"MAKER_NAME"))) {
			alert(arrRow[inx] +"번째 행의 제조사를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("MAKER_NAME");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"ORIGIN_CODE"))) {
			alert(arrRow[inx] +"번째 행의 원산지를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("ORIGIN_NAME");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"UNIT_PRICE"))) {
			alert(arrRow[inx] +"번째 행의 매출단가를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("UNIT_PRICE");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"AGENT_PRICE"))) {
			alert(arrRow[inx] +"번째 행의 매입단가를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("AGENT_PRICE");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"ITEM_QTY"))) {
			alert(arrRow[inx] +"번째 행의 수량을 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("ITEM_QTY");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"UNIT_MEASURE"))) {
			alert(arrRow[inx] +"번째 행의 단위를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("UNIT_MEASURE");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"PROCESS_NAME"))) {
			alert(arrRow[inx] +"번째 행의 거래유형을 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("PROCESS_NAME");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"BUYER_CODE"))) {
			alert(arrRow[inx] +"번째 행의 고객사를 선택하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("BUYER_NAME");
			return false;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"REQ_USER_ID"))) {
			alert(arrRow[inx] +"번째 행의 요청자를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("REQ_USER_NAME");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"REQ_USER_DEPT_CODE"))) {
			alert(arrRow[inx] +"번째 행의 요청자부서를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("REQ_USER_DEPT_NAME");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"DELY_TO_LOCATION"))) {
			alert(arrRow[inx] +"번째 행의 배송지 정보를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("DELY_TO_LOCATION");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"REQ_USER_TEL_NO"))) {
			alert(arrRow[inx] +"번째 행의 요청자 연락처를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("REQ_USER_TEL_NO");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"AGENT_CODE"))) {
			alert(arrRow[inx] +"번째 행의 협력사를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("AGENT_NAME");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"AGENT_USER_ID"))) {
			alert(arrRow[inx] +"번째 행의 협력사 담당자를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("AGENT_USER_NAME");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"AGENT_TEL_NO"))) {
			alert(arrRow[inx] +"번째 행의 협력사 전화번호를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("AGENT_TEL_NO");
			return false ;
		}
	}
	return true;
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>선입고 주문 관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<input type="hidden" name="tmp_company"	value="">
			<input type="hidden" name="st_check"			value="">
			<input type="hidden" name="st_query"			value="">
			<input type="hidden" name="st_call_position"	value="">
			
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="kep_user_id" name="kep_user_id"  value="<%=kep_user_id%>">
			<input type="hidden" id="kep_user_name" name="kep_user_name"  value="<%=kep_user_name%>">
			<!--HIDDEN-->
			
            	<table  class="cont_t_list01" style="width:1024px;">
					<caption>선입고 주문 관리</caption>
					<colgroup>
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
                        <col width="25%" />
					</colgroup>
						
					<tbody>
						<tr>
							<td>선입고일</td>
							<td>
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:28%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:28%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
							</td>
							<td colspan="4">
								<input type="radio" name="st_po_no" value="" class="Noborder" checked="checked" /> 전체 &nbsp;&nbsp;
								<input type="radio" name="st_po_no" value="POMP"  class="Noborder" /> 발주매핑
							</td>
						</tr>
						<tr>
							<td>진행상태</td>
							<td>
								<select id="st_status_code" name="st_status_code" style="width:80%;height:20px"></select>
							</td>
							<td>거래유형</td>
							<td>
								<select id="st_process_type" name="st_process_type" style="width:80%;height:20px"></select>
							</td>
						</tr>
						<tr> 
							<td><font color="red"><b>*</b></font>고객사</td>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:71%" value="" readonly onclick="javascript:doPop('buyerCompany');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyerCompany');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<td>품목코드</td>
							<td>
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:80%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
							</td>
							<td>규격</td>
							<td>
								<input type="text" class="input_type_text" id="st_desc_spec" name="st_desc_spec" style="width:80%;" value="" onkeydown="kepEnter()">
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
			<span class="fr">
				<span class="btn_02"><a href="javascript:doAction('addrows');">행추가</a></span>
				<span class="btn_02"><a href="javascript:doAction('deleteRows');">행삭제</a></span>
				<span class="btn_02"><a href="javascript:doAction('copyRows');">행복사</a></span>
				<select id="copy_row_cnt" name="copy_row_cnt" style="width: 70px;" >
					<option value="1" selected>1건</option>
					<option value="2">2건</option>
					<option value="3">3건</option>
					<option value="4">4건</option>
					<option value="5">5건</option>
					<option value="6">6건</option>
					<option value="7">7건</option>
					<option value="8">8건</option>
					<option value="9">9건</option>
					<option value="10">10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
				</select>
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c; margin-top: 15px;">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
  	          		<span class="btn_03" style="display:none"><a href="javascript:doAction('excelDown');">내려받기</a></span>
  				</span>
  				
  				<span class="fr">
  					<span class="btn_07"><a href="javascript:doPop('masterMpSoPrewarhsngRequestAllRegPop');">선입고 요청 업로드</a></span>
  					<span class="btn_06"><a href="javascript:doAction('savePrewarhsngReq');">선입고 요청 등록</a></span>
  					<span class="btn_04"><a href="javascript:doAction('savePrewarhsngCancel');">선입고 취소</a></span>
  					<span class="btn_04 mr04"><a href="javascript:doAction('tranStatement');">거래명세서</a></span>
  					<span class="btn_03 mr04"><a href="javascript:doAction('deliveryEnd');">납품 실적</a></span>
  					<span class="btn_03"><a href="javascript:doAction('savePrewarhsngMappingCancel');">매핑 취소</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
