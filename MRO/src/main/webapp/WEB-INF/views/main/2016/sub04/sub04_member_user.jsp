<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<script src="/resources/js/kep_common.js"></script>
</head>
<%
String com_code = CommonUtil.nvl((String) request.getParameter("com_code"), "");
String com_name = CommonUtil.nvl((String) request.getParameter("com_name"), "");
String business_cond = CommonUtil.nvl((String) request.getParameter("business_cond"), "");

String p01_1010_05 = CommonUtil.getSpecialCheckReturn(com_code,"P01-1010-05","COL01_DATA", request); // 고객사별 사번 라벨명
boolean p01_1010_06 = CommonUtil.getSpecialCheckReturn(com_code,"P01-1010-06"); // 사번필수 고객사
String p01_1010_07 = CommonUtil.getSpecialCheckReturn(com_code,"P01-1010-07","COL01_DATA", request); // 고객사별 부서검색

String st_agree_flag=  CommonUtil.nvl((String) request.getParameter("st_agree_flag"), "");
if(!st_agree_flag.equals("Y")){
		response.sendRedirect("/error/error.do");
		return;
}
if(p01_1010_05 == null){
	p01_1010_05 = "사번";
}else if("".equals(p01_1010_05)){
	p01_1010_05 = "사번";
}
%>
<body>
	<form id="contentForm" name="contentForm" method="post">
			<input type="hidden" id="id_check_flag" name="id_check_flag" value="N" />
			<input type="hidden" name="chkPassword1" id="chkPassword1" value="N" />
			<input type="hidden" name="chkPassword2" id="chkPassword2" value="N" />
			<input type="hidden" id="st_business_cond" name="st_business_cond" value="<%=business_cond%>" />
			<input type="hidden" id="st_ceo_reg_no" name="st_ceo_reg_no" value="" />
			<input type="hidden" id="st_com_code" name="st_com_code" value="<%=com_code %>" />
			<input type="hidden" id="st_role" name="st_role" value="" />
			<input type="hidden" id="st_zip_code" name="st_zip_code" value="" />
			<input type="hidden" id="st_zip_key" name="st_zip_key" value="" />
			<input type="hidden" id="st_address" name="st_address" value="" />
			<input type="hidden" id="st_address_dt" name="st_address_dt" value="" />
			<input type="hidden" id="st_address_eng" name="st_address_eng" value="" />
			<input type="hidden" id="st_country" name="st_country" value="KR" />
			<input type="hidden" id="st_city" name="st_city" value="KRSEL" />
		<div class="wrap">
			<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp"%>
			<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
    <!--컨텐츠-->
    <div class="subcontentsArea">
    	<div class="subbanner" >
        	 
            <div class="subbannerimg"><img src="/resources/images/2016/SB21.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">고객회원사 가입하기</p>
            	<p>KeP서비스 이용을 통해 경쟁력을 높여 보세요</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList04">
            	<ul>
                    <a href="javascript:MovePage_2016('<%=httpurl%>','03', '01');"><li>FAQ</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '02');"><li>업무처리 프로세스</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '01');"><li>신규협력사 가입안내</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '02');"><li  class="subtabOn">회원가입하기</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '03');"><li>계약서류 다운로드</li></a>
                </ul>  
            </div>
        </div>
		<div class="subcontent">
        	<div class="sub04_join">
                <p class="subcontentTit" >로그인정보 등록  </p>
                <p class="imp">*</span> 필수 입력사항 입력해 주세요.</p>
                <table class="TableMemberJoin">
                  <colgroup>
                  <col width="15%" />
                  <col width="30%" />
                  <col width="20%" />
                  <col width="30%" />
                  </colgroup>
                  <tbody>
                    <tr>
                      <th><span class="FontRed">*</span> 아이디</th>
                      <td><input type="text" id="st_user_id" name="st_user_id" title=""  onkeyup="idKeyUp()" maxlength="20" value="" style="width:61%;ime-mode:disabled;"/>
                        <a href="javascript:doAction('idCheck');"><span class="TJoinbtn" title="중복검사">중복확인</span></a></td>
                      <td></td>
                      <td></td>
                    </tr>
                    <tr>
                      <th ><span class="FontRed">*</span> 비밀번호</th>
                      <td><input type="password" id="st_password" name="st_password" title="" maxlength="20" value="" onchange="doAction('pwdCheck1')" style="width:75%;ime-mode:disabled;"/>
                        <font color="#FF0000" title="1. 8자리 이상 사용해야 합니다.&#10;&#13;2. 혼합(영문자+숫자+특수문자) 사용해야 합니다.&#10;&#13;3. 변경주기는 90일 입니다.&#10;&#13;4. 아이디와 동일하게 사용할 수 없습니다."><b>※규정</b></font></td>
                      <th><span class="FontRed">*</span> 비밀번호확인</th>
                      <td><input type="password" id="st_password_confirm" name="st_password_confirm" title="" maxlength="20" value="" onchange="doAction('pwdCheck2')" style="width:98%;ime-mode:disabled;"/></td>
                    </tr>
                    <tr>
                      <th><span class="FontRed">*</span> 이름(국문)</th>
                      <td><input type="text" id="st_user_name_loc" name="st_user_name_loc" title="" maxlength="40" onkeyup="fnCheckInputByte(this, 40);" onchange="fnCheckInputByte(this, 40);" value="" style="width:98%"/></td>
                      <th>이름(영문)</th>
                      <td><input type="text" id="st_user_name_eng" name="st_user_name_eng" title="" maxlength="40" value="" style="width:98%;ime-mode:disabled;"/></td>
                    </tr>
                    <tr>
                      <th><%if(p01_1010_06 == true){%><span class="FontRed">* </span><%}%><%=p01_1010_05%></th>
                      <td><input type="text" id="st_legacy_user_id" name="st_legacy_user_id" maxlength="20" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" value="" value="" style="width:98%"/></td>
                      <th><span class="FontRed">*</span> 사용언어</th>
                      <td><select id="st_lang" name="st_lang" style="width:99%;">
                          <option value="KR">Korean</option>
                          <option value="US">English</option>
                          <option value="CP">Chinese</option>
                          <option value="JP">Japanese</option>
                        </select></td>
                    </tr>
                  </tbody>
                </table>
                <br /><br /><br />
                <p class="subcontentTit" >사용자정보  </p>
                <p class="imp">*</span> 필수 입력사항 입력해 주세요.</p>
                <table class="TableMemberJoin">
                  <colgroup>
                  <col width="15%" />
                  <col width="30%" />
                  <col width="20%" />
                  <col width="30%" />
                  </colgroup>
                  <tbody>
                    <tr>
                      <th><span class="FontRed">*</span> 이메일</th>
                      <td><input type="text" id="st_email" name="st_email" title="" maxlength="100" value="" style="width:98%;ime-mode:disabled;" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);"/>
                      <th><span class="FontRed">*</span> 사용자구분</th>
                      <td><select id="st_user_type"  name="st_user_type" style="width:99%;">
                          <option value="A">Admin사용자</option>
