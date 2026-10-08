<%--
**********************************************
* 메뉴 : 
* 화면 : VOC 요청
* 기능 : 
* 프로그램 ID :  
* 담당자 : CEJ ( 설계 : 공통 )
* 착수일 : 2014-09-29
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<% 

String st_ds_user_id = CommonUtil.nvl((String) request.getParameter("st_ds_user_id"),""); // 처리자
String st_cd_user_id = st_ds_user_id; // 접수자 
String st_ds_dept = CommonUtil.nvl((String) request.getParameter("st_ds_dept"),"");
String st_code = CommonUtil.nvl((String) request.getParameter("st_code"),"");
String st_title = CommonUtil.nvl((String) request.getParameter("st_title"),"");
String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");
String st_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");

String st_req_user_tel  = _sessionInfo.getTel(); 
String st_user_name  =  _sessionInfo.getUserNameLoc() ; 

String editFlag = "Y";
String st_text = "";
if ("ZA".equals(st_code)) {
	editFlag = "N";
	st_text = "품목정보";
} else if ("ZB".equals(st_code)) {
	editFlag = "N";
	st_text = "품목이미지";
} else {
	st_title = "Claim 요청";
}
%>

<script type="text/javascript">
function kep_onload_view() {
	//조회조건 초기화
	kepSetCalender("st_ph_date"); 
	$("#st_ph_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	$("#st_image_key").val("");
}

//기능함수
function doAction(str) {
	switch (str) {
		case "save": // 저장
			if (checkSubmit()) {
				if(confirm(" 작성하신 요청내용으로 등록하시겠습니까?   ") == true){
					kepAjaxFormCall("/main/saveBuyerVocReqCreateReg.do", "commonCoCoVocBuyerReqCreateRegPop", str);
				}
			}
		break;
	}
}

function checkSubmit() {
	if (isEmpty(kepTrimStr($("#st_ph_date").val()))) {
		alert("처리희망일을 선택하여 주십시오.");
		$("#st_ph_date").focus();
		return false;
	}
	
	if (isEmpty(kepTrimStr($("#st_buyer_item_no").val()))) {
		alert("품목코드를 입력하여 주십시오.");
		$("#st_buyer_item_no").focus();
		return false;
	}

	var regex = /^PO\d{8}$/; //PO(대문자) + 숫자 8자리
	if(!isEmpty($("#st_po_no").val())){ //발주번호 입력값이 있는 경우에만 형식 체크
		if(!regex.test($("#st_po_no").val())){
			alert("<%=CommonLang.msg("MSG580")%> ");
			$("#st_po_no").focus();
			return false;
		}
	}
	
	if (isEmpty(kepTrimStr($("#st_req_remark").val()))) {
		alert("요청내역 입력하여 주십시오.");
		$("#st_req_remark").focus();
		return false;
	} 
	
	return true;
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	var sMsg = response.msg.MSG;
	var user_name = document.forms.commonCoCoVocBuyerReqCreateRegPop.st_user_name.value;
	var process_info = sMsg.split("@@", -1);
	
	if(process_info[0]=="SUCCESS") {
		alert( user_name+ " 님이 요청하신 사항은 KeP담당자에게  "+process_info[1]+" 번으로 접수되었습니다.");
		self.close();
    }
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.");
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "fileUpload": //파일업로드
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_image_key").val()+"&TYPE=VOC", "500,430,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "fileUpload") {
		var diskOn = "/resources/images/disk_on.gif";
		var diskOff = "/resources/images/disk_off.gif";

		if(code != ''){
			document.forms.commonCoCoVocBuyerReqCreateRegPop.st_image_key.value = code;
			document.forms.commonCoCoVocBuyerReqCreateRegPop.Image2.src = diskOn;
	    }else{
			document.forms.commonCoCoVocBuyerReqCreateRegPop.st_image_key.value = "";
			document.forms.commonCoCoVocBuyerReqCreateRegPop.Image2.src = diskOff;
	    }
	}
}
</script> 
<body onload="kep_onload_view()">
<form name="commonCoCoVocBuyerReqCreateRegPop" id="commonCoCoVocBuyerReqCreateRegPop" method=post > 
	<input type="hidden" name="st_ds_user_id" id="st_ds_user_id" value="">
	<input type="hidden" name="st_ds_dept" id="st_ds_dept" value="">
	<input type="hidden" name="st_cd_user_id" id="st_cd_user_id" value="<%=st_cd_user_id%>">
	<input type="hidden" name="st_cd_dept" id="st_cd_dept" value="">
	<input type="hidden" name="st_cd_date" id="st_cd_date" value="">
	<input type="hidden" name="st_user_name"     value="<%=st_user_name%>">
	<input type="hidden" name="st_req_user_tel"  value="<%=st_req_user_tel%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:354px;">
    	<div id="popHeader">
        	<h1 class="title">
        	<%=st_title%>
        	</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
      <div id="contArea">
				<table  class="cont_t_list06"  style="width:100%">
					<caption>Claim 요청</caption>
					<colgroup>
						<col width="18%" />
						<col width="32%" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="col" ><%=CommonLang.get("HTITLE501") %> / <%=CommonLang.get("HTITLE177") %><!-- VOC 유형 / 파일첨부 --></th> 
							<td class="left" >
							<% if ("N".equals(editFlag)) {%>
								<select name="st_claim_master"  id="st_claim_master" >
									<option value="<%=st_code%>"><%=st_text%></option>
						        </select>
							<%}else{%> 
								<select name="st_claim_master"  id="st_claim_master" >
									<option value="" selected> <%=CommonLang.get("HTITLE178") %><!-- 선택 --> </option>
									<option value="ZP"><%=CommonLang.get("HTITLE502") %><!-- 가격 --></option>
									<option value="ZC"><%=CommonLang.get("HTITLE503") %><!-- 교환/반품 --></option>
									<option value="ZE"><%=CommonLang.get("HTITLE504") %><!-- 기타 --></option>
									<option value="ZL"><%=CommonLang.get("HTITLE404") %><!-- 마감 --></option>
									<option value="ZO"><%=CommonLang.get("HTITLE162") %><!-- 발주 --></option>
									<option value="ZD"><%=CommonLang.get("HTITLE505") %><!-- 배송 --></option>
									<option value="ZS"><%=CommonLang.get("HTITLE506") %><!-- 시스템 --></option>
									<option value="ZN"><%=CommonLang.get("HTITLE507") %><!-- 신규등록 --></option>
								</select>
							<%}%>
							
								&nbsp; / &nbsp;
								
								<input type="hidden" id="st_image_key" name="st_image_key" value="" />
								<a href="javascript:doPop('fileUpload');"><img src="/resources/images/disk_off.gif" id="Image2" name="Image2" border="0" style="vertical-align: text-bottom;"></a>
							</td>
										
							<th scope="col" ><%=CommonLang.get("HTITLE508") %><!-- 처리희망일 --></th>
							<td class="left">
								<input type="text" id="st_ph_date" name="st_ph_date" class="input_type_text"   maxlength="40" style="width:40%;" readonly value="" />
							</td> 	
						</tr> 
						<tr>		  
							<th scope="col" ><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></th>
							<% if ("N".equals(editFlag)) {%>
								<td class="left">
									<%=st_buyer_item_no%>
									<input type="hidden" id="st_buyer_item_no" name="st_buyer_item_no" style="width:70%;" class="input_type_text" value="<%=st_buyer_item_no%>" />
								</td>
							<%}else{%>
								<td class="left">
									<input type="text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:70%;" class="input_type_text" value="" />
								</td>
							<%} %>
							<th scope="col" ><%=CommonLang.get("HTITLE203") %><!-- 발주번호 --></th>
							<% if ("N".equals(editFlag)) {%>
								<td class="left">
									<%=st_po_no%> 
									<input type="hidden" id="st_po_no" name="st_po_no" style="width:70%;" class="input_type_text"  value="<%=st_po_no%>" />
								</td>
							<%}else{%>
								<td class="left">
									<input type="text" id="st_po_no" name="st_po_no" style="width:70%;" class="input_type_text"  value="" />
								</td>
							<%} %>  						
						</tr>  
						<tr>
							<th scope="col" ><%=CommonLang.get("HTITLE509") %><!-- 요청내역 --></th> 
							<td class="left" colspan="3" style="padding: 5px 10px">  
							     <textarea name="st_req_remark" id="st_req_remark" rows="12" style="width:100% "></textarea> 							
							</td>  			
						</tr> 						
					</tbody>
				</table> 
				<div class="btnArea mt10 mb05">
					<span class="fr">
						<span class="btn_02 mr05"><a href="javascript:doAction('save');"><%=CommonLang.get("HTITLE500") %><!-- 요청 --></a></span>
					</span>
				</div>
        </div>
        </div>        
</div>
</form> 
</body>
</html>
