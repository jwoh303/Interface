<%--
**********************************************
* 메뉴 : 
* 화면 : VOC 요청
* 기능 : 
* 프로그램 ID : BU0901002 
* 담당자 : 최찬규
* 착수일 : 2026-01-30
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
<link rel="stylesheet" href="/resources/css/month_popup.css" type="text/css" />
</head>
<% 

String st_ds_user_id = CommonUtil.nvl((String) request.getParameter("st_ds_user_id"),""); // 처리자
String st_cd_user_id = st_ds_user_id; // 접수자 
String st_ds_dept = CommonUtil.nvl((String) request.getParameter("st_ds_dept"),"");
String st_code = CommonUtil.nvl((String) request.getParameter("st_code"),"");
String st_title = CommonUtil.nvl((String) request.getParameter("st_title"),"");
String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");
String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");
String st_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");

String st_req_user_tel  = _sessionInfo.getTel(); 
String st_user_name  =  _sessionInfo.getUserNameLoc() ; 

String editFlag = "Y";
String st_text = "";
if ("ZA".equals(st_code)) {
	editFlag = "N";
	//품목정보
	st_text = CommonLang.get("HTITLE1104");
} else if ("ZB".equals(st_code)) {
	editFlag = "N";
	//품목이미지
	st_text = CommonLang.get("HTITLE1105");
} else {
	//Claim 요청
	st_title = CommonLang.get("HTITLE1106");
}
%>

<script type="text/javascript">
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

<!--
function kep_onload_view() {
	//조회조건 초기화
	$("#st_ph_date").val( kepGetNowTimeStr('YYYYMMDD','/'));   		
}

//기능함수
function doAction(str) { 
	
	switch (str) { 
			
		case "save": // 저장	
			if (checkSubmit()) {
				//작성하신 요청내용으로 등록하시겠습니까?
				var text = "<%=CommonLang.msg("MSG656")%>";
				var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
				var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
				var but1funcC = "javascript:saveBuyerVocReqCreateReg(); return false;";
				var but2funcC = "javascript:closePopText1(); return false;";
				var but1widthC = "60px";
				var but2widthC = "60px";
				
				openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			}
			break;
	}
}
function saveBuyerVocReqCreateReg(){
	closePopText1();
	kepAjaxFormCall("/main/saveBuyerVocReqCreateReg.do", "commonCoCoVocBuyerReqCreateRegPop", "save");
}


function checkSubmit() {
	
	if (isEmpty(kepTrimStr($("#st_claim_master").val()))) {
		//VOC 유형분류 선택해주세요.
		var text = "<%=CommonLang.msg("MSG657")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("st_claim_master").focus();
		return false;
	}

	if (isEmpty(kepTrimStr($("#st_ph_date").val()))) {
		//처리희망일을 선택해주세요.
		var text = "<%=CommonLang.msg("MSG658")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_ph_date").focus();
		return false;
	}
	
	if (isEmpty(kepTrimStr($("#st_buyer_item_no").val()))) {
		//품목코드를 입력해주세요.
		var text = "<%=CommonLang.msg("MSG659")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_buyer_item_no").focus();
		return false;
	}

	var regex = /^PO\d{8}$/; //PO(대문자) + 숫자 8자리
	if(!isEmpty($("#st_po_no").val())){ //발주번호 입력값이 있는 경우에만 형식 체크
		if(!regex.test($("#st_po_no").val())){
			//발주번호를 다시 확인해주세요. 예)PO(대문자) + 숫자 8자리
			var text = "<%=CommonLang.msg("MSG580")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			$("#st_po_no").focus();
			return false;
		}
	}
	
	if (isEmpty(kepTrimStr($("#st_req_remark").val()))) {
		//요청내역을 입력해주세요.
		var text = "<%=CommonLang.msg("MSG660")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_req_remark").focus();
		return false;
	} 
	
	return true;
}



/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	
	  var sMsg = response.msg.MSG;   
	  var user_name = document.forms.commonCoCoVocBuyerReqCreateRegPop.st_user_name.value; 
	  var process_info = sMsg.split("@@", -1);
	  
	  var st_code = "<%=st_code%>";
	  
	    if(process_info[0]=="SUCCESS") {
			if(st_code == "ZA"){
	  		  //신고가 접수되었습니다.
	  		  var text = "<%=CommonLang.msg("MSG667")%>";
	  	  	}else if(st_code == "ZB"){
	  		  //이미지 요청이 완료되었습니다.
	  		  var text = "<%=CommonLang.msg("MSG668")%>";
	  	  	}else{
	  	  		//user_name님이 요청하신 사항은 KeP 고객도우미에게 process_info[1] 번으로 접수되었습니다.
	  	  		var text = user_name+ "<%=CommonLang.msg("MSG661")%> "+process_info[1]+" <%=CommonLang.msg("MSG662")%>";
	  	  	}
			openLayerPopText2(text,but1text,but1funcSearch,but1width);
	    } 
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	 //오류발생하였습니다.다시 한 번 시도해 주시기 바랍니다.
	 var text = "<%=CommonLang.msg("MSG163")%>";
	 openLayerPopText2(text,but1text,but1funcSearch,but1width);
	
} 
function thisPopClose(){
	closePopText2();
	self.close();
}
 //-->
