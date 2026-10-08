<%--
**********************************************
* 메뉴 : 공지사항
* 화면 : 공지사항 등록/수정
* 기능 : 공지사항 등록 및 수정 통합 폼
* 프로그램 ID :
* 담당자 : 원지성
* 착수일 : 2025-12-30
* 수정일 : 2026-01-06 (등록+수정 통합 모드 구현)
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<!doctype html>
<html>
<head>
<%@include file="../../common/include/head.jspf" %>
<style type="text/css">
/* 게시판 등록 폼 스타일 */
.board_write_new {
	width: 100%;
	border-collapse: collapse;
	border: 1px solid #ccc;
	table-layout: fixed;
}
.board_write_new th {
	background-color: #f5f5f5;
	border: 1px solid #ccc;
	padding: 8px 12px;
	text-align: left;
	font-weight: bold;
	vertical-align: middle;
}
.board_write_new td {
	border: 1px solid #ccc;
	padding: 8px 12px;
	vertical-align: middle;
}
.board_write_new .required {
	color: #e74c3c;
}
.customer_table_wrap {
	max-height: 155px;  /* 약 5행 높이 (헤더 제외) */
	overflow-y: auto;
	border: 1px solid #ccc;
}
.customer_table {
	width: 100%;
	border-collapse: separate;
	border-spacing: 0;

}
.customer_table th {
	background-color: #e9e9e9;
	border: 1px solid #ccc;
	padding: 4px 6px;
	height: 28px;
	box-sizing: border-box;
	text-align: center;
	font-weight: bold;
	font-size: 12px;
	position: sticky;
	top: 0;
	z-index: 1;
}
.customer_table td {
	border: 1px solid #ccc;
	border-top: none;
	padding: 4px 6px;
	height: 28px;
	box-sizing: border-box;
	text-align: center;
	font-size: 12px;
}
.btn_area_right {
	text-align: right;
	margin-bottom: 5px;
}
.btn_small {
	padding: 3px 10px;
	border: 1px solid #999;
	background: #fff;
	cursor: pointer;
	font-size: 12px;
}
.btn_small:hover {
	background: #f0f0f0;
}
.btn_register,
.btn_confirm,
.btn_cancel,
.btn_delete,
.btn_list {
	padding: 8px 15px;
	width: 100px;
	box-sizing: border-box;
	border: none;
	cursor: pointer;
	font-size: 13px;
	margin: 0 5px;
	color: #fff;
	text-align: center;
}
.btn_register {
	background: #333;
}
.btn_register:hover {
	background: #555;
}
.btn_confirm {
	background: #2ecc71;
}
.btn_confirm:hover {
	background: #27ae60;
}
.btn_cancel,
.btn_delete {
	background: #e74c3c;
}
.btn_cancel:hover,
.btn_delete:hover {
	background: #c0392b;
}
.btn_list {
	background: #95a5a6;
}
.btn_list:hover {
	background: #7f8c8d;
}
</style>
</head>
<%
	String result = CommonUtil.nvl((String) request.getAttribute("result")); // 처리결과
	String mode = CommonUtil.nvl((String) request.getAttribute("mode"), "write"); // 모드: write(등록), edit(수정)
	boolean isEditMode = "edit".equals(mode);

	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1");
	String onepagerow = (String) request.getParameter("onepagerow");
	String sbtype = CommonUtil.nvl((String) request.getParameter("sbtype"),"NT");
	String todayDate = DateTimeUtil.getFormatString("yyyy/MM/dd");
	String startDate = CommonUtil.nvl((String) request.getParameter("startDate"), todayDate);
	String st_open_flag = CommonUtil.nvl((String) request.getParameter("st_open_flag"),"");

	// 수정 모드용 변수
	Map<String, String> detail = null;
	String bid = "";
	String btype = "NT";
	boolean regflag = false;
	String openFlag = "N";

	if (isEditMode) {
		detail = (Map<String, String>) request.getAttribute("detail");
		if (detail != null) {
			bid = CommonUtil.nvl(detail.get("BID"));
			btype = CommonUtil.nvl(detail.get("BTYPE"), "NT");
			// 승인상태
			openFlag = CommonUtil.nvl(detail.get("OPEN_FLAG"), "N");
		}
		// 본인 글 여부
		Boolean regflagAttr = (Boolean) request.getAttribute("regflag");
		regflag = (regflagAttr != null) ? regflagAttr : false;
	}

	// 승인 권한 여부
	Boolean hasApprovalAuthAttr = (Boolean) request.getAttribute("hasApprovalAuth");
	boolean hasApprovalAuth = (hasApprovalAuthAttr != null) ? hasApprovalAuthAttr : false;

	// 대상 고객사 목록 (수정 모드)
	List<Map<String, String>> customers = (List<Map<String, String>>) request.getAttribute("customers");
