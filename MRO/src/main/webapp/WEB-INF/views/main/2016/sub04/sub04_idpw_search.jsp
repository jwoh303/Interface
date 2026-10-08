<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<script type="text/javascript">


</script>
</head>
<body> 
	<div class="wrap" >
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp" %>
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
    <!--컨텐츠-->
    <div class="subcontentsArea">
    	<div class="subbanner" >
            <div class="subbannerimg"><img src="/resources/images/2016/SB13.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">ID/PW찾기</p>
            	<p>KeP서비스 이용을 통해 경쟁력을 높여 보세요</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
		<div class="subcontent">
        	<div class="sub04_join">
                <p class="subcontentTit" >아이디/비밀번호 찾기</p>
                본 입력정보는 시스템으로 처리되어 ID/PW찾기 외 다른용도로 사용하지 않습니다.<br/> 
                <span class="FontRed">※ 문의전화 : 02-3016-7251</span><br/><br/><br/>
                
                <div style="position:relative; width:100%; ">
                	<div style="position:relative;width:529px">
                       <div  class="idpwChecktit">아이디 찾기</div>
                       <form id="id_search" name="id_search" method="post">
                        <div class="idpwCheck" style="height:250px" >
                            <ul>
                                <li>이름<input type="text"  name="st_name" id="st_name" class="PWCinput"/></li>
                                <li>이메일<input type="text"  name="st_mail_addr" id="st_mail_addr" class="PWCinput" onKeyDown="if(event.keyCode == 13){findId();};"/></li>
                                <li><div class="idpwBtn" style="letter-spacing:0px"><a href="javascript:findId();">확인</a></div></li>
                                <li><p class="idpwTxt">가입당시 입력하신 이메일 주소를 넣어 주세요.</p></li>
                            </ul>
                        </div>
                        </form>
                    </div>
                    <div style="position:absolute;width:520px;top:0px;left:560px;">
                        <div  class="idpwChecktit">비밀번호 찾기</div>
                        <form id="pw_search" name="pw_search" method="post"> 
                        <input type="hidden" id="st_phone_num1" name="st_phone_num1" value="">
                        <div class="idpwCheck" style="height:250px;">
                            <ul>
                                <li>이름<input type="text"  name="st_name" id="st_name" class="PWCinput"/></li>
                                <li>휴대폰<select name="st_phone_num" id="st_phone_num" style="width:100px;">
                                        <option value="010" selected>010
                                        <option value="011">011
                                        <option value="016">016
                                        <option value="017">017
                                        <option value="018">018
                                        <option value="019">019
                                    </select> -
                                    <input type="text" name="st_phone_num2" id="st_phone_num2" maxlength="4" style="width:90px;" class="PWCm0" /> -
                                    <input type="text" name="st_phone_num3" id="st_phone_num3" maxlength="4" style="width:95px;" class="PWCm0"/>
                                </li>
                                <li>아이디<input type="text"  name="st_id" id="st_id" size="20"  onkeyup="kepToUpper('st_id')" class="PWCinput"/></li>
                                <li>이메일<input type="text"  name="st_mail_addr" id="st_mail_addr" class="PWCinput" /></li>
                                <li><div class="idpwBtn" style="letter-spacing:0px"><a href="javascript:findPw();">확인</a></div></li>
                                <li><p class="idpwTxt">가입당시 입력하신 정보를 그대로 넣어 주세요. </li>
                            </ul>
                        </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--컨텐츠 끝-->
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainFooter.jsp" %>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	</div>
</body>
<script type="text/javascript">
//ID찾기
function findId(){  
	$('#id_search').attr("method", "post");
    $('#id_search').attr("action", "<%=sslurl2%>/main/2016/sub04/getIdFindUserInfo.do");
    $('#id_search').submit();

} 
//패스워드찾기
function findPw(){ 
	var no = document.getElementById("st_phone_num").options.selectedIndex;
	var num1 = document.getElementById("st_phone_num").options[no].value; 
	 
	$('#st_phone_num1').val(num1);
	$('#pw_search').attr("method", "post");
    $('#pw_search').attr("action", "<%=sslurl2%>/main/2016/sub04/getPwFind.do");
    $('#pw_search').submit();
} 
</script>
</html>

