<%--
**********************************************
* 메뉴 : 
* 화면 : 장바구니 > 명함 정보 입력 팝업(클린킹/가전에어컨)
* 기능 : 에스와이에스리테일(KRSYSR0001) 지점용 명함 정보입력 팝업
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
SessionInfo sessionInfoPop = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"), sessionInfoPop.getComCode());
String st_user_id =  CommonUtil.nvl((String) request.getParameter("st_user_id"), sessionInfoPop.getUserId());
String st_seq = CommonUtil.nvl((String) request.getParameter("st_seq"),"");
String st_center = CommonUtil.nvl((String) request.getParameter("param_text"),"");
String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"");
%>
<script type="text/javascript">
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
		
		if(remark_arr.length == 4 || remark_arr.length == 5){ // 클린킹 4, 가정에어컨 5(물류센터 주소 추가)
			for(var i=0; i<remark_arr.length; i++){
				if(i == 0){ // 협력사명
					document.forms.contentForm.st_agent.value = remark_arr[i];
				}else if(i == 1){ // 성명
					document.forms.contentForm.st_kor_name.value = remark_arr[i];
				}else if(i == 2){ // 물류센터명 - 파라미터로 받음
				}else if(i == 3){ // 휴대폰번호
					document.forms.contentForm.st_mobile_no.value = remark_arr[i];
				}
			}
		}else if(remark_arr.length != 1){ // 최초등록은 1
			// 명함정보가 올바르지 않습니다. KEP관리자에게 문의해주시기 바랍니다.
			var text = "<%=CommonLang.msg("MSG435") %>  ";
	     	openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
<%
	}
%>
}

function setReturn(){
	var agent = document.forms.contentForm.st_agent.value;
	var kor_name = document.forms.contentForm.st_kor_name.value;
	var center = $("#st_center option:selected").text();
	var mobile_no = document.forms.contentForm.st_mobile_no.value;
	var center_code = document.forms.contentForm.st_center.value;
	var remark = "";
	
	if(isEmpty(agent) || isEmpty(kor_name) || center == "<%=CommonLang.get("HTITLE178")%>" || isEmpty(mobile_no)){ //선택
		//* 표시된 필수 명함정보를 모두 입력해주세요
		var text = "<%=CommonLang.msg("MSG863") %>  ";
     	openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	remark	=	agent + ";"
			+	kor_name + ";"
			+	center + ";"
			+	mobile_no;
	
	document.forms.searchCondition.st_remark.value = remark;
	document.forms.searchCondition.st_center_code.value = center_code;
	kepAjaxFormCall("/mpso/saveBuyerMpSoCartRemarkNameCard.do","searchCondition","");
}

function setPopupReturn(value1, value2, value3){
	document.forms.contentForm.st_agent.value = value3;
}

function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	var remark = document.forms.searchCondition.st_remark.value;
	
	if (!isEmpty(msg)){
		//명함정보가 정상적으로 저장되었습니다.
		var text = "<%=CommonLang.msg("MSG864") %>  ";
     	openLayerPopText2(text,but1text,but1funcSearch,but1width);
		return;
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
		var text = msg;
     	openLayerPopText2(text,but1text,but1func,but1width);
	}
	return;
}

//팝업함수호출
function doPop(str){
	switch (str){
		case "HAAC": // 가전에어컨
			popupSel = "get_agent";
			var st_buyer = "<%=st_buyer%>";
			var st_gbn = "<%=CommonLang.get("HTITLE1384")%>"; //협력사리스트
			var st_type = "HAAG";
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
	<input type="hidden" name="st_center_code" id="st_center_code" value="">
	<input type="hidden" name="st_type" id="st_type" value="<%=st_type%>">
</form>
<form name="contentForm" id="contentForm" method=post >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE1368")%><!--명함 정보 입력--></div>
  <table  class="PopupSearchTableNoline mt10" width="820px"    >
	<colgroup>
      <col width="150px" />
      <col width="220px" />
      <col width="120px" />
      <col width="240px" />
	</colgroup>
	<tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE567")%><!--협력사명--></th>
      <td>
      	<div class="SearchPopupInput38" style="width:230px;">
        <input type="text" name="st_agent" id="st_agent" style=" width:78%;" value="" readonly>
        <button type="button" onclick="javascript:doPop('<%=st_type %>'); return false;"></button> </div> </td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1385")%><!-- 성명 --></th>
      <td><input class="input40" style="width:235px" name="st_kor_name" id="st_kor_name" type="text"/></td>
    </tr>
	<tr>
		<th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1386")%><!--물류센터명--></th>
		<td><select id="st_center" name="st_center" class="Select40" style="width:232px" >
				<%= CommonUtil.getTextComboList(st_buyer,"SEL","SYCT","ICOMCOD2","CODE",st_center)%>
        </select></td>
        
        <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1378")%><!--휴대폰번호--></th>
      	<td><input class="input40" style="width:235px" name="st_mobile_no" id="st_mobile_no" type="text" /></td>
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
