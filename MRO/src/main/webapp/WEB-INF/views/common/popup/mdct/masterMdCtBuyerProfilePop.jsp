<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 프로파일 팝업
* 기능 : 고객사 프로파일 등록, 수정
* 프로그램 ID :
* 담당자 : HSJ ( 설계 : HMH )
* 착수일 : 2022-11-08
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>

<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

String userID = _sessionInfo.getUserId();
String org_code=  CommonUtil.nvl((String) request.getParameter("org_code"), "");

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}
%>

<script type="text/javascript">
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var gridIndex = 0;
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var button_flag = ""; // S-최초등록, C-저장, R-재계약

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
					 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus"}
					,{ Align:"Center",	Width:40,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",			SaveName:"SELECTED",	Sort:0}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사코드",	SaveName:"COM_CODE",	BackColor:"${notnullColor}"}
					,{ Align:"Left",	Width:380,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사명",		SaveName:"COM_NAME_LOC"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"사업자번호",	SaveName:"IRS_NO"}
					,{ Align:"Center",	Width:180,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"대표자명",		SaveName:"CEO_NAME_LOC"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]

	kepSetCalender("contract_first_date");
	kepSetCalender("contract_start_date");
	kepSetCalender("contract_end_date");
	kepSetCalender("contract_validity_date");
	kepSetCalender("contract_start");
	kepSetCalender("contract_end");

	var initsheet2 = {};
	initsheet2.Cols = [
					 { Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"방문일시",		SaveName:"CSTMR_VISIT_DATE"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"방문유형",		SaveName:"VISIT_TYPE_NM"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"방문자",		SaveName:"USER_NAME_LOC"}
					,{ Align:"Left",	Width:400,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"활동결과",		SaveName:"VISIT_NOTE"}
					,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"첨부",		SaveName:"IMAGE_FLAG"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"첨부파일",		SaveName:"IMAGE_KEY"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"등록일자",		SaveName:"ADD_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"등록시간",		SaveName:"ADD_TIME"}
	];
	
	IBS_InitSheet(mySheet2, initsheet2, pagingMode);
	mySheet2.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	
	//하이퍼링크 설정
	setLinkCol(mySheet2, "VISIT_NOTE");
	
	//파일첨부이미지설정
	mySheet2.SetImageList(0, diskOff);
	mySheet2.SetImageList(1, diskOn);
	
	doAction('search');
}