%>
<body onload="kep_onload_view()" style="height:100%;">
<!--내용 시작-->
<div id="ContArea2">
<h3 style="margin-top: 5px; margin-bottom: 5px;" id="pageTitle">
<span style="display: inline-block; vertical-align: middle;">
<%=isEditMode ? "공지사항 수정" : "공지사항 등록" %>
</span>
<% if (isEditMode && detail != null) {
	boolean isApproved = "Y".equals(openFlag);
	boolean isEnded = "E".equals(openFlag);
	String badgeColor = isEnded ? "background-color:#95a5a6; color:#fff;" : (isApproved ? "background-color:#2ecc71; color:#fff;" : "background-color:#f39c12; color:#fff;");
	String badgeText = isEnded ? "게시 종료" : (isApproved ? "승인 완료" : "승인 대기");
%>
<span style="display: inline-block; vertical-align: middle; margin-left: 15px; padding: 4px 12px; border-radius: 4px; font-size: 13px; font-weight: normal;
	<%= badgeColor %>">
	<%= badgeText %>
</span>
<% } %>
</h3>
<form name="contentForm" id="contentForm" method="post">
	<!-- Hidden Fields -->
	<input type="hidden" name="mode" id="mode" value="<%=mode %>" />
	<input type="hidden" name="BID" id="BID" value="<%=bid %>" />
	<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	<input type="hidden" name="onepagerow" id="onepagerow" value="<%=onepagerow %>" />
	<input type="hidden" name="sbtype" id="sbtype" value="<%=sbtype %>" />
	<input type="hidden" name="startDate" id="startDate" value="<%=startDate %>" />
	<input type="hidden" name="st_open_flag" id="st_open_flag" value="<%=st_open_flag %>" />
	<input type="hidden" name="IMAGE_KEY" id="IMAGE_KEY" value="<%=isEditMode && detail != null ? CommonUtil.nvl(detail.get("IMAGE_KEY")) : "" %>" />
	<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">
	<input type="hidden" name="REG_USER_ID" id="REG_USER_ID" value="${sessionInfo.userId}" />
	<input type="hidden" name="REG_USER_NAME" id="REG_USER_NAME" value="${sessionInfo.userNameLoc}" />
	<input type="hidden" name="REG_DEP" id="REG_DEP" value="${sessionInfo.department}" />
	<input type="hidden" name="REG_DEP_NAME" id="REG_DEP_NAME" value="${sessionInfo.departmentName}" />
	<input type="hidden" name="COMPANY" id="COMPANY" value="${sessionInfo.comCode}" />
	<input type="hidden" name="BTYPE" id="BTYPE" value="<%=btype %>" />
	<input type="hidden" name="NOTICE_TYPE" id="NOTICE_TYPE" value="<%=isEditMode && detail != null ? CommonUtil.nvl(detail.get("NOTICE_TYPE"), "CMN") : "CMN" %>" />
	<input type="hidden" name="st_open_company_code" id="st_open_company_code" value="" />
	<input type="hidden" name="st_open_company_name" id="st_open_company_name" value="" />
	<%-- 권한 없는 사용자가 수정 시 기존 값 유지를 위한 hidden 필드 --%>
	<% if (!hasApprovalAuth && isEditMode && detail != null) { %>
	<input type="hidden" name="IMPORTANT_FLAG" value="<%=CommonUtil.nvl(detail.get("IMPORTANT_FLAG"), "N") %>" />
	<input type="hidden" name="ALL_CUSTOMER_FLAG" value="<%=CommonUtil.nvl(detail.get("ALL_CUSTOMER_FLAG"), "N") %>" />
	<input type="hidden" name="OPEN_FLAG" value="N" /> <!-- 관리자가 아닌 사용자가 수정할 경우 승인완료인 공지사항도 승인대기로 변경 -->
	<% } %>

	<table class="board_write_new">
		<colgroup>
			<col style="width:12%;" />
			<col style="width:38%;" />
			<col style="width:12%;" />
			<col style="width:38%;" />
		</colgroup>
		<tbody>
			<!-- 1행: 게시기간, 등록일 -->
			<tr>
				<th>게시기간</th>
				<td>
					<label style="cursor:pointer; margin-right:15px; display:inline-flex; align-items:center;">
						<input type="checkbox" id="ALWAYS_SHOW_FLAG" name="ALWAYS_SHOW_FLAG" value="Y" onchange="toggleAlwaysShow();" style="vertical-align:middle; margin:0;"
							<%=isEditMode && detail != null && "Y".equals(detail.get("ALWAYS_SHOW_FLAG")) ? "checked" : "" %>> <span style="vertical-align:middle; margin-left:3px;">상시 노출</span>
					</label>
					<input type="text" name="FROM_DATE" id="FROM_DATE" class="input_type_text" style="width:100px; text-align:center;"
						value="<%=isEditMode && detail != null ? CommonUtil.nvl(detail.get("FROM_DATE")) : "" %>">
					<span id="DATE_SEPARATOR" style="padding:0 5px;">~</span>
					<input type="text" name="TO_DATE" id="TO_DATE" class="input_type_text" style="width:100px; text-align:center;"
						value="<%=isEditMode && detail != null ? CommonUtil.nvl(detail.get("TO_DATE")) : "" %>">
				</td>
				<th>등록일</th>
				<td>
					<span id="REG_DATE_DISPLAY"><%=isEditMode && detail != null ? CommonUtil.nvl(detail.get("REG_DATE"), todayDate) : todayDate %></span>
				</td>
			</tr>
			<!-- 2행: 노출대상, 등록자 -->
			<tr>
				<th>노출대상</th>
				<td>
					<select name="EXPOSE_TARGET" id="EXPOSE_TARGET" style="width:150px;" onChange="setAclChange();">
						<option value="ALL" <%=isEditMode && detail != null && "ALL".equals(detail.get("EXPOSE_TARGET")) ? "selected" : "" %>>전체</option>
						<option value="BUY" <%=isEditMode && detail != null && "BUY".equals(detail.get("EXPOSE_TARGET")) ? "selected" : "" %>>고객사</option>
						<option value="SEL" <%=(!isEditMode || detail == null || "SEL".equals(detail.get("EXPOSE_TARGET"))) ? "selected" : "" %>>협력사</option>
					</select>
				</td>
				<th>등록자</th>
				<td>
					<%=isEditMode && detail != null ? CommonUtil.nvl(detail.get("REG_USER_NAME")) : "" %>
					<c:if test="${empty detail}"><c:out value="${sessionInfo.userNameLoc}"/></c:if>
				</td>
			</tr>
			<!-- 3행: 대상 고객사 -->
			<tr>
				<th>
					대상 고객사
					<% if (hasApprovalAuth) { %>
					<div style="margin-top:5px; font-weight:normal;">
						<label style="cursor:pointer; display:inline-flex; align-items:center;">
							<input type="checkbox" id="ALL_CUSTOMER_FLAG" name="ALL_CUSTOMER_FLAG" value="Y" onchange="toggleAllCustomerSelect();" style="vertical-align:middle; margin:0;"
								<%=isEditMode && detail != null && "Y".equals(detail.get("ALL_CUSTOMER_FLAG")) ? "checked" : "" %>>
							<span style="vertical-align:middle; margin-left:3px;">전체</span>
						</label>
					</div>
					<% } %>
				</th>
				<td colspan="3">
					<div class="btn_area_right">
						<button type="button" class="btn_small" onclick="addCustomer();">추가</button>
						<button type="button" class="btn_small" onclick="deleteCustomer();">삭제</button>
					</div>
					<div class="customer_table_wrap">
						<table class="customer_table" id="customerTable">
							<colgroup>
								<col style="width:5%;" />
								<col style="width:20%;" />
								<col style="width:35%;" />
								<col style="width:20%;" />
								<col style="width:20%;" />
							</colgroup>
							<thead>
								<tr>
									<th style="vertical-align:middle; text-align:center;"><input type="checkbox" id="chkAll" onclick="toggleAllCustomer(this);" style="margin:0; vertical-align:middle;"></th>
									<th>고객사코드</th>
									<th>고객사명</th>
									<th>사업자번호</th>
									<th>대표자명</th>
								</tr>
							</thead>
							<tbody id="customerTbody">
								<% if (customers != null && customers.size() > 0) {
									for (Map<String, String> customer : customers) { %>
								<tr>
									<td style="vertical-align:middle; text-align:center;"><input type="checkbox" name="chkCustomer" value="<%=CommonUtil.nvl(customer.get("COM_CODE")) %>" style="margin:0; vertical-align:middle;"></td>
									<td><%=CommonUtil.nvl(customer.get("COM_CODE")) %></td>
									<td><%=CommonUtil.nvl(customer.get("COM_NAME")) %></td>
									<td><%=CommonUtil.nvl(customer.get("IRS_NO")) %></td>
									<td><%=CommonUtil.nvl(customer.get("CEO_NAME")) %></td>
								</tr>
								<% } } %>
							</tbody>
						</table>
					</div>
				</td>
			</tr>
			<!-- 4행: 제목 -->
			<tr>
				<th>제목</th>
				<td colspan="3">
					<input type="text" name="SUBJECT" id="SUBJECT" class="input_type_text" style="width:100%;"
						   value="<%=isEditMode && detail != null ? CommonUtil.nvl(detail.get("SUBJECT")) : "" %>"
						   onkeyup="fnCheckInputByte(this, 250);" onchange="fnCheckInputByte(this, 250);">
				</td>
			</tr>
			<!-- 5행: 내용 -->
			<tr>
				<th>내용</th>
				<td colspan="3">
					<textarea name="CONTEXT" id="CONTEXT" style="width:100%; height:230px; resize:vertical;"
						maxlength="5000" onkeyup="updateCharCount();" onchange="updateCharCount();"><%=isEditMode && detail != null ? CommonUtil.nvl(detail.get("CONTEXT")) : "" %></textarea>
					<div style="text-align:right; margin-top:5px; font-size:12px; color:#666;">
						<span id="charCount">0</span> / 5,000자
					</div>
				</td>
			</tr>
			<!-- 6행: 첨부 -->
			<tr>
				<th>첨부</th>
				<td colspan="3">
					<a href="javascript:attach_popup();">
						<img id="diskimg" src="/resources/images/disk_<%=isEditMode && detail != null && !"".equals(CommonUtil.nvl(detail.get("IMAGE_KEY"))) ? "on" : "off" %>.gif" name="MasterImage" width="20" height="20" border="0" style="vertical-align:middle;">
					</a>
					<span id="attachFileName" style="margin-left:10px;"></span>
				</td>
			</tr>
		</tbody>
	</table>

