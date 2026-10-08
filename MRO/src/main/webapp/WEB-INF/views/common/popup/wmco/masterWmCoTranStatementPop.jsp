<%--
**********************************************
* 메뉴 : 
* 화면 : 거래명세서
* 기능 : 
* 프로그램 ID : PG_08_M_900_14
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-6-23
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
<script src="/resources/js/wms_tr_sheet.js"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var print="/resources/images/icon_print.gif";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	    			{Align : "Left",SaveName : "BUYER_NAME",		Header : "고객사",	Type : "Text",	Width : 120,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "PO_NO",		Header : "발주번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "S_INV_NO",		Header : "입고번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "INV_NO",		Header : "송장번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "CNT_ITEM",		Header : "품목수",	Type : "Int", Format:"${qtyFormat}", 	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "PRINT_YN",		Header : "출력",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "SLG_ID",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "DEPTCD",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "LEGACY_PO_NO",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "DOC_TYPE",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "BUYER",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "CAR_ID",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true}
	    			
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "PRINT_YN");
	kepSearch(document.searchCondition ,  mySheet , "/wmco/getMasterWmCoTranStatementPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmco/getMasterWmCoTranStatementPop.do" , pagingMode );
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
	
}

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmco/getMasterWmCoTranStatementPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "PRINT_YN" ){ 
		var st_warehouse_code = document.searchCondition.st_warehouse_code.value;
		var st_user_id = document.searchCondition.st_user_id.value;
	
		if("P08-0000011-23"==mySheet.GetCellValue(Row, "SLG_ID") ){
			//화승 네트워크인 경우에는 부서를 조회

			setWmsTrSheet(mySheet.GetCellValue(Row, "SLG_ID"),mySheet.GetCellValue(Row, "CAR_ID") ,mySheet.GetCellValue(Row, "DEPTCD"),st_warehouse_code, mySheet.GetCellValue(Row, "BUYER"), mySheet.GetCellValue(Row, "INV_NO"), st_user_id ,mySheet.GetCellValue(Row, "LEGACY_PO_NO"),'','',mySheet.GetCellValue(Row, "DOC_TYPE"));
			
		}else{
			setWmsTrSheet(mySheet.GetCellValue(Row, "SLG_ID"),mySheet.GetCellValue(Row, "CAR_ID"),"",st_warehouse_code, mySheet.GetCellValue(Row, "BUYER"), mySheet.GetCellValue(Row, "INV_NO"), st_user_id ,mySheet.GetCellValue(Row, "LEGACY_PO_NO"),'','', mySheet.GetCellValue(Row, "DOC_TYPE"));
		}
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
	<input type="hidden" id="st_warehouse_code"  name="st_warehouse_code" value="<%=CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"") %>">
	<input type="hidden" id="st_ivk_list"  name="st_ivk_list" value="<%=CommonUtil.nvl((String) request.getParameter("st_ivk_list"),"") %>">
	<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
	
	
	<div id="popWrapper" style="height:400px;">
    	<div id="popHeader">
        	<h1 class="title">거래명세서출력</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:325px;"> 
        	<!--버튼영역-->
            <!--조회영역-->
            <!--grid-->
 			<div style="border-top:2px solid #3c639c;height:300px;">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "300px");
				</script>
			</div>
		</div>	
        <!--버튼영역-->
        <br/><br/>
    </div>
</form> 
</body>
</html>
