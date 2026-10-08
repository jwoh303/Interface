<%--
**********************************************
* 메뉴 : 신규영업관리 > 잠재고객등록 팝업
* 화면 : 잠재고객등록 팝업
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
	
	String userid = "";
	String userName = "";
	String userDept = "";
	
	if (_sessionInfo != null){ 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
		userName = CommonUtil.nvl((String)_sessionInfo.getUserNameLoc());
		userDept = CommonUtil.nvl((String)_sessionInfo.getDepartment());
	}

	String st_sy_year = String.valueOf(DateTimeUtil.getYear());//매출액 년도
	String st_cd_year = String.valueOf(DateTimeUtil.getYear());//신용등급 년도
	String st_epl_year = "";//종업원수 년도
	String st_mro_yn = "";
	String st_past_mro_yn = "";
	String st_mro_start ="";
	String st_mro_end = "";
	String st_past_mro_start ="";
	String st_past_mro_end = "";
	String st_buyer_close_flag = "N";//고객사 종결 여부
	String st_process_status_type = "";//진행상태
	String st_revision = ""; //입찰차수
	//최초등록 여부
	String st_insertFlag = CommonUtil.nvl((String) request.getParameter("insertFlag"), "");
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	Map<String,String> _rowData = null;
	String sbuyer = "";
	String st_irs_no = "";
	
	if (_dataList != null && _dataList.size() != 0) { 
		_rowData = _dataList.get(0);
		sbuyer = CommonUtil.nvl(_rowData.get("BUYER"));
		st_sy_year = CommonUtil.nvl(_rowData.get("SALES_YEAR"));
		st_cd_year = CommonUtil.nvl(_rowData.get("CREDIT_DATE"));
		st_epl_year  = CommonUtil.nvl(_rowData.get("EMPLOYEE_YEAR"));
		st_mro_yn  = CommonUtil.nvl(_rowData.get("MRO_YN"));
		st_past_mro_yn  = CommonUtil.nvl(_rowData.get("PAST_MRO_YN"));
		st_mro_start  = CommonUtil.nvl(_rowData.get("MRO_START"));
		st_mro_end  = CommonUtil.nvl(_rowData.get("MRO_END"));
		st_past_mro_start  = CommonUtil.nvl(_rowData.get("PAST_MRO_START"));
		st_past_mro_end  = CommonUtil.nvl(_rowData.get("PAST_MRO_END"));
		st_buyer_close_flag = CommonUtil.nvl(_rowData.get("BUYER_CLOSE_FLAG"));
		st_process_status_type = CommonUtil.nvl(_rowData.get("PROCESS_TYPE"));
		st_revision = CommonUtil.nvl(_rowData.get("REVISION"));
		st_irs_no = CommonUtil.nvl(_rowData.get("IRS_NO"));
		
	}
	//기업정보관리 로직
	List<Map<String,String>> _dataMdctList = (List<Map<String,String>>) request.getAttribute("dataMdCt"); // 조회된 결과
	if (_dataMdctList != null && _dataMdctList.size() != 0) { 
		_rowData = _dataMdctList.get(0);
		sbuyer = "sbuyer";
		st_sy_year = CommonUtil.nvl(_rowData.get("YYYY"));
		st_cd_year = CommonUtil.nvl(_rowData.get("YYYY"));
		st_epl_year= CommonUtil.nvl(_rowData.get("YYYY"));
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
</head>

<script>
var popupSel = "";
var mySheet = new ibsheetObject();
var grbRow = "";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
function popupOnload(){
	//달력셋팅
	kepSetCalender("st_mro_s_date");
	kepSetCalender("st_mro_e_date");
	kepSetCalender("st_past_mro_date");
	kepSetCalender("st_past_mro_e_date");
	//영업활동 grid
	var st_insertFlag = "<%=st_insertFlag%>";
	if(st_insertFlag == "Y")return;
	kep_onload_view();
}
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",							SaveName:"sStatus"}
		,{ Align:"Center",	Width:50,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",								SaveName:"SELECTED"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"고객사코드",						SaveName:"BUYER"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"영업일시",							SaveName:"CSTMR_VISIT_DATE"}
		,{ Align:"Center",	Width:95,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"영업유형",							SaveName:"VISIT_MDCT_NM"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"담당자",							SaveName:"USER_NAME_LOC"}
		,{ Align:"Left",	Width:520,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"영업상 주요 활동결과/ 정보/ 특이사항",	SaveName:"VISIT_NOTE_TITLE"}
		,{ Align:"Center",	Width:58,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"첨부",							SaveName:"IMAGE_FLAG"}
		,{ Align:"Left",	Width:250,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"첨부파일",							SaveName:"IMAGE_KEY"}
		,{ Align:"Center",	Width:58,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"등록일자",							SaveName:"ADD_DATE"}
		,{ Align:"Left",	Width:250,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"등록시간",							SaveName:"ADD_TIME"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "USER_ID");					//아이디
	setLinkCol(mySheet, "COM_NAME");				//회원사명
	mySheet.SetImageList(1, diskOn);
	mySheet.SetImageList(0, diskOff);
	setLinkCol(mySheet, "VISIT_NOTE_TITLE");				//활동내용
	setLinkCol(mySheet, "IMAGE_FLAG");				//파일첨부
	doAction('mtSearch');
}

//기능함수
function doAction(str) {
	var st_mro_cmpy = document.getElementById('st_mro_cmpy');
	st = new Date();
	switch (str) {
		case "search":
			kepAjaxFormCall("/mdct/getMasterMdCtNewCustomerManageDetailList.do","searchCondition","");
			break;
		case "save":
			if (checkSaveSubmit()) {
			    if(!confirm("잠재고객 등록을 하시겠습니까?  ")) {
			        return;
			    }else{
			       st_mro_cmpy.disabled = false;
			       kepAjaxFormCall("/mdct/saveMasterMdCtNewCustomer.do","searchCondition","save"); 	   
			    }
			}
			break;
		case "update":
			if (checkSaveSubmit()) {
			    if(!confirm("잠재고객 정보 수정 하시겠습니까?  ")) {
			        return;
			    }else{
			    	st_mro_cmpy.disabled = false;
			       kepAjaxFormCall("/mdct/updateMasterMdCtNewCustomer.do","searchCondition","update"); 	   
			    }
			}
			break;
		case "cmy_update":
			if($("#st_mst_yn").val() == "N"){
				alert("등록 된 기업정보가 없습니다. 기업정보 등록 후 사용 바랍니다.");
				return;
			}
		    if(!confirm("기업정보 업데이트 하시겠습니까?  ")) {
		        return;
		    }else{
		       kepAjaxFormCall("/mdct/updateMasterMdCtMSTNewCustomer.do","searchCondition","cmy_update"); 	   
		    }
			break;
		case "end"://종결처리
			// 사유입력
			if(confirm("잠재고객 정보 종결 하시겠습니까?  ")) {
				popupSel = "reasonPop";
				openSearchPopup('/mppo/showBuyerMpPoRejectReasonPop.do','?openYn=O',"500,280,no");				
			}
			break;
		case "reStart"://재개
			if(confirm("잠재고객 정보 재개하시겠습니까?  ")) {
			    $("#st_end_remark").val("");
			    $("#st_buyer_close_flag_in").val("N");
				kepAjaxFormCall("/mdct/endMasterMdCtNewCustomer.do","searchCondition","restart");				
			}
			break;			
		case "mtSearch":	 //주요영업활동 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdcd/getMasterMdCdBuyerCardInfoPopVisit.do" , pagingMode );
			break;
		case "delete":	 // 삭제
			if (confirm("선택한 건을 삭제하겠습니까?")) {
				kepSave(document.searchCondition,  mySheet , "/mdcd/deleteMasterMdCdBuyerCardInfoPop.do" , "SELECTED" );
			}
			break;
	}

}
//유선영업 대면영업 처리방법
function processAction(str, str_gbn) {
	
	var st_confirm_msg = "";
	
	var st_mro_cmpy = document.getElementById('st_mro_cmpy');
	
	if(str_gbn == "BI"){
		st_confirm_msg ="유선영업 완료처리 하시겠습니까?";
	}else if(str_gbn == "BD"){
		st_confirm_msg ="대면영업 완료처리 하시겠습니까?";
	}else if(str_gbn == "GA"){
		st_confirm_msg ="유선영업 상태로 변경 하시겠습니까?";
	}
	//대면영업단계 변경
	$("#st_process_status_type").val(str_gbn);	
	switch (str) {
	
		case "comp"://유선영업변경
			if (checkSaveSubmit()) {
			    if(!confirm(st_confirm_msg)) {
			        return;
			    }else{
			       st_mro_cmpy.disabled = false;
			       kepAjaxFormCall("/mdct/saveMasterMdCtNewCustomerMtComp.do","searchCondition","comp"); 	   
			    }
			}
			break;	
	}
}
//
//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	if (msg != "") {
		alert(msg);
	}
	if (current_page==-1) {
		makePageIndex2(mySheet, 1, document.searchCondition.onepagerow.value);
	} else {
		makePageIndex2(mySheet, current_page, document.searchCondition.onepagerow.value);	
	}
	var st_mro_yn = document.getElementById('st_mro_yn');
	var st_mro_cmpy = document.getElementById('st_mro_cmpy');
	if(st_mro_yn.value == 'N') {
		st_mro_cmpy.disabled = true;
		st_mro_cmpy.value = 'NA';
		st_mro_cmpy.text = '해당없음';			
	}
	
}
	
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	if (code > 0) {
		//저장 성공시 재조회
		doAction('mtSearch');
	}
}

