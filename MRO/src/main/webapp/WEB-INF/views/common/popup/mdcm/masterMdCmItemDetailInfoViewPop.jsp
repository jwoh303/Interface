<%--
**********************************************
* 메뉴 : 
* 화면 : 상품상세보기
* 기능 : 
* 프로그램 ID : PG_03_M_008_01
* 담당자 : 카탈개 ( 설계 : 권우재 )
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
	Map<String,String> _dataList = (Map<String,String>) request.getAttribute("data"); // 조회된 결과
	
	String userName	= _sessionInfo.getUserNameLoc();
	String curDate	= CommonUtil.getCurrentDay_Time("yyMMdd");
	
	String itemNo	= CommonUtil.nvl((String)request.getParameter("ITEM_NO"), "");
	String rfqNo	= CommonUtil.nvl((String)request.getParameter("RFQ_NO"), "");
	
%>
<script type="text/javascript">
//<!--
function doAction(str) {
	switch (str) {
		case "proc":	 //처리
			setRecvRemark();
			break;
	}
}

//견적제안서 처리
function setRecvRemark() {

	if(isEmpty($("#st_recv_remark").val())) {
		alert("처리내역을 입력하여 주십시요.");
		$("#st_recv_remark").focus();
		return;
	}

	if(confirm("처리 하시겠습니까?")) {
		kepAjaxFormCall("/mdcm/procMasterMdCmItemDetailInfoViewPop.do","masterMdCmItemDetailInfoViewPop","btnProc");
		
	}	
	/*
     document.forms[0].target = "work";
     document.forms[0].method = "post";
     document.forms[0].action = "/kr/promote/promote_catalog_srdt_process_reg.jsp";
     document.forms[0].submit();
*/
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	alert("처리 완료 되었습니다.");
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


// 견적서 출력
function getPrmtitemInv() {

	var item_no = "<%=itemNo%>";
	var rd_id = "RD_09_A_001_00";

	var param = "["+item_no+"@@]";
	
	reportOpen(rd_id,param);
	
	//var item_no_list = "";

    //window.open("/kr/promote/prmtitem_inv.jsp?st_item_no="+item_no_list,"PrmtItem","width=700,height=680,resizable=YES,scrollbars=YES,top=0,left=0");
	return;
}

//-->
</script>
</head>
<body>
<form name="masterMdCmItemDetailInfoViewPop" id="masterMdCmItemDetailInfoViewPop" method=post >
	<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
	
	<input type="hidden" name="st_item_no" value="<%=itemNo%>">
	<input type="hidden" name="st_rfq_no" value="<%=rfqNo%>">
	
	<div id="popWrapper" style="height:544px;">
		<div id="popHeader">
			<h1 class="title">상품상세보기</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
			
			<!--내용 시작-->
			<div id="ContArea">
				<table  style="width:100%">
					<caption>상품상세보기</caption>
					<colgroup>
						<col width="220px" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<td width="220" vAlign="top">
								<table border="0" cellSpacing="0" cellPadding="0" width="100%">
									<tbody>
										<tr>
											<td height="230" vAlign="top" align="center">&nbsp;&nbsp; &nbsp;
												<img src = "/resources/images/icon_emptyimg.gif"  id="image1" name="image1" width="200" height="200">
											</td>
											<td width="20">&nbsp;</TD>
										</tr>
									</tbody>
								</table>
							</td>
							<td align="center">
								<table  class="cont_t_list06"  style="width:100%">
									<colgroup>
										<col width="120px" />
										<col width="32%" />
										<col width="120px" />
										<col width="32%" />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row">품목코드</th>
											<td>
												<%=CommonUtil.nvl(_dataList.get("ITEM_NO"))%> (<%=CommonUtil.nvl(_dataList.get("STATUS"))%>)
											</td>
											<th scope="row">현재상품상태</th>
											<td>
												<%=CommonUtil.nvl(_dataList.get("ITEM_STATUS"))%>
											</td>
										</tr>
										<tr>
											<th scope="row">품목명</th>
											<td colspan="3">
												<%=CommonUtil.nvl(_dataList.get("DESCRIPTION"))%>
											</td>
										</tr>
										<tr>
											<th scope="row">품목규격</th>
											<td colspan="3">
												<%=CommonUtil.nvl(_dataList.get("SPECIFICATION"))%>
											</td>
										</tr>
										<tr>
											<th scope="row">제조사</th>
											<td>
												<%=CommonUtil.nvl(_dataList.get("MAKER_NAME"))%>
											</td>
											<th scope="row">모델명</th>
											<td>
												<%=CommonUtil.nvl(_dataList.get("MAKER_PART_NO"))%>
											</td>
										</tr>
										<tr>
											<th scope="row">재질</th>
											<td>
												<%=CommonUtil.nvl(_dataList.get("QUALITY"))%>
											</td>
											<th scope="row">원산지</th>
											<td>
												<%=CommonUtil.nvl(_dataList.get("ORIGIN_TEXT"))%>
											</td>
										</tr>
										<tr>
											<th scope="row">배송기간</th>
											<td>
												최소(<%=CommonUtil.nvl(_dataList.get("MIN_DELIVERY_LT"))%> )일~최대(<%=CommonUtil.nvl(_dataList.get("MAX_DELIVERY_LT"))%> )일
											</td>
											<th scope="row">제작기간</th>
											<td>
												<%=CommonUtil.nvl(_dataList.get("MAKE_LT"))%>
											</td>
										</tr>
										<tr>
											<th scope="row">최소수량</th>
											<td>
												<%=CommonUtil.nvl(String.valueOf(_dataList.get("MIN_ORDER_QTY")))%>개
											</td>
											<th scope="row">단가(원)</th>
											<td>
												<b><%=CommonUtil.nvl(String.valueOf(_dataList.get("USER_PRICE")))%></b>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<table  class="cont_t_list09"  style="width:100%">
									<colgroup>
										<col width="40%" />
										<col width="15%" />
										<col width="15%" />
										<col width="15%" />
										<col width="15%" />
									</colgroup>
									<tbody>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;">인쇄옵션</th>
											<th scope="row" style="padding:3px 10px; text-align:left;" colspan="4">수량별 제안 단가</th>
										</tr>
										<tr height="30">
											<td rowspan="2" class="left">
												<%=CommonUtil.repl(_dataList.get("PRINT_OPT_PRICE"))%>
											</td>
											<td>
												<%=CommonUtil.nvl(_dataList.get("QTY1"))%>
											</td>
											<td>
												<%=CommonUtil.nvl(_dataList.get("QTY2"))%>
											</td>
											<td>
												<%=CommonUtil.nvl(_dataList.get("QTY3"))%>
											</td>
											<td>
												<%=CommonUtil.nvl(_dataList.get("QTY4"))%>
											</td>
										</tr>
										<tr height="30">
											<td class="right">
												<%=CommonUtil.formatNumber(_dataList.get("PRICE1"),true,0,3)%>&nbsp;
											</td>
											<td class="right">
												<%=CommonUtil.formatNumber(_dataList.get("PRICE2"),true,0,3)%>&nbsp;
											</td>
											<td class="right">
												<%=CommonUtil.formatNumber(_dataList.get("PRICE3"),true,0,3)%>&nbsp;
											</td>
											<td class="right">
												<%=CommonUtil.formatNumber(_dataList.get("PRICE4"),true,0,3)%>&nbsp;
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<table  class="cont_t_list09"  style="width:100%">
									<colgroup>
										<col width="95%" />
									</colgroup>
									<tbody>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;">상세정보</th>
										</tr>
										<tr height="50">
											<td class="left">
												<%=CommonUtil.repl(_dataList.get("REMARK"))%>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="2" class="pt10">
								<h2>견적의뢰내역</h2>
								<table  class="cont_t_list09"  style="width:100%">
									<colgroup>
										<col width="10%" />
										<col width="27%" />
										<col width="13%" />
										<col width="10%" />
										<col width="20%" />
										<col width="20%" />
									</colgroup>
									<tbody>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;" colspan="2">의뢰사</th>
											<th scope="row" style="padding:3px 10px; text-align:left;">의뢰자</th>
											<th scope="row" style="padding:3px 10px; text-align:left;">의뢰일시</th>
											<th scope="row" style="padding:3px 10px; text-align:left;">연락처</th>
											<th scope="row" style="padding:3px 10px; text-align:left;">이메일</th>
										</tr>
										<tr height="30">
											<td class="left pl05" colspan="2"><%=CommonUtil.nvl(_dataList.get("ADD_COMPANY"))%></td>
											<td class="left pl05"><%=CommonUtil.nvl(_dataList.get("ADD_USER_NAME"))%></td>
											<td class="left pl05"><%=CommonUtil.formatStrinigDate(_dataList.get("ADD_DATE"))%></td>
											<td class="left pl05"><%=CommonUtil.nvl(_dataList.get("ADD_TEL_NO"))%></td>
											<td class="left pl05"><%=CommonUtil.nvl(_dataList.get("ADD_EMAIL"))%></td>
										</tr>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;">의뢰내역</th>
											<td class="left pl05" colspan="5">
												<%=CommonUtil.nvl(_dataList.get("ADD_REMARK"))%>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="2" class="pt10">
								<h2>견적처리내역</h2>
								<table  class="cont_t_list09"  style="width:100%">
									<colgroup>
										<col width="12%" />
										<col width="25%" />
										<col width="12%" />
										<col width="*" />
									</colgroup>
									<tbody>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;">처리자</th>
											<td class="left pl05">
											<%
												String recvUserName = CommonUtil.nvl(_dataList.get("USER_NAME_LOC"));
												if(recvUserName.equals("ALL")){
													recvUserName = userName;
												}
											%>
												<%=recvUserName%>
											</td>
											<th scope="row" style="padding:3px 10px; text-align:left;">처리일</th>
											<td class="left pl05">
											<%
												String recvDate = CommonUtil.formatStrinigDate(_dataList.get("RECV_DATE"));
												if(recvDate.equals("ALL")){
													recvDate = curDate;
												}
											%>
												<%=recvDate%>
											</td>
										</tr>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;">처리내역</th>
											<td class="left pl05" colspan="3">
											<%
												String recvRemark = CommonUtil.nvl(_dataList.get("RECV_REMARK")).trim();
												if(recvRemark.equals("ALL")){
													recvRemark = "";
												}
											%>
											<textarea id="st_recv_remark" name="st_recv_remark" rows="7"
												style="padding:3px;width:100%;ime-mode:active;border-width:0px;overflow:auto;background:#f8f8f8;
												scrollbar-highlight-color: #CCCCCC;
												scrollbar-shadow-color: #CCCCCC;
												scrollbar-arrow-color: #CCCCCC;
												scrollbar-face-color: #f8f8f8;
												scrollbar-3dlight-color: #f8f8f8;
												scrollbar-darkshadow-color: #f8f8f8;
												scrollbar-track-color: #f8f8f8;
												font-size: 12px; font-family:굴림,돋움,seoul,Arial; font-color:#666666; line-height:11pt"><%=recvRemark%></textarea>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
				<!-- 버튼영역 -->
				<div class="btnArea mt15">
					<div class="fl">
						<span class="btn_04">
							<a href="javascript:getPrmtitemInv();">견적서출력</a>
						</span>
					</div>
					<div class="fr">
						<span class="btn_04">
							<a href="javascript:doAction('proc');">처리</a>
						</span>
					</div>
				</div>
			</div>
			
			<!--내용 종료-->
		</div>
	</div>
</form>
</body>
</html>
