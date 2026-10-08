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

<script language="javascript" src="/js/showErrorPopup.js"></script>
<script language="JavaScript" src="/js/showCalendar.js"></script>
<script language="JavaScript" src="/js/messcript.js"></script>

<html>
<head>
<title>Service Management</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="css/pub.css" type="text/css">
<base target="_self">
</head>

<%
	PosContext ctx = (PosContext)request.getAttribute( "PosContext" );
	PosRow row = null;
	PosRowSet rowSet = null;
/*
	String connection_seq = null;
	
	if(ctx.getRowSet( "QueryResult") != null){
		rowSet = ctx.getRowSet( "QueryResult");
		rowSet.reset();
		
		if(rowSet.count()>0) {
			row = rowSet.next();
			connection_seq = row.getAttribute("connection_seq").toString();
		}
	}
*/	
	Object engine_seq = null;
	Object queue_seq = null;
	Object engine_id = null;
	Object queue_id = null;
	
	rowSet = ctx.getRowSet( "uComposerConnectionResult");
	rowSet.reset();
	
	if(rowSet.hasNext()) {
		row = rowSet.next();
		engine_seq = row.getAttribute("engine_seq");
		queue_seq = row.getAttribute("queue_seq");
		engine_id = row.getAttribute("engine_id");
		queue_id = row.getAttribute("queue_id");
	}
	
	String interface_seq = request.getParameter("interface_seq");
	String soruceService = request.getParameter("soruceService");
	String targetService = request.getParameter("targetService");
%>

<script language = "javascript">
<!--
	var arg = window.dialogArguments;
	if(typeof arg == "undefined") { alert("Abnormal  Access!!!"); self.close(); }
	var used_queue = arg.key.split("|");
	
	function makeQueueList(engineValue) {

		engine_description.value = arrEngineInfo[engine_seq.selectedIndex][0]
		type.value = arrEngineInfo[engine_seq.selectedIndex][1]
		jmsprovider_url.value = arrEngineInfo[engine_seq.selectedIndex][2]
		initial_context_factory.value = arrEngineInfo[engine_seq.selectedIndex][3]
		queue_connection_factory.value = arrEngineInfo[engine_seq.selectedIndex][4]
		topic_prefix.value = arrEngineInfo[engine_seq.selectedIndex][5]
		queue_prefix.value = arrEngineInfo[engine_seq.selectedIndex][6]
		username.value = arrEngineInfo[engine_seq.selectedIndex][7]
		password.value = arrEngineInfo[engine_seq.selectedIndex][8]
	
		queue_seq.length = 1;
		checkQueueInfo("");
		
		if(engineValue != "") {
		
			for(var i=0;i<arrQueue.length;i++) {
				var strTemp = arrQueue[i].split("|");
				if(strTemp[0]==engineValue) {
					//alert(strTemp[1]+ " "+strTemp[2]);
					queue_seq.options.add(new Option(strTemp[2], strTemp[1]));
				}	
			}
		}
	}
	
	function checkQueueInfo(selected_queue) {
		
		if(selected_queue) queue_description.value = arrQueueInfo[selected_queue];
		else queue_description.value = "";
		
		var tmp_queue_seq = "<%=queue_seq %>";
	
		if(tmp_queue_seq != "" && tmp_queue_seq != selected_queue) {
			for(var i=0;i<used_queue.length;i++) {
	
				if(used_queue[i]!="" && used_queue[i].split("_")[0]==selected_queue) {
					alert("Used Queue!!!");
					queue_seq.value = "";
				}
			}
		}
	}
	
	function makeNewEngine(checkValue) {
		if(checkValue) {
			engine_seq.value = "";
//			engine_seq.disabled = true;
			engine_seq.style.display = 'none';
			engine_id.style.display = 'block';
	
			document.getElementById('chk_new_queue').checked = true;
			document.getElementById('chk_new_queue').disabled = true;
		
			makeNewQueue(true, false);
		}
		else {
			document.getElementById('chk_new_queue').checked = false;
			document.getElementById('chk_new_queue').disabled = false;
			
			engine_id.style.display = 'none';
//			engine_seq.disabled = false;
			engine_seq.style.display = 'block';
			
			makeNewQueue(false, false);
		}
	}
	
	function makeNewQueue(checkValue, engineInfo) {
		if(engineInfo && engine_seq.value == "") {
			alert("No Engine Selected!!! \n\nSelect Engine First!!!");
			document.getElementById('chk_new_queue').checked = false;
			return false;
		}
		
		if(checkValue) {
			document.getElementById('hidden_engine_seq').value = engine_seq.value;
			if(engineInfo) engine_seq.disabled = true;
			queue_seq.value = "";
//			queue_seq.disabled = true;
			queue_seq.style.display = 'none';
			queue_id.style.display = 'block';
		}
		else {
			document.getElementById('hidden_engine_seq').value = "";
			if(engineInfo) engine_seq.disabled = false;
//			queue_seq.disabled = false;
			queue_id.style.display = 'none';
			queue_seq.style.display = 'block';
		}
	}
	
	function checkValue() {
		
		var chk_new_engine = document.getElementById('chk_new_engine').checked;
		var chk_new_queue = document.getElementById('chk_new_queue').checked;
		
		if(chk_new_engine) {
			if(!engine_id.value) {
				alert("No engine ID!!!");
				engine_id.focus();
				return false;
			} 
		}
		else {
		
		}
		
		if(chk_new_engine || chk_new_queue) {
			if(!queue_id.value) {
				alert("No queue ID!!!");
				queue_id.focus();
				return false;
			}
		}
		
		else {
			if(!engine_seq.value) {
				alert("No engine selected!!!");
				engine_seq.focus();
				return false;
			} 
			else if(!queue_seq.value) {
				alert("No queue selected!!!");
				queue_seq.focus();
				return false;
			}
		}
		
		return true;
	}
