<%--
**********************************************
* 메뉴 : 
* 화면 : 거래명세서작성
* 기능 : 거래명세서를 작성하기위한 팝업
* 프로그램 ID : PG_07_A_002_01
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
	@SuppressWarnings (value="unchecked")


	String p_buyer			= CommonUtil.nvl((String)request.getAttribute("st_buyer"));
	String p_po_no			= CommonUtil.nvl((String)request.getAttribute("st_po_no"));
	String p_ds_date		= CommonUtil.nvl((String)request.getAttribute("st_ds_date"));
	String p_legacy_po_no	= CommonUtil.nvl((String)request.getAttribute("st_legacy_po_no"));
	String p_seller			= CommonUtil.nvl((String)request.getAttribute("st_seller"));
	String p_tr_buyer		= CommonUtil.nvl((String)request.getAttribute("st_tr_buyer"));
	
	String p_dely_to_location	= CommonUtil.nvl((String)request.getAttribute("st_dely_to_location"));
	String p_add_user_id		= CommonUtil.nvl((String)request.getAttribute("st_add_user_id"));
	
	// 운영사 업무대행에서 호출시 사용. (p_proxy_yn == Y)
	String p_proxy_yn	= CommonUtil.nvl((String)request.getAttribute("st_proxy_yn"));
	String p_agent		= CommonUtil.nvl((String)request.getAttribute("st_agent"));
	
	String p_user_id	= CommonUtil.nvl((String)request.getAttribute("st_add_user_id"));
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
	
	String po_no = "";
	String po_remark = "";
	String seller_amt = "";
	String seller_buyer = "";
	String ds_date = "";
	String surtax = "";
	String seller_com_name = "";
	String ttl_amt = "";
	String dely_to_location = "";
	String doc_type = "";
	String kepmro_doc_type = "";
	
	String process_type = "";
	
	String stx_rpt = "";
	String dsn_rpt = "";
	String rpt_url = "";
	
	String ktag_rpt = "";
	
	String sheet_inv_amt = "";
	String sheet_inv_tax_amt = "";
	String sheet_inv_tot_amt = "";
	
	String parcel_yn = "";
	
	String center_tel_no = "";
	
	if(detailInfo != null){
		po_no 				= CommonUtil.nvl(detailInfo.get("PO_NO"));
		po_remark 			= CommonUtil.nvl(detailInfo.get("PO_REMARK"));
		seller_amt 			= CommonUtil.nvl(detailInfo.get("SELLER_AMT"));
		seller_buyer 		= CommonUtil.nvl(detailInfo.get("SELLER_BUYER"));
		ds_date 			= CommonUtil.formatStrinigDate(detailInfo.get("DS_DATE"));
		surtax 				= CommonUtil.nvl(detailInfo.get("SURTAX"));
		seller_com_name 	= CommonUtil.nvl(detailInfo.get("SELLER_COM_NAME"));
		ttl_amt 			= CommonUtil.nvl(detailInfo.get("TTL_AMT"));
		dely_to_location 	= CommonUtil.nvl(detailInfo.get("DELY_TO_LOCATION"));
		doc_type 			= CommonUtil.nvl(detailInfo.get("DOC_TYPE"));
		kepmro_doc_type		= CommonUtil.nvl(detailInfo.get("KEPMRO_DOC_TYPE"));
		
		process_type		= CommonUtil.nvl(detailInfo.get("PROCESS_TYPE"));
		
		stx_rpt		= CommonUtil.nvl(detailInfo.get("STX_RPT"));
		dsn_rpt		= CommonUtil.nvl(detailInfo.get("DSN_RPT"));
		
		rpt_url		= CommonUtil.nvl(detailInfo.get("RPT_URL"));
		
		ktag_rpt		= CommonUtil.nvl(detailInfo.get("KTAG_RPT"));
		
		sheet_inv_amt = CommonUtil.nvl(detailInfo.get("SELLER_AMT2"));
		sheet_inv_tax_amt = CommonUtil.nvl(detailInfo.get("SURTAX2"));
		sheet_inv_tot_amt = CommonUtil.nvl(detailInfo.get("TTL_AMT2"));
		
		parcel_yn = CommonUtil.nvl(detailInfo.get("PARCEL_YN"));
		
		center_tel_no =  CommonUtil.nvl(detailInfo.get("CENTER_TEL_NO"));
	}

	//조회결과 - 상세 리스트
	List<Map<String, String>> detailList = (List<Map<String, String>>) request.getAttribute("data"); 
	
	//Map<String,String> orderRecvHeader = (Map<String,String>) request.getAttribute("orderRecvHeader"); // 조회결과 - 발주서인쇄 정보 조회
	
	//Map<String,String> specialLogicInfo = (Map<String,String>) request.getAttribute("specialLogicInfo"); // 조회결과 - 특수로직 정보 조회
	
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
			
		case "commonMpIvDlvryCarPop": // 배송차량조회
			openSearchPopup("/mpiv/getCommonMpIvDlvryCarPop.do", "?st_com_code="+value1, "580,400,no");
			break;
			
		case "commonMpIvDlvryNoticePop": // 납품시 공지정보
			openSearchPopup("/mpiv/getCommonMpIvDlvryNoticePop.do", "?st_type="+value1, value2);
			break;
		case "cmcInfoPop": // 물질정보
			if(value3 == "N"){
				alert("등록 된 물질정보가 없습니다.");
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
		document.forms[0].st_query.value = g_inv_param;
		kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteDoosanmecaPop.do","contentForm","btnSave");
	}
}  

// TR 협력사 배송 변경 팝업
function setDlvryNotice2(value1){
	document.forms[0].st_query.value = g_inv_param;
	
	kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteDoosanmecaPop.do","contentForm","btnSave");
}

var process_type = "<%=process_type%>";

// 납품서 생성
// else if((p_buyer.equals("KRDHIM0001") || p_buyer.equals("KRDOOS0046") || p_buyer.equals("KRDHIM0004")) && (dhim_legacy_po_no.equals("5") || dhim_legacy_po_no.equals("4") || dhim_legacy_po_no.equals("A")) && process_type.equals("0"))
function setDHIMCreate(){
	if(process_type == '0'){
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
		setInvoiceCreateDoosanmeca();
	}
}

// 납품서 생성
// else if(p_buyer.equals("KRDOOS0035") && legacy_flag.equals("Y") && process_type.equals("0"))
function setDMTCreate_new(){	    
    update_qty();  //한번 더 호출함
	if(process_type == '0'){
		alert(" PC환경에 따라 출력물 생성에 몇가지 프로그램이 설치될 수 있습니다. \n\n 출력물이 완전히 보이기 전까지는 창을 닫거나 다시 재 납품서 생성버튼을 클릭하기 마시지 바랍니다. ");
        
		var vendor_code = "OP00122";
		var inv_data = $("#st_inv_data").val();
		
		var loc  = 'http://doobuy.doosan.com/kep_invoice.jsp?';  //운영
			  loc += 'VENDOR_CODE='+vendor_code+'&INVOICE_DATA='+inv_data;

		//alert("loc : " + loc);
			 
		window.open(loc,"newW","left=0,top=0,width=1024,height=760,resizable=yes,scrollbars=no");
		window.close();
	}else{
		setInvoiceCreateDoosanmeca();
	}
}
	
