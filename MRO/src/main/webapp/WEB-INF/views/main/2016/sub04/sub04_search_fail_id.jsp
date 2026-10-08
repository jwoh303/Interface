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
        	 
            <div class="subbannerimg"><img src="/resources/images/2016/SB22.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">아이디 찾기</p>
            	<p>KeP서비스 이용을 통해 경쟁력을 높여 보세요</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
		<div class="subcontent">
        	<div class="sub04_join">
                <p class="subcontentTit" >아이디 확인</p>
                <div class="idpwSearch" style="height:390px"><br/> <br/>
                    입력하신 정보에 따른 일부 아이디정보입니다. <br/> <br/>
                    <img src="/resources/images/2016/img25.png" /><br/> 
                    해당정보를 찾을 수 없습니다. <br/> <br/> 
                    <div class="joinBtn" ><a href="javascript:MovePage_2016('<%=httpurl%>','04', '02');">회원가입</a> <a href="javascript:MovePage_2016('<%=httpurl%>','04', '04');">아이디찾기</a></div>
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
</html>

