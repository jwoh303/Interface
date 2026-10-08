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
String imgfile_dir = CommonUtil.nvl((String) request.getParameter("IMGFILE_DIR"),"");  //  (조회조건)
String imgfile_name = CommonUtil.nvl((String) request.getParameter("IMGFILE_NAME"),"");  //  (조회조건)
String viewType = CommonUtil.nvl((String) request.getParameter("viewType"),"");  //  (조회조건)
String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  //  (조회조건)
String st_agent = CommonUtil.nvl((String) request.getParameter("st_agent"),"");  //  (조회조건)
// String TYPE = CommonUtil.nvl((String) request.getParameter("TYPE"),"");  //  (조회조건)
// String IMG_YN = CommonUtil.nvl((String) request.getParameter("IMG_YN"),"N");  //  (조회조건) < 이미지 파일이여서 화면에서 보여줄경우 Y , 아니면 N
%>
<script type="text/javascript">
var dropFile = null;
var uploadFileName = "";
var uploadFileExt = "";

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1width = "120px";

function kepOnload(){
	var imgfile_dir = "<%=imgfile_dir%>";
	var imgfile_name = "<%=imgfile_name%>";
	var viewType = "<%=viewType%>";
	
	if(imgfile_name != ""){ //파일 있는 경우
		var lastIndex = imgfile_name.lastIndexOf(".");
		var fileName = imgfile_name.substring(0,lastIndex);
		var fileExt = imgfile_name.substring(lastIndex+1);
		
		uploadFileName = fileName;
		uploadFileExt = fileExt;
		
	  	var imgFlag = "Y";
	  	if(viewType == "R"){ //읽기전용
	  		var newHtml = '<div class="UploaderList"><div class="UploaderListImg" >'+'<img class="img" src="/resources/imgs/Add_file.png" style="cursor:pointer;" onclick="javascript:downLoadFile(\''+imgfile_dir+'\',\''+imgfile_name+'\',\''+imgFlag+'\');" /><div class="Txt"><p>'+uploadFileName+'</p><span>'+uploadFileExt+'</span></div></div></div>';
	  	}else{ //쓰기 가능
		  	var newHtml = '<div class="UploaderList" id="imgDrop"><div class="UploaderListImg" ><img class="Delete" src="/resources/imgs/delete_02.png" style="cursor:pointer;" onclick="javascript:deleteImageFile();"/>'+'<img class="img" src="/resources/imgs/Add_file.png" style="cursor:pointer;" onclick="javascript:downLoadFile(\''+imgfile_dir+'\',\''+imgfile_name+'\',\''+imgFlag+'\');" /><div class="Txt"><p>'+uploadFileName+'</p><span>'+uploadFileExt+'</span></div></div></div>';
	  		
	  	}
	  	
	  	$("#UploadDiv").empty().append(newHtml);
	  	$("#allDownload").show();
	  	$("#infoText").hide();
	}else{ //파일 없는 경우
		var newHtml = '<div class="Uploader" id="imgDrop"><p class="Title"><img src="/resources/imgs/Icon_Drop.png" /><br/>이미지를 넣으시면 등록됩니다</p></div>';
	  	$("#UploadDiv").empty().append(newHtml);
	  	$("#allDownload").hide();
	  	$("#infoText").show();
	}
	
}
function downLoadFile(value,value2,value3){
		location.href="/common/download_v2.do?IMGFILE_DIR="+value+"&IMGFILE_NAME="+value2+"&IMG_YN="+value3;
}
function downloadAll(){
	location.href="/common/download_v2.do?IMGFILE_DIR="+$("#IMGFILE_DIR").val()+"&IMGFILE_NAME="+$("#IMGFILE_NAME").val()+"&IMG_YN=Y";
}
function setImage(){
	var value1 = $("#IMGFILE_DIR").val();
  	var value2 = $("#IMGFILE_NAME").val();
	parent.setPopupReturn(value1,value2);
	parent.closePop();
}
function imgFileUploadOpen(){
	$("#imgFile").click();
}
function imgFileUpload(){
	if(uploadFileName != ""){
// 		alert("기존 첨부 파일을 삭제하고 진행해주시기 바랍니다.");
		var text = "기존 첨부 파일을 삭제하고 진행해주시기 바랍니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}	
	dropFile = null;
	
	var lastIndex = $("#imgFile")[0].files[0].name.lastIndexOf(".");
	var fileName = $("#imgFile")[0].files[0].name.substring(0,lastIndex);
	var fileExt = $("#imgFile")[0].files[0].name.substring(lastIndex+1);
	var ext = $("#imgFile")[0].files[0].name.substring(lastIndex).toLowerCase();
	
	if (fileName == ""){
// 		alert("이미지를 선택하세요.");
		var text = "이미지를 선택하세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	if (ext != ".jpg" && ext != ".jpeg" && ext != ".gif" && ext != ".png"){
// 		alert("이미지 업로드 할 수 없는 확장자 입니다.");
		var text = "이미지 업로드 할 수 없는 확장자 입니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	uploadFileName = fileName;
	uploadFileExt = fileExt;
	
	document.forms["searchCondition"].target = "account_work";
	document.forms["searchCondition"].method = "post";
	document.forms["searchCondition"].action ="/mprq/addImgRegPop.do";
	document.forms["searchCondition"].submit();
}
function upSet(docNo){ //이미지 업로드 후처리 함수
	var mg_arr = docNo.split("^");
  	$("#IMGFILE_DIR").val(mg_arr[0]);
  	$("#IMGFILE_NAME").val(mg_arr[1]);
//   	alert("이미지가 첨부되었습니다.");
  	var text = "이미지가 첨부되었습니다.";
	openLayerPopText2(text,but1text,but1func,but1width);
  	
  	var imgFileDir = $("#IMGFILE_DIR").val();
  	var imgFileName = $("#IMGFILE_NAME").val();
  	var imgFlag = "Y";
  	var newHtml = '<div class="UploaderList" id="imgDrop"><div class="UploaderListImg" ><img class="Delete" src="/resources/imgs/delete_02.png" style="cursor:pointer;" onclick="javascript:deleteImageFile();"/>'+'<img class="img" src="/resources/imgs/Add_file.png" style="cursor:pointer;" onclick="javascript:downLoadFile(\''+imgFileDir+'\',\''+imgFileName+'\',\''+imgFlag+'\');" /><div class="Txt"><p>'+uploadFileName+'</p><span>'+uploadFileExt+'</span></div></div></div>';
  	$("#UploadDiv").empty().append(newHtml);
  	$("#allDownload").show();
  	$("#infoText").hide();
}
function deleteImageFile(){ //서버에 업로드 된 파일은 안지우고 화면상으로만 교체
// 	alert("이미지가 삭제되었습니다.");
	var text = "이미지가 삭제되었습니다.";
	openLayerPopText2(text,but1text,but1func,but1width);
	
	dropFile = null;
	$("#imgFile").val("");
	$("#imgFileDrag").val("");
	$("#IMGFILE_DIR").val("");
  	$("#IMGFILE_NAME").val("");
  	uploadFileName = "";
	uploadFileExt = "";
	$("#allDownload").hide();
	$("#infoText").show();
  	
  	var newHtml = '<div class="Uploader" id="imgDrop"><p class="Title"><img src="/resources/imgs/Icon_Drop.png" /><br/>이미지를 넣으시면 등록됩니다</p></div>';
  	$("#UploadDiv").empty().append(newHtml);
  	
  	
}

//이미지 드래그앤드랍으로 첨부 구현
//이미지 2번 드래그앤드랍 할 경우 브라우저로 열리는 것 방지
$(document).on("dragover drop", function(e) {
e.preventDefault();
e.stopPropagation();
});
//드래그 오버
$(document).on('dragover',"#imgDrop", function(e) {
e.preventDefault();
e.stopPropagation();
$(this).addClass('dragover');
});

//드래그 아웃
$(document).on('dragleave',"#imgDrop", function(e) {
e.preventDefault();
e.stopPropagation();
$(this).removeClass('dragover');
});

//파일 드롭
$(document).on('drop',"#imgDrop", function(e) {
e.preventDefault();
e.stopPropagation();
$(this).removeClass('dragover');
if(uploadFileName != ""){
// 	alert("기존 첨부 파일을 삭제하고 진행해주시기 바랍니다.");
	var text = "기존 첨부 파일을 삭제하고 진행해주시기 바랍니다.";
	openLayerPopText2(text,but1text,but1func,but1width);
	return;
}

var file = e.originalEvent.dataTransfer.files[0]; //이미지는 1개 첨부라 고정
handleImgFiles(file);
});
function handleImgFiles(file){
	
	var lastIndex = file.name.lastIndexOf(".");
	var fileName = file.name.substring(0,lastIndex);
	var fileExt = file.name.substring(lastIndex+1);
	var ext = file.name.substring(lastIndex).toLowerCase();
	
	if (fileName == ""){
// 		alert("이미지를 선택하세요.");
		var text = "이미지를 선택하세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	} 	
	if (ext != ".jpg" && ext != ".jpeg" && ext != ".gif" && ext != ".png"){
// 		alert("이미지 업로드 할 수 없는 확장자 입니다.");
		var text = "이미지 업로드 할 수 없는 확장자 입니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	dropFile = file;
	
	uploadFileName = fileName;
	uploadFileExt = fileExt;
	
	var form = $("#searchCondition");
	form.find("#imgFileDrag").remove();
	var fileInput = $('<input type="file" name="files1" id="imgFileDrag" style="display:none;">');
	form.append(fileInput);
	
	var dataTransfer = new DataTransfer();
	dataTransfer.items.add(file);
	fileInput[0].files = dataTransfer.files;
	
	document.forms["searchCondition"].target = "account_work";
	document.forms["searchCondition"].method = "post";
	document.forms["searchCondition"].action ="/mprq/addImgRegPop.do";
	document.forms["searchCondition"].submit();
}
</script>  
<body onload="kepOnload()" >
<iframe name="account_work" id="account_work" style="display:none;" scrolling="no" frameborder="0" width="100%" height="100%"></iframe>
<form name="searchCondition" id="searchCondition" method="post" modelAttribute="uploadForm" enctype="multipart/form-data">
  <input type="hidden" name="IMGFILE_NAME" id="IMGFILE_NAME" value="<%=imgfile_name%>" >
  <input type="hidden" name="IMGFILE_DIR" id="IMGFILE_DIR" value="<%=imgfile_dir%>" >
  <input type="hidden" name="renewal" id="renewal" value="Y" >
  <input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no" value="<%=st_buyer_item_no%>" >
  <input type="hidden" name="st_agent" id="st_agent" value="<%=st_agent%>" >
  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup">
  <div class="PopupTit">이미지첨부<span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  <div class="Importance_Popup_row2" style="width:540px; height:30px; line-height:25px">▪이미지는 1개만 등록 가능합니다. 
  </div>
  <div class="h20"></div>
  <div id="UploadDiv"> 
  <div class="Uploader" style="width:560px; height:100px" id="imgDrop"><p class="Title"><img src="/resources/imgs/Icon_Drop.png" /><br/> 파일을 끌어다 넣으시거나 [파일찾기] 버튼을 통해 등록가능합니다.</p></div>
  </div>
  <div class="PopupTitSubSmall" style="position:relative;width:560px;">
  <button class="ButDownload_Medium_Outline" style=" margin-bottom:20px;"  onclick="javascript:downloadAll(); return false;" id="allDownload">전체다운로드</button>
  <%if(!viewType.equals("R")) {%> 
  <p class="font15px font400 mt10" style=" line-height:20px;" id="infoText">
      1. 제품의 도면, MSDS 및 기타 자료는 파일로 첨부 바랍니다.<br/>
      2. 제품의 상세 도면은 이미지로 등록이 불가합니다.</p>
  <button class="ButDarkGray_Medium" style=" position:absolute; right:0; top:5px" onclick="javascript:imgFileUploadOpen(); return false;">파일찾기</button>
  <%} %>
  </div>
  <input type="file" name="files1" id="imgFile" style="display: none;" onchange="imgFileUpload();">
  <div class="h15"></div>
  <div class="PopupListBtnBox_Center" style="width:560px;">
    <%if(!viewType.equals("R")) {%> 
    <button class="ButQuaternary_large" onclick="javascript:parent.closePop();" >취소</button>
    <button class="ButPrimary_large" onclick="javascript:setImage(); return false;">확인</button>
    <%}else{ %>
    <button class="ButQuaternary_large" onclick="javascript:parent.closePop();" >닫기</button>
    <%} %>
  </div>
</div><!-- warp 끝-->
</form>
</body>
</html>