<!-- 협력사 가입 시 관리자로만 선택할 수 있도록(리뉴얼에 승인 절차 없어짐) -->
<%if(!business_cond.equals("협력사")){%>
                          <option value="U" selected>일반사용자</option>
<%}%>
                        </select></td>
                    </tr>
                    <tr>
                      <th><span class="FontRed">*</span> 전화번호</th>
                      <td><input type="text" id="st_phone_number" name="st_phone_number" title=""  maxlength="20" value="" onkeyup="fnPhoneNumberCheck('st_phone_number');" onchange="fnPhoneNumberCheck('st_phone_number');" style="width:98%"/></td>
                      <th><span class="FontRed">*</span> 휴대폰</th>
                      <td><input type="hidden" id="st_mobile_phone" name="st_mobile_phone"  value="" />
                        <input type="text" id="st_mobile_phone1" name="st_mobile_phone1" title="" size="4" maxlength="3" value="" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
                        -
                        <input type="text" id="st_mobile_phone2" name="st_mobile_phone2" title="" size="5" maxlength="4" value="" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
                        -
                        <input type="text" id="st_mobile_phone3" name="st_mobile_phone3" title="" size="6" maxlength="4" value="" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /></td>
                    </tr>
                    <tr>
                      <th>팩스번호</th>
                      <td><input type="text" id=st_fax_number name="st_fax_number" title="" maxlength="20" value="" onkeydown="fnPhoneNumberCheck('st_fax_number');" onchange="fnPhoneNumberCheck('st_fax_number');" style="width:98%"/></td>
                      <td></td>
                      <td></td>
                    </tr>
                    <tr>
						<th>도착지</th>
                        <td colspan="3">
							<input type="hidden" id="st_dely_to_location" name="st_dely_to_location" value="" />
							<input type="text" id="st_dely_text" name="st_dely_text" class="input_type_text" title="" style="width:95%;" maxlength="300"  readonly value="" />
							<a href="javascript:doPop('location', '<%=com_code%>', '');"><img src="/resources/images/btn_search03.gif"></a>
						</td>
                    </tr>
                    <tr>
                      <th ><span class="FontRed">*</span>SMS수신여부</th>
                      <td ><input type="radio" id="sms_recv_flag1" name="sms_recv_flag"  value="Y"  class="noborder"/>
                        &nbsp;수신&nbsp;&nbsp;&nbsp;
                        <input type="radio" id="sms_recv_flag2" name="sms_recv_flag" value="N" class="noborder"/>
                        &nbsp;미수신
                        <input type="hidden" id="st_sms_recv_flag" name="st_sms_recv_flag" value="" class="noborder"/></td>
                      <th ><span class="FontRed">*</span>메일수신여부</th>
                      <td ><input type="radio" id="mail_recv_flag1" name="mail_recv_flag" value="Y"  class="noborder"/>
                        &nbsp;수신&nbsp;&nbsp;&nbsp;
                        <input type="radio" id="mail_recv_flag2" name="mail_recv_flag" value="N" class="noborder"/>
                        &nbsp;미수신
                        <input type="hidden" id="st_mail_recv_flag" name="st_mail_recv_flag"  value="" class="noborder"/></td>
                    </tr>
                  </tbody>
                </table>
                <br /><br /><br />
                <p class="subcontentTit" >회사정보   </p>
                <p class="imp">*</span> 필수 입력사항 입력해 주세요.</p>
                <table class="TableMemberJoin">
                  <colgroup>
                  <col width="15%" />
                  <col width="30%" />
                  <col width="20%" />
                  <col width="30%" />
                  </colgroup>
                  <tbody>
                    <tr>
                      <th><span class="FontRed">*</span> 회사명</th>
                      <td><input type="text" id="st_com_name_loc" name="st_com_name_loc" title=""  maxlength="50" value="<%=com_name%>"  readonly style="width:98%;"/></td>
                      <th><span class="FontRed">*</span> 직급</th>
                      <td><input type="text" id="st_position_text" name="st_position_text" title="" maxlength="50"  value=""  readonly style="width:75%;"/>
                        <input type="hidden" id="st_position" name="st_position" value="" />
                        <a href="javascript:doPop('position', '<%=com_code%>');"><b class="TJoinbtn" title="직급검색">직급조회</b></a></td>
                    </tr>
                    <tr>
                      <th><span class="FontRed">*</span> 부서</th>
                      <td><input type="text" id="st_department_text" name="st_department_text" title=""  maxlength="50" value=""  readonly style="width:75%;"/>
                        <input type="hidden" id="st_department" name="st_department" value="" />
                        <a href="javascript:doPop('dept', '<%=com_code%>');"><b class="TJoinbtn" title="부서조회">부서조회</b></a></td>
                      <th>발주부서</th>
                      <td><input type="text" id="st_purchase_dept_text" name="st_purchase_dept_text" title=""  maxlength="50" value=""  readonly style="width:75%;"/>
                        <input type="hidden" id="st_purchase_dept" name="st_purchase_dept" value="" />
                        <a href="javascript:doPop('purchase_dept', '<%=com_code%>');"><b class="TJoinbtn" title="발주부서조회">부서조회</b></a></td>
                    </tr>
                  </tbody>
                </table>
                <div class="joinBtn" style="margin-top:50px">  <a href="javascript:doAction('save');">등록하기</a> </div> 	
           </div>
        </div>
    </div>
    <!--컨텐츠 끝-->
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainFooter.jsp"%>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
		</div>
	</form>
