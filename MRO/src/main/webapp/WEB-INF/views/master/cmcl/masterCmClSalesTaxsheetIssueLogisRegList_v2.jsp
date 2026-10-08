<%--
**********************************************
* 메뉴 : 매출세금계산서>물류비 세금계산서 발행/등록
* 화면 : 물류비 세금계산서 발행/등록
* 기능 : 
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-09-17
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<script src="/resources/js/common.js"></script>
<script src="/resources/js/smartbill_common.js"></script>
<script>
<%
String flag = CommonUtil.getDevRealLocalFlag(request);
String smartbillUrl = "";
if(flag.equals("2")){
	smartbillUrl = "https://smartbill.co.kr/sb-api/request/";
}else{
	smartbillUrl = "http://demoapi.smartbill.co.kr/sb-api/request/";		
}
String user_id = "";
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
if (sessionInfo != null){
	user_id =  CommonUtil.nvl((String)sessionInfo.getUserId());
}

%>
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

var unit01 = KepSheetComboQueryIdData("masterTaxTypeListAR", "","TX02");		// IBSHEET : 세무구분
var unit02 = KepSheetComboData("TX03", "");											// IBSHEET : 발행주체
var unit03 = KepSheetComboData("SA15", "");											// IBSHEET : 결제조건(매출:SA15, 매입:SA01)
var unit04 = KepSheetComboData("SA02", "");											// IBSHEET : 결제유형(매출:수금/매입:지급)
var unit05 = KepSheetComboData("TX09", "");											// IBSHEET : 발행사이트
var unit06 = KepSheetComboData("TX10", "");											// IBSHEET : 영수,청구
var unit07 = KepSheetComboData("TX11", "");											// IBSHEET : 스마트빌 상태
var unit08 = KepSheetComboData("TX13", "");											// IBSHEET : 국세청전송결과
var unit09 = KepSheetComboData("TX14", "");											// IBSHEET : 수정사유

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,		Hidden:false,	Type:"DummyCheck",	Header:"",					SaveName:"SELECTED"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"상태",				SaveName:"STATUS"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"당사사업장",			SaveName:"KEP_IRS_NAME"}
		,{ Align:"Center",	Width:90,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Date",		Header:"작성일",				SaveName:"ISSUE_DATE",			FontColor:"#1e90ff",		Sort:0}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"사이트",				SaveName:"SITE_GUBUN_NAME"}
		,{ Align:"left",	Width:180,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"협력사명",				SaveName:"BUYER_NAME"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"사업자등록번호",		SaveName:"BUYER_IRS_NO"}
		,{ Align:"Center",	Width:90,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Combo",		Header:"세무구분",				SaveName:"TAX_TYPE_TEXT",		FontColor:"#1e90ff",		ComboText:unit01.ComboText, 	ComboCode:unit01.ComboCode}
		,{ Align:"Center",	Width:70,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Combo",		Header:"발행조건",				SaveName:"BILL_TYPE_TEXT",		FontColor:"#1e90ff",		Sort:0,		ComboText:unit02.ComboText, 	ComboCode:unit02.ComboCode}
		,{ Align:"Center",	Width:90,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Combo",		Header:"발행사이트",			SaveName:"BILL_CODE_TEXT", 		FontColor:"#1e90ff",		Sort:0, ComboText:unit05.ComboText, 	ComboCode:unit05.ComboCode}
		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"수신자이메일",			SaveName:"RECV_EMAIL"}
		,{ Align:"Center",	Width:90,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Combo",		Header:"영수/청구",			SaveName:"AR_REQ_TYPE", 		FontColor:"#1e90ff",		ComboText:unit06.ComboText, 	ComboCode:unit06.ComboCode}
		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Combo",		Header:"수정구분",				SaveName:"AMEND_CODE",			ComboText:unit09.ComboText, ComboCode:unit09.ComboCode}
		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"세금계산서",			SaveName:"TAX_BILL_NO"}
		,{ Align:"Center",	Width:210,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"스마트빌번호",			SaveName:"CONVERSATION_ID"}
		,{ Align:"Center",	Width:170,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"국세청번호",			SaveName:"ISSUE_ID"}
		,{ Align:"Center",	Width:170,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"당초승인번호",			SaveName:"ORI_ISSUE_ID"} 
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Combo",		Header:"세금계산서상태",		SaveName:"DTI_STATUS",			ComboText:unit07.ComboText, 	ComboCode:unit07.ComboCode}
		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"스마트빌메세지",		SaveName:"RETURN_DESCRIPTION"}		
		,{ Align:"right",	Width:90,	Edit:false,	EditLen:21,		Hidden:false,	Type:"Float",		Header:"공급가액",				SaveName:"SUPP_PRICE"}
		,{ Align:"right",	Width:90,	Edit:false,	EditLen:21,		Hidden:false,	Type:"Float",		Header:"세액",				SaveName:"TAX_PRICE",			FontColor:"#1e90ff"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,		Hidden:false,	Type:"Float",		Header:"합계",				SaveName:"AMT"}
		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Combo",		Header:"국세청전송결과",		SaveName:"NTS_RESULT_CODE",		ComboText:unit08.ComboText, 	ComboCode:unit08.ComboCode}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"출력일",				SaveName:"PRINT_DATE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"출력횟수",				SaveName:"PRINT_CNT"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"전송여부",				SaveName:"SEND_FLAG"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"전송일",				SaveName:"SEND_DATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"수정일",				SaveName:"CHANGE_DATE"}
		,{ Align:"left",	Width:200,	Edit:true,	EditLen:150,	Hidden:false,	Type:"Text",		Header:"비고",				SaveName:"ARDT_REMARK",			FontColor:"#1e90ff",				Sort:0}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"적요",				SaveName:"REMARK",				FontColor:"#1e90ff"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"당사사업자번호",		SaveName:"KEP_IRS_NO"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"사이트구분코드",		SaveName:"SITE_GUBUN_CODE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"고객사코드",			SaveName:"BUYER"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"제출여부",				SaveName:"CONFIRM_FLAG"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"총세액",				SaveName:"TOT_TAX_PRICE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"금액분할",				SaveName:"PARTIAL_FLAG"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"마감월",				SaveName:"CLOSE_MONTH",		Format:"Ym"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"마감차수",				SaveName:"CLOSE_REVISION"}
		,{ Align:"left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"상호(법인명)",			SaveName:"IRS_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"사업자등록번호",		SaveName:"IRS_NO"}
		,{ Align:"left",	Width:100,	Edit:true,	EditLen:150,	Hidden:false,	Type:"Text",		Header:"종사업자번호",			SaveName:"BYR_BIZPLACE_CODE"}
		,{ Align:"left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"대표자명",				SaveName:"CEO_NAME_LOC"}
		,{ Align:"left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"업태",				SaveName:"INDUSTRY_TYPE"}
		,{ Align:"left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"종목",				SaveName:"BUSINESS_ITEMS"}
		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"주소",				SaveName:"ADDRESS_LOC"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,		Hidden:false,	Type:"Float",		Header:"세금계산서 공급가액",		SaveName:"MAIN_SUP_AMOUNT"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,		Hidden:false,	Type:"Float",		Header:"세금계산서 세액",		SaveName:"MAIN_TAX_AMOUNT"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,		Hidden:false,	Type:"Float",		Header:"세금계산서 합계",		SaveName:"MAIN_TOTAL_AMOUNT"}
		,{ Align:"left",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"거래명세서",			SaveName:"DETAILARISSUE"}
		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"전자계산서발행여부",		SaveName:"E_TAX_BILL_FLAG"}
		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"전자계산서작성일자",		SaveName:"E_TAX_BILL_DATE"}
		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"ADD_USER_ID",		SaveName:"ADD_USER_ID"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_COM_IRS_NO",		SaveName:"KEP_COM_IRS_NO"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_COM_INDUSTRY_TYPE",	SaveName:"KEP_COM_INDUSTRY_TYPE"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_COM_NAME_LOC",		SaveName:"KEP_COM_NAME_LOC"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_COM_BUSINESS_ITEMS",SaveName:"KEP_COM_BUSINESS_ITEMS"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_COM_CEO_NAME_LOC",	SaveName:"KEP_COM_CEO_NAME_LOC"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_USER_NAME",			SaveName:"KEP_USER_NAME"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_USER_PHONE_NUMBER",	SaveName:"KEP_USER_PHONE_NUMBER"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_USER_EMAIL",		SaveName:"KEP_USER_EMAIL"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"REPLACE_BUYER_IRS_NO",	SaveName:"REPLACE_BUYER_IRS_NO"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"RECV_USER_NAME",		SaveName:"RECV_USER_NAME"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"RECV_PHONE_NUMBER",		SaveName:"RECV_PHONE_NUMBER"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_COM_ADDRESS_LOC",	SaveName:"KEP_COM_ADDRESS_LOC"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"AUTHTOKEN",				SaveName:"AUTHTOKEN"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"NTS_SEND_STATUS",		SaveName:"NTS_SEND_STATUS"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"STATUS_RETURN_CODE",	SaveName:"STATUS_RETURN_CODE"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"CREATED_BY",			SaveName:"CREATED_BY"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP부서",					SaveName:"DEPT_NAME"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"부서공급가액",				SaveName:"DEPT_SUPP_PRICE"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"부서세액",					SaveName:"DEPT_TAX_PRICE"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"부서금액",					SaveName:"DEPT_AMT"}
 		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"MAIN_CREATED_BY",		SaveName:"MAIN_CREATED_BY"}
	];
	var initsheet2 = {};
	initsheet2.Cols = [
   		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",					SaveName:"sStatus"}
  		,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,		Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
  		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"상태",					SaveName:"STATUS"}
  		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"당사사업장",				SaveName:"KEP_IRS_NAME"}
  		,{ Align:"Center",	Width:90,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Date",		Header:"작성일",					SaveName:"ISSUE_DATE",			FontColor:"#1e90ff",					Sort:0}
  		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"사이트",					SaveName:"SITE_GUBUN_NAME"}
  		,{ Align:"left",	Width:180,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"고객사명",					SaveName:"BUYER_NAME"}
  		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"사업자등록번호",			SaveName:"BUYER_IRS_NO"}
  		,{ Align:"Center",	Width:90,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Combo",		Header:"세무구분",					SaveName:"TAX_TYPE_TEXT",		FontColor:"#1e90ff",												ComboText:unit01.ComboText, 	ComboCode:unit01.ComboCode}
  		,{ Align:"Center",	Width:70,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Combo",		Header:"발행조건",					SaveName:"BILL_TYPE_TEXT",		FontColor:"#1e90ff",				Sort:0,		ComboText:unit02.ComboText, 	ComboCode:unit02.ComboCode}
  		,{ Align:"Center",	Width:90,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Combo",		Header:"발행사이트",				SaveName:"BILL_CODE_TEXT",		FontColor:"#1e90ff",	Sort:0, ComboText:unit05.ComboText, 	ComboCode:unit05.ComboCode}
  		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"수신자이메일",				SaveName:"RECV_EMAIL"}
  		,{ Align:"Center",	Width:90,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Combo",		Header:"영수/청구",				SaveName:"AR_REQ_TYPE", 		FontColor:"#1e90ff",	ComboText:unit06.ComboText, 	ComboCode:unit06.ComboCode}
  		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Combo",		Header:"수정구분",					SaveName:"AMEND_CODE",			ComboText:unit09.ComboText, 	ComboCode:unit09.ComboCode}
  		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"세금계산서",				SaveName:"TAX_BILL_NO"}
  		,{ Align:"Center",	Width:210,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"스마트빌번호",				SaveName:"CONVERSATION_ID"}
  		,{ Align:"Center",	Width:170,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"국세청번호",				SaveName:"ISSUE_ID"}
  		,{ Align:"Center",	Width:170,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"당초승인번호",				SaveName:"ORI_ISSUE_ID"}
  		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Combo",		Header:"세금계산서상태",			SaveName:"DTI_STATUS",			ComboText:unit07.ComboText, 	ComboCode:unit07.ComboCode}
  		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"스마트빌메세지",			SaveName:"RETURN_DESCRIPTION"}
  		,{ Align:"right",	Width:90,	Edit:false,	EditLen:21,		Hidden:false,	Type:"Float",		Header:"공급가액",					SaveName:"SUPP_PRICE"}
  		,{ Align:"right",	Width:90,	Edit:false,	EditLen:21,		Hidden:false,	Type:"Float",		Header:"세액",					SaveName:"TAX_PRICE",			FontColor:"#1e90ff"}
  		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,		Hidden:false,	Type:"Float",		Header:"합계",					SaveName:"AMT"}
  		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Combo",		Header:"국세청전송결과",			SaveName:"NTS_RESULT_CODE",		ComboText:unit08.ComboText, 	ComboCode:unit08.ComboCode}
  		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"출력일",					SaveName:"PRINT_DATE"}
  		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"출력횟수",					SaveName:"PRINT_CNT"}
  		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"전송여부",					SaveName:"SEND_FLAG"}
  		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"전송일",					SaveName:"SEND_DATE"}
  		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"수정일",					SaveName:"CHANGE_DATE"}
  		,{ Align:"left",	Width:200,	Edit:true,	EditLen:150,	Hidden:false,	Type:"Text",		Header:"비고",					SaveName:"ARDT_REMARK"}
  		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"적요",					SaveName:"REMARK",				FontColor:"#1e90ff"}
  		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"당사사업자번호",			SaveName:"KEP_IRS_NO"}
  		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"사이트구분코드",			SaveName:"SITE_GUBUN_CODE"}
  		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"고객사코드",				SaveName:"BUYER"}
  		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"제출여부",					SaveName:"CONFIRM_FLAG"}
  		,{ Align:"right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"총세액",					SaveName:"TOT_TAX_PRICE"}
  		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"금액분할",					SaveName:"PARTIAL_FLAG"}
  		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"마감월",					SaveName:"CLOSE_MONTH",			Format:"Ym"}
  		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"마감차수",					SaveName:"CLOSE_REVISION"}
  		,{ Align:"left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"상호(법인명)",				SaveName:"IRS_NAME"}
  		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"사업자등록번호",			SaveName:"IRS_NO"}
  		,{ Align:"left",	Width:100,	Edit:true,	EditLen:150,	Hidden:false,	Type:"Text",		Header:"종사업자번호",				SaveName:"BYR_BIZPLACE_CODE"}
  		,{ Align:"left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"대표자명",					SaveName:"CEO_NAME_LOC"}
  		,{ Align:"left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"업태",					SaveName:"INDUSTRY_TYPE"}
  		,{ Align:"left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"종목",					SaveName:"BUSINESS_ITEMS"}
  		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"주소",					SaveName:"ADDRESS_LOC"}
  		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,		Hidden:false,	Type:"Float",		Header:"세금계산서 공급가액",			SaveName:"MAIN_SUP_AMOUNT"}
  		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,		Hidden:false,	Type:"Float",		Header:"세금계산서 세액",			SaveName:"MAIN_TAX_AMOUNT"}
  		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,		Hidden:false,	Type:"Float",		Header:"세금계산서 합계",			SaveName:"MAIN_TOTAL_AMOUNT"}
  		,{ Align:"left",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"거래명세서",				SaveName:"DETAILARISSUE"}
  		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"전자계산서발행여부",			SaveName:"E_TAX_BILL_FLAG"}
  		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"전자계산서작성일자",			SaveName:"E_TAX_BILL_DATE"}
  		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"ADD_USER_ID",			SaveName:"ADD_USER_ID"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_COM_IRS_NO",		SaveName:"KEP_COM_IRS_NO"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_COM_INDUSTRY_TYPE",	SaveName:"KEP_COM_INDUSTRY_TYPE"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_COM_NAME_LOC",		SaveName:"KEP_COM_NAME_LOC"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_COM_BUSINESS_ITEMS",SaveName:"KEP_COM_BUSINESS_ITEMS"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_COM_CEO_NAME_LOC",	SaveName:"KEP_COM_CEO_NAME_LOC"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_USER_NAME",			SaveName:"KEP_USER_NAME"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_USER_PHONE_NUMBER",	SaveName:"KEP_USER_PHONE_NUMBER"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_USER_EMAIL",		SaveName:"KEP_USER_EMAIL"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"REPLACE_BUYER_IRS_NO",	SaveName:"REPLACE_BUYER_IRS_NO"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"RECV_USER_NAME",		SaveName:"RECV_USER_NAME"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"RECV_PHONE_NUMBER",		SaveName:"RECV_PHONE_NUMBER"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_COM_ADDRESS_LOC",	SaveName:"KEP_COM_ADDRESS_LOC"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"AUTHTOKEN",				SaveName:"AUTHTOKEN"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"NTS_SEND_STATUS",		SaveName:"NTS_SEND_STATUS"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"STATUS_RETURN_CODE",	SaveName:"STATUS_RETURN_CODE"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"CREATED_BY",			SaveName:"CREATED_BY"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP부서",					SaveName:"DEPT_NAME"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"부서공급가액",				SaveName:"DEPT_SUPP_PRICE"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"부서세액",					SaveName:"DEPT_TAX_PRICE"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"부서금액",					SaveName:"DEPT_AMT"}
   		,{ Align:"left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"MAIN_CREATED_BY",		SaveName:"MAIN_CREATED_BY"}
	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);
	IBS_InitSheet(mySheet2, initsheet2, pagingMode);
	mySheet.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	
	// 하이퍼링크 설정
	setLinkCol(mySheet, "RECV_EMAIL"); // 담당자이메일
	setLinkCol(mySheet, "TAX_PRICE"); // 세액
	setLinkCol(mySheet, "REMARK"); // 적요
	
	// 행복사 타이틀 설정
	mySheet.SetCellFontUnderline(0, "ISSUE_DATE", true);
	mySheet.SetCellFontUnderline(0, "PAY_TERMS", true);
