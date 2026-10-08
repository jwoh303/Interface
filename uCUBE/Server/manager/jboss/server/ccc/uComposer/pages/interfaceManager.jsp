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
<%@ page import = "com.posdata.glue.dao.vo.*,
                   com.posdata.eai.manager.util.*"%>

<%@ page import = "java.util.*" %>

<%
	PosContext ctx = (PosContext)request.getAttribute( "PosContext" );
	// 현재날짜
	java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

	Object[] objVal = new Object[]{};
	try {
		if(ctx!=null && ctx.get("interfaceList")!=null) 
			objVal = (Object[])ctx.get("interfaceList");
	}
	catch(Exception e) {
		out.println(e);
	}
	int totalCount = objVal==null?0:objVal.length;
	
	// 조회 혹은 등록
	String regResult = null;
	String actionFlag = request.getParameter("actionFlag");
	if( "delete".equals(actionFlag) || "edit".equals(actionFlag)) {
		regResult = (String)ctx.get(IConstant.CONST_STR_STATUS);
	}
%>

<html>
<head>
<%@ include file="/pages/form/htmlheader.jsp"%>

<script language="javascript" src="js/selectAll.js"></script>
<script language="javascript" src="js/enableCheck.js"></script>
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
    	
	document.forms[0].actionFlag.value= 'search';
	searching();
    	document.forms[0].submit();
}
function saveClick(event)
{
	var objCheck = document.all.check;
	if(objCheck==null) return;
	
	var message = "";
	if(event=="edit") {
		message = "정말로 수정하시겠습니까?";		
	}
	else if (event=="delete") {
		message = "정말로 삭제하시겠습니까?";
	}
	else {
		alert("잘못된 요청정보입니다."); return;
	}
	
	var selectcount = 0;
	if( objCheck.length == null) {
		if(objCheck.checked) selectcount++;
	} else {
		for(idx=0;idx<objCheck.length;idx++) {
			if( objCheck[idx].checked ) { selectcount++; break; }
		}
	}
	if( selectcount == 0 ) {
		if (event=="edit") alert("수정할 항목을 선택하세요"); 
		else alert("삭제할 항목을 선택하세요"); 
	}
	else {
		if(confirm(message)) {
			document.forms[0].actionFlag.value = event;
			document.forms[0].submit();
		}
	}
}
function clickLine(idx){
	var objCheck = document.all.check;
	if(objCheck==null) return;
	
	if( objCheck.length == null) {
		objCheck.checked = true;
	} else {
		objCheck[idx].checked = true;
	}
}

</script>
</head>

<body topmargin=0 leftmargin=0 onLoad="MM_preloadImages('img/ucube_img04_menu_over.gif','img/ucube_img05_menu_over.gif','img/ucube_img06_menu_over.gif','img/ucube_img07_menu_over.gif','img/ucube_img08_menu_over.gif','img/clock.gif')">
<form method="post" action="interfaceManager.do">
<input type="hidden" name="ServiceName" value="interfaceManager-service" />
<input type="hidden" name="find.x" value="1" />
<input type="hidden" name="update.x" value="1" />
<input type="hidden" name="delete.x" value="1" />


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

<!-- event search/delete/edit -->
<input type="hidden" name="actionFlag" value="">

		<table width="980" border="0" cellspacing="0" cellpadding="0">
			<tr bgcolor=white> 
				<td height=25> 
					<table width="980" height="25" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<img src="img/comm_img02_blank.gif" width="5" height="10"><img src="img/comm_img03_ic.gif" width="11" height="10"><span class="bluetit"><img src="img/comm_img02_blank.gif" width="5" height="10"></span>
								<span class="tit01">Interface Manager</span>
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
	        				<!-- 조회조건  -->
	        				<td height="25" bordercolor="999999" bgcolor="F8F3E8">            
					        	<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="search">
					            	<tr>
					              		<td width="%">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>인터페이스ID</b>
					            			<input type="text" size="15" maxlength="12" name="interfaceID" class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" />
										</td>
										<td width="%">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>트랜잭션코드</b>
					            			<input type="text" size="13" maxlength="8" name="tccode" class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" />
										</td>
										<td width="%">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>송신시스템</b>
					            			<input type="text" size="10" maxlength="8" name="sendSystem" class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" />
										</td>
										<td width="%">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>수신시스템</b>
					            			<input type="text" size="10" maxlength="8" name="recvSystem" class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" />
										</td>
					              		<td height="25" valign="middle" align="right">
					              			<img src="img/comm_img07_but.gif" width="55" height="21" style="cursor:hand" align="absmiddle" onclick="execute()">
					              			<img src="img/m000007ico.gif" style="cursor:hand" align="absmiddle" onclick="javascript:openWindow('/uComposer/pages/uploadFile.jsp');" alt="엑셀등록">
						        			<img src="img/m000009ico.gif" style="cursor:hand" align="absmiddle" onclick="saveClick('delete');" alt="삭제">
					              			<img src="img/comm_img08_but.gif" width="55" height="21" style="cursor:hand" align="absmiddle" onclick="openHelp()">
					              		</td>
					            	</tr>
					          	</table>	  
					       	</td>
	        			</tr>
	        		</table>  
        		</td>
        	</tr>
			
			<!-- total count  -->
			<tr bgcolor=white>
				<td height=25>
					<table border=0 width=100%>
						<tr>
							<td width=5> </td>
							<!-- 수행결과 -->							
