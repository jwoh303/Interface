<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!doctype html>
<!-- SSO Login 공통 -->
<%

String referer	= request.getHeader("REFERER");
String kita_id	= request.getParameter("st_user_id");
String page_cont	= request.getParameter("st_page_cont");
String com_code	= request.getParameter("st_com_code"); 

response.sendRedirect("/login/sso_login.do?st_user_id="+kita_id+"&st_buyer="+com_code);
%>
<html>
 <head>
  <title>ssoLogin</title>
 </head>
 <body>
ssoLogin
 </body>
</html>
