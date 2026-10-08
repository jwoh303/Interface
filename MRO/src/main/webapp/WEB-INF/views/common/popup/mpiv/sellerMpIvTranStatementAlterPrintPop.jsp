<%--
**********************************************
* 메뉴 : 
* 화면 : 거래명세서 수정 및 출력
* 기능 : 기 생성된 거래명세서 상세내역을 확인하고 출력 및 수정/삭제 처리할 수 있다.
* 프로그램 ID : PG_07_A_004_01
* 담당자 : 개발3 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>
 
<%
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
	
	String session_com_code = CommonUtil.nvl(_sessionInfo.getComCode());
	
	//조회결과 - 상세정보
	@SuppressWarnings (value="unchecked")
	Map<String,String> detailInfo = (Map<String,String>) request.getAttribute("info");
	
	String po_no = "";
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
    String legacy_iv_serial = "";
	
	String stx_rpt = "";
	String dsn_rpt = "";
	String rpt_url = "";
	
	String btn_yn = "";		// 저장,삭제버튼 출력여부 11 : 노출, 00 : 비노출
	String btn_nm = "";		// 거래명세서 출력 버튼명
	String extr_rpt = "";	// 납품지시서 리포트 출력여부
	String ktag_rpt = "";	// KTAG 사용여부
	String parcel_yn ="";	// 배송유형
	
	if(detailInfo != null){
		po_no 				= CommonUtil.nvl(detailInfo.get("PO_NO"));
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
		
		process_type		= CommonUtil.nvl(detailInfo.get("PROCESS_TYPE"));
		iv_serial			= CommonUtil.nvl(detailInfo.get("IV_SERIAL"));
		legacy_iv_serial	= CommonUtil.nvl(detailInfo.get("LEGACY_IV_SERIAL"));
		
		stx_rpt		= CommonUtil.nvl(detailInfo.get("STX_RPT"));
		dsn_rpt		= CommonUtil.nvl(detailInfo.get("DSN_RPT"));
		
		rpt_url		= CommonUtil.nvl(detailInfo.get("RPT_URL"));
		
		btn_yn		= CommonUtil.nvl(detailInfo.get("BTN_YN"));
		btn_nm		= CommonUtil.nvl(detailInfo.get("BTN_NM"));
		extr_rpt	= CommonUtil.nvl(detailInfo.get("EXTR_RPT"));
		ktag_rpt	= CommonUtil.nvl(detailInfo.get("KTAG_RPT"));
		parcel_yn	= CommonUtil.nvl(detailInfo.get("PARCEL_YN"));
		
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
	
	//조회결과 - 상세 리스트
	@SuppressWarnings (value="unchecked")
	List<Map<String, String>> detailList = (List<Map<String, String>>) request.getAttribute("data"); 
	
	int rec_cnt = 0;
	int page_display_cnt = 0;
	//SLOGIC-START
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
	
	// 입고라벨 미사용 대상 고객사(TR이어도 고객사 고유의 양식 사용)
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

var popupSel = "";

var today = kepGetNowTimeStr("YYYYMMDD","");
var fromDate = kepToDateAdd("7","M","noslash");
var toDate = kepToDateAdd("7","P","noslash");
var process_type = "<%=p_process_type%>";

//최초 화면 함수 
function kep_onload_view(){
	kepSetCalender('st_invoice_date_text');	
	$("#st_parcel_type").val("<%=parcel_yn%>");
}

//팝업호출
function doPop(str, value1, value2, value3, value4) {
	popupSel = str ;
	
	switch (str) {
		case "commonMpIvOrderInfoPop": // 발주번호 click시 발주정보 팝업
			openSearchPopup("/mpiv/getCommonMpIvOrderInfoPop.do", "?st_buyer="+value1+"&st_po_no="+value2, "930,600,no");
			break;
		case "catalogDetailPop": // 품목상세정보
			getBuyerCatalogDisplayPop(value1, value2, value3, value4);
			break;
		case "commonMpIvDlvryCarPop": // 배송차량조회
			openSearchPopup("/mpiv/getCommonMpIvDlvryCarPop.do", "?st_com_code="+value1, "580,400,no");
			break;
		case "msdsDetailPop": // msds
			openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+value1+"&st_btn_yn=N",'750,580,no');
			break;
	}
}

//Ktag 분할팝업
function setKtagDivide( buyer, inv_no, inv_seq , buyer_item_no , item_qty ,description ,po_no,po_seq,  x ){


    if(item_qty =='1'){   
        alert("수량 1개의 품목은 분할하실 수 없습니다.");
        return;
    }


        if(!confirm("Ktag출력시 수량분할하시겠습니까?")) return;

    
//     document.forms.sellerMpIvObtnodrReceiptDetailPop.x.value = x;

     openSearchPopup("/mpiv/getsellerMpIvKtagPlanEntryPop.do", "?st_buyer="+buyer+"&st_inv_no="+inv_no+"&st_inv_seq="+inv_seq +"&st_buyer_item_no="+buyer_item_no+"&st_item_qty="+item_qty+"&st_description="+description+"&st_po_no="+po_no+"&st_po_seq="+po_seq, "520,500,no");
    
}

