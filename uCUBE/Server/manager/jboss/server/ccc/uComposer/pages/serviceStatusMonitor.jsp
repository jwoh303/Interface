<%@ include file="/pages/form/jspheader.jsp"%>
<%@ include file="/pages/form/loginCheck.jsp"%>
<%@ page contentType="text/html;charset=UTF-8"%>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>

<%@ page import="com.posdata.glue.dao.vo.PosRowSet,
					com.posdata.glue.context.PosContext,
					com.posdata.glue.dao.vo.PosRow,
					com.posdata.glue.util.log.PosLog" %>
<%@ page import = "com.posdata.eai.manager.vo.*, 
                   com.posdata.eai.manager.util.JITPage" %>
<%@ page import = "com.posdata.glue.dao.vo.*,
                   com.posdata.eai.manager.util.*"%>					

<%@ page import = "java.util.*" %>

<%
	PosContext ctx = (PosContext)request.getAttribute( "PosContext" );

	// 현재날짜
	java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	java.text.SimpleDateFormat dateFormat1 = new java.text.SimpleDateFormat("yyyy-MM-dd");
	String currentDate = null;
	if (request.getParameter("date") == null) {
		currentDate = dateFormat1.format(new java.util.Date());
	} else {
		currentDate = (String) request.getParameter("date");
	}
    
	List objVal = new ArrayList();
	List sectionList = new ArrayList();

	try {
		if(ctx!=null && ctx.get("serviceStatusMonitor")!=null) {
			objVal = (ArrayList)ctx.get("serviceStatusMonitor");
		}
	}
	catch(Exception e) {
		out.println(e);
	}
				
	try {
		if(ctx!=null && ctx.get("sectionList")!=null) {
			sectionList = (ArrayList)ctx.get("sectionList");
		}
	}
	catch(Exception e) {
		out.println(e);
	}
	
	int totalCount = objVal==null?0:objVal.size();
%>

<html>
<head>

<%@ include file="/pages/form/htmlheader.jsp"%>

<script language="javascript" src="js/selectAll.js"></script>
<script type="text/javascript">

function execute() 
{
	//alert("execute() " + isWaiting);
	//Retry 방지 start
	if( isWaiting == 'true' )
	{
		alert("조회 중 입니다!");
		return;
    }
    isWaiting = 'true';
    
    //Retry 방지 end
	
	//업무 구분이 ALL 일경우에는 서비스 이름 혹은 링크이름에 값이 있어야한다 없을 경우 ALERT
//	if(document.forms[0].section.value == "ALL" && document.forms[0].serviceName.value == "" && document.forms[0].linkName.value == "" && document.forms[0].hostName.value == "")
//	{
//		alert("업무 구분에 ALL을 선택하였을 경우 서비스 이름 또는 링크이름은 필수 입력값입니다.");
//		isWaiting = 'false';
//		return;
//	}
    	
	checkPeriod(document.forms[0].refreshTime.value);
	//일반 조회
	//searching();
    //document.forms[0].submit();
    //Ajax
    getServerData();
}
function checkPeriod(num)
{
	
	if (checkDigit(num) == false || num < 10)
	{
		document.forms[0].refreshTime.value = 10;
		alert("최소 값은 10 입니다");
		return 10;
	}else	{
		return num;
	}
}
function saveClick(event)
{
	var objCheck = document.all.sequence;
	if(objCheck==null) return;
	
	var message = "";
	if(event=="edit") message = "정말로 수정하시겠습니까?";
	else if (event=="delete") message = "정말로 삭제하시겠습니까?";
	else {
		alert("잘못된 요청정보입니다."); return;
	}
	
	var selectcount = 0;
	if( objCheck.length == null) {
		if(objCheck.checked) selectcount++;
	} else {
		for(idx=0;idx<objCheck.length;idx++) {
			if( objCheck[idx].checked ) { selectcount++; break; }
		}
	}
	if( selectcount == 0 ) {
		if (event=="edit") alert("수정할 항목을 선택하세요"); 
		else alert("삭제할 항목을 선택하세요"); 
	}
	else {
		if(confirm(message)) {
			document.forms[0].actionFlag.value = event;
			document.forms[0].submit();
		}
	}
}
</script>
</head>

