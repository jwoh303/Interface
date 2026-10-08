<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
	String h_sslurl = CommonUtil.getSslURL(request, "http");
	String h_sslurl2 = CommonUtil.getSslURL(request, "https");
	String h_devReal = CommonUtil.getDevRealLocalFlag(request);
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
<form name="loginForm" method="post">
	<div id="headerWrap">
    	<div id="header">
        	<div id="header_globalArea">
					<!--로그인후-->
					<c:choose>
						<c:when test="${sessionInfo != null }">
						</c:when>
						<c:otherwise>
						<!--로그인전-->
						<ul class="header_topGmenu" >
							<li class="first"><label for="id">아이디</label> <input type="text" id="userId" name="userId" class="input_type_text" title="" style="width: 60px;" value="BJSU"/></li>
							<li class="first"><label for="id">비밀번호</label> <input type="password" id="password" name="password" class="input_type_text" title="" style="width: 60px;" value="314731633215298"/></li>
							<li class="first"><a href="javascript:actionLogin();">로그인</a></li>
						</ul>
						</c:otherwise>
					</c:choose>
            </div>
            <h1><a href="<%=h_sslurl%>/main.do"><img src="/resources/images/m_h1logo01.gif" alt="kep구매대행로고" /></a></h1>
            <c:choose>
						<c:when test="${sessionInfo != null }">
           				 <p class="name">${sessionInfo.comNameLoc} (${sessionInfo.departmentName})   ${sessionInfo.userNameLoc} [<span class="black">${sessionInfo.userId}</span>] 님&nbsp;&nbsp;l&nbsp;&nbsp;
           				 <a href="javascript:actionLogout();"><b>로그아웃</b></a>&nbsp;&nbsp;&nbsp;&nbsp;
           				  </p>
            			</c:when>
						<c:otherwise> 
						</c:otherwise>
			</c:choose>
            <!--메뉴부분-->
            <div id="header_gnbArea">
           <%= request.getAttribute("menu") %>
            </div>
        </div>
    </div>
</form>
<c:if test="${jqueryGbn ne 'Y' }">
	<script type="text/javascript" src="/resources/libs/jquery/js/jquery.superslide.2.1.1.js" ></script>
</c:if>
<script type="text/javascript">
<!--
	function actionLogin() {
		if (document.loginForm.userId.value == "") {
			alert("아이디를 입력하세요");
			return;
		} else if (document.loginForm.password.value == "") {
			alert("비밀번호를 입력하세요");
			return;
		} else {
			document.loginForm.action = "<%=httpsurl%>/login/login.do";
			document.loginForm.submit();
		}
	}

	function actionLogout() {
		document.loginForm.action = "/login/logout.do";
		document.loginForm.submit();
	}
	
	function kep_view_link(link){
		if (link.indexOf("#")>=0){
			return;
		}
		if (link.indexOf("showSellerMdCtMbrCmpyInfo") > 0){
			window.location.href = "<%=httpsurl%>"+link;
		}else{
			window.location.href = "<%=httpurl%>"+link;	
		}
	}
	
//-->
</script>
