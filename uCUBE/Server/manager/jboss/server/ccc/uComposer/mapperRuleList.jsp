<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>

<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<script language="JavaScript" src="js/showErrorPopup.js"></script>
<script language="javascript" src="js/messcript.js"></script>


<%
	PosContext ctx = (PosContext)request.getAttribute( "PosContext" );
	int rCnt = 0;
	if( ctx != null ) {
		PosRowSet rowSet = ctx.getRowSet( "MapperResutlList" );
		if( rowSet != null ) {
			rCnt = rowSet.count();
		}
	}
%>


<script>

function goClose() {
	self.close();
}

function testlink(ruleName) 
{
	window.open("/uComposer/mapperRuleTestAction.do?ServiceName=mapperRuleTest-service&find.x=1&ruleName="+ruleName,"popup","resizable=no,width=800,height=600");
}

function modifylink() 
{
	var objCheck = document.all.chk;
	var objruleID = document.all.ruleID;
	var objdescription = document.all.description;
	
	if(objCheck==null) return;
	if(objruleID==null) return;
	
	var selectcount = 0;
	var ruleID = null;
	if( objCheck.length != null) {
		for(var idx=0;idx<objCheck.length;idx++) {
			if( objCheck[idx].checked ) { 
				ruleID = objruleID[idx].value;
				selectcount++;
			}
		}
	}
	
	if( selectcount == 0 ) {
		errmessage = "수정할 항목을 선택하세요";
		alert(errmessage); 
	} else if (selectcount != 1) {
	 	errmessage = "한개의 항목을 선택하세요";
	 	alert(errmessage); 
	} else {
		window.open("/uComposer/mapperRuleCreateAction.do?ServiceName=mapperRule-service&find1.x=1&ruleID=" + ruleID, "popup","resizable=no,width=800,height=600");
	}
}

</script>


<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="css/pub.css" type="text/css">
	<title>uComposer Mapper</title>
	<!-- 풍선도움말을 위한 Div Layer --> 
	<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div> 
</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin=0 leftmargin=0>

	<form name="mapperRuleList" method="post" action="mapperRuleListAction.do" >
		<input type="hidden" name="ServiceName" value="mapperRule-service">
		<posui:showMessage/>

		<table width=800 border=0 cellpadding=0 cellspacing=0>
			<tr>
				<td height="45" bgcolor="0E3F61">
					<table width="800" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="16">&nbsp;</td>
							<td>
								<font size="6" color="#FFFFFF">uComposer - Mapper </font>
							</td>
						</tr>
					</table>
				</td>
			</tr>

			<tr>
				<td height="10"></td>
			</tr>

			<tr>
				<td>
					<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td height=25><font size="4"><b>Mapper Rule 조회</b></font></td>
						</tr>

						<tr>
							<td background="img/m000006img.gif"><img src="img/m000006img.gif" width="12" height=7></td>
						</tr>

						<tr>
							<td>
								<table width="780" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
									<tr>
										<td class="tbllg" height=25 width="400">
											<img src="img/m000008img.gif" width="7">
											<b><bean:message key="mapper.label.rulename"/> :</b>
											<% if( request.getParameter("ruleName") != null ){ %>
												<input type="text" name="ruleName" style="width:200" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' value="<%= request.getParameter("ruleName") %>">
											<% }else { %>
												<input type="text" name="ruleName" style="width:200" class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' value="">
											<%}%>
											&nbsp;

											
										</td>
										<td class="tbllg" height=25 width="380" align="absmiddle">
											<div align="right">
												<input type="image"  name="find"  src="img/m000001ico.gif"  onClick=""  valign="center" alt="조회">
												<img src="img/m000007ico.gif" style="cursor:hand" onClick=window.open("mapperRuleCreate.jsp","popup","resizable=no,width=800,height=600") valign="center" alt="신규생성"/>
												<img src="img/m000003ico.gif" style="cursor:hand" onClick="modifylink();" valign="center" alt="수정"/>
												<input type="image"  name="delete"  src="img/m000009ico.gif"  onClick=""  valign="center" alt="삭제">
												<img src="img/m000005ico.gif" style="cursor:hand" onClick="javascript: return goClose()"  valign="center" alt="종료">
											</div>
										</td>
									</tr>
								</table>
							</td>
						</tr>

						<tr>
							<td background="img/m000006img.gif"><img src="img/m000006img.gif" width="12" height=7></td>
						</tr>

						<tr>
							<td>
								<table width="780" border="1" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
									<tr height=25>
										<td class="tbldb" height=25 width=40 ><bean:message key="mapper.table.select"/></td>
										<td class="tbldb" height=25 width=40 ><bean:message key="mapper.table.number"/></td>
										<td class="tbldb" height=25 width=180 onmouseover="tooltipOn('<table border=1 cellspacing=0 cellpadding=0 bordercolorlight=#666666 bordercolordark=#FFFFFF style=font-size:9pt><tr height=18><td width=150 class=tbldb>XSLT TEST 를 수행</td></tr></table>', WIDTH, 150 )" onmouseout="tooltipOff();"><bean:message key="mapper.list.table.rulename"/></td>
										<td class="tbldb" height=25 width=520 ><bean:message key="mapper.list.table.description"/></td>
									</tr>
									
									<%
										if( ctx != null ) {
											PosRowSet rowSet = ctx.getRowSet( "MapperResutlList" );
											PosRow row = null;
											
											String trClasses = "tblcg";
											String tdClasses = "tbllb";
											
											if( rowSet != null ) {
												for( int i=0; i<rowSet.count(); i++ ) {
													row = rowSet.next();
													trClasses= trClasses.equals("tblcg")?"tblcw":"tblcg";														
									%>
									<tr class=<%=trClasses%> >
										<td class="tbllb" height=25 width= 40><input type=checkbox name="chk" value=<%=i%>></td>
										<td height=23 width= 40><%=i+1%> </td>
										<td height=23 style="cursor:hand" width=180 onclick="testlink('<%=row.getAttribute("rule_id")%>')" ><u><%=row.getAttribute("rule_id")%> </u></td>
										<input type=hidden name=ruleID  value=<%=row.getAttribute("rule_id")%>>
										<td height=23 width=520><%=row.getAttribute("description")==null?"&nbsp;":row.getAttribute("description")%> </td>
									</tr>
									<%			} // for						
											} //if
										} //if
									%>
								</table>
								<!-- posui:showTable
									tableName="mapperResutlList"
									infoName="MapperResutlList"
									columnNames="chk|null|null|null"
									columnWidths="40|40|180|520"
									height="23"
									headerValues="선택|번호|RULE NAME|DESCRIPTION"
									headerClasses="tbldb|tbldb"
									trClasses="tblcg|tblcw"
									tdClasses="tbllb|null|null|null"
									tdEvents="null|null|onClick=javascript: return printindex(this.parentElement.index)|null"
									displayTypes="checkno|no|link|null"
									attributes="null|null|rule_id|description"
								/-->
							</td>
						</tr>

					</table>
				</td>
			</tr>
		</table>
	</form>

</body>

</html>
