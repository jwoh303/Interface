<%--
**********************************************
* 메뉴 :  결재
* 화면 : 결재리스트 - 주문정보수정
* 기능 : 결재리스트
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
List<Map<String,String>> _dataList =  (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   


String buyer = CommonUtil.nvl((String) request.getParameter("COMPANY"),""); // 조회조건
String DOCU_NO = CommonUtil.nvl((String) request.getParameter("DOCU_NO"),""); // 조회조건
String DOC_TYPE = CommonUtil.nvl((String) request.getParameter("DOC_TYPE"),""); // 조회조건

String LEGACY_PO_NO = "";
String APLY_RANGE = "";
if (_dataList == null || _dataList.size() == 0){
}else{
	Map<String,String> rowData = _dataList.get(0); 
	LEGACY_PO_NO = rowData.get("LEGACY_PO_NO");
	APLY_RANGE = rowData.get("APLY_RANGE");
}

String POP_FLAG = CommonUtil.nvl((String) request.getParameter("POP_FLAG"),""); //***상세팝업시 사이즈 세팅**/
String divHeight = "200px"; //***상세팝업시 사이즈 세팅**/
if("Y".equals(POP_FLAG))//***상세팝업시 사이즈 세팅**/
	divHeight = "600px";//***상세팝업시 사이즈 세팅**/

%>
<script type="text/javascript">  
function setQuery(){
	
}
</script> 
<body onload="setQuery()">
	 <form name=approvalSamplePop id=approvalSamplePop method=post >
	 <input type="hidden" name="VIEW" id="VIEW"  value="approvalSamplePop">  
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
      
      
       <h3>고객사 주문생성번호 : <%=LEGACY_PO_NO %> / 적용범위 : <%=APLY_RANGE %></h3>
      <table  class="cont_t_list02"  style="width:100%">
                    <caption>업무결재 리스트</caption>
                    <colgroup>     
                        <col width="10%" />                   
                        <col width="*" />                   
                        <col width="20%" />                   
                        <col width="5%" />                   
                        <col width="10%" />
                        <col width="8%" />  
                        <col width="30%" />       
                    </colgroup>
                    <thead>
                        <tr> 
                            <th scope="col">품목코드</th> 
                            <th scope="col">품목명</th>  
                            <th scope="col">규격</th>  
                            <th scope="col">단위</th>  
                            <th scope="col">요청자명</th>  
                            <th scope="col">생성일</th>  
                            <th scope="col">오류내역</th>  
						</tr>
					</thead>
					<tbody>
					<%
if (_dataList == null || _dataList.size() == 0){
%>
                <tr bgcolor="#FFFFFF">
		            <td colspan="7" align="center" height = "50"> 
		            <span>조회된 데이타가 없습니다.</span>
		            </td> 
           		</tr>
<%
     }else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j); 	 
%>     
						<tr> 
							<td><%=rowData.get("BUYER_ITEM_NO")%></td>
							<td class="left"><%=rowData.get("DESCRIPTION")%></td> 
							<td class="left"><%=rowData.get("SPECIFICATION")%></td>
							<td><%=rowData.get("UNIT_MEASURE")%></td>
							<td><%=rowData.get("REQ_USER_NAME")%></td>
							<td><%=CommonUtil.formatStrinigDate(rowData.get("CREATE_DATE"))%></td>
							<td><%=CommonUtil.nvl(rowData.get("ERROR_MSG"))%></td>
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
