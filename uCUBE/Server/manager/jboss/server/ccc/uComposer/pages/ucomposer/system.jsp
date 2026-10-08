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
<title>System Management</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="css/pub.css" type="text/css">
<base target="_self">
</head>

<script type="text/javascript" src="tree/js/ajax.js"></script>

<script language = "javascript">
<!--
	
	var ajaxObjects = new Array();
	
	function checkIDExist() {
		var system_id = document.getElementById("system_id");
		if(!system_id.value) {
			alert("Sytem ID를 입력해 주세요."); //alert("No System ID!!!");
			system_id.focus();
			return false;
		}
		else {
			var ajaxIndex = ajaxObjects.length;
			ajaxObjects[ajaxIndex] = new sack();
			var url = "uComposerCheckIDAction.do?ServiceName=uComposerCheckID-service&select.x=1&system_id="+system_id.value;
			ajaxObjects[ajaxIndex].requestFile = url;	// Specifying which file to get
			ajaxObjects[ajaxIndex].onCompletion = function() { selectIdComplete(ajaxIndex); } ;	// Specify function that will be executed after file has been found
			ajaxObjects[ajaxIndex].runAJAX();		// Execute AJAX function
		}
	}
	
	function selectIdComplete(index) {
		var ajaxResponse = (ajaxObjects[index].response).replace(/\s/g, "");
		
		document.getElementById("id_check").value = ajaxResponse;
		
		if(ajaxResponse=="OK") {
			alert("사용가능한 System ID입니다."); //alert("Available ID!!!");
		}
		else {
			alert("이미 사용중이거나 사용 불가능한 System ID입니다."); //alert("Not Available ID!!!");
		}
	}
	
	function checkValue() {
		if(system_seq.value=="") {
			var id_check = document.getElementById("id_check");
			if(id_check.value!="OK") {
				alert("Check ID 버튼을 눌러주세요."); //alert("Check ID!!!");
				return false;
			}
		}
	
		if(system_id.value=="") { alert("No system_id value!!!"); return false; }
		//else if(description.value=="") { alert("No description value!!!"); return false; }
		else if(ip_address.value=="") { alert("No ip_address value!!!"); return false; }
		else if(host_name.value=="") { alert("No host_name value!!!"); return false; }
		else if(hw.value=="") { alert("No hw value!!!"); return false; }
		else if(os.value=="") { alert("No os value!!!"); return false; }
		else if(os_version.value=="") { alert("No os_version value!!!"); return false; }
		else if(language_support.value=="") { alert("No language_support value!!!"); return false; }
		else if(online_backup.value=="") { alert("No online_backup value!!!"); return false; }
		else if(eai_base_directory.value=="") { alert("No eai_base_directory value!!!"); return false; }
	
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

<body bgcolor="#FFFFFF" text="#000000" style="margin: 0 0 0 0">
<form name="form1" method="post" action="uComposerSystemAction.do" onSubmit="javascript:return checkValue();">
	<input type="HIDDEN" name="ServiceName" value="uComposerSystem-service"/>
	<input type="HIDDEN" name="insert.x" value="1"/>
	<input type="HIDDEN" id="system_seq" name="system_seq" value=""/>
	<input type="HIDDEN" id="id_check" name="id_check" value=""/>
	
  <posui:showMessage/>
  <table width="100%" border=0 cellpadding=0 cellspacing=0>
	<tr> 
      <td height="23"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="e5e5e5" height="23">
          <tr>
            <td></td>
          </tr>
        </table>
      </td>
    </tr>
    <Tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
          <tr> 
            <td height=25><b>System Management</b></td>
          </tr>
          <tr> 
            <td background="img/m000006img.gif"><img src="img/m000006img.gif" width="12" height=7></td>
          </tr>
          
          <tr> 
            <td>
              <table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
              	<tr><td class="tbllg" height=25 width="280"><img src="img/m000008img.gif"><b>&nbsp;system_id : </b></td><td class="tbllg" height=25 width=""><input type="text" id="system_id" name="system_id" style="width:300" class=adf value="" onChange="javascript:document.getElementById('id_check').value = '';"> <font color=red>*</font> <input type="button" value="Check ID" onClick="checkIDExist();" id="check_id" style="display:none"> </td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;description : </b></td><td class="tbllg" height=25 width=""><input type="text" id="description" name="description" style="width:300" class=adf value=""> </td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;ip_address : </b></td><td class="tbllg" height=25 width=""><input type="text" id="ip_address" name="ip_address" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;host_name : </b></td><td class="tbllg" height=25 width=""><input type="text" id="host_name" name="host_name" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;os : </b></td><td class="tbllg" height=25 width=""><input type="text" id="os" name="os" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;os_version : </b></td><td class="tbllg" height=25 width=""><input type="text" id="os_version" name="os_version" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;language_support : </b></td><td class="tbllg" height=25 width=""><input type="text" id="language_support" name="language_support" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;eai_base_directory : </b></td><td class="tbllg" height=25 width=""><input type="text" id="eai_base_directory" name="eai_base_directory" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
												
				<tr><td class="tbllg" height=25 width=""></td><td class="tbllg" height=25 width=""><input type="button" id="btn_open_close" value=" + " onClick="javascript:openCloseTable(this, 'optionTable');"> </td></tr>			
			</table>
			
			<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF" id="optionTable" style="display:none">
				<tr><td class="tbllg" height=25 width="280"><img src="img/m000008img.gif"><b>&nbsp;hw : </b></td><td class="tbllg" height=25 width=""><input type="text" id="hw" name="hw" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;online_backup : </b></td><td class="tbllg" height=25 width=""><select id="online_backup" name="online_backup" style="width:300"><option value="TRUE">TRUE</option><option value="FALSE">FALSE</option></select> <font color=red>*</font></td></tr>
			</table>
			
			<table width="98%" align="center" border="0" cellspacing="10" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
                <tr>
                	<td class="tbllg" height=25 width="" align="absmiddle">
			
                  		<!--posui:showUtilityButtons names="insert" 
                        	onClick="null|null|null|null|null|null"
                        	imgs="img/m000007ico.gif|img/m000004ico.gif|img/m000005ico.gif" /-->

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
				tableName="SystemRegisterResult"
				infoName="uComposerSystemAllResult"
				columnNames="null|null|null"
				columnWidths="200|200|200"
				height="23"
				headerValues="SYSTEM_SEQ|SYSTEM_ID|DESCRIPTION"
				headerClasses="tbldb"
				trClasses="tblcg|tblcw|tblcg"
				tdClasses="tbllb|null|null"
				displayTypes="null|null|null"
				attributes="system_seq|system_id|description"
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

	var system_seq = document.getElementById("system_seq");
	var system_id = document.getElementById("system_id");
	var description = document.getElementById("description");
	var ip_address = document.getElementById("ip_address");
	var host_name = document.getElementById("host_name");
	var hw = document.getElementById("hw");
	var os = document.getElementById("os");
	var os_version = document.getElementById("os_version");
	var language_support = document.getElementById("language_support");
	var online_backup = document.getElementById("online_backup");	
	var eai_base_directory = document.getElementById("eai_base_directory");
	
<%
	if(ctx.getRowSet("SystemResult") != null) {
		PosRowSet rowSet = ctx.getRowSet( "SystemResult");
		rowSet.reset();
	
		if(rowSet.count()>0){
			row = rowSet.next();
		}
	}
%>

	system_seq.value = "<%=(row!=null && row.getAttribute("system_seq")!=null)?row.getAttribute("system_seq"):"" %>";
	system_id.value = "<%=(row!=null && row.getAttribute("system_id")!=null)?row.getAttribute("system_id"):"" %>"; 
	description.value = "<%=(row!=null && row.getAttribute("description")!=null)?row.getAttribute("description"):"" %>"; 
	ip_address.value = "<%=(row!=null && row.getAttribute("ip_address")!=null)?row.getAttribute("ip_address"):"" %>"; 
	host_name.value = "<%=(row!=null && row.getAttribute("host_name")!=null)?row.getAttribute("host_name"):"" %>"; 
	hw.value = "<%=(row!=null && row.getAttribute("hw")!=null)?row.getAttribute("hw"):"notebook" %>"; 
	os.value = "<%=(row!=null && row.getAttribute("os")!=null)?row.getAttribute("os"):"" %>"; 
	os_version.value = "<%=(row!=null && row.getAttribute("os_version")!=null)?row.getAttribute("os_version"):"" %>"; 
	language_support.value = "<%=(row!=null && row.getAttribute("language_support")!=null)?row.getAttribute("language_support"):"" %>"; 
	online_backup.value = "<%=(row!=null && row.getAttribute("online_backup")!=null)?row.getAttribute("online_backup"):"TRUE" %>"; 
	eai_base_directory.value = "<%=(row!=null && row.getAttribute("eai_base_directory")!=null)?row.getAttribute("eai_base_directory").toString().replace("\\", "\\\\"):"" %>"; 
	
<% if(row!=null && row.getAttribute("system_seq")!=null) { %>
	window.returnValue = true; //window dialog return value;
	system_id.readOnly = true;

	<% if(request.getParameter("id_check")!=null) { %>
	alert("System 정보가 정상적으로 저장 되었습니다."); //alert("System Info Saved!!!");
	<% } %>
<% } else { %>
	document.getElementById("check_id").style.display = "block";
<% } %>

</script>
