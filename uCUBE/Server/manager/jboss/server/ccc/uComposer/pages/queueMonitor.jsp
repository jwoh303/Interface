<%@ include file="/pages/form/jspheader.jsp"%>
<%@ include file="/pages/form/loginCheck.jsp"%>
<%@ page contentType="text/html;charset=UTF-8"%>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>

<%@ page import="com.posdata.glue.dao.vo.PosRowSet,
					com.posdata.glue.context.PosContext,
					com.posdata.glue.dao.vo.PosRow" %>

<%@ page import = "com.posdata.eai.manager.vo.*" %>

<%@ page import = "java.util.*" %>
<%@ page import = "com.posdata.glue.dao.vo.*" %>
<%@ page import = "com.posdata.glue.util.log.PosLog" %>

<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>

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

	String qcount = request.getParameter("qcount");
	if( qcount == null ) qcount = "5";
	
	String delayTime = request.getParameter("delayTime");
	if( delayTime == null ) delayTime = "5";
	
	String refreshTime = request.getParameter("refreshTime");
	if( refreshTime == null ) refreshTime = "30";
	
	//String notice = (String) request.getAttribute("notice");
	//List objVal = (ArrayList)request.getAttribute("queueMonitor");
	String[] notice = null;
	List objVal = new ArrayList();
	
	try {
		if(ctx!=null && ctx.get("queueMonitor")!=null) {
			objVal = (ArrayList)ctx.get("queueMonitor");
			notice = (String[])ctx.get("notice");
		}
	}
	catch(Exception e) {
		out.println(e);
	}

	int totalQueueCount = 0;
	if(objVal!=null) {
		for(int i=0; i<objVal.size(); i++) {
			QueueMonitorVO vo = (QueueMonitorVO)objVal.get(i);
			
			totalQueueCount = totalQueueCount + vo.getDcnt();
		}
	}
	
	int totalCount = objVal==null?0:objVal.size();
%>

<html>
<head>

<%@ include file="/pages/form/htmlheader.jsp"%>
<script type="text/javascript">
function execute() 
{
	//Retry 방지 start
	if( isWaiting == 'true' )
	{
		//alert("조회 중 입니다!");
		return;
    	}
    	isWaiting = 'true';
    	//Retry 방지 end
    	
	var count = document.forms[0].qcount.value;	
	
	if(checkDigit(count) == false)
	{
		document.forms[0].qcount.value=5;
	}
	searching();
    	document.forms[0].submit();
}


</script>
</head>

<body topmargin=0 leftmargin=0 onLoad="MM_preloadImages('img/ucube_img04_menu_over.gif','img/ucube_img05_menu_over.gif','img/ucube_img06_menu_over.gif','img/ucube_img07_menu_over.gif','img/ucube_img08_menu_over.gif','img/clock.gif')">
<form method="post" action="queueMonitor.do">
<input type="hidden" name="ServiceName" value="queueMonitor-service" />
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

		<table width="980" border="0" cellspacing="0" cellpadding="0">
			<tr bgcolor=white> 
				<td height=25> 
					<table width="980" height="25" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<img src="img/comm_img02_blank.gif" width="5" height="10"><img src="img/comm_img03_ic.gif" width="11" height="10"><span class="bluetit"><img src="img/comm_img02_blank.gif" width="5" height="10"></span>
								<span class="tit01">Queue Monitor</span>
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
					              			<img src="img/comm_img02_blank.gif" width="%" height="10">
					              			<img src="img/comm_img06_ic.gif" width="%" height="3"> <b>엔진 이름</b>
						    				<input type="text" size="10" maxlength="12" name="engineName" class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" onkeyup="this.value=upperCase(this.value);" />
										</td>
					              		<td width="%">
					              			<img src="img/comm_img02_blank.gif" width="%" height="10">
					              			<img src="img/comm_img06_ic.gif" width="%" height="3"> <b>큐 이름 : </b>
					              			<input type="text" size="15" maxlength="20" name="qname" class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" onkeyup="this.value=upperCase(this.value);" />
					                  		<img src="img/comm_img02_blank.gif" width="10" height="10"> 
										</td>
					              		<td width="%">
					              			<img src="img/comm_img06_ic.gif" width="%" height="3"> <b>적체 메세지수 : </b>                
					              			<input type="text" size="5" value="<%=qcount%>" maxlength="3" name="qcount" class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" /> 이상
											<img src="img/comm_img02_blank.gif" width="10" height="10"> 
					              		</td>
					              		<td width="%">
					              			<img src="img/comm_img06_ic.gif" width="%" height="3"> <b>지연(분) :</b>
						    				<input type="text" size="5" value="<%=delayTime%>" maxlength="3" name="delayTime" class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" /> 이상
					                  		<img src="img/comm_img02_blank.gif" width="10" height="10"> 
										</td>
										<!-- td width="%">
					              			<img src="img/comm_img06_ic.gif" width="%" height="3"> <b>갱신 주기 :</b>
									    	<input type="text" size="5" value="30" maxlength="5" name="refreshTime" class="adb1" />
					                      	<input type="hidden" name="formName" value="<%=request.getParameter("refreshTime")%>" />
					                  		<img src="img/comm_img02_blank.gif" width="10" height="10"> 
										</td -->
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
				<td align=center bgcolor=white>
					<table width="980" border="0" cellpadding="0" cellspacing="0" bordercolorlight=666666 bordercolordark=FFFFFF>
						<tr>
							<td align=left height=25 width=500 valign=bottom><b><font color=blue> 공지사항</font><%if (notice!=null) {%> <%=notice %> <% } %></b></td>
							<td align=right height=25 valign=bottom><%if(objVal!=null) { %>총 적체건수는 <b><font color=red><%=totalQueueCount %></font></b> 이며, 총 <%=totalCount%>건이 조회되었습니다.<% } %>&nbsp;&nbsp;</td>
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
										<td width=110>서버이름</td>
										<td width=112>큐 이름</td>
										<td width=120>큐 설명</td>
										<td width=50>적체<br>건수</td>
										<td width=75>체크 시간</td>
										<td width=50>지연(분)</td>
										<td width=85>시스템 이름</td>
										<td width=90>인터페이스 ID</td>
										<td width=78>트렌젝<br>코드</td>
										<td width=50>코드</td>
										<td width=70>송신 시간</td>
										<td width=70>수신 시간</td>
									</tr>
								</table>
								</DIV>
								<DIV id="mainDisplay" style="width:980px;height:340px;overflow-y:scroll;overflow-x:hidden" onscroll="scrollY()">
								<table width="960" border="1" cellpadding="1" cellspacing="0" bordercolor="#FFFFFF" bordercolorlight="#626262" bordercolordark="White" bgcolor="#FFFFFF" class="tblbc" valign="TOP" style="table-layout:fixed">											
