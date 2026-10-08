<%@ include file="form/jspheader.jsp"%>
<%@ include file="form/loginCheck.jsp"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html:html locale="true">
<head>
<title><bean:message key="mainmenu.title" /></title>
<link rel="stylesheet" href="../css/pub.css" type="text/css">
<link rel="stylesheet" href="../css/menu.css" type="text/css">

<%@ include file="form/htmlheader.jsp"%>

<script language="javascript" src="../js/searching.js"></script>
<script language="javascript" src="../js/balloon.js"></script>
<script language="javascript" src="../js/menu.js"></script>
</head>


<body topmargin=0 leftmargin=0 onLoad="MM_preloadImages('../img/ucube_img04_menu_over.gif','../img/ucube_img05_menu_over.gif','../img/ucube_img06_menu_over.gif','../img/ucube_img07_menu_over.gif','../img/ucube_img08_menu_over.gif','../img/clock.gif')">
<html:form action="/liveChecker">

<%@ include file="header.jsp"%>
	<!--<div id="Layer1"
		style="position:absolute; width:400px; height:20px; z-index:1; left: 650px; top: 91px; font-size: 12px; color: #003063; font-weight: bold;">
	<a href="/uComposer/interfaceGenerator.do">Interface Generation </a>
	| <a href="/uComposer/queueManager.do">Queue Manager</a> |<a
		href="/uComposer/liveChecker.do"> Live Checker </a></div>-->
	<table width="100%" height="600" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center">
						<table width="1000" border="0" cellspacing="0" cellpadding="0">
						<tr> 
				<td background="../img/m000006img.gif" ><img src="/img/m000006img.gif" width="2" height="7"></td>
			</tr>			
			<tr bgcolor=white> 
				<td height=25> 
					<table width="980" border="0" cellspacing="0" cellpadding="0" height="25">
						<tr >
							<!-- title -->
							<td width=500>&nbsp;<font size="3"><b> Live Checker </b></font></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr bgcolor=white> 
				<td background="../img/m000006img.gif" ><img src="/img/m000006img.gif" width="2" height="7"></td>
			</tr>
			</table>
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<!--<tr>
					<td width="20" height="2" valign="top">&nbsp;</td>
					<td height="40" valign="top">&nbsp;</td>
					<td width="20" valign="top">&nbsp;</td>
				</tr>-->
				<tr>
					<td valign="top">&nbsp;</td>
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
							<td width="10" background="../img/comm_img_0007.gif"></td>
							<!-- form start  -->
							<td bgcolor="#EBEFFC" width="100%">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td width="120" align="center"><font color="003063"> <strong><img
										src="../img/dot_blue.gif" width="10" height="10"><font
										color="003063"><strong></strong></font>Adapter Name : </strong>
									</font></td>
									<td><html:text styleClass="formfield" size="25"
										property="adapterName" /></td>
									<td width="120" align="center"><strong><font color="003063"><strong><img
										src="../img/dot_blue.gif" width="10" height="10"><font
										color="003063"><strong></strong></font>Host Name<strong><font
										color="003063"> : </font></strong></strong> </font></strong></td>
									<td><html:text styleClass="formfield" size="25"
										property="hostName" /></td>
									<td><input type=hidden name="event"
										value="<%=request.getParameter("event")%>" /> <html:image
										src="../img/btn_cube_search.gif" /></td>
								</tr>
							</table>
							</td>
							<!-- form end  -->
							<td width="10" background="../img/comm_img_0008.gif">&nbsp;</td>
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
					<td valign="top">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">&nbsp;</td>
					<td valign="top">&nbsp;</td>
					<td valign="top">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="2">
						<tr bgcolor="#6C84BB">
							<td bgcolor="6C91BB"><!-- Table added end --> <display:table
								name="adapterList" class="its" sort="list" scope="request"
								requestURI="/liveChecker.do"
								decorator="com.posdata.eai.manager.struts.decorator.BaseDecorator"
								defaultsort="1" id="row">
								<display:column property="hostName" title="Host Name" group="1"
									sortable="true" headerClass="sortable" />
								<display:column property="fetchAdapterLink" title="Adapter Name"
									group="2" sortable="true" headerClass="sortable" />
								<display:column property="ipAddress" title="IP Address"
									group="3" sortable="true" headerClass="sortable" />
								<display:column property="port" title="Port Number" group="4"
									sortable="true" headerClass="sortable" />
							</display:table> <!-- Table added end --></td>
						</tr>
					</table>
					</td>
					<td>&nbsp;</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
	<div align="center"></div>
</html:form>
</body>
</html:html>
