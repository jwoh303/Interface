<script language="javascript" type="text/javascript" src="/uComposer/js/common.js"></script>
<script language="javascript" type="text/javascript" src="/uComposer/js/messageTicker.js"></script>
<script language="javascript" type="text/javascript" src="/uComposer/js/Calendar.js"></script>
<script language="javascript" type="text/javascript" src="/uComposer/js/dropdown.js"></script>
<script language="javascript" type="text/javascript" src="/uComposer/js/link.js"></script>
<script language="javascript" type="text/javascript" src="/uComposer/js/searching.js"></script>
<script language="javascript" type="text/javascript" src="/uComposer/js/balloon.js"></script>
<script language="javascript" type="text/javascript" src="/uComposer/js/menu.js"></script>
<script language="javascript" type="text/javascript" src="/uComposer/js/showCalendar.js"></script>

<title>u-CUBE 2.0</title>
<%@ page contentType="text/html;charset=UTF-8"%>
<%
	// 
	java.text.SimpleDateFormat simpleAateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String now = simpleAateFormat.format(new java.util.Date());
%>

		<!--로고 및 상단메뉴-->
		<table width="30" height="8" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
			</tr>
		</table>

		<table width="980"  border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="392"><img src="/uComposer/img/ucube_img01_logo.gif" width="341" height="22"></td>
				<td>&nbsp;</td>
				<td width="250">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="17"><img src="/uComposer/img/ucube_img10_time.gif" width="13" height="13"></td>
							<td valign="bottom" class="tblbl">[최종조회시간 : <%=now%>] </td>
						</tr>
					</table>
				</td>
				<td width="50" align="center"><img src="/uComposer/img/ucube_img11_logout.gif" width="50" height="14" onclick="ConfirmChoice('/uComposer/login.do?event=logout',' 나가시겠습니까 ?');return false; " style="cursor:hand"></td>
				<td width="10"></td>
			</tr>
		</table>
		<!--로고 및 상단메뉴 끝-->

		<!--메인메뉴-->
		<table width="980"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="20"><img src="/uComposer/img/ucube_img02_menu.gif" width="11" height="28"></td>
				<td width="20%" background="/uComposer/img/ucube_img03_menu.gif" height="28"></td>
				<td width="110" onMouseOver="MM_swapImage('Image1','','/uComposer/img/ucube_img04_menu_over.gif',1)" onMouseOut="MM_swapImgRestore()">
					<dl class="dropdown">
						<dt id="one-ddheader" onmouseover="ddMenu('one',1)" onmouseout="ddMenu('one',-1)">
							<a href="/uComposer/eventAudit.do?ServiceName=eventAudit-service"><img src="/uComposer/img/ucube_img04_menu.gif" name="Image1" width="110" height="28" border="0" id="Image1"></a>
						</dt>
						<dd id="one-ddcontent" onmouseover="cancelHide('one')" onmouseout="ddMenu('one',-1)">
		    				<ul>
					      		<li><a href="/uComposer/eventAudit.do?ServiceName=eventAudit-service" class="underline">- Hourly Statistical Data</a></li>
		    				</ul>
		  				</dd>
					</dl> 
				</td>
				<td width="104" onMouseOver="MM_swapImage('Image2','','/uComposer/img/ucube_img05_menu_over.gif',1)" onMouseOut="MM_swapImgRestore()">
					<dl class="dropdown">
						<dt id="two-ddheader" onmouseover="ddMenu('two',1)" onmouseout="ddMenu('two',-1)">
							<a href="/uComposer/historyEventView.do?ServiceName=historyEventView-service"><img src="/uComposer/img/ucube_img05_menu.gif" name="Image2" width="104" height="28" border="0" id="Image2"></a>
						</dt>
						<dd id="two-ddcontent" onmouseover="cancelHide('two')" onmouseout="ddMenu('two',-1)">
		    				<ul>
					      		<li><a href="/uComposer/historyEventView.do?ServiceName=historyEventView-service" class="underline">- History Event View</a></li>
					      		<li><a href="/uComposer/historyDetailView.do?ServiceName=historyDetailView-service" class="underline">- Detail Event View</a></li>
		    				</ul>
		  				</dd>
					</dl> 
				</td>
				<td width="130" onMouseOver="MM_swapImage('Image3','','/uComposer/img/ucube_img06_menu_over.gif',1)" onMouseOut="MM_swapImgRestore()">
					<dl class="dropdown">
						<dt id="three-ddheader" onmouseover="ddMenu('three',1)" onmouseout="ddMenu('three',-1)">
							<a href="/uComposer/queueMonitor.do?ServiceName=queueMonitor-service"><img src="/uComposer/img/ucube_img06_menu.gif" name="Image3" width="130" height="28" border="0" id="Image3"></a>
						</dt>
						<dd id="three-ddcontent" onmouseover="cancelHide('three')" onmouseout="ddMenu('three',-1)">
		    				<ul>
					      		<li><a href="/uComposer/queueMonitor.do?ServiceName=queueMonitor-service" class="underline">- Queue Monitor</a></li>
					      		<li><a href="/uComposer/serviceStatusMonitor.do" class="underline">- Service Status Monitor</a></li>
		    				</ul>
		  				</dd>
					</dl> 
				</td>
				<td width="137" onMouseOver="MM_swapImage('Image5','','/uComposer/img/ucube_img08_menu_over.gif',1)" onMouseOut="MM_swapImgRestore()">
					<dl class="dropdown">
						<dt id="four-ddheader" onmouseover="ddMenu('four',1)" onmouseout="ddMenu('four',-1)">
							<a href="/uComposer/interfaceList.do?ServiceName=interfaceList-serivce"><img src="/uComposer/img/ucube_img08_menu.gif" name="Image5" width="137" height="28" border="0" id="Image5"></a>
						</dt>
						<dd id="four-ddcontent" onmouseover="cancelHide('four')" onmouseout="ddMenu('four',-1)">
		    				<ul>
								<li><a href="/uComposer/serviceConfigManagerAction.do?ServiceName=serviceConfigManager-service&find.x=1" class="underline">- Service Config</a></li>
					      		<!--  li><a href="/uComposer/interfaceList.do?ServiceName=interfaceList-serivce" class="underline">- Interface Inquiry</a></li>
					      		<li><a href="/uComposer/interfaceManager.do?ServiceName=interfaceManager-serivce" class="underline">- Interface Manager</a></li>
					      		<li><a href="/uComposer/interfaceGenerator.do?v" class="underline">- Interface Generator</a></li>
					      		<li><a href="/uComposer/userManager.do?ServiceName=userManager-serivc?find.x=1" class="underline">- User Manager</a></li>
					      		<li><a href="/uComposer/smsResultList.do" class="underline">- SMS Manager</a></li> -->
		    				</ul>
		  				</dd>
					</dl> 
				</td>
				<!-- td width="124" onMouseOver="MM_swapImage('Image4','','/uComposer/img/ucube_img07_menu_over.gif',1)" onMouseOut="MM_swapImgRestore()">
					<dl class="dropdown">
						<dt id="five-ddheader" onmouseover="ddMenu('five',1)" onmouseout="ddMenu('five',-1)">
							<a href="javascript:top.calluComposer()"><img src="/uComposer/img/ucube_img08_menu.gif" name="Image5" width="124" height="28" border="0" id="Image5"></a>
							<img src="/uComposer/img/ucube_img07_menu.gif" name="Image4" width="124" height="28" border="0" id="Image4">
						</dt>
						<dd id="five-ddcontent" onmouseover="cancelHide('five')" onmouseout="ddMenu('five',-1)">
							<ul>
								<li><a href="javascript:top.calluComposer()" class="underline">- uComposer</a></li>
								<li><a href="javascript:top.callDistribute()" class="underline">- Distribute</a></li>
								<li><a href="javascript:callDistributeHistory()" class="underline">- Distribute History</a></li>
								<li><a href="/uComposer/serviceConfigManagerAction.do?ServiceName=serviceConfigManager-service&find.x=1" class="underline">- Service Config</a></li>
							</ul>
						</dd>
					</dl>
				</td -->
				<td width="30%" background="/uComposer/img/ucube_img03_menu.gif">&nbsp;</td>
				<td width="27"><img src="/uComposer/img/ucube_img09_menu.gif" width="9" height="28"></td>
			</tr>
		</table>
		
<!-- 		<dl class="dropdown">
			<dt id="one-ddheader" onmouseover="ddMenu('one',1)" onmouseout="ddMenu('one',-1)">Dropdown One</dt>
				<dd id="one-ddcontent" onmouseover="cancelHide('one')" onmouseout="ddMenu('one',-1)">
			    	<ul>
			      		<li><a href="#" class="underline">Navigation Item 1</a></li>
			      		<li><a href="#" class="underline">Navigation Item 2</a></li>
			      		<li><a href="#" class="underline">Navigation Item 3</a></li>
			      		<li><a href="#" class="underline">Navigation Item 4</a></li>
			      		<li><a href="#">Navigation Item 5</a></li>
			    	</ul>
			  	</dd>
		</dl>
-->
		
		<!--메인메뉴 끝-->
		
