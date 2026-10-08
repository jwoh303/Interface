<%--
**********************************************
* 메뉴 : 주문관리 > 반품조회 및 등록(코웨이)
* 화면 : 반품조회 및 등록(코웨이)
* 기능 : 코웨이 반납주문 생성
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.text.SimpleDateFormat"%> 
<%@ page import="java.util.Calendar"%> 
<%@ page import="java.util.Date"%> 
<%@ page import="java.util.Locale"%> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/include/head.jspf"%>
</head>

<%
String zcode	= CommonUtil.nvl((String) request.getParameter("st_zcode"), "");
String buyer	= "";
String message_str	= "";
if (_sessionInfo != null){ 
	buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 
}

boolean p060000064 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000064");	// 발주기간 제어 로직 사용여부.
String p060000064_admin	= "";

try {
	p060000064_admin = CommonUtil.nvl(CommonUtil.getSpecialCheckReturn(buyer,"P06-0000064","COL01_DATA", request));
} catch (Exception e) {
	e.printStackTrace();
}

Calendar _calendar = Calendar.getInstance();
Date _currentDate = new Date();
SimpleDateFormat _formatter = new SimpleDateFormat( "yyyyMMdd", Locale.KOREA );
String _toDay = _formatter.format ( _currentDate ); // 현재일자
_calendar.setTime( _currentDate );

String yyyymm  = _toDay.substring(0, 6);
String TEXT1 = "";
String TEXT2 = "";
String TEXT3 = "";
String TEXT4 = "";
String po_date_check	= "N";
String fnBlock	= "N";

if (p060000064) {
	TEXT1 = "";
	TEXT2 = "";
	TEXT3 = CommonUtil.addDate(new Date(), "D", -45, 1);
	TEXT4 = CommonUtil.addDate(new Date(), "D", 0, 1);
	po_date_check	= "Y";
	fnBlock	= "Y";
}

%>

