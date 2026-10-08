<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 카탈로그 변경 
* 기능 : 고객사카탈로그 상세정보 팝업
* 프로그램 ID : PG_03_M_002_01
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-06-16
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
 //String docNo = CommonUtil.nvl((String) request.getAttribute("docNo"),"");
 %>
<script> 
function kep_onload(){
parent.upSet();
}
</script>
<body onload="kep_onload()">
</body>

</html>
