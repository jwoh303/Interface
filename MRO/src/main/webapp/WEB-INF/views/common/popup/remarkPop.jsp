<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
String st_btoa_remark = CommonUtil.nvl((String) request.getParameter("st_btoa_remark"),"");  //  (조회조건)
st_btoa_remark = st_btoa_remark.replaceAll("&lt;br&gt;","\n");

String st_atob_remark = CommonUtil.nvl((String) request.getParameter("st_atob_remark"),"").replaceAll("<br>", "\r\n");  //  (조회조건)
st_atob_remark = st_atob_remark.replaceAll("&lt;br&gt;","\n");

String st_atoa_remark = CommonUtil.nvl((String) request.getParameter("st_atoa_remark"),"").replaceAll("<br>", "\r\n");  //  (조회조건)
st_atoa_remark = st_atoa_remark.replaceAll("&lt;br&gt;","\n");

String viewType = CommonUtil.nvl((String) request.getParameter("viewType"),"");  //  (조회조건)
String st_title = CommonUtil.nvl((String) request.getParameter("title"), ""); 
%>
<script type="text/javascript"> 

function init(){
<%--    $("#st_btoa_remark").val(<%=st_btoa_remark%>); --%>
}

function kepConfirm()
{ 
  var value1 = $("#st_btoa_remark").val();
  value1 = value1.replace(/\r?\n/g, '<br>');
  
  var value2 = $("#st_atob_remark").val();
  value2 = value2.replace(/\r?\n/g, '<br>');
  
  opener.setPopupReturn(value1,value2);
  this.close();
}


</script>  
<body onload="">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:304px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">비고</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        <input type="hidden" id="viewType" name="viewType" value="<%=viewType%>"/>
			<table class="cont_t_list05" style="background-color: #FAF9CF;">
                <tr> 
                <%
                	if ("A".equals(st_title)) {
                %>  	
               		<th >고객사<br>▶<br>운영자</th>	
                <%
                	} else if ("ATOB".equals(st_title)) {
                %>  	
               		<th >운영사<br>▶<br>고객사</th>	
                <%
                	} else if ("ATOA".equals(st_title)) {
                %>  	
               		<th >고객사<br>▶<br>운영자</th>	
                <% } else { %>
                    <th >고객사</th> 		
                <% } %> 		
                    <td >
               	<% if ("ATOB".equals(st_title)) {
                %>  	
                        <textarea id="st_atob_remark" name="st_atob_remark" style="width:100%; overflow:auto; border-color:white; border-width:0; background-color: #FAF9CF;" rows="5" cols="35" readonly><%=st_atob_remark%></textarea>
				<% } else { %>
                        <textarea id="st_btoa_remark" name="st_btoa_remark" style="width:100%; overflow:auto; border-color:white; border-width:0; background-color: #FAF9CF;" rows="5" cols="35" readonly><%=st_btoa_remark%></textarea>
				<% } %>
				
                    </td>
                </tr>
            </table>
            <table >
                <tr> 
                    <td></td>
                </tr>
            </table>
			<table >
                <tr>
                    <td height="5"></td>
                </tr>
            </table >
            <table class="cont_t_list05">
                <tr> 
                <%
                	if ("A".equals(st_title)) {
                %>  	
               		<th >운영사<br>▶<br>고객사</th>	
                <%
                	} else if ("ATOB".equals(st_title)) {
                %>  	
               		<th >고객사<br>▶<br>운영자</th>	
                <%
                	} else if ("ATOA".equals(st_title)) {
                %>  	
               		<th >운영사<br>▶<br>고객사</th>		
                <% } else { %>
                    <th >운영사</th> 		
                <% } %> 
                    <td >
                <%
                	if ("ATOB".equals(st_title)) {
                %>  	
                        <textarea name="st_btoa_remark" id="st_btoa_remark"  style="overflow:auto; border-color:white; border-width:0;" rows="5" cols="35" <%=("R".equals(viewType))?"readonly" :"" %> ><%=st_btoa_remark%></textarea>
                <% } else { %>
                        <textarea name="st_atob_remark" id="st_atob_remark"  style="overflow:auto; border-color:white; border-width:0;" rows="5" cols="35" <%=("R".equals(viewType))?"readonly" :"" %> ><%=st_atob_remark%></textarea>
                <% } %>      
                    </td>
                </tr>
            </table>
                <%
                	if ("ATOA".equals(st_title)) {
                %>  	
            <table class="cont_t_list05">
                <tr> 
                    <th >운영사</th> 		
                    <td >
	                    <textarea name="st_atoa_remark" id="st_atoa_remark"  style="overflow:auto; border-color:white; border-width:0;" rows="5" cols="35" <%=("R".equals(viewType))?"readonly" :"" %> ><%=st_atoa_remark%></textarea>
                    </td>
                </tr>
            </table>
                <% } %>      
<!--        	<textarea name="CONTEXT" id="CONTEXT"  rows="23"  style="width:100%"></textarea> -->
       	     <%
                	if (!"R".equals(viewType)) {
                %>  	
	       	<div class="btnArea ac mt20" style="margin-bottom:0px;"> 
			           	<span class="fr btn_02"><a href="javascript:kepConfirm()">확인</a></span> 
			</div>
			<% } %> 		
        </div>
    </div>
</body>
</html>