<body onload="kep_onload_view()">
	<div id="wrapper">
		<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp"%>
		
			<c:import charEncoding="utf-8" url="/menu/menu.do">
				<c:param name="page" value="buyerLeft" />
				<c:param name="part" value="${param.upperId}" />
			</c:import>
			<c:set var="sessionInfo" value="${sessionInfo }"/>
			<c:set var="comCode" value="${sessionInfo.comCode }"/>
			<c:set var="adminUser" value="<%=p060000064_admin%>"/>
			<c:set var="total_cnt" value='0' />
			<c:set var="CheckDate" value='<%=CommonUtil.addDate(new Date(), "D", 1, 1) %>' />
			<c:forEach items="${data }" var="_gridList" begin="0" end="1">
				<c:set var="total_cnt" value='${_gridList.TOTNUM }' />
			</c:forEach>
			<c:set var="curPage" value='${(curPage==null)?"1":curPage }' />
			<c:set var="onepagerow" value='${onepagerow }' />
			<c:set var="fromDate" value='' />
			<c:set var="toDate" value='' />
			<c:set var="st_from_date" value='${st_fromDate }' />
			<c:set var="st_to_date" value='${st_to_date }' />
			<c:if test='${st_from_date == null || st_from_date == "" }'>
				<c:set var="fromDate" value='<%=CommonUtil.addDate(new Date(), "M", -1, 1) %>' />
				<c:set var="toDate" value='<%=CommonUtil.getCurrentDay_Time("yyyyMMdd") %>' />
			</c:if>
			<c:if test='${!(st_from_date == null || st_from_date == "") }'>
				<c:set var="toDate" value='${st_to_date }' />
			</c:if>
			<c:set var="rowNumber" value='0' />
			<div id="container2">
			<div id="ContArea">
				<h3>반납품목 조회 및 등록</h3>
				<div id="searchBtnA">
					<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span>
					<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
				</div>
				<form name="searchForm" id="searchForm" method="post">
					<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">
					<input type="hidden" name="curPage" id="curPage" value="${curPage }" />
					<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
					<input type="hidden" name="st_dept" id="st_dept" value="${sessionInfo.department}">
					<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
					<input type="hidden" id="moveToMaster" name="moveToMaster" value="${moveToMaster }">
					<div id="cont_searchA">
						<table class="cont_t_list01">
							<caption>조회</caption>
							<colgroup>
								<col width="10%" />
								<col width="19%" />
								<col width="10%" />
								<col width="16%" />
								<col width="10%" />
								<col width="8%" />
								<col width="10%" align="center"/>
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th>
										<select name="st_date_type" id="st_date_type">
											<option value="PO" selected>생성일</option>
											<option value="PH">발주일</option>
										</select>
									</th>
									<td colspan="3">
										<input type="text" size="11" id="st_from_date" name="st_from_date" value="${st_from_date }" readonly="readonly" />
										 ~ 
										<input type="text" size="11" id="st_to_date" name="st_to_date" value="${st_to_date }" readonly="readonly" />
										<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
										<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>	
										<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','6')">6개월</a></span>
										<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>		
									</td>
									<th >요청서번호</th>
									<td>
										<input type="text" name="st_pr_no" id="st_pr_no" class="input_type_text" value="">
									</td>
									<th >&nbsp;&nbsp;&nbsp;&nbsp;공제구분</th>
									<td>
										<select id="st_zcode" name="st_zcode" title="공제구분" style="width:90%;">
											<%= CommonUtil.getCodeBComboList(_sessionInfo.getComCode(), "SEL", "Z019", "ICOMCOD2", zcode, "") %>
										</select>
									</td>
								</tr>
								<tr>
									<th>요청부서</th>
									<td>
										<input type="hidden" name="st_add_user_dept_code" id="st_add_user_dept_code" value="">
										<input type="text" name="st_add_user_dept_name" id="st_add_user_dept_name" style="width:55%;ime-mode:active" value="" READONLY>
										<a href="javascript:doPop('dept');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
										<a href="javascript:kepEraser('st_add_user_dept_code','st_add_user_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
									</td>
									<th>대상자사번</th>
									<td>
										<input type="text" name="st_req_legacy_user_id" id="st_req_legacy_user_id" class="input_type_text" value="">
									</td>
									<th>대상자이름</th>
									<td>
										<input type="text" name="st_req_user_name" id="st_req_user_name" class="input_type_text" value="" />
									</td>
									<th>&nbsp;&nbsp;&nbsp;&nbsp;상태</th>
									<td>
										<select id="st_status" name="st_status" style="width:90%;">
											<option value="" selected>전체</option>
											<option value="GR" >입고</option>
											<option value="JE" >정산완료</option>
											<option value="RT" >반납</option>
										</select>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top: 3px;" />
						<label for="b_no02" class="hidden">정렬개수선택</label>
						<select id="onepagerow" name="onepagerow">
							<option value="10" selected>10건</option>
							<option value="20">20건</option>
							<option value="30">30건</option>
							<option value="50">50건</option>
						</select> 
					</span>
<%
	if(p060000064) {
%>
					&nbsp;&nbsp; <font style="color:red;" ><b>CL 반납은 10월 10일이후부터 SAP에서 진행가능합니다. 자세한 사항은 담당자에게 문의하시기 바랍니다. (02-2172-1859)</b></font>
<%
	}
