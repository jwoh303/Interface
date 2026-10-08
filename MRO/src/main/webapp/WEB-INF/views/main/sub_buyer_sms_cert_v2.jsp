<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<!doctype html>
<html>
<head>
<%@ include file="../common/include/head_v2.jspf"  %>
<%
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("dataList");
Map<String,String> rowData = null;
if (_dataList == null || _dataList.size() == 0){
}else{
	rowData = _dataList.get(0);
}
String SessionUserId = "";
String SessionComCode = "";
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
if (sessionInfo != null){ 
	SessionUserId =  CommonUtil.nvl((String)sessionInfo.getUserId());
	SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode());
}
String redirectUrl = CommonUtil.nvl((String) request.getAttribute("redirectUrl"),"/main.do");
String sslurl2 = CommonUtil.getSslURL(request, "https");
%>
<style>
body {margin:0;background:#ecf2fd;display: flex;justify-content: center;align-items: center;height: 100vh;}
.container {width:500px;text-align:center;padding:40px 50px 60px 50px;border-radius:20px;background: #fff;box-shadow: 0 10px 30px rgba(0,0,0,0.08);}
.logo {width: 60px;margin-bottom: 15px;}
.title {font-size:37px;font-weight:700;margin-bottom:20px;}
.desc {font-size:15px;color:#595959;margin-bottom:45px;line-height:20px;}
.info {width:380px; margin:0 auto; text-align:left;margin-bottom:15px; font-size:18px;font-weight:400; color: #333;}
.info .blue {font-weight:600;margin-left: 15px; color:#2172EC} 
.info .black{font-weight:600;margin-left: 15px; color:#000} 
.auth-wrap { margin:0 auto;width:380px; display: flex;gap: 8px;margin-top: 10px;margin-bottom: 20px;}
.auth-wrap input {flex: 1;padding: 12px; font-size:16px;font-weight:500; border: 1px solid #ddd;border-radius:6px; outline: none;}
.auth-wrap input:focus {border-color: #4a90e2;}

.resend-btn {white-space: nowrap;padding: 0 12px;color:#2172EC; font-size:14px; border:0px;background:#ebf3ff;border-radius:6px;cursor: pointer;}
.resend-btn:hover {background:#2172EC;color: #fff;}
.btn {width:380px;height:45px; line-height:45px; font-size:16px; font-weight:500;color:#fff;border:none; border-radius:8px; cursor:pointer; transition:0.2s;background: #2172EC;}
.btn:hover {background: #1a5bbd;}
.blue{color:#2172EC}
</style>

<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1funcReload = "javascript:thisPopReload(); return false;";
var but1width = "120px";

function nextTime(){
	var cert_sms_no = $("#st_cert_sms_no").val();
	
	if (cert_sms_no == "") {
// 		alert("인증번호를 입력하세요");
		var text = "<%=CommonLang.msg("MSG746")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_cert_sms_no").focus();
		return;
	}
	
	kepAjaxFormCall("<%=sslurl2%>/login/getOldCertSmsCheck.do","certSmsform","getOldCertSmsCheck");
}

function buyerCertSmsResend(){
	//인증번호를 재발송합니다.\n진행하시겠습니까?
	var text = "<%=CommonLang.msg("MSG755")%>";
	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	var but1funcC = "javascript:setCertSmsResend(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "100px";
	var but2widthC = "100px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
// 	if (confirm('인증번호를 재발송합니다.\n진행하시겠습니까?')) {
<%-- 		kepAjaxFormCall("<%=sslurl2%>/login/setCertSmsResend.do","certSmsform","setCertSmsResend"); --%>
// 	}
}

function setCertSmsResend(){
	closePopText1();
	kepAjaxFormCall("<%=sslurl2%>/login/setCertSmsResend.do","certSmsform","setCertSmsResend");
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "getOldCertSmsCheck"){
		var flag = $.trim(eval("response.flag"));
		if (flag == 'Y') {
			$('#certSmsform').attr("method", "post");
		    $('#certSmsform').attr("action", "<%=sslurl2%>/login/logincertificate.do");
		    $('#certSmsform').submit();
		} else if (flag == 'N') {
// 			alert("인증번호가 일치하지 않습니다.");
			var text = "<%=CommonLang.msg("MSG747")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			$("#st_cert_sms_no").focus();
			return;
		}
	}else if(pMethod == "setCertSmsResend"){
// 		alert("인증번호를 재발송하였습니다.");
		var text = "<%=CommonLang.msg("MSG748")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "getOldCertSmsCheck"){ 
// 		alert('현재 인증번호 확인중 오류가 발생하였습니다.\n관리자에게 문의하여 주시기 바랍니다.');
		var text = "<%=CommonLang.msg("MSG749")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}else if(pMethod == "setCertSmsResend"){
// 		alert("인증번호 재발송에 실패하였습니다.\n관리자에게 문의하여 주시기 바랍니다.");
		var text = "<%=CommonLang.msg("MSG750")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
}

$(document).on('keydown', 'input[type=text]', function(e) {
	if (e.key === 'Enter'){
		e.preventDefault();
		nextTime();
	}
});
</script>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<form id="certSmsform" method="post" >
<input type="hidden" name="userId" id="userId" value="<%=rowData.get("USER_ID")%>"/>
<input type="hidden" name="comCode" id="comCode" value="<%=rowData.get("COM_CODE")%>"/>
<div class="container"> 
  <img src="/resources/imgs/Icon_key.png" alt="lock" class="logo">
  <div class="title"><%=CommonLang.get("HTITLE1172")%><!--로그인 추가 인증--></div>
  <div class="desc"> <%=CommonLang.msg("MSG751")%><!--회원님의 개인정보를 안전하게 보호하고, 개인정보 도용으로 인한-->  <br />
    <%=CommonLang.msg("MSG752")%><!--피해를 예방하기 위해 로그인 시 SMS추가인증을 이용하고 있습니다.--><br>
    <%=CommonLang.msg("MSG753")%><!--하기의 정보로 인증번호를 전송하여 드립니다.--><br>
    <%=CommonLang.msg("MSG754")%><!--인증번호 입력란에 입력하여 주시기 바랍니다.--> </div>
  <div class="info"> <%=CommonLang.get("HTITLE1173")%><!--로그인ID--> <span class="black"><%=CommonUtil.bnvl( rowData.get("USER_ID"))%></span> </div>
  <div class="info"> <%=CommonLang.get("HTITLE577")%><!-- 휴대전화 --> <span class="black"><%=CommonUtil.bnvl( rowData.get("MOBILE_PHONE"))%></span> </div>
     
  <div class="auth-wrap">
    <input type="text" id="st_cert_sms_no" name="st_cert_sms_no" placeholder="<%=CommonLang.get("HTITLE1174")%>" onKeyDown="if(event.keyCode == 13){nextTime();};"><!-- 인증번호 입력 -->
    <button class="resend-btn" onKeyDown="if(event.keyCode == 13){return false;};" onclick="javascript:buyerCertSmsResend(); return false;"><%=CommonLang.get("HTITLE1175")%><!--SMS 재발송--></button>
  </div>
  <button class="btn" type="button" onclick="javascript:nextTime(); return false;"><%=CommonLang.get("HTITLE516")%><!--확인--></button>
</div>
</form>
</body>
</html>

