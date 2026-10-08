<%--
**********************************************
* 메뉴 : 견적관리>벌크소싱 견적요청
* 화면 : 벌크소싱 견적요청
* 기능 : 벌크소싱 견적 관리
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 2025-07-02
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	String st_user_id = _sessionInfo.getUserId();
%>
<!-- 다중선택콤보(공통) - 사용시 필수 선언 start -->
<script src="/resources/js/jquery.multiple.select.js"></script>
<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<!-- 다중선택콤보(공통) - 사용시 필수 선언 end -->
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.HeaderMode = {ColMove : 1,			ColResize : 1		};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:11};
	initsheet.Cols = [
		 { Align:"Center",	Hidden:true,Type:"Text",	Header:"상태|상태",	SaveName: "sStatus"} 
		,{ Align:"Center",	Width:30,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:" | ",					SaveName:"SELECTED",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"프로젝트코드|프로젝트코드",	SaveName:"BURQ_NO",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"프로젝트명|프로젝트명",		SaveName:"PROJECT_NAME",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사명|고객사명",			SaveName:"BUYER_NAME",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"진행상태|진행상태",			SaveName:"STATUS",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적번호|견적번호",			SaveName:"BURQ_RFQ_NO",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"키값|키값",				SaveName:"ITEM_KEY_ID",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사 추가|기존 협력사",		SaveName:"AGENT_NAME",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사 추가|추가 협력사(요청전)",	SaveName:"ADD_AGENT_CNT",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사 추가|추가 협력사(요청전)",	SaveName:"BTN",ColMerge:0,Sort:1, BackColor:"#A6A6A6"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적현황|견적현황",			SaveName:"RECEIPT_CNT",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"GPL|GPL",				SaveName:"GPL_YN",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:75,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"견적요청일|견적요청일",		SaveName:"ATOS_DATE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:75,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"견적마감일|견적마감일",		SaveName:"ATOS_END_DATE",ColMerge:0,Sort:1}
		
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|품명",		SaveName:"KEP_DESCRIPTION",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|규격",		SaveName:"KEP_SPECIFICATION",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|모델명",	SaveName:"KEP_MAKER_PART_NO",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|제조사",	SaveName:"KEP_MAKER_NAME",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|최소주문수량",	SaveName:"KEP_MIN_ORDER_QTY",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|주문배수수량",	SaveName:"KEP_PUR_UNIT_QTY",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|단위",		SaveName:"KEP_UNIT_MEASURE",ColMerge:0,Sort:1}
	
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|품명",			SaveName:"SM_DESCRIPTION",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|규격",			SaveName:"SM_SPECIFICATION",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|모델명",		SaveName:"SM_MAKER_PART_NO",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|제조사",		SaveName:"SM_MAKER_NAME",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|최소주문수량",			SaveName:"SM_MIN_ORDER_QTY",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|주문배수수량",		SaveName:"SM_PUR_UNIT_QTY",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|단위",			SaveName:"SM_UNIT_MEASURE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|거래유형",			SaveName:"PROCESS_TYPE_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|배송유형",			SaveName:"PARCEL_YN_NAME"}
		,{ Align:"Center",	Width:155 ,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|TR",					SaveName:"WAREHOUSE_NAME"}
		
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주 횟수|발주 횟수",		SaveName:"PO_CNT"}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"수량|수량",			SaveName:"ITEM_QTY"}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"기존단가|기존단가",			SaveName:"RE_LIST_PRICE",	Format:"${priceFormat}"}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"메인사업장(납품처)|메인사업장(납품처)",	SaveName:"MAIN_BUYER"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"일괄담당자|일괄담당자",		SaveName:"AGENT_MNG_USER_NAME",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"SG|SG",			SaveName:"SG_NAME",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"SG담당자|SG담당자",		SaveName:"SM_USER_NAME",ColMerge:0,Sort:1}
		
		,{Hidden:true,	Type:"Date",	Header:"프로젝트견적마감일",	SaveName:"RFQ_END_SCHD_DATE"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode,5);

	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
	$("#st_to_date").val(kepToMonthAdd("2","P"));

	//다중선택콤보(공통) - 생성
	kepAjaxCommonTotalMultiCombo('st_receipt_status', 'BURQ08', 'ALL', '');
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "BURQ_NO");	//프로젝트 코드
	setLinkCol(mySheet, "ADD_AGENT_CNT"); // 추가협력사(요청전)
	setLinkCol(mySheet, "BTN");  // 추가협력사(요청전) - 추가
	setLinkCol(mySheet, "RECEIPT_CNT");// 견적현황
	
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");	
	var st_query = "";
	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	var burq_no = $("#st_burq_no").val();
	
	switch (str) {
		case "search":	 // 조회
		
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			
			if(isEmpty(burq_no)){
				alert("프로젝트를 선택하시기 바랍니다.");
				return;
			}
			
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 62 ){
				alert("조회기간을 2개월 단위로 조회가 가능합니다.\n\n2개월 이상의 데이타는 S/R 요청 바랍니다.");
				return;
			}
			
			$("#st_gpl_yn").val($("input[name=gpl_yn]:checked").val());
			
			kepSearch(document.searchCondition, mySheet, "/mprq/getMasterMpRqBulkQuotationReceiptList.do", pagingMode);
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_from_date").val(kepToDateAdd("7","M"));
			$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
			
			document.getElementById("st_date_type").selectedIndex = 1;
			document.getElementById("st_data_type").selectedIndex = 0;

			// 다중선택콤보(공통) - 초기화
			init_multiCombo("st_receipt_status");
			
			$("#st_burq_no").val("");
			$('#st_receipt_status').val("");
			$('#st_project_code').val("");		
			
			$('#st_gpl_default').prop("checked", true);
			
			mySheet.RemoveAll();
			break;
			
		case "excelDown": // 조회결과 다운로드
			if(mySheet.RowCount() < 2){
				alert("조회된 결과가 없습니다.");
				return;
			}
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 62 ){
				alert("조회기간을 2개월 단위로 조회가 가능합니다.\n\n2개월 이상의 데이타는 S/R 요청 바랍니다.");
				return;
			}
			
			var project = $("#st_burq_no").val();
			var param = {FileName:"벌크소싱견적요청_"+project+".xlsx",Merge:1,SheetDesign:1,HiddenColumn:1	};
			kepDownExcel(document.searchCondition ,mySheet , "/mprq/excelMasterMpRqBulkQuotationReceiptList.do", param);
			break;
		case "Finish": // 견적마감
			
			if(!confirm("견적을 마감하면 협력사에 추가 견적 요청이 불가합니다. 견적마감 하시겠습니까?")){
				return;
			};
			for(var i = 0 ; i < arrRow.length; i++){
				var checkItemKeyId = mySheet.GetCellValue(arrRow[i],"ITEM_KEY_ID");
				st_query+= checkItemKeyId+"@@";
			}
			
			$("#st_query").val(st_query);
			kepAjaxFormCall("/mprq/finishMasterMpRqBulkQuotationReceiptList.do","searchCondition","Finish");
			break;
			
		case "CancelFinish": // 견적마감 취소
			
			for(var i = 0 ; i < arrRow.length; i++){
				if(mySheet.GetCellValue(arrRow[i],"STATUS") != "견적마감"){
					alert("견적마감 상태가 아닌 견적건은 취소가 불가능합니다.");
					return;
				}
				var cur_date = kepGetNowTimeStr("YYYYMMDD","");  
				
				if(mySheet.GetCellValue(arrRow[i],"RFQ_END_SCHD_DATE") < cur_date){
					alert("프로젝트의 견적마감일이 지난 건은 취소가 불가능합니다.");
					return;
				}
				var checkItemKeyId = mySheet.GetCellValue(arrRow[i],"ITEM_KEY_ID");
				st_query+= checkItemKeyId+"@@";
			}
			
			if(!confirm("견적마감 취소하시겠습니까?")){
				return;
			};
			
			$("#st_query").val(st_query);
			kepAjaxFormCall("/mprq/cancleMasterMpRqBulkQuotationReceiptList.do","searchCondition","CancelFinish");
			break;
			
		case "TempSave": // 임시저장
			
			kepSave(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqBulkQuotationReceiptListTemp.do" , "SELECTED" );
			break;
			
		case "AgentOrder": // 견적요청
			
			if(!confirm("견적 요청하시겠습니까?")){
				return;
			};
			kepSave(document.searchCondition ,  mySheet , "/mprq/orderMasterMpRqBulkQuotationReceiptList.do" , "SELECTED" );
// 			kepAjaxFormCall("/mprq/orderMasterMpRqBulkQuotationReceiptList.do","searchCondition","orderBurqItem");
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
	
	if (msg != "") {
		alert(msg);
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

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	var burq_no = mySheet.GetCellValue(Row,"BURQ_NO");
	var st_item_key_id = mySheet.GetCellValue(Row,"ITEM_KEY_ID");
	
	if (column == 'BURQ_NO') { // BURQ 번호
		popupSel = "masterMpRqBulkQuotationDetailPop";
		openSearchPopup('/mprq/getMasterMpRqBulkQuotationDetailPop.do', '?st_burq_no='+burq_no, "800,800,no"); // 프로젝트 조회 및 수정
	}else if(column == 'ADD_AGENT_CNT'){
		if( mySheet.GetCellValue(Row,"ADD_AGENT_CNT") == 0) {
			alert("추가된 협력사가 없습니다.");
			return;
		}
		popupSel = "addAgent";
		openSearchPopup('/mprq/showMasterMpRqBulkQuotationAddAgentPop.do', '?st_burq_no='+burq_no+'&st_item_key_id='+st_item_key_id, "600,500,no"); // dyc
	}else if(column == 'BTN'){ // 추가 버튼 
		mySheet.SetCellValue(Row,"SELECTED",1);
		doPop('AddAgentMulti');
	}else if(column == 'RECEIPT_CNT'){
// 		if( mySheet.GetCellValue(Row,"RECEIPT_CNT") == '0/0') {
// 			alert("요청된 협력사가 없습니다.");
// 			return;
// 		}
		popupSel = "addAgentList";
		openSearchPopup('/mprq/showMasterMpRqBulkQuotationAddAgentListPop.do', '?st_burq_no='+burq_no+'&st_item_key_id='+st_item_key_id, "430,480,no"); // 프로젝트 조회 및 수정
	}
	return;
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	var burq_no = $("#st_burq_no").val();
	var project_name = $("#st_project_name").val();
	var st_query = "";
	switch (str) {
		case "selProject":
			openSearchPopup('/mprq/showMasterMpRqBulkQuotationSelProjectPop.do','?st_type=B','630,450,no');
			break;
		case "selBuyer":
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N&AUTH=ALL", "500,466,no");
			break;
		case "selAgent":
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N&AUTH=ALL", "500,466,no");
			break;
		case "selSg":
			openSearchPopup("/mprq/showMasterMpRqSgChoicePop.do", "", "500,500,no");
			break;
		case "AddAgent": // 협력사추가(엑셀)
			if(isEmpty(burq_no)){
				alert("프로젝트를 선택하시기 바랍니다.");
				return;
			}
			openSearchPopup("/mprq/showMasterMpRqBulkQuotationAddAgentExcelPop.do","?st_burq_no="+burq_no+"&st_project_name="+project_name,'830,800,no');
			break;
		case "RegItemInfo":
			if(isEmpty(burq_no)){
				alert("프로젝트를 선택하시기 바랍니다.");
				return;
			}
			openSearchPopup("/mprq/showMasterMpRqBulkQuotationItemInfoRegPop.do","?st_burq_no="+burq_no+"&st_project_name="+project_name,'1380,830,no');
			break;
		case "AddAgentMulti": //일괄협력사 추가
			if(isEmpty(burq_no)){
				alert("프로젝트를 선택하시기 바랍니다.");
				return;
			}
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			if (isEmpty(selectedGrid)){
				alert("선택하신 견적이 없습니다.");
				return;
			}
			var arrRow = selectedGrid.split("|");
			for(var i = 0 ; i < arrRow.length; i++){
				var ch_STATUS = mySheet.GetCellValue(arrRow[i],"STATUS");
				if(ch_STATUS == "견적마감"){
					alert("견적마감된 건이 포함되어 있습니다. 견적 마감 취소를 먼저 하시기 바랍니다.");
					return;
				}
				var checkItemKeyId = mySheet.GetCellValue(arrRow[i],"ITEM_KEY_ID");
				st_query+= checkItemKeyId+"@@";
			}
			
			openSearchPopup("/mprq/showMasterMpRqBulkQuotationSelAgentPop.do","?st_burq_no="+burq_no+"&st_item_key_id="+st_query,'1270,700,no');
			break;
		case "ChangeEndDate": // 견적마감일 변경
			if(isEmpty(burq_no)){
				alert("프로젝트를 선택하시기 바랍니다.");
				return;
			}
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			if (isEmpty(selectedGrid)){
				alert("선택하신 견적이 없습니다.");
				return;
			}
			
			var arrRow     = selectedGrid.split("|");
			
			for(var i = 0 ; i < arrRow.length; i++){
				var ch_STATUS = mySheet.GetCellValue(arrRow[i],"STATUS");
				if(ch_STATUS == "견적마감"){
					alert("견적마감된 건이 포함되어 있습니다. 견적 마감 취소를 먼저 하시기 바랍니다.");
					return;
				}
			}
			
			openSearchPopup('/common/calendarPop.do','','300,240,no');
			break;
	}
}
function setPopupCalendar(year,month,day){
	var new_date = '';
	new_date+=year;
	new_date+=month;
	new_date+=day;
	var cur_date = kepGetNowTimeStr("YYYYMMDD","");  
	if(new_date < cur_date){
		alert("오늘 이전으로 지정 불가능합니다.");
		return;
	}
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	
	for(var i = 0 ; i < arrRow.length; i++){
		var schd_date = mySheet.GetCellValue(arrRow[i],"RFQ_END_SCHD_DATE");
		if(schd_date < new_date){
			alert("프로젝트의 견적 마감일 이후로 변경이 불가능합니다.");
			return;
		}
	}
	$("#st_new_date").val(new_date);
	
	kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqBulkQuotationReceiptListEndDate.do" , "SELECTED" );
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2,value3, value4){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel=="selProject"){
		$("#st_burq_no").val(value1);
		$("#st_project_name").val(value2);
		$("#st_project_unit").val(value3);
		$("#st_sm_user_id").val(value4);
	} else if (popupSel == "selBuyer") {
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	} else if (popupSel == "selAgent") {
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
	} else if(popupSel=="selSg"){
		$("#st_c_sg_id").val(value1);
		$("#st_c_sg_nm").val(value2);
	} else if(popupSel="AddAgentMulti" || popupSel=="RegItemInfo"){
		if(value1='1'){
			doAction('search');
		}
	} else if(popupSel="addAgent"){
		if(value1='1'){
			doAction('search');
		}
	}
	grbRow="";	//초기화
}

function kepDate(from,to,mt){
	$("#"+to).val(tokepDateAdd(from,'7','M'));
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){  
	var msg = response.Msg;
	if (msg != "") {
		alert(msg);
	}
	
	if (pMethod == "Finish"){
		alert("선택된 품목이 마감되었습니다.");
		doAction('search');
	}else if(pMethod == "CancelFinish"){
		alert("견적마감이 취소되었습니다.");
		doAction('search');
	}else if(pMethod =="orderBurqItem"){
		alert("견적 요청되었습니다.");
		doAction('search');
	}
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function kepAjaxError(pMethod , response) { 
	var msg = response.Message;

	if (!isEmpty(msg)){	
		alert(msg);
	}
	return;
}

function kepMonth2(from,to,mt){
	var _from = "#" + from;
	var _to = "#" + to;
	$(_from).val( kepGetNowTimeStr('YYYYMMDD','/') );
	$(_to).val( kepToMonthAdd(mt,"P") );
	
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>벌크소싱 견적요청</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
		<!--조회영역-->
       	<form name = "searchCondition" id ="searchCondition"  method = "post">
			<div id="cont_searchA">
				<!--HIDDEN-->
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="st_query" name="st_query">
				<input type="hidden" id="st_gpl_yn" name="st_gpl_yn">
				<input type="hidden" id="st_sm_user_id" >
				<input type="hidden" id="st_new_date" name="st_new_date" >
            	<table  class="cont_t_list01" >
					<caption>벌크소싱 견적요청</caption>
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
							<th>
								<label for="b_code" class="hidden">기간선택</label>
					  			<select name = "st_date_type" id="st_date_type" class="TitSelect" style="height:20px;">
						      		<option value="ADD">견적요청일</option>
									<option value="END" selected="selected">견적마감일</option>
	                           </select>
							</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								-
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth2('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth2('st_from_date','st_to_date','2')">2개월</a></span>
								<span class="btn_month"><a href="javascript:kepFromMonth('st_from_date','st_to_date','1')">-1개월</a></span>
								
							</td>
						</tr>
						<tr> 
							<th class="center"><font color="red">*</font>프로젝트</th>
							<td>
								<input type="text" class="input_type_text" name="st_project_name" id="st_project_name" style="width:63%" value="">
								<input type="hidden" name="st_burq_no" id="st_burq_no" style="width:55%" value="">
								<a href="javascript:doPop('selProject');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_burq_no','st_project_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:63%" value="">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
								<a href="javascript:doPop('selBuyer');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>협력사</th>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:63%" value="">
								<input type="hidden" name="st_agent_code" id="st_agent_code" value="">
								<a href="javascript:doPop('selAgent');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
						<tr> 
							<th>
								<label for="b_code" class="hidden">선택</label>
						  		<select name = "st_data_type" id="st_data_type" class="TitSelect" style="height:20px;">
									<option value="ITEM_KEY" selected="selected">키값</option>
									<option value="ITEM_NO">품목코드</option>
								</select>
							</th>
							<td>
								<input type="text" class="input_type_text" id="st_data_input" name="st_data_input" style="width:87%;" value="" onkeydown="kepEnter()">
							</td>
							<th>SG</th>
							<td>
								<input type="text" class="input_type_text" name="st_c_sg_nm" id="st_c_sg_nm" style="width:63%" value="">
								<input type="hidden" name="st_c_sg_id" id="st_c_sg_id" style="width:55%" value="">
								<a href="javascript:doPop('selSg');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_c_sg_id','st_c_sg_nm');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>일괄 담당자</th>
							<td>
								<input type="text" class="input_type_text" id="st_agent_mng_name" name="st_agent_mng_name" style="width:87%;" value="" onkeydown="kepEnter()">
							</td>
						</tr>
						<tr>
							<th>제조사</th>
							<td>
								<input type="text" class="input_type_text" id="st_maker_name" name="st_maker_name" style="width:87%;" value="" onkeydown="kepEnter()">
							</td>
							<th>견적번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_burq_rfq_no" name="st_burq_rfq_no" style="width:87%;" value="" onkeydown="kepEnter()">
							</td>
							<th>진행상태</th>
							<td>
								<!-- 다중선택콤보(공통) - input박스의 type은 hidden으로 생성 할것 , style, class는 select 박스에 상속 됨. -->
								<input type="hidden" name="st_receipt_status" id="st_receipt_status" value ="" style="width:217px;">
							</td>
							</td>
						</tr>
						<tr>
							<th>품명</th>
							<td>
								<input type="text" class="input_type_text" id="st_description" name="st_description" style="width:87%;" value="" onkeydown="kepEnter()">
							</td>
							<th>규격</th>
							<td>
								<input type="text" class="input_type_text" id="st_specification" name="st_specification" style="width:87%;" value="" onkeydown="kepEnter()">
							</td>
							<th>모델명</th>
							<td>
								<input type="text" class="input_type_text" id="st_model_name" name="st_model_name" style="width:87%;" value="" onkeydown="kepEnter()">
							</td>
						</tr>
						<tr>
							<th>GPL 품목</th>
							<td>
								<label><input type="radio" name="gpl_yn" id="st_gpl_default" checked value="ALL">&nbsp;전체</label>
								<label><input type="radio" name="gpl_yn" value="Y">&nbsp;Y</label>
								<label><input type="radio" name="gpl_yn" value="N">&nbsp;N</label>
							</td>
							<th>추가 협력사 요청 전</th>
							<td>
								<label><input type="radio" name="st_agent_add" checked value="Y">&nbsp;전체</label>
								<label><input type="radio" name="st_agent_add" value="N">&nbsp;요청 전 건만</label>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
  		<br>
		</form>
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			
  			<!--버튼영역-->
            <div class="btnArea">
				<span class="fl">
					<span class="btn_08"><a href="javascript:doAction('excelDown');">조회결과 다운로드</a></span>
					<span class="btn_08"><a href="javascript:doPop('RegItemInfo');">KeP품목정보 등록</a></span>
					<span class="btn_06"><a href="javascript:doPop('AddAgent');">협력사 추가(엑셀)</a></span>
					<span class="btn_06"><a href="javascript:doPop('AddAgentMulti');">일괄협력사 추가</a></span>
					<span class="btn_06"><a href="javascript:doPop('ChangeEndDate');">견적마감일 변경</a></span>
				</span>
  				<span class="fr">
  					<span class="btn_06"><a href="javascript:doAction('CancelFinish');">견적마감 취소</a></span>
  					<span class="btn_04"><a href="javascript:doAction('Finish');">견적마감</a></span>
  					<span class="btn_04"><a href="javascript:doAction('AgentOrder');">견적요청</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
