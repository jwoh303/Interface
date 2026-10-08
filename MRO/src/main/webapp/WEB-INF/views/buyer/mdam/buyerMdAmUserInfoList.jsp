<%--
**********************************************
* 메뉴 : 개인정보>개인정보
* 화면 : 개인정보
* 기능 : 고객사 개인정보 조회, 수정 관리
* 프로그램 ID : PG_01_B_001_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-06-16
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
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("userData"); // 조회된 결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("approvedData"); // 결재자 목록
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList3 = (List<Map<String,String>>) request.getAttribute("referData"); // 참조자 목록
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList4 = (List<Map<String,String>>) request.getAttribute("agreeData"); // 합의자 목록

String com_code = CommonUtil.nvl((String)_sessionInfo.getComCode());
String st_lastlogin_date =CommonUtil.nvl((String)_sessionInfo.getLastLoginDate()); //마지막로그인 시간.
String st_open_yn = CommonUtil.nvl((String) request.getParameter("st_open_yn"),"");  // 요청부서명

String user_type = _sessionInfo.getUserType();
//p060000057 일반사용자 배송지변경 불가 SLOGIC
boolean p060000057= CommonUtil.getSpecialCheckReturn(com_code,"P06-0000057");
//p060000059 결재지정/변경 버튼 비활성화 SLOGIC
boolean p060000059= CommonUtil.getSpecialCheckReturn(com_code,"P06-0000059");
//p060000112 도착지입력 기능 추가
boolean p060000112 = CommonUtil.getSpecialCheckReturn(com_code,"P06-0000112");
Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}

String _approved = "";
String _db_name = "";
String _to_str_id = "";

if (_dataList2 != null && _dataList2.size() != 0) { 
	for (int i=0; i < _dataList2.size(); i++) {
		Map<String,String> _rowData2 = null;
		_rowData2 = _dataList2.get(i);
		if (i+1 == _dataList2.size()) {
			_approved += _rowData2.get("APPR_NAME") +"";
		} else {
			_approved += _rowData2.get("APPR_NAME")+" >> ";
		}
		
		_db_name+= _rowData2.get("APPR_ID")+"@@"+_rowData2.get("APPR_NAME")+"@@"+_rowData2.get("APPR_SEQ")+"@@"+_rowData2.get("GUBUN")+"^||^";
		_to_str_id += _rowData2.get("APPR_ID") + ",";
	}
 }
	
String _refer = "";
String _cc_str_id = "";

if (_dataList3 != null && _dataList3.size() != 0) { 
	for (int i=0; i < _dataList3.size(); i++) {
		Map<String,String> _rowData3 = null;
		_rowData3 = _dataList3.get(i);
		if (i+1 == _dataList3.size()) {
			_refer += _rowData3.get("APPR_NAME") +"";
		} else {
			_refer += _rowData3.get("APPR_NAME")+" >> ";
		}
		
		_db_name+= _rowData3.get("APPR_ID")+"@@"+_rowData3.get("APPR_NAME")+"@@"+_rowData3.get("APPR_SEQ")+"@@"+_rowData3.get("GUBUN")+"^||^";
		_cc_str_id += _rowData3.get("APPR_ID") + ",";
	}
 }	

String _agree = "";
String _ag_str_id = "";

if (_dataList4 != null && _dataList4.size() != 0) { 
	for (int i=0; i < _dataList4.size(); i++) {
		Map<String,String> _rowData4 = null;
		_rowData4 = _dataList4.get(i);
		if (i+1 == _dataList4.size()) {
			_agree += _rowData4.get("APPR_NAME") +"";
		} else {
			_agree += _rowData4.get("APPR_NAME")+" >> ";
		}
		
		_db_name+= _rowData4.get("APPR_ID")+"@@"+_rowData4.get("APPR_NAME")+"@@"+_rowData4.get("APPR_SEQ")+"@@"+_rowData4.get("GUBUN")+"^||^";
		_ag_str_id += _rowData4.get("APPR_ID") + ",";
	}
 }

String p01_1010_05 = CommonUtil.getSpecialCheckReturn(com_code,"P01-1010-05","COL01_DATA", request); // 고객사별 사번 라벨명
if(p01_1010_05 == null){
	p01_1010_05 = CommonLang.get("HTITLE454");	//사번
}else if("".equals(p01_1010_05)){
	p01_1010_05 = CommonLang.get("HTITLE454");	//사번
}

//p01_1010_06 사번값 필수 고객사 SLOGIC
boolean p01_1010_06 = CommonUtil.getSpecialCheckReturn(com_code,"P01-1010-06"); 

%>

<script type="text/javascript">
<!--
var popupSel = "";

//최초 화면 함수 
function kep_onload_view() {
	<% if (_dataList==null || _dataList.size()==0) { %>
		<% if (!"Y".equals(st_open_yn)) {%>
		doAction('search');
		<%}%>
	<% } %>
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
		case "search":						//조회
			kepSearch();
			break;
		case "save":							// 저장 ssl 적용
		
			if (checkSubmit()) {
				kepAjaxFormCall("/mdam/updateBuyerMdAmUserInfoList.do","contentForm", str);
			}
			break;
		case "pwdValidCheck":  
			if (passwordValidCheck()) {
				kepAjaxFormCall("/mdam/pwdValidCheckBuyerMdAmUserInfo.do","contentForm", str);
			}
			break;
		case "pwdSave":
		    if ($("#chkPassword").val() != "Y") {
		    	doAction("pwdValidCheck");
		    	return;
		    }
			break;
	}
}

// 조회
function kepSearch() {
	$('#searchForm').attr("action", "/mdam/getBuyerMdAmUserInfoList.do").submit();   
}
  
