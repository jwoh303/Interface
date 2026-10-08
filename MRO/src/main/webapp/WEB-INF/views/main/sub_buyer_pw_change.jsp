<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<link rel="stylesheet" href="/resources/styles/koreab2b_base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/koreab2b.css" type="text/css">
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script type="text/javascript" src="/resources/js/kep_common.js"></script>
<%
String sslurl2 = CommonUtil.getSslURL(request, "https");
String userId = CommonUtil.nvl((String) request.getAttribute("userId"),"");
String comCode = CommonUtil.nvl((String) request.getAttribute("comCode"),"");
%>
<script type="text/javascript">
var create_flag ="C";

function nextTime(){ 
	$("#form").attr("action","/login/login.do").submit();
}//end function

// 현재 비밀번호 체크
function old_password_check() {
    kepAjaxFormCall("<%=sslurl2%>/login/getOldPasswordCheck.do","form","getOldPasswordCheck");
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "getOldPasswordCheck"){
		var flag = $.trim(eval("response.flag"));
		if (flag == 'Y') {
			$('#pw_check').html('<li style="height:10px;"><p class="FontRed">등록된 패스워드와 일치 합니다.</p></li>');
			$("#oldPwdCheck").val("Y");
		} else if (flag == 'N') {
			$('#pw_check').html('<li style="height:10px;"><p class="FontRed">등록된 패스워드와 일치하지 않습니다.</p></li>');
			$("#oldPwdCheck").val("N");
		}

	}else if(pMethod == "setUserPwdUpdate"){
		create_flag = "C";
		var msg = $.trim(eval("response.msg"));
		if(msg == "ERR_MATCH"){
			alert("현재 비밀번호를 확인해주세요.");
			$("#st_old_password").focus();
			return;
		}else{
			alert($.trim(eval("response.msg")));
			nextTime();	
		}
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "getOldPasswordCheck"){ 
		alert('현재 비밀번호 확인중 오류가 발생하였습니다.\n관리자에게 문의하여 주시기 바랍니다.');
		$("#oldPwdCheck").val("N");
	
	}else if(pMethod == "setUserPwdUpdate"){
		create_flag = "C"; 
		alert(" 패스워드 수정에 실패 하였습니다. \n\n 담당자에게 연락 바랍니다.  ");
		return;
	}
}

// 현재 비밀번호 입력시 무조건 체크 flag N으로 셋팅
function checkFlagOnlyN() {
	$("#oldPwdCheck").val("N");
}

// 확인 버튼
// 패스워드 변경
function pwChange() {

	if(create_flag !="C"){
		alert("작업중 입니다.");
		return;
	}
    
	if (passwordvalidCheck()) {
		if (confirm('수정 하시겠습니까?')) {
	 		create_flag = "N";
	 		kepAjaxFormCall("<%=sslurl2%>/login/setUserPwdUpdate.do","form","setUserPwdUpdate");
		}
	}
}


/*---------------------------------------------------
*
* 패스워드 유효성 검사.
*
----------------------------------------------------*/
function checkpassword( ){ 
	
   var pUserId = "userId";
   var pPwd1   = "st_password";
   var pPwd2   = "password";

   var comp  = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

   var uId = document.getElementsByName(pUserId)[0].value;
   var pw1 = document.getElementsByName(pPwd1)[0].value;
   var pw2 = document.getElementsByName(pPwd2)[0].value;

   var invalid = " ";    
   var minLength = 6;
   
   if (pw1 == '' && pw2 == '') { 
       alert('비밀번호를 확인해주세요!');       
       return false; 
   } 
  
   if (uId == pw1) { 
       alert('ID 와 패스워드가 동일합니다. 비밀번호를 확인해주세요!'); 
       document.getElementsByName(pPwd1)[0].value = "";
       document.getElementsByName(pPwd2)[0].value = "";
       document.getElementsByName(pPwd1)[0].focus();  
       return false; 
   } 
  
   if ((pw1 != pw2 ) && pw2 != '' ) { 
       alert('변경할 비밀번호와 다릅니다. 비밀번호를 확인해주세요!'); 
       document.getElementsByName(pPwd2)[0].value = "";
       document.getElementsByName(pPwd2)[0].focus();                
       return false; 
   }     
    
   if (document.getElementsByName(pPwd1)[0].value.indexOf(invalid) > -1) { 
       alert("공백은 입력할 수 없습니다."); 
       document.getElementsByName(pPwd1)[0].value = "";
       document.getElementsByName(pPwd2)[0].value = "";
       document.getElementsByName(pPwd1)[0].focus();         
       return false; 
   }

   var len = pw1.length;
   /* for(i=0;i<len;i++){
       if(comp.indexOf(pw1.substring(i,i+1)) < 0){
           alert("허용된 문자가 아닙니다. \n\n ※영문(대,소문자), 숫자만 입력 가능합니다.");
			document.getElementsByName(pPwd1)[0].value = "";
			document.getElementsByName(pPwd2)[0].value = "";
			document.getElementsByName(pPwd1)[0].focus();  
			return false; 
       }
   } 장민기 주임 변경사항 적용 2014-09-26 */
   if (!pass_check(pw1)) {  
       document.getElementsByName(pPwd1)[0].value = "";
       document.getElementsByName(pPwd2)[0].value = "";
       document.getElementsByName(pPwd1)[0].focus();  
       return false; 
   }  
   if(!pass_valid_check(pw1)) {
       document.getElementsByName(pPwd1)[0].value = "";
       document.getElementsByName(pPwd2)[0].value = "";
       document.getElementsByName(pPwd1)[0].focus();         
       return false; 
   }    
}

