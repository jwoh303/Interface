<%--
**********************************************
* 메뉴 : 벌크소싱 프로젝트 관리 > 벌크소싱 프로젝트 조회 및 수정
* 화면 : 벌크소싱 프로젝트 조회 및 수정 화면
* 기능 : 
*****************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>

<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
</head>
<%
// 세션정보
String user_id =  _sessionInfo.getUserId();
String st_burq_no = CommonUtil.nvl((String) request.getParameter("st_burq_no"),"");

@SuppressWarnings (value="unchecked")
Map<String,String> _datamap = (Map<String,String>) request.getAttribute("_data"); // 조회된결과
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

//삭제된 행
var del3 = 0;
var del4 = 0;
var tmpRow = "";
var delRow = "";
var delRow3 = "";
var delRow4 = "";

var open_flag = ["+","+","+","+","+"];

const std_arr = ['sg_start_schd_date','rfq_start_schd_date','rfq_end_schd_date','rfq_merge_schd_date','rfq_submit_schd_date','rfq_approval_schd_date'];
const day_arr = ['SG분류개시일','소싱개시일','견적마감일','취합완료일','사업팀제출일','품의 완료'];

var unit01 = KepSheetComboData("BURQ09", "SEL"); // IBSHEET : 거래유형
var unit02 = KepSheetComboData("BURQ10", "SEL"); // IBSHEET : 배송유형
var unit03 = KepSheetComboData("BURQ11", "SEL"); // IBSHEET : 물류센터

