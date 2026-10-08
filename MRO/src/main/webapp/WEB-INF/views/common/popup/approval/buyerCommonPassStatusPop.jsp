<%--
**********************************************
* 메뉴 :  결재
* 화면 : 결재현황보기
* 기능 : 결재현황보기
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
String COMPANY = CommonUtil.nvl((String) request.getParameter("COMPANY"),"");  //  (조회조건)
String DOCU_NO = CommonUtil.nvl((String) request.getParameter("DOCU_NO"),"");  //  (조회조건)

%>
<script type="text/javascript">
 
function setQuery()
{     
  <% if ("".equals(_CRUD)){%>
  $('#buyerCommonPassStatusPop').attr("action", "/common/approval/getCommonApprovalListPop.do").submit();   
  <%}%>
}
 
</script> 
<body onload="setQuery()">
	 <form name=buyerCommonPassStatusPop id=buyerCommonPassStatusPop method=post >
	 <input type="hidden" name="VIEW" id="VIEW"  value="buyerCommonPassStatusPop"> 
	  <input type="hidden" name="COMPANY" id="COMPANY"  value="<%=COMPANY%>">
	  <input type="hidden" name="DOCU_NO" id="DOCU_NO"  value="<%=DOCU_NO%>">  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:394px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">결재현황보기</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">  
          
            <div class="scrollArea" style="height:300px">        
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>결재현황보기 리스트</caption>
                    <colgroup>
                        <col width="10%" /> 
                        <col width="10%" />  
                        <col width="20%" /> 
                        <col width="20%" />  
                        <col width="20%" />  
                        <col width="20%" />  
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">순서</th> 
                            <th scope="col">결재유형</th>  
                            <th scope="col">결재(참조)자</th> 
                            <th scope="col">열람일시</th>  
                            <th scope="col">결재(참조)일시</th>  
                            <th scope="col">결재여부</th>  
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="6" align="center" height = "270">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
							<td  title="순서"><%=CommonUtil.bnvl( rowData.get("ORDER_NO"))%></td> 
							<td  title="결재유형"><%=CommonUtil.nvl( rowData.get("PASS_TP"))%></td> 
							<td  title="결재(참조)자"><%=CommonUtil.nvl( rowData.get("USER_NM"))%></td> 
							<td title="열람일시"><%=CommonUtil.nvl( rowData.get("REFER_DATE"))%></td> 
							<td  title="결재(참조)일시"><%=CommonUtil.nvl( rowData.get("PASS_DATE"))%></td> 
							<td title="결재여부"><%=CommonUtil.nvl( rowData.get("PASS_KN"))%></td> 
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
