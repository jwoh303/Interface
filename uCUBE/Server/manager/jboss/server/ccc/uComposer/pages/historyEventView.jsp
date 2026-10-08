<%@ include file="/pages/form/jspheader.jsp"%>
<%@ include file="/pages/form/loginCheck.jsp"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page pageEncoding="UTF-8"%>

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
	request.setCharacterEncoding("UTF-8");
	java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	java.text.SimpleDateFormat dateFormat1 = new java.text.SimpleDateFormat("yyyy-MM-dd");
	String currentDate = null;
	if (request.getParameter("date") == null) {
		currentDate = dateFormat1.format(new java.util.Date());
	} else {
		currentDate = (String)request.getParameter("date");
	}
	
	String totalCount = null;
	//(String)request.getAttribute("totalCount");
	
	Object[] objVal = new Object[]{}; 
	
	
	try {
		if(ctx!=null && ctx.get("historyEvent")!=null && ctx.get("totalCount")!=null ) 
		{
			ArrayList objList= (ArrayList)ctx.get("historyEvent");
			objVal = objList.toArray();
			totalCount = (String)ctx.get("totalCount");
		}
	}
	catch(Exception e) {
		out.println(e);
	}
	
	String strIfid = request.getParameter("ifid");
	String strTc = request.getParameter("tc");
	if (strIfid == null) strIfid = "";
	if (strTc == null) strTc = "";
	//Object[] objVal = (Object[])ctx.get("historyEvent");	
%>
<html>
<head>

<%@ include file="/pages/form/htmlheader.jsp"%>

<script type="text/javascript">
function preLoadImg() {
    var Pic = new Array();
    Pic[0] = 'img/circle.gif'; 
    
    var preLoad = new Array();
    for (i = 0; i < Pic.length; i++) {
        preLoad[i] = new Image();
        preLoad[i].src = Pic[i];
    }
}
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
    	
    	
    	preLoadImg();
	searching();
    	document.forms[0].submit();
    		
}
function link(val, ifid, tc, date, stime, etime) 
{
//	alert("link");
	if( val <= 0 ) return; 
	searching();
	stime = stime + ":00";
	etime = etime + ":00";
	frm = document.forms[0];
	
	frm.ifid.value = ifid;
	frm.tc.value = tc;
	frm.date.value = date;
	frm.stime.value = date + " " + stime;
	frm.etime.value = date + " " + etime;
	
	document.getElementById("ServiceName").value = "historyDetailView-service";
	document.getElementById("find.x").value = "1";
	
	document.getElementById("select").value = "%";
	document.getElementById("firstselect").value = "%";
	
/*	alert(document.forms[0].ifid.value);
	alert(document.forms[0].tc.value);
	alert("date = " + document.forms[0].date.value);
	alert("stime = " + document.forms[0].stime.value);
	alert("etime = " + document.forms[0].etime.value);
	alert(document.getElementById("ServiceName").value);
	alert(document.getElementById("find.x").value);
	alert(document.getElementById("select").value);
	alert(document.getElementById("firstselect").value);
*/	
	
	frm.action = "/uComposer/historyDetailView.do?system=&pageNo=1";
	//userManager.do?actionFlag=add
	//frm.action = "historyDetailView.do?select=%&pageNo=1&firstselect=%&ifid=" + ifid + "&tc=" + tc+ "&date=" + date + "&stime=" + date + " " + stime + "&etime=" + date + " " + etime ;
	frm.method = "post";
	frm.submit();
}

function linkDiff(val, select, ifid, tc, date, stime, etime) 
{  
//   alert("linkDiff");
	if( val <= 0 ) return; 
	searching();
	stime = stime + ":00";
	etime = etime + ":00";
	frm = document.forms[0];
	
	frm.ifid.value = ifid;
	frm.tc.value = tc;
	frm.date.value = date;
	frm.stime.value = date + " " + stime;
	frm.etime.value = date + " " + etime;


	document.getElementById("ServiceName").value = "historyDetailView-service";
	document.getElementById("find.x").value = "1";	

/*	alert(document.forms[0].ifid.value);
	alert(document.forms[0].tc.value);
	alert("date = " + document.forms[0].date.value);
	alert("stime = " + document.forms[0].stime.value);
	alert("etime = " + document.forms[0].etime.value);
	alert(document.getElementById("ServiceName").value);
	alert(document.getElementById("find.x").value);
*/	
	///document.getElementById("pageNo").value = pageNo;

	frm.action = "/uComposer/historyDetailView.do?system=&pageNo=1";
	//frm.action += "?ServiceName=historyDetailView-service&find.x=1";
	//frm.action += "&select=" + select + "&ifid=" + ifid + "&tc=" + tc+ "&date=" + date + "&stime=" + date + " " + stime + "&etime=" + date + " " + etime ;
	frm.method = "post";
	//document.getElementById("SericeName").value = "historyDetailView-service";
	//alert("document.getElementById(SericeName).value = " + document.getElementById("SericeName").value);
	//frm.hEvent.elements(1).value = "1";
	frm.submit();
}