//페이지 인덱스 클릭시 재조회
function pageSearch(param) {
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcd/getMasterMdCdBuyerCardInfoPopVisit.do?page="+current_page , pagingMode );
}
//팝업리턴
function setReason(value){
    
	//사유저장
	if (popupSel == "reasonPop"){
	    $("#st_end_remark").val(value);
	    $("#st_buyer_close_flag_in").val("Y");
	    kepAjaxFormCall("/mdct/endMasterMdCtNewCustomer.do","searchCondition","end");
	}
	
}
function checkSaveSubmit(){

	if (isEmpty($("#st_kep_dept_nm").val())) {
		alert("담당부서가 입력되지 않았습니다. ");
		$("#st_kep_dept_nm").focus();
		return false;
	}

	if (isEmpty($("#st_process_type").val())) {
		alert("영업방식이 입력되지 않았습니다. ");
		$("#st_process_type").focus();
		return false;
	}
	if (isEmpty($("#st_buyer_name").val())) {
		alert("기업명이 입력되지 않았습니다. ");
		$("#st_buyer_name").focus();
		return false;
	}
	if (isEmpty($("#st_group").val())) {
		alert("기업집단이 입력되지 않았습니다. ");
		$("#st_group").focus();
		return false;
	}
	if (isEmpty($("#st_irs_no").val())) {
		alert("사업자번호가 입력되지 않았습니다. ");
		$("#st_irs_no").focus();
		return false;
	}
	if (isEmpty($("#st_ceo").val())) {
		alert("대표자가 입력되지 않았습니다. ");
		$("#st_ceo").focus();
		return false;
	}
	if (isEmpty($("#st_sy_amt").val())) {
		alert("매출액이 입력되지 않았습니다. ");
		$("#st_sy_amt").focus();
		return false;
	}
	if (isEmpty($("#st_cd_rank").val())) {
		alert("신용등급이 입력되지 않았습니다. ");
		$("#st_cd_rank").focus();
		return false;
	}
	if (isEmpty($("#st_epl").val())) {
		alert("종업원수가 입력되지 않았습니다. ");
		$("#st_epl").focus();
		return false;
	}
	if (isEmpty($("#st_ind_type").val())) {
		alert("산업분류가 입력되지 않았습니다. ");
		$("#st_ind_type").focus();
		return false;
	}
	if (isEmpty($("#st_ind_type").val())) {
		alert("산업분류가 입력되지 않았습니다. ");
		$("#st_ind_type").focus();
		return false;
	}
	if (isEmpty($("#st_mi").val())) {
		alert("주요생상품이 입력되지 않았습니다. ");
		$("#st_mi").focus();
		return false;
	}
	if (isEmpty($("#st_tel_no").val())) {
		alert("본사전화번호가 입력되지 않았습니다. ");
		$("#st_tel_no").focus();
		return false;
	}
	/* if (isEmpty($("#st_head_addr").val())) {
		alert("본사주소가 입력되지 않았습니다. ");
		$("#st_head_addr").focus();
		return false;
	} */
	if (isEmpty($("#st_mro_cmpy").val())) {
		alert("현 구매대행사가 입력되지 않았습니다. ");
		$("#st_mro_cmpy").focus();
		return false;
	}
	/* if (isEmpty($("#st_past_mro_yn").val())) {
		alert("과거 구매대행 거래여부가 입력되지 않았습니다. ");
		$("#st_past_mro_yn").focus();
		return false;
	}
	if (isEmpty($("#st_past_mro_cmpy").val())) {
		alert("과거 구매대행사가 입력되지 않았습니다. ");
		$("#st_past_mro_cmpy").focus();
		return false;
	} */
	if (isEmpty($("#st_year_mro_amt").val())) {
		alert("구매대행 거래금액(년)이 입력되지 않았습니다. ");
		$("#st_year_mro_amt").focus();
		return false;
	}
	if (isEmpty($("#st_mro_spd").val())) {
		alert("MRO  Spend가 입력되지 않았습니다. ");
		$("#st_mro_spd").focus();
		return false;
	}
	if (isEmpty($("#st_key_dept").val())) {
		alert("Key-man 부서가 입력되지 않았습니다. ");
		$("#st_key_dept").focus();
		return false;
	}
	if (isEmpty($("#st_key_nm").val())) {
		alert("Key-man 성명/직급이 입력되지 않았습니다. ");
		$("#st_key_nm").focus();
		return false;
	}
	if (isEmpty($("#st_int_status").val())) {
		alert("관심정도가 입력되지 않았습니다. ");
		$("#st_int_status").focus();
		return false;
	}
	if (isEmpty($("#st_int_status_user").val())) {
		alert("담당자 성향이 입력되지 않았습니다. ");
		$("#st_int_status_user").focus();
		return false;
	}
	if (isEmpty($("#st_int_main").val())) {
		alert("주요 관심사항이 입력되지 않았습니다. ");
		$("#st_int_main").focus();
		return false;
	}
	if(!kepChkDecimal($("#st_epl").val())){
		alert("종업원수 숫자로 입력 바랍니다. ");
		$("#st_epl").focus();
		return false;
	}
	if(!kepChkDecimal($("#st_sy_amt").val(),5)){
		alert("기업정보 매출액을 숫자(소수점 포함)로 입력 바랍니다. ");
		$("#st_sy_amt").focus();
		return false;
	}
	if(!kepChkDecimal($("#st_year_mro_amt").val(),5)){
		alert("구매대행 거래금액을 숫자(소수점 포함)로 입력 바랍니다. ");
		$("#st_year_mro_amt").focus();
		return false;
	}
	if(!kepChkDecimal($("#st_mro_spd").val(),5)){
		alert("MRO Spend 숫자(소수점 포함)로 입력 바랍니다. ");
		$("#st_mro_spd").focus();
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
		if(result=="Ok"){
			alert("정상적으로 저장 되었습니다.");
		}else{
			alert(result);
			return;
		}
	}else if(pMethod=="cmy_update"){
		if(result=="Ok"){
			alert("정상적으로 저장 되었습니다.");
			opener.doAction('search');
			this.close();
		}else{
			alert(result);
			return;
		}
	}else if(pMethod=="save"){
		if(result=="Ok"){
			alert("잠재고객사 등록 되었습니다.");
			opener.doAction('search');
			this.close();
		}else{
			alert(result);
			return;
		}	
	}else if(pMethod=="end"){
		if(result=="Ok"){
			alert("잠재고객사 종결 처리 되었습니다.");
			opener.doAction('search');
			this.close();
		}else{
			alert(result);
			return;
		}		
	}else if(pMethod=="restart"){
		if(result=="Ok"){
			alert("잠재고객사 재개 처리 되었습니다.");
			opener.doAction('search');
			this.close();
		}else{
			alert(result);
			return;
		}		
	}else if(pMethod=="comp"){
		if(result=="Ok"){
			alert("처리 완료 되었습니다.");
			opener.doAction('search');
			this.close();
		}else{
			alert(result);
			return;
		}		
	}
}


