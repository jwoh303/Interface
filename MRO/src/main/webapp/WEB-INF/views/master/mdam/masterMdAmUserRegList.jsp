<%--
**********************************************
* 메뉴 : 회원가입>사용자등록
* 화면 : 사용자등록
* 기능 : 
* 프로그램 ID : PG_01_M_014_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-06-24
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
</head>
<%
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), "");
String com_name=  CommonUtil.nvl((String) request.getParameter("com_name"), "");
%>

<body onload="">
<div class="wrap" >
	<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
	<c:set var="jqueryGbn"  value="Y"/>
	<%@ include file="/WEB-INF/views/common/include/mainHeader.jsp" %>
	<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
	<!--내용 시작-->
	<div class="Subwrap">
		<!------------------------------------------------------------------------------------------------left-------------------------------------------------------------------------------------------------------------->
		<c:import charEncoding="utf-8" url="/main/mainLeft.do" >
			<c:param name="subNo" value="None"/>
		</c:import>
		<!------------------------------------------------------------------------------------------------left-------------------------------------------------------------------------------------------------------------->
		<div class="SubCenter" >
			<form name="contentForm" id="contentForm" method="post" >
			<input type="hidden" id="id_check_flag" name="id_check_flag" value="N" />
			<input type="hidden" name="chkPassword" id="chkPassword" value="N" />
			<input type="hidden" id="st_business_cond" name="st_business_cond" value="B" />
			<input type="hidden" id="st_ceo_reg_no" name="st_ceo_reg_no" value="" />
			<input type="hidden" id="st_com_code" name="st_com_code" value="<%=com_code %>" />
			<input type="hidden" id="st_role" name="st_role" value="" />
	
			<div class="CenterVisual_MemberJoin"></div>
			<div class="MentLocation"><img src="/resources/images/main/br_home.gif" alt=""> > 회원가입 > 사용자 등록하기 </div>
			<div class="CenterBody" >
				<h2> 사용자 등록</h2>
				<div class="MemberJoin" >
					<div><span class="FontBlue">Koreab2b.com</span>사이트를 이용하시려면, 먼저 회원사 등록을 하셔야 합니다. KeP는 고객사의 경쟁력 확중에 기여하고 있으며 시장에서도 KeP의 역할을 인정하고 있습니다.</div>
	
					<div class="h50"></div>
					<h3>로그인정보 등록 <span class="h3stext"><span class="FontRed">*</span> 필수 입력사항 입니다.</span></h3>
					<table class="TableMemberJoin">
						<colgroup>
							<col width="130px" />
							<col width="210px" />
							<col width="130px" />
							<col width="210px" />
						</colgroup>
						<tbody>
							<tr>
								<th><span class="FontRed">*</span> 아이디</th>
								<td><input type="text" id="st_user_id" name="st_user_id" title=""  onkeyup="kepToUpper('st_user_id');" maxlength="20" value="" style="width:61%;ime-mode:disabled;"/>
								<a href="javascript:doAction('idCheck');"><span class="Joinbtn_Gray" title="중복검사">중복확인</span></a></td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<th ><span class="FontRed">*</span> 비밀번호</th>
								<td>
									<input type="password" id="st_password" name="st_password" title="" maxlength="20" value="" onchange="doAction('pwdCheck')" style="width:75%;ime-mode:disabled;"/>
									<font color="#FF0000" title=" 1. 8자리 이상 사용해야 합니다.
 2. 혼합(영문자+숫자+특수문자) 사용해야 합니다.
 3. 변경주기는 90일 입니다.
 4. 아이디와 동일하게 사용할수 없습니다."><b>※규정</b></font>
								</td>	
								<th><span class="FontRed">*</span> 비밀번호확인</th>
								<td><input type="password" id="st_password_confirm" name="st_password_confirm" title="" maxlength="20" value="" onchange="doAction('pwdCheck')" style="width:98%;ime-mode:disabled;"/></td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 이름(국문)</th>
								<td><input type="text" id="st_user_name_loc" name="st_user_name_loc" title="" maxlength="40" onkeyup="fnCheckInputByte(this, 40);" onchange="fnCheckInputByte(this, 40);" value="" style="width:98%"/></td>
								<th><span class="FontRed">*</span> 이름(영문)</th>
								<td><input type="text" id="st_user_name_eng" name="st_user_name_eng" title="" maxlength="40" value="" style="width:98%;ime-mode:disabled;"/></td>
							</tr>
							<tr>
								<th>사번</th>
								<td><input type="text" id="st_legacy_user_id" name="st_legacy_user_id" maxlength="20" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" value="" value="" style="width:98%"/></td>
								<th><span class="FontRed">*</span> 사용언어</th>
								<td>
									<select id="st_lang" name="st_lang" style="width:99%;">
										<option value="KR">Korean</option>
										<option value="US">English</option>
										<option value="CP">Chinese</option>
										<option value="JP">Japanese</option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
					
					<div class="h50"></div>
					<h3>사용자정보 <span class="h3stext"><span class="FontRed" >*</span> 필수 입력사항 입니다.</span></h3>
					<table class="TableMemberJoin">
						<colgroup>
							<col width="130px" />
							<col width="210px" />
							<col width="130px" />
							<col width="210px" />
						</colgroup>
						<tbody>
							<tr>
								<th><span class="FontRed">*</span> 이메일</th>
								<td><input type="text" id="st_email" name="st_email" title="" maxlength="100" value="" style="width:98%;ime-mode:disabled;" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);"/>
								<th><span class="FontRed">*</span> 사용자구분</th>
								<td>
									<select id="st_user_type"  name="st_user_type" style="width:99%;">
										<option value="A">Admin사용자</option>
										<option value="U" selected>일반사용자</option>
									</select>
								</td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 전화번호</th>
								<td><input type="text" id="st_phone_number" name="st_phone_number" title=""  maxlength="20" value="" onkeyup="fnPhoneNumberCheck('st_phone_number');" onchange="fnPhoneNumberCheck('st_phone_number');" style="width:98%"/></td>
								<th><span class="FontRed">*</span> 핸드폰</th>
								<td>
									<input type="hidden" id="st_mobile_phone" name="st_mobile_phone"  value="" />
									<input type="text" id="st_mobile_phone1" name="st_mobile_phone1" title="" size="4" maxlength="3" value="" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> -
									<input type="text" id="st_mobile_phone2" name="st_mobile_phone2" title="" size="5" maxlength="4" value="" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> -
									<input type="text" id="st_mobile_phone3" name="st_mobile_phone3" title="" size="6" maxlength="4" value="" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
								</td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 국가</th>
								<td>
									<input type="hidden" id="st_country" name="st_country" value="" />
									<input type="text" id="st_country_name" name="st_country_name"title="" style="width:81%;" value=""  readonly />
									<a href="javascript:doPop('country');"><img src="/resources/images/btn_search03.gif"></a>
								</td>
								<th><span class="FontRed">*</span> 지역</th>
								<td>
									<input type="hidden" id="st_city" name="st_city" value="" />
									<input type="text" id="st_city_name" name="st_city_name"title="" style="width:81%;" value="" readonly  />
									<a href="javascript:doPop('city');"><img src="/resources/images/btn_search03.gif"></a>
								</td>
							</tr>
							<tr>
								<th>팩스번호</th>
								<td><input type="text" id=st_fax_number name="st_fax_number" title="" maxlength="20" value="" onkeydown="fnPhoneNumberCheck('st_fax_number');" onchange="fnPhoneNumberCheck('st_fax_number');" style="width:98%"/></td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<th ><span class="FontRed">*</span> 주소</th>
								<td colspan="3">
									<input type="text" id="st_zip_code" name="st_zip_code" title="" style="width:21%;" maxlength="10"  readonly  value="" />
									<input type="hidden" id="st_zip_key" name="st_zip_key" value=""/>
									<input type="text" id="st_address" name="st_address" title="" style="width:60%;" maxlength="100" readonly value="" />
									<input type="hidden" id="st_address_eng" name="st_address_eng"title="" style="width:60%;" maxlength="50" value="" />
									<!-- <a href="javascript:doPop('zipcode');"><span class="Joinbtn_Gray" title="우편번호">우편번호찾기</span></a> -->		<!-- ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 -->
									<a href="javascript:doPop('newzipcode');"><span class="Joinbtn_Gray" title="우편번호">우편번호찾기</span></a>
								</td>
							</tr>
							<tr>
								<th>상세 주소</th>
								<td colspan="3"><input type="text" id="st_address_dt" name="st_address_dt" title="" maxlength="100" value="" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" style="width:99%"/></td>
							</tr>
						</tbody>
					</table>

					<div class="h50"></div>
					<h3>회사정보 <span class="h3stext"><span class="FontRed" >*</span> 필수 입력사항 입니다.</span></h3>
					<table class="TableMemberJoin">
						<colgroup>
							<col width="130px" />
							<col width="210px" />
							<col width="130px" />
							<col width="210px" />
						</colgroup>
						<tbody>
							<tr>
								<th><span class="FontRed">*</span> 회사명</th>
								<td><input type="text" id="st_com_name_loc" name="st_com_name_loc" title=""  maxlength="50" value="<%=com_name%>" readonly style="width:98%;"/></td>
								<th><span class="FontRed">*</span> 직급</th>
								<td>
									<input type="text" id="st_position_text" name="st_position_text" title="" maxlength="50"  value=""  readonly style="width:81%;"/>
									<input type="hidden" id="st_position" name="st_position" value="" />
									<a href="javascript:doPop('position', '<%=com_code%>');"><img src="/resources/images/btn_search03.gif"></a>
								</td>
							</tr>
							<tr>
								<th><span class="FontRed">*</span> 부서</th>
								<td>
									<input type="text" id="st_department_text" name="st_department_text" title=""  maxlength="50" value=""  readonly style="width:81%;"/>
									<input type="hidden" id="st_department" name="st_department" value="" />
									<a href="javascript:doPop('dept', '<%=com_code%>');"><img src="/resources/images/btn_search03.gif"></a>
								</td>
								<th>발주부서</th>
								<td>
									<input type="text" id="st_purchase_dept_text" name="st_purchase_dept_text" title=""  maxlength="50" value=""  readonly style="width:81%;"/>
									<input type="hidden" id="st_purchase_dept" name="st_purchase_dept" value="" />
									<a href="javascript:doPop('purchase_dept', '<%=com_code%>');"><img src="/resources/images/btn_search03.gif"></a>
								</td>
							</tr>
							<tr>
								<th >SMS수신여부</th>
								<td >
									<input type="radio" id="sms_recv_flag1" name="sms_recv_flag"  value="Y" checked="checked" class="noborder"/> &nbsp;수신&nbsp;&nbsp;&nbsp;
									<input type="radio" id="sms_recv_flag2" name="sms_recv_flag" value="N" class="noborder"/> &nbsp;미수신
									<input type="hidden" id="st_sms_recv_flag" name="st_sms_recv_flag" value="" class="noborder"/>
								</td>
								<th >메일수신여부</th>
								<td >
									<input type="radio" id="mail_recv_flag1" name="mail_recv_flag" value="Y" checked="checked" class="noborder"/> &nbsp;수신&nbsp;&nbsp;&nbsp;
									<input type="radio" id="mail_recv_flag2" name="mail_recv_flag" value="N" class="noborder"/> &nbsp;미수신
									<input type="hidden" id="st_mail_recv_flag" name="st_mail_recv_flag"  value="" class="noborder"/>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="h50"></div>
					<div class="JoinBtnArea">
						<a href="javascript:doAction('save');"><span class="BtnBlue">등록하기</span></a>
						<a href="javascript:doAction('reload');"><span class="BtnGray">취소하기</span></a>
					</div>
					<div class="h50"></div>
				</div>
			</div>
			</form>
		</div> <!--SubCenter-->
	</div> <!--Subwrap-->
	<!--내용 종료-->	
	
	<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	<%@ include file="/WEB-INF/views/common/include/mainFooter.jsp" %>
	<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