</script> 
<body onload="kep_onload_view()">
<form name="commonCoCoVocBuyerReqCreateRegPop" id="commonCoCoVocBuyerReqCreateRegPop" method=post > 
	<input type="hidden" name="st_ds_user_id" id="st_ds_user_id" value="">
	<input type="hidden" name="st_ds_dept" id="st_ds_dept" value="">
	<input type="hidden" name="st_cd_user_id" id="st_cd_user_id" value="<%=st_cd_user_id%>">
	<input type="hidden" name="st_cd_dept" id="st_cd_dept" value="">
	<input type="hidden" name="st_cd_date" id="st_cd_date" value="">
	<input type="hidden" name="st_user_name"     value="<%=st_user_name%>">
	<input type="hidden" name="st_req_user_tel"  value="<%=st_req_user_tel%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup">
    	<div class="PopupTit"><%=st_title%><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
		  <table class="PopupTableTxt mt20" style="width:500px">
		  	<tr>
		      <th width="25%"><%=CommonLang.get("HTITLE501") %><!-- VOC 유형 --></th>
		      <% if ("N".equals(editFlag)) {%>
		      <td width="75%">
		      	<select class="Select" name="st_claim_master"  id="st_claim_master" >
		      		<option value="<%=st_code%>"><%=st_text%></option>
		      	</select>
		      </td>
		      <%}else{ %>
		      <td width="75%">
		      	<select class="Select" name="st_claim_master"  id="st_claim_master" style="height:30px;">
		      		  <option value="" selected> <%=CommonLang.get("HTITLE29") %><!-- 전체 --> </option> 
		              <option value="ZP"><%=CommonLang.get("HTITLE502") %><!-- 가격 --></option> 
		              <option value="ZC"><%=CommonLang.get("HTITLE503") %><!-- 교환/반품 --></option> 
		              <option value="ZE"><%=CommonLang.get("HTITLE504") %><!-- 기타 --></option> 
		              <option value="ZL"><%=CommonLang.get("HTITLE404") %><!-- 마감 --></option> 
		              <option value="ZO"><%=CommonLang.get("HTITLE162") %><!-- 발주 --></option> 
		              <option value="ZD"><%=CommonLang.get("HTITLE505") %><!-- 배송 --></option> 
		              <option value="ZS"><%=CommonLang.get("HTITLE506") %><!-- 시스템 --></option> 
		              <option value="ZN"><%=CommonLang.get("HTITLE507") %><!-- 신규등록 --></option>
		        </select> 
		      </td>
		      <%} %>
		    </tr>
		    <tr>
		      <th width="25%"><%=CommonLang.get("HTITLE508") %><!-- 처리희망일 --></th>
		      <td>
		      <div class="Buyer-datepicker-wrap" style=" width:110px; margin-right:8px; height: 28px;">
              <div class="Buyer-date-input"  data-datepicker><input type="text" placeholder="" id="st_ph_date" name="st_ph_date" readonly /><span></span></div>
            </div>
              </td>
		    </tr>
		    <tr>
		      <th width="25%"><%=CommonLang.get("HTITLE203") %><!-- 발주번호 --></th>
		      <% if ("N".equals(editFlag)) {%>
		      <td width="75%"><%=st_po_no%></td>
		      <input type="hidden" id="st_po_no" name="st_po_no" style="width:70%;" class="input_type_text"  value="<%=st_po_no%>" />
		      <%}else{ %>
		      <td width="75%">
		      <input type="text" id="st_po_no" name="st_po_no" style="width:70%; height: 28px;" class="input30"  value="" />
		      </td>
		      
		      <%} %>
		    </tr>
		    <tr>
		      <th width="25%"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></th>
		      <% if ("N".equals(editFlag)) {%>
		      <td width="75%"><%=st_buyer_item_no %></td>
		      <input type="hidden" id="st_buyer_item_no" name="st_buyer_item_no" style="width:70%;" class="input_type_text"  value="<%=st_buyer_item_no%>" />
		      <%}else{ %>
		      <td width="75%">
		      <input type="text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:70%; height: 28px;" class="input30"  value="" />
		      </td>
		      <%} %>
		    </tr>
		    <tr>
		      <th><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></th>
		      <% if ("N".equals(editFlag)) {%>
		      <td><%=st_description %></td>
		      <%}else{ %>
		      <td></td>
		      <%} %>
		    </tr>
		    <tr>
		      <th><%=CommonLang.get("HTITLE509") %><!-- 요청내역 --></th>
		      <td>
		        <div class="TextField" id="limitedArea">
		          <textarea id="st_req_remark" name="st_req_remark" maxlength="100" placeholder="" style=" width:90%"></textarea>
		          <div class="meta" aria-live="polite"> <span id="count">0</span>/100 </div>
		        </div>
		        <script>
		          (function () {
		            const wrap = document.getElementById('limitedArea');
		            const ta   = document.getElementById('st_req_remark');
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
		      </td>
		  </table>
		  <div class="PopupListBtnBox_Center mt30">
		    <button class="ButQuaternary_large" onclick="javascript:self.close(); return false;"><%=CommonLang.get("HTITLE229") %><!-- 취소 --></button>
		    <button class="ButPrimary_large" onclick="javascript:doAction('save'); return false;" ><%=CommonLang.get("HTITLE500") %><!-- 요청 --></button>
		  </div>      
</div>
</form> 
</body>
</html>
