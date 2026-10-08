<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" href="/resources/styles/koreab2b_base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/koreab2b.css" type="text/css">
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
<!-- (Header) -->
	<div class="header" >
	<%  if ("2".equals(devReal)) { %>
		<h1 class="logo"><a href="http://<%=request.getServerName() %>" ><img src="/resources/images/b_h1_logo.gif" alt=""></a></h1>
		<%}else{ %>
		<h1 class="logo"><a href="/" ><img src="/resources/images/b_h1_logo.gif" alt=""></a></h1>
		<%} %>
		<form id="loginForm" name="loginForm" method="post">
		<input type = "hidden" id="originData" name = "originData" size="40" >
		<input type = "hidden" id="pageFlag" name = "pageFlag"  value="">
 		<input type = "hidden" id="mainLogin" name = "mainLogin" value="">
        <div class="LoginArea">
        	<c:choose>
	        	<c:when test="${sessionInfo != null }">
	        	<label for="id">아이디 :  </label>${sessionInfo.userId}
				 <a href="javascript:actionLogout();">로그아웃</a>
	        	</c:when>
	        	<c:otherwise>
	        	<a href="javascript:toggleBtn();"><div class="Loginbox">LOGIN</div></a>
				</c:otherwise>
        	</c:choose>
	            <div class="LoginTxt"><a href="javascript:MovePage('<%=httpsurl%>','05', '03_1');">ID/PW찾기│</a><a href="javascript:MovePage('<%=httpurl%>','03', '03');">Q&A </a></div>
	        </div>
        <div id="Login" class="Login" style="display:none">
        	<p style="font-size:12px;"> <input id="autoLogin" name="autoLogin" type="checkbox" style="border:0; width:15px; height:15px; margin-top:3px" onchange="saveCookieId(this.checked)" /> 로그인아이디 저장</p>
        	<p><input style="ime-mode:disabled;" type="text" id="userId" name="userId" title=""  onkeyup="kepToUpper('userId')" onKeyDown="if(event.keyCode == 13){actionLogin();};" placeholder="아이디" value="" /></p>
            <p><input type="password" id="password" name="password" title=""  placeholder="비밀번호"  onKeyDown="if(event.keyCode == 13){actionLogin();};" value=""/></p>
            <a href="javascript:actionLogin();"><p class="BtnBlack">로그인</p></a>
            <a href="javascript:signData();"><p class="BtnGreen">협력사(기업)인증서 로그인</p></a>
            <p class="Sellerlogin">※ <span class="FontRed">개인인증서</span>는 로그인할 수 없습니다.</p>
        </div>
        </form>
    </div>
    <div id="ksign" style="position:absolute; left:0px; top:0px; width:0%; height:0%;display:none;" >
		<object id="CC_Object_id"
		      classid="CLSID:A099920B-630C-426B-91EC-737685CEEE17"
		      width= Document.body.clientWidth
		      height= Document.body.clientHeight>
		</object>
	</div>
    <div class="top-nav" >
        <div id="navList" class="navlist-wrap">
            <div class="navlist clearfix">
                <a href="javascript:MovePage('<%=httpurl%>','01', '01');" class="nav-btn" data-device="#androidItem">회사소개</a>
                <a href="" class="nav-btn" data-device="#androidItem">사업소개</a>
                <a href="" class="nav-btn" data-device="#androidItem">이용안내</a>
                <a href="" class="nav-btn" data-device="#androidItem">정보안내</a>
                <c:choose>
		        	<c:when test="${sessionInfo == null }">
		        		<a href="<%=httpurl%>/mdam/showMasterMdAmMbrcmpyReg.do" class="nav-btn2" >회원가입</a>
		        	</c:when>
        		</c:choose>
            </div>
        </div>
        <div id="expandZone" class="expand active" >
            <div class="download" >
                <div id="androidItem" >
                    <div class="subIMG" ><img src="/resources/images/main/vanner_IMG.jpg" /></div>
                    <div class="sub1" >
                    	<ul>
                        	<li class="subTIT"><a href="javascript:MovePage('<%=httpurl%>','01', '01');">회사소개</a></li>
                            <li><a href="javascript:MovePage('<%=httpurl%>','01', '01');">CEO메세지</a></li>
                        	<li><a href="javascript:MovePage('<%=httpurl%>','01', '02');">개요</a></li>
                            <li><a href="javascript:MovePage('<%=httpurl%>','01', '03');">연혁</a></li>
                            <li><a href="javascript:MovePage('<%=httpurl%>','01', '04');">동반성장활동</a></li>
                            <li><a href="javascript:MovePage('<%=httpurl%>','01', '05');">사회공헌활동</a></li>
                            <li><a href="http://www.ekdp.com/ethics/main/main.asp" target="_blank">윤리경영</a></li>
                            <li><a href="javascript:MovePage('<%=httpurl%>','01', '06');">채용정보</a></li>
                            <li><a href="javascript:MovePage('<%=httpurl%>','01', '07');">오시는길</a></li>
                        </ul>    
                    </div>
                    <div class="sub2">
                    	<ul>
                        	<li class="subTIT"><a href="javascript:MovePage('<%=httpurl%>','02', '01');">사업소개</a></li>
                            <li><a href="javascript:MovePage('<%=httpurl%>','02', '01');">사업모델</a></li>
                        	<li><a href="javascript:MovePage('<%=httpurl%>','02', '02');">MRO특징</a></li>
                            <li><a href="javascript:MovePage('<%=httpurl%>','02', '03');">제공가치</a></li>
                            <li><a href="javascript:MovePage('<%=httpurl%>','02', '04');">구매대행소개</a></li>
                            <li><a href="javascript:MovePage('<%=httpurl%>','02', '05');">건설MRO소개</a></li>
                        </ul>    
                    </div>
                    <div class="sub3">
                    	<ul>
                        	<li class="subTIT"><a href="javascript:MovePage('<%=httpurl%>','03', '01');">이용안내</a></li>
                            <li><a href="javascript:MovePage('<%=httpurl%>','03', '01');">FAQ</a></li>
                        	<li><a href="javascript:MovePage('<%=httpurl%>','03', '03');">Q&A </a></li>
                            <li><a href="javascript:MovePage('<%=httpurl%>','03', '04');">계약서류다운로드</a></li>
                            <li><a href="http://113366.com/koreab2b" target="_blank">원격지원서비스</a></li>
                        </ul>    
                    </div>
                    <div class="sub4">
                    	<ul>
                        	<li class="subTIT"><a href="javascript:MovePage('<%=httpurl%>','04', '01');">정보안내</a></li>
                            <li><a href="javascript:MovePage('<%=httpurl%>','04', '01');">공지사항</a></li>
                        	<!-- <li><a href="javascript:MovePage('<%=httpurl%>','04', '02');">E-Biz뉴스</a></li> -->
                            <!--li><a href="javascript:MovePage('<%=httpurl%>','04', '03');">품목담당자</a></li-->
                            <!-- <li><a href="javascript:MovePage('<%=httpurl%>','04', '04');">고객회원사</a></li> -->
                        </ul>    
                    </div>
                    <div class="sub5">
                    	<ul>
                        	<li class="subTIT"><a href="<%=httpurl%>/mdam/showMasterMdAmMbrcmpyReg.do">회원가입</a></li>
                        </ul>    
                    </div>
                </div>
            </div>
            <div id="closeBtn" class="close-btn"><img src="/resources/images/main/vanner_btn.gif" /></div>
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
	function setCookie(name,value,expiredays) {
		var todayDate = new Date();
		todayDate.setDate(todayDate.getDate() + expiredays);
		document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
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
		    $('#loginForm').attr("action", "<%=sslurl2%>/login/login.do"); 
		    $('#loginForm').submit();
		}
	}
	
	/* 공동인증서 로그인을 위한 처리 */
	function signData()
	{
		var userId = $("#userId").val().toUpperCase();
		
		if(browser == "other"){
	    	 alert("공동인증서는 인터넷 익스플로러 브라우져만 사용가능합니다.");
	    	 return;
	     }
		
		if(userId  == null ||  userId == ""){
	        alert("회원아이디를 입력하여 주십시요. \n회원아이디로 사업자등록번호를 체크합니다.");
	        document.loginForm.userId.focus();
	        return;
	     }
	     
	     //object 존재여부 확인(설치가 안된 client는 수동설치 할 수 있도록 popup띄움)
	     if (document.CC_Object_id.object == null) {
 	    	 window.open( "<%=httpurl%>/module/crosscert/ccc-sample/Object_chk.html" ,"BicImage","width=600,height=470,toolbar=no,location=no,resizable=yes,menubar=no,status=no,scrollbars=yes");
 	    	 return;
 	     }else{
		     //사업자 번호 get(후 처리는 kepAjaxSuccessMain 펑션에서 수행.)
		     var pData = { st_user_id : userId };
		     kepAjaxCallMain("/login/getIRSNo.do",pData,"getIRSNo"); 
 	     }
	}
	
	/**
	 * ajax 공통 호출후 성공시 처리 함수
	 */ 
	function kepAjaxSuccessMain(pMethod , response){
		
		if(pMethod == "getIRSNo"){
			//사업자 정보 체크
		     var irs_no = $.trim(eval("response.data.IRS_NO"));
	    	 
	    	 if( irs_no == null || irs_no == "" ){
	 	        alert(" 사업자번호 정보가 없습니다.");
	 	        return;
	 	    }
	    	 
	    	 //원문data set
	    	 var originData = $.trim(eval("response.data.ORIGIN_DATA"));
			 $("#originData").val(originData);
	 	   
	 	     var ret;
	 	     var signeddata;
	 	     var userdn, getR;
	 	 	
 	    	 // 환경설정 함수 콜
 	    	 initCrosscert();
 		 	// 인증서 선택창 초기화 및 선택된 인증서의 DN 추출
 		 	// DN은 인증기관에서 유니크한 것임.
 		 	userdn = document.CC_Object_id.GetUserDN();
 		 	
 		 	if( userdn == null || userdn == "" ) { 
 				return;
 			} else {

 				signeddata = document.CC_Object_id.SignData( document.loginForm.originData.value, "SHA1", "");
 				
 				if( signeddata == null || signeddata == "" ){
 		            errmsg = document.CC_Object_id.GetErrorContent();
 		            errcode = document.CC_Object_id.GetErrorCode();
 		            alert( "SignData :"+errmsg );
 		            return;
 		        }else{
 		        	getR = document.CC_Object_id.GetRFromKey(userdn, "");
 		        	
 		        	if (getR == ""){
 		                alert("주민/사업자번호를 확인할 수 없는 인증서입니다.");
 		                return;
 		            }
 		            ret = CC_Object_id.ValidCert_VID(userdn, getR, irs_no); //사업자번호 체크
 		            if (ret != "0"){
 		                alert("본인확인에 실패했습니다. 선택한 인증서의 사업자번호와 일치하지 않습니다. \n\n해당 인증기관에 문의하시기 바랍니다.");
 		                return;
 		            }else{
 		            	//인증서의 유효성 체크(서명된 데이터를 서버에서 처리. )
	 		  		     var pData = { signedData : signeddata, getR : getR, ssn : irs_no, userId :  $("#userId").val()};
	 		  		     kepAjaxCallMain("/login/certValidate.do",pData,"getCertValidate"); 
 		            }
 		        }
 			    
 			}
	     
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
	     }
	}
	
	/**
	 * ajax 공통 호출후 에러시 처리 함수
	 */
	function  kepAjaxErrorMain(pMethod , response) {
		
		if (pMethod == "getIRSNo"){ 
			alert("사업자번호 조회 중 오류 발생하였습니다.");
 			return;
		}else if (pMethod == "getCertValidate"){ 
			alert("인증서 검증 중 오류 발생하였습니다.");
 			return;
		}
	} 

	function actionLogout() {
		document.loginForm.action = "<%=httpurl%>/login/logout.do";
		document.loginForm.submit();
	}
	
	function kep_view_link(link){
		window.location.href = "<%=httpurl%>"+link;
	}
	
//-->	
</script>
