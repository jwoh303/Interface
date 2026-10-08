<%--
**********************************************
* 메뉴 : 회원사관리>재계약관리
* 화면 : 재계약관리
* 기능 :
* 프로그램 ID :
* 담당자 : HSJ ( 설계 : HMH )
* 착수일 : 2022-11-16
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script type="text/javascript">
<%
String org_name = CommonUtil.nvl((String) request.getParameter("org_name"), "");
String searchYn	= CommonUtil.nvl((String)request.getParameter("search_yn"));
%>

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

var blue = "/resources/images/icon_bl.gif";
var green = "/resources/images/icon_g.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	SaveName:"sStatus",					Header:"상태|상태",					Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"CONTRACT_NO",				Header:"소싱요청번호|소싱요청번호",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"ORG_CODE",				Header:"사업장코드|사업장코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Left",	SaveName:"ORG_NAME",				Header:"사업장명|사업장명",				Type:"Text",		Width:300,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"CONTRACT_STATUS",			Header:"계약상태|계약상태",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"CONTRACT_TYPE_TEXT",		Header:"계약유형|계약유형",				Type:"Text",		Width:80,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"CONTRACT_START",			Header:"계약시작일|계약시작일",			Type:"Date",		Width:80,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"CONTRACT_END",			Header:"계약종료일|계약종료일",			Type:"Date",		Width:80,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"MONTH_DIFF",				Header:"거래기간(개월)|거래기간(개월)",	Type:"Text",		Width:100,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"CONTRACT_USER_DEPT_NAME",	Header:"사업팀|사업팀",					Type:"Text",		Width:120,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"CONTRACT_USER_NAME",		Header:"담당자|담당자",					Type:"Text",		Width:80,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"PAR_AMOUNT",				Header:"모수금액|모수금액",				Type:"Text",		Width:80,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"ORDER_RESULT_TEXT",		Header:"결과|결과",					Type:"Text",		Width:80,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"PRE_IMAGE",				Header:"재계약 진행 현황|사전준비",			Type:"Image",		Width:80,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"SOURCING_IMAGE",			Header:"재계약 진행 현황|소싱",			Type:"Image",		Width:80,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"ORDER_IMAGE",				Header:"재계약 진행 현황|제안결과",			Type:"Image",		Width:80,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"CONTRACT_IMAGE",			Header:"재계약 진행 현황|계약체결",			Type:"Image",		Width:80,	Edit:false,	EditLen:0,		Hidden:false}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetCountPosition(4);

	//하이퍼링크 설정
	setLinkCol(mySheet, "CONTRACT_NO");	//소싱요청번호
	setLinkCol(mySheet, "ORG_NAME");	//고객사명
	setLinkCol(mySheet, "PRE_IMAGE");	//사전준비
	setLinkCol(mySheet, "SOURCING_IMAGE");	//소싱
	setLinkCol(mySheet, "ORDER_IMAGE");	//제안결과
	setLinkCol(mySheet, "CONTRACT_IMAGE");	//계약체결
	
	//파일첨부이미지설정
	mySheet.SetImageList(0, blue);
	mySheet.SetImageList(1, green);
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepToMonthAdd("1","P"));
	
	var searchYn = "<%=searchYn%>";
	
	if(searchYn == "Y"){
		doAction("search");
	}
}

var st;
var mt;
// 기능함수
function doAction(str) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		
			var diff = kepGetDateDiff('st_from_date','st_to_date','D');
			if (eval(diff)>92){
				alert("3개월내 조회만 가능합니다.");
				return;
			}
			
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdct/getMasterMdCtBuyerReContractList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			
			$("#st_from_date").val( kepToMonthAdd("1","M") );
			$("#st_to_date").val( kepToMonthAdd("1","P") );
			break;
		}
	
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

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
	kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdCtBuyerReContractList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val) {
	popupSel = str;
	
	switch (str) {
		case "cominfo": // 고객사 M
			openSearchPopup("/mdct/showMasterMdCtBuyerProfilePop.do", "", "900,700,no");
			break;	
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if(Row < 2) return; // 헤더 병합으로 2번째 줄부터 유효한 클릭
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'CONTRACT_NO' || column == 'PRE_IMAGE' || column == 'SOURCING_IMAGE' || column == 'ORDER_IMAGE' || column == 'CONTRACT_IMAGE'){
		//post 팝업 파라미터 설정
		var st_form_name = "reContractPopForm";
		var st_popup_url = "/mdct/getMasterMdCtBuyerReContractPopList.do";
		var st_popup_param = "contract_no@@"+mySheet.GetCellValue(Row,"CONTRACT_NO")+"^||^"+"contract_status@@"+mySheet.GetCellValue(Row,"CONTRACT_STATUS");
		var st_popup_option = "600,550,no";
		//post 팝업 호출
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}

	if (column == 'ORG_NAME') { // 고객사명
		//post 팝업 파라미터 설정
		var st_form_name = "buyerProfileForm";
		var st_popup_url = "/mdct/getMasterMdCtBuyerProfilePopList.do";
		var st_popup_param = "org_code@@"+mySheet.GetCellValue(Row,"ORG_CODE");
		var st_popup_option = "900,800,no";
		//post 팝업 호출
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}
	return;
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if (code > 0) {
		//저장 성공시 재조회
		doAction("search");
	}
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction("search");
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	if (popupSel == "cominfo") {
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdct/getMasterMdCtBuyerReContractList.do" , pagingMode );
	}
	
	if (code == "CREATE"){
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdct/getMasterMdCtBuyerReContractList.do" , pagingMode );
	}

	grbRow="";	//초기화
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>재계약관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition" name="searchCondition" method="post" onsubmit="return false;" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>재계약관리</caption>
					<colgroup>
						<col width="10%" />
						<col width="60%" />
						<col width="10%" />
						<col width="20%" />
					</colgroup>
						
					<tbody>
						<tr>
							<td>계약시작일</td>
							<td style="text-align:left;">
								<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:80px; text-align:center;" > - 
								<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:80px; text-align:center;" >
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
							</td>
							<td>사업장</td>
							<td style="text-align:left;">
								<input type="text" class="input_type_text" name="st_org_name" id="st_org_name" style="width:90%" value="<%=org_name%>"  onkeydown="kepEnter();" />
							</td>
						</tr>
						<tr>
							<td>진행상태</td>
							<td style="text-align:left;">
								<select id="st_contract_status" name="st_contract_status" style="width:100px;">
									<script>kepAjaxCommonComboDataValue('st_contract_status', 'RWST', 'ALL', '');</script>
								</select>
							</td>
							<td>소싱요청번호</td>
							<td style="text-align:left;">
								<input type="text" name="st_ct_no" id="st_ct_no" style="width:90%;" >
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
				</select>
				&nbsp;<img src="/resources/images/icon_bl.gif"> 진행중
				&nbsp;<img src="/resources/images/icon_g.gif"> 완료
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
