<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<link rel="stylesheet" href="/resources/styles/koreab2b_base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/koreab2b.css" type="text/css">
<script type="text/javascript">
function goHome() {
	//부모창이 존재하면 부모창을 redirect시킴.
	if(typeof parent == 'undefined'){
		location.href = "/";
		return;
	}else{
		parent.location.href = "/";
		return;
	}
}
</script>
</head>
<body>

<div class="wrap" >
	<div class="LoginLogout">
        <img src="/resources/images/main/Error02.png" />
        <div class="LogoutTitle">현재 로그인 된 사용자에게는 <span class="FontBlue">권한이</span> 없습니다.</br></br></br>
        <a href="javascript:goHome();"><span class="LogoutBtn"> 홈으로 >></span></a></div>
    </div>
</div>
</body>
</html>

