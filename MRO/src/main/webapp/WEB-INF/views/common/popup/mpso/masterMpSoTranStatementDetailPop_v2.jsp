<%--
**********************************************
* 메뉴 : 
* 화면 : 거래명세서 상세조회
* 기능 : 거래명세서 상세조회 및 납품실적 등록을 대행한다.
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-09-17
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>

<%
	@SuppressWarnings (value="unchecked")
	
	String pBuyer 	= CommonUtil.nvl((String)request.getParameter("st_buyer"));
	String pPoNo	= CommonUtil.nvl((String)request.getParameter("st_po_no"));
	String pInvNo	= CommonUtil.nvl((String)request.getParameter("st_inv_no"));
	
	Map<String,String> detailInfo = (Map<String,String>) request.getAttribute("detailInfo"); // 조회결과 - 상세정보
	List<Map<String, String>> detailList = (List<Map<String, String>>) request.getAttribute("detailList"); // 조회결과 - 상세 리스트
	
	// 물류센터 고객사 체크
	String w001flag = (String) request.getAttribute("w001flag");
	
	String RPT_URL = CommonUtil.nvl(detailInfo.get("RPT_URL"));
	String SELLER = CommonUtil.nvl(detailInfo.get("SELLER"));
	String LEGACY_PO_NO = CommonUtil.nvl(detailInfo.get("LEGACY_PO_NO"));
	String PURCHASER_ID = CommonUtil.nvl(detailInfo.get("PURCHASER_ID"));
	String LEGACY_IV_SERIAL = CommonUtil.nvl(detailInfo.get("LEGACY_IV_SERIAL"));
	String TR_BUYER = CommonUtil.nvl(detailInfo.get("TR_BUYER"));
	String PROCESS_TYPE = CommonUtil.nvl(detailInfo.get("PROCESS_TYPE"));
	String DS_DATE = CommonUtil.nvl(detailInfo.get("DS_DATE"));
	//배송증빙 관련 추가
	String PARCEL_COM_CODE = CommonUtil.nvl(detailInfo.get("PARCEL_COM_CODE"));
	String IMAGE_KEY_INV = CommonUtil.nvl(detailInfo.get("IMAGE_KEY_INV"));
	String IMAGE_KEY_SIGN = CommonUtil.nvl(detailInfo.get("IMAGE_KEY_SIGN"));
	String INV_NO = CommonUtil.nvl(detailInfo.get("INV_NO"));
	String BUYER = CommonUtil.nvl(detailInfo.get("BUYER"));
	
	String AGENT = CommonUtil.nvl(detailInfo.get("AGENT"));
	
	String AP_BILL_FLAG = CommonUtil.nvl(detailInfo.get("AP_BILL_FLAG"));
	
	int page_display_cnt = 0;
	
	String com_type = "";
	String kep_user_id = "";
	if (_sessionInfo != null){
		com_type =  CommonUtil.nvl((String)_sessionInfo.getComType());
		kep_user_id =  CommonUtil.nvl((String)_sessionInfo.getUserId());
	}
	
	// 솔브레인 관련 IF발주번호 확인
	String solb_if_buyer = "N";
	boolean p070000032 = CommonUtil.getSpecialCheckReturn(pBuyer,"P07-0000032");
	if(p070000032 == true){
		solb_if_buyer = "Y";
	}
	
	String dhim_legacy_po_no = "";
	
	if(LEGACY_PO_NO.length() > 1){
		dhim_legacy_po_no = LEGACY_PO_NO.substring(0,1);
	}
	
	// 입고라벨 미사용 대상 고객사(TR이어도 고객사 고유의 양식 사용)
	String st_no_tag_check_yn = "N";
	boolean st_no_tag_check = CommonUtil.getCodeCheckReturn("M204", BUYER);
	if(st_no_tag_check == true){
		st_no_tag_check_yn = "Y";
	}else{
		st_no_tag_check_yn = "N";
	}
	
	// 품목라벨 자체 사용 고객사(KEP 품목라벨은 중복되어 출력되지 않아야 함)
	String st_no_itemTag_check_yn = "N";
	boolean st_no_itemTag_check = CommonUtil.getCodeCheckReturn("M206", BUYER);
	if(st_no_itemTag_check == true){
		st_no_itemTag_check_yn = "Y";
	}else{
		st_no_itemTag_check_yn = "N";
	}
	
	// 고객사 고유 품목라벨 사용
	String p070000034 = "";
	Map<String, String> p070000034_map = CommonUtil.getSpecialCheckReturnMap(BUYER,"P07-0000034");
	if (p070000034_map != null){
    	p070000034 = CommonUtil.nvl(p070000034_map.get("COL01_DATA"),""); // 품목라벨 mrd 1개만
    }