// -->
</script>

<body bgcolor="#FFFFFF" text="#000000" topmargin=0 leftmargin=0>
<form name="form1" method="post" action="/uComposer/uComposerConnectionAction.do" onSubmit="javascript:return checkValue();">
  <input type="HIDDEN" name="ServiceName" value="uComposerConnection-service"/>
  
  <input type="HIDDEN" id="hidden_engine_seq" name="hidden_engine_seq" value=""/>
  <input type="HIDDEN" id="interface_seq" name="interface_seq" value="<%=interface_seq %>"/>
  <input type="HIDDEN" id="soruceService" name="soruceService" value="<%=soruceService %>"/>
  <input type="HIDDEN" id="targetService" name="targetService" value="<%=targetService %>"/>
 
  <posui:showMessage/>
  <table width=1000 border=0 cellpadding=0 cellspacing=0>
	<tr> 
      <td height="23"> 
        <table width="1000" border="0" cellspacing="0" cellpadding="0" bgcolor="e5e5e5" height="23">
          <tr>
            <td width = 700></td>
            <td width = 300 align="right" height=25></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>
        <table width="980" border="0" cellspacing="0" cellpadding="0" align="center">
          <tr> 
            <td height=25><b>Connection Management</b></td>
          </tr>
          <tr> 
            <td background="/uComposer/img/m000006img.gif"><img src="/uComposer/img/m000006img.gif" width="12" height=7></td>
          </tr>
          
          <tr> 
            <td> 
              <table width="980" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
				<tr>
					<td class="tbllg" height=25 width="180"><img src="/uComposer/img/m000008img.gif"><b>&nbsp;Sender Function Unit ID :</b></td>
					<td class="tbllg" height=25 width="800">
						<%
						rowSet = ctx.getRowSet( "senderFunctionUnitResult");
						rowSet.reset();
						if(rowSet.hasNext()) {
							row = rowSet.next();
						%>
						<input type="hidden" name="sender_function_unit_seq" value="<%=row.getAttribute("function_unit_seq") %>">
						<%=row.getAttribute("function_unit_id") %>
						<%
						}
						%>
					</td>
				</tr>

				<tr>
					<td class="tbllg" height=25 width="180"><img src="/uComposer/img/m000008img.gif"><b>&nbsp;Receiver Function Unit ID :</b></td>
					<td class="tbllg" height=25 width="800">
						<%
						rowSet = ctx.getRowSet( "receiverFunctionUnitResult");
						rowSet.reset();
						if(rowSet.hasNext()) {
							row = rowSet.next();
						%>
						<input type="hidden" id="receiver_function_unit_seq" name="receiver_function_unit_seq" value="<%=row.getAttribute("function_unit_seq") %>">
						<%=row.getAttribute("function_unit_id") %>
						<%
						}
						%>
					</td>
				</tr>
				
				<tr>
					<td class="tbllg" height=25 width=""><img src="/uComposer/img/m000008img.gif"><b>&nbsp;Engine ID :</b></td>
					<td class="tbllg" height=25 width="">
						<label><input type="checkbox" id="chk_new_engine" name="chk_new_engine" value="1" onclick="javascript:makeNewEngine(this.checked);" > Make New Engine</label>
						<br>
						<select id="engine_seq" name="engine_seq" style="width:300" onChange="javascript:makeQueueList(this.value);">
							<option value="">-- Select Engine --</option>
						</select>
						
						<input type="text" id="engine_id" name="engine_id" style="width:300;display:none;" class=adf value="<% if(request.getParameter("engine_id") != null){ %><%=request.getParameter("engine_id")%><%}%>">
					</td>
				</tr>
				<tr><td class="tbllg" height=25 width=""><img src="/uComposer/img/m000008img.gif"><b>&nbsp;engine_description :</b></td><td class="tbllg" height=25 width=""><input type="text" id="engine_description" name="engine_description" style="width:300" class=adf value=""></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="/uComposer/img/m000008img.gif"><b>&nbsp;jmsprovider_url :</b></td><td class="tbllg" height=25 width=""><input type="text" id="jmsprovider_url" name="jmsprovider_url" style="width:300" class=adf value=""></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="/uComposer/img/m000008img.gif"><b>&nbsp;username :</b></td><td class="tbllg" height=25 width=""><input type="text" id="username" name="username" style="width:300" class=adf value=""></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="/uComposer/img/m000008img.gif"><b>&nbsp;password :</b></td><td class="tbllg" height=25 width=""><input type="text" id="password" name="password" style="width:300" class=adf value=""></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="/uComposer/img/m000008img.gif"><b>&nbsp;type :</b></td><td class="tbllg" height=25 width=""><input type="text" id="type" name="type" style="width:300" class=adf value="jbossmq"></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="/uComposer/img/m000008img.gif"><b>&nbsp;initial_context_factory :</b></td><td class="tbllg" height=25 width=""><input type="text" id="initial_context_factory" name="initial_context_factory" style="width:300" class=adf value="org.jnp.interfaces.NamingContextFactory"></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="/uComposer/img/m000008img.gif"><b>&nbsp;queue_connection_factory :</b></td><td class="tbllg" height=25 width=""><input type="text" id="queue_connection_factory" name="queue_connection_factory" style="width:300" class=adf value="UIL2ConnectionFactory"></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="/uComposer/img/m000008img.gif"><b>&nbsp;topic_prefix :</b></td><td class="tbllg" height=25 width=""><input type="text" id="topic_prefix" name="topic_prefix" style="width:300" class=adf value="topic/"></td></tr>
				<tr><td class="tbllg" height=25 width=""><img src="/uComposer/img/m000008img.gif"><b>&nbsp;queue_prefix :</b></td><td class="tbllg" height=25 width=""><input type="text" id="queue_prefix" name="queue_prefix" style="width:300" class=adf value="queue/"></td></tr>

				<tr>
					<td class="tbllg" height=25 width=""><img src="/uComposer/img/m000008img.gif"><b>&nbsp;Queue ID :</b></td>
					<td class="tbllg" height=25 width="">
						<label><input type="checkbox" id="chk_new_queue" name="chk_new_queue" value="1" onclick="javascript:makeNewQueue(this.checked, true);" > Make New Queue</label>
						<br>
						<select id="queue_seq" name="queue_seq" style="width:300" onChange="javascript:checkQueueInfo(this.value);">
							<option value="">-- Select Queue --</option>
						</select>
						<input type="text" id="queue_id" name="queue_id" style="width:300;display:none;" class=adf value="">
					</td>
				</tr>
				<tr><td class="tbllg" height=25 width=""><img src="/uComposer/img/m000008img.gif"><b>&nbsp;queue_description :</b></td><td class="tbllg" height=25 width=""><input type="text" id="queue_description" name="queue_description" style="width:300" class=adf value=""></td></tr>
				
                <tr>
 					<td class="tbllg" height=25 width=""></td>
					<td class="tbllg" height=25 width="" align="absmiddle">
                  		<posui:showUtilityButtons names="insert" 
                        	onClick="null|null|null|null|null|javascript: return call()"
                        	imgs="/uComposer/img/m000007ico.gif|/uComposer/img/m000004ico.gif|/uComposer/img/m000005ico.gif" />
                        	<img src="/uComposer/img/m000005ico.gif" onClick="javascript:self.close();" style="border:0;cursor:pointer;">
                  	</td>
                </tr>
              </table>
	    </td>
	  </tr>
	  <tr>
		<td>
			<posui:showTable
				tableName="ConnectionTable"
				infoName="uComposerConnectionAllResult"
				columnNames="null|null|null"
				columnWidths="200|200|200"
				height="23"
				headerValues="CONNECTION_SEQ|QUEUE_SEQ|ENGINE_SEQ"
				headerClasses="tbldb"
				trClasses="tblcg|tblcw|tblcg"
				tdClasses="tbllb|null|null"
				displayTypes="null|null|null"
				attributes="connection_seq|queue_seq|engine_seq"
			/>
		</td>
	  </tr>
	  <tr> 
        <td background="/uComposer/img/m000006img.gif"><img src="/uComposer/img/m000006img.gif" width="12" height=7></td>
      </tr>
		 
    </table>

	</td>
	</tr>
  </table>
