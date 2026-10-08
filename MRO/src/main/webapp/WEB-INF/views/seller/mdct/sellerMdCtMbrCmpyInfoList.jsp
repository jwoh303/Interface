<%--
**********************************************
* 메뉴 : 회원사관리>회원사정보
* 화면 : 회원사정보
* 기능 : 협력사 회원사 정보 관리
* 프로그램 ID : PG_01_A_001_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-02
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
</head>
<%
// 공통
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
List<Map<String,String>> _dataAreaList = (List<Map<String,String>>) request.getAttribute("dataDelyArea"); // 조회된 납품가능 지역
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}
//계좌번호 수정 기능.
boolean p01102003 = CommonUtil.getSpecialCheckReturn(com_code,"P01-1020-03"); 



%> 
<script type="text/javascript">
var popupSel = "";
var popupItem = "";

// 최초 화면 함수 
function kep_onload_view() {
	<% if (_dataList==null || _dataList.size()==0) { %>
	doAction('search');
	<% } %>
	//납품가능지역 데이터 셋팅
	var st_cmpy_dely_area = $("#st_cmpy_dely_area").val();
	if(st_cmpy_dely_area == null || st_cmpy_dely_area =="") return;
	var str_area_list = st_cmpy_dely_area.split("");
	var tot_cnt = $("#st_cmpy_dely_cnt").val();
	// 파라미터 선택된 값 체크하기
	for(var i=0; i< tot_cnt; i++){
		if(str_area_list[i] == "Y"){
			document.getElementById("st_dely_area_flag"+i).checked = true;
		}else{
			document.getElementById("st_dely_area_flag"+i).checked = false;
		}
	}
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
	case "search":	 //조회
		kepSearch();
		break;
	case "reload":	//초기화
		kepReload("searchForm");
		break;
	case "save": // 저장	
		if (checkSubmit()) {
			kepAjaxFormCall("/mdct/saveSellerMdCtMbrCmpyInfoList.do", "contentForm", "save"); 	
		}
		break;
	case "econtViewer": // 저장
		if(isEmpty(kepTrimStr($("#st_doc_id").val()))){
			alert("전자계약 정보가 존재하지 않습니다.");
			return;
		}
		kepAjaxFormCall("/mdcp/getMasterMdCpEcontEmbeddedUrl.do", "contentForm", "econtViewer");
		break;
	}
}

// 조회
function kepSearch() {
	$('#searchForm').attr("action", "/mdct/getSellerMdCtMbrCmpyInfoList.do").submit();   
}
  