<!-- 버튼 영역 -->
<div style="position:relative; margin-top:20px; text-align:center;">
	<% if (hasApprovalAuth) { %>
	<label style="position:absolute; left:0; top:50%; transform:translateY(-50%); cursor:pointer;">
		<input type="checkbox" id="IMPORTANT_FLAG" name="IMPORTANT_FLAG" value="Y" style="vertical-align:middle;"
			<%=isEditMode && detail != null && "Y".equals(detail.get("IMPORTANT_FLAG")) ? "checked" : "" %>>
		<span style="vertical-align:middle;">중요 게시물</span>
	</label>
	<% } %>

	<% if (isEditMode) { %>
		<% if (hasApprovalAuth || regflag) { %>
		<button type="button" class="btn_register" onclick="kepUpdate();">수정</button>
		<% } %>
		<% if (hasApprovalAuth) { %>
		<button type="button" class="btn_cancel" onclick="kepConfirm('E');">게시종료</button>
		<button type="button" class="btn_confirm" onclick="kepConfirm('Y');">승인</button>
		<% } %>
		<button type="button" class="btn_list" onclick="kepList();">목록</button>
		<% if (hasApprovalAuth || (regflag && "N".equals(openFlag))) { %>
		<button type="button" class="btn_delete" style="float:right;" onclick="kepDelete();">삭제</button>
		<% } %>
	<% } else { %>
		<button type="button" class="btn_list" onclick="kepList();">목록</button>
		<button type="button" class="btn_register" onclick="kepWrite();">등록</button>
	<% } %>
