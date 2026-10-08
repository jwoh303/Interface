<%--
**********************************************
* 메뉴 : 
* 화면 : 주요활동내용등록 
* 기능 : 주요활동내용등록
* 프로그램 ID : PG_01_M_015_03
* 담당자 : 최철규
* 착수일 : 2017-02-07
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
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
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String com_code =  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String add_date = CommonUtil.nvl((String) request.getParameter("add_date"), "");
String add_time = CommonUtil.nvl((String) request.getParameter("add_time"), "");
String s_user_id = CommonUtil.nvl((String) _sessionInfo.getUserId(), "") ;
String user_id = "";


Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}


if(_rowData != null) {
user_id = CommonUtil.nvl(_rowData.get("ADD_USER_ID"));
}
%>



<script type="text/javascript">
var popupSel = "";
var st;

function kep_onload_view() {
	//조회조건 초기화
	kepSetCalender("st_visit_date");
	<% if (_dataList == null) { %>
		$("#st_visit_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
	<% } %>	
}
//기능함수
function doAction(str, tag) {
	actionFlag = tag;
	$("#flag").val(tag);
	
	switch (str) {
		case "reload":	//초기화
			kepReload("searchForm");
			break;
			
		case "save": // 저장	
			if (checkSubmit()) {
				kepAjaxFormCall("/mdcd/saveMasterMdCdAgentPrimaryActivityDetailRegPop.do", "contentForm", str); 	
			}
			break;
	}
}

//팝업 함수호출
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "fileUpload":				//파일업로드
			openSearchPopup("/common/fileUploadPop.do","?DOC_NO="+$("#st_image_key").val(), "500,430,no");	
			break;
		case "buyer":
			openSearchPopup("/coco/showCommonCoCoCompanyPop.do", "?com_type=B&safety_flag=Y", "500,500,no");
			break;
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	
	if (pMethod == "save") {
		if (sMsg == "OK") {
			if (actionFlag == "insert") {
				msg = "등록";
			} else {
				msg = "수정";
			}
			alert("정상적으로 " + msg + " 완료 되었습니다.");
			setReturn("OK", "");
			return;
		} else {
			alert( msg + " 실패 하였습니다.\n다시 확인하여 주십시요!");
			return;
		}
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}

function kepSearch(){
  $('#masterMdCdAgentPrimaryActivityDetailRegPop').attr("action", "/mdcd/getMasterMdCdAgentPrimaryActivityDetailRegPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setPopupReturn(value1, value2) { 
	
	if (popupSel == "buyer") {
		$("#st_buyer").val(value1); 
		$("#st_buyer_name").val(value2);	
	}
	else if(popupSel == 'fileUpload'){
		<% if(user_id.equals(s_user_id)){ %>
			$("#st_image_key").val(value1);
		<% } %>
	}
}

function setReturn(value1, value2) { 
	opener.setPopupReturn(value1,value2);
	this.close();
}

function checkSubmit() {
	if (isEmpty(kepTrimStr($("#st_visit_date").val()))) {
		alert("방문일을 선택하여 주십시오.");
		$("st_visit_date").focus();
		return false;
	}
	if (isEmpty(kepTrimStr($("#st_visit_time").val()))) {
		alert("방문시간을 선택하여 주십시오.");
		$("#st_visit_time").focus();
		return false;

	}
	if (isEmpty(kepTrimStr($("#st_visit_to_time").val()))) {
		alert("방문시간을 선택하여 주십시오.");
		$("#st_visit_to_time").focus();
		return false;
	}
	if (isEmpty(kepTrimStr($("#st_kep_rspn_text").val()))) {
		alert("KeP 참석자를 입력하여 주십시오.");
		$("#st_kep_rspn_text").focus();
		return false;
	}
	if (isEmpty(kepTrimStr($("#st_agent_rspn_text").val()))) {
		alert("협력사 참석자를 입력하여 주십시오.");
		$("#st_agent_rspn_text").focus();
		return false;
	}
	if (isEmpty(kepTrimStr($("#st_agent_remark").val()))) {
		alert("영업활동 결과를 입력하여 주십시오.");
		$("#st_agent_remark").focus();
		return false;
	}
	
	// 미등록협력사 사용 시 KRKEPS0002 사용하기로 함(한애희)
	var com_code = $("#com_code").val();
	
	if(com_code == "KRKEPS0002"){
		if (isEmpty(kepTrimStr($("#st_agent_name").val()))) {
			alert("협력사정보(협력사명) 입력하여 주세요.");
			document.forms.contentForm.st_agent_name.focus();
			return false;
		}
		
		if (isEmpty(kepTrimStr($("#st_agent_irs_no").val()))) {
			alert("협력사정보(사업자번호) 입력하여 주세요.");
			document.forms.contentForm.st_agent_irs_no.focus();
			return false;
		}
	}
	
	var confir = confirm("주요활동내용을 저장 하시겠습니까?");
	return confir;
}

</script> 
<body onload="kep_onload_view();">
<form id="contentForm" name="contentForm" method="post" onsubmit="return false;">
<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}" />
<input type="hidden" id="com_code" name="com_code" value="<%=com_code%>" />
<input type="hidden" id="add_date" name="add_date" value="<%=add_date%>" />
<input type="hidden" id="add_time" name="add_time" value="<%=add_time%>" />
<input type="hidden" id="flag" name="flag" value="" />
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
		<div id="popHeader">
			<h1 class="title">주요활동내용등록 </h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
		
		<!--팝업내용입니다-->
		<div id="popContainer">
			<div id="contArea">
				<table  class="cont_t_list06"  style="width:100%">
					<caption>주요활동내용등록</caption>
					<colgroup>
						<col width="12%" />
						<col width="30%" />
						<col width="14%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="col"><font color="red">*</font> 방문일시</th> 
							<td class="left">
								<input type="text" id="st_visit_date" name="st_visit_date" class="input_type_text" title=""  maxlength="40" style="width:40%;" readonly value="<%=_rowData != null ? CommonUtil.formatDate(CommonUtil.nvl(_rowData.get("VISIT_DATE"))) : "" %>" />
								<select id="st_visit_time" name="st_visit_time">
									<script>kepAjaxCommonComboDataValue('st_visit_time', 'K004', 'SEL', '<%=_rowData != null ? CommonUtil.nvl(_rowData.get("VISIT_TIME")) : "" %>');</script>
								</select> ~
								<select id="st_visit_to_time" name="st_visit_to_time">
									<script>kepAjaxCommonComboDataValue('st_visit_to_time', 'K004', 'SEL', '<%=_rowData != null ? CommonUtil.nvl(_rowData.get("TO_VISIT_TIME")) : "" %>');</script>
								</select>
							</td> 
							<th scope="col" class=""><font color="red">*</font> KeP 참석자</th>
							<td class="left"><input type="text" id="st_kep_rspn_text" name="st_kep_rspn_text" class="input_type_text" title=""  maxlength="200" style="width:80%;" onkeyup="fnCheckInputByte(this, 200);" onchange="fnCheckInputByte(this, 200);" value="<%=_rowData != null ? CommonUtil.nvl(_rowData.get("KEP_CFRC_NM")) : "" %>" /></td> 
						</tr>
						<tr>
							<th scope="col" class="padding">방문유형</th> 
							<td class="left">
								<select id="st_visit_type" name="st_visit_type">
									<script>kepAjaxCommonComboDataValue('st_visit_type', 'K006', '', '<%=_rowData != null ? CommonUtil.nvl(_rowData.get("VISIT_TYPE")) : "" %>');</script>
								</select>
							</td> 
							<th scope="col"><font color="red">*</font> 협력사 참석자</th>
							<td class="left"><input type="text" id="st_agent_rspn_text" name="st_agent_rspn_text" class="input_type_text" title=""  maxlength="200" style="width:80%;" onkeyup="fnCheckInputByte(this, 200);" onchange="fnCheckInputByte(this, 200);" value="<%=_rowData != null ? CommonUtil.nvl(_rowData.get("AGENT_CFRC_RM")) : "" %>" /></td> 
						</tr>
						<tr>
							<th scope="col" class="padding">첨부파일</th> 
							<td class="left">
								<input type="hidden" id="st_image_key" name="st_image_key"  value="<%=_rowData != null ? CommonUtil.nvl(_rowData.get("IMAGE_KEY")) : "" %>" />
								<span class="btn_gray_03"  title="파일첨부" ><a href="javascript:doPop('fileUpload');">파일첨부</a></span>
							</td> 
							<th scope="col" class="padding">회의장소</th>
							<td class="left"><input type="text" id="st_place_text" name="st_place_text" class="input_type_text" title=""  maxlength="200" style="width:80%;" onkeyup="fnCheckInputByte(this, 200);" onchange="fnCheckInputByte(this, 200);" value="<%=_rowData != null ? CommonUtil.nvl(_rowData.get("CFRC_PLACE")) : "" %>" /></td> 
						</tr>
						<tr>
							<th scope="col" class="padding">고객사</th> 
							<td class="left">
								<input type="hidden" id="st_buyer" name="st_buyer" value="<%=_rowData != null ? CommonUtil.nvl(_rowData.get("BUYER")) : "" %>" readonly/>
								<input type="text" id="st_buyer_name" name="st_buyer_name" class="input_type_text" title=""  maxlength="200" style="width:80%;" onkeyup="fnCheckInputByte(this, 200);" onchange="fnCheckInputByte(this, 200);" value="<%=_rowData != null ? CommonUtil.nvl(_rowData.get("BUYER_NAME")) : "" %>" readonly/>
								
								<a href="javascript:doPop('buyer');"><img src="/resources/images/btn_search03.gif"></a>
						
							</td>
							
<%if(com_code.equals("KRKEPS0002")){%>
							<th scope="col" class="padding"><font color="red">*</font> 협력사정보</th>
							<td class="left">
								<input type="text" id="st_agent_name" name="st_agent_name" class="input_type_text" style="width:43%;" placeholder="협력사명을 입력하세요" value="<%=_rowData != null ? CommonUtil.nvl(_rowData.get("AGENT_NAME")) : "" %>"/>
								&nbsp;/&nbsp;
								<input type="text" id="st_agent_irs_no" name="st_agent_irs_no" class="input_type_text" style="width:30%;" maxlength="12" onkeyup="fnCheckInputByte(this, 12);" onchange="fnCheckInputByte(this, 12);" placeholder="ex) 123-45-67890" value="<%=_rowData != null ? CommonUtil.nvl(_rowData.get("IRS_NO")) : "" %>"/>
							</td>
<%}else{%>
							<th></th>
							<td>
								<input type="hidden" id="st_agent_name" name="st_agent_name" class="input_type_text" style="width:43%;" value="<%=_rowData != null ? CommonUtil.nvl(_rowData.get("AGENT_NAME")) : "" %>"/>
								<input type="hidden" id="st_agent_irs_no" name="st_agent_irs_no" class="input_type_text" style="width:30%;" value="<%=_rowData != null ? CommonUtil.nvl(_rowData.get("IRS_NO")) : "" %>"/>
							</td>
<%}%>
						</tr>
						<tr>
							<th scope="col" colspan="4" class="center"><font color="red">*</font> 영업상 주요 활동결과 / 정보 / 특이사항</th> 
						</tr>
						<tr>
							<td class="left" colspan="4" style="margin:0 0 0 0; padding: 0 0 0 0;"><textarea id="st_agent_remark" name="st_agent_remark"   style="padding-left:5px;text-align:left;width:100%;height:240px;" maxlength="2000" onkeyup="fnCheckInputByte(this, 2000);" onchange="fnCheckInputByte(this, 2000);"><%=_rowData != null ? CommonUtil.nvl(_rowData.get("VISIT_NOTE")) : "" %></textarea></td> 
						</tr>
					</tbody>
				</table>
				<% if(_rowData != null) { %>
				<% if(user_id.equals(s_user_id) ) {%>
				<div class="btnArea mt10 mb05">
					<span class="fr">
						<span class="btn_02 mr05"><a href="javascript:doAction('save', 'update');">수정</a></span>
					</span>
				</div>
				<% } %>
				<% } else { %>
				<div class="btnArea mt20">
					<span class="fr">
						<span class="btn_02 mr05"><a href="javascript:doAction('save', 'insert');">등록</a></span>
					</span>
				</div>
				<% } %>
			</div>
		</div>
	</div>
</form> 
</body>
</html>