// 팝업 함수호출
function doPop(str, item, val1, val2, val3, val4, val5) {
	popupSel = str;
	popupItem = item;
	switch (str) {
/* 		case "zipcode":	//ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
			openSearchPopup("/common/zipCodeSearchPop.do", "?1=1", "500,666,no");			
			break; */
		case "newzipcode":					//우편번호 검색
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");			
			break;
		case "kepManagerPop":		// KeP담당자
			openSearchPopup("/mdcp/getMasterMdCpUserChoicePop.do","?st_buyer=KRKORE0001", "500,500,no");
			break;	
		case "itmg":						// 대리점권보유품목
			openSearchPopup("/coco/getCommonCoCoTranGoodsPop.do", "", "600,500,no");
			break;
		case "itmMk":					// 대리점권보유 메이커명
			if ($("#st_itm_mk_yn").is(":checked")) {
				alert("대리점권 보유 메이커 해당없음을 해제 하십시오");
				return;
			}	
			openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
			break;	
		case "fileUpload":				//파일업로드
			if ($("#st_itm_mk_yn").is(":checked")) {
				alert("대리점권 보유 메이커 해당없음을 해제 하십시오");
				return;
			}
			openSearchPopup("/common/fileUploadPop.do","?DOC_NO="+$("#st_itm_mk"+popupItem+"_image_key").val(), "500,430,no");	
			break;	
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	switch (popupSel) {
		case "itmg": //우편번호 검색
			$("#st_itmg" + popupItem + "_cd").val(code);
			$("#st_itmg" + popupItem + "_nm").val(text);
			break;
		case "itmMk": //우편번호 검색
			$("#st_itm_mk" + popupItem).val(code);
			$("#st_itm_mk" + popupItem + "_nm").val(text);
			$("#st_itm_mk" + popupItem + "_yn").attr("disabled", false);
			break;	
		case "fileUpload":					//파일업로드
			$("#st_itm_mk" +popupItem + "_image_key").val(code);
			break;	
	}
}

function setItmMkYn(str) {
	$("#st_itm_mk" + str + "_yn").attr("disabled", true);
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
function kepAjaxSuccess(pMethod , response){
	var sMsg = response.msg;
	
	if (pMethod == "save") {
		if (sMsg == 'OK') {
			alert("회원사 정보 수정이 완료되었습니다.");
         // 처리후 재조회
    		doAction("search");
		} else {
			alert("회원사 정보 수정이 실패 하였습니다.\n다시 확인하여 주십시요!");
            return;
		}
	}else if(pMethod == "econtViewer"){
		var url = response.url;
		window.open(url, "", "width=770,height=800,resizable=YES");
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	if(pMethod == "econtViewer"){
		alert("전자계약 파일이 존재하지 않습니다.\n협력사 담당자(02-3016-7251)에게 문의하시기 바랍니다.");
	}else{
		alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");	
	}
} 

function checkSubmit() {
	
	if (isEmpty($("#st_com_name_eng").val())) {
		alert("영문 회사명을 입력해주세요.");
		$("#st_com_name_eng").select();
		return false;
	} else {
		if (kepTrimStr($("#st_com_name_eng").val()).length < chkKorea(kepTrimStr($("#st_com_name_eng").val()))) {
			alert("영문회사명을 영문으로 입력해 주십시요.");
		    $("#st_com_name_eng").select();
		    return false;
		}

		if (kepTrimStr($("#st_com_name_eng").val()).length < 4) {
			alert("영문 회사명을 4자리 이상 입력해 주십시오");
			$("#st_com_name_eng").select();
			return false;
		}

		if (!checkSpecialChar(kepTrimStr($("#st_com_name_eng").val()))) {
			alert("영문 회사명에 특수기호(%,$,&,*,@,!,#)를 사용 할수 없습니다.");
			$("#st_com_name_eng").select();
			return false;
		}
		$("#st_com_name_eng").val(kepTrimStr($("#st_com_name_eng").val()));		
	}

	
	if (isEmpty($("#st_industry_type").val()))  {
       alert("업태를 입력해 주십시요.");
       $("#st_industry_type").focus();
       return false;
    }

	if (isEmpty($("#st_business_items").val())) {
       alert("종목을 입력해 주십시요.");
       $("#st_business_items").focus();
       return false;
    }

	if (isEmpty($("#st_ceo_name_loc").val()))  {
       alert("대표자명을 입력해주세요.");
       $("#st_ceo_name_loc").focus();
       return false;
    }

	for (var i=1; i <= 3 ; i++) {
		if (isEmpty($("#st_tel_no"+i).val())) {
			alert('대표전화번호를 입력 하여 주십시오');
			$("#st_tel_no"+i).focus();
			return false;
		}
	}

	for (var i=1; i <= 3 ; i++) {
		if (isEmpty($("#st_fax_no"+i).val())) {
			alert('대표팩스번호를 입력 하여 주십시오');
			$("#st_fax_no"+i).focus();
			return false;
		}
	}

// 	if (isEmpty($("#st_kep_damdang_id").val())) {
// 		alert("KEP 담당자를 선택 하여주십시오");
// 		return false;
// 	}

	if (isEmpty($("#st_zip_code").val())) {
		alert("우편번호를 선택 하여주십시오");
		$("#st_zip_code").focus();
		return false;
	}

	if (isEmpty($("#st_zip_key").val())) {
		alert("도로명 주소로 변경 바랍니다.");
		$("#st_zip_code").focus();
		return false;
	}

	if (isEmpty($("#st_address").val())) {
		alert("주소를 선택 하여주십시오");
		$("#st_address").focus();
		return false;
	}
	

	var itmgSelectCount = 0;
	for (var i=1; i <= 5; i++) {
		if (!isEmpty($("#st_itmg"+i+"_cd").val())) {
			itmgSelectCount++;
		}
	}
	/*
	if (itmgSelectCount < 2 ) {
		alert("취급품목을 2개 이상 선택 해 주십시오");
		return false;
	}

	var makerSelectCount = 0;
	if (!$("#st_itm_mk_yn").is(":checked")) {
		for (var i=1; i < 11; i++){
			if (isEmpty($("st_itm_mk" + i).val())) {
				makerSelectCount++;
			}
		}

		if (makerSelectCount < 1 ) {
			alert("대리점권 보유 메이커를 1개 이상 선택 해주십시오");
			return false;
		}
	}

	for (var i=1; i < 11; i++) {
		if (!isEmpty($("#st_itm_mk"+i).val())) {
			if ($("#st_itm_mk"+i+"_yn option:selected").val() == "") {
				alert($("#st_itm_mk"+i+"_nm").val() + "의 유통레벨을 선택하십시오");
				return false;
			}   
		}
	}
	*/	
// 	if ( !$("#st_mp_business_yn").is(":checked")	&& !$("#st_mp1_business_yn").is(":checked") && !$("#st_mp2_business_yn").is(":checked") && !$("#st_mp3_business_yn").is(":checked") && !$("#st_mp4_business_yn").is(":checked") && 
// 		!$("#st_mp5_business_yn").is(":checked")	) {
// 		alert("타 마켓 플레이스 거래 여부를 체크 해 주십시오");
// 		return false;
// 	}
	
	if ($("input[name=mail_send_flag]:checked").val() == "") {
		alert("메일 수신 여부를 선택 해주세요");
		return false;
	}
	
	if($("input[name=sms_recv_flag]:checked").val() == "") {
		alert("SMS 메세지 수신 여부를 선택 해주세요");
		return false;
	}
	
	$("#st_mail_send_flag").val($("input[name=mail_send_flag]:checked").val());
	$("#st_sms_recv_flag").val($("input[name=sms_recv_flag]:checked").val());
	
	
	if ($("#st_biz_type option:selected").val() == "") {
		alert("유통레벨을 선택 하세요");
		return false;
	}
	
	if ($("#st_ceo_career option:selected").val() == "") {
		alert("대표자 동종업계 경력을 선택 하세요");
		return false;
	}

	if ($("#st_emp_cnt option:selected").val() == "" ) {
		alert("상시근로자수를 선택 하세요");
		return false;
	}
	
	/*
	if ($("#st_agency_yn option:selected").val() == "" ) {
		alert("대리점권 여부를 선택 하세요");
		return false;
	}
	*/
	
	if ($("#st_iso_yn option:selected").val() == "" ) {
		alert("ISO 보유여부를 선택 하세요");
		return false;
	}

	if ($("#st_license_yn option:selected").val() == "" ) {
		alert("특허 보유여부를 선택 하세요");
		return false;
	}

	if ($("#st_year_amt option:selected").val() == "" ) {
		alert("전년도 매출액을 선택 하세요");
		return false;
	}

	if ($("#st_capt_amt option:selected").val() == "" ) {
		alert("총자본금을 선택 하세요");
		return false;
	}
	
	if ($("#st_deliv_equip_cnt option:selected").val() == "") {
		alert("배송차량 수를 선택 하세요");
		return false;
	}
	
	if (isEmpty(kepTrimStr($("#st_ac_emp_nm").val()))) {
		alert("경리 담당자를 입력 해주십시오");
		$("#st_ac_emp_nm").focus();
		return false;
	}

	for (var i=1; i <= 3 ; i++) {
		if (isEmpty($("#st_ac_emp_tel"+i).val())) {
			alert('경리 담당자 전화번호를 입력하여 주십시오');
			$("#st_ac_emp_tel"+i).focus();
			return false;
		}
	}
	
	if (isEmpty(kepTrimStr($("#st_ac_emp_email").val()))) {
		alert("경리 담당자 이메일을 입력 해주십시오");
		$("#st_ac_emp_email").focus();
		return false;
	}
	
	if (!checkemail("st_ac_emp_email")) { return false; }
	
	for (var i=1; i <= 3 ; i++) {
		if (isEmpty($("#st_ac_emp_mobile"+i).val())) {
			alert('경리 담당자 휴대폰을 입력하여 주십시오');
			$("#st_ac_emp_mobile"+i).focus();
			return false;
		}
	}
	
	if (isEmpty(kepTrimStr($("#st_gr_emp_nm").val()))) {
		alert("영업 담당자를 입력 해주십시오");
		$("#st_gr_emp_nm").focus();
		return false;
	}

	for (var i=1; i <= 3 ; i++) {
		if (isEmpty($("#st_gr_emp_tel"+i).val())) {
			alert('영업 담당자 전화번호를 입력하여 주십시오');
			$("#st_gr_emp_tel"+i).focus();
			return false;
		}
	}
	
	if (isEmpty(kepTrimStr($("#st_gr_emp_email").val()))) {
		alert("영업 담당자 이메일을 입력 해주십시오");
		$("#st_gr_emp_email").focus();
		return false;
	}
	
	if (!checkemail("st_gr_emp_email")) { return; }
	
	for (var i=1; i <= 3 ; i++) {
		if (isEmpty($("#st_gr_emp_mobile"+i).val())) {
			alert('영업 담당자 휴대폰을 입력하여 주십시오');
			$("#st_gr_emp_mobile"+i).focus();
			return false;
		}
	}
	
	if (isEmpty(kepTrimStr($("#st_ec_emp_nm").val()))) {
		alert("계약 담당자를 입력 해주십시오");
		$("#st_ec_emp_nm").focus();
		return false;
	}

	if (isEmpty(kepTrimStr($("#st_ec_emp_email").val()))) {
		alert("계약 담당자 이메일을 입력 해주십시오");
		$("#st_ec_emp_email").focus();
		return false;
	}
	
	if (!checkemail("st_ec_emp_email")) { return false; }
	
	for (var i=1; i <= 3 ; i++) {
		if (isEmpty($("#st_ec_emp_mobile"+i).val())) {
			alert('계약 담당자 휴대폰을 입력하여 주십시오');
			$("#st_ec_emp_mobile"+i).focus();
			return false;
		}
	}
	
	//납품가능 지역 데이터 셋팅
	var tmpChoiceArea = "";
	var tot_cnt = $("#st_cmpy_dely_cnt").val();
	for(var i = 0; i < tot_cnt; i++){
		var box = eval("document.forms.contentForm.st_dely_area_flag"+i);
		if(box.checked == true){
			tmpChoiceArea += "Y";
		}else{
			tmpChoiceArea += "N";
		}
	}
	//납품가능지역 데이터 셋팅
	$("#st_cmpy_dely_area").val(tmpChoiceArea);
    var confir = confirm("회원사 정보를 수정 하시겠습니까?");
	
    if (confir) {
    	
	    for (var i=1; i < 11; i++) {
	    	$("#st_itm_mk"+i+"_yn").attr("disabled", false);
		}
    }
    return confir;
}

function checkMp (obj) {
	if (obj.checked) {
		for (var i=1; i <=5 ; i++) {
			$("#st_mp"+i+"_business_yn").attr("checked", false);
			$("#st_mp"+i+"_business_yn").attr("disabled", true);
		}
	} else {
		for (var i=1; i <=5 ; i++) {
			$("#st_mp"+i+"_business_yn").attr("checked", false);
			$("#st_mp"+i+"_business_yn").attr("disabled", false);
		}
	}
}

function checkSpecialChar(str) {
	for (var i=0 ; i < str.length; i++) {
		if (str.charAt(i) == '%' || str.charAt(i) == '$' || str.charAt(i) == '&' || str.charAt(i) == '*' || str.charAt(i) == '@' || str.charAt(i) == '! '|| str.charAt(i) == '#') {
			return false;
		}
	}
	return true;
}
</script>
<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="sellerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>회원사정보</h3>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
	<!--HIDDEN-->
	<!-- 공통 -->
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
	<!-- 화면 내 정의 -->
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	</form> 
	
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		
		
		<% if (_rowData != null) { %>
	  	<p class="text11 b pt40">1. 일반사항(<span style="background:url(/resources/images/icn_star.gif) 10px 8px no-repeat; padding-left:20px;"></span>는 필수 입력사항입니다)</p>
	  	<p style="font-weight:bold;width:20%;float:left;">[회사현황]</p><p class="right" style="font-weight:bold;float:right;">회사코드 : <%=com_code %></p>
        	
        	<table class="cont_t_list06" style="width:100%;">
				<caption>회원사 정보관리 리스트</caption>
				<colgroup>
					<col width="120px" />
					<col width="22%" />
					<col width="120px" />
					<col width="22%" />
					<col width="100px" />
					<col width="22%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="star">회원명(국문)</th>
						<td><%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC"))%></td>
						<th scope="row" class="star">사업자등록번호</th>
						<td><%=CommonUtil.nvl(_rowData.get("IRS_NO1"))%>-<%=CommonUtil.nvl(_rowData.get("IRS_NO2"))%>-<%=CommonUtil.nvl(_rowData.get("IRS_NO3"))%></td>
						<th scope="row" class="star">등록구분</th>
						<td>
							<label for="st_reg_type" class="hidden">등록구분</label>
							<select name="st_reg_type" id="st_reg_type" style="width:100px;">
								<script type="text/javascript">kepAjaxCommonComboDataValue('st_reg_type', 'M109', '', '<%=CommonUtil.nvl(_rowData.get("REG_TYPE")) %>');</script>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="star">회원명(영문)</th>
						<td><input type="text" id="st_com_name_eng" name="st_com_name_eng" class="input_type_text"  title="" style="width:80%; ime-mode:disabled;" value="<%=CommonUtil.nvl(_rowData.get("COM_NAME_ENG"))%>" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" /></td>
						<th scope="row" class="star">업체</th>
						<td><input type="text" id="st_industry_type" name="st_industry_type" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("INDUSTRY_TYPE"))%>"  maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" /></td>
						<th scope="row" class="star">품목</th>
						<td><input type="text" id="st_business_items" name="st_business_items" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("BUSINESS_ITEMS"))%>" maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" /></td>
					</tr>
					<tr>
						<th scope="row" class="star">대표자명</th>
						<td><input type="hidden" id="st_ceo_name_loc" name="st_ceo_name_loc" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("CEO_NAME_LOC"))%>"  maxlength="40" onkeyup="fnCheckInputByte(this, 40);" onchange="fnCheckInputByte(this, 40);" /><%=CommonUtil.nvl(_rowData.get("CEO_NAME_LOC"))%></td>
						<th scope="row" class="star">설립년도</th>
						<td>
							<input type="text" id="st_establish_date" name="st_establish_date" class="input_type_text" title="" style="width:80%;" maxlength="8" value="<%=CommonUtil.nvl(_rowData.get("ESTABLISH_DATE"))%>" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
							<a href="javascript:kepCalendar('st_establish_date');"></a>
						</td>
						<th scope="row" class="star">유통레벨</th>
						<td>
							<label for="st_biz_type" class="hidden">유통레벨</label>
							<select name="st_biz_type" id="st_biz_type" style="width:150px;">
								<script type="text/javascript">kepAjaxCommonComboDataValue('st_biz_type', 'M110', 'SEL', '<%=CommonUtil.nvl(_rowData.get("BIZ_TYPE")) %>');</script>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="star">대표전화번호</th>
						<td>
							<% String[] tel_no = CommonUtil.nvl(_rowData.get("TEL_NO")).split("-");	%>
							<select id="st_tel_no1" name="st_tel_no1" style="width:50px;">
								<option value="02"  <%=tel_no[0].equals("02") ?"selected":""%>>02</option>
								<option value="031" <%=tel_no[0].equals("031")?"selected":""%>>031</option>
								<option value="032" <%=tel_no[0].equals("032")?"selected":""%>>032</option>
								<option value="033" <%=tel_no[0].equals("033")?"selected":""%>>033</option>
								<option value="041" <%=tel_no[0].equals("041")?"selected":""%>>041</option>
								<option value="042" <%=tel_no[0].equals("042")?"selected":""%>>042</option>
								<option value="043" <%=tel_no[0].equals("043")?"selected":""%>>043</option>
								<option value="044" <%=tel_no[0].equals("044")?"selected":""%>>044</option>
								<option value="051" <%=tel_no[0].equals("051")?"selected":""%>>051</option>
								<option value="052" <%=tel_no[0].equals("052")?"selected":""%>>052</option>
								<option value="053" <%=tel_no[0].equals("053")?"selected":""%>>053</option>
								<option value="054" <%=tel_no[0].equals("054")?"selected":""%>>054</option>
								<option value="055" <%=tel_no[0].equals("055")?"selected":""%>>055</option>
								<option value="061" <%=tel_no[0].equals("061")?"selected":""%>>061</option>
								<option value="062" <%=tel_no[0].equals("062")?"selected":""%>>062</option>
								<option value="063" <%=tel_no[0].equals("063")?"selected":""%>>063</option>
								<option value="064" <%=tel_no[0].equals("064")?"selected":""%>>064</option>
								<option value="070" <%=tel_no[0].equals("070")?"selected":""%>>070</option>
								<option value="0303" <%=tel_no[0].equals("0303")?"selected":""%>>0303</option>
								<option value="0502" <%=tel_no[0].equals("0502")?"selected":""%>>0502</option>
								<option value="0504" <%=tel_no[0].equals("0504")?"selected":""%>>0504</option>
								<option value="0505" <%=tel_no[0].equals("0505")?"selected":""%>>0505</option>
								<option value="0506" <%=tel_no[0].equals("0506")?"selected":""%>>0506</option>
								<option value="0507" <%=tel_no[0].equals("0507")?"selected":""%>>0507</option>
							</select>
							- 
							<input type="text" id="st_tel_no2" name="st_tel_no2" class="input_type_text" title="" style="width:50px;" value="<%=tel_no.length==3 ? tel_no[1] : ""%>"  maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
							- 
							<input type="text" id="st_tel_no3" name="st_tel_no3" class="input_type_text" title="" style="width:50px;" value="<%=tel_no.length==3 ? tel_no[2] : ""%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
						</td>
						<th scope="row" class="star">KeP담당자</th>
						<td>
							<input type="text" id="st_kep_damdang_id" name="st_kep_damdang_id" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("KEP_MAN_LOC"))%>" readonly />
						</td>
						<th scope="row" class="star">상시근로자수</th>
						<td>
							<label for="st_emp_cnt" class="hidden">상시근로자수</label>
							<select name="st_emp_cnt" id="st_emp_cnt" style="width:150px;">
								<script type="text/javascript">kepAjaxCommonComboDataValue('st_emp_cnt', 'M111', 'SEL', '<%=CommonUtil.nvl(_rowData.get("EMP_CNT")) %>');</script>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="star">대표팩스번호</th>
						<td>
							<% String [] fax_no = CommonUtil.nvl(_rowData.get("FAX_NO")).split("-");	%>
							<select id="st_fax_no1" name="st_fax_no1" style="width:50px;">
								<option value="02"  <%=fax_no[0].equals("02") ?"selected":""%>>02</option>
								<option value="031" <%=fax_no[0].equals("031")?"selected":""%>>031</option>
								<option value="032" <%=fax_no[0].equals("032")?"selected":""%>>032</option>
								<option value="033" <%=fax_no[0].equals("033")?"selected":""%>>033</option>
								<option value="041" <%=fax_no[0].equals("041")?"selected":""%>>041</option>
								<option value="042" <%=fax_no[0].equals("042")?"selected":""%>>042</option>
								<option value="043" <%=fax_no[0].equals("043")?"selected":""%>>043</option>
								<option value="044" <%=fax_no[0].equals("044")?"selected":""%>>044</option>
								<option value="051" <%=fax_no[0].equals("051")?"selected":""%>>051</option>
								<option value="052" <%=fax_no[0].equals("052")?"selected":""%>>052</option>
								<option value="053" <%=fax_no[0].equals("053")?"selected":""%>>053</option>
								<option value="054" <%=fax_no[0].equals("054")?"selected":""%>>054</option>
								<option value="055" <%=fax_no[0].equals("055")?"selected":""%>>055</option>
								<option value="061" <%=fax_no[0].equals("061")?"selected":""%>>061</option>
								<option value="062" <%=fax_no[0].equals("062")?"selected":""%>>062</option>
								<option value="063" <%=fax_no[0].equals("063")?"selected":""%>>063</option>
								<option value="064" <%=fax_no[0].equals("064")?"selected":""%>>064</option>
								<option value="070" <%=fax_no[0].equals("070")?"selected":""%>>070</option>
								<option value="0303" <%=fax_no[0].equals("0303")?"selected":""%>>0303</option>
								<option value="0502" <%=fax_no[0].equals("0502")?"selected":""%>>0502</option>
								<option value="0504" <%=fax_no[0].equals("0504")?"selected":""%>>0504</option>
								<option value="0505" <%=fax_no[0].equals("0505")?"selected":""%>>0505</option>
								<option value="0506" <%=fax_no[0].equals("0506")?"selected":""%>>0506</option>
								<option value="0507" <%=fax_no[0].equals("0507")?"selected":""%>>0507</option>
							</select>
							- 
							<input type="text" id="st_fax_no2" name="st_fax_no2" class="input_type_text" title="" style="width:50px;" value="<%=fax_no.length==3 ? fax_no[1] : ""%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
							- 
							<input type="text" id="st_fax_no3" name="st_fax_no3" class="input_type_text" title="" style="width:50px;" value="<%=fax_no.length==3 ? fax_no[2] : ""%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
						</td>
						<th scope="row" class="star">대표자 동종업계 경력</th>
						<td>
							<label for="st_ceo_career" class="hidden">대표자 동종업계 경력</label>
							<select name="st_ceo_career" id="st_ceo_career" style="width:150px;">
								<script type="text/javascript">kepAjaxCommonComboDataValue('st_ceo_career', 'M128', 'SEL', '<%=CommonUtil.nvl(_rowData.get("CEO_CAREER")) %>');</script>
							</select>
						</td>
						<th class="padding">홈페이지주소</th>
						<td><input type="text" id="st_hp_address" name="st_hp_address" class="input_type_text" title="" style="width:92%;" value="<%=CommonUtil.nvl(_rowData.get("HP_ADDRESS")) %>" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" /></td>
					</tr>
					<tr>
						<th scope="row" class="padding">우편번호</th>
						<td colspan="5">
							<input type="text" id="st_zip_code" name="st_zip_code" class="input_type_text" title="" style="width:70px;" readonly value="<%=CommonUtil.nvl(_rowData.get("ZIP_CODE")) %>" />
							<input type="hidden" id="st_zip_key" name="st_zip_key" value="<%=CommonUtil.nvl(_rowData.get("ZIP_KEY"))%>"/>
							<!-- <span class="btn_gray_05"  title="우편번호" ><a href="javascript:doPop('zipcode');">우편번호 검색</a></span>ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 -->
							 <span class="btn_gray_05"  title="우편번호" ><a href="javascript:doPop('newzipcode');">우편번호 검색</a></span>
						</td>
					</tr>
					<tr>
						<th scope="row" class="padding">본사주소</th>
						<td colspan="5"><input type="text" id="st_address" name="st_address" class="input_type_text" title="" style="width:600px;" value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC1")) %>" readonly /></td>
					</tr>
					<tr>
						<th scope="row" class="padding">본사상세주소</th>
						<td colspan="5"><input type="text" id="st_address_dt" name="st_address_dt" class="input_type_text" title="" style="width:600px;" value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC2")) %>" maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);"/></td>
					</tr>
				</tbody>
			</table>
            
			<p class="text11 b">2. 업체현황(<span style="background:url(/resources/images/icn_star.gif) 10px 8px no-repeat; padding-left:20px;"></span>는 필수 입력사항입니다)</p>
        	<table  class="cont_t_list06" style="width:100%;">
				<caption>회사법인 정보관리 리스트</caption>
				<colgroup>
					<col width="13%" />
					<col width="17%" />
					<col width="17%" />
					<col width="17%" />
					<col width="17%" />
					<col width="17%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="star">대리점권보유품목</th>
						<td>
							<input type="text" id="st_itmg1_nm" name="st_itmg1_nm" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG1_NM")) %>" readonly />
							<input type="hidden" id="st_itmg1_cd" name="st_itmg1_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG1_CD")) %>" />
							<!--  a href="javascript:doPop( 'itmg',  '1');"><img src="/resources/images/btn_search03.gif" /></a-->
						</td>
						<td>
							<input type="text" id="st_itmg2_nm" name="st_itmg2_nm" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG2_NM")) %>"  readonly />
							<input type="hidden" id="st_itmg2_cd" name="st_itmg2_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG2_CD")) %>" />
							<!--  a href="javascript:doPop( 'itmg',  '2');"><img src="/resources/images/btn_search03.gif" /></a>-->
						</td>
						<td>
							<input type="text" id="st_itmg3_nm" name="st_itmg3_nm" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG3_NM")) %>"  readonly />
							<input type="hidden" id="st_itmg3_cd" name="st_itmg3_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG3_CD")) %>" />
							<!--  a href="javascript:doPop( 'itmg',  '3');"><img src="/resources/images/btn_search03.gif" /></a>-->
						</td>
						<td>
							<input type="text" id="st_itmg4_nm" name="st_itmg4_nm" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG4_NM")) %>"  readonly />
							<input type="hidden" id="st_itmg4_cd" name="st_itmg4_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG4_CD")) %>" />
							<!--  a href="javascript:doPop( 'itmg',  '4');"><img src="/resources/images/btn_search03.gif" /></a> -->
						</td>
						<td>
							<input type="text" id="st_itmg5_nm" name="st_itmg5_nm" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG5_NM")) %>"  readonly  />
							<input type="hidden" id="st_itmg5_cd" name="st_itmg5_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG5_CD")) %>" />
							<!--  a href="javascript:doPop( 'itmg',  '5');"><img src="/resources/images/btn_search03.gif" /></a>-->
						</td>
					</tr>
					<tr>
						<th scope="row" class="star">대리점권보유<br>메이커명</th>
						<td>
							<input type="text"  id="st_itm_mk1_nm" name="st_itm_mk1_nm"class="input_type_text" title="" style="width:65%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK1_NM")) %>" />
							<input type="hidden"  id="st_itm_mk1" name="st_itm_mk1" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK1")) %>" />
							<!--  a href="javascript:doPop( 'itmMk',  '1');"><img src="/resources/images/btn_search03.gif" /></a>
							<a href="javascript:kepEraser('st_itm_mk1','st_itm_mk1_nm'); setItmMkYn('1');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a-->
						</td>
						<td>
							<input type="text" id="st_itm_mk2_nm" name="st_itm_mk2_nm" class="input_type_text" title="" style="width:65%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK2_NM")) %>" />
							<input type="hidden"  id="st_itm_mk2" name="st_itm_mk2" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK2")) %>" />
							<!--  a href="javascript:doPop( 'itmMk',  '2');"><img src="/resources/images/btn_search03.gif" /></a>
							<a href="javascript:kepEraser('st_itm_mk2','st_itm_mk2_nm'); setItmMkYn('2');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a-->
						</td>
						<td>
							<input type="text" id="st_itm_mk3_nm" name="st_itm_mk3_nm" class="input_type_text" title="" style="width:65%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK3_NM")) %>" />
							<input type="hidden"  id="st_itm_mk3" name="st_itm_mk3" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK3")) %>" />
							<!--  a href="javascript:doPop( 'itmMk',  '3');"><img src="/resources/images/btn_search03.gif" /></a>
							<a href="javascript:kepEraser('st_itm_mk3','st_itm_mk3_nm'); setItmMkYn('3');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a-->
						</td>
						<td>
							<input type="text" id="st_itm_mk4_nm" name="st_itm_mk4_nm" class="input_type_text" title="" style="width:65%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK4_NM")) %>" />
							<input type="hidden"  id="st_itm_mk4" name="st_itm_mk4" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK4")) %>" />
							<!--  a href="javascript:doPop( 'itmMk',  '4');"><img src="/resources/images/btn_search03.gif" /></a>
							<a href="javascript:kepEraser('st_itm_mk4','st_itm_mk4_nm'); setItmMkYn('4');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a-->
						</td>
						<td>
							<input type="text" id="st_itm_mk5_nm" name="st_itm_mk5_nm" class="input_type_text" title="" style="width:65%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK5_NM")) %>" />
							<input type="hidden"  id="st_itm_mk5" name="st_itm_mk5" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK5")) %>" />
							<!--  a href="javascript:doPop( 'itmMk', '5');"><img src="/resources/images/btn_search03.gif" /></a>
							<a href="javascript:kepEraser('st_itm_mk5','st_itm_mk5_nm'); setItmMkYn('5');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a-->
						</td>
					</tr>
					<tr>
						<th scope="row" class="star">유통레벨/대리점<br>계약서류</th>
						<td>
							
							<label for="st_itm_mk1_yn" class="hidden">--선택--</label>
							<select id="st_itm_mk1_yn" name="st_itm_mk1_yn" style="width:65%;"  <%=CommonUtil.nvl(_rowData.get("ITM_MK1_AGENCY_YN")).replaceAll("N","").equals("")?"disabled":""%> disabled>
								<script>kepAjaxCommonComboDataValue('st_itm_mk1_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK1_AGENCY_YN")) %>');</script>
							</select>
							<input type="hidden"  id="st_itm_mk1_image_key" name="st_itm_mk1_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK1_IMAGE_KEY")) %>" />
							<!--  span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '1', '<%=CommonUtil.nvl(_rowData.get("ITM_MK1_IMAGE_KEY")) %>' ) ;">첨부등록</a></span-->
						</td>
						<td>
							<label for="st_itm_mk2_yn" class="hidden">--선택--</label>
							<select name="st_itm_mk2_yn" id="st_itm_mk2_yn" style="width:65%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK2_AGENCY_YN")).replaceAll("N","").equals("")?"disabled":""%> disabled>
								<script>kepAjaxCommonComboDataValue('st_itm_mk2_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK2_AGENCY_YN")) %>');</script>
							</select>
							<input type="hidden"  id="st_itm_mk2_image_key" name="st_itm_mk2_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK2_IMAGE_KEY")) %>" />
							<!--  span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '2', '<%=CommonUtil.nvl(_rowData.get("ITM_MK2_IMAGE_KEY")) %>' ) ;">첨부등록</a></span-->
						</td>
						<td>
							<label for="st_itm_mk3_yn" class="hidden">--선택--</label>
							<select name="st_itm_mk3_yn" id="st_itm_mk3_yn" style="width:65%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK3_AGENCY_YN")).replaceAll("N","").equals("")?"disabled":""%> disabled>
								<script>kepAjaxCommonComboDataValue('st_itm_mk3_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK3_AGENCY_YN")) %>');</script>
							</select>
							<input type="hidden"  id="st_itm_mk3_image_key" name="st_itm_mk3_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK3_IMAGE_KEY")) %>" />
							<!--  span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '3', '<%=CommonUtil.nvl(_rowData.get("ITM_MK3_IMAGE_KEY")) %>' ) ;">첨부등록</a></span-->
						</td>
						<td>
							<label for="st_itm_mk4_yn" class="hidden">--선택--</label>
							<select name="st_itm_mk4_yn" id="st_itm_mk4_yn" style="width:65%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK4_AGENCY_YN")).replaceAll("N","").equals("")?"disabled":""%> disabled>
								<script>kepAjaxCommonComboDataValue('st_itm_mk4_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK4_AGENCY_YN")) %>');</script>
							</select>
							<input type="hidden"  id="st_itm_mk4_image_key" name="st_itm_mk4_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK4_IMAGE_KEY")) %>" />
							<!--  span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '4', '<%=CommonUtil.nvl(_rowData.get("ITM_MK4_IMAGE_KEY")) %>' ) ;">첨부등록</a></span-->
						</td>
						<td>
							<label for="st_itm_mk5_yn" class="hidden">--선택--</label>
							<select name="st_itm_mk5_yn" id="st_itm_mk5_yn" style="width:65%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK5_AGENCY_YN")).replaceAll("N","").equals("")?"disabled":""%> disabled>
								<script>kepAjaxCommonComboDataValue('st_itm_mk5_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK5_AGENCY_YN")) %>');</script>
							</select>
							<input type="hidden"  id="st_itm_mk5_image_key" name="st_itm_mk5_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK5_IMAGE_KEY")) %>" />
							<!--  span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '5', '<%=CommonUtil.nvl(_rowData.get("ITM_MK5_IMAGE_KEY")) %>' ) ;">첨부등록</a></span-->
						</td>
					</tr>
					<tr>
						<th scope="row" class="star">대리점권보유품목</th>
						<td>
							<input type="text" id="st_itmg6_nm" name="st_itmg6_nm" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG6_NM")) %>" readonly />
							<input type="hidden" id="st_itmg6_cd" name="st_itmg6_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG6_CD")) %>" />
							<!--  a href="javascript:doPop( 'itmg',  '6');"><img src="/resources/images/btn_search03.gif" /></a-->
						</td>
						<td>
							<input type="text" id="st_itmg7_nm" name="st_itmg7_nm" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG7_NM")) %>"  readonly />
							<input type="hidden" id="st_itmg7_cd" name="st_itmg7_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG7_CD")) %>" />
							<!--  a href="javascript:doPop( 'itmg',  '7');"><img src="/resources/images/btn_search03.gif" /></a>-->
						</td>
						<td>
							<input type="text" id="st_itmg8_nm" name="st_itmg8_nm" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG8_NM")) %>"  readonly />
							<input type="hidden" id="st_itmg8_cd" name="st_itmg8_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG8_CD")) %>" />
							<!--  a href="javascript:doPop( 'itmg',  '8');"><img src="/resources/images/btn_search03.gif" /></a>-->
						</td>
						<td>
							<input type="text" id="st_itmg9_nm" name="st_itmg9_nm" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG9_NM")) %>"  readonly />
							<input type="hidden" id="st_itmg9_cd" name="st_itmg9_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG9_CD")) %>" />
							<!--  a href="javascript:doPop( 'itmg',  '9');"><img src="/resources/images/btn_search03.gif" /></a> -->
						</td>
						<td>
							<input type="text" id="st_itmg10_nm" name="st_itmg10_nm" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG10_NM")) %>"  readonly  />
							<input type="hidden" id="st_itmg10_cd" name="st_itmg10_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG10_CD")) %>" />
							<!--  a href="javascript:doPop( 'itmg',  '10');"><img src="/resources/images/btn_search03.gif" /></a>-->
						</td>
					</tr>
					<tr>
						<th scope="row" class="star">대리점권보유<br>메이커명</th>
						<td>
							<input type="text"  id="st_itm_mk6_nm" name="st_itm_mk6_nm"class="input_type_text" title="" style="width:65%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK6_NM")) %>" />
							<input type="hidden"  id="st_itm_mk6" name="st_itm_mk6" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK6")) %>" />
							<!--  a href="javascript:doPop( 'itmMk', '6');"><img src="/resources/images/btn_search03.gif" /></a>
							<a href="javascript:kepEraser('st_itm_mk6','st_itm_mk6_nm'); setItmMkYn('6');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a-->
						</td>
						<td>
							<input type="text" id="st_itm_mk7_nm" name="st_itm_mk7_nm" class="input_type_text" title="" style="width:65%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK7_NM")) %>" />
							<input type="hidden"  id="st_itm_mk7" name="st_itm_mk7" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK7")) %>" />
							<!--  a href="javascript:doPop( 'itmMk', '7');"><img src="/resources/images/btn_search03.gif" /></a>
							<a href="javascript:kepEraser('st_itm_mk7','st_itm_mk7_nm'); setItmMkYn('7');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a-->
						</td>
						<td>
							<input type="text" id="st_itm_mk8_nm" name="st_itm_mk8_nm" class="input_type_text" title="" style="width:65%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK8_NM")) %>" />
							<input type="hidden"  id="st_itm_mk8" name="st_itm_mk8" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK8")) %>" />
							<!--  a href="javascript:doPop( 'itmMk', '8');"><img src="/resources/images/btn_search03.gif" /></a>
							<a href="javascript:kepEraser('st_itm_mk8','st_itm_mk8_nm'); setItmMkYn('8');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a-->
						</td>
						<td>
							<input type="text" id="st_itm_mk9_nm" name="st_itm_mk9_nm" class="input_type_text" title="" style="width:65%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK9_NM")) %>" />
							<input type="hidden"  id="st_itm_mk9" name="st_itm_mk9" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK9")) %>" />
							<!--  a href="javascript:doPop( 'itmMk', '9');"><img src="/resources/images/btn_search03.gif" /></a>
							<a href="javascript:kepEraser('st_itm_mk9','st_itm_mk9_nm'); setItmMkYn('9');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a-->
						</td>
						<td>
							<input type="text" id="st_itm_mk10_nm" name="st_itm_mk10_nm" class="input_type_text" title="" style="width:65%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK10_NM")) %>" />
							<input type="hidden"  id="st_itm_mk10" name="st_itm_mk10" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK10")) %>" />
							<!--  a href="javascript:doPop( 'itmMk', '10');"><img src="/resources/images/btn_search03.gif" /></a>
							<a href="javascript:kepEraser('st_itm_mk10','st_itm_mk10_nm'); setItmMkYn('10');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a-->
						</td>
					</tr>
					<tr>
						<th scope="row" class="star">유통레벨/대리점<br>계약서류</th>
						<td>
							<label for="st_itm_mk6_yn" class="hidden">--선택--</label>
							<select name="st_itm_mk6_yn" id="st_itm_mk6_yn" style="width:65%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK6_AGENCY_YN")).replaceAll("N","").equals("")?"disabled":""%> disabled>
								<script>kepAjaxCommonComboDataValue('st_itm_mk6_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK6_AGENCY_YN")) %>');</script>
							</select>
							<input type="hidden"  id="st_itm_mk6_image_key" name="st_itm_mk6_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK6_IMAGE_KEY")) %>" />
							<!--span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '6', '<%=CommonUtil.nvl(_rowData.get("ITM_MK6_IMAGE_KEY")) %>' ) ;">첨부등록</a></span-->
						</td>
						<td>
							<label for="st_itm_mk7_yn" class="hidden">--선택--</label>
							<select name="st_itm_mk7_yn" id="st_itm_mk7_yn" style="width:65%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK7_AGENCY_YN")).replaceAll("N","").equals("")?"disabled":""%> disabled>
								<script>kepAjaxCommonComboDataValue('st_itm_mk7_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK7_AGENCY_YN")) %>');</script>
							</select>
							<input type="hidden"  id="st_itm_mk7_image_key" name="st_itm_mk7_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK7_IMAGE_KEY")) %>" />
							<!--  span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '7', '<%=CommonUtil.nvl(_rowData.get("ITM_MK7_IMAGE_KEY")) %>' ) ;">첨부등록</a></span-->
						</td>
						<td>
							<label for="st_itm_mk8_yn" class="hidden">--선택--</label>
							<select name="st_itm_mk8_yn" id="st_itm_mk8_yn" style="width:65%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK8_AGENCY_YN")).replaceAll("N","").equals("")?"disabled":""%> disabled>
								<script>kepAjaxCommonComboDataValue('st_itm_mk8_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK8_AGENCY_YN")) %>');</script>
							</select>
							<input type="hidden"  id="st_itm_mk8_image_key" name="st_itm_mk8_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK8_IMAGE_KEY")) %>" />
							<!--  span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '8', '<%=CommonUtil.nvl(_rowData.get("ITM_MK8_IMAGE_KEY")) %>' ) ;">첨부등록</a></span-->
						</td>
						<td>
							<label for="st_itm_mk9_yn" class="hidden">--선택--</label>
							<select name="st_itm_mk9_yn" id="st_itm_mk9_yn" style="width:65%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK9_AGENCY_YN")).replaceAll("N","").equals("")?"disabled":""%> disabled>
								<script>kepAjaxCommonComboDataValue('st_itm_mk9_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK9_AGENCY_YN")) %>');</script>
							</select>
							<input type="hidden"  id="st_itm_mk9_image_key" name="st_itm_mk9_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK9_IMAGE_KEY")) %>" />
							<!--  span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '9', '<%=CommonUtil.nvl(_rowData.get("ITM_MK9_IMAGE_KEY")) %>' ) ;">첨부등록</a></span-->
						</td>
						<td>
							<label for="st_itm_mk10_yn" class="hidden">--선택--</label>
							<select name="st_itm_mk10_yn" id="st_itm_mk10_yn" style="width:65%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK10_AGENCY_YN")).replaceAll("N","").equals("")?"disabled":""%> disabled>
								<script>kepAjaxCommonComboDataValue('st_itm_mk10_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK10_AGENCY_YN")) %>');</script>
							</select>
							<input type="hidden"  id="st_itm_mk10_image_key" name="st_itm_mk10_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK10_IMAGE_KEY")) %>" />
							<!--  span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '10', '<%=CommonUtil.nvl(_rowData.get("ITM_MK10_IMAGE_KEY")) %>' ) ;">첨부등록</a></span-->
						</td>
					</tr>
					<tr>
						<td colspan="6"><span class="text11">※ 대리권점 보유 메이커 해당 없음</span>&nbsp;<input type="checkbox" id="st_itm_mk_yn"  name="st_itm_mk_yn" value="Y" <%=CommonUtil.nvl(_rowData.get("ITM_MK_YN")).equals("Y")?"checked":""%> /></td>
					</tr>
					<tr style="display:none;">
						<th scope="row" class="padding">대리점권 보유현황</th>
						<td colspan="5">
							<select name="st_agency_yn" disabled>
								<option value="N">-- 선택 --</option>
								<option value="Y" <%=CommonUtil.nvl(_rowData.get("AGENCY_YN")).equals("Y")?"selected":""%>>있음</option>
								<option value="N" <%=CommonUtil.nvl(_rowData.get("AGENCY_YN")).equals("N")?"selected":""%>>없음</option>
							</select>
							<input name="st_agency_remark" type="text" class="text" id="234" size="80" maxlength="25" value="<%=CommonUtil.nvl(_rowData.get("AGENCY_REMARK"))%>" readonly />
						</td>
					</tr>
