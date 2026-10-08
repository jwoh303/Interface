<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
/*
사용안함 - 2014.08.28
사용안함 - 2014.08.28
사용안함 - 2014.08.28
사용안함 - 2014.08.28
사용안함 - 2014.08.28
사용안함 - 2014.08.28
사용안함 - 2014.08.28
사용안함 - 2014.08.28
사용안함 - 2014.08.28
사용안함 - 2014.08.28
사용안함 - 2014.08.28
사용안함 - 2014.08.28
사용안함 - 2014.08.28
*/
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과  
String com_type = CommonUtil.nvl((String) request.getParameter("com_type"),"");  //  (조회조건) 

String buyer = "";
String userid = "";
if (_sessionInfo != null){
	buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
	userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
} 
%>
<script type="text/javascript">
<!--
function setQuery()
{  
  $('#processTypePop').attr("action", "/common/commonList.do").submit();       
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2)
{
	if($("#st_warehouse_code_"+value1).length > 0 && isEmpty($("#st_warehouse_code_"+value1).val())){
		alert(value2+"물류센터를 반드시 선택 하셔야 합니다");
		$("#st_warehouse_code_"+value1).focus();
		return;
	}
	
	if(value1 == "1" || value1 == "2" || value1 == "3"){
		var warehouse_code = $("#st_warehouse_code_"+value1).val();
		var warehouse_name = $("#st_warehouse_code_"+value1+" option:selected").text();
		opener.setPopupReturn(value1,value2,warehouse_code,warehouse_name);
	}else{
		opener.setPopupReturn(value1,value2);
	}
	this.close();
}



function popupOnload(){
	//kepAjaxCommonQueryIdCombo('getWareHouseList','sampleCombo','SEL');
}
 

 //-->
</script>  
<body onload="">
	 <form name=processTypePop id=processTypePop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="processTypePop"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">거래유형</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:setQuery();">조회</a></span>  
            </div>      
            <div class="scrollArea" style="height:338px">
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>업체검색 리스트</caption>
                    <colgroup>
                        <col width="30%" /> 
                        <col width="*" />   
                    </colgroup>
                    <thead>
                        <tr> 
                            <th scope="col">코드</th>  
                            <th scope="col">거래유형명</th>   
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="2" align="center" height = "250">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr> 
						<td><%=CommonUtil.nvl(rowData.get("CODE"))%></td>
						<td>
						
						<a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT2")%>','')"><%=CommonUtil.nvl(rowData.get("TEXT2"))%></a>
						<% if ("1".equals(rowData.get("CODE")) || "2".equals(rowData.get("CODE")) || "3".equals(rowData.get("CODE"))) { %> <!--  TR -->
								&nbsp;&nbsp;<select id="st_warehouse_code_<%=rowData.get("CODE")%>" name="t_warehouse_code_<%=rowData.get("CODE")%>" style="width:80%;height:20px">
								<%
						 			Map<String, String> _map = new HashMap<String, String>();
						 			_map.put("BUYER",buyer);
						 			_map.put("USERID",userid);
								%>
								<%= CommonUtil.getCodeComboQueryIdList("common.getWareHouseIdSchList","",_map,"") %>
								</select>						 
						<%} %>
						</td> 
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
