<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<head>
<title>로그인 추가인증 설정</title>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script type="text/javascript" src="/resources/js/kep_common.js"></script>
<% 
	String sslurl2 = CommonUtil.getSslURL(request, "https"); 
%>
<script type="text/javascript">
 
function nextTime(){
	if($("#infoAgreeY").is(":checked") == false && $("#infoAgreeN").is(":checked") == false){
		alert("사용여부를 선택하여 주십시요.");
		return;
	}
	$("#loginAddiCertYn").val($("input[name=infoDefalut2]:checked").val());
	$('#loginForm').attr("method", "post");
    $('#loginForm').attr("action", "<%=sslurl2%>/login/logincertificate.do");
    $('#loginForm').submit();
}

</script>
</head>
<style>
.wrap{font-family:"맑은 고딕"; font-size:16px; }
.info_txt{position:relative; margin:0 auto; margin-top:100px; padding:35px 10px 35px 190px;width:560px;background-color:#3d414d; color:#fff; border:1px solid #2c303c; letter-spacing:-0.5px}
.info_txt img{ position:absolute; top:10px; left:35px}
.info_box{ margin:0 auto; padding:40px 30px 60px 30px; width:700px; background-color:#fff; text-align:center; border:1px solid #c9c9c9 }
h1{ letter-spacing:-1px; margin-bottom:30px}
a{text-decoration:none}
.ok{margin:0 auto;width:300px; height:40px; line-height:40px; background-color:#06347f; color:#fff; font-weight:bold; margin-top:45px; }
</style>
<body style="background-color:#e5e5e5">
<div class="wrap">
<form id="loginForm" id="loginForm"  name="loginForm" method="post">
	<input type = "hidden" id="userId" name = "userId" value="${userId}"/>
	<input type = "hidden" id="pageFlag" name = "pageFlag"  value="imsi"/>
	<input type = "hidden" id="loginAddiCertYn" name = "loginAddiCertYn"  value=""/>
</form>
	<div class="info_txt">
        사이트 사용자의 정보보호 강화 목적으로 two-factor(2단계 인증)을<br/>도입하였습니다. 보안 강화 사용을 희망하시면 적용이 됩니다.
    	<img src="/resources/images/main/info.png" />
    </div>
    <div class="info_box">
    	<h1>로그인 추가인증 설정</h1>
        <div style="line-height:24px">
사용 : 아이디 / (비밀번호 + 휴대폰 SMS 인증)<br/>
미사용 : 아이디 / 비밀번호&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br/><br/><br/>
            <b><input type="radio" name="infoDefalut2" id="infoAgreeY" value="Y"/>사용
			&nbsp; &nbsp; &nbsp;
            <input type="radio" name="infoDefalut2" id="infoAgreeN" value="N" checked/>미사용</b>
        </div>
        <a href="javascript:nextTime();"><div class="ok">확  인</div></a><br/>
        <font style="color:red"><b>※ 로그인 후 개인정보에서 변경 가능합니다.</b></font>
    </div>
</div>
</body>
</html>
