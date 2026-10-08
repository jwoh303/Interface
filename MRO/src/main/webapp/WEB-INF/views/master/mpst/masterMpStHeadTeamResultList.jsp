<%--
**********************************************
* 메뉴 : 통계>경영실적통계>본부/팀 실적
* 화면 : 본부/팀 실적
* 기능 : 사업계획대비 실적달성율을 본부/팀별로 월단위로 집계하여 보여주는 화면
* 프로그램 ID : PG_90_C_600_01
* 담당자 : 홍석규 ( 설계 : 공통 )
* 착수일 : 2014-08-11
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String check_date       = DateTimeUtil.getFormatString("yyyyMMddHHmm");
int nowYear             = Integer.parseInt(check_date.substring(0,4));
int startYear = 2010;
%>


<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:1, Type:"Text",			Header:"부서명",	SaveName:"TEAM_NM"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:1, Type:"Text",			Header:"항목",	SaveName:"GUBUN1"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:0, Type:"Text",			Header:"구분",	SaveName:"GUBUN2"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,		Type:"Float",	ColMerge:0, Format:"#,##0.0",		Header:"계",		SaveName:"TOTAL"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,		Type:"Float",	ColMerge:0, Format:"#,##0.0",		Header:"1월",	SaveName:"JAN"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,		Type:"Float",	ColMerge:0, Format:"#,##0.0",		Header:"2월",	SaveName:"FEB"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,		Type:"Float",	ColMerge:0, Format:"#,##0.0",		Header:"3월",	SaveName:"MAR"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,		Type:"Float",	ColMerge:0, Format:"#,##0.0",		Header:"4월",	SaveName:"APR"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,		Type:"Float",	ColMerge:0, Format:"#,##0.0",		Header:"5월",	SaveName:"MAY"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,		Type:"Float",	ColMerge:0, Format:"#,##0.0",		Header:"6월",	SaveName:"JUN"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,		Type:"Float",	ColMerge:0, Format:"#,##0.0",		Header:"7월",	SaveName:"JUL"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,		Type:"Float",	ColMerge:0, Format:"#,##0.0",		Header:"8월",	SaveName:"AUG"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,		Type:"Float",	ColMerge:0, Format:"#,##0.0",		Header:"9월",	SaveName:"SEP"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,		Type:"Float",	ColMerge:0, Format:"#,##0.0",		Header:"10월",	SaveName:"OCT"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,		Type:"Float",	ColMerge:0, Format:"#,##0.0",		Header:"11월",	SaveName:"NOV"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,		Type:"Float",	ColMerge:0, Format:"#,##0.0",		Header:"12월",	SaveName:"DEC"}
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
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	//var cfg = {MergeSheet:msAll};
	var cfg = {MergeSheet:msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	mySheet2.SetConfig(cfg);
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	IBS_InitSheet(mySheet2, initsheet2, pagingMode);
	
	kepAjaxCommonQueryIdCombo('st_user_dept','master.mdcd.selectMasterMdCdBuyerCardManageDeptList99','ALL', '');
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
    		tickInterval:5000,
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

// 기능함수
function doAction(str) {
	
	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpst/getMasterMpStHeadTeamResultList.do" , pagingMode );
		break;
		
	case "search1":	 // 차트 조회
		current_page = -1;
	
		var year = document.forms.searchCondition.st_year.value;
		var last_year = document.forms.searchCondition.st_year.value - 1;

		$("#st_last_year").val(last_year);
		
		// 차트 범례 이용 텍스트
		$("#st_chart_legend1").val(last_year +"년");
		$("#st_chart_legend2").val(year +"년");
		
		var selectedDept = $("#st_user_dept option:selected").text(); // 선택 부서명 제목으로 표기 위하여
		$("#chart_title").html("- "+ selectedDept + " 전년대비 월별 매출실적 현황 (단위 : 백만원)");
		
		kepSearch(document.searchCondition,  mySheet2 , "/mpst/getMasterMpStHeadTeamResultList1.do" , pagingMode );
		break;
		
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		mySheet2.RemoveAll();
		myChart.RemoveAll();
		
		$("#st_year").val("<%=nowYear%>");
		break;
		
	case "excelDown": // 엑셀다운로드
		var param = {FileName:"본부/팀 실적.xlsx"};
	    kepDownExcel(document.searchCondition ,mySheet , "/mpst/excelMasterMpStHeadTeamResultList.do", param);
		break;	
	}
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	return DATA;
}

//그리드 표시후 처리	 
function mySheet2_OnLoadData(DATA) {
	return DATA;
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	if(mySheet.RowCount() <= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}
	
	doAction("search1");
}

//조회 후처리
function mySheet2_OnSearchEnd(code, msg) {
	loader_obj("N");

	// 조회 데이터를 기반으로 차트 그리기
	myChart_init();
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpst/getMasterMpStHeadTeamResultList.do?page="+current_page , pagingMode );
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>본부/팀 실적</h3>
			(단위 : 백만원)
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post">
			<div id="cont_searchA">
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="pageflag" name="pageflag" value="1">
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
				<input type="hidden" id="st_last_year" name="st_last_year"  value="">
				
				<input type="hidden" name="st_chart_legend1" id="st_chart_legend1" style="width:80%" value="">
				<input type="hidden" name="st_chart_legend2" id="st_chart_legend2" style="width:80%" value="">
		
            	<table  class="cont_t_list01" >
					<caption>본부/팀 실적</caption>
					<colgroup>
						<col width="5%" />
					    <col width="10%" />
					    <col width="5%" />
					    <col width="15%" />
					    <col width="5%" />
					    <col width="15%" />
					    <col width="*" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>년도</th>
							<td>
								<select id="st_year" name="st_year" style="width:60px;">
								<% 
								  	for (int i=startYear ; i<=nowYear; i++) {
								  		out.println("<option value='"+i+"'" + ((i == nowYear) ? " selected>" : ">")+i);
								  	} 
								 %>
								</select>							
							</td>
							<th>본부</th>
							<td>
								<select id="st_user_division" name="st_user_division" style="width:150px;">
									<option value="" selected>전체</option>
									<option value="012" >제조사업본부</option>
				                    <option value="119" >건설서비스사업본부</option>
				                    <option value="106" >전략영업본부</option>
								</select>
							</td>
							<th>부서</th>
							<td>
								<select id="st_user_dept" name="st_user_dept" style="width:150px;">
								</select>
							</td>
							<td>&nbsp;</td>
						</tr>
					</tbody>
				</table>
            </div>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "450px");
  				</script>
  			</div>
  			
  			<div class="ib_product" style="border-top:2px solid #3c639c; display:none">
				<script type="text/javascript">
					createIBSheet("mySheet2", "100%", "80px");
				</script>
			</div>
			
			<h4 id="chart_title" name="chart_title"></h4>
			<div class="ib_products">
				<script type="text/javascript">
					createIBChart("myChart", "100%", "200px");
				</script>
			</div>
		
			<br>
  			<!--버튼영역-->
			<div class="btnArea">
				<span class="fl">
<!--  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span> -->
  				</span>
			</div>
<!--내용 종료-->	                 

</body>
</html>
