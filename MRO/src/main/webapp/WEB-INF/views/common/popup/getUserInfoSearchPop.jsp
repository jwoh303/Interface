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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   ;

String st_buyer=  CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode()); 
String st_gbn = CommonUtil.nvl((String) request.getParameter("st_gbn"),"");  //  (조회조건) 
String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"");  //  (조회조건)
String st_legacy_user_id = CommonUtil.nvl((String) request.getParameter("st_legacy_user_id"),"");  //  (조회조건 사번)
String st_user_name = CommonUtil.nvl((String) request.getParameter("st_user_name"),"");  //  (조회조건)
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)
Map<String, String> p060000029_map = CommonUtil.getSpecialCheckReturnMap(st_buyer,"P06-0000029");
String p060000029 = "";
if (p060000029_map != null){
	p060000029= CommonUtil.nvl(p060000029_map.get("COL01_DATA"),""); // 관리번호 팝업 연결(TYPE)	
}
%>
<script type="text/javascript">
<!--

var p060000029 = "<%=p060000029%>";
var open = "<%=open%>";
function kep_onload_view() {
	if(open == 'Y') {
		setQuery();
	}
}

function setQuery()
{	
	var legacy_user_id_params = document.getElementById("st_legacy_user_id").value;
	var user_name_params = document.getElementById("st_user_name").value;
	if(isEmpty(legacy_user_id_params) && isEmpty(user_name_params)){ // 사번 or 이름 한개의 파라미터는 필요
		alert('최소 1개 이상의 검색 파라미터를 입력 해주세요.');
		return;
	}
  $('#getUserPopSearch').attr("action", "/common/getUserList.do").submit();   
}

function kepEnter() {	
	if (event.keyCode == 13) {		
		setQuery();
	}		
}

function setReturn(value1,value2,value3)
{
  var st_type = "<%=st_type%>";
  opener.setPopupReturn(st_type,value1,value2,value3);
  this.close();
}

 //-->
</script> 
<body onload="kep_onload_view()">
	<form name=getUserPopSearch  id=getUserPopSearch method=post >
	<input type="hidden" name="st_buyer" id="st_buyer"  value="<%=st_buyer%>">
	<input type="hidden" name="st_type" id="st_type"  value="<%=st_type%>">
	<input type="hidden" name="st_gbn" id="st_gbn"  value="<%=st_gbn%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
		<div id="popHeader">
			<h1 class="title"><%=st_gbn%></h1>
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
						<caption> 리스트</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
							<col width="35%" />
						</colgroup>
						<tbody>
						<tr>
							<td>사번</td>
							<td>
								<input type=text name="st_legacy_user_id" id="st_legacy_user_id" value="<%=st_legacy_user_id%>" onkeydown="kepEnter()" class="input_type_text">
							</td>
							<td>성명</td>
							<td>
								<input type=text name="st_user_name" id="st_user_name" value="<%=st_user_name%>" onkeydown="kepEnter()" class="input_type_text">
							</td>
						 </tr>
					</tbody>
				</table>
			</div>
			<div class="scrollArea" style="height:300px">
				<!--grid-->
				<table  class="cont_t_list02"  style="width:100%">
					<caption>검색 리스트</caption>
					<colgroup>
			
							<col width="20%" />
							<col width="15%" />
							<col width="20%" />
							<col width="20%" />
							<col width="25%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">부서</th>
							<th scope="col">성명</th>
							<th scope="col">휴대폰</th>
							<th scope="col">전화번호</th>
							<th scope="col">이메일</th>
						</tr>
					</thead>
					<tbody>

					<%
					if (_dataList == null || _dataList.size() == 0){
					%>
						<tr bgcolor="#FFFFFF">
							<td colspan="5" align="center" height = "270">
							<span class="font1">조회된 데이타가 없습니다.</span>
							</td>
						</tr>
					<%}else{
						for (int j=0; j<_dataList.size(); j++) {
							Map<String,String> rowData = _dataList.get(j);
					%> 
							<tr>
								<td ><a href="javascript:setReturn('<%=rowData.get("LEGACY_USER_ID")%>','<%=rowData.get("USER_NAME")%>','')"><%=CommonUtil.nvl(rowData.get("DEPT_TEXT"))%></a></td>
								<td ><a href="javascript:setReturn('<%=rowData.get("LEGACY_USER_ID")%>','<%=rowData.get("USER_NAME")%>','')"><%=CommonUtil.nvl(rowData.get("USER_NAME"))%></a></td>
								<td ><a href="javascript:setReturn('<%=rowData.get("LEGACY_USER_ID")%>','<%=rowData.get("USER_NAME")%>','')"><%=CommonUtil.nvl(rowData.get("MOBILE_PHONE"))%></a></td>
								<td ><a href="javascript:setReturn('<%=rowData.get("LEGACY_USER_ID")%>','<%=rowData.get("USER_NAME")%>','')"><%=CommonUtil.nvl(rowData.get("PHONE_NUMBER"))%></a></td>
								<td ><a href="javascript:setReturn('<%=rowData.get("LEGACY_USER_ID")%>','<%=rowData.get("USER_NAME")%>','')"><%=CommonUtil.nvl(rowData.get("EMAIL"))%></a></td>
								
						<%} %>
					<%}%>
							</tr>
					</tbody>
				</table>
		</div>
	</div>
</div>
</form> 
</body>
</html>
