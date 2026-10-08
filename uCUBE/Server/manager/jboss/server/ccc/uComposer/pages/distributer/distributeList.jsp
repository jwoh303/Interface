<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>

<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<script language="JavaScript" src="js/showErrorPopup.js"></script>
<script language="JavaScript" src="js/showBubbleHelp.js"></script>

<%@ include file="/pages/form/htmlheader.jsp" %>

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


<script language="JavaScript" >

<% if( alertMessage != null ) { %>
	alert("<%=alertMessage %>");
<% } %>

function clickChkAll() {
	var chkdeployList = document.getElementsByName("chkdeploy");
	var boolChkAll = document.getElementById("chkall").checked;
	
	for( var i=0; i<chkdeployList.length; i++ ) {	
		if(!chkdeployList[i].disabled)	
			chkdeployList[i].checked = boolChkAll;
	}

}

function clickChkDeploy( idx, recursive ) {
	var objLen = document.getElementsByName("refsgs").length;
	if(objLen < 2) return;
	
	var boolChk = document.formDistList.chkdeploy[idx].checked;
	if(!boolChk && document.getElementById("chkall").checked) document.getElementById("chkall").checked = false;
	
	if(!recursive && boolChk && !confirm("Check related group(s)?")) 
		return;
	else if(!recursive && !boolChk) 
		return;
	
	var i, j, k;
	var objValue = document.formDistList.refsgs[idx].value.split("|");
	
	for(i=0;i<objValue.length;i++) {
		if(objValue[i]!="") {
			for(j=0;j<objLen;j++) {
				if(boolChk!=document.formDistList.chkdeploy[j].checked) {
					var tmpValue = document.formDistList.refsgs[j].value.split("|");
					for(k=0;k<tmpValue.length;k++) {
						if(objValue[i]==tmpValue[k]) {
							document.formDistList.chkdeploy[j].checked = boolChk;
							clickChkDeploy( j, true );
						}
					}
				}
			}
		}
	}
}


function init() {
	MM_preloadImages('img/I01_img25.gif','img/I01_img27.gif','main/img/I01_img04_1.gif','img/ucube_img04_menu_over.gif','img/ucube_img05_menu_over.gif','img/ucube_img06_menu_over.gif','img/ucube_img07_menu_over.gif','img/ucube_img08_menu_over.gif');
}


function showToolTip( tgname, index ) {
	var evalstr = "formDistList." + tgname + ((formDistList.linenum.value>1)?"[index]":"") + ".value";
	var msg = eval( evalstr );
	tooltipOn( msg );
}


function goClose() {
	self.close();
}

</script>


<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<style type="text/css">
		body { margin-left: 10px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; }
	</style>
	<link href="css/pub_ucube.css" rel="stylesheet" type="text/css">


	<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>  <!-- 풍선도움말을 위한 Div Layer -->
	<title>uComposer Distribute</title>
