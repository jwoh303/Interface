<%--
**********************************************
* 메뉴 : 
* 화면 : 거래명세서작성(일괄)
* 기능 : 거래명세서를 일괄작성하기위한 팝업
* 프로그램 ID : PG_07_A_003_0
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

	Map<String,String> _info = (Map<String,String>) request.getAttribute("info"); // 조회된 결과
	Map<String,String> _popKey = (Map<String,String>) request.getAttribute("mapPopKey"); // 조회된 결과
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	
	String total_cnt = "0";
	if(_gridList != null && _gridList.size() > 0){
		total_cnt = _gridList.size()+"";	
	}
	
	//String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	
	// 조회조건 S
	String p_buyer			= CommonUtil.nvl((String)request.getAttribute("st_buyer_code"));
	String p_invoice_date	= CommonUtil.nvl((String)request.getAttribute("st_invoice_date_text"));
	String p_remark			= CommonUtil.nvl((String)request.getAttribute("st_remark"));
	
	String p_seller 		= CommonUtil.nvl((String)request.getAttribute("st_seller"));
	
	String tr_buyer = CommonUtil.nvl(_info.get("TR_BUYER"));
	String stx_rpt = CommonUtil.nvl(_info.get("STX_RPT"));
	String dsn_rpt = CommonUtil.nvl(_info.get("DSN_RPT"));
	String process_type = CommonUtil.nvl(_info.get("PROCESS_TYPE"));
	
	String legacy_po_no = CommonUtil.nvl(_info.get("LEGACY_PO_NO"));
	String pur_id = CommonUtil.nvl(_info.get("PURCHASER_ID"));
	
	String rpt_url = CommonUtil.nvl(_info.get("RPT_URL"));

	String session_com_code = CommonUtil.nvl(_sessionInfo.getComCode());
	
	int page_display_cnt = 0;
	
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

//최초 화면 함수 
function kep_onload_view(){
	
}

//팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5) {
	switch (str) {
		case "agent": // 고객사정보
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
			break;
			
		case "commonMpIvTranBuyerChoicePop": // 고객사선택
			openSearchPopup("/mpiv/getCommonMpIvTranBuyerChoicePop.do", "?st_com_code="+$("#st_com_code").val(), "720,505,no");
			break;
			
		case "commonMpIvOrderInfoPop": // 발주번호 click시 발주정보 팝업
			openSearchPopup("/mpiv/getCommonMpIvOrderInfoPop.do", "?st_buyer="+value1+"&st_po_no="+value2, "930,600,no");
			break;
		case "catalogDetailPop": // 품목상세정보
			getBuyerCatalogDisplayPop(value1, value2, value3, value4);
			break;
	}
}

