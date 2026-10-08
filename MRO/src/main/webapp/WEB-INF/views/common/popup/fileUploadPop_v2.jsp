<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../include/head_v2.jspf"  %>
</head>
<%
String DOC_NO = CommonUtil.nvl((String) request.getParameter("DOC_NO"),"");  //  (조회조건)
String viewType = CommonUtil.nvl((String) request.getParameter("viewType"),"");  //  (조회조건)
String TYPE = CommonUtil.nvl((String) request.getParameter("TYPE"),"");  //  (조회조건)
String bulkYn = CommonUtil.nvl((String) request.getParameter("bulkYn"),"N");  //setpopupReturn에서 체크된 애들 전부 적용하는지 여부

List<Map<String,String>> fileData = (List<Map<String,String>>) request.getAttribute("fileData"); // 조회된 결과
// String IMG_YN = CommonUtil.nvl((String) request.getParameter("IMG_YN"),"N");  //  (조회조건) < 이미지 파일이여서 화면에서 보여줄경우 Y , 아니면 N
%> 
<script type="text/javascript">
var dropNorFile = null;

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1width = "120px";

var norFileStore = {};
function kepOnload(){
	var doc_no = "<%=DOC_NO%>";
	if(doc_no != ""){ //파일 있는 경우
		$("#DOC_NO").val("<%=DOC_NO%>");
		kepAjaxFormCall("/common/getFileList_v2.do","searchCondition","getFileList_v2");
	}else{
		makeFileList();
	}
}
function downLoadFile(value,value2,value3){
	if(value2==undefined){
		value2 = "";
	}
	location.href="/common/download_v2.do?DOC_NO="+value+"&DOC_SEQ="+value2;
}
function downloadAll(){
	var DOC_NO = $("#DOC_NO").val();
	location.href="/common/download_v2.do?DOC_NO="+DOC_NO+"&DOC_SEQ="+"";
}
function setFile(){
	var value1 = $("#DOC_NO").val();
	var value2 = Object.keys(norFileStore).length; //첨부파일 갯수
	parent.setPopupReturn(value1,value2);
	parent.closePop();
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
		dropNorFile = filesList;
	}
	if(fileLength + Object.keys(norFileStore).length > 5){//최대 5개까지 첨부
// 		alert("최대 5개 까지만 첨부 가능합니다.");
		var text = "최대 5개 까지만 첨부 가능합니다.";
		openLayerPopText2(text,but1text,but1func,but1width);

		dropNorFile = null;
		return;
	}
	
	var banArray = [".csv",".enc",".ncf",".txt",".gif",".png",".jpg",".jpeg",".bmp",".sit",".xls",".doc",".docx",".hwp",".ppt",".pptx",".pdf",".tif",".tiff",".xlsx",".zip",".dwg",".ai",".gul",".mht"];
	
	var fileCheck = false;
	newFile.forEach(function(f){
		//확장자 체크 
		var dot = f.name.lastIndexOf(".");
		var ext = f.name.substring(dot).toLowerCase();
		
		if(banArray.indexOf(ext) == -1){
// 			alert("첨부할 수 없는 확장자입니다.");
			var text = "첨부할 수 없는 확장자입니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			dropNorFile = null;
			return;
		}
		for(var key in norFileStore){
			var fileStoreName = norFileStore[key];
			if(fileStoreName == f.name){
// 				alert("이미 선택한 파일입니다.");
				var text = "이미 선택한 파일입니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				fileCheck = true; //중복여부
				return;
			}
		}
	})
	if(fileCheck)
		return;
	
	//드래그앤드랍
	if(filesList != undefined){
		var form = $("#searchCondition");
		form.find("#imgNorFileDrag").remove();
		var fileInput = $('<input type="file" name="files" id="imgNorFileDrag" style="display:none;">');
		form.append(fileInput);
		
		var dataTransfer = new DataTransfer();
		for(var i = 0; i<filesList.length; i++){
			dataTransfer.items.add(filesList[i]);
		}
		
		fileInput[0].files = dataTransfer.files;
	}
	
	document.forms["searchCondition"].target = "fileUpload";
	document.forms["searchCondition"].method = "post";
	document.forms["searchCondition"].action ="/common/fileUpload_v2.do";
	document.forms["searchCondition"].submit();
	
}
function upFileSet(docNo,key,result,extCheck){ //첨부파일 업로드 후처리 함수
	if(result == "E"){ // 확장자 오류
// 		alert(extCheck+" 파일은 첨부할 수 없는 파일입니다.");
		var text = extCheck+" 파일은 첨부할 수 없는 파일입니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}else if(result != "S"){ //정상 업로드
		$("#DOC_NO").val(docNo);
		$("#SELLER_IMAGE_KEY").val(docNo);
// 		alert("파일이 첨부되었습니다.");
		var text = "파일이 첨부되었습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		//해당 파일 list에 넣고 화면 그려주기
		var keyArr = key.split(",");
		var newFile;
		if(dropNorFile != undefined && dropNorFile != null){
			newFile = Array.from(dropNorFile);
			dropNorFile = null;
			$("#imgNorFileDrag").val(""); //초기화
			
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
	$("#UploadFileDiv").empty();
	
	if(Object.keys(norFileStore).length == 0){ //다 삭제 된 경우
		$("#SELLER_IMAGE_KEY").val("");
		$("#DOC_NO").val("");
		
		$("#imgNorFileDrag").val("");
		newHtml = '<div class="Uploader" id="fileDrop"><p class="Title"><img src="/resources/imgs/Icon_Drop.png" /><br/>파일을 끌어다 넣으시거나 [파일찾기] 버튼을 통해 등록가능합니다.</p></div>';
		$("#UploadFileDiv").append(newHtml);
		
		$("#allDownload").hide();
		
	}else{
		if(viewType == "R"){ //읽기전용
			newHtml = '<div class="UploaderList">';
		}else{
			newHtml = '<div class="UploaderList" id="fileDrop">';
		}
		for(var key in norFileStore){
			
			var lastIndex = norFileStore[key].lastIndexOf(".");
			var fileName = norFileStore[key].substring(0,lastIndex);
			var ext = norFileStore[key].substring(lastIndex+1);
			
			var docNo = $("#DOC_NO").val();
		  	var viewType = "<%=viewType%>";
			
		  	if(viewType == "R"){ //읽기전용
		  		newHtml += '<div class="UploaderListImg" >'+'<img class="img" src="/resources/imgs/Add_file.png" style="cursor:pointer;" onclick="javascript:downLoadFile(\''+docNo+'\',\''+key+'\');" /><div class="Txt"><p>'+fileName+'</p><span>'+ext+'</span></div></div>';
		  	}else{ //쓰기 가능
				newHtml += '<div class="UploaderListImg" ><img class="Delete" src="/resources/imgs/delete_02.png" style="cursor:pointer;" onclick="javascript:deleteNorFile(\''+key+'\');"/>'+'<img class="img" src="/resources/imgs/Add_file.png" style="cursor:pointer;" onclick="javascript:downLoadFile(\''+docNo+'\',\''+key+'\');" /><div class="Txt"><p>'+fileName+'</p><span>'+ext+'</span></div></div>';
		  	}
		}
		newHtml += '</div>';
		$("#UploadFileDiv").append(newHtml);
		
		$("#allDownload").show();
	}
	
	
}
function deleteNorFile(key){ //서버에 업로드 된 파일은 안지우고 화면상으로만 교체
	
	$("#D_DOC_NO").val($("#DOC_NO").val());
	$("#D_DOC_SEQ").val(key);
	
	kepAjaxFormCall("/common/removeFileInfo.do","deleteFile","Delete");
	
}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	if(pMethod == "Delete"){ //key 받아서 해당 파일 삭제
// 		alert("첨부파일이 삭제되었습니다.");
		var text = "첨부파일이 삭제되었습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		delete norFileStore[response.key];
		makeFileList();
	}else if(pMethod == "getFileList_v2"){
		response.forEach(function(data){
			var fileName = data['SRC_FILE_NAME'];
			var fileSeq = data['DOC_SEQ'];
			norFileStore[fileSeq]= fileName;
		})
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
//일반 파일첨부 드래그앤드랍 구현
$(document).on("dragover drop", function(e) {
e.preventDefault();
e.stopPropagation();
});
//드래그 오버
$(document).on('dragover',"#fileDrop", function(e) {
e.preventDefault();
e.stopPropagation();
$(this).addClass('dragover');
});

//드래그 아웃
$(document).on('dragleave',"#fileDrop", function(e) {
e.preventDefault();
e.stopPropagation();
$(this).removeClass('dragover');
});

//파일 드롭
$(document).on('drop',"#fileDrop", function(e) {
e.preventDefault();
e.stopPropagation();
$(this).removeClass('dragover');

norFileUpload(e.originalEvent.dataTransfer.files);
});
</script>  
<body onload="kepOnload()" >
<iframe name="fileUpload" id="fileUpload" style="display:none;" scrolling="no" frameborder="0" width="100%" height="100%"></iframe>
<form name="searchCondition" id="searchCondition" method="post" modelAttribute="uploadForm" enctype="multipart/form-data">
  <input type="hidden" name="DOC_NO" id="DOC_NO" value="<%=DOC_NO%>" >
  <input type="hidden" name="TYPE" id="TYPE" value="<%=TYPE%>" >
  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup">
  <%if(TYPE.equals("IV")) {%>
  <div class="PopupTit">배송증빙<span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  <div class="Importance_Popup_row2" style="width:540px; height:60px; line-height:25px">
  ▪배송완료 증빙 첨부파일을 등록할 수 있습니다.</br>
  ▪최대 5개까지 등록 가능합니다. 
  </div>
  <%}else{ %>
  <div class="PopupTit">파일첨부<span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  	<%if(bulkYn.equals("Y")) {%>
  		<div class="Importance_Popup_row2" style="width:540px; height:60px; line-height:25px">
  		▪최대 5개까지 등록 가능합니다. </br>
  		<span style="color:#2172EC">▪체크박스로 선택한 모든 행에 첨부파일이 일괄 적용됩니다.</span>
  	<%}else{ %>
  		<div class="Importance_Popup_row2" style="width:520px; height:30px; line-height:25px">▪최대 5개까지 등록 가능합니다. 
  	<%} %>
  
  </div>
  <%} %>
  <div class="h20"></div>
  <div id="UploadFileDiv"> 
  <div class="Uploader" style="width:560px; height:100px" id="fileDrop"><p class="Title"><img src="/resources/imgs/Icon_Drop.png" /><br/> 파일을 끌어다 넣으시거나 [파일찾기] 버튼을 통해 등록가능합니다.</p></div>
  </div>
  <div class="PopupTitSubSmall" style="position:relative;width:560px;">
  <button class="ButDownload_Medium_Outline" style=" margin-bottom:20px;"  onclick="javascript:downloadAll(); return false;" id="allDownload">전체다운로드</button>
  <%if(!viewType.equals("R")) {%> 
  <button class="ButDarkGray_Medium" style="position:absolute; right:20px; top:5px" onclick="javascript:norFileUploadOpen(); return false;">파일찾기</button>
  <%} %>
  </div>
  <input type="file" name="files" id="norFile" style="display: none;" onchange="norFileUpload();" multiple="multiple">
  <div class="h15"></div>
  <div class="PopupListBtnBox_Center" style="width:560px;">
    <%if(!viewType.equals("R")) {%> 
    <button class="ButQuaternary_large" onclick="javascript:parent.closePop();" >취소</button>
    <button class="ButPrimary_large" onclick="javascript:setFile(); return false;">확인</button>
    <%}else{ %>
    <button class="ButQuaternary_large" onclick="javascript:parent.closePop();" >닫기</button>
    <%} %>
  </div>
</div><!-- warp 끝-->
</form>
<form name="deleteFile" id="deleteFile">
	<input type="hidden" name="D_DOC_NO" id="D_DOC_NO" value="" >
	<input type="hidden" name="D_DOC_SEQ" id="D_DOC_SEQ" value="" >
	<input type="hidden" name="D_TYPE" id="D_TYPE" value="<%=TYPE%>" >
	<input type="hidden" name="renewal" id="renewal" value="Y" >
</form>     
</body>
</html>
