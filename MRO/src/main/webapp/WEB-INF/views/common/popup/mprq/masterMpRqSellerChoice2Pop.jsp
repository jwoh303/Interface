<%--
**********************************************
* 메뉴 : 
* 화면 : 협력사선정-일괄제출용
* 기능 : 견적번호에 해당하는 모든 견적건에 대해서 매출단가를 셋팅하고 협력사를 선정하여 고객사에 일괄제출한다.
* 프로그램 ID : PG_04_M_007_05
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-06-24
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
	SessionInfo _session = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String st_user_dept = _session.getDepartment();
	String st_user_id = _session.getUserId();
	//소싱부서 여부
	String st_sour_dept_yn = "";
	boolean st_sour_dept = CommonUtil.getCodeCheckReturn("SOURDEPT",st_user_dept);
	//중앙소싱 구매팀 전담고객사 사용자 여부
	boolean st_sour_user_id = CommonUtil.getCodeCheckReturn("CMDSM",st_user_id);
	if(st_sour_dept == true){
		st_sour_dept_yn = "Y";
	}else{
		if(st_sour_user_id == true){
			st_sour_dept_yn = "Y";
		}else{
			st_sour_dept_yn = "N";	
		}
	}
	// 고객사별 제출가능 단가범위 (P04-4041-09) SQL
