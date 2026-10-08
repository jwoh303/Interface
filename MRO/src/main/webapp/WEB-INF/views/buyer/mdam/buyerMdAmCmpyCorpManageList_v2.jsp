<%--
**********************************************
* 메뉴 : 관리자설정관리 > 회사정보관리
* 화면 : 회사정보관리 (리뉴얼)
* 기능 : 고객사 법인상세정보 조회 및 수정
* 프로그램 ID : PG_01_B_004_00
* 담당자 : (리뉴얼)
* 착수일 : 2026-05-06
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf"  %>
<style>
.input-error { border: 2px solid #F6495F !important; background-color: #FFF5F5 !important; }
.select-error { border: 2px solid #F6495F !important; background-color: #FFF5F5 !important; }
</style>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data");
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("data_pass");
Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) {
	_rowData = _dataList.get(0);
}

Vector vt = new Vector();
if (_dataList2 != null && _dataList2.size() != 0) {
	for (int j=0; j<_dataList2.size(); j++) {
		Map<String,String> _rowData2 = _dataList2.get(j);
		vt.add(_rowData2.get("DOCU_TYPE"));
	}
}

String menuId = CommonUtil.nvl((String) request.getParameter("menuId"),"");
if(myMenuListHeader != null){
	for(int i = 0; i<myMenuListHeader.size(); i++){
		if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
			myMenuFlag = true;
			break;
		}
	}
}

String _establishDate = "";
String _establishDateDisplay = "";
String _telNo1 = "", _telNo2 = "", _telNo3 = "";
String _faxNo1 = "", _faxNo2 = "", _faxNo3 = "";
String _grEmpTel1 = "", _grEmpTel2 = "", _grEmpTel3 = "";
String _acEmpTel1 = "", _acEmpTel2 = "", _acEmpTel3 = "";
String _corpRegNo1 = "", _corpRegNo2 = "";

if (_rowData != null) {
	_establishDate = CommonUtil.nvl(_rowData.get("ESTABLISH_DATE"));
	if (_establishDate.length() == 8) {
		_establishDateDisplay = _establishDate.substring(0,4) + "-" + _establishDate.substring(4,6) + "-" + _establishDate.substring(6,8);
	} else {
		_establishDateDisplay = _establishDate;
	}

	String _telNo = CommonUtil.nvl(_rowData.get("TEL_NO"));
	String[] _telParts = _telNo.split("-");
	if (_telParts.length >= 1) _telNo1 = _telParts[0];
	if (_telParts.length >= 2) _telNo2 = _telParts[1];
	if (_telParts.length >= 3) _telNo3 = _telParts[2];

	String _faxNo = CommonUtil.nvl(_rowData.get("FAX_NO"));
	String[] _faxParts = _faxNo.split("-");
	if (_faxParts.length >= 1) _faxNo1 = _faxParts[0];
	if (_faxParts.length >= 2) _faxNo2 = _faxParts[1];
	if (_faxParts.length >= 3) _faxNo3 = _faxParts[2];

	String _grEmpTel = CommonUtil.nvl(_rowData.get("GR_EMP_TEL"));
	String[] _grEmpTelParts = _grEmpTel.split("-");
	if (_grEmpTelParts.length >= 1) _grEmpTel1 = _grEmpTelParts[0];
	if (_grEmpTelParts.length >= 2) _grEmpTel2 = _grEmpTelParts[1];
	if (_grEmpTelParts.length >= 3) _grEmpTel3 = _grEmpTelParts[2];

	String _acEmpTel = CommonUtil.nvl(_rowData.get("AC_EMP_TEL"));
	String[] _acEmpTelParts = _acEmpTel.split("-");
	if (_acEmpTelParts.length >= 1) _acEmpTel1 = _acEmpTelParts[0];
	if (_acEmpTelParts.length >= 2) _acEmpTel2 = _acEmpTelParts[1];
	if (_acEmpTelParts.length >= 3) _acEmpTel3 = _acEmpTelParts[2];

	String _corpRegNo = CommonUtil.nvl(_rowData.get("CORP_REG_NO"));
	if (_corpRegNo.length() == 14 && _corpRegNo.contains("-")) {
		_corpRegNo1 = _corpRegNo.substring(0, 6);
		_corpRegNo2 = _corpRegNo.substring(7, 14);
	}
}
%>
<script type="text/javascript">
var popupSel = "";
var initialValues = {};

