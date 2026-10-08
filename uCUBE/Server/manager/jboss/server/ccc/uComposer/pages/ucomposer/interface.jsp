<%
	PosContext ctx = (PosContext)request.getAttribute( "PosContext" );
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
<title>Interface Management</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="css/pub.css" type="text/css">
<base target="_self">
</head>

<script type="text/javascript" src="tree/js/ajax.js"></script>

<script language = "javascript">
<!--
	
	var ajaxObjects = new Array();
	
	function checkIDExist() {
		var interface_id = document.getElementById("interface_id");
		if(!interface_id.value) {
			alert("Interface ID를 입력해 주세요."); //alert("No Interface ID!!!");
			interface_id.focus();
			return false;
		} 
		else {
			var ajaxIndex = ajaxObjects.length;
			ajaxObjects[ajaxIndex] = new sack();
			var url = "uComposerCheckIDAction.do?ServiceName=uComposerCheckID-service&select.x=1&interface_id="+interface_id.value;
			ajaxObjects[ajaxIndex].requestFile = url;	// Specifying which file to get
			ajaxObjects[ajaxIndex].onCompletion = function() { selectIdComplete(ajaxIndex); } ;	// Specify function that will be executed after file has been found
			ajaxObjects[ajaxIndex].runAJAX();		// Execute AJAX function
		}
	}
	
	function selectIdComplete(index) {
		var ajaxResponse = (ajaxObjects[index].response).replace(/\s/g, "");
		
		document.getElementById("id_check").value = ajaxResponse;
		
		if(ajaxResponse=="OK") {
			alert("사용가능한 Interface ID입니다."); //alert("Available ID!!!");
		}
		else {
			alert("이미 사용중이거나 사용 불가능한 Interface ID입니다."); //alert("Not Available ID!!!");
		}
	}
	
	function checkValue() {
		if(interface_seq.value=="") {	
			var id_check = document.getElementById("id_check");
			if(id_check.value!="OK") {
				alert("Check ID 버튼을 눌러주세요."); //alert("Check ID!!!");
				return false;
			}
		}
	
		//if(description.value =="") { alert("No description value!!!");description.focus(); return false; }
		if(interface_source_type.value =="") { alert("No interface_source_type value!!!");interface_source_type.focus(); return false; }
		else if(interface_target_type.value =="") { alert("No interface_target_type value!!!");interface_target_type.focus(); return false; }
		else if(persistent.value =="") { alert("No persistent value!!!");persistent.focus(); return false; }
		else if(sequential_data.value =="") { alert("No sequential_data value!!!");sequential_data.focus(); return false; }
		else if(destination_directory.value =="") { alert("No destination_directory value!!!");destination_directory.focus(); return false; }
		else if(destination_file_name.value =="") { alert("No destination_file_name value!!!");destination_file_name.focus(); return false; }
		else if(use_source_file_name.value =="") { alert("No use_source_file_name value!!!");use_source_file_name.focus(); return false; }
		else if(delimiter.value =="") { alert("No delimiter value!!!");delimiter.focus(); return false; }
		else if(file_type.value =="") { alert("No file_type value!!!");file_type.focus(); return false; }
		else if(file_action.value =="") { alert("No file_action value!!!");file_action.focus(); return false; }
		else if(file_chunk_size.value =="") { alert("No file_chunk_size value!!!");file_chunk_size.focus(); return false; }
		else if(post_processing_action.value =="") { alert("No post_processing_action value!!!");post_processing_action.focus(); return false; }
		else if(post_processing_directory.value =="") { alert("No post_processing_directory value!!!");post_processing_directory.focus(); return false; }
		else if(post_processing_file_name.value =="") { alert("No post_processing_file_name value!!!");post_processing_file_name.focus(); return false; }
		else if(post_processing_overwrite.value =="") { alert("No post_processing_overwrite value!!!");post_processing_overwrite.focus(); return false; }
		else if(post_processing_file_count.value =="") { alert("No post_processing_file_countvalue!!!");post_processing_file_count.focus(); return false; }
		else if(system_command.value =="") { alert("No system_command value!!!");system_command.focus(); return false; }
		
	
		return true;
	}

	function openCloseTable(obj, tableName){
		var divObj = document.getElementById(tableName);
	 	
		if(divObj.style.display=="none") {
			divObj.style.display = "block";
			obj.value = " - ";
		}
		else {	
			divObj.style.display = "none";
			obj.value = " + ";
		}	
	}
