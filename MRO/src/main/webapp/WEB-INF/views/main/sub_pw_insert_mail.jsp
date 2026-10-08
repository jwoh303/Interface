<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/koreab2b_base.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script type="text/javascript" src="/resources/js/kep_common.js"></script>
<%
String userId =CommonUtil.nvl((String)request.getAttribute("session_st_gj_user_id"),""); // 사용자ID
String gw_no =CommonUtil.nvl((String)request.getAttribute("session_st_gw_no"),""); // 결재번호
String gj_type =CommonUtil.nvl((String)request.getAttribute("session_st_gj_type"),""); // 결재방법
String password_type =CommonUtil.nvl((String)request.getAttribute("session_st_password_type"),""); // 비밀번호 종류
String sslurl2 = CommonUtil.getSslURL(request, "https");
String flag = CommonUtil.nvl((String)request.getAttribute("flag"),"");
String flag_text = "";
if(gj_type.equals("APRV")){
	flag_text = "승인";
}else{
	flag_text = "반려";
}
%>
<script type="text/javascript">
function actionLogin() {
<%if("S".equals(password_type)){%>
	if(document.loginForm.oldPwdCheck.value == "N" || document.loginForm.password_new.value == "" || document.loginForm.password_confirm.value == ""){
		alert("비밀번호를 변경하여 주십시오.");
		return;	
	}
	document.loginForm.password_old.value = document.loginForm.password.value;
<%}%>
	if (document.loginForm.userId.value == "") {
		alert("koreab2b 가입정보가 없습니다.");
		return;
	} else if (document.loginForm.password.value == "") {
		alert("비밀번호를 입력하세요");
		document.loginForm.password.focus();
		return;
	} else {
		$('#loginForm').attr("method", "post");
	    $('#loginForm').attr("action", "/login/getIdValidCheck.do");
	    $('#loginForm').submit();
	}
}
function kepEnter() {
	if (event.keyCode == 13) {
		actionLogin();
	}
}

function kep_onload_view(){
<%
	if (flag.equals("")){
%>
		document.loginForm.password.focus();
<%
	}else if(flag.equals("S")){
%>
		alert("승인되지 않은 ID입니다.\n관리자에게 문의 바랍니다.");
		document.loginForm.password.focus();
<%
	}else if(flag.equals("A")){
%>
		alert("관리자권한 승인 거절된 ID입니다.\n관리자에게 문의 바랍니다.");
		document.loginForm.password.focus();
<%
	}else if(flag.equals("P")){
%>
		alert("등록된 패스워드와 일치하지 않습니다.");
		document.loginForm.password.focus();
<%
	}else if(flag.equals("N")){
%>
		alert("결재 대상자가 아닙니다.");
		this.close();
<%
	}else if(flag.equals("G")){
%>
		alert("이미 처리된 결재건입니다.");
		this.close();
<%
	}else if(flag.equals("E")){
%>
		alert("결재 처리 중 오류가 발생하였습니다.");
		this.close();
<%
	}
%>
} 

//현재 비밀번호 체크
function old_password_check() {
	document.loginForm.st_old_password.value = document.loginForm.password.value;
    kepAjaxFormCall("/login/getOldPasswordCheck.do","loginForm","getOldPasswordCheck");
}

//현재 비밀번호 입력시 무조건 체크 flag N으로 셋팅
function checkFlagOnlyN() {
	$("#oldPwdCheck").val("N");
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "getOldPasswordCheck"){
		var flag = $.trim(eval("response.flag"));
		if (flag == 'Y') {
			$("#oldPwdCheck").val("Y");
		} else if (flag == 'N') {
			alert("등록된 패스워드와 일치하지 않습니다.");
			$("#oldPwdCheck").val("N");
			$("#password").val('');
			$("#password").focus();
		}
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "getOldPasswordCheck"){ 
		alert('현재 비밀번호 확인중 오류가 발생하였습니다.\n관리자에게 문의하여 주시기 바랍니다.');
		$("#oldPwdCheck").val("N");
	
	}
}

