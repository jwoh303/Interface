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
	 <form name=approvalCaListPop id=approvalCaListPop method=post >
	 <input type="hidden" name="VIEW" id="VIEW"  value="approvalCaListPop">  
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
            	 <h3>발주번호 : <%=DOCU_NO %></h3>
            	 ↑ ↓ : 변동 10% 이상, ▲ ▼ : 변동 10% 미만
            	 &nbsp;&nbsp;<font color="#FFD8D8"><b>■</b></font> : 변경전 , <font color="#D9E5FF"><b>■</b></font> : 변경후
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>업무결재 리스트</caption>
                    <colgroup>
                    	<col width="7%"/>
                        <col width="9%" />                   
                        <col width=* />                   
                        <col width="6%" />                   
<!--                         <col width="4%" />                    -->
<!--                         <col width="6%" /> -->
                        <col width="12%" /> 
<!--                         <col width="8%" /> -->
                        <col width="5%" /> 
                        <col width="6%" /> 
                        <col width="6%" />
                        <col width="10%" />
                        <col width="6%" />    
                        <col width="10%" />                    
                    </colgroup>
                    <thead>
                        <tr>
                            <th rowspan="2"  scope="col">구매사명</th> 
                            <th rowspan="2"  scope="col">품목코드</th> 
                            <th scope="col" style="background-color:#FFD8D8;">품목명</th>
<!-- 							<th scope="col" style="background-color:#FFD8D8;">규격</th>    -->
<!-- 							<th scope="col" style="background-color:#FFD8D8;">단위</th> -->
							<th scope="col" style="background-color:#FFD8D8;">원산지</th>
<!-- 							<th scope="col" style="background-color:#FFD8D8;">제조사</th> -->
							<th scope="col" style="background-color:#FFD8D8;">협력사</th>
							<th scope="col" style="background-color:#FFD8D8;">매익율</th>
							<th scope="col" style="background-color:#FFD8D8;">매출가</th>
							<th scope="col" style="background-color:#FFD8D8;">매입가</th>
							<th scope="col" style="background-color:#FFD8D8;">품목구분</th>
							<th scope="col" style="background-color:#FFD8D8;">표준납기일</th>
							<th rowspan="2"  scope="col">적용구분</th> 
                        </tr>
                        <tr>
                            <th scope="col">품목명</th>
<!-- 							<th scope="col">규격</th>    -->
<!-- 							<th scope="col">단위</th> -->
							<th scope="col">원산지</th>
<!-- 							<th scope="col">제조사</th> -->
							<th scope="col">협력사</th>
							<th scope="col">매익율</th>
							<th scope="col">매출가</th>
							<th scope="col">매입가</th>
							<th scope="col">품목구분</th>
							<th scope="col">표준납기일</th>
                        </tr>
                    </thead>
                    <tbody> 
