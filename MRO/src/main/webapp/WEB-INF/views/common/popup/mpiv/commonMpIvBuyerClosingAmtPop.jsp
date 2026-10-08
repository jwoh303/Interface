<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사별 마감금액
* 기능 : 
* 프로그램 ID : PG_07_M_900_07
* 담당자 :  고영일 ( 설계 : 김지현 )
* 착수일 : 2014-08-14
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
<%@ include file="../../../common/include/head_pop.jspf"  %>
 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String st_tax_bill_no = CommonUtil.nvl((String) request.getParameter("st_tax_bill_no"),"");  //  (조회조건)
%>
<script type="text/javascript">
//기능함수
function doAction(str, value1, value2) {
	switch (str) {
		case "reportOpen": // 고객사별 집계
			reportOpen("RD_06_S_001_92","["+value2+"]["+value1+"]");
			break;
	}
}
</script>
<body onload="">
<form name="commonMpIvBuyerClosingAmtPop" id="commonMpIvBuyerClosingAmtPop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:514px;">
    	<div id="popHeader">
        	<h1 class="title">고객사별 마감금액</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div class="scrollArea" style="height:418px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>고객사별 마감금액 리스트</caption>
                    <colgroup>
                        <col width="*" /> 
                        <col width="25%" /> 
                        <col width="20%" /> 
                        <col width="25%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">고객사명</th> 
                            <th scope="col">마감금액</th> 
                            <th scope="col">담당자</th> 
                            <th scope="col">담당자연락처</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="4" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
							<td class="left"><%=_tmp.get("BUYER_NAME")%></td>
							<td class="right">
							  	<a class="hyperLink" href="javascript:doAction('reportOpen', '<%=_tmp.get("BUYER_CODE")%>', '<%=st_tax_bill_no%>')">
								<%=CommonUtil.formatNumber(String.valueOf(_tmp.get("AMT")),true,0,3)%></a>
						   </td>
							<td><%=CommonUtil.nvl(_tmp.get("KEP_USER_NAME"))%></td>
							<td><%=CommonUtil.nvl(_tmp.get("PHONE_NUMBER"))%></td>
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