function showError(el) {
	var $el = (el instanceof jQuery) ? el : $(el);
	$el.addClass($el.is("select") ? "select-error" : "input-error");
	if ($el.length > 0 && $el[0].getBoundingClientRect) {
		var rect = $el[0].getBoundingClientRect();
		if (rect.top < 0 || rect.top > window.innerHeight) {
			$('html, body').animate({
				scrollTop: $el.offset().top - (window.innerHeight / 2)
			}, 300);
		}
	}
}
function clearError(el) {
	var $el = (el instanceof jQuery) ? el : $(el);
	$el.removeClass("input-error select-error");
}
function clearAllErrors() {
	$(".input-error, .select-error").removeClass("input-error select-error");
}

function kep_onload_view() {
	<% if (_dataList==null || _dataList.size()==0) { %>
		doAction("search");
	<% } %>
	captureInitialValues();
	$("#contentForm").on("input change", "input, select, textarea", function() {
		clearError(this);
	});
}

function captureInitialValues() {
	initialValues = {};
	$('#contentForm input[type=text], #contentForm input[type=number], #contentForm select').each(function() {
		if (this.id) initialValues[this.id] = $(this).val();
	});
	$('#contentForm input[type=checkbox]').each(function() {
		if (this.id) initialValues['__chk_'+this.id] = $(this).is(':checked');
	});
}

function isDirty() {
	var dirty = false;
	$('#contentForm input[type=text], #contentForm input[type=number], #contentForm select').each(function() {
		if (this.id && initialValues[this.id] !== $(this).val()) {
			dirty = true;
			return false;
		}
	});
	if (dirty) return true;
	$('#contentForm input[type=checkbox]').each(function() {
		if (this.id && initialValues['__chk_'+this.id] !== $(this).is(':checked')) {
			dirty = true;
			return false;
		}
	});
	return dirty;
}

function doAction(str) {
	switch (str) {
		case "search":
			kepSearch();
			break;
		case "save":
			if (!isDirty()) {
				alert("수정한 정보가 없습니다.");
				return;
			}
			if (!checkSubmit()) return;
			if (confirm("수정한 정보로 저장하시겠습니까?")) {
				combineSplitFields();
				kepAjaxFormCall("/mdam/saveBuyerMdAmCmpyCorpManageList.do", "contentForm", "save");
			}
			break;
	}
}

function kepSearch() {
	$('#searchForm').attr("action", "/mdam/getBuyerMdAmCmpyCorpManageList.do").submit();
}

function combineSplitFields() {
	$("#st_corp_reg_no").val(($("#st_corp_reg_no_1").val() || "") + "-" + ($("#st_corp_reg_no_2").val() || ""));
	$("#st_tel_no").val(joinPhone("st_tel_no_1","st_tel_no_2","st_tel_no_3"));
	$("#st_fax_no").val(joinPhone("st_fax_no_1","st_fax_no_2","st_fax_no_3"));
	$("#st_gr_emp_tel").val(joinPhone("st_gr_emp_tel_1","st_gr_emp_tel_2","st_gr_emp_tel_3"));
	$("#st_ac_emp_tel").val(joinPhone("st_ac_emp_tel_1","st_ac_emp_tel_2","st_ac_emp_tel_3"));

	var disp = $("#st_establish_date_display").val() || "";
	$("#st_establish_date").val(disp.replace(/-/g, ""));
}