<%	if( "delete".equals(actionFlag) || "edit".equals(actionFlag) ) {	
		out.println("<script>alert('" + regResult +"');execute();</script>");
%>
							<td align=right width=975 valign=bottom><%if(regResult!=null || !"".equals(regResult)) { %><%="수행결과 : " + regResult%><%} %>&nbsp;&nbsp;</td>
<%	} else {	%>
							<td align=right width=975 valign=bottom><%if(objVal!=null) { %>총 <%=totalCount%>건이 조회되었습니다.<% } %>&nbsp;&nbsp;</td>		
<%	}			%>
						</tr>
					</table>
				</td>	
			</tr>			        		
		</table>
		<!-- data start -->
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
										<TD WIDTH=50>
											<img src="img/m000009img.gif" border=0 align="absmiddle" style="cursor:hand" id='selectall_list' value='selectall_list' name="chkinterfaceListTable" onclick="selectAll(check);">
										</TD>
										<TD WIDTH=100>인터페이스ID</TD> 
										<TD WIDTH=90>트랜잭션코드</TD> 
										<td WIDTH=100>송신업무구분</td>
										<td WIDTH=80>송신시스템</td>
										<td WIDTH=100>송신 IP</td>
										<td WIDTH=70>송신타입</td>
										<td WIDTH=110>수신업무구분</td>
										<td WIDTH=80>수신시스템</td>
										<td WIDTH=100>수신 IP</td>
										<td WIDTH=70>수신타입</td>
									</TR>                                              
								</TABLE>
								</DIV>   
								<DIV id="mainDisplay" style="width:980px;height:340px;overflow-y:scroll;overflow-x:hidden" onscroll="scrollY()">
								<table width="960" border="1" cellpadding="1" cellspacing="0" bordercolor="#FFFFFF" bordercolorlight="#626262" bordercolordark="White" bgcolor="#FFFFFF" class="tblbc" valign="TOP" style="table-layout:fixed">     				
<%							
	if( objVal != null ) {
		
		// 라인색 및 반복데이터 제거
		String last_data = null; String curr_data = null;
		boolean samedata = false;
		String cssClass = "tblcg";
		
		for(int i=0; i<objVal.length; i++) {
			InterfaceListVO vo = (InterfaceListVO)objVal[i];
			
			curr_data = vo.getIfid();
			if( i==0 ) last_data = curr_data;
			
			// 같은 IF ID를 사용할 경우 다음 라인에서 출력하지 않음
			if(i!=0 && last_data.equals(curr_data)) samedata = true;
			else {
				samedata = false;
				cssClass = "tblcg".equals(cssClass)==true?"tblcw":"tblcg";
			}			
%>									
								<tr class=<%=cssClass%> height=21>
									<TD WIDTH=50><input type=checkbox name=check value='<%=i%>'></TD>									
									<TD WIDTH=100>
<!--										<input type="text" name="ifid" value="<%=vo.getIfid()%>" class="<%=cssClass%>" style="border-width:px;text-align:left;font-size:12px;height:17;width:96;cursor:hand" onClick="clickLine(<%=i%>);"> -->
										<%=vo.getIfid()%>
									</TD> 
									<TD WIDTH=90 hint="<%= vo.getTcName()==null?"값이 존재하지 않습니다.":vo.getTcName()%>"><%=vo.getTccode()%></TD>
									<td WIDTH=100><%=vo.getSendServiceSection()%></td>
									<td WIDTH=80><%=vo.getSendSystemID()%></td>
									<td WIDTH=100><%=vo.getSendIPAddress()%></td>
									<td WIDTH=70><%=vo.getSendType()%></td>
									<td WIDTH=110><%=vo.getRecvServiceSection()%></td>
									<td WIDTH=80><%=vo.getRecvSystemID()%></td>
									<td WIDTH=100><%=vo.getRecvIPAddress()%></td>
									<td WIDTH=70><%=vo.getRecvType()%></td>
										<input type=hidden name=h_sequence value='<%=vo.getSequence()%>'>
								
								</tr>			
<%			last_data = curr_data;
		}
		if( objVal != null && objVal.length == 0) {	
%>								<tr height=21><td colspan=9 align=center>검색된 결과가 없습니다.</td></tr>
<%		}		
	}
%>
							</table>		
							</DIV>
							
		    				</td>
					</tr>
					<tr>
															
					</tr>
    			</table>
    		</td>
    	</tr>
    </table>
    		<!-- data end -->
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
<%@ include file="/pages/footer.jsp"%>
</form>
</body>
</html>
