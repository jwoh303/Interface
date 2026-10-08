<%--
**********************************************
* 메뉴 : 
* 화면 : 선입고요청 등록(일괄)
* 기능 : 선입고요청 내역을 엑셀파일로 업로드 하기위한 팝업
* 프로그램 ID : PG_06_M_012_03
* 담당자 : 고영일 ( 설계 : 김지현 )
* 착수일 : 2014-08-07
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>

</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
						 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
						,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : true,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",	SaveName:"REQ_USER_NAME"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청부서",	SaveName:"REQ_USER_DEPT_NAME"}
						,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자연락처",	SaveName:"REQ_USER_TEL_NO"}
						,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"요청일",	SaveName:"BEFORE_GR_DATE"}
						,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
						,{ Align:"Left",		Width:150,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
						,{ Align:"Left",		Width:250,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
						,{ Align:"Center",	Width:150,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NAME"}
						,{ Align:"Right",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${priceFormat}",	Header:"매출단가",	SaveName:"UNIT_PRICE"}
						,{ Align:"Right",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${priceFormat}",	Header:"매입단가",	SaveName:"AGENT_PRICE"}
						,{ Align:"Right",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"선입고요청수량",	SaveName:"ITEM_QTY"}
						,{ Align:"Center",	Width:50,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"거래유형",	SaveName:"PROCESS_NAME"}
						,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"물류센터",	SaveName:"WAREHOUSE_NAME"}
						,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사담당자",	SaveName:"AGENT_USER_NAME"}
						,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사담당연락처",	SaveName:"AGENT_TEL_NO"}
						,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"Kep담당자ID",	SaveName:"KEP_USER_ID"}
						,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"Kep담당자",	SaveName:"KEP_USER_NAME"}
						,{ Align:"Left",		Width:300,	Edit:true,	EditLen:160,	Hidden:false,	Type:"Text",	Header:"배송지",	SaveName:"DELY_TO_LOCATION"}
						,{ Align:"Left",		Width:300,	Edit:true,	EditLen:400,	Hidden:false,	Type:"Text",	Header:"비고",	SaveName:"REMARK"}
						
						,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제조사코드",	SaveName:"MAKER_CODE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"원산지코드",	SaveName:"ORIGIN_CODE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자ID",	SaveName:"REQ_USER_ID"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청부서코드",	SaveName:"REQ_USER_DEPT_CODE"}
						,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사코드",	SaveName:"AGENT_CODE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사담당자ID",	SaveName:"AGENT_USER_ID"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서번호",	SaveName:"CONTRACT_NO"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서항번",	SaveName:"CONTRACT_SEQ"}
						
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청번호",	SaveName:"BS_NO"}
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float",  Format:"${qtyFormat}",	Header:"선입고발주수량",	SaveName:"CLOSE_ITEM_QTY"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"상태코드",	SaveName:"STATUS"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"발주번호코드",	SaveName:"PO_NO"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER_CODE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"거래유형코드",	SaveName:"PROCESS_TYPE"}
						,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"물류센터코드",	SaveName:"WAREHOUSE_CODE"}
						
		];
	
	initsheet.Cfg = {FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");				//품목코드
	setLinkCol(mySheet, "QUOTATION_NO");				//견적번호
	setLinkCol(mySheet, "REQ_USER_NAME");			//요청자
	setLinkCol(mySheet, "ORIGIN_NAME");				//원산지
	setLinkCol(mySheet, "AGENT_NAME");					//협력사
	setLinkCol(mySheet, "AGENT_USER_NAME");			//협력사담당자
	setLinkCol(mySheet, "DELY_TO_LOCATION");		//배송지
}


