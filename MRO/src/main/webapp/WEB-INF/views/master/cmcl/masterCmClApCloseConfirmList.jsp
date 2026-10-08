<%--
**********************************************
* 메뉴 : 마감관리 > 마감현황 > 확정마감 > 월별 마감확정내역(매입)
* 화면 : 월별 마감확정내역(매입)
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<script src="/resources/js/common.js"></script>
<script>
<%
	
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	
	String user_id = "";
	String user_dept = "";
	if (sessionInfo != null){ 
		user_id =  CommonUtil.nvl((String) sessionInfo.getUserId());
		user_dept =  CommonUtil.nvl((String)sessionInfo.getDepartment()); 
	}
	
	boolean getRoleYn = CommonUtil.getCodeCheckReturn("CMRD", user_id);
	
%>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";


// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,		Edit:true,	EditLen:30,		Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"사이트구분",		SaveName:"SITE"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"사업팀코드",			SaveName:"KEP_DEPT"}
		,{ Align:"Center",	Width:110,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"사업팀명",			SaveName:"KEP_DEPT_NAME"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"운영담당자사번",		SaveName:"PM_LEGACY_USER_ID"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"운영담당자",		SaveName:"PM_USER_NAME"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"제출담당자",			SaveName:"CONFIRM_USER_NAME"}
		,{ Align:"Center",	Width:120,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"사업자등록번호",		SaveName:"TAX_IRS_NO"}
		,{ Align:"Left",	Width:190,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"협력사명",			SaveName:"AGENT_NAME"}
		,{ Align:"Left",	Width:180,		Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"협력사코드",			SaveName:"AGENT_CODE"}
		,{ Align:"Left",	Width:190,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"고객사명",			SaveName:"BUYER_NAME"}
		,{ Align:"Left",	Width:90,		Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"고객사코드",			SaveName:"BUYER_CODE"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"매입구분",			SaveName:"AP_TYPE"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"매입구분",			SaveName:"AP_TYPE_TEXT"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"마감월",			SaveName:"AP_CLOSE_MONTH"}
		,{ Align:"Right",	Width:100,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		Header:"전월재고",			SaveName:"LAST_MONTH_STOCK_AMT", Format:"${priceFormat}"}
		,{ Align:"Right",	Width:100,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		Header:"당월매출원가",		SaveName:"THIS_MONTH_SELL_AMT", Format:"${priceFormat}"}
		,{ Align:"Right",	Width:100,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		Header:"당월매입",			SaveName:"THIS_MONTH_BUY_AMT", Format:"${priceFormat}"}
		,{ Align:"Right",	Width:100,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		Header:"이월재고",			SaveName:"THIS_MONTH_STOCK_AMT", Format:"${priceFormat}"}
		,{ Align:"Center",	Width:150,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"세금계산서번호",			SaveName:"TAX_BILL_NO"}
		,{ Align:"Center",	Width:150,		Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"세금계산서번호",			SaveName:"RE_TAX_BILL_NO"}		
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"세무구분",			SaveName:"TAX_TYPE_TEXT"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"제출담당자사번",			SaveName:"CONFIRM_LEGACY_USER_ID"}		
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"생성일",			SaveName:"ADD_DATE"}		
		,{ Align:"Center",	Width:100,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"회계전송여부",			SaveName:"ERP_SEND_YN"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"회계전송일시",			SaveName:"ERP_SEND_DATE"}
		
	];
	

	IBS_InitSheet(mySheet, initsheet, pagingMode);	
	mySheet.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	
	// 초기화 설정
	resetValue();
}

// 초기화 설정
function resetValue() {
	//조회조건 일자 초기화
	kepSetCalenderYearMonth("st_from_date");
	// 조회조건 일자 설정
	$("#st_from_date").val(kepGetNowTimeStr('YYYYMM', '/'));
	$("#st_irs_no").val("");
	$("#st_agent_code").val("");
	$("#st_agent_name").val("");
	$("#st_user_name").val("");
	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_user_dept_cd','master.mdcd.selectMasterMdCdBuyerCardManageDeptList99','ALL', 'ALL');
	//매출구분 셋팅
	kepAjaxCommonComboDataValue('st_ap_type','APCL01','ALL');
	
}


var st;
var mt;

