<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<link rel="stylesheet" href="/resources/styles/koreab2b_base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/koreab2b.css" type="text/css">
</head>
<body>
<script type="text/javascript">
<!--
	function actionLogout() {
		document.loginForm.action = "/login/logout.do";
		document.loginForm.submit();
	}
//-->	
</script>
<form id="loginForm" name="loginForm" method="post">
<div class="wrap" >
	<div class="LoginLogout">
        <img src="/resources/images/main/Error01.png" />
        <div class="LogoutTitle">로그인 되어 있는 화면이 있습니다.&nbsp;&nbsp; <a href="javascript:actionLogout();"><span class="FontBlue">로그아웃(클릭!!)</span></a> 해주십시오.</br></br>
        로그아웃 링크를 클릭하여 현재 브라우져 창은 닫아주세요.
        </br>
        <!-- <a href="javascript:close();"><span class="LogoutBtn"> 닫기 >></span></a></div> -->
    </div>
</div>
</div>
</form>
</body>
</html>

