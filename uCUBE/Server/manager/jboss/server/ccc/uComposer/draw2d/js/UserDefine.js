draw2d.Figure.prototype.onKeyDown=function(/*:int*/ keyCode, /*:boolean*/ ctrl)
{
  return;
  if(keyCode==46 && this.isDeleteable()==true)
  {
   	deleteService(this);
    //this.workflow.commandStack.execute(new draw2d.CommandDelete(this));
  }

  // redirect any CTRL key strokes to the parent workflow/canvas
  //
  if(ctrl)
  {
     this.workflow.onKeyDown(keyCode,ctrl);
  }
}

draw2d.Workflow.prototype.onKeyDown=function( /*:int*/ keyCode, /*:boolean*/ ctrl)
{
  return;
  // "Figure" l?cht sich selbst, da dies den KeyDown Event empfangen
  // kann. Bei einer Linie geht dies leider nicht, und muss hier abgehandelt werden.
  //

  if(keyCode==46 && this.currentSelection!=null && this.currentSelection.isDeleteable()) {
   	deleteConnection(this.currentSelection);
     //this.commandStack.execute(new draw2d.CommandDelete(this.currentSelection));
  }
  else if(keyCode==90 && ctrl)
     this.commandStack.undo();
  else if(keyCode==89 && ctrl)
     this.commandStack.redo();

}


function makeNewIFD() {
	if(document.getElementById("interface_seq").value != "")
		ClearCanvas();
	
	interfaceManagement();
}

function ClearCanvas() {
	document.getElementById("interface_seq").value = "";
	document.getElementById("interface_id_text").innerHTML = "";
	
	var figures = workflow.getDocument().getFigures();
	
	//remove figure
	for(var i=0;i<figures.getSize();i++) {
		//remove line
		if(figures.get(i).getPort("input")) {
			var line = figures.get(i).getPort("input").getConnections();
			if(line.getSize()>0) workflow.removeFigure(line.get(0));
		}

		workflow.removeFigure(figures.get(i));
	}
}

function findServiceObject(figures, objName) {

	for (var i=0;i<figures.getSize();i++) {
		if (figures.get(i).id==objName) {
			return figures.get(i);
		}
	}
	
	return null;
}

var objXPos = 50, objYPos = 50;

//Draw object on canvas
function addObj(objID, objType, objImage, objLabel, objPosX, objPosY, db_sql_cnt, db_layout_cnt) {
	var tempObj;
	var figures = workflow.getDocument().getFigures();

	for(var i=0;i<figures.getSize();i++)
	{
		if(figures.get(i).id==objID) {
			alert("이미 Interface 내에 존재하는 Service 입니다."); //alert("Already Exist!!!");
			return false;
		}
		else if(objType=="sender" && figures.get(i).type.toLowerCase()==objType) {
			alert("Interface 내에는 한개의 Sender Service가 존재할 수 있습니다."); //alert("Just 1 Sender!!!");
			return false;
		}
	}

	if(objType=="sender")
		tempObj = new draw2d.Sender(objLabel, objImage);
	else if(objType=="bridge")
		tempObj = new draw2d.Bridge(objLabel, objImage);
	else
		tempObj = new draw2d.Receiver(objLabel, objImage);
	
	tempObj.id = objID;
	
	//Dbadapter Sql, Layout Configuration Integrity
	if(db_sql_cnt>0) tempObj.db_sql = true;
	if(db_layout_cnt>0) tempObj.db_layout = true;
	
	if(objPosX==null || objPosY==null) {
		objPosX = objXPos; 
		objPosY = objYPos;
		objXPos += 20;
	  	objYPos += 20;  
	} 

	workflow.addFigure(tempObj, objPosX/1, objPosY/1);
	//return tempObj;
}

