<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html>
<head>
<%
	String com_code =  CommonUtil.nvl((String) request.getParameter("com_code"), "");
	String type =  CommonUtil.nvl((String) request.getParameter("type"), "");
%>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
</head>
<body onLoad="kep_onload_view()">
		<div class="wrap">
			<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp"%>
			<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
    <!--컨텐츠-->
<form id="loginForm" name="loginForm" method="post">
		<input type = "hidden" id="originData" name = "originData" size="40" >
		<input type = "hidden" id="pageFlag" name = "pageFlag"  value="">
 		<input type = "hidden" id="mainLogin" name = "mainLogin" value="">
        <div style="display:none">
        	    <textarea class="form-control" id="loginData" name = "loginData"></textarea>
        </div>
    <div class="subcontentsAreaLogin">
		<div class="subcontent" >
        	<div class="sub04_join">
                <br/><br/>
                <p class="subcontentTit" >LOGIN</p>
                <div class="LoginCheck" style="height:250px;width:650px; margin:auto ">
                    <p style="position:absolute; left:650px; line-height:15px">  <input class="checkbox" id="autoLogin" name="autoLogin" type="checkbox"  onchange="saveCookieId(this.checked)" /> 아이디저장</p>
                    <br />
                    <ul>
                        <li>아이디<input style="ime-mode:disabled;" class="LCinput" type="text" id="userId" name="userId" title=""  onkeyup="kepToUpper('userId')" onKeyDown="if(event.keyCode == 13){getTwoFactorLogin();};" placeholder="아이디" value="" /></li>
                        <li>비밀번호<input type="password" id="password" class="LCinput" name="password" title=""  placeholder="비밀번호"  onKeyDown="if(event.keyCode == 13){getTwoFactorLogin();};" value=""/></li>
                        <li><div class="LCBtn01" ><a href="javascript:getTwoFactorLogin();">로그인</a></div></li>
                        <li><div class="LCBtn02" ><a href="javascript:getTwoFactorSign();">협력사(기업)인증서 로그인</a></div></li>
                        <li><p class="LCTxt">※ <span class="FontRed">개인인증서</span>는 로그인할 수 없습니다.</li>
                    </ul>
                </div>
                <br/><br/><br/><br/>
            </div>
        </div>
    </div>
</form>
    <!--컨텐츠 끝-->
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainFooter.jsp"%>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
		</div>
</body>
<script type="text/javascript">
function saveCookieId(chk){
	var userId = $("#userId").val(); 
	if(chk == true){
		setCookie("chkLoginCookie", "Y" ,20);
		setCookie("saveCookieId", userId ,20);
	}else{
		setCookie("chkLoginCookie", "N" ,20);
		setCookie("saveCookieId", "" ,20);
	}
}
function setCookie(name,value,expiredays) {
	var todayDate = new Date();
	todayDate.setDate(todayDate.getDate() + expiredays);
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
}
	
function kep_onload_view(){ 
	
	if ('${message}' != '') {
		alert('${message}');
	}
	var cookieUserId = getCookie("saveCookieId");
	var chkLoginCookie = getCookie("chkLoginCookie");
	if(chkLoginCookie == "Y" ){
		$("#userId").val(cookieUserId);
		document.getElementById("autoLogin").checked = true;
	}
    nxTSPKI.onInit(function(){ 
        //nxTSPKI.init 함수 완료 후 실행해야 하는 함수나 기능 작성 위치
        //alert("Init 완료");
	});
} 
//자동로그인쿠키
function getCookie(name) {
	var nameOfCookie = name + "=";
	var x = 0

	while ( x <= document.cookie.length ) {
		var y = (x+nameOfCookie.length);
		if ( document.cookie.substring( x, y ) == nameOfCookie ) {
			if ( (endOfCookie=document.cookie.indexOf( ";",y )) == -1 )
				endOfCookie = document.cookie.length;
				return unescape( document.cookie.substring(y, endOfCookie ) );
		}
		x = document.cookie.indexOf( " ", x ) + 1;
		if ( x == 0 )
		break;
	}
	return "";
}  


/**
 * 상세폼이동
 */
function kepEditForm(bid,btype){ 
	$("#BID").val(bid);
	$("#BTYPE").val(btype);
	var action = "";
	if(btype == "EB"){
		action = "/main/sub04/sub04_02ebiz_news_view.do";
	}else{
		action = "/main/sub04/sub04_01notice_view.do";
	}
	$('#board').attr("action", action).submit();
}

//로그인 ID에 대한 추가인증 여부 확인 - 로그인 클릭 시
function getTwoFactorLogin(){
	var user_id = document.loginForm.userId.value;
	var password = document.loginForm.password.value;
	
	if (user_id == "") {
		alert("아이디를 입력하세요");
		document.loginForm.userId.focus();
		return;
	} else if (password == "") {
		alert("비밀번호를 입력하세요");
		document.loginForm.password.focus();
		return;
	}
	var userId = user_id.toUpperCase();
	var pData = { st_user_id : userId };
    kepAjaxCallMain("/login/getTwoFactorInfo.do",pData,"getTwoFactorLogin");
}

//로그인 ID에 대한 추가인증 여부 확인 - 인증서 클릭 시
function getTwoFactorSign(){
	var userId = $("#userId").val().toUpperCase();

	if(userId  == null ||  userId == ""){
		alert("회원아이디를 입력하여 주십시요. \n회원아이디로 사업자등록번호를 체크합니다.");
		document.loginForm.userId.focus();
		return;
	}
	
	var pData = { st_user_id : userId };
    kepAjaxCallMain("/login/getTwoFactorInfo.do",pData,"getTwoFactorSign");
}

