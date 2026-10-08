<%--
**********************************************
* 메뉴 : 
* 화면 : 견적종료
* 기능 : 견적종료  팝업
* 프로그램 ID : PG_04_B_004_01
* 담당자 : 현명환
* 착수일 : 2015-03-23
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
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/smoothness/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String po_dept = CommonUtil.nvl((String) request.getParameter("po_dept"),"");  //  (조회조건)
String st_btoa_nego_price = CommonUtil.nvl((String) request.getParameter("st_btoa_nego_price"),"");  //  (조회조건)
String st_btoa_end_date = CommonUtil.nvl((String) request.getParameter("st_btoa_end_date"),"");  //  (조회조건)
String st_reject_remark = CommonUtil.nvl((String) request.getParameter("st_reject_remark"),"");  //  (조회조건)
st_reject_remark = st_reject_remark.replaceAll("&lt;br&gt;","\n");
%>

<script type="text/javascript">
function kep_onload_view(){

}
function setReturn()
{ 

	var value = $('#st_reject_remark').val();
	opener.setCloseRemark(value);
	this.close();
}

</script> 
<body onload="kep_onload_view();">
<form name="buyerMpRqClosePop" id="buyerMpRqClosePop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:252px;">
    	<div id="popHeader">
        	<h1 class="title">견적종료 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:177px;">
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>네고요청  리스트</caption>
						<colgroup>
							<col width="20%" />
							<col width="80%" />
						</colgroup>						
						<tbody>
						<tr>
							<th>비고</th>
							<td> 
								<textarea name="st_reject_remark" id="st_reject_remark" style="width:90%" rows="8"><%=st_reject_remark%></textarea>
                            </td>
						</tr>					 
					</tbody>
				</table>
            </div>    
            <div class="btnArea mt10">
            	<span class="btn_04"><a href="javascript:setReturn();">확인</a></span>	
            </div>        
    </div>        
</div>
</form> 
</body>
</html>