// -->
</script>

<body bgcolor="#FFFFFF" text="#000000" topmargin=0 leftmargin=0>
<form name="form1" method="post" action="uComposerInterfaceAction.do" onSubmit="javascript:return checkValue();">
	<input type="HIDDEN" name="ServiceName" value="uComposerInterface-service"/>
	<input type="HIDDEN" name="insert.x" value="1"/>

	<input type="HIDDEN" id="interface_seq" name="interface_seq" value=""/>
	<input type="HIDDEN" id="id_check" name="id_check" value=""/>
  
  <posui:showMessage/>
  <table width=100% border=0 cellpadding=0 cellspacing=0>
	<tr> 
      <td height="23"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="e5e5e5" height="23">
          <tr>
            <td></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
          <tr> 
            <td height=25><b>Interface Management</b></td>
          </tr>
          <tr> 
            <td background="img/m000006img.gif"><img src="img/m000006img.gif" width="12" height=7></td>
          </tr>
          
          <tr> 
            <td> 
              <table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
              	
              	<tr><td class="tbllg" height=25 width="280"><img src="img/m000008img.gif"><b>&nbsp;interface_id :</b></td><td class="tbllg" height=25 width=""><input type="text" id="interface_id" name="interface_id" style="width:300" class=adf value="" onChange="javascript:document.getElementById('id_check').value = '';"> <font color=red>*</font> <input type="button" value="Check ID" onClick="checkIDExist();" id="check_id" style="display:none"> </td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;description :</b></td><td class="tbllg" height=25 width=""><input type="text" id="description" name="description" style="width:300" class=adf value=""></td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;interface_source_type :</b></td><td class="tbllg" height=25 width=""><input type="text" id="interface_source_type" name="interface_source_type" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;interface_target_type :</b></td><td class="tbllg" height=25 width=""><input type="text" id="interface_target_type" name="interface_target_type" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""></td><td class="tbllg" height=25 width=""><input type="button" id="btn_open_close" value=" + " onClick="javascript:openCloseTable(this, 'optionTable');"> </td></tr>			
			</table>

              <table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF" id="optionTable" style="display:none">

                <tr><td class="tbllg" height=25 width="280"><img src="img/m000008img.gif"><b>&nbsp;persistent :</b></td><td class="tbllg" height=25 width=""><select id="persistent" name="persistent" style="width:300"><option value="TRUE">TRUE</option><option value="FALSE">FALSE</option></select> <font color=red>*</font></td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;sequential_data :</b></td><td class="tbllg" height=25 width=""><select id="sequential_data" name="sequential_data" style="width:300"><option value="TRUE">TRUE</option><option value="FALSE">FALSE</option></select> <font color=red>*</font></td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;destination_directory :</b></td><td class="tbllg" height=25 width=""><input type="text" id="destination_directory" name="destination_directory" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;destination_file_name :</b></td><td class="tbllg" height=25 width=""><input type="text" id="destination_file_name" name="destination_file_name" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;use_source_file_name :</b></td><td class="tbllg" height=25 width=""><select id="use_source_file_name" name="use_source_file_name" style="width:300"><option value="TRUE">TRUE</option><option value="FALSE">FALSE</option></select> <font color=red>*</font></td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;delimiter :</b></td><td class="tbllg" height=25 width=""><input type="text" id="delimiter" name="delimiter" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;file_type :</b></td><td class="tbllg" height=25 width=""><input type="text" id="file_type" name="file_type" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;file_action :</b></td><td class="tbllg" height=25 width=""><input type="text" id="file_action" name="file_action" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;file_chunk_size :</b></td><td class="tbllg" height=25 width=""><input type="text" id="file_chunk_size" name="file_chunk_size" style="width:300" class=adf value="" onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'> <font color=red>*</font></td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;post_processing_action :</b></td><td class="tbllg" height=25 width=""><input type="text" id="post_processing_action" name="post_processing_action" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;post_processing_directory :</b></td><td class="tbllg" height=25 width=""><input type="text" id="post_processing_directory" name="post_processing_directory" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;post_processing_file_name :</b></td><td class="tbllg" height=25 width=""><input type="text" id="post_processing_file_name" name="post_processing_file_name" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;post_processing_overwrite :</b></td><td class="tbllg" height=25 width=""><select id="post_processing_overwrite" name="post_processing_overwrite" style="width:300"><option value="TRUE">TRUE</option><option value="FALSE">FALSE</option></select> <font color=red>*</font></td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;post_processing_file_count :</b></td><td class="tbllg" height=25 width=""><input type="text" id="post_processing_file_count" name="post_processing_file_count" style="width:300" class=adf value="" onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'> <font color=red>*</font></td></tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;system_command :</b></td><td class="tbllg" height=25 width=""><input type="text" id="system_command" name="system_command" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
			</table>
            
            <table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
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
<div id="unused_interface" style="display:none">
			<br>
			<font color='red' size=3>Unused Interface</font>
			<br>
			<table id='test' width='600' border='1' cellspacing='0' cellpadding='0' bordercolorlight='#666666' bordercolordark='#FFFFFF'> 
				<tr class="tbldb"  height="23" align="absmiddle">  
					<td width="90">Interface Seq</td> 
					<td width="180">Interface ID</td> 
					<td width="">Description</td> 
					<td width="90">Select</td> 
				</tr> 
				<%
				if(ctx.getRowSet( "uComposerInterfaceAllResult") != null) {
					PosRowSet rowSet = ctx.getRowSet( "uComposerInterfaceAllResult");
					rowSet.reset();
					while(rowSet.hasNext()) {
						row = rowSet.next();
						if(row.getAttribute("intervace_used_cnt").toString().equals("0")) {
				%> 
				<tr align='center' class=tblcw>
					<td class=tbllb><%=row.getAttribute("interface_seq") %></td>  
					<td><%=row.getAttribute("interface_id") %></td>
					<td><%=row.getAttribute("description") %></td>  
					<td><a href="uComposerInterfaceAction.do?ServiceName=uComposerInterface-service&select.x=1&interface_seq=<%=row.getAttribute("interface_seq") %>"><img src="img/m000002butstx.gif" border="0"></a></td>  
				</tr>
				<%
						}
					}
				}
				%>
			</table>

			<br>
