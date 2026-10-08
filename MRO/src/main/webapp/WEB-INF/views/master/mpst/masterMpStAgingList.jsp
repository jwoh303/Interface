<%--
**********************************************
* 메뉴 : 재고현황 모니터링 > 재고현황관리 > 재고현황 추이
* 화면 : 재고현황 추이
* 기능 :
* 프로그램 ID : 
* 담당자 : 한승준 ( 설계 : 김승우 )
* 착수일 : 2015-11-12
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
	 	 { Align:"Center",	Width:60,	Edit:false,	EditLen:20,		Hidden:false,	ColMerge:0, Type:"Text",	Header:"사이트|사이트",		SaveName:"SITE_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:20,		Hidden:true,	ColMerge:0, Type:"Text",	Header:"사이트|사이트",		SaveName:"SITE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:20,		Hidden:false,	ColMerge:0, Type:"Text",	Header:"기준년월|기준년월",	SaveName:"YYYYMM"}
		,{ Align:"left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:0, Type:"Text",	Header:"상품분류|상품분류",	SaveName:"CATEGORY_NAME"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:20,		Hidden:false,	ColMerge:0, Type:"Text",	Header:"상품코드|상품코드",	SaveName:"ITEM_NO"}
		,{ Align:"left",	Width:220,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:0, Type:"Text",	Header:"상품명|상품명",		SaveName:"DESCRIPTION"}
		,{ Align:"left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:0, Type:"Text",	Header:"규격|규격",		SaveName:"SPECIFICATION"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:0, Type:"Text",	Header:"제조사|제조사",		SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:0, Type:"Text",	Header:"단위|단위",		SaveName:"UNIT_MEASURE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:0, Type:"Text",	Header:"담당팀|담당팀",		SaveName:"DEPT_NAME"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:0, Type:"Text",	Header:"담당센터|담당센터",		SaveName:"WAREHOUSE_NAME"}
		,{ Align:"right",	Width:60,	Edit:false,	EditLen:20,		ColMerge:0, Type:"Float",	Header:"재고|단가",		SaveName:"STOCK_PRICE"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:20,		ColMerge:0, Type:"AutoSum",	Header:"재고|수량",		SaveName:"STOCK_QTY"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:20,		ColMerge:0, Type:"AutoSum",	Header:"재고|금액",		SaveName:"STOCK_AMT"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:20,		ColMerge:0, Type:"AutoSum",	Header:"1~3개월|수량",		SaveName:"PRD_QTY_1"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:20,		ColMerge:0, Type:"AutoSum",	Header:"1~3개월|금액",		SaveName:"PRD_AMT_1"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:20,		ColMerge:0, Type:"AutoSum",	Header:"4~6개월|수량",		SaveName:"PRD_QTY_2"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:20,		ColMerge:0, Type:"AutoSum",	Header:"4~6개월|금액",		SaveName:"PRD_AMT_2"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:20,		ColMerge:0, Type:"AutoSum",	Header:"7~12개월|수량",	SaveName:"PRD_QTY_3"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:20,		ColMerge:0, Type:"AutoSum",	Header:"7~12개월|금액",	SaveName:"PRD_AMT_3"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:20,		ColMerge:0, Type:"AutoSum",	Header:"1~2년|수량",		SaveName:"PRD_QTY_4"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:20,		ColMerge:0, Type:"AutoSum",	Header:"1~2년|금액",		SaveName:"PRD_AMT_4"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:20,		ColMerge:0, Type:"AutoSum",	Header:"2년초과|수량",		SaveName:"PRD_QTY_5"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:20,		ColMerge:0, Type:"AutoSum",	Header:"2년초과|금액",		SaveName:"PRD_AMT_5"}
];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:2};
	
	var info = [ {StdCol:"SITE_NAME", SumCols:"STOCK_QTY|STOCK_AMT|PRD_QTY_1|PRD_AMT_1|PRD_QTY_2|PRD_AMT_2|PRD_QTY_3|PRD_AMT_3|PRD_QTY_4|PRD_AMT_4|PRD_QTY_5|PRD_AMT_5",
		CaptionCol:"SITE_NAME", ShowCumulate:0, CaptionText:"- 소 계 -"} ];
	
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	var cfg = {MergeSheet:msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	mySheet.ShowSubSum(info);
	
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(0);
	
	setLinkCol(mySheet, "ITEM_NO");	//발주번호

	var st_from_date = "<%=_stFromDate%>";
	
	// 조회조건 일자 초기화
	kepSetCalenderYearMonth("st_from_date");
	
	// 조회조건 일자 설정
	if ( st_from_date == '' ) {
		$("#st_from_date").val( kepGetNowTimeStr('YYYYMM','/') );
	} else {
		$("#st_from_date").val( st_from_date );
	}
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
		mySheet.DoSearch("/mpst/getMasterMpStAgingList.do", param);
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		break;


	case "excelDown": // 엑셀다운로드
	
	    $("#pageflag").val('0');

	    var downCol = "";
		for(var i=0;i<=mySheet.LastCol();i++){
			if(!mySheet.GetColHidden(i) && mySheet.ColSaveName(i) !="SELECTED"){
				downCol += "|"+i;	
			}
		}
		
		var param = {FileName:"재고에이징.xlsx",DownCols:downCol.substring(1)};

		kepDownExcel(document.searchCondition ,mySheet , "/mpst/excelMasterMpStAgingList.do", param);
		$("#pageflag").val('1');
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
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if ( column == "ITEM_NO") {
		var	site_code	= mySheet.GetCellValue(Row,"SITE");
		var	yyyymm		= mySheet.GetCellValue(Row,"YYYYMM");
		var item_no		= mySheet.GetCellValue(Row,"ITEM_NO");
		openSearchPopup('/mpst/getMasterMpStAgingPopup.do','?st_site='+site_code+'&st_item_no='+item_no+'&st_yyyymm='+yyyymm , "450,700,no");
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
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA">
			<h3>재고 에이징</h3>
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
            	<table  class="cont_t_list01" >
					<caption>재고 에이징</caption>
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
						<th>시스템</th>
						<td>
							<select id="st_site" name="st_site">
								<option value="ALL">전체</option>
								<option value="WM">WMS</option>
								<option value="KW">KWAY</option>
								<option value="IT">ITWAY</option>
								<option value="SA">건설MRO</option>
							</select>
						</td>
						<th>기준년월</th>
						<td>
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
						</td>
						<th>자재코드</th>
						<td>
							<input type="text" class="input_type_text" name="st_item_no" id="st_item_no">
						</td>
					</tr>
					</tbody>
				</table>
            </div>
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="50" selected>50건</option>
					<option value="100">100건</option>
					<option value="500">500건</option>
					<option value="1000">1000건</option>
				</select>
				<label for="b_no02" ></label>
			</span>
            
			<br>
		</form>

      	<!--grid-->
      	<div class="ib_product" style="border-top:2px solid #3c639c">
	      	<script type="text/javascript">
	      	createIBSheet("mySheet", "100%", "300px");
			</script>
		</div>
  		<p class="paging" id="pageindex"></p>
  			
  		<!--버튼영역-->
        <div class="btnArea">
  	    	<span class="fl">
<!--   				<span class="btn_05 mr04" style="display:"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span> -->
  			</span>
  		</div>
<!--내용 종료-->	                 
</body>
</html>
