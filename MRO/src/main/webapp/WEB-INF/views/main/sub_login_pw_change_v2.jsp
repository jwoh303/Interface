<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
</head>
<link rel="stylesheet" href="/resources/css/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/css/main_seller.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<%
String sslurl2 = CommonUtil.getSslURL(request, "https");
String userId = CommonUtil.nvl((String) request.getAttribute("userId"),"");
String comCode = CommonUtil.nvl((String) request.getAttribute("comCode"),"");
%>
<script type="text/javascript">
var create_flag ="C";

function nextTime(){ 
	$("#form").attr("action","<%=sslurl2%>"+"/login/login.do").submit();
	
}//end function

// 현재 비밀번호 체크
function old_password_check() {
    kepAjaxFormCall("/login/getOldPasswordCheck.do","form","getOldPasswordCheck");
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
	 		kepAjaxFormCall("/login/setUserPwdUpdate.do","form","setUserPwdUpdate");
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
       $("#newPwCheck").html("");
       return false; 
   } 
  
   if (uId == pw1) { 
       alert('ID 와 패스워드가 동일합니다. 비밀번호를 확인해주세요!'); 
       document.getElementsByName(pPwd1)[0].value = "";
       document.getElementsByName(pPwd2)[0].value = "";
       document.getElementsByName(pPwd1)[0].focus();  
       $("#newPwCheck").html("");
       return false; 
   } 
  
   if ((pw1 != pw2 ) && pw2 != '' ) { 
       alert('변경할 비밀번호와 다릅니다. 비밀번호를 확인해주세요!'); 
       document.getElementsByName(pPwd2)[0].value = "";
       document.getElementsByName(pPwd2)[0].focus(); 
       $("#newPwCheck").html("");
       return false; 
   }     
    
   if (document.getElementsByName(pPwd1)[0].value.indexOf(invalid) > -1) { 
       alert("공백은 입력할 수 없습니다."); 
       document.getElementsByName(pPwd1)[0].value = "";
       document.getElementsByName(pPwd2)[0].value = "";
       document.getElementsByName(pPwd1)[0].focus();     
       $("#newPwCheck").html("");
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
       $("#newPwCheck").html("");
       return false; 
   }  
   if(!pass_valid_check(pw1)) {
       document.getElementsByName(pPwd1)[0].value = "";
       document.getElementsByName(pPwd2)[0].value = "";
       document.getElementsByName(pPwd1)[0].focus(); 
       $("#newPwCheck").html("");
       return false; 
   }   
   if($("#st_old_password").val() == $("#st_password").val()){
		alert("기존 패스워드와 동일 합니다.\n\n새로운패스워드로 입력 바랍니다.");
		$("#st_password").val('');
		$("#st_password_confirm").val('');
		$("#st_password").focus();
		$("#newPwCheck").html("");
		return false; 
	}
  
  $("#newPwCheck").html("사용가능");
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
        
		if( t_pass > 47 && t_pass < 58  ) {
			num_flag = true;
		}else if( (t_pass > 64 && t_pass < 91) || (t_pass > 96 && t_pass < 123)  ){
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
		alert("비밀번호가 입력되지 않았습니다. 1");
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
<input type="hidden" id="st_user_id" value="<%=userId%>">
<input type="hidden" name="oldPwdCheck" id="oldPwdCheck" value="N"/>
<div class="wrapPopup"  >
  <div class="PWChangeTit" style="margin-top: 150px;"><p><img src="/resources/imgs/Icon_key.png" /></p><div>개인정보를 위해 <br/><span>비밀번호</span>를 변경해주세요.</div>
  </div>
  <div class="PWChangeTxt mt50"><span><%=userId%></span> 회원님은 3개월 이상 동일한 비밀번호를 사용하고 계십니다.<br/>소중한 개인 정보를 위해 비밀번호를 주기적으로 변경해주세요.</div>
  <div class="PWChangeInput mt20 ">
    <input  name="st_old_password" type="password" id="st_old_password" size="25" onChange="javascript:old_password_check();" onkeypress="javascript:checkFlagOnlyN();" placeholder="현재 비밀번호 입력"/>
    <p id="pw_check"></p>
    <input  name="st_password" type="password" id="st_password" size="25" onChange="javascript:checkpassword();"  placeholder="새로운 비빌번호"/>
    <p>비밀번호는 8~32자의 영문 대/소문자,숫자,특수문자 혼합사용<span id="newPwCheck"></span></p>
    <input  name="password" type="password" id="password" size="25" onChange="javascript:checkpassword();"  placeholder="새로운 비빌번호 확인"/>
    <p id="newPwConfirm"></p>
  </div>

  <div class="PopupListBtnBox_Center mt30">
    <button class="ButPrimary_large" onclick="javascript:pwChange(); return false;" >확인</button>
  </div>  
</div><!-- wrapPopup 끝-->  
</form>
</body>
</html>