/**
	거래명세서 작성
	1. 직납건 확인.
	2. 구매사 차량등록유무 확인.
	3. 공급사 차량 리스트 확인.
	4. 차량코드 확인.
	5.거래명세서 생성
**/
function setInvoiceCreateDoosanmeca(){	
	var parcel_yn = $("#st_parcel_type").val();
	
	if(isEmpty(parcel_yn)){
		alert("배송유형을 선택해주세요.");
		$("#st_parcel_type").focus();
		return;
	}
	
	var print_size = $("#st_print_size").val();
	var process_type = "<%=process_type%>";
	var ktag_rpt = "<%=ktag_rpt%>";

	if(process_type == "2" || ktag_rpt == "Y"){
		var print_size = $("#st_print_size").val();
		$("#ktag_box_qty").val($("#itemTag_box_qty").val());
		
		if(isEmpty(print_size)){
			alert("라벨출력방식을 선택해주세요.");
			$("#st_print_size").focus();
			return;
		}
	}
	
	document.contentForm.st_parcel_yn.value =  parcel_yn;
	
	if(confirm("거래명세서를 작성 하시겠습니까?")){		
	
		var buyer			= "<%=p_buyer%>";  
		var agent			= $("#st_agent_code").val();
		var process_type	= "<%=process_type%>";
		
		if(process_type == '0'){			
	
			var data = {
						  "st_type" : "cBuyer"
						, "st_buyer" : buyer
						, "st_agent" : agent
					
					};
			kepAjaxCall("/mpiv/getSellerMpivBuyerCarInfo.do", data,"carInfo"); 	
			
			
			/*
			var send_params = "st_type=cBuyer&st_buyer="+buyer+"&st_agent="+agent;
			sendRequest("/kr/agent/invoice/agent_invoice_ajax.jsp", send_params, setInvoiceCheckResult, 'POST');
			try{
			httpRequest.send(send_params);
			}catch(e){}
			*/
		}else{
			//직납 제외한 경우 바로 호출.
			inSetInvoiceCreateDoosanmeca();	
		}
	}
}

function setCarInfo(car_query){
	document.forms[0].st_car_info.value = car_query;      
	document.forms[0].st_car_flag.value = "Y";

	inSetInvoiceCreateDoosanmeca();
}
//납품공지사항 파라미터
var g_inv_param = "";
//거래명세서 작성
function inSetInvoiceCreateDoosanmeca(){	
	
	//================================================
	var checkRdDate ="<%=rdMonthCheck%>";
	var p060000080 = "<%=p060000080%>";
	
	if(checkRdDate == "OV"){
		alert("두산모트롤은 납품요구일이 익월일경우 납품서 생성을 할수가 없습니다.");
		return;
	}
	
	var disp_cnt = document.forms[0].display_item_cnt.value;
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
		alert('재고나 VMI는 거래명세서 생성이 불가능 합니다.');
		return;
	}
	
	//유해화학물질 여부
	var harmful_yn = "";
	var invoice_date = $.datepicker.formatDate('yymmdd', $("#st_invoice_date_text").datepicker("getDate"));
	
	// MSDS 진행 통제
	var cod_check	= ""; //ICOMCOD1 에 있는지 체크하는 변수
	var msds_check	= ""; //BYIT.MSDS_NO의 null여부
	var req_check   = ""; //KEP_CMC_REQ 의 상태 체크
	var buyer_item_no_arr = []; //등록해야할 품목코드
	var msds_no_reg_buyer_item_no_arr = []; //카탈로그에 MSDS 미등록 품목코드
	var tempMng_no_reg_buyer_item_no_arr = []; //카탈로그에 보관조건 미등록 품목코드
	
	var temp_check   = ""; //보관조건 체크
	var sg118_check = ""; // 시약류 체크
	var p070000033 = ""; // 보관조건이 필수인 고객사 목록
	var temp_cond = ""; // 보관조건 유형(실온/정온/냉장/냉동/극냉동)
	
	// 매입단가유효일 진행 통제
	var buy_close_date_chk = ""; // 매입단가유효일 체크
	
	//var invoice_date	= document.forms[0].st_invoice_date.value;
	
	/*
	document.forms[0].st_invoice_date.value = document.forms[0].st_invoice_date.value;// 납품확정일
	document.forms[0].st_inv_amt.value      = document.forms[0].inv_amt.value;        // 공급가액
	document.forms[0].st_inv_tax_amt.value  = document.forms[0].inv_tax_amt.value;    // 부가세(공급가액 10%)
	document.forms[0].st_inv_tax_rate.value = document.forms[0].inv_tax_rate.value;   // 부가세비율(0.1)
	document.forms[0].st_inv_tot_amt.value  = document.forms[0].inv_tot_amt.value;    // 총금액(공급가액+부가세)
	document.forms[0].st_remark.value       = document.forms[0].st_remark.value;      // 비고
	*/
	
	if(eval(disp_cnt) < 2){
		var box = eval("document.forms[0].checkbox"+0);
		if(box.checked == true){
			
			chk_cnt++;
		
			var complete_mark   = "N";
			
			buyer       = document.forms[0].st_buyer.value;
			po_no       = document.forms[0].st_po_no.value;
			po_seq      = document.forms[0].st_po_seq.value;
			ds_date     = document.forms[0].st_ds_date.value;
			cd_qty      = document.forms[0].st_cd_qty.value;
			poss_cd_qty = document.forms[0].st_poss_cd_qty.value;
			inv_qty      = document.forms[0].st_inv_qty.value;
		
			po_qty      = document.forms[0].st_po_qty.value;
			
			//유해화학 물질여부
			harmful_yn = document.forms[0].st_harmful_yn.value;
			
			if(process_type=="2"&&harmful_yn=="Y"){
                alert("유해 화학물질은 물류센터로 납품 불가능합니다.\nKeP담당자에게 연락 바랍니다.");
                return ;				
			}
			
			// MSDS 진행 통제 체크
			cod_check = document.forms[0].st_cod_check.value;
	    	msds_check = document.forms[0].st_msds_check.value;
	    	req_check = document.forms[0].st_req_check.value;
	    	
	    	temp_check = document.forms[0].st_temp_check.value;
	    	p070000033 = document.forms[0].p070000033.value;
	    	sg118_check = document.forms[0].st_sg118_check.value;
	    	temp_cond = document.forms[0].st_temp_cond.value;
	    	
	    	if(cod_check=="Y" && msds_check=="Y" && req_check=="N"){ //물질정보등록 대상이면서 msds미매핑 건 이면서 입력요청 외에 다른 상태 건 이 없는 경우 거래명세서 작성 통제
	     		buyer_item_no_arr.push(document.forms[0].st_buyer_item_no.value);	
	     	}
	    	
	    	if(cod_check=="Y" && msds_check=="Y"){ // MSDS 대상 표준카테고리에 해당하고 카탈로그 MSDS 미매핑 품목 리스트 - 통제 2024.07.19 HSJ
	    		msds_no_reg_buyer_item_no_arr.push(document.forms[0].st_buyer_item_no.value);	
	     	}
	    	
	    	if(p070000033 != "" && sg118_check == "Y" && temp_check == "Y"){ // 보관조건 입력 필수 고객사 & 카탈로그에 보관조건 미등록 품목 통제 - 2025.06.27 HSJ
	    		tempMng_no_reg_buyer_item_no_arr.push(document.forms[0].st_buyer_item_no.value);
	    	}
	    	
	    	// 매입단가유효일 진행 통제
	    	buy_close_date_chk = document.forms[0].st_buy_close_date_chk.value;
			if(buy_close_date_chk == "Y"){
				alert("해당 건 진행할 수 없습니다.\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
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
		            				alert("실온/정온은 TR로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
		               				return;
		            			}
		            		}else{
		            			if(process_type != "0"){
		            				alert("냉장/냉동은 직납으로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
		               				return;
		            			}
		            		}
	    				}
	        		}	
	    		}
	    	}