</div>
</form>

</div>
<!--내용 종료-->

</body>
<script type="text/javascript">
var popupSel;
var isEditMode = <%=isEditMode ? "true" : "false" %>;
var currentOpenFlag = "<%=isEditMode && detail != null ? CommonUtil.nvl(detail.get("OPEN_FLAG"), "N") : "N" %>";

function kep_onload_view(){
	var result = "<%=result%>";

	// 내용 글자수 초기화
	updateCharCount();

	if (isEditMode) {
		// 수정 모드: 달력 버튼 설정
		kepNoSetCalender("FROM_DATE","");
		kepNoSetCalender("TO_DATE","");
		// 상시노출 체크 상태에 따라 날짜 필드 처리
		if ($("#ALWAYS_SHOW_FLAG").is(":checked")) {
			toggleAlwaysShow();
		}
		// 전체 고객사 체크 상태에 따라 테이블 처리
		if ($("#ALL_CUSTOMER_FLAG").is(":checked")) {
			toggleAllCustomerSelect();
		}
		// 대상 고객사 hidden 필드 초기화
		updateCustomerHiddenFields();

		if (result == "U") {
			alert("수정이 완료되었습니다.");
			kepList();
		} else if (result == "D") {
			alert("삭제가 완료되었습니다.");
			kepList();
		}
	} else {
		// 등록 모드: 기본값 설정
		kepNoSetCalender("FROM_DATE","Y");
		kepNoSetCalender("TO_DATE","");
		$("#TO_DATE").val(kepToMonthAdd("1","P"));

		if (result == "S") {
			$("#curPage").val(1);
			alert("저장이 완료되었습니다.");
			kepList();
		}
	}
}

