<%--
**********************************************
* 메뉴 : 
* 화면 : 협력사리스트
* 기능 : 협력사리스트 팝업
* 프로그램 ID : 
* 담당자 :  한승준 ( 설계 : 공통 )
* 착수일 : 2021-08-11
**********************************************
--%>
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

<script type="text/javascript">
</script> 
<body>
	 <form name=deptCodeAdminPop id=deptCodeAdminPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="deptCodeAdminPop">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">개인정보 3자 제공처</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<!--<span class="btn_search"><a href="javascript:setQuery();">조회</a></span>-->
            </div>
           	<!--grid-->
            <div class="scrollArea" style="height:368px">
                <table  class="cont_t_list02" style="width:100%">
                    <caption>부서검색 리스트</caption>
                    <colgroup>
                        <col width="*" />
                        <col width="35%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">협력사명</th>
                            <th scope="col">대표자명</th>
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
						<tr bgcolor="#FFFFFF">
       						<td colspan="2" align="center" height = "50">
       							<span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
    						</td>
						</tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%>
						<tr>
							<td class="left">
								<%=rowData.get("COM_NAME_LOC")%></a>
							</td>
							<td class="left">
								<%=rowData.get("CEO_NAME_LOC")%></a>
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
