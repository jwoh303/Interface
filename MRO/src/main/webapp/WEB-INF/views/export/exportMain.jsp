<%@page import="com.diquest.ir.util.common.DateUtil"%>
<%@page import="com.ctc.wstx.util.DataUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("total_data"); // 조회된결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _noticeList = (List<Map<String,String>>) request.getAttribute("notice_data"); // 조회된결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _chartList = (List<Map<String,String>>) request.getAttribute("chart_data"); // 조회된결과

Map<String,String> rowData = (_gridList != null && _gridList.size() > 0) ? _gridList.get(0) : new HashMap<String, String>();
Map<String,String> chartData = (_chartList != null && _chartList.size() > 0) ? _chartList.get(0) : new HashMap<String, String>();

String curYear	= CommonUtil.getCurrentDay_Time("YYYYMM").substring(0,4);

%> 
</head>
<script type="text/javascript">
//<!--
var popupSel = "";
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

function kep_init() {
	// 조회 데이터를 기반으로 차트 그리기
	myChart_init();
}

function myChart_init(){
	var ci_1 = Number("<%=CommonUtil.bnvl(chartData.get("CI_JAN"))%>");
	var ci_2 = Number("<%=CommonUtil.bnvl(chartData.get("CI_FEB"))%>");
	var ci_3 = Number("<%=CommonUtil.bnvl(chartData.get("CI_MAR"))%>");
	var ci_4 = Number("<%=CommonUtil.bnvl(chartData.get("CI_APR"))%>");
	var ci_5 = Number("<%=CommonUtil.bnvl(chartData.get("CI_MAY"))%>");
	var ci_6 = Number("<%=CommonUtil.bnvl(chartData.get("CI_JUN"))%>");
	var ci_7 = Number("<%=CommonUtil.bnvl(chartData.get("CI_JUL"))%>");
	var ci_8 = Number("<%=CommonUtil.bnvl(chartData.get("CI_AUG"))%>");
	var ci_9 = Number("<%=CommonUtil.bnvl(chartData.get("CI_SEP"))%>");
	var ci_10 = Number("<%=CommonUtil.bnvl(chartData.get("CI_OCT"))%>");
	var ci_11 = Number("<%=CommonUtil.bnvl(chartData.get("CI_NOV"))%>");
	var ci_12 = Number("<%=CommonUtil.bnvl(chartData.get("CI_DEC"))%>");
	
	var bl_1 = Number("<%=CommonUtil.bnvl(chartData.get("BL_JAN"))%>");
	var bl_2 = Number("<%=CommonUtil.bnvl(chartData.get("BL_FEB"))%>");
	var bl_3 = Number("<%=CommonUtil.bnvl(chartData.get("BL_MAR"))%>");
	var bl_4 = Number("<%=CommonUtil.bnvl(chartData.get("BL_APR"))%>");
	var bl_5 = Number("<%=CommonUtil.bnvl(chartData.get("BL_MAY"))%>");
	var bl_6 = Number("<%=CommonUtil.bnvl(chartData.get("BL_JUN"))%>");
	var bl_7 = Number("<%=CommonUtil.bnvl(chartData.get("BL_JUL"))%>");
	var bl_8 = Number("<%=CommonUtil.bnvl(chartData.get("BL_AUG"))%>");
	var bl_9 = Number("<%=CommonUtil.bnvl(chartData.get("BL_SEP"))%>");
	var bl_10 = Number("<%=CommonUtil.bnvl(chartData.get("BL_OCT"))%>");
	var bl_11 = Number("<%=CommonUtil.bnvl(chartData.get("BL_NOV"))%>");
	var bl_12 = Number("<%=CommonUtil.bnvl(chartData.get("BL_DEC"))%>");
	
	var year = "<%=curYear%>";
	
	myChart.SetOptions({
		Chart:{
			Type:"column"
		},
		
		Title:{
			Text: year+"년 외자납품현황",
			Style:{
				Color:"#15498B",
				FontFamily:"Dotum",
				FontWeight:"bold"
			}
		},
		
		XAxis:{
			Title:{
				Text:""
			},
			Categories : ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
		},
		
		YAxis:{
			Title:{
				Text:""
			},
			GridLineWidth:2
		},
			
		series: [{
			name: "C/I, P/L 등록",
            data: [
                {Y:ci_1},{Y:ci_2},{Y:ci_3},{Y:ci_4},{Y:ci_5},{Y:ci_6},{Y:ci_7},{Y:ci_8},{Y:ci_9},{Y:ci_10},{Y:ci_11},{Y:ci_12}
            ],
            showInLegend: true
		},{
			name: "B/L 등록",
            data: [
                {Y:bl_1},{Y:bl_2},{Y:bl_3},{Y:bl_4},{Y:bl_5},{Y:bl_6},{Y:bl_7},{Y:bl_8},{Y:bl_9},{Y:bl_10},{Y:bl_11},{Y:bl_12}
            ],
            showInLegend: true
        }],
        
        legend: {
        	Layout : "vertical", //Legend 모양 설정
        	Align : "right", //Legend 가로 정렬 설정
        	VerticalAlign : "middle" //Legend 세로 정렬 설정
        },
        
        ToolTip:{
        	Enabled:false
        }
	});
	
	myChart.SetPlotOptions({
		column: { // 컬럼 차트에만 데이터 레이블을 설정
			PointWidth : 25,
			GroupPadding : 0.1,
			DataLabels : {
				Enabled:true,
				Formatter:function(){
					if(this.y == 0){
						return "";	
					}else{
						return this.y;
					}
				}
			}
		}
	});
	
	myChart.Draw();
}

