<%--
**********************************************
* 메뉴 : 재계약 접수
* 화면 : 재계약 접수
* 기능 : 
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var productGbn = KepSheetComboData("CC01","SEL");
var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};
var productGbn2 = KepSheetComboData("M074","SEL");
var comboInfo2 = {ComboCode: productGbn2.ComboCode, ComboText:productGbn2.ComboText};

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 2};
	initsheet.Cols = [
					{ Align:"Center",	SaveName:"sStatus",						Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELECTED",					Header:"",					Type:"DummyCheck",	Width:30,	Edit:true,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"BUYER_NM",					Header:"고객사",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"REVISION",					Header:"차수",				Type:"Text",		Width:40,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"DESCRIPTION_LOC",				Header:"품명",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"SPECIFICATION",				Header:"규격",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"UNIT_MEASURE",				Header:"단위",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Right",	SaveName:"STOA_LIST_PRICE",				Header:"제출단가\n(VAT별도)",	Type:"Float",		Width:80,	Edit:true,	EditLen:100,	Hidden:false,	BackColor:"${optColor}",	KeyField:true,	Format:"${priceFormat}"}
					,{ Align:"Center",	SaveName:"LIST_PRICE_CHANGE_REASON",	Header:"매입단가\n변동사유",		Type:"Combo",		Width:110,	Edit:false,	EditLen:20,		Hidden:false,	BackColor:"${optColor}"}
					,{ Align:"Center",	SaveName:"STOA_CLOSE_DATE",				Header:"제출\n계약종료일",		Type:"Date",		Width:90,	Edit:true,	EditLen:110,	Hidden:false,	BackColor:"${optColor}",	Sort:0,	KeyField:true}
					,{ Align:"Left",	SaveName:"MAKER_NAME",					Header:"제조사",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"ORIGIN_NM",					Header:"원산지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"MAKER_PART_NO",				Header:"모델번호",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"ATOB_DATE",					Header:"재계약\마감일",			Type:"Date",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"CLOSE_DATE",					Header:"계약종료일",			Type:"Date",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Right",	SaveName:"MIN_ORDER_QTY",				Header:"MOQ",				Type:"Int",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Right",	SaveName:"PUR_UNIT_QTY",				Header:"발주배수",				Type:"Int",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"USER_NM",						Header:"KeP담당자",			Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"USER_PHONE_NUMBER",			Header:"담당자연락처",			Type:"Text",		Width:90,	Edit:true,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"ATOS_DATE",					Header:"요청일",				Type:"Date",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"RC_NO",						Header:"요청번호",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"RC_SEQ",						Header:"요청순번",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",				Header:"품목코드",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"A_NOTE",						Header:"운영사비고",			Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"S_NOTE",						Header:"협력사비고",			Type:"Text",		Width:180,	Edit:true,	EditLen:100,	Hidden:false,	BackColor:"${optColor}",	Sort:0}
					,{ Align:"Left",	SaveName:"CLOSE_STATUS_CODE",			Header:"포기사유",				Type:"Combo",		Width:80,	Edit:true,	EditLen:100,	Hidden:false,	BackColor:"${optColor}",	Sort:0}
					,{ Align:"Center",	SaveName:"BUYER",						Header:"BUYER",				Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
					,{ Align:"Center",	SaveName:"AGENT",						Header:"AGENT",				Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
					,{ Align:"Center",	SaveName:"RATE_GUBUN",					Header:"RATE_GUBUN",		Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
					,{ Align:"Center",	SaveName:"RATE",						Header:"RATE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
					,{ Align:"Center",	SaveName:"PRICE_RATE",					Header:"PRICE_RATE",		Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
					,{ Align:"Right",	SaveName:"UNIT_PRICE",					Header:"UNIT_PRICE",		Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",			Header:"BYIT_COMORG_CODE",	Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}

	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "REVISION");
	mySheet.SetCellFontUnderline(0, "STOA_CLOSE_DATE", true);	
	mySheet.SetCellFontUnderline(0, "S_NOTE", true);
	mySheet.SetCellFontUnderline(0, "CLOSE_STATUS_CODE", true);
	mySheet.SetColProperty("CLOSE_STATUS_CODE", comboInfo);
	mySheet.SetColProperty("LIST_PRICE_CHANGE_REASON", comboInfo2);
	
	doAction('search');
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str != "search" && str != "reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mpcl/getSellerMpClCatalogRecharterList.do" , pagingMode);
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case "submit": //재계약 제출
			submitData();
			break;
		case "reject": //재계약 포기
			agentHandout();
			break;
	}
}
//재계약 제출
function submitData(){ 
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	for(var idx=0; idx<arrRow.length; idx++){
		//제출 매입단가 필수값 체크
		var st_list_price = mySheet.GetCellValue(arrRow[idx], "STOA_LIST_PRICE");
		if(kepIsValueNull(st_list_price)) {
			 alert("제출 단가를 입력하여 주십시요.");
			 mySheet.SelectCell(arrRow[idx], "STOA_LIST_PRICE");
                return;
		}
		//제출 계약종료일 필수값 체크
		var st_list_price = mySheet.GetCellValue(arrRow[idx], "STOA_CLOSE_DATE");
		if(kepIsValueNull(st_list_price)) {
			 alert("제출 계약종료일 입력하여 주십시요.");
			 mySheet.SelectCell(arrRow[idx], "STOA_CLOSE_DATE");
                return;
		}
		//고객사별 매출단가 계산 수식.
		var st_buyer = mySheet.GetCellValue(arrRow[idx], "BUYER");
		var st_rate_gubun = mySheet.GetCellValue(arrRow[idx], "RATE_GUBUN");
		var st_margin_rate = mySheet.GetCellValue(arrRow[idx], "RATE");
		var st_list_price = mySheet.GetCellValue(arrRow[idx], "STOA_LIST_PRICE");
		var st_price = "";
		var b_margin_rate = 1+(st_margin_rate/100);
		if (st_rate_gubun == "B") { // 매입가 기준
			if(st_buyer =="KRSAMS0123"||st_buyer =="KRSAMS0192"){// 삼성  금액별 계산방법
				   st_price =  kepGetRound2(st_list_price * b_margin_rate,1);//소수점 반올림
			}else{//고객사 전용 수식 없을 경우
				st_price = kepGetRound2(st_list_price * b_margin_rate,1);
			}
		}else{ // S = 매출가 기준
			if(st_buyer =="KRSAMS0123"||st_buyer =="KRSAMS0192"){// 삼성  금액별 계산방법
				   st_price =  kepGetRound2(st_list_price * b_margin_rate,1);
			}else{//고객사 전용 수식 없을 경우
				st_price = kepGetRound2(st_list_price / (1 - (st_margin_rate / 100)) , 1);
			}			
		}
		//계산수식을 이용한 매출단가 셋팅. 매익율 셋팅
		mySheet.SetCellValue(arrRow[idx],"PRICE_RATE",st_margin_rate);
		mySheet.SetCellValue(arrRow[idx],"UNIT_PRICE",st_price);
	}
	//Confirm 처리 방식.
	g_confirm_type = "submitData"; // Confirm 타입 선언
	$("#confirmMsgDiv").text("재계약 제출 하시겠습니까?"); //Confirm 문구 입력
	$("#confirmAreaDiv").show(); //Confirm 창 확인.
}

//재계약 포기
function agentHandout(){ 
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
		for(var idx=0; idx<arrRow.length; idx++){
			var st_g_note = mySheet.GetCellValue(arrRow[idx], "CLOSE_STATUS_CODE");
			
			if(kepIsValueNull(st_g_note)) {
				 alert("포기사유를 입력하여 주십시요.");
				 mySheet.SelectCell(arrRow[idx], "CLOSE_STATUS_CODE");
                 return;
			}
		}
	//Confirm 처리 방식.
	g_confirm_type = "rejectData"; // Confirm 타입 선언
	$("#confirmMsgDiv").text("재계약 포기 하시겠습니까?"); //Confirm 문구 입력
	$("#confirmAreaDiv").show(); //Confirm 창 확인.	
}
//Confrim창 확인처리
function confirmAreaDivSearch(){
	$("#confirmAreaDiv").hide();	
	if(g_confirm_type == "submitData"){ //재계약 제출
		kepSave(document.searchCondition, mySheet, "/mpcl/saveSellerMpClCatalogRecharterList.do", "SELECTED");
	}else if(g_confirm_type == "rejectData"){//재계약포기
		kepSave(document.searchCondition, mySheet, "/mpcl/rejectSellerMpClCatalogRecharter.do", "SELECTED");
	}
}
//그리드 표시후 처리	 
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
		makePageIndex2(mySheet, 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2(mySheet, current_page , document.searchCondition.onepagerow.value);	
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpcl/getSellerMpClCatalogRecharterList.do?page="+current_page , pagingMode );
}


// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if(column == "REVISION"){
		var st_rc_no = mySheet.GetCellValue(Row, "RC_NO");
		var st_rc_seq = mySheet.GetCellValue(Row, "RC_SEQ");
		popupSel = "sellerMpClCatalogRechaterHistoryPop";
		openSearchPopup("/mpcl/showSellerMpRqQuotationUnitpriceHistoryPop.do", '?st_rc_no='+st_rc_no+'&st_rc_seq='+st_rc_seq, "900,400,no");
	}
}

function mySheet_OnChange(Row, Col, Value) {

	if ( Row  < 1) return;

	var column = mySheet.ColSaveName(Col);
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg.msg);
	}
	if ( code > 0 ) {
		//저장 성공시 처리
		doAction("search");
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
}

