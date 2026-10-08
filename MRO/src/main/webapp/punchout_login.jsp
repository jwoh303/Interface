<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!doctype html>
<!-- SSO Login 공통 -->
<%

String referer	= request.getHeader("REFERER");
String returnURL	= request.getParameter("returnURL");
String appUserName	= request.getParameter("appUserName");
String userName	= request.getParameter("userName");
String userEmail	= request.getParameter("userEmail");
String password	= request.getParameter("password");
String gbn	= request.getParameter("gbn");

response.sendRedirect("/login/punchout_login.do?returnURL="+returnURL+"&appUserName="+appUserName+"&password="+password+"&userName="+userName+"&userEmail="+userEmail+"&gbn="+gbn);
%>
<html>
 <head>
  <title>ssoLogin</title>
 </head>
 <body>
ssoLogin
 </body>
</html>
