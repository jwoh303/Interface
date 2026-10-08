<%--
**********************************************
* 메뉴 : 
* 화면 : 수주접수 초기화요청
* 기능 : 
* 프로그램 ID : SU0503003
* 담당자 : 최찬규
* 착수일 : 2025-10-16
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
<%
	String user_id = _sessionInfo.getUserId();
	String agent = _sessionInfo.getComCode();
	String query = CommonUtil.nvl((String) request.getParameter("value1"),"");
%>

<script language="javascript">
var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

// 변경요청
function ivInfoChangeRequest(){
	var form = document.sellerMpIvIvInfoChangePop;
	var value_reason = "";
	var value_reason_text = $("#st_change_reason_text").val();
	
	for( var i = 0; i < form.rdo_change_reason_cd.length; i++){
		if(form.rdo_change_reason_cd[i].checked == true){
			value_reason = form.rdo_change_reason_cd[i].value;
		}
	}
	
	if(isEmpty(value_reason)) {
// 		alert("변경사유를 선택하세요.");
		var text = "변경사유를 선택하세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	if(value_reason == "기타" && isEmpty(value_reason_text)){
// 		alert("기타 상세사유를 입력하세요.");
		var text = "기타 상세사유를 입력하세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}

	if(value_reason == "기타"){
		$("#st_reason").val(value_reason_text);
	}else{
		$("#st_reason").val(value_reason);
	}
	
	if(!confirm("수주접수 초기화요청 시 KeP 승인 전까지 납품을 할 수 없습니다.\n변경 요청 하시겠습니까?"))
		return;
	
	kepAjaxFormCall("/mpiv/saveSellerMpIvIvInfoChangeReqList.do","sellerMpIvIvInfoChangePop","btnCreate");
}
function closePopup(flag){
	closePopText1();
	parent.setPopupReturn(flag); //flag=1 : 납품이슈현황으로 페이지 이동 , flag=2 : 팝업 닫고 납품진행현황 search
	parent.closePop();
}
function init(){
}

//지연사유 클릭에 따른 이벤트
function delayReasonClick(){
	var reason = $("input[name='rdo_change_reason_cd']:checked").val();
	if(reason == "기타"){
		$("#st_change_reason_text").prop('readonly',false);
	}else{
		$("#st_change_reason_text").val("");
		$("#st_change_reason_text").prop('readonly',true);
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "btnCreate"){
		var text = "수주거부 신청 후 진행 상황은</br><span class='F6495F'>납품관리 > 납품 이슈현황 > 요청사항현황</span>에서 확인 가능합니다.";
		var but1textC = "확인";
		var but2textC = "진행현황";
		var but1funcC = "javascript:closePopup('2'); return false;";
		var but2funcC = "javascript:closePopup('1'); return false;";
		var but1widthC = "100px";
		var but2widthC = "120px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
// 		alert("변경요청이  정상적으로 완료 되었습니다.");
// 		parent.window.close(); // 수주접수 초기화요청 팝업
// 		opener.doAction("search"); // 납품진행현황
	}
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response) {	
	if(pMethod == "btnCreate"){ 
// 		alert("요청 등록에 실패 하였습니다. 관리자에게 문의하여 주십시오"); 
		var text = "요청 등록에 실패 하였습니다. 관리자에게 문의하여 주십시오";
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
</script>
</head>

<body onload="javascript:init();">
<form name="sellerMpIvIvInfoChangePop" id="sellerMpIvIvInfoChangePop" method="post" >
	<!-- HIDDEN -->
	<input type="hidden" name="st_user_id" id="st_user_id" value="<%=user_id%>">
	<input type="hidden" name="st_agent" id="st_agent" value="<%=agent%>">
	<input type="hidden" name="st_query" id="st_query" value="<%=query%>">
	<input type="hidden" name="st_reason" id="st_reason" value="">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup">
  <div class="PopupTit">수주접수 초기화 <span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  <div class="Importance_Popup_row2" style=" height:50px;width:630px">
    <img src="/resources/imgs/Icon_Importance01.png" /> 
    <span>해당 발주번호 내 모든 품목이 변경 요청되며, KeP 확인 전까지 납품이 불가합니다. <br/>KeP 승인 후에는 수주접수부터 진행하시기 바랍니다.</span> 
  </div>
 
  <div class="PopupTitSub">요청사유</div> 
  <div class="Popup_GrayBox" style="width:610px">
    <div class="txt"><label class="RadioLargeLabel"><input type="radio" name="rdo_change_reason_cd" value="거래유형" onchange="javascript:delayReasonClick();"><span class="RadioLargeTxt"></span>거래유형</label> 재 수주접수를 통해 거래유형 변경 목적</div>
    <div class="txt"><label class="RadioLargeLabel"><input type="radio" name="rdo_change_reason_cd" value="납품수량" onchange="javascript:delayReasonClick();"><span class="RadioLargeTxt"></span>납품수량</label> 재 수주접수를 통해 분할계획 변경 목적 </div>
    <div class="txt"><label class="RadioLargeLabel"><input type="radio" name="rdo_change_reason_cd" value="기타" onchange="javascript:delayReasonClick();"><span class="RadioLargeTxt"></span>기타</label> 
    <input class="input30" style="width:460px; " name="st_change_reason_text" id="st_change_reason_text" type="text" placeholder="사유를 입력해주세요." readonly/> </div>
  </div>
  <div class="h30" style="height: 15px;"></div>   
  <div class="PopupListBtnBox_Center" style="width:650px">
    <button class="ButQuaternary_large" onclick="javascript:self.close();">취소</button>
    <button class="ButPrimary_large" onclick="javascript:ivInfoChangeRequest(); return false;">변경요청</button>
  </div> 
</div><!-- warp 끝-->
</form> 
</body>
</html>