// 하이닉스 납품서생성
// if((p_buyer.equals("KRHYNI0001") || p_buyer.equals("KRHYNI0002") || p_buyer.equals("KRHYNI0003")) && legacy_flag.equals("Y") && process_type.equals("0"))
function setHynixInvoice(){
    var legacy_po_no = $("#st_legacy_po_no").val();
    var legacy_po_seq = $("#legacy_po_seq_tot").val();
    
    var sap_user = "saprfc22";
    var sap_password = "hynix001";
    
//var loc  = 'https://hsrm.hynix.com:8443/sap/bc/bsp/sap/system/login.htm?';  //기존
	var loc  = 'https://hypis.skhynix.com/irj/servlet/prt/portal/prtroot/pcd!3aportal_content!2fhynix!2fsupplier!2fkep!2fhynix.iv.srm.bsp.ZADE100J_S_KEP?';  //2011.12.19 신규적용
    loc +=  '&ebeln='+legacy_po_no+'&ebelp='+legacy_po_seq+'&sap-user='+sap_user+'&sap-password='+sap_password;        

    window.open(loc,"newW","left=0,top=0,width=1024,height=780,resizable=yes,scrollbars=no");
    window.close();
}



// 납품서 생성
// else if((p_buyer.equals("KRDHIM0001") || p_buyer.equals("KRDOOS0046") || p_buyer.equals("KRDHIM0004")) && (dhim_legacy_po_no.equals("5") || dhim_legacy_po_no.equals("4") || dhim_legacy_po_no.equals("A")) && process_type.equals("0"))
function setDHIMCreate(){
	if(process_type == '0'){
		var legacy_po_no = $("#st_legacy_po_no").val();
		var agent = $("#st_com_code").val();
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
		setInvoiceCreate();
	}
}

// 납품서 생성
//else if(p_buyer.equals("KRDOOS0049") && legacy_flag.equals("Y") && process_type.equals("0"))
function setDMTCreate(){	    
	if(process_type == '0'){
		var legacy_po_no = $("#st_legacy_po_no").val();
		var legacy_po_seq = $("#legacy_po_seq_tot").val();
		var agent = $("#st_com_code").val();
		var agent_name = $("#st_com_name").val();
		
	  	var loc  = 'http://203.226.120.41/mro_test/asp/index.asp?';   //개발
	//	var loc  = 'http://203.226.120.41/tmprd_kep/asp/index.asp?';  //운영
			loc +=  'loc_id='+legacy_po_seq+'&agent_id='+agent;

		window.open(loc,"newW","left=0,top=0,width=1024,height=760,resizable=yes,scrollbars=no");
		window.close();
	}else{
		setInvoiceCreate();
	}
}

// 납품서 생성
// else if(p_buyer.equals("KRDOOS0035") && legacy_flag.equals("Y") && process_type.equals("0"))
function setDMTCreate_new(){	    
	if(process_type == '0'){
		var vendor_code = "OP00122";
		var inv_no = $("#st_legacy_iv_no").val();
	  	
		var loc  = 'http://doobuy.doosan.com/kep_invoice.jsp?';  //운영
			  loc += 'VENDOR_CODE='+vendor_code+'&INVOICE_NO='+inv_no;
		
		window.open(loc,"newW","left=0,top=0,width=1024,height=760,resizable=yes,scrollbars=no");
		window.close();
	}else{
		setInvoiceCreate();
	}
}
	

//대우조선 납품지시서
function sheetWinDaewoo3(){
	alert("레포트 연결 예정!!");
	
	//RD_08_M_002_00
	
	return;
	
	//var agent_code  = "${sessionInfo.comCode}";
	//window.open("/kr/epro/buy/sheet/daewoo_delivery_order_list.jsp?agent_code="+agent_code,"sheetWin_TEST_3","toolbar=yes,width=700,height=600,resizable=YES,scrollbars=YES,top=0,left=0");
}


// 납품일 수정
function setInvoiceDate(){
	
	if(!confirm("납품일과 배송유형을 수정 하시겠습니까?")) return;
    
	var parcel_yn = $("#st_parcel_type").val();
	
	if(isEmpty(parcel_yn)){
		alert("배송유형을 선택해주세요.");
		$("#st_parcel_type").focus();
		return;
	}
    $("#st_invoice_date").val($.datepicker.formatDate('yymmdd', $("#st_invoice_date_text").datepicker("getDate")));
    $("#st_parcel_yn").val(parcel_yn);
   
    kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementAlterPrintPop.do","processForm","btnSave");
    
}