// 	mySheet.SetCellFontUnderline(0, "PAY_TYPE", true);
// 	mySheet.SetCellFontUnderline(0, "TAX_TYPE_TEXT", true);
	mySheet.SetCellFontUnderline(0, "BILL_TYPE_TEXT", true);
	mySheet.SetCellFontUnderline(0, "BILL_CODE_TEXT", true);
	mySheet.SetCellFontUnderline(0, "ARDT_REMARK", true);
	kepAjaxCommonQueryIdCombo('st_user_dept','master.mdcd.selectMasterMdCdBuyerCardManageDeptList99','ALL', '');							// 조회조건 : 부서
	//IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");

	// 초기화 설정
	resetValue();
}

// 초기화 설정
function resetValue() {
	// 일자 설정
	var tempDate = kepToMonthAdd("1","M").replace(/[/]/gi,"");
	var tempYear = tempDate.substring(0,4);
	var tempMonth = tempDate.substring(4,6);
	var tempDay = lastDay(tempYear, tempMonth, "");
	$("#st_from_date").val( kepGetDateStr(tempYear+tempMonth+"01", "/") );
	$("#st_to_date").val( kepGetDateStr(tempDay, "/") );
	
	// 콤보데이터 셋팅
	kepAjaxCommonQueryIdSearchTwoCombo('st_add_user_id','common.masterDepartmentUserList','PG_10_M_006_00','','ALL','${sessionInfo.userId}'); // 조회조건 : 담당자

	// 회계부서만 담당자 콤보박스 변경 가능
	$("#st_add_user_id").attr("disabled", false);
	/*
	if ( $("#st_dept_code").val() == '005' ||$("#st_dept_code").val() == '095') {
		$("#st_add_user_id").attr("disabled", false);
	} else {
		$("#st_add_user_id").attr("disabled", true);
	}
	*/
	// 조회조건 hidden 설정
	$("#st_buyer_code").val("");
	
	// 기타 설정
	$("#job_kind").val("");
	$("#buyerTotAmt").html("0");
	$("#buyerAmt").html("0");
	$("#buyerTaxAmt").html("0");
}

// 현재달의 마지막날(일자) 구하기
function lastDay(y , m , kind) {
	var d2, s = "";           
    var year, month, day;           

    d2 = new Date(y,m,"");
   
    year  = d2.getFullYear();                          
	month = (d2.getMonth()+1);
    day   = d2.getDate();
	
	if ( month < 10 ) {
		month = "0" + month;
    }
	if ( day < 10 ) {
		day = "0" + day;
    }

	s = String(year) + String(month) + String(day);

	return(s);                             
}

var st;
var mt;

