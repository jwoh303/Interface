<%@page contentType="text/html;charset=utf-8"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%-- <%@ page import="Wisehub.Lib.Properties.*;"%> --%>

<HTML>
<HEAD>
<TITLE>Result</TITLE>
</HEAD>
<BODY>
	<jsp:useBean id="cowayService1SoapProxyid" scope="session"
		class="com.koreab2b.mro.webservice.coway.Service1SoapProxy" />
	<%
		//if (request.getParameter("endpoint") != null && request.getParameter("endpoint").length() > 0)
		//cowayService1SoapProxyid.setEndpoint(request.getParameter("endpoint"));
		// 	WisehubProperties WiseConfig = new WisehubProperties();
		// 	WisehubUser Wsession = new WisehubUser(request);

		String path = "TEST";//WiseConfig.getNameValue("wisehub.webservice.cls");

		String tempResultreturnp14 = "";
		String val = "";
		String[] sp = null;
		String point_value = "";

		try {

			String emp_no_1id = "COWAY03";
			// 	        String emp_no_1id=  Wsession.getUserId(); //request.getParameter("emp_no16");
			String flag_2id = request.getParameter("flag18");
			emp_no_1id = emp_no_1id.substring(2);

			java.lang.String getPoint13mtemp = cowayService1SoapProxyid.getPoint(emp_no_1id, path);
			if (getPoint13mtemp == null) {
	%>
	<%=getPoint13mtemp%>
	<%
		} else {
				tempResultreturnp14 = org.eclipse.jst.ws.util.JspUtils.markup(String.valueOf(getPoint13mtemp));
				val = tempResultreturnp14;
				sp = val.split(":");

				if (sp.length > 0) {
					if (sp[0].equals("OK")) {
						point_value = sp[1];
						//out.println("Point:"+sp[1]);
					} else {
						//out.println("Point:0");
					}
				}
			}
		} catch (Exception e) {
	%>
	Exception:
	<%=org.eclipse.jst.ws.util.JspUtils.markup(e.toString())%>
	Message:
	<%=org.eclipse.jst.ws.util.JspUtils.markup(e.getMessage())%>
	<%
		return;
		}
	%>
	<b> &nbsp;&nbsp;&nbsp;Point : <input type="TEXT"
		value="<%=point_value%>" class="input.ccc" size="10" value="원"
		style="background-color: #FFFFFF; font-weight: bold; font-size: 9pt; border: #FFFFFF 1px solid;"
		READONLY>원
	</b>
</BODY>
</HTML>
