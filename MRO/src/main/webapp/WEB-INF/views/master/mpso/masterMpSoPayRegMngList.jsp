<%--
**********************************************
* 메뉴 : 주문관리 > 지급이슈 등록 및 조회
* 화면 : 지급이슈 등록 및 조회
* 기능 : 
**********************************************
--%>
<%@page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>
<style type="text/css">
<!--
table.ui-datepicker-calendar {
	display: none;
}
-->
</style>
<%
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String sessionEmpNo = sessionInfo.getEmpNo();
String st_user_id = ""; // 사용자 ID
if (sessionInfo != null){
	st_user_id = sessionInfo.getUserId();
}

%>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var zipOn="/resources/images/btn_search03.gif";
var calendar = "/resources/images/btn_calendar.gif";
var grbAcnt = 0;
var grbBcnt = 0;
var grbCcnt = 0;

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
			{Align : "Center", SaveName : "SELECTED",		Type : "DummyCheck", Header:"|",	Width : 30,		Edit : true,	Sort:0}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"품의번호|품의번호",			SaveName:"GW_PAY_REG_NO"}
			,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Type:"Text",		Header:"지급이슈등록번호|지급이슈등록번호",		SaveName:"PAY_REG_NO", Hidden : true}
			,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Type:"Text",		Header:"지급이슈등록항번|지급이슈등록항번",		SaveName:"PAY_REG_SEQ", Hidden : true}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"상태|상태",			SaveName:"STATUS", Hidden : true}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"주문번호|주문번호",			SaveName:"PR_NO", Hidden : true}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"주문항번|주문항번",			SaveName:"PR_SEQ", Hidden : true}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"입고번호|입고번호",			SaveName:"GR_NO", Hidden : true}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"입고항번|입고항번",			SaveName:"GR_SEQ", Hidden : true}
			,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Type:"Text",		Header:"진행상태|진행상태",		SaveName:"PAY_REG_STATUS"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"발주번호|발주번호",			SaveName:"PO_NO"	 }
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"발주항번|발주항번",			SaveName:"PO_SEQ", Hidden : true }
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"품목코드|품목코드",			SaveName:"BUYER_ITEM_NO"}
			,{ Align:"Center",	Width:30,	Edit:false,	EditLen:100, 	Type:"Image",		Header:"품목코드|품목코드",		SaveName:"BUYER_ITEM_NO_IMG"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"협력사코드|협력사코드",			SaveName:"AGENT", Hidden : true}
			,{ Align:"Left",	Width:110,	Edit:false,	EditLen:100,	Type:"Text",		Header:"협력사명|협력사명",			SaveName:"AGENT_NAME"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"사업자번호\n(S)|사업자번호\n(S)",			SaveName:"AGENT_IRS_NO" }
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"고객사코드|고객사코드",		SaveName:"BUYER", Hidden : true}
			,{ Align:"Left",	Width:110,	Edit:false,	EditLen:100,	Type:"Text",		Header:"고객사명|고객사명",		SaveName:"BUYER_NAME"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"사업자번호\n(B)|사업자번호\n(B)",		SaveName:"BUYER_IRS_NO" }
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Type:"Text",		Header:"마감\n예정월|마감\n예정월",		SaveName:"SCHD_CLOSE_MONTH"}
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Type:"Text",	 Hidden : true, 	Header:"마감\n예정월|마감\n예정월",		SaveName:"DB_SCHD_CLOSE_MONTH"}			
			,{ Align:"Center",	Width:30,	Edit:false,		Type:"Image",		Header:"마감\n예정월|마감\n예정월",		SaveName:"SCHD_CLOSE_MONTH_IMG"}
			,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Type:"Text",		Header:"지급이슈구분|지급이슈구분",		SaveName:"PAY_REG_TYPE", Hidden : true}			
			,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Type:"Float",		Header:"지급이슈금액|선지급금",			SaveName:"PAY_AMT1", Format:"${priceFormat}"}
			,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Type:"Float",		Header:"지급이슈금액|지체상금",			SaveName:"PAY_AMT2", Format:"${priceFormat}"}
			,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Type:"Float",		Header:"지급이슈금액|물류비",				SaveName:"PAY_AMT3", Format:"${priceFormat}"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Type:"Float",		Header:"지급이슈금액|물류비 확정세액",				SaveName:"TAX_AMT", Format:"${priceFormat}"}
			,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Type:"Float",		Header:"재고금액|재고금액",				SaveName:"PAY_AMT4", Format:"${priceFormat}"}
			,{ Align:"Left",	Width:180,	Edit:false,	EditLen:100,	Type:"Text",		Header:"등록사유|등록사유",		SaveName:"REMARK"}
			,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Type:"Text",		Header:"등록일자|등록일자",		SaveName:"ADD_DATE"}
			,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Type:"Text",		Header:"등록자|등록자",		SaveName:"ADD_USER_ID", Hidden : true}			
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Type:"Text",		Header:"등록자명|등록자명",			SaveName:"ADD_USER_NAME"}
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Type:"Text",		Header:"마감월|마감월",				SaveName:"BILL_CLOSE_MONTH"}
		
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	//하이퍼링크 설정	
	setLinkCol(mySheet, "BUYER_ITEM_NO_IMG");
	setLinkCol(mySheet, "SCHD_CLOSE_MONTH_IMG");
	//검색 이미지설정
	mySheet.SetImageList(0, zipOn);
	mySheet.SetImageList(1, calendar);
	//진행상태 셋팅
	kepAjaxCommonComboDataValue('st_pay_reg_status','PYRG01','ALL');
	
	//조회조건 일자 초기화
	kepSetCalenderYearMonth("st_from_date");
	// 조회조건 일자 설정
	$("#st_from_date").val(kepGetNowTimeStr('YYYYMM', '/'));
	
	
}
//기능함수
function doAction(str) {
	switch (str){
		case "search":	 // 조회
			current_page = -1;			
			kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoPayRegMngList.do" , pagingMode );
			break;
		case "save":	 // 저장
			
			if(checkSaveValid()) {
				if (!confirm('선택한 항목을 저장 하시겠습니까?')) {
					return;
				}
				kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoPayRegMngList.do" , "SELECTED" );
			}			
			break;
		case "delete":	 // 삭제
			
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow     = selectedGrid.split("|");	
			// 선택된 항목 유무 체크
			if (selectedGrid.length == 0) {
				alert("선택된 항목이 없습니다.");
				return false;
			}
			
			for(var i=0; i< arrRow.length; i++){
				if(mySheet.GetCellValue(arrRow[i], "PAY_REG_STATUS") == "품의중" || mySheet.GetCellValue(arrRow[i], "PAY_REG_STATUS") == "확정") {
					alert("신규등록 및 품의반려 건만 삭제가 가능합니다.")
					return;
				}
				if(mySheet.GetCellValue(arrRow[i], "ADD_USER_ID") != "<%=st_user_id%>") {
					alert("본인이 등록한 지급이슈에 대해서만 저장 및 삭제가 가능합니다.")
					return;
				}
			}
			if (!confirm('선택한 항목을 삭제 하시겠습니까?')) {
				return;
			}
			kepSave(document.searchCondition ,  mySheet , "/mpso/deleteMasterMpSoPayRegMngList.do" , "SELECTED" );
			break;
		case "gwSave":	 // 확정		
			if(checkApproval()) {
				if (!confirm('선택한 항목을 확정 하시겠습니까?')) {
					return;
				}
				$("#job_kind").val("Approval");
				if(grbCcnt > 0) {
					$("#job_type").val("C"); // 물류비
					kepSave(document.searchCondition, mySheet, "/mpso/approvalMasterMpSoPayRegMngList.do", "SELECTED");
				} else {
					if(grbAcnt > 0) {
						$("#job_type").val("A"); // 선지급
					} else if(grbBcnt > 0) {
						$("#job_type").val("B"); // 지체상금
					}					
					kepSave(document.searchCondition, mySheet, "/mpso/approvalMasterMpSoPayRegMngList.do", "SELECTED");					
				}
					
								
			}
			
			
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			//조회조건 일자 초기화
			kepSetCalenderYearMonth("st_from_date");
			// 조회조건 일자 설정
			$("#st_from_date").val(kepGetNowTimeStr('YYYYMM', '/'));
			$("#st_buyer_code").val("");
			$("#st_buyer_name").val("");
			$("#st_agent_code").val("");
			$("#st_agent_name").val("");
			$("#st_buyer_irs_no").val("");
			$("#st_agent_irs_no").val("");
			$("#st_pay_reg_status").val("");
			$("#st_po_no").val("");
			$("#st_add_user_name").val("");
			$("#st_buyer_item_no").val("");
			mySheet.RemoveAll();
			break;
		case "excelDown": // 엑셀다운로드
		    $("#pageflag").val('0');
			var param = {FileName:"지급이슈.xlsx",DownCols:"GW_PAY_REG_NO|PAY_REG_STATUS|PO_NO|PO_SEQ|BUYER_ITEM_NO|AGENT_NAME|AGENT_IRS_NO|BUYER_NAME|BUYER_IRS_NO|SCHD_CLOSE_MONTH|PAY_AMT1|PAY_AMT2|PAY_AMT3|TAX_AMT|PAY_AMT4|REMARK|ADD_DATE|ADD_USER_NAME|BILL_CLOSE_MONTH|"};
			kepDownExcel(document.searchCondition ,mySheet , "/mpso/excelMasterMpSoPayRegMngList.do", param);
			$("#pageflag").val('1');
			break;
		}
			
	}
