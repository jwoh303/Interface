<%
	PosContext ctx = (PosContext)request.getAttribute( "PosContext" );
	PosRowSet rowSet = null; 
	PosRow row = null;
%>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>

<%@ page contentType="text/html;charset=UTF-8"%>

<%@ page import="com.posdata.glue.dao.vo.PosRowSet,
					com.posdata.glue.context.PosContext,
					com.posdata.glue.dao.vo.PosRow" %>

<%@ page import = "java.util.*" %>
<%@ page import = "com.posdata.glue.dao.vo.*" %>
<%@ page import = "com.posdata.glue.util.log.PosLog" %>

<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>

<script language="javascript" src="js/showErrorPopup.js"></script>
<script language="JavaScript" src="js/showCalendar.js"></script>
<script language="JavaScript" src="js/messcript.js"></script>
<script language="JavaScript" src="js/common.js"></script>

<html>
<head>
<title>Service Management</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="css/pub.css" type="text/css">
<base target="_self">
</head>

<script type="text/javascript" src="tree/js/ajax.js"></script>

<script language = "javascript">
<!--

	var ajaxObjects = new Array();
	
	function checkIDExist() {
		
		if(!service_id.value) {
			alert("Service ID를 입력해주세요."); //alert("No Service ID!!!");
			service_id.focus();
			return false;
		} 
		else {
			var ajaxIndex = ajaxObjects.length;
			ajaxObjects[ajaxIndex] = new sack();
			var url = "uComposerCheckIDAction.do?ServiceName=uComposerCheckID-service&select.x=1&service_group_seq="+service_group_seq.value+"&service_id="+service_id.value;
			ajaxObjects[ajaxIndex].requestFile = url;	// Specifying which file to get
			ajaxObjects[ajaxIndex].onCompletion = function() { selectIdComplete(ajaxIndex); } ;	// Specify function that will be executed after file has been found
			ajaxObjects[ajaxIndex].runAJAX();		// Execute AJAX function
		}
	}
	
	function selectIdComplete(index) {
		var ajaxResponse = (ajaxObjects[index].response).replace(/\s/g, "");
		
		document.getElementById("id_check").value = ajaxResponse;
		
		if(ajaxResponse=="OK") {
			alert("사용가능한 Service ID입니다."); //alert("Available ID!!!");
		}
		else {
			alert("이미 사용중이거나 사용 불가능한 Service ID입니다."); //alert("Not Available ID!!!");
		}
	}
	
	function checkValue() {
		if(service_seq.value=="") {
			var id_check = document.getElementById("id_check");
			if(id_check.value!="OK") {
				alert("Check ID 버튼을 눌러주세요."); //alert("Check ID!!!");
				return false;
			}
		}
	
		for(var i=0; i<column_value.length; i++) {
			if(column_value[i].value=="") { alert("No "+column_name[i]+" value!!!"); column_value[i].focus(); return false; }
		}
		
		return true;
	}

// -->
</script>

<body bgcolor="#FFFFFF" text="#000000" topmargin=0 leftmargin=0>
<form name="form1" method="post" action="uComposerServiceAction.do" onSubmit="javascript:return checkValue();">
	<input type="HIDDEN" name="ServiceName" value="uComposerService-service"/>
	<input type="HIDDEN" name="insert.x" value="1"/>
	<input type="HIDDEN" id="service_group_seq" name="service_group_seq" value=""/>
	<input type="HIDDEN" id="service_seq" name="service_seq" value=""/>
	<input type="HIDDEN" id="id_check" name="id_check" value=""/>
	
  <posui:showMessage/>
  <table width=100% border=0 cellpadding=0 cellspacing=0>
	<tr> 
      <td height="23"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="e5e5e5" height="23">
          <tr>
            <td width = 700></td>
            <td width = 300 align="right" height=25></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
          <tr> 
            <td height=25><b>Service Management</b></td>
          </tr>
          <tr> 
            <td background="img/m000006img.gif"><img src="img/m000006img.gif" width="12" height=7></td>
          </tr>
          
          <tr> 
            <td> 
              <table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
              	
              	<tr><td class="tbllg" height=25 width="280"><img src="img/m000008img.gif"><b>&nbsp;service_id :</b></td><td class="tbllg" height=25 width=""><input type="text" id="service_id" name="service_id" style="width:300" class=adf value=""  onChange="javascript:document.getElementById('id_check').value = '';"> <font color=red>*</font> <input type="button" value="Check ID" onClick="checkIDExist();" id="check_id" style="display:none"> </td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;description :</b></td><td class="tbllg" height=25 width=""><input type="text" id="description" name="description" style="width:300" class=adf value=""></td></tr>

