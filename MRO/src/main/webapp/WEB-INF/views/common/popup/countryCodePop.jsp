<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과 
String country_search = CommonUtil.nvl((String) request.getParameter("country_search"),"");  //  (조회조건)
String initLoadFlag = CommonUtil.nvl((String) request.getParameter("initLoadFlag"),"N");  //  (조회조건)
%>
<script type="text/javascript">
<!--
function init()
{
<%
	if (!"Y".equals(initLoadFlag)){
%>
	document.forms[0].country_search.value = "대한민국";
	codeQuery();
	document.forms[0].country_search.focus();
<%	
	}
%>  
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		codeQuery();
	}
}

function codeQuery()
{
  document.forms[0].country_search.value = document.forms[0].country_search.value.toUpperCase();   
  $('#countryCodePop').attr("action", "/common/commonList.do").submit();    
}

function setOnkey(key)
{
  if(key == "13")
  {
    codeQuery();
  }
}
function setReturn(value1,value2,value3)
{ 
  opener.setPopupReturn(value1,value2,value3);
  this.close();
}
 //-->
</script> 
<body onload="init(); ">
	 <form name=countryCodePop id=countryCodePop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="countryCodePop">
	 <input type="hidden" name="initLoadFlag" id="initLoadFlag"  value="Y">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE120")%><!-- 원산지 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
                 <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:codeQuery();"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></a></span>  
            </div>  
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>원산지 리스트</caption>
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
							<td><%=CommonLang.get("HTITLE494")%><!-- 국가명 --></td>
							<td> 
								<input type=text class="input_type_text" name=country_search id="country_search" size=20 value="<%=country_search%>" onkeydown="kepEnter()" style="ime-mode:active">
								<input type=text name="tem_input_h" id="tem_input_h" style="display: none;" /> 
                            </td>
						    <td></td>						 
							<td  class="right"> 
							</td>
						</tr>					 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:338px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>우편번호 리스트</caption>
                    <colgroup>
                        <col width="20%" /> 
                        <col width="40%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE371")%><!-- 코드 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE495")%><!-- 국가명 (영문) --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE496")%><!-- 국가명 (국문) --></th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "230">
                        <span class="font1"><%=CommonLang.msg("MSG347")%><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						<td>
						  <a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','<%=rowData.get("TEXT2")%>')"><%=rowData.get("CODE")%></a>
						</td>
						<td class="left">
						  <a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','<%=rowData.get("TEXT2")%>')"><%=rowData.get("TEXT1")%></a>
					   </td>
						<td class="left">
							<a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','<%=rowData.get("TEXT2")%>')"><%=rowData.get("TEXT2")%></a>
						</td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table> 
                 
        </div>
    </div>       
    
    <!--  팝업내용종료 --> 
</div>
</form> 
</body>
</html>
