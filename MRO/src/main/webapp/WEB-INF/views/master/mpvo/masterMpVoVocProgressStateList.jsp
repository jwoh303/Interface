<%--
**********************************************
* 메뉴 : VOC 진행현황>
* 화면 : VOC 진행현황
* 기능 : 
* 프로그램 ID : PG_90_C_800_03
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-16
**********************************************
--%>
<%@page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String user_id		= CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId());
String user_name	= CommonUtil.nvl((String) request.getParameter("st_user_name"),_sessionInfo.getUserNameLoc());
String user_dept	= CommonUtil.nvl((String) request.getParameter("st_user_dept"),_sessionInfo.getDepartment());

String st_dashboard_flag = CommonUtil.nvl((String) request.getParameter("st_dashboard_flag"), "");
String st_item_gubun = CommonUtil.nvl((String) request.getParameter("st_item_gubun"), "");
String st_po_item_no = CommonUtil.nvl((String) request.getParameter("st_po_item_no"), "");
String st_lead_time = CommonUtil.nvl((String) request.getParameter("st_lead_time"), "");

// String st_sys_type = CommonUtil.nvl((String) request.getParameter("st_sys_type"), "");
String st_cd_user_id = CommonUtil.nvl((String) request.getParameter("st_cd_user_id"), "");
String st_ds_user_id = CommonUtil.nvl((String) request.getParameter("st_ds_user_id"), "");
String st_recv_flag = CommonUtil.nvl((String) request.getParameter("st_recv_flag"), "");
String st_ds_dept = CommonUtil.nvl((String) request.getParameter("st_ds_dept"), "");
String st_buyer_name = CommonUtil.nvl((String) request.getParameter("st_buyer_name"), "");
String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"), "");

if( "".equals(st_ds_user_id)){
	st_ds_user_id = user_id;
}else if( "ALL".equals(st_ds_user_id)){
	st_ds_user_id = "";
}

%>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 2};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:true,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태",				SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",Header:"선택",				SaveName:"SELECTED"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사코드",			SaveName:"BUYER"}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",				SaveName:"BUYER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"접수번호",				SaveName:"VC_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"진행상태",				SaveName:"RECV_FLAG_TEXT"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"회신요청일시",			SaveName:"PH_DATE", 			Sort:0}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청일시",				SaveName:"REQ_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주번호",				SaveName:"PO_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",				SaveName:"BUYER_ITEM_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"접수부서",				SaveName:"CD_DEPT_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"접수자",				SaveName:"CD_USER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"접수일자",				SaveName:"CD_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"처리부서",				SaveName:"DS_DEPT_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"처리자",				SaveName:"DS_USER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"처리일시",				SaveName:"DS_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"완료일자",				SaveName:"DF_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"재요청일시",			SaveName:"RE_REQ_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"재요청자",				SaveName:"RE_REQ_USER_NAME"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"차수",				SaveName:"REVISION"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"클레임등급",			SaveName:"CLAIM_GRADE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객평가",				SaveName:"RUB_TYPE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"처리 L/T",			SaveName:"LEAD_TIME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",				SaveName:"REQ_USER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자 연락처",			SaveName:"REQ_USER_TEL"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"VOC 유형 [상위분류]",	SaveName:"CLAIM_MASTER_TEXT"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"VOC 유형 [하위분류]",	SaveName:"CLAIM_TEXT"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"RECV_FLAG",			SaveName:"RECV_FLAG"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CLAIM_MASTER",		SaveName:"CLAIM_MASTER"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"DS_DATE",			SaveName:"DS_DATE"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"취소자",				SaveName:"CANCEL_USER_NAME", 	Sort:0}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"취소일시",				SaveName:"CANCEL_DATE", 		Sort:0}
					,{ Align:"Left",	Width:300,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"취소사유",				SaveName:"CANCEL_NOTE",			Sort:0,		BackColor:"${optColor}"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "VC_NO");	//접수번호
	setLinkCol(mySheet, "REVISION"); // 차수
	setLinkCol(mySheet, "BUYER_NAME"); // 고객사
	
	mySheet.SetCellFontUnderline(0, "CANCEL_NOTE", true);
	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdSearchTwoCombo('st_cd_user_id','common.masterDepartmentUserList','PG_10_M_006_00','','ALL',"<%=st_cd_user_id%>"); // 조회조건 : 접수자;
	kepAjaxCommonQueryIdSearchTwoCombo('st_ds_user_id','common.masterDepartmentUserList','PG_10_M_006_00','','ALL',""); // 조회조건 : 처리자;
	kepAjaxCommonQueryIdSearchTwoCombo('st_recv_flag','getSrsysTypeList','VC02','4','ALL','<%=st_recv_flag%>');
	kepAjaxCommonQueryIdCombo('st_ds_dept','getDeptSelectkorea2','ALL','<%=st_ds_dept%>');

	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