//거래명세서 삭제
function setInvoiceDelete(){
	
	var disp_cnt    = $("#display_item_cnt").val();
	
	var query       = ""; 
	var po_no       = "";
	var po_seq      = "";
	var inv_no      = "";
	var inv_seq     = "";
	var ds_date     = "";
	var buyer       = "<%=p_buyer%>";
	var process_type = "<%=p_process_type%>";
	if(eval(disp_cnt) < 2){
	
		buyer       = document.forms[0].st_buyer.value;
		po_no       = document.forms[0].st_po_no.value;
		po_seq      = document.forms[0].st_po_seq.value;
		inv_no      = document.forms[0].st_inv_no.value;
		inv_seq     = document.forms[0].st_inv_seq.value;
		ds_date     = document.forms[0].st_ds_date.value;
		
		query +=  buyer         + "@@";
		query +=  po_no         + "@@";
		query +=  po_seq        + "@@";
		query +=  inv_no        + "@@";
		query +=  inv_seq       + "@@";
		query +=  ds_date             ;
		query +=  "^||^" ;
		
	}else{
		for(var k=0; k<disp_cnt ; k++){		
			buyer       = document.forms[0].st_buyer[k].value;
			po_no       = document.forms[0].st_po_no[k].value;
			po_seq      = document.forms[0].st_po_seq[k].value;
			inv_no      = document.forms[0].st_inv_no[k].value;
			inv_seq     = document.forms[0].st_inv_seq[k].value;
			ds_date     = document.forms[0].st_ds_date[k].value;
			
			query +=  buyer         + "@@";
			query +=  po_no         + "@@";
			query +=  po_seq        + "@@";
			query +=  inv_no        + "@@";
			query +=  inv_seq       + "@@";
			query +=  ds_date             ;
			query +=  "^||^" ;
		}
	}

	document.forms[0].st_query.value  = query;
	
	if(!confirm("거래명세서를 삭제 하시겠습니까?")) return;
	
	kepAjaxFormCall("/mpiv/delSellerMpIvTranStatementAlterPrintPop.do","contentForm","btnDel");
	
	/*
	document.forms[0].st_query.value  = query;
	document.forms[0].target = "work";
	document.forms[0].method = "post";
	document.forms[0].action = "/kr/agent/invoice/agent_invoice_edit_reg.jsp";
	document.forms[0].submit();
	*/
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	var msg = response.msg;

	if (!isEmpty(msg)){
		alert(msg);
		
	} else {
		if(pMethod == "btnSave"){
			alert("납품일 변경이 정상적으로 완료 되었습니다.");
			
		} else if (pMethod == "btnDel"){
			alert("거래명세서 삭제가 정상적으로 완료 되었습니다.");
		}
	}
	
	opener.doAction("search");
	window.close();
	
	return;
}

function sheetWin() {
	var buyer	= "<%=p_buyer%>";
	var legacy_flag	= "<%=legacy_flag%>";
	var process_type = "<%=process_type%>";
	var rd_date = $("#st_rd_date0").val();
	var solb_legacy_po_no = "<%=dhim_legacy_po_no%>";
	var solb_if_buyer_flag = "<%=solb_if_buyer%>";
	
	if(buyer=="KRKORE0212"){
		var dateArr =  setDateMsg(rd_date);

		var msg = "고객사 납품요구일이 " + dateArr[0] +" 입니다.\n\n"
				+ dateArr[1] + " ~ " + dateArr[2] + " 기간내에만 출력이 가능합니다.\n\n"
				+ "(문의사항: 변상남 대리, 055-270-6208 / 010-2058-4564)";

		var from_date = dateArr[1].replace(/[/]/gi,"");
		var to_date = dateArr[2].replace(/[/]/gi,"");
		
		if( eval(today) < eval(from_date) || eval(today) > eval(to_date) ){
			alert(msg);
			return;
		}
	}
	else if (buyer=="KRDOOS0035" && legacy_flag=="Y" && process_type == "0"){
		setDMTCreate_new();
		return;
	}

	var seller	= "<%=p_seller%>";
	var inv_no	= "<%=p_inv_no%>";
	var rpt_url = "<%=rpt_url%>";
	var legacy_po_no = "<%=p_legacy_po_no%>";
	var pur_id = $("#st_pur_id").val();
	var legacy_iv_serial = "<%=legacy_iv_serial%>";
	var tr_buyer = "<%=p_tr_buyer%>";
	var print_gbn = $("input:radio[name='radioBtn']:checked").val();	// 0:발주서, 1:납품서

	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]";
	
	if(solb_if_buyer_flag == "Y" && solb_legacy_po_no == "4" && process_type == "0" && legacy_iv_serial == ""){ // 솔브레인 IF 발주
		alert("거래명세서를 고객사 시스템에 등록중입니다.(납품서 출력은 약 20분 후 가능합니다)\n출력이 지연되면 KeP담당자에게 문의하시기 바랍니다.");
		return;
	}
	
	if(process_type == "2" && "<%=st_no_tag_check_yn%>" == "N"){
		var print_size = $("#st_print_size").val();
		var ktag_box_qty = $("#itemTag_box_qty").val();
		
		if(isEmpty(print_size)){
			alert("라벨출력방식을 선택해주세요.");
			$("#st_print_size").focus();
			return;
		}
		
		if(print_size == "N"){
   			rpt_url = "RD_06_S_001_170";
   		}else if(print_size == "L"){
   			rpt_url = "RD_06_S_001_171";
   		}
		
		param = "["+inv_no+"]["+seller+"]["+buyer+"]["+ktag_box_qty+"]";
		
		openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, print_gbn, legacy_po_no);
		
		if("<%=st_no_itemTag_check_yn%>" == "Y"){
			rpt_url = "<%=p070000034%>";
			param = "["+inv_no+"]["+seller+"]["+buyer+"]";
			
			openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, print_gbn, legacy_po_no);
		}
	}else{
		openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, print_gbn, legacy_po_no);
	}
   	
	return;
}