// 그리드 표시후 처리
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if ( str !="search" && str !="excelDown" && str !="reload" && str !="stckAdd" &&  selectedGrid.length == 0 ) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	switch (str) {
		case "search": // 조회			
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/cmcl/getMasterCmClApCloseConfirmList.do" , pagingMode );
			break;
	
		case "reload": // 초기화			
			resetValue();
			mySheet.RemoveAll();			
			break;   
		
		case "send": // 회계전송			
			$("#job_kind").val("send");		
			if(checkSend()) {
				if (!confirm('선택한 항목의 동일한 세금계산서번호는 일괄 회계전송됩니다.\n 회계전송 하시겠습니까?')) {
					return;
				}
				kepSave(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClApCloseConfirmList.do" , "SELECTED" );
			}
			break;
			
		case "submit": // 추가제출			
			$("#job_kind").val("submit");
			if(arrRow.length > 1) {
				alert("하나만 선택하여 추가제출 바랍니다.");
				return;
			}
			if(mySheet.GetCellValue(arrRow[0], "TAX_BILL_NO").startsWith("ST")) {
				alert("재고 생성 건은 추가제출 처리 불가합니다.")
				return;
			}
			if (!confirm('추가제출 처리하겠습니까?')) {
				return;
			}
			kepSave(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClApCloseConfirmList.do" , "SELECTED" );			
			break;		
		
		case "cancle": // 제출취소			
			$("#job_kind").val("cancle");
			if(checkCancle()) {
				if (!confirm('선택한 항목의 동일한 세금계산서번호는 일괄 제출취소됩니다.\n 제출취소 하시겠습니까?')) {
					return;
				}
				kepSave(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClApCloseConfirmList.do" , "SELECTED" );
			}
			break;		
		
		case "excelDown": // 엑셀다운로드			
			var param = {FileName:"월별 마감확정내역(매입).xlsx",DownCols:"SITE|KEP_DEPT_NAME|PM_USER_NAME|CONFIRM_USER_NAME|TAX_IRS_NO|AGENT_NAME|BUYER_NAME|AP_TYPE_TEXT|LAST_MONTH_STOCK_AMT|THIS_MONTH_SELL_AMT|THIS_MONTH_BUY_AMT|THIS_MONTH_STOCK_AMT|TAX_BILL_NO|TAX_TYPE_TEXT|ERP_SEND_YN"};
			kepDownExcel(document.searchCondition ,mySheet , "/cmcl/excelMasterCmClApCloseConfirmList.do", param);
			break;
		case "save":	 // 저장
			$("#job_kind").val("save");
			if(checkSaveValid()) {
				if (!confirm('선택한 항목을 저장 하시겠습니까?')) {
					return;
				}
				kepSave(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClApCloseConfirmList.do" , "SELECTED" );
			}			
			break;
		
		case "stckAdd":	 // 재고생성
			$("#job_kind").val("stckAdd");
			
			if (!confirm('재고 생성하시겠습니까?(조회 마감월 기준)')) {
				return;
			}
			kepSaveAll(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClApCloseConfirmList.do");						
			break;
			
			

	}

}

//팝업함수호출
function doPop(str, params) {
	popupSel = str;

	switch (str) {			
		case "masterCmCoBuyerAgntcmpyPop2": // 협력사 팝업
			openSearchPopup("/cmco/showMasterCmCoBuyerAgntcmpyPop.do", "?st_com_type=S&st_sys_change_flag=N&st_sys_type=KA", "500,500,no");
			popupSel = "masterCmCoBuyerAgntcmpyPop2";
			break;
			
		case "confirmList": // 제출확인
			openSearchPopup("/cmcl/showMasterCmClArCloseConfirmPop.do", "?st_from_date="+$("#st_from_date").val()+"&st_type=AP", "900,850,no");
			break;
			
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3) {

	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "submitList") {	// 단일 제출확인
		
	} else if (popupSel == "masterCmCoBuyerAgntcmpyPop2") {	// 고객사, 협력사 팝업
		$("#st_agent_code").val(value2);
		$("#st_agent_name").val(value3);
	}	

	grbRow="";	//초기화
}

function  kepAjaxError(pMethod , response) {
	
} 
function kepAjaxSuccess(pMethod , response){
	
}
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if ( msg != "" ) {
		alert(msg);
	}
	var maxRow  = mySheet.RowCount();
	if(maxRow == 0){
		  return;
	}
	maxRow = mySheet.RowCount() + 1;
	for(var i=1; i<= maxRow; i++){
		if(mySheet.GetCellValue(i,"AP_TYPE_TEXT") == "재고") {
			mySheet.SetCellEditable(i, "LAST_MONTH_STOCK_AMT", 1);
			mySheet.SetCellEditable(i, "THIS_MONTH_SELL_AMT", 1);
			mySheet.SetCellEditable(i, "THIS_MONTH_BUY_AMT", 1);
			mySheet.SetCellEditable(i, "THIS_MONTH_STOCK_AMT", 1);
			mySheet.SetCellBackColor(i, "LAST_MONTH_STOCK_AMT", "${notnullColor}");
			mySheet.SetCellBackColor(i, "THIS_MONTH_SELL_AMT", "${notnullColor}");
			mySheet.SetCellBackColor(i, "THIS_MONTH_BUY_AMT", "${notnullColor}");
			mySheet.SetCellBackColor(i, "THIS_MONTH_STOCK_AMT", "${notnullColor}");			
		}
	}
	
	setSumAmt();
	
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if ( msg != "" ) {
		alert(msg);
	}

	if ( code > 0 ) {
		//저장 성공시 재조회
		doAction('search');
	}
}


// 그리드 셀 변경 이벤트
function mySheet_OnChange(Row, Col, Value) {
// 	alert("[OnChange]]Row / Col / Value => " + Row + " / " + Col + " / " + Value);
	var column = mySheet.ColSaveName(Col);

	if ( column == "TAX_TYPE_TEXT" ) {
	}
	
	
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
// 	alert("[OnClick] Row / Col / Value => " + Row + " / " + Col + " / " + Value);

	if ( Row < 1 ) return;

	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if ( column == 'TAX_BILL_NO' ) {
	
	} 
}

// 헤더 더블클릭 이벤트
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	
	if ( checkRows.length == 0 ) {
// 		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	
	var arrRow = checkRows.split("|");
	
	if ( mySheet.ColSaveName(Col) == "ISSUE_DATE" ) { 
		
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

function checkSaveValid() {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");	
	// 선택된 항목 유무 체크
	if (selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return false;
	}
	
	
	for(var i=0; i< arrRow.length; i++){	
			
		if(mySheet.GetCellValue(arrRow[i], "AP_TYPE_TEXT") != "재고") {
			alert("매입구분 재고에 대해서만 저장이 가능합니다.")
			return;
		}
	}
	
	
	return true;
	
}

function checkSend() { // 회계전송 된 건에 대해서는 회계전송 불가
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	
	// 선택된 항목 유무 체크
	if (selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	
	for(var i = 0; i < arrRow.length; i++) {
		if(mySheet.GetCellValue(arrRow[i], "ERP_SEND_YN") == "Y") {
			alert("이미 회계전송된 건입니다.")
			return;
		}
		if(mySheet.GetCellValue(arrRow[i], "TAX_BILL_NO").startsWith("ST")) {
			alert("재고 생성 건은 회계전송 처리 불가합니다.")
			return;
		}
	}
	
	
	return true;
	
}

function checkCancle() { // 회계전송 된 건에 대해서는 제출취소 불가
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	
	// 선택된 항목 유무 체크
	if (selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	
	for(var i = 0; i < arrRow.length; i++) {
		if(mySheet.GetCellValue(arrRow[i], "ERP_SEND_YN") == "Y") {
			alert("회계전송 된 건에 대해서는 제출취소할 수 없습니다.")
			return;
		}
		if(mySheet.GetCellValue(arrRow[i], "TAX_BILL_NO").startsWith("ST")) {
			alert("재고 생성 건은 제출취소 처리 불가합니다.\n삭제 요청은 DX팀 문의바랍니다.")
			return;
		}
	}
	
	
	return true;
	
}

//금액정보 설정
function setSumAmt() {
	var TotLastStockAmt = 0 ;
	var TotThisSellAmt = 0;
	var TotThisBuyAmt = 0;
	var TotThisStockAmt = 0;
	for( var i = 1; i <= mySheet.RowCount(); i++ ) {		
		TotLastStockAmt = TotLastStockAmt + Number( kepFilterNum( String( mySheet.GetCellValue(i, "LAST_MONTH_STOCK_AMT") ) ) );
		TotThisSellAmt = TotThisSellAmt + Number( kepFilterNum( String( mySheet.GetCellValue(i, "THIS_MONTH_SELL_AMT") ) ) );
		TotThisBuyAmt = TotThisBuyAmt + Number( kepFilterNum( String( mySheet.GetCellValue(i, "THIS_MONTH_BUY_AMT") ) ) );
		TotThisStockAmt = TotThisStockAmt + Number( kepFilterNum( String( mySheet.GetCellValue(i, "THIS_MONTH_STOCK_AMT") ) ) );
    }

	$("#TotLastStockAmt").html( kepCommaNum(TotLastStockAmt) );
	$("#TotThisSellAmt").html( kepCommaNum(TotThisSellAmt) );
	$("#TotThisBuyAmt").html( kepCommaNum(TotThisBuyAmt) );
	$("#TotThisStockAmt").html( kepCommaNum(TotThisStockAmt) );
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>월별 마감확정내역(매입)</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>		    
   		</div>
        
		<form name="processForm" id="processForm" method="post">	
			<input type="hidden" id="st_ca_id" name="st_ca_id"  value="">
			<input type="hidden" id="st_error_code" name="st_error_code"  value="">
			<input type="hidden" id="st_error_msg" name="st_error_msg"  value="">
			<input type="hidden" id="st_s_user_id" name="st_s_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="param1" name="param1"  value="">
			<input type="hidden" id="param2" name="param2"  value="">
			<input type="hidden" id="param3" name="param3"  value="">
			<input type="hidden" id="param4" name="param4"  value="">
			<input type="hidden" id="param5" name="param5"  value="">
			<input type="hidden" id="_authtoken" name="_authtoken"  value="">  
		</form>
		<!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<input type="hidden" name="st_send_gbn"  id="st_send_gbn" value ="">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_dept_code" name="st_dept_code"  value="${sessionInfo.department}">
			<input type="hidden" id="job_kind" name="job_kind" value="">
			<input type="hidden" id="job_type" name="job_type" value="">
			<input type="hidden" id="st_totAmt" name="st_totAmt"  value="0">

            	<table  class="cont_t_list01" >
					<caption>월별 마감확정내역(매입)</caption>
					<colgroup>
						<col width="6%" />
						<col width="16%" />
						<col width="7%" />
						<col width="10%" />
						<col width="9%" />
                        <col width="19%" />
						<col width="9%" />
                        <col width="*%" />
					</colgroup>

					<tbody>
						<tr>
							<td><font color="#FF6600">*</font>마감월</td>
							<td colspan="7">
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:70px; text-align:center;" >
							<span class="btn_month"><a href="javascript:chFromDate('st_from_date','1')">-1개월</a></span> 
							<span class="btn_month"><a href="javascript:chFromDate('st_from_date','0')">당월</a></span>
							</td>						
						</tr>
						<tr>
							<th>사업팀</th>
							<td>
								<select style="width: 70%;" name = "st_user_dept_cd" id="st_user_dept_cd"></select>							
							</td>
							<th>매입구분</th>
							<td>
								<select id="st_ap_type" name="st_ap_type" style="width:80%;"></select>
							</td>
							<th>협력사</th>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" value="" readonly onclick="javascript:doPop('masterCmCoBuyerAgntcmpyPop2');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:80%" value="">								
								<a href="javascript:doPop('masterCmCoBuyerAgntcmpyPop2');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<th>사업자등록번호</th>
							<td>
								<input type="text" class="input_type_text" name="st_irs_no" id="st_irs_no" value="">
							</td>
						</tr>
						<tr>
							<th>담당자명</th>
							<td>
								<input type="text" class="input_type_text" name="st_user_name" id="st_user_name" style="width:85%;" value="" onkeydown="kepEnter()">
							</td>
							
							<td>회계전송여부</td>
							<td>
								<select style="width: 50%;" name = "st_erp_send_yn" id="st_erp_send_yn">
									<option value='ALL' selected>전체</option>
									<option value='Y'>Y</option>
									<option value='N'>N</option>
								</select>
							</td>							
							<th>세금계산서번호</th>
							<td>
								<input type="text" class="input_type_text" name="st_tax_bill_no" id="st_tax_bill_no" style="width:85%;" value="" onkeydown="kepEnter()">
							</td>	
							<td></td>
							<td></td>							
						</tr>						
					</tbody>
				</table>
            </div>
		</form>

      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "454px");
			</script>
		</div>
		
		<!--금액영역-->
		<div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" border="1" bgcolor="#FFFFFF">
				<tr>
					<td height="35" align="right" style="font-weight:bold" align="center">
						&nbsp;
					</td>
					<td height="35" align="right" style="font-weight:bold" align="center">
						총 전월재고:<span id="TotLastStockAmt" style="font-weight:bold; color:orange;">0</span>원&nbsp;&nbsp;&nbsp;
						총 당월매출원가:<span id="TotThisSellAmt" style="font-weight:bold; color:orange;">0</span>원&nbsp;&nbsp;&nbsp;
						총 당월매입:<span id="TotThisBuyAmt" style="font-weight:bold; color:orange;">0</span>원&nbsp;&nbsp;&nbsp;
						총 이월재고:<span id="TotThisStockAmt" style="font-weight:bold; color:orange;">0</span>원 
					</td>
				</tr>
			</table>
		</div>
		
		<!--버튼영역-->
		<div class="btnArea">
			<span class="fl">
				<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
				<span class="btn_04 mr04"><a href="javascript:doPop('confirmList');">제출확인</a></span>
				<% if (getRoleYn == true) { %>
					<span class="btn_04 mr04"><a href="javascript:doAction('stckAdd');">재고생성</a></span>
				<%} %>
			</span>

			<span class="fr">
			<% if (getRoleYn == true) { %>
				<span class="btn_04 mr04"><a href="javascript:doAction('submit');">추가제출</a></span>	
				<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
				<span class="btn_04 mr04"><a href="javascript:doAction('cancle');">제출취소</a></span>				
				<span class="btn_04 mr04"><a href="javascript:doAction('send');">회계전송</a></span>
			<%} %>				
			</span>
		</div>

<!--내용 종료-->
</body>
</html>
