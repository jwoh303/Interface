<%--
**********************************************
* 메뉴 : 견적관리 > 견적상세팝업
* 화면 : 견적상세팝업 > 파일업로드
* 기능 : 
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2025-09-10
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
</head>
 <%
 
 String docNo = CommonUtil.nvl((String) request.getAttribute("docNo"),"");
 String extCheck = CommonUtil.nvl((String) request.getAttribute("extCheck"),"");
 String result = CommonUtil.nvl((String) request.getAttribute("result"),"");
 String key = CommonUtil.nvl((String) request.getAttribute("key"),"");
 
 %>
<script> 
function kep_onload(){
	
parent.upFileSet("<%=docNo%>","<%=key%>","<%=result%>","<%=extCheck%>");
}
</script>
<body onload="kep_onload()">
</body>

</html>
