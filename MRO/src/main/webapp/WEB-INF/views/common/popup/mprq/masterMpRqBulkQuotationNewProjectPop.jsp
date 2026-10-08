<%--
**********************************************
* 메뉴 : 벌크소싱 품목 관리 > 벌크소싱 프로젝트 신규등록
* 화면 : 벌크소싱 프로젝트 신규등록
* 기능 : 
*****************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>

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
String user_dept =  _sessionInfo.getDepartment();
String user_id =  _sessionInfo.getUserId();
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

var open_flag = ["+","+","+","+"];

const std_arr = ['sg_start_schd_date','rfq_start_schd_date','rfq_end_schd_date','rfq_merge_schd_date','rfq_submit_schd_date','rfq_approval_schd_date'];
const day_arr = ['SG분류개시일','소싱개시일','견적마감일','취합완료일','사업팀제출일','품의 완료'];
const process_arr = ["","직납","TR","직납,TR"];
const parcel_arr = ["","자차","택배","자차,택배"];
const warehouse_map = new Map([	["KRKORE0068", "코리아이플랫폼㈜ 창원센터"],
								["KRKORE0404", "코리아이플랫폼㈜ 대전센터"],
	  							["KRKORE0192", "코리아이플랫폼㈜ 구미센터"],
	  							["KRKORE0440", "코리아이플랫폼㈜ 중앙HUB"]
	]);

