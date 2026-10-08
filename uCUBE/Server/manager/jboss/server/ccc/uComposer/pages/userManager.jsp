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
    PosContext ctx = (PosContext)request.getAttribute("PosContext");
	// 현재날짜
	java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    
    List objVal = new ArrayList();
    
    try {
		if(ctx!=null && ctx.get("userManager")!=null) {
			objVal = (ArrayList)ctx.get("userManager");
		}
	}
	catch(Exception e) {
		out.println(e);
	}
	
    //String userID =(String)ctx.get("SessionID");
   // System.out.println("sessionID :"+sessionID);
	String userID = (String) session.getAttribute("IDDDDD");
	System.out.println("session :"+userID);
	int totalCount = objVal==null?0:objVal.size();
	
	// 조회 혹은 등록
	String regResult = null;
	String actionFlag = request.getParameter("actionFlag");
	if( "modify".equals(actionFlag) || "delete".equals(actionFlag) || "add".equals(actionFlag)) 
	{
		regResult = (String)ctx.get(IConstant.CONST_STR_STATUS);
	}	
	
%>
<html>
<head>
<%@ include file="/pages/form/htmlheader.jsp"%>

<script language="javascript" src="js/checkAll.js"></script>
<script language="javascript" src="js/editField.js"></script>
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
    	
	//searching();
	userManagerAddTbl.style.display='none';
	Processing.style.display=''; 
    document.forms[0].submit();
}

function copyData(obj) {
	var idxs = obj;
	if(idxs.value==''){ document.body.focus(); return; }
	idxs.select();
	var clip=idxs.createTextRange()
	clip.execCommand('copy');
	alert('클립보드에 복사되었습니다');
}
function addClick()
{
	//openWindow('/uComposer/userManagerAdd.do?actionFlag=add);
	userManagerAddTbl.style.display='block'; 
}

function registUser()
{
	thisForm = document.forms[0];
	alert(" 사용자 추가 메뉴입니다. ");
	if(thisForm.UserEmpNoP.value == "" || thisForm.HandPhoneP.value == "" || thisForm.EaiUserPasswordP.value == "" )
	{
		alert("사용자 ID 및 Password, 핸드폰번호는  필수 항목입니다.");
	} else {
		if(thisForm.smsChecked.checked)
		{
			thisForm.SmsRcvFlagP.value = "Y";
		} else {
			thisForm.SmsRcvFlagP.value = "N";
		}
		
		if(thisForm.EaiUserPasswordP.value != thisForm.EaiUserPasswordP1.value) 
		{ 
		   alert("비밀번호를 재확인 해주세요"); 
		   thisForm.EaiUserPasswordP.focus();
		   return;
		}
		if(!MinLengthValidator(thisForm.EaiUserPasswordP,3) || !MinLengthValidator(thisForm.EaiUserPasswordP1,3)) 
		{ 
		   alert("비밀번호의 길이는 4~12 입니다."); 
		   thisForm.EaiUserPasswordP.focus(); 
		   return;
		}
		if(!isPhoneCheck(thisForm.HandPhoneP)) 
		{
		   alert("핸드폰 번호의 형식이 맞지 않습니다."); 
		   thisForm.HandPhoneP.focus(); 
		   return;
		 }			
		//if(!checkEmail(thisForm.EmailAddressP.value)) {alert("이메일 주소를 확인하세요"); thisForm.EmailAddressP.focus(); return;}
		if(!isIDCheck(thisForm.UserEmpNoP)) 
		{
		   alert("아이디는 영문,숫자 조합이며 특수문자는 사용할 수 없습니다."); 
		   thisForm.UserEmpNoP.focus(); 
		   return;
		 }			
		if(!MinLengthValidator(thisForm.UserEmpNoP,3)) 
		{
		   alert("아이디의 길이는 4~12 입니다."); 
		   thisForm.UserEmpNoP.focus(); 
		   return;
		}			

		thisForm.action = "userManager.do?actionFlag=add";
		thisForm.submit();
		//document.forms[0].submit()
	}
}

