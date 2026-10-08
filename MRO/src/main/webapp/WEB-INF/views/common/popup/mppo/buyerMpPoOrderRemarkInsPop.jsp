<%--
**********************************************
* 메뉴 : 
* 화면 : 발주자 비고입력
* 기능 : 구매요청자의 비고를 확인할 수 있고, 구매발주자의 비고를 입력할 수 있다.
* 프로그램 ID : PG_06_B_016_01
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-06-23
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
String po_remark = CommonUtil.nvl((String) request.getParameter("po_remark"),"");  
po_remark = po_remark.replaceAll("&lt;br&gt;","\n");
%>

<script type="text/javascript">
<!-- 
 
function copyremark(){
	 var remark = document.forms.buyerMpPoOrderRemarkInsPop.pr_remark.value;
	 document.forms.buyerMpPoOrderRemarkInsPop.po_remark.value = remark;
}

function getAtobRemark(){ 
	var remark = document.forms.buyerMpPoOrderRemarkInsPop.po_remark.value; 
	remark = remark.replace(/\r?\n/g, '<br>');
	opener.checkOnePr(remark);
	self.close();
	 
}


 //-->
</script> 
<body onload="">
<form name="buyerMpPoOrderRemarkInsPop" id="buyerMpPoOrderRemarkInsPop" method=post > 
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">비고</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
 
 
 			<table class="cont_t_list05" style="background-color: #FAF9CF;">
				<tr > 
					<td style="width:100%">청구자 비고</td> 
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
                        <textarea name="pr_remark" id="pr_remark"  style="width:100%; overflow:auto; border-color:white; border-width:0;" rows="5" cols="35"  readonly><%=pr_remark%></textarea>
                    </td>
                </tr>
            </table>  
 			<table >	
                <tr>
                    <td height="5"></td>
                </tr>
            </table > 
 			<table class="cont_t_list05" style="background-color: #FAF9CF;">
				<tr > 
					<td  align="center"  width="80%">발주자 비고</td>
					<td  style="line-height:100%;padding:5px"> 
					<span class="btn_gray_03" title="복사"> <a href="javascript:copyremark();">복사</a></span> 					 
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
                    <td >
                        <textarea name="po_remark" id="po_remark"  style="width:100%; overflow:auto; border-color:white; border-width:0;" rows="5" cols="35" ><%=po_remark%></textarea>
                    </td>
                </tr>
            </table>  
            <br>
 		<div class="btnArea">
		 <span class="btn_02 mr04" title="확인" > <a href="javascript:getAtobRemark();">확인</a></span>
		            </div>
               
    </div>        
</div>
</form> 
</body>
</html>
