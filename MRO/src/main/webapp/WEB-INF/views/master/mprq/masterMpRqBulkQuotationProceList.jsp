<%--
**********************************************
* 메뉴 : 견적관리>벌크소싱 견적현황
* 화면 : 벌크소싱 견적현황
* 기능 : 벌크소싱 견적현황 관리
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 2025-09-19
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
	initsheet.HeaderMode = {			Sort : 0,			ColMove : 1,			ColResize : 1		};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:18};
	initsheet.Cols = [
		 { Align:"Center",	Hidden:true,Type:"Text",	Header:"상태|상태",	SaveName: "sStatus"} 
		,{ Align:"Center",	Width:30,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:" | ",					SaveName:"SELECTED",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적번호|견적번호",			SaveName:"BURQ_RFQ_NO",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"프로젝트코드|프로젝트코드",	SaveName:"BURQ_NO",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"프로젝트명|프로젝트명",		SaveName:"PROJECT_NAME",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사명|고객사명",			SaveName:"BUYER_NAME",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:75,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"견적요청일|견적요청일",		SaveName:"ATOS_DATE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:75,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"견적마감일|견적마감일",		SaveName:"ATOS_END_DATE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:65,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"진행상태|진행상태",			SaveName:"STATUS",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사구분|협력사구분",		SaveName:"AGENT_TYPE_NAME",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품목제안|품목제안",		SaveName:"ITEM_TYPE_NAME",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"기존단가|기존단가",			SaveName:"RE_LIST_PRICE",	Format:"${priceFormat}"}
		,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"제출단가|제출단가",			SaveName:"CH_LIST_PRICE",	Format:"${priceFormat}"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"단가제출자|단가제출자",		SaveName:"PRICE_SUBMIT_USER",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"수량|수량",				SaveName:"ITEM_QTY"}
		,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"총기준가|총기준가",			SaveName:"TOT_RE_LIST_PRICE",	Format:"${priceFormat}"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"단가변동액|단가변동액",		SaveName:"PRICE_GAP"}
		,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"단가변동율|단가변동율",		SaveName:"GAP_RATE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:75,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"메일발송일|메일발송일",		SaveName:"MAIL_SEND_DATE",ColMerge:0,Sort:1}
		
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사 제출정보|협력사명",		SaveName:"AGENT_NAME",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사 제출정보|품명",		SaveName:"AGENT_DESCRIPTION",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사 제출정보|규격",		SaveName:"AGENT_SPECIFICATION",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사 제출정보|모델명",		SaveName:"AGENT_MAKER_PART_NO",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사 제출정보|제조사",		SaveName:"AGENT_MAKER_NAME",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사 제출정보|최소주문수량",		SaveName:"AGENT_MIN_ORDER_QTY",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사 제출정보|주문배수수량",		SaveName:"AGENT_PUR_UNIT_QTY",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사 제출정보|단위",		SaveName:"AGENT_UNIT_MEASURE",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사 제출정보|거래유형",		SaveName:"AGENT_PROCESS_TYPE",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사 제출정보|배송유형",		SaveName:"AGENT_PARCEL_YN",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사 제출정보|비고",		SaveName:"AGENT_REMARK",ColMerge:0,Sort:1}
		
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|품명",		SaveName:"KEP_DESCRIPTION",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|규격",		SaveName:"KEP_SPECIFICATION",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|모델명",	SaveName:"KEP_MAKER_PART_NO",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|제조사",	SaveName:"KEP_MAKER_NAME",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|최소주문수량",	SaveName:"KEP_MIN_ORDER_QTY",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|주문배수수량",	SaveName:"KEP_PUR_UNIT_QTY",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|단위",		SaveName:"KEP_UNIT_MEASURE",ColMerge:0,Sort:1}
	
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|품명",			SaveName:"SM_DESCRIPTION",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|규격",			SaveName:"SM_SPECIFICATION",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|모델명",		SaveName:"SM_MAKER_PART_NO",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|제조사",		SaveName:"SM_MAKER_NAME",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|최소주문수량",	SaveName:"SM_MIN_ORDER_QTY",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|주문배수수량",	SaveName:"SM_PUR_UNIT_QTY",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|거래유형",		SaveName:"SM_PROCESS_TYPE",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|배송유형",		SaveName:"SM_PARCEL_YN",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|TR",			SaveName:"SM_WAREHOUSE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP 품목정보|단위",			SaveName:"SM_UNIT_MEASURE",ColMerge:0,Sort:1}
		
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주 횟수|발주 횟수",			SaveName:"PO_CNT"}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"메인사업장(납품처)|메인사업장(납품처)",	SaveName:"MAIN_BUYER"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"일괄담당자|일괄담당자",		SaveName:"AGENT_MNG_USER_NAME",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"SG|SG",					SaveName:"SG_NAME",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"SG담당자|SG담당자",			SaveName:"SM_USER_NAME",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:230,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"키값|키값",				SaveName:"ITEM_KEY_ID",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"GPL|GPL",				SaveName:"GPL_YN",ColMerge:0,Sort:1}
		
		,{ Align:"Center",	Hidden:true,	Type:"Float",		Header:"견적요청",		SaveName:"CNT1"}
		,{ Align:"Center",	Hidden:true,	Type:"Float",		Header:"견적제출",		SaveName:"CNT2"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",		Header:"절감액+/-",	SaveName:"PRICE_GAP_FLAG"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",		Header:"일괄담당자",	SaveName:"AGENT_MNG_USER_ID"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",		Header:"일괄담당자연락처",	SaveName:"AGENT_MNG_USER_TEL"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val(kepToMonthAdd("1","M")); 
	$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/'));

	//다중선택콤보(공통) - 생성
	kepAjaxCommonTotalMultiCombo('st_proce_status', 'BURQ04', 'ALL', '');
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "MAIL_SEND_DATE");	//메일발송일
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
	if (str !="search" && str !="excelDown" && str !="reload" && str != "AgentOrder" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	var burq_no = $("#st_burq_no").val();
	
	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 62 ){
				alert("조회기간을 2개월 단위로 조회가 가능합니다.\n\n2개월 이상의 데이타는 S/R 요청 바랍니다.");
				return;
			}
			
			if(isEmpty(burq_no)){
				alert("프로젝트를 반드시 선택하시기 바랍니다.");
				return;
			}
			
			$("#st_gpl_yn").val($("input[name=gpl_yn]:checked").val());
			$("#st_agent_type").val($("input[name=agent_type]:checked").val());
			
			kepSearch(document.searchCondition, mySheet, "/mprq/getMasterMpRqBulkQuotationProceList.do", pagingMode);
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
		
			document.getElementById("st_date_type").selectedIndex = 0;
			$("#st_from_date").val(kepToMonthAdd("1","M")); 
			$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
			
			// 다중선택콤보(공통) - 초기화
			init_multiCombo("st_proce_status");
			$('#st_proce_status').val('');
			$('#st_burq_no').val('');
			$('#st_c_sg_id').val('');
			$('#st_agent_code').val('');
			
			$('#st_gpl_default').prop("checked", true);
			$('#st_agent_type_default').prop("checked", true);
			
			mySheet.RemoveAll();
			
			break;
			
		case "excelDown": // 조회결과 다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 62 ){
				alert("조회기간을 2개월 단위로 조회가 가능합니다.\n\n2개월 이상의 데이타는 S/R 요청 바랍니다.");
				return;
			}
			
			if(mySheet.RowCount() < 1) {
				alert("다운로드 할 데이터가 없습니다.");
				return;
			}
