<%--
**********************************************
* 메뉴 : 견적관리 > 견적의뢰접수 > 
* 화면 : DB표준화 진행
* 기능 : 고객으로부터 견적의뢰받은 상품에 대해 DB표준화 작업을 하는 팝업
* 프로그램 ID : PG_04_M_003_02
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-05-20
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
 %>
<script> 
function kep_onload(){
	
<%-- 	alert("<%=docNo%>"); --%>
		
parent.upSet("<%=docNo%>");
}
</script>
<body onload="kep_onload()">
</body>

</html>
