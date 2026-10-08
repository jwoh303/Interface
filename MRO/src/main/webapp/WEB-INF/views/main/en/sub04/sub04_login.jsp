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
			<%@ include file="/WEB-INF/views/common/include/en/mainHeader.jsp" %>
			<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
    <div id="ksign" style="position:absolute; left:0px; top:0px; width:0%; height:0%;display:none;" >
		<object id="CC_Object_id"
		      classid="CLSID:A099920B-630C-426B-91EC-737685CEEE17"
		      width= Document.body.clientWidth
		      height= Document.body.clientHeight>
		</object>
	</div>
    <!--컨텐츠-->
<form id="loginForm" name="loginForm" method="post">
		<input type = "hidden" id="originData" name = "originData" size="40" >
		<input type = "hidden" id="pageFlag" name = "pageFlag"  value="">
 		<input type = "hidden" id="mainLogin" name = "mainLogin" value="">
    <div class="subcontentsAreaLogin">
		<div class="subcontent" >
        	<div class="sub04_join">
                <br/><br/>
                <p class="subcontentTit" >LOGIN</p>
                <div class="LoginCheck" style="height:250px;width:650px; margin:auto ">
                    <p style="position:absolute; left:650px; line-height:15px">  <input class="checkbox" id="autoLogin" name="autoLogin" type="checkbox"  onchange="saveCookieId(this.checked)" /> Save ID</p>
                    <br />
                    <ul>
                        <li>ID<input style="ime-mode:disabled;" class="LCinput" type="text" id="userId" name="userId" title=""  onkeyup="kepToUpper('userId')" onKeyDown="if(event.keyCode == 13){actionLogin();};" placeholder="ID" value="" /></li>
                        <li>Password<input type="password" id="password" class="LCinput" name="password" title=""  placeholder="Password"  onKeyDown="if(event.keyCode == 13){actionLogin();};" value=""/></li>
                        <li><div class="LCBtn01" ><a href="javascript:actionLogin();">Log In</a></div></li>
                        <li><div class="LCBtn02" ><a href="javascript:signData();">Log In for vendor(corporate)'s<br /> Authentication Certificate</a></div></li>
                        <li><p class="LCTxt">※ Can't Log In with <span style="color:#ee3212" >Personal Authentication Certificate.</span></li>
                    </ul>
                </div>
                <br/><br/><br/><br/>
            </div>
        </div>
    </div>
</form>
    <!--컨텐츠 끝-->
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/en/mainFooter.jsp" %>
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
} function saveCookieId(chk){
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
</script>
</html>

