<%@ include file="form/jspheader.jsp"%>
<%@ include file="form/loginCheck.jsp"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html:html locale="true">
<head>
<title><bean:message key="mainmenu.title" /></title>
<%@ include file="form/htmlheader.jsp"%>


<script language="javascript">

function uploadPopup()
{
	openWindow("/uComposer/uploadFile.do");
	return false;
}

</script>

</head>

<body bgColor="#FFFFFF" LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0"
	MARGINHEIGHT="0"
	onLoad="MM_preloadImages('img/menu_cube_01_s.gif','img/menu_cube_02_s.gif','img/menu_cube_03_s.gif')">
<html:form action="/addInterface">
	<div id="Layer1"
		style="position:absolute; width:240px; height:20px; z-index:1; left: 708px; top: 91px; font-size: 12px; color: #003063; font-weight: bold;">
	<a href="/uComposer/interfaceList.do">Interface List&#13;</a> | <a
		href="/uComposer/addInterface.do">Add Interface&#13;</a></div>
	<table width="100%" height="600" border="0" cellpadding="0"
		cellspacing="0">
		<tr>
			<td align="center" valign="top" background="../img/back.JPG">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr height="10">
					<td height="10"></td>
					<td width="749"></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="right"><span class="style3"> </span>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="620" height="25" align="right" class="style5"><%java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat(
							"yyyy/MM/dd HH:mm:ss");

					%>Current Time : <%=dateFormat.format(new java.util.Date())%></td>
							<td valign="top">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="10">&nbsp;</td>
									<td><a href="#"
										onclick="ConfirmChoice('/uComposer/login.do?event=logout','Are you sure you want to logout?');return false; "><img
										src="../img/btn_cube_logout.gif" width="71" height="21"
										border="0"></a></td>
								</tr>
							</table>
							</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td width="220">&nbsp;</td>
					<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td align="right" width="30"
								background="../img/menu_cube_back.gif">&nbsp;</td>
							<td width="113"><a href="/uComposer/historyEventView.do"><img
								src="../img/menu_cube_01.gif" name="Image1" width="113"
								height="47" border="0"></a></td>
							<td width="118"><a href="/uComposer/eventAudit.do"> <img
								src="../img/menu_cube_02.gif" name="Image2" width="118"
								height="47" border="0"></a></td>
							<td width="145"><a href="/uComposer/queueMonitor.do"> <img
								src="../img/menu_cube_03.gif" name="Image3" width="145"
								height="47" border="0" id="Image3"></a></td>
							<%if (session.getAttribute("level").equals("1")) {

					%>
							<td width="150"><img src="../img/menu_cube_04_s.gif"
								name="Image3" width="150" height="47" border="0" id="Image3"></td>
							<td width="134"><img src="../img/menu_cube_05.gif" name="Image3"
								width="134" height="47" border="0" id="Image3"></td>
							<%} else {

					%>
							<td width="150"><a href="/uComposer/interfaceList.do"> <img
								src="../img/menu_cube_04_s.gif" name="Image3" width="150"
								height="47" border="0" id="Image3"></a></td>
							<td width="134"><a href="/uComposer/interfaceGenerator.do"> <img
								src="../img/menu_cube_05.gif" name="Image3" width="134"
								height="47" border="0" id="Image3"></a></td>
							<%}

					%>
							<td background="../img/menu_cube_back.gif">&nbsp;</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="30" valign="top">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">
					<table border="0" cellspacing="0" cellpadding="0" valign="top"
						width="100%">
						<tr valign="top">
							<td width="10"><img src="../img/comm_img_0004.gif" width="10"
								height="10" border="0"></td>
							<td background="../img/comm_img_0005.gif" width="679"></td>
							<td width="11"><img src="../img/comm_img_0006.gif" width="11"
								height="10" border="0"></td>
						</tr>
						<tr valign="top">
							<td background="../img/comm_img_0007.gif"></td>
							<td bgcolor="#EBEFFC" width="100%">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td width="120" align="center"><font color="003063"> <strong><img
										src="../img/dot_blue.gif" width="10" height="10"><font
										color="003063"><strong></strong></font>Interface ID : </strong>
									</font></td>
									<td><input name="ifid" type="text" value=""></td>
									<td width="120" align="center"><strong><font color="003063"><strong><img
										src="../img/dot_blue.gif" width="10" height="10"><font
										color="003063"><strong></strong></font>TC Code : </strong> </font></td>
									<td><input name="tccode" type="text" value=""></td>
									<td align="right"><input type="image"
										src="../img/btn_cube_search.gif" value="Submit" alt="search">
									<input type="image" src="../img/btn_cube_add.gif" value="add"
										alt="add"> <input type="image"
										src="../img/btn_cube_delete.gif" value="delete" alt="delete">
									<input type="image" src="../img/btn_add.gif" value="popup"
										alt="popup" onClick="return uploadPopup()"></td>
								</tr>
							</table>
							</td>
							<td width="11" background="../img/comm_img_0008.gif">&nbsp;</td>
						</tr>
						<tr valign="top">
							<td width="10"><img src="../img/comm_img_0009.gif" width="10"
								height="10" border="0"></td>
							<td background="../img/comm_img_0010.gif" width="679"></td>
							<td width="11"><img src="../img/comm_img_0011.gif" width="11"
								height="10" border="0"></td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td valign="top">&nbsp;</td>
				</tr>
				<tr>
					<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="2">
						<tr bgcolor="#6C84BB">
							<td bgcolor="6C91BB"><%System.out.println("=================================");%>
							<!-- Table added end --> <display:table name="interfaceList"
								class="its" defaultsort="1">
								<display:column property="aaaaa" class="left" title="±¸ºÐ"
									group="1" />
								<display:column property="aaaaa" class="left" title="I/F ID"
									group="2" />
								<display:column property="aaaaa" class="left" title="TC" />
								<display:column property="aaaaa" class="left" title="TC NM" />
								<display:column property="aaaaa" class="left" title="aaaa" />
								<display:column property="aaaaa" class="left" title="aaaa" />
								<display:column property="aaaaa" class="left" title="aaaa" />
								<display:column property="aaaaa" class="left" title="aaaa" />
								<display:column property="aaaaa" class="left" title="aaaa" />
								<display:column property="aaaaa" class="left" title="aaaa" />
								<display:column property="aaaaa" class="left" title="aaaa" />
								<display:column property="aaaaa" class="left" title="aaaa" />
								<display:column property="aaaaa" class="left" title="aaaa" />
								<display:column property="aaaaa" class="left" title="aaaa" />
								<display:column property="aaaaa" class="left" title="aaaa" />
								<display:column property="aaaaa" class="left" title="aaaa" />
							</display:table> <!-- Table added end --></td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
	<div align="center"></div>
</html:form>
</body>
</html:html>
