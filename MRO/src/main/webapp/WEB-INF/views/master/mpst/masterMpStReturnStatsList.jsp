<%--
**********************************************
* 메뉴 : 통계 > 기타통계 > 반품통계
* 화면 : 반품통계
* 기능 :
* 프로그램 ID : 
* 담당자 : HSJ ( 설계 : 전략기획팀 )
* 착수일 : 2016-11-25
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
var mySheet2 = new ibsheetObject();
var mySheet3 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
					{ Align:"Center",	Width:60,	Edit:false,	EditLen:110,	Hidden:true,	Type:"Text",			Header:"발주년월",		SaveName:"YYYYMM",					ColMerge:1}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",			Header:"구분",				SaveName:"WMRE_TYPE2",			ColMerge:1}
	                ,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"구분",				SaveName:"WMRE_TYPE2_NAME",	ColMerge:1}
	              	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:110,	Hidden:true,	Type:"Text",			Header:"반품원인",		SaveName:"WMRE_TYPE3",			ColMerge:0}
	              	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",			Header:"반품원인",		SaveName:"WMRE_TYPE3_NAME",	ColMerge:0}
	              	,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",			Header:"전체건수",		SaveName:"TOT_WMRE_CNT",		ColMerge:1}
	              	,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"반품건수",		SaveName:"WMRE_CNT",				ColMerge:0}
					,{ Align:"right",	Width:90,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"반품금액",		SaveName:"WMRE_AMT",				ColMerge:0}
					,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",			Header:"비중(%)",		SaveName:"RATE",						ColMerge:0}
	];
	
	initsheet.HeaderMode = {Sort:1,ColMove:0,ColResize:0};
	
	var cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	
	IBS_InitSheet(mySheet, initsheet, pagingMode, 'XLS');
	
	var initsheet2 = {};
	initsheet2.Cols = [
					{ Align:"Center",	Width:60,	Edit:false,	EditLen:110,	Hidden:true,	Type:"Text",			Header:"발주년월",		SaveName:"YYYYMM",				ColMerge:0}
	              	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:110,	Hidden:true,	Type:"Text",			Header:"고객사코드",	SaveName:"COM_CODE",			ColMerge:0}
	              	,{ Align:"left",		Width:150,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",			Header:"고객사명",		SaveName:"COM_NAME",			ColMerge:0}
	              	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:110,	Hidden:true,	Type:"Text",			Header:"사업팀코드",	SaveName:"KEP_DEPT",				ColMerge:0}
	              	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",			Header:"사업팀명",		SaveName:"KEP_DEPT_NAME",	ColMerge:0}
	              	,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",			Header:"발주건수",		SaveName:"PO_CNT",				ColMerge:0}
	              	,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",			Header:"반품건수",		SaveName:"WMRE_CNT",			ColMerge:0}
	              	,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",			Header:"건수비중(%)",	SaveName:"CNT_RATE",			ColMerge:0}
	              	,{ Align:"right",	Width:90,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"발주금액",		SaveName:"PO_AMT",				ColMerge:0}
					,{ Align:"right",	Width:90,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"반품금액",		SaveName:"WMRE_AMT",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",			Header:"금액비중(%)",	SaveName:"AMT_RATE",			ColMerge:0}
	];
	
	initsheet2.HeaderMode = {Sort:1,ColMove:0,ColResize:0};
	
	IBS_InitSheet(mySheet2, initsheet2, pagingMode, 'XLS');
	
	var initsheet3 = {};
	initsheet3.Cols = [
					{ Align:"Center",	Width:60,	Edit:false,	EditLen:110,	Hidden:true,	Type:"Text",			Header:"발주년월",		SaveName:"YYYYMM",				ColMerge:0}
	              	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:110,	Hidden:true,	Type:"Text",			Header:"협력사코드",	SaveName:"COM_CODE",			ColMerge:0}
	              	,{ Align:"left",		Width:130,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",			Header:"협력사명",		SaveName:"COM_NAME",			ColMerge:0}
	              	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:110,	Hidden:true,	Type:"Text",			Header:"사업팀코드",	SaveName:"KEP_DEPT",				ColMerge:0}
	              	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",			Header:"사업팀명",		SaveName:"KEP_DEPT_NAME",	ColMerge:0}
	              	,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",			Header:"발주건수",		SaveName:"PO_CNT",				ColMerge:0}
	              	,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",			Header:"반품건수",		SaveName:"WMRE_CNT",			ColMerge:0}
	              	,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",			Header:"건수비중(%)",	SaveName:"CNT_RATE",			ColMerge:0}
	              	,{ Align:"right",	Width:90,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"발주금액",		SaveName:"PO_AMT",				ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"반품금액",		SaveName:"WMRE_AMT",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",			Header:"금액비중(%)",	SaveName:"AMT_RATE",			ColMerge:0}
	];
	
	initsheet3.HeaderMode = {Sort:1,ColMove:0,ColResize:0};
	
	IBS_InitSheet(mySheet3, initsheet3, pagingMode, 'XLS');
	
	kepAjaxCommonQueryIdCombo('st_dept_code','master.mdcd.selectMasterMdCdBuyerCardManageDeptList99','ALL', '');
	
	// 조회조건 일자 초기화
	kepSetCalenderYearMonth("st_from_date");
	
	// 조회조건 일자 설정
	$("#st_from_date").val( kepGetNowTimeStr('YYYYMM','/') );
	
	doAction("search");
}