<%
if (_dataList == null || _dataList.size() == 0){
%>
                <tr bgcolor="#FFFFFF">
		            <td colspan="10" align="center" height = "50"> 
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
          <td title="품목명" class="left"><%=rowData.get("RE_DESCRIPTION")%><br><%=rowData.get("CH_DESCRIPTION")%></td>
<%--           <td title="규격" class="left"><%=rowData.get("RE_SPECIFICATION")%><br><%=rowData.get("CH_SPECIFICATION")%></td> --%>
<%--           <td class="center" title="단위"><%=rowData.get("RE_UNIT_MEASURE")%><br><%=rowData.get("CH_UNIT_MEASURE")%></td> --%>
          <td class="center" title="원산지"><%=rowData.get("RE_ORGIN_TEXT")%><br><%=rowData.get("CH_ORGIN_TEXT")%></td>
<%--           <td class="center" title="제조사"><%=rowData.get("RE_MAKER_NAME")%><br><%=rowData.get("CH_MAKER_NAME")%></td> --%>
          <td class="center" title="협력사">
          	<a class="hyperLink"  href="javascript:openSearchPopup('/mdcp/showMasterMdCpAgntcmpyInfoAlterPop.do', '?com_code=<%=rowData.get("RE_AGENT")%>&simsaLevel=3', '950,670,no')"><%=rowData.get("CH_AGENT_TEXT")%></a>        	
          	<br>
          	<a class="hyperLink"  href="javascript:openSearchPopup('/mdcp/showMasterMdCpAgntcmpyInfoAlterPop.do', '?com_code=<%=rowData.get("AGENT")%>&simsaLevel=3', '950,670,no')"><%=rowData.get("RE_AGENT_TEXT")%></a></td>  
          <td class="right" title="매익율"><%=rowData.get("RE_RATE")%><br><%=rowData.get("CH_RATE")%></td>
          <td class="right" title="매출가"><%=CommonUtil.formatNumber(rowData.get("RE_UNIT_PRICE"),true,0,3)%><br>
          <%if( Double.parseDouble( String.valueOf(rowData.get("RE_UNIT_PRICE"))) > Double.parseDouble( String.valueOf(rowData.get("CH_UNIT_PRICE"))) ) { // 변경전 매출단가가 큰 경우 %>
           		<% if(rowData.get("UNIT_PRICE_CHG_FLAG").equals("Y")) { %>
           		<p style=" width:90%; text-align:right; padding-right:5px; font-weight:bold; color:#fff;background-color:#0000c7; border-radius:5px">
           			<%=CommonUtil.formatNumber(rowData.get("CH_UNIT_PRICE"),true,0,3)%>
           		<b style="font-size:16px">↓</b></p>
           		<% } else { %>
           		<p style=" width:90%; text-align:right; padding-right:5px; font-weight:bold; color:#fff;background-color:#02adfa; border-radius:5px">
           			<%=CommonUtil.formatNumber(rowData.get("CH_UNIT_PRICE"),true,0,3)%>
           			<b>▼</b></p>
           		<% } %>
             
          <% } else if( Double.parseDouble( String.valueOf(rowData.get("RE_UNIT_PRICE"))) < Double.parseDouble( String.valueOf(rowData.get("CH_UNIT_PRICE"))) ) {  // 변경전 매출단가가 작은 경우  %>
	        	   <% if(rowData.get("UNIT_PRICE_CHG_FLAG").equals("Y")) { %>
	           			<p style=" width:90%; text-align:right; padding-right:5px; font-weight:bold; color:#fff;background-color:#e60012; border-radius:5px">
	           			<%=CommonUtil.formatNumber(rowData.get("CH_UNIT_PRICE"),true,0,3)%>
	           			 <b style="font-size:16px">↑</b></p>
	           	   <% } else { %>
	           			<p style=" width:90%; text-align:right; padding-right:5px; font-weight:bold; color:#fff;background-color:#f18b00; border-radius:5px">
	           			<%=CommonUtil.formatNumber(rowData.get("CH_UNIT_PRICE"),true,0,3)%>
	           			<b>▲</b></p>
	           	   <% } %>
          <% } else { // 변경 없는 경우 %>        
           <%=CommonUtil.formatNumber(rowData.get("CH_UNIT_PRICE"),true,0,3)%>
           <% } %>
          </td>
          <td class="right" title="매입가"><%=CommonUtil.formatNumber(rowData.get("RE_LIST_PRICE"),true,0,3)%><br>
          <%if( Double.parseDouble( String.valueOf(rowData.get("RE_LIST_PRICE"))) > Double.parseDouble( String.valueOf(rowData.get("CH_LIST_PRICE"))) ) { // 변경전 매입단가가 큰 경우 %>
           		<% if(rowData.get("LIST_PRICE_CHG_FLAG").equals("Y")) { %>
           		<p style=" width:90%; text-align:right; padding-right:5px; font-weight:bold; color:#fff;background-color:#0000c7; border-radius:5px">
           			<%=CommonUtil.formatNumber(rowData.get("CH_LIST_PRICE"),true,0,3)%>
       			<b style="font-size:16px">↓</b></p>	
           		<% } else { %>
           		<p style=" width:90%; text-align:right; padding-right:5px; font-weight:bold; color:#fff;background-color:#02adfa; border-radius:5px">
           			<%=CommonUtil.formatNumber(rowData.get("CH_LIST_PRICE"),true,0,3)%>
           		<b>▼</b></p>	
           		<% } %>
             
          <% } else if( Double.parseDouble( String.valueOf(rowData.get("RE_LIST_PRICE"))) < Double.parseDouble( String.valueOf(rowData.get("CH_LIST_PRICE"))) ) {  // 변경전 매입단가가 작은 경우  %>
	        	   <% if(rowData.get("LIST_PRICE_CHG_FLAG").equals("Y")) { %>
	        	   <p style=" width:90%; text-align:right; padding-right:5px; font-weight:bold; color:#fff;background-color:#e60012; border-radius:5px">
	           			<%=CommonUtil.formatNumber(rowData.get("CH_LIST_PRICE"),true,0,3)%>
	           		<b style="font-size:16px">↑</b></p>
	           	   <% } else { %>
	           	   <p style=" width:90%; text-align:right; padding-right:5px; font-weight:bold; color:#fff;background-color:#f18b00; border-radius:5px">
	           			<%=CommonUtil.formatNumber(rowData.get("CH_LIST_PRICE"),true,0,3)%>
	           		<b>▲</b></p>
	           	   <% } %>
          <% } else { // 변경 없는 경우 %>        
           <%=CommonUtil.formatNumber(rowData.get("CH_LIST_PRICE"),true,0,3)%>
           <% } %>
          </td>          
          <td class="center" title="품목구분"><%=rowData.get("RE_ITEM_MAKE_TYPE_NM")%><br><%=rowData.get("CH_ITEM_MAKE_TYPE_NM")%></td>
          <td class="right" title="표준납기일"><%=rowData.get("RE_DELIVERY_LT")%><br><%=rowData.get("CH_DELIVERY_LT")%></td>
          <td class="center" title="적용구분"><%=rowData.get("BELOW_TEXT")%></td>
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