function checkIntegrity() {

	var figures = workflow.getDocument().getFigures();

	if(figures.getSize()==0) {
		alert("Interface에 Service를 추가해 주세요."); //alert("No Service!!!")
		return false;
	}

	for(var i=0;i<figures.getSize();i++)
	{
		if(figures.get(i).getPort("output") != null && figures.get(i).getPort("output").getConnections().getSize()==0) {
			alert(figures.get(i).title.split("<p>")[2] + " (outputPort)에 Connection 정보가 없습니다."); //alert(figures.get(i).title.split("<p>")[2] + " (outputPort) Has No Line!!!");
			return false;
		}
		else if(figures.get(i).getPort("input") != null && figures.get(i).getPort("input").getConnections().getSize()==0) {
			alert(figures.get(i).title.split("<p>")[2] + " (inputPort)에 Connection 정보가 없습니다."); //alert(figures.get(i).title.split("<p>")[2] + " (inputPort) Has No Line!!!");
			return false;
		}
		else if(figures.get(i).getPort("input") != null){
			var line = figures.get(i).getPort("input").getConnections();
			
			if(line.get(0).id.split("_").length!=3) {
				var sourceService = line.get(0).getSource().getParent().title.split("<p>")[2];
				var targetService = line.get(0).getTarget().getParent().title.split("<p>")[2];
				alert("["+sourceService+", "+targetService+"]에 Queue정보가 없습니다."); //alert("["+sourceService+", "+targetService+"] No Queue Info!!!");
				return false;
			}
		}
		
		if(figures.get(i).service_group_type=="9" && figures.get(i).db_sql!=true) {
			alert(figures.get(i).title.split("<p>")[2] + " (SQL Configuration) 정보가 입력되지 않았습니다."); //alert(figures.get(i).title.split("<p>")[2] + " (SQL Configuration) Not Completed!!!");
			return false;
		}
		else if(figures.get(i).service_group_type=="8" && figures.get(i).db_sql!=true) {
			alert(figures.get(i).title.split("<p>")[2] + " (SQL Configuration) 정보가 입력되지 않았습니다."); //alert(figures.get(i).title.split("<p>")[2] + " (SQL Configuration) Not Completed!!!");
			return false;
		}
		else if(figures.get(i).service_group_type=="8" && figures.get(i).db_layout!=true) {
			alert(figures.get(i).title.split("<p>")[2] + " (Layout Configuration) 정보가 입력되지 않았습니다."); //alert(figures.get(i).title.split("<p>")[2] + " (Layout Configuration) Not Completed!!!");
			return false;
		}
	}

	return true;
}

function configXML(){
	var senderServiceSeq;	
	var interfaceServiceValue = document.getElementById("interfaceServiceValue");
	interfaceServiceValue.value = "";

	var figures = workflow.getDocument().getFigures();

	//assign nodes to array
	for (var i = 0; i < figures.getSize(); i++) {
	  figure = figures.get(i);
		//alert(figure.service_group_type);
		if(figure.getPort("input") && figure.getPort("input").getConnections().getSize()>0) {
			con = figure.getPort("input").getConnections();
			senderServiceSeq = con.get(0).getSource().parentNode.id.split("_")[2];
		}
		else {
			senderServiceSeq = "noService";
		}

		interfaceServiceValue.value += figure.id.split("_")[2]+"|"+senderServiceSeq+"|"+figure.getX()+"|"+figure.getY()+"[";
		
//alert(interfaceServiceValue.value);
	}
	
	if(interfaceServiceValue.value=="") {
		alert("Interface Diagram 정보가 없습니다."); //alert("NO IFD");
		return false;
	}
	
	return true;
}

