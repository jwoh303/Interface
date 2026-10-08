<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사최종단가합의 건수 
* 기능 : 
* 프로그램 ID : PG_04_M_010_01
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-07-28
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
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:false}, 
	    			{Align : "Center",SaveName : "BUYER",		Header : "고객사",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:true, Edit : false},
	    			{Align : "Left",SaveName : "BUYER_NAME",		Header : "고객사명",	Type : "Text",	Width : 250, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "CNT",		Header : "최종단가합의건수",	Type : "Text",	Width : 120,	EditLen : 110,	Edit : false}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NAME");
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqBuyerFinalUnitpriceAgrmntCntPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqBuyerFinalUnitpriceAgrmntCntPop.do" , pagingMode );
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

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	if (column == "BUYER_NAME" ){ 
		opener.setPopupReturn(mySheet.GetCellValue(Row,"BUYER"),mySheet.GetCellValue(Row,"BUYER_NAME"));
		this.close();
	}
	return;
}


//확인
function kepConfirm()
{ 
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	
	if (selectedGrid.length == 0){
		alert("고객사를 선택하여 주십시오.");
		return;
	}
	var arrRow     = selectedGrid.split("|");

	var tmptmp1 = "";
	var tmptmp2 = "";
	
	//선택된 항목 유무 체크
	if (arrRow.length == 1){
		tmptmp1 = mySheet.GetCellValue(arrRow[0],"BUYER");
		tmptmp2 = mySheet.GetCellValue(arrRow[0],"BUYER_NAME");
	} else if (arrRow.length >=2) {
		for (var i=0; i<arrRow.length; i++){
			tmptmp1 = tmptmp1 + mySheet.GetCellValue(arrRow[i],"BUYER") + "@";
			tmptmp2 = tmptmp2 + mySheet.GetCellValue(arrRow[i],"BUYER_NAME") + "@";
		}
	}
	opener.setPopupReturn(tmptmp1,tmptmp2);
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
	<input type="hidden" id="USR_ID"  name="USR_ID" value="${sessionInfo.userId}">	

	<!-- 500*350 -->
	<div id="popWrapper" style="height:352px;">
    	<div id="popHeader">
        	<h1 class="title">고객사최종단가합의 건수 </h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
		<!--팝업내용입니다-->
        <div id="popContainer" style="height:272px;">
        	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "240px");
				</script>
			</div>
			<!--버튼영역-->
	        <div class="mr25 mt05" style="height:25px;">
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:kepConfirm()">확인</a></span>
				</span>
	        </div>
		</div>
    </div>
					
	</form>
		
</body>
</html>
