<%--
**********************************************
* 메뉴 : 마이페이지 > 개인정보
* 화면 : 개인정보
* 기능 : 고객사 개인정보 조회, 수정 관리
* 프로그램 ID : BU0801001
* 담당자 : 최찬규
* 착수일 : 2026-02-11
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("userData"); // 조회된 결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("approvedData"); // 결재자 목록
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList3 = (List<Map<String,String>>) request.getAttribute("referData"); // 참조자 목록
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList4 = (List<Map<String,String>>) request.getAttribute("agreeData"); // 합의자 목록
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList5 = (List<Map<String,String>>) request.getAttribute("userMailRecvChoiceData"); // 메일 수신 목록


String menuId = CommonUtil.nvl((String) request.getParameter("menuId"),""); // 메뉴아이디

if(myMenuListHeader != null){ //null이 아닌 경우에만 체크
	for(int i = 0; i<myMenuListHeader.size(); i++){
		if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
			myMenuFlag = true;
			break;
		}
	}
}

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
			_approved += _rowData2.get("APPR_NAME")+" > ";
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
			_refer += _rowData3.get("APPR_NAME")+" > ";
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
			_agree += _rowData4.get("APPR_NAME")+" > ";
		}
		
		_db_name+= _rowData4.get("APPR_ID")+"@@"+_rowData4.get("APPR_NAME")+"@@"+_rowData4.get("APPR_SEQ")+"@@"+_rowData4.get("GUBUN")+"^||^";
		_ag_str_id += _rowData4.get("APPR_ID") + ",";
	}
 }

int mailRecvChoiceSize = 0;
if (_dataList5 != null && _dataList5.size() != 0) { 
	mailRecvChoiceSize = _dataList5.size();
}
String p01_1010_05 = CommonUtil.getSpecialCheckReturn(com_code,"P01-1010-05","COL01_DATA", request); // 고객사별 사번 라벨명
if(p01_1010_05 == null){
	p01_1010_05 = CommonLang.get("HTITLE454");	//사번
}else if("".equals(p01_1010_05)){
	p01_1010_05 = CommonLang.get("HTITLE454");	//사번
}

//p01_1010_06 사번값 필수 고객사 SLOGIC
boolean p01_1010_06 = CommonUtil.getSpecialCheckReturn(com_code,"P01-1010-06"); 


//해당 리스트의 지역번호를 사용하면 국번은 입력 못하도록.
List<Map<String,String>> telNumList =  CommonUtil.getCode3List(com_code, "", "M080","", "ICOMCOD1", "", "");
List<String> telNumTempList = new ArrayList<String>();
for(int i = 0; i<telNumList.size(); i++){
	telNumTempList.add(telNumList.get(i).get("CODE"));
}

%>

<script type="text/javascript">
<!--
var popupSel = "";
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

//지역번호(시외국번) 목록 - M080 코드
var telAreaCodeList = [<%
	for (int i = 0; i < telNumTempList.size(); i++) {
		out.print("\"" + telNumTempList.get(i) + "\"");
		if (i != telNumTempList.size() - 1) out.print(",");
	}
%>];
// 이메일 도메인 선택
function setEmailDomain() {
	var domain = $("#st_email_domain").val();
	if (domain != "") {
		$("#st_email2").val(domain).trigger("change");
		$("#st_email2").attr("readonly", true);
	} else {
		$("#st_email2").val("").trigger("change");
		$("#st_email2").attr("readonly", false);
		$("#st_email2").focus();
	}
}

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



//최초 화면 함수 
function kep_onload_view() {
	<% if (_dataList==null || _dataList.size()==0) { %>
		<% if (!"Y".equals(st_open_yn)) {%>
		doAction('search');
		<%}%>
	<% }else{ %>
		var st_mail_recv_choice = "<%=CommonUtil.nvl(_rowData.get("MAIL_RECV_CHOICE"))%>";
		var st_mail_recv_flag = "<%=CommonUtil.nvl(_rowData.get("MAIL_RECV_FLAG"))%>";
		if(st_mail_recv_choice == null || st_mail_recv_choice =="") return;
		var str_area_list = st_mail_recv_choice.split("");
		
		var tot_cnt = "<%=mailRecvChoiceSize%>";
		// 파라미터 선택된 값 체크하기
		if(st_mail_recv_flag == "Y"){
			for(var i=0; i< tot_cnt; i++){
				if(str_area_list[i] == "Y"){
					document.getElementById("st_recv_mail_flag"+i).checked = true;
				}else{
					document.getElementById("st_recv_mail_flag"+i).checked = false;
				}
			}
		}else{ //메일 수신 N이면 전체해제
			$("input[name=st_recv_mail_flag]").prop("checked",false);
		}
		
		$("#contentForm").on("input change", "input, select, textarea", function() {
			clearError(this);
		});
		
		//이메일 앞부분에 @ 안들어가도록 수정
		var emailInput = document.getElementById("st_email1");
		emailInput.addEventListener('keydown',function(e){
			if(e.key === "@") e.preventDefault();
		});
		emailInput.addEventListener("input",function(){
			this.value = this.value.replace(/@/g,'');
		})
		
			
// 		var check = $("#checkedAll").is(":checked");
// 		$("#st_parcel_yn_check").prop("checked",check);
	<%}%>
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
		case "search":						//조회
			kepSearch();
			break;
		case "save":							// 저장 ssl 적용
			checkSubmit();
			break;
		case "pwdValidCheck":  
			passwordValidCheck();
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
	$('#searchForm').attr("action", "/mdam/getBuyerMdAmUserInfoList.do?menuId="+'<%=menuId%>').submit();   
}
  
