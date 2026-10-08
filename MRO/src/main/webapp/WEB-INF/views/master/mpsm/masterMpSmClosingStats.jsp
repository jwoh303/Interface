<%--
**********************************************
* 메뉴 : 관리자>통계>마감현황
* 화면 : 마감현황
* 기능 : 
* 프로그램 ID : 
* 담당자 : HSJ ( 설계 : KSW )
* 착수일 : 2017.03.24
**********************************************
--%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

//고객사 그룹통합여부 여부
String st_user_id = _sessionInfo.getUserId();
String buyer = _sessionInfo.getComCode();

boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", st_user_id, buyer);
String group_mng_flag = "N";
if(getCodeTGCM == true){
	group_mng_flag = "Y"; 
}

//엑셀다운로드 기능 통제
boolean p170000001 = CommonUtil.getSpecialCheckReturn(buyer,"P17-0000001");
%>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/smoothness/jquery-ui.min.css"/>   
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/ibchart/js/ibchart.js" type="text/javascript"></script>
<script src="/resources/libs/ibchart/js/ibchartinfo.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/common.js"></script>
<style type="text/css">
<!--
	table.ui-datepicker-calendar { display:none; }
-->
</style>
<script>
var mySheet1 = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet1 = {};
	initsheet1.Cols = [
					{ Align:"left",		Width:250,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사|고객사",					SaveName:"BUYER",			ColMerge:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"부서명|부서코드",					SaveName:"DEPT",			ColMerge:0}
	                ,{ Align:"left",	Width:250,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"부서명|부서명",					SaveName:"DEPT_NAME",		ColMerge:0}
	              	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:110,	Hidden:true,	Type:"Text",	Header:"계정명|계정코드",					SaveName:"ACCOUNT_CODE",	ColMerge:0}
	              	,{ Align:"left",	Width:250,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",	Header:"계정명|계정명",					SaveName:"ACCOUNT_NAME",	ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"조회년도\n누적금액|조회년도\n누적금액",	SaveName:"SUM_AMT",			ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"조회년월|주문건수",				SaveName:"PO_CNT",			ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"조회년월|금액",					SaveName:"AMT",				ColMerge:0}
					,{ Align:"right",	Width:70,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",	Header:"조회년월|비중(%)",				SaveName:"RATE",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",	Header:"조회년월|전월증감(%)",				SaveName:"BF_M_INCR_RATE",	ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",	Header:"조회년월|전년증감(%)",				SaveName:"BF_Y_INCR_RATE",	ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"전월금액|전월금액",				SaveName:"BF_M_AMT",		ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"당월금액|당월금액",				SaveName:"BF_Y_AMT",		ColMerge:0}
	];
	
	var initsheet2 = {};
	initsheet2.Cols = [ 
					{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"전년1월",	SaveName:"LAST_YEAR01"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"당년1월",	SaveName:"THIS_YEAR01"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"전년2월",	SaveName:"LAST_YEAR02"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"당년2월",	SaveName:"THIS_YEAR02"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"전년3월",	SaveName:"LAST_YEAR03"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"당년3월",	SaveName:"THIS_YEAR03"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"전년4월",	SaveName:"LAST_YEAR04"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"당년4월",	SaveName:"THIS_YEAR04"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"전년5월",	SaveName:"LAST_YEAR05"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"당년5월",	SaveName:"THIS_YEAR05"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"전년6월",	SaveName:"LAST_YEAR06"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"당년6월",	SaveName:"THIS_YEAR06"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"전년7월",	SaveName:"LAST_YEAR07"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"당년7월",	SaveName:"THIS_YEAR07"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"전년8월",	SaveName:"LAST_YEAR08"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"당년8월",	SaveName:"THIS_YEAR08"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"전년9월",	SaveName:"LAST_YEAR09"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"당년9월",	SaveName:"THIS_YEAR09"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"전년10월",	SaveName:"LAST_YEAR10"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"당년10월",	SaveName:"THIS_YEAR10"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"전년11월",	SaveName:"LAST_YEAR11"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"당년11월",	SaveName:"THIS_YEAR11"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"전년12월",	SaveName:"LAST_YEAR12"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"당년12월",	SaveName:"THIS_YEAR12"}
	];
	
	var cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge};
	mySheet1.SetConfig(cfg);
	mySheet2.SetConfig(cfg);
	
	IBS_InitSheet(mySheet1, initsheet1, pagingMode);
	IBS_InitSheet(mySheet2, initsheet2, pagingMode);
	
	mySheet1.SetCountPosition(4);
	
	// 조회조건 일자 초기화
	kepSetCalenderYearMonth("st_search_date");
	
	// 조회조건 일자 설정
	$("#st_search_date").val( kepGetNowTimeStr('YYYYMM','/') );
	
	// 헤더 텍스트 변경
	header_text_change();
	
	// 화면 로드 시 자동 조회
	doAction("search");
}

