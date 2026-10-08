<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>

<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<!-- 
<script language="JavaScript" src="js/showErrorPopup.js"></script>
<script language="JavaScript" src="js/showInsertableRow.js"></script>
<script language="JavaScript" src="js/checkValidations.js"></script>
<script language="javascript" src="js/messcript.js"></script>
-->

<script language="JavaScript" src="js/common.js"></script>

<%
String interface_seq = null;
String interface_id = null;
String service_seq = null;
String function_unit_seq = null;

PosContext ctx = (PosContext)request.getAttribute( "PosContext" );
PosRow row = null;
PosRowSet rowSet = null;

if(ctx.getRowSet( "dbAdapterSqlResult") != null){
	rowSet = ctx.getRowSet( "dbAdapterSqlResult");
//	out.println(rowSet.count());
	rowSet.reset();

}

if(ctx.get("function_unit_seq") != null){
	function_unit_seq = ctx.get("function_unit_seq").toString();
}

if(interface_seq == null) interface_seq = request.getParameter("interface_seq");
if(interface_id == null) interface_id = request.getParameter("interface_id");
if(service_seq == null) service_seq = request.getParameter("service_seq");
if(function_unit_seq == null) function_unit_seq = request.getParameter("function_unit_seq");

%>


<html> 
<head> 
<link rel="stylesheet" href="css/pub.css" type="text/css">
<title>uComposer DB Adapter</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8" /> 



<script type="text/javascript"> 