function kep_onload_view(){
	var initsheet = {};

	// mySheet 고객사 정보
	initsheet.HeaderMode = {Sort : 0,ColMove : 1};
	initsheet.Cols = [ 
		 { Align:"Center",	Width:120,	Edit:false,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER" } 
		,{ Align:"Center",	Width:75,	Edit:false,	Type:"Text",	Header:"거래유형코드",	SaveName:"PROCESS_TYPE" }
		,{ Align:"Center",	Width:70,	Edit:false,	Type:"Text",	Header:"거래유형",		SaveName:"PROCESS_TYPE_NAME" }
		,{ Align:"Center",	Width:75,	Edit:false,	Type:"Text",	Header:"배송유형코드",	SaveName:"PARCEL_YN" }
		,{ Align:"Center",	Width:70,	Edit:false,	Type:"Text",	Header:"배송유형",		SaveName:"PARCEL_YN_NAME" }
		,{ Align:"Left",	Width:80,	Edit:false,	Type:"Text",	Header:"TR코드",		SaveName:"WAREHOUSE" }
		,{ Align:"Left",	Width:155,	Edit:false,	Type:"Text",	Header:"TR",		SaveName:"WAREHOUSE_NAME" }
		,{ Align:"Center",	Width:300,	Edit:false,	Type:"Text",	Header:"결과",		SaveName:"RESULT" }
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	// mySheet2 1. SM 유의사항
	initsheet.HeaderMode = {Sort : 0,ColMove : 1};
	initsheet.Cfg={	
			MergeSheet:msFixedMerge + msHeaderOnly
	};
	initsheet.Cols = [
		 { Align:"Center",	Hidden:true,Type:"Status",	Header:"상태",		SaveName:"sStatus"} 
		,{ Align:"Center",	Hidden:true,Type:"Text",	Header:"유의사항구분",	SaveName:"NOTICE_TYPE" }
		,{ Align:"Center",	Hidden:true,Type:"Seq",		Header:"순번",		SaveName:"SEQ" }
		,{ Align:"Center",	Width:40,	Edit:true,		Type:"DummyCheck",	Header:"",			SaveName:"SELECTED"}
		,{ Align:"Center",	Width:160,	Edit:false,		Type:"Text",		Header:"등록일",		SaveName:"ADD_DATE2" }  
		,{ Align:"Center",	Width:514,	Edit:true,		Type:"Text",		Header:"유의사항",		SaveName:"REMARK"  } 
	];
	
	IBS_InitSheet(mySheet2, initsheet, pagingMode); 

	// mySheet3 2. 협력사 안내사항
	IBS_InitSheet(mySheet3, initsheet, pagingMode);
	
	 kepAjaxCommonCombo("st_project_mng_user", "BURQ12", "SEL");  
	// kepAjaxCommonQueryIdCombo('st_project_mng_user','master.mprq.selectPMList','SEL', ''); // PM 고정으로 인해 변경	
	
	kepSetCalender("sg_start_schd_date", 1, "Y", 0);
	$('input[id="sg_start_schd_date"]').datepicker("option", "disabled", false);
	kepSetCalender("rfq_start_schd_date", 0,"Y",1);
	$('input[id="rfq_start_schd_date"]').datepicker("option", "disabled", false);
	kepSetCalender("rfq_end_schd_date", 0,"Y", 2);
	$('input[id="rfq_end_schd_date"]').datepicker("option", "disabled", false);
	kepSetCalender("rfq_merge_schd_date",0,"Y",3);
	$('input[id="rfq_merge_schd_date"]').datepicker("option", "disabled", false);
	kepSetCalender("rfq_submit_schd_date",0, "Y",4);
	$('input[id="rfq_submit_schd_date"]').datepicker("option", "disabled", false);
	kepSetCalender("rfq_approval_schd_date",0, "Y", 5);
	$('input[id="rfq_approval_schd_date"]').datepicker("option", "disabled", false);
	
	for(var i = 0; i < open_flag.length;  i++){
		divShowHide(i);
	}
	
	kepAjaxCommonCombo('st_kep_dept','BURQ06','SEL');
	
}

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
	const today = kepGetNowTimeStr("YYYYMMDD",".");
	switch (str) {
		case "save":
			if(checkSave()){
				if(!confirm("입력하신 내용으로 프로젝트를 등록하시겠습니까?")){
					return;
				}
				kepAjaxFormCall("/mprq/saveMasterMpRqBulkQuotationNewProject.do","masterMpRqBulkQuotationNewProjectPop","save");
			}			
			break;
		case "loadExcel": // 파일 업로드
		
			var st_project_unit = $("input:radio[name='st_project_unit']").is(':checked');
			if(isEmpty(st_project_unit)){
				alert("소싱단위를 먼저 선택하시기 바랍니다.");
				return false;
			}
			
			var params = "";
			mySheet.RemoveAll();
			params = { StartRow: "2", ColumnMapping:"1|2||3||4|||"};
			mySheet.LoadExcel(params);
			break;
		case "downForm" : // 양식 다운로드
			location.href = "/resources/excel/work/NEWSOURCING/masterMpRqBulkQuotationBuyerCodeRegExcel.xlsx";
			break;
		case "downExcel": // 조회결과 다운로드
			if( mySheet.RowCount() < 1) {
				alert("조회된 결과가 없습니다.");
				return;
			}
			var param = {FileName:"고객사정보.xls", HiddenColumn:1, Merge:1, SheetDesign:1};
			mySheet.Down2Excel(param);
			break;
		case "insert1":	 // 행추가
			var rows = mySheet2.RowCount();
			if(rows < 5){
				var sel = mySheet2.DataInsert(-1);
				mySheet2.SetCellValue(sel, "ADD_DATE2", today);
				mySheet2.SetCellValue(sel, "NOTICE_TYPE","SM");
				mySheet2.SelectCell(sel, "REMARK");
			}else{
				alert("최대 5개까지 등록 가능합니다.");
				return;
			}
			break;	
		case "insert2":	 // 행추가
			var rows = mySheet3.RowCount();
			if(rows < 1){
				var sel = mySheet3.DataInsert(-1);
				mySheet3.SetCellValue(sel, "ADD_DATE2", today);
				mySheet3.SetCellValue(sel, "NOTICE_TYPE","AGENT");
				mySheet3.SelectCell(sel, "REMARK");
			}else{
				alert("최대 1개까지 등록 가능합니다.");
				return;
			}
			break;
		case "del1": // 삭제
			var selectedGrid = mySheet2.FindCheckedRow("SELECTED");
			mySheet2.RowDelete(selectedGrid, 1);
			break;
		case "del2": // 삭제
			var selectedGrid = mySheet3.FindCheckedRow("SELECTED");
			mySheet3.RowDelete(selectedGrid, 1);
			break;
	}
}
function checkSave(){
	var st_project_name = $("#st_project_name").val();
	if(isEmpty(st_project_name)){
		alert("프로젝트명을 입력하시기 바랍니다.");
		return false;
	}
	var st_project_unit = $("input:radio[name='st_project_unit']").is(':checked');
	if(isEmpty(st_project_unit)){
		alert("소싱단위를 선택하시기 바랍니다.");
		return false;
	}
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
	
	for(i = 0; i < 6; i++){
		if (isEmpty($('input[id="'+std_arr[i]+'"]').val())){
			alert(day_arr[i]+"을 선택하시기 바랍니다.");
			return false;
		}
	}
	
	var len = mySheet.RowCount(); 
	if(len < 1){
		alert("고객사 코드를 업로드하시기 바랍니다.");
		return;
	}
	
	for(i = 1; i <= len; i++){
		var result = mySheet.GetCellValue(i, "RESULT");
		if(isEmpty(result)){
			alert(i+"번째 고객사 코드 업로드 결과를 확인 바랍니다.");
			return;
		}
	}
	
	len = mySheet2.RowCount();
	if(len < 1){
		alert("SM 유의사항을 1개 이상 입력하시기 바랍니다.");
		return;
	}
	for(i = 1; i <= len; i++){
		var remark = mySheet.GetCellValue(i, "REMARK");
		if(isEmpty(remark)){
			alert(i+"번째 SM 유의사항을 입력하시기 바랍니다.");
			return;
		}
	}
	
	len = mySheet3.RowCount();
// 	if(len < 1){
// 		alert("협력사 안내사항을 1개 이상 입력하시기 바랍니다.");
// 		return;
// 	}
	for(i = 1; i <= len; i++){
		var remark = mySheet2.GetCellValue(i, "REMARK");
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
		var st_burq_no = response.BURQ_NO;
		if(isEmpty(st_burq_no)){
			alert("저장하는데 오류가 발생하였습니다.");
			return;
		}
		
		$('input[id="st_burq_no"]').val(st_burq_no);
		
		//고객사코드 
		kepSaveAll(document.masterMpRqBulkQuotationNewProjectPop ,  mySheet , "/mprq/saveMasterMpRqBulkQuotationBuyerCode.do");
		
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

//엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {
	loader_obj("N");
	
	if(mySheet.RowCount() == 0){
		//일괄 업로드를 실패하였습니다. 관리자에게 문의바랍니다.
		alert("<%=CommonLang.msg("MSG467") %>");
	}else{
		const regex_buyer = /^KR[A-Z .\-]{4}\d{4}$/;
		const regex_group = /^KR[A-Z .\-]{4}G\d{3}$/;
		var len = mySheet.RowCount();
		for(i = 1; i <= len; i++){
			var result = "";
			var buyer_code = mySheet.GetCellValue(i, "BUYER");
			var process_type = mySheet.GetCellValue(i, "PROCESS_TYPE");
			var parcel_yn = mySheet.GetCellValue(i, "PARCEL_YN");
			var warehouse = mySheet.GetCellValue(i, "WAREHOUSE");
			if(isEmpty(buyer_code) || isEmpty(process_type) || isEmpty(parcel_yn) || ( process_type != '1' && isEmpty(warehouse) ) ){
				result = "필수값 누락 ";
			}
			
			var st_project_unit =   $('input[name=st_project_unit]:checked').val();
			if (st_project_unit == 'B'){ // 고객사인 경우 
				if(!regex_buyer.test(buyer_code)){
					result += "고객사 코드 오류 ";
				}
			}else{ // 그룹사인 경우
				if(!regex_group.test(buyer_code)){
					result += "그룹사 카탈로그 코드 오류 ";
				}
			}
			if ( process_type in process_arr ) {
				mySheet.SetCellValue(i, "PROCESS_TYPE_NAME", process_arr[process_type]);
			}else{
				result += "거래유형코드 오류 ";
			}
			
			if ( parcel_yn in parcel_arr ) {
				mySheet.SetCellValue(i, "PARCEL_YN_NAME", parcel_arr[parcel_yn]);
			}else{
				result += "배송유형코드 오류 ";
			}
			var w = warehouse_map.get(warehouse);
			if(!isEmpty(warehouse)  && w == ""){
				result += "TR코드 오류 ";
			}else{
				mySheet.SetCellValue(i, "WAREHOUSE_NAME", w);
			}
			if((i > 1 && mySheet.FindText("BUYER",buyer_code,1) != i)|| mySheet.FindText("BUYER",buyer_code,i+1) != -1){
				result += "고객사코드 중복";
			}
			
			if (result == "") {
				result = "정상";
			}else{
				mySheet.SetRowBackColor(i,"#FFD966");
			}
			mySheet.SetCellValue(i, "RESULT", result);
		}
	}
}
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}

	// SM
	kepSaveAll(document.masterMpRqBulkQuotationNewProjectPop ,  mySheet2 , "/mprq/saveMasterMpRqBulkQuotationNewProjectNotice.do");
	
}
//트랜젝션(저장,삽입등) 후처리
function mySheet2_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}

	// AGENT
	kepSaveAll(document.masterMpRqBulkQuotationNewProjectPop ,  mySheet3 , "/mprq/saveMasterMpRqBulkQuotationNewProjectNotice.do");
	
}
//트랜젝션(저장,삽입등) 후처리
function mySheet3_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
	
	alert('저장이 완료되었습니다.');
	setReturn('1');
	
}
// 달력 날짜 선택시 콜백함수
function calenderChange(dateText, op){
	const input_date = dateText.replace(/[/]/gi,"");
	if(op == 0){
		
		var start_date = $('input[id="'+std_arr[op]+'"]').val();
		document.getElementById("start_date").innerHTML = start_date;
		
		for(i = 1; i < 5; i++){
			$('input[id="'+std_arr[i]+'"]').val("");
		}
	}else{
		
		var temp = $('input[id="'+std_arr[op-1]+'"]').val().replace(/[/]/gi,"");
		if(isEmpty(temp)){
			alert(day_arr[op-1]+"을 먼저 선택하시기 바랍니다.");
			$('input[id="'+std_arr[op]+'"]').val("");
			return;
		}
		
		if( temp > input_date){
			alert(day_arr[op-1]+"이후 날짜로 입력가능합니다.");
			$('input[id="'+std_arr[op]+'"]').val("");
			return;
		}
	}
	
	if(op == 5){
		
		var start_date = $('input[id="'+std_arr[0]+'"]').val().replace(/[/]/gi,"-");
		var sdate = new Date(start_date);
		
		var end_date = $('input[id="'+std_arr[op]+'"]').val().replace(/[/]/gi,"-");	
		var edate = new Date(end_date);
		
		var gap = Math.floor(Math.abs(sdate.getTime() - edate.getTime()) / (1000*60*60*24)) +1;
		
		document.getElementById("end_date").innerHTML =$('input[id="'+std_arr[op]+'"]').val() + "  (" +gap+"일)";
	}
	
	// 품의 완료일 이전 일자 설정 시 그 후 단계 설정되어있는 일정 초기화
	for(i = op+1; i < 6; i++){
		$('input[id="'+std_arr[i]+'"]').val("");
		$('input[id="st_'+std_arr[i]+'"]').val("");
	}
	
	$('input[id="st_'+std_arr[op]+'"]').val(input_date);
}

