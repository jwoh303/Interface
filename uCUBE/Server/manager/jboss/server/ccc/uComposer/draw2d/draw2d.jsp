<html>
<head>
<meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">
<title>uComposer Main</title>

<link rel="stylesheet" type="text/css" href="/uComposer/draw2d/css/ext-all.css" />

<SCRIPT src="/uComposer/draw2d/js/wz_jsgraphics.js"></SCRIPT>
<SCRIPT src="/uComposer/draw2d/js/draw2d.js"></SCRIPT>
<SCRIPT src="/uComposer/draw2d/js/UserDefine.js"></SCRIPT>

<SCRIPT src="/uComposer/draw2d/js/ResizeImage.js"></SCRIPT>
<SCRIPT src="/uComposer/draw2d/js/Sender.js"></SCRIPT>
<SCRIPT src="/uComposer/draw2d/js/Receiver.js"></SCRIPT>
<SCRIPT src="/uComposer/draw2d/js/Bridge.js"></SCRIPT>
<SCRIPT src="/uComposer/draw2d/js/ContextmenuConnection.js"></SCRIPT>
<SCRIPT src="/uComposer/draw2d/js/MyInputPort.js"></SCRIPT>
<SCRIPT src="/uComposer/draw2d/js/MyOutputPort.js"></SCRIPT>

<!-- use this imports if you whant the ExtJs native implementation
<script type="text/javascript" src="./ext-base.js"></script>
-->

<!-- use this import if you prefere prototype
<script type="text/javascript" src="./adapter/prototype/prototype.js"></script>
<script type="text/javascript" src="./adapter/prototype/effects.js"></script>
<script type="text/javascript" src="./adapter/prototype/scriptaculous.js"></script>
<script type="text/javascript" src="./adapter/prototype/ext-prototype-adapter.js"></script>
-->

<link rel="stylesheet" type="text/css" href="/uComposer/draw2d/css/xtheme-gray.css" />
<script type="text/javascript" src="/uComposer/draw2d/adapter/yui/yui-utilities.js"></script>
<script type="text/javascript" src="/uComposer/draw2d/adapter/yui/ext-yui-adapter.js"></script>

<script type="text/javascript" src="/uComposer/draw2d/js/ext-all.js"></script>

</head>

<body onselectstart="return false" ondragstart="return false">
  
	<div id="treeDiv">
		<jsp:include page="/tree/make_tree.jsp" />
	</div>

	<div id="center1" class="x-layout-active-content">
		<div id="paintarea" style="position:relative;width:100%;height:1000;" >
			<div style="background-color:white;border:1px solid gray;width:100%;padding:0px;font-size:12pt;">
				<table width="100%" border="0">
					<tr>
						<td>
		    				&nbsp; Interface ID : <b><span id="interface_id_text"></span></b> 
<!--  		    	
					    	&nbsp; 
					    	<select id="interface_version" name="interface_version" onChange="javascript:reloadIfdOnCanvas(document.getElementById('interface_seq').value, document.getElementById('interface_id_text').innerHTML);">
								<option value="">-- Current Version --</option>
								<option value="-1">-1</option>
								<option value="-2">-2</option>
								<option value="-3">-3</option>
								<option value="-4">-4</option>
								<option value="-5">-5</option>
							</select>
-->		    	
						</td>
						<td align="right">
							<input type=hidden id="interface_seq" name="interface_seq">
							<input type=hidden id="interfaceServiceValue" name="interfaceServiceValue">
							<input type="button" onclick="javascript:makeNewIFD();" value="New IFD" align="right">
							<!--<input type="button" onclick="javascript:saveInterfaceView('save');" value="Save IFD" align="right">-->
							<input type="button" onclick="javascript:saveInterfaceView('commit');" value="Commit IFD" align="right">
							<!-- 
							<input type="button" onclick="javascript:getConfigInfo('mapper');" value="Get Config Info" align="right">
							-->
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>

<script>

/**********************************************************************************
 * Do the Draw2D Stuff
 **********************************************************************************/
var workflow  = new draw2d.Workflow("paintarea");
//workflow.setEnableSmoothFigureHandling(true);


/**********************************************************************************
 * Do the Ext (Yahoo UI) Stuff
 **********************************************************************************/
var center = new Ext.ContentPanel('center1', {width:100, height:200});

Example = function(){
	var layout;
	return {
		init : function(){
        	layout = new Ext.BorderLayout(
        		document.body, {
	                west: {
	                    split: true,
	                    initialSize: 300,
	                    minSize: 300,
	                    maxSize: 300,
	                    titlebar: true,
	                    collapsible: false,
	                    autoScroll: true,
	                    animate: true
	                },
	                center: {
	                    titlebar: true,
	                    autoScroll: true,
	                    fitToFrame: true
	                }
            	}
        	);

            layout.beginUpdate();
            layout.add('west',  new Ext.ContentPanel('treeDiv', {title: 'uCube List'}));
            layout.add('center',center);
            layout.endUpdate();
            
            workflow.scrollArea = document.getElementById("center1").parentNode;
/*
            var dragsource=new Ext.dd.DragSource("dragMe", {ddGroup:'TreeDD',dragData:{name: "draw2d.Sender"}});
            var dragsource=new Ext.dd.DragSource("dragMe2", {ddGroup:'TreeDD',dragData:{name: "draw2d.Receiver"}});
            var dragsource=new Ext.dd.DragSource("dragMe3", {ddGroup:'TreeDD',dragData:{name: "draw2d.Bridge"}});
*/
            var droptarget=new Ext.dd.DropTarget("center1",{ddGroup:'TreeDD'});
            droptarget.notifyDrop=function(dd, e, data) {
                if(data.name) {
                    var xOffset    = workflow.getAbsoluteX();
                    var yOffset    = workflow.getAbsoluteY();
                    var scrollLeft = workflow.getScrollLeft();
                    var scrollTop  = workflow.getScrollTop();

                    workflow.addFigure(eval("new "+data.name+"()"),e.xy[0]-xOffset+scrollLeft,e.xy[1]-yOffset+scrollTop);
                    return true;
                }
            }
        }
    };
}();

Ext.EventManager.onDocumentReady(Example.init, Example, true);
/*
var simpleToolbar = new Ext.Toolbar('toolbar');
simpleToolbar.addButton({ text: 'Scroll Bottom', cls: 'x-btn-text-icon scroll-bottom'});
simpleToolbar.addButton({ text: 'Scroll Top', cls: 'x-btn-text-icon scroll-bottom'});
simpleToolbar.addButton({ text: 'Alert', cls: 'alert("Test");'});
*/
</script>

</body>

</html>