%>
					</br>
				</form>
				<form name="contentForm" id="contentForm" method="post">
					<input type="hidden" name="curPage" id="curPage" value="${curPage }" />
					<input type="hidden" name="onepagerow" id="onepagerow" value="${onepagerow }" />
					<table id="table_list" class="cont_t_list02" style="width: 100%">
						<colgroup>
							<col width="3%" />
							<col width="8%" />
							<col width="8%" />
							<col width="*" />
							<col width="9%" />
							<col width="8%" />
							<col width="9%" />
							<col width="8%" />
							<col width="5%" />
							<col width="8%" />
							<col width="8%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">전체</th>
								<th scope="col">주문번호<br/>반납번호</th>
								<th scope="col">대상자</th>
								<th scope="col">상품코드<br/>상품명</th>
								<th scope="col">단가<br/>금액</th>
								<th scope="col">발주일<br/>생성일</th>
								<th scope="col">요청부서명</th>
								<th scope="col">요청자</th>
								<th scope="col">상태</th>
								<th scope="col">입고수량<br/>반납가능수량</th>
								<th scope="col">반납수량<br/>반납사유</th>
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
											<td align="center" width="3%" title="체크박스" class="td01">
												<input type="checkbox" name="st_checkbox" value="${rowNumber-1 }" />
												<input type="hidden" name = "st_buyer" value = "${_gridList.BUYER }">
												<input type="hidden" name = "st_gr_no" value = "${_gridList.GR_NO }">
												<input type="hidden" name = "st_gr_seq" value = "${_gridList.GR_SEQ }">
												<input type="hidden" name = "st_zstatus" value = "${_gridList.ZSTATUS }">
												<input type="hidden" name = "st_lis_pr_no" value = "${_gridList.PR_NO }">
												<input type="hidden" name = "st_lis_pr_seq" value = "${_gridList.PR_SEQ }">
												<input type="hidden" name = "st_ret_pr_no" value = "${_gridList.RET_PR_NO }">
												<input type="hidden" name = "st_ref_pr_no" value = "${_gridList.REF_PR_NO }">
												<input type="hidden" name = "st_ret_ref_pr_no" value = "${_gridList.RET_REF_PR_NO }">
												<input type="hidden" name = "st_mg_note" value = "${_gridList.MG_NOTE }">
												<input type="hidden" name = "st_target_qty" value = "${_gridList.TARGET_QTY }">
												<input type="hidden" name = "st_buyer_item_no" value = "${_gridList.BUYER_ITEM_NO }">
												<input type="hidden" name = "st_org_buyer_item_no" value = "${_gridList.ORG_BUYER_ITEM_NO }">
												<input type="hidden" name = "st_req_user_id" value = "${_gridList.REQ_USER_ID }">
											</td>
											<td width="8%" title="주문번호/반납번호" class="td02">
												<a href="javascript:getPrDisplayPop('${_gridList.BUYER }','${_gridList.PR_NO }');">
													${_gridList.REF_PR_NO }
												</a>
												<br/>
												<a href="javascript:getPrDisplayPop('${_gridList.BUYER }','${_gridList.RET_PR_NO }');">
													${_gridList.RET_REF_PR_NO }&nbsp;
												</a>
											</td>
											<td width="8%" title="대상자사번/대상자이름" class="td02">
												${_gridList.LEGACY_REQ_USER_ID }
												<br/>
												${_gridList.REQ_USER_NAME_LOC }
											</td>
											<td title="상품코드/상품명" class="td02">
												<a href="javascript:getBuyerCatalogDisplayPop('${_gridList.BYIT_COMORG_CODE }','${_gridList.ORG_BUYER_ITEM_NO }','${_gridList.CONTRACT_NO }','${_gridList.CONTRACT_SEQ }');">
													${_gridList.BUYER_ITEM_NO }
												</a>
												<br/>
												${_gridList.DESCRIPTION }
											</td>
											<td width="9%" title="단가/금액" class="td02">
												<fmt:formatNumber value="${_gridList.UNIT_PRICE }" pattern="###,###,##0.###"/>
												<br/>
												<fmt:formatNumber value="${_gridList.ITEM_AMT }" pattern="###,###,##0.###"/>
											</td>
											<td width="8%" title="발주일/생성일" class="td02">
												<fmt:parseDate value="${_gridList.PO_CREATE_DATE }" pattern="yyyyMMdd" var="poCreateDate"/>
												<fmt:formatDate value="${poCreateDate }" pattern="yyyy/MM/dd" />
												<br/>
												<fmt:parseDate value="${_gridList.ADD_DATE }" pattern="yyyyMMdd" var="poDate"/>
												<fmt:formatDate value="${poDate }" pattern="yyyy/MM/dd" />
												<input type="hidden" id="st_po_date" name="st_po_date" value="${_gridList.ADD_DATE}" >
											</td>
											<td width="9%" title="요청부서" class="td02">
												${_gridList.ADD_USER_DEPT_NAME }
											</td>
											<td width="8%" title="요청자사번/요청자명" class="td02">
												${_gridList.LEGACY_ADD_USER_ID }
												<br/>
												${_gridList.ADD_USER_NAME }
											</td>
											<td width="5%" title="상태" class="td02">
												${_gridList.STATUS }
											</td>
											<td width="8%" title="입고수량/반납여부" class="td02">
												${_gridList.ITEM_QTY }
												<br/>
												<input type="text" id="st_ret_pos_qty" name="st_ret_pos_qty" class="ccc" style="width:95%; text-align:center; background-color:${tclass}; border:1px solid ${tclass}; " value="${_gridList.RET_POS_QTY }"  readOnly>
											</td>
											<td width="8%" title="반납사유" class="td02">
												<input type="text" id="st_return_qty" name="st_return_qty" class="ccc" style="width:95%; text-align:center; background-color:${tclass};" value="${_gridList.RET_TARGET_QTY}"  ${(_gridList.RET_CHECK == "Y")?"readOnly":"" } >
												<br/>
												<input type="text" id="st_return_remark" name="st_return_remark" style="width:95%; background-color:${tclass}; " maxlength="200" value="${_gridList.REMARK }" ${(_gridList.RET_CHECK == "Y")?"readOnly":"" }>
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
					<p id="paging" class="paging">
						<%=CommonUtil.getPageView("kepSearch", Integer.parseInt(pageContext.getAttribute("total_cnt").toString()), (pageContext.getAttribute("curPage") == null) ? "0" : (String) pageContext.getAttribute("curPage"), (String) pageContext.getAttribute("onepagerow"))%>
						<span class="cl">[ 총 <c:out value="${total_cnt }" /> 건 ]</span>
					</p>
					<div class="btnArea">
						<div class="fr">
							<c:if test="${ adminUser == sessionInfo.userId }">
							<span class="btn_04">
								<a href="javascript:doAction('setReturnSetting');">반납기간설정</a>
							</span>
							</c:if>
							<span class="btn_04">
								<a href="javascript:doAction('setGrReturn');">선택품목반납</a>
							</span>
						</div>
					</div>
				</form>
				<form name="processForm" id="processForm" method="post">
					<input type="hidden" id="s_SAVENAME" name="s_SAVENAME" value="" />
					<input type="hidden" id="total_cnt" name="total_cnt" value="${total_cnt }" />
					<input type="hidden" id="curPage" name="curPage" value="${curPage }" />
					<input type="hidden" id="onepagerow" name="onepagerow" value="${onepagerow }" />
					<input type="hidden" id="st_com_code" name="st_com_code" value="${sessionInfo.comCode }" />
					<input type="hidden" id="st_user_id" name="st_user_id" value="${sessionInfo.userId }" />
					<input type="hidden" id="st_buyer_code" name="st_buyer_code" value="" />
					<input type="hidden" id="st_mblnr" name="st_mblnr" value="">
					<input type="hidden" id="st_key" name="st_key" value="">
					<input type="hidden" id="st_from_date" name="st_from_date" value="">
					<input type="hidden" id="st_to_date" name="st_to_date" value="">
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
	var st_from_date = "${param.st_from_date }".replace(/[/]/gi,"");
	var st_to_date = "${param.st_to_date }".replace(/[/]/gi,"");
	initSearchCondition("searchForm", "st_date_type", "${param.st_date_type }");	// 입고일/주문일
	initSearchCondition("searchForm", "st_from_date", st_from_date);
	initSearchCondition("searchForm", "st_to_date", st_to_date);
	initSearchCondition("searchForm", "st_pr_no", "${param.st_pr_no }");
	initSearchCondition("searchForm", "st_add_user_dept_code", "${param.st_add_user_dept_code }");
	initSearchCondition("searchForm", "st_add_user_dept_name", "${param.st_add_user_dept_name }");
	initSearchCondition("searchForm", "st_req_legacy_user_id", "${param.st_req_legacy_user_id }");
	initSearchCondition("searchForm", "st_req_user_name", "${param.st_req_user_name }");
	initSearchCondition("searchForm", "st_status", "${param.st_status }");
	
	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#from_date").val( kepToMonthAdd("1","M"));
	$("#to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
}