function sheetTagListWin4() {
	
	var buyer	= "<%=p_buyer%>"; 
	var seller	= "<%=p_seller%>";
	var inv_no	= "<%=p_inv_no%>";
	var legacy_po_no = "<%=p_legacy_po_no%>";
	var pur_id = $("#st_pur_id").val();
	var ktag_start = $("#ktag_selectbox").val();
	var url ="/coco/showReportViewer.do";
	var ktag_box_qty = 1;	// 품목태그는 수량 관계없이 항상 기본 1장씩 출력(한애희)
	
	if(ktag_start >= 5){
		alert("K tag(4칸)은 출력위치 4 이하만 가능합니다.");
		return;
	}
	
	var process_type = "<%=process_type%>";
	var ktag_rpt = "<%=ktag_rpt%>";
	var fileName = "";

	var print_size = $("#st_print_size").val();
	
	if(isEmpty(print_size)){
		alert("라벨출력방식을 선택해주세요.");
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
	
	self.close();
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
		alert(msg);
	}
	return;
}

function setDateMsg(date){  

	var fRdDate = kepDateSlashAdd(date);
	var fFromDate = kepDateAdd("st_rd_date0", 7, "M");
	var fToDate = kepDateAdd("st_rd_date0", 7, "P");
	
	dateForm = new Array(fRdDate, fFromDate, fToDate );
	return dateForm;
	
}

</script> 
</head>

<body onload="kep_onload_view()">
<form name = "contentForm" id="contentForm" method = "post">

<!-- HIDDEN -->
<input type="hidden" id="st_query" name="st_query"            value="">
<input type="hidden" name="st_seller"           value="<%=p_seller%>">
<input type="hidden" name="st_process_type"     value="<%=p_process_type%>">
<input type="hidden" name="st_legacy_po_no"     value="<%=p_legacy_po_no%>">
<input type="hidden" name="st_type"			    value="">

<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
<input type="hidden" name="st_com_name" id="st_com_name" value="${sessionInfo.comNameLoc}">
<input type="hidden" name="st_com_tel" id="st_com_tel" value="${sessionInfo.tel}">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:604px;">
    	<div id="popHeader">
        	<h1 class="title">거래명세서 조회(출력) 및 수정</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!-- 거래명세서 작성 상세내용 -->  
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
			        <td height="23" colspan="2"></td>
			    </tr>
			    <tr>
			        <td bgcolor="#898989" height="1" colspan="2"></td>
			    </tr>
			
			    <tr>
			        <td colspan="2">
			            <table width="100%" border="0" cellspacing="0" cellpadding="0">
			                <tr height="25">
			                    <td width="13%" style="text-align:center" height="25"><font color="#993300">발주번호</font></td>
			                    <td width="20%">
			                    	<a class="hyperLink" href="javascript:doPop('commonMpIvOrderInfoPop','<%=p_buyer%>','<%=po_no%>');">
			                   			<%=po_no%>
			                   		</a>
			                    </td>

