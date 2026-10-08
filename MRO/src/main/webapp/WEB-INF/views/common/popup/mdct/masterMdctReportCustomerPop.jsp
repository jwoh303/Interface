<%--
**********************************************
* 메뉴 : 리포트 관리 등록
* 화면 : 리포트 관리 등록
* 기능 : 
* 프로그램 ID :
* 담당자 :
* 착수일 :
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
    SessionInfo _sessionInfo = (SessionInfo)request.getSession().getAttribute("sessionInfo");
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String userid = "";
	String userName = "";
	if (_sessionInfo != null){ 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
		userName = CommonUtil.nvl((String)_sessionInfo.getUserNameLoc());  	
	}
	String com_code = CommonUtil.nvl((String) request.getParameter("com_code"), "");
	String com_name = CommonUtil.nvl((String) request.getParameter("com_name"), "");
	String inert_yn = CommonUtil.nvl((String) request.getParameter("inert_yn"), "");
	String st_group_cd = CommonUtil.nvl((String) request.getParameter("st_group_cd"), "");
	
	Map<String,String> _rowData = null;
	if (_dataList != null && _dataList.size() != 0) { 
		_rowData = _dataList.get(0);
	}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script>
var popupSel = "";
var mySheet = new ibsheetObject();
var grbRow = "";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
function popupOnload(){
	kep_onload_view();
}
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
					 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus"}
					,{ Align:"Center",	Width:40,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED",	Sort:0}
					,{ Align:"Center",	Width:120,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사코드",		SaveName:"COM_CODE",	BackColor:"${notnullColor}"}
					,{ Align:"Left",	Width:400,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사명",			SaveName:"COM_NAME_LOC"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"사업자번호",		SaveName:"IRS_NO"}
					,{ Align:"Center",	Width:180,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"대표자명",			SaveName:"CEO_NAME_LOC"}
					,{ Align:"Center",	Width:180,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"GROUP_CODE",	SaveName:"GROUP_CODE"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	//데이터 셋팅
	var st_inert_yn = "<%=inert_yn%>";
	var st_com_name = "<%=com_name%>";
	//데이터 입력구분
	if(st_inert_yn == "Y"){
		var rows = mySheet.DataInsert(-1);
		mySheet.SetCellValue(rows, 'SELECTED', "1");
		mySheet.SetCellValue(rows, 'COM_CODE', "<%=com_code%>");
		mySheet.SetCellValue(rows, 'COM_NAME_LOC', "<%=com_name%>");
		$("#st_report_nm").val("<%=com_name%>");
	}else{
		//데이터 조회
		doAction('search');
	}
}

//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search":
			kepSearch(document.searchCondition, mySheet, "/mdct/getMasterMdCtReportCustomerManageList.do", pagingMode);
			break;
		case "reg":
			if (checkSaveSubmit("R")) {
			    if(!confirm("고객사 리포트 관리 등록을 하시겠습니까?")) {
			        return;
			    }else{
			    	kepSave(document.searchCondition, mySheet, "/mdct/saveMasterMdCtReportCustomerManageList.do", "SELECTED");
			    }
			}
			break;
		case "save":
			if (checkSaveSubmit("S")) {
			    if(!confirm("설정값 모두 저장하시겠습니까?")) {
			        return;
			    }else{
			    	kepSaveAll(document.searchCondition, mySheet, "/mdct/saveMasterMdCtReportCustomerList.do");
			    }
			}
			break;
		case "del":
			//고객사 매핑정보 필수
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			if(selectedGrid.length == 0){
				alert("고객사 코드 선택 바랍니다.");
				mySheet.SelectCell(1, "COM_CODE");
				return;		
			}
			if(!confirm("선택한 고객사 매핑을 삭제하시겠습니까?")) {
				return;
			}else{
				kepSave(document.searchCondition, mySheet, "/mdct/delMasterMdCtReportCustomerList.do", "SELECTED");
			}
			break;
	}

}
//
//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	return DATA;
}
	
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	if (msg != "") {
		alert(msg);
	}
}
	
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		if(msg=="OK"){
			alert("정상적으로 저장 되었습니다.");
		}else{
			alert(msg);
		}
	}
	//등록 후 후처리
	if (code == 1) {
		opener.doAction("search");
		this.close();
	}
}

