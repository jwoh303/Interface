<%@ include file="form/jspheader.jsp" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%
	String status = (String)request.getAttribute("status");
	String flag = (String)request.getAttribute("flag");
	
	if (flag != null)
	{
	%>
			<!-- tr>
			  <td> &nbsp; </td>
			  <td><%= status %></td>
			  <td> &nbsp; </td>
	        </tr-->
	<%	if(flag.equals("success"))
		{
	%>
		<script language=javascript>
			opener.execute();
			alert('업로드를 성공하였습니다. 클릭하시면 창이 닫힙니다. ');
			self.close();
		</script>
	<%	
		} else if(flag.equals("fail"))
		{ %>
		<script language=javascript>
			alert('<%= status %>');
			
		</script>
<%		} else {
		}
	}
%>
<script type="text/javascript" language="JavaScript">
function check() {
  var ext = document.forms[0].fileName1.value;
  ext = ext.substring(ext.length-3,ext.length);
  ext = ext.toLowerCase();
  if(ext == "") {
  	alert('파일이 선택되지 않았습니다. 먼저 파일을 선택해주십시요!'); 
  	return false;
  }
  if(ext != 'xls') {
    alert('Excel 파일을 선택해주십시요!');
    return false; }
  else
    return true; }
</script>
<html>
<head>
<title><bean:message key="mainmenu.title" /></title>
<html:base/>
<link rel="stylesheet" href="../css/pub_ucube.css" style type="text/css">  
<script language="javascript" type="text/javascript" src="../js/common.js"></script>  
</head>

<body bgColor="#FFFFFF" LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0" onLoad="MM_preloadImages('../img/menu_cube_02_s.gif','../img/menu_cube_03_s.gif','../img/menu_cube_01.gif')">
<form action="../uploadFile.do" method="post" enctype="multipart/form-data" onsubmit="return check();">
<input type="hidden" name="status" value="<%= status%>" >
<table width="550" height="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<!--td background="../img/popup_back.jpg" valign=top align=left-->
		<td >&nbsp;</td>
		<td valign=top align=left>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
        		<tr>
					<td width="5">&nbsp;</td>
					<td height="%">&nbsp;</td>
        		</tr>
        		<!--tr>
					<td>&nbsp;</td>
					<td height="30"> </td>
        		</tr-->
        		<tr>
					<td>&nbsp;</td>
					<td height="20"> </td>
        		</tr>
				<tr> 
					<td colspan=2 background="../img/m000006img.gif" ><img src="/img/m000006img.gif" width="2" height="7"></td>
				</tr>         						
				<tr bgcolor=white> 
					<td colspan=2>&nbsp;<font size="3" color=#005DA1><b>Interface File Upload</b></font></td>
				</tr> 
				
				<tr bgcolor=white> 
					<td colspan=2 background="../img/m000006img.gif" ><img src="/img/m000006img.gif" width="2" height="7"></td>
				</tr>								
	    		<tr>
	        		<td colspan=2 align=right bgcolor=white>
						<img src="../img/m000012ico.gif" border=0 style="cursor:hand" onClick="location.href='/uComposer/pages/template.zip';" alt="다운로드">
						<input type=image src="../img/m000007ico.gif" class="image" alt="등록">	        			
						<img src="../img/m000005ico.gif" border=0 style="cursor:hand" onClick="javascript:window.close();" alt="닫기">
						&nbsp;&nbsp;&nbsp;
	        		</td>
	        	</tr>
				<tr bgcolor=white> 
					<td colspan=2 background="../img/m000006img.gif" ><img src="/img/m000006img.gif" width="2" height="7"></td>
				</tr> 
								       		
				<tr bgcolor="#FFFFFF" width=100%>
					<td width=5> </td>
					<td>
						<table width="100%" cellpadding="5" cellspacing="0" border="0">
							<tr class=tbllw>
								<td class="tbllw">&nbsp;<img src="../img/c4310001img.gif" align="absmiddle"> <b>File 등록시 유의사항 및 방법</b></td>
							</tr>
							<tr>
								<td>&nbsp;&nbsp;<img src="../img/dot_blue_ico.gif" align="absmiddle"> Export한 파일은 압축을 해제하고 [Microsoft Excel 통합문서]형식의 다른 이름으로 저장한다.</td>
							</tr>
							<tr>
								<td>&nbsp;&nbsp;<img src="../img/dot_blue_ico.gif" align="absmiddle"> 첫번째 WorkSheet에 입력 또는 삭제할 데이터를 작성하고 필터는 해제한다.</td>	
							</tr>
							<tr>
								<td>&nbsp;&nbsp;<img src="../img/dot_blue_ico.gif" align="absmiddle"> 항상 10번째 Row부터 데이터를 작성한다.</td>
							</tr>
							<tr>
								<td>&nbsp;&nbsp;<img src="../img/dot_blue_ico.gif" align="absmiddle"> 테스트예정일자, 가동일자 외의 모든 항목은 셀서식을 [일반]으로 한다.</td>
							</tr>
							<tr>
								<td>&nbsp;&nbsp;<img src="../img/dot_blue_ico.gif" align="absmiddle"> 등록위치지정항목에 [StartSetUp!], [EndSetUp!]을 반드시 입력한다.</td>
							</tr>
							<tr>
								<td>
									<div id="shadow" style="position:absolute;z-index:100;">
									<input name="fileName" type="file" style="filter:alpha(opacity:0);width:400;" onChange="document.forms[0].fileName1.value=this.value;this.blur();" onMouseOver="this.style.cursor='hand';">
									</div>
									<input name="fileName1" type="text" size="50" class="adb1" readonly >
									<img src="../img/m000029ico.gif" align="absmiddle">		
								</td>								
							</tr>
							<tr>
								<td>

								</td>
							</tr>														
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td >&nbsp;</td>
	</tr>
</table>																																																																						
</form>
</body>
</html>