<%if(process_type.equals("2") || ktag_rpt.equals("Y")){ %>
			                    <td width="13%" style="text-align:center" height="25"><font color="#993300">라벨출력방식</font></td>
			                    <td width="20%">
			                    	<select style="width: 150px;" name="st_print_size" id ="st_print_size">
			                    		<option value="">선택</option>
			                    		<option value="N">일반프린터(A4 4분할)</option>
			                    		<option value="L">라벨프린터(10x10cm)</option>
			                    	</select>
			                    </td>
<%}%>
<%if(process_type.equals("2")){ %>
			                    <td width="13%" style="text-align:center" height="25"><font color="#993300">박스수량</font></td>
			                    <td width="20%">
			                    	<select style="width:50px;" name="itemTag_box_qty" id ="itemTag_box_qty">
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
					                    <option value="31" >31</option>
					                    <option value="32" >32</option>
					                    <option value="33" >33</option>
					                    <option value="34" >34</option>
					                    <option value="35" >35</option>
					                    <option value="36" >36</option>
					                    <option value="37" >37</option>
					                    <option value="38" >38</option>
					                    <option value="39" >39</option>
					                    <option value="40" >40</option>
					                    <option value="41" >41</option>
					                    <option value="42" >42</option>
					                    <option value="43" >43</option>
					                    <option value="44" >44</option>
					                    <option value="45" >45</option>
					                    <option value="46" >46</option>
					                    <option value="47" >47</option>
					                    <option value="48" >48</option>
					                    <option value="49" >49</option>
					                    <option value="50" >50</option>
			                        </select>
			                    </td>
<%}%>
			                </tr>
			
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                
			                <tr height="25">
			                    <td width="13%" style="text-align:center"><font color="#993300">공급받는자</font></td>
			                    <td><%=seller_buyer%></td>

			                    <td width="13%" style="text-align:center"><font color="#993300">총금액</font></td>
			                    <td style="padding-top:2px !important;">
			                    	<input type="text"   name="st_inv_tot_amt_text" size="14" style="background-color:#FFFFFF;border:#FFFFFF 1px solid;" value="<%=CommonUtil.formatNumber(inv_amt,true,0,3)%> 원"  READONLY >
			                    	<input type="hidden" name="st_inv_tot_amt" value ="<%=inv_amt%>">
			                    	<input type="hidden" name="st_inv_amt" value ="<%=inv_amt%>">
			                    	<input type="hidden" name="st_inv_amt_text" size="14" class="ar input_type_text" style="background-color:#FFFFFF;border:#FFFFFF 1px solid;" value="<%=CommonUtil.formatNumber(inv_amt,true,0,3)%> 원"  READONLY >
			                    	<input type="hidden" name="st_inv_tax_amt_text" size="14" class="ar input_type_text" style="background-color:#FFFFFF;border:#FFFFFF 1px solid;" value="<%=CommonUtil.formatNumber(inv_tax_amt,true,0,3)%> 원"  READONLY >
									<input type="hidden" name="st_inv_tax_amt"  value ="<%=inv_tax_amt%>">  <!-- 부가세(10%)   공급가액의 10% -->                                               
									<input type="hidden" name="st_inv_tax_rate" value ="0.1">          <!-- 부가세(10%) , 부가세 비율 10 * 0.01 -->
			                    </td>
			                </tr>
			
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			
			                <tr height="25">
			                    
			                    <td width="13%" style="text-align:center"><font color="#993300">납품예정일</font></td>
			                    <td><%=ds_date%></td>
			                    <td width="13%" style="text-align:center"><font color="#993300">납품일</font></td>
			                    <td>
								 	<input type="text"   name="st_invoice_date_text" size="10" id="st_invoice_date_text" class="input_type_text"  value='<%=inv_date%>' readonly>
			                    </td>
			                    <td width="13%" style="text-align:center"><font color="#993300">배송유형</font></td>
			                    <td width="20%" >	
			                    	<select name="st_parcel_type" id ="st_parcel_type">
			                    		<option value="">선택</option>
			                    		<option value="Y">택배</option>
			                    		<option value="N">자차</option>
			                    	</select>
			                    </td>	
			                </tr>
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                <tr height="25">
			                <% if(p_buyer.equals("KRDOOD0001")){  %>
			                    <td width="13%" style="text-align:center"><font color="#993300">납품장소</font></td>
			                    <td colspan="3"><%=dely_to_location%></td>
			                    <td width="13%" style="text-align:center"><font color="#993300">납품정보</font></td>
			                    <td ><%=iv_serial%>:<%=legacy_iv_serial%></td>
							<% } else { %>
								<td width="13%" style="text-align:center"><font color="#993300">납품장소</font></td>
			                    <td colspan="5"><%=dely_to_location%></td>
							<% } %>
			                </tr>
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                <tr height="25">
			               		<td width="13%" style="text-align:center"><font color="#993300">발주비고</font></td>
			                    <td colspan="5"><%=po_remark%></td>
			                </tr>
	                        <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                <tr height="25">
			                    <td width="13%" style="text-align:center"><font color="#993300">비고</font></td>
			                    <td colspan="5"><%=remark_inv%></td>
			                </tr>
			            </table>
			        </td>
			    </tr>
			    <tr>
			        <td bgcolor="#898989" height="1" colspan="2"></td>
			    </tr>
			    <tr>
			        <td height="10" colspan="2"></td>
			    </tr>
			</table>
			
           	<!--grid-->
            <div class="scrollArea" style="height:325px">
                <table  class="cont_t_list04"  style="width:100%">
                    <caption>거래명세서 수정 및 출력 상세 리스트</caption>
                    <colgroup> 
                        <col width="15%" />
                        <col width="28%" />
                        <col width="10%" />
                        <col width="12%" />
                        <col width="15%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">관리번호</th> 
                            <th scope="col">품목명/제조사</th> 
                            <th scope="col">발주수량/단위</th>
                            <th scope="col">단가</th>
                            <th scope="col">납품예정일</th>
							<%    
								if(p060000080.equals("TYPE1")) {
							%>
                            	<th scope="col" >길이/수량</th>
                            							<%    
								}else{
							%>
								<th scope="col" rowspan="2">비고</th>
							<%    
								}
							%>  
                        </tr>
                        <tr>
                            <th scope="col">품목코드</th> 
                            <th scope="col">규격</th> 
                            <th scope="col">납품수량</th>
                            <th scope="col">공급가액</th>
                            <th scope="col">납기요청일</th> 
							<%    
								if(p060000080.equals("TYPE1")) {
							%>
                            	<th scope="col" >비고</th>
							<%    
								}
							%> 
                        </tr>
                    </thead>
                    <tbody>
					<%
					
					String legacy_po_seq = "";
					String legacy_po_seq_a = "";
					String legacy_po_seq_tot = "";
					String pur_id = "";
					String legacy_iv_no = "";
					
					int recCnt = detailList.size();
					
					if (recCnt <= 0){
					%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="7" align="center" height = "50">
	                        <span class="font1">조회된 데이타가 없습니다.</span>
	                        </td> 
	                    </tr>
					<%
					} else {
						
						for (int j=0; j<recCnt; j++){
							page_display_cnt++;
							
							Map<String,String> rowData = detailList.get(j);
							
							legacy_po_seq 	= CommonUtil.nvl(rowData.get("LEGACY_PO_SEQ"));
							pur_id 			= CommonUtil.nvl(rowData.get("PURCHASER_ID"));
							legacy_iv_no	= CommonUtil.nvl(rowData.get("LEGACY_IV_NO"));
							
							if(p_buyer.equals("KRDOOS0035")){
								
								if((j+1) == rec_cnt){  
									legacy_po_seq_a = legacy_po_seq + "";
								}else{
									legacy_po_seq_a = legacy_po_seq + ",";
								}
								
								legacy_po_seq_tot = legacy_po_seq_tot + legacy_po_seq_a;  
								legacy_po_seq_tot = legacy_po_seq_tot;
							
							}else{
								legacy_po_seq_a = legacy_po_seq + "@@";	
								legacy_po_seq_tot = legacy_po_seq_tot + legacy_po_seq_a;
								legacy_po_seq_tot = legacy_po_seq_tot;
							}

							String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
					%> 
					
						<input type="hidden"   name="st_buyer"      value="<%=p_buyer%>">
						<input type="hidden"   name="st_po_no"      value="<%=CommonUtil.nvl(rowData.get("PO_NO"))%>">
						<input type="hidden"   name="st_inv_no"      value="<%=p_inv_no%>">
						<input type="hidden"   name="st_ds_date"      value="<%=CommonUtil.nvl(rowData.get("DS_DATE"))%>">
						
						<input type="hidden" name="st_po_seq"  value="<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>">
						<input type="hidden" name="st_inv_seq" value="<%=CommonUtil.nvl(rowData.get("INV_SEQ"))%>">
						
						<input type="hidden" name="st_cd_qty"  value="<%=CommonUtil.nvl(rowData.get("INV_LEGACY_QTY"))%>">
						<input type="hidden" name="st_po_qty"  value="<%=CommonUtil.nvl(rowData.get("ITEM_QTY"))%>">
						<input type="hidden" name="st_iv_qty"  value="<%=CommonUtil.nvl(rowData.get("IV_QTY"))%>">
						<input type="hidden" name="st_iv_cre_check"  value="<%=CommonUtil.nvl(rowData.get("DS_LIMIT"))%>">
						<input type="hidden" name="st_description"  value="<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>">
						
						<input type="hidden" id="st_rd_date<%=j%>" name="st_rd_date"  value="<%=CommonUtil.nvl(rowData.get("RD_DATE"))%>">
						
                        <tr bgcolor="<%=tclass%>">
							<td class="left">
								<!-- 관리번호 -->
							 	<%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%>
							</td>
							<td class="left">
								<!-- 품명/제조사 -->
							 	<%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%>
							</td>
							<td>
								<!-- 발주수량/단위 -->
							 	<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("ITEM_QTY")),true,0,3)%>/<%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>
							</td>
							<td class="right" style="padding:3px;">
								<!-- 단가 -->
							 	<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("AGENT_PRICE")),true,0,3)%>
							</td>
							<td>
								<!-- 납품예정일 -->
							 	<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("DS_DATE")))%>
							</td>
							<%    
								if(p060000080.equals("TYPE1")) {
							%>
								<td>
									<!-- 수량/길이 -->
								<%if(CommonUtil.nvl(rowData.get("SIZE_YN"),"").equals("Y")){%>
								 	<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("SIZE_LEN")),true,0,3)%>/
								 	<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("SIZE_QTY")),true,0,3)%>
								<%}%>
								</td>
							<%    
								}else{
							%>
								<td rowspan="2">
									<!-- 비고 -->
								 	<textarea cols="20" rows="3" style="overflow:auto" readonly><%=CommonUtil.nvl(rowData.get("PO_REMARK"))%></textarea>
								</td>							
							<%    
								}
							%>
                        </tr> 
                        <tr bgcolor="<%=tclass%>">
							<td class="left">
								<!-- 품목코드 -->
								<a class="hyperLink" href="javascript:doPop('catalogDetailPop','<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>');">
									<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>
								</a>
								<%
									if(!CommonUtil.nvl(rowData.get("MSDS_NO")).equals("")) { 
								%>  
										<a class="hyperLink" href="javascript:doPop('msdsDetailPop','<%=CommonUtil.nvl(rowData.get("MSDS_NO"))%>');">
											<font color=red><b>(MSDS)</b></font>
										</a>
								<%
									} 
								%>  
							</td>
							<td class="left">
								<!-- 규격 -->
							 	<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
							</td>
							<td>
								<!-- 납품수량 -->
