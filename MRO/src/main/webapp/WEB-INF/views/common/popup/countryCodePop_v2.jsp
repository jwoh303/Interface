<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과 
String country_search = CommonUtil.nvl((String) request.getParameter("country_search"),"");  //  (조회조건)
String initLoadFlag = CommonUtil.nvl((String) request.getParameter("initLoadFlag"),"N");  //  (조회조건)
%>
<script type="text/javascript">
function init() {
<%
	if (!"Y".equals(initLoadFlag)){
%>
	$("#country_search").val("대한민국");
	codeQuery();
	$("#country_search").focus();
<%	
	}
%>  
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		codeQuery();
	}
}

function codeQuery(){
	var str = $("#country_search").val();
	$("#country_search").val(str.toUpperCase());   
	$('#countryCodePop').attr("action", "/common/commonList.do").submit();    
}

function setOnkey(key){
  if(key == "13")
  {
    codeQuery();
  }
}

function setReturn(value1,value2,value3){ 
  opener.setPopupReturn(value1,value2,value3);
  this.close();
}
</script> 
<body onload="init(); ">
	 <form name=countryCodePop id=countryCodePop method=post>
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="countryCodePop_v2">
	 <input type="hidden" name="initLoadFlag" id="initLoadFlag"  value="Y">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup"  >
		<div class="PopupTit"><%=CommonLang.get("HTITLE120")%><!-- 원산지 --></div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--조회영역-->
            <table  class="PopupSearchTable mt10" width="100%">
				<caption>원산지 리스트</caption>
				<colgroup>
					<col width="20%" />
					<col width="60%" />
					<col width="20%" />
				</colgroup>						
				<tbody>
					<tr>
						<td><%=CommonLang.get("HTITLE494")%><!-- 국가명 --></td>
						<td> 
							<input type=text class="input40" name="country_search" id="country_search" size=20 value="<%=country_search%>" onkeydown="kepEnter()">
							<input type=text name="tem_input_h" id="tem_input_h" style="display: none;" /> 
	                    </td>
	                    <td>
	                    	<button class="ButDarkGray_Medium" onclick="javascript:codeQuery();"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></button>  
	                    </td>
					</tr>					 
				</tbody>
			</table>
           	<!--grid-->
			<div class="ScrollBox mt20" style="height:332px">
				<table class="Table16px"  style="width:100%;" >
                    <caption>원산지 리스트</caption>
                    <colgroup>
                        <col width="20%" /> 
                        <col width="40%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th><%=CommonLang.get("HTITLE371")%><!-- 코드 --></th> 
                            <th><%=CommonLang.get("HTITLE495")%><!-- 국가명 (영문) --></th> 
                            <th><%=CommonLang.get("HTITLE496")%><!-- 국가명 (국문) --></th> 
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
