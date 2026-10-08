<%--
**********************************************
* 메뉴 : 주문관리>주문진행관리>주문진행>협력사 DM 발송
* 화면 : 협력사 DM 발송
* 기능 : 협력사 DM 발송
* 프로그램 ID : 
* 담당자 : 임태성
* 착수일 : 2024-03-15
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"), "");//(st_com_code)
	String st_com_code_name = CommonUtil.nvl((String) request.getParameter("st_com_code_name"), "");//(st_com_code_name)
	String st_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"), "");//(st_po_no)
	String st_po_seq = CommonUtil.nvl((String) request.getParameter("st_po_seq"), "");//(st_po_seq)
	String st_ds_seq = CommonUtil.nvl((String) request.getParameter("st_ds_seq"), "");//(st_ds_seq)
	String st_sent_seq = CommonUtil.nvl((String) request.getParameter("st_sent_seq"), "");//(st_sent_seq)
	String st_dm_issue = CommonUtil.nvl((String) request.getParameter("st_dm_issue"), "");//(st_dm_issue)
	String userTel = (String)_sessionInfo.getTel();
	String userEmail = (String)_sessionInfo.getEmail();
	String userName = (String)_sessionInfo.getUserNameLoc();
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css"
	type="text/css" />
<script src="/resources/libs/ibsheet7/js/ibsheet.js"
	type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js"
	type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js"
	type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js"
	type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js"
	type="text/javascript"></script>
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

.cont_t_list02 td, th {
	border: 1px solid #cdcdcd;
}

.btn_99 {
	display: inline-block;
	padding: 0px 7px;
	height: 15px;
	line-height: 15px;
	text-align: center;
	font-size: 11px;
	background-color: #4b4948;
	border-radius: 3px;
	color: white;
}
-->
</style>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode					= "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel					= "";
const targetClassName			= "_area";
const removeTarget				= "Check";
const mailSendColumn			= "C4";
const smsSendColumn				= "C6";
const STR_MAIL					= "mail";
const STR_SMS					= "sms";
const columnData 				= {};
const dmSendY					= "Y";
const dmSendN					= "N";
const STR_RECV_NAME				= "RECV_NAME";
const STR_RECV_REMARK			= "RECV_REMARK";
const STR_RECV_OPTION			= "RECV_OPTION";
const STR_RECV_MAIL_FLG			= "RECV_MAIL_FLG";
const STR_RECV_MAIL				= "RECV_MAIL";
const STR_RECV_SMS_FLG			= "RECV_SMS_FLG";
const STR_RECV_MOBILE_NUMBER	= "RECV_MOBILE_NUMBER";
const CHECK_FLG_Y				= 1;
const CHECK_FLG_N				= 0;