<!-- 					<tr> -->
<!-- 						<th scope="row" class="padding">타마켓플레이스 거래</th> -->
<!-- 						<td colspan="5"> -->
<%-- 							<input type="checkbox" class="Noborder" id="st_mp1_business_yn" name="st_mp1_business_yn" <%=CommonUtil.nvl(_rowData.get("MP_BUSINESS_YN")).equals("Y")?"disabled":""%> <%=CommonUtil.nvl(_rowData.get("MP1_BUSINESS_YN")).equals("Y")?"checked":""%> value="Y" />&nbsp;IMK&nbsp;&nbsp;&nbsp;  --%>
<%-- 							<input type="checkbox" class="Noborder" id="st_mp2_business_yn" name="st_mp2_business_yn" <%=CommonUtil.nvl(_rowData.get("MP_BUSINESS_YN")).equals("Y")?"disabled":""%> <%=CommonUtil.nvl(_rowData.get("MP2_BUSINESS_YN")).equals("Y")?"checked":""%> value="Y" />&nbsp;서브원&nbsp;&nbsp;&nbsp; --%>
<%-- 							<input type="checkbox" class="Noborder" id="st_mp3_business_yn" name="st_mp3_business_yn" <%=CommonUtil.nvl(_rowData.get("MP_BUSINESS_YN")).equals("Y")?"disabled":""%> <%=CommonUtil.nvl(_rowData.get("MP3_BUSINESS_YN")).equals("Y")?"checked":""%> value="Y" />&nbsp;NtoB&nbsp;&nbsp;&nbsp; --%>
<%-- 							<input type="checkbox" class="Noborder" id="st_mp4_business_yn" name="st_mp4_business_yn" <%=CommonUtil.nvl(_rowData.get("MP_BUSINESS_YN")).equals("Y")?"disabled":""%> <%=CommonUtil.nvl(_rowData.get("MP4_BUSINESS_YN")).equals("Y")?"checked":""%> value="Y" />&nbsp;Biz MRO&nbsp;&nbsp;&nbsp; --%>
<%-- 							<input type="checkbox" class="Noborder" id="st_mp5_business_yn" name="st_mp5_business_yn" <%=CommonUtil.nvl(_rowData.get("MP_BUSINESS_YN")).equals("Y")?"disabled":""%> <%=CommonUtil.nvl(_rowData.get("MP5_BUSINESS_YN")).equals("Y")?"checked":""%> value="Y" />&nbsp;행복나래&nbsp;&nbsp;&nbsp; --%>
<%-- 							<input type="checkbox" class="Noborder" id="st_mp_business_yn" name="st_mp_business_yn" <%=CommonUtil.nvl(_rowData.get("MP_BUSINESS_YN")).equals("Y")?"checked":""%> onclick="checkMp(this);" value="Y"/>&nbsp;해당없음&nbsp;&nbsp;&nbsp; --%>
<!-- 						</td> -->
<!-- 					</tr> -->
					<tr>
						<th scope="row" class="star">ISO여부</th>
						<td colspan="2">
							<label for="st_iso_yn" class="hidden">없음</label>
							<select name="st_iso_yn" id="st_iso_yn">
								<script>kepAjaxCommonComboDataValue('st_iso_yn', 'M112', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ISO_YN")) %>');</script>
							</select>
						</td>
						<th scope="row" class="star">특허여부</th>
						<td colspan="2">
							<label for="st_license_yn" class="hidden">미보유</label>
							<select name="st_license_yn" id="st_license_yn">
								<script>kepAjaxCommonComboDataValue('st_license_yn', 'M113', 'SEL', '<%=CommonUtil.nvl(_rowData.get("LICENSE_YN")) %>');</script>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="star">전년도 매출액</th>
						<td colspan="2">
							<label for="st_year_amt" class="hidden">전년도 매출액</label>
							<select name="st_year_amt" id="st_year_amt">
								<script>kepAjaxCommonComboDataValue('st_year_amt', 'M114', 'SEL', '<%=CommonUtil.nvl(_rowData.get("YEAR_AMT")) %>');</script>
							</select>
						</td>
						<th scope="row" class="star">총자본금</th>
						<td colspan="2">
							<label for="st_capt_amt" class="hidden">총자본금</label>
							<select name="st_capt_amt" id="st_capt_amt">
								<script>kepAjaxCommonComboDataValue('st_capt_amt', 'M129', 'SEL', '<%=CommonUtil.nvl(_rowData.get("CAPT_AMT")) %>');</script>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row" class="padding">주요협력사</th>
						<td colspan="5"><input type="text" id="st_major_com" name="st_major_com" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("MAJOR_COM"))%>"  maxlength="250" onkeyup="fnCheckInputByte(this, 250);" onchange="fnCheckInputByte(this, 250);"/></td>
					</tr>
					<tr>
						<th scope="row" class="padding">직납가능지역</th>
						<td colspan="5">
							<input type="hidden" id="st_cmpy_dely_area" name="st_cmpy_dely_area" value="<%=CommonUtil.nvl(_rowData.get("DELY_AREA"))%>" />
							<input type="hidden" id="st_cmpy_dely_cnt" name="st_cmpy_dely_cnt" value="<%=_dataAreaList.size()%>" />
						<%
							for (int j=0; j<_dataAreaList.size(); j++) {
								Map<String,String> rowDataAreaList = _dataAreaList.get(j);
						%>
								<input id="st_dely_area_flag<%=j%>" name="st_dely_area_flag<%=j%>" type="checkbox" value="" style="vertical-align:middle" disabled> <%=CommonUtil.nvl(rowDataAreaList.get("TEXT1"))%>&nbsp;&nbsp;&nbsp;
								<%if((j > 0) && ((j+1)%6 == 0)){%>
									<br>
								<%}%>
							<%}%>
						</td>
					</tr>
					<tr>
						<th scope="row" class="padding">배송차량 수</th>
						<td colspan="5">
							<label for="st_deliv_equip_cnt" class="hidden">1~2대</label>
							<select name="st_deliv_equip_cnt" id="st_deliv_equip_cnt">
								<script>kepAjaxCommonComboDataValue('st_deliv_equip_cnt', 'M115', 'SEL', '<%=CommonUtil.nvl(_rowData.get("DELIV_EQUIP_CNT")) %>');</script>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
            
			<p class="text11 b">3.결제정보</p>
        	<table  class="cont_t_list06" style="width:100%;">
				<caption>회사법인 정보관리 리스트</caption>
				<colgroup>
					<col width="190px" />
					<col width="36%" />
					<col width="190px" />
					<col width="38%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="star">경리담당자</th>
						<td><input type="text" id="st_ac_emp_nm" name="st_ac_emp_nm" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("AC_EMP_NM"))%>"  maxlength="20" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);"/></td>
						<th scope="row" class="star">경리담당자연락처</th>
						<td>
							<% String[] ac_emp_tel_no = CommonUtil.nvl(_rowData.get("AC_EMP_TEL")).split("-");	%>
							<select id="st_ac_emp_tel1" name="st_ac_emp_tel1" style="width:50px;">
								<option value="02"  <%=ac_emp_tel_no[0].equals("02") ?"selected":""%>>02</option>
								<option value="031" <%=ac_emp_tel_no[0].equals("031")?"selected":""%>>031</option>
								<option value="032" <%=ac_emp_tel_no[0].equals("032")?"selected":""%>>032</option>
								<option value="033" <%=ac_emp_tel_no[0].equals("033")?"selected":""%>>033</option>
								<option value="041" <%=ac_emp_tel_no[0].equals("041")?"selected":""%>>041</option>
								<option value="042" <%=ac_emp_tel_no[0].equals("042")?"selected":""%>>042</option>
								<option value="043" <%=ac_emp_tel_no[0].equals("043")?"selected":""%>>043</option>
								<option value="044" <%=ac_emp_tel_no[0].equals("044")?"selected":""%>>044</option>
								<option value="051" <%=ac_emp_tel_no[0].equals("051")?"selected":""%>>051</option>
								<option value="052" <%=ac_emp_tel_no[0].equals("052")?"selected":""%>>052</option>
								<option value="053" <%=ac_emp_tel_no[0].equals("053")?"selected":""%>>053</option>
								<option value="054" <%=ac_emp_tel_no[0].equals("054")?"selected":""%>>054</option>
								<option value="055" <%=ac_emp_tel_no[0].equals("055")?"selected":""%>>055</option>
								<option value="061" <%=ac_emp_tel_no[0].equals("061")?"selected":""%>>061</option>
								<option value="062" <%=ac_emp_tel_no[0].equals("062")?"selected":""%>>062</option>
								<option value="063" <%=ac_emp_tel_no[0].equals("063")?"selected":""%>>063</option>
								<option value="064" <%=ac_emp_tel_no[0].equals("064")?"selected":""%>>064</option>
								<option value="070" <%=ac_emp_tel_no[0].equals("070")?"selected":""%>>070</option>
								<option value="0303" <%=ac_emp_tel_no[0].equals("0303")?"selected":""%>>0303</option>
								<option value="0502" <%=ac_emp_tel_no[0].equals("0502")?"selected":""%>>0502</option>
								<option value="0504" <%=ac_emp_tel_no[0].equals("0504")?"selected":""%>>0504</option>
								<option value="0505" <%=ac_emp_tel_no[0].equals("0505")?"selected":""%>>0505</option>
								<option value="0506" <%=ac_emp_tel_no[0].equals("0506")?"selected":""%>>0506</option>
								<option value="0507" <%=ac_emp_tel_no[0].equals("0507")?"selected":""%>>0507</option>
							</select>
							- 
							<input type="text" id="st_ac_emp_tel2" name="st_ac_emp_tel2" class="input_type_text" title="" style="width:50px;" value="<%=ac_emp_tel_no.length==3 ? ac_emp_tel_no[1] : ""%>"  maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
							- 
							<input type="text" id="st_ac_emp_tel3" name="st_ac_emp_tel3" class="input_type_text" title="" style="width:50px;" value="<%=ac_emp_tel_no.length==3 ? ac_emp_tel_no[2] : ""%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
						</td>
					</tr>
					<tr>
						<th scope="row" class="star">경리담당자휴대폰</th>
						<td>
						<% String[] ac_emp_mobile_no = CommonUtil.nvl(_rowData.get("AC_EMP_MOBILE")).split("-"); %>
						<select id="st_ac_emp_mobile1" name="st_ac_emp_mobile1" style="width:50px;">
							<option value="010" <%=ac_emp_mobile_no[0].equals("010") ?"selected":""%>>010</option>
							<option value="011" <%=ac_emp_mobile_no[0].equals("011") ?"selected":""%>>011</option>
							<option value="016" <%=ac_emp_mobile_no[0].equals("016") ?"selected":""%>>016</option>
							<option value="017" <%=ac_emp_mobile_no[0].equals("017") ?"selected":""%>>017</option>
							<option value="018" <%=ac_emp_mobile_no[0].equals("018") ?"selected":""%>>018</option>
							<option value="019" <%=ac_emp_mobile_no[0].equals("019") ?"selected":""%>>019</option>
                       	</select>
                        -
						<input type="text" id="st_ac_emp_mobile2" name="st_ac_emp_mobile2" title="" size="4" value="<%=ac_emp_mobile_no.length==3 ? ac_emp_mobile_no[1] : ""%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
                        -
						<input type="text" id="st_ac_emp_mobile3" name="st_ac_emp_mobile3" title="" size="4" value="<%=ac_emp_mobile_no.length==3 ? ac_emp_mobile_no[2] : ""%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
						</td>
						<th scope="row" class="star">경리담당자이메일</th>
						<td><input type="text" id="st_ac_emp_email" name="st_ac_emp_email" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl2(_rowData.get("AC_EMP_EMAIL"),"")%>"  maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);"/></td>
					</tr>
					<tr>
						<th scope="row" class="star">영업담당자</th>
						<td><input type="text" id="st_gr_emp_nm" name="st_gr_emp_nm" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("GR_EMP_NM"))%>"  maxlength="20" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);"/></td>
						<th scope="row" class="star">영업담당자연락처</th>
						<td>
							<% String[] gr_emp_tel_no = CommonUtil.nvl(_rowData.get("GR_EMP_TEL")).split("-");	%>
							<select id="st_gr_emp_tel1" name="st_gr_emp_tel1" style="width:50px;">
								<option value="02"  <%=gr_emp_tel_no[0].equals("02") ?"selected":""%>>02</option>
								<option value="031" <%=gr_emp_tel_no[0].equals("031")?"selected":""%>>031</option>
								<option value="032" <%=gr_emp_tel_no[0].equals("032")?"selected":""%>>032</option>
								<option value="033" <%=gr_emp_tel_no[0].equals("033")?"selected":""%>>033</option>
								<option value="041" <%=gr_emp_tel_no[0].equals("041")?"selected":""%>>041</option>
								<option value="042" <%=gr_emp_tel_no[0].equals("042")?"selected":""%>>042</option>
								<option value="043" <%=gr_emp_tel_no[0].equals("043")?"selected":""%>>043</option>
								<option value="044" <%=gr_emp_tel_no[0].equals("044")?"selected":""%>>044</option>
								<option value="051" <%=gr_emp_tel_no[0].equals("051")?"selected":""%>>051</option>
								<option value="052" <%=gr_emp_tel_no[0].equals("052")?"selected":""%>>052</option>
								<option value="053" <%=gr_emp_tel_no[0].equals("053")?"selected":""%>>053</option>
								<option value="054" <%=gr_emp_tel_no[0].equals("054")?"selected":""%>>054</option>
								<option value="055" <%=gr_emp_tel_no[0].equals("055")?"selected":""%>>055</option>
								<option value="061" <%=gr_emp_tel_no[0].equals("061")?"selected":""%>>061</option>
								<option value="062" <%=gr_emp_tel_no[0].equals("062")?"selected":""%>>062</option>
								<option value="063" <%=gr_emp_tel_no[0].equals("063")?"selected":""%>>063</option>
								<option value="064" <%=gr_emp_tel_no[0].equals("064")?"selected":""%>>064</option>
								<option value="070" <%=gr_emp_tel_no[0].equals("070")?"selected":""%>>070</option>
								<option value="0303" <%=gr_emp_tel_no[0].equals("0303")?"selected":""%>>0303</option>
								<option value="0502" <%=gr_emp_tel_no[0].equals("0502")?"selected":""%>>0502</option>
								<option value="0504" <%=gr_emp_tel_no[0].equals("0504")?"selected":""%>>0504</option>
								<option value="0505" <%=gr_emp_tel_no[0].equals("0505")?"selected":""%>>0505</option>
								<option value="0506" <%=gr_emp_tel_no[0].equals("0506")?"selected":""%>>0506</option>
								<option value="0507" <%=gr_emp_tel_no[0].equals("0507")?"selected":""%>>0507</option>
							</select>
							- 
							<input type="text" id="st_gr_emp_tel2" name="st_gr_emp_tel2" class="input_type_text" title="" style="width:50px;" value="<%=gr_emp_tel_no.length==3 ? gr_emp_tel_no[1] : ""%>"  maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
							- 
							<input type="text" id="st_gr_emp_tel3" name="st_gr_emp_tel3" class="input_type_text" title="" style="width:50px;" value="<%=gr_emp_tel_no.length==3 ? gr_emp_tel_no[2] : ""%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
						</td>
					</tr>
					<tr>
						<th scope="row" class="star">영업담당자휴대폰</th>
						<td>
						<% String[] gr_emp_mobile_no = CommonUtil.nvl(_rowData.get("GR_EMP_MOBILE")).split("-"); %>
						<select id="st_gr_emp_mobile1" name="st_gr_emp_mobile1" style="width:50px;">
							<option value="010" <%=gr_emp_mobile_no[0].equals("010") ?"selected":""%>>010</option>
							<option value="011" <%=gr_emp_mobile_no[0].equals("011") ?"selected":""%>>011</option>
							<option value="016" <%=gr_emp_mobile_no[0].equals("016") ?"selected":""%>>016</option>
							<option value="017" <%=gr_emp_mobile_no[0].equals("017") ?"selected":""%>>017</option>
							<option value="018" <%=gr_emp_mobile_no[0].equals("018") ?"selected":""%>>018</option>
							<option value="019" <%=gr_emp_mobile_no[0].equals("019") ?"selected":""%>>019</option>
                       	</select>
                        -
						<input type="text" id="st_gr_emp_mobile2" name="st_gr_emp_mobile2" title="" size="4" value="<%=gr_emp_mobile_no.length==3 ? gr_emp_mobile_no[1] : ""%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
                        -
						<input type="text" id="st_gr_emp_mobile3" name="st_gr_emp_mobile3" title="" size="4" value="<%=gr_emp_mobile_no.length==3 ? gr_emp_mobile_no[2] : ""%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
						</td>
						<th scope="row" class="star">영업담당자이메일</th>
						<td><input type="text" id="st_gr_emp_email" name="st_gr_emp_email" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl2(_rowData.get("GR_EMP_EMAIL"),"")%>"  maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);"/></td>
					</tr>
					<tr>
						<th scope="row" class="star">계약담당자</th>
						<td><input type="text" id="st_ec_emp_nm" name="st_ec_emp_nm" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("EC_USER_NAME"))%>"  maxlength="20" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);"/></td>
						<th scope="row">전자계약 내용보기</th>
						<td>
							<input type="hidden" name="st_doc_id" id="st_doc_id" value="<%=CommonUtil.nvl(_rowData.get("EC_DOC_ID"))%>">
							<span class="btn_month" title="계약보기"><a href="javascript:doAction('econtViewer');">보기</a></span>
						</td>
					</tr>
					<tr>
						<th scope="row" class="star">계약담당자휴대폰</th>
						<td>
						<% String[] ec_emp_mobile_no = CommonUtil.nvl(_rowData.get("EC_USER_TEL")).split("-"); %>
						<select id="st_ec_emp_mobile1" name="st_ec_emp_mobile1" style="width:50px;">
							<option value="010" <%=ec_emp_mobile_no[0].equals("010") ?"selected":""%>>010</option>
							<option value="011" <%=ec_emp_mobile_no[0].equals("011") ?"selected":""%>>011</option>
							<option value="016" <%=ec_emp_mobile_no[0].equals("016") ?"selected":""%>>016</option>
							<option value="017" <%=ec_emp_mobile_no[0].equals("017") ?"selected":""%>>017</option>
							<option value="018" <%=ec_emp_mobile_no[0].equals("018") ?"selected":""%>>018</option>
							<option value="019" <%=ec_emp_mobile_no[0].equals("019") ?"selected":""%>>019</option>
                       	</select>
                        -
						<input type="text" id="st_ec_emp_mobile2" name="st_ec_emp_mobile2" title="" size="4" value="<%=ec_emp_mobile_no.length==3 ? ec_emp_mobile_no[1] : ""%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
                        -
						<input type="text" id="st_ec_emp_mobile3" name="st_ec_emp_mobile3" title="" size="4" value="<%=ec_emp_mobile_no.length==3 ? ec_emp_mobile_no[2] : ""%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
						</td>
						<th scope="row" class="star">계약담당자이메일</th>
						<td><input type="text" id="st_ec_emp_email" name="st_ec_emp_email" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl2(_rowData.get("EC_USER_EMAIL"),"")%>"  maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);"/></td>
					</tr>
					<tr>						
						<th scope="row" class="star">지급조건</th>
						<td><%=CommonUtil.nvl(_rowData.get("PAY_TERMS"))%></td>
						<th scope="row" class="star">지급형태</th>
						<td><%=CommonUtil.nvl(_rowData.get("PAY_TYPE"))%></td>
						
					</tr>
					<tr>	
						<th scope="row" class="star">은행명</th>
						<td><%=CommonUtil.nvl(_rowData.get("BANK_NAME"))%></td>
						<th scope="row" class="star">계좌번호</th>
						<%
							if(p01102003 == true){
						%>
							<td><input type="text" id="st_bank_account_no" name="st_bank_account_no" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("BANK_ACCOUNT_NO"))%>"  maxlength="30" onkeyup="fnPhoneNumberCheck('st_bank_account_no');" onchange="fnPhoneNumberCheck('st_bank_account_no');"/></td>
						<%
							}else{
						%>
							<td><%=CommonUtil.nvl(_rowData.get("BANK_ACCOUNT_NO"))%><input type="hidden" name="st_bank_account_no" id="st_bank_account_no" value="<%=CommonUtil.nvl(_rowData.get("BANK_ACCOUNT_NO"))%>"></td>
						<%
							}
						%>
					</tr>
					<tr>						
						<th scope="row" class="star">예금주</th>
						<td colspan="3"><%=CommonUtil.nvl(_rowData.get("DEPOSITOR"))%></td>
					</tr>
				</tbody>
			</table>
            
			<p class="text11 b">4.SMS 및 이메일 수신여부</p>
        	<table  class="cont_t_list06" style="width:100%;">
				<caption>회사법인 정보관리 리스트</caption>
				<colgroup>
					<col width="190px" />
					<col width="36%" />
					<col width="190px" />
					<col width="38%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="star">이메일 수신여부</th>
						<td>
							<input type="radio" id="mail_send_flag1" name="mail_send_flag" value="Y" <%=CommonUtil.nvl(_rowData.get("MAIL_SEND_FLAG")).equals("Y") ? "checked" : "" %> />&nbsp;수신&nbsp;&nbsp;&nbsp;
							<input type="radio" id="mail_send_flag2" name="mail_send_flag" value="N" <%=CommonUtil.nvl(_rowData.get("MAIL_SEND_FLAG")).equals("N") ? "checked" : ""%> />&nbsp;미수신&nbsp;&nbsp;&nbsp;
							<input type="hidden" id="st_mail_send_flag" name="st_mail_send_flag" value="<%=CommonUtil.nvl(_rowData.get("MAIL_SEND_FLAG"))%>" />
						</td>
						<th scope="row" class="star">SMS 수신여부</th>
						<td>
							<input type="radio" id="sms_recv_flag1" name="sms_recv_flag" value="Y" <%=CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG")).equals("Y") ? "checked" : ""%> />&nbsp;수신&nbsp;&nbsp;&nbsp;
							<input type="radio" id="sms_recv_flag2" name="sms_recv_flag" value="N" <%=CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG")).equals("N") ? "checked" : ""%> />&nbsp;미수신&nbsp;&nbsp;&nbsp;
							<input type="hidden" id="st_sms_recv_flag" name="st_sms_recv_flag" value="<%=CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG"))%>" />
						</td>
					</tr>
				</tbody>
			</table>
            <% } %>
            <!--버튼영역-->
			<div class="btnArea">
				<div class="fr">
					<span class="btn_02"><a href="javascript:doAction('save');">수정</a></span>
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