// 패스워드 유효성 체크
function pass_check(pwd){
    var eng_flag = false;
    var num_flag = false;
	var pwdLength = pwd.length ; 

	if(pwdLength < 8){
		 alert('영문,숫자 조합 최소 8자리 이상이어야 합니다.');  
        return false;  
	}
   
    for(i=0; i < pwdLength; i++){
        var t_pass = parseInt(pwd.charCodeAt(i)) ; 
		if( t_pass >= 48 && t_pass <= 57  ) {
			num_flag = true;
		}else if( (t_pass >= 65 && t_pass <= 90) || (t_pass >= 97 && t_pass <= 122)  ){
			eng_flag = true; 
		}
	}

/*	if(eng_flag && !num_flag && pwdLength < 8){
			alert('영문만 사용할 경우 최소 8자리 이상이어야 합니다.');   
			return false;   
	}  장민기 주임 변경사항 적용 2014-09-26*/

	if(!eng_flag && num_flag){
			alert('숫자만으로 입력할수 없습니다.');   
			return false;   
	}
	return true;   
}

//패스워드 유효성 체크
function pass_valid_check(pwd){
    var cnt=0, cnt2=1, cnt3=1; cnt4=1;
    var temp="";
   
    for(i=0;i < pwd.length;i++){
        temp_pass1 = pwd.charAt(i);
        next_pass = (parseInt(temp_pass1.charCodeAt(0))) + 1;
        Re_pass = (parseInt(temp_pass1.charCodeAt(0))) + 1;
        temp_p = pwd.charAt(i + 1);
        temp_p2 = pwd.charAt(i - 1);  //역순
        temp_pass2 = (parseInt(temp_p.charCodeAt(0)));
        temp_pass3 = (parseInt(temp_p2.charCodeAt(0)));
       
		if (temp_pass2 == next_pass) {
			cnt2 = cnt2 + 1;
		} else {
			cnt2 = 1;
		} 
		if (temp_pass3 == Re_pass) {
			cnt4 = cnt4 + 1;
		} else {
			cnt4 = 1;
		}    
		if (temp_pass1 == temp_p) {
			cnt3 = cnt3 + 1;
		} else {
			cnt3 = 1;
		} 
		if (cnt2 > 3) 
			break;
		if (cnt3 > 3) 
			break;
		if (cnt4 > 3)
			break;
    } 
    if (cnt2 > 3 || cnt4 > 3) {
        alert("비밀번호에 연속된 문자나 순차적인 숫자를 4개이상 사용해서는 안됩니다.");
        pwd.value =""; 
        return false;  
    }
    
    if (cnt3 > 3) {
        alert("비밀번호에 반복된 문자/숫자를 4개이상 사용해서는 안됩니다.");
        pwd.value =""; 
        return false; 
    }    
    return pwd;    
}