</script>
</head>

<body topmargin=0 leftmargin=0 onLoad="MM_preloadImages('img/ucube_img04_menu_over.gif','img/ucube_img05_menu_over.gif','img/ucube_img06_menu_over.gif','img/ucube_img07_menu_over.gif','img/ucube_img08_menu_over.gif','img/circle.gif');">
<form method="post" action="historyEventView.do"  >
<input type="hidden" name="ServiceName" value="historyEventView-service" />
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
								<span class="tit01">History Event View</span>
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
								<input type="hidden" name="gubun" value="TC">	
								<input type="hidden" name="select" value="noReceivedMsg"/>	
								<input type="hidden" name="firstselect"/>
								<input type="hidden" name="stime" value=""/>
  								<input type="hidden" name="etime" value=""/>
						    	
						    	<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="search">
					            	<tr>
					              		<td width="250">
					              			<img src="img/comm_img02_blank.gif" width="10" height="10">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>인터페이스 ID :</b>
					                  		<input type="text" size="13" maxlength="17" name="ifid" Class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" onkeyup="this.value=upperCase(this.value);" value="<%=strIfid %>">					    		
						    				</text>
											<img src="img/comm_img02_blank.gif" width="10" height="10"> 
										</td>
										<td width="200">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>프로세스  코드 : </b>
					                  		<input type="text" size="9" maxlength="8" name="tc" Class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" onkeyup="this.value=upperCase(this.value);" value="<%=strTc %>">					    		
						    				</text>
											<img src="img/comm_img02_blank.gif" width="10" height="10"> 
										</td>
					              		<td width="200">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>날짜 : </b>                
					              			<input type="text" size="10" maxlength="10" name="date" value="<%= currentDate %>" Class="adb1" readonly="true" />                 
					              			<img src="img/comm_img04_cal.gif" width="14" height="13" onclick="showCalendar('date','','','YYYY/MONTH/DD','',1,'','',2,true,'',true,'','false',false,false)" style="cursor:hand">     
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
	        		</table><!--검색조건 끝--> 
	        	</td>
	        </tr>  
	        <tr bgcolor=white> 	
				<td align=right height=20 valign=bottom><%if(totalCount!=null) { %>총 <%=totalCount%>건이 조회되었습니다.<% } %>&nbsp;&nbsp;</td>
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
										<td rowspan=2 width=%>인터페이스<br>ID</td>
