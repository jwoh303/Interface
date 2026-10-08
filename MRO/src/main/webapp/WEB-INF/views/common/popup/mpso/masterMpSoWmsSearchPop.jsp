<%--
**********************************************
* 메뉴 : 
* 화면 : 물류센터 검색 팝업
* 기능 : 물류센터를 검색하기 위한 팝업
* 프로그램 ID : 
* 담당자 :  고영일 ( 설계 : 김지현 )
* 착수일 : 2014-08-21
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
<form name="masterMpSoWmsSearchPop" id="masterMpSoWmsSearchPop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:504px;">
    	<div id="popHeader">
        	<h1 class="title">물류센터 검색</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div class="scrollArea" style="height:428px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>물류센터 검색 리스트</caption>
                    <colgroup>
                        <col width="30%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">센터코드</th> 
                            <th scope="col">센터명</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="2" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
						<td>
						 	<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>')">
							<%=_tmp.get("CODE")%></a>
						</td>
						<td class="left">
						  	<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>')">
							<%=_tmp.get("TEXT1")%></a>
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