%>
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

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var cb_tax_type = KepSheetComboData("TX17","");
    var tax_type = {ComboCode: cb_tax_type.ComboCode, ComboText: cb_tax_type.ComboText};
       
	var productGbn = KepSheetComboData("M132","SEL");
	var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};

	var bidCode = KepSheetComboQueryIdData("common.getBidSucessCode", "SPACE", "");
	var initsheet2 = {};
	initsheet2.HeaderMode = {Sort : 0,ColMove : 1,ColResize : 1};
	initsheet2.Cfg = {MergeSheet:msPrevColumnMerge + msHeaderOnly, FrozenCol : 11,PrevColumnMergeMode:1};
	initsheet2.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1,ColMerge:0}
	      			, {Align : "Center",SaveName : "QUOTATION_SEQ2",		Header : "견적순번", Type : "Text",Width : 50, EditLen : 110,	Edit : false, Hidden : true}
	      			, {Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 25,	EditLen : 50,Hidden:false}
	    			, {Align : "Center",SaveName : "QUOTATION_SEQ",		Header : "견적순번", Type : "Text",Width : 50, EditLen : 110,	Edit : false, Hidden : false}
	    			, {Align : "Right",SaveName : "BUYER_TARGET_PRICE",		Header : "목표(고)", Type : "Float",	 Format:"${priceFormat}",Width : 50, EditLen : 110,	Edit : false, Hidden : false}
	    			, {Align : "Right",SaveName : "ADMIN_TARGET_PRICE",		Header : "목표(운)", Type : "Float",	 Format:"${priceFormat}",	Width : 50, EditLen : 110,	Edit : false, Hidden : false}
	    			, {Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 70,	EditLen : 110,Hidden:false, Edit : false, Wrap:true}
	    			, {Align : "Left",SaveName : "DESCR_SPEC",		Header : "품목명\n/규격",	Type : "Text",	Width : 70, EditLen : 110,	Edit : false, Hidden : false, Wrap:true}
	    			, {Align : "Right",SaveName : "ITEM_QTY_UNIT",		Header : "수량\n/단위",	Type:"Text",	Width : 35, EditLen : 110,	Edit : false, Hidden : false, Wrap:true}
	    			, {Align : "Center",SaveName : "RQ_MAKER_ORIGIN_NAME",		Header : "제조사\n/원산지",	Type : "Text",	Width : 50, EditLen : 110,	Edit : false, Hidden : false, Wrap:true}
	    			, {Align : "Center",SaveName : "ITEM_MAKE_TYPE",		Header : "품목구분",	Type : "Combo",	Width : 120,	EditLen : 120,	Edit : true, Hidden:false}
	    			, {Align:"Center",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",ComboText:"운영사|협력사|운영사(미완성)",ComboCode:"M|S|N",	Header:"이미지구분",	SaveName:"RFQ_IMG_TYPE"}
	    			, {Align : "Center",	SaveName : "RFQ_IMG_FLAG",			Header : "이미지필수",		Type : "Text",				Width : 60,		EditLen : 110,	Edit : false, Hidden : false}
	    			, {Align : "Center",	SaveName : "IMGFILE_NAME_IMG",		Header : "이미지첨부(M)",		Type : "Image",			Width : 70,		EditLen : 100,	Edit : false,	Hidden : false}
	    			, {Align : "Center",	SaveName : "RQDT_AGENT_NAME",			Header : "기존협력사",		Type : "Text",				Width : 100,		EditLen : 110,	Edit : false, Hidden : false}
	    			, {Align : "Center",	SaveName : "ASSIGN_AGENT_CODE",			Header : "지정협력사",		Type : "Text",				Width : 100,		EditLen : 110,	Edit : false, Hidden : true}
	    			, {Align : "Center",	SaveName : "ASSIGN_AGENT_NAME",			Header : "지정협력사",		Type : "Text",				Width : 100,		EditLen : 110,	Edit : false, Hidden : false}
	    			,{Align : "Center",	SaveName : "TAX_TYPE",			Header : "과세구분",	Type : "Combo",	Width : 60,	EditLen : 100,	Edit : true,	Hidden : false}
	    			, {Align : "Center",SaveName : "SELECTED2",	Header : "",	Type : "DummyCheck",	Width : 25,	EditLen : 50,Hidden:false,ColMerge:0}
	    			, {Align : "Center",SaveName : "NO",	Header : "NO",	Type : "Seq",	Width : 30,	EditLen : 50,Hidden:false, ColMerge:0}
	    			, {Align : "Center",SaveName : "SOURCING_STATUS",		Header : "상태",	Type : "Text",	Width : 50, EditLen : 110,	Edit : false, Hidden : false, Wrap:true,ColMerge:0}
	    			, {Align : "Center",SaveName : "AGENT_CHECK",	Header : "협력사명",	Type : "DummyCheck",	RadioIcon: 1, Width : 20,	EditLen : 50,Edit:true,Hidden:false,ColMerge:0, HeaderCheck:0}
	    			, {Align : "Center",SaveName : "SELECTED_F",	Header : "협력사명",	Type : "DummyCheck",	Width : 20,	EditLen : 50,Hidden:true,ColMerge:0}
	    			, {Align : "Left",SaveName : "AGENT_NAME",		Header : "협력사명",	Type : "Text",	Width : 110, EditLen : 110,	Edit : false, Hidden : false, Wrap:true,ColMerge:0}
	    			, {Align : "Center",SaveName : "ORIGIN_NAME",		Header : "원산지",	Type : "Text",	Width : 60, EditLen : 110,	Edit : false, Hidden : false,ColMerge:0}
	    			, {Align : "Center",SaveName : "ORIGIN_CODE",		Header : "원산지",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : true,ColMerge:0}
	    			, {Align : "Center",SaveName : "MAKER_CODE",		Header : "제조사",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : true,ColMerge:0}
	    			, {Align : "Center",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 70, EditLen : 110,	Edit : false, Hidden : false,ColMerge:0}
	    			, {Align : "Right",SaveName : "ITEM_QTY",		Header : "수량",	Type : "Float",  Format:"${qtyFormat}",	Width : 35, EditLen : 110,	Edit : false, Hidden : true, ColMerge:0}
	    			, {Align : "Right",SaveName : "LEAD_TIME",		Header : "조달일수", Type:"Int",	Format:"${qtyFormat}", Width : 50, EditLen : 110,	Edit : false, Hidden : false,ColMerge:0}
	    			, {Align : "Right",SaveName : "STOA_LIST_PRICE",		Header : "매입단가", Type : "Text",	 Width : 70, EditLen : 60,	Edit : false, Hidden : false,ColMerge:0}
					, {Align : "Center",SaveName : "IMPORT_FLAG",		Header : "수입여부",	Type : "Combo",	ComboText:"N|Y", ComboCode:"N|Y",	Width :50, EditLen : 110,	Edit : true, Hidden : false,ColMerge:0}
					, {Align : "Center",SaveName : "QTDT_PROCESS_NM",		Header : "협력사\n거래유형",	Type : "Text",	Width : 60, EditLen : 110,	Edit : false, Hidden : false,ColMerge:0}
					, {Align : "Center",SaveName : "PROCESS_NAME",		Header : "거래유형",	Type : "Text",	Width : 60, EditLen : 110,	Edit : false, Hidden : false,ColMerge:0}
					, {Align : "Center",SaveName : "PROCESS_TYPE",		Header : "거래유형",	Type : "Text",	Width : 60, EditLen : 110,	Edit : false, Hidden : true,ColMerge:0}
					, {Align : "Center",SaveName : "BELOW_COMORG_CODE",		Header : "적용구분",	Type : "Text",	Width : 60, EditLen : 110,	Edit : false, Hidden : true,ColMerge:0}
					, {Align : "Center",SaveName : "BELOW_COMORG_NAME",		Header : "적용구분",	Type : "Text",	Width : 60, EditLen : 110,	Edit : false, Hidden : false,ColMerge:0}
	    			, {Align : "Right",SaveName : "ATOB_UNIT_PRICE",		Header : "판매단가", Type : "Float",	 Format:"${priceFormat}",	Width : 60, EditLen : 110,	Edit : false, Hidden : false,ColMerge:0}
	    			, {Align : "Right",SaveName : "RATE",		Header : "매익(%)",	Type : "Float",	 Format:"${priceFormat}", Width : 50, EditLen : 110,	Edit : false, Hidden : false,ColMerge:0}
	    			, {Align : "Center",SaveName : "STOA_REMARK_IMG",		Header : "비고",	Type : "Image",	Width : 40, EditLen : 110,	Edit : false, Hidden : false,ColMerge:0}
	    			, {Align : "Center",SaveName : "STOA_REMARK",		Header : "비고",	Type : "Text",	Width : 40,	EditLen : 110,	Edit : false, Hidden:true,ColMerge:0}
	    			, {Align : "Center",SaveName : "ATOS_REMARK",		Header : "비고",	Type : "Text",	Width : 40,	EditLen : 110,	Edit : false, Hidden:true,ColMerge:0}
	    			, {Align : "Center",	SaveName : "IMGFILE_DIR",			Header : "이미지경로",		Type : "Text",				Width : 60,		EditLen : 110,	Edit : false, Hidden : true,ColMerge:0}
	    			, {Align : "Center",	SaveName : "IMGFILE_NAME",			Header : "이미지파일",		Type : "Text",				Width : 60,		EditLen : 110,	Edit : false, Hidden : true,ColMerge:0}
	    			, {Align : "Center",	SaveName : "QTDT_IMGFILE_NAME_IMG",		Header : "이미지첨부(S)",		Type : "Image",			Width : 80,		EditLen : 100,	Edit : false,	Hidden : false,ColMerge:0}
	    			, {Align : "Center",	SaveName : "QTDT_IMGFILE_DIR",			Header : "이미지경로",		Type : "Text",				Width : 60,		EditLen : 110,	Edit : false, Hidden : true,ColMerge:0}
	    			, {Align : "Center",	SaveName : "QTDT_IMGFILE_NAME",			Header : "이미지파일",		Type : "Text",				Width : 60,		EditLen : 110,	Edit : false, Hidden : true,ColMerge:0}
	    			, {Align : "Center",	SaveName : "ATOA_REMARK_IMG",	Header : "운영사비고",	Type : "Image",	Width : 70,	EditLen : 100,	Edit : false,	Hidden : false,	ColMerge:0}
	    			, {Align : "Center",	SaveName : "ATOA_REMARK",	Header : "운영사비고",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden : true,	ColMerge:0}
	    			, {Align : "Center",SaveName : "SELLER_IMAGE_KEY_IMG",		Header : "첨부",	Type : "Image",	Width : 40,	EditLen : 110,	Edit : false,ColMerge:0}
	    			, {Align : "Center",SaveName : "SELLER_IMAGE_KEY",		Header : "첨부",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true,ColMerge:0}
	    			, {Align : "Center",SaveName : "BID_CODE",		Header : "선정사유",	Type : "Combo", ComboText:bidCode.ComboText, ComboCode:bidCode.ComboCode,	Width : 60,	EditLen : 110,	Edit : true, Hidden:false,ColMerge:0,Wrap:true}
	    			, {Align : "Center",SaveName : "AGENT_CHOICE_REQ_DEPT",		Header : "요청부서",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:false,ColMerge:0,Wrap:true}
	    			, {Align : "Center",SaveName : "AGENT_CHOICE_REQ_USER",		Header : "요청자",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:false,ColMerge:0,Wrap:true}
	    			, {Align : "Center",SaveName : "BID_REMARK",		Header : "기타사유",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:false,ColMerge:0,Wrap:true}
	    			, {Align : "Center",SaveName : "END_TIME_FLAG",		Header : "END_TIME_FLAG",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true,ColMerge:0}
	    			, {Align : "Center",SaveName : "SEND_FLAG",		Header : "SEND_FLAG",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true,ColMerge:0}
	    			, {Align : "Center",SaveName : "WAREHOUSE_CODE",		Header : "WAREHOUSE_CODE",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true,ColMerge:0}
	    			, {Align : "Center",SaveName : "AGENT",		Header : "AGENT",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true,ColMerge:0}
	    			, {Align : "Center",SaveName : "RFQ_KEP_USER",		Header : "RFQ_KEP_USER",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true,ColMerge:0}
	    			, {Align : "Center",SaveName : "AGENT_REVISION",		Header : "AGENT_REVISION",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true,ColMerge:0}
	    			, {Align : "Center",SaveName : "AGENT_CK",		Header : "AGENT_CK",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true,ColMerge:0}
	    			, {Align : "Center",SaveName : "AGENT_MIN_PRICE",		Header : "AGENT_MIN_PRICE",	Type : "Float",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true,ColMerge:0}
	    			,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"신용등급평가",	SaveName:"DSS_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"신용등급메시지",	SaveName:"DSS_MSG"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"DSS_CHOICE",	SaveName:"DSS_CHOICE"}
	    			,{Align : "Center",SaveName : "SG_GBN",		Header : "SG_GBN",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true}
	    			,{Align : "Center",SaveName : "SG_KEP_YN",		Header : "SG_KEP_YN",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true}
	    			,{Align : "Right",SaveName : "MIN_ORDER_QTY",	Header : "MOQ",		Type : "Int",	Format:"${qtyFormat}",	Width : 50,	EditLen : 10,	Edit : true, Hidden:false, ColMerge:0}
	    			,{Align : "Right",SaveName : "PUR_UNIT_QTY",		Header : "발주배수",	Type : "Int",	Format:"${qtyFormat}",	Width : 60,	EditLen : 10,	Edit : true, Hidden:false, ColMerge:0}
	    			,{Align : "Center",SaveName : "SELLER_AREA_IMG",	Header : "납품지역",	Type : "Image",	Width : 60,	EditLen : 110,	Edit : false, ColMerge:0}
	    			,{Align : "Center",SaveName : "SELLER_AREA",		Header : "납품지역",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true, ColMerge:0}
	    			,{Align : "Center",SaveName : "PROCESS_NM",		Header : "거래유형",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:false, ColMerge:0}
	    			,{Align : "Center",SaveName : "AGENT_ITEM_MAKE_TYPE",	Header : "품목구분",	Type : "Combo",	Width : 120,	EditLen : 110,	Edit : false, Hidden:false, ColMerge:0}
	    			,{Align : "Center",SaveName : "QTDT_TAX_TYPE",	Header : "과세구분",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:false, ColMerge:0}
	    			,{Align : "Center",SaveName : "QTDT_TAX_TYPE_CODE",	Header : "과세구분코드",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true, ColMerge:0}
	    			, {Align : "Center",SaveName : "SOL_AGENT_YN",		Header : "SOL_AGENT_YN",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true,ColMerge:0}
	    			, {Align : "Center",SaveName : "PLANT",		Header : "PLANT",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true,ColMerge:0}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제출단가\n확인여부",	SaveName:"UNIT_PRICE_CHECK_FLAG"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제출가능\n최저단가",	SaveName:"MIN_UNIT_PRICE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제출가능\n최고단가",	SaveName:"MAX_UNIT_PRICE"}
	    			
	];

	IBS_InitSheet2(mySheet2, initsheet2,pagingMode,9);
	
	mySheet2.SetColProperty("TAX_TYPE", tax_type);
	mySheet2.SetColProperty("ITEM_MAKE_TYPE", comboInfo);
	mySheet2.SetColProperty("AGENT_ITEM_MAKE_TYPE", comboInfo);
	
	mySheet2.SetCountPosition(4);
	mySheet2.SetAutoRowHeight(1);

	//하이퍼링크 설정
	if ($('#st_buyer_code').val() == "KRDOOD0001"){
		setLinkCol(mySheet2, "MAKER_NAME");
		mySheet2.SetCellFontUnderline(0, "ORIGIN_NAME", true);	
		mySheet2.SetCellFontUnderline(0, "MAKER_NAME", true);	
		setLinkCol(mySheet2, "ORIGIN_NAME");
		setLinkCol(mySheet2, "MAKER_NAME");
	}
	setLinkCol(mySheet2, "PROCESS_NAME");
	setLinkCol(mySheet2, "BELOW_COMORG_NAME");
	setLinkCol(mySheet2, "STOA_REMARK_IMG");
	setLinkCol(mySheet2, "SELLER_IMAGE_KEY_IMG");
	setLinkCol(mySheet2, "SELLER_AREA_IMG");
	setLinkCol(mySheet2, "ATOA_REMARK_IMG");
	setLinkCol(mySheet2, "IMGFILE_NAME_IMG");
	setLinkCol(mySheet2, "QTDT_IMGFILE_NAME_IMG");
	
	mySheet2.SetImageList(1, remarkOn);
	mySheet2.SetImageList(0, remarkOff);
	mySheet2.SetImageList(3, diskOn);
	mySheet2.SetImageList(2, diskOff);
	mySheet2.SetImageList(5, areaOn);
	mySheet2.SetImageList(4, areaOff);
	
	mySheet2.SetCellFontUnderline(0, "PROCESS_NAME", true);
	mySheet2.SetCellFontUnderline(0, "BELOW_COMORG_NAME", true);
	mySheet2.SetCellFontUnderline(0, "BID_CODE", true);
	
	HdQuery();
	kepSearch(document.searchCondition ,  mySheet2 , "/mprq/getMasterMpRqSellerChoice2Detail.do" , pagingMode );
	//SLOGIC-BEGIN(P04-4031-12)
	if ($('#st_buyer_code').val() == "KRDOOD0001"){
		$('#prt1').show();
	} else {
		$('#prt1').hide();
	}
	if ($('#st_buyer_code').val() == "KRDOOS0046"
			||$('#st_buyer_code').val() == "KRDHIM0001"||$('#st_buyer_code').val() == "KRDAEW0043"
			||$('#st_buyer_code').val() == "KRDAEW0045"||$('#st_buyer_code').val() == "KRDHIM0002"
			||$('#st_buyer_code').val() == "KRDHIM0003"||$('#st_buyer_code').val() == "KRDHIM0005"
			||$('#st_buyer_code').val() == "KRDIGU0001"
			||$('#st_buyer_code').val() == "KRCOWA0001"||$('#st_buyer_code').val() == "KRCOWA0002"
			||$('#st_buyer_code').val() == "KRCOWA0003"||$('#st_buyer_code').val() == "KRCOWA0004"
			||$('#st_buyer_code').val() == "KRCOWA0005"||$('#st_buyer_code').val() == "KRCOWA0006"
			||$('#st_buyer_code').val() == "KRCOWA0007"||$('#st_buyer_code').val() == "KRCOWA0008"
			||$("#st_buyer_code").val() == "KRKEPB0004"||$('#st_buyer_code').val() == "KRHSDE0003"
			||$('#st_buyer_code').val() == "KRKOLO0112"||$('#st_buyer_code').val() == "KRKOLO0099"
			||$('#st_buyer_code').val() == "KRKOLO0106"||$('#st_buyer_code').val() == "KRKOLO0107"
			||$('#st_buyer_code').val() == "KRKOLO0108"||$('#st_buyer_code').val() == "KRKOLO0111"
			||$('#st_buyer_code').val() == "KRKOLO0110"||$('#st_buyer_code').val() == "KRKOLO0109"
			||$('#st_buyer_code').val() == "KRKOLO0113"||$('#st_buyer_code').val() == "KRSAMS0123"
			||$('#st_buyer_code').val() == "KRSAMS0140"||$('#st_buyer_code').val() == "KRSAMS0192"
			)
	{
		$('#st_round_flag').hide();
		$('#st_decimal_flag').hide();		
	}else{
		$('#st_round_flag').show();
		$('#st_decimal_flag').show();
	}
	//SLOGIC-END
}