//팝업함수호출
function doPop(str, val1, val2, val3, val4) {
	popupSel = str;
	switch (str) {
		case "kepUser": 
			popupSel = "kepUserSelectAllPop";
			openSearchPopup("/common/kepUserSelectAllPop.do", '', "500,485,no");
	        break;	
		case "add":// 활동내용등록
			var st_com_code = $("#st_com_code").val();
			popupSel = "activityRegPop";
			openSearchPopup("/mdcd/showMasterMdCdPrimaryActivityDetailRegPop.do", "?com_code=" + st_com_code+"&st_potential_customer_yn=Y&st_mdct_yn=Y", "1000, 500,no");
	        break;	
		case "remark":
			popupSel = "activityRegPop";
			openSearchPopup("/mdcd/showMasterMdCdPrimaryActivityDetailRegPop.do", "?com_code=" + val1 + "&add_date=" + val2 + "&add_time=" + val3 + "&st_potential_customer_yn=Y&st_mdct_yn=Y", "1000, 500,no");
			break;
		case "company_address":
			popupSel = "companyAddressPop";
			var irs_no = $("#st_irs_no").val();
			openSearchPopup("/mdcd/getCompanyAddressPop.do", "?irs_no=" + irs_no, "700,585,no");
	        break;
		case "kepIndType":
			popupSel = "kepIndTypePop";			
			openSearchPopup("/common/getKepIndTypePop.do", "?open=Y", "700,475,no");
	        break;
	}
}
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'VISIT_NOTE_TITLE') {				// 활동내용
		doPop("remark", mySheet.GetCellValue(Row, "BUYER"), mySheet.GetCellValue(Row, "ADD_DATE"), mySheet.GetCellValue(Row, "ADD_TIME"), "" );
		return;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
									,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
									,value21,value22,value23,value24,value25,value26,value27,value28,value29,value30
									,value31,value32){
	 if (popupSel == "kepUserSelectAllPop"){ //담당자
			$("#st_kep_dept_nm").val(value4);
			$("#st_kep_dept_cd").val(value3);
			$("#st_kep_user_nm").val(value2);
			$("#st_kep_user_id").val(value1);
		}else if(popupSel == "activityRegPop"){//주요활동내역 등록
			doAction('mtSearch');
		}else if(popupSel == "kepIndTypePop"){//산업분류명
			$("#st_ind_name").val(value2);
			$("#st_ind_type").val(value1);
		}
}
function EraserBuyerCode(){
	$("#st_kep_dept_nm").val('');
	$("#st_kep_dept_cd").val('');
	$("#st_kep_user_nm").val('');
	$("#st_kep_user_id").val('');
}
function EraserIndType(){
	$("#st_ind_name").val('');
	$("#st_ind_type").val('');	
}