<%}%>

			if(p060000080 == "TYPE1"){
				size_yn		= document.forms[0].st_size_yn.value;
				size_len		= document.forms[0].st_size_len.value;
				size_qty		= document.forms[0].st_size_qty.value;
			}
			
            // 납품수량 = 납품가능수량 일때 ICOMPORS.COMPLETE_MARK = 'Y'로 설정
            // 납품수량   ==> 송장생성할 수량

            // ICOMPODT의 COMPLETE_MARK는 ICOMPORS.COMPLETE_MAKR가 모두 'Y'경우  ==>  ICOMPODT.COMPLETE_MAKR = 'Y'로 설정
            // ICOMPODT의 COMPLETE_MARK는 ICOMPODT.COMPLETE_MAKR가 모두 'Y'경우  ==>  ICOMPOHD.COMPLETE_MAKR = 'Y'로 설정


            if( poss_cd_qty == cd_qty){
                complete_mark = "Y";
            }
            
            if(cd_qty == 0){
                alert("납품수량을 0으로 지정할수 없습니다.");
                return ;
            }

			if((eval(cd_qty) + eval(inv_qty)) > eval(po_qty)) {
				alert("발주수량을 초과할수 없습니다");
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
	}else{
		for( k=0; k<disp_cnt ; k++){
			var box = eval("document.forms[0].checkbox" + k);
			if(box.checked == true){
				chk_cnt++;
				
				var complete_mark   = "N";
				
				buyer       = document.forms[0].st_buyer[k].value;
				ds_date     = document.forms[0].st_ds_date[k].value;
				po_no       = document.forms[0].st_po_no[k].value;
				po_seq      = document.forms[0].st_po_seq[k].value;
				cd_qty      = document.forms[0].st_cd_qty[k].value;
				poss_cd_qty = document.forms[0].st_poss_cd_qty[k].value;
                inv_qty     = document.forms[0].st_inv_qty[k].value;

				po_qty      = document.forms[0].st_po_qty[k].value;
				
				//유해화학 물질여부
				harmful_yn = document.forms[0].st_harmful_yn[k].value;
				
				if(process_type=="2"&&harmful_yn=="Y"){
	                alert("유해 화학물질은 물류센터로 납품 불가능합니다.\nKeP담당자에게 연락 바랍니다.");
	                return ;				
				}
				
				// MSDS 진행 통제 체크
				cod_check = document.forms[0].st_cod_check[k].value;
		    	msds_check = document.forms[0].st_msds_check[k].value;
		    	req_check = document.forms[0].st_req_check[k].value;
		    	
		    	temp_check = document.forms[0].st_temp_check[k].value;
		    	p070000033 = document.forms[0].p070000033[k].value;
		    	sg118_check = document.forms[0].st_sg118_check[k].value;
		    	temp_cond = document.forms[0].st_temp_cond[k].value;
		    	
		    	if(cod_check=="Y" && msds_check=="Y" && req_check=="N"){ //물질정보등록 대상이면서 msds미매핑 건 이면서 입력요청 외에 다른 상태 건 이 없는 경우 거래명세서 작성 통제
		     		buyer_item_no_arr.push(document.forms[0].st_buyer_item_no[k].value);	
		     	}
		    	
		    	if(cod_check=="Y" && msds_check=="Y"){ // MSDS 대상 표준카테고리에 해당하고 카탈로그 MSDS 미매핑 품목 리스트 - 통제 2024.07.19 HSJ
	        		msds_no_reg_buyer_item_no_arr.push(document.forms[0].st_buyer_item_no[k].value);	
	         	}
		    	
		    	if(p070000033 != "" && sg118_check == "Y" && temp_check == "Y"){ // 보관조건 입력 필수 고객사 & 카탈로그에 보관조건 미등록 품목 통제 - 2025.06.27 HSJ
		    		tempMng_no_reg_buyer_item_no_arr.push(document.forms[0].st_buyer_item_no[k].value);
		    	}
		    	
		    	// 매입단가유효일 진행 통제
		    	buy_close_date_chk = document.forms[0].st_buy_close_date_chk[k].value;
				if(buy_close_date_chk == "Y"){
					alert("해당 건 진행할 수 없습니다.\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
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
			            				alert("실온/정온은 TR로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
			               				return;
			            			}
			            		}else{
			            			if(process_type != "0"){
			            				alert("냉장/냉동은 직납으로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
			               				return;
			            			}
			            		}
		    				}
		        		}	
		    		}
		    	}
<%}%>

				if(p060000080 == "TYPE1"){
					size_yn		= document.forms[0].st_size_yn[k].value;
					size_len		= document.forms[0].st_size_len[k].value;
					size_qty		= document.forms[0].st_size_qty[k].value;
				}
				
				if( poss_cd_qty == cd_qty){
					complete_mark = "Y";
				}
				

                if(cd_qty == 0){
                    alert("납품수량을 0으로 지정할수 없습니다.");
                    return ;
                }

				if((eval(cd_qty) + eval(inv_qty)) > eval(po_qty)) {
					alert("발주수량을 초과할수 없습니다");
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
		}
	}
	//alert(query);
	if(chk_cnt == "0"){
		alert("거래명세서를 생성할 품목을 선택하여 주십시요");
		return;
	}
	
	if(buyer_item_no_arr.length != 0){ //수주접수 통제해야되는 건이 있는 경우
		if(confirm("해당 품목 ("+buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n\n카탈로그 관리 > 물질정보 제출 화면으로 이동하셔서 MSDS 및 물질정보 제출 후 KEP에서 MSDS매핑이 완료되면 거래명세서 작성하시기 바랍니다.\n\n확인을 누르면 물질정보 제출 요청이 됩니다.\n원하지 않으면 취소를 누르세요.\n\n*문의사항은 거래명세서 작성 화면에 있는 KeP담당자 통해서 하시길 바랍니다.")){
			//KEP_CMC_REQ insert 코드
			document.forms[0].st_query.value = query;
			kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteChemicalInfo.do","contentForm","saveChemInfo");
		}
		return;
	}
	
	if(tempMng_no_reg_buyer_item_no_arr.length != 0){ //수주접수 통제해야되는 건이 있는 경우
		if(confirm("해당 품목 ("+tempMng_no_reg_buyer_item_no_arr+") 은 보관조건(온도) 확인이 필요한 대상입니다.\n카탈로그 관리 > 물질정보 제출 화면으로 이동하셔서 물질정보 제출 후 KEP에서 승인되면 거래명세서 작성하시기 바랍니다.\n\n확인을 누르면 물질정보 제출 요청이 됩니다.\n원하지 않으면 취소를 누르세요.\n\n*문의사항은 거래명세서 작성 화면에 있는 KeP담당자 통해서 하시길 바랍니다.")){
			//KEP_CMC_REQ insert 코드
			document.forms[0].st_query.value = query;
			kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteChemicalInfo.do","contentForm","saveChemInfo");
		}
		return;
	}
	
	if(msds_no_reg_buyer_item_no_arr.length != 0){
		alert("해당 품목 ("+msds_no_reg_buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n현재 MSDS가 매핑되어 있지 않아 진행이 불가하니 확인하여 주시기 바랍니다.\n*문의사항은 거래명세서 작성 화면에 있는 KeP담당자 통해서 하시길 바랍니다.");
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
	
	if(p070000023_type != ""){
		g_inv_param = query;
		doPop('commonMpIvDlvryNoticePop', p070000023_type, p070000023_size);
		return;
	}else{
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
				document.forms[0].st_query.value  = query;
				kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteDoosanmecaPop.do","contentForm","btnSave");
			}
		}
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	if(pMethod == "carInfo"){
		var parcel_yn = $("#st_parcel_type").val();
		
		if(isEmpty(parcel_yn)){
			alert("배송유형을 선택해주세요.");
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
		opener.doAction("search");
		window.open('', '_self').close(); // IE버전에 따른 창 닫기 여부 무시
	}
	
	// 특수로직 추가 후 주석 풀기!!! 
	//opener.setQuery();
	//window.close();
	
	return;
}

// 거래명세서 작성 성공 후 호출
function setResult(response){
	
	var inv_no = response.inv_no;
	var buyer = "<%=p_buyer%>";
	var tr_buyer = "<%=p_tr_buyer%>";
	var com_code = $("#st_com_code").val(); 
	
	
	var action_flag = response.action_flag;
	
	if(action_flag == "DO"){
		alert("해당건에 대해서 현재 작업중입니다.");
		location.reload();
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
		alert("거래명세서를 고객사 시스템에 등록중입니다.\n[거래명세서 출력 및 삭제] 에서 확인 하시기 바랍니다.\n(납품서 출력은 약 20분 후 가능합니다)");
	} else if(solb_if_buyer_flag == "Y" && buyer == tr_buyer && solb_legacy_po_no == "4"){ // 솔브레인 IF 발주
		alert("거래명세서를 고객사 시스템에 등록중입니다.\n[거래명세서 출력 및 삭제] 에서 확인 하시기 바랍니다.\n(납품서 출력은 약 20분 후 가능합니다)");
	} else {
		alert("거래명세서 생성이 완료 되었습니다.\n\n거래명세서 번호는  " + inv_no + " 입니다.");	

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
	}
	
	// 품목라벨 대상 고객사 아니더라도 창원센터로 납품은 모두 품목라벨 출력(실장님)
	if(ktag_rpt == "Y" || ("<%=p_tr_buyer%>" == "KRKORE0068" && "<%=st_no_itemTag_check_yn%>" == "N")){	
		if ($("#ktag_selectbox2").val() == "4") {
			sheetTagListWin4(inv_no);
		}else if ($("#ktag_selectbox2").val() == "12") {
			sheetTagListWin12(inv_no);
		}
	}
	
	opener.doAction("search");
	window.close();
		
}

	
// 두산인프라코어 10개사의 경우 거래명세서 저장후, 리포트 오픈전, 인터페이스호출
function openIvUpdate(buyer, inv_no){ 
	document.forms[0].st_buyer.value  = buyer;
	document.forms[0].st_inv_no.value  = inv_no;
	document.forms[0].st_type.value  = "INS";
	
	kepAjaxFormCall("/mpiv/saveKrdhimInvoice.do","contentForm","saveIvUpdate");
	
	/*
	document.forms[0].target = "work";
	document.forms[0].method = "post";
	document.forms[0].action = "/kr/agent/invoice/krdhim_invoice_reg.jsp";
	document.forms[0].submit();
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
        alert("조회한 결과가 없습니다.");
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

//전체선택/해제
function checkAll(){
	var tot_cnt      = document.forms[0].display_item_cnt.value;
	//var check_status = document.forms[0].check_status.value;
	var check_status = $("#check_status").html();
	
	if(check_status == "전체"){
		for(var j = 0; j < tot_cnt; j++){
			var box = eval("document.forms[0].checkbox" + j);
			var check_status = "해제";
			
			if(box.checked == false) box.checked = true;
			
			//document.forms[0].check_status.value = check_status;
			$("#check_status").html(check_status);
		}
	} else {
		for(var j = 0; j < tot_cnt; j++){
			var box = eval("document.forms[0].checkbox" + j);
			var check_status = "전체";
			
			if(box.checked == true) box.checked = false;
			
			//document.forms[0].check_status.value = check_status;
			$("#check_status").html(check_status);
		}
	}
	
	if(tot_cnt!="0"){
		sum_price(); // 선택 품목 총 합계금액
	}
}

function update_qty(row){
	var buyer		= "<%=p_buyer%>"; 
	var tot_cnt		= document.forms[0].display_item_cnt.value;
	var inv_date	= "";
	var agent		=  $("#st_agent_code").val();

    if (row!= null){ // 납품서 생성버튼 클릭시 한번 더 호출할껀데 이때 row없음 
    if(eval(tot_cnt) < 2 ){
    	var imsi_qty            = $.trim(filterNum(document.forms[0].cd_qty.value));                // 납품수량
        var imsi_poss_cd_qty    = $.trim(filterNum(document.forms[0].st_poss_cd_qty.value));        // 납품가능수량
        var imsi_agent_price    = $.trim(filterNum(document.forms[0].st_agent_price.value));        // 단가


        if( !chkDecimal(imsi_qty,3) ){
            alert("납품수량은 소숫점 3자리 까지 입력 가능합니다. 확인 후 다시 입력해 주십시요");
            document.forms[0].cd_qty.value      = kepCommaNum(imsi_poss_cd_qty);
            document.forms[0].st_cd_qty.value   = imsi_poss_cd_qty;
            document.forms[0].item_amt.value    = kepCommaNum(imsi_agent_price * imsi_poss_cd_qty);
            document.forms[0].sheet_item_amt.value = document.forms[0].item_amt.value; 
            sum_price();
            
            return;
        }

        if(imsi_qty!=""){
            document.forms[0].cd_qty.value      = kepCommaNum(imsi_qty);
            document.forms[0].st_cd_qty.value   = imsi_qty;
            document.forms[0].item_amt.value    = kepCommaNum(imsi_agent_price * imsi_qty);
            document.forms[0].sheet_item_amt.value = document.forms[0].item_amt.value; 
        }
    }else{
    	var imsi_qty            = $.trim(filterNum(document.forms[0].cd_qty[row].value));               // 납품수량
        var imsi_poss_cd_qty    = $.trim(filterNum(document.forms[0].st_poss_cd_qty[row].value));        // 납품가능수량
        var imsi_agent_price    = $.trim(filterNum(document.forms[0].st_agent_price[row].value));        // 단가

        if( !chkDecimal(imsi_qty,3) ){
            alert("납품수량은 소숫점 3자리 까지 입력 가능합니다. 확인 후 다시 입력해 주십시요");
            document.forms[0].cd_qty[row].value         = kepCommaNum(imsi_poss_cd_qty);
            document.forms[0].st_cd_qty[row].value      = imsi_poss_cd_qty;
            document.forms[0].item_amt[row].value       = kepCommaNum(imsi_agent_price * imsi_poss_cd_qty);
            document.forms[0].sheet_item_amt[row].value = document.forms[0].item_amt[row].value; 
            sum_price();
            
            return;
        }


        if(imsi_qty!=""){
            document.forms[0].cd_qty[row].value         = kepCommaNum(imsi_qty);
            document.forms[0].st_cd_qty[row].value      = imsi_qty;
            document.forms[0].item_amt[row].value   = kepCommaNum(imsi_agent_price * imsi_qty);
            document.forms[0].sheet_item_amt[row].value = document.forms[0].item_amt[row].value; 
        }
    }// end else
    }

    if(buyer == "KRDOOS0035"){
    		if(eval(tot_cnt) < 2){
		    		var box = eval("document.forms[0].checkbox"+0);
		        if(box.checked == true){
				    		var dmtr_po_no   = document.forms[0].st_dmtr_po_no.value;
				    		var dmtr_po_seq  = document.forms[0].st_dmtr_po_seq.value;
				    		var dmtr_po_qty  = filterNum(document.forms[0].cd_qty.value);
				    		var dmtr_po_date = document.forms[0].st_dmtr_po_date.value;    		
				    		
				    		inv_date += dmtr_po_no    +"^";
				        inv_date += dmtr_po_seq   +"^";
				        inv_date += dmtr_po_qty   +"^";
				        inv_date += dmtr_po_date  ;        
				        inv_date += "!";
				     }
    	  }else{
    		
		    		for(var k = 0; k < tot_cnt; k++){
		    		var box = eval("document.forms[0].checkbox" + k);
		            if(box.checked == true){
		                var dmtr_po_no   = document.forms[0].st_dmtr_po_no[k].value;
						    		var dmtr_po_seq  = document.forms[0].st_dmtr_po_seq[k].value;
						    		var dmtr_po_qty  = filterNum(document.forms[0].cd_qty[k].value);
						    		var dmtr_po_date = document.forms[0].st_dmtr_po_date[k].value;    		
		    		
						    		inv_date += dmtr_po_no    +"^";
						        inv_date += dmtr_po_seq   +"^";
						        inv_date += dmtr_po_qty   +"^";
						        inv_date += dmtr_po_date  ;        
						        inv_date += "!";	
		            }
	    		}
        }  
        document.forms[0].st_inv_data.value = inv_date;
        
    }
    
    sum_price();
}

function update_len_qty(row){
	var buyer		= "<%=p_buyer%>"; 
	var tot_cnt		= document.forms[0].display_item_cnt.value;
	var inv_date	= "";
	var agent		=  $("#st_agent_code").val();

    if (row!= null){ // 납품서 생성버튼 클릭시 한번 더 호출할껀데 이때 row없음 
	    if(eval(tot_cnt) < 2 ){
	        var imsi_poss_cd_qty	= $.trim(filterNum(document.forms[0].st_poss_cd_qty.value));        // 납품가능수량
	        var imsi_agent_price		= $.trim(filterNum(document.forms[0].st_agent_price.value));        // 단가
	        var imsi_size_len			= $.trim(filterNum(document.forms[0].st_size_len.value));        // 길이
	        var imsi_size_qty			= $.trim(filterNum(document.forms[0].size_qty.value));        // 수량
	        var ori_size_qty			= $.trim(filterNum(document.forms[0].st_size_qty.value));        // 변경 전 수량
	        var imsi_qty				= imsi_size_len * imsi_size_qty;                // 납품수량
	        var ori_qty					= imsi_size_len * ori_size_qty;                // 변경 전 납품수량
	        
	        if( !chkDecimal(imsi_size_qty,2) ){
	            alert("수량은 소숫점 2자리 까지 입력 가능합니다. 확인 후 다시 입력해 주십시요");
	            document.forms[0].size_qty.value = kepCommaNum(ori_size_qty);
	            document.forms[0].st_size_qty.value = ori_size_qty;
	            document.forms[0].cd_qty.value = kepCommaNum(ori_qty);
	            document.forms[0].st_cd_qty.value = ori_qty;
	            document.forms[0].item_amt.value = kepCommaNum(imsi_agent_price * ori_qty);
	            document.forms[0].sheet_item_amt.value = document.forms[0].item_amt.value; 
	            sum_price();
	            
	            return;
	        }else{
	        	document.forms[0].size_qty.value = kepCommaNum(imsi_size_qty);
	            document.forms[0].st_size_qty.value = imsi_size_qty;
	            document.forms[0].cd_qty.value = kepCommaNum(imsi_qty);
	            document.forms[0].st_cd_qty.value = imsi_qty;
	            document.forms[0].item_amt.value = kepCommaNum(imsi_agent_price * imsi_qty);
	            document.forms[0].sheet_item_amt.value = document.forms[0].item_amt.value; 
	        }
	    }else{
	    	var imsi_poss_cd_qty	= $.trim(filterNum(document.forms[0].st_poss_cd_qty[row].value));        // 납품가능수량
	        var imsi_agent_price		= $.trim(filterNum(document.forms[0].st_agent_price[row].value));        // 단가
	        var imsi_size_len			= $.trim(filterNum(document.forms[0].st_size_len[row].value));        // 길이
	        var imsi_size_qty			= $.trim(filterNum(document.forms[0].size_qty[row].value));        // 수량
	        var ori_size_qty			= $.trim(filterNum(document.forms[0].st_size_qty[row].value));        // 변경 전 수량
	        var imsi_qty				= imsi_size_len * imsi_size_qty;                // 납품수량
	        var ori_qty					= imsi_size_len * ori_size_qty;                // 변경 전 납품수량
	        
	        if( !chkDecimal(imsi_size_qty,2) ){
	            alert("수량은 소숫점 2자리 까지 입력 가능합니다. 확인 후 다시 입력해 주십시요");
	            document.forms[0].size_qty[row].value = kepCommaNum(ori_size_qty);
	            document.forms[0].st_size_qty[row].value = ori_size_qty;
	            document.forms[0].cd_qty[row].value = kepCommaNum(ori_qty);
	            document.forms[0].st_cd_qty[row].value = ori_qty;
	            document.forms[0].item_amt[row].value = kepCommaNum(imsi_agent_price * ori_qty);
	            document.forms[0].sheet_item_amt[row].value = document.forms[0].item_amt[row].value; 
	            sum_price();
	            
	            return;
	        }else{
	        	document.forms[0].size_qty[row].value = kepCommaNum(imsi_size_qty);
	            document.forms[0].st_size_qty[row].value = imsi_size_qty;
	            document.forms[0].cd_qty[row].value = kepCommaNum(imsi_qty);
	            document.forms[0].st_cd_qty[row].value = imsi_qty;
	            document.forms[0].item_amt[row].value = kepCommaNum(imsi_agent_price * imsi_qty);
	            document.forms[0].sheet_item_amt[row].value = document.forms[0].item_amt[row].value; 
	        }
	    }// end else
    }

    sum_price();
}

function sum_price(){
    var tot_cnt  = document.forms[0].display_item_cnt.value;
    var sum_price = 0;
    var sheet_sum_price = 0;
    
    if(eval(tot_cnt) < 2){
        var box = eval("document.forms[0].checkbox"+0);
        if(box.checked == true){
            sum_price = eval(sum_price) + eval(kepFilterNum(document.contentForm.item_amt.value));
            sheet_sum_price = eval(sheet_sum_price) + eval(filterNum(document.contentForm.sheet_item_amt.value));
        }
    }else{
        for(var k = 0; k < tot_cnt; k++){
            var box = eval("document.forms[0].checkbox" + k);
            if(box.checked == true){
                sum_price = eval(sum_price) + eval(kepFilterNum(document.contentForm.item_amt[k].value));
                sheet_sum_price = eval(sheet_sum_price) + eval(filterNum(document.contentForm.sheet_item_amt[k].value));
            }
        }
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

    document.contentForm.st_inv_amt_text.value      =   kepCommaNum(sum_price) + " 원";
    document.contentForm.st_inv_tax_amt_text.value  =   kepCommaNum(tax_amt)   + " 원";
    document.contentForm.st_inv_tot_amt_text.value  =   kepCommaNum(eval(sum_price) + eval(tax_amt))   + " 원";

    document.contentForm.sheet_inv_amt.value        =   sheet_sum_price;
    document.contentForm.sheet_inv_tax_amt.value    =   sheet_tax_amt;
    document.contentForm.sheet_inv_tot_amt.value    =   eval(sheet_sum_price) + eval(sheet_tax_amt);

    /*
    top.top_f.document.forms[0].inv_amt.value       =   sum_price;
    top.top_f.document.forms[0].inv_tax_amt.value   =   tax_amt;
    top.top_f.document.forms[0].inv_tot_amt.value   =   eval(sum_price) + eval(tax_amt);
    */
}

function checkRemark(){
	
    if(kepGetByteLength("st_remark")>120){
        alert("비고란에 입력한 내용이 입력가능한 크기를 초과하였습니다.\n\n※한글(2byte) 영문,숫자,특수문자(1byte)로 120byte를 초과할 수 없습니다.")
        document.forms[0].st_remark.focus();
        return ;
    }   
}

</script> 
</head>

<body onload="kep_onload_view()">
<form name = "contentForm" id="contentForm" method = "post">

<!-- HIDDEN -->
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

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
    	<div id="popHeader">
        	<h1 class="title">거래명세서 작성</h1><!--  분할납품가능화면 -->
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!-- 거래명세서 작성 상세내용 -->  
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
			        <td height="23"></td>
			        <%
			            if(doc_type.equals("S") || (doc_type.equals("X") && kepmro_doc_type.equals("Y"))){
			        %>
			                <td align="right" valign="absbottom"><font color="red"><b>※ 선입고 발주건입니다.&nbsp;</b></font></td>
			        <%
			            } else if(doc_type.equals("F")){
			        %>
			                <td align="right" valign="absbottom"><font color="red"><b>※ 긴급 발주건입니다.&nbsp;</b></font></td>
			        <%
			            }
			        %>
			    </tr>
			    <tr>
			        <td bgcolor="#898989" height="1" colspan="2"></td>
			    </tr>
			
			    <tr>
			        <td colspan="2">
			            <table width="100%" border="0" cellspacing="0" cellpadding="0">
			                <tr height="25">
			                    <td width="13%" height="25" style="text-align:center"><font color="#993300">발주번호</font></td>
			                    <td>
			                    	<a class="hyperLink" href="javascript:doPop('commonMpIvOrderInfoPop','<%=p_buyer%>','<%=po_no%>');">
			                   			<%=po_no%>
			                   		</a>
			                    </td>
<%if(process_type.equals("2")|| ktag_rpt.equals("Y")){ %>
			                    <td width="13%" height="25" style="text-align:center"><font color="#993300">라벨출력방식</font></td>
			                    <td>
			                    	<select style="width: 150px;" name="st_print_size" id ="st_print_size">
			                    		<option value="">선택</option>
			                    		<option value="N">일반프린터(A4 4분할)</option>
			                    		<option value="L">라벨프린터(10x10cm)</option>
			                    	</select>
			                    </td>
<%}%>
<%if(process_type.equals("2")){ %>
			                    <td width="13%" height="25" style="text-align:center"><font color="#993300">박스수량</font></td>
			                    <td>
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
<%} %>
			                </tr>
			
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                
			                <tr height="25">
			                    <td style="text-align:center"><font color="#993300">공급받는자</font></td>
			                    <td><%=seller_buyer%></td>
			                    
			                    <td width="13%" style="text-align:center"><font color="#993300">총금액</font></td>
			                    <td width="20%" style="padding-top:2px !important;">
<%if(!com_type.equals("W")){%>
			                    	<input type="text"   name="st_inv_tot_amt_text" size="14" style="background-color:#FFFFFF;border:#FFFFFF 1px solid;" value="<%=CommonUtil.formatNumber(seller_amt,true,0,3)%> 원"  READONLY >
<%}else{%>
									<input type="hidden"   name="st_inv_tot_amt_text" size="14" class = "ar am input_type_text" style="background-color:#FFFFFF;border:#FFFFFF 1px solid;" value="<%=CommonUtil.formatNumber(seller_amt,true,0,3)%> 원"  READONLY >
<%}%>
			                    	<input type="hidden" name="st_inv_tot_amt" value ="<%=seller_amt%>">
			                    	
			                    	<input type="hidden"   name="st_inv_amt_text" size="14" class="ar input_type_text" style="background-color:#FFFFFF;border:#FFFFFF 1px solid;" value="<%=CommonUtil.formatNumber(seller_amt,true,0,3)%> 원"  READONLY >
			                    	<input type="hidden" name="st_inv_amt" value ="<%=seller_amt%>">
			                    	<input type="hidden" name="sheet_inv_amt"     value="<%=sheet_inv_amt%>">
									<input type="hidden" name="sheet_inv_tax_amt" value="<%=sheet_inv_tax_amt%>">
									<input type="hidden" name="sheet_inv_tot_amt" value="<%=sheet_inv_tot_amt%>">
									
									<input type="hidden"   name="st_inv_tax_amt_text" size="14" class="ar input_type_text" style="background-color:#FFFFFF;border:#FFFFFF 1px solid;" value="<%=CommonUtil.formatNumber(surtax,true,0,3)%> 원"  READONLY >
									<input type="hidden" name="st_inv_tax_amt"  value ="<%=surtax%>">  <!-- 부가세(10%)   공급가액의 10% -->                                               
									<input type="hidden" name="st_inv_tax_rate" value ="0.1">          <!-- 부가세(10%) , 부가세 비율 10 * 0.01 -->
			                    </td>
			                </tr>
			
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			
			                <tr height="25">
			                	<td style="text-align:center"><font color="#993300">납품예정일</font></td>
			                    <td ><%=ds_date%></td>
			                    
			                    <td style="text-align:center"><font color="#993300">납품일</font></td>
			                    <td>
								 	<input type="text"   name="st_invoice_date_text" size="10" id="st_invoice_date_text" class="input_type_text"  value='<%=CommonUtil.getCurrentDay_Time("yyMMdd")%>' readonly>
			                    </td>
			                    
			                    <td width="13%" style="text-align:center"><font color="#993300">배송유형</font></td>
			                    <td width="21%" >	
			                    	<select style="width: 100px;" name="st_parcel_type" id ="st_parcel_type">
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
			                    <td style="text-align:center"><font color="#993300">납품장소</font></td>
			                    <td colspan="5"><%=dely_to_location%>
			                    <%if(process_type.equals("2")){%>
			                    &nbsp;/ 수령자: 센터장&nbsp;/ 연락처 : <%=center_tel_no%>
			                    <br/> 
			                    <font color="red"><b>&nbsp;택배 발송 시 상단의 센터 정보로 입력하여 발송바랍니다.</b></font>
			                    <%} %>
			                    </td>
			                </tr>
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                <tr height="25">
			                    <td style="text-align:center"><font color="#993300">발주비고</font></td>
			                    <td colspan="5"><%=po_remark%></td>
			                </tr>
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                <tr height="25">
			                    <td style="text-align:center"><font color="#993300">메&nbsp;&nbsp;모</font></td>
			                    <td colspan="5"><input type="text" id="st_remark" name="st_remark" size="90" maxlength="120" value="" onChange="checkRemark()"></td>
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
            <div class="scrollArea" style="height:300px">
                <table  class="cont_t_list04"  style="width:100%">
                    <caption>거래명세서 작성 상세 리스트</caption>
                    <colgroup>
<%if(p060000080.equals("TYPE1")){%>
                        <col width="4%" />
                        <col width="15%" />
                        <col width="20%" />
                        <col width="8%" />
                        <col width="12%" />
                        <col width="12%" />
                        <col width="8%" />
                        <col width="6%" />
                        <col width="*" />
<%}else{%>
						<col width="4%" />
                        <col width="15%" />
                        <col width="25%" />
                        <col width="8%" />
                        <col width="12%" />
                        <col width="15%" />
                        <col width="15%" />
                        <col width="*" />
<%}%>
                    </colgroup>
                    <thead>
                        <tr>
                        	<th scope="col" rowspan="2">
	                        	<a href="javascript:checkAll();" id="check_status">전체</a>
	                        	<!-- input type="text" name="check_status" size="3px" value="전체" READONLY style="background-color:#fffaec;height=20;font-weight:normal;border:#EDE1B0;color:#1F1F1F; 1px solid;" class="ac"-->
                        	</th>
                            <th scope="col">관리번호</th> 
                            <th scope="col">품목명/제조사</th>
							<th scope="col">발주수량</th>
                            <th scope="col">단가/공급가액</th>
                            <th scope="col">기납품수량/단위</th>
                            <th scope="col">납기예정일</th>
						<%if(p060000080.equals("TYPE1")){%>
							<th scope="col">길이</th>
						<%}%>
                            <th scope="col" rowspan="2">비고</th> 
                        </tr>
                        <tr>
                            <th scope="col">품목코드</th> 
                            <th scope="col">규격</th>
                            <th scope="col" >물질정보</th>
                            <th scope="col" >유해화학물질</th>
                            <th scope="col">납품수량</th>
                            <th scope="col">납기요청일</th>
						<%if(p060000080.equals("TYPE1")){%>
							<th scope="col">수량</th>
						<%}%>
                        </tr>
                    </thead>
                    <tbody>
					<%
					
					String legacy_po_seq = "";
					String legacy_po_seq_a = "";
					String legacy_po_seq_tot = "";
					String pur_id = "";
					String inv_data = "";
					String inv_data_a = "";
					String inv_legacy_po = "";
					String inv_legacy_seq = "";
					String inv_legacy_qty = "";
					String inv_legacy_date = "";
					
					String tclass = ""; 
							
					rec_cnt = detailList.size();
					
					if (rec_cnt <= 0){
					%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="7" align="center" height = "50">
	                        <span class="font1">조회된 데이타가 없습니다.</span>
	                        </td> 
	                    </tr>
					<%
					} else {
						
						for (int j=0; j<rec_cnt; j++){
							page_display_cnt++;
							
							Map<String,String> rowData = detailList.get(j);
							
							legacy_po_seq 	= CommonUtil.nvl(rowData.get("LEGACY_PO_SEQ"));
							pur_id 			= CommonUtil.nvl(rowData.get("PURCHASER_ID"));
							inv_legacy_po   = CommonUtil.nvl(rowData.get("INV_LEGACY_PO_NO"));
							inv_legacy_seq  = CommonUtil.nvl(rowData.get("INV_LEGACY_PO_SEQ"));
							inv_legacy_qty  = CommonUtil.nvl(rowData.get("INV_POSS_QTY"));
							inv_legacy_date = CommonUtil.nvl(rowData.get("INV_LEGACY_DATE"));
							
							if(p_buyer.equals("KRDOOS0049")){
								
								if((j+1) == rec_cnt){  
									legacy_po_seq_a = legacy_po_seq + "";
								}else{
									legacy_po_seq_a = legacy_po_seq + ",";
								}
								
								legacy_po_seq_tot = legacy_po_seq_tot + legacy_po_seq_a;  
								legacy_po_seq_tot = legacy_po_seq_tot;
								
							}else if(p_buyer.equals("KRDOOS0035")){  
								
								inv_data_a = inv_legacy_po + "^" + inv_legacy_seq + "^" + inv_legacy_qty + "^" + inv_legacy_date + "!"; 	
								inv_data = inv_data + inv_data_a; 
								inv_data = inv_data;
								
							}else{
								
								legacy_po_seq_a = legacy_po_seq + "@@";	
								legacy_po_seq_tot = legacy_po_seq_tot + legacy_po_seq_a;
								legacy_po_seq_tot = legacy_po_seq_tot;
								
							}

							tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
					%> 
					
						<input type="hidden"   name="st_buyer"      value="<%=p_buyer%>">
						<input type="hidden"   name="st_po_no"      value="<%=p_po_no%>">
						<input type="hidden"   name="st_ds_date"      value="<%=p_ds_date%>">
						
						<input type="hidden" name="st_po_seq"  value="<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>">
						<input type="hidden" name="st_po_qty"       value="<%=CommonUtil.nvl(rowData.get("ITEM_QTY"))%>">
						<input type="hidden" name="st_dmtr_po_no"   value="<%=CommonUtil.nvl(rowData.get("INV_LEGACY_PO_NO"))%>">
						<input type="hidden" name="st_dmtr_po_seq"  value="<%=CommonUtil.nvl(rowData.get("INV_LEGACY_PO_SEQ"))%>">
						<input type="hidden" name="st_dmtr_po_date" value="<%=CommonUtil.nvl(rowData.get("INV_LEGACY_DATE"))%>">
						
						<input type="hidden" name="st_size_yn"       value="<%=CommonUtil.nvl(rowData.get("SIZE_YN"))%>">
                		
                		<input type="hidden" name="st_cod_check" value="<%=CommonUtil.nvl(rowData.get("COD_CHECK"))%>">
						<input type="hidden" name="st_msds_check" value="<%=CommonUtil.nvl(rowData.get("MSDS_CHECK"))%>">
						<input type="hidden" name="st_req_check" value="<%=CommonUtil.nvl(rowData.get("REQ_CHECK"))%>">
						<input type="hidden" name="st_buyer_item_no" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>">
						<input type="hidden" name="st_buy_close_date_chk" value="<%=CommonUtil.nvl(rowData.get("BUY_CLOSE_DATE_CHK"))%>">
                		
                		<input type="hidden" name="st_harmful_check"      value="<%=CommonUtil.nvl(rowData.get("CMC_HARMFUL_YN"))%>">
						<input type="hidden" name="st_temp_check"      value="<%=CommonUtil.nvl(rowData.get("TEMP_CHECK"))%>">
						<input type="hidden" name="p070000033" value="<%=p070000033%>">
						<input type="hidden" name="st_temp_cond" value="<%=CommonUtil.nvl(rowData.get("TEMP_COND"))%>">
						<input type="hidden" name="st_sg118_check" value="<%=CommonUtil.nvl(rowData.get("SG118_CHECK"))%>">
						
                        <tr bgcolor="<%=tclass%>">
							<td rowspan="2">
								<!-- CHECKBOX -->
								<input type="checkbox" name="checkbox<%=j%>" value="" id="check" checked onClick="javascript:sum_price();">
								</a>
							</td>
							<td class="left">
								<!-- 관리번호 -->
							 	<%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%>
							</td>
							<td class="left">
								<!-- 품명/제조사 -->
							 	<%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%>
							</td>
							<td>
								<!-- 발주수량 -->
							 	<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("ITEM_QTY")),true,0,3)%>
							</td>
							<td class="right">
								<!-- 단가 -->
								<%	if(p_buyer.equals("KRDOOS0020")||p_buyer.equals("KRKEPB00045")){		%>
										<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("AGENT_PRICE")),true,0,3)%>
										<input type="hidden" name="st_agent_price" size="11" class="ar input_type_text" style="background-color:<%=tclass%>;border:<%=tclass%> 1px solid;" value="<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("AGENT_PRICE")),true,0,3)%>" READONLY >
								
								<%	} else {	%>
									<%if(!com_type.equals("W")){%>
										<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("UNIT_PRICE")),true,0,3)%>
									<%}%>
										<input type="hidden" name="st_agent_price" size="11" class="ar input_type_text" style="background-color:<%=tclass%>;border:<%=tclass%> 1px solid;" value="<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("UNIT_PRICE")),true,0,3)%>" READONLY >
								
								<%	}	%>
								<!-- 공급가액 -->
								<%	if(p_buyer.equals("KRDOOS0020")||p_buyer.equals("KRKEPB00045")){		%>
										/<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("SELLER_AMT2")),true,0,3)%>
									 	<input type="hidden" name="item_amt" size="11" class="ar input_type_text" style="background-color:<%=tclass%>;border:<%=tclass%> 1px solid;" value="<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("SELLER_AMT2")),true,0,3)%>" READONLY >
									 	<input type="hidden" name="sheet_item_amt" value="<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("SELLER_AMT")),true,0,3)%>" >
								<%	} else {	%>
									<%if(!com_type.equals("W")){%>
										/<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("SELLER_AMT2")),true,0,3)%>
									<%}%>
										<input type="hidden" name="item_amt" size="11" class="ar input_type_text" style="background-color:<%=tclass%>;border:<%=tclass%> 1px solid;" value="<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("SELLER_AMT2")),true,0,3)%>" READONLY >
										<input type="hidden" name="sheet_item_amt" value="<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("SELLER_AMT")),true,0,3)%>" >
										
								<%	}	%>
							
							</td>
							<td>
								<!-- 기납품수량 -->
								<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("INV_COMP_QTY")),true,0,3)%>
								<!-- 단위 -->
							 	/<%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>
							</td>
							<td>
								<!-- 납품예정일 -->
							 	<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("INV_LEGACY_DATE")))%>
							</td>