</body>
<script type="text/javascript">
var popupSel = "";
var st;
var mt;
// 기능함수
function doAction(str) {

	switch (str) {
		case "reload":	// 초기화
			kepReload('contentForm');
			break;
		case "save": // 저장
			if (checkSubmit()) {
				kepAjaxFormCall("/mdam/saveMasterMdAmUserRegList.do","contentForm","save");
			}
			break;
		case "idCheck": // 저장
			if (isEmpty($("#st_user_id").val())) {
				alert("사용자 ID를 입력해 주십시요");
				$("#st_user_id").focus();
				return;
			} else if (kepIsSpecialChar("st_user_id")) {
				alert("사용자 ID는 특수문자를 포함할 수 없습니다.");
				$("#st_user_id").focus();
				return;
			} else if (kepTrim("st_user_id") != $("#st_user_id").val() || containsWhitespace($("#st_user_id").val())){
				alert("사용자 ID는 공백을 포함할 수 없습니다.");
				$("#st_user_id").focus();	
				return ;
			}	else {
				kepAjaxFormCall("/mdam/getMasterMdAmUserRegIDCheck.do","contentForm","idCheck");
			}	
			break;
		case "pwdCheck1":
			if (passwordValidCheck1()) {
				kepAjaxFormCall("/mdam/getMasterMdAmUserRegPwdValidCheck.do","contentForm","pwdCheck1");
			}
			break;
		case "pwdCheck2":
			if (passwordValidCheck2()) {
				kepAjaxFormCall("/mdam/getMasterMdAmUserRegPwdValidCheck.do","contentForm","pwdCheck2");
			}
			break;
	}
}
	

