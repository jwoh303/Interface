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
			
			var downloadDOC = {
					index : 10, 
					id : 'myItem2' , 
					svg : '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="35px" height="35px" viewBox="0 0 24 24" enable-background="new 0 0 24 24" xml:space="preserve" focusable="false"><path fill="none" stroke="#A0A0A0" stroke-width="1" stroke-miterlimit="10" d="M0.505,2.993v17.424c0,0-0.196,3.083,3.278,3.083	c3.473,0,16.858,0,16.858,0s2.856-0.221,2.856-2.688c0-2.463,0-17.819,0-17.819s0.234-2.488-2.645-2.488c-2.881,0-17.797,0-17.797,0	S0.505,0.262,0.505,2.993z"></path><path fill="#3578BD" d="M4.362,6.428h5.344v0.806c0,0-1.35,0.469-1.444,1.481l-0.075,5.42l3.787-7.708h2.494v7.708L17.3,8.584	c0,0,0.618-1.237-0.749-1.313l-0.039-0.844h4.127v0.769l-0.281,0.112l-5.945,11.063h-2.438l-0.056-6.881l-3.975,6.788l-2.531,0.094	L5.394,8.697c0,0-0.169-1.257-1.031-1.388V6.428z"></path></svg>',
					title : 'DOC',
					separator : false,
					handler : function() {
						try{
							viewer.downloadFile('doc', function(e) {
								$('#crownix-download-iframe').attr('src', e + '&attachment=true');
								});
						}catch(e){
							alert(e);
						}
					  } 
					};
			
			var downloadXLSX = {
					index : 11, 
					id : 'myItem3' , 
					svg : '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="35px" height="35px" viewBox="0 0 24 24" enable-background="new 0 0 24 24" xml:space="preserve" focusable="false"><path fill="none" stroke="#A0A0A0" stroke-width="1" stroke-miterlimit="10" d="M0.505,2.993v17.424c0,0-0.196,3.083,3.278,3.083	c3.473,0,16.858,0,16.858,0s2.856-0.221,2.856-2.688c0-2.463,0-17.819,0-17.819s0.234-2.488-2.645-2.488c-2.881,0-17.797,0-17.797,0	S0.505,0.262,0.505,2.993z"></path><polygon fill="#6CA75C" points="4.625,6.294 9.688,6.294 12.238,9.032 15.088,6.294 20.188,6.294 14.863,12.069 20.188,18.106 	14.863,18.106 11.713,14.618 9.238,17.094 4.063,17.094 9.463,11.994 "></polygon></svg>',
					title : 'XLSX',
					separator : false,
					handler : function() {
						try{
							viewer.downloadFile('xlsx', function(e) {
								$('#crownix-download-iframe').attr('src', e + '&attachment=true');
								});
						}catch(e){
							alert(e);
						}
					  } 
					};

					var downloadPPT = {
					index : 12, 
					id : 'myItem4' , 
					svg : '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="35px" height="35px" viewBox="0 0 24 24" enable-background="new 0 0 24 24" xml:space="preserve" focusable="false"><path fill="none" stroke="#A0A0A0" stroke-width="1" stroke-miterlimit="10" d="M0.505,2.993v17.424c0,0-0.196,3.083,3.278,3.083	c3.473,0,16.858,0,16.858,0s2.856-0.221,2.856-2.688c0-2.463,0-17.819,0-17.819s0.234-2.488-2.645-2.488c-2.881,0-17.797,0-17.797,0	S0.505,0.262,0.505,2.993z"></path><path fill="#C54C1C" d="M11.52,12V7.697c0,0,3.619-0.489,3.619,2.345c0,0,0.174,1.917-3.139,1.958H8.6v6.992h2.981v-4.533h2.668	c0,0,4.063-0.271,3.906-4.625c0,0,0.136-4.652-5.26-4.826H6.844v2.679H8.6V12H11.52z"></path></svg>',
					title : 'PPT',
					separator : false,
					handler : function() {
						try{
							viewer.downloadFile('ppt', function(e) {
								$('#crownix-download-iframe').attr('src', e + '&attachment=true');
								});
						}catch(e){
							alert(e);
						}
					  } 
					};
				
					var downloadHWP = {
					index : 13, 
					id : 'myItem5' , 
					svg : '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="35px" height="35px" viewBox="0 0 24 24" enable-background="new 0 0 24 24" xml:space="preserve" focusable="false"><path fill="none" stroke="#A0A0A0" stroke-width="1" stroke-miterlimit="10" d="M0.505,2.993v17.424c0,0-0.196,3.083,3.278,3.083	c3.473,0,16.858,0,16.858,0s2.856-0.221,2.856-2.688c0-2.463,0-17.819,0-17.819s0.234-2.488-2.645-2.488c-2.881,0-17.797,0-17.797,0	S0.505,0.262,0.505,2.993z"></path><g>	<path fill="#00A0E9" d="M10.689,4.796c0,0,3.411,0.366,4.589,1.954c0,0,0.458,0.326-0.119-0.549c0,0-0.889-2.117-3.075-2.321		c0,0-0.794,0.021-1.25,0.57C10.834,4.451,10.49,4.77,10.689,4.796z"></path>	<path fill="#3897D4" d="M17.922,9.865c0,0-2.691-1.771-6.151,0c0,0-2.667,2.056,0.601,2.809c0,0,1.802,0.081,2.306-2.158		c0,0-0.168-2.789-3.339-3.033c0,0-2.931,0.021-3.339,0.204c0,0-0.265,0.183-0.24-0.407c0,0-0.24-2.015,3.244-1.628		c0,0,5.886,0.264,5.501,5.17c0,0-0.816,3.684-5.141,3.481c0,0-3.604-0.184-3.1-3.013c0,0-0.144-2.606,4.109-3.379		c0,0,3.076-0.692,5.119,0.265c0,0,0.506,0.223,0.553,0.936C18.043,9.112,18.123,9.979,17.922,9.865z"></path>	<path fill="#3897D4" d="M12.516,15.484c0,0-1.177,0.142-1.177,0.997c0,0.854,0.817,0.997,1.177,0.997		c0.361,0,1.153-0.144,1.153-0.978S12.516,15.484,12.516,15.484z"></path>	<path fill="#3897D4" d="M9.201,16.033v1.588c0,0,0.192,0.896,2.018,0.896s5.959-0.121,6.704-0.346		c0.745-0.225-0.48,1.588-0.48,1.588s-4.493,0.61-7.448,0.244c0,0-2.283,0.184-2.835-2.076l-0.12-1.894H9.201z"></path></g></svg>',
					title : 'HWP',
					separator : false,
					handler : function() {
						try{
							viewer.downloadFile('hwp', function(e) {
								$('#crownix-download-iframe').attr('src', e + '&attachment=true');
								});
						}catch(e){
							alert(e);
						}
					  } 
					};

				viewer.hideToolbarItem(["save"]);
				viewer.addToolbarItem(downloadPDF);
				viewer.addToolbarItem(downloadDOC); 
				viewer.addToolbarItem(downloadXLSX); 
				viewer.addToolbarItem(downloadPPT); 
				viewer.addToolbarItem(downloadHWP); 
			viewer.openFile(mrdPath, rdParam,{timeout:180});
		}; 

		</script>
	</body>
</HTML>
