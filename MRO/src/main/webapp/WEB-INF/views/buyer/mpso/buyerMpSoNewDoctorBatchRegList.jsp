<%--
**********************************************
* 메뉴 : 관리자>예산관리>예산편성
* 화면 : 예산편성
* 기능 : 예산관리 부서별 예산을 편성/관리할 수 있는 화면이다.
* 프로그램 ID : PG_06_B_052_00
* 담당자 : 개발2 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/include/head.jspf"%>
</head>
<body onload="kep_onload_view()">
	<div id="wrapper">
		<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp"%>
		<div id="container2">
			<c:import charEncoding="utf-8" url="/menu/menu.do">
				<c:param name="page" value="buyerLeft" />
				<c:param name="part" value="${param.upperId}" />
			</c:import>
			<c:set var="sessionInfo" value="${sessionInfo }"/>
			<c:set var="comCode" value="${sessionInfo.comCode }"/>
			<c:set var="total_cnt" value='0' />
			<c:set var="CheckDate" value='<%=CommonUtil.addDate(new Date(), "D", 1, 1) %>' />
			<c:forEach items="${data }" var="_gridList" begin="0" end="1">
				<c:set var="total_cnt" value='${_gridList.TOTNUM }' />
			</c:forEach>
			<c:set var="curPage" value='${(curPage==null)?"1":curPage }' />
			<c:set var="fromDate" value='' />
			<c:set var="toDate" value='' />
			<c:set var="st_from_date" value='${st_fromDate }' />
			<c:set var="st_to_date" value='${st_to_date }' />
			<c:if test='${st_from_date == null || st_from_date == "" }'>
				<c:set var="fromDate" value='<%=CommonUtil.addDate(new Date(), "M", -1, 1) %>' />
				<c:set var="toDate" value='<%=CommonUtil.getCurrentDay_Time("yyyyMMdd") %>' />
			</c:if>
			<jsp:useBean id="toDay" class="java.util.Date" />
			<fmt:formatDate value="${toDay}" pattern="yyyy-MM-dd" var="currDate"/>
			<fmt:formatDate value="${toDay}" pattern="yyyyMMdd" var="stCurrDate"/>

			<c:if test='${!(st_from_date == null || st_from_date == "") }'>
				<c:set var="toDate" value='${st_to_date }' />
			</c:if>
			<c:set var="rowNumber" value='0' />
			<div id="ContArea">
				<h3>신규닥터 일괄주문</h3>
<!-- 				<div id="searchBtnA"> -->
<!-- 					<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> -->
<!-- 					<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span> -->
<!-- 				</div> -->
				<form name="searchForm" id="searchForm" method="post">
					<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">
					<input type="hidden" name="curPage" id="curPage" value="${curPage }" />
					<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
					<input type="hidden" name="st_dept" id="st_dept" value="${sessionInfo.department}">
<%-- 					<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> --%>
					<input type="hidden" id="moveToMaster" name="moveToMaster" value="${moveToMaster }">
					<div id="cont_searchA">
						<table class="cont_t_list01">
							<caption>조회</caption>
							<colgroup>
								<col width="7%" />
								<col width="12%" />
								<col width="7%" />
								<col width="12%" />
								<col width="7%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th>요청일</th>
									<td>
										<input type="text" value='<c:out value="${currDate }"/>' readonly="readonly" size="10" />
										<input type="hidden" id="st_req_date" name="st_req_date" value="${stCurrDate }" />
									</td>
									<th >요청서구분</th>
									<td>
										<input type="text" value='<c:out value="지급"/>' readonly="readonly" size="8" />
										<input type="hidden" name="st_req_type" id="st_req_type" value="지급" />
									</td>
									<th >신입</th>
									<td>
										<input type="text" value='<c:out value="Y"/>' readonly="readonly" size="6" />
										<input type="hidden" name="st_new_type" id="st_new_type" value="Y" />
									</td>
									<th>지급기준</th>
									<td>
										<select id="st_status" name="st_status"  >
