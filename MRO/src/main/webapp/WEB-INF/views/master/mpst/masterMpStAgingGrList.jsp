<%--
**********************************************
* 메뉴 : 재고현황 모니터링 > 재고에이징(입고)
* 화면 : 재고에이징(입고)
* 기능 :
* 프로그램 ID : 
* 담당자 : 한승준 ( 설계 : 김승우 )
* 착수일 : 2016-09-26
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
					{ Align:"Center",	Width:80,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",			Header:"조회년월",		SaveName:"YYYYMM",				ColMerge:1}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",			Header:"구분",				SaveName:"SITE",						ColMerge:1}
	                ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"구분",				SaveName:"SITE_NAME",			ColMerge:1}
	              	,{ Align:"Center",	Width:140,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",			Header:"구분",				SaveName:"KEP_DEPT_NAME",	ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"1M 이하",		SaveName:"D01_AMT",				ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"2M 이하",		SaveName:"D02_AMT",				ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"3M 이하",		SaveName:"D03_AMT",				ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"4M 이하",		SaveName:"D04_AMT",				ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"5M 이하",		SaveName:"D05_AMT",				ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"6M 이하",		SaveName:"D06_AMT",				ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"7M 이하",		SaveName:"D07_AMT",				ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"8M 이하",		SaveName:"D08_AMT",				ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"9M 이하",		SaveName:"D09_AMT",				ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"10M 이하",		SaveName:"D10_AMT",				ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"11M 이하",		SaveName:"D11_AMT",				ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"12M 이하",		SaveName:"D12_AMT",				ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"12M 초과",		SaveName:"ETC_AMT",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"조회당월(A)",	SaveName:"STOCK_AMT",			ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"조회전월(B)",	SaveName:"BF_M_STOCK_AMT",	ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"증감(A-B)",		SaveName:"INCR",					ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"증감율(%)",		SaveName:"INCR_RATE",			ColMerge:0}
];
	
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:0};
	
	var cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(0);
	
	// 조회조건 일자 초기화
	kepSetCalenderYearMonth("st_from_date");
	
	// 조회조건 일자 설정
	$("#st_from_date").val( kepGetNowTimeStr('YYYYMM','/') );
}

