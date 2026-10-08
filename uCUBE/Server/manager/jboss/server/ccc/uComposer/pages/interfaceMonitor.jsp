<%@ include file="form/jspheader.jsp"%>
<%@ include file="form/loginCheck.jsp"%>
<%@ page contentType="text/html;charset=UTF-8"%>

<%
	// 현재날짜
	java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	java.text.SimpleDateFormat dateFormat1 = new java.text.SimpleDateFormat("yyyy-MM-dd");
	String currentDate = null;
	if (request.getParameter("date") == null) {
		currentDate = dateFormat1.format(new java.util.Date());
	} else {
		currentDate = (String) request.getParameter("date");
	}
	
	List objVal = (ArrayList)request.getAttribute("interfaceMonitor");
	int totalCount = objVal==null?0:objVal.size();

%>

<html:html locale="true">
<head>
<title><bean:message key="mainmenu.title" /></title>
<link rel="stylesheet" href="../css/menu.css" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@ include file="form/htmlheader.jsp"%>


<script language="javascript" src="../js/searching.js"></script>
<script language="javascript" src="../js/balloon.js"></script>
<script language="javascript" src="../js/selectAll.js"></script>
<script language="javascript" src="../js/menu.js"></script>
<script type="text/javascript">
function execute() {
	searching();
    document.forms[0].submit();
}

</script>
</head>

<body topmargin=0 leftmargin=0 onLoad="MM_preloadImages('../img/ucube_img04_menu_over.gif','../img/ucube_img05_menu_over.gif','../img/ucube_img06_menu_over.gif','../img/ucube_img07_menu_over.gif','../img/ucube_img08_menu_over.gif','../img/clock.gif')">
<html:form action="/interfaceMonitor">
<%@ include file="header.jsp"%>
<!--<div style="display:none"><img id=statusimage src='../img/clock.gif'></div>-->

<!-- 풍선도움말 -->
<div id="balloonHint" style="display:none">
<table border="0" cellspacing="0" cellpadding="3" bgcolor="#FFFFCC" style="border:1px solid #CC3300">
<tr><td style="font-size:12px">도움말</td></tr>
<tr><td style="font-size:12px">{{hint}}</td></tr>
</table>
</div>

<!--<div id="dhtml" style="background:#FFFFFF;margin:5; margin-top:2; display:none; position:absolute; z-index:99; overflow-y: auto;"></div>-->
<script language="javascript">balloonHint("balloonHint")</script>
<!--<div id="Layer1" style="position:absolute; width:400px; height:20px; z-index:1; left: 511px; top: 91px; font-size: 12px; color: #003063; font-weight: bold;">
	<a href="/uComposer/queueMonitor.do">Queue Monitor</a> | 
	<a href="/uComposer/serviceStatusMonitor.do">Service Status Monitor</a> | 
	<a href="/uComposer/interfaceMonitor.do">Interface Monitor</a>
</div>-->

