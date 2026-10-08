<%--
**********************************************
* 메뉴 : 
* 화면 : 발주 상세조회 고객사용
* 기능 : 
* 프로그램 ID : PG_07_M_900_11
* 담당자 : CEJ  ( 설계 : 김지현 )
* 착수일 : 2014-09-05
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
	
	String p_buyer = CommonUtil.nvl((String) request.getParameter("buyer"),"");
	String p_po_no = CommonUtil.nvl((String) request.getParameter("po_no"),"");
	
%>

<script type="text/javascript">

//팝업 함수호출
function doPop(str, value1, value2, value3, value4, value5, value6) {
	switch (str) {
		case "dept": // 요청부서
			var com_code = $("#st_com_code").val();
			//kepOpenSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+value1);
			break;
			
		case "commonMpIvOrderDetailPop": // 발주번호
			openSearchPopup('/mpiv/getCommonMpIvOrderDetailPop.do','?buyer='+value1+'&po_no='+value2 , "820,550,no");
		 
			break;
			
		case "commonMpIvInvoiceDetailPop": // 송장번호
			if(value3.substring(0,2) == "IV") {
				openSearchPopup('/mpiv/getCommonMpIvInvoiceDetailIVPop.do','?buyer='+value1+'&seller='+value2+'&inv_no='+value3+'&po_no='+value4+'&pur_id='+value6,  "820,550,no");
				
			} else {
				openSearchPopup('/mpiv/getCommonMpIvInvoiceDetailIKPop.do','?buyer='+value1+'&seller='+value2+'&inv_no='+value3+'&po_no='+value4+'&warehouse_code='+value5,   "820,550,no");
			}
			
			break;	
			
		case "agentDisplayPop": // 협력사
			getAgentDisplayPop(value1);
			break;
			
		case "newDepartmentDisplayPop": // 요청부서팝업
			var com_code = $("#st_com_code").val();
			openSearchPopup('/coco/getCommonCoCoDepartmentDetailViewPop.do','?openYn=Y&st_com_code='+com_code+'&st_dept='+value1 , "410,143,no");
			break;	
		
		case "buyerCatalogDisplayPop": // 품목코드팝업
			getBuyerCatalogDisplayPop(value1, value2, value3, value4);
			break;
		
	}
}

function btnSheet(){

	var po_no   = "<%=p_po_no%>";
	var buyer  = "<%=p_buyer%>";
	var seller = "KRKORE0001";
	var add_user_id = $("#st_add_user_id").val();


	<%
		String rptUrl = CommonUtil.nvl(_infoMap.get("RPT_URL"));
		
		if(rptUrl.equals("")){
// 			rptUrl = "RD_06_S_002_06";
			rptUrl = "RD_06_B_003_03";
			
		}
	%>
	
	var param =  "["+po_no+"]["+seller+"]["+buyer+"]";
	var fileName = "<%=rptUrl%>";
	
	//alert("RD_ID : " + fileName + "\n, param : " + param);
	
	//var param =  "[PO14004517][KRDAEW0023][KRKORE0001]";
	reportOpen(fileName,param);
	
	return;	

	/*
	if(buyer == 'KRDOOD0001' && add_user_id != "1110"){   // 1110 ==> 지원)총무팀

		window.open("/kr/epro/buy/sheet/bpo_prn1_doosan.jsp?po_no="+pono+"&buyer="+buyer+"&seller="+seller,"SWin","width=710,height=710,left=0, top=0,resizable=YES,scrollbars=YES");
	
	}else if(buyer == 'KRDCCH0002' || buyer == 'KRDCCH0004'){
	
		window.open("/kr/epro/buy/sheet/bpo_prn1_gunsan.jsp?po_no="+pono+"&buyer="+buyer+"&seller="+seller,"SWin","width=710,height=710,left=0, top=0,resizable=YES,scrollbars=YES");
	
	}else if(buyer == 'KRDAEW0023' || buyer == 'KRDHIM0001'){
	
		window.open("/kr/epro/buy/sheet/bpo_prn1_daew.jsp?po_no="+pono+"&buyer="+buyer+"&seller="+seller,"SWin","width=710,height=710,left=0, top=0,resizable=YES,scrollbars=YES");
	
	}else{
	
		window.open("/kr/epro/buy/sheet/bpo_prn1.jsp?po_no="+pono+"&buyer="+buyer+"&seller="+seller,"SWin","width=710,height=710,left=0, top=0,resizable=YES,scrollbars=YES");
	
	}
	*/

}