<%							if(ktag_rpt.equals("Y") || (p_tr_buyer.equals("KRKORE0068") && st_no_itemTag_check_yn.equals("N"))){%>
<%					if (("").equals(CommonUtil.nvl(rowData.get("KTAG_QTY")))) {						 %>
<a href="javascript:setKtagDivide('<%=CommonUtil.nvl((String)request.getAttribute("st_buyer"))%>','<%=CommonUtil.nvl((String)request.getAttribute("st_inv_no"))%>','<%=CommonUtil.nvl(rowData.get("INV_SEQ"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("INV_QTY"))%>','<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>','<%=CommonUtil.nvl(rowData.get("PO_NO"))%>','<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>','<%=j%>');">							 
							 <%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("INV_QTY")),true,0,3)%></a>
<%						}else{ %>
<a href="javascript:setKtagDivide('<%=CommonUtil.nvl((String)request.getAttribute("st_buyer"))%>','<%=CommonUtil.nvl((String)request.getAttribute("st_inv_no"))%>','<%=CommonUtil.nvl(rowData.get("INV_SEQ"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("INV_QTY"))%>','<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>','<%=CommonUtil.nvl(rowData.get("PO_NO"))%>','<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>','<%=j%>');">							 
							 <font color="#990000"><%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("INV_QTY")),true,0,3)%></font></a>
