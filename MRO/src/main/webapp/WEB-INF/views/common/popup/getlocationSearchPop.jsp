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
String sido = CommonUtil.nvl((String) request.getParameter("sido"),"");  //  (조회조건) 
String gugun = CommonUtil.nvl((String) request.getParameter("gugun"),"");  //  (조회조건) 
%>
<script type="text/javascript">
<!--
function setQuery()
{  
  $('#getlocationSearchPop').attr("action", "/common/commonList.do").submit();      
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
	 <form name=getlocationSearchPop id=getlocationSearchPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="getlocationSearchPop"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">소재지</h1>
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
						<caption>소재지 검색 리스트</caption>
						<colgroup>
							<col width="70px" />
							<col width="30%" />
							<col width="70px" /> 
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>시도</td>
							<td> 
								<select name="sido" id="sido">           
									 <option value="서울" <% if ("서울".equals(sido)) { %> selected <%} %>>서울특별시</option>
									<option value="인천" <% if ("인천".equals(sido)) { %> selected <%} %>>인천광역시</option>
									<option value="경기" <% if ("경기".equals(sido)) { %> selected <%} %>>경기도</option>
									<option value="강원" <% if ("강원".equals(sido)) { %> selected <%} %>>강원도</option>
									<option value="대전" <% if ("대전".equals(sido)) { %> selected <%} %>>대전광역시</option>
									<option value="충북" <% if ("충북".equals(sido)) { %> selected <%} %>>충청북도</option>
									<option value="충남" <% if ("충남".equals(sido)) { %> selected <%} %>>충청남도</option>
									<option value="대구" <% if ("대구".equals(sido)) { %> selected <%} %>>대구광역시</option>
									<option value="경북" <% if ("경북".equals(sido)) { %> selected <%} %>>경상북도</option>
									<option value="경남" <% if ("경남".equals(sido)) { %> selected <%} %>>경상남도</option>
									<option value="울산" <% if ("울산".equals(sido)) { %> selected <%} %>>울산광역시</option>
									<option value="부산" <% if ("부산".equals(sido)) { %> selected <%} %>>부산광역시</option>         	
									<option value="광주" <% if ("광주".equals(sido)) { %> selected <%} %>>광주광역시</option>
									<option value="전북" <% if ("전북".equals(sido)) { %> selected <%} %>>전라북도</option>
									<option value="전남" <% if ("전남".equals(sido)) { %> selected <%} %>>전라남도</option>
									<option value="제주" <% if ("제주".equals(sido)) { %> selected <%} %>>제주도</option>
								 </select>
                            </td>
							<td>구군</td>						
							<td> 
								<input type=text name="gugun" id="gugun" size=20 value="<%=gugun%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
                         </tr> 
					</tbody>
				</table>
            </div>            
            <div class="scrollArea" style="height:338px">
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>소재지 리스트</caption>
                    <colgroup>
                        <col width="30%" />  
                        <col width="*" />   
                    </colgroup>		   
                    <thead> 
                        <tr>
                            <th scope="col">시(도)</th> 
                            <th scope="col">시/구/군</th>   
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
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						   <td ><%=CommonUtil.nvl(rowData.get("SIDO"))%></td>
							<td ><a href="javascript:setReturn('<%=rowData.get("SIDO")%>','<%=rowData.get("GUGUN")%>','')"><%=CommonUtil.nvl(rowData.get("GUGUN"))%></a></td>
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