//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	
	switch (str) {
		case "masterCmCoBuyerAgntcmpyPop1": // 고객사 팝업
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
			popupSel = "masterCmCoBuyerAgntcmpyPop1";
			break;			
		case "masterCmCoBuyerAgntcmpyPop2": // 협력사 팝업
			openSearchPopup("/cmco/showMasterCmCoBuyerAgntcmpyPop.do", "?st_com_type=S&st_sys_change_flag=N&st_sys_type=KA", "500,500,no");
			popupSel = "masterCmCoBuyerAgntcmpyPop2";
			break;		
		case "insert" : // 등록 팝업
			openSearchPopup("/mpso/showMasterMpSoPayRegMngUploadPop.do", "", "1400,580,no");
			popupSel = "insert";
			break;
		case "po_search":
				var status = mySheet.GetCellValue(grbRow,"PAY_REG_STATUS");		
					
				if(mySheet.GetCellValue(grbRow,"ADD_USER_ID") != "<%=st_user_id%>") {
					alert("본인이 등록한 지급이슈에 대해서만 발주정보 수정이 가능합니다.")
					return;
				}
				
				if(status =="품의중" || status =="확정") {
					alert("진행상태가 신규등록 및 품의반려인 지급이슈만 정보 수정이 가능합니다.");
					return;
				}
			
			openSearchPopup("/mpso/showMasterMpSoPayRegMngUploadPoSearchPop.do", "", "900,350,no");
			break;			
		case "calendarHour":
			kepCalendarOpenPopup();
			break;
		case "changeDate":
			if(checkValid()) {				
				var pay_reg_no = mySheet.GetCellValue(arrRow[0],"PAY_REG_NO");
				var pay_reg_seq = mySheet.GetCellValue(arrRow[0],"PAY_REG_SEQ");							
				var schd_close_month = mySheet.GetCellValue(arrRow[0],"SCHD_CLOSE_MONTH");
				document.forms.masterMpSoSchdCloseMMPop.pay_reg_no.value = pay_reg_no;
				document.forms.masterMpSoSchdCloseMMPop.pay_reg_seq.value = pay_reg_seq;				
				document.forms.masterMpSoSchdCloseMMPop.schd_close_month.value = schd_close_month.replace("/","");
				openSearchPopupPost("/mpso/getMasterMpSoChangeSchdCloseMMPop.do", "masterMpSoSchdCloseMMPop", 'masterMpSoSchdCloseMMPop', "width=450,height=260,resizable=no,scrollbars=no");
				break;
			};
			
			
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7, value8){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterCmCoBuyerAgntcmpyPop1") {	// 고객사, 협력사 팝업
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	} else if (popupSel == "po_search") { // 발주정보
		mySheet.SetCellValue(grbRow,"BUYER", value1);
		mySheet.SetCellValue(grbRow,"PO_NO", value2);
		mySheet.SetCellValue(grbRow,"PO_SEQ", value3);
		mySheet.SetCellValue(grbRow,"BUYER_ITEM_NO", value4);
		mySheet.SetCellValue(grbRow,"AGENT_NAME", value5);
		mySheet.SetCellValue(grbRow,"AGENT_IRS_NO", value6);
		mySheet.SetCellValue(grbRow,"BUYER_NAME", value7);
		mySheet.SetCellValue(grbRow,"BUYER_IRS_NO", value8);
	}else if (popupSel == "masterCmCoBuyerAgntcmpyPop2") {	// 고객사, 협력사 팝업
		$("#st_agent_code").val(value2);
		$("#st_agent_name").val(value3);
	}
	
	grbRow="";	//초기화
}
//콜백함수(파일명은 모두 동일)
function setPopupCalendar(year,month,day) {
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if(popupSel == "calendarHour") { // 마감예정일
		mySheet.SetCellValue(grbRow,"SCHD_CLOSE_MONTH", year+"/"+month);
		mySheet.SetCellValue(grbRow,"SELECTED", 1);
	}

	grbRow="";	//초기화
}

