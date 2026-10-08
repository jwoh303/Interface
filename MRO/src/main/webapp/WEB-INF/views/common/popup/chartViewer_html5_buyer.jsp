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
			
			var rdParam = "/rf <%=cxServerUrl%> /rsn <%=cxServerSid%> /rusecxlib /rchartopt [2] /rp " + fileParam  + " /rpdflinebreak [1]"; 
			var viewer = new m2soft.crownix.Viewer("<%=serverUrl%>", 'crownix-viewer');
			
			var downloadPDF = {
					index : 9,
					id : 'myItem' , 
					svg : '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="35px" height="35px" viewBox="0 0 24 24" enable-background="new 0 0 24 24" xml:space="preserve" focusable="false"><path fill="none" stroke="#A0A0A0" stroke-width="1" stroke-miterlimit="10" d="M0.505,2.993v17.424c0,0-0.196,3.083,3.278,3.083	c3.473,0,16.858,0,16.858,0s2.856-0.221,2.856-2.688c0-2.463,0-17.819,0-17.819s0.234-2.488-2.645-2.488c-2.881,0-17.797,0-17.797,0	S0.505,0.262,0.505,2.993z"></path><path fill="#E41737" stroke="#E41737" stroke-width="0.2" stroke-miterlimit="10" d="M11.549,9.045c0,0-4.489,10.481-7.78,11.242	c0,0-0.171-1.122,2.911-3.31c0,0-3.005,1.294-3.386,3.12c0,0,0.095,0.476,1.198,0.438c0,0,0.932,0.19,4.014-4.261	c0,0,0.026-0.04,0.075-0.114c0.44-0.678,2.685-4.181,3.216-6.049c0,0,1.121,2.929,3.252,4.47c0,0-4.311,0.605-6.624,1.641	l-0.072,0.1c0,0,3.652-1.17,7.39-1.298c0,0,4.337,2.254,5.065,0.998v-0.057c0,0-0.999,0.442-3.867-0.999	c0,0,4.052-0.171,3.938,0.828c0,0,0.756-0.757-1.256-1.228c0,0-2.026-0.229-3.566-0.1c0,0-2.994-1.228-3.901-5.521	c0,0,0.563-2.839,0.505-3.923L11.92,7.847c0,0-0.711-3.41,0.236-4.223c0,0,0.392,0.1,0.563,1.027c0,0,0.458-1.084-0.563-1.17	c0,0-0.764-0.257-0.893,1.127C11.264,4.608,10.955,7.21,11.549,9.045z"></path></svg>',
					title : 'PDF',
					separator : false,
					handler : function() {
						try{
							viewer.downloadFile('pdf', function(e) {
								$('#crownix-download-iframe').attr('src', e + '&attachment=true');
								});
						}catch(e){
							alert(e);
						}
					  } 
					};
			
				viewer.hideToolbarItem(["save"]);
				viewer.addToolbarItem(downloadPDF);
			viewer.openFile(mrdPath, rdParam,{timeout:180});
		}; 

		</script>
	</body>
</HTML>
