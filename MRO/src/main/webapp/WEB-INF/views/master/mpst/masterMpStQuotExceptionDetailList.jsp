<%--
**********************************************
* 메뉴 : 단가 조정통계 > 견적 최저가 예외 상세
* 화면 : 견적 최저가 예외 상세
* 기능 :
* 프로그램 ID : 
* 담당자 : CCK
* 착수일 : 2021-03-11
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ include file="../../common/include/head.jspf"  %>
<%
String _stFromDate = CommonUtil.nvl(request.getParameter("st_from_date"));
String _stToDate = CommonUtil.nvl(request.getParameter("st_to_date"));
%>
<script src="/resources/js/common.js"></script>
<style type="text/css">
<!--
	table.ui-datepicker-calendar { display:none; }
-->
</style>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		{ Align:"Center",	Width:120,	Edit:false,	EditLen:70,		Hidden:false,	Type:"Text",			Header:"부서명|부서명",	SaveName:"TEAM_NM",			ColMerge:0}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:70,		Hidden:false,	Type:"Text",			Header:"담당자|담당자",	SaveName:"KEP_USER_NM",			ColMerge:0}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:70,		Hidden:false,	Type:"Text",			Header:"고객사코드|고객사코드",	SaveName:"BUYER_CODE",			ColMerge:0}
		,{ Align:"Left",	Width:150,	Edit:false,	EditLen:70,		Hidden:false,	Type:"Text",			Header:"고객사명|고객사명",	SaveName:"BUYER_NM",			ColMerge:0}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:70,		Hidden:false,	Type:"Text",			Header:"견적번호|견적번호",	SaveName:"QUOTATION_NO",			ColMerge:0}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:70,		Hidden:false,	Type:"Text",			Header:"견적항번|견적항번",	SaveName:"QUOTATION_SEQ",			ColMerge:0}
		,{ Align:"Left",	Width:150,	Edit:false,	EditLen:70,		Hidden:false,	Type:"Text",			Header:"협력사명|협력사명",	SaveName:"AGENT_NM",			ColMerge:0}
		,{ Align:"Left",	Width:220,	Edit:false,	EditLen:70,		Hidden:false,	Type:"Text",			Header:"품목|품목",	SaveName:"DESCRIPTION",			ColMerge:0}
      	,{ Align:"Right",	Width:70,	Edit:false,	EditLen:70,		Hidden:false,	Type:"Text",			Header:"수량|수량",		SaveName:"ITEM_QTY",			ColMerge:0}
      	,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"예외사항|예외사항",	SaveName:"GUBUN",					ColMerge:0}
		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"최저가 대비 차액|최저가",	SaveName:"LOW_AMT",			ColMerge:0}
		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"최저가 대비 차액|낙찰가",	SaveName:"BUY_AMT",			ColMerge:0}
		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"최저가 대비 차액|차액",	SaveName:"DIF_AMT",					ColMerge:0}
		,{ Align:"Left",	Width:250,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",	Header:"최저가 배제 사유|최저가 배제 사유",		SaveName:"BID_SUCCESS_REASON",				ColMerge:0}
];
	
// 	var info = [ {StdCol:"TEAM_NM", SumCols:"RE_CNT|TOT_QTY|LOW_AMT|BUY_AMT|DIF_AMT", CaptionCol:"GUBUN", ShowCumulate:0, CaptionText:"- 소 계 -"} ];	
// 	mySheet.ShowSubSum(info);
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	
	//var cfg = {MergeSheet:msAll};
	var cfg = {MergeSheet:msPrevColumnMerge + msHeaderOnly};
	mySheet.SetConfig(cfg);
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	
	// 사업팀 콤보박스
	kepAjaxCommonQueryIdCombo('st_dept','master.mdcd.selectMasterMdCdBuyerCardManageDeptList99','ALL','');
	
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(0);
	
	var st_from_date = "<%=_stFromDate%>";
	var st_to_date = "<%=_stToDate%>";
	
	// 조회조건 일자 초기화
	kepSetCalenderYearMonth("st_from_date");
	kepSetCalenderYearMonth("st_to_date");
	
	// 조회조건 일자 설정
	if ( st_from_date == '' ) {
		$("#st_from_date").val( kepGetNowTimeStr('YYYYMM','/') );
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMM','/') );
	} else {
		$("#st_from_date").val( st_from_date );
		$("#st_to_date").val( st_to_date );
	}
}