// 			var param = {FileName:"벌크소싱 견적현황.xls", Merge:1,SheetDesign:1};
// 			kepDownExcel(document.searchCondition , mySheet , "/mprq/excelMasterMpRqBulkQuotationProceList.do", param);
			document.forms.searchCondition.action = "/mprq/excelMasterMpRqBulkQuotationProceList.do";
			document.forms.searchCondition.submit();
			break;
		case "save": // 동일 단가 적용
			
			if(!confirm("선택한 품목을 기존 단가와 동일하게 적용하시겠습니까?")){
				return;
			};
			
			for(var i = 0 ; i < arrRow.length; i++){
				if(mySheet.GetCellValue(arrRow[i], "AGENT_TYPE_NAME") != "재계약"){
					alert("신규 협력사 단가는 기존단가 동일 적용이 불가 합니다.");
					return;
				}
				
				if(mySheet.GetCellValue(arrRow[i], "AGENT_MNG_USER_ID") != "<%=st_user_id%>"){
					alert("견적 일괄담당자가 아닌 건이 선택되었습니다.");
					return;
				}
				
				var checkItemKeyId = mySheet.GetCellValue(arrRow[i],"ITEM_KEY_ID");
				st_query+= checkItemKeyId+"@@";
			}
			
			$("#st_query").val(st_query);
			kepAjaxFormCall("/mprq/updateMasterMpRqBulkQuotationSamePrice.do","searchCondition","save");
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
	if( totRow <= 0) return;
	
	if (msg != "") {
		alert(msg);
	}
	
	document.getElementById("cnt1").innerHTML = mySheet.RowCount();
	document.getElementById("cnt2").innerHTML = mySheet.ComputeSum("|49|");
	document.getElementById("cnt3").innerHTML = mySheet.ComputeSum("|50|");
	
	// 절감액 절감율 색 바꾸기
	/*
	for(var i = 2 ; i <= totRow+2; i++){
		var flag = mySheet.GetCellValue(i,"PRICE_GAP_FLAG");

		switch (flag){
			case "P":
				 mySheet.SetCellFontColor(i,"PRICE_GAP","#FF0000");
				 mySheet.SetCellFontColor(i,"GAP_RATE","#FF0000");
				 break;
			case "N":
				 mySheet.SetCellFontColor(i,"PRICE_GAP","#0000FF");
				 mySheet.SetCellFontColor(i,"GAP_RATE","#0000FF");
				 break;
		}
	}
	*/
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
		openSearchPopup('/mprq/getMasterMpRqBulkQuotationDetailPop.do', '?st_burq_no='+burq_no, "1000,621,no"); // 프로젝트 조회 및 수정
	}else if(column == 'ADD_AGENT_CNT'){
		if( mySheet.GetCellValue(Row,"ADD_AGENT_CNT") == 0) {
			alert("추가된 협력사가 없습니다.");
			return;
		}		
		popupSel = "masterMpRqBulkQuotationAddAgentPop";
		openSearchPopup('/mprq/showMasterMpRqBulkQuotationAddAgentPop.do', '?st_burq_no='+burq_no+'&st_item_key_id='+st_item_key_id, "600,500,no"); // 프로젝트 조회 및 수정
	}else if(column == 'BTN'){
		popupSel = "masterMpRqBulkQuotationSelAgentPop";
		
		openSearchPopup("/mprq/showMasterMdcmAgentDmSendPop.do","?st_burq_no="+burq_no+"&st_item_key_id="+mySheet.GetCellValue(Row,"ITEM_KEY_ID"),'1300,500,no');
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
			openSearchPopup('/mprq/showMasterMpRqBulkQuotationSelProjectPop.do','?st_type=B','760,450,no');
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
		case "mail":
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");

			if(isEmpty(selectedGrid)){
				alert("메일 발송할 건을 선택하시기 바랍니다.");
				return;
			}
			
			var arrRow = selectedGrid.split("|");
			
			if (arrRow.length > 10){
				alert("10건 이하로 DM발송 가능합니다.");
				return;
			}
			
			var agent = mySheet.GetCellValue(arrRow[0],"AGENT");
			var agent_name = mySheet.GetCellValue(arrRow[0],"AGENT_NAME");
			var st_agent_mng_user_name = mySheet.GetCellValue(arrRow[0],"AGENT_MNG_USER_NAME");
			var st_agent_mng_user_tel = mySheet.GetCellValue(arrRow[0],"AGENT_MNG_USER_TEL");
			
			var item_list  =  ''; 
			for(var idx = 0; idx < arrRow.length ; idx++){
				if(agent != mySheet.GetCellValue(arrRow[idx],"AGENT")){
					alert("2개이상의 협력사가 선택 되었습니다.\n 1개의 협력사만 선택 후 메일을 발송해 주세요.");
					return;
				}
				
				if(mySheet.GetCellValue(arrRow[idx], "AGENT_MNG_USER_ID") != "<%=st_user_id%>"){
					alert("견적 일괄담당자가 아닌 건이 선택되었습니다.");
					return;
				}
				
				item_list += mySheet.GetCellValue(arrRow[idx],"BURQ_NO") + "-" + mySheet.GetCellValue(arrRow[idx],"BURQ_RFQ_NO") + "@@" 
			}
			
			$("#st_com_code").val(agent);
			$("#st_com_name").val(agent_name);
			$("#item_list").val(item_list);
			$("#st_agent_mng_user_name").val(st_agent_mng_user_name);
			$("#st_agent_mng_user_tel").val(st_agent_mng_user_tel);
			
			popupSel = "DmSendPop";
			openSearchPopupPost("/mprq/showMasterMpRqBulkQuotationDmSendPop.do", "agentDmSendPopForm", "showMasterMpRqBulkQuotationDmSendPop", "width=910,height=880,resizable=no,scrollbars=no, top=0, left=0");
			break;
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2,value3){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel=="selProject"){
		$("#st_burq_no").val(value1);
		$("#st_project_name").val(value2);
		$("#st_project_unit").val(value3);
	} else if (popupSel == "selBuyer") {
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	} else if (popupSel == "selAgent") {
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
	} else if(popupSel=="selSg"){
		$("#st_c_sg_id").val(value1);
		$("#st_c_sg_nm").val(value2);
	} else if(popupSel =="DmSendPop"){
		doAction('search');
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
	
	if (pMethod == "save"){
		alert("선택된 품목에 동일 단가 적용하였습니다.");
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

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if (column == 'MAIL_SEND_DATE') { // 메일 발송일
		var burq_no = mySheet.GetCellValue(Row,"BURQ_NO");
		var burq_rfq_no = mySheet.GetCellValue(Row,"BURQ_RFQ_NO");
		var agent = mySheet.GetCellValue(Row,"AGENT");
		popupSel = "DmHistPop";
		openSearchPopup('/mprq/getMasterMpRqBulkQuotationDmHistPop.do', '?BURQ_NO='+burq_no+"&BURQ_RFQ_NO="+burq_rfq_no+"&AGENT="+agent, "600,300,no"); 
	}
	return;
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>벌크소싱 견적현황</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>       
   		<form name="agentDmSendPopForm" id="agentDmSendPopForm">
   			<input type="hidden" name="st_com_code" id="st_com_code">
   			<input type="hidden" name="st_com_name" id="st_com_name">
			<input type="hidden" id="item_list" name="item_list">
			<input type="hidden" name="st_agent_mng_user_name" id="st_agent_mng_user_name">
			<input type="hidden" name="st_agent_mng_user_tel" id="st_agent_mng_user_tel"> 
   		</form> 	
		<!--조회영역-->
       	<form name = "searchCondition" id ="searchCondition"  method = "post">
			<div id="cont_searchA">
				<!--HIDDEN-->
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="st_query" name="st_query"> 
				<input type="hidden" id="st_gpl_yn" name="st_gpl_yn">	
				<input type="hidden" id="st_agent_type" name="st_agent_type">
            	<table  class="cont_t_list01" >
					<caption>벌크소싱 견적현황</caption>
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
						      		<option value="ADD" selected="selected">견적요청일</option>
									<option value="END">견적마감일</option>
	                           </select>
							</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								-
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
							</td>
						</tr>
						<tr> 
							<th class="center"><font color="red">*</font> 프로젝트</th>
							<td>
								<input type="text" class="input_type_text" name="st_project_name" id="st_project_name" style="width:63%" value="">
								<input type="hidden" name="st_burq_no" id="st_burq_no" style="width:55%" value="">
								<a href="javascript:doPop('selProject');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_burq_no','st_project_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:87%" value="" onkeydown="kepEnter()">
<!-- 								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:55%" value=""> -->
<!-- 								<a href="javascript:doPop('selBuyer');"><img src="/resources/images/btn_search03.gif"></a> -->
<!-- 								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> -->
							</td>
							<th>협력사</th>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:63%" value="">
								<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:55%" value="">
								<a href="javascript:doPop('selAgent');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
						<tr> 
							<th>키값</th>
							<td>
								<input type="text" class="input_type_text" id="st_item_key_id" name="st_item_key_id" style="width:87%;" value="" onkeydown="kepEnter()">
							</td>
							<th>SG</th>
							<td>
								<input type="text" class="input_type_text" name="st_c_sg_nm" id="st_c_sg_nm" style="width:63%" value="">
								<input type="hidden" name="st_c_sg_id" id="st_c_sg_id" style="width:55%" value="">
								<a href="javascript:doPop('selSg');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_c_sg_id','st_c_sg_nm');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>
								<label for="b_code" class="hidden">담당자 선택</label>
					  			<select name = "st_mng_type" id="st_mng_type" class="TitSelect" style="height:20px;">
						      		<option value="AGENT" selected="selected">일괄담당자</option>
									<option value="SG">SG담당자</option>
	                           </select>
							</th>
							<td>
								<input type="text" class="input_type_text" id="st_mng_name" name="st_mng_name" style="width:87%;" value="" onkeydown="kepEnter()">
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
								<input type="hidden" name="st_proce_status" id="st_proce_status" value ="" style="width:217px;">
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
								<label><input type="radio" name="gpl_yn" value="ALL" id="st_gpl_default" checked>&nbsp;전체</label>
								<label><input type="radio" name="gpl_yn" value="Y">&nbsp;Y</label>
								<label><input type="radio" name="gpl_yn" value="N">&nbsp;N</label>
							</td>
							<th>협력사 구분</th>
							<td colspan="3">
								<label><input type="radio" name="agent_type" value="ALL" id="st_agent_type_default" checked>&nbsp;전체</label>
								<label><input type="radio" name="agent_type" value="A">&nbsp;신규</label>
								<label><input type="radio" name="agent_type" value="B">&nbsp;재계약</label>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
		</form>
		<br>
		  
      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
  			
		<table width="100%" border="0" cellspacing="0" cellpadding="0" border="1" bgcolor="#F0F0F0" height="25px">
			<colgroup>
				<col width="5%" />
				<col width="8%" />
				<col width="8%" />
				<col width="8%" />
				<col width="*%" />
			</colgroup>
			<tr>
				<td align="right" style="font-weight:bold" rowspan=2>
					요약
				</td>
				<td align="right" style="font-weight:bold">
					견적요청      <span id="cnt1" style="font-weight:bold;">0</span>
					
				</td>
				<td align="right" style="font-weight:bold">
					견적제출      <span id="cnt2" style="font-weight:bold;">0</span>
				</td>
				<td align="right" style="font-weight:bold">
					미회신        <span id="cnt3" style="font-weight:bold;">0</span> 
				</td>
				<td></td>
			</tr>
		</table>
		<!--버튼영역-->
        <div class="btnArea">
        	<span class="fl">
				<span class="btn_08"><a href="javascript:doAction('excelDown');">조회결과 다운로드</a></span>
			</span>
			<span class="fr">
				<span class="btn_06"><a href="javascript:doAction('save');">동일 단가 적용</a></span>
				<span class="btn_06"><a href="javascript:doPop('mail');">협력사 메일발송</a></span>
			</span>
		</div>
<!--내용 종료-->	                 

</body>
</html>