// 그리드 표시후 처리
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
var g_paramInfo = ""; //취소시 정보
var g_send_irs_no =""; //취소시공급자사업자번호
var g_recv_irs_no =""; //취소시공급받는자사업번호
var g_ar_no = "";  //취소시AR_NO
var g_authtoken = ""; //토근
var g_tax_type = ""; //과세구분
var g_ori_issue_id = ""; //당초세금계산서번호
var g_buyer = ""; //고객사코드
// 기능함수
function doAction(str) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if ( str !="search" && str !="excelDown" && str !="excelDetailDown" && str !="reload" && str != "ARconfirm" && selectedGrid.length == 0 ) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	if ( str == "search" ) {
		if ( $('input:radio[name="st_job_type"]:checked').val() == "A2" ) {
			$("#job_type").val("BNT");
		} else {
			$("#job_type").val("ORG");
		}
	}
	switch (str) {
		case "search": // 조회
			// 조회조건 체크
			if ( !searchValidate() )
				return;
			$("#job_kind").val("");
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/cmcl/getMasterCmClSalesTaxsheetLogisIssueRegList.do" , pagingMode );
			break;
	
		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			mySheet2.RemoveAll();
			break;   
	
		case "confirm": // 확정
			if ( !validationConfirm() )
				return;
			if ( !confirm('세금계산서를 확정 하시겠습니까?') )
				return;
			$("#job_kind").val("confirm");
			kepSave(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClSalesTaxsheetLogisIssueRegList.do" , "SELECTED" );
			break;
	
		case "confirmCancle": // 확정취소
			if ( !validationConfirmCancle() )
				return;
			if ( !confirm('세금계산서 확정을 취소 하시겠습니까?') )
				return;
			$("#job_kind").val("confirmCancle");
			kepSave(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClSalesTaxsheetLogisIssueRegList.do" , "SELECTED" );
			break;
	
		case "delete": // 삭제
			if ( !validationDelete() )
				return;
			if ( !confirm('세금계산서를 삭제 하시겠습니까?') )
				return;
			$("#job_kind").val("delete");
			kepSave(document.searchCondition ,  mySheet , "/cmcl/delMasterCmClSalesTaxsheetLogisIssueRegList_v2.do" , "SELECTED" );
			break;
		case "delete2": // 수정삭제
			if ( !validationDelete2() )
				return;
			if ( !confirm('수정 세금계산서를 삭제 하시겠습니까?') )
				return;
			$("#job_kind").val("delete");
			kepSave(document.searchCondition ,  mySheet , "/cmcl/delMasterCmClSalesTaxsheetLogisIssueRegList_v2.do" , "SELECTED" );
			break;
		case "update": // 수정
			if ( !validationUpdate() )
				return;
			if ( !confirm('세금계산서를 수정 하시겠습니까?') )
				return;
			$("#job_kind").val("update");
			kepSave(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClSalesTaxsheetIssueRegList.do" , "SELECTED" );
			break;
	
		case "ARsend": // 전송
			if ( !validationARsend() )
				return;
			if ( !confirm('세금계산서를 전송 하시겠습니까?') )
				return;
			$("#job_kind").val("ARsend");
			kepSave(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClSalesTaxsheetIssueRegList.do" , "SELECTED" );
			break;
		case "ARconfirm": // 마감제출
			if ( !validationArConfirm() )
				return;
			if ( !confirm('선택된 행과 상관없이 마감 미제출 건에 대해 제출됩니다.\n마감제출 하시겠습니까?') )
				return;
			$("#job_kind").val("ARconfirm");
			kepSave(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClSalesTaxsheetIssueRegList.do" , "SELECTED" );
			break;
	
		case "ARreverse": // 전송취소
			if ( !validationARreverse() )
				return;
			if ( !confirm('세금계산서를 전송취소 하시겠습니까?') )
				return;
			$("#job_kind").val("ARreverse");
			kepSave(document.searchCondition ,  mySheet , "/cmcl/ARreverseMasterCmClSalesTaxsheetIssueRegList.do" , "SELECTED" );
			break;
	
		case "excelDown": // 엑셀다운로드
			$("#job_kind").val("excelDown");
			var param = {FileName:"매출세금계산서발행.xlsx",DownCols:"STATUS|KEP_IRS_NAME|ISSUE_DATE|SITE_GUBUN_NAME|BUYER_NAME|BUYER_IRS_NO|TAX_TYPE_TEXT|BILL_TYPE_TEXT|BILL_CODE_TEXT|SUPP_PRICE|TAX_PRICE|AMT|PRINT_DATE|PRINT_CNT|TAX_BILL_NO|SEND_FLAG|SEND_DATE|CHANGE_DATE|REMARK|KEP_IRS_NO|SITE_GUBUN_CODE|BUYER|CONFIRM_FLAG|TOT_TAX_PRICE|PARTIAL_FLAG|CLOSE_MONTH|CLOSE_REVISION|IRS_NAME|IRS_NO|CEO_NAME_LOC|INDUSTRY_TYPE|BUSINESS_ITEMS|ADDRESS_LOC|E_TAX_BILL_FLAG|E_TAX_BILL_DATE"};
			kepDownExcel(document.searchCondition ,mySheet , "/cmcl/excelMasterCmClSalesTaxsheetLogisIssueRegList.do", param);
			break;
		case "send": // 전송
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow     = selectedGrid.split("|");
			var paramInfo = "";
			var ar_no = "";
			var recv_irs_no = "";
			var send_irs_no = "";
			var processYn= sendvalCheck();
			if(processYn == "N")return;
			if(processYn == "U"){
				if (confirm("변경된 정보가 있습니다.저장하지 않으면 정보는 사라집니다.\n계속 진행 하시겠습니까?")==false) return;
			}
			loader_obj("Y");
			for (var i=0; i<arrRow.length; i++){
				/*
					0공급자 사업자등록번호 KEP_COM_IRS_NO
					1공급업체의 업태 텍스트 KEP_COM_INDUSTRY_TYPE
					2공급업체 사업체명    KEP_COM_NAME_LOC
					3공급업체의 업종      KEP_COM_BUSINESS_ITEMS
					4공급업체 대표자명    KEP_COM_CEO_NAME_LOC
					5공급업체 담당자명     KEP_USER_NAME
					6공급업체 담당자 전화번호  KEP_USER_PHONE_NUMBER
					7공급업체 담당자 이메일    KEP_USER_EMAIL
					8공급업체의 주소      KEP_COM_ADDRESS_LOC
					9공급받는자 사업자등록번호 IRS_NO
					10공급받는자의 업태 텍스트 INDUSTRY_TYPE
					11공급받는자 사업체명     IRS_NAME
					12공급받는자의 업종         BUSINESS_ITEMS
					13공급받는대표자명       CEO_NAME_LOC
					14공급받는 담당자명           현명환                     -추가작업
					15공급받는자 담당자 전화번호   02-3016-8919     -추가작업
					16공급받는자 담당자 이메일     myunghwanhyun@koreab2b.com -추가작업
					17공급받는자 주소            ADDRESS_LOC
					18물품 공급 가액          SUPP_PRICE
					19물품 공급세액      TAX_PRICE
					20매출매입구분 AR+AP
					21역발행정발행 1,2
					22과세면세영세 구분 01과세 정리필요
					23청구영수 0102 
					24세금계산서번호AR AP
					25계산서총금액
					26typeCode 
					27계산서상태
					28작성일자
					29비고
					30종사업자번호
					31 CONVERSATION_ID
					32 ISSUE_ID
					
				*/
				var tax_bil_type= mySheet.GetCellValue(arrRow[i],"TAX_TYPE_TEXT");
				//인증토큰
				var authtoken= mySheet.GetCellValue(arrRow[i],"AUTHTOKEN");
				var typeCodeSb = "";
				var typeCodeSb1 = "";				
				// AR번호
				ar_no = mySheet.GetCellValue(arrRow[i],"TAX_BILL_NO");
				if(tax_bil_type == "11" ){ //과세
					typeCodeSb= "0101";
					typeCodeSb1 = "01";
				}else if(tax_bil_type == "12"){ //영세
					typeCodeSb ="0102";
					typeCodeSb1 = "02";
				}else if(tax_bil_type == "13"){ //면세
					typeCodeSb ="0301";
					typeCodeSb1 = "03";
				}
				paramInfo    = mySheet.GetCellValue(arrRow[i],"KEP_COM_IRS_NO")+"@@"+mySheet.GetCellValue(arrRow[i],"KEP_COM_INDUSTRY_TYPE")+"@@"+mySheet.GetCellValue(arrRow[i],"KEP_COM_NAME_LOC")
				+"@@"+mySheet.GetCellValue(arrRow[i],"KEP_COM_BUSINESS_ITEMS")+"@@"+mySheet.GetCellValue(arrRow[i],"KEP_COM_CEO_NAME_LOC")+"@@"+mySheet.GetCellValue(arrRow[i],"KEP_USER_NAME")
				+"@@"+mySheet.GetCellValue(arrRow[i],"KEP_USER_PHONE_NUMBER")+"@@"+mySheet.GetCellValue(arrRow[i],"KEP_USER_EMAIL")+"@@"+mySheet.GetCellValue(arrRow[i],"KEP_COM_ADDRESS_LOC")
				+"@@"+mySheet.GetCellValue(arrRow[i],"REPLACE_BUYER_IRS_NO")+"@@"+mySheet.GetCellValue(arrRow[i],"INDUSTRY_TYPE")+"@@"+mySheet.GetCellValue(arrRow[i],"IRS_NAME")
				+"@@"+mySheet.GetCellValue(arrRow[i],"BUSINESS_ITEMS")+"@@"+mySheet.GetCellValue(arrRow[i],"CEO_NAME_LOC")+"@@"+mySheet.GetCellValue(arrRow[i],"RECV_USER_NAME")
				+"@@"+mySheet.GetCellValue(arrRow[i],"RECV_PHONE_NUMBER")+"@@"+mySheet.GetCellValue(arrRow[i],"RECV_EMAIL")
				+"@@"+mySheet.GetCellValue(arrRow[i],"ADDRESS_LOC")+"@@"+mySheet.GetCellValue(arrRow[i],"SUPP_PRICE")+"@@"+mySheet.GetCellValue(arrRow[i],"TAX_PRICE")+"@@AR"+"@@2"
				+"@@"+typeCodeSb1+"@@"+mySheet.GetCellValue(arrRow[i],"AR_REQ_TYPE")
				+"@@"+ mySheet.GetCellValue(arrRow[i],"TAX_BILL_NO")+"@@"+ mySheet.GetCellValue(arrRow[i],"AMT")+"@@"+typeCodeSb+"@@"+mySheet.GetCellValue(arrRow[i],"DTI_STATUS")
				+"@@"+mySheet.GetCellValue(arrRow[i],"ISSUE_DATE")+"@@"+mySheet.GetCellValue(arrRow[i],"ARDT_REMARK")+"@@"+mySheet.GetCellValue(arrRow[i],"BYR_BIZPLACE_CODE")
				+"@@"+ mySheet.GetCellValue(arrRow[i],"CONVERSATION_ID")+"@@"+ mySheet.GetCellValue(arrRow[i],"ISSUE_ID");
				// 공급자사업자번호
				send_irs_no = mySheet.GetCellValue(arrRow[i],"KEP_COM_IRS_NO");
				// 공급받는자 사업자 번호
				recv_irs_no = mySheet.GetCellValue(arrRow[i],"REPLACE_BUYER_IRS_NO");
				var detailArIssue = mySheet.GetCellValue(arrRow[i],"DETAILARISSUE"); 
				//getSendSmartBillFormat(paramInfo,send_irs_no,recv_irs_no,ar_no,authtoken,"I","S","A");
				//정보, 공급자사업자번호, 공급받는자사업자번호, ar_no, 토근, 상태, 세금계산서정상/취소구분/계산서/계산서취소(S/R) ,정발행역발행구분(A/B)
				var toRow = i+1;
				var totalRow = arrRow.length;
				getSendFormat(paramInfo,send_irs_no,recv_irs_no,ar_no,authtoken,"I","S","A","","",totalRow,toRow,"",detailArIssue,"","","",mySheet.GetCellValue(arrRow[i],"BUYER"));
			}
			break;
		case "rsend": //수정/삭제
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow     = selectedGrid.split("|");			
			var processYn= sendvalRCheck();
			if(processYn == "N")return;	
			//loader_obj("Y");
			for (var i=0; i<arrRow.length; i++){
				/*
					0공급자 사업자등록번호 KEP_COM_IRS_NO
					1공급업체의 업태 텍스트 KEP_COM_INDUSTRY_TYPE
					2공급업체 사업체명    KEP_COM_NAME_LOC
					3공급업체의 업종      KEP_COM_BUSINESS_ITEMS
					4공급업체 대표자명    KEP_COM_CEO_NAME_LOC
					5공급업체 담당자명     KEP_USER_NAME
					6공급업체 담당자 전화번호  KEP_USER_PHONE_NUMBER
					7공급업체 담당자 이메일    KEP_USER_EMAIL
					8공급업체의 주소      KEP_COM_ADDRESS_LOC
					9공급받는자 사업자등록번호 IRS_NO
					10공급받는자의 업태 텍스트 INDUSTRY_TYPE
					11공급받는자 사업체명     IRS_NAME
					12공급받는자의 업종         BUSINESS_ITEMS
					13공급받는대표자명       CEO_NAME_LOC
					14공급받는 담당자명           현명환                     -추가작업
					15공급받는자 담당자 전화번호   02-3016-8919     -추가작업
					16공급받는자 담당자 이메일     myunghwanhyun@koreab2b.com -추가작업
					17공급받는자 주소            ADDRESS_LOC
					18물품 공급 가액          SUPP_PRICE
					19물품 공급세액      TAX_PRICE
					20매출매입구분 AR+AP
					21역발행정발행 1,2
					22과세면세영세 구분 01과세 정리필요
					23청구영수 0102 
					24세금계산서번호AR AP
					25계산서총금액
					26typeCode  01(세금계산서), 02(수정세금계산서), 03(계산서), 04(수정계산서)/세금계산서 종류(2자리) : 01(일반), 02(영세율), 03(일반 위수탁), 04(수입), 05(영세율 위수탁)
					27계산서상태
					28작성일자
					29비고
					30종사업자번호
					31 CONVERSATION_ID
					32 ISSUE_ID
					33 수정사유//취소사유
					34 당초ISSIE_ID
				*/
				var tax_bil_type= mySheet.GetCellValue(arrRow[i],"TAX_TYPE_TEXT");
				//인증토큰
				g_authtoken = mySheet.GetCellValue(arrRow[i],"AUTHTOKEN");
				// AR번호
				 g_ar_no = mySheet.GetCellValue(arrRow[i],"TAX_BILL_NO");
				// 국세청전송상태
				var ntsSendStatus = mySheet.GetCellValue(arrRow[i],"NTS_SEND_STATUS");
				var typeCodeSb = "";
				var typeCodeSb1 = "";		
				g_tax_type = tax_bil_type;
				if(tax_bil_type == "11" ){ //과세
					typeCodeSb= "0201";
					typeCodeSb1 = "01";
				}else if(tax_bil_type == "12"){ //영세
					typeCodeSb ="0202";
					typeCodeSb1 = "02";
				}else if(tax_bil_type == "13"){ //면세
					typeCodeSb ="0401";
					typeCodeSb1 = "03";
				}				
				g_paramInfo    = mySheet.GetCellValue(arrRow[i],"KEP_COM_IRS_NO")+"@@"+mySheet.GetCellValue(arrRow[i],"KEP_COM_INDUSTRY_TYPE")+"@@"+mySheet.GetCellValue(arrRow[i],"KEP_COM_NAME_LOC")
				+"@@"+mySheet.GetCellValue(arrRow[i],"KEP_COM_BUSINESS_ITEMS")+"@@"+mySheet.GetCellValue(arrRow[i],"KEP_COM_CEO_NAME_LOC")+"@@"+mySheet.GetCellValue(arrRow[i],"KEP_USER_NAME")
				+"@@"+mySheet.GetCellValue(arrRow[i],"KEP_USER_PHONE_NUMBER")+"@@"+mySheet.GetCellValue(arrRow[i],"KEP_USER_EMAIL")+"@@"+mySheet.GetCellValue(arrRow[i],"KEP_COM_ADDRESS_LOC")
				+"@@"+mySheet.GetCellValue(arrRow[i],"REPLACE_BUYER_IRS_NO")+"@@"+mySheet.GetCellValue(arrRow[i],"INDUSTRY_TYPE")+"@@"+mySheet.GetCellValue(arrRow[i],"IRS_NAME")
				+"@@"+mySheet.GetCellValue(arrRow[i],"BUSINESS_ITEMS")+"@@"+mySheet.GetCellValue(arrRow[i],"CEO_NAME_LOC")+"@@"+mySheet.GetCellValue(arrRow[i],"RECV_USER_NAME")
				+"@@"+mySheet.GetCellValue(arrRow[i],"RECV_PHONE_NUMBER")+"@@"+mySheet.GetCellValue(arrRow[i],"RECV_EMAIL")
				+"@@"+mySheet.GetCellValue(arrRow[i],"ADDRESS_LOC")+"@@"+mySheet.GetCellValue(arrRow[i],"SUPP_PRICE")*-1+"@@"+mySheet.GetCellValue(arrRow[i],"TAX_PRICE")*-1+"@@AR"+"@@2"
				+"@@"+typeCodeSb1+"@@"+mySheet.GetCellValue(arrRow[i],"AR_REQ_TYPE")
				+"@@"+ mySheet.GetCellValue(arrRow[i],"TAX_BILL_NO")+"@@"+ mySheet.GetCellValue(arrRow[i],"AMT")*-1+"@@"+typeCodeSb+"@@"+mySheet.GetCellValue(arrRow[i],"DTI_STATUS")
				+"@@"+mySheet.GetCellValue(arrRow[i],"ISSUE_DATE")+"@@"+ mySheet.GetCellValue(arrRow[i],"ARDT_REMARK")+"@@"+mySheet.GetCellValue(arrRow[i],"BYR_BIZPLACE_CODE")
				+"@@"+ mySheet.GetCellValue(arrRow[i],"CONVERSATION_ID")+"@@"+ mySheet.GetCellValue(arrRow[i],"ISSUE_ID");
				// 공급자사업자번호
				g_send_irs_no = mySheet.GetCellValue(arrRow[i],"KEP_COM_IRS_NO");
				// 공급받는자 사업자 번호
				g_recv_irs_no = mySheet.GetCellValue(arrRow[i],"REPLACE_BUYER_IRS_NO");
				//당초세금계산서
				g_ori_issue_id = mySheet.GetCellValue(arrRow[i],"ISSUE_ID");
				//고객사코드
				g_buyer= mySheet.GetCellValue(arrRow[i],"BUYER");
				//국세청 미전송일경우
				if(ntsSendStatus == "7"||mySheet.GetCellValue(arrRow[i],"DTI_STATUS") =="C"||mySheet.GetCellValue(arrRow[i],"CONVERSATION_ID")==""){
					//국세청전송후
					var irsNo = mySheet.GetCellValue(arrRow[i],"IRS_NO");
					var supMail = mySheet.GetCellValue(arrRow[i],"KEP_USER_EMAIL");
					var issueDate = mySheet.GetCellValue(arrRow[i],"ISSUE_DATE");
					var params = "?st_kep_irs="+irsNo+"&st_sup_email="+supMail+"&st_issueDate="+issueDate;
					doPop('masterCmClStndModifySettingPop', params);
				}else{
					openSearchPopup('/mppo/showBuyerMpPoRejectReasonPop.do','?openYn=O',"500,280,no");		
				}
			}
			break;
		case "excelDetailDown": // 상세다운로드
			$("#job_kind").val("excelDetailDown");
			var param = {FileName:"매출세금계산서발행_상세내역.xlsx",DownCols:"STATUS|KEP_IRS_NAME|ISSUE_DATE|SITE_GUBUN_NAME|BUYER_NAME|BUYER_IRS_NO|TAX_BILL_NO|SUPP_PRICE|TAX_PRICE|AMT|DEPT_NAME|DEPT_SUPP_PRICE|DEPT_TAX_PRICE|DEPT_AMT|PRINT_DATE|TAX_TYPE_TEXT|BILL_TYPE_TEXT|SEND_FLAG|SEND_DATE|CHANGE_DATE|REMARK|KEP_IRS_NO|BUYER|IRS_NAME|IRS_NO|CEO_NAME_LOC|INDUSTRY_TYPE|BUSINESS_ITEMS|ADDRESS_LOC"};
			kepDownExcel(document.searchCondition ,mySheet , "/cmcl/excelMasterCmClSalesTaxsheetLogisIssueRegList.do", param);
			break;
		case "IssueSendInfo": // 국세청전송
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow     = selectedGrid.split("|");
			var processYn= issueSendInfoValCheck();
			if(processYn == "N")return;
			var arrConvId = new Array();
			var authtoken = "";
			var send_irs_no = "";
			var ar_no = "";
			var buyer = "";
			for (var i=0; i<arrRow.length; i++){
				arrConvId[i] = mySheet.GetCellValue(arrRow[i],"CONVERSATION_ID");
				authtoken= mySheet.GetCellValue(arrRow[i],"AUTHTOKEN");
				send_irs_no = mySheet.GetCellValue(arrRow[i],"KEP_COM_IRS_NO");
				ar_no = mySheet.GetCellValue(arrRow[i],"TAX_BILL_NO");
				buyer = mySheet.GetCellValue(arrRow[i],"BUYER");
			}
			getSendFormat("",send_irs_no,"","",authtoken,"","","","","","1","1","","","Y",arrConvId,ar_no,buyer);
			break;

	}

}
/*
function getSendSmartBillFormat(paramInfo,send_irs_no,recv_irs_no,ar_no,authtoken,gbn,gbn2,gbn3,gbn4,gbn5){
	
	document.forms.processForm.param1.value = paramInfo;
	document.forms.processForm.param2.value = document.forms.searchCondition.st_user_id.value;
	document.forms.processForm.param3.value = gbn;
	document.forms.processForm.param4.value = gbn2;
	document.forms.processForm.param5.value = gbn3;
	document.forms.processForm._authtoken.value = authtoken;
	kepAjaxFormCall("/cmcl/SendARMasterCmClSalesTaxsheetIssueRegList.do","processForm","smartBill");
}*/
//국세청전송 체크 데이터 모듈.
function issueSendInfoValCheck(){
	var valCheck = "Y";
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	var cnt = 0;
	for (var j=0; j<arrRow.length; j++){
		var dtiStatus= mySheet.GetCellValue(arrRow[j],"DTI_STATUS");
		var ar_no = mySheet.GetCellValue(arrRow[j],"TAX_BILL_NO");
		if(dtiStatus != "C" && dtiStatus != "I"){
			alert("AR번호:"+ar_no+"\n수신승인, 수신미승인 상태일때만 국세청 전송이 가능합니다.");
			valCheck = "N";
			return valCheck;			
		}
	}

	return valCheck;
}
//세금계산서 삭제
function validationsendDelete(){
	var userId = $("#st_user_id").val();

	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
        if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
 	       if (mySheet.GetCellValue(i, "DTI_STATUS") != "E" ) {
	        	alert("전송오류건이 아닙니다.");
				return false;
			}        	
	       if (mySheet.GetCellValue(i, "MAIN_CREATED_BY") != userId ) {
	        	alert("등록자 본인 건만 삭제 할 수 있습니다.");
				return false;
			}
            if ( mySheet.GetCellValue(i, "BILL_CODE_TEXT") != "41000008"||mySheet.GetCellValue(i, "CONVERSATION_ID") =="") {
				alert("발행사이트 SMART BILL만 삭제 가능합니다.");
				return false;
			}
            if ( mySheet.GetCellValue(i, "STATUS_RETURN_CODE") == "30000") {
				alert("세금계산서 전송된건은 삭제가 불가능 합니다.");
				return false;
			}
            if(mySheet.GetCellValue(i, "DTI_STATUS") != 'O'&&mySheet.GetCellValue(i, "STATUS_RETURN_CODE") == "30000"){
            	alert("세금계산서 상태가 발행취소인 경우만 가능 합니다.");
				return false;            	
            }
    		var sendFlag= mySheet.GetCellValue(i,"SEND_FLAG");
    		
    		if(sendFlag == "전송"){
    			alert("AR번호:"+ar_no+"\nKHRM 전송된건이므로 세금계산서 삭제가 불가능 합니다. ");
    			valCheck = "N";
    			return false;			
    		}
            /*
            if(mySheet.GetCellValue(i, "ORI_ISSUE_ID") != null){
				alert("수정게산서는 삭제가 불가능 합니다.");
				return false;            	
            }*/
		}
	}
	
	return true;
}
//사유
function setReason(value){
	loader_obj("Y");
	////정보, 공급자사업자번호, 공급받는자사업자번호, ar_no, 토근, 상태, 세금계산서 정상/취소/수정세금계산서(S/R/M) ,정발행역발행구분(A/B), 취소사유, 과세영세면세구분
	g_paramInfo = g_paramInfo+"@@"+value;
	getSendFormat(g_paramInfo,g_send_irs_no,g_recv_irs_no,g_ar_no,g_authtoken,"O","R","A",value,g_tax_type,"1","1",value,"","",g_buyer);
	
}
//삭제체크 데이터 모듈.
function sendvalRCheck(){
	var valCheck = "Y";
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	var cnt = 0;
	for (var j=0; j<arrRow.length; j++){
		// AR번호
		var ar_no = mySheet.GetCellValue(arrRow[j],"TAX_BILL_NO");
		var bill_code_text= mySheet.GetCellValue(arrRow[j],"BILL_CODE_TEXT");
		var tax_bil_type= mySheet.GetCellValue(arrRow[j],"TAX_TYPE_TEXT");
		var recvEmail= mySheet.GetCellValue(arrRow[j],"RECV_EMAIL");
		var conversationId= mySheet.GetCellValue(arrRow[j],"CONVERSATION_ID");
		var issueDate= mySheet.GetCellValue(arrRow[j],"ISSUE_DATE");
		var today = kepGetNowTimeStr("YYYYMMDD","");
		var sendFlag= mySheet.GetCellValue(arrRow[j],"SEND_FLAG");
		var status= mySheet.GetCellValue(arrRow[j],"STATUS");
		var dtiStatus= mySheet.GetCellValue(arrRow[j],"DTI_STATUS");
		
		if(dtiStatus == "E"){
			alert("AR번호:"+ar_no+"\n전송오류건이므로 수정/삭제세금계산서 발행 불가능 합니다. ");
			valCheck = "N";
			return valCheck;			
		}
		if(sendFlag == "전송"){
			alert("AR번호:"+ar_no+"\nKHRM 전송된건이므로 수정/삭제세금계산서 발행 불가능 합니다. ");
			valCheck = "N";
			return valCheck;			
		}
		if(status != "미제출"){
			alert("AR번호:"+ar_no+"\n미제출건이 아니므로 수정/삭제세금계산서 발행 불가능 합니다. ");
			valCheck = "N";
			return valCheck;			
		}
		if(tax_bil_type != "11" && tax_bil_type != "12" && tax_bil_type != "13"){
			alert("AR번호:"+ar_no+"\n세무구분이 과세, 영세, 면세만 세금계산서 발행 가능합니다. ");
			valCheck = "N";
			return valCheck;
		}
		/*
		if(bill_code_text !="41000008"||mySheet.GetCellValue(arrRow[j], "CONVERSATION_ID") ==""){
			alert("AR번호:"+ar_no+"\n세금계산서 미발행 전표입니다.\n수정/삭제세금계산서 발행을 할 수 없습니다");
			valCheck = "N";
			return valCheck;
		}*/
		if(issueDate > today){
			alert("AR번호:"+ar_no+"\n금일 이후 세금계산서 전송은 불가능 합니다.");
			valCheck = "N";
			return valCheck;			
		}
		/*
		if(conversationId == "" || conversationId == null){
			alert("AR번호:"+ar_no+"\n수정/삭제 세금계산서 발행 대상이 아닙니다.");
			valCheck = "N";
			return valCheck;			
		}*/
		if(recvEmail == "" || recvEmail == null){
			alert("AR번호:"+ar_no+"\n수신자 이메일 정보가 없습니다.");
			valCheck = "N";
			return valCheck;			
		}
		
		cnt++;
	}
	if(cnt > 1){
		alert("다중 선택이 안됩니다. 확인 바람니다.");
		valCheck = "N";
		return valCheck;			
	}
	return valCheck;
}
//전송체크 데이터 모듈.
function sendvalCheck(){
	var valCheck = "Y";
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	var returnStatus = "R";
	for (var j=0; j<arrRow.length; j++){
		// AR번호
		var ar_no = mySheet.GetCellValue(arrRow[j],"TAX_BILL_NO");
		var bill_code_text= mySheet.GetCellValue(arrRow[j],"BILL_CODE_TEXT");
		var tax_bil_type= mySheet.GetCellValue(arrRow[j],"TAX_TYPE_TEXT");
		var recvEmail= mySheet.GetCellValue(arrRow[j],"RECV_EMAIL");
		var conversationId= mySheet.GetCellValue(arrRow[j],"CONVERSATION_ID");
		var issueDate= mySheet.GetCellValue(arrRow[j],"ISSUE_DATE");
		var biiTypeText= mySheet.GetCellValue(arrRow[j],"BILL_TYPE_TEXT");
		var sStatus= mySheet.GetCellValue(arrRow[j],"sStatus");
		var today = kepGetNowTimeStr("YYYYMMDD","");
		var sendFlag= mySheet.GetCellValue(arrRow[j],"SEND_FLAG");
		var status= mySheet.GetCellValue(arrRow[j],"STATUS");
		var dtiStatus= mySheet.GetCellValue(arrRow[j],"DTI_STATUS");
		
		if(sStatus == "U"){
			returnStatus = sStatus;
		}
		if(status != "미제출"){
			alert("AR번호:"+ar_no+"\n미제출건이 아니므로 수정/삭제세금계산서 발행 불가능 합니다. ");
			valCheck = "N";
			return valCheck;			
		}
		if(sendFlag == "전송"){
			alert("AR번호:"+ar_no+"\nKHRM 전송된건이므로 세금계산서 발행 불가능 합니다. ");
			valCheck = "N";
			return valCheck;			
		}
		if(tax_bil_type != "11" && tax_bil_type != "12" && tax_bil_type != "13"){
			alert("AR번호:"+ar_no+"\n세무구분이 과세, 영세, 면세만 세금계산서 발행 가능합니다. ");
			valCheck = "N";
			return valCheck;
		}
		if(biiTypeText != "10"){
			alert("AR번호:"+ar_no+"\n매출은 발행조건이 KEP인 정발행세금계산서만 발행할 수 있습니다");
			valCheck = "N";
			return valCheck;			
		}
		if(bill_code_text !="41000008"){
			alert("AR번호:"+ar_no+"\n발행사이트 SMART BILL만 세금계산서 발행 가능합니다.");
			valCheck = "N";
			return valCheck;
		}
		if(issueDate > today){
			alert("AR번호:"+ar_no+"\금일 이후 세금계산서 전송은 불가능 합니다.");
			valCheck = "N";
			return valCheck;			
		}
		if(conversationId != "" && conversationId != null && dtiStatus != "E"){
			alert("AR번호:"+ar_no+"\n세금계산서 발행된 건입니다.");
			valCheck = "N";
			return valCheck;			
		}
		if(recvEmail == "" || recvEmail == null){
			alert("AR번호:"+ar_no+"\n수신자 이메일 정보가 없습니다.");
			valCheck = "N";
			return valCheck;			
		}
	}
	if(returnStatus == "U"){
		valCheck = "U";
	}
	return valCheck;
}

function  kepAjaxError(pMethod , response) {
	 alert("전송 에러가 발생했습니다.");
	 doAction('search');	
}
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "smartBill"){
		 alert("처리되었습니다.");
		 doAction('search');		
	}else if(pMethod == "errorSmartBill"){
		loader_obj("N");
		 alert("전송 실패하였습니다. ");
		 doAction('search');					 
		 return;
	}
}
function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

}
function mySheet2_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

}
// 조회조건 체크
function searchValidate() {
	var start_date = $("#st_from_date").val().replace(/[/]/gi,"");
	var end_date = $("#st_to_date").val().replace(/[/]/gi,"");
	if(document.forms.searchCondition.st_checkbox.checked == true){
		document.forms.searchCondition.st_send_gbn.value = "Y";
	}else{
		document.forms.searchCondition.st_send_gbn.value = "";
	}
	if ( start_date > end_date ) {
		alert("발행 종료일은 시작일보다 작을 수 없습니다.");
		return false;
	}
	if ( start_date.substring(0,6) != end_date.substring(0,6) ) {
		alert("동일한 년월로만 조회가 가능합니다.");
		return false;
	}

	return true;
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if ( msg != "" ) {
		alert(msg);
	}
	
	// 세무구분 히든 처리 : 매출물류비는 세무구분이 고정(1A)
	if ( $("#job_type").val() == "BNT" ) {
		mySheet.SetColHidden("TAX_TYPE_TEXT", 1);
	}
	else if ( $("#job_type").val() == "ORG" ) {
		mySheet.SetColHidden("TAX_TYPE_TEXT", 0);
	}
	
	setSumAmt();
	checkTaxPriceALL();
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if ( msg != "" ) {
		alert(msg);
	}

	if ( code > 0 ) {
		//저장 성공시 재조회
		doAction('search');
	}
}

