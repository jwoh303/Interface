<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.posdata.glue.context.PosContext" %>
<%@ page import="com.posdata.glue.dao.vo.PosRowSet" %>
<%@ page import="com.posdata.glue.dao.vo.PosRow" %>

<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<script language="JavaScript" src="js/showErrorPopup.js"></script>
<script language="JavaScript" src="js/showInsertableRow.js"></script>
<script language="JavaScript" src="js/checkValidations.js"></script>
<script language="javascript" src="js/messcript.js"></script>


<%
	PosContext ctx = (PosContext)request.getAttribute( "PosContext" );
	int inputRowCnt = 0;
	int outputRowCnt = 0;
	
	String CONST_STR_STATUS = null;
	String interface_id = null;
	Integer rule_seq = null;
	Integer function_unit_seq = null;
	
	PosRowSet inputRowSet = null;
	PosRowSet outputRowSet = null;
	
	if( ctx != null ) {
		inputRowSet = ctx.getRowSet( "selectInputReslut" );
		if( inputRowSet != null ) {
			inputRowCnt = inputRowSet.count();
		}
		outputRowSet = ctx.getRowSet( "selectOutputReslut" );
		if( outputRowSet != null ) {
			outputRowCnt = outputRowSet.count();
		}
		if (ctx.get("CONST_STR_STATUS") instanceof String) CONST_STR_STATUS = (String) ctx.get("CONST_STR_STATUS");
		if (ctx.get("interface_id") instanceof String) interface_id = (String) ctx.get("interface_id");
		if (ctx.get("rule_seq") instanceof Integer) rule_seq = (Integer) ctx.get("rule_seq");
		if (ctx.get("function_unit_seq") instanceof Integer) function_unit_seq = (Integer) ctx.get("function_unit_seq");
		
	}
	
	String register = request.getParameter("register.x");
%>

<script>

function createTD(format,hiddenTable,chkname,seqName){
	var objSeq1 = seqName;
	
	if(objSeq1.length != null){
		for(var idx=0;idx<objSeq1.length;idx++) {
			//alert(idx);
			//alert(document.all.seq1[idx].value);
			temp = idx;
		}
		//alert(document.all.seq1[temp].value);
		objSeq1[temp].value = temp+1;		
	}

	insRow(format,hiddenTable,chkname);

	

//	alert(document.getElementById('seq1').value);
	
//	idx = chkname.value;
//	var seqObj = eval("document.forms[0]."+seqName[idx])==null?eval("document.forms[0]."+seqName):eval("document.forms[0]."+seqName[idx]);
//	if( seqObj != null ) seqObj.value = eval(idx+1);	
//document.all.inputFormat.rows + 1;
}

function checkValue() 
{
	// Input format check 값의 존재 여부 및 값의 정합성
	var objInputName = document.all.inputName;
	var objStart = document.all.start;
	var objLength = document.all.length;
	
	if(objInputName.length != null){
		for(var idx=0;idx<objInputName.length-1;idx++) {
			var inputName = objInputName[idx].value;
			var start = objStart[idx].value;
			var length = objLength[idx].value;
			
			if ((Trim(inputName) == "") || (Trim(start) == "") || (Trim(length) == "")) {
    			alert("Input Format 의 FIELD NAME, START, LENGTH 값이 입력되지 않았습니다.");
    			return false;
 			}
 			
 			if (!checkDigit(start) || !checkDigit(length)){
 				alert("START, LENGTH 값은 숫자만 입력이 가능합니다.");
 				return false;
 			}
		}
	}
	
	// Onput format check 값의 존재 여부 및 값의 정합성
	var objOutputName = document.all.outputName;
	var objInput = document.all.sel_input;
	
	if(objOutputName.length != null){
		for(var idx=0;idx<objOutputName.length-1;idx++) {
			var outputName = objOutputName[idx].value;
			var input = objInput[idx].value;
			
			if ((Trim(outputName) == "") || (Trim(input) == "")) {
    			alert("Output Format 의 FIELD NAME,INPUT 값이 입력되지 않았습니다.");
    			return false;
 			}
		}
	}
}

