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
String user_id = CommonUtil.nvl((String) request.getParameter("user_id"),"");  //  (조회조건)
String user_name_loc = CommonUtil.nvl((String) request.getParameter("user_name_loc"),"");  //  (조회조건)
String dept_code = CommonUtil.nvl((String) request.getParameter("dept_code"),"");  //  (조회조건)
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)
String result = CommonUtil.nvl((String)request.getAttribute("result")); // 조회된결과
String user_dept = CommonUtil.nvl((String) request.getParameter("user_dept"),"");  //  (조회조건)
%>
<script type="text/javascript">
function kep_onload_view(){ 
<%
	if(_sessionInfo == null){
%>
		$('#misUserSelectDeptPop').attr("action", "http://www.koreab2b.com").submit();
<%
	}else{
		if(_sessionInfo.getComCode().equals("KRKORE0001") == false){
			com_code = _sessionInfo.getComCode();
		}
	}
%>
 <% if ("O".equals(open)){%>
		$('#misUserSelectAllPop').attr("action", "/common/commonList.do").submit();   
  <%}%>
}
function setQuery()
{  
	if (kepIsEmpty("user_dept")==true && kepIsEmpty("user_name_loc")==true){
		alert("<%=CommonLang.msg("MSG395") %>");	//검색조건을 입력하세요.
		return;
	} else{	
  		$('#misUserSelectDeptPop').attr("action", "/common/commonList.do").submit();		
	}
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}

function setReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11) // id,이름,부서코드,부서명,전화번호,email,fax,휴대폰,우편번호,주소
{ 
  opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11);
  this.close();
}

</script> 
<body onload="kep_onload_view();">
	 <form name=misUserSelectDeptPop id=misUserSelectDeptPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="misUserSelectDeptPop"> 
	 <input type="hidden" name="dept_code" id="dept_code" size=20 value="<%=dept_code%>" >
	 <input type="hidden" name="com_code" id="com_code" size=20 value="<%=com_code%>" >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
		<div id="popHeader">
			<h1 class="title"><%=CommonLang.get("HTITLE696") %><!-- 사용자검색 --></h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
			 <div id="searchBtnA02">
				<span class="btn_search"><a href="javascript:setQuery();"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>  
			</div>   
			<!--조회영역-->
			<div id="cont_searchA">
				<table  class="cont_t_list01"  style="width:100%">
						<caption>사용자검색 리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="18%" />
							<col width="9%" />
							<col width="15%" />
						</colgroup>
						<tbody>
						<tr>
							<td><%=CommonLang.get("HTITLE322") %><!-- 사용자명 --></td>
							<td> 
								<input type=text name="user_name_loc" id="user_name_loc" size=20 value="<%=user_name_loc%>" style="ime-mode:active" onkeydown="kepEnter()" class="input_type_text"> 
							</td>
							<td><%=CommonLang.get("HTITLE323") %><!-- 부서명 --></td>
							<td> 
								<input type=text name="user_dept" id="user_dept" size=20 value="<%=user_dept%>" style="ime-mode:inactive" onkeydown="kepEnter()" class="input_type_text"> 
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!--grid-->
			<div class="scrollArea" style="height:338px">
				<table  class="cont_t_list02"  style="width:100%">
					<caption>사용자검색 리스트</caption>
					<colgroup>
						<col width="*" />
						<col width="*" />
						<col width="20%" />
						<col width="*" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col"><%=CommonLang.get("HTITLE322") %><!-- 사용자명 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE329") %><!-- 부서 --></th>   
							<th scope="col"><%=CommonLang.get("HTITLE326") %><!-- 전화번호 --></th>  
							<th scope="col"><%=CommonLang.get("HTITLE41") %><!-- 이메일 --></th>
						</tr>
					</thead>
					<tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
			   		<tr bgcolor="#FFFFFF">
						<td colspan="4" align="center" height = "250">
						<span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
						</td> 
					</tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
						<tr>
							<td class="left"><a href="javascript:setReturn('<%=rowData.get("USER_ID")%>','<%=rowData.get("USER_NAME_LOC")%>','<%=rowData.get("DEPARTMENT")%>','<%=rowData.get("DEPT_NAME")%>','<%=rowData.get("PHONE_NUMBER")%>','<%=CommonUtil.nvl(rowData.get("EMAIL"))%>','<%=CommonUtil.nvl(rowData.get("FAX_NUMBER"))%>','<%=CommonUtil.nvl(rowData.get("LEGACY_USER_ID"))%>','<%=CommonUtil.nvl(rowData.get("MOBILE_PHONE"))%>','<%=CommonUtil.nvl(rowData.get("ZIP_CODE"))%>','<%=CommonUtil.nvl(rowData.get("ADDRESS_LOC"))%>')"><%=rowData.get("USER_NAME_LOC")%></a></td>
							<td class="left"><a href="javascript:setReturn('<%=rowData.get("USER_ID")%>','<%=rowData.get("USER_NAME_LOC")%>','<%=rowData.get("DEPARTMENT")%>','<%=rowData.get("DEPT_NAME")%>','<%=rowData.get("PHONE_NUMBER")%>','<%=CommonUtil.nvl(rowData.get("EMAIL"))%>','<%=CommonUtil.nvl(rowData.get("FAX_NUMBER"))%>','<%=CommonUtil.nvl(rowData.get("LEGACY_USER_ID"))%>','<%=CommonUtil.nvl(rowData.get("MOBILE_PHONE"))%>','<%=CommonUtil.nvl(rowData.get("ZIP_CODE"))%>','<%=CommonUtil.nvl(rowData.get("ADDRESS_LOC"))%>')"><%=rowData.get("DEPT_NAME")%></a></td>
							<td class="left"><a href="javascript:setReturn('<%=rowData.get("USER_ID")%>','<%=rowData.get("USER_NAME_LOC")%>','<%=rowData.get("DEPARTMENT")%>','<%=rowData.get("DEPT_NAME")%>','<%=rowData.get("PHONE_NUMBER")%>','<%=CommonUtil.nvl(rowData.get("EMAIL"))%>','<%=CommonUtil.nvl(rowData.get("FAX_NUMBER"))%>','<%=CommonUtil.nvl(rowData.get("LEGACY_USER_ID"))%>','<%=CommonUtil.nvl(rowData.get("MOBILE_PHONE"))%>','<%=CommonUtil.nvl(rowData.get("ZIP_CODE"))%>','<%=CommonUtil.nvl(rowData.get("ADDRESS_LOC"))%>')"><%=CommonUtil.nvl(rowData.get("PHONE_NUMBER"))%></a></td>
							<td class="left"><a href="javascript:setReturn('<%=rowData.get("USER_ID")%>','<%=rowData.get("USER_NAME_LOC")%>','<%=rowData.get("DEPARTMENT")%>','<%=rowData.get("DEPT_NAME")%>','<%=rowData.get("PHONE_NUMBER")%>','<%=CommonUtil.nvl(rowData.get("EMAIL"))%>','<%=CommonUtil.nvl(rowData.get("FAX_NUMBER"))%>','<%=CommonUtil.nvl(rowData.get("LEGACY_USER_ID"))%>','<%=CommonUtil.nvl(rowData.get("MOBILE_PHONE"))%>','<%=CommonUtil.nvl(rowData.get("ZIP_CODE"))%>','<%=CommonUtil.nvl(rowData.get("ADDRESS_LOC"))%>')"><%=CommonUtil.nvl(rowData.get("EMAIL"))%></a></td>
						</tr>
<% } 
}%>							   
					</tbody>
				</table> 
			 </div>	
	</div>		
</div>
</form> 
</body>
</html>