%>
<script>
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	kepAjaxCommonCombo("st_parcel_com_code", "C019", "SEL");
	document.forms[0].st_parcel_com_code.value = "<%=PARCEL_COM_CODE%>";
	kepSetCalender('st_invoice_date_text');
}

//기능함수
function doAction(str) {
	switch (str) {
		case "create": //등록
			//kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoTranStatementDetailPop.do" , pagingMode );
			setDeliveryRsltCreate();
			break;
	}
}


//납품실적등록
function setDeliveryRsltCreate(){

	var tot_cnt = $("#display_item_cnt").val();
	var query   = "";
	var chk_cnt = 0;    // 납품실적등록할 품목수
	
	var buyer	 		= "";
	var po_no			= "";
	var po_seq			= "";
	var inv_no			= "";
	var inv_seq			= "";
	var invoice_date	= "";
	var delivery_qty	= "";
	var delivery_date	= $.datepicker.formatDate('yymmdd', $("input[name=st_invoice_date_text]").datepicker("getDate"));
	//자동입고 여부. 고객사옵션
	var st_gr_auto_flag = "";
	var st_image_key = "";
	var db_buyer_nm = "";
	var db_process_type = "";
	//자동입고처리 FLAG
	var exe_gr_auto_flag = "N"
	//택배번호 추가 입력 기능
	var st_parcel_inv_no = "";
	var st_parcel_com_code = "";
	var db_parcel_inv_no = "";
	var db_parcel_com_code = "";
	var db_buyer_nm=  "";
	var cur_date = kepGetNowTimeStr("YYYYMMDD", "");           // 현재날짜
	var st_parcel_yn = "N";
	var st_parcel_changed = "N"; // 택배 송장 변경여부 확인
	
	if(eval(tot_cnt) == 0){
		alert("대상 품목이 없습니다.");
		return;
	}

	if(eval(tot_cnt) < 2){

		var box = eval("document.forms[0].checkbox"+0);
		if(box.checked == true){
			chk_cnt++;
			
			buyer           = document.forms[0].db_buyer.value;
			po_no           = document.forms[0].db_po_no.value;
			po_seq          = document.forms[0].db_po_seq.value;
			inv_no          = document.forms[0].db_inv_no.value;
			inv_seq         = document.forms[0].db_inv_seq.value;
			invoice_date    = document.forms[0].db_inv_date.value;
			delivery_qty    = document.forms[0].st_delivery_qty.value;
			
			if(eval(invoice_date) > eval(cur_date)){
			    alert("납품일("+invoice_date+") 이 후 부터 실적등록이 가능합니다.\n\n※ 납품 완료 후 실적을 등록해 주십시요");
			    box.checked = false;
			    return;
			}
			
			if(eval(invoice_date) > eval(delivery_date)){
			    alert("납품일("+invoice_date+") 이 후 부터 실적등록이 가능합니다.\n\n※ 납품 완료 후 실적을 등록해 주십시요");
			    box.checked = false;
			    return;
			}
			/*
			고객사 옵션이 자동입고 로직
			1. 직납일때만 첨부기능.(협력사)
			2. 택배송장번호 입력건은 배송증빙처리 불필요
			3. 택번거 이외 모든건 배송증빙 처리 해야함
			*/
			st_gr_auto_flag = document.forms[0].st_gr_auto_flag.value;
			st_image_key = document.forms[0].st_image_key.value;
			db_process_type = document.forms[0].db_process_type.value;
			st_parcel_inv_no = document.forms[0].st_parcel_inv_no.value;
			st_parcel_com_code = document.forms[0].st_parcel_com_code.value;
			db_buyer_nm  = document.forms[0].db_buyer_nm.value;
			if(st_gr_auto_flag == "Y"&&db_process_type == "0"){
				exe_gr_auto_flag = "Y";	
				if(st_parcel_com_code == "" || st_parcel_com_code == null){
					if(st_image_key == "" || st_image_key == null){
						alert("고객사: "+db_buyer_nm+ " 거래명세서번호: "+inv_no+"\n배송완료 증빙 처리 바랍니다.");
						return;
					}
				}else{
					//택배건은 자동입고 처리 안함.
					exe_gr_auto_flag = "N";	
				}
			}
			
			// 택배사 코드가 채워져있는데 택배송장번호가 없는 경우 / 택배송장번호가 채워져 있는데 택배사 코드가 없는 경우
			if((!isEmpty(st_parcel_com_code) && isEmpty(st_parcel_inv_no)) || (isEmpty(st_parcel_com_code) && !isEmpty(st_parcel_inv_no)) ){
				alert("택배사와 송장번호를 확인해주시기 바랍니다.")
				return;
			}
			
			// 택배사코드 택배송장번호가 다 채워져있는 경우 둘 중 하나이상이 변화가 있는 경우에만 택배정보 변경자, 일자 변경 
			if(!isEmpty(st_parcel_com_code) && !isEmpty(st_parcel_inv_no)){
				st_parcel_yn = "Y";
				db_parcel_inv_no = document.forms[0].db_parcel_inv_no.value;
				db_parcel_com_code = document.forms[0].db_parcel_com_code.value;
				if( (db_parcel_com_code != st_parcel_com_code) || (db_parcel_inv_no != st_parcel_inv_no) ){
					st_parcel_changed = "Y";
				}
			}
			
			query +=  buyer         + "@@";
			query +=  po_no         + "@@";
			query +=  po_seq        + "@@";
			query +=  inv_no        + "@@";
			query +=  inv_seq       + "@@";
			query +=  delivery_qty  + "@@";
			query +=  delivery_date   + "@@";
			query +=  st_image_key + "@@";
			query +=  exe_gr_auto_flag+ "@@";
			query +=  st_parcel_com_code+ "@@";
			query +=  st_parcel_inv_no+ "@@";
			query +=  st_parcel_yn+ "@@";
			query +=  st_parcel_changed;
			query +=  "^||^" ;
		}

	} else {
		for(var k = 0; k < tot_cnt; k++){
			var box = eval("document.forms[0].checkbox"+k);
			st_parcel_changed = "N";
			if(box.checked == true){
				chk_cnt++;
				
				buyer           = document.forms[0].db_buyer[k].value;
				po_no           = document.forms[0].db_po_no[k].value;
				po_seq          = document.forms[0].db_po_seq[k].value;
				inv_no          = document.forms[0].db_inv_no[k].value;
				inv_seq         = document.forms[0].db_inv_seq[k].value;
				invoice_date    = document.forms[0].db_inv_date[k].value;
				delivery_qty    = document.forms[0].st_delivery_qty[k].value; 
				
				if(eval(invoice_date) > eval(cur_date)){
					alert(k + "번째 품목은 납품일("+invoice_date+") 이 후 부터 실적등록이 가능합니다.\n\n※ 납품 완료 후 실적을 등록해 주십시요");
					box.checked = false;
					return;
				}
				
				if(eval(invoice_date) > eval(delivery_date)){
				    alert(k + "번째 품목은 납품일("+invoice_date+") 이 후 부터 실적등록이 가능합니다.\n\n※ 납품 완료 후 실적을 등록해 주십시요");
				    box.checked = false;
				    return;
				}
				/*
				고객사 옵션이 자동입고 로직
				1. 직납일때만 첨부기능.(협력사)
				2. 택배송장번호 입력건은 배송증빙처리 불필요
				3. 택번거 이외 모든건 배송증빙 처리 해야함
				*/
				st_gr_auto_flag = document.forms[0].st_gr_auto_flag.value;
				st_image_key = document.forms[0].st_image_key.value;
				db_process_type = document.forms[0].db_process_type.value;
				st_parcel_inv_no = document.forms[0].st_parcel_inv_no.value;
				st_parcel_com_code = document.forms[0].st_parcel_com_code.value;
				db_buyer_nm  = document.forms[0].db_buyer_nm.value;
				if(st_gr_auto_flag == "Y"&&db_process_type == "0"){
					exe_gr_auto_flag = "Y";	
					if(st_parcel_com_code == "" || st_parcel_com_code == null){
						if(st_image_key == "" || st_image_key == null){
							alert("고객사: "+db_buyer_nm+ " 거래명세서번호: "+inv_no+"\n배송완료 증빙 처리 바랍니다.");
							return;
						}
					}else{
						//택배건은 자동입고 처리 안함.
						exe_gr_auto_flag = "N";	
					}
				}
				
				// 택배사 코드가 채워져있는데 택배송장번호가 없는 경우 / 택배송장번호가 채워져 있는데 택배사 코드가 없는 경우
				if((!isEmpty(st_parcel_com_code) && isEmpty(st_parcel_inv_no)) || (isEmpty(st_parcel_com_code) && !isEmpty(st_parcel_inv_no)) ){
					alert("택배사와 송장번호를 확인해주시기 바랍니다.")
					return;
				}
				
				// 택배사코드 택배송장번호가 다 채워져있는 경우 둘 중 하나이상이 변화가 있는 경우에만 택배정보 변경자, 일자 변경 
				if(!isEmpty(st_parcel_com_code) && !isEmpty(st_parcel_inv_no)){
					st_parcel_yn = "Y";
					db_parcel_inv_no = document.forms[0].db_parcel_inv_no.value;
					db_parcel_com_code = document.forms[0].db_parcel_com_code.value;
					if( (db_parcel_com_code != st_parcel_com_code) || (db_parcel_inv_no != st_parcel_inv_no) ){
						st_parcel_changed = "Y";
					}
				}
				
				query +=  buyer         + "@@";
				query +=  po_no         + "@@";
				query +=  po_seq        + "@@";
				query +=  inv_no        + "@@";
				query +=  inv_seq       + "@@";
				query +=  delivery_qty  + "@@";
				query +=  delivery_date   + "@@";
				query +=  st_image_key + "@@";
				query +=  exe_gr_auto_flag+ "@@";
				query +=  st_parcel_com_code+ "@@";
				query +=  st_parcel_inv_no+ "@@";
				query +=  st_parcel_yn+ "@@";
				query +=  st_parcel_changed;
				query +=  "^||^" ;
			}
		}
	}
	
	if(chk_cnt == 0){
		alert("납품실적등록할 품목을 선택하여 주십시요");
		return;
	}

	if(!confirm("납품실적을 등록 하시겠습니까?")) return;

//	console.log(query);
	document.forms[0].st_query.value  = query;
	
	kepAjaxFormCall("/mpiv/saveSellerMpIvDeliveryRecordRegList.do","searchCondition","btnCreate");
	
	/*
	document.forms[0].target = "work";
	document.forms[0].method = "post";
	document.forms[0].action = "/kr/sysop/proxbuy/order/buyer_gr/delivery_rslt_cre_reg.jsp";
	document.forms[0].submit();
	*/
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
	var buyer       = "<%=pBuyer%>";
	var process_type = "<%=PROCESS_TYPE%>";
	var seller		= "<%=SELLER%>";
	var w001flag	= "<%=w001flag%>";	
	var ap_bill_flag = "<%=AP_BILL_FLAG%>";
	if( (process_type == "1" || process_type == "3") && w001flag == "N") {
		alert('재고나 VMI는 거래명세서 삭제가 불가능 합니다.');
		return;
	}
	
	if(ap_bill_flag != "N"){
		alert("매입마감이 완료된 건은 삭제가 불가능합니다.");
		return;
	}
	
	if(eval(disp_cnt) < 2){
	
		buyer       = document.forms[0].db_buyer.value;
		po_no       = document.forms[0].db_po_no.value;
		po_seq      = document.forms[0].db_po_seq.value;
		inv_no      = document.forms[0].db_inv_no.value;
		inv_seq     = document.forms[0].db_inv_seq.value;
		ds_date     = document.forms[0].db_ds_date.value;
		
		query +=  buyer         + "@@";
		query +=  po_no         + "@@";
		query +=  po_seq        + "@@";
		query +=  inv_no        + "@@";
		query +=  inv_seq       + "@@";
		query +=  ds_date             ;
		query +=  "^||^" ;
		
	}else{
		for(var k=0; k<disp_cnt ; k++){		
			buyer       = document.forms[0].db_buyer[k].value;
			po_no       = document.forms[0].db_po_no[k].value;
			po_seq      = document.forms[0].db_po_seq[k].value;
			inv_no      = document.forms[0].db_inv_no[k].value;
			inv_seq     = document.forms[0].db_inv_seq[k].value;
			ds_date     = document.forms[0].db_ds_date[k].value;
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
	

	kepAjaxFormCall("/mpiv/delSellerMpIvTranStatementAlterPrintPop.do","searchCondition","btnDel");
	
	/*
	document.forms[0].st_query.value  = query;
	document.forms[0].target = "work";
	document.forms[0].method = "post";
	document.forms[0].action = "/kr/agent/invoice/agent_invoice_edit_reg.jsp";
	document.forms[0].submit();
	*/
}

//ajax 공통 호출후 성공시 처리 함수



//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	//var msg = response.Message;
	
	if(pMethod == "btnCreate"){
		alert("납품실적등록이  정상적으로 완료 되었습니다.");
	}else if (pMethod == "btnDel"){
		alert("거래명세서 삭제가 정상적으로 완료 되었습니다.");
	}
	
	opener.doAction("search");
	self.close();   
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
		alert(msg);
	}
	return;
}