<%	if( objVal != null ) 
	{
		String last_data = null; String curr_data = null;
		boolean sameifid = false;
		String cssClass = "tblcg";
		
		for(int i=0; i<objVal.size(); i++) {
			QueueMonitorVO vo = (QueueMonitorVO)objVal.get(i);
			curr_data = vo.getQname();
			if( i==0 ) last_data = curr_data;
			
			// 같은 IF ID를 사용할 경우 다음 라인에서 출력하지 않음
			if(i!=0 && last_data.equals(curr_data)) sameifid = true;
			else {
				sameifid = false;
				cssClass = "tblcg".equals(cssClass)==true?"tblcw":"tblcg";
			}
%>
									<tr class=<%=cssClass%>>
										<td width=110><%=vo.getServerName()==null?"&nbsp;":vo.getServerName()%></td>
										<td width=112><%=vo.getQname()%></td>
										<td width=120><%=vo.getQdesc()==null?"&nbsp":(vo.getQdesc().equals(""))?"&nbsp":vo.getQdesc()%></td>
										<td width=50><%=vo.getDcnt()%></td>
										<td width=75><%=vo.getGdate()%></td>
										<td width=50><%=vo.getDdate()==null?"&nbsp;":vo.getDdate()%></td>
										<td width=85><%=vo.getSysid()==null?"&nbsp;":vo.getSysid()%></td>
										<td width=90><%=vo.getIfid()==null?"&nbsp;":vo.getIfid()%></td>
										<td width=78><%=vo.getTcode()==null?"&nbsp;":vo.getTcode()%></td>
										<td width=50><%=vo.getEcode()==null?"&nbsp;":vo.getEcode()%></td>
										<td width=70><%=vo.getStime()==null?"&nbsp;":vo.getStime()%></td>
										<td width=70><%=vo.getRtime()==null?"&nbsp;":vo.getRtime()%></td>
									</tr>				
<%			last_data = curr_data;		
		}
		if( objVal == null || objVal.size() == 0) {	
%>									<tr height=21><td colspan=11 align=center>검색된 결과가 없습니다.</td></tr>
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
<script>
function scrollX() {
	//document.all.mainDisplay.scrollLeft = document.all.bottomLine.scrollLeft;
	//document.all.topLine.scrollLeft = document.all.bottomLine.scrollLeft;
}
function scrollY() {
	//document.all.leftDisplay.scrollTop = document.all.mainDisplay.scrollTop;
}
</script>	
<%@ include file="/pages/footer.jsp"%>
</form>
</body>
</html>
