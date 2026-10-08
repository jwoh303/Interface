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
String DESCRIPTION = CommonUtil.nvl((String) request.getParameter("DESCRIPTION"),"");  //  (조회조건) 
String SPECIFICATION = CommonUtil.nvl((String) request.getParameter("SPECIFICATION"),"");  //  (조회조건) 
%>
<script type="text/javascript">
<!--
function setQuery()
{ 
	  $('#standardcatalogidPop').attr("action", "/common/commonList.do").submit();    
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

function popupOnload(){
	//kepAjaxCommonQueryIdCombo('getWareHouseList','sampleCombo','SEL');
}
 

 //-->
</script> 
<body>
	 <form name=standardcatalogidPop id=standardcatalogidPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="standardcatalogidPop"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">표준카탈로그</h1>
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
						<caption>표준카탈로그 검색 리스트</caption>
						<colgroup>
							<col width="50px" />
							<col width="30%" />
							<col width="50px" /> 
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>품목명</td>
							<td> 
								<input type=text name=DESCRIPTION  id="DESCRIPTION"  value="<%=DESCRIPTION%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
							<td>규격</td>						
							<td> 
								<input type=text name=SPECIFICATION id="SPECIFICATION"  value="<%=SPECIFICATION%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
                         </tr> 
					</tbody>
				</table>
            </div>            
            <div class="scrollArea" style="height:340px">
            	 <!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>업체검색 리스트</caption>
                    <colgroup>
                        <col width="15%" />  
                        <col width="15%" />  
                        <col width="15%" />  
                        <col width="*" />  
                        <col width="15%" />  
                        <col width="15%" />  
                        <col width="7%" />   
                    </colgroup>
                    <thead> 
                        <tr>
                            <th scope="col">카테고리명</th> 
                            <th scope="col">카테고리ID</th>  
                            <th scope="col">표준카탈로그ID</th>  
                            <th scope="col">품목명</th>  
                            <th scope="col">규격</th>  
                            <th scope="col">제조사</th>  
                            <th scope="col">구매<br>사수</th>  
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="7" align="center" height = "250">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						   <td ><%=CommonUtil.nvl(rowData.get("CATEG_NAME"))%></td>
							<td ><a href="javascript:setReturn('<%=rowData.get("CATEG_NAME")%>','<%=rowData.get("STDCATEG_ID")%>','')"><%=CommonUtil.nvl(rowData.get("STDCATEG_ID"))%></a></td>
							<td ><a href="javascript:setReturn('<%=rowData.get("CATEG_NAME")%>','<%=rowData.get("STDCATEG_ID")%>','')"><%=CommonUtil.nvl(rowData.get("STDCATLG_ID"))%></a></td>
							<td ><a href="javascript:setReturn('<%=rowData.get("CATEG_NAME")%>','<%=rowData.get("STDCATEG_ID")%>','')"><%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%></a></td>
							<td ><a href="javascript:setReturn('<%=rowData.get("CATEG_NAME")%>','<%=rowData.get("STDCATEG_ID")%>','')"><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></a></td>
							<td ><a href="javascript:setReturn('<%=rowData.get("CATEG_NAME")%>','<%=rowData.get("STDCATEG_ID")%>','')"><%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%></a></td>
							<td ><%=CommonUtil.bnvl(rowData.get("COUNT"))%></td>
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