</form>

</body>
</html>

<script language = "javascript">
<!--
	var engine_seq = document.getElementById("engine_seq");
	var engine_id = document.getElementById("engine_id");
	var engine_description = document.getElementById("engine_description");
	var type = document.getElementById("type");
	var jmsprovider_url = document.getElementById("jmsprovider_url");
	var initial_context_factory = document.getElementById("initial_context_factory");
	var queue_connection_factory = document.getElementById("queue_connection_factory");
	var topic_prefix = document.getElementById("topic_prefix");
	var queue_prefix = document.getElementById("queue_prefix");
	var username = document.getElementById("username");
	var password = document.getElementById("password");
	
	var queue_seq = document.getElementById("queue_seq");
	var queue_id = document.getElementById("queue_id");
	var queue_description = document.getElementById("queue_description");

	var arrQueue = new Array(); 
	
	var arrEngineInfo = new Array();
	arrEngineInfo[0] = new Array();
	arrEngineInfo[0][0] = "";
	arrEngineInfo[0][1] = "jbossmq";
	arrEngineInfo[0][2] = "172.31.73.36:2099";
	arrEngineInfo[0][3] = "org.jnp.interfaces.NamingContextFactory";
	arrEngineInfo[0][4] = "UIL2ConnectionFactory";
	arrEngineInfo[0][5] = "topic/";
	arrEngineInfo[0][6] = "queue/";
	arrEngineInfo[0][7] = "";
	arrEngineInfo[0][8] = "";
	
	var arrQueueInfo = new Array();
	
