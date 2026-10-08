<%--
**********************************************
* 메뉴 : 예산편성 > 비고 팝업
* 화면 : 예산편성 > 비고 팝업
* 기능 : 예산편성 > 비고 팝업
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-03-23
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<script>
<%
String st_term_type = CommonUtil.nvl((String) request.getParameter("st_term_type"),"");
String st_tab_id = CommonUtil.nvl((String) request.getParameter("st_tab_id"),"");
String[] st_remark = new String[12]; //비고
String[] st_flag = new String[12]; //편집여부 flag 0이면 readonly
String[] colName = new String[12]; //컬럼명
String index = "";
for(int i = 0; i<12; i++){
	if(i < 9){
		index = "0"+(i+1);
	}else{
		index = "" + (i+1);
	}
	st_remark[i] = CommonUtil.nvl((String) request.getParameter("st_remark_"+index),"");
	st_remark[i] = st_remark[i].replaceAll("&lt;br&gt;","\n");
	st_flag[i] = CommonUtil.nvl((String) request.getParameter("st_flag_"+index),"");
}
String gHeight = "";
int forLength = 0;
String trHeight = "";
if(st_term_type.equals("Y")){
	gHeight = "360px";
	forLength = 1;
	trHeight = "480px";
	colName[0] = CommonLang.get("HTITLE424"); //년
}else if(st_term_type.equals("H")){
	gHeight = "180px";
	forLength = 2;
	trHeight = "240px";
	colName[0] = CommonLang.get("HTITLE1152"); //상반기
	colName[1] = CommonLang.get("HTITLE1153"); //하반기
}else if(st_term_type.equals("Q")){
	gHeight = "90px";
	forLength = 4;
	trHeight = "120px";
	for(int i = 0; i<forLength; i++){
		colName[i] = (i+1)+CommonLang.get("HTITLE426"); //x분기
	}
}else if(st_term_type.equals("M")){
	gHeight = "32px";
	forLength = 12;
	trHeight = "60px";
	for(int i = 0; i<forLength; i++){
		colName[i] = (i+1)+CommonLang.get("HTITLE427"); //x월
	}
}
%>
</script>
<script type="text/javascript">

function init(){
}

function kepConfirm()
{ 
	var forLength = "<%=forLength%>";
	var returnArr = new Array();
	for(var i = 1; i<=forLength; i++){
		returnArr.push($("#st_remark_"+i).val().replace(/\r?\n/g, '<br>'));
	}
	
	var tab_id = "<%=st_tab_id%>";
	opener.tabs[tab_id]["setPopupReturn"](returnArr);
  	self.close();
}

</script>  
<body onload="" >
	<form id="buyerMdAmBudgetCompilationBigoPop_v2" name="buyerMdAmBudgetCompilationBigoPop_v2">
		<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
		<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE122") %><!-- 비고 --></div>
  <div class="Popup_GrayBox"><%=CommonLang.msg("MSG725")%><!--예산편성시 입력할 비고내용을 입력해주세요 (최대 300자 입력 가능)--></div>
  <table  class="BudgetTableBigo mt10" width="100%">
	<colgroup>
      <col width="70px" />
      <col width="*" />
	</colgroup>
	<%for(int i = 0; i < forLength ; i++) {%>
    <tr style="height: <%=trHeight%>">
      <th><%=colName[i] %></th>
      <td><textarea id="st_remark_<%=i+1 %>" style="width:97%; height:<%=gHeight %>; overflow-y:auto; border:1px solid #dedede;" maxlength="300" <%if(st_flag[i].equals("0")) {%> readonly <%} %>><%=st_remark[i] %></textarea></td>
    </tr>
    <%} %>
	</table>
  <div class="PopupListBtnBox_Center mt15">
    <button class="ButOutline_Medium" style="width:120px" onclick="javascript:self.close(); return false;" ><%=CommonLang.get("HTITLE229") %><!-- 취소 --></button> 
    <button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:kepConfirm(); return false;" ><%=CommonLang.get("HTITLE440") %><!-- 등록 --></button> 
  </div> 
</div><!-- wrapPopup 끝-->  
    </form>
</body>
</html>
