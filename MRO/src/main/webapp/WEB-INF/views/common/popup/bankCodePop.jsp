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
String bank = CommonUtil.nvl((String) request.getParameter("bank"),"");  //  (조회조건) 
String franch = CommonUtil.nvl((String) request.getParameter("franch"),"");  //  (조회조건) 
%>
<script type="text/javascript">
<!--
function setQuery()
{  
	
	if (kepIsEmpty("bank")==true && kepIsEmpty("franch")==true){
		alert("은행명ㅇ 입력하세요.");
		return;
	} 
	
  $('#bankCodePop').attr("action", "/common/commonList.do").submit();   
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
	 <form name=bankCodePop id=bankCodePop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="bankCodePop">
	 <input type="hidden" name="franch" id="franch" size=20 value="<%=franch%>" onkeydown="kepEnter()" class="input_type_text"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">은행</h1>
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
						<caption>은행 검색 리스트</caption>
						<colgroup>
							<col width="140px" />
							<col width="20%" />
							<!-- <col width="50px" /> 
                            <col width="*" /> -->
						</colgroup>						
						<tbody>
						<tr>
							<td>은행명</td>
							<td> 
								<input type=text name="bank"  id="bank" size=20 value="<%=bank%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
							<%-- <td>지점명</td>						
							<td> 
								<input type=text name="franch" id="franch" size=20 value="<%=franch%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td> --%>
                         </tr>  
					</tbody>
				</table>
            </div>            
            <div class="scrollArea" style="height:338px">
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>은행 리스트</caption>
                    <colgroup>
                        <col width="40%" />  
                        <col width="60%" />   
                        <!-- <col width="*" />   --> 
                    </colgroup>		   
                    <thead> 
                        <tr>   
                            <th scope="col">코드</th> 
                            <th scope="col">은행명 (국문)</th>    
                            <!-- <th scope="col">지점</th> -->   
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "250">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						   <td ><%=CommonUtil.nvl(rowData.get("CODE"))%></td>
							<td ><a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1") + " " + CommonUtil.nvl(rowData.get("TEXT2")) %>','')"><%=CommonUtil.nvl(rowData.get("TEXT1"))%></a></td>
						<%-- 	<td ><a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1") + " " + CommonUtil.nvl(rowData.get("TEXT2")) %> ','')"><%=CommonUtil.nvl(rowData.get("TEXT2"))%></a></td> --%> 
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
