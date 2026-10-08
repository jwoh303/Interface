<%--
**********************************************
* 메뉴 : 단가 조정통계 > 발주 단가조정 현황
* 화면 : 발주 단가조정 현황
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
	              	 { Align:"Center",	Width:120,	Edit:false,	EditLen:70,		Hidden:false,	Type:"Text",			Header:"구분|구분",	SaveName:"TEAM_NAME",			ColMerge:1}
	              	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:70,		Hidden:false,	Type:"Text",			Header:"구분|구분",		SaveName:"UP_DOWN",			ColMerge:0}
	              	,{ Align:"right",	Width:80,	Edit:false,	EditLen:70,		Hidden:false,	Type:"AutoSum",			Header:"건수|건수",		SaveName:"PO_CNT",			ColMerge:0}
	              	,{ Align:"right",	Width:80,	Edit:false,	EditLen:110,	Hidden:false,	Type:"AutoSum",			Header:"수량|수량",		SaveName:"TOT_QTY",					ColMerge:0}	              	
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"금액|조정 전 금액",	SaveName:"BEFOR_AMT",			ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"금액|조정 후 금액",	SaveName:"CURRENT_AMT",			ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"금액|증감액",	SaveName:"DIF_AMT",					ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",	Header:"증감율(%)|증감율(%)",		SaveName:"AMT_RATE",				ColMerge:0}
					
];
	
	var info = [ {StdCol:"TEAM_NAME", SumCols:"PO_CNT|TOT_QTY|BEFOR_AMT|CURRENT_AMT|DIF_AMT", CaptionCol:"UP_DOWN", ShowCumulate:0, CaptionText:"- 소 계 -"} ];	
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	
	//var cfg = {MergeSheet:msAll};
	var cfg = {MergeSheet:msPrevColumnMerge + msHeaderOnly};
	mySheet.SetConfig(cfg);
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	mySheet.ShowSubSum(info);
	
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
		
		IBS_SaveName(document.searchCondition,mySheet);
		//조회조건 묶기
		var param = FormQueryStringEnc2(document.searchCondition);
		//조회
		mySheet.DoSearch("/mpst/getMasterMpStPoPriceAdjustList.do", param);
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		$("#st_from_date").val( kepGetNowTimeStr('YYYYMM','/') );
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMM','/') );
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
	mySheet.SetSumValue(1, "- 합 계 -");
	mySheet.SetMergeCell(mySheet.LastRow(), 0, 1, 1);
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

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA">
			<h3>발주 단가조정 현황</h3>
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
					<caption>발주 단가조정 현황</caption>
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
						<th></th>
						<td></td>
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