//  그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	return DATA;
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	if(mySheet.RowCount() <= 0){
   		$("#pageindex").html("");
   		return;
   	} 
   	
   	var maxRow  = mySheet.RowCount();
	if(maxRow == 0){
		  return;
	}
	maxRow = mySheet.RowCount() + 1;
	for(var i=1; i<= maxRow; i++){
		if(mySheet.GetCellValue(i,"PAY_REG_STATUS") == "신규등록" || mySheet.GetCellValue(i,"PAY_REG_STATUS") == "품의반려") {
			mySheet.SetCellEditable(i, "PAY_AMT1", 1);
			mySheet.SetCellEditable(i, "PAY_AMT2", 1);
			mySheet.SetCellEditable(i, "PAY_AMT3", 1);
			mySheet.SetCellEditable(i, "TAX_AMT", 1);
			mySheet.SetCellBackColor(i, "PO_NO", "${notnullColor}");
			mySheet.SetCellBackColor(i, "BUYER_ITEM_NO", "${notnullColor}");
			mySheet.SetCellBackColor(i, "PAY_AMT1", "${notnullColor}");
			mySheet.SetCellBackColor(i, "PAY_AMT2", "${notnullColor}");
			mySheet.SetCellBackColor(i, "PAY_AMT3", "${notnullColor}");
			mySheet.SetCellBackColor(i, "TAX_AMT", "${notnullColor}");
		}
	}
   	
   	
	if (msg != "") {
		alert(msg);
	}
	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoPayRegMngList.do?page="+current_page , pagingMode );
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	var st_popup_url="";
	var st_popup_param = "";
	var st_popup_option = "";
	
	if (column == 'BUYER_ITEM_NO_IMG') { // 품목코드	
		 <%if(st_user_id.equals("KEP2259018")) { // 자금팀 김연주 프로%>						 				 
		 <%} else {%>
		 doPop("po_search");
		 <%}%>
	}
	else if (column == 'SCHD_CLOSE_MONTH_IMG') { // 마감 예정일
		doPop('calendarHour');
	}
	
	return;
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	grbAcnt = 0;
	grbBcnt = 0;
	grbCcnt = 0;
	loader_obj("N");	
	
	if ( $("#job_kind").val() == "Approval" ) { // 품의 상신
		var type = $("#job_type").val();		
		if(type == 'A') {
			gw_aprv_Atype(msg);
			
		} else if(type == 'B') {
			gw_aprv_Btype(msg);
		} else {
			alert("확정 처리하였습니다.");
		}
		
	} else {
		alert(msg);
	}
	if(!checkedSession(stCode)){return;}
	if ( msg != "저장에 실패하였습니다." ) {		
		doAction('search');
	}
	
}

function chFromDate(value1, value2){
	var st_date = $('#'+value1).val();	
	var yyyy = st_date.substr(0,4);
	var mm =  st_date.substr(5,2);
	var tToday = new Date(yyyy,eval(mm + '-' + 1));
	yyyy = tToday.getFullYear();
	mm = tToday.getMonth();
	mm = "" +mm;
	if(value2 =='1') {
		 mm =(mm.length ==1)?"0"+mm: mm;
		 if(mm == "00"){
			 mm = "12";
			 yyyy = yyyy-1;
		 }
		 $('#'+value1).val(yyyy+"/"+mm);
	}	
	if(value2 =='0') {
		var today = kepGetNowTimeStr("YYYYMM","/"); // 오늘의 년 월
		$('#'+value1).val( today);
	}
	
}

