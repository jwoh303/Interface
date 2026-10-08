<%--
**********************************************
* 메뉴 : 
* 화면 : 송장 상세조회 IV
* 기능 : 
* 프로그램 ID : PG_07_M_900_24
* 담당자 :  ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
 
<%
	@SuppressWarnings (value="unchecked")
	Map<String,String> _infoMap 		= (Map<String,String>) request.getAttribute("info"); // 조회된 결과
	
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList  = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

	//buyer=KRKEPB0004&seller=KRKORE0001&inv_no=IV13372113&po_no=PO13000067&pur_id=BUYER
	
	String p_buyer			= CommonUtil.nvl((String)request.getAttribute("buyer"));
	String p_seller			= CommonUtil.nvl((String)request.getAttribute("seller"));
	String p_po_no			= CommonUtil.nvl((String)request.getAttribute("po_no"));
	String p_inv_no			= CommonUtil.nvl((String)request.getAttribute("inv_no"));
	
	String legacy_po_no		= CommonUtil.nvl(_infoMap.get("LEGACY_PO_NO"));
	String purchaser_id		= CommonUtil.nvl(_infoMap.get("PURCHASER_ID"));
	String tr_buyer			= CommonUtil.nvl(_infoMap.get("TR_BUYER"));
	String legacy_iv_serial	= CommonUtil.nvl(_infoMap.get("LEGACY_IV_SERIAL"));
	String rpt_url			= CommonUtil.nvl(_infoMap.get("RPT_URL"));
	
%>

<script type="text/javascript">

//팝업 함수호출
function doPop(str, value1, value2, value3, value4) {
	switch (str) {
		case "agentDisplayPop": // 협력사
			getAgentDisplayPop(value1);
			break;
		
		case "buyerCatalogDisplayPop": // 품목코드팝업
			getBuyerCatalogDisplayPop(value1, value2, value3, value4);
			break;
		
	}
}

function sheetWin() {
	
	var buyer	= "<%=p_buyer%>";
	var rd_date = $("#st_rd_date").val();

	if(buyer=="KRKORE0212"){

		var dateArr =  setDateMsg(rd_date);
		
		// 고객사 납품요구일이  입니다. 기간내에만 출력이 가능합니다. (문의사항: 변상남 대리, 055-270-6208 / 010-2058-4564)
		var msg = CommonLang.msg("MSG481") + dateArr[0] +CommonLang.msg("MSG482") + "\n\n"
				+ dateArr[1] + " ~ " + dateArr[2] + CommonLang.msg("MSG483") + "\n\n"
				+ CommonLang.msg("MSG484");

		var from_date = dateArr[1].replace(/[/]/gi,"");
		var to_date = dateArr[2].replace(/[/]/gi,"");
		
		//if( rd_date <= fromDate || rd_date >= toDate  ){
		if( eval(today) < eval(from_date) || eval(today) > eval(to_date) ){
			alert(msg);
			return;
		}
	}

	var seller			= "<%=p_seller%>";
	var inv_no			= "<%=p_inv_no%>";
	var rpt_url 		= "<%=rpt_url%>";
	var legacy_po_no	= "<%=legacy_po_no%>";
	var pur_id 			= "<%=purchaser_id%>";
	var legacy_iv_serial= "<%=legacy_iv_serial%>";
	var tr_buyer 		= "<%=tr_buyer%>";
	var print_gbn 		= "";
	 	
   	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]";
   	
   	openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, print_gbn, legacy_po_no);
   	
	return;
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

