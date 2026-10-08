<%--
**********************************************
* 메뉴 : 
* 화면 : 회원사 담당자 정보 팝업
* 기능 : 
* 프로그램 ID : BU0201004 
* 담당자 :  최찬규
* 착수일 : 2025-09-17
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
</head>
<%
String comType = (String)_sessionInfo.getBusinessCond();
// @SuppressWarnings (value="unchecked")
// List<Map<String,String>> _dataList1 = (List<Map<String,String>>) request.getAttribute("data1"); // 조회된결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("data2"); // 조회된결과  
String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  //  (조회조건)
String st_popup_check = CommonUtil.nvl((String) request.getParameter("st_popup_check"),"Y");  //  (조회조건)
// Map<String,String> rowData = null;
// if (_dataList1==null || _dataList1.size()==0){	
// }else{
// 	rowData = _dataList1.get(0);
// }
%>
<script type="text/javascript">
<!--
function kep_onload_view(){
}


function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
//팝업함수호출
function doPop(str) {
	var st_agent_code = "<%=st_com_code%>";
	
	switch (str) {
	case "agentCommunity": // 협력사 커뮤니티
		if(st_agent_code == "") {
			alert("존재하지 않는 협력사입니다.");
			break;
		}

		openSearchPopup('/mdcp/getMasterMdCpAgentCommunityInfoList.do','?com_code='+st_agent_code, '800,680,no');
		break;
	}
}
function thisPopClose(){
	var popupCheck = $("#st_popup_check").val();
	if(popupCheck == "Y"){
		parent.closePop();
	}else{
		self.close();
	}
		
}
document.addEventListener("keydown",function(e){
	if(e.key === " " || e.key === "Enter"){
		e.preventDefault();
		e.stopPropagation();
		thisPopClose();
	}
})
 //-->
</script> 
<body onload="kep_onload_view()">
	 <form name=agent_info_display_pop id=agent_info_display_pop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="agentUserInfoDisplayPop_v2"> 
	 <input type="hidden"  name="st_com_code"  id="st_com_code"  value="<%=st_com_code%>"  /> 
	 <input type="hidden"  name="st_popup_check"  id="st_popup_check"  value="<%=st_popup_check%>" />
	 
	 <div class="wrapPopup">
  <div class="PopupTit">담당자정보<span></span></div>
  <table class="PopupTableTHList">
    <colgroup>
      <col width="150px" />
      <col width="230px" />
      <col width="150px" />
      <col width="230px" />
    </colgroup>  
  	<tr>
      <th>직급</th>
      <th>사용자명</th>
      <th>전화번호</th>
      <th>이메일</th>
    </tr>
<%
if (_dataList2==null || _dataList2.size()==0){
%>
	<tr>
		<td colspan="4">데이터가 없습니다.</td>
	</tr>
<%}else{ %>	 

<% 
for (int j=0; j<_dataList2.size(); j++) {
	Map<String,String> _tmp2 = _dataList2.get(j);

	if(comType.equals("S")){
%>
    <tr>
      <td><%=CommonUtil.nvl(_tmp2.get("POSITION_NAME"))%></td>
      <td><%=CommonUtil.nvl(_tmp2.get("USER_NAME_LOC"))%></td>
      <td><%=CommonUtil.nvl(_tmp2.get("PHONE_NUMBER"))%></td>
      <td><%=CommonUtil.nvl3(_tmp2.get("EMAIL"), "")%></td>
    </tr>
    <%}else{ %>
    <tr>
      <td><%=CommonUtil.nvl(_tmp2.get("POSITION_NAME"))%></td>
      <td><%=CommonUtil.nameMasking(CommonUtil.nvl(_tmp2.get("USER_NAME_LOC")))%></td>
      <td><%=CommonUtil.phoneMasking(CommonUtil.nvl(_tmp2.get("PHONE_NUMBER")))%></td>
      <td><%=CommonUtil.emailMasking(CommonUtil.nvl3(_tmp2.get("EMAIL"), ""))%></td>
    </tr>
    <%} %>
<% } %>
<%} %>                  
  </table>
  <div class="h30"></div> 
  <div class="PopupListBtnBox_Center"><button class="ButPrimary_large" onclick="javascript:thisPopClose(); return false;" >확인</button></div>  
</div><!-- warp 끝--> 
</form> 
</body>
</html>
