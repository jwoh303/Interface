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
            	 <h3>결재번호 : <%=DOCU_NO %></h3>
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>업무결재 리스트</caption>
                    <colgroup>
                    	<col width="7%"/>
                        <col width="9%" />                   
                        <col width="11%" />                   
                        <col width=* />                   
                        <col width="4%" />                   
                        <col width="8%" />
                        <col width="6%" /> 
                        <col width="6%" /> 
                        <col width="8%" /> 
                        <col width="10%" />
                        <col width="10%" />                    
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">구매사명</th> 
                            <th scope="col">품목코드</th> 
                            <th scope="col">품목명</th>
							<th scope="col">규격</th>   
							<th scope="col">단위</th>
							<th scope="col">제조사</th>
							<th scope="col">매출가</th>
							<th scope="col">매입가</th>
							<th scope="col">카탈로그<br>상태변경</th>
							<th scope="col">변경사유</th> 
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
          <td title="품목명" class="left"><%=rowData.get("RE_DESCRIPTION")%></td>
          <td title="규격" class="left"><%=rowData.get("RE_SPECIFICATION")%></td>
          <td class="center" title="단위"><%=rowData.get("RE_UNIT_MEASURE")%></td>
          <td class="center" title="제조사"><%=rowData.get("RE_MAKER_NAME")%></td>
          <td class="right" title="매출가"><%=CommonUtil.formatNumber(rowData.get("RE_UNIT_PRICE"),true,0,3)%></td>
          <td class="right" title="매입가"><%=CommonUtil.formatNumber(rowData.get("RE_LIST_PRICE"),true,0,3)%></td>          
          <td class="center" title="카탈로그상태변경"><%=rowData.get("GW_NO_TEXT")%></td>
          <td class="left" title="변경사유"><%=rowData.get("CH_CLOSE_STATUS_TEXT")%><%=rowData.get("CH_DEL_STATUS_TEXT")%></td>
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
