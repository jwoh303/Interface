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
String com_code = CommonUtil.nvl((String) request.getParameter("com_code"),"");  //  (조회조건) 
String type = CommonUtil.nvl((String) request.getParameter("type"),"");  //  (조회조건) 
%>
<body onload="">
	 <form name=positionCodePop id=positionCodePop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="positionCodePop">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:414px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">대상자 정보</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div class="scrollArea" style="height:338px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>대상자 정보</caption>
                    <colgroup>
                        <col width="20%" />
                        <col width="20%" />  
                        <col width="20%" />    
                        <col width="*" />   
                    </colgroup>		   
                    <thead> 
                        <tr>
                            <th scope="col">사용자ID</th> 
                            <th scope="col">사번</th>
                            <th scope="col">사용자명</th>
                            <th scope="col">부서</th>   
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="2" align="center" height = "270">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						   	<td class="left"><%=CommonUtil.nvl(rowData.get("USER_ID"))%></td>
							<td class="left"><%=CommonUtil.nvl(rowData.get("LEGACY_USER_ID"))%></td>
							<td class="left"><%=CommonUtil.nvl(rowData.get("USER_NAME_LOC"))%></td>
							<td class="left"><%=CommonUtil.nvl(rowData.get("DEPARTMENT_NM"))%></td>
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
