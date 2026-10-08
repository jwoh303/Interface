<%--
**********************************************
* 메뉴 : 
* 화면 : 재계약관리 상세 팝업
* 기능 : 재계약관리 스텝별 등록/수정
* 프로그램 ID :
* 담당자 : HSJ ( 설계 : HMH )
* 착수일 : 2022-11-24
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

String userID = _sessionInfo.getUserId();
String sessionEmpNo = _sessionInfo.getEmpNo();
String contract_no = CommonUtil.nvl((String) request.getParameter("contract_no"), "");
String contract_status = CommonUtil.nvl((String) request.getParameter("contract_status"), "");
String completion_yn = "N";

Map<String,String> _rowData = null;

if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
	
	completion_yn = CommonUtil.nvl(_rowData.get("COMPLETION_YN"));
}
%>

<script type="text/javascript">
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var gridIndex = 0;
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	kepSetCalender("pre_meeting_date");
	kepSetCalender("sourcing_dis_date");
	kepSetCalender("sourcing_ass_date");
	kepSetCalender("in_reporting_date");
	kepSetCalender("buyer_proposal_date");
	$("#st_tobe_contract_status").val("");
}

//팝업함수호출
function doPop(str, value1) {
	popupSel = str;
	
	switch (str) {
		case "sales_user":
			popupSel = "sales_user";
			openSearchPopup("/common/kepUserSelectAllPop.do", '', "500,485,no");
			break;
			
		case "sourcing_user":
			popupSel = "sourcing_user";
			openSearchPopup("/common/kepUserSelectAllPop.do", '', "500,485,no");
			break;
			
		case "sourcing_dis":
			var in_appr_status = document.contentForm.st_in_appr_status.value;
			if((in_appr_status == "C") || (in_appr_status == "Q")){ //내부품의 결재완료, 결재중 
				alert("내부품의 진행 건은 소싱자료배포가 불가합니다.");
				return;
			}
			
			var param = encodeURI("?contract_no="+"<%=contract_no%>");
		    opener.parent.tab("카탈로그 소싱 요청(재계약)","/mdcm/showMasterMdCmCatalogRegReq.do" + param, "Y");
		    self.close();
			break;
			
		case "contract_attach":
			var type="RFQ";
			var viewType="VI";
			<% if ("Y".equals(completion_yn)) { %>
				viewType = "R";
			<%}%>
			var value = document.contentForm.st_contract_image_key.value;
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
		,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
		,value21,value22,value23,value24,value25,value26,value27,value28,value29){
	//팝업 조회후 해당 항목에 값을 셋팅
	if(popupSel == "contract_attach") {
		 $("input[name=st_contract_image_key]").eq(gridIndex).val(value1);
	 	 if(value1 ==""){
			 $("img[id=st_contract_image_key_img]").eq(gridIndex).attr("src",diskOff);
	 	 }else{
			 $("img[id=st_contract_image_key_img]").eq(gridIndex).attr("src",diskOn);
	 	 }
	}else if(popupSel == "sales_user"){ //영업메인
		$("input[name=st_sales_user_id]").eq(gridIndex).val(value1);
		$("input[name=st_sales_user_name]").eq(gridIndex).val(value2);
	}else if(popupSel == "sourcing_user"){ //소싱메인
		$("input[name=st_sourcing_user_id]").eq(gridIndex).val(value1);
		$("input[name=st_sourcing_user_name]").eq(gridIndex).val(value2);
	}else{
	}
	
	popupSel = "";
	grbRow="";	//초기화
}
 
var st;
var mt;

//기능함수
function doAction(str, flag) {
	st = new Date();
	$("#st_tobe_contract_status").val(""); // 초기화 (완료 버튼 시에만 값 들어감)
	switch (str) {
		case "save":
			// 단순 저장 시 일자 값 변환
			if (checkDate() == false) return;
			
			$("#st_pre_meeting_date").val($("#pre_meeting_date").val().replace(/[/]/gi,""));
			$("#st_sourcing_dis_date").val($("#sourcing_dis_date").val().replace(/[/]/gi,""));
			$("#st_sourcing_ass_date").val($("#sourcing_ass_date").val().replace(/[/]/gi,""));
			$("#st_in_reporting_date").val($("#in_reporting_date").val().replace(/[/]/gi,""));
			$("#st_buyer_proposal_date").val($("#buyer_proposal_date").val().replace(/[/]/gi,""));
			
			if (confirm("저장하시겠습니까?")) {
				kepAjaxFormCall("/mdct/saveMasterMdCtBuyerReContractPop.do","contentForm","SAVE");
			}
			break;
			
		case "complete":
			if (checkSubmit(flag)) {
				if (confirm("완료하시겠습니까?")) {
					kepAjaxFormCall("/mdct/saveMasterMdCtBuyerReContractPop.do","contentForm","COMPLETE");
				}
			}
			break;
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;    
	
	if (sMsg == 'OK') {
		alert("저장 완료");
		opener.setPopupReturn("CREATE","");
		self.close();
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
} 

function checkSubmit(flag) {
	if (flag == "S") { // 사전준비 완료
		if (isEmpty($("#st_par_agr_yn").val())) {
			alert("모수협의를 선택하여 주십시요.");
			$("#st_par_agr_yn").focus();
			return false;
		}
		
		if ($("#st_par_agr_yn").val() != "Y") {
			alert("모수협의가 완료되어야 합니다.");
			$("#st_par_agr_yn").focus();
			return false;
		}
		
	}else if (flag == "R") { // 소싱 완료
		if ($("#st_sourcing_dis_yn").val() != "Y") {
			alert("소싱 자료 배포가 완료되어야 합니다.");
			return false;
		}
		
		if ($("#st_sourcing_subm_yn").val() != "Y") {
			alert("소싱 자료 제출이 완료되어야 합니다.");
			return false;
		}

		if (isEmpty($("#st_in_appr_id").val())) {
			alert("소싱 내부품의를 진행하여 주십시요.");
			return false;
		}

		if ($("#st_in_appr_status").val() != "C") {
			alert("소싱 내부품의가 결재완료되어야 합니다.");
			return false;
		}

		if (isEmpty($("#st_buyer_proposal_yn").val())) {
			alert("고객사 제안을 선택하여 주십시요.");
			$("#st_buyer_proposal_yn").focus();
			return false;
		}
	
		if ($("#st_buyer_proposal_yn").val() != "Y") {
			alert("고객사 제안이 완료되어야 합니다.");
			$("#st_buyer_proposal_yn").focus();
			return false;
		}
	}else if (flag == "C") { // 제안결과
		if (isEmpty($("#st_order_result").val())) {
			alert("수주결과를 선택하여 주십시요.");
			$("#st_order_result").focus();
			return false;
		}

		if (isEmpty($("#st_order_in_appr_id").val())) {
			alert("제안결과 내부품의를 진행하여 주십시요.");
			return false;
		}
		
		if ($("#st_order_in_appr_status").val() != "C") {
			alert("제안결과 내부품의가 결재완료되어야 합니다.");
			return false;
		}
		
	}else if (flag == "Y") { // 체결
		if (isEmpty($("#st_contract_image_key").val())) {
			alert("계약체결 첨부를 진행하여 주십시요.");
			return false;
		}
	
		if ($("#st_re_contract_system_yn").val() != "Y") {
			alert("시스템 반영이 완료되어야 합니다.");
			return false;
		}
	}
	
	if (isEmpty($("#st_sales_user_id").val())) {
		alert("영업메인을 입력하여 주십시요.");
		$("#st_sales_user_name").focus();
		return false;
	}
	
	if (isEmpty($("#st_sourcing_user_id").val())) {
		alert("소싱메인을 입력하여 주십시요.");
		$("#st_sourcing_user_name").focus();
		return false;
	}
	
	if (isEmpty($("#pre_meeting_date").val())) {
		alert("사전미팅 계획 일정을 선택하여 주십시요.");
		$("#pre_meeting_date").focus();
		return false;
	}
	
	if (isEmpty($("#sourcing_dis_date").val())) {
		alert("소싱자료 배포 계획 일정을 선택하여 주십시요.");
		$("#sourcing_dis_date").focus();
		return false;
	}
	
	if (isEmpty($("#sourcing_ass_date").val())) {
		alert("소싱자료 취합 계획 일정을 선택하여 주십시요.");
		$("#sourcing_ass_date").focus();
		return false;
	}
	
	if (isEmpty($("#in_reporting_date").val())) {
		alert("내부 보고 계획 일정을 선택하여 주십시요.");
		$("#in_reporting_date").focus();
		return false;
	}
	
	if (isEmpty($("#buyer_proposal_date").val())) {
		alert("고객사 제안 계획 일정을 선택하여 주십시요.");
		$("#buyer_proposal_date").focus();
		return false;
	}
	
	var pre_meeting_date = $("#pre_meeting_date").val().replace(/[/]/gi,"");
	var sourcing_dis_date = $("#sourcing_dis_date").val().replace(/[/]/gi,"");
	var sourcing_ass_date = $("#sourcing_ass_date").val().replace(/[/]/gi,"");
	var in_reporting_date = $("#in_reporting_date").val().replace(/[/]/gi,"");
	var buyer_proposal_date = $("#buyer_proposal_date").val().replace(/[/]/gi,"");
	
	if ((pre_meeting_date > sourcing_dis_date) && sourcing_dis_date != "") {
		alert("사전미팅 일정이 소싱자료 배포 일정보다 전이어야 합니다");
		$("#pre_meeting_date").focus();
		return false;
	}else if ((sourcing_dis_date > sourcing_ass_date) && sourcing_ass_date != "") {
		alert("소싱자료 배포 일정이 소싱자료 취합 일정보다 전이어야 합니다");
		$("#sourcing_dis_date").focus();
		return false;
	}else if ((sourcing_ass_date > in_reporting_date) && in_reporting_date != "") {
		alert("소싱자료 취합 일정이 내부 보고 일정보다 전이어야 합니다");
		$("#sourcing_ass_date").focus();
		return false;
	}else if ((in_reporting_date > buyer_proposal_date) && buyer_proposal_date != "") {
		alert("내부 보고 일정이 고객사 제안 일정보다 전이어야 합니다");
		$("#in_reporting_date").focus();
		return false;
	}
	
	$("#st_tobe_contract_status").val(flag);
	$("#st_pre_meeting_date").val($("#pre_meeting_date").val().replace(/[/]/gi,""));
	$("#st_sourcing_dis_date").val($("#sourcing_dis_date").val().replace(/[/]/gi,""));
	$("#st_sourcing_ass_date").val($("#sourcing_ass_date").val().replace(/[/]/gi,""));
	$("#st_in_reporting_date").val($("#in_reporting_date").val().replace(/[/]/gi,""));
	$("#st_buyer_proposal_date").val($("#buyer_proposal_date").val().replace(/[/]/gi,""));
	
	return true;
}

function gw_aprv(str, docId, status){
	if(str == "in_appr"){ // 소싱 내부품의
		if($("#st_sourcing_dis_yn").val() != "Y") {
			alert("소싱 자료 배포가 완료되어야 합니다.");
			return;
		}
		
		if($("#st_sourcing_subm_yn").val() != "Y") {
			alert("소싱 자료 제출이 완료되어야 합니다.");
			return;
		}
	}else{ // 제안결과 내부품의
		if (isEmpty($("#st_order_result").val())) {
			alert("수주결과를 선택하여 주십시요.");
			$("#st_order_result").focus();
			return;
		}
	}
	
	if((status == "") || (status == "B")){
		var gw_doc_type = "";
		var gw_doc_name = "";
		
		if(str == "in_appr"){
			gw_doc_type = "B05";
			gw_doc_name = "[koreab2b] 재계약 소싱 내부품의";
		}else if(str == "order_appr"){
			gw_doc_type = "B06";
			gw_doc_name = "[koreab2b] 재계약 제안결과 내부품의";
		}
		
		var form = document.createElement("form");
		form.setAttribute("method", "post");
		form.setAttribute("target", "_blank");
		form.setAttribute("action", "https://gw.koreab2b.com/jsp/kep_linkage/InQdbData.jsp");

		var hiddenField01 = document.createElement("input");
		hiddenField01.setAttribute("type", "hidden");
		hiddenField01.setAttribute("name", "DrafterCode");
		hiddenField01.setAttribute("value", "<%=sessionEmpNo%>");	
		form.appendChild(hiddenField01);
		
		var hiddenField02 = document.createElement("input");
		hiddenField02.setAttribute("type", "hidden");
		hiddenField02.setAttribute("name", "FormID");
		hiddenField02.setAttribute("value", "JHOKR223330173873000,LINK001");
		form.appendChild(hiddenField02);
		
		var hiddenField03 = document.createElement("input");
		hiddenField03.setAttribute("type", "hidden");
		hiddenField03.setAttribute("name", "LinkageKey");
		hiddenField03.setAttribute("value", gw_doc_type);
		form.appendChild(hiddenField03);
		
		var hiddenField04 = document.createElement("input");
		hiddenField04.setAttribute("type", "hidden");
		hiddenField04.setAttribute("name", "LinkageSub1");
		hiddenField04.setAttribute("value", "<%=contract_no%>");
		form.appendChild(hiddenField04);
		
		var LinkageSub2 = document.createElement("input");
		LinkageSub2.setAttribute("type", "hidden");
		LinkageSub2.setAttribute("name", "LinkageSub2");
		LinkageSub2.setAttribute("value", "");
		form.appendChild(LinkageSub2);
		
		var LinkageSub3 = document.createElement("input");
		LinkageSub3.setAttribute("type", "hidden");
		LinkageSub3.setAttribute("name", "LinkageSub3");
		LinkageSub3.setAttribute("value", "");
		form.appendChild(LinkageSub3);
		
		var LinkageSub4 = document.createElement("input");
		LinkageSub4.setAttribute("type", "hidden");
		LinkageSub4.setAttribute("name", "LinkageSub4");
		LinkageSub4.setAttribute("value", "");
		form.appendChild(LinkageSub4);
		
		var LinkageSub5 = document.createElement("input");
		LinkageSub5.setAttribute("type", "hidden");
		LinkageSub5.setAttribute("name", "LinkageSub5");
		LinkageSub5.setAttribute("value", "");
		form.appendChild(LinkageSub5);			
		
		var hiddenField05 = document.createElement("input");
		hiddenField05.setAttribute("type", "hidden");
		hiddenField05.setAttribute("name", "SancTitle");
		hiddenField05.setAttribute("value", gw_doc_name);
		form.appendChild(hiddenField05);
		
		var SacnBodyType = document.createElement("input");
		SacnBodyType.setAttribute("type", "hidden");
		SacnBodyType.setAttribute("name", "SacnBodyType");
		SacnBodyType.setAttribute("value", "TEXT");
		form.appendChild(SacnBodyType);	
		
		var hiddenField06 = document.createElement("input");
		hiddenField06.setAttribute("type", "hidden");
		hiddenField06.setAttribute("name", "SancBody");
		hiddenField06.setAttribute("value", "");
		form.appendChild(hiddenField06);
		
		var AttachYN = document.createElement("input");
		AttachYN.setAttribute("type", "hidden");
		AttachYN.setAttribute("name", "AttachYN");
		AttachYN.setAttribute("value", "N");
		form.appendChild(AttachYN);
		
		var AttachInfo = document.createElement("input");
		AttachInfo.setAttribute("type", "hidden");
		AttachInfo.setAttribute("name", "AttachInfo");
		AttachInfo.setAttribute("value", "");
		form.appendChild(AttachInfo);
		
		document.charset="UTF-8";
		document.body.appendChild(form);
		form.submit();
		
		// 그룹웨어 전송 후 캐릭터 셋 복원
		document.charset="utf-8";	
	}else{
	}
}

function checkDate(){
	var pre_meeting_date = $("#pre_meeting_date").val().replace(/[/]/gi,"");
	var sourcing_dis_date = $("#sourcing_dis_date").val().replace(/[/]/gi,"");
	var sourcing_ass_date = $("#sourcing_ass_date").val().replace(/[/]/gi,"");
	var in_reporting_date = $("#in_reporting_date").val().replace(/[/]/gi,"");
	var buyer_proposal_date = $("#buyer_proposal_date").val().replace(/[/]/gi,"");
	
	if ((pre_meeting_date > sourcing_dis_date) && sourcing_dis_date != "") {
		alert("사전미팅 일정이 소싱자료 배포 일정보다 전이어야 합니다");
		$("#pre_meeting_date").focus();
		return false;
	}else if ((sourcing_dis_date > sourcing_ass_date) && sourcing_ass_date != "") {
		alert("소싱자료 배포 일정이 소싱자료 취합 일정보다 전이어야 합니다");
		$("#sourcing_dis_date").focus();
		return false;
	}else if ((sourcing_ass_date > in_reporting_date) && in_reporting_date != "") {
		alert("소싱자료 취합 일정이 내부 보고 일정보다 전이어야 합니다");
		$("#sourcing_ass_date").focus();
		return false;
	}else if ((in_reporting_date > buyer_proposal_date) && buyer_proposal_date != "") {
		alert("내부 보고 일정이 고객사 제안 일정보다 전이어야 합니다");
		$("#in_reporting_date").focus();
		return false;
	}else {
	}
}
</script> 
<body onload="kep_onload_view();">

<form name="searchForm" id="searchForm" method=post>
<input type="hidden" id="st_user_id" name="st_user_id" value="<%=userID%>"/>
<input type="hidden" id="pageflag" name="pageflag" value="1"/>
</form>

<form name="contentForm" id="contentForm" method=post>
<input type="hidden" id="st_user_id" name="st_user_id" value="<%=userID%>"/>
<input type="hidden" id="st_contract_status" name="st_contract_status" value="<%=contract_status%>"/>
<input type="hidden" id="st_tobe_contract_status" name="st_tobe_contract_status" value=""/>
<input type="hidden" id="st_contract_no" name="st_contract_no" value="<%=contract_no%>"/>
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:500px;">
		<div id="popHeader">
			<h1 class="title">재계약관리 상세</h1>
		</div>
        
        <!--팝업내용입니다-->
		<div id="popContainer">
			<div style="height:420px;">
				<p style="font-weight:bold;">[사전준비]</P>
				<table class="cont_t_list06" style="width:100%;">
					<caption>재계약관리 상세</caption>
					<colgroup>
						<col width="25%" />
						<col width="25%" />
	                    <col width="25%" />
	                    <col width="25%" />
					</colgroup>

					<tbody>
<% if ("A".equals(contract_status)) { %> <!-- 사전준비 -->
						<tr>
							<th class="star" scope="row">모수협의</th>
	                        <td colspan="3">
	                        	<select id="st_par_agr_yn" name="st_par_agr_yn" style="width:100px;">
	                        		<option value="">선택</option>
									<option value="Y" <% if (CommonUtil.nvl(_rowData.get("PAR_AGR_YN")).equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N" <% if (CommonUtil.nvl(_rowData.get("PAR_AGR_YN")).equals("N")) { %> selected <%} %>>N</option>
								</select>
	                        </td>
						</tr>
						
						<tr>
	                        <th scope="row" class="star">영업메인</th>
	                      	<td>
	                      		<input type="hidden" id="st_sales_user_id" name="st_sales_user_id" class="input_type_text" title="" style="width:60px;" value="<%=CommonUtil.nvl(_rowData.get("SALES_USER_ID"))%>"/>
	                      		<input type="text" id="st_sales_user_name" name="st_sales_user_name" class="input_type_text" title="" style="width:60px;" readOnly value="<%=CommonUtil.nvl(_rowData.get("SALES_USER_NAME"))%>"/>
	                      		<a href="javascript:doPop('sales_user');"><img src="/resources/images/btn_search03.gif"></a>
	                      	</td>
	                        <th scope="row" class="star">소싱메인</th>
	                      	<td>
	                      		<input type="hidden" id="st_sourcing_user_id" name="st_sourcing_user_id" class="input_type_text" title="" style="width:60px;" value="<%=CommonUtil.nvl(_rowData.get("SOURCING_USER_ID"))%>" />
	                      		<input type="text" id="st_sourcing_user_name" name="st_sourcing_user_name" class="input_type_text" title="" style="width:60px;" readOnly value="<%=CommonUtil.nvl(_rowData.get("SOURCING_USER_NAME"))%>"/>
	                      		<a href="javascript:doPop('sourcing_user');"><img src="/resources/images/btn_search03.gif"></a>
	                      	</td>
	                    </tr>
					</tbody>
				</table>
			
				<p style="font-weight:bold;">[계획 일정]</P>
				<table class="cont_t_list06" style="width:100%;">
					<colgroup>
						<col width="25%" />
						<col width="25%" />
	                    <col width="25%" />
	                    <col width="25%" />
					</colgroup>

					<tbody>	
	                    <tr>
	                        <th scope="row" class="star">사전미팅</th>
	                        <td colspan="3">
	                      		<input type="text" id="pre_meeting_date" name="pre_meeting_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("PRE_MEETING_DATE"))%>"/>
	                      		<input type="hidden" id="st_pre_meeting_date" name="st_pre_meeting_date"  value="<%=CommonUtil.nvl(_rowData.get("PRE_MEETING_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">소싱자료 배포</th>
	                        <td colspan="3">
	                      		<input type="text" id="sourcing_dis_date" name="sourcing_dis_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("SOURCING_DIS_DATE"))%>"/>
	                      		<input type="hidden" id="st_sourcing_dis_date" name="st_sourcing_dis_date"  value="<%=CommonUtil.nvl(_rowData.get("SOURCING_DIS_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">소싱자료 취합</th>
	                        <td colspan="3">
	                      		<input type="text" id="sourcing_ass_date" name="sourcing_ass_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("SOURCING_ASS_DATE"))%>"/>
	                      		<input type="hidden" id="st_sourcing_ass_date" name="st_sourcing_ass_date"  value="<%=CommonUtil.nvl(_rowData.get("SOURCING_ASS_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">내부 보고</th>
	                        <td colspan="3">
	                      		<input type="text" id="in_reporting_date" name="in_reporting_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("IN_REPORTING_DATE"))%>"/>
	                      		<input type="hidden" id="st_in_reporting_date" name="st_in_reporting_date"  value="<%=CommonUtil.nvl(_rowData.get("IN_REPORTING_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">고객사 제안</th>
	                        <td colspan="3">
	                      		<input type="text" id="buyer_proposal_date" name="buyer_proposal_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("BUYER_PROPOSAL_DATE"))%>"/>
	                      		<input type="hidden" id="st_buyer_proposal_date" name="st_buyer_proposal_date"  value="<%=CommonUtil.nvl(_rowData.get("BUYER_PROPOSAL_DATE"))%>" />
	                      	</td>
	                    </tr>
					</tbody>
				</table>
				
<% } else if ("S".equals(contract_status)) { %> <!-- 소싱 -->
						<tr>
							<th class="star" scope="row">모수협의</th>
	                        <td colspan="3">
	                        	<input type="hidden" name="st_par_agr_yn" id="st_par_agr_yn" value="<%=CommonUtil.nvl(_rowData.get("PAR_AGR_YN"))%>">
	                        	<%=CommonUtil.nvl(_rowData.get("PAR_AGR_YN")) %>
	                        </td>
						</tr>
						
						<tr>
	                        <th scope="row" class="star">영업메인</th>
	                      	<td>
	                      		<input type="hidden" id="st_sales_user_id" name="st_sales_user_id" class="input_type_text" title="" style="width:60px;" value="<%=CommonUtil.nvl(_rowData.get("SALES_USER_ID"))%>"/>
	                      		<input type="text" id="st_sales_user_name" name="st_sales_user_name" class="input_type_text" title="" style="width:60px;" readOnly value="<%=CommonUtil.nvl(_rowData.get("SALES_USER_NAME"))%>"/>
	                      		<a href="javascript:doPop('sales_user');"><img src="/resources/images/btn_search03.gif"></a>
	                      	</td>
	                        <th scope="row" class="star">소싱메인</th>
	                      	<td>
	                      		<input type="hidden" id="st_sourcing_user_id" name="st_sourcing_user_id" class="input_type_text" title="" style="width:60px;" value="<%=CommonUtil.nvl(_rowData.get("SOURCING_USER_ID"))%>" />
	                      		<input type="text" id="st_sourcing_user_name" name="st_sourcing_user_name" class="input_type_text" title="" style="width:60px;" readOnly value="<%=CommonUtil.nvl(_rowData.get("SOURCING_USER_NAME"))%>"/>
	                      		<a href="javascript:doPop('sourcing_user');"><img src="/resources/images/btn_search03.gif"></a>
	                      	</td>
	                    </tr>
					</tbody>
				</table>
			
				<p style="font-weight:bold;">[계획 일정]</P>
				<table class="cont_t_list06" style="width:100%;">
					<colgroup>
						<col width="25%" />
						<col width="25%" />
	                    <col width="25%" />
	                    <col width="25%" />
					</colgroup>

					<tbody>	
	                    <tr>
	                        <th scope="row" class="star">사전미팅</th>
	                        <td colspan="3">
	                      		<input type="text" id="pre_meeting_date" name="pre_meeting_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("PRE_MEETING_DATE"))%>"/>
	                      		<input type="hidden" id="st_pre_meeting_date" name="st_pre_meeting_date"  value="<%=CommonUtil.nvl(_rowData.get("PRE_MEETING_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">소싱자료 배포</th>
	                        <td colspan="3">
	                      		<input type="text" id="sourcing_dis_date" name="sourcing_dis_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("SOURCING_DIS_DATE"))%>"/>
	                      		<input type="hidden" id="st_sourcing_dis_date" name="st_sourcing_dis_date"  value="<%=CommonUtil.nvl(_rowData.get("SOURCING_DIS_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">소싱자료 취합</th>
	                        <td colspan="3">
	                      		<input type="text" id="sourcing_ass_date" name="sourcing_ass_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("SOURCING_ASS_DATE"))%>"/>
	                      		<input type="hidden" id="st_sourcing_ass_date" name="st_sourcing_ass_date"  value="<%=CommonUtil.nvl(_rowData.get("SOURCING_ASS_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">내부 보고</th>
	                        <td colspan="3">
	                      		<input type="text" id="in_reporting_date" name="in_reporting_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("IN_REPORTING_DATE"))%>"/>
	                      		<input type="hidden" id="st_in_reporting_date" name="st_in_reporting_date"  value="<%=CommonUtil.nvl(_rowData.get("IN_REPORTING_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">고객사 제안</th>
	                        <td colspan="3">
	                      		<input type="text" id="buyer_proposal_date" name="buyer_proposal_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("BUYER_PROPOSAL_DATE"))%>"/>
	                      		<input type="hidden" id="st_buyer_proposal_date" name="st_buyer_proposal_date"  value="<%=CommonUtil.nvl(_rowData.get("BUYER_PROPOSAL_DATE"))%>" />
	                      	</td>
	                    </tr>
					</tbody>
				</table>
				
				<p style="font-weight:bold;">[소싱]</P>
				<table class="cont_t_list06" style="width:100%;">
					<colgroup>
						<col width="25%" />
						<col width="25%" />
	                    <col width="25%" />
	                    <col width="25%" />
					</colgroup>

					<tbody>
	                    <tr>
	                        <th scope="row">소싱 자료 배포</th>
	                      	<td>
	                      		<input type="hidden" name="st_sourcing_dis_yn" id="st_sourcing_dis_yn" value="<%=CommonUtil.nvl(_rowData.get("SOURCING_DIS_YN"))%>">
	                      		<a href="javascript:doPop('sourcing_dis')">
	                      			<div class="btn_gray_03">자료배포</div>
	                      		</a>
	                      		/ <%=CommonUtil.nvl(_rowData.get("SOURCING_DIS_YN"))%>
	                      	</td>
	                      	
	                      	<th scope="row">소싱 자료 제출</th>
	                      	<td>
	                      		<input type="hidden" name="st_sourcing_subm_yn" id="st_sourcing_subm_yn" value="<%=CommonUtil.nvl(_rowData.get("SOURCING_SUBM_YN"))%>">
	                      		<%=CommonUtil.nvl(_rowData.get("SOURCING_SUBM_YN"))%>
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row">내부품의</th>
	                        <td>
	                        	<input type="hidden" name="st_in_appr_id" id="st_in_appr_id" value="<%=CommonUtil.nvl(_rowData.get("IN_APPR_ID"))%>">
	                        	<input type="hidden" name="st_in_appr_status" id="st_in_appr_status" value="<%=CommonUtil.nvl(_rowData.get("IN_APPR_STATUS"))%>">
	                        	
                        	<%if(("").equals(CommonUtil.nvl(_rowData.get("IN_APPR_STATUS")))){%>
                        		<a href="javascript:gw_aprv('in_appr', '<%=CommonUtil.nvl(_rowData.get("IN_APPR_ID"))%>', '<%=CommonUtil.nvl(_rowData.get("IN_APPR_STATUS"))%>')">
	                        		<div class="btn_gray_03">결재상신</div>
	                        	</a>
                        	<%}else if(("B").equals(CommonUtil.nvl(_rowData.get("IN_APPR_STATUS")))){%>
                        		<a href="javascript:gw_aprv('in_appr', '<%=CommonUtil.nvl(_rowData.get("IN_APPR_ID"))%>', '<%=CommonUtil.nvl(_rowData.get("IN_APPR_STATUS"))%>')">
                        			<div class="btn_gray_03">결재상신</div>
                        		</a>
                        			/ <%=CommonUtil.nvl(_rowData.get("IN_APPR_STATUS_TEXT"))%>
                        	<%}else{%>
                        		<a href="https://gw.koreab2b.com/qdb-linkage/DocViewer.do?docid=<%=CommonUtil.nvl(_rowData.get("IN_APPR_ID"))%>" target="_blank">
	                        		<div class="btn_gray_03">결재문서</div>
	                        	</a>
	                        		/ <%=CommonUtil.nvl(_rowData.get("IN_APPR_STATUS_TEXT"))%>
                        	<%}%>
	                        	
	                      	</td>

	                      	<th scope="row">고객사 제안</th>
	                      	<td>
	                      		<select id="st_buyer_proposal_yn" name="st_buyer_proposal_yn" style="width:100px;">
	                        		<option value="">선택</option>
									<option value="Y" <% if (CommonUtil.nvl(_rowData.get("BUYER_PROPOSAL_YN")).equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N" <% if (CommonUtil.nvl(_rowData.get("BUYER_PROPOSAL_YN")).equals("N")) { %> selected <%} %>>N</option>
								</select>
	                      	</td>
	                    </tr>
					</tbody>
				</table>
				
<% } else if ("R".equals(contract_status)) { %> <!-- 제안결과 -->
						<tr>
							<th class="star" scope="row">모수협의</th>
	                        <td colspan="3">
	                        	<input type="hidden" name="st_par_agr_yn" id="st_par_agr_yn" value="<%=CommonUtil.nvl(_rowData.get("PAR_AGR_YN"))%>">
	                        	<%=CommonUtil.nvl(_rowData.get("PAR_AGR_YN"))%>
	                        </td>
						</tr>
						
						<tr>
	                        <th scope="row" class="star">영업메인</th>
	                      	<td>
	                      		<input type="hidden" id="st_sales_user_id" name="st_sales_user_id" class="input_type_text" title="" style="width:60px;" value="<%=CommonUtil.nvl(_rowData.get("SALES_USER_ID"))%>"/>
	                      		<input type="text" id="st_sales_user_name" name="st_sales_user_name" class="input_type_text" title="" style="width:60px;" readOnly value="<%=CommonUtil.nvl(_rowData.get("SALES_USER_NAME"))%>"/>
	                      		<a href="javascript:doPop('sales_user');"><img src="/resources/images/btn_search03.gif"></a>
	                      	</td>
	                        <th scope="row" class="star">소싱메인</th>
	                      	<td>
	                      		<input type="hidden" id="st_sourcing_user_id" name="st_sourcing_user_id" class="input_type_text" title="" style="width:60px;" value="<%=CommonUtil.nvl(_rowData.get("SOURCING_USER_ID"))%>" />
	                      		<input type="text" id="st_sourcing_user_name" name="st_sourcing_user_name" class="input_type_text" title="" style="width:60px;" readOnly value="<%=CommonUtil.nvl(_rowData.get("SOURCING_USER_NAME"))%>"/>
	                      		<a href="javascript:doPop('sourcing_user');"><img src="/resources/images/btn_search03.gif"></a>
	                      	</td>
	                    </tr>
					</tbody>
				</table>
			
				<p style="font-weight:bold;">[계획 일정]</P>
				<table class="cont_t_list06" style="width:100%;">
					<colgroup>
						<col width="25%" />
						<col width="25%" />
	                    <col width="25%" />
	                    <col width="25%" />
					</colgroup>

					<tbody>	
	                    <tr>
	                        <th scope="row" class="star">사전미팅</th>
	                        <td colspan="3">
	                      		<input type="text" id="pre_meeting_date" name="pre_meeting_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("PRE_MEETING_DATE"))%>"/>
	                      		<input type="hidden" id="st_pre_meeting_date" name="st_pre_meeting_date"  value="<%=CommonUtil.nvl(_rowData.get("PRE_MEETING_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">소싱자료 배포</th>
	                        <td colspan="3">
	                      		<input type="text" id="sourcing_dis_date" name="sourcing_dis_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("SOURCING_DIS_DATE"))%>"/>
	                      		<input type="hidden" id="st_sourcing_dis_date" name="st_sourcing_dis_date"  value="<%=CommonUtil.nvl(_rowData.get("SOURCING_DIS_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">소싱자료 취합</th>
	                        <td colspan="3">
	                      		<input type="text" id="sourcing_ass_date" name="sourcing_ass_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("SOURCING_ASS_DATE"))%>"/>
	                      		<input type="hidden" id="st_sourcing_ass_date" name="st_sourcing_ass_date"  value="<%=CommonUtil.nvl(_rowData.get("SOURCING_ASS_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">내부 보고</th>
	                        <td colspan="3">
	                      		<input type="text" id="in_reporting_date" name="in_reporting_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("IN_REPORTING_DATE"))%>"/>
	                      		<input type="hidden" id="st_in_reporting_date" name="st_in_reporting_date"  value="<%=CommonUtil.nvl(_rowData.get("IN_REPORTING_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">고객사 제안</th>
	                        <td colspan="3">
	                      		<input type="text" id="buyer_proposal_date" name="buyer_proposal_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("BUYER_PROPOSAL_DATE"))%>"/>
	                      		<input type="hidden" id="st_buyer_proposal_date" name="st_buyer_proposal_date"  value="<%=CommonUtil.nvl(_rowData.get("BUYER_PROPOSAL_DATE"))%>" />
	                      	</td>
	                    </tr>
					</tbody>
				</table>
				
				<p style="font-weight:bold;">[소싱]</P>
				<table class="cont_t_list06" style="width:100%;">
					<colgroup>
						<col width="25%" />
						<col width="25%" />
	                    <col width="25%" />
	                    <col width="25%" />
					</colgroup>

					<tbody>
	                    <tr>
	                        <th scope="row">소싱 자료 배포</th>
	                      	<td>
	                      		<input type="hidden" name="st_sourcing_dis_yn" id="st_sourcing_dis_yn" value="<%=CommonUtil.nvl(_rowData.get("SOURCING_DIS_YN"))%>">
                      			<%=CommonUtil.nvl(_rowData.get("SOURCING_DIS_YN"))%>
	                      	</td>
	                      	
	                      	<th scope="row">소싱 자료 제출</th>
	                      	<td>
	                      		<input type="hidden" name="st_sourcing_subm_yn" id="st_sourcing_subm_yn" value="<%=CommonUtil.nvl(_rowData.get("SOURCING_SUBM_YN"))%>">
                      			<%=CommonUtil.nvl(_rowData.get("SOURCING_SUBM_YN"))%>
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row">내부품의</th>
	                        <td>
	                        	<input type="hidden" name="st_in_appr_id" id="st_in_appr_id" value="<%=CommonUtil.nvl(_rowData.get("IN_APPR_ID"))%>">
	                        	<input type="hidden" name="st_in_appr_status" id="st_in_appr_status" value="<%=CommonUtil.nvl(_rowData.get("IN_APPR_STATUS"))%>">
	                        	
                        	<%if(("").equals(CommonUtil.nvl(_rowData.get("IN_APPR_STATUS")))){%>
                        		<a href="javascript:gw_aprv('in_appr', '<%=CommonUtil.nvl(_rowData.get("IN_APPR_ID"))%>', '<%=CommonUtil.nvl(_rowData.get("IN_APPR_STATUS"))%>')">
	                        		<div class="btn_gray_03">결재상신</div>
	                        	</a>
                        	<%}else if(("B").equals(CommonUtil.nvl(_rowData.get("IN_APPR_STATUS")))){%>
                        		<a href="javascript:gw_aprv('in_appr', '<%=CommonUtil.nvl(_rowData.get("IN_APPR_ID"))%>', '<%=CommonUtil.nvl(_rowData.get("IN_APPR_STATUS"))%>')">
                        			<div class="btn_gray_03">결재상신</div>
                        		</a>
                        			/ <%=CommonUtil.nvl(_rowData.get("IN_APPR_STATUS_TEXT"))%>
                        	<%}else{%>
                        		<a href="https://gw.koreab2b.com/qdb-linkage/DocViewer.do?docid=<%=CommonUtil.nvl(_rowData.get("IN_APPR_ID"))%>" target="_blank">
	                        		<div class="btn_gray_03">결재문서</div>
	                        	</a>
	                        		/ <%=CommonUtil.nvl(_rowData.get("IN_APPR_STATUS_TEXT"))%>
                        	<%}%>
	                      	</td>

	                      	<th scope="row">고객사 제안</th>
	                      	<td>
	                      		<input type="hidden" name="st_buyer_proposal_yn" id="st_buyer_proposal_yn" value="<%=CommonUtil.nvl(_rowData.get("BUYER_PROPOSAL_YN"))%>">
	                      		<%=CommonUtil.nvl(_rowData.get("BUYER_PROPOSAL_YN"))%>
	                      	</td>
	                    </tr>
					</tbody>
				</table>
				
				<p style="font-weight:bold;">[제안결과]</P>
				<table class="cont_t_list06" style="width:100%;">
					<colgroup>
						<col width="25%" />
						<col width="25%" />
	                    <col width="25%" />
	                    <col width="25%" />
					</colgroup>

					<tbody>
	                    <tr>
	                        <th scope="row">수주결과</th>
	                      	<td>
	                      	<% if ("N".equals(completion_yn)) { %>
	                      		<%if(("").equals(CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_STATUS"))) || ("B").equals(CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_STATUS")))){%>
								<select id="st_order_result" name="st_order_result" style="width:40%;">
									<script>kepAjaxCommonComboDataValue('st_order_result', 'CTRS', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ORDER_RESULT"))%>');</script>
								</select>
								<%}else{%>
								<input type="hidden" name="st_order_result" id="st_order_result" value="<%=CommonUtil.nvl(_rowData.get("ORDER_RESULT"))%>">
	                      		<%=CommonUtil.nvl(_rowData.get("ORDER_RESULT_TEXT"))%>
								<%}%>
							<%}else{%>
								<input type="hidden" name="st_order_result" id="st_order_result" value="<%=CommonUtil.nvl(_rowData.get("ORDER_RESULT"))%>">
	                      		<%=CommonUtil.nvl(_rowData.get("ORDER_RESULT_TEXT"))%>
							<%}%>
                      		</td>
                      		
	                        <th scope="row">내부품의</th>
	                        <td>
	                        	<input type="hidden" name="st_order_in_appr_id" id="st_order_in_appr_id" value="<%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_ID"))%>">
	                        	<input type="hidden" name="st_order_in_appr_status" id="st_order_in_appr_status" value="<%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_STATUS"))%>">
	                        	
                        	<%if(("").equals(CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_STATUS")))){%>
                        		<a href="javascript:gw_aprv('order_appr', '<%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_ID"))%>', '<%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_STATUS"))%>')">
	                        		<div class="btn_gray_03">결재상신</div>
	                        	</a>
                        	<%}else if(("B").equals(CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_STATUS")))){%>
                        		<a href="javascript:gw_aprv('order_appr', '<%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_ID"))%>', '<%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_STATUS"))%>')">
                        			<div class="btn_gray_03">결재상신</div>
                        		</a>
                        			/ <%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_STATUS_TEXT"))%>
                        	<%}else{%>
                        		<a href="https://gw.koreab2b.com/qdb-linkage/DocViewer.do?docid=<%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_ID"))%>" target="_blank">
	                        		<div class="btn_gray_03">결재문서</div>
	                        	</a>
	                        		/ <%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_STATUS_TEXT"))%>
                        	<%}%>
	                      	</td>
	                    </tr>
					</tbody>
				</table>
