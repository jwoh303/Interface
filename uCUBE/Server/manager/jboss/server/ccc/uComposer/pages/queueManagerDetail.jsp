<%@ include file="form/jspheader.jsp" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>


<html:html locale="true">
<head>
    <title><bean:message key="mainmenu.title" /></title>
    <%@ include file="form/htmlheader.jsp" %>
    <%@ page import="com.posdata.eai.manager.jms.MessageProperties"%>
    
</head>

<body bgColor="#FFFFFF" LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0" onLoad="MM_preloadImages('../img/menu_cube_02_s.gif','../img/menu_cube_03_s.gif','../img/menu_cube_01.gif')">
<html:form action="/queueManagerDetail">
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
          				<td>
          					<table width="100%" border="0" cellspacing="0" cellpadding="2">
            					<tr bgcolor="#6C84BB" >
            						<td bgcolor="6C91BB">
	                					<display:table name="messageList" id="testit" class="its" pagesize="20" requestURI="/queueManagerDetail.do">
	                						<display:column title="#"><%=pageContext.getAttribute("testit_rowNum")%></display:column>
											<display:column property="messageId" />
											<display:column property="jmsDestination" />
											<display:column property="jmsTimeStamp" />
											<display:column title="#"><%=((MessageProperties)pageContext.getAttribute("testit")).getMessage()%></display:column>
										</display:table>
									</td>
            					</tr>
          					</table>
          				</td>
        			</tr>
        			<tr>
          				<td height="10">&nbsp;</td>
        			</tr>
        			<tr>
          				<td align="center"><textarea name="data" cols="65"></textarea></td>
        			</tr>
      			</table>
      		</td>
    	</tr>
  	</table>
</html:form>
</body>
</html:html>
