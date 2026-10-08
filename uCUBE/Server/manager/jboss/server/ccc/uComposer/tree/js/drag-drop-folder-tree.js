/************************************************************************************************************
Drag and drop folder tree
Copyright (C) 2006  DTHMLGoodies.com, Alf Magne Kalleland

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

Dhtmlgoodies.com., hereby disclaims all copyright interest in this script
written by Alf Magne Kalleland.

Alf Magne Kalleland, 2006
Owner of DHTMLgoodies.com


************************************************************************************************************/

	var JSTreeObj;
	var treeUlCounter = 0;

	/* Constructor */
	function JSDragDropTree()
	{
		var idOfTree;
		var imageFolder;
		var folderImage;
		var plusImage;
		var minusImage;
		var maximumDepth;
		var dragNode_source;
		var dragNode_parent;
		var dragNode_sourceNextSib;
		var dragNode_sourceCountUp;
		var dragNode_noSiblings;
		var ajaxObjects;

		this.dragDropEnable = "noDrag";
		var dragNode_destination;
		var floatingContainer;
		var dragDropTimer;
		var dropTargetIndicator;
		var insertAsSub;
		var indicator_offsetX;
		var indicator_offsetX_sub;
		var indicator_offsetY;

		this.imageFolder = '/uComposer/tree/images/';
		this.folderImage = 'dhtmlgoodies_folder.gif';
		this.plusImage = 'dhtmlgoodies_plus.gif';
		this.minusImage = 'dhtmlgoodies_minus.gif';
		this.maximumDepth = 5;
		var messageMaximumDepthReached;
		var filePathNewAddItem;
		var filePathDeleteItem;
		var filePathRenameItem;

		var additionalAddNewRequestParameters = {};
		var additionalDeleteRequestParameters = {};
		var additionalRenameRequestParameters = {};

		var addNewAllowed;
		var renameAllowed;
		var deleteAllowed;
		var currentlyActiveItem;
		var contextMenu;
		var currentItemToEdit;		// Reference to item currently being edited(example: renamed)
		var helpObj;

		this.contextMenu = false;
		this.floatingContainer = document.createElement('UL');
		this.floatingContainer.style.position = 'absolute';
		this.floatingContainer.style.display='none';
		this.floatingContainer.id = 'floatingContainer';
		this.insertAsSub = false;
		//sms document.body.appendChild(this.floatingContainer);
		document.getElementById("tree_div").appendChild(this.floatingContainer);
		this.dragDropTimer = -1;
		this.dragNode_noSiblings = false;
		this.currentItemToEdit = false;

		if(document.all){
			this.indicator_offsetX = 2;	// Offset position of small black lines indicating where nodes would be dropped.
			this.indicator_offsetX_sub = 4;
			this.indicator_offsetY = 2;
		}else{
			this.indicator_offsetX = 1;	// Offset position of small black lines indicating where nodes would be dropped.
			this.indicator_offsetX_sub = 3;
			this.indicator_offsetY = 2;
		}
		if(navigator.userAgent.indexOf('Opera')>=0){
			this.indicator_offsetX = 2;	// Offset position of small black lines indicating where nodes would be dropped.
			this.indicator_offsetX_sub = 3;
			this.indicator_offsetY = -7;
		}

		this.messageMaximumDepthReached = ''; // Use '' if you don't want to display a message

		this.addNewAllowed = true;
		this.deleteAllowed = true;
		this.renameAllowed = true;
		this.currentlyActiveItem = false;
		this.filePathAddNewItem = '/uComposer/tree/folderTree_updateItem.jsp';
		this.filePathDeleteItem = '/uComposer/tree/folderTree_updateItem.jsp';
		this.filePathRenameItem = '/uComposer/tree/folderTree_updateItem.jsp';
		this.filePathGetItemList = '/uComposer/uComposerMainListAction.do';

		this.ajaxObjects = new Array();
		this.helpObj = false;

		this.RENAME_STATE_BEGIN = 1;
		this.RENAME_STATE_CANCELED = 2;
		this.RENAME_STATE_REQUEST_SENDED = 3;
		this.renameState = null;
	}


	/* JSDragDropTree class */
	JSDragDropTree.prototype = {
		// {{{ addEvent()
	    /**
	     *
	     *  This function adds an event listener to an element on the page.
	     *
	     *	@param Object whichObject = Reference to HTML element(Which object to assigne the event)
	     *	@param String eventType = Which type of event, example "mousemove" or "mouseup"
	     *	@param functionName = Name of function to execute.
	     *
	     * @public
	     */
		addEvent : function(whichObject,eventType,functionName)
		{
		  if(whichObject.attachEvent){
		    whichObject['e'+eventType+functionName] = functionName;
		    whichObject[eventType+functionName] = function(){whichObject['e'+eventType+functionName]( window.event );}
		    whichObject.attachEvent( 'on'+eventType, whichObject[eventType+functionName] );
		  } else
		    whichObject.addEventListener(eventType,functionName,false);
		}
		// }}}
		,
		// {{{ removeEvent()
	    /**
	     *
	     *  This function removes an event listener from an element on the page.
	     *
	     *	@param Object whichObject = Reference to HTML element(Which object to assigne the event)
	     *	@param String eventType = Which type of event, example "mousemove" or "mouseup"
	     *	@param functionName = Name of function to execute.
	     *
	     * @public
	     */
		removeEvent : function(whichObject,eventType,functionName)
		{
		  if(whichObject.detachEvent){
		    whichObject.detachEvent('on'+eventType, whichObject[eventType+functionName]);
		    whichObject[eventType+functionName] = null;
		  } else
		    whichObject.removeEventListener(eventType,functionName,false);
		}
		,
		Get_Cookie : function(name) {
		   var start = document.cookie.indexOf(name+"=");
		   var len = start+name.length+1;
		   if ((!start) && (name != document.cookie.substring(0,name.length))) return null;
		   if (start == -1) return null;
		   var end = document.cookie.indexOf(";",len);
		   if (end == -1) end = document.cookie.length;
		   return unescape(document.cookie.substring(len,end));
		}
		,
		// This function has been slightly modified
		Set_Cookie : function(name,value,expires,path,domain,secure) {
			expires = expires * 60*60*24*1000;
			var today = new Date();
			var expires_date = new Date( today.getTime() + (expires) );
		    var cookieString = name + "=" +escape(value) +
		       ( (expires) ? ";expires=" + expires_date.toGMTString() : "") +
		       ( (path) ? ";path=" + path : "") +
		       ( (domain) ? ";domain=" + domain : "") +
		       ( (secure) ? ";secure" : "");
		    document.cookie = cookieString;
		}
		,
		setFileNameAddNew : function(newFileName)
		{
			this.filePathAddNewItem = newFileName;
		}
		,
		setFileNameDelete : function(newFileName)
		{
			this.filePathDeleteItem = newFileName;
		}
		,
		setFileNameRename : function(newFileName)
		{
			this.filePathRenameItem = newFileName;
		}
		,
		setAdditionalAddNewRequestParameters : function(requestParameters)
		{
			this.additionalAddNewRequestParameters = requestParameters;
		}
		,
		setAdditionalDeleteRequestParameters : function(requestParameters)
		{
			this.additionalDeleteRequestParameters = requestParameters;
		}
		,
		setAdditionalRenameRequestParameters : function(requestParameters)
		{
			this.additionalRenameRequestParameters = requestParameters;
		}
		,
		setAddNewAllowed : function(addNewAllowed)
		{
			this.addNewAllowed = addNewAllowed;
		}
		,
		setDeleteAllowed : function(deleteAllowed)
		{
			this.deleteAllowed = deleteAllowed;
		}
		,
		setRenameAllowed : function(renameAllowed)
		{
			this.renameAllowed = renameAllowed;
		}
		,
		setMaximumDepth : function(maxDepth)
		{
			this.maximumDepth = maxDepth;
		}
		,
		setDragDropEnable : function(dragDropMode)
		{
			this.dragDropEnable = dragDropMode;
		}
		,
		setMessageMaximumDepthReached : function(newMessage)
		{
			this.messageMaximumDepthReached = newMessage;
		}
		,
		setImageFolder : function(path)
		{
			this.imageFolder = path;
		}
		,
		setFolderImage : function(imagePath)
		{
			this.folderImage = imagePath;
		}
		,
		setPlusImage : function(imagePath)
		{
			this.plusImage = imagePath;
		}
		,
		setMinusImage : function(imagePath)
		{
			this.minusImage = imagePath;
		}
		,
		setTreeId : function(idOfTree)
		{
			this.idOfTree = idOfTree;
		}
		,
		expandAll : function()
		{
			var menuItems = document.getElementById(this.idOfTree).getElementsByTagName('LI');
			for(var no=0;no<menuItems.length;no++){
				var subItems = menuItems[no].getElementsByTagName('UL');
				if(subItems.length>0 && subItems[0].style.display!='block'){
					JSTreeObj.showHideNode(false,menuItems[no].id);
				}
			}
		}
		,
		collapseAll : function()
		{
			var menuItems = document.getElementById(this.idOfTree).getElementsByTagName('LI');
			for(var no=0;no<menuItems.length;no++){
				var subItems = menuItems[no].getElementsByTagName('UL');
				if(subItems.length>0 && subItems[0].style.display=='block'){
					JSTreeObj.showHideNode(false,menuItems[no].id);
				}
			}
		}
		,
		/*
		Find top pos of a tree node
		*/
		getTopPos : function(obj){
			var top = obj.offsetTop/1;
			while((obj = obj.offsetParent) != null){
				if(obj.tagName!='HTML')top += obj.offsetTop;
			}
			if(document.all)top = top/1 + 13; else top = top/1 + 4;
			return top;
		}
		,
		/*
		Find left pos of a tree node
		*/
		getLeftPos : function(obj){
			var left = obj.offsetLeft/1 + 1;
			while((obj = obj.offsetParent) != null){
				if(obj.tagName!='HTML')left += obj.offsetLeft;
			}

			if(document.all)left = left/1 - 2;
			return left;
		}
		,
		showHideNode : function(e,inputId)
		{
			if(inputId){
				if(!document.getElementById(inputId)) return;
				thisNode = document.getElementById(inputId).getElementsByTagName('IMG')[0];
			}else {
				thisNode = this;
				if(this.tagName=='A') thisNode = this.parentNode.getElementsByTagName('IMG')[0];

			}

			//if(thisNode.style.visibility=='hidden') return;

			var parentNode = thisNode.parentNode;
			inputId = parentNode.id.replace(/[^0-9]/g,'');

			if(thisNode.src.indexOf(JSTreeObj.plusImage)>=0){
				thisNode.src = thisNode.src.replace(JSTreeObj.plusImage,JSTreeObj.minusImage);
				var ul = parentNode.getElementsByTagName('UL')[0];
				if(ul) ul.style.display='block';
				if(!initExpandedNodes)initExpandedNodes = ',';
				if(initExpandedNodes.indexOf(',' + inputId + ',')<0) initExpandedNodes = initExpandedNodes + inputId + ',';

				//Make sub list
				if(parentNode.itemCategory=="system") {
					uls = parentNode.getElementsByTagName('UL');
					if(uls==null || uls.length==0)
						JSTreeObj.__loadSubItem(parentNode.itemCategory, parentNode.id)
				}
			}else{
				thisNode.src = thisNode.src.replace(JSTreeObj.minusImage,JSTreeObj.plusImage);
				var ul = parentNode.getElementsByTagName('UL')[0];
				if(ul) ul.style.display='none';
				initExpandedNodes = initExpandedNodes.replace(',' + inputId, '');
			}

			JSTreeObj.Set_Cookie('dhtmlgoodies_expandedNodes',initExpandedNodes,500);
			
			return false;
		}
		,
		/* Initialize drag */
		initDrag : function(e)
		{
			if(JSTreeObj.dragDropEnable=="noDrag") return;

			if(document.all)e = event;

			var subs = JSTreeObj.floatingContainer.getElementsByTagName('LI');
			if(subs.length>0){
				if(JSTreeObj.dragNode_sourceNextSib){
					JSTreeObj.dragNode_parent.insertBefore(JSTreeObj.dragNode_source,JSTreeObj.dragNode_sourceNextSib);
				}else{
					JSTreeObj.dragNode_parent.appendChild(JSTreeObj.dragNode_source);
				}
			}

			JSTreeObj.dragNode_source = this.parentNode;
			JSTreeObj.dragNode_parent = this.parentNode.parentNode;
			JSTreeObj.dragNode_sourceNextSib = false;
			JSTreeObj.dragNode_sourceCountUp = JSTreeObj.dragDropCountLevels(JSTreeObj.dragNode_source,'up');

			if(JSTreeObj.dragNode_source.nextSibling)JSTreeObj.dragNode_sourceNextSib = JSTreeObj.dragNode_source.nextSibling;
			JSTreeObj.dragNode_destination = false;
			JSTreeObj.dragDropTimer = 0;
			JSTreeObj.timerDrag();
			return false;
		}
		,
		timerDrag : function()
		{
			if(this.dragDropTimer>=0 && this.dragDropTimer<80){
				this.dragDropTimer = this.dragDropTimer + 1;
				setTimeout('JSTreeObj.timerDrag()',20);
				return;
			}
			if(this.dragDropTimer==80)
			{
				JSTreeObj.floatingContainer.style.display='block';
				JSTreeObj.floatingContainer.appendChild(JSTreeObj.dragNode_source);
			}
		}
		,
		moveDragableNodes : function(e)
		{
			if(JSTreeObj.dragDropTimer==null || JSTreeObj.dragDropTimer<80)return;
			if(document.all)e = event;

			dragDrop_x = e.clientX/1 + 5 + document.body.scrollLeft;
			dragDrop_y = e.clientY/1 + 5 + document.documentElement.scrollTop;

			JSTreeObj.floatingContainer.style.left = dragDrop_x + 'px';
			JSTreeObj.floatingContainer.style.top = dragDrop_y + 'px';
			JSTreeObj.floatingContainer.style.zIndex = '10000';

			var thisObj = this;
			if(thisObj.tagName=='A' || thisObj.tagName=='IMG')thisObj = thisObj.parentNode;

			JSTreeObj.dragNode_noSiblings = false;
			var tmpVar = thisObj.getAttribute('noSiblings');
			if(!tmpVar)tmpVar = thisObj.noSiblings;
			if(tmpVar=='true')JSTreeObj.dragNode_noSiblings=true;

			var thisObjCountUp = JSTreeObj.dragDropCountLevels(thisObj,'up');

			var dragNodeEnable = false;
			if(JSTreeObj.dragDropEnable=="sameDepth") {
				if(JSTreeObj.dragNode_sourceCountUp==thisObjCountUp/1+1){
					dragNodeEnable = true;
					JSTreeObj.dragNode_noSiblings = true;
				}else if(JSTreeObj.dragNode_sourceCountUp==thisObjCountUp)	{
					if(this.tagName=='IMG') dragNodeEnable = true;
				}
			}else{
				dragNodeEnable = true;
			}

			if(thisObj && thisObj.id && dragNodeEnable)
			{
				JSTreeObj.dragNode_destination = thisObj;
				var img = thisObj.getElementsByTagName('IMG')[1];
				var tmpObj= JSTreeObj.dropTargetIndicator;
				tmpObj.style.display='block';

				var eventSourceObj = this;
				if(JSTreeObj.dragNode_noSiblings && eventSourceObj.tagName=='IMG')eventSourceObj = eventSourceObj.nextSibling;

				var tmpImg = tmpObj.getElementsByTagName('IMG')[0];

				if(this.tagName=='A' || JSTreeObj.dragNode_noSiblings){
					tmpImg.src = tmpImg.src.replace('ind1','ind2');
					JSTreeObj.insertAsSub = true;
					tmpObj.style.left = (JSTreeObj.getLeftPos(eventSourceObj) + JSTreeObj.indicator_offsetX_sub) + 'px';
				}else{
					tmpImg.src = tmpImg.src.replace('ind2','ind1');
					JSTreeObj.insertAsSub = false;
					tmpObj.style.left = (JSTreeObj.getLeftPos(eventSourceObj) + JSTreeObj.indicator_offsetX) + 'px';
				}

				tmpObj.style.top = (JSTreeObj.getTopPos(thisObj) + JSTreeObj.indicator_offsetY) + 12 + 'px';
				tmpObj.style.zIndex = '10000';
			}

			return false;
		}
		,
		dropDragableNodes:function()
		{
			if(JSTreeObj.dragDropTimer<10){
				JSTreeObj.dragDropTimer = -1;
				return;
			}
			var showMessage = false;
			if(JSTreeObj.dragNode_destination){	// Check depth
				var countUp = JSTreeObj.dragDropCountLevels(JSTreeObj.dragNode_destination,'up');
				var countDown = JSTreeObj.dragDropCountLevels(JSTreeObj.dragNode_source,'down');
				var countLevels = countUp/1 + countDown/1 + (JSTreeObj.insertAsSub?1:0);

				if(countLevels>JSTreeObj.maximumDepth){
					JSTreeObj.dragNode_destination = false;
					showMessage = true; 	// Used later down in this function
				}
			}


			if(JSTreeObj.dragNode_destination){
				if(JSTreeObj.insertAsSub){
					var uls = JSTreeObj.dragNode_destination.getElementsByTagName('UL');
					if(uls.length>0){
						ul = uls[0];
						ul.style.display='block';

						var lis = ul.getElementsByTagName('LI');

						if(lis.length>0){	// Sub elements exists - drop dragable node before the first one
							ul.insertBefore(JSTreeObj.dragNode_source,lis[0]);
						}else {	// No sub exists - use the appendChild method - This line should not be executed unless there's something wrong in the HTML, i.e empty <ul>
							ul.appendChild(JSTreeObj.dragNode_source);
						}
					}else{
						var ul = document.createElement('UL');
						ul.style.display='block';
						JSTreeObj.dragNode_destination.appendChild(ul);
						ul.appendChild(JSTreeObj.dragNode_source);
					}
					var img = JSTreeObj.dragNode_destination.getElementsByTagName('IMG')[0];
					img.style.visibility='visible';
					img.src = img.src.replace(JSTreeObj.plusImage,JSTreeObj.minusImage);

				}else{
					if(JSTreeObj.dragNode_destination.nextSibling){
						var nextSib = JSTreeObj.dragNode_destination.nextSibling;
						nextSib.parentNode.insertBefore(JSTreeObj.dragNode_source,nextSib);
					}else{
						JSTreeObj.dragNode_destination.parentNode.appendChild(JSTreeObj.dragNode_source);
					}
				}
				/* Clear parent object */
				var tmpObj = JSTreeObj.dragNode_parent;
				var lis = tmpObj.getElementsByTagName('LI');
				if(lis.length==0){
					var img = tmpObj.parentNode.getElementsByTagName('IMG')[0];
					img.style.visibility='hidden';	// Hide [+],[-] icon
					tmpObj.parentNode.removeChild(tmpObj);
				}

			}else{
				// Putting the item back to it's original location

				if(JSTreeObj.dragNode_sourceNextSib){
					JSTreeObj.dragNode_parent.insertBefore(JSTreeObj.dragNode_source,JSTreeObj.dragNode_sourceNextSib);
				}else{
					JSTreeObj.dragNode_parent.appendChild(JSTreeObj.dragNode_source);
				}

			}
			JSTreeObj.dropTargetIndicator.style.display='none';
			JSTreeObj.dragDropTimer = -1;
			if(showMessage && JSTreeObj.messageMaximumDepthReached)alert(JSTreeObj.messageMaximumDepthReached);
		}
		,
		createDropIndicator : function()
		{
			this.dropTargetIndicator = document.createElement('DIV');
			this.dropTargetIndicator.style.position = 'absolute';
			this.dropTargetIndicator.style.display='none';
			var img = document.createElement('IMG');
			img.src = this.imageFolder + 'dragDrop_ind1.gif';
			img.id = 'dragDropIndicatorImage';
			this.dropTargetIndicator.appendChild(img);
			//sms document.body.appendChild(this.dropTargetIndicator);
			document.getElementById("tree_div").appendChild(this.dropTargetIndicator);

		}
		,
		dragDropCountLevels : function(obj,direction,stopAtObject){
			var countLevels = 0;
			if(direction=='up'){
				while(obj.parentNode && obj.parentNode!=stopAtObject){
					obj = obj.parentNode;
					if(obj.tagName=='UL')countLevels = countLevels/1 +1;
				}
				return countLevels;
			}

			if(direction=='down'){
				var subObjects = obj.getElementsByTagName('LI');
				for(var no=0;no<subObjects.length;no++){
					countLevels = Math.max(countLevels,JSTreeObj.dragDropCountLevels(subObjects[no],"up",obj));
				}
				return countLevels;
			}
		}
		,
		cancelEvent : function()
		{
			return false;
		}
		,
		cancelSelectionEvent : function()
		{
			if(JSTreeObj.dragDropTimer<10)return true;
			return false;
		}
		,
		getNodeOrders : function(initObj,saveString)
		{
			if(!saveString)var saveString = '';

			if(!initObj){
				initObj = document.getElementById(this.idOfTree);
			}

			var lis = initObj.getElementsByTagName('LI');

			if(lis.length>0){
				var li = lis[0];
				while(li){
					if(li.id){
						if(saveString.length>0)saveString = saveString + ',';
						var numericID = li.id.replace(/[^0-9]/gi,'');
						if(numericID.length==0)numericID='A';
						var numericParentID = li.parentNode.parentNode.id.replace(/[^0-9]/gi,'');
						if(numericID!='0'){
							saveString = saveString + numericID;
							saveString = saveString + '-';


							if(li.parentNode.id!=this.idOfTree)saveString = saveString + numericParentID; else saveString = saveString + '0';
						}
						var ul = li.getElementsByTagName('UL');
						if(ul.length>0){
							saveString = this.getNodeOrders(ul[0],saveString);
						}
					}
					li = li.nextSibling;
				}
			}

			if(initObj.id == this.idOfTree){
				return saveString;

			}
			return saveString;
		}
		,
		highlightItem : function(inputObj,e)
		{
			if(JSTreeObj.currentlyActiveItem)JSTreeObj.currentlyActiveItem.className = '';
			this.className = 'highlightedNodeItem';
			JSTreeObj.currentlyActiveItem = this;
		}
		,
		removeHighlight : function()
		{
			if(JSTreeObj.currentlyActiveItem)JSTreeObj.currentlyActiveItem.className = '';
			JSTreeObj.currentlyActiveItem = false;
		}
		,
		hasSubNodes : function(obj)
		{
			var subs = obj.getElementsByTagName('LI');
			
			if(subs.length>0) return true;
			
			return false;
		}
		,
		addItem : function(itemCategory, parentID, itemID, itemText, serviceTitle, serviceImage, groupCategory, sub_exist)
		{
			if(document.getElementById(itemID)) return false;

			obj = document.getElementById(parentID);

			var li = document.createElement('LI'); //create new node

			li.id = itemID;
			li.itemCategory = itemCategory;
			if(groupCategory != "") li.groupCategory = groupCategory;
			if(serviceTitle != "") li.serviceTitle = serviceTitle;
			if(serviceImage != "") li.serviceImage = serviceImage;
			if(itemCategory=="interface") li.itemText = itemText;

			var aTag = document.createElement('A');
									
			aTag.style.cursor = "pointer";
			
			if(itemCategory=="system") {
				aTag.innerHTML = "<b>" + itemText + "</b>";
			}
			else {
				aTag.innerHTML = itemText;
			}
				
			li.appendChild(aTag);
			
			var plusImage = document.createElement('IMG');
			//plusImage.id = "test";
			plusImage.onclick = this.showHideNode;
			
			plusImage.src = this.imageFolder + this.plusImage;
//alert(sub_exist);
			if(itemCategory!="system" || sub_exist=="") 
				plusImage.style.visibility = 'hidden';
			li.insertBefore(plusImage, aTag);
			
			var folderImg = document.createElement('IMG');
			//folderImg.src = this.imageFolder + "ic_" + serviceImage + ".gif";
			folderImg.src = this.imageFolder + "ic_" + itemCategory + ".gif";
			li.insertBefore(folderImg, aTag);

			if(this.contextMenu){
				try {
					var menuModel = new DHTMLGoodies_menuModel();
					
					if(itemCategory=="system") {
						menuModel.addItem(1,'Add New Service Group','','',false,'JSTreeObj.addNewItem');
						menuModel.addItem(2,'Refresh Sub List','','',false,'JSTreeObj.refreshItem');
						menuModel.addItem(3,'Delete','','',false,'JSTreeObj.deleteItem');
						menuModel.addItem(4,'Property','','',false,'JSTreeObj.updateItem');
						aTag.ondblclick = function () { JSTreeObj.addNewItem(null, aTag); }
					} 
					else if(itemCategory=="servicegroup") {
						menuModel.addItem(1,'Add New Service','','',false,'JSTreeObj.addNewItem');
						menuModel.addItem(2,'Refresh Sub List','','',false,'JSTreeObj.refreshItem');
						menuModel.addItem(3,'Delete','','',false,'JSTreeObj.deleteItem');
						menuModel.addItem(4,'Property','','',false,'JSTreeObj.updateItem');
						aTag.ondblclick = function () { JSTreeObj.addNewItem(null, aTag); }
					}
					else if(itemCategory=="service") {
						menuModel.addItem(1,'Add Service On Canvas','','',false,'JSTreeObj.drawObject');
						menuModel.addItem(2,'Refresh Sub List','','',false,'JSTreeObj.refreshItem');
						menuModel.addItem(3,'Delete','','',false,'JSTreeObj.deleteItem');
						menuModel.addItem(4,'Property','','',false,'JSTreeObj.updateItem');
						aTag.ondblclick = function () { JSTreeObj.drawObject(null, aTag); }
					}
					else if(itemCategory=="interface") {
						menuModel.addItem(1,'Reload Interface Diagram','','',false,'JSTreeObj.reloadIFD');
						menuModel.addItem(2,'Delete','','',false,'JSTreeObj.deleteItem');
						menuModel.addItem(3,'Property','','',false,'JSTreeObj.updateItem');
						aTag.ondblclick = function () { JSTreeObj.reloadIFD(null, aTag); }
					}
					
					menuModel.init();
				}catch(e){

				}

				this.contextMenu.attachToElement(aTag, false, menuModel);
			}

			this.addEvent(aTag, 'contextmenu', this.highlightItem);
			this.addEvent(aTag, 'click', this.highlightItem);

			this.__addNode(obj, li);
		}
		,
		__addNode : function(parentNode, newNode)
		{
			uls = parentNode.getElementsByTagName('UL');

			if(uls.length>0){
				ul = uls[0];
				ul.style.display = 'block';

				var lis = ul.getElementsByTagName('LI');
				if(lis.length>0){
					ul.insertBefore(newNode,lis[0]);
				}else {
					ul.appendChild(newNode);
				}
			}else{
				var ul = document.createElement('UL');
				ul.style.display = 'block';
				parentNode.appendChild(ul);
				ul.appendChild(newNode);
			}
			
			if(parentNode.itemCategory=="system") {
				var img = parentNode.getElementsByTagName('IMG');
				
				//if(img[0] && img[0].style.visibility != "hidden") {
					img[0].style.visibility = 'visible';
					img[0].src = this.imageFolder + this.minusImage;
				//}
				
				//if(ul.style.display != 'block'){
				//	this.showHideNode(false, parentNode.id);
				//}
			}	
		}
		,
		deleteItem : function(obj1, obj2)
		{
			var subs = obj2.parentNode.getElementsByTagName('LI');
			
			for(var i=0; i<subs.length ; i++) { //Check If has subnodes
				var sub_id = subs[i].id.split("_");
				if(sub_id.length==4) { //Interface Id (exam 111_222_333_444) 
					alert("Delete Interface First!!!");
					return false;
				}	
			}

			var message = 'Click OK to delete item ' + obj2.innerHTML.replace(/<[\/\!]*?[^<>]*?>/gi,"");
			message = message + ' (and it\'s sub nodes)';
			
			if(confirm(message)){
				this.__deleteItem_step2(obj2.parentNode);	// Sending <LI> tag to the __deleteItem_step2 method
			}
		}
		,
		deleteChildItem : function(obj)
		{
			//alert(obj.id);
			uls = obj.getElementsByTagName('UL');

			if(uls!=null && uls.length>0)
				obj.removeChild(uls[0]);
			
			//obj.parentNode.removeChild(obj);
			
			var parentRef = obj.parentNode.parentNode;
			//this.__reloadList(parentRef);
		}
		,
		updateItem : function(obj1, obj2)
		{
			JSTreeObj.__popupDialog("updateItem", obj2);
		}
		,
		refreshItem : function(obj1, obj2)
		{
			var targetObj = null;
			
			if(obj1=="fromOuterFunc")
				targetObj = obj2;
			else
				targetObj = obj2.parentNode;
				
			JSTreeObj.deleteChildItem(targetObj);
			
			if(targetObj.itemCategory=="system") {
				targetObj.getElementsByTagName('IMG')[0].style.visibility = 'hidden';
			}
			
			var tempId = targetObj.id.split("_");
			tempId = tempId[(tempId.length-1)];
			
			JSTreeObj.__loadSubItem(targetObj.itemCategory, tempId);
		}
		,
		__loadSubItem : function(itemCategory, itemID)
		{
			// Creating ajax object and send items
			var ajaxIndex = JSTreeObj.ajaxObjects.length;
			JSTreeObj.ajaxObjects[ajaxIndex] = new sack();
			JSTreeObj.ajaxObjects[ajaxIndex].method = "GET";
			JSTreeObj.ajaxObjects[ajaxIndex].setVar("ServiceName", "uComposerMainList-service");
			JSTreeObj.ajaxObjects[ajaxIndex].setVar("select.x", "1");
			JSTreeObj.ajaxObjects[ajaxIndex].setVar("itemCategory", itemCategory);
			JSTreeObj.ajaxObjects[ajaxIndex].setVar("itemID", itemID);
			JSTreeObj.__addAdditionalRequestParameters(JSTreeObj.ajaxObjects[ajaxIndex], JSTreeObj.additionalAddNewRequestParameters);
			JSTreeObj.ajaxObjects[ajaxIndex].requestFile = JSTreeObj.filePathGetItemList;	// Specifying which file to get
			JSTreeObj.ajaxObjects[ajaxIndex].onCompletion = function() { JSTreeObj.__getMainListComplete(ajaxIndex, itemCategory, itemID); } ;	// Specify function that will be executed after file has been found
			JSTreeObj.ajaxObjects[ajaxIndex].runAJAX();		// Execute AJAX function
		}
		,
		__getMainListComplete : function(ajaxIndex, itemCategory, itemID)
		{
			var beforeSystemID = "";
			var beforeServiceGroupID = "";
			var beforeServiceID = "";
			
			var mainListInfo = this.ajaxObjects[ajaxIndex].response.split("]");
		
			for(var i=0;i<mainListInfo.length;i++) {
				var mainList = mainListInfo[i].replace(/\s/g, ""); 
				//alert("-----"+mainListInfo+"-----");
				if(mainList!="") {
					mainList = mainList.split("|");
		
					//alert(mainList[0]+" : "+mainList[1]+" : "+mainList[2]+" : "+mainList[3]+" : "+mainList[4]+" : "+mainList[5]+" : "+mainList[6]+" : "+mainList[7]+" : "+mainList[8]+" : "+mainList[9]+" : "+mainList[10]+" : "+mainList[11]);
		
					if(mainList[0] != "" && beforeSystemID != mainList[0]) {
						beforeSystemID = mainList[0];
						this.addItem("system", "ucubeTree", mainList[0], mainList[1], "", "system", "", mainList[9]);
					}
					if(mainList[2] != "" && beforeServiceGroupID != mainList[0]+"_"+mainList[2]) {
						beforeServiceGroupID = beforeSystemID+"_"+mainList[2];
						this.addItem("servicegroup", beforeSystemID, beforeServiceGroupID, "<font color=#E09820>["+mainList[10]+"]</font> "+mainList[3], "", mainList[8], mainList[9], "");
					}
					if(mainList[4] != "" && beforeServiceID != mainList[0]+"_"+mainList[2]+"_"+mainList[4]) {
						beforeServiceID = beforeServiceGroupID+"_"+mainList[4];
						this.addItem("service", beforeServiceGroupID, beforeServiceID, mainList[5], mainList[1]+"<p>"+mainList[3]+"<p>"+mainList[5], mainList[8], mainList[9], "");
					}
					if(mainList[6] != "") {
						this.addItem("interface", beforeServiceID, beforeServiceID+"_"+mainList[6], mainList[7], "", "interface", "", "");
					}
				}
			}
			
			
			if(itemCategory=="root") {
				initExpandedNodes = this.Get_Cookie('dhtmlgoodies_expandedNodes');
	
				if(initExpandedNodes){
					var nodes = initExpandedNodes.split(',');
					for(var no=0;no<nodes.length;no++){
						if(nodes[no]){
							this.showHideNode(false,nodes[no]);
						}
					}
				}
			}
		}
		,
		__refreshDisplay : function(obj)
		{
			var img = obj.getElementsByTagName('IMG')[0];
			//alert(img.style.visibility);
			
			if(this.hasSubNodes(obj)) {
				img.style.visibility = 'visible'; //visible
				
				//img.src = this.imageFolder + this.minusImage;
			}
			else {
				img.style.visibility = 'hidden';
			}
		}
		,
		addNewItem : function(obj1, obj2)
		{
			this.__popupDialog("addNewItem", obj2);
		}
		,
		__popupDialog : function(callFunc, obj2)
		{
			var systemObj;
			var targetUrl;
			var modalValue;

			switch (obj2.parentNode.itemCategory)
			{
				case "root" : 
					targetUrl = "/uComposer/uComposerSystemAction.do?ServiceName=uComposerSystem-service&select.x=1";
					break;
				case "system" : 
					var seq = obj2.parentNode.id;
					if(callFunc == "addNewItem")
						targetUrl = "/uComposer/uComposerServiceGroupAction.do?ServiceName=uComposerServiceGroup-service&select.x=1&system_seq="+seq;
					else
						targetUrl = "/uComposer/uComposerSystemAction.do?ServiceName=uComposerSystem-service&select.x=1&system_seq="+seq;
					break;
				case "servicegroup" : 
					var seq = obj2.parentNode.id.split("_");
					systemObj = obj2.parentNode.parentNode;
//alert(obj2.parentNode.parentNode.parentNode.id+" : "+obj2.parentNode.parentNode.parentNode.parentNode.parentNode.id);					
					var groupCategory = obj2.parentNode.groupCategory;
					if(callFunc == "addNewItem")
						targetUrl = "/uComposer/uComposerServiceAction.do?ServiceName=uComposerService-service&select.x=1&service_group_seq="+seq[1]+"&service_group_type="+groupCategory;
					else
						targetUrl = "/uComposer/uComposerServiceGroupAction.do?ServiceName=uComposerServiceGroup-service&select.x=1&service_group_seq="+seq[1];
					break;
				case "service" : 
					var seq = obj2.parentNode.id.split("_");
					//var groupCategory = obj2.parentNode.groupCategory;
					//targetUrl = "/uComposer/uComposerServiceAction.do?ServiceName=uComposerService-service&select.x=1&service_group_seq="+seq[1]+"&service_seq="+seq[2]+"&service_group_type="+groupCategory;
					targetUrl = "/uComposer/uComposerServiceAction.do?ServiceName=uComposerService-service&select.x=1&service_group_seq="+seq[1]+"&service_seq="+seq[2];
					break;
				case "interface" : 
					var seq = obj2.parentNode.id.split("_");
					targetUrl = "/uComposer/uComposerInterfaceAction.do?ServiceName=uComposerInterface-service&select.x=1&interface_seq="+seq[3];
					break;	
			}

			
			var returnValue = window.showModalDialog(targetUrl, modalValue, "dialogWidth:800px; dialogHeight:600px; stauts:no; help:no; scroll:yes;"); // resizable:no; status:no; scroll:no; unadorned:no; edge:sunken; ecnter:yes
					
			if(callFunc == "addNewItem" && typeof returnValue != "undefined" && returnValue) {
				//alert(returnValue);
				if(obj2.parentNode.itemCategory=="root" || obj2.parentNode.itemCategory=="system") {
					JSTreeObj.refreshItem(null, obj2);
				}
				else {	
					JSTreeObj.refreshItem(null, systemObj);
				}
			} 
		
		}
		,
		__deleteItem_step2 : function(obj)
		{
			var itemSeq = "";
			var tempSeq = obj.id.split("_");
			
			switch (obj.itemCategory)
			{
				case "system" : 
					itemSeq = tempSeq[0];
					break;
				case "servicegroup" : 
					itemSeq = tempSeq[1];
					break;
				case "service" : 
					itemSeq = tempSeq[2];
					break;
				case "interface" : 
					itemSeq = tempSeq[3];
					break;	
			}

			var ajaxIndex = JSTreeObj.ajaxObjects.length;
			JSTreeObj.ajaxObjects[ajaxIndex] = new sack();
			JSTreeObj.ajaxObjects[ajaxIndex].method = "GET";
			
			JSTreeObj.ajaxObjects[ajaxIndex].setVar("ServiceName", "uComposerDeleteList-service");
			JSTreeObj.ajaxObjects[ajaxIndex].setVar("delete.x", "1");
			JSTreeObj.ajaxObjects[ajaxIndex].setVar("itemCategory", obj.itemCategory);
			JSTreeObj.ajaxObjects[ajaxIndex].setVar("itemSeq", itemSeq);
			
			JSTreeObj.__addAdditionalRequestParameters(JSTreeObj.ajaxObjects[ajaxIndex], JSTreeObj.additionalDeleteRequestParameters);
			//JSTreeObj.ajaxObjects[ajaxIndex].requestFile = JSTreeObj.filePathDeleteItem;	// Specifying which file to get
			JSTreeObj.ajaxObjects[ajaxIndex].requestFile = "/uComposer/uComposerDeleteListAction.do";	// Specifying which file to get
			JSTreeObj.ajaxObjects[ajaxIndex].onCompletion = function() { JSTreeObj.__deleteComplete(ajaxIndex,obj); } ;	// Specify function that will be executed after file has been found
			JSTreeObj.ajaxObjects[ajaxIndex].runAJAX();		// Execute AJAX function
		
		}
		,
		__deleteComplete : function(ajaxIndex,obj)
		{
			if(this.ajaxObjects[ajaxIndex].response.replace(/\s/g,'')!='OK'){
				alert('ERROR WHEN TRYING TO DELETE!!!'); 	// Delete failed
			}else{
				JSTreeObj.refreshItem(null, obj.parentNode);
				
				objId = obj.id.split("_");

				if(objId.length==4) {
					var subs = document.getElementById("ucubeTree").getElementsByTagName('LI');
					for(var i=0; i<subs.length; i++){
						subId = subs[i].id.split("_");
						if(subId.length==4 && subId[3]==objId[3]) {
							JSTreeObj.refreshItem(null, subs[i].parentNode);
						}
					}
				}
				
				//var parentRef = obj.parentNode.parentNode;
				//obj.parentNode.removeChild(obj);
				//this.__refreshDisplay(obj.parentNode.parentNode);
			}
		}
		,
		__renameComplete : function(ajaxIndex)
		{
			if(this.ajaxObjects[ajaxIndex].response!='OK'){
				alert('ERROR WHEN TRYING TO RENAME NODE: ' + this.ajaxObjects[ajaxIndex].response); 	// Rename failed
			}
		}
		,
		__saveTextBoxChanges : function(e,inputObj)
		{
			if(!inputObj && this)inputObj = this;
			if(document.all)e = event;
			if(e.keyCode && e.keyCode==27){
				JSTreeObj.__cancelRename(e,inputObj);
				return;
			}
			inputObj.style.display='none';
			inputObj.nextSibling.style.visibility='visible';
			if(inputObj.value.length>0){
				inputObj.nextSibling.innerHTML = inputObj.value;
				// Send changes to the server.
				if (JSTreeObj.renameState != JSTreeObj.RENAME_STATE_BEGIN) {
					return;
				}
				JSTreeObj.renameState = JSTreeObj.RENAME_STATE_REQUEST_SENDED;

				var ajaxIndex = JSTreeObj.ajaxObjects.length;
				JSTreeObj.ajaxObjects[ajaxIndex] = new sack();
				JSTreeObj.ajaxObjects[ajaxIndex].method = "GET";
				JSTreeObj.ajaxObjects[ajaxIndex].setVar("renameId", inputObj.parentNode.id.replace(/[^0-9]/gi,''));
				JSTreeObj.ajaxObjects[ajaxIndex].setVar("newName", inputObj.value);
				JSTreeObj.__addAdditionalRequestParameters(JSTreeObj.ajaxObjects[ajaxIndex], JSTreeObj.additionalRenameRequestParameters);
				JSTreeObj.ajaxObjects[ajaxIndex].requestFile = JSTreeObj.filePathRenameItem;	// Specifying which file to get
				JSTreeObj.ajaxObjects[ajaxIndex].onCompletion = function() { JSTreeObj.__renameComplete(ajaxIndex); } ;	// Specify function that will be executed after file has been found
				JSTreeObj.ajaxObjects[ajaxIndex].runAJAX();		// Execute AJAX function

			}
		}
		,
		__cancelRename : function(e,inputObj)
		{
			JSTreeObj.renameState = JSTreeObj.RENAME_STATE_CANCELD;
			if(!inputObj && this)inputObj = this;
			inputObj.value = JSTreeObj.helpObj.innerHTML;
			inputObj.nextSibling.innerHTML = JSTreeObj.helpObj.innerHTML;
			inputObj.style.display = 'none';
			inputObj.nextSibling.style.visibility = 'visible';
		}
		,
		__renameCheckKeyCode : function(e)
		{
			if(document.all)e = event;
			if(e.keyCode==13){	// Enter pressed
				JSTreeObj.__saveTextBoxChanges(false,this);
			}
			if(e.keyCode==27){	// ESC pressed
				JSTreeObj.__cancelRename(false,this);
			}
		}
		,
		__createTextBox : function(obj)
		{
			var textBox = document.createElement('INPUT');
			textBox.className = 'folderTreeTextBox';
			textBox.value = obj.innerHTML;
			obj.parentNode.insertBefore(textBox,obj);
			textBox.id = 'textBox' + obj.parentNode.id.replace(/[^0-9]/gi,'');
			textBox.onblur = this.__saveTextBoxChanges;
			textBox.onkeydown = this.__renameCheckKeyCode;
			this.__renameEnableTextBox(obj);
		}
		,
		__renameEnableTextBox : function(obj)
		{
			JSTreeObj.renameState = JSTreeObj.RENAME_STATE_BEGIN;
			obj.style.visibility = 'hidden';
			obj.previousSibling.value = obj.innerHTML;
			obj.previousSibling.style.display = 'inline';
			obj.previousSibling.select();
		}
		,
		renameItem : function(obj1,obj2)
		{
			currentItemToEdit = obj2.parentNode;	// Reference to the <li> tag.
			if(!obj2.previousSibling || obj2.previousSibling.tagName.toLowerCase()!='input'){
				this.__createTextBox(obj2);
			}else{
				this.__renameEnableTextBox(obj2);
			}
			this.helpObj.innerHTML = obj2.innerHTML;

		}
		,
		drawObject : function(obj1,obj2)
		{
			addObj(obj2.parentNode.id, obj2.parentNode.groupCategory, obj2.parentNode.serviceImage, obj2.parentNode.serviceTitle, null, null, null, null);
		}
		,
		reloadIFD : function(obj1,obj2)
		{
			reloadIfdOnCanvas(obj2.parentNode.id, obj2.parentNode.itemText);
		}
		,
		initTree : function()
		{
			JSTreeObj = this;
			//JSTreeObj.createDropIndicator();
			//document.documentElement.onselectstart = JSTreeObj.cancelSelectionEvent;
			//document.documentElement.ondragstart = JSTreeObj.cancelEvent;
			document.documentElement.onmousedown = JSTreeObj.removeHighlight;

			/* Creating help object for storage of values */
			//this.helpObj = document.createElement('DIV');
			//this.helpObj.style.display = 'none';
			//document.body.appendChild(this.helpObj);
			//document.getElementById("tree_div").appendChild(this.helpObj);

			/* Create context menu */
			try{
				window.refToDragDropTree = this;

				this.contextMenu = new DHTMLGoodies_contextMenu();
				this.contextMenu.setWidth(220);
				referenceToDHTMLSuiteContextMenu = this.contextMenu;
			}catch(e){

			}

			var dhtmlgoodies_tree = document.getElementById(this.idOfTree);
			var menuItems = dhtmlgoodies_tree.getElementsByTagName('LI');	// Get an array of all menu items
			
			menuItems[0].itemCategory = "root"
			var aTag = menuItems[0].getElementsByTagName('A')[0];
			
			var img = document.createElement('IMG');
			img.style.visibility = "hidden";
			img.src = this.imageFolder + this.plusImage;
			img.onclick = JSTreeObj.showHideNode;
			menuItems[0].insertBefore(img, aTag);
			
			var folderImg = document.createElement('IMG');
			folderImg.src = this.imageFolder + this.folderImage;
			menuItems[0].insertBefore(folderImg, aTag);

			if(this.contextMenu){
				try {
					var menuModel = new DHTMLGoodies_menuModel();
							//addItem(id,itemText,itemIcon,url,parentId,jsFunction)
					menuModel.addItem(1,'Add New System','','',false,'JSTreeObj.addNewItem');
					menuModel.addItem(2,'Refresh Sub List','','',false,'JSTreeObj.refreshItem');
					aTag.ondblclick = function () { JSTreeObj.addNewItem(null, aTag); }
					menuModel.init();
				}catch(e){
	
				}
	
				this.contextMenu.attachToElement(aTag, false, menuModel);
			}
			
			this.addEvent(aTag, 'contextmenu', this.highlightItem);

			this.__loadSubItem("root", "ucubeTree");

			//document.documentElement.onmousemove = JSTreeObj.moveDragableNodes;
			//document.documentElement.onmouseup = JSTreeObj.dropDragableNodes;
		}
		,
		__addAdditionalRequestParameters : function(ajax, parameters)
		{
			for (var parameter in parameters) {
				ajax.setVar(parameter, parameters[parameter]);
			}
		}
	}
