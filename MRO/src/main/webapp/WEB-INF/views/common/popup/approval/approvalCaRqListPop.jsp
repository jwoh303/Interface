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
List<Map<String,String>> _dataList =  (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   


String buyer = CommonUtil.nvl((String) request.getParameter("COMPANY"),""); // 조회조건
String DOCU_NO = CommonUtil.nvl((String) request.getParameter("DOCU_NO"),""); // 조회조건
String DOC_TYPE = CommonUtil.nvl((String) request.getParameter("DOC_TYPE"),""); // 조회조건
String POP_FLAG = CommonUtil.nvl((String) request.getParameter("POP_FLAG"),""); //***상세팝업시 사이즈 세팅**/
String divHeight = "200px"; //***상세팝업시 사이즈 세팅**/
if("Y".equals(POP_FLAG))//***상세팝업시 사이즈 세팅**/
	divHeight = "600px";//***상세팝업시 사이즈 세팅**/
%>
<script type="text/javascript"> 

</script> 
<body>
	 <form name=approvalCaRqListPop id=approvalCaRqListPop method=post >
	 <input type="hidden" name="VIEW" id="VIEW"  value="approvalCaRqListPop">  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper"> 
    	<%
    		if("Y".equals(POP_FLAG)){//***상세팝업시 사이즈 세팅**/ %>
        	<div id="popHeader" >
	    	<h1 class="title">결재문서 상세</h1>
	        <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
	  	</div>
    	<%}%>
        <!--팝업내용입니다-->
        <div id="popContainer">  
         
            <div class="scrollArea" style="height:<%=divHeight %>">
            	<!--grid-->
            	 <h3>결재번호 : <%=DOCU_NO %></h3>
            	 &nbsp;&nbsp;<font color="#FFD8D8"><b>■</b></font> : 변경전 , <font color="#D9E5FF"><b>■</b></font> : 변경후
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>업무결재 리스트</caption>
                    <colgroup>
                    	<col width="6%" />
                        <col width="6%" />                   
                        <col width="10%" />                   
                        <col width="*" />                   
                        <col width="3%" />
                        <col width="8%" />
                        <col width="5%" /> 
                        <col width="5%" />
                        <col width="6%" />                     
                        <col width="5%" />
                        <col width="6%" />
                        <col width="6%" />
                        <col width="3%" />
                        <col width="5%" />
                        <col width="5%" />
                        <col width="5%" />
                    </colgroup>
                    <thead>
                        <tr>
                        	<th rowspan ="2" scope ="col">구매사명</th>
                            <th rowspan="2"  scope="col">품목코드</th> 
                            <th rowspan="2" scope="col">품목명</th>
							<th rowspan="2" scope="col">규격</th>   
							<th rowspan="2" scope="col">단위</th>
							<th scope="col" style="background-color:#FFD8D8;">협력사</th>
							<th scope="col" style="background-color:#FFD8D8;">매출가</th>
							<th scope="col" style="background-color:#FFD8D8;">매입가</th>
							<th scope="col" style="background-color:#FFD8D8;">품목구분</th>
							<th scope="col" style="background-color:#FFD8D8;">조달일수</th>
							<th scope="col" style="background-color:#FFD8D8;">단가유효일</th>
							<th scope="col" style="background-color:#FFD8D8;">판가유효일</th>
							<th scope="col" style="background-color:#FFD8D8;">MOQ</th>
							<th scope="col" style="background-color:#FFD8D8;">발주배수</th>
							<th scope="col" style="background-color:#FFD8D8;">거래유형</th>
							<th scope="col" style="background-color:#FFD8D8;">물류센터</th> 
                        </tr>
                        <tr> 
							<th scope="col">협력사</th>
							<th scope="col">매출가</th>
							<th scope="col">매입가</th>
							<th scope="col">품목구분</th>
							<th scope="col">조달일수</th>
							<th scope="col">단가유효일</th>
							<th scope="col">판가유효일</th>
							<th scope="col">MOQ</th>
							<th scope="col">발주배수</th>
							<th scope="col">거래유형</th>
							<th scope="col">물류센터</th>
                        </tr>
                    </thead>
                    <tbody> 
<%
if (_dataList == null || _dataList.size() == 0){
%>
                <tr bgcolor="#FFFFFF">
		            <td colspan="14" align="center" height = "50"> 
		            <span>조회된 데이타가 없습니다.</span>
		            </td> 
           		</tr>
<%
     }else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%>     
<tr>
		  <td height="50" align="center" title="구매사명"><%=rowData.get("BUYER_NAME")%></td>
		  <td height="50" align="center" title="품목코드"><%=rowData.get("BUYER_ITEM_NO")%></td>
          <td title="품목명" class="left"><%=rowData.get("CH_DESCRIPTION")%></td>
          <td title="규격" class="left"><%=rowData.get("CH_SPECIFICATION")%></td>
          <td class="center" title="단위"><%=rowData.get("CH_UNIT_MEASURE")%><br></td>
          <td class="center" title="협력사">
          	<a class="hyperLink"  href="javascript:openSearchPopup('/mdcp/showMasterMdCpAgntcmpyInfoAlterPop.do', '?com_code=<%=rowData.get("AGENT")%>&simsaLevel=3', '950,670,no')"><%=rowData.get("RE_AGENT_TEXT")%></a>
          	<br>
          	<a class="hyperLink"  href="javascript:openSearchPopup('/mdcp/showMasterMdCpAgntcmpyInfoAlterPop.do', '?com_code=<%=rowData.get("RE_AGENT")%>&simsaLevel=3', '950,670,no')"><%=rowData.get("CH_AGENT_TEXT")%></a>
          	</td>
          <td class="right" title="매출가"><%=CommonUtil.formatNumber(rowData.get("RE_UNIT_PRICE"),true,0,3)%><br><%=CommonUtil.formatNumber(rowData.get("CH_UNIT_PRICE"),true,0,3)%></td>
          <td class="right" title="매입가"><%=CommonUtil.formatNumber(rowData.get("RE_LIST_PRICE"),true,0,3)%><br><%=CommonUtil.formatNumber(rowData.get("CH_LIST_PRICE"),true,0,3)%></td>
          <td class="center" title="품목구분"><%=rowData.get("RE_ITEM_MAKE_TYPE_NM")%><br><%=rowData.get("CH_ITEM_MAKE_TYPE_NM")%></td>
          <td class="right" title="조달일수"><%=CommonUtil.formatNumber(rowData.get("RE_DELIVERY_LT"),true,0,3)%><br><%=CommonUtil.formatNumber(rowData.get("CH_DELIVERY_LT"),true,0,3)%></td>
          <td class="center" title="단가유효일"><%=CommonUtil.formatDate(rowData.get("RE_BUY_CLOSE_DATE"))%><br><%=CommonUtil.formatDate(rowData.get("CH_BUY_CLOSE_DATE"))%></td>
          <td class="center" title="판가유효일"><%=CommonUtil.formatDate(rowData.get("RE_TO_DATE"))%><br><%=CommonUtil.formatDate(rowData.get("CH_TO_DATE"))%></td>
          <td class="right" title="MOQ"><%=CommonUtil.formatNumber(rowData.get("RE_MIN_ORDER_QTY"),true,0,3)%><br><%=CommonUtil.formatNumber(rowData.get("CH_MIN_ORDER_QTY"),true,0,3)%></td>
          <td class="right" title="발주배수"><%=CommonUtil.formatNumber(rowData.get("RE_PUR_UNIT_QTY"),true,0,3)%><br><%=CommonUtil.formatNumber(rowData.get("CH_PUR_UNIT_QTY"),true,0,3)%></td>
          <td class="center" title="거래유형"><%=rowData.get("RE_PROCESS_TYPE_TEXT")%><br><%=rowData.get("CH_PROCESS_TYPE_TEXT")%></td>
          <td class="center" title="물류센터"><%=rowData.get("RE_WAREHOUSE_CODE_TEXT")%><br><%=rowData.get("CH_WAREHOUSE_CODE_TEXT")%></td>
<tr>
<%}
}%>                      
                    </tbody>
                </table>                  
        </div>
    </div>        
</div>
</form> 
</body>
</html>
