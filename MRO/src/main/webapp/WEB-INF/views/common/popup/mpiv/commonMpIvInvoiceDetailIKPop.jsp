<%--
**********************************************
* 메뉴 : 
* 화면 : 송장 상세조회 IK
* 기능 : 
* 프로그램 ID : PG_07_M_900_23
* 담당자 :  ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
 
<%
	@SuppressWarnings (value="unchecked")
	Map<String,String> _infoMap 		= (Map<String,String>) request.getAttribute("info"); // 조회된 결과
	
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList  = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

	String _buyer = CommonUtil.nvl((String)request.getParameter("buyer"),"");
	String _warehouseCode = CommonUtil.nvl((String)request.getParameter("warehouse_code"),"");
	
    String pP08_0000011id ="";
	Map<String, String> _map = CommonUtil.getSpecialCheckReturnSheetMap(_buyer);
	if(_map!=null){
		pP08_0000011id = _map.get("SLG_ID");
	}
	String  deptMap = "";
	Map<String,String> formDataTemp = new HashMap<String,String>();
	if("P08-0000011-23".equals(pP08_0000011id)   ){
		
		formDataTemp.put("st_warehouse_code",CommonUtil.nvl((String) request.getParameter(_warehouseCode),"") );
		formDataTemp.put("st_ik_no_temp",   CommonUtil.nvl((String) _infoMap.get("INV_NO")));
		formDataTemp.put("st_buyer",CommonUtil.nvl((String) request.getParameter(_buyer),"") );
		deptMap = CommonUtil.getSpecialCheckReturnSheetMapByDept( formDataTemp );

		}
%>
<script src="/resources/js/wms_tr_sheet.js"></script>
<script type="text/javascript">

//팝업 함수호출
function doPop(str, value1, value2, value3, value4){
	switch (str) {
		case "agentDisplayPop": // 협력사
			getAgentDisplayPop(value1);
			break;
			
		case "buyerCatalogDisplayPop": // 품목코드팝업
			getBuyerCatalogDisplayPop(value1, value2, value3, value4);
			break;
	}
}

