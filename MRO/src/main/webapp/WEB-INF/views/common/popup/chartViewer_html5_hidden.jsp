<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
String fileOpenUrl = "";
String serviceInfo = CommonUtil.nvl(request.getRemoteAddr(),"");
String flag = CommonUtil.getDevRealLocalFlag(request);
if(flag.equals("0")){// flag=0이면 localhost
	fileOpenUrl = "http://10.20.101.39:8081/report/";
}else{
	fileOpenUrl= "http://"+serviceInfo+":8081/report/";
}

String cxServerSid = "";
String cxServerUrl = (String)request.getAttribute("rdServer");
// String serverUrl = (String)request.getAttribute("rdServerNonActiveXService");
String serverUrl = (String)request.getAttribute("rdServerNonActiveXServiceNew");

if ("2".equals(flag)){
	cxServerSid = (String)request.getAttribute("sidRdServerReal");
}else{
	cxServerSid = (String)request.getAttribute("cx.sidRdServerDev");
}
%>
<!doctype html>
<html> 
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title>Crownix HTML5 Viewer</title>
		<script src="/resources/libs/jquery/js/jquery-1.11.0.min.js" type="text/javascript"></script> 
		<script src="/resources/libs/jquery/js/crownix-viewer.min.js" type="text/javascript"></script>
		<link rel="stylesheet" href="/resources/styles/crownix-viewer.min.css" type="text/css" />
	</head>
	<body style="margin:0;height:100%">
		<div id="crownix-viewer" style="position:absolute;width:100%;height:100%"></div>
		<script>
		window.onload = function(){
			var fileName= "${param.fileName}";
			var fileParam= "${param.param}";
			var mrdPath =  "<%=fileOpenUrl%>" + fileName + ".mrd";
			
			var rdParam = "/rf <%=cxServerUrl%> /rsn <%=cxServerSid%> /rusecxlib /rchartopt [2] /rp " + fileParam + " /rpdflinebreak [1]"; 
			var viewer = new m2soft.crownix.Viewer("<%=serverUrl%>", 'crownix-viewer');
			
			viewer.hideToolbarItem(["save"]);
			viewer.openFile(mrdPath, rdParam,{timeout:180});
		};
		</script>
	</body>
</HTML>
