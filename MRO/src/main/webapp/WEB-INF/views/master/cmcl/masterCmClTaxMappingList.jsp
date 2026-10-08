<%--
**********************************************
* 메뉴 : 마감관리>계산서조회
* 화면 : 계산서조회
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

var unit01 = KepSheetComboData("TX03", "");		// IBSHEET : 발행주체
var unit02 = KepSheetComboData("TX09", "");		// IBSHEET : 발행사이트

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",  Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			    Header:"상태|상태",	SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,		Hidden:false,	Type:"DummyCheck",	ColMerge:0,	Header:"|",	SaveName:"SELECTED"}
		,{ Align:"Center",	Width:170,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",				Header:"국세청번호|국세청번호",		SaveName:"ISSUE_ID"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,	    Hidden:false,	Type:"Text",				Header:"매출/매입|매출/매입",		SaveName:"ARAP_CODE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,	    Hidden:false,	Type:"Text",				Header:"매출/매입|매출/매입",		SaveName:"ARAP"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,	    Hidden:true,	Type:"Text",				Header:"생성일자|생성일자",		SaveName:"ISSUE_DT"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:90,	    Hidden:false,	Type:"Date",			Header:"작성일자|작성일자",	SaveName:"ISSUE_DATE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:90,	    Hidden:false,	Type:"Text",				Header:"ASP업체|ASP업체",		SaveName:"ASP_CODE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"계산서타입|계산서타입",		SaveName:"TYPE_CODE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",				Header:"영수청구|영수청구",		SaveName:"PURP_CODE"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:true,	Type:"Text",				Header:"수정코드|수정코드",		SaveName:"AMEND_CODE"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:110,	Hidden:true,	Type:"Text",				Header:"원세금계산서번호|원세금계산서번호",		SaveName:"ISSUE_ID_OLD"}
		,{ Align:"Center",	Width:150,	Edit:false,	EditLen:150,	Hidden:false,	Type:"Text",				Header:"비고|비고",	    SaveName:"DESC_TEXT1"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",				Header:"공급자|사업자번호",	SaveName:"SU_ID"}
		,{ Align:"Center",	Width:10,	Edit:false,	EditLen:10,		Hidden:true,	Type:"Text",				Header:"공급자|",	SaveName:"SU_MIN"}
		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:140,	Hidden:false,	Type:"Text",				Header:"공급자|회사명",	SaveName:"SU_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"공급자|대표자명",	SaveName:"SU_REPRES"}
		,{ Align:"Center",	Width:170,	Edit:false,	EditLen:170,	Hidden:true,	Type:"Text",				Header:"공급자|주소",	SaveName:"SU_ADDR"}
		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:140,	Hidden:true,	Type:"Text",				Header:"공급자|업종",	SaveName:"SU_BUSTYPE"}
		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:140,	Hidden:true,	Type:"Text",				Header:"공급자|업태",	    SaveName:"SU_INDTYPE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"공급자|부서명",	SaveName:"SU_DEPTNAME"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:90,		Hidden:false,	Type:"Text",				Header:"공급자|담당자명",	SaveName:"SU_PERSNAME"}
		,{ Align:"Center",	Width:10,	Edit:false,	EditLen:10,		Hidden:true,	Type:"Text",				Header:"공급자|전화번호",	SaveName:"SU_TELNO"}
		,{ Align:"Center",	Width:10,	Edit:false,	EditLen:10,		Hidden:true,	Type:"Text",				Header:"공급자|핸드폰",	SaveName:"SU_HPNO"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",				Header:"공급자|이메일",	SaveName:"SU_EMAIL"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:true,	Type:"Text",				Header:"공급받는자|type",	SaveName:"IP_TYPECODE"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",				Header:"공급받는자|사업자번호",	SaveName:"IP_ID"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:true,	Type:"Text",				Header:"공급받는자|",	SaveName:"IP_MIN"}
		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:140,	Hidden:false,	Type:"Text",				Header:"공급받는자|회사명",	SaveName:"IP_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"공급받는자|대표자명",	SaveName:"IP_REPRES"}
		,{ Align:"Center",	Width:170,	Edit:false,	EditLen:170,	Hidden:true,	Type:"Text",				Header:"공급받는자|주소",	SaveName:"IP_ADDR"}
		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:140,	Hidden:true,	Type:"Text",				Header:"공급받는자|업종",	SaveName:"IP_BUSTYPE"}
		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:140,	Hidden:true,	Type:"Text",				Header:"공급받는자|업태",	SaveName:"IP_INDTYPE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"공급받는자|부서",	SaveName:"IP_DEPTNAME1"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"공급받는자|담당자명",	SaveName:"IP_PERSNAME1"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:true,	Type:"Text",				Header:"공급받는자|전화번호",	SaveName:"IP_TELNO1"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:true,	Type:"Text",				Header:"공급받는자|핸드폰",	SaveName:"IP_HPNO1"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",				Header:"공급받는자|이메일",	SaveName:"IP_EMAIL1"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:true,	Type:"Text",				Header:"공급받는자|부서2",	SaveName:"IP_DEPTNAME2"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:true,	Type:"Text",				Header:"공급받는자|담당자2",	SaveName:"IP_PERSNAME2"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:true,	Type:"Text",				Header:"공급받는자|전화번호2",	SaveName:"IP_TELNO2"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:true,	Type:"Text",				Header:"공급받는자|핸드폰2",	SaveName:"IP_HPNO2"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:true,	Type:"Text",				Header:"공급받는자|이메일2",	SaveName:"IP_EMAIL2"}
		,{ Align:"right",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Float",				Header:"공급가액|공급가액",	SaveName:"CHARGETOTAL"}
		,{ Align:"right",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Float",				Header:"부가세액|부가세액",	SaveName:"TAXTOTAL"}
		,{ Align:"right",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Float",				Header:"금액합계|금액합계",	SaveName:"GRANDTOTAL"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",				Header:"수집일자|수집일자",	SaveName:"ERDAT"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:true,	Type:"Text",				Header:"|",	SaveName:"ERZET"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:true,	Type:"Text",				Header:"|",	SaveName:"ERNAM"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:true,	Type:"Text",				Header:"|",	SaveName:"TRANS_DATE"}
		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:140,	Hidden:false,	Type:"Text",				Header:"전표번호|전표번호",	SaveName:"ACCNO"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",				Header:"전표번호항번|전표번호항번",	SaveName:"ACCSEQ"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",				Header:"사용자아이디|사용자아이디",	SaveName:"USER_ID"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",				Header:"사용자명|사용자명",	SaveName:"USER_NAME_LOC"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",				Header:"부서|부서",	SaveName:"DEPARTMENT"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",				Header:"자동예외그룹키|자동예외그룹키",		SaveName:"NTS_GROUP_KEY"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:170,	Hidden:true,	Type:"Text",				Header:"매핑키|매핑키",		SaveName:"MAP_ISSUE_ID"}
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
	
	//setLinkCol(mySheet, "ISSUE_ID"); // 국세청번호
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
	
	// 시스템운영팀, 시스템개발팀, 관리팀, 자금팀 - 담당자정보/부서 선택가능
	if ( $("#st_dept_code").val() == '094' || $("#st_dept_code").val() == '095' || $("#st_dept_code").val() == '005' || $("#st_dept_code").val() == '004') {
		$("#st_user_dept").attr("disabled", false);
	} else {
		$("#st_user_dept").attr("disabled", true);
	}
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
	if (str !="search" && str !="reload" && str !="mapping" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search": // 조회
			current_page =-1;
			kepSearch(document.searchCondition,  mySheet , "/cmcl/getMasterCmClTaxMappingList.do" , pagingMode );
			break;
	
		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;
			
		case "mapping": // 상계처리 매핑
			kepAjaxFormCall("/cmcl/callProcTaxSkip.do", "searchCondition", "MAPPING");
			break;
			
		case "man_mapping": // 수동 상계처리
			if(!validationSave())
				return;
			if(!confirm('선택한 항목을 확정 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/cmcl/manProcTaxSkip.do", "SELECTED");
			break;
	}
}
var grbRow = "";

function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}

//페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
    current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/cmcl/getMasterCmClTaxMappingList.do?page="+current_page , pagingMode );
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
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}

	if(code>0){
		//저장 성공시 재조회
		doAction('search');
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

//Valitation - 저장
function validationSave() {
	var maxRow = mySheet.RowCount()+1;
	var cnt = 0;
	var map_issue_id = "";
	
	var arap = "";
	var bf_arap = "";
	
	var su_id = "";
	var bf_su_id = "";
	
	var ip_id = "";
	var bf_ip_id = "";
	
	var charge_total = 0;
	var tax_total = 0;
	
    for(var i=1; i<=maxRow; i++){
		if(mySheet.GetCellValue(i, "SELECTED") == 1){
			cnt++;
			if(cnt == 1){
				bf_arap = mySheet.GetCellValue(i, "ARAP_CODE");
				arap = mySheet.GetCellValue(i, "ARAP_CODE");
				
				bf_su_id = mySheet.GetCellValue(i, "SU_ID");
				su_id = mySheet.GetCellValue(i, "SU_ID");
				
				bf_ip_id = mySheet.GetCellValue(i, "IP_ID");
				ip_id = mySheet.GetCellValue(i, "IP_ID");
			}else{
				arap = mySheet.GetCellValue(i, "ARAP_CODE");
				su_id = mySheet.GetCellValue(i, "SU_ID");
				ip_id = mySheet.GetCellValue(i, "IP_ID");
			}
			
			map_issue_id = mySheet.GetCellValue(i, "MAP_ISSUE_ID");
			charge_total = charge_total + mySheet.GetCellValue(i, "CHARGETOTAL");
			tax_total = tax_total + mySheet.GetCellValue(i, "TAXTOTAL");
			
			if(map_issue_id != ""){
				alert(i-1 + " 행은 이미 매핑되었습니다.");
				return false;
			}
			
			if(bf_arap != arap){
				alert("매출/매입이 일치하는 건들만 상계처리 가능합니다.");
				return false;
			}
			
			if(bf_su_id != su_id){
				alert("공급자 사업자번호가 일치하지 않습니다.");
				return false;
			}
			
			if(bf_ip_id != ip_id){
				alert("공급받는자 사업자번호가 일치하지 않습니다.");
				return false;
			}
			
			if(mySheet.GetCellValue(i, "NTS_GROUP_KEY") != ""){
				alert(i-1 + " 행은 이미 상계처리 매핑되었습니다.");
				return false;
			}
        }
    }
    
    if(charge_total != 0){
    	alert(charge_total + " 공급가액 합계가 0이 아닙니다.");	
    	return false;
    }
    
    if(tax_total != 0){
    	alert("부가세액 합계가 0이 아닙니다.");	
    	return false;
    }
    
	return true;
}

</script>
</head>

<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>계산서 조회</h3>
       	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
	    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
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
           	<table  class="cont_t_list01" >
				<caption>계산서 조회</caption>
				<colgroup>
					<col width="35px" />
					<col width="23%" />
					<col width="35px" />
					<col width="23%" />
					<col width="35px" />
                    <col width="23%" />
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
								<select id="st_arap" name="st_arap" style="width:60%;height:20px">
					                <option value="">전체</option>
					                <option value="AR" seleted>매출</option>
					                <option value="AP">매입</option>
								</select>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>공급자사업자번호 </th>
						<td>
							<input type="text" class="input_type_text" name="st_su_id" id="st_su_id" style="width:70%" value="" onkeydown="kepEnter()">
						</td>
						<th>공급자사업장명</th>
						<td>
							<input type="text" class="input_type_text" name="st_su_name" id="st_su_name" style="width:70%" value="" onkeydown="kepEnter()">
						</td>
						<th>공급자이메일</th>
						<td>
							<input type="text" class="input_type_text" name="st_su_email" id="st_su_email" style="width:70%" value="" onkeydown="kepEnter()">
						</td>
					</tr>
					<tr>
						
						<th>공급받는자사업자번호 </th>
						<td>
							<input type="text" class="input_type_text" name="st_ip_id" id="st_ip_id" style="width:70%" value="" onkeydown="kepEnter()">
						</td>
						<th>공급받는자사업장명</th>
						<td>
							<input type="text" class="input_type_text" name="st_ip_name" id="st_ip_name" style="width:70%" value="" onkeydown="kepEnter()">
						</td>
						<th>공급받는자이메일</th>
						<td>
							<input type="text" class="input_type_text" name="st_ip_email" id="st_ip_email" style="width:70%" value="" onkeydown="kepEnter()">
						</td>
					</tr>
					<tr>						
						<th>전표번호</th>
						<td>
							<input type="text" class="input_type_text" name="st_accno" id="st_accno" style="width:70%" value="" onkeydown="kepEnter()">
						</td>
						<th>국세청승인번호</th>
						<td>
							<input type="text" class="input_type_text" name="st_issue_id" id="st_issue_id" style="width:70%" value="" onkeydown="kepEnter()">
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>운영담당자</th>
						<td>
							<select id="st_add_user_id" name="st_add_user_id" style="width:80%;height:20px"></select>
						</td>
						<th>운영부서정보</th>
						<td>
							<select id="st_user_dept" name="st_user_dept" style="width:80%;height:20px">
							</select>
						</td>
						<th>매핑여부</th>
						<td>
							<select id="st_mapping" name="st_mapping"	style="width:80%;height:20px">
					                <option value="" selected>전체</option>
					                <option value="Y">매핑</option>
					                <option value="N" >미매핑</option>
					                <option value="E" >자동예외</option>					                
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
		
		<%if(user_dept.equals("005") || user_dept.equals("095")){%>
		<!--버튼영역-->
        <div class="btnArea">
			<span class="fr">
				<span class="btn_05 mr04"><a href="javascript:doAction('man_mapping');">수동 상계처리</a></span>
				<span class="btn_05 mr04"><a href="javascript:doAction('mapping');">상계처리 매핑</a></span>
			</span>
		</div>
		<%}%>
 	</form>
<!--내용 종료-->

</body>
</html>
