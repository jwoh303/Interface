<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%><%-- session import --%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
<TITLE>RD Viewer Open</TITLE>
<style type="text/css">
html,body {
	height: 100%;
	margin: 0;
}

table {
	height: 100%;
	margin: 0;
}
</style>
</HEAD>
<BODY onload="rdopen()" leftmargin="0px" rightmargin="0px" topmargin="0px" bottommargin="0px">
<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_buyer" id="st_buyer" value= "${param.buyer}"/>
	<input type="hidden" name="st_inv_no" id="st_inv_no"  value="${param.inv_no}"/>
</form>
<script laungage = JavaScript  for=cxviewer  event = "PrintButtonClicked">

if ('${param.fileName}' == "RD_06_X_002_12" || '${param.fileName}' == "RD_06_X_002_11"){
	rdprint();
}

function rdprint(){

	kepAjaxFormCall("/common/updateKtagList.do","processForm","KtagUpdate");
// 	var pData = {st_com_code : "KRKEPB0004", st_from_date : "20110101", st_dept_code : "042"};
// 	kepAjaxCallNoBar("/common/getCheckedPoAgentDeptList2.do",pData,"popup_042_20150225");

}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	var msg = response.msg;

	if (!isEmpty(msg)){
		alert(msg);
		
	} else {
		if(pMethod == "KtagUpdate"){
			alert("Ktag 프린트여부 업데이트가 정상적으로 완료 되었습니다.");
			
		} 
	}
	
	return;
}
//ajax 공통 호출후 실패시 처리 함수
	function  kepAjaxError(pMethod , response) {
		alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}
	
</script>
	<SCRIPT LANGUAGE=javascript>
<%
String fileOpenUrl = (String)request.getAttribute("fileOpenNonActiveX");
String cxServerUrl = (String)request.getAttribute("rdServer");
String cxServerSid = "";
String flag = CommonUtil.getDevRealLocalFlag(request); // 0 로컬 1 개발 2 운영
//if ("2".equals(flag)||"0".equals(flag)){
if ("2".equals(flag)){
	cxServerSid = (String)request.getAttribute("sidRdServerReal");
}else{
	cxServerSid = (String)request.getAttribute("sidRdServerReal");
}

String rdImages = (String)request.getAttribute("rdImage");
String userAgent = (String)request.getHeader("User-Agent");

String cx_viewer_classid = null;
String cx_viewer_codebase = null;
String cx_barcode_classid = null;
String cx_barcode_codebase = null;

if (userAgent.indexOf("MSIE") != -1 && userAgent.indexOf("Win64") != -1 && userAgent.indexOf("x64") != -1){
	   
	   cx_viewer_classid = (String)request.getAttribute("sidX64");
	   cx_viewer_codebase = (String)request.getAttribute("codeBaseX64");
	   
	   cx_barcode_classid = (String)request.getAttribute("barcodeSidX64");
	   cx_barcode_codebase = (String)request.getAttribute("barcodeCodebaseX64");

	}
	else {
	     
	   cx_viewer_classid = ((String)request.getAttribute("sid"));
	   cx_viewer_codebase = ((String)request.getAttribute("codeBase"));
	   
	   cx_barcode_classid = (String)request.getAttribute("barcodeSid");
	   cx_barcode_codebase = (String)request.getAttribute("barcodeCodebase");

	}

%>

function rdopen()
{
	cxviewer.AutoAdjust = true;
	cxviewer.ZoomRatio = 100;
	cxviewer.ApplyLicense('<%=cxServerUrl.replace("[","").replace("]","")%>');
 
//	var param = "[IV17317474][KRKORE0001][KRHWAS0031][MO2017-08-00250][00007]";
//	var report_name = "RD_06_S_001_59.mrd";
	
	$("#cxviewer").focus();
//	cxviewer.SetAppendReport(1);
// alert("<%=fileOpenUrl%>${param.fileName}.mrd");
	cxviewer.FileOpen("<%=fileOpenUrl%>${param.fileName}.mrd", "/rf <%=cxServerUrl%> /rsn <%=cxServerSid%>	/rp ${param.param}");
//	cxviewer.FileOpen("<%=fileOpenUrl%>"+report_name, "/rf <%=cxServerUrl%> /rsn <%=cxServerSid%>	/rp " + param);
}

	</SCRIPT>


	<object id=rdbarcode5 classid="<%=cx_barcode_classid%>" width=0% height=0% codebase="<%=cx_barcode_codebase%>"> </object>

	<object id=cxviewer name=cxviewer width=100% height=100% classid="<%=cx_viewer_classid%>" codebase="<%=cx_viewer_codebase%>"></object>

</BODY>
</HTML>