//거래명세서 작성
function setInvoiceCreate(){
	//================================================
	var checkRdDate ="IN";
	
	var process_type = "<%=process_type%>";
	var tr_buyer = "<%=tr_buyer%>";

	if(process_type == "2"){
		var print_size = $("#st_print_size").val();
		
		if(isEmpty(print_size)){
			alert("라벨출력방식을 선택해주세요.");
			$("#st_print_size").focus();
			return;
		}	
	}
	
	if(!confirm("거래명세서 일괄 작성을 하시겠습니까?")){
		return;
	}
	
	var disp_cnt = document.forms[0].display_item_cnt.value;
	var query = "";
	
	var buyer           = "";
	var ds_date         = "";
	var po_no           = "";
	var po_seq          = "";
	var cd_qty          = "";
	var poss_cd_qty     = "";
	var inv_qty         = "";
	var po_qty          = "";
	var invoice_date = $("#st_invoice_date").val().replace(/[/]/gi,"");
	
	if(eval(disp_cnt) < 2){
		var complete_mark   = "N";

		buyer       = document.forms[0].st_buyer.value;
		po_no       = document.forms[0].st_po_no.value;
		po_seq      = document.forms[0].st_po_seq.value;
		ds_date     = document.forms[0].st_ds_date.value;
		cd_qty      = document.forms[0].st_cd_qty.value;
		poss_cd_qty = document.forms[0].st_poss_cd_qty.value;
		inv_qty     = document.forms[0].st_inv_qty.value;
	
		po_qty      = document.forms[0].st_po_qty.value;

		if( poss_cd_qty == cd_qty){
               complete_mark = "Y";
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
		query +=  "^||^" ;
		
	}else{
		for( k=0; k<disp_cnt ; k++){
			
			var complete_mark   = "N";
			buyer       = document.forms[0].st_buyer[k].value;
			ds_date     = document.forms[0].st_ds_date[k].value;
			po_no       = document.forms[0].st_po_no[k].value;
			po_seq      = document.forms[0].st_po_seq[k].value;
			cd_qty      = document.forms[0].st_cd_qty[k].value;
			poss_cd_qty = document.forms[0].st_poss_cd_qty[k].value;
			po_qty      = document.forms[0].st_po_qty[k].value;
			inv_qty     = document.forms[0].st_inv_qty[k].value;
			
			if( poss_cd_qty == cd_qty){
				complete_mark = "Y";
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
			query +=  "^||^" ;
		}
		
	}
	
	$("#st_invoice_date_text").val(invoice_date);
	
	document.forms[0].st_query.value  = query;
	
	kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementDivsnWriteList.do","contentForm","btnSave");
	
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	if(pMethod == "btnSave"){
		setResult(response);
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
	var tr_buyer = "<%=tr_buyer%>";
	var com_code = $("#st_com_code").val(); 
	
	var action_flag = response.action_flag;
	
	if(action_flag == "DO"){
		alert("해당건에 대해서 현재 작업중입니다.");
		location.reload();
		return;
	}
	
	var stx_rpt = "<%=stx_rpt%>";
	var dsn_rpt = "<%=dsn_rpt%>";
	
	// P06-0000005 - 거래명세서 저장후, 거래명세서를 STX시스템에 등록
	if(stx_rpt == "Y" && buyer == tr_buyer){
	
		/*
	if( ( buyer == "KRSTX-0001" || 
			buyer == "KRSTX-0002" ||
			buyer == "KRSTX-0003" ||
			buyer == "KRSTX-0005" ||
			buyer == "KRSTX-0006" ||
			buyer == "KRSTX-0007" ) && buyer == tr_buyer ) {	// KRSTX-0004 의 경우 B2B 사이트 거래명세서를 사용함.
		*/
		
		alert("거래명세서를 고객사 시스템에 등록중입니다.\n[거래명세서 출력 및 삭제] 에서 확인 하시기 바랍니다.\n(납품서 출력은 약 20분 후 가능합니다)");
	} else {
		alert("거래명세서 생성이 완료 되었습니다.\n\n거래명세서 번호는  " + inv_no + " 입니다.");	
	}
	

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
	
	}else if(buyer == "KRDAEW0016" || (buyer == "KRDOOD0001" && com_code != "KRMOOH0001") ){
		// 기존 특수로직 유지.
	
    } else {
    	sheetWin(inv_no); //거래명세서 출력.
    }
	
	//opener.kepSearch('1');
	opener.doAction("search");
	window.close();
	
	
	// 거래명세서 저장 성공 후 특수로직 추가예정~~~	
}

	
// 두산인프라코어 10개사의 경우 거래명세서 저장후, 리포트 오픈전, 인터페이스호출
function openIvUpdate(buyer, inv_no){ 
	document.forms[0].st_buyer.value  = buyer;
	document.forms[0].st_inv_no.value  = inv_no;
	document.forms[0].st_type.value  = "INS";
	
	kepAjaxFormCall("/mpiv/saveKrdhimInvoice.do","contentForm","saveIvUpdate");
   
}  


function sheetWin(inv_no) {
	var buyer			= "<%=p_buyer%>";
	var seller			= "<%=p_seller%>";
	var legacy_po_no	= "<%=legacy_po_no%>";
	var pur_id			= "<%=pur_id%>";
	var tr_buyer = "<%=tr_buyer%>";
	var process_type = "<%=process_type%>"; 
	
	var legacy_iv_serial = "";
	
	var rpt_url 		= "<%=rpt_url%>";
	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]";
	
    if(inv_no.length == 0 ){
        alert("조회한 결과가 없습니다.");
        return;
    }else{
    	if(process_type == "2" && "<%=st_no_tag_check_yn%>" == "N"){
    		if($("#st_print_size").val() == "N"){
    			rpt_url = "RD_06_S_001_170";
    		}else if($("#st_print_size").val() == "L"){
    			rpt_url = "RD_06_S_001_171";
    		}
    		
    		param = "["+inv_no+"]["+seller+"]["+buyer+"][]";
    		
    		openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
    		
    		if("<%=st_no_itemTag_check_yn%>" == "Y"){
   				rpt_url = "<%=p070000034%>";
   				param = "["+inv_no+"]["+seller+"]["+buyer+"]";
   				
   				openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
   			}
    	}else{
    		openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
    	}
    }
}

function openHttp(rptUrl, winName){
	var param = "";
	
	if(rptUrl.indexOf("doowin") > -1){
		// http://doowin.doosaninfracore.com/keplogin.do
		var _option = buildOption("1024,760,no");
		
		var agent = $("#st_com_code").val();
		var agent_name = $("#st_com_name").val();
		var legacy_po_no = "<%=legacy_po_no%>";
		
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

</script> 
</head>

<body onload="kep_onload_view()">
<form name = "contentForm" id="contentForm" method = "post">

<!-- HIDDEN -->
<input type="hidden" name="st_query"            value="">
<input type="hidden" name="st_seller"           value="<%=p_seller%>">
<!--  input type="hidden" name="st_process_type"     value="" -->
<input type="hidden" name="st_legacy_po_no"     value="<%//=p_legacy_po_no%>">

<input type="hidden" name="st_action_id"		value="<%//=action_id%>">
<input type="hidden" name="st_inv_no"			value="">
<input type="hidden" name="st_type"			    value="">

<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
<input type="hidden" name="st_com_name" id="st_com_name" value="${sessionInfo.comNameLoc}">
<input type="hidden" name="st_parcel_yn" id="st_parcel_yn" value="N">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
    	<div id="popHeader">
        	<h1 class="title">거래명세서 작성(일괄) 확인</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!-- 거래명세서 작성 상세내용 -->  
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			    <tr>
			        <td bgcolor="#898989" height="1" colspan="2"></td>
			    </tr>
			
			    <tr>
			        <td colspan="2">
			            <table width="100%" height="130" border="0" cellspacing="0" cellpadding="0">
			                <tr height="25">
			                    <td height="25" style="width:80px;">&nbsp;&nbsp;<font color="#993300">공급받는자</font></td>
			                    <td>
			                    	<%=_info.get("BUYER_NAME")%>
			                    </td>
<%if(process_type.equals("2")){ %>
			                    <td height="25" style="width:100px;">&nbsp;&nbsp;<font color="#993300">라벨출력방식</font></td>
			                    <td>
			                    	<select style="width: 150px;" name="st_print_size" id ="st_print_size">
			                    		<option value="">선택</option>
			                    		<option value="N">일반프린터(A4 4분할)</option>
			                    		<option value="L">라벨프린터(10x10cm)</option>
			                    	</select>
			                    </td>
<%}%>
			                </tr>
			
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                
			                <tr height="25">
			                    <td style="width:100px;">&nbsp;&nbsp;<font color="#993300">공급원</font></td>
			                    <td>
			                    	<%=_info.get("SELLER_COM_NAME")%>
			                    </td>
			                    <td style="width:100px;">&nbsp;&nbsp;<font color="#993300">납품일</font></td>
			                    <td>
			                    	<%=p_invoice_date%>
			                    	<input type="hidden" id="st_invoice_date" name="st_invoice_date" value="<%=p_invoice_date%>" />
			                    	<input type="hidden" id="st_invoice_date_text" name="st_invoice_date_text" value="" />
			                    </td>
			                </tr>
			
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			
			                <tr height="25">
			                    <td>&nbsp;&nbsp;<font color="#993300">납품장소</font></td>
			                    <td>
			                    	<%=_info.get("DELY_TO_LOCATION")%>
			                    	<%	
			                    		int locationCnt = Integer.parseInt(String.valueOf(_info.get("LOCATION_CNT"))); 
			                    		if(locationCnt > 1){%>
			                    			외 <%=(locationCnt-1) %>
			                    	<%	}%>
			                    </td>
			                    
			                    <td>&nbsp;&nbsp;<font color="#993300">발주자</font></td>
			                    <td>
			                    	<%=_info.get("PURCHASER_NAME")%>
			                    	<%	
			                    		int purchaserCnt = Integer.parseInt(String.valueOf(_info.get("PURCHASER_CNT"))); 
			                    		if(purchaserCnt > 1){%>
			                    			외 <%=(purchaserCnt-1)%>명
			                    	<%	}%>
			                    </td>
			                    
			                    <td class="pl10">&nbsp;&nbsp;<font color="#993300">총금액</font></td>
			                    <td>
			                    	<input type="text"   name="st_inv_tot_amt_text" class = "ar am input_type_text" style="background-color:#FFFFFF;border:#FFFFFF 1px solid;" value="<%=CommonUtil.formatNumber(_info.get("SELLER_AMT"),true,0,3)%> 원"  READONLY >
			                    	<input type="hidden" name="st_inv_tot_amt" value ="<%=_info.get("SELLER_AMT")%>">
			                    	<input type="hidden" name="sheet_inv_tot_amt" value ="<%=_info.get("SELLER_AMT")%>">
			                    	<input type="hidden" name="st_inv_amt_text" size="14" class="ar input_type_text" style="background-color:#FFFFFF;border:#FFFFFF 1px solid;" value="<%=CommonUtil.formatNumber(_info.get("SELLER_AMT"),true,0,3)%> 원"  READONLY >
			                    	<input type="hidden" name="st_inv_amt" value ="<%=_info.get("SELLER_AMT")%>">
			                    	<input type="hidden" name="sheet_inv_amt" value ="<%=_info.get("SELLER_AMT")%>">
			                    	<input type="hidden" name="st_inv_tax_amt_text" size="14" class="ar input_type_text" style="background-color:#FFFFFF;border:#FFFFFF 1px solid;" value="<%=CommonUtil.formatNumber(_info.get("TAX_AMT"),true,0,3)%> 원"  READONLY >
									<input type="hidden" name="st_inv_tax_amt"  value ="<%=_info.get("TAX_AMT")%>">  <!-- 부가세(10%)   공급가액의 10% -->
									<input type="hidden" name="sheet_inv_tax_amt"  value ="<%=_info.get("TAX_AMT")%>">  <!-- 부가세(10%)   공급가액의 10% -->
									<input type="hidden" name="st_inv_tax_rate" value ="0.1">          <!-- 부가세(10%) , 부가세 비율 10 * 0.01 -->
			                    </td>
			                </tr>
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                <tr height="25">
			                    <td>&nbsp;&nbsp;<font color="#993300">비고</font></td>
			                    <td colspan="5">
			                    	<%=p_remark%>
			                    	<input type="hidden" name="st_remark" value="<%=p_remark%>" />
			                   	</td>
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
            <div class="scrollArea" style="height:320px">
                <table  class="cont_t_list04"  style="width:100%">
                    <caption>거래명세서 작성 상세 리스트</caption>
                    <colgroup>
			            <col width="7%" />
			            <col width="7%" />
			            <col width="7%" />
			            <col width="8%" />
			            <col width="5%" />
			            <col width="7%" />
			            <col width="15%" />
			            <col width="8%" />
			            <col width="7%" />
			            <col width="10%" />
			            <col width="*" />
                    </colgroup>
                    <thead>
                        <tr>
			                <th scope="col" rowspan="2">발주일</th>
			                <th scope="col">주문번호</th>
			                <th scope="col" rowspan="2">납품총금액</th>
			                <th scope="col">납기요청일</th>
			                <th scope="col" rowspan="2">발주비고</th>
			                <th scope="col" rowspan="2">품목코드</th>
			                <th scope="col">품목명/제조사</th>
			                <th scope="col">발주수량</th>
			                <th scope="col">단가</th>
			                <th scope="col">발주자</th>
			                <th scope="col" rowspan="2">품목별비고</th>
						</tr>
						<tr>
			                <th scope="col">발주번호</th>
			                <th scope="col">납기예정일</th>
			                <th scope="col">규격</th>
			                <th scope="col">납품수량/단위</th>
			                <th scope="col">공급가</th>
			                <th scope="col">도착지정보</th>
                        </tr>
                    </thead>
                    <tbody>
					<%
					
					if (_gridList == null || _gridList.size() == 0){
					%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="7" align="center" height = "50">
	                        <span class="font1">조회된 데이타가 없습니다.</span>
	                        </td> 
	                    </tr>
					<%
					} else {
						
						String po_no = "";
			        	String pre_po_no = "";
			        	String tclass = "#FAFAFA";
						for (int j=0; j<_gridList.size(); j++) {
							page_display_cnt++;
							Map<String,String> rowData = _gridList.get(j);
							//String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
							
							po_no = CommonUtil.nvl(rowData.get("PO_NO"));
							if(!pre_po_no.equals(po_no)){
								if(tclass.equals("#FFFFFF")){
									tclass = "#FAFAFA";
								} else {
									tclass = "#FFFFFF";	
								}	
							}
							
					%> 
						<input type="hidden"   name="st_buyer"      value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>">
						<input type="hidden"   name="st_po_no"      value="<%=CommonUtil.nvl(rowData.get("PO_NO"))%>">
						<input type="hidden"   name="st_po_seq"      value="<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>">
						<input type="hidden"   name="st_ds_date"      value="<%=CommonUtil.nvl(rowData.get("DS_DATE"))%>">
						<input type="hidden"   name="st_process_type"      value="<%=CommonUtil.nvl(rowData.get("PROCESS_TYPE"))%>">
						<input type="hidden"   name="st_po_qty"      value="<%=CommonUtil.nvl(rowData.get("ITEM_QTY"))%>">
						<input type="hidden"   name="st_seller"      value="<%=CommonUtil.nvl(rowData.get("SELLER"))%>">
						<input type="hidden"   name="st_po_no_cnt"      value="<%=CommonUtil.nvl(rowData.get("PO_NO_CNT"))%>">
						<input type="hidden"   name="st_inv_qty"      value="<%=CommonUtil.nvl(rowData.get("IV_QTY"))%>">
						
						<tr bgcolor="<%=tclass%>">
							<td title="발주일" rowspan ="2">
								<%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%>
							</td>
							<td title="주문번호"><%=CommonUtil.nvl(rowData.get("PX_NO"))%></td>
			                <td title="납품총금액" class="right" rowspan="2"><%=CommonUtil.formatNumber(rowData.get("AGENT_TOT_AMT"),true,0,3)%></td>
			                <td title="납기요청일"><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%></td>
			                <td rowspan="2">
			                	<!-- 발주비고 -->
			                	<a class="tip">
			                	<img src="/resources/images/icon2.gif" />
			                	<span><%=CommonUtil.nvl(rowData.get("PO_REMARK"))%></span>
			                	</a>
			                </td>
			                <td title="품목코드" rowspan="2">
			                	<a class="hyperLink" href="javascript:doPop('catalogDetailPop','<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>');">
			                		<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>
			                	</a>
			                </td>
			                <td title="품명/제조사" class="left" ><%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%></td>
			                <td title="발주수량" class="right" ><%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%></td>
			                <td title="단가" class="right pr05" ><%=CommonUtil.formatNumber(rowData.get("AGENT_PRICE"),true,0,3)%></td>
			                <td title="요청자" class="left" ><%=CommonUtil.nvl(rowData.get("PURCHASER_NAME"))%></td>
			                <td title="품목별비고" class="left" rowspan="2"><%=CommonUtil.nvl(rowData.get("ITEM_PO_REMARK"))%></td>
						</tr>
						<tr bgcolor="<%=tclass%>">
		                    <td title="발주번호">
								<a class="hyperLink" href="javascript:doPop('commonMpIvOrderInfoPop','<%=String.valueOf(rowData.get("BUYER"))%>','<%=String.valueOf(rowData.get("PO_NO"))%>');">
		                    		<%=CommonUtil.nvl(rowData.get("PO_NO"))%>
		                    	</a>
		                    </td>
			                <td title="납기예정일"><%=CommonUtil.formatStrinigDate(rowData.get("DS_DATE"))%></td>
			                <td title="규격" class="left" ><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></td>
			                <td title="납품수량/단위" class="right" >
			                	<div class="fl" style="width:65%;">
		                			<%=_popKey.get(CommonUtil.nvl(rowData.get("POP_KEY")))%>
		                			<input type="hidden" name="st_cd_qty"		value="<%=_popKey.get(CommonUtil.nvl(rowData.get("POP_KEY")))%>">
		                			<input type="hidden" name="st_poss_cd_qty"  value="<%=CommonUtil.nvl(rowData.get("INV_POSS_QTY"))%>">    <!-- 납품가능수량       -->
		                		</div>
		                		<div class="fr">
			                		/<%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>
			                	</div>
			                </td>
			                <td title="공급가" class="right pr05" ><%=CommonUtil.formatNumber(rowData.get("SUPP_PRICE"),true,0,3)%></td>
			                <td title="도착지정보" class="left" ><%=CommonUtil.nvl(rowData.get("DELY_TO_LOCATION"))%></td>
						</tr>
					<%

		    				pre_po_no = po_no;
		                } 
					}
					%>
  
                    </tbody>
                </table>                  
                <input type="hidden" id="display_item_cnt" 	name="display_item_cnt"    value="<%=page_display_cnt%>">
                <input type="hidden" id="legacy_po_seq_tot" name="legacy_po_seq_tot"   value="<%//=legacy_po_seq_tot%>">
		        <input type="hidden" id="st_pur_id"			name="st_pur_id"		value="<%//=pur_id%>">
		        <input type="hidden" id="st_inv_data"		name="st_inv_data"   	value="<%//=inv_data%>">
        </div>
        
        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:8px;margin-bottom:12px;font-weight:bold;">
        	<tr>
       	<%
  		    int refadduserCnt = Integer.parseInt(String.valueOf(_info.get("REF_ADD_USER_CNT"))); 
       	       	
   		    /*if(purchaserCnt > 1 || locationCnt > 1){ 발주자에서 ==> 요청자로 수정*/ 
       		if(refadduserCnt > 1 || locationCnt > 1){
       	%>
        		<td style="text-align:center;font-size:15px;font-family:'맑은 고딕';color:red;">
        		<%
		       		if(refadduserCnt > 1){
		       	%>
		       			요청자가 <%=_info.get("REF_ADD_USER_NAME")%>님 외 <%=(refadduserCnt-1)%>명이 존재합니다.<br>
		       	<%
		       		}
		       	%>
		       	<%
		       		if(locationCnt > 1){
		       	%>
		       			서로 다른 납품장소가 <!-- <%=_info.get("DELY_TO_LOCATION")%>외 --> <%=locationCnt%>곳 존재합니다.<br>
		       	<%
		       		}
		       	%>
		        	선택하신 주문에 대하여 거래명세서를 일괄 작성할 수 없습니다.
        		</td>
        		<td align="right" class="ab">
					<div class="btnArea02">
						<div class="fr">
							<span class="btn_04">
								<a href="javascript:self.close();">취소</a>
							</span>
			            </div>
			        </div>
				</td>
       	<%
       		} else {
       	%>
				<td align="right">
					<div class="btnArea02">
						<div class="fr">
							<span class="btn_04">
								<a href="javascript:setInvoiceCreate();">확인</a>
							</span>
			            </div>
			        </div>
					
					<!-- a href="javascript:top.window.close();"><img src="/kr/agent/images/button/btn_close.gif"	width="64" height="27" border="0" align="absmiddle" ></a -->
				</td>
		<%
       		}
       	%>
				
			</tr>
		</table>
    </div>        
</div>
</form> 

</body>
</html>
