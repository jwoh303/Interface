<%--
**********************************************
* 메뉴 : 
* 화면 : 주문진행>반품진행>고객사
* 기능 : 
* 프로그램 ID : 
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-9-21
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
</head>

<body onload="" >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" >
    	<div id="popHeader">
        	<h1 class="title">고객사</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"  style="height:210px;">

			<table class="cont_t_list05" >
                <tr> 
                    <th >고객사요청부서</th>
                    <td >
                    <textarea  readOnly  style="width:100%;ime-mode:active; overflow:auto; border-color:white; border-width:0;" rows="2" cols="35" ><%=CommonUtil.nvl((String) request.getParameter("st_dept"),"") %></textarea>
                    </td>
                </tr>
                 <tr> 
                    <th >요청자</th>
                    <td >
                        <textarea  readOnly  style="width:100%;ime-mode:active; overflow:auto; border-color:white; border-width:0;" rows="2" cols="35" ><%=CommonUtil.nvl((String) request.getParameter("st_name"),"") %></textarea>
                    </td>
                </tr>
                 <tr> 
                    <th >연락처</th>
                    <td >
                        <textarea  readOnly  style="width:100%;ime-mode:active; overflow:auto; border-color:white; border-width:0;" rows="2" cols="35" ><%=CommonUtil.nvl((String) request.getParameter("st_tel"),"") %></textarea>
                    </td>
                </tr>                
            </table>
            <table >
                <tr> 
                    <td></td>
                </tr>
            </table>	
        </div>
    </div>
</body>
</html>