function HdQuery(){
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mprq/getMasterMpRqSellerChoice2PopHd.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { st_buyer_code: $("#st_buyer_code").val(),st_quotation_no: $("#st_quotation_no").val(),st_revision: $("#st_revision").val(),st_sour_dept_yn: $("#st_sour_dept_yn").val()},
	     async : false,
	     success:function( response ) {
		    	 if (response.data.length > 0){
		    		$("#st_qno").text('${param.st_quotation_no}');
		    		$("#st_buyer_name").text($.trim(eval("response.data[0].BUYER_NAME")));
		    		$("#st_buyer_name2").val($.trim(eval("response.data[0].BUYER_NAME")));
		    		$("#st_btoa_user_name").text($.trim(eval("response.data[0].BTOA_USER_NAME")));
		    		$("#st_btoa_user_tel").text($.trim(eval("response.data[0].BTOA_USER_TEL")));
		    		$("#st_buyer_rate_gubun").val($.trim(eval("response.data[0].BUYER_RATE_GUBUN")));
		    		$("#st_catalog_com_code").val($.trim(eval("response.data[0].CATLG_CODE")));
		    		$("#st_buyer_rate").val($.trim(eval("response.data[0].BUYER_RATE")));
		    		$("#st_margin_rate").val($.trim(eval("response.data[0].FEE_RATE")));
		    		
		    		var buyerRateEdit = $.trim(eval("response.data[0].BUYER_RATE_EDIT"));
		    		//RATE 타이틀변경
		    		if($.trim(eval("response.data[0].BUYER_RATE_GUBUN"))=="B"){
		    			$("#st_rate_text").val("고정매입수수료율");	
		    		}else{
		    			$("#st_rate_text").val("매익율");
		    		}
		    		if (buyerRateEdit == "N"){
		    			$("#st_margin_rate").attr("disabled", true);
		    		}
		    	 }
		      },
		 error:function( response ) {  		    	   
	    	 alert("오류발생하였습니다.");
		      }	
	 }); 
}

var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "ReAgentSelect": // 추가라운드요청
			if(kepIsValueNull($('#st_atos_end_date').val())){
				alert("견적마감일을 입력하여 주세요.");
				break;
			}
		
			var atos_end_rtn_result = getAtosEndAndRtnCheck('RE_ORDER'); 		// 마감여부 체크
			if(!atos_end_rtn_result) break;
			var atos_re_round = getAtosEndAndRtnCheck('RE_ROUND');		// 추가라운드요청 사업팀 권한 체크
			if(!atos_re_round) break;
			//협력사 추가할 협력사기준
			var selectedGrid = mySheet2.FindCheckedRow("SELECTED2");
			if (selectedGrid.length == 0){
				alert("협력사를 선택하여 주십시요.");
				return;
			}
			kepSave(document.searchCondition ,  mySheet2 , "/mprq/saveReAgentSelect.do" , "SELECTED2" );
			
			break;
		case "bid": // 확인
			if(kepIsValueNull($('#st_margin_rate').val())) {
				alert("매익율을 입력하여 주십시요.");
				$('#st_margin_rate').focus();
				break;
			}

			if(!kepIsNumChk('st_margin_rate',2)) {
				
				alert("매익율(숫자형식)을 입력하여 주십시요.");
				$("#st_margin_rate").val("");
				$('#st_margin_rate').focus();
				break;
			}	
		
			var atos_end_rtn_result = getAtosEndAndRtnCheck('SAVE');		// 마감여부 및 회신여부 체크
			if(!atos_end_rtn_result)  return;
			
			
			if(!getAgentPickupList()) return;
			
			//품목구분이 없는 경우 체크(공백인 경우)
			var selectedGrid = mySheet2.FindCheckedRow("SELECTED_F");
			var arrRow = selectedGrid.split("|");

			for(var i = 1; i<=arrRow.length; i++){
				if(mySheet2.GetCellValue(arrRow[i-1], "ITEM_MAKE_TYPE") == ""){
					alert("품목구분을 선택하여 주십시요.");
					mySheet2.SelectCell(arrRow[i-1], "ITEM_MAKE_TYPE");
					return;
				}
				
				if(mySheet2.GetCellValue(arrRow[i-1], "ASSIGN_AGENT_CODE") != ""){
					if(mySheet2.GetCellValue(arrRow[i-1], "ASSIGN_AGENT_CODE") != mySheet2.GetCellValue(arrRow[i], "AGENT") && mySheet2.GetCellValue(arrRow[i-1], "AGENT_CHECK") == 1){
						alert("지정협력사( " + mySheet2.GetCellValue(arrRow[i-1], "ASSIGN_AGENT_NAME") + " )가 아닙니다.");
						mySheet2.SelectCell(arrRow[i-1], "ASSIGN_AGENT_NAME");
						return;
					}
				}
				
				// 제출가능 단가 범위
				if(mySheet2.GetCellValue(arrRow[i-1],"UNIT_PRICE_CHECK_FLAG") == "Y" && mySheet2.GetCellValue(arrRow[i-1], "AGENT_CHECK") == 1){
					if(mySheet2.GetCellValue(arrRow[i-1],"MIN_UNIT_PRICE") >= mySheet2.GetCellValue(arrRow[i-1],"ATOB_UNIT_PRICE")){
						alert("해당 고객사의 최저단가는 " + mySheet2.GetCellValue(arrRow[i-1],"MIN_UNIT_PRICE") + " 원 이하 제출 불가합니다.");
						mySheet2.SelectCell(arrRow[i-1], "ATOB_UNIT_PRICE");
						return;
					}
					if(mySheet2.GetCellValue(arrRow[i-1],"MAX_UNIT_PRICE") <= mySheet2.GetCellValue(arrRow[i-1],"ATOB_UNIT_PRICE")){
						alert("해당 고객사의 최고단가는 " + mySheet2.GetCellValue(arrRow[i-1],"MAX_UNIT_PRICE") + " 원 이상 제출 불가합니다.");
						mySheet2.SelectCell(arrRow[i-1], "ATOB_UNIT_PRICE");
						return;
					}
				}
				
				if(mySheet2.GetCellValue(arrRow[i-1], "TAX_TYPE") != mySheet2.GetCellValue(arrRow[i-1], "QTDT_TAX_TYPE_CODE") && mySheet2.GetCellValue(arrRow[i-1], "AGENT_CHECK") == 1){
					alert(mySheet2.GetCellValue(arrRow[i-1], "TAX_TYPE"));
					alert(mySheet2.GetCellValue(arrRow[i-1], "QTDT_TAX_TYPE_CODE"));
					mySheet2.SelectCell(arrRow[i-1], "QTDT_TAX_TYPE");
					alert("KEP견적의 과세구분이 협력사가 제출한 과세구분과 불일치합니다.\n제출 전 꼭 확인하시기 바랍니다.\n진행 시 KEP견적의 과세구분으로 등록됩니다.");
				}
			}
			
			if(confirm("저장하시겠습니까?")) {
				
				kepSave(document.searchCondition ,  mySheet2 , "/mprq/saveAllAgentSel.do" , "SELECTED_F" );
			}
			break;
	}

}
//협력사 지정, 판매단가 및 매익율 저장
function getAgentPickupList(){
	var selectedGrid = mySheet2.FindCheckedRow("SELECTED_F");
	var arrRow = selectedGrid.split("|");
	if(selectedGrid.length ==0) {
        alert("저장할 견적품목을 선택하여 주십시요.");
        return false;
    }
	var selAgentCnt = 0;
	var errBuyerItem = "";
	
	var moq_use_flag = "<%=moq_use_flag%>";
	var area_use_flag = "<%=area_use_flag%>";
	
	for (var i=0; i<arrRow.length; i++){
		var sgKepYn = mySheet2.GetCellValue(arrRow[i], "SG_KEP_YN");
		var sgGbn = mySheet2.GetCellValue(arrRow[i], "SG_GBN");
		var min_order_qty = mySheet2.GetCellValue(arrRow[i], "MIN_ORDER_QTY");
		var pur_unit_qty = mySheet2.GetCellValue(arrRow[i], "PUR_UNIT_QTY");
		var seller_area = mySheet2.GetCellValue(arrRow[i], "SELLER_AREA");
		
		if(sgGbn =="SO"){
			//전략소싱팀
			if(sgKepYn =="Y"){
				// 목표단가 및 공급사 차수 확인 후 진행 여부 확인한다.
				/*
				if(eval(mySheet2.GetCellValue(arrRow[i], "BUYER_TARGET_PRICE")) == 0 && eval(mySheet2.GetCellValue(arrRow[i], "ADMIN_TARGET_PRICE")) == 0 && mySheet2.GetCellValue(i, "AGENT_REVISION") == 1 ) {
					alert("목표단가(고), 목표단가(운) 값이 없을 경우\n1차수에 협력사 선정할 수 없습니다.\n추가라운드를 진행하시기 바랍니다.");
					return false;
				}
				*/
				for (var j=0; j<arrRow.length; j++) {
					if (mySheet2.GetCellValue(arrRow[i], "QUOTATION_SEQ") == mySheet2.GetCellValue(arrRow[j], "QUOTATION_SEQ")){
						if (mySheet2.GetCellValue(arrRow[j], "AGENT_CHECK") == 1){
							selAgentCnt++;
						}
					} 
				}
				if (mySheet2.GetCellValue(arrRow[i], "AGENT_CHECK") == 1) { 
					if (parseFloat(kepFilterNum(mySheet2.GetCellValue(arrRow[i], "STOA_LIST_PRICE"))) == 0){
						alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 매입단가 0원이므로 협력사 선정 할 수 없습니다.");
						return false;
					}
					if (kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "BID_CODE"))){
						alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 업체선정사유를 입력하여 주십시오.");
						return false;
					} else if (mySheet2.GetCellValue(arrRow[i], "BID_CODE") == 'BS09' && kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "BID_REMARK"))){
						alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 단독입찰 상세사유를 입력 해야합니다.");
						mySheet2.SelectCell(arrRow[i], "BID_REMARK");
						return false;
					} else if (mySheet2.GetCellValue(arrRow[i], "BID_CODE") == 'BS08' && kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "BID_REMARK"))){
						alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 선정사유가 기타이면 비고를 입력 해야합니다.");
						return false;
					} else if ((mySheet2.GetCellValue(arrRow[i], "BID_CODE") == 'BS11' || mySheet2.GetCellValue(arrRow[i], "BID_CODE") == 'BS12')
							&& kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "AGENT_CHOICE_REQ_DEPT"))
							&& kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "AGENT_CHOICE_REQ_USER"))){
						alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 선정사유는 요청부서, 요청자 입력 해야합니다.");
						return false;
					} else if ((mySheet2.GetCellValue(arrRow[i], "BID_CODE") != 'BS11' && mySheet2.GetCellValue(arrRow[i], "BID_CODE") != 'BS12')){
						var bid_remark = mySheet2.GetCellValue(arrRow[i], "BID_REMARK");
						
						if(bid_remark.length < 20){
							alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 선정사유는 기타사유를 10자 이상 입력 해야합니다.");
							return false;	
						}
					}				
				}
			//사업팀
			}else{
				selAgentCnt = arrRow.length;
				if (mySheet2.GetCellValue(arrRow[i], "AGENT_CHECK") == 1) { 
					if(kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "PROCESS_TYPE"))) {
						alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 거래유형을 입력하여 주십시요.");
						return false;
					}		
					if(kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "BELOW_COMORG_CODE"))) {
						alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 적용구분을 입력하여 주십시요.");
						return false;
					}
					if(kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "MAKER_NAME"))) {
						alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 제조사를 입력하여 주십시요.");
						return false;
					}
					
					if ($('#st_buyer_code').val() == "KRDOOD0001") {
						if(kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "ORIGIN_CODE")) || kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "ORIGIN_NAME"))) {
							alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 원산지를 입력하여 주십시요.");
							return false;
						}
					}
				}
			}
		}else{
			if (mySheet2.GetCellValue(arrRow[i], "RFQ_KEP_USER").indexOf("${sessionInfo.userId}") == -1){
			<%
				if(st_sour_user_id != true){ // 전담고객사 담당자는 선정담당자가 아니라도 진행 가능하도록
			%>
					alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째는 협력사 선정 담당자가 아닙니다.");
					return false;
			<%
				}
			%>
			}
			// 목표단가 및 공급사 차수 확인 후 진행 여부 확인한다.
			/*
			if(eval(mySheet2.GetCellValue(arrRow[i], "BUYER_TARGET_PRICE")) == 0 && eval(mySheet2.GetCellValue(arrRow[i], "ADMIN_TARGET_PRICE")) == 0 && mySheet2.GetCellValue(i, "AGENT_REVISION") == 1 ) {
				alert("목표단가(고), 목표단가(운) 값이 없을 경우\n1차수에 협력사 선정할 수 없습니다.\n추가라운드를 진행하시기 바랍니다.");
				return false;
			}
*/
			for (var j=0; j<arrRow.length; j++) {
				if (mySheet2.GetCellValue(arrRow[i], "QUOTATION_SEQ") == mySheet2.GetCellValue(arrRow[j], "QUOTATION_SEQ")){
					if (mySheet2.GetCellValue(arrRow[j], "AGENT_CHECK") == 1){
						selAgentCnt++;
					}
				} 
			}
			if (arrRow.length != selAgentCnt){
				errBuyerItem = mySheet2.GetCellValue(arrRow[i], "QUOTATION_SEQ");
			}
				
			if (mySheet2.GetCellValue(arrRow[i], "AGENT_CHECK") == 1) { 
				if (parseFloat(kepFilterNum(mySheet2.GetCellValue(arrRow[i], "STOA_LIST_PRICE"))) == 0){
					alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 매입단가 0원이므로 협력사 선정 할 수 없습니다.");
					return false;
				}
				if(kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "PROCESS_TYPE"))) {
					alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 거래유형을 입력하여 주십시요.");
					return false;
				}		
				if(kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "BELOW_COMORG_CODE"))) {
					alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 적용구분을 입력하여 주십시요.");
					return false;
				}
				if(kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "MAKER_NAME"))) {
					alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 제조사를 입력하여 주십시요.");
					return false;
				}
				
				if ($('#st_buyer_code').val() == "KRDOOD0001") {
					if(kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "ORIGIN_CODE")) || kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "ORIGIN_NAME"))) {
						alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 원산지를 입력하여 주십시요.");
						return false;
					}
				}

				if (kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "BID_CODE"))){
					alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 업체선정사유를 입력하여 주십시오.");
					return false;
				} else if (mySheet2.GetCellValue(arrRow[i], "BID_CODE") == 'BS09' && kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "BID_REMARK"))){
					alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 단독입찰 상세사유를 입력 해야합니다.");
					mySheet2.SelectCell(arrRow[i], "BID_REMARK");
					return false;
				} else if (mySheet2.GetCellValue(arrRow[i], "BID_CODE") == 'BS08' && kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "BID_REMARK"))){
					alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 선정사유가 기타이면 비고를 입력 해야합니다.");
					return false;
				} else if ((mySheet2.GetCellValue(arrRow[i], "BID_CODE") == 'BS11' || mySheet2.GetCellValue(arrRow[i], "BID_CODE") == 'BS12')
						&& kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "AGENT_CHOICE_REQ_DEPT"))
						&& kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "AGENT_CHOICE_REQ_USER"))){
					alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 선정사유는 요청부서, 요청자를 입력 해야합니다.");
					return false;
				} else if ((mySheet2.GetCellValue(arrRow[i], "BID_CODE") != 'BS01' && mySheet2.GetCellValue(arrRow[i], "BID_CODE") != 'BS09' &&
						mySheet2.GetCellValue(arrRow[i], "BID_CODE") != 'BS11' && mySheet2.GetCellValue(arrRow[i], "BID_CODE") != 'BS12')){
					var bid_remark = mySheet2.GetCellValue(arrRow[i], "BID_REMARK");
					
					if(bid_remark.length < 20){
						alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째의 선정사유는 기타사유를 10자 이상 입력 해야합니다.");
						return false;	
					}					
				}
				if(moq_use_flag == "Y"){
					if(min_order_qty < 1 || kepIsValueNull(min_order_qty)){
						alert("MOQ(숫자형식)를 입력하세요.(최소값:1)");
						mySheet2.SelectCell(arrRow[i], "MIN_ORDER_QTY");
						return false;
					}
					if(pur_unit_qty < 1 || kepIsValueNull(pur_unit_qty)){
						alert("발주배수(숫자형식)를 입력하세요.(최소값:1)");
						mySheet2.SelectCell(arrRow[i], "PUR_UNIT_QTY");
						return false;
					}
				}
			}
		}


		
		if(area_use_flag == "Y"){
			if(kepIsValueNull(seller_area)){
				alert("납품지역을 선택하여 주십시요.");
				mySheet2.SelectCell(arrRow[i], "SELLER_AREA_IMG");
				return false;
			}
		}
	}
	
	if(selAgentCnt != arrRow.length){
		alert(errBuyerItem + " 품목의 협력사를 선택하여 주십시요.");
		return false;
	} 
	return true;
}
//트랜젝션(저장,삽입등) 후처리
function mySheet2_OnSaveEnd(code, msg) {
	loader_obj("N");
	if (msg != "") {
		alert(msg);
	}
	
	if(code>0){
// 		alert("1");
		opener.doAction('close');
// 		alert("2");
		self.close();
	}
}
//마감전 체크
function getAtosEndAndRtnCheck(mode) {
	var selectedGrid = "";
	var arrRow = "";
	var bFlag = true;
	if(mode=="SAVE") {
		selectedGrid = mySheet2.FindCheckedRow("SELECTED");
		arrRow = selectedGrid.split("|");
		
		for (var i=0; i<arrRow.length; i++){
			if (mySheet2.GetCellValue(arrRow[i], "END_TIME_FLAG") == "N" && mySheet2.GetCellValue(arrRow[i], "SEND_FLAG") == "N"){
				alert(mySheet2.GetCellValue(arrRow[i], "NO")+"번째는 마감전 견적회신 완료 되지 않았습니다.");
				bFlag = false;
				mySheet2.SetCellValue(arrRow[i], "SELECTED",0);
				break;
			}
		}	
	} else if(mode=="RE_ORDER") {
		selectedGrid = mySheet2.FindCheckedRow("SELECTED2");
		arrRow = selectedGrid.split("|");

		for (var i=0; i<arrRow.length; i++){
			if (mySheet2.GetCellValue(arrRow[i], "END_TIME_FLAG") == "N" && mySheet2.GetCellValue(arrRow[i], "SEND_FLAG") == "N"){
				alert("해당 품목은 마감전 견적회신 완료 되지 않았습니다.\n\n재견적 요청이 불가능합니다.");
				bFlag = false;
				mySheet2.SetCellValue(arrRow[i], "SELECTED2",0);
				break;
			}
		}	
	} else if(mode=="RE_ROUND") {
		selectedGrid = mySheet2.FindCheckedRow("SELECTED2");
		arrRow = selectedGrid.split("|");
		for (var i=0; i<arrRow.length; i++){
			if (mySheet2.GetCellValue(arrRow[i], "SG_KEP_YN") == "N" && mySheet2.GetCellValue(arrRow[i], "SG_GBN") == "SO"){
				var buyerItemNo = mySheet2.GetCellValue(arrRow[i], "BUYER_ITEM_NO");
				var quotationSeq = mySheet2.GetCellValue(arrRow[i], "QUOTATION_SEQ");
				alert("견적순번 "+quotationSeq+"("+ buyerItemNo+ ") 품목의 추가라운드 권한이 없습니다.");
				bFlag = false;
				mySheet2.SetCellValue(arrRow[i], "SELECTED2",0);
				break;
			}
		}	
	} else if(mode=="AGENT") {
		selectedGrid = mySheet2.FindCheckedRow("SELECTED2");
		arrRow = selectedGrid.split("|");
		for (var i=0; i<arrRow.length; i++){
			if (mySheet2.GetCellValue(arrRow[i], "SG_KEP_YN") == "N" && mySheet2.GetCellValue(arrRow[i], "SG_GBN") == "SO"){
				var buyerItemNo = mySheet2.GetCellValue(arrRow[i], "BUYER_ITEM_NO");
				var quotationSeq = mySheet2.GetCellValue(arrRow[i], "QUOTATION_SEQ");
				alert("견적순번 "+quotationSeq+"("+ buyerItemNo+ ") 품목의 협력사 선택의 권한이 없습니다.");
				bFlag = false;
				mySheet2.SetCellValue(arrRow[i], "SELECTED2",0);
				break;
			}
		}	
	}
	
	return bFlag;
}

