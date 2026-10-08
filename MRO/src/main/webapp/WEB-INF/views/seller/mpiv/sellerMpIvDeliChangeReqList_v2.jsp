<%--
**********************************************
* 메뉴 : 납품이슈현황
* 화면 : 납품이슈현황
* 기능 : 수주거부요청,거래유형 변경요청,납품예정일 변경요청,수주접수 초기화요청 등에 대한 진행사항 확인
* 프로그램 ID : BU0701001
* 담당자 : 최찬규
* 착수일 : 2025-11-03
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
 </head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	String menuId = (String) request.getParameter("menuId");
	String user_id      = _sessionInfo.getUserId();
	String com_code 	= _sessionInfo.getComCode();
	
	if(myMenuListHeader != null){ //null이 아닌 경우에만 체크
		for(int i = 0; i<myMenuListHeader.size(); i++){
			if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
				myMenuFlag = true;
				break;
			}
		}
	}
%> 

<script type="text/javascript">
var today = kepGetNowTimeStr("YYYYMMDD","");
//var fromDate = kepToDateAdd("7","M","noslash");
//var toDate = kepToDateAdd("7","P","noslash");

var mySheet0 = new ibsheetObject();
var mySheet1 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var currIndex=0;
var Sheet;
//최초 화면 함수 
function kep_onload_view(){
	Sheet = mySheet0; //첫화면에선 mySheet0;
	
	//초기 날짜 셋팅
	var indexLength = $("input[name=st_from_date]").length;
	for(var i = 0; i<indexLength; i++){
		if($("input[name=st_from_date]").eq(i).val() ==  ""){
			$("input[name=st_from_date]").eq(i).val(kepToMonthAdd("3","M"));
			$("input[name=st_to_date]").eq(i).val(kepGetNowTimeStr('YYYYMMDD','/'));
		}
	}
	
	
	var initsheet0 = {};
	initsheet0.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet0.Cols = [
						{ Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
						,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"ADD_DATE",			Header:"요청일",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"TYPE",				Header:"TYPE",				Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Left",	SaveName:"TYPE_TEXT",			Header:"요청사항",				Type:"Text",		FontColor:"#3a72c7", Cursor:"Pointer",Width:130,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"STATUS",				Header:"STATUS",			Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"STATUS_TEXT",			Header:"진행상태",				Type:"Text",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"PO_NO",				Header:"발주번호",				Type:"Text",		FontColor:"#3a72c7", Cursor:"Pointer", Width:100,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",				Type:"Text", FontColor:"#3a72c7", Cursor:"Pointer",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"BUYER",				Header:"고객사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
						,{ Align:"Center",	SaveName:"BUYER2",				Header:"BUYER2",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
						,{ Align:"Left",	SaveName:"AGENT_REMARK",		Header:"상세사유",				Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"KEP_REMARK",			Header:"KeP 처리 내용",			Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"DESC_REMARK",			Header:"품목정보",				Type:"Text",		Width:240,	Edit:false,	EditLen:100,	Hidden:false}
						
						
						,{ Align:"Center",	SaveName:"PO_STATUS",			Header:"PO_STATUS",		Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"SEQ",					Header:"SEQ",			Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"PO_SEQ",				Header:"PO_SEQ",		Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"DS_SEQ",				Header:"DS_SEQ",		Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"AGENT",				Header:"AGENT",			Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
	];
	
	var initsheet1 = {};
	initsheet1.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet1.Cols = [
						{ Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
						,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"B_REQ_DATE",			Header:"요청일",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"WMRE_NO",				Header:"요청번호",				Type:"Text", FontColor:"#3a72c7", Cursor:"Pointer",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"FLAG_NAME",			Header:"진행상태",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"WMRE_TYPE_NAME",		Header:"요청유형",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"WMRE_TYPE",			Header:"요청유형",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",				Type:"Text", FontColor:"#3a72c7", Cursor:"Pointer",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"BUYER",				Header:"고객사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
						,{ Align:"Center",	SaveName:"PO_NO",				Header:"발주번호",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"BUYER2",				Header:"BUYER2",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
						,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"REC_STATUS_BUTTON",	Header:"접수",				Type:"Image",		Cursor:"Pointer",Width:100,	Edit:false,	EditLen:100,	Hidden:false,BackColor:"${optColor}"}
						,{ Align:"Center",	SaveName:"GR_STATUS_BUTTON",	Header:"입고",				Type:"Image",		Cursor:"Pointer",Width:100,	Edit:false,	EditLen:100,	Hidden:false,BackColor:"${optColor}"}
						,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"품목명",				Type:"Text",		Width:220,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",				Type:"Text",		Width:220,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Right",	SaveName:"WMRE_QTY",			Header:"요청수량",				Type:"Float",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
						
						,{ Align:"Center",	SaveName:"S_REC_DATE",			Header:"S_REC_DATE",		Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"M_REC_DATE",			Header:"M_REC_DATE",		Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"S_GR_DATE",			Header:"S_GR_DATE",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"FLAG",				Header:"FLAG",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"PROCESS_TYPE",		Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"ITEM_QTY",			Header:"ITEM_QTY",			Type:"Float",		Width:150,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"PROCESS_TYPE_NM",		Header:"PROCESS_TYPE_NM",	Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true}
						
						
// 						,{ Align:"Center",	SaveName:"FLAG",				Header:"FLAG",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true}
// 						,{ Align:"Center",	SaveName:"FLAG",				Header:"FLAG",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true}
// 						,{ Align:"Center",	SaveName:"FLAG",				Header:"FLAG",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true}
						
						
	];

	IBS_InitSheet(mySheet0, initsheet0, pagingMode);
	IBS_InitSheet(mySheet1, initsheet1, pagingMode);
	
	mySheet0.SetHighlightAfterSort(2);
	mySheet1.SetHighlightAfterSort(2);
	
	mySheet0.SetCountFormat(" 총  ROWCOUNT 건 ");
	mySheet1.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet0.SetHeaderBackColor("#f2f7ff");
	mySheet1.SetHeaderBackColor("#f2f7ff");
	
	mySheet0.SetTheme("DB", "DeepBlue");
	mySheet1.SetTheme("DB", "DeepBlue");
	
	doAction('search');
}
//조회 후처리
function mySheet0_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
//조회 후처리
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
//그리드 셀클릭 이벤트
function mySheet0_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_buyer = Sheet.GetCellValue(Row, "BUYER");
	var st_buyer2 = Sheet.GetCellValue(Row, "BUYER2");
	var st_po_no = Sheet.GetCellValue(Row, "PO_NO");
	var st_po_status = Sheet.GetCellValue(Row,"PO_STATUS");
	var st_type = Sheet.GetCellValue(Row,"TYPE");
	var st_po_seq = Sheet.GetCellValue(Row,"PO_SEQ");
	var st_ds_seq = Sheet.GetCellValue(Row,"DS_SEQ");
	var st_seq = Sheet.GetCellValue(Row,"SEQ");
	var st_agent = Sheet.GetCellValue(Row,"AGENT");
	
	if(column == "BUYER_NAME"){
		var src = "/common/agentInfoDisplayPop.do?st_com_code="+st_buyer2; 
		openLayerPop(src,"825px","700px");
		
// 		openSearchPopup("/common/agentInfoDisplayPop.do", '?st_com_code='+st_buyer2, "825,700,no");
	}
	if(column == "PO_NO"){
		var src = "/mpiv/commonMpIvOrderInfoPop_v2.do?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status="+st_po_status; 
		openLayerPop(src,"1240px","800px");
		
// 		openSearchPopup("/mpiv/commonMpIvOrderInfoPop_v2.do", "?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status="+st_po_status, "1240,770,no");
	}
	if(column == "TYPE_TEXT"){ //요청사항
		var src = "/mpiv/showSellerMpIvDeliChangeReqDetailPop_v2.do?value1="+st_type+"&value2="+st_buyer+"&value3="+st_po_no+"&value4="+st_po_seq+"&value5="+st_ds_seq+"&value6="+st_seq+"&value7="+st_agent; 
		if(st_type != "D"){ //거래유형 변경은 사이즈 작게(품목정보가 없음);
			openLayerPop(src,"640px","480px");
			
// 			openSearchPopup("/mpiv/showSellerMpIvDeliChangeReqDetailPop_v2.do", "?value1="+st_type+"&value2="+st_buyer+"&value3="+st_po_no+"&value4="+st_po_seq+"&value5="+st_ds_seq+"&value6="+st_seq+"&value7="+st_agent, "640,480,no");
		}else{
			openLayerPop(src,"640px","300px");
			
// 			openSearchPopup("/mpiv/showSellerMpIvDeliChangeReqDetailPop_v2.do", "?value1="+st_type+"&value2="+st_buyer+"&value3="+st_po_no+"&value4="+st_po_seq+"&value5="+st_ds_seq+"&value6="+st_seq+"&value7="+st_agent, "640,300,no");
		}
	}
	return;
} 
//그리드 셀클릭 이벤트
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_buyer = Sheet.GetCellValue(Row,"BUYER");
	var st_m_rec_date = Sheet.GetCellValue(Row,"M_REC_DATE");
	var st_wmre_type = Sheet.GetCellValue(Row,"WMRE_TYPE");
	var st_s_rec_date = Sheet.GetCellValue(Row,"S_REC_DATE");
	var st_flag = Sheet.GetCellValue(Row,"FLAG");
	var st_process_type = Sheet.GetCellValue(Row,"PROCESS_TYPE");
	var st_process_type_nm = Sheet.GetCellValue(Row,"PROCESS_TYPE_NM");
	var st_wmre_type_name = Sheet.GetCellValue(Row,"WMRE_TYPE_NAME");
	var st_wmre_no = Sheet.GetCellValue(Row,"WMRE_NO");
	var st_item_qty = Sheet.GetCellValue(Row,"ITEM_QTY");
	
	if(column == "REC_STATUS_BUTTON"){
		if(st_m_rec_date != "" && st_wmre_type != '09' && st_flag == '02'){
			var src = "/wmre/showMasterWmReReturnEntryPopForUpdateSeller_v2.do?st_WMRE_NO="+st_wmre_no; 
			openLayerPop(src,"1260px","800px");
			
// 			openSearchPopup('/wmre/showMasterWmReReturnEntryPopForUpdateSeller_v2.do', '?st_WMRE_NO='+st_wmre_no,'1260,800,no');
		}
	}
	if(column == "GR_STATUS_BUTTON"){
		if(st_s_rec_date != "" && st_wmre_type != '09' && st_flag == '03'){
			var src = "/wmre/showMasterWmReReturnEntryPopForUpdateSeller_v2.do?st_WMRE_NO="+st_wmre_no; 
			openLayerPop(src,"1260px","800px");
// 			openSearchPopup('/wmre/showMasterWmReReturnEntryPopForUpdateSeller_v2.do', '?st_WMRE_NO='+st_wmre_no,'1260,800,no');
		}
	}
	if(column == "WMRE_NO"){ //요청번호 눌러서 가는 경우 view만 되도록
		var src = "/wmre/showMasterWmReReturnEntryPopForUpdateSeller_v2.do?st_WMRE_NO="+st_wmre_no+"&viewType=R"; 
		openLayerPop(src,"1260px","800px");
// 		openSearchPopup('/wmre/showMasterWmReReturnEntryPopForUpdateSeller_v2.do', '?st_WMRE_NO='+st_wmre_no+'&viewType=R','1260,800,no');
	}
	if(column == "BUYER_NAME"){
		var src = "/common/agentInfoDisplayPop.do?st_com_code="+st_buyer; 
		openLayerPop(src,"825px","700px");
// 		openSearchPopup("/common/agentInfoDisplayPop.do", '?st_com_code='+st_buyer, "825,700,no");
	}
	return;
} 
function doAction(str) {
	switch (str) {
		case "search":	 //조회
			if (kep_dateSearchCheck($("#st_from_date_"+currIndex).val(),$("#st_to_date_"+currIndex).val()) == false) return;
			var diff = kepGetDateDiff('st_from_date_'+currIndex,'st_to_date_'+currIndex,'D');
			if (eval(diff)>372){
// 				alert("1년 이내 조회만 가능합니다.");
				var text = "1년 이내 조회만 가능합니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
		
			if(currIndex == 0){
				kepSearch(document.searchCondition0, Sheet, "/mpiv/getSellerMpIvDeliChangeReqList_v2.do" , pagingMode);
			}else if(currIndex == 1){
				kepSearch(document.searchCondition1, Sheet, "/wmre/getMasterWmReReturnProgressStateList_v2.do" , pagingMode);
			}
			break;
			
		case "reload":	//초기화
			kepReload_v2('searchCondition'+currIndex);
			kepMonth_v2('st_from_date_'+currIndex,'st_to_date_'+currIndex,'3');
			Sheet.RemoveAll();
			
			// hidden값은 공통에서 처리안됨.
			$("#st_buyer_code_"+currIndex).val("");
			break;

		case "cancel":	// 요청취소
			setRequestCancel();
			break;	
	}
}

// 요청취소
function setRequestCancel(){
	var query   = "";
	
	var buyer			= "";
	var po_no			= "";
	var po_seq			= "";
	var ds_seq			= "";
	var seq				= "";
	var agent			= "";
	
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	if(checkRows.length == 0){
// 		alert("선택된 항목이 없습니다.");
		var text = "선택된 항목이 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	for(var idx = 0; idx<arrRow.length; idx++){
		buyer           = Sheet.GetCellValue(arrRow[idx],"BUYER");
		po_no           = Sheet.GetCellValue(arrRow[idx],"PO_NO");
		po_seq          = Sheet.GetCellValue(arrRow[idx],"PO_SEQ");
		ds_seq			= Sheet.GetCellValue(arrRow[idx],"DS_SEQ");
		seq				= Sheet.GetCellValue(arrRow[idx],"SEQ");
		agent			= Sheet.GetCellValue(arrRow[idx],"AGENT");
		status			= Sheet.GetCellValue(arrRow[idx],"STATUS");
		
		if(status != "S"){
// 			alert("요청 상태건만 취소 가능합니다.");
			var text = "요청 상태건만 취소 가능합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		query +=  buyer			+ "@@";
		query +=  po_no			+ "@@";
		query +=  po_seq		+ "@@";
		query +=  ds_seq		+ "@@";
		query +=  seq			+ "@@";
		query +=  agent			+ "@@";
		query +=  "^||^" ;
	}
	document.searchCondition0.st_query0.value = query;
	
	
// 	if(!confirm("요청취소 하시겠습니까?")) return;
	var text = "요청취소 하시겠습니까?";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:saveSellerMpIvDeliChangeReqCancel(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "110px";
	var but2widthC = "110px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);

	
// 	kepAjaxFormCall("/mpiv/saveSellerMpIvDeliChangeReqCancel.do","searchCondition0","btnCreate");
}

function saveSellerMpIvDeliChangeReqCancel(){
	closePopText1();
	kepAjaxFormCall("/mpiv/saveSellerMpIvDeliChangeReqCancel.do","searchCondition0","btnCreate");
}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "btnCreate"){
// 		alert("요청취소가 정상적으로 완료 되었습니다.");
		var text = "요청취소가 정상적으로 완료 되었습니다.";
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
	}
	
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	return;
}

var gridIndex = "";
var popupSel= "";

// 팝업 함수호출
function doPop(str, value1, value2, value3, value4, value5, value6, value7) {
	switch (str) {
		case "commonMpIvTranBuyerChoicePop": // 고객사선택
			openSearchPopup("/mpiv/getCommonMpIvTranBuyerChoicePop.do", "?st_com_code="+$("#st_com_code"+currIndex).val(), "750,530,no");
			break;
	}
}

function setBuyerChoiceReturn(buyer, com_name){
	$("#st_buyer_code_"+currIndex).val(buyer);
	$("#st_buyer_name_"+currIndex).val(com_name);
}

function excelDownload(){
	if(Sheet.RowCount() == 0){
// 		alert("조회된 데이터가 없습니다.");
		var text = "조회된 데이터가 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	// 선택된 항목 유무 체크
	if (checkRows.length == 0) {
// 		alert("상품을 선택해주세요.");
		var text = "항목을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	Sheet.SetWaitImageVisible(true);
	
	var downRow = "|0";
	for(var i=1; i<=Sheet.RowCount(); i++) {
		if(Sheet.GetCellValue(i,"SELECTED"))
			downRow += "|"+i;
	}
	
	var downCol = "";
	for(var i=0; i<=Sheet.LastCol(); i++){
		if(!Sheet.GetColHidden(i) && Sheet.ColSaveName(i) !="SELECTED" && Sheet.GetCellProperty(1, i, "Type") != "Image"){
			downCol += "|"+i;
		}
	}
	
	if(downRow == "|0"){
		downRow = "";
	}
	var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
	
	var fileName = "교환반품현황_";
	var param = {FileName:fileName+nowTime, SheetName:fileName, DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
	Sheet.Down2Excel(param);
}

function thisPopClose(){
	closePopText2();
	doAction("search");
}
</script>

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader_sub_v2"/>
<c:param name="part" value="header_v2"/>
</c:import>
<div id="container2">
<c:import charEncoding="utf-8" url="/main/leftMenuData.do">
<c:param name="page" value="sellerLeft_v2"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div class="containerBoxSub" >
	  
      <div class="PDleft50"><!--padding-left:50px; 시작 -->    
		<div class="SubTit">
          <%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star"></button>
     	<%} %> 납품이슈현황
          <div class="SummaryGuide">
      	    <ul>
        	  <li><img src="/resources/imgs/Icon_Home.png" /></li>
              <li>납품관리</li>
              <li>납품이슈현황</li>
            </ul>
          </div>
        </div>
        <div class="SubSearchTab">
         <button class="TabTit active" data-tab="Search1">요청사항현황</button>
         <button class="TabTit" data-tab="Search2">교환/반품현황</button> 
        </div>
        <form id="searchCondition0" name="searchCondition0" method="post">
        <input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_com_code" id="st_com_code0" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id0" value="${sessionInfo.userId}">   
		<input type="hidden" name="st_query" id="st_query0" value="${sessionInfo.userId}">
        <div id="Search1" class="SearchContent active">
          <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> KeP에 요청한 수주거부요청, 거래유형변경요청, 납품예정일 변경요청, 수주접수 초기화요청에 대한 진행사항을 확인 할 수 있습니다.</div>
          <table class="TabSearchTable" >
            <colgroup>
              <col width="80px" />
              <col width="260px" />
              <col width="80px" />
              <col width="250px" />
              <col width="80px" />
              <col width="230px" />
              <col width="80px" />
              <col width="220px" />
            </colgroup>            	
            <tr>
              <th>요청일</th>
              <td colspan="3" >
                <div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date_0" name="st_from_date" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_0" name="st_to_date" readonly /><span></span></div>
                </div>
                <button class="But_MonthSmall" style="width:55px;" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','1'); return false;">1개월</button> 
                <button class="But_MonthSmall" style="width:55px;" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','2'); return false;">2개월</button>
                <button class="But_MonthSmall" style="width:55px;" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','3'); return false;">3개월</button>
                <button class="But_MonthSmall" style="width:55px;" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','12'); return false;">1년</button>
              </td>
              <th></th>
              <td colspan="3" ></td>
            </tr>
            <tr>           
              <th>고객사명</th>
              <td>
                  <input type="text" class="input30" id="st_buyer_name_0"  name="st_buyer_name" style=" width:150px; " onKeyDown="kepEnter_v2();" >
<!--                   <input type="hidden" name="st_buyer_code" id="st_buyer_code_0" value=""> -->
<!--                   <button type="button" onclick="javascript:doPop('commonMpIvTranBuyerChoicePop'); return false;">고객사명</button> -->
			  </td> 
              <th>발주번호</th>
              <td ><input class="input30" style="width:200px" name="st_po_no" type="text" onKeyDown="kepEnter_v2();"/></td>                
              <th>진행상태</th>
              <td><select name="st_status" class="Select" style="width:170px;">
                  	<option value="">전체</option>
					<option value="S">요청</option>
					<option value="RE">확인중</option>
					<option value="GD">취소</option>
					<option value="CM">승인</option>
					<option value="B">반려</option>
                </select> 
              </td> 
              <th >요청사항</th>
              <td><select name="st_type" class="Select" style="width:170px;">
                  	<option value="">전체</option>
					<option value="E">수주거부 요청</option>
					<option value="D">거래유형 변경요청</option>
					<option value="G">납품예정일 변경요청</option>
					<option value="I">수주접수 초기화요청</option>
                </select> 
              </td>
            </tr>
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="doAction('search');return false;">조회</button>
          </div>
          <div class="ListBtnBox">
            <div class="left"> </div>
            <div class="right"><button class="ButPrimary_Medium" onclick="javascript:doAction('cancel'); return false;" >요청취소</button></div>
          </div>  
          <div class="IBSheet">
          	<script type="text/javascript">
          		createIBSheet("mySheet0", "", "100%");
          	</script>
          </div><!--IBSheet 끝 --> 
          <div class="h50"></div>              
        </div><!--id="Search1" 요청사항현황 끝 -->
        </form>
        <form id="searchCondition1" name="searchCondition1" method="post">
        <input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_com_code" id="st_com_code1" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id1" value="${sessionInfo.userId}">   
		<input type="hidden" name="st_query" id="st_query1" value="${sessionInfo.userId}">      
        <div id="Search2" class="SearchContent">
          <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> 교환/반품현황 조회가 가능합니다.</div>
          <table class="TabSearchTable" >
            <colgroup>
              <col width="80px" />
              <col width="260px" />
              <col width="80px" />
              <col width="250px" />
              <col width="80px" />
              <col width="230px" />
              <col width="80px" />
              <col width="220px" />
            </colgroup>            	
            <tr>
              <th>요청일</th>
              <td><div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date_1" name="st_from_date" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_1" name="st_to_date" readonly /><span></span></div>
                </div>
                <button class="But_MonthSmall" style="width:55px;" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','1'); return false;">1개월</button> 
                <button class="But_MonthSmall" style="width:55px;" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','2'); return false;">2개월</button>
                <button class="But_MonthSmall" style="width:55px;" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','3'); return false;">3개월</button>
                <button class="But_MonthSmall" style="width:55px;" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','12'); return false;">1년</button>                
              </td>
              <th>진행상태</th>
              <td><select name="st_flag" class="Select" style="width:170px;">
                  <%= CommonUtil.getCodeComboQueryIdList("common.getTypeWM07","ALL","") %>
                </select> 
              </td> 
              <th>요청유형	</th>                            
              <td><select name="st_wmre_type" class="Select" style="width:170px;">
                  <option value="">전체</option>
                  <option value="01">반품</option>
                  <option value="02">교환</option>
                  <option value="03">불량</option>
                  <option value="09">주문취소</option>
                </select> 
              </td> 
              <th>요청번호</th>                            
              <td><input class="input30" style="width:150px" name="st_wmre_no" type="text" onKeyDown="kepEnter_v2()"/></td>    
            </tr>
            <tr>
              <th>발주번호</th>
              <td ><input class="input30" style="width:448px" name="st_po_no"  type="text" placeholder="여러 개의 발주번호로 조회 가능하며 띄어쓰기 없이 콤마(,)로 구분해서 입력해주세요"  onKeyDown="kepEnter_v2()"/></td>
              <th>고객사명</th>
              <td>
                  <input type="text" class="input30" id="st_buyer_name_1"  name="st_buyer_name" style=" width:150px; " onKeyDown="kepEnter_v2();" >
<!--                   <input type="hidden" name="st_buyer_code" id="st_buyer_code_1" value=""> -->
<!--                   <button type="button" onclick="javascript:doPop('commonMpIvTranBuyerChoicePop'); return false;">고객사명</button> -->
			  </td> 
              <th>품목코드</th>
              <td><input class="input30" style="width:150px" name="st_buyer_item_no" type="text" onKeyDown="kepEnter_v2()"/></td>                                                    
              <th>품목명</th>
              <td><input class="input30" style="width:150px" name="st_description" type="text" onKeyDown="kepEnter_v2()"/></td>              
            </tr>              
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="doAction('search');return false;">조회</button> 
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40" onclick="javascript:excelDownload(); return false;">엑셀다운로드</button></div>
            <div class="right"></div>
          </div> 
          <div class="IBSheet">
          	<script type="text/javascript">
          		createIBSheet("mySheet1", "", "100%");
          	</script>
          </div><!--IBSheet 끝 --> 
          <div class="h50"></div>    
        </div><!--id="Search2" 교환/반품현황 끝 -->
        </form>    
         
		<!-- 탭 스크립트 -->     
		<script>
		const tabLinks = document.querySelectorAll(".TabTit");
        const tabContents = document.querySelectorAll(".SearchContent");
        
        tabLinks.forEach(function(link,index) {
          link.addEventListener("click", function() {
            // 모든 탭 버튼, 컨텐츠 비활성화
            tabLinks.forEach(function(btn) {btn.classList.remove("active")});
            tabContents.forEach(function(content){ content.classList.remove("active")});
      
            // 클릭한 탭 활성화
            link.classList.add("active");
            document.getElementById(link.dataset.tab).classList.add("active");
            currIndex = index; //현재 탭 index를 저장
            if(currIndex == 0){
          	  Sheet = mySheet0;
            }else if(currIndex == 1){
          	  Sheet = mySheet1;
            }
            
            doAction('search');
          });
        });
        
        const inputs = document.querySelectorAll("input[name=st_po_no],input[name=st_wmre_no],input[name=st_buyer_item_no],input[name=st_description]");
        inputs.forEach(function(input){
        	  input.addEventListener("input",function(){
        		  this.value = this.value.trimStart();
        	  });
          });
        </script>
      </div> <!--padding-left:50px; 끝 -->
    </div><!--containerBoxSub-->  

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter_sub_v2.jsp" %>  
</div>
</body>
</html>