<%--
**********************************************
* 메뉴 :
* 화면 : 장바구니 > 명함 정보 입력 팝업(LS오토모티브)
* 기능 : 명함 정보입력 팝업 - 국/영문 양면 명함 정보를 한 번에 입력받음
*        (앞면=국문, 뒷면=영문. REMARK 필드 순서는 이 파일과 buyerMpSoCartList_v2.jsp의
*        nameCardView() LSAT 분기가 공유하는 규약이므로 두 곳을 항상 같이 수정할 것)
* 프로그램 ID :
* 착수일 : 2026-09-02
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<!doctype html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<%
@SuppressWarnings (value="unchecked")
Map<String,String> _dataList = (Map<String,String>) request.getAttribute("data");
SessionInfo _sessionInfoPop = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfoPop.getComCode());
String st_user_id =  CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfoPop.getUserId());
String st_seq = CommonUtil.nvl((String) request.getParameter("st_seq"),"");
String st_type = CommonUtil.nvl((String) request.getAttribute("st_type"), "LSAT");
// 근무지 콤보박스: 기존 공용 유틸(CommonUtil.getCodeComboQueryIdList)이 기대하는 CODE/TEXT1 형식의
Map<String, String> _wkplSearch = new java.util.HashMap<String, String>();
_wkplSearch.put("st_buyer", st_buyer);
%>
<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

// REMARK 필드 순서(총 15개, ';' 구분) - setReturn()/kep_onload()/buyerMpSoCartList_v2.jsp의 nameCardView()가 공유하는 규약
// 0 이름(국문) / 1 이름(영문) / 2 직급(국문) / 3 직급(영문) / 4 소속·부서명(국문) / 5 소속·부서명(영문)
// 6 직통번호(국문) / 7 직통번호(영문) / 8 팩스번호(국문) / 9 팩스번호(영문) / 10 휴대번호(국문) / 11 휴대번호(영문)
// 12 e-mail
// 13 근무지주소(국문, 저장 시 서버가 층수까지 넣어서 자동첨부) / 14 근무지주소(영문, 〃)
// 근무지코드/층수 자체는 REMARK에 남기지 않음(실제로 필요한 정보는 이미 주소 안에 다 있음) -
// 이 팝업을 다시 열어 수정할 때는 근무지/층수를 다시 선택해야 함(자동 복원 안 됨)

// 국내(0xx-xxxx-xxxx) <-> 국제(+82 xx-xxxx-xxxx) 형식 상호 변환.
// 형식이 정확히 맞을 때만 변환하고, 내선번호처럼 표준 전화번호 형식이 아니면 그대로 null 리턴(건드리지 않음).
// 서울(02)만 지역번호가 1자리(2), 나머지 지역/휴대폰은 2자리.
function convertKrPhone(value){
	value = (value || "").trim();
	var kr = value.match(/^0(2|1[016789]|[3-6]\d)[-\s]?(\d{3,4})[-\s]?(\d{4})$/);
	if(kr){
		return "+82 " + kr[1] + "-" + kr[2] + "-" + kr[3];
	}
	var intl = value.match(/^\+82[-\s]?(2|1[016789]|[3-6]\d)[-\s]?(\d{3,4})[-\s]?(\d{4})$/);
	if(intl){
		return "0" + intl[1] + "-" + intl[2] + "-" + intl[3];
	}
	return null;
}

// 국/영문 짝 필드 중 하나에 올바른 형식으로 입력하면, 비어있는 반대쪽 칸을 자동으로 채워줌.
// 반대쪽에 이미 값이 있으면 덮어쓰지 않음(사용자가 직접 입력한 값 보존).
function syncPhonePair(sourceId, targetId){
	var srcVal = document.getElementById(sourceId).value;
	var targetEl = document.getElementById(targetId);
	if(!isEmpty(targetEl.value)) return;
	var converted = convertKrPhone(srcVal);
	if(converted){
		targetEl.value = converted;
	}
}

