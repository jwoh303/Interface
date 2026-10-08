<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<%
String popupCheck = CommonUtil.nvl((String) request.getParameter("popupCheck"),"");  //layer의 layer인지 , 그냥 layer인지
%> 

<script type="text/javascript">

function init(){

}

function kepConfirm()
{ 
	var frm = document.forms["sellerMpRqAbandonmentReasonPop"];
	var reason = "";
	var reason_cd = $("input[name=st_giveup_reason]:checked").val();
	if(reason_cd == undefined){ //선택 안되었으면
		alert("포기사유를 선택해주시기 바랍니다.");
		return;
	}
	
	if(frm.st_giveup_reason[4].checked) {
		var aa = frm.st_giveup_reason_etc.value;
		if(aa.length < 5 ){ 
			alert("기타사유를 5자리 이상으로 입력 바랍니다.");
			frm.st_giveup_reason_etc.focus();
			return;
		}
	}
	var length = frm.st_giveup_reason.length;
	for(var i=0; i<length; i++){
		if(frm.st_giveup_reason[i].checked){
			if(frm.st_giveup_reason[4].checked){
				reason = frm.st_giveup_reason_etc.value; 
			}else{
				reason = frm.st_giveup_reason[i].value;
			}
			break;		
		} 
	}
  parent.AgentGiveUp(reason);
  
  var popupCheck = '<%=popupCheck%>';
  if(popupCheck == "Y"){
	  parent.closePop2();
  }else{
	  parent.closePop();
  }
}

function giveupReasonClick(){
	
	var reason = $("input[name='st_giveup_reason']:checked").val();
	if(reason == "기타"){
		$("#st_giveup_reason_etc").prop('readonly',false);
	}else{
		$("#st_giveup_reason_etc").val("");
		$("#st_giveup_reason_etc").prop('readonly',true);
	}
}

</script>  
<body >
<form name="sellerMpRqAbandonmentReasonPop" id="sellerMpRqAbandonmentReasonPop" method="post">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup">
  <div class="PopupTit">견적포기사유<span>
  <%if(popupCheck.equals("Y")) {%>
  <a href="javascript:parent.closePop2();">
  <%}else{%>
  <a href="javascript:parent.closePop();">
  <%} %>
  <img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  <div class="Importance_Popup" style="width:500px"><img src="/resources/imgs/Icon_Importance01.png" /> 견적포기에 대한 사유를 선택해주세요.</div>
  <div style="height: 20px;"></div>
  <div class="Popup_BlueBox" style="width:500px">
    <label class="RadioLargeLabel"><input type="radio" name="st_giveup_reason" onchange="javascript:giveupReasonClick();" value="제작불가"><span class="RadioLargeTxt"></span>제작불가</label> 
    <label class="RadioLargeLabel"><input type="radio" name="st_giveup_reason" onchange="javascript:giveupReasonClick();" value="수급불가"><span class="RadioLargeTxt"></span>수급불가</label>
    <label class="RadioLargeLabel"><input type="radio" name="st_giveup_reason" onchange="javascript:giveupReasonClick();" value="미취급"><span class="RadioLargeTxt"></span>미취급</label>
    <label class="RadioLargeLabel"><input type="radio" name="st_giveup_reason" onchange="javascript:giveupReasonClick();" value="단종"><span class="RadioLargeTxt"></span>단종</label>
    <label class="RadioLargeLabel"><input type="radio" name="st_giveup_reason" onchange="javascript:giveupReasonClick();" value="기타" onclick="setReason();"><span class="RadioLargeTxt"></span>기타</label><br/>
    <input class="input30" style="width:90%; margin-left:10px; margin-top:5px" name="st_giveup_reason_etc" id="st_giveup_reason_etc" type="text" placeholder="기타 사유를 입력해주세요" maxlength="100"/>
  </div>
  <div class="PopupTitSub"></div>  
  <div class="PopupListBtnBox_Center"  style="width:500px;">
  <%if(popupCheck.equals("Y")) {%>
    <button class="ButQuaternary_large" onclick="javascript:parent.closePop2();" >취소</button>
  <%}else{ %>
  	<button class="ButQuaternary_large" onclick="javascript:parent.closePop();" >취소</button>
  <%} %>
    <button class="ButPrimary_large" onclick="javascript:kepConfirm(); return false;">견적포기</button>
  </div>  
</div><!-- warp 끝-->
</form>    
</body>
</html>
