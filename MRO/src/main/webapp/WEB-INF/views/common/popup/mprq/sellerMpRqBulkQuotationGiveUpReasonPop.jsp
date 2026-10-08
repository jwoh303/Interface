<%--
**********************************************
* 메뉴 : 벌크 견적요청 접수 > 벌크 견적 포기 사유 입력 팝업
* 화면 : 벌크 견적 포기 사유 입력 팝업
* 기능 : 
*****************
--%>
<%@page import="java.math.BigDecimal"%>
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
String burq_no = CommonUtil.nvl((String) request.getParameter("st_burq_no"),"");
String burq_rfq_no_list = CommonUtil.nvl((String) request.getParameter("st_burq_rfq_no_list"),"");
%>
<script type="text/javascript">

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

function kep_onload_view(){
	if(!isEmpty("<%=burq_no%>")){
		$("#st_burq_no").val("<%=burq_no%>");
		$("#st_burq_rfq_no_list").val("<%=burq_rfq_no_list%>");
	}
	var arr = "<%=burq_rfq_no_list%>";
	var arrRow = arr.split("@@").filter(Boolean);
	document.getElementById("cnt").innerHTML = arrRow.length;
}

//기능함수
function doAction(str) {
	
	switch (str) {
		case "save":
			if (kepIsEmpty("st_remark")==true){
// 				alert("포기 사유를 입력하시기 바랍니다.");
				var text = "포기 사유를 입력하시기 바랍니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				$("#st_remark").focus();
				return;
			} 	
// 			if(!confirm("해당 품목에 대한 견적을 포기 하시겠습니까?")){ return;}
			var text = "해당 품목에 대한 견적을 포기 하시겠습니까?";
			var but1textC = "확인";
			var but2textC = "취소";
			var but1funcC = "javascript:giveupsellerMpRqBulkQuotation(); return false;";
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "80px";
			var but2widthC = "80px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);

			
// 			kepAjaxFormCall("/mprq/giveupsellerMpRqBulkQuotation.do","sellerMpRqBulkQuotationGiveUpReasonPop","save");
			break;
	}
}

function giveupsellerMpRqBulkQuotation(){
	closePopText1();
	kepAjaxFormCall("/mprq/giveupsellerMpRqBulkQuotation.do","sellerMpRqBulkQuotationGiveUpReasonPop","save");
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){  
	if (pMethod == "save"){
// 		alert("견적이 포기되었습니다.");
		var text = "견적이 포기되었습니다.";
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
// 		setReturn('1');
	}
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) { 
	var msg = response.Message;

	if (!isEmpty(msg)){	
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	return;
}
function setReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9)
{ 
  closePopText2();
  parent.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9);
  parent.closePop();
  
}

function thisPopClose(){
	setReturn('1');
// 	closePopText2();
// 	parent.doAction('search');
}
</script> 
<body onLoad="kep_onload_view()">
<form name="sellerMpRqBulkQuotationGiveUpReasonPop" id="sellerMpRqBulkQuotationGiveUpReasonPop" method=post >
	<input type="hidden" id= "st_burq_no" name="st_burq_no" value="<%=burq_no%>">
	<input type="hidden" id="st_burq_rfq_no_list" name="st_burq_rfq_no_list" value="<%=burq_rfq_no_list%>">
	<div class="wrapPopup">
		  <div class="PopupTit">견적 포기 사유 <span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
		  <div class="h15"></div>
		  <div class="Importance_Popup" style="width:480px; height:30px;line-height:30px; vertical-align: middle;" >선택된 품목 ( <font color="red"><span id="cnt">00</span></font> )건을 견적 포기합니다.</div>
		  <div class="h15"></div>
		  <div class="TextField" id="limitedArea" style="width:500px">
		    <textarea placeholder=""  maxlength="1300" cols="90" rows="6" style=" width:470px" id="st_remark" name="st_remark"></textarea>
		    <div class="meta" aria-live="polite"> <span id="count">0</span>/1300 </div>
		  </div>
			<script>
		      (function () {
		        const wrap = document.getElementById('limitedArea');
		        const ta   = document.getElementById('st_remark');
		        const cnt  = document.getElementById('count');
		        const MAX  = parseInt(ta.getAttribute('maxlength'), 10);
		        function update() {
		          const len = ta.value.length;
		          cnt.textContent = len;
		        }
		        // 초기 상태 반영 및 입력 시 업데이트
		        update();
		        ta.addEventListener('input', update);
		      })();
		    </script>            
		  <div class="h30"></div>
		  <div class="PopupListBtnBox_Center" style="width:500px;">
		    <button class="ButQuaternary_large" onclick="javascript:parent.closePop();" >취소</button>
		    <button class="ButPrimary_large" onclick="javascript:doAction('save'); return false;">등록</button>
		  </div> 
</div><!-- warp 끝-->
</form> 
</body>
</html>
