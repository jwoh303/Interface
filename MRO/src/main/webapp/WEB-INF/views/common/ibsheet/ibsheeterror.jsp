<%@page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
	String etcData = "<ETC-DATA>";
	String key = "";
	@SuppressWarnings("unchecked")
	Enumeration<String> en =  (Enumeration<String>)request.getAttributeNames();
	while(en.hasMoreElements()){
		key = (String)en.nextElement();
		etcData += "<ETC KEY='"+key+"'>"+request.getAttribute(key)+"</ETC>";
	}
	etcData += "</ETC-DATA>";
	
	
	String msg  = (request.getAttribute("SHEET_MSG")!=null)?(String)request.getAttribute("SHEET_MSG"):"";
%>
<?xml version="1.0"?>
<SHEET>
	<%= etcData %>
	<MESSAGE><%= msg %></MESSAGE>
	<RESULT Code="-1" Message="<%= msg %>"/>
</SHEET>
