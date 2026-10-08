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
<title>Service Group Management</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="css/pub.css" type="text/css">
<base target="_self">
</head>

<script type="text/javascript" src="tree/js/ajax.js"></script>

<script language = "javascript">
<!--
	
	var ajaxObjects = new Array();
	
	function checkIDExist() {
		var service_group_id = document.getElementById("service_group_id");
		
		if(!service_group_id.value) {
			alert("Service Group ID를 입력해 주세요."); //alert("No Service Group ID!!!");
			service_group_id.focus();
			return false;
		} 
		else {
			var ajaxIndex = ajaxObjects.length;
			ajaxObjects[ajaxIndex] = new sack();
			var url = "uComposerCheckIDAction.do?ServiceName=uComposerCheckID-service&select.x=1&system_seq="+system_seq.value+"&service_group_id="+service_group_id.value;
			ajaxObjects[ajaxIndex].requestFile = url;	// Specifying which file to get
			ajaxObjects[ajaxIndex].onCompletion = function() { selectIdComplete(ajaxIndex); } ;	// Specify function that will be executed after file has been found
			ajaxObjects[ajaxIndex].runAJAX();		// Execute AJAX function
		}
	}
	
	function selectIdComplete(index) {
		var ajaxResponse = (ajaxObjects[index].response).replace(/\s/g, "");
		
		document.getElementById("id_check").value = ajaxResponse;
		
		if(ajaxResponse=="OK") {
			alert("사용가능한 Service Group ID입니다."); //alert("Available ID!!!");
		}
		else {
			alert("이미 사용중이거나 사용 불가능한 Service Group ID입니다."); //alert("Not Available ID!!!");
		}
	}
	
	function checkValue() {
		if(service_group_seq.value=="") { 	
			var service_group_type_seq = document.getElementById("service_group_type_seq");
			if(!service_group_type_seq.value) {
				alert("No Service Group Type!!!");
				service_group_type_seq.focus();
				return false;
			}
			
			var id_check = document.getElementById("id_check");
			if(id_check.value!="OK") {
				alert("Check ID 버튼을 눌러주세요."); //alert("Check ID!!!");
				return false;
			}
		}
	
		//if(description.value=="") { alert("No description value!!!"); description.focus(); return false; }
		if(src_pc.value=="") { alert("No src_pc value!!!"); src_pc.focus(); return false; }
		else if(reconnect_interval.value=="") { alert("No reconnect_interval value!!!"); reconnect_interval.focus(); return false; }
		else if(event_queue.value=="") { alert("No event_queue value!!!"); event_queue.focus(); return false; }
		else if(data_queue.value=="") { alert("No data_queue value!!!"); data_queue.focus(); return false; }
		else if(encoding_value.value=="") { alert("No encoding_value value!!!"); encoding_value.focus(); return false; }
		//else if(enable_monitor.value=="") { alert("No enable_monitor value!!!"); enable_monitor.focus(); return false; }
		//else if(back_ground_conn.value=="") { alert("No back_ground_conn value!!!"); back_ground_conn.focus(); return false; }
		//else if(on_signal.value=="") { alert("No on_signal value!!!"); on_signal.focus(); return false; }
		else if(log_config_file.value=="") { alert("No log_config_file value!!!"); log_config_file.focus(); return false; }
		else if(log_maxfilesize.value=="") { alert("No log_maxfilesize value!!!"); log_maxfilesize.focus(); return false; }
		else if(log_level.value=="") { alert("No log_level value!!!"); log_level.focus(); return false; }
		else if(log_maxbackupindex.value=="") { alert("No log_maxbackupindex value!!!"); log_maxbackupindex.focus(); return false; }
		//else if(enable_livecheck.value=="") { alert("No enable_livecheck value!!!"); enable_livecheck.focus(); return false; }
		else if(livecheck_server_port.value=="") { alert("No livecheck_server_port value!!!"); livecheck_server_port.focus(); return false; }
		//else if(check_memory_usage.value=="") { alert("No check_memory_usage value!!!"); check_memory_usage.focus(); return false; }
		else if(event_type.value=="") { alert("No event_type value!!!"); event_type.focus(); return false; }
		else if(seq_config_file.value=="") { alert("No seq_config_file value!!!"); seq_config_file.focus(); return false; }
		else if(channel_server_start.value=="") { alert("No channel_server_start value!!!"); channel_server_start.focus(); return false; }
		else if(channel_server_port.value=="") { alert("No channel_server_port value!!!"); channel_server_port.focus(); return false; }
		else if(type.value=="") { alert("No type value!!!"); type.focus(); return false; }
		else if(destination_name.value=="") { alert("No destination_name value!!!"); destination_name.focus(); return false; }
		else if(jmsprovider_url.value=="") { alert("No jmsprovider_url value!!!"); jmsprovider_url.focus(); return false; }
		else if(initial_context_factory.value=="") { alert("No initial_context_factory value!!!"); initial_context_factory.focus(); return false; }
		else if(topic_connection_factory.value=="") { alert("No topic_connection_factory value!!!"); topic_connection_factory.focus(); return false; }
		else if(topic_name.value=="") { alert("No topic_name value!!!"); topic_name.focus(); return false; }
		else if(topic_prefix.value=="") { alert("No topic_prefix value!!!"); topic_prefix.focus(); return false; }
		else if(username.value=="") { alert("No username value!!!"); username.focus(); return false; }
		else if(password.value=="") { alert("No password value!!!"); password.focus(); return false; }
		else if(send_status_interval.value=="") { alert("No send_status_interval value!!!"); send_status_interval.focus(); return false; }
		else if(reconnect_try_count.value=="") { alert("No reconnect_try_count value!!!"); reconnect_try_count.focus(); return false; }
		//else if(enable_localqueue.value=="") { alert("No enable_localqueue value!!!"); enable_localqueue.focus(); return false; }
	
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
<form name="form1" method="post" action="uComposerServiceGroupAction.do" onSubmit="javascript:return checkValue();">
	<input type="HIDDEN" name="ServiceName" value="uComposerServiceGroup-service"/>
	<input type="HIDDEN" name="insert.x" value="1"/>
	<input type="HIDDEN" id="system_seq" name="system_seq" value=""/>
	<input type="HIDDEN" id="service_group_seq" name="service_group_seq" value=""/>
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
            <td height=25><b>Service Group Management</b></td>
          </tr>
          <tr> 
            <td background="img/m000006img.gif"><img src="img/m000006img.gif" width="12" height=7></td>
          </tr>
          
          <tr> 
            <td> 
              <table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
              	
              	<tr><td class="tbllg" height=25 width="280"><img src="img/m000008img.gif"><b>&nbsp;service_group_id :</b></td><td class="tbllg" height=25 width=""><input type="text" id="service_group_id" name="service_group_id" style="width:300" class=adf value="" onChange="javascript:document.getElementById('id_check').value = '';"> <font color=red>*</font> <input type="button" value="Check ID" onClick="checkIDExist();" id="check_id" style="display:none"> </td></tr>
              	<tr>
              		<td class="tbllg" height=25 width="">
              			<img src="img/m000008img.gif"><b>&nbsp;service_group_type :</b>
              		</td>
              		<td class="tbllg" height=25 width="">
    
    					<select id="service_group_type_seq" name="service_group_type_seq" style="width:300">
							<option value="">-- Select --</option>
							<%
							if(ctx.getRowSet( "ServiceGroupTypeResult") != null) {
								PosRowSet rowSet = ctx.getRowSet( "ServiceGroupTypeResult");
								rowSet.reset();
								while(rowSet.hasNext()) {
									row = rowSet.next();
							%> 
								<option value="<%=row.getAttribute("service_group_type_seq") %>"><%=row.getAttribute("service_group_type_id") %></option>
							<%
								}
							}
							%>
						</select>
						 <font color=red>*</font>
    
              		</td>
              	</tr>
                <tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;description :</b></td><td class="tbllg" height=25 width=""><input type="text" id="description" name="description" style="width:300" class=adf value=""></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;src_pc :</b></td><td class="tbllg" height=25 width=""><input type="text" id="src_pc" name="src_pc" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>

				<tr><td class="tbllg" height=25 width=""></td><td class="tbllg" height=25 width=""><input type="button" id="btn_open_close" value=" + " onClick="javascript:openCloseTable(this, 'optionTable');"> </td></tr>
			</table>
			
			<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF" id="optionTable" style="display:none">
				<tr><td class="tbllg" height=25 width="280"><img src="img/m000008img.gif"><b>&nbsp;reconnect_interval :</b></td><td class="tbllg" height=25 width=""><input type="text" id="reconnect_interval" name="reconnect_interval" style="width:300" class=adf value="" onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;event_queue :</b></td><td class="tbllg" height=25 width=""><input type="text" id="event_queue" name="event_queue" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;data_queue :</b></td><td class="tbllg" height=25 width=""><input type="text" id="data_queue" name="data_queue" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;encoding_value :</b></td><td class="tbllg" height=25 width=""><input type="text" id="encoding_value" name="encoding_value" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;enable_monitor :</b></td><td class="tbllg" height=25 width=""><select id="enable_monitor" name="enable_monitor" style="width:300"><option value="TRUE">TRUE</option><option value="FALSE">FALSE</option></select> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;back_ground_conn :</b></td><td class="tbllg" height=25 width=""><select id="back_ground_conn" name="back_ground_conn" style="width:300"><option value="TRUE">TRUE</option><option value="FALSE">FALSE</option></select> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;on_signal :</b></td><td class="tbllg" height=25 width=""><select id="on_signal" name="on_signal" style="width:300"><option value="TRUE">TRUE</option><option value="FALSE">FALSE</option></select> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;log_config_file :</b></td><td class="tbllg" height=25 width=""><input type="text" id="log_config_file" name="log_config_file" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;log_maxfilesize :</b></td><td class="tbllg" height=25 width=""><input type="text" id="log_maxfilesize" name="log_maxfilesize" style="width:300" class=adf value="" onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;log_level :</b></td><td class="tbllg" height=25 width=""><input type="text" id="log_level" name="log_level" style="width:300" class=adf value="" onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;log_maxbackupindex :</b></td><td class="tbllg" height=25 width=""><input type="text" id="log_maxbackupindex" name="log_maxbackupindex" style="width:300" class=adf value="" onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;enable_livecheck :</b></td><td class="tbllg" height=25 width=""><select id="enable_livecheck" name="enable_livecheck" style="width:300"><option value="TRUE">TRUE</option><option value="FALSE">FALSE</option></select> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;livecheck_server_port :</b></td><td class="tbllg" height=25 width=""><input type="text" id="livecheck_server_port" name="livecheck_server_port" style="width:300" class=adf value="" onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;check_memory_usage :</b></td><td class="tbllg" height=25 width=""><select id="check_memory_usage" name="check_memory_usage" style="width:300"><option value="TRUE">TRUE</option><option value="FALSE">FALSE</option></select> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;event_type :</b></td><td class="tbllg" height=25 width=""><input type="text" id="event_type" name="event_type" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;seq_config_file :</b></td><td class="tbllg" height=25 width=""><input type="text" id="seq_config_file" name="seq_config_file" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;channel_server_start :</b></td><td class="tbllg" height=25 width=""><input type="text" id="channel_server_start" name="channel_server_start" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;channel_server_port :</b></td><td class="tbllg" height=25 width=""><input type="text" id="channel_server_port" name="channel_server_port" style="width:300" class=adf value="" onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;type :</b></td><td class="tbllg" height=25 width=""><input type="text" id="type" name="type" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;destination_name :</b></td><td class="tbllg" height=25 width=""><input type="text" id="destination_name" name="destination_name" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;jmsprovider_url :</b></td><td class="tbllg" height=25 width=""><input type="text" id="jmsprovider_url" name="jmsprovider_url" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;initial_context_factory :</b></td><td class="tbllg" height=25 width=""><input type="text" id="initial_context_factory" name="initial_context_factory" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;topic_connection_factory :</b></td><td class="tbllg" height=25 width=""><input type="text" id="topic_connection_factory" name="topic_connection_factory" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;topic_name :</b></td><td class="tbllg" height=25 width=""><input type="text" id="topic_name" name="topic_name" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;topic_prefix :</b></td><td class="tbllg" height=25 width=""><input type="text" id="topic_prefix" name="topic_prefix" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;username :</b></td><td class="tbllg" height=25 width=""><input type="text" id="username" name="username" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;Password :</b></td><td class="tbllg" height=25 width=""><input type="text" id="password" name="password" style="width:300" class=adf value=""> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;send_status_interval :</b></td><td class="tbllg" height=25 width=""><input type="text" id="send_status_interval" name="send_status_interval" style="width:300" class=adf value="" onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;reconnect_try_count :</b></td><td class="tbllg" height=25 width=""><input type="text" id="reconnect_try_count" name="reconnect_try_count" style="width:300" class=adf value="" onkeypress='InputFieldSetNum(this)' onblur='InputFieldSetNum(this)'> <font color=red>*</font></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="img/m000008img.gif"><b>&nbsp;enable_localqueue :</b></td><td class="tbllg" height=25 width=""><select id="enable_localqueue" name="enable_localqueue" style="width:300"><option value="TRUE">TRUE</option><option value="FALSE">FALSE</option></select> <font color=red>*</font></td></tr>

			</table>
			
			<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
                <tr>
					<td class="tbllg" height=25 width="" align="center">
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
				tableName="ServiceGroupTable"
				infoName="uComposerServiceGroupAllResult"
				columnNames="null|null|null"
				columnWidths="200|200|200"
				height="23"
				headerValues="SERVICE_GROUP_SEQ|SERVICE_GROUP_ID|DESCRIPTION"
				headerClasses="tbldb"
				trClasses="tblcg|tblcw|tblcg"
				tdClasses="tbllb|null|null"
				displayTypes="null|null|null"
				attributes="service_group_seq|service_group_id|description"
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
	var service_group_seq = document.getElementById("service_group_seq");
	var service_group_id = document.getElementById("service_group_id");
	var service_group_type_seq = document.getElementById("service_group_type_seq");
	var description = document.getElementById("description");                   
	var src_pc = document.getElementById("src_pc");
	var reconnect_interval = document.getElementById("reconnect_interval");
	var event_queue = document.getElementById("event_queue");
	var data_queue = document.getElementById("data_queue");
	var encoding_value = document.getElementById("encoding_value");
	var enable_monitor = document.getElementById("enable_monitor");
	var back_ground_conn = document.getElementById("back_ground_conn");
	var on_signal = document.getElementById("on_signal");
	var log_config_file = document.getElementById("log_config_file");
	var log_maxfilesize = document.getElementById("log_maxfilesize");
	var log_level = document.getElementById("log_level");
	var log_maxbackupindex = document.getElementById("log_maxbackupindex");
	var enable_livecheck = document.getElementById("enable_livecheck");
	var livecheck_server_port = document.getElementById("livecheck_server_port");
	var check_memory_usage = document.getElementById("check_memory_usage");
	var event_type = document.getElementById("event_type");
	var seq_config_file = document.getElementById("seq_config_file");
	var channel_server_start = document.getElementById("channel_server_start");
	var channel_server_port = document.getElementById("channel_server_port");
	var type = document.getElementById("type");
	var destination_name = document.getElementById("destination_name");
	var jmsprovider_url = document.getElementById("jmsprovider_url");
	var initial_context_factory = document.getElementById("initial_context_factory");
	var topic_connection_factory = document.getElementById("topic_connection_factory");
	var topic_name = document.getElementById("topic_name");
	var topic_prefix = document.getElementById("topic_prefix");
	var username = document.getElementById("username");
	var password = document.getElementById("password");
	var send_status_interval = document.getElementById("send_status_interval");
	var reconnect_try_count = document.getElementById("reconnect_try_count");
	var enable_localqueue = document.getElementById("enable_localqueue");

<%

	if(ctx.getRowSet( "ServiceGroupResult") != null) {
		PosRowSet rowSet = ctx.getRowSet( "ServiceGroupResult");
		rowSet.reset();
	
		if(rowSet.count()>0){
			row = rowSet.next();
		}
	}

//out.println(service_group_seq);
%>

	system_seq.value = "<%=(row!=null && row.getAttribute("system_seq")!= null)?row.getAttribute("system_seq"):request.getParameter("system_seq") %>";
	service_group_seq.value = "<%=(row!=null && row.getAttribute("service_group_seq")!= null)?row.getAttribute("service_group_seq"):"" %>";
	service_group_id.value = "<%=(row!=null && row.getAttribute("service_group_id")!= null)?row.getAttribute("service_group_id"):"" %>";
	service_group_type_seq.value = "<%=(row!=null && row.getAttribute("service_group_type_seq")!= null)?row.getAttribute("service_group_type_seq"):"" %>";
	descriptionvalue = "<%=(row!=null && row.getAttribute("description")!= null)?row.getAttribute("description"):"" %>";
	src_pc.value = "<%=(row!=null && row.getAttribute("src_pc")!= null)?row.getAttribute("src_pc"):"" %>";
	reconnect_interval.value = "<%=(row!=null && row.getAttribute("reconnect_interval")!= null)?row.getAttribute("reconnect_interval"):"5000" %>";
	event_queue.value = "<%=(row!=null && row.getAttribute("event_queue")!= null)?row.getAttribute("event_queue"):"EVENT.QUEUE" %>";
	data_queue.value = "<%=(row!=null && row.getAttribute("data_queue")!= null)?row.getAttribute("data_queue"):"DATA.QUEUE" %>";
	encoding_value.value = "<%=(row!=null && row.getAttribute("encoding_value")!= null)?row.getAttribute("encoding_value"):"EUC_KR" %>";
	enable_monitor.value = "<%=(row!=null && row.getAttribute("enable_monitor")!= null)?row.getAttribute("enable_monitor"):"TRUE" %>";
	back_ground_conn.value = "<%=(row!=null && row.getAttribute("back_ground_conn")!= null)?row.getAttribute("back_ground_conn"):"FALSE" %>";
	on_signal.value = "<%=(row!=null && row.getAttribute("on_signal")!= null)?row.getAttribute("on_signal"):"FALSE" %>";
	log_config_file.value = "<%=(row!=null && row.getAttribute("log_config_file")!= null)?row.getAttribute("log_config_file"):"/home/udev/uCUBE/log/ucube_log.txt" %>";
	log_maxfilesize.value = "<%=(row!=null && row.getAttribute("log_maxfilesize")!= null)?row.getAttribute("log_maxfilesize"):"10000" %>";
	log_level.value = "<%=(row!=null && row.getAttribute("log_level")!= null)?row.getAttribute("log_level"):"5" %>";
	log_maxbackupindex.value = "<%=(row!=null && row.getAttribute("log_maxbackupindex")!= null)?row.getAttribute("log_maxbackupindex"):"10" %>";
	enable_livecheck.value = "<%=(row!=null && row.getAttribute("enable_livecheck")!= null)?row.getAttribute("enable_livecheck"):"FALSE" %>";
	livecheck_server_port.value = "<%=(row!=null && row.getAttribute("livecheck_server_port")!= null)?row.getAttribute("livecheck_server_port"):"9088" %>";
	check_memory_usage.value = "<%=(row!=null && row.getAttribute("check_memory_usage")!= null)?row.getAttribute("check_memory_usage"):"FALSE" %>";
	event_type.value = "<%=(row!=null && row.getAttribute("event_type")!= null)?row.getAttribute("event_type"):"1" %>";
	seq_config_file.value = "<%=(row!=null && row.getAttribute("seq_config_file")!= null)?row.getAttribute("seq_config_file"):"1" %>";
	channel_server_start.value = "<%=(row!=null && row.getAttribute("channel_server_start")!= null)?row.getAttribute("channel_server_start"):"1" %>";
	channel_server_port.value = "<%=(row!=null && row.getAttribute("channel_server_port")!= null)?row.getAttribute("channel_server_port"):"1099" %>";
	type.value = "<%=(row!=null && row.getAttribute("type")!= null)?row.getAttribute("type"):"DESTINATION" %>";
	destination_name.value = "<%=(row!=null && row.getAttribute("destination_name")!= null)?row.getAttribute("destination_name"):"MON" %>";
	jmsprovider_url.value = "<%=(row!=null && row.getAttribute("jmsprovider_url")!= null)?row.getAttribute("jmsprovider_url"):"172.31.73.36:2099" %>";
	initial_context_factory.value = "<%=(row!=null && row.getAttribute("initial_context_factory")!= null)?row.getAttribute("initial_context_factory"):"org.jnp.interfaces.NamingContextFactory" %>";
	topic_connection_factory.value = "<%=(row!=null && row.getAttribute("topic_connection_factory")!= null)?row.getAttribute("topic_connection_factory"):"UIL2ConnectionFactory" %>";
	topic_name.value = "<%=(row!=null && row.getAttribute("topic_name")!= null)?row.getAttribute("topic_name"):"ADAPTER.MONITOR" %>";
	topic_prefix.value = "<%=(row!=null && row.getAttribute("topic_prefix")!= null)?row.getAttribute("topic_prefix"):"topic/" %>";
	username.value = "<%=(row!=null && row.getAttribute("username")!= null)?row.getAttribute("username"):"guest" %>";
	password.value = "<%=(row!=null && row.getAttribute("password")!= null)?row.getAttribute("password"):"guest" %>";
	send_status_interval.value = "<%=(row!=null && row.getAttribute("send_status_interval")!= null)?row.getAttribute("send_status_interval"):"300" %>";
	reconnect_try_count.value = "<%=(row!=null && row.getAttribute("reconnect_try_count")!= null)?row.getAttribute("reconnect_try_count"):"10" %>";
	enable_localqueue.value = "<%=(row!=null && row.getAttribute("enable_localqueue")!= null)?row.getAttribute("enable_localqueue"):"FALSE" %>";
	
<% if(row!=null && row.getAttribute("service_group_seq")!=null) { %>
	window.returnValue = true;	
	service_group_id.readOnly = true;
	service_group_type_seq.disabled = true;
	<% if(request.getParameter("id_check")!=null) { %>
	alert("Service Group 정보가 정상적으로 저장되었습니다."); //alert("Service Group Info Saved!!!");
	<% } %>
<% } else { %>
	document.getElementById("check_id").style.display = "block";	
<% } %>

</script>
