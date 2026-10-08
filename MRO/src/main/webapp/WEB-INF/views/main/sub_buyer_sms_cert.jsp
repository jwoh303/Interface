<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<link rel="stylesheet" href="/resources/styles/koreab2b_base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/koreab2b.css" type="text/css">
<link rel="stylesheet" href="/resources/styles/certification.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script type="text/javascript" src="/resources/js/kep_common.js"></script>

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
<script type="text/javascript">
function nextTime(){
	var cert_sms_no = $("#st_cert_sms_no").val();
	
	if (cert_sms_no == "") {
		alert("인증번호를 입력하세요");
		$("#st_cert_sms_no").focus();
		return;
	}
	
	kepAjaxFormCall("<%=sslurl2%>/login/getOldCertSmsCheck.do","certSmsform","getOldCertSmsCheck");
}

function buyerCertSmsResend(){
	if (confirm('인증번호를 재발송합니다.\n진행하시겠습니까?')) {
		kepAjaxFormCall("<%=sslurl2%>/login/setCertSmsResend.do","certSmsform","setCertSmsResend");
	}
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
			alert("인증번호가 일치하지 않습니다.");
			$("#st_cert_sms_no").focus();
			return;
		}
	}else if(pMethod == "setCertSmsResend"){
		alert("인증번호를 재발송하였습니다.");
		return;
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "getOldCertSmsCheck"){ 
		alert('현재 인증번호 확인중 오류가 발생하였습니다.\n관리자에게 문의하여 주시기 바랍니다.');
		return;
	}else if(pMethod == "setCertSmsResend"){
		alert("인증번호 재발송에 실패하였습니다.\n관리자에게 문의하여 주시기 바랍니다.");
		return;
	}
}
</script>
</head>
<body>
<form id="certSmsform" method="post" >
<input type="hidden" name="userId" id="userId" value="<%=rowData.get("USER_ID")%>"/>
<input type="hidden" name="comCode" id="comCode" value="<%=rowData.get("COM_CODE")%>"/>
<div class="sms_wrap">
        <div class="tit">로그인 추가인증</div>
        <div class="sms_reason">
         회원님의 개인정보를 안전하게 보호하고, 개인정보도용을 인한 피해를 예방하기 위해 </br>
         로그인 시 SMS 추가인증을 이용하고 있습니다. 하기의 정보로 인증번호를 전송하여 드립니다. </br>
         인증번호 입력란에 입력하여 주시기 바랍니다.
        </div>
        <div class="txt">
            <dl>
                <dt>로그인 ID </dt>
                <dd><%=CommonUtil.bnvl( rowData.get("USER_ID"))%></dd>
            </dl>
            <dl>
                <dt>휴대전화 </dt>
                <dd><%=CommonUtil.bnvl( rowData.get("MOBILE_PHONE"))%></dd>
            </dl>
            <dl>
                <dt>인증번호  </dt>
                <dd><input id="st_cert_sms_no" name="st_cert_sms_no" type="text" placeholder="입력란"/><input type="text" style="display:none;"/><a href="javascript:buyerCertSmsResend();"><div class="sms_btn">SMS 재발송</div></a> </dd>
            </dl>
        </div>
        <a href="javascript:nextTime();"><div class="smsOK_btn">확인</div></a>
     </div>
</form>
</body>
</html>