function mrocmpy_onchange() {
	var st_mro_yn = document.getElementById('st_mro_yn');
	var st_mro_cmpy = document.getElementById('st_mro_cmpy');
	if(st_mro_yn.value == 'N') {
		st_mro_cmpy.disabled = true;
		st_mro_cmpy.value = 'NA';
		st_mro_cmpy.text = '해당없음';			
	} else {
		st_mro_cmpy.disabled = false;		
	}
}


</script> 
<body onload="popupOnload(); ">
<form name = "searchCondition"  id = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="com_code"  name="com_code"  value="<%=sbuyer%>">
	<input type="hidden" id="st_com_code"  name="st_com_code"  value="<%=sbuyer%>">
	<input type="hidden" id="st_insertFlag"  name="st_insertFlag"  value="<%=st_insertFlag%>">
	<input type="hidden" id="st_end_remark"  name="st_end_remark"  value="">
	<input type="hidden" id="st_buyer_close_flag_in"  name="st_buyer_close_flag_in"  value="">
	<input type="hidden" id="st_buyer_close_flag"  name="st_buyer_close_flag"  value="<%=st_buyer_close_flag%>">
	<input type="hidden" id="st_revision"  name="st_revision"  value="<%=st_revision%>">
	<input type="hidden" id="st_process_status_type"  name="st_process_status_type"  value="">
	<input type="hidden" id="USER_DEPT"  name="USER_DEPT" value="<%=userDept%>">
	<div id="popWrapper" style="height:100%;">
    	<div id="popHeader">
			<%
			if(st_buyer_close_flag.equals("Y")){
			%>
        		<h1 class="title">잠재고객 정보 등록</h1>
			<%
			}else{
			%>
				<h1 class="title">잠재고객 정보 조회</h1>
			<%
			}
			%>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"  style="height:518px;">
        	<!--버튼영역-->
            <!--조회영역-->
            <h4><b>KeP담당자 </b></h4>
			<table class="cont_t_list07" style="width:100%">
						<colgroup>
						<col width="12%"/>
                        <col width="20%" />
                        <col width="16%" />
                        <col width="20%" />
                        <col width="13%"/>
                        <col width="*" />                                            
						</colgroup>
						<tbody>
						  <tr>		
						  	<th>* 담당부서</th>  		
							<td>
								<input type="text" name="st_kep_dept_nm" id="st_kep_dept_nm" class="input_type_text" title=""  style="width:90%;background:#EAEAEA;" readonly value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("KEP_USER_DEPT_NM")) %>"/>
								<input type="hidden" name="st_kep_dept_cd" id="st_kep_dept_cd" style="width:80%" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("KEP_USER_DEPT")) %>"/>
							</td>
							<th>* 담당자</th>			
							<td><input type="text" name="st_kep_user_nm" id="st_kep_user_nm" class="input_type_text" title="" style="width:60%;"  readonly onclick="javascript:doPop('kepUser');" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("KEP_USER_NM")) %>"/>
								  <input type="hidden" name="st_kep_user_id" id="st_kep_user_id" style="width:80%" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("KEP_USER_ID")) %>"/>
								<a href="javascript:doPop('kepUser');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:EraserBuyerCode();"><img src="/resources/images/btn_eraser2.gif"></a>
							</td> 
							<th>* 영업방식</th>
							<td>
								<select name="st_process_type" id="st_process_type" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "SEL", "CP02","", "ICOMCOD1", sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("BUSINESS_METHOD")), "") %>           
						         </select>
							</td>
						 </tr>
					</tbody>
				</table>	
            <h4><b>기업정보 </b></h4>
			<table class="cont_t_list07" style="width:100%">
						<colgroup>
						<col width="12%"/>
                        <col width="20%" />
                        <col width="16%" />
                        <col width="20%" />
                        <col width="13%"/>
                        <col width="*" />                                            
						</colgroup>
						<tbody>
						 <tr>				
							<th>*기업명</th>			
							<td><input type="text" name="st_buyer_name" id="st_buyer_name" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("BUYER_NAME")) %>"/></td>	
							<th>*기업집단</th>			
							<td><input type="text" name="st_group" id="st_group" class="input_type_text" title="" style="width:90%;"  value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("GROUP_NAME")) %>"/></td>		
							<th>*사업자번호</th>			
							<td><input type="text" name="st_irs_no" id="st_irs_no" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("IRS_NO")) %>" readOnly/></td>																														  	
						  </tr>
						  <tr>
							<th>*대표자</th>			
							<td><input type="text" name="st_ceo" id="st_ceo" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("CEO_NAME_LOC")) %>"/></td>
							<th>*매출액(단위:억)</th>			
							<td>
								<input type="hidden" id="st_mst_yn"  name="st_mst_yn"  value="<%=CommonUtil.nvl(_rowData.get("MST_YN"))%>">
								<select name="st_sy_year" id="st_sy_year"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="<%=DateTimeUtil.getYear() - 5 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 5).equals(st_sy_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 5 %></option>
			                		<option value="<%=DateTimeUtil.getYear() - 4 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 4).equals(st_sy_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 4 %></option>
			                		<option value="<%=DateTimeUtil.getYear() - 3 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 3).equals(st_sy_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 3 %></option>
			                		<option value="<%=DateTimeUtil.getYear() - 2 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 2).equals(st_sy_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 2 %></option>
			                		<option value="<%=DateTimeUtil.getYear() - 1 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 1).equals(st_sy_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 1 %></option>
			                		<option value="<%=DateTimeUtil.getYear() %>" <% if (String.valueOf(DateTimeUtil.getYear()).equals(st_sy_year)) { %> selected <%} %>><%=DateTimeUtil.getYear()%></option>
			                	</select>&nbsp;년&nbsp;
								<input type="text" name="st_sy_amt" id="st_sy_amt" class="input_type_text" title="" style="width:20%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("SALES_AMT")) %>"/>&nbsp;억&nbsp;</td>
							</td>
							<th>*신용등급</th>			
							<td >
								<select name="st_cd_year" id="st_cd_year"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="<%=DateTimeUtil.getYear() - 5 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 5).equals(st_cd_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 5 %></option>
			                		<option value="<%=DateTimeUtil.getYear() - 4 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 4).equals(st_cd_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 4 %></option>
			                		<option value="<%=DateTimeUtil.getYear() - 3 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 3).equals(st_cd_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 3 %></option>
			                		<option value="<%=DateTimeUtil.getYear() - 2 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 2).equals(st_cd_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 2 %></option>
			                		<option value="<%=DateTimeUtil.getYear() - 1 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 1).equals(st_cd_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 1 %></option>
			                		<option value="<%=DateTimeUtil.getYear() %>" <% if (String.valueOf(DateTimeUtil.getYear()).equals(st_cd_year)) { %> selected <%} %>><%=DateTimeUtil.getYear()%></option>
			                	</select>&nbsp;년&nbsp;
								<input type="text" name="st_cd_rank" id="st_cd_rank" class="input_type_text" title=""   onkeyup="kepToUpper('st_cd_rank')"  style="width:40%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("CREDIT_RATING")) %>"/></td>
							</td>	
						  </tr>
						  <tr>
							<th>*종업원수</th>			
							<td>
								<select name="st_epl_year" id="st_epl_year"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="<%=DateTimeUtil.getYear() - 5 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 5).equals(st_epl_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 5 %></option>
			                		<option value="<%=DateTimeUtil.getYear() - 4 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 4).equals(st_epl_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 4 %></option>
			                		<option value="<%=DateTimeUtil.getYear() - 3 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 3).equals(st_epl_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 3 %></option>
			                		<option value="<%=DateTimeUtil.getYear() - 2 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 2).equals(st_epl_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 2 %></option>
			                		<option value="<%=DateTimeUtil.getYear() - 1 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 1).equals(st_epl_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 1 %></option>
			                		<option value="<%=DateTimeUtil.getYear() %>" <% if (String.valueOf(DateTimeUtil.getYear()).equals(st_epl_year)) { %> selected <%} %>><%=DateTimeUtil.getYear()%></option>
			                	</select>&nbsp;년&nbsp;
								<input type="text" name="st_epl" id="st_epl" class="input_type_text" title="" style="width:20%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("EMPLOYEE_CNT")) %>"/>&nbsp;명&nbsp;
							</td>
							<th>*산업분류명</th>			
							<td>
								<input type="text" name="st_ind_name" id="st_ind_name" class="input_type_text" title="" style="width:60%;"  readonly onclick="javascript:doPop('kepIndType');" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("INDUSTRY_NAME"), "") %>"/>
								  <input type="hidden" name="st_ind_type" id="st_ind_type" style="width:80%" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("INDUSTRY_TYPE")) %>"/>
								<a href="javascript:doPop('kepIndType');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:EraserIndType();"><img src="/resources/images/btn_eraser2.gif"></a>
								<%-- <select name="st_ind_type" id="st_ind_type" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "SEL", "CP13","", "ICOMCOD1",sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("INDUSTRY_TYPE")), "") %>                
						         </select> --%>
							</td>
							<th>*주요생산품</th>			
							<td><input type="text" name="st_mi" id="st_mi"" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("MAJOR_ITEM")) %>"/></td>																		  	
						  </tr>
						  <tr>
							<th>*본사전화번호</th>			
							<td><input type="text" name="st_tel_no" id="st_tel_no" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("TEL_NO")) %>"/></td>
							<th>*소재지</th>			
							<td colspan="3"><a href="javascript:doPop('company_address');"><img src="/resources/images/btn_search03.gif"></a></td>																		  	
						  </tr>
						  <tr>
							<th>그룹사</th>			
							<td><input type="text" name="st_group_info" id="st_group_info" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("GROUP_CO_NM")) %>"/></td>
							<th>공장소재지<br>(삭제예정)</th>			
							<td><input type="text" name="st_fact_addr" id="st_fact_addr" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("FACTORY_ADDRESS_LOC")) %>"/></td>
							<th>산업군</th>			
							<td><input type="text" name="st_industry" id="st_industry" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("INDUSTRY_NM")) %>"/></td>																									  	
						  </tr>			
					</tbody>
				</table>	
				<h4><b>구매대행 거래이력</b></h4>
            	<table class="cont_t_list07" style="width:100%">
						<caption>구매대행 거래이력</caption>
						<colgroup>
						<col width="12%" />
                        <col width="20%" />
                        <col width="16%" />
                        <col width="20%" />
                        <col width="13%"/>
                        <col width="*" />                                                   
						</colgroup>
						<tbody>	
						  <tr >
							<th>*현 구매대행<br>거래여부</th>
							<td>			
								<select name="st_mro_yn" id="st_mro_yn"  style="height:20px; width: 60px;" onchange="mrocmpy_onchange()">
									<option value="">선택</option>
									<option value="Y"  <% if (st_mro_yn.equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N"  <% if (st_mro_yn.equals("N")) { %> selected <%} %>>N</option>
			                	</select>
							</td>
							<th>*현 구매대행사</th>			
							<td>
								<select name="st_mro_cmpy" id="st_mro_cmpy" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "SEL", "CP04","", "ICOMCOD1", sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("MRO_COMPANY")), "") %>           
						         </select>
							</td>
							<th>현 구매대행<br>거래개시일</th>			
							<td>
								<input type="text" class="input_type_text" name="st_mro_s_date" id="st_mro_s_date" style="width:75%;" readOnly value="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(st_mro_start)) %>"/></td>
								<a href="javascript:kepCalendar('st_mro_s_date')"></a>
							</td>
						 </tr>
						 <tr>	
							<th>현 구매대행<br>계약만료일</th>			
							<td>
								<input type="text" class="input_type_text" name="st_mro_e_date" id="st_mro_e_date" style="width:75%;" readOnly value="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(st_mro_end)) %>"/></td>
								<a href="javascript:kepCalendar('st_mro_e_date')"></a>
							</td>	
							<th>과거 구매대행<br>거래여부</th>			
							<td>			
								<select name="st_past_mro_yn" id="st_past_mro_yn"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="Y" <% if (st_past_mro_yn.equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N" <% if (st_past_mro_yn.equals("N")) { %> selected <%} %>>N</option>
			                	</select>
							</td>
							<th>과거<br>구매대행사</th>			
							<td>
								<select name="st_past_mro_cmpy" id="st_past_mro_cmpy" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "SEL", "CP04","", "ICOMCOD1", sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("PAST_MRO_COMPANY")), "") %>           
						         </select>
							</td>																								  	
						  </tr>
						 <tr>	
							<th>과거 구매대행<br>거래개시일</th>			
							<td>
								<input type="text" class="input_type_text" name="st_past_mro_date" id="st_past_mro_date" style="width:75%;" readOnly value="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(st_past_mro_start)) %>"/></td>
								<a href="javascript:kepCalendar('st_past_mro_date')"></a>
							</td>	
							<th>과거 구매대행<br>계약만료일</th>			
							<td>
								<input type="text" class="input_type_text" name="st_past_mro_e_date" id="st_past_mro_e_date" style="width:75%;" readOnly value="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(st_past_mro_end)) %>"/></td>
								<a href="javascript:kepCalendar('st_past_mro_e_date')"></a>
							</td>	
							<th>*구매대행<br>거래금액(년)</th>			
							<td><input type="text" name="st_year_mro_amt" id="st_year_mro_amt" class="input_type_text" title="" style="width:60%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("MRO_YEAR_AMT")) %>"/>&nbsp;(단위:억)&nbsp;</td>
						  </tr>
						 <tr>	
							<th>결제조건</th>			
							<td>
								<select name="st_bill_type" id="st_bill_type" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "SEL", "SA15","", "ICOMCOD1", sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("BILL_TYPE")), "") %>           
						         </select>
							</td>	
							<th>시스템구성</th>			
							<td>
								<select name="st_sys_type" id="st_bill_type" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "SEL", "CP05","", "ICOMCOD1",  sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("SYSTEM_TYPE")), "") %>           
						         </select>
							</td>	
							<th>*MRO Spend</th>			
							<td><input type="text" name="st_mro_spd" id="st_mro_spd" class="input_type_text" title="" style="width:60%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("MRO_SPEND")) %>"/>&nbsp;(단위:억)&nbsp;</td>
						  </tr>						  
					</tbody>
				</table>	
				<h4><b>Key-man </b></h4>					 						  
            	<table class="cont_t_list07" style="width:100%">
						<caption>Key-man</caption>
						<colgroup>
						<col width="12%" />
                        <col width="20%" />
                        <col width="16%" />
                        <col width="20%" />
                        <col width="13%"/>
                        <col width="*" />                                                 
						</colgroup>
						<tbody>
						  <tr>
							<th>*부서</th>			
							<td><input type="text" name="st_key_dept" id="st_key_dept" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("KEYMAN_DEPT_NAME1")) %>"/></td>
							<th>*성명/직급</th>			
							<td><input type="text" name="st_key_nm" id="st_key_nm" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("KEYMAN_USER_NAME1")) %>"/></td>
							<th>*연락처</th>
							<td><input type="text" name="st_key_tel" id="st_key_tel" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("KEYMAN_TEL_NAME1")) %>"/></td>
						 </tr>
						  <tr>
							<th>부서</th>			
							<td><input type="text" name="st_key_dept2" id="st_key_dept2" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("KEYMAN_DEPT_NAME2")) %>"/></td>
							<th>성명/직급</th>			
							<td><input type="text" name="st_key_nm2" id="st_key_nm2" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("KEYMAN_USER_NAME2")) %>"/></td>
							<th>연락처</th>
							<td><input type="text" name="st_key_tel2" id="st_key_tel2" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("KEYMAN_TEL_NAME2")) %>"/></td>
						 </tr>
						  <tr>
							<th>부서</th>			
							<td><input type="text" name="st_key_dept3" id="st_key_dept3" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("KEYMAN_DEPT_NAME3")) %>"/></td>
							<th>성명/직급</th>			
							<td><input type="text" name="st_key_nm3" id="st_key_nm3" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("KEYMAN_USER_NAME3")) %>"/></td>
							<th>연락처</th>
							<td><input type="text" name="st_key_tel3" id="st_key_tel3" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("KEYMAN_TEL_NAME3")) %>"/></td>
						 </tr>
						 <tr>
							<th>*관심정도</th>
							<td>
								<select name="st_int_status" id="st_int_status" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "SEL", "CP06","", "ICOMCOD1",  sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("INTEREST_STATUS")), "") %>           
						         </select>
							</td>		
							<th>*담당자 성향</th>			
							<td>
								<select name="st_int_status_user" id="st_int_status_user" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "SEL", "CP07","", "ICOMCOD1",  sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("INTEREST_USER")), "") %>           
						         </select>
						    </td>		
						    <td></td>
						    <td></td>
						  </tr>
						  <tr>
							<th>*주요<br> 관심사항</th>			
							<td colspan="5"><input type="text" name="st_int_main" id="st_int_main" class="input_type_text" title="" style="width:97%;onkeyup="fnCheckInputByte(this, 1000);" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("INTEREST_MAIN")) %>"/></td>
						 </tr>
					</tbody>
				</table>	
			<%
			if(st_buyer_close_flag.equals("Y")){
			%>
            	<table class="cont_t_list07" style="width:100%">
						<caption>종결사유</caption>
						<colgroup>
						<col width="12%" />
                        <col width="*" />                                                 
						</colgroup>
						<tbody>
						  <tr>
							<th>종결사유</th>			
							<td><input type="text" name="st_int_main" id="st_int_main" class="input_type_text" title="" style="width:97%;onkeyup="fnCheckInputByte(this, 1000);" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("BUYER_CLOSE_REMARK")) %>"/></td>
						 </tr>
					</tbody>
				</table>
			<%
			}
			//잠재고객사 등록 화면 일 경우
			if(!st_insertFlag.equals("Y")){
			%>				
				<h4><b>주요 영업활동</b></h4>
				<div class="ib_product" style="border-top:2px solid #3c639c">
	  				<script type="text/javascript">
	  					createIBSheet("mySheet", "100%", "92px");
	  				</script>
	  			</div>
	  			<p class="paging" id="pageindex"></p>
			<%
			}
			%>
            <!--grid-->
			<span class="fr">
			<%
			//잠재고객사 등록 화면 일 경우
			if(st_insertFlag.equals("Y")){
			%>
				<span class="btn_02 mr04"><a href="javascript:doAction('save')">저장</a></span>
			<%
			}else{
				//잠재고객사 종결일 경우
				if(st_buyer_close_flag.equals("Y")){
			%>
					<span class="btn_02 mr04"><a href="javascript:doAction('reStart')">재개</a></span>
			<%
				}else if(st_buyer_close_flag.equals("N")){
			%>
					<span class="btn_06 mr04"><a href="javascript:doPop('add');">영업활동 추가</a></span>
					<span class="btn_06 mr04"><a href="javascript:doAction('delete');">영업활동 삭제</a></span>
				<%if(st_process_status_type.equals("GA")){%>	
						<span class="btn_06 mr04"><a href="javascript:processAction('comp','BI')">유선영업 완료</a></span>		
				<%}%>
				<%if(st_process_status_type.equals("BI")){%>
						<span class="btn_06 mr04"><a href="javascript:processAction('comp','GA')">유선영업 변경</a></span>	
						<span class="btn_06 mr04"><a href="javascript:processAction('comp','BD')">대면영업 완료</a></span>		
				<%}%>
				<%if(!st_process_status_type.equals("CP")){%>
						<span class="btn_08 mr04"><a href="javascript:doAction('cmy_update')">기업정보 업데이트</a></span>
						<span class="btn_02 mr04"><a href="javascript:doAction('update')">저장</a></span>
						<span class="btn_02 mr04"><a href="javascript:doAction('end')">종결</a></span>
				<%}%>
			<%
				}
			}
			%>
			</span>
			<br/>
		</div>	
        <!--버튼영역-->

        
    </div>
</form> 
</body>
</html>
