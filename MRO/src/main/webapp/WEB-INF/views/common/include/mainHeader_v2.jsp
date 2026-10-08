<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String sslurl = CommonUtil.getSslURL(request, "http");
	String sslurl2 = CommonUtil.getSslURL(request, "https");
	String devReal = CommonUtil.getDevRealLocalFlag(request);
	String flag = CommonUtil.getDevRealLocalFlag(request);
	String httpurl ="";
	String httpsurl ="";
	if(flag.equals("2")){
		httpurl =  "" ;
		httpsurl = "" ;
	}else{
		httpurl =  "" ;
		httpsurl = "" ;
	}
	String start_msg = CommonUtil.nvl((String) request.getParameter("start_msg"),"");
%>
<link rel="icon" type="image/png" sizes="32x32" href="/resources/imgs/favicon.png">
<link rel="stylesheet" type="text/css" href="/resources/css/base.css" />
<link rel="stylesheet" type="text/css" href="/resources/css/main_com.css" />

<c:if test="${jqueryGbn ne 'Y' }">
    <script src="/resources/libs/jquery/js/jquery-3.6.0.min.js"></script>
</c:if>
<script type="text/javascript" src="/resources/js/kep_main_common.js"></script>
<script type="text/javascript" src="/resources/js/kep_common.js"></script>
<script>console.log("[JSP] <%= request.getServletPath() %>");</script>

<section class="header">
  <h1><a href="/main.do"><img src="/resources/imgs/logo.png" /></a></h1>
  <div class="FamilySite">
    <div class="FamilySite-btn">Family Site</div>
    <div class="FamilySite-content">
      <div onclick="window.open('https://safety.koreab2b.com','_blank')">건설MRO</div>
      <div onclick="window.open('https://kway.koreab2b.com','_blank')">Kway</div>
      <div onclick="window.open('http://www.kepchina.cn','_blank')">중국법인</div>
      <div onclick="window.open('http://www.koreab2b-eu.com','_blank')">유럽법인</div>
    </div>
  </div>
</section>