let templateArr = [];
let dmissueObj = null;
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
					{ Align:"Center",	Width:150,	Edit:true,	EditLen:160,	Hidden:false,	Type:"Text",		Header:"받을대상",			SaveName:STR_RECV_NAME,	ColMerge:0}
					,{ Align:"Center",	Width:216,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"비고",			SaveName:STR_RECV_REMARK,	ColMerge:0}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Combo",		Header:"수신유형",			SaveName:STR_RECV_OPTION,	ColMerge:0, ComboText:"수신|발송안함", 		ComboCode:dmSendY + "|" + dmSendN}
					,{ Align:"Center",	Width:40,	Edit:true,	EditLen:40,		Hidden:false,	Type:"CheckBox",	Header:"",				SaveName:STR_RECV_MAIL_FLG,	ColMerge:0}
					,{ Align:"Center",	Width:252,	Edit:true,	EditLen:250,	Hidden:false,	Type:"Text",		Header:"이메일",			SaveName:STR_RECV_MAIL,	ColMerge:0}
					,{ Align:"Center",	Width:40,	Edit:true,	EditLen:40,		Hidden:false,	Type:"CheckBox",	Header:"",				SaveName:STR_RECV_SMS_FLG,	ColMerge:0}
					,{ Align:"Center",	Width:150,	Edit:true,	EditLen:150,	Hidden:false,	Type:"Text",		Header:"휴대폰 번호",		SaveName:STR_RECV_MOBILE_NUMBER,	ColMerge:0}
	];

	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:0};
	var cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4);

	//하이퍼링크 설정
	setLinkCol(mySheet, "SETTING");
	
	// 이슈 정보 호출
	kepAjaxFormCall("/mdcm/getMasterMdcmAgentDmIssueList.do","agentDmIssueForm","agentDmIssueMethod");
	
	// 템플릿 호출
	kepAjaxFormCall("/mdcm/getMasterMdcmAgentDmSendTemplateList.do","mailTemplateForm","mailTemplateMethod");
	//TODO
	//kepAjaxCommonQueryIdCombo('st_kep_user_id','getSgKepUserList','ALL2','');
	
	doAction('search');
}
//기능함수
function doAction(str) {
	
	switch (str) {
		case "search":	 // 수신정보 리스트 조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet , "/mdcm/getMasterMdcmAgentDmSendPopList.do" , "" );
			break;
		case "save":	//저장하기
			if(!confirm("협력사에 DM을 발송 하시겠습니까?")){
				return;
			}
			// 메일 발송 전 발송 개수 validtion check
			if(validSendCnt() && validSendCheck()){
				// sms 전송 종류 set
				setSmsKind();
				// dm 전송
				// 발송 전 개행 replace				
				var remark = $('#REMARK').val();
				var brCnt = remark.match(/(\n|\r\n)/g);
				if(brCnt != null ) {
					if(brCnt.length > 6) {
						alert("운영자 메모 입력 시 개행은 최대 6회까지 가능합니다.");
						return;
					}
				}
				remark = remark.replaceAll(/(\n|\r\n)/g, '<br>');
				$('#REMARK').val(remark);
				kepSaveAll(document.searchCondition ,mySheet , "/mdcm/saveMasterMdcmAgentDmSend.do");
			}
			//this.close();
			break;
	}
}

//미리보기 팝업
function doPreviewPop(){

	const targetComName = "협력사명,";
	const sellerNameSeparator = "@@@";
	const separator = "@";
	const formSeparator = "@@";
	const paramSeparator = "^||^";
	const templateSeparator = "@";
	const convSeparator = "^c^c^";
	const firstIndex = 1;
	const fixMail = "운영자<sender@koreab2b.com>, ";
	const KOREAB2B_URL = "www.KoreaB2B.com";
	const KOREAB2B_URL_ATAG = '<a href="http://www.koreab2b.com" target="_blank"  style="color:#e8340c; font-weight:bold; text-decoration:none">www.KoreaB2B.com</a>'
	

	// init
	var agentDmMemo = $("#REMARK").val(); // 운영자 메모
	agentDmMemo = agentDmMemo.replaceAll(/(\n|\r\n)/g, '<br>'); // 개행 -> <br> 태그로 repalce
	var st_dm_issue = $("#st_dm_issue").val();
	var st_com_code = $("#st_com_code").val();
	var st_com_code_name = $("#st_com_code_name").val();

	var userEmail = fixMail + $("#SEND_NAME").val() + "<" + $("#SEND_EMAIL").val() + ">";
	var mailSubject = $("#mailSubject").val();
	var sendTel = $("#SEND_TEL").val();
	var sendName = $("#SEND_NAME").val()
	var mailContents = $("#mailContents").val().replaceAll(targetComName, st_com_code_name+", ")
						.replaceAll(templateSeparator, convSeparator).replaceAll(KOREAB2B_URL, KOREAB2B_URL_ATAG);
	var recvInfo = mySheet.GetCellValue(firstIndex, STR_RECV_NAME) + "<" + mySheet.GetCellValue(firstIndex, STR_RECV_MAIL) + ">"; // 첫번째 줄

	if(dmissueObj == null) {
		alert("잠시 후 다시 시도해주세요");
		return;
	}else {
		// 이슈 데이터가 있다면 string으로 변환
		strDmissueObj = JSON.stringify(dmissueObj);
	}

	var st_form_name = "AgentPreviewPopForm";
	var st_popup_url = "/mdcm/showMasterMdCmAgentDmPreviewPop.do";
	var st_popup_param = "st_com_code_name"+ formSeparator +st_com_code_name + paramSeparator + "agentDmMemo"+ formSeparator + agentDmMemo + paramSeparator
						 + "dmissueObj" + formSeparator + strDmissueObj + paramSeparator + "st_com_code" + formSeparator + st_com_code
						 + paramSeparator + "userEmail" + formSeparator + userEmail + paramSeparator + "mailSubject" + formSeparator + mailSubject
						 + paramSeparator + "recvInfo" + formSeparator + recvInfo + paramSeparator + "mailContents" + formSeparator + mailContents
						 + paramSeparator + "sendTel" + formSeparator + sendTel + paramSeparator + "sendName" + formSeparator + sendName;
	
	var st_popup_option = "1040,650,no";
	//post 팝업 호출
	openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
}