<%						} %>
<% }else{ 	%>
 							<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("INV_QTY")),true,0,3)%>
 <%   }       %>
							</td>
							<td class="right">
								<!-- 공급가액 -->
								<input type="text" name="st_item_amt" size="11" class="ar input_type_text" style="background-color:<%=tclass%>;border:<%=tclass%> 1px solid;" value="<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("SELLER_AMT")),true,0,3)%>" READONLY >
							</td>
							<td>
								<!-- 납기요청일 -->
                                <%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("RD_DATE")))%>
							</td>
							<%    
								if(p060000080.equals("TYPE1")) {
							%>
								<td>
									<!-- 비고 -->
								 	<textarea cols="20"  style="overflow:auto" readonly><%=CommonUtil.nvl(rowData.get("PO_REMARK"))%></textarea>
								</td>
							<%    
								}
							%>
                        </tr> 
					<%
						}
					}
					%>
  
                    </tbody>
                </table>                  
                <input type="hidden" id="display_item_cnt" 	name="display_item_cnt"		value="<%=page_display_cnt%>">
                <input type="hidden" id="legacy_po_seq_tot" name="legacy_po_seq_tot"	value="<%=legacy_po_seq_tot%>">
                <input type="hidden" id="st_legacy_iv_no"	name="st_legacy_iv_no"		value="<%=legacy_iv_no%>">
		        <input type="hidden" id="st_pur_id"			name="st_pur_id"			value="<%=pur_id%>">
        </div>
        <div style="height:20px;">
	        <table   style="width:100%;margin-top:8px;">
				<tr>
					<td>
						<div class="btnArea">
							<div class="fl" style="">&nbsp;
							<% 
								// 거래명세서, 발주서 checkbox
								if((p_buyer.equals("KRSTX-0002") || p_buyer.equals("KRSTX-0003") ||p_buyer.equals("KRSTX-0005") ||p_buyer.equals("KRSTX-0006") ||p_buyer.equals("KRSTX-0007")) && p_buyer.equals(p_tr_buyer) ) { 
							%>
								<span style="vertical-align:top;height:28px;padding-top:2px;">
									<input type="radio" name="radioBtn" value="0" style="border:0px;vertical-align:middle;" checked>발주서</input>&nbsp;&nbsp;
									<input type="radio" name="radioBtn" value="1" style="border:0px;vertical-align:middle;">납품서</input>
								</span>
							<%
								}
							%>
								<span class="btn_05">
									<a href="javascript:sheetWin();"><%=CommonUtil.nvl(detailInfo.get("BTN_NM"))%></a> &nbsp;
								</span>
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
          				       
          				       <span class ="btn_10_blue mr04" style="width:115px;vertical-align:top; line-height:22px; color:#FFF; display:none;">
									박스수량: 
									<select id="ktag_box_qty" name="ktag_box_qty" style="width:40px; margin-top:3px">
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
				                    <option value="31" >31</option>
				                    <option value="32" >32</option>
				                    <option value="33" >33</option>
				                    <option value="34" >34</option>
				                    <option value="35" >35</option>
				                    <option value="36" >36</option>
				                    <option value="37" >37</option>
				                    <option value="38" >38</option>
				                    <option value="39" >39</option>
				                    <option value="40" >40</option>
				                    <option value="41" >41</option>
				                    <option value="42" >42</option>
				                    <option value="43" >43</option>
				                    <option value="44" >44</option>
				                    <option value="45" >45</option>
				                    <option value="46" >46</option>
				                    <option value="47" >47</option>
				                    <option value="48" >48</option>
				                    <option value="49" >49</option>
				                    <option value="50" >50</option>
				                    </select> &nbsp;
				                </span>	
				                
								<span class="btn_05_blue mr04" style="vertical-align:top; line-height:22px;padding-top:2px; color:#FFF; display:none;">
									<a href="javascript:sheetTagListWin4();">K tag출력(4칸)</a> &nbsp;
								</span>
									
								<span class="btn_05_blue mr04" style="vertical-align:top; line-height:22px;padding-top:2px; color:#FFF; display:none;">
									<a href="javascript:sheetTagListWin12();">K tag출력(12칸)</a> &nbsp;
								</span>
							
								<span class="btn_05_blue mr04" style="vertical-align:top; line-height:22px;padding-top:2px; color:#FFF">
									<a href="javascript:sheetTagListWin4();">품목라벨 출력</a> &nbsp;
								</span>
							
							<%} %>

							<%
								// 납품지시서 버튼 출력
								if(extr_rpt.equals("Y")) { 
							%>
								<!-- 납품지시서 버튼 -->
								<!--
								<span class="btn_04">
									<a href="javascript:sheetWinDaewoo3();">납품지시서</a> &nbsp;
								</span>
								&nbsp;&nbsp;
								-->
							<% 
								}
							%>
							
							<% if(p_buyer.equals("KRKORE0212")||p_buyer.equals("KRKEPB0004")) { %>
								<!-- KAI RD 양식 품질보증서 자동출력으로 인해 수동 다운로드 막음 - 20180330 HSJ 
									<span class="btn_10">
										<a href="/resources/excel/work/INVOICE/sellerWarrantyForm.doc">품질보증서 내려받기</a> &nbsp;
										<a href="/resources/excel/cart_template.xls">품질보증서 내려받기</a>
									</span>
								-->
							<% }  %>
				
							</div>
							<div class="fr">&nbsp;
							<!-- 저장, 삭제버튼 -->
							<%  if(btn_yn.equals("11")){ %>
									<span class="btn_04">
										<a href="javascript:setInvoiceDelete();">삭제</a> &nbsp;
									</span>
								 	<span class="btn_04">
										<a href="javascript:setInvoiceDate();">저장</a> &nbsp;
									</span>
							<%  } %>
				            </div>
				        </div>
						
						<!-- a href="javascript:top.window.close();"><img src="/kr/agent/images/button/btn_close.gif"	width="64" height="27" border="0" align="absmiddle" ></a -->
					</td>
				</tr>
			</table>
		</div>
    </div>        
</div>
</form> 
<form id="processForm" name="processForm" method="post">
	<input type="hidden" id="st_user_id"		name="st_user_id" 		value="${sessionInfo.userId}" />
	<input type="hidden" id="st_buyer"			name="st_buyer" 		value="<%=p_buyer%>" />
	<input type="hidden" id="st_inv_no"			name="st_inv_no" 		value="<%=p_inv_no%>" />
	<input type="hidden" id="st_invoice_date"	name="st_invoice_date"	value="" />
	<input type="hidden" id="st_po_no"			name="st_po_no" 		value="<%=p_po_no%>" />
	<input type="hidden" id="st_parcel_yn"		name="st_parcel_yn" 	value="" />
	
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
