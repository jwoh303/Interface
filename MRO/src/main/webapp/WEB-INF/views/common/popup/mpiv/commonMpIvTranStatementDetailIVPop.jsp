<%--
**********************************************
* 메뉴 : 
* 화면 : 거래명세서 상세조회IV
* 기능 : 
* 프로그램 ID : PG_07_M_900_04
* 담당자 :  ( 설계 : 김지현 )
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
<script src="/resources/js/kep_common.js"></script>
 
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
	
	//조회결과 - 상세정보
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
	
	String stx_rpt = "";
	String dsn_rpt = "";
	String rpt_url = "";
	
	String btn_yn = "";		// 저장,삭제버튼 출력여부 11 : 노출, 00 : 비노출
	String btn_nm = "";		// 거래명세서 출력 버튼명
	String extr_rpt = "";	// 납품지시서 리포트 출력여부
	
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
		
		stx_rpt		= CommonUtil.nvl(detailInfo.get("STX_RPT"));
		dsn_rpt		= CommonUtil.nvl(detailInfo.get("DSN_RPT"));
		
		rpt_url		= CommonUtil.nvl(detailInfo.get("RPT_URL"));
		
		btn_yn		= CommonUtil.nvl(detailInfo.get("BTN_YN"));
		btn_nm		= CommonUtil.nvl(detailInfo.get("BTN_NM"));
		extr_rpt	= CommonUtil.nvl(detailInfo.get("EXTR_RPT"));
		
	}

	//조회결과 - 상세 리스트
	List<Map<String, String>> detailList = (List<Map<String, String>>) request.getAttribute("data"); 
	
	int rec_cnt = 0;
	int page_display_cnt = 0;
	
%>
<script type="text/javascript">

var popupSel = "";

//최초 화면 함수 
function kep_onload_view(){
	//kepSetCalender('st_invoice_date_text');	
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
		case "msdsDetailPop": // msds
			openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+value1+"&st_btn_yn=N",'750,580,no');
			break;
	}
}

//대우조선 납품지시서
function sheetWinDaewoo3(){
	var agent_code  = "${sessionInfo.comCode}";
	window.open("/kr/epro/buy/sheet/daewoo_delivery_order_list.jsp?agent_code="+agent_code,"sheetWin_TEST_3","toolbar=yes,width=700,height=600,resizable=YES,scrollbars=YES,top=0,left=0");
}

function sheetWin() {
	var buyer	= "<%=p_buyer%>";
	var seller  = "<%=p_seller%>";
	var inv_no	= "<%=p_inv_no%>";
	var rpt_url = '<%=rpt_url%>';
	
	var legacy_po_no = "<%=p_legacy_po_no%>";
	var pur_id = $("#st_pur_id").val();

	var legacy_iv_serial= "<%=legacy_iv_serial%>";
	var tr_buyer 		= "<%=p_tr_buyer%>";
	var print_gbn 		= "";
	
	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]";
   	openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, print_gbn, legacy_po_no);
}
</script> 
</head>

