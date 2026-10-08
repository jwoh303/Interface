<%--
**********************************************
* 메뉴 : 주문관리 > 명절선물세트신청
* 화면 : 명절선물세트신청
* 기능 : 명절선물세트신청
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 2015-08-27
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String buyer             = "";
	String userType 		 = "";
	String userID 		     = "";
	String userName 		 = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){
		buyer             = sessionInfo.getComCode();
		userType         = sessionInfo.getUserType();
	    userID            = sessionInfo.getUserId();
	    userName          = sessionInfo.getUserNameLoc();
	}
	
	boolean p060000058= CommonUtil.getSpecialCheckReturn(buyer,"P06-0000058");
	//getCodeC007Text W 권한 체크
	String getCodeC007Text = CommonUtil.getCode2TextReturn("C007",userID,buyer,"TEXT1");

%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/include/head.jspf"%>
</head>
<body onload="kep_onload_view()">
	<div id="wrapper">
		<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp"%>
		
			<c:import charEncoding="utf-8" url="/menu/menu.do">
				<c:param name="page" value="buyerLeft" />
				<c:param name="part" value="${param.upperId}" />
			</c:import>
			<c:set var="sessionInfo" value="${sessionInfo }"/>
			<c:set var="comCode" value="${sessionInfo.comCode }"/>
			<c:set var="CheckDate" value='<%=CommonUtil.addDate(new Date(), "D", 1, 1) %>' />
			<c:forEach items="${data }" var="_gridList" begin="0" end="1">
				<c:set var="total_cnt" value='${_gridList.TOTNUM }' />
			</c:forEach>
			<c:set var="curPage" value='${(curPage==null)?"1":curPage }' />
			<c:set var="fromDate" value='' />
			<c:set var="toDate" value='' />
			<c:set var="st_from_date" value='${st_fromDate }' />
			<c:set var="st_to_date" value='${st_to_date }' />
			<c:set var="realImgUploadPath" value='<%=CommonUtil.realImgS3UploadPath %>'/>
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
			<div id="container2">
			<div id="ContArea">
				<h3>명절선물리스트</h3>
				<form name="searchForm" id="searchForm" method="post">
					<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">
					<input type="hidden" name="curPage" id="curPage" value="${curPage }" />
					<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
					<input type="hidden" name="st_dept" id="st_dept" value="${sessionInfo.department}">
					<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
					<input type="hidden" id="moveToMaster" name="moveToMaster" value="${moveToMaster }">
				</form>
				<form name="contentForm" id="contentForm" method="post">
					<input type="hidden" name="curPage" id="curPage" value="${curPage }" />
					<input type="hidden" name="st_query_cart" id="st_query_cart" value="" />
					<input type="hidden" name="st_prev_url" id="st_prev_url" value="" />
					<table id="table_list" class="cont_t_list02" style="width: 100%">
						<colgroup>
							<col width="5%" />
							<col width="15%" />
							<col width="20%" />
							<col width="10%" />
							<col width="*"/>
							<col width="8%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">선택</th>
								<th scope="col">상품</th>
								<th scope="col">상품명</th>
								<th scope="col">대상자</th>
								<th scope="col">규격</th>
								<th scope="col">수량</th>
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
											<td width="5%" title="선택" class="td02">
												<input type="checkbox" name="st_checkbox"  value="${_gridList.RN-1 }" onclick="javascript:chk_sum_price()"/>
												<input type="hidden" name="st_no" value="${_gridList.RN - 1 }" />
												<input type="hidden" name="st_contract_no" value="${_gridList.CONTRACT_NO }" />
												<input type="hidden" name="st_contract_seq" value="${_gridList.CONTRACT_SEQ }" />
												<input type="hidden" name="st_use_flag" value="${_gridList.USE_FLAG }" />
												<input type="hidden" name="st_byit_comorg_code" value="${_gridList.BELOW_COMORG_CODE }" />
												<input type="hidden" name="st_agent" value="${_gridList.AGENT }" />
												<input type="hidden" name="st_ref_pr_no" id="st_ref_pr_no" value="<%=userID%>">
											</td>
											<td width="*" title="상품" class="td02" style="text-align:center">
												<c:if test='${_gridList.IMGFILE_DIR != null }'> 
													<a href="javascript:getBigImage('${_gridList.IMGFILE_DIR }','${_gridList.IMGFILE_NAME }');">
														<img src='${realImgUploadPath }/${_gridList.IMGFILE_DIR }/${_gridList.IMGFILE_NAME }' onerror="javasrcipt:this.src='/resources/images/noimage.gif'" name="image1" width="160" height="160" border="0">
													</a>
												</c:if>
											<c:if test='${_gridList.IMGFILE_DIR == null }'>
												<img src="/resources/images/noimage.gif" width="160" height="160" border="0">
											</c:if>
											</td>
											<td width="* title="상품명" class="td02" style="text-align:left">
												${_gridList.DESCRIPTION }
											</td>
										<td>
											<div title="대상자" class="TextNomal">
