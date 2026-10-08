<%--
**********************************************
* 메뉴 : 견적관리 > 신규상품규격의뢰 > 상품상태 선택
* 화면 : 계약서조회
* 기능 : 계약서조회팝업
* 프로그램 ID : PG_04_M_001_02
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-05-13
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1},
	    			{Align : "Center",SaveName : "CONTRACT_NO",		Header : "계약서번호",	Type : "Text",	Width : 90,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "CONTRACT_SEQ",		Header : "계약서순번",	Type : "Text",	Width : 65,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 90, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 150, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "ORIGIN_NAME",		Header : "원산지",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "AGENT_NAME",		Header : "협력사",	Type : "Text",	Width : 90, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "BELOW_COMORG_NAME",		Header : "사업장",	Type : "Text",	Width : 60, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "UNIT_PRICE",		Header : "매출단가",	Type : "Float",	Format:"${priceFormat}", Width : 80,	EditLen : 110,	Edit : false},
	    			{Align : "Right",SaveName : "LIST_PRICE",		Header : "매입단가",	Type : "Float",	Format:"${priceFormat}", Width : 80,	EditLen : 110,	Edit : false},
	    			{Align : "Right",SaveName : "PRICE_RATE",		Header : "매익률",	Type:"Text",	 Width : 80,	EditLen : 110,	Edit : false},
	    			{Align : "Center",SaveName : "UNIT_MEASURE",		Header : "UNIT_MEASURE",	Type : "Text",	Width : 90, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "MAKER_CODE",		Header : "MAKER_CODE",	Type : "Text",	Width : 90, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "ORIGIN_CODE",		Header : "MAKER_CODE",	Type : "Text",	Width : 90, EditLen : 110,	Edit : false, Hidden : true}
	];
	
	IBS_InitSheet2(mySheet, initsheet,pagingMode,"4");

	//하이퍼링크 설정
	setLinkCol(mySheet, "CONTRACT_NO");
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqContractLisPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqContractLisPop.do" , pagingMode );
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
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqContractLisPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "CONTRACT_NO" ){ 
			kepConfirm();
	}
	return;
}


//확인
function kepConfirm()
{ 
	var value1 = mySheet.GetCellValue(grbRow, "CONTRACT_NO");
	var value2 = mySheet.GetCellValue(grbRow, "CONTRACT_SEQ");
 	var value3 = mySheet.GetCellValue(grbRow, "DESCRIPTION");
 	var value4 = mySheet.GetCellValue(grbRow, "SPECIFICATION");
 	var value5 = mySheet.GetCellValue(grbRow, "UNIT_MEASURE");
 	var value6 = mySheet.GetCellValue(grbRow, "MAKER_CODE");
 	var value7 = mySheet.GetCellValue(grbRow, "MAKER_NAME");
 	var value8 = mySheet.GetCellValue(grbRow, "ORIGIN_CODE");
 	var value9 = mySheet.GetCellValue(grbRow, "ORIGIN_NAME");
 	opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7, value8, value9);
 
 this.close();
}
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="${param.st_buyer}">
	<input type="hidden" id="st_buyer_item_no"  name="st_buyer_item_no" value="${param.st_buyer_item_no}">
	
	<div id="popWrapper" style="height:294px;">
    	<div id="popHeader">
        	<h1 class="title">계약서조회</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "210px");
				</script>
			</div>
			<div id="pageindex"></div>
		</div>	
    </div>
</form> 
</body>
</html>