<body topmargin=0 leftmargin=0 onLoad="MM_preloadImages('img/ucube_img04_menu_over.gif','img/ucube_img05_menu_over.gif','img/ucube_img06_menu_over.gif','img/ucube_img07_menu_over.gif','img/ucube_img08_menu_over.gif','img/clock.gif')">
<form method="post" action="serviceStatusMonitor.do">
<input type="hidden" name="ServiceName" value="serviceStatusMonitor-service" />
<input type="hidden" name="find.x" value="1" />


<div style="display:none"><img src='img/clock.gif'></div>
<!-- 풍선도움말 -->
<div id="balloonHint" style="display:none">
<table border="0" cellspacing="0" cellpadding="3" bgcolor="#FFFFCC" style="border:1px solid #CC3300">
<tr><td style="font-size:12px">도움말</td></tr>
<tr><td style="font-size:12px">{{hint}}</td></tr>
</table>
</div>

<div id="dhtml" style="background:#FFFFFF;margin:5; margin-top:2; display:none; position:absolute; z-index:99; overflow-y: auto;"></div>
<script language="javascript">balloonHint("balloonHint")</script>
<%@ include file="/pages/header.jsp"%>

<input type="hidden" name="actionFlag" value="">
<input type="hidden" name="asyncRefresh" value="">

		<table width="980" border="0" cellspacing="0" cellpadding="0">
			<tr bgcolor=white> 
				<td height=25> 
					<table width="980" height="25" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<img src="img/comm_img02_blank.gif" width="5" height="10"><img src="img/comm_img03_ic.gif" width="11" height="10"><span class="bluetit"><img src="img/comm_img02_blank.gif" width="5" height="10"></span>
								<span class="tit01">Service Status Monitor</span>
							</td>
						</tr>
					</table>
				</td>
			</tr>		
			<tr><!--tr5 start --> 
        		<td align=center bgcolor=white>
        			<!--검색조건-->
        			<table width="980"  border="1" cellpadding="2" cellspacing="0" bordercolor="#FFFFFF" bgcolor="#FFFFFF" >
	        			<tr> 
	        				<td height="25" bordercolor="999999" bgcolor="F8F3E8">            
					        	<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="search">
					            	<tr>
					              		<td width="%">
					              			<img src="img/comm_img02_blank.gif" width="%"  height="10">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>업부구분 : </b>
					                  		<select name="section" Class="adf">
												<option value="STOP">STOP</option>
												<option value="ALL">ALL</option>
										    </select>
											<img src="img/comm_img02_blank.gif" width="%" height="10"> 
										</td>
										<td width="%">
					              			<img src="img/comm_img02_blank.gif" width="%"  height="10">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>시스템 이름 : </b>
					                  		<input type="text" size="10" maxlength="8" name="hostName" Class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" />
											<img src="img/comm_img02_blank.gif" width="%"  height="10"> 
										</td>
										<td width="%">
					              			<img src="img/comm_img02_blank.gif" width="%"  height="10">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>서비스 이름 : </b>
					                  		<input type="text" size="15" maxlength="12" name="serviceName" Class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" />
											<img src="img/comm_img02_blank.gif" width="%" height="10"> 
										</td>
										<td width="%">
					              		    <img src="img/comm_img02_blank.gif" width="%" height="10">
										    <img src="img/comm_img06_ic.gif" width="10" height="3"> <b>링크 이름 : </b>
						    	            <input type="text" size="10" maxlength="8" name="linkName" Class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" />
						    	            <img src="img/comm_img02_blank.gif" width="%" height="10"> 
						    	        </td>
										<td width="%">
					              			<img src="img/comm_img02_blank.gif" width="%"  height="10">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>갱신 주기 : </b>
					                  		<input type="text" size="5" maxlength="5" name="refreshTime" value="60" Class="adb1" />
											<img src="img/comm_img02_blank.gif" width="%"  height="10"> 
											<input type="hidden" name="formName" value="<%=request.getParameter("refreshTime")%>" />
										</td>
					              		<td height="25" valign="middle" align="right">
					              			<img src="img/comm_img07_but.gif" width="55" height="21" style="cursor:hand" align="absmiddle" onclick="execute()">
					              			<img src="img/comm_img08_but.gif" width="55" height="21" style="cursor:hand" align="absmiddle" onclick="openHelp()">
					              			<img src="img/comm_img02_blank.gif" width="5" height="10"> 
					              		</td>
					            	</tr>
					          	</table>	  
					       	</td>
	        			</tr>
	        		</table>
	        	</td>
	        </tr>  
			<tr bgcolor=white>
				<td height=25>
					<table border=0 width=100%>
						<tr>
							<td width=5> </td>
							<td width=% valign=bottom> 
								<img src="img/icon_critical.gif"> Down
								<img src="img/icon_error.gif"> Error
								<img src="img/icon_normal.gif"> Normality
							</td>
							<td align=right width=300 valign=bottom><div id="totalCount"></div></td>
							
						</tr>
					</table>
				</td> 	
			</tr>			        		
		</table>
		<!-- data -->
   		<table width="960" height=400 border=0 cellpadding="0" cellspacing="0" bordercolorlight=FFFFFF  bordercolordark=FFFFFF>
			<tr>
				<td width=5> </td>
				<td align=center valign=top>
					<table width=960 border=0 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF>
		    			<tr>
		    				<td height=400 width=100% valign=top>
		    					<DIV id="topLine" style="width:980px;overflow:hidden;">
								<table width="960" border="1" cellpadding="1" cellspacing="0" bordercolor="Black" bordercolorlight="#626262" bordercolordark="White" class="tblcb1" valign="TOP" style="table-layout:fixed">
									<TR HEIGHT=40 CLASS=tbldb> 
										
										<td width=100>시스템 이름</td>
										<td width=200>서비스 이름</td>
										<td width=160>링크 이름</td>
										<td width=%>설 명</td>
										<td width=100>상 태</td>
										<td width=150>마지막 접속시간</td>
									</tr>
								</table>
								</div>
								<!--nom-->
								<div id="dataTable" style="width:998px;height:340px;overflow-y:scroll;overflow-x:hidden;visibility:hidden;filter:revealTrans(duration=1);" onscroll="scrollY()"></div>
								<div id="mainDisplay" style="width:998px;height:340px;overflow-y:scroll;overflow-x:hidden;display:none;" onscroll="scrollY()">
								<table width=980 border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF style="table-layout:fixed">											