// 협력사 연락처 설정
function doAgentContactPop(){

	// init
	var st_com_code = $("#st_com_code").val();
	var st_form_name = "AgentContactMngPopForm";
	var st_popup_url = "/mdcm/showMasterMdCmAgentContactMngPop.do";
	var st_popup_param = "st_com_code@@"+st_com_code;
	var st_popup_option = "850,540,no";
	//post 팝업 호출
	openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
}

//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	// 기본값 설정(발신수단 메일 check)
	$('#mailCheck').prop('checked', true);
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
		if(code ==  "1"){ // 메일 발송인 경우
			this.close();
		}
	}
}

/**
 * 테이블에 행 추가
 * param Json || null rowData
 * return void
 */
function addrows(rowData) {

	// 최대 5행만 존재가능 2024.04.22 표시 제한 해제 
	//if(mySheet.RowCount() > 4) {
	//	alert("대량발송은 그룹웨어를 이용해주세요.");
	//	return;
	//}

	if(nullCheck(rowData)){ // rowData가 빈값이면 (일반로직)
		var rows = mySheet.DataInsert(-1);
		mySheet.SetCellValue(rows, STR_RECV_NAME, "");				// 받을 대상
		mySheet.SetCellValue(rows, STR_RECV_REMARK, "");			// 비고
		mySheet.SetCellValue(rows, STR_RECV_MAIL_FLG, CHECK_FLG_N);	// 메일전송체크
		mySheet.SetCellValue(rows, STR_RECV_MAIL, "");				// 이메일
		mySheet.SetCellValue(rows, STR_RECV_SMS_FLG, CHECK_FLG_N);	// SMS전송체크
		mySheet.SetCellValue(rows, STR_RECV_MOBILE_NUMBER, "");			// 휴대폰 번호
	} else { // rowArray가 존재한다면
		var rows = mySheet.DataInsert(-1);
		mySheet.SetCellValue(rows, STR_RECV_NAME, rowData.STR_RECV_NAME);				// 받을 대상
		mySheet.SetCellValue(rows, STR_RECV_REMARK, rowData.STR_RECV_REMARK);			// 비고
		mySheet.SetCellValue(rows, STR_RECV_MAIL_FLG, rowData.STR_RECV_MAIL_FLG);		// 메일전송체크
		mySheet.SetCellValue(rows, STR_RECV_MAIL, rowData.STR_RECV_MAIL);				// 이메일
		mySheet.SetCellValue(rows, STR_RECV_SMS_FLG, rowData.STR_RECV_SMS_FLG);			// SMS전송체크
		mySheet.SetCellValue(rows, STR_RECV_MOBILE_NUMBER, rowData.STR_RECV_MOBILE_NUMBER);			// 휴대폰 번호
	}
}

