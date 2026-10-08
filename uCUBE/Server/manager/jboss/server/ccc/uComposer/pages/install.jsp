<%@ include file="form/jspheader.jsp"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html:html locale="true">
<head>
<title><bean:message key="mainmenu.title" /></title>
<%@ include file="form/htmlheader.jsp"%>


<script language="javascript">

function install()
{
	alert("초기 화면으로 이동합니다.");
	document.InstallForm.actionFlag.value="install";
}
</script>
</head>

<body bgColor="#FFFFFF" LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0"
	MARGINHEIGHT="0"
	onLoad="MM_preloadImages('../img/menu_cube_02_s.gif','../img/menu_cube_03_s.gif','../img/menu_cube_01.gif')">
<html:form action="/install">
	<table width="100%" height="100%" border="0" cellpadding="0"
		cellspacing="0">
		<tr>
			<td valign="top" background="../img/back.JPG">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="50">&nbsp;</td>
				</tr>
				<tr>
					<td height="30" align="right"><a href=javascript:window.close()><img
						src="../img/btn_close.gif" width="52" height="21" border="0"></a></td>
				</tr>
				<tr>
					<td>
					<table align="center" width="80%" border="0" cellpadding="10"
						cellspacing="1">
						<tr>
							<td bgcolor="#e8e8e8" colspan="2"><span class="title">Installation
							Options</span></td>
						</tr>
						<tr>
							<td>Type of Database</td>
							<td><html:select property="dbType">
								<html:option value="ORACLE">Oracle (default)</html:option>
								<html:option value="MYSQL">MySql</html:option>
							</html:select></td>
						</tr>

						<tr>
							<td>Hostname (for Database Server)</td>
							<td><html:text property="dbUrl" /></td>
						</tr>

						<tr>
							<td>Username (for Database)</td>
							<td><html:text property="dbUserName" /></td>
						</tr>

						<tr>
							<td>Password (for Database)</td>
							<td><html:text property="dbUserPasswd" /></td>
						</tr>

						<tr>
							<td>Database name (for Database)</td>
							<td><html:text property="dbName" /></td>
						</tr>
						<tr>
							<td>Database Max Connection (recommend, less than 5)</td>
							<td><html:text property="dbMaxConnection" /></td>
						</tr>
						<tr>
							<td>Admin Username (to create Database)</td>
							<td><html:text property="adminUserName" /></td>
						</tr>

						<tr>
							<td>Admin Password (to create Database)</td>
							<td><html:text property="adminUserPasswd" /></td>
						</tr>

						<tr>
							<td>Attempt Installation</td>
							<td><input name="go" type="submit"
								value="Install/Upgrade Database" onclick="install()"></input></td>
						</tr>
						<input type="hidden" name="actionFlag" value="">
						<html:messages property="property" message="true" id="msg">
							<tr>
								<td><%=pageContext.getAttribute("msg")%></td>
							</tr>
						</html:messages>
					</table>
					</td>
				</tr>
				<tr>
					<td height="10">&nbsp;</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
</html:form>
</body>
</html:html>
