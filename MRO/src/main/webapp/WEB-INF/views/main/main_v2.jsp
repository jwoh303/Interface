<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="keywords" content="" />
<meta name="description" content="" />
<title>코리아이플랫폼</title>

<%@ include file="/WEB-INF/views/common/include/mainHeader_v2.jsp" %>

<link rel="stylesheet" href="/resources/styles/nxts/common.css" type="text/css" />
<script src="/resources/js/nxts/nxts.min.js"></script>
<script src="/resources/js/nxts/nxtspki_config.js"></script>
<script src="/resources/js/nxts/nxtspki.js"></script>
<style type="text/css">
/* 가입여부 확인 팝업 스타일 보완 */
.input42{height:38px; line-height:38px; padding:0 10px; color:#24252B; font-size:16px; letter-spacing:-0.2px; font-weight:400; border:1px solid #DEDEDE; border-radius:6px; text-align:center}
.UserCheckBoxIn-Popup{text-align:center; font-size:16px; font-weight:700; line-height:28px; border-top:1px solid #E5E5E5; color:#090A10}
.UserCheckBoxIn-Popup img{width:24px; height:24px; margin-right:8px; vertical-align:middle}
.UserCheckBoxIn-Popup.notRegistered{color:#C82626}

</style>
</head>
<body onLoad="kep_onload_view()">
<div class="wrap">
<div class="CompanySite"><a href="https://company.koreab2b.com" target="_blank"><img src="/resources/imgs/CompanySite.jpg"></a></div>
	<!-- 컨텐츠 -->
    <div class="containerBox">

      <div class="ComMainBannerBox">
        <div class="ComMainBanner">
		  <div class="Sentence">더 쉽고, 더 빠르게,<br/>기업 간 거래의 새로운 시작</div>
		  <div class="LoginBox">
<form id="loginForm" name="loginForm" method="post">
		<input type="hidden" id="originData" name="originData" size="40" />
		<input type="hidden" id="pageFlag" name="pageFlag" value="" />
		<input type="hidden" id="mainLogin" name="mainLogin" value="" />
		<input type="hidden" id="st_user_id" name="st_user_id" value="" />
		<input type="hidden" id="uiVersion" name="uiVersion" value="renewal" />
		<div style="display:none">
			<textarea class="form-control" id="loginData" name="loginData"></textarea>
		</div>

            <div class="LoginArea">
              <div class="h50"></div>
              <div class="LoginInput">
                <input style="width:235px" id="userId" name="userId" type="text" placeholder="아이디"
                       onkeyup="kepToUpper('userId')"
                       onKeyDown="if(event.keyCode==13){getTwoFactorLogin();}" />
                <button type="button" onclick="$('#userId').val('')"></button>
              </div>
              <div class="h10"></div>
              <div class="LoginInput">
                <input style="width:275px" id="password" name="password" type="password" placeholder="패스워드"
                       onKeyDown="if(event.keyCode==13){getTwoFactorLogin();}" />
              </div>
              <div class="LoginIDSave">
                <label class="IDSaveLabel" style="margin:0px">
                  <input type="checkbox" id="autoLogin" name="autoLogin" onChange="saveCookieId(this.checked)" />
                  <span class="IDSaveCustom"></span>아이디저장
                </label>
              </div>
              <div class="h10"></div>
              <div class="LoginBut">
                <button type="button" class="ComLoginBut" onclick="getTwoFactorLogin()">로그인</button>
                <button type="button" class="ComLoginCerBut" onclick="getTwoFactorSign()">인증서 로그인</button>
              </div>
              <div class="h20"></div>
              <div class="LoginInfo">
              	<ul>
                  <li onclick="location.href='<%=httpsurl%>/main/sub04/sub04_idpw_search_v2_2016.do'">아이디 찾기</li>
                  <li onclick="location.href='<%=httpsurl%>/main/sub04/sub04_idpw_search_v2_2016.do'">비밀번호 찾기</li>
                  <li onclick="openIrsCheckPopup()">가입여부 확인</li>
                </ul>
              </div>
              <div class="h50"></div>
              <button type="button" class="JoinBuyer" onclick="location.href='/main/renewal_buyer_join.do'">고객사 회원가입</button>
              <div class="h5"></div>
              <button type="button" class="JoinSeller" onclick="location.href='/main/renewal_seller_join.do'">협력사 회원가입</button>
            </div><!-- LoginArea 끝 -->
</form>
          </div><!-- LoginBox 끝 -->
        </div><!-- ComMainBanner 끝 -->

        <div class="ComMainBannerImg"></div>
	  </div> <!-- ComMainBannerBox 끝 -->

      <div class="h50"></div>
	  <div class="ComContainer">
        <div class="ComBoard">
          <div class="ComBoardBox" onclick="location.href='/main/renewal_buyer_join.do'">
          	<div class="ComBoardTit">고객사 가입안내 <button class="ShortcutBut">바로가기</button></div>
            <div class="ComBoardTxt">복잡한 구매 과정을 더 쉽고 빠르게, <br/>고객사 실무에 최적화된 서비스를 제공합니다.</div>
          </div>
          <div class="ComBoardBox" onclick="location.href='/main/renewal_seller_join.do'">
            <div class="ComBoardTit">협력사 가입안내 <button class="ShortcutBut">바로가기</button></div>
            <div class="ComBoardTxt">다양한 고객사와의 거래를 통해 <br/>안정적인 매출 성장을 경험해보세요.</div>
          </div>
          <div class="ComBoardBox" onclick="location.href='/main/renewal_faq.do'">
            <div class="ComBoardTit">자주 묻는 질문<button class="ShortcutBut">바로가기</button></div>
            <div class="ComBoardTxt">로그인, 가입, 거래 관련 궁금증을<br/> 빠르게 해결해보세요.</div>
          </div>
        </div>
        <div class="h50"></div>
        <div class="ComBanner">
          <div class="ComBannerBox" onclick="window.open('https://company.koreab2b.com/_Renewal_main/html/sub02_mro.html', '_blank')">
          	<div class="ComBoardTit">취급품목 </div>
            <div class="ComBoardTxt">15,000여 개의 협력사 네트워크를 기반으로 <br/>기업에서 필요한 다양한 품목을 제공합니다.</div>
          </div>
          <div class="ComBannerBox" onclick="window.open('https://company.koreab2b.com/_Renewal_main/html/sub04_logistics.html', '_blank')">
          	<div class="ComBoardTit">물류 시스템 </div>
            <div class="ComBoardTxt">전국 주요 거점의 5개 물류센터와 80여 개 전문 네트워크를 통해<br/> 통합 배송과 신속한 물류 대응 서비스를 제공합니다.</div>
          </div>
        </div>
        <div class="h80"></div>
	  </div><!-- ComContainer 끝 -->

	</div> <!-- containerBox 끝 -->

    <%@ include file="/WEB-INF/views/common/include/mainFooter_v2.jsp" %>

</div><!-- wrap 끝 -->

<!-- 가입여부 확인 팝업 -->
<div class="DIVpopup-overlay" id="irsCheck-overlay"></div>
<div class="DIVpopup" id="irsCheck" style="width:550px">
  <div class="wrapPopup">
    <div class="PopupTit">회원가입 여부 확인<span><a href="#" onclick="closeIrsCheckPopup(); return false;"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
    <div class="Popup_GrayBox">기존 등록된 회원사인지 확인하기 위해, 귀사의 사업자등록 번호를 입력해주세요.</div>
    <div class="mt10" style="text-align:center">
      <input class="input42" style="width:80px" id="irs_no1" maxlength="3" type="text" placeholder="000" onkeyup="kepNumcheck(this); autoTabIrs(this, 'irs_no2', 3);" />
      <span style="font-weight:bold"> - </span>
      <input class="input42" style="width:80px" id="irs_no2" maxlength="2" type="text" placeholder="00" onkeyup="kepNumcheck(this); autoTabIrs(this, 'irs_no3', 2);" />
      <span style="font-weight:bold"> - </span>
      <input class="input42" style="width:80px" id="irs_no3" maxlength="5" type="text" placeholder="00000" onkeyup="kepNumcheck(this);" onkeydown="if(event.keyCode==13){checkIrsNo();}" />
      <button class="ButDarkGray_Medium" style="width:100px" onclick="checkIrsNo()">확인</button>
    </div>
    <div id="irsCheckResult" class="UserCheckBoxIn-Popup mt20 pt20" style="display:none;"></div>
  </div>
</div>

</body>

<script type="text/javascript">
// UI 버전을 포함한 로그인 처리 함수
function actionLoginWithUIVersion(){
	document.loginForm.action = "/login/login.do";
	document.loginForm.submit();
}

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

	if("<%=start_msg%>" == "Y"){
		alert("메인화면의 로그인 버튼을 이용하여 접속하여 주시기 바랍니다.");
	}

	var cookieUserId = getCookie("saveCookieId");
	var chkLoginCookie = getCookie("chkLoginCookie");
	if(chkLoginCookie == "Y" ){
		$("#userId").val(cookieUserId);
		document.getElementById("autoLogin").checked = true;
	}
    nxTSPKI.onInit(function(){
        //nxTSPKI.init 함수 완료 후 실행해야 하는 함수나 기능 작성 위치
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

//로그인 ID에 대한 추가인증 여부 확인 - 로그인 클릭 시
function getTwoFactorLogin(){
	var user_id = document.loginForm.userId.value;
	var password = document.loginForm.password.value;
	// 모바일 접속 체크
	var agent = "win16|win32|win64|macintel|mac";
	if(agent.indexOf(navigator.platform.toLowerCase())<0){
		alert("현재 모바일 접속입니다.\n모바일 환경에서 발생하는 문제는 지원이 불가하오니\n정상적인 기능을 위해 PC로 접속바랍니다.");
	}

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
	if(document.getElementById("autoLogin").checked == true){
		setCookie("chkLoginCookie", "Y" ,20);
		setCookie("saveCookieId", userId ,20);
	}else{
		setCookie("chkLoginCookie", "N" ,20);
		setCookie("saveCookieId", "" ,20);
	}
	document.loginForm.st_user_id.value = user_id;
	actionLoginWithUIVersion();
	return;
	kepAjaxFormCallMain("/login/getTwoFactorInfo.do","loginForm","getTwoFactorLogin");
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

//KTNET 공동인증서
function signDataNxTSPKI(irs_no) {
    var sessionId = $("#userId").val();
    var ssn = irs_no;
    var userInfo = "0";
    var options = {};
    nxTSPKI.loginData(sessionId, ssn, userInfo, options, loginDataCompleteCallback);
}
//KTNET 공동인증서 call back
function loginDataCompleteCallback(res) {
    if (res.code == 0) {
        $("#loginData").val(res.data.loginData);
    	var pData = { loginData : $("#loginData").val(), st_user_id : $("#userId").val()};
        kepAjaxCallMain("/login/certKtnetValidate.do",pData,"certKtnetValidate");
     }else {
        alert("error code = " + res.code + ", message = " + res.errorMessage);
    }
}

// 가입여부 확인 팝업 열기
function openIrsCheckPopup() {
	document.getElementById("irs_no1").value = "";
	document.getElementById("irs_no2").value = "";
	document.getElementById("irs_no3").value = "";
	document.getElementById("irsCheckResult").style.display = "none";
	document.getElementById("irsCheck").style.display = "block";
	document.getElementById("irsCheck-overlay").style.display = "block";
	document.getElementById("irs_no1").focus();
}

// 가입여부 확인 팝업 닫기
function closeIrsCheckPopup() {
	document.getElementById("irsCheck").style.display = "none";
	document.getElementById("irsCheck-overlay").style.display = "none";
}

// 사업자등록번호 자동 탭 이동
function autoTabIrs(el, nextId, maxLen) {
	if (el.value.length >= maxLen) {
		document.getElementById(nextId).focus();
	}
}

// 사업자등록번호 가입여부 조회
function checkIrsNo() {
	var n1 = document.getElementById("irs_no1").value;
	var n2 = document.getElementById("irs_no2").value;
	var n3 = document.getElementById("irs_no3").value;

	if (n1.length < 3 || n2.length < 2 || n3.length < 5) {
		alert("사업자등록번호를 정확히 입력해주세요.");
		return;
	}

	var irsNo = n1 + "-" + n2 + "-" + n3;
	var pData = { st_irs_no: irsNo };
	kepAjaxCallMain("/mdam/getMasterMdAmMbrcmpyIrsCheck.do", pData, "checkIrsNo");
}

// 오버레이 클릭 시 팝업 닫기
document.getElementById("irsCheck-overlay").onclick = function() {
	closeIrsCheckPopup();
};

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccessMain(pMethod , response){

	if(pMethod == "getCertValidate"){
		if("0000" != response.data.errorCode) {
			alert("유효하지 않은 인증서입니다.\n"+response.data.errorMsg);
			return;
		}else{
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
     }else if(pMethod == "getTwoFactorLogin"){
		var two_factor_yn = $.trim(eval("response.data.TWO_FACTOR_YN"));

		if(two_factor_yn == "SY"){
			alert("추가인증 설정 사용자입니다. 비밀번호 입력 후,\n협력사 공동 인증서 로그인을 이용하시기 바랍니다.");
 	        return;
 	    }else{
 	    	actionLoginWithUIVersion();
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
     }else if(pMethod == "getNxTSPKIIRSNo"){
	     var irs_no = $.trim(eval("response.data.IRS_NO"));
    	 if( irs_no == null || irs_no == "" ){
 	        alert(" 사업자번호 정보가 없습니다.");
 	        return;
 	    }
    	 signDataNxTSPKI(irs_no);
     }else if(pMethod == "certKtnetValidate"){
		if(response.data.error != "no_error"){
			alert(response.data.error);
			return;
		}
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
     }else if(pMethod == "checkIrsNo"){
		var cnt = parseInt(response.data.CNT);
		var resultDiv = document.getElementById("irsCheckResult");
		resultDiv.style.display = "block";

		if (cnt > 0) {
			var sellerYn = response.data.SELLER_YN;
			var buyerYn = response.data.BUYER_YN;
			var typeMsg = "";
			if (sellerYn == "Y" && buyerYn == "Y") typeMsg = " (협력사, 고객사)";
			else if (sellerYn == "Y") typeMsg = " (협력사)";
			else if (buyerYn == "Y") typeMsg = " (고객사)";

			resultDiv.className = "UserCheckBoxIn-Popup mt20 pt20";
			resultDiv.innerHTML = '<img src="/resources/imgs/Check_blue_big.png" />등록된 회원사 입니다.' + typeMsg;
		} else {
			resultDiv.className = "UserCheckBoxIn-Popup mt20 pt20 notRegistered";
			resultDiv.innerHTML = '<img src="/resources/imgs/Icon_Importance04.png" />신규 가입을 해주세요.';
		}
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
	}else if(pMethod == "checkIrsNo"){
		alert("가입여부 확인 중 오류가 발생하였습니다.");
		return;
	}
}
</script>
</html>
