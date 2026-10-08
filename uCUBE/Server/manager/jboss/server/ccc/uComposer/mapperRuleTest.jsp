<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>

<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<script language="JavaScript" src="js/showErrorPopup.js"></script>

<%
	PosContext ctx = (PosContext)request.getAttribute( "PosContext" );

	int rCnt = 0;
	String ruleXslt = null;
	String transformStringData = null;
	if( ctx != null ) {
		PosRowSet rowSet = ctx.getRowSet( "ruleFindReslut" );
		if( rowSet != null ) {
			rCnt = rowSet.count();
		}
		if( ctx.get("ruleXslt") instanceof String){
			ruleXslt = (String) ctx.get("ruleXslt");
		} else {
			ruleXslt = request.getParameter("ruleXslt");
		}
			
		if( ctx.get("transformStringData") instanceof String){
			transformStringData = (String) ctx.get("transformStringData");
		} else {
			transformStringData = request.getParameter("transformStringData");
		}
	}
	
%>

<script>

function goClose() {
	self.close();
}

</script>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="css/pub.css" type="text/css">
	<title>uComposer Mapper</title>
</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin=0 leftmargin=0>

	<form name="mapperRuleTest" method="post" action="mapperRuleTestAction.do" >
		<input type="hidden" name="ServiceName" value="mapperRuleTest-service">
		<input type="hidden" name="rCnt" value=<%=rCnt%>>
		
		<table width=800 border=0 cellpadding=0 cellspacing=0>
			<tr>
				<td height="45" bgcolor="0E3F61">
					<table width="800" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="16">&nbsp;</td>
							<td>
								<font size="6" color="#FFFFFF">uComposer - Mapper Test </font>
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
							<td height=25><font size="4"><b>Mapper Rule 테스트</b></font></td>
						</tr>

						<tr>
							<td background="img/m000006img.gif"><img src="img/m000006img.gif" width="12" height=7></td>
						</tr>

						<tr>
							<td>
								<table width="780" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
									<tr>
										<td class="tbllg" height=25 width="120">
											<img src="img/m000008img.gif" width="7">
											<b>OUTPUT FORMAT</b>
											<!-- img src="img/m000008img.gif" width="7">
											<b><bean:message key="mapper.label.rulename"/></b-->
										</td>
										<td class="tbllg" height=25 width="%"> 
											<b>:</b>
											&nbsp;
											<select name=outputFormat style=width:70;height:18 class=adb1>
									        	<option value='FLAT'>FLAT</option>
									          	<option value='XML'>XML</option>
											</select>
											&nbsp;
										</td>
										<td class="tbllg" height=25 width="280" align="absmiddle">
											<div align="right">
												<!-- input type="image"  name="find"  src="img/m000001ico.gif"  onClick=""  valign="center"  -->
												<input type="image"  name="test"  src="img/m000010ico.gif"  onClick=""  valign="center" alt="테스트">
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
							<td height="10">
							</td>
						</tr>
						<tr>
							<td>
								<table width="%" border="1" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
									<tr class=tblcw>
										<td class="tbllb" align="absmiddle" width="100" height=23>
											<b><bean:message key="mapper.test.inputdata"/></b>
										</td>
										<td>
											<TEXTAREA name="inputData" rows="5" cols="100" ><%=request.getParameter("inputData")==null?"":request.getParameter("inputData")%></textarea>
											<!-- input type=text  name=inputData  style=width:650 style=height:18 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' value='<%=request.getParameter("inputData")==null?"":request.getParameter("inputData")%>' -->
										</td>
									</tr>
									<tr class=tblcw>
										<td class="tbllb" align="absmiddle" height=23>
											<b><bean:message key="mapper.test.outputdata"/></b>
										</td>
										<td><TEXTAREA name="transformStringData" rows="5" cols="100" readonly="readonly"><%=transformStringData==null?"":transformStringData %></textarea>
										    <!-- input type=text  name=transformStringData readonly="readonly" style=width:650 style=height:18 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' value='<%=transformStringData==null?"":transformStringData %>' -->
										</td>
									</tr>
									<tr class=tblcw>
										<td class="tbllb"  align="absmiddle" height=23>
											<b><bean:message key="mapper.test.rule"/></b>
										</td>
										<td>
											<TEXTAREA name="ruleXslt" rows="15" cols="100" readonly="readonly" onclick="this.select()" ><%=ruleXslt==null?"":ruleXslt%></textarea>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						
						<!-- posui:showTable
									tableName="ruleFindReslut"
									infoName="RuleFindReslut"
									columnNames="null|null|null|null|null"
									columnWidths="40|40|180|260|260"
									height="23"
									headerValues="OUTPUT_FORMAT_NO|OUTPUT_FORMAT_NAME|INPUT_FIELD_NAME|INPUT_FIELD_START|INPUT_FIELD_LENGTH"
									headerClasses="tbldb|tbldb"
									trClasses="tblcg|tblcw"
									tdClasses="tbllb|null|null|null|null"
									attributes="output_format_no|output_format_name|input_field_name|input_field_start|input_field_length"
						/-->
						
					</table>
				</td>
			</tr>
		</table>
	</form>
</body>

</html>