function myChart_init(){
	myChart.SetOptions({
		Chart:{
			Type:"pie",
			BorderWidth:0
		},
		Title:{
			Text:"고객사 반품원인 현황",
			Style:{
				Color:"#15498B",
				FontFamily:"Dotum",
				FontWeight:"bold"
			}
		},
		ToolTip:{
			Enabled:false
		},
		plotOptions:{
			Pie:{
				StartAngle : 0,
				Size : "75%",
				dataLabels: {
	                enabled: true,
	                distance: 10,				//파이 영역위에 레이블 표시
	                formatter:function(){			//레이블 표시 방식 (시리즈 색상: 시리즈명 /n 포인트명: 포인트값)
	                	return this.point.name+" : "+this.y+"%";
	                }
	            }
			}
		},
        legend: {
            align: 'right',
            verticalAlign: 'middle',
            layout: 'vertical'
        },
	});
	
	myChart1.SetOptions({
		Chart:{
			Type:"pie",
			BorderWidth:0
		},
		Title:{
			Text:"협력사 반품원인 현황",
			Style:{
				Color:"#15498B",
				FontFamily:"Dotum",
				FontWeight:"bold"
			}
		},
		ToolTip:{
			Enabled:false,
		},
		plotOptions:{
			Pie:{
				StartAngle:0,
				Size : "75%",
				dataLabels: {
	                enabled: true,
	                distance: 10,				//파이 영역위에 레이블 표시
	                formatter:function(){			//레이블 표시 방식 (시리즈 색상: 시리즈명 /n 포인트명: 포인트값)
	                	return this.point.name+" : "+this.y+"%";
	                }
	            }
			}
		},
		legend: {
            align: 'right',
            verticalAlign: 'middle',
            layout: 'vertical'
        },
	});
	
	/* 아이비리더스 가이드(Pie 차트 버그) - 범례 클릭 사용하지 않기 위함(버그로 인한 의미없는 그리기 호출하기) */
	myChart.Draw(function(){
		myChart.SetPlotOptions({
			Pie:{
				animation:true
			}
		},1);
		setTimeout(function(){ myChart.Draw(); } , 10);
	});
	
	myChart1.Draw(function(){
		myChart1.SetPlotOptions({
			Pie:{
				animation:true
			}
		},1);
		setTimeout(function(){ myChart1.Draw(); } , 10);
	});
	
	createData_myChart();
	myChart.Draw();
	
	createData_myChart1();
	myChart1.Draw();
}

function createData_myChart(){
	var maxRow = mySheet.RowCount() + 1; // 그리드 row 1부터 시작
	var name = "";
	var rate = "";
	
	var teamOne = myChart.CreateSeries();
	var thisPoints = [];
	
	// 차트에 사용할 데이터 - 고객사
	for(var i=1; i < maxRow; i++){
		if(mySheet.GetCellValue(i, "WMRE_TYPE2") == "01"){
			rate = mySheet.GetCellValue(i,"RATE");
			name = mySheet.GetCellValue(i,"WMRE_TYPE3_NAME");
			
			if(rate > 0){
				thisPoints.push({"Name":name, "Y":rate});				
			}
		}
	}
	
	teamOne.AddPoints(thisPoints);
	myChart.AddSeries(teamOne);
}

