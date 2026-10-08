<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.posdata.glue.context.PosContext,
                java.util.ArrayList" %>
<html>
<head>
<title>uComposer Service Config - File Edit</title>
<%@ include file="/pages/form/htmlheader.jsp" %>
<script language="JavaScript">
function setEvent(value)
{
    if(value=='create' && confirm("등록 하시겠습니까?")){
        document.forms[0].hidden_event.value=value;
        return true;
    }else if(value=='modify' && confirm("수정 하시겠습니까?")){
        document.forms[0].hidden_event.value=value;
        return true;
    }
    return false;
}
</script>
<base target="_self"/>
</head><%
    PosContext ctx = (PosContext)request.getAttribute( "PosContext" );
    String hidden_event = request.getParameter("hidden_event");
    String hidden_service = request.getParameter("hidden_service");
    String hidden_filename = request.getParameter("hidden_filename");
    String close = (String)ctx.get("closeModalDailog");
%>
<body bgcolor="#FFFFFF" text="#000000" topmargin=0 leftmargin=0 <%=close!=null?"onLoad=self.close();window.returnValue=\""+hidden_event+"\";":""%>>
<form name="serviceConfigManager_popup" method="post" action="serviceConfigManagerPopupAction.do">
<input type="hidden" name="ServiceName" value="serviceConfigManager-service">
<input type="hidden" name="hidden_event" value="<%=hidden_event%>">
<!--세로간격-->
<table width="860" height="25" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td>
            <img src="/uComposer/img/comm_img02_blank.gif" width="5" height="10"><img src="/uComposer/img/comm_img03_ic.gif" width="11" height="10"><span class="bluetit"><img src="/uComposer/img/comm_img02_blank.gif" width="5" height="10"></span>
            <span class="tit01">Service Config File : <%=hidden_event%> </span>
        </td>
    </tr>
</table>
<!--세로간격 끝-->
<!--검색조건-->
<table width="860" border="1" cellpadding="2" cellspacing="0" bordercolor="#FFFFFF" bgcolor="#FFFFFF">
    <tr>
        <td height="25" bordercolor="999999" bgcolor="F8F3E8">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="search">
                <tr height=25>
                  <td>
                      <img src="/uComposer/img/comm_img02_blank.gif" width="10" height="10"><img src="/uComposer/img/comm_img06_ic.gif" width="10" height="3">
                      <b>Service:</b><%
          if(hidden_service==null){
%>
                      <select name="service_config_type" class=adf><%
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
                      <img src="/uComposer/img/comm_img02_blank.gif" width="10" height="10"><img src="/uComposer/img/comm_img06_ic.gif" width="10" height="3">
                      <b>File Name:</b>
                      <input type="text" name="file_name" style="width:200" class=adf value=""><%
          }else{
%>
                      <input type="hidden" name="service_config_type" value="<%=hidden_service%>" readonly><%=hidden_service%>
                      <img src="/uComposer/img/comm_img02_blank.gif" width="10" height="10"><img src="/uComposer/img/comm_img06_ic.gif" width="10" height="3">
                      <b>File Name:</b>
                      <input type="hidden" name="file_name" value="<%=hidden_filename%>" readonly><%=hidden_filename%><%
          }
%>
                  </td>
                  <td valign=bottom align=right><% if("modify".equals(hidden_event)){%>
                      <input type=image name="update" src="img/m000028ico.gif" onClick="javascript:return setEvent('modify')"><%}else{%>
                      <input type=image name="insert" src="img/m000007ico.gif" onClick="javascript:return setEvent('create')"><%}%>
                      <input type=image name="close" src="img/m000005ico.gif" onClick="javascript:window.close();return false;">&nbsp;
                  </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<table width="860" height="8" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td>
        </td>
    </tr>
</table>
<table width="860" height="8" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td align=center>
          <textarea name="content" class=adb style="height:500px;width:858px;"><%=ctx.get("file_contents")==null?"":ctx.get("file_contents")%></textarea>
        </td>
    </tr>
</table>
<!--검색조건 끝-->