// display change
$(document).ready(function() {
	$('input[type=checkbox]').change(function(){
		let target				= $(this).attr('id');
		let targetId			= null;

		// init columnData
		columnData[STR_MAIL + targetClassName]	= mailSendColumn;
		columnData[STR_SMS + targetClassName]	= smsSendColumn;
		columnData[STR_MAIL + removeTarget]		= STR_RECV_MAIL_FLG;
		columnData[STR_SMS + removeTarget]		= STR_RECV_SMS_FLG;

		var maxRow		= mySheet.RowCount();
		if(nullCheck(target)) return;
		targetId	= target.replaceAll(removeTarget, targetClassName);
		if(nullCheck(targetId)) return;

		// 발신수단 체크시
		if($(this).is(':checked')){
			
			// 회색표시 및 편집불가 해제
			$('.'+targetId).find('input').css('background-color','');
			$('.'+targetId).find('input').attr('disabled', false);
			$('.'+targetId).find('textarea').css('background-color','');
			$('.'+targetId).find('textarea').attr('disabled', false);
			$('.'+targetId).find('select').css('background-color','');
			$('.'+targetId).find('select').attr('disabled', false);
			
			// 체크 개수 파악
			for(var i=maxRow; i>= 0; i--){
				var recvOption = mySheet.GetCellValue(i,STR_RECV_OPTION);
				// 수신여부가 수신이라면
				if(recvOption == dmSendY){
					// 체크로직
					mySheet.SetCellValue(i, columnData[target], CHECK_FLG_Y); // 1 check
				}
			}
		// 발신수단 체크해제시
		}else{

			// 회색표시 및 편집불가 적용
			$('.'+targetId).find('input').css('background-color','lightgrey');
			$('.'+targetId).find('input').attr('disabled', true);
			$('.'+targetId).find('textarea').css('background-color','lightgrey');
			$('.'+targetId).find('textarea').attr('disabled', true);
			$('.'+targetId).find('select').css('background-color','lightgrey');
			$('.'+targetId).find('select').attr('disabled', true);
			

			// 체크 갯수 관계없이 체크박스 전체 변경 event
			for(var i=maxRow; i>= 0; i--){
				var recvOption = mySheet.GetCellValue(i,STR_RECV_OPTION);
				// 헤더 제외
				if(recvOption == dmSendY || recvOption == dmSendN){
					// 체크해제로직
					mySheet.SetCellValue(i, columnData[target], CHECK_FLG_N);
				}
			}
		}
		
		// 체크여부와 관계없이 css 세팅
		$('#mailContents').css('background-color','lightgrey');
		$('#mailSubject').css('background-color','lightgrey');
		$('#AgentDmMailTitle').css('background-color','lightgrey');

	});
	
	// 템플릿 변경시 
	$('#MAILFORM_ID').on('change', function(){
		templateArr.forEach((element) => {
			// 메일 제목 및 메일 본문과 sms 본문에 템플릿 설정
			if($(this).val() == element.MAILFORM_ID){
				$('#mailSubject').val(element.MAIL_SUBJECT);
				$('#mailContents').val(element.MAIL_CONTENTS);
				$('#SMS_CONTENTS').val(element.SMS_CONTENTS); 
			}
		});
	});
});

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
/**
 * sms,이메일 발송 체크가 5개 이상이면 발송금지 팝업 호출
 * return boolean
 */
function validSendCnt(){
	var maxRow = mySheet.RowCount();
	var smsCnt = 0;
	var mailCnt = 0;
	for(var i=maxRow; i>= 0; i--){
		// sms 체크 여부 확인
		if(mySheet.GetCellValue(i,STR_RECV_SMS_FLG) == CHECK_FLG_Y){
			// sms 체크로직이 5개 이상이면
			if(++smsCnt >= 5){
				alert("sms는 4개 까지 보낼 수 있습니다.");
				return false;
			}
		}
		// 메일 체크 여부 확인
		if(mySheet.GetCellValue(i,STR_RECV_MAIL_FLG) == CHECK_FLG_Y){
			// 메일 체크로직이 5개 이상이면
			if(++mailCnt >= 5){
				alert("메일은 4개 까지 보낼 수 있습니다.");
				return false;
			}
		}
	}
	return true;
}

/**
 * sms 발송시 sms mms 종류 set
 */
function setSmsKind(){
	// init
	const smsContents = $('#SMS_CONTENTS').val();
	var tempChar = "";										// TextArea의 문자를 한글자씩 담는다
	var countChar = 0;										// 한글자씩 담긴 문자를 카운트 한다
	var tempHangul = 0;										// 한글을 카운트 한다

	// 글자수 바이트 체크를 위한 반복
	for(var i = 0 ; i < smsContents.length; i++) {
		tempChar = smsContents.charAt(i);
		// 한글일 경우 2 추가, 영문일 경우 1 추가
		if(escape(tempChar).length > 4) {
			countChar += 2;
			tempHangul++;
		} else {
			countChar++;
		}
	}

	if( countChar > 90){
		document.forms.searchCondition.st_kind.value = "M";
	}else{
		document.forms.searchCondition.st_kind.value = "S";
	}
}

