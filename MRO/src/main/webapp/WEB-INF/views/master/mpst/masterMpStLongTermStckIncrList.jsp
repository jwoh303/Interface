<%--
**********************************************
* 메뉴 : 재고현황 모니터링 > 장기재고 증감현황
* 화면 : 장기재고 증감현황
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
					{ Align:"Center",	Width:100,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",			Header:"조회년월|조회년월",	SaveName:"YYYYMM",				ColMerge:1}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",			Header:"구분|사업코드",		SaveName:"SITE",						ColMerge:0}
	                ,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"구분|사업구분",		SaveName:"SITE_NAME",			ColMerge:1}
	              	,{ Align:"Center",	Width:120,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",			Header:"구분|팀구분",			SaveName:"KEP_DEPT_NAME",	ColMerge:1}
	              	,{ Align:"Center",	Width:160,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",			Header:"구분|제품분류",		SaveName:"ITEM_TYPE",			ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"조회전월(A)|수량",	SaveName:"BF_M_STOCK_QTY",	ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"조회전월(A)|금액",	SaveName:"BF_M_STOCK_AMT",	ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"조회당월(B)|수량",	SaveName:"STOCK_QTY",			ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"조회당월(B)|금액",	SaveName:"STOCK_AMT",			ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"증감(B-A)|수량",		SaveName:"INCR_QTY",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"증감(B-A)|금액",		SaveName:"INCR_AMT",			ColMerge:0}
];
	
	var info = [ {StdCol:"SITE", SumCols:"BF_M_STOCK_QTY|BF_M_STOCK_AMT|STOCK_QTY|STOCK_AMT|INCR_QTY|INCR_AMT",
		CaptionCol:"SITE_NAME", ShowCumulate:0, CaptionText:"- 소     계 -"} ];
	
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:0};

	var cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	mySheet.ShowSubSum(info);
	
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(0);
	
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
		mySheet.DoSearch("/mpst/getMasterMpStLongTermStckIncrList.do", param);
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
	
	// 합계 행 다듬기
	mySheet.SetSumValue(1, "- 합     계 -");
	mySheet.SetMergeCell (mySheet.LastRow(), 1, 1, 3);
	mySheet.SetCellAlign(mySheet.LastRow(), 1, "Center");
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
			<h3>장기재고 증감현황</h3>
			(단위 : EA, 백만원)
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
					<caption>장기재고 증감현황</caption>
					<colgroup>
						<col width="30px" />
						<col width="25%" />
						<col width="30px" />
						<col width="25%" />
						<col width="30px" />
						<col width="25%" />
					</colgroup>
					<tbody>
					<tr>
						<th>조회년월</th>
						<td>
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
						</td>
						<th></th>
						<td></td>
						<th></th>
						<td></td>
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
