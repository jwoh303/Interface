<%--
**********************************************
* 메뉴 : 
* 화면 : 장바구니 > 명함 정보 입력 팝업(본사)
* 기능 : 에스와이에스리테일(KRSYSR0001) 본사 명함 정보입력 팝업
* 프로그램 ID :
* 담당자 : 최찬규
* 착수일 : 2026-05-26
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
%>
<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var popupSel = "";

function kep_onload(){
<%	
	if(_dataList != null || _dataList.size() > 0){
%>
		var st_remark = "<%=CommonUtil.nvl(_dataList.get("CART_REMARK"))%>";
		var remark_arr = st_remark.split(";");
		if(remark_arr.length == 12){
			for(var i=0; i<remark_arr.length; i++){
				if(i == 0){ // 성명
					document.forms.contentForm.st_kor_name.value = remark_arr[i];
				}else if(i == 1){ // 성명(영문)
					document.forms.contentForm.st_eng_name.value = remark_arr[i];
				}else if(i == 2){ // 팀명
					document.forms.contentForm.st_kor_team.value = remark_arr[i];
				}else if(i == 3){ // 그룹명_직위
					document.forms.contentForm.st_kor_group.value = remark_arr[i];
				}else if(i == 4){ // 내선번호
					document.forms.contentForm.st_phone_no.value = remark_arr[i];
				}else if(i == 5){ // 팩스번호
					document.forms.contentForm.st_fax_no.value = remark_arr[i];
				}else if(i == 6){ // 휴대폰번호
					document.forms.contentForm.st_mobile_no.value = remark_arr[i];
				}else if(i == 7){ // 이메일주소
					document.forms.contentForm.st_email.value = remark_arr[i];
				}else if(i == 8){ // 지점주소
					document.forms.contentForm.st_kor_addr.value = remark_arr[i];
				}else if(i == 9){ // 팀명(영문)
					document.forms.contentForm.st_eng_team.value = remark_arr[i];
				}else if(i == 10){ // 그룹명_직위(영문)
					document.forms.contentForm.st_eng_group.value = remark_arr[i];
				}else if(i == 11){ // 지점주소(영문)
					document.forms.contentForm.st_eng_addr.value = remark_arr[i];
				}
			}
		}else if(remark_arr.length != 1){
			alert("<%=CommonLang.msg("MSG435")%>"); // 명함정보가 올바르지 않습니다. KEP관리자에게 문의해주시기 바랍니다.
			return;
		}
<%
	}
%>
}