<%	if (request.getParameter("gubun") == null || request.getParameter("gubun").equals("TC")) { %>											
										<td rowspan=2 width=80>프로세스<br>코드</td>
<%	} %>										
										<td rowspan=2 width=60>송수신<br>구분</td>
										<td rowspan=2 width=70>시스템<br> 이름</td>
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
		String last_ifid = null; String curr_ifid = null;
		boolean sameifid = false;
		String cssClass = "tblcg";
		Hashtable hashtable = new Hashtable();
		for(int i=0; i<objVal.length; i++)
		{
			HistoryEventViewVO vo = (HistoryEventViewVO)objVal[i];
			Object key = vo.getIfd();
			Integer count = (Integer)hashtable.get(key);
			if ( count == null)
			{
				hashtable.put(key, new Integer(1));
			}else
			{
				hashtable.remove(key);
				hashtable.put(key,new Integer(count.intValue() + 1));
			}
			key = null;
			count = null;
			
			key = vo.getIfd() + vo.getTc();
			count = (Integer)hashtable.get(key);
			if ( count == null)
			{
				hashtable.put(key, new Integer(1));
			}else
			{
				hashtable.remove(key);
				hashtable.put(key,new Integer(count.intValue() + 1));
			}
			
		}

		for(int i=0; i<objVal.length; i++) {
			HistoryEventViewVO vo = (HistoryEventViewVO)objVal[i];
			curr_ifid = vo.getIfd();
			if( i==0 ) last_ifid = curr_ifid;
			
			// 같은 IF ID를 사용할 경우 다음 라인에서 출력하지 않음
			if(i!=0 && last_ifid.equals(curr_ifid)) sameifid = true;
			else {
				sameifid = false;
				cssClass = "tblcg".equals(cssClass)==true?"tblcw":"tblcg";
			}
%>			
									<tr class=<%=cssClass%> height=18>
										<!--<td width="%"><%=sameifid==true?"&nbsp;":vo.getIfd()%></td>-->
<%		
			Integer count = (Integer)hashtable.get(vo.getIfd());
			if( count != null)
			{
				hashtable.remove( vo.getIfd() );
	
%>												
										<td width="%" ROWSPAN=<%=count.intValue()%> ><%=sameifid==true?"&nbsp;":vo.getIfd()%></td>
<%
			}
%>										
										
<%			/* if (request.getParameter("gubun") != null && request.getParameter("gubun").equals("TC")) { */ 
			count = null;
			count = (Integer)hashtable.get(vo.getIfd() +  vo.getTc());
			if( count != null)
			{
				hashtable.remove( vo.getIfd() +  vo.getTc() );
%>										
										<td width=80 ROWSPAN=<%=count.intValue()%> ><%=vo.getTc()%></td>
<%			} %>
										<td width=60><%=vo.getSrc()==null?"&nbsp;":vo.getSrc()%></td>
										<td width=70><%=(vo.getSc()==null || vo.getSc().equals(""))?"&nbsp;":vo.getSc()%></td>
<%			if ("차이".equals(vo.getSrc()) && vo.getTot() > 0) { %>										
										<td width=40 style="padding:0 3 0 0;text-align:right;color:red"><%=vo.getTot()%></td>
										<%
										for(int time =0 ; time < 24 ; time++)
										{
											if(vo.getCountByTime(time) > 0)
											{
										%>	
											<td width=26 style="padding:0 3 0 0;text-align:right;color:red;text-decoration:underline;cursor:hand;" onClick="linkDiff(this,'noReceivedMsg' ,'<%=vo.getIfd()%>', '<%=vo.getTc()%>', '<%=currentDate%>','<%=vo.format(time)%>:00','<%=vo.format(time+1)%>:00');"><%=vo.getCountByTime(time)%></td>
										<%
											}else
											{
										%>
											<td width=26 style="padding:0 3 0 0;text-align:right;color:black"><%=vo.getCountByTime(time)%></td>	
										<%
											}
										}
										%>
<%			}else if ("에러".equals(vo.getSrc()) && vo.getTot() > 0) { %>										
										<td width=40 style="padding:0 3 0 0;text-align:right;color:red"><%=vo.getTot()%></td>
										<%
										for(int time =0 ; time < 24 ; time++)
										{
											if(vo.getCountByTime(time) > 0)
											{
										%>	
											<td width=26 style="padding:0 3 0 0;text-align:right;color:red;text-decoration:underline;cursor:hand;" onClick="link(this, '<%=vo.getIfd()%>', '<%=vo.getTc()%>', '<%=currentDate%>','<%=vo.format(time)%>:00','<%=vo.format(time+1)%>:00');"><%=vo.getCountByTime(time)%></td>
										<%
											}else
											{
										%>
											<td width=26 style="padding:0 3 0 0;text-align:right;color:black"><%=vo.getCountByTime(time)%></td>	
										<%
											}
										}
										%> 
										
<%			} else { %>	
										<td width=40 style="padding:0 3 0 0;text-align:right;"><%=vo.getTot()%></td>
										<%
										for(int time =0 ; time < 24 ; time++)
										{
											if(vo.getCountByTime(time) > 0)
											{
										%>	
											<td width=26 style="padding:0 3 0 0;text-align:right;cursor:hand;" onClick="link(this, '<%=vo.getIfd()%>', '<%=vo.getTc()%>', '<%=currentDate%>','<%=vo.format(time)%>:00','<%=vo.format(time+1)%>:00');"><%=vo.getCountByTime(time)%></td>
										<%
											}else
											{
										%>
											<td width=26 style="padding:0 3 0 0;text-align:right;color:black"><%=vo.getCountByTime(time)%></td>	
										<%
											}
										}
										%> 																		
<%			} %>										

									</tr>			
<%			last_ifid = curr_ifid;		
		}
		if( objVal == null || objVal.length == 0) {	
%>									<tr height=21><td colspan=29 align=center>검색된 결과가 없습니다.</td></tr>
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
	<!-- </td>
</tr>
</table>-->
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
