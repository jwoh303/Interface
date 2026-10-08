<%--
**********************************************
* 메뉴 : 
* 화면 : 장바구니 품목별 비고입력
* 기능 : 
* 프로그램 ID :
* 담당자 : HSJ
* 착수일 : 2018-09-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());

String pr_remark = CommonUtil.nvl((String) request.getParameter("pr_remark"),"");  
pr_remark = pr_remark.replaceAll("&lt;br&gt;","\n");
%>

<script type="text/javascript">

function getAtobRemark(){ 
	var remark = document.forms.buyerMpPoOrderPrRemarkInsPop.pr_remark.value; 
	remark = remark.replace(/\r?\n/g, '<br>');
	opener.checkOnePr(remark);
	self.close();
	 
}

</script> 
<body onload="">
<form name="buyerMpPoOrderPrRemarkInsPop" id="buyerMpPoOrderPrRemarkInsPop" method=post > 
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE122")%><!-- 비고 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
 
 
 			<table class="cont_t_list05" style="background-color: #FAF9CF;">
				<tr > 
					<td style="width:100%"><%=CommonLang.get("HTITLE911")%><!-- 청구자 비고 --></td> 
				</tr>

            </table>
 			<table >
                <tr>
                    <td height="5"></td>
                </tr>
            </table >
             <table class="cont_t_list05">
                <tr> 
                    <td >
                        <textarea name="pr_remark" id="pr_remark"  style="width:100%; overflow:auto; border-color:white; border-width:0;" rows="5" cols="35"><%=pr_remark%></textarea>
                    </td>
                </tr>
            </table>  
 		<div class="btnArea">
		 <span class="btn_02 mr04" title="확인" > <a href="javascript:getAtobRemark();"><%=CommonLang.get("HTITLE516")%><!-- 확인 --></a></span>
		            </div>
               
    </div>        
</div>
</form> 
</body>
</html>
