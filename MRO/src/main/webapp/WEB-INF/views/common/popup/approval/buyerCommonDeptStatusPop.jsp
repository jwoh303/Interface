<%--
**********************************************
* 메뉴 :  결재
* 화면 : 요청부서[해당부서명 표기]별 년간실적
* 기능 : 요청부서[해당부서명 표기]별 년간실적
* 프로그램 ID : 
* 담당자 : CEJ  
* 착수일 : 2014-XX-XX
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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과  
String _CRUD =  CommonUtil.nvl((String)request.getAttribute("CRUD")); // 조회된결과
String BUYER = CommonUtil.nvl((String) request.getParameter("BUYER"),"");  //  (조회조건)
String REVISION = CommonUtil.nvl((String) request.getParameter("REVISION"),"");  //  (조회조건)
String USERDEPT = CommonUtil.nvl((String) request.getParameter("USERDEPT"),"");  //  (조회조건)
String BUYER_ITEM_NO = CommonUtil.nvl((String) request.getParameter("BUYER_ITEM_NO"),"");  //  (조회조건)

//USERDEPT = "013E"; // 강제로 임시
%>
<script type="text/javascript">
 
function setQuery()
{     
  <% if ("".equals(_CRUD)){%>
  $('#buyerCommonDeptStatusPop').attr("action", "/common/approval/getCommonApprovalListPop.do").submit();   
  <%}%>
}
 
</script> 
<body onload="setQuery()">
	 <form name=buyerCommonDeptStatusPop id=buyerCommonDeptStatusPop method=post >
	 <input type="hidden" name="VIEW" id="VIEW"  value="buyerCommonDeptStatusPop"> 
	  <input type="hidden" name="BUYER" id="BUYER"  value="<%=BUYER%>">
	  <input type="hidden" name="REVISION" id="REVISION"  value="<%=REVISION%>">  
	  <input type="hidden" name="USERDEPT" id="USERDEPT"  value="<%=USERDEPT%>">  
	  <input type="hidden" name="BUYER_ITEM_NO" id="BUYER_ITEM_NO"  value="<%=BUYER_ITEM_NO%>">  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">요청부서[해당부서명 표기]별 년간실적 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">  
          
            <div class="scrollArea" style="height:400px">
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>요청부서[해당부서명 표기]별 년간실적 리스트</caption>
                    <colgroup>
                        <col width="8%" /> 
                        <col width="6%" />  
                        <col width="3.5%" /> 
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" /> 
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />  
                        <col width="3.5%" />                          
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">분류</th> 
                            <th scope="col">구분</th>
							<th scope="col">수량</th>   
							<th scope="col">금액</th>   
							<th scope="col">수량</th>   
							<th scope="col">금액</th>  
							<th scope="col">수량</th>   
							<th scope="col">금액</th>  
							<th scope="col">수량</th>   
							<th scope="col">금액</th>  
							<th scope="col">수량</th>   
							<th scope="col">금액</th>  
							<th scope="col">수량</th>   
							<th scope="col">금액</th>  
							<th scope="col">수량</th>   
							<th scope="col">금액</th>  
							<th scope="col">수량</th>   
							<th scope="col">금액</th>  
							<th scope="col">수량</th>   
							<th scope="col">금액</th>  
							<th scope="col">수량</th>   
							<th scope="col">금액</th>  
							<th scope="col">수량</th>   
							<th scope="col">금액</th>  
							<th scope="col">수량</th>   
							<th scope="col">금액</th>  
                        </tr>                        
                        <tr>
                            <th scope="col">카테고리명</th> 
                            <th scope="col">품목코드/월</th>
							<th scope="col" colspan="2"><%=CommonUtil.getMonthAgoDate( -1)%></th>   
							<th scope="col" colspan="2"><%=CommonUtil.getMonthAgoDate( -2)%></th>   
							<th scope="col" colspan="2"><%=CommonUtil.getMonthAgoDate( -3)%></th>   
							<th scope="col" colspan="2"><%=CommonUtil.getMonthAgoDate( -4)%></th>   
							<th scope="col" colspan="2"><%=CommonUtil.getMonthAgoDate( -5)%></th>   
							<th scope="col" colspan="2"><%=CommonUtil.getMonthAgoDate( -6)%></th>   
							<th scope="col" colspan="2"><%=CommonUtil.getMonthAgoDate( -7)%></th>   
							<th scope="col" colspan="2"><%=CommonUtil.getMonthAgoDate( -8)%></th>   
							<th scope="col" colspan="2"><%=CommonUtil.getMonthAgoDate( -9)%></th>   
							<th scope="col" colspan="2"><%=CommonUtil.getMonthAgoDate( -10)%></th>   
							<th scope="col" colspan="2"><%=CommonUtil.getMonthAgoDate( -11)%></th>   
							<th scope="col" colspan="2"><%=CommonUtil.getMonthAgoDate( -12)%></th>   
                        </tr>
                                                
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="26" align="center" height = "270">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
							<td><%=CommonUtil.bnvl( rowData.get("COMPANY_CODE_TEXT"))%></td> 
							<td>
								<a href="javascript:openSearchPopup('/common/popup/approval/buyerCommonItemStatusPop.do','?BUYER=<%= BUYER%>&USERDEPT=<%=CommonUtil.nvl( rowData.get("ORDER_DEPT_CD")) %>&BUYER_ITEM_NO=<%=CommonUtil.nvl( rowData.get("BUYER_ITEM_NO"))%>&REVISION=2','1500,500,no')">
				              <%=CommonUtil.nvl( rowData.get("BUYER_ITEM_NO"))%>
				              </a>
				              </td> 
							<td><%=CommonUtil.nvl( rowData.get("YY01_QTY"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY01_AMT"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY02_QTY"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY02_AMT"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY03_QTY"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY03_AMT"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY04_QTY"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY04_AMT"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY05_QTY"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY05_AMT"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY06_QTY"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY06_AMT"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY07_QTY"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY07_AMT"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY08_QTY"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY08_AMT"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY09_QTY"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY09_AMT"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY10_QTY"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY10_AMT"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY11_QTY"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY11_AMT"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY12_QTY"))%></td> 
							<td><%=CommonUtil.nvl( rowData.get("YY12_AMT"))%></td> 
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