function saveInterfaceView(flag)
{
	var interface_seq = document.getElementById("interface_seq").value;
	
	if(interface_seq=="") {
		alert("Interface 정보가 없습니다. - 새로운 Interface를 생성 후 정보를 입력해 주세요."); //alert("No Interface Info - Make New Interface First");
		return false;
	}

	if(flag=="commit") {
		if(!checkIntegrity()) return false;
	}
		
	if(!configXML()) return false;
	
	var saveString = document.getElementById("interfaceServiceValue").value;
//alert(saveString);
	var ajaxIndex = ajaxObjects.length;
	ajaxObjects[ajaxIndex] = new sack();
	var url = '/uComposer/uComposerInterfaceServiceAction.do?ServiceName=uComposerInterfaceService-service&insert.x=1&flag='+flag+'&interface_seq='+interface_seq+'&saveString='+saveString;
//alert(url);
	ajaxObjects[ajaxIndex].requestFile = url;	// Specifying which file to get
	ajaxObjects[ajaxIndex].onCompletion = function() { interfaceSaveComplete(ajaxIndex, flag); } ;	// Specify function that will be executed after file has been found
	ajaxObjects[ajaxIndex].runAJAX();		// Execute AJAX function
}

function interfaceSaveComplete(index, flag)
{
	if(ajaxObjects[index].response.replace(/\s/g, "") == "OK") {

		var figures = workflow.getDocument().getFigures();
	
		//assign nodes to array
		for (var i = 0; i < figures.getSize(); i++) {
			figure = figures.get(i);
			obj = document.getElementById(figure.id+"_"+document.getElementById("interface_seq").value);

			if(obj==null) {
				tempService = document.getElementById(figure.id);
				if(tempService!=null) {
					treeObj.refreshItem("fromOuterFunc", tempService);
				}	
			}
		}


		if(flag=="commit")
			alert("정상 처리 되었습니다."); //alert("Committed!!!");
		else
			alert("정보가 저장되었습니다."); //alert("Saved!!!");
	}
	else
		alert("저장중 오류가 발생했습니다."); //alert("An error occurred!!!");
}

function reloadIfdOnCanvas(interface_seq, interface_id_text)
{
	ClearCanvas();

	var temp_interface_seq = interface_seq.split("_");

	if(temp_interface_seq[3]!=null) 
		interface_seq = temp_interface_seq[3];
	else {
		if(interface_seq=="") return false;
		var version = document.getElementById("interface_version").value;
	}
			
	document.getElementById("interface_seq").value = interface_seq;  
	document.getElementById("interface_id_text").innerHTML = interface_id_text;
//alert(interface_seq);
	//var saveString = document.getElementById("interfaceServiceValue").value;
	var ajaxIndex = ajaxObjects.length;
	ajaxObjects[ajaxIndex] = new sack();
	var url = '/uComposer/uComposerInterfaceServiceAction.do?ServiceName=uComposerInterfaceService-service&select.x=1&interface_seq='+interface_seq+'&version='+version;
	ajaxObjects[ajaxIndex].requestFile = url;	// Specifying which file to get
	ajaxObjects[ajaxIndex].onCompletion = function() { interfaceServiceSelectComplete(ajaxIndex); } ;	// Specify function that will be executed after file has been found
	ajaxObjects[ajaxIndex].runAJAX();		// Execute AJAX function
	
}

function interfaceServiceSelectComplete(index)
{
	ReloadCanvas(ajaxObjects[index].response);
}

