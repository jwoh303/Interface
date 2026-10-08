<%--
**********************************************
* 메뉴 : 실적/정산현황
* 화면 : 마감현황 탭
* 기능 : 마감현황 탭
* 프로그램 ID : 
* 담당자 : 최찬규  
* 착수일 : 2026-05-13
**********************************************
--%> 
<%@ page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*"%> 
<%@ page import="java.sql.Timestamp"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>

<%
SessionInfo _sessionInfoStat = (SessionInfo) request.getSession().getAttribute("sessionInfo");

//고객사 그룹통합여부 여부
String st_user_id = _sessionInfoStat.getUserId();
String buyer = _sessionInfoStat.getComCode();

boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", st_user_id, buyer);
String group_mng_flag = "N";
if(getCodeTGCM == true){
	group_mng_flag = "Y"; 
}

//엑셀다운로드 기능 통제
boolean p170000001 = CommonUtil.getSpecialCheckReturn(buyer,"P17-0000001");

%>
<script type="text/javascript">
var mySheet1 = new ibsheetObject();
var mySheet2 = new ibsheetObject();

window.tabs = window.tabs || {};
tabs.masterMpSmStats_tab1 = {
	//alert layer용
	but1text : "<%=CommonLang.get("HTITLE516")%>",/* 확인 */
	but1func : "javascript:closePopText2(); return false;",
	but1funcSearch : "javascript:tabs.masterMpSmStats_tab1.thisPopClose(); return false;",
	but1width : "120px",
	pagingMode : "N",
	current_page : "1",
	popupSel : "",
	init:function(){
		
		var initsheet1 = {};
		initsheet1.HeaderMode={ColMove:0};
		initsheet1.Cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet1.Cols = [
				 { Align:"left",		Width:250,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE604")%>|<%=CommonLang.get("HTITLE604")%>",					SaveName:"BUYER",			ColMerge:0}/*고객사|고객사*/
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE323")%>|<%=CommonLang.get("HTITLE380")%>",					SaveName:"DEPT",			ColMerge:0}/*부서명|부서코드*/
	                ,{ Align:"left",	Width:250,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE323")%>|<%=CommonLang.get("HTITLE323")%>",					SaveName:"DEPT_NAME",		ColMerge:0}/*부서명|부서명*/
	              	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:110,	Hidden:true,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE267")%>|<%=CommonLang.get("HTITLE386")%>",					SaveName:"ACCOUNT_CODE",	ColMerge:0}/*계정명|계정코드*/
	              	,{ Align:"left",	Width:250,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE267")%>|<%=CommonLang.get("HTITLE267")%>",					SaveName:"ACCOUNT_NAME",	ColMerge:0}/*계정명|계정명*/
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"<%=CommonLang.get("HTITLE1294")%>\n<%=CommonLang.get("HTITLE1295")%>|<%=CommonLang.get("HTITLE1294")%>\n<%=CommonLang.get("HTITLE1295")%>",	SaveName:"SUM_AMT",			ColMerge:0}/*조회년도\n누적금액|조회년도\n누적금액*/
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"<%=CommonLang.get("HTITLE1296")%>|<%=CommonLang.get("HTITLE1297")%>",				SaveName:"PO_CNT",			ColMerge:0}/*조회년월|주문건수*/
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"<%=CommonLang.get("HTITLE1296")%>|<%=CommonLang.get("HTITLE204")%>",					SaveName:"AMT",				ColMerge:0}/*조회년월|금액*/
					,{ Align:"right",	Width:70,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1296")%>|<%=CommonLang.get("HTITLE1298")%>(%)",				SaveName:"RATE",			ColMerge:0}/*조회년월|비중(%)*/
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1296")%>|<%=CommonLang.get("HTITLE1299")%>(%)",				SaveName:"BF_M_INCR_RATE",	ColMerge:0}/*조회년월|전월증감(%)*/
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1296")%>|<%=CommonLang.get("HTITLE1300")%>(%)",				SaveName:"BF_Y_INCR_RATE",	ColMerge:0}/*조회년월|전년증감(%)*/
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"<%=CommonLang.get("HTITLE1301")%>|<%=CommonLang.get("HTITLE1301")%>",				SaveName:"BF_M_AMT",		ColMerge:0}/*전월금액|전월금액*/
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",	Header:"<%=CommonLang.get("HTITLE1302")%>|<%=CommonLang.get("HTITLE1302")%>",				SaveName:"BF_Y_AMT",		ColMerge:0}/*당월금액|당월금액*/
		];
		
		var initsheet2 = {};