function sheetWin(){
	
	//http://localhost:8080/mpiv/getCommonMpIvInvoiceDetailIKPop.do?buyer=KRKEPB0004&seller=KRKORE0001&inv_no=IK14106577&po_no=PO14000024&warehouse_code=KRKORE0246
			
	var warehouse_code = $("#st_warehouse_code").val();
	var buyer = $("#st_buyer").val();
	var ik_no = $("#st_ik_no").val();
	var user_id = $("#st_user_id").val();
	
	var legacy_po_no = $("#st_legacy_po_no").val();
	var legacy_po_seq = $("#st_legacy_po_seq_tot").val();
	var legacy_iv_serial = $("#st_legacy_iv_serial").val();
	
	if("P08-0000011-23"=="<%=pP08_0000011id%>" )
	{
		setWmsTrSheet("<%=pP08_0000011id%>","", "<%=deptMap%>", warehouse_code, buyer, ik_no, user_id, legacy_po_no, legacy_po_seq, legacy_iv_serial, "");
	}else{
		setWmsTrSheet("<%=pP08_0000011id%>","", "", warehouse_code, buyer, ik_no, user_id, legacy_po_no, legacy_po_seq, legacy_iv_serial, "");
	}
	

	return;
}
</script> 
</head>
<body>
<form name="commonMpIvInvoiceDetailIKPop" id="commonMpIvInvoiceDetailIKPop" method=post >

	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=_buyer%>">
	<input type="hidden" id="st_warehouse_code"  name="st_warehouse_code" value="<%=_warehouseCode%>">
	<input type="hidden" id="st_ik_no"  name="st_ik_no" value="<%=_infoMap.get("INV_NO")%>">
	<input type="hidden" id="st_legacy_po_no"  name="st_legacy_po_no" value="<%=_infoMap.get("LEGACY_PO_NO")%>">
	<input type="hidden" id="st_legacy_iv_serial"  name="st_legacy_iv_serial" value="<%=_infoMap.get("LEGACY_IV_SERIAL")%>">
	
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:556px;">
    	<div id="popHeader">
        	<h1 class="title">송장 상세조회 IK</h1>
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
			                    <td width="15%">&nbsp;&nbsp;<font color="#993300">발주번호</font></td>
			                    <td width="37%">
			                   		<%=_infoMap.get("PO_NO")%>
			                    </td>
			                    <td width="15%" height="25">&nbsp;&nbsp;<font color="#993300">송장번호</font></td>
			                    <td width="33%">
			                    	<%=_infoMap.get("INV_NO")%>
			                    </td>
			                </tr>
			
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			
			                <tr height="25">
			                    <td>&nbsp;&nbsp;<font color="#993300">고객사</font></td>
			                    <td>
			                    	<%=_infoMap.get("BUYER_NAME")%>
			                    </td>
			                    <td>&nbsp;&nbsp;<font color="#993300">협력사</font></td>
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
			                    <td>&nbsp;&nbsp;<font color="#993300">택배회사</font></td>
			                    <td>
			                    	<%=_infoMap.get("DELIVERY_COMPANY")%>
			                    </td>
			                    <td>&nbsp;&nbsp;<font color="#993300">운송장번호</font></td>
			                    <td>
			                    	<%=_infoMap.get("DELIVERY_NO")%>
			                    </td>
			                </tr>
			                
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                
			                <tr height="25">
			                    <td>&nbsp;&nbsp;<font color="#993300">납기요청일</font></td>
			                    <td>
			                   		<%=CommonUtil.formatStrinigDate(_infoMap.get("RD_DATE"))%>
			                    </td>
			                    <td>&nbsp;&nbsp;<font color="#993300">납품확정일</font></td>
			                    <td>
			                    	<%=CommonUtil.formatStrinigDate(_infoMap.get("DELIVERY_DATE"))%>
			                    </td>
			                </tr>
			                
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                
			                <tr height="25">
			                    <td>&nbsp;&nbsp;<font color="#993300">배송지</font></td>
			                    <td colspan="3">
			                   		<%=_infoMap.get("DELY_TO_LOCATION")%>
			                    </td>
			                </tr>
			                
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                
			                <tr height="25">
			                    <td>&nbsp;&nbsp;<font color="#993300">비고</font></td>
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
                            <th scope="col">품목코드</th>
                            <th scope="col">품목명</th>
                            <th scope="col">규격</th>
                            <th scope="col">발주수량</th>
                            <th scope="col">송장수량</th>
                            <th scope="col">단위</th>
                            <th scope="col">단가</th>
                            <th scope="col">금액</th>
                            <th scope="col">관리번호</th>  
                        </tr>
                    </thead>
                    <tbody>
				<%
					double tot_price = 0;
				
					String _legacyPoSeqA = "";
					String _legacyPoSeqTot = "";
					
					if (_dataList == null || _dataList.size() == 0){
				%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="9" align="center" height = "280">
	                        <span class="font1">조회된 데이타가 없습니다.</span>
	                        </td> 
	                    </tr>
				<%
					} else {
						
						for (int j=0; j<_dataList.size(); j++) {
							Map<String,String> _tmp = _dataList.get(j);
							
							tot_price += Double.parseDouble(_tmp.get("PO_AMT"));
							
							if(_buyer.equals("KRDOOS0035")){
								if(j == (_dataList.size()-1) ){
									_legacyPoSeqA = CommonUtil.nvl(_tmp.get("LEGACY_PO_SEQ")) + "";
								} else {
									_legacyPoSeqA = CommonUtil.nvl(_tmp.get("LEGACY_PO_SEQ")) + ",";
								}
								
								_legacyPoSeqTot = _legacyPoSeqTot + _legacyPoSeqA;
								
							} else {
								_legacyPoSeqA = CommonUtil.nvl(_tmp.get("LEGACY_PO_SEQ")) + "@@";	
								_legacyPoSeqTot = _legacyPoSeqTot + _legacyPoSeqA;
							}
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
								<font color="#990000">금액합계</font> : 
								<font color="#006699">
									<%=CommonUtil.formatNumber(tot_price,true,0,3)%>&nbsp;원
									
									<input type="hidden" id="st_legacy_po_seq_tot"  name="st_legacy_po_seq_tot" value="<%=_legacyPoSeqTot%>">
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
										<a href="javascript:sheetWin();">거래명세서</a>
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
