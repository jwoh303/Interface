<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
String reason = CommonUtil.nvl((String) request.getParameter("reason"),"");  //  (조회조건)
%>
<script type="text/javascript">

</script>  
<body onload="">
	<div id="popWrapper" style="height:174px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">사유</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div style="height:88px">
			<table class="cont_t_list05">
                <tr> 
                    <th >사유</th>
                    <td >
                        <textarea id="st_return_remark" name="st_return_remark" style="width:100%; overflow:auto; border-color:white; border-width:0;" rows="3" cols="35" readonly><%=reason%></textarea>
                    </td>
                </tr>
            </table>
            </div>
        </div>
    </div>
</body>
</html>