</div>
			<posui:showTable
				tableName="InterfaceTable"
				infoName="uComposerInterfaceAllResult"
				columnNames="null|null|null"
				columnWidths="200|200|200"
				height="23"
				headerValues="INTERFACE_SEQ|INTERFACE_ID|DESCRIPTION"
				headerClasses="tbldb"
				trClasses="tblcg|tblcw|tblcg"
				tdClasses="tbllb|null|null"
				displayTypes="null|null|null"
				attributes="interface_seq|interface_id|description"
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

<script type="text/javascript">

	var interface_seq = document.getElementById("interface_seq");
	var interface_id = document.getElementById("interface_id");
	var description = document.getElementById("description");
	var interface_source_type = document.getElementById("interface_source_type");
	var interface_target_type = document.getElementById("interface_target_type");
	var persistent = document.getElementById("persistent");
	var sequential_data = document.getElementById("sequential_data");
	var destination_directory = document.getElementById("destination_directory");
	var destination_file_name = document.getElementById("destination_file_name");
	var use_source_file_name = document.getElementById("use_source_file_name");
	var delimiter = document.getElementById("delimiter");
	var file_type = document.getElementById("file_type");
	var file_action = document.getElementById("file_action");
	var file_chunk_size = document.getElementById("file_chunk_size");
	var post_processing_action = document.getElementById("post_processing_action");
	var post_processing_directory = document.getElementById("post_processing_directory");
	var post_processing_file_name = document.getElementById("post_processing_file_name");
	var post_processing_overwrite = document.getElementById("post_processing_overwrite");
	var post_processing_file_count = document.getElementById("post_processing_file_count");
	var system_command = document.getElementById("system_command");