function joinPhone(id1, id2, id3) {
	var v1 = $("#"+id1).val() || "";
	var v2 = $("#"+id2).val() || "";
	var v3 = $("#"+id3).val() || "";
	if (v1 === "" && v2 === "" && v3 === "") return "";
	return v1 + "-" + v2 + "-" + v3;
}

function doPop(str) {
	popupSel = str;
	switch (str) {
		case "newzipcode":
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");
			break;
	}
}

function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
	$("#st_zip_code").val(zipNo.replace(/[^0-9]/gi, ''));
	$("#st_zip_key").val(bdMgtSn);
	$("#st_address").val(roadAddrPart1 + " " + roadAddrPart2);
	$("#st_address_dt").val(addrDetail);
}

function kepAjaxSuccess(pMethod, response) {
	var msg = response.msg;
	if (pMethod == "save") {
		if (msg == 'OK') {
			alert("<%=CommonLang.msg("MSG269")%>");
		} else {
			alert("<%=CommonLang.msg("MSG270")%>");
			return;
		}
	}
	doAction("search");
}

function kepAjaxError(pMethod, response) {
	alert("<%=CommonLang.msg("MSG163")%>");
}

function checkSubmit() {
	clearAllErrors();

	if (isEmpty($("#st_ceo_name_loc").val())) { alert("<%=CommonLang.msg("MSG271")%>"); showError("#st_ceo_name_loc"); $("#st_ceo_name_loc").focus(); return false; }
	if (isEmpty($("#st_ceo_name_eng").val())) { alert("<%=CommonLang.msg("MSG272")%>"); showError("#st_ceo_name_eng"); $("#st_ceo_name_eng").focus(); return false; }
	if ($("#st_ceo_name_eng").val().length < chkKorea($("#st_ceo_name_eng").val())) { alert("<%=CommonLang.msg("MSG273")%>"); showError("#st_ceo_name_eng"); $("#st_ceo_name_eng").focus(); return false; }

	var telCombined = joinPhone("st_tel_no_1","st_tel_no_2","st_tel_no_3");
	if (telCombined === "" || $("#st_tel_no_1").val() === "" || $("#st_tel_no_2").val() === "" || $("#st_tel_no_3").val() === "") {
		alert("<%=CommonLang.msg("MSG274")%>");
		if (isEmpty($("#st_tel_no_1").val())) showError("#st_tel_no_1");
		if (isEmpty($("#st_tel_no_2").val())) showError("#st_tel_no_2");
		if (isEmpty($("#st_tel_no_3").val())) showError("#st_tel_no_3");
		if (isEmpty($("#st_tel_no_1").val())) { $("#st_tel_no_1").focus(); }
		else if (isEmpty($("#st_tel_no_2").val())) { $("#st_tel_no_2").focus(); }
		else { $("#st_tel_no_3").focus(); }
		return false;
	}

	if (isEmpty($("#st_industry_type").val())) { alert("<%=CommonLang.msg("MSG275")%>"); showError("#st_industry_type"); $("#st_industry_type").focus(); return false; }
	if (isEmpty($("#st_business_items").val())) { alert("<%=CommonLang.msg("MSG276")%>"); showError("#st_business_items"); $("#st_business_items").focus(); return false; }
	if (isEmpty($("#st_zip_code").val())) { alert("<%=CommonLang.msg("MSG277")%>"); showError("#st_zip_code"); $("#st_zip_code").focus(); return false; }
	if (isEmpty($("#st_zip_key").val())) { alert("<%=CommonLang.msg("MSG278")%>"); showError("#st_zip_code"); $("#st_zip_code").focus(); return false; }
	if (isEmpty($("#st_address").val())) { alert("<%=CommonLang.msg("MSG279")%>"); showError("#st_address"); $("#st_address").focus(); return false; }

	if (isEmpty($("#st_corp_reg_no_1").val()) || isEmpty($("#st_corp_reg_no_2").val())) {
		alert("<%=CommonLang.msg("MSG281")%>");
		if (isEmpty($("#st_corp_reg_no_1").val())) showError("#st_corp_reg_no_1");
		if (isEmpty($("#st_corp_reg_no_2").val())) showError("#st_corp_reg_no_2");
		$("#st_corp_reg_no_1").focus();
		return false;
	}
	if ($("#st_corp_reg_no_1").val().length != 6) {
		alert("<%=CommonLang.msg("MSG282")%>"); showError("#st_corp_reg_no_1"); $("#st_corp_reg_no_1").val(""); $("#st_corp_reg_no_1").focus(); return false;
	}
	if ($("#st_corp_reg_no_2").val().length != 7) {
		alert("<%=CommonLang.msg("MSG283")%>"); showError("#st_corp_reg_no_2"); $("#st_corp_reg_no_2").val(""); $("#st_corp_reg_no_2").focus(); return false;
	}

	if (isEmpty($("#st_gr_emp_tel_1").val()) || isEmpty($("#st_gr_emp_tel_2").val()) || isEmpty($("#st_gr_emp_tel_3").val())) {
		alert("<%=CommonLang.msg("MSG285")%>");
		if (isEmpty($("#st_gr_emp_tel_1").val())) showError("#st_gr_emp_tel_1");
		if (isEmpty($("#st_gr_emp_tel_2").val())) showError("#st_gr_emp_tel_2");
		if (isEmpty($("#st_gr_emp_tel_3").val())) showError("#st_gr_emp_tel_3");
		if (isEmpty($("#st_gr_emp_tel_1").val())) { $("#st_gr_emp_tel_1").focus(); }
		else if (isEmpty($("#st_gr_emp_tel_2").val())) { $("#st_gr_emp_tel_2").focus(); }
		else { $("#st_gr_emp_tel_3").focus(); }
		return false;
	}
	if (isEmpty($("#st_ac_emp_tel_1").val()) || isEmpty($("#st_ac_emp_tel_2").val()) || isEmpty($("#st_ac_emp_tel_3").val())) {
		alert("<%=CommonLang.msg("MSG287")%>");
		if (isEmpty($("#st_ac_emp_tel_1").val())) showError("#st_ac_emp_tel_1");
		if (isEmpty($("#st_ac_emp_tel_2").val())) showError("#st_ac_emp_tel_2");
		if (isEmpty($("#st_ac_emp_tel_3").val())) showError("#st_ac_emp_tel_3");
		if (isEmpty($("#st_ac_emp_tel_1").val())) { $("#st_ac_emp_tel_1").focus(); }
		else if (isEmpty($("#st_ac_emp_tel_2").val())) { $("#st_ac_emp_tel_2").focus(); }
		else { $("#st_ac_emp_tel_3").focus(); }
		return false;
	}
	if (isEmpty($("#st_pay_recver").val())) { alert("<%=CommonLang.msg("MSG288")%>"); showError("#st_pay_recver"); $("#st_pay_recver").focus(); return false; }
	if ($("#st_pay_terms").val() == "") { alert("<%=CommonLang.msg("MSG289")%>"); showError("#st_pay_terms"); $("#st_pay_terms").focus(); return false; }
	if ($("#st_pay_type").val() == "") { alert("<%=CommonLang.msg("MSG290")%>"); showError("#st_pay_type"); $("#st_pay_type").focus(); return false; }

	return true;
}

