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
  var value1 = kepTrim("st_btoa_remark");
  value1 = value1.replace(/\r?\n/g, '<br>');
  
  var value2 = "";
  opener.setPopupReturn(value1,value2);
  this.close();
}


</script>  
<body onload="init(); " >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:225px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">비고</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">

			<table class="cont_t_list05" >
                <tr> 
                    <th >비고</th>
                    <td >
                        <textarea id="st_btoa_remark" name="st_btoa_remark"  readOnly style="width:100%;ime-mode:active; overflow:auto; border-color:white; border-width:0;" rows="5" cols="35" ><%=st_btoa_remark%></textarea>
                    </td>
                </tr>
            </table>
            <table >
                <tr> 
                    <td></td>
                </tr>
            </table><br/><br/>	<br/>		
        </div>
    </div>
</body>
</html>