// 금액정보 설정
function setSumAmt() {
	var buyerAmt = 0 ;
	var buyerTaxAmt = 0;
	var buyerTotAmt = 0;
	for( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if(mySheet.GetCellValue(i, "ORI_ISSUE_ID") ==""){
			buyerAmt = buyerAmt + Number( kepFilterNum( String( mySheet.GetCellValue(i, "SUPP_PRICE") ) ) );
			buyerTaxAmt = buyerTaxAmt + Number( kepFilterNum( String( mySheet.GetCellValue(i, "TAX_PRICE") ) ) );
			buyerTotAmt = buyerTotAmt + Number( kepFilterNum( String( mySheet.GetCellValue(i, "AMT") ) ) );
		}
    }

	$("#buyerAmt").html( kepCommaNum(buyerAmt) );
	$("#buyerTaxAmt").html( kepCommaNum(buyerTaxAmt) );
	$("#buyerTotAmt").html( kepCommaNum(buyerTotAmt) );
}

// 전체 세액 체크
function checkTaxPriceALL() {
	var check_cnt = 0;
	
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		var taxPrice = Number(mySheet.GetCellValue(i, "TAX_PRICE"));
		var totTaxPrice = Number(mySheet.GetCellValue(i, "TOT_TAX_PRICE"));
		
		if ( totTaxPrice != taxPrice ) {
			mySheet.SetCellBackColor(i, "TAX_PRICE", "#F9C9DF");
			check_cnt++;
		} else {
			mySheet.SetCellBackColor(i, "TAX_PRICE", "#FFFFFF");
		}
	}
	
	if ( check_cnt > 0 ) {
		alert("세무구분이 변경 되었습니다.\n\n팝업을 통해 세액의 상세내역을 수정해 주십시요.");
	}
}

