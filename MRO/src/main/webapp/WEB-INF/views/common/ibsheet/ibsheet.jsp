<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.common.ibsheet.IBSheetUtil"%>
<% 
out.clear(); // where out is a JspWriter
out = pageContext.pushBody();
IBSheetUtil ib =  new IBSheetUtil(); 
%>
<% ib.getXml(request,response);%>