// ajax 공통 호출후 에러시 처리 함수
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction("search");
	}
}
//헤더 더블클릭시 복사
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	if (checkRows.length == 0){
		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	var arrRow = checkRows.split("|");
	 if (mySheet.ColSaveName(Col) == "STOA_CLOSE_DATE"){ // 제출 계약만료일
		var value1 = mySheet.GetCellValue(arrRow[0], "STOA_CLOSE_DATE");
		if(kepIsValueNull(value1)){
			alert("복사할 제출 계약 만료일을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "STOA_CLOSE_DATE", value1);
		}
	}else if(mySheet.ColSaveName(Col) == "S_NOTE"){ // 협력사 포기
		var value1 = mySheet.GetCellValue(arrRow[0], "S_NOTE");
		if(kepIsValueNull(value1)){
			alert("복사할 제출 계약 만료일을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "S_NOTE", value1);
		}
	}
}
</script>
</head>
<body onload="kep_onload_view()">
<div id="wrapper">
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>
<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="sellerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
	<!--내용 시작-->
<!--내용 시작-->
<div id="ContArea">
	
		<!--버튼영역-->
       	<div id="searchBtnA">
       		<h3>재계약 접수</h3>
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition" name="searchCondition" method="post" onsubmit="return false;" >
			<div>
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME" />
				<input type="hidden" id="pageflag" name="pageflag" value="1" />
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_user_id" name="st_user_id" value="${sessionInfo.userId}" />
				<input type="hidden" id="st_com_code" name="st_com_code" value="${sessionInfo.comCode}" />
            </div>
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" onChange="doAction('search');">
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
				createIBSheet("mySheet", "", "400px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>

  		<!--버튼영역-->
  		<div class="btnArea">
			<span class="fr">
				<span class="btn_05 mr04"><a href="javaScript:doAction('reject');">재계약 포기</a></span>
				<span class="btn_05 mr04"><a href="javaScript:doAction('submit');">재계약 제출</a></span>
			</span>
		</div>
<!--내용 종료-->
</div>
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>
</div>
</body>
</html>
