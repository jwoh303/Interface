<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" href="/resources/styles/2016_koreab2b_base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/2021_koreab2b.css" type="text/css">
<%
	String sslurl = CommonUtil.getSslURL(request, "http");
	String sslurl2 = CommonUtil.getSslURL(request, "https");
	String devReal = CommonUtil.getDevRealLocalFlag(request);
	String flag = CommonUtil.getDevRealLocalFlag(request);
	String httpurl ="";
	String httpsurl ="";
	if(flag.equals("2")){
/* 		httpurl =  "http"+ "://" + request.getServerName() ;
		httpsurl = "https"+ "://" + request.getServerName() ; */
		httpurl =  "" ;
		httpsurl = "" ;	
	}else{
		httpurl =  "" ;
		httpsurl = "" ;		
	}
%>
<c:if test="${jqueryGbn ne 'Y' }">
    <script src="/resources/libs/jquery/js/jquery-3.6.0.min.js"></script>
</c:if>
<script type="text/javascript" src="/resources/js/kep_main_common.js" ></script>
<script type="text/javascript" src="/resources/js/kep_common.js"></script>
<script type="text/javascript" src="/resources/js/placeholders.min.js"></script>
<script type="text/javascript" src="/module/crosscert/ccc-sample/init.js"></script>

<!-- KTNET 공동인증서 -->
<link rel="stylesheet" href="/resources/styles/nxts/common.css" type="text/css">
<script src="/resources/js/bs-3.3.5/js/bootstrap.js"></script>
<script src="/resources/js/nxts/nxts.min.js"></script>
<script src="/resources/js/nxts/nxtspki_config.js"></script>
<script src="/resources/js/nxts/nxtspki.js"></script>
<!-- (Header) -->
	<div class="header" >
		<h1 class="logo"><a href="/main.do" ><img src="/resources/images/2016/logo.gif" alt=""></a></h1>
        <div class="Gnb">
            <div class="GnbMenu">
            <a href="javascript:MovePage_2016('<%=httpsurl%>','04', '05');">로그인</a>&nbsp;&nbsp;&nbsp;&nbsp;
            <a href="javascript:MovePage_2016('<%=httpurl%>','04', '02');">회원가입</a>&nbsp;&nbsp;&nbsp;&nbsp;
            <a href="javascript:MovePage_2016('<%=httpsurl%>','04', '04');">ID/PW찾기</a>&nbsp;&nbsp;&nbsp;&nbsp;
            <a href="javascript:MovePage_2016('<%=httpurl%>','03', '01');">FAQ</a>&nbsp;&nbsp;&nbsp;&nbsp;
            <a href="http://113366.com/koreab2b" target="_blank">원격지원서비스</a> &nbsp;&nbsp; 
            <a href="javascript:MovePage_2016('<%=httpurl%>','00', '01');"><img src="/resources/images/2016/site_icon.png" style="vertical-align:middle" />&nbsp;KR</p></a>
            </div>
        </div>
    </div>

    <!--202108 메뉴네비-->
    <div class="TopNav"  style="position:relative; width:100%; top:-38px; z-index:5;" >
        <input type="checkbox" class="" id="collapsible"  >
        <label for="collapsible" >
            <div>
                <ul>
                    <li>회사소개</li>
                    <li>사업소개</li>
                    <li>인재채용</li>
                    <li>이용안내</li>
                  </ul>
            </div>
            <p><img src="/resources/images/2016/menu_close.gif" /></p>   
        </label>
        <div id="menuitems" class="menuitems"   >
             <div class="menuitems_1080"  >
                <div class="Msub1" >
                    <ul>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','01', '01');">CEO메시지</a></li>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','01', '02');">개요</a></li>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','01', '03');">연혁</a></li>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','01', '04');">비전</a></li>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','01', '06');">공고</a></li>
                        <li><a href="http://www.ekdp.com/ethics/main/main.asp" target="_blank">윤리경영</a></li>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','01', '05');">오시는길</a></li>
                    </ul>    
                </div>
                <div class="Msub2">
                    <ul>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','02', '01');">MRO구매대행</a></li>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','02', '02');">부자재구매대행</a></li>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','02', '03');">건설MRO소개</a></li>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','02', '04');">해외법인</a></li>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','02', '05');">구매시스템</a></li>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','02', '06');">물류센터</a></li>
                    </ul>    
                </div>
                <div class="Msub3">
                    <ul>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','03', '04');">인재상</a></li>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','03', '05');">인사제도</a></li>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','03', '06');">채용정보</a></li>
                    </ul>    
                </div>
                <div class="Msub4">
                    <ul>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','03', '01');">FAQ</a></li>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','03', '02');">업무처리 프로세스</a></li>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','03', '07');">구매대행 도입문의</a></li>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','04', '01');">신규협력사 가입안내</a></li>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','04', '02');">회원가입하기</a></li>
                        <li><a href="javascript:MovePage_2016('<%=httpurl%>','04', '03');">계약서류 다운로드</a></li>
                    </ul>    
                </div>
             </div>
		</div> 
    </div>




<script type="text/javascript" src="/module/crosscert/ccc-sample/init.js"></script>    
<script type="text/javascript">
<!--
	//ie브라우져 체크
	var agt = navigator.userAgent.toLowerCase();
	var browser;
	if(agt.indexOf("msie") != -1 || agt.indexOf("trident") != -1){
		browser = "ie";
	}else{
		browser = "other";
	}
	function toggleBtn(){
		if ( $("#Login").css("display") == "none" ){
			$("#Login").show();
			Placeholders.enable();
			var chkLoginCookie = getCookie("chkLoginCookie");
			if(chkLoginCookie == "Y" ){
				$("#password").focus();
			}else{
				$("#userId").focus();	
			}			
		}else{
			$("#Login").hide();
		}
	} 


	function actionLogin() {
		var userId = $("#userId").val(); 
		if(document.getElementById("autoLogin").checked == true){
			setCookie("chkLoginCookie", "Y" ,20);
			setCookie("saveCookieId", userId ,20);
		}else{
			setCookie("chkLoginCookie", "N" ,20);
			setCookie("saveCookieId", "" ,20);
		}
		if ($("#userId").val() == "") {
			alert("아이디를 입력하세요");
			$("#userId").focus();
			return;
		} else if ($("#password").val() == "") {
			alert("비밀번호를 입력하세요");
			$("#password").focus();
			return;
		} else {
				$("#userId").val($("#userId").val().toUpperCase());
			$('#loginForm').attr("method", "post");
		    $('#loginForm').attr("action", "/login/login.do"); 
		    $('#loginForm').submit();
		}
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
	function actionLogout() {
		document.loginForm.action = "/login/logout.do";
		document.loginForm.submit();
	}
	
	function kep_view_link(link){
		window.location.href = "<%=httpurl%>"+link;
	}
	
//-->	
</script>