<%
	rowSet = ctx.getRowSet( "engineAllResult");
	rowSet.reset();
	int i = 1;

	while(rowSet.hasNext()) {
		row = rowSet.next();
%>
	document.getElementById('engine_seq').options.add(new Option("<%=row.getAttribute("engine_id") %>", "<%=row.getAttribute("engine_seq") %>"));
	
	arrEngineInfo[<%=i%>] = new Array();
	arrEngineInfo[<%=i%>][0] = "<%=row.getAttribute("description") %>";
	arrEngineInfo[<%=i%>][1] = "<%=row.getAttribute("type") %>";
	arrEngineInfo[<%=i%>][2] = "<%=row.getAttribute("jmsprovider_url") %>";
	arrEngineInfo[<%=i%>][3] = "<%=row.getAttribute("initial_context_factory") %>";
	arrEngineInfo[<%=i%>][4] = "<%=row.getAttribute("queue_connection_factory") %>";
	arrEngineInfo[<%=i%>][5] = "<%=row.getAttribute("topic_prefix") %>";
	arrEngineInfo[<%=i%>][6] = "<%=row.getAttribute("queue_prefix") %>";
	arrEngineInfo[<%=i%>][7] = "<%=row.getAttribute("username") %>";
	arrEngineInfo[<%=i%>][8] = "<%=row.getAttribute("password") %>";
<%
		i++;
	}
%>

<%
	rowSet = ctx.getRowSet( "queueAllResult");
	rowSet.reset();
	i = 0;
	while(rowSet.hasNext()) {
		row = rowSet.next();
%>
	arrQueue[<%=i%>] = "<%=row.getAttribute("engine_seq") %>|<%=row.getAttribute("queue_seq") %>|<%=row.getAttribute("queue_id") %>";

	arrQueueInfo[<%=row.getAttribute("queue_seq") %>] = "<%=row.getAttribute("description") %>";
	
<%
		i++;
	}
%>
	
	engine_seq.value = "<%=(engine_seq!=null ? engine_seq : "") %>";
	makeQueueList("<%=engine_seq %>");
	queue_seq.value = "<%=(queue_seq!=null ? queue_seq : "") %>";
	checkQueueInfo("<%=queue_seq %>");

<% if(queue_seq != null) { %>
	if(typeof arg != "undefined") window.returnValue = '<%=queue_seq%>_<%=engine_id%>_<%=queue_id%>';
<% } %>

// -->
</script>
