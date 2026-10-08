<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.posdata.glue.context.PosContext,
                java.util.ArrayList" %>
<%@ taglib uri="/WEB-INF/gluetag.tld" prefix="posui" %>
<jsp:useBean id="infoBean" class="com.posdata.glue.ui.tags.GetInfoBean"/>
<html>
<head>
<%@ include file="/pages/form/htmlheader.jsp" %>
<title>uComposer Service Config</title><%

    PosContext ctx = (PosContext)request.getAttribute( "PosContext" );
    int linenum = 0;
    String alertMessage = null;
    String currentTime = "";
    if( ctx != null ) {
        alertMessage = (String)ctx.get( "alertMessage" );
        currentTime = (String)ctx.get( "currentTime" );
    }
%>
<script language="javascript" type="text/javascript">
<!--
<% if( alertMessage != null ) { %>
    alert("<%=alertMessage %>");
<% } %>
var chk_flg;
function uCUBE_setEvent( btn )
{
    if( btn=="find" )
    {
        document.forms[0].hidden_event.value = btn;
        return true;
    } else if( btn=="delete" )
    {
        if(confirm("삭제하시겠습니까?"))
        {
            document.forms[0].hidden_event.value = btn;
            return true;
        }
    } else
    {
        if(document.forms[0].hidden_event.value=="create"){
            var target_url = "/uComposer/serviceConfigManagerPopupAction.do?ServiceName=serviceConfigManager-service&find.x=1&hidden_event=create";
            returnValue = window.showModalDialog(target_url,"","dialogWidth:900px;dialogHeight:620px;status:yes;");
            if(returnValue=="create"){
                document.forms[0].hidden_event.value = "find";
                document.forms[0].action = document.forms[0].action+"?find.x=1";
                document.forms[0].submit();
            }
        } else {
            var target_url = "/uComposer/serviceConfigManagerPopupAction.do?ServiceName=serviceConfigManager-service&find.x=1&hidden_event=modify";
            if(document.forms[0].chk.length>1){
                for(i=0; i<document.forms[0].chk.length; i++){
                    if(document.forms[0].chk[i].checked){
                        target_url = target_url+"&hidden_service="+document.forms[0].directory[i].value+"&hidden_filename="+document.forms[0].file_info[i].value ;
                        window.showModalDialog(target_url,"","dialogWidth:900px;dialogHeight:620px;stauts:yes;");
                    }
                }
            }else{
                    if(document.forms[0].chk.checked){
                        target_url = target_url+"&hidden_service="+document.forms[0].directory.value+"&hidden_filename="+document.forms[0].file_info.value ;
                        window.showModalDialog(target_url,"","dialogWidth:900px;dialogHeight:620px;stauts:yes;");
                    }
            }
        }
    }
    return false;
}
function uCUBE_toggleButton(checkbox_obj,imgsrc1,imgsrc2)
{
    var _form = eval("document.forms[0]." + checkbox_obj.name);
    var cnt = _form.length
    chk_flg = 0;
    if( cnt > 1)
    {
        for( i=0; i<cnt ; i++)
        {
            if(_form[i].checked == true ) chk_flg = chk_flg+1;
        }
    } else
    {
        if( _form.checked == true) chk_flg = 1;
    }
    var imgname = document.getElementById('insert');
    if(chk_flg==1){
        document.forms[0].hidden_event.value="modify";
        imgname.src = imgsrc2;
    } else {
        document.forms[0].hidden_event.value="create";
        imgname.src = imgsrc1;
    }
    return;
}
function goClose() {
    self.close();
}
-->
</script>
</head>
<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div><!-- 풍선도움말을 위한 Div Layer -->
<body bgcolor="#FFFFFF" text="#000000" topmargin=0 leftmargin=0>
<%@ include file="/pages/header.jsp" %>
<form name="serviceConfigManager" method="post" action="serviceConfigManagerAction.do">
<input type="hidden" name="ServiceName" value="serviceConfigManager-service">
<input type="hidden" name="hidden_event" value="create"><!-- checkbox 클릭시 변경, 조회|삭제 버튼클릭시 변경 -->
<!--세로간격-->
<table width="980" height="25" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td>
            <img src="/uComposer/img/comm_img02_blank.gif" width="5" height="10"><img src="/uComposer/img/comm_img03_ic.gif" width="11" height="10"><span class="bluetit"><img src="/uComposer/img/comm_img02_blank.gif" width="5" height="10"></span>
            <span class="tit01">Service Config</span>
        </td>
    </tr>
