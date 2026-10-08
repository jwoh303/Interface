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
%>
</script> 
<body onload="">
	 <form name="commonNsAgentInfoPop" id="commonNsAgentInfoPop" method="post" >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" >
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE928") %><!--상세입찰 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div>
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>상세입찰</caption>
                    <colgroup>
                        <col width="10%" />  
                        <col width="60%" />  
                        <col width="30%" />    
                    </colgroup>
                    <thead>
                    	<tr>
                    		<th  scope="col"><%=CommonLang.get("HTITLE929") %><!-- 순위 --></th>
                    		<th  scope="col"><%=CommonLang.get("HTITLE144") %><!-- 협력사 --></th>
                    		<th  scope="col"><%=CommonLang.get("HTITLE145") %><!-- 견적단가 --></th>
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
	<%
	}else{
		for (int j=0; j<_dataList.size(); j++) {
			Map<String,String> rowData = _dataList.get(j);
	%> 
	                        <tr>
								<td  title="순서"><%=CommonUtil.bnvl( rowData.get("SEQ"))%></td> 
								<td  class="left"  title="협력사"><%=CommonUtil.nvl( rowData.get("AGENT_NAME"))%></td> 
								<td  class="right"  title="견적단가"><%=CommonUtil.formatNumber(rowData.get("ATOB_UNIT_PRICE"),true,0,3)%></td> 
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
