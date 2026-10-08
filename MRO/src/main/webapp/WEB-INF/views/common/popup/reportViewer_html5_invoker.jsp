<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.io.*, java.util.*, java.net.*" %>
<%@ page import="m2soft.ers.invoker.InvokerException" %>
<%@ page import="m2soft.ers.invoker.http.ReportingServerInvoker" %>

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
// String downloadUrl = (String)request.getAttribute("rdServerHtml5Download");
String serverUrl = (String)request.getAttribute("rdServerNonActiveXServiceNew");
String downloadUrl = (String)request.getAttribute("rdServerHtml5DownloadNew");

if ("2".equals(flag)){
	cxServerSid = (String)request.getAttribute("sidRdServerReal");
}else{
	cxServerSid = (String)request.getAttribute("sidRdServerDev");
}
%>
<!doctype html>
<html> 
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title>Crownix ReportingServer Invoker</title>
		<script src="/resources/libs/jquery/js/crownix-invoker.min.js" type="text/javascript"></script>
	</head>
	<body style="margin:0;height:100%">
		<div id="crownix-viewer" style="position:absolute;width:100%;height:100%"></div>
		<script>
		window.onload = function(){
			var fileName= "${param.fileName}";
			var fileParam= "${param.param}";
			var mrdPath =  "<%=fileOpenUrl%>" + fileName + ".mrd";
			var rdParam = "/rf <%=cxServerUrl%> /rsn <%=cxServerSid%> /rpdfprintdialog /rp " + fileParam + " /rpdflinebreak [1]"; 

			// INVOKER 바로 출력
			var invoker = new m2soft.crownix.ReportingServerInvoker("<%=serverUrl%>");
			
			invoker.addParameter("opcode", "500");
			invoker.addParameter("mrd_path", mrdPath);
			invoker.addParameter("mrd_param", rdParam);
			invoker.addParameter("export_type", "pdf");
			invoker.addParameter("protocol", "sync");
			
			invoker.invoke(function(response, xhr){
				var downloadServletPath = "<%=downloadUrl%>";
				var ret = response.split('|');
				var resultCode = ret[0];
				var message = ret[1];
				
				if(resultCode == '1'){
					// If successful, download
					var iframeSrc = downloadServletPath + '?filename=' + message;
					var rdid = xhr && xhr.getResponseHeader('crownix-rdid');
					
					if(rdid){
						iframeSrc += '&rdid=' + rdid;
					}
					
					document.getElementById('downloadFrame').src = iframeSrc;
				}else{
					// If failure, process error message
					document.getElementById('response').innerText = message;
				}
			});
		};

		</script>
		<iframe id="downloadFrame" style="display:none"></iframe>
		<div id="response" style="position:absolute; width:100%; height:100%"></div>
	</body>
</HTML>