function myChart_init(){
	var chart_legend1 = $("#st_chart_legend1").val();
	var chart_legend2 = $("#st_chart_legend2").val();
	
	var categories = ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'];
	
	myChart.SetOptions({
		Chart:{
			Type:"column"
		},
		
		Title:{
			Style:{
				Color:"#15498B",
				FontFamily:"Dotum",
				FontWeight:"bold"
			}
		},
		
		xAxis: {
        },
        
        yAxis: {
        	GridLineDashStyle:"solid",
    		tickInterval:50,
        	title: {
        		text : ''
        	}
        },
        
		ToolTip:{
			pointFormat: '<table><tr><td style="color:{series.color}; padding:0">{series.name}:</td>' + '<td style="padding:0"><b>{point.y:1f}</b></td></tr>',
			footerFormat:'</table>',
			shared:true,
			useHTML:true
		},
		
		plotOptions:{
			Column:{
				borderWidth: 0,
				PointPadding: 0.05
			}
		},

		legend: {
            align: 'right',
            verticalAlign: 'middle',
            layout: 'vertical'
        }
	});
	
	var data = {
		IBChart: {
			Data : []
		}
	};
	
	var row = 1;
	
	for(var i=0; i< categories.length; i++){
		
		if(i==0){
			var tData = {
					AxisLabel: categories[i],
					Series:[
					        {
					        	SeriesName: chart_legend1,
					        	Value:Number(mySheet2.GetCellValue(row, "LAST_YEAR"+addZeroAndPlusOne(i))),
					        	SeriesColor:"#0000FF"
					        },
					        {
					        	SeriesName:chart_legend2,
					        	Value:Number(mySheet2.GetCellValue(row, "THIS_YEAR"+addZeroAndPlusOne(i))),
					        	SeriesColor:"#FF0000"
					        }
					]
			};
			data.IBChart.Data.push(tData);
		}else{
			var tData = {
					AxisLabel:categories[i],
					Series:[
					        Number(mySheet2.GetCellValue(row, "LAST_YEAR"+addZeroAndPlusOne(i))),
					        Number(mySheet2.GetCellValue(row, "THIS_YEAR"+addZeroAndPlusOne(i)))
					]
			};
			data.IBChart.Data.push(tData);
		}
	}
	
	//최종 조합된 데이터를 시트에 로드 함.
	myChart.LoadSearchData(data);
	
	// 1 을 01 로 리턴해 준다.
	function addZeroAndPlusOne(str){
	       var n = str; //<--넘버형변환
	       n++;
	       return (n<10)?"0"+n:n;
	}
	
	myChart.Draw();
}