<% if(rowSet.count() > 0) { %>
window.returnValue = true;
<% } %>

	function make_table() { 
	    table = document.createElement("table"); 
	    document.body.appendChild(table); 
	} 
	
	
	function make_row(tableID) { 
	    tableObj = document.getElementById(tableID);
	    
	    var tableId = Math.random();
		
		var rowLen = tableObj.rows.length;
		
		var row = tableObj.insertRow(rowLen); 
		var cell = row.insertCell(0); 
		
		var tmpCell = "<table width='100%' border='1' cellspacing='0' cellpadding='0'  bordercolorlight='#666666' bordercolordark='#FFFFFF'>"; 
		tmpCell += "<tr id='trObj' align='center' class=tblcw>";  
		tmpCell += "	<td width='30' class=tbllb><input type='checkbox' name='chkRow'></td>";  
		tmpCell += "	<td width='70'><input name='sql_seq' value='"+(rowLen+1)+"' size='1' readOnly></td>";  
		tmpCell += "	<td width='90'><select name='type'><option value='SELECT'>SELECT</option><option value='INSERT'>INSERT</option><option value='UPDATE'>UPDATE</option><option value='DELETE'>DELETE</option><option value='DSQL'>DSQL</option></select></td>";  
		tmpCell += "	<td width='90'><select name='post_sql' onChange='javascript:onSelect_post_sql(\""+tableId+"\", this.value)'><option value='TRUE'>TRUE</option><option value='FALSE' selected>FALSE</option></select></td>";  
		tmpCell += "	<td width='70'><input type='text' name='param_start' size=3 onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'></td>";  
		tmpCell += "	<td width='70'><input type='text' name='param_length' size=3 onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'></td>";  
		tmpCell += "	<td><textarea name='sql' cols='36' rows ='3' WRAP='SOFT'></textarea></td>";  
		//tmpCell += "	<td>"; 
		//tmpCell += "		<input type='button' value='up' onClick='javascript:move_row(\"up\", this)'> <br>"; 
		//tmpCell += "		<input type='button' value='down' onClick='javascript:move_row(\"down\", this)'> <br>"; 
		//tmpCell += "		<input type='button' value='X' onClick='javascript:delete_row(this)'>"; 
		//tmpCell += "	</td>";  
		tmpCell += "</tr>";
		tmpCell += "</table>"; 
	
		tmpCell += "<table id='"+tableId+"' width='100%' border='1' cellspacing='0' cellpadding='0' bordercolorlight='#666666' bordercolordark='#FFFFFF' style='display:none'>"; 
		tmpCell += "<tr align='center' class=tblcw>";  
		tmpCell += "	<td width='102' rowspan=3>Child SQL</td>";  
		tmpCell += "	<td width='90'>Post Result</td>";  
		tmpCell += "	<td width='90'>Type</td>";  
		tmpCell += "	<td width='70'>Param Start</td>";  
		tmpCell += "	<td width='70'>Param Length</td>";  
		tmpCell += "	<td width=''>SQL</td>";  
		tmpCell += "</tr>";
		tmpCell += "<tr align='center' class=tblcw>";  
		tmpCell += "	<td>TRUE<input type='hidden' name='p_sql_result_t' value='true'></td>";  
		tmpCell += "	<td><select name='type_t'><option value='SELECT'>SELECT</option><option value='INSERT'>INSERT</option><option value='UPDATE'>UPDATE</option><option value='DELETE'>DELETE</option><option value='DSQL'>DSQL</option></select></td>";  
		tmpCell += "	<td><input type='text' name='param_start_t' size=3 onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'></td>";  
		tmpCell += "	<td><input type='text' name='param_length_t' size=3 onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'></td>";  
		tmpCell += "	<td><textarea name='sql_t' cols='36' rows ='3' WRAP='SOFT'></textarea></td>";  
		tmpCell += "</tr>";
		tmpCell += "<tr align='center' >";  
		tmpCell += "	<td>FALSE<input type='hidden' name='p_sql_result_f' value='false'></td>";  
		tmpCell += "	<td><select name='type_f'><option value='SELECT'>SELECT</option><option value='INSERT'>INSERT</option><option value='UPDATE'>UPDATE</option><option value='DELETE'>DELETE</option><option value='DSQL'>DSQL</option></select></td>";  
		tmpCell += "	<td><input type='text' name='param_start_f' size=3 onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'></td>";  
		tmpCell += "	<td><input type='text' name='param_length_f' size=3 onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'></td>";  
		tmpCell += "	<td><textarea name='sql_f' cols='36' rows ='3' WRAP='SOFT'></textarea></td>";  
		tmpCell += "</tr>";
		tmpCell += "</table>";	
	
		tmpCell += "<table width='100%' border='0'><tr height=3><td></td></tr></table>";
		
		cell.innerHTML = tmpCell;
		
		return tableId;
	} 
	
	
	function onSelect_post_sql(tableName, flag) {
		
		var targetTable = document.getElementById(tableName);
	
		if(flag=="TRUE") {
			targetTable.style.display = 'block';
		}
		else {
			targetTable.style.display = 'none';		
		}
	}
	
	
	function delete_row() { 
		
		chkRow = document.getElementsByName("chkRow");
		chkRowLen = chkRow.length;
	
		if(chkRowLen==0) return false;
	
	    //if(!confirm("Delete Selected item(s)?")) return false;
	//alert(chkRow.length);
		for(var i=chkRowLen-1;i>=0;i--) {
			//alert(i+" : "+chkRowLen+" : "+chkRow[i].checked);
			if(chkRow[i].checked) {
				tableObj.deleteRow(i); 
			}
		}
		
		if(chkRowLen==chkRow.length) {
			alert("삭제할 Row를 선택해 주세요."); //alert("Select Line First!!!");
		}
		else {
			sql_seq = document.getElementsByName("sql_seq");
	//alert(sql_seq.length);		
			for(var i=0;i<sql_seq.length;i++) {
				sql_seq[i].value = i+1;
			}
		}
		
		/*
		if(confirm("Delete SEQ["+(rowIndex+1)+"]?"))
			tableObj.deleteRow(rowIndex); 
		
		rowIndex = obj.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.rowIndex;
		alert(rowIndex);
		if(confirm("Delete SEQ["+(rowIndex+1)+"]?"))
			tableObj.deleteRow(rowIndex); 
		*/
	} 
	
	function move_row(flag, obj) { 
	    //alert(rowIndex);
		rowIndex = obj.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.rowIndex;
		
		if(flag=="up") {
			
			if(rowIndex==0) return false; 
			swapNodes(tableObj.rows[rowIndex], tableObj.rows[rowIndex-1]);
		}  
		else {
			if(rowIndex==tableObj.rows.length-1) return false;
			swapNodes(tableObj.rows[rowIndex], tableObj.rows[rowIndex+1]);
		}
		//tableObj.rows(rowIndex).swapNode(tableObj.rows(0)); 
		
		//tableObj.rows[rowIndex].rowIndex = rowIndex - 1; 
		
	} 
	
	function swapNodes(item1, item2) {
		var tmpItem = item1.cloneNode(true);
		var parent = item1.parentNode;
	
		item2 = parent.replaceChild(tmpItem,item2);
		parent.replaceChild(item2,item1);
		parent.replaceChild(item1,tmpItem);
	
		tmpItem = null;
	}
	
	function checkValue() {
		
		var param_start = document.getElementsByName("param_start");
		var param_length = document.getElementsByName("param_length");
		var sql = document.getElementsByName("sql");
		var post_sql = document.getElementsByName("post_sql");
		
		var param_start_t = document.getElementsByName("param_start_t");
		var param_length_t = document.getElementsByName("param_length_t");
		var sql_t = document.getElementsByName("sql_t");
		
		var param_start_f = document.getElementsByName("param_start_f");
		var param_length_f = document.getElementsByName("param_length_f");
		var sql_f = document.getElementsByName("sql_f");
	
		for(var i=0;i<param_start.length;i++) {
			if(param_start[i].value=="") { alert("No param start Value!!!"); param_start[i].focus(); return false; }
			if(param_length[i].value=="") { alert("No param length Value!!!"); param_length[i].focus(); return false; }
			if(sql[i].value=="") { alert("No sql Value!!!"); sql[i].focus(); return false; }
	
			if(post_sql[i].value=="TRUE") {
				if(param_start_t[i].value=="") { alert("No true param start Value!!!"); param_start_t[i].focus(); return false; }
				if(param_length_t[i].value=="") { alert("No true param length Value!!!"); param_length_t[i].focus(); return false; }
				if(sql_t[i].value=="") { alert("No true sql Value!!!"); sql_t[i].focus(); return false; }
		
				if(param_start_f[i].value=="") { alert("No false param start Value!!!"); param_start_f[i].focus(); return false; }
				if(param_length_f[i].value=="") { alert("No false param length Value!!!"); param_length_f[i].focus(); return false; }
				if(sql_f[i].value=="") { alert("No false sql Value!!!"); sql_f[i].focus(); return false; }
			}
		}
		
		return true;
	}
	
	function chkAllRow(flag) {
		var chkRow = document.getElementsByName("chkRow");
	
		for(var i=0;i<chkRow.length;i++) {
			chkRow[i].checked = flag;
		}
	}

