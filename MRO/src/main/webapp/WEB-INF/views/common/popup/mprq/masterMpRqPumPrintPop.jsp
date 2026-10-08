<%--
**********************************************
* 메뉴 : 견적관리 > 견적진행조회
* 화면 : 품의서 출력 
* 기능 : 
* 프로그램 ID : PG_04_M_009_02
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-07-21
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
	    			{Align : "Center",SaveName : "QUOTATION_NO",		Header : "견적번호",	Type : "Text",	Width : 200,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "QUOTATION_SEQ",		Header : "견적항번",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false}
	];
	
	IBS_InitSheet2(mySheet, initsheet,pagingMode,0);
	mySheet.SetCountPosition(4);

	//하이퍼링크 설정
	setLinkCol(mySheet, "QUOTATION_NO");
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getPumPrintPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqQuotationPrintPop.do" , pagingMode );
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
	
	grbRow = Row;
// 	var quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
	var quotation_seq = "";
	
	if (column == "QUOTATION_NO" ){ 
		doos_print_all(quotation_seq);
	}
	return;
}


//확인
  function kepConfirm()
  { 
	  var checkRows = mySheet.FindCheckedRow("SELECTED");
		if (checkRows.length == 0){
			alert("견적항번을 선택하여 주십시요.");
			return;
		}
		var arrRow = checkRows.split("|");
		var quotation_seq = "";
		var initValue = 1;
		
		if (arrRow.length == 1){
// 			quotation_seq = "'" + mySheet.GetCellValue(arrRow[idx], "QUOTATION_SEQ") + "'";
			quotation_seq = mySheet.GetCellValue(arrRow[0], "QUOTATION_SEQ") + "@@";
			doos_print_all(quotation_seq);
			return;
		} else {
			for(var idx=0; idx<arrRow.length; idx++){
				if (initValue == 1){
// 					quotation_seq = "'" + mySheet.GetCellValue(arrRow[idx], "QUOTATION_SEQ") + "',";
					quotation_seq = mySheet.GetCellValue(arrRow[idx], "QUOTATION_SEQ") + "@@";
				} else if (initValue > 1 && initValue < arrRow.length){
// 					quotation_seq = "'" + mySheet.GetCellValue(arrRow[idx], "QUOTATION_SEQ") + "',";
					quotation_seq = quotation_seq + mySheet.GetCellValue(arrRow[idx], "QUOTATION_SEQ") + "@@";
				} else if (initValue == arrRow.length){
// 					quotation_seq = "'" + mySheet.GetCellValue(arrRow[idx], "QUOTATION_SEQ") + "'";
					quotation_seq = quotation_seq + mySheet.GetCellValue(arrRow[idx], "QUOTATION_SEQ") + "@@";
				}
				initValue++;
			}
			doos_print_all(quotation_seq);
		}
  }

   function doos_print_all(quotation_seq){
	    var agent = "${param.st_agent}";
		var user_id = "${sessionInfo.userId}";
		var buyer = "${param.st_buyer}";
		var quotation_no = "${param.st_quotation_no}";
		var revision = "${param.st_revision}";
		
	   if ("${sessionInfo.userId}" == 'KEP200013'){
			fileName = "RD_04_B_006_04";
//			dmt_sourcing_print
//st_buyer="+buyer+"&st_quotation_no="+quotation_no+"&st_revision="+revision+"&st_user_id="+user_id+"&st_quotation_seq="+quotation_seq+"&st_agent_code="+agent
			
		} else {
			fileName = "RD_04_M_004_06";
//			sysop_proxbuy_sourcing_print_doos_ago
//st_buyer="+buyer+"&st_quotation_no="+quotation_no+"&st_revision="+revision+"&st_user_id="+user_id+"&st_quotation_seq="+quotation_seq+"&st_agent_code="+agent
		}
		var param =  "["+buyer+"]["+quotation_no+"]["+revision+"]["+user_id+"]["+quotation_seq+"]["+agent+"]";
		reportOpen(fileName,param);
		return;	
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
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">	
	<input type="hidden" id="st_buyer"  name="st_buyer" value="${param.st_buyer}">	
	<input type="hidden" id="st_quotation_no"  name="st_quotation_no" value="${param.st_quotation_no}">	
	<input type="hidden" id="st_revision"  name="st_revision" value="${param.st_revision}">

	<!-- 500*350 -->
	<div id="popWrapper" style="height:390px;">
    	<div id="popHeader">
        	<h1 class="title">품의서 출력 </h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
		<!--팝업내용입니다-->
        <div id="popContainer">
        	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "285px");
				</script>
			</div>
		</div>
		
		<!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
				<span class="btn_04 mr04"><a href="javascript:kepConfirm()">선택항번 출력</a></span>
			</span>
        </div>
    </div>
					
	</form>
		
</body>
</html>
