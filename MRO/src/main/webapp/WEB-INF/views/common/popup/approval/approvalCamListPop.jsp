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
//팝업함수호출
function doPop(str, value1, value2,idx) {
	popupSel = str ;
	gridIndex = idx;
	
	switch (str) {
	case "deliAreaPop": // 납품지역
		gridIndex = value2;
		var area_list = $("input[name=st_deliArea]").eq(gridIndex).val();
		
		openSearchPopup("/common/getDeliveryAreaPop.do", '?st_com_code='+value1+'&st_area_list='+area_list+'&mod_yn=N', "400,270,no");
		
		break;
	}
}

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
                    	<col width="6%" />
                        <col width="6%" />                   
                        <col width="8%" />                   
                        <col width="*" />                   
                        <col width="3%" />
                        <col width="3%" />                   
                        <col width="8%" />
                        <col width="6%" /> 
                        <col width="6%" />
                        <col width="5%" />                     
                        <col width="7%" />                     
                        <col width="5%" />
                        <col width="6%" />
                        <col width="6%" />
                        <col width="4%" />
                        <col width="5%" />
                        <col width="5%" />
                        <col width="8%" />
                    </colgroup>
                    <thead>
                        <tr>
                        	<th rowspan ="2" scope ="col">구매사명</th>
                            <th rowspan="2"  scope="col">품목코드</th> 
                            <th rowspan="2" scope="col">품목명</th>
							<th rowspan="2" scope="col">규격</th>   
							<th rowspan="2" scope="col">단위</th>
							<th rowspan="2" scope="col">납품</br>지역</th> 
							<th scope="col" style="background-color:#FFD8D8;">협력사</th>
							<th scope="col" style="background-color:#FFD8D8;">매출가</th>
							<th scope="col" style="background-color:#FFD8D8;">매입가</th>
							<th scope="col" style="background-color:#FFD8D8;">매익율</th>
							<th scope="col" style="background-color:#FFD8D8;">품목구분</th>
							<th scope="col" style="background-color:#FFD8D8;">표준<br>납기일</th>
							<th scope="col" style="background-color:#FFD8D8;">매출<br>단가유효일</th>
							<th scope="col" style="background-color:#FFD8D8;">매입<br>단가유효일</th>
							<th scope="col" style="background-color:#FFD8D8;">MOQ</th>
							<th scope="col" style="background-color:#FFD8D8;">발주배수</th>
							<th scope="col" style="background-color:#FFD8D8;">거래유형</th>
							<th scope="col" style="background-color:#FFD8D8;">물류센터</th> 
                        </tr>
                        <tr> 
							<th scope="col">협력사</th>
							<th scope="col">매출가</th>
							<th scope="col">매입가</th>
							<th scope="col">매익율</th>
							<th scope="col">품목구분</th>
							<th scope="col">표준<br>납기일</th>
							<th scope="col">매출<br>단가유효일</th>
							<th scope="col">매입<br>단가유효일</th>
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
          <td title="품목명" class="left"><%=rowData.get("RE_DESCRIPTION")%></td>
          <td title="규격" class="left"><%=rowData.get("RE_SPECIFICATION")%></td>
          <td class="center" title="단위"><%=rowData.get("RE_UNIT_MEASURE")%><br></td>
          <td title="납품지역">
            <input type="hidden" name="st_deliArea" id="st_deliArea" value="<%=rowData.get("CH_SELLER_AREA")%>">
            <%if("".equals(rowData.get("CH_SELLER_AREA")) || null == rowData.get("CH_SELLER_AREA")){%>
            	<a class="hyperLink" href="javascript:doPop('deliAreaPop', '<%=rowData.get("BUYER") %>', '<%=j%>');"><img name="area_select_img" id="area_select_img" src="/resources/images/icon2.gif"></a>
            <%}else{%>
            	<a class="hyperLink" href="javascript:doPop('deliAreaPop', '<%=rowData.get("BUYER") %>', '<%=j%>');"><img name="area_select_img" id="area_select_img" src="/resources/images/icon.gif"></a>
            <%}%>
          </td>
          <td class="center" title="협력사">
          	<a class="hyperLink"  href="javascript:openSearchPopup('/mdcp/showMasterMdCpAgntcmpyInfoAlterPop.do', '?com_code=<%=rowData.get("AGENT")%>&simsaLevel=3', '950,670,no')"><%=rowData.get("RE_AGENT_TEXT")%></a>
          	<br>
          	<a class="hyperLink"  href="javascript:openSearchPopup('/mdcp/showMasterMdCpAgntcmpyInfoAlterPop.do', '?com_code=<%=rowData.get("RE_AGENT")%>&simsaLevel=3', '950,670,no')"><%=rowData.get("CH_AGENT_TEXT")%></a>
          	</td>
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
          <td class="right" title="매익율"><%=rowData.get("RE_RATE")%><br><%=rowData.get("CH_RATE")%></td>
          <td class="center" title="품목구분"><%=rowData.get("RE_ITEM_MAKE_TYPE_NM")%><br><%=rowData.get("CH_ITEM_MAKE_TYPE_NM")%></td>
          <td class="right" title="표준납기일"><%=CommonUtil.formatNumber(rowData.get("RE_DELIVERY_LT"),true,0,3)%><br><%=CommonUtil.formatNumber(rowData.get("CH_DELIVERY_LT"),true,0,3)%></td>
          <td class="center" title="매출단가유효일"><%=CommonUtil.formatDate(rowData.get("RE_SELL_CLOSE_DATE"))%><br><%=CommonUtil.formatDate(rowData.get("CH_SELL_CLOSE_DATE"))%></td>
          <td class="center" title="매입단가유효일"><%=CommonUtil.formatDate(rowData.get("RE_BUY_CLOSE_DATE"))%><br><%=CommonUtil.formatDate(rowData.get("CH_BUY_CLOSE_DATE"))%></td>
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
