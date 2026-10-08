<%--
**********************************************
* 메뉴 : 
* 화면 : 발주정보 조회
* 기능 : 발주상세정보를 확인할 수 있는 팝업(협력사에서)
* 프로그램 ID : PG_07_M_900_13
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

<%
	@SuppressWarnings (value="unchecked")

	//SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String user_id      = _sessionInfo.getUserId();
	String com_code =  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
	String p_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
	String p_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");  //  (조회조건)
	
	
	Map<String,String> detailInfo = (Map<String,String>) request.getAttribute("detailInfo"); // 조회결과 - 상세정보
	List<Map<String, String>> detailList = (List<Map<String, String>>) request.getAttribute("detailList"); // 조회결과 - 상세 리스트
	
	Map<String,String> orderRecvHeader = (Map<String,String>) request.getAttribute("orderRecvHeader"); // 조회결과 - 발주서인쇄 정보 조회
	
	Map<String,String> specialLogicInfo = (Map<String,String>) request.getAttribute("specialLogicInfo"); // 조회결과 - 특수로직 정보 조회
	
	int page_display_cnt = 0;
	
	// 발주서인쇄, 납부지시서 이벤트 시 사용
	String buyer_tr = "";
	String seller = "";
	String ref_if_no = "";
	String add_user_id = "";
	String agent_code = "";
	
	if(orderRecvHeader != null){
		
		buyer_tr = CommonUtil.nvl(orderRecvHeader.get("BUYER2"));
		seller = CommonUtil.nvl(orderRecvHeader.get("SELLER"));
		ref_if_no = CommonUtil.nvl(orderRecvHeader.get("REF_IF_NO"));
		add_user_id = CommonUtil.nvl(orderRecvHeader.get("ADD_USER_ID"));
		agent_code = CommonUtil.nvl(orderRecvHeader.get("AGENT"));
		
		//buyer_tr = "KRDAEW0016";
	}
	
%>
<script type="text/javascript"> 
 var popupSel = "";
 
// 팝업호출
var gridIndex = 0;
function doPop(str, value1, value2, value3, value4) {
	popupSel = str ;
	
	switch (str) {
		case "agent": // 고객사정보
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
			break;
		case "catalogDetailPop": // 품목상세정보
			getBuyerCatalogDisplayPop(value1, value2, value3, value4);
			break;
		case "attach"://파일 첨부
			popupSel = "fileUpload";

			var type="PO";
			var imageKey =  value1;
			var viewType="R";
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+imageKey+"&TYPE="+type+"&viewType="+viewType, "500,430,no");
			break;
	}
}

// 발주서 인쇄
function btnSheet() {
	var po_no        = "<%=p_po_no%>";
	var buyer       = "<%=p_buyer%>";
	var seller      = "<%=CommonUtil.nvl(specialLogicInfo.get("SELLER"))%>";

	<%
		String Agent_rptUrl = CommonUtil.nvl(specialLogicInfo.get("AGENT_RPT_URL"));
		
		if(Agent_rptUrl.equals("")){
			Agent_rptUrl = "RD_06_S_002_06";
		}
	%>
	
	var param =  "["+po_no+"]["+seller+"]["+buyer+"]";
	var fileName = "<%=Agent_rptUrl%>";
	
	reportOpen(fileName,param);
	
	return;	
	
}

function SheetWin_daewoo_3(){  //신규 납품지시서
	 var agent_code  = "<%--=String.valueOf(vt.elementAt(4)) --%>";
	 window.open("/kr/epro/buy/sheet/daewoo_delivery_order_list.jsp?agent_code="+agent_code,"sheetWin_TEST_3","toolbar=yes,width=700,height=600,resizable=YES,scrollbars=YES,top=0,left=0");
}

</script> 
</head>

