<%--
**********************************************
* 메뉴 : 회원사관리>협력사관리>협력사 연락처 관리
* 화면 : 협력사 연락처 관리
* 기능 : 
* 프로그램 ID : 
* 담당자 : 
* 착수일 :
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String SessionUserId		 = sessionInfo.getUserId();
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",		Width:0,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus"}
					,{ Align:"Center",		Width:40,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Radio",		Header:"선택",			SaveName:"SELECTED"}
					,{ Align:"Center",		Width:0,	Edit:false,	EditLen:260,	Hidden:true,	Type:"Text",		Header:"PK",			SaveName:"RECV_PK"}
					,{ Align:"Center",		Width:0,	Edit:false,	EditLen:260,	Hidden:true,	Type:"Text",		Header:"COM_CODE",		SaveName:"COM_CODE"}
					,{ Align:"Center",		Width:160,	Edit:false,	EditLen:260,	Hidden:false,	Type:"Text",		Header:"협력사명",			SaveName:"AGENT_NAME"}
					,{ Align:"Center",		Width:300,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"사업자등록번호",	SaveName:"AGENT_IRS_NO"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"대표자명",			SaveName:"AGENT_CEO_NAME"}
					,{ Align:"Center",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"대표전화",			SaveName:"AGENT_TEL"}
					,{ Align:"Center",		Width:480,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"본사주소",			SaveName:"AGENT_ADDRESS"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"이력",			SaveName:"AGNET_HISOTRY"}
	];	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4);
	//하이퍼링크 설정
	setLinkCol(mySheet, "AGNET_HISOTRY");		// 이력
}

// 기능함수
function doAction(str) {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && str != "creditSearch" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			// 로그인 유저 취득
			var st_user_id = $("#st_user_id").val();
			if(check_search() == false){
				alert("협력사명, 사업자등록번호, 대표자명, 대표전화, 본사주소 중 하나 이상 조회조건이 필요합니다.");
				return;
			}
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdcp/getMasterMdCpAegntContactList.do" , pagingMode );
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
	}
}

// 검색 조건 공백 확인 처리 
function check_search(){
	var com_name = document.forms.searchCondition.st_com_name.value;
	var irs_no = document.forms.searchCondition.st_irs_no.value;
	var ceo_name = document.forms.searchCondition.st_ceo_name.value;
	var tel_no = document.forms.searchCondition.st_tel_no.value;
	var address_loc = document.forms.searchCondition.st_address_loc.value;
	
	// 모두 공백이라면 true
	if(nullCheck(com_name) && nullCheck(irs_no) && nullCheck(ceo_name)
		&& nullCheck(tel_no) && nullCheck(address_loc)){
		return false;
	}

	// 공백확인 끝나면 trim처리 
	$("#st_com_name").val(TrimCommon($("#st_com_name").val()));
	$("#st_irs_no").val(TrimCommon($("#st_irs_no").val()));
	$("#st_ceo_name").val(TrimCommon($("#st_ceo_name").val()));
	$("#st_tel_no").val(TrimCommon($("#st_tel_no").val()));
	$("#st_address_loc").val(TrimCommon($("#st_address_loc").val()));

	return true;
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	return DATA;
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcp/getMasterMdCpAegntContactList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val1, val2, val3, val4) {
	popupSel = str;
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str =="agentContactMng" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	switch (str) {
		case "getAgentContactHistory": // 수정이력 팝업
			var st_form_name = "AgentContactHistoryPopForm";
			var st_popup_url = "/mdcm/showMasterMdCmAgentContactHistoryPop.do";
			var st_popup_param = "st_com_code@@"+val1;
			var st_popup_option = "1400,630,no";
			//post 팝업 호출
			openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
			break;
		case "agentContactMng":
			var st_com_code = mySheet.GetCellValue(selectedGrid,"COM_CODE"); // com_code 취득
			//post 팝업 파라미터 설정
			var st_form_name = "AgentContactMngPopForm";
			var st_popup_url = "/mdcm/showMasterMdCmAgentContactMngPop.do";
			var st_popup_param = "st_com_code@@"+st_com_code;
			var st_popup_option = "850,540,no";
			//post 팝업 호출
			openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
			break;
	}
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	var st_com_code = mySheet.GetCellValue(Row,"COM_CODE"); // com_code 취득

	if(column == 'AGNET_HISOTRY'){
		// 이력 클릭
		doPop("getAgentContactHistory",st_com_code,'','','');
	}
	return;
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	if (pMethod == "creditSearch") {
		mySheet.SetCellValue(creditRow, 'CREDIT_AGENT_CNT', sMsg );
	}else if(pMethod == "getUrl"){
		var url = response.url;
		window.open(url, "", "width=770,height=800,resizable=YES");
	}else if(pMethod == "getRejectReason"){
		popupSel = "cancelRemark";
		var viewType="eContReject";
		var cancel_remark = response.reason;
		openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType,"500,230,no");
	}
}

//ajax 공통 호출후 에러시 처리 함수
function  kepAjaxError(pMethod , response) {
	alert("처리중 오류가 발생 하였습니다.");		//처리중 오류가 발생 하였습니다.
}

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		alert(msg);
	}
	
	// 페이지 처리
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
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
		<h3>협력사 연락처 관리</h3>
		<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	</div>			
	<!--조회영역-->
	<form id="searchCondition" name="searchCondition" method="post" onsubmit="return false" >
		<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1" />
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}" />
			<input type="hidden" id="st_com_code" name="st_com_code"  value="" />
			<table  class="cont_t_list01" >
				<caption>협력사 연락처 관리</caption>
				<colgroup>
					<col width="14%" />
					<col width="20%" />
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="20%" />
					<col width="*" />
				</colgroup>
					
				<tbody>
					<tr>
						<td>협력사명</td>
						<td>
							<input type="text" id="st_com_name" name="st_com_name" class="input_type_text" title="" style="width:80%;" value=""  onkeydown="kepEnter();" />
						</td>
						<td>사업자등록번호</td>
						<td>
							<input type="text" id="st_irs_no" name="st_irs_no" class="input_type_text" title="" style="width:80%;" value=""  onkeydown="kepEnter();" />
						</td>
						<td>대표자명</td>
						<td>
							<input type="text" id="st_ceo_name" name="st_ceo_name" class="input_type_text" title="" style="width:80%;" value=""  onkeydown="kepEnter();" />
						</td>
					</tr>
					<tr>
						<td>대표전화</td>
						<td>
							<input type="text" id="st_tel_no" name="st_tel_no" class="input_type_text" title="" style="width:80%;" value=""  onkeydown="kepEnter();" />
						</td>
					</tr>
					<tr>
						<td>본사주소</td>
						<td colspan="6">
							<input type="text" id="st_address_loc" name="st_address_loc" class="input_type_text" title="" style="width:95%;" value="" onkeydown="kepEnter();" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
			<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" style="width: 70px;" >
				<option value="50" selected>50건</option>
				<option value="70">70건</option>
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
	
	<!--버튼영역-->
	<div class="btnArea">
		<span>
			<span class="btn_07 mr04"><a href="javascript:doPop('agentContactMng');">협력사 연락처 설정</a></span>
		</span>
	</div>
<!--내용 종료-->
</body>
</html>