</script> 
</head>
<body>
<form name="commonMpIvOrderDetailPop" id="commonMpIvOrderDetailPop" method=post >
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
<input type="hidden" name="st_seller" id="st_seller" value="<%=_infoMap.get("SELLER")%>">
<input type="hidden" name="st_add_user_id" id="st_add_user_id" value="<%=_infoMap.get("CHANGE_USER_ID")%>">


	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:556px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE705") %><!-- 고객사 발주 상세조회 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!-- 발주 상세내용 -->
        	<table style="width:100%;">
			    <tr>
			        <td colspan="2">
			           <table  class="board_write" summary="구매발주 상세조회">
			                <tr height="25">
			                    <th width="15%"><%=CommonLang.get("HTITLE203") %><!-- 발주번호 --></th>
			                    <td width="37%"><font color="#1c89de"><b><%=_infoMap.get("PO_NO")%></b></font>
			                    </td>
			                    <th width="15%" height="25"><%=CommonLang.get("HTITLE582") %><!-- 선입고여부 --></th>
			                    <td width="33%">
			                    	<%=_infoMap.get("DOC_TEXT")%>
			                    </td>
			                </tr>
			
			                <tr height="25">
			                    <th><%=CommonLang.get("HTITLE208") %><!-- 발주일 --></th>
			                    <td>
			                   		<%=CommonUtil.formatStrinigDate(_infoMap.get("PO_CREATE_DATE"))%>
			                    </td>
			                    <th><%=CommonLang.get("HTITLE187") %><!-- 발주자 --></th>
			                    <td>
			                    	<%=_infoMap.get("USER_NAME")%>
			                    </td>
			                </tr>
			                
			                <tr height="25">
			                    <th><%=CommonLang.get("HTITLE144") %><!-- 협력사 --></th>
			                    <td>
			                   		<%=_infoMap.get("AGNET_TEXT")%>
			                    </td>
			                    <th><%=CommonLang.get("HTITLE188") %><!-- 발주부서 --></th>
			                    <td>
			                    	<a class="hyperLink" href="javascript:doPop('newDepartmentDisplayPop','<%=_infoMap.get("CHANGE_USER_DEPT")%>');">
				                    	<%=_infoMap.get("USER_DEPT")%>
				                    </a>
			                    </td>
			                </tr>
			                
			                <tr height="25">
			                    <th><%=CommonLang.get("HTITLE583") %><!-- 배송지 --></th>
			                    <td colspan="3">
			                   		<%=_infoMap.get("DELY_TO_LOCATION")%>
			                    </td>
			                </tr>
			                
			                <tr height="25">
			                    <th><%=CommonLang.get("HTITLE122") %><!-- 비고 --></th>
			                    <td colspan="3">
			                   		<%=_infoMap.get("PO_REMARK")%>
			                    </td>
			                </tr>
			                
			            </table>
			        </td>
			    </tr>
			</table>
            <br>
			<!--grid-->
			<div class="scrollArea" style="height:230px">
				<table  class="cont_t_list02"  style="width:100%">
					<caption>발주 상세조회 리스트</caption>
						<colgroup>
						<col width="11%" />
						<col width="13%" />
						<col width="20%" />
						<col width="11%" />
						<col width="11%" />
						<col width="11%" /> 
						<col width="13%" /> 
						<col width="*" /> 
					</colgroup>
					<thead>
						<tr>
							<th scope="col"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE142") %><!-- 수량/단위 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE174") %><!-- 단가 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE204") %><!-- 금액 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE243") %><!-- 납기요청일 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --></th> 
						</tr>
					</thead>
					<tbody>
				<%
					double tot_price = 0;
				
					if (_dataList == null || _dataList.size() == 0){
				%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="8" align="center" height = "230">
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
							 	<%=CommonUtil.formatNumber(_tmp.get("ITEM_QTY"),true,0,3)%>/<%=_tmp.get("UNIT_MEASURE")%>
							</td>
							<td class="right">
							 	<%=CommonUtil.formatNumber(_tmp.get("UNIT_PRICE"),true,0,3)%>
							</td>
							<td class="right">
							 	<%=CommonUtil.formatNumber(_tmp.get("PO_AMT"),true,0,3)%>
							</td>
							<td>
							 	<%=CommonUtil.formatStrinigDate(_tmp.get("RD_DATE"))%>
							</td>
							<td>
							 	<%=_tmp.get("REF_PR_NO")%>
							</td>
						</tr>
						<tr>
							<td class="left" colspan="8">
								<%=CommonLang.get("HTITLE783") %><!-- 품목비고 --> : <%=_tmp.get("PO_REMARK")%>
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
								<div class="fl">
									<span class="btn_04">
										<a href="javascript:btnSheet();"><%=CommonLang.get("HTITLE585") %><!-- 발주서인쇄 --></a>
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
