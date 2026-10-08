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
 
 String rtnMsg = CommonUtil.nvl((String) request.getAttribute("rtnMsg"),"");
 String file_name = CommonUtil.nvl((String) request.getAttribute("file_name"),"");
 String upload_date = CommonUtil.nvl((String) request.getAttribute("upload_date"),"");
 
 %>
<script> 
function kep_onload(){
	parent.loader_obj("N");
<%
	if("OK".equals(rtnMsg)){
%>
		parent.searchCondition.file_name.value = "<%=file_name%>";
		parent.searchCondition.upload_date.value = "<%=upload_date%>";
		parent.doAction('search');
<%
	}else{
%>
		alert("선입고 등록(일괄) 요청 중에 오류가 발생 했습니다.\n관리자에 문의하여 주세요.");
<%
	}
%>
}
</script>
<body onload="kep_onload()">
</body>

</html>
