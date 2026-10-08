<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/koreab2b_base.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script type="text/javascript" src="/resources/js/kep_common.js"></script>
<%
String result = CommonUtil.nvl((String)request.getAttribute("result"),"");
%>
<script type="text/javascript">
function kep_onload_view(){
	setTimeout(function(){
		this.close();
	}, 1000);
} 

</script>
</head>
<body onLoad="kep_onload_view()">
<form id="loginForm" name="loginForm" method="post">
	<input type = "hidden" id="originData" name = "originData" size="40" >
	<input type = "hidden" id="pageFlag" name = "pageFlag"  value="">
	<input type = "hidden" id="mainLogin" name = "mainLogin" value="KOREAB2B">
	<div class="wrap" >
	<div style="vertical-align: middle; text-align: center; margin:0 auto; margin-top:50px;">
        <table>
		<%if("1".equals(result)){%>
        	<img src="/resources/images/approval_ok.jpg"/>
		<%}else if("3".equals(result)){%>
    	    <img src="/resources/images/approval_no.jpg"/>
		<%}%>
        </table>
    </div>
</div>
</form>
</body>
</html>