function createData_myChart1(){
	var maxRow = mySheet.RowCount() + 1; // 그리드 row 1부터 시작
	var name = "";
	var rate = "";
	
	var teamOne = myChart1.CreateSeries();
	var thisPoints = [];
	
	// 차트에 사용할 데이터 - 고객사
	for(var i=1; i < maxRow; i++){
		if(mySheet.GetCellValue(i, "WMRE_TYPE2") == "02"){
			rate = mySheet.GetCellValue(i,"RATE");
			name = mySheet.GetCellValue(i,"WMRE_TYPE3_NAME");

			if(rate > 0){
				thisPoints.push({"Name":name, "Y":rate});				
			}
		}
	}
	
	teamOne.AddPoints(thisPoints);
	myChart1.AddSeries(teamOne);
}

// 기능함수
function doAction(str) {
	switch (str) {
	case "search":	 // 조회
		kepSearchNoBar(document.searchCondition,  mySheet , "/mpst/getMasterMpStReturnStatsList.do" , pagingMode);
		kepSearchNoBar(document.searchCondition,  mySheet2 , "/mpst/getMasterMpStReturnStatsBuyerList.do" , pagingMode);
		kepSearchNoBar(document.searchCondition,  mySheet3 , "/mpst/getMasterMpStReturnStatsAgentList.do" , pagingMode);
		
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		
		mySheet.RemoveAll();
		mySheet2.RemoveAll();
		mySheet3.RemoveAll();
		
		myChart.RemoveAll();
		myChart1.RemoveAll();
		
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

//그리드 표시후 처리	 
function mySheet2_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

//그리드 표시후 처리	 
function mySheet3_OnLoadData(DATA) {
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
	mySheet.SetMergeCell(mySheet.LastRow(), 2, 1, 3);
	mySheet.SetSumValue(2, "- 합 계 -");
	mySheet.SetCellAlign(mySheet.LastRow(), 2, "Center");
	
	// 조회 데이터를 기반으로 차트 그리기
	myChart_init();
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

/* 아이비리더스 가이드(Pie 차트 버그) - 범례 클릭 사용하지 않기 위함 */
function myChart_OnLegendItemClick(Index, Name) {
    return false;
}
function myChart1_OnLegendItemClick(Index, Name) {
    return false;
}

function mySheet_OnDownFinish(downloadType, result){
	loader_obj("N");
}

function mySheet2_OnDownFinish(downloadType, result){
	loader_obj("N");
}

function mySheet3_OnDownFinish(downloadType, result){
	loader_obj("N");
}

</script>
</head>
<body onload="kep_onload_view();">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>반품통계</h3>
			(단위 : 원)
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
					<caption>반품통계</caption>
					<colgroup>
						<col width="30px" />
						<col width="300px" />
						<col width="30px" />
						<col width="150px" />
					</colgroup>
					<tbody>
					<tr>
						<th>발주년월</th>
						<td>
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
							<b> - 데이터 집계는 전일 기준으로 집계 (유효데이터 : 2016년 11월 이후)</b>
						</td>

						<th>사업팀</th>
						<td>
							<select id="st_dept_code" name="st_dept_code" style="width:150px;">
							</select>
						</td>
					</tr>
					</tbody>
				</table>
            </div>
		</form>

      	<!--grid-->
      	<div class="ib_product" style="border-top:2px solid #3c639c">
			<table width="100%" height="300px">
				<tr>
	     			<td width="740px" style="vertical-align:top">
		         		<div class="text11">고객사 반품 현황</div>
		            	<script type="text/javascript">
		            		createIBSheet("mySheet2", "", "240px");
		            	</script>
	        		</td>
	        
	        		<td width="*" style="vertical-align:top">
	         			<div class="text11">협력사 반품 현황</div>
	            		<script type="text/javascript">
	            			createIBSheet("mySheet3", "", "240px");
	            		</script> 
	        		</td>
    			</tr>
			</table>

			<table width="100%" height="320px"	>
				<tr>
					<td width="32%" style="vertical-align:top">
						<div class="text11">전체 반품 현황</div>
						<script type="text/javascript">
				      		createIBSheet("mySheet", "", "260px");
						</script>
					</td>
					
					<td width="850px">
						<table width="850px">
							<tr>
								<td width="50%">
	         						<script type="text/javascript">
										createIBChart("myChart", "100%", "280px");
					                </script>
	         					</td>
	         					<td width="50%">
	         						<script type="text/javascript">
										createIBChart("myChart1", "100%", "280px");
					                </script>
	         					</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>		
<!--내용 종료-->	                 
</body>
</html>
