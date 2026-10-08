<%--
**********************************************
* 메뉴 : 
* 화면 : 결재자의견
* 기능 : 결재자의견
* 프로그램 ID : BU0701008
* 담당자 : 최찬규
* 착수일 : 2026-02-02
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<%

String st_pass_kn = CommonUtil.nvl((String) request.getParameter("st_pass_kn"),""); // 결재(1), 반려(3)
String tab_id = CommonUtil.nvl((String) request.getParameter("tab_id"),""); // tab_id
String total_cnt = CommonUtil.nvl((String) request.getParameter("total_cnt"),"1"); // 결재 건수

%>
<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var st_pass_kn = "<%=st_pass_kn%>";

function setSave(){
	var value = TrimCommon(document.forms.buyerMpPoRejectReasonPop.textarea2.value);
	
	//일괄결재는 결재자의견 선택, 일괄반려는 결재자의견 필수
	if(st_pass_kn == "1"){
		var text = "<%=CommonLang.msg("MSG626")%>";//선택하신 대상을 결재 진행하시겠습니까?
		var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
		var but1funcC = "javascript:setReason(); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "60px";
		var but2widthC = "60px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		
	} else {
		if(isEmpty(value)) {
			var text = "<%=CommonLang.msg("MSG627")%>";//결재자의견 입력하세요.
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}else{
			var text = "<%=CommonLang.msg("MSG628")%>";//선택하신 대상을 반려 진행하시겠습니까?
			var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
			var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
			var but1funcC = "javascript:setReason(); return false;";
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "60px";
			var but2widthC = "60px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		}
	}
}
function setReason(){
	closePopText1();
	var value = TrimCommon(document.forms.buyerMpPoRejectReasonPop.textarea2.value);
	var tab_id = "<%=tab_id%>";
	parent.tabs[tab_id]["setReason"](value);
	parent.closePop();
}


function chk_byte(max_byte){

  if (kepGetByteLength("textarea2") > max_byte) {
          var text = "<%=CommonLang.msg("MSG629")%>";//결재자의견 한글 50자(영문 100자) 이상 입력할 수 없습니다.
		  openLayerPopText2(text,but1text,but1func,but1width);
          $("#textarea2").val("");
          $("#textarea2").focus();
          return;
  }
 
	     
}

</script> 
<body onload="">
<form name="buyerMpPoRejectReasonPop" id="buyerMpPoRejectReasonPop" method=post > 
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopupAlert">
    <div class="PopupTit"><%=CommonLang.get("HTITLE1050")%><!--결재자의견--><span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
    <div class="AlertTxtM mt15 mb30" style="text-align: left;">
      <%=CommonLang.get("HTITLE921") %><!-- 총 --> <span style="color:#2172EC" ><%=total_cnt %></span><%=CommonLang.msg("MSG630") %><!-- 건이 선택되었습니다. --> <%=CommonLang.msg("MSG627")%><!--결재자의견 입력하세요.--><br/>
      <div class="TextField mt10" id="limitedArea">
       <textarea id="textarea2" name="textarea2" style=" width:92%; height:50px;" placeholder="<%=CommonLang.msg("MSG627")%>" onkeyup="chk_byte( 100);"></textarea><!--결재자의견 입력하세요.-->
      </div>
    </div>
    <div class="PopupListBtnBox_Center">
      <button class="ButQuaternary_large closePopup" onclick="javascript:parent.closePop(); return false;"><%=CommonLang.get("HTITLE229")%><!-- 취소 --></button>
      <button class="ButPrimary_large" onclick="javascript:setSave(); return false;"><%=CommonLang.get("HTITLE516")%><!-- 확인 --></button>
    </div>
  </div>
</form> 
</body>
</html>