<% } else if ("C".equals(contract_status)) { %> <!-- 계약체결 -->
						<tr>
							<th class="star" scope="row">모수협의</th>
	                        <td colspan="3">
	                        	<input type="hidden" name="st_par_agr_yn" id="st_par_agr_yn" value="<%=CommonUtil.nvl(_rowData.get("PAR_AGR_YN"))%>">
	                        	<%=CommonUtil.nvl(_rowData.get("PAR_AGR_YN")) %>
	                        </td>
						</tr>
						
						<tr>
	                        <th scope="row" class="star">영업메인</th>
	                      	<td>
	                      		<input type="hidden" id="st_sales_user_id" name="st_sales_user_id" class="input_type_text" title="" style="width:60px;" value="<%=CommonUtil.nvl(_rowData.get("SALES_USER_ID"))%>"/>
	                      		<input type="text" id="st_sales_user_name" name="st_sales_user_name" class="input_type_text" title="" style="width:60px;" readOnly value="<%=CommonUtil.nvl(_rowData.get("SALES_USER_NAME"))%>"/>
	                      		<a href="javascript:doPop('sales_user');"><img src="/resources/images/btn_search03.gif"></a>
	                      	</td>
	                        <th scope="row" class="star">소싱메인</th>
	                      	<td>
	                      		<input type="hidden" id="st_sourcing_user_id" name="st_sourcing_user_id" class="input_type_text" title="" style="width:60px;" value="<%=CommonUtil.nvl(_rowData.get("SOURCING_USER_ID"))%>" />
	                      		<input type="text" id="st_sourcing_user_name" name="st_sourcing_user_name" class="input_type_text" title="" style="width:60px;" readOnly value="<%=CommonUtil.nvl(_rowData.get("SOURCING_USER_NAME"))%>"/>
	                      		<a href="javascript:doPop('sourcing_user');"><img src="/resources/images/btn_search03.gif"></a>
	                      	</td>
	                    </tr>
					</tbody>
				</table>
			
				<p style="font-weight:bold;">[계획 일정]</P>
				<table class="cont_t_list06" style="width:100%;">
					<colgroup>
						<col width="25%" />
						<col width="25%" />
	                    <col width="25%" />
	                    <col width="25%" />
					</colgroup>

					<tbody>	
	                    <tr>
	                        <th scope="row" class="star">사전미팅</th>
	                        <td colspan="3">
	                      		<input type="text" id="pre_meeting_date" name="pre_meeting_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("PRE_MEETING_DATE"))%>"/>
	                      		<input type="hidden" id="st_pre_meeting_date" name="st_pre_meeting_date"  value="<%=CommonUtil.nvl(_rowData.get("PRE_MEETING_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">소싱자료 배포</th>
	                        <td colspan="3">
	                      		<input type="text" id="sourcing_dis_date" name="sourcing_dis_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("SOURCING_DIS_DATE"))%>"/>
	                      		<input type="hidden" id="st_sourcing_dis_date" name="st_sourcing_dis_date"  value="<%=CommonUtil.nvl(_rowData.get("SOURCING_DIS_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">소싱자료 취합</th>
	                        <td colspan="3">
	                      		<input type="text" id="sourcing_ass_date" name="sourcing_ass_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("SOURCING_ASS_DATE"))%>"/>
	                      		<input type="hidden" id="st_sourcing_ass_date" name="st_sourcing_ass_date"  value="<%=CommonUtil.nvl(_rowData.get("SOURCING_ASS_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">내부 보고</th>
	                        <td colspan="3">
	                      		<input type="text" id="in_reporting_date" name="in_reporting_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("IN_REPORTING_DATE"))%>"/>
	                      		<input type="hidden" id="st_in_reporting_date" name="st_in_reporting_date"  value="<%=CommonUtil.nvl(_rowData.get("IN_REPORTING_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row" class="star">고객사 제안</th>
	                        <td colspan="3">
	                      		<input type="text" id="buyer_proposal_date" name="buyer_proposal_date" class="input_type_text" title="" style="width:80px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("BUYER_PROPOSAL_DATE"))%>"/>
	                      		<input type="hidden" id="st_buyer_proposal_date" name="st_buyer_proposal_date"  value="<%=CommonUtil.nvl(_rowData.get("BUYER_PROPOSAL_DATE"))%>" />
	                      	</td>
	                    </tr>
					</tbody>
				</table>
				
				<p style="font-weight:bold;">[소싱]</P>
				<table class="cont_t_list06" style="width:100%;">
					<colgroup>
						<col width="25%" />
						<col width="25%" />
	                    <col width="25%" />
	                    <col width="25%" />
					</colgroup>

					<tbody>
	                    <tr>
	                        <th scope="row">소싱 자료 배포</th>
	                      	<td>
	                      		<input type="hidden" name="st_sourcing_dis_yn" id="st_sourcing_dis_yn" value="<%=CommonUtil.nvl(_rowData.get("SOURCING_DIS_YN"))%>">
                      			<%=CommonUtil.nvl(_rowData.get("SOURCING_DIS_YN"))%>
	                      	</td>
	                      	
	                      	<th scope="row">소싱 자료 제출</th>
	                      	<td>
	                      		<input type="hidden" name="st_sourcing_subm_yn" id="st_sourcing_subm_yn" value="<%=CommonUtil.nvl(_rowData.get("SOURCING_SUBM_YN"))%>">
                      			<%=CommonUtil.nvl(_rowData.get("SOURCING_SUBM_YN"))%>
	                      	</td>
	                    </tr>
	                    
	                    <tr>
	                        <th scope="row">내부품의</th>
	                        <td>
	                        	<input type="hidden" name="st_in_appr_id" id="st_in_appr_id" value="<%=CommonUtil.nvl(_rowData.get("IN_APPR_ID"))%>">
	                        	<input type="hidden" name="st_in_appr_status" id="st_in_appr_status" value="<%=CommonUtil.nvl(_rowData.get("IN_APPR_STATUS"))%>">
	                        	
                        	<%if(("").equals(CommonUtil.nvl(_rowData.get("IN_APPR_STATUS")))){%>
                        		<a href="javascript:gw_aprv('in_appr', '<%=CommonUtil.nvl(_rowData.get("IN_APPR_ID"))%>', '<%=CommonUtil.nvl(_rowData.get("IN_APPR_STATUS"))%>')">
	                        		<div class="btn_gray_03">결재상신</div>
	                        	</a>
                        	<%}else if(("B").equals(CommonUtil.nvl(_rowData.get("IN_APPR_STATUS")))){%>
                        		<a href="javascript:gw_aprv('in_appr', '<%=CommonUtil.nvl(_rowData.get("IN_APPR_ID"))%>', '<%=CommonUtil.nvl(_rowData.get("IN_APPR_STATUS"))%>')">
                        			<div class="btn_gray_03">결재상신</div>
                        		</a>
                        			/ <%=CommonUtil.nvl(_rowData.get("IN_APPR_STATUS_TEXT"))%>
                        	<%}else{%>
                        		<a href="https://gw.koreab2b.com/qdb-linkage/DocViewer.do?docid=<%=CommonUtil.nvl(_rowData.get("IN_APPR_ID"))%>" target="_blank">
	                        		<div class="btn_gray_03">결재문서</div>
	                        	</a>
	                        		/ <%=CommonUtil.nvl(_rowData.get("IN_APPR_STATUS_TEXT"))%>
                        	<%}%>
	                      	</td>

	                      	<th scope="row">고객사 제안</th>
	                      	<td>
	                      		<input type="hidden" name="st_buyer_proposal_yn" id="st_buyer_proposal_yn" value="<%=CommonUtil.nvl(_rowData.get("BUYER_PROPOSAL_YN"))%>">
	                      		<%=CommonUtil.nvl(_rowData.get("BUYER_PROPOSAL_YN"))%>
	                      	</td>
	                    </tr>
					</tbody>
				</table>
				
				<p style="font-weight:bold;">[제안결과]</P>
				<table class="cont_t_list06" style="width:100%;">
					<colgroup>
						<col width="25%" />
						<col width="25%" />
	                    <col width="25%" />
	                    <col width="25%" />
					</colgroup>

					<tbody>
	                    <tr>
	                        <th scope="row">수주결과</th>
	                      	<td>
	                      		<input type="hidden" name="st_order_result" id="st_order_result" value="<%=CommonUtil.nvl(_rowData.get("ORDER_RESULT"))%>">
	                      		<%=CommonUtil.nvl(_rowData.get("ORDER_RESULT_TEXT"))%>
	                      	</td>
                      		
	                        <th scope="row">내부품의</th>
	                        <td>
	                        	<input type="hidden" name="st_order_in_appr_id" id="st_order_in_appr_id" value="<%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_ID"))%>">
	                        	<input type="hidden" name="st_order_in_appr_status" id="st_order_in_appr_status" value="<%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_STATUS"))%>">
	                        	
                        	<%if(("").equals(CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_STATUS")))){%>
                        		<a href="javascript:gw_aprv('order_appr', '<%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_ID"))%>', '<%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_STATUS"))%>')">
	                        		<div class="btn_gray_03">결재상신</div>
	                        	</a>
                        	<%}else if(("B").equals(CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_STATUS")))){%>
                        		<a href="javascript:gw_aprv('order_appr', '<%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_ID"))%>', '<%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_STATUS"))%>')">
                        			<div class="btn_gray_03">결재상신</div>
                        		</a>
                        			/ <%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_STATUS_TEXT"))%>
                        	<%}else{%>
                        		<a href="https://gw.koreab2b.com/qdb-linkage/DocViewer.do?docid=<%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_ID"))%>" target="_blank">
	                        		<div class="btn_gray_03">결재문서</div>
	                        	</a>
	                        		/ <%=CommonUtil.nvl(_rowData.get("ORDER_IN_APPR_STATUS_TEXT"))%>
                        	<%}%>
	                        	</a>
	                      	</td>
	                    </tr>
					</tbody>
				</table>
				
				<p style="font-weight:bold;">[계약체결]</P>
				<table class="cont_t_list06" style="width:100%;">
					<colgroup>
						<col width="25%" />
						<col width="25%" />
	                    <col width="25%" />
	                    <col width="25%" />
					</colgroup>

					<tbody>
	                    <tr>
	                        <th scope="row">계약체결</th>
	                      	<td>
								<input type="hidden" name="st_contract_image_key" id="st_contract_image_key" value="<%=CommonUtil.nvl(_rowData.get("CONTRACT_IMAGE_KEY"))%>">
	                        	<a class="hyperLink" href="javascript:doPop('contract_attach', '<%=CommonUtil.nvl(_rowData.get("CONTRACT_IMAGE_KEY"))%>')">
                        	<%if(("").equals(CommonUtil.nvl(_rowData.get("CONTRACT_IMAGE_KEY")))){%>
                        			<img id = "st_contract_image_key_img" name = "st_contract_image_key_img" src="/resources/images/disk_off.gif" border="0">
                        	<%}else{%>
                        			<img id = "st_contract_image_key_img" name = "st_contract_image_key_img" src="/resources/images/disk_on.gif" border="0">
                        	<%}%>
	                        	</a>									
                      		</td>
                      		
	                        <th scope="row">시스템반영</th>
	                        <td>
	                        	<input type="hidden" name="st_re_contract_system_yn" id="st_re_contract_system_yn" value="<%=CommonUtil.nvl(_rowData.get("RE_CONTRACT_SYSTEM_YN"))%>">
	                      		<%=CommonUtil.nvl(_rowData.get("RE_CONTRACT_SYSTEM_YN"))%>
	                      	</td>
	                    </tr>
					</tbody>
				</table>
<% } %>
			</div>
			
			<!--버튼영역-->
			<p class="btnArea mt10 mb05">
<% if ("N".equals(completion_yn)) { %>
	<% if ("A".equals(contract_status)) { %> <!-- 사전준비 -->
				<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
				<span class="btn_04"><a href="javascript:doAction('complete','S');">사전준비 완료</a></span>
	<% } else if ("S".equals(contract_status)) { %> <!-- 소싱 -->
				<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
				<span class="btn_04"><a href="javascript:doAction('complete','R');">소싱완료</a></span>
	<% } else if ("R".equals(contract_status)) { %> <!-- 제안결과 -->
				<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
				<span class="btn_04"><a href="javascript:doAction('complete','C');">결과완료</a></span>
	<% } else if ("C".equals(contract_status)) { %> <!-- 계약체결 -->
				<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
				<span class="btn_04"><a href="javascript:doAction('complete','Y');">체결완료</a></span>
	<% } %>
<% } %>
			</p>
		</div>
	</div>
</form> 
</body>
</html>