//현재 비밀번호 체크
function old_password_check() {
	var userId = $("#userId").val().toUpperCase();
	var password = document.loginForm.password.value;
	
	if (password == "") {
		alert("비밀번호를 입력하세요");
		document.loginForm.password.focus();
		return;
	}
	
	var pData = { userId : userId, st_old_password : password};
	kepAjaxCallMain("<%=sslurl2%>/login/getOldPasswordCheck.do",pData,"getOldPasswordCheck");
}

/* 공동인증서 로그인을 위한 처리 */
function signData()
{
	var userId = $("#userId").val().toUpperCase();
	
	if(userId  == null ||  userId == ""){
        alert("회원아이디를 입력하여 주십시요. \n회원아이디로 사업자등록번호를 체크합니다.");
        document.loginForm.userId.focus();
        return;
     }
	
	//KTNET 공동인증서
 	var pData = { st_user_id : userId };
 	kepAjaxCallMain("/login/getNxTSPKIIRSNo.do",pData,"getNxTSPKIIRSNo");
	
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccessMain(pMethod , response){
	
	if(pMethod == "getNxTSPKIIRSNo"){
 		//사업자 정보 체크
	     var irs_no = $.trim(eval("response.data.IRS_NO"));
    	 if( irs_no == null || irs_no == "" ){
 	        alert(" 사업자번호 정보가 없습니다.");
 	        return;
 	    }
    	 signDataNxTSPKI(irs_no); //KTNET 공동인증서 로그인
     }else if(pMethod == "getCertValidate"){
		if("0000" != response.data.errorCode) {
			alert("유효하지 않은 인증서입니다.\n"+response.data.errorMsg);
			return;
		}else{ 
			//인증성공
			document.loginForm.userId.value =  response.data.userId;
			document.loginForm.pageFlag.value =  "CertLogin";
        	document.loginForm.action = "<%=sslurl%>/login/office_login.do";
   	     	document.loginForm.submit();
		}
     }else if(pMethod == "getTwoFactorLogin"){
		var two_factor_yn = $.trim(eval("response.data.TWO_FACTOR_YN"));
    	 
		if(two_factor_yn == "SY"){
			alert("추가인증 설정 사용자입니다. 비밀번호 입력 후,\n협력사(기업)인증서 로그인을 이용하시기 바랍니다.");
 	        return;
 	    }else{
 	    	actionLogin();
 	    }
     }else if(pMethod == "getTwoFactorSign"){
		var two_factor_sign = $.trim(eval("response.data.TWO_FACTOR_YN"));

		if(two_factor_sign == "SY"){
			old_password_check();
 	    }else{
 	    	signData();
 	    }
     }else if(pMethod == "getOldPasswordCheck"){
		var flag = $.trim(eval("response.flag"));
 		if (flag == 'Y') {
 			signData();
 		}else if (flag == 'N') {
 			alert("추가인증 설정 사용자입니다.\n등록된 패스워드와 일치하지 않습니다.");
 			document.loginForm.password.focus();
 			return;
 		}
     }else if(pMethod == "certKtnetValidate"){//KTNET 인증서
 		//에러가 발생시 에러 표기
 		if(response.data.error != "no_error"){
 			alert(response.data.error);
 			return;
 		}
 		//로그인 처리
 		var userId = $("#userId").val(); 
 		if(document.getElementById("autoLogin").checked == true){
 			setCookie("chkLoginCookie", "Y" ,20);
 			setCookie("saveCookieId", userId ,20);
 		}else{
 			setCookie("chkLoginCookie", "N" ,20);
 			setCookie("saveCookieId", "" ,20);
 		}
 		document.loginForm.userId.value =  response.data.userId;
 		document.loginForm.pageFlag.value =  "CertLogin";
     	document.loginForm.action = "<%=sslurl2%>/login/office_login.do";
      	document.loginForm.submit();
      }
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxErrorMain(pMethod , response) {
	
	if (pMethod == "getCertValidate"){ 
		alert("인증서 검증 중 오류 발생하였습니다.");
			return;
	}else if(pMethod == "getTwoFactorLogin" || pMethod == "getTwoFactorSign"){
		alert("추가인증 여부 확인 중 오류 발생하였습니다.");
		return;
	}else if(pMethod == "getOldPasswordCheck"){
		alert("비밀번호 확인 중 오류 발생하였습니다.");
		return;
	}
}
//KTNET 공동인증서
function signDataNxTSPKI(irs_no) {
    var sessionId = $("#userId").val(); //사용자ID
    var ssn = irs_no; //사업자번호(슛자로만 입력)
    var userInfo = "0"; 
    var options = {};
    nxTSPKI.loginData(sessionId, ssn, userInfo, options, loginDataCompleteCallback);
}
//KTNET 공동인증서 call back
function loginDataCompleteCallback(res) {
    if (res.code == 0) {
        $("#loginData").val(res.data.loginData);
    	//인증서의 유효성 체크(서명된 데이터를 서버에서 처리. )
    	var pData = { loginData : $("#loginData").val(), st_user_id : $("#userId").val()};
        kepAjaxCallMain("/login/certKtnetValidate.do",pData,"certKtnetValidate");
     }else {
        alert("error code = " + res.code + ", message = " + res.errorMessage);
    }
}
</script>
</html>

