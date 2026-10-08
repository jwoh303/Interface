<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<%
String st_user_id = CommonUtil.nvl((String) request.getParameter("st_user_id"),"");
%>
</head>
<body> 
	<div class="wrap" >
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp" %>
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
    <!--컨텐츠-->
<form id="id_some_find" name="id_some_find" method="post">
     <input type="hidden" id="st_id_no" name="st_id_no"			value=""> 
     <input type="hidden" id="st_user_id" name="st_user_id"			value="">
     <input type="hidden" id="p_num" name="p_num"			value="">
    <div class="subcontentsArea">
    	<div class="subbanner" >
            <div class="subbannerimg"><img src="/resources/images/2016/SB22.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">아이디 찾기 완료</p>
            	<p>KeP서비스 이용을 통해 경쟁력을 높여 보세요</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
		<div class="subcontent">
        	<div class="sub04_join">
                <p class="subcontentTit" >아이디 찾기 완료</p>
                <div class="idpwSearch" style="height:360px">
                   <br/><br/>
                    입력하신 정보에 따른 일부 아이디정보입니다. <br/> <br/><br/> 
						<p style="line-height:10px;color:#ee3212; font-weight:bold"><%=st_user_id %></p><br/>
						 <br/>  <br/> 
                    <div class="joinBtn" > <a href="javascript:MovePage_2016('<%=httpurl%>','04', '04');">비밀번호 확인</a></div>
                </div>
            </div>
        </div>
    </div>
    <!--컨텐츠 끝-->
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainFooter.jsp" %>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	</div>
</form>
</body>
</html>

