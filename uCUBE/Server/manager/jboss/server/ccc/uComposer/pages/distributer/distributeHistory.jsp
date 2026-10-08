<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>

<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<script language="JavaScript" src="/uComposer/js/showErrorPopup.js"></script>
<script language="JavaScript" src="/uComposer/js/showBubbleHelp.js"></script>

<%@ include file="/pages/form/htmlheader.jsp" %>
<%@ include file="/pages/form/jspheader.jsp"%>
<%@ include file="/pages/form/loginCheck.jsp"%>

<%
	PosContext ctx = (PosContext)request.getAttribute( "PosContext" );
	int linenum = 0;
	String alertMessage = null;
	String currentTime = "";
	if( ctx != null ) {
		alertMessage = (String)ctx.get( "alertMessage" );
		currentTime = (String)ctx.get( "currentTime" );
	}
%>

<%
	// 현재날짜
	request.setCharacterEncoding("UTF-8");
	java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	java.text.SimpleDateFormat dateFormat1 = new java.text.SimpleDateFormat("yyyy-MM-dd");
	
	String currentDate = null;
	if (request.getParameter("date") == null) {
		currentDate = dateFormat1.format(new java.util.Date());
	} else {
		currentDate = (String) request.getParameter("date");
	}
	
	String totalCount = (String)request.getAttribute("totalCount");
	Object[] objVal = (Object[])request.getAttribute("historyEvent");	

	String _stime=request.getParameter("stime");
	String _etime=request.getParameter("etime");
	_stime = _stime==null?currentDate:_stime;
	_etime = _etime==null?currentDate:_etime;

%>

<script>

<% if( alertMessage!=null ) { %>
	alert("<%=alertMessage %>");
<% } %>

function checkTime(messg1, messg2)
{

    formDistHistList.stime.value =messg1 ;
    formDistHistList.etime.value =messg2;
    
    return; 

}


function init() {
	MM_preloadImages('/img/I01_img25.gif','/img/I01_img27.gif','/img/I01_img04_1.gif','/img/ucube_img04_menu_over.gif','/img/ucube_img05_menu_over.gif','/img/ucube_img06_menu_over.gif','/img/ucube_img07_menu_over.gif','/img/ucube_img08_menu_over.gif');
}


function runReDistribute( vmseq, sgseq ) {
	confirmStr = "재 분배 하시겠습니까?";
	if( confirm( confirmStr ) ) {
		formDistHistList.inputvmseq.value = vmseq;
		formDistHistList.inputsgseq.value = sgseq;
		return;
	}
	return false;
}


function showToolTip( tgname, index ) {
	var evalstr = "formDistHistList." + tgname + ((formDistHistList.linenum.value>1)?"[index]":"") + ".value";
	var msg = eval( evalstr );
	tooltipOn( msg );
}

function callDistributeHistory() {
	var url = "/uComposer/distributeHistoryAction.do?ServiceName=distributeHistory-service&find.x=1";
	location.href = url;
}


function goClose() {
	self.close();
}

</script>


<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<style type="text/css">
		body { margin-left: 10px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; }
	</style>
	<link href="css/pub_ucube.css" rel="stylesheet" type="text/css">


	<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>  <!-- 풍선도움말을 위한 Div Layer -->
	<title>uComposer Distribute History</title>