function doPop(str) {
	var buyer = "${param.st_buyer}";
	var quotation_no = "${param.st_quotation_no}";
	var revision = "${param.st_revision}";
	switch (str){
	case "offPrint": // 오프라인 출력물
		//SLOGIC-BEGIN(P04-4031-12)
		var fileName = "RD_04_M_001_04";
		var agent_cnt = mySheet2.RowCount();
		if (agent_cnt == 0) return;
		
		var price_profit = "";
	    var target_price = 0;
	    var price_rate   = $('#st_margin_rate').val();
	    var tot_price    = 0;
		var quotation_seq = "";
		var seq_agent = "";
		var agent = "";
		var profit_temp = 0;
		
		var selectedGrid = mySheet2.FindCheckedRow("AGENT_CHECK"); // incheck
		var arrRow = selectedGrid.split("|");
		if (selectedGrid.length > 0) {
			for (var i=0; i<arrRow.length; i++){
				if (kepIsValueNull(mySheet2.GetCellValue(arrRow[i], "ATOB_UNIT_PRICE")) || mySheet2.GetCellValue(arrRow[i], "ATOB_UNIT_PRICE") < 1){
					alert(mySheet2.GetCellValue(arrRow[i], "NO") +"번째 판매단가가 입력되지 않았습니다. 다시 입력해 주시기 바랍니다.");
					return;
				}
				
				profit_temp = eval(mySheet2.GetCellValue(arrRow[i], "ATOB_UNIT_PRICE")) - eval(parseFloat(kepFilterNum(mySheet2.GetCellValue(arrRow[i], "STOA_LIST_PRICE"))));
				quotation_seq = quotation_seq + mySheet2.GetCellValue(arrRow[i], "QUOTATION_SEQ") + "@@";
				target_price = target_price + mySheet2.GetCellValue(arrRow[i], "ATOB_UNIT_PRICE") + "@@";
				price_profit = price_profit + profit_temp + "@@";
// 				price_rate = price_rate + mySheet2.GetCellValue(arrRow[i], "RATE") + "@@";
				tot_price = tot_price + eval(parseFloat(kepFilterNum(mySheet2.GetCellValue(arrRow[i], "STOA_LIST_PRICE")))) * eval(mySheet2.GetCellValue(arrRow[i], "ITEM_QTY"));
				agent = agent + mySheet2.GetCellValue(arrRow[i], "AGENT") + "@@";
				seq_agent = seq_agent + mySheet2.GetCellValue(arrRow[i], "QUOTATION_SEQ") + mySheet2.GetCellValue(arrRow[i], "AGENT") + "@@";
			}
		}
		//SLOGIC-END
		var param =  "["+$('#USER_ID').val()+"]["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+agent+"]["+price_profit+"]["+target_price+"]["+price_rate+"]["+tot_price+"]["+seq_agent+"]";
		reportOpen(fileName,param);
		break;
	case "calendarHour": // 견적마감일 선택
		popupSel = "calendarHour";
		openSearchPopup("/common/calendarAndHourPop.do",'',"300,300,no");
		break;
		
	case "remarkReturn2Pop"://운영사비고
		popupSel = "remarkReturn2Pop";
		openSearchPopup("/common/remarkReturn2Pop.do", "?st_return_remark="+$('#st_atos_remark').val(), "500,230,no");  // 고객사 비고
		break;
		
	case "setAgentView": // 협력사 선택
		var atos_agent = getAtosEndAndRtnCheck('AGENT');		// 추가라운드요청 사업팀 권한 체크
		if(!atos_agent) break;
		popupSel = "masterMpRqSellerChoice4Pop";
		openSearchPopup("/mprq/showMasterMpRqSellerChoice4Pop.do","?st_buyer="+buyer+"&st_quotation_no="+quotation_no+"&st_revision="+revision,"400,300,no");
		break;
		
	case "soloAgentRemark": // 단독입찰 사유
		popupSel = "soloAgentRemark";
		openSearchPopup("/common/remarkSoloAngetPop.do",'',"550,300,no");
		break;
	}
}
function mySheet2_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

