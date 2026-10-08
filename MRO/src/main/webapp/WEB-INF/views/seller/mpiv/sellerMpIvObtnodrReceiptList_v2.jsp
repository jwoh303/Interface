<%--
**********************************************
* 메뉴 : 납품관리>수주접수
* 화면 : 수주접수
* 기능 : 수주내역을 조회하고 접수처리 하기 위한 화면
* 프로그램 ID : SU0502001
* 담당자 : 최찬규
* 착수일 : 2025-09-22
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
	// 공통
	@SuppressWarnings (value="unchecked")
	String user_id      = _sessionInfo.getUserId();
	String com_code 	= _sessionInfo.getComCode();
    String menuId = (String) request.getParameter("menuId");

    if(myMenuListHeader != null){ //null이 아닌 경우에만 체크
    	for(int i = 0; i<myMenuListHeader.size(); i++){
    		if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
    			myMenuFlag = true;
    			break;
    		}
    	}
    }

	//SLOGIC-END
	
	// MSDS 수주접수 통제 예외 협력사 확인
	boolean p060000079 = CommonUtil.getSpecialCheckReturn(com_code,"P06-0000079");
	
	// 보관조건, 보관온도 입력 필수 대상 고객사
// 	String p070000033 = "";
// 	Map<String, String> p070000033_map = CommonUtil.getSpecialCheckReturnMap(p_buyer,"P07-0000033");
// 	if (p070000033_map != null){
// 		p070000033= CommonUtil.nvl(p070000033_map.get("COL01_DATA"),""); // 유형별 값
// 	}
	
%> 

<script type="text/javascript"> 
var mySheet0 = new ibsheetObject();
var mySheet1 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var grbSrc = "";

var productGbn = KepSheetComboData("M132","SEL");
var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};

var currIndex=0;
var Sheet;

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var reject_yn = "N"; // 수주거부 입력
var g_query = "";