//팝업함수호출
function doPop(str, value1) {
	popupSel = str;

	switch (str) {
		case "fileUpload": //파일업로드
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_image_key").val()+"&TYPE=BURQ", "500,430,no");
			break;
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "fileUpload") {
		$("#st_image_key").val(code);
		$("#st_image_key_text").val(text);
	}
}
function setReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9)
{ 
  opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9);
  this.close();
}
</script> 

<style>
.PopNewBox{background-color:#fff; border-radius:5px; margin-top:10px;}
.PopTableBox{display:block; margin:0px 15px; padding-bottom:10px;  }
.PopTitle_s {display:block; margin-bottom:5px; height:46px;line-height:50px; padding-left:15px;  font-size:16px; font-weight:bold; letter-spacing:-1.5px; color:#000; border-bottom:0px solid #eaeaea  }
.PopTitle_s b{ font-size:16px;line-height:46px; margin-right:5px;}
.PopTitle_ss{float:right; margin-right:15px; margin-top:10px; width:30px; height:30px; line-height:30px; font-size:30px; letter-spacing:-1px;color:#000; text-align:center; border-radius:50px; background-color:#fff}
.desc{font-size:11px;font-weight:lighter;}
</style>
<body onLoad="kep_onload_view()">
	<div id="popWrapper" >
		<div id="popHeader">
		   	<h1 class="title">벌크소싱 프로젝트 신규등록</h1>
		    <p class="popClose"><a href="javascript:self.close()">
 			    <img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
		    </a></p>
		</div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="background-color:#f5f5f5"  >
        	<div class="btnArea"> 
				<span class="fr">
					<span class="btn_03 mr04"><a href="javascript:doAction('save')">등록</a></span>			
				</span>
			</div>
			<form id="masterMpRqBulkQuotationNewProjectPop" name="masterMpRqBulkQuotationNewProjectPop" method="post">
				<input type="hidden" id="st_sheet" name="st_sheet" value="1">
				<input type="hidden" id="s_SAVENAME" name="s_SAVENAME" value="">
				<input type="hidden" id="st_add_user_id" name="st_add_user_id" value="<%=user_id %>">
				<input type="hidden" id="st_burq_no" name="st_burq_no" value="">
				<div class="scrollArea" style="height:730px;padding:0 10px 0 0">
		            <div  class="PopNewBox">
		                <a href="javascript:divShowHide('0');"><div class="PopTitle_s"><b id="show0"></b>프로젝트 기본정보&nbsp;&nbsp;<span class="desc">프로젝트 기본 정보를 입력해주세요.</span> <span class="PopTitle_ss" id="btn0"></span></div></a>
		                
		                 <div id="div0" class="PopTableBox"> 
		                    <table  class="cont_t_list06" summary="프로젝트 기본정보" style="width:100%;">
		                        <caption>프로젝트 기본정보</caption>
		                        <colgroup>
		                            <col width="15%" />
		                            <col width="35%" />
		                            <col width="15%" />
		                            <col width="35%" />
		                        </colgroup>
		                        <tbody>
		                        <tr style="height:30px"> 
		                            <th scope="row" class="center">프로젝트명</th>
		                            <td scope="row" class="center"><input type="text" id="st_project_name" name="st_project_name"  style="width:180px" value=""> </td>
		                            <th scope="row" class="center">프로젝트 유형</th>
		                            <td scope="row" class="left">재계약 <input type="hidden" id="st_project_type" name="st_project_type" value="A"></td>
		                        </tr>
		                        <tr style="height:30px">
		                            <th scope="row" class="center">사업부서</th>
		                            <td scope="row" class="center">
		                            	<select id="st_kep_dept" name="st_kep_dept" style="width:180px;height:20px">
		                            	</select>
		                            </td>
		                            <th scope="row" class="center">소싱단위</th>
		                            <td scope="row" class="left">
		                            	<label><input type="radio" name="st_project_unit" value="B">&nbsp;고객사</label>&nbsp;&nbsp;
		                            	<label><input type="radio"  name="st_project_unit" value="G">&nbsp;그룹사</label>
		                            </td>
		                        </tr>
		                        <tr style="height:30px">
		                            <th scope="row" class="center">PM</th>
		                            <td scope="row" class="center">
		                            	<select id="st_project_mng_user" name="st_project_mng_user" style="width:180px;height:20px"></select>
		                            </td>
		                            <th scope="row" class="center">소싱 대상</th>
		                            <td scope="row" class="left">
			                            <input type="hidden" id="st_image_key" name="st_image_key" value="" />
										<input type="hidden" id="st_image_key_Text" name="st_image_key_Text"  value="" />
		                            	<span class="btn_gray_03"  title="파일첨부" ><a href="javascript:doPop('fileUpload','')">파일 첨부</a></span>
		                            </td>
		                        </tr>
		                        </tbody>
		                   </table> 
		                </div>
		        	</div>
		            <div  class="PopNewBox" >
		                <a href="javascript:divShowHide('1');"><div class="PopTitle_s"><b id="show1"></b> 프로젝트 기간&nbsp;&nbsp;<span class="desc">프로젝트 일정을 입력해주세요.</span> <span class="PopTitle_ss" id="btn1"></span></div></a>
		                <div id="div1" class="PopTableBox"> 
		                    <table  class="cont_t_list06 mb15" summary="프로젝트 기간" style="width:100%;">
		                        <caption>프로젝트 기간</caption>
		                        <colgroup>
		                            <col width="50%" />
		                            <col width="50%" />
		                        </colgroup>
		                        <tbody>
		                            <tr> 
		                                <th scope="row" class="center">분류</th>
		                                <th scope="row" class="center">추진일정</th>
		                            </tr>
		                            <tr style="height:30px">
		                                <td class="center" style="background-color:#e1f0d0">SG분류 개시</td>
		                                <td class="center">
		                                	<input type="text" class="input_type_text" name="sg_start_schd_date" id="sg_start_schd_date" readOnly style="width:180px;  height:21px; text-align:center; margin-bottom:2px" value="">
	                                		<input type="hidden" id="st_sg_start_schd_date" name="st_sg_start_schd_date"  value="" />
		                                </td>
		                            </tr>
		                            <tr style="height:30px">
		                                <td class="center"  style="background-color:#e1f0d0">소싱 개시</td>
		                                <td class="center">
		                                	<input type="text" class="input_type_text" name="rfq_start_schd_date" id="rfq_start_schd_date" readOnly style="width:180px;  height:21px; text-align:center; margin-bottom:2px" value="">
		                                	<input type="hidden" id="st_rfq_start_schd_date" name="st_rfq_start_schd_date"  value="" />
	                                	</td>
		                            <tr style="height:30px">
		                                <td class="center"  style="background-color:#e1f0d0">견적 마감</td>
		                                <td class="center">
		                                	<input type="text" class="input_type_text" name="rfq_end_schd_date" id="rfq_end_schd_date" readOnly style="width:180px;  height:21px; text-align:center; margin-bottom:2px" value="">
		                                	<input type="hidden" id="st_rfq_end_schd_date" name="st_rfq_end_schd_date"  value="" />
		                                </td>
		                            </tr>
		                            <tr style="height:30px">
		                                <td class="center"  style="background-color:#e1f0d0">취합 완료</td>
		                                <td class="center">
		                                	<input type="text" class="input_type_text" name="rfq_merge_schd_date" id="rfq_merge_schd_date" readOnly style="width:180px;  height:21px; text-align:center; margin-bottom:2px" value="">
		                                	<input type="hidden" id="st_rfq_merge_schd_date" name="st_rfq_merge_schd_date"  value="" />	
	                                	</td>
		                            </tr>
		                            <tr style="height:30px">
		                                <td class="center"  style="background-color:#e1f0d0">사업팀 제출</td>
		                                <td class="center">
		                                	<input type="text" class="input_type_text" name="rfq_submit_schd_date" id="rfq_submit_schd_date" readOnly style="width:180px;  height:21px; text-align:center; margin-bottom:2px" value="">
											<input type="hidden" id="st_rfq_submit_schd_date" name="st_rfq_submit_schd_date"  value="" />			                                
		                                </td>
		                            </tr>
		                            <tr style="height:30px">
		                                <td class="center"  style="background-color:#e1f0d0">품의 완료</td>
		                                <td class="center">
		                                	<input type="text" class="input_type_text" name="rfq_approval_schd_date" id="rfq_approval_schd_date" readOnly style="width:180px;  height:21px; text-align:center; margin-bottom:2px" value="">
		                                	<input type="hidden" id="st_rfq_approval_schd_date" name="st_rfq_approval_schd_date"  value="" />	
		                                </td>
		                            </tr>
		                            <tr style="height:30px">
		                                <th class="center">전체 일정</td>
		                                <th class="center"><span id ="start_date"></span>&nbsp;&nbsp;&nbsp;&nbsp;ㅡ&nbsp;&nbsp;&nbsp;&nbsp;<span id = "end_date"></span></th>
		                            </tr>
		                          </tbody>
		                     </table> 	                     
		                </div>
		            </div>
	            	<div class="PopNewBox" >
						<a href="javascript:divShowHide('2');"><div class="PopTitle_s"><b id="show2"></b>고객사 정보<span class="PopTitle_ss" id="btn2"></span></div></a>
						<div id="div2" class="PopTableBox" style="overflow: hidden"> 
							<span class="fr">
								<span class="btn_06 mr04"><a href="javascript:doAction('downForm');">양식 다운로드</a></span>
								<span class="btn_06 mr04"><a href="javascript:doAction('loadExcel');">엑셀 업로드</a></span>
							</span>
							<br><br>
							<div style="border-top:2px solid #3c639c; left:0;">
		                        <script type="text/javascript">
		                            createIBSheet("mySheet", "100%", "390px");
		                        </script>
		                    </div>
		                    <br>
           					<span class="fr">
								<span class="btn_08 mr04"><a href="javascript:doAction('downExcel');">조회결과 다운로드</a></span>
							</span>
		                </div>
	        		</div>
		            <div class="PopNewBox" >
						<a href="javascript:divShowHide('3');"><div class="PopTitle_s"><b id="show3"></b>소싱 유의사항&nbsp;&nbsp;<span class="desc">(최대 5개 입력가능)</span><span class="PopTitle_ss" id="btn3" ></span></div></a>
						<div id="div3" class="PopTableBox"> 
							<b>1. SM 유의사항</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	SM이 소싱 시 유의해야할 사항에 대해 기재해주세요
							<span class="fr">
								<span class="btn_02 mr04"><a href="javascript:doAction('insert1');">행추가</a></span>
								<span class="btn_02 mr04"><a href="javascript:doAction('del1');">삭제</a></span>
							</span>
							<br><br>
		                 	<div style="border-top:2px solid #3c639c; left:0;">
		                        <script type="text/javascript">
		                            createIBSheet("mySheet2", "100%", "140px");
		                        </script>
							</div>
							<br><br>
		                	<b>2. 협력사 안내사항</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;협력사에 전달할 안내사항을 기재해주세요.
	                		<span class="fr">
								<span class="btn_02 mr04"><a href="javascript:doAction('insert2');">행추가</a></span>
								<span class="btn_02 mr04"><a href="javascript:doAction('del2');">삭제</a></span>
							</span>
							<br><br>
							<div style="border-top:2px solid #3c639c; left:0;">
		                        <script type="text/javascript">
		                            createIBSheet("mySheet3", "100%", "140px");
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