function myChart_init(){
	var maxRow = mySheet.RowCount();
	var count = 0;
	
	var kw_do1_amt = 0;
	var kw_do2_amt = 0;
	var kw_do3_amt = 0;
	var kw_do4_amt = 0;
	var kw_do5_amt = 0;
	var kw_do6_amt = 0;
	var kw_do7_amt = 0;
	var kw_do8_amt = 0;
	var kw_do9_amt = 0;
	var kw_do10_amt = 0;
	var kw_do11_amt = 0;
	var kw_do12_amt = 0;
	var kw_etc_amt = 0;
	var kw_stock_amt = 0;
	
	// 차트에 사용할 데이터 - 유통 
	for(var i=1; i <= maxRow; i++){
		if(mySheet.GetCellValue(i, "SITE") == "KW"){
			kw_do1_amt = kw_do1_amt + mySheet.GetCellValue(i,"D01_AMT");
			kw_do2_amt = kw_do2_amt + mySheet.GetCellValue(i,"D02_AMT");
			kw_do3_amt = kw_do3_amt + mySheet.GetCellValue(i,"D03_AMT");
			kw_do4_amt = kw_do4_amt + mySheet.GetCellValue(i,"D04_AMT");
			kw_do5_amt = kw_do5_amt + mySheet.GetCellValue(i,"D05_AMT");
			kw_do6_amt = kw_do6_amt + mySheet.GetCellValue(i,"D06_AMT");
			kw_do7_amt = kw_do7_amt + mySheet.GetCellValue(i,"D07_AMT");
			kw_do8_amt = kw_do8_amt + mySheet.GetCellValue(i,"D08_AMT");
			kw_do9_amt = kw_do9_amt + mySheet.GetCellValue(i,"D09_AMT");
			kw_do10_amt = kw_do10_amt + mySheet.GetCellValue(i,"D10_AMT");
			kw_do11_amt = kw_do11_amt + mySheet.GetCellValue(i,"D11_AMT");
			kw_do12_amt = kw_do12_amt + mySheet.GetCellValue(i,"D12_AMT");
			kw_etc_amt = kw_etc_amt + mySheet.GetCellValue(i,"ETC_AMT");
			kw_stock_amt = kw_stock_amt + mySheet.GetCellValue(i,"STOCK_AMT");
		}
	}
	
	// 차트에 사용할 데이터 - %
	var kw_do1_per = Math.round(kw_do1_amt / kw_stock_amt * 100);
	var kw_do2_per = Math.round(kw_do2_amt / kw_stock_amt * 100);
	var kw_do3_per = Math.round(kw_do3_amt / kw_stock_amt * 100);
	var kw_do4_per = Math.round(kw_do4_amt / kw_stock_amt * 100);
	var kw_do5_per = Math.round(kw_do5_amt / kw_stock_amt * 100);
	var kw_do6_per = Math.round(kw_do6_amt / kw_stock_amt * 100);
	var kw_do7_per = Math.round(kw_do7_amt / kw_stock_amt * 100);
	var kw_do8_per = Math.round(kw_do8_amt / kw_stock_amt * 100);
	var kw_do9_per = Math.round(kw_do9_amt / kw_stock_amt * 100);
	var kw_do10_per = Math.round(kw_do10_amt / kw_stock_amt * 100);
	var kw_do11_per = Math.round(kw_do11_amt / kw_stock_amt * 100);
	var kw_do12_per = Math.round(kw_do12_amt / kw_stock_amt * 100);
	var kw_etc_per = Math.round(kw_etc_amt / kw_stock_amt * 100);
	
	myChart.SetOptions({
		Chart:{
			Type:"pie"
		},
		Title:{
			Text:"유통 Aging",
			Style:{
				Color:"#15498B",
				FontFamily:"Dotum",
				FontWeight:"bold"
			}
		},
		ToolTip:{
			Enabled:true,
			Shadow:true,
			Formatter:function(){
				if(this.point.name == "1M"){
					count	= kw_do1_amt;
				}else if(this.point.name == "2M"){
					count	= kw_do2_amt;
				}else if(this.point.name == "3M"){
					count	= kw_do3_amt;
				}else if(this.point.name == "4M"){
					count	= kw_do4_amt;
				}else if(this.point.name == "5M"){
					count	= kw_do5_amt;
				}else if(this.point.name == "6M"){
					count	= kw_do6_amt;
				}else if(this.point.name == "7M"){
					count	= kw_do7_amt;
				}else if(this.point.name == "8M"){
					count	= kw_do8_amt;
				}else if(this.point.name == "9M"){
					count	= kw_do9_amt;
				}else if(this.point.name == "10M"){
					count	= kw_do10_amt;
				}else if(this.point.name == "11M"){
					count	= kw_do11_amt;
				}else if(this.point.name == "12M"){
					count	= kw_do12_amt;
				}else if(this.point.name == "12M 초과"){
					count	= kw_etc_amt;
				}
				return '<span style="color: #4572A7;background-color:#FDFDFD">' +  this.point.name + '</span><br/>' + count;
			},
			Style:{
				Color:"#000000",
				FontSize:"12px",
				FontWeight:"bold"
			}
		},
		plotOptions:{
			Pie:{
				Center : ["60%", "50%"],
				StartAngle : 0,
				Size : 200,
				dataLabels: {
	                enabled: true,
	                //distance: -50,				//파이 영역위에 레이블 표시
	                formatter:function(){			//레이블 표시 방식 (시리즈 색상: 시리즈명 /n 포이트명: 포인트값)
	                	return this.point.name+" : "+this.y+"%";
	                }
	            }
			}
		},
		series: [{
            data: [
                ["1M", kw_do1_per],
                ["2M", kw_do2_per],
                ["3M", kw_do3_per],
                ["4M", kw_do4_per],
                ["5M", kw_do5_per],
                ["6M", kw_do6_per],
                ["7M", kw_do7_per],
                ["8M", kw_do8_per],
                ["9M", kw_do9_per],
                ["10M", kw_do10_per],
                ["11M", kw_do11_per],
                ["12M", kw_do12_per],
                ["12M 초과", kw_etc_per]
            ],
            showInLegend: true 
        }],
        legend: {
            align: 'right',
            verticalAlign: 'middle',
            layout: 'vertical'
        },
	});
	
	var wm_do1_amt = 0;
	var wm_do2_amt = 0;
	var wm_do3_amt = 0;
	var wm_do4_amt = 0;
	var wm_do5_amt = 0;
	var wm_do6_amt = 0;
	var wm_do7_amt = 0;
	var wm_do8_amt = 0;
	var wm_do9_amt = 0;
	var wm_do10_amt = 0;
	var wm_do11_amt = 0;
	var wm_do12_amt = 0;
	var wm_etc_amt = 0;
	var wm_stock_amt = 0;
	
	// 차트에 사용할 데이터 - 구매대행 
	for(var i=1; i <= maxRow; i++){
		if(mySheet.GetCellValue(i, "SITE") == "WM"){
			wm_do1_amt = wm_do1_amt + mySheet.GetCellValue(i,"D01_AMT");
			wm_do2_amt = wm_do2_amt + mySheet.GetCellValue(i,"D02_AMT");
			wm_do3_amt = wm_do3_amt + mySheet.GetCellValue(i,"D03_AMT");
			wm_do4_amt = wm_do4_amt + mySheet.GetCellValue(i,"D04_AMT");
			wm_do5_amt = wm_do5_amt + mySheet.GetCellValue(i,"D05_AMT");
			wm_do6_amt = wm_do6_amt + mySheet.GetCellValue(i,"D06_AMT");
			wm_do7_amt = wm_do7_amt + mySheet.GetCellValue(i,"D07_AMT");
			wm_do8_amt = wm_do8_amt + mySheet.GetCellValue(i,"D08_AMT");
			wm_do9_amt = wm_do9_amt + mySheet.GetCellValue(i,"D09_AMT");
			wm_do10_amt = wm_do10_amt + mySheet.GetCellValue(i,"D10_AMT");
			wm_do11_amt = wm_do11_amt + mySheet.GetCellValue(i,"D11_AMT");
			wm_do12_amt = wm_do12_amt + mySheet.GetCellValue(i,"D12_AMT");
			wm_etc_amt = wm_etc_amt + mySheet.GetCellValue(i,"ETC_AMT");
			wm_stock_amt = wm_stock_amt + mySheet.GetCellValue(i,"STOCK_AMT");
		}
	}
	
	// 차트에 사용할 데이터 - %
	var wm_do1_per = Math.round(wm_do1_amt / wm_stock_amt * 100);
	var wm_do2_per = Math.round(wm_do2_amt / wm_stock_amt * 100);
	var wm_do3_per = Math.round(wm_do3_amt / wm_stock_amt * 100);
	var wm_do4_per = Math.round(wm_do4_amt / wm_stock_amt * 100);
	var wm_do5_per = Math.round(wm_do5_amt / wm_stock_amt * 100);
	var wm_do6_per = Math.round(wm_do6_amt / wm_stock_amt * 100);
	var wm_do7_per = Math.round(wm_do7_amt / wm_stock_amt * 100);
	var wm_do8_per = Math.round(wm_do8_amt / wm_stock_amt * 100);
	var wm_do9_per = Math.round(wm_do9_amt / wm_stock_amt * 100);
	var wm_do10_per = Math.round(wm_do10_amt / wm_stock_amt * 100);
	var wm_do11_per = Math.round(wm_do11_amt / wm_stock_amt * 100);
	var wm_do12_per = Math.round(wm_do12_amt / wm_stock_amt * 100);
	var wm_etc_per = Math.round(wm_etc_amt / wm_stock_amt * 100);
	
	myChart1.SetOptions({
		Chart:{
			Type:"pie"
		},
		Title:{
			Text:"구매대행 Aging",
			Style:{
				Color:"#15498B",
				FontFamily:"Dotum",
				FontWeight:"bold"
			}
		},
		ToolTip:{
			Enabled:true,
			Shadow:true,
			Formatter:function(){
				if(this.point.name == "1M"){
					count	= wm_do1_amt;
				}else if(this.point.name == "2M"){
					count	= wm_do2_amt;
				}else if(this.point.name == "3M"){
					count	= wm_do3_amt;
				}else if(this.point.name == "4M"){
					count	= wm_do4_amt;
				}else if(this.point.name == "5M"){
					count	= wm_do5_amt;
				}else if(this.point.name == "6M"){
					count	= wm_do6_amt;
				}else if(this.point.name == "7M"){
					count	= wm_do7_amt;
				}else if(this.point.name == "8M"){
					count	= wm_do8_amt;
				}else if(this.point.name == "9M"){
					count	= wm_do9_amt;
				}else if(this.point.name == "10M"){
					count	= wm_do10_amt;
				}else if(this.point.name == "11M"){
					count	= wm_do11_amt;
				}else if(this.point.name == "12M"){
					count	= wm_do12_amt;
				}else if(this.point.name == "12M 초과"){
					count	= wm_etc_amt;
				}
				return '<span style="color: #4572A7;background-color:#FDFDFD">' +  this.point.name + '</span><br/>' + count;
			},
			Style:{
				Color:"#000000",
				FontSize:"12px",
				FontWeight:"bold"
			}
		},
		plotOptions:{
			Pie:{
				Center : ["60%", "50%"],
				StartAngle:0,
				Size : 200,
				dataLabels: {
	                enabled: true,
	                //distance: -50,				//파이 영역위에 레이블 표시
	                formatter:function(){			//레이블 표시 방식 (시리즈 색상: 시리즈명 /n 포이트명: 포인트값)
	                	return this.point.name+" : "+this.y+"%";
	                }
	            }
			}
		},
		series: [{
            data: [
                ["1M", wm_do1_per],
                ["2M", wm_do2_per],
                ["3M", wm_do3_per],
                ["4M", wm_do4_per],
                ["5M", wm_do5_per],
                ["6M", wm_do6_per],
                ["7M", wm_do7_per],
                ["8M", wm_do8_per],
                ["9M", wm_do9_per],
                ["10M", wm_do10_per],
                ["11M", wm_do11_per],
                ["12M", wm_do12_per],
                ["12M 초과", wm_etc_per]
            ],
            showInLegend: true 
        }],
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
	
	myChart.Draw();
	myChart1.Draw();
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
		mySheet.DoSearch("/mpst/getMasterMpStAgingGrList.do", param);
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
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
	mySheet.SetSumValue(0, "- 합     계 -");
	mySheet.SetMergeCell(mySheet.LastRow(), 0, 1, 4);
	mySheet.SetCellAlign(mySheet.LastRow(), 0, "Center");
	
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

</script>
</head>
<body onload="kep_onload_view(); doAction('search');">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>재고에이징(입고)</h3>
			(단위 : 백만원)
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
					<caption>재고에이징(입고)</caption>
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
	      	createIBSheet("mySheet", "100%", "180px");
			</script>
		</div>

		<b>- 재고 Aging 산출 기준 : 현 재고 수량을 기준으로 월별 역산하여 Aging 산출, 현 재고 = 입고(A월 + B월 + ... N월)</b>
		<br><br>
		
		<div style="width:100%;height:320px;">
			<div style="width:630px;height:100%;float:left">
				<div class="ib_products">
					<script type="text/javascript">
						createIBChart("myChart", "100%", "320px");
	                </script>
           		</div>
			</div>
			<div  style="width:630px;height:100%;float:left">
           		<div class="ib_products">
	                <script type="text/javascript">
						createIBChart("myChart1", "100%", "320px");
	                </script>
				</div>
			</div>
        </div>
<!--내용 종료-->	                 
</body>
</html>
