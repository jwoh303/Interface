<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
String st_re_remark = CommonUtil.nvl((String) request.getParameter("st_re_remark"),"");  //  (조회조건)
st_re_remark = st_re_remark.replaceAll("&lt;br&gt;","\n");

String st_ch_remark = CommonUtil.nvl((String) request.getParameter("st_ch_remark"),"");  //  (조회조건)
st_ch_remark = st_ch_remark.replaceAll("&lt;br&gt;","\n");
%>
<script type="text/javascript">

</script>  
<body onload="">
	<div id="popWrapper" style="height:224px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">비고</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
			<table class="cont_t_list05" style="background-color: #FAF9CF;">
                <tr> 
                    <th >기존비고</th>
                    <td >
                        <textarea id="st_re_remark" name="st_re_remark" style="width:100%; overflow:auto; border-color:white; border-width:0; background-color: #FAF9CF;" rows="4" cols="35" readonly><%=st_re_remark%></textarea>
                    </td>
                </tr>
            </table>
            <table >
                <tr> 
                    <td></td>
                </tr>
            </table>
            <table class="cont_t_list05" style="background-color: #FAF9CF;">
                <tr> 
                    <th >변경비고</th>
                    <td >
                        <textarea id="st_ch_remark" name="st_ch_remark" style="width:100%; overflow:auto; border-color:white; border-width:0; background-color: #FAF9CF;" rows="4" cols="35" readonly><%=st_ch_remark%></textarea>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>