//팝업함수호출
function doPop(str, value1) {
	popupSel = str;
	
	switch (str) {
		case "contract_attach":
			popupSel = "contract_attach";
			var type="RFQ";
			var viewType="VI";
			var value = document.contentForm.st_contract_image_key.value;
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
		,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
		,value21,value22,value23,value24,value25,value26,value27,value28,value29){
	//팝업 조회후 해당 항목에 값을 셋팅
	if(popupSel == "contract_attach") {
		 $("input[name=st_contract_image_key]").eq(gridIndex).val(value1);
	 	 if(value1 ==""){
			 $("img[id=st_contract_image_key_img]").eq(gridIndex).attr("src",diskOff);
	 	 }else{
			 $("img[id=st_contract_image_key_img]").eq(gridIndex).attr("src",diskOn);
	 	 }
	}else if(popupSel == "buyerMulti") {	//고객사선택
		mySheet.SetCellValue(grbRow, 'COM_CODE', value1);
		mySheet.SetCellValue(grbRow, 'COM_NAME_LOC', value2);
		mySheet.SetCellValue(grbRow, 'IRS_NO', value7);
		mySheet.SetCellValue(grbRow, 'CEO_NAME_LOC', value8);
	}
	popupSel = "";
	grbRow="";	//초기화
}
 
var st;
var mt;

//기능함수
function doAction(str, flag) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	var maxRow = mySheet.RowCount();
	button_flag = flag;
	
	if (str =="del"  && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	switch (str) {
		case "search":
			current_page = -1;
			kepSearch(document.searchForm, mySheet, "/mdct/getMasterMdCtBuyerProfileMappingList.do", pagingMode);
			kepSearch(document.searchForm, mySheet2, "/mdct/getMasterMdCtBuyerProfileCardList.do" , pagingMode );
			break;
			
		case "del":
			if (confirm("선택한 고객사 매핑건을 삭제하시겠습니까?")) {
				kepSave(document.contentForm, mySheet, "/mdct/delMasterMdCtBuyerProfileMappingList.do", "SELECTED");
			}
			break;
			
		case "save":
			if (checkSubmit()) {
				if (button_flag == "S") { // 최초등록
					if (confirm("등록하시겠습니까?")) {
						if(maxRow == 0){
							kepAjaxFormCall("/mdct/regMasterMdCtBuyerProfilePopList.do","contentForm","CREATE");	  
						}else{
							kepSaveAll(document.contentForm, mySheet, "/mdct/regAllMasterMdCtBuyerProfilePopList.do");	
						}
					}
				}else if (button_flag == "C") { // 저장
					if (confirm("저장하시겠습니까?")) {
						if(maxRow == 0){
							kepAjaxFormCall("/mdct/saveMasterMdCtBuyerProfilePopList.do","contentForm","CREATE");
						}else{
							kepSaveAll(document.contentForm, mySheet, "/mdct/saveAllMasterMdCtBuyerProfilePopList.do");
						}
					}
				}else if (button_flag == "R") { // 재계약
					if (confirm("재계약 등록하시겠습니까?")) {
						kepAjaxFormCall("/mdct/regMasterMdCtBuyerReContractList.do","contentForm","CREATE");
					}
				}
			}
			break;
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	var new_com_code = mySheet.GetCellValue(Row,"COM_CODE");
	
	if (column == 'COM_CODE' && new_com_code == '') { //고객사코드
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N&AUTH=ALL", "500,466,no");
		popupSel = "buyerMulti";
		
	}
	return;
}

//그리드 셀클릭 이벤트
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	var val1 = mySheet2.GetCellValue(Row,"BUYER");
	var val2 = mySheet2.GetCellValue(Row,"ADD_DATE");
	var val3 = mySheet2.GetCellValue(Row,"ADD_TIME");
	
	if (column == 'VISIT_NOTE') { //활동결과
		openSearchPopup("/mdcd/showMasterMdCdPrimaryActivityDetailRegPop.do", "?com_code=" + val1 + "&add_date=" + val2 + "&add_time=" + val3, "1000, 500,no");
		popupSel = "visitnote";
	}
	return;
}

function mySheet_OnChange(Row, Col, Value) {
	if ( Row  < 1) return;
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
}

//그리드 표시후 처리	 
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
}