function checkValid() {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	
	// 선택된 항목 유무 체크
	if (selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return false;
	}
	if (arrRow.length > 1) {
		alert("예정월 변경은 하나씩 가능합니다.");
		return false;
	}
	
	var schd_close_month = mySheet.GetCellValue(arrRow[0],"SCHD_CLOSE_MONTH");
	var db_schd_close_month = mySheet.GetCellValue(arrRow[0],"DB_SCHD_CLOSE_MONTH");
	if (schd_close_month == db_schd_close_month) {
		alert("예정월이 변경 전과 동일합니다. ");
		return false;
	}
	
	return true;
	
}

function checkSaveValid() {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");	
	// 선택된 항목 유무 체크
	if (selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return false;
	}
	
	
	for(var i=0; i< arrRow.length; i++){	
		var cnt = 0;		
		if(mySheet.GetCellValue(arrRow[i], "PAY_REG_STATUS") == "품의중" || mySheet.GetCellValue(arrRow[i], "PAY_REG_STATUS") == "확정") {
			alert("신규등록 및 품의반려 건만 저장이 가능합니다.")
			return;
		}
		
		if(mySheet.GetCellValue(arrRow[i], "ADD_USER_ID") != "<%=st_user_id%>") {
			alert("본인이 등록한 지급이슈에 대해서만 저장 및 삭제가 가능합니다.")
			return;
		}
		var PAY_AMT1 = mySheet.GetCellValue(arrRow[i], "PAY_AMT1");			
		var PAY_AMT2 = mySheet.GetCellValue(arrRow[i], "PAY_AMT2");			
		var PAY_AMT3 = mySheet.GetCellValue(arrRow[i], "PAY_AMT3");
		var TAX_AMT = mySheet.GetCellValue(arrRow[i], "TAX_AMT");
		if(PAY_AMT1 == "" && PAY_AMT2 == "" && PAY_AMT3 == "") {
			alert("지급이슈금액을 입력하세요.");
			return;
		}
		
		if(PAY_AMT1.toString().indexOf('.') != -1 || PAY_AMT2.toString().indexOf('.') != -1 || PAY_AMT3.toString().indexOf('.') != -1 || TAX_AMT.toString().indexOf('.') != -1) {				
			alert("지급이슈금액에 소숫점은 포함할 수 없습니다.");
			return;
		}
		if(PAY_AMT1 != "") {
			cnt++;
			mySheet.SetCellValue(arrRow[i],"PAY_REG_TYPE", "A");
		}
		if(PAY_AMT2 != "") {
			cnt++;
			mySheet.SetCellValue(arrRow[i],"PAY_REG_TYPE", "B");
		}
		if(PAY_AMT3 != "") {
			mySheet.SetCellValue(arrRow[i],"PAY_REG_TYPE", "C");
			if(TAX_AMT == "") {
				alert("물류비의 경우 세액 필수 입력입니다.");
				return;
			}
			var TAX_AMT_TEMP = PAY_AMT3 * 0.1;
			if(TAX_AMT_TEMP >= TAX_AMT) {
				if(TAX_AMT_TEMP - TAX_AMT >= 10) {
					alert("물류비 확정세액이 10원 이상 차이가 발생합니다. 확정세액 확인바랍니다.");
					return;
				}
			}
			if(TAX_AMT >= TAX_AMT_TEMP) {
				if(TAX_AMT - TAX_AMT_TEMP >= 10) {
					alert("물류비 확정세액이 10원 이상 차이가 발생합니다. 확정세액 확인바랍니다.");
					return;
				}
			}
			cnt++;
		}
		if(cnt > 1) {
			alert("지급이슈금액 중 하나만 입력하세요.")
			return;
		}
		var PAY_REG_TYPE = mySheet.GetCellValue(arrRow[i], "PAY_REG_TYPE");
		if(PAY_REG_TYPE == "A") {
			mySheet.SetCellValue(arrRow[i],"PAY_AMT2","");
			mySheet.SetCellValue(arrRow[i],"PAY_AMT3","");
			mySheet.SetCellValue(arrRow[i],"TAX_AMT","");
		} else if(PAY_REG_TYPE == "B") {
			mySheet.SetCellValue(arrRow[i],"PAY_AMT1","");
			mySheet.SetCellValue(arrRow[i],"PAY_AMT3","");
			mySheet.SetCellValue(arrRow[i],"TAX_AMT","");
		} else if(PAY_REG_TYPE == "C") {
			mySheet.SetCellValue(arrRow[i],"PAY_AMT1","");
			mySheet.SetCellValue(arrRow[i],"PAY_AMT2","");
		}
	
	}
	
	
	return true;
	
}