<!-- 											<option value="" >전체</option> -->
											<option value="NEW" selected="selected">신규</option>
<!-- 											<option value="OLD" >기존</option> -->
										</select>
									</td>
									<th>&nbsp;&nbsp;&nbsp;대상자입력</th>
									<td>
									<input type="text" id="txtMember" size="10" />
									<input type="hidden" id="txtMemberId" />
									<span id="spanName"></span>
									<a href="javascript:getReqUserSelect();" id="btnMemberBatch"><img src="/resources/images/btn_search03.gif" alt="대상자 일괄입력" /></a>
<!-- 										<input type="text" name="st_req_legacy_user_id" id="st_req_legacy_user_id" class="input_type_text" value=""/> -->
<!-- 										<a href="javascript:doPop('dept');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a> -->
<!-- 										btnMemberBatch -->
									</td>
								</tr>
							</tbody>
						</table>
					</div>
<!-- 					<br/> -->
				</form>
				<form name="contentForm" id="contentForm" method="post">
					<input type="hidden" name="curPage" id="curPage" value="${curPage }" />
					<input type="hidden" name="st_query_cart" id="st_query_cart" value="" />
					<input type="hidden" name="st_prev_url" id="st_prev_url" value="" />
					<table id="table_list" class="cont_t_list02" style="width: 100%">
						<colgroup>
							<col width="4%" />
							<col width="" />
							<col width="200px" />
<!-- 							<col width="20%" /> -->
							<col width="10%" />
							<col width="8%" />
							<col width="10%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">NO</th>
								<th scope="col">품목명</th>
								<th scope="col">사이즈</th>
								<th scope="col">대상자</th>
								<th scope="col">수량</th>
								<th scope="col">공제율(%)</th>
								<th scope="col">금액</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${data == null || fn:length(data) == 0}">
									<tr>
										<td colspan="15" align="center" height="50">
											<span>조회된 데이타가 없습니다.</span>
										</td>
									</tr>
								</c:when>
								<c:when test="${fn:length(data) > 0}">
									<c:set var="tclass" value='#FFFFFF' />
									<c:forEach items="${data}" var="_gridList" varStatus="status">
										<c:set var="total_cnt" value='${_gridList.TOTNUM }' />
										<c:set var="rowNumber" value='${status.index +1 }' />
										<c:if test='${rowNumber % 2 != 0 }' >
											<c:set var="tclass" value="#FAFAFA"/>
										</c:if>
										<c:if test='${rowNumber % 2 == 0 }' >
											<c:set var="tclass" value="#FFFFFF"/>
										</c:if>
										<tr align="center" bgcolor="${tclass }" height="25" >
											<td width="4%" title="NO" class="td02">
												<c:out value="${_gridList.NO }"/>
												<input type="hidden" name="st_no" value="${_gridList.NO - 1 }" />
												<input type="hidden" name="st_contract_no" value="${_gridList.CONTRACT_NO }" />
												<input type="hidden" name="st_contract_seq" value="${_gridList.CONTRACT_SEQ }" />
												<input type="hidden" name="st_use_flag" value="${_gridList.USE_FLAG }" />
												<input type="hidden" name="st_byit_comorg_code" value="${_gridList.BELOW_COMORG_CODE }" />
												<input type="hidden" name="st_agent" value="${_gridList.AGENT }" />
											</td>
											<td width="*" title="품목명" class="td02" style="text-align:left">
												${_gridList.DESCRIPTION }
											</td>
											<td title="사이즈" class="td02" width="10%">
												<input type="hidden" name="st_buyer_item_no" value="" />
												<select id="st_attribute" name="st_attribute" style="width: 200px" onchange="javascript:setInitItemNo()" >
													<c:forEach items="${_gridList.ITEM}" var="_itemList" varStatus="status">
														<option value="${_itemList.BUYER_ITEM_NO }" selected="selected" >${_itemList.ATTR }</option>
													</c:forEach>
												</select>
											</td>
											<td width="200px" title="대상자" class="td02">
												<input type="text" name="st_user_name" style="width:95%" maxlength="200" value="" />
												<input type="hidden" name="st_user_id"value="" />
												<input type="hidden" name="st_user_dept"value="" />
											</td>