<%if(p060000080.equals("TYPE1")){%>
							<td>
								<!-- 길이 -->
						<%if(CommonUtil.nvl(rowData.get("SIZE_YN"),"").equals("Y")){%>
							<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("SIZE_LEN")),true,0,3)%>
						<%}%>
								<input type="hidden" name="st_size_len"       value="<%=CommonUtil.nvl(rowData.get("SIZE_LEN"))%>">
							</td>
<%}%>
							<td rowspan="2">
								<!-- 비고 -->
							 	<textarea cols="20" rows="3" style="overflow:auto" readonly><%=CommonUtil.nvl(rowData.get("PO_REMARK"))%></textarea>
							</td>
                        </tr> 
                        <tr bgcolor="<%=tclass%>">
							<td>
								<!-- 품목코드 -->
								<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>
							</td>
							<td class="left">
								<!-- 규격 -->
					 	<%if(p070000033.equals("TYPE0") || p070000033.equals("TYPE1")){%>
							<%if(CommonUtil.nvl(rowData.get("SG118_CHECK")).equals("Y")){%>
							 	<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("TEMP_COND_TEXT"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("TEMP_RANGE"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("HARMFUL_TEXT"))%>
							<%}else{%>
								<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
							<%}%>	
						<%}else{%>
								<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
						<%}%>
							</td>
							<td  class="center" >
								<!-- 물질정보 -->
				                <%
									if(CommonUtil.nvl(rowData.get("CMC_INFO_YN")).equals("Y")) {
				                %>
									<a href="javascript:doPop('cmcInfoPop','<%=rowData.get("CMC_REQ_NO")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CMC_INFO_YN")%>', '<%=rowData.get("SG118_CHECK")%>');"><img name="Image2" src="/resources/images/icon.gif" border="0"></a>
				                <%
									}else {
				                %>
									<a href="javascript:doPop('cmcInfoPop','<%=rowData.get("CMC_REQ_NO")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CMC_INFO_YN")%>', '<%=rowData.get("SG118_CHECK")%>');"><img name="Image2" src="/resources/images/icon2.gif" border="0"></a>
				                <%
									}
				                %>
							</td>
							<td  class="center" >
								<!-- 유해물질여부 -->
								<input type="hidden" name="st_harmful_yn"      value="<%=CommonUtil.nvl(rowData.get("CMC_HARMFUL_YN"))%>"> 
							 	<%=CommonUtil.nvl(rowData.get("CMC_HARMFUL_YN"))%>
							</td>
							<td>
								<!-- 납품수량 -->
						<%if(p060000080.equals("TYPE1") && CommonUtil.nvl(rowData.get("SIZE_YN"),"").equals("Y")){%>
								<input type="text"   name="cd_qty" size="7" class="ar input_type_text" style="background-color:<%=tclass%>;border:<%=tclass%> 1px solid;" value="<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("INV_POSS_QTY")),true,0,3)%>"  READONLY>
						<%}else{%>
							<% if( CommonUtil.nvl(rowData.get("DS_YN"),"").equals("Y") ){ %> <!-- 고객사 요청 분할 Y -->
								<input type="text" name="cd_qty" size="7" class="ar input_type_text" value="<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("INV_POSS_QTY")),true,0,3)%>" onchange="javascript:update_qty(<%=j%>);" />
							<% } else { %> <!-- 고객사 요청 분할 N -->
								<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("INV_POSS_QTY")),true,0,3)%>
								<input type="hidden" name="cd_qty" size="7" class="ar input_type_text" value="<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("INV_POSS_QTY")),true,0,3)%>" onchange="javascript:update_qty(<%=j%>);" />
							<% } %>
						<%}%>								
								<input type="hidden" name="st_cd_qty"       value="<%=CommonUtil.nvl(rowData.get("INV_POSS_QTY"))%>">
								<input type="hidden" name="st_poss_cd_qty"  value="<%=CommonUtil.nvl(rowData.get("INV_POSS_QTY"))%>">    <!-- 납품가능수량       -->
								<input type="hidden" name="st_orgin_cd_qty" value="<%=CommonUtil.nvl(rowData.get("INV_LEGACY_QTY"))%>">   <!-- ICOMPORS.CD_QTY    -->
								<input type="hidden" name="st_inv_qty"      value="<%=CommonUtil.nvl(rowData.get("IV_QTY"))%>">   <!-- ICOMPORS의 각 품목에 대한 송장수량 -->

							</td>
							<td>
								<!-- 납기요청일 -->
                                <%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("RD_DATE")))%>
							</td>
