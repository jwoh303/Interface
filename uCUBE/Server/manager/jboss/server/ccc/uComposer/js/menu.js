<!--
isWaiting='false';
var timer='';
var mnu1='mnu1';
var mnu2='mnu2';
var mnu3='mnu3';
var mnu4='mnu4';
var mnu5='mnu5';
var default_mnu='';


if (document.images) 
{
	var normal_img1 = new Image();
	normal_img1.src ="../img/mnu_normal01.gif";
	var normal_img2 = new Image();
	normal_img2.src ="../img/mnu_normal02.gif";
	var normal_img3 = new Image();
	normal_img3.src ="../img/mnu_normal03.gif";
	var normal_img4 = new Image();
	normal_img4.src ="../img/mnu_normal04.gif";
	var normal_img5 = new Image();
	normal_img5.src ="../img/mnu_normal05.gif";
	
	var high_img1 = new Image();
	high_img1.src ="../img/mnu_hightlight01.gif";
	var high_img2 = new Image();
	high_img2.src ="../img/mnu_hightlight02.gif";
	var high_img3 = new Image();
	high_img3.src ="../img/mnu_hightlight03.gif";
	var high_img4 = new Image();
	high_img4.src ="../img/mnu_hightlight04.gif";
	var high_img5 = new Image();
	high_img5.src ="../img/mnu_hightlight05.gif";
}
	
function setDefaultMenu()
{
	
	if(document.forms[0].action == "/uComposer/eventAudit.do")
	{
		default_mnu = mnu1;
	}
	
	if(document.forms[0].action == "/uComposer/historyEventView.do" || document.forms[0].action =="/uComposer/historyDetailView.do")
	{
		default_mnu = mnu2;
	}
	
	if(document.forms[0].action == "/uComposer/queueMonitor.do" ||document.forms[0].action == "/uComposer/serviceStatusMonitor.do")
	{
		default_mnu = mnu3;
	}
	if(document.forms[0].action == "/uComposer/interfaceList.do")
	{
		default_mnu = mnu4;
	}
	if(document.forms[0].action == "/uComposer/interfaceGenerator.do" ||document.forms[0].action == "/uComposer/interfaceManager.do"|| document.forms[0].action == "/uComposer/userManager.do")
	{
		default_mnu = mnu5;
	}	
		
	hightlightImage(default_mnu);
	
}
function displayLink(num)
{  

    	if(num == "mnu1" ) sublink.innerHTML=	'<div onMouseOver="if(timer)clearTimeout(timer)" onMouseOut=timer=setTimeout("normalImage(default_mnu)",3000)> \
    						<a href="/uComposer/eventAudit.do">Hourly Statistical Data</a></div>';
    						
        if(num == "mnu2" ) sublink.innerHTML=	'<div onMouseOver="if(timer)clearTimeout(timer)" onMouseOut=timer=setTimeout("normalImage(default_mnu)",3000)> \
						 <a href="/uComposer/historyEventView.do">History Event View</a> | \
						<a href="/uComposer/historyDetailView.do">Detail Event View</a></div>';
						
    	if(num == "mnu3" ) sublink.innerHTML=	'<div onMouseOver="if(timer)clearTimeout(timer)" onMouseOut=timer=setTimeout("normalImage(default_mnu)",3000)> \
						<a href="/uComposer/queueMonitor.do">Queue Monitor</a> | \
						<a href="/uComposer/serviceStatusMonitor.do">Service Status Monitor</a></div>';
						
    	if(num == "mnu4" ) sublink.innerHTML=	'<div onMouseOver="if(timer)clearTimeout(timer)" onMouseOut=timer=setTimeout("normalImage(default_mnu)",3000)> \
	 					<a href="/uComposer/interfaceList.do">Interface Inquery</a></div>';
	 					
    	if(num == "mnu5" ) sublink.innerHTML=	'<div onMouseOver="if(timer)clearTimeout(timer)" onMouseOut=timer=setTimeout("normalImage(default_mnu)",3000)> \
    						<a href="/uComposer/interfaceManager.do">Interface Manager</a> | \
    						<a href="/uComposer/interfaceGenerator.do">Interface Generation</a> | \
    						<a href="/uComposer/userManager.do">User Manager</a></div>';

	
	sublink.style.pixelLeft= "210";
	var max = num.substring(3,4);

	for(i=1; i < max; i++)
	{
		var obName = "mnu" + i ;
		sublink.style.pixelLeft = sublink.style.pixelLeft + document[obName].width;

	}
	sublink.style.pixelLeft = sublink.style.pixelLeft - 115;
	//alert(sublink.style.pixelLeft);
	
	sublink.style.visibility = "hidden";
	sublink.filters.item(0).transition = 12;
	sublink.filters.item(0).apply();
	sublink.style.visibility = "visible";
	sublink.filters.item(0).play();
		
	

}