function sheetWin() {
	var buyer	= "<%=pBuyer%>";
	var inv_no	= "<%=pInvNo%>";
	var rpt_url = "<%=RPT_URL%>";
	
	var seller	= "<%=SELLER%>";
	var legacy_po_no = "<%=LEGACY_PO_NO%>";
	var pur_id = "<%=PURCHASER_ID%>";
	var legacy_iv_serial = "<%=LEGACY_IV_SERIAL%>";
	var tr_buyer = "<%=TR_BUYER%>";
	var print_gbn = $("input:radio[name='radioBtn']:checked").val();	// 0:발주서, 1:납품서
	var solb_if_buyer_flag = "<%=solb_if_buyer%>";
	var solb_legacy_po_no = "<%=dhim_legacy_po_no%>";
	var process_type = "<%=PROCESS_TYPE%>";
	
	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]";
	var fileName = "";
	
	if(solb_if_buyer_flag == "Y" && solb_legacy_po_no == "4" && buyer == tr_buyer && legacy_iv_serial == ""){ // 솔브레인 IF 발주
		alert("거래명세서를 고객사 시스템에 등록중입니다.(납품서 출력은 약 20분 후 가능합니다)\n출력이 지연되면 KeP담당자에게 문의하시기 바랍니다.");
		return;
	}
	
	if(process_type == "2" && "<%=st_no_tag_check_yn%>" == "N"){
		var ktag_box_qty = $("#itemTag_box_qty").val();
		var print_size = $("#st_print_size").val();
		
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

function doPop(str, value1, value2, value3, value4) {
	switch (str) {
		case "commonMpIvOrderDetailPop": // 발주번호
			//openSearchPopup("/mpiv/getCommonMpIvOrderDetailPop.do", "?buyer="+value1+"&po_no="+value2, "820,550,no");
		//아래 팝업으로 교체 협력사> 납품관리 > 거래명세서 > 거래명세서 출력 및 삭제 => 거래명세서 번호 클릭 => 거래명세서 상세팝업에서 발주번호 클릭 2014.11.11
			openSearchPopup("/mpiv/getCommonMpIvOrderInfoPop.do", "?st_buyer="+value1+"&st_po_no="+value2, "820,600,no");
			
			break;
		case "catalogDetailPop": // 품목상세정보
			getBuyerCatalogDisplayPop(value1, value2, value3, value4);
			break;
		case "msdsDetailPop": // msds
			openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+value1+"&st_btn_yn=N",'750,580,no');
			break;
		case "attachSet"://파일 첨부(등록)
			var type="IV";
			var viewType="VI";
			var image_key =  "<%=IMAGE_KEY_INV%>";
			var st_buyer =  "<%=BUYER%>";
			var st_inv_no =  "<%=INV_NO%>";
			popupSel = "attachSet";
			openSearchPopup('/common/imageFileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType+'&BUYER='+st_buyer+'&INVOICE='+st_inv_no,'500,430,no');// 파일첨부
			break;
		case "attachSignSet"://서명 첨부(등록)
			var type="IV";
			var viewType="R";
			var image_key =  "<%=IMAGE_KEY_SIGN%>";
			var st_buyer =  "<%=BUYER%>";
			var st_inv_no =  "<%=INV_NO%>";
			popupSel = "attachSignSet";
			openSearchPopup('/common/imageFileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType+'&BUYER='+st_buyer+'&INVOICE='+st_inv_no,'500,430,no');// 파일첨부
			break;
	}
}
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	if(popupSel == "attachSet") {	//파일 첨부
		 document.forms[0].st_image_key.value = value1;
	 	 if(value1 ==""){
			 $("img[id=st_image_key_img]").eq("0").attr("src",diskOff);
	 	 }else{
			 $("img[id=st_image_key_img]").eq("0").attr("src",diskOn);
	 	 }
	}else if(popupSel == "attachSignSet") {	//서명 첨부
		 document.forms[0].st_image_sign.value = value1;
	 	 if(value1 ==""){
			 $("img[id=st_image_sign_img]").eq("0").attr("src",diskOff);
	 	 }else{
			 $("img[id=st_image_sign_img]").eq("0").attr("src",diskOn);
	 	 }
	}
}
function parcelInvNoCheck(){
	if(!kepIsAlphaNum("st_parcel_inv_no")){
		alert("영문, 숫자만 입력가능합니다.");
		$("#st_parcel_inv_no").focus();
		return false;
	}
	return true;
}
</script>
</head>
<body onload="kep_onload_view();">
<form name = "searchCondition" id="searchCondition" method = "post" >
	<input type="hidden" name="st_seller"           value="<%=SELLER%>">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	
	<input type="hidden" name="st_query" value ="">
	
	<div id="popWrapper" style="height:605px;">
		<div id="popHeader">
			<h1 class="title">거래명세서 상세조회</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
			<!--데이타그리드-->
			<table class="cont_t_list06 mb15" style="width:100%;">
				<caption>상세정보</caption>
				<colgroup>
					<col width="10%" />
					<col width="20%" />
					<col width="10%" />
					<col width="25%" />
					<col width="10%" />
					<col width="25%" />
				</colgroup>
				<tbody>
					<tr>
						<th>발주번호</th>
						<td>
							<a class="hyperLink" href="javascript:doPop('commonMpIvOrderDetailPop','<%=pBuyer%>', '<%=pPoNo%>');">
								<%=CommonUtil.nvl(detailInfo.get("PO_NO"))%>
							</a>
						</td>
						<th>발주비고</th>
						<td colspan="3"><%=CommonUtil.nvl(detailInfo.get("PO_REMARK"))%></td>
					</tr>
					<tr>
						<th>공급받는자</th>
						<td><%=CommonUtil.nvl(detailInfo.get("SELLER_NAME"))%></td>
						<th>납품예정일</th>
<%if(PROCESS_TYPE.equals("2") && st_no_tag_check_yn.equals("N")){ %>
						<td><%=CommonUtil.formatStrinigDate(detailInfo.get("DS_DATE"))%></td>						
						<th>박스수량</th>
						<td>
							<select style="width:40px;" name="itemTag_box_qty" id ="itemTag_box_qty">
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
	                        
	                        <select style="width:140px;" name="st_print_size" id ="st_print_size">
		                        <option value="L">라벨프린터(10x10cm)</option>
		                        <option value="N" selected>일반프린터(A4 4분할)</option>
	                        </select>
						</td>
<%}else{ %>
		<td colspan="3"><%=CommonUtil.formatStrinigDate(detailInfo.get("DS_DATE"))%></td>
<%} %>
					</tr>
					<tr>
						<th>공급원</th>
						<td><%=CommonUtil.nvl(detailInfo.get("SELLER_COM_NAME"))%></td>
						<th>납품확정일</th>
						<td>
							<input type="text" name="st_invoice_date_text" id="st_invoice_date_text" style="width:80px;" class="input_type_text"  value='<%=CommonUtil.formatStrinigDate(detailInfo.get("INV_DATE"))%>' readonly>
						</td>
						<th>총금액</th>
<%if(!com_type.equals("W")){%>
						<td class="right"><%=CommonUtil.formatNumber(detailInfo.get("INV_AMT"),true,0,3)%> 원</td>
<%}else{%>
						<td class="right"></td>
<%}%>
					</tr>
					<tr>
						<th>납품장소</th>
						<td colspan="5"><%=CommonUtil.nvl(detailInfo.get("DELY_TO_LOCATION"))%></td>
					</tr>
					<tr>
						<th>배송증빙</th>
						<td>
			          		<input type="hidden" name="st_image_key" id=st_image_key value="<%=CommonUtil.nvl(detailInfo.get("IMAGE_KEY_INV"))%>">
			          		<input type="hidden" name="st_image_sign" id=st_image_sign value="<%=CommonUtil.nvl(detailInfo.get("IMAGE_KEY_SIGN"))%>">
			          		<input type="hidden" name="db_process_type" id=db_process_type value="<%=CommonUtil.nvl(detailInfo.get("PROCESS_TYPE"))%>">
			          		<input type="hidden" name="st_gr_auto_flag" id=st_gr_auto_flag value="<%=CommonUtil.nvl(detailInfo.get("AUTO_GR_FLAG"))%>">
			          		<input type="hidden" name="db_buyer_nm" id=db_buyer_nm value="<%=CommonUtil.nvl(detailInfo.get("SELLER_NAME"))%>">
			          		<input type="hidden" name="db_parcel_com_code" id=db_parcel_com_code value="<%=CommonUtil.nvl(detailInfo.get("PARCEL_COM_CODE"))%>">
			          		<input type="hidden" name="db_parcel_inv_no" id=db_parcel_inv_no value="<%=CommonUtil.nvl(detailInfo.get("PARCEL_INV_NO"))%>">
				          <%
				          	if(CommonUtil.nvl(detailInfo.get("PROCESS_TYPE")).equals("0")){
				          		if(!"".equals(CommonUtil.nvl(detailInfo.get("IMAGE_KEY_INV")))) {
					          %>
								<a href="javascript:doPop('attachSet');"><img src="/resources/images/disk_on.gif" name="st_image_key_img" id="st_image_key_img" border="0"></a>
				          <%
					          	}else{
				          %>
								<a href="javascript:doPop('attachSet');"><img src="/resources/images/disk_off.gif" name="st_image_key_img" id="st_image_key_img" border="0"></a>
				          <%
					          	}
				          		
				          		if(!"".equals(CommonUtil.nvl(detailInfo.get("IMAGE_KEY_SIGN")))) {
				          %>
				          		<a href="javascript:doPop('attachSignSet');"><img src="/resources/images/disk_on.gif" name="st_image_sign_img" id="st_image_sign_img" border="0"></a>
				          <%
				          		}else{
				          %>
				          		<a href="javascript:doPop('attachSignSet');"><img src="/resources/images/disk_off.gif" name="st_image_sign_img" id="st_image_sign_img" border="0"></a>
				          <%
				          		}
				          	}
				          %>
						</td>
						<th>택배사</th>
						<td>				
							<select id="st_parcel_com_code" name="st_parcel_com_code"  ></select>
						</td>
						<th>송장번호</th>
						<td  colspan="3">
							<input type="text" id="st_parcel_inv_no" name="st_parcel_inv_no"  maxlength="25" onblur="javascript:parcelInvNoCheck();"  value='<%=CommonUtil.nvl(detailInfo.get("PARCEL_INV_NO"))%>' >
						</td>
					</tr>
					<tr>
						<th class="lineNone">비고</th>
						<td colspan="5" class="lineNone"><%=CommonUtil.nvl(detailInfo.get("REMARK_INV"))%></td>
					</tr>
				</tbody>
			</table>

			<!--grid-->
			<div class="scrollArea" style="height:300px">
				<table  class="cont_t_list04"  style="width:100%">
					<caption>상세내역</caption>
					<colgroup>
						<col width="5%" />
						<col width="15%" />
						<col width="33%" />
						<col width="10%" />
						<col width="13%" />
						<col width="11%" />
						<col width="13%" />
					</colgroup>
					<thead>
						<tr align="center">
							<th scope="col" rowspan="2">전체</th>
							<th scope="col">관리번호</th>
							<th scope="col">품목명/제조사</th>
							<th scope="col">단가</th>
							<th scope="col">발주수량/단위</th>
							<th scope="col">기납품수량</th>
							<th scope="col">납품예정일</th>
						</tr>
						<tr align="center">
							<th scope="col">품목코드</th>
							<th scope="col">규격</th>
							<th scope="col">공급가액</th>
							<th scope="col">납품수량</th>
							<th scope="col">확정수량</th>
							<th scope="col">납기요청일</th>
						</tr>
					</thead>
					<tbody>
					<% 
					for (int j=0; j<detailList.size(); j++) {
						++page_display_cnt;
						Map<String,String> rowData = detailList.get(j);
						String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
					%>
						<tr align="center" bgcolor="<%=tclass%>">
							<td rowspan="2">
								<input type="hidden" name="db_buyer"	value="<%=pBuyer%>"/>
								<input type="hidden" name="db_po_no"	value="<%=CommonUtil.nvl(rowData.get("PO_NO"))%>"/>
								<input type="hidden" name="db_po_seq"	value="<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>"/>
								<input type="hidden" name="db_inv_no"	value="<%=pInvNo%>"/>
								<input type="hidden" name="db_inv_seq"	value="<%=CommonUtil.nvl(rowData.get("INV_SEQ"))%>"/>
								<input type="hidden" name="db_ds_date"	value="<%=CommonUtil.nvl(rowData.get("DS_DATE"))%>"/>
								<input type="hidden" name="db_cd_qty"	value="<%=CommonUtil.nvl(rowData.get("INV_QTY"))%>"/>
								<input type="hidden" name="db_po_qty"	value="<%=CommonUtil.nvl(rowData.get("ITEM_QTY"))%>"/>
								<input type="hidden" name="db_iv_qty"	value="<%=CommonUtil.nvl(rowData.get("INV_QTY"))%>"/>
								<input type="hidden" name="db_inv_date"	value="<%=CommonUtil.nvl(rowData.get("INVOICE_DATE"))%>"/>
								<input type="hidden" name="st_ds_date"	value="<%=DS_DATE%>">
								<input type="checkbox" id="checkbox<%=j%>" name="checkbox<%=j%>" value="<%=j%>" checked>
							</td>
							<td class="left"><%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%></td>
							<td class="left"><%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%></td>
							
						<%	if(pBuyer.equals("KRDOOS0020") || pBuyer.equals("KRKEPB0004")){	%>
								<td class="right"><%=CommonUtil.formatNumber(rowData.get("AGENT_PRICE"),true,0,3)%></td>
						<%	} else {	%>
							<%if(!com_type.equals("W")){%>
								<td class="right"><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%></td>
							<%}else{%>
								<td class="right"></td>
							<%}%>
						<%	}	%>
							
							<td class="right">
								<%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%>/<%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>
							</td>
							<td class="right">
								<%=CommonUtil.formatNumber(rowData.get("INV_COMP_QTY"),true,0,3)%>
							</td>
							<td><%=CommonUtil.formatStrinigDate(rowData.get("DS_DATE"))%></td>
						</tr>
						<tr>
							<td class="left">
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
							<td class="left"><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></td>
						<%	if(pBuyer.equals("KRDOOS0020") || pBuyer.equals("KRKEPB0004")){	%>
								<td class="right"><%=CommonUtil.formatNumber(rowData.get("INV_AGENT_AMT"),true,0,3)%></td>
						<%	} else {	%>
							<%if(!com_type.equals("W")){%>
								<td class="right"><%=CommonUtil.formatNumber(rowData.get("INV_UNIT_AMT"),true,0,3)%></td>
							<%}else{%>
								<td class="right"></td>
							<%}%>
						<%	}	%>
						
							<td class="right"><%=CommonUtil.formatNumber(rowData.get("INV_QTY"),true,0,3)%></td>
							<td class="right">
								<%=CommonUtil.formatNumber(rowData.get("REMAIN_QTY"),true,0,3)%>
								<input type="hidden" name="delivery_qty" value="<%=CommonUtil.formatNumber(rowData.get("REMAIN_QTY"),true,0,3)%>" />
								<input type="hidden" name="st_delivery_qty" value="<%=CommonUtil.nvl(rowData.get("REMAIN_QTY"))%>" />
								<input type="hidden" name="st_inv_qty"      value="<%=CommonUtil.nvl(rowData.get("INV_QTY"))%>" />
							</td>
							<td><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%></td>
						</tr>
				<%	} %>
					</tbody>
				</table>
				<input type="hidden" id="display_item_cnt" name="display_item_cnt" value="<%=page_display_cnt%>">
			</div>
			<!--버튼영역-->
			<div class="btnArea mt10 mb0">
				<span class="fl">
					<span class="btn_04"><a href="javascript:sheetWin();">거래명세서</a></span>
					<% if (("KRSTX-0002".equals(pBuyer) ||   "KRSTX-0003".equals(pBuyer) ||   "KRSTX-0005".equals(pBuyer) ||   "KRSTX-0006".equals(pBuyer) ||   "KRSTX-0007".equals(pBuyer)) && pInvNo.indexOf("IK") == -1){       //STX 엔진3사 (KRSTX-0002,KRSTX-0003,KRSTX-0005,KRSTX-0006)              %>
						<span style="vertical-align:top;height:28px;padding-top:2px; vertical-align: middle;">
							<input type="radio" name="radioBtn" value="0" style="border:0px;vertical-align:middle;" checked>발주서</input>&nbsp;&nbsp;
							<input type="radio" name="radioBtn" value="1" style="border:0px;vertical-align:middle;">납품서</input>
						</span>
					<%} %>
				</span>
				<!-- 매입마감 개선 > 협력사 업무 대행 중지 / 혹시 몰라서 삭제버튼에는 매입마감여부 조건 걸어놓음. 추후 살리게 되는 경우 이 조건은 따라야함 -->
				<span class="fr">
							<%  if(CommonUtil.nvl(detailInfo.get("BTN_YN")).equals("11")){ %>
								<span class="btn_04 mr04">
									<a href="javascript:setInvoiceDelete();">삭제</a> 
								</span>
							<% } %>
					<!--버튼이 2글자일때 class="btn_02",버튼이 3글자일때 class="btn_03",버튼이 4글자일때 class="btn_04" 글자수와 class숫자가 동일 최대 10글자까지 가능-->
<!-- 					<span class="btn_04 mr04"><a href="javascript:doAction('create');">등록</a></span> -->
				</span>
			</div>
		</div>
	</div>
</form> 
</body>
</html>
