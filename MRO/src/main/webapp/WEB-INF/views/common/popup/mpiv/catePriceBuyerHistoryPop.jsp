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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   
 
String byca_comorg_code = CommonUtil.nvl((String) request.getParameter("st_byca_comorg_code"),"");  //  (조회조건)  
String buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  //  (조회조건) 
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건) 
%>
<script type="text/javascript">
<!--
function setQuery()
{   
<% if ("Y".equals(open)) {%>
  $('#catePriceHistoryPop').attr("action", "/common/commonFolderList.do").submit();   
<%}%>  
}
 //-->
</script> 
<body onload="setQuery();">
	 <form name=catePriceHistoryPop id=catePriceHistoryPop method=post >
	 <input type="hidden" name="folder" id="folder"  value="mpiv"> 
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="catePriceBuyerHistoryPop"> 
	 <input type="hidden" name="byca_comorg_code" id="byca_comorg_code"  value="<%=byca_comorg_code%>"> 
	 <input type="hidden" name="buyer_item_no" id="buyer_item_no"  value="<%=buyer_item_no%>">
	  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">단가정보</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">         
            <div>
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>단가정보</caption>
                    <colgroup>
                        <col width="15%" />
                        <col width="20%" />  
                        <col width="15%" />
                        <col width="15%" />
                        <col width="13%" />
                        <col width="10%" />   
                        <col width="*" />   
                    </colgroup>		   
                    <thead> 
                        <tr>
                        	<th scope="col">구매사코드</th>
                        	<th scope="col">구매사명</th>    
                            <th scope="col">품목코드</th>
                            <th scope="col">제조사</th>
                            <th scope="col">계약번호</th>
                            <th scope="col">계약항번</th> 
                            <th scope="col" >단가</th>       
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "250">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						    <td><%=CommonUtil.nvl(rowData.get("BELOW_COMORG_CODE"))%></td>
						    <td class="left"><%=CommonUtil.nvl(rowData.get("BELOW_COMORG_NM"))%></td>						    
						    <td><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></td>
						    <td class="left"><%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%></td>
						    <td><%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%></td>
						    <td><%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%></td>
						    <td class="right"><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%></td>
						</tr> 
<% } %>
<%}%>                                   
                    </tbody>
                </table>  		 
        </div>
    </div>        
</div>
</form> 
</body>
</html>