// 		initsheet1.HeaderMode={ColResize:0 , ColMove:0};
		initsheet2.Cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet2.Cols = [
				 { Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1303")%>1<%=CommonLang.get("HTITLE427")%>",	SaveName:"LAST_YEAR01"}/*전년1월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1304")%>1<%=CommonLang.get("HTITLE427")%>",	SaveName:"THIS_YEAR01"}/*당년1월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1303")%>2<%=CommonLang.get("HTITLE427")%>",	SaveName:"LAST_YEAR02"}/*전년2월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1304")%>2<%=CommonLang.get("HTITLE427")%>",	SaveName:"THIS_YEAR02"}/*당년2월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1303")%>3<%=CommonLang.get("HTITLE427")%>",	SaveName:"LAST_YEAR03"}/*전년3월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1304")%>3<%=CommonLang.get("HTITLE427")%>",	SaveName:"THIS_YEAR03"}/*당년3월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1303")%>4<%=CommonLang.get("HTITLE427")%>",	SaveName:"LAST_YEAR04"}/*전년4월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1304")%>4<%=CommonLang.get("HTITLE427")%>",	SaveName:"THIS_YEAR04"}/*당년4월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1303")%>5<%=CommonLang.get("HTITLE427")%>",	SaveName:"LAST_YEAR05"}/*전년5월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1304")%>5<%=CommonLang.get("HTITLE427")%>",	SaveName:"THIS_YEAR05"}/*당년5월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1303")%>6<%=CommonLang.get("HTITLE427")%>",	SaveName:"LAST_YEAR06"}/*전년6월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1304")%>6<%=CommonLang.get("HTITLE427")%>",	SaveName:"THIS_YEAR06"}/*당년6월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1303")%>7<%=CommonLang.get("HTITLE427")%>",	SaveName:"LAST_YEAR07"}/*전년7월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1304")%>7<%=CommonLang.get("HTITLE427")%>",	SaveName:"THIS_YEAR07"}/*당년7월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1303")%>8<%=CommonLang.get("HTITLE427")%>",	SaveName:"LAST_YEAR08"}/*전년8월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1304")%>8<%=CommonLang.get("HTITLE427")%>",	SaveName:"THIS_YEAR08"}/*당년8월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1303")%>9<%=CommonLang.get("HTITLE427")%>",	SaveName:"LAST_YEAR09"}/*전년9월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1304")%>9<%=CommonLang.get("HTITLE427")%>",	SaveName:"THIS_YEAR09"}/*당년9월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1303")%>10<%=CommonLang.get("HTITLE427")%>",	SaveName:"LAST_YEAR10"}/*전년10월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1304")%>10<%=CommonLang.get("HTITLE427")%>",	SaveName:"THIS_YEAR10"}/*당년10월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1303")%>11<%=CommonLang.get("HTITLE427")%>",	SaveName:"LAST_YEAR11"}/*전년11월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1304")%>11<%=CommonLang.get("HTITLE427")%>",	SaveName:"THIS_YEAR11"}/*당년11월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1303")%>12<%=CommonLang.get("HTITLE427")%>",	SaveName:"LAST_YEAR12"}/*전년12월*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE1304")%>12<%=CommonLang.get("HTITLE427")%>",	SaveName:"THIS_YEAR12"}/*당년12월*/
		];
		
		IBS_InitSheet(mySheet1, initsheet1, this.pagingMode);
		IBS_InitSheet(mySheet2, initsheet2, this.pagingMode);
		
		mySheet1.SetHighlightAfterSort(2);
		
		mySheet1.SetHeaderBackColor("#f2f7ff");
		mySheet1.SetTheme("DB", "DeepBlue");
		
		mySheet2.SetHighlightAfterSort(2);
		
		mySheet2.SetHeaderBackColor("#f2f7ff");
		mySheet2.SetTheme("DB", "DeepBlue");
		
		$("#st_search_date_1").val( kepGetNowTimeStr('YYYYMM','/') );
		this.header_text_change();
		
	},
	
	search:function(){
		if(isEmpty($("#st_search_date_1").val())){
			//기준년도를 선택하세요.
			var text = "<%=CommonLang.msg("MSG302")%>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			$("#st_search_date_1").focus();
			return;
		}
		this.header_text_change();
		$("#st_yyyy_mm_1").val($("#st_search_date_1").val().replace(/[/]/gi, ""));
		
		// 금액단위에 따른 그리드 제목변경
		var money_unit = $("#st_money_unit_1").val();
		
		var tempText = "- <%=CommonLang.get("HTITLE1315")%>" + "<span class='font400_5B5C61 font14px'>";
		if(money_unit == 1){
			tempText += " <%=CommonLang.get("HTITLE1418")%>" + "</span>";
		}else{
			tempText += " <%=CommonLang.get("HTITLE1314")%>" + "</span>";
		}
		<%
		//엑셀다운로드 기능 통제
		if(p170000001 == false){
		%>
		tempText += "<button style='float: right;'  class='But_ExcelDown40' onclick='tabs.masterMpSmStats_tab1.excelDown(); return false;'>"+"<%=CommonLang.get("HTITLE150") %>"+"</button>";		
		<%}%>
		$("#grid_subject_1").html(tempText);//부서/계정별 마감현황 (단위 : 백만원)
		kepSearch_v2(document.searchCondition1, mySheet1, "/mpsm/getMasterMpSmClosingStatsList.do", this.pagingMode);
	},
	search2:function(){
		if(isEmpty($("#st_search_date_1").val())){
			//기준년도를 선택하세요
			var text = "<%=CommonLang.msg("MSG302")%>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			$("#st_search_date_1").focus();
			return;
		}

		$("#st_yyyy_mm_1").val($("#st_search_date_1").val().replace(/[/]/gi, ""));
		
		kepSearch_v2(document.searchCondition1, mySheet2, "/mpsm/getMasterMpSmClosingStatsList1.do", this.pagingMode);
	},
	reload:function(){
		kepReload_v2('searchCondition1');
		mySheet1.RemoveAll();
		mySheet2.RemoveAll();
		myChart.RemoveAll();
		
		$("#st_search_date_1").val( kepGetNowTimeStr('YYYYMM','/') );
		this.header_text_change();
	},
	excelDown:function(){
		document.forms.searchCondition1.action = "/mpsm/excelMasterMpSmClosingStatsList.do";
		document.forms.searchCondition1.submit();
	},
	doAction:function(str,value1,value2,value3){
		switch (str) {
		default:
			break;
		}
	},
	myChart_init:function(){
		var chart_legend1 = $("#st_chart_legend1_1").val();
		var chart_legend2 = $("#st_chart_legend2_1").val();
		
		var categories = ['1<%=CommonLang.get("HTITLE427")%>', '2<%=CommonLang.get("HTITLE427")%>', '3<%=CommonLang.get("HTITLE427")%>', '4<%=CommonLang.get("HTITLE427")%>', '5<%=CommonLang.get("HTITLE427")%>', '6<%=CommonLang.get("HTITLE427")%>', '7<%=CommonLang.get("HTITLE427")%>', '8<%=CommonLang.get("HTITLE427")%>', '9<%=CommonLang.get("HTITLE427")%>', '10<%=CommonLang.get("HTITLE427")%>', '11<%=CommonLang.get("HTITLE427")%>', '12<%=CommonLang.get("HTITLE427")%>'];
		
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
	},
	header_text_change:function(){
		var from_date = $("#st_search_date_1").val();
		var from_date_str = from_date.split("/");
		
		var year_text = from_date_str[0];
		var month_text = from_date_str[1];

		$("#st_yyyy_1").val(year_text);
		
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
		mySheet1.SetCellValue(0,"SUM_AMT", year_text+"<%=CommonLang.get("HTITLE1164")%>\n<%=CommonLang.get("HTITLE1295")%>"); //년도\n누적금액
		mySheet1.SetCellValue(0,"PO_CNT", year_text+"<%=CommonLang.get("HTITLE424")%> "+month_text+"<%=CommonLang.get("HTITLE427")%>");
		mySheet1.SetCellValue(0,"AMT", year_text+"<%=CommonLang.get("HTITLE424")%> "+month_text+"<%=CommonLang.get("HTITLE427")%>");
		mySheet1.SetCellValue(0,"RATE", year_text+"<%=CommonLang.get("HTITLE424")%> "+month_text+"<%=CommonLang.get("HTITLE427")%>");
		mySheet1.SetCellValue(0,"BF_M_INCR_RATE", year_text+"<%=CommonLang.get("HTITLE424")%> "+month_text+"<%=CommonLang.get("HTITLE427")%>");
		mySheet1.SetCellValue(0,"BF_Y_INCR_RATE", year_text+"<%=CommonLang.get("HTITLE424")%> "+month_text+"<%=CommonLang.get("HTITLE427")%>");
		mySheet1.SetCellValue(0,"BF_M_AMT", bf_month_year_text+"<%=CommonLang.get("HTITLE424")%>\n"+bf_month_text+"<%=CommonLang.get("HTITLE1307")%>");
		mySheet1.SetCellValue(0,"BF_Y_AMT", bf_year_text+"<%=CommonLang.get("HTITLE424")%>\n"+month_text+"<%=CommonLang.get("HTITLE1307")%>");
		
		// 엑셀 다운로드용 헤더 텍스트
		$("#st_header_text1_1").val(year_text +"<%=CommonLang.get("HTITLE1164")%> <%=CommonLang.get("HTITLE1295")%>"); //년도 누적금액
		$("#st_header_text2_1").val(bf_month_year_text + "<%=CommonLang.get("HTITLE424")%> " + bf_month_text + "<%=CommonLang.get("HTITLE1307")%>");
		$("#st_header_text3_1").val(bf_year_text + "<%=CommonLang.get("HTITLE424")%> " + month_text + "<%=CommonLang.get("HTITLE1307")%>");
		
		// 차트 범례 이용 텍스트
		$("#st_chart_legend1_1").val(bf_year_text +"<%=CommonLang.get("HTITLE424")%>");
		$("#st_chart_legend2_1").val(year_text +"<%=CommonLang.get("HTITLE424")%>");
	},
	thisPopClose:function(){
		closePopText2();
		this.search();
	}
};
//조회 후처리
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,tabs.masterMpSmStats_tab1.but1text,tabs.masterMpSmStats_tab1.but1func,tabs.masterMpSmStats_tab1.but1width);
	}
	tabs.masterMpSmStats_tab1.search2();
	
}
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,tabs.masterMpSmStats_tab1.but1text,tabs.masterMpSmStats_tab1.but1func,tabs.masterMpSmStats_tab1.but1width);
	}
	
	tabs.masterMpSmStats_tab1.myChart_init();
	
}
//그리드 표시후 처리	 
function mySheet1_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

