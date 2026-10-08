<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>

<%@ page import="com.posdata.glue.dao.vo.PosRowSet,
com.posdata.glue.context.PosContext,
com.posdata.glue.dao.vo.PosRow,
java.util.ArrayList" 
%>

<%@ page contentType="text/html;charset=UTF-8"%>

<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>

<%

PosContext ctx = (PosContext)request.getAttribute( "PosContext" );

if(request.getParameter("delete.x") != null) {
	String returnValue = ctx.get("queryResult").toString();
	out.println(returnValue);
}

%>