function kep_onload_view(){
	
	// mySheet 고객사 정보
	var initsheet = {};
	initsheet.HeaderMode = {Sort : 0,ColMove : 1};
	initsheet.Cols = [ 
		 { Hidden:true,	Type:"Text",	Header:"상태",	SaveName: "STATUS"} 
		,{ Align:"Center",	Width:40,	Edit:true,	Type:"CheckBox",	Header:"",			SaveName:"SELECTED"}
		,{ Align:"Center",	Width:120,	Edit:false,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER" }
		,{ Align:"Center",	Width:250,	Edit:false,	Type:"Text",	Header:"고객사명",	SaveName:"BUYER_NAME" } 
		,{ Align:"Center",	Width:80,	Edit:true,	Type:"Combo",	Header:"거래유형",		SaveName:"PROCESS_TYPE", ComboText:unit01.ComboText, 	ComboCode:unit01.ComboCode}
		,{ Align:"Center",	Width:80,	Edit:true,	Type:"Combo",	Header:"배송유형",		SaveName:"PARCEL_YN", 	ComboText:unit02.ComboText, 	ComboCode:unit02.ComboCode}
		,{ Align:"Center",	Width:80,	Edit:true,	Type:"Combo",	Header:"TR",		SaveName:"WAREHOUSE", 	ComboText:unit03.ComboText, 	ComboCode:unit03.ComboCode}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	// mySheet2 SG 정보
	var initsheet2 = {};
	initsheet2.HeaderMode = {Sort : 0,ColMove : 1};
	initsheet2.Cfg={	
			MergeSheet: msHeaderOnly
	};
	initsheet2.Cols = [ 
		 { Align:"Center",	Width:60,	Edit:false,	Type:"Text",	Header:"SG ID|SG ID",			SaveName:"SG_ID" } 
		,{ Align:"Center",	Width:180,	Edit:false,	Type:"Text",	Header:"SG명|SG명",				SaveName:"SG_NAME" }
		,{ Align:"Center",	Width:70,	Edit:false,	Type:"Text",	Header:"담당자|담당자",				SaveName:"SM_USER_NAME"}
		,{ Align:"Right",	Width:70,	Edit:false,	Type:"Text",	Header:"견적요청현황|대상 건수",		SaveName:"TOT_CNT" }
		,{ Align:"Right",	Width:70,	Edit:false,	Type:"Text",	Header:"견적요청현황|요청 건수",		SaveName:"REQ_CNT" }
		,{ Align:"Right",	Width:70,	Edit:false,	Type:"Text",	Header:"견적요청현황|회신 건수",		SaveName:"RES_CNT" }
		,{ Align:"Right",	Width:168,	Edit:false,	Type:"Float",	Header:"기준금액|기준금액",			SaveName:"AMT",	 Format:"${priceFormat}" }
	];
	
	IBS_InitSheet(mySheet2, initsheet2, pagingMode);
	
	// mySheet3 SM 유의사항
	// mySheet4 협력사 안내사항
	var initsheet3 = {};
	initsheet3.HeaderMode = {Sort : 0,ColMove : 1};
	initsheet3.Cols = [
		 { Hidden:true,		Type:"Text",	Header:"상태",	SaveName: "NOTICE_STATUS"} 
		,{ Hidden:true,		Type:"Text",	Header:"유의사항구분",	SaveName:"NOTICE_TYPE" }
		,{ Hidden:true,		Type:"Text",	Header:"순번",		SaveName:"SEQ" }
		,{ Align:"Center",	Width:40,	Edit:true,		Type:"DummyCheck",	Header:"",			SaveName:"SELECTED"}
		,{ Align:"Center",	Width:160,	Edit:false,		Type:"Text",		Header:"등록일",		SaveName:"ADD_DATE" }  
		,{ Align:"Left",	Width:514,	Edit:true,		Type:"Text",		Header:"유의사항",		SaveName:"NOTICE_REMARK"  } 
	];
	
	IBS_InitSheet(mySheet3, initsheet3, pagingMode); 
	
	IBS_InitSheet(mySheet4, initsheet3, pagingMode);
	
	$("#st_sheet").val('1');
	$("#s_SAVENAME").val('');
	kepSearchNoBar(document.searchCondition,  mySheet , "/mprq/getMasterMpRqBulkQuotationDetailSheetPop.do" , pagingMode );

	$("#st_sheet").val('2');
	$("#s_SAVENAME").val('');
	kepSearchNoBar(document.searchCondition,  mySheet2 , "/mprq/getMasterMpRqBulkQuotationDetailSheetPop.do" , pagingMode );

	$("#st_sheet").val('Notice');
	$("#s_SAVENAME").val('');
	$("#st_notice_type").val('SM');
	kepSearchNoBar(document.searchCondition,  mySheet3 , "/mprq/getMasterMpRqBulkQuotationDetailSheetPop.do" , pagingMode );
	
	$("#s_SAVENAME").val('');
	$("#st_notice_type").val('AGENT');
	kepSearchNoBar(document.searchCondition,  mySheet4, "/mprq/getMasterMpRqBulkQuotationDetailSheetPop.do" , pagingMode );
	
	kepAjaxCommonCombo('st_project_mng_user', 'BURQ12', 'SEL', '');
	$("#st_project_mng_user").val('<%=_datamap.get("PROJECT_MNG_USER")%>');
<%-- 	kepAjaxCommonQueryIdCombo('st_project_mng_user','master.mprq.selectPMList','SEL', '<%=_datamap.get("PROJECT_MNG_USER")%>');	 --%>

	kepAjaxCommonCombo('st_kep_dept','BURQ06','SEL','');
	$("#st_kep_dept").val('<%=_datamap.get("KEP_DEPT")%>');
	
	<% if(Integer.parseInt(_datamap.get("ITEM_CNT")) > 0) {%>
	$("input[name='st_project_unit2']:input[value='<%=_datamap.get("PROJECT_UNIT")%>']").prop('checked',true);
	$('#st_project_unit').val('<%=_datamap.get("PROJECT_UNIT")%>');
	<% } else{%>
	
	$("input[name='st_project_unit']:input[value='<%=_datamap.get("PROJECT_UNIT")%>']").prop('checked',true);
	<% } %>
	
	for(var i = 0; i < open_flag.length;  i++){
		divShowHide(i);
	}
	
}
$(document).ready(function(){
	var y_flag = 'N';
	for(var i = 0; i < 6 ; i++){
		kepSetCalender(std_arr[i], 0, "Y", i);
		var tempDate = $('input[id="'+std_arr[i]+'"]').val().replace(/[/]/gi,"");
		
		<% if(user_id.equals(_datamap.get("PROJECT_MNG_USER"))){ %> // pm 이면 무조건 수정 가능
			$('input[id="'+std_arr[i]+'"]').datepicker("option", "disabled", false);
		<% } else{ %>
			if(tempDate < kepGetNowTimeStr("YYYYMMDD","")){ // 계획일자가 오늘 이전이면 게획일자 수정 가능
				$('input[id="'+std_arr[i]+'"]').datepicker("option", "disabled", true);	
			}
		<% } %>
			
		if(isEmpty($('input[id="real_'+std_arr[i]+'"]').val())){ // 수행일자가 비워져있는 경우
			if(y_flag=='N'){
				document.getElementById('tr'+i).style.backgroundColor="#ffff99"; // 노란색 처리
				y_flag= 'Y';
			}
		} else{
			document.getElementById('tr'+i).style.backgroundColor="#cccccc"; 	
			$('input[id="'+std_arr[i]+'"]').datepicker("option", "disabled", true);	
		}
	}
})

function divShowHide(num){
	var  con  = document.getElementById("div"+num);
	if(open_flag[num] == "+"){
		con.style.display = "block";
		open_flag[num] = "-";
		document.getElementById("show"+num).innerHTML ="▼";
	}else{
		con.style.display = "none";
		open_flag[num] = "+";
		document.getElementById("show"+num).innerHTML ="▶";
	}
	document.getElementById("btn"+num).innerHTML = open_flag[num];
}

//기능함수
function doAction(str) {
	const today = kepGetNowTimeStr("YYYYMMDD","/");
	switch (str) {
		case "save":
			if(checkSave()){
				if(!confirm("변경한 내용으로 저장되며, 이전 내용은 복원되지 않습니다. 저장하시겠습니까?")){
					return;
				}
				kepAjaxFormCall("/mprq/saveMasterMpRqBulkQuotationDetailPop.do","masterMpRqBulkQuotationDetailPop","save");
			}			
			break;
		case "insert":	// 고객사 정보 행추가
			var sel = mySheet.DataInsert(-1);
			mySheet.SetCellValue(sel, "ADD_DATE", today);
			mySheet.SetCellValue(sel, "STATUS","N"); // N: 신규 , C: DB등록, R: DB등록 후 수정 
			mySheet.SetCellEditable(sel, "BUYER", true);
			break;
		case "del": // 고객사 정보 삭제
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow = selectedGrid.split("|");
 			for(var i = 0; i < arrRow.length; i++){
				if(mySheet.GetCellValue(arrRow[i],"STATUS") != "N"){  // 신규 등록건 아닌 경우
					delRow += arrRow[i] + "|";
					mySheet.SetCellValue(arrRow[i], "STATUS","D");
					mySheet.SetRowHidden(arrRow[i], 1);
				}else{
					tmpRow += arrRow[i] + "|";
				}
			}
			mySheet.RowDelete(tmpRow);	
			tmpRow ="";
			mySheet.CheckAll(1, 0); // 전체 선택해제
			break;
		case "insert1":	 // 행추가
			var rows = mySheet3.RowCount() - del3;
			if(rows < 5){
				var sel = mySheet3.DataInsert(-1);
				mySheet3.SetCellValue(sel, "ADD_DATE", today);
				mySheet3.SetCellValue(sel, "NOTICE_TYPE","SM");
				mySheet3.SetCellValue(sel, "NOTICE_STATUS","N");
				mySheet3.SelectCell(sel, "REMARK");
			}else{
				alert("최대 5개까지 등록 가능합니다.");
				return;
			}
			break;	
		case "insert2":	 // 행추가
			var rows = mySheet4.RowCount() - del4;
			if(rows < 1){
				var sel = mySheet4.DataInsert(-1);
				mySheet4.SetCellValue(sel, "ADD_DATE", today);
				mySheet4.SetCellValue(sel, "NOTICE_TYPE","AGENT");
				mySheet4.SetCellValue(sel, "NOTICE_STATUS","N");
				mySheet4.SelectCell(sel, "REMARK");
			}else{
				alert("최대 1개까지 등록 가능합니다.");
				return;
			}
			break;
		case "del1": // 삭제
			var selectedGrid = mySheet3.FindCheckedRow("SELECTED");
			var arrRow = selectedGrid.split("|");
			for(var i = 0; i < arrRow.length; i++){
				var temp_Status = mySheet3.GetCellValue(arrRow[i],"NOTICE_STATUS");
				if(temp_Status == "N"){  // 신규 등록건 아닌 경우
					tmpRow += arrRow[i] + "|";
				}else if(temp_Status != 'D'){
					delRow3 += arrRow[i] + "|";
					del3++;
					mySheet3.SetCellValue(arrRow[i], "NOTICE_STATUS","D");
					mySheet3.SetRowHidden(arrRow[i], 1);
				}
			}
			mySheet3.RowDelete(tmpRow);	
			tmpRow ="";		
			mySheet3.CheckAll(1, 0); // 전체 선택해제
			break;
		case "del2": // 삭제
			var selectedGrid = mySheet4.FindCheckedRow("SELECTED");
			var arrRow = selectedGrid.split("|");
			for(var i = 0; i < arrRow.length; i++){
				var temp_Status = mySheet4.GetCellValue(arrRow[i],"NOTICE_STATUS");
				if(temp_Status == "N"){  // 신규 등록건 아닌 경우
					tmpRow += arrRow[i] + "|";
				}else if(temp_Status != 'D'){
					delRow4 += arrRow[i] + "|";
					del4++;
					mySheet4.SetCellValue(arrRow[i], "NOTICE_STATUS","D");
					mySheet4.SetRowHidden(arrRow[i], 1);
				}
			}
			mySheet4.RowDelete(tmpRow);
			tmpRow ="";		
			mySheet4.CheckAll(1, 0); // 전체 선택해제
			break;
	}
}
function checkSave(){
	var st_project_name = $("#st_project_name").val();
	if(isEmpty(st_project_name)){
		alert("프로젝트명을 입력하시기 바랍니다.");
		return false;
	}
	var st_project_unit = '';
	// 품목 등록 안 되어 있을 때만 수정 가능하므로 그 때만 체크
	<% if(Integer.parseInt(_datamap.get("ITEM_CNT")) > 0) {%>
	st_project_unit = $('#st_project_unit').val();
	<% } else {%>
	st_project_unit =  $('input[name=st_project_unit]:checked').val();
	if(isEmpty(st_project_unit)){
		alert("소싱단위를 선택하시기 바랍니다.");
		return false;
	}
	<% } %>
	
	var st_kep_dept = $("#st_kep_dept").val();
	if(isEmpty(st_kep_dept)){
		alert("담당사업팀을 선택하시기 바랍니다.");
		return false;
	}
	var st_project_mng_user = $("#st_project_mng_user").val();
	if(isEmpty(st_project_mng_user)){
		alert("PM을 선택하시기 바랍니다.");
		return false;
	}
	
	var len = mySheet.RowCount(); 
	if(len < 1){
		alert("고객사 코드를 추가하시기 바랍니다.");
		return;
	}
	
	const regex_buyer = /^KR[A-Z .\-]{4}\d{4}$/;
	const regex_group = /^KR[A-Z .\-]{4}G\d{3}$/;
	for(i = 1; i <= len; i++){
		var buyer_code = mySheet.GetCellValue(i, "BUYER");
		var process_type = mySheet.GetCellValue(i, "PROCESS_TYPE");
		var parcel_yn = mySheet.GetCellValue(i, "PARCEL_YN");
		var warehouse = mySheet.GetCellValue(i, "WAREHOUSE");
		if(isEmpty(buyer_code) || isEmpty(process_type) || isEmpty(parcel_yn) || ( process_type != '1' && isEmpty(warehouse) ) ){
			mySheet.SetRowBackColor(i,"#FFD966");
			alert(i+ "번째 필수 입력 값이 누락되었습니다.");
			return;
		} 
		if (st_project_unit == 'B'){ // 고객사인 경우 
			if(!regex_buyer.test(buyer_code)){
				alert(i+"번째 고객사 코드 오류 ");
				return;
			}
		}else{ // 그룹사인 경우
			if(!regex_group.test(buyer_code)){
				alert(i+"번째 그룹사 카탈로그 코드 오류 ");
				return;
			}
		}
	}
	
	if(mySheet.ColValueDup("BUYER",0) != -1){
		alert("중복된 고객사 코드가 있습니다.(저장된 건 삭제 후 저장 없이 재등록 불가)");
		return;
	}
	
	len = mySheet3.RowCount();
	
	if(len < 1){
		alert("SM 유의사항을 1개 이상 입력하시기 바랍니다.");
		return;
	}
	for(i = 1; i <= len; i++){
		var remark = mySheet3.GetCellValue(i, "NOTICE_REMARK");
		if(isEmpty(remark)){
			alert(i+"번째 SM 유의사항을 입력하시기 바랍니다.");
			return;
		}
	}
	
	len = mySheet4.RowCount();
// 	if(len < 1){
// 		alert("협력사 안내사항을 1개 이상 입력하시기 바랍니다.");
// 		return;
// 	}
	for(i = 1; i <= len; i++){
		var remark = mySheet4.GetCellValue(i, "NOTICE_REMARK");
		if(isEmpty(remark)){
			alert(i+"번째 협력사 안내사항을 입력하시기 바랍니다.");
			return;
		}
	}
	
	return true;
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){  
	if (pMethod == "save"){
		// 고객사 정보 저장
		kepSaveAll(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqBulkQuotationDetailBuyer.do");
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) { 
	var msg = response.Message;
	
	if (!isEmpty(msg)){	
		alert(msg);
	}
	return;
}
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
	// 고객사코드 -> sm 저장 
	mySheet3.SetRowHidden(delRow3, 0);
	kepSaveAll(document.searchCondition ,  mySheet3 , "/mprq/saveMasterMpRqBulkQuotationDetailNotice.do");
	
}
//트랜젝션(저장,삽입등) 후처리
function mySheet3_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
	// sm 저장 -> agent 저장
	mySheet4.SetRowHidden(delRow4, 0);
	kepSaveAll(document.searchCondition ,  mySheet4 , "/mprq/saveMasterMpRqBulkQuotationDetailNotice.do");
	
}
//트랜젝션(저장,삽입등) 후처리
function mySheet4_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
	
	alert("저장이 완료되었습니다.");
	
	setReturn('1');
}
//cell 값 변경 시 호출되는 함수
function mySheet_OnChange(Row,Col,Value, OldValue){
	// STATUS 변경되지 않고, DB에 저장되어 있는 값이 변경될 경우 STATUS 변경(R을 또 수정할 필요가 없어서)
	if(Col != 1 && mySheet.GetCellValue(Row, "STATUS") == "C"){ //신규입력 아닌 경우 수정 시 상태값 변경 
		mySheet.SetCellValue(Row,"STATUS","R",0);
	}
}

//cell 값 변경 시 호출되는 함수
function mySheet3_OnChange(Row,Col,Value, OldValue){
	if(Col != 1 && mySheet3.GetCellValue(Row, "NOTICE_STATUS") == "C"){ //신규입력 아닌 경우 수정 시 상태값 변경 
		mySheet3.SetCellValue(Row,"NOTICE_STATUS","R",0);
	}
}
function mySheet4_OnChange(Row,Col,Value, OldValue){
	if(Col != 1 && mySheet4.GetCellValue(Row, "NOTICE_STATUS") == "C"){ //신규입력 아닌 경우 수정 시 상태값 변경 
		mySheet4.SetCellValue(Row,"NOTICE_STATUS","R",0);
	}
}
// 달력 날짜 선택시 콜백함수
function calenderChange(dateText, op){
	const input_date = dateText.replace(/[/]/gi,"");
	if(op == 0){ // SG 분류 개시 설정 시 전체일정에서 시작일만 계산
		var start_date = $('input[id="'+std_arr[op]+'"]').val();
		document.getElementById("start_date").innerHTML = start_date;
	}else{
		var temp = $('input[id="'+std_arr[op-1]+'"]').val().replace(/[/]/gi,"");
		if(isEmpty(temp)){ // 이전일자 없으면 입력 불가
			alert(day_arr[op-1]+"을 먼저 선택하시기 바랍니다.");
			$('input[id="'+std_arr[op]+'"]').val("");
			return;
		}
		
		if( temp > input_date){ // 이전 일자 이후로 입력 불가  
			alert(day_arr[op-1]+"이후 날짜로 입력가능합니다.");
			$('input[id="'+std_arr[op]+'"]').val("");
			return;
		}
	}
	
	if(op == 5){ // 품의 완료일 설정 시 전체 일정 계산
		var start_date = $('input[id="'+std_arr[0]+'"]').val().replace(/[/]/gi,"-");
		var sdate = new Date(start_date);
		
		var end_date = $('input[id="'+std_arr[op]+'"]').val().replace(/[/]/gi,"-");	
		var edate = new Date(end_date);
		
		var gap = Math.floor(Math.abs(sdate.getTime() - edate.getTime()) / (1000*60*60*24));
		
		document.getElementById("end_date").innerHTML =$('input[id="'+std_arr[op]+'"]').val() + "  (" +gap+"일)";
	}


	for(i = op+1; i < 6; i++){ // SG분류 개시 외에 다른 일자 설정 시 그 전 일자 초기화
		$('input[id="'+std_arr[i]+'"]').val("");
		$('input[id="st_'+std_arr[i]+'"]').val("");
	}

	$('input[id="st_'+std_arr[op]+'"]').val(input_date);
}

//팝업함수호출
function doPop(str, value1) {
	popupSel = str;

	switch (str) {
		case "BurqInputfileUpload": //파일업로드
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#"+value1).val()+"&TYPE=BURQ", "500,430,no");
			break;
		case "BurqOutputfileUpload": //소싱결과 파일업로드
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#"+value1).val()+"&TYPE=BURQ", "500,430,no");
			break;
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "BurqInputfileUpload") {
		$("#st_image_key").val(code);
		$("#st_image_key_text").val(text);
	}else if (popupSel == "BurqOutputfileUpload") {
		$("#st_image_key2").val(code);
		$("#st_image_key2_text").val(text);
	}
}

function changeDiskImg(idx){
	if(!isEmpty($("#st_image_key").val())){
		document.getElementById("diskimg"+idx).src = "/resources/images/disk_on.gif";
	}else{
		document.getElementById("diskimg"+idx).src = "/resources/images/disk_off.gif";
	}
}

function setReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9){ 
	opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9);
	this.close();
}
</script> 

