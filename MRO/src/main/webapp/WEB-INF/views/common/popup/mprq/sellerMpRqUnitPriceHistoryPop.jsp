<%--
**********************************************
* 메뉴 : 
* 화면 : 견적제출단가이력 
* 기능 : 견적제출단가이력
* 프로그램 ID : PG_04_A_002_01
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-07-29
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
<link rel="stylesheet" href="/resources/styles/seller_layout.css" type="text/css" />
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
String st_agent = CommonUtil.nvl((String) request.getParameter("st_agent"),"");  //  (조회조건)  
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
  $('#sellerMpRqUnitPriceHistoryPop').attr("action", "/mprq/getSellerUnitPriceHistoryPop.do").submit();    
}

</script> 
<body onload="kep_onload_view()">
<form name="sellerMpRqUnitPriceHistoryPop" id="sellerMpRqUnitPriceHistoryPop" method=post >
	<input type="hidden" name="st_buyer" id="st_buyer" size=20 value="<%=st_buyer%>" >
	<input type="hidden" name="st_quotation_no" id="st_quotation_no" value="<%=st_quotation_no%>" >
	<input type="hidden" name="st_quotation_seq" id="st_quotation_seq" value="<%=st_quotation_seq%>" >
	<input type="hidden" name="st_revision" id="st_revision" value="<%=st_revision%>" >
	<input type="hidden" name="st_agent" id="st_agent" value="<%=st_agent%>" >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:268px;">
    	<div id="popHeader">
        	<h1 class="title">견적제출 단가 이력</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
<!--              <div id="searchBtnA02"> -->
<!--             	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>   -->
<!--             </div>    -->
           	<!--grid-->
            <div class="scrollArea" style="height:217px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>견적서 출력  리스트</caption>
                    <colgroup>
                        <col width="5%" /> 
                        <col width="10%" /> 
                        <col width="10%" /> 
                        <col width="20%" /> 
                        <col width="12%" /> 
                        <col width="12%" /> 
                        <col width="29%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">NO</th> 
                            <th scope="col">견적번호</th> 
                            <th scope="col">순번</th> 
                            <th scope="col">품목코드</th> 
                            <th scope="col">견적제출일</th> 
                            <th scope="col">견적제출단가</th> 
                            <th scope="col">비고</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
						<td><%=String.valueOf(_tmp.get("NO"))%></td>
						<td><%=CommonUtil.nvl(_tmp.get("QUOTATION_NO"))%></td>
						<td><%=String.valueOf(_tmp.get("QUOTATION_SEQ"))%></td>
						<td><%=CommonUtil.nvl(_tmp.get("BUYER_ITEM_NO"))%></td>
						<td><%=CommonUtil.formatDate(_tmp.get("STOA_DATE"),1)%></td>
						<td class="right"><%=CommonUtil.formatNumber(_tmp.get("STOA_LIST_PRICE"),true,0,3)%></td>
						<td class="left"><%=CommonUtil.nvl(_tmp.get("STOA_REMARK"))%></td>
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
