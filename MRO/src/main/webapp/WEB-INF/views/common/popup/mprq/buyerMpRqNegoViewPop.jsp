<%--
**********************************************
* 메뉴 : 
* 화면 : 단가합의 및 Nego요청 
* 기능 : 
* 프로그램 ID : PG_04_B_004_04
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-08-28
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
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)  
String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");  //  (조회조건)  
String st_quotation_seq = CommonUtil.nvl((String) request.getParameter("st_quotation_seq"),"");  //  (조회조건)  
String st_revision = CommonUtil.nvl((String) request.getParameter("st_revision"),"");  //  (조회조건)  
%>

<script type="text/javascript">
function kep_onload_view()
{  
	<%
	if (_dataList==null || _dataList.size()==0){
	%> 
		setQuery();
	<%}%>
}
function setQuery(){
  $('#buyerMprqNegoViewPop').attr("action", "/mprq/getBuyerMprqNegoViewPop.do").submit();    
}

</script> 
<body onload="kep_onload_view()">
<form name="buyerMprqNegoViewPop" id="buyerMprqNegoViewPop" method=post >
	<input type="hidden" name="st_buyer" id="st_buyer" size=20 value="<%=st_buyer%>" >
	<input type="hidden" name="st_quotation_no" id="st_quotation_no" value="<%=st_quotation_no%>" >
	<input type="hidden" name="st_quotation_seq" id="st_quotation_seq" value="<%=st_quotation_seq%>" >
	<input type="hidden" name="st_revision" id="st_revision" value="<%=st_revision%>" >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:302px;">
    	<div id="popHeader">
        	<h1 class="title">단가 합의 및 Nego 요청</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
<!--              <div id="searchBtnA02"> -->
<!--             	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>   -->
<!--             </div>    -->
           	<!--grid-->
            <div class="scrollArea" style="height:228px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>단가 합의 및 Nego 요청</caption>
                    <colgroup>
                        <col width="18%" /> 
                        <col width="8%" /> 
                        <col width="14%" /> 
                        <col width="17%" /> 
                        <col width="15%" /> 
                        <col width="28%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">견적번호</th> 
                            <th scope="col">순번</th> 
                            <th scope="col">품목코드</th> 
                            <th scope="col">Nego 회신 요청일</th> 
                            <th scope="col">Nego 요청단가</th> 
                            <th scope="col">Nego 요청사유</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="6" align="center" height = "285">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
						<td><%=CommonUtil.nvl(_tmp.get("QUOTATION_NO"))%></td>
						<td><%=String.valueOf(_tmp.get("QUOTATION_SEQ"))%></td>
						<td><%=CommonUtil.nvl(_tmp.get("BUYER_ITEM_NO"))%></td>
						<td><%=CommonUtil.formatDate(_tmp.get("BTOA_END_DATE"),1)%></td>
						<td class="right"><%=CommonUtil.formatNumber(_tmp.get("BTOA_NEGO_PRICE"),true,0,3)%></td>
						<td class="left"><%=CommonUtil.nvl(_tmp.get("REJECT_REMARK"))%></td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table>                  
        </div>
    </div>        
</div>
</form> 
</body>
</html>
