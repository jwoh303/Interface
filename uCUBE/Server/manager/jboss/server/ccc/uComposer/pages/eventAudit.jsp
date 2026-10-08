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
<%@ page import = "com.posdata.glue.dao.vo.*" %>

<%@ page import = "java.util.*" %>

<%
	PosContext ctx = (PosContext)request.getAttribute( "PosContext" );
	
	// 현재날짜
	
	 //out.println("Session :" + ctx.getAllSessionAttrs().get("ID"));
	java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	java.text.SimpleDateFormat dateFormat1 = new java.text.SimpleDateFormat("yyyy-MM-dd");
	String currentDate = null;
	if (request.getParameter("sendDate") == null) {
		currentDate = dateFormat1.format(new java.util.Date());
	} else {
		currentDate = (String) request.getParameter("sendDate");
	}
	//PosRowSet rowSet = (PosRowSet)ctx.get("empResult");
	//while(rowSet.hasNext()){
	//    PosRow row = rowSet.next(); 
 	//}
	//List objVal = (ArrayList)request.getAttribute("staticsEventAudit");
	List objVal = new ArrayList();
	try {
		if(ctx!=null && ctx.get("staticsEventAudit")!=null) 
			objVal = (ArrayList)ctx.get("staticsEventAudit");
	}
	catch(Exception e) {
		out.println(e);
	}

	int totalCount = 0;
	String code = null;
	
	if (objVal != null)
	{
		for(int i=0; i<objVal.size(); i++) {
			ServiceEventAuditVO vo = (ServiceEventAuditVO)objVal.get(i);
			code = vo.getCode();
			if(code != null && !code.equals("합계"))
			{
				totalCount++;
			}
		}
	}

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
		alert("조회 중 입니다!");
		return;
    	}
    	isWaiting = 'true';
    	//Retry 방지 end

	searching();
    	document.forms[0].submit();
}
</script>
</head>

<body topmargin=0 leftmargin=0 onLoad="MM_preloadImages('img/ucube_img04_menu_over.gif','img/ucube_img05_menu_over.gif','img/ucube_img06_menu_over.gif','img/ucube_img07_menu_over.gif','img/ucube_img08_menu_over.gif','img/clock.gif')">
<form method="post" action="eventAudit.do">
<input type="hidden" name="ServiceName" value="eventAudit-service" />
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
								<img src="img/comm_img02_blank.gif" width="5" height="10">
								<img src="img/comm_img03_ic.gif" width="11" height="10">
								<span class="bluetit"><img src="img/comm_img02_blank.gif" width="5" height="10"></span>
								<span class="tit01">Hourly Statistical Data</span>
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
					              		<td width="150">
					              			<img src="img/comm_img02_blank.gif" width="10" height="10">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>구분 : </b>
					                  		<select name="select" Class="adf">
												<option value="SYSTEM">시스템</option>
												<option value="SERVICE">서비스</option>
										    </select>
											<img src="img/comm_img02_blank.gif" width="10" height="10"> 
										</td>
					              		<td width="150">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>날짜 : </b>                
					              			<input type="text" name="sendDate" value="<%=currentDate %>" size="10" maxlength="15" Class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" readonly="true" />                
					              			<img src="img/comm_img04_cal.gif" width="14" height="13" onclick="showCalendar('sendDate','','','YYYY/MONTH/DD','',1,'','',2,true,'',true,'','false',false,false)" style="cursor:hand">              
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
	        		<!--검색조건 끝--> 
        		</td>
        	</tr>
			<tr bgcolor=white> 	
				<td align=right height=20 valign=bottom><%if(objVal!=null) { %>총 <%=totalCount%>건이 조회되었습니다.<% } %>&nbsp;&nbsp;</td>
			</tr>			        		
		</table>
		
		<!-- data -->
   		<table width="960" height=400 border=0 cellpadding="0" cellspacing="0" bordercolorlight=FFFFFF  bordercolordark=FFFFFF>
			<tr>
				<td width=5></td>
				<td align=center valign=top>
					<table width=960 border=0 cellpadding=0 cellspacing=0 bordercolorlight=666666 bordercolordark=FFFFFF>
		    			<tr>
		    				<td height=400 width=100% valign=top>
		    					<DIV id="topLine" style="width:980px;overflow:hidden;">
		    					<table width="960" border="1" cellpadding="1" cellspacing="0" bordercolor="Black" bordercolorlight="#626262" bordercolordark="White" class="tblcb1" valign="TOP" style="table-layout:fixed">
									<tr> 