function filterKorean(el) { el.value = el.value.replace(/[^ㄱ-ㆎ가-힣\s]/g, ''); }
function filterEnglish(el) { el.value = el.value.replace(/[^a-zA-Z\s]/g, ''); }
function filterNumber(el) { el.value = el.value.replace(/[^0-9]/g, ''); }
</script>
<body onload="kep_onload_view()">
<div id="wrapper">
<c:import charEncoding="utf-8" url="/menu/menu.do">
	<c:param name="page" value="buyerHeader_v2"/>
	<c:param name="part" value="buyerHeader_v2"/>
</c:import>
<div id="container2">
	<div class="SubPageTit">
		회사정보 관리
		<% if (myMenuFlag) { %>
			<button class="But_Star_on"></button>
		<% } else { %>
			<button class="But_Star_off"></button>
		<% } %>
		<div class="SubPageGuide">
			<ul>
				<li><img src="/resources/imgs/Icon_Home.png" /></li>
				<li>관리자설정관리</li>
				<li>회사정보관리</li>
			</ul>
		</div>
	</div>
	<div class="container">
		<form name="searchForm" id="searchForm" method="post">
			<input type="hidden" name="upperId" id="upperId" value="<c:out value="${param.upperId}"/>">
			<input type="hidden" name="menuId" value="<%=menuId %>">
			<input type="hidden" name="st_com_code" value="${sessionInfo.comCode}">
			<input type="hidden" name="st_user_id" value="${sessionInfo.userId}">
		</form>
		<form name="contentForm" id="contentForm" method="post">
			<input type="hidden" name="st_com_code" value="${sessionInfo.comCode}">
			<input type="hidden" name="st_user_id" value="${sessionInfo.userId}">
			<input type="hidden" name="add_user_id" value="${sessionInfo.userId}" />
			<input type="hidden" name="add_user_name" value="${sessionInfo.userNameLoc}" />
			<input type="hidden" name="add_user_tel" value="${sessionInfo.tel}" />
			<input type="hidden" name="add_user_dept" value="${sessionInfo.department}" />
			<input type="hidden" name="change_user_id" value="${sessionInfo.userId}" />
			<input type="hidden" name="change_user_name" value="${sessionInfo.userNameLoc}" />
			<input type="hidden" name="change_user_tel" value="${sessionInfo.tel}" />
			<input type="hidden" name="change_user_dept" value="${sessionInfo.userId}" />
		<% if (_rowData != null) {  %>
			<input type="hidden" id="st_tel_no" name="st_tel_no" value="<%=CommonUtil.nvl(_rowData.get("TEL_NO"))%>" />
			<input type="hidden" id="st_fax_no" name="st_fax_no" value="<%=CommonUtil.nvl(_rowData.get("FAX_NO"))%>" />
			<input type="hidden" id="st_gr_emp_tel" name="st_gr_emp_tel" value="<%=CommonUtil.nvl(_rowData.get("GR_EMP_TEL"))%>" />
			<input type="hidden" id="st_ac_emp_tel" name="st_ac_emp_tel" value="<%=CommonUtil.nvl(_rowData.get("AC_EMP_TEL"))%>" />
			<input type="hidden" id="st_corp_reg_no" name="st_corp_reg_no" value="<%=CommonUtil.nvl(_rowData.get("CORP_REG_NO"))%>" />
			<input type="hidden" id="st_establish_date" name="st_establish_date" value="<%=_establishDate%>" />
			<input type="hidden" id="st_address_eng" name="st_address_eng" value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_ENG"))%>" />
			<input type="hidden" id="st_remark" name="st_remark" value="<%=CommonUtil.nvl(_rowData.get("REMARK"))%>" />
			<input type="hidden" id="st_mail_send_flag" name="st_mail_send_flag" value="<%=CommonUtil.nvl(_rowData.get("MAIL_SEND_FLAG"))%>" />
			<input type="hidden" id="st_zip_key" name="st_zip_key" value="<%=CommonUtil.nvl(_rowData.get("ZIP_KEY"))%>" />

			<div class="SubPageTitMedium mt20">기본정보</div>
			<table class="ComInfor mt10">
				<colgroup>
					<col width="150px" />
					<col width="280px" />
					<col width="150px" />
					<col width="280px" />
					<col width="140px" />
					<col width="280px" />
				</colgroup>
				<tr>
					<th>회사코드</th>
					<td><%=CommonUtil.nvl(_rowData.get("COM_CODE"))%></td>
					<th>법인그룹</th>
					<td><%=CommonUtil.nvl(_rowData.get("CORP_NAME"))%></td>
					<th>설립연도</th>
					<td><input class="input40" style="width:230px" id="st_establish_date_display" type="text" maxlength="8" placeholder="YYYYMMDD" onkeyup="filterNumber(this);" value="<%=_establishDateDisplay%>" /></td>
				</tr>
				<tr>
					<th>회사명(국문)</th>
					<td><%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC"))%></td>
					<th>사업자등록번호 <span class="F6495F">*</span></th>
					<td><%=CommonUtil.nvl(_rowData.get("IRS_NO"))%></td>
					<th>대표자(국문) <span class="F6495F">*</span></th>
					<td><input class="input40" style="width:230px" id="st_ceo_name_loc" name="st_ceo_name_loc" type="text" maxlength="15" onkeyup="filterKorean(this);" value="<%=CommonUtil.nvl(_rowData.get("CEO_NAME_LOC"))%>" /></td>
				</tr>
				<tr>
					<th>회사명(영문)</th>
					<td><%=CommonUtil.nvl(_rowData.get("COM_NAME_ENG"))%></td>
					<th>법인번호 <span class="F6495F">*</span></th>
					<td>
						<input class="input40" style="width:97px" id="st_corp_reg_no_1" name="st_corp_reg_no_1" type="text" maxlength="6" onkeyup="filterNumber(this);" value="<%=_corpRegNo1%>" /> -
						<input class="input40" style="width:98px" id="st_corp_reg_no_2" name="st_corp_reg_no_2" type="text" maxlength="7" onkeyup="filterNumber(this);" value="<%=_corpRegNo2%>" />
					</td>
					<th>대표자(영문) <span class="F6495F">*</span></th>
					<td><input class="input40" style="width:230px" id="st_ceo_name_eng" name="st_ceo_name_eng" type="text" maxlength="25" onkeyup="filterEnglish(this);" value="<%=CommonUtil.nvl(_rowData.get("CEO_NAME_ENG"))%>" /></td>
				</tr>
				<tr>
					<th>업태 <span class="F6495F">*</span></th>
					<td><input class="input40" style="width:230px" id="st_industry_type" name="st_industry_type" type="text" maxlength="50" value="<%=CommonUtil.nvl(_rowData.get("INDUSTRY_TYPE"))%>" /></td>
					<th>무역업등록번호</th>
					<td><input class="input40" style="width:230px" id="st_trade_reg_no" name="st_trade_reg_no" type="text" maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("TRADE_REG_NO"))%>" /></td>
					<th>대표 전화번호 <span class="F6495F">*</span></th>
					<td>
						<input class="input40" style="width:40px" id="st_tel_no_1" name="st_tel_no_1" type="text" maxlength="4" onkeyup="filterNumber(this);" value="<%=_telNo1%>" /> -
						<input class="input40" style="width:59px" id="st_tel_no_2" name="st_tel_no_2" type="text" maxlength="4" onkeyup="filterNumber(this);" value="<%=_telNo2%>" /> -
						<input class="input40" style="width:60px" id="st_tel_no_3" name="st_tel_no_3" type="text" maxlength="4" onkeyup="filterNumber(this);" value="<%=_telNo3%>" />
					</td>
				</tr>
				<tr>
					<th>종목 <span class="F6495F">*</span></th>
					<td><input class="input40" style="width:230px" id="st_business_items" name="st_business_items" type="text" maxlength="100" value="<%=CommonUtil.nvl(_rowData.get("BUSINESS_ITEMS"))%>" /></td>
					<th>DUNS-NO</th>
					<td><input class="input40" style="width:230px" id="st_duns_no" name="st_duns_no" type="text" maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("DUNS_NO"))%>" /></td>
					<th>대표 FAX번호</th>
					<td>
						<input class="input40" style="width:40px" id="st_fax_no_1" name="st_fax_no_1" type="text" maxlength="4" onkeyup="filterNumber(this);" value="<%=_faxNo1%>" /> -
						<input class="input40" style="width:59px" id="st_fax_no_2" name="st_fax_no_2" type="text" maxlength="4" onkeyup="filterNumber(this);" value="<%=_faxNo2%>" /> -
						<input class="input40" style="width:60px" id="st_fax_no_3" name="st_fax_no_3" type="text" maxlength="4" onkeyup="filterNumber(this);" value="<%=_faxNo3%>" />
					</td>
				</tr>
				<tr>
					<th>홈페이지 주소</th>
					<td colspan="3"><input class="input40" style="width:660px" id="st_hp_address" name="st_hp_address" type="text" maxlength="50" value="<%=CommonUtil.nvl(_rowData.get("HP_ADDRESS"))%>" /></td>
					<th>신용등급</th>
					<td><input class="input40" style="width:230px" id="st_credit_rating" name="st_credit_rating" type="text" maxlength="10" value="<%=CommonUtil.nvl(_rowData.get("CREDIT_RATING"))%>" /></td>
				</tr>
				<tr>
					<th>사업장 주소 <span class="F6495F">*</span></th>
					<td colspan="5">
						<input class="input40" style="width:150px" id="st_zip_code" name="st_zip_code" type="text" maxlength="10" readonly value="<%=CommonUtil.nvl(_rowData.get("ZIP_CODE"))%>" />
						<button class="ButDarkGray_Medium" type="button" onclick="doPop('newzipcode');return false;">우편번호</button>
						<input class="input40" style="width:404px" id="st_address" name="st_address" type="text" maxlength="100" readonly value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC1"))%>" />
						<input class="input40" style="width:395px" id="st_address_dt" name="st_address_dt" type="text" maxlength="100" value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC2"))%>" />
					</td>
				</tr>
			</table>

			<div class="SubPageTitMedium mt30">결제정보</div>
			<table class="ComInfor mt10">
				<colgroup>
					<col width="150px" />
					<col width="280px" />
					<col width="150px" />
					<col width="280px" />
					<col width="140px" />
					<col width="280px" />
				</colgroup>
				<tr>
					<th>결제조건 <span class="F6495F">*</span></th>
					<td>
						<select id="st_pay_terms" name="st_pay_terms" class="Select40" style="width:252px;">
							<script>kepAjaxCommonComboDataValue('st_pay_terms', 'SA15', 'SEL', '<%=CommonUtil.nvl(_rowData.get("PAY_TERMS"))%>');</script>
						</select>
					</td>
					<th>결재방식 <span class="F6495F">*</span></th>
					<td>
						<select id="st_pay_type" name="st_pay_type" class="Select40" style="width:252px;">
							<script>kepAjaxCommonComboDataValue('st_pay_type', 'SA02', 'SEL', '<%=CommonUtil.nvl(_rowData.get("PAY_TYPE"))%>');</script>
						</select>
					</td>
					<th>자금집행부서 <span class="F6495F">*</span></th>
					<td><input class="input40" style="width:230px" id="st_pay_recver" name="st_pay_recver" type="text" maxlength="50" value="<%=CommonUtil.nvl(_rowData.get("PAY_RECVER"))%>" /></td>
				</tr>
			</table>

			<div class="SubPageTitMedium mt30">담당자정보</div>
			<table class="ComInfor mt10">
				<colgroup>
					<col width="150px" />
					<col width="420px" />
					<col width="150px" />
					<col width="560px" />
				</colgroup>
				<tr>
					<th>입고 담당자</th>
					<td><input class="input40" style="width:365px" id="st_gr_emp_nm" name="st_gr_emp_nm" type="text" maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("GR_EMP_NM"))%>" /></td>
					<th>입고담당자 연락처 <span class="F6495F">*</span></th>
					<td>
						<input class="input40" style="width:130px" id="st_gr_emp_tel_1" name="st_gr_emp_tel_1" type="text" maxlength="4" onkeyup="filterNumber(this);" value="<%=_grEmpTel1%>" /> -
						<input class="input40" style="width:154px" id="st_gr_emp_tel_2" name="st_gr_emp_tel_2" type="text" maxlength="4" onkeyup="filterNumber(this);" value="<%=_grEmpTel2%>" /> -
						<input class="input40" style="width:155px" id="st_gr_emp_tel_3" name="st_gr_emp_tel_3" type="text" maxlength="4" onkeyup="filterNumber(this);" value="<%=_grEmpTel3%>" />
					</td>
				</tr>
				<tr>
					<th>자금 담당자</th>
					<td><input class="input40" style="width:365px" id="st_ac_emp_nm" name="st_ac_emp_nm" type="text" maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("AC_EMP_NM"))%>" /></td>
					<th>자금 담당자 연락처 <span class="F6495F">*</span></th>
					<td>
						<input class="input40" style="width:130px" id="st_ac_emp_tel_1" name="st_ac_emp_tel_1" type="text" maxlength="4" onkeyup="filterNumber(this);" value="<%=_acEmpTel1%>" /> -
						<input class="input40" style="width:154px" id="st_ac_emp_tel_2" name="st_ac_emp_tel_2" type="text" maxlength="4" onkeyup="filterNumber(this);" value="<%=_acEmpTel2%>" /> -
						<input class="input40" style="width:155px" id="st_ac_emp_tel_3" name="st_ac_emp_tel_3" type="text" maxlength="4" onkeyup="filterNumber(this);" value="<%=_acEmpTel3%>" />
					</td>
				</tr>
			</table>

			<div class="SubPageTitMedium mt30">전자결재범위</div>
			<table class="ComInfor mt10 mb30">
				<tr>
					<th width="150px" rowspan="4">결재범위</th>
					<td width="120px"><label class="CheckLargeLabel"><input type="checkbox" id="st_NG" name="st_NG" value="소싱의뢰 결재" <%=vt.contains("NG")?"checked":""%>><span class="CheckLargeCustom"></span>견적의뢰</label></td>
					<td width="1110px">신규 품목에 대한 견적 문의 시 내부 품의 절차를 진행하는 경우</td>
				</tr>
				<tr>
					<td><label class="CheckLargeLabel"><input type="checkbox" id="st_NS" name="st_NS" value="신규소싱 합의" <%=vt.contains("NS")?"checked":""%>><span class="CheckLargeCustom"></span>견적합의</label></td>
					<td>신규 품목 견적 의뢰 후 KeP가 제출한 견적단가를 합의하는 단계에서 내부 품의를 진행하는 경우</td>
				</tr>
				<tr>
					<td><label class="CheckLargeLabel"><input type="checkbox" id="st_PR" name="st_PR" value="구매요청서 생성" <%=vt.contains("PR")?"checked":""%>><span class="CheckLargeCustom"></span>주문요청</label></td>
					<td>주문 시 부서 내에서 내부 품의 절차를 진행하는 경우</td> 
				</tr>
				<tr>
					<td><label class="CheckLargeLabel"><input type="checkbox" id="st_PX" name="st_PX" value="구매대행 발주" <%=vt.contains("PX")?"checked":""%>><span class="CheckLargeCustom"></span>주문발주</label></td>
					<td>발주 부서에 주문 요청 시 내부 품의 절차를 진행하는 경우</td> 
				</tr> 
			</table>

			<div class="ac mb30">
				<button class="ButPrimary_large" style="width:150px" type="button" onclick="doAction('save')">저장</button>
			</div>
		<% } %>
		</form>
	</div>
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>
</div>
</body>
</html>