/**
 * 내용 글자수 카운트 업데이트
 */
function updateCharCount() {
	var content = $("#CONTEXT").val();
	var length = content ? content.length : 0;
	$("#charCount").text(length.toLocaleString());

	// 5000자 초과 시 빨간색으로 표시
	if (length > 5000) {
		$("#charCount").css("color", "#e74c3c");
	} else {
		$("#charCount").css("color", "#666");
	}
}

/**
 * 상시 노출 체크박스 토글
 */
function toggleAlwaysShow() {
	var isChecked = $("#ALWAYS_SHOW_FLAG").is(":checked");

	if (isChecked) {
		$("#FROM_DATE").val("").prop("disabled", true).css("background-color", "#f0f0f0");
		$("#TO_DATE").val("").prop("disabled", true).css("background-color", "#f0f0f0");
	} else {
		$("#FROM_DATE").prop("disabled", false).css("background-color", "#fff");
		$("#TO_DATE").prop("disabled", false).css("background-color", "#fff");
		if (!isEditMode) {
			kepNoSetCalender("FROM_DATE","Y");
			kepNoSetCalender("TO_DATE","");
			$("#TO_DATE").val(kepToMonthAdd("1","P"));
		}
	}
}

/**
 * 목록이동
 */
function kepList(){
	$('#contentForm').attr("action", "/notice/noticeList.do").submit();
}

