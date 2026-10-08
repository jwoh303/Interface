<%--
**********************************************
* 메뉴 : 회원사관리>고객사 등록관리 조회
* 화면 : 고객회원사 가입 팝업
* 기능 : 고객사의 정보를 입력하여 가입 등록
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
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>


<script type="text/javascript">
var popupSel = "";
var mt;

function kep_onload(){
	kepSetCalender('establish_date');
	kepAjaxCommonComboDataValue('st_pay_terms', 'SA15', 'SEL', '');
	kepAjaxCommonComboDataValue('st_pay_type', 'SA02', 'SEL', '');
}
// 기능함수
function doAction(str) {
	switch (str) {
	case "reload": // 초기화
		kepReload('contentForm');
		break;
	case "save": // 저장
		if (checkSubmit()) {
			kepAjaxFormCall("/mdam/saveMasterMdAmBuyerMbrcmpyRegList.do", "contentForm", "save");
		}
		break;
	case "idCheck": // id 중복체크
		if (isEmpty($("#st_user_id").val())) {
			alert("사용자 ID를 입력해 주십시요");
			$("#st_user_id").focus();
			return;
		}
		if (kepIsSpecialChar("st_user_id")) {
			alert("사용자 ID는 특수문자를 포함할 수 없습니다.");
			$("#st_user_id").focus();
			return;
		}
		if (kepTrim("st_user_id") != $("#st_user_id").val() || containsWhitespace($("#st_user_id").val())){
			alert("사용자 ID는 공백을 포함할 수 없습니다.");
			$("#st_user_id").focus();	
			return ;
		}
		kepAjaxFormCall("/mdam/getMasterMdAmBuyerMbrcmpyRegIDCheck.do", "contentForm", "idCheck");
		break;
	case "pwdCheck":
		if (passwordValidCheck()) {
			kepAjaxFormCall("/mdam/getMasterMdAmBuyerMbrcmpyRegPwdValidCheck.do", "contentForm", "pwdCheck");
		}
		break;
	case "estDate":	 // 달력
		CalendarCheck('estDate');
		break; 		
	}
}
//설립년도 체크
var date_check;
function CalendarCheck(check){
    date_check = check;
    kepCalendarOpenPopup();
}
//설립년도 셋팅.
function setPopupCalendar(year,month,day){
    var rd_date      = year+""+month+""+day+"";
    var rd_date_text = year+"/"+month+"/"+day+"";
    if(date_check=="estDate"){
        document.forms.contentForm.establish_date.value = rd_date_text;
        document.forms.contentForm.st_establish_date.value   = rd_date;
    }
}
// 팝업함수호출
function doPop(str) {
	popupSel = str;

	switch (str) {
		case "newzipcode": //우편번호 검색
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");			
			break;
		case "fileUpload": //파일업로드
			openSearchPopup("/common/fileUploadPop.do","?DOC_NO="+$("#st_image_key").val(), "500,430,no");
			break;
		case "kepCorpCcode": //고객사 법인그룹선택
			openSearchPopup("/mdct/showMasterMdctBuyerCorpGroupPop.do", "", "500,500,no");
			break;	
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	switch (popupSel) {
		case "zipcode": //우편번호 검색
			$("#st_zip_code").val(code);
			$("#st_address").val(text);
			break;
		case "fileUpload": //파일업로드
			$("#st_image_key").val(code);
			break;
		case "kepCorpCcode": //파일업로드
			$("#st_corp_code").val(code);
			$("#st_corp_name").val(text);
			break;	
	}
	grbRow = ""; //초기화
}

// ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 
function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
	$("#st_zip_code").val(zipNo.replace(/[^0-9]/gi, ''));
	$("#st_zip_key").val(bdMgtSn);
	$("#st_address").val(roadAddrPart1 + " " + roadAddrPart2);
	$("#st_address_dt").val(addrDetail);
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod, response) {

	var sMsg = response.msg;
	if (pMethod == "pwdCheck") {
		if (sMsg != 'OK') {
			alert(sMsg);
			$("#st_password").val("");
			$("#st_password").focus();
			return;
		} else {
			$("#chkPassword").val("Y");
			return;
		}
	} else if (pMethod == "idCheck") {
		if (sMsg == 'OK') {
			alert("사용가능한 ID 입니다.");
			$("#id_check_flag").val("Y");
			return;
		}else if(sMsg=='NO'){
			alert("이미 사용하고 있는 ID 입니다. 다른 ID를 입력하세요.");
			$("#id_check_flag").val("N");
			$("#st_user_id").val("");
			$("#st_user_id").focus();
			return;
		} else {
			alert("ID에 금지어("+sMsg+")가 포함되어 있습니다. 다른 ID를 입력하세요.");
			$("#id_check_flag").val("N");
			$("#st_user_id").val("");
			$("#st_user_id").focus();
			return;
		}
	} else if (pMethod == "save") {
		if (sMsg == "OK") {
			alert("고객회원사 가입이 완료되었습니다.");
			window.opener.doAction("search");
			self.close();
			return;
		} else {
			if (sMsg == "Err") {
				alert("고객사 및 관리자 사용자 등록이 실패 하였습니다.\n다시 확인하여 주십시요!");
			} else if (sMsg == "irs") {
				alert("이미 등록된 업체입니다.\n다시 확인하여 주십시요!");
				return;
			} else if (sMsg == "9999") {
				alert("한 회사에서 9999건 이상 초과해서 등록할 수 없습니다.");
				return;
			}
		}
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function kepAjaxError(pMethod, response) {
	if (pMethod == "pwdCheck") {
		 alert(response);
		 console.log(response);
	} else {
		alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.");
	}
	
}

function passwordValidCheck() {
	$("#chkPassword").val("N");

	if (isEmpty($("#st_user_id").val())) {
		alert("사용자 ID를 입력해 주십시요");
		$("#st_user_id").focus();
		return false;
	}

	if ($("#st_user_id").val().length < chkKorea($("#st_user_id").val())) {
		alert("사용자 ID를 영문으로 입력해 주십시요.");
		$("#st_user_id").focus();
		return false;
	}
	if (kepIsSpecialChar("st_user_id")) {
		alert("사용자 ID는 특수문자를 포함할 수 없습니다.");
		$("#st_user_id").focus();
		return false;
	}
	if ($("#id_check_flag").val() == "N") {
		alert("사용자 ID 중복 검사를 먼저 해 주십시요");
		return false;
	}

	if ($("#st_password").val().length == 0) {
		alert("비밀번호가 입력되지 않았습니다. ");
		$("#st_password").focus();
		return false;
	}

	if (checkSpace($("#st_password").val()) && $("#st_password").val() != "") {
		alert("비밀번호에 공백문자은 입력할 수 없습니다.   ");
		$("#st_password").val("");
		$("#st_password").focus();
		return false;
	}

	if ($("#st_password").val().length < 8) {
		alert("비밀번호는 8 자리 이상 사용해야 합니다.");
		$("#st_password").focus();
		$("#st_password").select();
		return false;
	}

	if ($("#st_password").val().length < chkKorea($("#st_password").val())) {
		alert("비밀번호는 영문으로 입력해 주십시요.");
		$("#st_password").focus();
		return false;
	}

	if ($("#st_confirmpasswd").val().length == 0) {
		alert("비밀번호가 입력되지 않았습니다. ");
		$("#st_password_confirm").focus();
		return false;
	}

	if (checkSpace($("#st_confirmpasswd").val()) && $("#st_confirmpasswd").val() != "") {
		alert("비밀번호에 공백문자은 입력할 수 없습니다.   ");
		$("#st_confirmpasswd").val("");
		$("#st_confirmpasswd").focus();
		return false;
	}

	if ($("#st_confirmpasswd").val().length < 8) {
		alert("비밀번호는 8 자리 이상 사용해야 합니다.");
		$("#st_confirmpasswd").focus();
		return false;
	}

	if ($("#st_confirmpasswd").val().length < chkKorea($("#st_confirmpasswd").val())) {
		alert("비밀번호는 영문으로 입력해 주십시요.");
		$("#st_confirmpasswd").focus();
		return false;
	}

	if ($("#st_password").val() != $("#st_confirmpasswd").val()) {
		alert("비밀번호가 일치하지 않습니다.\n다시 한번 입력하시기 바랍니다.");
		$("#st_password").focus();
		return false;
	}

	return true;
}

function checkSubmit() {
	
	if (isEmpty($("#st_com_name_loc").val())) {
		alert("한글회사명을 입력해주세요.");
		$("#st_com_name_loc").focus();
		return false;
	}

	if (isEmpty($("#st_com_name_eng").val())) {
		alert("영문회사명을 입력해주세요.");
		$("#st_com_name_eng").focus();
		return false;
	}

	//영문 회사명 Check
	if ($("#st_com_name_eng").val().length < chkKorea($("#st_com_name_eng").val())) {
		alert("회사명(영문)을 영문으로 입력해 주십시요.");
		$("#st_com_name_eng").focus();
		return false;
	}

	if ($("#st_com_name_eng").val().length < 1) {
		alert("회사명(영문)을 입력해 주십시요.");
		$("#st_com_name_eng").focus();
		return false;
	}

	if (!checkSpecialChar($("#st_com_name_eng").val())) {
		alert("영문 회사명에 특수기호(\", \')를 사용 할수 없습니다.");
		$("#st_com_name_eng").focus();
		return false;
	}
	
	var irsLength = new Array();
	irsLength[0] = 3;
	irsLength[1] = 2;
	irsLength[2] = 5;
	
	for (var i=1; i <= 3 ; i++) {
		if(isEmpty($("#st_irs_no_"+i).val())){
			alert('사업자 등록 번호를 입력 하여 주십시오');
			$("#st_irs_no_"+i).focus();
			return false;
		}
		

		if($("#st_irs_no_"+i).val().length != irsLength[i-1] ) { 
			alert("사업자등록번호 "+i+"번째는 숫자로 "+irsLength[i-1]+"자리 입니다.");
			$("#st_irs_no_"+i).val("");
			$("#st_irs_no_"+i).focus();
			return false;
		}
	}

	if (!KepBizNoCheckStr2($("#st_irs_no_1").val() + $("#st_irs_no_2").val() + $("#st_irs_no_3").val())) {
		alert("사업자 등록번호가 유효하지 않습니다.");
		$("#st_irs_no_1").focus();
		return false;
	}

	if ($("#st_irs_no_1").val() != "") {
		$("#st_irs_no").val($("#st_irs_no_1").val() + "-" + $("#st_irs_no_2").val() + "-" + $("#st_irs_no_3").val());
	}
	
	if (isEmpty($("#establish_date").val())) {
	   alert("설립년도를 선택해 주십시요.");
	   $("#establish_date").focus();
	   return false;
	}
	
	$("#st_establish_date").val($("#establish_date").val().replace(/[/]/gi,""));
	
	if(isEmpty($("#st_corp_name").val())) {
		alert("법인그룹을 선택해 주십시요.");
		$("#st_corp_name").focus();
		return false;
	}

	if (isEmpty($("#st_ceo_name_loc").val())) {
		alert("대표자(국문)를 입력해주세요.");
		$("#st_ceo_name_loc").focus();
		return false;
	}

	if (isEmpty($("#st_ceo_name_eng").val())) {
		alert("대표자(영문)를 입력해주세요.");
		$("#st_ceo_name_eng").focus();
		return false;
	}

	if ($("#st_ceo_name_eng").val().length < chkKorea($("#st_ceo_name_eng").val())) {
		alert("대표자(영문)를 영문으로 입력해 주십시요.");
		$("#st_ceo_name_eng").focus();
		return false;
	}

	if (isEmpty($("#st_tel_no").val())) {
		alert("대표전화번호를 입력해 주십시요.");
		$("#st_tel_no").focus();
		return false;
	}

	if (isEmpty($("#st_industry_type").val())) {
		alert("업태를 입력해 주십시요.");
		$("#st_industry_type").focus();
		return false;
	}

	if (isEmpty($("#st_business_items").val())) {
		alert("종목을 입력해 주십시요.");
		$("#st_business_items").focus();
		return false;
	}

	if (isEmpty($("#st_zip_code").val())) {
		alert("우편번호를 입력해 주십시요.");
		$("#st_zip_code").focus();
		return false;
	}

	if (isEmpty($("#st_zip_key").val())) {
		alert("도로명 주소로 변경 바랍니다.");
		$("#st_zip_code").focus();
		return false;
	}

	if (isEmpty($("#st_address").val())) {
		alert("주소를 입력해 주십시요");
		$("#st_address").focus();
		return false;
	}
	
	if($("#st_irs_no_2").val() == "81" || $("#st_irs_no_2").val() == "82" || $("#st_irs_no_2").val() == "83" || $("#st_irs_no_2").val() == "84" ||
		$("#st_irs_no_2").val() == "85" || $("#st_irs_no_2").val() == "86" || $("#st_irs_no_2").val() == "87" || $("#st_irs_no_2").val() == "88") {
		
		if($("#st_corp_reg_no_1").val() == "" || $("#st_corp_reg_no_2").val() == "") {
			alert("법인등록번호 필수 대상 고객사입니다. 법인등록번호 입력 바랍니다.");
			$("#st_corp_reg_no_1").focus();
			return false;
		}		
	} 

	if ($("#st_corp_reg_no_1").val() != "" && $("#st_corp_reg_no_1").val().length != 6) {
		alert("법인등록번호 첫번째는 숫자로 6자리 입니다.");
		$("#st_corp_reg_no_1").val("");
		$("#st_corp_reg_no_1").focus();
		return false;
	}

	if ($("#st_corp_reg_no_2").val() != "" && $("#st_corp_reg_no_2").val().length != 7) {
		alert("법인등록번호 두번째는 숫자로 7자리 입니다.");
		$("#st_corp_reg_no_2").val("");
		$("#st_corp_reg_no_2").focus();
		return false;
	}

	if ($("#st_corp_reg_no_1").val() != "" && $("#st_corp_reg_no_2").val() != "") {
		$("#st_corp_reg_no").val($("#st_corp_reg_no_1").val() + "-" + $("#st_corp_reg_no_2").val());
	}

	if (isEmpty($("#st_gr_emp_nm").val())) {
		alert("입고담당자명을 입력하여 주십시요.");
		$("#st_gr_emp_nm").focus();
		return false;
	}

	if (isEmpty($("#st_gr_emp_tel").val())) {
		alert("입고담당자 전화번호를 입력하여 주십시요.");
		$("#st_gr_emp_tel").focus();
		return false;
	}

	if (isEmpty($("#st_ac_emp_nm").val())) {
		alert("경리담당자명을 입력하여 주십시요.");
		$("#st_ac_emp_nm").focus();
		return false;
	}

	if (isEmpty($("#st_ac_emp_tel").val())) {
		alert("경리담당자 전화번호를 입력하여 주십시요.");
		$("#st_ac_emp_tel").focus();
		return false;
	}

	if (isEmpty($("#st_pay_recver").val())) {
		alert("물품대금수령처를 입력하여 주십시요.");
		$("#st_pay_recver").focus();
		return false;
	}
	
	if ($("#st_pay_terms").val() == "") {
		alert("수금조건을 선택해 주십시요.");
		$("#st_pay_terms").focus();
		return false;
	}
	
	if ($("#st_pay_type").val() == "") {
		alert("수금형태를 선택해 주십시요.");
		$("#st_pay_type").focus();
		return false;
	}
	if (isEmpty($("#st_user_id").val())) {
		alert("사용자 ID를 입력해 주십시요");
		$("#st_user_id").focus();
		return false;
	}
	if ($("#st_user_id").val().length < chkKorea($("#st_user_id").val())) {
		alert("사용자 ID를 영문으로 입력해 주십시요.");
		$("#st_user_id").focus();
		return false;
	}
	if ($("#id_check_flag").val() == "N") {
		alert("사용자 ID 중복 검사를 먼저 해 주십시요");
		return false;
	}
	if ($("#chkPassword").val() != "Y") {
		doAction("pwdCheck");
		return false;
	}
	
	if (kepTrim("st_user_id") != $("#st_user_id").val()){
		alert("사용자 ID는 공백을 포함할 수 없습니다.");
		$("#st_user_id").focus();	
		return false;
	}
	if (kepIsSpecialChar("st_user_id")) {
		alert("사용자 ID는 특수문자를 포함할 수 없습니다.");
		$("#st_user_id").focus();
		return false;
	}
	if (isEmpty($("#st_user_name_loc").val())) {
		alert("사용자 이름(국문)을 입력해 주십시요");
		$("#st_user_name_loc").focus();
		return false;
	}


	if (isEmpty($("#st_mobile_phone1").val())) {
		alert(" 사용자 휴대폰번호를 입력해 주십시요.");
		$("#st_mobile_phone1").focus();
		return false;
	}

	if (isEmpty($("#st_mobile_phone2").val())) {
		alert("사용자 휴대폰번호를 입력해 주십시요.");
		$("#st_mobile_phone2").focus();
		return false;
	}

	if (isEmpty($("#st_mobile_phone3").val())) {
		alert("사용자 휴대폰번호를 입력해 주십시요.");
		$("#st_mobile_phone3").focus();
		return false;
	}
	if ($("#st_mobile_phone1").val().length != 3 || $("#st_mobile_phone2").val().length < 3 || $("#st_mobile_phone3").val().length != 4) {
		alert("휴대폰 번호를 정확히 입력하세요.");
		$("#st_mobile_phone1").focus();
		return false;
	}

	$("#st_mobile_phone").val($("#st_mobile_phone1").val() + "-" + $("#st_mobile_phone2").val() + "-" + $("#st_mobile_phone3").val());

	if (isEmpty($("#st_mobile_phone").val())) {
		alert("사용자 휴대폰번호를 입력해 주십시요");
		$("#st_mobile_phone").focus();
		return false;
	}
	if (isEmpty($("#st_fax_number").val())) {
		alert("사용자 팩스번호를 입력해 주십시요");
		$("#st_fax_number").focus();
		return false;
	}
	

	if (isEmpty($("#st_phone_number").val())) {
		alert("사용자 전화번호를 입력해 주십시요");
		$("#st_phone_number").focus();
		return false;
	}
	

	dial = $("#st_phone_number").val().substring(0,2);
	if(dial == '01'){ <%-- 휴대폰 번호 앞자리 (010 ~ 019) 판별을 위해--%>
		alert(" 전화번호에 휴대폰 번호는 입력하실 수 없습니다.");
		return false;
	}
	
	if (isEmpty($("#st_email").val())) {
		alert("사용자 E-MAIL을 입력해 주십시요");
		$("#st_email").focus();
		return false;
	}

	if (!checkemail("st_email")) {
		return false;
	}
	
	if (kepTrim("st_legacy_user_id") != $("#st_legacy_user_id").val()){
		alert("사번은 공백을 포함할 수 없습니다.");
		$("#st_legacy_user_id").focus();	
		return ;
	}
	
	$("#st_mail_send_flag").val($("input[name=mail_send_flag]:checked").val());

	return confirm("고객사 및 관리자 사용자를 등록 하시겠습니까?");
	 
}
//특수문자 입력체크
function checkSpecialChar(str) {
	
	for(var i=0 ; i < str.length; i++) {
		if(str.charAt(i)=='\'' || str.charAt(i)=='"'){
			return false;
		}
	}
	return true;
}

</script> 
<body onload="kep_onload();">
<form name="contentForm" id="contentForm" method=post >
	<input type="hidden" id="id_check_flag" name="id_check_flag" value="N" />
	<input type="hidden" name="chkPassword" id="chkPassword" value="N" />
	<input type="hidden" id="st_business_cond" name="st_business_cond" value="B" />
	<input type="hidden" id="st_ceo_reg_no" name="st_ceo_reg_no" value="" />
	<div id="popWrapper" style="height:700px;">
		<div id="popHeader">
			<h1 class="title">고객회원사 가입</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
		</div>
		<div id="popContainer">
			<h3 class="pt20">고객회원사 등록</h3>
			<p class="b" style="color:red;">* 필수입력사항을 입력해 주세요.</P>
			<table class="cont_t_list06 TableMemberJoin" style="width:100%;">
				<colgroup>
					<col width="130px" />
					<col width="210px" />
					<col width="130px" />
					<col width="210px" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="star"> 회사명(국문)</th>
						<td><input type="text" class="input_type_text" id="st_com_name_loc" name="st_com_name_loc" title="" maxlength="50" onkeyup="fnCheckInputByte(this, 50);"
							onchange="fnCheckInputByte(this, 50);" value="" style="width: 98%" class="input_type_text" /></td>
						<th scope="row" class="star"> 회사명(영문)</th>
						<td><input type="text" class="input_type_text" id="st_com_name_eng" name="st_com_name_eng" title="" maxlength="50" value=""
							style="ime-mode: disabled; width: 98%" class="input_type_text" /></td>
					</tr>
					<tr>
						<th scope="row" class="star">사업자등록번호</th>
						<td><input type="text" class="input_type_text" class="input_type_text" id="st_irs_no_1" name="st_irs_no_1" title="" size="4" maxlength="3" value="" onkeyup="kepNumcheck(this);"
							onchange="kepNumcheck(this);" /> - <input type="text" class="input_type_text" class="input_type_text" id="st_irs_no_2" name="st_irs_no_2" title="" size="3" maxlength="2" value=""
							onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> - <input type="text" class="input_type_text" class="input_type_text" id="st_irs_no_3" name="st_irs_no_3" title="" size="6"
							maxlength="5" value="" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> <input type="hidden" id="st_irs_no" name="st_irs_no"
							value="" /></td>
						<th scope="row" class="star">설립년도</th>
						<td>
							<input type="text" class="input_type_text" class="input_type_text" id="establish_date" name="establish_date" title="" maxlength="8"   value="" readonly style="width:85%"/>
							<input type="hidden" id="st_establish_date" name="st_establish_date" title="" maxlength="8"   value="" />
						</td>
		
					</tr>
					<tr>
						<th scope="row"  class="star">법인그룹</th>
						<td>
							<input type="hidden" id="st_corp_code" name="st_corp_code" value="" /> <input type="text" class="input_type_text" class="input_type_text" id="st_corp_name" name="st_corp_name" title="" value="" readonly style="width: 65%" />
							<span class="btn_gray_03"  title="그룹검색" ><a href="javascript:doPop('kepCorpCcode');">그룹검색</a></span>
						</td>
						<th scope="row">메일링서비스</th>
						<td><input type="radio" id="mail_send_flag1" name="mail_send_flag" value="Y" class="noborder" />&nbsp;예&nbsp;&nbsp;&nbsp;
							<input type="radio" id="mail_send_flag2" name="mail_send_flag" value="N" checked="checked" class="noborder" />&nbsp;아니오
							<input type="hidden" id="st_mail_send_flag" name="st_mail_send_flag" value="" />
						</td>
					</tr>
					<tr>
						<th scope="row" class="star">대표자(국문)</th>
						<td><input type="text" class="input_type_text" class="input_type_text" id="st_ceo_name_loc" name="st_ceo_name_loc" title="" maxlength="40" onkeyup="fnCheckInputByte(this, 40);" onchange="fnCheckInputByte(this, 40);" value="" style="width: 98%" /></td>
						<th scope="row" class="star">대표자(영문)</th>
						<td><input type="text" class="input_type_text" class="input_type_text" id="st_ceo_name_eng" name="st_ceo_name_eng" title="" maxlength="20" value="" style="width: 98%; ime-mode: disabled;" /></td>
					</tr>
					<tr>
						<th scope="row" class="star">대표전화번호</th>
						<td>
							<input type="text" class="input_type_text" class="input_type_text" id="st_tel_no" name="st_tel_no" title="" maxlength="20" value="" onkeyup="fnPhoneNumberCheck('st_tel_no');" onchange="fnPhoneNumberCheck('st_tel_no');" style="width: 40%" />
							(EX : 02-0000-0000)
						</td>
						<th scope="row">대표FAX번호</th>
						<td><input type="text" class="input_type_text" class="input_type_text" id="st_fax_no" name="st_fax_no" title="" maxlength="20" value="" onkeyup="fnPhoneNumberCheck('st_fax_no');" onchange="fnPhoneNumberCheck('st_fax_no');" style="width: 98%" /></td>
					</tr>
					<tr>
						<th scope="row" class="star">업태</th>
						<td><input type="text" class="input_type_text" class="input_type_text" id="st_industry_type" name="st_industry_type" title="" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" value="" style="width: 98%" /></td>
						<th scope="row" class="star">종목</th>
						<td><input type="text" class="input_type_text" class="input_type_text" id="st_business_items" name="st_business_items" title="" maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" value="" style="width: 98%" /></td>
					</tr>
					<tr>
						<th scope="row" class="star">주소</th>
						<td colspan="3"><input type="text" class="input_type_text" id="st_zip_code" name="st_zip_code" title="" maxlength="7" readonly value="" style="width: 21%" />
							<input type="hidden" id="st_zip_key" name="st_zip_key" value="" />
							<input type="text" class="input_type_text" id="st_address" name="st_address" title="" maxlength="50" readonly value="" style="width: 60%" />
							<input type="hidden" id="st_address_eng" name="st_address_eng" title="" maxlength="100" value="" />
							<span class="btn_gray_05"  title="우편번호" ><a href="javascript:doPop('newzipcode');">우편번호 검색</a></span>
						</td>
					</tr>
					<tr>
						<th>상세 주소</th>
						<td colspan="3">
							<input type="text" class="input_type_text" id="st_address_dt" name="st_address_dt" title="" maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" value="" style="width: 99%" />
						</td>
					</tr>
					<tr>
						<th>홈페이지 주소</th>
						<td colspan="3">
							<input type="text" class="input_type_text" id="st_hp_address" name="st_hp_address" title="" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" value="" style="width: 99%" />
						</td>
					</tr>
					<tr>
						<th  class="star">법인등록번호</th>
						<td>
							<input type="text" class="input_type_text" id="st_corp_reg_no_1" name="st_corp_reg_no_1" title="" size="9" maxlength="6" value="" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
							 - <input type="text" class="input_type_text" id="st_corp_reg_no_2" name="st_corp_reg_no_2" title="" size="8" maxlength="7" value="" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
							 <input type="hidden" id="st_corp_reg_no" name="st_corp_reg_no" value="" />
						 </td>
						<th>무역등록번호</th>
						<td><input type="text" class="input_type_text" id="st_trade_reg_no" name="st_trade_reg_no" title="" maxlength="20" value="" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" style="width: 98%" /></td>
					</tr>
					<tr>
						<th>DUNS-NO</th>
						<td colspan="3">
							<input type="text" class="input_type_text" id="st_duns_no" name="st_duns_no" title="" maxlength="20" value="" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" style="width: 34%" />
						</td>
					</tr>
					<tr>
						<th class="star">입고담당자명</th>
						<td><input type="text" class="input_type_text" id="st_gr_emp_nm" name="st_gr_emp_nm" title="" maxlength="20" value="" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" style="width: 98%" /></td>
						<th class="star">연락처</th>
						<td><input type="text" class="input_type_text" id="st_gr_emp_tel" name="st_gr_emp_tel" title="" maxlength="20" value="" onkeyup="fnPhoneNumberCheck('st_gr_emp_tel');" onchange="fnPhoneNumberCheck('st_gr_emp_tel');" style="width: 98%" /></td>
					</tr>
					<tr>
						<th class="star">경리담당자명</th>
						<td><input type="text" class="input_type_text" id="st_ac_emp_nm" name="st_ac_emp_nm" title="" maxlength="20" value="" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" style="width: 98%" /></td>
						<th class="star"> 연락처</th>
						<td><input type="text" class="input_type_text" id="st_ac_emp_tel" name="st_ac_emp_tel" title="" maxlength="20" value="" onkeyup="fnPhoneNumberCheck('st_ac_emp_tel');" onchange="fnPhoneNumberCheck('st_ac_emp_tel');" style="width: 98%" /></td>
					</tr>
					<tr>
						<th class="star">물품대금수령처</th>
						<td colspan="3">
							<input type="text" class="input_type_text" id="st_pay_recver" name="st_pay_recver" title="" maxlength="50" value="" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" style="width: 99%" />
							※ 통장이체, 공장/본사 출납부서등을 표기 부탁드립니다.
						</td>
					</tr>
					<tr>
						<th class="star">수금조건</th>
						<td><select id="st_pay_terms" name="st_pay_terms" style="width: 99%"></select></td>
						<th class="star">수금형태</th>
						<td><select id="st_pay_type" name="st_pay_type" style="width: 99%"></select></td>
					</tr>
					<tr>
						<th>첨부파일</th>
						<td colspan="3"><input type="text" class="input_type_text" id="st_image_key" name="st_image_key" value="" style="width: 86%" />
							<input type="hidden" id="st_image_key_Text" name="st_image_key_Text" title="" value="" style="width: 86%" />
							<span class="btn_gray_03"  title="파일첨부" ><a href="javascript:doPop('fileUpload')">파일첨부</a></span>
						</td>
					</tr>
					<tr>
						<th>비고</th>
						<td colspan="3"><input type="text" class="input_type_text" id="st_remark" name="st_remark" title="" maxlength="50" value="" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" style="width: 99%" /></td>
					</tr>
				</tbody>
			</table>
			
			<h3 class="pt20">관리자 정보</h3>
			<p class="b" style="color:red;">* 필수입력사항을 입력해 주세요.</P>
			<table class="TableMemberJoin cont_t_list06 ">
				<colgroup>
					<col width="130px" />
					<col width="210px" />
					<col width="130px" />
					<col width="210px" />
				</colgroup>
				<tbody>
					<tr>
						<th class="star">아이디</th>
						<td>
							<input type="text" class="input_type_text" id="st_user_id" name="st_user_id" title="" onkeyup="kepToUpper('st_user_id');" style="ime-mode: disabled;" maxlength="20" value="" />
							<span class="btn_gray_03"  title="중복확인" ><a href="javascript:doAction('idCheck');">중복확인</a></span>
						</td>
						<th>사번</th>
						<td>
							<input type="text" class="input_type_text" id="st_legacy_user_id" name="st_legacy_user_id" title="" maxlength="20" value="" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" style="width: 98%" />
						</td>
					</tr>
					<tr>
						<th class="star">비밀번호</th>
						<td>
							<input type="password" class="input_type_text" id="st_password" name="st_password" title="" style="width: 75%; ime-mode: disabled;" maxlength="20" value="" onchange="doAction('pwdCheck')" />
							<font color="#FF0000" title=" 1. 8자리 이상 사용해야 합니다.&#10;2. 혼합(영문자+숫자+특수문자) 사용해야 합니다.&#10;3. 변경주기는 90일 입니다.&#10;4. 아이디와 동일하게 사용할수 없습니다.">
								<b>※규정</b>
							</font>
						</td>
						<th class="star">비밀번호 확인</th>
						<td><input type="password" class="input_type_text" id="st_confirmpasswd" name="st_confirmpasswd" title="" style="width: 98%; ime-mode: disabled;" maxlength="20" value="" onchange="doAction('pwdCheck')" /></td>
					</tr>
					<tr>
						<th class="star">이름(국문)</th>
						<td>
							<input type="text" class="input_type_text" id="st_user_name_loc" name="st_user_name_loc" title="" maxlength="40" value="" onkeyup="fnCheckInputByte(this, 40);" onchange="fnCheckInputByte(this, 40);" style="width: 98%" />
						</td>
						<th>이름(영문)</th>
						<td><input type="text" class="input_type_text" id="st_user_name_eng" name="st_user_name_eng" title="" style="width: 98%; ime-mode: disabled;" maxlength="40" value="" /></td>
					</tr>
					<tr>
						<th class="star">휴대폰번호</th>
						<td><input type="hidden" id="st_mobile_phone" name="st_mobile_phone" value="" />
							<input type="text" class="input_type_text" id="st_mobile_phone1" name="st_mobile_phone1" title="" size="4" maxlength="3" value="" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
							 - <input type="text" class="input_type_text" id="st_mobile_phone2" name="st_mobile_phone2" title="" size="5" maxlength="4" value="" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
							 - <input type="text" class="input_type_text" id="st_mobile_phone3" name="st_mobile_phone3" title="" size="5" maxlength="4" value="" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
						 </td>
						<th class="star">전화번호</th>
						<td>
							<input type="text" class="input_type_text" id="st_phone_number" name="st_phone_number" title="" maxlength="20" value="" onkeyup="fnPhoneNumberCheck('st_phone_number');" onchange="fnPhoneNumberCheck('st_phone_number');" style="width: 98%" />
						</td>
					</tr>
					<tr>
						<th class="star">팩스번호</th>
						<td>
							<input type="text" class="input_type_text" id=st_fax_number name="st_fax_number" title="" maxlength="20" value="" onkeyup="fnPhoneNumberCheck('st_fax_number');" onchange="fnPhoneNumberCheck('st_fax_number');" style="width: 98%" />
						</td>
						<th class="star">이메일</th>
						<td>
							<input type="text" class="input_type_text" id="st_email" name="st_email" title="" maxlength="50" value="" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" style="width: 98%" />
						</td>
					</tr>
				</tbody>
			</table>
			<p class="btnArea mt10 mb05"> 
				<span class="btn_02"><a href="javascript:doAction('save');">등록하기</a></span>
			</p>
		
		</div>
	</div>
	
</form>


 
</body>
</html>