// 건별 세액 체크
function checkTaxPrice(index) {
	var taxPrice = Number(mySheet.GetCellValue(index, "TAX_PRICE"));
	var totTaxPrice = Number(mySheet.GetCellValue(index, "TOT_TAX_PRICE"));
	
	if ( totTaxPrice != taxPrice ) {
		mySheet.SetCellBackColor(index, "TAX_PRICE", "#F9C9DF");
		alert(index + "번째 세무구분이 변경 되었습니다.\n\n팝업을 통해 세액의 상세내역을 수정해 주십시요.");
		return false;
	} else {
		mySheet.SetCellBackColor(index, "TAX_PRICE", "#FFFFFF");
		return true;
	}
}

// Valitation - 확정
function validationConfirm() {
	var userId = $("#st_user_id").val();
	var userDept = $("#st_dept_code").val();
	var misDept = "005";
	
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
	        /*if ( userDept != misDept) {
	        	alert("세금계산서 확정 취소는 관리팀에서 처리합니다.");
				return false;
			}*/
	        if ( userDept != misDept && mySheet.GetCellValue(i, "ADD_USER_ID") != userId ) {
	        	alert("등록자 본인 건만 확정 할 수 있습니다.");
				return false;
			}
			if ( mySheet.GetCellValue(i, "CONFIRM_FLAG") == 'Y' ) {
				alert("이미 확정된 건이 있습니다.");
				return false;
			}
			/*
			if(mySheet.GetCellValue(i, "BILL_CODE_TEXT") =="41000008"&&mySheet.GetCellValue(i, "BILL_TYPE_TEXT") =="10"){
	            if ( mySheet.GetCellValue(i, "CONVERSATION_ID") == "") {
					alert("세금계산서 발행정보가 없어 확정이 불가능 합니다.");
					return false;
				}
			}
			*/
			if ( !checkTaxPrice(i) ) {
				return false;
			}
		}
	}
	
	return true;
}

