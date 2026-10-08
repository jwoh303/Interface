<%--
**********************************************
* 메뉴 : 
* 화면 : 카테고리 합계보기
* 기능 : 장바구니에서 선택된금액의 카테고리별 합계금액을 보기 위한 팝업
* 프로그램 ID : PG_06_B_006_50
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-05-23
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
double tot_po_amt = 0;
%>

<script type="text/javascript">
<!--
 
 //-->
</script> 
<body onload="">
<form name="buyerMpSoCategoryTotalViewPop" id="buyerMpSoCategoryTotalViewPop" method=post > 	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:480px;">
    	<div id="popHeader">
        	<h1 class="title">카테고리 합계보기</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">

           	<!--grid-->
            <div class="scrollArea" style="height:350px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>카테고리 합계보기 리스트</caption>
                    <colgroup>
                        <col width="50%" />  
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">품목군 명 [중분류]</th> 
                            <th scope="col">합계금액</th>  
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
	tot_po_amt += Double.parseDouble(_tmp.get("TOT_AMT"));
%> 
                        <tr>
						<td class="left">
						&nbsp;<%=_tmp.get("CATEG_NAME")%>
						</td>
						<td class="right">
						<%=CommonUtil.formatNumber(_tmp.get("TOT_AMT"),true,0,3)%> 원
					   </td> 
                        </tr> 
<% }
%>
                        <tr>
						<th>
						<b>총 합계금액</b>
						</th>
						<td class="right">
						<%=CommonUtil.formatNumber(tot_po_amt,true,0,3)%> 원
					   </td> 
                        </tr> 
<%
}%>                               
                    </tbody>
                </table>                  
        </div>
    </div>        
</div>
</form> 
</body>
</html>