/**
 * 유효성 검사 공통
 */
function validateForm() {
	if (kepIsEmpty("SUBJECT")==true){
		alert("제목을 입력하세요.");
		$("#SUBJECT").focus();
		return false;
	}

	if (!fnCheckInputByteStr($("#SUBJECT").val(), 250)) {
		alert("제목은 영문 250자, 한글 125자 까지 입력할수 있습니다.");
		return false;
	}

	if (kepSelectValid("EXPOSE_TARGET")==true){
		alert("노출대상을 선택하세요.");
		$("#EXPOSE_TARGET").focus();
		return false;
	}

	// 상시 노출이 아닌 경우에만 날짜 유효성 검사
	if (!$("#ALWAYS_SHOW_FLAG").is(":checked")) {
		if (kepIsEmpty("FROM_DATE")==true || kepIsEmpty("TO_DATE")==true){
			alert("게시기간을 입력해주세요.");
			$("#FROM_DATE").focus();
			return false;
		}
	}

	// 대상 고객사 유효성 검사 (전체 선택이 아닌 경우에만)
	if (!$("#ALL_CUSTOMER_FLAG").is(":checked")) {
		var customerCount = $("#customerTbody tr").length;
		if (customerCount == 0) {
			alert("대상 고객사를 설정해주세요.");
			return false;
		}
	}

	if (kepIsEmpty("CONTEXT")==true){
		alert("내용을 입력하세요.");
		$("#CONTEXT").focus();
		return false;
	}

	if ($("#CONTEXT").val().length > 5000) {
		alert("내용은 5,000자 이내로 입력해주세요.");
		$("#CONTEXT").focus();
		return false;
	}

	// 대상 고객사 hidden 필드 업데이트
	updateCustomerHiddenFields();

	// 공지유형 자동 설정: 전체 선택 시 "공통(CMN)", 개별 선택 시 "고객사별(CUS)"
	var isAllCustomerChecked = false;
	var $allCustomerCheckbox = $("#ALL_CUSTOMER_FLAG");

	if ($allCustomerCheckbox.length > 0 && $allCustomerCheckbox.is(":checked")) {
		// 체크박스가 존재하고 체크된 경우
		isAllCustomerChecked = true;
	} else {
		// 체크박스가 없거나 체크되지 않은 경우 - hidden 필드 확인
		var hiddenVal = $("input[name='ALL_CUSTOMER_FLAG'][type='hidden']").val();
		if (hiddenVal === "Y") {
			isAllCustomerChecked = true;
		}
	}

	console.log("ALL_CUSTOMER_FLAG checkbox exists:", $allCustomerCheckbox.length > 0);
	console.log("ALL_CUSTOMER_FLAG is checked:", $allCustomerCheckbox.is(":checked"));
	console.log("isAllCustomerChecked:", isAllCustomerChecked);

	if (isAllCustomerChecked) {
		$("#NOTICE_TYPE").val("CMN");
		console.log("NOTICE_TYPE set to CMN (공통)");
	} else {
		$("#NOTICE_TYPE").val("CST");
		console.log("NOTICE_TYPE set to CST (고객사별)");
	}

	// 상시 노출 체크 시 기본 날짜값 설정 (SQL 호환성 유지)
	// disabled 상태를 해제해야 폼 제출 시 값이 전송됨
	if ($("#ALWAYS_SHOW_FLAG").is(":checked")) {
		$("#FROM_DATE").prop("disabled", false).val("1900/01/01");
		$("#TO_DATE").prop("disabled", false).val("9999/12/31");
	}

	return true;
}