<% 
	if(ctx.getRowSet( "uComposerServiceGroupFunctionResult") != null){
	
		rowSet = ctx.getRowSet( "uComposerServiceGroupFunctionResult");
		rowSet.reset();
		
		Object before_function_unit_type_seq = null;

		while(rowSet.hasNext()) {
			row = rowSet.next();
%>

			<% if(before_function_unit_type_seq==null || !row.getAttribute("function_unit_type_seq").equals(before_function_unit_type_seq)) { %>
				<tr> 
                	<td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;Function Unit Type ID :</b></td>
                    <td class="tbllg" height=25 width=""><%=row.getAttribute("function_unit_type_id") %></td>
                </tr>
			<% } %>
				<tr> 
                	<td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;<%=row.getAttribute("column_name_definition_id") %> :</b></td>
                    <td class="tbllg" height=25 width="">
                    	<input type="hidden" name="function_unit_id" value="<%=row.getAttribute("function_unit_type_id") %>">
                    	<input type="hidden" name="function_unit_type_seq" value="<%=row.getAttribute("function_unit_type_seq") %>">
                    	
                    	<input type="hidden" name="column_name_definition_seq" value="<%=row.getAttribute("column_name_definition_seq") %>">
                    	&nbsp; <img src="tree/images/folder_sub.gif" border="0"> 
			<% if(row.getAttribute("input_type")!=null && row.getAttribute("input_type").equals("S")) { %>                    	
            	<% 
            		StringTokenizer st = new StringTokenizer(row.getAttribute("input_values").toString(), ";"); 
            		String strToken = null; 
            	%>
                    	<select name="column_value" style="width:300">
                    		<% while(st.hasMoreTokens()){ strToken = st.nextToken(); %>
                    		<option value="<%=strToken %>"><%=strToken %></option>
                    		<% } %>
                    	</select>
			<% } else { %>
						<input type="text" name="column_value" style="width:300" class=adf value="<% if(row.getAttribute("insert_value") != null) { %><%=row.getAttribute("insert_value") %><% } else if(row.getAttribute("default_value") != null) { %><%=row.getAttribute("default_value") %><% } else { %><% } %>" <%=row.getAttribute("type").equals("INTEGER")?"onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'":"" %>> <font color=red>*</font>
			<% } %>
                    </td>
                </tr>

<%
			before_function_unit_type_seq = row.getAttribute("function_unit_type_seq");
		}
	}
%>
 
                <tr>
 					<td class="tbllg" height=25 width=""></td>
					<td class="tbllg" height=25 width="" align="absmiddle">
                  		<!-- posui:showUtilityButtons names="insert" 
                        	onClick="null|null|null|null|null|javascript: return call()"
                        	imgs="img/m000007ico.gif|img/m000004ico.gif|img/m000005ico.gif" / -->
                        	
                        	<input type="image" src="img/m000007ico.gif">
                        	<img src="img/m000005ico.gif" onClick="javascript:self.close();" style="border:0;cursor:pointer;">
                  	</td>
                </tr>
              </table>
	    </td>
	  </tr>
	  <tr>
		<td>
			<posui:showTable
				tableName="ServiceTable"
				infoName="uComposerServiceAllResult"
				columnNames="null|null|null"
				columnWidths="200|200|200"
				height="23"
				headerValues="SERVICE_SEQ|SERVICE_ID|DESCRIPTION"
				headerClasses="tbldb"
				trClasses="tblcg|tblcw|tblcg"
				tdClasses="tbllb|null|null"
				displayTypes="null|null|null"
				attributes="service_seq|service_id|description"
			/>
		</td>
	  </tr>
	  <tr> 
        <td background="img/m000006img.gif"><img src="img/m000006img.gif" width="12" height=7></td>
      </tr>
		 
    </table>

	</td>
	</tr>
  </table>
</form>

</body>

</html>

<script>

	var service_group_seq = document.getElementById("service_group_seq");
	var service_seq = document.getElementById("service_seq");
	var service_id = document.getElementById("service_id");
	var description = document.getElementById("description");

	var column_value = document.getElementsByName("column_value");
	var column_name = new Array(column_value.length);

<%
	rowSet.reset();
	
	for(int i=0; rowSet.hasNext(); i++) {
		row = rowSet.next();
	
		out.println("column_name["+i+"] = '"+row.getAttribute("column_name_definition_id").toString()+"';");
		
	}
%>

<%
	if(ctx.getRowSet( "ServiceResult") != null){
		rowSet = ctx.getRowSet( "ServiceResult");
		rowSet.reset();
		
		if(rowSet.hasNext()) {
			row = rowSet.next();
		}
	}
%>

	service_group_seq.value = "<%=(row!=null && row.getAttribute("service_group_seq")!= null)?row.getAttribute("service_group_seq"):request.getParameter("service_group_seq") %>";
	service_seq.value = "<%=(row!=null && row.getAttribute("service_seq")!= null)?row.getAttribute("service_seq"):"" %>";
	service_id.value = "<%=(row!=null && row.getAttribute("service_id")!= null)?row.getAttribute("service_id"):"" %>";
	description.value = "<%=(row!=null && row.getAttribute("description")!= null)?row.getAttribute("description"):"" %>";

<% if(row!=null && row.getAttribute("service_seq")!= null) { %>
	window.returnValue = true; //window dialog return value;
	service_id.readOnly = true;

	<% if(request.getParameter("id_check")!=null) { %>
	alert("Service 정보가 정상적으로 저장되었습니다."); //alert("Service Info Saved!!!");
	<% } %>
<% } else { %>
	document.getElementById("check_id").style.display = "block";
<% } %>

</script>