//매익율 입력시 판매단가와 매익율 계산적용
function Adapt(){
	var st_margin_rate = $("#st_margin_rate").val();
	var st_round_flag = $('#st_round_flag').val();
	var st_decimal_flag = $('#st_decimal_flag').val();

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
		for(var i=1; i<=totRow;i++){
			stoa_list_price = parseFloat(kepFilterNum(mySheet2.GetCellValue(i, "STOA_LIST_PRICE")));
			if ($("#st_buyer_code").val() == "KRDOOD0001" || $("#st_buyer_code").val() == "KRDOOS0004"){
				atob_unit_price = eval(stoa_list_price * (1 + (st_margin_rate / 100))).toFixed(st_decimal_flag2);
				if (eval(atob_unit_price) > 1000){
					price = Math.round(atob_unit_price*0.1)/0.1; // 1000원 초과일경우 반올림 계산식
				} else {
					price = Math.round(atob_unit_price*1)/1;  // 1000원 이하일경우 반올림 계산식
				}
			} else if($("#st_buyer_code").val() =="KRDOOS0046"
				||$("#st_buyer_code").val() =="KRDHIM0001"|| $("#st_buyer_code").val() =="KRDAEW0043"
				||$("#st_buyer_code").val() =="KRDAEW0045"|| $("#st_buyer_code").val() =="KRDHIM0002"
				||$("#st_buyer_code").val() =="KRDHIM0003"|| $("#st_buyer_code").val() =="KRDHIM0005"
				||$("#st_buyer_code").val() =="KRDIGU0001"){
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
			} else if($("#st_buyer_code").val() =="KRCOWA0001"|| $("#st_buyer_code").val() =="KRCOWA0002"
				||$("#st_buyer_code").val() =="KRCOWA0003"|| $("#st_buyer_code").val() =="KRCOWA0004"
				||$("#st_buyer_code").val() =="KRCOWA0005"|| $("#st_buyer_code").val() =="KRCOWA0006"
				||$("#st_buyer_code").val() =="KRCOWA0007"|| $("#st_buyer_code").val() =="KRCOWA0008"){
				   // 코웨이  금액별 계산방법
				   price = stoa_list_price*margin_rate;
					if(eval(price) < 20) {
						price = kepGetRound2(price, 2);
					}else if(eval(price) >= 20 && eval(price) < 1000){
						price = kepGetRound2(price, 1);								
					}else if(eval(price) >= 1000){
						price = kepGetRound2(price, 0);
					}
			} else if($("#st_buyer_code").val() =="KRSAMS0140"){
				   // 삼성전기  금액별 계산방법
				   price = doSum(stoa_list_price,margin_rate);
					if(eval(price) < 200) {
						price = kepGetRound2(price,1);
					}else{
						price = kepGetFloor2(price, 1);								
					}	
			} else if($("#st_buyer_code").val() =="KRSAMS0123"||$("#st_buyer_code").val() =="KRSAMS0192"){
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
				  var rate = (price-stoa_list_price)/stoa_list_price*100;
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
			} else if($("#st_buyer_code").val() =="KRHSDE0003"){
				   // 두산엔진  금액별 계산방법
				   price= doSum(stoa_list_price,margin_rate);
				   price = kepGetFloor2(price, 1);
			}else{
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
			mySheet2.SetCellValue(i,"ATOB_UNIT_PRICE",price);
			mySheet2.SetCellValue(i,"RATE",st_margin_rate);
		}
		
	} else { // S = 매출가 기준
		for(var i=1; i<=totRow;i++){
			stoa_list_price = parseFloat(kepFilterNum(mySheet2.GetCellValue(i, "STOA_LIST_PRICE")));
			if ($("#st_buyer_code").val() == "KRDOOD0001" || $("#st_buyer_code").val() == "KRDOOS0004"){
				atob_unit_price = eval(stoa_list_price / (1 - (st_margin_rate / 100))).toFixed(st_decimal_flag2);
				if (eval(atob_unit_price) > 1000){
					price = Math.round(atob_unit_price*0.1)/0.1; // 1000원 초과일경우 반올림 계산식
				} else {
					price = Math.round(atob_unit_price*1)/1;  // 1000원 이하일경우 반올림 계산식
				}
			} else if($("#st_buyer_code").val() =="KRDOOS0046"
				||$("#st_buyer_code").val() =="KRDHIM0001"|| $("#st_buyer_code").val() =="KRDAEW0043"
				||$("#st_buyer_code").val() =="KRDAEW0045"|| $("#st_buyer_code").val() =="KRDHIM0002"
				||$("#st_buyer_code").val() =="KRDHIM0003"|| $("#st_buyer_code").val() =="KRDHIM0005"
				||$("#st_buyer_code").val() =="KRDIGU0001"){
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
			} else if($("#st_buyer_code").val() =="KRCOWA0001"|| $("#st_buyer_code").val() =="KRCOWA0002"
				||$("#st_buyer_code").val() =="KRCOWA0003"|| $("#st_buyer_code").val() =="KRCOWA0004"
				||$("#st_buyer_code").val() =="KRCOWA0005"|| $("#st_buyer_code").val() =="KRCOWA0006"
				||$("#st_buyer_code").val() =="KRCOWA0007"|| $("#st_buyer_code").val() =="KRCOWA0008"){
				   // 코웨이  금액별 계산방법
				   price = stoa_list_price*margin_rate;
					if(eval(price) < 20) {
						price = kepGetRound2(price, 2);
					}else if(eval(price) >= 20 && eval(price) < 1000){
						price = kepGetRound2(price, 1);								
					}else if(eval(price) >= 1000){
						price = kepGetRound2(price, 0);
					}
			} else if($("#st_buyer_code").val() =="KRHSDE0003"){
				   // 두산엔진  금액별 계산방법
				   price= doSum(stoa_list_price,margin_rate);
				   price = kepGetFloor2(price, 1);
			} else if($("#st_buyer_code").val() =="KRSAMS0140"){
				   // 삼성전기  금액별 계산방법
				   price = doSum(stoa_list_price,margin_rate);
					if(eval(price) < 200) {
						price = kepGetRound2(price,1);
					}else{
						price = kepGetFloor2(price, 1);								
					}	
			} else if($("#st_buyer_code").val() =="KRSAMS0123"||$("#st_buyer_code").val() =="KRSAMS0192"){
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
				  var rate = (price-stoa_list_price)/stoa_list_price*100;
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
			} else if($('#st_buyer_code').val() == "KRKOLO0112"||$('#st_buyer_code').val() == "KRKOLO0099"
				||$('#st_buyer_code').val() == "KRKOLO0106"||$('#st_buyer_code').val() == "KRKOLO0107"
					||$('#st_buyer_code').val() == "KRKOLO0108"||$('#st_buyer_code').val() == "KRKOLO0111"
					||$('#st_buyer_code').val() == "KRKOLO0110"||$('#st_buyer_code').val() == "KRKOLO0109"
					||$('#st_buyer_code').val() == "KRKOLO0113"||$("#st_buyer_code").val() =="KRKEPB0004"){//코오롱인더 매출기준 단가 셋팅
				//매출기준
				price=  eval(stoa_list_price / (1 - (st_margin_rate / 100)));
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
					price = kepGetRound2(eval(stoa_list_price / (1 - (eval(st_margin_rate) / 100))) , st_decimal_flag);
				}
			}
			mySheet2.SetCellValue(i,"ATOB_UNIT_PRICE",price);
			mySheet2.SetCellValue(i,"RATE",st_margin_rate);
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
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	
	var totRow = mySheet2.RowCount();
	if( totRow<= 0) return;
	var vCnt = 1;
	var baseValue = mySheet2.GetCellValue(1, "QUOTATION_SEQ");

	for(var i=1; i<=totRow;i++){
		mySheet2.SetCellValue(i,"SELECTED2",1);
		
// 		if (mySheet2.GetCellValue(i, "END_TIME_FLAG")== "N"){
// 			mySheet2.SetCellValue(i,"STOA_LIST_PRICE","***,***");
// 		} else {
// 			stoaListPrice = kepNumComma2(mySheet2.GetCellValue(i, "STOA_LIST_PRICE"));
// 			mySheet2.SetCellValue(i,"STOA_LIST_PRICE",stoaListPrice);
// 		}
		if (mySheet2.GetCellValue(i, "STOA_LIST_PRICE") == "***"){
			mySheet2.SetCellValue(i,"STOA_LIST_PRICE","***,***");
		} else {
			stoaListPrice = kepNumComma2(mySheet2.GetCellValue(i, "STOA_LIST_PRICE"));
			mySheet2.SetCellValue(i,"STOA_LIST_PRICE",stoaListPrice);
		}
		mySheet2.SetCellEditable(i, "BID_REMARK", 0);
		if (eval(parseFloat(kepFilterNum(mySheet2.GetCellValue(i, "STOA_LIST_PRICE")))) > 0) {
// 			if (eval(parseFloat(kepFilterNum(mySheet2.GetCellValue(i, "STOA_LIST_PRICE")))) ==  eval(mySheet2.GetCellValue(i, "AGENT_MIN_PRICE"))) {
			if (mySheet2.GetCellValue(i, "AGENT_CK") == "1"){
				mySheet2.SetCellValue(i, "AGENT_CHECK", "1");
				mySheet2.SetCellValue(i, "BID_CODE", "BS01");
				mySheet2.SetCellEditable(i, "BID_CODE", 0);
			}
			//단독입찰인경우 코드 자동 셋팅
			if (mySheet2.GetCellValue(i, "SOL_AGENT_YN") == "Y"){
				mySheet2.SetCellValue(i, "AGENT_CHECK", "1");
				mySheet2.SetCellValue(i, "BID_CODE", "BS09");
				mySheet2.SetCellEditable(i, "BID_CODE", 0);
				mySheet2.SetCellEditable(i, "BID_REMARK", 0);
			}
		}
		
		if ( baseValue== mySheet2.GetCellValue(i, "QUOTATION_SEQ")){
			if (vCnt %2 == 0){
				mySheet2.SetRowBackColor(i,'#EAEAEA');
			} else {
				mySheet2.SetRowBackColor(i,'#FFFFFF');
			}
		} else {
			baseValue = mySheet2.GetCellValue(i, "QUOTATION_SEQ");
			vCnt++;
			if (vCnt %2 == 0){
				mySheet2.SetRowBackColor(i,'#EAEAEA');
			} else {
				mySheet2.SetRowBackColor(i,'#FFFFFF');
			}
		}
		
		mySheet2.SetCellEditable(i, "BID_CODE", 0);
		
		
		mySheet2.SetToolTipText(i, "SELECTED2", "추가라운드대상여부");
		
	}
	
	if(!kepIsValueNull($('#st_margin_rate').val())) {
		Adapt();
	}
	
	//첫 조회때 품목구분이 공백일 경우 -> 선택되어져 있는 협력사의 품목구분으로 셋팅 
	for(var i = 1; i<=mySheet2.RowCount();i++){
		if(mySheet2.GetCellValue(i, "AGENT_CHECK") == 1){
			if(mySheet2.GetCellValue(i, "ITEM_MAKE_TYPE")== ""){
				var baseValue = mySheet2.GetCellValue(i, "QUOTATION_SEQ");
				for(var j=1; j<=mySheet2.RowCount(); j++){
					if (baseValue == mySheet2.GetCellValue(j, "QUOTATION_SEQ")){
						mySheet2.SetCellValue(j,"ITEM_MAKE_TYPE",mySheet2.GetCellValue(i, "AGENT_ITEM_MAKE_TYPE"));
					}
				}
			}	
		}
	}	
   	
}
//그리드 헤더 전체 체크박스 클릭 이벤트
function mySheet2_OnCheckAllEnd(Col, Value) {
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	if (column == "SELECTED" ){
		if (Value == 1){
			for (var i=1; i<=mySheet2.RowCount(); i++){
				mySheet2.SetCellValue(i, "SELECTED_F", "1");
			}
		} else {
			for (var i=1; i<=mySheet2.RowCount(); i++){
				mySheet2.SetCellValue(i, "SELECTED_F", "0");
			}
		}
	} 
}
//그리드 셀클릭 이벤트
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	grbRow = Row;
	if (column == "STOA_REMARK_IMG" ){ 
		popupSel = "remarkAtoS";
		var stoaRemark = mySheet2.GetCellValue(Row, "STOA_REMARK");
		var atosRemark = mySheet2.GetCellValue(Row, "ATOS_REMARK");
		if (stoaRemark != ""){
			openSearchPopup("/common/remarkAtoSPop.do", '?st_atos_remark='+atosRemark+'&st_stoa_remark='+stoaRemark+'&titleType=S'+'&viewType=R', "500,310,no");
		}
		
	}else if (column == "ATOA_REMARK_IMG" ){ 
		popupSel = "remarkAtoAPop";
		var st_buyer = "${param.st_buyer}";
		var st_quotation_no = "${param.st_quotation_no}";
		var st_quotation_seq = mySheet2.GetCellValue(Row, "QUOTATION_SEQ");
		var st_revision = "${param.st_revision}";
		var st_atoa_remark = mySheet2.GetCellValue(Row, "ATOA_REMARK");
		openSearchPopup("/common/remarkAtoAPop.do",'?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_atoa_remark='+st_atoa_remark,"500,200,no");// 운영사비고
	} else if (column == "SELLER_IMAGE_KEY_IMG" ){
		popupSel = "fileUpload";
		var type="RFQ";
		var viewType="R";
		var image_key=mySheet2.GetCellValue(Row, "SELLER_IMAGE_KEY");
		if (image_key != "") {
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
		}
	} else if (column == "MAKER_NAME" ){ // 제조사
		if ($('#st_buyer_code').val() != "KRDOOD0001") return;
		popupSel = "maker";
		openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
	
	} else if (column == "ORIGIN_NAME" ){ // 원산지
		if ($('#st_buyer_code').val() != "KRDOOD0001") return;
		popupSel = "country";
		openSearchPopup("/common/countryCodePop.do", "", "500,500,no"); 
	
	} else if (column == "PROCESS_NAME" ){ // 거래유형
		popupSel = "commonCoCoGoodsDlvyClssifyPop";
		var st_buyer_code = $("#st_buyer_code").val();
		var sgKepYn = mySheet2.GetCellValue(Row, "SG_KEP_YN");
		var sgGbn = mySheet2.GetCellValue(Row, "SG_GBN");
		//전략소싱팀 담당건 진행 불가.
		if(sgGbn == "SO"){
			if(sgKepYn == "Y"){
				alert("사업팀만 처리 가능합니다.");
				return;
			}
		}
		openSearchPopup("/coco/getCommonCoCoGoodsDlvyClssifyPop.do?st_buyer_code="+st_buyer_code+"&st_gubun=RQ",'',"500,200,no");
		
	} else if (column == "BELOW_COMORG_NAME" ){ // 적용구분
		popupSel = "commonCoCoBottomOrgCodePop";
		var buyer_item_no = mySheet2.GetCellValue(Row, "BUYER_ITEM_NO");
		var sgKepYn = mySheet2.GetCellValue(Row, "SG_KEP_YN");
		var sgGbn = mySheet2.GetCellValue(Row, "SG_GBN");
		//전략소싱팀 담당건 진행 불가.
		if(sgGbn == "SO"){
			if(sgKepYn == "Y"){
				alert("사업팀만 처리 가능합니다.");
				return;
			}
		}
		openSearchPopup("/coco/getCommonCoCoBottomOrgCodePop.do",'?&st_buyer='+"${param.st_buyer}"+'&st_buyer_item_no='+buyer_item_no+'&st_gubun=RQ',"500,250,no");

	} else if (column == "AGENT_CHECK" ){ // 협력사 선정
		var sgKepYn = mySheet2.GetCellValue(Row, "SG_KEP_YN");
		var sgGbn = mySheet2.GetCellValue(Row, "SG_GBN");
		var agentCheck = mySheet2.GetCellValue(Row, "AGENT_CHECK");
		if(sgGbn == "SO"){
			if(sgKepYn =="N"){
				alert("전략소싱팀담당 진행건이므로\n사업팀은 협력사 선정이 불가능 합니다.");
				if(agentCheck == "1"){
				 	mySheet2.SetCellValue(Row, "AGENT_CHECK", "0");
				}else{
					mySheet2.SetCellValue(Row, "AGENT_CHECK", "1");
				}
				return;
			}
		}
		Radiotie2(Row,mySheet2.GetCellValue(Row, "QUOTATION_SEQ"),Value);
	} else if (column == "SELECTED" ){
		var baseValue = mySheet2.GetCellValue(Row, "QUOTATION_SEQ");
		if (Value == 1){
			for (var i=1; i<=mySheet2.RowCount(); i++){
				if (baseValue == mySheet2.GetCellValue(i, "QUOTATION_SEQ")){
					mySheet2.SetCellValue(i, "SELECTED_F", "1");
				} 
			}
		} else {
			for (var i=1; i<=mySheet2.RowCount(); i++){
				if (baseValue == mySheet2.GetCellValue(i, "QUOTATION_SEQ")){
					mySheet2.SetCellValue(i, "SELECTED_F", "0");
				} 
			}
		}
	}else if(column == "SELLER_AREA_IMG"){
		popupSel = "deliAreaPop";
		var buyer = $('#st_buyer_code').val();
		var seller_area = mySheet2.GetCellValue(Row, "SELLER_AREA");
		var plant = mySheet2.GetCellValue(Row, "PLANT");
		openSearchPopup("/common/getDeliveryAreaPop.do", '?st_com_code='+buyer+'&st_area_list='+seller_area+'&mod_yn=Y&plant_code='+plant, "400,270,no");
	}else if(column == "IMGFILE_NAME_IMG"){
		popupSel = "addImgPop";
		var st_imgfile_dir = mySheet2.GetCellValue(Row, "IMGFILE_DIR");
		var st_imgfile_name = mySheet2.GetCellValue(Row, "IMGFILE_NAME");
		var st_buyer_item_no = mySheet2.GetCellValue(Row, "BUYER_ITEM_NO");
		var st_agent = document.searchCondition.USER_ID.value;
		var mod_yn = "Y"; //수정여부
		var st_type = "S"; //협력사일경우
		openSearchPopup("/common/addImagePop.do", '?st_agent='+st_agent+'&st_imgfile_dir='+st_imgfile_dir+'&st_imgfile_name='+st_imgfile_name+'&st_buyer_item_no='+st_buyer_item_no+'&mod_yn='+mod_yn+'&st_type='+st_type, "590,670,no");
	}else if(column == "QTDT_IMGFILE_NAME_IMG"){
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
	}else if(column == "AGENT_CHOICE_REQ_DEPT" || column == "AGENT_CHOICE_REQ_USER"){
		popupSel = "masterMpRqBuyerDesignAgentPop";
		
		var st_bid_code = mySheet2.GetCellValue(Row, "BID_CODE");
		
		if (st_bid_code == "BS12"){ // 고객사 지정 협력사
			var st_buyer = $("#st_buyer_code").val();
			var st_agent = mySheet2.GetCellValue(Row, "AGENT");
			openSearchPopup("/mprq/getMasterMpRqBuyerDesignAgentPop.do",'?st_buyer='+st_buyer+'&st_agent='+st_agent,"700,400,no");
		}
	}else if(column == "BID_REMARK" && mySheet2.GetCellValue(Row, "BID_CODE") == "BS09"){
		//단독입찰 팝업 호출
		doPop('soloAgentRemark');
	}
	return;
}
// 협력사 선택 
function Radiotie2(Row,baseValue,Value,flag) {
	if (Value == 0){
		mySheet2.SetCellValue(Row, "AGENT_CHECK",0);
		mySheet2.SetCellValue(Row, "BID_CODE", "");
		mySheet2.SetCellEditable(Row, "BID_CODE", 0);
		mySheet2.SetCellEditable(Row, "BID_REMARK", 0);
		return;
	}
	
	for (var i=1; i<=mySheet2.RowCount(); i++){
		if (baseValue == mySheet2.GetCellValue(i, "QUOTATION_SEQ")){
			mySheet2.SetCellValue(i, "AGENT_CHECK", 0);
			mySheet2.SetCellValue(i, "BID_CODE", "");
			mySheet2.SetCellValue(i, "BID_REMARK", "");
			mySheet2.SetCellEditable(i, "BID_CODE", 0);
			//선택한 협력사의 품목구분으로 셋팅하기
			mySheet2.SetCellValue(i,"ITEM_MAKE_TYPE",mySheet2.GetCellValue(Row, "AGENT_ITEM_MAKE_TYPE"));
		} 
	}
	mySheet2.SetCellValue(Row, "AGENT_CHECK", 1);
	mySheet2.SetCellEditable(Row, "BID_CODE", 0);
	mySheet2.SetCellEditable(Row, "BID_REMARK", 0);
	if (eval(parseFloat(kepFilterNum(mySheet2.GetCellValue(Row, "STOA_LIST_PRICE")))) > 0) {
		//단독입찰인경우
		if(mySheet2.GetCellValue(Row, "SOL_AGENT_YN")=="Y"){
			mySheet2.SetCellValue(Row, "BID_CODE", "BS09");
			mySheet2.SetCellEditable(Row, "BID_CODE", 0);
		//최저가업체일경우
		}else if (eval(parseFloat(kepFilterNum(mySheet2.GetCellValue(Row, "STOA_LIST_PRICE")))) ==  eval(mySheet2.GetCellValue(Row, "AGENT_MIN_PRICE"))) {
			mySheet2.SetCellValue(Row, "BID_CODE", "BS01");
			mySheet2.SetCellEditable(Row, "BID_CODE", 0);
		} else {
			if (flag != "N"){
				alert("선택하신 업체는 최저가 업체가 아닙니다\n\n계속하시겠습니까?");
			}
			mySheet2.SetCellEditable(Row, "BID_CODE", 1);
			mySheet2.SetCellEditable(Row, "BID_REMARK", 1);
		}
	}
}

