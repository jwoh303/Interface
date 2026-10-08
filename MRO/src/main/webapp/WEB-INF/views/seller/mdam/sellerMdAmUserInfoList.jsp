<%--
**********************************************
* 메뉴 : 회원사관리>HOME>개인정보
* 화면 : 사용자등록요청접수
* 기능 : 
* 프로그램 ID : PG_01_A_005_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-06-23
**********************************************
--%>

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

//String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());

String com_code=  CommonUtil.nvl((String)_sessionInfo.getComCode());
String user_type = CommonUtil.nvl((String)_sessionInfo.getUserType());

String moveToMaster = CommonUtil.nvl((String) request.getParameter("moveToMaster"),""); // 조회조건
String test = CommonUtil.nvl((String) request.getParameter("test"),""); // 조회조건
Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}
%>
<script type="text/javascript">
<!--

function kep_onload_view() {
	<% if (_dataList==null || _dataList.size()==0) { %>
	kepSearch();
	<% } %>
}

function kepSearch()
{  
	$('#searchForm').attr("action", "/mdam/getSellerMdAmUserInfoList.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) {
		kepSearch();
	}
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
		case "search":			//조회
			kepSearch();
			break;
		case "save":				// 저장ssl 적용
			if (checkSubmit()) {
				kepAjaxFormCall("/mdam/saveSellerMdAmUserInfoList.do","contentForm", str);
			}
			break;
		case "pwdValidCheck":
			if (passwordValidCheck()) {
				kepAjaxFormCall("/mdam/pwdValidCheckSellerMdAmUserInfoList.do", "contentForm", str);
			}
			break;
		case "pwdSave":
		    if ($("#chkPassword").val() != "Y") {
		    	doAction("pwdValidCheck");
		    	return;
		    }

			break;	
	}
}

