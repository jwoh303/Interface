<%--
**********************************************
* 메뉴 : 주문관리>주문진행관리>주문진행>협력사 DM 발송>협력사 연락처 설정
* 화면 : 협력사 연락처 설정
* 기능 : 협력사 연락처 설정
* 프로그램 ID : 
* 담당자 : 임태성
* 착수일 : 2024-03-18
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<% 
	String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");//(st_com_code)
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
 
</head>
<style type="text/css">
<!--
	h2 { 
		width: 500px;
		font-family: "맑은 고딕";
		font-weight: bold;
		font-size: 18px;
		color: #333333;
		text-align: left;
		letter-spacing: -1px;
		margin-bottom: 10px; 
	}
	.cont_t_list02 td,th{
		border: 1px solid #cdcdcd;
	}
-->
</style>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
let delSeq = "";
const STR_STATUS = "sStatus";
const STR_SELECTED = "SELECTED";
const STR_RECV_SEQ = "RECV_SEQ";
const STR_MASTER_FLG = "MASTER_FLG";
const STR_RECV_NAME = "RECV_NAME";
const STR_RECV_MAIL = "RECV_MAIL";
const STR_RECV_MOBILE_NUMBER = "RECV_MOBILE_NUMBER";
const STR_RECV_REMARK = "RECV_REMARK";
const STR_ADD_USER = "ADD_USER";
const STR_ADD_USER_ID = "ADD_USER_ID";
const STR_ADD_DATE = "ADD_DATE";
const STR_RECV_OPTION = "RECV_OPTION";
const STR_MASTER_CODE = "0" // 대표자 코드값
const COLOR_CODE_DARKGREY = "#a9a9a9"; //dark grey 색상 코드


// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
					 { Align:"Center",	Width:0,	Edit:true,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",			SaveName:STR_STATUS}
					,{ Align:"Center",	Width:30,	Edit:true,									Type:"DummyCheck",	Header:"",				SaveName:STR_SELECTED, Sort:0}
					,{ Align:"Center",	Width:0,	Edit:true,					Hidden:true,	Type:"Text",		Header:"SEQ",			SaveName:STR_RECV_SEQ}
					,{ Align:"Center",	Width:0,	Edit:true,					Hidden:true,	Type:"Text",		Header:"대표flg",			SaveName:STR_MASTER_FLG}
					,{ Align:"Center",	Width:100,	Edit:true,					Hidden:false,	Type:"Text",		Header:"담당자명",			SaveName:STR_RECV_NAME}
					,{ Align:"Center",	Width:150,	Edit:true,	EditLen:150,	Hidden:false,	Type:"Text",		Header:"이메일",			SaveName:STR_RECV_MAIL}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:150,	Hidden:false,	Type:"Text",		Header:"휴대폰 번호",		SaveName:STR_RECV_MOBILE_NUMBER}
					,{ Align:"Center",	Width:120,	Edit:true,	EditLen:150,	Hidden:false,	Type:"Text",		Header:"비고",			SaveName:STR_RECV_REMARK}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"등록자",			SaveName:STR_ADD_USER}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"등록자아이디",		SaveName:STR_ADD_USER_ID}
					,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"등록일시",			SaveName:STR_ADD_DATE}
					,{ Align:"Center",	Width:80,	Edit:true,	EditLen:80,		Hidden:false,	Type:"Combo",		Header:"설정",			SaveName:STR_RECV_OPTION, ComboText:"수신|발송안함", ComboCode:"Y|N"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4);
	doAction('search');
	
}
//기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow(STR_SELECTED);

	// 선택된 항목 유무 체크
//	if (str !="search" && selectedGrid.length == 0) {
	//	alert("선택된 항목이 없습니다.");
		//return;
	//}
	
	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet , "/mdcm/getMasterMdcmAgentContactMngPopList.do" , "" );
			break;
		case "save":	//저장하기 체크유무 관계 없이 보이는 데이터 전부 저장
			document.getElementById("del_SEQ").value = delSeq;
			
			var checkMsg = emptyCellCheck();
			if(!nullCheck(checkMsg)){
				alert(checkMsg);
				break;
			}
			
			kepSaveAll(document.searchCondition ,mySheet , "/mdcm/saveMasterMdcmAgentContactMngPop.do");
			break;
	}
}