/**
 * 전송하려는 값 중 null 값이 존재하는지 체크
 * return boolean
 */
function validSendCheck(){
	let sendFlg = false;
	// 체크 개수 파악
	var maxRow = mySheet.RowCount();
	for(var i=maxRow; i>= 0; i--){
		var mailFlg = mySheet.GetCellValue(i,STR_RECV_MAIL_FLG); // mail 송신 체크 
		var smsFlg = mySheet.GetCellValue(i,STR_RECV_SMS_FLG); // sms 송신 체크 
		
		// mail param validation check
		if(mailFlg == CHECK_FLG_Y){
			
			// 이메일 존재여부 체크
			if(nullCheck(mySheet.GetCellValue(i, STR_RECV_MAIL))){
				alert(i+"번째 이메일이 비어있습니다.");
				return false;
			}
			// 이메일 형식 체크
			if(!kepIsValidEmailValue(mySheet.GetCellValue(i,STR_RECV_MAIL))){
				alert(i+"번째 이메일 형식에 오류가 있습니다.");
				return false; // 이메일 체크
			}
			sendFlg = true;
		}
		
		// sms param validation check
		if(smsFlg == CHECK_FLG_Y){
			// 휴대폰 번호 존재여부 체크
			if(nullCheck(mySheet.GetCellValue(i, STR_RECV_MOBILE_NUMBER))){
				alert(i+"번째 휴대폰 번호가 비어있습니다.");
				return false; 
			}
			// 휴대폰 번호 형식 체크
			if(!kepIisValidPhone(mySheet.GetCellValue(i,STR_RECV_MOBILE_NUMBER))){
				alert(i+"번째 휴대폰 번호 형식에 오류가 있습니다.");
				return false; 
			}
			// 휴대폰 앞자리 체크
			if(!kepIisValidFirstNumber(mySheet.GetCellValue(i,STR_RECV_MOBILE_NUMBER))){
				alert(i+"번째 휴대폰 번호 형식에 오류가 있습니다.");
				return false;
			}
			sendFlg = true;
		}

		// 공통 param check
		if(smsFlg == CHECK_FLG_Y || mailFlg == CHECK_FLG_Y){ // sms or mail 하나라도 보낸다면
			// 받을 대상 체크
			if(nullCheck(mySheet.GetCellValue(i, STR_RECV_NAME))){
				alert(i+"번째 받을 대상이 비어있습니다.");
				return false;
			}
			// 비고 체크
			if(nullCheck(mySheet.GetCellValue(i, STR_RECV_REMARK))){
				alert(i+"번째 받을 비고가 비어있습니다.");
				return false;
			}
		}
	}
	// 체크가 하나도 없었다면
	if(!sendFlg){
		alert("보낼 대상을 선택 해주세요");
		return false
	}
	return true;
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){

	// mailTemplate불러와서 select box에 삽입
	if (pMethod == "mailTemplateMethod"){
		const DEFAULT_TEMPLATE = "DM_001_MS";
		//DM_SEND_SETM
		templateArr = response.data.reverse();
		templateArr.forEach((element) => {
			$("#MAILFORM_ID").append("<option value=" + element.MAILFORM_ID + ">" + element.MAILFORM_DESC + "</option>");
			if(element.MAILFORM_ID == DEFAULT_TEMPLATE){
				$('#mailSubject').val(element.MAIL_SUBJECT);
				$('#mailContents').val(element.MAIL_CONTENTS);
				$('#SMS_CONTENTS').val(element.SMS_CONTENTS);
				$("#MAILFORM_ID").val(DEFAULT_TEMPLATE).prop("selected", true); // defalut 템플릿 선택
			}
		});
	}

	// 이슈정보 가져와서 미리보기로 전달
	if (pMethod == "agentDmIssueMethod"){
		// 전달 대상 key
		const previewTargetKey = ["SENT_TYPE_TEXT", "SENT_BUYER_NAME", "SENT_PO_NO", "SENT_BUYER_ITEM_NO", "SENT_DESCRIPTION", "SENT_SPECIFICATION", "SENT_PO_REMARK"];
		// 각 컬럼의 헤더명 및 길이 설정
		const tableHeader = ["상태", "고객사명", "발주번호", "품목코드", "품명", "규격", "고객사 요청사항"];
		const widthArr = ["100", "120", "90", "110", "150", "180", "150"]; // 단위 px
		dmissueObj = response.data;

		// nullcheck
		if(nullCheck(dmissueObj)){
			alert('이슈 상태가 존재하지 않습니다.\n잠시 후 다시 시도해주세요.');
			opener.doAction('search');
			this.close();
		}

		// 테이블 헤더 설정
		const headerJson = {};
		
		previewTargetKey.forEach((val, index) => {headerJson[val] = [{headerName : tableHeader[index]},{headerWidth : widthArr[index]}]});

		// 첫 위치에 추가
		dmissueObj.unshift(headerJson);

		let sortArr = [];
		// json key값 정렬
		dmissueObj.forEach((obj)=>{
			// 임시 obj
			let sortObj = {};
			previewTargetKey.forEach((key)=>{
				sortObj[key] = obj[key];
			});
			sortArr.push(sortObj);
		});
		// 정렬된 객체로 옮기기
		dmissueObj = sortArr;

		// json에러 형식 변환
		dmissueObj.forEach((obj, index)=>{
			if(index != 0){ // 첫 행은 header 부분이라 형식변환 제외
				Object.keys(obj).forEach((key) => {
					if(Object.keys(headerJson).includes(key)){
						obj[key] = convJsonParse(obj[key]);
					} else { // 전달 대상 외의 데이터가 있다면 전부 제거
						delete obj[key];
					}
				})
			}
		});
	}
}