// Valitation - 확정취소
function validationConfirmCancle() {
	var userId = $("#st_user_id").val();
	var userDept = $("#st_dept_code").val();
	var misDept = "005";
	
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
        if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
	        if ( userDept != misDept && userDept != "095") {
	        	alert("세금계산서 확정 취소는 관리팀에서 처리합니다.");
				return false;
			}
        	if ( mySheet.GetCellValue(i, "SEND_FLAG") == '전송' ) {
	        	alert("이미 전송된 건이 있습니다.");
				return false;
			}
        	if ( mySheet.GetCellValue(i, "CONFIRM_FLAG") == 'N' ) {
	        	alert("확정된 건만 취소 할 수 있습니다.");
				return false;
        	}
		}
	}
	
	return true;
}

//Valitation - 마감제출
function validationArConfirm() {
	var userId = $("#st_user_id").val();
	var totCnt = mySheet.RowCount();

	if (totCnt < 1)
		return;
	var confirmCnt = 0;
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
			mySheet.SetCellValue(i, "SELECTED", 1);
	       if ( mySheet.GetCellValue(i, "CONFIRM_FLAG") == "N" && mySheet.GetCellValue(i, "BILL_CODE_TEXT") =="41000008" &&  userId == mySheet.GetCellValue(i, "ADD_USER_ID") && (mySheet.GetCellValue(i, "BILL_TYPE_TEXT") == "10" || mySheet.GetCellValue(i, "BILL_TYPE_TEXT") == "")) {
	        	if(mySheet.GetCellValue(i, "CONVERSATION_ID") == "") {
	        		alert("발행되지 않은 물류비 세금계산서가 있습니다.\확인 후 마감 제출 바랍니다.");
					return false;	
	        	}	        	
			}
	        if (mySheet.GetCellValue(i, "ADD_USER_ID") != userId ) {
	        	alert("등록자 본인 건만 마감제출 할 수 있습니다.");
				return false;
			}
	        if (mySheet.GetCellValue(i, "CONFIRM_FLAG") == "N" ) {
	        	confirmCnt++;	        	
			}
			if ( !checkTaxPrice(i) && userId == mySheet.GetCellValue(i, "ADD_USER_ID")) {
				return false;
			}
			
			/*
			if(mySheet.GetCellValue(i, "BILL_CODE_TEXT") =="41000008"&&mySheet.GetCellValue(i, "BILL_TYPE_TEXT") =="10"){
	            if ( mySheet.GetCellValue(i, "CONVERSATION_ID") == "") {
					alert("세금계산서 발행정보가 없어 확정이 불가능 합니다.");
					return false;
				}
			}
			*/
	 }
	if(confirmCnt > 0) {
		return true;
	} else {
		alert("이미 마감제출 하였습니다.");
		return false;
	}
	
	return true;
}

// Valitation - 삭제
function validationDelete() {

	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
        if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {

            if ( mySheet.GetCellValue(i, "SEND_DATE") != ''  ) {
				alert("회계시스템 전송 완료된 건이 있습니다\n\n관리팀 협의후 전송내역을 취소 하여야 합니다.");
				return false;
			}
            if ( mySheet.GetCellValue(i, "CONFIRM_FLAG") == 'Y') {
	        	alert("선택한 목록 중 마감제출된 건이 있습니다.\n관리팀에게 요청하여 마감 제출 취소 후 진행하시기 바랍니다.");
				return false;
			}
			if ( mySheet.GetCellValue(i, "PARTIAL_FLAG") == 'Y' ) {
				alert("금액분할로 생성된 세금계산서 삭제는 SR요청 바랍니다.");
				return false;
			}            
			if(mySheet.GetCellValue(i, "BILL_CODE_TEXT") =="41000008"&&mySheet.GetCellValue(i, "CONVERSATION_ID") !=""){
        		if( mySheet.GetCellValue(i, "DTI_STATUS") == "C"){
					alert("수신 승인건은 삭제가 불가능 합니다.");
					return false;	            			
        		}
        		if( mySheet.GetCellValue(i, "DTI_STATUS") == "I"){
					alert("수신 미승인건은 삭제가 불가능 합니다.");
					return false;	            			
        		}
        		if( mySheet.GetCellValue(i, "DTI_STATUS") == "V"){
					alert("역발행 요청건은 삭제가 불가능 합니다.");
					return false;	            			
        		}
        		if( mySheet.GetCellValue(i, "NTS_SEND_STATUS") == "7"){
					alert("국세청 전송 건은 삭제가 불가능 합니다.");
					return false;	            			
        		}
			}
		}
	}
	
	return true;
}