function create_input_select() {
	var objInputName = document.all.inputName;
	
	
	if(objInputName.length != null){
		for(var idx=1;idx<objInputName.length;idx++) {
			if( objInputName[idx].value != null) {
				var sel_input = document.getElementsByName("sel_input");
				for(var idx1=0;idx1<sel_input.length;idx1++) {
					sel_input[idx1].options[idx] = null;
				}
		    }
		}
		
		for(var idx=1;idx<objInputName.length;idx++) {
			if( objInputName[idx].value != null) {
				var sel_input = document.getElementsByName("sel_input");
				for(var idx1=0;idx1<sel_input.length;idx1++) {
					sel_input[idx1].options[idx] = new Option(idx,idx);
				}
		    }
		}
	}
}

function goClose() {
	self.close();
}

function testlink(ruleName) 
{
	window.open("/uComposer/mapperRuleTestAction.do?ServiceName=mapperRuleTest-service&find.x=1&ruleName="+ruleName,"popup","resizable=no,width=800,height=600");
}

function tooltip()
{
	tooltipOn('<table border=1 cellspacing=0 cellpadding=0 bordercolorlight=#666666 bordercolordark=#FFFFFF style=font-size:9pt><tr height=18>  <td width=80  class=tbldb>FUNCTION</td>  <td width=160 class=tbldb>내 용</td></tr><tr height=17>  <td class=tbllb>SUBSTITUTE</td>  <td class=tblcw>VALUE1 을 VALUE2로 SUBSTITUTE</td></tr><tr height=17>  <td class=tbllb>PADDING</td>  <td class=tblcw>VALUE1을 VALUE2로 PADDING</td></tr><tr height=17>  <td class=tbllb>SUBSTRING</td>  <td class=tblcw>VALUE1부터 VALUE2까지 SUBSTRING</td></tr><tr height=17>  <td class=tbllb>PREFIX</td>  <td class=tblcw>무조건 Data앞에 VALUE1를 INSERT</td></tr><tr height=17>  <td class=tbllb>SUFFIX</td>  <td class=tblcw>무조건 Data뒤에 VALUE1를 INSERT</td></tr><tr height=17>  <td class=tbllb>FIX</td>  <td class=tblcw>Data와 관계없이 무조건 VALUE1를 넣는다</td></tr></table>',CAPTION , 'FUNCTION 안내' , WIDTH ,250);
}
</script>

<html>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="css/pub.css" type="text/css">
	<title>uComposer Mapper</title>
	<!-- 풍선도움말을 위한 Div Layer --> 
	<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>
<base target="_self"/>	 
</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin=0 leftmargin=0 onload="create_input_select();">

