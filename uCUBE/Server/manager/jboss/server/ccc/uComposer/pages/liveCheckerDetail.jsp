<%@ include file="form/jspheader.jsp" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>


<html:html locale="true">
<head>
    <title><bean:message key="mainmenu.title" /></title>
    <%@ include file="form/htmlheader.jsp" %>
    
</head>

<body bgColor="#FFFFFF" LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0" onLoad="MM_preloadImages('../img/menu_cube_02_s.gif','../img/menu_cube_03_s.gif','../img/menu_cube_01.gif')">
<html:form action="/liveCheckerDetail">
  <table width="500" height="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td valign="top" background="../img/popup_back.jpg"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="20">&nbsp;</td>
          <td height="50">&nbsp;</td>
          <td width="20">&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td height="30" align="right"><a href= javascript:window.close()><img src="../img/btn_close.gif" width="52" height="21" border="0"></a></td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td><table width="100%" border="0" cellspacing="0" cellpadding="2">
            <tr bgcolor="#6C84BB" >
            	<td bgcolor="6C91BB">
	                <display:table name="liveCheckerDetail" class="its" pagesize="20">
	                	<display:setProperty name="">basic.msg.empty_list=Adatper Down</display:setProperty>
						<display:column property="linkName" title="LinkName"	group="1" />
						<display:column property="name" 	title="Name"		group="2" />
						<display:column property="type" 	title="Type"		group="3" />
						<display:column property="ip" 		title="IP Addresss"	group="4" />
						<display:column property="status" 	title="Status"		group="5" />
						<display:column property="lqCount" 	title="LQ Count"	group="6" />
						<display:column property="value" 	title="Value"		group="7" />
					</display:table>
				</td>
            </tr>
          </table></td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td align="right">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table></td>
    </tr>
  </table>
</html:form>
</body>
</html:html>
