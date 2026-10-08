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
String table = CommonUtil.nvl((String) request.getParameter("table"),"1");  //  (조회조건)  
String type = CommonUtil.nvl((String) request.getParameter("type"),"");  //  (조회조건)  
String tableNm = "ICOMCOD"+table;
String queryId = "common.getICOMCOD"+table;
String typeGubun = "";
if ("1".equals(table)){
	typeGubun = "TYPE";
}else if ("2".equals(table)){
	typeGubun = "COMPANY_CODE";
}else if ("3".equals(table)){
	typeGubun = "BUYER";
}else if ("4".equals(table)){
	typeGubun = "BUYER";
}else if ("5".equals(table)){
	typeGubun = "COMPANY_CODE";
}
%>
<script type="text/javascript">
<!--
function setQuery()
{  
  $('#icomcdPop').attr("action", "/common/icomcdpopList.do").submit();        
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
	 <form name=icomcdPop id=icomcdPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="icomcdPop"> 
	 <input type="hidden" name="table" id="table"  value="<%=table%>"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">ICOMCOD 공통코드 샘플</h1>
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
						<caption>ICOMCOD 공통코드 샘플 검색 리스트</caption>
						<colgroup>
							<col width="70px" />
							<col width="30%" />
							<col width="70px" /> 
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>공통코드테이블</td>
							<td> 
								<input type=text name="tableNm" id="tableNm" size=20 value="<%=tableNm%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
							<td>코드구분</td>						
							<td><%=typeGubun %>&nbsp;
								<select name="type" id="type">
									<%=CommonUtil.getCodeComboQueryIdList(queryId,"SEL",null,type)%>
								</select> 
                            </td>
                         </tr> 
					</tbody>
				</table>
            </div>            
            <div class="scrollArea" style="height:318px">
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>ICOMCOD 공통코드 샘플 리스트</caption>
                    <colgroup>
                        <col width="30%" />   
                        <col width="30%" />   
                        <col width="*" />   
                    </colgroup>		   
                    <thead> 
                        <tr>
                            <th scope="col">code</th> 
                            <th scope="col">text1</th>    
                            <th scope="col">text2</th>    
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "260">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
%>
</table>
<div  class="scrollArea" >         
<table  class="cont_t_list02"  style="width:100%">
	<caption>검색 리스트</caption>
	<colgroup>
	            <col width="30%" />   
	            <col width="30%" />   
	            <col width="*" />   
	</colgroup>
	<thead>
	</thead>
	<tbody>
<%
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						   <td ><%=CommonUtil.nvl(rowData.get("CODE"))%></td>
							<td ><a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','')"><%=CommonUtil.nvl(rowData.get("TEXT1"))%></a></td> 
							<td ><a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','')"><%=CommonUtil.nvl(rowData.get("TEXT2"))%></a></td> 
						</tr> 
<% } %>
<%}%> 
                    </tbody>
    </table>  		                                  
             </div>
        </div>
    </div>        
</div>
</form> 
</body>
</html>