<%if (register != null) {
	out.println("<script>alert('" + CONST_STR_STATUS +"');</script>");
} %>
	<form name="mapperRuleCreate" method="post" action="mapperRuleCreateAction.do">
		<input type="hidden" name="ServiceName" value="mapperRule-service">
		<posui:showMessage/>

		<table width=800 border=0 cellpadding=0 cellspacing=0>
			<tr>
				<td height="45" bgcolor="0E3F61">
					<table width="800" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="16">&nbsp;</td>
							<td>
								<font size="6" color="#FFFFFF">uComposer - Mapper Create </font>
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
							<td height=25><font size="4"><b>Mapper Rule 생성</b></font></td>
						</tr>

						<tr>
							<td background="img/m000006img.gif"><img src="img/m000006img.gif" width="12" height=7></td>
						</tr>

						<tr>
							<td>
								<table width="780" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
									<tr>
										<td class="tbllg" height=25 width="100">
											<img src="img/m000008img.gif" width="7">
											<b><bean:message key="mapper.label.rulename"/></b>
										</td>
										<td class="tbllg" height=25 width="%"> 
											<b>:</b>
											&nbsp;
												<input type="text" readonly="readonly" name="interface_id" style="width:200" class=adb1 onBlur="this.className='adb1';isNull(this.value)" onFocus=this.className='adf1' value="<%= interface_id==null?"":interface_id %>" TABINDEX="1" >
												<input type="hidden" name="interface_seq" value="<%=request.getParameter("interface_seq")%>"/>
												<input type="hidden" name="service_seq" value="<%=request.getParameter("service_seq")%>"/>
												<input type="hidden" name="function_unit_seq" value="<%=function_unit_seq%>"/>
											&nbsp;
										</td>
										<td class="tbllg" height=25 width="280" align="absmiddle">
											<div align="right">
												<input type="image"  name="register"  src="img/m000006ico.gif"  onClick="return checkValue();"  valign="center" alt="저장">
												<img src="img/m000010ico.gif" style="cursor:hand" onclick="testlink('<%= rule_seq %>')"  valign="center" alt="확인">
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
							<td background="img/m000006img.gif"><img src="img/m000006img.gif" width="12" height=7></td>
						</tr>
						<tr>
							<table width="760" border="0" cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF" align="center">
								<tr>
									<td class="tbllg" height=25 width=160>
										<img src="img/m000008img.gif" width="7">
										<b><bean:message key="mapper.create.inputformat"/></b>
										
										&nbsp;
									</td>
									<td class="tbllg" height=25 width="160" align="absmiddle">
										<div align="right">
											<img src="img/m000008butstx.gif" style="cursor:hand" onClick="javascript: createTD(inputFormat,inhiddenTable,document.forms[0].inchk,document.all.seq1); create_input_select();" valign="center" />&nbsp;<img src="img/m000007butstx.gif" style="cursor:hand" onClick="javascript: delRow(inputFormat,document.forms[0].inchk); create_input_select();" valign="center" />
										</div>
									</td>
									<td>
									&nbsp;
									</td>
									<td class="tbllg" height=25 width=210>
										<img src="img/m000008img.gif" width="7">
										<b><bean:message key="mapper.create.outputformat"/></b>
										
										&nbsp;
									</td>
									<td class="tbllg" height=25 width="210" align="absmiddle">
										<div align="right">
											<img src="img/m000008butstx.gif" style="cursor:hand" onClick="javascript: createTD(outputFormat,outhiddenTable,document.forms[0].outchk,document.all.seq2); create_input_select();" valign="center" />&nbsp;<img src="img/m000007butstx.gif" style="cursor:hand" onClick="javascript: delRow(outputFormat,document.forms[0].outchk)" valign="center" />
										</div>
									</td>
								</tr>
							</table>
						</tr>
						<tr>
							<table width="760" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
									<div align="right">
									<td align="absmiddle" valign="top">
										<div align="right">
											<table width="320" height=23 border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF"> 
									            <tr class=tbldb>  
									            	<td align="absmiddle"  width="30" height="23"><bean:message key="mapper.table.select"/></td> 
									                <td align="absmiddle"  width="35" height="23"><bean:message key="mapper.table.number"/></td> 
									                <td align="absmiddle"  width="%" height="23"><bean:message key="mapper.create.table.fieldname"/></td> 
									                <td align="absmiddle"  width="70" height="23"><bean:message key="mapper.create.table.start"/></td> 
									                <td align="absmiddle"  width="70" height="23"><bean:message key="mapper.create.table.length"/></td>
									                
									            </tr> 
									        </table> 

																													
											<table id="inputFormat" width="320" height=23 border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
											<% 	if (inputRowCnt == 0 ) { 
												%> 
									            <tr class=tblcw>  
									            	<td align="absmiddle"  width="30" height="23" class=tbllb>
									            		<input type=checkbox  name=inchk value=1> 
									            	</td> 
									                <td align="absmiddle"  width="35" height="23">
									                	<input type=text name=seq1 value="1" style="width:30;border:0px;text-align:center" readonly="readonly">
									                </td> 
									                <td align="absmiddle"  width="%" height="23">
									                	<input type=text  id=inputName name=inputName  style=width:90 style=height:18 class=adb1 value="" onBlur="this.className='adb1';isNull(this.value)" onFocus=this.className='adf1' >
													</td> 
									                <td align="absmiddle"  width="70" height="23">
									                	<input type=text  name=start style=width:60 style=height:18 class=adb1 value="" onBlur="this.className='adb1';isNull(this.value)" onFocus=this.className='adf1' >
									                </td> 
									                <td align="absmiddle"  width="70" height="23">
									                	<input type=text  name=length style=width:60 style=height:18 class=adb1 value="" onBlur="this.className='adb1';isNull(this.value)" onFocus=this.className='adf1' > 
									                </td>
									        	</tr> 
									        	<%} else { 
									        	PosRow row = null;
									        	for(int i = 0 ; i < inputRowCnt ; i++ ) {
									        		row = inputRowSet.next();
									        %>
									        	<tr class=tblcw>  
									            	<td align="absmiddle"  width="30" height="23" class=tbllb>
									            		<input type=checkbox  name=inchk value=1> 
									            	</td> 
									                <td align="absmiddle"  width="35" height="23">
									                	<input type=text name=seq1 style="width:30;border:0px;text-align:center" readonly="readonly" value=<%=row.getAttribute("INPUT_FIELD_NO")%> >
									                </td> 
									                <td align="absmiddle"  width="%" height="23">
									                	<input type=text  id=inputName name=inputName style=width:90 style=height:18 class=adb1 onBlur="this.className='adb1';isNull(this.value)" onFocus=this.className='adf1' value=<%=row.getAttribute("INPUT_FIELD_NAME")%> >
													</td> 
									                <td align="absmiddle"  width="70" height="23">
									                	<input type=text  name=start style=width:60 style=height:18 class=adb1 onBlur="this.className='adb1';isNull(this.value)" onFocus=this.className='adf1' value=<%=row.getAttribute("INPUT_FIELD_START")%>>
									                </td> 
									                <td align="absmiddle"  width="70" height="23">
									                	<input type=text  name=length style=width:60 style=height:18 class=adb1 onBlur="this.className='adb1';isNull(this.value)" onFocus=this.className='adf1' value=<%=row.getAttribute("INPUT_FIELD_LENGTH")%> > 
									                </td>
									        	</tr> 
									        <%	}
									        } 
									        %>
									        </table> 
									        
										</div>
									</td>
									<td width="20">&nbsp;</td>
									<td align="absmiddle" valign="top">
										<div align="right">
											<table width="420" height=23 border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF"> 
									            <tr class=tbldb>  
									            	<td align="absmiddle"  width="30" height="23"><bean:message key="mapper.table.select"/></td> 
									                <td align="absmiddle"  width="35" height="23"><bean:message key="mapper.table.number"/></td> 
									                <td align="absmiddle"  width="%" height="23"><bean:message key="mapper.create.table.fieldname"/></td> 
									                <td align="absmiddle"  width="45" height="23"><bean:message key="mapper.create.table.input"/></td> 
									                <td align="absmiddle"  width="80" height="23"><bean:message key="mapper.create.table.function"/></td> 
									                <td align="absmiddle"  width="60" height="23"><bean:message key="mapper.create.table.value1"/></td> 
									                <td align="absmiddle"  width="60" height="23"><bean:message key="mapper.create.table.value2"/></td> 
									            </tr> 
									        </table> 
											
												
											<table id="outputFormat" width="420" height=23 border=1 cellspacing="0" cellpadding="0" bordercolorlight="#666666" bordercolordark="#FFFFFF">
											<% 	if (outputRowCnt ==0 ) { 
												%> 
									            <tr class=tblcw>  
									            	<td align="absmiddle"  width="30" height="23" class=tbllb>
									            		<input type=checkbox  name=outchk value=1> 
									            	</td> 
									                <td align="absmiddle"  width="35" height="23">
									                	<input type=text name=seq2 value="1" style="width:30;border:0px;text-align:center" readonly="readonly">
									                </td> 
									                <td align="absmiddle"  width="%" height="23">
									                	<input type=text  name=outputName  style=width:85 style=height:18 class=adb1 onBlur="this.className='adb1';isNull(this.value)" onFocus=this.className='adf1' >
									                </td> 
									                <td align="absmiddle"  width="45" height="23">
									                	<select id=sel_input name=sel_input style=width:35;height:18 class=adb1">
												        	<!--option value='1'>1</option-->
												        </select>
									                </td> 
									                <td align="absmiddle"  width="80" height="23">
									                	<select name=function style=width:70;height:18 class=adb1>
									                		<option value=''>&nbsp;</option>
												        	<option value='SUBSTITUTE'>SUBSTITUTE</option>
												         	<!-- option value='PADDING'>PADDING</option> -->
												          	<option value='SUBSTRING'>SUBSTRING</option>
												          	<option value='PREFIX'>PREFIX</option>
												          	<option value='SUFIX'>SUFIX</option>
												          	<option value='FIX'>FIX</option>
												        </select>
									                </td> 
									                <td align="absmiddle"  width="60" height="23">
									                	<input type=text  name=value1 style=width:50 style=height:18 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' > 
									                </td>
									                <td align="absmiddle"  width="60" height="23">
									                	<input type=text  name=value2 style=width:50 style=height:18 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' > 
									                </td>
									            </tr> 
									        <%} else { 
									        	PosRow row = null;
									        	for(int i = 0 ; i < outputRowCnt ; i++ ) {
									        		row = outputRowSet.next();
									        		
									        		String tp = (String) row.getAttribute("TRANS_FUNCTION");
									        		String tp0 = ""; String tp1 = ""; String tp2 = ""; String tp3 = ""; String tp4 = ""; String tp5 = ""; String tp6 = ""; 
									        		if("SUBSTITUTE".equals(tp)) 	tp1="selected"; 
									        		else if("PADDING".equals(tp)) 	tp2="selected";
									        		else if("SUBSTRING".equals(tp)) tp3="selected"; 
									        		else if("PREFIX".equals(tp)) 	tp4="selected"; 
									        		else if("SUFIX".equals(tp)) 	tp5="selected"; 
									        		else if("FIX".equals(tp)) 		tp6="selected"; 
									        		else tp0="selected";
									        		
									        		int inputFieldNo = ((Integer) row.getAttribute("INPUT_FIELD_NO")).intValue();
									        		 
									        %>    
									        
									        
									            <tr class=tblcw>  
									            	<td align="absmiddle"  width="30" height="23" class=tbllb>
									            		<input type=checkbox  name=outchk value=1> 
									            	</td> 
									                <td align="absmiddle"  width="35" height="23">
									                	<input type=text id=seq2 name=seq2 style="width:30;border:0px;text-align:center" readonly="readonly" value=<%=row.getAttribute("OUTPUT_FORMAT_NO")%> >
									                </td> 
									                <td align="absmiddle"  width="%" height="23">
									                	<input type=text  name=outputName style=width:85 style=height:18 class=adb1 onBlur="this.className='adb1';isNull(this.value)" onFocus=this.className='adf1' value=<%=row.getAttribute("OUTPUT_FORMAT_NAME")%> >
									                </td> 
									                <td align="absmiddle"  width="45" height="23">
									                	<select id=sel_input name=sel_input style=width:35;height:18 class=adb1">
												        	<option selected value='<%= inputFieldNo %>'><%= inputFieldNo %></option>
												        </select>
									                </td> 
									                <td align="absmiddle"  width="80" height="23">
									                	<select name=function style=width:70;height:18 class=adb1>
									                		<option <%=tp0%> value=''>&nbsp;</option>
												        	<option <%=tp1%> value='SUBSTITUTE'>SUBSTITUTE</option>
												         	<!-- option <%=tp2%> value='PADDING'>PADDING</option> -->
												          	<option <%=tp3%> value='SUBSTRING'>SUBSTRING</option>
												          	<option <%=tp4%> value='PREFIX'>PREFIX</option>
												          	<option <%=tp5%> value='SUFIX'>SUFIX</option>
												          	<option <%=tp6%> value='FIX'>FIX</option>
												        </select>
									                </td> 
									                <td align="absmiddle"  width="60" height="23">
									                	<input type=text  name=value1 style=width:50 style=height:18 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' value=<%=row.getAttribute("TRANS_FUNCTION_FIELD1")==null?"":row.getAttribute("TRANS_FUNCTION_FIELD1")%>> 
									                </td>
									                <td align="absmiddle"  width="60" height="23">
									                	<input type=text  name=value2 style=width:50 style=height:18 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' value=<%=row.getAttribute("TRANS_FUNCTION_FIELD2")==null?"":row.getAttribute("TRANS_FUNCTION_FIELD2")%>> 
									                </td>
									            </tr> 
									        <%	}
									        } 
									        %>    
									        </table>	
									        <b onmouseover="tooltip();" onmouseout="tooltipOff();">function 도움말 </b>
										</div>
									</td>
								</tr>
							</table>
							
							<!-- posui:showTable
									tableName="selectInputReslut"
									infoName="selectInputReslut"
									columnNames="null|null|null|null"
									columnWidths="40|40|180|260"
									height="23"
									headerValues="input_field_no|input_field_name|input_field_start|input_field_length"
									headerClasses="tbldb|tbldb"
									trClasses="tblcg|tblcw"
									tdClasses="tbllb|null|null|null"
									attributes="input_field_no|input_field_name|input_field_start|input_field_length"
							/ -->
							<!-- posui:showTable
									tableName="selectOutputReslut"
									infoName="selectOutputReslut"
									columnNames="null|null|null|null|null|null|null"
									columnWidths="40|40|180|130|130|40|40"
									height="23"
									headerValues="output_format_no|output_format_name|input_format_seq|input_field_no|function|value1|value2"
									headerClasses="tbldb|tbldb"
									trClasses="tblcg|tblcw"
									tdClasses="tbllb|null|null|null|null|null|null"
									attributes="output_format_no|output_format_name|input_format_seq|input_field_no|trans_function|trans_function_field1|trans_function_field2"
							/ -->
						</tr>

					</table>
				</td>
			</tr>
		</table>
	</form>

