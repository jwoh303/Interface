<%--
**********************************************
* 메뉴 : 관리자>회사법인정보관리
* 화면 : 회사법인정보관리
* 기능 : 고객사 법인상세정보 조회 및 수정
* 프로그램 ID : PG_01_B_004_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-06-11
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("data_pass"); // 조회된 결과
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
%>
<script type="text/javascript">
<!--
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view() {
	<% if (_dataList==null || _dataList.size()==0) { %>
		doAction("search");
	<% } 	%>
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
	case "search":	 //조회
		kepSearch();
		break;
	case "save": // 저장	
		if (checkSubmit()) {
			kepAjaxFormCall("/mdam/saveBuyerMdAmCmpyCorpManageList.do", "contentForm", "save"); 	
		}
		break;
	}
}

// 조회
function kepSearch() {
	$('#searchForm').attr("action", "/mdam/getBuyerMdAmCmpyCorpManageList.do").submit();   
}
  
//팝업함수호출
function doPop(str) {
	popupSel = str;

	switch (str) {
/* 		case "zipcode": //ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
			openSearchPopup("/common/zipCodeSearchPop.do", "?1=1", "500,666,no");			
			break; */
		case "newzipcode": //우편번호 검색
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");			
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "zipcode") {
		$("#st_zip_code").val(code);
		$("#st_address").val(text);
	}
}
/* //ICOMPOST 테이블 이용하여 우편번호 검색 김영훈	
function setZipPopupReturn(str_zipcode, str_zip_key, str_sido, str_gugun, str_roadNm, str_buildingNo, str_buildingName, str_dong) {
	$("#st_zip_code").val(str_zipcode);
	$("#st_zip_key").val(str_zip_key);
	$("#st_address").val(str_sido + " " + str_gugun + " " + str_roadNm + " " + str_buildingNo);
	$("#st_address_dt").val(str_buildingName);
}
 */

function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
	$("#st_zip_code").val(zipNo.replace(/[^0-9]/gi, ''));
	$("#st_zip_key").val(bdMgtSn);
	$("#st_address").val(roadAddrPart1 + " " + roadAddrPart2);
	$("#st_address_dt").val(addrDetail);
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var msg = response.msg;
	
	if (pMethod == "save") {
		if (msg == 'OK') {
			alert("<%=CommonLang.msg("MSG269")%>");	//회원사 정보 변경이 성공하였습니다.
		} else {
			alert("<%=CommonLang.msg("MSG270")%>");	//회원사 정보 변경이 실패 하였습니다.\n다시 확인하여 주십시요!
            return;
		}
	}
	// 처리후 재조회
	doAction("search");
}

function  kepAjaxError(pMethod , response) {
	alert("<%=CommonLang.msg("MSG163")%>");	//오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.   
} 

