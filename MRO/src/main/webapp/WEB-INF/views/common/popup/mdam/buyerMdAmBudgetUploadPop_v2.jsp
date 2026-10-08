<%--
**********************************************
* 메뉴 : 예산편성 > 일괄편성 팝업
* 화면 : 예산편성 > 일괄편성 팝업
* 기능 : 예산편성 > 일괄편성 팝업
* 프로그램 ID : BU1005012
* 담당자 : 최찬규
* 착수일 : 2026-03-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%
String toDate = CommonUtil.formatDateNoDateGubun(new Date(),1);

String tab_id = CommonUtil.nvl((String) request.getParameter("tab_id"),""); // tab_id
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<script>
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var maxAllowRow = 1000;	// 업로드 허용할 데이터 Row수

var checkStartIndex = 1;

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var date = new Date();
	year = date.getFullYear();
	month = date.getMonth()+1;
	for(var i=0;i<=2;i++) {
		$('#st_year').append('<option value="' + (year+i) + '">' + (year+i) + '</option>');
	}
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [ 
	         		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus"}
	         		,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,		Hidden:true,	Type:"DummyCheck",	Header:"",			SaveName:"SELECTED"}
	         		,{ Align:"Center",	Width:120,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE568")%>",		SaveName:"BUDGET_DEPT"}/* 예산부서코드 */
	         		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE268")%>",		SaveName:"BUDGET_DEPT_NAME"}/*예산부서*/
	         		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE984")%>",		SaveName:"ACCOUNT"}/*예산계정코드*/
	         		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE966")%>",		SaveName:"ACCOUNT_NAME"}/*예산계정*/
	         		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		Header:"<%=CommonLang.get("HTITLE1141")%>",	SaveName:"TOTAL_PLAN_AMT"}/*편성총금액*/
	  				
	         		,{ Align:"Right",	SaveName:"Y_01_PLAN_AMT",				Header:"<%=CommonLang.get("HTITLE1164")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*1월*/ 
	  				,{ Align:"Right",	SaveName:"H_01_PLAN_AMT",				Header:"<%=CommonLang.get("HTITLE1152")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*2월*/ 
	  				,{ Align:"Right",	SaveName:"H_02_PLAN_AMT",				Header:"<%=CommonLang.get("HTITLE1153")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*3월*/ 
	  				,{ Align:"Right",	SaveName:"Q_01_PLAN_AMT",				Header:"1<%=CommonLang.get("HTITLE426")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*4월*/ 
	  				,{ Align:"Right",	SaveName:"Q_02_PLAN_AMT",				Header:"2<%=CommonLang.get("HTITLE426")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*5월*/ 
	  				,{ Align:"Right",	SaveName:"Q_03_PLAN_AMT",				Header:"3<%=CommonLang.get("HTITLE426")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*6월*/ 
	  				,{ Align:"Right",	SaveName:"Q_04_PLAN_AMT",				Header:"4<%=CommonLang.get("HTITLE426")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*7월*/
	  				,{ Align:"Right",	SaveName:"Y_01_ORG_PLAN_AMT",				Header:"Y_01_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*1월*/ 
	  				,{ Align:"Right",	SaveName:"H_01_ORG_PLAN_AMT",				Header:"H_01_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*2월*/ 
	  				,{ Align:"Right",	SaveName:"H_02_ORG_PLAN_AMT",				Header:"H_02_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*3월*/ 
	  				,{ Align:"Right",	SaveName:"Q_01_ORG_PLAN_AMT",				Header:"Q_01_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*4월*/ 
	  				,{ Align:"Right",	SaveName:"Q_02_ORG_PLAN_AMT",				Header:"Q_02_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*5월*/ 
	  				,{ Align:"Right",	SaveName:"Q_03_ORG_PLAN_AMT",				Header:"Q_03_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*6월*/ 
	  				,{ Align:"Right",	SaveName:"Q_04_ORG_PLAN_AMT",				Header:"Q_04_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*7월*/
	  				,{ Align:"Right",	SaveName:"Y_01_RESULT_AMT",				Header:"Y_01_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*1월*/ 
	  				,{ Align:"Right",	SaveName:"H_01_RESULT_AMT",				Header:"H_01_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*2월*/ 
	  				,{ Align:"Right",	SaveName:"H_02_RESULT_AMT",				Header:"H_02_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*3월*/ 
	  				,{ Align:"Right",	SaveName:"Q_01_RESULT_AMT",				Header:"Q_01_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*4월*/ 
	  				,{ Align:"Right",	SaveName:"Q_02_RESULT_AMT",				Header:"Q_02_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*5월*/ 
	  				,{ Align:"Right",	SaveName:"Q_03_RESULT_AMT",				Header:"Q_03_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*6월*/ 
	  				,{ Align:"Right",	SaveName:"Q_04_RESULT_AMT",				Header:"Q_04_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*7월*/
	  				
	         		,{ Align:"Right",	SaveName:"M_01_PLAN_AMT",				Header:"1<%=CommonLang.get("HTITLE427")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*1월*/ 
	  				,{ Align:"Right",	SaveName:"M_02_PLAN_AMT",				Header:"2<%=CommonLang.get("HTITLE427")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*2월*/ 
	  				,{ Align:"Right",	SaveName:"M_03_PLAN_AMT",				Header:"3<%=CommonLang.get("HTITLE427")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*3월*/ 
	  				,{ Align:"Right",	SaveName:"M_04_PLAN_AMT",				Header:"4<%=CommonLang.get("HTITLE427")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*4월*/ 
	  				,{ Align:"Right",	SaveName:"M_05_PLAN_AMT",				Header:"5<%=CommonLang.get("HTITLE427")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*5월*/ 
	  				,{ Align:"Right",	SaveName:"M_06_PLAN_AMT",				Header:"6<%=CommonLang.get("HTITLE427")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*6월*/ 
	  				,{ Align:"Right",	SaveName:"M_07_PLAN_AMT",				Header:"7<%=CommonLang.get("HTITLE427")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*7월*/
	  				,{ Align:"Right",	SaveName:"M_08_PLAN_AMT",				Header:"8<%=CommonLang.get("HTITLE427")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*8월*/
	  				,{ Align:"Right",	SaveName:"M_09_PLAN_AMT",				Header:"9<%=CommonLang.get("HTITLE427")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*9월*/
	  				,{ Align:"Right",	SaveName:"M_10_PLAN_AMT",				Header:"10<%=CommonLang.get("HTITLE427")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*10월*/ 
	  				,{ Align:"Right",	SaveName:"M_11_PLAN_AMT",				Header:"11<%=CommonLang.get("HTITLE427")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*11월*/
	  				,{ Align:"Right",	SaveName:"M_12_PLAN_AMT",				Header:"12<%=CommonLang.get("HTITLE427")%>",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*12월*/
	  				,{ Align:"Right",	SaveName:"M_01_RESULT_AMT",				Header:"M_01_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*1*/ 
	  				,{ Align:"Right",	SaveName:"M_02_RESULT_AMT",				Header:"M_02_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*2*/ 
	  				,{ Align:"Right",	SaveName:"M_03_RESULT_AMT",				Header:"M_03_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*3*/ 
	  				,{ Align:"Right",	SaveName:"M_04_RESULT_AMT",				Header:"M_04_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*4*/ 
	  				,{ Align:"Right",	SaveName:"M_05_RESULT_AMT",				Header:"M_05_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*5*/ 
	  				,{ Align:"Right",	SaveName:"M_06_RESULT_AMT",				Header:"M_06_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*6*/ 
	  				,{ Align:"Right",	SaveName:"M_07_RESULT_AMT",				Header:"M_07_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*7*/
	  				,{ Align:"Right",	SaveName:"M_08_RESULT_AMT",				Header:"M_08_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*8*/
	  				,{ Align:"Right",	SaveName:"M_09_RESULT_AMT",				Header:"M_09_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*9*/
	  				,{ Align:"Right",	SaveName:"M_10_RESULT_AMT",				Header:"M_10_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*10*/ 
	  				,{ Align:"Right",	SaveName:"M_11_RESULT_AMT",				Header:"M_11_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*11*/
	  				,{ Align:"Right",	SaveName:"M_12_RESULT_AMT",				Header:"M_12_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*12*/
	  				,{ Align:"Right",	SaveName:"M_01_ORG_PLAN_AMT",				Header:"M_01_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*1*/ 
	  				,{ Align:"Right",	SaveName:"M_02_ORG_PLAN_AMT",				Header:"M_02_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*2*/ 
	  				,{ Align:"Right",	SaveName:"M_03_ORG_PLAN_AMT",				Header:"M_03_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*3*/ 
	  				,{ Align:"Right",	SaveName:"M_04_ORG_PLAN_AMT",				Header:"M_04_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*4*/ 
	  				,{ Align:"Right",	SaveName:"M_05_ORG_PLAN_AMT",				Header:"M_05_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*5*/ 
	  				,{ Align:"Right",	SaveName:"M_06_ORG_PLAN_AMT",				Header:"M_06_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*6*/ 
	  				,{ Align:"Right",	SaveName:"M_07_ORG_PLAN_AMT",				Header:"M_07_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*7*/
	  				,{ Align:"Right",	SaveName:"M_08_ORG_PLAN_AMT",				Header:"M_08_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*8*/
	  				,{ Align:"Right",	SaveName:"M_09_ORG_PLAN_AMT",				Header:"M_09_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*9*/
	  				,{ Align:"Right",	SaveName:"M_10_ORG_PLAN_AMT",				Header:"M_10_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*10*/ 
	  				,{ Align:"Right",	SaveName:"M_11_ORG_PLAN_AMT",				Header:"M_11_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*11*/
	  				,{ Align:"Right",	SaveName:"M_12_ORG_PLAN_AMT",				Header:"M_12_ORG_PLAN_AMT",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}/*12*/
// 	         		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		Header:"사용금액",		SaveName:"USED_AMT"}
	         		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE1165")%>",	SaveName:"MAPPING_YN"}/*예산/계정 매핑*/
	         		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE1166")%>",	SaveName:"EXIST_YN"} /*기등록여부*/
	         		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE1166")%>",	SaveName:"EXIST_TERM_TYPE"}/*기등록여부*/
	         		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE1166")%>",	SaveName:"EXIST_TERM_TYPE_TEXT"}/*기등록여부*/
	         		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE1167")%>",	SaveName:"BUDGET_DEPT_YN"}/*예산부서등록*/
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetHighlightAfterSort(2);
	mySheet.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetTheme("DB", "DeepBlue");
}
	
var st;
var mt;

// 기능함수
function doAction(str) {
	
	st = new Date();
	var rowCount = mySheet.RowCount();
	
	switch (str) {
		case "search": // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdam/getBuyerMdAmBudgetUploadPop_v2.do" , pagingMode );
			break;
		
		case "reload": // 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
	
		case "save": // 저장
			if(rowCount == 0){
				//저장할 대상이 없습니다.
				var text = "<%=CommonLang.msg("MSG731")%>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
		
			var st_year = $("#st_year").val();
			var st_term_type = $("#st_term_type").val();
		
			for ( var i = 1; i <= mySheet.RowCount();i++) {
				
				// 예산부서 확인
				if(mySheet.GetCellValue(i, "BUDGET_DEPT_NAME") == "" || mySheet.GetCellValue(i, "BUDGET_DEPT_NAME") == null || mySheet.GetCellValue(i, "BUDGET_DEPT_YN") == "N"){
					//예산부서를 확인해주세요.
					var text = i+"<%=CommonLang.get("HTITLE1154")%>"+" "+"<%=CommonLang.msg("MSG727")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
				
				// 계정코드 확인
				if(mySheet.GetCellValue(i, "ACCOUNT_NAME") == "" || mySheet.GetCellValue(i, "ACCOUNT_NAME") == null){
					//계정코드를 확인해주세요.
					var text = i+"<%=CommonLang.get("HTITLE1154")%>"+" "+"<%=CommonLang.msg("MSG728")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
				
				// 부서별계정 매핑 확인
				if(mySheet.GetCellValue(i, "MAPPING_YN") == "N"){
					//부서별계정 매핑을 확인해주세요.
					var text = i+"<%=CommonLang.get("HTITLE1154")%>"+"<%=CommonLang.msg("MSG729")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
				var forLength = 1;
				if(st_term_type == "Y"){
					forLength = 1;
				}else if(st_term_type == "H"){
					forLength = 2;
				}else if(st_term_type == "Q"){
					forLength = 4;
				}else if(st_term_type == "M"){
					forLength = 12;
				}
				for(var j = checkStartIndex; j <= forLength; j++){
					var index = j;
					if(index <10){
						index = "0"+index;
					}
					console.log(i+",,"+index+",,"+mySheet.GetCellValue(i,st_term_type+"_"+index+"_PLAN_AMT")+" || "+mySheet.GetCellValue(i,st_term_type+"_"+index+"_RESULT_AMT"));
					if(mySheet.GetCellValue(i,st_term_type+"_"+index+"_PLAN_AMT") < mySheet.GetCellValue(i,st_term_type+"_"+index+"_RESULT_AMT")){
						//i번째 예산금액은 실적금액보다 큰 경우만 수정 가능합니다.
						var text = i+"<%=CommonLang.get("HTITLE1154")%>"+" "+"<%=CommonLang.msg("MSG7")%>";
						openLayerPopText2(text,but1text,but1func,but1width);
						return;
					}
				}
				
				
				if(mySheet.GetCellValue(i,"EXIST_TERM_TYPE") != "" && mySheet.GetCellValue(i,"EXIST_TERM_TYPE") != st_term_type){
					//i번째 편성기간이 다른 예산이 존재합니다.
					var text = i+"<%=CommonLang.get("HTITLE1154")%>"+" "+"<%=CommonLang.msg("MSG730")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
				
				if(mySheet.GetCellValue(i,"TOTAL_PLAN_AMT") == "0"){
					//i번째 편성금액을 확인해주세요.
					var text = i+"<%=CommonLang.get("HTITLE1154")%>"+" "+"<%=CommonLang.msg("MSG735")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
			}
			//선택한 항목을 저장 하시겠습니까?
			var text = "<%=CommonLang.msg("MSG292")%>";
			var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
			var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
			var but1funcC = "javascript:saveBuyerMdAmBudgetUpload_v2(); return false;";
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "120px";
			var but2widthC = "120px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			
			break;
			
		case "loadExcel": // 파일 업로드
			var st_year = $("#st_year").val();
			if(st_year == ""){
				var text = "<%=CommonLang.msg("MSG717")%>"; //예산년도를 선택해주세요.
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			var term_type = $("#st_term_type").val();
			if(term_type == ""){
				//편성기간을 선택해주세요.
				var text = "<%=CommonLang.msg("MSG726")%>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			
			mySheet.RemoveAll();
			var params = { Mode : "HeaderMatch"};
// 			if(term_type == "Y"){
// 				var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"||1||2|||3|||||||||||"};
// 			}else if(term_type == "H"){
// 				var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"||1||2|||3|4||||||||||"};
// 			}else if(term_type == "Q"){
// 				var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"||1||2|||3|4|5|6||||||||"};
// 			}else if(term_type == "M"){
// 				var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"||1||2|||3|4|5|6|7|8|9|10|11|12|13|14"};
// 			}
			
			mySheet.LoadExcel(params);
			break;
		case "excelDown": //양식다운로드
			var term_type = $("#st_term_type").val();
			if(term_type == ""){
				//편성기간을 선택해주세요.
				var text = "<%=CommonLang.msg("MSG726")%>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			
			location.href="/resources/excel/kep_budget_upload_"+term_type+".xlsx";
			break;
	}
}

function saveBuyerMdAmBudgetUpload_v2(){
	closePopText1();
	
	$("#st_from_date").val($("#st_year").val()+"0101");
	$("#st_to_date").val($("#st_year").val()+"1231");
	
	kepSaveAll(document.searchCondition ,  mySheet , "/mdam/saveBuyerMdAmBudgetUpload_v2.do" , "SELECTED" );
}
//엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {
	loader_obj("N");
	var maxRowCount = maxAllowRow + 1;
	
	if(mySheet.RowCount() == 0){
		//일괄 업로드를 실패하였습니다. 관리자에게 문의바랍니다.
		var text = "<%=CommonLang.msg("MSG467")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
	}else{
		if(maxRowCount < mySheet.RowCount() + 1) {
			//건 이하의 파일만 업로드하여 주세요.
			var text = maxRowCount+"<%=CommonLang.msg("MSG468")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			mySheet.RemoveAll();
			return;
		}else{
			kepSaveAll(document.searchCondition ,  mySheet , "/mdam/saveBuyerMdAmExcelUpload_v2.do" , "SELECTED" );
		}
	}
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	if (msg != "") {
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
	mySheet.SetColHidden("MAPPING_YN",false);
	mySheet.SetColHidden("EXIST_YN",false);
	mySheet.SetColHidden("EXIST_TERM_TYPE_TEXT",false);
	mySheet.SetColHidden("BUDGET_DEPT_YN",false);
	
	var toDate = "<%=toDate%>"; //20260323
	var toYear = toDate.substring(0, 4); //2026
	var toMonth = toDate.substring(4, 6);//03
	var toMonth2 = Number(toMonth);//3
	var selYear = $("#st_year").val();
	
	var term_type = $("#st_term_type").val();
	
	var endIndex = 0;
	var startIndex = 0;
	var forLength = 1;
	if(selYear>=toYear){
		if(term_type == "Y"){
			startIndex = 1;
			endIndex = 1;
			forLength = 1;
		}else if(term_type == "H"){
			startIndex = 2;
			forLength = 2;
			if(toMonth < "07"){
				endIndex = 1;
			}else{
				endIndex = 2;
			}
		}else if(term_type == "Q"){
			startIndex = 4;
			forLength = 4;
			if(toMonth < "04"){
				endIndex = 1;
			}else if(toMonth < "07"){
				endIndex = 2;
			}else if(toMonth < "10"){
				endIndex = 3;
			}else{
				endIndex = 4;
			}
		}else{
			startIndex = 12;
			forLength = 12;
			endIndex = toMonth2;
		}
	}
	
	checkStartIndex = Number(endIndex) || 1;
	
	for(var i = 1; i<=mySheet.RowCount(); i++){
		for(var j = startIndex; j>=endIndex; j--){
			var index = j;
			if(index < 10){
				index = "0"+index;
			}
// 	 		mySheet.SetCellEditable(i,"M_"+index+"_PLAN_AMT",true);
	 		mySheet.SetCellBackColor(i,term_type+"_"+index+"_PLAN_AMT","${optColor}");
		}
		
		var term_type_text = "";
		if(mySheet.GetCellValue(i,"EXIST_TERM_TYPE") == "Y"){
			term_type_text = "<%=CommonLang.get("HTITLE424")%>"; //년
		}else if(mySheet.GetCellValue(i,"EXIST_TERM_TYPE") == "H"){
			term_type_text = "<%=CommonLang.get("HTITLE425")%>"; //반기
		}else if(mySheet.GetCellValue(i,"EXIST_TERM_TYPE") == "Q"){
			term_type_text = "<%=CommonLang.get("HTITLE426")%>"; //분기
		}else if(mySheet.GetCellValue(i,"EXIST_TERM_TYPE") == "M"){
			term_type_text = "<%=CommonLang.get("HTITLE427")%>"; //월
		}
		mySheet.SetCellValue(i,"EXIST_TERM_TYPE_TEXT",term_type_text);
	}
	
	//수정할 수 없는 컬럼 -> 0원처리
	for(var i = 1; i<=mySheet.RowCount(); i++){
		for(var j = endIndex-1; j>0; j--){
			var index = j;
			if(index < 10){
				index = "0"+index;
			}
	 		mySheet.SetCellValue(i,term_type+"_"+index+"_PLAN_AMT",0);
		}
	}
	
	for(var i = 1; i<=mySheet.RowCount(); i++){
		var total_amt = 0;
		for(var j = 1; j<=forLength; j++){
			var index = j;
			if(index < 10){
				index = "0"+index;
			}
			total_amt += mySheet.GetCellValue(i,term_type+"_"+index+"_PLAN_AMT");
		}
		mySheet.SetCellValue(i,"TOTAL_PLAN_AMT",total_amt);
	}
	
	
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		var text = msg;
		if(code == 1){
			//업로드성공
			openLayerPopText2(text,but1text,but1funcSearch,but1width);
		}else if(code == 2){
			//저장성공
			openLayerPopText2(text,but1text,"javascript:thisPopClose2();return false;",but1width);
		}else{
			openLayerPopText2(text,but1text,but1func,but1width);
		}
	}
}
function thisPopClose(){
	closePopText2();
	doAction('search');
}
function thisPopClose2(){
	closePopText2();
	var tab_id = "<%=tab_id%>";
	opener.tabs[tab_id]["search"]();
	self.close();
}
//팝업 함수호출
var gridIndex = 0;


function changeTermInit(){
	//처음엔 hidden 초기화
	mySheet.SetColHidden("Y_01_PLAN_AMT",true);
	mySheet.SetColHidden("H_01_PLAN_AMT",true);
	mySheet.SetColHidden("H_02_PLAN_AMT",true);
	mySheet.SetColHidden("Q_01_PLAN_AMT",true);
	mySheet.SetColHidden("Q_02_PLAN_AMT",true);
	mySheet.SetColHidden("Q_03_PLAN_AMT",true);
	mySheet.SetColHidden("Q_04_PLAN_AMT",true);
	for(var j = 1; j<=12; j++){
		var index = j;
		if(index < 10){
			index = "0"+index;
		}
		mySheet.SetColHidden("M_"+index+"_PLAN_AMT",true);
		
	}
	mySheet.SetColHidden("MAPPING_YN",true);
	mySheet.SetColHidden("EXIST_YN",true);
	mySheet.SetColHidden("EXIST_TERM_TYPE_TEXT",true);
	mySheet.SetColHidden("BUDGET_DEPT_YN",true);
	
	var st_term_type = $("#st_term_type").val();
	var forLength = 1;
	if(st_term_type == "Y"){
		forLength = 1;
	}else if(st_term_type == "H"){
		forLength = 2;
	}else if(st_term_type == "Q"){
		forLength = 4;
	}else if(st_term_type == "M"){
		forLength = 12;
	}
	
	for(var i = 1; i<=forLength; i++){
		var index = i;
		if(index < 10){
			index = "0"+index;
		}
		mySheet.SetColHidden(st_term_type+"_"+index+"_PLAN_AMT",false);
	}
	
	
	
	mySheet.RemoveAll();
// 	doAction('search');
}
</script>
</head>

<body onload="kep_onload_view()">

<!--내용 시작-->
<div class="wrapPopup">
  <div class="PopupTit"><%=CommonLang.get("HTITLE703") %><!-- 일괄편성 --><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="BudgetExcelBox">
    <div class="BudgetExcelBoxTxt mb10"><%=CommonLang.msg("MSG732")%><!--1. 일괄편성을 위하여 작성하실 기간을 선택하여 양식을 다운로드 해주세요--><br /><%=CommonLang.msg("MSG733")%><!--2. 작성한 양식을 업로드해주세요. 편성기간과 양식 내 기재된 기간이 일치하지 않을 경우, 금액이 0원으로 표시됩니다.--></div>
    <div class="BudgetExcel">
  <form name = "searchCondition" method = "post">
    <select name="st_year" id="st_year" class="Select40" style="width:150px;">
<%--         <option value=""><%=CommonLang.get("HTITLE1143")%><!--예산년도--></option> --%>
      </select>
      <select name="st_term_type" id="st_term_type" class="Select40" style="width:150px;" onchange="javascript:changeTermInit();">
        <option value=""><%=CommonLang.get("HTITLE429") %><!-- 편성기간 --></option>
        <option value = "Y"><%=CommonLang.get("HTITLE424") %><!-- 년 --></option>
        <option value = "H"><%=CommonLang.get("HTITLE425") %><!-- 반기 --></option>
        <option value = "Q"><%=CommonLang.get("HTITLE426") %><!-- 분기 --></option>
        <option value = "M"><%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
      </select>      
      <button class="But_ExcelDown40 ml10" onclick="javascript:doAction('excelDown'); return false;"><%=CommonLang.get("HTITLE35")%><!-- 양식다운로드 --></button> <button class="ButDarkGray_Medium ml05" onclick="doAction('loadExcel');return false;"><%=CommonLang.get("HTITLE1155")%><!--파일업로드--></button>
    </div>
  </div>
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag" name="pageflag" value="1">
	<input type="hidden" id="st_from_date"  name="st_from_date" value="">
	<input type="hidden" id="st_to_date"  name="st_to_date"   value="">
	<input type="hidden" id="st_term" name="st_term"  value="" readonly>
	<!-- 화면 내 정의 -->
	<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
	<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
  <div class="ScrollBox mt20 " style="height:400px">
      <script type="text/javascript">
		createIBSheet("mySheet", "100%", "100%");
	  </script>
  </div>
  </form>  
  <div class="PopupListBtnBox_Center mt50" ><button class="ButPrimary_large"  onclick="javascript:doAction('save');return false;">저장</button></div>  
</div><!-- warp 끝-->
</body>
</html>
