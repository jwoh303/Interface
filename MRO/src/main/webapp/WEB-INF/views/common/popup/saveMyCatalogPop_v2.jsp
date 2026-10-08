<%--
**********************************************
* 메뉴 : 관심상품
* 화면 : 관심상품 폴더 이동 팝업
* 기능 : 관심상품 폴더 이동 팝업
* 프로그램 ID : BU0803003
* 담당자 : 최찬규
* 착수일 : 2026-03-05
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../include/head_v2.jspf"  %>
</head>
<%
	String SessionComCode = "";
	String SessionUserId = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		SessionUserId = CommonUtil.nvl((String)sessionInfo.getUserId());
	}
	
	//관심상품 분류 리스트
	List<Map<String,String>> myItemList =  CommonUtil.getCode3List(SessionComCode, "SEL", "ITEM",SessionUserId, "ICOMCOD3", "", "");
		
%>
<script>
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
}

function kep_confirm(){
	if(isEmpty(kepTrimStr($("#selFolderCode").val()))){
		//이동할 폴더를 선택해주세요.
		var text = "<%=CommonLang.msg("MSG681")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	parent.setPopupReturn($("#selFolderCode").val());
	parent.closePop();
}
function folderClick(index){
	$("div[name=myFolderClick]").attr("class","FPDFolder"); //전부 class on처리 제거
	$("#myFolderClick"+index).attr("class","FPDFolder_on"); //클릭한 div만 class on처리
	$("#selFolderCode").val($("#myFolder"+index).val());
	
}

</script>
</head>
<body onload="kep_onload_view()">
		<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE1118") %><!-- 폴더이동 --><span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="PopupTitSubTxt"><%=CommonLang.msg("MSG679")%><!--선택한 상품을 이동할 폴더를 선택해주세요.--></div>
  <div class="FolderBoxSelect">
  	<%if(myItemList.size()<=0 || myItemList == null) {%>
  	<%}else{ %>
  		<%for(int i = 0; i<myItemList.size(); i++) {%>
  			<input type="hidden" name="myFolder" id="myFolder<%=i %>" value="<%=myItemList.get(i).get("CODE2")%>">
	  		<div class="FPDFolder" name ="myFolderClick" id="myFolderClick<%=i%>" onclick="javascript:folderClick('<%=i%>');"><p class="HeartWon"></p><p class="HeartFont"><%=myItemList.get(i).get("TEXT1")%></p></div>
  		<%} %>
  	<%} %>
  </div>
  <input type="hidden" name="selFolderCode" id="selFolderCode" value="">
  <div class="PopupListBtnBox_Center mt30">
    <!--button class="ButQuaternary_large" >취소</button-->
    <button class="ButPrimary_large" onclick="javascript:kep_confirm();return false;"><%=CommonLang.get("HTITLE592") %><!-- 이동 --></button>
  </div>  
</div><!-- wrapPopup 끝--> 
</body>
</html>