var st;
var mt;
//기능함수 
function doAction(str) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	
	// 선택된 항목 유무 체크
	if (str !="search" && str !="uploadExcel" && selectedGrid.length == 0) {
		alert("등록된 항목이 없습니다.");
		return;
	}
	
	switch (str) {
		case "search": //조회
			kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoPrewarhsngRequestAllRegPop.do" , pagingMode );
			break;
		
		case "uploadExcel": // 엑셀 업로드
			if(isEmpty($("#st_buyer_code").val())){
				alert("고객사는 필수 선택사항입니다.");
				return;
			}
			if(isEmpty($("#files").val())){
				alert("파일을 선택해 주세요.");
				return;
			}
			var extension = $("#files").val();
			extension = extension.substring(extension.lastIndexOf(".") + 1, extension.length);
			if(extension.toUpperCase().indexOf("XLS") == -1 ){
				alert("엑셀파일(XLS,XLSX)만 업로드 가능합니다.");
				return;
			}
			
			$("#searchCondition").attr("target", "iframeExcelUpload");
			$("#searchCondition").attr("method", "post");
			$("#searchCondition").attr("action", "/mpso/getMasterMpSoPrewarhsngRequestAllExcelUp.do").submit();
			
			break;
			
		case "savePrewarhsngReqAll": // 선입고 요청 등록(일괄)
		
			if(isEmpty($("#st_buyer_code").val())){
				alert("고객사는 필수 선택사항입니다.");
				return;
			}
		
			if(!checkPrewarhsngReq(arrRow)){ return; }
			
			if(confirm("등록하신 항목에 대한 선입고 요청 등록을 하시겠습니까?  ")){
				kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoPrewarhsngRequestAllRegPop.do" , "SELECTED" );
			}
			break;
	}
}

