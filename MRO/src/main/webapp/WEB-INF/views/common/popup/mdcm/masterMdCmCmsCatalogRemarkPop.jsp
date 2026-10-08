<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
String st_remark = CommonUtil.nvl((String) request.getParameter("st_remark"),"");  //  (조회조건)
%>

<body onload="">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:304px;">
    	<div id="popHeader">
        	<h1 class="title">비고</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
			<table class="cont_t_list05">
                <tr> 
                    <th >비고</th>
                    <td >
                        <textarea id="st_remark" name="st_remark" style="width:100%; overflow:auto; border-color:white; border-width:0;" rows="13" cols="35" readonly><%=st_remark%></textarea>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>