</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin=0 leftmargin=0 onload="init()">

	<form name="formDistList" method="post" action="distributeListAction.do" >
		<input type="hidden" name="ServiceName" value="distributeList-service">
		<posui:showMessage/>

		<%@ include file="/pages/header.jsp" %>

		<!--세로간격-->
		<table width="980" height="25" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<img src="/uComposer/img/comm_img02_blank.gif" width="5" height="10"><img src="/uComposer/img/comm_img03_ic.gif" width="11" height="10"><span class="bluetit"><img src="/uComposer/img/comm_img02_blank.gif" width="5" height="10"></span>
					<span class="tit01">Distribute</span>
				</td>
			</tr>
		</table>
		<!--세로간격 끝-->

		<!--검색조건-->
		<table width="980"  border="1" cellpadding="2" cellspacing="0" bordercolor="#FFFFFF" bgcolor="#FFFFFF" >
			<tr>
				<td height="25" bordercolor="999999" bgcolor="F8F3E8">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="search">
						<tr>
							<td height=25 width="700">
								<img src="/uComposer/img/comm_img02_blank.gif" width="10" height="10"><img src="/uComposer/img/comm_img06_ic.gif" width="10" height="3">
								<b>System:</b>
								<% if( request.getParameter("inputsystem") != null ){ %>
									<input type="text" name="inputsystem" style="width:100" class=adff value="<%= request.getParameter("inputsystem") %>">
								<% }else { %>
									<input type="text" name="inputsystem" style="width:100" class=adff value="">
								<%}%>

								<img src="/uComposer/img/comm_img02_blank.gif" width="10" height="10"><img src="/uComposer/img/comm_img06_ic.gif" width="10" height="3">
								<b>Service:</b>
								<% if( request.getParameter("inputservice") != null ){ %>
									<input type="text" name="inputservice" style="width:100" class=adff value="<%= request.getParameter("inputservice") %>">
								<% }else { %>
									<input type="text" name="inputservice" style="width:100" class=adff value="">
								<%}%>

								<img src="/uComposer/img/comm_img02_blank.gif" width="10" height="10"><img src="/uComposer/img/comm_img06_ic.gif" width="10" height="3">
								<b>IFID:</b>
								<% if( request.getParameter("inputifid") != null ){ %>
									<input type="text" name="inputifid" style="width:100" class=adff value="<%= request.getParameter("inputifid") %>">
								<% }else { %>
									<input type="text" name="inputifid" style="width:100" class=adff value="">
								<%}%>
							</td>
							<td height=25 width="280" align="absmiddle">
								<div align="right">
									<posui:showUtilityButtons
										names="find|distribute|close"
										onClick="null|null|javascript: return goClose()"
										imgs="/uComposer/img/m000001ico.gif|img/distribute.gif|img/m000005ico.gif"
									/>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<!--검색조건 끝-->

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
				<td class="tblcb1" height=25 width=100>수정자</td>
				<td class="tblcb1" height=25 width=80 >수정시간</td>
				<td class="tblcb1" height=25 width=70 >분배&nbsp;<input type="checkbox" id="chkall" name="chkall" onClick="clickChkAll()"></td>
				<td class="tblcb1" height=25 width=70 >처리상태</td>
			</tr>

			<%
				if( ctx != null ) {
					PosRowSet rowSet = ctx.getRowSet( "DistListResult" );
					PosRow row = null;
					PosRow row2 = null;
					if( rowSet != null ) {
						String sgid1 = null;
						String sgid2 = null;
						String sid1 = null;
						String sid2 = null;
						int sgcnt = 1, scnt = 1;
						boolean isNext = false;
						boolean isPrevious = false;
						boolean isEnd = false;
						boolean isSGCheck = false;
						boolean isDeploied = false;
						String status_flag = null;
						String status_flag2 = null;
						String statusdre = null;
						String statusd = null;
						String statusd2 = null;
						String statusr = null;
						String refsgs = null;


						String IFID = null;
						String[] redIFIDs = (ctx.get("redIFIDs")!=null) ? (String[])ctx.get("redIFIDs") : null;
						boolean isRefIFIDs = false;
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
									status_flag = null;
									statusd = null;
									isEnd = false;
									sgid2 = (String)row.getAttribute( "SERVICE_GROUP_ID" );
									status_flag2 = (row.getAttribute("STATUS_FLAG")!=null) ? (String)row.getAttribute( "STATUS_FLAG" ) : null;
									statusd2 = (row.getAttribute("DISPATCHED_TIME")!=null) ? (String)row.getAttribute( "DISPATCHED_TIME" ) : null;
									isPrevious = false;
									while( true ) {
										// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"] #2<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], sgid1 = [" + sgid1 + "]<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], sgid2 = [" + sgid2 + "]<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], statusd = [" + statusd + "]<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], statusd2 = [" + statusd2 + "]<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], status_flag2 = [" + status_flag2 + "]<br>" );

										if( sgid1 == null ) {
											sgid1 = sgid2;
											status_flag = status_flag2;
											statusd = statusd2;
										}
										else if( !sgid2.equals( sgid1 ) || (status_flag!=null && !status_flag.equals(status_flag2)) || (statusd!=null && !statusd.equals(statusd2)) ) isPrevious = true;

										// ★★★★★ out.println( "★★★★★ i=["+i+"], isPrevious = [" + isPrevious + "]<br>" );

										isNext = false;
										if( !isPrevious ) {
											if( rowSet.hasNext() ) {
												sgcnt++;
												isNext = true;
												row2 = rowSet.next();
												// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], rowSet.next();<br>" );
												// ★★★★★ out.println( "★★★★★ i=["+i+"], sgcnt=["+sgcnt+"], row2.SERVICE_SEQ = [" + row2.getAttribute( "SERVICE_SEQ" ) + "], row2.SERVICE_ID = ["+row2.getAttribute( "SERVICE_ID" )+"], row2.INTERFACE_ID = ["+row2.getAttribute( "INTERFACE_ID" )+"]<br>" );
												sgid2 = (String)row2.getAttribute( "SERVICE_GROUP_ID" );
												status_flag2 = (row2.getAttribute("STATUS_FLAG")!=null) ? (String)row2.getAttribute( "STATUS_FLAG" ) : null;
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
											status_flag = status_flag2;
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
									status_flag = null;
									statusd = null;
									isEnd = false;
									sid2 = (String)row.getAttribute( "SERVICE_ID" );
									status_flag2 = (row.getAttribute("STATUS_FLAG")!=null) ? (String)row.getAttribute( "STATUS_FLAG" ) : null;
									statusd2 = (row.getAttribute("DISPATCHED_TIME")!=null) ? (String)row.getAttribute( "DISPATCHED_TIME" ) : null;
									isPrevious = false;
									while( true ) {
										// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"] #2<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"], sid1 = [" + sid1 + "]<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"], sid2 = [" + sid2 + "]<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"], statusd = [" + statusd + "]<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"], statusd2 = [" + statusd2 + "]<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"], status_flag = [" + status_flag + "]<br>" );
										// ★★★★★ out.println( "★★★★★ i=["+i+"], scnt=["+scnt+"], status_flag2 = [" + status_flag2 + "]<br>" );

										if( sid1 == null && sid2 != null ) {
											sid1 = sid2;
											status_flag = status_flag2;
											statusd = statusd2;
										}
										else if( sid2==null || !sid2.equals( sid1 ) || (status_flag!=null && !status_flag.equals(status_flag2)) || (statusd!=null && !statusd.equals(statusd2)) ) isPrevious = true;

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
												status_flag2 = (row2.getAttribute("STATUS_FLAG")!=null) ? (String)row2.getAttribute( "STATUS_FLAG" ) : null;
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
											status_flag = status_flag2;
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
								if( redIFIDs != null && IFID != null ) {
									isRefIFIDs = false;
									for( int r=0; r<redIFIDs.length; r++ ) {
										if( IFID.equals( redIFIDs[r] ) ) {
											isRefIFIDs = true;
											break;
										}
									}
								}
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
									isDeploied = (statusd != null) ? true : false;
								}

								out.println( "    <td height=23 width=100 " + ((!isDeploied&&isRefIFIDs)?"style=background-color:red;color:yellow":"") + ">" + ((IFID!=null)?IFID:"&nbsp;") + "</td>" );
								out.println( "    <td width=170>" + ((row.getAttribute("SERVICE_GROUP_TYPE_ID")!=null) ? (String)row.getAttribute( "SERVICE_GROUP_TYPE_ID" ) : "&nbsp;") + "</td>" );
								out.println( "    <td width=100>" + ((row.getAttribute("USER_ID")!=null) ? (String)row.getAttribute( "USER_ID" ) : "&nbsp;") + "</td>" );
								out.println( "    <td width=80 >" + ((row.getAttribute("LAST_UPDATED_TIME")!=null) ? row.getAttribute( "LAST_UPDATED_TIME" ) : "&nbsp;") + "</td>" );

								if( isSGCheck ) {
									refsgs = (row.getAttribute("REF_SG_IDS")!=null) ? (String)row.getAttribute( "REF_SG_IDS" ) : null;

									out.println( "    <td rowspan=" + sgcnt + " width=70>" );
									//out.println( "        <input type=\"checkbox\" name=\"chkdeploy\" value=\"" + (linenum-1) + "\" onClick=\"clickChkDeploy('refsgs',"+(linenum-1)+")\" " + ((isDeploied)?"disabled":"") + ">" );
									out.println( "        <input type=\"checkbox\" name=\"chkdeploy\" value=\"" + (linenum-1) + "\" onClick=\"clickChkDeploy("+(linenum-1)+", false)\" " + ((isDeploied)?"disabled":"") + ">" );
									out.println( "    </td>" );
									out.println( "    <td rowspan=" + sgcnt + " width=70>" );
									%>
										<table border="0" cellspacing="0" cellpadding="0" width=100%>
											<tr align=center>
												<td>
													<%
														statusdre = (String)row.getAttribute( "REDISPATCHED_TIME" );
														if( statusdre.length() > 0 ) {
															out.println( "        <img src=\"/uComposer/img/statusdre.gif\" onmouseover=\"showToolTip('statusdre',"+(linenum-1)+");\" onmouseout='tooltipOff();'>" );
														}
														out.println( "        <img src=\"/uComposer/img/statusd" + ((statusd!=null)?"3":"1") + ".gif\" " + ((statusd!=null)?"onmouseover=\"showToolTip('statusd',"+(linenum-1)+");\" onmouseout='tooltipOff();'":"") + ">" );
													%>
												</td>
												<td><% out.println( "        <img src=\"/uComposer/img/statusr" + ((statusr!=null)?"3":"1") + ".gif\" " + ((statusr!=null)?"onmouseover=\"showToolTip('statusr',"+(linenum-1)+");\" onmouseout='tooltipOff();'":"") + ">" ); %></td>
											</tr>
										</table>
									<%
									out.println( "    </td>" );
									out.println( "   <input type=\"hidden\" name=\"sgseq\" value=\"" + ((Integer)row.getAttribute( "SERVICE_GROUP_SEQ" )).toString() + "\">" );
									out.println( "   <input type=\"hidden\" name=\"statusdre\" value=\"" + ((statusdre.length()>0)?statusdre:"") + "\">" );
									out.println( "   <input type=\"hidden\" name=\"statusd\" value=\"" + ((statusd!=null)?statusd:"") + "\">" );
									out.println( "   <input type=\"hidden\" name=\"statusr\" value=\"" + ((statusr!=null)?statusr:"") + "\">" );
									out.println( "   <input type=\"hidden\" name=\"refsgs\" value=\"" + ((refsgs!=null)?refsgs:"") + "\">" );

 									isSGCheck = false;
								}

								out.println( "</tr>" );
								
							}
						}
					}
				}
			%>
		</table>

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
				<td height=25 width="960" align="absmiddle">
					<div align="right">
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td valign="middle">처리상태 초기화&nbsp;</td>
								<td>
									<input type="image" name="distreset" src="/uComposer/img/distreset.gif" OnClick="" alt="처리상태 초기화">
								</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>

			<tr>
				<td background="/uComposer/img/m000006img.gif"><img src="/uComposer/img/m000006img.gif" width="12" height=7></td>
			</tr>

			<% /*
			<tr>
				<td>
					<posui:showTable
						tableName="distlisttable"
						infoName="DistListResult"
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
			*/ %>
		</table>

		<input type="hidden" name="linenum" value="<%=linenum%>" >

	</form>
	
	<jsp:include page="/pages/common/copyright.jsp"/>

</body>

</html>
