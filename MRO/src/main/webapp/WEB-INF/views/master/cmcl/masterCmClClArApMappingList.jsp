<%--
**********************************************
* 메뉴 : 마감관리>계산서Mapping
* 화면 : 계산서Mapping
* 기능 :
* 프로그램 ID : 
* 담당자 : 옥대수
* 착수일 : 
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
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>
<%
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

	String user_dept = "";
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		user_dept =  CommonUtil.nvl((String)sessionInfo.getDepartment()); 
	}
%>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

var unit01 = KepSheetComboData("TX03", "");		// IBSHEET : 발행주체
var unit02 = KepSheetComboData("TX09", "");		// IBSHEET : 발행사이트

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",  Width:60,	Edit:false,	EditLen:0,		Hidden:true,	ColMerge:0, Type:"Status",			    Header:"상태|상태",			SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,	    Hidden:false,	ColMerge:0, Type:"DummyCheck",		Header:"|",						SaveName:"SELECTED"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	    Hidden:false,	ColMerge:1, Type:"Text",				Header:"전표정보|매핑상태",		SaveName:"MAPPING_STATUS"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	    Hidden:true,	ColMerge:1, Type:"Text",				Header:"전표정보|정확도",		SaveName:"ACCURACY"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	    Hidden:false,	ColMerge:1, Type:"Text",				Header:"전표정보|확정여부",		SaveName:"CONFIRM_CLS_TEXT"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:95,	    Hidden:false,	ColMerge:1, Type:"Text",				Header:"전표정보|매출/매입",		SaveName:"ACODE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:1, Type:"Text",				Header:"전표정보|사이트",		SaveName:"SITE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:1, Type:"Text",				Header:"전표정보|전표타입",		SaveName:"REFNO2"}
		,{ Align:"Center",	Width:170,	Edit:false,	EditLen:170,	Hidden:false,	ColMerge:1, Type:"Text",				Header:"전표정보|매핑그룹",		SaveName:"GROUP_KEY"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	ColMerge:1, Type:"Text",				Header:"전표정보|매핑타입",		SaveName:"MAPPING_TYPE"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:1, Type:"Float",				Header:"전표정보|총공급가액",	SaveName:"TOTAL_PRIN_AMOUNT"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:1, Type:"Float",				Header:"전표정보|총부가세",	SaveName:"TOTAL_TAX"}
		,{ Align:"Center",	Width:150,	Edit:false,	EditLen:190,	Hidden:false,	ColMerge:1, Type:"Text",				Header:"전표정보|전표번호",	SaveName:"ACCNO"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:1, Type:"Text",				Header:"전표정보|행번호",	SaveName:"ACCSEQ"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:1, Type:"Date",				Header:"전표정보|작성일자",	SaveName:"ISSUE_DATE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:1, Type:"Text",				Header:"전표정보|통화",	    SaveName:"CURRENCY"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:1, Type:"Float",				Header:"전표정보|합계금액",	SaveName:"PRIN_AMOUNT"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:1, Type:"Float",				Header:"전표정보|부가세",	SaveName:"CREDIT"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:true,	ColMerge:1, Type:"Text",				Header:"전표정보|부서코드",	SaveName:"KEP_DEPT_CD"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:1, Type:"Text",				Header:"전표정보|부서명",	SaveName:"KEP_DEPT_NM"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:true,	ColMerge:1, Type:"Text",				Header:"전표정보|부서코드",	SaveName:"A01_CCODE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:true,	ColMerge:1, Type:"Text",				Header:"전표정보|계정명",	SaveName:"ACODENM"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:1, Type:"Text",				Header:"전표정보|비고",	    SaveName:"REMARK"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:1, Type:"Text",				Header:"전표정보|사업자번호",	SaveName:"A01_REGNO"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:1, Type:"Text",				Header:"전표정보|사업자명",	SaveName:"A01_CUSTOMERNM"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:1, Type:"Text",				Header:"전표정보|원가중심점",	SaveName:"CT01_NAME"}
		,{ Align:"Center",	Width:150,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:1, Type:"Text",				Header:"전표정보|KEP세금계산서",	SaveName:"A01_REFNO2"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:1, Type:"Date",				Header:"전표정보|발행일자",	SaveName:"ENTRY_DATE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:1, Type:"Date",				Header:"전표정보|전표생성일자",	SaveName:"CREATE_DATE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:true,	ColMerge:1, Type:"Text",				Header:"전표정보|담당자사번",	SaveName:"EMPLOYEE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:1, Type:"Text",				Header:"전표정보|담당자",	SaveName:"USER_NM"}
		,{ Align:"Center",	Width:180,	Edit:false,	EditLen:180,	Hidden:false,	ColMerge:0, Type:"Text",				Header:"세금계산서정보|국세청번호",	SaveName:"ISSUE_ID"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:0, Type:"Date",				Header:"세금계산서정보|전자세금계산서작성일",	SaveName:"ISSUE_DT"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:0, Type:"Text",				Header:"세금계산서정보|세금계산서종류",	SaveName:"TYPE_CODE"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:0, Type:"Float",				Header:"세금계산서정보|공급가액",	SaveName:"CHARGETOTAL"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:0, Type:"Float",				Header:"세금계산서정보|부가세",	SaveName:"TAXTOTAL"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:0, Type:"Text",				Header:"세금계산서정보|발행사이트",	SaveName:"ASP_CODE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:0, Type:"Text",				Header:"세금계산서정보|공급자이메일",	SaveName:"SU_EMAIL"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:0, Type:"Text",				Header:"세금계산서정보|공급자담당자명",	SaveName:"SU_PERSNAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:0, Type:"Text",				Header:"세금계산서정보|공급받는자이메일",	SaveName:"IP_EMAIL1"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:0, Type:"Text",				Header:"세금계산서정보|공급받는자명",	SaveName:"IP_PERSNAME1"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	ColMerge:0, Type:"Text",				Header:"세금계산서정보|비고",	SaveName:"DESC_TEXT1"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:true,	ColMerge:0, Type:"Text",				Header:"세금계산서정보|수정사유",	SaveName:"AMEND_CODE"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:160,	Hidden:false,	ColMerge:0, Type:"Image",				Header:"세금계산서정보|첨부",	SaveName:"IMAGE_KEY_YN"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:true,	ColMerge:0, Type:"Text",				Header:"|",	SaveName:"M_STATUS"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:true,	ColMerge:0, Type:"Text",				Header:"|",	SaveName:"CONFIRM_CLS"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:true,	ColMerge:0, Type:"Text",				Header:"|",	SaveName:"KEP_EMAIL"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:160,	Hidden:true,	ColMerge:0, Type:"Text",				Header:"|",	SaveName:"IMAGE_KEY"}
	];
	//InitHeaders의 두번째 인자
	initsheet.Cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge, FrozenCol:1};
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1};
	var cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	IBS_InitSheet(mySheet, initsheet, pagingMode,'XLS');
	mySheet.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	//파일첨부이미지설정
	mySheet.SetImageList(2, diskOff);
	mySheet.SetImageList(3, diskOn);
	
	setLinkCol(mySheet, "IMAGE_KEY_YN");
	
	setLinkCol(mySheet, "ISSUE_ID"); // 국세청번호
	resetValue();
}
//초기화 설정
function resetValue() {
	// 일자 설정
	var tempDate = kepToMonthAdd("1","M").replace(/[/]/gi,"");
	var tempYear = tempDate.substring(0,4);
	var tempMonth = tempDate.substring(4,6);
	var tempDay = lastDay(tempYear, tempMonth, "");
	$("#st_from_date").val( kepGetDateStr(tempYear+tempMonth+"01", "/") );
	$("#st_to_date").val( kepGetDateStr(tempDay, "/") );
	
	// 콤보데이터 셋팅
	kepAjaxCommonQueryIdSearchTwoCombo('st_add_user_id','common.masterDepartmentUserList','PG_10_M_010_00','','ALL','${sessionInfo.userId}'); // 조회조건 : 담당자
	kepAjaxCommonQueryIdCombo('st_user_dept','master.cmcl.selectMasterCmClArApDeptList','ALL','${sessionInfo.department}');
	

	$("#st_mapping").val("N");
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
	
function checkLoc(){
	var search = kepSelectOptionVal('st_dept');
	kepAjaxCommonQueryIdSearchTwoCombo("st_user","common.masterDepartmentUserList",'PG_10_M_001_00',search,"ALL","");
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

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && str !="AR_AUTO_MAPPING" && str !="AP_AUTO_MAPPING" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search": // 조회
			current_page =-1;
			kepSearch(document.searchCondition,  mySheet , "/cmcl/getMasterCmClArApMappingList.do" , pagingMode );
			break;
	
		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;
	
		case "save": // 저장
			if(mySheet.CheckedRows(1) > 1){
				alert("수기계산서매핑은 한 건만 가능합니다.");
				return;
			}
		
			if ( !validationSave() )return;
			if (!confirm('선택한 항목을 수기세금계산서 매핑으로 저장 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/cmcl/saveExceptionMasterCmClArApMappingList.do" , "SELECTED" );
			break;
			
		case "confirm": // 확정
			if ( !validationConfirm() )return;
			if (!confirm('선택한 항목을 확정 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/cmcl/confirmMasterCmClArApMappingList.do" , "SELECTED" );
			break;
			
		case "cancleMapping": // 매핑취소
			if ( !validationCancleMapping() )return;
			if (!confirm('선택한 항목을 매핑취소 하시겠습니까?\n(동일 전표번호/항번 건은 함께 취소됩니다.)'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/cmcl/cancleMappingMasterCmClArApMappingList.do" , "SELECTED" );
			break;

		case "cancle": // 확정취소
			if ( !validationCancle() )return;
			if (!confirm('선택한 항목을 확정취소 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/cmcl/cancleMasterCmClArApMappingList.do" , "SELECTED" );
			break;
		
		case "mappingPop": // 계산서 매핑
			mappingPopOpen();
			break;
		
		case "AR_AUTO_MAPPING": // 매출 자동매핑
			kepAjaxFormCall("/cmcl/callProcTaxMappingAr.do", "searchCondition", "MAPPING");
			break;
		
		case "AP_AUTO_MAPPING": // 매입 자동매핑
			kepAjaxFormCall("/cmcl/callProcTaxMappingAp.do", "searchCondition", "MAPPING");
			break;
	}
}
var grbRow = "";

function mappingPopOpen(){
	var fromDate = "";
	var toDate = "";
	var tempYear = "";
	var tempMonth = "";
	var tempDay ="";
	var kepEmail = "";
	var group_key = "";
	var gbn = "";
	var suEmail = "";
	var ipEmail = "";
	var old_irs_no = "";
	var next_irs_no = "";
	var old_issue_date = "";
	var next_issue_date = "";
	var old_acode = "";
	var next_acode = "";
	var cnt = 1;
	
	for ( var i = 2; i <= mySheet.RowCount()+1; i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			group_key += mySheet.GetCellValue(i, "GROUP_KEY") + "@";
			next_irs_no = mySheet.GetCellValue(i, "A01_REGNO"); // 사업자번호
			next_issue_date = mySheet.GetCellValue(i, "ISSUE_DATE").substring(0, 6); // 작성년월
			next_acode = mySheet.GetCellValue(i, "ACODE"); // 매출/매입
			kepEmail = mySheet.GetCellValue(i, "KEP_EMAIL");
			
			if ( mySheet.GetCellValue(i, "CONFIRM_CLS") == 'Y' ) {
				alert(i-1 + "번째 확정건은 매핑이 불가능합니다.");
				return;
			}
			
			if ( mySheet.GetCellValue(i, "M_STATUS") != '' ) {
				alert(i-1 + "번째 매핑완료건은 매핑이 불가능합니다.");
				return;
			}
			
			if(cnt > 1){
				if(next_acode != old_acode){
					alert("매출/매입이 다른 건들은 함께 매핑할 수 없습니다.");
					return;
				}
				
				if(next_irs_no != old_irs_no){
					alert("사업자번호가 다른 건들은 함께 매핑할 수 없습니다.");
					return;
				}
				
				if(next_issue_date != old_issue_date){
					alert("작성년월이 다른 건들은 함께 매핑할 수 없습니다.");
					return;
				}
			}
			cnt = cnt + 1;
		}
		
		old_irs_no = next_irs_no;
		old_issue_date = next_issue_date;
		old_acode = next_acode;
	}
	
	if(old_acode =="매출"){
		gbn = "AR";
		suEmail = kepEmail;
		ipEmail = "";
	}else{
		gbn = "AP";
		suEmail = "";
		ipEmail = kepEmail;
	}
	
	// 선택한 정보의 발행일로 시작일, 종료일 세팅
	tempYear = old_issue_date.substring(0,4);
	tempMonth = old_issue_date.substring(4,6);
	tempDay = lastDay(tempYear, tempMonth, "");
	
	fromDate = old_issue_date + "01";
	toDate = tempDay;
	
	fromDate = kepDateSlashAdd(fromDate);
	toDate = kepDateSlashAdd(toDate);
	
	var params = "?group_key="+group_key+"&gbn="+gbn+"&suEmail="+suEmail+"&ipEmail="+ipEmail+"&fromDate="+fromDate+"&toDate="+toDate+"&irsNo="+old_irs_no ;
	doPop('masterCmClIssueIdInfoPop', params);
}

//Valitation - 저장
function validationSave() {
	var misDept = "005"; // 관리팀
	var userDept = $("#st_dept_code").val();
	
	for ( var i = 2; i <= mySheet.RowCount()+1; i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			if ( mySheet.GetCellValue(i, "CONFIRM_CLS") == 'Y' ) {
				alert(i-1 + "번째 확정건은 수기계산서매핑이 불가능합니다.");
				return false;
			}
			if ( mySheet.GetCellValue(i, "M_STATUS") != '' ) {
				alert(i-1 + "번째 매핑완료건은 수기계산서매핑이 불가능합니다.");
				return false;
			}
			if ((mySheet.GetCellValue(i, "IMAGE_KEY") == '') && (userDept != misDept)) {
				alert(i-1 + "번째 미첨부건은 수기계산서매핑이 불가능합니다.");
				return false;
			}
		}
	}
	
	return true;
}
//Valitation - 확정
function validationConfirm() {
	for ( var i = 2; i <= mySheet.RowCount()+1; i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			if ( mySheet.GetCellValue(i, "CONFIRM_CLS") == 'Y' ) {
				alert(i-1 + "번째 확정건입니다. 확인 부탁합니다.");
				return false;
			}
			if ( mySheet.GetCellValue(i, "M_STATUS") == '' ) {
				alert(i-1 + "번째 미맵핑건입니다. 확인 부탁합니다.");
				return false;
			}
		}
	}
	return true;
}
//Valitation - 매핑취소
function validationCancleMapping() {
	for ( var i = 2; i <= mySheet.RowCount()+1; i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			if ( mySheet.GetCellValue(i, "CONFIRM_CLS") == 'Y' ) {
				alert(i-1 + "번째 확정건이므로 매핑취소가 불가능 합니다.");
				return false;
			}
			if ( mySheet.GetCellValue(i, "M_STATUS") == '' ) {
				alert(i-1 + "번째 미맵핑건입니다. 확인 부탁합니다.");
				return false;
			}
		}
	}
	return true;
}
//Valitation - 취소
function validationCancle() {
	var misDept = "005";
	var userDept = $("#st_dept_code").val();
	if(userDept == misDept){
		for ( var i = 2; i <= mySheet.RowCount()+1; i++ ) {
			if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {

				if ( mySheet.GetCellValue(i, "CONFIRM_CLS") != 'Y' ) {
					alert(i-1 + "번째 미확정건이므로 확정취소가 불가능 합니다.");
					return false;
				}
			}
		}
	}else{
		alert("확정취소는 관리팀만 가능합니다.");
		return false;
	}
	
	return true;
}
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

	if ( Row < 2 ) return;

	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if ( column == 'ISSUE_ID' ) {//국세청번호
		var aCode = mySheet.GetCellValue(Row, "ACODE");
		var fromDate = $("#st_from_date").val();
		var toDate = $("#st_to_date").val();	
		var issueId = mySheet.GetCellValue(Row, "ISSUE_ID");
		var issueIdYn ="N";
		var group_key = mySheet.GetCellValue(Row, "GROUP_KEY");
		var mapping_type = mySheet.GetCellValue(Row, "MAPPING_TYPE");
/*		
		if(issueId != ""){
			alert("매핑 된 건입니다. 매핑취소 후 재매핑 해주시기 바랍니다.");
			return;
		}
		
		if(confirmCls == "Y"){
			alert("확정 건 입니다. 확정 취소 후 재매핑 가능합니다.");
			return;
		}
*/		
		var gbn = "";
		if(aCode =="매출"){
			gbn = "AR";
		}else{
			gbn = "AP";
		}
		
		if(issueId != ""){
			issueIdYn = "Y";
		}else{
			alert("조회 팝업은 매핑된 건만 가능합니다.\n선택 후 하단의 계산서 매핑 버튼을 클릭하세요.");
			return;
		}
		
		var params = "?group_key="+group_key+"&gbn="+gbn+"&fromDate="+fromDate+"&toDate="+toDate+"&mapping_type="+mapping_type+"&issueIdYn="+issueIdYn ;
		doPop('masterCmClIssueIdInfoPop', params);
	} else if(column == "IMAGE_KEY_YN"){ // 파일첨부
		popupSel = "fileUpload";
		var type="RFQ";
		var viewType="VI";
		var image_key=mySheet.GetCellValue(Row, "IMAGE_KEY");
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}
}

//팝업함수호출
function doPop(str, params) {
	popupSel = str;
	switch (str) {
	case "masterCmClIssueIdInfoPop": // 국세청번호 셋팅
		openSearchPopup("/cmcl/showMasterCmClIssueIdInfoPop.do", params, "1100,600,no");
		break;
		
	case "manual": // 매뉴얼 호출
		openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=0000007zt&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
		break;
	}
}

function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}

//페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
    current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/cmcl/getMasterCmClArApMappingList.do?page="+current_page , pagingMode );
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}

	if (msg != "") {
		alert(msg);
	}
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	$("#st_mapping_type").val("");
	
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}

	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	// 팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterCmClIssueIdInfoPop") {
		$("#st_mapping_type").val("");
		doAction('search');
	}else if(popupSel == "fileUpload") {	//파일 첨부
 			mySheet.SetCellValue(grbRow, 'IMAGE_KEY', value1);
 			mySheet.SetCellValue(grbRow, 'IMAGE_KEY_YN', (value2=='on')? diskOn : diskOff);
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	var sMsg = response.msg.MSG;   

	if (sMsg == "UPDATE_OK") {
		if(pMethod == "MAPPING") {
			alert(" 정상적으로 매핑되었습니다.");
		}

		// 처리후 재조회
		doAction('search');
      }  
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function kepAjaxError(pMethod, response){
	if(pMethod == "MAPPING"){
		alert("매핑 중 오류가 발생하였습니다.");
	}
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>계산서Mapping</h3>
       	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
	    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	    <span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
	</div>
	<!--조회영역-->
    <form name = "searchCondition" method = "post" onsubmit="return false" >
		<div id="cont_searchA">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="pageflag" name="pageflag" value="1">
		<input type="hidden" name="s_SAVENAME">
		<!-- 화면 내 정의 -->
		<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
		<input type="hidden" id="st_dept_code" name="st_dept_code"  value="${sessionInfo.department}">
		<input type="hidden" id="st_accuracy" name="st_accuracy"  value="">
           	<table  class="cont_t_list01" >
				<caption>계산서Mapping</caption>
				<colgroup>
					<col width="30px" />
					<col width="25%" />
					<col width="30px" />
					<col width="25%" />
					<col width="30px" />
                    <col width="25%" />
				</colgroup>

				<tbody>
					<tr>
						<th><font color="#FF6600">*</font>작성일자</th>
						<td>
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:80px; text-align:center;" value="">
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:80px; text-align:center;" value="">
						</td>
						<th>매출/매입</th>
						<td>
								<select id="st_a_code" name="st_a_code" style="width:80%;height:20px">
					                <option value="ALL">전체</option>
					                <option value="2112605" seleted>매출</option>
					                <option value="1114805">매입</option>
								</select>
						</td>
						<th>사이트</th>
						<td>
								<select id="st_site" name="st_site" style="width:80%;height:20px">
					                <option value="B2B" seleted>KOREAB2B</option>
					                <option value="CMRO">건설유통</option>
					                <option value="NON">일반</option>
								</select>
						</td>
					</tr>
					<tr>
						<th>전표삭제여부</th>
						<td>
							<select id="st_status_cd" name="st_status_cd"	style="width:80%;height:20px">
					                <option value="R">등록</option>
					                <option value="D">삭제</option>
							</select>
						</td>
						<th>전표번호</th>
						<td>
							<input type="text" class="input_type_text" name="st_accno" id="st_accno" style="width:75%" value="" onkeydown="kepEnter()">
						</td>
						<th>국세청승인번호</th>
						<td>
							<input type="text" class="input_type_text" name="st_issue_id" id="st_issue_id" style="width:75%" value="" onkeydown="kepEnter()">
						</td>
					</tr>
					<tr>
						<th>사업자번호</th>
						<td>
							<input type="text" class="input_type_text" name="st_a01_regno" id="st_a01_regno" style="width:75%" value="" onkeydown="kepEnter()">
						</td>
						<th>사업자명</th>
						<td>
							<input type="text" class="input_type_text" name="st_a01_customer_nm" id="st_a01_customer_nm" style="width:75%" value="" onkeydown="kepEnter()">
						</td>
						<th>매핑여부</th>
						<td>
							<select id="st_mapping" name="st_mapping"	style="width:80%;height:20px">
					                <option value="T">전체</option>
					                <option value="M">매핑</option>
					                <option value="N" selected>미매핑</option>
					                <option value="A">자동매핑</option>
					                <option value="O" >수동매핑</option>
					                <option value="E" >수기계산서매핑</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>담당자</th>
						<td>
							<select id="st_add_user_id" name="st_add_user_id" style="width:80%;height:20px"></select>
						</td>
						<th>부서정보</th>
						<td>
							<select id="st_user_dept" name="st_user_dept" style="width:80%;height:20px">
							</select>
						</td>
						<th>KEP세금계산서</th>
						<td>
							<input type="text" class="input_type_text" name="st_tax_bill_no" id="st_tax_bill_no" style="width:75%" value="" onkeydown="kepEnter()">
						</td>
						
					</tr>
					<tr>
						<th>확정여부</th>
						<td>
							<select id="st_confirm_cls" name="st_confirm_cls"	style="width:34%;height:20px">
					                <option value="" selected>전체</option>
					                <option value="Y">확정</option>
					                <option value="N" >미확정</option>
							</select>
						</td>
						<th>매핑그룹</th>
						<td>
							<input type="text" class="input_type_text" name="st_group_key" id="st_group_key" style="width:75%" value="" onkeydown="kepEnter()">
						</td>
						<th>매핑타입</th>
						<td>
							<select id="st_mapping_type" name="st_mapping_type"	style="width:80%;height:20px">
					                <option value="" selected>전체</option>
					                <option value="11">전표1,세금계산서1</option>
					                <option value="1N">전표1,세금계산서N</option>
					                <option value="N1">전표N,세금계산서1</option>
					                <option value="NN">전표N,세금계산서N</option>
							</select>
						</td>
						
					</tr>
				</tbody>
			</table>
		</div>
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="10">10건</option>
					<option value="50" selected>50건</option>
					<option value="100">100건</option>
					<option value="1000">1000건</option>
					<option value="2000">2000건</option>
					<option value="10000">10000건</option>
				</select>
			</span>
			<br>
      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c; padding-bottom:10px;">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "380px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
		<!--버튼영역-->
        <div class="btnArea">
			<span class="fr">
			<%if(user_dept.equals("005") || user_dept.equals("095")){%>
				<span class="btn_05 mr04"><a href="javascript:doAction('AR_AUTO_MAPPING');">매출 자동매핑</a></span>
				<span class="btn_05 mr04"><a href="javascript:doAction('AP_AUTO_MAPPING');">매입 자동매핑</a></span>
			<%}%>
				<span class="btn_05 mr04"><a href="javascript:doAction('mappingPop');">계산서 매핑</a></span>
				<span class="btn_05 mr04"><a href="javascript:doAction('save');">수기계산서매핑</a></span>
				<span class="btn_05 mr04"><a href="javascript:doAction('cancleMapping');">매핑취소</a></span>
				<span class="btn_02"><a href="javascript:doAction('confirm');">확정</a></span>
				<span class="btn_05 mr04"><a href="javascript:doAction('cancle');">확정취소</a></span>				
			</span>
		</div>
	</form>
<!--내용 종료-->

</body>
</html>
