<%--
**********************************************
* 메뉴 : 관심상품
* 화면 : 관심상품 폴더 추가 팝업
* 기능 : 관심상품 폴더 추가 팝업
* 프로그램 ID : BU0803002
* 담당자 : 최찬규
* 착수일 : 2026-03-03
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
	if(isEmpty(kepTrimStr($("#TEXT1").val()))){
		//새 폴더명을 입력해주세요.
		var text = "<%=CommonLang.msg("MSG673")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	parent.setPopupReturn($("#TEXT1").val());
	parent.closePop();
}

</script>
</head>
<body onload="kep_onload_view()">
		<div class="wrapPopupAlert">
		<form name = "searchCondition" method = "post">
				<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
				<input type="hidden" id="st_type" name="st_type"  value="ITEM">
				
		    <div class="PopupTit"><%=CommonLang.get("HTITLE1116")%><!--새폴더--><span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
		    <div class="AlertTxtM mt15 mb30" style="text-align: left;">
		      <%=CommonLang.msg("MSG672")%><!--새 폴더를 추가하여 관심상품을 관리하세요.--><br/>
		       <input class="input40 mt20" style="width:350px" placeholder="<%=CommonLang.msg("MSG673")%>" name="TEXT1" id="TEXT1" type="text" /> <!-- 새 폴더명을 입력해주세요. -->
		    </div>
		    <div class="PopupListBtnBox_Center">
		      <button class="ButPrimary_large" onclick="kep_confirm(); return false;"><%=CommonLang.get("HTITLE1120")%><!--추가--></button>
		    </div>
		  </form>
		  </div>
</body>
</html>