<%-- 												<fmt:formatNumber value="${_gridList.ITEM_AMT }" pattern="###,###,##0.###"/> --%>
											<td width="10%" title="수량" class="td02">
												<input type="text" name="st_req_qty" id="st_req_qty" style="text-align:right" maxlength="200" value="1" size="4" onchange="javascript:chk_sum_price();" />개
												<br/>
												<font color="grey"><c:out value="(${_gridList.MIN_QTY }~${_gridList.MAX_QTY })"/></font>
												<input type="hidden" name="st_min_qty" value="${_gridList.MIN_QTY }" />
												<input type="hidden" name="st_max_qty" value="${_gridList.MAX_QTY }" />
											</td>
											<td width="8%" title="공제율(%)" class="td02">
												<font color="red"><b><fmt:formatNumber value="${_gridList.DEDUCT_RATE }" pattern="###,###,##0.###"/></b></font>
												<input type="hidden" name="st_deduct_rate" value="${_gridList.DEDUCT_RATE }" />
											</td>
											<td width="10%" title="금액" class="td02">
												<font color="red"><b><fmt:formatNumber value="${_gridList.UNIT_PRICE }" pattern="###,###,##0.###"/></b></font>
												<input type="hidden" name="st_unit_price" value="${_gridList.UNIT_PRICE }" />
											</td>
										</tr>
									</c:forEach>
								</c:when>
							</c:choose>
						</tbody>
					</table>
					<c:if test="${data != null && fn:length(data) > 0}">
						<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="${total_cnt }" />
					</c:if>
					<div class="fr">
						<b>총 주문 금액 </b>
						<input type="text" name="check_sum_price" id="check_sum_price" class="input_type_text" value="0" style="background-color:#FFFFFF;color:red;font-weight: bold;font-size:9pt;border:#FFFFFF 1px solid;text-align:right;" readOnly>&nbsp;
						<input type="hidden" name="st_check_sum_price" id="st_check_sum_price" value=""> 
						<input type="hidden" name="pointValue" id="pointValue" value=""> 
					</div>
					<font color="#ff4500"><b>* 주문 버튼은 한 번만 클릭해주세요. 더블 클릭 시 이중 주문됩니다.</b></font>
					<div class="btnArea ac" style="margin-bottom:0px; margin-top: 5px;"> 
						<span class="fr btn_02">
							<a href="javascript:doAction('regOrder');">주문하기</a>
						</span> 
					</div>
					<div align="center">
						<h3>
							관리품목 신청 시 유의사항
						</h3>
						<b>
							* 신청물품에 대한 취소는 담당자 휴선통화 후 가능합니다.(당일)
							<br/>
							* 주문최종 확정 후에는 취소가 불가합니다.(본사 담당자 최종 진행함)
							<br/>
							* 제품 배송처는 해당 서비스팀으로 배송됨.
							<br/>
							<font color=red>
							* 주문 최종 확정 후에는 취소가 불가합니다.(본사 담당자 최종 진행함)
							</font>
							<br/>
							* 닥터 공구 및 신청 관련 담당자 : 이영민 02-2172-1782
						</b>
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";