<%	if( objVal != null  && objVal.size() > 0) 
	{
		String last_data = null; String curr_data = null;
		boolean samedata = false;
		String cssClass = "tblcg";
		
		Object preValue = null;					
		Hashtable hashtable = new Hashtable();		
		int currIndex = 0;
		int count = 0;
		int[] objVaArray = new int[objVal.size()];
		
		for(int i=0; i<objVal.size(); i++)
		{
			ServiceStatusMonitorVO vo = (ServiceStatusMonitorVO)objVal.get(i);
			Object key = vo.getServiceName();
			if(!key.equals(preValue))
			{
				
				objVaArray[currIndex] = count;
				currIndex = i;
				count = 1;
			}else
			{
				count++;
			}
			preValue = key;
		}
		objVaArray[currIndex] = count;
		
		for(int i=0; i<objVal.size(); i++) {
			ServiceStatusMonitorVO vo = (ServiceStatusMonitorVO)objVal.get(i);
			//curr_data = vo.getServiceName() + ":" + vo.getHostName();
			curr_data = vo.getHostName();
			if( i==0 ) last_data = curr_data;
			
			// 같은 IF ID를 사용할 경우 다음 라인에서 출력하지 않음
			if(i!=0 && last_data.equals(curr_data)) samedata = true;
			else {
				samedata = false;
				cssClass = "tblcg".equals(cssClass)==true?"tblcw":"tblcg";
			}
			
			// 이미지
			String status = vo.getStatus();
			String targetImg = "";
			long currentTime = System.currentTimeMillis();
			String timestamp = vo.getLtime();
			
			Date myDate = null;
			try {
				if (timestamp != null) {
					myDate = dateFormat.parse(timestamp);
				}
			} catch (java.text.ParseException e) {}
	
			long diff = currentTime - myDate.getTime();
			// Normal
			if ("NORMAL".equals(status))
			{
				targetImg = "<img src=\"img/icon_normal.gif\" />";
			}
			// ERROR
			else if ("ERROR".equals(status))
			{
				targetImg = "<img src=\"img/icon_error.gif\" />";
			}
			else
			{
				targetImg = "<img src=\"img/icon_critical.gif\" />";
			}
			// 이미지 끝
%>

									<tr class=<%=cssClass%>>
										<!--<td width="70"><input type='checkbox' name='sequence' id='<%="l"+i%>' value='<%=vo.getSeq()%>'/></td>-->
										
<%
			if(objVaArray[i] != 0)
			{
%>										<td width=100 ROWSPAN=<%=objVaArray[i]%> ><%=samedata==true?"&nbsp;":vo.getHostName()%></td>
										
										
<%
			}
%>
										<td width=200><%=vo.getServiceName()%> </td>
										<td width=160><%=vo.getLinkName()%></td>
										<td width="%" align="left"><%=vo.getQDescription()==null?"&nbsp":vo.getQDescription()%></td>
										<td width=100><%=targetImg%></td>
										<td width=150><%=vo.getLtime()%></td>
									</tr>			
<%			last_data = curr_data;		
		}				
	}else
	{
%>	
									<tr height=21><td colspan=7 align=center>검색된 결과가 없습니다.</td></tr>
<%									
	}
