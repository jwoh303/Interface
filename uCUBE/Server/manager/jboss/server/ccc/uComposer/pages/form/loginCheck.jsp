<%@ page import="com.posdata.glue.dao.vo.PosRowSet,
				com.posdata.glue.context.PosContext,
				com.posdata.glue.dao.vo.PosRow,
				com.posdata.glue.util.log.PosLog" %>
<%
     PosContext ctx1 = (PosContext)request.getAttribute( "PosContext" );
     int level =0;
      //level =Integer.parseInt(ctx1.getSessionUserData("level").toString());
     if(ctx1==null) {
     //	response.sendRedirect("/uComposer");
     //	return;
     }
%>
