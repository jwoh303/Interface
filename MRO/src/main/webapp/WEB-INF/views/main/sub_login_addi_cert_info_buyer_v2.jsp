<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<head>
<title>로그인 추가인증 설정</title>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<link rel="stylesheet" href="/resources/css/base.css" type="text/css" />
<% 
	String sslurl2 = CommonUtil.getSslURL(request, "https"); 
%>
<script type="text/javascript">
 
function nextTime(){
	$("#loginAddiCertYn").val($("input[name=infoDefalut2]:checked").val());
	$('#loginForm').attr("method", "post");
    $('#loginForm').attr("action", "<%=sslurl2%>/login/logincertificate.do");
    $('#loginForm').submit();
}

</script>
</head>
<style>
body {margin:0;background:#ecf2fd;display: flex;justify-content: center;align-items: center;height: 100vh;}
.container {width:500px;text-align:center;padding:40px 50px 60px 50px;border-radius:20px;background: #fff;box-shadow: 0 10px 30px rgba(0,0,0,0.08);}
.logo {width: 60px;margin-bottom: 15px;}
.title {font-size:37px;font-weight:700;margin-bottom:20px;}
.desc {font-size:15px;color:#595959;margin-bottom:25px;line-height:20px;}
.info {width:320px; margin:0 auto; text-align:left;margin-bottom:15px; font-size:18px;font-weight:400; color: #333;}
.info .blue {font-weight:600;margin-left: 15px; color:#2172EC} 
.info .black{font-weight:600;margin-left: 15px; color:#000} 
.auth-wrap { margin:0 auto;width:380px;  margin-top:50px;margin-bottom:30px; text-align:center}
.auth-wrap label:first-child{ margin-right:20px}
.resend-btn {white-space: nowrap;padding: 0 12px;color:#2172EC; font-size:14px; border:0px;background:#ebf3ff;border-radius:6px;cursor: pointer;}
.resend-btn:hover {background:#2172EC;color: #fff;}
.btn {width:380px;height:45px; line-height:45px; font-size:16px; font-weight:500;color:#fff;border:none;margin-bottom:20px; border-radius:8px; cursor:pointer; transition:0.2s;background: #2172EC;}
.btn:hover {background: #1a5bbd;}
.blue{color:#2172EC}
</style>
<body>
<div class="container"> 
<form id="loginForm" id="loginForm"  name="loginForm" method="post">
	<input type = "hidden" id="userId" name = "userId" value="${userId}"/>
	<input type = "hidden" id="pageFlag" name = "pageFlag"  value="imsi"/>
	<input type = "hidden" id="loginAddiCertYn" name = "loginAddiCertYn"  value=""/>
</form>

  <img src="/resources/imgs/Icon_key.png" alt="lock" class="logo">
  <div class="title">로그인 추가인증 설정</div>
  <div class="desc"> 사이트 사용자의 정보보호 강화 목적으로 two-factor(2단계 인증)을 도입하였습니다. <br />보안 강화 사용을 희망하시면 적용이 됩니다. </div>
  <div class="info"> 사용 : 아이디/(비밀번호 + 휴대폰 SMS 인증) </div>
  <div class="info"> 미사용 : 아이디/비밀번호  </div>
     
  <div class="auth-wrap">
    <label class="RadioLargeLabel"><input type="radio" name="infoDefalut2" id="infoAgreeY" value="Y"><span class="RadioLargeTxt"></span>사용</label>
    <label class="RadioLargeLabel"><input type="radio" name="infoDefalut2" id="infoAgreeN" value="N" checked><span class="RadioLargeTxt"></span>미사용</label>
  </div>
  <button class="btn" onclick="javascript:nextTime(); return false;">확인</button><br />
  ※ 로그인 후 개인정보에서 변경 가능합니다.
</div>
</body>
</html>