<%	if( "SERVICE".equals(request.getParameter("select")) ) {	%>
										<td rowspan=2 width=120 style="padding:0 0 0 5;">서비스명</td>
<%	} %>
										<td rowspan=2 width=80>시스템 <br>이름</td>
										<td rowspan=2 width=60>송수신<br>구분</td>
										<td rowspan=2 width=40>합계</td>
										<td colspan=24 width=624 height="20">시간</td>
									</tr>
									<tr> 
										<td width=26 class="tblcb3" height="20">00</td>
										<td width=26 class="tblcb3">01</td>
										<td width=26 class="tblcb3">02</td>
										<td width=26 class="tblcb3">03</td>
										<td width=26 class="tblcb3">04</td>
										<td width=26 class="tblcb3">05</td>
										<td width=26 class="tblcb3">06</td>
										<td width=26 class="tblcb3">07</td>
										<td width=26 class="tblcb3">08</td>
										<td width=26 class="tblcb3">09</td>
										<td width=26 class="tblcb3">10</td>
										<td width=26 class="tblcb3">11</td>
										<td width=26 class="tblcb3">12</td>
										<td width=26 class="tblcb3">13</td>
										<td width=26 class="tblcb3">14</td>
										<td width=26 class="tblcb3">15</td>
										<td width=26 class="tblcb3">16</td>
										<td width=26 class="tblcb3">17</td>
										<td width=26 class="tblcb3">18</td>
										<td width=26 class="tblcb3">19</td>
										<td width=26 class="tblcb3">20</td>
										<td width=26 class="tblcb3">21</td>
										<td width=26 class="tblcb3">22</td>
										<td width=26 class="tblcb3">23</td>
									</tr>									
								</table>
								</div>
								<DIV id="mainDisplay" style="width:980px;height:340px;overflow-y:scroll;overflow-x:hidden" onscroll="scrollY()">
								<table width="960" border="1" cellpadding="1" cellspacing="0" bordercolor="#FFFFFF" bordercolorlight="#626262" bordercolordark="White" bgcolor="#FFFFFF" class="tblbc" valign="TOP" style="table-layout:fixed">
<%	if( objVal != null ) 
	{
		String last_data = null; String curr_data = null;
		boolean sameData = false;
		String cssClass = "tblcg";
		
		for(int i=0; i<objVal.size(); i++) {
			ServiceEventAuditVO vo = (ServiceEventAuditVO)objVal.get(i);
			
			if("SERVICE".equals(request.getParameter("select"))) {
				curr_data = vo.getCode()==null?"":vo.getCode();
			} else {
				curr_data = vo.getCode()==null?"":vo.getCode();
			}
			if( i==0 ) last_data = curr_data;
			
			// 같은 IF ID를 사용할 경우 다음 라인에서 출력하지 않음
			if(i!=0 && last_data.equals(curr_data)) sameData = true;
			else {
				sameData = false;
				cssClass = "tblcg".equals(cssClass)==true?"tblcw":"tblcg";
			}
%>
									<tr class=<%=cssClass%>>
<%	if ( "SERVICE".equals(request.getParameter("select")) ) {	%>
										<td width="120" style="padding:0 0 0 5;"><%=vo.getCode()%></td>
							            <td width="80"  style="padding:0 0 0 5;"><%=(vo.getSystem()==null||vo.getSystem().equals(""))?"&nbsp;":vo.getSystem()%></td>	
<% 	}else {	%>									
										<td width="80"><%=vo.getCode()%></td>
<% } %>
										<td width=60><%=vo.getSrc()%></td>
										<td width=40 style="padding:0 3 0 0;text-align:right"><%=vo.getTot()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT00()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT01()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT02()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT03()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT04()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT05()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT06()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT07()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT08()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT09()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT10()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT11()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT12()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT13()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT14()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT15()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT16()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT17()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT18()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT19()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT20()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT21()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT22()%></td>
										<td width=26 style="padding:0 3 0 0;text-align:right"><%=vo.getT23()%></td>											
									</tr>			
<%			last_data = curr_data;		
		}
		if( objVal != null && objVal.size() == 0) {	
%>									<tr height=21><td colspan=27 align=center>검색된 결과가 없습니다.</td></tr>
<%		}	
	} %>

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
	document.all.mainDisplay.scrollLeft = document.all.bottomLine.scrollLeft;
	document.all.topLine.scrollLeft = document.all.bottomLine.scrollLeft;
}
function scrollY() {
	//document.all.leftDisplay.scrollTop = document.all.mainDisplay.scrollTop;
}
</script>	
<%@ include file="/pages/footer.jsp"%>
</form>
</body>
</html>