/**
 * 대상 고객사 hidden 필드 업데이트
 */
function updateCustomerHiddenFields() {
	var codes = [];
	var names = [];

	$("#customerTbody tr").each(function() {
		var code = $(this).find("input[name='chkCustomer']").val();
		var name = $(this).find("td:eq(2)").text();
		if (code && code != "") {
			codes.push(code);
			names.push(name);
		}
	});

	$("#st_open_company_code").val(codes.join("@"));
	$("#st_open_company_name").val(names.join("@"));
}

/**
 * 등록처리
 */
function kepWrite(){
	if (!validateForm()) return;

	// 디버깅: 폼 제출 전 NOTICE_TYPE 값 확인
	console.log("=== 폼 제출 직전 ===");
	console.log("NOTICE_TYPE value:", $("#NOTICE_TYPE").val());
	console.log("ALL_CUSTOMER_FLAG checked:", $("#ALL_CUSTOMER_FLAG").is(":checked"));

	if(!confirm("공지사항을 등록하시겠습니까?")) return;
	$('#contentForm').attr("action", "/notice/noticeWrite.do").submit();
}

/**
 * 수정처리
 */
function kepUpdate(){
	if (!validateForm()) return;

	if(!confirm("내용을 수정하시겠습니까?")) return;
	$('#contentForm').attr("action", "/notice/noticeUpdate.do").submit();
}

/**
 * 삭제처리
 */
function kepDelete(){
	if(!confirm("공지사항을 삭제하시겠습니까?")) return;
	$('#contentForm').attr("action", "/notice/noticeDelete.do").submit();
}

/**
 * 승인/게시종료 (폼 제출 방식 - 변경내용과 함께 저장)
 */
function kepConfirm(openFlag){
	if (openFlag == "Y") {
		// 승인 처리
		if(!confirm("변경사항을 저장하고 승인하시겠습니까?")) return;
	} else if (openFlag == "E") {
		// 게시종료 처리 (E=강제종료) - 승인완료 상태에서만 가능
		if (currentOpenFlag != "Y") {
			alert("승인상태가 '승인완료'인 건만 게시종료 가능합니다.");
			return;
		}
		if(!confirm("변경사항을 저장하고 게시 종료하시겠습니까?")) return;
	}

	// 폼 유효성 검사
	if (!validateForm()) return;

	// OPEN_FLAG hidden 필드 추가/업데이트
	if ($("#OPEN_FLAG_HIDDEN").length === 0) {
		$('<input>').attr({
			type: 'hidden',
			id: 'OPEN_FLAG_HIDDEN',
			name: 'OPEN_FLAG',
			value: openFlag
		}).appendTo('#contentForm');
	} else {
		$("#OPEN_FLAG_HIDDEN").val(openFlag);
	}

	// 기존 수정 엔드포인트로 폼 제출
	$('#contentForm').attr("action", "/notice/noticeUpdate.do").submit();
}


