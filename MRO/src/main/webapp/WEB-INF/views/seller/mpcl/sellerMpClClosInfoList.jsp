<%--
**********************************************
* 메뉴 : 마감정보조회
* 화면 : 마감정보조회
* 기능 : 그리드 이용한 마감정보조회
* 프로그램 ID : 
* 담당자 : 한승준
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	//initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 6};
	
	initsheet.Cols = [
					 { Align:"Center",	SaveName:"sStatus",					Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELECTED",				Header:"",					Type:"DummyCheck",	Width:60,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Left",	SaveName:"BUYER_NAME",				Header:"고객사",				Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false}							
					,{ Align:"Center",	SaveName:"PO_CREATE_DATE",			Header:"발주일",				Type:"Date",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"PO_NO",					Header:"발주번호",				Type:"Text",		Width:85,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",			Header:"품목코드",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"DESCRIPTION",				Header:"품명",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"SPECIFICATION",			Header:"규격",				Type:"Text",		Width:250,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Right",	SaveName:"AGENT_PRICE",				Header:"단가",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"UNIT_MEASURE",			Header:"단위",				Type:"Text",		Width:50,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Right",	SaveName:"PO_QTY",					Header:"발주수량",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Right",	SaveName:"PO_AMT",					Header:"발주금액",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Right",	SaveName:"DELIVERY_QTY",			Header:"납품총수량",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Right",	SaveName:"DELIVERY_AMT",			Header:"납품금액",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Right",	SaveName:"GR_QTY",					Header:"입고총수량",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Right",	SaveName:"GR_AMT",					Header:"입고금액",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"DS_DATE",					Header:"납품예정일",				Type:"Date",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"DELIVERY_DATE",			Header:"납품확정일",				Type:"Date",		Width:75,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"LEGACY_PO_NO",			Header:"고객사발주번호",			Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"KEP_USER_NAME",			Header:"KEP담당자",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"KEP_USER_PHONE",			Header:"담당자연락처",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"PO_SEQ",					Header:"발주항번",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Left",	SaveName:"LEGACY_PO_SEQ",			Header:"고객사발주항번",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"PURCHASER_NAME",			Header:"발주자",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"CHANGE_USER_MOBILE_PHONE",Header:"인수자연락처",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"BUYER",					Header:"고객사코드",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"BUYER2",					Header:"고객사코드2",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",		Header:"카탈로그관리코드",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"CONTRACT_NO",				Header:"계약서번호",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"CONTRACT_SEQ",			Header:"계약서항번",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NAME");
	setLinkCol(mySheet, "PO_NO");
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	
	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	dateSetting();
}

var st;
var mt;
// 기능함수
function doAction(str) {

	st = new Date();
	
	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 31 ){
				alert("조회기간을 1개월 단위로 조회가 가능합니다.");
				return;
			}
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mpcl/getSellerMpClClosInfoList.do" , pagingMode);
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			// 조회일 초기 셋팅
			kepSetCalender("st_from_date");
			kepSetCalender("st_to_date");

			dateSetting();
			break;
		case "excelDown": // 엑셀다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 31 ){
				alert("조회기간을 1개월 단위로 조회가 가능합니다.");
				return;
			}
			
		    $("#pageflag").val('0');
			var param = {FileName:"마감정보조회.xlsx",DownCols:"BUYER_NAME|BUYER2|PO_CREATE_DATE|BUYER_ITEM_NO|PO_NO|PO_SEQ|DESCRIPTION|SPECIFICATION|AGENT_PRICE|UNIT_MEASURE|PO_QTY|PO_AMT|DELIVERY_QTY|DELIVERY_AMT|GR_QTY|GR_AMT|DS_DATE|DELIVERY_DATE|LEGACY_PO_NO|LEGACY_PO_SEQ|PURCHASER_NAME|CHANGE_USER_MOBILE_PHONE|KEP_USER_NAME|KEP_USER_PHONE|"};
			kepDownExcel(document.searchCondition ,mySheet , "/mpcl/excelSellerMpClClosInfoList.do", param);
			$("#pageflag").val('1');
			break;
		case "reportOpen": // 고객사별 집계
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 31 ){
				alert("조회기간을 1개월 단위로 조회가 가능합니다.");
				return;
			}
			
			var agent_code = $("#st_com_code").val();
			var st_from_date = $("#st_from_date").val().replace(/\//gi, "");
			var st_to_date = $("#st_to_date").val().replace(/\//gi, "");

			reportOpen("RD_06_S_001_91", "[" + agent_code + "][" + st_from_date + "][" + st_to_date + "]");
			break;
	}
}

function dateSetting() {
	// 일자 설정
	var tempDate = kepToMonthAdd("1", "M").replace(/[/]/gi, "");
	var tempYear = tempDate.substring(0, 4);
	var tempMonth = tempDate.substring(4, 6);
	var tempDay = lastDay(tempYear, tempMonth);

	$("#st_from_date").val(kepGetDateStr(tempYear + tempMonth + "01", "/"));
	$("#st_to_date").val(kepGetDateStr(tempDay, "/"));
}