</script> 
</head>
<body>
<form name="commonMpIvInvoiceDetailIVPop" id="commonMpIvInvoiceDetailIVPop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:556px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE869") %><!-- 송장 상세조회 IV --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!-- 송장 상세내용 -->
        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	        	<tr>
			        <td bgcolor="#898989" height="1" colspan="2"></td>
			    </tr>
			
			    <tr>
			        <td colspan="2">
			            <table width="100%" border="0" cellspacing="0" cellpadding="0">
			                <tr height="25">
			                    <td width="15%">&nbsp;&nbsp;<font color="#993300"><%=CommonLang.get("HTITLE203") %><!-- 발주번호 --></font></td>
			                    <td width="37%">
			                   		<%=_infoMap.get("PO_NO")%>
			                    </td>
			                    <td width="15%" height="25">&nbsp;&nbsp;<font color="#993300"><%=CommonLang.get("HTITLE271") %><!-- 송장번호 --></font></td>
			                    <td width="33%">
			                    	<%=_infoMap.get("INV_NO")%>
			                    </td>
			                </tr>
			
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			
			                <tr height="25">
			                    <td>&nbsp;&nbsp;<font color="#993300"><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></font></td>
			                    <td>
			                    	<%=_infoMap.get("BUYER_NAME")%>
			                    </td>
			                    <td>&nbsp;&nbsp;<font color="#993300"><%=CommonLang.get("HTITLE144") %><!-- 협력사 --></font></td>
			                    <td>
			                    	<a class="hyperLink" href="javascript:doPop('agentDisplayPop','<%=_infoMap.get("AGENT_CODE")%>');">
				                    	<%=_infoMap.get("AGENT_NAME")%>
				                    </a>
			                    </td>
			                </tr>
			                
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                
			                <tr height="25">
			                    <td>&nbsp;&nbsp;<font color="#993300"><%=CommonLang.get("HTITLE924") %><!-- 택배회사 --></font></td>
			                    <td>
			                    	<%=_infoMap.get("PARCEL_COM_CODE")%>
			                    </td>
			                    <td>&nbsp;&nbsp;<font color="#993300"><%=CommonLang.get("HTITLE925") %><!-- 운송장번호 --></font></td>
			                    <td>
			                    	<%=_infoMap.get("PARCEL_INV_NO")%>
			                    </td>
			                </tr>
			                
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                
			                <tr height="25">
			                    <td>&nbsp;&nbsp;<font color="#993300"><%=CommonLang.get("HTITLE243") %><!-- 납기요청일 --></font></td>
			                    <td>
			                    	<input type="hidden" id="st_rd_date" name="st_rd_date"  value="<%=CommonUtil.nvl(_infoMap.get("RD_DATE"))%>">
			                   		<%=CommonUtil.formatStrinigDate(_infoMap.get("RD_DATE"))%>
			                    </td>
			                    <td>&nbsp;&nbsp;<font color="#993300"><%=CommonLang.get("HTITLE870") %><!-- 납품확정일 --></font></td>
			                    <td>
			                    	<%=CommonUtil.formatStrinigDate(_infoMap.get("INV_DATE"))%>
			                    </td>
			                </tr>
			                
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                
			                <tr height="25">
			                    <td>&nbsp;&nbsp;<font color="#993300"><%=CommonLang.get("HTITLE583") %><!-- 배송지 --></font></td>
			                    <td colspan="3">
			                   		<%=_infoMap.get("DELY_TO_LOCATION")%>
			                    </td>
			                </tr>
			                
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                
			                <tr height="25">
			                    <td>&nbsp;&nbsp;<font color="#993300"><%=CommonLang.get("HTITLE122") %><!-- 비고 --></font></td>
			                    <td colspan="3">
			                   		<%=_infoMap.get("REMARK_INV")%>
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
            <div class="scrollArea" style="height:284px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>송장 상세조회 IV 리스트</caption>
                    <colgroup>
                        <col width="11%" />
						<col width="15%" />
						<col width="20%" />
						<col width="9%" />
						<col width="9%" />
                        <col width="4%" />
                        <col width="10%" />
                        <col width="12%" />
                        <col width="10%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE217") %><!-- 발주수량 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE263") %><!-- 송장수량 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE52") %><!-- 단위 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE174") %><!-- 단가 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE204") %><!-- 금액 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --></th>  
                        </tr>
                    </thead>
                    <tbody>
				<%
					double tot_price = 0;
					
					if (_dataList == null || _dataList.size() == 0){
				%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="9" align="center" height = "280">
	                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
	                        </td> 
	                    </tr>
				<%
					} else {
						for (int j=0; j<_dataList.size(); j++) {
							Map<String,String> _tmp = _dataList.get(j);
							
							tot_price += Double.parseDouble(_tmp.get("PO_AMT"));
							
				%> 
						<tr>
							<td class="left">
								<a class="hyperLink" href="javascript:doPop('buyerCatalogDisplayPop','<%=_tmp.get("BYIT_COMORG_CODE")%>', '<%=_tmp.get("BUYER_ITEM_NO")%>','<%=_tmp.get("CONTRACT_NO")%>', '<%=_tmp.get("CONTRACT_SEQ")%>');">
							 		<%=_tmp.get("BUYER_ITEM_NO")%>
							 	</a>
							</td>
							<td class="left">
							 	<%=_tmp.get("DESCRIPTION")%>
							</td>
							<td class="left">
							 	<%=_tmp.get("SPECIFICATION")%>
							</td>
							<td class="right">
							 	<%=CommonUtil.formatNumber(_tmp.get("ITEM_QTY"),true,0,3)%>
							</td>
							<td class="right">
							 	<%=CommonUtil.formatNumber(_tmp.get("INV_QTY"),true,0,3)%>
							</td>
							<td class="right">
							 	<%=_tmp.get("UNIT_MEASURE")%>
							</td>
							<td class="right">
							 	<%=CommonUtil.formatNumber(_tmp.get("UNIT_PRICE"),true,0,3)%>
							</td>
							<td class="right">
							 	<%=CommonUtil.formatNumber(_tmp.get("PO_AMT"),true,0,3)%>
							</td>
							<td>
							 	<%=_tmp.get("REF_PR_NO")%>
							</td>
						</tr> 
				<%
						}
					}
				%>   
                    </tbody>
                </table>    
                <table width="100%">
					<tr>
						<td align="right" height = "30" style="padding-bottom:2px">
							<b>
								<font color="#990000"><%=CommonLang.get("HTITLE584") %><!-- 금액합계 --></font> : 
								<font color="#006699">
									<%=CommonUtil.formatNumber(tot_price,true,0,3)%>&nbsp;<%=CommonLang.get("HTITLE660") %><!-- 원 -->
								</font>
							</b>
						</td>
					</tr>
				</table>              
	        </div>
	        <div style="height:25px">
		        <table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:5px;">
					<tr> 
						<td align="left" width="100px">
							<!-- 발주서인쇄 버튼 -->
							<div class="btnArea">
								<div class="fr">
									<span class="btn_04">
										<a href="javascript:sheetWin();"><%=CommonLang.get("HTITLE871") %><!-- 거래명세서 --></a>
									</span>	
					            </div>
					        </div>
						</td>
					</tr>
				</table>
			</div>
	    </div>        
	</div>
</form> 
</body>
</html>
