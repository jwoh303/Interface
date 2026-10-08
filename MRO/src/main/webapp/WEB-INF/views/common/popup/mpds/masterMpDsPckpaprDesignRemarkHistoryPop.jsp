<%--
**********************************************
* 메뉴 : 팝업 (포장지 도안관리 상세(작물보호) > KEP 클릭시
* 화면 : 포장지 도안 수정 현황
* 기능 : 도안관리 변경내역을 조회할 수 있다.
* 프로그램 ID : PG_07_M_003_05 
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-06-05
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
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",				Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "SELECTED",			Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:1},
	    			{Align : "Center",SaveName : "SEQ",			Header : "순서",	Type : "text",	Width : 40,	EditLen : 50,Hidden:false},
	    			{Align : "Center",SaveName : "CHANGE_DATE",		Header : "변경일시",	Type : "Date", Format:"YmdHm",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "USER_NAME_LOC",		Header : "변경자",	Type : "Text",	Width : 90, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "REQ_USER_NAME",		Header : "요청자",	Type : "Text",	Width : 90, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "REQ_USER_REMARK",		Header : "요청사유",	Type : "Text",	Width : 150, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "RE_REMARK",		Header : "기존비고",	Type : "Text",	Width : 150, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "CH_REMARK",		Header : "변경비고",	Type : "Text",	Width : 150, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "REMARK_IMG",		Header : "비고",	Type : "Image",	Width : 80, EditLen : 110,	Edit : false, Hidden : false}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);

	
	//하이퍼링크 설정
	setLinkCol(mySheet, "REMARK_IMG");
	
	kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsPckpaprDesignRemarkHistoryPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsPckpaprDesignRemarkHistoryPop.do" , pagingMode );
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
	kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsPckpaprDesignRemarkHistoryPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "BUYER_NAME" ){ 
			kepConfirm();
	} else if (column == "REMARK_IMG" ){ // 비고
		popupSel = "remarkHistory";
		var re_remark = mySheet.GetCellValue(Row, "RE_REMARK");
		var ch_remark = mySheet.GetCellValue(Row, "CH_REMARK");
		openSearchPopup('/common/remarkHistoryPop.do','?st_re_remark='+re_remark+'&st_ch_remark='+ch_remark,'500,230,no');// 비고
	}
	
	return;
}


//확인
function kepConfirm()
{ 
 var value1 = mySheet.GetCellValue(grbRow, "BUYER")+"@";
 var value2 = mySheet.GetCellValue(grbRow, "BUYER_NAME");
 
 opener.setPopupReturn(value1,value2);
 
 this.close();
}
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">

	<input type="hidden" id="st_dept"  name="st_dept" value="${param.st_dept}">
	<input type="hidden" id="st_plant"  name="st_plant" value="${param.st_plant}">
	<input type="hidden" id="st_byca_comorg_code"  name="st_byca_comorg_code" value="${param.st_byca_comorg_code}">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="${param.st_buyer}">
	<input type="hidden" id="st_opkg_seq"  name="st_opkg_seq" value="${param.st_opkg_seq}">
	<input type="hidden" id="st_rd_date"  name="st_rd_date" value="${param.st_rd_date}">
	<input type="hidden" id="st_buyer_item_no"  name="st_buyer_item_no" value="${param.st_buyer_item_no}">

	<div id="popWrapper" style="height:206px;">
    	<div id="popHeader">
        	<h1 class="title">포장지 도안 수정 현황</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->

            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "100%", "130px");
				</script>
			</div>
			<div id="pageindex"></div>
		</div>	
        
    </div>
</form> 
</body>
</html>