function checkSaveSubmit(val){
	//등록일때 체크
	if(val == "R"){
		//고객사 매핑정보 필수
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		if(selectedGrid.length == 0){
			alert("고객사 매핑정보 선택 바랍니다.");
			mySheet.SelectCell(1, "COM_CODE");
			return false;		
		}
	}
	//리포트 그룹명 필수
	if (isEmpty($("#st_report_nm").val())) {
		alert("리포트 그룹명 입력이 필요합니다.");
		$("#st_report_nm").focus();
		return false;
	}
	//리포트 설정 최소 1개 이상 설정
	var st_select_yn = "N";
	for(var i =0; i < 12; i++){
		if ($("#st_inCheck"+i).is(":checked")) {
			st_select_yn = "Y";
			$("#st_check_yn"+i).val("Y");
		}else{
			$("#st_check_yn"+i).val("N");
		}
	}
	if(st_select_yn == "N"){
		alert("리포트 설정 최소 한개 이상 선택 바랍니다.");
		return false;
	}
	return true;
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {	
	
	if (pMethod == "save"||pMethod == "end"||pMethod == "restart"){ 
		 alert("저장에 실패 하였습니다. 다시 시도 하여 주십시오"); 
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	var result = response.msg.MSG;  
	if(pMethod=="update"){
		if(result=="OK"){
			alert("정상적으로 저장 되었습니다.");
		}else{
			alert(result);
		}
	}
}


//팝업함수호출
function doPop(str, val1, val2, val3, val4) {
	popupSel = str;
	switch (str) {
		case "com_code"://품목코드 멀티입력
			if($("#st_report_cd").val() == ""){
				alert("먼저 그룹코드 생성 후 고객사 추가 시 이용 가능합니다.");
				return;
			}

			popupSel = "comCodeCondPop";
			openSearchPopup('/common/multiSearchCondPop.do','?header_text=고객사코드',"420,380,no");
	        break;	
	}
}
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2){
	 if (popupSel == "comCodeCondPop"){ //고객사코드 멀티 입력
			var arrRow = value1.split("@");
			mySheet.RemoveAll();
			for (var i = 0; i < arrRow.length-1; i++) {
				var rows = mySheet.DataInsert(-1);
				mySheet.SetCellValue(rows, 'SELECTED', "1");
				mySheet.SetCellValue(rows, 'COM_CODE', arrRow[i]);
				mySheet.SetCellValue(rows, 'GROUP_CODE', $("#st_group_cd").val());
			}
		}
}
//TABLE의 ROW 데이타 생성
function addrows() {
	var rows = mySheet.DataInsert(-1);
	mySheet.SetCellValue(rows, 'SELECTED', "1");
	mySheet.SetCellValue(rows, 'GROUP_CODE', $("#st_group_cd").val());
}
</script> 
</head>
<body onload="popupOnload(); ">
<form name = "searchCondition"  id = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_group_cd"  name="st_group_cd" value="<%=st_group_cd%>">
	<input type="hidden" id="st_check_yn0"  name="st_check_yn0" value="">
	<input type="hidden" id="st_check_yn1"  name="st_check_yn1" value="">
	<input type="hidden" id="st_check_yn2"  name="st_check_yn2" value="">
	<input type="hidden" id="st_check_yn3"  name="st_check_yn3" value="">
	<input type="hidden" id="st_check_yn4"  name="st_check_yn4" value="">
	<input type="hidden" id="st_check_yn5"  name="st_check_yn5" value="">
	<input type="hidden" id="st_check_yn6"  name="st_check_yn6" value="">
	<input type="hidden" id="st_check_yn7"  name="st_check_yn7" value="">
	<input type="hidden" id="st_check_yn8"  name="st_check_yn8" value="">
	<input type="hidden" id="st_check_yn9"  name="st_check_yn9" value="">
	<input type="hidden" id="st_check_yn10"  name="st_check_yn10" value="">
	<input type="hidden" id="st_check_yn11"  name="st_check_yn11" value="">
	
	<div id="popWrapper" style="height:100%;">
    	<div id="popHeader">
			<h1 class="title">고객사 리포트 관리</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:518px;">
            <!--조회영역-->
            <h4><b>리포트 정보 </b></h4>
			<table class="cont_t_list07" style="width:100%">
				<colgroup>
					<col width="20%"/>
	                <col width="30%" />
	                <col width="20%" />
	                <col width="30%" />                                            
				</colgroup>
				<tbody>
					<tr>	
				  <% if (_rowData != null) { %> <!-- 리스트 조회 -->	
					  	<th>리포트 그룹코드</th>  		
						<td>
							<input type="text" name="st_report_cd" id="st_report_cd" class="input_type_text" title=""  style="width:90%;background:#EAEAEA;" readonly value="<%=CommonUtil.nvl(_rowData.get("GROUP_CODE"))%>"/>
						</td>
						<th>* 리포트 그룹명</th>			
						<td><input type="text" name="st_report_nm" id="st_report_nm" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("GROUP_NAME"))%>"/>
					<% }else{ %>
					  	<th>리포트 그룹코드</th>  		
						<td>
							<input type="text" name="st_report_cd" id="st_report_cd" class="input_type_text" title=""  style="width:90%;background:#EAEAEA;" readonly value=""/>
						</td>
						<th>* 리포트 그룹명</th>			
						<td><input type="text" name="st_report_nm" id="st_report_nm" class="input_type_text" title="" style="width:90%;" value=""/>
					<% } %> 
						</td> 
					</tr>
				</tbody>
			</table>	
			
			<h4><b>리포트 설정</b></h4>	
            <style>
			.reporttable{border-top:2px solid #4b4948; border-bottom:1px solid #cdcdcd}
			.reporttable th{text-align:center; font-weight:bold; color:#000; background-color:#eee}
			.reporttable td{ vertical-align:top; text-align:left; padding:15px 0px 0px 10px;line-height:18px;}
			.reporttable td input{ width:25px; width:25px; margin-top:3px}
			.reporttable td p{  vertical-align:top; display:inline-block;  margin-bottom:15px; width:245px;  }
			.reporttable td select{float:right; margin-right:20px}
            </style>
            
<% if (_rowData != null) { %> <!-- 리스트 조회 -->
			<table class="reporttable">
				<tr>
					<th width="10%">전체선택<br><br>
						<input name="st_check_status" id="st_check_status" type="checkbox" value="" onclick="kepCheckAll('12',document.forms.searchCondition.st_check_status,'document.forms.searchCondition.st_inCheck');">
					</th>
	                
	                <td width="250px">
	                	<p>
		                	<input name="st_inCheck0" id="st_inCheck0" type="checkbox" value="" <%=("Y".equals(_rowData.get("TR_YN")))?"checked":""%>>거래현황 
		                	<select name="st_select0" id="st_select0">
		                		<option value="A" <%=("A".equals(_rowData.get("TR_TYPE")))?"selected":""%>>자동</option>
		                		<option value="M" <%=("M".equals(_rowData.get("TR_TYPE")))?"selected":""%>>가공</option>
		                	</select>  
	                    </p>
						<p>
							<input name="st_inCheck1" id="st_inCheck1" type="checkbox" value="" <%=("Y".equals(_rowData.get("TRDT_YN")))?"checked":""%>>거래현황 상세 
	                    	<select name="st_select1" id="st_select1">
								<option value="A" <%=("A".equals(_rowData.get("TRDT_TYPE")))?"selected":""%>>자동</option>
								<option value="M" <%=("M".equals(_rowData.get("TRDT_TYPE")))?"selected":""%>>가공</option>
							</select>
	                    </p>
	                	<p>
	                		<input name="st_inCheck2" id="st_inCheck2" type="checkbox" value="" <%=("Y".equals(_rowData.get("NEW_CONTRACT_YN")))?"checked":""%>>계약/신규품목 현황 
							<select name="st_select2" id="st_select2">
								<option value="A" <%=("A".equals(_rowData.get("NEW_CONTRACT_TYPE")))?"selected":""%>>자동</option>
								<option value="M" <%=("M".equals(_rowData.get("NEW_CONTRACT_TYPE")))?"selected":""%>>가공</option>
							</select>
	                    </p>
	                    <p>
	                    	<input name="st_inCheck3" id="st_inCheck3" type="checkbox" value="" <%=("Y".equals(_rowData.get("PD_YN")))?"checked":""%>>품목별 현황(SG) 
							<select name="st_select3" id="st_select3">
								<option value="A" <%=("A".equals(_rowData.get("PD_TYPE")))?"selected":""%>>자동</option>
								<option value="M" <%=("M".equals(_rowData.get("PD_TYPE")))?"selected":""%>>가공</option>
							</select>
						</p>
					</td>
	                
	                <td width="250px">
	                	<p>
	                		<input name="st_inCheck4" id="st_inCheck4" type="checkbox" value="" <%=("Y".equals(_rowData.get("BUYER_CA_PD_YN")))?"checked":""%>>품목별 현황(카테고리) 
							<select name="st_select4" id="st_select4">
								<option value="A" <%=("A".equals(_rowData.get("BUYER_CA_PD_TYPE")))?"selected":""%>>자동</option>
								<option value="M" <%=("M".equals(_rowData.get("BUYER_CA_PD_TYPE")))?"selected":""%>>가공</option>
							</select>
						</p>
						<p>
							<input name="st_inCheck5" id="st_inCheck5" type="checkbox" value="" <%=("Y".equals(_rowData.get("RD_YN")))?"checked":""%>> 절감현황(SG)
							<select name="st_select5" id="st_select5">
								<option value="A" <%=("A".equals(_rowData.get("RD_TYPE")))?"selected":""%>>자동</option>
								<option value="M" <%=("M".equals(_rowData.get("RD_TYPE")))?"selected":""%>>가공</option>
							</select>
						</p>
						<p>
							<input name="st_inCheck6" id="st_inCheck6" type="checkbox" value="" <%=("Y".equals(_rowData.get("BUYER_CA_RD_YN")))?"checked":""%>> 절감현황(카테고리)
							<select name="st_select6" id="st_select6">
								<option value="A" <%=("A".equals(_rowData.get("BUYER_CA_RD_TYPE")))?"selected":""%>>자동</option>
								<option value="M" <%=("M".equals(_rowData.get("BUYER_CA_RD_TYPE")))?"selected":""%>>가공</option>
							</select>
	                    </p>
	                    <p>
	                    	<input name="st_inCheck7" id="st_inCheck7" type="checkbox" value="" <%=("Y".equals(_rowData.get("DE_CD_YN")))?"checked":""%>>납기관리(Calendar Day)
	                    	<select name="st_select7" id="st_select7">
								<option value="A" <%=("A".equals(_rowData.get("DE_CD_TYPE")))?"selected":""%>>자동</option>
								<option value="M" <%=("M".equals(_rowData.get("DE_CD_TYPE")))?"selected":""%>>가공</option>
							</select>
						</p>
					</td>
					
					<td width="250px">
						<p>
							<input name="st_inCheck8" id="st_inCheck8" type="checkbox" value="" <%=("Y".equals(_rowData.get("DE_WD_YN")))?"checked":""%>>납기관리(Working Day)
							<select name="st_select8" id="st_select8">
								<option value="A" <%=("A".equals(_rowData.get("DE_WD_TYPE")))?"selected":""%>>자동</option>
								<option value="M" <%=("M".equals(_rowData.get("DE_WD_TYPE")))?"selected":""%>>가공</option>
							</select>
	                    </p>
	                    <p>
	                    	<input name="st_inCheck9" id="st_inCheck9" type="checkbox" value="" <%=("Y".equals(_rowData.get("RE_CD_YN")))?"checked":""%>>견적관리(Calendar Day)
	                    	<select name="st_select9" id="st_select9">
	                    		<option value="A" <%=("A".equals(_rowData.get("RE_CD_TYPE")))?"selected":""%>>자동</option>
	                    		<option value="M" <%=("M".equals(_rowData.get("RE_CD_TYPE")))?"selected":""%>>가공</option>
	                    	</select>
	                    </p>
	                    <p>
	                    	<input name="st_inCheck10" id="st_inCheck10" type="checkbox" value="" <%=("Y".equals(_rowData.get("RE_WD_YN")))?"checked":""%>>견적관리(Working Day)
	                    	<select name="st_select10" id="st_select10">
	                    		<option value="A" <%=("A".equals(_rowData.get("RE_WD_TYPE")))?"selected":""%>>자동</option>
	                    		<option value="M" <%=("M".equals(_rowData.get("RE_WD_TYPE")))?"selected":""%>>가공</option>
	                    	</select>
	                    </p>
	                    <p>
	                    	<input name="st_inCheck11" id="st_inCheck11" type="checkbox" value="" value="" <%=("Y".equals(_rowData.get("EVALUATION_YN")))?"checked":""%>>총 평
	                    </p> 
	                </td>
				</tr>    
			</table>
<% }else{ %>
			<table class="reporttable">
  				<tr>
					<th width="100px">전체선택<br><br>
						<input name="st_check_status" id="st_check_status" type="checkbox" value="" onclick="kepCheckAll('12',document.forms.searchCondition.st_check_status,'document.forms.searchCondition.st_inCheck');">
					</th>
					
					<td width="754px">
						<p>
							<input name="st_inCheck0" id="st_inCheck0" type="checkbox" value="">거래현황 
							<select name="st_select0" id="st_select0">  
								<option value="A">자동</option>
								<option value="M">가공</option>
							</select>  
						</p>
						<p>
							<input name="st_inCheck1" id="st_inCheck1" type="checkbox" value="">거래현황 상세 
							<select name="st_select1" id="st_select1">
								<option value="A">자동</option>
								<option value="M">가공</option>
							</select>
						</p>
    					<p>
    						<input name="st_inCheck2" id="st_inCheck2" type="checkbox" value="">계약/신규품목 현황 
							<select name="st_select2" id="st_select2">
								<option value="A">자동</option>
								<option value="M">가공</option>
							</select>
						</p>
						<p>
							<input name="st_inCheck3" id="st_inCheck3" type="checkbox" value="">품목별 현황(SG) 
							<select name="st_select3" id="st_select3">
								<option value="A">자동</option>
								<option value="M">가공</option>
							</select>
						</p>
       					<p>
       						<input name="st_inCheck4" id="st_inCheck4" type="checkbox" value="">품목별 현황(카테고리) 
							<select name="st_select4" id="st_select4">
								<option value="A">자동</option>
								<option value="M">가공</option>
							</select>
						</p>
						<p>
							<input name="st_inCheck5" id="st_inCheck5" type="checkbox" value=""> 절감현황(SG)
							<select name="st_select5" id="st_select5">
								<option value="A">자동</option>
								<option value="M">가공</option>
							</select>
						</p>
						<p>
							<input name="st_inCheck6" id="st_inCheck6" type="checkbox" value=""> 절감현황(카테고리)
							<select name="st_select6" id="st_select6">
								<option value="A">자동</option>
								<option value="M">가공</option>
							</select>
						</p>
						<p>
							<input name="st_inCheck7" id="st_inCheck7" type="checkbox" value="">납기관리(Calendar Day) 
							<select name="st_select7" id="st_select7">
								<option value="A">자동</option>
								<option value="M">가공</option>
							</select>
						</p>
						<p>
							<input name="st_inCheck8" id="st_inCheck8" type="checkbox" value="">납기관리(Working Day) 
							<select name="st_select8" id="st_select8">
								<option value="A">자동</option>
								<option value="M">가공</option>
							</select>
						</p>
						<p>
							<input name="st_inCheck9" id="st_inCheck9" type="checkbox" value="">견적관리(Calendar Day) 
							<select name="st_select9" id="st_select9">
								<option value="A">자동</option>
								<option value="M">가공</option>
							</select>
						</p>
						<p>
							<input name="st_inCheck10" id="st_inCheck10" type="checkbox" value="">견적관리(Working Day) 
							<select name="st_select10" id="st_select10">
								<option value="A">자동</option>
								<option value="M">가공</option>
							</select>
						</p>
						<p>
							<input name="st_inCheck11" id="st_inCheck11" type="checkbox" value="">총 평</p> 
					</td>
				</tr>
			</table>
<% } %>
			<br>
			<h4>
				<b>고객사 매핑정보</b>
			</h4>
			
			<div class="ib_product" style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "100%", "250px");
				</script>
			</div>
			
			<table style="width:100%;">
		    	<tr>
			        <td height="25" align="left">
			            <font color="#666666">&nbsp;&nbsp;※ 한 고객사당 1개의 그룹코드 매핑만 가능합니다. </font><br>
			            <font color="#666666">&nbsp;&nbsp;※ 리포트는 매월 10일 자동 생성 됩니다. </font>
			        </td>
			        <td height="25" align="right" valign="middle">
			            <span class="btn_02"><a href="javascript:addrows();">행추가</a></span>
						<span class="btn_02"><a href="javascript:doPop('com_code');">멀티입력</a></span>
						<span class="btn_04"><a href="javascript:doAction('del');">매핑삭제</a></span>
						<%if(inert_yn.equals("Y")){ %>
							<span class="btn_02"><a href="javascript:doAction('reg');">등록</a></span>
						<%}else{ %>
							<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
						<%} %>
			        </td>
			    </tr>
			</table>
		</div>
	</div>
</form> 
</body>
</html>