//Valitation -수정세금계산서 삭제
function validationDelete2() {

	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
  	 if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {

       		if ( mySheet.GetCellValue(i, "SEND_DATE") != ''  ) {
				alert("회계시스템 전송 완료된 건이 있습니다\n\n관리팀 협의후 전송내역을 취소 하여야 합니다.");
				return false;
			}
       	 	if ( mySheet.GetCellValue(i, "CONFIRM_FLAG") == 'Y') {
	        	alert("선택한 목록 중 마감제출된 건이 있습니다.\n관리팀에게 요청하여 마감 제출 취소 후 진행하시기 바랍니다.");
				return false;
			}
			if ( mySheet.GetCellValue(i, "PARTIAL_FLAG") == 'Y' ) {
				alert("금액분할로 생성된 세금계산서 삭제는 SR요청 바랍니다.");
				return false;
			}       		
			if(mySheet.GetCellValue(i, "BILL_CODE_TEXT") =="41000008"&&mySheet.GetCellValue(i, "CONVERSATION_ID") !=""){
	         	var ori_issue_id = mySheet.GetCellValue(i, "ORI_ISSUE_ID");
	         	var strIssue_id = mySheet.GetCellValue(i, "ISSUE_ID");
	         	var passFlag = "Y";
	         	var passFlag2 = "Y";
	         	if(ori_issue_id != ""){
	         		passFlag = "N";
	         	}
	         	var total_cnt = 0;
	         	for ( var j = 1; j<= mySheet.RowCount(); j++ ) {
	         		if ( mySheet.GetCellValue(j, "SELECTED") == 1 ) {
	         				total_cnt = j;
		            		if(mySheet.GetCellValue(j, "ISSUE_ID") == ori_issue_id){
		            			passFlag = "Y";
		            		}
	         		}else{
		            		if(mySheet.GetCellValue(j, "ORI_ISSUE_ID") == strIssue_id){
		            			passFlag2 = "N";
		            		}	            			
	         		}
	         	}
            	if(total_cnt == 1){
					alert("수정세금계산서는 당초세금계산서와 함게 삭제 가능합니다.");
					return false;            		
            	}
	         	if(passFlag =="N"||passFlag2=="N"){
						alert("수정세금계산서는 당초세금계산서와 함게 삭제 가능합니다.");
						return false;	            		
	         	}
	         	if(passFlag =="Y"&&passFlag2=="Y"){
	        		if( mySheet.GetCellValue(i, "DTI_STATUS") == "R"){
						alert("수신거부 건은 삭제가 불가능 합니다.");
						return false;	            			
	        		}
	        		if( mySheet.GetCellValue(i, "DTI_STATUS") == "O"){
						alert("발행취소 건은 삭제가 불가능 합니다.");
						return false;	            			
	        		}
	        		if( mySheet.GetCellValue(i, "NTS_SEND_STATUS") != "7"&& mySheet.GetCellValue(i, "DTI_STATUS") =="I"){
						alert("수신 미승인건은 삭제가 불가능 합니다.");
						return false;	            			
	        		}
	         	}
			}
		}
	}
	
	return true;
}
// Valitation - 수정
function validationUpdate() {
	
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
	        if ( mySheet.GetCellValue(i, "CONFIRM_FLAG") == 'Y' || mySheet.GetCellValue(i, "SEND_FLAG") == '전송'){
				alert("세금계산서 출력, 담당자 확인 또는 전송된 건은 수정 불가 합니다.");
				return false;
			}
	        
			if(mySheet.GetCellValue(i, "BILL_CODE_TEXT") =="41000008"){
	            if ( mySheet.GetCellValue(i, "STATUS_RETURN_CODE") == "30000") {
					alert("세금계산서 전송된건은 수정 불가능 합니다.");
					return false;
				}
	            if(mySheet.GetCellValue(i, "DTI_STATUS") != 'O'&&mySheet.GetCellValue(i, "STATUS_RETURN_CODE") == "30000"){
					alert("세금계산서 상태가 발행취소인 경우만 가능 합니다.");
					return false;            	
	            }
			}
			if ( !checkTaxPrice(i) ) {
				return false;
			}
		}
	}
	
	return true;
}

// Valitation - 전송
function validationARsend() {
	var userId = $("#st_user_id").val();
	var userDept = $("#st_dept_code").val();
	var misDept = "005";
	
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			/*if (mySheet.GetCellValue(i, "ADD_USER_ID") != userId ) {
	        	alert("등록자 본인 건만 전송처리 할 수 있습니다.");
				return false;
			}*/
	        if ( userDept != misDept) {
	        	alert("전송처리는 관리팀에서 처리합니다.");
				return false;
			}
 	        if ( mySheet.GetCellValue(i, "CONFIRM_FLAG") != 'Y' ) {
 	        	alert("담당자 확인이 안된 건은 전송처리 할 수 없습니다.");
 				return false;
 			}
 	        if ( mySheet.GetCellValue(i, "SEND_FLAG") == '전송' ) {
 	        	alert("이미 전송된 건이 있습니다.");
 				return false;
 			}
		}
	}
	
	return true;
}

// Valitation - 전송취소
function validationARreverse() {
// 	var userId = $("#st_user_id").val();
	var userDept = $("#st_dept_code").val();
	var misDept = "005";
	
	if ( userDept != misDept ) {
		alert("세금계산서 전송취소는 관리팀에서 처리합니다.");
		return false;
	}
	
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
// 	        if ( mySheet.GetCellValue(i, "ADD_USER_ID") != userId ) {
// 	        	alert("등록자 본인 건만 전송취소처리 할 수 있습니다.");
// 				return false;
// 			}
	        if ( mySheet.GetCellValue(i, "CLOSE_YN") == 'Y' ) {
	        	alert("마감이 확정된 건은 전송취소처리 할 수 없습니다.");
				return false;
			}
	        if ( mySheet.GetCellValue(i, "SEND_FLAG") == '미전송' ) {
	        	alert("미전송된 건은 전송취소처리 할 수 없습니다.");
				return false;
			}
	        if ( mySheet.GetCellValue(i, "IF_SEND_FLAG") != 'Y' ) {
	        	alert("전송완료 건만 전송취소처리 할 수 있습니다.");
				return false;
			}
		}
	}
	
	return true;
}

var changeIssueDate = '';

// 그리드 셀 변경 이벤트
function mySheet_OnChange(Row, Col, Value) {
// 	alert("[OnChange]]Row / Col / Value => " + Row + " / " + Col + " / " + Value);
	var column = mySheet.ColSaveName(Col);

	if ( column == "TAX_TYPE_TEXT" ) {
		var taxType = mySheet.GetCellValue(Row, "TAX_TYPE_TEXT"); // 세무구분
		var suppPrice = Number(mySheet.GetCellValue(Row, "SUPP_PRICE")); // 공급가액
		
		// 과세매출
		if ( taxType == "11" || taxType == "17" ) {
			// 소숫점 버림
			if ( suppPrice > 0 ) {
				mySheet.SetCellValue(Row, "TAX_PRICE", Math.floor(suppPrice*0.1), 0); // 세액
				mySheet.SetCellValue(Row, "AMT", Math.floor(suppPrice+suppPrice*0.1), 0); // 합계
			// 소수점 올림
			} else {
				mySheet.SetCellValue(Row, "TAX_PRICE", Math.ceil(suppPrice*0.1), 0); // 세액
				mySheet.SetCellValue(Row, "AMT", Math.ceil(suppPrice+suppPrice*0.1), 0); // 합계
			}
		} else {
			mySheet.SetCellValue(Row, "TAX_PRICE", 0, 0); // 세액
			mySheet.SetCellValue(Row, "AMT", suppPrice, 0); // 합계
		}
		
		checkTaxPrice(Row);
	}
	else if ( column == "ISSUE_DATE" ) {
		// 마감월안에서만 허용 : 2014.08.11
		var close_month	 = mySheet.GetCellValue(Row, 'CLOSE_MONTH'); // 마감월

		var from_date = close_month + "01";
		var to_date = lastDay(close_month.substring(0,4) , close_month.substring(4,6) , "");

		var fromStr = kepDateSlashAdd(from_date);
		var toStr = kepDateSlashAdd(to_date);

		if ( eval(Value) < eval(from_date) || eval(Value) > eval(to_date) ) {
			alert("작성일자 수정은 " + fromStr + " ~ " + toStr + " 사이에서 가능합니다.");
			
			if ( changeIssueDate == '' ) {
				mySheet.ReturnCellData(Row, "ISSUE_DATE", 0);
			} else {
				mySheet.SetCellValue(Row, "ISSUE_DATE", changeIssueDate, 0);
			}
		} else {
			changeIssueDate = Value;
		}
	}
	
}

// 그리드 헤더 전체 체크박스 클릭 이벤트
function mySheet_OnCheckAllEnd(Col, Value) {
// 	alert("Col / Value => " + Col + " / " + Value);

	var totCnt = mySheet.RowCount();

	if ( totCnt < 1 ) return;
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
// 	alert("[OnClick] Row / Col / Value => " + Row + " / " + Col + " / " + Value);

	if ( Row < 1 ) return;

	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
		if ( column == 'TAX_PRICE'||column == 'SUPP_PRICE') { // 세액(세액 변경 Popup)
			var taxPrice = Number(mySheet.GetCellValue(Row, "TAX_PRICE"));
			var totTaxPrice = Number(mySheet.GetCellValue(Row, "TOT_TAX_PRICE"));
		
		if(mySheet.GetCellValue(Row, "BILL_CODE_TEXT") =="41000008"&&mySheet.GetCellValue(Row, "CONVERSATION_ID") !=""){
			alert("스마트빌 발행된건은 세액수정이 불가능 합니다.");
			return;			
		}
		if ( totTaxPrice == 0 && taxPrice == 0 ) {
			return;
		}
		if( mySheet.GetCellValue(Row, "CONFIRM_FLAG") == 'Y' ||  mySheet.GetCellValue(Row, "SEND_FLAG")== '전송') {
			alert("담당자 확인 또는 전송된 건은 수정 불가 합니다.");
			return;
		}

		var taxBillNo = mySheet.GetCellValue(Row, "TAX_BILL_NO");
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var siteType = mySheet.GetCellValue(Row, "SITE_GUBUN_CODE");
		var taxPrice = mySheet.GetCellValue(Row, "TAX_PRICE");
		var suppPrice = mySheet.GetCellValue(Row, "SUPP_PRICE");
		var taxType = mySheet.GetCellValue(Row, "TAX_TYPE_TEXT");
		var totTaxPrice = mySheet.GetCellValue(Row, "TOT_TAX_PRICE");
		var st_user_id = $("#st_user_id").val();
		
		var params = "?st_buyer="+buyer+"&st_tax_bill_no="+taxBillNo+"&st_site_type="+siteType+"&st_taxPrice="+taxPrice+"&st_tax_type_code="+taxType+"&st_supp_price="+suppPrice+"&st_user_id="+st_user_id+"&st_totTaxPrice="+totTaxPrice;
		doPop('taxPricePop', params);

	} else if (column == 'REMARK' ) { // 적요(적요 변경 Popup)
		var taxBillNo = mySheet.GetCellValue(Row, "TAX_BILL_NO");
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var siteType = mySheet.GetCellValue(Row, "SITE_GUBUN_CODE");
		var suppPrice = mySheet.GetCellValue(Row, "SUPP_PRICE");
		var taxPrice = mySheet.GetCellValue(Row, "TAX_PRICE");
		var tableName = "KEPTARDT";
		
		var params = "?st_buyer="+buyer+"&st_tax_bill_no="+taxBillNo+"&st_site_type="+siteType+"&st_edit_flag=Y&st_table_name="+tableName+"&st_suppPrice="+suppPrice+"&st_taxPrice="+taxPrice;
		doPop('remarkPop', params);
	} else if (column == 'RECV_EMAIL' ) { // 담당자E-MAIL
		var buyer_code = mySheet.GetCellValue(Row, "BUYER");
		var buyer_irs_no = mySheet.GetCellValue(Row, "BUYER_IRS_NO");
		var buyer_name = mySheet.GetCellValue(Row, "BUYER_NAME");
		
		var params = "?buyer_code="+buyer_code+"&buyer_irs_no="+buyer_irs_no+"&buyer_name="+buyer_name+"&confirm_flag=Y";
		doPop('masterCmClStndSettingPop', params);
	}
}