//팝업함수호출
function doPop(str, val, val2) {
	popupSel = str;
	
	switch (str) {
		case "dept":
			openSearchPopup("/common/deptCodeAdminPop.do", "?com_code=" + val + "&open=Y", "720,580,no");	
			break;
		case "position":
			openSearchPopup("/common/positionCodePop_v2.do", "?com_code="+val+"&type=C003", "500,470,no");			
			break;
		case "purchase_dept":
			openSearchPopup("/coco/showCommonCoCoOrderDepartmentSearchPop.do", "?com_code="+val, "700,620,no");				
			break;
		case "role":
			openSearchPopup("/coco/showCommonCoCoAuthorityRegPop.do","?st_role_code=" + $("#st_role").val().replace("+", "@") + "&st_user_type=" + val, "200, 240,no");
			break;
		case "location":
			openSearchPopup("/common/delLocationPop.do", "?com_code=" + val + "&del_code="+val2, "930,580,no");					
			break;
		case "approved":
			if ($("#st_icogpass").val() == "0") {
				//전자결재 범위가 지정되어 있지 않습니다.전자결재 범위를 지정한 후 결재선을 수정하여 주십시요.
				var text = "<%=CommonLang.msg("MSG310") %>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			openSearchPopup("/coco/showCommonCoCoApprovalAppointPop.do", "?to=" + $("#to").val() + "&cc=" + $("#cc").val() + "&cur_order_no=1&type=APSE", "1000,660,no");						
			break;
		case "recvMailPop": // 메일수신항목
			if(document.getElementById("mail_recv_flag").checked == false){
				//메일 수신여부가 미수신일 경우 메일 수신항목을 지정 할 수 없습니다.
				var text = "<%=CommonLang.msg("MSG506") %>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;					
			}
			var st_mail_recv = $("#st_mail_recv").val();
			openSearchPopup("/common/getUserMailRecvChoicePop.do", '?st_mail_recv='+st_mail_recv, "520,270,no");
			break;
		case "addLocation": //도착지 입력기능.
			openSearchPopup("/common/delLocationAddPop.do", "?com_code=" + val, "1200,540,no");					
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text, val) {
	//팝업 조회후 해당 항목에 값을 셋팅
	
	switch (popupSel) {
		case "dept":
			$("#st_department").val(code);
			$("#st_department_text").val(text +" / " + code);
			clearError("#st_dept_div");
			break;
		case "position":
			$("#st_position").val(code);
			$("#st_position_text").val(text);
			clearError("#st_pos_div");
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
			clearError("#st_dely_div");
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
			var text = sMsg;
			openLayerPopText2(text,but1text,but1func,but1width);
			$("#st_password").val("");
			$("#st_password").focus();
			return;
		} else {
			$("#chkPassword").val("Y");
			
					
			var text = "<%=CommonLang.msg("MSG333") %>";//비밀번호를 수정 하시겠습니까?
			var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
			var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
			var but1funcC = "javascript:saveSellerMdAmUsePwd(); return false;";
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "60px";
			var but2widthC = "60px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		}
	} else if (pMethod == "save") {
		if (sMsg == 'OK') {
			//사용자 정보 수정이 완료되었습니다.
			var text = "<%=CommonLang.msg("MSG312") %>";
			openLayerPopText2(text,but1text,but1funcSearch,but1width);
		} else if (sMsg == "ERR") {
			//사용자 정보 수정이 실패 하였습니다.\n다시 확인하여 주십시요!
			var text = "<%=CommonLang.msg("MSG313") %>";
			openLayerPopText2(text,but1text,but1func,but1width);
            return;
        } else {
			var text = sMsg;
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}else if(pMethod == "pwdSave"){
		if (sMsg == 'OK') {
			//비밀번호 변경이 완료되었습니다.
			var text = "<%=CommonLang.msg("MSG314") %>";
			openLayerPopText2(text,but1text,but1funcSearch,but1width);
		} else if (sMsg == "ERR") {
			//비밀번호 변경이 실패 하였습니다. 다시 확인하여 주십시요!
			var text = "<%=CommonLang.msg("MSG503") %>";
			openLayerPopText2(text,but1text,but1func,but1width);
            return;
		} else if (sMsg == "ERR_MATCH"){
			//현재 비밀번호가 일치하지 않습니다.
			var text = "<%=CommonLang.msg("MSG504") %>";
			openLayerPopText2(text,but1text,but1func,but1width);
			$("#st_password_present").focus();
			return;
		} else {
			var text = sMsg;
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}
}

function  kepAjaxError(pMethod , response) {
	//오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.   
	var text = "<%=CommonLang.msg("MSG418") %>";
	openLayerPopText2(text,but1text,but1func,but1width);
} 
function saveSellerMdAmUsePwd(){
	closePopText1();
	kepAjaxFormCall("/mdam/saveSellerMdAmUsePwd.do","contentForm", "pwdSave");
}

function checkSubmit() {
	if (isEmpty($("#st_user_name_loc").val())) {
		showError("#st_user_name_loc");
		//국문이름이 입력되지 않았습니다.
		var text = "<%=CommonLang.msg("MSG950") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
// 		$("#st_user_name_loc").focus();
		return;
	}

	if($("#st_user_name_eng").val().length > 0){
		if (!/^[A-Za-z\s]+$/.test($("#st_user_name_eng").val().trim())) {
			showError("#st_user_name_eng");
			//영문이름은 영어와 공백만 입력 가능합니다.
			var text = "<%=CommonLang.msg("MSG960") %>";
			openLayerPopText2(text,but1text,but1func,but1width);
//	 		$("#st_user_name_loc").focus();
			return;
		  }
	}
	
	if (isEmpty($("#st_email1").val())) {
		showError("#st_email1");
		//Email 주소가 입력되지 않았습니다.
		var text = "<%=CommonLang.msg("MSG316") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
    }
	if (isEmpty($("#st_email2").val())) {
		showError("#st_email2");
		//Email 주소가 입력되지 않았습니다.
		var text = "<%=CommonLang.msg("MSG316") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
    }
	
	var emailFull = $("#st_email1").val() + "@" + $("#st_email2").val();
	$("#st_email").val(emailFull);
	
	if (!checkemail("st_email")) {
		return;
	}
	
	if (isEmpty($("#st_mobile_phone1").val())) {
		showError("#st_mobile_phone1");
		//핸드폰 번호가 입력되지 않았습니다.
		var text = "<%=CommonLang.msg("MSG321") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
// 		$("#st_mobile_phone1").focus();
		return;
	}
	
	if (isEmpty($("#st_mobile_phone2").val())) {
		showError("#st_mobile_phone2");
		//핸드폰 번호가 입력되지 않았습니다.
		var text = "<%=CommonLang.msg("MSG321") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_mobile_phone2").focus();
		return;
	}
	
	if (isEmpty($("#st_mobile_phone3").val())) {
		showError("#st_mobile_phone3");
		//핸드폰 번호가 입력되지 않았습니다.
		var text = "<%=CommonLang.msg("MSG321") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
// 		$("#st_mobile_phone3").focus();
		return;
	}
	
	if ($("#st_mobile_phone1").val().length != 3  || $("#st_mobile_phone2").val().length<3 || $("#st_mobile_phone3").val().length !=4) { 
		showError("#st_mobile_phone1");
		//핸드폰 번호를 정확히 입력하세요.
		var text = "<%=CommonLang.msg("MSG322") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
// 		$("#st_mobile_phone1").focus();
		return;
	}

	$("#st_mobile_phone").val($("#st_mobile_phone1").val() + "-" + $("#st_mobile_phone2").val() + "-" + $("#st_mobile_phone3").val());  
	
	if (isEmpty($("#st_phone_number1").val())) {
		showError("#st_phone_number1");
		//전화번호가 입력되지 않았습니다.
		var text = "<%=CommonLang.msg("MSG324") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
// 		$("#st_phone_number1").focus();
		return;
	}
	
	if($("#st_phone_number_flag").val() == "N"){
		if (isEmpty($("#st_phone_number2").val())) {
			showError("#st_phone_number2");
			//전화번호가 입력되지 않았습니다.
			var text = "<%=CommonLang.msg("MSG324") %>";
			openLayerPopText2(text,but1text,but1func,but1width);
//	 		$("#st_phone_number2").focus();
			return;
		}
	}
	
	
	if (isEmpty($("#st_phone_number3").val())) {
		showError("#st_phone_number3");
		//전화번호가 입력되지 않았습니다.
		var text = "<%=CommonLang.msg("MSG324") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
// 		$("#st_phone_number3").focus();
		return;
	}
	$("#st_phone_number").val($("#st_phone_number1").val() + "-" + $("#st_phone_number2").val() + "-" + $("#st_phone_number3").val());  
	
	dial = $("#st_phone_number1").val().substring(0,2);
	if(dial == '01'){ <%-- 휴대폰 번호 앞자리 (010 ~ 019) 판별을 위해--%>
		showError("#st_phone_number1");
		//전화번호에 휴대폰 번호는 입력하실 수 없습니다.
		var text = "<%=CommonLang.msg("MSG641") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	//fax
	$("#st_fax_number").val($("#st_fax_number1").val() + "-" + $("#st_fax_number2").val() + "-" + $("#st_fax_number3").val());  
	
	
	if(isEmpty($("#st_department_text").val())) {
		showError("#st_dept_div");
		//부서가 입력되지 않았습니다.
		var text = "<%=CommonLang.msg("MSG325") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
// 		$("#st_department_text").focus();
		return;
    }

    if (isEmpty($("#st_position_text").val())) {
    	showError("#st_pos_div");
		//직급이 입력되지 않았습니다.
		var text = "<%=CommonLang.msg("MSG326") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
// 		$("#st_position_text").focus();
		return;
	}

    <%--사번 필수값 확인--%>
    <%if(p01_1010_06 == true){%>
		if(isEmpty(kepTrim("st_legacy_user_id"))){
			showError("#st_legacy_user_id");
			//""은 필수 값입니다.
			var text = "<%=p01_1010_05%>" +"<%=CommonLang.msg("MSG642")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
// 			$("#st_legacy_user_id").focus();
			return;
		}
	<%}%>
	
	<%--사번 공백 불가--%>
	if (kepTrim("st_legacy_user_id") != $("#st_legacy_user_id").val()){
		showError("#st_legacy_user_id");
		//""은 공백을 포함할 수 없습니다.
		var text = "<%=p01_1010_05%>" +"<%=CommonLang.msg("MSG643")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
// 		$("#st_legacy_user_id").focus();	
		return;
	}

    if($("#sms_recv_flag").is(":checked")){
    	$("#st_sms_recv_flag").val("Y");
    }else{
    	$("#st_sms_recv_flag").val("N");
    }
    
    if($("#mail_recv_flag").is(":checked")){
    	$("#st_mail_recv_flag").val("Y");
    }else{
    	$("#st_mail_recv_flag").val("N");
    }
    
    var tmpChoiceMail = "";
	var tot_cnt = "<%=mailRecvChoiceSize%>";
	for(var i = 0; i < tot_cnt; i++){
		if($("#st_recv_mail_flag"+i).is(":checked")){
			tmpChoiceMail += "Y";
		}else{
			tmpChoiceMail += "N";
		}
	}
	//메일설정 자리수 체크 때문에 쓰임.
	tmpChoiceMail=tmpChoiceMail+"NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN";
	$("#st_mail_recv").val(tmpChoiceMail);//메일수신항목 저장
	
    $("#st_person_author").val($("input[name=person_author]:checked").val());
    $("#st_two_factor_flag").val($("input[name=two_factor_flag]:checked").val());
    $("#st_chg_info_pwd_flag").val($("input[name=chg_info_pwd_flag]:checked").val());

    if (isEmpty($("#st_dely_to_location").val())) {
    	showError("#st_dely_div");
		//도착지가 입력되지 않았습니다.
		var text = "<%=CommonLang.msg("MSG327") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
    
	if (isEmpty($("#st_chg_info_pwd_flag").val())) {
		//추가인증 여부(개인정보변경)를 선택하여 주십시오.
		var text = "<%=CommonLang.msg("MSG560") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
// 	if ($("#st_user_type").val() == "U" &&  $("#change_user_type").val() == "A") {
//         //사용자 구분 변경시에는 \n(일반사용자->Admin사용자)\n운영자의 승인 후에 반영됩니다.
<%--         var text = "<%=CommonLang.msg("MSG317") %>"; --%>
// 		openLayerPopText2(text,but1text,"javascript:doSaveCheck(); return false;",but1width);
// 	}else{
		doSaveCheck();
// 	}
}

function doSaveCheck(){
	closePopText2();
	var text = "<%=CommonLang.msg("MSG334") %>";//사용자 정보를 수정 하시겠습니까?
	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	var but1funcC = "javascript:doSave(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "60px";
	var but2widthC = "60px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
}
function doSave(){
	closePopText1();

	$("#st_sms_recv_flag").val($("#sms_recv_flag").is(":checked") ? "Y" : "N");
	$("#st_mail_recv_flag").val($("#mail_recv_flag").is(":checked") ? "Y" : "N");

	var tmpChoiceMail = "";
	var tot_cnt = "<%=mailRecvChoiceSize%>";
	for(var i = 0; i < tot_cnt; i++){
		tmpChoiceMail += $("#st_recv_mail_flag"+i).is(":checked") ? "Y" : "N";
	}
	tmpChoiceMail = tmpChoiceMail + "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN";
	$("#st_mail_recv").val(tmpChoiceMail);

	kepAjaxFormCall("/mdam/updateBuyerMdAmUserInfoList.do","contentForm", "save");
}

function passwordValidCheck() {
	$("#chkPassword").val("N");
	
	if ($("#st_password_present").val().length == 0) {
		showError("#st_password_present");
		//현재 비밀번호가 입력되지 않았습니다.
		var text = "<%=CommonLang.msg("MSG505") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
// 		$("#st_password_present").focus();
		return;
	}
	
	if ($("#st_password").val().length == 0) {
		showError("#st_password");
		//비밀번호가 입력되지 않았습니다. 
		var text = "<%=CommonLang.msg("MSG328") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
// 		$("#st_password").focus();
		return;
	}
    
	if (checkSpace($("#st_password").val()) && $("#st_password").val() !="") {
        $("#st_password").val("");
		showError("#st_password");
		//비밀번호에 공백문자를 입력할 수 없습니다.   
		var text = "<%=CommonLang.msg("MSG329") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
//         $("#st_password").focus();
        return;
    }
	
	if ($("#st_password").val().length < 8) {
		$("#st_password").val("");
		showError("#st_password");
		//비밀번호는 8 자리 이상 사용해야 합니다.
		var text = "<%=CommonLang.msg("MSG330") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
// 		$("#st_password").focus();
// 		$("#st_password").select();
		return;
	}

	if ( $("#st_password").val().length < chkKorea($("#st_password").val())) {
		$("#st_password").val("");
		showError("#st_password");
		//비밀번호는 영문으로 입력해 주십시요.
		var text = "<%=CommonLang.msg("MSG331") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
// 		$("#st_password").focus();
		return;
	}
	
	if ($("#st_password_confirm").val().length == 0) {
		showError("#st_password_confirm");
		//비밀번호가 입력되지 않았습니다. 
		var text = "<%=CommonLang.msg("MSG328") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
// 		$("#st_password_confirm").focus();
		return;
	}
	
	if (checkSpace($("#st_password_confirm").val()) && $("#st_password_confirm").val() !="") {
        $("#st_password_confirm").val("");
		showError("#st_password_confirm");
		//비밀번호에 공백문자은 입력할 수 없습니다.    
		var text = "<%=CommonLang.msg("MSG329") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
//         $("#st_password_confirm").focus();
        return;
    }
	
	if ($("#st_password_confirm").val().length < 8) {
		$("#st_password_confirm").val("");
		showError("#st_password_confirm");
		//비밀번호는 8 자리 이상 사용해야 합니다.
		var text = "<%=CommonLang.msg("MSG330") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
// 		$("#st_password_confirm").focus();
		return;
	}
	
	if ( $("#st_password_confirm").val().length < chkKorea($("#st_password_confirm").val())) {
		$("#st_password_confirm").val("");
		showError("#st_password_confirm");
		//비밀번호는 영문으로 입력해 주십시요.
		var text = "<%=CommonLang.msg("MSG331") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
// 		$("#st_password_confirm").focus();
		return;
	}
	
	if ( $("#st_password").val() != $("#st_password_confirm").val()) {
		showError("#st_password");
		//비밀번호가 일치하지 않습니다.\n다시 한번 입력하시기 바랍니다.
		var text = "<%=CommonLang.msg("MSG332") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
// 		$("#st_password").focus();
		return;
	}
	
	kepAjaxFormCall("/mdam/pwdValidCheckBuyerMdAmUserInfo.do","contentForm", "pwdValidCheck");
	
}

// ISMS Cache 사용 제한 - bfcache(뒤로가기, 앞으로가기) 감지하여 로그아웃 만들도록 수정 2024.05.29 HSJ
window.onpageshow = function(event) {
	if(event.persisted || (window.performance && window.performance.navigation.type == 2)){
		doAction('search');
	}
}

function changeEmailRecvFlag(){
	if(!$("#mail_recv_flag").is(":checked")){ //이메일 체크 해제하면 수신항목 다 해제
		$("input[name=st_recv_mail_flag]").prop("checked",false);
	}
}
function checkEmailRecvFlag(index){
	if($("#st_recv_mail_flag"+index).is(":checked") && !$("#mail_recv_flag").is(":checked")){
		$("#mail_recv_flag").prop("checked", true);
		$("#st_mail_recv_flag").val("Y");
	}
}

function thisPopClose(){
	closePopText2();
	doAction("search");
}
function approvalLine(){
	openSearchPopup('/common/popup/approval/approvalHumanEditPop.do',"", "1200,670,no"); 
}

function telNumCheck(args){
	if (kepIsNumberString(args.value)  == false){
		//숫자만 입력 가능합니다.
		var text = "<%=CommonLang.msg("MSG951") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
		args.value = "";
		args.focus();
		return;
	} else{
		var telValue = args.value;
		
		if ($.inArray(telValue, telAreaCodeList) > -1) {
			// 지역번호 목록에 포함 -> 국번 입력 불가 처리
			$("#st_phone_number_flag").val("Y");
			$("#st_phone_number2").val("").prop("disabled", true);
			clearError("#st_phone_number2"); //showError상태 인 경우 제거
		} else {
			// 목록에 없음 -> 국번 입력 가능
			$("#st_phone_number_flag").val("N");
			$("#st_phone_number2").prop("disabled", false);
		}
	}
}
//-->
</script>

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerHeader_v2"/>
<c:param name="part" value="buyerHeader_v2"/>
</c:import>   
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<!--서브타이틀-->  
  <div class="SubPageTit">
    <%=CommonLang.get("HTITLE445") %><!-- 개인정보 --> 
    	<%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star_off"></button>
     	<%} %>
    <div class="SubPageGuide">
      <ul>
        <li><img src="/resources/imgs/Icon_Home.png" /></li>
        <li><%=CommonLang.get("HTITLE987") %><!-- 마이페이지 --></li>
        <li><%=CommonLang.get("HTITLE445") %><!-- 개인정보 --></li>
      </ul>
    </div>   
  </div>
  <div class="container">
  		<!--조회영역-->
		<form name = "searchForm" id="searchForm" method = "post" >
			<!--HIDDEN-->
			<!-- 공통 -->
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
	<% if (_rowData != null) {  %>
    <div class="SubPageTitMedium mt20"><%=CommonLang.get("HTITLE1074")%><!--기본정보--></div>
    <table class="PerInfor mt10" >
      <colgroup>
        <col width="150px" />
        <col width="280px" />
        <col width="150px" />
        <col width="280px" />
        <col width="140px" />
        <col width="280px" />
      </colgroup>
      <tr>
        <th><%=CommonLang.get("HTITLE324") %><!-- ID --></th>
        <td><%=CommonUtil.nvl(_rowData.get("USER_ID"))%>
        <input type="hidden" name="st_status" id="st_status"  value="<%=CommonUtil.nvl(_rowData.get("STATUS"))%>">
        </td>
        <th><%=CommonLang.get("HTITLE1075")%><!--국문이름--><span class="F6495F">*</span></th>
        <td><input class="input40" style="width:230px" name="st_user_name_loc" type="text" id="st_user_name_loc" maxlength="40" onkeyup="fnCheckInputByte(this, 40);" onchange="fnCheckInputByte(this, 40);" value="<%=CommonUtil.nvl(_rowData.get("USER_NAME_LOC"))%>"/></td>
        <th><%=CommonLang.get("HTITLE1076")%><!--영문이름--></th>
        <td><input class="input40" style="width:230px; ime-mode:disabled;" name="st_user_name_eng" type="text" id="st_user_name_eng" maxlength="40" value="<%=CommonUtil.nvl(_rowData.get("USER_NAME_ENG"))%>"/></td>
      </tr>
      <tr>
        <th rowspan="3" title="<%=CommonLang.get("HTITLE897") %>
<%=CommonLang.get("HTITLE898") %>
<%=CommonLang.get("HTITLE899") %>
<%=CommonLang.get("HTITLE900") %>"><%=CommonLang.get("HTITLE1077")%><!--비밀번호--> <span class="F6495F">*</span></th>
        <td rowspan="3">
          <input class="input40" style="width:230px" placeholder="<%=CommonLang.get("HTITLE1078")%>" name="st_password_present" id="st_password_present" type="password" /> <!-- 현재 비밀번호 -->
          <input class="input40 mt03" style="width:230px" placeholder="<%=CommonLang.get("HTITLE1079")%>" name="st_password" id="st_password" type="password" /><!-- 새 비밀번호 -->
          <input class="input40 mt03" style="width:230px" placeholder="<%=CommonLang.get("HTITLE1080")%>" name="st_password_confirm" id="st_password_confirm" type="password" /><!-- 새 비밀번호 재입력 -->
          <input type="hidden" name="chkPassword" id="chkPassword"  value="<%=CommonUtil.nvl(_rowData.get("CHKPASSWORD"))%>" />
          <button class="ButQuaternary_Small mt03" onclick="javascript:doAction('pwdValidCheck'); return false;"><%=CommonLang.get("HTITLE446")%><!-- 비밀번호변경 --></button>
        </td>
        <th><%=p01_1010_05%><%if(p01_1010_06 == true){%><span class="F6495F">*</span><%} %></th>
        <td><input class="input40" style="width:230px;ime-mode:disabled;" name="st_legacy_user_id" id="st_legacy_user_id" type="text" maxlength="40" value="<%=CommonUtil.nvl(_rowData.get("LEGACY_USER_ID"))%>" /></td>
        <th><%=CommonLang.get("HTITLE462")%><!-- 핸드폰 --> <span class="F6495F">*</span></th>
        <td>
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
        <input class="input40" style="width:40px" maxlength="3" name="st_mobile_phone1" id="st_mobile_phone1" type="text" value="<%=_mobilePhone1%>"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/> - 
        <input class="input40" style="width:59px" maxlength="4" name="st_mobile_phone2" id="st_mobile_phone2" type="text" value="<%=_mobilePhone2%>"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> - 
        <input class="input40" style="width:60px" maxlength="4" name="st_mobile_phone3" id="st_mobile_phone3" type="text" value="<%=_mobilePhone3%>"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /></td>
      </tr>
      <tr>
        <th><%=CommonLang.get("HTITLE326")%><!-- 전화번호 --> <span class="F6495F">*</span></th>
        <td>
        	<% 
          	String _phoneNum1 = "";
    		String _phoneNum2 = "";
    		String _phoneNum3 = "";	
    		String _phoneNumFlag = "N";//지역번호가 ICOMCOD1.TYPE='M080' 에 포함되면 Y / 아니면 N
          	if (!CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).equals("")) {
				if(CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-").length == 0){
          			
          		}else if(CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-").length == 1){
          			_phoneNum1 = CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-")[0];
          		}else if(CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-").length == 2){
          			_phoneNum1 = CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-")[0];
          			_phoneNum2 = CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-")[1];
          		}else if(CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-").length == 3){
          			_phoneNum1 = CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-")[0];
          			_phoneNum2 = CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-")[1];
          			_phoneNum3 = CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-")[2];
          		}
				
				if(telNumTempList.contains(_phoneNum1)){
					_phoneNumFlag = "Y";
				}
          	}
          	%>
         <input type="hidden" id="st_phone_number" name="st_phone_number"  value="<%=CommonUtil.nvl(_rowData.get("PHONE_NUMBER")) %>" />
         <input type="hidden" id="st_phone_number_flag" name="st_phone_number_flag"  value="<%=_phoneNumFlag%>" />
        <input class="input40" style="width:40px" name="st_phone_number1" id="st_phone_number1" type="text" value="<%=_phoneNum1%>"  onkeyup="javascript:telNumCheck(this);" onchange="javascript:telNumCheck(this);" /> - 
        <input class="input40" style="width:59px" name="st_phone_number2" id="st_phone_number2" type="text" <%if(_phoneNumFlag.equals("Y")){ %> value="" disabled  <%}else{ %> value="<%=_phoneNum2%>"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" <%} %> /> - 
        <input class="input40" style="width:60px" name="st_phone_number3" id="st_phone_number3" type="text" value="<%=_phoneNum3%>"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /></td>
        <th><%=CommonLang.get("HTITLE463")%><!-- Fax --></th>
        <td>
        	<% 
          	String _faxNum1 = "";
    		String _faxNum2 = "";
    		String _faxNum3 = "";
          	if (!CommonUtil.nvl(_rowData.get("FAX_NUMBER")).equals("")) {
          		if(CommonUtil.nvl(_rowData.get("FAX_NUMBER")).split("\\-").length == 0){
          			
          		}else if(CommonUtil.nvl(_rowData.get("FAX_NUMBER")).split("\\-").length == 1){
          			_faxNum1 = CommonUtil.nvl(_rowData.get("FAX_NUMBER")).split("\\-")[0];
          		}else if(CommonUtil.nvl(_rowData.get("FAX_NUMBER")).split("\\-").length == 2){
          			_faxNum1 = CommonUtil.nvl(_rowData.get("FAX_NUMBER")).split("\\-")[0];
          			_faxNum2 = CommonUtil.nvl(_rowData.get("FAX_NUMBER")).split("\\-")[1];
          		}else if(CommonUtil.nvl(_rowData.get("FAX_NUMBER")).split("\\-").length == 3){
          			_faxNum1 = CommonUtil.nvl(_rowData.get("FAX_NUMBER")).split("\\-")[0];
          			_faxNum2 = CommonUtil.nvl(_rowData.get("FAX_NUMBER")).split("\\-")[1];
          			_faxNum3 = CommonUtil.nvl(_rowData.get("FAX_NUMBER")).split("\\-")[2];
          		}
          	}
          	%>
         <input type="hidden" id="st_fax_number" name="st_fax_number"  value="<%=CommonUtil.nvl(_rowData.get("FAX_NUMBER")) %>" />
        <input class="input40" style="width:40px" name="st_fax_number1" id="st_fax_number1" type="text" value="<%=_faxNum1%>"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> - 
        <input class="input40" style="width:59px" name="st_fax_number2" id="st_fax_number2" type="text" value="<%=_faxNum2%>"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> - 
        <input class="input40" style="width:60px" name="st_fax_number3" id="st_fax_number3" type="text" value="<%=_faxNum3%>"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /></td>
      </tr>
       <tr>
        <th><%=CommonLang.get("HTITLE41")%><!-- 이메일 --> <span class="F6495F">*</span></th>
        <td colspan="3">
        <input type="hidden" id="st_email" name="st_email" value="<%=CommonUtil.nvl(_rowData.get("EMAIL"))%>" />
        <% 
          	String email1 = "";
    		String email2 = "";
          	if (!CommonUtil.nvl(_rowData.get("EMAIL")).equals("")) {
          		if(CommonUtil.nvl(_rowData.get("EMAIL")).split("\\@").length == 0){
          			
          		}else if(CommonUtil.nvl(_rowData.get("EMAIL")).split("\\@").length == 1){
          			email1 = CommonUtil.nvl(_rowData.get("EMAIL")).split("\\@")[0];
          		}else if(CommonUtil.nvl(_rowData.get("EMAIL")).split("\\@").length == 2){
          			email1 = CommonUtil.nvl(_rowData.get("EMAIL")).split("\\@")[0];
          			email2 = CommonUtil.nvl(_rowData.get("EMAIL")).split("\\@")[1];
          		}
          	}
          	%>
        <input class="input40" style="width:275px;ime-mode:disabled;" id="st_email1" name="st_email1" type="text" value="<%=email1 %>" maxlength="30" /> @
            <input class="input40" style="width:140px;ime-mode:disabled;" id="st_email2" name="st_email2" type="text" value="<%=email2 %>" maxlength="20" />
            <select id="st_email_domain" name="st_email_domain" class="Select" style="width:190px" onchange="setEmailDomain()">
              <option value=""><%=CommonLang.get("HTITLE1425") %><!-- 직접입력 --></option>
              <option value="naver.com">naver.com</option>
              <option value="gmail.com">gmail.com</option>
              <option value="daum.net">daum.net</option>
              <option value="hanmail.net">hanmail.net</option>
              <option value="nate.com">nate.com</option>
              <option value="hotmail.com">hotmail.com</option>
              <option value="yahoo.co.kr">yahoo.co.kr</option>
            </select>
        </td>
<%--         <input class="input40" style="width:650px" name="st_email" id="st_email" maxlength="100" type="text" value="<%=CommonUtil.nvl(_rowData.get("EMAIL"))%>" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" /></td> --%>
       
      </tr>
      <tr>
        <th rowspan="2">알림 수신</th>
        <td colspan="5"> <span class="TdTit">채널</span>
        
        <input type="hidden" id="st_img_view_flag" name="st_img_view_flag" value="<%=CommonUtil.nvl(_rowData.get("IMG_VIEW_FLAG"))%>" />
        <input type="hidden" id="st_sms_recv_flag" name="st_sms_recv_flag" value="<%=CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG"))%>" />
        <input type="hidden" id="st_mail_recv_flag" name="st_mail_recv_flag"  value="<%=CommonUtil.nvl(_rowData.get("MAIL_RECV_FLAG"))%>" />
          <label class="CheckLargeLabel"><input type="checkbox" id="sms_recv_flag" name="sms_recv_flag" <% if (CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG")).equals("Y")) { %>checked="checked"<% } %>><span class="CheckLargeCustom"></span><%=CommonLang.get("HTITLE1081")%><!--SMS--></label>
          <label class="CheckLargeLabel"><input type="checkbox" id="mail_recv_flag" name="mail_recv_flag" <% if (CommonUtil.nvl(_rowData.get("MAIL_RECV_FLAG")).equals("Y")) { %>checked="checked"<% } %> onchange="javascript:changeEmailRecvFlag();"><span class="CheckLargeCustom"></span><%=CommonLang.get("HTITLE41")%><!-- 이메일 --></label>
        </td>
      </tr>
      <tr>
        <td colspan="5">
          <table class="PerInforSmall">
            <tr>
              <td style="border:0"><span class="TdTit" style="width:113px">메일수신</span></td>
              <input type="hidden" name="st_mail_recv" id="st_mail_recv" value="<%=CommonUtil.nvl(_rowData.get("MAIL_RECV_CHOICE"))%>">
              <td style="border:0">
              <% 
              if (_dataList5 != null && _dataList5.size() != 0) { 
            		for (int i=0; i < _dataList5.size(); i++) {
            			Map<String,String> _rowData5 = null;
            			_rowData5 = _dataList5.get(i);
              %>
              <label class="CheckLargeLabel"><input type="checkbox" id="st_recv_mail_flag<%=i%>" name="st_recv_mail_flag" value="<%=CommonUtil.nvl(_rowData5.get("TEXT1"))%>" onchange="javascript:checkEmailRecvFlag(<%=i%>);"><span class="CheckLargeCustom"></span><%=CommonUtil.nvl(_rowData5.get("TEXT4"))%></label>
              			<%if(i==5) {%>
              				</br>
              			<%} %>
              
              <%
            		}
              }
              %>
              
              </td>
            </tr>
          </table> 
        </td>
      </tr>                              
    </table>
    <div class="SubPageTitMedium mt30"><%=CommonLang.get("HTITLE737")%><!-- 회사정보 --></div>
    <table class="PerInfor mt10" >
      <colgroup>
        <col width="150px" />
        <col width="280px" />
        <col width="150px" />
        <col width="280px" />
        <col width="140px" />
        <col width="280px" />
      </colgroup>
      <tr>
        <th><%=CommonLang.get("HTITLE474")%><!-- 회사명 --></th>
        <td><%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC")) %></td>
        <th><%=CommonLang.get("HTITLE332")%><!-- 법인그룹 --></th>
        <td><%=CommonUtil.nvl(_rowData.get("CORP_NAME"))%></td>
        <th><%=CommonLang.get("HTITLE475")%><!-- 사업자번호 --></th>
        <td><%=CommonUtil.nvl(_rowData.get("IRS_NO"))%></td>
	  </tr>
	  <tr>
	  	<th><%=CommonLang.get("HTITLE476")%><!-- 직급 --> <span class="F6495F">*</span></th>
        <td><div class="PerInforSearch" style="width: 250px;" id="st_pos_div">
            <input type="text" id="st_position_text" name="st_position_text"  maxlength="50" value="<%=CommonUtil.nvl(_rowData.get("POSITION_TEXT")) %>"  readonly  style=" width:200px; vertical-align: top;">
            <input type="hidden" id="st_position" name="st_position" value="<%=CommonUtil.nvl(_rowData.get("POSITION")) %>" />
            <button onclick="javascript:doPop('position', '<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>'); return false;">검색버튼</button></div>  
        </td>
        <th><%=CommonLang.get("HTITLE1086")%><!--부서명/부서코드--> <span class="F6495F">*</span></th>
        <td><div class="PerInforSearch" style="width: 250px;" id="st_dept_div">
        <input type="hidden" id="st_department" name="st_department" value="<%=CommonUtil.nvl(_rowData.get("DEPARTMENT")) %>" />
            <input type="text" id="st_department_text" name="st_department_text" maxlength="50" value="<%=CommonUtil.nvl(_rowData.get("DEPARTMENT_TEXT")) %> / <%=CommonUtil.nvl(_rowData.get("DEPARTMENT")) %>"  readonly  style=" width:200px; vertical-align: top; ">
            <button onclick="javascript:doPop('dept', '<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>'); return false;">검색버튼</button></div>  
        </td>
        <th><%=CommonLang.get("HTITLE188")%><!-- 발주부서 --></th>
        <td><div class="PerInforSearch" style="width: 250px;" id="st_pur_div">
        	<input type="hidden" id="st_purchase_dept" name="st_purchase_dept" value="<%=CommonUtil.nvl(_rowData.get("PURCHASE_DEPT")) %>" />
            <input type="text" id="st_purchase_dept_text" name="st_purchase_dept_text" maxlength="50" value="<%=CommonUtil.nvl(_rowData.get("PURCHASE_DEPT_TEXT")) %>"  readonly  style=" width:200px; vertical-align: top; ">
            <button onclick="javascript:doPop('purchase_dept', '<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>'); return false;">검색버튼</button></div>  
        </td>
	  </tr>
	  <tr>
        <th><%=CommonLang.get("HTITLE1087")%><!--배송주소--><span class="F6495F">*</span></th>
        <td colspan="5">
	        <input type="hidden" id="st_dely_to_location" name="st_dely_to_location" value="<%=CommonUtil.nvl(_rowData.get("DELY_TO_LOCATION")) %>" />
	        <%if(p060000112==true){%>
	        <div class="PerInforSearch" style="width:1015px; display:inline-block" id="st_dely_div">
		        <input id="st_dely_text" name="st_dely_text" style="width:950px; vertical-align: top;" maxlength="300"  readonly value="<%=CommonUtil.nvl(_rowData.get("DELY_TEXT")) %>" type="text" />
	        <%}else{ %>
	        <div class="PerInforSearch" style="width:1100px; display:inline-block" id="st_dely_div">
	        	<input id="st_dely_text" name="st_dely_text" style="width:1050px; vertical-align: top;" maxlength="300"  readonly value="<%=CommonUtil.nvl(_rowData.get("DELY_TEXT")) %>" type="text" />
	        <%} %>
	        <%if(p060000057==true&&user_type.equals("U")){%>
            <%}else{ %>
	        <button onclick="javascript:doPop('location', '<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>', '<%=CommonUtil.nvl(_rowData.get("DELY_TO_LOCATION")) %>'); return false;">검색버튼</button>
	        <%} %>
	        </div>
	        <%if(p060000112==true){%>
	        <button class="ButDarkGray_Small" style="vertical-align: top;" onclick="javascript:doPop('addLocation','<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>',''); return false;"><%=CommonLang.get("HTITLE952") %><!-- 도착지추가 --></button>
	        <%}%>
        </td>
      </tr>
      <tr>
        <th rowspan="3"><%=CommonLang.get("HTITLE1082")%><!--권한--></th>
        <td colspan="5"><span class="TdTit"><%=CommonLang.get("HTITLE1083")%><!--메뉴접근--></span> <%=CommonUtil.nvl(_rowData.get("ROLE_NAME")) %>
        <input type="hidden" id="st_role" name="st_role"  value="<%=CommonUtil.nvl(_rowData.get("ROLE")) %>" />
        </td>
	  </tr>
	  <tr>
	  <td colspan="5">
          <span class="TdTit"><%=CommonLang.get("HTITLE1219")%><!--발주권한--></span>
          <%if(CommonUtil.nvl(_rowData.get("PERSON_AUTHOR")).equals("PR")){ %>
          <%=CommonLang.get("HTITLE479")%><!-- 구매요청자 -->
          <%}else{ %>
          <%=CommonLang.get("HTITLE480")%><!-- 구매발주자(직발주) --> 
          <%} %>      
        	<input type="hidden" id="st_person_author" name="st_person_author" value="<%=CommonUtil.nvl(_rowData.get("PERSON_AUTHOR"))%>" />
        </td>
	  </tr>
	  <tr>
	  <td colspan="5">
          <span class="TdTit"><%=CommonLang.get("HTITLE777")%><!-- 신규소싱 --></span>
          <select name="st_user_group" id="st_user_group" class="Select40" style="width:280px;">
            	<option value = "Q" <%=CommonUtil.nvl(_rowData.get("USER_GROUP")).equals("Q")?"selected":""%> <%if( !"A".equals(user_type)){ %> disabled <%} %>> <%=CommonLang.get("HTITLE482") %><!-- 본인 의뢰 건 조회 --></option>
				<option value = "C" <%=CommonUtil.nvl(_rowData.get("USER_GROUP")).equals("C")?"selected":""%> <%if( !"A".equals(user_type)){ %> disabled <%} %>> <%=CommonLang.get("HTITLE483") %><!-- 본인 의뢰 건 조회 및 단가확정 --></option>
				<option value = "A" <%=CommonUtil.nvl(_rowData.get("USER_GROUP")).equals("A")?"selected":""%> <%if( !"A".equals(user_type)){ %> disabled <%} %>> <%=CommonLang.get("HTITLE484") %><!-- 전체 의뢰 건 조회 및 단가확정 --></option>
          </select>          
        </td>
	  </tr>
	  
    </table>
    <div class="SubPageTitMedium mt30"><%=CommonLang.get("HTITLE1092")%><!--시스템 환경설정--></div>	 
    <table class="PerInfor mt10 mb90" >
      <colgroup>
        <col width="150px" />
        <col width="420px" />
        <col width="150px" />
        <col width="560px" />
      </colgroup>
      <tr>
        <th style="display: none;"><%=CommonLang.get("HTITLE453")%><!-- 사용언어 --></th>
        <td style="display: none;"><select name="st_lang" id="st_lang" class="Select40" style="width:392px;" >
           	  <option value="KR" <%=CommonUtil.nvl(_rowData.get("LANG")).equals("KR")?"selected":""%>>Korean</option>
              <option value="US" <%=CommonUtil.nvl(_rowData.get("LANG")).equals("US")?"selected":""%>>English</option>
              <option value="CP" <%=CommonUtil.nvl(_rowData.get("LANG")).equals("CP")?"selected":""%>>Chinese</option>
              <option value="JP" <%=CommonUtil.nvl(_rowData.get("LANG")).equals("JP")?"selected":""%>>Japanese</option>
          </select></td>
        <th><%=CommonLang.get("HTITLE1088")%><!--컨텐츠 조회개수--> <span class="F6495F">*</span></th>
        <td colspan="3"><select name="st_row_cnt" id="st_row_cnt" class="Select40" style="width:393px;">
            	<option value="30" <%=CommonUtil.nvl(_rowData.get("ROW_CNT")).equals("30")?"selected":""%>> 30 </option>
				<option value="50" <%=CommonUtil.nvl(_rowData.get("ROW_CNT")).equals("50")?"selected":""%>> 50 </option>
				<option value="100" <%=CommonUtil.nvl(_rowData.get("ROW_CNT")).equals("100")?"selected":""%>> 100 </option>
				<option value="200" <%=CommonUtil.nvl(_rowData.get("ROW_CNT")).equals("200")?"selected":""%>> 200 </option>
				<option value="500" <%=CommonUtil.nvl(_rowData.get("ROW_CNT")).equals("500")?"selected":""%>> 500 </option>
				<option value="1000" <%=CommonUtil.nvl(_rowData.get("ROW_CNT")).equals("1000")?"selected":""%>> 1000 </option>
          </select></td>
      </tr>
      <tr>
        <th rowspan="2"><%=CommonLang.get("HTITLE457")%><!-- 사용자구분 --></th>
        <td rowspan="2">
          <input type="hidden" id="st_user_type" name="st_user_type" value="<%=CommonUtil.nvl(_rowData.get("USER_TYPE"))%>" readonly/>
          <input type="hidden" id="change_user_type" name="change_user_type" value="<%=CommonUtil.nvl(_rowData.get("USER_TYPE"))%>" readonly/>
          <%if(CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("A")) {%> <%=CommonLang.get("HTITLE458") %> <%}else{ %> <%=CommonLang.get("HTITLE459") %> <%} %>
<!--           <select name="change_user_type" id="change_user_type" class="Select40" style="width:392px;"> -->
<%--             <% if(CommonUtil.nvl(_rowData.get("CHANGE_USER_TYPE")).equals("M")) { %> --%>
<%-- 			<option <%=CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("M")?"selected":""%> value="M"><%=CommonLang.get("HTITLE793") %><!-- 운영자 --></option> --%>
<%-- 			<% } %> --%>
<%-- 			<option <%=CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("A")?"selected":""%> value="A"><%=CommonLang.get("HTITLE458") %><!-- Admin사용자 --></option> --%>
<%-- 			<option <%=CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("U")?"selected":""%> value="U"><%=CommonLang.get("HTITLE459") %><!-- 일반사용자 --></option> --%>
<!--           </select> -->
          <div class="PObr"><img src="/resources/imgs/Icon_Importance02.png" /><%=CommonLang.msg("MSG640")%><!--사용자구분 변경은 운영자의 승인이 필요합니다.--></div>
        </td>
        <th rowspan="2"><%=CommonLang.get("HTITLE1089")%><!--추가인증--><span class="F6495F">*</span></th>
        <td style="vertical-align: top;">
          <span class="TdTit"><%=CommonLang.get("HTITLE1091")%><!--개인정보변경--></span>
          <label class="RadioLargeLabel" style="width:80px"><input type="radio" id="chg_info_pwd_flag1" name="chg_info_pwd_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("CHG_INFO_PWD_YN")).equals("Y")) { %>checked="checked"<% } %>><span class="RadioLargeTxt"></span><%=CommonLang.get("HTITLE932")%><!-- 사용 --></label>
          <label class="RadioLargeLabel" style="width:80px"><input type="radio" id="chg_info_pwd_flag2" name="chg_info_pwd_flag" value="N" <% if (CommonUtil.nvl(_rowData.get("CHG_INFO_PWD_YN")).equals("N")) { %>checked="checked"<% } %>><span class="RadioLargeTxt"></span><%=CommonLang.get("HTITLE933")%><!-- 미사용 --></label> 
        </td>
       	<input type="hidden" id="st_two_factor_flag" name="st_two_factor_flag"  value="<%=CommonUtil.nvl(_rowData.get("TWO_FACTOR_YN"))%>" />
		<input type="hidden" id="st_old_two_factor_flag" name="st_old_two_factor_flag"  value="<%=CommonUtil.nvl(_rowData.get("TWO_FACTOR_YN"))%>" />
		<input type="hidden" id="st_chg_info_pwd_flag" name="st_chg_info_pwd_flag"  value="<%=CommonUtil.nvl(_rowData.get("CHG_INFO_PWD_YN"))%>" />
		<input type="hidden" id="st_old_chg_info_pwd_flag" name="st_old_chg_info_pwd_flag"  value="<%=CommonUtil.nvl(_rowData.get("CHG_INFO_PWD_YN"))%>" />
      </tr>
      <%if("A".equals(user_type)){%> 
      <tr>
        <td > <span class="TdTit"><%=CommonLang.get("HTITLE1090")%><!--로그인--></span>
          <label class="RadioLargeLabel" style="width:80px"><input type="radio" id="two_factor_flag1" name="two_factor_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("TWO_FACTOR_YN")).equals("Y")) { %>checked="checked"<% } %>><span class="RadioLargeTxt"></span><%=CommonLang.get("HTITLE932")%><!-- 사용 --></label>
          <label class="RadioLargeLabel" style="width:80px"><input type="radio" id="two_factor_flag2" name="two_factor_flag" value="N" <% if (CommonUtil.nvl(_rowData.get("TWO_FACTOR_YN")).equals("N")) { %>checked="checked"<% } %>><span class="RadioLargeTxt"></span><%=CommonLang.get("HTITLE933")%><!-- 미사용 --></label> 
        </td>
      </tr>
      <%}%>
    </table>
    <div class="ac"><button class="ButPrimary_large" style=" width:150px" id="" onclick="javascript:doAction('save'); return false;"><%=CommonLang.get("HTITLE124")%><!-- 저장 --></button></div>         
    <div class="h80"></div>
    <%} %>	 
    </form>

	<form name="processForm" id="processForm" method="post">	
		<div id="process">
		
		</div>
	</form> 	 
  </div><!-- container 끝 -->
  
</div>
<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>   
</div>
</body>


</html>