function saveClick(event)
{
	var objCheck = document.all.check;
	if(objCheck==null) return;
	
	var message = "";
	var errmessage = ""
	if(event=="modify") message = "정말로 수정하시겠습니까?";
	else if (event=="delete") message = "정말로 삭제하시겠습니까?";
	else {
		alert("잘못된 요청정보입니다."); return;
	}
	
	var selectcount = 0;
	if( objCheck.length == null) {
	    alert("objCheck.length null 입니다 ");
		if(objCheck.checked) {
			if(!isPhoneCheck(document.forms[0].handPhone)) {alert("핸드폰 번호를 확인하세요"); document.form[0].handPhone.focus(); return;}			
			//if(event=="modify" && !checkEmail(document.forms[0].emailAddress.value)) {alert("e-Mail Address를 확인하세요"); document.forms[0].emailAddress.select(); return; }
			selectcount++;
		}
	} else {
		for(idx=0;idx<objCheck.length;idx++) {
			if( objCheck[idx].checked ) { 
			   
				if(!isPhoneCheck(document.forms[0].handPhone[idx])){
				 	alert("핸드폰 번호를 확인하세요"); 
					document.forms[0].handPhone[idx].focus(); return;}
				// Admin 은 삭제 불가능하도록 함
					if(event=="delete"){
					if(document.forms[0].h_userEmpNo[idx].value == "admin") {alert("admin 은 삭제할 수 없습니다."); return;}
					if(document.forms[0].h_userEmpNo[idx].value == document.forms[0].userID.value) {alert("현재 사용자 ID 는 삭제할 수 없습니다."); return;}
					}
				//if(event=="modify" && !checkEmail(document.forms[0].emailAddress[idx].value)) {alert("e-Mail Address를 확인하세요"); document.forms[0].emailAddress[idx].select();return; }
				selectcount++;
			 }
		}
	}
	if( selectcount == 0 ) {
		if(event=="modify") errmessage = "수정할 항목을 선택하세요";
		else if (event=="delete") errmessage = "삭제할 항목을 선택하세요";
		alert(errmessage); 
	}
	else {
		if(confirm(message)) {
			document.forms[0].actionFlag.value = event;
			document.forms[0].submit();
		}
	}
}
function typeDesc() 
{
	this[0] = 'userName';
	this[1] = 'sysUserTpP';
	this[2] = 'handPhone';
	this[3] = 'emailAddress';
	this[4] = 'smsRcvFlagP';
	
}
function MinLengthValidator(input, length)
{
	return input.value.length > length;
}

function checkEmail(str){
	var regExp = /[a-z0-9]{2,}@[a-z0-9-]{2,}\.[a-z0-9]{2,}/i;

	if(!regExp.test(str)) {
		return false;
	} else {
		return true;
	}
}
function isIDCheck(input) { 
	return checkID(input.value);
}
function checkID(str){
	var regExp = /^[a-zA-Z0-9]+$/;

	if(!regExp.test(str)) {
		return false;
	} else {
		return true;
	}
}
function isPhoneCheck(input) { 
	return checkPhone(input.value);
//	var chars = "0123456789( ).-,<>{}[]_~";
//	return containsCharsOnly(input,chars);
}

function containsCharsOnly(input,chars) {
	for (var inx = 0; inx < input.value.length; inx++) {
		if (chars.indexOf(input.value.charAt(inx)) == -1)
		return false;
	}
	return true;
}
function checkPhone(str){
	var regExp = /[0-9]{3,}-[0-9]{3,}-[0-9]{4,}/;

	if(!regExp.test(str)) {
		return false;
	} else {
		return true;
	}
}	


</script>
</head>

<body topmargin=0 leftmargin=0 onLoad="MM_preloadImages('img/ucube_img04_menu_over.gif','img/ucube_img05_menu_over.gif','img/ucube_img06_menu_over.gif','img/ucube_img07_menu_over.gif','img/ucube_img08_menu_over.gif','img/clock.gif')">

<form method="post" action="userManager.do">
<input type="hidden" name="ServiceName" value="userManager-service" />
<input type="hidden" name="find.x" value="1" />

<%@ include file="userManagerAdd.jsp"%>
<%@ include file="searching.jsp"%>
<input type="hidden" id="actionFlag" name="actionFlag" value="">

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
<%@ include file="header.jsp"%>

		<table width="980" border="0" cellspacing="0" cellpadding="0">
			<tr bgcolor=white> 
				<td height=25> 
					<table width="980" height="25" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<img src="img/comm_img02_blank.gif" width="5" height="10">
								<img src="img/comm_img03_ic.gif" width="11" height="10"><span class="bluetit"><img src="img/comm_img02_blank.gif" width="5" height="10"></span>
								<span class="tit01">User Manager</span>
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
					              		<td width="250">
					              			<img src="img/comm_img02_blank.gif" width="10" height="10">
					              			<img src="img/comm_img06_ic.gif" width="10" height="3"> <b>사용자 ID</b>
						    				<input type="text" size="15" maxlength="20" name="userEmpNo" Class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" />						    	
			        					</td>
					              		<td height="25" valign="middle" align="right">
					              			<img src="img/comm_img07_but.gif" width="55" height="21" style="cursor:hand" align="absmiddle" onclick="execute()">
					              			<img src="img/m000007ico.gif" style="cursor:hand" align="absmiddle" onClick="addClick();" alt="등록">
				        					<img src="img/m000003ico.gif" style="cursor:hand" align="absmiddle" onclick="saveClick('modify');" alt="수정">
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
   			<tr bgcolor=white> 	
				<td height=25>
					<table border=0 width=100%>
						<tr>
							<td width=5> </td>
							<!-- 수행결과 -->							
