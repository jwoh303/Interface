<%@ include file="form/jspheader.jsp"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>

<%@ page import="com.posdata.glue.dao.vo.PosRowSet,
					com.posdata.glue.context.PosContext,
					com.posdata.glue.dao.vo.PosRow,
					com.posdata.glue.util.log.PosLog" %>

<%@ page import = "java.util.*" %>

<%
	PosContext ctx = (PosContext)request.getAttribute( "PosContext" );
	// 현재날짜
	java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");


%>

<html>
<%
	String loginResult = (String)request.getAttribute("loginResult");
	if( loginResult != null ) out.println("<script>alert('" + loginResult +"');</script");
%>
<head>
<title><bean:message key="login.title" /></title>
<%@ include file="form/htmlheader.jsp"%>

<script language="JavaScript">
function login() {

//alert(LoginForm.id.value);
	if ( LoginForm.id.value == "" ) {
	//document.forms[0].id.value;
	//document.LoginForm.id.value;
	//	alert("Username을 입력하세요");
		LoginForm.id.focus();
		return false;
	} 
	if ( LoginForm.password.value == "" ) {
		alert("Password을 입력하세요");
		LoginForm.password.focus();
		return false;
	}
	LoginForm.submit();	
}
function executeEnterKey(){
	if( event.keyCode == 13 ) LoginForm.submit();	
}
</script>
</head>

<body>

<form name=LoginForm method="post" action="login.do">
<input type="hidden" name="ServiceName" value="login-service" />
<input type="hidden" name="find.x" value="1" />
	<div id="body"><BR>
	<BR>
	<BR>
	<BR>
	<BR>
	
<table width="697" height="100"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
<table width="697" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="184" colspan="3"><img src="/uComposer/img/ucube_img00_login01.JPG" width="697" height="184"></td>
  </tr>
  <tr>
    <td width="348"><img src="/uComposer/img/ucube_img00_login02.JPG" width="348" height="126"></td>
    <td width="306" height="126" align="center" valign="top" background="/uComposer/img/ucube_img00_login04.JPG"><table width="50"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td><img src="/uComposer/img/comm_img02_blank.gif" width="10" height="5"></td>
      </tr>
    </table>      
    <table width="260"  border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="85"><img src="/uComposer/img/comm_img00_login_username.gif" width="78" height="12"></td>
        <td> <input type="text" name="id"  style="solid" value="" size="12" titleKey="login.title.username" tabindex="1"></td>
        <td width="65" rowspan="3" valign="bottom">
        <img src="/uComposer/img/comm_img00_login_btn.gif" width="52" height="22" style="cursor:hand" onclick="return login();" /></td>
      </tr>
      <tr>
        <td colspan="2"><img src="/uComposer/img/comm_img02_blank.gif" width="10" height="5"></td>
        </tr>
      <tr>
        <td><img src="/uComposer/img/comm_img00_login_password.gif" width="71" height="13"></td>
        <td><input type="password"  name="password" value="" tabindex="2" titleKey="login.title.password" size="12" maxlength="8" onkeypress="javascript:return executeEnterKey();" /></td>
     </tr>
    </table></td>
    <td width="43"><img src="/uComposer/img/ucube_img00_login03.JPG" width="43" height="126"></td>
  </tr>
</table>
<table width="50"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="/uComposer/img/comm_img02_blank.gif" width="10" height="10"></td>
  </tr>
</table>
<table width="697"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="right" valign="top"><img src="/uComposer/img/comm_img00_login_copyright.gif" width="697" height="44"></td>
  </tr>
</table>
</div>
</form>
</body>
</html>