</div>
</body>
</html>
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
			} else {
				kepAjaxFormCall("/mdam/getMasterMdAmUserRegIDCheck.do","contentForm","idCheck");
			}	
			break;
		case "pwdCheck":
			if (passwordValidCheck()) {
				kepAjaxFormCall("/mdam/getMasterMdAmUserRegPwdValidCheck.do","contentForm","pwdCheck");
			}
			break;
	}
}
	

// 팝업함수호출
function doPop(str, val) {
	popupSel = str;
	
	switch (str) {
		/* case "zipcode": //우편번호 검색	ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
			openSearchPopup("/common/zipCodeSearchPop.do", "?1=1", "500,666,no");			
			break; */
		case "newzipcode": //우편번호 검색
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");			
			break;
		case "country":
			openSearchPopup("/common/countryCodePop.do", "?1=1", "500,500,no");			
			break;
		case "city":
			openSearchPopup("/common/cityCodePop.do", "?1=1", "500,500,no");			
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
	}
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	switch (popupSel) {
		case "zipcode": //우편번호 검색
			$("#st_zip_code").val(code);
			$("#st_address").val(text);
			break;
		case "country":
			$("#st_country").val(code);
			$("#st_country_name").val(text);
			break;
		case "city":
			$("#st_city").val(code);
			$("#st_city_name").val(text);
			break;
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
	}
}
/* ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
function setZipPopupReturn(str_zipcode, str_zip_key, str_sido, str_gugun, str_roadNm, str_buildingNo, str_buildingName, str_dong) {
	$("#st_zip_code").val(str_zipcode);
	$("#st_zip_key").val(str_zip_key);
	$("#st_address").val(str_sido + " " + str_gugun + " " + str_roadNm + " " + str_buildingNo);
	$("#st_address_dt").val(str_buildingName);
}
 */

