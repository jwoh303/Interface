<%--
**********************************************
* 메뉴 : 
* 화면 : 협력사선정  3
* 기능 : 견적접수 및 견적제출화면에서 접수건수를 클릭하여 협력사선정 팝업을 호출한다 협력사선정 팝업에서 견적마감처리를 하고 협력사를 선정한다
* 프로그램 ID : PG_04_M_007_03
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-06-17
**********************************************
--%>
<%@page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
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
<%
@SuppressWarnings (value="unchecked")
String buyer = (String) request.getParameter("st_buyer");
String moq_use_flag = "N";
String area_use_flag = "N";
String unit_price_check_flag = "N";
String min_unit_price = "";
String max_unit_price = "";

SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_user_dept = _sessionInfo.getDepartment();

// 삼성계열사(MOQ, 발주배수 필수 사용)
boolean p04404101 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4041-01");

if(p04404101 == true){
	moq_use_flag = "Y";
}

//삼성계열사(납품지역 필수 사용)
boolean p04404102 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4041-02");

if(p04404102 == true){
	area_use_flag = "Y";
}

// 선정 전 확인사항 비고
String getCodeASRMText = CommonUtil.getCode2TextReturn("ASRM",buyer,"KRKORE0001","TEXT1");

// 고정매입수수료율 고객사별 절삭단위
String getDecimalFlag = CommonUtil.getCode2TextReturn("DECM",buyer,"KRKORE0001","TEXT1");

// 제출단가 범위 제한
boolean p04404109 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4041-09");
if(p04404109 == true){
	min_unit_price = CommonUtil.getSpecialCheckReturn(buyer,"P04-4041-09","COL01_DATA"); // 최저단가
	max_unit_price = CommonUtil.getSpecialCheckReturn(buyer,"P04-4041-09","COL02_DATA"); // 최고단가
	unit_price_check_flag = "Y";
}

//제출단가 범위 제한
boolean p04403212 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4032-12");
String columnType = "";
if(p04403212 == true){
	columnType = CommonUtil.getSpecialCheckReturn(buyer,"P04-4032-12","COL01_DATA"); // 최저가 통제 : A, 매입단가 통제 : B, 매출단가 통제 : C
}

//SMART팀 확인
String st_smart_dept_yn = "";
boolean st_smart_dept = CommonUtil.getCodeCheckReturn("SMRTDEPT",st_user_dept);
if(st_smart_dept == true){
	st_smart_dept_yn = "Y";
}else{
	st_smart_dept_yn = "N";
}


%>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var areaOn = "/resources/images/icon.gif";
var areaOff = "/resources/images/icon2.gif";
var iconOn = "/resources/images/icon2.gif";

var productGbn = KepSheetComboData("M132","SEL");
var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};
var online_reason = KepSheetComboData("OPRN","SEL");
var comboInfo2 = {ComboCode: online_reason.ComboCode, ComboText:online_reason.ComboText};

