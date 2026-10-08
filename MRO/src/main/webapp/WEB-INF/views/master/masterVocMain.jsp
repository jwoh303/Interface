<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../common/include/head.jspf"  %> 
<body>
<div id="wrapper">
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="masterHeader"/>
<c:param name="part" value="masterHeader"/>
<c:param name="upperId" value="${param.upperId}"/>
</c:import>
<!--내용 시작-->	      
    <div id="admin_home">
     <img src="/resources/images/bg_voc.jpg">
	       
	</div>
    
<!--내용 종료-->	       
<%@ include file="/WEB-INF/views/common/include/masterFooter.jsp" %>    
</div>
	
</body>
</html>			