<body>
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

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
    	<div id="popHeader">
        	<h1 class="title">거래명세서 상세조회</h1>
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
			            <table width="100%" border="0" cellspacing="0" cellpadding="0">
			                <tr height="25">
			                    <td width="10%" height="25">&nbsp;&nbsp;<font color="#993300">발주번호</font></td>
			                    <td width="23%">
			                    	<a class="hyperLink" href="javascript:doPop('commonMpIvOrderInfoPop','<%=p_buyer%>','<%=po_no%>');">
			                   			<%=po_no%>
			                   		</a>
			                    </td>
			                    
			                    <td width="10%">&nbsp;&nbsp;<font color="#993300">발주비고</font></td>
			                    <td width="30%" title="<%=po_remark%>">
			                    	<%=CommonUtil.textMore(po_remark,35)%>
			                    </td>
			                </tr>
			
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                
			                <tr height="25">
			                    <td>&nbsp;&nbsp;<font color="#993300">공급받는자</font></td>
			                    <td><%=seller_buyer%></td>
			                    
			                    <td>&nbsp;&nbsp;<font color="#993300">납품예정일</font></td>
			                    <td><%=ds_date%></td>
			                </tr>
			
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			
			                <tr height="25">
			                    <td>&nbsp;&nbsp;<font color="#993300">공급원</font></td>
			                    <td><%=seller_com_name%></td>
			                    <td>&nbsp;&nbsp;<font color="#993300">납품일</font></td>
			                    <td><%=inv_date%></td>
			                    <td>&nbsp;&nbsp;<font color="#993300">총금액</font></td>
			                    <td class="fr pr30" style="padding-top:2px !important;">
			                    	<%=CommonUtil.formatNumber(inv_amt,true,0,3)%> 원
			                    </td>
			                </tr>
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                <tr height="25">
			                    <td>&nbsp;&nbsp;<font color="#993300">납품장소</font></td>
			                    <td colspan="5"><%=dely_to_location%></td>
			                </tr>
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                <tr height="25">
			                    <td>&nbsp;&nbsp;<font color="#993300">비고</font></td>
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
            <div class="scrollArea" style="height:350px;">
                <table class="cont_t_list04"  style="width:100%;">
                    <caption>거래명세서 수정 및 출력 상세 리스트</caption>
                    <colgroup> 
                        <col width="15%" />
                        <col width="28%" />
                        <col width="12%" />
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
                            <th rowspan="2">비고</th> 
                        </tr>
                        <tr>
                            <th scope="col">품목코드</th> 
                            <th scope="col">규격</th> 
                            <th scope="col">납품수량</th>
                            <th scope="col">공급가액</th>
                            <th scope="col">납기요청일</th> 
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
						<input type="hidden"   name="st_po_no"      value="<%=p_po_no%>">
						<input type="hidden"   name="st_inv_no"      value="<%=p_inv_no%>">
						<input type="hidden"   name="st_ds_date"      value="<%=p_ds_date%>">
						
						<input type="hidden" name="st_po_seq"  value="<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>">
						<input type="hidden" name="st_inv_seq" value="<%=CommonUtil.nvl(rowData.get("INV_SEQ"))%>">
						
						<input type="hidden" name="st_cd_qty"  value="<%=CommonUtil.nvl(rowData.get("INV_LEGACY_QTY"))%>">
						<input type="hidden" name="st_po_qty"  value="<%=CommonUtil.nvl(rowData.get("ITEM_QTY"))%>">
						<input type="hidden" name="st_iv_qty"  value="<%=CommonUtil.nvl(rowData.get("IV_QTY"))%>">
						<input type="hidden" name="st_iv_cre_check"  value="<%=CommonUtil.nvl(rowData.get("DS_LIMIT"))%>">
						
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
							
							<td rowspan="2">
								<!-- 비고 -->
							 	<textarea cols="20" rows="3" style="overflow:auto" readonly><%=CommonUtil.nvl(rowData.get("PO_REMARK"))%></textarea>
							</td>
                        </tr> 
                        <tr bgcolor="<%=tclass%>">
							<td>
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
							 	<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("INV_QTY")),true,0,3)%>
							</td>
							<td class="right">
								<!-- 공급가액 -->
								<input type="text" name="st_item_amt" size="11" class="ar input_type_text" style="background-color:<%=tclass%>;border:<%=tclass%> 1px solid;" value="<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("SELLER_AMT")),true,0,3)%>" READONLY >
							</td>
							<td>
								<!-- 납기요청일 -->
                                <%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("RD_DATE")))%>
							</td>
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
		<!-- a href="javascript:top.window.close();"><img src="/kr/agent/images/button/btn_close.gif"	width="64" height="27" border="0" align="absmiddle" ></a -->

    </div>        
</div>
</form>
</body>
</html>