// 최초 화면 함수 
function kep_onload_view(){
	//조회조건 초기화(기존값 재설정)
// 	initSearchCondition("searchForm", "st_pr_no", "${param.st_pr_no }");
// 	initSearchCondition("searchForm", "st_add_user_dept_code", "${param.st_add_user_dept_code }");
// 	initSearchCondition("searchForm", "st_add_user_dept_name", "${param.st_add_user_dept_name }");
// 	initSearchCondition("searchForm", "st_req_legacy_user_id", "${param.st_req_legacy_user_id }");
// 	initSearchCondition("searchForm", "st_req_user_name", "${param.st_req_user_name }");
// 	initSearchCondition("searchForm", "st_status", "${param.st_status }");
	setInitItemNo();
// 	kepAjaxCommonTotalCombo("st_status", "M126", "", "", "CODE", "TEXT1", "");// TODO
}

var st;
//기능함수
function doAction(str) {
	var btnEvent = str;
	switch (str) {
	case "search":	 //조회
// 	 	var buyerCode = $("#st_buyer").val();
// 		if(buyerCode != null && buyerCode == ''){
// 			alert("고객사를 선택해 주십시오.");return;
// 		}
	
// 		var term = document.forms.searchForm.st_term.value;
// 		if(term == ""){
// 			alert("예산 편성기간을 선택해 주십시요");
// 			return; 
// 		}

		kepSearch($("#curPage").val());
		break;
		
	case "reload":	//초기화
		$("#st_buyer").val("none");
		$("#st_buyer_name").val("");
		$("#st_dept_code").val("none");
		$("#st_dept_name").val("");
		$("#st_term_type").val("M");
		$("#st_term").val("");
		$("#st_term_text").val("");
		
// 		kepSearch(-1);
		jspTableClean("table_list");
		break;

	case "excelDown": // 엑셀다운로드
		giExcelDownload();
		break; 

	case "regOrder": // 주문하기
		if($($("input:hidden[name=st_user_id]")[0]).val() == ''){
			alert('대상자를 입력하시기 바랍니다.');
			return;
		}
		if(!confirm("일괄주문 하시겠습니까?")){ 
			return;
		} 
// 		item_check('CART');
		kepAjaxFormCall("/mpso/setBuyerMpSoNewDoctorBatchRegList.do","contentForm","regOrder");
		break;
	}
}

// 조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoNewDoctorBatchRegList.do").submit();   
}
  