<% if("Y".equals(st_dashboard_flag)){ %>
	$("#st_from_date").val( kepToDateAdd("14","M",""));
<% } else {%>
	$("#st_from_date").val( kepToMonthAdd("1","M"));
<% } %>
	
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
<% if("Y".equals(st_dashboard_flag)){ %>
	doAction("search");
<% }%>
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		pagingMode = "N";
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpvo/getMasterMpVoVocProgressStateList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		
		//콤보데이터 셋팅		
		kepAjaxCommonQueryIdCombo("st_cd_user_id","getUserSelectkorea", "ALL", "<%=st_cd_user_id%>");
		kepAjaxCommonQueryIdCombo("st_ds_user_id","getUserSelectkorea", "ALL", "");
		kepAjaxCommonQueryIdSearchTwoCombo('st_recv_flag','getSrsysTypeList','VC02','4','ALL','<%=st_recv_flag%>');
		kepAjaxCommonQueryIdCombo('st_ds_dept','getDeptSelectkorea2','ALL','<%=st_ds_dept%>');
		
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		
		$("#st_buyer_code").val("");
		$("#st_buyer_name").val("");
		
		$("#st_dashboard_flag").val("");
		
		break;
	case "excelDown": // 엑셀다운로드
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	    $("#pageflag").val('0');
		var fromTo =  $("#st_from_date").val().replace(/\//gi, "") + "_" + $("#st_to_date").val().replace(/\//gi, "");
	    var param = {FileName:"VOC 진행현황_"+fromTo+".xlsx",Merge:1,SheetDesign:1,DownCols:"BUYER_NAME|VC_NO|REQ_DATE|PO_NO|BUYER_ITEM_NO|CD_DEPT_NAME|CD_USER_NAME|DS_DEPT_NAME|DS_USER_NAME|CD_DATE|DS_DATE|DF_DATE|RE_REQ_DATE|RE_REQ_USER_NAME|RECV_FLAG_TEXT|REVISION|RUB_TYPE|LEAD_TIME|REQ_USER_NAME|REQ_USER_TEL|CLAIM_MASTER_TEXT|CLAIM_TEXT"};
		kepDownExcel(document.searchCondition ,mySheet , "/mpvo/excelMasterMpVoVocProgressStateList.do", param);
		$("#pageflag").val('1');
		break;

	case "cancle": //VOC 취소
		for(var i=0; i<arrRow.length;i++){
			var st_recv_Flag = mySheet.GetCellValue(arrRow[i],"RECV_FLAG");
			if(st_recv_Flag == "FB"){
				alert("F/B 완료 된건은 취소 불가능 합니다.["+arrRow[i]+"번째]");
				mySheet.SelectCell(arrRow[i], "VC_NO");
				return;
			}
			if(st_recv_Flag == "GD"){
				alert("취소처리 된 상태입니다.["+arrRow[i]+"번째]");
				mySheet.SelectCell(arrRow[i], "CANCEL_NOTE");
				return;
			}
			var st_cancle_note = mySheet.GetCellValue(arrRow[i],"CANCEL_NOTE");
			if(st_cancle_note == ""){
				alert("취소 사유 입력바랍니다.["+arrRow[i]+"번째]");
				mySheet.SelectCell(arrRow[i], "CANCEL_NOTE");
				return;
			}
		}
		//Confirm 처리 방식.
		if(confirm("VOC 취소 처리 하시겠습니까?")){
			kepSave(document.searchCondition ,  mySheet , "/mpvo/delMasterMpVoVocProgressStateList.do" , "SELECTED" );	
		}
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

	$("#st_dashboard_flag").val("");
   	if(mySheet.RowCount() <= 0){   
   		return;
   	}else{
   		for(var i=1; i<mySheet.RowCount()+1; i++){
   			mySheet.SetCellValue(i, "CD_USER_NAME", kepMaskingName(mySheet.GetCellValue(i, "CD_USER_NAME")));
   			mySheet.SetCellValue(i, "REQ_USER_TEL", kepMaskingName(mySheet.GetCellValue(i, "REQ_USER_TEL")));
   			mySheet.SetCellValue(i, "DS_USER_NAME", kepMaskingName(mySheet.GetCellValue(i, "DS_USER_NAME")));
   			mySheet.SetCellValue(i, "REQ_USER_NAME", kepMaskingName(mySheet.GetCellValue(i, "REQ_USER_NAME")));
   			mySheet.SetCellValue(i, "RE_REQ_USER_NAME", kepMaskingName(mySheet.GetCellValue(i, "RE_REQ_USER_NAME")));
   			mySheet.SetCellValue(i, "CANCEL_USER_NAME", kepMaskingName(mySheet.GetCellValue(i, "CANCEL_USER_NAME")));
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
	pagingMode = "P";
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpvo/getMasterMpVoVocProgressStateList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "masterCmCoBuyerAgntcmpyPop": // 고객사, 협력사 팝업
			var st_sys_type = $("#st_sys_type").val();
			popupSel = "masterCmCoBuyerAgntcmpyPop";
			openSearchPopup("/cmco/showMasterCmCoBuyerAgntcmpyPop.do", "?st_com_type=B&st_sys_change_flag=N&st_sys_type="+st_sys_type, "500,500,no");
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'VC_NO') { // 접수번호
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var vc_no = mySheet.GetCellValue(Row,"VC_NO");
		var recv_flag = mySheet.GetCellValue(Row,"RECV_FLAG");
		var claim_master = mySheet.GetCellValue(Row,"CLAIM_MASTER");
		var user_id = "<%=user_id%>";
		var user_dept = "<%=user_dept%>";
		
		if(recv_flag == "FB"){
			popupSel = "masterMpVoVocProgressStateFBPop";

			openSearchPopup("/mpvo/getMasterMpVoVocProgressStateFBPop.do", "?st_buyer="+buyer+"&st_vc_no="+vc_no, "800,780,no");		// VOC 진행현황 상세 팝업
		}else{
			popupSel = "masterMpVoVocProgressStatePop";
			openSearchPopup("/mpvo/getMasterMpVoVocProgressStatePop.do", "?st_buyer="+buyer+"&st_vc_no="+vc_no+"&st_claim_master="+claim_master+"&st_user_id="+user_id+"&st_user_dept="+user_dept, "800,780,no");		// VOC 진행현황 상세 팝업
		}
	}else if (column == 'REVISION'){
		popupSel = 'masterMpVoVocHistPop';
		var vo_no = mySheet.GetCellValue(Row,"VC_NO");
		openSearchPopup("/mpvo/showMasterMpVoVocHistPop.do", "?st_vo_no="+vo_no, "1100,300,no");		// VOC 차수 상세 팝업
	}else if (column == 'BUYER_NAME'){
		popupSel = 'masterMdCtBuyerJoinAlterRequest';
		var st_buyer = mySheet.GetCellValue(Row,"BUYER");
		openSearchPopup("/mdct/showMasterMdCtBuyerJoinAlterRequestApprovalPop.do", "?com_code="+st_buyer,  "900,700,no");	// 고객사 상세팝업
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterCmCoBuyerAgntcmpyPop") {	// 고객사, 협력사 팝업
		$("#st_buyer_code").val(value2);
		$("#st_buyer_name").val(value3);
	}
	
	grbRow="";	//초기화
}

//상태가 F/B완료 외로 선택되면 처리리드타임을 전체 선택 상태로 처리
function changeLeadTimeSel(val){
	if(val != "FB"){
		document.forms[0].st_lead_time.selectedIndex = 0;
	}
}

//처리리드타임이 전체 외로 선택되면 상태를 F/B완료 선택 상태로 처리
function chageStateSel(val){
	if(val != "ALL"){
		var selectIndex = 0;

		for(i=0; i<document.forms[0].st_recv_flag.length; i++){
			if(document.forms[0].st_recv_flag[i].value == "FB"){
				selectIndex = i;
			}
		}
		document.forms[0].st_recv_flag.selectedIndex = selectIndex;
	}
}

//구매회원사 시스템타입이 변경되면 구매사 선택정보 제거
function clearBuyer(){
	document.forms[0].st_buyer_code.value = "";
	document.forms[0].st_buyer_name.value = "";
}

//담당자 selectbox 생성
function makeUserSel(){
	var dept = $("#st_ds_dept").val();
	
	if(isEmpty(dept)){
		kepAjaxCommonQueryIdCombo("st_ds_user_id","getUserSelectkorea", "ALL", "");
	}else{
		kepAjaxCommonQueryIdSearchCombo("st_ds_user_id","getUserOrderedDept", dept, "ALL", "");
	}
}
//그리드 저정 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
		doAction('search');
	}
}
// 헤더 더블클릭시 복사
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	if (checkRows.length == 0){
		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	var arrRow = checkRows.split("|");
	if (mySheet.ColSaveName(Col) == "CANCEL_NOTE"){ // 취소사유
		var value1 = mySheet.GetCellValue(arrRow[0], "CANCEL_NOTE");
		if(kepIsValueNull(value1)){
			alert("복사할 취소사유 입력 바랍니다.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "CANCEL_NOTE", value1);
		}
	}
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>VOC 진행현황</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_dashboard_flag" name="st_dashboard_flag"  value="<%=st_dashboard_flag%>">
			
            	<table  class="cont_t_list01" >
					<caption>VOC 진행현황</caption>
					<colgroup>
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
                        <col width="*" />
					</colgroup>
						
					<tbody>
						<tr>
							<td>요청일자</td>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_to_date')"></a>
								&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
							</td>
							<td>고객사</td>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:33%" value="<%=st_buyer_name%>" readonly onclick="javascript:doPop('masterCmCoBuyerAgntcmpyPop');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="<%=st_buyer_code%>">
								<input type="hidden" name="st_sys_type" id="st_sys_type" value="">
								<a href="javascript:doPop('masterCmCoBuyerAgntcmpyPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
						</tr>
						<tr> 
							<td>접수자</td>
							<td>
								<select id="st_cd_user_id" name="st_cd_user_id"></select>
							</td>
							<td>처리자</td>
							<td>
								<select id="st_ds_user_id" name="st_ds_user_id"></select>
							</td>
							<td>
								<select id="st_item_gubun" name="st_item_gubun" class="TitSelect">
					                <option <%=(st_item_gubun.equals("PO_NO")? "selected" : "")%> value="PO_NO">발주번호 </option>
					                <option <%=(st_item_gubun.equals("BUYER_ITEM_NO")? "selected" : "")%> value="BUYER_ITEM_NO">품목코드</option>
					                <option <%=(st_item_gubun.equals("VC_NO")? "selected" : "")%> value="VC_NO">접수번호</option>                
					            </select>
							</td>
							<td>
								<input type="text" class="input_type_text" id="st_po_item_no" name="st_po_item_no" style="width:80%;" value="<%=st_po_item_no %>" onkeydown="if(event.keyCode == 13) {doAction('search');}">
							</td>
						</tr>
						<tr> 
							<td>진행상태</td>
							<td>
								<select id="st_recv_flag" name="st_recv_flag" onchange="changeLeadTimeSel(this.value);"></select>
							</td>
							<td>처리부서</td>
							<td>
								<select id="st_ds_dept" name="st_ds_dept" onchange="makeUserSel();"></select>
							</td>
							<td>처리리드타임</td>
							<td>
								<select id="st_lead_time" name="st_lead_time" onchange="chageStateSel(this.value);">
									<option value="" selected>전체</option>
									<option <%=(st_lead_time.equals("1") ? "selected" : "")%> value="1">1일</option>
									<option <%=(st_lead_time.equals("2") ? "selected" : "")%> value="2">2일</option>
									<option <%=(st_lead_time.equals("3") ? "selected" : "")%> value="3">3일</option>
									<option <%=(st_lead_time.equals("4") ? "selected" : "")%> value="4">4일</option>
									<option <%=(st_lead_time.equals("5") ? "selected" : "")%> value="5">5일</option>
									<option <%=(st_lead_time.equals("6") ? "selected" : "")%> value="6">6일</option>
									<option <%=(st_lead_time.equals("7") ? "selected" : "")%> value="7">7일이상</option>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="50" selected>50건</option>
					<option value="100">100건</option>
					<option value="500">500건</option>
				</select>
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
  					<span class="btn_04 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  	          	<span class="fr">
  					<span class="btn_04 mr04"><a href="javascript:doAction('cancle');">VOC 취소</a></span>
  				</span>
  			 </div>
</body>
</html>