$(document).ready(function(){
	
	$('#onepagerow').change(function(){
		
		document.forms.searchForm.curPage.value = "1";
	});
	
});

var st;
//기능함수
function doAction(str) {

	if ("<%=fnBlock%>" == "Y") {
		alert("CL 반납은 10월 10일이후부터 SAP에서 진행가능합니다.\n자세한 사항은 담당자에게 문의하시기 바랍니다.\n02-2172-1859");
		return;
	}
	
	var btnEvent = str;
	switch (str) {
	case "search":	 //조회
	
		var zcode	= $("#st_zcode").val();
	
		if(zcode == "") {
			alert("공제구분 조건을 입력하시기 바랍니다.");
			$("#st_zcode").focus();
		} else {
			$("#curPage").val("1");
			kepSearch($("#curPage").val());	
		}
		break;
		
	case "reload":	//초기화
		$("#st_buyer").val("none");
		$("#st_buyer_name").val("");
		$("#st_dept_code").val("none");
		$("#st_dept_name").val("");
		$("#st_term_type").val("M");
		$("#st_term").val("");
		$("#st_term_text").val("");

		jspTableClean("table_list");
		break;

	case "excelDown": // 엑셀다운로드
		giExcelDownload();
		break;

	case "setGrReturn" : //반납
	
		var zcode	= $('#st_zcode').val();
		var st_po_from_date		= "<%=TEXT3%>";
		var st_po_to_date		= "<%=TEXT4%>";

		var chechboxCnt = $('input:checkbox[name="st_checkbox"]').length;
		var checkedCnt = $('input:checkbox[name="st_checkbox"]:checked').length;
		if(checkedCnt == 0){
			alert("반납하실 목록을 선택하여 주십시요. ");
			return;
		}
		var _st_ret_pr_no = $("input:hidden[name=st_ret_pr_no]");
		var _st_return_qty = $("input:text[name=st_return_qty]");
		var _st_target_qty = $("input:hidden[name=st_target_qty]");
		var _st_return_remark = $("input:text[name=st_return_remark]");
		var _st_checkbox = $("input:checkbox[name=st_checkbox]");
		var _st_zstatus = $("input:hidden[name=st_zstatus]");
		var _st_lis_pr_no = $("input:hidden[name=st_lis_pr_no]");
		var _st_po_date = $("input:hidden[name=st_po_date]");
		
		if(zcode == ""){
			alert("공제구분을 입력하여 주십시오.");
			return;
		}
		
		for(var i = 0; i < chechboxCnt; i++){
			if($(_st_checkbox[i]).is(":checked") == true){
				
				var ret_pr_no = $(_st_ret_pr_no[i]).val();
				var return_qty = $(_st_return_qty[i]).val();
				var target_qty = $(_st_target_qty[i]).val();
				var return_remark = $(_st_return_remark[i]).val();
				var zstatus = $(_st_zstatus[i]).val();
				var lis_pr_no = $(_st_lis_pr_no[i]).val();
				var po_date = $(_st_po_date[i]).val();
				
				if(zstatus == "D"){
					alert("주문번호:"+lis_pr_no+" 정산건이므로 반납이 불가합니다.");
					return;
				}
				
				if(ret_pr_no != ""){
					alert("이미 반납하신 이력이 있어 반납이 불가합니다.");
					return;
				}
				
				if(return_qty == "" || return_qty == "0"){
					alert("반납수량을 입력하여 주십시오.");
					$(_st_return_qty[i]).focus();
					return;
				}
				
				if(return_qty > target_qty){
					alert("반납수량은 주문수량을 초과할 수 없습니다.");
					$(_st_return_qty[i]).focus();
					return;
				}
				
				if(return_remark == ""){
					alert("반납사유를 입력하여 주십시오.");
					$(_st_return_remark[i]).focus();
					return;
				}
				
				if ( "Y" == "<%=po_date_check%>" ) {
					if ( st_po_from_date > po_date || po_date > st_po_to_date ) {
						alert("반납대상이 아닙니다.\n담당자에게 문의하여 확인하여 주십시요(담당자 02-2172-1859)");
						return;
					}
				}
			}
		}
		
		var msg = "선택한 목록을 반납하시겠습니까?";
		if(confirm(msg)) {
			kepAjaxFormCall("/mpso/saveBuyerMpSoDelyReturnCowayList.do","contentForm",'setGrReturn');
		}
		break;
	case "setReturnSetting" : 
		doPop(str);
		break;
	}
}