// 팝업 함수호출
var gridIndex = 0;
var grbRow = "";
function doPop(idx, str,value1, value2, value3, value4, value5) {
	popupSel = str;
	gridIndex =idx;
	
	switch (str) {
	case "icomcmpyPop":
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
		break;
	case "dept": // 요청부서
		var buyerCode = $("#st_buyer").val();
		var sessionCode = $("#st_com_code").val();
		var comCode = (buyerCode == null || buyerCode == '')? sessionCode : buyerCode  ;
		openSearchPopup("/common/deptCodeAdminPop.do", "?open=Y&com_code="+comCode, "500,500,no");
		break;
	case "commonCoCoTermChoicePop": // 기간선택
		var termType = $("#st_term_type").val();
		if(termType == 'ALL'){
			alert("기간 구분을 먼저 선택하십시오.");
			return;
		}else if(termType == 'Y'){
			termType = "year";
		}else if(termType == 'H'){
			termType = "half";
		}else if(termType == 'Q'){
			termType = "quarter";
		}else{
			termType = "month";
		}
		
		openSearchPopup("/coco/showCommonCoCoTermChoicePop.do", "?st_row=text&st_gubun_code="+termType, "500,300,no");
		break;
	case "remarkReturn2Pop": // 비고
		var remark = $("input[name=st_remark]").eq(idx).val();
		openSearchPopup("/common/remarkReturn2Pop.do", "?st_return_remark="+remark, "500,230,no");
		break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2,value3,value4,value5){
//  	alert(gridIndex+"::"+value1+"::"+value2+"::"+value3+"::"+value4+"::"+value5);
	if (popupSel == "icomcmpyPop"){
		$("#st_buyer").val(value1);
		$("#st_buyer_name").val(value2);
		$("#st_dept_code").val('');
		$("#st_dept_name").val('');
	}else if(popupSel == "remarkReturn2Pop"){
		 $("input[name=st_remark]").eq(gridIndex).val(value1);
		 if(value1 ==""){
	 		$("img[id=st_remark_img]").eq(gridIndex).attr("src",remarkOff);
	 	 }else{
	 		$("img[id=st_remark_img]").eq(gridIndex).attr("src",remarkOn);
	 	 }
	}

}

//예산금액 입력/변경
function update_price(row){
	var tot_cnt  = document.forms.contentForm.display_item_cnt.value;
	if(eval(tot_cnt) < 2){	   
		var imsi_plan_amt = $("input[name=st_plan_amt_text]").eq(row).val();// 예산금액
		var imsi_st_plan_amt = $("input[name=st_plan_amt]").eq(row).val();// 예산금액
		// 예산금액 변경시
		if( isEmpty(imsi_plan_amt) || !kepIsNumberStr(imsi_plan_amt) || (imsi_plan_amt == 0) ){
			alert("예산금액을 확인 후 다시 입력해 주십시요");
			document.forms.contentForm.st_plan_amt_text.value		= kepCommaNum(imsi_st_plan_amt);
			return;
		}
		if(imsi_plan_amt!=""){
			document.forms.contentForm.st_plan_amt_text.value		= kepCommaNum(imsi_plan_amt);
			document.forms.contentForm.st_plan_amt.value		= imsi_plan_amt;
		}
	}else{
		var imsi_plan_amt = $("input[name=st_plan_amt_text]").eq(row).val();// 예산금액
		var imsi_st_plan_amt = $("input[name=st_plan_amt]").eq(row).val();// 예산금액
		
		// 예산금액 변경시
		if( isEmpty(imsi_plan_amt) || !kepIsNumberStr(imsi_plan_amt) || (imsi_plan_amt == 0) ){
			alert("예산금액을 확인 후 다시 입력해 주십시요");
			document.forms.contentForm.st_plan_amt_text[row].value		= kepCommaNum(imsi_st_plan_amt);
			return;
		}
		if(imsi_plan_amt!=""){
			document.forms.contentForm.st_plan_amt_text[row].value		= kepCommaNum(imsi_plan_amt);
			document.forms.contentForm.st_plan_amt[row].value		= imsi_plan_amt;
		}
	}// end else

}



// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var status = response.msg.MSGTYPE;
	var msg = response.msg.MESSAGE;
	if(pMethod == 'setGrReturn'){
		if (status == "E"){
			alert("작업에 실패하였습니다. \n[" +msg+"]\n 위 메시지를 담당자에게 전달하시기 바랍니다.");
		}
		// 처리후 재조회
		kepSearch($("#curPage").val());
	} else if(pMethod == "regOrder"){
		document.forms.contentForm.st_query_cart.value = response.msg.ST_QUERY_CART;
		document.forms.contentForm.st_prev_url.value = '/mpso/getBuyerMpSoNewDoctorBatchRegList.do';
		
		$('#contentForm').attr("action", "<%=h_sslurl2%>/mpso/getBuyerMpSoDlvryInfoCowayList.do").submit();
// 	} else if(response.msg.MSG == "UPDATE_OK"){
// 		if(pMethod == "CART"){
// 			var hSslurl2 = $('#hSslurl2').val();
// 			document.forms.locationForm.st_query_cart.value = query; 
// 			document.forms.locationForm.st_verif_num.value = document.forms.searchForm.st_verif_num.value; 
// 			// alert("일반 코웨이 배송 으로 이동 PG_06_B_010_04");
// 			url = hSslurl2+"/mpso/getBuyerMpSoDlvryInfoCowayList.do";
// 			$('#locationForm').attr("action", url).submit();
// 		}
	}
	
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if(pMethod != 'excelDown')
		alert("처리중 오류가 발생 하였습니다.\n\n확인 후 다시 시도하여 주십시요");
	else {
		alert('aaa')
	}
} 
function getPrDisplayPop(BUYER,PR_NO,RECV_FLAG,VALUE2){ 
	openSearchPopup('/mpiv/showCommonMpIvOdrreqDetailPop.do','?openYn=Y&PR_NO='+PR_NO+'&RECV_FLAG='+RECV_FLAG , "800,600,no"); 
}

//팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5, value6) {
	switch (str) {
	case "dept": // 요청부서
		popupSel = "dept";
		openSearchPopup("/common/deptCodeAdminPop.do", "?open=Y&com_code="+$('#st_com_code').val(), "500,500,no");
		break;
	case "buyerMpRqDepartmentTotalPop": // 견적번호
		openSearchPopup("/mprq/showBuyerMpRqDepartmentTotalPop.do", '?st_buyer='+value1+'&st_quotation_no='+value2+'&st_revision='+value3, "950,450,no");
		break;
	case "agent": // 협력사
		openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
		break;
	case "kepManagerPop": // KeP담당자
		openSearchPopup("/common/kepManagerPop.do", "?st_user_id="+value1, "430,194,no");
		break;
	case "attach"://파일 첨부
		popupSel = "fileUpload";
		var type="RFQ";
		var viewType="R";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value1+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
		break;
	case "negoreq"://네고팝업
		popupSel = "buyerMpRqNegoReqPop";
		gridIndex = value1;
		var nego_price = $('input[name=st_btoa_nego_price2]').eq(gridIndex).val();
		var btoa_end_date = $('input[name=st_btoa_end_date2]').eq(gridIndex).val();
		var reject_remark = $('input[name=st_reject_remark2]').eq(gridIndex).val();
		openSearchPopup('/mprq/showBuyerMpRqNegoReqPop.do','?st_btoa_nego_price='+nego_price+'&st_btoa_end_date='+btoa_end_date+'&st_reject_remark='+reject_remark,'400,250,no');// 파일첨부 
		break;
	case "remark"://비고
		var viewType="R";
		var title = "ATOB";
		openSearchPopup('/common/remarkPop.do','?st_btoa_remark='+value2+'&st_atob_remark='+value1+'&viewType='+viewType+'&title='+title,'500,310,no');  
		break;
	case "getNegoView":
		openSearchPopup('/mprq/showBuyerMpRqNegoViewPop.do','?st_buyer='+value1+'&st_quotation_no='+value2+'&st_quotation_seq='+value3+'&st_revision='+value4,'800,300,no');  
		break;
	}
}
function setPopupReturn(code, text, value){
	if (popupSel == "dept") {
		$("#st_add_user_dept_code").val(code);
		$("#st_add_user_dept_name").val(text);
	} else if (popupSel == "buyerMpRqNegoReqPop") {
		$("input[name=st_btoa_nego_price2]").eq(gridIndex).val(code);
		$("input[name=st_btoa_end_date2]").eq(gridIndex).val(text);
		$("input[name=st_reject_remark2]").eq(gridIndex).val(value);
		if(code ==""){
			$("img[id=Image2]").eq(gridIndex).attr("src","/resources/images/icon2.gif");
		}else{
			$("img[id=Image2]").eq(gridIndex).attr("src","/resources/images/icon.gif");
		}
	}
}