var image_check_flag = "N"; // 이미지 클릭 여부

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var cb_rqdt_tax_type = KepSheetComboData("TX17","");
    var rqdt_tax_type = {ComboCode: cb_rqdt_tax_type.ComboCode, ComboText: cb_rqdt_tax_type.ComboText};
    
    var cb_qtdt_tax_type = KepSheetComboData("TX17","SPACE");
    var qtdt_tax_type = {ComboCode: cb_qtdt_tax_type.ComboCode, ComboText: cb_qtdt_tax_type.ComboText};
    
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	initsheet.HeaderMode = {			Sort : 0,			ColMove : 1,			ColResize : 1		};
	initsheet.Cols = [  
	      			{Align : "Center",	SaveName : "sStatus",					Header : "상태",				Type : "Status",		Width : 60,		Hidden : true}, 
	    			{Align : "Center",	SaveName : "SELECTED",					Header : "",				Type : "DummyCheck",	Width : 60,		Hidden : true,	EditLen : 50}, 
	    			{Align : "Center",	SaveName : "BUYER_ITEM_NO",				Header : "품목코드",			Type : "Text",			Width : 100,	Edit : false,	Hidden : false,	EditLen : 110},
	    			{Align : "Center",	SaveName : "SIGNAL",					Header : "기등록",			Type : "Text",			Width : 15,		Edit : false,	Hidden : true,	EditLen : 100},
	    			{Align : "Left",	SaveName : "DESCRIPTION",				Header : "품목명",			Type : "Text",			Width : 150,	Edit : false,	Hidden : false,	EditLen : 110},
	    			{Align : "Left",	SaveName : "SPECIFICATION",				Header : "규격",				Type : "Text",			Width : 190,	Edit : false,	Hidden : false,	EditLen : 110},
	    			{Align : "Left",	SaveName : "BTOA_AGENT_NAME",			Header : "기존협력사",			Type : "Text",			Width : 100,	Edit : false,	Hidden : false,	EditLen : 110},
	    			{Align : "Center",	SaveName : "ASSIGN_AGENT_CODE",			Header : "지정협력사",			Type : "Text",			Width : 100,	Edit : false,	Hidden : true,	EditLen : 110},
	    			{Align : "Left",	SaveName : "ASSIGN_AGENT_NAME",			Header : "지정협력사",			Type : "Text",			Width : 100,	Edit : false,	Hidden : false,	EditLen : 110},
	    			{Align : "Center",	SaveName : "UNIT_MEASURE",				Header : "단위",				Type : "Text",			Width : 40,		Edit : false,	Hidden : false,	EditLen : 110},
	    			{Align : "Right",	SaveName : "ITEM_QTY",					Header : "수량",				Type : "Float",			Width : 60,		Edit : false,	Hidden : false,	EditLen : 110,	Format:"${qtyFormat}"},
	    			{Align : "Center",	SaveName : "MAKER_NAME",				Header : "제조사",			Type : "Text",			Width : 80,		Edit : false,	Hidden : false,	EditLen : 110},
	    			{Align : "Right",	SaveName : "RPA_MARKET_PRICE",			Header : "RPA시장가격",		Type : "Float",			Width : 80,		Edit : false,	Hidden : false,	EditLen : 110},
	    			{Align : "Right",	SaveName : "RPA_HIST_PRICE",			Header : "실적가격",			Type : "Float",			Width : 80,		Edit : false,	Hidden : false,	EditLen : 110},
	    			{Align : "Center",	SaveName : "RPA_BUYER",					Header : "RPA_BUYER",		Type : "Text",			Width : 80,		Edit : false,	Hidden : true,	EditLen : 110},
	    			{Align : "Center",	SaveName : "RPA_CATLG_CODE",			Header : "RPA_CATLG_CODE",	Type : "Text",			Width : 80,		Edit : false,	Hidden : true,	EditLen : 110},
	    			{Align : "Center",	SaveName : "RPA_ITEM_NO",				Header : "RPA_ITEM_NO",		Type : "Text",			Width : 80,		Edit : false,	Hidden : true,	EditLen : 110},
	    			{Align : "Center",	SaveName : "ORIGIN_NAME",				Header : "원산지",			Type : "Text",			Width : 60,		Edit : false,	Hidden : false,	EditLen : 110},
	    			{Align : "Center",	SaveName : "ORIGIN_CODE",				Header : "원산지코드",			Type : "Text",			Width : 60,		Edit : false,	Hidden : true,	EditLen : 110},
	    			{Align : "Left",	SaveName : "MAKER_PART_NO",				Header : "모델번호",			Type : "Text",			Width : 80,		Edit : false,	Hidden : false,	EditLen : 110},
	    			{Align : "Center",	SaveName : "REQ_PRICE_TYPE_TEXT",		Header : "단가구분",			Type : "Text",			Width : 60,		Edit : false,	Hidden : false,	EditLen : 110},
	    			{Align : "Right",	SaveName : "BUYER_TARGET_PRICE",		Header : "요청단가",			Type : "Float",			Width : 80,		Edit : false,	Hidden : false,	EditLen : 110,	Format:"${priceFormat}"},
	    			{Align : "Right",	SaveName : "ADMIN_TARGET_PRICE",		Header : "목표단가",			Type : "Float",			Width : 80,		Edit : false,	Hidden : false,	EditLen : 110,	Format:"${priceFormat}"},
	    			{Align : "Right",	SaveName : "BTOA_NEGO_PRICE",			Header : "고객사\n네고요청단가",	Type : "Float",			Width : 80,		Edit : false,	Hidden : false,	EditLen : 110,	Format:"${priceFormat}"},
	    			{Align : "Center",	SaveName : "ITEM_MAKE_TYPE",			Header : "품목구분",			Type : "Combo",			Width : 120,	Edit : true,	Hidden : false,	EditLen : 120},
	    			{Align : "Center",	SaveName : "MARKET_UNIT_PRICE_YN",		Header : "시장가확인",			Type : "Text",			Width : 80,		Edit : false,	Hidden : false,	EditLen : 100},
	    			{Align : "Center",	SaveName : "MARKET_UNIT_PRICE_YN_IMG",	Header : "시장가확인",			Type : "Image",			Width : 30,		Edit : false,	Hidden : false,	EditLen : 100},
	    			{Align : "Right",	SaveName : "ONLINE_PRICE",				Header : "시장단가",			Type : "Float",			Width : 80,		Edit : true,	Hidden : true,	EditLen : 100},
	    			{Align : "Center",	SaveName : "ONLINE_URL",				Header : "시장단가URL",		Type : "Text",			Width : 80,		Edit : false,	Hidden : true,	EditLen : 100},
	    			{Align : "Center",	SaveName : "ONLINE_PRICE_REASON",		Header : "시장단가구분",		Type : "Combo",			Width : 155,	Edit : true,	Hidden : true,	EditLen : 300},
	    			{Align : "Center",	SaveName : "ATOA_REMARK_IMG",			Header : "운영사비고",			Type : "Image",			Width : 70,		Edit : false,	Hidden : false,	EditLen : 100},
	    			{Align : "Center",	SaveName : "ATOA_REMARK",				Header : "운영사비고",			Type : "Text",			Width : 60,		Edit : false,	Hidden : true,	EditLen : 110},
	    			{Align : "Center",	SaveName : "RFQ_IMG_TYPE",				Header : "이미지구분",			Type : "Combo",			Width : 80,		Edit : true,	Hidden : false,	EditLen : 100,	ComboText:"운영사|협력사|운영사(미완성)",	ComboCode:"M|S|N"},
	    			{Align : "Center",	SaveName : "RFQ_IMG_FLAG",				Header : "이미지필수",			Type : "Text",			Width : 60,		Edit : false,	Hidden : false,	EditLen : 110},
	    			{Align : "Center",	SaveName : "IMGFILE_NAME_IMG",			Header : "이미지첨부(M)",		Type : "Image",			Width : 90,		Edit : false,	Hidden : false, EditLen : 100},
	    			{Align : "Center",	SaveName : "IMGFILE_DIR",				Header : "이미지경로",			Type : "Text",			Width : 90,		Edit : false,	Hidden : false,	EditLen : 110},
	    			{Align : "Center",	SaveName : "IMGFILE_NAME",				Header : "이미지파일",			Type : "Text",			Width : 90,		Edit : false,	Hidden : false, EditLen : 110},
	    			{Align : "Center",	SaveName : "TAX_TYPE",					Header : "과세구분",			Type : "Combo",			Width : 60,		Edit : true,	Hidden : false, EditLen : 100},
	    			{Align : "Center",	SaveName : "CMS_CATEG_ID",				Header : "표준카테고리",		Type : "Text",			Width : 100,	Edit : false,	Hidden : true},
	    			{Align : "Center",	SaveName : "CMS_CATLG_ID",				Header : "표준카탈로그",		Type : "Text",			Width : 100,	Edit : false,	Hidden : false},
	    			{Align : "Right",	SaveName : "LAST_LIST_PRICE",			Header : "매입단가", 			Type : "Float",			Width : 70,		Edit : false,	Hidden : false,	Format:"${priceFormat}"},
	    			{Align : "Center",	SaveName : "LAST_CHANGE_DATE",			Header : "최근계약일",			Type : "Date",			Width : 80,		Edit : false,	Hidden : false},
	    			{Align : "Center",	SaveName : "LAST_PO_DATE",				Header : "최근발주일",			Type : "Date",			Width : 80,		Edit : false,	Hidden : false},
	];
	
	IBS_InitSheet2(mySheet, initsheet,pagingMode,1);
	
	mySheet.SetColProperty("TAX_TYPE", rqdt_tax_type);
	mySheet.SetColProperty("ITEM_MAKE_TYPE", comboInfo);
	mySheet.SetColProperty("ONLINE_PRICE_REASON", comboInfo2);
	setLinkCol(mySheet, "ATOA_REMARK_IMG");
	setLinkCol(mySheet, "IMGFILE_NAME_IMG");
	setLinkCol(mySheet, "CMS_CATLG_ID");
	setLinkCol(mySheet, "MARKET_UNIT_PRICE_YN_IMG");
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "RPA_MARKET_PRICE");
	setLinkCol(mySheet, "RPA_HIST_PRICE");
	setLinkCol(mySheet, "ORIGIN_NAME");
	
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);
	mySheet.SetImageList(2, diskOff);
	mySheet.SetImageList(3, diskOn);
	mySheet.SetImageList(6, iconOn);
	
	var initsheet2 = {};
	initsheet2.HeaderMode = {			Sort : 0,			ColMove : 1,			ColResize : 1		};
	if ($('#st_buyer').val() == "KRDOOD0001"){
		initsheet2.Cols = [  
			      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
			    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:true}, 
			    			{Align : "Center",SaveName : "SOURCING_STATUS",		Header : "상태",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
			    			{Align : "Center",SaveName : "AGENT_CHECK",	Header : "",	Type : "Radio",	Width : 20,	EditLen : 50,Edit:true,Hidden:false, ColMerge:1}, 
			    			{Align : "Left",SaveName : "AGENT_NAME",		Header : "협력사명",	Type : "Text",	Width : 120, EditLen : 110,	Edit : false, Hidden : false},
			    			{Align : "Center",SaveName : "ORIGIN_NAME",		Header : "원산지",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
			    			{Align : "Center",SaveName : "ORIGIN_CODE",		Header : "원산지",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : true},
			    			{Align : "Center",SaveName : "MAKER_CODE",		Header : "제조사",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : true},
			    			{Align : "Center",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
			    			{Align : "Right",SaveName : "LEAD_TIME",		Header : "조달일수", Type:"Int",	Format:"${qtyFormat}", Width : 60, EditLen : 110,	Edit : false, Hidden : false},
			    			{Align : "Right",SaveName : "STOA_LIST_PRICE",		Header : "매입단가", Type : "Text",	 Width : 80, EditLen : 100,	Edit : false, Hidden : false},
			    			{Align : "Right",SaveName : "ATOB_UNIT_PRICE",		Header : "판매단가", Type : "Float",	 Format:"${priceFormat}",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
			    			{Align : "Right",SaveName : "RATE",		Header : "RATE(%)",	Type : "Text",	 Width : 60, EditLen : 110,	Edit : false, Hidden : false},
			    			{Align : "Right",SaveName : "AVG_RATE",		Header : "평균RATE(%)", Type : "Text",	 Width : 90, EditLen : 110,	Edit : false, Hidden : false},
			    			{Align : "Center",SaveName : "STOA_REMARK_IMG",		Header : "비고",	Type : "Image",	Width : 50, EditLen : 110,	Edit : false, Hidden : false},
			    			{Align : "Center",SaveName : "STOA_REMARK",		Header : "비고",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
			    			{Align : "Center",SaveName : "ATOS_REMARK",		Header : "비고",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
			    			{Align : "Center",SaveName : "SELLER_IMAGE_KEY_IMG",		Header : "첨부",	Type : "Image",	Width : 50,	EditLen : 110,	Edit : false},
			    			{Align : "Center",SaveName : "SELLER_IMAGE_KEY",		Header : "첨부",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
			    			{Align : "Center",SaveName : "END_TIME_FLAG",		Header : "END_TIME_FLAG",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
			    			{Align : "Center",SaveName : "AGENT",		Header : "AGENT",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
			    			{Align : "Center",SaveName : "MIN_PRICE",		Header : "MIN_PRICE",	Type : "Float",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
			    			{Align : "Center",SaveName : "RANK",		Header : "RANK",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
			    			{Align : "Center",SaveName : "AGENT_REVISION",		Header : "AGENT_REVISION",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
			    			{Align : "Center",SaveName : "T_MIN_PRICE",		Header : "T_MIN_PRICE",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
			    			{Align : "Center",SaveName : "T_ROUND",		Header : "T_ROUND",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
			    			{Align : "Center",SaveName : "SG_GBN",		Header : "SG_GBN",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
			    			{Align : "Center",SaveName : "SG_KEP_YN",		Header : "SG_KEP_YN",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
			    			{Align : "Right",SaveName : "MIN_ORDER_QTY",	Header : "MOQ",		Type : "Int",	Format:"${qtyFormat}",	Width : 50,	EditLen : 10,	Edit : true, Hidden:false, BackColor:"${optColor}"},
			    			{Align : "Right",SaveName : "PUR_UNIT_QTY",		Header : "발주배수",	Type : "Int",	Format:"${qtyFormat}",	Width : 60,	EditLen : 10,	Edit : true, Hidden:false, BackColor:"${optColor}"},
			    			{Align : "Center",SaveName : "SELLER_AREA_IMG",	Header : "납품지역",	Type : "Image",	Width : 60,	EditLen : 110,	Edit : false},
			    			{Align : "Center",SaveName : "SELLER_AREA",		Header : "납품지역",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
			    			{Align : "Center",SaveName : "PROCESS_NM",		Header : "거래유형",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:false},
			    			{Align : "Center",SaveName : "AGENT_ITEM_MAKE_TYPE",		Header : "품목구분",	Type : "Combo",	Width : 120,	EditLen : 120,	Edit : false, Hidden:false},
			    			{Align:"Center",	Width:80,	ImgWidth:50, Edit:false,		Type:"Image",	Header:"이미지",	SaveName:"QTDT_IMG"},
			    			{Align : "Center",	SaveName : "QTDT_IMGFILE_NAME_IMG",		Header : "이미지첨부(S)",		Type : "Image",			Width : 80,		EditLen : 100,	Edit : false,	Hidden : false},
			    			{Align : "Center",	SaveName : "QTDT_IMGFILE_DIR",			Header : "이미지경로",		Type : "Text",				Width : 60,		EditLen : 110,	Edit : false, Hidden : true},
			    			{Align : "Center",	SaveName : "QTDT_IMGFILE_NAME",			Header : "이미지파일",		Type : "Text",				Width : 60,		EditLen : 110,	Edit : false, Hidden : true},
			    			{Align : "Center",SaveName : "SOL_AGENT_YN",		Header : "SOL_AGENT_YN",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
			    			{Align : "Center",SaveName : "BID_SUCCESS_REASON",		Header : "BID_SUCCESS_REASON",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true}
			    			
			];
	} else {
		initsheet2.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:true}, 
	    			{Align : "Center",SaveName : "SOURCING_STATUS",		Header : "상태",	Type : "Text",	Width : 70, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "AGENT_CHECK",	Header : "",	Type : "Radio", Width : 20,	EditLen : 50,Edit:true,Hidden:false}, 
	    			{Align : "Center",SaveName : "QTDT_IMG",	Header : "이미지",Type : "Image",	Width : 80,	ImgWidth:50, Edit:false},
	    			{Align : "Left",SaveName : "AGENT_NAME",		Header : "협력사명",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "ORIGIN_NAME",		Header : "원산지",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "ORIGIN_CODE",		Header : "원산지",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "MAKER_CODE",		Header : "제조사",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "LEAD_TIME",		Header : "조달일수", Type:"Int",	Format:"${qtyFormat}", Width : 60, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "STOA_LIST_PRICE",		Header : "매입단가", Type : "Text",	 Width : 60, EditLen : 110,	Edit : false, Hidden : false},	    			
	    			{Align : "Right",SaveName : "ATOB_UNIT_PRICE",		Header : "판매단가", Type : "Float",	 Format:"${priceFormat}",	Width : 70, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "BETWEEN_RATE",		Header : "매입최저대비(%)", Type : "Text",	 Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "RATE",		Header : "RATE(%)",	Type : "Text", Width : 60, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "AVG_RATE",		Header : "평균RATE(%)", Type : "Text", Width : 90, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "STOA_REMARK_IMG",		Header : "비고",	Type : "Image",	Width : 32, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "STOA_REMARK",		Header : "비고",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "ATOS_REMARK",		Header : "비고",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "BUYER",		Header : "고객사",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "QUOTATION_NO",		Header : "견적번호",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "QUOTATION_SEQ",		Header : "견적항번",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "REVISION",		Header : "차수",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "BTOA_REMARK",		Header : "비고",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "ATOB_REMARK",		Header : "비고",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "SELLER_IMAGE_KEY_IMG",		Header : "첨부",	Type : "Image",	Width : 32,	EditLen : 110,	Edit : false},
	    			{Align : "Center",SaveName : "SELLER_IMAGE_KEY",		Header : "첨부",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "END_TIME_FLAG",		Header : "END_TIME_FLAG",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "AGENT",		Header : "AGENT",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "MIN_PRICE",		Header : "MIN_PRICE",	Type : "Float",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "RANK",		Header : "RANK",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "AGENT_REVISION",		Header : "AGENT_REVISION",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "T_MIN_PRICE",		Header : "T_MIN_PRICE",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "T_ROUND",		Header : "T_ROUND",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "SG_GBN",		Header : "SG_GBN",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "SG_KEP_YN",		Header : "SG_KEP_YN",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Right",SaveName : "MIN_ORDER_QTY",	Header : "MOQ",		Type : "Int",	Format:"${qtyFormat}",	Width : 50,	EditLen : 10,	Edit : true, Hidden:false},
	    			{Align : "Right",SaveName : "PUR_UNIT_QTY",		Header : "발주배수",	Type : "Int",	Format:"${qtyFormat}",	Width : 60,	EditLen : 10,	Edit : true, Hidden:false},
	    			{Align : "Center",SaveName : "SELLER_AREA_IMG",	Header : "납품지역",	Type : "Image",	Width : 60,	EditLen : 110,	Edit : false},
	    			{Align : "Center",SaveName : "SELLER_AREA",		Header : "납품지역",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "PROCESS_NM",		Header : "거래유형",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:false},
	    			{Align : "Center",SaveName : "AGENT_ITEM_MAKE_TYPE",		Header : "품목구분",	Type : "Combo",	Width : 120,	EditLen : 120,	Edit : false, Hidden:false},
	    			{Align : "Center",	SaveName : "QTDT_IMGFILE_NAME_IMG",		Header : "이미지첨부(S)",		Type : "Image",			Width : 80,		EditLen : 100,	Edit : false,	Hidden : true},
	    			{Align : "Center",	SaveName : "QTDT_IMGFILE_DIR",			Header : "이미지경로",		Type : "Text",				Width : 60,		EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",	SaveName : "QTDT_IMGFILE_NAME",			Header : "이미지파일",		Type : "Text",				Width : 60,		EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",	SaveName : "QTDT_TAX_TYPE",					Header : "과세구분",		Type : "Combo",			Width : 60,		EditLen : 100,	Edit : false,	Hidden : false},
	    			{Align : "Center",SaveName : "QTDT_PRE_GR_FLAG",		Header : "선입고",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:false},
	    			{Align : "Center",SaveName : "VAT_YN",		Header : "부가세포함",	Type : "Text",	Width : 75,	EditLen : 110,	Edit : false, Hidden:false},
	    			{Align : "Center",SaveName : "SOL_AGENT_YN",		Header : "SOL_AGENT_YN",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "BID_SUCCESS_REASON",		Header : "BID_SUCCESS_REASON",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "PLANT",		Header : "PLANT",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true}
		];
	}
	IBS_InitSheet2(mySheet2, initsheet2,pagingMode,4);
	
	mySheet2.SetColProperty("QTDT_TAX_TYPE", qtdt_tax_type);
	mySheet2.SetColProperty("AGENT_ITEM_MAKE_TYPE", comboInfo);
	
	mySheet2.SetImageList(1, remarkOn);
	mySheet2.SetImageList(0, remarkOff);
	mySheet2.SetImageList(3, diskOn);
	mySheet2.SetImageList(2, diskOff);
	mySheet2.SetImageList(5, areaOn);
	mySheet2.SetImageList(4, areaOff);
	
	//하이퍼링크 설정
	setLinkCol(mySheet2, "STOA_REMARK_IMG");
	setLinkCol(mySheet2, "SELLER_IMAGE_KEY_IMG");
	setLinkCol(mySheet2, "SELLER_AREA_IMG");
	setLinkCol(mySheet2, "QTDT_IMGFILE_NAME_IMG");
	if ($('#st_buyer').val() == "KRDOOD0001"){
		setLinkCol(mySheet2, "ORIGIN_NAME");
		setLinkCol(mySheet2, "MAKER_NAME");
		mySheet2.SetCellFontUnderline(0, "ORIGIN_NAME", true);	
		mySheet2.SetCellFontUnderline(0, "MAKER_NAME", true);	
	}
	//절삭기능 없음. 정해진 로직대로. 반올림/버림/소수점자리 선택 불가 고객사
	if ($('#st_buyer').val() == "KRDOOS0046" 
		||$('#st_buyer').val() == "KRDHIM0001"||$('#st_buyer').val() == "KRDAEW0043"
		||$('#st_buyer').val() == "KRDAEW0045"||$('#st_buyer').val() == "KRDHIM0002"
		||$('#st_buyer').val() == "KRDHIM0003"||$('#st_buyer').val() == "KRDHIM0005"
		||$('#st_buyer').val() == "KRDIGU0001"
		||$('#st_buyer').val() == "KRCOWA0001"||$('#st_buyer').val() == "KRCOWA0002"
		||$('#st_buyer').val() == "KRCOWA0003"||$('#st_buyer').val() == "KRCOWA0004"
		||$('#st_buyer').val() == "KRCOWA0005"||$('#st_buyer').val() == "KRCOWA0006"
		||$('#st_buyer').val() == "KRCOWA0007"||$('#st_buyer').val() == "KRCOWA0008"
		||$('#st_buyer').val() == "KRHSDE0003"
		||$('#st_buyer').val() == "KRKOLO0112"||$('#st_buyer').val() == "KRKOLO0099"
		||$('#st_buyer').val() == "KRKOLO0106"||$('#st_buyer').val() == "KRKOLO0107"
		||$('#st_buyer').val() == "KRKOLO0108"||$('#st_buyer').val() == "KRKOLO0111"
		||$('#st_buyer').val() == "KRKOLO0110"||$('#st_buyer').val() == "KRKOLO0109"
		||$('#st_buyer').val() == "KRKOLO0113"||$('#st_buyer').val() == "KRSAMS0123"
		||$('#st_buyer').val() == "KRSAMS0192"
		)
	{
		$('#st_round_flag').hide();
		$('#st_decimal_flag').hide();		
	}else{
		$('#st_round_flag').show();
		$('#st_decimal_flag').show();
	}

	//mysheet3 - 운영사 견적특이사항
	var initsheet3 = {};
	initsheet3.Cols = [ 
					{ Align:"Center",	SaveName:"sStatus",	Header:"상태",	Type:"Status",	Width:50,	Hidden:1}
					,{ Align:"Left",	Width:440,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"특이사항",	SaveName:"ADD_NOTE"}
					,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"첨부",	SaveName:"IMAGE_KEY_IMG"}
					,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"첨부",	SaveName:"IMAGE_KEY"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"등록자",	SaveName:"ADD_USER_NM"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"등록일시",	SaveName:"ADD_DATE"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"수정자",	SaveName:"CHANGE_USER_NM"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"수정일시",	SaveName:"CHANGE_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BUYER",	SaveName:"BUYER"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"QUOTATION_NO",	SaveName:"QUOTATION_NO"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"QUOTATION_SEQ",	SaveName:"QUOTATION_SEQ"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"REVISION",	SaveName:"REVISION"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SEQ",	SaveName:"SEQ"}
					
	];
	
	IBS_InitSheet(mySheet3, initsheet3, pagingMode);
	
	mySheet3.SetImageList(2, diskOff);
	mySheet3.SetImageList(3, diskOn);
	
	//하이퍼링크 설정
	setLinkCol(mySheet3, "ADD_NOTE");	//특이사항
	setLinkCol(mySheet3, "IMAGE_KEY_IMG"); //첨부
	
	HdQuery();
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqSellerChoice3PopCode.do" , pagingMode );
	mySheet.SetFocusAfterProcess(0);
	kepSearch(document.searchCondition ,  mySheet2 , "/mprq/getMasterMpRqSellerChoice3Pop.do" , pagingMode );
	kepSearchNoBar(document.searchCondition,  mySheet3 , "/mprq/getMasterMpRqSellerChoice3PopReNote.do" , pagingMode );
	
}

function HdQuery(){
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mprq/getMasterMpRqSellerChoice3PopHd.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { st_buyer: $("#st_buyer").val(),st_quotation_no: $("#st_quotation_no").val(),st_quotation_seq: $("#st_quotation_seq").val(),st_revision: $("#st_revision").val(),st_sour_dept_yn: $("#st_sour_dept_yn").val()},
	     async : false,
	     success:function( response ) {
		    	 if (response.data.length > 0){
		    		
		    		$("#st_buyer_name").text($.trim(eval("response.data[0].BUYER_NAME")));
		    		$("#st_atos_end_date").text($.trim(eval("response.data[0].ATOS_END_DATE")));
		    		$("#st_import_flag").val($.trim(eval("response.data[0].IMPORT_FLAG")));
		    		$("#st_buyer_rate").text($.trim(eval("response.data[0].BUYER_RATE")) + " %");
		    		$("#st_pre_gr_flag").val($.trim(eval("response.data[0].PRE_GR_FLAG")));
		    		$("#st_btoa_user_name").text($.trim(eval("response.data[0].BTOA_USER_NAME")));
		    		$("#st_quotation_noseq").text("${param.st_quotation_no}"+" ("+"${param.st_quotation_seq}"+")");
		    		$("#st_process_name").val($.trim(eval("response.data[0].PROCESS_NAME")));
		    		$("#st_process_type").val($.trim(eval("response.data[0].PROCESS_TYPE")));
		    		$("#st_below_comorg_name").val($.trim(eval("response.data[0].BELOW_COMORG_NAME")));
		    		$("#st_below_comorg_code").val($.trim(eval("response.data[0].BELOW_COMORG_CODE")));
		    		$("#st_warehouse_code").val($.trim(eval("response.data[0].WAREHOUSE_CODE")));
		    		
		    		var buyer = $.trim(eval("response.data[0].BUYER"));
		    		if (buyer == "KRSAMS0123"){
		    			$("#st_process_type").val("2");
		    			$("#st_process_name").val("TR");
		    			$("#st_warehouse_code").val("KRKORE0440");
		    		}
		    		var st_buyer = 'KRDAEW0043,KRDAEW0045,KRDOOS0046,KRDIGU0001,KRDHIM0005,KRDHIM0002,KRDHIM0003,KRDHIM0001,KRDIVC0001,KRDIVC0002,KRDOOS0052';
		    		if (st_buyer.indexOf(buyer) >-1 && $.trim(eval("response.data[0].BELOW_COMORG_CODE")) == ""){
		    			$("#st_below_comorg_name").val($.trim(eval("response.data[0].BUYER_NAME")));
			    		$("#st_below_comorg_code").val($("#st_buyer").val());
		    		}
		    		$("#st_margin_rate").val($.trim(eval("response.data[0].MARGIN_RATE")));
		    		$("#st_margin_rate_org").val($.trim(eval("response.data[0].MARGIN_RATE")));
		    		$("#st_image_key").val($.trim(eval("response.data[0].IMAGE_KEY")));
		    		if ($.trim(eval("response.data[0].IMAGE_KEY")) == ""){
		    			$("img[id=st_image_1]").attr("src",diskOff);
		    		} else {
		    			$("img[id=st_image_1]").attr("src",diskOn);
		    		}
		    		$("#st_end_time_flag").val($.trim(eval("response.data[0].END_TIME_FLAG")));
		    		$("#st_admin_close_flag").val($.trim(eval("response.data[0].ADMIN_CLOSE_FLAG")));
		    		$("#st_admin_close_flag2").val($.trim(eval("response.data[0].ADMIN_CLOSE_FLAG_2")));
		    		$("#st_buyer_rate_gubun").val($.trim(eval("response.data[0].BUYER_RATE_GUBUN")));
		    		$("#st_early_end_flag").val($.trim(eval("response.data[0].EARLY_END_FLAG")));
		    		$("#st_after_item_md_complete").val($.trim(eval("response.data[0].AFTER_ITEM_MD_COMPLETE")));
		    		
		    		//RATE 타이틀변경
		    		if($.trim(eval("response.data[0].BUYER_RATE_GUBUN"))=="B"){
		    			$("#st_rate_text").val("고정매입수수료율");	
		    		}else{
		    			$("#st_rate_text").val("매익율");
		    		}
		    		$("#st_logistics_fee").val($.trim(eval("response.data[0].LOGISTICS_FEE")));
		    		$("#st_contract_flag").val($.trim(eval("response.data[0].CONTRACT_FLAG")));
		    		
		    		var buyerRateEdit = $.trim(eval("response.data[0].BUYER_RATE_EDIT"));
		    		
		    		if ($("#st_pre_gr_flag").val() == "Y"){
		    			 $('#ck_pre_gr_flag').attr("checked", true);
		    		} else {
		    			 $('#ck_pre_gr_flag').attr("checked", false);
		    		}
		    		//안전인증서 데이터 셋팅
		    		$("#st_safety_flag").val($.trim(eval("response.data[0].SAFETY_FLAG")));
		    		$("#st_old_safety_flag").val($.trim(eval("response.data[0].SAFETY_FLAG")));
		    		if (buyerRateEdit == "N"){
		    			$("#st_margin_rate").attr("disabled", true);
// 		    			$("#st_round_flag").attr("disabled", true);
// 		    			$("#st_decimal_flag").attr("disabled", true);
		    		}
		    		var options = {};
		    		 options.color = "red";
		    		 options["font-weight"] = "bold"; 

		    		if ($.trim(eval("response.data[0].END_TIME_FLAG"))=="Y"){
		    			$("#st_atos_end_date").css(options);
		    		}
		    	 }
		      },
		 error:function( response ) {  		    	   
	    	 alert("오류발생하였습니다.");
		      }	
	 }); 
}

function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg) {
	loader_obj("N","2");

   	if(mySheet.RowCount() <= 0) return;
   	
	var st_buyer = "${param.st_buyer}";
	if(st_buyer == "KRSAMS0123") { // 삼성전자만 보이도록
		mySheet.SetColHidden("ONLINE_PRICE", false);
		mySheet.SetColHidden("ONLINE_PRICE_REASON", false);	
	}
	
   	
	if (msg != "") {
		alert(msg);
	}

}
function mySheet2_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet2_OnSearchEnd(code, msg) {
	loader_obj("N","2");
	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
	var totRow = mySheet2.RowCount();
	if( totRow<= 0) return;
	var stoaListPrice = "";
	var buyer = 'KRDAEW0043,KRDAEW0045,KRDOOS0046,KRDIGU0001,KRDHIM0005,KRDHIM0002,KRDHIM0003,KRDHIM0001,KRDIVC0001,KRDIVC0002,KRDOOS0052';
	var st_buyer = 'KRCOWA0002,KRCOWA0003,KRCOWA0004,KRCOWA0001,KRCOWA0005,KRCOWA0006,KRCOWA0007,KRCOWA0008,KRSAMS0123,KRSAMS0140,KRSAMS0192';
	var avgRate = "";
	var rate = "";
	for(var i=1; i<=totRow;i++){
		mySheet2.SetCellValue(i,"SELECTED",1);
		
		if (mySheet2.GetCellValue(i, "END_TIME_FLAG")== "N" && $("#st_admin_close_flag2").val() == "N"){
			mySheet2.SetCellValue(i,"STOA_LIST_PRICE","***,***");
		} else {
			stoaListPrice = kepNumComma2(mySheet2.GetCellValue(i, "STOA_LIST_PRICE"));
			mySheet2.SetCellValue(i,"STOA_LIST_PRICE",stoaListPrice);
		}
 
		if (buyer.indexOf("${param.st_buyer}") >-1 && parseFloat(kepFilterNum(mySheet2.GetCellValue(i, "STOA_LIST_PRICE")))== eval(mySheet2.GetCellValue(i, "MIN_PRICE")) && mySheet2.GetCellValue(i, "RANK") == "1"){
			mySheet2.SetCellValue(i,"AGENT_CHECK",1);
			
		}
		
// 		if ("${param.st_buyer}" == "KRDHIM0001" && mySheet2.GetCellValue(i, "AVG_RATE") == "신규"){
			
// 		} else {
			if (mySheet2.GetCellValue(i, "AVG_RATE") != "***" && mySheet2.GetCellValue(i, "AVG_RATE") != "" &&  mySheet2.GetCellValue(i, "AVG_RATE") != "신규"){
				avgRate = kepNumComma2(mySheet2.GetCellValue(i, "AVG_RATE"));
				mySheet2.SetCellValue(i,"AVG_RATE",avgRate);
			}
			if (mySheet2.GetCellValue(i, "RATE") != "***" && mySheet2.GetCellValue(i, "RATE") != ""){
				rate = kepNumComma2(mySheet2.GetCellValue(i, "RATE"));
				mySheet2.SetCellValue(i,"RATE",rate);
			}
// 		}
		
	}
   	
	if (buyer.indexOf("${param.st_buyer}") >-1){
		mySheet2.SetColEditable("AGENT_CHECK",0);
	}
	
	if (st_buyer.indexOf("${param.st_buyer}") >-1 || buyer.indexOf("${param.st_buyer}") >-1){
		getBuyerPrimeCostRate();
		//Adapt();
	}
	
	if("${param.st_buyer}" == "KRDOOD0001" && !kepIsValueNull($('#st_process_type').val()) && !kepIsValueNull($('#st_below_comorg_code').val()) && !kepIsValueNull($('#st_margin_rate').val())) {
		//Adapt();
	}
	
	if (msg != "") {
		alert(msg);
	}
	
}

function mySheet3_OnSearchEnd(code, msg) {
	loader_obj("N");

   	if(mySheet3.RowCount() <= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}
}

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet2 , "/mprq/getMasterMpRqSellerChoice3Pop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "ATOA_REMARK_IMG" ){ 
		popupSel = "remarkAtoAPop";
		var st_buyer = "${param.st_buyer}";
		var st_quotation_no = "${param.st_quotation_no}";
		var st_quotation_seq = "${param.st_quotation_seq}";
		var st_revision = "${param.st_revision}";
		var st_atoa_remark = mySheet.GetCellValue(Row, "ATOA_REMARK");
		
		openSearchPopup("/common/remarkAtoAPop.do",'?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_atoa_remark='+st_atoa_remark,"500,200,no");// 운영사비고
	}else if(column == "IMGFILE_NAME_IMG"){
		popupSel = "addImgPop";
		var st_imgfile_dir = mySheet.GetCellValue(Row, "IMGFILE_DIR");
		var st_imgfile_name = mySheet.GetCellValue(Row, "IMGFILE_NAME");
		var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
		var st_agent = document.searchCondition.USER_ID.value;
		var mod_yn = "Y"; //수정여부
		var st_type = "S"; //협력사일경우
		openSearchPopup("/common/addImagePop.do", '?st_agent='+st_agent+'&st_imgfile_dir='+st_imgfile_dir+'&st_imgfile_name='+st_imgfile_name+'&st_buyer_item_no='+st_buyer_item_no+'&mod_yn='+mod_yn+'&st_type='+st_type, "590,670,no");
	}else if(column == "CMS_CATLG_ID"){
		var st_cms_catlg_id = mySheet.GetCellValue(Row,"CMS_CATLG_ID");
		if(st_cms_catlg_id == ""){
			alert("매핑된 표준카탈로그코드가 없습니다.");
			return ;
		}
		var st_cms_categ_id = mySheet.GetCellValue(Row,"CMS_CATEG_ID");
		openSearchPopup("/mdcm/showMasterMdCmGoodsInfoDetailPop.do", '?st_cms_categ_id='+st_cms_categ_id+'&st_cms_catlg_id='+st_cms_catlg_id, "800,700,no");// 품목정보 상세보기
	}else if(column == "MARKET_UNIT_PRICE_YN_IMG"){
		var maker_part_no = mySheet.GetCellValue(Row, "MAKER_PART_NO");
		if(maker_part_no == ""){ //모델명이 없는 경우
			alert("모델명이 존재하지 않습니다.");
			return ;
		}
		
		var url = "http://search.danawa.com/dsearch.php?k1=" + maker_part_no; //모델명 다나와 검색결과 호출
		window.open(url, "_blank");
		
		if(mySheet.GetCellValue(1, "MARKET_UNIT_PRICE_YN")=="N"){ //처음 N일 때만 update,쿼리 호출
			mySheet.SetCellValue(1, "MARKET_UNIT_PRICE_YN","Y");
			mySheet.SetCellValue(1, "ONLINE_URL",url);
			kepSaveAll(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqMarketUnitPriceYn.do");
		}
	}else if (column == 'BUYER_ITEM_NO'){ // 품목코드
		var st_buyer = "${param.st_buyer}";
		
		if (mySheet.GetCellValue(Row,"SIGNAL") == "1"){ // 기등록일 때만
			var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
			openSearchPopup('/common/mprq/masterMpRqContractLisPop.do','?st_buyer='+st_buyer+'&st_buyer_item_no='+buyerItemNo,'800,300,no');
		}else{
			alert("기등록건만 계약정보 조회 가능 합니다.");
			return;
		}
	}else if (column == 'RPA_MARKET_PRICE'){ // 시장가격
		var maker_part_no = mySheet.GetCellValue(Row, "MAKER_PART_NO");
		if(maker_part_no == ""){ //모델명이 없는 경우
			alert("모델명이 존재하지 않습니다.");
			return ;
		}
		
		var url = "http://search.danawa.com/dsearch.php?k1=" + maker_part_no; //모델명 다나와 검색결과 호출
		window.open(url, "_blank");
	}else if (column == 'RPA_HIST_PRICE'){ // 실적가격
		var buyer = mySheet.GetCellValue(Row,"RPA_BUYER");
		var catalog_com_code = mySheet.GetCellValue(Row,"RPA_CATLG_CODE");
		var buyer_item_no = mySheet.GetCellValue(Row,"RPA_ITEM_NO");
		
		if(buyer_item_no == ""){ // 실적이 없는 경우(품목코드로 판단)
			alert("실적 이력이 존재하지 않습니다.");
			return ;
		}
		
		//openSearchPopup("/mdcm/showMasterMdCmBuyerCatalogAlterPop.do","?st_buyer_code="+buyer+"&st_catalog_com_code="+catalog_com_code+"&st_buyer_item_no="+buyer_item_no+"&st_edit_yn=N","988,710,no");
		
		//post 팝업 파라미터 설정
		var st_form_name = "masterMdCmBuyerCatalogAlterPop";
		var st_popup_url = "/mdcm/showMasterMdCmBuyerCatalogAlterPop.do";
		var st_popup_param = "st_buyer_code@@"+buyer+"^||^"+"st_catalog_com_code@@"+catalog_com_code+"^||^"+"st_buyer_item_no@@"+buyer_item_no+"^||^"+"st_edit_yn@@N";
		var st_popup_option = "988,710,no";
		//post 팝업 호출
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}else if (column == "ORIGIN_NAME" ){ // 원산지
		popupSel = "country1";
		openSearchPopup("/common/countryCodePop.do", "", "500,500,no");
	}
	
	return;
}

//그리드 셀클릭 이벤트
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "STOA_REMARK_IMG" ){ 
		popupSel = "remarkBAS";
		var btoa_remark = mySheet2.GetCellValue(Row, "BTOA_REMARK");
		var atos_remark = mySheet2.GetCellValue(Row, "ATOS_REMARK");
		var stoa_remark = mySheet2.GetCellValue(Row, "STOA_REMARK");
		var atob_remark = mySheet2.GetCellValue(Row, "ATOB_REMARK");
		var st_buyer = mySheet2.GetCellValue(Row, "BUYER");
		var st_quotation_no = mySheet2.GetCellValue(Row, "QUOTATION_NO");
		var st_quotation_seq = mySheet2.GetCellValue(Row, "QUOTATION_SEQ");
		var st_revision = mySheet2.GetCellValue(Row, "REVISION");
		
		//openSearchPopup("/common/remarkBASPop.do",'?st_type=SOUR&st_btoa_remark='+btoa_remark+'&st_atos_remark='+atos_remark+'&st_stoa_remark='+stoa_remark+'&st_atob_remark='+atob_remark+'&st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision,"1000,730,no");// 고객사 비고
		
		var st_popup_url = "/common/remarkBASPop.do";
		var st_popup_param = "st_type@@SOUR^||^st_btoa_remark@@"+ btoa_remark +"^||^st_atos_remark@@"+  atos_remark
					+"^||^st_stoa_remark@@"+ stoa_remark +"^||^st_atob_remark@@"+ atob_remark
					+"^||^st_buyer@@"+ st_buyer +"^||^st_quotation_no@@"+st_quotation_no+"^||^st_quotation_seq@@"+st_quotation_seq
					+"^||^st_revision@@"+st_revision;
		var st_popup_option = "1000,730,no";
		
		openSearchPopupAppendPost("remarkBASPopForm",st_popup_url,st_popup_param,st_popup_option);// 고객사 비고
		
	}else if (column == "SELLER_IMAGE_KEY_IMG" ){
		popupSel = "fileUpload";
		var type="RFQ";
		var viewType="R";
		var image_key=mySheet2.GetCellValue(Row, "SELLER_IMAGE_KEY");
		if (image_key != "") {
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
		}
	}else if(column =="AGENT_CHECK"){
		if($('#st_sg_gbn').val() == "SO" &&$('#st_sg_kep_yn').val() == "N"){
			alert("협력사 선정 권한이 없습니다.");
			mySheet2.SetCellValue(Row,"AGENT_CHECK",0);
			return;
		}
		//선택한 협력사의 품목구분으로 셋팅하기
		mySheet.SetCellValue(1,"ITEM_MAKE_TYPE",mySheet2.GetCellValue(Row, "AGENT_ITEM_MAKE_TYPE"));
		
	//SLOGIC-BEGIN(P04-4031-23)
	} else if (column == "ORIGIN_NAME" ){ // 원산지
		if ($('#st_buyer').val() != "KRDOOD0001") return;
		popupSel = "country";
		openSearchPopup("/common/countryCodePop.do", "", "500,500,no");
	//SLOGIC-END
	//SLOGIC-BEGIN(P04-4031-24)
	} else if (column == "MAKER_NAME" ){ // 제조사
		if ($('#st_buyer').val() != "KRDOOD0001") return;
		popupSel = "maker";
		openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
	//SLOGIC-END
	}else if(column == "SELLER_AREA_IMG"){
		popupSel = "deliAreaPop";
		var buyer = $('#st_buyer').val();
		var seller_area = mySheet2.GetCellValue(Row, "SELLER_AREA");
		var plant = mySheet2.GetCellValue(Row, "PLANT");
		openSearchPopup("/common/getDeliveryAreaPop.do", '?st_com_code='+buyer+'&st_area_list='+seller_area+'&mod_yn=Y&plant_code='+plant, "400,270,no");
	}else if(column == "QTDT_IMGFILE_NAME_IMG"||column == "QTDT_IMG"){
		image_check_flag = "Y"; // 이미지 클릭 완료
		var st_imgfile_dir = mySheet2.GetCellValue(Row, "QTDT_IMGFILE_DIR");
		var st_imgfile_name = mySheet2.GetCellValue(Row, "QTDT_IMGFILE_NAME");
		var st_buyer_item_no = mySheet2.GetCellValue(Row, "BUYER_ITEM_NO");
		var mod_yn = "N"; //수정여부
		var st_type = "S"; //협력사일경우
		if(st_imgfile_name == ""){
			alert("협력사에서 첨부한 이미지가 없습니다.");
			return;
		}
		openSearchPopup("/common/addImagePop.do", '?st_imgfile_dir='+st_imgfile_dir+'&st_imgfile_name='+st_imgfile_name+'&st_buyer_item_no='+st_buyer_item_no+'&mod_yn='+mod_yn+'&st_type='+st_type, "590,670,no");
	}
	return;
}

//그리드 셀클릭 이벤트
function mySheet3_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet3.ColSaveName(mySheet3.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if(column == "IMAGE_KEY_IMG"){
		popupSel = "remarkFileUpload";
		var type="RFQ";
		var viewType="R";
		var image_key=mySheet3.GetCellValue(Row, "IMAGE_KEY");
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}else if(column == "ADD_NOTE" ){ //특이사항 입력
		var st_buyer = mySheet3.GetCellValue(Row,"BUYER");
		var st_quotation_no = mySheet3.GetCellValue(Row,"QUOTATION_NO");
		var st_quotation_seq = mySheet3.GetCellValue(Row,"QUOTATION_SEQ");
		var st_revision = mySheet3.GetCellValue(Row,"REVISION");
		openSearchPopup("/mprq/showMasterMpRqQutationRemark.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "850,350,no");
	}
}

//헤더 더블클릭시 복사
function mySheet2_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	
	if ( Row > 0 ) return;
	if ($('#st_buyer').val() != "KRDOOD0001") return;
	var totRow = mySheet2.RowCount();
	//SLOGIC-BEGIN(P04-4031-21)
	if (mySheet2.ColSaveName(Col) == "ORIGIN_NAME"){ // 원산지
		var value1 = mySheet2.GetCellValue(1, "ORIGIN_CODE");
		var value2 = mySheet2.GetCellValue(1, "ORIGIN_NAME");
		if(kepIsValueNull(value1)){
			alert("복사할 원산지를 선택하여 주십시요.");
			return;
		}
		for(var i=2; i<=totRow; i++){
			mySheet2.SetCellValue(i, "ORIGIN_CODE", value1);
			mySheet2.SetCellValue(i, "ORIGIN_NAME", value2);
		}
	//SLOGIC-END
	//SLOGIC-BEGIN(P04-4031-22)
	} else if (mySheet2.ColSaveName(Col) == "MAKER_NAME"){ // 제조사
		var value1 = mySheet2.GetCellValue(1, "MAKER_CODE");
		var value2 = mySheet2.GetCellValue(1, "MAKER_NAME");
		
		if(kepIsValueNull(value1)){
			alert("복사할 제조사를 선택하여 주십시요.");
			return;
		}
		for(var i=2; i<=totRow; i++){
			mySheet2.SetCellValue(i, "MAKER_CODE", value1);
			mySheet2.SetCellValue(i, "MAKER_NAME", value2);
		}
	}
	//SLOGIC-END
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3){
	if(popupSel == "fileUpload") {	//파일 첨부
		$('#st_image_key').val(value1);
		if (value1 == ""){
			$("img[id=st_image_1]").attr("src",diskOff);
		} else {
			$("img[id=st_image_1]").attr("src",diskOn);
		}
	} else if (popupSel == "commonCoCoGoodsDlvyClssifyPop"){ // 거래유형
		$('#st_process_type').val(value1);
		$('#st_process_name').val(value2);
		$('#st_warehouse_code').val(value3);
		//Adapt();
	} else if (popupSel == "commonCoCoBottomOrgCodePop"){ // 적용구분
		$('#st_below_comorg_code').val(value1);
		$('#st_below_comorg_name').val(value2);
		//Adapt();
	} else if (popupSel == "country1"){ // 원산지(RQDT)
		mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value1);
		mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value3);
	} else if (popupSel == "country"){ // 원산지(QTDT)
		mySheet2.SetCellValue(grbRow, 'ORIGIN_CODE', value1);
		mySheet2.SetCellValue(grbRow, 'ORIGIN_NAME', value3);
	}else if (popupSel == "maker"){ // 제조사
		mySheet2.SetCellValue(grbRow, 'MAKER_CODE', value1);
		mySheet2.SetCellValue(grbRow, 'MAKER_NAME', value2);
	}else if (popupSel == "deliAreaPop"){ // 납품지역
		mySheet2.SetCellValue(grbRow, 'SELLER_AREA', value1);
	 	 if(value1 ==""){
	 		mySheet2.SetCellValue(grbRow, 'SELLER_AREA_IMG', areaOff);
	 	 }else{
	 		mySheet2.SetCellValue(grbRow, 'SELLER_AREA_IMG', areaOn);
	 	 }
	}else if(popupSel == "addImgPop") {	// 이미지첨부
			mySheet.SetCellValue(grbRow, 'IMGFILE_DIR', value1);
			mySheet.SetCellValue(grbRow, 'IMGFILE_NAME', value2);
 			mySheet.SetCellValue(grbRow, 'IMGFILE_NAME_IMG', (value1!="")? diskOn : diskOff);
 			mySheet.SetCellValue(grbRow, 'RFQ_IMG_TYPE', (value1!="")? "M" : "S");
	}else if(popupSel == "remarkAtoAPop") {	//운영사 비고
 			mySheet.SetCellValue(grbRow, 'ATOA_REMARK', value1);
 			mySheet.SetCellValue(grbRow, 'ATOA_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
 			
	}
	
	grbRow="";	//초기화
}
function doAction(str) { 
	switch (str) {
	case "save":
		
		if ($('#st_image_key').val()==""){
			alert("파일을 첨부하여 주십시요.");
			return;
		}
		if(confirm("첨부파일을 수정하시겠습니까?")) {
			fileUpdate();
		}
		break;
	case "close": //견적마감
		//전략소싱팀 담당건 사업팀 진행 불가.
		if($('#st_sg_gbn').val() == "SO"){
			if($('#st_sg_kep_yn').val() == "N"){
				alert("해당견적에 대한 처리 권한이 없습니다.");
				return;
			}
		}
		if($('#st_admin_close_flag').val() == "N"){
			alert("견적이 완료되었습니다.");
			return;
		}
		if(!confirm(" 견적을 조기 마감 하시겠습니까?")) return;
		
// 		IBS_SaveName(document.searchCondition ,mySheet);
//  		var info = FormQueryStringEnc(document.searchCondition , true);
//  		mySheet.DoAllSave("/mprq/saveMasterMpRqClose.do", info);
 		kepSaveAll(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqClose.do");
		break;
	case "round": // 추가라운드요청
		//전략소싱팀 담당건 사업팀 진행 불가.
		if($('#st_sg_gbn').val() == "SO"){
			if($('#st_sg_kep_yn').val() == "N"){
				alert("해당견적에 대한 처리 권한이 없습니다.");
				return;
			}
		}
		var end_time_flag = $('#st_end_time_flag').val();
		
		var rcv_agent_flag = $('#st_rcv_agent_flag').val();
		if(rcv_agent_flag=="N") {
			if(end_time_flag=="N") {
				alert("견적마감일 전에는 협력사 재견적 요청 혹은 추가를 할수 없습니다.");
				return;
			}
		}
		
		var after_item_md_complete = $('#st_after_item_md_complete').val();
		if(after_item_md_complete != "Y") {
			alert("추가정비 요청 후 미제출건은 진행할 수 없습니다.");
			return;
		}
		
		var buyer = "${param.st_buyer}";
		var quotation_no = "${param.st_quotation_no}";
		var quotation_seq = "${param.st_quotation_seq}";
		var revision = "${param.st_revision}";
		var rcv_agent_flag = "${param.st_rcv_agent_flag}";
		var sg_id = "${param.st_sg_id}";
		var rfq_kep_user = "${sessionInfo.userId}";
		
		popupSel = "masterMpRqSellerChoicePop";
		// 파라미터는 수정 해야 함
		openSearchPopup("/mprq/showMasterMpRqSellerChoicePop.do",'?st_buyer_code='+buyer+"&st_quotation_no="+quotation_no+"&st_quotation_seq="+quotation_seq+"&st_revision="+revision
									+"&st_end_time_flag="+end_time_flag+"&rcv_agent_flag="+rcv_agent_flag+"&st_sg_id="+sg_id+"&st_rfq_kep_user="+rfq_kep_user+"&st_agent_list="
									,"900,400,no");
		break;
	case "bid": // 협력사 선정
		var selectedGrid = mySheet2.FindCheckedRow("AGENT_CHECK");
		var arrRow = selectedGrid.split("|");
		var columnType = "<%=columnType%>";
		if (selectedGrid.length == 0){
	        alert("협력사를 지정하여 주십시요.");
	        return;
		}
		var st_smart_dept_yn = "<%=st_smart_dept_yn%>";
		var st_buyer = "<%=buyer%>";
		var maker_part_no = mySheet.GetCellValue(1, "MAKER_PART_NO");
		var online_price = mySheet.GetCellValue(1, "ONLINE_PRICE");		
		var online_price_reason = mySheet.GetCellValue(1, "ONLINE_PRICE_REASON");
	
		if(st_smart_dept_yn == "Y" && maker_part_no != "" && mySheet.GetCellValue(1, "MARKET_UNIT_PRICE_YN") == "N") { // 제조번호 있으면서 시장가 확인이 안된 경우
			alert("SMART팀은 시장가 확인 필수입니다");
			return;
		}
		if(st_buyer == 'KRSAMS0123' && maker_part_no != "") { // 삼성전자면서 제조번호가 있는경우, 위에 시장가 확인은 체크함
			if(online_price == '') {
				alert("SMART팀은 시장가 확인 이후 시장단가 입력 필수입니다.");
				return;
			}
			if(online_price_reason == '') {
				alert("SMART팀은 시장가 확인 이후 단가구분 입력 필수입니다.");
				return;
			}
		}
		
		
		if(columnType == "A" && columnType != "") { // // 최저가 통제 : A
			if(mySheet2.GetCellValue(selectedGrid, "BETWEEN_RATE") != '최저가'){
				alert("해당 고객사는 최저가 업체 선정 필수입니다.");
				return;
			}
		} else if(columnType == "B" && columnType != "") { // 매입단가 통제 : B
			if(mySheet2.GetCellValue(selectedGrid, "STOA_LIST_PRICE") != ''){ 
				alert(""); // 해당 고객사는 [매입단가 x원 이하 불가, x원 이상] 업체 선정 필수입니다.
				return;
			}			
		} else if(columnType == "C" && columnType != "") { // 매출단가 통제 : C
			if(mySheet2.GetCellValue(selectedGrid, "ATOB_UNIT_PRICE") != ''){ 
				alert(""); // 해당 고객사는 [매출단가 x원 이하 불가, x원 이상] 업체 선정 필수입니다.
				return;
			}			
		}
		
		if(mySheet2.GetCellValue(selectedGrid, "STOA_LIST_PRICE") == 0){
			alert("매입단가 0원인 협력사는 선정할 수 없습니다.");
			return;
		}
		
		Adapt();
		//품목구분이 없는 경우 체크(공백인 경우)
		var item_make_type = mySheet.GetCellValue(1, "ITEM_MAKE_TYPE");
		if(item_make_type == ""){
			alert("품목구분을 선택하여 주십시요.");
			mySheet.SelectCell(1, "ITEM_MAKE_TYPE");
			return;
		} 
		var rtn = getAgentListCheck();
		if (rtn == 1)
		{
			setBidSuccessCode('BS01','최저가 업체','');
		}
		else if(rtn == 2){
			// 팝업링크
			doPop('bidSucessCode');
		}
		else if(rtn==4){
			//단독입찰 팝업 호출
			doPop('soloAgentRemark');
		}
		else if(rtn ==3){
			//사업팀에서 입력한 내용 저장.
			if(!confirm("입력한 내용 저장 하시겠습니까?")){
				return;
			}
			setAgentPickup();
		}
		break;
	case "kepConfirm":
		parent.doAction('search');
		self.close();
		break;
		
	case "add_note":
		var st_buyer = "${param.st_buyer}";
		var st_quotation_no = "${param.st_quotation_no}";
		var st_quotation_seq = "${param.st_quotation_seq}";
		var st_revision = "${param.st_revision}";
		openSearchPopup("/mprq/showMasterMpRqQutationRemark.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "850,350,no");
		break;
	}
}
function setBidSuccessCode( code, name, remark, seq, user_name, dept_name ){
	$('#st_bid_success_code').val(code);
	$('#st_bid_success_reason').val(remark);
	$('#st_agent_choice_seq').val(seq);
	$('#st_pre_gr_user_name').val(user_name);
	$('#st_pre_gr_dept_name').val(dept_name);
	/*
	if(code == "BS01"){
		if(!confirm("최저가 업체로 선정 되었습니다\n\n견적 제출 하시겠습니까?")){
			return;
		}
	}else{
		if(!confirm(name+"으로 선정 사유가 선택 되었습니다\n\n견적 제출 하시겠습니까?")){
			return;
		}
	}*/
	setAgentPickup();
}

//저장시 체크로직
/**
 * 0 : 진행안함.
 * 1 : 최저가업체
 * 2 : 그외
 */
function getAgentListCheck(){
	var totRow = mySheet2.RowCount();
	if( totRow<= 0) return;
	var chk_success_flag = "N";
	var bid_success_flag = "N";
	var buyer_target_price	= mySheet.GetCellValue(1, "BUYER_TARGET_PRICE");
	var admin_target_price	= mySheet.GetCellValue(1, "ADMIN_TARGET_PRICE");
	var agent_revision		= "";
	var min_price		    = "";
	var st_t_min_price		= "";
	var st_t_round		    = ""; 
	var stoa_list_price		= "";
	var moq_use_flag = "<%=moq_use_flag%>";
	var min_order_qty = "";
	var pur_unit_qty = "";
	var area_use_flag = "<%=area_use_flag%>";
	var seller_area = "";
	var item_make_type = "";
	var sol_agent_yn = "";
	//이미지 경로 null 체크
	var st_imgfile_dir = mySheet.GetCellValue(1, "IMGFILE_DIR");
	var st_imgfile_name = mySheet.GetCellValue(1, "IMGFILE_NAME");
	//지정협력사 체크
	var st_assign_agent_code = mySheet.GetCellValue(1, "ASSIGN_AGENT_CODE");
	var st_assign_agent_name = mySheet.GetCellValue(1, "ASSIGN_AGENT_NAME");
	//제출단가 범위 체크
	var unit_price_check_flag = "<%=unit_price_check_flag%>";
	var min_unit_price = 0;
	var max_unit_price = 0;
	//과세구분 체크
	var rqdt_tax_type = mySheet.GetCellValue(1, "TAX_TYPE");
	var qtdt_tax_type = "";
	
	if(unit_price_check_flag == "Y"){
		min_unit_price = "<%=min_unit_price%>";
		max_unit_price = "<%=max_unit_price%>";
	}
	
	//마감건 조기마감 이후 처리 되게 수정
	if($('#st_admin_close_flag').val() == "Y"){
		alert("견적마감일 미도래건 입니다.\n견적마감 처리 바랍니다.");
		return 0;
	}
	if(st_imgfile_dir != "" || st_imgfile_name!=""){
		if(st_imgfile_dir == ""){
			alert("품목 이미지 경로 입력 바랍니다.");
			mySheet.SelectCell(1, "IMGFILE_DIR");
			return 0;
		}
		if(st_imgfile_name == ""){
			alert("품목 이미지 파일명을 입력 바랍니다.");
			mySheet.SelectCell(1, "IMGFILE_NAME");
			return 0;			
		}
	}
	if(!kepIsNumChk('st_margin_rate',2)) {
		alert("매익율(숫자형식)을 입력하여 주십시요.");
		$('#st_margin_rate').focus();
		return 0;
	}
	
	
	for(var i=1; i<=totRow;i++){
		agent_revision		= mySheet2.GetCellValue(i, "AGENT_REVISION");
		st_t_min_price		= parseFloat(mySheet2.GetCellValue(i, "T_MIN_PRICE"));
		min_price		    = parseFloat(mySheet2.GetCellValue(i, "MIN_PRICE"));
		st_t_round		    = mySheet2.GetCellValue(i, "T_ROUND"); 
		stoa_list_price		= parseFloat(kepFilterNum(mySheet2.GetCellValue(i, "STOA_LIST_PRICE")));
		min_order_qty	    = mySheet2.GetCellValue(i, "MIN_ORDER_QTY");
		pur_unit_qty	    = mySheet2.GetCellValue(i, "PUR_UNIT_QTY");
		seller_area		    = mySheet2.GetCellValue(i, "SELLER_AREA");
		sol_agent_yn	    = mySheet2.GetCellValue(i, "SOL_AGENT_YN");
		atob_unit_price	    = mySheet2.GetCellValue(i, "ATOB_UNIT_PRICE");
		qtdt_tax_type		= mySheet2.GetCellValue(i, "QTDT_TAX_TYPE");
		
		if (mySheet2.GetCellValue(i, "AGENT_CHECK") == 1){
			chk_success_flag = "Y";
			bid_success_flag = "Y";
			
			if(moq_use_flag == "Y"){
				if(min_order_qty < 1 || kepIsValueNull(min_order_qty)){
					alert("MOQ(숫자형식)를 입력하세요.(최소값:1)");
					mySheet2.SelectCell(i, "MIN_ORDER_QTY");
					return 0;
				}
				if(pur_unit_qty < 1 || kepIsValueNull(pur_unit_qty)){
					alert("발주배수(숫자형식)를 입력하세요.(최소값:1)");
					mySheet2.SelectCell(i, "PUR_UNIT_QTY");
					return 0;
				}
			}
			
			if(pur_unit_qty > min_order_qty) {
				alert("발주배수가 MOQ보다 큽니다. 확인 바랍니다.");
				mySheet2.SelectCell(i, "PUR_UNIT_QTY");
				return 0;
			}
			
			if(area_use_flag == "Y"){
				if(kepIsValueNull(seller_area)){
					alert("납품지역을 선택하여 주십시요.");
					mySheet2.SelectCell(i, "SELLER_AREA_IMG");
					return 0;
				}
			}
			
			if(st_assign_agent_code != ''){
				if(st_assign_agent_code != mySheet2.GetCellValue(i, "AGENT")){
					alert("지정협력사( " + st_assign_agent_name + " )가 아닙니다.");
					mySheet.SelectCell(1, "ASSIGN_AGENT_NAME");
					return 0;
				}
			}
			
			if(unit_price_check_flag == "Y"){
				if(min_unit_price >= atob_unit_price){
					alert("해당 고객사의 판매 최저단가는 " + min_unit_price + " 원 이하 제출 불가합니다.");
					mySheet2.SelectCell(i, "ATOB_UNIT_PRICE");
					return 0;
				}
				if(max_unit_price <= atob_unit_price){
					alert("해당 고객사의 판매 최고단가는 " + max_unit_price + " 원 이상 제출 불가합니다.");
					mySheet2.SelectCell(i, "ATOB_UNIT_PRICE");
					return 0;
				}
			}
			
			if(qtdt_tax_type != rqdt_tax_type){
				mySheet.SelectCell(1, "TAX_TYPE");
				mySheet2.SelectCell(i, "QTDT_TAX_TYPE");
				alert("KEP견적의 과세구분이 협력사가 제출한 과세구분과 불일치합니다.\n제출 전 꼭 확인하시기 바랍니다.\n진행 시 KEP견적의 과세구분으로 등록됩니다.");
			}
		}else {
			bid_success_flag = "N";
		}
		
		if ($('#st_buyer').val() == "KRDOOD0001"){
			if (mySheet2.GetCellValue(i, "AGENT_CHECK") == 1 && (kepIsValueNull(mySheet2.GetCellValue(i, "ORIGIN_CODE")) || kepIsValueNull(mySheet2.GetCellValue(i, "ORIGIN_NAME")))){
				alert("원산지를 선택하세요.");
				return 0;
			}
			if (mySheet2.GetCellValue(i, "AGENT_CHECK") == 1 && (kepIsValueNull(mySheet2.GetCellValue(i, "MAKER_CODE")) || kepIsValueNull(mySheet2.GetCellValue(i, "MAKER_NAME")))){ 
				alert("제조사를 선택하세요.");
				return 0;
			}
		}
		// 목표단가 및 공급사 차수 확인 후 진행 여부 확인한다.
		/*
		if((buyer_target_price ==""||buyer_target_price == 0) && (admin_target_price ==""||admin_target_price == 0) && agent_revision == 1 ) {
			alert("목표단가(고), 목표단가(운) 값이 없을 경우\n1차수에 협력사 선정할 수 없습니다.\n추가라운드를 진행하시기 바랍니다.");
			return 0;
		}
		*/
		//협력사 2차수 이상일 경우 기존 매입단가 조회 2014.03.07 현
		if(agent_revision > 1){
			if(bid_success_flag == "Y" && (eval(st_t_min_price) != eval(stoa_list_price))){
				if(!confirm(st_t_round+"라운드의 최저가인 "+kepNumComma2(st_t_min_price)+"원 보다 비싼 단가가 선정되었습니다.\n 전체라운드 내에서는 최저가 선정이 아닙니다. \n계속하시겠습니까?")){
					return 0;
				} else {
					return 2;
				}
			}
		}else{
			if(bid_success_flag == "Y" && (eval(stoa_list_price) !=  eval(min_price))) {
				if(!confirm("선택하신 업체는 최저가 업체가 아닙니다\n\n계속하시겠습니까?")) { 
					return 0;
				} else {
					return 2;
				}
			}
		}
		//라운드 진행 중 단독입찰일 경우 사유 입력 팝업 호출.
		if(sol_agent_yn == "Y"){
			return 4;
		}
		
	}
	
	//전략소싱팀 담당건 사업팀 진행 불가.
	if($('#st_sg_gbn').val() == "SO"){
		//전략소싱팀건 사업팀이 아닐경우 체크 하지 않음.
		if($('#st_sg_kep_yn').val() == "Y"){
			if(chk_success_flag == "N"){
		        alert("협력사를 지정하여 주십시요.");
		        return 0;
			}else{
				return 1;
			}
		}else{
			return 3;			
		}
	}else{
		if(chk_success_flag == "N"){
	        alert("협력사를 지정하여 주십시요.");
	        return 0;
		}else{
			return 1;	
		}		
	}
}
function setAgentPickup() {

	var end_time_flag = $('#st_end_time_flag').val();
	var rcv_agent_flag = $('#st_rcv_agent_flag').val();
	//조기마감 가능 고객사 모든 견적 회신이 들어오지 않아도 업체선정 가능.
	if($('#st_early_end_flag').val() == "N" ){
		if(rcv_agent_flag=="N" && end_time_flag=="N") {
			alert("마감전 협력사로 부터 모든견적이 회신이 되지 않았습니다.");
			return;
		}
	}
	//안전인증서 상태 체크
	var st_old_safety_flag = $('#st_old_safety_flag').val();
	var st_safety_flag = $('#st_safety_flag').val();
	if(st_old_safety_flag=="Y" && st_safety_flag =="N"){
		alert("고객사에서 안전 인증서를 요청한 견적건은 미요청으로 변경 불가능 합니다.");
		$('#st_safety_flag').focus();
		return;		
	}
	//안전인증서 첨부시 첨부파일 체크
	if($('#st_image_key').val()=="" && st_safety_flag =="A"){
		alert("안전인증서 첨부 바랍니다.");
		return;		
	}
	
	if ($("#ck_pre_gr_flag").is(':checked') == false){
		$('#st_pre_gr_flag').val("N");
	} else {
		$('#st_pre_gr_flag').val("Y");
	}

	getAgentPickupList();
}
//협력사 지정, 판매단가 및 매익율 저장
function getAgentPickupList(){
	var totRow = mySheet2.RowCount();
	if( totRow<= 0){
		alert("협력사로 부터 회신된 견적제시 단가 데이타가 없습니다.");		
		return;
	} 
		
	var selectedGrid = mySheet2.FindCheckedRow("AGENT_CHECK");
	var arrRow = selectedGrid.split("|");
	//전략소싱팀 담당건 사업팀 진행 불가.
	if($('#st_sg_gbn').val() == "SO"){
		//전략소싱팀건 사업팀이 아닐경우 체크 하지 않음.
		if($('#st_sg_kep_yn').val() == "Y"){
			if (selectedGrid.length == 0){
		        alert("협력사를 지정하여 주십시요.");
		        return;
			}
		}
	}else{
		if (selectedGrid.length == 0){
	        alert("협력사를 지정하여 주십시요.");
	        return;
		}		
	}

	document.searchCondition.st_img_type.value = mySheet.GetCellValue(1, "RFQ_IMG_TYPE");
	document.searchCondition.st_imgfile_dir.value = mySheet.GetCellValue(1, "IMGFILE_DIR");
	document.searchCondition.st_imgfile_name.value = mySheet.GetCellValue(1, "IMGFILE_NAME");
	document.searchCondition.st_rqdt_tax_type.value = mySheet.GetCellValue(1, "TAX_TYPE");
	document.searchCondition.st_item_make_type.value = mySheet.GetCellValue(1, "ITEM_MAKE_TYPE");
	document.searchCondition.st_rqdt_origin_code.value = mySheet.GetCellValue(1, "ORIGIN_CODE");
	document.searchCondition.st_online_price.value = mySheet.GetCellValue(1, "ONLINE_PRICE");
	document.searchCondition.st_online_price_reason.value = mySheet.GetCellValue(1, "ONLINE_PRICE_REASON");
	
	var st_imgfile_name = mySheet2.GetCellValue(arrRow, "QTDT_IMGFILE_NAME");
	var st_imgfile_dir = mySheet2.GetCellValue(arrRow, "QTDT_IMGFILE_DIR");
	var st_buyer_item_no = mySheet2.GetCellValue(arrRow, "BUYER_ITEM_NO");
	var mod_yn = "N"; //수정여부
	var st_type = "S"; //협력사일경우
	
	if(st_imgfile_name != ""){
		if(image_check_flag == "N"){ // 이미지 클릭 한 적 없는 경우
			image_check_flag = "Y";
			openSearchPopup("/common/addImagePop.do", '?st_imgfile_dir='+st_imgfile_dir+'&st_imgfile_name='+st_imgfile_name+'&st_buyer_item_no='+st_buyer_item_no+'&mod_yn='+mod_yn+'&st_type='+st_type, "590,670,no");
			return;
		}
	}
	
	IBS_SaveName(document.searchCondition ,mySheet2);
	var info = FormQueryStringEnc(document.searchCondition , true);
	mySheet2.DoAllSave("/mprq/saveMasterMpRqAgentSel.do", info);
	
}
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	if(code>0){
		HdQuery();
		kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqSellerChoice3PopCode.do" , pagingMode );
		mySheet.SetFocusAfterProcess(0);
		kepSearch(document.searchCondition ,  mySheet2 , "/mprq/getMasterMpRqSellerChoice3Pop.do" , pagingMode );
	}
}
//트랜젝션(저장,삽입등) 후처리
function mySheet2_OnSaveEnd(code, msg) {
	loader_obj("N");
	if (msg != "") {
		alert(msg);
	}
	
	if(code>0){
		opener.doAction('search');
		self.close();
	}
}
function mySheet_OnChange(Row, Col, Value) {

	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	if(column == "RFQ_IMG_TYPE"){
		var st_rfq_img_type = mySheet.GetCellValue(1,"RFQ_IMG_TYPE");
			
		if(st_rfq_img_type == "N"){ //운영사(미완성) 선택할 경우
			mySheet.SetCellValue(1, "IMGFILE_DIR","ITEM_IMAGE/S2017_2");
			mySheet.SetCellValue(1, "IMGFILE_NAME","s_make.jpg");
		}else{
			mySheet.SetCellValue(1, "IMGFILE_DIR","");
			mySheet.SetCellValue(1, "IMGFILE_NAME","");
		}
	}
}
function fileUpdate() {
	if ($("#ck_pre_gr_flag").is(':checked') == false){
		$('#st_pre_gr_flag').val("N");
	} else {
		$('#st_pre_gr_flag').val("Y");
	}
	
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mprq/updateFileUpload.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { st_image_key:$('#st_image_key').val(),st_pre_gr_flag:$('#st_pre_gr_flag').val(),st_buyer: $("#st_buyer").val(),st_quotation_no: $("#st_quotation_no").val(),st_quotation_seq: $("#st_quotation_seq").val(),st_revision: $("#st_revision").val()},
	     async : false,
	     success:function( response ) {
	    	 alert(response.Message);
		      },
		 error:function( response ) {  	
			 alert(response.Message);
		      }	
	 }); 
}
// 
function getBuyerPrimeCostRate() {
	if(kepIsValueNull($('#st_below_comorg_code').val())) {
		alert("적용구분을 입력하여 주십시요.");
		return;
	}

	if(kepIsValueNull($('#st_process_type').val())) {
		alert("거래유형을 입력하여 주십시요.");
		return;
	}

	
	//SLOGIC-BEGIN(P04-4031-33)
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mprq/getBuyerRate.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { st_buyer: $("#st_buyer").val()},
	     async : false,
	     success:function( response ) {
		    	 if (response.data.length > 0){
		    	 	$('#st_logi_buyer_rate').val($.trim(eval("response.data[0].BUYER_RATE")));
		    	 }
		      },
		 error:function( response ) {  	
			 alert("오류발생하였습니다.");
		      }	
	 });
	
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mprq/getProcessImportRate.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { st_process_type:$('#st_process_type').val(),st_import_flag:$('#st_import_flag').val()},
	     async : false,
	     success:function( response ) {
	    	 if (response.data.length > 0){
		    	 	$('#st_process_import_rate').val($.trim(eval("response.data[0].PROCESS_IMPORT_RATE")));
		    	 }
	    	 
		      },
		 error:function( response ) {  	
			 alert("오류발생하였습니다.");
		      }	
	 });
	
	$('#st_logi_buyer_rate').val(eval($('#st_logi_buyer_rate').val()) + eval($('#st_process_import_rate').val()));
	
	var totRow = mySheet2.RowCount();
	if( totRow<= 0) return;
	var logiAmt = "";
	var logiticsFee = $('#st_logistics_fee').val();
	var price = "";
	var stoa_list_price = "";
	for(var i=1; i<=totRow;i++){
		stoa_list_price = parseFloat(kepFilterNum(mySheet2.GetCellValue(i, "STOA_LIST_PRICE")));
		logiAmt = kepGetRound(stoa_list_price  * (eval(logiticsFee) / eval(100)), 3);
		price = kepGetRound(stoa_list_price + kepGetRound(stoa_list_price * (eval($('#st_logi_buyer_rate').val()) / 100),3) ,3) - eval(logiAmt);
		mySheet2.SetCellValue(i,"ATOB_UNIT_PRICE",price);
	}
	//SLOGIC-END
}
//마진율 입력시 판매단가와 매익율 계산적용
function Adapt(){
	//전략소싱팀 담당건 진행 불가.
	if($('#st_sg_gbn').val() == "SO"){
		if($('#st_sg_kep_yn').val() == "Y"){
			alert("사업팀만 처리 가능합니다.");
			$("#st_margin_rate").val($("#st_margin_rate_org").val());
			return;
		}
	}
	var st_margin_rate = $("#st_margin_rate").val();
	var st_margin_rate_org = $("#st_margin_rate_org").val();
	var st_round_flag = $('#st_round_flag').val();
	var st_decimal_flag = $('#st_decimal_flag').val();

	if($('#st_admin_close_flag').val() == "Y"){
		alert("마감이후 매익율 조정이 가능합니다.");
		$("#st_margin_rate").val("");
		return;
	}

	if(kepIsValueNull($('#st_process_type').val())) {
		alert("거래유형을 입력하여 주십시요.");
		return;
	}

	if(kepIsValueNull($('#st_below_comorg_code').val())) {
		alert("적용구분을 입력하여 주십시요.");
		return;
	}

	if(kepIsValueNull($('#st_margin_rate').val())) {
		alert("매익율을 입력하여 주십시요.");
		$('#st_margin_rate').focus();
		return;
	}

	if(!kepIsNumChk('st_margin_rate',2)) {
		
		alert("매익율(숫자형식)을 입력하여 주십시요.");
		$("#st_margin_rate").val("");
		$('#st_margin_rate').focus();
		return;
	}	
	
 	if ($('#st_contract_flag').val() == "F"){ // feebase 고객사
 		if (st_margin_rate_org != st_margin_rate){
	 		if(!confirm("계약 매익율은 "+st_margin_rate_org+"입니다. "+st_margin_rate+" 로 변경하시겠습니까?")){
	 			$('#st_margin_rate').val(st_margin_rate_org);
	 			return;
	 		}
 		}
 	}

	setMargin(st_margin_rate, st_round_flag, st_decimal_flag);
}
function setMargin(st_margin_rate, st_round_flag, st_decimal_flag){
	var totRow = mySheet2.RowCount();
	var stoa_list_price = "";
	var price = "";
	var atob_temp = "";
	var atob_unit_price = "";
	var st_decimal_flag2 = st_decimal_flag;
	var margin_rate = 1+(st_margin_rate/100);
	if (st_decimal_flag == "1"){
		st_decimal_flag2 = "0";	
	} else if (st_decimal_flag == "2"){
		st_decimal_flag2 = "1";	
	} else if (st_decimal_flag == "3"){
		st_decimal_flag2 = "2";	
	} else if (st_decimal_flag == "4"){
		st_decimal_flag2 = "3";	
	} else {
		st_decimal_flag2 = "0";
	}

	if( totRow<= 0) return;
	//SLOGIC-BEGIN(P04-4031-26)	
	if ($('#st_buyer_rate_gubun').val() == "B") { // 매입가 기준
		var rate = 0;
		for(var i=1; i<=totRow;i++){
			stoa_list_price = parseFloat(kepFilterNum(mySheet2.GetCellValue(i, "STOA_LIST_PRICE")));
			if ($("#st_buyer").val() == "KRDOOD0001" || $("#st_buyer").val() == "KRDOOS0004"){
				atob_unit_price = eval(stoa_list_price * (1 + (st_margin_rate / 100))).toFixed(st_decimal_flag2);
				if (eval(atob_unit_price) > 1000){
					price = Math.round(atob_unit_price*0.1)/0.1; // 천원 초과일경우 반올림 계산식
				} else {
					price = Math.round(atob_unit_price*1)/1;  // 천원 이하일경우 반올림 계산식
				}				
			} else if($("#st_buyer").val() =="KRDOOS0046"
				||$("#st_buyer").val() =="KRDHIM0001"|| $("#st_buyer").val() =="KRDAEW0043"
					||$("#st_buyer").val() =="KRDAEW0045"|| $("#st_buyer").val() =="KRDHIM0002"
					||$("#st_buyer").val() =="KRDHIM0003"|| $("#st_buyer").val() =="KRDHIM0005"
					||$("#st_buyer").val() =="KRDIGU0001"){
					   // 두산인프라코어 금액별 계산방법
						if(stoa_list_price*margin_rate > 999){
							price = kepGetFloor2(stoa_list_price*margin_rate,1);
						}else{
							price = kepGetRound2(stoa_list_price*margin_rate,1);
						}
						var atob_unit_price_len = String(price).length;
						
						if(eval(price) <= 999) {
							price = kepGetRound2(price, 1);
						}else if(eval(price) >= 1000 && eval(price) <= 999999){
							price = kepGetFloor2(price, -(atob_unit_price_len-5)).toFixed(0);								
						}else if(eval(price) >= 1000000 && eval(price) <= 9999999999){
							price = kepGetFloor2(price, -(atob_unit_price_len-4)).toFixed(0);
						}						
						
			} else if($("#st_buyer").val() =="KRCOWA0001"|| $("#st_buyer").val() =="KRCOWA0002"
					||$("#st_buyer").val() =="KRCOWA0003"|| $("#st_buyer").val() =="KRCOWA0004"
					||$("#st_buyer").val() =="KRCOWA0005"|| $("#st_buyer").val() =="KRCOWA0006"
					||$("#st_buyer").val() =="KRCOWA0007"|| $("#st_buyer").val() =="KRCOWA0008"){
					   // 코웨이  금액별 계산방법
					   price = stoa_list_price*margin_rate;
						if(eval(price) < 20) {
							price = kepGetRound2(price, 2);
						}else if(eval(price) >= 20 && eval(price) < 1000){
							price = kepGetRound2(price, 1);								
						}else if(eval(price) >= 1000){
							price = kepGetRound2(price, 0);
						}						
						
			} else if($("#st_buyer").val() =="KRSAMS0140"){
				   // 삼성  금액별 계산방법
				   price = doSum(stoa_list_price,margin_rate);
					if(eval(price) < 200) {
						price = kepGetRound2(price, 1);
					}else{
						price = kepGetFloor2(price, 1);								
					}					
					
			} else if($("#st_buyer").val() =="KRSAMS0123"||$("#st_buyer").val() =="KRSAMS0192"){
				   // 삼성  금액별 계산방법
				  
				   var unit_price = stoa_list_price*margin_rate; //매출단가 구하는 공식
				 
				   // 고정매입 수수료율에 따라 반올림 처리
				   if( unit_price<= 22){
					   price =  kepGetFloor2(unit_price,1);//소수점 첫째자리 절삭 처리
				   }else{
					   if(st_margin_rate <= 3 ){//수수료율 3이하일때 올림처리
						   price = Math.ceil(unit_price);						   
					   }else if(st_margin_rate > 3 && st_margin_rate < 4.5){//3.1~4.4 소수점 첫째자리 반올림
						   price =  kepGetRound2(unit_price,1);
					   }else if(st_margin_rate >= 4.5 ){//4.5 이상일때 소수점 첫째자리 버림 처리
						   price =  kepGetFloor2(unit_price,1);//소수점 첫째자리 절삭 처리
					   }
				   }
				   
				  rate = kepGetRound2( ((price-stoa_list_price)/stoa_list_price*100),3);			  
				  
				  if(mySheet2.GetCellValue(i, "AGENT_CHECK") == 1) {
					  //최종 수수료율 체크 로직.
	 			      if(rate < 3){
				    	var agentName = mySheet2.GetCellValue(i, "AGENT_NAME");
				    	alert(agentName+"는 고정 매입 수수료율은"+kepGetRound2(rate,4)+"이며, 3% 미만건 입니다.\n 고정 매입 수수료율 수정 바랍니다.");
				    	$('#st_margin_rate').val("");
				    	return;
				      }
				     if(rate > 4.5){
				    	var agentName = mySheet2.GetCellValue(i, "AGENT_NAME");
				    	alert(agentName+"는 고정 매입 수수료율은"+kepGetRound2(rate,4)+"이며, 4.5% 초과건 입니다.\n 고정 매입 수수료율 수정 바랍니다.");
				    	$('#st_margin_rate').val("");
				    	return;
				      }
				  }
			} else if($("#st_buyer").val() =="KRHSDE0003"){
					   // 두산엔진  금액별 계산방법
				   price= doSum(stoa_list_price,margin_rate);		   
				   price = kepGetFloor2(price, 1);				   
				   
			} else {
				if(st_round_flag == "D"){ // 버림 , R 반올림
					atob_temp = eval(stoa_list_price * (1 + (st_margin_rate / 100)));

					if (atob_temp.toString().indexOf(".") == -1){
						price = kepGetFloor2(atob_temp,st_decimal_flag);
					} else {
						atob_unit_price = atob_temp.toString().substring(0,atob_temp.toString().indexOf("."),st_decimal_flag2);
						price = kepGetFloor2(atob_unit_price,st_decimal_flag);
					}
// 					price = kepGetFloor2(eval(stoa_list_price * (1 + (st_margin_rate / 100))).toFixed(st_decimal_flag2),st_decimal_flag);
				} else { // R 반올림					
					//price = kepGetRound2(eval(stoa_list_price * (1 + (st_margin_rate / 100))).toFixed(st_decimal_flag2),st_decimal_flag);
					price = kepGetRound2(eval(stoa_list_price * (1 + (st_margin_rate / 100))),st_decimal_flag);
				}
				
				
			}
			mySheet2.SetCellValue(i,"ATOB_UNIT_PRICE", price);
			if($("#st_buyer").val() =="KRSAMS0123"||$("#st_buyer").val() =="KRSAMS0192") { // 삼성전자,서비스만 rate로 표기, 나머지는 고정매입수수료율 표기
				mySheet2.SetCellValue(i,"RATE", rate);
			} else {
				mySheet2.SetCellValue(i,"RATE", st_margin_rate);
			}
			
		}
		
	} else { // S = 매출가 기준
		var rate = 0;
		for(var i=1; i<=totRow;i++){
			stoa_list_price = parseFloat(kepFilterNum(mySheet2.GetCellValue(i, "STOA_LIST_PRICE")));
			
			if ($("#st_buyer").val() == "KRDOOD0001" || $("#st_buyer").val() == "KRDOOS0004"){
				atob_unit_price = eval(stoa_list_price / (1 - (st_margin_rate / 100))).toFixed(st_decimal_flag2);
				if (eval(atob_unit_price) > 1000){
					price = Math.round(atob_unit_price*0.1)/0.1; // 1000원 초과일경우 반올림 계산식
				} else {
					price = Math.round(atob_unit_price*1)/1;  // 1000원 이하일경우 반올림 계산식
				}				
				
			} else if($("#st_buyer").val() =="KRDOOS0046"
				||$("#st_buyer").val() =="KRDHIM0001"|| $("#st_buyer").val() =="KRDAEW0043"
					||$("#st_buyer").val() =="KRDAEW0045"|| $("#st_buyer").val() =="KRDHIM0002"
					||$("#st_buyer").val() =="KRDHIM0003"|| $("#st_buyer").val() =="KRDHIM0005"
					||$("#st_buyer").val() =="KRDIGU0001"){
					   // 두산인프라코어 금액별 계산방법
						if(stoa_list_price*margin_rate > 999){
							price = kepGetFloor2(stoa_list_price*margin_rate,1);
						}else{
							price = kepGetRound2(stoa_list_price*margin_rate,1);
						}
						var atob_unit_price_len = String(price).length;
						
						if(eval(price) <= 999) {
							
							price = kepGetRound2(price, 1);
						}else if(eval(price) >= 1000 && eval(price) <= 999999){
							price = kepGetFloor2(price, -(atob_unit_price_len-5)).toFixed(0);
						}else if(eval(price) >= 1000000 && eval(price) <= 9999999999){
							price = kepGetFloor2(price, -(atob_unit_price_len-4)).toFixed(0);
						}						
						
		} else if($("#st_buyer").val() =="KRCOWA0001"|| $("#st_buyer").val() =="KRCOWA0002"
			||$("#st_buyer").val() =="KRCOWA0003"|| $("#st_buyer").val() =="KRCOWA0004"
			||$("#st_buyer").val() =="KRCOWA0005"|| $("#st_buyer").val() =="KRCOWA0006"
			||$("#st_buyer").val() =="KRCOWA0007"|| $("#st_buyer").val() =="KRCOWA0008"){
			   // 코웨이  금액별 계산방법
			   price = stoa_list_price*margin_rate;
				if(eval(price) < 20) {
					price = kepGetRound2(price, 2);
				}else if(eval(price) >= 20 && eval(price) < 1000){
					price = kepGetRound2(price, 1);								
				}else if(eval(price) >= 1000){
					price = kepGetRound2(price, 0);
				}				
				
		} else if($("#st_buyer").val() =="KRSAMS0140"){
			   // 삼성전기  금액별 계산방법
			   price = doSum(stoa_list_price,margin_rate);
				if(eval(price) < 200) {
					price = kepGetRound2(price,1);
				}else{
					price = kepGetFloor2(price, 1);								
				}				
				
		} else if($("#st_buyer").val() =="KRSAMS0123"||$("#st_buyer").val() =="KRSAMS0192"){
			   // 삼성  금액별 계산방법
			   var unit_price = stoa_list_price*margin_rate; //매출단가 구하는 공식
			   // 고정매입 수수료율에 따라 반올림 처리
			   if( unit_price<= 22){
				   price =  kepGetFloor2(unit_price,1);//소수점 첫째자리 절삭 처리
			   }else{
				   if(st_margin_rate <= 3 ){//수수료율 3이하일때 올림처리
					   price = Math.ceil(unit_price);						   
				   }else if(st_margin_rate > 3 && st_margin_rate < 4.5){//3.1~4.4 소수점 첫째자리 반올림
					   price =  kepGetRound2(unit_price,1);
				   }else if(st_margin_rate >= 4.5 ){//4.5 이상일때 소수점 첫째자리 버림 처리
					   price =  kepGetFloor2(unit_price,1);//소수점 첫째자리 절삭 처리
				   }
			   }
			  rate = kepGetRound2( ((price-stoa_list_price)/price*100),3);
			  //최종 수수료율 체크 로직.
			  if(mySheet2.GetCellValue(i, "AGENT_CHECK") == 1) {
			      if(rate < 3){
			    	var agentName = mySheet2.GetCellValue(i, "AGENT_NAME");
			    	alert(agentName+"는 고정 매입 수수료율은"+rate+"이며, 3% 미만건 입니다.\n 고정 매입 수수료율 수정 바랍니다.");
			    	$('#st_margin_rate').val("");
			    	return;
			     }
			     if(rate > 4.5){
			    	var agentName = mySheet2.GetCellValue(i, "AGENT_NAME");
			    	alert(agentName+"는 고정 매입 수수료율은"+rate+"이며, 4.5% 초과건 입니다.\n 고정 매입 수수료율 수정 바랍니다.");
			    	$('#st_margin_rate').val("");
			    	return;
			     }
			  }
		} else if($("#st_buyer").val() =="KRHSDE0003"){
			   // 두산엔진  금액별 계산방법
			   price= doSum(stoa_list_price,margin_rate);		   
			   price = kepGetFloor2(price, 1);			   
			   
		} else if($('#st_buyer').val() == "KRKOLO0112"||$('#st_buyer').val() == "KRKOLO0099"
			||$('#st_buyer').val() == "KRKOLO0106"||$('#st_buyer').val() == "KRKOLO0107"
				||$('#st_buyer').val() == "KRKOLO0108"||$('#st_buyer').val() == "KRKOLO0111"
				||$('#st_buyer').val() == "KRKOLO0110"||$('#st_buyer').val() == "KRKOLO0109"
				||$('#st_buyer').val() == "KRKOLO0113"){//코오롱인더 매출기준 단가 셋팅
			//매출기준
			price= doSumB(stoa_list_price,st_margin_rate);
			if(eval(price) < 100) {
				price = kepGetRound2(price, 3);								
			}else if(eval(price) >= 100){
				price = kepGetRound2(price, 1);
			}			
			
		} else {
				if(st_round_flag == "D"){ // 버림 , R 반올림
					atob_temp = eval(stoa_list_price / (1 - (st_margin_rate / 100)));
					if (atob_temp.toString().indexOf(".") == -1){
						price = kepGetFloor2(atob_temp,st_decimal_flag);
					} else {
						atob_unit_price = atob_temp.toString().substring(0,atob_temp.toString().indexOf("."),st_decimal_flag2);
						price = kepGetFloor2(atob_unit_price,st_decimal_flag);
					}
// 					price = kepGetFloor2(eval(stoa_list_price / (1 - (st_margin_rate / 100))).toFixed(st_decimal_flag2),st_decimal_flag);
				} else { // R 반올림
					//price = kepGetRound2(eval(stoa_list_price / (1 - (eval(st_margin_rate) / 100))).toFixed(st_decimal_flag2),st_decimal_flag);
					price = kepGetRound2(eval(stoa_list_price /  (1 - (st_margin_rate / 100))),st_decimal_flag);
				}				
			}
			mySheet2.SetCellValue(i,"ATOB_UNIT_PRICE", price);
			if($("#st_buyer").val() =="KRSAMS0123"||$("#st_buyer").val() =="KRSAMS0192") { // 삼성전자,서비스만 rate로 표기, 나머지는 고정매입수수료율 표기
				mySheet2.SetCellValue(i,"RATE", rate);
			} else {
				mySheet2.SetCellValue(i,"RATE", st_margin_rate);
			}
		}
	}
	//SLOGIC-END
}
//매익율계산(매출기준)
function doSumB(list_amt, margin_rate){
	var strTmp = "";
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mprq/getBuyerSumB.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param1: list_amt,param2: margin_rate},
	     async : false,
	     success:function( response ) {  		    	  
	    	 	 		    	  
	  	 	if (response.data.length > 0){
			    	  for (var i=0; i<response.data.length; i++){ 
			    		var D_SUM = $.trim(eval("response.data["+i+"].D_SUM")); 
			    		strTmp = D_SUM;
		 		      }	 		
	  		  }else{
	  			  strTmp = "";
	  		  }   	  
  		
	      },
	 error:function( response ) {  		    	   
    	 alert("오류발생하였습니다.");
	      }
  });  
  return strTmp;
}
//고정매입수수료율(매입기준)
function doSum(list_amt, margin_rate){
	var strTmp = "";
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mprq/getBuyerSum.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param1: list_amt,param2: margin_rate},
	     async : false,
	     success:function( response ) {  		    	  
	    	 	 		    	  
	  	 	if (response.data.length > 0){
			    	  for (var i=0; i<response.data.length; i++){ 
			    		var D_SUM = $.trim(eval("response.data["+i+"].D_SUM")); 
			    		strTmp = D_SUM;
		 		      }	 		
	  		  }else{
	  			  strTmp = "";
	  		  }   	  
  		
	      },
	 error:function( response ) {  		    	   
    	 alert("오류발생하였습니다.");
	      }
  });  
  return strTmp;
}
function doPop(str) {
	switch (str){
	case "file":
		popupSel = "fileUpload";
		var type="RFQ";
		var viewType="VI";
		var image_key=$('#st_image_key').val();
// 		if (image_key != "") {
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
// 		}
		break;
	case "process": // 거래유형
		//전략소싱팀 담당건 진행 불가.
		if($('#st_sg_gbn').val() == "SO"){
			if($('#st_sg_kep_yn').val() == "Y"){
				alert("사업팀만 처리 가능합니다.");
				return;
			}
		}
		popupSel = "commonCoCoGoodsDlvyClssifyPop";
		var st_buyer_code = $("#st_buyer").val();
		openSearchPopup("/coco/getCommonCoCoGoodsDlvyClssifyPop.do?st_buyer_code="+st_buyer_code+"&st_gubun=RQ",'',"500,200,no");
		break;
	case "below": // 적용구분
		//전략소싱팀 담당건 진행 불가.
		if($('#st_sg_gbn').val() == "SO"){
			if($('#st_sg_kep_yn').val() == "Y"){
				alert("사업팀만 처리 가능합니다.");
				return;
			}
		}
		var buyer_item_no = mySheet.GetCellValue(1, "BUYER_ITEM_NO");
		popupSel = "commonCoCoBottomOrgCodePop";
		openSearchPopup("/coco/getCommonCoCoBottomOrgCodePop.do",'?&st_buyer='+"${param.st_buyer}"+'&st_buyer_item_no='+buyer_item_no+'&st_gubun=RQ',"500,250,no");
		break;
	case "bidSucessCode": // 업체선정사유
		popupSel = "masterMpRqSouringBidSucessCodePop";
//		openSearchPopup("/mprq/showMasterMpRqSouringBidSucessCodePop.do",'',"500,360,no");

		var selectedGrid = mySheet2.FindCheckedRow("AGENT_CHECK");
		var arrRow = selectedGrid.split("|");
		var st_agent = mySheet2.GetCellValue(arrRow[0], "AGENT");
		var st_buyer = $('#st_buyer').val();
		
		openSearchPopup("/mprq/showMasterMpRqSouringBidExceptReasonPop.do",'?st_buyer='+st_buyer+'&st_agent='+st_agent,"500,380,no");
		
		break;
	case "soloAgentRemark": // 단독입찰 사유
		popupSel = "soloAgentRemark";
//		var st_sol_agent_remark = mySheet2.GetCellValue(1, "BID_SUCCESS_REASON");
		openSearchPopup("/common/remarkSoloAngetPop.do",'',"550,300,no");
		break;
	case "offPrint": // 오프라인 출력물
		//SLOGIC-BEGIN(P04-4031-51)
		var fileName = "";
		if ("${param.st_buyer}" == "KRDAEW0023"){
			fileName = "RD_04_M_001_02";
		} else if ("${param.st_buyer}" == "KRYUHA0011" || "${param.st_buyer}" == "KRYUHA0013" || "${param.st_buyer}" == "KRYUHA0019"){
			fileName = "RD_04_M_001_05";
		} else {
			fileName = "RD_04_M_001_03";
		}
		var selectedGrid = mySheet2.FindCheckedRow("AGENT_CHECK");
		var arrRow = selectedGrid.split("|");
		
		if (mySheet2.RowCount() == 0){
			alert("행이 없습니다.");
			return;
			
		}
		if (selectedGrid.length == 0){
			alert("선택된 항목이 없습니다.");
			return;
		}	
		
		var target_price = mySheet2.GetCellValue(arrRow[0], "ATOB_UNIT_PRICE");
		var price_profit = eval(target_price) - eval(parseFloat(kepFilterNum(mySheet2.GetCellValue(arrRow[0], "STOA_LIST_PRICE")))); 
		var price_rate = mySheet2.GetCellValue(arrRow[0], "RATE");
		var tot_price = eval(parseFloat(kepFilterNum(mySheet2.GetCellValue(arrRow[0], "STOA_LIST_PRICE")))) * eval(mySheet.GetCellValue(1, "ITEM_QTY"));
		var agent = mySheet2.GetCellValue(arrRow[0], "AGENT");
		
		var param =  "["+"${sessionInfo.userId}"+"]["+"${param.st_buyer}"+"]["+"${param.st_quotation_no}"+"]["+"${param.st_quotation_seq}"+"]["+"${param.st_revision}"+"]["+agent+"]["+price_profit+"]["+target_price+"]["+price_rate+"]["+tot_price+"]";
		reportOpen(fileName,param);
		break;
		//SLOGIC-END
	}
}
</script>
<title>코리아 e 플랫폼</title>
</head>