// 기능함수
function doAction(str) {
	switch (str) {
	case "search":	 // 조회
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		if (kepGetDateDiff('st_from_date','st_to_date','M') > 12.1 ){
			alert("최대 1년까지만 조회가 가능합니다.");
			return;
		}
		if($("#st_buyer").val() == ""){ //고객사를 선택 안하면 부서를 선택해야함(고객사 선택하면 부서는 전체 가능)
			if($("#st_dept").val() == ""){
				alert("부서를 선택해 주십시요.");
				return;
			}
		}
		if($("#st_buyer").val() != ""){
			if (kepGetDateDiff('st_from_date','st_to_date','M') > 1 ){
				alert("고객사를 선택하는 경우 조회기간이 2개월 이하여야 합니다.");
				return;
			}
		}
		
		IBS_SaveName(document.searchCondition,mySheet);
		//조회조건 묶기
		var param = FormQueryStringEnc2(document.searchCondition);
		//조회
		mySheet.DoSearch("/mpst/getMasterMpStQuotExceptionDetailList.do", param);
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		$("#st_from_date").val( kepGetNowTimeStr('YYYYMM','/') );
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMM','/') );
		$("#st_buyer").val("");
		$("#st_buyer_name").val("");
		break;
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
	}
} 
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	
	if(!checkedSession(stCode)){
		return;
		}	

	if (msg != ""){
		alert(msg);
	}
	
	// 합계 행 다듬기
	mySheet.SetSumValue(0, "- 합 계 -");
	mySheet.SetMergeCell(mySheet.LastRow(), 0, 1, 8);
	mySheet.SetCellAlign(mySheet.LastRow(), 0, "Center");
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	
	if(!checkedSession(stCode)){
		return;
	}
	
	if (msg != ""){
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

function mySheet_OnDownFinish(downloadType, result){
	loader_obj("N");
}
//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer": // 고객사 M
			openSearchPopup("/common/safetyCompanyCodePop.do", "?COM_TYPE=B", "880,450,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer") {	// 구매회원사
		$("#st_buyer").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	}
	
	grbRow="";	//초기화
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA">
			<h3>견적 최저가 예외 상세</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
        	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span> 
   		</div>        	
        <!--조회영역-->
       	<form id = "searchCondition" name = "searchCondition" method = "post">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>견적 최저가 예외 상세</caption>
					<colgroup>
						<col width="30px" />
						<col width="25%" />
						<col width="20px" />
						<col width="30px" />
						<col width="25%" />
						<col width="30px" />
						<col width="25%" />
					</colgroup>
					<tbody>
					<tr>
						<th>조회기간</th>
						<td>
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
							-
							<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
						</td>
						<th></th>
						<th>팀명</th>
						<td>
							<select id="st_dept" name="st_dept" style="width:120px; height:20px"></select>
						</td>
						<th>고객사</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:70%;" value = "" READONLY>
							<input type="hidden" name="st_buyer" id="st_buyer" style="width:100px;" value ="">
							<a href="javascript:doPop('buyer');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
					</tr>
					</tbody>
				</table>
            </div>
			<br>
		</form>

      	<!--grid-->
      	<div class="ib_product" style="border-top:2px solid #3c639c">
	      	<script type="text/javascript">
	      	createIBSheet("mySheet", "100%", "340px");
			</script>
		</div>
<!--내용 종료-->	                 
</body>
</html>