function setGrReturn(){
	var chechboxCnt = $('input:checkbox[name="st_checkbox"]').length;
	var checkedCnt = $('input:checkbox[name="st_checkbox"]:checked').length;
	if(checkedCnt == 0){
		alert("반납하실 목록을 선택하여 주십시요. ");
		return;
	}
	var _st_ret_pr_no = $("input:hidden[name=st_ret_pr_no]");
	var _st_return_qty = $("input:text[name=st_return_qty]");
	var _st_return_remark = $("input:text[name=st_return_remark]");
	var _st_checkbox = $("input:checkbox[name=st_checkbox]");
	for(var i = 0; i < chechboxCnt; i++){
		if($(_st_checkbox[i]).is(":checked") == true){
			var ret_pr_no = $(_st_ret_pr_no[i]).val();
			var return_qty = $(_st_return_qty[i]).val();
			var return_remark = $(_st_return_remark[i]).val();
			if(ret_pr_no != ""){
				alert("이미 반납하신 이력이 있어 반납이 불가합니다.");
				return;
			}
			if(return_qty == "" || return_qty == "0"){
				alert("반납수량을 입력하여 주십시오.");
				$(_st_return_qty[i]).focus();
				return;
			}
			if(return_remark == ""){
				alert("반납사유를 입력하여 주십시오.");
				$(_st_return_remark[i]).focus();
				return;
			}
		}
	}
	if(!confirm("선택한 목록을 반납 하시겠습니까?  ")) {
		return;
	}else{
		kepAjaxFormCall("/mpso/saveBuyerMpSoDelyReturnCowayList.do","contentForm",'setGrReturn');
	}
}
//선택 품목 총 합계금액
function chk_sum_price(){
	var _st_req_qty = $("input:text[name=st_req_qty]");
	var _st_deduct_rate = $("input:hidden[name=st_deduct_rate]");
	var _st_unit_price = $("input:hidden[name=st_unit_price]");
	var stReqQtyCnt = $("input:text[name=st_req_qty]").length;
	var sumPrice = 0;
	for(var i = 0; i < stReqQtyCnt; i++){
		var st_req_qty = $(_st_req_qty[i]).val();
		var st_deduct_rate = $(_st_deduct_rate[i]).val();
		var st_unit_price = $(_st_unit_price[i]).val();
		if(!kepIsNumberStr(st_req_qty)){
			alert(i+1+'번째 행의 수량은 숫자형식만 입력가능합니다.');
			$(_st_req_qty[i]).focus();
			return;
		}
		sumPrice += eval(st_req_qty)*eval(st_unit_price)*eval(100-st_deduct_rate)/100;
	}
	document.forms.contentForm.check_sum_price.value = kepCommaNum(sumPrice) + " 원";
	document.forms.contentForm.st_check_sum_price.value = sumPrice;
}

function setInitItemNo(){
	var _st_buyer_item_no = $("input:hidden[name=st_buyer_item_no]");
	var _st_attribute = $("select[name=st_attribute]");
	var stBuyerItemNoCnt = $("input:hidden[name=st_buyer_item_no]").length;
	for(var i = 0; i < stBuyerItemNoCnt; i++){
		$(_st_buyer_item_no[i]).val($(_st_attribute[i]).val());
	}
}

//대상자선택
function getReqUserSelect(popRow){
	getUserSelect('${comCode }');
}

//대상자셋팅
function setUserSelect(user_id, user_name, phone_number, email, dept, dept_name, address_loc, fax_number, legacy_user_id, mobile_phone){
	var member = user_name;
	var memberId = user_id;
	var memberDept = dept;
	var stUserNameCnt = $("input:text[name=st_user_name]").length;
	var _st_user_name = $("input:text[name=st_user_name]");
	var _st_user_id = $("input:hidden[name=st_user_id]");
	var _st_user_dept = $("input:hidden[name=_st_user_dept]");
	for(var i = 0; i < stUserNameCnt; i++){
		$(_st_user_name[i]).val(member);
		$(_st_user_id[i]).val(memberId);
		$(_st_user_dept[i]).val(memberDept);
	}
	chk_sum_price();
}
function getUserSelect(buyer){
	popupSel = "USER";
	openSearchPopup('/common/misUserSelectAllPop.do', '?open=Y&com_code='+buyer , "500,500,no");
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11,value12,value13,value14,value15,value16){
	if (popupSel == "USER") {	// 사용자
		setUserSelect(value1, value2, value3);
	} 
} 
</script>
</html>