<%-- 												<input type="text" name="st_ref_pr_no" id="st_ref_pr_no" size="13" value="${_gridList.REF_PR_NO }" style="text-align:left" readOnly> --%>
                <%if(p060000058==true&&userType.equals("U")){
                %>
												<input type="hidden" name="st_ref_pr_no1" id="st_ref_pr_no1" value="<%=userID%>">
												<input type='text' name='req_user_name' id='req_user_name' size="13" value="<%=userName%>" style="text-align:left" readOnly/>
												&nbsp;
                <%}else{ %>
												<input type="hidden" name="st_ref_pr_no1" id="st_ref_pr_no1" value="" >
												<input type='text' name='req_user_name' id='req_user_name' size="13" value="" style="text-align:left" readOnly/>
												&nbsp;
                <%} %>
  												<a href="javascript:getReqUserSelect('${_gridList.RN }');">
													<img src="/resources/images/but_query.gif" width="19" height="19">
												</a>
											</div>
										</td>
											<td title="규격" class="td02" width="*"  style="text-align:left">
												<input type="hidden" name="st_buyer_item_no" value="${_gridList.BUYER_ITEM_NO }" />
													${_gridList.SPECIFICATION }
											</td>
											<td width="10%" title="수량" class="td02">
												<input type="text" name="st_req_qty" id="st_req_qty" style="text-align:right; border:0px solid #000;" maxlength="200" value="1" size="4" onchange="javascript:chk_sum_price();" readOnly/> 개
												<br/>
												<font color="red"><b><fmt:formatNumber value="${_gridList.UNIT_PRICE }" pattern="###,###,##0.###"/></b>원</font>
												<input type="hidden" name="st_unit_price" value="${_gridList.UNIT_PRICE }" />
											</td>
										</tr>
									</c:forEach>
								</c:when>
							</c:choose>
						</tbody>
					</table>
					<c:if test="${data != null && fn:length(data) > 0}">
						<input type="hidden" name="display_item_cnt" id="display_item_cnt" value= "${total_cnt }" />
					</c:if>
					<div class="fr">
						<b>총 주문 금액 </b>
						<input type="text" name="check_sum_price" id="check_sum_price" class="input_type_text" value="0" style="background-color:#FFFFFF;color:red;font-weight: bold;font-size:9pt;border:#FFFFFF 1px solid;text-align:right;" readOnly>&nbsp;
						<input type="hidden" name="st_check_sum_price" id="st_check_sum_price" value=""> 
						<input type="hidden" name="pointValue" id="pointValue" value=""> 
					</div>
					<br/>
					<div class="btnArea ac" style="margin-bottom:0px; margin-top: 5px;">
						<span class="fr btn_02">
							<a href="javascript:doAction('regOrder');">주문하기</a>
						</span>
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
}

var st;
//기능함수
function doAction(str) {
	var btnEvent = str;
	switch (str) {
	case "search":	 //조회
		kepSearch($("#curPage").val());
		break;
	case "regOrder": // 주문하기
		var checkedCnt = $('input:checkbox[name="st_checkbox"]:checked').length;
		if(checkedCnt == 0){
			alert("명절선물 품목을 선택하여 주십시요. ");
			return;
		}
		if(!confirm("명절선물 세트 주문신청 하시겠습니까? ")){ 
			return;
		} 

		kepAjaxFormCall("/mpso/setBuyerMpSoGroupPurchaseList.do","contentForm","regOrder");
		break;
	}
}

// 조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoHolidayPurchaseList.do").submit();   
}

//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}

// 팝업 함수호출
var gridIndex = 0;
var grbRow = "";

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
		alert("신청 완료했습니다.");
		kepSearch(1);
	}
	
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("처리중 오류가 발생 하였습니다.\n\n확인 후 다시 시도하여 주십시요");
} 

//선택 품목 총 합계금액
function chk_sum_price(){
	var _st_checkbox = $("input:checkbox[name=st_checkbox]");
	var _st_req_qty = $("input:text[name=st_req_qty]");
	var _st_unit_price = $("input:hidden[name=st_unit_price]");
	var stReqQtyCnt = $("input:text[name=st_req_qty]").length;
	var sumPrice = 0;
	for(var i = 0; i < stReqQtyCnt; i++){
		var st_req_qty = $(_st_req_qty[i]).val();
		var st_unit_price = $(_st_unit_price[i]).val();
		if(!kepIsNumberStr(st_req_qty)){
			alert(i+1+'번째 행의 수량은 숫자형식만 입력가능합니다.');
			$(_st_req_qty[i]).focus();
			return;
		}
		if($(_st_checkbox[i]).is(":checked") == true)
 			sumPrice += eval(st_req_qty)*eval(st_unit_price);
	}
	document.forms.contentForm.check_sum_price.value = kepCommaNum(sumPrice) + " 원";
	document.forms.contentForm.st_check_sum_price.value = sumPrice;
}


var g_popRow = "";
//대상자선택
function getReqUserSelect(popRow){
	g_popRow = popRow;
	var st_buyer = "<%=buyer%>";
	getUserSelect(st_buyer);
}
//대상자셋팅
function setPopupReturn(user_id, user_name, phone_number, email, dept, dept_name, address_loc, fax_number, legacy_user_id, mobile_phone){

	var tot_cnt  = document.forms.contentForm.display_item_cnt.value;

	if(eval(tot_cnt) < 2) {
		var _st_checkbox = $("input:checkbox[name=st_checkbox]");
		_st_checkbox.checked = true;
		document.contentForm.st_ref_pr_no.value = user_id;
		document.contentForm.req_user_name.value = user_name;
	}else{
		var _st_checkbox = $("input:checkbox[name=st_checkbox]");
		_st_checkbox[g_popRow-1].checked = true;
		document.contentForm.st_ref_pr_no[g_popRow-1].value = user_id;
		document.contentForm.req_user_name[g_popRow-1].value = user_name;
	}
}
// 사용자선택
function getUserSelect(buyer){
	popupSel = "USER";
	var dept_code = "";
	openSearchPopup('/common/misUserSelectDeptPop.do', '?open=Y&com_code='+buyer +'&dept_code='+dept_code, "650,500,no");
}

</script>
</html>
