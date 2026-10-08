<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>

<%@ page import="com.posdata.glue.context.PosContext" %>

<%@ page contentType="text/html;charset=UTF-8"%>

<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>

<%
	PosContext ctx = (PosContext)request.getAttribute("PosContext" );
	String returnValue = ctx.get("deleteResult" ).toString();
	out.println(returnValue);
%>