/*---------------------------------------------------
*
* 패스워드 유효성 검사.
*
----------------------------------------------------*/
function checkpassword( ){

	var pUserId = "userId";
	var pPwd1   = "password_new";
	var pPwd2   = "password_confirm";

	var uId = document.getElementsByName(pUserId)[0].value;
	var pw1 = document.getElementsByName(pPwd1)[0].value;
	var pw2 = document.getElementsByName(pPwd2)[0].value;

	var invalid = " ";
   
	if (pw1 == '' && pw2 == '') {
		alert('비밀번호를 확인해주세요!');
		return;
	}
   
	if (uId == pw1) {
		alert('ID 와 패스워드가 동일합니다. 비밀번호를 확인해주세요!');
		document.getElementsByName(pPwd1)[0].value = "";
		document.getElementsByName(pPwd2)[0].value = "";
		document.getElementsByName(pPwd1)[0].focus();
		return;
	}
	
	if ((pw1 != pw2 ) && pw2 != '' ) {
		alert('변경할 비밀번호와 다릅니다. 비밀번호를 확인해주세요!');
		document.getElementsByName(pPwd2)[0].value = "";
		document.getElementsByName(pPwd2)[0].focus();
		return; 
	}
    
	if (document.getElementsByName(pPwd1)[0].value.indexOf(invalid) > -1) { 
		alert("공백은 입력할 수 없습니다."); 
		document.getElementsByName(pPwd1)[0].value = "";
		document.getElementsByName(pPwd2)[0].value = "";
		document.getElementsByName(pPwd1)[0].focus();         
		return; 
	}

	if (!pass_check(pw1)) {
		document.getElementsByName(pPwd1)[0].value = "";
		document.getElementsByName(pPwd2)[0].value = "";
		document.getElementsByName(pPwd1)[0].focus();  
		return;
	}
   
	if(!pass_valid_check(pw1)) {
		document.getElementsByName(pPwd1)[0].value = "";
		document.getElementsByName(pPwd2)[0].value = "";
		document.getElementsByName(pPwd1)[0].focus();
		return;
	}
}

// 패스워드 유효성 체크
function pass_check(pwd){
	var eng_flag = false;
    var num_flag = false;
	var pwdLength = pwd.length ; 

	if(pwdLength < 8){
		 alert('영문,숫자 조합 최소 8자리 이상이어야 합니다.');  
        return false;  
	}
   
    for(i=0; i < pwdLength; i++){
        var t_pass = parseInt(pwd.charCodeAt(i)) ; 
		if( t_pass > 48 && t_pass < 57  ) {
			num_flag = true;
		}else if( (t_pass > 65 && t_pass < 90) || (t_pass > 97 && t_pass < 122)  ){
			eng_flag = true; 
		}
	}

	if(!eng_flag && num_flag){
			alert('숫자만으로 입력할수 없습니다.');   
			return false;   
	}
	return true;   
}

//패스워드 유효성 체크
function pass_valid_check(pwd){
    var cnt=0, cnt2=1, cnt3=1; cnt4=1;
    var temp="";
   
    for(i=0;i < pwd.length;i++){
        temp_pass1 = pwd.charAt(i);
        next_pass = (parseInt(temp_pass1.charCodeAt(0))) + 1;
        Re_pass = (parseInt(temp_pass1.charCodeAt(0))) + 1;
        temp_p = pwd.charAt(i + 1);
        temp_p2 = pwd.charAt(i - 1);  //역순
        temp_pass2 = (parseInt(temp_p.charCodeAt(0)));
        temp_pass3 = (parseInt(temp_p2.charCodeAt(0)));
       
		if (temp_pass2 == next_pass) {
			cnt2 = cnt2 + 1;
		} else {
			cnt2 = 1;
		} 
		if (temp_pass3 == Re_pass) {
			cnt4 = cnt4 + 1;
		} else {
			cnt4 = 1;
		}    
		if (temp_pass1 == temp_p) {
			cnt3 = cnt3 + 1;
		} else {
			cnt3 = 1;
		} 
		if (cnt2 > 3) 
			break;
		if (cnt3 > 3) 
			break;
		if (cnt4 > 3)
			break;
    } 
    if (cnt2 > 3 || cnt4 > 3) {
        alert("비밀번호에 연속된 문자나 순차적인 숫자를 4개이상 사용해서는 안됩니다.");
        pwd.value =""; 
        return false;  
    }
    
    if (cnt3 > 3) {
        alert("비밀번호에 반복된 문자/숫자를 4개이상 사용해서는 안됩니다.");
        pwd.value =""; 
        return false; 
    }    
    return pwd;    
}