</script> 
<base target="_self">
</head> 

<body style="margin:0 0 0 0;"> 

<form name="regForm" method="post" action="dbAdapterSqlAction.do">

<input type="hidden" name="ServiceName" value="uComposerDbAdapterSql-service">
<input type="hidden" name="insert.x" value="1">

<table width="800" border=0 cellpadding=0 cellspacing=0>
	<tr>
		<td height="45" bgcolor="0E3F61">
			<table width="800" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="16">&nbsp;</td>
					<td><font size="6" color="#FFFFFF">uComposer - DB ADAPTER - SQL Configuration</font></td>
				</tr>
			</table>
		</td>
	</tr>

	<tr><td height="10"></td></tr>

	<tr>
		<td>
			<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr><td height=25><font size="4"><b>DB Adapter SQL Configuration</b></font></td></tr>

				<tr><td background="img/m000006img.gif"><img src="img/m000006img.gif" width="12" height=7></td></tr>

				<tr>
					<td>
						<table width="780" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
							<tr>
								<td class="tbllg" height=25 width="100">
									<img src="img/m000008img.gif" width="7">
									<b>Rule Name</b>
								</td>
								<td class="tbllg" height=25 width="%"> 
									<b>:</b>
									&nbsp;
										<input type="text" readonly="readonly" name="interface_id" style="width:200" class=adb1 onBlur="this.className='adb1';" onFocus=this.className='adf1' value="<%=interface_id %>" TABINDEX="1" >
										<input type="hidden" name="interface_seq" value="<%=interface_seq %>"/>
										<input type="hidden" name="service_seq" value="<%=service_seq %>"/>
										<input type="hidden" name="function_unit_seq" value="<%=function_unit_seq %>"/>
									&nbsp;
								</td>
								<td class="tbllg" height=25 width="280" align="absmiddle">
									<div align="right">
										<input type="image"  name="register"  src="img/m000006ico.gif"  onClick="return checkValue();"  valign="center" alt="저장">
										<img src="img/m000005ico.gif" style="cursor:hand" onClick="javascript:self.close();"  valign="center" alt="종료">
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>

				<tr><td background="img/m000006img.gif"><img src="img/m000006img.gif" width="12" height=7></td></tr>
				
				<tr><td background="img/m000006img.gif"><img src="img/m000006img.gif" width="12" height=7></td></tr>
				
				<tr>
					<td>
						<table width="760" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF" align="center">
							<tr>
								<td class="tbllg" height=25 width=160>
									<img src="img/m000008img.gif" width="7">
									<b>Input Format</b>
									
									&nbsp;
								</td>
								<td class="tbllg" height=25 width="" align="absmiddle">
									<div align="right">
										<img src="img/m000008butstx.gif" style="cursor:hand" onClick="javascript:make_row('tableObj1');" valign="center" />&nbsp;<img src="img/m000007butstx.gif" style="cursor:hand" onClick="javascript:delete_row();" valign="center" />
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			
				<tr>
					<td>
						<table width="760" height=23 border=1 align="center" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF"> 
							<tr class="tbldb"  height="23" align="absmiddle">  
								<td width="30"><input type='checkbox' onClick='javascript:chkAllRow(this.checked);'></td> 
								<td width="70">SEQ</td> 
								<td width="90">TYPE</td> 
								<td width="90">POST SQL</td> 
								<td width="70">PARAM START</td> 
								<td width="70">PARAM LENGTH</td>
								<td width="">SQL</td>
							</tr> 
						</table>
						<table id="tableObj1" width="760" height=23 border=0 align="center" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF"></table> 						
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</form>

