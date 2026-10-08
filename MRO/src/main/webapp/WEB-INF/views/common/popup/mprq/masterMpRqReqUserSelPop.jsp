<%--
**********************************************
* 메뉴 : 
* 화면 : 담당자 팝업
* 기능 : 
* 프로그램 ID : 
* 담당자 :  김영미 ( 설계 : 권우재 )
* 착수일 : 2014-06-10
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
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
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
   			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 50,	Hidden : 1} 
   			, {Align : "Center",SaveName : "REQ_USER_ID",		Header : "담당자ID",	Type : "Text",	Width : 150,	EditLen : 100,Hidden:false, Edit : false}
   			, {Align : "Center",SaveName : "REQ_USER_NAME",		Header : "담당자",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false}
		];
	
	IBS_InitSheet2(mySheet, initsheet,pagingMode,"0");

	//하이퍼링크 설정
	setLinkCol(mySheet, "REQ_USER_NAME");
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqReqUserSelPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqReqUserSelPop.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
	}

}
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	if(mySheet.RowCount() <= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqReqUserSelPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "REQ_USER_NAME" ){ 
			kepConfirm();
	}
	return;
}


//확인
  function kepConfirm()
  { 
		var value1 = mySheet.GetCellValue(grbRow,"REQ_USER_ID");
		var value2 = mySheet.GetCellValue(grbRow,"REQ_USER_NAME");
		
		opener.setPopupReturn(value1,value2);
		this.close();
  }
   
</script>
<title>코리아 e 플랫폼</title>
</head>

<body onload="kep_onload_view();">
<!--조회영역-->
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="${param.st_buyer}">	
	<input type="hidden" id="st_item_group"  name="st_item_group" value="${param.st_item_group}">	
	<input type="hidden" id="st_kep_dept"  name="st_kep_dept" value="${param.st_kep_dept}">	
	<input type="hidden" id="st_agent_min_price"  name="st_agent_min_price" value="${param.st_agent_min_price}">	

	<!-- 500*350 -->
	<div id="popWrapper" style="height:352px;">
    	<div id="popHeader">
        	<h1 class="title">담당자 선택</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
		<!--팝업내용입니다-->
        <div id="popContainer">
        	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "250px");
				</script>
			</div>
			<div id="pageindex"></div>
		</div>
    </div>
					
	</form>
		
</body>
</html>