//그리드 표시후 처리	 
function mySheet2_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
</script>
<form id="searchCondition1" name="searchCondition1" method="post">
		<input type="hidden" name="s_SAVENAME">
		<input type="hidden" id="pageflag_1" name="pageflag" value="1">
		<input type="hidden" name="onepagerow" id="onepagerow_1" value="<%=request.getParameter("rowCnt")%>">
	<!-- 화면 내 정의 -->
		<input type="hidden" id="st_user_id_1" name="st_user_id"  value="${sessionInfo.userId}">
		<input type="hidden" id="st_com_code_1" name="st_com_code"  value="${sessionInfo.comCode}">
		<input type="hidden" name="st_buyer" id="st_buyer_1" style="width:80%" value="">

		<input type="hidden" name="st_yyyy_mm" id="st_yyyy_mm_1" style="width:80%" value="">
		<input type="hidden" name="st_yyyy" id="st_yyyy_1" style="width:80%" value="">

		<input type="hidden" name="st_header_text1" id="st_header_text1_1" style="width:80%" value="">
		<input type="hidden" name="st_header_text2" id="st_header_text2_1" style="width:80%" value="">
		<input type="hidden" name="st_header_text3" id="st_header_text3_1" style="width:80%" value="">
		
		<input type="hidden" name="st_chart_legend1" id="st_chart_legend1_1" style="width:80%" value="">
		<input type="hidden" name="st_chart_legend2" id="st_chart_legend2_1" style="width:80%" value="">
		
		<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag_1" style="width:80%" value="<%=group_mng_flag%>">

	<div id="Search1" class="SearchContent">
      <table class="TabSearchTable" >
        <colgroup>
          <col width="80px" />
          <col width="490px" />
          <col width="80px" />
          <col width="350px" />
          <col width="80px" />
          <col width="200px" />
        </colgroup>           	
        <tr>
          <th><%=CommonLang.get("HTITLE1308")%><!--기준년월--></th>
          <td>
            <div class="Buyer-datepicker-wrap" style=" width:120px">
              <div class="Buyer-date-input" data-monthpicker><input type="text" name="st_search_date" id="st_search_date_1" readonly /><span></span></div>
            </div>               
            <select name="st_dept_type" id="st_dept_type_1" class="Select40" style=" float:left; width:252px; margin-right:7px">
              	<option value="B" selected><%=CommonLang.get("HTITLE419")%><!-- 예산부서 --></option>
				<option value="A"><%=CommonLang.get("HTITLE135")%><!-- 요청부서 --></option>
            </select> 
          </td>
          <th><%=CommonLang.get("HTITLE1310")%><!--조회기준--></th>
          <td><select name="st_view_type" id="st_view_type_1" class="Select40" style="width:250px;">
              	<option value="A" selected><%=CommonLang.get("HTITLE1309")%><!--부서/계정--></option>
				<option value="B"><%=CommonLang.get("HTITLE329")%><!-- 부서 --></option>
				<option value="C"><%=CommonLang.get("HTITLE428")%><!-- 계정 --></option>
            </select>  
          </td>                     
          <th><%=CommonLang.get("HTITLE1311")%><!--금액단위--></th>
          <td><select name="st_money_unit" id="st_money_unit_1" class="Select40" style="width:200px;">
              	<option value="1000000" selected><%=CommonLang.get("HTITLE1312")%><!--백만원--></option>
				<option value="1"><%=CommonLang.get("HTITLE660")%><!-- 원 --></option>
            </select>  
          </td> 
		</tr>           
      </table>
      <div class="SearchBtnBox">
      	<button class="ButOutline_Medium" onclick="javascript:tabs.masterMpSmStats_tab1.reload(); return false;"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
        <button class="ButDarkGray_Medium" onclick="javascript:tabs.masterMpSmStats_tab1.search(); return false;"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
      </div>
      <div class="SubPageTitSmall mt20"><%=CommonLang.get("HTITLE1313")%><!--전년대비 월별 마감현황--> <span class="font400_5B5C61 font14px"><%=CommonLang.get("HTITLE1314")%><!--(단위 : 백만원)--></span></div>
      <div class="IBSheetBuyer" style="border:1px solid #eee; background-color:#fff; height:180px; background-color:#f6f5f6">
      	<script type="text/javascript">
			createIBChart("myChart", "100%", "100%");
		</script>
      </div><!--IBSheetBuyer 끝 --> 
      <div class="SubPageTitSmall mt30" style="height:50px;" id="grid_subject_1"><%=CommonLang.get("HTITLE1315")%><!--부서/계정별 마감현황--> <span class="font400_5B5C61 font14px"><%=CommonLang.get("HTITLE1314")%><!--(단위 : 백만원)--></span>
      		<%
			//엑셀다운로드 기능 통제
			if(p170000001 == false){
			%>
      		<button style="float: right;"  class="But_ExcelDown40" onclick="tabs.masterMpSmStats_tab1.excelDown(); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
      		<%} %>
	  </div>
      <div class="IBSheetBuyer" style="border:1px solid #eee; background-color:#fff; height:350px; background-color:#f6f5f6">
      	<script type="text/javascript">
			createIBSheet("mySheet1", "100%", "100%");
		</script>
      </div><!--IBSheetBuyer 끝 -->
      
      <div class="IBSheetBuyer" style="border:1px solid #eee; background-color:#fff; height:180px; background-color:#f6f5f6; display: none;">
      	<script type="text/javascript">
			createIBSheet("mySheet2", "100%", "100%");
		</script>
      </div><!--IBSheetBuyer 끝 -->  
      <div class="h50"></div>         
    </div><!--Tab1끝 -->
</form> 