<table width="1000"  border="0" cellspacing="0" cellpadding="0">
<tr> 
	<td height="23">  
		<table width="1000" border="0" cellspacing="0" cellpadding="0" align="center">
			<!--<tr>
				<td height=25> </td>
			</tr>-->
			<tr> 
				<td background="../img/m000006img.gif" ><img src="/img/m000006img.gif" width="2" height="7"></td>
			</tr>			
			<tr bgcolor=white> 
				<td height=25> 
					<table width="980" border="0" cellspacing="0" cellpadding="0" height="25">
						<tr >
							<!-- title -->
							<td width=500>&nbsp;<font size="3" color=#005DA1><b>Inteface Monitor</b></font></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr bgcolor=white> 
				<td background="../img/m000006img.gif" ><img src="/img/m000006img.gif" width="2" height="7"></td>
			</tr>
    		<tr><!--tr5 start --> 
        		<td align=center bgcolor=white>
	        		<table width="980" border="0" cellpadding="0" cellspacing="0" bordercolorlight=666666 bordercolordark=FFFFFF><!--table4 start -->
	        			<tr> 
						   	<td valing=middle width=900>
						   		&nbsp;<img src="../img/m000008img.gif" align="absmiddle"> <b>업무 구분</b>
						   		<html:select property="section" size="1" styleClass="adf">
									<html:options name="sectionList" labelName="sectionList" />
								</html:select>
									
						    	&nbsp;<img src="../img/m000008img.gif" align="absmiddle"> <b>Inteface ID</b>
						    	<html:text size="15" maxlength="12" property="ifid" styleClass="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" />
						    	
						    	&nbsp;<img src="../img/m000008img.gif" align="absmiddle"> <b>Send System</b>
						    	<html:text size="10" maxlength="10" property="sendSystem" styleClass="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" />
						    							    							    	
						    	&nbsp;<img src="../img/m000008img.gif" align="absmiddle"> <b>Recv System </b>
						    	<html:text size="10" maxlength="10" property="recvSystem" styleClass="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" />					    	
			        		</td>
			        		<td align="right"><img src="../img/m000037ico.gif" style="cursor:hand" onclick="execute()"></td>
	        			</tr>
	        		</table>  
        		</td>
        	</tr>
			<tr bgcolor=white> 
				<td background="../img/m000006img.gif" ><img src="/img/m000006img.gif" width="2" height="7"></td>
			</tr>
			<!-- total count  -->
			<tr bgcolor=white>
				<td height=25>
					<table border=0 width=100%>
						<tr>
							<td width=5> </td>
							<td width=% valign=bottom>
								<img src="../img/icon_critical.gif"> Down
								<img src="../img/icon_error.gif"> Error
								<img src="../img/icon_normal.gif"> Normality
							</td>
							<td align=right width=300 valign=bottom><%if(objVal!=null) { %>총 <%=totalCount%>건이 조회되었습니다.<% } %>&nbsp;&nbsp;</td>
						</tr>
					</table>
				</td>	
			</tr>			        		
		</table>
		<!-- data -->
   		<table width="1000" height=380 align=center border=0 cellpadding="0" cellspacing="0" bordercolorlight=FFFFFF  bordercolordark=FFFFFF>
			<tr>
				<td width=5> </td>
				<td align=center valign=top>
					<table width=980 border=0 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF>
		    			<tr>
		    				<td height=380 width=100% valign=top>
		    					<DIV id="topLine" style="width:980px;overflow:hidden;">
		    					<table width=980 border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF style="table-layout:fixed">
									<tr class=tbldb height=25>
										<td width=40>No.</td>
										<td width=%>IF ID</td>
										<td width=90>Send System</td>
										<td width=90>Send Adapter</td>
										<td width=90>Send Link</td>
										<td width=90>Send Status</td>
										<td width=90>Recv System</td>
										<td width=150>Recv Adapter</td>
										<td width=130>Recv Link</td>
										<td width=90>Recv Status</td>
									</tr>
								</table>
								</div>
								<div id="mainDisplay" style="width:998px;height:340px;overflow-y:scroll;overflow-x:hidden" onscroll="scrollY()">
								<table width=980 border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF style="table-layout:fixed">											
<%	if( objVal != null ) 
	{
		String last_data = null; String curr_data = null;
		boolean samedata = false;
		String cssClass = "tblcg";
		
		for(int i=0; i<objVal.size(); i++) {
			String targetImg1 = ""; 
			String targetImg2 = "";
			InterfaceMonitorVO vo = (InterfaceMonitorVO)objVal.get(i);
			curr_data = vo.getIfid();
			if( i==0 ) last_data = curr_data;
			
			// 같은 IF ID를 사용할 경우 다음 라인에서 출력하지 않음
			if(i!=0 && last_data.equals(curr_data)) samedata = true;
			else {
				samedata = false;
				cssClass = "tblcg".equals(cssClass)==true?"tblcw":"tblcg";
			}
			
			// 이미지
			targetImg1 = CommonUtil.getStatusImg(vo.getSendStatus(), vo.getSendLtime());
			targetImg2 = CommonUtil.getStatusImg(vo.getRecvStatus(), vo.getRecvLtime());
			// 이미지 끝
%>
									<tr class=<%=cssClass%>>
										<td width=40><%=(i+1)%></td>
										<td width="%"><%=samedata==true?"&nbsp;":vo.getIfid()%></td>
										<td width="90"><%=vo.getSendSystem()%></td>
										<td width="90"><%=vo.getSendAdapterName()%></td>
										<td width=90><%=vo.getSendLinkName()%></td>
										<td width=90><%=targetImg1%></td>
										<td width=90><%=vo.getRecvSystem()%></td>
										<td width=150><%=vo.getRecvAdapterName()%></td>
										<td width=130><%=vo.getRecvLinkName()%></td>
										<td width=90><%=targetImg2%></td>
									</tr>			
<%			last_data = curr_data;		
		}
		if( objVal == null || objVal.size() == 0) {	
%>									<tr height=21><td colspan=10 align=center>검색된 결과가 없습니다.</td></tr>
<%		}		
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
	</td>
</tr>
</table>
<script>
<!--
function scrollX() {
	document.all.mainDisplay.scrollLeft = document.all.bottomLine.scrollLeft;
	document.all.topLine.scrollLeft = document.all.bottomLine.scrollLeft;
}
function scrollY() {
	//document.all.leftDisplay.scrollTop = document.all.mainDisplay.scrollTop;
}
//-->
</script>	
</html:form>
</body>
</html:html>