//조회 후처리
function mySheet2_OnSearchEnd(code, msg, stCode) {
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
	
	if (code > 0) {
		if (button_flag == "S"){
			alert("등록 완료");
			opener.setPopupReturn("CREATE","");
			self.close();
		}else{
			alert("저장 완료");
			opener.setPopupReturn("CREATE","");
			self.close();
		}
	}else{
		alert(msg);
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;    
	if (pMethod == "CREATE") {
		if (sMsg == 'OK') {
			if (button_flag == "S"){
				alert("등록 완료");
				opener.setPopupReturn("CREATE","");
				self.close();
			}else if(button_flag == "R") {
				alert("등록 완료");
				var org_name = $("#st_org_name").val();
					var param = encodeURI("search_yn=Y&org_name="+org_name);
				    opener.parent.tab("재계약 관리","/mdct/showMasterMdCtBuyerReContract.do?" + param, "Y");
				    self.close();
			}else{
				alert("저장 완료");
				opener.setPopupReturn("CREATE","");
				self.close();
			}
		}
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
} 

//TABLE의 ROW 데이타 생성
function addrows() {
	var rows = mySheet.DataInsert(-1);
	mySheet.SetCellValue(rows, 'SELECTED', "1");
}

function checkSubmit(flag) {
	
	if (isEmpty($("#st_org_name").val())) {
        alert("사업장명을 입력해주세요.");
        $("#st_org_name").focus();
        return false;
	}

	if (isEmpty($("#contract_first_date").val())) {
		alert("최초계약일을 선택하여 주십시요.");
		$("#contract_first_date").focus();
		return false;
	}
	
	if (isEmpty($("#contract_start_date").val())) {
		alert("현재계약 시작일을 선택하여 주십시요.");
		$("#contract_start_date").focus();
		return false;
	}
	
	if (isEmpty($("#contract_end_date").val())) {
		alert("현재계약 종료일을 선택하여 주십시요.");
		$("#contract_end_date").focus();
		return false;
	}
	
	if (isEmpty($("#contract_validity_date").val())) {
		alert("단가계약유효일자를 선택하여 주십시요.");
		$("#contract_validity_date").focus();
		return false;
	}
	
	if (isEmpty($("#st_contract_type").val())) {
		alert("계약유형을 선택하여 주십시요.");
		$("#st_contract_type").focus();
		return false;
	}
	
	if (isEmpty($("#st_process_status").val())) {
		alert("진행상태를 선택하여 주십시요.");
		$("#st_process_status").focus();
		return false;
	}
	
	if (isEmpty($("#st_contract_kind").val())) {
		alert("계약구분을 선택하여 주십시요.");
		$("#st_contract_kind").focus();
		return false;
	}
	
	if (isEmpty($("#st_contract_image_key").val())) {
		alert("계약서 등록하여 주십시요.");
		$("#st_contract_image_key_img").focus();
		return false;
	}

	if (isEmpty($("#st_sales_map_image_dir").val())) {
		alert("영업Map 이미지파일 등록하여 주십시요.");
		return false;
	}
	
	if (isEmpty($("#st_org_chart_image_dir").val())) {
		alert("조직도 이미지파일 등록하여 주십시요.");
		return false;
	}
	
	if (isEmpty($("#st_sys_process_image_dir").val())) {
		alert("시스템프로세스 이미지파일 등록하여 주십시요.");
		return false;
	}
	
	$("#st_contract_first_date").val($("#contract_first_date").val().replace(/[/]/gi,""));
	$("#st_contract_start_date").val($("#contract_start_date").val().replace(/[/]/gi,""));
	$("#st_contract_end_date").val($("#contract_end_date").val().replace(/[/]/gi,""));
	$("#st_contract_validity_date").val($("#contract_validity_date").val().replace(/[/]/gi,""));
	
	if (button_flag == "R") {
		if (isEmpty($("#contract_start").val())) {
			alert("계약시작일을 선택하여 주십시요.");
			$("#contract_start").focus();
			return false;
		}
		
		if (isEmpty($("#contract_end").val())) {
			alert("계약종료일을 선택하여 주십시요.");
			$("#contract_end").focus();
			return false;
		}
		$("#st_contract_start").val($("#contract_start").val().replace(/[/]/gi,""));
		$("#st_contract_end").val($("#contract_end").val().replace(/[/]/gi,""));
	}

	return true;
}

//이미지 미리보기
function preview_image(img, str) {
	popupSel = str;
	
	var fileName = "";
	
	if(popupSel == "preview_sales_map"){
		fileName = $("#files1").val();
	}else if(popupSel == "preview_org_chart"){
		fileName = $("#files2").val();
	}else if(popupSel == "preview_sys_process"){
		fileName = $("#files3").val();
	}
	
	var dot = fileName.lastIndexOf(".");
	var ext = fileName.substring(dot).toLowerCase();
	
	if (ext != ".jpg" && ext != ".jpeg" && ext != ".gif" && ext != ".png"){
		alert("이미지 업로드 할 수 없는 확장자 입니다.");
		return;
	}
	
	$("#contentForm").attr("target","account_work");
	
	if(popupSel == "preview_sales_map"){
		$("#contentForm").attr("action","/mdct/addMasterMdCtBuyerProfileSalesImagePop.do").submit();
	}else if(popupSel == "preview_org_chart"){
		$("#contentForm").attr("action","/mdct/addMasterMdCtBuyerProfileOrgImagePop.do").submit();
	}else if(popupSel == "preview_sys_process"){
		$("#contentForm").attr("action","/mdct/addMasterMdCtBuyerProfileSysImagePop.do").submit();
	}
	
}

function setImageView(img_dr,img_name){
	if(img_name == "icon_emptyimg.gif"){
		alert("등록된 이미지가 없습니다.");
		return;		
	}else{
		var st_img_dr = img_dr+img_name;
		window.open(st_img_dr,'catalogImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=700,height=700');
	}
}

function upSet(docNo){
	loader_obj("N");
	var dir_name = docNo.substring(0,20); // ex) BUYER_PROFILE/YYYYMM
	var file_name = docNo.substring(21, docNo.length); // ex) YYYYMMDDHHMISS.jpg

	if(popupSel == "preview_sales_map") {	// 영업Map
		$("#st_sales_map_image_dir").val(dir_name);
		$("#st_sales_map_image_name").val(file_name);
	}else if(popupSel == "preview_org_chart"){
		$("#st_org_chart_image_dir").val(dir_name);
		$("#st_org_chart_image_name").val(file_name);
	}else if(popupSel == "preview_sys_process"){
		$("#st_sys_process_image_dir").val(dir_name);
		$("#st_sys_process_image_name").val(file_name);
	}
	
	var dest = "";
	if(popupSel == "preview_sales_map"){
		$("#image1").attr("src","");
		dest = document.getElementById("image1");
		dest.src = "<%=CommonUtil.realImgS3UploadPath%>" + "/" + dir_name + "/" + file_name;
	}else if(popupSel == "preview_org_chart"){
		$("#image2").attr("src","");
		dest = document.getElementById("image2");
		dest.src = "<%=CommonUtil.realImgS3UploadPath%>" + "/" + dir_name + "/" + file_name;
	}else if(popupSel == "preview_sys_process"){
		$("#image3").attr("src","");
		dest = document.getElementById("image3");
		dest.src = "<%=CommonUtil.realImgS3UploadPath%>" + "/" + dir_name + "/" + file_name;
	}
	
	popupSel = "";
	return;
}
</script> 
</head>
<body onload="kep_onload_view();" style="overflow-y: hidden;">
<iframe name="account_work" id="account_work" style="display:none;" scrolling="no" frameborder="0" width="100%" height="100%"></iframe>

<form name="searchForm" id="searchForm" method=post>
<input type="hidden" id="st_user_id" name="st_user_id" value="<%=userID%>"/>
<input type="hidden" id="st_org_code" name="st_org_code" value="<%=org_code%>"/>
<input type="hidden" id="s_SAVENAME" name="s_SAVENAME"/>
<input type="hidden" id="pageflag" name="pageflag" value="1"/>
</form>

<form name="contentForm" id="contentForm" method=post modelAttribute="uploadForm" enctype="multipart/form-data">
<input type="hidden" id="s_SAVENAME" name="s_SAVENAME" />
<input type="hidden" id="st_user_id" name="st_user_id" value="<%=userID%>"/>
<input type="hidden" id="st_org_code" name="st_org_code" value="<%=org_code%>"/>
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:700px;">
		<div id="popHeader">
			<h1 class="title">고객사 프로파일 </h1>
		</div>
        
        <!--팝업내용입니다-->
		<div id="popContainer">
			<div class="scrollArea" style="height:650px;">
				<p style="font-weight:bold;">[사업장 정보]</P>
				<table class="cont_t_list06" style="width:100%;">
					<caption>고객사 프로파일</caption>
					<colgroup>
						<col width="17%" />
						<col width="33%" />
	                    <col width="17%" />
	                    <col width="33%" />
					</colgroup>

					<tbody>
<% if (_rowData != null) { %> <!-- 리스트 조회 -->
						<tr>
							<th class="star" scope="row">사업장명</th>
	                        <td><input type="text" id="st_org_name" name="st_org_name" class="input_type_text" title=""  maxlength="50" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("ORG_NAME"))%>"  onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);"/></td>
	                        <th class="star" scope="row">최초계약일</th>
	                        <td>
	                        	<input type="text" id="contract_first_date" name="contract_first_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("CONTRACT_FIRST_DATE"))%>" />
	                      		<input type="hidden" id="st_contract_first_date" name="st_contract_first_date"  value="<%=CommonUtil.nvl(_rowData.get("CONTRACT_FIRST_DATE"))%>" />
	                        </td>
						</tr>
						
						<tr>
	                        <th scope="row" class="star">현재계약 시작일</th>
	                      	<td>
	                      		<input type="text" id="contract_start_date" name="contract_start_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("CONTRACT_START_DATE"))%>" />
	                      		<input type="hidden" id="st_contract_start_date" name="st_contract_start_date"  value="<%=CommonUtil.nvl(_rowData.get("CONTRACT_START_DATE"))%>" />
	                      	</td>
	                        <th scope="row" class="star">현재계약 종료일</th>
	                      	<td>
	                      		<input type="text" id="contract_end_date" name="contract_end_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("CONTRACT_END_DATE"))%>" />
	                      		<input type="hidden" id="st_contract_end_date" name="st_contract_end_date"  value="<%=CommonUtil.nvl(_rowData.get("CONTRACT_END_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">단가계약유효일자</th>
	                        <td>
	                      		<input type="text" id="contract_validity_date" name="contract_validity_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("CONTRACT_VALIDITY_DATE"))%>" />
	                      		<input type="hidden" id="st_contract_validity_date" name="st_contract_validity_date"  value="<%=CommonUtil.nvl(_rowData.get("CONTRACT_VALIDITY_DATE"))%>" />
	                      	</td>
	                      	<th scope="row" class="star">계약유형</th>
	                      	<td>
	                      		<select id="st_contract_type" name="st_contract_type" style="width:40%;">
									<script>kepAjaxCommonComboDataValue('st_contract_type', 'CTTP', 'SEL', '<%=CommonUtil.nvl(_rowData.get("CONTRACT_TYPE"))%>');</script>
								</select>
                      		</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">진행상태</th>
	                        <td>
	                      		<select id="st_process_status" name="st_process_status" style="width:40%;">
									<script>kepAjaxCommonComboDataValue('st_process_status', 'PFST', 'SEL', '<%=CommonUtil.nvl(_rowData.get("PROCESS_STATUS"))%>');</script>
								</select>
	                      	</td>
	                      	<th scope="row" class="star">계약구분</th>
	                      	<td>
	                      		<select id="st_contract_kind" name="st_contract_kind" style="width:40%;">
									<script>kepAjaxCommonComboDataValue('st_contract_kind', 'PFTP', 'SEL', '<%=CommonUtil.nvl(_rowData.get("CONTRACT_KIND"))%>');</script>
								</select>
                      		</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">계약서</th>
	                        <td>
	                        	<input type="hidden" name="st_contract_image_key" id="st_contract_image_key" value="<%=CommonUtil.nvl(_rowData.get("CONTRACT_IMAGE_KEY"))%>">
	                        	<a class="hyperLink" href="javascript:doPop('contract_attach', '')">
	                        	<%if(("").equals(CommonUtil.nvl(_rowData.get("CONTRACT_IMAGE_KEY")))){%>
	                        		<img id = "st_contract_image_key_img" name = "st_contract_image_key_img" src="/resources/images/disk_off.gif" border="0">
	                        	<%}else{%>
	                        		<img id = "st_contract_image_key_img" name = "st_contract_image_key_img" src="/resources/images/disk_on.gif" border="0">
	                        	<%}%>
	                        	</a>
	                      	</td>
	                        <th scope="row">계약유형 특이사항</th>
	                      	<td><input type="text" id="st_contract_note" name="st_contract_note" class="input_type_text" title=""  maxlength="1000" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("CONTRACT_NOTE"))%>"  onkeyup="fnCheckInputByte(this, 1000);" onchange="fnCheckInputByte(this, 1000);"/></td>
	                    </tr>
					</tbody>
				</table>
				<br>
				<p style="font-weight:bold;">[사업장 프로세스]</P>
				<table class="cont_t_list06" style="width:100%;">
					<caption>고객프로세스MAP</caption>
					<colgroup>
						<col width="50%" />
						<col width="50%" />
					</colgroup>
					<tbody>
	                    <tr>
	                        <th class="star" style="height:30px; text-align:center">영업Map</th>
                            <th class="star" style="text-align:center" >조직도</th>
	                    </tr>
                        <tr> 
                            <td style="height:400px; border-right:1px solid #e0e0e0 ">
	                         	<%
                         		String image_dr1  = _rowData.get("SALES_MAP_IMAGE_DIR");
								String image_sm1 = _rowData.get("SALES_MAP_IMAGE_NAME");
								
								if (image_sm1 == null || image_sm1.equals("null") || image_sm1.equals("") || image_sm1.equals(" ")){
									image_sm1 = "icon_emptyimg.gif";
								}
								
								if(image_sm1.equals("icon_emptyimg.gif")) {
								%>
									<img src = "/resources/images/<%=image_sm1%>"  id="image1" name="image1" width="400" height="400">
								<%}else{%>
									<a href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+image_dr1+"/"%>','<%=image_sm1%>')" >
										<img src = "<%=CommonUtil.realImgS3UploadPath+"/"+image_dr1+"/"+image_sm1%>"   id="image1" name = "image1" width="400" height="400" border="0">
									</a>
								<%}%>
								
								<input type="hidden" name="st_sales_map_image_dir" id="st_sales_map_image_dir" value="<%=CommonUtil.nvl(_rowData.get("SALES_MAP_IMAGE_DIR"))%>" />
								<input type="hidden" name="st_sales_map_image_name" id="st_sales_map_image_name" value="<%=CommonUtil.nvl(_rowData.get("SALES_MAP_IMAGE_NAME"))%>" />
								<br>
								<label for="files1"><div class="btn_gray_03">파일선택</div></label>
								<input name="files1" id="files1" type="file" onchange="preview_image(this.value, 'preview_sales_map');" value="" style="width:200px; display:none;"/>										
                      		</td>
	                        <td style="height:400px;">

	                        	<%
                         		String image_dr2  = _rowData.get("ORG_CHART_IMAGE_DIR");
								String image_sm2 = _rowData.get("ORG_CHART_IMAGE_NAME");
								
								if (image_sm2 == null || image_sm2.equals("null") || image_sm2.equals("") || image_sm2.equals(" ")){
									image_sm2 = "icon_emptyimg.gif";
								}
								
								if(image_sm2.equals("icon_emptyimg.gif")) {
								%>
									<img src = "/resources/images/<%=image_sm2%>"  id="image2" name="image2" width="400" height="400">
								<%}else{%>
									<a href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+image_dr2+"/"%>','<%=image_sm2%>')" >
										<img src = "<%=CommonUtil.realImgS3UploadPath+"/"+image_dr2+"/"+image_sm2%>"   id="image2" name = "image2" width="400" height="400" border="0">
									</a>
								<%}%>
								
								<input type="hidden" name="st_org_chart_image_dir" id="st_org_chart_image_dir" value="<%=CommonUtil.nvl(_rowData.get("ORG_CHART_IMAGE_DIR"))%>" />
								<input type="hidden" name="st_org_chart_image_name" id="st_org_chart_image_name" value="<%=CommonUtil.nvl(_rowData.get("ORG_CHART_IMAGE_NAME"))%>" />
	                        	<br>
	                        	<label for="files2"><div class="btn_gray_03">파일선택</div></label>
								<input name="files2" id="files2" type="file" onchange="preview_image(this.value, 'preview_org_chart');" value="" style="width:75px; display:none;"/>										
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th class="star" style="height:30px;text-align:center">시스템프로세스</th>
	                      	<th style="text-align:center"> </th>
	                    </tr>
	                    <tr>
	                      	<td style="height:400px;border-right:1px solid #e0e0e0 ">
	                      		<%
                         		String image_dr3  = _rowData.get("SYS_PROCESS_IMAGE_DIR");
								String image_sm3 = _rowData.get("SYS_PROCESS_IMAGE_NAME");
								
								if (image_sm3 == null || image_sm3.equals("null") || image_sm3.equals("") || image_sm3.equals(" ")){
									image_sm3 = "icon_emptyimg.gif";
								}
								
								if(image_sm3.equals("icon_emptyimg.gif")) {
								%>
									<img src = "/resources/images/<%=image_sm3%>"  id="image3" name="image3" width="400" height="400">
								<%}else{%>
									<a href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+image_dr3+"/"%>','<%=image_sm3%>')" >
										<img src = "<%=CommonUtil.realImgS3UploadPath+"/"+image_dr3+"/"+image_sm3%>"   id="image3" name = "image3" width="400" height="400" border="0">
									</a>
								<%}%>
								
								<input type="hidden" name="st_sys_process_image_dir" id="st_sys_process_image_dir" value="<%=CommonUtil.nvl(_rowData.get("SYS_PROCESS_IMAGE_DIR"))%>" />
								<input type="hidden" name="st_sys_process_image_name" id="st_sys_process_image_name" value="<%=CommonUtil.nvl(_rowData.get("SYS_PROCESS_IMAGE_NAME"))%>" />
	                        	<br>
	                        	<label for="files3"><div class="btn_gray_03">파일선택</div></label>
								<input name="files3" id="files3" type="file" onchange="preview_image(this.value, 'preview_sys_process');" value="" style="width:200px; display:none;"/>										
                      		</td>
							<td></td>
	                    </tr>
					</tbody>
				</table>
<% } else { %> <!-- 최초등록 -->
						<tr>
							<th class="star" scope="row">사업장명</th>
	                        <td><input type="text" id="st_org_name" name="st_org_name" class="input_type_text" title=""  maxlength="50" style="width:90%;" value=""  onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);"/></td>
	                        <th class="star" scope="row">최초계약일</th>
	                        <td>
	                        	<input type="text" id="contract_first_date" name="contract_first_date" class="input_type_text" title="" style="width:80px;" readOnly value="" />
	                      		<input type="hidden" id="st_contract_first_date" name="st_contract_first_date"  value="" />
	                        </td>
						</tr>
						
						<tr>
	                        <th scope="row" class="star">현재계약 시작일</th>
	                      	<td>
	                      		<input type="text" id="contract_start_date" name="contract_start_date" class="input_type_text" title="" style="width:80px;" readOnly value="" />
	                      		<input type="hidden" id="st_contract_start_date" name="st_contract_start_date"  value="" />
	                      	</td>
	                        <th scope="row" class="star">현재계약 종료일</th>
	                      	<td>
	                      		<input type="text" id="contract_end_date" name="contract_end_date" class="input_type_text" title="" style="width:80px;" readOnly value="" />
	                      		<input type="hidden" id="st_contract_end_date" name="st_contract_end_date"  value="" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">단가계약유효일자</th>
	                        <td>
	                      		<input type="text" id="contract_validity_date" name="contract_validity_date" class="input_type_text" title="" style="width:80px;" readOnly value="" />
	                      		<input type="hidden" id="st_contract_validity_date" name="st_contract_validity_date"  value="" />
	                      	</td>
	                      	<th scope="row" class="star">계약유형</th>
	                      	<td>
	                      		<select id="st_contract_type" name="st_contract_type" style="width:40%;">
									<script>kepAjaxCommonComboDataValue('st_contract_type', 'CTTP', 'SEL', '');</script>
								</select>
                      		</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">진행상태</th>
	                        <td>
	                      		<select id="st_process_status" name="st_process_status" style="width:40%;">
									<script>kepAjaxCommonComboDataValue('st_process_status', 'PFST', 'SEL', '');</script>
								</select>
	                      	</td>
	                      	<th scope="row" class="star">계약구분</th>
	                      	<td>
	                      		<select id="st_contract_kind" name="st_contract_kind" style="width:40%;">
									<script>kepAjaxCommonComboDataValue('st_contract_kind', 'PFTP', 'SEL', '');</script>
								</select>
                      		</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">계약서</th>
	                        <td>
	                        	<input type="hidden" name="st_contract_image_key" id="st_contract_image_key" value="">
	                        	<a class="hyperLink" href="javascript:doPop('contract_attach', '')">
	                        		<img id = "st_contract_image_key_img" name = "st_contract_image_key_img" src="/resources/images/disk_off.gif" border="0">
	                        	</a>
	                      	</td>
	                        <th scope="row">계약유형 특이사항</th>
	                      	<td ><input type="text" id="st_contract_note" name="st_contract_note" class="input_type_text" title=""  maxlength="1000" style="width:90%;" value=""  onkeyup="fnCheckInputByte(this, 1000);" onchange="fnCheckInputByte(this, 1000);"/></td>
	                    </tr>
					</tbody>
				</table>
				<br>
				<p style="font-weight:bold;">[사업장 프로세스]</P>
				<table class="cont_t_list06" style="width:100%;">
					<caption>고객프로세스MAP</caption>
					<colgroup>
						<col width="50%" />
						<col width="50%" />
					</colgroup>
					<tbody>
	                    <tr>
	                        <th class="star" style="height:30px; text-align:center">영업Map</th>
                            <th class="star" style="text-align:center" >조직도</th>
	                    </tr>
                        <tr> 
                            <td style="height:400px; border-right:1px solid #e0e0e0 ">
								<img src = "/resources/images/icon_emptyimg.gif"  id="image1" name="image1" width="400" height="400">
								<input type="hidden" name="st_sales_map_image_dir" id="st_sales_map_image_dir" value="" />
								<input type="hidden" name="st_sales_map_image_name" id="st_sales_map_image_name" value="" />
								<br>
								<label for="files1"><div class="btn_gray_03">파일선택</div></label>
								<input name="files1" id="files1" type="file" onchange="preview_image(this.value, 'preview_sales_map');" value="" style="width:200px; display:none;"/>										
                      		</td>
	                        <td style="height:400px;">
								<img src = "/resources/images/icon_emptyimg.gif"  id="image2" name="image2" width="400" height="400">
								<input type="hidden" name="st_org_chart_image_dir" id="st_org_chart_image_dir" value="" />
								<input type="hidden" name="st_org_chart_image_name" id="st_org_chart_image_name" value="" />
	                        	<br>
	                        	<label for="files2"><div class="btn_gray_03">파일선택</div></label>
								<input name="files2" id="files2" type="file" onchange="preview_image(this.value, 'preview_org_chart');" value="" style="width:75px; display:none;"/>										
	                      	</td>
	                    </tr>
                         <tr>
	                        <th class="star" style="height:30px;text-align:center">시스템프로세스</th>
                            <th style="text-align:center"> </th>
	                    </tr>
	                    
	                    <tr>
	                      	<td style="height:400px;border-right:1px solid #e0e0e0 ">
								<img src = "/resources/images/icon_emptyimg.gif"  id="image3" name="image3" width="400" height="400">
								<input type="hidden" name="st_sys_process_image_dir" id="st_sys_process_image_dir" value="" />
								<input type="hidden" name="st_sys_process_image_name" id="st_sys_process_image_name" value="" />
	                        	<br>
	                        	<label for="files3"><div class="btn_gray_03">파일선택</div></label>
								<input name="files3" id="files3" type="file" onchange="preview_image(this.value, 'preview_sys_process');" value="" style="width:200px; display:none;"/>										
                      		</td>
							<td></td>
					</tbody>
				</table>
			