//reload the canvas
function  ReloadCanvas(interfaceServiceInfo)
{
	//alert(interfaceServiceInfo);
	var serviceInfo;
	var sourceObj = new Array(); 
	var targetObj = new Array();
	var sourceServiceID = new Array();
	var engine_queue_info = new Array();
	var tmpObj = new Array(); 
	
	interfaceServiceInfo = interfaceServiceInfo.split("[");
	//alert(interfaceServiceInfo.length);

	for(var i=0;i<interfaceServiceInfo.length;i++) {
		serviceInfo = interfaceServiceInfo[i].replace(/\s/g, ""); 
		//alert("-----"+serviceInfo+"-----");
		if(serviceInfo!="") {
			serviceInfo = serviceInfo.split("|");

			addObj(serviceInfo[0], serviceInfo[1], serviceInfo[2], serviceInfo[3], serviceInfo[4], serviceInfo[5], serviceInfo[9], serviceInfo[10]);
			
			targetObj[i] = serviceInfo[0];
			sourceObj[i] = serviceInfo[7];
			sourceServiceID[serviceInfo[6]/1] = serviceInfo[0];
			engine_queue_info[i] = serviceInfo[8];
						
		}
	}
	
	var figures = workflow.getDocument().getFigures();
	
	for(j=0;j<figures.getSize();j++) {
		if(sourceServiceID[sourceObj[j]/1]!=null) {
			sourceFigure = findServiceObject(figures, sourceServiceID[sourceObj[j]/1]);
			targetFigure = findServiceObject(figures, targetObj[j]);
			
			if(sourceFigure && targetFigure) {
				makeConnection(sourceFigure, targetFigure, engine_queue_info[j]);
			}	
		}	
	}
}

function makeConnection(sourceFigure, targetFigure, engine_queue_info) {
	// create a new connection
	var temp_engine_queue_info = engine_queue_info.split("_");
	if(sourceFigure.getPort("output") && targetFigure.getPort("input")) {
		var con = new draw2d.ContextmenuConnection(temp_engine_queue_info[1]+"<p>"+temp_engine_queue_info[2]);
		
		con.setSource(sourceFigure.getPort("output"));
		con.setTarget(targetFigure.getPort("input"));
		workflow.addFigure(con);
		
		if(engine_queue_info != "") { 
			con.id = engine_queue_info;
		}
	}
}
		
function connectionManagement(oThis) {
	//alert(oThis.id);
	var interface_seq = document.getElementById("interface_seq").value;
	
	if(interface_seq == "") {
		//alert("No Interface ID, Save Interface ID First!!!");
		alert("Interface 정보가 없습니다. - 새로운 Interface를 생성 후 정보를 입력해 주세요."); //alert("No Interface Info - Make New Interface First");
		return false;
	}
	
	var temp_soruceService = oThis.getSource().getParent();
	var temp_targetService = oThis.getTarget().getParent(); 
	
	soruceService = temp_soruceService.id.split("_")[2];
	targetService = temp_targetService.id.split("_")[2];	

	//Get Connection ID
	var modalValue = new Object();
	modalValue.key = "";
		
	var figures = workflow.getDocument().getFigures();
	
	for(var i=0;i<figures.getSize();i++)
	{
		if(figures.get(i).getPort("input") != null) {
			var lines = figures.get(i).getPort("input").getConnections();
			if(lines.getSize()>0) {
				modalValue.key += lines.get(0).id + "|";
			}
		}
	}

	var targetUrl = "/uComposer/uComposerConnectionAction.do?ServiceName=uComposerConnection-service&select.x=1&interface_seq="+interface_seq+"&soruceService="+soruceService+"&targetService="+targetService;
	
	var returnValue = window.showModalDialog(targetUrl, modalValue, "dialogWidth:800px; dialogHeight:600px; stauts:no; help:no;");

	if(typeof returnValue != "undefined" && returnValue != "") {
		workflow.removeFigure(oThis);
		makeConnection(temp_soruceService, temp_targetService, returnValue);
	}
}

function interfaceManagement(interface_seq) {
	var interface_seq = document.getElementById("interface_seq");
	//alert(interface_seq);
	
	var targetUrl = "/uComposer/uComposerInterfaceAction.do?ServiceName=uComposerInterface-service&select.x=1&interface_seq="+interface_seq.value;
	var returnValue = window.showModalDialog(targetUrl, "interface", "dialogWidth:800px; dialogHeight:600px; stauts:no; help:no;");
			
	if(returnValue) {
		returnValue = returnValue.split("|");
		interface_seq.value = returnValue[0];
		document.getElementById("interface_id_text").innerHTML = returnValue[1];
		//alert("Interface Saved.");
	}
	else {
		//alert("No Interface, Please Make Interface Again!!!");
		alert("Interface 정보가 없습니다. - 새로운 Interface를 생성 후 정보를 입력해 주세요."); //alert("No Interface Info - Make New Interface First");
	}
}