</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin=0 leftmargin=0 onload="init()">

	<form name="formDistHistList" method="post" action="distributeHistoryAction.do" >
		<input type="hidden" name="ServiceName" value="distributeHistory-service">
		<posui:showMessage/>
		<input type="hidden" name="inputvmseq">
		<input type="hidden" name="inputsgseq">
		
		<%@ include file="/pages/header.jsp" %>

		<!--세로간격-->
	<table width="980" border="0" cellspacing="0" cellpadding="0">
		<tr bgcolor=white> 
			<td height=25> 	
				<table width="980" height="25" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<img src="/uComposer/img/comm_img02_blank.gif" width="5" height="10"><img src="/uComposer/img/comm_img03_ic.gif" width="11" height="10"><span class="bluetit"><img src="/uComposer/img/comm_img02_blank.gif" width="5" height="10"></span>
							<span class="tit01">Distribute History</span>
						</td>
					</tr>
				</table>
				<!--세로간격 끝-->
			</tr>


		<tr><!--검색조건-->
			<td align=center bgcolor=white>
				<table width="980"  border="1" cellpadding="2" cellspacing="0" bordercolor="#FFFFFF" bgcolor="#FFFFFF" >
					<tr>
						<td height="25" bordercolor="999999" bgcolor="F8F3E8">
							<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="search">
								<tr>
									<td width="%">
				              			<img src="/uComposer/img/comm_img02_blank.gif" width="10" height="10">
										<img src="/uComposer/img/comm_img06_ic.gif" width="10" height="3">
										<b>기간:</b>                                           				              																							  
										<input type="text" name="stime" style="width:80"  value="<%=_stime%>"  class=adb2 onBlur=this.className='adb2' onFocus=this.className='adf2' readonly="true"/> ~               
										<input type="text" name="etime" style="width:80"  value="<%=_etime%>"  class=adb2 onBlur=this.className='adb2' onFocus=this.className='adf2' readonly="true"/> 
										<img src="/uComposer/img/comm_img04_cal.gif" align="absmiddle" border=0 onclick ="showCalendar('stime','','','','etime',2,'','',2,true)" style="cursor:hand" onMouseOver="window.status='Calendar';return true;" onMouseOut="window.status='';return true;"/>    
                                           																				  
										<img src="/uComposer/img/comm_img02_blank.gif" width="10" height="10">
										<img src="/uComposer/img/comm_img06_ic.gif" width="10" height="3">
										<b>System:</b>
										<% if( request.getParameter("inputsystem") != null ){ %>
											<input type="text" name="inputsystem" style="width:80" class=adff value="<%= request.getParameter("inputsystem") %>">
										<% }else { %>
											<input type="text" name="inputsystem" style="width:80" class=adff value="">
										<%}%>
		
										<img src="/uComposer/img/comm_img02_blank.gif" width="10" height="10">
										<img src="/uComposer/img/comm_img06_ic.gif" width="10" height="3">
										<b>Group:</b>
										<% if( request.getParameter("inputsg") != null ){ %>
											<input type="text" name="inputsg" style="width:80" class=adff value="<%= request.getParameter("inputsg") %>">
										<% }else { %>
											<input type="text" name="inputsg" style="width:80" class=adff value="">
										<%}%>
		
										<img src="/uComposer/img/comm_img02_blank.gif" width="10" height="10">
										<img src="/uComposer/img/comm_img06_ic.gif" width="10" height="3">
										<b>Service:</b>
										<% if( request.getParameter("inputservice") != null ){ %>
											<input type="text" name="inputservice" style="width:80" class=adff value="<%= request.getParameter("inputservice") %>">
										<% }else { %>
											<input type="text" name="inputservice" style="width:80" class=adff value="">
										<%}%>
										</td>
										<td width="%">
											<div align="right">
												<posui:showUtilityButtons
													names="find|close"
													onClick="javascript: callDistributeHistory()|javascript: return goClose()"
													imgs="/uComposer/img/m000001ico.gif|img/m000005ico.gif"
												/>
											</div>
									   </td>
								  </tr>
							</table>
						</td>
					</tr>
				 </table>
		       <!--검색조건 끝-->
		     </td>
		   </tr>
		</table>

		<!--세로간격-->
		<table width="980" height="8" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>

				</td>
			</tr>
		</table>
		<!--세로간격 끝-->

		<table width="980" border="1" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
			<tr height=25>
				<td class="tblcb1" height=25 width=40 >NO</td>
				<td class="tblcb1" height=25 width=125>System</td>
				<td class="tblcb1" height=25 width=125>Group</td>
				<td class="tblcb1" height=25 width=100>Service</td>
				<td class="tblcb1" height=25 width=100>IFID</td>
				<td class="tblcb1" height=25 width=170>Type</td>
				<td class="tblcb1" height=25 width=100>분배자</td>
				<td class="tblcb1" height=25 width=80 >분배시간</td>
				<td class="tblcb1" height=25 width=70 >결과</td>
				<td class="tblcb1" height=25 width=70 >재 분배</td>
			</tr>

			<%
				if( ctx != null ) {
					PosRowSet rowSet = ctx.getRowSet( "DistHistoryListResult" );
					PosRow row = null;
					PosRow row2 = null;
					if( rowSet != null ) {
						String sgseq = null;
						String sgid1 = null;
						String sgid2 = null;
						String sid1 = null;
						String sid2 = null;
						int sgcnt = 1, scnt = 1;
						boolean isNext = false;
						boolean isPrevious = false;
						boolean isEnd = false;
						boolean isSGCheck = false;
						String status_flag = null;
						String statusdre = null;
						String statusd = null;
						String statusd2 = null;
						String statusr = null;
						String statusf = null;

						String IFID = null;
						// ★★★★★ out.println( "<br>" );
						// ★★★★★ out.println( "★★★★★ rowSet.count()=["+rowSet.count()+"]<br>" );
						for( int i=0; i<rowSet.count(); i++ ) {
							row = rowSet.next();
							// ★★★★★ out.println( "<br>" );
							// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], scnt=["+scnt+"], rowSet.next();<br>" );
							if( row != null ) {
								out.println( "<tr align=center>" );
								// ★★★★★ out.println( "<br>" );
								// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"] #1<br>" );
								// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], row.SERVICE_SEQ = [" + row.getAttribute( "SERVICE_SEQ" ) + "], row.SERVICE_ID = ["+row.getAttribute( "SERVICE_ID" )+"], row.INTERFACE_ID = ["+row.getAttribute( "INTERFACE_ID" )+"]<br>" );
								if( sgcnt == 1 ) {
									sgid1 = null;
									statusd = null;
									isEnd = false;
									sgid2 = (String)row.getAttribute( "SERVICE_GROUP_ID" );
									statusd2 = (row.getAttribute("DISPATCHED_TIME")!=null) ? (String)row.getAttribute( "DISPATCHED_TIME" ) : null;
									isPrevious = false;
									while( true ) {
										// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"] #2<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], sgid1 = [" + sgid1 + "]<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], sgid2 = [" + sgid2 + "]<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], statusd = [" + statusd + "]<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], statusd2 = [" + statusd2 + "]<br>" );

										if( sgid1 == null ) {
											sgid1 = sgid2;
											statusd = statusd2;
										}
										else if( !sgid2.equals( sgid1 ) || (statusd!=null && !statusd.equals(statusd2)) ) isPrevious = true;

										// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], isPrevious = [" + isPrevious + "]<br>" );

										isNext = false;
										if( !isPrevious ) {
											if( rowSet.hasNext() ) {
												sgcnt++;
												isNext = true;
												row2 = rowSet.next();
												// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], rowSet.next();<br>" );
												// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], row2.SERVICE_SEQ = [" + row2.getAttribute( "SERVICE_SEQ" ) + "], row2.SERVICE_ID = ["+row2.getAttribute( "SERVICE_ID" )+"], row2.INTERFACE_ID = ["+row2.getAttribute( "INTERFACE_ID" )+"]<br>" );
												sgid2 = (String)row2.getAttribute( "SERVICE_GROUP_ID" );
												statusd2 = (row2.getAttribute("DISPATCHED_TIME")!=null) ? (String)row2.getAttribute( "DISPATCHED_TIME" ) : null;
											}
											else {
												isPrevious = true;
												isEnd = true;
											}
										}

										if( isPrevious ) {
											if( sgcnt != 1 ) {
												for( int j=0; j<sgcnt+((isNext)?1:0); j++ ) {
													if( rowSet.hasPrevious() ) {
														row2 = rowSet.previous();
														// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], j=["+j+"], rowSet.previous();<br>" );
														// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], row2.SERVICE_SEQ = ["+row2.getAttribute( "SERVICE_SEQ" )+"], row2.SERVICE_ID = ["+row2.getAttribute( "SERVICE_ID" )+"], row2.INTERFACE_ID = ["+row2.getAttribute( "INTERFACE_ID" )+"]<br>" );
													}
												}
												if( rowSet.hasNext() ) rowSet.next();
												if( !isEnd ) sgcnt--;
											}
											sgid1 = sgid2;
											statusd = statusd2;
											break;
										}
									}

									// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"] #3<br>" );
									linenum++;
									out.println( "    <td rowspan=" + sgcnt + " width=40 >" + linenum + "</td>" );
									out.println( "    <td rowspan=" + sgcnt + " width=125>" + row.getAttribute( "SYSTEM_ID" ) + "</td>" );
									out.println( "    <td rowspan=" + sgcnt + " width=125>" + row.getAttribute( "SERVICE_GROUP_ID" ) + "</td>" );
									isSGCheck = true;
								}
								else {
									sgcnt--;
								}


								// ★★★★★ out.println( "<br>" );
								// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"] #1<br>" );
								// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"], row.SERVICE_SEQ = [" + row.getAttribute( "SERVICE_SEQ" ) + "], row.SERVICE_ID = ["+row.getAttribute( "SERVICE_ID" )+"], row.INTERFACE_ID = ["+row.getAttribute( "INTERFACE_ID" )+"]<br>" );
								if( scnt == 1 ) {
									sid1 = null;
									statusd = null;
									isEnd = false;
									sid2 = (String)row.getAttribute( "SERVICE_ID" );
									statusd2 = (row.getAttribute("DISPATCHED_TIME")!=null) ? (String)row.getAttribute( "DISPATCHED_TIME" ) : null;
									isPrevious = false;
									while( true ) {
										// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"] #2<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"], sid1 = [" + sid1 + "]<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"], sid2 = [" + sid2 + "]<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"], statusd = [" + statusd + "]<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"], statusd2 = [" + statusd2 + "]<br>" );

										if( sid1 == null && sid2 != null ) {
											sid1 = sid2;
											statusd = statusd2;
										}
										else if( sid2==null || !sid2.equals( sid1 ) || (statusd!=null && !statusd.equals(statusd2)) ) isPrevious = true;

										// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"], isPrevious = [" + isPrevious + "]<br>" );

										isNext = false;
										if( !isPrevious ) {
											if( rowSet.hasNext() ) {
												scnt++;
												isNext = true;
												row2 = rowSet.next();
												// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"], rowSet.next();<br>" );
												// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"], row2.SERVICE_SEQ = ["+row2.getAttribute( "SERVICE_SEQ" )+"], row2.SERVICE_ID = ["+row2.getAttribute( "SERVICE_ID" )+"], row2.INTERFACE_ID = ["+row2.getAttribute( "INTERFACE_ID" )+"]<br>" );
												sid2 = (String)row2.getAttribute( "SERVICE_ID" );
												statusd2 = (row2.getAttribute("DISPATCHED_TIME")!=null) ? (String)row2.getAttribute( "DISPATCHED_TIME" ) : null;
											}
											else {
												isPrevious = true;
												isEnd = true;
											}
										}

										if( isPrevious ) {
											if( scnt != 1 ) {
												for( int j=0; j<scnt+((isNext)?1:0); j++ ) {
													if( rowSet.hasPrevious() ) {
														row2 = rowSet.previous();
														// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"], j=["+j+"], rowSet.previous();<br>" );
														// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"], row2.SERVICE_SEQ = ["+row2.getAttribute( "SERVICE_SEQ" )+"], row2.SERVICE_ID = ["+row2.getAttribute( "SERVICE_ID" )+"], row2.INTERFACE_ID = ["+row2.getAttribute( "INTERFACE_ID" )+"]<br>" );
													}
												}
												if( rowSet.hasNext() ) rowSet.next();
												if( !isEnd ) scnt--;
											}
											sid1 = sid2;
											statusd = statusd2;
											break;
										}
									}

									// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"] #3<br>" );
									out.println( "    <td rowspan=" + scnt + " width=100>" + ((row.getAttribute("SERVICE_ID")!=null) ? (String)row.getAttribute( "SERVICE_ID" ) : "&nbsp;") + "</td>" );
								}
								else {
									scnt--;
								}


								IFID = (row.getAttribute("INTERFACE_ID")!=null) ? (String)row.getAttribute( "INTERFACE_ID" ) : null;
								if( isSGCheck ) {
									status_flag = (row.getAttribute("STATUS_FLAG")!=null) ? (String)row.getAttribute( "STATUS_FLAG" ) : null;
									statusd =
										(row.getAttribute("DISPATCHED_TIME")!=null) ?
											(
												(status_flag!=null && (status_flag.equals("D") || status_flag.equals("R"))) ?
													(String)row.getAttribute( "DISPATCHED_TIME" ) : null
											)
											:
											null;
									statusr = (statusd!=null && row.getAttribute("RECEIVED_TIME")!=null) ? (String)row.getAttribute( "RECEIVED_TIME" ) : null;
									statusf = (statusd!=null && row.getAttribute("RUNED_TIME")!=null) ? (String)row.getAttribute( "RUNED_TIME" ) : null;
								}

								out.println( "    <td width=100>" + ((IFID!=null)?IFID:"&nbsp;") + "</td>" );
								out.println( "    <td width=170>" + ((row.getAttribute("SERVICE_GROUP_TYPE_ID")!=null) ? (String)row.getAttribute( "SERVICE_GROUP_TYPE_ID" ) : "&nbsp;") + "</td>" );
								out.println( "    <td width=100>" + ((row.getAttribute("USER_ID")!=null) ? (String)row.getAttribute( "USER_ID" ) : "&nbsp;") + "</td>" );
								out.println( "    <td width=80 >" + ((row.getAttribute("DISPATCHED_TIME")!=null) ? row.getAttribute( "DISPATCHED_TIME" ) : "&nbsp;") + "</td>" );

								if( isSGCheck ) {
									out.println( "    <td rowspan=" + sgcnt + " width=70>" );
									statusdre = (String)row.getAttribute( "REDISPATCHED_TIME" );
									if( statusdre.length() > 0 ) {
										out.println( "        <img src=\"/uComposer/img/statusdre.gif\" onmouseover=\"showToolTip('statusdre',"+(linenum-1)+");\" onmouseout='tooltipOff();'>" );
									}
									if( status_flag.equals( "D" ) ) out.println( "        <img src=\"/uComposer/img/statusd3.gif\" " + ((statusd!=null)?"onmouseover=\"showToolTip('statusd',"+(linenum-1)+");\" onmouseout='tooltipOff();'":"") + ">" );
									else if( status_flag.equals( "R" ) ) out.println( "        <img src=\"/uComposer/img/statusr3.gif\" " + ((statusr!=null)?"onmouseover=\"showToolTip('statusr',"+(linenum-1)+");\" onmouseout='tooltipOff();'":"") + ">" );
									else if( status_flag.equals( "F" ) ) out.println( "        <img src=\"/uComposer/img/statusf.gif\" " + ((statusf!=null)?"onmouseover=\"showToolTip('statusr',"+(linenum-1)+");\" onmouseout='tooltipOff();'":"") + ">" );
									else if( status_flag.equals( "I" ) ) out.println( "        <img src=\"/uComposer/img/statusi.gif\">" );
									out.println( "    </td>" );
									sgseq = ((Integer)row.getAttribute( "SERVICE_GROUP_SEQ" )).toString();
									out.println( "    <td rowspan=" + sgcnt + " width=70>" );
									if( status_flag.equals( "F" ) ) out.println( "        <input type=\"image\" name=\"redistribute\" src=\"/uComposer/img/redistribute.gif\" onClick=\"javascript: return runReDistribute('" + ((Integer)row.getAttribute( "DISPATCH_VERSION" )).toString() + "','" + sgseq + "')\">" );
									else out.println( "        &nbsp;" );
									out.println( "    </td>" );

									out.println( "   <input type=\"hidden\" name=\"sgseq\" value=\"" + sgseq + "\">" );
									out.println( "   <input type=\"hidden\" name=\"statusdre\" value=\"" + ((statusdre.length()>0)?statusdre:"") + "\">" );
									out.println( "   <input type=\"hidden\" name=\"statusd\" value=\"" + ((statusd!=null)?statusd:"") + "\">" );
									out.println( "   <input type=\"hidden\" name=\"statusr\" value=\"" + ((statusr!=null)?statusr:"") + "\">" );

 									isSGCheck = false;
								}

								out.println( "</tr>" );
							}
						}
					}
				}
			%>
		</table>

		<% /*
		<table width="980" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td background="/uComposer/img/m000006img.gif"><img src="/uComposer/img/m000006img.gif" width="12" height=7></td>
			</tr>

			<tr>
				<td height=20>&nbsp;</td>
			</tr>

			<tr>
				<td background="/uComposer/img/m000006img.gif"><img src="/uComposer/img/m000006img.gif" width="12" height=7></td>
			</tr>

			<tr>
				<td>
					<posui:showTable
						tableName="distlisttable"
						infoName="DistHistoryListResult"
						columnNames="null|null|null|null|null|null|null|null|null|null|null|null|null"
						columnWidths="40|150|40|40|150|40|40|150|40|40|150|40|60"
						height="23"
						headerValues="System|System|System|Service Group|Service Group|Service Group|Service|Service|Service|Interface|Interface|Interface|Status;SEQ|ID|VER|SEQ|ID|VER|SEQ|ID|VER|SEQ|ID|VER|Status"
						headerClasses="tbldb|tbldb"
						trClasses="tblcg|tblcw"
						tdClasses="tbllb|null|null|tbllb|null|null|tbllb|null|null|tbllb|null|null|null"
						displayTypes="null|null|null|null|null|null|null|null|null|null|null|null|null"
						attributes="SYSTEM_SEQ|SYSTEM_ID|SYSVER|SERVICE_GROUP_SEQ|SERVICE_GROUP_ID|SGVER|SERVICE_SEQ|SERVICE_ID|SERVER|INTERFACE_SEQ|INTERFACE_ID|IFVER|STATUS_FLAG"
					/>
				</td>
			</tr>

			<tr>
				<td background="/uComposer/img/m000006img.gif"><img src="/uComposer/img/m000006img.gif" width="12" height=7></td>
			</tr>

			<tr>
				<td height=20>&nbsp;</td>
			</tr>

			<tr>
				<td background="/uComposer/img/m000006img.gif"><img src="/uComposer/img/m000006img.gif" width="12" height=7></td>
			</tr>
		</table>
		*/ %>

		<input type="hidden" name="linenum" value="<%=linenum%>" >

	</form>

	<jsp:include page="/pages/common/copyright.jsp"/>

</body>

</html>
