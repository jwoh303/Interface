<%--
**********************************************
* 메뉴 : 
* 화면 : 취급가능품목
* 기능 : 
* 프로그램 ID : 
* 담당자 :  고영일 ( 설계 : 공통 )
* 착수일 : 2014-06-24
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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
%>

<script type="text/javascript">
<!--
function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}
 //-->
</script> 
<body onload="">
<form name="commonCoCoTranGoodsPop" id="commonCoCoTranGoodsPop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">취급가능품목</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div class="scrollArea" style="height:410px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>부서코드 리스트</caption>
                    <colgroup>
                        <col width="10%" /> 
                        <col width="23%" /> 
                        <col width="10%" /> 
                        <col width="23%" /> 
                        <col width="10%" /> 
                        <col width="" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">SG코드</th> 
                            <th scope="col">SG명</th>
                            <th scope="col">SG코드</th> 
                            <th scope="col">SG명</th>
                            <th scope="col">SG코드</th> 
                            <th scope="col">SG명</th>
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
						<td><%=_tmp.get("SG_ID_A")%></td>
						<td>
						 	<a class="hyperLink" href="javascript:setReturn('<%=_tmp.get("SG_ID_A")%>','<%=_tmp.get("SG_NAME_A")%>','')">
							<%=_tmp.get("SG_NAME_A")%></a>
						</td>
						<td><%=_tmp.get("SG_ID_B")%></td>
						<td>
						 	<a class="hyperLink" href="javascript:setReturn('<%=_tmp.get("SG_ID_B")%>','<%=_tmp.get("SG_NAME_B")%>','')">
							<%=_tmp.get("SG_NAME_B")%></a>
						</td>
						<td><%=_tmp.get("SG_ID_C")%></td>
						<td>
						 	<a class="hyperLink" href="javascript:setReturn('<%=_tmp.get("SG_ID_C")%>','<%=_tmp.get("SG_NAME_C")%>','')">
							<%=_tmp.get("SG_NAME_C")%></a>
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
