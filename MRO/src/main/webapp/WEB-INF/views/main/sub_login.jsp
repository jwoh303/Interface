<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<link rel="stylesheet" href="/resources/styles/koreab2b_base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/koreab2b.css" type="text/css">
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script type="text/javascript" src="/resources/js/kep_common.js"></script>
<script type="text/javascript">
 
function kep_onload_view(){ 
	var Cookieuser_id = GetCookie("Koreab2bUserID");
    if(Cookieuser_id == null)
    {
        Cookieuser_id = "";
    }else {
       document.forms[0].auto_login.checked=true;
	}
	document.forms[0].userId.value = Cookieuser_id;
	
	if( document.forms[0].userId.value != "" )
	{
	    document.forms[0].password.focus();
	}else {
	    document.forms[0].userId.focus();
	}
	
	if ('${message}' != '') {
		alert('${message}');
	}
	
} 

function actionLogin() { 
	if ($("#userId").val() == "") {
		alert("아이디를 입력하세요");
		return;
	} else if ($("#password").val() == "") {
		alert("비밀번호를 입력하세요");
		return;
	} else {
		if (document.forms[0].auto_login.checked==true) {
			SetCookie("Koreab2bUserID",$("#userId").val());
		}else {
			DeleteCookie("Koreab2bUserID");
		}
		$('#loginForm').attr("method", "post");
	    $('#loginForm').attr("action", "/login/login.do");
	    $('#loginForm').submit();
	}
}

function SetCookie(name, value) {
	  if (value.length <= 0) return;

	  var exp = new Date();
	  exp.setHours(exp.getHours()+3);  // This cookie is history
	  document.cookie = name + "=" + value + ("; expires=" + exp.toGMTString()) + "; /;"
}

function DeleteCookie(namefield) {
	  var exp = new Date();
	  exp.setTime (exp.getTime() - 1);  // This cookie is history
	  var cookieval = GetCookie (namefield);
	  document.cookie = namefield + "=" + cookieval + "; expires=" + exp.toGMTString();
}

function GetCookie(name) {
	 var arg = name + "=";
	 var arglen = arg.length;
	 var cookielen = document.cookie.length;
	 var i = 0;
	 while( i < cookielen ) {
	   var j = i + arglen;
	   if( document.cookie.substring(i, j) == arg )
	     return GetCookieByNum(j);
	   i = document.cookie.indexOf(" ", i) + 1;
	   if (i == 0) break;
	 }
	 return null;
}

function GetCookieByNum(index) {
	  var end = document.cookie.indexOf (";", index);
	  if (end == -1)
	    end = document.cookie.length;
	  return unescape(document.cookie.substring(index, end));
}
</script>
</head>
<body onload="kep_onload_view()">
<div class="wrap" >
	<div class="SessionLogin">
	<form id="loginForm" id="loginForm"  name="loginForm" method="post">
	<input type="hidden" id="st_page_flag"	name="st_page_flag"		value="">
    	<div class="SessionTitle">로그인 종료되었습니다.&nbsp; <span class="FontBlue">재로그인</span> 해주십시오.</div>
        <div class="SessionBox" >
            <ul>
                <li>아이디 &nbsp;&nbsp;<input name="userId" type="text" id="userId" onkeyup="kepToUpper('userId')" value = "" onkeydown="if(event.keyCode == 13) {actionLogin();}" /></li>
                <li>비밀번호 &nbsp;<input name="password" type="password" id="password" onkeydown="if(event.keyCode == 13) {actionLogin();}" /></li>
                <li><p><input type="checkbox" id="auto_login"  name="auto_login" value="1" onfocus="this.blur();" class="noline"> 아이디저장 </p></li>
            </ul>
        </div>
        <div class="SessionBtn" ><a href="javascript:actionLogin();"><span class="LayerBtnBlue">로그인 >></span></a>
        <a href="/" ><span class="LayerBtnRed">메인화면으로 이동 >></span></a></div>
    </form>
    </div>
</div>
</body>
</html>