//최초 화면 함수 
function kep_onload_view(){
Sheet = mySheet0; //첫화면에선 mySheet0;
	
	//초기 날짜 셋팅
	var indexLength = $("input[name=st_from_date]").length;
	for(var i = 0; i<indexLength; i++){
		if($("input[name=st_from_date]").eq(i).val() ==  ""){
			$("input[name=st_from_date]").eq(i).val(kepToMonthAdd("3","M"));
			$("input[name=st_to_date]").eq(i).val(kepGetNowTimeStr('YYYYMMDD','/'));
		}
	}
	
	//RD_DATE=고객수령희망일, ST_DATE=표준납품일
	var initsheet0 = {};
	initsheet0.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet0.Cols = [
						{ Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
						,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"PO_CREATE_DATE",		Header:"발주일",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"PO_NO",				Header:"발주번호",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",				Type:"Text", 		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"BUYER",				Header:"고객사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
						,{ Align:"Center",	SaveName:"PROCESS_TYPE_TEXT",	Header:"거래유형",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Right",	SaveName:"PO_SEQ",				Header:"품목수",				Type:"Int",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Right",	SaveName:"PO_AMT",				Header:"발주총금액",			Type:"Float",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}
						,{ Align:"Center",	SaveName:"RD_DATE",				Header:"고객수령희망일",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"ST_DATE",				Header:"표준납품일",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"URGENT_YN",			Header:"긴급발주",			Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"BFRE_STCK_YN",		Header:"선입고",			Type:"Date",		Width:70,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"SBUTTON",				Header:"수주접수",				Type:"Image",		Cursor:"Pointer",Width:100,	Edit:false,	EditLen:100,	Hidden:false,BackColor:"${optColor}"}
						,{ Align:"Left",	SaveName:"PO_REMARK",			Header:"비고",				Type:"Text",		Width:505,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"거래유형",				Type:"Combo",		Width:90,	Edit:false,	EditLen:100,	Hidden:true,	ComboText:"직납|TR",	ComboCode:"0|2"}
						,{ Align:"Left",	SaveName:"KEP_USER_INFO",		Header:"KeP담당자",			Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:true}
						,{ Align:"Center",	SaveName:"PORS_CHECK",			Header:"PORS_CHECK",		Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
						,{ Align:"Center",	SaveName:"BUYER2",				Header:"BUYER2",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
						,{ Align:"Center",	SaveName:"SELLER",				Header:"SELLER",			Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
	];
	
	var initsheet1 = {};
	initsheet1.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet1.Cols = [
					{ Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"PO_CREATE_DATE",		Header:"발주일",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
					,{ Align:"Center",	SaveName:"PO_NO",				Header:"발주번호",				Type:"Text",		FontColor:"#3a72c7", Cursor:"Pointer",Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",				Type:"Text", 		Width:200,	Edit:false,	EditLen:100,	Hidden:false}							
					,{ Align:"Center",	SaveName:"BUYER",				Header:"고객사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
					,{ Align:"Center",	SaveName:"PROCESS_TYPE_TEXT",	Header:"거래유형",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"BUYER2",				Header:"BUYER2",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
					,{ Align:"Center",	SaveName:"PO_SEQ",				Header:"발주항번",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text", 		FontColor:"#3a72c7", Cursor:"Pointer",Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"품목명",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"거래유형",				Type:"Combo",		Width:90,	Edit:false,	EditLen:100,	Hidden:true,	ComboText:"직납|TR",	ComboCode:"0|2"}
					,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",				Type:"Text",		Width:300,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"RD_DATE",				Header:"고객수령희망일",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
					,{ Align:"Center",	SaveName:"DS_GUBUN",			Header:"납품구분",				Type:"CheckBox",	Width:110,	Edit:true,	EditLen:100,	Hidden:false, ItemText:"전량|분할",  ItemCode:"전량|분할", MaxCheck:1, RadioIcon:1,BackColor:"${optColor}"}
					,{ Align:"Center",	SaveName:"DS_DATE",				Header:"납품예정일",			Type:"Date",		Width:115,	Edit:true,	EditLen:10,	Hidden:false,BackColor:"${optColor}",Format:"yyyy-MM-dd"}
					,{ Align:"Center",	SaveName:"DELAY_REASON_COMBO",	Header:"지연사유",				Type:"Combo",		Width:140,	Edit:false,	EditLen:100,	Hidden:false, ComboText:"선택|재고부족|수입지연|제작지연|발주확인지연|기타",	ComboCode:"|재고부족|수입지연|제작지연|발주확인지연|기타"}
					,{ Align:"Left",	SaveName:"DELAY_REASON_TEXT",	Header:"지연사유",				Type:"Text",		Width:140,	Edit:false,	EditLen:100,	Hidden:false,BackColor:"${optColor}"}
					,{ Align:"Left",	SaveName:"DELAY_REASON",		Header:"지연사유",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Right",	SaveName:"UNIT_PRICE",			Header:"단가",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Format:"${priceFormat}"}
					,{ Align:"Right",	SaveName:"ITEM_QTY",			Header:"수량",				Type:"Float",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Right",	SaveName:"ITEM_AMT",			Header:"주문금액",				Type:"Float",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}
					,{ Align:"Center",	SaveName:"IMAGE_KEY_YN",		Header:"파일첨부",				Type:"Button",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type02'}
					,{ Align:"Center",	SaveName:"IMAGE_KEY",			Header:"파일첨부",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Left",	SaveName:"MAKER_PART_NO",		Header:"모델번호",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"URGENT_YN",			Header:"긴급발주여부",			Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"BFRE_STCK_YN",		Header:"선입고여부",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
					,{ Align:"Left",	SaveName:"PO_REMARK",			Header:"품목비고",				Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"ITEM_MAKE_TYPE_TEXT",	Header:"품목구분",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"ITEM_MAKE_TYPE",		Header:"품목구분",				Type:"Combo",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Left",	SaveName:"KEP_USER_INFO",		Header:"KeP담당자",			Type:"Text",		Width:160,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"PO_HD_REMARK",		Header:"비고",				Type:"Text",		Width:470,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"ST_DATE",				Header:"표준납품일",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
					
					,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",	Header:"BYIT_COMORG_CODE",	Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"CONTRACT_NO",			Header:"CONTRACT_NO",		Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"CONTRACT_SEQ",		Header:"CONTRACT_SEQ",		Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"SELLER",				Header:"SELLER",			Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
				
					,{ Align:"Center",	SaveName:"PORS_CHECK",			Header:"PORS_CHECK",		Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
					,{ Align:"Center",	SaveName:"DS_FLAG",				Header:"DS_FLAG",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"EXP_DS_FLAG",			Header:"EXP_DS_FLAG",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"H_DS_FLAG",			Header:"H_DS_FLAG",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"COD_CHECK",			Header:"MSDS대상",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"MSDS_CHECK",			Header:"MSDS매핑필요",			Type:"Text",		Width:110,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"REQ_CHECK",			Header:"REQ_CHECK",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"TEMP_REQ_CHECK",			Header:"TEMP_REQ_CHECK",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					
					,{ Align:"Center",	SaveName:"TEMP_CHECK",			Header:"TEMP_CHECK",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"HARMFUL_CHECK",		Header:"유해화학물질",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"SG118_CHECK",			Header:"SG118_CHECK",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"BUYER_NEED_DELI",		Header:"BUYER_NEED_DELI",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"QUERY_TEXT",			Header:"QUERY_TEXT",		Type:"Text",		Width:80,	Edit:false,	Hidden:true}
					,{ Align:"Center",	SaveName:"REJECT_REASON",		Header:"REJECT_REASON",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"REJECT_REASON_TEXT",	Header:"REJECT_REASON_TEXT",Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"REJECT_IMAGE_KEY",	Header:"REJECT_IMAGE_KEY",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"PROCESS_TYPE",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"PH_PO_DATE",			Header:"PH_PO_DATE",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"WAREHOUSE_CODE",		Header:"WAREHOUSE_CODE",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"TR_WAREHOUSE_YN",		Header:"TR_WAREHOUSE_YN",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"BUY_CLOSE_DATE_CHK",	Header:"BUY_CLOSE_DATE_CHK",Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"TEMP_COND",			Header:"TEMP_COND",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"P070000033",			Header:"P070000033",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"TR_BUYER",			Header:"TR_BUYER",			Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"DELY_TO_LOCATION_TEXT",			Header:"도착지주소",			Type:"Text",		Width:350,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"MAKER_NAME",			Header:"제조사",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"PO_CNT",				Header:"PO_CNT",				Type:"Int",		Width:70,	Edit:false,	EditLen:100,	Hidden:true}
					
	];
	
	IBS_InitSheet(mySheet0, initsheet0, pagingMode);
	IBS_InitSheet(mySheet1, initsheet1, pagingMode);
	
	mySheet1.SetColProperty("ITEM_MAKE_TYPE", comboInfo);
	
	mySheet0.SetHighlightAfterSort(2);
	mySheet1.SetHighlightAfterSort(2);
	
	mySheet0.SetCountFormat(" 총  ROWCOUNT 건 ");
	mySheet1.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet0.SetHeaderBackColor("#f2f7ff");
	mySheet1.SetHeaderBackColor("#f2f7ff");
	
	mySheet0.SetTheme("DB", "DeepBlue");
	mySheet1.SetTheme("DB", "DeepBlue");
	
// 	var datePickerInstance = new IBSheetDatePicker(mySheet1, {
// 	    columns: ['DS_DATE'],  // 달력을 적용할 컬럼들
// 	    dateFormat: '-',                         // 날짜 구분자 (YYYY.MM.DD)
// 	    displayFormat:'YYYY-MM-DD',
// 	    saveFormat: 'YYYYMMDD',               // 저장 형식
// 	    yearFirst: true,                         // 년도를 월 앞에 표시
// 	    autoClose: false,                        // 날짜 선택 후 자동 닫기 비활성화
// 	    autoInit: true,                          // 자동 초기화
// 	    onChange: function(data) {
// 	        console.log('[사용자 콜백] 날짜 변경:', data);
// 	    }
// 	});
	
	doAction("search");	
	
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

	for(var i = 1; i<=Sheet.RowCount();i++){
		Sheet.SetCellValue(i,"DS_GUBUN","전량:1|분할:0");
		
		// 납품예정일 기본 설정(고객수령희망일 or 오늘일자) 및 납품지연사유 활성화 로직(표준납품일 기준)
		var today_date = kepGetNowTimeStr('YYYYMMDD','');
		var ds_date = Sheet.GetCellValue(i, "DS_DATE");
		var rd_date = Sheet.GetCellValue(i, "RD_DATE");
		var st_date = Sheet.GetCellValue(i, "ST_DATE"); 
		var delay_reason = Sheet.GetCellValue(i, "DELAY_REASON");
		
		// 납품예정일 기본 설정
		if(rd_date > today_date){
			Sheet.SetCellValue(i,"DS_DATE", rd_date);
		}else{
			Sheet.SetCellValue(i,"DS_DATE", today_date);
		}
		
		// 변경된 납품예정일로 지연사유 판단
		if(st_date < Sheet.GetCellValue(i, "DS_DATE") && delay_reason == ""){
			Sheet.SetCellEditable(i, "DELAY_REASON_COMBO", true);
			Sheet.SelectCell(i, "DELAY_REASON_COMBO");
		}else if(st_date >= Sheet.GetCellValue(i, "DS_DATE")){
			Sheet.SetCellEditable(i, "DELAY_REASON_COMBO", false);
			Sheet.SetCellValue(i, "DELAY_REASON_COMBO", "");
			Sheet.SetCellValue(i, "DELAY_REASON_TEXT", "");
		}
	}
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
//그리드 셀클릭 이벤트
function mySheet0_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_buyer = Sheet.GetCellValue(Row, "BUYER");
	var st_buyer2 = Sheet.GetCellValue(Row, "BUYER2");
	var st_po_no = Sheet.GetCellValue(Row, "PO_NO");
	var st_po_seq = Sheet.GetCellValue(Row, "PO_SEQ");
	var st_pors_check = Sheet.GetCellValue(Row, "PORS_CHECK");
	
	if(column == "SBUTTON"){ //수주접수 버튼
		if(st_pors_check == "Y"){
// 			alert("고객사 이슈로 수주 접수 불가, 담당자에게 문의 바랍니다.\n 최병관 책임(02-3016-8931), 배인영 사원(02-3016-8933)");
			var text = "고객사 이슈로 수주 접수 불가, 담당자에게 문의 바랍니다.</br>최병관 책임(02-3016-8931), 배인영 사원(02-3016-8933)";
			openLayerPopText2(text,but1text,but1func,but1width);
    		return;
		}
		var src = "/mpiv/sellerMpIvObtnodrReceiptDetailPop_v2.do?st_buyer="+st_buyer+"&st_po_no="+st_po_no; 
		openLayerPop(src,"1240px","850px");
		
// 		openSearchPopup("/mpiv/sellerMpIvObtnodrReceiptDetailPop_v2.do", "?st_buyer="+st_buyer+"&st_po_no="+st_po_no, "1240,800,no");
	}
	
	return;
}
//그리드 셀클릭 이벤트
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_buyer = Sheet.GetCellValue(Row, "BUYER");
	var st_buyer2 = Sheet.GetCellValue(Row, "BUYER2");
	var st_po_no = Sheet.GetCellValue(Row, "PO_NO");
	var st_po_seq = Sheet.GetCellValue(Row, "PO_SEQ");
	var st_image_key = Sheet.GetCellValue(Row, "IMAGE_KEY");
	var st_buyer_item_no = Sheet.GetCellValue(Row, "BUYER_ITEM_NO");
	var st_byit_comorg_code = Sheet.GetCellValue(Row,"BYIT_COMORG_CODE");
	var st_contract_no = Sheet.GetCellValue(Row,"CONTRACT_NO");
	var st_contract_seq = Sheet.GetCellValue(Row,"CONTRACT_SEQ");
	
	if(column == "PO_NO"){
		var src = "/mpiv/commonMpIvOrderInfoPop_v2.do?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status=수주접수대상"; 
		openLayerPop(src,"1240px","850px");
// 		openSearchPopup("/mpiv/commonMpIvOrderInfoPop_v2.do", "?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status=수주접수대상", "1240,770,no");
	}
	if(column == "IMAGE_KEY_YN"){
		if(Sheet.GetCellValue(Row,"IMAGE_KEY_YN") != ""){
			location.href="/common/download_v2.do?DOC_NO="+st_image_key;
		}
	}
	if(column == "BUYER_ITEM_NO"){
		var src = "/common/catalogDetailPop.do?open=Y&BUYER="+st_byit_comorg_code+"&BUYER_ITEM_NO="+escape(st_buyer_item_no)+"&CONTRACT_NO="+st_contract_no+"&CONTRACT_SEQ="+st_contract_seq+"&popupCheck=N";
		openLayerPop(src,"650px","600px");
		
// 		openSearchPopup("/common/catalogDetailPop.do","?open=Y&BUYER="+st_buyer+"&BUYER_ITEM_NO="+escape(st_buyer_item_no)+"&CONTRACT_NO="+st_contract_no+"&CONTRACT_SEQ="+st_contract_seq,"650,600,no");
	}
	if(column == "DS_GUBUN"){
		if(Sheet.GetCellValue(Row, "DS_GUBUN") == "전량:1|분할:0"){ //전량선택
			Sheet.SetCellValue(Row,"QUERY_TEXT",""); //분할납품 입력했던거 초기화
			Sheet.SetCellValue(Row,"DS_FLAG","N");
			Sheet.SetCellValue(Row,"BUYER_NEED_DELI","N");
		}
		if(Sheet.GetCellValue(Row, "DS_GUBUN") == "전량:0|분할:1"){ //분할선택
			// 특수로직 - 분할납품 제한 고객사 체크
			if(Sheet.GetCellValue(Row,"EXP_DS_FLAG") == "Y") {
// 				alert("분할납품이 불가능한 고객사입니다.");
				var text = "분할납품이 불가능한 고객사입니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				Sheet.SetCellValue(Row,"DS_GUBUN","전량:1|분할:0");
				return;
			}else{
				if(Sheet.GetCellValue(Row,"DS_FLAG") == "Y"){
					var po_no = Sheet.GetCellValue(Row, "PO_NO");
					var buyer = Sheet.GetCellValue(Row, "BUYER");
					var po_seq = Sheet.GetCellValue(Row, "PO_SEQ");
					var po_qty = Sheet.GetCellValue(Row, "ITEM_QTY");
					var seller = Sheet.GetCellValue(Row, "SELLER");
					var ds_flag = Sheet.GetCellValue(Row, "DS_FLAG");
					var st_date = Sheet.GetCellValue(Row, "ST_DATE");
					var ds_delay_reason = Sheet.GetCellValue(Row, "DELAY_REASON");
					var check_flag = Sheet.GetCellValue(Row, "BUYER_NEED_DELI");
					var po_create_date = Sheet.GetCellValue(Row, "PH_PO_DATE");
					var description = Sheet.GetCellValue(Row,"DESCRIPTION");
					var query_text = Sheet.GetCellValue(Row,"QUERY_TEXT");
					
					var src = "/mpiv/showSellerMpIvDivsnDeliveryPlanEntryPop.do?po_no="+po_no+"&buyer="+buyer +"&po_seq="+po_seq +"&po_qty="+po_qty+"&seller="+seller+"&ds_flag="+ds_flag+"&st_date="+st_date+"&ds_delay_reason="+encodeURIComponent(ds_delay_reason)+"&query_text="+query_text+"&check_flag="+check_flag+"&po_create_date="+po_create_date+"&description="+encodeURIComponent(description)+"&popupCheck=N"; 
					openLayerPop(src,"640px","760px");
				}else{
					
					var text = "분할하여 납품하시겠습니까?";
					var but1textC = "확인";
					var but2textC = "취소";
					var but1funcC = "javascript:showSellerMpIvDivsnDeliveryPlanEntryPop(); return false;";
					var but2funcC = "javascript:closePopText1(); return false;";
					var but1widthC = "120px";
					var but2widthC = "120px";
					openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
					
// 					if(!confirm("분할하여 납품하시겠습니까?")) return;
				}
// 				openSearchPopup("/mpiv/showSellerMpIvDivsnDeliveryPlanEntryPop.do", "?po_no="+po_no+"&buyer="+buyer +"&po_seq="+po_seq +"&po_qty="+po_qty+"&seller="+seller+"&ds_flag="+ds_flag+"&st_date="+st_date+"&ds_delay_reason="+ds_delay_reason+"&query_text="+query_text+"&check_flag="+check_flag+"&po_create_date="+po_create_date+"&description="+description, "640,760,no");
			}
		}
	}
	return;
}
function mySheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag){
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if(column == "DELAY_REASON_COMBO"){
		if(Sheet.GetCellValue(Row, "DELAY_REASON_COMBO") == "기타"){ //기타면 사유 입력 가능하도록
			Sheet.SetCellValue(Row,"DELAY_REASON","");
			Sheet.SetCellEditable(Row, "DELAY_REASON_TEXT", true);
			Sheet.SelectCell(Row,"DELARY_REASON_TEXT");
		}else{ //기타 아니면 선택한 사유를 reason에 저장
			Sheet.SetCellValue(Row,"DELAY_REASON",Sheet.GetCellValue(Row, "DELAY_REASON_COMBO"));
			Sheet.SetCellValue(Row,"DELAY_REASON_TEXT","");
			Sheet.SetCellEditable(Row, "DELAY_REASON_TEXT", false);
		}
	}
	if(column == "DELAY_REASON_TEXT"){ //기타인 경우 입력한 text를 reason에 저장
		if(Sheet.GetCellValue(Row, "DELAY_REASON_COMBO") == "기타" && Sheet.GetCellValue(Row, "DELAY_REASON_TEXT") != ""){
			Sheet.SetCellValue(Row,"DELAY_REASON",Sheet.GetCellValue(Row, "DELAY_REASON_TEXT"));
		}
	}
	if(column == "DS_GUBUN"){
		//이전꺼랑 비교해서 checkbox 해제 안되도록
		if(OldValue == "전량:1|분할:0" && Value == "전량:0|분할:0"){  
			Sheet.SetCellValue(Row,"DS_GUBUN","전량:1|분할:0");
		}
		if(OldValue == "전량:0|분할:1" && Value == "전량:0|분할:0"){
			Sheet.SetCellValue(Row,"DS_GUBUN","전량:0|분할:1");
		}
		if(OldValue == "전량:1|분할:0" && Value == "전량:0|분할:1"){  
			Sheet.SetCellValue(Row,"DS_DATE","");
			Sheet.SetCellValue(Row,"DELAY_REASON","");
			Sheet.SetCellValue(Row,"DELAY_REASON_TEXT","");
			Sheet.SetCellValue(Row,"DELAY_REASON_COMBO","");
			Sheet.SetCellEditable(Row,"DS_DATE",false);
			Sheet.SetCellEditable(Row,"DELAY_REASON_TEXT",false);
			Sheet.SetCellEditable(Row,"DELAY_REASON_COMBO",false);
		}
		if(OldValue == "전량:0|분할:1" && Value == "전량:1|분할:0"){  //전량에서 분할 바뀌면 데이터 싹 초기화
			Sheet.SetCellValue(Row,"DS_DATE","");
			Sheet.SetCellValue(Row,"DELAY_REASON","");
			Sheet.SetCellValue(Row,"DELAY_REASON_TEXT","");
			Sheet.SetCellValue(Row,"DELAY_REASON_COMBO","");
			Sheet.SetCellEditable(Row,"DS_DATE",true);
			Sheet.SetCellValue(Row,"QUERY_TEXT",""); //분할납품 입력했던거 초기화
			Sheet.SetCellValue(Row,"DS_FLAG","N");
			Sheet.SetCellValue(Row,"BUYER_NEED_DELI","N");
		}
	}
	if(column == "DS_DATE"){ 
		var st_date = Sheet.GetCellValue(Row, "ST_DATE");
		var ds_date = Sheet.GetCellValue(Row, "DS_DATE");
		var delay_reason = Sheet.GetCellValue(Row, "DELAY_REASON");
		var cur_date = kepGetNowTimeStr("YYYYMMDD","");
		if(ds_date < cur_date && ds_date !=""){
// 			alert("납품예정일을 금일 이후 날짜로 입력하여 주십시요.");
			var text = "납품예정일을 금일 이후 날짜로 입력해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			Sheet.SetCellValue(Row,"DS_DATE","");
			Sheet.SelectCell(Row,"DS_DATE");
            return;
		}
		if(st_date < ds_date && delay_reason == ""){
// 			alert("납품지연사유를 입력하여 주십시요.");
			var text = "납품지연사유를 입력해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			Sheet.SetCellEditable(Row, "DELAY_REASON_COMBO", true);
			Sheet.SelectCell(Row,"DELAY_REASON_COMBO");
			return;
		}else if(st_date >= ds_date){
			Sheet.SetCellEditable(Row, "DELAY_REASON_COMBO", false);
			Sheet.SetCellValue(Row,"DELAY_REASON_TEXT","");
		}
	}
}
function showSellerMpIvDivsnDeliveryPlanEntryPop(){
	closePopText1();
	var po_no = Sheet.GetCellValue(grbRow, "PO_NO");
	var buyer = Sheet.GetCellValue(grbRow, "BUYER");
	var po_seq = Sheet.GetCellValue(grbRow, "PO_SEQ");
	var po_qty = Sheet.GetCellValue(grbRow, "ITEM_QTY");
	var seller = Sheet.GetCellValue(grbRow, "SELLER");
	var ds_flag = Sheet.GetCellValue(grbRow, "DS_FLAG");
	var st_date = Sheet.GetCellValue(grbRow, "ST_DATE");
	var ds_delay_reason = Sheet.GetCellValue(grbRow, "DELAY_REASON");
	var check_flag = Sheet.GetCellValue(grbRow, "BUYER_NEED_DELI");
	var po_create_date = Sheet.GetCellValue(grbRow, "PH_PO_DATE");
	var description = Sheet.GetCellValue(grbRow,"DESCRIPTION");
	var query_text = Sheet.GetCellValue(grbRow,"QUERY_TEXT");
	
	var src = "/mpiv/showSellerMpIvDivsnDeliveryPlanEntryPop.do?po_no="+po_no+"&buyer="+buyer +"&po_seq="+po_seq +"&po_qty="+po_qty+"&seller="+seller+"&ds_flag="+ds_flag+"&st_date="+st_date+"&ds_delay_reason="+encodeURIComponent(ds_delay_reason)+"&query_text="+query_text+"&check_flag="+check_flag+"&po_create_date="+po_create_date+"&description="+encodeURIComponent(description)+"&popupCheck=N"; 
	openLayerPop(src,"640px","760px");
}
function doAction(str) {
	switch (str) {
		case "search":	 //조회
			if (kep_dateSearchCheck($("#st_from_date_"+currIndex).val(),$("#st_to_date_"+currIndex).val()) == false) return;
			var diff = kepGetDateDiff('st_from_date_'+currIndex,'st_to_date_'+currIndex,'D');
			if (eval(diff)>372){
// 				alert("1년 이내 조회만 가능합니다.");
				var text = "1년 이내 조회만 가능합니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			
			if(currIndex == 0){
				kepSearch(document.searchCondition0, Sheet, "/mpiv/getSellerMpIvObtnodrReceiptList_v2.do" , pagingMode);
			}else if(currIndex == 1){
				kepSearch(document.searchCondition1, Sheet, "/mpiv/getSellerMpIvObtnodrReceiptMultiList_v2.do" , pagingMode);
			}
			break;
			
		case "reload":	//초기화
			kepReload_v2('searchCondition'+currIndex);
			kepMonth_v2('st_from_date_'+currIndex,'st_to_date_'+currIndex,'3');
			Sheet.RemoveAll();
			
			// hidden값은 공통에서 처리안됨.
			$("#st_buyer_code_"+currIndex).val("");
			break;
	
		case "excelDown": // 엑셀다운로드
			excelDownload();
			break;
	}
}

// 팝업 함수호출
function doPop(str,value1, value2, value3) {
	switch (str) {
		case "commonMpIvTranBuyerChoicePop": // 고객사선택
			openSearchPopup("/mpiv/getCommonMpIvTranBuyerChoicePop.do", "?st_com_code="+$("#st_com_code"+currIndex).val(), "750,530,no");
			break;
		case "dsDateDelayReasonMulti": //납품예정일,지연 사유입력
			var checkRows = Sheet.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			if(checkRows == "") {
// 				alert('선택된 데이터가 없습니다.');
				var text = "선택된 데이터가 없습니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			if(arrRow.length <2 ){
// 				alert("일괄등록은 2건 이상 선택이 필요합니다.");
				var text = "일괄등록은 2건 이상 선택이 필요합니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			
			var rowList = new Array();
			var rowJson = "";
			var gridJsonList = "";
			
			for(var idx = 0; idx<arrRow.length; idx++){
				var param = {
						"BUYER_NAME" : Sheet.GetCellValue(arrRow[idx],"BUYER_NAME")
						,"PO_NO" : Sheet.GetCellValue(arrRow[idx],"PO_NO")
						,"BUYER_ITEM_NO" : Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO")
						,"DESCRIPTION" : Sheet.GetCellValue(arrRow[idx],"DESCRIPTION")
						,"UNIT_PRICE" : Sheet.GetCellValue(arrRow[idx],"UNIT_PRICE")
						,"ITEM_QTY" : Sheet.GetCellValue(arrRow[idx],"ITEM_QTY")
						,"UNIT_MEASURE" : Sheet.GetCellValue(arrRow[idx],"UNIT_MEASURE")
						,"ITEM_AMT" : Sheet.GetCellValue(arrRow[idx],"ITEM_AMT")
						,"ST_DATE" : Sheet.GetCellValue(arrRow[idx],"ST_DATE")
					};
				rowJson = JSON.stringify(param);
				rowList.push(rowJson);
			}
		
			gridJsonList =  "[" + rowList.toString() + "]";
			
			var url = "/mpiv/showSellerMpIvDsDateDelayReasonMultiPop_v2.do";
			openLayerPop3(url,gridJsonList,"","850px","700px");
			
//  			$("#info").val(gridJsonList);
//  			openSearchPopupPost("/mpiv/showSellerMpIvDsDateDelayReasonMultiPop_v2.do", 'dsDateReasonAllForm', 'dsDateReasonAllForm', "width=850,height=700,resizable=no,scrollbars=no, top=100, left=200");
			break;
	}
}

function setBuyerChoiceReturn(buyer, com_name){
	$("#st_buyer_code_"+currIndex).val(buyer);
	$("#st_buyer_name_"+currIndex).val(com_name);
}

//분할납품 팝업 리턴
function setDSQuery(query,ds_date,buyer_need_check,delay_reason){
	Sheet.SetCellValue(Sheet.GetSelectRow(),"DS_FLAG","Y");
	Sheet.SetCellValue(Sheet.GetSelectRow(),"QUERY_TEXT",query);
	Sheet.SetCellValue(Sheet.GetSelectRow(),"BUYER_NEED_DELI",buyer_need_check);
	Sheet.SetCellEditable(Sheet.GetSelectRow(), "DS_DATE", false);
	if(delay_reason != ""){
		if(delay_reason != "" && delay_reason != "재고부족" && delay_reason != "수입지연" && delay_reason != "제작지연" && delay_reason != "발주확인지연"){ //기타인 경우
			Sheet.SetCellValue(Sheet.GetSelectRow(),"DELAY_REASON_COMBO","기타");
			Sheet.SetCellValue(Sheet.GetSelectRow(),"DELAY_REASON_TEXT",delay_reason);
			Sheet.SetCellValue(Sheet.GetSelectRow(),"DELAY_REASON",delay_reason);
			Sheet.SetCellEditable(Sheet.GetSelectRow(), "DELAY_REASON_TEXT", false);
			Sheet.SetCellEditable(Sheet.GetSelectRow(), "DELAY_REASON_COMBO", false);
		}else{
			Sheet.SetCellValue(Sheet.GetSelectRow(),"DELAY_REASON_COMBO",delay_reason);
			Sheet.SetCellValue(Sheet.GetSelectRow(),"DELAY_REASON_TEXT","");
			Sheet.SetCellValue(Sheet.GetSelectRow(),"DELAY_REASON",delay_reason);
			Sheet.SetCellEditable(Sheet.GetSelectRow(), "DELAY_REASON_TEXT", false);
			Sheet.SetCellEditable(Sheet.GetSelectRow(), "DELAY_REASON_COMBO", false);
		}
	}else{
		Sheet.SetCellValue(Sheet.GetSelectRow(),"DELAY_REASON_COMBO","");
		Sheet.SetCellValue(Sheet.GetSelectRow(),"DELAY_REASON_TEXT","");
		Sheet.SetCellValue(Sheet.GetSelectRow(),"DELAY_REASON","");
		Sheet.SetCellEditable(Sheet.GetSelectRow(), "DELAY_REASON_TEXT", false);
		Sheet.SetCellEditable(Sheet.GetSelectRow(), "DELAY_REASON_COMBO", false);
	}
	
	Sheet.SetCellValue(Sheet.GetSelectRow(),"DS_DATE",ds_date);
	
}
function setDsDateReason(flag,ds_gubun,ds_date,delay_reason){
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	for(var idx = 0; idx<arrRow.length; idx++){
		Sheet.SetCellValue(arrRow[idx],"DS_GUBUN",ds_gubun);
		if(flag == "all"){
			Sheet.SetCellEditable(arrRow[idx],"DS_DATE",true);
			Sheet.SetCellValue(arrRow[idx],"QUERY_TEXT",""); //분할납품 입력했던거 초기화
			Sheet.SetCellValue(arrRow[idx],"DS_FLAG","N");
			Sheet.SetCellValue(arrRow[idx],"BUYER_NEED_DELI","N");
			if(Sheet.GetCellValue(arrRow[idx],"ST_DATE") < ds_date){
				if(delay_reason != "" && delay_reason != "재고부족" && delay_reason != "수입지연" && delay_reason != "제작지연" && delay_reason != "발주확인지연"){ //기타인 경우
					Sheet.SetCellValue(arrRow[idx],"DELAY_REASON_COMBO","기타");
					Sheet.SetCellValue(arrRow[idx],"DELAY_REASON_TEXT",delay_reason);
					Sheet.SetCellValue(arrRow[idx],"DELAY_REASON",delay_reason);
					Sheet.SetCellEditable(arrRow[idx],"DELAY_REASON_COMBO",true);
					Sheet.SetCellEditable(arrRow[idx], "DELAY_REASON_TEXT", true);
				}else{
					Sheet.SetCellValue(arrRow[idx],"DELAY_REASON_COMBO",delay_reason);
					Sheet.SetCellValue(arrRow[idx],"DELAY_REASON_TEXT","");
					Sheet.SetCellValue(arrRow[idx],"DELAY_REASON",delay_reason);
					Sheet.SetCellEditable(arrRow[idx], "DELAY_REASON_TEXT", false);
					Sheet.SetCellEditable(arrRow[idx],"DELAY_REASON_COMBO",true);
				}
			}else{
				Sheet.SetCellValue(arrRow[idx],"DELAY_REASON_COMBO","");
				Sheet.SetCellValue(arrRow[idx],"DELAY_REASON_TEXT","");
				Sheet.SetCellValue(arrRow[idx],"DELAY_REASON","");
				Sheet.SetCellEditable(arrRow[idx], "DELAY_REASON_TEXT", false);
				Sheet.SetCellEditable(arrRow[idx], "DELAY_REASON_COMBO", false);
			}
			Sheet.SetCellValue(arrRow[idx],"DS_DATE",ds_date);
		}
	}
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
	
	// 선택된 항목 유무 체크
	if (checkRows.length == 0) {
// 		alert("상품을 선택해주세요.");
		var text = "항목을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	Sheet.SetWaitImageVisible(true);
	
	var downRow = "|0";
	for(var i=1; i<=Sheet.RowCount(); i++) {
		if(Sheet.GetCellValue(i,"SELECTED"))
			downRow += "|"+i;
	}
	
	var downCol = "";
	for(var i=0; i<=Sheet.LastCol(); i++){
		if(!Sheet.GetColHidden(i) && Sheet.ColSaveName(i) !="SELECTED" && Sheet.GetCellProperty(1, i, "Type") != "Image"){
			downCol += "|"+i;
		}
	}
	if(currIndex == 1){
		downCol = downCol+"|PO_SEQ|DELY_TO_LOCATION_TEXT|MAKER_NAME";
	}
	
	if(downRow == "|0"){
		downRow = "";
	}
	var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
	
	var fileName = "";
	if(currIndex == 0){
		fileName = "수주접수_PO별_";
	}else if(currIndex == 1){
		fileName = "수주접수_품목별_";
	}
	var param = {FileName:fileName+nowTime, SheetName:fileName, DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
	Sheet.Down2Excel(param);
}

//수주거부 팝업 호출
function setRejectReason(x){
	
	var returnData = customerAndPoCheck("수주거부");
// 	returnData = ["고객사코드","PO번호","true/false여부"];
	if(returnData[2]){
		grbSrc = "/mpiv/showSellerMpIvDeliveryRejectReasonPop.do?buyer="+returnData[0]+"&po_no="+returnData[1]; 
		
// 		alert("수주거부는 해당 발주번호 내 모든 품목에 적용되며, 납품이 불가합니다.");
		var text = "수주거부는 해당 발주번호 내 모든 품목에 적용되며, 납품이 불가합니다.";
		var but1funcTmp = "javascript:showSellerMpIvDeliveryRejectReasonPop(); return false;";
		openLayerPopText2(text,but1text,but1funcTmp,but1width);
		
		
		
// 		openSearchPopup("/mpiv/showSellerMpIvDeliveryRejectReasonPop.do", "?buyer="+returnData[0]+"&po_no="+returnData[1], "800,850,no");
	}
}
function showSellerMpIvDeliveryRejectReasonPop(){
	closePopText2();
	openLayerPop(grbSrc,"800px","850px");
	grbSrc = "";
}
// 수주거부 팝업 리턴
function setRejectReasonText(value1, value2, value3){ // 거부사유, 거부 상세사유, 첨부파일
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	// 선택된 항목 유무 체크
	if (checkRows.length == 0) {
// 		alert("품목을 선택해주세요.");
		var text = "품목을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	for(var idx=0; idx<arrRow.length; idx++){
		Sheet.SetCellValue(arrRow[idx],"REJECT_REASON",value1);
		Sheet.SetCellValue(arrRow[idx],"REJECT_REASON_TEXT",value2);
		Sheet.SetCellValue(arrRow[idx],"REJECT_IMAGE_KEY",value3);
		
		//나머지값들은 초기화
		Sheet.SetCellValue(arrRow[idx],"DS_FLAG","N");
		Sheet.SetCellValue(arrRow[idx],"DS_DATE","");
		Sheet.SetCellValue(arrRow[idx],"DELAY_REASON","");
		Sheet.SetCellValue(arrRow[idx],"DELAY_REASON_COMBO","");
		Sheet.SetCellValue(arrRow[idx],"DELAY_REASON_TEXT","");
		Sheet.SetCellEditable(arrRow[idx],"DELAY_REASON_TEXT",false);
		Sheet.SetCellValue(arrRow[idx],"BUYER_NEED_DELI","N");
	}
	
	reject_yn = "Y";
	
	setDeliverySchedule("수주거부");
}


//확인
function setDeliverySchedule(str){
		if(str == "수주접수"){
			var returnData = customerAndPoCheck("수주접수");
			if(!returnData[2]){
				return;
			}
		}
		
		var checkRows = Sheet.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		var query = "";
	    var check_cnt = 0;
	    var buyer        = "";
	    var po_no        = "";
	    var po_seq       = "";
	    var po_qty       = "";
	    var seller       = "";
	    var cd_date      = "";
	    var cd_qty       = "";
	    var ds_flag      = "";
	    var user_id      = "<%=user_id%>";
	    var delay_reason = "";
	    var max_cd_date = "";
	    var rd_date     = "";
	    var query_text  = "";
		var ds_date		= "";
		var st_date		= "";
		var reject_reason = "";
		var buyer_need_deli = "";
		var po_create_date = "";
		var reject_image_key = "";
		
		var cod_check	= ""; //ICOMCOD1 에 있는지 체크하는 변수
		var msds_check	= ""; //BYIT.MSDS_NO의 null여부
		var req_check   = ""; //KEP_CMC_REQ 의 상태 체크
		var temp_req_check   = ""; //KEP_CMC_REQ 의 상태 체크(TEMP_COND 입력 여부)
		var harmful_check   = ""; //유해화학물질 여부 체크
		var temp_check   = ""; //보관조건 체크
		var sg118_check = ""; // 시약류 체크
		var buyer_item_no_arr = []; //등록해야할 품목코드
		var msds_no_reg_buyer_item_no_arr = []; //카탈로그에 MSDS 미등록 품목코드
		var tempMng_no_reg_buyer_item_no_arr = []; //카탈로그에 보관조건 미등록 품목코드
		var p070000033 = ""; // 보관조건이 필수인 고객사 목록
		var temp_cond = ""; // 보관조건 유형(실온/정온/냉장/냉동/극냉동)
		
		var process_type = "";
		var warehouse_code = "";
		var tr_warehouse_yn = "";
		var st_pors_check = "";
		
		document.forms["processForm"].st_monitor.value = "AGENT_S_0";
		
		// 매입단가유효일 진행 통제
		var buy_close_date_chk = ""; // 매입단가유효일 체크
		
		for(var idx=0; idx<arrRow.length; idx++){
			st_pors_check = Sheet.GetCellValue(arrRow[idx],"PORS_CHECK");
			if(st_pors_check == "Y"){
// 				alert("고객사 이슈로 수주 접수 불가, 담당자에게 문의 바랍니다.\n 최병관 책임(02-3016-8931), 배인영 사원(02-3016-8933)");
				var text = "고객사 이슈로 수주 접수 불가, 담당자에게 문의 바랍니다.</br>최병관 책임(02-3016-8931), 배인영 사원(02-3016-8933)";
				openLayerPopText2(text,but1text,but1func,but1width);
	    		return;
			}
	    	cod_check = Sheet.GetCellValue(arrRow[idx],"COD_CHECK");
	    	msds_check = Sheet.GetCellValue(arrRow[idx],"MSDS_CHECK");
	    	req_check = Sheet.GetCellValue(arrRow[idx],"REQ_CHECK");
	    	temp_req_check = Sheet.GetCellValue(arrRow[idx],"TEMP_REQ_CHECK");
	    	
	    	temp_check = Sheet.GetCellValue(arrRow[idx],"TEMP_CHECK");
	    	p070000033 = Sheet.GetCellValue(arrRow[idx],"P070000033");
	    	sg118_check = Sheet.GetCellValue(arrRow[idx],"SG118_CHECK");
	    	
	    	if(cod_check=="Y" && msds_check=="Y" && req_check=="N"){ //물질정보등록 대상이면서 msds미매핑 건 이면서 입력요청 외에 다른 상태 건 이 없는 경우 수주접수 통제
	    		var flag = true;
	    	 
	    	 	for(var i = 0; i<buyer_item_no_arr.length;i++){ //buyer_item_no 중복 출력 방지
	    			if(Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO")==buyer_item_no_arr[i]){
	    				flag = false;
			    		break;		
	    			}
	    		}
	    		if(flag)
	    			buyer_item_no_arr.push(Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO"));
	     	}
	    	 
			if(cod_check=="Y" && msds_check=="Y"){ // MSDS 대상 표준카테고리에 해당하고 카탈로그 MSDS 미매핑 품목 리스트 - 통제 2024.07.19 HSJ
				var flag1 = true;
	    	 	for(var i = 0; i<msds_no_reg_buyer_item_no_arr.length;i++){ //buyer_item_no 중복출력 방지
	     			if(Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO")==msds_no_reg_buyer_item_no_arr[i]){
	     				flag1 = false;
	 		    		break;		
	     			}
	     		}
	     		if(flag1)
	     			msds_no_reg_buyer_item_no_arr.push(Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO"));
	      	}
			
			if(p070000033 != "" && sg118_check == "Y" && temp_check == "Y"){ // 보관조건 입력 필수 고객사 & 카탈로그에 보관조건 미등록 품목 통제 - 2025.06.27 HSJ
				if(temp_req_check == "Y"){ //협력사제출,제출(오분류) 상태이고 보관조건을 입력한 데이터가 있는 경우 -> 진행하지말고 기다리라고 안내
	    			var text = "해당 품목 ("+Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO")+") 은 보관온도 조건 입력 요청이 접수되어 현재 KeP 담당자 검토 단계에서 처리 중입니다.</br>동일 품목에 대한 추가 요청은 접수되지 않으니 검토 완료까지 잠시만 기다려 주세요.";
	    			openLayerPopText2(text,but1text,but1func,but1width);
	    			return
	    		}else{
	    			var flag1 = true;
		    		for(var i = 0; i<tempMng_no_reg_buyer_item_no_arr.length;i++){ //buyer_item_no 중복출력 방지
		    			if(Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO")==tempMng_no_reg_buyer_item_no_arr[i]){
		    				flag1 = false;
				    		break;		
		    			}
		    		}
		    		if(flag1)
		    			tempMng_no_reg_buyer_item_no_arr.push(Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO"));
	    		}
	     	}
	        buyer       = Sheet.GetCellValue(arrRow[idx],"BUYER");
	        po_no       = Sheet.GetCellValue(arrRow[idx],"PO_NO");
	        po_seq      = Sheet.GetCellValue(arrRow[idx],"PO_SEQ");
	        po_qty      = Sheet.GetCellValue(arrRow[idx],"ITEM_QTY");
	        cd_date     = Sheet.GetCellValue(arrRow[idx],"DS_DATE");
	        cd_qty      = Sheet.GetCellValue(arrRow[idx],"ITEM_QTY");
	        ds_flag     = Sheet.GetCellValue(arrRow[idx],"DS_FLAG");
	        seller      = Sheet.GetCellValue(arrRow[idx],"SELLER");
	        delay_reason= Sheet.GetCellValue(arrRow[idx],"DELAY_REASON");
	        rd_date     = Sheet.GetCellValue(arrRow[idx],"RD_DATE");
//	     	rd_date     = rd_date.replace(/[/]/garrRow[idx],"");
	        query_text  = Sheet.GetCellValue(arrRow[idx],"QUERY_TEXT");    // 분할납품일 경우 이 변수에 값이 존재함
			ds_date		= Sheet.GetCellValue(arrRow[idx],"DS_DATE");
			st_date     = Sheet.GetCellValue(arrRow[idx],"ST_DATE");
//	     	st_date     = st_date.replace(/[/]/garrRow[idx],"");
			reject_reason = Sheet.GetCellValue(arrRow[idx],"REJECT_REASON");
			buyer_need_deli = Sheet.GetCellValue(arrRow[idx],"BUYER_NEED_DELI");
			po_create_date = Sheet.GetCellValue(arrRow[idx], "PH_PO_DATE");
			reject_image_key = Sheet.GetCellValue(arrRow[idx], "REJECT_IMAGE_KEY");
			process_type = Sheet.GetCellValue(arrRow[idx], "PROCESS_TYPE");
	    	warehouse_code = Sheet.GetCellValue(arrRow[idx], "WAREHOUSE_CODE");
	    	tr_warehouse_yn = Sheet.GetCellValue(arrRow[idx], "TR_WAREHOUSE_YN");
	    	temp_cond = Sheet.GetCellValue(arrRow[idx], "TEMP_COND");
	    	harmful_check = Sheet.GetCellValue(arrRow[idx], "HARMFUL_CHECK");
	    	
	    	// 보관조건에 따른 거래유형 검증(아모레퍼시픽(TYPE1))
	    	if(p070000033 == "TYPE1"){ // 아모레퍼시픽(TYPE1)
	    		if(sg118_check == "Y"){ // 시약류
	    			if(harmful_check != "Y"){ // 유해화학물질 여부
	    				if(temp_cond != ""){
	    					if(temp_cond == "A" || temp_cond == "B"){ // 실온(A), 정온(B)
	                			if(process_type != "2"){
// 	                				alert("품목 실온/정온은 TR로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
	                				var text = "품목 실온/정온은 TR로만 가능합니다.(거래유형오류)</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
	                				openLayerPopText2(text,but1text,but1func,but1width);
	                   				return;
	                			}
	                		}else{
	                			if(process_type != "0"){
// 	                				alert("품목 냉장/냉동은 직납으로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
	                				var text = "품목 냉장/냉동은 직납으로만 가능합니다.(거래유형오류)</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
	                				openLayerPopText2(text,but1text,but1func,but1width);
	                   				return;
	                			}
	                		}	
	    				}
	        		}	
	    		}
	    	}
	    	
	    	if(harmful_check == "Y"){ // 유해화학물질 여부
	    		if(process_type != "0"){ // 무조건 직납
// 					alert("유해화학물질이 포함되어 직납만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
					var text = "유해화학물질이 포함되어 직납만 가능합니다.(거래유형오류)</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
    				openLayerPopText2(text,but1text,but1func,but1width);
	   				return;
				}
	    	}
	    	
	   		if(process_type == '2') {
	   			if(tr_warehouse_yn == 'N' || warehouse_code == "" || warehouse_code == null || warehouse_code == 'null') {
// 	   				alert("해당 건 진행할 수 없습니다.(거래유형정보오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
	   				var text = "해당 건 진행할 수 없습니다.(거래유형정보오류)</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
    				openLayerPopText2(text,but1text,but1func,but1width);
	   				return;
	   			}
	   		}
			if(reject_reason != ""){
				reject_yn = "Y";
				reject_reason = Sheet.GetCellValue(arrRow[idx], "REJECT_REASON") + " | " + Sheet.GetCellValue(arrRow[idx], "REJECT_REASON_TEXT");
			}
			
			if(reject_yn == "N"){
				// 매입단가유효일 진행 통제
		        buy_close_date_chk = Sheet.GetCellValue(arrRow[idx], "BUY_CLOSE_DATE_CHK");
				if(buy_close_date_chk == "Y"){
// 					alert("해당 건 진행할 수 없습니다.\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
					var text = "해당 건 진행할 수 없습니다.</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
    				openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
				
				if(Sheet.GetCellValue(arrRow[idx],"DS_GUBUN") == "전량:0|분할:0"){
// 		        	alert("납품구분을 선택해주시기 바랍니다.");
		        	var text = "납품구분을 선택해주시기 바랍니다.";
    				openLayerPopText2(text,but1text,but1func,but1width);
		        	Sheet.SelectCell(arrRow[idx],"DS_GUBUN");
		        	return;
		        }
				
		        if(cd_date == ""){
// 		            alert("납품예정일을 입력해주세요.");
		            var text = "납품예정일을 입력해주세요.";
    				openLayerPopText2(text,but1text,but1func,but1width);
		            Sheet.SelectCell(arrRow[idx],"DS_DATE");
		            return;
		        }
		        
		        var cur_date = kepGetNowTimeStr("YYYYMMDD","");
		        if(cd_date < cur_date){
// 		            alert("납품예정일을 금일 이후 날짜로 입력해주세요.");
		            var text = "납품예정일을 금일 이후 날짜로 입력해주세요.";
    				openLayerPopText2(text,but1text,but1func,but1width);
		            Sheet.SelectCell(arrRow[idx],"DS_DATE");
		            return;
		        }
		        
		        if(buyer_need_deli == "N"){
		        	if((st_date < ds_date) && isEmpty(delay_reason)) {
// 		    			alert("납품지연사유를 입력하여 주십시요.");
		    			var text = "납품지연사유를 입력하여 주십시요.";
	    				openLayerPopText2(text,but1text,but1func,but1width);
		    			Sheet.SelectCell(arrRow[idx],"DELAY_REASON_COMBO");
		    			return;
		    		}	
		        }
		        
			}
			
	        if(ds_flag=="N"){ // Y는 분할납품한 품목임
	            max_cd_date = cd_date;

	            query +=  buyer         + "@@";
	            query +=  po_no         + "@@";
	            query +=  po_seq        + "@@";
	            query +=  po_qty        + "@@";
	            query +=  cd_date       + "@@";
	            query +=  cd_qty        + "@@";
	            query +=  "Y"           + "@@"; // DS_FLAG
	            query +=  seller        + "@@";
	            query +=  user_id       + "@@";
	            query +=  delay_reason  + "@@";
	            query +=  max_cd_date   + "@@";// ICOMPODT.DS_DATE 에 들어가는 값   , 분할접수일 경우 마지날 납품예정일
	            query +=  rd_date + "@@";
	            query +=  reject_reason + "@@";
	            query +=  buyer_need_deli + "@@";
	            query +=  st_date + "@@";
	            query +=  reject_image_key;
	            query +=  "^||^" ;
	            
	            document.forms["processForm"].st_monitor.value = "AGENT_S_S_S";
	        }else{
	            query +=  query_text;
	            
	            document.forms["processForm"].st_monitor.value = "AGENT_S_S_M";
	        }
		}
		if(reject_yn == "N"){
			if(buyer_item_no_arr.length != 0 && <%=p060000079%> == false){ //수주접수 통제해야되는 건이 있는 경우(통제 예외 협력사도 아니어야 함)
				g_query = query;
			
				var text = "해당 품목 ("+buyer_item_no_arr+") 은 MSDS 제출이 필요합니다.</br>MSDS 등록 후 KeP 승인이 완료되면 수주접수를 진행할 수 있습니다.</br>KeP 승인완료 전에는 수주접수가 제한됩니다.";
				var but1textC = "확인";
				var but2textC = "MSDS관리 바로가기";
				var but1funcC = "javascript:reqAndClose(); return false;";
				var but2funcC = "javascript:reqAndMove(); return false;";
				var but1widthC = "120px";
				var but2widthC = "170px";
				openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
				
// 				if(confirm("해당 품목 ("+buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n카탈로그 관리 > 물질정보 제출 화면으로 이동하셔서 MSDS 및 물질정보 제출 후 KEP에서 MSDS매핑이 완료되면 수주접수 하시기 바랍니다\n*문의사항은 수주접수 화면에 있는 KeP담당자 통해서 하시길 바랍니다.")){
// 					//KEP_CMC_REQ insert 코드
// 					if(setGridData(query)){
// 						document.forms.sellerMpIvObtnodrReceiptDetailPop.st_query.value = query;
// 						kepAjaxFormCall("/mpiv/saveSellerMpIvChemicalInfo.do","processForm","msds");
// 					}
// 				}
				return;
			}else if(tempMng_no_reg_buyer_item_no_arr.length != 0 && <%=p060000079%> == false){
				g_query = query;
				var text = "해당 품목 ("+tempMng_no_reg_buyer_item_no_arr+") 은 보관온도 조건 제출이 필요합니다.</br>등록 후 KeP 승인이 완료되면 수주접수를 진행할 수 있습니다.</br>KeP 승인완료 전에는 수주접수가 제한됩니다.";
				var but1textC = "확인";
				var but2textC = "MSDS관리 바로가기";
				var but1funcC = "javascript:reqAndClose(); return false;";
				var but2funcC = "javascript:reqAndMove(); return false;";
				var but1widthC = "120px";
				var but2widthC = "170px";
				openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
// 				if(confirm("해당 품목 ("+tempMng_no_reg_buyer_item_no_arr+") 은 보관조건(온도) 확인이 필요한 대상입니다.\n카탈로그 관리 > 물질정보 제출 화면으로 이동하셔서 물질정보 제출 후 KEP에서 승인되면 수주접수 하시기 바랍니다\n*문의사항은 수주접수 화면에 있는 KeP담당자 통해서 하시길 바랍니다.")){
// 					//KEP_CMC_REQ insert 코드
// 					if(setGridData(query)){
// 						document.forms.sellerMpIvObtnodrReceiptDetailPop.st_query.value = query;
// 						kepAjaxFormCall("/mpiv/saveSellerMpIvChemicalInfo.do","processForm","msds");
// 					}
// 				}
				return;
			}else if(msds_no_reg_buyer_item_no_arr.length != 0 && <%=p060000079%> == false){
				g_query = query;
				var text = "해당 품목 ("+msds_no_reg_buyer_item_no_arr+") 은 MSDS 제출이 필요합니다.</br>MSDS 등록 후 KeP 승인이 완료되면 수주접수를 진행할 수 있습니다.</br>KeP 승인완료 전에는 수주접수가 제한됩니다.";
				var but1textC = "확인";
				var but2textC = "MSDS관리 바로가기";
				var but1funcC = "javascript:layerPopClose(); return false;";
				var but2funcC = "javascript:layerPopMove(); return false;";
				var but1widthC = "120px";
				var but2widthC = "170px";
				openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
// 				alert("해당 품목 ("+msds_no_reg_buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n현재 MSDS가 매핑되어 있지 않아 진행이 불가하니 확인하여 주시기 바랍니다.\n*문의사항은 수주접수 화면에 있는 KeP담당자 통해서 하시길 바랍니다.");
				return;
			}else{//통제 건 없는 경우 수주접수 진행
			    document.forms["sellerMpIvObtnodrReceiptDetailPop"].st_query.value  = query;
			    document.forms["processForm"].st_po_create_date.value = po_create_date;
			    
			    if(setGridData(query)){
			    	
			    	var text = "수주접수 하시겠습니까?";
					var but1textC = "확인";
					var but2textC = "취소";
					var but1funcC = "javascript:saveSellerMpIvObtnodrReceiptDetailPop(); return false;";
					var but2funcC = "javascript:closePopText1(); return false;";
					var but1widthC = "120px";
					var but2widthC = "120px";
					openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
					
// 					if(!confirm("수주접수 하시겠습니까?")){ 
// 						return;
// 					}
// 					kepAjaxFormCall("/mpiv/saveSellerMpIvObtnodrReceiptDetailPop.do","processForm","order"); 	
				}
			}
	    }else{
	    	if(setGridData(query)){
//	 			if(!confirm("수주거부 하시겠습니까?")){
//	 				return;
//	 			}
				
				kepAjaxFormCall("/mpiv/saveSellerMpIvObtnodrReceiptDetailRejectPop.do","processForm","reject");
			}
	    }
}

function saveSellerMpIvObtnodrReceiptDetailPop(){
	closePopText1();
	kepAjaxFormCall("/mpiv/saveSellerMpIvObtnodrReceiptDetailPop.do","processForm","order"); 	
}
//선택된 그리드 값을 셋팅
function setGridData(query) {
	var returnValue = true;

	var resultArr = new Array(2);
	resultArr = ['',''];
//	  for (i = 0; i < j; i++) {
	
		/*
		str[0] ==>KRKEPB0004		==> BUYER
		str[1] ==>PO04000131		==> PO_NO
		str[2] ==>000001			==> PO_SEQ
		str[3] ==>5					==> PO_QTY
		str[4] ==>20040916			==> CD_DATE
		str[5] ==>1					==> CD_QTY
		str[6] ==>Y					==> DS_FLAG
		str[7] ==>KRKORE0001		==> SELLER
		str[8] ==>KEPSE03			==> USER_ID 
		str[9] ==>지연사유				==> DS_DELAY_REASON
		str[10]==>20040916			==> MAX_CD_DATE				
		str[11]==>20040915			==> RD_DATE
		str[12]==>거부사유				==> REJECT_REASON
		str[13]==>고객사요청분할		==> BUYER_NEED_DELI
		str[14]==>표준납품일			==> ST_DATE
		str[15]==>수주거부 첨부			==> REJECT_IMAGE_KEY
		*/
		
	var inputCnt = $("input[name='st_query_text']").length;
		
	//var name = "st_buyer|st_po_no|st_po_seq|st_cd_qty|st_ds_date|st_cd_qty|st_ds_flag|st_user_id|st_delay_reason|st_max_cd_date|st_rd_date";
	
	var name = new Array(15);
	name = ['st_buyer','st_po_no','st_po_seq','st_po_qty','st_ds_date','st_cd_qty','st_ds_flag','st_seller','st_user_id','st_delay_reason','st_max_cd_date','st_rd_date','st_reject_reason', 'st_ds_yn', 'st_st_date', 'st_reject_image_key'];

	//resultArr[0] = name;
	
	var st_query = query.split("^||^");
	
	for(var j = 0; j < st_query.length-1; j++){
		
		var value = st_query[j].split("@@",-1);
		
		for(var k = 0; k < name.length; k++){
			
			
			resultArr[0] = resultArr[0]+ name[k] + "|";
			resultArr[1] = resultArr[1]+ "<input type='hidden' name='"+name[k]+"' id='"+name[k]+"' value='"+value[k]+"'>";
		}
	}

	//마지막에 | 를 없애기 위함
	if (resultArr[0] != "")  resultArr[0] = resultArr[0].substr(0, resultArr[0].length -1);
		
	if(resultArr != null && resultArr !=""){
		
		document.forms["processForm"].s_SAVENAME.value = resultArr[0];
		$("#process").html(resultArr[1]);
		
	} else {
// 		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
		var text = "그리드 데이터 변환에 실패하였습니다.[getFormToArr]";
		openLayerPopText2(text,but1text,but1func,but1width);
		returnValue = false;
	}
	
	return returnValue;
}

function customerAndPoCheck(flag){
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	// 선택된 항목 유무 체크
	if (checkRows.length == 0) {
// 		alert("품목을 선택해주세요.");
		var text = "품목을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return ["","",false];
	}
	var buyer = "";
	var po_no = "";
	var buyerPoNoText = {};
	var poMap = {};
	for(var idx=0; idx<arrRow.length; idx++){
		//복수 고객사 선택 방지(수주거부)
		if(idx == 0){
			buyer = Sheet.GetCellValue(arrRow[idx],"BUYER");
		}
		
		if(buyer != Sheet.GetCellValue(arrRow[idx],"BUYER") && flag == "수주거부"){
//				alert(flag+"는 한 번에 하나의 고객사만 처리할 수 있습니다. 하나의 고객사를 선택해 주세요.");
			var text = flag+"는 한 번에 하나의 고객사만 처리할 수 있습니다. 하나의 고객사를 선택해 주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return["","",false];
		}
		
		//고객사, 발주번호 합쳐서 파라미터 만들기
		var tmp = Sheet.GetCellValue(arrRow[idx],"BUYER")+Sheet.GetCellValue(arrRow[idx],"PO_NO");
		if(buyerPoNoText[tmp] == undefined){
			buyerPoNoText[tmp] = 1;
		}else{
			buyerPoNoText[tmp] = buyerPoNoText[tmp]+1;
		}
		
		if(po_no.indexOf(Sheet.GetCellValue(arrRow[idx],"PO_NO")) < 0){
			po_no = po_no + Sheet.GetCellValue(arrRow[idx],"PO_NO") +","
		}
		
		if(flag == "수주접수"){
			var warehouse_code = Sheet.GetCellValue(arrRow[idx],"WAREHOUSE_CODE");		
			if(!setMapValue(poMap, tmp, warehouse_code)) {
				var text = "해당 건 진행할 수 없습니다.(물류센터정보오류)</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return["","",false];
			}
		}
		
	}
	
	if(flag == "수주접수"){
		for(var i = 1; i<=Sheet.RowCount(); i++){
			var tmpCheck = Sheet.GetCellValue(i,"BUYER")+Sheet.GetCellValue(i,"PO_NO");
			if(buyerPoNoText[tmpCheck] != undefined){
				if(Sheet.GetCellValue(i,"SELECTED") == "0"){ //고객사+발주번호가 포함되어있는데 체크 안 된 품목이 있는 경우
//	 				alert(flag+"는 발주번호 단위로 처리됩니다. 동일 발주번호의 모든 품목을 선택해주세요.");
					var text = flag+"는 발주번호 단위로 처리됩니다. 동일 발주번호의 모든 품목을 선택해주세요.";
					openLayerPopText2(text,but1text,but1func,but1width);
					return["","",false];
				}
				
				if(Sheet.GetCellValue(i,"PO_CNT") != buyerPoNoText[tmpCheck]){
					var text = flag+"는 발주번호 단위로 처리됩니다. 동일 발주번호의 모든 품목을 선택해주세요.";
					openLayerPopText2(text,but1text,but1func,but1width);
					return["","",false];
				}
			}
		}
	}
	
	return[buyer,po_no,true];
}

function setMapValue(obj, key, value) {		
	// 객체에 key 존재하는지 확인
	if(Object.hasOwn(obj, key)) {
		var oldValue = obj[key];
		// 물류센터 코드(value)가 다른경우
		if(oldValue != value) {
			return false;
		}
	}
	// key 존재안하면
	obj[key] = value;
	return true;
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	
	g_query = "";
	if (isEmpty(msg)){
		if(pMethod == "order"){
// 			alert("수주접수 정상 등록 완료.\n납품예정일 준수 부탁 드립니다.");
			var text = "수주접수 정상 등록 완료.</br>납품예정일 준수 부탁 드립니다.";
			openLayerPopText2(text,but1text,but1funcSearch,but1width);
		}else if(pMethod == "msds"){
// 			alert("물질정보 등록요청 완료.\n물질정보 제출 화면으로 이동하셔서 MSDS 및 물질정보 제출 후 수주접수 하시기 바랍니다.");
		}else if(pMethod == "reject"){
			reject_yn = "N"; //reject_yn 초기화
// 			alert("수주거부요청이 완료되었습니다.\n진행현황은 [납품관리 > 납품이슈현황]에서 확인 가능합니다.");
			var text = "수주거부요청이 완료되었습니다.</br>진행현황은 [납품관리 > 납품이슈현황]에서 확인 가능합니다.";
			openLayerPopText2(text,but1text,but1funcSearch,but1width);
		}else if(pMethod == "msdsMove"){
			location.href = "/mdct/showSellerMdCmChemicalMatMngList.do?menuId=sr00202000000";
			return;
		}else{
		}
		
// 		doAction('search');
	}else{
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
	return;
}
function thisPopClose(){
	closePopText2();
	doAction('search');
}
//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response,msg){
	var msg = response.msg;
	
	if (!isEmpty(msg)){
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	return;
}

function reqAndClose(){
	closePopText1();
    if(setGridData(g_query)){
    	document.forms["sellerMpIvObtnodrReceiptDetailPop"].st_query.value = g_query;
    	kepAjaxFormCall("/mpiv/saveSellerMpIvChemicalInfo.do","processForm","msds");
    }
	
}
function reqAndMove(){
	closePopText1();
    if(setGridData(g_query)){
    	document.forms["sellerMpIvObtnodrReceiptDetailPop"].st_query.value = g_query;
    	kepAjaxFormCall("/mpiv/saveSellerMpIvChemicalInfo.do","processForm","msdsMove");
    }
}
function layerPopClose(){
	closePopText1();
}
function layerPopMove(){
	closePopText1();
    location.href = "/mdct/showSellerMdCmChemicalMatMngList.do?menuId=sr00202000000";
}

function msdsMove(){
	location.href = "/mdct/showSellerMdCmChemicalMatMngList.do?menuId=sr00202000000";
}
</script>
</head>

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader_sub_v2"/>
<c:param name="part" value="header_v2"/>
</c:import>
<div id="container2">
<c:import charEncoding="utf-8" url="/main/leftMenuData.do">
<c:param name="page" value="sellerLeft_v2"/>
</c:import>
<!-- 메뉴 E -->
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
         수주접수
          <div class="SummaryGuide">
      	    <ul>
        	  <li><img src="/resources/imgs/Icon_Home.png" /></li>
              <li>납품관리</li>
              <li>수주접수</li>
            </ul>
          </div>
        </div>
        <div class="SubSearchTab">
         <button class="TabTit active" data-tab="Search1">수주접수(PO별)</button>
         <button class="TabTit" data-tab="Search2">수주접수(품목별)</button> 
        </div>
        <form id="searchCondition0" name="searchCondition0" method="post">
        <input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_com_code" id="st_com_code0" value="${sessionInfo.comCode}">
        <div id="Search1" class="SearchContent active">
          <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> 발주번호(PO) 단위별 <button class="ButOutline_Tiny" style="padding:0 6px; margin:0 3px 0 7px; cursor: default;" onclick="return false;" >수주접수</button>
          버튼 선택 시 수주접수 상세 화면에서  수주접수 또는 수주거부를 할 수 있습니다. </div>
          <table class="TabSearchTable" >
            <colgroup>
              <col width="80px" />
              <col width="560px" />
              <col width="90px" />
              <col width="230px" />
              <col width="90px" />
              <col width="230px" />
            </colgroup>            	
            <tr>
              <th>기간</th>
              <td>
                <select name="st_date_type" class="Select" style=" float:left;width:95px; margin-right:5px">
                  <option value="st_po_create_date" selected>발주일</option>
                  <option value="st_rd_date">고객수령희망일</option>
                </select>
                <div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date_0" name="st_from_date" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_0" name="st_to_date" readonly /><span></span></div>
                </div>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','1'); return false;">1개월</button> 
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','2'); return false;">2개월</button>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','3'); return false;">3개월</button>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','12'); return false;">1년</button>               
              </td>
              <th>거래유형</th>
              <td><select name="st_process_type" class="Select" style="width:240px;">
                  <option value="" selected>전체</option>
                  <option value="2">TR</option>
                  <option value="0">직납</option>
                </select> 
              </td> 
              <th>고객사</th>
              <td>
                  <input type="text" class="input30"  id="st_buyer_name_0"  name="st_buyer_name" style=" width:218px; "onKeyDown="kepEnter_v2();">
<!--                   <input type="hidden" name="st_buyer_code" id="st_buyer_code_0" value=""> -->
<!--                   <button type="button" onclick="javascript:doPop('commonMpIvTranBuyerChoicePop'); return false;">고객사명</button> -->
               
			  </td>              
            </tr>
            <tr>           
              <th>발주번호</th>
              <td ><input class="input30" style="width:488px" name="st_po_no" type="text" placeholder="여러 개의 발주번호로 조회 가능하며 띄어쓰기 없이 콤마(,)로 구분해서 입력해주세요."  onKeyDown="kepEnter_v2();"/></td>
              <th>선입고여부</th>
              <td><select name="st_bfre_stck_yn" class="Select" style="width:240px;">
                  <option value="" selected>전체</option>
                  <option value="S">Y</option>
                  <option value="N">N</option>
                </select> </td>                                                    
              <th>긴급발주여부</th>
              <td><select name="st_urgent_yn" class="Select" style="width:240px;">
                  <option value="" selected>전체</option>
                  <option value="F">Y</option>
                  <option value="N">N</option>
                </select> </td>
            </tr>
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="doAction('search');return false;">조회</button>
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40" onclick="javascript:excelDownload(); return false;">엑셀다운로드</button>
            </div>
            <div class="right"></div>
          </div>
          <div class="IBSheet">
          	<script type="text/javascript">
          		createIBSheet("mySheet0", "", "100%");
          	</script>
          </div><!--IBSheet 끝 --> 
          <div class="h50" style="height:50px; "></div>              
        </div><!--id="Search1" 수주접수(PO별) 끝 -->
        </form>
        <form id="searchCondition1" name="searchCondition1" method="post">  
        <input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_com_code" id="st_com_code1" value="${sessionInfo.comCode}">    
        <div id="Search2" class="SearchContent">
          <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> 발주번호별로 수주접수 또는 수주거부를 할 수 있으며 수주거부는 해당 발주번호 내 모든 품목에 적용되며, 납품이 불가합니다. </div>
          <table class="TabSearchTable" >
            <colgroup>
              <col width="80px" />
              <col width="560px" />
              <col width="90px" />
              <col width="230px" />
              <col width="90px" />
              <col width="230px" />
            </colgroup>           	
            <tr>
              <th>기간</th>
              <td >
                <select name="st_date_type" class="Select" style=" float:left;width:95px; margin-right:5px">
                  <option value="st_po_create_date" selected>발주일</option>
                  <option value="st_rd_date">고객수령희망일</option>
                </select>
                <div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date_1" name="st_from_date" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_1" name="st_to_date" readonly /><span></span></div>
                </div>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','1'); return false;">1개월</button> 
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','2'); return false;">2개월</button>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','3'); return false;">3개월</button>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','12'); return false;">1년</button>                
              </td>
              <th>거래유형</th>
              <td><select name="st_process_type" class="Select" style="width:240px;">
                  <option value="" selected>전체</option>
                  <option value="2">TR</option>
                  <option value="0">직납</option>
                </select> 
              </td> 
              <th>고객사</th>
              <td>
                  <input type="text" class="input30" id="st_buyer_name_1"  name="st_buyer_name" style=" width:218px; " onKeyDown="kepEnter_v2();">
<!--                   <input type="hidden" name="st_buyer_code" id="st_buyer_code_1" value=""> -->
<!--                   <button type="button" onclick="javascript:doPop('commonMpIvTranBuyerChoicePop'); return false;">고객사명</button> -->
			  </td> 
            </tr>
            <tr>           
              <th>발주번호</th>
              <td ><input class="input30" style="width:488px" name="st_po_no" type="text" placeholder="여러 개의 발주번호로 조회 가능하며 띄어쓰기 없이 콤마(,)로 구분해서 입력해주세요." onKeyDown="kepEnter_v2();" /></td>             
              <th>긴급발주여부</th>
              <td><select name="st_urgent_yn" class="Select" style="width:240px;">
                  <option value="" selected>전체</option>
                  <option value="F">Y</option>
                  <option value="N">N</option>
                </select> </td>
              <th>선입고여부</th>
              <td><select name="st_bfre_stck_yn" class="Select" style="width:240px;">
                  <option value="" selected>전체</option>
                  <option value="S">Y</option>
                  <option value="N">N</option>
                </select> </td>                                                         
                   
            </tr>
            <tr> 
              <th>품목명</th>
              <td><input class="input30" style="width:488px" name="st_description" type="text" onKeyDown="kepEnter_v2();"/></td>         
              <th>규격</th>
              <td><input class="input30" style="width:218px" name="st_specification" type="text" onKeyDown="kepEnter_v2();"/></td>                                              
              <th>품목코드</th>
              <td><input class="input30" style="width:218px" name="st_buyer_item_no" type="text" onKeyDown="kepEnter_v2();"/></td>
            </tr>              
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="doAction('search');return false;">조회</button>
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40" onclick="javascript:excelDownload(); return false;">엑셀다운로드</button> <button class="ButOutline_Medium"  onclick="javascript:doPop('dsDateDelayReasonMulti'); return false;">납품예정일 일괄등록</button></div>
            <div class="right"><button class="ButOutline_Medium"  onclick="javascript:setRejectReason(); return false;">수주거부</button> <button class="ButMPrimary" onclick="javascript:setDeliverySchedule('수주접수'); return false;">수주접수</button></div>
          </div> 
          <div class="IBSheet">
            <script type="text/javascript">
          		createIBSheet("mySheet1", "", "100%");
          	</script>            
          </div><!--IBSheet 끝 --> 
          <div class="h50" style="height:50px; "></div>   
        </div><!--id="Search2" 수주접수(품목별) 끝 -->
        </form>    
         
		<!-- 탭 스크립트 -->     
		<script>
          const tabLinks = document.querySelectorAll(".TabTit");
          const tabContents = document.querySelectorAll(".SearchContent");
        
          tabLinks.forEach(function(link,index)  {
            link.addEventListener("click", function() {
              // 모든 탭 버튼, 컨텐츠 비활성화
              tabLinks.forEach(function(btn){btn.classList.remove("active")});
              tabContents.forEach(function(content){content.classList.remove("active")});
        
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
          
          const inputs = document.querySelectorAll("input[name=st_po_no],input[name=st_description],input[name=st_buyer_item_no]");
          inputs.forEach(function(input){
          	  input.addEventListener("input",function(){
          		  this.value = this.value.trimStart();
          	  });
            });
        </script>
      </div> <!--padding-left:50px; 끝 -->
    </div><!--containerBoxSub-->
<form name="sellerMpIvObtnodrReceiptDetailPop" id="sellerMpIvObtnodrReceiptDetailPop" method=post >
	<!-- HIDDEN -->
	<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
	
	<input type="hidden" id="x" name="x"		value="">
	<input type="hidden" name="st_query"    	value="">
	<input type="hidden" name="file_get_y"		value="">
</form>
<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="st_com_code" id="st_com_code"  value="<%=com_code%>">
	<input type="hidden" name="st_po_create_date" id="st_po_create_date"  value=""> <!-- 장납기 이슈등록 판단 기준-->
	<input type="hidden" name="st_monitor" id="st_monitor" value=""> <!-- 모니터링용. 남아있는거 보이면 삭제하세요-->
	<div id="process">
	
	</div>
</form>
<form name="dsDateReasonAllForm" id="dsDateReasonAllForm" method="post">	
	<input type="hidden" name="info" id="info"  value="">
</form>
<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter_sub_v2.jsp" %> 
</div>
</body>
</html>