</body> 

<script type="text/javascript"> 

var rowCnt = -1;

<%
String before_sql_seq = null;
//out.println(rowSet.count());
while(rowSet.hasNext()) {
	row = rowSet.next();
%>	
	<% if(!row.getAttribute("sql_seq").toString().equals(before_sql_seq)) { %>
		rowCnt++;
		tableId = make_row('tableObj1');

		document.getElementsByName("sql_seq")[rowCnt].value = "<%=row.getAttribute("sql_seq").toString() %>";
		document.getElementsByName("type")[rowCnt].value = "<%=row.getAttribute("type").toString() %>";
		document.getElementsByName("post_sql")[rowCnt].value = "<%=row.getAttribute("post_sql").toString() %>";		
		document.getElementsByName("param_start")[rowCnt].value = "<%=row.getAttribute("param_start").toString() %>";
		document.getElementsByName("param_length")[rowCnt].value = "<%=row.getAttribute("param_length").toString() %>";
		document.getElementsByName("sql")[rowCnt].value = "<%=row.getAttribute("sql").toString() %>";
		
		<% if(row.getAttribute("post_sql").equals("TRUE")) { %>		
		onSelect_post_sql(tableId, "TRUE");
		
		document.getElementsByName("p_sql_result_t")[rowCnt].value = "<%=row.getAttribute("p_sql_result_c").toString() %>";
		document.getElementsByName("type_t")[rowCnt].value = "<%=row.getAttribute("type_c").toString() %>";
		document.getElementsByName("param_start_t")[rowCnt].value = "<%=row.getAttribute("param_start_c").toString() %>";
		document.getElementsByName("param_length_t")[rowCnt].value = "<%=row.getAttribute("param_length_c").toString() %>";
		document.getElementsByName("sql_t")[rowCnt].value = "<%=row.getAttribute("sql_c").toString() %>";
		<% } %>
	<% } else { %>

		document.getElementsByName("p_sql_result_f")[rowCnt].value = "<%=row.getAttribute("p_sql_result_c").toString() %>";
		document.getElementsByName("type_f")[rowCnt].value = "<%=row.getAttribute("type_c").toString() %>";
		document.getElementsByName("param_start_f")[rowCnt].value = "<%=row.getAttribute("param_start_c").toString() %>";
		document.getElementsByName("param_length_f")[rowCnt].value = "<%=row.getAttribute("param_length_c").toString() %>";
		document.getElementsByName("sql_f")[rowCnt].value = "<%=row.getAttribute("sql_c").toString() %>";
	<% } %>	
<%	
	before_sql_seq = row.getAttribute("sql_seq").toString();
}
%>


</script>

</html> 
