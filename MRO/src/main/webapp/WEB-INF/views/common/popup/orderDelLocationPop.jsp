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
String del_code = CommonUtil.nvl((String) request.getParameter("del_code"),"");  //  (조회조건) 
String del_name = CommonUtil.nvl((String) request.getParameter("del_name"),"");  //  (조회조건) 
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)

SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String userId = "";
if (sessionInfo != null){ 
	userId = CommonUtil.nvl((String)sessionInfo.getUserId()); 
}
%>

<script type="text/javascript">
function kep_onload(){
	<% if ("Y".equals(open)){%>
	setQuery();
  <%}%>
}

function setQuery(){
  	$('#orderDelLocationPop').attr("action", "/common/commonList.do").submit();
}

function kepEnter(){
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2, value3){
  opener.setPopupReturn(value1,value2, value3);
  this.close();
}

function popupOnload(){
}
</script>
 
<body onload="kep_onload();">
	 <form name=orderDelLocationPop id=orderDelLocationPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="orderDelLocationPop"> 
	 <input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>"> 	
	 <input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE942") %><!-- 배송이력 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
※ 최근 3개월 간 주문 내역의 배송지 정보입니다.
            	<span class="btn_search"><a href="javascript:setQuery();"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>배송이력 검색 리스트</caption>
						<colgroup>
							<col width="50px" />
							<col width="10%" />
							<col width="5%" />
							<col width="120px" /> 
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td><%=CommonLang.get("HTITLE371") %><!-- 코드 --></td>						
							<td> 
								<input type=text name="del_code" id="del_code" size=10 value="<%=del_code%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td> 
                            <td></td>
							<td><%=CommonLang.get("HTITLE373") %><!-- 도착지주소 --></td>
							<td> 
								<input type=text name="del_name"  id="del_name" size=20 value="<%=del_name%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td> 
                         </tr> 
					</tbody>
				</table>
            </div>            
             <div class="scrollArea" style="height:330px">
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>직급 리스트</caption>
                    <colgroup>
                        <col width="20%" />  
                        <col width="*" />   
                    </colgroup>		   
                    <thead> 
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE371") %><!-- 코드 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE373") %><!-- 도착지주소 --></th>   
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="2" align="center" height = "250">
                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                       
						<tr>
							<td colspan="2">
								<table style="border:0px; width:100%">
				 					<tr>
									   <td style="border:0px; width:20%;"><a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT2")%>','<%=rowData.get("TEXT1")%>')"><%=CommonUtil.nvl(rowData.get("CODE"))%></td>
										<td style="border:0px;" class="left"><a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT2")%>','<%=rowData.get("TEXT1")%>')"><%=CommonUtil.nvl(rowData.get("TEXT2"))%></a></td>
									</tr> 
								</table>
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