//팝업함수호출
function doPop(str, val) {
	popupSel = str;
	
	switch (str) {
		/* case "zipcode": //우편번호 검색	ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
			openSearchPopup("/common/zipCodeSearchPop.do", "?1=1", "500,666,no");			
			break; */
		case "newzipcode":	//우편번호 검색
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");			
			break;
		case "dept":
			openSearchPopup("/common/deptCodeAdminPop.do", "?com_code="+val+"&open=Y", "500,500,no");			
			break;
		case "position":
			openSearchPopup("/common/getPositionCodePop.do", "?com_code="+val+"&type=C003", "500,420,no");			
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	//팝업 조회후 해당 항목에 값을 셋팅
	
	switch (popupSel) {
		case "dept":
			$("#st_department").val(code);
			$("#st_department_text").val(text);
			break;
		case "position":
			$("#st_position").val(code);
			$("#st_position_text").val(text);
			break;
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var msg = response.msg;
	if (pMethod == "pwdValidCheck") {
		if (msg != 'OK') {
			alert(msg);
			$("#st_password").val("");
			$("#st_password").focus();
			return;
		} else {
			$("#chkPassword").val("Y");
		    if(confirm("비밀번호를 수정 하시겠습니까?")){
		    	kepAjaxFormCall("/mdam/saveSellerMdAmUsePwd.do","contentForm", "pwdSave");	
		    	return;
		    }
		}
	} else if (pMethod == "save") {
		if (msg == 'OK') {
			alert("사용자 정보 수정이 완료되었습니다.");
			// 처리후 재조회
        	doAction("search");
		} else if (msg == "ERR") {
			alert("사용자 정보 수정이 실패 하였습니다.\n다시 확인하여 주십시요!");
            return;
		} else {
			alert(msg);
			return;
		}
	}else if(pMethod == "pwdSave"){
		if (msg == 'OK') {
			alert("비밀번호 변경이 완료되었습니다.");
			// 처리후 재조회
        	doAction("search");
		} else if (msg == "ERR") {
			alert("비밀번호 변경이 실패 하였습니다.\n다시 확인하여 주십시요!");
            return;
		} else if (msg == "ERR_MATCH"){
			alert("현재 비밀번호가 일치하지 않습니다.");
			$("#st_password_present").focus();
			return;
		} else {
			alert(msg);
			return;
		}		
	}
}

function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
  
}

function checkSubmit() {

	if (isEmpty($("#st_user_name_loc").val())) {
		alert(" 사용자 이름이 입력되지 않았습니다. ");
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
	
// 	if ($("#st_user_type").val() == "U" &&  $("#change_user_type").val() == "A") {
//         alert("사용자 구분 변경시에는 \n(일반사용자->Admin사용자)\n운영자의 승인 후에 반영됩니다.   ");
// 	}
	
	
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
	}

	$("#st_mobile_phone").val($("#st_mobile_phone1").val() + "-" + $("#st_mobile_phone2").val() + "-" + $("#st_mobile_phone3").val());  
	

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
	
/* 부서 체크 생략 20180730 HSJ     
	if(isEmpty($("#st_department_text").val())) {
		alert(" 부서가 입력되지 않았습니다.");
		return false;
    }
*/
    if(isEmpty($("#st_position_text").val())) {
		alert( "직급이 입력되지 않았습니다. ");
		return false;
	}
    
    $("#st_mail_recv_flag").val($("input[name=mail_recv_flag]:checked").val());
    $("#st_two_factor_flag").val($("input[name=two_factor_flag]:checked").val());
     
     return confirm(" 사용자 정보를 수정 하시겠습니까?");
}

function passwordValidCheck() {
	$("#chkPassword").val("N");
	
	if ($("#st_password_present").val().length == 0) {
		alert("현재 비밀번호가 입력되지 않았습니다. ");
		$("#st_password_present").focus();
		return false;
	}
	
	if ($("#st_password").val().length == 0) {
		alert("비밀번호가 입력되지 않았습니다. ");
		$("#st_password").focus();
		return false;
	}
    
	if (checkSpace($("#st_password").val()) && $("#st_password").val() !="") {
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

	if ( $("#st_password").val().length < chkKorea($("#st_password").val())) {
		alert("비밀번호는 영문으로 입력해 주십시요.");
		$("#st_password").focus();
		return false;
	}
	
	if ($("#st_password_confirm").val().length == 0) {
		alert("비밀번호가 입력되지 않았습니다. ");
		$("#st_password_confirm").focus();
		return false;
	}
	
	if (checkSpace($("#st_password_confirm").val()) && $("#st_password_confirm").val() !="") {
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
	
	if ( $("#st_password_confirm").val().length < chkKorea($("#st_password_confirm").val())) {
		alert("비밀번호는 영문으로 입력해 주십시요.");
		$("#st_password_confirm").focus();
		return false;
	}
	
	if ( $("#st_password").val() != $("#st_password_confirm").val()) {
		alert("비밀번호가 일치하지 않습니다.\n다시 한번 입력하시기 바랍니다.");
		$("#st_password").focus();
		return false;
	}

	return true;
}

 //-->
</script>
<body onload="kep_onload_view()">
<!-- 메뉴 S --> 
<%if(!"Y".equals(moveToMaster) ){%>
<div id="wrapper"> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>
	<div id="container2" style="margin-right: 20px;">
	<!-- 메뉴 E -->
	<!--내용 시작-->
	<div id="ContArea">
		<h3>개인정보</h3>
<%} %>
<%if("Y".equals(moveToMaster) ){%>
<div id="popWrapper" style="height:664px;">
   	<div id="popHeader">
       	<h1 class="title">개인정보</h1>
           <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
      </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
<%} %>

	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="${param.upperId}"/>    	
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	    <input type="hidden" id="moveToMaster"  name="moveToMaster" value="<%=moveToMaster%>">
	</form>
	<form id="contentForm" name="contentForm" method="post" onsubmit="return false;">
	<!-- 공통 -->
	<input type="hidden" name="st_com_code" id="st_com_code"  value="<%=com_code%>">
	<input type="hidden" id="st_zip_code" name="st_zip_code" value="" />
	<input type="hidden" id="st_zip_key" name="st_zip_key" value="" />
	<input type="hidden" id="st_address" name="st_address" value="" />
	<input type="hidden" id="st_address_dt" name="st_address_dt" value="" />
	<input type="hidden" id="st_address_eng" name="st_address_eng" value="" />  	
	<input type="hidden" id="st_country_code" name="st_country_code" value="KR" />
	<input type="hidden" id="st_city_code" name="st_city_code" value="KRSEL" /> 	
		<% if (_rowData != null) {  %>
         <p style="font-weight:bold; padding-top: 40px;">[LOG IN 정보]</P>
       	<table  class="cont_t_list06" style="width:100%;">
               <caption>LOG IN 정보</caption>
               <colgroup>
                   <col width="120px" />
                   <col width="32%" />
                   <col width="120px" />
                   <col width="32%" />
               </colgroup>
               <tbody>
				<tr>
					<th scope="row">ID</th>
                       <td>
                       	<%=CommonUtil.nvl(_rowData.get("USER_ID"))%>
                       	<input type="hidden" id="st_com_code" name="st_com_code" value="<%=CommonUtil.nvl(_rowData.get("COM_CODE"))%>" />
                       </td>
					<th scope="row" class="star">현재 PASSWORD</th>
						<td><input type="password" id="st_password_present" name="st_password_present" class="input_type_text" title=""  maxlength="24" style="width:80%; ime-mode:disabled;" value="" /></td>
				</tr>
                   <tr>
                       <th scope="row" class="star">PASSWORD</th>
                     	<td>
                     		<input type="hidden" name="chkPassword" id="chkPassword"  value="<%=CommonUtil.nvl(_rowData.get("CHKPASSWORD"))%>" />
                     		<input type="password" id="st_password" name="st_password" class="input_type_text" title=""  maxlength="24" style="width:70%; ime-mode:disabled;" value="<%=CommonUtil.nvl(_rowData.get("PASSWORD"))%>" />&nbsp;&nbsp;&nbsp;
	                      	<font color="#FF0000" title=" 1. 8자리 이상 사용해야 합니다.
2. 혼합(영문자+숫자+특수문자) 사용해야 합니다.
3. 변경주기는 90일 입니다.
4. 아이디와 동일하게 사용할수 없습니다."><b>※규정</b></font>
	                      	</td>
	                        <th scope="row" class="star">PASSWORD 확인</th>
	                      	<td><input type="password" id="st_password_confirm" name="st_password_confirm" class="input_type_text" title=""  maxlength="24" style="width:80%; ime-mode:disabled;" value="<%=CommonUtil.nvl(_rowData.get("PASSWORD"))%>" /></td>
                   </tr>
                   <tr>
                       <th scope="row" class="star">이름(국문)</th>
                     	<td><input type="text" id="st_user_name_loc" name="st_user_name_loc" class="input_type_text" title=""  maxlength="40" style="width:80%;" onkeyup="fnCheckInputByte(this, 40);" onchange="fnCheckInputByte(this, 40);" value="<%=CommonUtil.nvl(_rowData.get("USER_NAME_LOC"))%>" /></td>
                       <th scope="row">이름(영문)</th>
                     	<td><input type="text" id="st_user_name_eng" name="st_user_name_eng" class="input_type_text" title="" style="width:80%; ime-mode:disabled;" maxlength="40"  value="<%=CommonUtil.nvl(_rowData.get("USER_NAME_ENG"))%>" /></td>
                   </tr>
                   <tr>
                       <th scope="row" class="star">사용언어</th>
                     	<td>
                     		<select id="st_lang" name="st_lang">
				              <option value="KR" <%=CommonUtil.nvl(_rowData.get("LANG")).equals("KR")?"selected":""%>>Korean</option>
				              <option value="US" <%=CommonUtil.nvl(_rowData.get("LANG")).equals("US")?"selected":""%>>English</option>
				              <option value="CP" <%=CommonUtil.nvl(_rowData.get("LANG")).equals("CP")?"selected":""%>>Chinese</option>
				              <option value="JP" <%=CommonUtil.nvl(_rowData.get("LANG")).equals("JP")?"selected":""%>>Japanese</option>
				            </select>
                     	</td>
                       <th scope="row">메일수신여부</th>
                     	<td>
                     		<input type="radio" class="Noborder" id="mail_recv_flag1" name="mail_recv_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("MAIL_RECV_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;받겠습니다.&nbsp;&nbsp;&nbsp;
                      		<input type="radio" class="Noborder" id="mail_recv_flag2" name="mail_recv_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("MAIL_RECV_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;받지않습니다.
                      		<input type="hidden" id="st_mail_recv_flag" name="st_mail_recv_flag"  value="<%=CommonUtil.nvl(_rowData.get("MAIL_RECV_FLAG"))%>" />
                      	</td>
                   </tr>
<%if("A".equals(user_type)){%>
					<tr>
						<th scope="row">추가인증 여부(로그인)</th>
                     	<td colspan="3">
                     		<input type="radio" class="Noborder" id="two_factor_flag1" name="two_factor_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("TWO_FACTOR_YN")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;사용&nbsp;&nbsp;&nbsp;
                      		<input type="radio" class="Noborder" id="two_factor_flag2" name="two_factor_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("TWO_FACTOR_YN")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;미사용
                     	</td>
					</tr>
<%}%>
					<input type="hidden" id="st_two_factor_flag" name="st_two_factor_flag"  value="<%=CommonUtil.nvl(_rowData.get("TWO_FACTOR_YN"))%>" />
					<input type="hidden" id="st_old_two_factor_flag" name="st_old_two_factor_flag"  value="<%=CommonUtil.nvl(_rowData.get("TWO_FACTOR_YN"))%>" />
			</tbody>
		</table>	

		<p class="pt20" style="font-weight:bold;">[USER 정보]</P>
       	<table  class="cont_t_list06" style="width:100%;">
               <caption>USER 정보</caption>
               <colgroup>
                   <col width="120px" />
                   <col width="32%" />
                   <col width="120px" />
                   <col width="32%" />
               </colgroup>
               <tbody>
               	<tr>
                       <th scope="row" class="star">E-mail</th>
                     	<td><input type="text" id="st_email" name="st_email"class="input_type_text" title="" style="width:80%;" maxlength="50" value="<%=CommonUtil.nvl2(_rowData.get("EMAIL"),"")%>" /> </td>
                       <th scope="row" class="star">사용자구분</th>
                     	<td>
                     		<%=CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("U") ? "일반사용자" : (CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("A") ? "Admin사용자" : "운영자")%>&nbsp; ⇒ &nbsp;
                     		<input type="hidden" id="st_user_type" name="st_user_type" value="<%=CommonUtil.nvl(_rowData.get("USER_TYPE"))%>" />
                     		<select id="change_user_type"  name="change_user_type" >
							<% if(CommonUtil.nvl(_rowData.get("CHANGE_USER_TYPE")).equals("M")) { %>
							<option <%=CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("M")?"selected":""%> value="M">운영자</option>
							<% } %>
							<option <%=CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("A")?"selected":""%> value="A">Admin사용자</option>
							<option <%=CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("U")?"selected":""%> value="U">일반사용자</option>
						</select>
                     	</td>
                   </tr>
				
				<tr>
                       <th scope="row" class="star">휴대폰</th>
                     	<td colspan="3">
                     	<% 
                     	String _mobilePhone1 = "";
                			String _mobilePhone2 = "";
                			String _mobilePhone3 = "";	
                     	if (!CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).equals("")) {
                     		_mobilePhone1 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[0];
                      		_mobilePhone2 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[1];
                      		_mobilePhone3 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[2];
                     	}
                     	%>
                     		<input type="hidden" id="st_mobile_phone" name="st_mobile_phone"  value="<%=CommonUtil.nvl(_rowData.get("MOBILE_PHONE"))%>" />
                     		<input type="text" id="st_mobile_phone1" name="st_mobile_phone1" class="input_type_text" title="" style="width:40px;" maxlength="3" value="<%=_mobilePhone1%>" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> -
                     		<input type="text" id="st_mobile_phone2" name="st_mobile_phone2" class="input_type_text" title="" style="width:50px;" maxlength="4" value="<%=_mobilePhone2%>" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> -
                     		<input type="text" id="st_mobile_phone3" name="st_mobile_phone3" class="input_type_text" title="" style="width:50px;" maxlength="4" value="<%=_mobilePhone3%>" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
                      	</td>
                   </tr>
                   <tr>
                        <th scope="row" class="star">전화번호</th>
					<%if(com_code.equals("KRKORE0001")){%>
                        <td><input type="hidden" id="st_phone_number" name="st_phone_number" value="<%=CommonUtil.nvl(_rowData.get("PHONE_NUMBER")) %>"/><%=CommonUtil.nvl(_rowData.get("PHONE_NUMBER"))%></td>
					<%}else{%>
                     	<td><input type="text" id="st_phone_number" name="st_phone_number" class="input_type_text" title="" style="width:80%;" maxlength="30" value="<%=CommonUtil.nvl(_rowData.get("PHONE_NUMBER")) %>" onkeyup="fnPhoneNumberCheck('st_phone_number');" onchange="fnPhoneNumberCheck('st_phone_number');"/></td>
                    <%}%>
                     	<th scope="row">FAX</th>
                     	<td><input type="text" id="st_fax_number" name="st_fax_number" class="input_type_text" title="" style="width:80%;" maxlength="30" value="<%=CommonUtil.nvl(_rowData.get("FAX_NUMBER")) %>"  onkeyup="fnPhoneNumberCheck('st_fax_number');" onchange="fnPhoneNumberCheck('st_fax_number');"/></td>
                   </tr>
			</tbody>
		</table>	

		<p class="pt20" style="font-weight:bold;">[회사정보]</P>
       	<table  class="cont_t_list06" style="width:100%;">
               <caption>회사정보</caption>
               <colgroup>
                   <col width="120px" />
                   <col width="32%" />
                   <col width="120px" />
                   <col width="32%" />
               </colgroup>
               <tbody>
					<tr>
                       <th scope="row">회사명</th>
                     	<td><%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC"))%></td>
                     	<th scope="row">사업자번호</th>
                     	<td><%=CommonUtil.nvl(_rowData.get("IRS_NO"))%></td>
                   </tr>
                   <tr>
                       <th>부서</th>
                     	<td>
                     	<%if(com_code.equals("KRKORE0001")){%>
                     		<%=CommonUtil.nvl(_rowData.get("DEPARTMENT_TEXT"))%>
                     	<%}else{%>
                     		<input type="text" id="st_department_text" name="st_department_text" class="input_type_text" title=""  maxlength="50" style="width:80%;"  value="<%=CommonUtil.nvl(_rowData.get("DEPARTMENT_TEXT")) %>"  readonly/>
                     		<%if("A".equals(user_type)){%>
                     			<a href="javascript:doPop('dept', '<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>');"><img src="/resources/images/btn_search03.gif"></a>
                     		<% } %>
                     	<%}%>
                     		<input type="hidden" id="st_department" name="st_department" value="<%=CommonUtil.nvl(_rowData.get("DEPARTMENT")) %>" />
                     	</td>
                     	<th scope="row"  class="star">직급</th>
                     	<td>
                     		<input type="text" id="st_position_text" name="st_position_text" class="input_type_text" title="" maxlength="50"  style="width:80%;"  value="<%=CommonUtil.nvl(_rowData.get("POSITION_TEXT")) %>"  readonly/>
                     		<input type="hidden" id="st_position" name="st_position" value="<%=CommonUtil.nvl(_rowData.get("POSITION")) %>" />
                     		<a href="javascript:doPop('position', '<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>');"><img src="/resources/images/btn_search03.gif"></a>
                     	</td>
                   </tr>
			</tbody>
		</table>	  
		<% } %>

		<!-- 버튼영역 -->
		<div class="btnArea mt10 mb05">
			<div class="fr">
				<span class="btn_06">
					<a href="javascript:doAction('pwdValidCheck');">비밀번호변경</a>
				</span>
				<span class="btn_04">
					<a href="javascript:doAction('save');">저장</a>
				</span>	
            </div>
        </div>
</form>

<form name="processForm" id="processForm" method="post">	
	<div id="process">
	</div>
</form>
</div>
</div>
<!--내용 종료-->	                 
<%if(!"Y".equals(moveToMaster) ){%>
</div>
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>   
</div>
<%} %>
</body>
</html>
