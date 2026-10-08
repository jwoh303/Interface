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
System.out.println("=========="+_dataList.size());
%>
<script type="text/javascript">
function kep_onload_view(){
	
}

function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}
</script> 
<body onload="kep_onload_view()">
	 <form name=agent_info_display_pop id=agent_info_display_pop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="agentInfoDisplayPop"> 

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" >
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE882") %><!--예산부서별주문금액 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" >
			<div class="scrollArea"  style="height:180px">         
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>예산부서별주문금액</caption>
                    <colgroup>
                        <col width="65%" />  
                        <col width="30%" />  
                    </colgroup>		   
                    <thead> 
                        <tr>         
                            <th scope="col"><%=CommonLang.get("HTITLE419") %><!-- 예산부서 --></th>     
                            <th scope="col"><%=CommonLang.get("HTITLE176") %><!-- 구매액 --></th>   
                        </tr>
                    </thead>
                    <tbody>
<% 
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%>  
                        <tr>
						   <td class="left"><%=CommonUtil.nvl(_tmp.get("BUDGET_DEPT_NM"))%></td> 
						   <td class="right"><%=CommonUtil.formatNumber(_tmp.get("ORDER_PRICE"),true,0,3)%> <%=CommonLang.get("HTITLE660") %><!-- 원 --></td> 
						</tr>
<%}%>     
                    </tbody>
                </table>  
             </div>	
        </div>
    </div>         
                
</form> 
</body>
</html>
