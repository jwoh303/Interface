<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%
String header_text = CommonUtil.nvl((String) request.getParameter("header_text"), "");	// 팝업 제목 및 그리드 헤더 세팅용
%>

<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
	
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function initPage(){
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",	SaveName : "sStatus",	Header : "상태",	Type : "Status",		Width : 60,		Hidden : 1}, 
	    			{Align : "Center",	SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,		EditLen : 50,	Hidden:true},
	    			{Align : "Left",	SaveName : "ITEM",		Header : "",	Type : "Text",			Width : 245,	EditLen : 110}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	var header_text = "<%=header_text%>";
	mySheet.SetCellText(0, "ITEM", header_text); // 그리드 헤더명에 파라미터로 받아온 이름 설정
	mySheet.SetCountPosition(4);
	
	addrows();
	
	// 붙여넣기 기능 활성
	mySheet.SetClipPasteMode(2);
}
	
var st;
var mt;

//TABLE의 ROW 데이타 생성
function addrows() {
	var rows = mySheet.DataInsert();
}

//그리드 셀 변경시 이벤트
function mySheet_OnChange(Row, Col, Value) {
	if (50 < mySheet.RowCount() + 1) {
		alert("50건 이하의 품목만 입력 가능합니다. 초기화 클릭 후 이용바랍니다.");

		doAction('reload');
	}
}

//기능함수
function doAction(str){
	st = new Date();
	switch (str){
		case "reload":
			mySheet.RemoveAll();
			addrows();
			break;
	}
}

function mySheet_OnLoadData(DATA){
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode){
}

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	mySheet.SetEndEdit(0);
	setTimeout(function() {
		mySheet.SetFocus();
	}, 0);
}
	
	//확인
function kepConfirm(){
	var value1 = "";
	
	for(var i=1; i<=mySheet.RowCount(); i++){
		value1 = value1 + mySheet.GetCellValue(i, "ITEM") + "@";
	}
	
	opener.setPopupReturn(value1);
	this.close();
}
   
</script>
<title>코리아 e 플랫폼</title>
</head>

<body onload="initPage();">
	<!--조회영역-->
	<form name = "searchCondition" method = "post" onsubmit="return false" >
		<input type="hidden" name="s_SAVENAME">
		<input type="hidden" id="pageflag"  name="pageflag" value="1">
		<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
		<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">

		<div id="popWrapper"  style="min-width:0;">
    		<div id="popHeader">
        		<h1 class="title"><%=header_text%> 다중입력</h1>
            	<p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        	</div>
	        
	        <!--팝업내용입니다-->
	        <div id="popContainer" style="width:246px;">
			※ 입력 방법 :<br>엑셀에서 열 일괄 복사 후 붙여넣기 시 반영<br>
		       	<!--grid-->
				<div>
					<script type="text/javascript">
						createIBSheet("mySheet", "246px", "240px");
					</script>
				</div>
				
				<div id="pageindex"></div>

				<!--버튼영역-->
		        <div class="btnArea">
					<span class="fl">
						<span class="btn_02 mr04"><a href="javascript:doAction('reload');">초기화</a></span>
						<span class="btn_02 mr04"><a href="javascript:kepConfirm()">확인</a></span>
					</span>
				</div>
			</div>				
		</div>
	</form>	
</body>
</html>