function deleteService(oThis) {
	//alert(oThis.id+"_"+document.getElementById("interface_seq").value);
	
	if(oThis.getPort("output") != null && oThis.getPort("output").getConnections().getSize()>0) {
		alert("Service를 삭제하기 전에 Connection을 먼저 삭제해야 합니다."); //alert("Delete Connection First!!!");
		
		return false;
	}
	else if(oThis.getPort("input") != null && oThis.getPort("input").getConnections().getSize()>0) {
		alert("Service를 삭제하기 전에 Connection을 먼저 삭제해야 합니다."); //alert("Delete Connection First!!!");		
		return false;
	}
	else {
		tempTitle = oThis.title.split("<p>");
		if(!confirm("service("+tempTitle[2]+")를 삭제 하시겠습니까?")) { //if(!confirm("Would you like to delete selected service("+tempTitle[2]+")?")) {
			return false;
		}
		
		obj = document.getElementById(oThis.id+"_"+document.getElementById("interface_seq").value);
		if(obj) {
			obj.parentNode.removeChild(obj);
		}
	
		oThis.workflow.commandStack.execute(new draw2d.CommandDelete(oThis))
	}
}

function deleteConnection(oThis) {
	var temp_queue_seq = oThis.id.split("_");
	var msg;
	
	if(temp_queue_seq.length==3)
		msg = "선택된 connection("+temp_queue_seq[1]+"/"+temp_queue_seq[2]+")을 삭제 하시겠습니까?"; //msg = "Would you like to delete selected connection("+temp_queue_seq[1]+"/"+temp_queue_seq[2]+")?";
	else
		msg = "선택된 connection을 삭제 하시겠습니까?"; //msg = "Would you like to delete selected connection?";
			
	if(!confirm(msg)) {
		return false;
	}
	
	if(temp_queue_seq.length==3) {
		queue_seq = temp_queue_seq[0];
		var interface_seq = document.getElementById("interface_seq").value;
	
		var ajaxIndex = ajaxObjects.length;
		ajaxObjects[ajaxIndex] = new sack();
		var url = '/uComposer/uComposerConnectionDeleteAction.do?ServiceName=uComposerConnection-service&delete.x=1&queue_seq='+queue_seq+'&interface_seq='+interface_seq;
		ajaxObjects[ajaxIndex].requestFile = url;	// Specifying which file to get
		ajaxObjects[ajaxIndex].onCompletion = function() { deleteConnectionComplete(ajaxIndex, oThis); } ;	// Specify function that will be executed after file has been found
		ajaxObjects[ajaxIndex].runAJAX();		// Execute AJAX function
	}
	else
		oThis.workflow.commandStack.execute(new draw2d.CommandDelete(oThis));	
}

function deleteConnectionComplete(index, oThis) {
	//alert(ajaxObjects[index].response);
	if((ajaxObjects[index].response).replace(/\s/g, "")=="OK") {
		oThis.workflow.commandStack.execute(new draw2d.CommandDelete(oThis));
	}
	else {
		alert("오류가 발생했습니다. 다시 삭제해 주세요."); //alert("An Error Occurred!!!");
		
	}
}

