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
String interface_length = "";
String service_seq = null;
String function_unit_seq = null;

PosContext ctx = (PosContext)request.getAttribute( "PosContext" );
PosRow row = null;
PosRowSet rowSet = null;

if(ctx.getRowSet( "dbAdapterLayoutResult") != null){
	rowSet = ctx.getRowSet( "dbAdapterLayoutResult");
	
	if(rowSet.hasNext()) {
		row = rowSet.next();
		interface_length = row.getAttribute("interface_length").toString();
	}

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
	    
	    var subTableID = Math.random();
		
		var rowLen = tableObj.rows.length;
		
		var row = tableObj.insertRow(rowLen); 
		var cell = row.insertCell(0); 
		
		var tmpCell = "<table id='" + subTableID + "' width='100%' border='1' cellspacing='0' cellpadding='0'  bordercolorlight='#666666' bordercolordark='#FFFFFF'>"; 
		tmpCell += "<tr id='trObj' align='center' class=tblcw>";  
		tmpCell += "	<td width='30' class=tbllb><input type='checkbox' name='chkRow'></td>";  
		tmpCell += "	<td width='70'><input name='linkage_sql_seq' value='"+(rowLen+1)+"' size='1' readOnly></td>";  
		tmpCell += "	<td width='200'><input name='tb_name' value='' size='20'></td>";  
		tmpCell += "	<td width=''><input name='description' value='' size='40'></td>";
		tmpCell += "	<td width='140'><img src='img/m000008butstx.gif' style='cursor:hand' onClick=javascript:make_sub_row('" + subTableID + "'); valign='center' />&nbsp;<img src='img/m000007butstx.gif' style='cursor:hand' onClick=javascript:delete_sub_row(this); valign='center' /></td>";  
		tmpCell += "</tr>";
		tmpCell += "</table>"; 
	
		tmpCell += "<table id='" + subTableID + "_sub' width='100%' border='1' cellspacing='0' cellpadding='0' bordercolorlight='#666666' bordercolordark='#FFFFFF' style='display:block'>"; 
		tmpCell += "	<tr align='center' class=tblcw>";  
		tmpCell += "		<td width='102'>&nbsp;</td>";  
		tmpCell += "		<td width='30'>&nbsp;</td>";
		tmpCell += "		<td width='60'>SEQ</td>";  
		tmpCell += "		<td width=''>COLUMN NAME</td>";  
		tmpCell += "		<td width='70'>COLUMN TYPE</td>";  
		tmpCell += "		<td width='70'>USED</td>";  
		tmpCell += "		<td width='70'>PRECISION</td>";  
		tmpCell += "		<td width='70'>DATA START</td>";  
		tmpCell += "		<td width='70'>DATA LENGTH</td>";
		tmpCell += "	</tr>";
		tmpCell += "</table>";
	
		tmpCell += "<table width='100%' border='0'><tr height=3><td></td></tr></table>";
		
		cell.innerHTML = tmpCell;
		
		return subTableID;
	} 
	
	
	function make_sub_row(tableID) {
	    var tableObj = document.getElementById(tableID+"_sub");
		var parentSeq = tableObj.parentNode.parentNode.rowIndex + 1;
		var rowLen = tableObj.rows.length;
		var row = tableObj.insertRow(rowLen); 
	
		row.align = "center";
		
		row.insertCell(0).innerHTML = "&nbsp;<input type='hidden' name='parent_seq' value='"+parentSeq+"' size=3>"; 
		//row.insertCell(1).class = "tbllb";
		row.insertCell(1).innerHTML = "<input type='checkbox' name='subChkRow'>"; 
		row.insertCell(2).innerHTML = "<input type='text' name='column_seq' value='"+(rowLen)+"' size='1' readOnly>"; 
		row.insertCell(3).innerHTML = "<input type='text' name='col_name' value='' size='20'>";
		row.insertCell(4).innerHTML = "<select name='type'><option value='CHAR'>CHAR</option><option value='VARCHAR2'>VARCHAR2</option><option value='NUMBER'>NUMBER</option><option value='BLOB'>BLOB</option><option value='CLOB'>CLOB</option><option value='DATE'>DATE</option><option value='TIMESTAMP'>TIMESTAMP</option></select>";
		row.insertCell(5).innerHTML = "<select name='used'><option value='ALL'>ALL</option><option value='SQL' selected>SQL</option><option value='NOT'>NOT</option></select>";
		row.insertCell(6).innerHTML = "<input type='text' name='precision' value='' size='2' onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'>";
		row.insertCell(7).innerHTML = "<input type='text' name='start_index' value='' size='2' onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'>";
		row.insertCell(8).innerHTML = "<input type='text' name='data_length' value='' size='2' onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'>";
		
	}
	
	
	function onSelect_post_sql(tableID, flag) {
		
		var targetTable = document.getElementById(tableID);
	
		if(flag=="TRUE") {
			targetTable.style.display = 'block';
		}
		else {
			targetTable.style.display = 'none';		
		}
	}
	
	
	function delete_row() { 
		
		var chkRow = document.getElementsByName("chkRow");
		var chkRowLen = chkRow.length;
	
		if(chkRowLen==0) return false;
	
	    //if(!confirm("Delete Selected item(s)?")) return false;
	
		for(var i=chkRowLen-1;i>=0;i--) {
			if(chkRow[i].checked) {
				tableObj.deleteRow(i); 
			}
		}
		
		if(chkRowLen==chkRow.length) {
			alert("삭제할 Row를 선택해 주세요."); //alert("Select Line First!!!");
		}
		else {
			var linkage_sql_seq = document.getElementsByName("linkage_sql_seq");
			var parent_seq = document.getElementsByName("parent_seq");
			
			for(var i=0;i<linkage_sql_seq.length;i++) {
				//alert(linkage_sql_seq[i].value+" : "+i+1)
				if(linkage_sql_seq[i].value!=(i+1)) {
					for(var j=0;j<parent_seq.length;j++) {
						if(parent_seq[j].value==linkage_sql_seq[i].value) {
							parent_seq[j].value = i+1;
						}
					}
					linkage_sql_seq[i].value = i+1;
				}
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
	
	
	function delete_sub_row(imgObj) { 
		var chkRow = document.getElementsByName("subChkRow");
		var chkRowLen = chkRow.length;
	
		if(chkRowLen==0) return false;
	
		//if(!confirm("Delete Selected item(s)?")) return false;
		
		var parentTable = imgObj.parentNode.parentNode.parentNode.parentNode;
		var parentRowIndex = parentTable.parentNode.parentNode.rowIndex;
		var tableObj = document.getElementById(parentTable.id+"_sub");
	
		for(var i=chkRowLen-1;i>=0;i--) {
			if(chkRow[i].checked==true && parentRowIndex==chkRow[i].parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.rowIndex) {
				tableObj.deleteRow(chkRow[i].parentNode.parentNode.rowIndex);
			}
		}
		
		if(chkRowLen==chkRow.length) {
			alert("삭제할 Row를 선택해 주세요."); //alert("Select Line First!!!");
		}
		else {
			parent_seq = document.getElementsByName("parent_seq");
			column_seq = document.getElementsByName("column_seq");
			
			for(var i=0,j=1;i<column_seq.length;i++) {
				if(parent_seq[i].value==parentRowIndex+1) {
					column_seq[i].value = j;
					j++;
				}
			}
		}
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
		var interface_length = document.getElementById("interface_length");
		if(interface_length.value=="") { alert("No interface length Value!!!"); interface_length.focus(); return false; }
		
		var tb_name = document.getElementsByName("tb_name");
		for(var i=0;i<tb_name.length;i++) {
			if(tb_name[i].value=="") { alert("No table name Value!!!"); tb_name[i].focus(); return false; }
		}
		
		var col_name = document.getElementsByName("col_name");
		var start_index = document.getElementsByName("start_index");
		var data_length = document.getElementsByName("data_length");
		for(var i=0;i<col_name.length;i++) {
			if(col_name[i].value=="") { alert("No column name Value!!!"); col_name[i].focus(); return false; }
			if(start_index[i].value=="") { alert("No data start Value!!!"); start_index[i].focus(); return false; }
			if(data_length[i].value=="") { alert("No data length Value!!!"); data_length[i].focus(); return false; }
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

<form name="regForm" method="post" action="dbAdapterLayoutAction.do">

<input type="hidden" name="ServiceName" value="uComposerDbAdapterLayout-service">
<input type="hidden" name="insert.x" value="1">

<table width="800" border=0 cellpadding=0 cellspacing=0>
	<tr>
		<td height="45" bgcolor="0E3F61">
			<table width="800" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="16">&nbsp;</td>
					<td><font size="6" color="#FFFFFF">uComposer - DB ADAPTER - LAYOUT Configuration</font></td>
				</tr>
			</table>
		</td>
	</tr>

	<tr><td height="10"></td></tr>

	<tr>
		<td>
			<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr><td height=25><font size="4"><b>DB Adapter LAYOUT Configuration</b></font></td></tr>

				<tr><td background="img/m000006img.gif"><img src="img/m000006img.gif" width="12" height=7></td></tr>

				<tr>
					<td>
						<table width="780" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
							<tr>
								<td class="tbllg" height=25 width="150">
									<img src="img/m000008img.gif" width="7"><b>Interface ID : </b>
									<input type="hidden" name="interface_seq" value="<%=interface_seq %>"/>
									<input type="hidden" name="service_seq" value="<%=service_seq %>"/>
									<input type="hidden" name="function_unit_seq" value="<%=function_unit_seq %>"/>
								</td>
								<td class="tbllg" height=25 width="%" align="absmiddle">
									<input type="text" readonly="readonly" name="interface_id" style="width:200" class=adb1 onBlur="this.className='adb1';" onFocus=this.className='adf1' value="<%=interface_id %>" TABINDEX="1" >
								</td>
								
								<td rowspan=2 class="tbllg" height=25 width="280" align="absmiddle">
									<div align="right">
										<input type="image"  name="register"  src="img/m000006ico.gif"  onClick="return checkValue();"  valign="center" alt="저장">
										<img src="img/m000005ico.gif" style="cursor:hand" onClick="javascript:self.close();"  valign="center" alt="종료">
									</div>
								</td>
							</tr>
							<tr>	
								<td class="tbllg" height=25>
									<img src="img/m000008img.gif" width="7"><b>Interface Length : </b>
								</td>
								<td class="tbllg" height=25 width="%" align="absmiddle">
									<input type="text" id="interface_length" name="interface_length" style="width:200" class=adb1 onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)' value="<%=interface_length %>">
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
								<td width="200">TABLE NAME</td> 
								<td width="">DESCRIPTION</td> 
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
var subRowCnt = -1;
var tmpTableId;
<%
String before_linkage_sql_seq = null;
//out.println(rowSet.count());
while(rowSet.hasNext()) {
	row = rowSet.next();
%>	
	<% if(!row.getAttribute("linkage_sql_seq").toString().equals(before_linkage_sql_seq)) { %>

		rowCnt++;
		tmpTableId = make_row('tableObj1');

		document.getElementsByName("linkage_sql_seq")[rowCnt].value = "<%=row.getAttribute("linkage_sql_seq").toString() %>";
		document.getElementsByName("tb_name")[rowCnt].value = "<%=row.getAttribute("tb_name").toString() %>";
		document.getElementsByName("description")[rowCnt].value = "<%=row.getAttribute("description").toString() %>";		

		<% if(row.getAttribute("column_seq")!=null) { %>
		
		subRowCnt++;
		make_sub_row(tmpTableId);
		
		document.getElementsByName("parent_seq")[subRowCnt].value = "<%=row.getAttribute("linkage_sql_seq").toString() %>";
		document.getElementsByName("column_seq")[subRowCnt].value = "<%=row.getAttribute("column_seq").toString() %>";
		document.getElementsByName("col_name")[subRowCnt].value = "<%=row.getAttribute("col_name").toString() %>";
		document.getElementsByName("type")[subRowCnt].value = "<%=row.getAttribute("type").toString() %>";
		document.getElementsByName("used")[subRowCnt].value = "<%=row.getAttribute("used").toString() %>";
		<% if(row.getAttribute("precision")!=null) { %>
		document.getElementsByName("precision")[subRowCnt].value = "<%=row.getAttribute("precision").toString() %>";
		<% } %>
		document.getElementsByName("start_index")[subRowCnt].value = "<%=row.getAttribute("start_index").toString() %>";
		document.getElementsByName("data_length")[subRowCnt].value = "<%=row.getAttribute("data_length").toString() %>";
		
		<% } %>

	<% } else { %>

		subRowCnt++;
		make_sub_row(tmpTableId);
		
		document.getElementsByName("parent_seq")[subRowCnt].value = "<%=row.getAttribute("linkage_sql_seq").toString() %>";
		document.getElementsByName("column_seq")[subRowCnt].value = "<%=row.getAttribute("column_seq").toString() %>";
		document.getElementsByName("col_name")[subRowCnt].value = "<%=row.getAttribute("col_name").toString() %>";
		document.getElementsByName("type")[subRowCnt].value = "<%=row.getAttribute("type").toString() %>";
		document.getElementsByName("used")[subRowCnt].value = "<%=row.getAttribute("used").toString() %>";
		<% if(row.getAttribute("precision")!=null) { %>
		document.getElementsByName("precision")[subRowCnt].value = "<%=row.getAttribute("precision").toString() %>";
		<% } %>
		document.getElementsByName("start_index")[subRowCnt].value = "<%=row.getAttribute("start_index").toString() %>";
		document.getElementsByName("data_length")[subRowCnt].value = "<%=row.getAttribute("data_length").toString() %>";
	

	<% } %>	
<%	
	before_linkage_sql_seq = row.getAttribute("linkage_sql_seq").toString();
}
%>

</script>

</html> 