function setReturn(){
	var kor_name = document.forms.contentForm.st_kor_name.value;
	var eng_name = document.forms.contentForm.st_eng_name.value;
	var kor_team = document.forms.contentForm.st_kor_team.value;
	var kor_group = document.forms.contentForm.st_kor_group.value;
	var phone_no = document.forms.contentForm.st_phone_no.value;
	var fax_no = document.forms.contentForm.st_fax_no.value;
	var mobile_no = document.forms.contentForm.st_mobile_no.value;
	var email = document.forms.contentForm.st_email.value;
	var kor_addr = document.forms.contentForm.st_kor_addr.value;
	var eng_team = document.forms.contentForm.st_eng_team.value;
	var eng_group = document.forms.contentForm.st_eng_group.value;
	var eng_addr = document.forms.contentForm.st_eng_addr.value;
	var remark = "";

	if(isEmpty(kor_name) || isEmpty(eng_name) || isEmpty(kor_team) || isEmpty(kor_group) || isEmpty(fax_no) || isEmpty(mobile_no) || isEmpty(email) || isEmpty(kor_addr) || isEmpty(eng_team) || isEmpty(eng_group) || isEmpty(eng_addr)){
		//* 표시된 필수 명함정보를 모두 입력해주세요
		var text = "<%=CommonLang.msg("MSG863") %>  ";
     	openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	remark	=	kor_name + ";"
			+	eng_name + ";"
			+	kor_team + ";"
			+	kor_group + ";"
			+	phone_no + ";"
			+	fax_no + ";"
			+	mobile_no + ";"
			+	email + ";"
			+	kor_addr + ";"
			+	eng_team + ";"
			+	eng_group + ";"
			+	eng_addr;
	
	document.forms.searchCondition.st_remark.value = remark;
	kepAjaxFormCall("/mpso/saveBuyerMpSoCartRemarkNameCard.do","searchCondition","");
}

function setPopupReturn(value1,value2,value3){
	document.forms.contentForm.st_kor_addr.value = value2;
	document.forms.contentForm.st_eng_addr.value = value3;
}

function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	var remark = document.forms.searchCondition.st_remark.value;
	
	if (!isEmpty(msg)){
		//명함정보가 정상적으로 저장되었습니다.
		var text = "<%=CommonLang.msg("MSG864") %>  ";
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

//팝업함수호출
function doPop(str){
	popupSel = str;
	
	switch (str){
		case "get_address": // 지점명
			popupSel = "get_address";
			var st_buyer = "<%=st_buyer%>";
			var st_gbn = "<%=CommonLang.get("HTITLE1376")%>";//지점주소
			var st_type = "HQBR";
			var st_code = "";
			var st_text = "";
		    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "700,500,no");
			break;
	}
}

</script>
<body onload="kep_onload()">
<form id ="searchCondition" name="searchCondition" method = "post" onsubmit="return false">
	<input type="hidden" id="st_buyer" name="st_buyer" value="<%=st_buyer%>"/>
	<input type="hidden" name="st_user_id" id="st_user_id" value="<%=st_user_id%>">
	<input type="hidden" name="st_seq" id="st_seq" value="<%=st_seq%>">
	<input type="hidden" name="st_remark" id="st_remark" value="">
</form>
<form name="contentForm" id="contentForm" method=post >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE1368")%><!--명함 정보 입력-->
  <span class="font500 font15px F6495F pt05">* <%=CommonLang.get("HTITLE1391")%><!-- 영문 성명 기입 유의사항: 각 이름 첫영문자 대문자로 표기 (Hong Suk Su) --></span>
  </div>
  <table  class="PopupSearchTableNoline mt10" width="820px"    >
	<colgroup>
      <col width="150px" />
      <col width="220px" />
      <col width="120px" />
      <col width="240px" />
	</colgroup>
	<tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1385")%><!--성명--></th>
      <td><input class="input40" style="width:210px" name="st_kor_name" id="st_kor_name" type="text" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1394")%><!-- 성명(영문) --></th>
      <td><input class="input40" style="width:235px" name="st_eng_name" id="st_eng_name" type="text"  /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1395")%><!--팀명--></th>
      <td><input class="input40" style="width:210px" name="st_kor_team" id="st_kor_team" type="text" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1396")%><!--팀명(영문)--></th>
      <td><input class="input40" style="width:235px" name="st_eng_team" id="st_eng_team" type="text"  /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1397")%><!--그룹명/직위--></th>
      <td><input class="input40" style="width:210px" name="st_kor_group" id="st_kor_group" type="text" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1398")%><!-- 그룹명/직위(영문) --></th>
      <td><input class="input40" style="width:235px" name="st_eng_group" id="st_eng_group" type="text"  /></td>
    </tr>
    <tr>
      <th>&nbsp;&nbsp; <%=CommonLang.get("HTITLE1399")%><!--내선번호--></th>
      <td><input class="input40" style="width:210px" name="st_phone_no" id="st_phone_no" type="text" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE43")%><!-- 팩스번호 --></th>
      <td><input class="input40" style="width:235px" name="st_fax_no" id="st_fax_no" type="text" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1378")%><!--휴대폰번호--></th>
      <td><input class="input40" style="width:210px" name="st_mobile_no" id="st_mobile_no" type="text" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1379")%><!-- 이메일주소 --></th>
      <td><input class="input40" style="width:235px" name="st_email" id="st_email" type="text" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1376")%><!--지점주소--></th>
      <td colspan="3">
      	<div class="SearchPopupInput38" style="width:640px;">
        <input type="text" name="st_kor_addr" id="st_kor_addr" style=" width:78%;" value="" readonly>
        <button type="button" onclick="javascript:doPop('get_address'); return false;"></button> </div> </td>
    </tr>
    <tr>
		<th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1400")%><!--지점주소(영문)--></th>
		<td colspan="3"><input class="input40" name="st_eng_addr" id="st_eng_addr" value="" style="width:620px" type="text" readOnly/></td>
	</tr>
	
    
	</table>
  <div class="PopupListBtnBox_Center mt15">
    <!--button class="ButOutline_Medium" style="width:120px" >초기화</button--> 
    <button class="ButDarkGray_Medium" style="width:150px" onclick="javascript:setReturn(); return false;" ><%=CommonLang.get("HTITLE1383")%><!--확인 후 시안보기--></button> 
  </div> 
</div><!-- wrapPopup 끝-->  
</form>
</body>
</html>
