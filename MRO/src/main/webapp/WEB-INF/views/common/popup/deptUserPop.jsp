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
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   
String buyer = CommonUtil.nvl((String) request.getParameter("buyer"),"KRHITE0003");  //  (조회조건) <-- 고쳐야함
String po_dept = CommonUtil.nvl((String) request.getParameter("po_dept"),"");  //  (조회조건) 
String po_user_id = CommonUtil.nvl((String) request.getParameter("po_user_id"),"");  //  (조회조건) 
%>
<script type="text/javascript">
function kep_onload_view(){ 
<%
	if(_sessionInfo == null){
%>
		$('#deptUserPop').attr("action", "http://www.koreab2b.com").submit();
<%
	}
%>
}
<!--
function setQuery()
{  
  $('#deptUserPop').attr("action", "/common/commonList.do").submit();      
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
<body onload="kep_onload_view();">
	 <form name=deptUserPop id=deptUserPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="deptUserPop"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">발주부서 & 발주자</h1>
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
						<caption>발주 검색 리스트</caption>
						<colgroup>
							<col width="70px" />
							<col width="30%" />
							<col width="70px" /> 
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>구매회사</td>
							<td> 
								<input type=text name="buyer" id="buyer" size=20 value="<%=buyer%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
							<td>발주부서</td>						
							<td> 
							  <%
                             Map<String, String> _map = new HashMap<String, String>();
                             _map.put("BUYER",buyer);
                             %>
							<select name="po_dept" id="po_dept">   
								<%=CommonUtil.getCodeComboQueryIdList("common.getDeptCombo","SEL",_map,po_dept)%>
							</select>
                            </td>
                         </tr> 
						<tr>
							<td>발주자</td>
							<td colspan="3"> 
							<select name="po_user_id" id="po_user_id">   
								<%= CommonUtil.getCodeComboQueryIdList("common.getPoUserId","SEL",_map,po_user_id)%>
							</select>
                            </td> 
                         </tr> 
					</tbody>
				</table>
            </div>            
            <div class="scrollArea" style="height:318px">
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>발주 리스트</caption>
                    <colgroup>
                        <col width="20%" />  
                        <col width="20%" />  
                        <col width="20%" />  
                        <col width="*" />   
                    </colgroup>		   
                    <thead> 
                        <tr>
                            <th scope="col">발주부서코드</th> 
                            <th scope="col">발주부서명</th>   
                            <th scope="col">발주자ID</th>   
                            <th scope="col">발주자</th>   
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="4" align="center" height = "250">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						   <td ><%=CommonUtil.nvl(rowData.get("DEPARTMENT"))%></td>
							<td ><a href="javascript:setReturn('<%=rowData.get("DEPARTMENT")%>','<%=rowData.get("DEPARTMENT_TEXT")%>','')"><%=CommonUtil.nvl(rowData.get("DEPARTMENT_TEXT"))%></a></td>
							<td ><a href="javascript:setReturn('<%=rowData.get("DEPARTMENT")%>','<%=rowData.get("DEPARTMENT_TEXT")%>','')"><%=CommonUtil.nvl(rowData.get("USER_ID"))%></a></td>
							<td ><a href="javascript:setReturn('<%=rowData.get("DEPARTMENT")%>','<%=rowData.get("DEPARTMENT_TEXT")%>','')"><%=CommonUtil.nvl(rowData.get("USER_NAME_LOC"))%></a></td>
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
