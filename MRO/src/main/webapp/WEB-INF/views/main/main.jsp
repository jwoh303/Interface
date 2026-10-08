<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!doctype html>
<html>
<head>
</head>
<%
String start_msg = CommonUtil.nvl((String) request.getParameter("start_msg"),"");
%>
<body onLoad="kep_onload_view()"> 
	<div class="wrap"  >

		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp" %>
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<form id="loginForm" name="loginForm" method="post">
		<input type = "hidden" id="originData" name = "originData" size="40" >
		<input type = "hidden" id="pageFlag" name = "pageFlag"  value="">
		<input type = "hidden" id="mainLogin" name = "mainLogin" value="">
 		<input type = "hidden" id="st_user_id" name = "st_user_id" value="">
        <div style="display:none">
        	    <textarea class="form-control" id="loginData" name = "loginData"></textarea>
        </div>
	<script >

        var wnum=0;
        var wwslidingAuto=null;
        function play_w(directw) {	
                if(directw=="right"){
                    wnum++;
                    if(wnum>2)wnum=0;
                }else if(directw=="left"){
                    wnum--;
                    if(wnum<0)wnum=2;
                }else {
                    wnum = directw;
                }
                
                jQuery(".rollingbtn").find('li.seq a').each(function(){
                    jQuery(".rollingbtn li.seq a img").attr('src',jQuery(".rollingbtn li.seq a img").attr('src').replace('_on.png','_off.png'));
                });
                jQuery(".rollingbtn li.butt"+wnum+ " a img").attr('src',jQuery(".rollingbtn li.butt"+wnum+ " a img").attr('src').replace('_off.png','_on.png'));
    
                    if(wnum==0) {
                    jQuery(".viewImgList li.imglist0").animate({'opacity' : 1 },1000);
                    jQuery(".viewImgList li.imglist1").animate({'opacity' : 0 },1000);
                    jQuery(".viewImgList li.imglist2").animate({'opacity' : 0 },1000);
                    $("bannerType").value = "0";
                }else if (wnum==1){
                    jQuery(".viewImgList li.imglist0").animate({'opacity' : 0 },1000);
                    jQuery(".viewImgList li.imglist1").animate({'opacity' : 1 },1000);
                    jQuery(".viewImgList li.imglist2").animate({'opacity' : 0 },1000);
                    $("bannerType").value = "1";
                }else if (wnum==2){
                    jQuery(".viewImgList li.imglist0").animate({'opacity' : 0 },1000);
                    jQuery(".viewImgList li.imglist1").animate({'opacity' : 0 },1000);
                    jQuery(".viewImgList li.imglist2").animate({'opacity' : 1 },1000);
                    $("bannerType").value = "2";
                }
    
                if(wwslidingAuto)clearTimeout(wwslidingAuto);
                wwslidingAuto=setTimeout("play_w('right')",3000);
        }
        var wwslidingAuto=setTimeout("play_w('right')",3000);
    
    jQuery(document).ready(function(){
    
        jQuery(".rollstop").click(function(){
            jQuery(".rollplay").css('display','inline-block');
            if(wwslidingAuto)clearTimeout(wwslidingAuto);	
        });
        jQuery(".rollplay").click(function(){
            jQuery(".rollstop").css('display','inline-block');
            play_w('right');
        });
        jQuery(".rollingbtn li.seq a").each(function(index){
            jQuery(this).click(function(){
                jQuery(".rollstop").css('display','inline-block');
                if(wwslidingAuto)clearTimeout(wwslidingAuto);	
                play_w(index);
            });
        });
    
    });
    </script>   
    <!-- 2018 베너-->
      <div class="visualRoll">
        <ul class="viewImgList">
            <li class="imglist0">
            	<div class="visuaTxt"><img src="/resources/images/2016/banner_txt01.png" /></div>
                <div class="visuaBg" > </div>
                <img src="/resources/images/2016/banner01.jpg">
            </li>
            <li class="imglist1">
            	<div class="visuaTxt"><img src="/resources/images/2016/banner_txt02.png" /></div>
                <div class="visuaBg" > </div>
           		<img src="/resources/images/2016/banner02.jpg">
            </li>
            <li class="imglist2">
            	<div class="visuaTxt"><img src="/resources/images/2016/banner_txt03.png" /></div>
                <div class="visuaBg" > </div>
                <img src="/resources/images/2016/banner03.jpg">
            </li>
        </ul>
        <div class="rollbtnArea">
            <ul class="rollingbtn">
                <li class="seq butt0"><a href="#butt"><img src="/resources/images/2016/BtnPDRoll_on.png"  alt="" />1</a></li>
                <li class="seq butt1"><a href="#butt"><img src="/resources/images/2016/BtnPDRoll_off.png" alt="" />2</a></li>
                <li class="seq butt2"><a href="#butt"><img src="/resources/images/2016/BtnPDRoll_off.png" alt="" />3</a></li>
            </ul> 
        </div>
      </div>
    <!--베너끝-->
    
    
    
    <!--컨텐츠-->
    <div class="contentsArea">
    	<div class="loginbox" style="position: relative">
    	
    	
    			<!-- UI 버전 선택 (화면 오른쪽 상단) -->
		<div id="uiSelect" style="position: absolute; top:35px;  left: -260px; z-index: 1000; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 15px 20px; border-radius: 10px; border: 2px solid #5a67d8; box-shadow: 0 4px 15px rgba(0,0,0,0.2); display: none;">
			<label style="font-size: 16px; font-weight: bold; color: white; margin-right: 10px; text-shadow: 0 1px 2px rgba(0,0,0,0.3);">UI 버전:</label>
			<select name="uiVersion" id="uiVersion" style="font-size: 16px; padding: 8px 12px; border-radius: 6px; border: 2px solid #4c51bf; background: white; color: #2d3748; font-weight: 600; min-width: 120px; cursor: pointer;">
				<option value="original">🔸 원본 화면</option>
				<option value="renewal">✨ 리뉴얼 화면</option>
			</select>
		</div>
    	
    	
    	
            <div class="login">
                  <input id="autoLogin" name="autoLogin" type="checkbox" style="border:0; width:15px; height:15px; margin-top:3px" onChange="saveCookieId(this.checked)" /> 아이디저장<br />
                  <input style="ime-mode:disabled;" type="text" id="userId" name="userId" title=""  onkeyup="kepToUpper('userId')" onKeyDown="if(event.keyCode == 13){getTwoFactorLogin();};" placeholder="아이디" value=""  class="input_text"/>
				  <input type="password" id="password" name="password" title=""  placeholder="비밀번호"  onKeyDown="if(event.keyCode == 13){getTwoFactorLogin();};" value=""  class="input_text" />/>
                  <a href="javascript:getTwoFactorLogin();"><p class="loginBut">로그인</p></a>
                  <a href="javascript:getTwoFactorSign();"><p class="loginBut_seller">협력사 공동 인증서 로그인</p></a>
                  <a href="https://www.tradesign.net/ra/koreab2b" target="_blank"><p class="loginBut_sale">공동인증서 할인발급 안내</p></a> 
              </div>
        </div>
        <div class="value01">
        	<div class="valuebox">
                <a href="javascript:MovePage_2016('<%=httpurl%>','02', '05');"><p class="valuetit">구매시스템</p></a>
                <p class="valuetxt"><img src="/resources/images/2016/br06.gif" style="margin-bottom:5px"/><br />고객 요구를 반영한 다양한 <br />시스템을 통해 고객사의 구매 <br />업무를 안정적으로 지원합니다.  </p>
            </div>
        </div>
        <div class="value02">
        	<div class="valuebox">
                <a href="javascript:MovePage_2016('<%=httpurl%>','02', '06');"><p class="valuetit">물류센터</p></a>
                <p class="valuetxt"><img src="/resources/images/2016/br06.gif" style="margin-bottom:5px"/><br />선진화된 물류정보시스템을 <br />통해 입고, 출고, 반품/교환 등<br />전체 프로세스를 관리하고 있습니다.  </p>
            </div>
        </div>
       
		<div class="ethics">
            <div class="ethicsbox01" > 
                <a href="https://www.ekdp.com/ethics/main/main.do" target="_blank"><p class="ethicstit" >윤리경영제보</p></a><img src="/resources/images/2016/index_img13.png" style="margin:14px 0"/><br />임직원들의 행동과 <br />가치판단의 기준이 됩니다.
            </div>
            <div class="ethicsbox02"> 
                <a href="javascript:MovePage_2016('<%=httpurl%>','03', '06');"><p class="ethicstit">채용정보</p></a><img src="/resources/images/2016/index_img14.png" style="margin:14px 0"/><br />진취적이고 역량 있는<br />인재를모집합니다.
            </div>
        </div>
        
        <div class="newcustomer">
        	<div class="valuebox">
                <a href="javascript:MovePage_2016('<%=httpurl%>','03', '07');"><p class="newcustomertit">신규고객 <br />구매대행 도입문의</p></a>
                <p class="valuetxt"><img src="/resources/images/2016/br06.gif" style="margin-bottom:5px"/><br />최적의 맞춤형 구매대행 <br /> 서비스를 제공해 드립니다. </p> 
            </div>
        </div>        
        
        <div class="cmro">
             <div class="valuebox">
                <a href="javascript:MovePage_2016('<%=httpurl%>','02', '03');"><p class="valuetit">건설MRO</p></a> 
                <p class="valuetxt"><img src="/resources/images/2016/br06.gif" style="margin-bottom:5px"/><br />전국 네트워크 협력사를 통해  <br />가장 경쟁력 있는 서비스를 <br /> 제공합니다. </p>
            </div>    
        </div>
    </div>
