<%--
**********************************************
* 메뉴 : 마감관리 > 계산서Mapping > 미매핑 세금계산서 조회
* 화면 : 미매핑 세금계산서 조회
* 기능 : 
* 프로그램 ID :
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	String st_reg_no	= CommonUtil.nvl((String)request.getParameter("regNo"),"");
	String st_customer_nm	= CommonUtil.nvl((String)request.getParameter("customerNm"),"");
	String st_acode		= CommonUtil.nvl((String)request.getParameter("aCode"),""); 
	String st_ref_no2	= CommonUtil.nvl((String)request.getParameter("refNO2"),"");
	String st_prin_amount	= CommonUtil.nvl((String)request.getParameter("prinAmount"),"");
	String st_gbn		= CommonUtil.nvl((String)request.getParameter("gbn"),"");
	String st_acc_no	= CommonUtil.nvl((String)request.getParameter("accNo"),"");
	String st_acc_seq	= CommonUtil.nvl((String)request.getParameter("accSeq"),"");
	String st_surtax	= CommonUtil.nvl((String)request.getParameter("surtax"),"");
	String st_su_email	= CommonUtil.nvl((String)request.getParameter("suEmail"),"");
	String st_ip_email	= CommonUtil.nvl((String)request.getParameter("ipEmail"),"");
	String st_from_date	= CommonUtil.nvl((String)request.getParameter("fromDate"),"");
	String st_to_date	= CommonUtil.nvl((String)request.getParameter("toDate"),"");
	String st_issue_id = CommonUtil.nvl((String)request.getParameter("issueId"),"");
	String st_issueId_yn	= CommonUtil.nvl((String)request.getParameter("issueIdYn"),"N");
	String st_group_key	= CommonUtil.nvl((String)request.getParameter("group_key"),"");
	String st_mapping_type	= CommonUtil.nvl((String)request.getParameter("mapping_type"),"");
	String st_irs_no	= CommonUtil.nvl((String)request.getParameter("irsNo"),"");
	
	
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>미매핑 세금계산서 조회</title>
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
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet2 = {};
	initsheet2.Cols = [
				{ Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",				Header:"상태",							SaveName:"sStatus"}
				,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,		Hidden:false,	Type:"DummyCheck",	Header:"",				    			SaveName:"SELECTED",		HeaderCheck:0}
				,{ Align:"Center",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",					Header:"사업자번호",				SaveName:"IRS_NO"}
				,{ Align:"left",		Width:150,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",					Header:"사업자명",					SaveName:"IRS_NAME"}
				,{ Align:"Center",	Width:80,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",					Header:"매출/매입",					SaveName:"ACODE"}
				,{ Align:"Center",	Width:200,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",					Header:"전표번호",					SaveName:"ACCNO"}
				,{ Align:"Center",	Width:60,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",					Header:"항번",							SaveName:"ACCSEQ"}
				,{ Align:"right",	Width:140,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",				Header:"공급가액",					SaveName:"PRIN_AMOUNT"}
				,{ Align:"right",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",				Header:"부가세",						SaveName:"TAX"}
				,{ Align:"Center",	Width:180,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",					Header:"KEP세금계산서번호",		SaveName:"KEP_TAX_BILL_NO"}
	];
	
	var initsheet = {};
	initsheet.Cols = [
				 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",				Header:"상태",							SaveName:"sStatus"}
				,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,		Hidden:false,	Type:"DummyCheck",	Header:"",				    			SaveName:"SELECTED",		HeaderCheck:0}
         		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Date",				Header:"작성일자",					SaveName:"ISSUE_DATE"}
         		,{ Align:"Left",		Width:160,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",					Header:"국세청승인번호",			SaveName:"ISSUE_ID"}
         		,{ Align:"Left",		Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",					Header:"세금계산서종류",			SaveName:"TYPE_CODE"}
         		,{ Align:"right",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",				Header:"공급가액",					SaveName:"CHARGETOTAL"}
         		,{ Align:"right",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",				Header:"부가세",						SaveName:"TAXTOTAL"}
         		,{ Align:"right",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",				Header:"합계",							SaveName:"GRANDTOTAL"}
         		,{ Align:"Left",		Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",					Header:"공급자이메일",				SaveName:"SU_EMAIL"}
         		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",					Header:"공급자담당자",				SaveName:"SU_PERSNAME"}
         		,{ Align:"Left",		Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",					Header:"공급받는자이메일",		SaveName:"IP_EMAIL1"}
         		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",					Header:"공급받는자담당자명",	SaveName:"IP_PERSNAME1"}
         		,{ Align:"Left",		Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",					Header:"세금계산서비고",			SaveName:"DESC_TEXT1"}
         		,{ Align:"Left",		Width:100,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",					Header:"수정사유",					SaveName:"AMEND_CODE"}
         		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",					Header:"사업자번호",				SaveName:"IP_ID",}
         		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",					Header:"사업자명",					SaveName:"IP_NAME"}
	];
	initsheet.HeaderMode = {Sort:0,ColMove:0};
	initsheet2.HeaderMode = {Sort:0,ColMove:0};
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	IBS_InitSheet(mySheet2, initsheet2, pagingMode);
	
	var userDept = $("#st_dept_code").val();
	
	if(userDept == "005" || userDept == "095" || userDept == "094"){
		// 관리팀, 시스템팀만 달력이미지 보임(관리팀 외 일자 수정 변경 막기 위함)
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
	}
	
	resetValue();
	doAction( "search1");
}

var st;
var mt;
var st_issueId_yn_flag = "<%=st_issueId_yn%>";

function resetValue() {
	// 일자 설정
	var tempDate = kepToMonthAdd("1","M").replace(/[/]/gi,"");
	var tempYear = tempDate.substring(0,4);
	var tempMonth = tempDate.substring(4,6);
	var tempDay = lastDay(tempYear, tempMonth, "");
	//$("#st_from_date").val( kepGetDateStr(tempYear+tempMonth+"01", "/") );
	//$("#st_to_date").val( kepGetDateStr(tempDay, "/") );
	
	//전표금액 셋팅
	var accAmt = Number( $("#st_accAmt").val() );
	var accTax = Number( $("#st_accTax").val() );
	var totAmt = Number( $("#st_totAmt").val() );
	var totTax = Number( $("#st_totTax").val() );
	
	$("#buyerAccAmt").html( kepCommaNum(accAmt) );
	$("#buyerAccTax").html( kepCommaNum(accTax) );
	$("#buyerAmt").html( kepCommaNum(totAmt) );
	$("#buyerTaxAmt").html( kepCommaNum(totTax) );
}

function checkAllTop(){
	var sumAmt = 0;
	var sumTax = 0;
	var selAmt = 0;
	var selTax = 0;

	for ( var i = 1; i <= mySheet2.RowCount(); i++ ) {
		mySheet2.SetCellValue(i, "SELECTED", "1");
		selAmt = Number( kepFilterNum( String( mySheet2.GetCellValue(i, "PRIN_AMOUNT") ) ) );
		selTax = Number( kepFilterNum( String( mySheet2.GetCellValue(i, "TAX") ) ) );
		
		if(st_issueId_yn_flag == "Y"){
			mySheet2.SetCellEditable(i, 1, 0);
		}
		
		sumAmt = sumAmt + selAmt;
		sumTax = sumTax + selTax;
	}
	
	$("#buyerAccAmt").html( kepCommaNum(sumAmt) );
	$("#buyerAccTax").html( kepCommaNum(sumTax) );
	$("#st_accAmt").val(sumAmt);
	$("#st_accTax").val(sumTax);
}

function checkAllBtm(){
	var sumAmt = 0;
	var sumTax = 0;
	var selAmt = 0;
	var selTax = 0;

	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		mySheet.SetCellValue(i, "SELECTED", "1");
		selAmt = Number( kepFilterNum( String( mySheet.GetCellValue(i, "CHARGETOTAL") ) ) );
		selTax = Number( kepFilterNum( String( mySheet.GetCellValue(i, "TAXTOTAL") ) ) );
		mySheet.SetCellEditable(i, 1, 0);
		
		sumAmt = sumAmt + selAmt;
		sumTax = sumTax + selTax;
	}
	
	$("#buyerAmt").html( kepCommaNum(sumAmt) );
	$("#buyerTaxAmt").html( kepCommaNum(sumTax) );
	$("#st_totAmt").val(sumAmt);
	$("#st_totTax").val(sumTax);
}

//현재달의 마지막날(일자) 구하기
function lastDay(y , m , kind) {
	var d2, s = "";           
    var year, month, day;           

    d2 = new Date(y,m,"");
   
    year  = d2.getFullYear();                          
	month = (d2.getMonth()+1);
    day   = d2.getDate();
	
	if ( month < 10 ) {
		month = "0" + month;
    }
	if ( day < 10 ) {
		day = "0" + day;
    }

	s = String(year) + String(month) + String(day);

	return(s);                             
}

// 그리드 표시후 처리
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

//그리드 표시후 처리
function mySheet2_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {
	st = new Date();
	
	switch (str) {
		case "search1": // 상단 그리드 조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet2 , "/cmcl/getMasterCmClIssueIdInfoPop1.do" , pagingMode );
			break;
		case "search2": // 하단 그리드 조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/cmcl/getMasterCmClIssueIdInfoPop.do" , pagingMode );
			break;
		case "save": // 저장
			if ( !validationSave() )return;
			saveCall();
			break;	
		case "confirm": //확인
			var userNameLoc = "";
			var phoneNumber = "";
			var email = "";
			var cnt =0;
			for ( var i =1; i < mySheet.RowCount()+1;i++) {
				if ( mySheet.GetCellValue(i, "SELECTED") == 1) {
					userNameLoc = mySheet.GetCellValue(i, "USER_NAME_LOC");
					phoneNumber = mySheet.GetCellValue(i, "PHONE_NUMBER");
					email = mySheet.GetCellValue(i, "EMAIL");
					cnt++;
				}
			}
			if(cnt > 1){
				alert("다중 선택은 불가능 합니다.");
				return;
			}
			opener.setPopupReturn(userNameLoc,phoneNumber,email);
			this.close();
			break;
	}
}

function saveCall(){ // 매핑타입(11, 1N, N1, NN) 결정 후 저장 
	var accNo = "";
	var accSeq = "";
	var issueId = "";
	var groupKey = "";
	
	// 상단 그리드 체크 개수 체크
	var chkRowCntTop = mySheet2.CheckedRows(1);
	
	// 하단 그리드 체크 개수 체크
	var chkRowCntBtm = mySheet.CheckedRows(1);
	
	if(chkRowCntTop > 1 && chkRowCntBtm > 1){
		$("#st_mapping_type").val("NN");
	}else if(chkRowCntTop > 1 && chkRowCntBtm == 1){
		$("#st_mapping_type").val("N1");
	}else if(chkRowCntTop == 1 && chkRowCntBtm > 1){
		$("#st_mapping_type").val("1N");
	}else if(chkRowCntTop == 1 && chkRowCntBtm == 1){
		$("#st_mapping_type").val("11");
	}else{
		alert("매핑할 전표 및 세금계산서의 선택항목이 없습니다.");
		return;
	}
	
	for ( var i = 1; i <= mySheet2.RowCount(); i++ ) {
		if ( mySheet2.GetCellValue(i, "SELECTED") == 1 ) {
			groupKey = mySheet2.GetCellValue(i, "ACCNO") + mySheet2.GetCellValue(i, "ACCSEQ"); // 마지막 accNo와 accSeq의 조합 
			accNo += mySheet2.GetCellValue(i, "ACCNO") + "@";
			accSeq += mySheet2.GetCellValue(i, "ACCSEQ") + "@";
		}
	}
	
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			issueId += mySheet.GetCellValue(i, "ISSUE_ID") + "@";
		}
	}
	
	$("#st_acc_no").val(accNo);
	$("#st_acc_seq").val(accSeq);
	$("#st_issue_id").val(issueId);
	$("#st_group_key").val(groupKey);
	
	if (!confirm('선택 내용과 같이 매핑하시겠습니까?'))
		return;
	kepAjaxFormCall("/cmcl/savetMasterCmClArApMappingList.do", "searchCondition", "MAPPING");
}

// 하단 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if ( Row  < 1) return;
	
	if(st_issueId_yn_flag == "Y") return;
	
	if ( column == 'SELECTED' ) {//체크박스
		setAmtBtmGrid(Row, Value);
	}
}

// 상단 그리드 셀클릭 이벤트
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	var column = mySheet.ColSaveName(mySheet2.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if ( Row  < 1) return;
	
	if(st_issueId_yn_flag == "Y") return;
	
	if ( column == 'SELECTED' ) {//체크박스
		setAmtTopGrid(Row, Value);
	}
}

// 변경 여부 체크
function checkRow() {
	var check = true;
	
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "sStatus") != 'R' ) {
        	check = false;
        	break;
		}
	}
	
	if ( check ) {
		alert("변경된 항목이 없습니다.");
		return false;
	}
	
	return true;
}

// 하단 그리드 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	
	if(st_issueId_yn_flag == "Y"){
		checkAllBtm();	
	}
}

// 상단 그리드 조회 후처리
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	checkAllTop();
	doAction("search2");
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg);
	}

	if ( code > 0 ) {
		//저장 성공시 처리
		opener.doAction("search");
		this.close();
	}
}

//트랜젝션(저장,삽입등) 후처리
function mySheet2_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg);
	}

	if ( code > 0 ) {
		//저장 성공시 처리
		opener.doAction("search");
		this.close();
	}
}

// 하단 그리드 금액정보 처리
function setAmtBtmGrid(index, value) {
	var buyerAmt = 0;
	var buyerTax = 0;
	var selAmt = Number( kepFilterNum( String( mySheet.GetCellValue(index, "CHARGETOTAL") ) ) );
	var selTax = Number( kepFilterNum( String( mySheet.GetCellValue(index, "TAXTOTAL") ) ) );
	var totAmt = Number($("#st_totAmt").val());
	var totTax = Number($("#st_totTax").val());
	
	if( value == "1" ) {
		buyerAmt = totAmt + selAmt;
		buyerTax = totTax + selTax;
	} else {
		buyerAmt = totAmt - selAmt;
		buyerTax = totTax - selTax;
	}

	// 선택한 공급가액, 부가가치세액, 누적공급가액 설정
	$("#buyerAmt").html( kepCommaNum(buyerAmt) );
	$("#buyerTaxAmt").html( kepCommaNum(buyerTax) );
	$("#st_totAmt").val(buyerAmt);
	$("#st_totTax").val(buyerTax);
}

// 상단 그리드 금액정보 처리
function setAmtTopGrid(index, value) {
	var buyerAmt = 0;
	var buyerTax = 0;
	var selAmt = Number( kepFilterNum( String( mySheet2.GetCellValue(index, "PRIN_AMOUNT") ) ) );
	var selTax = Number( kepFilterNum( String( mySheet2.GetCellValue(index, "TAX") ) ) );
	var totAmt = Number($("#st_accAmt").val());
	var totTax = Number($("#st_accTax").val());
		
	if( value == "1" ) {
		buyerAmt = totAmt + selAmt;
		buyerTax = totTax + selTax;
	} else {
		buyerAmt = totAmt - selAmt;
		buyerTax = totTax - selTax;
	}

	// 선택한 공급가액, 부가가치세액, 누적공급가액 설정
	$("#buyerAccAmt").html( kepCommaNum(buyerAmt) );
	$("#buyerAccTax").html( kepCommaNum(buyerTax) );
	$("#st_accAmt").val(buyerAmt);
	$("#st_accTax").val(buyerTax);
}

function validationSave() {
	
	var stTotAmt= Number( $("#st_totAmt").val());
	var stTotTax= Number( $("#st_totTax").val());
	var accAmt = Number( $("#st_accAmt").val());
	var accTax = Number( $("#st_accTax").val());
	var remsg = "";
	var accuracy = $("#st_accuracy").val("Y");;
	
	if(stTotAmt != accAmt ){
		remsg = alert("선택한 세금계산서 금액과 전표금액이 차이가 있습니다.\n 금액불일치로 저장할 수 없습니다.");
		//$("#st_accuracy").val("N");
	    return false;
	}else if(stTotTax != accTax ){
		remsg = alert("선택한 세금계산서 금액과 전표금액이 차이가 있습니다.\n 금액불일치로 저장할 수 없습니다.");
		//$("#st_accuracy").val("N");
	    return false;
	}    
	return true;
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "MAPPING"){
		alert("정상적으로 매핑되었습니다.");
		opener.setPopupReturn();
		this.close();
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("오류가 발생하였습니다.");
} 

</script> 
<body onload="kep_onload_view();">
<form id = "searchCondition" name = "searchCondition" method = "post" onsubmit="return false">
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id=st_user_id  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_dept_code" name="st_dept_code"  value="${sessionInfo.department}">
	<input type="hidden" id="st_ip_id" name="st_ip_id"  value="<%=st_reg_no%>">
	<input type="hidden" id="st_ar_ap" name="st_ar_ap"	value="<%=st_gbn%>">
	<input type="hidden" id="st_acc_no" name="st_acc_no"	value="<%=st_acc_no%>">
	<input type="hidden" id="st_acc_seq" name="st_acc_seq"	value="<%=st_acc_seq%>">
	<input type="hidden" id="st_totAmt" name="st_totAmt"  value="0">
	<input type="hidden" id="st_totTax" name="st_totTax"  value="0">
	<input type="hidden" id="st_accAmt" name="st_accAmt"  value="0">
	<input type="hidden" id="st_accTax" name="st_accTax"  value="0">
	<input type="hidden" id="st_accuracy" name="st_accuracy"  value="">
	<input type="hidden" id="st_group_key" name="st_group_key"  value="<%=st_group_key%>">
	<input type="hidden" id="st_mapping_type" name="st_mapping_type"  value="<%=st_mapping_type%>">
	<input type="hidden" id="st_issue_id" name="st_issue_id"  value="">
	<input type="hidden" id="st_issueId_yn" name="st_issueId_yn"  value="<%=st_issueId_yn%>">
	<input type="hidden" id="st_irs_no" name="st_irs_no"  value="<%=st_irs_no%>">
	
	<div id="popWrapper" style="height:250px;">
    	<div id="popHeader">
        	<h1 class="title">미매핑 세금계산서 조회</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
        <%if(("N").equals(st_issueId_yn)){%>
            <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:doAction('search1')">조회</a></span>
            </div>
		<%}%>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet2", "", "160px");
				</script>
			</div>
			
			<br>
			
        	<table class="cont_t_list06">
            	<caption>리스트</caption>
                <colgroup>
                    <col width="13%" />
                    <col width="20%" />
                    <col width="13%" />
                    <col width="20%" />
                    <col width="13%" />
                    <col width="*" />
                </colgroup>
                <tbody>
                	<tr>
                      <th>계산서작성일자</th>
                      <td colspan="5">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:80px; text-align:center;" value="<%=st_from_date%>">
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:80px; text-align:center;" value="<%=st_to_date%>">
                      </td>
                	</tr>
                	<tr>
                      <th>국세청승인번호</th>
                      <td>
                      	<input type="text" class="input_type_text" name="st_issue_id" id="st_issue_id" style="width:75%" value="<%=st_issue_id %>" onkeydown="kepEnter()">
                      </td>
                      <th>공급받는자 이메일</th>
                      <td>
                      	<input type="text" class="input_type_text" name="st_ip_email" id="st_ip_email" style="width:75%" value="<%=st_ip_email %>" onkeydown="kepEnter()">
                      </td>
                      <th>공급자 이메일</th>
                      <td>
                      	<input type="text" class="input_type_text" name="st_su_email" id="st_su_email" style="width:75%" value="<%=st_su_email %>" onkeydown="kepEnter()">
                      </td>                      
                	</tr>
                </tbody>
            </table>
            
			<br>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "160px");
				</script>
			</div>
			<!--금액영역-->
			<div>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" border="1" bgcolor="#FFFFFF">
					<tr>
						<td height="35" align="right" style="font-weight:bold" align="center" width="50%">
							전표공급가액:<span id="buyerAccAmt" style="font-weight:bold; color:orange;">0</span>원&nbsp;&nbsp;&nbsp;
							전표부가가치세액:<span id="buyerAccTax" style="font-weight:bold; color:orange;">0</span>원
						</td>
						<td height="35" align="right" style="font-weight:bold" align="center" width="50%">
							 선택공급가액합계:<span id="buyerAmt" style="font-weight:bold; color:orange;">0</span>원&nbsp;&nbsp;&nbsp;
							 선택부가가치세액합계:<span id="buyerTaxAmt" style="font-weight:bold; color:orange;">0</span>원
						</td>
					</tr>
				</table>
			</div>
			<!--버튼영역-->
		<%if(("N").equals(st_issueId_yn)){%>
	        <div class="btnArea">
				<span class="fr">
					<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>				
				</span>
			</div>
		<%}%>
		</div>	
    </div>
</form> 
</body>
</html>