function passwordvalidCheck(){
	if ($("#oldPwdCheck").val() == 'N') {
		alert('현재 비밀번호를 확인해주세요.');
		return;
	}
   var uId = $("#userId").val();
   var pw1 = $("#st_password").val();
   var pw2 = $("#password").val();

   var invalid = " ";    
   var minLength = 6;
   
   if (pw1 == '' && pw2 == '') { 
       alert('비밀번호를 확인해주세요!');       
       return false; 
   } 
  
  
   if ((pw1 != pw2 ) && pw2 != '' ) { 
       alert('변경할 비밀번호와 다릅니다. 비밀번호를 확인해주세요!'); 
       $("#password").val('');
       $("#password").focus();  
       return false; 
   }     
    
   if ($("#st_password").val().indexOf(invalid) > -1) { 
       alert("공백은 입력할 수 없습니다."); 
       $("#st_password").val('');
       $("#password").val('');
       $("#st_password").focus();      
       return false; 
   }
	   
	if($("#st_old_password").val() == $("#st_password").val()){
		alert("기존 패스워드와 동일 합니다.\n\n새로운패스워드로 입력 바랍니다.");
		$("#st_password").val('');
		$("#password").val('');
		$("#st_password").focus();
		return false; 
	} 
	
	if ($("#st_password").val().length == 0) {
		alert("비밀번호가 입력되지 않았습니다. ");
		$("#st_password").focus();
		return false;
	}
  
	if (checkSpace($("#st_password").val()) && $("#st_password").val() !="") {
      alert("비밀번호에 공백문자은 입력할 수 없습니다.   ");
      $("#st_password").val("");
      $("#st_password").focus();
      return false;
  }
	
	if ($("#st_password").val().length < 8) {
		alert("비밀번호는 8 자리 이상 사용해야 합니다.");
		$("#st_password").focus();
		$("#st_password").select();
		return false;
	}

	if ( $("#st_password").val().length < chkKorea($("#st_password").val())) {
		alert("비밀번호는 영문으로 입력해 주십시요.");
		$("#st_password").focus();
		return false;
	}
	
	if ($("#password").val().length == 0) {
		alert("비밀번호가 입력되지 않았습니다. ");
		$("#password").focus();
		return false;
	}
	
	if (checkSpace($("#password").val()) && $("#password").val() !="") {
		 alert("비밀번호에 공백문자은 입력할 수 없습니다.   ");
      $("#password").val("");
      $("#password").focus();
      return false;
  }
	
	if ($("#password").val().length < 8) {
		alert("비밀번호는 8 자리 이상 사용해야 합니다.");
		$("#password").focus();
		return false;
	}
	
	if ( $("#password").val().length < chkKorea($("#password").val())) {
		alert("비밀번호는 영문으로 입력해 주십시요.");
		$("#password").focus();
		return false;
	}
	
	if ( $("#st_password").val() != $("#password").val()) {
		alert("비밀번호가 일치하지 않습니다.\n다시 한번 입력하시기 바랍니다.");
		$("#st_password").focus();
		return false;
	}

   if (uId == pw1.toUpperCase()) { 
       alert('ID 와 패스워드가 동일합니다. 비밀번호를 확인해주세요!'); 
       $("#st_password").val('');
       $("#password").val('');
       $("#st_password").focus();  
       return false; 
   }
   
   /*
   if(kepPasswdChkChar(pw1)){
	   alert('특수문자는 다음의 문자만 입력 가능합니다._(언더바), #(샵), $(달러) ');
       $("#st_password").val('');
       $("#password").val('');
       $("#st_password").focus();  
	   return false;
   }  */

	return true;	
}

</script>
</head>
<body>
<form id="form" method="post" >
<input type="hidden" name="userId" id="userId" value="<%=userId%>"/>
<input type="hidden" name="comCode" id="comCode" value="<%=comCode%>"/>
<input type="hidden" name="oldPwdCheck" id="oldPwdCheck" value="N"/>
<div class="wrap">
	<div class="PwChange">
    	<div class="PwTitle">비밀번호 변경</div>
        <div class="PwTxt">회원님의 아이디 <span class="FontBlue"><b><%=userId%></b></span> 는 <span class="FontRed"><b>초기 비밀번호 발급 대상</b></span>입니다. 코리아이플랫폼(주)에서는 회원님의 개인정보를 안전하게 보호하고,</br> 
		개인정보도용으로 인한 피해를 예방하기 위해 비밀번호를 변경하지 않은 경우 비밀번호 변경을 안내하고 있습니다.</div>
        <div class="PwBlueBox"><span class="Bigtxt">고객님의 개인정보를 위해서는 주기적으로 비밀번호를 변경하는 것이 좋습니다..</span> </div>
        <br><br>
        <div class="PwChangeBox" >
            <ul>
                <li>현재 비밀번호 <input name="st_old_password" type="password" id="st_old_password" size="25" onChange="javascript:old_password_check();" onkeypress="javascript:checkFlagOnlyN();"></li>
                <div id="pw_check"></div>
                <li>새로운 비밀번호 <input name="st_password" type="password" id="st_password" size="25" onChange="javascript:checkpassword();"></li>
                <li><p>※ 비빌번호는 8~32자의 영문 대/소문자, 숫자, 특수문자를 혼합해서 사용하실 수 있습니다.</p></li>
                <li>비밀번호 확인 <input name="password" type="password" id="password" size="25" onChange="javascript:checkpassword();"></li>
                <li><p>※ 재확인을 위해서 입력하신 비밀번호를 다시 한번 입력해 주세요.</p></li>
            </ul>
        </div>
        <div class="PwBtn">
        	<a href="javascript:pwChange();"><span class="LayerBtnBlue">확인 >></span></a>&nbsp;
        </div>
        <div class="PwTxt"><span class="FontBlue">쉬운 비밀번호</span>나 <span class="FontBlue">자주쓰는 사이트의 비밀번호가 같을 경우,</span> 도용이 쉬우므로 <span class="FontBlue">주기적으로 변경하셔서 사용</span>하는 것이 좋습니다.</div>
    </div>
</div>
</form>
</body>
</html>

