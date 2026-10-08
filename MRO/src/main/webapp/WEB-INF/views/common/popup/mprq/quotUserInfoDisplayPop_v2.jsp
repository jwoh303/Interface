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
<%@ include file="../../include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
</head>
<%
String comType = (String)_sessionInfo.getBusinessCond();
@SuppressWarnings (value="unchecked")
Map<String,String> _data = (Map<String,String>) request.getAttribute("data"); // 조회된결과 
String st_user_id = CommonUtil.nvl((String) request.getParameter("st_user_id"),"");  //  (조회조건)
%>
<script type="text/javascript">
<!--
function kep_onload_view(){
}

 //-->
</script> 
<body onload="kep_onload_view()">
	 <form name=agent_info_display_pop id=agent_info_display_pop method=post >
	 <input type="hidden"  name="st_user_id"  id="st_user_id"  value="<%=st_user_id%>111"  /> 
	 
	 <div class="wrapPopup">
  <div class="PopupTit">담당자정보<span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <table class="PopupTableTHList">
    <colgroup>
      <col width="230px" />
      <col width="150px" />
      <col width="230px" />
    </colgroup>  
  	<tr>
      <th>사용자명</th>
      <th>전화번호</th>
      <th>이메일</th>
    </tr>
<%
if (_data==null || _data.size()==0){
%>
	<tr>
		<td colspan="3">데이터가 없습니다.</td>
	</tr>
<%}else{ %>	 
    <tr>
      <td><%=CommonUtil.nvl(_data.get("USER_NAME_LOC"))%></td>
      <td><%=CommonUtil.nvl(_data.get("PHONE_NUMBER"))%></td>
      <td><%=CommonUtil.nvl3(_data.get("EMAIL"), "")%></td>
    </tr>
<%} %>                  
  </table>
  <div class="h30"></div> 
  <div class="PopupListBtnBox_Center"><button class="ButPrimary_large" onclick="javascript:parent.closePop(); return false;" >확인</button></div>  
</div><!-- warp 끝--> 
</form> 
</body>
</html>
