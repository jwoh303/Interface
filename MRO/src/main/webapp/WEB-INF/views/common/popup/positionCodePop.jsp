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
String com_code = CommonUtil.nvl((String) request.getParameter("com_code"),"");  //  (조회조건) 
String type = CommonUtil.nvl((String) request.getParameter("type"),"");  //  (조회조건) 
%>
<script type="text/javascript">
<!--
function setQuery()
{  
	
	if (kepIsEmpty("com_code")==true && kepIsEmpty("type")==true){
	    alert("검색조건을 입력하세요.");
		return;
	} 
	
  $('#positionCodePop').attr("action", "/common/commonList.do").submit();     
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
	 <form name=positionCodePop id=positionCodePop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="positionCodePop">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:414px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE476") %><!-- 직급 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
<%--
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:setQuery();">조회</a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>직급 검색 리스트</caption>
						<colgroup>
							<col width="70px" />
							<col width="30%" />
							<col width="70px" /> 
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>회원사코드</td>
							<td> 
								<input type=text name="com_code"  id="com_code" size=20 value="<%=com_code%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
							<td>코드종류</td>						
							<td> 
								<input type=text name="type" id="type" size=20 value="<%=type%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
                         </tr> 
					</tbody>
				</table>
            </div>
 --%>
            	<!--grid-->
            <div class="scrollArea" style="height:338px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>직급 리스트</caption>
                    <colgroup>
                        <col width="30%" />  
                        <col width="*" />   
                    </colgroup>		   
                    <thead> 
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE376") %><!-- 직급코드 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE377") %><!-- 직급명 --></th>   
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="2" align="center" height = "270">
                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						   <td ><%=CommonUtil.nvl(rowData.get("CODE"))%></td>
							<td class="left"><a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','')"><%=CommonUtil.nvl(rowData.get("TEXT1"))%></a></td>
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
