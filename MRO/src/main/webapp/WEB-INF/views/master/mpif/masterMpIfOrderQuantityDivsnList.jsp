<%--
**********************************************
* 메뉴 : I/F 관리>대우조선>발주수량 분할
* 화면 : 발주수량 분할
* 기능 : 
* 프로그램 ID : PG_11_M_004_01
* 담당자 : 개발5 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",			SaveName:"sStatus"}
					,{ Align:"Center",		Width:60,		Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",					SaveName:"SELECTED"}
					,{ Align:"Center",		Width:80,		Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"년도",			SaveName:"YEAR"}
					,{ Align:"Center",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"상태",			SaveName:"STATUS"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"발주번호",		SaveName:"LEGACY_PO_NO"}
					,{ Align:"Center",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"발주항번",		SaveName:"LEGACY_PO_SEQ"}
					,{ Align:"Left",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"관리번호",		SaveName:"REF_IF_NO"}
					,{ Align:"Left",		Width:120,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"품목코드",		SaveName:"BUYER_ITEM_NO"}
					,{ Align:"Right",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Flaot",				Header:"수량",			SaveName:"ITEM_QTY"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"등록일",			SaveName:"ADD_DATE"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"납품요구일",	SaveName:"RD_DATE"}
					,{ Align:"Center",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"협력사합계",		SaveName:"AGNET_CNT"}
					,{ Align:"Center",		Width:300,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"에러내역",		SaveName:"ERROR_MSG"}
					,{ Align:"Center",		Width:300,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"분할수량",		SaveName:"DIVIDE_ITEM_QTY"}
					,{ Align:"Center",		Width:300,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"회원사코드",	SaveName:"BUYER"}

	];

	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	var initsheet2 = {};
	initsheet2.Cols = [ 
					 { Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",			SaveName:"sStatus"}
					,{ Align:"Center",		Width:60,		Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",					SaveName:"SELECTED"}
					,{ Align:"Center",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"상태",			SaveName:"STATUS"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"발주번호",		SaveName:"LEGACY_PO_NO"}
					,{ Align:"Center",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"발주항번",		SaveName:"LEGACY_PO_SEQ"}
					,{ Align:"Center",		Width:120,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"품목코드",		SaveName:"BUYER_ITEM_NO"}
					,{ Align:"Left",		Width:260,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"품목명",			SaveName:"DESCRIPTION"}
					,{ Align:"Left",		Width:120,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"규격",			SaveName:"SPECIFICATION"}
					,{ Align:"Center",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"단위",			SaveName:"UNIT_MEASURE"}
					,{ Align:"Left",		Width:260,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"제조사",			SaveName:"MAKER_NAME"}
					,{ Align:"Right",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Flaot",				Header:"주문수량",		SaveName:"ITEM_QTY"}
					,{ Align:"Right",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Flaot",				Header:"주문단가",		SaveName:"ORDER_UNIT_PRICE"}
					,{ Align:"Right",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Flaot",				Header:"판매단가",		SaveName:"SALE_UNIT_PRICE"}
					,{ Align:"Left",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"비고",			SaveName:"REMARK"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"등록일",			SaveName:"ADD_DATE"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"납품요구일",	SaveName:"RD_DATE"}

	];
	
	IBS_InitSheet(mySheet2, initsheet2, pagingMode);
	setLinkCol(mySheet, "AGNET_CNT");
	
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
				current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpif/getMasterMpIfOrderQuantityDivsnList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
				mySheet.RemoveAll();
			break;
	
		case "save": // 저장
			if (checkSubmit()) {
				kepSave(document.searchCondition ,  mySheet , "/mpif/saveMasterMpIfOrderQuantityDivsnList.do" , "SELECTED" );
			}
			break;
			
		case "del": // 취소
			if (confirm('선택한 항목을 삭제 하시겠습니까?')) {
				kepSave(document.searchCondition ,  mySheet , "/mpif/delMasterMpIfOrderQuantityDivsnList.do" , "SELECTED" );
			}
			break;
	
		case "excelDown": // 엑셀다운로드
		    $("#pageflag").val('0');
		    var param = {FileName:"대우조선 발주수량 분할.xlsx",Merge:1,SheetDesign:1,DownCols:"STATUS|LEGACY_PO_NO|LEGACY_PO_SEQ|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|MAKER_NAME|ITEM_QTY|ORDER_UNIT_PRICE|SALE_UNIT_PRICE|REMARK|ADD_DATE|RD_DATE"};
			kepDownExcel(document.searchCondition, mySheet2, "/mpif/excelMasterMpIfOrderQuantityDivsnList.do", param);
			$("#pageflag").val('1');
			break;
	}
}

function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

}	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	
   	
	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet , "/mpif/getMasterMpIfOrderQuantityDivsnList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "mpifDivsn": // 고객사 M
			openSearchPopup("/mpif/showMasterMpIfDivsnPop.do", "?buyer=" + mySheet.GetCellValue(grbRow, "BUYER") + "&legacy_po_no=" + mySheet.GetCellValue(grbRow, "LEGACY_PO_NO") + "&legacy_po_seq=" + mySheet.GetCellValue(grbRow, "LEGACY_PO_SEQ") + "&buyer_item_no=" + mySheet.GetCellValue(grbRow, "BUYER_ITEM_NO"), "900,420,no");
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'AGNET_CNT') { // 요청자
		doPop("mpifDivsn");
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {

	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "mpifDivsn") {	// 다중 고객사
		kepSearch(document.searchCondition , mySheet , "/mpif/getMasterMpIfOrderQuantityDivsnList.do?page="+current_page , pagingMode );
	}
	grbRow="";	//초기화
}

function checkSubmit() {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	
	for (var i = 0; i <  arrRow.length; i++) {

		if (mySheet.GetCellValue(arrRow[i], "STATUS") != "신규") {
			 alert( arrRow[i] + "번째 줄 요청항목의 상태가 신규가 아닙니다.\n\n상태가 신규일 경우만 발주 가능합니다.");
			 return false;
		}
		
		if (mySheet.GetCellValue(arrRow[i], "DIVIDE_ITEM_QTY") != mySheet.GetCellValue(arrRow[i], "ITEM_QTY")) {
			 alert( arrRow[i] + "번째 줄 요청항목의 수량과 분할수량이 일치하지 않습니다.");
			 return false;
		}
	}

	return confirm("선택하신 항목으로 발주생성 하시겠습니까?");
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>발주수량 분할</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
				</select>
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  					createIBSheet("mySheet2", "100%", "0px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
  					<span class="btn_05 mr04" ><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  				
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('save');">발주</a></span>
  					<span class="btn_02"><a href="javascript:doAction('del');">삭제</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
