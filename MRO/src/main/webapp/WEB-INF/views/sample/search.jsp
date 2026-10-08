<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>
	<ul>
		<%
			for (Map<String,String> rowData : _gridList) {
		%>
		<li><%= rowData.get("BUYER_NAME") %></li>
		<%
			}
		%>
	</ul>
</body>
</html>