</table>
<!--세로간격 끝-->
<!--검색조건-->
<table width="980" border="1" cellpadding="2" cellspacing="0" bordercolor="#FFFFFF" bgcolor="#FFFFFF">
    <tr>
        <td height="25" bordercolor="999999" bgcolor="F8F3E8">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="search">
                <tr>
                  <td height=25>
                      <img src="/uComposer/img/comm_img02_blank.gif" width="10" height="10">
                      <img src="/uComposer/img/comm_img06_ic.gif" width="10" height="3">
                      <b>Service:</b>
                      <select name=service_config_type>
                        <option value=all>----------all----------</option><%
              ArrayList service = (ArrayList)ctx.get("service_config_types");
              if(service!=null)
              {
                  String prev = request.getParameter("service_config_type")==null?"all":request.getParameter("service_config_type");
                  for(int i=0, iz=service.size(); i<iz; i++)
                  {
                      String selected = prev.equals(service.get(i))?" selected":""; 
%>
                        <option value='<%=service.get(i)%>'<%=selected%>><%=((String)service.get(i))%></option><%
                  }
              }
                        %>
                      </select>
                      <img src="/uComposer/img/comm_img02_blank.gif" width="10" height="10">
                      <img src="/uComposer/img/comm_img06_ic.gif" width="10" height="3">
                      <b>File Name:</b>
                      <input type="text" name="file_name" style="width:100" Class="adb1" onblur="this.className='adb1'" onfocus="this.className='adf1'" onkeyup="this.value=upperCase(this.value);" value="<%= request.getParameter("file_name")==null?"":request.getParameter("file_name") %>">
                  </td>
                  <td height=25 valign="middle" align=right>
                      <input type=image name=find src="img/m000001ico.gif" border=0 onclick="return uCUBE_setEvent('find');"">
                      <img id="insert" src="img/m000007ico.gif" border=0 onclick="uCUBE_setEvent('insert');" style="cursor:pointer">
                      <input type=image name=delete  src="img/m000009ico.gif"border=0 onclick="return uCUBE_setEvent('delete');">
                      <img name=close src="img/m000005ico.gif" border=0 onclick="goClose();" style="cursor:pointer">
                      <!--
                      <posui:showUtilityButtons
                          names="find|insert|delete|close"
                          onClick="uCUBE_setEvent('find')|javascript:return uCUBE_setEvent('insert')|uCUBE_setEvent('delete')|javascript: return goClose()"
                          imgs="/uComposer/img/m000001ico.gif|img/m000007ico.gif|img/m000009ico.gif|img/m000005ico.gif"
                      />
                      -->
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
    <tr height=25 class="tblcb1">
        <td><img src="img/m000009img.gif" border=0 onClick="selectAll(chk);" style='cursor:hand'></td>
        <td width=45%>Service</td>
        <td width=50%>FileName</td>
    </tr><%
              ArrayList fileinfo = (ArrayList)ctx.get("service_config_files");
              if(fileinfo!=null){
                  for(int i=0, iz=fileinfo.size(); i<iz; i++){
                      Object[] obj = (Object[])fileinfo.get(i);
%>
    <tr height=25>
        <td align=center><input type=checkbox name=chk value=<%=i%> onClick="uCUBE_toggleButton(this, 'img/m000007ico.gif', 'img/m000028ico.gif')"></td>
        <td>&nbsp;<%=obj[0]%><input type=hidden name=directory value="<%=obj[0]%>"></td>
        <td>&nbsp;<%=obj[1]%><input type=hidden name=file_info value="<%=obj[1]%>"></td>
    </tr><%
                  }
              }
%>
</table>
<input type=hidden name=chk_cnt value=0>
</form>
<div style="display:none">
<form name="popup" method="post" action="serviceConfigManagerAction.do">
<input type=text name=directory value="">
<input type=text name=filename value="">
<textarea name=filecontent></textarea>
</form>
</div>
<jsp:include page="/pages/common/copyright.jsp"/>
</body>
</html>