<style>
.PopNewBox{background-color:#fff; border-radius:5px; margin-top:10px;}
.PopTableBox{display:block; margin:0px 15px; padding-bottom:10px;}
.PopTitle_s {display:block; margin-bottom:5px; height:46px;line-height:50px; padding-left:15px;  font-size:16px; font-weight:bold; letter-spacing:-1.5px; color:#000; border-bottom:0px solid #eaeaea  }
.PopTitle_s b{ font-size:16px;line-height:46px; margin-right:5px;}
.PopTitle_s span{float:right; margin-right:15px; margin-top:10px; width:30px; height:30px; line-height:30px; font-size:30px; letter-spacing:-1px;color:#000; text-align:center; border-radius:50px; background-color:#fff}
</style>
<body onLoad="kep_onload_view()" style="overflow:hidden; height:542px">
	<form name="searchCondition" id="searchCondition" method="post">
		<input type="hidden" id="st_sheet" name="st_sheet" value="1">
		<input type="hidden" id="s_SAVENAME" name="s_SAVENAME" value="">
		<input type="hidden" id="st_burq_no" name="st_burq_no" value="<%=_datamap.get("BURQ_NO")%>">
		<input type="hidden" id="st_notice_type" name="st_notice_type" value="">
	</form>
	 
	<div id="popWrapper" >
		<div id="popHeader">
		   	<h1 class="title">벌크소싱 프로젝트 조회 및 수정</h1>
		    <p class="popClose"><a href="javascript:self.close()">
 			    <img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
		    </a></p>
		</div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="background-color:#f5f5f5"  >
        	<%if(!_datamap.get("PROJECT_STATUS").equals("G")){%>
        	<div class="btnArea mr25"> 
				<span class="fr">
					<span class="btn_03 mr04"><a href="javascript:doAction('save')">저장</a></span>			
				</span>
			</div>
			<%} %>
			<form id="masterMpRqBulkQuotationDetailPop" name="masterMpRqBulkQuotationDetailPop" method="POST">
			<input type="hidden" id="st_burq_no" name="st_burq_no" value="<%=_datamap.get("BURQ_NO")%>">
				<div class="scrollArea" style="height:708px;padding:0 10px 0 0">
		            <div  class="PopNewBox" >
		                <a href="javascript:divShowHide('0');"><div class="PopTitle_s"><b id="show0"></b> 프로젝트 기본정보 <span id="btn0"></span></div></a>
		                 <div id="div0" class="PopTableBox"> 
		                    <table  class="cont_t_list06" summary="프로젝트 기본정보" style="width:100%;">
		                        <caption>프로젝트 기본정보</caption>
		                        <colgroup>
		                            <col width="15%"  />
		                            <col width="35%"/>
		                            <col width="15%" />
		                            <col width="35%" />
		                        </colgroup>
		                        <tbody>
		                        <tr height="30px"> 
		                            <th scope="row" class="center">프로젝트 명</th>
		                            <td scope="row" class="center"><input type= "text" style="width:180px;height:20px" class="input_type_text" id="st_project_name" name="st_project_name" value="<%=_datamap.get("PROJECT_NAME")%>"></td>
		                            <th scope="row" class="center">프로젝트 코드</th>
		                            <td scope="row" class="center"><%=_datamap.get("BURQ_NO")%></td>
		                        </tr>
		                        <tr height="30px">
		                           <th scope="row" class="center">사업부서</th>
			                            <td scope="row" class="center">
			                            	<select id="st_kep_dept" name="st_kep_dept" style="width:182px;height:20px">
			                            	</select>
			                            </td>
		                            <th scope="row" class="center">소싱유형</th>
		                            <td scope="row" class="center">재계약</td>
		                        </tr>
		                        <tr height="30px">
		                            <th scope="row" class="center">PM</th>
		                            <td scope="row" class="center"><select id="st_project_mng_user" name="st_project_mng_user" style="width:182px;height:20px"></select></td>
		                            <th scope="row" class="center">소싱 단위</th>
		                            <td scope="row" class="center">
		                            <% if(Integer.parseInt(_datamap.get("ITEM_CNT")) > 0) {%>
		                            	<label><input type="radio" name="st_project_unit2" value="B" disabled>&nbsp;고객사</label>&nbsp;&nbsp;
		                            	<label><input type="radio" name="st_project_unit2" value="G" disabled>&nbsp;그룹사</label>
		                            	<input type="hidden" name="st_project_unit" id="st_project_unit" value="<%=_datamap.get("PROJECT_UNIT")%>">
									<% } else{%>
		                            	<label><input type="radio" name="st_project_unit" value="B">&nbsp;고객사</label>&nbsp;&nbsp;
		                            	<label><input type="radio" name="st_project_unit" value="G">&nbsp;그룹사</label>
									<% } %>
	                            	</td>                          
		                        </tr>
		                        <tr height="30px">
		                        	<th scope="row" class="center">대상품목</th>
		                            <td scope="row" class="center">
			                            <input type="hidden" id="st_image_key" name="st_image_key" value="<%=CommonUtil.nvl(_datamap.get("BURQ_INPUT_IMAGE_KEY")) %>" onChange="changeDiskImg(1)" />
										<input type="hidden" id="st_image_key_Text" name="st_image_key_Text"  value="" />
										<a href="javascript:doPop('BurqInputfileUpload','st_image_key')">
	                            			<img class="center" name="image_key_img" id="diskimg1" src="/resources/images/disk_<%if(_datamap.get("BURQ_INPUT_IMAGE_KEY") == null) {%>off<%}else{ %>on<%} %>.gif"border="0">
	                            		</a>
		                            </td>
		                            <th scope="row" class="center">소싱 결과</th>
									<td scope="row" class="center">
			                            <input type="hidden" id="st_image_key2" name="st_image_key2" value="<%=CommonUtil.nvl(_datamap.get("BURQ_OUTPUT_IMAGE_KEY"))%>"  onChange="changeDiskImg(2)" />
										<input type="hidden" id="st_image_key2_Text" name="st_image_key2_Text"  value="" />
	                            		<a href="javascript:doPop('BurqOutputfileUpload','st_image_key2')">
	                            			<img class="center" name="image_key_img" id="diskimg2" src="/resources/images/disk_<%if(_datamap.get("BURQ_OUTPUT_IMAGE_KEY") == null) {%>off<%}else{ %>on<%} %>.gif" border="0">
	                            		</a>
		                            </td>
		                        </tr>	
		                        <tr height="30px">
		                            <th scope="row" class="center">진행 현황</th>
		                            <td scope="row" class="left" colspan="3"><%=_datamap.get("PROJECT_STATUS_NAME")%></td>
		                        </tr>                         
		                        </tbody>
		                   </table> 
		                </div>
		        	</div>
		            <div  class="PopNewBox" >
		                <a href="javascript:divShowHide('1');"><div class="PopTitle_s"><b id="show1"></b> 프로젝트 기간 <span id="btn1"></span></div></a>
		                <div id="div1" class="PopTableBox"> 
		                    <table  class="cont_t_list06 mb15" summary="주문 정보" style="width:100%;">
		                        <caption>주문 정보</caption>
		                        <colgroup>
		                            <col width="33%" />
		                            <col width="33%" />
		                            <col width="33%" />
		                        </colgroup>
		                        <tbody>
		                            <tr  height="30px"> 
		                                <th scope="row" class="center">분류</th>
		                                <th scope="row" class="center">계획 일자</th>
		                                <th scope="row" class="center">수행 일자</th>
		                            </tr>
									<tr id="tr0"  height="30px">
		                                <td class="center">SG분류 개시</td>
		                                <td class="center">
		                                	<input type="text" class="input_type_text" name="sg_start_schd_date" id="sg_start_schd_date" readOnly style="width:180px;  height:21px; text-align:center; margin-bottom:2px" value="<%=CommonUtil.formatStrinigDate(_datamap.get("SG_START_SCHD_DATE"))%>">
	                                		<input type="hidden" id="st_sg_start_schd_date" name="st_sg_start_schd_date"  value="<%=CommonUtil.nvl(_datamap.get("SG_START_SCHD_DATE"))%>" />
		                                </td>
		                                <td class="center"><%=CommonUtil.nvl(_datamap.get("SG_START_DATE"))%>
		                                	<input type="hidden" id="real_sg_start_schd_date" name="real_sg_start_schd_date"  value="<%=CommonUtil.nvl(_datamap.get("SG_START_DATE"))%>" />
		                                </td>
		                            </tr>
		                            <tr id="tr1"  height="30px">
		                                <td class="center">소싱 개시</td>
		                                <td class="center">
		                                	<input type="text" class="input_type_text" name="rfq_start_schd_date" id="rfq_start_schd_date" readOnly style="width:180px;  height:21px; text-align:center; margin-bottom:2px" value="<%=CommonUtil.formatStrinigDate(_datamap.get("RFQ_START_SCHD_DATE"))%>">
		                                	<input type="hidden" id="st_rfq_start_schd_date" name="st_rfq_start_schd_date"  value="<%=CommonUtil.nvl(_datamap.get("RFQ_START_SCHD_DATE"))%>" />
	                                	</td>
	                                	<td class="center"><%=CommonUtil.nvl(_datamap.get("RFQ_START_DATE"))%>
	                                		<input type="hidden" id="real_rfq_start_schd_date" name="real_rfq_start_schd_date"  value="<%=CommonUtil.nvl(_datamap.get("RFQ_START_DATE"))%>" />
	                                	</td>
		                            <tr id="tr2" height="30px">
		                                <td class="center">견적 마감</td>
		                                <td class="center">
		                                	<input type="text" class="input_type_text" name="rfq_end_schd_date" id="rfq_end_schd_date" readOnly style="width:180px;  height:21px; text-align:center; margin-bottom:2px" value="<%=CommonUtil.formatStrinigDate(_datamap.get("RFQ_END_SCHD_DATE"))%>">
		                                	<input type="hidden" id="st_rfq_end_schd_date" name="st_rfq_end_schd_date"  value="<%=CommonUtil.nvl(_datamap.get("RFQ_END_SCHD_DATE"))%>" />
		                                </td>
		                                <td class="center"><%=CommonUtil.nvl(_datamap.get("RFQ_END_DATE"))%>
		                                	<input type="hidden" id="real_rfq_start_schd_date" name="real_rfq_start_schd_date"  value="<%=CommonUtil.nvl(_datamap.get("RFQ_START_DATE"))%>" />
		                                </td>
		                            </tr>
		                            <tr id="tr3" height="30px">
		                                <td class="center">취합 완료</td>
		                                <td class="center">
		                                	<input type="text" class="input_type_text" name="rfq_merge_schd_date" id="rfq_merge_schd_date" readOnly style="width:180px;  height:21px; text-align:center; margin-bottom:2px" value="<%=CommonUtil.formatStrinigDate(_datamap.get("RFQ_MERGE_SCHD_DATE"))%>">
		                                	<input type="hidden" id="st_rfq_merge_schd_date" name="st_rfq_merge_schd_date"  value="<%=CommonUtil.nvl(_datamap.get("RFQ_MERGE_SCHD_DATE"))%>" />	
	                                	</td>
	                                	<td class="center"><%=CommonUtil.nvl(_datamap.get("RFQ_MERGE_DATE"))%>
	                                		<input type="hidden" id="real_rfq_merge_schd_date" name="real_rfq_merge_schd_date"  value="<%=CommonUtil.nvl(_datamap.get("RFQ_MERGE_DATE"))%>" />
	                                	</td>
		                            </tr>
		                            <tr id="tr4" height="30px">
		                                <td class="center">사업팀 제출</td>
		                                <td class="center">
		                                	<input type="text" class="input_type_text" name="rfq_submit_schd_date" id="rfq_submit_schd_date" readOnly style="width:180px;  height:21px; text-align:center; margin-bottom:2px" value="<%=CommonUtil.formatStrinigDate(_datamap.get("RFQ_SUBMIT_SCHD_DATE"))%>">
											<input type="hidden" id="st_rfq_submit_schd_date" name="st_rfq_submit_schd_date"  value="<%=CommonUtil.nvl(_datamap.get("RFQ_SUBMIT_SCHD_DATE"))%>" />			                                
		                                </td>
		                                <td class="center"><%=CommonUtil.nvl(_datamap.get("RFQ_SUBMIT_DATE"))%>
		                                	<input type="hidden" id="real_rfq_submit_schd_date" name="real_rfq_submit_schd_date"  value="<%=CommonUtil.nvl(_datamap.get("RFQ_SUBMIT_DATE"))%>" />
		                                </td>
		                            </tr>
		                            <tr id="tr5" height="30px">
		                                <td class="center">품의 완료</td>
		                                <td class="center">
		                                	<input type="text" class="input_type_text" name="rfq_approval_schd_date" id="rfq_approval_schd_date" readOnly style="width:180px;  height:21px; text-align:center; margin-bottom:2px" value="<%=CommonUtil.formatStrinigDate(_datamap.get("RFQ_APPROVAL_SCHD_DATE"))%>">
		                                	<input type="hidden" id="st_rfq_approval_schd_date" name="st_rfq_approval_schd_date"  value="<%=CommonUtil.nvl(_datamap.get("RFQ_APPROVAL_SCHD_DATE"))%>">	
		                                </td>
		                                <td class="center"><%=CommonUtil.nvl(_datamap.get("RFQ_APPROVAL_DATE"))%>
		                                	<input type="hidden" id="real_rfq_approval_schd_date" name="real_rfq_approval_schd_date"  value="<%=CommonUtil.nvl(_datamap.get("RFQ_APPROVAL_DATE"))%>" />
		                                </td>
		                            </tr>
		                            <tr height="30px">
		                                <th class="center">전체 일정</td>
		                                <th class="center" colspan=2><span id ="start_date"><%=CommonUtil.formatStrinigDate(_datamap.get("SG_START_SCHD_DATE"))%></span>
		                                &nbsp;&nbsp;&nbsp;&nbsp;ㅡ&nbsp;&nbsp;&nbsp;&nbsp;<span id = "end_date"><%=CommonUtil.formatStrinigDate(_datamap.get("RFQ_APPROVAL_SCHD_DATE"))%></span></th>
		                            </tr>
								</tbody>
							</table> 	                     
		                </div>
		            </div>
	        		<div class="PopNewBox" >
						<a href="javascript:divShowHide('2');"><div class="PopTitle_s"><b id="show2"></b>고객사 정보 <span id="btn2"></span></div></a>
						<div id="div2" class="PopTableBox" style="overflow: hidden"> 
							<div style="border-top:2px solid #3c639c; left:0;">
		                        <script type="text/javascript">
		                            createIBSheet("mySheet", "100%", "390px");
		                        </script>
		                    </div>
		                    <br>
           					<span class="fr">
								<span class="btn_08"><a href="javascript:doAction('insert');">행 추가</a></span>
								<span class="btn_08"><a href="javascript:doAction('del');">행 삭제</a></span>
							</span>
		                </div>
	        		</div>
	        		<div class="PopNewBox" >
						<a href="javascript:divShowHide('3');"><div class="PopTitle_s"><b id="show3"></b>SG별 품목 수 <span id="btn3" ></span></div></a>
						<div id="div3" class="PopTableBox"> 
							<div style="border-top:2px solid #3c639c; left:0;">
		                        <script type="text/javascript">
		                            createIBSheet("mySheet2", "100%", "390px");
		                        </script>
		                    </div>
		                </div>
	        		</div>
		            <div class="PopNewBox" >
						<a href="javascript:divShowHide('4');"><div class="PopTitle_s"><b id="show4"></b>소싱 유의사항 <span id="btn4" ></span></div></a>
						<div id="div4" class="PopTableBox"> 
							<b>1. SM 유의사항</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	SM이 소싱 시 유의해야할 사항에 대해 기재해주세요
							<span class="fr">
								<span class="btn_02 mr04"><a href="javascript:doAction('insert1');">행추가</a></span>
								<span class="btn_02 mr04"><a href="javascript:doAction('del1');">삭제</a></span>
							</span>
							<br><br>
		                 	<div style="border-top:2px solid #3c639c; left:0;">
		                        <script type="text/javascript">
		                            createIBSheet("mySheet3", "100%", "380px");
		                        </script>
							</div>
							<br>
		                	<b>2. 협력사 안내사항</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;협력사에 전달할 안내사항을 기재해주세요.
	                		<span class="fr">
								<span class="btn_02 mr04"><a href="javascript:doAction('insert2');">행추가</a></span>
								<span class="btn_02 mr04"><a href="javascript:doAction('del2');">삭제</a></span>
							</span>
							<br><br>
							<div style="border-top:2px solid #3c639c; left:0;">
		                        <script type="text/javascript">
		                            createIBSheet("mySheet4", "100%", "380px");
		                        </script>
		                    </div>
		                </div>
	        		</div>
	          	</div>
			</form>
        </div>
	</div>
</body>
</html>
