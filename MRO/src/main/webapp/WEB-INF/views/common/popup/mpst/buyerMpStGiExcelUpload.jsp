<%--
**********************************************
* 메뉴 : 재고관리>출고진행조회>출고업로드 팝업
* 화면 : 출고 업로드 팝업
* 기능 : 엑셀파일과 그리드를 이용하여 출고 업로드
* 프로그램 ID :
* 담당자 : CCK
* 착수일 : 2021-01-05
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/smoothness/jquery-ui.min.css"/>   
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var maxAllowRow = 100;	// 엑셀업로드 허용할 데이터 Row수

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
	                  {Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus"},
	                  {Align:"Center",	Width:50,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",			SaveName:"SELECTED"},
	                  {Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"",		SaveName:""},
	                  {Align:"Left",	Width:144,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품목코드",		SaveName:"BUYER_ITEM_NO"},
	                  {Align:"Right",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"출고수량",		SaveName:"IV_QTY"},
	                  {Align:"Right",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"차량번호",		SaveName:"CAR_NO"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	
}

// 기능함수
function doAction(str) {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	
	// 선택된 항목 유무 체크
	if (str =="setGi" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {			
		case "loadExcel": // 파일 업로드
			mySheet.RemoveAll();
			var params = { Mode : "NoHeader", StartRow: "2", ColumnMapping:"|||1|5|6|"};
			mySheet.LoadExcel(params);
			break;
			
		case "setGi": // 출고
			setGi();
			break;
	}
}

function setGi(){
	
	for(var i=1; i<=mySheet.RowCount(); i++){
		if(mySheet.GetCellValue(i, "SELECTED") == 1){
			var buyer_item_no = mySheet.GetCellValue(i, "BUYER_ITEM_NO");
			var iv_qty = mySheet.GetCellValue(i, "IV_QTY");
			var car_no = mySheet.GetCellValue(i, "CAR_NO");

			//공백체크하기
			if(buyer_item_no == ""){
				alert(i+"번째 품목코드를 입력하시기 바랍니다.");
				return;
			}
			if(iv_qty == ""){
				alert(i+"번째 출고수량을 입력하시기 바랍니다.");
				return;
			}
			if(car_no == ""){
				alert(i+"번째 차량번호를 입력하시기 바랍니다.");
				return;
			}
			
			//출고수량과 차량번호 숫자형식 체크하기(소수점x , 숫자 외 다른 문자x)
			if(!kepChkDecimal(iv_qty,0)){
				alert(i+"번째 출고수량을 숫자 형식으로 입력하시기 바랍니다.");
				return;
			}
			if(!kepChkDecimal(car_no,0)){
				alert(i+"번째 차량번호를 숫자 형식으로 입력하시기 바랍니다.");
				return;
			}
		}
	}
	if (!confirm('선택한 항목을 출고하시겠습니까?')){
		return;
	}
	kepSave(document.searchCondition ,  mySheet , "/mpst/setBuyerMpStGiAdd.do" , "SELECTED" );
	
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

//엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {
	loader_obj("N");
	var maxRowCount = maxAllowRow + 1;
	
	if(mySheet.RowCount() == 0){
		alert("일괄 업로드를 실패하였습니다. 관리자에게 문의바랍니다.");
	}else{
		if(maxRowCount < mySheet.RowCount() + 1) {
			//건 이하의 파일만 업로드하여 주세요.
			alert(maxAllowRow + "건 이하의 파일만 업로드하여 주세요.");
			mySheet.RemoveAll();
			return;
		}
	}
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
	
	if(code>0){
		//출고 정상 처리시 화면 닫기
		self.close();
	}
}

</script>
</head>
<body onload="kep_onload_view()">
	<div id="popWrapper" style="height: 500px;">
		<div id="popHeader">
			<h1 class="title">출고 업로드</h1>
			<p class="popClose">
				<a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a>
			</p>
		</div>
		<!--내용 시작-->
		<div id="popContainer" style="height: 400px">  	
	   		<form name = "searchCondition" method = "post">
		   		<input type="hidden" name="s_SAVENAME">
		   		<input type="hidden" id="st_buyer" name="st_buyer"  value="${sessionInfo.comCode}">
	    		<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
	    		
	    		<!--grid-->
   				<div class="ib_product" style="border-top:2px solid #3c639c">
	  				<script type="text/javascript">
	  					createIBSheet("mySheet", "100%", "400px");
	  				</script>
  				</div>
	  			<br>
  				<!--버튼영역-->
				<div class="btnArea">
					<span class="fl">
	 					<span class="btn_05 mr04"><a href="javascript:doAction('loadExcel');">엑셀업로드</a></span>
	 				</span>
	 	          	<span class="fr">
	 	          		<span class="btn_03 mr04"><a href="javascript:doAction('setGi');">출고</a></span>
	 				</span> 
	 			 </div>
			</form>
		</div>
	</div>
</body>
</html>