</script>
 <style>
/* 비밀번호 변경 */
.PwChange{margin:0 auto; margin-top:50px; width:450px; height:240px; border:1px solid #CCC; color:#1d2a40; background-color:#fff; border-top:3px solid #ef4023 }
.PwTitle{margin:0 auto; width:450px; font-size:30px; font-weight:bold; color:#fff; text-align:center; letter-spacing:-3px; height:70px; line-height:80px; background:url(/resources/images/dot03.png);background-color:#4b4948  }
table{margin:0 auto; margin-top:25px; margin-bottom:25px;font-size:16px;   }
table th{font-weight:bold; text-align:left; height:40px}
table input{border:1px solid #ef4023; background-color:#fff; height:35px; line-height:35px; width:170px;}
table .id{color:#ef4023; font-weight:bold}
.PwBtn{margin:0 auto; width:190px; text-align:left; padding-top:20px;   }
.PwBtn .LayerBtnBlue  {padding:10px 65px; background:url(/resources/images/dot03.png);  background-color:#ef4023; font-size:16px;  font-weight:bold; color:#fff; text-align:center;}
.Pwtxt{margin:0 auto; margin-top:15px; width:500px; height:30px; text-align:center; font-weight:bold }
</style> 
</head>
<body onLoad="kep_onload_view()">
<form id="loginForm" name="loginForm" method="post">
	<input type = "hidden" id="originData" name = "originData" size="40" >
	<input type = "hidden" id="pageFlag" name = "pageFlag"  value="">
	<input type = "hidden" id="mainLogin" name = "mainLogin" value="KOREAB2B">
	<input type = "hidden" id="gw_no" name = "gw_no" value="<%=gw_no%>">
	<input type = "hidden" id="gj_type" name = "gj_type" value="<%=gj_type%>">
	<input type = "hidden" id="userId" name = "userId" value="<%=userId%>">
	<input type = "hidden" id="oldPwdCheck" name="oldPwdCheck" value="N"/>
	<input type = "hidden" id="st_old_password" name="st_old_password" value=""/>
	<input type = "hidden" id="password_old" name="password_old" value=""/>
	<div class="wrap" >
	<div class="PwChange">
    	<div class="PwTitle"><%=flag_text%> 비밀번호 입력</div>
<%if("S".equals(password_type)){%>
		<table>
			<tr>
				<th style="width:130px; height:30px;">현재 비밀번호</th>
				<td>
					<input name="password" type="password" id="password" style="height:20px;" size="25" onChange="javascript:old_password_check();" onkeypress="javascript:checkFlagOnlyN();" value="">
				</td>
				<td width="120px" rowspan="3" align="center" > <img src="/resources/images/pw_input.png" /></td>
            </tr>
            <tr>
            	<th style="width:130px; height:30px;">새로운 비밀번호</th>
				<td>
					<input name="password_new" type="password" id="password_new" style="height:20px;" size="25" onChange="javascript:checkpassword();" value="">
				</td>
            </tr>
            <tr>
            	<th style="width:130px; height:30px;">비밀번호 확인</th>
				<td>
					<input name="password_confirm" type="password" id="password_confirm" style="height:20px;" size="25" onChange="javascript:checkpassword();" value="">
				</td>
            </tr>
            <tr>
            	<th></th>
                <td>
                	<div class="PwBtn" style="padding-top:0px; padding:0px;">
                		<a href="javascript:actionLogin();"><span class="LayerBtnBlue" style="padding:3px 65px;">확 인</span></a>
        			</div>
				</td>
				<td>
				</td>
			</tr>
		</table>
<%}else{%>
        <table>
			<tr>
				<th width="85px">비밀번호</th>
				<td width="195px">
					<input name="password" type="password" id="password" onKeyDown="if(event.keyCode == 13){actionLogin();};" value="">
					<input name="password_confirm" type="hidden" id="password_confirm" value="">
				</td>
				<td width="120px" rowspan="2" align="right" > <img src="/resources/images/pw_input.png" /></td>
            </tr>
            <tr>
            	<th></th>
                <td>
                	<div class="PwBtn">
                		<a href="javascript:actionLogin();"><span class="LayerBtnBlue">확 인</span></a>
        			</div>
				</td>
			</tr>
		</table>
<%}%>		
	</div>
</div>
</form>
</body>
</html>