<% } %>
				<p class="pt20" style="font-weight:bold;">[고객사 코드매핑]</P>
				<div class="ib_product" style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "100%", "150px");
					</script>
				</div>
				
				<p class="pt20" style="font-weight:bold;">[고객사 방문일지]</P>
				<div class="ib_product" style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet2", "100%", "182px");
					</script>
				</div>
				
<% if (_rowData != null) {  %> <!-- 리스트 조회 -->
				<p class="pt20" style="font-weight:bold;">[재계약 정보]</P>
				<table  class="cont_t_list06" style="width:100%;">
	                <caption>재계약 정보</caption>
	                <colgroup>
	                    <col width="20%" />
	                    <col width="30%" />
	                    <col width="20%" />
	                    <col width="30%" />
	                </colgroup>
	                <tbody>
						<tr>
							<th scope="row">계약시작일</th>
	                        <td>
	                        	<input type="text" id="contract_start" name="contract_start" class="input_type_text" title="" style="width:80px;" readOnly value="" />
	                      		<input type="hidden" id="st_contract_start" name="st_contract_start"  value="" />
	                        </td>
	                        <th scope="row">계약종료일</th>
	                        <td>
	                        	<input type="text" id="contract_end" name="contract_end" class="input_type_text" title="" style="width:80px;" readOnly value="" />
	                      		<input type="hidden" id="st_contract_end" name="st_contract_end"  value="" />
	                        </td>
						</tr>
						<tr>
							<th scope="row">모수금액</th>
	                      	<td><input type="text" id="st_par_amount" name="st_par_amount" class="input_type_text" title="" style="width:52%;" value=""/></td>
	                        <th scope="row"></th>
	                      	<td></td>
	                    </tr>
					</tbody>
				</table>	
<% } %>
			</div>
			
			<!--버튼영역-->
			<p class="btnArea mt10 mb05">
				<span class="btn_02 mr04"><a href="javascript:addrows();">행추가</a></span>
				<span class="btn_02"><a href="javascript:doAction('del');">행삭제</a></span>
<% if (_rowData != null) { %> <!-- 리스트 조회 -->
				<span class="btn_02"><a href="javascript:doAction('save','R');">재계약</a></span>
				<span class="btn_02"><a href="javascript:doAction('save','C');">저장</a></span>
<% } else { %> <!-- 최초등록 -->
				<span class="btn_02"><a href="javascript:doAction('save','S');">등록</a></span>
<% } %>
			</p>
		</div>
	</div>
</form> 
</body>
</html>
