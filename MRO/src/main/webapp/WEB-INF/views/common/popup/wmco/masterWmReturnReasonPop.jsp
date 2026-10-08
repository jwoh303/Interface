<%--
**********************************************
* 메뉴 : 주문>반품진행관리
* 화면 : 요청사유 및 취소 사유
* 기능 : 
* 프로그램 ID : 
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-9-18
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

<script type="text/javascript">
<!--
function kepConfirm()
{  
  $('#masterWmCoDelayPop').attr("action", "/wmgr/saveMasterWmCoDelayPop.do").submit();    
  var value1 = document.masterWmCoDelayPop.st_DELAY_REMARK.value;
  var value2 = "";
  opener.setPopupReturn(value1,value2);
  this.close();
}
 //-->
</script> 
<body >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:225px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonUtil.nvl((String) request.getParameter("st_title"),"") %></h1>
             <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"  style="height:148px;">

			<table class="cont_t_list05" >
                <tr> 
                    <th><%=CommonUtil.nvl((String) request.getParameter("st_title"),"") %></th>
                    <td>
                        <textarea id="st_btoa_remark" name="st_btoa_remark"  readOnly style="width:100%;ime-mode:active; overflow:auto; border-color:white; border-width:0;" rows="8" cols="35" ><%=CommonUtil.nvl((String) request.getParameter("st_reason"),"") %></textarea>
                    </td>
                </tr>
            </table>	
        </div>
    </div>
</body>
</html>