<body onload="">
<form name = "contentForm" id="contentForm" method = "post">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
    	<div id="popHeader">
        	<h1 class="title">발주정보 조회</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!-- 수주접수 상세내용 -->
        	<%
        		
        		String doc_type = "";
        		String pre_gr_flag = "";
        		String buyer_name = "";
        		String buyer2 = "";
        		String purchaser_name = "";
        		String po_create_date = "";
        		
        		String tel_no = "";
        		String agent_po_ttl_amt = "";
        		
        		String dely_to_location = "";
        		String po_remark = "";
        		
				String center_tel_no = ""; 
				String process_type =  "";
				
				if(detailInfo != null){
					
					doc_type = CommonUtil.nvl(detailInfo.get("DOC_TYPE"));
					pre_gr_flag = CommonUtil.nvl(detailInfo.get("KEPMRO_PRE_GR_FLAG"));
					buyer_name = CommonUtil.nvl(detailInfo.get("BUYER_NAME"));
	        		buyer2 = CommonUtil.nvl(detailInfo.get("BUYER2"));
	        		purchaser_name = CommonUtil.nvl(detailInfo.get("PURCHASER_NAME"));
	        		po_create_date = CommonUtil.formatStrinigDate(CommonUtil.nvl(detailInfo.get("PO_CREATE_DATE")));
	        		
	        		tel_no = CommonUtil.nvl(detailInfo.get("TEL_NO"));
	        		agent_po_ttl_amt = CommonUtil.formatNumber(CommonUtil.nvl(detailInfo.get("AGENT_PO_TTL_AMT")),true,0,3);
	        		
	        		dely_to_location = CommonUtil.nvl(detailInfo.get("DELY_TO_LOCATION"));
	        		
	        		process_type = CommonUtil.nvl(detailInfo.get("PROCESS_TYPE"));
	        		center_tel_no = CommonUtil.nvl(detailInfo.get("CENTER_TEL_NO"));
	        		
	        		if("KRDAEH0123".equals(p_buyer) || "KRDAEH0133".equals(p_buyer) || "KRDAEH0134".equals(p_buyer)){
						po_remark = "";
					}else{
						po_remark = CommonUtil.nvl(detailInfo.get("PO_REMARK"));
					}
	        		
				}
			%>     
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
			        <td height="23"></td>
			        <%
			            if(doc_type.equals("S") || (doc_type.equals("X") && pre_gr_flag.equals("Y"))){
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
	            			<%if(process_type.equals("2")){%>
	            			<colgroup>
								<col width=9%" />
								<col width= * />
								<col width="9%" />
								<col width="13%" />
								<col width="9%" />
								<col width="13%" />
				           	</colgroup>
							<%}%>            
							
							<tr>
			                    <td height="25">&nbsp;&nbsp;<font color="#993300">고객사</font></td>
			                    <td> : 
			                    	<a class="hyperLink" href="javascript:doPop('agent','<%=buyer2%>');">
			                   			<%=buyer_name%>
			                   		</a>
			                    </td>
			                    
			                    <td>&nbsp;&nbsp;<font color="#993300">발주자</font></td>
			                    <td> : <%=purchaser_name%></td>
			                    <td>&nbsp;&nbsp;<font color="#993300">발주일</font></td>
			                    <td> : <%=po_create_date%></td>
			                </tr>
			
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			
			                <tr>
			                    <td height="25">&nbsp;&nbsp;<font color="#993300">발주번호</font></td>
			                    <td> : <%=p_po_no%></td>
			                    <td>&nbsp;&nbsp;<font color="#993300">전화번호</font></td>
			                    <td> : <%=tel_no%></td>
			                    <td>&nbsp;&nbsp;<font color="#993300">금액</font></td>
			                    <td> : <%=agent_po_ttl_amt%> 원</td>
			                </tr>
			                <tr>
			                    <td background="/resources/images/line_dot.gif" colspan="6" height="1"></td>
			                </tr>
			                <tr>
			                    <td height="25">&nbsp;&nbsp;<font color="#993300">배송지</font></td>
			                    <td colspan="5" > : <%=dely_to_location%>
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
			                <tr>
			                    <td height="25">&nbsp;&nbsp;<font color="#993300">비고</font></td>
			                    <td colspan="5"> :
								<%=po_remark%>
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
            <div class="scrollArea" style="height:338px">
                <table  class="cont_t_list04"  style="width:100%">
                    <caption>발주정보 상세 리스트</caption>
                    <colgroup>
                        <col width="11%" /> 
                        <col width="28%" />
                        <col width="10%" />
                        <col width="10%" />
                        <col width="12%" />
                        <col width="18%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">관리번호</th> 
                            <th scope="col">품목명</th> 
                            <th scope="col">발주수량</th>
                            <th scope="col">단가</th>
                            <th scope="col">납기요청일</th>
                            <th scope="col" rowspan="2">비고</th>
                            <th scope="col" rowspan="2">첨부</th> 
                        </tr>
                        <tr>
                            <th scope="col">품목코드</th> 
                            <th scope="col">규격</th> 
                            <th scope="col">단위</th>
                            <th scope="col">금액</th>
                            <th scope="col">제조사</th> 
                        </tr>
                    </thead>
                    <tbody>
					<%
					if (detailList == null || detailList.size() == 0){
					%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="8" align="center" height = "280">
	                        <span class="font1">조회된 데이타가 없습니다.</span>
	                        </td> 
	                    </tr>
					<%
					}else{
						for (int j=0; j<detailList.size(); j++) {
							page_display_cnt++;
							
							Map<String,String> rowData = detailList.get(j);
							String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
					%> 
                        <tr bgcolor="<%=tclass%>">
							<td>
								<!-- 관리번호 -->
							 	<%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%>
							</td>
							<td class="left">
								<!-- 품명 -->
							 	<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>
							</td>
							<td class="right">
								<!-- 발주수량 -->
							 	<%=CommonUtil.nvl(rowData.get("ITEM_QTY"))%>
							</td>
							<td class="right">
								<!-- 단가 -->
							 	<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("AGENT_PRICE")),true,0,3)%>
							 	
							</td>
							<td>
								<!-- 납기요청일 -->
							 	<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("RD_DATE")))%>
							 	
							</td>
							<td rowspan="2">
								<!-- 비고 -->
							 	<%=CommonUtil.nvl(rowData.get("PO_REMARK"))%>
							</td>
							<td rowspan="2">
								<!-- 첨부 -->
							 	<%
									if (("").equals(CommonUtil.nvl(rowData.get("IMAGE_KEY")))) {
								%>
										<img name = "st_image_key_img" src="/resources/images/disk_off.gif" border="0">
								<%
									}else{
								%>         
										<a class="hyperLink" href="javascript:doPop('attach', '<%=CommonUtil.nvl(rowData.get("IMAGE_KEY"))%>')">
											<img name = "st_image_key_img" src="/resources/images/disk_on.gif" border="0">
										</a>
										<!-- a href="javascript:attach_popup('<% //=j%>');">
											<img src="/kr/new_sourcing/images/disk_on.gif" name="MasterImage" width="14" height="14" border="0">
										</a -->    
								<%
									}
								%>
							</td>
                        </tr> 
                        <tr bgcolor="<%=tclass%>">
							<td>
								<!-- 품목코드-->
								<a class="hyperLink" href="javascript:doPop('catalogDetailPop','<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>');">
									<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>
								</a>
							</td>
							<td class="left">
								<!-- 규격 -->
							 	<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
							</td>
							<td>
								<!-- 단위 -->
							 	<%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>
							</td>
							<td class="right">
								<!-- 금액 -->
								<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("AGENT_ITEM_AMT")),true,0,3)%>
							</td>
							<td class="left pl10">
								<!-- 제조사 -->
							 	<%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%>
                                
							</td>
                        </tr>
					<%
						}
					}
					%>
  
                    </tbody>
                </table>                  
                <input type="hidden" id="display_item_cnt" name="display_item_cnt"    value="<%=page_display_cnt%>">
        </div>
        
        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:8px;">
			<tr> 
				<td align="left" width="100px">
					<!-- 발주서인쇄 버튼 -->
					<!-- a href="javascript:btnSheet()"><img src="/kr/agent/images/button/btn_po_prt.gif"	width="98" height="27" border="0" align="absmiddle"></a -->
					
					<div class="btnArea">
						<div class="fl">
							<span class="btn_04">
								<a href="javascript:btnSheet();">발주서인쇄</a>
							</span>	
			            </div>
			        </div>
				</td>
				
				<td align="left" width="100px">
					<% 
						if(buyer_tr.equals("KRDAEW0016")){ 
					%>
						<!-- 납품지시서 버튼 삭제
						<div class="btnArea">
							<div class="fr">
								<span class="btn_04">
									<a href="javascript:SheetWin_daewoo_3();">납품지시서</a>
								</span>	
				            </div>
				        </div>
							 -->
					<% 
						}	
					%>
				</td>
		  </tr>
		</table>
    </div>        
</div>
</form>
</body>
</html>
