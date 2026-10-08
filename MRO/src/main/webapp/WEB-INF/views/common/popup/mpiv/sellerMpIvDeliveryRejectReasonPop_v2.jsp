<%--
**********************************************
* 메뉴 : 
* 화면 : 수주거부 팝업
* 기능 : 수주거부 사유 입력 팝업
* 프로그램 ID : SU0502006
* 담당자 : 최찬규
* 착수일 : 2025-09-26
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
	@SuppressWarnings (value="unchecked")

	//SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String user_id      = _sessionInfo.getUserId();
	String com_code =  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
	String p_buyer = CommonUtil.nvl((String) request.getParameter("buyer"),"");  //  (조회조건)
	String p_po_no = CommonUtil.nvl((String) request.getParameter("po_no"),"");  //  (조회조건)
%>
<script type="text/javascript"> 
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var dropFile = null;

var norFileStore = {};

</script>
<script language="javascript">

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	$("#itemCnt").html("("+mySheet.RowCount()+")");
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
// 거부사유 저장
function deliveryRejectReq(){
	var form = document.sellerMpIvDeliveryRejectReasonPop;
	var value_reason = "";
	var value_reason_text = "";
	var image_key = "";
	
	for( var i = 0; i < form.rdo_reject_reason_cd.length; i++){
		if(form.rdo_reject_reason_cd[i].checked == true){
			value_reason = form.rdo_reject_reason_cd[i].value;
		}
	}
	
	if(isEmpty(value_reason)) {
// 		alert("거부사유를 선택하세요.");
		var text = "거부사유를 선택하세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	value_reason_text = $("#st_reject_reason_text").val();
	image_key = $("#st_image_key").val();
	
	if(isEmpty(value_reason_text)) {
// 		alert("거부 상세사유를 입력하세요.");
		var text = "거부 상세사유를 입력하세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	
// 	if(!confirm("수주거부 하시겠습니까?")){
// 		return;
// 	}
	var text = "수주거부 하시겠습니까?";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:setRejectReasonTextCheck(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "100px";
	var but2widthC = "100px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
	
	
}
function setRejectReasonTextCheck(){
	var form = document.sellerMpIvDeliveryRejectReasonPop;
	var value_reason = "";
	var value_reason_text = "";
	var image_key = "";
	
	for( var i = 0; i < form.rdo_reject_reason_cd.length; i++){
		if(form.rdo_reject_reason_cd[i].checked == true){
			value_reason = form.rdo_reject_reason_cd[i].value;
		}
	}
	
	value_reason_text = $("#st_reject_reason_text").val();
	image_key = $("#st_image_key").val();
	
	closePopText1();
	parent.setRejectReasonText(value_reason, value_reason_text, image_key);
	parent.closePop();
}
function init(){
	

	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:60,	Edit:true,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PO_NO",				Header:"발주코드",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"품목명",				Type:"Text",		Width:230,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"UNIT_PRICE",			Header:"단가",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Format:"${priceFormat}"}
			,{ Align:"Right",	SaveName:"ITEM_QTY",			Header:"수량",				Type:"Int",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"ITEM_AMT",			Header:"주문금액",				Type:"Float",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet.SetTheme("DB", "DeepBlue");
	
	kepSearch(document.sellerMpIvDeliveryRejectReasonPop, mySheet, "/mpiv/getSellerMpIvDeliveryRejectReasonPop_v2.do" , pagingMode);
}

function rejectReasonClick(){
	
	var reason = $("input[name='rdo_reject_reason_cd']:checked").val();
	if(reason == "단가이슈"){
		$("#st_reject_reason_text").attr('placeholder',"요청사유 및 납품 가능 단가 기재 후 제출");
	}else if(reason == "규격이슈"){
		$("#st_reject_reason_text").attr('placeholder',"필요정보(제조사/사양/기타) 기재 후 제출");
	}else if(reason == "단종상품"){
		$("#st_reject_reason_text").attr('placeholder',"대체품목 기재 후 제출");
	}else if(reason == "수급불가"){
		$("#st_reject_reason_text").attr('placeholder',"수급불가 사유 기재 후 제출");
	}else if(reason == "기타사유"){
		$("#st_reject_reason_text").attr('placeholder',"상기 외 사유 기재 후 제출");
	}
}

function norFileUploadOpen(){
	$("#norFile").click();
}
function norFileUpload(filesList){
	var fileLength = 0;
	var newFile;
	if(filesList == undefined){ //파일찾기로 첨부
		fileLength = Array.from($("#norFile").prop("files")).length; //첨부파일 갯수
		newFile = Array.from($("#norFile").prop("files"));
	}else{ //드래그앤드랍으로 첨부
		fileLength = Array.from(filesList).length; //첨부파일 갯수
		newFile = Array.from(filesList);
		dropFile = filesList;
	}
	if(fileLength + Object.keys(norFileStore).length > 5){//최대 5개까지 첨부
// 		alert("최대 5개 까지만 첨부 가능합니다.");
		var text = "최대 5개 까지만 첨부 가능합니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		dropFile = null;
		return;
	}
	
	var banArray = [".csv",".enc",".ncf",".txt",".gif",".png",".jpg",".jpeg",".bmp",".sit",".xls",".doc",".docx",".hwp",".ppt",".pptx",".pdf",".tif",".tiff",".xlsx",".zip",".dwg",".ai",".gul",".mht"];
	
	newFile.forEach(function(f){
		//확장자 체크 
		var dot = f.name.lastIndexOf(".");
		var ext = f.name.substring(dot).toLowerCase();
		
		if(banArray.indexOf(ext) == -1){
// 			alert("첨부할 수 없는 확장자입니다.");
			var text = "첨부할 수 없는 확장자입니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			dropFile = null;
			return;
		}
	})
	
	//드래그앤드랍
	if(filesList != undefined){
		var form = $("#sellerMpIvDeliveryRejectReasonPop");
		form.find("#imgFileDrag").remove();
		var fileInput = $('<input type="file" name="files" id="imgFileDrag" style="display:none;">');
		form.append(fileInput);
		
		var dataTransfer = new DataTransfer();
		for(var i = 0; i<filesList.length; i++){
			dataTransfer.items.add(filesList[i]);
		}
		
		fileInput[0].files = dataTransfer.files;
	}
	
	
	document.forms["sellerMpIvDeliveryRejectReasonPop"].target = "fileUpload";
	document.forms["sellerMpIvDeliveryRejectReasonPop"].method = "post";
	document.forms["sellerMpIvDeliveryRejectReasonPop"].action ="/common/fileUpload_v2.do";
	document.forms["sellerMpIvDeliveryRejectReasonPop"].submit();
	
}
function upFileSet(docNo,key,result,extCheck){
	if(result == "E"){ // 확장자 오류
// 		alert(extCheck+" 파일은 첨부할 수 없는 파일입니다.");
		var text = extCheck+" 파일은 첨부할 수 없는 파일입니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}else if(result != "S"){ //정상 업로드
		$("#DOC_NO").val(docNo);
		$("#st_image_key").val(docNo);
// 		alert("파일이 첨부되었습니다.");
		var text = "파일이 첨부되었습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		var keyArr = key.split(",");
		//해당 파일 list에 넣고 화면 그려주기
		var newFile;
		if(dropFile != undefined && dropFile != null){
			newFile = Array.from(dropFile);
			dropFile = null;
			$("#imgFileDrag").val(""); //초기화
			
		}else{
			newFile = Array.from($("#norFile").prop("files"));
			$("#norFile").val(""); //초기화
		}
		var seq = 0;
		newFile.forEach(function(f){
			norFileStore[keyArr[seq]]= f.name;
			seq++;
		})
		makeFileList();
	}
}
function makeFileList(){
	
	var newHtml = "";
	$("#Uploader").empty();
	
	if(Object.keys(norFileStore).length != 0){
		
		for(var key in norFileStore){
		
			var lastIndex = norFileStore[key].lastIndexOf(".");
			var fileName = norFileStore[key].substring(0,lastIndex);
			var ext = norFileStore[key].substring(lastIndex+1);
		
			var docNo = $("#DOC_NO").val();
			
			newHtml = '<div class="UploaderListImg" ><img class="Delete" src="/resources/imgs/delete_02.png" style="cursor:pointer;" onclick="javascript:deleteNorFile(\''+key+'\');"/>'+'<img class="img" src="/resources/imgs/Add_file.png" style="cursor:pointer;" onclick="javascript:downLoadFile(\''+docNo+'\',\''+key+'\');" /><div class="Txt"><p>'+fileName+'</p><span>'+ext+'</span></div></div>';
			$("#Uploader").append(newHtml);
		}
	}else{
		$("#DOC_NO").val("");
		$("#st_image_key").val("");
		$("#imgFileDrag").val("");
		newHtml = '<p class="Title"><img src="/resources/imgs/Icon_Drop.png" /><br/> 파일을 끌어다 넣으시거나 [파일찾기] 버튼을 통해 등록가능합니다.</p>';
		$("#Uploader").append(newHtml);
	}

}
function deleteNorFile(key){
	
	$("#D_DOC_NO").val($("#DOC_NO").val());
	$("#D_DOC_SEQ").val(key);
	
	kepAjaxFormCall("/common/removeFileInfo.do","deleteFile","Remove");
	
}

function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	if(pMethod == "Remove"){ //key 받아서 해당 파일 삭제
// 		alert("첨부파일이 삭제되었습니다.");
		var text = "첨부파일이 삭제되었습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		delete norFileStore[response.key];
		makeFileList();
	}
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.msg;
	
	if (!isEmpty(msg)){
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	return;
}

//드래그앤드랍으로 첨부 구현
$(document).on("dragover drop", function(e) {
e.preventDefault();
e.stopPropagation();
});
//드래그 오버
$(document).on('dragover',"#Uploader", function(e) {
e.preventDefault();
e.stopPropagation();
$(this).addClass('dragover');
});

//드래그 아웃
$(document).on('dragleave',"#Uploader", function(e) {
e.preventDefault();
e.stopPropagation();
$(this).removeClass('dragover');
});

//파일 드롭
$(document).on('drop',"#Uploader", function(e) {
e.preventDefault();
e.stopPropagation();
$(this).removeClass('dragover');

norFileUpload(e.originalEvent.dataTransfer.files);
});
</script> 
</head>
<body onload="init();">
<iframe name="fileUpload" id="fileUpload" style="display:none;" scrolling="no" frameborder="0" width="100%" height="100%"></iframe>
<form name="sellerMpIvDeliveryRejectReasonPop" id="sellerMpIvDeliveryRejectReasonPop" method=post modelAttribute="uploadForm" enctype="multipart/form-data">
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="st_com_code" id="st_com_code"  value="<%=com_code%>">
	<input type="hidden" name="st_buyer" id="st_buyer"  value="<%=p_buyer%>">
	<input type="hidden" name="st_po_no" id="st_po_no"  value="<%=p_po_no%>">
	<input type="hidden" id="DOC_NO" name="DOC_NO" value="">
	<input type="hidden" id="TYPE" name="TYPE" value="RFQ">
	<input type="hidden" name="renewal" id="renewal" value="Y" >
<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
<div class="wrapPopup">
  <div class="PopupTit">수주거부요청<span>
  <a href="javascript:parent.closePop();">
  <img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  <div class="Importance_Popup" style="width:720px"><img src="/resources/imgs/Icon_Importance01.png" /> 수주거부 시 해당 발주번호 내 모든 품목이 수주거부 신청되어 KeP 담당자가 확인 전까지 수주접수대상에서 제외됩니다. </div>
  <div class="PopupTitSub">거부사유</div>
  <div class="Popup_BlueBox" style="width:725px">
    <label class="RadioLargeLabel"><input type="radio" name="rdo_reject_reason_cd" onchange="javascript:rejectReasonClick();" value="단가이슈"><span class="RadioLargeTxt"></span>단가이슈</label> 
    <label class="RadioLargeLabel"><input type="radio" name="rdo_reject_reason_cd" onchange="javascript:rejectReasonClick();" value="규격이슈"><span class="RadioLargeTxt"></span>규격이슈</label>
    <label class="RadioLargeLabel"><input type="radio" name="rdo_reject_reason_cd" onchange="javascript:rejectReasonClick();" value="단종상품"><span class="RadioLargeTxt"></span>단종상품</label>
    <label class="RadioLargeLabel"><input type="radio" name="rdo_reject_reason_cd" onchange="javascript:rejectReasonClick();" value="수급불가"><span class="RadioLargeTxt"></span>수급불가</label>
    <label class="RadioLargeLabel"><input type="radio" name="rdo_reject_reason_cd" onchange="javascript:rejectReasonClick();" value="기타사유"><span class="RadioLargeTxt"></span>기타사유</label><br/>
    <input class="input30" style="width:90%; margin-left:10px; margin-top:5px" name="st_reject_reason_text" id="st_reject_reason_text" maxlength="100" type="text" placeholder="" />
  </div>
  <div class="PopupTitSubSmall" style=" position:relative;width:740px">증빙첨부 
    <span style="font-size:14px; font-weight:400px; color:#5B5C61; margin-left:15px">· 첨부파일은 최대 5개까지 등록가능합니다.   </span>
    <button class="ButMSmallDarkGray" style=" position:absolute; right:0; top:15px" onclick="javascript:norFileUploadOpen(); return false;">파일찾기</button>
    <input type="file" name="files" id="norFile" style="display: none;" onchange="norFileUpload(); " multiple="multiple">
    <input type="hidden" name="st_image_key" id="st_image_key"  value="">
  </div>
  <div class="Uploader" id="Uploader" style="width:740px"><p class="Title"><img src="/resources/imgs/Icon_Drop.png" /><br/> 파일을 끌어다 넣으시거나 [파일찾기] 버튼을 통해 등록가능합니다.</p></div>
   
  <div class="PopupTitSub">대상품목<p style="display:inline-block; margin-left:5px" id="itemCnt"></p> </div>  
  <div class="IBSheetTablePopup" style="width:740px">
    <script type="text/javascript">
		createIBSheet("mySheet", "", "100%");
    </script>
  </div>
  </div>
  <div class="PopupListBtnBox_Center" style="width:775px;">
   <button class="ButQuaternary_large" onclick="javascript:parent.closePop();">취소</button>
    <button class="ButPrimary_large" id="DIVopenPopup" onclick="javascript:deliveryRejectReq(); return false;">수주거부요청</button>
  </div>
</div><!-- warp 끝-->       
</div>
</form>
<form name="deleteFile" id="deleteFile">
	<input type="hidden" name="D_DOC_NO" id="D_DOC_NO" value="" >
	<input type="hidden" name="D_DOC_SEQ" id="D_DOC_SEQ" value="" >
	<input type="hidden" name="D_TYPE" id="D_TYPE" value="RFQ" >
	<input type="hidden" name="renewal" id="renewal" value="Y" >
</form> 
</body>
</html>
