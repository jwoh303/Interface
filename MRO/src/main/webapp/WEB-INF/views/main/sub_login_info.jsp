<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<head>
<title>정보제공 동의서</title>
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
		alert("동의여부를 확인하여 주십시요.");
		return;
	}
	$("#infoAgreeYn").val($("input[name=infoDefalut2]:checked").val());
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
	<input type = "hidden" id="password" name = "password"  value="${password}"/>
	<input type = "hidden" id="pageFlag" name = "pageFlag"  value="imsi"/>
	<input type = "hidden" id="infoAgreeYn" name = "infoAgreeYn"  value=""/>
</form>
	<div class="info_txt">
        납품받은 업체에서 기술적인 문의나 긴급시 협력사에 직접 연락하기 위하여 <br/>협력사 정보 제공 목적으로 사용하기 위하여 동의를 받고자 합니다.
    	<img src="/resources/images/main/info.png" />
    </div>
    <div class="info_box">
    	<h1>정보제공 동의서</h1>
        <div style="line-height:24px">
            당사는 코리아이플랫폼이 아래의 정보를 납품받은 업체에 제공하는 것에 동의합니다.<br/>
        	-	정보제공 범위 : 회사명 / 대표자명 / 담당자명 / 연락처 / 메일 주소<br/><br/><br/>
            <b><input type="radio" name="infoDefalut2" id="infoAgreeY" value="Y"/>동의 
             &nbsp; &nbsp; &nbsp;   
            <input type="radio" name="infoDefalut2" id="infoAgreeN" value="N"/>미동의</b>
        </div>
        <a href="javascript:nextTime();"><div class="ok">확  인</div></a>
    </div>
</div>
</body>
</html>
