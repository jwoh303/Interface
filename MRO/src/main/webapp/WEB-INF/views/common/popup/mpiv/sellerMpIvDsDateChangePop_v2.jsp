<%--
**********************************************
* 메뉴 : 
* 화면 : 납품예정일 변경 요청
* 기능 : 
* 프로그램 ID : SU0503002
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
<link rel="stylesheet" href="/resources/css/month_popup.css" type="text/css" />
<%
	String user_id = _sessionInfo.getUserId();
	String agent = _sessionInfo.getComCode();
	
	String layerPopInfo = CommonUtil.nvl((String)request.getParameter("layerPopInfo"), ""); //이전 페이지에서 넘겨온 대상 품목 데이터들
	if(layerPopInfo == null) layerPopInfo = "[]"; //null 방지
	
%>

<script language="javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var delayFlag = false;

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

// 변경요청
function dsDateChangeRequest(){
	var st_ds_date = $("#st_ds_date").val().replace(/[/]/gi,"");
	
	if(isEmpty(st_ds_date)){
// 		alert("변경요청일을 입력해주세요.");
		var text = "변경요청일을 입력해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	if(delayFlag){
		var form = document.sellerMpIvDsDateChangePop;
		var value_reason = "";
		var value_reason_text = $("#delay_reason_text").val();
		
		for( var i = 0; i < form.delay_reason.length; i++){
			if(form.delay_reason[i].checked == true){
				value_reason = form.delay_reason[i].value;
			}
		}
		
		if(isEmpty(value_reason)) {
// 			alert("지연사유를 선택하세요.");
			var text = "지연사유를 선택하세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		if(value_reason == "기타" && isEmpty(value_reason_text)){
// 			alert("기타 상세사유를 입력하세요.");
			var text = "기타 상세사유를 입력하세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}

		if(value_reason == "기타"){
			$("#st_reason").val(value_reason_text);
		}else{
			$("#st_reason").val(value_reason);
		}
	}
	
	
	var check = $("#confirmCheck").is(":checked");
	if(!check){
// 		alert("확인사항을 확인해주세요.");
		var text = "확인사항을 확인해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var query =  "";
	for(var i = 1; i<=mySheet.RowCount(); i++){
		query +=  mySheet.GetCellValue(i,"BUYER_CODE")	+ "@@";
		query +=  mySheet.GetCellValue(i,"PO_NO")		+ "@@";
		query +=  mySheet.GetCellValue(i,"PO_SEQ")		+ "@@";
		query +=  mySheet.GetCellValue(i,"DS_SEQ")		+ "@@";
		query +=  mySheet.GetCellValue(i,"PR_NO")		+ "@@";
		query +=  mySheet.GetCellValue(i,"PR_SEQ")		+ "@@";
		query +=  mySheet.GetCellValue(i,"AGENT")		+ "@@";
		query +=  mySheet.GetCellValue(i,"DS_DATE")		+ "@@";
		query +=  st_ds_date							+ "@@";
		if(mySheet.GetCellValue(i,"DS_DATE") < st_ds_date){
			query +=  $("#st_reason").val();
		}
		query +=  "^||^" ;
	}
	
	document.sellerMpIvDsDateChangePop.st_query.value = query;
	
// 	if(!confirm("1. 납품예정일은 승인 기준 1회만 변경 가능\n2. 영업일 기준 2일전까지 변경 요청 가능\n\n납품예정일 변경요청을 하시겠습니까?")) return;
	var text = "1. 납품예정일은 승인 기준 1회만 변경 가능</br>2. 영업일 기준 2일전까지 변경 요청 가능</br></br>납품예정일 변경요청을 하시겠습니까?";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:saveSellerMpIvDsDateChangeReqList(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "100px";
	var but2widthC = "100px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);

	
// 	kepAjaxFormCall("/mpiv/saveSellerMpIvDsDateChangeReqList.do","sellerMpIvDsDateChangePop","btnCreate");
}
function saveSellerMpIvDsDateChangeReqList(){
	closePopText1();
	kepAjaxFormCall("/mpiv/saveSellerMpIvDsDateChangeReqList.do","sellerMpIvDsDateChangePop","btnCreate");
}
function closePopup(flag){
	closePopText1();
	parent.setPopupReturn(flag); //flag=1 : 납품이슈현황으로 페이지 이동 , flag=2 : 팝업 닫고 납품진행현황 search
	parent.closePop3();
}
function init(){
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"BUYER_CODE",			Header:"고객사코드",			Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사명",				Type:"Text",		Width:160,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"PO_NO",				Header:"발주코드",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"DS_DATE",				Header:"납품예정일",			Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"AGENT_AMT",			Header:"주문금액",				Type:"Float",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}
			
			,{ Align:"Center",	SaveName:"PO_SEQ",				Header:"PO_SEQ",			Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PR_NO",				Header:"PR_NO",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PR_SEQ",				Header:"PR_SEQ",			Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"DS_SEQ",				Header:"DS_SEQ",			Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"AGENT",				Header:"AGENT",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	mySheet.SetHighlightAfterSort(2);
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");
	mySheet.SetHeaderBackColor("#f2f7ff");	
	
	mySheet.SetTheme("DB", "DeepBlue");
	
	var infoList = <%=layerPopInfo%>;
	
	mySheet.RenderSheet(0);
	for(var i = 0; i<infoList.length; i++){
		// 대상품목 그려주기
		var newIndex = 0;
		newIndex = mySheet.DataInsert(-1);
		mySheet.SetCellValue(newIndex, "BUYER_NAME", infoList[i].BUYER_NAME);
		mySheet.SetCellValue(newIndex, "BUYER_CODE", infoList[i].BUYER_CODE);
		mySheet.SetCellValue(newIndex, "PO_NO", infoList[i].PO_NO);
		mySheet.SetCellValue(newIndex, "PO_SEQ", infoList[i].PO_SEQ);
		mySheet.SetCellValue(newIndex, "PR_NO", infoList[i].PR_NO);
		mySheet.SetCellValue(newIndex, "PR_SEQ", infoList[i].PR_SEQ);
		mySheet.SetCellValue(newIndex, "DS_SEQ", infoList[i].DS_SEQ);
		mySheet.SetCellValue(newIndex, "BUYER_ITEM_NO", infoList[i].BUYER_ITEM_NO);
		mySheet.SetCellValue(newIndex, "AGENT", infoList[i].AGENT);
		mySheet.SetCellValue(newIndex, "DS_DATE", infoList[i].DS_DATE);
		mySheet.SetCellValue(newIndex, "AGENT_AMT", infoList[i].AGENT_AMT);
	}
	mySheet.RenderSheet(1);
	
	
	$("#itemCnt").html("("+mySheet.RowCount()+")");
}

//납품예정일 변경에 따른 이벤트
function delayCheck(){
	delayFlag = false;
	var st_ds_date = $("#st_ds_date").val().replace(/[/]/gi,"");
	var cur_date = kepGetNowTimeStr("YYYYMMDD","");
	
	if(st_ds_date < cur_date){
// 		alert("금일 날짜 이후로 선택해주세요.");
		var text = "금일 날짜 이후로 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_ds_date").val("");
		return;
	}
	
	for(var i = 1; i<=mySheet.RowCount(); i++){
		if(mySheet.GetCellValue(i,"DS_DATE") < st_ds_date){
			delayFlag = true;
		}
		if(mySheet.GetCellValue(i,"DS_DATE") == st_ds_date){
// 			alert("납품예정일 변경건만 가능합니다.");
			var text = "납품예정일 변경건만 가능합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			$("#st_ds_date").val("");
			return;
		}
	}
	if(delayFlag){
		$("#delayReasonTr").show();
	}else{
		$("#delayReasonTr").hide();
	}
}
//지연사유 클릭에 따른 이벤트
function delayReasonClick(){
	var reason = $("input[name='delay_reason']:checked").val();
	if(reason == "기타"){
		$("#delay_reason_text").prop('readonly',false);
	}else{
		$("#delay_reason_text").val("");
		$("#delay_reason_text").prop('readonly',true);
	}
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "btnCreate"){
		
		var text = "납품예정일 변경 신청 후 진행 상황은</br><span class='F6495F'>납품관리 > 납품 이슈현황 > 요청사항현황</span>에서 확인 가능합니다.";
		var but1text = "확인";
		var but2text = "진행현황";
		var but1func = "javascript:closePopup('2'); return false;";
		var but2func = "javascript:closePopup('1'); return false;";
		var but1width = "100px";
		var but2width = "120px";
		openLayerPopText(text,but1text,but2text,but1func,but2func,but1width,but2width);
		
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

<body>
<form name="sellerMpIvDsDateChangePop" id="sellerMpIvDsDateChangePop" method="post" >
	<!-- HIDDEN -->
	<input type="hidden" name="st_user_id" id="st_user_id" value="<%=user_id%>">
	<input type="hidden" name="st_agent" id="st_agent" value="<%=agent%>">
	<input type="hidden" name="st_query" id="st_query" value="">
	<input type="hidden" name="st_reason" id="st_reason" value="">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup">
  <div class="PopupTit">납품예정일 변경 <span><a href="javascript:parent.closePop3();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  <div class="Importance_Popup" style="width:630px"><img src="/resources/imgs/Icon_Importance01.png" /> 대상 발주건을 확인하시고 변경요청 할 납품예정일을 입력해주세요. KeP담당자  확인 후 처리됩니다. </div>
  <div class="h15"></div>
  <table class="PopupTableTxt"  width="650px">
    <colgroup>
      <col width="150px" />
      <col width="650px" /> 
   	</colgroup>
    <tr>      
      <th>변경요청일 <span class="F6495F">*</span></th>
      
      <td>
      			<div class="datepicker-wrap" style=" width:110px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_ds_date" onchange="javascript:delayCheck();" name="st_ds_date" readonly /><span> </span></div>
                </div>
      </td>
    </tr>
    <tr id="delayReasonTr" style="display: none;">
      <th>지연사유 <span class="F6495F">*</span></th>
      <td>
        <label class="RadioMediumLabel"><input type="radio" name="delay_reason" value="재고부족" onchange="javascript:delayReasonClick();"><span class="RadioMediumTxt"></span>재고부족</label> 
        <label class="RadioMediumLabel"><input type="radio" name="delay_reason" value="수입지연" onchange="javascript:delayReasonClick();" ><span class="RadioMediumTxt"></span>수입지연</label>
        <label class="RadioMediumLabel"><input type="radio" name="delay_reason" value="제작지연" onchange="javascript:delayReasonClick();" ><span class="RadioMediumTxt"></span>제작지연</label>
        <label class="RadioMediumLabel"><input type="radio" name="delay_reason" value="발주확인지연" onchange="javascript:delayReasonClick();" ><span class="RadioMediumTxt"></span>발주확인지연</label>
        <label class="RadioMediumLabel"><input type="radio" name="delay_reason" value="기타" onchange="javascript:delayReasonClick();" ><span class="RadioMediumTxt"></span>기타</label><br/>
        <input class="input30" style="width:90%; margin-left:10px; margin-top:5px" name="delay_reason_text" id="delay_reason_text" type="text" placeholder="지연사유를 입력해주세요." readonly="readonly"/>      
      </td>
    </tr>       
  </table>
  
    
  <div class="PopupTitSub">확인사항</div> 
  <div class="Popup_GrayBox" style="width:610px">
    1. 납품예정일은 승인 기준 1회만 변경 가능합니다.<br/>
    2. 영업일 기준 2일전까지 변경요청 가능합니다.<br/>
    <div class="h10"></div>
    <label class="CheckMediumLabel" style=" margin:0"><input type="checkbox" id="confirmCheck"><span class="CheckMediumCustom"></span> 확인하였습니다.  </label> 
  </div>
  <div class="PopupTitSub">대상<p style="display:inline-block; margin-left:5px" id="itemCnt"></p> </div>  
  <div class="IBSheetTablePopup" style="width:650px">
    <script type="text/javascript">
		createIBSheet("mySheet", "", "100%");
    </script>
  </div>  
  <div class="h30"></div>
  <div class="PopupListBtnBox_Center" style="width:650px">
    <button class="ButQuaternary_large" onclick="javascript:parent.closePop3();">취소</button>
    <button class="ButPrimary_large"  onclick="javascript:dsDateChangeRequest(); return false;">변경요청</button>
  </div> 
</div><!-- warp 끝-->
</form>
</body>
</html>