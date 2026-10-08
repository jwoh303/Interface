<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.SeedCbcAlgorithmUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    //response.setHeader("Cache-Control","no-store");
    //response.setDateHeader ("Expires", -1);
    //response.setHeader("Pragma","no-cache");

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
	SessionInfo sessionIDInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String bszUserid = "";
	//ID 암호화
	String plainTextStr = "";
	if (sessionIDInfo != null){  
		String st_o_user_id =  "O"+CommonUtil.nvl((String)sessionIDInfo.getUserId());
		byte[] plainText = st_o_user_id.getBytes();
		byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);		
		bszUserid = SeedCbcAlgorithmUtil.getString(bszDigest);
	}  

%>
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
			document.loginForm.action = "/login/login.do";
			document.loginForm.submit();
		}
	}

	function actionLogout() {
		document.loginForm.action = "/login/logout.do";
		document.loginForm.submit();
	}
	
	// 팝업 함수호출
	function goPop(str) {
		switch (str) {
			case "companyMng": // 회원사관리
				openSearchPopup('<%=httpsurl%>/common/misUserSelectAllPop2.do','','500,485,no');
				break;
			case "personalInfo" : // 개인정보
				openSearchPopup('<%=httpsurl%>/mdam/showSellerMdAmUserInfo.do','?moveToMaster=Y','1000,600,no');
				break;
		}
	}
	
	
	function goLoginSubmit()
	{ 
		//ID암호화
		var plainId= "<%=bszUserid%>";
	    document.ssoHeaderLogin.userId.value = plainId;
		
	    $('#ssoHeaderLogin').attr("action", "<%=sslurl2%>/login/office_login.do").submit();      
	}

	
	function kep_view_link(link){
		window.location.href = link;
	}
	 
//-->
</script>
<!-- 나의주요업무처리 레이어팝업-->
<%@ include file="/WEB-INF/views/master/mdam/masterMdAmProxyMainWorkProcess.jsp" %>
 <form name="ssoHeaderLogin" id="ssoHeaderLogin" method="post">
			<input type="hidden" name="userId" id="userId" value="" /> 
			<input type="hidden" name="password" id="password" value="" /> 
</form>
<form name="loginForm" method="post">
	<div id="headerWrapMain">
    	<div id="header">
        	<div id="header_globalArea">
					<!--로그인후-->
					<c:choose>
						<c:when test="${sessionInfo != null }">
						<ul class="header_topGmenu">
							<c:choose>
								<c:when test="${sessionInfo.userAuth eq 'ROLE_WMS'}">
									<li class="first"><a href="/mdam/getMasterMdAmWmsHome.do">운영사홈&nbsp;&nbsp;l</a></li>
			                    	<li><a href='/mdam/getMasterMdAmWmsHome.do'>구매대행홈&nbsp;&nbsp;|</a></li>
			                    </c:when>
			                    <c:when test="${sessionInfo.userAuth eq 'ROLE_WMS_GJ'}">
									<li class="first"><a href="/mdam/getMasterMdAmWmsHome.do">운영사홈&nbsp;&nbsp;l</a></li>
			                    	<li><a href='/mdam/getMasterMdAmWmsHome.do'>구매대행홈&nbsp;&nbsp;|</a></li>
			                    </c:when>
			                    <c:otherwise>
							        <li class="first"><a href="/masterMain.do">운영사홈&nbsp;&nbsp;l</a></li>
				                    <li><a href='/mdam/getMasterMdAmProxyHome.do?upperId=m00200000000'>구매대행홈&nbsp;&nbsp;|</a></li>
								</c:otherwise>
							</c:choose>
			                    <li><a href="javascript:goPop('companyMng');">회원사관리&nbsp;&nbsp;|</a></li>
			                    <li><a href="javascript:goPop('personalInfo');">개인정보&nbsp;&nbsp;|</a></li>
			                    <li class="last"><a href="javascript:actionLogout();"><b>로그아웃</b></a></li>
<!-- 			                    <li class="last"><a href='javascript:tab("고객카드관리","/mdcd/showMasterMdCdBuyerCardManage.do")'>고객카드관리</a></li> -->
			                    
			                   
						</ul>
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
            
            <c:choose>
				<c:when test="${sessionInfo.userAuth eq 'ROLE_WMS'}">
					<h1><a href="/mdam/getMasterMdAmWmsHome.do"><img src="/resources/images/m_h1logo01.gif" alt="kep구매대행로고" /></a></h1>
				</c:when>
				<c:when test="${sessionInfo.userAuth eq 'ROLE_WMS_GJ'}">
					<h1><a href="/mdam/getMasterMdAmWmsHome.do"><img src="/resources/images/m_h1logo01.gif" alt="kep구매대행로고" /></a></h1>
				</c:when>
				<c:otherwise>
					<h1><a href="/masterMain.do"><img src="/resources/images/m_h1logo01.gif" alt="kep구매대행로고" /></a></h1>
				</c:otherwise>
			</c:choose>
            
            <c:choose>
						<c:when test="${sessionInfo != null }">
           				 <p class="name"> 최종접속: ${sessionInfo.lastLoginDate} | ${sessionInfo.comNameLoc} (${sessionInfo.departmentName})  ${sessionInfo.userNameLoc} [<span class="black">${sessionInfo.userId}</span>] 님</p>
            			</c:when>
						<c:otherwise> 
						</c:otherwise>
			</c:choose>
            <!--메뉴부분-->
            <div id="header_gnbAreaMain" >  
                   <%= request.getAttribute("menu") %>  
            </div>
        </div>
    </div>
</form>
