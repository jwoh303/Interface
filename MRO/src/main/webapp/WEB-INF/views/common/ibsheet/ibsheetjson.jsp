<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.common.ibsheet.IBSheetUtil"%>
<% IBSheetUtil ib =  new IBSheetUtil(); %>
<%= ib.getJson(request)%>