</form>
    <!--컨텐츠 끝-->
  
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainFooter.jsp" %>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	</div>
 </body>
<script type="text/javascript">
// UI 버전을 포함한 로그인 처리 함수
function actionLoginWithUIVersion(){
	var uiVersion = $("#uiVersion").val() || "original";
	document.loginForm.action = "/login/login.do";
	// uiVersion을 hidden input으로 추가
	var uiVersionInput = document.createElement("input");
	uiVersionInput.type = "hidden";
	uiVersionInput.name = "uiVersion";
	uiVersionInput.value = uiVersion;
	document.loginForm.appendChild(uiVersionInput);
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
	//리디렉션 오류로 인해 추가인증 체크 임시 해제처리. 리디렉션 관련 오류 없으면 로그인시점에 체크되도록 로직 변경. 현명환 23.02.20
	// 원본: actionLogin(); - UI 버전 선택 기능 추가를 위해 actionLoginWithUIVersion()으로 변경
	actionLoginWithUIVersion();
	return;
	//var pData = { st_user_id : userId }; kepAjaxCallMain 소스콜 문제로 인해 kepAjaxFormCallMain 대체 함. 현명환 22.09.01
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
/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccessMain(pMethod , response){
	
	if(pMethod == "getCertValidate"){
		if("0000" != response.data.errorCode) {
			alert("유효하지 않은 인증서입니다.\n"+response.data.errorMsg);
			return;
		}else{ 
			//인증성공
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
 	    	// 원본: actionLogin(); - UI 버전 선택 기능 추가를 위해 actionLoginWithUIVersion()으로 변경
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
 		//사업자 정보 체크
	     var irs_no = $.trim(eval("response.data.IRS_NO"));
    	 if( irs_no == null || irs_no == "" ){
 	        alert(" 사업자번호 정보가 없습니다.");
 	        return;
 	    }
    	 signDataNxTSPKI(irs_no); //KTNET 공동인증서 로그인
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
</script>
</html>