var st;
var mt;
// 기능함수
function doAction(str) {
	switch (str) {
	case "search":	 // 부서/계정별 마감현황 조회
		if(isEmpty($("#st_search_date").val())){
			alert("기준년도를 선택하세요.");
			$("#st_search_date").focus();
			return;
		}
		current_page = -1;

		// 헤더 텍스트 변경
		header_text_change();
		
		$("#st_yyyy_mm").val($("#st_search_date").val().replace(/[/]/gi, ""));
		
		// 금액단위에 따른 그리드 제목변경
		var money_unit = $("#st_money_unit").val();
		
		if(money_unit == 1){
			$("#grid_subject").html("- 부서/계정별 마감현황 (단위 : 원)");	
		}else{
			$("#grid_subject").html("- 부서/계정별 마감현황 (단위 : 백만원)");
		}
		
		kepSearch(document.searchCondition,  mySheet1 , "/mpsm/getMasterMpSmClosingStatsList.do" , pagingMode );
		break;

	case "search1":	 // 전년대비 월별 마감현황 조회
		if(isEmpty($("#st_search_date").val())){
			alert("기준년도를 선택하세요.");
			$("#st_search_date").focus();
			return;
		}
		current_page = -1;

		$("#st_yyyy_mm").val($("#st_search_date").val().replace(/[/]/gi, ""));
		
		kepSearch(document.searchCondition,  mySheet2 , "/mpsm/getMasterMpSmClosingStatsList1.do" , pagingMode );
		break;
		
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet1.RemoveAll();
		mySheet2.RemoveAll();
		myChart.RemoveAll();
		
		// 조회조건 일자 초기화
		kepSetCalenderYearMonth("st_search_date");
		
		// 조회조건 일자 설정
		$("#st_search_date").val( kepGetNowTimeStr('YYYYMM','/') );
		
		// 헤더 텍스트 변경
		header_text_change();
		break;
		
	case "excelDown": // 엑셀다운로드
		
		document.forms.searchCondition.action = "/mpsm/excelMasterMpSmClosingStatsList.do";
		document.forms.searchCondition.submit();
		break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet1_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

//그리드 표시후 처리	 
function mySheet2_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 조회 후처리
function mySheet1_OnSearchEnd(code, msg) {
	loader_obj("N");
	doAction("search1");
}

//조회 후처리
function mySheet2_OnSearchEnd(code, msg) {
	loader_obj("N");
	
	// 조회 데이터를 기반으로 차트 그리기
	myChart_init();
}

function header_text_change(){
	/* 헤더 일자 표기 */
	var from_date = $("#st_search_date").val();
	var from_date_str = from_date.split("/");
	
	var year_text = from_date_str[0];
	var month_text = from_date_str[1];

	$("#st_yyyy").val(year_text);
	
	var bf_year_text = year_text - 1;
	var bf_month_year_text = year_text;
	var bf_month_text = month_text - 1;
	
	if(bf_month_text == "0"){
		bf_month_text = "12";
		bf_month_year_text = bf_month_year_text - 1;
	}
	
	if(("" + bf_month_text).length == 1){
		bf_month_text = "0" + bf_month_text;
	}
	
	// 조회 후 기준년월 이용하여 헤더 부분 변경
	mySheet1.SetCellValue(0,"SUM_AMT", year_text+"년도\n누적금액");
	mySheet1.SetCellValue(0,"PO_CNT", year_text+"년 "+month_text+"월");
	mySheet1.SetCellValue(0,"AMT", year_text+"년 "+month_text+"월");
	mySheet1.SetCellValue(0,"RATE", year_text+"년 "+month_text+"월");
	mySheet1.SetCellValue(0,"BF_M_INCR_RATE", year_text+"년 "+month_text+"월");
	mySheet1.SetCellValue(0,"BF_Y_INCR_RATE", year_text+"년 "+month_text+"월");
	mySheet1.SetCellValue(0,"BF_M_AMT", bf_month_year_text+"년\n"+bf_month_text+"월 금액");
	mySheet1.SetCellValue(0,"BF_Y_AMT", bf_year_text+"년\n"+month_text+"월 금액");
	
	// 엑셀 다운로드용 헤더 텍스트
	$("#st_header_text1").val(year_text +"년도 누적금액");
	$("#st_header_text2").val(bf_month_year_text + "년 " + bf_month_text + "월 금액");
	$("#st_header_text3").val(bf_year_text + "년 " + month_text + "월 금액");
	
	// 차트 범례 이용 텍스트
	$("#st_chart_legend1").val(bf_year_text +"년");
	$("#st_chart_legend2").val(year_text +"년");
}

//팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5) {
	popupSel = "";
	var dept_type = $("#st_dept_type").val();
	
	switch (str) {
	
	case "dept": // 부서
		if(dept_type == "A"){
			popupSel = "dept";
			var buyerCode = $("#st_buyer").val();
			var sessionCode = $("#st_com_code").val();
			var comCode = (buyerCode == null || buyerCode == '')? sessionCode : buyerCode  ;
			openSearchPopup("/common/deptCodeAdminPop.do", "?open=Y&com_code="+comCode, "500,500,no");
		}else{
			popupSel = "budget_dept";
			var buyerCode = $("#st_buyer").val();
			var sessionCode = $("#st_com_code").val();
			var comCode = (buyerCode == null || buyerCode == '')? sessionCode : buyerCode  ;
			openSearchPopup("/coco/showCommonCoCoBudgetDeptPop.do", "?open=Y&st_com_code="+comCode, "500,500,no");
		}
		break;
		
	case "acct": // 부서
		popupSel = "acct";
		var buyerCode = $("#st_buyer").val();
		var sessionCode = $("#st_com_code").val();
		var comCode = (buyerCode == null || buyerCode == '')? sessionCode : buyerCode  ;
		openSearchPopup("/coco/showCommonCoCoAccountPop.do", "?open=Y&st_com_code="+comCode, "500,500,no");
		break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	if(popupSel == "budget_dept"){
		$("#st_dept_code").val(value1);
		$("#st_dept_name").val(value2);
	}else if(popupSel == "dept"){
		$("#st_dept_code").val(value1);
		$("#st_dept_name").val(value2);
	}else if(popupSel == "acct"){
		$("#st_account_code").val(value1);
		$("#st_account_name").val(value2);
	}
}

</script>
</head>

<body onload="kep_onload_view()">
<!-- 메뉴 S --> 
<div id="wrapper"> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>

<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<form name = "searchCondition" method = "post">
	<div id="ContArea" class="divGridArea" style="min-height: 230px;">
    <h3>마감현황</h3>
    <div id="searchBtnA">
		<!--버튼영역-->
       	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
       	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   	</div>        	
	
	<!--조회영역-->
	<div id="cont_searchA" class="divGridArea">
	<!--HIDDEN-->
	<!-- 공통 -->
		<input type="hidden" name="s_SAVENAME">
		<input type="hidden" id="pageflag" name="pageflag" value="1">
		<input type="hidden" id="onepagerow" name="onepagerow" value="100">
	<!-- 화면 내 정의 -->
		<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
		<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
		<input type="hidden" name="st_buyer" id="st_buyer" style="width:80%" value="">

		<input type="hidden" name="st_yyyy_mm" id="st_yyyy_mm" style="width:80%" value="">
		<input type="hidden" name="st_yyyy" id="st_yyyy" style="width:80%" value="">

		<input type="hidden" name="st_header_text1" id="st_header_text1" style="width:80%" value="">
		<input type="hidden" name="st_header_text2" id="st_header_text2" style="width:80%" value="">
		<input type="hidden" name="st_header_text3" id="st_header_text3" style="width:80%" value="">
		
		<input type="hidden" name="st_chart_legend1" id="st_chart_legend1" style="width:80%" value="">
		<input type="hidden" name="st_chart_legend2" id="st_chart_legend2" style="width:80%" value="">
		
		<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" style="width:80%" value="<%=group_mng_flag%>">
			
		<table  class="cont_t_list01" style="width:100%;">
			<caption>마감현황</caption>
			<colgroup>
				<col width="5%" />
				<col width="10%" />
				<col width="7%" />
<!--				
				<col width="20%" />
				<col width="4%" />
				<col width="20%" />
 -->				
				<col width="5%" />
				<col width="8%" />
				<col width="5%" />
				<col width="6%" />
				<col width="*" />
			</colgroup>
			
			<tbody>
				<tr>
					<td>기준년월</td>
					<td>
						<input type="text" class="input_type_text" name="st_search_date" id="st_search_date" readOnly style="width:65px; text-align:center;" value="">
					</td>

					<td>
						<select id="st_dept_type" name="st_dept_type">
							<option value="B" selected>예산부서</option>
							<option value="A">요청부서</option>
						</select>
					</td>
<!-- 					
					<td>
						<input type="text" name="st_dept_name" id="st_dept_name" style="width:65%;ime-mode:active" value="" READONLY>
						<input type="hidden" name="st_dept_code" id="st_dept_code" value="">
						<a href="javascript:doPop('dept');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_dept_code','st_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
							
					<td>계정</td>
					<td>
						<input type="text" name="st_account_name" id="st_account_name" style="width:65%;ime-mode:active" value="" READONLY>
						<input type="hidden" name="st_account_code" id="st_account_code" value="">
						<a href="javascript:doPop('acct');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_account_code','st_account_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
-->
					<td>조회기준</td>
					<td>
						<select id="st_view_type" name="st_view_type" style="width:80%;">
							<option value="A" selected>부서/계정</option>
							<option value="B">부서</option>
							<option value="C">계정</option>
						</select>
					</td>
					
					<td>금액단위</td>
					<td>
						<select id="st_money_unit" name="st_money_unit" style="width:80%;">
							<option value="1000000" selected>백만원</option>
							<option value="1">원</option>
						</select>
					</td>
							
					<td></td>
				</tr>
			</tbody>
		</table>
	</div>
					
	<!--grid-->
	<h4>- 전년대비 월별 마감현황 (단위 : 백만원)</h4>
	<div class="ib_products">
		<script type="text/javascript">
			createIBChart("myChart", "100%", "200px");
		</script>
	</div>

	<br>
		
	<h4 id="grid_subject">- 부서/계정별 마감현황</h4>
	<div class="ib_product" style="border-top:2px solid #3c639c">
		<script type="text/javascript">
			createIBSheet("mySheet1", "100%", "200px");
		</script>
	</div>
		
	<div class="ib_product" style="border-top:2px solid #3c639c; display:none">
		<script type="text/javascript">
			createIBSheet("mySheet2", "100%", "200px");
		</script>
	</div>

	<!-- 버튼영역 -->
	<div class="btnArea">
		<div class="fr">
			<%
			//엑셀다운로드 기능 통제
			if(p170000001 == false){
			%>
				<span class="btn_04">
					<a href="javascript:doAction('excelDown');">엑셀다운로드</a>
				</span>
			<%
			}
			%>
		</div>
	</div>
<!--내용 종료-->	
</div>
</form>
</div>
	<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
</div>
</body>
</html>