//현재달의 마지막날(일자) 구하기
function lastDay(y, m) {
	var d2, s = "";
	var year, month, day;

	d2 = new Date(y, m, "");

	year = d2.getFullYear();
	month = (d2.getMonth() + 1);
	day = d2.getDate();

	if (month < 10) {
		month = "0" + month;
	}
	if (day < 10) {
		day = "0" + day;
	}

	s = year.toString() + month.toString() + day.toString();

	return (s);
}

//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2(mySheet, 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2(mySheet, current_page , document.searchCondition.onepagerow.value);	
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpcl/getSellerMpClClosInfoList.do?page="+current_page , pagingMode );
}

//팝업함수호출
function doPop(str, value1, value2, value3, value4, value5) {
	switch (str) {
	case "icomcmpyPop": // 고객사 선택
		popupSel = "icomcmpyPop";
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
		break;
	}
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_buyer_code = mySheet.GetCellValue(Row, "BUYER");
	var st_buyer_code2 = mySheet.GetCellValue(Row, "BUYER2");
	var st_po_no = mySheet.GetCellValue(Row, "PO_NO");
	var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
	var st_byit_comorg_code = mySheet.GetCellValue(Row, "BYIT_COMORG_CODE");
	var st_contract_no = mySheet.GetCellValue(Row, "CONTRACT_NO");
	var st_contract_seq = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
	
	if(column == "BUYER_NAME"){
		openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code=" + st_buyer_code2, "800,550,no");
	}
	
	if(column == "PO_NO"){
		openSearchPopup("/mpiv/getCommonMpIvOrderInfoPop.do", "?st_buyer=" + st_buyer_code + "&st_po_no=" + st_po_no, "930,600,no");
	}
	
	if(column == "BUYER_ITEM_NO"){
		getBuyerCatalogDisplayPop(st_byit_comorg_code, st_buyer_item_no, st_contract_no, st_contract_seq);
	}
	
	return;
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg.msg);
	}
	if ( code > 0 ) {
		//저장 성공시 처리
		doAction("search");
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
}

// ajax 공통 호출후 에러시 처리 함수
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction("search");
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	if (popupSel = "icomcmpyPop") {
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(text);
	}
}

</script>
</head>
<%
@SuppressWarnings (value="unchecked")
String userID = _sessionInfo.getUserId();
%>
<body onload="kep_onload_view()">
<div id="wrapper">
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>
<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="sellerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>

<!--내용 시작-->
<div id="ContArea">
	
	<!--버튼영역-->
	<div id="searchBtnA">
		<h3>마감정보조회</h3>
		<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
		<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	</div>        	
	
	<!--조회영역-->
	<form id="searchCondition" name="searchCondition" method="post" onsubmit="return false;" >
		<div>
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME" />
			<input type="hidden" id="pageflag" name="pageflag" value="1" />
			
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_com_code" name="st_com_code" value="${sessionInfo.comCode}" />
		</div>
        
		<div id="cont_searchA">
			<table class="cont_t_list01">
				<caption>조회</caption>
				<colgroup>
					<col width="8%" />
					<col width="25%" />
					<col width="9%" />
					<col width="25%" />
					<col width="8%" />
					<col width="25%" />
				</colgroup>

				<tbody>
					<tr>
						<td>조회일</td>
						<td colspan="3">
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width: 100px; text-align: center;" value="">
							<a href="javascript:kepCalendar('st_from_date')"></a>
							&nbsp;~&nbsp;
							<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width: 100px; text-align: center;" value="">
							<a href="javascript:kepCalendar('st_to_date')"></a>
	          				<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>
						</td>

						<td>고객사</td>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:55%" value="" readonly onclick="javascript:doPop('icomcmpyPop');">
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:55%" value="">
							<a href="javascript:doPop('icomcmpyPop');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
					</tr>
					
					<tr>
						<td>정산여부</td>
						<td>
							<select id="st_ap_yn" name="st_ap_yn" style="width:45%">
								<option value = "" selected>전체</option>
								<option value = "Y">Y</option>
								<option value = "N">N</option>
							</select>
						</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</tbody>
			</table>
		</div>

		<span class="fl">
			<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
			<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" style="width: 70px;" onChange="doAction('search');">
				<option value="10" selected>10건</option>
				<option value="20">20건</option>
				<option value="30">30건</option>
				<option value="40">40건</option>
				<option value="50">50건</option>
			</select>
		</span>
		<br>
	</form>
					
	<!--grid-->
	<div class="ib_product" style="border-top:2px solid #3c639c">
		<script type="text/javascript">
			createIBSheet("mySheet", "", "354px");
		</script>
	</div>
	<p class="paging" id="pageindex"></p>

	<!-- 버튼영역 -->
	<div class="btnArea">
		<div class="fr">
			<span class="btn_04 mr04"> <a href="javascript:doAction('reportOpen');">고객사별 집계</a></span>
			<span class="btn_04"> <a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
		</div>
	</div>
<!--내용 종료-->
</div>
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>
</div>
</body>
</html>