<%
	row = null;

	if(ctx.getRowSet( "InterfaceResult") != null) {
		PosRowSet rowSet = ctx.getRowSet( "InterfaceResult");
		rowSet.reset();
	
		if(rowSet.hasNext()){
			row = rowSet.next();
		}
	}
%>
	
	interface_seq.value = "<%=(row!=null && row.getAttribute("interface_seq")!= null)?row.getAttribute("interface_seq"):"" %>";
	interface_id.value = "<%=(row!=null && row.getAttribute("interface_id")!= null)?row.getAttribute("interface_id"):"" %>";
	description.value = "<%=(row!=null && row.getAttribute("description")!= null)?row.getAttribute("description"):"" %>";
	interface_source_type.value = "<%=(row!=null && row.getAttribute("interface_source_type")!= null)?row.getAttribute("interface_source_type"):"" %>";
	interface_target_type.value = "<%=(row!=null && row.getAttribute("interface_target_type")!= null)?row.getAttribute("interface_target_type"):"" %>";
	persistent.value = "<%=(row!=null && row.getAttribute("persistent")!= null)?row.getAttribute("persistent"):"TRUE" %>";
	sequential_data.value = "<%=(row!=null && row.getAttribute("sequential_data")!= null)?row.getAttribute("sequential_data"):"FALSE" %>";
	destination_directory.value = "<%=(row!=null && row.getAttribute("destination_directory")!= null)?row.getAttribute("destination_directory").toString().replace("\\", "\\\\"):"/UIPPEA01/EAI2/data" %>";
	destination_file_name.value = "<%=(row!=null && row.getAttribute("destination_file_name")!= null)?row.getAttribute("destination_file_name"):"PBZATR04.dat" %>";
	use_source_file_name.value = "<%=(row!=null && row.getAttribute("use_source_file_name")!= null)?row.getAttribute("use_source_file_name"):"TRUE" %>";
	delimiter.value = "<%=(row!=null && row.getAttribute("delimiter")!= null)?row.getAttribute("delimiter"):"#^#^#" %>";
	file_type.value = "<%=(row!=null && row.getAttribute("file_type")!= null)?row.getAttribute("file_type"):"BINARY" %>";
	file_action.value = "<%=(row!=null && row.getAttribute("file_action")!= null)?row.getAttribute("file_action"):"NEWFILE" %>";
	file_chunk_size.value = "<%=(row!=null && row.getAttribute("file_chunk_size")!= null)?row.getAttribute("file_chunk_size"):"500000" %>";
	post_processing_action.value = "<%=(row!=null && row.getAttribute("post_processing_action")!= null)?row.getAttribute("post_processing_action"):"NO_ACTION" %>";
	post_processing_directory.value = "<%=(row!=null && row.getAttribute("post_processing_directory")!= null)?row.getAttribute("post_processing_directory").toString().replace("\\", "\\\\"):"C:\\Posco\\devel\\tifadaptor\\post" %>";
	post_processing_file_name.value = "<%=(row!=null && row.getAttribute("post_processing_file_name")!= null)?row.getAttribute("post_processing_file_name"):"post" %>";
	post_processing_overwrite.value = "<%=(row!=null && row.getAttribute("post_processing_overwrite")!= null)?row.getAttribute("post_processing_overwrite"):"TRUE" %>";
	post_processing_file_count.value = "<%=(row!=null && row.getAttribute("post_processing_file_count")!= null)?row.getAttribute("post_processing_file_count"):"10" %>";
	system_command.value = "<%=(row!=null && row.getAttribute("system_command")!= null)?row.getAttribute("system_command"):"ls" %>";
	
<% if(row!=null && row.getAttribute("interface_seq")!= null) { %>
	window.returnValue = "<%=row.getAttribute("interface_seq") %>|<%=row.getAttribute("interface_id") %>";
	interface_id.readOnly = true;

	<% if(request.getParameter("id_check")!=null) { %>
	alert("Interface 정보가 정상적으로 저장되었습니다."); //alert("Interface Info Saved!!!");
	<% } %>
<% } else { %>
	document.getElementById("check_id").style.display = "block";
	document.getElementById("unused_interface").style.display = "block";
<% } %>	

</script>
