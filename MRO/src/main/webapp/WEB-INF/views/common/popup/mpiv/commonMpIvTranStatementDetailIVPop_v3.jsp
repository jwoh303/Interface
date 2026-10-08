<%--
**********************************************
* 메뉴 : 
* 화면 : 거래명세서 상세조회IV
* 기능 : 
* 프로그램 ID : SU0501004
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
</head>
<%
	@SuppressWarnings (value="unchecked")

	String p_buyer			= CommonUtil.nvl((String)request.getAttribute("st_buyer"));
	String p_po_no			= CommonUtil.nvl((String)request.getAttribute("st_po_no"));
	String p_inv_no			= CommonUtil.nvl((String)request.getAttribute("st_inv_no"));
	String p_ds_date		= CommonUtil.nvl((String)request.getAttribute("st_ds_date"));
	String p_seller			= CommonUtil.nvl((String)request.getAttribute("st_seller"));
	String p_process_type	= CommonUtil.nvl((String)request.getAttribute("st_process_type"));
	String p_legacy_po_no	= CommonUtil.nvl((String)request.getAttribute("st_legacy_po_no"));
	
	String p_tr_buyer		= CommonUtil.nvl((String)request.getAttribute("st_tr_buyer"));
	
	String p_dely_to_location = CommonUtil.nvl((String)request.getAttribute("st_dely_to_location"));
	String p_add_user_id      = CommonUtil.nvl((String)request.getAttribute("st_add_user_id"));
	String legacy_iv_serial	= CommonUtil.nvl((String)request.getAttribute("st_legacy_iv_serial"));
	
	String session_com_code = CommonUtil.nvl(_sessionInfo.getComCode());
	
	//조회결과 - 상세정보
	Map<String,String> detailInfo = (Map<String,String>) request.getAttribute("info");
	
	String po_no = "";
	String po_create_date = "";
	String purchaser_name = "";
	String agent_po_ttl_amt = "";
	String tel_no = "";
	String po_remark = "";
	String inv_amt = "";
	String seller_buyer = "";
	String ds_date = "";
	String inv_tax_amt = "";
	String seller_com_name = "";
	String inv_ttl_amt = "";
	String dely_to_location = "";
	String doc_type = "";
	String kepmro_doc_type = "";
	String remark_inv = "";
	String inv_date = "";
	String process_type = "";
	String iv_serial = "";
	
	String stx_rpt = "";
	String dsn_rpt = "";
	String rpt_url = "";
	
	String btn_yn = "";		// 저장,삭제버튼 출력여부 11 : 노출, 00 : 비노출
	String btn_nm = "";		// 거래명세서 출력 버튼명
	String extr_rpt = "";	// 납품지시서 리포트 출력여부
	String ktag_rpt = "";	// KTAG 사용여부
	String parcel_yn ="";	// 배송유형
	String delivery_remark = "";
	String ap_bill_flag = "";
	
	if(detailInfo != null){
		po_no 				= CommonUtil.nvl(detailInfo.get("PO_NO"));
		purchaser_name 		= CommonUtil.nvl(detailInfo.get("PURCHASER_NAME"));
		po_create_date 		= CommonUtil.formatStrinigDate(CommonUtil.nvl(detailInfo.get("PO_CREATE_DATE")));
		agent_po_ttl_amt	= CommonUtil.formatNumber(CommonUtil.nvl(detailInfo.get("AGENT_PO_TTL_AMT")),true,0,3);
		tel_no 				= CommonUtil.nvl(detailInfo.get("TEL_NO"));
		po_remark 			= CommonUtil.nvl(detailInfo.get("PO_REMARK"));
		inv_amt 			= CommonUtil.nvl(detailInfo.get("INV_AMT"));
		seller_buyer 		= CommonUtil.nvl(detailInfo.get("SELLER_BUYER"));
		ds_date 			= CommonUtil.formatStrinigDate(detailInfo.get("DS_DATE"));
		inv_tax_amt 		= CommonUtil.nvl(detailInfo.get("INV_TAX_AMT"));
		seller_com_name 	= CommonUtil.nvl(detailInfo.get("SELLER_COM_NAME"));
		inv_ttl_amt 		= CommonUtil.nvl(detailInfo.get("INV_TTL_AMT"));
		dely_to_location 	= CommonUtil.nvl(detailInfo.get("DELY_TO_LOCATION"));
		doc_type 			= CommonUtil.nvl(detailInfo.get("DOC_TYPE"));
		kepmro_doc_type		= CommonUtil.nvl(detailInfo.get("KEPMRO_DOC_TYPE"));
		remark_inv			= CommonUtil.nvl(detailInfo.get("REMARK_INV"));		
		inv_date 			= CommonUtil.formatStrinigDate(detailInfo.get("INV_DATE"));
		iv_serial			= CommonUtil.nvl(detailInfo.get("IV_SERIAL"));
		
		process_type		= CommonUtil.nvl(detailInfo.get("PROCESS_TYPE"));
		
		stx_rpt		= CommonUtil.nvl(detailInfo.get("STX_RPT"));
		dsn_rpt		= CommonUtil.nvl(detailInfo.get("DSN_RPT"));
		
		rpt_url		= CommonUtil.nvl(detailInfo.get("RPT_URL"));
		
		btn_yn		= CommonUtil.nvl(detailInfo.get("BTN_YN"));
		btn_nm		= CommonUtil.nvl(detailInfo.get("BTN_NM"));
		extr_rpt	= CommonUtil.nvl(detailInfo.get("EXTR_RPT"));
		ktag_rpt	= CommonUtil.nvl(detailInfo.get("KTAG_RPT"));
		parcel_yn	= CommonUtil.nvl(detailInfo.get("PARCEL_YN"));
		delivery_remark = CommonUtil.nvl(detailInfo.get("DELIVERY_REMARK"));
		ap_bill_flag = CommonUtil.nvl(detailInfo.get("AP_BILL_FLAG"));
	}
	
	String legacy_flag = "";
	
	if(p_legacy_po_no.equals("") || p_legacy_po_no.equals("N")){
		legacy_flag = "N";
	}else{
		legacy_flag = "Y";
	}
	
	String dhim_legacy_po_no = "";

	if(p_legacy_po_no.length() > 1){
		dhim_legacy_po_no = p_legacy_po_no.substring(0,1);
	}

	/*
	장바구니 필드추가 제어 
	-TYPE1: 윈체  수량길이 필드 추가
	*/
	String p060000080 =  CommonUtil.getSpecialCheckReturn(p_buyer,"P06-0000080","COL01_DATA");
	//SLOGIC-END
	
	// 솔브레인 관련 IF발주번호 확인
	String solb_if_buyer = "N";
	boolean p070000032 = CommonUtil.getSpecialCheckReturn(p_buyer,"P07-0000032");
	if(p070000032 == true){
		solb_if_buyer = "Y";
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
var grbSrc = "";

var today = kepGetNowTimeStr("YYYYMMDD","");
var fromDate = kepToDateAdd("7","M","noslash");
var toDate = kepToDateAdd("7","P","noslash");

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

//최초 화면 함수 
function kep_onload_view(){

	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			 ,{ Align:"Left",	SaveName:"BUYER",				Header:"고객사",				Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:true}
			 ,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text", FontColor:"#3a72c7", Cursor:"Pointer",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"MSDS_YN",				Header:"MSDS",				Type:"Button",		Width:80,	Edit:false,	EditLen:100,	Hidden:true,ClassName :'Type02'}
			,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"품목명",				Type:"Text",		Width:230,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",				Type:"Text",		Width:230,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"AGENT_PRICE",			Header:"단가",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Format:"${priceFormat}"}
			,{ Align:"Right",	SaveName:"ITEM_QTY",			Header:"수량",				Type:"Text",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"INV_QTY",				Header:"납품수량",				Type:"Float",		FontColor:"#3a72c7", Cursor:"Pointer",Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"RD_DATE",				Header:"수령희망일",			Type:"Date",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			,{ Align:"Center",	SaveName:"DS_DATE",				Header:"납품예정일",			Type:"Date",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			<%if(p060000080.equals("TYPE1")) {%>
			,{ Align:"Left",	SaveName:"SIZE_LEN_QTY",		Header:"길이/수량",			Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"SIZE_YN",				Header:"SIZE_YN",			Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Left",	SaveName:"SIZE_LEN",			Header:"SIZE_LEN",			Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Left",	SaveName:"SIZE_QTY",			Header:"SIZE_QTY",			Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:true}
			<%}%>
			,{ Align:"Left",	SaveName:"PO_REMARK",			Header:"품목비고",				Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"INV_NO",				Header:"INV_NO",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"INV_SEQ",				Header:"INV_SEQ",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PO_NO",				Header:"PO_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PO_SEQ",				Header:"PO_SEQ",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			
			,{ Align:"Center",	SaveName:"CONTRACT_NO",			Header:"CONTRACT_NO",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"CONTRACT_SEQ",		Header:"CONTRACT_SEQ",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",	Header:"BYIT_COMORG_CODE",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"MSDS_NO",				Header:"MSDS_NO",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"KTAG_QTY",			Header:"KTAG_QTY",			Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PURCHASER_ID",		Header:"PURCHASER_ID",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"LEGACY_IV_NO",		Header:"LEGACY_IV_NO",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "MSDS_YN");
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet.SetTheme("DB", "DeepBlue");
	
	kepSearch(document.contentForm, mySheet, "/mpiv/getCommonMpIvTranStatementDetailIVPop_v2.do" , pagingMode);
}
</script>
<script type="text/javascript">
//팝업호출

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	$("#itemCnt").html("("+mySheet.RowCount()+")");
// 	$("#buyerItemCnt").text(mySheet.RowCount());
	$("#st_rd_date").val(mySheet.GetCellValue(1,"RD_DATE").replace(/-/g,""));
	$("#st_pur_id").val(mySheet.GetCellValue(mySheet.LastRow(),"PURCHASER_ID"));
	$("#st_legacy_iv_no").val(mySheet.GetCellValue(mySheet.LastRow(),"LEGACY_IV_NO"));
	var p060000080 = "<%=p060000080%>";
	
	for(var i = 1; i<=mySheet.RowCount();i++){
		if(p060000080 == "TYPE1"){
			if(mySheet.GetCellValue(i,"SIZE_YN") == "Y"){
				mySheet.SetCellValue(i,"SIZE_LEN_QTY",mySheet.GetCellValue(i,"SIZE_LEN")+"/"+mySheet.GetCellValue(i,"SIZE_QTY"));
			}
		}
	}
	
	
	
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
	var st_image_key = mySheet.GetCellValue(Row, "IMAGE_KEY");
	var st_contract_no = mySheet.GetCellValue(Row, "CONTRACT_NO");
	var st_contract_seq = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
	var st_buyer = mySheet.GetCellValue(Row, "BYIT_COMORG_CODE");
	var st_msds_yn = mySheet.GetCellValue(Row, "MSDS_YN");
	var st_msds_no = mySheet.GetCellValue(Row, "MSDS_NO");
	var st_inv_seq = mySheet.GetCellValue(Row, "INV_SEQ");
	var st_inv_qty = mySheet.GetCellValue(Row, "INV_QTY");
	var st_po_no = mySheet.GetCellValue(Row, "PO_NO");
	var st_po_seq = mySheet.GetCellValue(Row, "PO_SEQ");
	var st_description = mySheet.GetCellValue(Row, "DESCRIPTION");
	var ktag_rpt = "<%=ktag_rpt%>";
	var tr_buyer = "<%=p_tr_buyer%>";
	var st_no_itemTag_check_yn = "<%=st_no_itemTag_check_yn%>";
	

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

	if(column == "INV_QTY"){
		var p_buyer = "<%=p_buyer%>";
		var p_inv_no = "<%=p_inv_no%>";
// 		if(ktag_rpt == "Y" || (tr_buyer == "KRKORE0068" && st_no_itemTag_check_yn == "N")){
			setKtagDivide(p_buyer,p_inv_no,st_inv_seq,st_buyer_item_no,st_inv_qty,st_description,st_po_no,st_po_seq);
// 		}
	}
	return;
}

//Ktag 분할팝업
function setKtagDivide( buyer, inv_no, inv_seq , buyer_item_no , item_qty ,description ,po_no,po_seq,  x ){
    if(item_qty ==1){   
//         alert("수량 1개의 품목은 분할하실 수 없습니다.");
        var text = "수량 1개의 품목은 분할하실 수 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }

    grbSrc = "/mpiv/getsellerMpIvKtagPlanEntryPop.do?st_buyer="+buyer+"&st_inv_no="+inv_no+"&st_inv_seq="+inv_seq +"&st_buyer_item_no="+buyer_item_no+"&st_item_qty="+item_qty+"&st_description="+description+"&st_po_no="+po_no+"&st_po_seq="+po_seq;

//         if(!confirm("Ktag출력시 수량분할하시겠습니까?")) return;
    var text = "Ktag출력시 수량분할하시겠습니까?";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:setKtagDividePop(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);


    
//     document.forms.sellerMpIvObtnodrReceiptDetailPop.x.value = x;
// 		var src = "/mpiv/getsellerMpIvKtagPlanEntryPop.do?st_buyer="+buyer+"&st_inv_no="+inv_no+"&st_inv_seq="+inv_seq +"&st_buyer_item_no="+buyer_item_no+"&st_item_qty="+item_qty+"&st_description="+description+"&st_po_no="+po_no+"&st_po_seq="+po_seq;
// 		openLayerPop2(src,"650px","500px");
//      openSearchPopup("/mpiv/getsellerMpIvKtagPlanEntryPop.do", "?st_buyer="+buyer+"&st_inv_no="+inv_no+"&st_inv_seq="+inv_seq +"&st_buyer_item_no="+buyer_item_no+"&st_item_qty="+item_qty+"&st_description="+description+"&st_po_no="+po_no+"&st_po_seq="+po_seq, "520,500,no");
    
}
function setKtagDividePop(){
	closePopText1();
	openLayerPop2(grbSrc,"650px","500px");
	grbSrc = "";
}
//대우조선 납품지시서
function sheetWinDaewoo3(){
	var agent_code  = "${sessionInfo.comCode}";
	window.open("/kr/epro/buy/sheet/daewoo_delivery_order_list.jsp?agent_code="+agent_code,"sheetWin_TEST_3","toolbar=yes,width=700,height=600,resizable=YES,scrollbars=YES,top=0,left=0");
}
function sheetWin() {
	var buyer	= "<%=p_buyer%>";
	var legacy_flag	= "<%=legacy_flag%>";
	var process_type = "<%=process_type%>";
	var rd_date = $("#st_rd_date").val();
	var solb_legacy_po_no = "<%=dhim_legacy_po_no%>";
	var solb_if_buyer_flag = "<%=solb_if_buyer%>";
	
	if(buyer=="KRKORE0212"){
		var dateArr =  setDateMsg(rd_date);

		var msg = "고객사 납품요구일이 " + dateArr[0] +" 입니다.</br>"
				+ dateArr[1] + " ~ " + dateArr[2] + " 기간내에만 출력이 가능합니다.</br>"
				+ "(문의사항: 변상남 대리, 055-270-6208 / 010-2058-4564)";

		var from_date = dateArr[1].replace(/[/]/gi,"");
		var to_date = dateArr[2].replace(/[/]/gi,"");
		
		if( eval(today) < eval(from_date) || eval(today) > eval(to_date) ){
// 			alert(msg);
			var text = msg;
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}

	var seller	= "<%=p_seller%>";
	var inv_no	= "<%=p_inv_no%>";
	var rpt_url = "<%=rpt_url%>";
	var legacy_po_no = "<%=p_legacy_po_no%>";
	var pur_id = $("#st_pur_id").val();
	var legacy_iv_serial = "<%=legacy_iv_serial%>";
	var tr_buyer = "<%=p_tr_buyer%>";

	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]";
	
	if(solb_if_buyer_flag == "Y" && solb_legacy_po_no == "4" && process_type == "0" && legacy_iv_serial == ""){ // 솔브레인 IF 발주
// 		alert("거래명세서를 고객사 시스템에 등록중입니다.(납품서 출력은 약 20분 후 가능합니다)\n출력이 지연되면 KeP담당자에게 문의하시기 바랍니다.");
		var text = "거래명세서를 고객사 시스템에 등록중입니다.(납품서 출력은 약 20분 후 가능합니다)</br>출력이 지연되면 KeP담당자에게 문의하시기 바랍니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	if(process_type == "2" && "<%=st_no_tag_check_yn%>" == "N"){
		var print_size = $("#st_print_size").val();
		var ktag_box_qty = $("#itemTag_box_qty").val();
		
		if(isEmpty(print_size)){
// 			alert("라벨출력방식을 선택해주세요.");
			var text = "라벨출력방식을 선택해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			$("#st_print_size").focus();
			return;
		}
		
		if(print_size == "N"){
   			rpt_url = "RD_06_S_001_170";
   		}else if(print_size == "L"){
   			rpt_url = "RD_06_S_001_171";
   		}
		
		param = "["+inv_no+"]["+seller+"]["+buyer+"]["+ktag_box_qty+"]";
		
		openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
		
		if("<%=st_no_itemTag_check_yn%>" == "Y"){
			rpt_url = "<%=p070000034%>";
			param = "["+inv_no+"]["+seller+"]["+buyer+"]";
			
			openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
		}
	}else{
	   	openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
	}
	
	
	
   	
	return;
}
	
function setDateMsg(date){  

	var fRdDate = kepDateSlashAdd(date);
	var fFromDate = kepDateAdd("st_rd_date", 7, "M");
	var fToDate = kepDateAdd("st_rd_date", 7, "P");
	
	dateForm = new Array(fRdDate, fFromDate, fToDate );
	return dateForm;
	
}
var process_type = "<%=p_process_type%>";

function sheetTagListWin4() {
	
	var buyer	= "<%=p_buyer%>"; 
	var seller	= "<%=p_seller%>";
	var inv_no	= "<%=p_inv_no%>";
	var legacy_po_no = "<%=p_legacy_po_no%>";
	var pur_id = $("#st_pur_id").val();
	var ktag_start = 1;
	var url ="/coco/showReportViewer.do";
	var ktag_box_qty = 1; // 품목태그는 수량 관계없이 항상 기본 1장씩 출력(한애희)
	
	if(ktag_start >= 5){
// 		alert("K tag(4칸)은 출력위치 4 이하만 가능합니다.");
		var text = "K tag(4칸)은 출력위치 4 이하만 가능합니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var process_type = "<%=process_type%>";
	var ktag_rpt = "<%=ktag_rpt%>";
	var fileName = "";

	var print_size = $("#st_print_size").val();
	
	if(isEmpty(print_size)){
// 		alert("라벨출력방식을 선택해주세요.");
		var text = "라벨출력방식을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_print_size").focus();
		return;
	}
	
	if($("#st_print_size").val() == "L"){
 		fileName = "RD_06_X_002_20";
 	}else if($("#st_print_size").val() == "N"){
 		fileName = "RD_06_X_002_19";
 	}
	
   	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]";   
   	
   	reportOpen(fileName, param); 
    
	return;
}

function sheetTagListWin12() {
	
	var buyer	= "<%=p_buyer%>"; 
	var seller	= "<%=p_seller%>";
	var inv_no	= "<%=p_inv_no%>";	
	var legacy_po_no = "<%=p_legacy_po_no%>";
	var pur_id = $("#st_pur_id").val();
	var ktag_start = $("#ktag_selectbox").val();
	var ktag_box_qty = $("#ktag_box_qty").val();
   	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]&inv_no="+inv_no+"&buyer="+buyer; 

 	reportOpen("RD_06_X_002_11", param); 

	return;
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

function setInvoiceDelete(){
	var ap_bill_flag = "<%=ap_bill_flag%>";

	if(ap_bill_flag == "Y"){
		var text = "매입마감이 완료된 건은 거래명세서 삭제할 수 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	var query       = "";
	var buyer		= "";
	var po_no		= "";
	var po_seq 		= "";
	var inv_no      = "";
	var inv_seq		= "";
	var ds_date		= "";
	var seller		= "";
	
	for(var i = 1; i<=mySheet.RowCount(); i++){
		buyer = mySheet.GetCellValue(i,"BUYER");
		po_no = mySheet.GetCellValue(i,"PO_NO");
		po_seq = mySheet.GetCellValue(i,"PO_SEQ");
		inv_no = mySheet.GetCellValue(i,"INV_NO");
		inv_seq = mySheet.GetCellValue(i,"INV_SEQ");
		ds_date = mySheet.GetCellValue(i,"DS_DATE");
		
		query +=  buyer         + "@@";
		query +=  po_no         + "@@";
		query +=  po_seq        + "@@";
		query +=  inv_no        + "@@";
		query +=  inv_seq       + "@@";
		query +=  ds_date             ;
		query +=  "^||^" ;
		
	}
	document.forms["contentForm"].st_query.value  = query;
	
// 	if(!confirm("거래명세서를 삭제 하시겠습니까?")) return;
	var text = "거래명세서를 삭제 하시겠습니까?";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:delSellerMpIvTranStatementAlterPrintPop(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
// 	kepAjaxFormCall("/mpiv/delSellerMpIvTranStatementAlterPrintPop.do","contentForm","btnDel");
}
function delSellerMpIvTranStatementAlterPrintPop(){
	closePopText1();
	kepAjaxFormCall("/mpiv/delSellerMpIvTranStatementAlterPrintPop.do","contentForm","btnDel");
}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	var msg = response.msg;

	if (!isEmpty(msg)){
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
		
	} else {
		if (pMethod == "btnDel"){
// 			alert("거래명세서 삭제가 정상적으로 완료 되었습니다.");
			var text = "거래명세서 삭제가 정상적으로 완료 되었습니다.";
			openLayerPopText2(text,but1text,but1funcSearch,but1width);
		}
	}
	return;
}
//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.msg;
	
	if (!isEmpty(msg)){
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
	}
	return;
}
function thisPopClose(){
	closePopText2();
	parent.doAction("search");
	parent.closePop();
}
</script> 

<body onload="kep_onload_view();">
<form name = "contentForm" id="contentForm" method = "post">
<input type="hidden" name="s_SAVENAME" />
<!-- HIDDEN -->
<input type="hidden" id="st_query" name="st_query"            value="">
<input type="hidden" name="st_buyer"           value="<%=p_buyer%>">
<input type="hidden" name="st_inv_no"           value="<%=p_inv_no%>">
<input type="hidden" name="st_seller"           value="<%=p_seller%>">
<input type="hidden" name="st_process_type"     value="<%=p_process_type%>">
<input type="hidden" name="st_legacy_po_no"     value="<%=p_legacy_po_no%>">
<input type="hidden" name="st_type"			    value="">

<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
<input type="hidden" name="st_com_name" id="st_com_name" value="${sessionInfo.comNameLoc}">

<input type="hidden" name="st_rd_date" id="st_rd_date" value="">
<input type="hidden" name="st_pur_id" id="st_pur_id" value="">
<input type="hidden" id="st_legacy_iv_no"	name="st_legacy_iv_no"	value="">
<div class="wrapPopup">
  <div class="PopupTit">거래명세서 조회 <span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="PopupTitSub">발주정보</div>
  <table class="PopupTableTxt" width="1200px">
    <colgroup>
      <col width="120px" />
      <col width="180px" />
      <col width="120px" />
      <col width="180px" />
      <col width="120px" />
      <col width="180px" />
      <col width="120px" />
      <col width="180px" />
  	</colgroup>
    <tr>
      <th>발주번호</th>
      <td><%=po_no%></td>
      <th>발주일</th>
      <td><%=po_create_date%></td>
      <th>고객사</th>
      <td><%=seller_buyer%></a></td>
      <th>발주자</th>
      <td><%=purchaser_name%></td>
    </tr>
<!--     <tr> -->
<!--       <th>품목수량</th> -->
<!--       <td align="right" id="buyerItemCnt"></td> -->
<!--       <th>발주금액</th> -->
<%--       <td align="right"><%=agent_po_ttl_amt%></td> --%>
<!--       <th>납품예정일</th> -->
<%--       <td><%=ds_date%></td> --%>
<!--       <th>납품일</th> -->
<%--       <td><%=inv_date%></td> --%>
<!--     </tr> -->
    <tr>
      <th>발주비고</th>
      <td colspan="7"><%=po_remark%></td>
    </tr>  
  </table>  
  <div class="PopupTitSub">발주/송장정보</div>
  <table class="PopupTableTxt" width="1200px">
    <colgroup>
      <col width="120px" />
      <col width="180px" />
      <col width="120px" />
      <col width="180px" />
      <col width="120px" />
      <col width="180px" />
      <col width="120px" />
      <col width="180px" />
  	</colgroup>
    <tr>
<!--       <th>인수자명</th> -->
<!--       <td>김구매</td> -->
<!--       <th>연락처</th> -->
<%--       <td><%=tel_no %></td> --%>
      <th>납품예정일</th>
      <td><%=ds_date%></td>
      <th>납품일</th>
      <td colspan="5"><%=inv_date%></td>
    </tr>
    <tr>
      <th>배송지</th>
      <td colspan="7"><%=dely_to_location%></td>
    </tr>
    <tr>
      <th>배송 특이사항</th>
      <td colspan="7"><%=delivery_remark %></td>
    </tr>
<!--     <tr> -->
<!--       <th>협력사메모</th> -->
<%--       <td colspan="7"><%=remark_inv%></td> --%>
<!--     </tr> -->
  </table>  
  <div class="PopupTitSub">주문품목<p  style="display:inline-block; margin-left:5px" id="itemCnt">(3)</p></div>
  <div class="IBSheetTablePopup" width="1200px">
    <script type="text/javascript">
		createIBSheet("mySheet", "", "100%");
    </script>       
  </div>
  <%if(process_type.equals("2") || ktag_rpt.equals("Y")){ %>
  <div class="PopupTitSub">출력옵션 설정</div>
  <table class="PopupTableTxt" width="1200px">
    <colgroup>
      <col width="120px" />
      <col width="180px" />
      <col width="120px" />
      <col width="180px" />
      <col width="120px" />
      <col width="180px" />
      <col width="120px" />
      <col width="180px" />
  	</colgroup>
    <tr>
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
      <td colspan="4"></td>
    </tr>
  </table> 
<%} %>  
  <div class="h30"></div>
  <div class="PopupListBtnBox_Center">
  <button class="ButQuaternary_large" onclick="javascript:sheetWin(); return false;">
  <%if(process_type.equals("2")){ %>
    입고라벨 출력
  <%}else{ %>
  	<%=CommonUtil.nvl(detailInfo.get("BTN_NM"))%>
  <%} %>
  </button>
  	<%if(ktag_rpt.equals("Y") || (p_tr_buyer.equals("KRKORE0068") && st_no_itemTag_check_yn.equals("N"))){%> 
		<button class="ButQuaternary_large" onclick="javascript:sheetTagListWin4(); return false;">품목라벨 출력</button>
  	<%} %>
  	<%  if(btn_yn.equals("11")){ %>
  		<button class="ButQuaternary_large" onclick="javascript:setInvoiceDelete(); return false;">거래명세서 삭제</button>
  	<%} %>
  </div>
</div><!-- warp 끝-->
</form>
</body>
</html>