function kep_onload(){
<%
	if(_dataList != null && _dataList.size() > 0){
%>
		var st_remark = "<%=CommonUtil.nvl(_dataList.get("CART_REMARK"))%>";
		var remark_arr = st_remark.split(";");
		if(remark_arr.length == 15){
			for(var i=0; i<remark_arr.length; i++){
				if(i == 0){ // 이름(국문)
					document.forms.contentForm.st_name_ko.value = remark_arr[i];
				}else if(i == 1){ // 이름(영문)
					document.forms.contentForm.st_name_en.value = remark_arr[i];
				}else if(i == 2){ // 직급(국문)
					document.forms.contentForm.st_position_ko.value = remark_arr[i];
				}else if(i == 3){ // 직급(영문)
					document.forms.contentForm.st_position_en.value = remark_arr[i];
				}else if(i == 4){ // 소속/부서명(국문)
					document.forms.contentForm.st_dept_ko.value = remark_arr[i];
				}else if(i == 5){ // 소속/부서명(영문)
					document.forms.contentForm.st_dept_en.value = remark_arr[i];
				}else if(i == 6){ // 직통번호(국문)
					document.forms.contentForm.st_phone_no_ko.value = remark_arr[i];
				}else if(i == 7){ // 직통번호(영문)
					document.forms.contentForm.st_phone_no_en.value = remark_arr[i];
				}else if(i == 8){ // 팩스번호(국문)
					document.forms.contentForm.st_fax_no_ko.value = remark_arr[i];
				}else if(i == 9){ // 팩스번호(영문)
					document.forms.contentForm.st_fax_no_en.value = remark_arr[i];
				}else if(i == 10){ // 휴대번호(국문)
					document.forms.contentForm.st_mobile_no_ko.value = remark_arr[i];
				}else if(i == 11){ // 휴대번호(영문)
					document.forms.contentForm.st_mobile_no_en.value = remark_arr[i];
				}else if(i == 12){ // e-mail
					document.forms.contentForm.st_email.value = remark_arr[i];
				}else if(i == 13){ // 근무지 주소(국문) - 저장 시 서버가 자동으로 채운 값
					document.getElementById('st_addr_view_ko').value = remark_arr[i];
				}else if(i == 14){ // 근무지 주소(영문) - 저장 시 서버가 자동으로 채운 값
					document.getElementById('st_addr_view_en').value = remark_arr[i];
				}
			}
			// 근무지코드/층수는 REMARK에 없어서 자동 복원 불가 - 필요하면 다시 선택
			toggleFloorRow();
		}else if(remark_arr.length != 1){
			var text = "<%=CommonLang.msg("MSG435")%>"; // 명함정보가 올바르지 않습니다. KEP관리자에게 문의해주시기 바랍니다.
	     	openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
<%
	}
%>
}

function toggleFloorRow(){
	var workplace = document.getElementById('st_workplace').value;
	var display = (workplace == 'HQ') ? '' : 'none';
	document.getElementById('floorRow').style.display = display;
	document.getElementById('floorCell').style.display = display;
	if(workplace != 'HQ'){
		document.getElementById('st_floor').value = '';
	}
}

// 근무지 선택 시(사용자 조작) - 층수 표시 여부 갱신 + ajax로 국/영문 상세주소 미리보기 조회.
// 한샘 명함 팝업이 직위/직급 자동판별에 쓰는 것과 같은 /mpso/getNameCardPositionType.do를
// 그대로 재사용(st_code2로 근무지코드 매칭 - 저장 시점 서버 로직과 동일한 쿼리를 공유).
function onWorkplaceChange(){
	toggleFloorRow();

	var workplace = document.getElementById('st_workplace').value;
	document.getElementById('st_addr_view_ko').value = '';
	document.getElementById('st_addr_view_en').value = '';
	if(isEmpty(workplace)) return;

	$.ajax({
		url: '/mpso/getNameCardPositionType.do',
		type: 'POST',
		dataType: 'json',
		data: {
			st_buyer: '<%=st_buyer%>',
			st_code2: workplace,
			type: 'NCIF',
			code1Csv: 'WKPL'
		},
		success: function(response){
			if(response.result == 'success' && response.columnInfo){
				document.getElementById('st_addr_view_ko').value = response.columnInfo.TEXT2 || '';
				document.getElementById('st_addr_view_en').value = response.columnInfo.TEXT3 || '';
			}
		},
		error: function(){
			console.log('근무지 주소 조회 실패');
		}
	});
}

function setReturn(){
	var name_ko = document.forms.contentForm.st_name_ko.value;
	var name_en = document.forms.contentForm.st_name_en.value;
	var position_ko = document.forms.contentForm.st_position_ko.value;
	var position_en = document.forms.contentForm.st_position_en.value;
	var dept_ko = document.forms.contentForm.st_dept_ko.value;
	var dept_en = document.forms.contentForm.st_dept_en.value;
	var phone_no_ko = document.forms.contentForm.st_phone_no_ko.value;
	var phone_no_en = document.forms.contentForm.st_phone_no_en.value;
	var fax_no_ko = document.forms.contentForm.st_fax_no_ko.value;
	var fax_no_en = document.forms.contentForm.st_fax_no_en.value;
	var mobile_no_ko = document.forms.contentForm.st_mobile_no_ko.value;
	var mobile_no_en = document.forms.contentForm.st_mobile_no_en.value;
	var email = document.forms.contentForm.st_email.value;
	var workplace = document.forms.contentForm.st_workplace.value;
	var floor = document.forms.contentForm.st_floor.value;
	var remark = "";

	// REMARK가 ';' 구분자로 저장/전달(엑셀로 협력사 확인용까지 그대로 나감)되므로,
	// 입력값에 ';'가 섞이면 필드가 밀려서 전체 데이터가 깨짐 - 저장 전에 반드시 차단
	var checkFields = [
		["<%=CommonLang.get("HTITLE451")%>", name_ko], ["<%=CommonLang.get("HTITLE452")%>", name_en],
		["<%=CommonLang.get("HTITLE1515")%>", position_ko], ["<%=CommonLang.get("HTITLE1516")%>", position_en],
		["<%=CommonLang.get("HTITLE1517")%>", dept_ko], ["<%=CommonLang.get("HTITLE1518")%>", dept_en],
		["<%=CommonLang.get("HTITLE1519")%>", phone_no_ko], ["<%=CommonLang.get("HTITLE1520")%>", phone_no_en],
		["<%=CommonLang.get("HTITLE1521")%>", fax_no_ko], ["<%=CommonLang.get("HTITLE1522")%>", fax_no_en],
		["<%=CommonLang.get("HTITLE1523")%>", mobile_no_ko], ["<%=CommonLang.get("HTITLE1524")%>", mobile_no_en],
		["<%=CommonLang.get("HTITLE1525")%>", email], ["<%=CommonLang.get("HTITLE1527")%>", floor]
	];
	for(var ci=0; ci<checkFields.length; ci++){
		if(checkFields[ci][1].indexOf(";") != -1){
			var text = checkFields[ci][0] + "<%=CommonLang.msg("MSG1001")%>"; // 에는 세미콜론(;)을 입력할 수 없습니다.
	     	openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}

	if(isEmpty(name_ko) || isEmpty(name_en) || isEmpty(position_ko) || isEmpty(position_en)
			|| isEmpty(dept_ko) || isEmpty(dept_en)
			|| isEmpty(fax_no_ko) || isEmpty(fax_no_en)
			|| isEmpty(mobile_no_ko) || isEmpty(mobile_no_en)
			|| isEmpty(email) || isEmpty(workplace)){
		var text = "<%=CommonLang.msg("MSG863")%>"; // * 표시된 필수 명함정보를 모두 입력해주세요
     	openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}

	if(workplace == 'HQ' && isEmpty(floor)){
		var text = "<%=CommonLang.msg("MSG1002")%>"; // 본사는 층수를 필수로 기재해 주십시오.
     	openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}

	// 근무지코드/층수 자체는 REMARK에 안 넣음 - 실제로 읽어야 할 정보(층수 포함 실주소)는
	// 서버가 이 뒤에 붙여주는 근무지주소(국/영문)에 이미 다 들어있음
	remark	=	name_ko + ";"
			+	name_en + ";"
			+	position_ko + ";"
			+	position_en + ";"
			+	dept_ko + ";"
			+	dept_en + ";"
			+	phone_no_ko + ";"
			+	phone_no_en + ";"
			+	fax_no_ko + ";"
			+	fax_no_en + ";"
			+	mobile_no_ko + ";"
			+	mobile_no_en + ";"
			+	email;

	document.forms.searchCondition.st_remark.value = remark;
	document.forms.searchCondition.st_workplace_code.value = workplace;
	document.forms.searchCondition.st_floor.value = floor;
	kepAjaxFormCall("/mpso/saveBuyerMpSoCartRemarkNameCard.do","searchCondition","");
}

function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;

	if (!isEmpty(msg)){
		// 서버가 근무지주소(국/영문)까지 붙여 저장한 최종 REMARK(15필드)로 갱신
		// - 이걸 안 하면 클라이언트가 만든 값이 그대로 opener로 돌아가서
		//   장바구니 화면의 nameCardView()가 15필드 기준으로 파싱하다 오류남
		document.forms.searchCondition.st_remark.value = msg;
		var text = "<%=CommonLang.msg("MSG864")%>"; // 명함정보가 정상적으로 저장되었습니다.
     	openLayerPopText2(text,but1text,but1funcSearch,but1width);
	}
	return;
}
function thisPopClose(){
	closePopText2();

	var remark = document.forms.searchCondition.st_remark.value;
	opener.setPopupReturn(remark);
	this.close();
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;

	if (!isEmpty(msg)){
		alert(msg);
	}
	return;
}
</script>
<body onload="kep_onload()">
<form id ="searchCondition" name="searchCondition" method = "post" onsubmit="return false">
	<input type="hidden" id="st_buyer" name="st_buyer" value="<%=st_buyer%>"/>
	<input type="hidden" name="st_user_id" id="st_user_id" value="<%=st_user_id%>">
	<input type="hidden" name="st_seq" id="st_seq" value="<%=st_seq%>">
	<input type="hidden" name="st_remark" id="st_remark" value="">
	<input type="hidden" name="st_workplace_code" id="st_workplace_code" value="">
	<input type="hidden" name="st_floor" id="st_floor_param" value="">
	<input type="hidden" name="st_type" id="st_type" value="<%=st_type%>">
</form>
<form name="contentForm" id="contentForm" method=post >
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE1368")%><!-- 명함 정보 입력 --><span class="font500 font15px" style="margin-left:8px;"><%=CommonLang.get("HTITLE1530")%><!-- (국/영문 양면) --></span></div>
  <table  class="PopupSearchTableNoline mt10" width="820px"    >
	<colgroup>
      <col width="150px" />
      <col width="220px" />
      <col width="120px" />
      <col width="240px" />
	</colgroup>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE451")%><!-- 이름(국문) --></th>
      <td><input class="input40" style="width:210px" name="st_name_ko" id="st_name_ko" type="text" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE452")%><!-- 이름(영문) --></th>
      <td><input class="input40" style="width:235px" name="st_name_en" id="st_name_en" type="text"  /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1515")%><!-- 직급(국문) --></th>
      <td><input class="input40" style="width:210px" name="st_position_ko" id="st_position_ko" type="text" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1516")%><!-- 직급(영문) --></th>
      <td><input class="input40" style="width:235px" name="st_position_en" id="st_position_en" type="text" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1517")%><!-- 소속/부서명(국문) --></th>
      <td><input class="input40" style="width:210px" name="st_dept_ko" id="st_dept_ko" type="text" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1518")%><!-- 소속/부서명(영문) --></th>
      <td><input class="input40" style="width:235px" name="st_dept_en" id="st_dept_en" type="text" /></td>
    </tr>
    <tr>
      <th>&nbsp;&nbsp; <%=CommonLang.get("HTITLE1519")%><!-- 직통번호(국문) --></th>
      <td><input class="input40" style="width:210px" name="st_phone_no_ko" id="st_phone_no_ko" type="text" placeholder="032-0000-0000" onblur="javascript:syncPhonePair('st_phone_no_ko','st_phone_no_en');" /></td>
      <th>&nbsp;&nbsp; <%=CommonLang.get("HTITLE1520")%><!-- 직통번호(영문) --></th>
      <td><input class="input40" style="width:235px" name="st_phone_no_en" id="st_phone_no_en" type="text" placeholder="+82 32-0000-0000" onblur="javascript:syncPhonePair('st_phone_no_en','st_phone_no_ko');" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1521")%><!-- 팩스번호(국문) --></th>
      <td><input class="input40" style="width:210px" name="st_fax_no_ko" id="st_fax_no_ko" type="text" placeholder="032-0000-0000" onblur="javascript:syncPhonePair('st_fax_no_ko','st_fax_no_en');" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1522")%><!-- 팩스번호(영문) --></th>
      <td><input class="input40" style="width:235px" name="st_fax_no_en" id="st_fax_no_en" type="text" placeholder="+82 32-0000-0000" onblur="javascript:syncPhonePair('st_fax_no_en','st_fax_no_ko');" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1523")%><!-- 휴대번호(국문) --></th>
      <td><input class="input40" style="width:210px" name="st_mobile_no_ko" id="st_mobile_no_ko" type="text" placeholder="010-0000-0000" onblur="javascript:syncPhonePair('st_mobile_no_ko','st_mobile_no_en');" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1524")%><!-- 휴대번호(영문) --></th>
      <td><input class="input40" style="width:235px" name="st_mobile_no_en" id="st_mobile_no_en" type="text" placeholder="+82 10-0000-0000" onblur="javascript:syncPhonePair('st_mobile_no_en','st_mobile_no_ko');" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1525")%><!-- e-mail --></th>
      <td><input class="input40" style="width:210px" name="st_email" id="st_email" type="text" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1526")%><!-- 근무지 --></th>
      <td>
      	<select class="Select40" style="width:235px" name="st_workplace" id="st_workplace" onchange="javascript:onWorkplaceChange();">
      		<option value=""><%=CommonLang.get("HTITLE178")%><!-- 선택 --></option>
      		<%= CommonUtil.getCodeComboQueryIdList("common.mpso.selectBuyerMpSoNameCardWorkplaceCombo","NO",_wkplSearch,"") %>
      	</select>
      </td>
    </tr>
    <tr>
      <th id="floorRow" style="display:none"><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1527")%><!-- 층수 --></th>
      <td id="floorCell" style="display:none">
      	<input class="input40" style="width:210px" name="st_floor" id="st_floor" type="text" placeholder="<%=CommonLang.get("HTITLE1531")%>" /><!-- 숫자만 입력 (예: 3) -->
      </td>
      <td colspan="2"></td>
    </tr>
    <tr>
      <th>&nbsp;&nbsp; <%=CommonLang.get("HTITLE1528")%><!-- 근무지주소(국문) --></th>
      <td colspan="3"><input class="input40" id="st_addr_view_ko" value="" style="width:640px" type="text" readOnly/></td>
    </tr>
    <tr>
      <th>&nbsp;&nbsp; <%=CommonLang.get("HTITLE1529")%><!-- 근무지주소(영문) --></th>
      <td colspan="3"><input class="input40" id="st_addr_view_en" value="" style="width:640px" type="text" readOnly/></td>
    </tr>
	</table>
  <div class="PopupListBtnBox_Center mt15">
    <button class="ButDarkGray_Medium" style="width:150px" onclick="javascript:setReturn(); return false;" ><%=CommonLang.get("HTITLE1383")%><!-- 확인 후 시안보기 --></button>
  </div>
</div>
</form>
</body>
</html>