%>

								</table>
								</DIV>		    					  				
		    				</td>
						</tr>
    				</table>
    			</td>
    		</tr>
    	</table>

<script type="text/javascript">

function getServerData() 
{

  // Obtain an XMLHttpRequest instance
  var req = newXMLHttpRequest();
  

  // Set the handler function to receive callback notifications
  // from the request object
  var handlerFunction = getReadyStateHandler(req, displayDataTable);
  req.onreadystatechange = handlerFunction;
  
  // Open an HTTP POST connection to the shopping cart servlet.
  // Third parameter specifies request is asynchronous.
  req.open("POST", "/uComposer/PosAjaxAction.do?ServiceName=serviceStatusMonitor-service&find.x=1", true);

  // Specify that the body of the request contains form data
  req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
  //req.send("section=M10");
  req.send("asyncRefresh=YES&section=" + document.forms[0].section.value + "&serviceName=" + document.forms[0].serviceName.value+ "&hostName=" + document.forms[0].hostName.value+"&linkName="+document.forms[0].linkName.value);
}

/*
 * Returns a new XMLHttpRequest object, or false if this browser
 * doesn't support it
 */
function newXMLHttpRequest() {

  var xmlreq = false;

  if (window.XMLHttpRequest) {

    // Create XMLHttpRequest object in non-Microsoft browsers
    xmlreq = new XMLHttpRequest();

  } else if (window.ActiveXObject) {

    // Create XMLHttpRequest via MS ActiveX
    try {
      // Try to create XMLHttpRequest in later versions
      // of Internet Explorer

      xmlreq = new ActiveXObject("Msxml2.XMLHTTP");

    } catch (e1) {

      // Failed to create required ActiveXObject

      try {
        // Try version supported by older versions
        // of Internet Explorer

        xmlreq = new ActiveXObject("Microsoft.XMLHTTP");

      } catch (e2) {

        // Unable to create an XMLHttpRequest with ActiveX
      }
    }
  }

  return xmlreq;
}


/*
 * Returns a function that waits for the specified XMLHttpRequest
 * to complete, then passes its XML response
 * to the given handler function.
 * req - The XMLHttpRequest whose state is changing
 * responseXmlHandler - Function to pass the XML response to
 */
function getReadyStateHandler(req, displayDataTable) {

  // Return an anonymous function that listens to the 
  // XMLHttpRequest instance
  return function () {
    //alert(req.readyState);
    // If the request's status is "complete"
    if (req.readyState == 4) {
      
      // Check that a successful server response was received
      if (req.status == 200) {

        // Pass the XML payload of the response to the 
        // handler function
       // alert(req.status);
        displayDataTable(req.responseXML);
        
      } else {

        // An HTTP problem has occurred
        alert("HTTP error: "+req.status);
      }
    }
  }
}


