<%--
**********************************************
* 메뉴 : 재고현황 모니터링 > 재고에이징 상세(입고)
* 화면 : 재고에이징 상세(입고)
* 기능 :
* 프로그램 ID : 
* 담당자 : 한승준 ( 설계 : 김승우 )
* 착수일 : 2016-09-27
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ include file="../../common/include/head.jspf"  %>
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
					{ Align:"Center",	Width:60,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",	Header:"조회년월",		SaveName:"YYYYMM",			ColMerge:0}
	              	,{ Align:"Center",	Width:120,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",	Header:"팀명",		SaveName:"KEP_DEPT_NAME",	ColMerge:0}
	              	,{ Align:"left",	Width:100,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",	Header:"카테고리명"	,	SaveName:"CATEG_NAME",		ColMerge:0}
	              	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",	Header:"자재코드",		SaveName:"ITEM_NO",			ColMerge:0}
	              	,{ Align:"left",	Width:160,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",	Header:"품명",		SaveName:"DESCRIPTION",		ColMerge:0}
	              	,{ Align:"left",	Width:160,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",	Header:"규격",		SaveName:"SPECIFICATION",	ColMerge:0}
	              	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",	Header:"단위",		SaveName:"UNIT_MEASURE",	ColMerge:0}
	              	,{ Align:"left",	Width:120,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",	Header:"제조사",		SaveName:"MAKER_NAME",		ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"단가",		SaveName:"STOCK_PRICE",		ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"재고수량",		SaveName:"STOCK_QTY",		ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"1M 이하",		SaveName:"D01_QTY",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"2M 이하",		SaveName:"D02_QTY",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"3M 이하",		SaveName:"D03_QTY",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"4M 이하",		SaveName:"D04_QTY",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"5M 이하",		SaveName:"D05_QTY",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"6M 이하",		SaveName:"D06_QTY",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"7M 이하",		SaveName:"D07_QTY",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"8M 이하",		SaveName:"D08_QTY",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"9M 이하",		SaveName:"D09_QTY",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"10M 이하",	SaveName:"D10_QTY",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"11M 이하",	SaveName:"D11_QTY",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"12M 이하",	SaveName:"D12_QTY",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"12M 초과",	SaveName:"ETC_QTY",			ColMerge:0}
];
	
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:0};

	var cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	
	kepAjaxCommonQueryIdCombo('st_dept_code','master.mdcd.selectMasterMdCdBuyerCardManageDeptList99','ALL', '');
	
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(4);
	
	// 조회조건 일자 초기화
	kepSetCalenderYearMonth("st_from_date");
	
	// 조회조건 일자 설정
	$("#st_from_date").val( kepGetNowTimeStr('YYYYMM','/') );
}
// 기능함수
function doAction(str) {
	switch (str) {
	case "search":	 // 조회
		//kepSearch()
		IBS_SaveName(document.searchCondition,mySheet);
		//조회조건 묶기
		var param = FormQueryStringEnc2(document.searchCondition);
		//조회
		mySheet.DoSearch("/mpst/getMasterMpStAgingGrDtList.do", param);
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		
		// 조회조건 일자 초기화
		kepSetCalenderYearMonth("st_from_date");
		
		// 조회조건 일자 설정
		$("#st_from_date").val( kepGetNowTimeStr('YYYYMM','/') );
		
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

</script>
</head>
<body onload="kep_onload_view(); doAction('search');">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>재고에이징 상세(입고)</h3>
			(단위 : EA)
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
        	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>  
   		</div>        	
        <!--조회영역-->
       	<form id = "searchCondition" name = "searchCondition" method = "post" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<!-- 화면 내 정의 -->
            	<table  class="cont_t_list01" >
					<caption>재고에이징 상세(입고)</caption>
					<colgroup>
						<col width="8px" />
						<col width="25%" />
						<col width="8px" />
						<col width="25%" />
						<col width="8px" />
						<col width="25%" />
					</colgroup>
					<tbody>
					<tr>
						<th>조회년월</th>
						<td>
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
						</td>
						<th>팀명</th>
						<td>
							<select id="st_dept_code" name="st_dept_code" style="width:150px;">
							</select>
						</td>
						<th>자재코드</th>
						<td>
							<input type="text" class="input_type_text" name="st_item_no" id="st_item_no" style="width:60%; text-align:left;" value="" onKeyDown="kepEnter()">
						</td>
					</tr>
					</tbody>
				</table>
            </div>
		</form>

      	<!--grid-->
      	<div class="ib_product" style="border-top:2px solid #3c639c">
	      	<script type="text/javascript">
	      	createIBSheet("mySheet", "100%", "500px");
			</script>
		</div>

<!--내용 종료-->	                 
</body>
</html>
