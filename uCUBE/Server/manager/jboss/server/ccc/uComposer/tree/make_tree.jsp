<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>

<%@ page import="com.posdata.glue.dao.vo.PosRowSet,
					com.posdata.glue.context.PosContext,
					com.posdata.glue.dao.vo.PosRow" %>

<%@ page contentType="text/html;charset=UTF-8"%>

<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<script language="JavaScript" src="js/showErrorPopup.js"></script>

<div id="tree_div"></div>

<script type="text/javascript" src="/uComposer/tree/js/ajax.js"></script>
<script type="text/javascript" src="/uComposer/tree/js/context-menu.js"></script><!-- IMPORTANT! INCLUDE THE context-menu.js FILE BEFORE drag-drop-folder-tree.js -->
<script type="text/javascript" src="/uComposer/tree/js/drag-drop-folder-tree.js">

/************************************************************************************************************
(C) www.dhtmlgoodies.com, July 2006

Update log:


This is a script from www.dhtmlgoodies.com. You will find this and a lot of other scripts at our website.

Terms of use:
You are free to use this script as long as the copyright message is kept intact.

For more detailed license information, see http://www.dhtmlgoodies.com/index.html?page=termsOfUse

Thank you!

www.dhtmlgoodies.com
Alf Magne Kalleland

************************************************************************************************************/
</script>

<link rel="stylesheet" href="/uComposer/tree/css/drag-drop-folder-tree.css" type="text/css"></link>
<link rel="stylesheet" href="/uComposer/tree/css/context-menu.css" type="text/css"></link>
<style type="text/css">
/* CSS for the demo */
img{
	border:0px;
}
</style>
<script type="text/javascript">
//--------------------------------
// Save functions
//--------------------------------
var ajaxObjects = new Array();
/*
// Use something like this if you want to save data by Ajax.
function saveMyTree()
{
	saveString = treeObj.getNodeOrders();
	var ajaxIndex = ajaxObjects.length;
	ajaxObjects[ajaxIndex] = new sack();
	var url = '/tree/saveNodes.jsp?saveString=' + saveString;
	ajaxObjects[ajaxIndex].requestFile = url;	// Specifying which file to get
	ajaxObjects[ajaxIndex].onCompletion = function() { saveComplete(ajaxIndex); } ;	// Specify function that will be executed after file has been found
	ajaxObjects[ajaxIndex].runAJAX();		// Execute AJAX function

}
function saveComplete(index)
{
	alert(ajaxObjects[index].response);
}

// Call this function if you want to save it by a form.
function saveMyTree_byForm()
{
	document.myForm.elements['saveString'].value = treeObj.getNodeOrders();
	document.myForm.submit();
}
*/

</script>

<!-- input type="hidden" id="elementID" value=""-->

<hr>

<% String searchCondition = request.getParameter("search_condition"); %>
<select id="search_condition" name="search_condition">
	<option value="interface_id">Interface ID</option>
	<option value="service_id">Service ID</option>
	<option value="service_group_id">Group ID</option>
	<option value="system_id">System ID</option>
</select>
<script type="text/javascript">document.getElementById("search_condition").value = "<%=searchCondition%>"; </script>

<input type="text" id="search_value" name="search_value" size="5" value="<% if(request.getParameter("search_value")!= null) { %><%=request.getParameter("search_value") %><% } %>">
<br>
<input type="button" onclick="javascript:searchMainList();" value="  Search  " width="200">
<input type="button" onclick="javascript:treeObj.deleteChildItem(document.getElementById('ucubeTree')); treeObj.__loadSubItem('root', 'ucubeTree');" value="  All List  " width="200">

<hr>

<UL id="dhtmlgoodies_tree2" class="dhtmlgoodies_tree">
	<LI id="ucubeTree"><a href="#"><b>uCube</b></a>
	</LI>
</UL>
<br><br><br>


<script type="text/javascript">

var treeObj = new JSDragDropTree();
treeObj.setTreeId('dhtmlgoodies_tree2');
treeObj.setMaximumDepth(5);
treeObj.setDragDropEnable('sameDepth'); //allDepth or sameDepth (default is no Drag and Drop)
treeObj.setMessageMaximumDepthReached('Maximum depth reached'); // If you want to show a message when maximum depth is reached, i.e. on drop.
treeObj.initTree();
//treeObj.expandAll();

function setElementID(ElementID) {
	document.getElementById("elementID").value += "|"+ElementID
}

function AddInterfaceID() {
	var nodeID = document.getElementById("elementID").value;
	var obj;

	var array_nodeID = nodeID.split("|");

	for(i=0;i<array_nodeID.length;i++) {
		obj = document.getElementById(array_nodeID[i]);
		if(obj) treeObj.__addNewItem_step2(obj);
	}
	document.getElementById("elementID").value = "";
}

function searchMainList() {
	var search_condition = document.getElementById('search_condition').value;
	var search_value = document.getElementById('search_value').value; 
	
	if(search_value==null || search_value=="") {
		alert("No Searching Value!!!");
	}
	else {
		treeObj.deleteChildItem(document.getElementById('ucubeTree')); 
		treeObj.__loadSubItem(search_condition, search_value);
	}
}

</script>
<!--  
<a href="#" onclick="treeObj.collapseAll()">Collapse all</a> |
<a href="#" onclick="treeObj.expandAll()">Expand all</a>
-->

<!--
<p style="margin:10px">Use your mouse to drag and drop the nodes. Use the "Save" button to save your changes. The new structure will be sent to the server by use of Ajax(Asynchron XML and Javascript). </p>
<p style="margin:10px"><b><i>Note!</i></b> I'm not saving the structure in this demo in order to make the script look the same for all visitors</p>
-->
<!-- Form - if you want to save it by form submission and not Ajax -->
<!-- 
<form name="myForm" method="post" action="saveNodes.php">
	<input type="hidden" name="saveString">
</form>
 -->
