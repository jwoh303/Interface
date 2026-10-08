<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>

<%@ page import="com.posdata.glue.dao.vo.PosRowSet,
com.posdata.glue.context.PosContext,
com.posdata.glue.dao.vo.PosRow,
java.util.ArrayList" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>


<%

PosContext ctx = (PosContext)request.getAttribute( "PosContext" );
PosRowSet rowSet = ctx.getRowSet( "MainListResult");
PosRow row = null; 
String returnValue = "";

for (int i=0; i<rowSet.count(); i++)
{ 
	row = rowSet.next();
	
	if(row.getAttribute("system_seq")!=null) returnValue += row.getAttribute("system_seq").toString();
	returnValue += "|";
	if(row.getAttribute("system_id")!=null) returnValue += row.getAttribute("system_id").toString();
	returnValue += "|";
	if(row.getAttribute("service_group_seq")!=null) returnValue += row.getAttribute("service_group_seq").toString();
	returnValue += "|";
	if(row.getAttribute("service_group_id")!=null) returnValue += row.getAttribute("service_group_id").toString();
	returnValue += "|";
	if(row.getAttribute("service_seq")!=null) returnValue += row.getAttribute("service_seq").toString();
	returnValue += "|";
	if(row.getAttribute("service_id")!=null) returnValue += row.getAttribute("service_id").toString();
	returnValue += "|";
	if(row.getAttribute("interface_seq")!=null) returnValue += row.getAttribute("interface_seq").toString();
	returnValue += "|";
	if(row.getAttribute("interface_id")!=null) returnValue += row.getAttribute("interface_id").toString();
	returnValue += "|";
	if(row.getAttribute("service_category")!=null) returnValue += row.getAttribute("service_category").toString();
	returnValue += "|";
	if(row.getAttribute("sub_exist")!=null) returnValue += row.getAttribute("sub_exist").toString();
	returnValue += "]";
//	out.println(i+" "+arrTreeNode[i][8]+"<br>");
}

out.println(returnValue);

%>
