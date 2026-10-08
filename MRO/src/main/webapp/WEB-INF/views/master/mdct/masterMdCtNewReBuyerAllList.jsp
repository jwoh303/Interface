<%--
**********************************************
* 메뉴 : 운영사 > 회원사관리> 재계약 신규고객 현황(전체)
* 화면 : 재계약 신규고객 현황(전체)
* 기능 :
* 프로그램 ID :
* 담당자 : HSJ
* 착수일 : 2023-12-19
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script type="text/javascript">
<%
%>

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
		 { Align:"Center",	SaveName:"sStatus",			Header:"상태|상태|상태",					Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
		,{ Align:"Center",	SaveName:"SELECTED",		Header:"||",							Type:"DummyCheck",	Width:30,	Edit:true,	EditLen:100,	Hidden:true}
		,{ Align:"Center",	SaveName:"DEPT",			Header:"구분|항목|사업팀",					Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
		,{ Align:"Center",	SaveName:"DEPT_NAME",		Header:"구분|항목|사업팀",					Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
		
		,{ Align:"Right",	SaveName:"CONTRACT_P_C",	Header:"재계약현황|수의(단가갱신포함)|완료",		Type:"Float",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Right",	SaveName:"CONTRACT_P_T",	Header:"재계약현황|수의(단가갱신포함)|진행중",	Type:"Float",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Right",	SaveName:"CONTRACT_P_F",	Header:"재계약현황|수의(단가갱신포함)|실패",		Type:"Float",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Right",	SaveName:"CONTRACT_P_N",	Header:"재계약현황|수의(단가갱신포함)|미지정",	Type:"Float",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
		
		,{ Align:"Right",	SaveName:"CONTRACT_C_C",	Header:"재계약현황|경쟁|완료",				Type:"Float",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Right",	SaveName:"CONTRACT_C_T",	Header:"재계약현황|경쟁|진행중",				Type:"Float",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Right",	SaveName:"CONTRACT_C_F",	Header:"재계약현황|경쟁|실패",				Type:"Float",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Right",	SaveName:"CONTRACT_C_N",	Header:"재계약현황|경쟁|미지정",				Type:"Float",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
		
		,{ Align:"Right",	SaveName:"CONTRACT_A_A",	Header:"재계약현황|합계|대상",				Type:"Float",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Right",	SaveName:"CONTRACT_A_C",	Header:"재계약현황|합계|완료",				Type:"Float",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Right",	SaveName:"CONTRACT_A_T",	Header:"재계약현황|합계|진행중",				Type:"Float",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Right",	SaveName:"CONTRACT_A_F",	Header:"재계약현황|합계|실패",				Type:"Float",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Right",	SaveName:"CONTRACT_A_N",	Header:"재계약현황|합계|미지정",				Type:"Float",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Right",	SaveName:"CONTRACT_A_RATE",	Header:"재계약현황|합계|진척율(%)",			Type:"Float",		Width:98,	Edit:false,	EditLen:100,	Hidden:false}
		
		,{ Align:"Right",	SaveName:"SHORT_TERM",		Header:"고객사관리|거래기간|단기(~5년이내)",	Type:"Float",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Right",	SaveName:"MID_TERM",		Header:"고객사관리|거래기간|중기(5~10년이내)",	Type:"Float",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Right",	SaveName:"LONG_TERM",		Header:"고객사관리|거래기간|장기(10년이상)",	Type:"Float",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
		
		,{ Align:"Right",	SaveName:"CONTRACT_KIND_R",	Header:"신규고객|Set-up|완료",				Type:"Float",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Right",	SaveName:"CONTRACT_KIND_S",	Header:"신규고객|Set-up|진행중",			Type:"Float",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Right",	SaveName:"CONTRACT_KIND_N",	Header:"신규고객|Set-up|미지정",			Type:"Float",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
	];
	
	var cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:0};
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(0);

	//하이퍼링크 설정		
	setLinkCol(mySheet, "CONTRACT_P_C");
	setLinkCol(mySheet, "CONTRACT_P_T");
	setLinkCol(mySheet, "CONTRACT_P_F");
	setLinkCol(mySheet, "CONTRACT_P_N");
	
	setLinkCol(mySheet, "CONTRACT_C_C");
	setLinkCol(mySheet, "CONTRACT_C_T");
	setLinkCol(mySheet, "CONTRACT_C_F");
	setLinkCol(mySheet, "CONTRACT_C_N");
	
	setLinkCol(mySheet, "CONTRACT_A_A");
	setLinkCol(mySheet, "CONTRACT_A_C");
	setLinkCol(mySheet, "CONTRACT_A_T");
	setLinkCol(mySheet, "CONTRACT_A_F");
	setLinkCol(mySheet, "CONTRACT_A_N");
	
	setLinkCol(mySheet, "SHORT_TERM");
	setLinkCol(mySheet, "MID_TERM");
	setLinkCol(mySheet, "LONG_TERM");
	
	setLinkCol(mySheet, "CONTRACT_KIND_R");
	setLinkCol(mySheet, "CONTRACT_KIND_S");
	setLinkCol(mySheet, "CONTRACT_KIND_N");

	doAction("search");
}

// 기능함수
function doAction(str) {
	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdct/getMasterMdctNewReBuyerAllList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
	}
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

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdctNewReBuyerAllList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val) {
	popupSel = str;
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if(Row < 3) return; // 헤더 병합으로 3번째 줄부터 유효한 클릭
	
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	var st_contract_type = "";
	var st_process_status = "";
	var st_contract_kind = "";
	var st_term = "";
	
	if(column == "CONTRACT_P_C") {// 수의 완료
		st_contract_type = "P";
		st_process_status = "C";
		st_contract_kind = "";
	}else if(column == "CONTRACT_P_T") {// 수의 진행중
		st_contract_type = "P";
		st_process_status = "T";
		st_contract_kind = "";
	}else if(column == "CONTRACT_P_F") {// 수의 실패
		st_contract_type = "P";
		st_process_status = "F";
		st_contract_kind = "";
	}else if(column == "CONTRACT_P_N") {// 수의 미지정
		st_contract_type = "P";
		st_process_status = "N";
		st_contract_kind = "";
	}else if(column == "CONTRACT_C_C") {// 경쟁 완료
		st_contract_type = "C";
		st_process_status = "C";
		st_contract_kind = "";
	}else if(column == "CONTRACT_C_T") {// 경쟁 진행중
		st_contract_type = "C";
		st_process_status = "T";
		st_contract_kind = "";
	}else if(column == "CONTRACT_C_F") {// 경쟁 실패
		st_contract_type = "C";
		st_process_status = "F";
		st_contract_kind = "";
	}else if(column == "CONTRACT_C_N") {// 경쟁 미지정
		st_contract_type = "C";
		st_process_status = "N";
		st_contract_kind = "";	
	}else if(column == "CONTRACT_A_A") {// 합계 대상
		st_contract_type = "";
		st_process_status = "";
		st_contract_kind = "";
	}else if(column == "CONTRACT_A_C") {// 합계 완료
		st_contract_type = "";
		st_process_status = "C";
		st_contract_kind = "";
	}else if(column == "CONTRACT_A_T") {// 합계 진행중
		st_contract_type = "";
		st_process_status = "T";
		st_contract_kind = "";
	}else if(column == "CONTRACT_A_F") {// 합계 실패
		st_contract_type = "";
		st_process_status = "F";
		st_contract_kind = "";
	}else if(column == "CONTRACT_A_N") {// 합계 미지정
		st_contract_type = "";
		st_process_status = "N";
		st_contract_kind = "";
	}else if(column == "SHORT_TERM") {// 단기
		st_contract_type = "";
		st_process_status = "";
		st_contract_kind = "";
		st_term = "S";
	}else if(column == "MID_TERM") {// 중기
		st_contract_type = "";
		st_process_status = "";
		st_contract_kind = "";
		st_term = "M";
	}else if(column == "LONG_TERM") {// 장기
		st_contract_type = "";
		st_process_status = "";
		st_contract_kind = "";
		st_term = "L";
	}else if(column == "CONTRACT_KIND_R") {// 완료
		st_contract_type = "";
		st_process_status = "";
		st_contract_kind = "R";
	}else if(column == "CONTRACT_KIND_S") {// 진행중
		st_contract_type = "";
		st_process_status = "";
		st_contract_kind = "S";
	}else if(column == "CONTRACT_KIND_N") {// 미지정
		st_contract_type = "";
		st_process_status = "";
		st_contract_kind = "N";
	}
	
	if(column != "DEPT_NAME" && column != "CONTRACT_A_RATE") {
		var st_form_name = "buyerDetailPopForm";
		var st_team_code = mySheet.GetCellValue(Row,"DEPT");
		var st_popup_url = "/mdct/showMasterMdCtNewReBuyerDetailPop.do"; // URL 경로
		var st_popup_param = "st_contract_type@@"+st_contract_type+"^||^"+"st_process_status@@"+st_process_status+"^||^"+"st_contract_kind@@"+st_contract_kind+"^||^"+"st_team_code@@"+st_team_code+"^||^"+"+st_term@@"+st_term; 
		var st_popup_option = "800,500,no";	

		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);	
	}
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	
	if (msg != "") {
		alert(msg);
	}
	
	if (code > 0) {
		//저장 성공시 재조회
		doAction("search");
	}
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction("search");
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	grbRow="";	//초기화
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA">
		<h3>재계약/신규고객 현황(전체)</h3>
      	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
    	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
 	</div>
	
	<!--조회영역-->
	<form id="searchCondition" name="searchCondition" method="post" onsubmit="return false;" >
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" name="s_SAVENAME">
		<input type="hidden" id="pageflag" name="pageflag" value="1">
		
		<!-- 화면 내 정의 -->
		<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
		<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
	</form>

   	<!--grid-->
	<div class="ib_product" style="border-top:2px solid #3c639c">
		<script type="text/javascript">
			createIBSheet("mySheet", "100%", "400px");
		</script>
	</div>
	
	<!--버튼영역-->
    <p class="btnArea mt10 mb05">
		<span class="fl">
			<font>* 정확한 집계를 위해서 <font color=RED><b>[고객사 프로파일], [고객사별 담당자 입력]</b></font> 정보를 최신화 해주시기 바랍니다.</font>
		</span>
	</p>
<!--내용 종료-->
</body>
</html>