<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!doctype html>
<!-- SSO Login 공통 -->
<%
String referer	= request.getHeader("REFERER");
String legacy_user_id	= request.getParameter("st_user_id");
String page_cont	= request.getParameter("st_page_cont");
String com_code	= request.getParameter("st_com_code");

String v_id	= request.getParameter("v");
String slo_p_ota	= request.getParameter("slo_p_ota");

if ( !"".equals(v_id) && v_id != null) {
	com_code = "KRLOTTG004";
	legacy_user_id = v_id;
}

/* (주)한화 자동로그인 */
if ( !"".equals(slo_p_ota) && slo_p_ota != null) {
	legacy_user_id = slo_p_ota;
}


if("KRINNOG001".equals(com_code)){
	legacy_user_id = request.getParameter("st_user_id").replaceAll("\\+", "%2b");
}

response.sendRedirect("/login/sso_login.do?st_user_id="+legacy_user_id+"&st_buyer="+com_code);

%>
<html>
 <head>
  <title>ssoLogin</title>
 </head>
 <body>
ssoLogin
 </body>
</html>