function hightlightImage(num)
{
    clearImage();
    if(num == "mnu1" ) document["mnu1"].src = high_img1.src;
    if(num == "mnu2" ) document["mnu2"].src = high_img2.src;
    if(num == "mnu3" ) document["mnu3"].src = high_img3.src;
    if(num == "mnu4" ) document["mnu4"].src = high_img4.src;
    if(num == "mnu5" ) document["mnu5"].src = high_img5.src;
    displayLink(num);
}


function normalImage(num)
{

    clearImage();
    hightlightImage(num);

}

function clearImage()
{
    document["mnu1"].src = normal_img1.src;    
    document["mnu2"].src = normal_img2.src;
    document["mnu3"].src = normal_img3.src;
    document["mnu4"].src = normal_img4.src;
    document["mnu5"].src = normal_img5.src;
}
function mouseOver(num)
{
	if(timer)clearTimeout(timer);
	hightlightImage(num);
}

function checkDigit(count)
{
	var regexp = /^[0-9]+$/ig ; 
	//regexp=new RegExp('^[0-9]+$','ig');
	if(count.search(regexp) < 0)
	{
		return false;
	}else
	{
		return true;
	}
}

function openHelp() {
	if( document.forms[0].action == "/uComposer/historyEventView.do" )
	{
		nWindow = window.open('/uComposer/help/historyEventView.htm', 'SA', 'toolbar=no,width=570,height=650,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
	}else if( document.forms[0].action == "/uComposer/historyDetailView.do" )
	{
		nWindow = window.open('/uComposer/help/historyDetailView.htm', 'SA', 'toolbar=no,width=570,height=650,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
	}else if( document.forms[0].action == "/uComposer/eventAudit.do" )
	{
		nWindow = window.open('/uComposer/help/eventAudit.htm', 'SA', 'toolbar=no,width=570,height=650,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
	}else if( document.forms[0].action == "/uComposer/queueMonitor.do" )
	{
		nWindow = window.open('/uComposer/help/queueMonitor.htm', 'SA', 'toolbar=no,width=570,height=650,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
	}else if( document.forms[0].action == "/uComposer/serviceStatusMonitor.do" )
	{
		nWindow = window.open('/uComposer/help/serviceStatusMonitor.htm', 'SA', 'toolbar=no,width=570,height=650,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
	}else if( document.forms[0].action == "/uComposer/interfaceManager.do" )
	{
		nWindow = window.open('/uComposer/help/interfaceManager.htm', 'SA', 'toolbar=no,width=570,height=650,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
	}else if( document.forms[0].action == "/uComposer/userManager.do" )
	{
		nWindow = window.open('/uComposer/help/userManager.htm', 'SA', 'toolbar=no,width=570,height=650,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
	}else if( document.forms[0].action == "/uComposer/interfaceGenerator.do" )
	{
		nWindow = window.open('/uComposer/help/interfaceGeneration.htm', 'SA', 'toolbar=no,width=570,height=650,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
	}else if( document.forms[0].action == "/uComposer/interfaceList.do" )
	{
		nWindow = window.open('/uComposer/help/interfaceInquery.htm', 'SA', 'toolbar=no,width=570,height=650,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
	}else
	{
		nWindow = window.open('/uComposer/help/interfaceGeneration.htm', 'SA', 'toolbar=no,width=570,height=650,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
	}		
	
	nWindow.focus();
	
}

function openWin(val) {
	if( val == 'firstConnect' ){
		nWindow = window.open('/home/notice/firstConnect.html', 'firstConnect', 'toolbar=no,width=780,height=500,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
		nWindow.focus();
	}
	
}

-->