function mySheet2_OnChange(Row, Col, Value, OldValue) {

	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	
	if(column == "ITEM_MAKE_TYPE"){ //품목구분 변경 할 때마다 같은 seq의 품목구분을 선택한 품목구분 값으로 셋팅
		var baseValue = mySheet2.GetCellValue(Row, "QUOTATION_SEQ");
		for (var i=1; i<=mySheet2.RowCount(); i++){
			if (baseValue == mySheet2.GetCellValue(i, "QUOTATION_SEQ")){
				mySheet2.SetCellValue(i,"ITEM_MAKE_TYPE",mySheet2.GetCellValue(Row, "ITEM_MAKE_TYPE"));
			} 
		}
	}
	if(column == "RFQ_IMG_TYPE"){ //이미지구분 변경 할 때마다 같은 seq의 이미지구분,imgfile_dir,imgfile_name을 선택한 값으로 셋팅
		var baseValue = mySheet2.GetCellValue(Row, "QUOTATION_SEQ");
		var st_rfq_img_type = mySheet2.GetCellValue(Row,"RFQ_IMG_TYPE");
		for (var i=1; i<=mySheet2.RowCount(); i++){
			if (baseValue == mySheet2.GetCellValue(i, "QUOTATION_SEQ")){
				mySheet2.SetCellValue(i,"RFQ_IMG_TYPE",mySheet2.GetCellValue(Row, "RFQ_IMG_TYPE"));
				if(st_rfq_img_type == "N"){ //운영사(미완성) 선택했을 경우
					mySheet2.SetCellValue(i,"IMGFILE_DIR","ITEM_IMAGE/S2017_2");
					mySheet2.SetCellValue(i,"IMGFILE_NAME","s_make.jpg");
				}else{
					mySheet2.SetCellValue(i,"IMGFILE_DIR","");
					mySheet2.SetCellValue(i,"IMGFILE_NAME","");
				}
			}
		}
	}
	if (column == "IMPORT_FLAG" ){ 
		// 수입여부 변경시 매출원가 재산정
// 		getBuyerPrimeCostRate(Row,mySheet2.GetCellValue(Row, "AGENT"));
	} else if (column == "BID_CODE" ){
		if (mySheet2.GetCellValue(Row, "BID_CODE")=="BS08"){
			mySheet2.SetCellEditable(Row, "BID_REMARK", 1);
		} else if (mySheet2.GetCellValue(Row, "BID_CODE")=="BS01"){
			if (eval(parseFloat(kepFilterNum(mySheet2.GetCellValue(Row, "STOA_LIST_PRICE")))) > 0) {
				if (eval(parseFloat(kepFilterNum(mySheet2.GetCellValue(Row, "STOA_LIST_PRICE")))) !=  eval(mySheet2.GetCellValue(Row, "AGENT_MIN_PRICE"))) {
					alert("선택하신 업체는 최저가 업체가 아닙니다\n\n선정사유를 다시 선택하십시오.");
					mySheet2.SetCellValue(Row, "BID_CODE", "");
					mySheet2.SetCellEditable(Row, "BID_REMARK", 0);
					return;
				}
			}
		} else if (mySheet2.GetCellValue(Row, "BID_CODE")=="BS09"){//단독입찰인경우
			if (eval(parseFloat(kepFilterNum(mySheet2.GetCellValue(Row, "STOA_LIST_PRICE")))) > 0) {
				if(mySheet2.GetCellValue(Row, "SOL_AGENT_YN") == "N"){
					alert("선택하신 업체는 단독입찰 업체가 아닙니다\n\n선정사유를 다시 선택하십시오.");
					mySheet2.SetCellValue(Row, "BID_CODE", "");
					mySheet2.SetCellEditable(Row, "BID_REMARK", 0);
					return;
				}else{
					mySheet2.SetCellEditable(Row, "BID_REMARK", 1);				
				}
			}
		} else if (mySheet2.GetCellValue(Row, "BID_CODE")=="BS11"){//선입고선진행 경우
			if (eval(parseFloat(kepFilterNum(mySheet2.GetCellValue(Row, "STOA_LIST_PRICE")))) > 0) {
				mySheet2.SetCellValue(Row, "BID_REMARK", "");
				mySheet2.SetCellEditable(Row, "BID_REMARK", 0);
				mySheet2.SetCellEditable(Row, "AGENT_CHOICE_REQ_DEPT", 1);
				mySheet2.SetCellEditable(Row, "AGENT_CHOICE_REQ_USER", 1);
			}
		} else if (mySheet2.GetCellValue(Row, "BID_CODE")=="BS12"){//고객지정협력사 경우
			if (eval(parseFloat(kepFilterNum(mySheet2.GetCellValue(Row, "STOA_LIST_PRICE")))) > 0) {
				mySheet2.SetCellValue(Row, "BID_REMARK", "");
				mySheet2.SetCellEditable(Row, "BID_REMARK", 0);
				mySheet2.SetCellEditable(Row, "AGENT_CHOICE_REQ_DEPT", 0);
				mySheet2.SetCellEditable(Row, "AGENT_CHOICE_REQ_USER", 0);
			}
		} else {
			mySheet2.SetCellValue(Row, "BID_REMARK", "");
			mySheet2.SetCellValue(Row, "AGENT_CHOICE_REQ_DEPT", "");
			mySheet2.SetCellValue(Row, "AGENT_CHOICE_REQ_USER", "");
			mySheet2.SetCellEditable(Row, "BID_REMARK", 1);
			mySheet2.SetCellEditable(Row, "AGENT_CHOICE_REQ_DEPT", 0);
			mySheet2.SetCellEditable(Row, "AGENT_CHOICE_REQ_USER", 0);
		}
	}
	return;
}
//헤더 더블클릭시 복사
function mySheet2_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	var selectedGrid = mySheet2.FindCheckedRow("AGENT_CHECK");
	var arrRow = selectedGrid.split("|");
	
