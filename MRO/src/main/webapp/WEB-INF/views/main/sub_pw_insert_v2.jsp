<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<!doctype html>
<head>
<%@ include file="../common/include/head_v2.jspf"  %>

<%
String userId =CommonUtil.nvl((String)request.getAttribute("user_Id"),""); // 사용자ID
String user_nm =CommonUtil.nvl((String)request.getAttribute("user_nm"),""); // 사용자명
String sslurl2 = CommonUtil.getSslURL(request, "https");
String after_url = CommonUtil.nvl((String)request.getAttribute("after_url"),""); // 다음 URL
%>
<style>
body {margin:0;;background: #ecf2fd; display:flex;justify-content: center;align-items: center; height: 100vh;}
.container {width:500px;background: #fff;border-radius:20px;padding:50px 50px 70px 50px;box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);text-align: center;}
.logo {width: 60px;margin-bottom: 15px;}
.title {font-size:37px;font-weight:700;margin-bottom:20px;}
.desc {font-size: 13px;color: #666;margin-bottom: 25px;line-height: 1.6;text-align: center;}
.info {width:380px; margin:0 auto; text-align:left;margin-bottom:15px; font-size:18px;font-weight:600; color: #333;}
.info .blue {font-weight:500;margin-left: 5px; color:#2172EC} 
.info .black{font-weight:500;margin-left: 5px; color:#000} 
.input-box {margin-bottom:10px;}
.input-box input {width:340px; height:40px; line-height:40px; padding:0 20px; font-size:16px; border:1px solid #DEDEDE; border-radius:8px; }
.input-box input:focus {border-color: #4a90e2;}
.btn {width:380px;height:45px; line-height:45px; font-size:16px; font-weight:500;color:#fff;border:none; border-radius:8px; cursor:pointer; transition:0.2s;background: #2172EC;}
.btn2 {width:190px;height:45px; line-height:45px; font-size:16px; font-weight:500;color:#fff;border:none; border-radius:8px; cursor:pointer; transition:0.2s;background: #2172EC;}
.btn:hover {background:#1a5bbd;}
.blue{color:#2172EC}
</style>
<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1funcReload = "javascript:thisPopReload(); return false;";
var but1width = "120px";

function actionLogin() {
	if (document.loginForm.userId.value == "") {
		//koreab2b 가입정보가 없습니다.
		var text = "<%=CommonLang.msg("MSG741")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	} else if (document.loginForm.password.value == "") {
// 		alert("비밀번호를 입력하세요");
		var text = "<%=CommonLang.msg("MSG431")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		document.loginForm.password.focus();
		return;
	} else if ("<%=after_url%>" != "") {
		var pMethod ="pwdChk";
		var data = { password : $("#password").val() };
		kepAjaxCallNoBar("/main/getSubPwInsert.do", data, pMethod);
	} else {
		document.loginForm.method ="post";
		document.loginForm.action ="/login/login.do";
		document.loginForm.submit();
	}
}

function kep_onload_view(){
	document.loginForm.password.focus();
} 

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	var sMsg = response.RESULT;
	if (pMethod == "pwdChk"){
		if(sMsg == "Y"){
			document.loginForm.method ="post";
			document.loginForm.action ="<%=after_url%>";
			document.loginForm.submit();
		}else{
// 			alert("인증에 실패하였습니다.\n다시 시도하여 주시기 바랍니다.");
			var text = "<%=CommonLang.msg("MSG742")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
		}
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function kepAjaxError(pMethod , response) {
	var msg = response.Message;
	if (msg != ""){
		alert(msg);
	}
	if (pMethod == "pwdChk"){
// 		alert("인증에 실패하였습니다.\n\n시스템 관리자에게 문의하여 주시기 바랍니다.");
		var text = "<%=CommonLang.msg("MSG743")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
</script>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body onLoad="kep_onload_view()" style="background-color:#eee">
<form id="loginForm" name="loginForm" method="post">
	<input type = "hidden" id="originData" name = "originData" size="40" >
	<input type = "hidden" id="pageFlag" name = "pageFlag"  value="">
	<input type = "hidden" id="mainLogin" name = "mainLogin" value="KOREAB2B">
	<div class="container">
	  <img src="/resources/imgs/Icon_key.png" alt="lock" class="logo">
	  <div class="title"><%=CommonLang.get("HTITLE1170")%><!--비밀번호 확인--></div>
	  <div class="desc"> <%=CommonLang.msg("MSG744")%><!--개인정보 보호를 위해 비밀번호를 다시 한 번 입력해주세요.--></div>
	  <input type="hidden" id="userId" name="userId" title=""  value="<%=userId%>"/>
	  <div class="info"> 아이디 : <span class="blue"><%= userId%> </span> <span class="black">[<%= user_nm%>]</span></div>
	  <div class="input-box"> <input type="password" id="password" name="password" onKeyDown="if(event.keyCode == 13){actionLogin();};" placeholder="<%=CommonLang.msg("MSG745")%>"></div><!-- 비밀번호를 입력해주세요. -->
	  <%if(!"".equals(after_url)){ %>
		  <button class="btn" onclick="javascript:actionLogin(); return false;"><%=CommonLang.get("HTITLE516") %><!-- 확인 --></button>
	  <%}else{ %>
	  	  <button class="btn2" onclick="javascript:actionLogin(); return false;"><%=CommonLang.get("HTITLE516") %><!-- 확인 --></button>
	  	  <button class="btn2" onclick="location.href='/main/sub04/sub04_idpw_search_v2_2016.do'; return false;" target="_blank"><%=CommonLang.get("HTITLE1171")%><!--비밀번호 찾기--></button>
	  <%} %>
	</div>
</form>
</body>
</html>