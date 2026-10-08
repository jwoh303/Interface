<%--
**********************************************
* 메뉴 : 
* 화면 : 상품정보 상세 및 수정
* 기능 : 
* 프로그램 ID : PG_03_M_007_01
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

var popupSel = "";

function doAction(str) {

	switch (str) {
		case "modify":	 // 조회
			setModifyCatalogPromote();
			break;
		
		case "print": // 견적서출력
			
			var param = "<%=itemNo%>@@";
			var fileName = "RD_09_A_001_00"; // RD_ID
			
			reportOpen(fileName,param);
	
			break;
			
	}

}

//팝업호출
function doPop(str, value1, value2, value3, value4) {
	popupSel = str ;
	
	switch (str) {
		case "agent_single": // 협력사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			popupSel = "agent_single";
			break;
			
		case "country": // 원산지
			openSearchPopup("/common/countryCodePop.do", "", "500,500,no");
			break;
			
		case "masterMdCmPromotionMarketCatalogSelPop": // 판촉물전용마켓 카테고리 선택팝업
			popupSel = "masterMdCmPromotionMarketCatalogSelPop";
			openSearchPopup('/mdcm/showMasterMdCmPromotionMarketCatalogSelPop.do','','528,510,no');
			break;
			
		case "attach"://파일 첨부
			popupSel = "fileUpload";
			var type="RFQ";
			var viewType="R";
			openSearchPopup("/common/fileUploadPop.do", '?DOC_NO='+value1+'&TYPE='+type+'&viewType='+viewType, "500,430,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "agent_single"){ // 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
		
	} else if (popupSel == "country") {
		$("#st_origin_name").val(value3);
		$("#st_origin_code").val(value1);
		
	}else if (popupSel == "masterMdCmPromotionMarketCatalogSelPop") {	// 판촉물전용마켓 카테고리 선택팝업

		$("#st_categ_id").val(value1);
		$("#st_categ_type").val(value2);
		$("#st_category_path").val(value3);
		
		//표준카테고리 선택에 따른 속성 조회조건 추가
		//setSysopKssCategorySearch(value3, value5);
	}
}

//삭제 및 반려 처리
function getProcessCatalogStatus(app) {

	var confirm_msg = "";
	
	if(app=="DELETE") {
	
		if(isEmpty($("#st_d_remark").val())) {
			alert("삭제사유를 입력하여 주십시요.");
			$("#st_d_remark").focus();
			$("#st_d_remark").val("");
			return;
		}
		
		confirm_msg = "선택하신 판촉물을 삭제하시겠습니까?";
		$("#st_status").val("D");
	
	} else if(app=="NO_ACCEPT") {
	
		if(isEmpty($("#st_b_remark").val())) {
		
			alert("반려사유를 입력하여 주십시요.");
			$("#st_b_remark").focus();
			$("#st_b_remark").val();
			return;
			
		}
		
		confirm_msg = "선택하신 판촉물을 반려하시겠습니까?";
		$("#st_status").val("B");
		
	} else if(app=="RECOMMAND") {
		confirm_msg = "해당 판촉물을 추천상품으로 지정하시겠습니까?";
		$("#st_status").val("V");
		
	} else if(app=="PLAN") {
		confirm_msg = "해당 판촉물을 기획상품으로 지정하시겠습니까?";
		$("#st_item_flag").val("G");
		
	} else if(app=="KEEP") {
		confirm_msg = "해당 판촉물을 보관 하시겠습니까?";
		$("#st_status").val("A");
		
	} else {
		confirm_msg = "해당 판촉물을 승인하시겠습니까?";
		$("#st_status").val("C");
	}
	
	if(confirm(confirm_msg)) {
	
		$("#st_process_mode").val(app);
		
		kepAjaxFormCall("/mdcm/saveMasterMdCmItemDetailInfoDeleteNotAccept.do","masterMdCmItemDetailInfoModifyPop","btnProc");
		
		/*
		document.f1.target = "work";
		document.f1.method = "post";
		document.f1.action = "/kr/promote/promote_master_catalog_delete_notaccept_reg.jsp";
		document.f1.submit();
		*/
	}
}

//공급사 판촉물 제안 수정 로직
function setModifyCatalogPromote() {
	
	if(isEmpty($("#st_categ_id").val())){ //|| isEmpty($("#st_category_path").val())) {
		alert("카테고리를 지정하여 주십시요.");
		return;
	}
	
	if(isEmpty($("#st_description").val())) {
		
		alert("상품명을 입력하여 주십시요.");
		$("#st_description").focus();
		$("#st_description").val("");
		return;
		
	}
	
	if(isEmpty($("#st_specification").val())) {
	
		alert("규격을 입력하여 주십시요.");
		$("#st_specification").focus();
		$("#st_specification").val("");
		return;
	
	}
	
	if(isEmpty($("#st_maker_name").val())) {
	
		alert("제조사를 입력하여 주십시요.");
		$("#st_maker_name").focus();
		$("#st_maker_name").val("");
		return;
	
	}
	
	if(isEmpty($("#st_origin_code").val())) {
	
		alert("원산지를 입력하여 주십시요.");
		$("#st_origin_name_text").focus();
		return;
	
	}
	
	if(!IsNumber1($("#st_min_delivery_lt").val())) {
	
		alert("최소 배송기간을 숫자(0~9) 형태로 입력하여 주십시요.");
		$("#st_min_delivery_lt").focus();
		$("#st_min_delivery_lt").val("");
		return;
	
	}
	
	if(!IsNumber1($("#st_max_delivery_lt").val())) {
		alert("최대 배송기간을 숫자(0~9) 형태로 입력하여 주십시요.");
		$("#st_max_delivery_lt").focus();
		$("#st_max_delivery_lt").val("");
		return;
	}
	
	if(!chkDecimal($("#st_user_price").val(), 2)) {
	
		alert("단가를 숫자형태로 입력하여 주십시요.\n\n(단, 소수점은 2자리까지 허용됩니다.)");
		$("#st_user_price").val("");
		return;
	
	}
	
	if(!chkDecimal($("#st_min_order_qty").val(), 2)) {
	
		alert("최소주문수량을 숫자형태로 입력하여 주십시요.\n\n(단, 소수점은 2자리까지 허용됩니다.)");
		$("#st_min_order_qty").val("");
	return;
	
	}
	
	if(!isEmpty($("#st_remark").val())) {
		var remark = $("#st_remark").val();
		
		if(remark.length<=19) {
			alert("상세정보는 20자리 이상 400자 까지 작성가능합니다.");
			$("#st_remark").focus();
			return;
		}
	}
	
	if(confirm("작성하신 판촉물을 수정하시겠습니까?")) {
		
		kepAjaxFormCall("/mdcm/saveMasterMdCmItemDetailInfoModifyPop.do","masterMdCmItemDetailInfoModifyPop","btnModify");
		
		/*
		document.f1.target="work";
		document.f1.method="post";
		document.f1.action="/kr/promote/promote_master_catalog_modify_reg.jsp";
		document.f1.submit();
		*/
	}
}


//단가 및 배송기간 숫자 체크
function displayNumbering(type, position) {
	
	var min_delivery_lt = filterNum($("#st_min_delivery_lt").val().trim());		// 최소 배송기간
	var max_delivery_lt = filterNum($("#st_max_delivery_lt").val().trim());		// 최대 배송기간
	var min_order_qty	= filterNum($("#st_min_order_qty_text").val().trim());	// 최소주문수량
	var user_price		= filterNum($("#st_user_price_text").val().trim());		// 단가
	
	if(type=="MIN_DELIVERY") {
		if(!IsNumber1(min_delivery_lt)) {
			alert("최소 배송기간을 숫자(0~9) 형태로 입력하여 주십시요.");
			$("#st_min_delivery_lt").val("");
			$("#st_min_delivery_lt").focus();
			return;
		}
	} else if(type=="MAX_DELIVERY") {
		if(!IsNumber1(max_delivery_lt)) {
			alert("최대 배송기간을 숫자(0~9) 형태로 입력하여 주십시요.");
			$("#st_max_delivery_lt").val("");
			$("#st_max_delivery_lt").focus();
			return;
		}
	} else if(type=="MIN_ORDER_QTY") {
		if(!chkDecimal(min_order_qty, 2)) {
			alert("최소주문수량을 숫자형태로 입력하여 주십시요.");
			$("#st_min_order_qty_text").val("");
			$("#st_min_order_qty").val("");
			$("#st_min_order_qty_text").focus();
			return;
		}
		
		if(min_order_qty != "") {
			var qty_price_text = kepCommaNum(min_order_qty);
			
			$("#st_min_order_qty").val(min_order_qty);
			$("#st_min_order_qty_text").val(qty_price_text);
		}
	} else if(type=="USER_PRICE") {
		if(!chkDecimal(user_price, 2)) {
			alert("단가를 숫자형태로 입력하여 주십시요.");
			$("#st_user_price_text").val("");
			$("#st_user_price").val("");
			$("#st_user_price_text").focus();
			return;
		}
		
		if(user_price != "") {
			var user_price_text = kepCommaNum(user_price);
			
			$("#st_user_price").val(user_price);
			$("#st_user_price_text").val(user_price_text);
		}
		
	} else if(type=="QTY_PRICE") {
		for(var i=1; i<=4; i++) {
			if(position==i) {
				
				var qty_price = filterNum($("#st_qty_price"+i+"_text").val().trim());
				
				if(!isEmpty(qty_price)) {

					if(!chkDecimal(qty_price, 5)) {
						alert("수량별 단가를 숫자형태로 입력하여 주십시요.");
						$("#st_qty_price"+i+"_text").val("");
						$("#st_qty_price"+i+"_text").focus();
						return;
					}
					
					if(qty_price != "") {
						
						qty_price_text = kepCommaNum(qty_price);
						
						switch(i) {
							case 1:
								$("#st_qty_price1").val(qty_price);
								$("#st_qty_price1_text").val(qty_price_text);
								break;
							case 2:
								$("#st_qty_price2").val(qty_price);
								$("#st_qty_price2_text").val(qty_price_text);
								break;
							case 3:
								$("#st_qty_price3").val(qty_price);
								$("#st_qty_price3_text").val(qty_price_text);
								break;
							case 4:
								$("#st_qty_price4").val(qty_price);
								$("#st_qty_price4_text").val(qty_price_text);
								break;
						}
					}
				}
			}
		}
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	if(pMethod == "btnModify"){
		
		alert("정상적으로 처리완료되었습니다.");
		self.close();
		opener.doAction("search");
		//location.href = "/none/showSellerNoNeSaleshookProposal.do";

	}
	
	if(pMethod == "btnProc"){
		
		alert("정상적으로 처리완료되었습니다.");
		self.close();
		opener.doAction("search");
		
		//location.href = "/none/showSellerNoNeSaleshookProposal.do";


	}
	
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


 //-->
</script> 
<body>
<form name="masterMdCmItemDetailInfoModifyPop" id="masterMdCmItemDetailInfoModifyPop" method=post >
	<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
	<input type="hidden" id="st_process_mode" name="st_process_mode" value="">
	<input type="hidden" id="st_item_no" name="st_item_no" value="<%=itemNo%>">
	
	<input type="hidden" id="st_status" name="st_status" value="">
	<input type="hidden" id="st_item_flag" name="st_item_flag" value="">
	
		
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:544px;">
    	<div id="popHeader">
        	<h1 class="title">상품정보 상세 및 수정</h1>
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
							<td>
								<table  class="cont_t_list09">
									<colgroup>
										<col width="10%" />
										<col width="20%" />
										<col width="15%" />
										<col width="20%" />
										<col width="10%" />
										<col width="20%" />
									</colgroup>
									<tbody>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;">카테고리</th>
											<td colspan="3" class="left">
												<input type="text" id="st_category_path" name="st_category_path" value="<%=CommonUtil.nvl(_dataList.get("CATEG_PATH"))%>" class="input_type_text" style="width:75%" readonly>
												<a href="javascript:doPop('masterMdCmPromotionMarketCatalogSelPop');"><img src="/resources/images/btn_search03.gif"></a>
												<a href="javascript:kepEraser('st_categ_id','st_category_path');"><img src="/resources/images/btn_eraser2.gif"></a>
												<input type="hidden" id="st_categ_id" name="st_categ_id" value = "<%=CommonUtil.nvl(_dataList.get("CATEGORY_NO"))%>">
												<input type="hidden" id="st_categ_type" name="st_categ_type" value = "">
												
											</td>
											<th scope="row" style="padding:3px 10px; text-align:left;">상태</th>
											<td class="left">
												<%=CommonUtil.nvl(_dataList.get("STATUS"))%>&nbsp;/&nbsp;<%=CommonUtil.nvl(_dataList.get("GUBUN"))%>
											</td>
										</tr>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;">품목코드</th>
											<td class="left">
												<%=CommonUtil.nvl(_dataList.get("ITEM_NO"))%>
											</td>
											<th scope="row" style="padding:3px 10px; text-align:left;">제안일/수정일</th>
											<td class="left">
												<%=CommonUtil.formatStrinigDate(_dataList.get("ADD_DATE"))%>&nbsp;||&nbsp;<%=CommonUtil.formatStrinigDate(_dataList.get("CHANGE_DATE"))%>
											</td>
											<th scope="row" style="padding:3px 10px; text-align:left;">품목상태</th>
											<td class="left">
												<select id="st_item_status" name="st_item_status">
													<option value="N" <%=CommonUtil.nvl(_dataList.get("ITEM_STATUS")).equals("N") ? "selected" : ""%>>주문가능상품</option>
													<option value="Q" <%=CommonUtil.nvl(_dataList.get("ITEM_STATUS")).equals("Q") ? "selected" : ""%>>일시품절</option>
													<option value="P" <%=CommonUtil.nvl(_dataList.get("ITEM_STATUS")).equals("P") ? "selected" : ""%>>단종</option>
												</select>
											</td>
										</tr>
										<tr height="30">
											<td colspan="2" rowspan="7">
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
											<th scope="row" style="padding:3px 10px; text-align:left;">협력사</th>
											<td class="left">
												<input type="text" id="st_agent_name" name="st_agent_name" class="input_type_text" style="width:60%" value="<%=CommonUtil.nvl(_dataList.get("AGENT_NAME"))%>" readonly>
												<input type="hidden" id="st_agent_code" name="st_agent_code" value="<%=CommonUtil.nvl(_dataList.get("AGENT"))%>">
												<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
												<a href="javascript:kepEraser('st_agent_name','st_agent_code');"><img src="/resources/images/btn_eraser2.gif"></a>
											</td>
											<th scope="row" style="padding:3px 10px; text-align:left;">원산지</th>
											<td class="left">
												<input type="text" id="st_origin_name" name="st_origin_name" class="input_type_text" style="width:60%" value="<%=CommonUtil.nvl(_dataList.get("ORIGIN_TEXT"))%>" readonly>
												<input type="hidden" id="st_origin_code" name="st_origin_code" value="<%=CommonUtil.nvl(_dataList.get("ORIGIN_CODE"))%>">
												
												<a href="javascript:doPop('country');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
												<a href="javascript:kepEraser('st_origin_name','st_origin_code');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
											</td>
										</tr>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;">품목명</th>
											<td class="left" colspan="3">
												<input type="text" id="st_description" name="st_description" class="input_type_text" style="width:90%" value="<%=CommonUtil.nvl(_dataList.get("DESCRIPTION"))%>">
											</td>
										</tr>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;">품목규격</th>
											<td class="left" colspan="3">
												<input type="text" id="st_specification" name="st_specification" class="input_type_text" style="width:90%" value="<%=CommonUtil.nvl(_dataList.get("SPECIFICATION"))%>">
											</td>
										</tr>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;">제조사</th>
											<td class="left">
												<input type="text" id="st_maker_name" name="st_maker_name" class="input_type_text" style="width:90%" value="<%=CommonUtil.nvl(_dataList.get("MAKER_NAME"))%>">
											</td>
											<th scope="row" style="padding:3px 10px; text-align:left;">모델명</th>
											<td class="left">
												<input type="text" id="st_maker_part_no" name="st_maker_part_no" class="input_type_text" style="width:90%" value="<%=CommonUtil.nvl(_dataList.get("MAKER_PART_NO"))%>">
											</td>
										</tr>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;">재질</th>
											<td class="left">
												<input type="text" id="st_quality" name="st_quality" class="input_type_text" style="width:90%" value="<%=CommonUtil.nvl(_dataList.get("QUALITY"))%>">
											</td>
											<th scope="row" style="padding:3px 10px; text-align:left;">제작기간</th>
											<td class="left">
												<input type="text" id="st_make_lt" name="st_make_lt" class="input_type_text" style="width:90%" value="<%=CommonUtil.nvl(_dataList.get("MAKE_LT"))%>">
											</td>
										</tr>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;">배송기간</th>
											<td class="left">
												<input type="text" id="st_min_delivery_lt" name="st_min_delivery_lt" class="input_type_text" style="width:20%" value="<%=CommonUtil.nvl(_dataList.get("MIN_DELIVERY_LT"))%>" onblur="displayNumbering('MIN_DELIVERY', 0);">일 ~ 최대
												<input type="text" id="st_max_delivery_lt" name="st_max_delivery_lt" class="input_type_text" style="width:20%" value="<%=CommonUtil.nvl(_dataList.get("MAX_DELIVERY_LT"))%>" onblur="displayNumbering('MAX_DELIVERY', 0);">일
											</td>
											<th scope="row" style="padding:3px 10px; text-align:left;">최소수량</th>
											<td class="left">
												<input type="text" id="st_min_order_qty_text" name="st_min_order_qty_text" class="input_type_text" style="width:80%" value="<%=CommonUtil.nvl(_dataList.get("MIN_ORDER_QTY"))%>" onblur="displayNumbering('MIN_ORDER_QTY', 0);">개
												<input type="hidden" id="st_min_order_qty" name="st_min_order_qty" value="<%=CommonUtil.nvl(_dataList.get("MIN_ORDER_QTY"))%>">
											</td>
										</tr>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;">제안단가표</th>
											<td class="left">
												V.A.T 별도 
											</td>
											<th scope="row" style="padding:3px 10px; text-align:left;">단가</th>
											<td class="left">
												<input type="text" id="st_user_price_text" name="st_user_price_text" class="input_type_text"style="width:80%" value="<%=CommonUtil.nvl(_dataList.get("USER_PRICE"))%>"  onblur="displayNumbering('USER_PRICE', 0);">원
												<input type="hidden" id="st_user_price" name="st_user_price" value="<%=CommonUtil.nvl(_dataList.get("USER_PRICE"))%>">
											</td>
										</tr>
										<tr height="30">
											<th rowspan="2" scope="row" style="padding:3px 10px; text-align:left;">인쇄옵션 및 가격</th>
											<td rowspan="2" class="left">
												<textarea id="st_print_opt_price" name="st_print_opt_price" rows="4" style="padding:3px;width:100%;ime-mode:active;border-width:1px;"><%=CommonUtil.nvl(_dataList.get("PRINT_OPT_PRICE"))%></textarea>
											</td>
											<td>
												<input type="text" id="st_qty1" name="st_qty1" class="input_type_text" style="width:80%" value="<%=CommonUtil.nvl(_dataList.get("QTY1"))%>">
											</td>
											<td>
												<input type="text" id="st_qty_price1_text" name="st_qty_price1_text" class="input_type_text" style="width:80%" value="<%=CommonUtil.formatNumber(_dataList.get("PRICE1"),true,0,3)%>" onblur="displayNumbering('QTY_PRICE', 1);">원
												<input type="hidden" id="st_qty_price1" name="st_qty_price1" value="<%=CommonUtil.nvl(_dataList.get("PRICE1"))%>">
											</td>
											<td>
												<input type="text" id="st_qty2" name="st_qty2" class="input_type_text" style="width:80%" value="<%=CommonUtil.nvl(_dataList.get("QTY2"))%>">
											</td>
											<td>
												<input type="text" id="st_qty_price2_text" name="st_qty_price2_text" class="input_type_text" style="width:80%" value="<%=CommonUtil.formatNumber(_dataList.get("PRICE2"),true,0,3)%>" onblur="displayNumbering('QTY_PRICE', 2);">원
												<input type="hidden" id="st_qty_price2" name="st_qty_price2" value="<%=CommonUtil.nvl(_dataList.get("PRICE2"))%>">
											</td>
										</tr>
										<tr height="30">
											<td>
												<input type="text" id="st_qty3" name="st_qty3" class="input_type_text" style="width:80%" value="<%=CommonUtil.nvl(_dataList.get("QTY3"))%>">
											</td>
											<td>
												<input type="text" id="st_qty_price3_text" name="st_qty_price3_text" class="input_type_text" style="width:80%" value="<%=CommonUtil.formatNumber(_dataList.get("PRICE3"),true,0,3)%>" onblur="displayNumbering('QTY_PRICE', 3);">원
												<input type="hidden" id="st_qty_price3" name="st_qty_price3" value="<%=CommonUtil.nvl(_dataList.get("PRICE3"))%>">
											</td>
											<td>
												<input type="text" id="st_qty4" name="st_qty4" class="input_type_text" style="width:80%" value="<%=CommonUtil.nvl(_dataList.get("QTY4"))%>">
											</td>
											<td>
												<input type="text" id="st_qty_price4_text" name="st_qty_price4_text" class="input_type_text" style="width:80%" value="<%=CommonUtil.formatNumber(_dataList.get("PRICE4"),true,0,3)%>" onblur="displayNumbering('QTY_PRICE', 4);">원
												<input type="hidden" id="st_qty_price4" name="st_qty_price4" value="<%=CommonUtil.nvl(_dataList.get("PRICE4"))%>">
											</td>
										</tr>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;">첨부파일</th>
											<td colspan="5" class="left">&nbsp;&nbsp;
												<%
													if (("").equals(CommonUtil.nvl(_dataList.get("IMAGE_KEY")))) {
												%>
														<img name = "st_image_key_img" src="/resources/images/disk_off.gif" border="0">
												<%
													}else{
												%>
														<a class="hyperLink" href="javascript:doPop('attach', '<%=CommonUtil.nvl(_dataList.get("IMAGE_KEY"))%>')">
															<img name = "st_image_key_img" src="/resources/images/disk_on.gif" border="0">
														</a>
												<%
													}
												%>
											</td>
										</tr>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;">상세정보</th>
											<td colspan="5" class="left">
												<textarea id="st_remark" name="st_remark" rows="5" style="padding:3px;width:95%;ime-mode:active;border-width:1px;"><%=CommonUtil.nvl(_dataList.get("REMARK")).trim()%></textarea>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<td>
							<!-- 버튼영역 -->
								<div class="btnArea mt05" style="margin-bottom:5px;">
									<div class="fl">
										<span class="btn_04">
											<a href="javascript:javascript:doAction('print');">견적서출력</a>
										</span>
									</div>
									<div class="fr">
										<span class="btn_02">
											<a href="javascript:getProcessCatalogStatus('ACCEPT');">게시</a>
										</span>
										<span class="btn_02">
											<a href="javascript:getProcessCatalogStatus('KEEP');">보관</a>
										</span>
										<span class="btn_02">
											<a href="javascript:getProcessCatalogStatus('RECOMMAND');">추천상품</a>
										</span>
										<span class="btn_02">
											<a href="javascript:getProcessCatalogStatus('PLAN');">기획</a>
										</span>
										<span class="btn_02">
											<a href="javascript:doAction('modify');">수정</a>
										</span>
										
										<span class="btn_02">
											<a href="javascript:getProcessCatalogStatus('DELETE');">삭제</a>
										</span>
										<span class="btn_02">
											<a href="javascript:getProcessCatalogStatus('NO_ACCEPT');">반려</a>
										</span>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<table  class="cont_t_list09"  style="width:100%">
									<colgroup>
										<col width="12%" />
										<col width="*" />
									</colgroup>
									<tbody>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;">삭제사유</th>
											<td class="left pl05">
												<textarea  id="st_d_remark" name="st_d_remark" rows="4" style="padding:3px;width:95%;ime-mode:active;border-width:1px;"><%=CommonUtil.nvl(_dataList.get("D_REMARK")).trim()%></textarea>
											</td>
										</tr>
										<tr height="30">
											<th scope="row" style="padding:3px 10px; text-align:left;">반려사유</th>
											<td class="left pl05" colspan="3">
												<textarea id="st_b_remark" name="st_b_remark" rows="4" style="padding:3px;width:95%;ime-mode:active;border-width:1px;"><%=CommonUtil.nvl(_dataList.get("B_REMARK")).trim()%></textarea>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!--내용 종료-->
    	</div>        
	</div>
</form> 
</body>
</html>