function attach_popup(){
	popupSel = "file";  // 파일 첨부 팝업 구분자 설정 (buyerMulti와 구분)
	var type = "BO";
	var viewType = "C";
	var img_key = $("#IMAGE_KEY").val();
	kepFileUploadOpenPopup(img_key,type,viewType);
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4){
	// 첨부파일 팝업 콜백 (value3, value4가 없는 경우)
	if (popupSel != "buyerMulti") {
		$("#IMAGE_KEY").val(value1);
		$("#diskimg").attr("src","/resources/images/disk_"+value2+".gif");
		return;
	}

	// 고객사 팝업 콜백
	if (popupSel == "buyerMulti") {
		var comCodes = value1 ? value1.split("@") : [];
		var comNames = value2 ? value2.split("@") : [];
		var irsNos = value3 ? value3.split("@") : [];      // 사업자번호
		var ceoNames = value4 ? value4.split("@") : [];    // 대표자명

		// 기존 빈 행 삭제 (데이터가 없는 행만)
		$("#customerTbody tr").each(function() {
			var checkboxVal = $(this).find("input[name='chkCustomer']").val();
			if (!checkboxVal || checkboxVal == "") {
				$(this).remove();
			}
		});

		// 선택된 고객사 추가
		for (var i = 0; i < comCodes.length; i++) {
			var comCode = comCodes[i];
			var comName = comNames[i] || "";

			if (!comCode || comCode == "") continue;

			// 중복 체크
			var isDuplicate = false;
			$("#customerTbody input[name='chkCustomer']").each(function() {
				if ($(this).val() == comCode) {
					isDuplicate = true;
					return false;
				}
			});

			if (isDuplicate) continue;

			// 새 행 추가
			var irsNo = irsNos[i] || "";          // 사업자번호
			var ceoName = ceoNames[i] || "";      // 대표자명

			var newRow = "<tr>";
			newRow += "<td style='vertical-align:middle; text-align:center;'><input type='checkbox' name='chkCustomer' value='" + comCode + "' style='margin:0; vertical-align:middle;'></td>";
			newRow += "<td>" + comCode + "</td>";
			newRow += "<td>" + comName + "</td>";
			newRow += "<td>" + irsNo + "</td>";
			newRow += "<td>" + ceoName + "</td>";
			newRow += "</tr>";

			$("#customerTbody").append(newRow);
		}

		// hidden 필드 업데이트
		updateCustomerHiddenFields();
	}
}

function setAclChange(){
	var acl = $("#EXPOSE_TARGET").val();
	if(acl == "CST"){
		doPop("buyerMulti");
	}
}

//팝업함수호출
function doPop(str) {
	popupSel = str;

	switch (str) {
		case "buyerMulti":
			// 공지사항 전용 고객사 팝업 (사업자번호, 대표자명 포함)
			openSearchPopup("/none/getCommonNoNeNoticeBuyerPop.do","?search_opt=2&disable_yn=Y",'1000,500,no')
			popupSel = "buyerMulti";
			break;
	}
}

/**
 * 고객사 추가 (팝업 호출)
 */
function addCustomer() {
	doPop("buyerMulti");
}

/**
 * 선택된 고객사 삭제
 */
function deleteCustomer() {
	var checked = $("input[name='chkCustomer']:checked");
	if (checked.length == 0) {
		alert("삭제할 고객사를 선택해 주세요.");
		return;
	}
	checked.closest("tr").remove();
	$("#chkAll").prop("checked", false);
	updateCustomerHiddenFields();
}

/**
 * 전체 선택/해제
 */
function toggleAllCustomer(obj) {
	$("input[name='chkCustomer']").prop("checked", obj.checked);
}

/**
 * 대상 고객사 전체 선택 토글
 */
function toggleAllCustomerSelect() {
	var isChecked = $("#ALL_CUSTOMER_FLAG").is(":checked");

	if (isChecked) {
		$(".customer_table_wrap").css("opacity", "0.5");
		$("#customerTable input").prop("disabled", true);
		$(".btn_area_right button").prop("disabled", true);
	} else {
		$(".customer_table_wrap").css("opacity", "1");
		$("#customerTable input").prop("disabled", false);
		$(".btn_area_right button").prop("disabled", false);
	}
}

</script>
</html>
