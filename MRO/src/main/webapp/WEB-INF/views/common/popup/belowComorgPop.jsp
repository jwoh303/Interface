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
String buyer = CommonUtil.nvl((String) request.getParameter("buyer"),"");  //  (조회조건)
%>
<script type="text/javascript">
<!--
function setQuery()
{    

	if (kepIsEmpty("buyer")==true){
		alert("검색조건을 입력하세요.");
		return;
	} 
	
  $('#belowComorgPop').attr("action", "/common/commonList.do").submit();   
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
 //-->
</script> 
<body onload="">
	 <form name=belowComorgPop id=belowComorgPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="belowComorgPop"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	 <div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">하위조직코드</h1>
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
						<caption>하위조직코드 검색 리스트</caption>
						<colgroup>
							<col width="70px" />
							<col width="30%" />
							<col width="70px" /> 
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>회사</td>
							<td> 
								<input type=text name="buyer" id="buyer" size=20 value="<%=buyer%>" onkeydown="kepEnter()" class="input_type_text"> 
								<input type=text name="tem_input_h" id="tem_input_h" style="display: none;" /> 
                            </td>
							<td></td>						
							<td> 
                            </td>
                         </tr> 
					</tbody>
				</table>
            </div>            
            <div class="scrollArea" style="height:338px">
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>하위조직코드 리스트</caption>
                    <colgroup>
                        <col width="30%" />   
                        <col width="*" />   
                    </colgroup>		   
                    <thead> 
                        <tr>
                            <th scope="col">코드</th> 
                            <th scope="col">조직명</th>    
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="2" align="center" height = "270">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						   <td ><%=CommonUtil.nvl(rowData.get("CODE"))%></td>
							<td ><a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT")%>','')"><%=CommonUtil.nvl(rowData.get("TEXT"))%></a></td> 
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
