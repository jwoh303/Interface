<%@ include file="form/jspheader.jsp" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>



<html:html locale="true">
<head>
    <title><bean:message key="mainmenu.title" /></title>
    <%@ include file="form/htmlheader.jsp" %>
    
</head>

<body bgColor="#FFFFFF" LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0" onLoad="MM_preloadImages('../img/menu_cube_02_s.gif','../img/menu_cube_03_s.gif','../img/menu_cube_01.gif')">
<html:form action="userManagerModify">
  	<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
    	<tr>
      		<td valign="top" background="../img/popup_back.jpg">
      			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			    	<tr>
		          		<td height="50">&nbsp;</td>
        			</tr>
        			<tr>
          				<td height="30" align="right"><a href= javascript:window.close()><img src="../img/btn_close.gif" width="52" height="21" border="0"></a></td>
        			</tr>
        			<tr>
          				<td align = center>
          					<table width="90%" border="0" cellspacing="0" cellpadding="2">
            					<tr>
            					</tr>
            					<tr>
            						<td>
	                					<table class="its" width="50%" border=0 cellpadding=0 cellspacing=1>
	                						<thead>
												<tr height="15">
													<th>항목</th>
													<th>값</th>
												</tr>
											</thead>
											<tbody>
		                						<tr class="odd">
												    <th><label for="firstName">* User ID : </label></th>
												    <td>
												    	<html:text property="userEmpNo"></html:text>
												        
												        
												    </td>
												</tr>
												<tr class="odd">
												    <th><label for="firstName">User Passwd : </label></th>
												    <td>
												    	<html:text property="eaiUserPassword"></html:text>
												    </td>
												</tr>
												<tr class="odd">
												    <th><label for="lastName">User Name : </label></th>
												    <td>
												    	<html:text property="lastName"></html:text>
												    </td>
												</tr>
												<tr class="odd">
												    <th><label for="emailAddress">E-mail :</label></th>
												    <td>
												    	<html:text property="emailAddress"></html:text>
												    </td>
												</tr>
												<tr class="odd">
												    <th><label for="sysUserTp">Level :</label></th>
												    <td>
												    	<SELECT name=sysUserTp>
														      <OPTION value=0>개발자
														      <OPTION value=1>Manager
														      <OPTION value=2>Admin
														</SELECT>
												    </td>
												</tr>
												<tr class="odd">
												    <th><label for="handPhone">Phone Number :</label></th>
												    <td>
												    	<html:text property="handPhone"></html:text>
												    </td>
												</tr>
												<tr class="odd">
												    <th><label>SMS :</label></th>
												    <td>
												        <input type=checkbox checked name=smsChecked />
												        <input type="hidden" name=smsRcvFlag />
												    </td>
												</tr>
											</tbody>
                						</table>
									</td>
            					</tr>
            					<tr  class="odd" align = center>
								    <td>
								        <img src="../img/btn_cube_add.gif" onclick="addClick()">
								        <input type="hidden" name="actionFlag" value="" >
								    </td>
								</tr>
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