function checkApproval() { // 선지급 : 멀티 체크 불가, 지체상급 : 동일 고객사/지급이슈 같을경우 멀티 체크 가능, 물류비의 경우 저장 버튼 클릭과 동시에 품의 완료로 저장
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	var Acnt = 0; // 선지급 카운트
	var Bcnt = 0; // 지체상금 카운트
	var Ccnt = 0; // 물류비 카운트
	
	// 선택된 항목 유무 체크
	if (selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	var buyer = mySheet.GetCellValue(arrRow[0],"BUYER");
	var agent = mySheet.GetCellValue(arrRow[0],"AGENT");
	var st_SCHD_CLOSE_MONTH = mySheet.GetCellValue(arrRow[0],"SCHD_CLOSE_MONTH");
	for(var i = 0; i < arrRow.length; i++) {
		var cnt = 0; // 동시 금액 입력 카운트
		if(mySheet.GetCellValue(arrRow[i], "PAY_REG_STATUS") == "품의중" || mySheet.GetCellValue(arrRow[i], "PAY_REG_STATUS") == "확정") {
			alert("신규등록 및 품의반려 건만 품의가 가능합니다.")
			return;
		}
		var PAY_AMT1 = mySheet.GetCellValue(arrRow[i], "PAY_AMT1");			
		var PAY_AMT2 = mySheet.GetCellValue(arrRow[i], "PAY_AMT2");			
		var PAY_AMT3 = mySheet.GetCellValue(arrRow[i], "PAY_AMT3");
		var PAY_AMT4 = mySheet.GetCellValue(arrRow[i], "PAY_AMT4");
		var TAX_AMT = mySheet.GetCellValue(arrRow[i], "TAX_AMT");
		if(PAY_AMT1 == "" && PAY_AMT2 == "" && PAY_AMT3 == "") {
			alert("지급이슈금액을 입력하세요.");
			return;
		}
		if(PAY_AMT1.toString().indexOf('.') != -1 || PAY_AMT2.toString().indexOf('.') != -1 || PAY_AMT3.toString().indexOf('.') != -1 || TAX_AMT.toString().indexOf('.') != -1) {				
			alert("지급이슈금액에 소숫점은 포함할 수 없습니다.");
			return;
		}		
		if(PAY_AMT1 != "") {
			Acnt++;
			cnt++;
			mySheet.SetCellValue(arrRow[i],"PAY_REG_TYPE", "A");
		} 
		if(PAY_AMT2 != "") {
			Bcnt++;
			cnt++;
			mySheet.SetCellValue(arrRow[i],"PAY_REG_TYPE", "B");
		}
		if(PAY_AMT3 != "") {			
			mySheet.SetCellValue(arrRow[i],"PAY_REG_TYPE", "C");
			if(TAX_AMT == "") {
				alert("물류비의 경우 세액 필수 입력입니다.");
				return;
			}
			var TAX_AMT_TEMP = PAY_AMT3 * 0.1;
			if(TAX_AMT_TEMP >= TAX_AMT) {
				if(TAX_AMT_TEMP - TAX_AMT >= 10) {
					alert("물류비 확정세액이 10원 이상 차이가 발생합니다. 확정세액 확인바랍니다.");
					return;
				}
			}
			if(TAX_AMT >= TAX_AMT_TEMP) {
				if(TAX_AMT - TAX_AMT_TEMP >= 10) {
					alert("물류비 확정세액이 10원 이상 차이가 발생합니다. 확정세액 확인바랍니다.");
					return;
				}
			}
			Ccnt++;
			cnt++;
		}
		if(PAY_AMT4 != "") {
			mySheet.SetCellValue(arrRow[i],"PAY_REG_TYPE", "D");
			alert("재고는 품의 없음");
			return;
		}
		var SCHD_CLOSE_MONTH = mySheet.GetCellValue(arrRow[i],"SCHD_CLOSE_MONTH");
		if(SCHD_CLOSE_MONTH != st_SCHD_CLOSE_MONTH) {
			alert("같은 마감 예정월의 경우만 품의가 가능합니다.");
			return;
		}
		var PAY_REG_TYPE = mySheet.GetCellValue(arrRow[i], "PAY_REG_TYPE");
		if(PAY_REG_TYPE == 'B') { // 지체상금
			var chk_buyer = mySheet.GetCellValue(arrRow[i],"BUYER");
			if(buyer != chk_buyer) {
				alert("같은 고객사인 경우만 품의가 가능합니다.");
				return;
			}
		} else if(PAY_REG_TYPE == 'A') { // 선지급금
			var chk_agent = mySheet.GetCellValue(arrRow[i],"AGENT");
			if(agent != chk_agent) {
				alert("같은 협력사인 경우만 품의가 가능합니다.");
				return;
			}
		}
			
		if(mySheet.GetCellValue(arrRow[i], "ADD_USER_ID") != "<%=st_user_id%>") {
			alert("본인이 등록한 지급이슈에 대해서만 품의가 가능합니다.")
			return;
		}
		if(cnt > 1) {
			alert("지급이슈금액 중 하나만 입력하세요.")
			return;
		}
	}	
	
	
	if(Acnt > 0 && Bcnt > 0) { // 선지급금과 지체상금 동시 발생
		alert("동시 품의 불가.");
		return;
	} else if(Acnt > 0 && Ccnt > 0) { // 선지급금과 물류비 동시 발생
		alert("동시 품의 불가.");
		return;
	} else if(Bcnt > 0 && Ccnt > 0) { // 지체상금과 물류비 동시 발생
		alert("동시 품의 불가.");
		return;
	}
	grbAcnt = Acnt;
	grbBcnt = Bcnt;
	grbCcnt = Ccnt;
	return true;
	
}

// 선지급금 품의 상신 
function gw_aprv_Atype(msg){
	alert("품의 완료하였습니다.");
	var gw_kep_no = msg;
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");	
	var arrRow     = selectedGrid.split("|");
	
	
	var AGENT_NAME = mySheet.GetCellValue(arrRow[0],"AGENT_NAME");
	var AGENT_IRS_NO = mySheet.GetCellValue(arrRow[0],"AGENT_IRS_NO");	
	var SCHD_CLOSE_MONTH = mySheet.GetCellValue(arrRow[0],"SCHD_CLOSE_MONTH");
	
	
	var bodyContents =
		"<style> .SmallTB{border:1px solid #000; font-size:12px} .SmallTB th{ height:30px; text-align:center; background-color:#e8f3f9;border-right:1px solid #000;border-bottom:1px solid #000;} .SmallTB td{ height:25px;border-bottom:1px solid #000; padding-left:5px} .SmallTbNoboder{border:0px solid #000; font-size:12px} </style>"+
		"<body>"+
		"<div style=\"text-align: left; font-weight: bold; margin-top: 20px;\">(1) 선지급 사유</div>"+
		"<table style=\"width: 650px;\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\">"+
		"<tr>"+
		"<td id=\"선지급사유\" height=\"90\" valign=\"top\" style=\"text-align:left; padding:1px; font-size: 11pt; font-family: 굴림; line-height: 150%;\" tweedittype=\"true\" controltype=\"TextArea\">"+
		"</td>"+
        "</tr>"+
		"</table>"+
	 	"<div style=\"text-align: left; font-weight: bold; margin-top: 20px;\">(2) 선지급사항</div>"+
		"<table  style=\"width: 650px;\"><colgroup><col width=\"100\" bgcolor=\"#c9e5f8\" /><col /><col /></colgroup>"+
		"<tbody>"+
		"<tr style=\" height: 25; background-color: #c9e5f8;\">"+
		"<td colspan=\"2\" width=\"25%\" style=\"font-weight: bold;\">구분</td>"+
		"<td width=\"75%\" style=\"font-weight: bold;\">내용</td>"+
		"</tr>"+
		"<tr style=\" height: 25;\"><td colspan=\"2\" style=\"font-weight: bold;\">고객사</td><td style=\"text-align: left; font-size: 11pt; font-family: 굴림; line-height: 150%; \"></td></tr>"+
		"<tr style=\" height: 25;\"><td colspan=\"2\" style=\"font-weight: bold;\">협력사</td><td style=\"text-align: left; font-size: 11pt; font-family: 굴림; line-height: 150%; \">"+AGENT_NAME+"</td></tr>"+
		"<tr style=\" height: 25;\"><td colspan=\"2\" style=\"font-weight: bold;\">협력사 사업자번호</td><td style=\"text-align: left; font-size: 11pt; font-family: 굴림; line-height: 150%; \">"+AGENT_IRS_NO+"</td></tr>"+
		"<tr style=\" height: 25;\"><td colspan=\"2\" style=\"font-weight: bold;\">마감월</td><td style=\"text-align: left; font-size: 11pt; font-family: 굴림; line-height: 150%; \">"+SCHD_CLOSE_MONTH+"</td></tr>"+
		"<tr style=\" height: 25;\"><td colspan=\"2\" style=\"font-weight: bold;\">발주번호</td><td style=\"text-align: left; font-size: 11pt; font-family: 굴림; line-height: 150%;\"></td></tr>"+
		"<tr style=\" height: 25;\"><td colspan=\"2\" style=\"font-weight: bold;\">세금계산서일자</td><td style=\"text-align: left; font-size: 11pt; font-family: 굴림; line-height: 150%;\"></td></tr>"+
		"<tr style=\" height: 25;\"><td colspan=\"2\" style=\"font-weight: bold;\">매출금액</td><td style=\"text-align: left; font-size: 11pt; font-family: 굴림; line-height: 150%;\"></td></tr>"+
		"<tr style=\" height: 25;\"><td colspan=\"2\" style=\"font-weight: bold;\">매입금액</td><td style=\"text-align: left; font-size: 11pt; font-family: 굴림; line-height: 150%;\"></td></tr>"+
		"<tr style=\" height: 25;\"><td colspan=\"2\" style=\"font-weight: bold;\">매익율</td><td style=\"text-align: left; font-size: 11pt; font-family: 굴림; line-height: 150%;\"></td></tr>"+
		"<tr style=\" height: 25;\"><td colspan=\"2\" style=\"font-weight: bold;\">선결제요청금액(VAT포함)</td><td style=\"text-align: left; font-size: 11pt; font-family: 굴림; line-height: 150%;\"></td></tr>"+
		"<tr style=\" height: 25;\"><td colspan=\"2\" style=\"font-weight: bold;\">지급요청일</td><td style=\"text-align: left; font-size: 11pt; font-family: 굴림; line-height: 150%;\"></td></tr>"+
		"<tr style=\" height: 25;\"><td colspan=\"2\" style=\"font-weight: bold;\">지급방식</td><td style=\"text-align: left; font-size: 11pt; font-family: 굴림; line-height: 150%;\"></td></tr>"+
		"<tr style=\" height: 25;\"><td rowspan=\"3\" style=\"font-weight: bold; width: 12.5%;\">선결제정보</td><td  style=\"font-weight: bold; background: #c9e5f8;\">은행명</td><td style=\"text-align: left; font-size: 11pt; font-family: 굴림; line-height: 150%;\"></td></tr>"+		
		"<tr style=\" height: 25;\"><td  style=\"font-weight: bold; background: #c9e5f8;\">예금주명</td><td style=\"text-align: left; font-size: 11pt; font-family: 굴림; line-height: 150%;\"></td></tr>"+
		"<tr style=\" height: 25;\"><td  style=\"font-weight: bold; background: #c9e5f8;\">계좌번호</td><td style=\"text-align: left; font-size: 11pt; font-family: 굴림; line-height: 150%;\"></td></tr>"+
		"<tr style=\" height: 25;\"><td colspan=\"2\" style=\"font-weight: bold;\">고객사 입금예정일</td><td style=\"text-align: left; font-size: 11pt; font-family: 굴림; line-height: 150%;\"></td></tr>"+   
		"<tr style=\" height: 25;\"><td colspan=\"2\" style=\"font-weight: bold;\">비고</td><td style=\"text-align: left; font-size: 11pt; font-family: 굴림; line-height: 150%; \"></td></tr>"+
		"</tbody></table>"+
  		"<div style=\"text-align: left; margin-top:5px; font-size:9pt\">* 첨부서류 : 세금계산서 또는 선급금 보증보험증권(신규업체:사업자등록증 및 통장사본)</div>";
		
		
	 	var form = document.createElement("form");
		form.setAttribute("method", "post");
		form.setAttribute("target", "_blank");
		form.setAttribute("action", "https://gw.koreab2b.com/jsp/kep_linkage/InQdbData.jsp");

		var hiddenField01 = document.createElement("input");
		hiddenField01.setAttribute("type", "hidden");
		hiddenField01.setAttribute("name", "DrafterCode");
		hiddenField01.setAttribute("value", <%=sessionEmpNo%>);
		form.appendChild(hiddenField01);
		var hiddenField02 = document.createElement("input");
		hiddenField02.setAttribute("type", "hidden");
		hiddenField02.setAttribute("name", "FormID");
		hiddenField02.setAttribute("value", "JHOMS160070008591000,LINK001");
		form.appendChild(hiddenField02);
		
		var hiddenField03 = document.createElement("input");
		hiddenField03.setAttribute("type", "hidden");
		hiddenField03.setAttribute("name", "LinkageKey");
		hiddenField03.setAttribute("value", "B08");
		form.appendChild(hiddenField03);
		
		var hiddenField04 = document.createElement("input");
		hiddenField04.setAttribute("type", "hidden");
		hiddenField04.setAttribute("name", "LinkageSub1");
		hiddenField04.setAttribute("value", gw_kep_no);
		form.appendChild(hiddenField04);
		
		var LinkageSub2 = document.createElement("input");
		LinkageSub2.setAttribute("type", "hidden");
		LinkageSub2.setAttribute("name", "LinkageSub2");
		LinkageSub2.setAttribute("value", "");
		form.appendChild(LinkageSub2);
		
		var LinkageSub3 = document.createElement("input");
		LinkageSub3.setAttribute("type", "hidden");
		LinkageSub3.setAttribute("name", "LinkageSub3");
		LinkageSub3.setAttribute("value", "");
		form.appendChild(LinkageSub3);
		
		var LinkageSub4 = document.createElement("input");
		LinkageSub4.setAttribute("type", "hidden");
		LinkageSub4.setAttribute("name", "LinkageSub4");
		LinkageSub4.setAttribute("value", "");
		form.appendChild(LinkageSub4);
		
		var LinkageSub5 = document.createElement("input");
		LinkageSub5.setAttribute("type", "hidden");
		LinkageSub5.setAttribute("name", "LinkageSub5");
		LinkageSub5.setAttribute("value", "");
		form.appendChild(LinkageSub5);			
		
		var hiddenField05 = document.createElement("input");
		hiddenField05.setAttribute("type", "hidden");
		hiddenField05.setAttribute("name", "SancTitle");
		hiddenField05.setAttribute("value", "선지급 요청의뢰서");
		form.appendChild(hiddenField05);
		
		var SacnBodyType = document.createElement("input");
		SacnBodyType.setAttribute("type", "hidden");
		SacnBodyType.setAttribute("name", "SacnBodyType");
		SacnBodyType.setAttribute("value", "TEXT");
		form.appendChild(SacnBodyType);	
		
		var hiddenField06 = document.createElement("input");
		hiddenField06.setAttribute("type", "hidden");
		hiddenField06.setAttribute("name", "SancBody");
		hiddenField06.setAttribute("value", bodyContents);
		form.appendChild(hiddenField06);
		
		var AttachYN = document.createElement("input");
		AttachYN.setAttribute("type", "hidden");
		AttachYN.setAttribute("name", "AttachYN");
		AttachYN.setAttribute("value", "N");
		form.appendChild(AttachYN);
		
		var AttachInfo = document.createElement("input");
		AttachInfo.setAttribute("type", "hidden");
		AttachInfo.setAttribute("name", "AttachInfo");
		AttachInfo.setAttribute("value", "");
		form.appendChild(AttachInfo);
		
		document.charset="UTF-8";
		document.body.appendChild(form);
		form.submit();
		
		// 그룹웨어 전송 후 캐릭터 셋 복원
		document.charset="utf-8";		
		doAction('search'); 
}


//지체상금 품의 상신 
function gw_aprv_Btype(msg){
	alert("품의 완료하였습니다.");
	var gw_kep_no = msg;	
		
	 	var form = document.createElement("form");
		form.setAttribute("method", "post");
		form.setAttribute("target", "_blank");
		form.setAttribute("action", "https://gw.koreab2b.com/jsp/kep_linkage/InQdbData.jsp");

		var hiddenField01 = document.createElement("input");
		hiddenField01.setAttribute("type", "hidden");
		hiddenField01.setAttribute("name", "DrafterCode");
		hiddenField01.setAttribute("value", <%=sessionEmpNo%>);
		form.appendChild(hiddenField01);
		var hiddenField02 = document.createElement("input");
		hiddenField02.setAttribute("type", "hidden");
		hiddenField02.setAttribute("name", "FormID");
		hiddenField02.setAttribute("value", "JHOMS160070008591000,LINK001");
		form.appendChild(hiddenField02);
		
		var hiddenField03 = document.createElement("input");
		hiddenField03.setAttribute("type", "hidden");
		hiddenField03.setAttribute("name", "LinkageKey");
		hiddenField03.setAttribute("value", "B09");
		form.appendChild(hiddenField03);
		
		var hiddenField04 = document.createElement("input");
		hiddenField04.setAttribute("type", "hidden");
		hiddenField04.setAttribute("name", "LinkageSub1");
		hiddenField04.setAttribute("value", gw_kep_no);
		form.appendChild(hiddenField04);
		
		var LinkageSub2 = document.createElement("input");
		LinkageSub2.setAttribute("type", "hidden");
		LinkageSub2.setAttribute("name", "LinkageSub2");
		LinkageSub2.setAttribute("value", "");
		form.appendChild(LinkageSub2);
		
		var LinkageSub3 = document.createElement("input");
		LinkageSub3.setAttribute("type", "hidden");
		LinkageSub3.setAttribute("name", "LinkageSub3");
		LinkageSub3.setAttribute("value", "");
		form.appendChild(LinkageSub3);
		
		var LinkageSub4 = document.createElement("input");
		LinkageSub4.setAttribute("type", "hidden");
		LinkageSub4.setAttribute("name", "LinkageSub4");
		LinkageSub4.setAttribute("value", "");
		form.appendChild(LinkageSub4);
		
		var LinkageSub5 = document.createElement("input");
		LinkageSub5.setAttribute("type", "hidden");
		LinkageSub5.setAttribute("name", "LinkageSub5");
		LinkageSub5.setAttribute("value", "");
		form.appendChild(LinkageSub5);			
		
		var hiddenField05 = document.createElement("input");
		hiddenField05.setAttribute("type", "hidden");
		hiddenField05.setAttribute("name", "SancTitle");
		hiddenField05.setAttribute("value", "");
		form.appendChild(hiddenField05);
		
		var SacnBodyType = document.createElement("input");
		SacnBodyType.setAttribute("type", "hidden");
		SacnBodyType.setAttribute("name", "SacnBodyType");
		SacnBodyType.setAttribute("value", "TEXT");
		form.appendChild(SacnBodyType);	
		
		var hiddenField06 = document.createElement("input");
		hiddenField06.setAttribute("type", "hidden");
		hiddenField06.setAttribute("name", "SancBody");
		hiddenField06.setAttribute("value", "");
		form.appendChild(hiddenField06);
		
		var AttachYN = document.createElement("input");
		AttachYN.setAttribute("type", "hidden");
		AttachYN.setAttribute("name", "AttachYN");
		AttachYN.setAttribute("value", "N");
		form.appendChild(AttachYN);
		
		var AttachInfo = document.createElement("input");
		AttachInfo.setAttribute("type", "hidden");
		AttachInfo.setAttribute("name", "AttachInfo");
		AttachInfo.setAttribute("value", "");
		form.appendChild(AttachInfo);
		
		document.charset="UTF-8";
		document.body.appendChild(form);
		form.submit();
		
		// 그룹웨어 전송 후 캐릭터 셋 복원
		document.charset="utf-8";		
		doAction('search'); 
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>지급이슈 등록 및 조회</h3>
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
			<input type="hidden" id="job_kind" name="job_kind" value="">
			<input type="hidden" id="job_type" name="job_type" value="">
			
			
            	<table  class="cont_t_list01" >
					<caption>지급이슈 등록 및 조회</caption>
					<colgroup>
						<col width="7%" />
						<col width="20%" />
						<col width="8%" />
						<col width="16%" />
						<col width="6%" />
						<col width="16%" />
						<col width="6%" />
                        <col width="10%" />
                        <col width="*" />
					</colgroup>
						
					<tbody>
						<tr>
							<td><font color="#FF6600">*</font>마감예정월</td>
							<td colspan="8">
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:70px; text-align:center;" >
							<span class="btn_month"><a href="javascript:chFromDate('st_from_date','1')">-1개월</a></span> 
							<span class="btn_month"><a href="javascript:chFromDate('st_from_date','0')">당월</a></span>
							</td>						
						</tr>
						<tr>
							
							<td>고객사</td>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" value="" readonly onclick="javascript:doPop('masterCmCoBuyerAgntcmpyPop1');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">								
								<a href="javascript:doPop('masterCmCoBuyerAgntcmpyPop1');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<td>사업자번호(B)</td>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_irs_no" id="st_buyer_irs_no" value="">								
							</td>
							<td>진행상태</td>	                    	
							<td>
							<select id="st_pay_reg_status" name="st_pay_reg_status" style="width:50%;"></select>														
							</td>
							<td>등록자명</td>
							<td>
								<input type="text" class="input_type_text" name="st_add_user_name" id="st_add_user_name" value="">								
							</td>
							<td></td>
						</tr>
						<tr>
							<td>협력사</td>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" value="" readonly onclick="javascript:doPop('masterCmCoBuyerAgntcmpyPop2');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:80%" value="">								
								<a href="javascript:doPop('masterCmCoBuyerAgntcmpyPop2');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<td>사업자번호(S)</td>
							<td>
								<input type="text" class="input_type_text" name="st_agent_irs_no" id="st_agent_irs_no" value="">								
							</td>
							<td>발주번호</td>
							<td>
								<input type="text" class="input_type_text" name="st_po_no" id="st_po_no" value="" style="width:80%">								
							</td>
							<td>품목코드</td>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" value="">								
							</td>
							<td>																
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="50" selected>50건</option>
					<option value="70" >70건</option>
					<option value="100" >100건</option>
				</select>
				&nbsp;&nbsp;<b>※ 물류비는 해당 고객사 협력사 기준 상계 예정 금액 입력(VAT 별도)</b>
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "450px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			<!--버튼영역-->
             <div class="btnArea">
  	          	<span class="fl" >
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀 다운로드</a></span>
  				</span>
  				<span class="fr">	  				 
	  				<span class="btn_04 mr04"><a href="javascript:doPop('changeDate');">예정월 변경</a></span>
	  				<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
	  				<span class="btn_02 mr04"><a href="javascript:doAction('delete');">삭제</a></span>
					<span class="btn_04 mr04"><a href="javascript:doPop('insert');">신규등록</a></span>
					<span class="btn_02 mr04"><a href="javascript:doAction('gwSave');">확정</a></span> 				
  				</span>
  			 </div>
  			 
  			
			<!--예정월 변경 FORM POST-->
    	<form name="masterMpSoSchdCloseMMPop" id="masterMpSoSchdCloseMMPop" method="post">
    		<input type="hidden" name="pay_reg_no" id="pay_reg_no" value="">
    		<input type="hidden" name="pay_reg_seq" id="pay_reg_seq" value="">
    		<input type="hidden" name="remark" id="remark" value="">
    		<input type="hidden" name="schd_close_month" id="schd_close_month" value="">
		</form>		
<!--내용 종료-->

</body>
</html>
