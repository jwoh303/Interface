<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
String st_atos_remark = CommonUtil.nvl((String) request.getParameter("st_atos_remark"),"");  //  (조회조건)
st_atos_remark = st_atos_remark.replaceAll("&lt;br&gt;","\n");
String st_stoa_remark = CommonUtil.nvl((String) request.getParameter("st_stoa_remark"),"");  //  (조회조건)
st_stoa_remark = st_stoa_remark.replaceAll("&lt;br&gt;","\n");
String viewType = CommonUtil.nvl((String) request.getParameter("viewType"),"");  //  (조회조건)
String titleType = CommonUtil.nvl((String) request.getParameter("titleType"),"");  //  (조회조건)
%>
<script type="text/javascript">

function init(){
<%--    $("#st_btoa_remark").val(<%=st_btoa_remark%>); --%>
//    $("#st_atob_remark").val("");
   
//   opener.setPopupReturn(value1,"");
//   this.close();
}

function kepConfirm()
{ 
  var value1 = $("#st_atos_remark").val();
  value1 = value1.replace(/\r?\n/g, '<br>');
  
  var value2 = $("#st_stoa_remark").val();
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
			<table class="cont_t_list05" >
                <tr> 
            <% if ("S".equals(titleType)) { %>
             		<th >운영사<br>▶<br>협력사</th>
             <% }else{ %>
                    <th >운영사</th>
             <% } %>
                    <td >
                        <textarea id="st_atos_remark" name="st_atos_remark" style="width:100%; overflow:auto; border-color:white; border-width:0;" rows="5" cols="35" <%=("S".equals(titleType))?"readonly" :"" %> ><%=st_atos_remark%></textarea>
                    </td>
                </tr>
            </table>
 			<table >
                <tr>
                    <td height="5"></td>
                </tr>
            </table >
             <table class="cont_t_list05">
                <tr> 
            <% if ("S".equals(titleType)) { %>
             		<th >협력사<br>▶<br>운영사</th>
             <% }else{ %>
                    <th >협력사</th>
             <% } %>
                    <td >
                        <textarea name="st_stoa_remark" id="st_stoa_remark"  style="width:100%; overflow:auto; border-color:white; border-width:0;" rows="5" cols="35" readonly><%=st_stoa_remark%></textarea>
                    </td>
                </tr>
            </table>
            <%
                	if (!"R".equals(viewType)) {
                %>  	                 	       	
	       	<div class="btnArea ac mt20" style="margin-bottom:0px;"> 
	           	<span class="fr btn_02"><a href="javascript:kepConfirm()">확인</a></span> 
			</div> 	
			<%
                	}
                %>  		
        </div>
    </div>
</body>
</html>
