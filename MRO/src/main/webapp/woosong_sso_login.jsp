<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!doctype html>
<!-- 우송대학교 SSO -->
<%

String referer	= request.getHeader("REFERER");
String user_id	= request.getParameter("st_user_id");
String page_cont	= request.getParameter("st_page_cont");
String com_code	= "KRWOOS0062";

response.sendRedirect("/login/sso_login.do?st_user_id="+user_id+"&st_buyer="+com_code);
%>
<html>
 <head>
  <title>ssoLogin</title>
 </head>
 <body>
ssoLogin
 </body>
</html>