<%if(p060000080.equals("TYPE1")){%>
							<td>
								<!-- 수량 -->
						<%if(CommonUtil.nvl(rowData.get("SIZE_YN"),"").equals("Y")){%>
								<input type="text" name="size_qty" class="ar input_type_text" style="width:80%" value="<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("INV_POSS_SIZE_QTY")),true,0,3)%>" onchange="javascript:update_len_qty(<%=j%>);" />
						<%}else{%>
								<input type="hidden" name="size_qty">
						<%}%>
								<input type="hidden" name="st_size_qty"       value="<%=CommonUtil.nvl(rowData.get("INV_POSS_SIZE_QTY"))%>">
							</td>
<%}%>
                        </tr> 
					<%
						}
					}
					%>
  
                    </tbody>
                </table>     
                <input type="hidden" id="display_item_cnt" 	name="display_item_cnt"    value="<%=page_display_cnt%>">
                <input type="hidden" id="legacy_po_seq_tot" name="legacy_po_seq_tot"   value="<%=legacy_po_seq_tot%>">
		        <input type="hidden" id="st_pur_id"			name="st_pur_id"		value="<%=pur_id%>">
		        <input type="hidden" id="st_inv_data"		name="st_inv_data"   	value="<%=inv_data%>">
        </div>
        
        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:8px;">
			<%
       			if(p_buyer.equals("KRDOOS0003")){
		    %>
		        <tr>
		            <td height="25" align="left">
		                ※ 납품일은 당일기준 <font color="red"> 전후 3일만 </font>가능합니다.
		            </td>
		        </tr>
		    <%
		        }
		    %>
			<tr>
				<td align="right">
					<div class="btnArea">
						<div class="fr">
						<% 
							// 두산메카텍(주) 공작기계 사업부(KRDOOS0003) => 삭제대상 고객사 
							//if(p_buyer.equals("KRDOOS0003")) { 
						%>
							<!-- 
								<span class="btn_04">
									<a href="javascript:distribute_info()">분납정보</a>
								</span>
							-->
						<% 
							//}
						%>
						
						<%
						//해당 고객사 조건 삭제
						//if((p_buyer.equals("KRHYNI0001") || p_buyer.equals("KRHYNI0002") || p_buyer.equals("KRHYNI0003")) && legacy_flag.equals("Y")) { %>
						
							<!-- 
								<span class="btn_10">
									<a href="/kr/guide_down/HYNIX.exe">하이닉스 인증서설치</a> &nbsp;
								</span>
			  
			  					<span class="btn_10">
									<a href="/kr/guide_down/KICA_MoveCertSet.exe">Windows7 인증서 자동이관설치파일</a> &nbsp;
								</span>
								
								<span class="btn_10">
									<a href="/kr/guide_down/BARCODE05.zip">하이닉스 바코드폰트설치</a> &nbsp;
								</span>
								
								<span class="btn_10">
									<a href="javascript:setHynixInvoice();">하이닉스 납품서생성</a> &nbsp;
								</span>
							  -->
						<!--  -->
							<%
							if(ktag_rpt.equals("Y") || (p_tr_buyer.equals("KRKORE0068") && st_no_itemTag_check_yn.equals("N"))){
							%>
								<span class ="btn_10_blue mr04" style="vertical-align:top; line-height:22px;padding-top:2px; color:#FFF; display:none;">
									KTAG출력위치
									<select id="ktag_selectbox" name="ktag_selectbox" style="width:40px; margin-top:3px">
				                    <option value="1" seleceted>1</option>
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
			                    </span>
								<span class="btn_10_blue mr04" style="vertical-align:top; line-height:22px;padding-top:2px; color:#FFF; display:none;">
									K tag출력
									<select id="ktag_selectbox2" name="ktag_selectbox2" style="width:60px; margin-top:3px">
				                    <option value="12" >12칸</option>
				                    <option value="4" selected>4칸</option>
				                    </select> 
								</span>
						<%} %>
						<%
							//KRDHIM0004 고객사 삭제
							//} else if((p_buyer.equals("KRDHIM0001") || p_buyer.equals("KRDAEW0023") || p_buyer.equals("KRDOOS0046") || p_buyer.equals("KRDHIM0004")) && (p_legacy_po_no.length()!=14 || dhim_legacy_po_no.equals("5") || dhim_legacy_po_no.equals("4") || dhim_legacy_po_no.equals("A"))) {
							if((p_buyer.equals("KRDHIM0001") || p_buyer.equals("KRDAEW0023") || p_buyer.equals("KRDOOS0046")) && (p_legacy_po_no.length()!=14 || dhim_legacy_po_no.equals("5") || dhim_legacy_po_no.equals("4") || dhim_legacy_po_no.equals("A"))) {  %>
								
								<span class="btn_04">
									<a href="javascript:setDHIMCreate();">납품서생성</a> &nbsp;
								</span>
							
						<!-- KRDOOS0049 고객사 삭제 -->
						<%  
							// KRDOOS0049 고객사 삭제
							//} else if(p_buyer.equals("KRDOOS0049") && legacy_flag.equals("Y") && process_type.equals("0")) {  %>
								<!-- 	
								<span class="btn_04">
									<a href="javascript:setDMTCreate();">납품서생성</a> &nbsp;
								</span>
								 -->
							 
						<%  } else if(p_buyer.equals("KRDOOS0035") && legacy_flag.equals("Y") && process_type.equals("0")) {  %>
						
								<span class="btn_04">
									<a href="javascript:setDMTCreate_new();">납품서생성</a> &nbsp;
								</span>
							 
						<%  } else {       %>
						
								<span class="btn_04">
									<a href="javascript:setInvoiceCreateDoosanmeca();">저장</a>
								</span>
							 
						<%  }       %>
		  							
			            </div>
			        </div>
					
					<!-- a href="javascript:top.window.close();"><img src="/kr/agent/images/button/btn_close.gif"	width="64" height="27" border="0" align="absmiddle" ></a -->
				</td>
			</tr>
		</table>
    </div>        
</div>
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
