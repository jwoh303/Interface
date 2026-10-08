<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
// String bid_success_reason = _dataList.get(0).get("BID_SUCCESS_REASON"); //선정사유
%>
</script>
<body onload="">
	 <form name="commonQuotDetailInfoPop" id="commonQuotDetailInfoPop" method="post" >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" >
    	<div id="popHeader">
        	<h1 class="title">NEGO이력</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div>
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>NEGO이력</caption>
                    <colgroup>
                        <col width="12%" />  
                        <col width="20%" />  
                        <col width="15%" />
                        <col width="20%" />  
                        <col width="*" />      
                    </colgroup>
                    <thead>
                    	<tr>
                    		<th  scope="col">NEGO차수</th>
                    		<th  scope="col">NEGO견적 제출일자</th>
                    		<th  scope="col">제출단가</th>
                    		<th  scope="col">NEGO 요청단가</th>
                    		<th  scope="col">비고</th>
                    	</tr>
                    </thead>		   
                    <tbody>
	<%
	if (_dataList == null || _dataList.size() == 0){
	%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="5" align="center" height = "100">
	                        <span class="font1">조회된 데이타가 없습니다.</span>
	                        </td> 
	                    </tr>
	<%
	}else{
		for (int j=0; j<_dataList.size(); j++) {
			Map<String,String> rowData = _dataList.get(j);
	%> 
	                        <tr>
								<td  class="center"  title="NEGO차수"><%=CommonUtil.nvl( rowData.get("NEGO_SEQ"))%></td>
								<td  class="center"  title="NEGO견적 제출일자"><%=CommonUtil.nvl( rowData.get("NEGO_DATE"))%></td> 
								<td  class="right"  title="제출단가"><%=CommonUtil.formatNumber(rowData.get("NEGO_PRICE"),true,0,3)%></td>
								<td  class="right"  title="NEGO 요청단가"><%=CommonUtil.formatNumber(rowData.get("BTOA_NEGO_PRICE"),true,0,3)%></td>
								<td  class="left"  title="비고"><%=CommonUtil.nvl( rowData.get("BTOA_NEGO_REMARK"))%></td>  
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