//기능함수
function doAction(str) {
	switch (str) {
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("조회에 실패하였습니다.\n\n관리자에 문의 하여 주십시오."); 
}

//팝업함수호출
function doPop(str, value1, value2) {
	popupSel = str;
	switch (str) {
	case "export_notice_detail":  // 수출 공지사항 상세정보
		openSearchPopup("/none/showSellerNoNeNoticeDetailPop.do", "?st_btype="+value1+"&st_bid="+value2, "800,600,no");
		break;
	}
}
 //-->
</script>
<body onload="kep_init();">
<div id="wrapper">
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="exportHeader"/>
<c:param name="part" value="eheader"/>
</c:import>
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
    <!--조회영역-->
	<form id = "searchCondition" name = "searchCondition" method = "post" >
	<!--HIDDEN-->
	<!-- 공통 -->
		<input type="hidden" name="s_SAVENAME">
		<!-- 화면 내 정의 -->
		<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
	</form>
	<br>			
	<div id="container">
		<div id="leftCont2">
			<div id="leftCont">
				<div id="leftWork2">
					<div class="specialGift">
						<ul class="specialGift1">
							<li><img src="/resources/images/banner_export1.jpg" alt="메인화면" /></a>
						</ul>
					</div>
				</div>
			</div>
            
	<br>			
				<div id="noticeArea">
                	<h2 class="height20" ><img src="/resources/images/s_tit_notice.gif" alt="공지사항" /></h2>
                    <ul>
<%
	if (_noticeList == null || _noticeList.size() == 0){
%>
                    	<li style="text-align: center; height: 108px;"><span class="title">현재 목록에 나와 있는 자료가 없습니다.</span></li>
<%
	}else{
		for (int j=0; j<_noticeList.size(); j++) {
			Map<String,String> noticeData = _noticeList.get(j);
%> 
						<li>
							<a href="javascript:doPop('export_notice_detail','<%=CommonUtil.nvl(noticeData.get("BTYPE"))%>','<%=CommonUtil.bnvl(noticeData.get("BID"))%>');">
								<span class="title"><%=CommonUtil.nvl(noticeData.get("SUBJECT"))%></span>
							</a>
							<span class="date"><%=CommonUtil.formatStrinigDate(noticeData.get("REG_DATE")).replaceAll("/", ".")%></span>
						</li>
 <%
		}
	}
%>
					</ul>
				</div>
			</div>
		</div>
		
			
				
				<br><br>
				
				<div style="width:100%;height:250px;">
					<div style="width:100%;height:100%;float:left">
						<div class="ib_products">
							<script type="text/javascript">
								createIBChart("myChart", "970px", "230px");
			                </script>
		           		</div>
					</div>
		        </div>
		        
		        
	</div>
 <!-----------------------------------------------------------------------------------------------footer------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/exportFooter.jsp" %>
<!-----------------------------------------------------------------------------------------------footer------------------------------------------------------------------------------------------------------->
    
</div>
</body>
</html>
