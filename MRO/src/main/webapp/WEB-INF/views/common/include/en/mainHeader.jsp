<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" href="/resources/styles/2016_koreab2b_base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/2016_en_koreab2b.css" type="text/css">
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
	<script type="text/javascript" src="/resources/libs/jquery/js/jquery-1.9.0.min.js"></script>
	<script type="text/javascript" src="/resources/libs/jquery/js/jquery.superslide.2.1.1.js" ></script>
</c:if>
<script type="text/javascript" src="/resources/js/kep_main_common.js" ></script>
<script type="text/javascript" src="/resources/js/kep_en_main_common.js" ></script>
<script type="text/javascript" src="/resources/js/kep_common.js"></script>
<script type="text/javascript" src="/resources/js/placeholders.min.js"></script>
<script type="text/javascript" src="/module/crosscert/ccc-sample/init.js"></script>
<!-- (Header) -->
	<div class="header" >
		<h1 class="logo"><a href="/main/main_en.do" ><img src="/resources/images/2016/logo_en.gif" alt=""></a></h1>
        <div class="Gnb">
            <div class="GnbMenu">
            <a href="javascript:EnMovePage('<%=httpsurl%>','04', '01');">LOGIN</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <a href="/" ><img src="/resources/images/2016/site_icon.png" style="vertical-align:middle" /> KOREAN</a>
            </div>
        </div>
    </div>
    <!--메뉴-->
    <div class="top-nav" >
        <div id="navList" class="navlist-wrap">
            <div class="navlist clearfix">
                <a href="" class="nav-btn" data-device="#androidItem">About us</a>
                <a href="" class="nav-btn" data-device="#androidItem">Our business</a>
                <a href="" class="nav-btn" data-device="#androidItem">Recruitment</a>
            </div>
        </div>
        <div id="expandZoneEn" class="expand active" >
          <div class="download" >
                <div id="androidItem" >
                    <div class="sub1" >
                        <ul>
                            <li class="sub1TIT">About us</li>
                            <li><a href="javascript:EnMovePage('<%=httpurl%>','01', '02');">Overview</a></li>
                            <li><a href="javascript:EnMovePage('<%=httpurl%>','01', '03');">History</a></li>
                            <li><a href="javascript:EnMovePage('<%=httpurl%>','01', '04');">Vision</a></li>
                            <li><a href="javascript:EnMovePage('<%=httpurl%>','01', '05');">Directions</a></li>
                        </ul>    
                    </div>
                    <div class="sub2">
                        <ul>
                            <li class="sub1TIT">Our business</li>
                            <li><a href="javascript:EnMovePage('<%=httpurl%>','02', '01');">MRO Procurement Service</a></li>
                            <li><a href="javascript:EnMovePage('<%=httpurl%>','02', '02');">Subsidiary Materials Procurement Service</a></li>
                            <li><a href="javascript:EnMovePage('<%=httpurl%>','02', '03');">Construction MRO Introduction</a></li>
                            <li><a href="javascript:EnMovePage('<%=httpurl%>','02', '04');">Overseas Corporate</a></li>
                            <li><a href="javascript:EnMovePage('<%=httpurl%>','02', '05');">Procurement System</a></li>
                            <li><a href="javascript:EnMovePage('<%=httpurl%>','02', '06');">Distribution Center</a></li>
                        </ul>    
                    </div>
                    <div class="sub3">
                        <ul>
                            <li class="sub1TIT">Recruitment</li>
                            <li><a href="javascript:EnMovePage('<%=httpurl%>','03', '01');">Qualification for Talented Person</a></li>
                            <li><a href="javascript:EnMovePage('<%=httpurl%>','03', '02');">Personnel Management System</a></li>
                            <li><a href="javascript:EnMovePage('<%=httpurl%>','03', '03');">Recruitment Information</a></li>
                        </ul>    
                    </div>
                </div>
            </div>
            <div id="closeBtn" class="close-btn"><img src="/resources/images/2016/menu_close.gif" /></div>
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
