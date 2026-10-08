<%--
**********************************************
* 메뉴 : 회원사관리>협력사관리>이메일/문자 발송내역 관리
* 화면 : 이메일/문자 발송내역 관리
* 기능 : 
* 프로그램 ID : 
* 담당자 : 임태성
* 착수일 : 
**********************************************
--%>
<%@page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"), "");
String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"), "");
String st_agent_address = CommonUtil.nvl((String) request.getParameter("st_agent_address"), "");
String st_sender_name = CommonUtil.nvl((String) request.getParameter("st_sender_name"), "");

%>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

const STR_DM_ID = "DM_ID";
const STR_SEND_PROC_DATE = "SEND_PROC_DATE";
const STR_SEND_TYPE = "SEND_TYPE";
const STR_DM_TYPE = "DM_TYPE";
const STR_RECV_COM_CODE = "RECV_COM_CODE";
const STR_RECV_COM_NAME = "RECV_COM_NAME";
const STR_SENT_BUYER_NAME = "SENT_BUYER_NAME";
const STR_SENT_PO_NO = "SENT_PO_NO";
const STR_RECV_SUBJECT = "RECV_SUBJECT";
const STR_SMS_CONTENTS = "SMS_CONTENTS";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PK",		SaveName:STR_DM_ID}
					,{ Align:"Center",	Width:200,	Edit:false,	EditLen:100,					Type:"Text",	Header:"발송날짜",		SaveName:STR_SEND_PROC_DATE}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,					Type:"Text",	Header:"구분",		SaveName:STR_SEND_TYPE}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"구분코드",		SaveName:STR_DM_TYPE}
					,{ Align:"Center",	Width:0,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"수신처코드",	SaveName:STR_RECV_COM_CODE}
					,{ Align:"Center",	Width:300,	Edit:false,	EditLen:100,					Type:"Text",	Header:"수신처",		SaveName:STR_RECV_COM_NAME}
					,{ Align:"Center",	Width:300,	Edit:false,	EditLen:100,					Type:"Text",	Header:"고객사",		SaveName:STR_SENT_BUYER_NAME}
					,{ Align:"Center",	Width:250,	Edit:false,	EditLen:100,					Type:"Text",	Header:"발주번호",		SaveName:STR_SENT_PO_NO}
					,{ Align:"Center",	Width:600,	Edit:false,	EditLen:100,					Type:"Text",	Header:"제목/문구",	SaveName:STR_RECV_SUBJECT}
					,{ Align:"Center",	Width:0,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"내용",		SaveName:STR_SMS_CONTENTS}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4);

	//하이퍼링크 설정
	setLinkCol(mySheet, STR_RECV_COM_NAME);
	setLinkCol(mySheet, STR_RECV_SUBJECT);

	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");

	// 발송일자 기본 2개월
	$("#st_from_date").val( kepToMonthAdd("2","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));

}

// 기능함수
function doAction(str) {
	
	switch (str) {
	case "search":	 // 조회
		// 로그인 유저 취득
		var st_user_id = $("#st_user_id").val();
		if(check_search() == false){
			alert("하나 이상의 검색값을 입력해주세요.");
			return;
		}
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdcp/getMasterMdCpAgentDmHistory.do" , pagingMode );
		break;
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		$("#st_from_date").val( kepToMonthAdd("2","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		document.forms.searchCondition.st_checkbox.checked = false; // 기간무시
		document.forms.searchCondition.st_checkbox_mail.checked = false; // 이메일
		document.forms.searchCondition.st_checkbox_sms.checked = false; // 문자

		break;

	}
}
//팝업함수호출
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "seller": // 수신처
			openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=S&MULTI=N', "500,466,no");
			break;
	}
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	return DATA;
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if(mySheet.RowCount() <= 0) return;

	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);
	}
}
	
// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcp/getMasterMdCpAgentDmHistory.do?page="+current_page , pagingMode );
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == STR_RECV_COM_NAME) { // 수신처
		// 보낸 수신처 목록 표시
		popupSel = "masterMdCmAgentDmContactListPop";
		var st_form_name = "AgentDmContactListPopForm";
		var st_popup_url = "/mdcm/showMasterMdCmAgentDmContactListPop.do";
		var st_popup_param = STR_DM_ID + "@@" + mySheet.GetCellValue(Row, STR_DM_ID) + "^||^" + STR_DM_TYPE  + "@@" + mySheet.GetCellValue(Row, STR_DM_TYPE);
		var st_popup_option = "600,250,no";
		//post 팝업 호출
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}else if (column == STR_RECV_SUBJECT) { // 제목/문구
		// 보낸 내용 표시
		var dmType = mySheet.GetCellValue(Row,STR_SEND_TYPE);
		var mailFlg = "E-MAIL";
		var smsFlg = "문자";
		if(nullCheck(dmType)) return;

		if(dmType == mailFlg){
			alert('메일 발송 내용은 그룹웨어 수신 내역에서 확인해주세요.');
		}else if(dmType == smsFlg){
			// SMS 발송 팝업 표시
			popupSel = "masterMdCmAgentDmSendHistoryDetailPop";
			var st_form_name = "gentDmSendHistoryDetailPopForm";
			var st_popup_url = "/mdcm/showMasterMdCmAgentDmSendHistoryDetailPop.do";
			var sms_contents = mySheet.GetCellValue(Row, STR_SMS_CONTENTS);
			var st_popup_param = STR_SMS_CONTENTS + "@@" + sms_contents.replaceAll("@@", "^&^&");
			var st_popup_option = "600,275,no";
			//post 팝업 호출
			openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
		}
	}
	return;
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){

	//팝업 조회후 해당 항목에 값을 셋팅
	if(popupSel == "seller") {	// 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
	}
	grbRow="";	//초기화
}

//검색 조건 공백 확인 처리 
function check_search(){
	var st_agent_name = document.forms.searchCondition.st_agent_name.value;
	var st_agent_address = document.forms.searchCondition.st_agent_address.value;
	var st_sender_name = document.forms.searchCondition.st_sender_name.value;
	
	// 모두 공백이라면 true
	if(nullCheck(st_agent_name) && nullCheck(st_agent_address) && nullCheck(st_sender_name)){
		return false;
	}

	// 공백확인 끝나면 trim처리 
	$("#st_agent_address").val(TrimCommon($("#st_agent_address").val())); // 수신 연락처
	$("#st_sender_name").val(TrimCommon($("#st_sender_name").val())); // 발송자
	
	var _st_checkbox = $("input:checkbox[name=st_checkbox]");
	if(_st_checkbox.is(":checked") == true){
		$("#st_date_flg").val(true);
	} else {
		$("#st_date_flg").val("");
	}

	return true;
}

/**
 * 빈값 체크 null이면 true 아니면 false
 * param {*}
 * return boolean
 */
function nullCheck(element){
	const result = false;
	if(element === null) return true;
	if(element === undefined) return true;
	if(element === '') return true;
	return result;
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
		<div id="searchBtnA"  >
			<h3>이메일/문자 발송내역 관리</h3>
			<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
			<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
		</div>
		<!--조회영역-->
		<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_date_flg" name="st_date_flg"  value="">
				<table  class="cont_t_list01" >
					<caption>이메일/문자 발송내역 관리</caption>
					<colgroup>
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
						<col width="21%" />
					</colgroup>
					<tbody>
						<tr>
							<th>발송일자</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="<%=st_from_date%>">
								<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="<%=st_to_date%>">
								<a href="javascript:kepCalendar('st_to_date')"></a>
								&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepFromMonth('st_from_date','st_to_date','1')">-1개월</a></span>
								&nbsp;&nbsp;
								<input type="checkbox" class="Noborder" name="st_checkbox" id="st_checkbox">
								&nbsp;기간무시
								<img src="/resources/images/but_query.png" title="[기간무시 조회기준]
																					제한없음">
							</td>
							<th>구분</th>
							<td>
								<input type="checkbox" class="Noborder" name="st_checkbox_mail" id="st_checkbox_mail">
								&nbsp;이메일&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="checkbox" class="Noborder" name="st_checkbox_sms" id="st_checkbox_sms">
								&nbsp;문자
							</td>
						</tr>
						<tr> 
							<th>수신처</th>
							<td colspan="2">
								<a href="javascript:doPop('seller');">
									<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:67%;" value ="" READONLY>
									<input type="hidden" name="st_agent_code" id="st_agent_code" value ="">
									<img style="margin-left: -5px;" src="/resources/images/btn_search03.gif">
								</a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img style="margin-left: -5px;" src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th></th>
							<th>수신 연락처</th>
							<td>
								<input type="text" id="st_agent_address"  name="st_agent_address"  class="input_type_text" value="<%=st_agent_address %>"  style="width:97%;ime-mode:active" onkeydown="kepEnter()">
							</td>
						</tr>
						<tr> 
							<td>발송자</td>
							<td colspan="1">
								<input type="text" id="st_sender_name"  name="st_sender_name"  class="input_type_text" value="<%=st_sender_name %>"  style="width:105%;ime-mode:active" onkeydown="kepEnter()">
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
				<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="50" selected>50건</option>
					<option value="70" >70건</option>
					<option value="100" >100건</option>
				</select>
			</span>
			<br>
		</form>
					
		<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
<!--내용 종료-->

</body>
</html>
