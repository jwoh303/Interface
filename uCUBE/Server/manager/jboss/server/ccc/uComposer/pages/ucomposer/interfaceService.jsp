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

if(request.getParameter("select.x") != null) {

	PosRowSet rowSet = ctx.getRowSet( "QueryResult");	
	PosRow row = null; 
	String returnValue = "";
	
	for (int i=0; i<rowSet.count(); i++) 
	{ 
		row = rowSet.next();
		
		if(request.getParameter("insert.x") != null) {
			//if(row.getAttribute("version")!=null) 
			returnValue += row.getAttribute("version").toString() + "[";
		}
		else if(request.getParameter("select.x") != null) {
			returnValue += row.getAttribute("service_info").toString() + "|";
			returnValue += row.getAttribute("service_pos_x").toString() + "|";
			returnValue += row.getAttribute("service_pos_y").toString() + "|";
			returnValue += row.getAttribute("service_seq").toString() + "|";
			
			if(row.getAttribute("sender_service_seq") != null) 
				returnValue += row.getAttribute("sender_service_seq").toString();
			
			returnValue += "|";
	
			if(row.getAttribute("engine_queue_info") != null) 
				returnValue += row.getAttribute("engine_queue_info").toString();
			
			returnValue += "|";
			
			returnValue += row.getAttribute("sql_conf_cnt").toString() + "|";
			returnValue += row.getAttribute("layout_conf_cnt").toString();
			
			returnValue +=  "[";
		}
	}
	
	out.println(returnValue);
}
else {
	String returnValue = ctx.get("QueryResult" ).toString().trim();
	out.println(returnValue);
}

%>
