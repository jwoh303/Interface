<%--
**********************************************
* 메뉴 : 
* 화면 : 거래명세서작성
* 기능 : 거래명세서를 작성하기위한 팝업
* 프로그램 ID : SU0503006
* 담당자 : 최찬규
* 착수일 : 2026-09-22
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
<link rel="stylesheet" href="/resources/css/month_popup.css" type="text/css" />
</head>
 
<%
	@SuppressWarnings (value="unchecked")

// 	String p_buyer			= CommonUtil.nvl((String)request.getAttribute("st_buyer"));
// 	String p_po_no			= CommonUtil.nvl((String)request.getAttribute("st_po_no"));
// 	String p_ds_date		= CommonUtil.nvl((String)request.getAttribute("st_ds_date"));
// 	String p_legacy_po_no	= CommonUtil.nvl((String)request.getAttribute("st_legacy_po_no"));
// 	String p_seller			= CommonUtil.nvl((String)request.getAttribute("st_seller"));
// 	String p_tr_buyer		= CommonUtil.nvl((String)request.getAttribute("st_tr_buyer"));
	
// 	String p_dely_to_location	= CommonUtil.nvl((String)request.getAttribute("st_dely_to_location"));
// 	String p_add_user_id		= CommonUtil.nvl((String)request.getAttribute("st_add_user_id"));
	
	String p_buyer			= CommonUtil.nvl((String)request.getParameter("st_buyer"));
	String p_po_no			= CommonUtil.nvl((String)request.getParameter("st_po_no"));
	String p_ds_date		= CommonUtil.nvl((String)request.getParameter("st_ds_date"));
	String p_legacy_po_no	= CommonUtil.nvl((String)request.getParameter("st_legacy_po_no"));
	String p_seller			= CommonUtil.nvl((String)request.getParameter("st_seller"));
	String p_tr_buyer		= CommonUtil.nvl((String)request.getParameter("st_tr_buyer"));
	
	String p_dely_to_location	= CommonUtil.nvl((String)request.getParameter("st_dely_to_location"));
	String p_add_user_id		= CommonUtil.nvl((String)request.getParameter("st_add_user_id"));
	
	// 운영사 업무대행에서 호출시 사용. (p_proxy_yn == Y)
	String p_proxy_yn	= CommonUtil.nvl((String)request.getAttribute("st_proxy_yn"));
	String p_agent		= CommonUtil.nvl((String)request.getAttribute("st_agent"));
	
	String p_user_id	= CommonUtil.nvl((String)request.getParameter("st_add_user_id"));
	String p_kep_id		= CommonUtil.nvl(_sessionInfo.getUserId());
	
	// TR 협력사 납품 변경 팝업 확인
	String st_tr_notice_check_yn = "N";
	
	if(!p_proxy_yn.equals("Y")){
		p_agent = CommonUtil.nvl(_sessionInfo.getComCode());
		p_user_id	= CommonUtil.nvl(_sessionInfo.getUserId());
		
		boolean st_tr_notice_check = CommonUtil.getCodeCheckReturn("TRNOTICE", p_user_id);
		if(st_tr_notice_check == true){
			st_tr_notice_check_yn = "Y";
		}else{
			st_tr_notice_check_yn = "N";
		}
	}
	
	String action_id = "CREATE_IK_"+p_buyer+p_po_no;

	String legacy_flag = "";
	
	if(p_legacy_po_no.equals("") || p_legacy_po_no.equals("N")){
		legacy_flag = "N";
		
		if(p_proxy_yn.equals("Y")){
			p_legacy_po_no = "TM";	
		}
	}else{
		legacy_flag = "Y";
	}
	
	String rdMonthCheck = "IN";	
	
	String dhim_legacy_po_no = "";
	
	if(p_legacy_po_no.length() > 1){
		dhim_legacy_po_no = p_legacy_po_no.substring(0,1);
	}
	
	//조회결과 - 상세정보
	Map<String,String> detailInfo = (Map<String,String>) request.getAttribute("info");
	
	// 물류센터 고객사 체크
		String w001flag = (String) request.getAttribute("w001flag");
	
	String kep_user_info = "";
	String po_no = "";
	String po_create_date = "";
	String po_remark = "";
	String seller_amt = "";
	String seller_buyer = "";
	String seller_buyer_code = "";
	String ds_date = "";
	String surtax = "";
	String seller_com_name = "";
	String ttl_amt = "";
	String dely_to_location = "";
	String doc_type = "";
	String kepmro_doc_type = "";
	
	String process_type = "";
	String process_name = "";
	
	String stx_rpt = "";
	String dsn_rpt = "";
	String rpt_url = "";
	
	String ktag_rpt = "";
	
	String sheet_inv_amt = "";
	String sheet_inv_tax_amt = "";
	String sheet_inv_tot_amt = "";
	
	String parcel_yn = "";
	
	String center_tel_no = "";
	String delivery_remark = "";
	
	if(detailInfo != null){
		kep_user_info		= CommonUtil.nvl(detailInfo.get("KEP_USER_INFO"));
		po_no 				= CommonUtil.nvl(detailInfo.get("PO_NO"));
		po_create_date 		= CommonUtil.formatStrinigDate(detailInfo.get("PO_CREATE_DATE"));
		po_remark 			= CommonUtil.nvl(detailInfo.get("PO_REMARK"));
		seller_amt 			= CommonUtil.nvl(detailInfo.get("SELLER_AMT"));
		seller_buyer 		= CommonUtil.nvl(detailInfo.get("SELLER_BUYER"));
		seller_buyer_code 	= CommonUtil.nvl(detailInfo.get("SELLER_BUYER_CODE"));
		ds_date 			= CommonUtil.formatStrinigDate(detailInfo.get("DS_DATE"));
		surtax 				= CommonUtil.nvl(detailInfo.get("SURTAX"));
		seller_com_name 	= CommonUtil.nvl(detailInfo.get("SELLER_COM_NAME"));
		ttl_amt 			= CommonUtil.nvl(detailInfo.get("TTL_AMT"));
		dely_to_location 	= CommonUtil.nvl(detailInfo.get("DELY_TO_LOCATION"));
		doc_type 			= CommonUtil.nvl(detailInfo.get("DOC_TYPE"));
		kepmro_doc_type		= CommonUtil.nvl(detailInfo.get("KEPMRO_DOC_TYPE"));
		
		process_type		= CommonUtil.nvl(detailInfo.get("PROCESS_TYPE"));
		process_name		= CommonUtil.nvl(detailInfo.get("PROCESS_NAME"));
		
		stx_rpt		= CommonUtil.nvl(detailInfo.get("STX_RPT"));
		dsn_rpt		= CommonUtil.nvl(detailInfo.get("DSN_RPT"));
		
		rpt_url		= CommonUtil.nvl(detailInfo.get("RPT_URL"));
		
		ktag_rpt		= CommonUtil.nvl(detailInfo.get("KTAG_RPT"));
		
		sheet_inv_amt = CommonUtil.nvl(detailInfo.get("SELLER_AMT2"));
		sheet_inv_tax_amt = CommonUtil.nvl(detailInfo.get("SURTAX2"));
		sheet_inv_tot_amt = CommonUtil.nvl(detailInfo.get("TTL_AMT2"));
		
		parcel_yn = CommonUtil.nvl(detailInfo.get("PARCEL_YN"));
		
		center_tel_no =  CommonUtil.nvl(detailInfo.get("CENTER_TEL_NO"));
		delivery_remark = CommonUtil.nvl(detailInfo.get("DELIVERY_REMARK"));
	}

	//조회결과 - 상세 리스트
	List<Map<String, String>> detailList = (List<Map<String, String>>) request.getAttribute("data"); 
	
	int rec_cnt = 0;
	int page_display_cnt = 0;
	
	// SLOGIC-BEGIN(P06-0000080) - 길이수량 이용 고객사(윈체)
	String p060000080 =  CommonUtil.getSpecialCheckReturn(p_buyer,"P06-0000080","COL01_DATA");
	//거래명세서 알림창 (타입에 따라 팝업창 분류)
	String p070000023_type =  CommonUtil.getSpecialCheckReturn(p_buyer,"P07-0000023","COL01_DATA");
	String p070000023_size =  CommonUtil.getSpecialCheckReturn(p_buyer,"P07-0000023","COL02_DATA");
	// SLOGIC-END
	
	String com_type = "";
	if (_sessionInfo != null){
		com_type =  CommonUtil.nvl((String)_sessionInfo.getComType()); 	
	}
	
	// 솔브레인 관련 IF발주번호 확인
	String solb_if_buyer = "N";
	boolean p070000032 = CommonUtil.getSpecialCheckReturn(p_buyer,"P07-0000032");
	if(p070000032 == true){
		solb_if_buyer = "Y";
	}
	
	// 보관조건, 보관온도 입력 필수 대상 고객사
	String p070000033 = "";
	Map<String, String> p070000033_map = CommonUtil.getSpecialCheckReturnMap(p_buyer,"P07-0000033");
	if (p070000033_map != null){
    	p070000033= CommonUtil.nvl(p070000033_map.get("COL01_DATA"),""); // 유형별 값
    }
	
	// 입고라벨 미사용 대상 고객사
	String st_no_tag_check_yn = "N";
	boolean st_no_tag_check = CommonUtil.getCodeCheckReturn("M204", p_buyer);
	if(st_no_tag_check == true){
		st_no_tag_check_yn = "Y";
	}else{
		st_no_tag_check_yn = "N";
	}
	
	// 품목라벨 자체 사용 고객사(KEP 품목라벨은 중복되어 출력되지 않아야 함)
	String st_no_itemTag_check_yn = "N";
	boolean st_no_itemTag_check = CommonUtil.getCodeCheckReturn("M206", p_buyer);
	if(st_no_itemTag_check == true){
		st_no_itemTag_check_yn = "Y";
	}else{
		st_no_itemTag_check_yn = "N";
	}
	
	// 고객사 고유 품목라벨 사용
	String p070000034 = "";
	Map<String, String> p070000034_map = CommonUtil.getSpecialCheckReturnMap(p_buyer,"P07-0000034");
	if (p070000034_map != null){
    	p070000034 = CommonUtil.nvl(p070000034_map.get("COL01_DATA"),""); // 품목라벨 mrd
    }
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var g_query = "";
//최초 화면 함수 
function init(){
	var st_parcel_type = document.getElementsByName("st_parcel_type");
	var parcel_yn = "<%=parcel_yn%>";
	for( var i = 0; i < st_parcel_type.length; i++ ) {
		if( st_parcel_type[i].value == parcel_yn ) {
			st_parcel_type[i].checked = true;
			break;
		}
	}
	$("#st_invoice_date_text").val(kepGetNowTimeStr('YYYYMMDD','/'));
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:60,	Edit:true,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"INV_LEGACY_DATE",		Header:"납품예정일",			Type:"Date",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text", FontColor:"#3a72c7", Cursor:"Pointer",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"MSDS_YN",				Header:"MSDS",				Type:"Button",		Width:80,	Edit:false,	EditLen:100,	Hidden:true,ClassName:'Type02'}
			
			,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"품목명",				Type:"Text",		Width:230,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",				Type:"Text",		Width:230,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"MAKER_PART_NO",		Header:"모델번호",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			
			,{ Align:"Right",	SaveName:"UNIT_PRICE",			Header:"단가",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Format:"${priceFormat}"}
			,{ Align:"Right",	SaveName:"ITEM_QTY",			Header:"발주수량",				Type:"Float",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"INV_COMP_QTY",		Header:"기납품수량",			Type:"Float",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"INV_POSS_QTY",		Header:"납품수량",				Type:"Float",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"ORG_INV_POSS_QTY",	Header:"ORG_INV_POSS_QTY",	Type:"Float",			Width:60,	Edit:false,	EditLen:100,	Hidden:true}
			
			,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"SELLER_AMT2",			Header:"합계",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Format:"${priceFormat}"}
			,{ Align:"Right",	SaveName:"SELLER_AMT",			Header:"SELLER_AMT",		Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Format:"${priceFormat}"}
			,{ Align:"Center",	SaveName:"IMAGE_KEY_YN",		Header:"파일첨부",				Type:"Text",		FontColor:"#3a72c7", Cursor:"Pointer",Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"IMAGE_KEY",			Header:"파일첨부",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Left",	SaveName:"PO_REMARK",			Header:"품목비고",				Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ITEM_MAKE_TYPE_NM",	Header:"품목구분",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ITEM_MAKE_TYPE",		Header:"품목구분",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
			
			,{ Align:"Center",	SaveName:"ST_DATE",				Header:"표준납품일",			Type:"Date",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			
			
			,{ Align:"Right",	SaveName:"INV_LEGACY_QTY",		Header:"납품수량",				Type:"Float",			Width:60,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"RD_DATE",				Header:"고객수령희망일",			Type:"Date",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
		<%if(p060000080.equals("TYPE1")) {%>
// 			,{ Align:"Left",	SaveName:"SIZE_LEN_QTY",		Header:"길이/수량",			Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"SIZE_YN",				Header:"SIZE_YN",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Left",	SaveName:"SIZE_LEN",			Header:"길이",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"INV_POSS_SIZE_QTY",	Header:"수량",				Type:"Float",		Width:60,	Edit:true,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"ORG_INV_POSS_SIZE_QTY",	Header:"수량",				Type:"Float",		Width:60,	Edit:true,	EditLen:100,	Hidden:true}
// 			,{ Align:"Left",	SaveName:"SIZE_QTY",			Header:"SIZE_QTY",			Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:true}
		<%}%>
			
			,{ Align:"Center",	SaveName:"CMC_INFO_YN",			Header:"CMC_INFO_YN",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			
			,{ Align:"Right",	SaveName:"IV_QTY",				Header:"IV_QTY",			Type:"Int",			Width:60,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"CONTRACT_NO",			Header:"CONTRACT_NO",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"CONTRACT_SEQ",		Header:"CONTRACT_SEQ",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",	Header:"BYIT_COMORG_CODE",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"MSDS_NO",				Header:"MSDS_NO",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PURCHASER_ID",		Header:"PURCHASER_ID",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			
			,{ Align:"Center",	SaveName:"LEGACY_PO_SEQ",		Header:"LEGACY_PO_SEQ",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"INV_LEGACY_PO_NO",	Header:"INV_LEGACY_PO_NO",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"INV_LEGACY_PO_SEQ",	Header:"INV_LEGACY_PO_SEQ",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"INV_LEGACY_QTY",		Header:"INV_LEGACY_QTY",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"HARMFUL_TEXT",		Header:"HARMFUL_TEXT",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"TEMP_COND_TEXT",		Header:"TEMP_COND_TEXT",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"TEMP_RANGE",			Header:"TEMP_RANGE",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"CMC_REQ_NO",			Header:"CMC_REQ_NO",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PO_SEQ",				Header:"PO_SEQ",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"DS_YN",				Header:"DS_YN",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			
			,{ Align:"Center",	SaveName:"COD_CHECK",			Header:"MSDS대상",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"MSDS_CHECK",			Header:"MSDS매핑필요",			Type:"Text",		Width:110,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"REQ_CHECK",			Header:"REQ_CHECK",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"TEMP_REQ_CHECK",		Header:"TEMP_REQ_CHECK",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"TEMP_CHECK",			Header:"TEMP_CHECK",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"CMC_HARMFUL_YN",		Header:"유해화학물질"	,		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"SG118_CHECK",			Header:"SG118_CHECK",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"QUERY_TEXT",			Header:"QUERY_TEXT",		Type:"Text",		Width:80,	Edit:false,	Hidden:true}
			,{ Align:"Center",	SaveName:"PH_PO_DATE",			Header:"PH_PO_DATE",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"WAREHOUSE_CODE",		Header:"WAREHOUSE_CODE",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"TR_WAREHOUSE_YN",		Header:"TR_WAREHOUSE_YN",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"BUY_CLOSE_DATE_CHK",	Header:"BUY_CLOSE_DATE_CHK",Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"TEMP_COND",			Header:"TEMP_COND",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"DS_LIMIT",			Header:"DS_LIMIT",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);

	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");

	mySheet.SetTheme("DB", "DeepBlue");
	
	kepSearch(document.contentForm, mySheet, "/mpiv/getSellerMpIvTranStatementWriteDoosanmecaPop_v2.do" , pagingMode);
}

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	var p_buyer = "<%=p_buyer%>";
	var p060000080 = "<%=p060000080%>";
	var p070000033 = "<%=p070000033%>";
	
	var legacy_po_seq = "";
	var legacy_po_seq_a = "";
	var legacy_po_seq_tot = "";
	var pur_id = "";
	
	var rowAmt = 0;
	var rowCnt = 0;
	
	for(var i = 1; i<=mySheet.RowCount();i++){
		if(p060000080 == "TYPE1" && mySheet.GetCellValue(i,"SIZE_YN") == "Y") {
			mySheet.SetCellEditable(i,"INV_POSS_QTY",false);
		}else{
			if(mySheet.GetCellValue(i,"DS_YN") == "Y"){
				mySheet.SetCellEditable(i,"INV_POSS_QTY",true);
				mySheet.SetCellBackColor(i,"INV_POSS_QTY","#FFFFDC");
			}else{
				mySheet.SetCellEditable(i,"INV_POSS_QTY",false);
			}
		}
		
		if(p070000033 == "TYPE0" || p070000033 == "TYPE1") {
			if(mySheet.GetCellValue(i,"SG118_CHECK")=="Y"){
				mySheet.SetCellValue(i,"SPECIFICATION",mySheet.GetCellValue(i,"SPECIFICATION")+" "+mySheet.GetCellValue(i,"TEMP_COND_TEXT")+" "+mySheet.GetCellValue(i,"TEMP_RANGE")+" "+mySheet.GetCellValue(i,"HARMFUL_TEXT"))
			}
		}

		legacy_po_seq_a = legacy_po_seq + "@@";	
		legacy_po_seq_tot = legacy_po_seq_tot + legacy_po_seq_a;
		legacy_po_seq_tot = legacy_po_seq_tot;
		
		mySheet.SetCellValue(i,"SELECTED",true);
		
		rowAmt += mySheet.GetCellValue(i, "SELLER_AMT");
		rowCnt += 1;
	}
	
	$("#itemCnt").html(rowCnt);
	$("#itemAmt").html(kepCommaNum(rowAmt));
	
	$("#legacy_po_seq_tot").val(legacy_po_seq_tot);
	$("#st_pur_id").val(mySheet.GetCellValue(1,"PURCHASER_ID"));
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
function mySheet_OnCheckAllEnd(col,value){
	var sRow = mySheet.FindCheckedRow("SELECTED");
	var arrRow = sRow.split("|");
	if(sRow == "") {
		$("#itemCnt").html("0");
		$("#itemAmt").html("0");
		return;
	}
	var rowAmt = 0;
	var rowCnt = 0;
	
	for(var i = 0; i<arrRow.length; i++){
		rowAmt += mySheet.GetCellValue(arrRow[i], "SELLER_AMT2");
		rowCnt += 1;
	}
	$("#itemCnt").html(rowCnt);
	$("#itemAmt").html(kepCommaNum(rowAmt));
}
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
	var st_image_key = mySheet.GetCellValue(Row, "IMAGE_KEY");
	var st_image_key_yn = mySheet.GetCellValue(Row, "IMAGE_KEY_YN");
	var st_contract_no = mySheet.GetCellValue(Row, "CONTRACT_NO");
	var st_contract_seq = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
	var st_buyer = mySheet.GetCellValue(Row, "BYIT_COMORG_CODE");
	var st_msds_yn = mySheet.GetCellValue(Row, "MSDS_YN");
	var st_msds_no = mySheet.GetCellValue(Row, "MSDS_NO");
	var st_cmc_info_yn = mySheet.GetCellValue(Row, "CMC_INFO_YN");
	var st_cmc_req_no = mySheet.GetCellValue(Row,"CMC_REQ_NO");
	var st_sg118_check = mySheet.GetCellValue(Row,"SG118_CHECK");
	

	if(column == "BUYER_ITEM_NO"){
		var src = "/common/catalogDetailPop.do?open=Y&BUYER="+st_buyer+"&BUYER_ITEM_NO="+escape(st_buyer_item_no)+"&CONTRACT_NO="+st_contract_no+"&CONTRACT_SEQ="+st_contract_seq+"&popupCheck=Y";
		openLayerPop2(src,"650px","600px");
// 		openSearchPopup("/common/catalogDetailPop.do","?open=Y&BUYER="+st_buyer+"&BUYER_ITEM_NO="+escape(st_buyer_item_no)+"&CONTRACT_NO="+st_contract_no+"&CONTRACT_SEQ="+st_contract_seq,"650,600,no");
	}
	if(column == "MSDS_YN"){
		if(st_msds_yn == "Y"){
			openSearchPopup("/coco/showCommonCoCoMsdsDetailPop_v2.do","?st_msds_no="+st_msds_no+"&st_btn_yn=N",'750,580,no');
		}
	}
	if(column == "IMAGE_KEY_YN"){
		if(st_image_key_yn != ""){
			location.href="/common/download_v2.do?DOC_NO="+st_image_key;
		}
	}
	if(column == "CMC_INFO_YN"){
		doPop('cmcInfoPop',st_cmc_req_no,st_buyer_item_no,st_cmc_info_yn, st_sg118_check);
	}
	if(column == 'SELECTED'){
		var sRow = mySheet.FindCheckedRow("SELECTED");
		var arrRow = sRow.split("|");
		if(sRow == "") {
			$("#itemCnt").html("0");
			$("#itemAmt").html("0");
			return;
		}
		var rowAmt = 0;
		var rowCnt = 0;
		
		for(var i = 0; i<arrRow.length; i++){
			rowAmt += mySheet.GetCellValue(arrRow[i], "SELLER_AMT2");
			rowCnt += 1;
		}
		$("#itemCnt").html(rowCnt);
		$("#itemAmt").html(kepCommaNum(rowAmt));
	}
	return;
}
function mySheet_OnChange(Row, Col, Value, OldValue, RaiseFlag){
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if(column == "INV_POSS_SIZE_QTY"){
		update_len_qty(Row);
	}
	if(column == "INV_POSS_QTY"){
		update_qty(Row);
	}
}

//팝업호출
function doPop(str, value1, value2, value3, value4) {
	popupSel = str ;
	
	switch (str) {
		case "commonMpIvOrderInfoPop": // 발주번호 click시 발주정보 팝업
			openSearchPopup("/mpiv/getCommonMpIvOrderInfoPop.do", "?st_buyer="+value1+"&st_po_no="+value2, "930,600,no");
			break;
			
		case "commonMpIvDlvryCarPop": // 배송차량조회
			openSearchPopup("/mpiv/getCommonMpIvDlvryCarPop.do", "?st_com_code="+value1, "580,400,no");
			break;
			
		case "commonMpIvDlvryNoticePop": // 납품시 공지정보
			openSearchPopup("/mpiv/getCommonMpIvDlvryNoticePop.do", "?st_type="+value1, value2);
			break;
		case "cmcInfoPop": // 물질정보
			if(value3 == "N"){
// 				alert("등록 된 물질정보가 없습니다.");
				var text = "등록 된 물질정보가 없습니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			
			if(value4 == "Y"){ // 시약류이면 보관조건 높이만큼 추가
				openSearchPopup('/mdct/getSellerMdCtChemicalMatRegPopHd.do', '?st_req_no='+value1+'&st_buyer_item_no='+value2+'&st_type=sSearch'+'&st_req_status=C','800,670,yes');	
			}else{
				openSearchPopup('/mdct/getSellerMdCtChemicalMatRegPopHd.do', '?st_req_no='+value1+'&st_buyer_item_no='+value2+'&st_type=sSearch'+'&st_req_status=C','800,620,yes');
			}
			break;
	}
}
//납품공지 후 저장.
function setDlvryNotice(value1){
	if("<%=process_type%>" == "2" && "<%=p_proxy_yn%>" != "Y" && "<%=st_tr_notice_check_yn%>" == "N"){
		doPop('commonMpIvDlvryNoticePop', "TYPE90", "620,530,no");
	}else{
		document.forms["contentForm"].st_query.value = g_inv_param;
		kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteDoosanmecaPop_v3.do","contentForm","btnSave");
	}
}  

// TR 협력사 배송 변경 팝업
function setDlvryNotice2(value1){
	document.forms["contentForm"].st_query.value = g_inv_param;
	
	kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteDoosanmecaPop_v3.do","contentForm","btnSave");
}

var process_type = "<%=process_type%>";
	
/**
	거래명세서 작성
	1. 직납건 확인.
	2. 구매사 차량등록유무 확인.
	3. 공급사 차량 리스트 확인.
	4. 차량코드 확인.
	5.거래명세서 생성
**/
function setInvoiceCreateDoosanmeca(){	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	// 선택된 항목 유무 체크
	if (checkRows.length == 0) {
// 		alert("거래명세서를 생성할 품목을 선택하여 주세요.");
		var text = "거래명세서를 생성할 품목을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var parcel_yn = $("input[name='st_parcel_type']:checked").val();
	
	if(isEmpty(parcel_yn)){
// 		alert("배송유형을 선택해주세요.");
		var text = "배송유형을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_parcel_type").focus();
		return;
	}
	
	var process_type = "<%=process_type%>";
	var ktag_rpt = "<%=ktag_rpt%>";

	if(process_type == "2" || ktag_rpt == "Y"){
		var print_size = $("#st_print_size").val();
		$("#ktag_box_qty").val($("#itemTag_box_qty").val());
		
		if(isEmpty(print_size)){
// 			alert("라벨출력방식을 선택해주세요.");
			var text = "라벨출력방식을 선택해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			$("#st_print_size").focus();
			return;
		}
	}
	
	document.contentForm.st_parcel_yn.value =  parcel_yn;
	
	
// 	if(confirm("거래명세서를 작성 하시겠습니까?")){	
// 		inSetInvoiceCreateDoosanmeca();
// 	}

	var text = "거래명세서를 작성 하시겠습니까?";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:inSetInvoiceCreateDoosanmeca(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "110px";
	var but2widthC = "110px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
}

function setCarInfo(car_query){
	document.forms["contentForm"].st_car_info.value = car_query;      
	document.forms["contentForm"].st_car_flag.value = "Y";

	inSetInvoiceCreateDoosanmeca();
}
//납품공지사항 파라미터
var g_inv_param = "";
//거래명세서 작성
function inSetInvoiceCreateDoosanmeca(){	
	closePopText1();
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	//================================================
	var checkRdDate ="<%=rdMonthCheck%>";
	var p060000080 = "<%=p060000080%>";
	
	if(checkRdDate == "OV"){
// 		alert("두산모트롤은 납품요구일이 익월일경우 납품서 생성을 할수가 없습니다.");
		var text = "두산모트롤은 납품요구일이 익월일경우 납품서 생성을 할수가 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var query = "";
	var chk_cnt = 0;    // 거래명세서 생성할 품목수
	
	var buyer           = "";
	var ds_date         = "";
	var po_no           = "";
	var po_seq          = "";
	var cd_qty          = "";
	var poss_cd_qty     = "";
	var inv_qty         = "";
	var po_qty          = "";
	
	var size_yn			= "";
	var size_len			= "";
	var size_qty		= "";
	var process_type	= "<%=process_type%>";
	var w001flag	= "<%=w001flag%>";
	if( (process_type == "1" || process_type == "3") && w001flag == "N") {
// 		alert('재고나 VMI는 거래명세서 생성이 불가능 합니다.');
		var text = "재고나 VMI는 거래명세서 생성이 불가능 합니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	//유해화학물질 여부
	var harmful_yn = "";
	var invoice_date = $("#st_invoice_date_text").val().replace(/[/]/gi,"");
	
	// MSDS 진행 통제
	var cod_check	= ""; //ICOMCOD1 에 있는지 체크하는 변수
	var msds_check	= ""; //BYIT.MSDS_NO의 null여부
	var req_check   = ""; //KEP_CMC_REQ 의 상태 체크
	var temp_req_check   = ""; //KEP_CMC_REQ 의 상태 체크(TEMP_COND 입력 여부)
	var buyer_item_no_arr = []; //등록해야할 품목코드
	var msds_no_reg_buyer_item_no_arr = []; //카탈로그에 MSDS 미등록 품목코드
	var tempMng_no_reg_buyer_item_no_arr = []; //카탈로그에 보관조건 미등록 품목코드
	
	var temp_check   = ""; //보관조건 체크
	var sg118_check = ""; // 시약류 체크
	var p070000033 = ""; // 보관조건이 필수인 고객사 목록
	var temp_cond = ""; // 보관조건 유형(실온/정온/냉장/냉동/극냉동)
	
	// 매입단가유효일 진행 통제
	var buy_close_date_chk = ""; // 매입단가유효일 체크
	
	//var invoice_date	= document.forms.contentForm.st_invoice_date.value;
	
	/*
	document.forms.contentForm.st_invoice_date.value = document.forms.contentForm.st_invoice_date.value;// 납품확정일
	document.forms.contentForm.st_inv_amt.value      = document.forms.contentForm.inv_amt.value;        // 공급가액
	document.forms.contentForm.st_inv_tax_amt.value  = document.forms.contentForm.inv_tax_amt.value;    // 부가세(공급가액 10%)
	document.forms.contentForm.st_inv_tax_rate.value = document.forms.contentForm.inv_tax_rate.value;   // 부가세비율(0.1)
	document.forms.contentForm.st_inv_tot_amt.value  = document.forms.contentForm.inv_tot_amt.value;    // 총금액(공급가액+부가세)
	document.forms.contentForm.st_remark.value       = document.forms.contentForm.st_remark.value;      // 비고
	*/
	for(var idx = 0; idx<arrRow.length; idx++){
			var complete_mark   = "N";
			
			buyer       = $("#st_buyer").val();
			po_no       = $("#st_po_no").val();
			po_seq      = mySheet.GetCellValue(arrRow[idx],"PO_SEQ");
			ds_date     = $("#st_ds_date").val();
			cd_qty      = mySheet.GetCellValue(arrRow[idx],"INV_POSS_QTY");
			poss_cd_qty = mySheet.GetCellValue(arrRow[idx],"ORG_INV_POSS_QTY");
			inv_qty      = mySheet.GetCellValue(arrRow[idx],"IV_QTY");
		
			po_qty      = mySheet.GetCellValue(arrRow[idx],"ITEM_QTY");
			
			//유해화학 물질여부
			harmful_yn = mySheet.GetCellValue(arrRow[idx],"CMC_HARMFUL_YN");
			
			if(process_type=="2"&&harmful_yn=="Y"){
//                 alert("유해 화학물질은 물류센터로 납품 불가능합니다.\nKeP담당자에게 연락 바랍니다.");
                var text = "유해 화학물질은 물류센터로 납품 불가능합니다.</br>KeP담당자에게 연락 바랍니다.";
        		openLayerPopText2(text,but1text,but1func,but1width);
                return ;				
			}
			// MSDS 진행 통제 체크
			cod_check = mySheet.GetCellValue(arrRow[idx],"COD_CHECK");
    		msds_check = mySheet.GetCellValue(arrRow[idx],"MSDS_CHECK");
    		req_check = mySheet.GetCellValue(arrRow[idx],"REQ_CHECK");
    		temp_req_check = mySheet.GetCellValue(arrRow[idx],"TEMP_REQ_CHECK");
    	
    		temp_check = mySheet.GetCellValue(arrRow[idx],"TEMP_CHECK");
    		p070000033 = $("#p070000033").val();
    		sg118_check = mySheet.GetCellValue(arrRow[idx],"SG118_CHECK");
    		temp_cond = mySheet.GetCellValue(arrRow[idx],"TEMP_COND");
	    	
	    	if(cod_check=="Y" && msds_check=="Y" && req_check=="N"){ //물질정보등록 대상이면서 msds미매핑 건 이면서 입력요청 외에 다른 상태 건 이 없는 경우 거래명세서 작성 통제
	     		buyer_item_no_arr.push(mySheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO"));	
	     	}
	    	
	    	if(cod_check=="Y" && msds_check=="Y"){ // MSDS 대상 표준카테고리에 해당하고 카탈로그 MSDS 미매핑 품목 리스트 - 통제 2024.07.19 HSJ
	    		msds_no_reg_buyer_item_no_arr.push(mySheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO"));	
	     	}
	    	if(p070000033 != "" && sg118_check == "Y" && temp_check == "Y"){ // 보관조건 입력 필수 고객사 & 카탈로그에 보관조건 미등록 품목 통제 - 2025.06.27 HSJ
	    		if(temp_req_check == "Y"){ //협력사제출,제출(오분류) 상태이고 보관조건을 입력한 데이터가 있는 경우 -> 진행하지말고 기다리라고 안내
	    			var text = "해당 품목 ("+mySheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO")+") 은 보관온도 조건 입력 요청이 접수되어 현재 KeP 담당자 검토 단계에서 처리 중입니다.</br>동일 품목에 대한 추가 요청은 접수되지 않으니 검토 완료까지 잠시만 기다려 주세요.";
	    			openLayerPopText2(text,but1text,but1func,but1width);
	    			return
	    		}else{
		    		tempMng_no_reg_buyer_item_no_arr.push(mySheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO"));
	    		}
	    	}
	    	// 매입단가유효일 진행 통제
	    	buy_close_date_chk = mySheet.GetCellValue(arrRow[idx],"BUY_CLOSE_DATE_CHK");
			if(buy_close_date_chk == "Y"){
// 				alert("해당 건 진행할 수 없습니다.\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
				 var text = "해당 건 진행할 수 없습니다.</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
	        		openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}

<%if(!p_proxy_yn.equals("Y")){%>			
			// 보관조건에 따른 거래유형 검증(아모레퍼시픽(TYPE1))
	    	if(p070000033 == "TYPE1"){ // 아모레퍼시픽(TYPE1)
	    		if(sg118_check == "Y"){ // 시약류
	    			if(harmful_yn != "Y"){ // 유해화학물질 여부
	    				if(temp_cond != ""){
		        			if(temp_cond == "A" || temp_cond == "B"){ // 실온(A), 정온(B)
		            			if(process_type != "2"){
// 		            				alert("실온/정온은 TR로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
		            				var text = "실온/정온은 TR로만 가능합니다.(거래유형오류)</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
		        	        		openLayerPopText2(text,but1text,but1func,but1width);
		               				return;
		            			}
		            		}else{
		            			if(process_type != "0"){
// 		            				alert("냉장/냉동은 직납으로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
		            				var text = "냉장/냉동은 직납으로만 가능합니다.(거래유형오류)</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
		        	        		openLayerPopText2(text,but1text,but1func,but1width);
		               				return;
		            			}
		            		}
	    				}
	        		}	
	    		}
	    	}
<%}%>

			if(p060000080 == "TYPE1"){
				size_yn		= mySheet.GetCellValue(arrRow[idx],"SIZE_YN");
				size_len		= mySheet.GetCellValue(arrRow[idx],"SIZE_LEN");
				size_qty		= mySheet.GetCellValue(arrRow[idx],"INV_POSS_SIZE_QTY");
			}
			
            // 납품수량 = 납품가능수량 일때 ICOMPORS.COMPLETE_MARK = 'Y'로 설정
            // 납품수량   ==> 송장생성할 수량

            // ICOMPODT의 COMPLETE_MARK는 ICOMPORS.COMPLETE_MAKR가 모두 'Y'경우  ==>  ICOMPODT.COMPLETE_MAKR = 'Y'로 설정
            // ICOMPODT의 COMPLETE_MARK는 ICOMPODT.COMPLETE_MAKR가 모두 'Y'경우  ==>  ICOMPOHD.COMPLETE_MAKR = 'Y'로 설정


            if( poss_cd_qty == cd_qty){
                complete_mark = "Y";
            }
            
            if(cd_qty == 0){
//                 alert("납품수량을 0으로 지정할수 없습니다.");
                var text = "납품수량을 0으로 지정할수 없습니다.";
        		openLayerPopText2(text,but1text,but1func,but1width);
                return ;
            }

			if((eval(cd_qty) + eval(inv_qty)) > eval(po_qty)) {
// 				alert("발주수량을 초과할수 없습니다");
				var text = "발주수량을 초과할수 없습니다.";
        		openLayerPopText2(text,but1text,but1func,but1width);
				return ;
			}
            
			query +=  buyer         + "@@";
			query +=  po_no         + "@@";
			query +=  po_seq        + "@@";
			query +=  cd_qty        + "@@";
			query +=  invoice_date  + "@@";
			query +=  ds_date       + "@@";
			query +=  complete_mark + "@@";	// 6
			query +=  po_qty		+ "@@";	// 7
			query +=  inv_qty			  ;	// 8
			if(p060000080 == "TYPE1"){
				if(size_yn == "Y"){
					query += "@@";
					query += size_yn + "@@"; // 9
					query += size_len + "@@"; // 10
					query += size_qty; // 11
				}
			}
			query +=  "^||^" ;
	}
	
	if(buyer_item_no_arr.length != 0){ //수주접수 통제해야되는 건이 있는 경우
		g_query = query;
		var text = "해당 품목 ("+buyer_item_no_arr+") 은 MSDS 제출이 필요합니다.</br>MSDS 등록 후 KeP 승인이 완료되면 거래명세서 생성을 진행할 수 있습니다.</br>KeP 승인완료 전에는 거래명세서 생성이 제한됩니다.";
		var but1textC = "확인";
		var but2textC = "MSDS관리 바로가기";
		var but1funcC = "javascript:reqAndClose(); return false;";
		var but2funcC = "javascript:reqAndMove(); return false;";
		var but1widthC = "120px";
		var but2widthC = "160px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		
// 		if(confirm("해당 품목 ("+buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n\n카탈로그 관리 > 물질정보 제출 화면으로 이동하셔서 MSDS 및 물질정보 제출 후 KEP에서 MSDS매핑이 완료되면 거래명세서 작성하시기 바랍니다.\n\n확인을 누르면 물질정보 제출 요청이 됩니다.\n원하지 않으면 취소를 누르세요.\n\n*문의사항은 거래명세서 작성 화면에 있는 KeP담당자 통해서 하시길 바랍니다.")){
// 			//KEP_CMC_REQ insert 코드
// 			document.forms.contentForm.st_query.value = query;
// 			kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteChemicalInfo.do","contentForm","saveChemInfo");
// 		}
		return;
	}
	
	if(tempMng_no_reg_buyer_item_no_arr.length != 0){ //수주접수 통제해야되는 건이 있는 경우
		g_query = query;
		var text = "해당 품목 ("+tempMng_no_reg_buyer_item_no_arr+") 은 보관온도 조건 제출이 필요합니다.</br>등록 후 KeP 승인이 완료되면 거래명세서 생성을 진행할 수 있습니다.</br>KeP 승인완료 전에는 거래명세서 생성이 제한됩니다.";
		var but1textC = "확인";
		var but2textC = "MSDS관리 바로가기";
		var but1funcC = "javascript:reqAndClose(); return false;";
		var but2funcC = "javascript:reqAndMove(); return false;";
		var but1widthC = "120px";
		var but2widthC = "160px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		
// 		if(confirm("해당 품목 ("+tempMng_no_reg_buyer_item_no_arr+") 은 보관조건(온도) 확인이 필요한 대상입니다.\n카탈로그 관리 > 물질정보 제출 화면으로 이동하셔서 물질정보 제출 후 KEP에서 승인되면 거래명세서 작성하시기 바랍니다.\n\n확인을 누르면 물질정보 제출 요청이 됩니다.\n원하지 않으면 취소를 누르세요.\n\n*문의사항은 거래명세서 작성 화면에 있는 KeP담당자 통해서 하시길 바랍니다.")){
// 			//KEP_CMC_REQ insert 코드
// 			document.forms.contentForm.st_query.value = query;
// 			kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteChemicalInfo.do","contentForm","saveChemInfo");
// 		}
		return;
	}
	
	if(msds_no_reg_buyer_item_no_arr.length != 0){
		
		g_query = query;
		var text = "해당 품목 ("+msds_no_reg_buyer_item_no_arr+") 은 MSDS 제출이 필요합니다.</br>MSDS 등록 후 KeP 승인이 완료되면 거래명세서 생성을 진행할 수 있습니다.</br>KeP 승인완료 전에는 거래명세서 생성이 제한됩니다.";
		var but1textC = "확인";
		var but2textC = "MSDS관리 바로가기";
		var but1funcC = "javascript:layerPopClose(); return false;";
		var but2funcC = "javascript:layerPopMove(); return false;";
		var but1widthC = "120px";
		var but2widthC = "160px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		
// 		alert("해당 품목 ("+msds_no_reg_buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n현재 MSDS가 매핑되어 있지 않아 진행이 불가하니 확인하여 주시기 바랍니다.\n*문의사항은 거래명세서 작성 화면에 있는 KeP담당자 통해서 하시길 바랍니다.");
		return;
	}
	/*
	KRKITU0003@@PO14000014@@000001@@50@@20140620@@20140613@@Y^||^
	KRKITU0003@@PO14000014@@000002@@50@@20140620@@20140613@@Y^||^
	KRKITU0003@@PO14000014@@000003@@50@@20140620@@20140613@@Y^||^
	KRKITU0003@@PO14000014@@000004@@50@@20140620@@20140613@@Y^||^ 
	*/
	//P07-0000023  특수로직 타입에 따라 안내화면 내용이 다름.
	var p070000023_type = "<%=p070000023_type%>";
	var p070000023_size = "<%=p070000023_size%>";
	
// 	if(p070000023_type != ""){
// 		g_inv_param = query;
// 		doPop('commonMpIvDlvryNoticePop', p070000023_type, p070000023_size);
// 		return;
// 	}else{
		var p_buyer = "<%=p_buyer%>";
		var p_legacy_po_no = "<%=p_legacy_po_no%>";
		var dhim_legacy_po_no = "<%=dhim_legacy_po_no%>";
		var process_type = "<%=process_type%>";
		
		if(p_buyer == "KRDOOS0099" && (p_legacy_po_no.length != 14 || dhim_legacy_po_no == "5" || dhim_legacy_po_no == "4" || dhim_legacy_po_no == "A") && process_type == "0"){
			var legacy_po_no = $("#st_legacy_po_no").val();
			var agent = $("#st_agent_code").val();
			var agent_name = $("#st_com_name").val();
			var legacy_po_seq = $("#legacy_po_seq_tot").val();
			
			var sap_user = "20493";
			var sap_password = "20493";
			var sap_lang="KO";
		
			document.doowinForm.agent.value = agent;
			document.doowinForm.agent_name.value = agent_name;
			document.doowinForm.po_no.value = legacy_po_no;
			document.doowinForm.po_seq.value = legacy_po_seq;
			document.doowinForm.portal_user_id.value = sap_user;
			document.doowinForm.portal_password.value = sap_password;
			document.doowinForm.lang_cd.value = sap_lang;
			
			//document.doowinForm.action = "http://doowin.doosanmachinetools.com/keplogin.do";
			document.doowinForm.action = "https://partner.dn-solutions.com/keplogin.do";
			document.doowinForm.target = "_blank";
			document.doowinForm.submit();
		}else{
			if("<%=process_type%>" == "2" && "<%=p_proxy_yn%>" != "Y" && "<%=st_tr_notice_check_yn%>" == "N"){
				g_inv_param = query;
				doPop('commonMpIvDlvryNoticePop', "TYPE90", "620,530,no");
			}else{
				document.forms["contentForm"].st_query.value  = query;
				kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteDoosanmecaPop_v3.do","contentForm","btnSave");
			}
		}
// 	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	if(pMethod == "carInfo"){
		var parcel_yn = $("input[name='st_parcel_type']:checked").val();
		
		if(isEmpty(parcel_yn)){
// 			alert("배송유형을 선택해주세요.");
			var text = "배송유형을 선택해주세요.";
    		openLayerPopText2(text,but1text,but1func,but1width);
			$("#st_parcel_type").focus();
			return;
		}
		
		document.contentForm.st_parcel_yn.value =  parcel_yn;
		
		var carFlag = response.car_flag;
		
		//carFlag = "N";
		
		if(carFlag == "N"){
			//구매사 차량정보 입력 = "N" 경우 바로 명세서 생성.
			inSetInvoiceCreateDoosanmeca();				
		} else if(carFlag == "Y") {
			//공급사 차량정보 화면 오픈.
			doPop('commonMpIvDlvryCarPop', $("#st_agent_code").val());
			return;
		}
	} else if(pMethod == "btnSave"){
		setResult(response);
	} else if(pMethod == "saveChemInfo"){
		parent.doAction("search");
		parent.closePop3();
// 		window.open('', '_self').close(); // IE버전에 따른 창 닫기 여부 무시
	}else if(pMethod == "saveChemInfoMove"){
		parent.msdsMove();
		parent.closePop3();
// 		window.open('', '_self').close(); // IE버전에 따른 창 닫기 여부 무시
	}
	
	// 특수로직 추가 후 주석 풀기!!! 
	//opener.setQuery();
	//window.close();
	
	return;
}

function reloadFunc(){
	closePopText2();
	location.reload();
}
// 거래명세서 작성 성공 후 호출
function setResult(response){
	
	var inv_no = response.inv_no;
	var buyer = "<%=p_buyer%>";
	var tr_buyer = "<%=p_tr_buyer%>";
	var com_code = $("#st_com_code").val(); 
	
	
	var action_flag = response.action_flag;
	
	if(action_flag == "DO"){
// 		alert("해당건에 대해서 현재 작업중입니다.");
		var text = "해당건에 대해서 현재 작업중입니다.";
		var but1funcTmp = "javascript:reloadFunc();return false;";
		openLayerPopText2(text,but1text,but1funcTmp,but1width);
		return;
	}
	
	var stx_rpt = "<%=stx_rpt%>";
	var dsn_rpt = "<%=dsn_rpt%>";
	var ktag_rpt = "<%=ktag_rpt%>";
	var solb_legacy_po_no = "<%=dhim_legacy_po_no%>";
	var solb_if_buyer_flag = "<%=solb_if_buyer%>";
	
	/*
	if( ( buyer == "KRSTX-0001" || 
		buyer == "KRSTX-0002" ||
		buyer == "KRSTX-0003" ||
		buyer == "KRSTX-0005" ||
		buyer == "KRSTX-0006" ||
		buyer == "KRSTX-0007" ) && buyer == tr_buyer ) {	// KRSTX-0004 의 경우 B2B 사이트 거래명세서를 사용함.
	*/
	// P06-0000005 - 거래명세서 저장후, 거래명세서를 STX시스템에 등록
	if(stx_rpt == "Y" && buyer == tr_buyer){
// 		alert("거래명세서를 고객사 시스템에 등록중입니다.\n[거래명세서 출력 및 삭제] 에서 확인 하시기 바랍니다.\n(납품서 출력은 약 20분 후 가능합니다)");
		var text = "거래명세서를 고객사 시스템에 등록중입니다.</br>[거래명세서 출력 및 삭제] 에서 확인 하시기 바랍니다.</br>(납품서 출력은 약 20분 후 가능합니다)";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	} else if(solb_if_buyer_flag == "Y" && buyer == tr_buyer && solb_legacy_po_no == "4"){ // 솔브레인 IF 발주
// 		alert("거래명세서를 고객사 시스템에 등록중입니다.\n[거래명세서 출력 및 삭제] 에서 확인 하시기 바랍니다.\n(납품서 출력은 약 20분 후 가능합니다)");
		var text = "거래명세서를 고객사 시스템에 등록중입니다.</br>[거래명세서 출력 및 삭제] 에서 확인 하시기 바랍니다.</br>(납품서 출력은 약 20분 후 가능합니다)";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	} else {
// 		alert("거래명세서 생성이 완료 되었습니다.\n\n거래명세서 번호는  " + inv_no + " 입니다.");
		var text = "거래명세서 생성이 완료 되었습니다.</br>거래명세서 번호는  " + inv_no + " 입니다.";
		var but1funcTmp = "javascript:afterResult('"+inv_no+"'); return false;";
		openLayerPopText2(text,but1text,but1funcTmp,but1width);

		/*
		if(	
				buyer == "KRDHIM0002"
			||	buyer == "KRDHIM0003"  
			||	buyer == "KRDHIM0006"  
			||	buyer == "KRDHIM0005"  
			||	buyer == "KRDIGU0001"  
			||	buyer == "KRDAEW0043"  
			||	buyer == "KRDAEW0045" 
			||	buyer == "KRDOOS0020"
			||	buyer == "KRDIVC0001"
			||	buyer == "KRDIVC0002"
		){  
			*/
	}
}

function afterResult(inv_no){
	var buyer = "<%=p_buyer%>";
	var tr_buyer = "<%=p_tr_buyer%>";
	var com_code = $("#st_com_code").val(); 
	
	var stx_rpt = "<%=stx_rpt%>";
	var dsn_rpt = "<%=dsn_rpt%>";
	var ktag_rpt = "<%=ktag_rpt%>";
	var solb_legacy_po_no = "<%=dhim_legacy_po_no%>";
	var solb_if_buyer_flag = "<%=solb_if_buyer%>";
	
	if(dsn_rpt == "Y"){
		// P06-0000006 - 두산인프라코어 10개사의 경우 거래명세서 저장후, 리포트 오픈전, 인터페이스호출

		// 타사 인터페이스 추가해야함 - kkl 
		openIvUpdate(buyer, inv_no);  
		sheetWin(inv_no);
	
	} else if(buyer == "KRDAEW0016" || (buyer == "KRDOOD0001" && com_code != "KRMOOH0001") ){
		// 기존 특수로직 유지.		
    } else {
    	sheetWin(inv_no); //거래명세서 출력.
    }
	
	// 품목라벨 대상 고객사 아니더라도 창원센터로 납품은 모두 품목라벨 출력(실장님)
	if(ktag_rpt == "Y" || ("<%=p_tr_buyer%>" == "KRKORE0068" && "<%=st_no_itemTag_check_yn%>" == "N")){	
		if ($("#ktag_selectbox2").val() == "4") {
			sheetTagListWin4(inv_no);
		}else if ($("#ktag_selectbox2").val() == "12") {
			sheetTagListWin12(inv_no);
		}
	}
	
	parent.doAction("search");
	parent.closePop3();
}
	
// 두산인프라코어 10개사의 경우 거래명세서 저장후, 리포트 오픈전, 인터페이스호출
function openIvUpdate(buyer, inv_no){ 
	document.forms["contentForm"].st_buyer.value  = buyer;
	document.forms["contentForm"].st_inv_no.value  = inv_no;
	document.forms["contentForm"].st_type.value  = "INS";
	
	kepAjaxFormCall("/mpiv/saveKrdhimInvoice.do","contentForm","saveIvUpdate");
	
	/*
	document.forms.contentForm.target = "work";
	document.forms.contentForm.method = "post";
	document.forms.contentForm.action = "/kr/agent/invoice/krdhim_invoice_reg.jsp";
	document.forms.contentForm.submit();
	*/
}  

function sheetWin(inv_no) {
	var buyer				= "<%=p_buyer%>";
	var seller              = "<%=p_seller%>";
	var legacy_po_no        = "<%=p_legacy_po_no%>";
	var pur_id = $("#st_pur_id").val();
	
	var rpt_url	= "<%=rpt_url%>";
	var process_type = "<%=process_type%>";
	var tr_buyer = "<%=p_tr_buyer%>";
	
	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]";
	
    if(inv_no.length == 0 ){
//         alert("조회한 결과가 없습니다.");
        var text = "조회한 결과가 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }else{
      	if(process_type == "2" && "<%=st_no_tag_check_yn%>" == "N"){
   			var ktag_box_qty = $("#itemTag_box_qty").val();

   			if($("#st_print_size").val() == "N"){
   				rpt_url = "RD_06_S_001_170";
	   		}else if($("#st_print_size").val() == "L"){
	   			rpt_url = "RD_06_S_001_171";
	   		}
	   		
	   		param = "["+inv_no+"]["+seller+"]["+buyer+"]["+ktag_box_qty+"]";
	   		
	   		openTranStatReportOpen(rpt_url, param);
	   		
	   		if("<%=st_no_itemTag_check_yn%>" == "Y"){
				rpt_url = "<%=p070000034%>";
				param = "["+inv_no+"]["+seller+"]["+buyer+"]";
				
				openTranStatReportOpen(rpt_url, param);
			}
      	}else{
      		openTranStatReportOpen(rpt_url, param);
      	}
    }
}

function sheetTagListWin4(inv_no) {
	var buyer	= "<%=p_buyer%>"; 
	var seller	= "<%=p_seller%>";
	var legacy_po_no = "<%=p_legacy_po_no%>";
	var pur_id = $("#st_pur_id").val();
	var ktag_start = $("#ktag_selectbox").val();
	var url ="/coco/showReportViewer.do";
	var ktag_box_qty = 1;	// 품목태그는 수량 관계없이 항상 기본 1장씩 출력(한애희)
	var fileName = "";
	
   	if($("#st_print_size").val() == "L"){
 		fileName = "RD_06_X_002_20";
 	}else if($("#st_print_size").val() == "N"){
 		fileName = "RD_06_X_002_19";
 	}
	
   	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]";
   	
    reportOpen(fileName, param);
	return;
}

function sheetTagListWin12(inv_no) {

	
	var buyer	= "<%=p_buyer%>"; 
	var seller	= "<%=p_seller%>";
	var legacy_po_no = "<%=p_legacy_po_no%>";
	var pur_id = $("#st_pur_id").val();
	var ktag_start = $("#ktag_selectbox").val();
	var url ="/coco/showReportViewer.do";
	var ktag_box_qty = $("#ktag_box_qty").val();

	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]&inv_no="+inv_no+"&buyer="+buyer;
	reportOpen("RD_06_X_002_11", param); 
	return;
}

function openHttp(rptUrl, winName){
	var param = "";
	
	if(rptUrl.indexOf("doowin") > -1){
		// http://doowin.doosaninfracore.com/keplogin.do
		var _option = buildOption("1024,760,no");
		
		var agent = $("#st_com_code").val();
		var agent_name = $("#st_com_name").val();
		var legacy_po_no = "<%=p_legacy_po_no%>";
		
		var legacy_po_seq = "00001";
        var sap_user = "20493";
        var sap_password = "20493";
        
		param 	 = "?agent=" + agent;
		param	+= "&agent_name=" + agent_name;
		param	+= "&po_no=" + legacy_po_no;
		param	+= "&po_seq=" + legacy_po_seq;
		param	+= "&portal_user_id=" + sap_user;
		param	+= "&portal_password=" + sap_password;
		
		window.open(rptUrl+param, winName, _option );
		
	} else {
		// http://ez-van.doosaninfracore.co.kr/dhivan2/kep/index.asp
		var com_code = $("#st_com_code").val();
	
		var _option = buildOption("1015,700,no");
		param = "?kepvndno="+com_code;
		
		window.open(rptUrl+param, winName, _option );
	}
	
	parent.closePop3();
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	return;
}


function update_qty(row){
	var buyer		= "<%=p_buyer%>"; 
	var inv_date	= "";
	var agent		=  $("#st_agent_code").val();

    if (row!= null){ // 납품서 생성버튼 클릭시 한번 더 호출할껀데 이때 row없음 
    	var imsi_qty            = mySheet.GetCellValue(row,"INV_POSS_QTY").toString();       // 납품수량
        var imsi_poss_cd_qty    = mySheet.GetCellValue(row,"ORG_INV_POSS_QTY");        		 // 납품가능수량
        var imsi_agent_price    = mySheet.GetCellValue(row,"UNIT_PRICE");       			 // 단가

        if( !chkDecimal(imsi_qty,3) ){
//             alert("납품수량은 소숫점 3자리 까지 입력 가능합니다. 확인 후 다시 입력해 주십시요");
            var text = "납품수량은 소숫점 3자리 까지 입력 가능합니다. 확인 후 다시 입력해주세요.";
    		openLayerPopText2(text,but1text,but1func,but1width);
            mySheet.SetCellValue(row,"INV_POSS_QTY",mySheet.GetCellValue(row,"ORG_INV_POSS_QTY"));
            sum_price();
            return;
        }

        if(imsi_qty!=""){
        	mySheet.SetCellValue(row,"SELLER_AMT2",imsi_agent_price*mySheet.GetCellValue(row,"INV_POSS_QTY"));
        	mySheet.SetCellValue(row,"SELLER_AMT",mySheet.GetCellValue(row,"SELLER_AMT2"));
        }
    }
    sum_price();
}

function update_len_qty(row){
	var buyer		= "<%=p_buyer%>"; 
	var inv_date	= "";
	var agent		=  $("#st_agent_code").val();

    if (row!= null){ // 납품서 생성버튼 클릭시 한번 더 호출할껀데 이때 row없음 
        var imsi_poss_cd_qty	= mySheet.GetCellValue(row,"INV_POSS_QTY");       // 납품가능수량
        var imsi_agent_price		= mySheet.GetCellValue(row,"UNIT_PRICE");        // 단가
        var imsi_size_len			= mySheet.GetCellValue(row,"SIZE_LEN");        // 길이
        var imsi_size_qty			= mySheet.GetCellValue(row,"INV_POSS_SIZE_QTY").toString();        // 수량
        var ori_size_qty			= mySheet.GetCellValue(row,"ORG_INV_POSS_SIZE_QTY");        // 변경 전 수량
        var imsi_qty				= imsi_size_len * imsi_size_qty;                // 납품수량
        var ori_qty					= imsi_size_len * ori_size_qty;                // 변경 전 납품수량
        
        if( !chkDecimal(imsi_size_qty,2) ){
//             alert("수량은 소숫점 2자리 까지 입력 가능합니다. 확인 후 다시 입력해 주십시요");
            var text = "수량은 소숫점 2자리 까지 입력 가능합니다. 확인 후 다시 입력해 주세요.";
    		openLayerPopText2(text,but1text,but1func,but1width);
            mySheet.SetCellValue(row,"INV_POSS_SIZE_QTY",mySheet.GetCellValue(row,"ORG_INV_POSS_SIZE_QTY"));
            sum_price();
            
            return;
        }else{
        	mySheet.SetCellValue(row,"SELLER_AMT2",imsi_agent_price*mySheet.GetCellValue(row,"INV_POSS_SIZE_QTY"));
        	mySheet.SetCellValue(row,"SELLER_AMT",mySheet.GetCellValue(row,"SELLER_AMT2"));
        }
    }

    sum_price();
}

function sum_price(){
    var sum_price = 0;
    var sheet_sum_price = 0;
    
    var sRow = mySheet.FindCheckedRow("SELECTED");
	var arrRow = sRow.split("|");
	
	for(var i = 0; i<arrRow.length; i++){
		sum_price += mySheet.GetCellValue(arrRow[i], "SELLER_AMT2");
		sheet_sum_price += mySheet.GetCellValue(arrRow[i], "SELLER_AMT");
	}

    // 공급가액
    // 부가세(공급가액 10%)
    // 부가세비율(0.1)
    // 총금액(공급가액+부가세)
    var tax_amt  = Math.floor(sum_price/10);
    var sheet_tax_amt  = Math.floor(sheet_sum_price/10);

    document.contentForm.st_inv_amt.value                  =   sum_price;
    document.contentForm.st_inv_tax_amt.value              =   tax_amt;
    document.contentForm.st_inv_tot_amt.value              =   eval(sum_price) + eval(tax_amt);

    document.contentForm.sheet_inv_amt.value        =   sheet_sum_price;
    document.contentForm.sheet_inv_tax_amt.value    =   sheet_tax_amt;
    document.contentForm.sheet_inv_tot_amt.value    =   eval(sheet_sum_price) + eval(sheet_tax_amt);
}

function checkRemark(){
	
    if(kepGetByteLength("st_remark")>120){
//         alert("비고란에 입력한 내용이 입력가능한 크기를 초과하였습니다.\n\n※한글(2byte) 영문,숫자,특수문자(1byte)로 120byte를 초과할 수 없습니다.");
        var text = "비고란에 입력한 내용이 입력가능한 크기를 초과하였습니다.</br>※한글(2byte) 영문,숫자,특수문자(1byte)로 120byte를 초과할 수 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
        document.forms["contentForm"].st_remark.focus();
        return ;
    }   
}

function reqAndClose(){
	closePopText1();
    
    document.forms["contentForm"].st_query.value = g_query;
	kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteChemicalInfo.do","contentForm","saveChemInfo");
}
function reqAndMove(){
	closePopText1();
    
    document.forms["contentForm"].st_query.value = g_query;
	kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteChemicalInfo.do","contentForm","saveChemInfoMove");
}
function layerPopClose(){
	closePopText1();
    parent.doAction('search');
    parent.closePop3();
}
function layerPopMove(){
	closePopText1();
    parent.msdsMove();
    parent.closePop3();
}
function checkNumber(el){
	el.value = el.value.replace(/\s/g,"");
	if(el.value == ""){
		el.value = "1";
	}
	if(isNaN(el.value)){
// 		alert("숫자형식으로 입력해주시기 바랍니다.");
		 var text = "숫자형식으로 입력해주시기 바랍니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
		el.value = "1";
		el.focus();
		return;
	}
	if(el.value != "" && Number(el.value) < 1){
// 		alert("최소 박스수량은 1개입니다.");
		 var text = "최소 박스수량은 1개입니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
		el.value = "1";
		el.focus();
		return;
	}
	if(el.value != "" && Number(el.value) > 50){
// 		alert("최대 50개까지 입력 가능합니다.");
		 var text = "최대 50개까지 입력 가능합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
		el.value = "1";
		el.focus();
		return;
	}
	el.value = Number(el.value);
}
</script> 

<body>
<form name = "contentForm" id="contentForm" method = "post">
<input type="hidden" name="s_SAVENAME" />
<!-- HIDDEN -->
<input type="hidden" name="st_buyer" id="st_buyer" value="<%=p_buyer%>">
<input type="hidden" name="st_po_no" id="st_po_no" value="<%=p_po_no%>">
<input type="hidden" name="st_ds_date" id="st_ds_date" value="<%=p_ds_date%>">

<input type="hidden" name="st_query"            value="">
<input type="hidden" name="st_seller"           value="<%=p_seller%>">
<input type="hidden" name="st_process_type"     value="<%=process_type%>">
<input type="hidden" name="st_legacy_po_no"     value="<%=p_legacy_po_no%>">

<input type="hidden" name="st_action_id"		value="<%=action_id%>">
<input type="hidden" name="st_inv_no"			value="">
<input type="hidden" name="st_type"				value="">
<input type="hidden" name="st_car_info"			value="">
<input type="hidden" name="st_car_flag"			value="N">
<input type="hidden" name="st_add_user_id"		value="<%=p_add_user_id%>">

<input type="hidden" name="st_user_id"  id="st_user_id" value="<%=p_user_id%>">
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
<input type="hidden" name="st_com_name" id="st_com_name" value="${sessionInfo.comNameLoc}">

<input type="hidden" name="st_agent_code" id="st_agent_code" value="<%=p_agent%>">

<input type="hidden" name="st_proxy_yn" id="st_proxy_yn" value="<%=p_proxy_yn%>">
<input type="hidden" name="st_kep_id" id="st_kep_id" value="<%=p_kep_id%>">
<input type="hidden" name="st_gbn" id="st_gbn" value="WR">

<input type="hidden" name="st_parcel_yn" id="st_parcel_yn" value="<%=parcel_yn%>">
<input type="hidden" name="p070000033" id="p070000033" value="<%=p070000033%>">
<input type="hidden" id="legacy_po_seq_tot" name="legacy_po_seq_tot"   value="">
<input type="hidden" id="st_pur_id"			name="st_pur_id"		value="">
<input type="hidden" id="st_inv_data"		name="st_inv_data"   	value="">
	  <%if(!com_type.equals("W")){%>
	  <%}else{%>
		<input type="hidden"   name="st_inv_tot_amt_text" size="14" value="<%=CommonUtil.formatNumber(seller_amt,true,0,3)%> 원"  READONLY >
	  <%}%>
        <input type="hidden" name="st_inv_tot_amt" value ="<%=seller_amt%>">
      	<input type="hidden" name="st_inv_amt_text" size="14" class="ar input_type_text" style="background-color:#FFFFFF;border:#FFFFFF 1px solid;" value="<%=CommonUtil.formatNumber(seller_amt,true,0,3)%> 원"  READONLY >
       	<input type="hidden" name="st_inv_amt" value ="<%=seller_amt%>">
		<input type="hidden" name="sheet_inv_amt"     value="<%=sheet_inv_amt%>">
		<input type="hidden" name="sheet_inv_tax_amt" value="<%=sheet_inv_tax_amt%>">
		<input type="hidden" name="sheet_inv_tot_amt" value="<%=sheet_inv_tot_amt%>">
		<input type="hidden" name="st_inv_tax_amt_text" size="14" class="ar input_type_text" style="background-color:#FFFFFF;border:#FFFFFF 1px solid;" value="<%=CommonUtil.formatNumber(surtax,true,0,3)%> 원"  READONLY >
		<input type="hidden" name="st_inv_tax_amt"  value ="<%=surtax%>">  <!-- 부가세(10%)   공급가액의 10% -->                                               
		<input type="hidden" name="st_inv_tax_rate" value ="0.1">          <!-- 부가세(10%) , 부가세 비율 10 * 0.01 -->
		
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
<div class="wrapPopup">
  <div class="PopupTit">거래명세서 상세<span><a href="javascript:parent.closePop3();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="PopupTitSub">발주정보 
  <%
	if(doc_type.equals("S")){
  %>
	<span style=" position:absolute; right:0px; font-size:13px">※ 선입고 발주건입니다.&nbsp;&nbsp;&nbsp;&nbsp;</span>
  <%
	} else if(doc_type.equals("F")){
  %>
	<span style=" position:absolute; right:0px; font-size:13px">※ 긴급 발주건입니다.&nbsp;&nbsp;&nbsp;&nbsp;</span>
  <%
	}
  %> 
  </div>
  <table class="PopupTableTxt" width="1200px">
    <colgroup>
      <col width="120px" />
      <col width="170px" />
      <col width="120px" />
      <col width="170px" />
      <col width="120px" />
      <col width="190px" />
      <col width="120px" />
      <col width="190px" />
  	</colgroup>
    <tr>
      <th>발주번호</th>
      <td><%=po_no%></td>
      <th>발주일</th>
      <td><%=po_create_date%></td>
      <th>고객사</th>
      <td><%=seller_buyer%></td>
      <th>발주자</th>
      <td>김구매</td>
    </tr>
    <tr>
<!--       <th>인수자명</th> -->
<!--       <td>김구매</td> -->
<!--       <th>연락처</th> -->
<!--       <td>02-1111-1111</td> -->
      <th>거래유형</th>
      <td><%=process_name %></td>
      <th>KeP담당자</th>
      <td colspan="5"><%=kep_user_info %></td>
    </tr>
    <tr>
      <th>비고</th>
      <td colspan="7"><%=po_remark %></td>
    </tr>
    <tr>
      <th>배송지</th>
      <td colspan="7"><%=dely_to_location%>
      <%if(process_type.equals("2")){%>
		&nbsp;/ 수령자: 센터장&nbsp;/ 연락처 : <%=center_tel_no%>
		<br/> 
		<font color="F6495F"><b>&nbsp;택배 발송 시 상단의 센터 정보로 입력하여 발송바랍니다.</b></font>
	  <%} %>
      </td>
    </tr>
    <tr>      
      <th>배송 특이사항</th>
      <td colspan="7"><%=delivery_remark %></td>
    </tr>       
  </table>  
    <div class="PopupTitSub">거래명세서 생성 설정</div>
  <table class="PopupTableTxt" width="1200px">
    <colgroup>
      <col width="120px" />
      <col width="170px" />
      <col width="120px" />
      <col width="170px" />
      <col width="120px" />
      <col width="190px" />
      <col width="120px" />
      <col width="190px" />
  	</colgroup>
    <tr>
      <th>납품일</th>
      <td><div class="datepicker-wrap" style=" width:120px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_invoice_date_text" name="st_invoice_date_text" readonly /><span> </span></div>
                </div>
        </td>
      <th>배송유형</th>
      <td>
			<label class="RadioSmallLabel" style="font-size: 14px; margin: 0px 9px;"><input type="radio" name="st_parcel_type" value="Y"><span class="RadioSmallTxt"></span>택배</label>
        	<label class="RadioSmallLabel" style="font-size: 14px; margin: 0px 9px;"><input type="radio" name="st_parcel_type" value="N"><span class="RadioSmallTxt"></span>자차</label>
	  </td>
	  <%if(process_type.equals("2") || ktag_rpt.equals("Y")){ %>
      <th>라벨출력방식</th>
      <td>
      	  <select name="st_print_size" id="st_print_size" class="Select" style="width:98%">
		   <option value="N" selected>일반프린터(A4 4분할)</option>
		   <option value="L">라벨프린터(10x10cm)</option>
          </select>
      </td>
      <th>박스수량</th>
      <td>
      	<input type="Text" maxlength="2" name="itemTag_box_qty" id="itemTag_box_qty" class="input30" value="1" style="width:20%; text-align: right; " onblur="checkNumber(this);">
      </td>
      <%}else{ %>
      	<td colspan = "4"></td>
      <%} %>
    </tr>
    <tr style="display: none;">
    	<th>메모</th>
    	<td colspan = "7"><input type="text" id="st_remark" name="st_remark" maxlength="120" value="" style="width: 98%; height: 90%; border: 1px solid #dedede;" onChange="checkRemark()"></td>
    </tr>       
  </table>  
  <div class="PopupTitSub" style="position:relative;width:1200px;">
    품목  <p style="display:inline-block; margin-left:5px" id="itemCnt">0</p>
    
    금액  <p style="display:inline-block; margin-left:5px" id="itemAmt">0</p> 
    
  </div>  
  <div class="IBSheetTablePopup" width="1200px">
  	<script type="text/javascript">
		createIBSheet("mySheet", "", "100%");
    </script>
  </div>  
  <div class="h30"></div>
  							<%
							if(ktag_rpt.equals("Y") || (p_tr_buyer.equals("KRKORE0068") && st_no_itemTag_check_yn.equals("N"))){
							%>
								<span class ="btn_10_blue mr04" style="vertical-align:top; line-height:22px;padding-top:2px; color:#FFF; display:none;">
									KTAG출력위치
									<select id="ktag_selectbox" name="ktag_selectbox" style="width:40px; margin-top:3px">
				                    <option value="1" selected>1</option>
				                    <option value="2" >2</option>
				                    <option value="3" >3</option>
				                    <option value="4" >4</option>
				                    <option value="5" >5</option>
				                    <option value="6" >6</option>
				                    <option value="7" >7</option>
				                    <option value="8" >8</option>
				                    <option value="9" >9</option>
				                    <option value="10" >10</option>
				                    <option value="11" >11</option>
				                    <option value="12" >12</option>
				                    </select> 
          				       </span>
          				       <span class ="btn_10_blue mr04" style="width:115px;vertical-align:top; line-height:22px;padding-top:2px; color:#FFF; display:none;">
		                        	박스수량: 
			                        <select id="ktag_box_qty" name="ktag_box_qty" style="width:40px; margin-top:3px">
			                        <option value="1" >1</option>
			                        <option value="2" >2</option>
			                        <option value="3" >3</option>
			                        <option value="4" >4</option>
			                        <option value="5" >5</option>
			                        <option value="6" >6</option>
			                        <option value="7" >7</option>
			                        <option value="8" >8</option>
			                        <option value="9" >9</option>
			                        <option value="10" >10</option>
			                        <option value="11" >11</option>
			                        <option value="12" >12</option>
			                        <option value="13" >13</option>
			                        <option value="14" >14</option>
			                        <option value="15" >15</option>
			                        <option value="16" >16</option>
				                    <option value="17" >17</option>
				                    <option value="18" >18</option>
				                    <option value="19" >19</option>
				                    <option value="20" >20</option>
				                    <option value="21" >21</option>
				                    <option value="22" >22</option>
				                    <option value="23" >23</option>
				                    <option value="24" >24</option>
				                    <option value="25" >25</option>
				                    <option value="26" >26</option>
				                    <option value="27" >27</option>
				                    <option value="28" >28</option>
				                    <option value="29" >29</option>
				                    <option value="30" >30</option>
			                        </select> 
			                    </span>	
			                    
								<span class="btn_10_blue mr04" style="vertical-align:top; line-height:22px;padding-top:2px; color:#FFF; display:none;">
									K tag출력
									<select id="ktag_selectbox2" name="ktag_selectbox2" style="width:60px; margin-top:3px">
				                    <option value="12" >12칸</option>
				                    <option value="4" selected>4칸</option>
				                    </select> 
								</span>
							<%} %>
  <div class="PopupListBtnBox_Center" style="width:1190px;">
    <button class="ButPrimary_large" onclick="javascript:setInvoiceCreateDoosanmeca(); return false;" >거래명세서 생성</button>
  </div>  
</div><!-- warp 끝-->
</form> 

<!-- 두산시스템 전송용 POST방식 20170627 HSJ-->
<form id="doowinForm" name="doowinForm" method="post">
	<input type="hidden" id="agent" name="agent" value =""/>
	<input type="hidden" id="agent_name" name="agent_name" value =""/>
	<input type="hidden" id="po_no" name="po_no" value =""/>
	<input type="hidden" id="po_seq" name="po_seq"	value="">
	<input type="hidden" id="portal_user_id" name="portal_user_id" value =""/>
	<input type="hidden" id="portal_password" name="portal_password" value =""/>
	<input type="hidden" id="lang_cd" name="lang_cd" value =""/>
</form>
</body>
</html>