// 헤더 더블클릭 이벤트
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	
	if ( checkRows.length == 0 ) {
// 		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	
	var arrRow = checkRows.split("|");
	
	if ( mySheet.ColSaveName(Col) == "ISSUE_DATE" ) { // 작성일
		var value1 = mySheet.GetCellValue(arrRow[0], "ISSUE_DATE");
		
		for ( var idx=0; idx<arrRow.length; idx++ ) {
			mySheet.SetCellValue(arrRow[idx], "ISSUE_DATE", value1);
		}
	} else 	if ( mySheet.ColSaveName(Col) == "PAY_TERMS" ) { // 결제조건
		var value1 = mySheet.GetCellValue(arrRow[0], "PAY_TERMS");
		
		for ( var idx=0; idx<arrRow.length; idx++ ) {
			mySheet.SetCellValue(arrRow[idx], "PAY_TERMS", value1);
		}
	} else 	if ( mySheet.ColSaveName(Col) == "BILL_TYPE_TEXT" ) { // 발행조건
		var value1 = mySheet.GetCellValue(arrRow[0], "BILL_TYPE_TEXT");
		
		for ( var idx=0; idx<arrRow.length; idx++ ) {
			mySheet.SetCellValue(arrRow[idx], "BILL_TYPE_TEXT", value1);
		}
	}else 	if ( mySheet.ColSaveName(Col) == "BILL_CODE_TEXT" ) { // 발행조건
		var value1 = mySheet.GetCellValue(arrRow[0], "BILL_CODE_TEXT");
		
		for ( var idx=0; idx<arrRow.length; idx++ ) {
			mySheet.SetCellValue(arrRow[idx], "BILL_CODE_TEXT", value1);
		}
	}else if( mySheet.ColSaveName(Col) == "ARDT_REMARK"){ // 비고
		var value1 = mySheet.GetCellValue(arrRow[0], "ARDT_REMARK");
		
		for ( var idx=0; idx<arrRow.length; idx++ ) {
			mySheet.SetCellValue(arrRow[idx], "ARDT_REMARK", value1);
		}

	}
	
}

// 팝업함수호출
function doPop(str, params) {
	popupSel = str;

	switch (str) {
		case "agent_single": // 협력사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			break;
			
		case "taxPricePop": // 세액 변경
			openSearchPopup("/cmcl/showMasterCmClTaxamntAlterPop.do", params, "500,340,no");
			break;
		
		case "remarkPop": // 적요
			openSearchPopup("/cmcl/showMasterCmClCmmntPop.do", params, "850,300,no");
			break;

		case "masterCmClStndSettingPop": // 담당자
			openSearchPopup("/cmcl/showMasterCmClStndSettingPop.do", params, "800,340,no");
			break;
			
		case "masterCmClStndModifySettingPop": // 계산서수정사유
			openSearchPopup("/cmcl/showMasterCmClStndModifySettingPop.do", params, "800,500,no");
			break;
			
		case "offPrint": // 리포트 호출
			var rpt_url = "RD_10_M_001_00";
			openTranStatReportOpen(rpt_url, params, 1);
			break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3) {
// 	alert("value1 / value2 => " + value1 + " / " + value2);

	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "agent_single") { // 단일 협력사
			$("#st_agent_code").val(value1);
			$("#st_agent_name").val(value2);

	} else if (popupSel == "taxPricePop") {	// 세액 변경
		
	} else if (popupSel == "remarkPop") {	// 적요
		
	} else if (popupSel == "masterCmClStndSettingPop") {	// 담당자메일
		mySheet.SetCellValue(grbRow, "RECV_USER_NAME", value1); // 받는담당자정보
		mySheet.SetCellValue(grbRow, "RECV_PHONE_NUMBER", value2); // 받는담당자전화번호
		mySheet.SetCellValue(grbRow, "RECV_EMAIL", value3); // 받는담당자이메일
	} else if (popupSel == "masterCmClStndModifySettingPop") {	// 수정사유
		//정보, 공급자사업자번호, 공급받는자사업자번호, ar_no, 토근, 상태, 세금계산서정상/취소구분/계산서/계산서취소(S/R) ,정발행역발행구분(A/B)
		if(value1 == "01"){
			g_paramInfo = g_paramInfo+"@@"+value1+"@@"+value2;	
		}else{
			g_paramInfo = g_paramInfo+"@@"+value1+"@@"+g_ori_issue_id;	
		}
		loader_obj("Y");
		getSendFormat(g_paramInfo,g_send_irs_no,g_recv_irs_no,g_ar_no,g_authtoken,"I","M","B","","","1","1","","","",g_buyer);
		
	}

	grbRow="";	//초기화
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>물류비 세금계산서 발행/등록(출력 및 전송)</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>
        
		<form name="processForm" id="processForm" method="post">	
			<input type="hidden" id="st_ca_id" name="st_ca_id"  value="">
			<input type="hidden" id="st_error_code" name="st_error_code"  value="">
			<input type="hidden" id="st_error_msg" name="st_error_msg"  value="">
			<input type="hidden" id="st_s_user_id" name="st_s_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="param1" name="param1"  value="">
			<input type="hidden" id="param2" name="param2"  value="">
			<input type="hidden" id="param3" name="param3"  value="">
			<input type="hidden" id="param4" name="param4"  value="">
			<input type="hidden" id="param5" name="param5"  value="">
			<input type="hidden" id="_authtoken" name="_authtoken"  value="">  
		</form>
		<!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<input type="hidden" name="st_send_gbn"  id="st_send_gbn" value ="">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_dept_code" name="st_dept_code"  value="${sessionInfo.department}">
			<input type="hidden" id="job_kind" name="job_kind" value="">
			<input type="hidden" id="job_type" name="job_type" value="">
			<input type="hidden" id="close_type" name="close_type" value="LG">
			<input type="hidden" id="st_totAmt" name="st_totAmt"  value="0">

            	<table  class="cont_t_list01" >
					<caption>물류비 세금계산서 발행/등록(출력 및 전송)</caption>
					<colgroup>
						<col width="8%" />
						<col width="26%" />
						<col width="8%" />
						<col width="14%" />
						<col width="8%" />
                        <col width="14%" />
						<col width="8%" />
                        <col width="14%" />
					</colgroup>

					<tbody>
						<tr>
							<th><font color="#FF6600">*</font>작성일</th>
							<td>
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:80px; text-align:center;" value="">
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:80px; text-align:center;" value="">
							</td>
							<th>사업자번호</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_irs_no" id="st_buyer_irs_no" style="width:75%" value="" onkeydown="kepEnter()">
							</td>
							<th>발행주체</th>
							<td>
								  <select name="st_bill_type_text" id="st_bill_type_text" style="width:80%">           
						         	 <%= CommonUtil.getCode3ComboList("", "ALL", "TX03","", "ICOMCOD1", "", "") %>
						         </select>
							</td>
							<th>발행사이트</th>
							<td>
								  <select name="st_bill_code_text" id="st_bill_code_text" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "ALL", "TX09","", "ICOMCOD1", "", "") %>           
						         </select>
							</td>
						</tr>
						<tr>
							<th>협력사</th>
							<td>
							<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:70%" value="" readonly onclick="javascript:doPop('agent_single');">
							<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:80%" value="">
							<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>담당자</th>
							<td>
								<select id="st_add_user_id" name="st_add_user_id" style="width:80%;height:20px"></select>
							</td>
							<th>제출여부</th>
							<td>
								<select id="st_confirm_flag" name="st_confirm_flag" style="width:80%;height:20px">
									<option value="ALL">전체</option>
									<option value="Y">제출</option>
									<option value="N">미제출</option>
								</select>
							</td>
							<th>회계전송여부</th>
							<td>
								<select id="st_send_flag" name="st_send_flag" style="width:80%;height:20px">
									<option value="ALL">전체</option>
									<option value="Y">전송</option>
									<option value="N">미전송</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>세금계산서번호</th>
							<td>
								<input type="text" class="input_type_text" name="st_tax_bill_no" id="st_tax_bill_no" style="width:75%" value="" onkeydown="kepEnter()">
							</td>
							<th>세금계산서상태</th>
							<td>
								<select name="st_dti_status" id="st_dti_status" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "ALL", "TX11","", "ICOMCOD1", "", "") %>           
						         </select>
							</td>
							<th>국세청전송상태</th>
							<td>
								<select name="st_ntd_sendstatus" id="st_ntd_sendstatus" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "ALL", "TX12","", "ICOMCOD1", "", "") %>           
						         </select>
							</td>
							<th colspan="2"><input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox">&nbsp;세금계산서 미발행</th>
						</tr>
						<tr>
							<th>부서정보</th>
							<td><select id="st_user_dept" name="st_user_dept" style="width: 80%; height: 20px">
							<th></th>
							<td>
							</td>
							<th></th>
							<td>
							</td>
							<th colspan="2"></th>
						</tr>
					</tbody>
				</table>
            </div>
		</form>

      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
		<div style="display:none">
			<script type="text/javascript">
				createIBSheet("mySheet2", "100%", "1px");
			</script>
		</div>

		<!--금액영역-->
		<div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" border="1" bgcolor="#FFFFFF">
				<tr>
					<td height="35" align="right" style="font-weight:bold" align="center">
						&nbsp;
					</td>
					<td height="35" align="right" style="font-weight:bold" align="center">
						총 합계액:<span id="buyerTotAmt" style="font-weight:bold; color:orange;">0</span>원&nbsp;&nbsp;&nbsp;
						총 공급가액:<span id="buyerAmt" style="font-weight:bold; color:orange;">0</span>원&nbsp;&nbsp;&nbsp;
						총 부가가치세액:<span id="buyerTaxAmt" style="font-weight:bold; color:orange;">0</span>원 
					</td>
				</tr>
			</table>
		</div>

		<!--버튼영역-->
		<div class="btnArea">
			<span class="fl">
				<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
				<span class="btn_05 mr04"><a href="javascript:doAction('excelDetailDown');">상세다운로드</a></span>
			</span>

			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('update');">수정</a></span>
				<span class="btn_08 mr04"><a href="javascript:doAction('delete2');">수정계산서삭제</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('delete');">삭제</a></span>
				<span class="btn_05 mr04"><a href="javascript:doAction('send');">세금계산서발행</a></span>
				<span class="btn_10 mr04"><a href="javascript:doAction('rsend');">수정/삭제세금계산서발행</a></span>
				<span class="btn_05 mr04"><a href="javascript:doAction('IssueSendInfo');">국세청전송</a></span>
			   <!-- <span class="btn_02 mr04"><a href="javascript:doAction('confirm');">확정</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('confirmCancle');">확정취소</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('ARsend');">회계전송</a></span> -->
				<span class="btn_02 mr04"><a href="javascript:doAction('ARconfirm');">마감제출</a></span>				
			</span>
		</div>

<!--내용 종료-->
</body>
</html>