<body onload="kep_onload_view();">
<!--조회영역-->
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="1000">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">	
	<input type="hidden" id="st_buyer"  name="st_buyer" value="${param.st_buyer}">	
	<input type="hidden" id="st_quotation_no"  name="st_quotation_no" value="${param.st_quotation_no}">	
	<input type="hidden" id="st_quotation_seq"  name="st_quotation_seq" value="${param.st_quotation_seq}">
	<input type="hidden" id="st_sg_kep_yn"  name="sg_kep_yn" value="${param.st_sg_kep_yn}">
	<input type="hidden" id="st_sg_gbn"  name="sg_gbn" value="${param.st_sg_gbn}">	
	<input type="hidden" id="st_revision"  name="st_revision" value="${param.st_revision}">	
	<input type="hidden" id="st_rcv_agent_flag"  name="st_rcv_agent_flag" value="${param.st_rcv_agent_flag}">
	<input type="hidden" id="st_sour_dept_yn"  name="st_sour_dept_yn" value="${param.st_sour_dept_yn}">
	<input type="hidden" id="st_sg_id"  name="st_sg_id" value="${param.st_sg_id}">	
	<input type="hidden" id="st_logi_buyer_rate"  name="st_logi_buyer_rate" value="">	
	<input type="hidden" id="st_process_import_rate"  name="st_process_import_rate" value="">	
	<input type="hidden" id="st_logi_rate"  name="st_logi_rate" value="">	
	<input type="hidden" id="st_bid_success_code"  name="st_bid_success_code" value="">	
	<input type="hidden" id="st_bid_success_reason"  name="st_bid_success_reason" value="">	
	<input type="hidden" id="st_contract_flag"  name="st_contract_flag" value="">	
	<input type="hidden" id="st_margin_rate_org"  name="st_margin_rate_org" value="">
	<input type="hidden" id="st_img_type"  name=st_img_type value="">
	<input type="hidden" id="st_imgfile_dir"  name="st_imgfile_dir" value="">
	<input type="hidden" id="st_imgfile_name"  name="st_imgfile_name" value="">
	<input type="hidden" id="st_rqdt_tax_type"  name="st_rqdt_tax_type" value="">
	<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
	<input type="hidden" id="st_early_end_flag" name="st_early_end_flag" />
	<input type="hidden" id="st_item_make_type"  name="st_item_make_type" value="">
	<input type="hidden" id="st_pre_gr_user_name"  name="st_pre_gr_user_name" value="">
	<input type="hidden" id="st_pre_gr_dept_name"  name="st_pre_gr_dept_name" value="">
	<input type="hidden" id="st_agent_choice_seq"  name="st_agent_choice_seq" value="">
	<input type="hidden" id="st_rqdt_origin_code"  name="st_rqdt_origin_code" value="">
	<input type="hidden" id="st_online_price"  name="st_online_price" value="">
	<input type="hidden" id="st_online_price_reason"  name="st_online_price_reason" value="">
	<!-- 500*350 -->
	<div id="popWrapper" style="height:828px;">
    	<div id="popHeader">
        	<h1 class="title">협력사선정</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
		<!--팝업내용입니다-->
        <div id="popContainer" style="height:422px;">
        	<!--데이타그리드-->
        	<table class="cont_t_list06">
            	<caption>리스트</caption>
                <colgroup>
                    <col width="53px" />
                    <col width="13%" />
                    <col width="43px" />
                    <col width="11%" />
                    <col width="45px" />
                    <col width="9%" />
                    <col width="55px" />
                    <col width="9%" />
                    <col width="72px" />
                    <col width="12%" />
                </colgroup>
                <tbody>
                    <tr>
                      <th>고객사</th>
                      <td id="st_buyer_name"></td>
                      <th>마감일시</th>
                      <td id="st_atos_end_date">
                      </td>
                      <th>표준매익률</th>
                      <td id="st_buyer_rate">
                      <th>안전인증서상태</th>
                      <td>
                      		<input type="hidden" id="st_import_flag" name="st_import_flag" value="N">
                      		<input type="hidden" id="st_old_safety_flag" name="st_old_safety_flag" />
                      		<select id="st_safety_flag" name="st_safety_flag" style="width:70px;height:20px">
								<%= CommonUtil.getCodeComboList("M160", "","", "", "", "") %>
                      		</select>
                      </td>
                      <th>선입고견적여부/첨부파일</th>
                      <td>
                      		<input type="checkbox" class="input_type_text"  id="ck_pre_gr_flag" name="ck_pre_gr_flag" />
                      		&nbsp;/&nbsp;
                      		<a href="javascript:doPop('file');"><img src="/resources/images/disk_off.gif" id="st_image_1" name="st_image_1" alt="첨부파일" /></a>
                      		<input type="hidden" id="st_image_key" name="st_image_key" />
                      		<input type="hidden" id="st_pre_gr_flag" name="st_pre_gr_flag" />
                      		<span class="btn_gray_02"><a href="javascript:doAction('save')">저장</a></span>
                      </td>
                    </tr>
                    <tr>
                      <th>견적작성자</th>
                      <td id="st_btoa_user_name">
                      <th>의뢰번호</th>
                      <td id="st_quotation_noseq">
                      <th>거래유형</th>
                      <td>
                      	<a href="javascript:doPop('process');"><input type="text" class="input_blue_text"  id="st_process_name" name="st_process_name" style="width:80%;" readonly="readonly" /></a>
                      	<input type="hidden" id="st_process_type" name="st_process_type" />
                      	<input type="hidden" id="st_warehouse_code" name="st_warehouse_code" />
                      	<input type="hidden" id="st_admin_close_flag" name="st_admin_close_flag" />
                      	<input type="hidden" id="st_admin_close_flag2" name="st_admin_close_flag2" />
                      	<input type="hidden" id="st_end_time_flag" name="st_end_time_flag" />
                      	<input type="hidden" id="st_buyer_rate_gubun" name="st_buyer_rate_gubun" />
                      	<input type="hidden" id="st_logistics_fee" name="st_logistics_fee" />
                      	<input type="hidden" id="st_after_item_md_complete" name="st_after_item_md_complete" />
                      </td>
                      <th>적용구분</th>
                      <td>
                      	<a href="javascript:doPop('below');"><input type="text" class="input_blue_text"  id="st_below_comorg_name" name="st_below_comorg_name" style="width:80%;" readonly="readonly" /></a>
                      	<input type="hidden" id="st_below_comorg_code" name="st_below_comorg_code" />
                      </td>
                      <th><input type="text" class="input_blue_text"  id="st_rate_text" name="st_rate_text" style="width:110%;border:0px solid #fff;background-color:transparent;font-weight:bold;letter-spacing:-1px;font-family:돋움;font-size:12px;" readonly="readonly" /></th>
                      <td>
                      		<input type="text" class="input_type_text"  id="st_margin_rate" name="st_margin_rate" style="width:30px;" onChange="javascript:Adapt();" />
                      		<select id="st_round_flag" name="st_round_flag" style="width:60px;height:20px" onChange="javascript:Adapt();">
								<option value="R" selected>반올림</option>
								<option value="D" >버림</option>
                      		</select>
                      		<select id="st_decimal_flag" name="st_decimal_flag" style="width:60px;height:20px" onChange="javascript:Adapt();">
									<option value="-6" <%=(getDecimalFlag.equals("-6") ? "selected" : "")%>>10000000</option>
									<option value="-5" <%=(getDecimalFlag.equals("-5") ? "selected" : "")%>>1000000</option>
									<option value="-4" <%=(getDecimalFlag.equals("-4") ? "selected" : "")%>>100000</option>
									<option value="-3" <%=(getDecimalFlag.equals("-3") ? "selected" : "")%>>10000</option>
									<option value="-2" <%=(getDecimalFlag.equals("-2") ? "selected" : "")%>>1000</option>
									<option value="-1" <%=(getDecimalFlag.equals("-1") ? "selected" : "")%>>100</option>
									<option value="0" <%=(getDecimalFlag.equals("0") ? "selected" : "")%>>10</option>
									<option value="1" <%=(getDecimalFlag.equals("1") ? "selected" : (getDecimalFlag.equals("") ? "selected" : ""))%>>0</option>
									<option value="2" <%=(getDecimalFlag.equals("2") ? "selected" : "")%>>0.1</option>
									<option value="3" <%=(getDecimalFlag.equals("3") ? "selected" : "")%>>0.01</option>
									<option value="4" <%=(getDecimalFlag.equals("4") ? "selected" : "")%>>0.001</option>
                      		</select>
                      </td>
                    </tr>
                </tbody>
            </table>
            
            <div id="div_re_note">
				<div style="text-align:right;line-height:25px" > 
					<span class="text11" style="float:left">
					- 운영특이사항 -
					&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;
					&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
					- 선정 전 확인사항 -
					</span>
					<span class="btn_06" style="height:28px;"><a href="javaScript:doAction('add_note');">운영특이사항 입력</a></span>
					<span class="btn_search"><a href="javaScript:doAction('searchHead');">조회</a></span>
				</div>
				
				<div style="border-top:2px solid #3c639c;width:100%;">
	  				<div style="float:left; width:500px;">
		  				<script type="text/javascript">
		  					createIBSheet("mySheet3", "100%", "210px");
		  				</script>
	  				</div>
	  				
	  				<textarea id="st_dss_re_note" name="st_dss_re_note" style="width:65%;" rows="15" readonly><%=getCodeASRMText%></textarea>
  				</div>
  			</div>
  			
  			<br>
  			
        	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "70px");
				</script>
			</div>
			
        	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet2", "", "208px");
				</script>
			</div>
			<p class="paging" id="pageindex"></p>
			<!--버튼영역-->
	        <div class="mt10 mr25" style="height:25px;">
				<span class="fl">
					<span class="btn_07 ml20"><a href="javascript:doPop('offPrint')">오프라인견적서출력</a></span>
				</span>
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:doAction('close')">견적마감</a></span>
					<span class="btn_05 mr04"><a href="javascript:doAction('round')">추가라운드요청</a></span>
					<span class="btn_02"><a href="javascript:doAction('bid');">확인</a></span>
				</span>
	        </div>
		</div>
		
    </div>
	</form>
		
</body>
</html>
