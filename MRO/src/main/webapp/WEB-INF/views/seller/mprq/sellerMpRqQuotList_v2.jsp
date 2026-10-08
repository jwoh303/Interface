<%--
**********************************************
* 메뉴 : 일반 견적
* 화면 : 일반 견적
* 기능 : 
* 프로그램 ID : SU0401001
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
	
	//협력사 품목코드 입력 필수
	boolean p03302303 = CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P03-3023-03");
%>

<script type="text/javascript">


var mySheet0 = new ibsheetObject();
var mySheet1 = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var mySheet3 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

var productGbn = KepSheetComboData("M132","SEL");
var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};

var currIndex=1;
var Sheet;
// var Sheet = "mySheet"+currIndex;

//alert layer용
var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	Sheet = mySheet1; //첫화면에선 mySheet0; -> 견적요청이 먼저 되도록 mySheet1
	
	//초기 날짜 셋팅
	var indexLength = $("input[name=st_from_date]").length;
	for(var i = 0; i<indexLength; i++){
		if($("input[name=st_from_date]").eq(i).val() ==  ""){
			$("input[name=st_from_date]").eq(i).val(kepToMonthAdd("3","M"));
			$("input[name=st_to_date]").eq(i).val(kepGetNowTimeStr('YYYYMMDD','/'));
		}
	}
	
	var initsheet0 = {};
	initsheet0.Cfg = {FrozenCol:11,MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet0.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ATOS_DATE",			Header:"견적요청일",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"QUOTATION_NO",		Header:"견적번호",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"AGENT_SOURCING_STATUS",Header:"진행상태",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"BUYER",				Header:"고객사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
			,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",				Type:"Text",		Width:220,	Edit:false,	EditLen:100,	Hidden:false}							
			,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"품목명",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"ITEM_QTY",			Header:"수량",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ATOS_END_DATE",		Header:"견적마감일",			Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"KEP_USER_NAME",		Header:"KeP담당자",			Type:"Text",FontColor:"#3a72c7", Cursor:"Pointer",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ITEM_MAKE_TYPE",		Header:"품목구분",				Type:"Text",		Width:110,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"LEAD_TIME",			Header:"배송일수",				Type:"Int",			Width:80,	Edit:false,	EditLen:3,		Hidden:false}
			,{ Align:"Right",	SaveName:"STOA_LIST_PRICE",		Header:"제출단가\n(VAT별도)",	Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Format:"${priceFormat}"}
			,{ Align:"Right",	SaveName:"ORG_STOA_LIST_PRICE",	Header:"제출단가\n(VAT별도)",	Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Format:"${priceFormat}"}
			,{ Align:"Right",	SaveName:"MIN_ORDER_QTY",		Header:"최소주문\n수량",		Type:"Int",			Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"PUR_UNIT_QTY",		Header:"주문배수\n수량",		Type:"Int",			Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"PROCESS_NM",			Header:"거래유형",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"DELI_AREA_USE_FLAG",	Header:"납품지역",				Type:"Text",		Width:70,	Edit:false,	Hidden:true}
			,{ Align:"Center",	SaveName:"SELLER_AREA_YN",		Header:"납품지역",				Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	Hidden:false}
			,{ Align:"Center",	SaveName:"SELLER_AREA_TEXT",	Header:"납품지역",				Type:"Text",		Width:150,	Edit:false,	Hidden:true}
			,{ Align:"Center",	SaveName:"SELLER_AREA",			Header:"납품지역",				Type:"Text",		Width:150,	Edit:false,	Hidden:true}
			,{ Align:"Left",	SaveName:"ATOS_REMARK",			Header:"KeP비고",				Type:"Text",		Width:300,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"ATOS_REMARK_YN",		Header:"KeP비고",				Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"IMAGE_KEY_CNT",		Header:"KeP첨부",				Type:"Button",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type03'}
			,{ Align:"Center",	SaveName:"IMAGE_KEY",			Header:"KeP첨부",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"RFQ_IMG_FLAG",		Header:"이미지",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"IMGFILE_NAME_YN",		Header:"이미지",				Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"IMGFILE_NAME",		Header:"이미지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"IMGFILE_DIR",			Header:"이미지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SELLER_IMAGE_KEY_YN",	Header:"첨부",				Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"SELLER_IMAGE_KEY",	Header:"첨부",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_REMARK",			Header:"협력사비고",			Type:"Text",		Width:80,	Edit:false,	EditLen:500,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_REMARK_YN",		Header:"협력사비고",			Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	EditLen:100,	Hidden:false}
// 			,{ Align:"Center",	SaveName:"AGENT_SOURCING_STATUS_BUTTON",Header:"진행상태",		Type:"Image",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"AGENT_REVISION_YN",	Header:"제출이력",				Type:"Image",		Cursor:"Pointer",Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"AGENT_REVISION",		Header:"차수",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"REVISION",			Header:"차수",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"QUOTATION_SEQ",		Header:"순번",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"MAKER_PART_NO",		Header:"모델번호",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"MAKER_NAME",			Header:"제조사",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"ORIGIN_NAME",			Header:"원산지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"DELY_TO_LOCATION",	Header:"예상 도착지",			Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"PRE_GR_FLAG",			Header:"선입고",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"TAX_TYPE",			Header:"과세",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"SELLER_ITEM_NO",		Header:"협력사품목코드",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"AGENT",				Header:"협력사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SEL_USER_ID",			Header:"SEL_USER_ID",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SM_USER_NAME",		Header:"총괄담당자",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SM_USER_PHONE",		Header:"총괄담당자연락처",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
			
			
			,{ Align:"Center",	SaveName:"MSDS_YN",				Header:"MSDS",				Type:"Combo",		Width:60,	Edit:false,	EditLen:100,	Hidden:true,	ComboText:"Y|N",	ComboCode:"Y|N",	BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"KEP_USER_PHONE",		Header:"담당자연락처",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SAFETY_FLAG_TEXT",	Header:"안전인증서상태",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
			
			,{ Align:"Center",	SaveName:"KEP_USER_ID",			Header:"KeP담당자ID",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"REF_NO",				Header:"관리번호",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SAFETY_FLAG",			Header:"안전인증서상태",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_DATE",			Header:"협력사제출일",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_TIME",			Header:"협력사제출시간",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PLANT",				Header:"PLANT",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"MOQ_USE_FLAG",		Header:"MOQ_USE_FLAG",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PROCESS_TYPE_FLAG",	Header:"PROCESS_TYPE_FLAG",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"GIVEUP_REMARK",		Header:"GIVEUP_REMARK",		Type:"Text",		Width:80,	Edit:false,	EditLen:500,	Hidden:true}
			,{ Align:"Center",	SaveName:"VAT_FLAG",			Header:"VAT_FLAG",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SG_ID",				Header:"SG_ID",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
	];
	
	var initsheet1 = {};
	initsheet1.Cfg = {FrozenCol:11,MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet1.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ATOS_DATE",			Header:"견적요청일",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"QUOTATION_NO",		Header:"견적번호",				Type:"Text",FontColor:"#3a72c7", Cursor:"Pointer",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"SOURCING_STATUS",		Header:"진행상태",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"BUYER",				Header:"고객사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
			,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",				Type:"Text",		Width:220,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"품목명",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"ITEM_QTY",			Header:"수량",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ATOS_END_DATE",		Header:"견적마감일",			Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"KEP_USER_NAME",		Header:"KeP담당자",			Type:"Text",FontColor:"#3a72c7", Cursor:"Pointer",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ITEM_MAKE_TYPE",		Header:"품목구분",				Type:"Combo",		Width:100,	Edit:true,	EditLen:100,	Hidden:false,KeyField:true,BackColor:"${optColor}"}
			,{ Align:"Right",	SaveName:"LEAD_TIME",			Header:"배송일수",				Type:"Int",			Width:80,	Edit:true,	EditLen:4,		Hidden:false,KeyField:true,BackColor:"${optColor}"}
			,{ Align:"Right",	SaveName:"STOA_LIST_PRICE",		Header:"제출단가\n(VAT별도)",	Type:"Float",		Width:80,	Edit:true,	EditLen:100,	Hidden:true,	Format:"${priceFormat}"}
			,{ Align:"Right",	SaveName:"ORG_STOA_LIST_PRICE",	Header:"제출단가\n(VAT별도)",	Type:"Float",		Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Format:"${priceFormat}",KeyField:true,BackColor:"${optColor}"}
			,{ Align:"Right",	SaveName:"MIN_ORDER_QTY",		Header:"최소주문\n수량",		Type:"Int",			Width:80,	Edit:true,		Hidden:false,KeyField:true,BackColor:"${optColor}"}
			,{ Align:"Right",	SaveName:"PUR_UNIT_QTY",		Header:"주문배수\n수량",		Type:"Int",			Width:80,	Edit:true,		Hidden:false,KeyField:true,BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"거래유형",				Type:"Combo",		Width:90,	Edit:true,	EditLen:100,	Hidden:true,	ComboText:"직납|TR",	ComboCode:"0|2",BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"DELI_AREA_USE_FLAG",	Header:"납품지역",				Type:"Text",		Width:70,	Edit:false,	Hidden:true}
			,{ Align:"Center",	SaveName:"SELLER_AREA_YN",		Header:"납품지역",				Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	Hidden:false,BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"SELLER_AREA_TEXT",	Header:"납품지역",				Type:"Text",		Width:150,	Edit:false,	Hidden:true}
			,{ Align:"Center",	SaveName:"SELLER_AREA",			Header:"납품지역",				Type:"Text",		Width:150,	Edit:false,	Hidden:true}
			,{ Align:"Left",	SaveName:"ATOS_REMARK",			Header:"KeP비고",				Type:"Text",		Width:300,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"ATOS_REMARK_YN",		Header:"KeP비고",				Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"IMAGE_KEY_CNT",		Header:"KeP첨부",				Type:"Button",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type03'}
			,{ Align:"Center",	SaveName:"IMAGE_KEY",			Header:"KeP첨부",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"RFQ_IMG_FLAG",		Header:"이미지",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"IMGFILE_NAME_YN",		Header:"이미지",				Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	EditLen:100,	Hidden:false,BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"IMGFILE_NAME",		Header:"이미지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"IMGFILE_DIR",			Header:"이미지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SELLER_IMAGE_KEY_YN",	Header:"첨부",				Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	EditLen:100,	Hidden:false,BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"SELLER_IMAGE_KEY",	Header:"첨부",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_REMARK",			Header:"협력사비고",			Type:"Text",		Width:80,	Edit:false,	EditLen:500,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_REMARK_YN",		Header:"협력사비고",			Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	EditLen:100,	Hidden:false,BackColor:"${optColor}"}
// 			,{ Align:"Center",	SaveName:"SOURCING_STATUS_BUTTON",Header:"진행상태",			Type:"Image",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,ImgHeight:25,ImgWidth:80}
			,{ Align:"Center",	SaveName:"AGENT_REVISION_YN",	Header:"제출이력",				Type:"Image",		Cursor:"Pointer",Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"AGENT_REVISION",		Header:"차수",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"REVISION",			Header:"차수",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"QUOTATION_SEQ",		Header:"순번",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"MAKER_PART_NO",		Header:"모델번호",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"MAKER_NAME",			Header:"제조사",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"ORIGIN_NAME",			Header:"원산지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"DELY_TO_LOCATION",	Header:"예상 도착지",			Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"QTDT_PRE_GR_FLAG",	Header:"선입고",				Type:"Combo",		Width:60,	Edit:true,	EditLen:100,	Hidden:false,	ComboText:"Y|N",	ComboCode:"Y|N",BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"TAX_TYPE",			Header:"과세",				Type:"Combo",		Width:60,	Edit:true,	EditLen:100,	Hidden:false,	ComboText:"과세|면세",	ComboCode:"11|12",BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"SELLER_ITEM_NO",		Header:"협력사품목코드",			Type:"Text",		Width:100,	Edit:true,	EditLen:100,	Hidden:false,BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"AGENT",				Header:"협력사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			
			,{ Align:"Center",	SaveName:"SEL_USER_ID",			Header:"SEL_USER_ID",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			
			,{ Align:"Center",	SaveName:"MSDS_YN",				Header:"MSDS",				Type:"Combo",		Width:60,	Edit:false,	EditLen:100,	Hidden:true,	ComboText:"Y|N",	ComboCode:"Y|N",	BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"KEP_USER_PHONE",		Header:"담당자연락처",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SAFETY_FLAG_TEXT",	Header:"안전인증서상태",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
			
			,{ Align:"Center",	SaveName:"KEP_USER_ID",			Header:"KeP담당자ID",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"REF_NO",				Header:"관리번호",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SAFETY_FLAG",			Header:"안전인증서상태",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_DATE",			Header:"협력사제출일",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_TIME",			Header:"협력사제출시간",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PLANT",				Header:"PLANT",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"MOQ_USE_FLAG",		Header:"MOQ_USE_FLAG",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PROCESS_TYPE_FLAG",	Header:"PROCESS_TYPE_FLAG",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"GIVEUP_REMARK",		Header:"GIVEUP_REMARK",		Type:"Text",		Width:80,	Edit:false,	EditLen:500,	Hidden:true}
			,{ Align:"Center",	SaveName:"VAT_FLAG",			Header:"VAT_FLAG",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SG_ID",				Header:"SG_ID",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"CHANGE_FLAG",			Header:"CHANGE_FLAG",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
	];
	
	var initsheet2 = {};
	initsheet2.Cfg = {FrozenCol:11,MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet2.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ATOS_DATE",			Header:"견적요청일",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"QUOTATION_NO",		Header:"견적번호",				Type:"Text",		FontColor:"#3a72c7", Cursor:"Pointer",Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"AGENT_SOURCING_STATUS",Header:"진행상태",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"BUYER",				Header:"고객사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
			,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",				Type:"Text",		Width:220,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"품목명",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"ITEM_QTY",			Header:"수량",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ATOS_END_DATE",		Header:"견적마감일",			Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"KEP_USER_NAME",		Header:"KeP담당자",			Type:"Text",FontColor:"#3a72c7", Cursor:"Pointer",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ITEM_MAKE_TYPE",		Header:"품목구분",				Type:"Combo",		Width:100,	Edit:true,	EditLen:100,	Hidden:false,KeyField:true,BackColor:"${optColor}"}
			,{ Align:"Right",	SaveName:"LEAD_TIME",			Header:"배송일수",				Type:"Int",			Width:80,	Edit:true,	EditLen:4,		Hidden:false,KeyField:true,BackColor:"${optColor}"}
			,{ Align:"Right",	SaveName:"STOA_LIST_PRICE",		Header:"제출단가\n(VAT별도)",	Type:"Float",		Width:80,	Edit:true,	EditLen:100,	Hidden:true,	Format:"${priceFormat}"}
			,{ Align:"Right",	SaveName:"ORG_STOA_LIST_PRICE",	Header:"제출단가\n(VAT별도)",	Type:"Float",		Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Format:"${priceFormat}",KeyField:true,BackColor:"${optColor}"}
			,{ Align:"Right",	SaveName:"MIN_ORDER_QTY",		Header:"최소주문\n수량",		Type:"Int",			Width:80,	Edit:true,		Hidden:false,KeyField:true,BackColor:"${optColor}"}
			,{ Align:"Right",	SaveName:"PUR_UNIT_QTY",		Header:"주문배수\n수량",		Type:"Int",			Width:80,	Edit:true,		Hidden:false,KeyField:true,BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"거래유형",				Type:"Combo",		Width:90,	Edit:true,	EditLen:100,	Hidden:true,	ComboText:"직납|TR",	ComboCode:"0|2",BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"DELI_AREA_USE_FLAG",	Header:"납품지역",				Type:"Text",		Width:70,	Edit:false,	Hidden:true}
			,{ Align:"Center",	SaveName:"SELLER_AREA_YN",		Header:"납품지역",				Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	Hidden:false,BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"SELLER_AREA_TEXT",	Header:"납품지역",				Type:"Text",		Width:150,	Edit:false,	Hidden:true}
			,{ Align:"Center",	SaveName:"SELLER_AREA",			Header:"납품지역",				Type:"Text",		Width:150,	Edit:false,	Hidden:true}
			,{ Align:"Left",	SaveName:"ATOS_REMARK",			Header:"KeP비고",				Type:"Text",		Width:300,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"ATOS_REMARK_YN",		Header:"KeP비고",				Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"IMAGE_KEY_CNT",		Header:"KeP첨부",				Type:"Button",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type03'}
			,{ Align:"Center",	SaveName:"IMAGE_KEY",			Header:"KeP첨부",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"RFQ_IMG_FLAG",		Header:"이미지",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"IMGFILE_NAME_YN",		Header:"이미지",				Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	EditLen:100,	Hidden:false,BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"IMGFILE_NAME",		Header:"이미지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"IMGFILE_DIR",			Header:"이미지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SELLER_IMAGE_KEY_YN",	Header:"첨부",				Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	EditLen:100,	Hidden:false,BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"SELLER_IMAGE_KEY",	Header:"첨부",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_REMARK",			Header:"협력사비고",			Type:"Text",		Width:80,	Edit:false,	EditLen:500,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_REMARK_YN",		Header:"협력사비고",			Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	EditLen:100,	Hidden:false,BackColor:"${optColor}"}
// 			,{ Align:"Center",	SaveName:"AGENT_SOURCING_STATUS_BUTTON",Header:"진행상태",		Type:"Image",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,ImgHeight:25,ImgWidth:80}
			,{ Align:"Center",	SaveName:"AGENT_REVISION_YN",	Header:"제출이력",				Type:"Image",		Cursor:"Pointer",Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"AGENT_REVISION",		Header:"차수",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"REVISION",			Header:"차수",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"QUOTATION_SEQ",		Header:"순번",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"MAKER_PART_NO",		Header:"모델번호",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"MAKER_NAME",			Header:"제조사",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"ORIGIN_NAME",			Header:"원산지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"DELY_TO_LOCATION",	Header:"예상 도착지",			Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"PRE_GR_FLAG",			Header:"선입고",				Type:"Combo",		Width:60,	Edit:true,	EditLen:100,	Hidden:false,	ComboText:"Y|N",	ComboCode:"Y|N",BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"TAX_TYPE",			Header:"과세",				Type:"Combo",		Width:60,	Edit:true,	EditLen:100,	Hidden:false,	ComboText:"과세|면세",	ComboCode:"11|12",BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"SELLER_ITEM_NO",		Header:"협력사품목코드",			Type:"Text",		Width:100,	Edit:true,	EditLen:100,	Hidden:false,BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"AGENT",				Header:"협력사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SM_USER_NAME",		Header:"총괄담당자",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SM_USER_PHONE",		Header:"총괄담당자연락처",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SEL_USER_ID",			Header:"SEL_USER_ID",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			
			,{ Align:"Center",	SaveName:"MSDS_YN",				Header:"MSDS",				Type:"Combo",		Width:60,	Edit:false,	EditLen:100,	Hidden:true,	ComboText:"Y|N",	ComboCode:"Y|N",	BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"KEP_USER_PHONE",		Header:"담당자연락처",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SAFETY_FLAG_TEXT",	Header:"안전인증서상태",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"MODIFY_FLAG",			Header:"MODIFY_FLAG",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
			
			,{ Align:"Center",	SaveName:"KEP_USER_ID",			Header:"KeP담당자ID",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"REF_NO",				Header:"관리번호",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SAFETY_FLAG",			Header:"안전인증서상태",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_DATE",			Header:"협력사제출일",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_TIME",			Header:"협력사제출시간",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PLANT",				Header:"PLANT",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"MOQ_USE_FLAG",		Header:"MOQ_USE_FLAG",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PROCESS_TYPE_FLAG",	Header:"PROCESS_TYPE_FLAG",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"GIVEUP_REMARK",		Header:"GIVEUP_REMARK",		Type:"Text",		Width:80,	Edit:false,	EditLen:500,	Hidden:true}
			,{ Align:"Center",	SaveName:"VAT_FLAG",			Header:"VAT_FLAG",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SG_ID",				Header:"SG_ID",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"CHANGE_FLAG",			Header:"CHANGE_FLAG",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
	];
	
	var initsheet3 = {};
	initsheet3.Cfg = {FrozenCol:10,MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet3.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:60,	Edit:true,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"QUOTATION_NO",		Header:"견적번호",				Type:"Button",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,ClassName :'Type02'}
			,{ Align:"Center",	SaveName:"AGENT_SOURCING_STATUS",Header:"진행상태",			Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"BUYER",				Header:"고객사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
			,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}							
			,{ Align:"Center",	SaveName:"ATOS_END_DATE",		Header:"견적마감일",			Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"품목명",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"ITEM_QTY",			Header:"수량",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"KEP_USER_NAME",		Header:"KeP담당자",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ITEM_MAKE_TYPE",		Header:"품목구분",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"LEAD_TIME",			Header:"배송일수",				Type:"Int",			Width:80,	Edit:false,	EditLen:3,		Hidden:false}
			,{ Align:"Right",	SaveName:"STOA_LIST_PRICE",		Header:"제출단가\n(VAT별도)",	Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Format:"${priceFormat}"}
			,{ Align:"Right",	SaveName:"ORG_STOA_LIST_PRICE",	Header:"제출단가\n(VAT별도)",	Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Format:"${priceFormat}"}
			,{ Align:"Right",	SaveName:"MIN_ORDER_QTY",		Header:"최소주문\n수량",		Type:"Int",			Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"PUR_UNIT_QTY",		Header:"주문배수\n수량",		Type:"Int",			Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"PROCESS_NM",			Header:"거래유형",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"거래유형",				Type:"Combo",		Width:90,	Edit:false,	EditLen:100,	Hidden:true,	ComboText:"직납|TR",	ComboCode:"0|2"}
			,{ Align:"Center",	SaveName:"DELI_AREA_USE_FLAG",	Header:"납품지역",				Type:"Text",		Width:70,	Edit:false,	Hidden:true}
			,{ Align:"Center",	SaveName:"SELLER_AREA_YN",		Header:"납품지역",				Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	Hidden:false}
			,{ Align:"Center",	SaveName:"SELLER_AREA_TEXT",	Header:"납품지역",				Type:"Text",		Width:150,	Edit:false,	Hidden:true}
			,{ Align:"Center",	SaveName:"SELLER_AREA",			Header:"납품지역",				Type:"Text",		Width:150,	Edit:false,	Hidden:true}
			,{ Align:"Center",	SaveName:"RFQ_IMG_FLAG",		Header:"이미지",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"IMGFILE_NAME_YN",		Header:"이미지",				Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"IMGFILE_NAME",		Header:"이미지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"IMGFILE_DIR",			Header:"이미지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SELLER_IMAGE_KEY_YN",	Header:"첨부",				Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"SELLER_IMAGE_KEY",	Header:"첨부",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_REMARK",			Header:"협력사비고",			Type:"Text",		Width:80,	Edit:false,	EditLen:500,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_REMARK_YN",		Header:"협력사비고",			Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"ATOS_REMARK",			Header:"KeP비고",				Type:"Text",		Width:300,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"ATOS_REMARK_YN",		Header:"KeP비고",				Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"IMAGE_KEY_CNT",		Header:"KeP첨부",				Type:"Button",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type03'}
			,{ Align:"Center",	SaveName:"IMAGE_KEY",			Header:"KeP첨부",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
// 			,{ Align:"Center",	SaveName:"AGENT_SOURCING_STATUS_BUTTON",Header:"진행상태",		Type:"Image",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,ImgHeight:25,ImgWidth:80}
			,{ Align:"Center",	SaveName:"AGENT_REVISION_YN",	Header:"제출이력",				Type:"Image",		Cursor:"Pointer",Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"AGENT_REVISION",		Header:"차수",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"REVISION",			Header:"차수",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"QUOTATION_SEQ",		Header:"순번",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"MAKER_PART_NO",		Header:"모델번호",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"MAKER_NAME",			Header:"제조사",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"ORIGIN_NAME",			Header:"원산지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"DELY_TO_LOCATION",	Header:"예상 도착지",			Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"PRE_GR_FLAG",			Header:"선입고",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"TAX_TYPE",			Header:"과세",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ATOS_DATE",			Header:"견적요청일",			Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"SELLER_ITEM_NO",		Header:"협력사품목코드",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"AGENT",				Header:"협력사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SM_USER_NAME",		Header:"총괄담당자",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SM_USER_PHONE",		Header:"총괄담당자연락처",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SEL_USER_ID",			Header:"SEL_USER_ID",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			
			,{ Align:"Center",	SaveName:"MSDS_YN",				Header:"MSDS",				Type:"Combo",		Width:60,	Edit:false,	EditLen:100,	Hidden:true,	ComboText:"Y|N",	ComboCode:"Y|N",	BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"KEP_USER_PHONE",		Header:"담당자연락처",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SAFETY_FLAG_TEXT",	Header:"안전인증서상태",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
			
			,{ Align:"Center",	SaveName:"KEP_USER_ID",			Header:"KeP담당자ID",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"REF_NO",				Header:"관리번호",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SAFETY_FLAG",			Header:"안전인증서상태",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_DATE",			Header:"협력사제출일",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"STOA_TIME",			Header:"협력사제출시간",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PLANT",				Header:"PLANT",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"MOQ_USE_FLAG",		Header:"MOQ_USE_FLAG",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PROCESS_TYPE_FLAG",	Header:"PROCESS_TYPE_FLAG",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"GIVEUP_REMARK",		Header:"GIVEUP_REMARK",		Type:"Text",		Width:80,	Edit:false,	EditLen:500,	Hidden:true}
			,{ Align:"Center",	SaveName:"VAT_FLAG",			Header:"VAT_FLAG",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SG_ID",				Header:"SG_ID",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
	];
	
	
	
	IBS_InitSheet(mySheet0, initsheet0, pagingMode);
	IBS_InitSheet(mySheet1, initsheet1, pagingMode);
	IBS_InitSheet(mySheet2, initsheet2, pagingMode);
// 	IBS_InitSheet(mySheet3, initsheet3, pagingMode);
	

	mySheet1.SetColProperty("ITEM_MAKE_TYPE", comboInfo);
	mySheet2.SetColProperty("ITEM_MAKE_TYPE", comboInfo);
	
	mySheet0.SetHighlightAfterSort(2);
	mySheet1.SetHighlightAfterSort(2);
	mySheet2.SetHighlightAfterSort(2);
// 	mySheet3.SetHighlightAfterSort(2);
	
	mySheet0.SetCountFormat(" 총  ROWCOUNT 건 ");
	mySheet1.SetCountFormat(" 총  ROWCOUNT 건 ");
	mySheet2.SetCountFormat(" 총  ROWCOUNT 건 ");
// 	mySheet3.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet0.SetHeaderBackColor("#f2f7ff");
	mySheet1.SetHeaderBackColor("#f2f7ff");
	mySheet2.SetHeaderBackColor("#f2f7ff");
// 	mySheet3.SetHeaderBackColor("#f2f7ff");
	
	mySheet0.SetTheme("DB", "DeepBlue");
	mySheet1.SetTheme("DB", "DeepBlue");
	mySheet2.SetTheme("DB", "DeepBlue");
// 	mySheet3.SetTheme("DB", "DeepBlue");

	doAction('search');
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = "";
	selectedGrid = Sheet.FindCheckedRow("SELECTED");
	
	// 선택된 항목 유무 체크
	if (str != "search" && str != "reload" && selectedGrid.length == 0) {
// 		alert("선택된 항목이 없습니다.");
	var text = "선택된 항목이 없습니다.";
	openLayerPopText2(text,but1text,but1func,but1width);

		return;
	}

	switch (str) {
		case "search":	 // 조회
// 			if (kep_dateSearchCheck($("input[name=st_from_date]").eq(currIndex).val(),$("input[name=st_to_date]").eq(currIndex).val()) == false) return;
			if (kep_dateSearchCheck($("#st_from_date_"+currIndex).val(),$("#st_to_date_"+currIndex).val()) == false) return;
			var diff = kepGetDateDiff('st_from_date_'+currIndex,'st_to_date_'+currIndex,'D');
			if (eval(diff)>372){
// 				alert("1년 이내 조회만 가능합니다.");
				var text = "1년 이내 조회만 가능합니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			if(currIndex == 0){
				kepSearch(document.searchCondition0, Sheet, "/mprq/getSellerMpRqQuotaList_v2.do" , pagingMode);
			}else if(currIndex == 1){
				kepSearch(document.searchCondition1, Sheet, "/mprq/getSellerMpRqQuotaReqList_v2.do" , pagingMode);
			}else if(currIndex == 2){
				kepSearch(document.searchCondition2, Sheet, "/mprq/getSellerMpRqQuotaList_v2.do" , pagingMode);
			}else if(currIndex == 3){
				kepSearch(document.searchCondition3, Sheet, "/mprq/getSellerMpRqQuotaList_v2.do" , pagingMode);
			}
			break;
		case "reload":	// 초기화
			kepReload_v2('searchCondition'+currIndex);
			kepMonth_v2('st_from_date_'+currIndex,'st_to_date_'+currIndex,'3');
			Sheet.RemoveAll();
			break;
		case "agentHandout":
			$('#st_giveup_yn').val("N");
			agentHandout(str);
			break;
		case "cancel":
			$('#st_giveup_yn').val("Y");
			agentHandout(str);
			break;
		case "reqSourcing"://견적요청서 목록
			ReqSourcingList(str);
			break;
		case "report": //견적서 출력
			report();
			break;
		case "excelDownload": //엑셀다운로드
			excelDownload();
			break;
		case "saveInfo"://저장
			saveInfo();
			break;
		case "tmpSave"://임시저장
			$('#st_giveup_yn').val("S");
			agentHandout(str);
			break;
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
//조회 후처리
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
	var totRow = Sheet.RowCount();
	
	for(var i=1; i<=totRow;i++){
		
		if(<%=p03302303%> == true){
			Sheet.SetCellBackColor(i, "SELLER_ITEM_NO", "${optColor}");
		}
	}
}
//조회 후처리
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
	var totRow = Sheet.RowCount();
	
	for(var i=1; i<=totRow;i++){
		
		if(<%=p03302303%> == true){
			Sheet.SetCellBackColor(i, "SELLER_ITEM_NO", "${optColor}");
		}
		if(Sheet.GetCellValue(i,"MODIFY_FLAG") == "N"){ //수정 안되도록 막기
			Sheet.SetCellEditable(i,"ITEM_MAKE_TYPE",false);
			Sheet.SetCellEditable(i,"LEAD_TIME",false);
			Sheet.SetCellEditable(i,"ORG_STOA_LIST_PRICE",false);
			Sheet.SetCellEditable(i,"MIN_ORDER_QTY",false);
			Sheet.SetCellEditable(i,"PUR_UNIT_QTY",false);
			Sheet.SetCellEditable(i,"PRE_GR_FLAG",false);
			Sheet.SetCellEditable(i,"TAX_TYPE",false);
			Sheet.SetCellEditable(i,"SELLER_ITEM_NO",false);
		}
	}
	
}
//조회 후처리
function mySheet3_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
//팝업함수호출
function doPop(str, val1, val2) {
	popupSel = str;
	
	switch (str) {
	case "popMulti": // 납품지역 일괄선정
		popupSel = "popMulti";
		var checkRows = Sheet.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		if(arrRow.length <= 0){
// 			alert("선택된 항목이 없습니다.");
		var text = "선택된 항목이 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}else if(arrRow.length < 2){
// 			alert("일괄선정은 2건 이상 선택이 필요합니다.");
			var text = "일괄선정은 2건 이상 선택이 필요합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		var text = "선택된 항목들에 일괄적용됩니다. 진행하시겠습니까?";
		var but1textC = "확인";
		var but2textC = "취소";
		var but1funcC = "javascript:getSellerMpRqQuotMultiPop(); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);

		
// 		if(confirm("선택된 항목들에 일괄적용됩니다. 진행하시겠습니까?")){
// 			var src = "/mprq/getSellerMpRqQuotMultiPop_v2.do";
// 			openLayerPop(src,"500px","650px");
            
// // 			openSearchPopup("/common/getMultiPop_v2.do","", "500,550,no");	
// 		}
		
		break;
	}
}
function getSellerMpRqQuotMultiPop(){
	closePopText1();
	var src = "/mprq/getSellerMpRqQuotMultiPop_v2.do";
	openLayerPop(src,"500px","650px");
}
var changeFlag = false; // 클릭하고 수정 했는지 여부
// 그리드 셀클릭 이벤트
function mySheet0_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_agent_sourcing_status = Sheet.GetCellValue(Row, "AGENT_SOURCING_STATUS");
	var st_buyer = Sheet.GetCellValue(Row, "BUYER");
	var st_quotation_no = Sheet.GetCellValue(Row, "QUOTATION_NO");
	var st_quotation_seq = Sheet.GetCellValue(Row, "QUOTATION_SEQ");
	var st_revision = Sheet.GetCellValue(Row, "REVISION");
	var st_agent_revision = Sheet.GetCellValue(Row, "AGENT_REVISION");
	var st_agent = Sheet.GetCellValue(Row, "AGENT");
	var st_imgfile_dir = Sheet.GetCellValue(Row, "IMGFILE_DIR");
	var st_imgfile_name = Sheet.GetCellValue(Row, "IMGFILE_NAME");
	var st_image_key = Sheet.GetCellValue(Row, "IMAGE_KEY");
	var st_seller_image_key = Sheet.GetCellValue(Row, "SELLER_IMAGE_KEY");
	var st_stoa_remark = Sheet.GetCellValue(Row, "STOA_REMARK");
	var st_atos_remark = Sheet.GetCellValue(Row, "ATOS_REMARK");
	var st_seller_area = Sheet.GetCellValue(Row, "SELLER_AREA");
	var st_plant = Sheet.GetCellValue(Row, "PLANT");
	var st_seller_area_flag = Sheet.GetCellValue(Row, "DELI_AREA_USE_FLAG");
	var st_kep_user_id = Sheet.GetCellValue(Row, "KEP_USER_ID");
	
	if(column == "AGENT_REVISION_YN"){
		var src = '/mprq/showSellerMpRqUnitPriceHistoryPop.do?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_agent='+st_agent;
		openLayerPop(src,"850px","420px");
// 		openSearchPopup("/mprq/showSellerMpRqUnitPriceHistoryPop.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_agent='+st_agent, "850,400,no");
	}
	
	if(column == "STOA_REMARK_YN"){ //협력사 비고
		if(Sheet.GetCellValue(Row, "STOA_REMARK") == "")
			return;
	
		var src = '/common/remarkStoAPop.do?st_stoa_remark='+encodeURIComponent(st_stoa_remark)+'&viewType=R';
		openLayerPop(src,"540px","420px");
// 		openSearchPopup("/common/remarkStoAPop.do", '?st_stoa_remark='+st_stoa_remark+'&viewType=R', "540,420,no");
	}
	if(column == "ATOS_REMARK_YN"){ //운영사 비고
		if(Sheet.GetCellValue(Row, "ATOS_REMARK") == "")
			return;
		var src = '/common/remarkAtoSPop.do?st_atos_remark='+encodeURIComponent(st_atos_remark)+'&viewType=R';
		openLayerPop(src,"540px","420px");
        
// 		openSearchPopup("/common/remarkAtoSPop.do", '?st_atos_remark='+st_atos_remark+'&viewType=R', "540,420,no");
	}
	
	if(column == "IMAGE_KEY_CNT"){
		if(Sheet.GetCellValue(Row, "IMAGE_KEY") == "")
			return;
		location.href="/common/download_v2.do?DOC_NO="+st_image_key;
	}
	
	if(column == "SELLER_IMAGE_KEY_YN"){
		if(Sheet.GetCellValue(Row, "SELLER_IMAGE_KEY") == "")
			return;
		
		var src = '/common/fileUploadPop_v2.do?DOC_NO='+st_seller_image_key+'&viewType=R';
		openLayerPop(src,"600px","490px");
        
// 		openSearchPopup("/common/fileUploadPop_v2.do", '?DOC_NO='+st_seller_image_key+'&viewType=R', "600,490,no");
	}
	
	if(column == "IMGFILE_NAME_YN"){
		if(Sheet.GetCellValue(Row, "IMGFILE_NAME") == "")
			return;
		
		var src = '/common/imageUploadPop_v2.do?IMGFILE_DIR='+st_imgfile_dir+'&IMGFILE_NAME='+st_imgfile_name+'&viewType=R';
		openLayerPop(src,"600px","490px");
        
// 		openSearchPopup("/common/imageUploadPop_v2.do", '?IMGFILE_DIR='+st_imgfile_dir+'&IMGFILE_NAME='+st_imgfile_name+'&viewType=R', "600,490,no");
	}
	if(column == "SELLER_AREA_YN"){
		if(st_seller_area == ""){
			return;
		}		
		var stoa_date = "";
		var stoa_time = "";
		var mod_yn = "Y";
		
		stoa_date = Sheet.GetCellValue(Row, "STOA_DATE");
		stoa_time = Sheet.GetCellValue(Row, "STOA_TIME");
		
		if(stoa_date != "" || stoa_time != ""){
			mod_yn = "N";
		}
		
		if(st_seller_area_flag == "Y"){
			var src = "/common/getDeliveryAreaPop_v2.do?st_com_code="+st_buyer+"&st_area_list="+st_seller_area+"&mod_yn="+mod_yn+"&plant_code="+st_plant+"&viewType=R";
			openLayerPop(src,"465px","470px");
// 			openSearchPopup("/common/getDeliveryAreaPop_v2.do", '?st_com_code='+st_buyer+'&st_area_list='+st_seller_area+'&mod_yn='+mod_yn+'&plant_code='+st_plant+"&viewType=R", "465,465,no");	
		}else{
// 			alert("해당 고객사는 납품지역 선택이 불필요합니다.");
			var text = "해당 고객사는 납품지역 선택이 불필요합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}
	if(column == "KEP_USER_NAME"){
		var src = "/mprq/quotUserInfoDisplayPop_v2.do?st_user_id="+st_kep_user_id; 
		openLayerPop(src,"680px","300px");
	}
	
	return;
}
//그리드 셀클릭 이벤트
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if(Sheet.GetCellValue(grbRow,"CHANGE_FLAG") != "Y"){ //그전 클릭한 row가 수정되었으면 색 그대로 유지, 아니면 원래색
		Sheet.SetRowBackColor(grbRow, "");
	}
	
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_buyer = Sheet.GetCellValue(Row, "BUYER");
	var st_quotation_no = Sheet.GetCellValue(Row, "QUOTATION_NO");
	var st_quotation_seq = Sheet.GetCellValue(Row, "QUOTATION_SEQ");
	var st_revision = Sheet.GetCellValue(Row, "REVISION");
	var st_agent_revision = Sheet.GetCellValue(Row, "AGENT_REVISION");
	var st_agent = Sheet.GetCellValue(Row, "AGENT");
	var st_seller_area = Sheet.GetCellValue(Row, "SELLER_AREA");
	var st_plant = Sheet.GetCellValue(Row, "PLANT");
	var st_seller_area_flag = Sheet.GetCellValue(Row, "DELI_AREA_USE_FLAG");
	var st_seller_image_key = Sheet.GetCellValue(Row, "SELLER_IMAGE_KEY");
	var st_imgfile_name = Sheet.GetCellValue(Row, "IMGFILE_NAME");
	var st_imgfile_dir = Sheet.GetCellValue(Row, "IMGFILE_DIR");
	var st_stoa_remark = Sheet.GetCellValue(Row, "STOA_REMARK");
	var st_atos_remark = Sheet.GetCellValue(Row, "ATOS_REMARK");
	var st_buyer_item_no = Sheet.GetCellValue(Row,"BUYER_ITEM_NO");
	var st_image_key = Sheet.GetCellValue(Row, "IMAGE_KEY");
	var st_kep_user_id = Sheet.GetCellValue(Row, "KEP_USER_ID");
	
	if(column == "QUOTATION_NO"){
		var src = '/mprq/showSellerMpRqQuotaDetailPop_v2.do?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_agent='+st_agent+'&st_agent_revision='+st_agent_revision;
		openLayerPop(src,"800px","800px");
        
// 		openSearchPopup("/mprq/showSellerMpRqQuotaDetailPop_v2.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_agent='+st_agent+'&st_agent_revision='+st_agent_revision, "800,800,no");
	}
	if(column == "AGENT_REVISION_YN"){
		var src = '/mprq/showSellerMpRqUnitPriceHistoryPop.do?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_agent='+st_agent;
		openLayerPop(src,"850px","420px");
        
// 		openSearchPopup("/mprq/showSellerMpRqUnitPriceHistoryPop.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_agent='+st_agent, "850,400,no");
	}
	if(column == "IMAGE_KEY_CNT"){
		if(Sheet.GetCellValue(Row, "IMAGE_KEY") == "")
			return;
		location.href="/common/download_v2.do?DOC_NO="+st_image_key;
	}
	if(column == "SELLER_AREA_YN"){
		popupSel = "seller_area";
		
		var stoa_date = "";
		var stoa_time = "";
		var mod_yn = "Y";
		
		stoa_date = Sheet.GetCellValue(Row, "STOA_DATE");
		stoa_time = Sheet.GetCellValue(Row, "STOA_TIME");
		
		if(stoa_date != "" || stoa_time != ""){
			mod_yn = "N";
		}
		
		if(st_seller_area_flag == "Y"){
			var src = "/common/getDeliveryAreaPop_v2.do?st_com_code="+st_buyer+"&st_area_list="+st_seller_area+"&mod_yn="+mod_yn+"&plant_code="+st_plant;
			openLayerPop(src,"465px","490px");
	        
// 			openSearchPopup("/common/getDeliveryAreaPop_v2.do", '?st_com_code='+st_buyer+'&st_area_list='+st_seller_area+'&mod_yn='+mod_yn+'&plant_code='+st_plant, "465,465,no");	
		}else{
// 			alert("해당 고객사는 납품지역 선택이 불필요합니다.");
			var text = "해당 고객사는 납품지역 선택이 불필요합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}
	if( column == "STOA_REMARK_YN"){ //협력사 비고
		popupSel = "stoa_remark";
	
		var src = '/common/remarkStoAPop.do?st_stoa_remark='+encodeURIComponent(st_stoa_remark)+'&viewType=W';
		openLayerPop(src,"540px","440px");
        
// 		openSearchPopup("/common/remarkStoAPop.do", '?st_stoa_remark='+st_stoa_remark+'&viewType=W', "540,420,no");
	}
	if(column == "ATOS_REMARK_YN"){ //운영사 비고
		if(Sheet.GetCellValue(Row, "ATOS_REMARK") == "")
			return;
	
		var src = '/common/remarkAtoSPop.do?st_atos_remark='+encodeURIComponent(st_atos_remark)+'&viewType=R';
		openLayerPop(src,"540px","420px");
        
// 		openSearchPopup("/common/remarkAtoSPop.do", '?st_atos_remark='+st_atos_remark+'&viewType=R', "540,420,no");
	}
	if(column == "SELLER_IMAGE_KEY_YN"){
		popupSel = "seller_image_key";
		
		var src = '/common/fileUploadPop_v2.do?DOC_NO='+st_seller_image_key+'&viewType=W&TYPE=RFQ';
		openLayerPop(src,"600px","510px");
        
// 		openSearchPopup("/common/fileUploadPop_v2.do", '?DOC_NO='+st_seller_image_key+'&viewType=W&TYPE=RFQ', "600,490,no");
	}
	
	if(column == "IMGFILE_NAME_YN"){
		popupSel = "imgfile_name";
		
		var src = '/common/imageUploadPop_v2.do?IMGFILE_DIR='+st_imgfile_dir+'&IMGFILE_NAME='+st_imgfile_name+'&st_buyer_item_no='+st_buyer_item_no+'&st_agent='+st_agent+'&viewType=W';
		openLayerPop(src,"600px","510px");
        
// 		openSearchPopup("/common/imageUploadPop_v2.do", '?IMGFILE_DIR='+st_imgfile_dir+'&IMGFILE_NAME='+st_imgfile_name+'&st_buyer_item_no='+st_buyer_item_no+'&st_agent='+st_agent+'&viewType=W', "600,490,no");
	}
	if(column == "KEP_USER_NAME"){
		var src = "/mprq/quotUserInfoDisplayPop_v2.do?st_user_id="+st_kep_user_id; 
		openLayerPop(src,"680px","300px");
	}
	Sheet.SetRowBackColor(Row, "#F5F9FF");
	return;
}
//그리드 셀클릭 이벤트
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if(Sheet.GetCellValue(grbRow,"CHANGE_FLAG") != "Y"){ //그전 클릭한 row가 수정되었으면 색 그대로 유지, 아니면 원래색
		Sheet.SetRowBackColor(grbRow, "");
	}
	
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_agent_sourcing_status = Sheet.GetCellValue(Row, "AGENT_SOURCING_STATUS");
	var st_buyer = Sheet.GetCellValue(Row, "BUYER");
	var st_quotation_no = Sheet.GetCellValue(Row, "QUOTATION_NO");
	var st_quotation_seq = Sheet.GetCellValue(Row, "QUOTATION_SEQ");
	var st_revision = Sheet.GetCellValue(Row, "REVISION");
	var st_agent_revision = Sheet.GetCellValue(Row, "AGENT_REVISION");
	var st_agent = Sheet.GetCellValue(Row, "AGENT");
	var st_imgfile_dir = Sheet.GetCellValue(Row, "IMGFILE_DIR");
	var st_imgfile_name = Sheet.GetCellValue(Row, "IMGFILE_NAME");
	var st_image_key = Sheet.GetCellValue(Row, "IMAGE_KEY");
	var st_seller_image_key = Sheet.GetCellValue(Row, "SELLER_IMAGE_KEY");
	var st_seller_area = Sheet.GetCellValue(Row, "SELLER_AREA");
	var st_plant = Sheet.GetCellValue(Row, "PLANT");
	var st_seller_area_flag = Sheet.GetCellValue(Row, "DELI_AREA_USE_FLAG");
	var st_stoa_remark = Sheet.GetCellValue(Row, "STOA_REMARK");
	var st_atos_remark = Sheet.GetCellValue(Row, "ATOS_REMARK");
	var st_buyer_item_no = Sheet.GetCellValue(Row,"BUYER_ITEM_NO");
	var st_modify_flag = Sheet.GetCellValue(Row,"MODIFY_FLAG");
	var st_kep_user_id = Sheet.GetCellValue(Row, "KEP_USER_ID");
	
	var st_view_type = "";
	if(st_modify_flag == "N"){
		st_view_type = "R";
	}else{
		st_view_type = "W";
	}
	if(column == "AGENT_REVISION_YN"){
		var src = '/mprq/showSellerMpRqUnitPriceHistoryPop.do?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_agent='+st_agent;
		openLayerPop(src,"850px","420px");
// 		openSearchPopup("/mprq/showSellerMpRqUnitPriceHistoryPop.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_agent='+st_agent, "850,400,no");
	}
	
	if(column == "QUOTATION_NO"){
		var src = '/mprq/showSellerMpRqQuotaDetailPop_v2.do?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_agent='+st_agent+'&st_agent_revision='+st_agent_revision;
		openLayerPop(src,"800px","800px");
        
// 		openSearchPopup("/mprq/showSellerMpRqQuotaDetailPop_v2.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_agent='+st_agent+'&st_agent_revision='+st_agent_revision, "800,800,no");
	}
	
	if(column == "IMAGE_KEY_CNT"){
		if(Sheet.GetCellValue(Row, "IMAGE_KEY") == "")
			return;
		location.href="/common/download_v2.do?DOC_NO="+st_image_key;
	}
	
	if( column == "STOA_REMARK_YN"){ //협력사 비고
		popupSel = "stoa_remark";
		var src = '/common/remarkStoAPop.do?st_stoa_remark='+encodeURIComponent(st_stoa_remark)+'&viewType='+st_view_type;
		openLayerPop(src,"540px","440px");
        
// 		openSearchPopup("/common/remarkStoAPop.do", '?st_stoa_remark='+st_stoa_remark+'&viewType=W', "540,420,no");
	}
	if(column == "ATOS_REMARK_YN"){ //운영사 비고
		if(Sheet.GetCellValue(Row, "ATOS_REMARK") == "")
			return;
	
		var src = '/common/remarkAtoSPop.do?st_atos_remark='+encodeURIComponent(st_atos_remark)+'&viewType=R';
		openLayerPop(src,"540px","420px");
// 		openSearchPopup("/common/remarkAtoSPop.do", '?st_atos_remark='+st_atos_remark+'&viewType=R', "540,420,no");
	}
	if(column == "SELLER_IMAGE_KEY_YN"){
		popupSel = "seller_image_key";
		
		var src = '/common/fileUploadPop_v2.do?DOC_NO='+st_seller_image_key+'&TYPE=RFQ&viewType='+st_view_type;
		openLayerPop(src,"600px","510px");
        
// 		openSearchPopup("/common/fileUploadPop_v2.do", '?DOC_NO='+st_seller_image_key+'&viewType=W&TYPE=RFQ', "600,490,no");
	}
	
	if(column == "IMGFILE_NAME_YN"){
		popupSel = "imgfile_name";
		
		var src = '/common/imageUploadPop_v2.do?IMGFILE_DIR='+st_imgfile_dir+'&IMGFILE_NAME='+st_imgfile_name+'&st_buyer_item_no='+st_buyer_item_no+'&st_agent='+st_agent+'&viewType='+st_view_type;
		openLayerPop(src,"600px","510px");
// 		openSearchPopup("/common/imageUploadPop_v2.do", '?IMGFILE_DIR='+st_imgfile_dir+'&IMGFILE_NAME='+st_imgfile_name+'&st_buyer_item_no='+st_buyer_item_no+'&st_agent='+st_agent+'&viewType=W', "600,490,no");
	}
	if(column == "SELLER_AREA_YN"){
		popupSel = "seller_area";
		
		var stoa_date = "";
		var stoa_time = "";
		var mod_yn = "Y";
		
		stoa_date = Sheet.GetCellValue(Row, "STOA_DATE");
		stoa_time = Sheet.GetCellValue(Row, "STOA_TIME");
		
		if(stoa_date != "" || stoa_time != ""){
			mod_yn = "N";
		}
		
		if(st_seller_area_flag == "Y"){
			
			var src = "/common/getDeliveryAreaPop_v2.do?st_com_code="+st_buyer+"&st_area_list="+st_seller_area+"&mod_yn="+mod_yn+"&plant_code="+st_plant+"&viewType="+st_view_type;
			openLayerPop(src,"465px","490px");
// 			openSearchPopup("/common/getDeliveryAreaPop_v2.do", '?st_com_code='+st_buyer+'&st_area_list='+st_seller_area+'&mod_yn='+mod_yn+'&plant_code='+st_plant, "465,465,no");	
		}else{
// 			alert("해당 고객사는 납품지역 선택이 불필요합니다.");
			var text = "해당 고객사는 납품지역 선택이 불필요합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}
	if(column == "KEP_USER_NAME"){
		var src = "/mprq/quotUserInfoDisplayPop_v2.do?st_user_id="+st_kep_user_id; 
		openLayerPop(src,"680px","300px");
	}
	Sheet.SetRowBackColor(Row, "#F5F9FF");
	return;
}
//그리드 셀클릭 이벤트
function mySheet3_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_agent_sourcing_status = Sheet.GetCellValue(Row, "AGENT_SOURCING_STATUS");
	var st_buyer = Sheet.GetCellValue(Row, "BUYER");
	var st_quotation_no = Sheet.GetCellValue(Row, "QUOTATION_NO");
	var st_quotation_seq = Sheet.GetCellValue(Row, "QUOTATION_SEQ");
	var st_revision = Sheet.GetCellValue(Row, "REVISION");
	var st_agent_revision = Sheet.GetCellValue(Row, "AGENT_REVISION");
	var st_agent = Sheet.GetCellValue(Row, "AGENT");
	var st_imgfile_dir = Sheet.GetCellValue(Row, "IMGFILE_DIR");
	var st_imgfile_name = Sheet.GetCellValue(Row, "IMGFILE_NAME");
	var st_image_key = Sheet.GetCellValue(Row, "IMAGE_KEY");
	var st_seller_image_key = Sheet.GetCellValue(Row, "SELLER_IMAGE_KEY");
	var st_stoa_remark = Sheet.GetCellValue(Row, "STOA_REMARK");
	var st_atos_remark = Sheet.GetCellValue(Row, "ATOS_REMARK");
	var st_seller_area = Sheet.GetCellValue(Row, "SELLER_AREA");
	var st_plant = Sheet.GetCellValue(Row, "PLANT");
	var st_seller_area_flag = Sheet.GetCellValue(Row, "DELI_AREA_USE_FLAG");
	
	if(column == "AGENT_REVISION_YN"){
		var src = '/mprq/showSellerMpRqUnitPriceHistoryPop.do?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_agent='+st_agent;
		openLayerPop(src,"850px","420px");
// 		openSearchPopup("/mprq/showSellerMpRqUnitPriceHistoryPop.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_agent='+st_agent, "850,400,no");
	}
	
	if(column == "QUOTATION_NO"){
		var src = '/mprq/showSellerMpRqQuotaDetailPop_v2.do?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_agent='+st_agent+'&st_agent_revision='+st_agent_revision;
		openLayerPop(src,"800px","800px");
        
// 		openSearchPopup("/mprq/showSellerMpRqQuotaDetailPop_v2.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_agent='+st_agent+'&st_agent_revision='+st_agent_revision, "800,800,no");
	}
	if(column == "STOA_REMARK_YN"){ //협력사 비고
		if(Sheet.GetCellValue(Row, "STOA_REMARK") == "")
			return;
	
		var src = '/common/remarkStoAPop.do?st_stoa_remark='+encodeURIComponent(st_stoa_remark)+'&viewType=R';
		openLayerPop(src,"540px","420px");
// 		openSearchPopup("/common/remarkStoAPop.do", '?st_stoa_remark='+st_stoa_remark+'&viewType=R', "540,420,no");
	}
	if(column == "ATOS_REMARK_YN"){ //운영사 비고
		if(Sheet.GetCellValue(Row, "ATOS_REMARK") == "")
			return;
	
		var src = '/common/remarkAtoSPop.do?st_atos_remark='+encodeURIComponent(st_atos_remark)+'&viewType=R';
		openLayerPop(src,"540px","420px");
// 		openSearchPopup("/common/remarkAtoSPop.do", '?st_atos_remark='+st_atos_remark+'&viewType=R', "540,420,no");
	}
	if(column == "IMAGE_KEY_CNT"){
		if(Sheet.GetCellValue(Row, "IMAGE_KEY") == "")
			return;
		location.href="/common/download_v2.do?DOC_NO="+st_image_key;
	}
	
	if(column == "SELLER_IMAGE_KEY_YN"){
		if(Sheet.GetCellValue(Row, "SELLER_IMAGE_KEY") == "")
			return;
		
		var src = '/common/fileUploadPop_v2.do?DOC_NO='+st_seller_image_key+'&viewType=R';
		openLayerPop(src,"600px","490px");
// 		openSearchPopup("/common/fileUploadPop_v2.do", '?DOC_NO='+st_seller_image_key+'&viewType=R', "600,490,no");
	}
	
	if(column == "IMGFILE_NAME_YN"){
		if(Sheet.GetCellValue(Row, "IMGFILE_NAME") == "")
			return;
		
		var src = '/common/imageUploadPop_v2.do?IMGFILE_DIR='+st_imgfile_dir+'&IMGFILE_NAME='+st_imgfile_name+'&viewType=R';
		openLayerPop(src,"600px","490px");
// 		openSearchPopup("/common/imageUploadPop_v2.do", '?IMGFILE_DIR='+st_imgfile_dir+'&IMGFILE_NAME='+st_imgfile_name+'&viewType=R', "600,490,no");
	}
	if(column == "SELLER_AREA_YN"){
		if(st_seller_area == ""){
			return;
		}
		
		var stoa_date = "";
		var stoa_time = "";
		var mod_yn = "Y";
		
		stoa_date = Sheet.GetCellValue(Row, "STOA_DATE");
		stoa_time = Sheet.GetCellValue(Row, "STOA_TIME");
		
		if(stoa_date != "" || stoa_time != ""){
			mod_yn = "N";
		}
		
		if(st_seller_area_flag == "Y"){
			var src = "/common/getDeliveryAreaPop_v2.do?st_com_code="+st_buyer+"&st_area_list="+st_seller_area+"&mod_yn="+mod_yn+"&plant_code="+st_plant+"&viewType=R";
			openLayerPop(src,"465px","470px");
// 			openSearchPopup("/common/getDeliveryAreaPop_v2.do", '?st_com_code='+st_buyer+'&st_area_list='+st_seller_area+'&mod_yn='+mod_yn+'&plant_code='+st_plant+"&viewType=R", "465,465,no");	
		}else{
// 			alert("해당 고객사는 납품지역 선택이 불필요합니다.");
			var text = "해당 고객사는 납품지역 선택이 불필요합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}
	return;
}

function mySheet1_OnChange(Row, Col, Value) {

	if ( Row  < 1) return;

	var column = Sheet.ColSaveName(Col);
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if(column =="ORG_STOA_LIST_PRICE"){//VAT별도 금액
		var st_list_price = Sheet.GetCellValue(Row, "ORG_STOA_LIST_PRICE");
		if(st_list_price != "" && st_list_price <= 0){
// 			alert("유효하지 않는 견적단가입니다.");
			Sheet.SetCellValue(Row, "ORG_STOA_LIST_PRICE",0);
			var text = "유효하지 않는 견적단가입니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
// 		var st_tax_type = Sheet.GetCellValue(Row, "TAX_TYPE");
// 		var st_vat_list_price = 0;
// 		var st_vat_list_price_amt = 0;
// 		var item_qty = Sheet.GetCellValue(Row,"ITEM_QTY");
		
// 		if(st_tax_type =="12"){//면세일경우 부가세 제외 처리
// 			Sheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE",st_list_price);
// 			Sheet.SetCellValue(Row, "STOA_LIST_PRICE_AMT",st_list_price * item_qty);
// 			Sheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE_AMT",st_list_price * item_qty);
// 		}else{//과세일경우 부가세 처리 st_tax_type ="11"
// 			st_vat_list_price = kepGetRound2(st_list_price*1.1,1);
// 			Sheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE",st_vat_list_price);
// 			Sheet.SetCellValue(Row, "STOA_LIST_PRICE_AMT",st_list_price * item_qty);
// 			st_vat_list_price_amt = kepGetRound2(st_list_price*1.1*item_qty,1);
// 			Sheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE_AMT",st_vat_list_price_amt);
// 		}
		
	}else if(column =="TAX_TYPE"){
// 		var st_list_price = Sheet.GetCellValue(Row, "STOA_LIST_PRICE");
// 		var item_qty = Sheet.GetCellValue(Row,"ITEM_QTY");
		
// 		//제출단가가 들어갈 경우만 해당 됨.
// 		if(st_list_price != ""){
// 			var st_tax_type = Sheet.GetCellValue(Row, "TAX_TYPE");
// 			var st_vat_list_price = 0;
// 			var st_vat_list_price_amt = 0;
			
// 			if(st_tax_type =="12"){//면세일경우 부가세 제외 처리
// 				Sheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE",st_list_price);
// 				Sheet.SetCellValue(Row, "STOA_LIST_PRICE_AMT",st_list_price * item_qty);
// 				Sheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE_AMT",st_list_price * item_qty);
// 			}else{//과세일경우 부가세 처리 st_tax_type ="11"
// 				st_vat_list_price = kepGetRound2(st_list_price*1.1,1);
// 				Sheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE",st_vat_list_price);
// 				Sheet.SetCellValue(Row, "STOA_LIST_PRICE_AMT",st_list_price * item_qty);
// 				st_vat_list_price_amt = kepGetRound2(st_list_price*1.1*item_qty,1);
// 				Sheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE_AMT",st_vat_list_price_amt);
// 			}				
// 		}
	}else if(column =="ITEM_MAKE_TYPE"){//품목구분
		var st_item_make_type = Sheet.GetCellValue(Row, "ITEM_MAKE_TYPE");
		var st_lead_time = Sheet.GetCellValue(Row, "LEAD_TIME");
		var new_lead_time = 0;
		if( st_item_make_type == "ST"){
			new_lead_time = 3;
		}else if( st_item_make_type == "MK"){
			new_lead_time = 7;
		}else if( st_item_make_type == "SI" || st_item_make_type == "MI"){
			new_lead_time = 30;
		}
		
		if(st_lead_time != ""){
// 			alert("선택하신 품목구분에 따라 기본 배송일수가 자동으로 변경되었습니다. 변경된 배송일수를 확인해 주세요.");
			var text = "선택하신 품목구분에 따라 기본 배송일수가 자동으로 변경되었습니다.</br>변경된 배송일수를 확인해 주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
		}
		Sheet.SetCellValue(Row, "LEAD_TIME", new_lead_time);
		Sheet.SelectCell(Row, "LEAD_TIME");
	}else if(column =="MIN_ORDER_QTY" || column =="PUR_UNIT_QTY"){//최소주문수량 , 주문배수수량
		var min_order_qty = Sheet.GetCellValue(Row, "MIN_ORDER_QTY");
		var pur_unit_qty = Sheet.GetCellValue(Row, "PUR_UNIT_QTY");
		if((min_order_qty != "" && min_order_qty <= 0)){
// 			alert("유효하지 않는 수량입니다.");
			var text = "유효하지 않는 수량입니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			Sheet.SetCellValue(Row, "MIN_ORDER_QTY",0);
			return;
		}
		if((pur_unit_qty != "" && pur_unit_qty <= 0)){
// 			alert("유효하지 않는 수량입니다.");
			var text = "유효하지 않는 수량입니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			Sheet.SetCellValue(Row, "PUR_UNIT_QTY",0);
			return;
		}
	}
	Sheet.SetCellValue(Row,"CHANGE_FLAG","Y"); //수정되었는지 확인용도
	Sheet.SetCellValue(Row,"SELECTED",true); //수정하면 체크처리
}
function mySheet2_OnChange(Row, Col, Value) {

	if ( Row  < 1) return;

	var column = Sheet.ColSaveName(Col);
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if(column =="ORG_STOA_LIST_PRICE"){//VAT별도 금액
		var st_list_price = Sheet.GetCellValue(Row, "ORG_STOA_LIST_PRICE");
		if(st_list_price != "" && st_list_price <= 0){
// 			alert("유효하지 않는 견적단가입니다.");
			var text = "유효하지 않는 견적단가입니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			Sheet.SetCellValue(Row, "ORG_STOA_LIST_PRICE",0);
			return;
		}
// 		var st_tax_type = Sheet.GetCellValue(Row, "TAX_TYPE");
// 		var st_vat_list_price = 0;
// 		var st_vat_list_price_amt = 0;
// 		var item_qty = Sheet.GetCellValue(Row,"ITEM_QTY");
		
// 		if(st_tax_type =="12"){//면세일경우 부가세 제외 처리
// 			Sheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE",st_list_price);
// 			Sheet.SetCellValue(Row, "STOA_LIST_PRICE_AMT",st_list_price * item_qty);
// 			Sheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE_AMT",st_list_price * item_qty);
// 		}else{//과세일경우 부가세 처리 st_tax_type ="11"
// 			st_vat_list_price = kepGetRound2(st_list_price*1.1,1);
// 			Sheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE",st_vat_list_price);
// 			Sheet.SetCellValue(Row, "STOA_LIST_PRICE_AMT",st_list_price * item_qty);
// 			st_vat_list_price_amt = kepGetRound2(st_list_price*1.1*item_qty,1);
// 			Sheet.SetCellValue(Row, "STOA_VAT_LIST_PRICE_AMT",st_vat_list_price_amt);
// 		}
	}else if(column =="ITEM_MAKE_TYPE"){//품목구분
		var st_item_make_type = Sheet.GetCellValue(Row, "ITEM_MAKE_TYPE");
		var st_lead_time = Sheet.GetCellValue(Row, "LEAD_TIME");
		var new_lead_time = 0;
		if( st_item_make_type == "ST"){
			new_lead_time = 3;
		}else if( st_item_make_type == "MK"){
			new_lead_time = 7;
		}else if( st_item_make_type == "SI" || st_item_make_type == "MI"){
			new_lead_time = 30;
		}
		
		if(st_lead_time != ""){
// 			alert("선택하신 품목구분에 따라 기본 배송일수가 자동으로 변경되었습니다. 변경된 배송일수를 확인해 주세요.");
			var text = "선택하신 품목구분에 따라 기본 배송일수가 자동으로 변경되었습니다.</br>변경된 배송일수를 확인해 주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
		}
		Sheet.SetCellValue(Row, "LEAD_TIME", new_lead_time);
		Sheet.SelectCell(Row, "LEAD_TIME");
	}else if(column =="MIN_ORDER_QTY" || column =="PUR_UNIT_QTY"){//최소주문수량 , 주문배수수량
		var min_order_qty = Sheet.GetCellValue(Row, "MIN_ORDER_QTY");
		var pur_unit_qty = Sheet.GetCellValue(Row, "PUR_UNIT_QTY");
		if((min_order_qty != "" && min_order_qty <= 0)){
// 			alert("유효하지 않는 수량입니다.");
			var text = "유효하지 않는 수량입니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			Sheet.SetCellValue(Row, "MIN_ORDER_QTY",0);
			return;
		}
		if((pur_unit_qty != "" && pur_unit_qty <= 0)){
// 			alert("유효하지 않는 수량입니다.");
			var text = "유효하지 않는 수량입니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			Sheet.SetCellValue(Row, "PUR_UNIT_QTY",0);
			return;
		}
	}
	Sheet.SetCellValue(Row,"CHANGE_FLAG","Y"); //수정되었는지 확인용도
	Sheet.SetCellValue(Row,"SELECTED",true); //수정하면 체크처리
}
//트랜젝션(저장,삽입등) 후처리
function mySheet1_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		if ( code > 0 ) {
			Sheet.SetColProperty("ITEM_MAKE_TYPE",{KeyField:true});
			Sheet.SetColProperty("LEAD_TIME",{KeyField:true});
			Sheet.SetColProperty("MIN_ORDER_QTY",{KeyField:true});
			Sheet.SetColProperty("PUR_UNIT_QTY",{KeyField:true});
			Sheet.SetColProperty("ORG_STOA_LIST_PRICE",{KeyField:true});
			//저장 성공시 처리
			var text = msg.msg;
			openLayerPopText2(text,but1text,but1funcSearch,but1width);
		}else{
			var text = msg.msg;
			openLayerPopText2(text,but1text,but1func,but1width);
		}
// 		alert(msg.msg);
		
	}
	
}
//트랜젝션(저장,삽입등) 후처리
function mySheet2_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		if ( code > 0 ) {
			//저장 성공시 처리
			var text = msg.msg;
			openLayerPopText2(text,but1text,but1funcSearch,but1width);
		}else{
			var text = msg.msg;
			openLayerPopText2(text,but1text,but1func,but1width);
		}
// 		alert(msg.msg);
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
	downCol = downCol+"|ATOS_REMARK|SM_USER_NAME|SM_USER_PHONE";
	
	if(downRow == "|0"){
		downRow = "";
	}
	var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
	
	var fileName = "";
	if(currIndex == 0){
		fileName = "일반견적_전체_";
	}else if(currIndex == 1){
		fileName = "일반견적_견적요청_";
	}else if(currIndex == 2){
		fileName = "일반견적_견적제출_";
	}else if(currIndex == 3){
		fileName = "일반견적_단가선정_";
	}
	
	var param = {FileName:fileName+nowTime, SheetName:fileName, DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
	Sheet.Down2Excel(param);
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

//견적요청서
function req_print(buyer,quotation_no,quotation_seq,revision,kep_user_id,ref_no){
	//SLOGIC-BEGIN(P04-4040-05)
	var param = "";
	var fileName = "";
	var rfq_gubun = ref_no;
	if(buyer == "KRDOOD0001"){
	    if(rfq_gubun == "RFQ"){
	    	fileName = "RD_04_M_005_02";
	    	param =  "["+quotation_no+"]["+revision+"]["+buyer+"]";
	    }else{
	    	fileName = "RD_04_M_006_02"; //견적번호기준으로 품목 나오도록 수정.2015.1.15 현업 협의완료.
	    	param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+kep_user_id+"]["+"${sessionInfo.comCode}"+"]";	
	    }
    }else if(buyer == "KRSAMS0123" || buyer == "KRSAMS0192"){ //삼성전자 관리번호 필드 추가 
    	fileName = "RD_04_M_006_03";
    	param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+kep_user_id+"]["+"${sessionInfo.comCode}"+"]";
    }else {
    	fileName = "RD_04_M_006_01";
    	param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+kep_user_id+"]["+"${sessionInfo.comCode}"+"]";
    }
	reportOpen(fileName,param);
	//SLOGIC-END
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2,value3,value4,value5,value6,value7,value8){
	if(popupSel == "seller_area"){
		Sheet.SetCellValue(grbRow, 'SELLER_AREA', value1);
		if(value1 != ""){
			Sheet.SetCellValue(grbRow, 'SELLER_AREA_YN', '/resources/imgs/Btn_RegEnd.gif');
		}else{
			Sheet.SetCellValue(grbRow, 'SELLER_AREA_YN', '/resources/imgs/Btn_RegIng.gif');
		}
		
	}else if(popupSel == "popMulti") {	// 납품지역 일괄선정
		var checkRows = Sheet.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		for(var idx=0; idx<arrRow.length; idx++){
			if(value1 != ""){ //최소주문수량
				Sheet.SetCellValue(arrRow[idx], 'MIN_ORDER_QTY', value1);
			}
			if(value2 != ""){ //주문배수수량
				Sheet.SetCellValue(arrRow[idx], 'PUR_UNIT_QTY', value2);
			}
			if(value3 != ""){ //품목구분
				Sheet.SetCellValue(arrRow[idx], 'ITEM_MAKE_TYPE', value3);
			}
			if(value4 != ""){ //배송일수
				Sheet.SetCellValue(arrRow[idx], 'LEAD_TIME', value4);
			}
			if(value5 != ""){ //선입고
				Sheet.SetCellValue(arrRow[idx], 'QTDT_PRE_GR_FLAG', value5);
			}
			if(value6 != ""){ //과세
				Sheet.SetCellValue(arrRow[idx], 'TAX_TYPE', value6);
			}
			if(value7 != ""){ //협력사비고
				Sheet.SetCellValue(arrRow[idx], 'STOA_REMARK', value7);
				Sheet.SetCellValue(arrRow[idx], 'STOA_REMARK_YN', "/resources/imgs/Btn_RegEnd.gif");
			}else{
				Sheet.SetCellValue(arrRow[idx], 'STOA_REMARK', value7);
				Sheet.SetCellValue(arrRow[idx], 'STOA_REMARK_YN', "/resources/imgs/Btn_RegIng.gif");
			}
		}
	}else if(popupSel == "stoa_remark"){ //협력사비고
		Sheet.SetCellValue(grbRow, 'STOA_REMARK', value1);
		if(value1 != ""){
			Sheet.SetCellValue(grbRow, 'STOA_REMARK_YN', "/resources/imgs/Btn_RegEnd.gif");
		}else{
			Sheet.SetCellValue(grbRow, 'STOA_REMARK_YN', "/resources/imgs/Btn_RegIng.gif");
		}
		
	}else if(popupSel == "imgfile_name"){ //이미지 첨부
		Sheet.SetCellValue(grbRow, 'IMGFILE_DIR', value1);
		Sheet.SetCellValue(grbRow, 'IMGFILE_NAME', value2);
		if(value1 != ""){
			Sheet.SetCellValue(grbRow, 'IMGFILE_NAME_YN', "/resources/imgs/Btn_RegEnd.gif");
		}else{
			Sheet.SetCellValue(grbRow, 'IMGFILE_NAME_YN', "/resources/imgs/Btn_RegIng.gif");
		}
		
	}else if(popupSel == "seller_image_key"){ //파일 첨부
		Sheet.SetCellValue(grbRow, 'SELLER_IMAGE_KEY', value1);
		if(value1 != ""){
			Sheet.SetCellValue(grbRow, 'SELLER_IMAGE_KEY_YN', "/resources/imgs/Btn_RegEnd.gif");
		}else{
			Sheet.SetCellValue(grbRow, 'SELLER_IMAGE_KEY_YN', "/resources/imgs/Btn_RegIng.gif");
		}
	}
	grbRow = "";	//초기화
}
function agentHandout(btnEvent){ // 견적 제출, 포기, 임시저장
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	if(btnEvent == "agentHandout"){
		var sg_alert_flag = false;
		var msds_yn_flag = false; 
		
		for(var idx=0; idx<arrRow.length; idx++){
			var RFQ_IMG_FLAG = Sheet.GetCellValue(arrRow[idx], "RFQ_IMG_FLAG");
			var IMGFILE_NAME = Sheet.GetCellValue(arrRow[idx], "IMGFILE_NAME");
			var SELLER_IMAGE_KEY = Sheet.GetCellValue(arrRow[idx], "SELLER_IMAGE_KEY");
			var LEAD_TIME = Sheet.GetCellValue(arrRow[idx], "LEAD_TIME");
			var ORG_STOA_LIST_PRICE = Sheet.GetCellValue(arrRow[idx], "ORG_STOA_LIST_PRICE");
			var DELI_AREA_USE_FLAG = Sheet.GetCellValue(arrRow[idx], 'DELI_AREA_USE_FLAG');
			var PROCESS_TYPE_FLAG = Sheet.GetCellValue(arrRow[idx], 'PROCESS_TYPE_FLAG');
			var MIN_ORDER_QTY = Sheet.GetCellValue(arrRow[idx], 'MIN_ORDER_QTY');
			var PUR_UNIT_QTY = Sheet.GetCellValue(arrRow[idx], 'PUR_UNIT_QTY');
			var SELLER_AREA = Sheet.GetCellValue(arrRow[idx], 'SELLER_AREA');
			var PROCESS_TYPE = Sheet.GetCellValue(arrRow[idx], 'PROCESS_TYPE');
			var ITEM_MAKE_TYPE = Sheet.GetCellValue(arrRow[idx], 'ITEM_MAKE_TYPE');
			var SELLER_ITEM_NO = Sheet.GetCellValue(arrRow[idx], 'SELLER_ITEM_NO');
			var SG_ID = Sheet.GetCellValue(arrRow[idx], 'SG_ID');
			var MSDS_YN = Sheet.GetCellValue(arrRow[idx], 'MSDS_YN');
			
			if(RFQ_IMG_FLAG == "Y" && kepIsValueNull(IMGFILE_NAME)){
//         		alert("해당 품목 이미지첨부가 필요합니다.");
        		var text = "이미지첨부가 필요합니다.";
        		openLayerPopText2(text,but1text,but1func,but1width);
        		Sheet.SelectCell(arrRow[idx], "IMGFILE_NAME_YN");
        		return;
        	}
			
			if(ITEM_MAKE_TYPE == "" || kepIsValueNull(ITEM_MAKE_TYPE) ){
// 				alert("품목구분을 선택하여 주십시요.");
				var text = "품목구분을 선택해주세요.";
        		openLayerPopText2(text,but1text,but1func,but1width);
				Sheet.SelectCell(arrRow[idx], "ITEM_MAKE_TYPE");
				return;
			}
			
			if(LEAD_TIME < 1){
// 				alert("배송일수는 0보다 큰 숫자로 입력하세요.");
				var text = "배송일수는 0보다 큰 숫자로 입력하세요.";
        		openLayerPopText2(text,but1text,but1func,but1width);
				Sheet.SelectCell(arrRow[idx], "LEAD_TIME");
				return;
			}
			
			if(kepIsValueNull(LEAD_TIME)) {
// 				 alert("배송일수(숫자형식)를 입력하여 주십시요.");
				 var text = "배송일수(숫자형식)를 입력해주세요.";
	        	 openLayerPopText2(text,but1text,but1func,but1width);
				 Sheet.SelectCell(arrRow[idx], "LEAD_TIME");
                 return;
			}
			
			if(kepIsValueNull(ORG_STOA_LIST_PRICE)) {
// 				 alert("제출단가(숫자형식)를 입력하여 주십시요.");
				 var text = "제출단가(숫자형식)를 입력해주세요.";
	        	 openLayerPopText2(text,but1text,but1func,but1width);
				 Sheet.SelectCell(arrRow[idx], "ORG_STOA_LIST_PRICE");
                return;
			}
			
			if(ORG_STOA_LIST_PRICE <= 1) {
// 				alert("유효하지 않는 견적단가입니다.");
				var text = "유효하지 않는 견적단가입니다.";
	        	 openLayerPopText2(text,but1text,but1func,but1width);
				Sheet.SelectCell(arrRow[idx], "ORG_STOA_LIST_PRICE");
				return;
			}
			
			if(kepIsValueNull(MIN_ORDER_QTY) || MIN_ORDER_QTY < 1 || !kepIsNumChkStr(MIN_ORDER_QTY,2)){
// 				alert("최소주문수량을 숫자형식으로 입력해주세요.");
				var text = "최소주문수량을 숫자형식으로 입력해주세요.";
	        	 openLayerPopText2(text,but1text,but1func,but1width);
				Sheet.SelectCell(arrRow[idx], "MIN_ORDER_QTY");
				return;
			}
			if(kepIsValueNull(PUR_UNIT_QTY) || PUR_UNIT_QTY < 1 || !kepIsNumChkStr(PUR_UNIT_QTY,2)){
// 				alert("주문배수수량을 숫자형식으로 입력해주세요.");
				var text = "주문배수수량을 숫자형식으로 입력해주세요.";
	        	 openLayerPopText2(text,but1text,but1func,but1width);
				Sheet.SelectCell(arrRow[idx], "PUR_UNIT_QTY");
				return;
			}
			if( MIN_ORDER_QTY < PUR_UNIT_QTY ){
// 				alert("최소주문수량은 주문배수수량보다 작을 수 없습니다.");
				var text = "최소주문수량은 주문배수수량보다 작을 수 없습니다.";
	        	 openLayerPopText2(text,but1text,but1func,but1width);
				Sheet.SelectCell(arrRow[idx], "MIN_ORDER_QTY");
				return;
			}
			
			if(DELI_AREA_USE_FLAG == "Y"){
				if(kepIsValueNull(SELLER_AREA)){
// 					alert("납품지역을 선택하여 주십시요.");
					var text = "납품지역을 선택해주세요.";
		        	 openLayerPopText2(text,but1text,but1func,but1width);
					Sheet.SelectCell(arrRow[idx], "SELLER_AREA_TEXT");
					return;
				}
			}
			
			if(PROCESS_TYPE_FLAG == "Y"){
				if(kepIsValueNull(PROCESS_TYPE)){
// 					alert("거래유형을 선택하여 주십시요.");
					var text = "거래유형을 선택해주세요.";
		        	 openLayerPopText2(text,but1text,but1func,but1width);
					Sheet.SelectCell(arrRow[idx], "PROCESS_TYPE");
					return;
				}
			}
			
			if(<%=p03302303%> == true){
				if(SELLER_ITEM_NO == "" || kepIsValueNull(SELLER_ITEM_NO)){
// 					alert("협력사품목코드를 입력하여 주십시요.");
					var text = "협력사품목코드를 입력해주세요.";
		        	 openLayerPopText2(text,but1text,but1func,but1width);
					Sheet.SelectCell(arrRow[idx], "SELLER_ITEM_NO");
					return;
				}
			}
			
			if(SG_ID == "SG118" || SG_ID == "SG120" || SG_ID == "SG153" || SG_ID == "SG163"){
				sg_alert_flag = true;
			}
			
			if(MSDS_YN == "Y"){
				msds_yn_flag = true;
			}
		}
		
		if(msds_yn_flag) {
			var text = "제출 품목 중 MSDS 제출이 필요한 제품이 포함되어 있습니다.</br>최종 선정 시 MSDS 제출이 필요합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
		}
		
		if(sg_alert_flag) {
// 			alert("냉장 / 냉동 품목은 TR(물류센터) 거래 불가능합니다.\n견적 제출 전 협력사비고란에 품목 보관조건을 꼭 기재하여 제출 부탁드립니다.");
			var text = "냉장 / 냉동 품목은 TR(물류센터) 거래 불가능합니다.</br>견적 제출 전 협력사비고란에 품목 보관조건을 꼭 기재하여 제출 부탁드립니다.";
			var but1funcTemp = "javascript:saveSellerMpRqQuotaReqListConfirm(); return false;";
       	 openLayerPopText2(text,but1text,but1funcTemp,but1width);
		}else{
			var text = "견적을 제출하시겠습니까?";
			var but1textC = "확인";
			var but2textC = "취소";
			var but1funcC = "javascript:saveSellerMpRqQuotaReqList_v2(); return false;";
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "120px";
			var but2widthC = "120px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			
// 			if(confirm("견적을 제출하시겠습니까?")){
// 				kepSave(document.searchCondition1, Sheet, "/mprq/saveSellerMpRqQuotaReqList_v2.do", "SELECTED");
// 			}
		}
	}else if(btnEvent == "tmpSave"){ //임시저장
		var text = "임시 저장하시겠습니까?";
		var but1textC = "확인";
		var but2textC = "취소";
		var but1funcC = "javascript:tmpSave(); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	}else{
		if(arrRow.length > 1){
// 			alert("한번에 하나의 견적만 포기 가능 합니다.");
			var text = "한번에 하나의 견적만 포기 가능 합니다.";
       	 openLayerPopText2(text,but1text,but1func,but1width);
			return;	
		}
		
		var text = "견적을 포기하시겠습니까?";
		var but1textC = "확인";
		var but2textC = "취소";
		var but1funcC = "javascript:estimateAbandonmentReasonPop(); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		
// 		if(confirm("견적을 포기하시겠습니까?")){
// 			var src = '/common/mprq/estimateAbandonmentReasonPop.do';
// 			openLayerPop(src,"560px","400px");
	        
// // 			openSearchPopup("/common/mprq/estimateAbandonmentReasonPop.do", "", "560,400,no");
// 		}
		
	}
}
function estimateAbandonmentReasonPop(){
	closePopText1();
	var src = '/common/mprq/estimateAbandonmentReasonPop.do';
	openLayerPop(src,"560px","400px");
}
function saveSellerMpRqQuotaReqListConfirm(){
	closePopText2();
	var text = "견적을 제출하시겠습니까?";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:saveSellerMpRqQuotaReqList_v2(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
}
function saveSellerMpRqQuotaReqList_v2(){
	closePopText1();
	<%-- AWS에서 특수문자, 함수모양의 문자 공격으로 인식하여 제출 직전에 잠깐 규격, 품명 비움 --%>
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	for(var idx=0; idx<arrRow.length; idx++){
		Sheet.SetCellValue(arrRow[idx], "DESCRIPTION", "");
		Sheet.SetCellValue(arrRow[idx], "SPECIFICATION","");
	}
	kepSave(document.searchCondition1, Sheet, "/mprq/saveSellerMpRqQuotaReqList_v2.do", "SELECTED");
}
//저장
function saveInfo(){
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	for(var idx=0; idx<arrRow.length; idx++){
		var MODIFY_FLAG = Sheet.GetCellValue(arrRow[idx],"MODIFY_FLAG");
		var RFQ_IMG_FLAG = Sheet.GetCellValue(arrRow[idx], "RFQ_IMG_FLAG");
		var IMGFILE_NAME = Sheet.GetCellValue(arrRow[idx], "IMGFILE_NAME");
		var SELLER_IMAGE_KEY = Sheet.GetCellValue(arrRow[idx], "SELLER_IMAGE_KEY");
		var LEAD_TIME = Sheet.GetCellValue(arrRow[idx], "LEAD_TIME");
		var ORG_STOA_LIST_PRICE = Sheet.GetCellValue(arrRow[idx], "ORG_STOA_LIST_PRICE");
		var DELI_AREA_USE_FLAG = Sheet.GetCellValue(arrRow[idx], 'DELI_AREA_USE_FLAG');
		var PROCESS_TYPE_FLAG = Sheet.GetCellValue(arrRow[idx], 'PROCESS_TYPE_FLAG');
		var MIN_ORDER_QTY = Sheet.GetCellValue(arrRow[idx], 'MIN_ORDER_QTY');
		var PUR_UNIT_QTY = Sheet.GetCellValue(arrRow[idx], 'PUR_UNIT_QTY');
		var SELLER_AREA = Sheet.GetCellValue(arrRow[idx], 'SELLER_AREA');
		var PROCESS_TYPE = Sheet.GetCellValue(arrRow[idx], 'PROCESS_TYPE');
		var ITEM_MAKE_TYPE = Sheet.GetCellValue(arrRow[idx], 'ITEM_MAKE_TYPE');
		var SELLER_ITEM_NO = Sheet.GetCellValue(arrRow[idx], 'SELLER_ITEM_NO');
		var SG_ID = Sheet.GetCellValue(arrRow[idx], 'SG_ID');
		
		if(MODIFY_FLAG == "N"){
// 			alert("견적 마감처리가 된 건이므로, 수정 불가능 합니다.");
			var text = "견적 마감처리가 된 건이므로, 수정 불가능 합니다.";
	       	 openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		if(RFQ_IMG_FLAG == "Y" && kepIsValueNull(IMGFILE_NAME)){
//     		alert("품목 이미지첨부가 필요합니다.");
    		var text = "이미지첨부가 필요합니다.";
	       	 openLayerPopText2(text,but1text,but1func,but1width);
    		Sheet.SelectCell(arrRow[idx], "IMGFILE_NAME_YN");
    		return;
    	}
		
		if(ITEM_MAKE_TYPE == "" || kepIsValueNull(ITEM_MAKE_TYPE) ){
// 			alert("품목구분을 선택하여 주십시요.");
			var text = "품목구분을 선택해주세요.";
	       	 openLayerPopText2(text,but1text,but1func,but1width);
			Sheet.SelectCell(arrRow[idx], "ITEM_MAKE_TYPE");
			return;
		}
		
		if(LEAD_TIME < 1){
// 			alert("배송일수는 0보다 큰 숫자로 입력하세요.");
			var text = "배송일수는 0보다 큰 숫자로 입력하세요.";
	       	 openLayerPopText2(text,but1text,but1func,but1width);
			Sheet.SelectCell(arrRow[idx], "LEAD_TIME");
			return;
		}
		
		if(kepIsValueNull(LEAD_TIME)) {
// 			 alert("배송일수(숫자형식)를 입력하여 주십시요.");
			 var text = "배송일수(숫자형식)를 입력해주세요.";
	       	 openLayerPopText2(text,but1text,but1func,but1width);
			 Sheet.SelectCell(arrRow[idx], "LEAD_TIME");
             return;
		}
		
		if(kepIsValueNull(ORG_STOA_LIST_PRICE)) {
// 			 alert("제출단가(숫자형식)를 입력하여 주십시요.");
			 var text = "제출단가(숫자형식)를 입력해주세요.";
	       	 openLayerPopText2(text,but1text,but1func,but1width);
			 Sheet.SelectCell(arrRow[idx], "ORG_STOA_LIST_PRICE");
            return;
		}
		
		if(ORG_STOA_LIST_PRICE <= 1) {
// 			alert("유효하지 않는 견적단가입니다.");
			var text = "유효하지 않는 견적단가입니다.";
	       	 openLayerPopText2(text,but1text,but1func,but1width);
			Sheet.SelectCell(arrRow[idx], "ORG_STOA_LIST_PRICE");
			return;
		}
		
		if(kepIsValueNull(MIN_ORDER_QTY) || MIN_ORDER_QTY < 1 || !kepIsNumChkStr(MIN_ORDER_QTY,2)){
// 			alert("최소주문수량을 숫자형식으로 입력해주세요.");
			var text = "최소주문수량을 숫자형식으로 입력해주세요.";
	       	 openLayerPopText2(text,but1text,but1func,but1width);
			Sheet.SelectCell(arrRow[idx], "MIN_ORDER_QTY");
			return;
		}
		if(kepIsValueNull(PUR_UNIT_QTY) || PUR_UNIT_QTY < 1 || !kepIsNumChkStr(PUR_UNIT_QTY,2)){
// 			alert("주문배수수량을 숫자형식으로 입력해주세요.");
			var text = "주문배수수량을 숫자형식으로 입력해주세요.";
	       	 openLayerPopText2(text,but1text,but1func,but1width);
			Sheet.SelectCell(arrRow[idx], "PUR_UNIT_QTY");
			return;
		}
		if( MIN_ORDER_QTY < PUR_UNIT_QTY ){
// 			alert("최소주문수량은 주문배수수량보다 작을 수 없습니다.");
			var text = "최소주문수량은 주문배수수량보다 작을 수 없습니다.";
	       	 openLayerPopText2(text,but1text,but1func,but1width);
			Sheet.SelectCell(arrRow[idx], "MIN_ORDER_QTY");
			return;
		}
		
		if(DELI_AREA_USE_FLAG == "Y"){
			if(kepIsValueNull(SELLER_AREA)){
// 				alert("납품지역을 선택하여 주십시요.");
				var text = "납품지역을 선택해주세요.";
		       	 openLayerPopText2(text,but1text,but1func,but1width);
				Sheet.SelectCell(arrRow[idx], "SELLER_AREA_TEXT");
				return;
			}
		}
		
		if(PROCESS_TYPE_FLAG == "Y"){
			if(kepIsValueNull(PROCESS_TYPE)){
// 				alert("거래유형을 선택하여 주십시요.");
				var text = "거래유형을 선택해주세요.";
		       	 openLayerPopText2(text,but1text,but1func,but1width);
				Sheet.SelectCell(arrRow[idx], "PROCESS_TYPE");
				return;
			}
		}
		if(<%=p03302303%> == true){
			if(SELLER_ITEM_NO == "" || kepIsValueNull(SELLER_ITEM_NO)){
// 				alert("협력사품목코드를 입력하여 주십시요.");
				var text = "협력사품목코드를 입력해주세요.";
		       	 openLayerPopText2(text,but1text,but1func,but1width);
				Sheet.SelectCell(arrRow[idx], "SELLER_ITEM_NO");
				return;
			}
		}
	}
	
  	var text = "수정제출 하시겠습니까?";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:saveSellerMpRqQuotaList_v2(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
// 	if(confirm("저장하시겠습니까?")){
// 		kepSave(document.searchCondition2, Sheet, "/mprq/saveSellerMpRqQuotaList_v2.do", "SELECTED");
// 	}
	
}
function saveSellerMpRqQuotaList_v2(){
	closePopText1();
	
	<%-- AWS에서 특수문자, 함수모양의 문자 공격으로 인식하여 제출 직전에 잠깐 규격, 품명 비움 --%>
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	for(var idx=0; idx<arrRow.length; idx++){
		Sheet.SetCellValue(arrRow[idx], "DESCRIPTION", "");
		Sheet.SetCellValue(arrRow[idx], "SPECIFICATION","");
	}
	kepSave(document.searchCondition2, Sheet, "/mprq/saveSellerMpRqQuotaList_v2.do", "SELECTED");
}
/*
 * 견적요청서 목록
 */
function ReqSourcingList(btnEvent) {
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	var deli_query = "";
	
	// 선택된 항목 유무 체크
	if (checkRows.length == 0) {
// 		alert("상품을 선택해주세요.");
		var text = "상품을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	for(var idx=0; idx<arrRow.length; idx++){
		var BUYER = Sheet.GetCellValue(arrRow[idx], "BUYER");
		var QUOTATION_NO = Sheet.GetCellValue(arrRow[idx], "QUOTATION_NO");
		var QUOTATION_SEQ = Sheet.GetCellValue(arrRow[idx], "QUOTATION_SEQ");
		var REVISION = Sheet.GetCellValue(arrRow[idx], "REVISION");
		
		deli_query += BUYER;
        deli_query += QUOTATION_NO;
        deli_query += QUOTATION_SEQ;
        deli_query += REVISION;
        deli_query += "^||^";
	}
	
	var param =  "["+deli_query+"]["+"${sessionInfo.comCode}"+"]";
	var fileName = "RD_04_B_008_03";
	
	reportOpen(fileName,param);
}

//견적서 출력
function report(){
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	if (checkRows.length == 0) {
// 		alert("상품을 선택해주세요.");
		var text = "상품을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	if(arrRow.length >1){
// 		alert("견적서 출력은 하나의 상품만 선택해주세요.");
		var text = "견적서 출력은 하나의 상품만 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var param = "";
	var BUYER = Sheet.GetCellValue(Sheet.GetSelectRow(), "BUYER");
	var QUOTATION_NO = Sheet.GetCellValue(Sheet.GetSelectRow(), "QUOTATION_NO");
	var QUOTATION_SEQ = Sheet.GetCellValue(Sheet.GetSelectRow(), "QUOTATION_SEQ");
	var REVISION = Sheet.GetCellValue(Sheet.GetSelectRow(), "REVISION");
	var KEP_USER_ID = Sheet.GetCellValue(Sheet.GetSelectRow(), "KEP_USER_ID");
	var AGENT = Sheet.GetCellValue(Sheet.GetSelectRow(), "AGENT");
	var SEL_USER_ID = Sheet.GetCellValue(Sheet.GetSelectRow(), "SEL_USER_ID");
	var AGENT_SOURCING_STATUS = Sheet.GetCellValue(Sheet.GetSelectRow(), "AGENT_SOURCING_STATUS");
	
	if(AGENT_SOURCING_STATUS == "견적취소" || AGENT_SOURCING_STATUS =="견적포기"){
// 		alert("해당 진행상태는 견적서를 출력할 수 없습니다.");
		var text = "해당 진행상태는 견적서를 출력할 수 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	if(SEL_USER_ID == ""){
// 		alert("견적서가 작성되지 않았습니다.");
		var text = "견적서가 작성되지 않았습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
        return;
	}
	
	param =  "["+BUYER+"]["+QUOTATION_NO+"]["+QUOTATION_SEQ+"]["+REVISION+"]["+KEP_USER_ID+"]["+AGENT+"]["+SEL_USER_ID+"]";
	
	var fileName = "RD_04_M_007_01";
	
	reportOpen(fileName,param);
}
function tmpSave(){
	closePopText1();
	Sheet.SetColProperty("ITEM_MAKE_TYPE",{KeyField:false});
	Sheet.SetColProperty("LEAD_TIME",{KeyField:false});
	Sheet.SetColProperty("MIN_ORDER_QTY",{KeyField:false});
	Sheet.SetColProperty("PUR_UNIT_QTY",{KeyField:false});
	Sheet.SetColProperty("ORG_STOA_LIST_PRICE",{KeyField:false});
    
	$('#st_giveup_yn').val("S");
	kepSave(document.searchCondition1, Sheet, "/mprq/saveSellerMpRqQuotaReqList_v2.do", "SELECTED");
}
function AgentGiveUp(reason) { 
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	for(var idx=0; idx<arrRow.length; idx++){
		Sheet.SetCellValue(arrRow[idx], 'GIVEUP_REMARK', reason);
	}
	Sheet.SetColProperty("ITEM_MAKE_TYPE",{KeyField:false});
	Sheet.SetColProperty("LEAD_TIME",{KeyField:false});
	Sheet.SetColProperty("MIN_ORDER_QTY",{KeyField:false});
	Sheet.SetColProperty("PUR_UNIT_QTY",{KeyField:false});
	Sheet.SetColProperty("ORG_STOA_LIST_PRICE",{KeyField:false});
    
	$('#st_giveup_yn').val("Y");
	kepSave(document.searchCondition1, Sheet, "/mprq/saveSellerMpRqQuotaReqList_v2.do", "SELECTED");
  
 }

function thisPopClose(){
	closePopText2();
	doAction('search');
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
           	일반 견적 
          <div class="SummaryGuide">
      	    <ul>
        	  <li><img src="/resources/imgs/Icon_Home.png" /></li>
        	  <li>견적 관리</li>
              <li>일반 견적</li>
            </ul>
          </div>
        </div>
        <div class="SubSearchTab">
         <button class="TabTit" data-tab="Search1">전체</button>
         <button class="TabTit active" data-tab="Search2">견적요청</button>
         <button class="TabTit" data-tab="Search3">견적제출</button>
<!--          <button class="TabTit" data-tab="Search4">단가선정</button> -->
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
              <th>기간</th>
              <td colspan="3">
              <select name="st_date_type" class="Select" style=" float:left;width:120px; margin-right:5px">
                  <option value="st_req_date" selected>견적요청일</option>
                  <option value="st_end_date">견적마감일</option>
               </select>
                <div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date_0" name="st_from_date" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_0" name="st_to_date" readonly /><span></span></div>
                </div>
                <button class="But_Month" style="width: 69px;" data-group="tab0" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','1'); return false;">1개월</button> 
                <button class="But_Month" style="width: 69px;" data-group="tab0" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','2'); return false;">2개월</button>
                <button class="But_Month" style="width: 69px;" data-group="tab0" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','3'); return false;">3개월</button>
                <button class="But_Month" style="width: 69px;" data-group="tab0" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','12'); return false;">1년</button>
               </td>
              <th>진행상태</th>
              <td><select name="st_sourcing_status" id="" class="Select" style="width:94%">
                  	<option value="" >전체</option>
			      	<option value="신규견적요청" >신규견적요청</option>
					<option value="재견적요청" >재견적요청</option>
			        <option value="견적제출" >견적제출</option>
			        <option value="단가선정" >단가선정</option>
			        <option value="단가미선정" >단가미선정</option>
			        <option value="견적미제출" >견적미제출</option>
			        <option value="차수증가종료" >차수증가종료</option>
			        <option value="견적취소" >견적취소</option>
			        <option value="견적포기" >견적포기</option>
                  </select>
               </td>
              <th>고객사명</th>
              <td><input class="input30" style="width:86%" id="st_buyer_name_0" name="st_buyer_name" type="text" onKeyDown="kepEnter_v2()"/></td>               
            </tr>
            <tr>
              <th>견적번호</th>
              <td><input class="input30" style="width:86%" id="st_quotation_no_0" name="st_quotation_no" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>품목명</th>
              <td><input class="input30" style="width:86%" id="st_description_0" name="st_description" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>규격</th>
              <td><input class="input30" style="width:86%" id="st_specification_0" name="st_specification" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>모델번호</th>
              <td><input class="input30" style="width:86%" id="st_maker_part_no_0" name="st_maker_part_no" type="text" onKeyDown="kepEnter_v2()"/></td>
            </tr>
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="doAction('search');return false;">조회</button> 
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40" onclick="javscript:doAction('excelDownload'); return false;">엑셀다운로드</button>
            <button class="ButM_Outline" onclick="javascript:doAction('report'); return false;">견적서 출력</button>
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
          <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> “견적요청”탭에서는 귀사에 전달된 “신규견적요청” 및 “재견적요청” 상태의 견적건을 확인할 수 있습니다. 견적번호를 클릭하면 상세정보 확인 및 견적 제출이 가능합니다.</div>
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
              <th>기간</th>
              <td colspan="3">
              	<select name="st_date_type" class="Select" style=" float:left;width:120px; margin-right:5px">
                  <option value="st_req_date" selected>견적요청일</option>
                  <option value="st_end_date">견적마감일</option>
               </select>
                <div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date_1" name="st_from_date" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_1" name="st_to_date" readonly /><span></span></div>
                </div>
				<button class="But_Month" style="width: 69px;" data-group="tab1" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','1'); return false;">1개월</button> 
                <button class="But_Month" style="width: 69px;" data-group="tab1" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','2'); return false;">2개월</button>
                <button class="But_Month" style="width: 69px;" data-group="tab1" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','3'); return false;">3개월</button>
                <button class="But_Month" style="width: 69px;" data-group="tab1" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','12'); return false;">1년</button>
              </td>
              <th>진행상태</th>
              <td><select name="st_sourcing_status" id="" class="Select" style="width:94%">
                  	<option value="" >전체</option>
			      	<option value="신규견적요청" >신규견적요청</option>
					<option value="재견적요청" >재견적요청</option>
                  </select>
               </td>
              <th>고객사명</th>
              <td><input class="input30" style="width:86%" id="st_buyer_name_1" name="st_buyer_name" type="text" onKeyDown="kepEnter_v2()"/></td>               
            </tr>
            <tr>
              <th>견적번호</th>
              <td><input class="input30" style="width:86%" id="st_quotation_no_1" name="st_quotation_no" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>품목명</th>
              <td><input class="input30" style="width:86%" id="st_description_1" name="st_description" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>규격</th>
              <td><input class="input30" style="width:86%" id="st_specification_1" name="st_specification" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>모델번호</th>
              <td><input class="input30" style="width:86%" id="st_maker_part_no_1" name="st_maker_part_no" type="text" onKeyDown="kepEnter_v2()"/></td>
            </tr>
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="doAction('search'); return false;">조회</button> 
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40" onclick="javscript:doAction('excelDownload'); return false;">엑셀다운로드</button>
            <button class="ButM_Outline" onclick="javascript:doAction('reqSourcing'); return false;">견적요청서 목록</button>
            <button class="ButM_Outline" onclick="javascript:doPop('popMulti'); return false;" >일괄등록</button></div>
<!--             <div class="left"><button class="ButM_Outline" id="DIVopenMultiPop" onclick="return false;" >일괄등록</button></div> -->
            <div class="right">
              <button class="ButM_Outline" onclick="javascript:doAction('cancel'); return false;">견적포기</button>
<!--               <button class="ButM_Outline" onclick="javascript:doAction('tmpSave'); return false;">임시저장</button> -->
              <button class="ButMPrimary" onclick="javascript:doAction('agentHandout'); return false;">견적제출</button>
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
        <form id="searchCondition2" name="searchCondition2" method="post">
		<input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" id="st_user_id" name="st_user_id" value="${sessionInfo.userId}" />
		<input type="hidden" id="st_user_name" name="st_user_name" value="${sessionInfo.userNameLoc}">
		<input type="hidden" id="st_user_tel" name="st_user_tel" value="${sessionInfo.tel}">
		<input type="hidden" id="st_corp_code" name="st_corp_code" value="" />
		<input type="hidden" id="st_status_exception" name="st_status_exception" value="Y" />
		    
        <div id="Search3" class="SearchContent">
          <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> “견적제출”탭에서는 귀사가 제출한 “견적제출” 상태의 견적건을 확인할 수 있습니다. 견적 마감 전까지 내용 수정이 가능합니다.</div>
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
              <th>기간</th>
              <td colspan="3">
              	<select name="st_date_type" class="Select" style=" float:left;width:120px; margin-right:5px">
                  <option value="st_req_date" selected>견적요청일</option>
                  <option value="st_end_date">견적마감일</option>
               </select>
                <div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date_2" name="st_from_date" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_2" name="st_to_date" readonly /><span></span></div>
                </div>
                <button class="But_Month" style="width: 69px;" data-group="tab2" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','1'); return false;">1개월</button> 
                <button class="But_Month" style="width: 69px;" data-group="tab2" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','2'); return false;">2개월</button>
                <button class="But_Month" style="width: 69px;" data-group="tab2" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','3'); return false;">3개월</button>
                <button class="But_Month" style="width: 69px;" data-group="tab2" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','12'); return false;">1년</button>
              </td>
              <th>진행상태</th>
              <td><select name="st_sourcing_status" class="Select" style="width:94%" >
                  <option disabled="disabled" value="견적제출" selected >견적제출</option>
                  </select>
               </td>
              <th>고객사명</th>
              <td><input class="input30" style="width:86%" id="st_buyer_name_2" name="st_buyer_name" type="text" onKeyDown="kepEnter_v2()"/></td>               
            </tr>
            <tr>
              <th>견적번호</th>
              <td><input class="input30" style="width:86%" id="st_quotation_no_2" name="st_quotation_no" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>품목명</th>
              <td><input class="input30" style="width:86%" id="st_description_2" name="st_description" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>규격</th>
              <td><input class="input30" style="width:86%" id="st_specification_2" name="st_specification" type="text" onKeyDown="kepEnter_v2()"/></td>
              <th>모델번호</th>
              <td><input class="input30" style="width:86%" id="st_maker_part_no_2" name="st_maker_part_no" type="text" onKeyDown="kepEnter_v2()"/></td>
            </tr>
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="doAction('search'); return false;">조회</button> 
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40" onclick="javascript:doAction('excelDownload'); return false;">엑셀다운로드</button>
<!--             <button class="ButM_Outline" onclick="javascript:doAction('report'); return false;">견적서 출력</button> -->
            </div>
            <div class="right"><button class="ButMPrimary" onclick="javascript:doAction('saveInfo'); return false;">수정제출</button></div>
          </div>
          <div class="IBSheet">
			<script type="text/javascript">
          		createIBSheet("mySheet2", "", "100%");
          	</script>
		  </div> 
          <div class="h5" style="height: 50px;"></div>             
        </div><!--id="Search3" 견적제출 끝 -->
        </form> 
<!--         <form id="searchCondition3" name="searchCondition3" method="post"> -->
<!-- 		<input type="hidden" name="s_SAVENAME" /> -->
<%-- 		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">  --%>
<!--         <div id="Search4" class="SearchContent"> -->
<!--           <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> “단가선정”탭은 “단가선정” 상태의 상품견적을 확인하실 수 있으며, 상단 탭을 선택하여 다른 진행상태의 견적을 확인하실 수 있습니다.</div> -->
<!--           <table class="TabSearchTable" > -->
<!--             <colgroup> -->
<!--               <col width="6%" /> -->
<!--               <col width="19%" /> -->
<!--               <col width="6%" /> -->
<!--               <col width="19%" /> -->
<!--               <col width="6%" /> -->
<!--               <col width="19%" /> -->
<!--               <col width="6%" /> -->
<!--               <col width="19%" /> -->
<!--             </colgroup>          	 -->
<!--             <tr> -->
<!--               <th>견적요청일</th> -->
<!--               <td colspan="3"> -->
<!--                 <div class="datepicker-wrap" style=" width:230px"> -->
<!--                   <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date_3" name="st_from_date" readonly /><span> </span></div> -->
<!--                   <span class="dash">~</span> -->
<!--                   <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_3" name="st_to_date" readonly /><span></span></div> -->
<!--                 </div> -->
<!--                 <button class="But_Month" data-group="tab3" onclick="javascript:kepMonth_v2('st_from_date_3','st_to_date_3','1'); return false;">1개월</button>  -->
<!--                 <button class="But_Month" data-group="tab3" onclick="javascript:kepMonth_v2('st_from_date_3','st_to_date_3','2'); return false;">2개월</button> -->
<!--                 <button class="But_Month" data-group="tab3" onclick="javascript:kepMonth_v2('st_from_date_3','st_to_date_3','3'); return false;">3개월</button> -->
<!--                 <button class="But_Month" data-group="tab3" onclick="javascript:kepMonth_v2('st_from_date_3','st_to_date_3','12'); return false;">1년</button> -->
<!--               </td> -->
<!--               <th>진행상태</th> -->
<!--               <td><select name="st_sourcing_status" class="Select" style="width:90%"> -->
<!--                   <option disabled="disabled" value="단가선정" selected >단가선정</option> -->
<!--                   </select> -->
<!--                </td> -->
<!--               <th>견적번호</th> -->
<!--               <td><input class="input30" style="width:92%" name="st_quotation_no" id="st_quotation_no3" type="text" onKeyDown="kepEnter_v2()" /></td>                -->
<!--             </tr> -->
<!--           </table> -->
<!--           <div class="SearchBtnBox"> -->
<!--          	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button>  -->
<!--         	<button class="ButMSmallDarkGray" onclick="doAction('search'); return false;">조회</button>  -->
<!--           </div> -->
<!--           <div class="ListBtnBox"><div class="left"><button class="But_ExcelDown40" onclick="javascript:doAction('excelDownload'); return false;" >엑셀다운로드</button></div></div> -->
<!--           <div class="IBSheet"> -->
<!-- 			<script type="text/javascript"> -->
<!-- //           		createIBSheet("mySheet3", "", "100%"); -->
<!--           	</script> -->
<!-- 		  </div>  -->
<!--           <div class="h5" style="height: 50px;"></div>           -->
<!--         </div>id="Search4" 단가선정 끝 -->
<!--         </form>   -->
        
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
              }else if(currIndex == 2){
            	  Sheet = mySheet2;
              }else if(currIndex == 3){
            	  Sheet = mySheet3;
              }
              
              doAction('search');
            });
          });
          
          
          //입력했을때 앞 공백 제거
          const inputs = document.querySelectorAll("input[name=st_quotation_no],input[name=st_description],input[name=st_specification]");
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