//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	// 수정 금지 설정
	convMysheetEditFlg();
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	location.reload();
	// 협력사 DM 리로드
	opener.doAction('search');
}

//TABLE의 ROW 데이타 생성
function addrows() {
	var rows = mySheet.DataInsert(-1);
	let tempCnt = mySheet.GetTotalRows();
	// var st_dept_code = $("#st_dept_code").val();
	mySheet.SetCellValue(rows, STR_RECV_NAME, "");
	mySheet.SetCellValue(rows, STR_RECV_MAIL, "");
	mySheet.SetCellValue(rows, STR_RECV_MOBILE_NUMBER, "");
	mySheet.SetCellValue(rows, STR_RECV_REMARK, "");
	mySheet.SetCellValue(rows, STR_ADD_USER, "");
	mySheet.SetCellValue(rows, STR_ADD_DATE, "");
	mySheet.SetCellValue(rows, STR_RECV_OPTION, "Y");
}

// 행 삭제
function delrows() {
	
	// 선택 확인
	var selectedGrid = mySheet.FindCheckedRow(STR_SELECTED);
	if (selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	// 삭제 확인
	if(confirm("선택한 연락처를 삭제하시겠습니까?") == false) return;

	const separator = "@@";
	
	// 삭제 idx 저장
	stack = [];
	const delProcess = () => {
		this.stack.reverse().forEach((element) => mySheet.RowDelete(element, 0));
	}

	// 삭제할 table의 pk 저장
	for(var i=1; i<mySheet.GetTotalRows()+1; i++){
		// 스테이터스 데이터 확인
		if (mySheet.GetCellValue(i, STR_SELECTED) == '1'){
			// 셀 삭제 대상
			stack.push(i);
			// 삭제 pk값 저장
			if(nullCheck(mySheet.GetCellValue(i, STR_RECV_SEQ))) continue;
			if(stack.length == 1 && nullCheck(delSeq)) {
				delSeq += mySheet.GetCellValue(i, STR_RECV_SEQ);
			} else {
				delSeq += separator + mySheet.GetCellValue(i, STR_RECV_SEQ);
			}
			
		}
	}

	// 최종 삭제 프로세스
	delProcess();
}

/**
 * 관리자 행은 변경 불가 처리
 * 본인등록건 이외는 변경/삭제 불가 처리
 */
function convMysheetEditFlg(){
	var st_user_id	= $("#st_user_id").val(); // 로그인유저 ID
	var maxRow		= mySheet.RowCount();
	var fixRow = 0;
	
	// 체크 개수 파악
	for(var i=maxRow; i>= 0; i--){
		// 대표 코드 확인 
		var masterFlg = mySheet.GetCellValue(i,STR_MASTER_FLG);
		if(masterFlg == STR_MASTER_CODE){ // 대표자라면
			// 편집 불가 대상 컬럼
			mySheet.SetCellEditable(i, STR_STATUS, 0);
			mySheet.SetCellEditable(i, STR_SELECTED, 0);
			mySheet.SetCellEditable(i, STR_RECV_NAME, 0);
			mySheet.SetCellEditable(i, STR_RECV_MAIL, 0);
			mySheet.SetCellEditable(i, STR_RECV_MOBILE_NUMBER, 0);
			mySheet.SetCellEditable(i, STR_RECV_REMARK, 0);
			mySheet.SetCellEditable(i, STR_RECV_OPTION, 0);

			// 편집 불가 대상 컬럼 배경색 변경
			mySheet.SetCellBackColor(i, STR_STATUS, COLOR_CODE_DARKGREY);
			mySheet.SetCellBackColor(i, STR_SELECTED, COLOR_CODE_DARKGREY);
			mySheet.SetCellBackColor(i, STR_RECV_NAME, COLOR_CODE_DARKGREY);
			mySheet.SetCellBackColor(i, STR_RECV_MAIL, COLOR_CODE_DARKGREY);
			mySheet.SetCellBackColor(i, STR_RECV_MOBILE_NUMBER, COLOR_CODE_DARKGREY);
			mySheet.SetCellBackColor(i, STR_RECV_REMARK, COLOR_CODE_DARKGREY);
			mySheet.SetCellBackColor(i, STR_ADD_USER, COLOR_CODE_DARKGREY);
			mySheet.SetCellBackColor(i, STR_ADD_DATE, COLOR_CODE_DARKGREY);
			mySheet.SetCellBackColor(i, STR_RECV_OPTION, COLOR_CODE_DARKGREY);
			//열고정 설정 수
			fixRow++;
		}else if(mySheet.GetCellValue(i,STR_ADD_USER_ID) != st_user_id){ // 대표자가 아닌데 본인등록건이 아니라면 편집/삭제불가
			// 편집 불가 대상 컬럼
			mySheet.SetCellEditable(i, STR_STATUS, 0);
			mySheet.SetCellEditable(i, STR_SELECTED, 0);
			mySheet.SetCellEditable(i, STR_RECV_NAME, 0);
			mySheet.SetCellEditable(i, STR_RECV_MAIL, 0);
			mySheet.SetCellEditable(i, STR_RECV_MOBILE_NUMBER, 0);
			mySheet.SetCellEditable(i, STR_RECV_REMARK, 0);
			mySheet.SetCellEditable(i, STR_RECV_OPTION, 0);
		}
	} // end for
	// 대표자는 열 고정으로 최상단 위치 && 정렬 불가
	mySheet.SetFrozenRows(fixRow);
}

// 행 추가시 빈 값이 존재해서는 안됨
function emptyCellCheck(){
	// const MAX_CONTACT_CNT = 5;
	const MSG_END = "행에 빈값이 있습니다.\n등록자, 등록일시를 제외한 데이터를 채워주세요.\n";
	const MAIL_MSG_END = "행의 이메일 형식에 오류가 있습니다.\n";
	const SMS_MSG_END = "행의 휴대폰 번호 형식에 오류가 있습니다.\n";
	const DUP_MAIL_MSG_END = "행의 이메일에 중복값이 있습니다.\n";
	const DUP_SMS_MSG_END = "행의 이메일에 중복값이 있습니다.\n";
	let resultMsg = "";
	let contractMailData = [];
	let contractSmsData = [];
	var maxRow = mySheet.RowCount();
	// 협력사 연락처 제한 2024.04.22 저장 제한 해제
	// if(maxRow > MAX_CONTACT_CNT) return "협력사 연락처 설정은 관리자 포함 최대 " + MAX_CONTACT_CNT + "개까지 가능합니다.)";

	// grid 체크 
	var errorFlg = false;
	for(var i=maxRow; i> 0; i--){
		// 대표 코드 확인 
		var masterFlg = mySheet.GetCellValue(i,STR_MASTER_FLG);
		if(masterFlg != STR_MASTER_CODE){ // 대표자가 아니라면 empty check 대상
			// 담당자명, 이메일, 휴대폰 번호, 비고, 설정 중 1개라도 빈값이 있다면 
			// 담당자명 체크
			if(nullCheck(mySheet.GetCellValue(i,STR_RECV_NAME)) && !errorFlg){
				resultMsg += i + MSG_END;
				errorFlg = true;
			}

			// 이메일 체크
			if(nullCheck(mySheet.GetCellValue(i,STR_RECV_MAIL)) && !errorFlg){
				resultMsg += i + MSG_END;
				errorFlg = true;
			}else if(!kepIsValidEmailValue(mySheet.GetCellValue(i,STR_RECV_MAIL)) && !errorFlg){ // 이메일이 존재하면 이메일 형식 체크
				// 이메일 형식이 아닌경의 msg 추가
				resultMsg += i + MAIL_MSG_END;
				errorFlg = true;
			}

			// 휴대폰번호 체크
			if(nullCheck(mySheet.GetCellValue(i,STR_RECV_MOBILE_NUMBER)) && !errorFlg){
				resultMsg += i + MSG_END;
				errorFlg = true;
			}else if(!kepIisValidPhone(mySheet.GetCellValue(i,STR_RECV_MOBILE_NUMBER)) && !errorFlg){ // 휴대폰번호가 존재하면 휴대폰번호 형식 체크
				resultMsg += i + SMS_MSG_END;
				errorFlg = true;
			}else if(!kepIisValidFirstNumber(mySheet.GetCellValue(i,STR_RECV_MOBILE_NUMBER)) && !errorFlg){ // 지정된 휴대폰 번호 앞글자 이외는 전부 에러
				resultMsg += i + SMS_MSG_END;
				errorFlg = true;
			}

			// 설정 체크
			if(nullCheck(mySheet.GetCellValue(i,STR_RECV_OPTION)) && !errorFlg){
				resultMsg += i + MSG_END;
				errorFlg = true;
			}
			
			// 비고 체크
			if(nullCheck(mySheet.GetCellValue(i,STR_RECV_REMARK)) && !errorFlg){
				resultMsg += i + MSG_END;
				errorFlg = true;
			}

			// 메일 중복 체크
			if(!contractMailData.includes(mySheet.GetCellValue(i,STR_RECV_MAIL))){
				contractMailData.push(mySheet.GetCellValue(i,STR_RECV_MAIL));
			}else if(!errorFlg){ // 중복됨
				resultMsg += i + DUP_MAIL_MSG_END;
				errorFlg = true;					
			}

			// SMS 중복 체크
			if(!contractSmsData.includes(mySheet.GetCellValue(i,STR_RECV_MOBILE_NUMBER))){
				contractSmsData.push(mySheet.GetCellValue(i,STR_RECV_MOBILE_NUMBER));
			}else if(!errorFlg){ // 중복됨
				resultMsg += i + DUP_SMS_MSG_END;
				errorFlg = true;					
			}
		}
	} // end for
	return resultMsg;
}

/**
* 입력값이 전화번호 형식(숫자-숫자-숫자)인지 체크
* param {*}
* return boolean
*/
function kepIisValidPhone(value) {
	var input = value; 	
	var format = /^(\d+)-(\d+)-(\d+)$/;
	return isValidFormat(input,format);
}

/**
* 휴대폰 번호 첫자리중 입력가능한 목록
* param Array array
* param String number
* return boolean 허가된 번호 true 허가된 번호 이외 false
*/
function kepIisValidFirstNumber(number, array) {
	const authArr = array ?? ['010','016','018','017','011'];
	const target = number.split('-')[0];
	if(!nullCheck(target)) { // 타깃중 첫번째 항목이 null이 아니라면
		return authArr.includes(target);
	}
	return false;
}

/**
 * 빈값 체크 null이면 true 아니면 false
 * param {*}
 * return boolean
 */
function nullCheck(element){
	const result = false;
	if(element === null) return true;
	if(element === undefined) return true;
	if(element === '') return true;
	return result;
}
</script> 
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:500px;">
		<div id="popHeader">
			<h1 class="title">협력사 연락처 설정</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
			<!-- <div id="searchBtnA02">
			<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
			</div> -->
			<form name="searchCondition" id="searchCondition" method=post >
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="pageflag" name="pageflag" value="1">
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_user_id" name="st_user_id"value="${sessionInfo.userId}">
				<input type="hidden" name="st_com_code" id="st_com_code" value="<%=st_com_code%>">
				<input type="hidden" name="page_title" id="page_title" value="협력사 연락처 설정">
				<input type="hidden" name="del_SEQ" id="del_SEQ" value="">

				<!--grid-->
				<p style="color: red;">※ 본인이 등록한 정보에 대해서만 수정/삭제 가능합니다.</p>
				<div class="ib_product" style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "100%", "400px");
					</script>
				</div>
			</form>
			<!--버튼영역-->
			<div class="btnArea02" style="margin: 2px;">
				<div class="btnLeft" style="display: inline-block; float: left;">
					<a href="javascript:addrows();"><span class="btn_03 mr02" style="color: white;">행추가</span></a>
					<a href="javascript:delrows();"><span class="btn_04 mr02" style="color: white;">선택삭제</span></a>
				</div>
				<div class="btnRight" style="display: inline-block; float: right;">
					<a href="javascript:doAction('save');"><span class="btn_03 mr02" style="color: white;">저장</span></a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
