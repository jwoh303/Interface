<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<head>
<%
String userId =CommonUtil.nvl((String)request.getAttribute("user_Id"),""); // 사용자ID
String user_nm =CommonUtil.nvl((String)request.getAttribute("user_nm"),""); // 사용자명
String sslurl2 = CommonUtil.getSslURL(request, "https");
String after_url = CommonUtil.nvl((String)request.getAttribute("after_url"),""); // 다음 URL
%>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script type="text/javascript">
function actionLogin() {
	if (document.loginForm.userId.value == "") {
		alert("koreab2b 가입정보가 없습니다.");
		return;
	} else if (document.loginForm.password.value == "") {
		alert("비밀번호를 입력하세요");
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
			alert("인증에 실패하였습니다.\n다시 시도하여 주시기 바랍니다.");
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
		alert("인증에 실패하였습니다.\n\n시스템 관리자에게 문의하여 주시기 바랍니다.");
	}
}
</script>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<link rel="stylesheet" href="/resources/styles/koreab2b_base.css" type="text/css" />
 <style>
/* 비밀번호 변경 */
.PwChange{margin:0 auto; margin-top:150px; width:500px; height:300px; border:1px solid #CCC; color:#1d2a40; background-color:#fff; border-top:3px solid #ef4023 }
.PwTitle{margin:0 auto; width:500px; font-size:30px; font-weight:bold; color:#fff; text-align:center; letter-spacing:-3px; height:70px; line-height:80px; background:url(/resources/images/dot03.png);background-color:#4b4948  }
table{margin:0 auto; margin-top:25px; margin-bottom:25px;font-size:16px;   }
table th{font-weight:bold; text-align:left; height:40px}
table input{border:1px solid #ef4023; background-color:#fff; height:35px; line-height:35px; width:170px;}
table .id{color:#ef4023; font-weight:bold}
.PwBtn{margin:0 auto; width:400px; text-align:left; padding-top:20px; padding-bottom:20px;   }
.PwBtn .LayerBtnBlue  {padding:10px 60px; background:url(/resources/images/dot03.png);  background-color:#ef4023; font-size:16px;  font-weight:bold; color:#fff; text-align:center;}
.PwBtn .LayerBtnRed {padding:10px 50px; background-color:#7a7979;font-size:16px;  font-weight:bold; color:#fff; text-align:center;}
.Pwtxt{margin:0 auto; margin-top:15px; width:500px; height:30px; text-align:center; font-weight:bold }
</style> 

<body onLoad="kep_onload_view()" style="background-color:#eee">
<form id="loginForm" name="loginForm" method="post">
	<input type = "hidden" id="originData" name = "originData" size="40" >
	<input type = "hidden" id="pageFlag" name = "pageFlag"  value="">
	<input type = "hidden" id="mainLogin" name = "mainLogin" value="KOREAB2B">
	<div class="wrap" >
	<div class="PwChange">
    	<div class="PwTitle">패스워드 입력</div>
        <table >
        	<tr>
                <th width="85px">아이디</th>
                <td width="195px" class="id">
                	<input type="hidden" id="userId" name="userId" title=""  value="<%=userId%>"  class="input_text"/>
                	<%=userId%><br><font color="black">[<%= user_nm%>]</font>
                </td>
                <td width="120px" rowspan="2" align="right" > <img src="/resources/images/pw_input.png" /></td>
            </tr>
            <tr>
            	<th>패스워드</th>
                <td><input name="password" type="password" id="password"   onKeyDown="if(event.keyCode == 13){actionLogin();};" value=""></td>
            </tr>
          </table>
<%if(!"".equals(after_url)){ %>
        <div class="PwBtn" style="text-align: center;">
        	<a href="javascript:actionLogin();"><span class="LayerBtnBlue">로그인</span></a>&nbsp;
        </div>
<%}else{%>
        <div class="PwBtn">
        	<a href="javascript:actionLogin();"><span class="LayerBtnBlue">로그인</span></a>&nbsp;
           	<a href="/main/sub04/sub04_idpw_search_2016.do" target="_blank"><span class="LayerBtnRed">패스워드찾기</span></a>
        </div>
<%}%>        
    </div>
</div>
   <div class="Pwtxt" >※ 개인정보를 안전하게 보호하기 위해 비밀번호를 다시 한번 확인 합니다. </div>
</form>
</body>
</html>