function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if(mySheet.RowCount() <= 0) return;
	
	if (msg != "") {
		alert(msg);
	}
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		opener.doAction('reload');
		opener.searchCondition.st_buyer_code.value = $("#st_buyer_code").val();
		opener.searchCondition.st_buyer_name.value = $("#st_buyer_name").val();
		opener.doAction('search');
		self.close();
	}
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "icomcmpyPop": // 고객사 M
			popupSel = "icomcmpyPop";
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'BUYER_ITEM_NO') { // 품목코드
		var buyer = $("#st_buyer_code").val();
		if(isEmpty(buyer)){
			alert("고객사가 선택 되지 않았습니다.");
			return;
		}
		
		var buyer_name = $("#st_buyer_name").val();
		popupSel = "commonCoCoExistingCatalogPop";
		openSearchPopup("/coco/showCommonCoCoExistingCatalogPop.do", "?st_buyer="+buyer+"&st_buyer_name="+buyer_name, "800,600,no");
		
		return;
	} else if (column == 'ORIGIN_NAME') { // 원산지
		popupSel = "country";
		openSearchPopup("/common/countryCodePop.do", "?1=1", "500,500,no");
		
		return;
	} else if (column == 'REQ_USER_NAME') { // 요청자
		var buyer = $("#st_buyer_code").val();
		if(isEmpty(buyer)){
			alert("고객사가 선택 되지 않았습니다.");
			return;
		}
		
		popupSel = "masterMdCpUserChoicePop";
		openSearchPopup("/mdcp/getMasterMdCpUserChoicePop.do", "?st_buyer=" + buyer, "500,500,no");
		
		return;
	} else if (column == 'DELY_TO_LOCATION') { // 배송지(도착지 정보 팝업)
		var buyer = $("#st_buyer_code").val();
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

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14,value15){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "country") {	// 원산지
		mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value1);
		mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value3);
	
	} else if (popupSel == "icomcmpyPop") {	// 고객사 
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	
	} else if (popupSel == "masterMdCpUserChoicePop") {	// 요청자  
		mySheet.SetCellValue(grbRow, 'REQ_USER_ID', value1);
		mySheet.SetCellValue(grbRow, 'REQ_USER_NAME', value2);
		mySheet.SetCellValue(grbRow, 'REQ_USER_TEL_NO', value3);
		mySheet.SetCellValue(grbRow, 'REQ_USER_DEPT_CODE', value5);
		mySheet.SetCellValue(grbRow, 'REQ_USER_DEPT_NAME', value6);
	
	} else if (popupSel == "location") {	// 배송지
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
		mySheet.SetCellValue(grbRow, 'LIST_PRICE', value10);
		mySheet.SetCellValue(grbRow, 'AGENT_NAME', value11);
		mySheet.SetCellValue(grbRow, 'AGENT_CODE', value12);
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
	if(isEmpty($("#st_buyer_code").val())) {
		alert("고객사를 선택하여 주십시오.");
		$("#st_buyer_name").focus();
		return false;
	}
	for(var inx = 0 ; inx < arrRow.length ; inx++){
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"REQ_USER_ID"))) {
			alert(arrRow[inx] +"번째 행의 요청자를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("REQ_USER_NAME");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"REQ_USER_DEPT_CODE"))) {
			alert(arrRow[inx] +"번째 행의 요청자부서를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("REQ_USER_DEPT_CODE");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"REQ_USER_TEL_NO"))) {
			alert(arrRow[inx] +"번째 행의 요청자 연락처를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("REQ_USER_TEL_NO");
			return false ;
		}
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
			mySheet.SetSelectCol("ORIGIN_CODE");
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
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"PROCESS_TYPE"))) {
			alert(arrRow[inx] +"번째 행의 거래유형을 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("PROCESS_TYPE");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"AGENT_CODE"))) {
			alert(arrRow[inx] +"번째 행의 협력사를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("AGENT_CODE");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"AGENT_USER_ID"))) {
			alert(arrRow[inx] +"번째 행의 협력사 담당자를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("AGENT_USER_ID");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"AGENT_TEL_NO"))) {
			alert(arrRow[inx] +"번째 행의 협력사 전화번호를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("AGENT_TEL_NO");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"KEP_USER_ID"))) {
			alert(arrRow[inx] +"번째 행의 KEP담당자ID를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("KEP_USER_ID");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"KEP_USER_NAME"))) {
			alert(arrRow[inx] +"번째 행의 KEP담당자명을 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("KEP_USER_NAME");
			return false ;
		}
		if(isEmpty(mySheet.GetCellValue(arrRow[inx],"DELY_TO_LOCATION"))) {
			alert(arrRow[inx] +"번째 행의 배송지 정보를 입력하여 주십시오.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("DELY_TO_LOCATION");
			return false ;
		}
	}
	return true;
}
</script> 
<body onload="kep_onload_view();">
<form id="searchCondition" name="searchCondition" method="post" enctype="multipart/form-data" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="file_name"  name="file_name" value="">
	<input type="hidden" id="upload_date"  name="upload_date" value="">
	
	<div id="popWrapper" style="height:504px;">
    	<div id="popHeader">
        	<h1 class="title">선입고요청 등록(일괄)</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:doAction('uploadExcel')">UPLOAD</a></span> 
            </div>
            <!--조회영역-->
        	<div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="12%" />
							<col width="38%" />
							<col width="12%" />
							<col width="*" />
							
						</colgroup>
						
						<tbody>
						<tr>
							<td>고객사</td>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:71%" value="" readonly onclick="javascript:doPop('icomcmpyPop');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('icomcmpyPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<td>파일선택</td>
							<td><input type="file" id="files" name="files" class="input_type_text" /></td>
						  </tr>
					</tbody>
				</table>
            </div>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "310px");
				</script>
			</div>
			<div id="pageindex"></div>
		</div>	
        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
				<span class="btn_04 mr04"><a href="/resources/excel/work/MPSO/masterMpSoPrewarhsngRequest.xlsx">양식 내려받기</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('savePrewarhsngReqAll');">저장</a></span>
			</span>
       </div>
        
    </div>
</form>
<iframe name="iframeExcelUpload" id="iframeExcelUpload" style="display:none;" scrolling="no" frameborder="0" width="100%" height="100%"></iframe>
</body>
</html>
