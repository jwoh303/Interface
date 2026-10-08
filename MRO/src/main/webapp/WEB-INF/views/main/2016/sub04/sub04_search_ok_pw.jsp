<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<%
	String st_id = CommonUtil.nvl((String)request.getParameter("st_id"), "");
    String st_mail_addr = CommonUtil.nvl((String)request.getParameter("st_mail_addr"), "");
    String st_phone_num1 = CommonUtil.nvl((String)request.getParameter("st_phone_num1"), "");
    String st_phone_num2 = CommonUtil.nvl((String)request.getParameter("st_phone_num2"), "");
    String st_phone_num3 = CommonUtil.nvl((String)request.getParameter("st_phone_num3"), "");
    String st_mobile = st_phone_num1+"-"+st_phone_num2+"-"+st_phone_num3;
%> 
</head>
<body> 
	<div class="wrap" >
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp" %>
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
    <!--컨텐츠-->
    <form method="post" name="member_pw_create">
	<input type="hidden" id="st_id" name="st_id"		value="<%=st_id%>">
    <div class="subcontentsArea">
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
                <p class="subcontentTit" >비밀번호 확인</p>
                <div class="idpwSearch" style="height:350px"> <br/> <br/><br/>
                    <p style="line-height:10px;color:#ee3212; font-weight:bold">이메일 :   <%=st_mail_addr %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;휴대폰 : <%=st_mobile %></p><br/>
                    이메일의 경우 최대 5분 소요됩니다.<br/> 
                    위 방법으로 비밀번호 찾기가 불가능할 경우, ‘새로운 아이디로 가입’ 하시거나,  <br/> 고객센터로 본인확인정보를 보내주시면 임시번호를 발급해드립니다.<br/>  <br/> 

                    <div class="joinBtn" ><a href="javascript:sendNeewPw('email');">이메일로 재발급받기</a> <a href="javascript:sendNeewPw('sms');">휴대폰번호 재발급받기</a></div>
                </div>
            </div>
        </div>
        </form>
    </div>
    <!--컨텐츠 끝-->
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainFooter.jsp" %>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	</div>
</body>

<script type="text/javascript">
<!-- 
function sendNeewPw(type){  
	var pData = { st_id : $("#st_id").val(), st_type : type};
	kepAjaxCall("/main/sub05/setNewPw.do",pData,"setNewPw"); 
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "setNewPw"){ 
		alert("정상적으로 발송 되었습니다.");  
	}
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if(pMethod == "setNewPw"){
		alert("처리중 오류가 발생하였습니다.");  
		return;
	}
} 
	
//-->
</script>
</html>