function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
	$("#st_zip_code").val(zipNo.replace(/[^0-9]/gi, ''));
	$("#st_zip_key").val(bdMgtSn);
	$("#st_address").val(roadAddrPart1 + " " + roadAddrPart2);
	$("#st_address_dt").val(addrDetail);
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response) {
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
		} else {
			alert("이미 사용하고 있는 ID 입니다. 다른 ID를 입력하세요.");
			$("#id_check_flag").val("N");
			$("#st_user_id").val("");
			$("#st_user_id").focus();
			return;
		}
	} else if (pMethod == "save") {
		if (sMsg == "OK") {
			location.href="<%=httpurl%>/mdam/showMasterMdAmMbrcmpyRegEnd.do?type=U";
			//alert("사용자 등록이 완료 되었습니다.");
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

	if ($("#st_password_confirm").val().length == 0) {
		alert("비밀번호가 입력되지 않았습니다. ");
		$("#st_password_confirm").focus();
		return false;
	}

	if (checkSpace($("#st_password_confirm").val()) && $("#st_password_confirm").val() != "") {
		alert("비밀번호에 공백문자은 입력할 수 없습니다.   ");
		$("#st_password_confirm").val("");
		$("#st_password_confirm").focus();
		return false;
	}

	if ($("#st_password_confirm").val().length < 8) {
		alert("비밀번호는 8 자리 이상 사용해야 합니다.");
		$("#st_password_confirm").focus();
		return false;
	}

	if ($("#st_password_confirm").val().length < chkKorea($("#st_password_confirm").val())) {
		alert("비밀번호는 영문으로 입력해 주십시요.");
		$("#st_password_confirm").focus();
		return false;
	}

	if ($("#st_password").val() != $("#st_password_confirm").val()) {
		alert("비밀번호가 일치하지 않습니다.\n다시 한번 입력하시기 바랍니다.");
		$("#st_password").focus();
		return false;
	}

	return true;
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
	
	if ($("#id_check_flag").val() == "N") {
		alert("사용자 ID 중복 검사를 먼저 해 주십시요");
		return false;
	}

	if ($("#chkPassword").val() != "Y") {
		doAction("pwdCheck");
		return false;
	}

	if (isEmpty($("#st_user_name_loc").val())) {
		alert(" 사용자 이름이 입력되지 않았습니다. ");
		$("#st_user_name_loc").val("");
		$("#st_user_name_loc").focus();
		return false;
	}
	
	if (isEmpty($("#st_user_name_eng").val())) {
		alert(" 사용자 이름(영문)이 입력되지 않았습니다. ");
		$("#st_user_name_eng").val("");
		$("#st_user_name_eng").focus();
		return false;
	}
	
	if (!isEmpty($("#st_user_name_eng").val()) && $("#st_user_name_eng").val().length < chkKorea($("#st_user_name_eng").val())) {
		alert("사용자 이름(영문)을 영문으로 입력해 주십시요.");
		$("#st_user_name_eng").val("");
		$("#st_user_name_eng").focus();
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
	
	if (isEmpty($("#st_mobile_phone1").val())) {
		alert(" 핸드폰 번호가 입력되지 않았습니다.");
		$("#st_mobile_phone1").focus();
		return false;
	}
	
	if (isEmpty($("#st_mobile_phone2").val())) {
		alert(" 핸드폰 번호가 입력되지 않았습니다.");
		$("#st_mobile_phone2").focus();
		return false;
	}
	
	if (isEmpty($("#st_mobile_phone3").val())) {
		alert(" 핸드폰 번호가 입력되지 않았습니다.");
		$("#st_mobile_phone3").focus();
		return false;
	}
	
	if ($("#st_mobile_phone1").val().length != 3  || $("#st_mobile_phone2").val().length<3 || $("#st_mobile_phone3").val().length !=4) { 
		alert( "핸드폰 번호를 정확히 입력하세요." );
		$("#st_mobile_phone1").focus();
	}

	$("#st_mobile_phone").val($("#st_mobile_phone1").val() + "-" + $("#st_mobile_phone2").val() + "-" + $("#st_mobile_phone3").val());
	
	if (isEmpty($("#st_country").val())) {
		alert(" 국가가 선택되지 않았습니다.");
		$("#st_country_name").focus();
		return false;
	}
	
	if (isEmpty($("#st_city").val())) {
		alert(" 지역이 선택되지 않았습니다.");
		$("#st_city_name").focus();
		return false;
	}

	if (isEmpty($("#st_zip_code").val())) {
		alert(" 우편 번호가 입력되지 않았습니다.");
		$("#st_zip_code").focus();
		return false;
	}
	
	 if (isEmpty($("#st_zip_key").val())) {
		alert("도로명 주소로 변경 바랍니다.");
		$("#st_zip_code").focus();
		return false;
    }

	if (isEmpty($("#st_address").val())) {
        alert(" 사용자 주소가 입력되지 않았습니다.");
		$("#st_address").focus();
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
    
    $("#st_mail_recv_flag").val($("input[name=mail_recv_flag]:checked").val());
    $("#st_sms_recv_flag").val($("input[name=sms_recv_flag]:checked").val());
    $("#st_role").val($("#st_user_type").val() + "+");

	return confirm("현재 사용자 정보를 등록하겠습니까 ?");
}
</script>
