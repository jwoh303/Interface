<%--
**********************************************
* 메뉴 : Lot 정보입력
* 화면 : Lot 정보입력
* 기능 : 
* 프로그램 ID :
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	String st_lot_info = CommonUtil.nvl((String)request.getParameter("st_lot_info"),"");
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Lot 정보입력</title>
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
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	initsheet.Cols = [
		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태",		SaveName:"sStatus"}
		,{ Align:"Center",	Width:60,	Edit : true,	EditLen:0,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
		,{ Align:"left",	Width:150,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"Lot No",	SaveName:"LOT_NO", BackColor:"${notnullColor}"}
		,{ Align:"right",	Width:80,		Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"Lot QTY",		SaveName:"LOT_QTY", BackColor:"${notnullColor}"}
		,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"Prd Date",	SaveName:"PRD_DATE", BackColor:"${notnullColor}"}
	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	var st_lot_info = "<%=st_lot_info%>";
	if(st_lot_info == ""){
		var rowCnt = mySheet.RowCount();
		for ( var i = rowCnt + 1; i <= 5; i++ ) {
			var rows = mySheet.DataInsert(-1);
			mySheet.SetCellValue(rows, "sStatus", "R");
		}
	}else{
		var st_query = st_lot_info.split("@@");
		for(var j = 0; j < st_query.length-1; j++){
			var arr_lot = st_query[j].split('__');
			var rows = mySheet.DataInsert(-1);
			mySheet.SetCellValue(rows, "sStatus", "R");
			mySheet.SetCellValue(rows, "LOT_NO", arr_lot[0]);
			mySheet.SetCellValue(rows, "LOT_QTY", arr_lot[1]);
			mySheet.SetCellValue(rows, "PRD_DATE", arr_lot[2]);
		}
	}
}

var st;
var mt;

// 그리드 표시후 처리
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	// 선택된 항목 유무 체크
	if (selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	switch (str) {
		case "search": //조회
			break;
		case "deleteRows": // 행삭제
			mySheet.RowDelete(selectedGrid, 1);	
			break;
		case "save": // 수정
			var lot_info = "";
	 	 	for(var i = 0 ; i <arrRow.length; i++){
	 	 		var st_lot_no = mySheet.GetCellValue(arrRow[i],"LOT_NO");
	 	 		var st_lot_qty = mySheet.GetCellValue(arrRow[i],"LOT_QTY");
	 	 		var st_prd_date = mySheet.GetCellValue(arrRow[i],"PRD_DATE");
	 	 		if(st_lot_no == ""){
	 	 			alert(arrRow[i]+"번째 Lot No 입력바랍니다.");
	 	 			return;
	 	 		}
	 	 		if(st_lot_qty == ""){
	 	 			alert(arrRow[i]+"번째 Lot Qty 입력바랍니다.");
	 	 			return;
	 	 		}
	 	 		if(st_prd_date == ""){
	 	 			alert(arrRow[i]+"번째 Prd Date 입력바랍니다.");
	 	 			return;
	 	 		}
	 	 		lot_info += st_lot_no+"__"+st_lot_qty+"__"+ st_prd_date+"@@";
	 	 	}
	 	 	opener.setPopupReturn(lot_info);
	 	 	this.close();
			break;
	}

}
//TABLE의 ROW 데이타 생성
function addrows() {
	mySheet.DataInsert(-1);
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	if (msg != "") {
		alert(msg);
	}
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg);
	}

}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	
	grbRow = Row;
	
	return;
}

</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	
	<div id="popWrapper" style="height:250px;">
    	<div id="popHeader">
        	<h1 class="title">Lot 정보입력</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <div id="searchBtnA02"></div>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "180px");
				</script>
			</div>
		</div>	
    </div>
  		<div class="btnArea mr25">
			<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:addrows();">행추가</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('deleteRows');">행삭제</a></span>
				<span class="btn_02"><a href="javascript:doAction('save');">등록</a></span>
			</span>
		</div>
</form> 
</body>
</html>