function displayDataTable(serviceStatus)
{
	//alert(serviceStatus);
	//serviceStatus = getElement();
	
	adapterArray = serviceStatus.getElementsByTagName('ADAPTER');
	            	
	//totalCount.style.visibility = "hidden";
	//if( adapterArray != null  && adapterArray.length > 0) 
	//{	
	//	totalCount.innerHTML =  "<table><tr><td align=right width=300 valign=bottom>총" + adapterArray.length +  "건이 조회되었습니다</td></tr></table>";
	//}else
	//{
	//	totalCount.innerHTML =  "<table><tr><td align=right width=300 valign=bottom>&nbsp;&nbsp;</td></tr></table>";
	//}
	//totalCount.style.visibility = "visible";
	
	
	var totalCoount = document.getElementById("totalCount");
	if (adapterArray.length > 0)
	{
		totalCount.innerHTML = "총 " + adapterArray.length+ "건이 조회되었습니다";
	}else
	{
		totalCount.innerHTML = "&nbsp;&nbsp;";
	}
	
	var mainTable	= '<table width=960 border=1 cellpadding=1 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF style="table-layout:fixed">';	
	if( adapterArray != null  && adapterArray.length > 0) 
	{
	
			
		var cssClass = "tblcg";
		var samedata;
		var targetImg;
		
		var objVaArray = new Array(adapterArray.length);
		
		var preValue;					
		//Hashtable hashtable = new Hashtable();		
		var currIndex = 0;
		var count = 1;
		
		
		for (var i = 0 ; i < adapterArray.length ; i++) 
		{
			var adapter = adapterArray[i];
			var key = adapter.getAttribute('SYSTEM_NAME');
			if( preValue != key)
			{
				
				objVaArray[currIndex] = count;
				currIndex = i;
				count = 1;
			}else
			{
				count++;
			}
			preValue = key;
		}
		objVaArray[currIndex] = count;
		
		for (var i = 0 ; i < adapterArray.length ; i++) 
		{
			var adapter = adapterArray[i];
			//var curr_data = adapter.getAttribute('ADAPTER_NAME') + ":" + adapter.getAttribute('SYSTEM_NAME');			
			var curr_data = adapter.getAttribute('SYSTEM_NAME');
			if( i==0 ) last_data = curr_data;
			// 같은 IF ID를 사용할 경우 다음 라인에서 출력하지 않음
			if( i != 0 && last_data == curr_data) 
			{
				samedata = true;
			}else {
				samedata = false;
				cssClass = ("tblcg" == cssClass?"tblcw":"tblcg");
			}
			last_data = curr_data;	
			// 이미지
			var status = adapter.getAttribute('STATUS');			
	
			// Normal
			if ("NORMAL" == status)
			{
				targetImg = "<img src=\"img/icon_normal.gif\" />";
			}
			// ERROR
			else if ("ERROR" == status)
			{
				targetImg = "<img src=\"img/icon_error.gif\" />";
			}
			else
			{
				targetImg = "<img src=\"img/icon_critical.gif\" />";
			}		
			
			mainTable 	= mainTable + '<tr class=' + cssClass + '>';	
			
			if(objVaArray[i] != null)
			{
				//alert("\"" + objVaArray[i]+ "\"");	
				mainTable	= mainTable + '<td width=100 ROWSPAN='+ objVaArray[i] + ' >'+ adapter.getAttribute('SYSTEM_NAME')+'</td>';
				
				
			}			
			//alert(adapter.getAttribute('DESC'));
			//mainTable	= mainTable + '<td width=200 >'+ adapter.getAttribute('ADAPTER_NAME')+'</td>';
			//mainTable	= mainTable + '<td width=100 >'+ adapter.getAttribute('SYSTEM_NAME')+'</td>';
			//mainTable	= mainTable + '<td width=200 ROWSPAN='+ objVaArray[i] + ' >'+ adapter.getAttribute('ADAPTER_NAME')+'</td>';
			mainTable	= mainTable + '<td width=200>'+ adapter.getAttribute('ADAPTER_NAME')+'</td>';
			mainTable	= mainTable + '<td width=160>'+ adapter.getAttribute('LINK_NAME')+'</td>';
			mainTable	= mainTable + '<td width=%>'+ (adapter.getAttribute('DESC')==""?"&nbsp;":adapter.getAttribute('DESC')) +'</td>';
			mainTable	= mainTable + '<td width=100>'+ targetImg + '</td>';
			mainTable	= mainTable + '<td width=150>'+ adapter.getAttribute('LAST_ACCESS_TIME')+'</td>';
			mainTable	= mainTable + '</tr>';
											
		}
		
		//mainDisplay.style.visibility = "hidden";

	}else
	{
		mainTable = mainTable + "<tr height=21><td colspan=7 align=center>검색된 결과가 없습니다.</td></tr>" ;
	}
	
	mainTable = mainTable + '</table>';
	
	
	//dataTable.filters.item(0).transition =(new Date().getSeconds() %15);
	dataTable.filters.item(0).transition = 44;
	dataTable.filters.item(0).apply();
	dataTable.style.visibility = "hidden";
	dataTable.filters.item(0).play();
	//dataTable.style.visibility = "hidden";	
	dataTable.innerHTML = "" + mainTable;             	
	dataTable.style.visibility = "visible";
	
	if(clock != 0)
	{
		//alert(" clock " + clock);
		window.clearTimeout(clock);
		clock = 0;
	}
	clock = window.setTimeout('execute()',1000*eval(checkPeriod(document.forms[0].refreshTime.value)));
	
	//Prevent Retry
	isWaiting = 'false';
	
	
}
function getElement()
{
	//TEST용
	var serviceStatus = document.createElement('SERVICE_STATUS');
	
	var adapter = document.createElement('ADAPTER');
	serviceStatus.appendChild(adapter);
	
	adapter.setAttribute('ADAPTER_NAME','aaaaaa');
	adapter.setAttribute('SYSTEM_NAME','bbbbb');
	adapter.setAttribute('LINK_NAME','ccccc');
	adapter.setAttribute('DESC','ddddd');
	adapter.setAttribute('STATUS','NORMAL');
	adapter.setAttribute('LAST_ACCESS_TIME','fffff');
	
	adapter = document.createElement('ADAPTER');
	serviceStatus.appendChild(adapter);
	
	adapter.setAttribute('ADAPTER_NAME','aaaaaa');
	adapter.setAttribute('SYSTEM_NAME','bbbbb');
	adapter.setAttribute('LINK_NAME','ccccc');
	adapter.setAttribute('DESC','ddddd');
	adapter.setAttribute('STATUS','NORMAL');
	adapter.setAttribute('LAST_ACCESS_TIME','fffff');
	
	adapter = document.createElement('ADAPTER');
	serviceStatus.appendChild(adapter);
	
	adapter.setAttribute('ADAPTER_NAME','fffff');
	adapter.setAttribute('SYSTEM_NAME','bbbbb');
	adapter.setAttribute('LINK_NAME','ccccc');
	adapter.setAttribute('DESC','ddddd');
	adapter.setAttribute('STATUS','NORMAL');
	adapter.setAttribute('LAST_ACCESS_TIME','fffff');
	
	
	adapter = document.createElement('ADAPTER');
	serviceStatus.appendChild(adapter);
	
	adapter.setAttribute('ADAPTER_NAME','fffff');
	adapter.setAttribute('SYSTEM_NAME','bbbbb');
	adapter.setAttribute('LINK_NAME','ccccc');
	adapter.setAttribute('DESC','ddddd');
	adapter.setAttribute('STATUS','NORMAL');
	adapter.setAttribute('LAST_ACCESS_TIME','fffff');
	
	
	adapter = document.createElement('ADAPTER');
	serviceStatus.appendChild(adapter);
	
	adapter.setAttribute('ADAPTER_NAME','fffff');
	adapter.setAttribute('SYSTEM_NAME','bbbbb');
	adapter.setAttribute('LINK_NAME','ccccc');
	adapter.setAttribute('DESC','ddddd');
	adapter.setAttribute('STATUS','NORMAL');
	adapter.setAttribute('LAST_ACCESS_TIME','fffff');
	//TEST용
	return serviceStatus;
}

</script>
<script>
<!--
function scrollX() {
	document.all.mainDisplay.scrollLeft = document.all.bottomLine.scrollLeft;
	document.all.topLine.scrollLeft = document.all.bottomLine.scrollLeft;
}
function scrollY() {
	//document.all.leftDisplay.scrollTop = document.all.mainDisplay.scrollTop;
}
clock = window.setTimeout('execute()',1000*eval(checkPeriod(document.forms[0].refreshTime.value)));
//-->
</script>	
<%@ include file="/pages/footer.jsp"%>
</form>
</body>
</html>