<%	if( "modify".equals(actionFlag) || "delete".equals(actionFlag) || "add".equals(actionFlag) ) {	
		out.println("<script>alert('" + regResult +"');//document.forms[0].submit();</script>");
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
									<tr class=tbldb height=25>
										<TD WIDTH=50>
											<img src="img/m000009img.gif" border=0 align="absmiddle" style="cursor:hand" onClick="javascript:js_check_able(document.forms[0]);">
										</TD>
										<td width=140>사용자ID</td>
										<td width=160>접근레벨</td>
										<td width=140>사용자명</td>
										<td width=%>헨드폰 번호</td>
										<td width=200>E-Mail</td>
										<td width=120>SMS 수신여부</td>
									</tr>
								</table>
								</div>
								<DIV id="mainDisplay" style="width:980px;height:340px;overflow-y:scroll;overflow-x:hidden" onscroll="scrollY()">
								<table width="960" border="1" cellpadding="1" cellspacing="0" bordercolor="#FFFFFF" bordercolorlight="#626262" bordercolordark="White" bgcolor="#FFFFFF" class="tblbc" valign="TOP" style="table-layout:fixed">     				
<%	if( objVal != null ) 
	{
		String cssClass = "tblcg";
		
		for(int i=0; i<objVal.size(); i++) {
			UserVO vo = (UserVO)objVal.get(i);
			cssClass = "tblcg".equals(cssClass)==true?"tblcw":"tblcg";
			
			// 권한결정
			String tp = vo.getSysUserTp();
			String tp1 = ""; 
			String tp2 = ""; 
			String tp3 = "";
			
			if("Manager".equals(tp)) tp1="selected"; 
			else if("Admin".equals(tp)) tp2="selected"; 
			else tp3="selected";
			
			// SMS수신여부 결정
			String smsflag = vo.getSmsRcvFlag()==null?"":vo.getSmsRcvFlag();
			String smsflag1 = ""; String smsflag2 = "";
			if("Manager".equals(tp)) smsflag1="selected"; else smsflag2="selected";
%>
								<tr class=<%=cssClass%>>
									<TD WIDTH=50><input type=checkbox name=check value='<%=i%>' onClick="abledbox(<%=i%>);"></TD>
									<td width=140>
										<b><%=vo.getUserEmpNo()%><b>
										<input type=hidden name=h_userEmpNo value='<%=vo.getUserEmpNo()%>'>
									</td>
									<td width=160>
										<input type=text name="_sysUserTpP" value="<%=tp%>" readonly  style="border-width:0px;" class="<%=cssClass%>">
										<select name="sysUserTpP" style="display:none;" class="adf">
											<option value="1" <%=tp1%>>Manager</option>
											<option value="3" <%=tp2%>>Developer</option>
											<!--option value="1" <%=tp3%>>Admin</option-->
										</select>									
									</td>
									<td width=140><input type=text name=userName value="<%=vo.getLastName()==null?"":vo.getLastName()%>" readonly  style="border-width:0px;" class="<%=cssClass%>"></td>
									<td width=%><input type=text name=handPhone value="<%=vo.getHandPhone()==null?"":vo.getHandPhone()%>" readonly  style="border-width:0px;" class="<%=cssClass%>"></td>
									<td width=200><input type=text size=30 maxlength=50 name=emailAddress value="<%=vo.getEmailAddress()==null?"":vo.getEmailAddress()%>" readonly  style="border-width:0px;" class="<%=cssClass%>"></td>
									<td width=120>
										<input type=text name="_smsRcvFlagP" value="<%=smsflag%>" readonly  style="border-width:0px;" class="<%=cssClass%>">
										<select name="smsRcvFlagP" style="display:none;" class="adf">
											<option value="Y" <%=smsflag1%>>Y</option>
											<option value="N" <%=smsflag2%>>N</option>
										</select>																						
									</td>
								</tr>			
<%		
		}
		if( objVal != null && objVal.size() == 0) {	
%>								<tr height=21><td colspan=9 align=center>검색된 결과가 없습니다.</td></tr>
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
<input type=hidden name=userID value='<%=userID%>'>
<script>
<!--
function scrollX() {
	document.all.mainDisplay.scrollLeft = document.all.bottomLine.scrollLeft;
	document.all.topLine.scrollLeft = document.all.bottomLine.scrollLeft;
}
-->
</script>	
<%@ include file="footer.jsp"%>
</form>
</body>
</html>