function checkSubmit() {
    if (isEmpty($("#st_ceo_name_loc").val())) {
		alert("<%=CommonLang.msg("MSG271")%>");	//대표자(국문)를 입력해주세요.
		$("#st_ceo_name_loc").focus();
		return false;
	}

	if (isEmpty($("#st_ceo_name_eng").val())) {
		alert("<%=CommonLang.msg("MSG272")%>");	//대표자(영문)를 입력해주세요.
		$("#st_ceo_name_eng").focus();
		return false;
	}

	if ( $("#st_ceo_name_eng").val().length < chkKorea($("#st_ceo_name_eng").val())) {
		alert("<%=CommonLang.msg("MSG273")%>");	//대표자(영문)를 영문으로 입력해 주십시요.
		$("#st_ceo_name_eng").focus();
		return false;
	}

	if (isEmpty($("#st_tel_no").val())) {
		alert("<%=CommonLang.msg("MSG274")%>");	//대표전화번호를 입력해 주십시요.
		$("#st_tel_no").focus();
		return false;
	}

	if (isEmpty($("#st_industry_type").val())) {
		alert("<%=CommonLang.msg("MSG275")%>");	//업태을 입력해 주십시요.
		$("#st_industry_type").focus();
		return false;
	}

	if (isEmpty($("#st_business_items").val())) {
		alert("<%=CommonLang.msg("MSG276")%>");	//종목을 입력해 주십시요.
		$("#st_business_items").focus();
		return false;
	}

	if (isEmpty($("#st_zip_code").val())) {
		alert("<%=CommonLang.msg("MSG277")%>");	//우편번호를 입력해 주십시요.
		$("#st_zip_code").focus();
		return false;
	}
	
	if (isEmpty($("#st_zip_key").val())) {
		alert("<%=CommonLang.msg("MSG278")%>");	//도로명 주소로 변경 바랍니다.
		$("#st_zip_code").focus();
		return false;
	}
	
	
	if (isEmpty($("#st_address").val())) {
		alert("<%=CommonLang.msg("MSG279")%>");	//주소를 입력해 주십시요
		$("#st_address").focus();
		return false;
	}

	if ( $("#st_address_eng").val().length < chkKorea($("#st_address_eng").val())) {
		alert("<%=CommonLang.msg("MSG280")%>");	//영문주소를 영문으로 입력해 주십시요.
		$("#st_address_eng").select();
		return false;
	}
	
	if (isEmpty($("#st_corp_reg_no_1").val()) || isEmpty($("#st_corp_reg_no_2").val())) {
		alert("<%=CommonLang.msg("MSG281")%>");	//법인등록번호를 입력하여 주십시요.
		$("#st_corp_reg_no_1").focus();
		return false;
	}
	
	if ($("#st_corp_reg_no_1").val() != "" && $("#st_corp_reg_no_1").val().length != 6) {
		alert("<%=CommonLang.msg("MSG282")%>");	//법인등록번호 첫번째는 숫자로 6자리 입니다.
		$("#st_corp_reg_no_1").val("");
		$("#st_corp_reg_no_1").focus();
		return false;
	}

	if ($("#st_corp_reg_no_2").val() != "" && $("#st_corp_reg_no_2").val().length != 7) {
		alert("<%=CommonLang.msg("MSG283")%>");	//법인등록번호 두번째는 숫자로 7자리 입니다.
		$("#st_corp_reg_no_2").val("");
		$("#st_corp_reg_no_2").focus();
		return false;
	}

	if ( $("#st_corp_reg_no_1").val() != "" && $("#st_corp_reg_no_2").val() != "" ) {
		$("#st_corp_reg_no").val($("#st_corp_reg_no_1").val() + "-" + $("#st_corp_reg_no_2").val());
	}

	if (isEmpty($("#st_gr_emp_nm").val())) {
		alert("<%=CommonLang.msg("MSG284")%>");	//입고담당자명을 입력하여 주십시요.
		$("#st_gr_emp_nm").focus();
		return false;
	}
    
	if (isEmpty($("#st_gr_emp_tel").val())) {
		alert("<%=CommonLang.msg("MSG285")%>");	//입고담당자 전화번호를 입력하여 주십시요.
		$("#st_gr_emp_tel").focus();
		return false;
	}
    
	if (isEmpty($("#st_ac_emp_nm").val())) {
		alert("<%=CommonLang.msg("MSG286")%>");	//경리담당자명을 입력하여 주십시요.
		$("#st_ac_emp_nm").focus();
		return false;
	}
    
	if (isEmpty($("#st_ac_emp_tel").val())) {
		alert("<%=CommonLang.msg("MSG287")%>");	//경리담당자 전화번호를 입력하여 주십시요.
		$("#st_ac_emp_tel").focus();
		return false;
	}
    
	if (isEmpty($("#st_pay_recver").val())) {
		alert("<%=CommonLang.msg("MSG288")%>");	//물품대금수령처를 입력하여 주십시요.
		$("#st_pay_recver").focus();
		return false;
	}
    
	if ($("#st_pay_terms").val() == "") {
		alert("<%=CommonLang.msg("MSG289")%>");	//수금조건을 선택해 주십시요.
		$("#st_pay_terms").focus();
		return false;
	}
	
	if ($("#st_pay_type").val() == "") {
		alert("<%=CommonLang.msg("MSG290")%>");	//수금형태를 선택해 주십시요.
		$("#st_pay_type").focus();
		return false;
	}
	
	$("#st_mail_send_flag").val($("input[name=mail_send_flag]:checked").val());

	return confirm("<%=CommonLang.msg("MSG291")%>");	//회원사 정보를 수정 하시겠습니까?
}
//-->
</script>
<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<div id="ContArea">
	<h3><%=CommonLang.get("HTITLE330")%><!-- 회사법인정보관리 --></h3>
	
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<input type="hidden" id="st_com_code"			name="st_com_code"			value="${sessionInfo.comCode}">
		<input type="hidden" id="st_user_id" 				name="st_user_id"				value="${sessionInfo.userId}">
		<input type="hidden" id="add_user_id"			name="add_user_id"				value="${sessionInfo.userId}"  />
		<input type="hidden" id="add_user_name"		name="add_user_name"		value="${sessionInfo.userNameLoc}"  />
		<input type="hidden" id="add_user_tel"			name="add_user_tel"	 		value="${sessionInfo.tel}"  />
		<input type="hidden" id="add_user_dept"		name="add_user_dept" 		value="${sessionInfo.department}"  />
		<input type="hidden" id="change_user_id"		name="change_user_id"		value="${sessionInfo.userId}"  />
		<input type="hidden" id="change_user_name"	name="change_user_name" 	value="${sessionInfo.userNameLoc}"  />
		<input type="hidden" id="change_user_tel"		name="change_user_tel" 		value="${sessionInfo.tel}"  />
		<input type="hidden" id="change_user_dept"	name="change_user_dept" 	value="${sessionInfo.userId}"  />
	
		<!-- 공통 -->
	  	<% if (_rowData != null) {  %>
		<table  class="cont_t_list06" style="width:100%;">
              <caption><%=CommonLang.get("HTITLE330")%><!-- 회사법인정보관리 --></caption>
              <colgroup>
                  <col width="15%" />
                  <col width="35%" />
                  <col width="15%" />
                  <col width="35%" />
              </colgroup>
              <tbody>
			<tr>
				<th scope="row"><%=CommonLang.get("HTITLE331")%><!-- 회사코드 --></th>
                      <td><%=CommonUtil.nvl(_rowData.get("COM_CODE"))%></td>
                      <th scope="row"><%=CommonLang.get("HTITLE332")%><!-- 법인그룹 --></th>
                      <td><%=CommonUtil.nvl(_rowData.get("CORP_NAME"))%></td>
			</tr>
			
			<tr>
                      <th scope="row"><%=CommonLang.get("HTITLE333")%><!-- 회사명(국문) --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC"))%></td>
                      <th scope="row"><%=CommonLang.get("HTITLE334")%><!-- 회사명(영문) --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("COM_NAME_ENG"))%></td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE335")%><!-- 사업자등록번호 --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("IRS_NO")) %></td>
                      <th scope="row"><%=CommonLang.get("HTITLE336")%><!-- 설립년도 --></th>
                    	<td>
                    		<input type="text" id="st_establish_date" name="st_establish_date" class="input_type_text" title="" style="width:80px;" maxlength="8"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"  value="<%=CommonUtil.nvl(_rowData.get("ESTABLISH_DATE"))%>" /> (EX : YYYYMMDD)
                    	</td>
                  </tr>
                  <tr>
                      <th scope="row" class="star"><%=CommonLang.get("HTITLE337")%><!-- 대표자(국문) --></th>
                    	<td><input type="text" id="st_ceo_name_loc" name="st_ceo_name_loc" class="input_type_text" title="" style="width:85%;" maxlength="40"  onkeyup="fnCheckInputByte(this, 40);" onchange="fnCheckInputByte(this, 40);" value="<%=CommonUtil.nvl(_rowData.get("CEO_NAME_LOC"))%>" /></td>
                      <th scope="row" class="star"><%=CommonLang.get("HTITLE338")%><!-- 대표자(영문) --></th>
                    	<td><input type="text" id="st_ceo_name_eng" name="st_ceo_name_eng" class="input_type_text" title="" style="width:85%; ime-mode:disabled;" maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("CEO_NAME_ENG"))%>" /></td>
                  </tr>
                  <tr>
                      <th scope="row" class="star"><%=CommonLang.get("HTITLE339")%><!-- 대표전화번호 --></th>
                    	<td><input type="text" id="st_tel_no" name="st_tel_no"class="input_type_text" title="" style="width:50%;" maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("TEL_NO"))%>"  onkeyup="fnPhoneNumberCheck('st_tel_no');" onchange="fnPhoneNumberCheck('st_tel_no');"/> (EX : 02-0000-0000)</td>
                      <th scope="row"><%=CommonLang.get("HTITLE340")%><!-- 대표FAX번호 --></th>
                    	<td><input type="text" id="st_fax_no" name="st_fax_no"class="input_type_text" title="" style="width:85%;" maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("FAX_NO"))%>"  onkeyup="fnPhoneNumberCheck('st_fax_no');" onchange="fnPhoneNumberCheck('st_fax_no');"/></td>
                  </tr>
                  <tr>
                      <th scope="row" class="star"><%=CommonLang.get("HTITLE341")%><!-- 업태 --></th>
                    	<td><input type="text" id="st_industry_type" name="st_industry_type"class="input_type_text" title="" style="width:85%;" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" value="<%=CommonUtil.nvl(_rowData.get("INDUSTRY_TYPE"))%>" /></td>
                      <th scope="row" class="star"><%=CommonLang.get("HTITLE342")%><!-- 종목 --></th>
                    	<td><input type="text" id="st_business_items" name="st_business_items"class="input_type_text" title="" style="width:85%;" maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" value="<%=CommonUtil.nvl(_rowData.get("BUSINESS_ITEMS"))%>" /></td>
                  </tr>
                  <tr>
                      <th scope="row" class="star"><%=CommonLang.get("HTITLE343")%><!-- 우편번호 --></th>
                    	<td>
                    		<input type="text" id="st_zip_code" name="st_zip_code" class="input_type_text" title="" style="width:80px;" maxlength="10"  readonly  value="<%=CommonUtil.nvl(_rowData.get("ZIP_CODE"))%>" />
	                      	<input type="hidden" id="st_zip_key" name="st_zip_key" value="<%=CommonUtil.nvl(_rowData.get("ZIP_KEY"))%>"/>
                    		<%-- <span class="btn_gray_05"  title="우편번호" ><a href="javascript:doPop('zipcode');"><%=CommonLang.get("HTITLE343")%><!-- 우편번호 --> <%=CommonLang.get("HTITLE511")%><!-- 검색 --></a></span>	<!-- ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 --> --%>
                    		<span class="btn_gray_05"  title="우편번호" ><a href="javascript:doPop('newzipcode');"><%=CommonLang.get("HTITLE343")%><!-- 우편번호 --> <%=CommonLang.get("HTITLE511")%><!-- 검색 --></a></span>
                    	</td>
                      <th scope="row"><%=CommonLang.get("HTITLE344")%><!-- 메일링서비스 --></th>
                    	<td>
                    		<input type="radio" id="mail_send_flag1" name="mail_send_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("MAIL_SEND_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;<%=CommonLang.get("HTITLE688")%><!-- 예 -->&nbsp;&nbsp;&nbsp;
                     		<input type="radio" id="mail_send_flag2" name="mail_send_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("MAIL_SEND_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;<%=CommonLang.get("HTITLE689")%><!-- 아니오 -->
                     		<input type="hidden" id="st_mail_send_flag" name="st_mail_send_flag"  value=<%=CommonUtil.nvl(_rowData.get("MAIL_SEND_FLAG"))%>" />
                     	</td>
                  </tr>
                  <tr>
                      <th scope="row" class="star"><%=CommonLang.get("HTITLE345")%><!-- 주소 --></th>
                    	<td colspan="3">
                    		<input type="text" id="st_address" name="st_address" class="input_type_text" title="" style="width:480px;" maxlength="100" readonly value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC1"))%>" />
	                      		<input type="hidden" id="st_address_eng" name="st_address_eng"class="input_type_text" title="" style="width:85%;" maxlength="100" value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_ENG"))%>" />
                    	</td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE346")%><!-- 상세주소 --></th>
                    	<td colspan="3">
	                      		<input type="text" id="st_address_dt" name="st_address_dt" class="input_type_text" title="" style="width:85%;" maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC2"))%>" />
	                      	</td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE347")%><!-- 홈페이지주소 --></th>
                    	<td colspan="3"><input type="text" id="st_hp_address" name="st_hp_address" class="input_type_text" title="" style="width:85%;" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" value="<%=CommonUtil.nvl(_rowData.get("HP_ADDRESS"))%>" /></td>
                  </tr>
                  <tr>
                      <th scope="row" class="star"><%=CommonLang.get("HTITLE348")%><!-- 법인등록번호 --></th>
                    	<% 
                    	String _corpRegNo1 = "";
               			String _corpRegNo2 = "";
                    	if (!CommonUtil.nvl(_rowData.get("CORP_REG_NO")).equals("")) {
                    		_corpRegNo1 = CommonUtil.nvl(_rowData.get("CORP_REG_NO").substring(0, 6));
                    		_corpRegNo2 = CommonUtil.nvl(_rowData.get("CORP_REG_NO").substring(7, 14));
                    	}
                    	%>
                    	<td>
                    		<input type="text" id="st_corp_reg_no_1" name="st_corp_reg_no_1" class="input_type_text" title="" style="width:60px;" maxlength="6" value="<%=_corpRegNo1%>"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />-
                    		<input type="text" id="st_corp_reg_no_2" name="st_corp_reg_no_2" class="input_type_text" title="" style="width:60px;" maxlength="7" value="<%=_corpRegNo2 %>"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
                    		<input type="hidden" id="st_corp_reg_no" name="st_corp_reg_no" value="<%=CommonUtil.nvl(_rowData.get("CORP_REG_NO")) %>" />
                    	</td>
                    	<th scope="row"><%=CommonLang.get("HTITLE349")%><!-- 무역업등록번호 --></th>
                    	<td><input type="text" id="st_trade_reg_no" name="st_trade_reg_no" class="input_type_text" title="" style="width:85%;" maxlength="20" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" value="<%=CommonUtil.nvl(_rowData.get("TRADE_REG_NO")) %>" /></td>
                  </tr>
                  <tr>
                      <th scope="row">DUNS-NO</th>
                    	<td><input type="text" id="st_duns_no" name="st_duns_no" class="input_type_text" title="" style="width:85%;" maxlength="20" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" value="<%=CommonUtil.nvl(_rowData.get("DUNS_NO")) %>" /></td>
                    	<th scope="row"><%=CommonLang.get("HTITLE351")%><!-- 신용등급 --></th>
                    	<td><input type="text" id="st_credit_rating" name="st_credit_rating" class="input_type_text" title="" style="width:85%;" maxlength="10" onkeyup="fnCheckInputByte(this, 10);" onchange="fnCheckInputByte(this, 10);" value="<%=CommonUtil.nvl(_rowData.get("CREDIT_RATING")) %>" /></td>
                  </tr>
                  <tr>
                      <th scope="row" class="star"><%=CommonLang.get("HTITLE352")%><!-- 입고담당자명 --></th>
                    	<td><input type="text" id="st_gr_emp_nm" name="st_gr_emp_nm" class="input_type_text" title="" style="width:85%;" maxlength="20" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" value="<%=CommonUtil.nvl(_rowData.get("GR_EMP_NM")) %>" /></td>
                    	<th scope="row" class="star"><%=CommonLang.get("HTITLE353")%><!-- 입고담당자 연락처 --></th>
                    	<td><input type="text" id="st_gr_emp_tel" name="st_gr_emp_tel" class="input_type_text" title="" style="width:85%;" maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("GR_EMP_TEL")) %>"  onkeyup="fnPhoneNumberCheck('st_gr_emp_tel');" onchange="fnPhoneNumberCheck('st_gr_emp_tel');" /></td>
                  </tr>
                  <tr>
                      <th scope="row" class="star"><%=CommonLang.get("HTITLE354")%><!-- 경리담당자명 --></th>
                    	<td><input type="text" id="st_ac_emp_nm" name="st_ac_emp_nm" class="input_type_text" title="" style="width:85%;" maxlength="20" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" value="<%=CommonUtil.nvl(_rowData.get("AC_EMP_NM")) %>" /></td>
                    	<th scope="row" class="star"><%=CommonLang.get("HTITLE355")%><!-- 경리담당자 연락처 --></th>
                    	<td><input type="text" id="st_ac_emp_tel" name="st_ac_emp_tel" class="input_type_text" title="" style="width:85%;" maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("AC_EMP_TEL")) %>"  onkeyup="fnPhoneNumberCheck('st_ac_emp_tel');" onchange="fnPhoneNumberCheck('st_ac_emp_tel');" /></td>
                  </tr>
                  <tr>
                      <th scope="row" class="star"><%=CommonLang.get("HTITLE356")%><!-- 물품대금수령처 --></th>
                    	<td colspan="3"><input type="text" id="st_pay_recver" name="st_pay_recver" class="input_type_text" title="" style="width:50%;" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" value="<%=CommonUtil.nvl(_rowData.get("PAY_RECVER")) %>" /> <span><%=CommonLang.get("HTITLE367")%><!-- ※ 통장이체, 공장/본사 출납부서등을 표기 부탁드립니다. --></span></td>
                  </tr>
                 <tr>
					<th scope="row" class="star"><%=CommonLang.get("HTITLE357")%><!-- 수금조건 --></th>
					<td>
						<select id="st_pay_terms" name="st_pay_terms" style="width:55%;">
							<script>kepAjaxCommonComboDataValue('st_pay_terms', 'SA15', 'SEL', '<%=CommonUtil.nvl(_rowData.get("PAY_TERMS")) %>');</script>
						</select>
					</td>
					<th scope="row" class="star"><%=CommonLang.get("HTITLE358")%><!-- 수금형태 --></th>
					<td>
						<select id="st_pay_type" name="st_pay_type" style="width:55%;">
							<script>kepAjaxCommonComboDataValue('st_pay_type', 'SA02', 'SEL', '<%=CommonUtil.nvl(_rowData.get("PAY_TYPE")) %>');</script>
						</select>
					</td>
				</tr>
                <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE122")%><!-- 비고 --></th>
                    	<td colspan="3"><input type="text"  id="st_remark" name="st_remark" class="input_type_text" title="" style="width:85%;" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" value="<%=CommonUtil.nvl(_rowData.get("REMARK")) %>" /></td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE362")%><!-- 전자결재범위 --></th>
                    	<td colspan="3">
                    		<input type="checkbox"  id="st_PR" name="st_PR" class="input_type_text" title=""  value="구매요청서 생성"  <%=vt.contains("PR")?"checked":""%>/> <%=CommonLang.get("HTITLE363")%><!-- 청구 품의 -->&nbsp;&nbsp;&nbsp;
                    		<input type="checkbox"  id="st_PX" name="st_PX" class="input_type_text" title=""  value="구매대행 발주"  <%=vt.contains("PX")?"checked":""%>/> <%=CommonLang.get("HTITLE364")%><!-- 발주 품의 -->&nbsp;&nbsp;&nbsp;
                    		<input type="checkbox"  id="st_NG" name="st_NG" class="input_type_text" title=""  value="소싱의뢰 결재"  <%=vt.contains("NG")?"checked":""%>/> <%=CommonLang.get("HTITLE365")%><!-- 소싱의뢰 결재 -->&nbsp;&nbsp;&nbsp;
                    		<input type="checkbox"  id="st_NS" name="st_NS" class="input_type_text" title=""  value="신규소싱 합의"  <%=vt.contains("NS")?"checked":""%>/> <%=CommonLang.get("HTITLE366")%><!-- 신규소싱 합의 -->
                    	</td>
                  </tr>
		</tbody>
	</table>
	<% } %>
		
		
		<!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fr">
				<span class="btn_04">
					<a href="javascript:doAction('save');"><%=CommonLang.get("HTITLE124")%><!-- 저장 --></a>
				</span>	
            </div>
        </div>
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>


</html>