// 	if (selectedGrid.length == 0) {
// 		alert("선택된 항목이 없습니다.");
// 		return;
// 	}
	if (mySheet2.ColSaveName(Col) == "BID_CODE"){ // 선정사유
		var value1 = mySheet2.GetCellValue(arrRow[0], "BID_CODE");
		var value2 = mySheet2.GetCellValue(arrRow[0], "BID_REMARK");
		
		if (value1 == "BS01"){
			return;
		}
		for (var i=1; i<=arrRow.length; i++){
			if (mySheet2.GetCellValue(arrRow[i], "BID_CODE") != "BS01"){
			mySheet2.SetCellValue(arrRow[i], "BID_CODE", value1);
			mySheet2.SetCellValue(arrRow[i], "BID_REMARK", value2);
			}
		}
		
		
	//SLOGIC-BEGIN(P04-4031-21)
	} else if (mySheet2.ColSaveName(Col) == "ORIGIN_NAME"){ // 원산지
		var value1 = mySheet2.GetCellValue(1, "ORIGIN_CODE");
		var value2 = mySheet2.GetCellValue(1, "ORIGIN_NAME");
		if(kepIsValueNull(value1)){
			alert("복사할 원산지를 선택하여 주십시요.");
			return;
		}
		for (var i=2; i<=mySheet2.RowCount(); i++){
			mySheet2.SetCellValue(i, "ORIGIN_CODE", value1);
			mySheet2.SetCellValue(i, "ORIGIN_NAME", value2);
		}
	//SLOGIC-END
	//SLOGIC-BEGIN(P04-4031-22)
	} else if (mySheet2.ColSaveName(Col) == "MAKER_NAME"){ // 제조사
		if ($('#st_buyer_code').val() != "KRDOOD0001") return;
		var value1 = mySheet2.GetCellValue(1, "MAKER_CODE");
		var value2 = mySheet2.GetCellValue(1, "MAKER_NAME");
		
		if(kepIsValueNull(value1)){
			alert("복사할 제조사를 선택하여 주십시요.");
			return;
		}
		for (var i=2; i<=mySheet2.RowCount(); i++){
			mySheet2.SetCellValue(i, "MAKER_CODE", value1);
			mySheet2.SetCellValue(i, "MAKER_NAME", value2);
		}
		//SLOGIC-END
	} else if (mySheet2.ColSaveName(Col) == "PROCESS_NAME"){ // 거래유형
		var value1 = mySheet2.GetCellValue(1, "PROCESS_TYPE");
		var value2 = mySheet2.GetCellValue(1, "PROCESS_NAME");
		var value3 = mySheet2.GetCellValue(1, "WAREHOUSE_CODE");
		
		if(kepIsValueNull(value1)){
			alert("복사할 거래유형을 선택하여 주십시요.");
			return;
		}
		for (var i=2; i<=mySheet2.RowCount(); i++){
			mySheet2.SetCellValue(i, "PROCESS_TYPE", value1);
			mySheet2.SetCellValue(i, "PROCESS_NAME", value2);
			mySheet2.SetCellValue(i, "WAREHOUSE_CODE", value3);
		}
	} else if (mySheet2.ColSaveName(Col) == "BELOW_COMORG_NAME"){ // 적용구분
		var value1 = mySheet2.GetCellValue(1, "BELOW_COMORG_CODE");
		var value2 = mySheet2.GetCellValue(1, "BELOW_COMORG_NAME");
		
		if(kepIsValueNull(value1)){
			alert("복사할 적용구분을 선택하여 주십시요.");
			return;
		}
		for (var i=2; i<=mySheet2.RowCount(); i++){
			mySheet2.SetCellValue(i, "BELOW_COMORG_CODE", value1);
			mySheet2.SetCellValue(i, "BELOW_COMORG_NAME", value2);
		}
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3){
	if(popupSel == "fileUpload") {	//파일 첨부
		$('#st_image_key').val(value1);
	} else if (popupSel == "commonCoCoGoodsDlvyClssifyPop"){ // 거래유형
		mySheet2.SetCellValue(grbRow, 'PROCESS_TYPE', value1);
		mySheet2.SetCellValue(grbRow, 'PROCESS_NAME', value2);
		mySheet2.SetCellValue(grbRow, 'WAREHOUSE_CODE', value3);
		
	} else if (popupSel == "commonCoCoBottomOrgCodePop"){ // 적용구분
		mySheet2.SetCellValue(grbRow, 'BELOW_COMORG_CODE', value1);
		mySheet2.SetCellValue(grbRow, 'BELOW_COMORG_NAME', value2);
	} else if (popupSel == "country"){ // 원산지
		mySheet2.SetCellValue(grbRow, 'ORIGIN_CODE', value1);
		mySheet2.SetCellValue(grbRow, 'ORIGIN_NAME', value3);
	} else if (popupSel == "maker"){ // 제조사
		mySheet2.SetCellValue(grbRow, 'MAKER_CODE', value1);
		mySheet2.SetCellValue(grbRow, 'MAKER_NAME', value2);
	} else if (popupSel == "calendarHour"){ // 견적마감일
		$('#st_atos_end_date').val(value1);
		$('#st_atos_end_date_text').val(value1.substr(0,4) + "/" + value1.substr(4,2) + "/" + value1.substr(6,2));
		$('#st_atos_end_time').val(value2);
		$('#st_atos_end_time_text').val(value2.substr(0,2) + ":" + value2.substr(2,2) + ":" + value2.substr(4,2));
	} else if (popupSel == "remarkReturn2Pop"){ // 운영사 비고
		$('#st_atos_remark').val(value1);
	 	 if(value1 ==""){
	 		$("img[id=Image2]").attr("src","/resources/images/icon2.gif");
	 	 }else{
	 		$("img[id=Image2]").attr("src","/resources/images/icon.gif");
	 	 }
	
	} else if (popupSel == "masterMpRqSellerChoice4Pop"){ // 협력사선택
		for (var i=0; i<mySheet2.RowCount(); i++){
			mySheet2.SetCellValue(i, "AGENT_CHECK", 0);
		}
		for (var i=0; i<mySheet2.RowCount(); i++){
			if (value1 == mySheet2.GetCellValue(i,"AGENT")){
				mySheet2.SetCellValue(i, "AGENT_CHECK", 1);
				Radiotie2(i,mySheet2.GetCellValue(i, "QUOTATION_SEQ"),1,'N');
			}
		}
	}else if (popupSel == "deliAreaPop"){ // 납품지역
		mySheet2.SetCellValue(grbRow, 'SELLER_AREA', value1);
	 	 if(value1 ==""){
	 		mySheet2.SetCellValue(grbRow, 'SELLER_AREA_IMG', areaOff);
	 	 }else{
	 		mySheet2.SetCellValue(grbRow, 'SELLER_AREA_IMG', areaOn);
	 	 }
	} else if(popupSel == "remarkAtoAPop") {	//운영사 비고
 			mySheet2.SetCellValue(grbRow, 'ATOA_REMARK', value1);
 			mySheet2.SetCellValue(grbRow, 'ATOA_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
	}else if(popupSel == "addImgPop") {	// 이미지첨부
			mySheet2.SetCellValue(grbRow, 'IMGFILE_DIR', value1);
			mySheet2.SetCellValue(grbRow, 'IMGFILE_NAME', value2);
			mySheet2.SetCellValue(grbRow, 'IMGFILE_NAME_IMG', (value1!="")? diskOn : diskOff);
			mySheet2.SetCellValue(grbRow, 'RFQ_IMG_TYPE', (value1!="")? "M" : "S");
	}else if (popupSel == "masterMpRqBuyerDesignAgentPop") {	// 고객사 요청자정보 설정 
		mySheet2.SetCellValue(grbRow, 'AGENT_CHOICE_REQ_DEPT', value1);
		mySheet2.SetCellValue(grbRow, 'AGENT_CHOICE_REQ_USER', value2);
		$('#AGENT_CHOICE_SEQ').val(value3);
	}
	grbRow="";	//초기화
}

function setBidSuccessCode( code, name, remark){
	mySheet2.SetCellValue(grbRow, 'BID_REMARK', remark);
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
	<input type="hidden" id="st_buyer_code"  name="st_buyer_code" value="${param.st_buyer}">	
	<input type="hidden" id="st_buyer_name2"  name="st_buyer_name2" value="">	
	<input type="hidden" id="st_quotation_no"  name="st_quotation_no" value="${param.st_quotation_no}">	
	<input type="hidden" id="st_revision"  name="st_revision" value="${param.st_revision}">
	<input type="hidden" id="st_sour_dept_yn"  name="st_sour_dept_yn" value="<%=st_sour_dept_yn%>">		
	<input type="hidden" id="st_buyer_rate_gubun"  name="st_buyer_rate_gubun" value="">	
	<input type="hidden" id="st_delimeterValue"  name="st_delimeterValue" value="">	
	<input type="hidden" id="st_catalog_com_code"  name="st_catalog_com_code" value="">	
	<input type="hidden" id="st_buyer_rate"  name="st_buyer_rate" value="">
	<input type="hidden" id="AGENT_CHOICE_SEQ"  name="AGENT_CHOICE_SEQ" value="">

	<div id="popWrapper" style="height:600px;">
    	<div id="popHeader">
        	<h1 class="title">협력사선정</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
		<!--팝업내용입니다-->
        <div id="popContainer">
        	<!--데이타그리드-->
        	<table class="cont_t_list06">
            	<caption>리스트</caption>
                <colgroup>
                    <col width="12%" />
                    <col width="21%" />
                    <col width="12%" />
                    <col width="21%" />
                    <col width="12%" />
                    <col width="21%" />
                </colgroup>
                <tbody>
                    <tr>
                      <th>고객사</th>
                      <td id="st_buyer_name"></td>
                      <th>의뢰번호</th>
                      <td id="st_qno" colspan="3"></td>
                    </tr>
                    <tr>
                      <th>견적작성자</th>
                      <td id="st_btoa_user_name">
                      <th>연락처</th>
                      <td id="st_btoa_user_tel">
                      <th><input type="text" class="input_blue_text"  id="st_rate_text" name="st_rate_text" style="width:110%;border:0px solid #fff;background-color:transparent;font-weight:bold;letter-spacing:-1px;font-family:돋움;font-size:12px;" readonly="readonly" /></th>
                      <td>
                      		<input type="text" class="input_type_text"  id="st_margin_rate" name="st_margin_rate" style="width:30px;" onChange="javascript:Adapt();" />
                      		<select id="st_round_flag" name="st_round_flag" style="width:60px;height:20px" onChange="javascript:Adapt();">
								<option value="R" selected>반올림</option>
								<option value="D" >버림</option>
                      		</select>
                      		<select id="st_decimal_flag" name="st_decimal_flag" style="width:60px;height:20px" onChange="javascript:Adapt();">
									<option value="-6">10000000</option>
									<option value="-5">1000000</option>
									<option value="-4">100000</option>
									<option value="-3">10000</option>
									<option value="-2">1000</option>
									<option value="-1">100</option>
									<option value="0">10</option>
									<option value="1" selected>0</option>
									<option value="2">0.1</option>
									<option value="3">0.01</option>
									<option value="4">0.001</option>
                      		</select>
                      </td>
                    </tr>
                </tbody>
            </table>
        
	       	<!--grid-->
			<div id="gridArea" style="height:430px;" class="mb10">
				<div style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet2", "100%", "430px");
					</script>
				</div>
			</div>
		
			<!--버튼영역-->
	        <div class="mr25">
			<div id="d" style="position:relative;width:1100px;height:25px">
				<div style="width:800px;position:absolute; left:0;">
					<span class="btn_07 mr10" id="prt1"><a href="javascript:doPop('offPrint')">오프라인견적서출력</a></span>
					견적마감일 : 
					<input type="hidden" name="st_atos_end_date" id="st_atos_end_date" value="">
					<input type="hidden" name="st_atos_end_time" id="st_atos_end_time" value="">
					<input type="text" name="st_atos_end_date_text" id="st_atos_end_date_text" class="input_type_text"  value="" onclick="javascript:doPop('calendarHour');" readonly>
					<input type="text" name="st_atos_end_time_text" id="st_atos_end_time_text" class="input_type_text"  value=""onclick="javascript:doPop('calendarHour');" readonly>
						<a href="javascript:doPop('calendarHour');"><img src="/resources/images/btn_calendar.gif"></a>
					&nbsp;
					<input type="hidden" id="st_atos_remark" name="st_atos_remark"	value="">
					<a href="javascript:doPop('remarkReturn2Pop');"><img name="Image2" id="Image2" src="/resources/images/icon2.gif"></a>
  				</div>
				<div style="width:300px;position:absolute; right:0;">
					<span class="btn_02 mr04"><a href="javascript:doPop('setAgentView')">협력사선택</a></span>
					<span class="btn_05 mr04"><a href="javascript:doAction('ReAgentSelect')">추가라운드요청</a></span>
					<span class="btn_02"><a href="javascript:doAction('bid');">확인</a></span>
  				</div>
  			</div>
        </div>
    	</div>
	</div>				
	</form>
		
</body>
</html>