<div STYLE=display:none> 
<table id=inhiddenTable width=320 align=null border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666  bordercolordark=FFFFFF> 
 
  	<tr  class=tblcg height=18>  
    		<td index=0 width=30 class=tbllb> 
        		<input type=checkbox name=inchk value=0  > 
    		</td> 
 
	    	<td index=0 value='1' width=35 align="absmiddle"> 
	        	<input type=text name=seq1 value="1" style="width:30;border:0px;text-align:center" readonly="readonly">
	    	</td> 
	 
	    	<td index=0 width=%> 
	        	<input type=text  id=inputName name=inputName  style=width:90 style=height:18 class=adb1 onBlur="this.className='adb1';isNull(this.value)" onFocus=this.className='adf1' > 
	    	</td> 
	 
	    	<td index=0 width=70> 
	        	<input type=text  name=start style=width:60 style=height:18 class=adb1 onBlur="this.className='adb1';isNull(this.value)" onFocus=this.className='adf1' > 
	    	</td> 
	 
	    	<td index=0 width=70> 
	        	<input type=text  name=length style=width:60 style=height:18 class=adb1 onBlur="this.className='adb1';isNull(this.value)" onFocus=this.className='adf1' > 
	    	</td> 
	</tr> 
</table>

<table id=outhiddenTable width=420 align=null border=1 cellpadding=0 cellspacing=0 bordercolorlight=666666  bordercolordark=FFFFFF> 
 
  	<tr  class=tblcg height=18>  
    		<td index=0 width=30 class=tbllb> 
        		<input type=checkbox  name=outchk value=0  > 
    		</td> 
 
	    	<td index=0 value='1' width=35 align="absmiddle"> 
	        	<input type=text name=seq2 value="1" style="width:30;border:0px;text-align:center" readonly="readonly">
	    	</td> 
	 
	    	<td index=0 width=%> 
	        	<input type=text  name=outputName  style=width:85 style=height:18 class=adb1 onBlur="this.className='adb1';isNull(this.value)" onFocus=this.className='adf1' > 
	    	</td> 
	 
	    	<td index=0 width=45> 
	    		<select id=sel_input name=sel_input style=width:35;height:18 class=adb1">
				<!--option value='1'>1</option-->
				</select>
	    	</td> 
	 
	    	<td index=0 width=80> 
	        	<select name=function style=width:70;height:18 class=adb1>
	        		<option value=''>&nbsp;</option>
		        	<option value='SUBSTITUTE'>SUBSTITUTE</option>
		         	<!-- option value='PADDING'>PADDING</option> -->
		          	<option value='SUBSTRING'>SUBSTRING</option>
		          	<option value='PREFIX'>PREFIX</option>
		          	<option value='SUFIX'>SUFIX</option>
		          	<option value='FIX'>FIX</option>
		        </select> 
	    	</td> 
	    	
	    	<td index=0 width=60> 
	        	<input type=text  name=value1 style=width:50 style=height:18 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' > 
	    	</td>
	    	 
	    	<td index=0 width=60> 
	        	<input type=text  name=value2 style=width:50 style=height:18 class=adb1 onBlur=this.className='adb1' onFocus=this.className='adf1' > 
	    	</td> 
	    	<input type=hidden  name=hiddnesal value='800'> 
	</tr> 
</table> 
</div> 

</body>

</html>