// 조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoDelyReturnCowayList.do").submit();   
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2,value3,value4,value5){
	if (popupSel == "icomcmpyPop"){
		$("#st_buyer").val(value1);
		$("#st_buyer_name").val(value2);
		$("#st_dept_code").val('');
		$("#st_dept_name").val('');
	} else if(popupSel == "remarkReturn2Pop") {
		$("input[name=st_remark]").eq(gridIndex).val(value1);
		if(value1 ==""){
			$("img[id=st_remark_img]").eq(gridIndex).attr("src",remarkOff);
		}else{
			$("img[id=st_remark_img]").eq(gridIndex).attr("src",remarkOn);
		}
	} else if(popupSel == "setReturnSetting") {
		kepSearch("1");
	}
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var status = response.msg.MSGTYPE;
	var msg = response.msg.MESSAGE;
	if(pMethod == 'setGrReturn'){
		if (status == "E"){
			alert("작업에 실패하였습니다. \n[" +msg+"]\n 위 메시지를 담당자에게 전달하시기 바랍니다.");
		}else{
			alert("반품등록에 성공하였습니다.");
		}
		// 처리후 재조회
		kepSearch($("#curPage").val());
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function kepAjaxError(pMethod , response) {
	if(pMethod != 'excelDown') {
		alert("처리중 오류가 발생 하였습니다.\n\n확인 후 다시 시도하여 주십시요");	
	}
}

function getPrDisplayPop(BUYER,PR_NO,RECV_FLAG,VALUE2){ 
	
	if (PR_NO != "") {
		openSearchPopup('/mpiv/showCommonMpIvOdrreqDetailPop.do','?openYn=Y&PR_NO='+PR_NO+'&RECV_FLAG='+'' , "800,600,no");
	}
}

//팝업 함수호출
function doPop(str, value1, value2, value3, value4, value5, value6) {
	switch (str) {
	case "dept": // 요청부서
		popupSel = "dept";
		openSearchPopup("/common/deptCodeAdminPop.do", "?open=Y&com_code="+$('#st_com_code').val(), "500,500,no");
		break;
		
	case "setReturnSetting" :
		openSearchPopup("/mpso/getBuyerCowayReturnPeriodPop.do", "" , "500,220,no");
		break;
	}
}

function setPopupReturn(code, text, value){
	if (popupSel == "dept") {
		$("#st_add_user_dept_code").val(code);
		$("#st_add_user_dept_name").val(text);
	}
}

function setResulte(){
	document.contentForm.st_page.value = "1";
	document.contentForm.st_check.value = "SEARCH";
	document.contentForm.method = "post";
	document.contentForm.target = "cen";
	document.contentForm.action = "<%=request.getRequestURI()%>";
	document.contentForm.submit();
}
</script>
</html>