/**
 * json 데이터 중 parse error에 해당하는 부분 대응 후 return
 * param String data
 * return String convData 
 */
function convJsonParse(data){

	if(typeof(data) != 'string'){
		return data;
	}

	let convData;
	const singleQuote = "'";
	const doubleQuote = '"';
	const singleQuoteSeparator = "^s^s^s^";
	const doubleQuoteSeparator = "^d^d^d^";
	const comma = ",";

	// 형변환 '와 "는 json parse에서 오류가 발생할 수 있기 떄문에 제거
	convData = data;
	convData = convData.replaceAll(singleQuote, singleQuoteSeparator);
	convData = convData.replaceAll(doubleQuote, doubleQuoteSeparator);

	// last word comma 제거 
	const lastWord = convData[convData.length - 1];
	if(lastWord == comma){ //마지막 문자열이 , 라면
		convData = convData.slice(0,-1); // 마지막 문자열 제거 
	}

	return convData;
}

//행 추가시 빈 값이 존재해서는 안됨
function emptyCellCheck(){
	const MAX_CONTACT_CNT = 5;
	const MSG_END = "행에 빈값이 있습니다.\n";
	const MAIL_MSG_END = "행의 이메일 형식에 오류가 있습니다.\n";
	const SMS_MSG_END = "행의 휴대폰 번호 형식에 오류가 있습니다.\n";
	const KEY_MSG_END = "행의 이메일/SMS 키가 중복됩니다.\n";
	let resultMsg = "";
	let contractData = [];
	var maxRow = mySheet.RowCount();
	// 협력사 연락처 제한 
	if(maxRow > MAX_CONTACT_CNT) return "협력사 연락처 설정은 관리자 포함 최대 " + MAX_CONTACT_CNT + "개까지 가능합니다.)";

	// grid 체크 
	for(var i=maxRow; i> 0; i--){
		var errorFlg = false;
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
			}else if(!kepIsValidEmailValue(mySheet.GetCellValue(i,STR_RECV_MAIL))){ // 이메일이 존재하면 이메일 형식 체크
				// 이메일 형식이 아닌경의 msg 추가
				resultMsg += i + MAIL_MSG_END;
				errorFlg = true;
			}

			// 휴대폰번호 체크
			if(nullCheck(mySheet.GetCellValue(i,STR_RECV_MOBILE_NUMBER)) && !errorFlg){
				resultMsg += i + MSG_END;
				errorFlg = true;
			}else if(!kepIisValidPhone(mySheet.GetCellValue(i,STR_RECV_MOBILE_NUMBER))){ // 휴대폰번호가 존재하면 휴대폰번호 형식 체크
				resultMsg += i + SMS_MSG_END;
				errorFlg = true;
			}

			// 설정 체크
			if(nullCheck(mySheet.GetCellValue(i,STR_RECV_OPTION)) && !errorFlg){
				resultMsg += i + MSG_END;
				errorFlg = true;
			}

			// 입력값중 email/sms를 키로하는 중복체크
			if(!contractData.includes(mySheet.GetCellValue(i,STR_RECV_MAIL) + mySheet.GetCellValue(i,STR_RECV_MOBILE_NUMBER))) {
				contractData.push(mySheet.GetCellValue(i,STR_RECV_MAIL) + mySheet.GetCellValue(i,STR_RECV_MOBILE_NUMBER));
			}else if(!errorFlg){ // 중복됨
				resultMsg += i + KEY_MSG_END;
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
 * ajax 공통 호출후 에러시 처리 함수
 */
function kepAjaxError(pMethod , response) {
	alert("<%=CommonLang.msg("MSG14")%>"); //처리중 오류가 발생 하였습니다.\n\n확인 후 다시 시도하여 주십시요
	}
</script>
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height: 594px;">
		<div id="popHeader">
			<h1 class="title">협력사 DM 발송</h1>
			<p class="popClose">
				<a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a>
			</p>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
			<!-- 템플릿 호출용 폼 -->
			<form name="mailTemplateForm" id="mailTemplateForm" method="post">
				<input type="hidden" id="st_com_code" name="st_com_code" value="<%=st_com_code%>">
			</form>
			<!-- 이슈정보 호출용 폼 -->
			<form name="agentDmIssueForm" id="agentDmIssueForm" method="post">
				<input type="hidden" id="st_com_code" name="st_com_code" value="<%=st_com_code%>"> 
				<input type="hidden" id="st_po_no" name="st_po_no" value="<%=st_po_no%>"> 
				<input type="hidden" id="st_po_seq" name="st_po_seq" value="<%=st_po_seq%>">
				<input type="hidden" id="st_ds_seq" name="st_ds_seq" value="<%=st_ds_seq%>">
				<input type="hidden" id="st_dm_issue" name="st_dm_issue" value="<%=st_dm_issue%>">
			</form>

			<form name="searchCondition" id="searchCondition" method=post>
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME"> <input type="hidden" id="pageflag" name="pageflag" value="1">
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_user_id" name="st_user_id" value="${sessionInfo.userId}">
				<input type="hidden" id="st_com_code" name="st_com_code" value="<%=st_com_code%>"> 
				<input type="hidden" id="st_po_no" name="st_po_no" value="<%=st_po_no%>"> 
				<input type="hidden" id="st_po_seq" name="st_po_seq" value="<%=st_po_seq%>">
				<input type="hidden" id="st_ds_seq" name="st_ds_seq" value="<%=st_ds_seq%>">
				<input type="hidden" id="st_sent_seq" name="st_sent_seq" value="<%=st_sent_seq%>">
				<input type="hidden" id="st_dm_issue" name="st_dm_issue" value="<%=st_dm_issue%>">
				<input type="hidden" id="SEND_EMAIL" name="SEND_EMAIL" value="<%=userEmail%>">
				<input type="hidden" id="SEND_TEL" name="SEND_TEL" value="<%=userTel%>">
				<input type="hidden" id="SEND_NAME" name="SEND_NAME" value="<%=userName%>">
				<input type="hidden" id="st_com_code_name" name="st_com_code_name" value="<%=st_com_code_name%>">
				<input type="hidden" name="st_kind" id="st_kind" type="text"  value="" >

				<!-- 발신 수단 선택 영역 -->
				<h2>
					발신 정보
				</h2>
				<table class="cont_t_list06 mb15" summary="발신 정보"
					style="width: 100%;">
					<caption>발신 정보</caption>
					<colgroup>
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
						<col width="40%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">발신수단</th>
							<td colspan="1">
								<div>
									<input type="checkbox" id="mailCheck" name="mailCheck">
									<span>E-mail</span>
								</div>
							</td>
							<td colspan="2">
								<div>
									<input type="checkbox" id="smsCheck" name="smsCheck">
									<span>SMS</span>
								</div>
							</td>
						</tr>
					</tbody>
				</table>

				<!-- 이메일 정보 영역 -->
				<div class="mail_area">
					<h2>
						이메일 정보
					</h2>
					<table class="cont_t_list06 mb15" summary="발신 정보"
						style="width: 100%;">
						<caption>발신 정보</caption>
						<colgroup>
							<col width="20%" />
							<col width="15%" />
							<col width="15%" />
							<col width="20%" />
							<col width="30%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">메일 발송 주소</th>
								<td colspan="4"><span><%=userEmail%></span></td>
							</tr>

							<tr>
								<th scope="row">템플릿</th>
								<td colspan="2">
									<div>
										<select id = "MAILFORM_ID" name="MAILFORM_ID" style="width: 95%">
										</select>
									</div>
								</td>
								<td colspan="2">
								</td>
							</tr>

							<tr>
								<th scope="row">메일 제목</th>
								<td colspan="4">
									<div>
										<input type="text" id="mailSubject" name="mailSubject" class="input_type_text" value="" readonly style="width: 99%; background-color: lightgrey;">
									</div>
								</td>
							</tr>

							<tr>
								<th scope="row">메일 본문</th>
								<td colspan="4"><textarea rows="6" id="mailContents" name="mailContents" style="width: 99.5%; margin: 5px 0px; background-color: lightgrey;" readonly></textarea>
								</td>
							</tr>

							<tr>
								<th scope="row">운영자 메모</th>
								<td colspan="4">
									<div>
										<textarea rows="4" id="REMARK" name="REMARK"
											placeholder="최대 200자 입력 가능"
											maxlength="200" style="width: 99%; margin: 5px 0px;"></textarea>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<!-- SMS 정보 영역 -->
				<div class="sms_area">
					<h2>
						SMS 정보
					</h2>
					<table class="cont_t_list06 mb15" summary="SMS 정보"
						style="width: 100%;">
						<caption>SMS 정보</caption>
						<colgroup>
							<col width="20%" />
							<col width="30%" />
							<col width="50%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">발신 번호</th>
								<td colspan="2">
									<div>
										<input type="text" id="AgentDmMailTitle"
											name="AgentDmMailTitle" class="input_type_text"
											value="<%= userName %> ( <%= userTel %> )" style="width: 33%; background-color: lightgrey;" readonly>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row">SMS발송문구</th>
								<td colspan="2">
									<div>
										<textarea rows="4" id="SMS_CONTENTS" name="SMS_CONTENTS"
											placeholder="SMS발송문구를 입력해주세요"
											maxlength="200" style="width: 99%; margin: 5px 0px; background-color: lightgrey;" disabled="disabled">[KoreaB2B.com] 수주내역 확인요청 드립니다.&#10자세한 사항은 KeP협력사 사이트에서 확인 가능합니다.</textarea>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<!-- 수신 정보 -->
				<div class="info_area">
					<h2>
						수신 정보
					</h2>
					<table class="cont_t_list06 mb15" summary="SMS 정보"
						style="width: 100%;">
						<caption>SMS 정보</caption>
						<colgroup>
							<col width="20%" />
							<col width="80%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" style="text-align: center;">
									<p>
										협력사
									</p> <a href="javascript:doAgentContactPop();"><span
										class="btn_99 mr02">설정</span></a>
								</th>
								<td colspan="1"><span> <%=st_com_code_name%> ( <%=st_com_code%> )
								</span></td>
							</tr>
						</tbody>
					</table>
					<!--grid-->
					<div class="ib_product" style="border-top: 2px solid #3c639c">
						<script type="text/javascript">
							createIBSheet("mySheet", "100%", "200px");
						</script>
					</div>
				</div>
			</form>
			<!--버튼영역-->
			<div class="btnArea02" style="margin: 2px; text-align: right;">
				<span class="btn_03 mr02"><a href="javascript:addrows();">행추가</a></span>
				<span class="btn_03 mr02"><a href="javascript:doPreviewPop();">미리보기</a></span> 
				<span class="btn_04 mr02"><a href="javascript:doAction('save');">발송</a></span>
			</div>
		</div>
	</div>
</body>
</html>
