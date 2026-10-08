<%--
**********************************************
* 메뉴 : 
* 화면 : 거래유형 변경요청
* 기능 : 
* 프로그램 ID : SU0502002
* 담당자 : 최찬규
* 착수일 : 2025-09-29
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
<%
	String user_id = _sessionInfo.getUserId();
	String agent = _sessionInfo.getComCode();
	String buyer = CommonUtil.nvl((String) request.getParameter("value1"));
	String po_no = CommonUtil.nvl((String) request.getParameter("value2"));
	String process_type = CommonUtil.nvl((String) request.getParameter("value3"));
%>

<script language="javascript">
// 변경요청
function processTypeChangeRequest(){
	var ch_process_type = $("input[name=ch_process_type]:checked").val();
	var value_reason_text = $("#st_reason_text").val();
	
	if(ch_process_type == undefined){
		alert("변경요청할 거래유형을 선택하세요.");
		return;
	}else if(ch_process_type == "Y"){ // 택배 선택 시
		$("#st_parcel_yn").val("Y");
	}else{
		$("#st_parcel_yn").val("N");
	}
	
	if(isEmpty(value_reason_text)) {
		alert("상세사유를 입력하세요.");
		return;
	}
	
	if(!confirm("거래유형 변경요청 시 KeP 승인 전까지 납품을 할 수 없습니다.\n변경 요청 하시겠습니까?"))
		return;
	
	kepAjaxFormCall("/mpiv/saveSellerMpIvProcessTypeChangeReqPop.do","sellerMpIvProcessTypeChangePop","save");
}

// OPENER창의 지연사유 값 얻기
function init(){
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	var text = "거래유형 변경요청이 완료되었습니다.</br>진행현황은 <span class='F6495F'>납품관리 > 납품 이슈현황 </span>에서 확인 가능합니다.";
	var but1text = "확인";
	var but1func = "javascript:closePopup(); return false;";
	var but1width = "120px";
	openLayerPopText2(text,but1text,but1func,but1width);
	
// 	alert("거래유형 변경요청이 완료되었습니다.\n진행현황은 [납품관리 > 납품이슈현황]에서 확인 가능합니다.");
// 	parent.closePop2(); // 거래유형 변경요청 팝업
// 	parent.closePop(); // 수주접수 상세 팝업
// 	parent.doAction('search'); // 수주접수
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function kepAjaxError(pMethod , response) {	
	if(pMethod == "save"){ 
		alert("요청 등록에 실패 하였습니다. 관리자에게 문의하여 주십시오"); 
	}
}

function closePopup(){
	parent.setPopupReturn();
	parent.closePop2(); // 거래유형 변경요청 팝업
}
</script>
</head>

<body onload="javascript:init();">
<form name="sellerMpIvProcessTypeChangePop" id="sellerMpIvProcessTypeChangePop" method="post" >
	<!-- HIDDEN -->
	<input type="hidden" name="st_user_id" id="st_user_id" value="<%=user_id%>">
	<input type="hidden" name="st_agent" id="st_agent" value="<%=agent%>">
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=buyer%>">
	<input type="hidden" name="st_po_no" id="st_po_no" value="<%=po_no%>">
	<input type="hidden" name="re_process_type" id="re_process_type" value="<%=process_type%>">
	<input type="hidden" name="st_parcel_yn" id="st_parcel_yn" value="N">
	
	<div class="wrapPopup">
  <div class="PopupTit">거래유형 변경요청<span><a href="javascript:parent.closePop2();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  <div class="Importance_Popup" style="width:620px"><img src="/resources/imgs/Icon_Importance01.png" /> 해당 발주번호 내 모든 품목이 변경요청되며, 코리아이플랫폼 담당자가 확인 후 완료처리됩니다. </div>
  <div class="h20"></div>
  <table class="PopupTableTxt" width="640px">
    <colgroup>
      <col width="140px" />
      <col width="500px" /> 
  	</colgroup>
    <tr>
      <th>기존 거래유형</th>
      <td>TR</td>
    </tr>
    <tr>
      <th>변경 거래유형</th>
      <td ><label class="RadioMediumLabel" style=" margin-left:0px" ><input type="radio" name="ch_process_type" value="Y" ><span class="RadioMediumTxt"></span> 고객사 직접납품(택배)</label> 
           <label class="RadioMediumLabel"><input type="radio" name="ch_process_type" value="N"><span class="RadioMediumTxt"></span> 고객사 직접납품(자차)</label> </td>
    </tr>       
    <tr>
      <th>상세사유</th>
      <td> <div class="TextField" id="limitedArea">
          <textarea maxlength="400" placeholder="" style=" width:94%" id="st_reason_text" name="st_reason_text"></textarea>
          <div class="meta" aria-live="polite"> <span id="count">0</span>/400 </div>
        </div>
      </td>
    </tr>
  </table> 
  <div class="h20"></div> 
  <div class="PopupListBtnBox_Center"  style="width:650px;">
    <button class="ButQuaternary_large" onclick="javascript:parent.closePop2();">취소</button>
    <button class="ButPrimary_large"  id="DIVopenPopup" onclick="javascript:processTypeChangeRequest(); return false;">변경요청</button>
  </div>
  <script>
      (function () {
        const wrap = document.getElementById('limitedArea');
        const ta   = document.getElementById('st_reason_text');
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
</div><!-- warp 끝-->
</form> 
</body>
</html>