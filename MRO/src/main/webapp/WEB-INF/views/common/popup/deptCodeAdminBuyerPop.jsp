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
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String st_req_dept_name = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),"");  //  (조회조건)
String po_dept = CommonUtil.nvl((String) request.getParameter("po_dept"),"");  //  (조회조건)
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)
%>

<script type="text/javascript">
<!--
function setQuery()
{  
<% if ("Y".equals(open)){%>
  $('#deptCodeAdminPop').attr("action", "/common/commonList.do").submit();    
  <%}%>
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}
 //-->
</script> 
<body onload="setQuery();">
	 <form name=deptCodeAdminPop id=deptCodeAdminPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="deptCodeAdminBuyerPop">
	 <input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
	 <input type=hidden name="po_dept" id="po_dept"  value="<%=po_dept%>">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE712") %><!-- 부서검색 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:setQuery();"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>  
            </div>   
           	<!--grid-->
            <div class="scrollArea" style="height:368px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>부서검색 리스트</caption>
                    <colgroup>
                        <col width="20%" /> 
                        <col width="30%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE380") %><!-- 부서코드 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE490") %><!-- 요약 부서명 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE491") %><!-- 상세 부서명 --></th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "280">
                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						<td>
						 	<a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','')">
							<%=rowData.get("CODE")%></a>
						</td>
						<td>
						  	<a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','')">
							<%=rowData.get("TEXT1")%></a>
					   </td>
						<td>
								<a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','')">
							<%=CommonUtil.nvl(rowData.get("TEXT2"))%></a>
						</td>
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