// 팝업함수호출
function doPop(str, val, val2) {
	popupSel = str;
	
	switch (str) {
/* 		case "zipcode": //ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
			openSearchPopup("/common/zipCodeSearchPop.do", "?1=1", "500,666,no");			
			break; */
		case "newzipcode": //우편번호 검색
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");			
			break;
		case "dept":
			openSearchPopup("/common/deptCodeAdminPop.do","?com_code="+val + "&open=Y", "500,500,no");
			break;
		case "position":
			openSearchPopup("/common/getPositionCodePop.do", "?com_code="+val+"&type=C003", "500,420,no");			
			break;
		case "purchase_dept":
			openSearchPopup("/coco/showCommonCoCoOrderDepartmentSearchPop.do","?com_code="+val + "&open=Y", "680,500,no");
			break;
		case "location":
			openSearchPopup("/common/delLocationPop.do", "?com_code=" + val + "&del_code="+val2, "500,500,no");					
			break;
	}
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	switch (popupSel) {
		case "dept":
			$("#st_department").val(code);
			$("#st_department_text").val(text);
			break;
		case "position":
			$("#st_position").val(code);
			$("#st_position_text").val(text);
			break;
		case "purchase_dept":
			$("#st_purchase_dept").val(code);
			$("#st_purchase_dept_text").val(text);
			break;
		case "location":
			$("#st_dely_to_location").val(code);
			$("#st_dely_text").val(text);
			break;
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	if (pMethod == "pwdCheck1") {
		if (sMsg != 'OK') {
			alert(sMsg);
			$("#st_password").val("");
			$("#st_password").focus();
			return;
		} else {
			$("#chkPassword1").val("Y");
			return;
		}
	} else if (pMethod == "pwdCheck2") {
		if (sMsg != 'OK') {
			alert(sMsg);
			$("#st_password").val("");
			$("#st_password").focus();
			return;
		} else {
			$("#chkPassword2").val("Y");
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
			location.href="<%=httpurl%>/mdam/showMasterMdAmMbrcmpyRegEnd_2016.do?type=U";
			return;
		} else {
			if (sMsg == "Err") {
				alert("사용자 등록에 실패 하였습니다\n\n확인한 후 다시 입력 해 주시기 바랍니다.");
			}	else if (sMsg == "dup" ) {
				alert("이미 다른 사용자가 사용중인 ID입니다.\n\n확인한 후 다시 입력 해 주시기 바랍니다.");
				return;
			}
		}
		doAction("reload");
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다. ");
} 

function passwordValidCheck1() {
	$("#chkPassword1").val("N");

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

	if ($("#st_password").val().length == 0) {
		alert("비밀번호가 입력되지 않았습니다. ");
		$("#st_password_confirm").focus(); // 버그로 다른 곳 포커스를 했다가 포커스 지정해야 원하는 곳으로 포커스 됨.
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
		$("#st_password_confirm").focus(); // 버그로 다른 곳 포커스를 했다가 포커스 지정해야 원하는 곳으로 포커스 됨.
		$("#st_password").focus();
		$("#st_password").select();
		return false;
	}

	if ($("#st_password").val().length < chkKorea($("#st_password").val())) {
		alert("비밀번호는 영문으로 입력해 주십시요.");
		$("#st_password_confirm").focus(); // 버그로 다른 곳 포커스를 했다가 포커스 지정해야 원하는 곳으로 포커스 됨.
		$("#st_password").focus();
		return false;
	}

	return true;
}

function passwordValidCheck2() {
	$("#chkPassword2").val("N");

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

	if ($("#st_password").val().length == 0) {
		alert("비밀번호가 입력되지 않았습니다. ");
		$("#st_password_confirm").focus(); // 버그로 다른 곳 포커스를 했다가 포커스 지정해야 원하는 곳으로 포커스 됨.
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
		$("#st_password_confirm").focus(); // 버그로 다른 곳 포커스를 했다가 포커스 지정해야 원하는 곳으로 포커스 됨.
		$("#st_password").focus();
		$("#st_password").select();
		return false;
	}

	if ($("#st_password").val().length < chkKorea($("#st_password").val())) {
		alert("비밀번호는 영문으로 입력해 주십시요.");
		$("#st_password_confirm").focus(); // 버그로 다른 곳 포커스를 했다가 포커스 지정해야 원하는 곳으로 포커스 됨.
		$("#st_password").focus();
		return false;
	}

	if ($("#st_password_confirm").val().length == 0) {
		alert("비밀번호가 입력되지 않았습니다. ");
		$("#st_password").focus(); // 버그로 다른 곳 포커스를 했다가 포커스 지정해야 원하는 곳으로 포커스 됨.
		$("#st_password_confirm").focus();
		return false;
	}

	if (checkSpace($("#st_password_confirm").val()) && $("#st_password_confirm").val() != "") {
		alert("비밀번호에 공백문자은 입력할 수 없습니다.   ");
		$("#st_password_confirm").val("");
		$("#st_password").focus(); // 버그로 다른 곳 포커스를 했다가 포커스 지정해야 원하는 곳으로 포커스 됨.
		$("#st_password_confirm").focus();
		return false;
	}

	if ($("#st_password_confirm").val().length < 8) {
		alert("비밀번호는 8 자리 이상 사용해야 합니다.");
		$("#st_password").focus(); // 버그로 다른 곳 포커스를 했다가 포커스 지정해야 원하는 곳으로 포커스 됨.
		$("#st_password_confirm").focus();
		return false;
	}

	if ($("#st_password_confirm").val().length < chkKorea($("#st_password_confirm").val())) {
		alert("비밀번호는 영문으로 입력해 주십시요.");
		$("#st_password").focus(); // 버그로 다른 곳 포커스를 했다가 포커스 지정해야 원하는 곳으로 포커스 됨.
		$("#st_password_confirm").focus();
		return false;
	}

	if ($("#st_password").val() != $("#st_password_confirm").val()) {
		alert("비밀번호가 일치하지 않습니다.\n다시 한번 입력하시기 바랍니다.");
		$("#st_password").focus(); // 버그로 다른 곳 포커스를 했다가 포커스 지정해야 원하는 곳으로 포커스 됨.
		$("#st_password_confirm").focus();
		return false;
	}

	return true;
}
// 아이디 칸에 키 입력 시  
function idKeyUp(){
	kepToUpper('st_user_id');
	
	$("#id_check_flag").val("N");
}

function checkSubmit() {

	if (isEmpty($("#st_user_id").val())) {
		alert( "사용자 ID를 반드시 입력하세요." );
		$("#st_user_id").val("");
		$("#st_user_id").focus();
		return;
	}
	
	if ($("#st_user_id").val().length < chkKorea($("#st_user_id").val())) {
		alert("사용자 ID를 영문으로 입력해 주십시요.");
		$("#st_user_id").focus();
		return false;
	}
	
	if (kepTrim("st_user_id") != $("#st_user_id").val()){
		alert("사용자 ID는 공백을 포함할 수 없습니다.");
		$("#st_user_id").focus();	
		return false;
	}
	
	if ($("#id_check_flag").val() == "N") {
		alert("사용자 ID 중복 검사를 먼저 해 주십시요");
		return false;
	}

	if ($("#chkPassword1").val() != "Y") {
		doAction("pwdCheck1");
		return false;
	}

	if ($("#chkPassword2").val() != "Y") {
		doAction("pwdCheck2");
		return false;
	}
	
	if (isEmpty($("#st_user_name_loc").val())) {
		alert(" 사용자 이름이 입력되지 않았습니다. ");
		$("#st_user_name_loc").val("");
		$("#st_user_name_loc").focus();
		return false;
	}

	if (isEmpty($("#st_email").val())) {
		alert(" Email 주소가 입력되지 않았습니다.");
		$("#st_email").focus();
		return false;
    }
	
	if (!checkemail("st_email")) {
		return false;
	}
	
	if (isEmpty($("#st_phone_number").val())) {
		alert(" 전화번호가 입력되지 않았습니다.");
		$("#st_phone_number").focus();
		return false;
	}
	
	dial = $("#st_phone_number").val().substring(0,2);
	if(dial == '01'){ <%-- 휴대폰 번호 앞자리 (010 ~ 019) 판별을 위해--%>
		alert(" 전화번호에 휴대폰 번호는 입력하실 수 없습니다.");
		return false;
	}
	
	if (isEmpty($("#st_mobile_phone1").val())) {
		alert(" 휴대폰 번호가 입력되지 않았습니다.");
		$("#st_mobile_phone1").focus();
		return false;
	}
	
	if (isEmpty($("#st_mobile_phone2").val())) {
		alert(" 휴대폰 번호가 입력되지 않았습니다.");
		$("#st_mobile_phone2").focus();
		return false;
	}
	
	if (isEmpty($("#st_mobile_phone3").val())) {
		alert(" 휴대폰 번호가 입력되지 않았습니다.");
		$("#st_mobile_phone3").focus();
		return false;
	}
	
	if ($("#st_mobile_phone1").val().length != 3  || $("#st_mobile_phone2").val().length<3 || $("#st_mobile_phone3").val().length !=4) { 
		alert( "휴대폰 번호를 정확히 입력하세요." );
		$("#st_mobile_phone1").focus();
		return false;
	}

	$("#st_mobile_phone").val($("#st_mobile_phone1").val() + "-" + $("#st_mobile_phone2").val() + "-" + $("#st_mobile_phone3").val());
	
	<%if(p01_1010_06 == true){%>
		if(isEmpty(kepTrim("st_legacy_user_id"))){
			alert("<%=p01_1010_05%>" +"은 필수 값입니다.");
			return false;
		}
	<%}%>
	
	if (kepTrim("st_legacy_user_id") != $("#st_legacy_user_id").val()){
		alert("<%=p01_1010_05%>" +"은 공백을 포함할 수 없습니다.");
		$("#st_legacy_user_id").focus();	
		return false;
	}
	
	if(isEmpty($("#st_department_text").val())) {
		alert("부서를 반드시 선택하세요.");
		return false;
    }

    if(isEmpty($("#st_position_text").val())) {
		alert( "직급을 반드시 선택하세요. ");
		return false;
	}
    
	if(!$("#sms_recv_flag1").is(":checked") && !$("#sms_recv_flag2").is(":checked")) {
		alert("SMS 메세지 수신 여부를 선택 해주세요");
		return false;
	}
	
	if (!$("#mail_recv_flag1").is(":checked") && !$("#mail_recv_flag2").is(":checked")) {
		alert("메일 수신 여부를 선택 해주세요");
		return false;
	}
	
    $("#st_mail_recv_flag").val($("input[name=mail_recv_flag]:checked").val());
    $("#st_sms_recv_flag").val($("input[name=sms_recv_flag]:checked").val());
    $("#st_role").val($("#st_user_type").val() + "+");

	return confirm("현재 사용자 정보를 등록하겠습니까 ?");
}

//document.domain = "koreab2b.com";
</script>
</html>

