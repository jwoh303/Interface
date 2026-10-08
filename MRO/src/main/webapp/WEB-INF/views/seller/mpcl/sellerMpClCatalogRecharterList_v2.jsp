<%--
**********************************************
* 메뉴 : 재계약 견적
* 화면 : 재계약 견적
* 기능 : 
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2025-12-02
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
<%@ include file="../../common/include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
<script type="text/javascript">
<%
@SuppressWarnings (value="unchecked")
String userID = _sessionInfo.getUserId();
String menuId = (String) request.getParameter("menuId");
if(myMenuListHeader != null){ //null이 아닌 경우에만 체크
	for(int i = 0; i<myMenuListHeader.size(); i++){
		if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
			myMenuFlag = true;
			break;
		}
	}
}
%>

var mySheet0 = new ibsheetObject();
var mySheet1 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var productGbn = KepSheetComboData("CC01","SEL");
var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};
var productGbn2 = KepSheetComboData("M074","SEL");
var comboInfo2 = {ComboCode: productGbn2.ComboCode, ComboText:productGbn2.ComboText};

var currIndex=1;
var Sheet;

//alert layer용
var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	Sheet = mySheet1; //첫화면에선 mySheet0; -> 재견적접수가 먼저 되도록 mySheet1
	
	//초기 날짜 셋팅
	var indexLength = $("input[name=st_from_date]").length;
	for(var i = 0; i<indexLength; i++){
		if($("input[name=st_from_date]").eq(i).val() ==  ""){
			$("input[name=st_from_date]").eq(i).val(kepToMonthAdd("3","M"));
			$("input[name=st_to_date]").eq(i).val(kepGetNowTimeStr('YYYYMMDD','/'));
		}
	}
	
	var initsheet0 = {};
	initsheet0.Cfg = {FrozenCol : 2,MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet0.Cols = [
						{ Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
						,{ Align:"Center",	SaveName:"SELECTED",					Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"BUYER_NM",			Header:"고객사",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"RC_NO",		Header:"요청번호",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"RC_SEQ",		Header:"요청순번",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"REVISION",		Header:"차수",				Type:"Text",FontColor:"#3a72c7", Cursor:"Pointer",		Width:40,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"RC_TEXT",		Header:"진행상태",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"DESCRIPTION_LOC",		Header:"품명",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Right",	SaveName:"STOA_LIST_PRICE",		Header:"제출단가\n(VAT별도)",		Type:"Float",		Width:80,	Edit:false ,EditLen:100,	Hidden:false,	Format:"${priceFormat}"}
						, {Align : "Center",SaveName : "STOA_CLOSE_DATE",		Header : "제출\n계약종료일",	Type : "Date",	Width : 110,	EditLen : 110,	Edit :false,Format:"yyyy-MM-dd"}
						,{ Align:"Left",	SaveName:"MAKER_NAME",			Header:"제조사",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"ORIGIN_NM",			Header:"원산지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"MAKER_PART_NO",		Header:"모델번호",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"ATOB_DATE",			Header:"재계약\마감일",				Type:"Date",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"CLOSE_DATE",		Header:"계약종료일",				Type:"Date",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
						,{ Align:"Right",	SaveName:"MIN_ORDER_QTY",		Header:"MOQ",				Type:"Int",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Right",	SaveName:"PUR_UNIT_QTY",		Header:"발주배수",				Type:"Int",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"USER_NM",		Header:"KeP담당자",				Type:"Text",			Width:90,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"USER_PHONE_NUMBER",		Header:"담당자연락처",				Type:"Text",			Width:90,	Edit:true,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"ATOS_DATE",			Header:"요청일",				Type:"Date",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
						,{ Align:"Left",	SaveName:"A_NOTE",			Header:"운영사비고",				Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"S_NOTE",			Header:"협력사비고",				Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false }
						,{ Align:"Left",	SaveName:"G_NOTE",			Header:"포기사유",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"BUYER",				Header:"BUYER",				Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
						,{ Align:"Center",	SaveName:"AGENT",				Header:"AGENT",				Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
	];
	
	var initsheet1 = {};
	initsheet1.Cfg = {FrozenCol : 2,MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet1.Cols = [
					{ Align:"Center",	SaveName:"sStatus",						Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELECTED",					Header:"",					Type:"DummyCheck",	Width:30,	Edit:true,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"BUYER_NM",					Header:"고객사",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"REVISION",					Header:"차수",				Type:"Text",FontColor:"#3a72c7", Cursor:"Pointer",		Width:40,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"DESCRIPTION_LOC",				Header:"품명",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"SPECIFICATION",				Header:"규격",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"UNIT_MEASURE",				Header:"단위",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Right",	SaveName:"STOA_LIST_PRICE",				Header:"제출단가\n(VAT별도)",	Type:"Float",		Width:80,	Edit:true,	EditLen:100,	Hidden:false,	BackColor:"${optColor}",	KeyField:true,	Format:"${priceFormat}"}
					,{ Align:"Center",	SaveName:"LIST_PRICE_CHANGE_REASON",	Header:"매입단가\n변동사유",		Type:"Combo",		Width:110,	Edit:false,	EditLen:20,		Hidden:true,	BackColor:"${optColor}"}
					,{ Align:"Center",	SaveName:"STOA_CLOSE_DATE",				Header:"제출\n계약종료일",		Type:"Date",		Width:110,	Edit:true,	EditLen:110,	Hidden:false,	BackColor:"${optColor}",	Sort:0,	KeyField:true,Format:"yyyy-MM-dd"}
					,{ Align:"Left",	SaveName:"MAKER_NAME",					Header:"제조사",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"ORIGIN_NM",					Header:"원산지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"MAKER_PART_NO",				Header:"모델번호",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"ATOB_DATE",					Header:"재계약\마감일",			Type:"Date",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
					,{ Align:"Center",	SaveName:"CLOSE_DATE",					Header:"계약종료일",			Type:"Date",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
					,{ Align:"Right",	SaveName:"MIN_ORDER_QTY",				Header:"MOQ",				Type:"Int",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Right",	SaveName:"PUR_UNIT_QTY",				Header:"발주배수",				Type:"Int",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"USER_NM",						Header:"KeP담당자",			Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"USER_PHONE_NUMBER",			Header:"담당자연락처",			Type:"Text",		Width:90,	Edit:true,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"ATOS_DATE",					Header:"요청일",				Type:"Date",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
					,{ Align:"Center",	SaveName:"RC_NO",						Header:"요청번호",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"RC_SEQ",						Header:"요청순번",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",				Header:"품목코드",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"A_NOTE",						Header:"운영사비고",			Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"S_NOTE",						Header:"협력사비고",			Type:"Text",		Width:180,	Edit:true,	EditLen:100,	Hidden:false,	BackColor:"${optColor}",	Sort:0}
					,{ Align:"Left",	SaveName:"CLOSE_STATUS_CODE",			Header:"포기사유",				Type:"Combo",		Width:100,	Edit:true,	EditLen:100,	Hidden:false,	BackColor:"${optColor}",	Sort:0}
					,{ Align:"Center",	SaveName:"BUYER",						Header:"BUYER",				Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
					,{ Align:"Center",	SaveName:"AGENT",						Header:"AGENT",				Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
					,{ Align:"Center",	SaveName:"RATE_GUBUN",					Header:"RATE_GUBUN",		Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
					,{ Align:"Center",	SaveName:"RATE",						Header:"RATE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
					,{ Align:"Center",	SaveName:"PRICE_RATE",					Header:"PRICE_RATE",		Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
					,{ Align:"Right",	SaveName:"UNIT_PRICE",					Header:"UNIT_PRICE",		Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",			Header:"BYIT_COMORG_CODE",	Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}

	];
	
	
	IBS_InitSheet(mySheet0, initsheet0, pagingMode);
	IBS_InitSheet(mySheet1, initsheet1, pagingMode);

	//하이퍼링크 설정
// 	mySheet.SetCellFontUnderline(0, "STOA_CLOSE_DATE", true);	
// 	mySheet.SetCellFontUnderline(0, "S_NOTE", true);
// 	mySheet.SetCellFontUnderline(0, "CLOSE_STATUS_CODE", true);
	mySheet1.SetColProperty("CLOSE_STATUS_CODE", comboInfo);
	mySheet1.SetColProperty("LIST_PRICE_CHANGE_REASON", comboInfo2);
	
	mySheet0.SetHighlightAfterSort(2);
	mySheet1.SetHighlightAfterSort(2);
	
	mySheet0.SetCountFormat(" 총  ROWCOUNT 건 ");
	mySheet1.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet0.SetHeaderBackColor("#f2f7ff");
	mySheet1.SetHeaderBackColor("#f2f7ff");
	
	mySheet0.SetTheme("DB", "DeepBlue");
	mySheet1.SetTheme("DB", "DeepBlue");
	
	doAction('search');
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = Sheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str != "search" && str != "reload" && selectedGrid.length == 0) {
// 		alert("선택된 항목이 없습니다.");
		var text = "선택된 항목이 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}

	switch (str) {
		case "search":	 // 조회
			
			if(currIndex == 0){
				if (kep_dateSearchCheck($("#st_from_date_"+currIndex).val(),$("#st_to_date_"+currIndex).val()) == false) return;
				var diff = kepGetDateDiff('st_from_date_'+currIndex,'st_to_date_'+currIndex,'D');
				if (eval(diff)>372){
//	 				alert("1년 이내 조회만 가능합니다.");
					var text = "1년 이내 조회만 가능합니다.";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
				
				kepSearch(document.searchCondition0, Sheet, "/mpcl/getSellerMpClCatalogRecharterMngList.do" , pagingMode);
			}else if(currIndex == 1){
				kepSearch(document.searchCondition1, Sheet, "/mpcl/getSellerMpClCatalogRecharterList.do" , pagingMode);
			}
			
			
			break;
		case "reload":	// 초기화
			kepReload_v2('searchCondition'+currIndex);
			kepMonth_v2('st_from_date_'+currIndex,'st_to_date_'+currIndex,'3');
			Sheet.RemoveAll();
			break;
		case "submit": //재계약 제출
			submitData();
			break;
		case "reject": //재계약 포기
			agentHandout();
			break;
		case "excelDownload": //엑셀다운로드
			excelDownload();
			break;
	}
}
//재계약 제출
function submitData(){ 
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	for(var idx=0; idx<arrRow.length; idx++){
		//제출 매입단가 필수값 체크
		var st_list_price = Sheet.GetCellValue(arrRow[idx], "STOA_LIST_PRICE");
		if(kepIsValueNull(st_list_price)) {
// 			 alert("제출 단가를 입력하여 주십시요.");
			 var text = "제출 단가를 입력해주세요.";
			 openLayerPopText2(text,but1text,but1func,but1width);
			 mySheet.SelectCell(arrRow[idx], "STOA_LIST_PRICE");
             return;
		}
		//제출 계약종료일 필수값 체크
		var st_list_price = Sheet.GetCellValue(arrRow[idx], "STOA_CLOSE_DATE");
		if(kepIsValueNull(st_list_price)) {
// 			 alert("제출 계약종료일 입력하여 주십시요.");
			 var text = "제출 계약종료일 입력해주세요.";
			 openLayerPopText2(text,but1text,but1func,but1width);
			 mySheet.SelectCell(arrRow[idx], "STOA_CLOSE_DATE");
                return;
		}
		//고객사별 매출단가 계산 수식.
		var st_buyer = Sheet.GetCellValue(arrRow[idx], "BUYER");
		var st_rate_gubun = Sheet.GetCellValue(arrRow[idx], "RATE_GUBUN");
		var st_margin_rate = Sheet.GetCellValue(arrRow[idx], "RATE");
		var st_list_price = Sheet.GetCellValue(arrRow[idx], "STOA_LIST_PRICE");
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
		Sheet.SetCellValue(arrRow[idx],"PRICE_RATE",st_margin_rate);
		Sheet.SetCellValue(arrRow[idx],"UNIT_PRICE",st_price);
	}
	
	var text = "재계약 제출 하시겠습니까?";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:saveSellerMpClCatalogRecharterList(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "100px";
	var but2widthC = "100px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
// 	//Confirm 처리 방식.
// 	g_confirm_type = "submitData"; // Confirm 타입 선언
// 	$("#confirmMsgDiv").text("재계약 제출 하시겠습니까?"); //Confirm 문구 입력
// 	$("#confirmAreaDiv").show(); //Confirm 창 확인.
}
function saveSellerMpClCatalogRecharterList(){
	closePopText1();
	kepSave(document.searchCondition1, Sheet, "/mpcl/saveSellerMpClCatalogRecharterList.do", "SELECTED");
}
//재계약 포기
function agentHandout(){ 
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
		for(var idx=0; idx<arrRow.length; idx++){
			var st_g_note = Sheet.GetCellValue(arrRow[idx], "CLOSE_STATUS_CODE");
			
			if(kepIsValueNull(st_g_note)) {
// 				 alert("포기사유를 입력하여 주십시요.");
				 var text = "포기사유를 입력해주세요.";
				 openLayerPopText2(text,but1text,but1func,but1width);
				 Sheet.SelectCell(arrRow[idx], "CLOSE_STATUS_CODE");
                 return;
			}
		}
		
		var text = "재계약 포기 하시겠습니까?";
		var but1textC = "확인";
		var but2textC = "취소";
		var but1funcC = "javascript:rejectSellerMpClCatalogRecharter(); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "100px";
		var but2widthC = "100px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		
// 	//Confirm 처리 방식.
// 	g_confirm_type = "rejectData"; // Confirm 타입 선언
// 	$("#confirmMsgDiv").text("재계약 포기 하시겠습니까?"); //Confirm 문구 입력
// 	$("#confirmAreaDiv").show(); //Confirm 창 확인.	
}
function rejectSellerMpClCatalogRecharter(){
	closePopText1();
	kepSave(document.searchCondition1, Sheet, "/mpcl/rejectSellerMpClCatalogRecharter.do", "SELECTED");
	
}
//Confrim창 확인처리
function confirmAreaDivSearch(){
	$("#confirmAreaDiv").hide();	
	if(g_confirm_type == "submitData"){ //재계약 제출
		kepSave(document.searchCondition1, Sheet, "/mpcl/saveSellerMpClCatalogRecharterList.do", "SELECTED");
	}else if(g_confirm_type == "rejectData"){//재계약포기
		kepSave(document.searchCondition1, Sheet, "/mpcl/rejectSellerMpClCatalogRecharter.do", "SELECTED");
	}
}
//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 조회 후처리
function mySheet0_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		 openLayerPopText2(text,but1text,but1func,but1width);
	}
}
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		 openLayerPopText2(text,but1text,but1func,but1width);
	}
}

// 그리드 셀클릭 이벤트
function mySheet0_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if(column == "REVISION"){
		var st_rc_no = Sheet.GetCellValue(Row, "RC_NO");
		var st_rc_seq = Sheet.GetCellValue(Row, "RC_SEQ");
// 		popupSel = "sellerMpClCatalogRechaterHistoryPop";
// 		openSearchPopup("/mpcl/showSellerMpRqQuotationUnitpriceHistoryPop.do", '?st_rc_no='+st_rc_no+'&st_rc_seq='+st_rc_seq, "900,400,no");
		var src = '/mpcl/showSellerMpRqQuotationUnitpriceHistoryPop.do?st_rc_no='+st_rc_no+'&st_rc_seq='+st_rc_seq;
		openLayerPop(src,"900px","420px");
	}
}
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	var st_rc_no = Sheet.GetCellValue(Row, "RC_NO");
	var st_rc_seq = Sheet.GetCellValue(Row, "RC_SEQ");	
	if(column == "REVISION"){
// 		popupSel = "sellerMpClCatalogRechaterHistoryPop";
// 		openSearchPopup("/mpcl/showSellerMpRqQuotationUnitpriceHistoryPop.do", '?st_rc_no='+st_rc_no+'&st_rc_seq='+st_rc_seq, "900,400,no");
		
		var src = '/mpcl/showSellerMpRqQuotationUnitpriceHistoryPop.do?st_rc_no='+st_rc_no+'&st_rc_seq='+st_rc_seq;
		openLayerPop(src,"900px","420px");
	}
}
function mySheet0_OnChange(Row, Col, Value) {

	if ( Row  < 1) return;

	var column = Sheet.ColSaveName(Col);
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
}
function mySheet1_OnChange(Row, Col, Value) {

	if ( Row  < 1) return;

	var column = Sheet.ColSaveName(Col);
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
}
//트랜젝션(저장,삽입등) 후처리
function mySheet0_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		var text = msg.msg;
		if(code>0){//저장 성공시 처리
			openLayerPopText2(text,but1text,but1funcSearch,but1width);
		}else{
			openLayerPopText2(text,but1text,but1func,but1width);
		}
	}
// 	if ( code > 0 ) {
// 		//저장 성공시 처리
// 		doAction("search");
// 	}
}
function mySheet1_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		var text = msg.msg;
		if(code>0){//저장 성공시 처리
			openLayerPopText2(text,but1text,but1funcSearch,but1width);
		}else{
			openLayerPopText2(text,but1text,but1func,but1width);
		}
	}
// 	if ( code > 0 ) {
// 		//저장 성공시 처리
// 		doAction("search");
// 	}
}


//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
}

// ajax 공통 호출후 에러시 처리 함수
function  kepAjaxError(pMethod , response) {
// 	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
	var text = "오류발생하였습니다.</br>다시 한 번 시도해 주시기 바랍니다.";
	openLayerPopText2(text,but1text,but1func,but1width);
}

function thisPopClose(){
	closePopText2();
	doAction('search');
}

function excelDownload(){
	if(Sheet.RowCount() == 0){
// 		alert("조회된 데이터가 없습니다.");
		var text = "조회된 데이터가 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	if(checkRows.length == 0){
// 		alert("상품을 선택해주세요.");
		var text = "항목을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	Sheet.SetWaitImageVisible(true);
	
	var downRow = "|0";
	for(var i=1; i<=Sheet.RowCount(); i++) {
		if(Sheet.GetCellValue("SELECTED"))
			downRow += "|"+i;
	}
	
	var downCol = "";
	for(var i=0; i<=Sheet.LastCol(); i++){
		if(!Sheet.GetColHidden(i) && Sheet.ColSaveName(i) !="SELECTED" && Sheet.GetCellProperty(1, i, "Type") != "Image"){
			downCol += "|"+i;
		}
	}
	
	if(downRow == "|0"){
		downRow = "";
	}
	var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
	
	var fileName = "";
	if(currIndex == 0){
		fileName = "재계약 견적_전체_";
	}else if(currIndex == 1){
		fileName = "재계약 견적_견적요청_";
	}
	
	var param = {FileName:fileName+nowTime, SheetName:fileName, DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
	Sheet.Down2Excel(param);
}
//헤더 더블클릭시 복사
function mySheet1_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	if (checkRows.length == 0){
// 		alert("복사할 행을 선택하여 주십시요.");
		var text = "복사할 행을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	var arrRow = checkRows.split("|");
	 if (Sheet.ColSaveName(Col) == "STOA_CLOSE_DATE"){ // 제출 계약만료일
		var value1 = Sheet.GetCellValue(arrRow[0], "STOA_CLOSE_DATE");
		if(kepIsValueNull(value1)){
// 			alert("복사할 제출 계약 만료일을 입력하여 주십시요.");
			var text = "복사할 제출 계약 만료일을 입력해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			Sheet.SetCellValue(arrRow[idx], "STOA_CLOSE_DATE", value1);
		}
	}else if(Sheet.ColSaveName(Col) == "S_NOTE"){ // 협력사 포기
		var value1 = Sheet.GetCellValue(arrRow[0], "S_NOTE");
		if(kepIsValueNull(value1)){
// 			alert("복사할 제출 계약 만료일을 입력하여 주십시요.");
			var text = "복사할 협력사비고를 입력해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			Sheet.SetCellValue(arrRow[idx], "S_NOTE", value1);
		}
	}
}
</script>
</head>
<body onload="kep_onload_view()">
<div id="wrapper">
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader_sub_v2"/>
<c:param name="part" value="header_v2"/>
</c:import>
<div id="container2">
<c:import charEncoding="utf-8" url="/main/leftMenuData.do">
<c:param name="page" value="sellerLeft_v2"/>
</c:import>
	<!--내용 시작-->
<!-- 컨텐츠 -->
	<div class="containerBoxSub" >
	  
      <div class="PDleft50"><!--padding-left:50px; 시작 -->    
		<div class="SubTit">
		<%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star"></button>
     	<%} %>     		
           	재계약 견적 
          <div class="SummaryGuide">
      	    <ul>
        	  <li><img src="/resources/imgs/Icon_Home.png" /></li>
        	  <li>견적 관리</li>
              <li>재계약 견적</li>
            </ul>
          </div>
        </div>
        <div class="SubSearchTab">
         <button class="TabTit" data-tab="Search1">전체</button>
         <button class="TabTit active" data-tab="Search2">재계약 견적요청</button>
        </div>
    <form id="searchCondition0" name="searchCondition0" method="post">
		<input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
        <div id="Search1" class="SearchContent">
          <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> “전체”탭은 모든 진행상태에 대한 견적현황을 확인 할 수 있습니다.</div>
          <table class="TabSearchTable" >
            <colgroup>
              <col width="6%" />
              <col width="19%" />
              <col width="6%" />
              <col width="19%" />
              <col width="6%" />
              <col width="19%" />
              <col width="6%" />
              <col width="19%" />
            </colgroup>          	
            <tr>
              <th>요청일</th>
              <td colspan="3">
                <div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date_0" name="st_from_date" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_0" name="st_to_date" readonly /><span></span></div>
                </div>
                <button class="But_Month" data-group="tab0" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','1'); return false;">1개월</button> 
                <button class="But_Month" data-group="tab0" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','2'); return false;">2개월</button>
                <button class="But_Month" data-group="tab0" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','3'); return false;">3개월</button>
                <button class="But_Month" data-group="tab0" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','12'); return false;">1년</button>
               </td>
              <th>요청번호</th>
              <td><input class="input30" style="width:90%" id="st_rc_no_0" name="st_rc_no" type="text" onKeyDown="kepEnter_v2()"/></td>               
              <th>고객사명</th>
              <td><input class="input30" style="width:90%" id="st_buyer_name_0" name="st_buyer_name" type="text" onKeyDown="kepEnter_v2()"/></td>
            </tr>
            <tr>
              <th>품목코드</th>
              <td><input class="input30" style="width:90%" id="st_buyer_item_no_0" name="st_buyer_item_no" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>품목명</th>
              <td><input class="input30" style="width:90%" id="st_description_0" name="st_desc" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>규격</th>
              <td><input class="input30" style="width:90%" id="st_specification_0" name="st_sepc" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>모델번호</th>
              <td><input class="input30" style="width:90%" id="st_maker_part_no_0" name="st_maker_part_no" type="text" onKeyDown="kepEnter_v2()"/></td>
            </tr>
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="doAction('search');return false;">조회</button> 
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40" onclick="javscript:doAction('excelDownload'); return false;">엑셀다운로드</button>
            </div>
          </div>
          <div class="IBSheet">
          	<script type="text/javascript">
          		createIBSheet("mySheet0", "", "100%");
          	</script>
          </div><!--IBSheet 끝 --> 
          <div class="h5" style="height: 50px;"></div>         
        </div><!--id="Search1" 전체 끝 --> 
      </form>     
      <form id="searchCondition1" name="searchCondition1" method="post">
		<input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_giveup_yn" id="st_giveup_yn" value="" >
		<input type="hidden" id="st_user_id" name="st_user_id" value="${sessionInfo.userId}" />
		<input type="hidden" id="st_user_name" name="st_user_name" value="${sessionInfo.userNameLoc}">
		<input type="hidden" id="st_user_tel" name="st_user_tel" value="${sessionInfo.tel}">
		<input type="hidden" id="st_corp_code" name="st_corp_code" value="" />
        <div id="Search2" class="SearchContent active">
          <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> “견적요청”탭에서는 재계약 대상 품목에 대한 견적을 제출하거나 포기 할 수 있습니다.</div>
          <table class="TabSearchTable" >
            <colgroup>
              <col width="6%" />
              <col width="19%" />
              <col width="6%" />
              <col width="19%" />
              <col width="6%" />
              <col width="19%" />
              <col width="6%" />
              <col width="19%" />
            </colgroup>          	
            <tr>
<!--               <th>견적요청일</th> -->
<!--               <td colspan="3"> -->
<!--                 <div class="datepicker-wrap" style=" width:230px"> -->
<!--                   <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date_1" name="st_from_date" readonly /><span> </span></div> -->
<!--                   <span class="dash">~</span> -->
<!--                   <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_1" name="st_to_date" readonly /><span></span></div> -->
<!--                 </div> -->
<!-- 				<button class="But_Month" data-group="tab1" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','1'); return false;">1개월</button>  -->
<!--                 <button class="But_Month" data-group="tab1" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','2'); return false;">2개월</button> -->
<!--                 <button class="But_Month" data-group="tab1" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','3'); return false;">3개월</button> -->
<!--                 <button class="But_Month" data-group="tab1" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','12'); return false;">1년</button> -->
<!--               </td> -->
<!--               <th>진행상태</th> -->
<!--               <td><select name="st_sourcing_status" id="" class="Select" style="width:90%"> -->
<!--                   	<option value="" >전체</option> -->
<!-- 			      	<option value="신규견적요청" >신규견적요청</option> -->
<!-- 					<option value="재견적요청" >재견적요청</option> -->
<!--                   </select> -->
<!--                </td> -->
              <th>고객사</th>
              <td><input class="input30" style="width:92%" id="st_buyer_name_1" name="st_buyer_name" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>품목명</th>
              <td><input class="input30" style="width:92%" id="st_description_1" name="st_desc" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>규격</th>
              <td><input class="input30" style="width:92%" id="st_specification_1" name="st_sepc" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>모델번호</th>
              <td><input class="input30" style="width:92%" id="st_maker_part_no_1" name="st_maker_part_no" type="text" onKeyDown="kepEnter_v2()"/></td>
            </tr>
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="doAction('search'); return false;">조회</button> 
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40" onclick="javscript:doAction('excelDownload'); return false;">엑셀다운로드</button>
<!--             &nbsp;<button class="ButM_Outline" onclick="javascript:doPop('popMulti'); return false;" >일괄등록</button> -->
            </div>
            <div class="right">
              <button class="ButM_Outline" onclick="javascript:doAction('reject'); return false;">견적포기</button>
              <button class="ButMPrimary" onclick="javascript:doAction('submit'); return false;">견적제출</button>
            </div>
          </div>
          <div class="IBSheet">
          	<script type="text/javascript">
          		createIBSheet("mySheet1", "", "100%");
          	</script>
		  </div>
		  <div class="h5" style="height: 50px;"></div> 
        </div><!--id="Search2" 견적요청 끝 -->
        </form>
        
		<!-- 탭 스크립트 -->     
		<script>
		//탭 클릭
          const tabLinks = document.querySelectorAll(".TabTit");
          const tabContents = document.querySelectorAll(".SearchContent");
          
          tabLinks.forEach(function(link,index) {
            link.addEventListener("click", function() {
              // 모든 탭 버튼, 컨텐츠 비활성화
              tabLinks.forEach(function(btn) {btn.classList.remove("active")});
              tabContents.forEach(function(content){ content.classList.remove("active")});
        
              // 클릭한 탭 활성화
              link.classList.add("active");
              document.getElementById(link.dataset.tab).classList.add("active");
              currIndex = index; //현재 탭 index를 저장
              if(currIndex == 0){
            	  Sheet = mySheet0;
              }else if(currIndex == 1){
            	  Sheet = mySheet1;
              }
              
              doAction('search');
            });
          });
          
          
          //입력했을때 앞 공백 제거
          const inputs = document.querySelectorAll("input[name=st_rc_no],input[name=st_description],input[name=st_specification],input[name=st_buyer_item_no]");
          inputs.forEach(function(input){
        	  input.addEventListener("input",function(){
        		  this.value = this.value.trimStart();
        	  });
          });
          
        </script>
        
      </div> <!--padding-left:50px; 끝 -->
    </div><!--containerBoxSub--> 
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter_sub_v2.jsp" %>
</div>
</body>
</html>
