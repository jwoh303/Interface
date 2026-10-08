<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
String msg = request.getAttribute("SHEET_MSG")+"";

%>
<script>
try{
	var xml = "<SHEET><MESSAGE><%= msg %></MESSAGE></SHEET>";
	parent.multipartWorkFinish(xml);
}catch(e){}
</script>
