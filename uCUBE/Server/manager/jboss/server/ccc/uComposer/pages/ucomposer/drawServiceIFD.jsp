<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>

<%@ page contentType="text/html;charset=UTF-8"%>

<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<script language="JavaScript" src="js/showErrorPopup.js"></script>


<script>

function goClose() {
	self.close();
}

</script>


<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="/css/pub.css" type="text/css">
	<title>uComposer Distribute</title>
</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin=0 leftmargin=0>

	<form name="formDistList" method="post" action="distributeListAction.do" >
		<input type="hidden" name="ServiceName" value="distributeList-service">
		<posui:showMessage/>

		<table width=1000 border=0 cellpadding=0 cellspacing=0>
			<tr>
				<td height="45" bgcolor="0E3F61">
					<table width="1000" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="16">&nbsp;</td>
							<td>
								<font size="6" color="#FFFFFF">uComposer - Distributor </font>
							</td>
						</tr>
					</table>
				</td>
			</tr>

			<tr>
				<td height="10"></td>
			</tr>

			<tr>
				<td>
					<table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td height=25><font size="4"><b>분배 대상 조회</b></font></td>
						</tr>

						<tr>
							<td background="img/m000006img.gif"><img src="img/m000006img.gif" width="12" height=7></td>
						</tr>

						<tr>
							<td>
								<table width="980" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
									<tr>
										<td class="tbllg" height=25 width="700">
											<img src="img/m000008img.gif" width="7">
											<b>System:</b>
											<% if( request.getParameter("inputsystem") != null ){ %>
												<input type="text" name="inputsystem" style="width:100" class=adff value="<%= request.getParameter("inputsystem") %>">
											<% }else { %>
												<input type="text" name="inputsystem" style="width:100" class=adff value="">
											<%}%>
											&nbsp;

											<b>Service:</b>
											<% if( request.getParameter("inputservice") != null ){ %>
												<input type="text" name="inputservice" style="width:100" class=adff value="<%= request.getParameter("inputservice") %>">
											<% }else { %>
												<input type="text" name="inputservice" style="width:100" class=adff value="">
											<%}%>
											&nbsp;

											<b>IFID:</b>
											<% if( request.getParameter("inputifid") != null ){ %>
												<input type="text" name="inputifid" style="width:100" class=adff value="<%= request.getParameter("inputifid") %>">
											<% }else { %>
												<input type="text" name="inputifid" style="width:100" class=adff value="">
											<%}%>
										</td>
										<td class="tbllg" height=25 width="280" align="absmiddle">
											<div align="right">
												<posui:showUtilityButtons
													names="find|distribute|close"
													onClick="null|null|javascript: return goClose()"
													imgs="img/m000001ico.gif|img/distribute.gif|img/m000005ico.gif"
												/>
											</div>
										</td>
									</tr>
								</table>
							</td>
						</tr>

						<tr>
							<td background="img/m000006img.gif"><img src="img/m000006img.gif" width="12" height=7></td>
						</tr>

						<tr>
							<td>
								<posui:showTable
									tableName="distlisttable"
									infoName="DistListResult"
									columnNames="null|null|null"
									columnWidths="326|326|328"
									height="23"
									headerValues="Function SEQ|Function Type|설명"
									headerClasses="tbldb"
									trClasses="tblcg|tblcw"
									tdClasses="null|null|null"
									displayTypes="null|null|null"
									attributes="function_unit_type_seq|function_unit_type_id|description"
								/>
							</td>
						</tr>

					</table>
				</td>
			</tr>
		</table>
	</form>

</body>

</html>