//팝업함수호출
function doPop(str, val, val2) {
	popupSel = str;
	
	switch (str) {
		case "dept":
			openSearchPopup("/common/deptCodeAdminPop.do", "?com_code=" + val + "&open=Y", "500,500,no");	
			break;
		case "position":
			openSearchPopup("/common/getPositionCodePop.do", "?com_code="+val+"&type=C003", "500,420,no");			
			break;
		case "purchase_dept":
			openSearchPopup("/coco/showCommonCoCoOrderDepartmentSearchPop.do", "?com_code="+val, "680,500,no");				
			break;
		case "role":
			openSearchPopup("/coco/showCommonCoCoAuthorityRegPop.do","?st_role_code=" + $("#st_role").val().replace("+", "@") + "&st_user_type=" + val, "200, 240,no");
			break;
		case "location":
			openSearchPopup("/common/delLocationPop.do", "?com_code=" + val + "&del_code="+val2, "500,500,no");					
			break;
		case "approved":
			if ($("#st_icogpass").val() == "0") {
				alert("<%=CommonLang.msg("MSG310") %>");	//전자결재 범위가 지정되어 있지 않습니다.\n\n전자결재 범위를 지정한 후 결재선을 수정하여 주십시요.
				return;
			}
			openSearchPopup("/coco/showCommonCoCoApprovalAppointPop.do", "?to=" + $("#to").val() + "&cc=" + $("#cc").val() + "&cur_order_no=1&type=APSE", "1000,660,no");						
			break;
		case "recvMailPop": // 메일수신항목
			if(document.getElementById("mail_recv_flag1").checked == false){
				alert("<%=CommonLang.msg("MSG506") %>");	//메일 수신여부가 미수신일 경우 메일 수신항목을 지정 할 수 없습니다.
				return;					
			}
			var st_mail_recv = $("#st_mail_recv").val();
			openSearchPopup("/common/getUserMailRecvChoicePop.do", '?st_mail_recv='+st_mail_recv, "520,270,no");
			break;
		case "addLocation": //도착지 입력기능.
			openSearchPopup("/common/delLocationAddPop.do", "?com_code=" + val, "900,500,no");					
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text, val) {
	//팝업 조회후 해당 항목에 값을 셋팅
	
	switch (popupSel) {
		case "dept":
			if ( "<%=com_code%>" == "KRKEPB0004" || "<%=com_code%>" == "KRDHIM0002" ) {
				if ( Number(val) >= 2) {
					alert(text +" <%=CommonLang.msg("MSG311") %> " + val + "<%=CommonLang.msg("MSG439") %>");	//부서는 현재 	명 입니다.
				}
			}

			$("#st_department").val(code);
			$("#st_department_text").val(text +" / " + code);
			break;
		case "position":
			$("#st_position").val(code);
			$("#st_position_text").val(text);
			break;
		case "purchase_dept":
			$("#st_purchase_dept").val(code);
			$("#st_purchase_dept_text").val(text);
			break;
		case "role":
			$("#st_role").val(code);
			$("#st_role_text").text(text);
			break;
		case "location":
			$("#st_dely_to_location").val(code);
			$("#st_dely_text").val(text);
			break;
		case "approved":
			$("#kto").val(text);
			break;
		case "recvMailPop"://메일수신 항목 셋팅
			$("#st_mail_recv").val(code);//매일수신항목 저장
			$("img[id=mail_select_img]").attr("src", "/resources/images/icon.gif");
			break;
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	
	if (pMethod == "pwdValidCheck") {
		if (sMsg != 'OK') {
			alert(sMsg);
			$("#st_password").val("");
			$("#st_password").focus();
			return;
		} else {
			$("#chkPassword").val("Y");
			//비밀번호를 수정 하시겠습니까?
		    if(confirm(" <%=CommonLang.msg("MSG333") %>")){
		    	kepAjaxFormCall("/mdam/saveSellerMdAmUsePwd.do","contentForm", "pwdSave");
				return;
		    }
		}
	} else if (pMethod == "save") {
		if (sMsg == 'OK') {
			alert("<%=CommonLang.msg("MSG312") %>");	//사용자 정보 수정이 완료되었습니다.
         // 처리후 재조회
    		doAction("search");
		} else if (sMsg == "ERR") {
			alert("<%=CommonLang.msg("MSG313") %>");	//사용자 정보 수정이 실패 하였습니다.\n다시 확인하여 주십시요!
            return;
        } else {
			alert(sMsg);
			return;
		}
	}else if(pMethod == "pwdSave"){
		if (sMsg == 'OK') {
			alert("<%=CommonLang.msg("MSG314") %>");	//비밀번호 변경이 완료되었습니다.
			// 처리후 재조회
        	doAction("search");
		} else if (sMsg == "ERR") {
			alert("<%=CommonLang.msg("MSG503") %>");	//비밀번호 변경이 실패 하였습니다. 다시 확인하여 주십시요!
            return;
		} else if (sMsg == "ERR_MATCH"){
			alert("<%=CommonLang.msg("MSG504") %>");	//현재 비밀번호가 일치하지 않습니다.
			$("#st_password_present").focus();
			return;
		} else {
			alert(sMsg);
			return;
		}
	}
}

function  kepAjaxError(pMethod , response) {
	alert("<%=CommonLang.msg("MSG418") %>");	//오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.   
} 

function checkSubmit() {
	
	if (isEmpty($("#st_user_name_loc").val())) {
		alert(" <%=CommonLang.msg("MSG315") %>");	//사용자 이름이 입력되지 않았습니다. 
		$("#st_user_name_loc").focus();
		return false;
	}

	if (isEmpty($("#st_email").val())) {
		alert(" <%=CommonLang.msg("MSG316") %>");	//Email 주소가 입력되지 않았습니다.
		$("#st_email").focus();
		return false;
    }
	
	if (!checkemail("st_email")) {
		return false;
	}
	
	if ($("#st_user_type").val() == "U" &&  $("#change_user_type").val() == "A") {
        alert("<%=CommonLang.msg("MSG317") %>");	//사용자 구분 변경시에는 \n(일반사용자->Admin사용자)\n운영자의 승인 후에 반영됩니다.   
	}
	
	if (isEmpty($("#st_mobile_phone1").val())) {
		alert(" <%=CommonLang.msg("MSG321") %>");	//핸드폰 번호가 입력되지 않았습니다.
		$("#st_mobile_phone1").focus();
		return false;
	}
	
	if (isEmpty($("#st_mobile_phone2").val())) {
		alert(" <%=CommonLang.msg("MSG321") %>");	//핸드폰 번호가 입력되지 않았습니다.
		$("#st_mobile_phone2").focus();
		return false;
	}
	
	if (isEmpty($("#st_mobile_phone3").val())) {
		alert(" <%=CommonLang.msg("MSG321") %>");	//핸드폰 번호가 입력되지 않았습니다.
		$("#st_mobile_phone3").focus();
		return false;
	}
	
	if ($("#st_mobile_phone1").val().length != 3  || $("#st_mobile_phone2").val().length<3 || $("#st_mobile_phone3").val().length !=4) { 
		alert( "<%=CommonLang.msg("MSG322") %>" );	//핸드폰 번호를 정확히 입력하세요.
		$("#st_mobile_phone1").focus();
		return false;
	}

	$("#st_mobile_phone").val($("#st_mobile_phone1").val() + "-" + $("#st_mobile_phone2").val() + "-" + $("#st_mobile_phone3").val());  
	
    if (isEmpty($("#st_phone_number").val())) {
		alert(" <%=CommonLang.msg("MSG324") %>");	//전화번호가 입력되지 않았습니다.
		$("#st_phone_number").focus();
		return false;
	}
	
	dial = $("#st_phone_number").val().substring(0,2);
	if(dial == '01'){ <%-- 휴대폰 번호 앞자리 (010 ~ 019) 판별을 위해--%>
		alert(" 전화번호에 휴대폰 번호는 입력하실 수 없습니다.");
		return false;
	}
	
	if(isEmpty($("#st_department_text").val())) {
		alert(" <%=CommonLang.msg("MSG325") %>");	//부서가 입력되지 않았습니다.
		return false;
    }

    if (isEmpty($("#st_position_text").val())) {
		alert( "<%=CommonLang.msg("MSG326") %>");	//직급이 입력되지 않았습니다. 
		return false;
	}

    <%--사번 필수값 확인--%>
    <%if(p01_1010_06 == true){%>
		if(isEmpty(kepTrim("st_legacy_user_id"))){
			alert("<%=p01_1010_05%>" +"은 필수 값입니다.");
			return false;
		}
	<%}%>
	
	<%--사번 공백 불가--%>
	if (kepTrim("st_legacy_user_id") != $("#st_legacy_user_id").val()){
		alert("<%=p01_1010_05%>" +"은 공백을 포함할 수 없습니다.");
		$("#st_legacy_user_id").focus();	
		return false;
	}

    $("#st_mail_recv_flag").val($("input[name=mail_recv_flag]:checked").val());
    $("#st_sms_recv_flag").val($("input[name=sms_recv_flag]:checked").val());
    $("#st_person_author").val($("input[name=person_author]:checked").val());
    $("#st_two_factor_flag").val($("input[name=two_factor_flag]:checked").val());
    $("#st_chg_info_pwd_flag").val($("input[name=chg_info_pwd_flag]:checked").val());

    if (isEmpty($("#st_dely_to_location").val())) {
		alert(" <%=CommonLang.msg("MSG327") %>");	//도착지가 입력되지 않았습니다.
		return false;
	}
    
	if (isEmpty($("#st_chg_info_pwd_flag").val())) {
		alert(" <%=CommonLang.msg("MSG560") %>");	//추가인증 여부(개인정보변경)를 선택하여 주십시오.
		return false;
	}
    
    return confirm(" <%=CommonLang.msg("MSG334") %>");	//사용자 정보를 수정 하시겠습니까?
}

function passwordValidCheck() {
	$("#chkPassword").val("N");
	
	if ($("#st_password_present").val().length == 0) {
		//현재 비밀번호가 입력되지 않았습니다.
		alert("<%=CommonLang.msg("MSG505") %>");
		$("#st_password_present").focus();
		return false;
	}
	
	if ($("#st_password").val().length == 0) {
		//비밀번호가 입력되지 않았습니다. 
		alert("<%=CommonLang.msg("MSG328") %>");
		$("#st_password").focus();
		return false;
	}
    
	if (checkSpace($("#st_password").val()) && $("#st_password").val() !="") {
		//비밀번호에 공백문자은 입력할 수 없습니다.   
		alert("<%=CommonLang.msg("MSG329") %>");
        $("#st_password").val("");
        $("#st_password").focus();
        return false;
    }
	
	if ($("#st_password").val().length < 8) {
		//비밀번호는 8 자리 이상 사용해야 합니다.
		alert("<%=CommonLang.msg("MSG330") %>");
		$("#st_password").focus();
		$("#st_password").select();
		return false;
	}

	if ( $("#st_password").val().length < chkKorea($("#st_password").val())) {
		//비밀번호는 영문으로 입력해 주십시요.
		alert("<%=CommonLang.msg("MSG331") %>");
		$("#st_password").focus();
		return false;
	}
	
	if ($("#st_password_confirm").val().length == 0) {
		//비밀번호가 입력되지 않았습니다. 
		alert("<%=CommonLang.msg("MSG328") %>");
		$("#st_password_confirm").focus();
		return false;
	}
	
	if (checkSpace($("#st_password_confirm").val()) && $("#st_password_confirm").val() !="") {
		//비밀번호에 공백문자은 입력할 수 없습니다.    
		alert("<%=CommonLang.msg("MSG329") %>");
        $("#st_password_confirm").val("");
        $("#st_password_confirm").focus();
        return false;
    }
	
	if ($("#st_password_confirm").val().length < 8) {
		//비밀번호는 8 자리 이상 사용해야 합니다.
		alert("<%=CommonLang.msg("MSG330") %>");
		$("#st_password_confirm").focus();
		return false;
	}
	
	if ( $("#st_password_confirm").val().length < chkKorea($("#st_password_confirm").val())) {
		//비밀번호는 영문으로 입력해 주십시요.
		alert("<%=CommonLang.msg("MSG331") %>");
		$("#st_password_confirm").focus();
		return false;
	}
	
	if ( $("#st_password").val() != $("#st_password_confirm").val()) {
		//비밀번호가 일치하지 않습니다.\n다시 한번 입력하시기 바랍니다.
		alert("<%=CommonLang.msg("MSG332") %>");
		$("#st_password").focus();
		return false;
	}

	return true;
}

// ISMS Cache 사용 제한 - bfcache(뒤로가기, 앞으로가기) 감지하여 로그아웃 만들도록 수정 2024.05.29 HSJ
window.onpageshow = function(event) {
	if(event.persisted || (window.performance && window.performance.navigation.type == 2)){
		doAction('search');
	}
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
	<h3><%=CommonLang.get("HTITLE445") %><!-- 개인정보 --></h3>

	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post" >
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_open_yn" id="st_open_yn"  value="Y">
	</form>			

	<form name="contentForm" id="contentForm" method="post" onsubmit="return false;">
	<input type="hidden" name="st_com_code" id="st_com_code"  value="<%=com_code%>">
	<input type="hidden" id="st_zip_code" name="st_zip_code" value="" />
	<input type="hidden" id="st_zip_key" name="st_zip_key" value="" />
	<input type="hidden" id="st_address" name="st_address" value="" />
	<input type="hidden" id="st_address_dt" name="st_address_dt" value="" />
	<input type="hidden" id="st_address_eng" name="st_address_eng" value="" />
	<input type="hidden" id="st_country_code" name="st_country_code" value="KR" />
	<input type="hidden" id="st_city_code" name="st_city_code" value="KRSEL" />
	<!-- 공통 -->
	<b><%=CommonLang.get("HTITLE447") %><!-- [LOG IN 정보] --></b>
	<% if (_rowData != null) {  %>
		<table  class="cont_t_list06" style="width:100%;">
			<caption>LOG IN 정보</caption>
			<colgroup>
				<col width="120px" />
				<col width="32%" />
				<col width="120px" />
				<col width="32%" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><%=CommonLang.get("HTITLE324") %><!-- ID --></th>
                    <td class="left" >
                    	<%=CommonUtil.nvl(_rowData.get("USER_ID"))%>
                    	<input type="hidden" name="st_status" id="st_status"  value="<%=CommonUtil.nvl(_rowData.get("STATUS"))%>">
                    </td>
                    <th scope="row" class="star"><%=CommonLang.get("HTITLE891") %><!-- 현재 PASSWORD --></th>
					<td><input type="password" id="st_password_present" name="st_password_present" class="input_type_text" title=""  maxlength="24" style="width:80%; ime-mode:disabled;" value="" /></td>
				</tr>
				<tr>
					<th scope="row" class="star"><%=CommonLang.get("HTITLE448") %><!-- PASSWORD --></th>
					<td>
						<input type="hidden" name="chkPassword" id="chkPassword"  value="<%=CommonUtil.nvl(_rowData.get("CHKPASSWORD"))%>" />
						<input type="password" id="st_password" name="st_password" class="input_type_text" title=""  maxlength="24" style="width:70%; ime-mode:disabled;" value="<%=CommonUtil.nvl(_rowData.get("PASSWORD"))%>" />&nbsp;&nbsp;&nbsp;
						<font color="#FF0000" title="<%=CommonLang.get("HTITLE897") %>
<%=CommonLang.get("HTITLE898") %>
<%=CommonLang.get("HTITLE899") %>
<%=CommonLang.get("HTITLE900") %>"><b><%=CommonLang.get("HTITLE449") %><!-- ※규정 --></b></font>	
<!-- 1. 8자리 이상 사용해야 합니다.
 2. 혼합(영문자+숫자+특수문자) 사용해야 합니다.
 3. 변경주기는 90일 입니다.
 4. 아이디와 동일하게 사용할수 없습니다. -->
					</td>
		                        <th scope="row" class="star"><%=CommonLang.get("HTITLE450") %><!-- PASSWORD 확인 --></th>
		                      	<td><input type="password" id="st_password_confirm" name="st_password_confirm" class="input_type_text" title=""  maxlength="24" style="width:80%; ime-mode:disabled;" value="<%=CommonUtil.nvl(_rowData.get("PASSWORD"))%>" /></td>
	                  </tr>
	                  <tr>
	                      <th scope="row" class="star"><%=CommonLang.get("HTITLE451") %><!-- 이름(국문) --></th>
	                    	<td><input type="text" id="st_user_name_loc" name="st_user_name_loc" class="input_type_text" title=""  maxlength="40" style="width:80%;" onkeyup="fnCheckInputByte(this, 40);" onchange="fnCheckInputByte(this, 40);" value="<%=CommonUtil.nvl(_rowData.get("USER_NAME_LOC"))%>" /></td>
	                      <th scope="row"><%=CommonLang.get("HTITLE452") %><!-- 이름(영문) --></th>
	                    	<td><input type="text" id="st_user_name_eng" name="st_user_name_eng" class="input_type_text" title="" style="width:80%; ime-mode:disabled;" maxlength="40" value="<%=CommonUtil.nvl(_rowData.get("USER_NAME_ENG"))%>" /></td>
	                  </tr>
	                  <tr>
	                      <th scope="row" class="star"><%=CommonLang.get("HTITLE453") %><!-- 사용언어 --></th>
	                    	<td>
	                    		<select id="st_lang" name="st_lang">
				              <option value="KR" <%=CommonUtil.nvl(_rowData.get("LANG")).equals("KR")?"selected":""%>>Korean</option>
				              <option value="US" <%=CommonUtil.nvl(_rowData.get("LANG")).equals("US")?"selected":""%>>English</option>
				              <option value="CP" <%=CommonUtil.nvl(_rowData.get("LANG")).equals("CP")?"selected":""%>>Chinese</option>
				              <option value="JP" <%=CommonUtil.nvl(_rowData.get("LANG")).equals("JP")?"selected":""%>>Japanese</option>
				            </select>
	                    	</td>
	                    	<th scope="row"><%if(p01_1010_06 == true){%><span class="f_red">*</span><%}%><%=p01_1010_05%></th>
	                      	<td><input type="text" id="st_legacy_user_id" name="st_legacy_user_id" class="input_type_text" title="" style="width:80%; ime-mode:disabled;" maxlength="40" value="<%=CommonUtil.nvl(_rowData.get("LEGACY_USER_ID"))%>" /></td>
	                  </tr>
			</tbody>
		</table>	
		<br />
		<b><%=CommonLang.get("HTITLE455") %><!-- [USER 정보] --></b>
		<table  class="cont_t_list06" style="width:100%;">
	              <caption>USER 정보</caption>
	              <colgroup>
	                  <col width="120px" />
	                  <col width="32%" />
	                  <col width="120px" />
	                  <col width="32%" />
	              </colgroup>
	              <tbody>
	                  <tr>
							<th scope="row" class="star"><%=CommonLang.get("HTITLE456") %><!-- E-mail --></th>
	                    	<td><input type="text" id="st_email" name="st_email"class="input_type_text" title="" style="width:80%;" maxlength="100" value="<%=CommonUtil.nvl(_rowData.get("EMAIL"))%>" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" /> </td>
							<th scope="row" class="star"><%=CommonLang.get("HTITLE457") %><!-- 사용자구분 --></th>
							<td>
	                    		<%=CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("U") ? "일반사용자" : (CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("A") ? "Admin사용자" : "운영자")%>&nbsp; ⇒ &nbsp;
	                    		<input type="hidden" id="st_user_type" name="st_user_type" value="<%=CommonUtil.nvl(_rowData.get("USER_TYPE"))%>" />
	                    		<select id="change_user_type"  name="change_user_type" >
							<% if(CommonUtil.nvl(_rowData.get("CHANGE_USER_TYPE")).equals("M")) { %>
							<option <%=CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("M")?"selected":""%> value="M"><%=CommonLang.get("HTITLE793") %><!-- 운영자 --></option>
							<% } %>
							<option <%=CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("A")?"selected":""%> value="A"><%=CommonLang.get("HTITLE458") %><!-- Admin사용자 --></option>
							<option <%=CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("U")?"selected":""%> value="U"><%=CommonLang.get("HTITLE459") %><!-- 일반사용자 --></option>
						</select>
	                    	</td>
	                  </tr>
	                  <tr>
	                      <th scope="row" class="star"><%=CommonLang.get("HTITLE462") %><!-- 핸드폰 --></th>
	                    	<td colspan="3">
	                    	<% 
	                    	String _mobilePhone1 = "";
	               			String _mobilePhone2 = "";
	               			String _mobilePhone3 = "";	
	                    	if (!CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).equals("")) {
	                    		_mobilePhone1 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[0];
	                      		_mobilePhone2 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[1];
	                      		_mobilePhone3 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[2];
	                    	}
	                    	%>
	                    		<input type="hidden" id="st_mobile_phone" name="st_mobile_phone"  value="<%=CommonUtil.nvl(_rowData.get("MOBILE_PHONE"))%>" />
	                    		<input type="text" id="st_mobile_phone1" name="st_mobile_phone1" class="input_type_text" title="" style="width:40px;" maxlength="3" value="<%=_mobilePhone1%>"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> -
	                    		<input type="text" id="st_mobile_phone2" name="st_mobile_phone2" class="input_type_text" title="" style="width:50px;" maxlength="4" value="<%=_mobilePhone2%>"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> -
	                    		<input type="text" id="st_mobile_phone3" name="st_mobile_phone3" class="input_type_text" title="" style="width:50px;" maxlength="4" value="<%=_mobilePhone3%>"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
	                     	</td>
	                  </tr>
	                  <tr>
	                      <th scope="row" class="star"><%=CommonLang.get("HTITLE326") %><!-- 전화번호 --></th>
	                    	<td><input type="text" id="st_phone_number" name="st_phone_number" class="input_type_text" title="" style="width:80%;" maxlength="30" onkeyup="fnPhoneNumberCheck('st_phone_number');" onchange="fnPhoneNumberCheck('st_phone_number');" value="<%=CommonUtil.nvl(_rowData.get("PHONE_NUMBER")) %>" /></td>
	                    	<th scope="row"><%=CommonLang.get("HTITLE463") %><!-- FAX --></th>
	                    	<td><input type="text" id="st_fax_number" name="st_fax_number" class="input_type_text" title="" style="width:80%;" maxlength="30" onkeyup="fnPhoneNumberCheck('st_fax_number');" onchange="fnPhoneNumberCheck('st_fax_number');"  value="<%=CommonUtil.nvl(_rowData.get("FAX_NUMBER")) %>" /></td>
	                  </tr>
			</tbody>
		</table>	
		<br />
		<b><%=CommonLang.get("HTITLE464") %><!-- [환경설정] --></b>
		<table  class="cont_t_list06" style="width:100%;">
	              <caption>환경설정</caption>
	              <colgroup>
	                  <col width="120px" />
	                  <col width="32%" />
	                  <col width="120px" />
	                  <col width="32%" />
	              </colgroup>
	              <tbody>
	                  <tr>
	                      <th scope="row"><%=CommonLang.get("HTITLE465") %><!-- 조회개수 --></th>
	                    	<td>
	                    		<select id="st_row_cnt" name="st_row_cnt" >
							<option value="10" <%=CommonUtil.nvl(_rowData.get("ROW_CNT")).equals("10")?"selected":""%>> 10 </option>
							<option value="20" <%=CommonUtil.nvl(_rowData.get("ROW_CNT")).equals("20")?"selected":""%>> 20 </option>
							<option value="30" <%=CommonUtil.nvl(_rowData.get("ROW_CNT")).equals("30")?"selected":""%>> 30 </option>
							<option value="40" <%=CommonUtil.nvl(_rowData.get("ROW_CNT")).equals("40")?"selected":""%>> 40 </option>
							<option value="50" <%=CommonUtil.nvl(_rowData.get("ROW_CNT")).equals("50")?"selected":""%>> 50 </option>
						</select>
	                    	</td>
	                     <th scope="row"><%=CommonLang.get("HTITLE469") %><!-- SMS수신여부 --></th>
	                    	<td>
	                    		<input type="hidden" id="st_img_view_flag" name="st_img_view_flag" value="<%=CommonUtil.nvl(_rowData.get("IMG_VIEW_FLAG"))%>" />
	                    		<input type="radio" id="sms_recv_flag1" name="sms_recv_flag" value="Y"  <% if (CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;<%=CommonLang.get("HTITLE470") %><!-- 받겠습니다. -->&nbsp;&nbsp;&nbsp;
	                     		<input type="radio" id="sms_recv_flag2" name="sms_recv_flag" value="N"  <% if (!CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;<%=CommonLang.get("HTITLE471") %><!-- 받지않습니다. -->
	                     		<input type="hidden" id="st_sms_recv_flag" name="st_sms_recv_flag" value="<%=CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG"))%>" />
	                    	</td>
	                  </tr>
	                  <tr>
	                    	<th scope="row"><%=CommonLang.get("HTITLE472") %><!-- 메일수신여부 --></th>
	                    	<td>
	                    		<input type="radio" id="mail_recv_flag1" name="mail_recv_flag" value="Y"  <% if (CommonUtil.nvl(_rowData.get("MAIL_RECV_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;<%=CommonLang.get("HTITLE470") %><!-- 받겠습니다. -->&nbsp;&nbsp;&nbsp;
	                     		<input type="radio" id="mail_recv_flag2" name="mail_recv_flag" value="N"  <% if (!CommonUtil.nvl(_rowData.get("MAIL_RECV_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;<%=CommonLang.get("HTITLE471") %><!-- 받지않습니다. -->
	                     		<input type="hidden" id="st_mail_recv_flag" name="st_mail_recv_flag"  value="<%=CommonUtil.nvl(_rowData.get("MAIL_RECV_FLAG"))%>" />
	                     	</td>
	                     	<th scope="row"><%=CommonLang.get("HTITLE892") %><!-- 메일수신항목 --></th>
	                    	<td>
	                    		<input type="hidden" name="st_mail_recv" id="st_mail_recv" value="<%=CommonUtil.nvl(_rowData.get("MAIL_RECV_CHOICE"))%>">
					            <%if("".equals(CommonUtil.nvl(_rowData.get("MAIL_RECV_CHOICE"))) || null == CommonUtil.nvl(_rowData.get("MAIL_RECV_CHOICE"))){%>
					            	<a class="hyperLink" href="javascript:doPop('recvMailPop', '<%=_rowData.get("MAIL_RECV_CHOICE") %>');"><img name="mail_select_img" id="mail_select_img" src="/resources/images/icon2.gif"></a>
					            <%}else{%>
					            	<a class="hyperLink" href="javascript:doPop('recvMailPop', '');"><img name="mail_select_img" id="mail_select_img" src="/resources/images/icon.gif"></a>
					            <%}%>
	                    	</td>
	                  </tr>
<%if("A".equals(user_type)){%>	                  
	                <tr>
						<th scope="row"><%=CommonLang.get("HTITLE969") %><!-- 추가인증 여부(개인정보변경) --></th>
						<td>
							<input type="radio" id="chg_info_pwd_flag1" name="chg_info_pwd_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("CHG_INFO_PWD_YN")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;<%=CommonLang.get("HTITLE932") %><!-- 사용 -->&nbsp;&nbsp;&nbsp;
							<input type="radio" id="chg_info_pwd_flag2" name="chg_info_pwd_flag" value="N" <% if (CommonUtil.nvl(_rowData.get("CHG_INFO_PWD_YN")).equals("N")) { %>checked="checked"<% } %> />&nbsp;<%=CommonLang.get("HTITLE933") %><!-- 미사용 -->
							&nbsp;&nbsp;<font color="red"><b>※ <%=CommonLang.msg("MSG561") %> <!-- 재접속 후 적용됩니다. --></b></font>
						</td>
	                	<th scope="row"><%=CommonLang.get("HTITLE931") %><!-- 추가인증 여부(로그인) --></th>
	                	<td>
	                		<input type="radio" id="two_factor_flag1" name="two_factor_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("TWO_FACTOR_YN")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;<%=CommonLang.get("HTITLE932") %><!-- 사용 -->&nbsp;&nbsp;&nbsp;
	                		<input type="radio" id="two_factor_flag2" name="two_factor_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("TWO_FACTOR_YN")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;<%=CommonLang.get("HTITLE933") %><!-- 미사용 -->
	                   	</td>
	                </tr>
<%}else{%>
					<tr>
						<th scope="row"><%=CommonLang.get("HTITLE969") %><!-- 추가인증 여부(개인정보변경) --></th>
						<td colspan="3">
							<input type="radio" id="chg_info_pwd_flag1" name="chg_info_pwd_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("CHG_INFO_PWD_YN")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;<%=CommonLang.get("HTITLE932") %><!-- 사용 -->&nbsp;&nbsp;&nbsp;
							<input type="radio" id="chg_info_pwd_flag2" name="chg_info_pwd_flag" value="N" <% if (CommonUtil.nvl(_rowData.get("CHG_INFO_PWD_YN")).equals("N")) { %>checked="checked"<% } %> />&nbsp;<%=CommonLang.get("HTITLE933") %><!-- 미사용 -->
							&nbsp;&nbsp;<font color="red"><b>※ <%=CommonLang.msg("MSG561") %> <!-- 재접속 후 적용됩니다. --></b></font>
						</td>
					</tr>
<%}%>
					<input type="hidden" id="st_two_factor_flag" name="st_two_factor_flag"  value="<%=CommonUtil.nvl(_rowData.get("TWO_FACTOR_YN"))%>" />
					<input type="hidden" id="st_old_two_factor_flag" name="st_old_two_factor_flag"  value="<%=CommonUtil.nvl(_rowData.get("TWO_FACTOR_YN"))%>" />
					<input type="hidden" id="st_chg_info_pwd_flag" name="st_chg_info_pwd_flag"  value="<%=CommonUtil.nvl(_rowData.get("CHG_INFO_PWD_YN"))%>" />
					<input type="hidden" id="st_old_chg_info_pwd_flag" name="st_old_chg_info_pwd_flag"  value="<%=CommonUtil.nvl(_rowData.get("CHG_INFO_PWD_YN"))%>" />
			</tbody>
		</table>	
		<br />
		<b><%=CommonLang.get("HTITLE473") %><!-- [회사정보] --></b>
		<table  class="cont_t_list06" style="width:100%;">
	              <caption>회사정보</caption>
	              <colgroup>
	                  <col width="120px" />
	                  <col width="32%" />
	                  <col width="120px" />
	                  <col width="32%" />
	              </colgroup>
	              <tbody>
	                  <tr>
	                      <th scope="row" class="star"><%=CommonLang.get("HTITLE474") %><!-- 회사명 --></th>
	                    	<td colspan="3"><%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC")) %></td>
	                  </tr>
	                  <tr>
	                      <th scope="row" class="star"><%=CommonLang.get("HTITLE332") %><!-- 법인그룹 --></th>
	                    	<td><%=CommonUtil.nvl(_rowData.get("CORP_NAME"))%></td>
	                    	<th scope="row" class="star"><%=CommonLang.get("HTITLE475") %><!-- 사업자번호 --></th>
	                    	<td><%=CommonUtil.nvl(_rowData.get("IRS_NO"))%></td>
	                  </tr>
	                  <tr>
	                      <th scope="row" class="star"><%=CommonLang.get("HTITLE977") %><!-- 부서(명/코드) --></th>
	                    	<td>
	                    		<input type="text" id="st_department_text" name="st_department_text" class="input_type_text" title=""  maxlength="50" style="width:80%;"  value="<%=CommonUtil.nvl(_rowData.get("DEPARTMENT_TEXT")) %> / <%=CommonUtil.nvl(_rowData.get("DEPARTMENT")) %>"  readonly/>
	                    		<input type="hidden" id="st_department" name="st_department" value="<%=CommonUtil.nvl(_rowData.get("DEPARTMENT")) %>" />
	                    		<%if("A".equals(user_type)){%>
	                    			<a href="javascript:doPop('dept', '<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>');"><img src="/resources/images/btn_search03.gif"></a>
	                    		<% } %>
	                    	</td>
	                    	<th scope="row"  class="star"><%=CommonLang.get("HTITLE476") %><!-- 직급 --></th>
	                    	<td>
	                    		<input type="text" id="st_position_text" name="st_position_text" class="input_type_text" title="" maxlength="50"  style="width:80%;"  value="<%=CommonUtil.nvl(_rowData.get("POSITION_TEXT")) %>"  readonly/>
	                    		<input type="hidden" id="st_position" name="st_position" value="<%=CommonUtil.nvl(_rowData.get("POSITION")) %>" />
	                    		<a href="javascript:doPop('position', '<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>');"><img src="/resources/images/btn_search03.gif"></a>
	                    	</td>
	                  </tr>
	                  <tr>
	                      <th scope="row"><%=CommonLang.get("HTITLE477") %><!-- 메뉴접근 권한 --></th>
	                    	<td>
	                    		<input type="hidden" id="st_role" name="st_role"  value="<%=CommonUtil.nvl(_rowData.get("ROLE")) %>" />
	                    		<p id="st_role_text" style="float:left;width:82%"><%=CommonUtil.nvl(_rowData.get("ROLE_NAME")) %></p>
	                    	</td>
	                    	<th scope="row"><%=CommonLang.get("HTITLE188") %><!-- 발주부서 --></th>
	                    	<td>
	                    		<input type="text" id="st_purchase_dept_text" name="st_purchase_dept_text" class="input_type_text" title=""  maxlength="50"  style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("PURCHASE_DEPT_TEXT")) %>"  readonly/>
	                    		<input type="hidden" id="st_purchase_dept" name="st_purchase_dept" value="<%=CommonUtil.nvl(_rowData.get("PURCHASE_DEPT")) %>" />
	                    		<a href="javascript:doPop('purchase_dept', '<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>');"><img src="/resources/images/btn_search03.gif"></a>
	                     	</td>
	                  </tr>
	                  <%if( "A".equals(user_type)){ %>
	                  <tr>
	                      <th scope="row"><%=CommonLang.get("HTITLE478") %><!-- 직발주 권한 --></th>
	                    	<td>
	                    		<input type="radio" id="person_author1" name="person_author" value="PR" <% if (CommonUtil.nvl(_rowData.get("PERSON_AUTHOR")).equals("PR")) { %>checked="checked"<% } %> disabled/>&nbsp;<%=CommonLang.get("HTITLE479") %><!-- 구매요청자 -->&nbsp;&nbsp;&nbsp;
	                     		<input type="radio" id="person_author2" name="person_author" value="PO" <% if (CommonUtil.nvl(_rowData.get("PERSON_AUTHOR")).equals("PO")) { %>checked="checked"<% } %> disabled/>&nbsp;<%=CommonLang.get("HTITLE480") %><!-- 구매발주자(직발주) -->
	                     		<input type="hidden" id="st_person_author" name="st_person_author" value="<%=CommonUtil.nvl(_rowData.get("PERSON_AUTHOR"))%>" />
	                    	</td>
	                    	<th scope="row"><%=CommonLang.get("HTITLE481") %><!-- 신규소싱권한 --></th>
	                    	<td>
						<select id="st_user_group" name="st_user_group">
							<option value = "Q" <%=CommonUtil.nvl(_rowData.get("USER_GROUP")).equals("Q")?"selected":""%>> <%=CommonLang.get("HTITLE482") %><!-- 본인 의뢰 건 조회 --></option>
							<option value = "C" <%=CommonUtil.nvl(_rowData.get("USER_GROUP")).equals("C")?"selected":""%>> <%=CommonLang.get("HTITLE483") %><!-- 본인 의뢰 건 조회 및 단가확정 --></option>
							<option value = "A" <%=CommonUtil.nvl(_rowData.get("USER_GROUP")).equals("A")?"selected":""%>> <%=CommonLang.get("HTITLE484") %><!-- 전체 의뢰 건 조회 및 단가확정 --></option>
						</select>
	                    	</td>
	                  </tr>
	                  <%} %>
	                  <tr>
	                      <th scope="row"  class="star"><%=CommonLang.get("HTITLE485") %><!-- 도착지 --></th>
	                    	<td colspan="3">
	                    		<input type="hidden" id="st_dely_to_location" name="st_dely_to_location" value="<%=CommonUtil.nvl(_rowData.get("DELY_TO_LOCATION")) %>" />
	                    		<input type="text" id="st_dely_text" name="st_dely_text" class="input_type_text" title="" style="width:89%;" maxlength="300"  readonly value="<%=CommonUtil.nvl(_rowData.get("DELY_TEXT")) %>" />
                <%if(p060000057==true&&user_type.equals("U")){
                %>
                <%}else{ %>	
	                    		<a href="javascript:doPop('location', '<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>', '<%=CommonUtil.nvl(_rowData.get("DELY_TO_LOCATION")) %>');"><img src="/resources/images/btn_search03.gif"></a>
				<%} %>
                <%if(p060000112==true){
                %>
                	<span class="btn_wishproduct"  title="도착지추가"><a href="javascript:doPop('addLocation','<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>','')"><%=CommonLang.get("HTITLE952") %><!-- 도착지추가 --></a></span></td>
                <%} %>
	                    	</td>
	                  </tr>
	                  <tr>
	                      <th scope="row"><%=CommonLang.get("HTITLE486") %><!-- 결재선등록 --></th>
	                    	<td colspan="3">
	                    		<input type="hidden" id="st_icogpass" name="st_icogpass" value="<%=CommonUtil.nvl(_rowData.get("ICOGPASS")) %>" /> 
	                    		 <textarea rows="3" cols="70" name="kto"   style="text-align:left;width:90%;" readonly >
<%=CommonLang.get("HTITLE310") %> : <%=_approved %>
<%=CommonLang.get("HTITLE311") %> : <%=_refer %>
<%=CommonLang.get("HTITLE792") %> : <%=_agree %>
	                    		 </textarea>
	                    		 <!-- 결재 -->
	                    		 <!-- 참조 -->
	                    		 <!-- 합의 -->
	                    		 <input type="hidden" id="db_name" name="db_name" value="<%=_db_name%>" />
	                    		 <input type="hidden" id="to" name="to" value="<%=_to_str_id%>" />
	                    		 <input type="hidden" id="cc" name="cc" value="<%=_cc_str_id%>" />
	                    		 <input type="hidden" id="ag" name="ag" value="<%=_ag_str_id%>" />
     <%if(p060000059==true&&user_type.equals("U")){
    	}else{ %>
	                    		 <a href="javascript:doPop('approved');"><img src="/resources/images/btn_search03.gif"></a>
		<%} %>
	                    	</td>
			</tbody>
		</table>
		
		<!-- 버튼영역 -->
		<div class="btnArea mt10 mb05">
			<div class="fr">
				<span class="btn_06">
					<a href="javascript:doAction('pwdValidCheck');"><%=CommonLang.get("HTITLE446") %><!-- 비밀번호변경 --></a>
				</span>
				<span class="btn_04">
					<a href="javascript:doAction('save');"><%=CommonLang.get("HTITLE124") %><!-- 저장 --></a>
				</span>	
            </div>
        </div>
        		
		<% } else{%>
		<%} %>

</form>

<form name="processForm" id="processForm" method="post">	
	<div id="process">
	
	</div>
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>


</html>
