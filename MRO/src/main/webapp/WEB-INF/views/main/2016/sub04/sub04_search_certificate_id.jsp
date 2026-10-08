<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<%
String st_id_no = CommonUtil.nvl((String) request.getParameter("st_id_no"),"");
String st_user_id = CommonUtil.nvl((String) request.getParameter("st_user_id"),"");
String p_num = CommonUtil.nvl((String) request.getParameter("p_num"),"");
String p_num_x = "";
	if(!p_num.equals("") ){ 
		String [] number = p_num.split("-");  
		if(number.length ==3){
			p_num_x = number[0]+"-"+number[1]+" - ****";
		}
	}
%>
</head>
<body> 
	<div class="wrap" >
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp" %>
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
    <!--컨텐츠--> 
    <div class="subcontentsArea">
  	<form name="member_id_certification" method="post">
         <input type="hidden" id="st_id_no" name="st_id_no"	value="<%=st_id_no%>"> 
		<input type="hidden" id="st_user_id" name="st_user_id"	value="<%=st_user_id%>"> 	
		<input type="hidden" id="p_num" name="p_num"	value="<%=p_num%>">
    	<div class="subbanner" >
            <div class="subbannerimg"><img src="/resources/images/2016/SB22.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">비밀번호 찾기</p>
            	<p>KeP서비스 이용을 통해 경쟁력을 높여 보세요</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
		<div class="subcontent">
        	<div class="sub04_join">
                <p class="subcontentTit" >등록된 연락처 인증</p>
                <div class="certificate" style="height:370px"></br></br>
                     <div class="certificateIN">
                         휴대폰번호 <input type="text" style="border:0; background:transparent"  name="" id=""  value="<%=p_num_x %>"  /> <a href="javascript:sendOtp();"><span class="LCBtn03">인증번호 받기</span></a>
                         </br>
                         인증번호입력 <input type="text"  name="st_auhen_no" id="st_auhen_no" size="21"  disabled  /><a href="javascript:auhenOtp();"><span class="LCBtn03" title="인증번호확인">인증번호 확인</span></a>
                     </div>
                     <div class="certificateIS">
                         <span class="FontRed">등록된 휴대폰으로 인증번호를 전송받아 인증을 받으시면</br> 정확한 아이디를 확인 하실 수 있습니다.</span></br></br></br></br>
                         <div class="joinBtn"><a href="#">다른 아이디 확인</a> &nbsp;&nbsp;<a href="#">비밀번호 찾기</a> </div></br>
                        위 방법으로 아이디 찾기가 불가능 할 경우, <span class="FontRed"><b>새로운 아이디로 가입</b></span> 하시거나,</br> 고객센터로 본인확인 정보를 보내주시면 정확한 아이디를 확인해 드리겠습니다.
                    </div>
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
var sendSms ='N'; 
function sendOtp(){    
	var pData = { st_user_id : $("#st_user_id").val(), p_num :   $("#p_num").val()};
	kepAjaxCall("/main/sub05/sendOtpReg.do",pData,"sendOtp");    
}  
function auhenOtp() { 
	if(sendSms != 'Y'){
		alert("인증번호를 받으시고 확인 바랍니다.");
		return;
	}
	
	var pData = { st_user_id : $("#st_user_id").val(), st_auhen_no : $("#st_auhen_no").val()};
	kepAjaxCall("/main/sub05/getOtpAuhen.do",pData,"getOtpAuhen");
} 

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	
	if(pMethod == "sendOtp"){
 		alert("인증번호를 정상적으로 발송 하였습니다.");
		sendSms ='Y'; 
		document.getElementById("st_auhen_no").disabled = false;
	}else if(pMethod == "getOtpAuhen"){
		var msg = response.Result;
		if(msg =="OK"){  
			document.member_id_certification.action = "<%=sslurl%>/main/sub05/sub05_03id_search_find_end.do";
			document.member_id_certification.submit(); 
		}else if(msg =="TIME_OVER"){ 
			alert("인증번호의 유효시간이 경과 하였습니다.\n\n인증번호의 유효시간은 1분입니다. \n\n새로 인증번호 받으시고 진행 바랍니다.");
		}else if(msg =="NO_AUHEN"){ 
			alert("인증번호가 유효하지 않습니다.\n\n인증번호를 확인 하시기 바랍니다."); 
		}else{
			alert("인증에 실패 하였습니다.\n\n확인 후 다시 진행 바랍니다."); 
		}
	}
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	
	if (pMethod == "sendOtp"){ 
		alert("인증번호 발송에 실패 하였습니다.\n\n다시 확인 후 진행 바랍니다.");
		sendSms ='N';
		return;
	}else if(pMethod == "getOtpAuhen"){
		alert("인증에 실패 하였습니다.\n\n확인 후 다시 진행 바랍니다."); 
		return; 
	}
} 
</script>
</html>

