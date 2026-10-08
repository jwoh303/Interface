<%--
**********************************************
* 메뉴 : 
* 화면 : 공급유형별 협력사 검색
* 기능 : 공급유형별 물류센텨벌 협력사를 검색하기 위한 팝업
* 프로그램 ID : PG_06_M_017_01
* 담당자 :  고영일 ( 설계 : 공통 )
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
String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"");  //  (조회조건)
String st_process_type = CommonUtil.nvl((String) request.getParameter("st_process_type"),"");  //  (조회조건)
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
<form name="masterMpSoAgntcmpyTypePop" id="masterMpSoAgntcmpyTypePop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:504px;">
    	<div id="popHeader">
        	<h1 class="title">협력사</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div class="scrollArea" style="height:428px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>협력사 리스트</caption>
                    <colgroup>
                        <col width="30%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">협력사코드</th> 
                            <th scope="col">협력사명</th> 
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
						 	<a href="javascript:setReturn('<%=_tmp.get("AGENT")%>','<%=_tmp.get("AGENT_NAME")%>')">
							<%=_tmp.get("AGENT")%></a>
						</td>
						<td class="left">
						  	<a href="javascript:setReturn('<%=_tmp.get("AGENT")%>','<%=_tmp.get("AGENT_NAME")%>')">
							<%=_tmp.get("AGENT_NAME")%></a>
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
