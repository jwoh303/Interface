<%--
**********************************************
* 메뉴 : 
* 화면 : 송장번호입력
* 기능 : 송장번호 입력을 위한  팝업
* 프로그램 ID : 
* 담당자 :
* 착수일 : 2024-03-26
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	Map<String,String> _map = (Map<String,String>) request.getAttribute("_data");

	String buyer = CommonUtil.nvl(_map.get("st_buyer"));
	String inv_no =  CommonUtil.nvl(_map.get("st_inv_no"));
	String parcel_com_code = CommonUtil.nvl(_map.get("st_parcel_com_code"));
	String parcel_inv_no = CommonUtil.nvl(_map.get("st_parcel_inv_no"));
	String num = CommonUtil.nvl(_map.get("st_num"));
%>
<script type="text/javascript">

var popupSel = "";

//최초 화면 함수 
function kep_onload_view(){
	kepAjaxCommonComboDataValue("st_parcel_com_code", "C019", "SEL", "<%=parcel_com_code%>");
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
		
	if (!isEmpty(msg)){
		alert(msg);
	}
	return;
}
function doAction(str) {
	switch (str) {
		case "saveParcel":	//택배사정보 저장
			if(parcelInvNoCheck()){
				setParcel();
			}
			break;
	}
}

function parcelInvNoCheck(){
	if(!kepIsAlphaNum("parcel_inv_no")){
		alert("영문, 숫자만 입력가능합니다.");
		$("#parcel_inv_no").focus();
		return false;
	}
	return true;
}
//택배사정보등록
function setParcel(){
	
	parcel_com_code = $("#st_parcel_com_code").val();
	parcel_inv_no 	= $("#parcel_inv_no").val();
	
	if(isEmpty(parcel_com_code)){
		alert("택배사정보를 선택해주십시오.");
		return;
	}	

	if(isEmpty(parcel_inv_no)){
		alert("운송장번호를 입력해주십시오.");
		return;
	}
	
	if(!confirm("택배사정보를 등록 하시겠습니까?")) return;
	
	$("#parcel_com_code").val(parcel_com_code);
	
	kepAjaxFormCall("/mpiv/saveSellerMpIvDeliveryRecordParcelRegPop.do","contentForm","btnParcel");
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	if(pMethod == "btnParcel"){
		kepAjaxFormCall("/mpiv/getSellerMpIvDeliveryRecordParcelRegPop.do","contentForm","newParcel");
	}if(pMethod == "newParcel"){
		var data = response.data;
		alert("택배사 정보가 정상적으로 등록되었습니다.");
	 	opener.setPopupReturn( $("#parcel_inv_no").val(), data.PARCEL_COM_CODE, data.PARCEL_COM_NAME, data.PARCEL_REAL_URL, "<%=num%>");
		this.close();		
	} else 
	
	return;
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
</head>

<body onload="kep_onload_view()">
<form name = "contentForm" id="contentForm" method = "post">
	<input type="hidden" id = "parcel_com_code" name = "parcel_com_code" value="<%=CommonUtil.nvl(parcel_com_code)%>">
	<input type="hidden" id = "buyer" name ="buyer" value="<%=CommonUtil.nvl(buyer)%>">
	<input type="hidden" id = "inv_no" name ="inv_no" value="<%=CommonUtil.nvl(inv_no)%>">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">택배송장 입력</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
			<table width="100%"  class="cont_t_list02">
				<th>택배사</td>
				<th>택배송장 번호</th>
				<tr> 
					<td> 
						<select id="st_parcel_com_code" name="st_parcel_com_code"></select>
 					</td>
					<td><input type="text" id="parcel_inv_no" name="parcel_inv_no" value="<%=CommonUtil.nvl(parcel_inv_no)%>" maxlength="25"/></td>
				</tr>
			</table>
			<div class="fr">
				<span class="btn_04"><a href="javascript:doAction('saveParcel');">적용</a></span>	
	        </div>
		</div>
	</div>
</form> 
</body>
</html>