function ruleManagement(oThis) {
	//alert(oThis.id);
	var interface_seq = document.getElementById("interface_seq").value;
	if(interface_seq=="") {
		alert("먼저 Interface를 생성해 주세요."); alert("No Interface ID!!!");
		return false;
	}

	var modalValue = ""; 
	var service_seq = oThis.id.split("_")[2];
	var targetUrl = "/uComposer/mapperRuleCreateAction.do?ServiceName=mapperRule-service&find1.x=1&service_seq="+service_seq+"&interface_seq="+interface_seq;
	//alert(targetUrl); 
	var returnValue = window.showModalDialog(targetUrl, modalValue, "dialogWidth:800px; dialogHeight:600px; stauts:no; help:no; scroll:yes;"); // resizable:no; status:no; scroll:no; unadorned:no; edge:sunken; ecnter:yes
	
	if(typeof returnValue != "undefined" && returnValue) {
		alert(returnValue);
	}	

}

function getConfigInfo(flag)
{
	var ajaxIndex = ajaxObjects.length;
	ajaxObjects[ajaxIndex] = new sack();
	var url = '/uComposer/uComposerGetConfigInfoAction.do?ServiceName=uComposerGetConfigInfo-service&select.x=1&flag='+flag;
//alert(url);
	ajaxObjects[ajaxIndex].requestFile = url;	// Specifying which file to get
	ajaxObjects[ajaxIndex].onCompletion = function() { getConfigInfoComplete(ajaxIndex, flag); } ;	// Specify function that will be executed after file has been found
	ajaxObjects[ajaxIndex].runAJAX();		// Execute AJAX function
}

function getConfigInfoComplete(index, flag)
{
alert(ajaxObjects[index].response.replace(/\s/g, ""));
	if(ajaxObjects[index].response.replace(/\s/g, "") == "OK") {
		alert("정상처리 되었습니다."); //alert("OK");
	}
	else
		alert("처리중 오류가 발생했습니다."); //alert("An error occurred!!!");
}

function sqlManagement(oThis) {
	//alert(oThis.id);
	var interface_seq = document.getElementById("interface_seq").value;
	var interface_id = document.getElementById("interface_id_text").innerHTML;
	if(interface_seq=="") {
		alert("Interface 정보가 없습니다. 먼저 Interface 정보를 입력해 주세요."); //alert("No Interface ID!!!");
		return false;
	}

	var modalValue = ""; 
	var service_seq = oThis.id.split("_")[2];
	var targetUrl = "/uComposer/dbAdapterSqlAction.do?ServiceName=uComposerDbAdapterSql-service&select.x=1&service_seq="+service_seq+"&interface_seq="+interface_seq+"&interface_id="+interface_id;
	//alert(targetUrl); 
	var returnValue = window.showModalDialog(targetUrl, modalValue, "dialogWidth:820px; dialogHeight:600px; stauts:no; help:no; scroll:yes;"); // resizable:no; status:no; scroll:no; unadorned:no; edge:sunken; ecnter:yes
	
	if(typeof returnValue != "undefined" && returnValue) {
		oThis.db_sql = returnValue;
		//alert(oThis.db_sql);
	}	

}

function layoutManagement(oThis) {

	var interface_seq = document.getElementById("interface_seq").value;
	var interface_id = document.getElementById("interface_id_text").innerHTML;
	if(interface_seq=="") {
		alert("Interface 정보가 없습니다. 먼저 Interface 정보를 입력해 주세요."); //No Interface ID!!!");
		return false;
	}

	var modalValue = ""; 
	var service_seq = oThis.id.split("_")[2];
	var targetUrl = "/uComposer/dbAdapterLayoutAction.do?ServiceName=uComposerDbAdapterLayout-service&select.x=1&service_seq="+service_seq+"&interface_seq="+interface_seq+"&interface_id="+interface_id;

	//alert(targetUrl); 
	var returnValue = window.showModalDialog(targetUrl, modalValue, "dialogWidth:820px; dialogHeight:600px; stauts:no; help:no; scroll:yes;"); // resizable:no; status:no; scroll:no; unadorned:no; edge:sunken; ecnter:yes
	
	if(typeof returnValue != "undefined" && returnValue) {
		oThis.db_layout = returnValue;
		//alert(oThis.db_layout);
	}	

}