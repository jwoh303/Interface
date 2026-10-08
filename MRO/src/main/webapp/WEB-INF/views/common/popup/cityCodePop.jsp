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
String country_search = CommonUtil.nvl((String) request.getParameter("country_search"),"");  //  (조회조건) 
String city_search = CommonUtil.nvl((String) request.getParameter("city_search"),"");  //  (조회조건) 
%>
<script type="text/javascript">
<!--
function setQuery()
{    
	
	if (kepIsEmpty("country_search") && kepIsEmpty("city_search")){
		alert("적어도 하나의 검색조건을 입력하셔야 합니다.");
		return;
	} 
	
  $('#cityCodePop').attr("action", "/common/commonList.do").submit();   
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
<body onload="">
	 <form name=cityCodePop id=cityCodePop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="cityCodePop"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE493") %><!-- 도시 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:setQuery();"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>도시 검색 리스트</caption>
						<colgroup>
							<col width="50px" />
							<col width="20%" />
							<col width="50px" /> 
                            <col width="*" />
						</colgroup>
						<tbody>
						<tr>
							<td><%=CommonLang.get("HTITLE460") %><!-- 국가 --></td>
							<td> 
								<input type=text name="country_search"  id="country_search" size=20 value="<%=country_search%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
							<td><%=CommonLang.get("HTITLE493") %><!-- 도시 --></td>						
							<td> 
								<input type=text name="city_search" id="city_search" size=20 value="<%=city_search%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
                         </tr>  
					</tbody>
				</table>
            </div>            
            <div class="scrollArea" style="height:338px">	 
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>도시 리스트</caption>
                    <colgroup>
                        <col width="20%" />  
                        <col width="40%" />   
                        <col width="*" />   
                    </colgroup>		   
                    <thead> 
                        <tr>   
                            <th scope="col"><%=CommonLang.get("HTITLE371") %><!-- 코드 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE493") %><!-- 도시 --></th>    
                            <th scope="col"><%=CommonLang.get("HTITLE460") %><!-- 국가 --></th>   
                        </tr>
                    </thead>
                   <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "270">
                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						   <td ><%=CommonUtil.nvl(rowData.get("COUNTRY_CODE"))%></td>
							<td ><a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','')"><%=CommonUtil.nvl(rowData.get("TEXT1"))%></a></td>
							<td ><a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','')"><%=CommonUtil.nvl(rowData.get("COUNTRY_NAME"))%></a></td> 
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
