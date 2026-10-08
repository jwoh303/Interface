<%--
**********************************************
* 메뉴 : 프로젝트 견적
* 화면 : 프로젝트 견적
* 기능 : 
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2025-08-20
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
String com_code = _sessionInfo.getComCode();
%>

<script type="text/javascript">


var mySheet0 = new ibsheetObject();
var mySheet1 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

var currIndex=1;
var Sheet;
// var Sheet = "mySheet"+currIndex;

//alert layer용
var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

// var unit01 = KepSheetComboQueryIdData('seller.mprq.sellerItemCodeList','SEL','');	// IBSHEET : 품목제안
var unit01 = KepSheetComboData("BURQ05", "SEL"); // IBSHEET1 : 거래유형
var unit02 = KepSheetComboData("BURQ09", "SEL"); // IBSHEET1 : 거래유형
var unit03 = KepSheetComboData("BURQ10", "SEL"); // IBSHEET1 : 배송유형

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	Sheet = mySheet1; //첫화면에선 mySheet0; -> 견적요청이 먼저 되도록 mySheet1
	//초기 날짜 셋팅
	var indexLength = $("input[name=st_from_date]").length;
	
	// 물류수수료율 
	kepAjaxCallNoBar("/mprq/getLogisFee.do", '' ,"burqLogisFee");
	
	for(var i = 0; i<indexLength; i++){
		if($("input[name=st_from_date]").eq(i).val() ==  ""){
			$("input[name=st_from_date]").eq(i).val(kepToMonthAdd("1","M"));
			$("input[name=st_to_date]").eq(i).val(kepGetNowTimeStr('YYYYMMDD','/'));
		}
	}
	
	// 진행현황
	var initsheet0 = {};
	initsheet0.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet0.Cols = [
		 { Align:"Center",	Hidden:true,Type:"Text",	Header:"상태",	SaveName: "sStatus"}
		,{ Align:"Center",	Width:40,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",					SaveName:"SELECTED",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"견적요청일",		SaveName:"ATOS_DATE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적번호",			SaveName:"BURQ_RFQ_NO",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"진행상태",			SaveName:"STATUS",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"프로젝트코드",		SaveName:"BURQ_NO",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"프로젝트명",		SaveName:"PROJECT_NAME",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품목구분",			SaveName:"AGENT_TYPE_NAME",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"견적마감일",		SaveName:"ATOS_END_DATE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"견적제출일",		SaveName:"STOA_DATE",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사명",			SaveName:"BUYER_NAME",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품명",			SaveName:"AGENT_DESCRIPTION",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"규격",			SaveName:"AGENT_SPECIFICATION",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"모델명",			SaveName:"AGENT_MAKER_PART_NO",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"제조사",			SaveName:"AGENT_MAKER_NAME",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"MOQ",			SaveName:"AGENT_MIN_ORDER_QTY",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주배수",			SaveName:"AGENT_PUR_UNIT_QTY",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"단위",			SaveName:"AGENT_UNIT_MEASURE",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"견적단가(VAT별도)",	SaveName:"CH_LIST_PRICE",ColMerge:0,Sort:1,	Format:"${priceFormat}"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"거래유형",			SaveName:"AGENT_PROCESS_TYPE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"배송유형",			SaveName:"AGENT_PARCEL_YN"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"예상도착지",		SaveName:"DELY_TEXT"}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"조달일수",			SaveName:"DELIVERY_LT",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적포기 사유",		SaveName:"GIVEUP_REASEON",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"비고",			SaveName:"AGENT_REMARK",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"견적유효일",		SaveName:"BUY_CLOSE_DATE",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"SG담당자",		SaveName:"AGENT_MNG_USER_NAME",ColMerge:0,Sort:1,FontColor:"#3a72c7", Cursor:"Pointer"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"SG담당자",		SaveName:"AGENT_MNG_USER_ID",ColMerge:0,Sort:1}
	];
	
	// 요청 접수
	var initsheet1 = {};
	initsheet1.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 25, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet1.Cols = [
			 { Align:"Center",	Hidden:true,Type:"Text",	Header:"상태|상태",	SaveName: "sStatus"} 
		,{ Align:"Center",	Width:40,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:" | ",					SaveName:"SELECTED",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"진행상태|진행상태",			SaveName:"STATUS",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 요청 품목 정보|품목구분",			SaveName:"AGENT_TYPE_NAME",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 요청 품목 정보|견적번호",			SaveName:"BURQ_RFQ_NO",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"견적 요청 품목 정보|프로젝트코드",	SaveName:"BURQ_NO",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 요청 품목 정보|프로젝트명",		SaveName:"PROJECT_NAME",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 요청 품목 정보|고객사명",			SaveName:"BUYER_NAME",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"견적 요청 품목 정보|견적요청일",		SaveName:"ATOS_DATE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"견적 요청 품목 정보|견적마감일",		SaveName:"ATOS_END_DATE",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 요청 품목 정보|품명",		SaveName:"DESCRIPTION",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 요청 품목 정보|규격",		SaveName:"SPECIFICATION",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 요청 품목 정보|모델명",	SaveName:"MAKER_PART_NO",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 요청 품목 정보|제조사",	SaveName:"MAKER_NAME",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 요청 품목 정보|최소주문수량",		SaveName:"MIN_ORDER_QTY",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 요청 품목 정보|주문배수수량",	SaveName:"PUR_UNIT_QTY",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 요청 품목 정보|단위",		SaveName:"UNIT_MEASURE",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"견적 요청 품목 정보|기존단가",	SaveName:"RE_LIST_PRICE",	Format:"${priceFormat}"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 요청 품목 정보|거래유형",	SaveName:"PROCESS_TYPE_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 요청 품목 정보|배송유형",	SaveName:"PARCEL_YN_NAME"}
		,{ Align:"Left",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 요청 품목 정보|예상도착지",	SaveName:"DELY_TEXT"}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 요청 품목 정보|예상수량",	SaveName:"ITEM_QTY"}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 요청 품목 정보|발주 횟수",	SaveName:"PO_CNT"}
		
		,{ Align:"Center",	Width:120,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Combo",		Header:"견적 제출 정보|품목제안",		SaveName:"ITEM_TYPE", ComboText:unit01.ComboText, 	ComboCode:unit01.ComboCode}
		,{ Align:"Left",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 제출 정보|품명",			SaveName:"AGENT_DESCRIPTION",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 제출 정보|규격",			SaveName:"AGENT_SPECIFICATION",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 제출 정보|모델명",		SaveName:"AGENT_MAKER_PART_NO",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 제출 정보|제조사",		SaveName:"AGENT_MAKER_CODE",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:90,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 제출 정보|최소주문수량",			SaveName:"AGENT_MIN_ORDER_QTY",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:90,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 제출 정보|주문배수수량",		SaveName:"AGENT_PUR_UNIT_QTY",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 제출 정보|단위",			SaveName:"AGENT_UNIT_MEASURE",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"견적 제출 정보|견적단가(VAT별도)",	SaveName:"CH_LIST_PRICE",ColMerge:0,Sort:1,	Format:"${priceFormat}"}
		,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",		Header:"견적 제출 정보|거래유형",		SaveName:"AGENT_PROCESS_TYPE", ComboText:unit02.ComboText, 	ComboCode:unit02.ComboCode}
		,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",		Header:"견적 제출 정보|배송유형",		SaveName:"AGENT_PARCEL_YN", 	ComboText:unit03.ComboText, 	ComboCode:unit03.ComboCode}
		,{ Align:"Right",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 제출 정보|조달일수",			SaveName:"DELIVERY_LT",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"견적 제출 정보|견적유효일",		SaveName:"BUY_CLOSE_DATE",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적 제출 정보|비고",			SaveName:"AGENT_REMARK",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"SG담당자|SG담당자",			SaveName:"AGENT_MNG_USER_NAME",ColMerge:0,Sort:1,FontColor:"#3a72c7", Cursor:"Pointer"}

		,{ Hidden:true,	Type:"Text",	Header:"견적 요청 품목 정보|거래유형_코드",	SaveName:"PROCESS_TYPE"}
		,{ Hidden:true,	Type:"Text",	Header:"견적 요청 품목 정보|배송유형_코드",	SaveName:"PARCEL_YN"}
		,{ Hidden:true,	Type:"Text",	Header:"SG담당자|SG담당자_아이디",		SaveName:"AGENT_MNG_USER_ID"}
	];
	
	
	IBS_InitSheet(mySheet0, initsheet0, pagingMode);
	IBS_InitSheet(mySheet1, initsheet1, pagingMode);
	
	mySheet0.SetHighlightAfterSort(2);
	mySheet1.SetHighlightAfterSort(2);
	
	mySheet0.SetCountFormat(" 총  ROWCOUNT 건 ");
	mySheet1.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet0.SetHeaderBackColor("#f2f7ff");
	mySheet1.SetHeaderBackColor("#f2f7ff");
	
	mySheet0.SetTheme("DB", "DeepBlue");
	mySheet1.SetTheme("DB", "DeepBlue");

// 	doAction('search');

	// 최초 방문 시 프로젝트 견적 안내 팝업 자동 표시
	showBulkNoticeAutoPopup();
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	if(currIndex == 1){
		if(str != "reload"){
			if(isEmpty($("#st_burq_no"+currIndex).val())){
	// 			alert("프로젝트를 선택하시기 바랍니다.");
				var text = "프로젝트를 선택하시기 바랍니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
		}
	}
	
	var selectedGrid = "";
	selectedGrid = Sheet.FindCheckedRow("SELECTED");
	
	if(str != "search" && str != "excelDown" && str != "reload"){
		if (isEmpty(selectedGrid)){
// 			alert("품목을 하나 이상 선택해 주세요.");
			var text = "품목을 하나 이상 선택해 주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}
	
	var arrRow  = selectedGrid.split("|");
	switch (str) {
		case "search":	 // 조회
			if(currIndex == 0){
				if (kep_dateSearchCheck($("#st_from_date_"+currIndex).val(),$("#st_to_date_"+currIndex).val()) == false) return;
				var diff = kepGetDateDiff('st_from_date_'+currIndex,'st_to_date_'+currIndex,'D');
				if (eval(diff)>372){
	// 				alert("1년 이내 조회만 가능합니다.");
					var text = "1년 이내 조회만 가능합니다.";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
			}
			
			if(currIndex == 0){
				kepSearch(document.searchCondition0, Sheet, "/mprq/getSellerMpRqBulkQuotationProceStateList.do" , pagingMode);
			}else if(currIndex == 1){
				kepSearch(document.searchCondition1, Sheet, "/mprq/getSellerMpRqBulkQuotationReqList.do" , pagingMode);
			}
			break;
		case "reload":	// 초기화
			kepReload_v2('searchCondition'+currIndex);
			kepMonth_v2('st_from_date_'+currIndex,'st_to_date_'+currIndex,'1');
			Sheet.RemoveAll();
			document.getElementById("remark").innerHTML = '';
			document.getElementById("logis_fee").innerHTML = '00';
			break;
		case "setSamePrice": // (재계약) 동일단가 적용
			for(var i = 0 ; i < arrRow.length; i++){
				var check = Sheet.GetCellValue(arrRow[i],"AGENT_TYPE_NAME");
				if(check != "재계약"){
// 					alert("신규 품목에는 동일단가 적용이 불가능 합니다. 재계약 품목만 선택해 주세요.");
					var text = "신규 품목에는 동일단가 적용이 불가능 합니다. 재계약 품목만 선택해 주세요.";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
				checkNo = Sheet.GetCellValue(arrRow[i],"BURQ_RFQ_NO");
				st_burq_rfq_no_list += checkNo+"@@";
			}
			kepSave(document.searchCondition1 ,  Sheet , "/mprq/updateSellerMpRqBulkQuotationReqSamePrice.do" , "SELECTED" );  
			break;
		case "cancelSubmit": // 견적제출 취소
			var st_burq_rfq_no_list = '';
			for(var i = 0 ; i < arrRow.length; i++){
				if( Sheet.GetCellValue(arrRow[i],"STATUS") != "견적제출"){
// 					alert("현재 [견적요청] 상태인 품목은 취소 대상이 아닙니다.");
					var text = "현재 [견적요청] 상태인 품목은 취소 대상이 아닙니다.";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
				var checkNo = Sheet.GetCellValue(arrRow[i],"BURQ_RFQ_NO");
				st_burq_rfq_no_list += checkNo+"@@";
			}
			$("#st_query"+currIndex).val(st_burq_rfq_no_list);
			
// 			if(!confirm("선택하신 품목의 견적 제출을 취소하시겠습니까?  취소 시 해당 품목은 [견적요청] 상태로 돌아갑니다. ")){
// 				return;
// 			}
			var text = "선택하신 품목의 견적 제출을 취소하시겠습니까?  취소 시 해당 품목은 [견적요청] 상태로 돌아갑니다.";
			var but1textC = "확인";
			var but2textC = "취소";
			var but1funcC = "javascript:updateSellerMpRqBulkQuotationReqCancelSubmit(); return false;";
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "80px";
			var but2widthC = "80px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			
// 			kepAjaxFormCall("/mprq/updateSellerMpRqBulkQuotationReqCancelSubmit.do","searchCondition1","cancelSubmit");
			
			break;
		case "submit": // 견적제출
			for(var i = 0 ; i < arrRow.length; i++){
				if( Sheet.GetCellValue(arrRow[i],"STATUS") != "견적요청"){
// 					alert("이미 [견적제출]된 품목이 포함되어 있습니다. 확인 후 다시 시도해 주세요.");
					var text = "이미 [견적제출]된 품목이 포함되어 있습니다. 확인 후 다시 시도해 주세요.";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
				
				for(var j = 23; j <= 35; j++){ // 품목제안 ~ 유효일
					if(isEmpty(Sheet.GetCellValue(arrRow[i],j))){
// 						alert(arrRow[i]-1 + "번째 행의 견적 제출 정보를 채워주시기 바랍니다.");
						var text = arrRow[i]-1 + "번째 행의 견적 제출 정보를 채워주시기 바랍니다.";
						openLayerPopText2(text,but1text,but1func,but1width);
						return;
					}
				}
				
				//최종적으로 제출하기전 품명,규격,모델명,제조사,최소주문수량,주문배수수량,단위 중 하나라도 기존값과 다르면 대체제안 / 다 같으면 동일
				if( (Sheet.GetCellValue(arrRow[i],"DESCRIPTION") != Sheet.GetCellValue(arrRow[i],"AGENT_DESCRIPTION")) || (Sheet.GetCellValue(arrRow[i],"SPECIFICATION") != Sheet.GetCellValue(arrRow[i],"AGENT_SPECIFICATION")) || 
					(Sheet.GetCellValue(arrRow[i],"MAKER_PART_NO") != Sheet.GetCellValue(arrRow[i],"AGENT_MAKER_PART_NO")) || (Sheet.GetCellValue(arrRow[i],"MAKER_NAME") != Sheet.GetCellValue(arrRow[i],"AGENT_MAKER_CODE")) || 
					(Sheet.GetCellValue(arrRow[i],"MIN_ORDER_QTY") != Sheet.GetCellValue(arrRow[i],"AGENT_MIN_ORDER_QTY")) || (Sheet.GetCellValue(arrRow[i],"PUR_UNIT_QTY") != Sheet.GetCellValue(arrRow[i],"AGENT_PUR_UNIT_QTY")) || 
					(Sheet.GetCellValue(arrRow[i],"UNIT_MEASURE") != Sheet.GetCellValue(arrRow[i],"AGENT_UNIT_MEASURE")) || (Sheet.GetCellValue(arrRow[i],"AGENT_PROCESS_TYPE") != Sheet.GetCellValue(arrRow[i],"PROCESS_TYPE")) ||
					(Sheet.GetCellValue(arrRow[i],"AGENT_PARCEL_YN") != Sheet.GetCellValue(arrRow[i],"PARCEL_YN"))){
					Sheet.SetCellValue(arrRow[i],"ITEM_TYPE","A");
				}else{
					Sheet.SetCellValue(arrRow[i],"ITEM_TYPE","B");
				}
			}
			
// 			if(!confirm("선택하신 품목을 [견적제출] 하시겠습니까?")){
// 				return;
// 			}
			
			var text = "선택하신 품목을 [견적제출] 하시겠습니까?";
			var but1textC = "확인";
			var but2textC = "취소";
			var but1funcC = "javascript:updateSellerMpRqBulkQuotationReq(); return false;";
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "80px";
			var but2widthC = "80px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			
			
// 			kepSave(document.searchCondition1 ,  Sheet , "/mprq/updateSellerMpRqBulkQuotationReq.do" , "SELECTED" );
			break;
		case "tempSave": // 임시저장
			for(var i = 0 ; i < arrRow.length; i++){
				if( Sheet.GetCellValue(arrRow[i],"STATUS") != "견적요청"){
// 					alert("이미 [견적제출]된 품목이 포함되어 있습니다. 확인 후 다시 시도해 주세요.");
					var text = "이미 [견적제출]된 품목이 포함되어 있습니다. 확인 후 다시 시도해 주세요.";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
			}
		
			kepSave(document.searchCondition1 ,  Sheet , "/mprq/updateSellerMpRqBulkQuotationReqTemp.do" , "SELECTED" );
			break;
		case "excelDown": // 엑셀다운로드
			excelDownload();
			break;
	}
}
function updateSellerMpRqBulkQuotationReqCancelSubmit(){
	closePopText1();
	kepAjaxFormCall("/mprq/updateSellerMpRqBulkQuotationReqCancelSubmit.do","searchCondition1","cancelSubmit");
}
function updateSellerMpRqBulkQuotationReq(){
	closePopText1();
	kepSave(document.searchCondition1 ,  Sheet , "/mprq/updateSellerMpRqBulkQuotationReq.do" , "SELECTED" );
}
function excelDownload(){
// 	alert("엑셀다운");
	
	if(Sheet.RowCount() == 0){
// 		alert("조회된 데이터가 없습니다.");
		var text = "조회된 데이터가 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
// 	// 선택된 항목 유무 체크
// 	if (checkRows.length == 0) {
// // 		alert("상품을 선택해주세요.");
// 		var text = "항목을 선택해주세요.";
// 		openLayerPopText2(text,but1text,but1func,but1width);
// 		return;
// 	}
	
	Sheet.SetWaitImageVisible(true);
	
// 	var downRow = "|0";
// 	for(var i=1; i<=Sheet.RowCount(); i++) {
// 		if(Sheet.GetCellValue(i,"SELECTED"))
// 			downRow += "|"+i;
// 	}
	
	var downCol = "";
	for(var i=0; i<=Sheet.LastCol(); i++){
		if(!Sheet.GetColHidden(i) && Sheet.ColSaveName(i) !="SELECTED" && Sheet.GetCellProperty(1, i, "Type") != "Image"){
			downCol += "|"+i;
		}
	}
	
// 	if(downRow == "|0"){
// 		downRow = "";
// 	}
	var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
	
	var fileName = "";
	if(currIndex == 0){
		fileName = "프로젝트견적_전체_";
	}else if(currIndex == 1){
		fileName = "프로젝트견적_견적요청_";
	}
	
	var param = {FileName:fileName+nowTime, SheetName:fileName,DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:1, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
	//  DownRows:downRow, 
	Sheet.Down2Excel(param);
}
//팝업함수호출
function doPop(str, val1, val2) {
	popupSel = str;
	var burq_no = '';
	if(str != 'selProject'){
		burq_no = $("#st_burq_no"+currIndex).val();
		if(isEmpty(burq_no)){
// 			alert("프로젝트를 선택하시기 바랍니다.");
			var text = "프로젝트를 선택하시기 바랍니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}
	
	switch (str) {
		case "selProject": // 프로젝트
			popupSel = "selProject";
			
			var src = "/mprq/showSellerProjectList.do"; 
			openLayerPop(src,"580px","420px");
// 			openSearchPopup("/mprq/showSellerProjectList.do", '', "600,380,no");
			
			break;
		case "giveUp": //견적포기
			popupSel = "giveUp";
			var selectedGrid = Sheet.FindCheckedRow("SELECTED");
			if (isEmpty(selectedGrid)){
				var text = "선택하신 견적이 없습니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			var arrRow  = selectedGrid.split("|");
			var st_burq_rfq_no_list = '';
			for(var i = 0 ; i < arrRow.length; i++){
				var checkNo = Sheet.GetCellValue(arrRow[i],"BURQ_RFQ_NO");
				st_burq_rfq_no_list += checkNo+"@@";
			}
			
			var src = "/mprq/showSellerMpRqBulkQuotationGiveUpReasonPop.do?st_burq_no="+burq_no+"&st_burq_rfq_no_list="+st_burq_rfq_no_list; 
			openLayerPop(src,"550px","420px");
			
// 			openSearchPopup("/mprq/showSellerMpRqBulkQuotationGiveUpReasonPop.do", '?st_burq_no='+burq_no+'&st_burq_rfq_no_list='+st_burq_rfq_no_list, "600,350,no");
			break;
		case "priceUpload" : // 단가 업로드
			var src = "/mprq/showSellerBulkQuotationPriceRegPop.do?st_burq_no="+burq_no+"&st_project_name="+$('#st_project_name'+currIndex).val(); 
			openLayerPop(src,"610px","730px");
// 			openSearchPopup("/mprq/showSellerBulkQuotationPriceRegPop.do", '?st_burq_no='+burq_no+'&st_project_name='+$('#st_project_name'+currIndex).val(), "550,660,no");
			break;
		case "popMulti": // 일괄 입력
			var checkRows = Sheet.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			
			if(arrRow.length <= 0){
				var text = "선택된 항목이 없습니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}else if(arrRow.length < 2){
				var text = "일괄선정은 2건 이상 선택이 필요합니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}else{
				for(var i = 0 ; i < arrRow.length; i++){
					var status = Sheet.GetCellValue(arrRow[i],"STATUS");
					if(status == "견적제출"){
						var text = "견적제출 건이 포함되어 있습니다.";
						openLayerPopText2(text,but1text,but1func,but1width);
						return;
					}
				}
			}
			
			var text = "선택된 항목들에 일괄적용됩니다. 진행하시겠습니까?";
			var but1textC = "확인";
			var but2textC = "취소";
			var but1funcC = "javascript:getSellerMpRqBulkQuotMultiPop(); return false;";
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "120px";
			var but2widthC = "120px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			break;
	}
}
function getSellerMpRqBulkQuotMultiPop(){
	closePopText1();
	var src = "/mprq/getSellerMpRqBulkQuotMultiPop_v2.do";
	openLayerPop(src,"500px","500px");
}

//조회 후처리
function mySheet0_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
//조회 후처리
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
	var oneYearAfterDate = kepToMonthAdd("12","P","noslash");
	var maxRow = Sheet.RowCount() + 1; 
    for(var i = 2; i <= maxRow; i++){
    	Sheet.SetCellValue(i,"BUY_CLOSE_DATE",oneYearAfterDate);
    	Sheet.SetCellBackColor(i,"AGENT_DESCRIPTION","${optColor}");
    	Sheet.SetCellBackColor(i,"AGENT_SPECIFICATION","${optColor}");
    	Sheet.SetCellBackColor(i,"AGENT_MAKER_PART_NO","${optColor}");
    	Sheet.SetCellBackColor(i,"AGENT_MAKER_CODE","${optColor}");
    	Sheet.SetCellBackColor(i,"AGENT_MIN_ORDER_QTY","${optColor}");
    	Sheet.SetCellBackColor(i,"AGENT_PUR_UNIT_QTY","${optColor}");
    	Sheet.SetCellBackColor(i,"AGENT_UNIT_MEASURE","${optColor}");
    	Sheet.SetCellBackColor(i,"AGENT_PROCESS_TYPE","${optColor}");
    	Sheet.SetCellBackColor(i,"AGENT_PARCLE_YN","${optColor}");
   		Sheet.SetCellBackColor(i,"DELIVERY_LT","${optColor}");
   		Sheet.SetCellBackColor(i,"CH_LIST_PRICE","${optColor}");
   		Sheet.SetCellBackColor(i,"BUY_CLOSE_DATE","${optColor}");
   		
   		if(Sheet.GetCellValue(i,23) == "B" && Sheet.GetCellValue(i,"STATUS") == "견적요청"){  // 기본 값 동일로 세팅
	    	setSame(i);
   		}
    }
}
//그리드 셀클릭 이벤트
function mySheet0_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_user_id = Sheet.GetCellValue(Row, "AGENT_MNG_USER_ID");
	
	if(column == "AGENT_MNG_USER_NAME"){
		var src = "/mprq/quotUserInfoDisplayPop_v2.do?st_user_id="+st_user_id; 
		openLayerPop(src,"680px","300px");
	}
	
	return;
}
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_user_id = Sheet.GetCellValue(Row, "AGENT_MNG_USER_ID");
	
	if(column == "AGENT_MNG_USER_NAME"){
		var src = "/mprq/quotUserInfoDisplayPop_v2.do?st_user_id="+st_user_id; 
		openLayerPop(src,"680px","300px");
	}
	
	return;
}

function mySheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag){
	/* Row : 해당 셀의 Row Index, Col : 해당셀의 Column Index, value : 변경 값(format 적용 X), OldValue : 변경 이전 값, RaiseFlag: 이벤트 발생 옵션(0: 사용자편집, 1:메소드 2:Copy&paste) */
// 	console.log(Row+ ", "+ Col+ ", "+ Value+ ", "+ OldValue + ',' + RaiseFlag);

	var column = mySheet1.ColSaveName(0 ,Col );
	
	if(RaiseFlag == 0){ // 데이터 직접 수정한 경우에만 이벤트
		
		if (column == "AGENT_MIN_ORDER_QTY" || column == "AGENT_PUR_UNIT_QTY" || column == "CH_LIST_PRICE" || column == "DELIVERY_LT"){ // MOQ, 발주배수, 견적단가 , 조달일수 , 견적유효일
			if(isNaN(Value)){
// 				alert("숫자만 입력할 수 있습니다.");
				var text = "숫자만 입력할 수 있습니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				Sheet.SetCellValue(Row,Col,"");
				return;
			}
		}	
	
		if(Col == 23){ //품목유형 변경 시
			switch(Value){
				case "A" : // 대체제안
					for(var i = 24; i <= 33; i++){
						Sheet.SetCellValue(Row,i,"");
					}
					break;
				case "B" : // 동일
					setSame(Row);
					break;
			}
		}else if (24 <= Col && Col < 35){ //  품명/규격/모델명/제조사/MOQ/발주배수/단위/거래유형 /배송유형 변경 입력 시 자동으로 옵션값 변경
			if(Sheet.GetCellValue(Row,23) == "B"){
				Sheet.SetCellValue(Row,23,"A");
			}
		}
	}
		
}
function setSame(i){
	Sheet.SetCellValue(i,"AGENT_DESCRIPTION",Sheet.GetCellValue(i,"DESCRIPTION"));
	Sheet.SetCellValue(i,"AGENT_SPECIFICATION",Sheet.GetCellValue(i,"SPECIFICATION"));
	Sheet.SetCellValue(i,"AGENT_MAKER_PART_NO",Sheet.GetCellValue(i,"MAKER_PART_NO"));
	Sheet.SetCellValue(i,"AGENT_MAKER_CODE",Sheet.GetCellValue(i,"MAKER_NAME"));
	Sheet.SetCellValue(i,"AGENT_MIN_ORDER_QTY",Sheet.GetCellValue(i,"MIN_ORDER_QTY"));
	Sheet.SetCellValue(i,"AGENT_PUR_UNIT_QTY",Sheet.GetCellValue(i,"PUR_UNIT_QTY"));
	Sheet.SetCellValue(i,"AGENT_UNIT_MEASURE",Sheet.GetCellValue(i,"UNIT_MEASURE"));
	Sheet.SetCellValue(i,"AGENT_PROCESS_TYPE",Sheet.GetCellValue(i,"PROCESS_TYPE"));
	Sheet.SetCellValue(i,"AGENT_PARCEL_YN",Sheet.GetCellValue(i,"PARCEL_YN"));
	Sheet.SetCellValue(i,"CH_LIST_PRICE",Sheet.GetCellValue(i,"RE_LIST_PRICE"));
}

//트랜젝션(저장,삽입등) 후처리
function mySheet1_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
		
	if ( code == 0 ) {
		//저장 성공시 처리
		var text = "처리 완료하였습니다.";
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
	}else{
		if(msg != ""){
			var text = msg.msg;
			openLayerPopText2(text,but1text,but1func,but1width);
		}
	}
	
}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	if(pMethod == "burqremark"){
		var list = response.list;
		var remarkStr = '';
		for(var i = 0; i < list.length; i++){
			remarkStr += '▪ ' + list[i].NOTICE_REMARK + '<br>';	
		}
		document.getElementById("remark").innerHTML = remarkStr;
	}else if (pMethod =="cancelSubmit"){
// 		alert("견적 제출 취소가 완료 되었습니다.");
		var text = "견적 제출 취소가 완료 되었습니다.";
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
	}else if(pMethod == "burqLogisFee"){
		var fee = response.logis_fee;
		document.getElementById("logis_fee").innerHTML = fee;
	}
	return;
}

// ajax 공통 호출후 에러시 처리 함수
function  kepAjaxError(pMethod , response) {
	var msg = response.Message;
	
	if (!isEmpty(msg)){
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	return;
	
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2,value3,value4,value5,value6,value7,value8){
	if(popupSel=="selProject"){
// 		document.getElementById("project_name").innerHTML = value2;
		
		$("#st_burq_no"+currIndex).val(value1);
		$("#st_project_name"+currIndex).val(value2);
		if(currIndex == 1){
			var data = { st_burq_no : value1};
			kepAjaxCallNoBar("/mprq/getProjectRemark.do",data,"burqremark");  
		}
	}else if(popupSel =="giveUp") {
		if(value1=='1'){
			doAction('search');
		}
	}else if(popupSel =="priceUpload") {
		if(value1=='1'){
			doAction('search');
		}
	}else if(popupSel == "popMulti") {	// 일괄등록
		var checkRows = Sheet.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		for(var idx=0; idx<arrRow.length; idx++){
			if(value1 != ""){ // 거래유형
				Sheet.SetCellValue(arrRow[idx], 'AGENT_PROCESS_TYPE', value2);
			}
			if(value2 != ""){ // 배송유형
				Sheet.SetCellValue(arrRow[idx], 'AGENT_PARCEL_YN', value3);
			}
			if(value3 != ""){ // 조달일수
				Sheet.SetCellValue(arrRow[idx], 'DELIVERY_LT', value1);
			}
		}
	}
}

function thisPopClose(){
	closePopText2();
	doAction('search');
}

/**
 * 프로젝트 견적 안내 팝업 열기 (버튼 클릭 시)
 */
function openBulkNoticePopup() {
    var NOTICE_POPUP_KEY = 'mro_bulk_notice_state';
    var state = localStorage.getItem(NOTICE_POPUP_KEY);
    var isCacheCleared = (state === 'cache_cleared');

    PopupUtil.open({
        url: '/resources/html/common/popup/popup_bulk_notice.html',
        animation: 'fromButton',
        data: {
            isFirstVisit: false,      // 버튼 클릭 모드
            isCacheCleared: isCacheCleared
        }
    });
}

/**
 * 최초 방문 시 자동 팝업 표시
 */
function showBulkNoticeAutoPopup() {
    var NOTICE_POPUP_KEY = 'mro_bulk_notice_state';
    var noticeState = localStorage.getItem(NOTICE_POPUP_KEY);

    if (!noticeState || noticeState === 'pending') {
        // pending 상태 설정 (Ctrl+Shift+R 감지 대비)
        localStorage.setItem(NOTICE_POPUP_KEY, 'pending');

        PopupUtil.open({
            url: '/resources/html/common/popup/popup_bulk_notice.html',
            animation: 'fromButton',
            data: {
                isFirstVisit: true,       // 최초 방문 모드 (스크롤 가이드 표시)
                isCacheCleared: false
            }
        });
    } else if (noticeState === 'cache_cleared') {
        // 캐시 삭제 후 재방문
        PopupUtil.open({
            url: '/resources/html/common/popup/popup_bulk_notice.html',
            animation: 'fromButton',
            data: {
                isFirstVisit: true,
                isCacheCleared: true      // 체크마크 표시
            }
        });
    }
    // 'completed' 상태면 자동 팝업 안 뜸
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
           	프로젝트 견적
            <button class="But_Info" style="cursor: pointer;" onclick="openBulkNoticePopup(); return false;"></button>
          <div class="SummaryGuide">
      	    <ul>
        	  <li><img src="/resources/imgs/Icon_Home.png" /></li>
        	  <li>견적 관리</li>
              <li>프로젝트 견적</li>
            </ul>
          </div>
        </div>
        <div class="SubSearchTab">
         <button class="TabTit" data-tab="Search1">전체</button>
         <button class="TabTit active" data-tab="Search2">견적요청</button>
        </div>
    <form id="searchCondition0" name="searchCondition0" method="post">
		<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
				<input type="hidden" id="upperId0"  name="upperId" value="<c:out value="${param.upperId}"/>">    
				<input type="hidden" id="st_query0" name="st_query" value ="">
        <div id="Search1" class="SearchContent">
          <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" />모든 요청건은 코리아이플랫폼의 사정에 따라 조기 마감될 수 있습니다.</div>
          <table class="SearchTable03" >
            <colgroup>
              <col width="80px" />
              <col width="550px" />
              <col width="80px" />
              <col width="250px" />
              <col width="80px" />
              <col width="240px" />
            </colgroup>        	
            <tr>
              <th>기간</th>
              <td>
                <select name="st_date_type" id="st_date_type" class="Select" style=" float:left;width:140px; margin-right:5px">
                  	<option value="ADD" selected="selected">견적요청일</option>
					<option value="END">견적마감일</option>
					<option value="SAVE">견적제출일</option>
                </select>
                <div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date_0" name="st_from_date" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_0" name="st_to_date" readonly /><span></span></div>
                </div>
                <button class="But_MonthSmall" data-group="tab0" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','1'); return false;">1개월</button> 
                <button class="But_MonthSmall" data-group="tab0" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','6'); return false;">6개월</button>
                <button class="But_MonthSmall" data-group="tab0" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','12'); return false;">1년</button>
              </td>
              <th>프로젝트명</th>
              <td>
                  <input type="text"class="input30" id="st_project_name0" name="st_project_name" style=" width:198px; " onKeyDown="kepEnter_v2();">
			  </td>
              <th>품목구분</th>
              <td><select name="st_agent_type" id="st_agent_type0" class="Select" style="width:220px;">
                  	<option value="" selected>전체</option>
					<option value="A">신규</option>
					<option value="B">재계약</option>
                </select> 
              </td>
			</tr>
            <tr>
              <th>견적번호</th>
              <td><input class="input30" style="width:490px;" name="st_burq_rfq_no" id="st_burq_rfq_no0" type="text" placeholder="여러 개의 견적번호로 조회 가능하며 띄어쓰기 없이 콤마(,)로 구분해서 입력해주세요."  onKeyDown="kepEnter_v2();"/></td>
              <th>고객사</th>
              <td><input class="input30" style="width:198px" name="st_buyer_name" id="st_buyer_name0" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>진행상태</th>
              <td><select name="st_sourcing_status" id="st_sourcing_status0" class="Select" style="width:220px;">
                  	<option value="" selected>전체</option>
					<option value="K1">견적요청</option>
					<option value="S1">견적제출</option>
					<option value="K2">견적마감</option>
                </select> 
              </td>   
            </tr>
            <tr> 
              <th>품목명</th>
              <td><input class="input30" style="width:490px" name="st_description" id="st_description0" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>규격</th>
              <td><input class="input30" style="width:198px" name="st_specification" id="st_specification0" type="text" onKeyDown="kepEnter_v2()"/></td>                                                    
              <th>제조사</th>
              <td><input class="input30" style="width:198px" name="st_maker_name" id="st_maker_name0" type="text" onKeyDown="kepEnter_v2()"/></td> 
            </tr>
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="doAction('search');return false;">조회</button> 
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40" onclick="javscript:doAction('excelDown'); return false;">엑셀다운로드</button>
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
			<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
			<input type="hidden" id="st_query1" name="st_query" value ="">
        <div id="Search2" class="SearchContent active">
          <div class="Importance" style="height: 100%;">
          	<img src="/resources/imgs/Icon_Importance.png" />
          	<span>견적은 마감 전까지 수정 가능하나 조기 마감될 수 있으며, 도착도 기준 동일품 우선(불가 시 대체품 제안), 최소주문수량·발주배수단가(부가세 별도)를 정확히 입력해 주시기 바랍니다.</span>
			<br>
			<img src="/resources/imgs/Icon_Importance.png"/>
			<span>물류수수료 평균 <span id="logis_fee"></span>% 적용  - 품목별 상이할 수 있습니다. * KeP 물류센터 : 중앙HUB(군포시 부곡동) · 대전(청주시 서원구 현도면) · 구미(칠곡군 석적읍) · 창원(의창구 팔용동) · 광주(광산구 안청동)</span>
			<div id="remark">
			</div>
		  </div>
          <table class="SearchTable03" >
            <colgroup>
              <col width="80px" />
              <col width="550px" />
              <col width="80px" />
              <col width="250px" />
              <col width="80px" />
              <col width="240px" />
            </colgroup>        	
            <tr>
              <th>프로젝트</th>
              <td><div class="SearchBuyer" style="width:510px; ">
                  <input type="text" placeholder=" " id="st_project_name1" name="st_project_name" style=" width:490px; " onKeyDown="kepEnter_v2();" readonly onclick="javascript:doPop('selProject');">
                  <input type="hidden" name="st_burq_no" id="st_burq_no1" value="">
                  <button type="button" onclick="javascript:doPop('selProject'); return false;">고객사명</button>
                </div>
			  </td>
              <th>품목구분</th>
              <td><select name="st_agent_type" id="st_agent_type1" class="Select" style="width:220px;">
                  	<option value="" selected>전체</option>
					<option value="A">신규</option>
					<option value="B">재계약</option>
                </select> 
              </td>
              <th>진행상태</th>
              <td><select name="st_sourcing_status" id="st_sourcing_status1" class="Select" style="width:220px;">
                  	<option value="" selected>전체</option>
					<option value="K1">견적요청</option>
					<option value="S1">견적제출</option>
                </select> 
              </td>
			</tr>
            <tr>
              <th>견적번호</th>
              <td><input class="input30" style="width:490px;" name="st_burq_rfq_no" id="st_burq_rfq_no1" type="text" placeholder="여러 개의 견적번호로 조회 가능하며 띄어쓰기 없이 콤마(,)로 구분해서 입력해주세요."  onKeyDown="kepEnter_v2();"/></td>
              <th>고객사</th>
              <td><input class="input30" style="width:198px" name="st_buyer_name" id="st_buyer_name1" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>제조사</th>
              <td><input class="input30" style="width:198px" name="st_maker_name" id="st_maker_name1" type="text" onKeyDown="kepEnter_v2()"/></td>    
            </tr>
            <tr> 
              <th>품목명</th>
              <td><input class="input30" style="width:490px" name="st_description" id="st_description1" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>규격</th>
              <td><input class="input30" style="width:198px" name="st_specification" id="st_specification1" type="text" onKeyDown="kepEnter_v2()"/></td>                                                    
              <th>모델명</th>
              <td><input class="input30" style="width:198px" name="st_model_no" id="st_model_no1" type="text" onKeyDown="kepEnter_v2()"/></td> 
            </tr>
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="doAction('search');return false;">조회</button> 
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40" onclick="javscript:doAction('excelDown'); return false;">엑셀다운로드</button>
            &nbsp;<button class="ButM_Outline" onclick="javascript:doPop('priceUpload'); return false;">단가 업로드</button>
            &nbsp;<button class="ButM_Outline" onclick="javascript:doPop('popMulti'); return false;">일괄 등록</button>
            &nbsp;<button class="ButM_Outline" onclick="javascript:doAction('tempSave'); return false;">임시저장</button>
            </div>
            <div class="right">
              <button class="ButM_Outline" onclick="javascript:doAction('setSamePrice'); return false;">(재계약) 동일단가 적용</button>
              <button class="ButM_Outline" onclick="javascript:doAction('cancelSubmit'); return false;">견적제출 취소</button>
              <button class="ButM_Outline" onclick="javascript:doPop('giveUp'); return false;">견적포기</button>
              <button class="ButMPrimary" onclick="javascript:doAction('submit'); return false;">견적제출</button>
            </div>
          </div>
          <div class="IBSheet">
          	<script type="text/javascript">
          		createIBSheet("mySheet1", "", "100%");
          	</script>
          </div><!--IBSheet 끝 --> 
          <div class="h5" style="height: 50px;"></div>         
        </div><!--id="Search2" 전체 끝 --> 
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
            	  doAction('search');
              }else if(currIndex == 1){
            	  Sheet = mySheet1;
              }
            });
          });
          
          
          //입력했을때 앞 공백 제거
          const inputs = document.querySelectorAll("input[name=st_burq_rfq_no],input[name=st_description],input[name=st_specification],input[name=st_project_name],input[name=st_buyer_name],input[name=st_model_no],input[name=st_model_no]");
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
