<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과  
String tableName = CommonUtil.nvl((String) request.getParameter("tableName"),"");  //  (조회조건)
String columnName = CommonUtil.nvl((String) request.getParameter("columnName"),"");  //  (조회조건)
%>
<script type="text/javascript">
<!--
function setQuery()
{    
	
	if (kepIsEmpty("tableName") == true && kepIsEmpty("columnName")==true){
	    alert("검색조건을 입력하세요."); 
		return;
	} 
	
  $('#tableinfoPop').attr("action", "/common/commonList.do").submit();   
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
} 
 //-->
</script> 
<body>
	 <form name=tableinfoPop id=tableinfoPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="tableinfoPop"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">TABLE 정보</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:setQuery();">조회</a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>TABLE 리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="18%" />
							<col width="9%" />
							<col width="15%" />
							<col width="10%" />
                            <col width="10%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>TABLE</td>
							<td> 
								<input type=text name="tableName"  id="tableName" size=20 value="<%=tableName%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						    <td>COLUMN</td>
							<td> 
								<input type=text name="columnName"  id="columnName" size=20 value="<%=columnName%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						</tr>					 
					</tbody>
				</table>
            </div>            
            <div class="scrollArea" style="height:340px">    
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>TABLE 리스트</caption>
                    <colgroup>
                        <col width="20%" /> 
                        <col width="30%" />  
                        <col width="*" />  
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">TABLE</th> 
                            <th scope="col">COLUMN</th>  
                            <th scope="col">COLUMN COMMENT</th>  
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "270">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						<td><%=CommonUtil.nvl(rowData.get("TABLE_NAME"))%></td>
						<td><%=CommonUtil.nvl(rowData.get("COLUMN_NAME"))%></td>
						<td><%=CommonUtil.nvl(rowData.get("COMMENTS"))%></td>
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
