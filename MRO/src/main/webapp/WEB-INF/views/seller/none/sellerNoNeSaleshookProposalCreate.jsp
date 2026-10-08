<%--
**********************************************
* 메뉴 : HOME>판촉물제안하기>신규품목제안
* 화면 : 신규품목제안
* 기능 : 
* 프로그램 ID : 
* 담당자 : 김경례 ( 설계 :  )
* 착수일 : 2014-10-06
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script type="text/javascript">
//<!--

var popupSel = "";

//최초 화면 함수 
function kep_onload_view(){
	
	kepSetCalender('st_re_sale_date');
}

function doAction(str) {
	switch (str) {
		case "save":	 // 신규상품제안 저장
			setAgentApprovalPromote();
			break;

	}
}


//공급사 판촉물 제안 로직
function setAgentApprovalPromote() {

	if(isEmpty($("#st_description").val())) {
		alert("품목명을 입력하여 주십시요.");
		$("#st_description").focus();
		$("#st_description").val("");
		return;
	}

	if(isEmpty($("#st_specification").val())) {	
		alert("품목규격을 입력하여 주십시요.");
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
		$("#st_origin_name").focus();
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

	if(!isEmpty($("#st_remark").val())) {
		var remark = $("#st_remark").val();

		if(remark.length<=19) {
			alert("상세정보는 20자리 이상 400자 까지 작성가능합니다.");
			$("#st_remark").focus();
			return;
		}
	}

	if(confirm("작성하신 판촉물을 제안하시겠습니까?")) {
		kepAjaxFormCall("/none/saveSellerNoNeSaleshookProposal.do","searchForm","btnCreate");
	}
}


//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	if(pMethod == "btnCreate"){
		alert("정상적으로 신규상품 제안 등록 이루워졌습니다.");
		location.href = "/none/showSellerNoNeSaleshookProposal.do";

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

// 팝업 함수호출
function doPop(str, value1) {
	popupSel = str;
	
	switch (str) {
		case "country": // 원산지
			openSearchPopup("/common/countryCodePop.do", "", "500,500,no");
			break;
	}
}

function setPopupReturn(code, text, value){
	
	if (popupSel == "country") {
		$("#st_origin_name").val(value);
		$("#st_origin_code").val(code);
		
	} else if (popupSel == "fileUpload") {
		$("#st_image_key").val(code);
	}
}

function attach_popup(){		
	var type = "PROMOTE";
	var viewType = "IV";
	var image_key = $("#st_image_key").val();
	
	popupSel = "fileUpload";
	kepFileUploadOpenPopup(image_key, type, viewType); 
}

//단가 및 배송기간 숫자 체크
function displayNumbering(type, position) {
	
	var min_delivery_lt = filterNum($("#st_min_delivery_lt").val().trim());		// 최소 배송기간
	var max_delivery_lt = filterNum($("#st_max_delivery_lt").val().trim());		// 최대 배송기간

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

//-->
</script>
</head>
<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>

<div id="container2" style="margin-right: 20px;">
<!--내용 시작-->
<div id="ContArea">
	<h3>신규상품제안 등록하기</h3>
	<div id="searchBtnA">
	</div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="${param.upperId}"/>    	
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">

		<input type="hidden" name="st_detail_item_no" id="st_detail_item_no" value="">

		<table  class="cont_t_list06">
			<caption>신규상품제안 등록하기</caption>
			<colgroup>
				<col width="10%" />
				<col width="40%" />
				<col width="10%" />
				<col width="13%" />
				<col width="13%" />
				<col width="13%" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><font color="red">*</font> 품목명</th>
					<td colspan="5"><input type="text" id="st_description" name="st_description" class="input_type_text" title="품목명" maxlength="50"/></td>
				</tr>
				<tr>
					<th scope="row"><font color="red">*</font> 품목규격</th>
					<td colspan="5">
						<input type="text" id="st_specification" name="st_specification" class="input_type_text" title="품목규격" maxlength="250"/>
						<br>(작성법) 가로 * 세로*높이
						<br>- 가로 : 상품의 진영 정면을 기준으로 죄측끝에서 우측끝까지의 길이
						<br>- 세로 : 상품의 진영 정면을 기준으로 앞쪽끝에서 뒤쪽끝까지의 길이
						<br>- 높이 : 상품의 진열 정면을 기준으로 하단끝에서 상단끝까지의 길이
					</td>
				</tr>
				<tr>
					<th scope="row">모델명</th>
					<td><input type="text" id="st_maker_part_no" name="st_maker_part_no" class="input_type_text" title="모델명" maxlength="50"/></td>
					<th scope="row"><font color="red">*</font> 제조사</th>
					<td colspan="3">
						<input type="text" id="st_maker_name" name="st_maker_name" class="input_type_text" title="제조사" maxlength="40"/>
						<br>(작성법)&nbsp; 회사명이 영문인 경우 영문 대문자로 입력
						<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							(주) 또는 주식회사는 제외하고 입력
					</td>
				</tr>
				<tr>
					<th scope="row">재질</th>
					<td><input type="text" id="st_quality" name="st_quality" class="input_type_text" title="재질" maxlength="40"/></td>
					<th scope="row"><font color="red">*</font> 원산지</th>
					<td colspan="3">
						<input type="text" id="st_origin_name" name="st_origin_name" class="input_type_text" title="원산지" value="" readonly/>
						<input type="hidden" id="st_origin_code" name="st_origin_code" value="">
						
						<a href="javascript:doPop('country');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_origin_name','st_origin_code');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
				</tr>
				<tr>
					<th scope="row"><font color="red">*</font> 배송기간</th>
					<td>
						최소&nbsp;
						<input type="text" id="st_min_delivery_lt" name="st_min_delivery_lt" class="input_type_text" title="최소배송기간"  onblur="displayNumbering('MIN_DELIVERY', 0);"/>일 ~
						최대&nbsp;
						<input type="text" id="st_max_delivery_lt" name="st_max_delivery_lt" class="input_type_text" title="최대배송기간"  onblur="displayNumbering('MAX_DELIVERY', 0);"/>일
					</td>
					<th scope="row">제작기간</th>
					<td colspan="3">
						<input type="text" id="st_make_lt" name="st_make_lt" class="input_type_text" title="제작기간" maxlength="50"/>
						<br>(제작품인 경우 제작기간을 기입)
					</td>
				</tr>
				<tr>
					<th scope="row"><font color="red">*</font> 현재 상품 상태</th>
					<td>
						<select id="st_item_status" name="st_item_status">
							<option value="N">진행 가능 상품</option>
							<option value="P">단종</option>
							<option value="Q">일시품절</option>
						</select>
					</td>
					<th scope="row">재판매 가능일</th>
					<td colspan="3"><input type="text" id="st_re_sale_date" name="st_re_sale_date" size="10" class="input_type_text" value="" readonly></td>
				</tr>
				<tr>
					<th scope="row" rowspan="3">인쇄옵션 및 가격</th>
					<td rowspan="3">
						<textarea name="st_print_opt_price" rows="5" style="padding:3px;width:95%;ime-mode:active;border-width:1px;"></textarea>
					</td>
					<th scope="row">수량별 제안단가</th>
					<td colspan="3">V.A.T 별도</td>
				</tr>
				<tr>
					<td>
						<input type="text" id="st_qty1" name="st_qty1" style="width:95%" value="">
					</td>
					<td>
						<input type="text" id="st_qty_price1_text" name="st_qty_price1_text" size="10" style="text-align:right;" onblur="displayNumbering('QTY_PRICE', 1);">원
						<input type="hidden" id="st_qty_price1" name="st_qty_price1" value="">
					</td>
					<td>
						<input type="text" id="st_qty2" name="st_qty2" style="width:95%" value="">
					</td>
					<td>
						<input type="text" id="st_qty_price2_text" name="st_qty_price2_text" size="10" style="text-align:right;" onblur="displayNumbering('QTY_PRICE', 2);">원
						<input type="hidden" id="st_qty_price2" name="st_qty_price2" value="">
					</td>
				</tr>
				<tr>
					<td>
						<input type="text" id="st_qty3" name="st_qty3" style="width:95%" value="">
					</td>
					<td>
						<input type="text" id="st_qty_price3_text" name="st_qty_price3_text" size="10" style="text-align:right;" onblur="displayNumbering('QTY_PRICE', 3);">원
						<input type="hidden" id="st_qty_price3" name="st_qty_price3" value="">
					</td>
					<td>
						<input type="text" id="st_qty4" name="st_qty4" style="width:95%" value="">
					</td>
					<td>
						<input type="text" id="st_qty_price4_text" name="st_qty_price4_text" size="10" style="text-align:right;" onblur="displayNumbering('QTY_PRICE', 4);">원
						<input type="hidden" id="st_qty_price4" name="st_qty_price4" value="">
					</td>
				</tr>
				<tr>
					<th scope="row">상세정보(최소20자)</th>
					<td colspan="5">
						<textarea id="st_remark" name="st_remark" rows="7" style="padding:3px;width:95%;ime-mode:active;border-width:1px;"></textarea>
					</td>
				</tr>
				<tr>
					<th scope="row">첨부파일</th>
					<td colspan="5">
						<span class="btn_quickbuy mb02"  title="파일추가"><a href="javascript:attach_popup();">파일추가</a></span>
						<input type="hidden" id="st_image_key" name="st_image_key" value="" />
					</td>
				</tr>
			</tbody>
		</table>
		
		
		<!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fr">
				<span class="btn_04">
					<a href="javascript:doAction('save');">제안하기</a>
				</span>
				&nbsp;
				<span class="btn_04">
					<a href="/none/showSellerNoNeSaleshookProposal.do">목록으로</a>
				</span>
			</div>
		</div>
	</form>
</div>

<!--내용 종료-->
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>   
</div>
</body>
</html>
