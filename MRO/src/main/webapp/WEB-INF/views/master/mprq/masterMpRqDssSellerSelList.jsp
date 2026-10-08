<%--
**********************************************
* 메뉴 : 견적관리>견적의뢰접수>협력사선택
* 화면 : 협력사선택
* 기능 : 고객으로부터 견적의뢰받은 품목에 대해 견적을 요청하기 위해 협력사를 선택하여 지정
* 프로그램 ID : PG_04_M_005_02
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-05-26
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<script src="/resources/js/common.js"></script>
<%
String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");
String getCodeDSRMText = CommonUtil.getCode2TextReturn("DSRM",st_buyer_code,"KRKORE0001","TEXT1");
boolean mqt00001 = CommonUtil.getSpecialCheckReturn(st_buyer_code,"MQT00001"); // 단독입찰 고객사
%>
<script>

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	kepHidden('hidden');
	// mySheet S.담당자 관리(제조사,SG)
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus",		EditLen:0}
					,{ Align:"Center",	Width:20,	Edit:true,	Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED"}
					,{ Align:"Center",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"순위",			SaveName:"RANK"}
					,{ Align:"Left",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유형",			SaveName:"TYPE_BEFORE_ONE"}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",		Header:"등록일",			SaveName:"CREATE_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급평가",		SaveName:"DSS_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급메시지",	SaveName:"DSS_MSG"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"취급메이커",		SaveName:"REF_MAKER"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	//하이퍼링크 설정
	setLinkCol(mySheet, "AGENT_NAME");	//협력사
	
	// mySheet13 D. 총판/대리점 관리(제조사,SG) 
	var initsheet13 = {};
	initsheet13.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus",		EditLen:0}	
					,{ Align:"Center",	Width:20,	Edit:true,	Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED"}
					,{ Align:"Center",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"순위",			SaveName:"RANK"}
					,{ Align:"Left",	Width:50,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유통레벨",			SaveName:"SUP_TYPE"}
					,{ Align:"Left",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유형",			SaveName:"TYPE_BEFORE_ONE"}	
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
					,{ Align:"Left",	Width:185,	Edit:false,	Hidden:false,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME"}
					,{ Align:"Rigt",	Width:80,	Edit:false,	Hidden:false,	Type:"Float",		Header:"매출금액",			SaveName:"ITEM_AMT",	Format:"${priceFormat}"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급평가",		SaveName:"DSS_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급메시지",	SaveName:"DSS_MSG"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"취급메이커",		SaveName:"REF_MAKER"}
	];
	
	IBS_InitSheet(mySheet13, initsheet13,pagingMode);
	//하이퍼링크 설정
	setLinkCol(mySheet13, "AGENT_NAME");	//협력사
	
	// mySheet14 D.총판/대리점 관리(SG) 
	var initsheet14 = {};
	initsheet14.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus",		EditLen:0}	
					,{ Align:"Center",	Width:20,	Edit:true,	Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED"}
					,{ Align:"Center",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"순위",			SaveName:"RANK"}
					,{ Align:"Left",	Width:50,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유통레벨",			SaveName:"SUP_TYPE"}
					,{ Align:"Left",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유형",			SaveName:"TYPE_BEFORE_ONE"}	
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
					,{ Align:"Left",	Width:185,	Edit:false,	Hidden:false,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME"}
					,{ Align:"Rigt",	Width:80,	Edit:false,	Hidden:false,	Type:"Float",		Header:"매출금액",			SaveName:"ITEM_AMT",	Format:"${priceFormat}"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급평가",		SaveName:"DSS_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급메시지",	SaveName:"DSS_MSG"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"취급메이커",		SaveName:"REF_MAKER"}
	];
	
	IBS_InitSheet(mySheet14, initsheet14,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet14, "AGENT_NAME");	//협력사
	
	
	// mySheet2  S. 담당자 관리(SG)
	var initsheet2 = {};
	initsheet2.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus",		EditLen:0}
					,{ Align:"Center",	Width:20,	Edit:true,	Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED"}
					,{ Align:"Center",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"순위",			SaveName:"RANK"}
					,{ Align:"Left",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유형",			SaveName:"TYPE_BEFORE_ONE"}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",		Header:"등록일",			SaveName:"CREATE_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급평가",		SaveName:"DSS_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급메시지",	SaveName:"DSS_MSG"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"취급메이커",		SaveName:"REF_MAKER"}
	];
	
	IBS_InitSheet(mySheet2, initsheet2,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet2, "AGENT_NAME");	//협력사
	
	// mySheet3 A. 고객사 거래실적(제조사,SG) 
	var initsheet3 = {};
	initsheet3.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus",		EditLen:0}
					,{ Align:"Center",	Width:20,	Edit:true,	Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED"}
					,{ Align:"Center",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"순위",			SaveName:"RANK"}
					,{ Align:"Left",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유형",			SaveName:"TYPE_BEFORE_ONE"}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME"}
					,{ Align:"Rigt",	Width:100,	Edit:false,	Hidden:false,	Type:"Float",		Header:"매출금액",			SaveName:"ITEM_AMT",	Format:"${priceFormat}"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급평가",		SaveName:"DSS_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급메시지",	SaveName:"DSS_MSG"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"취급메이커",		SaveName:"REF_MAKER"}
	];
	
	IBS_InitSheet(mySheet3, initsheet3,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet3, "AGENT_NAME");	//협력사
	
	// mySheet4 A. 고객사 거래실적(SG) ,   B. 고객사 소재지역 거래실적(SG) 
	var initsheet4 = {};
	initsheet4.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus",		EditLen:0}
					,{ Align:"Center",	Width:20,	Edit:true,	Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED"}
					,{ Align:"Center",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"순위",			SaveName:"RANK"}
					,{ Align:"Left",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유형",			SaveName:"TYPE_BEFORE_ONE"}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME"}
					,{ Align:"Rigt",	Width:90,	Edit:false,	Hidden:false,	Type:"Float",		Header:"매출금액",			SaveName:"ITEM_AMT",		Format:"${priceFormat}"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급평가",		SaveName:"DSS_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급메시지",	SaveName:"DSS_MSG"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"취급메이커",		SaveName:"REF_MAKER"}
	];
	
	IBS_InitSheet(mySheet4, initsheet4,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet4, "AGENT_NAME");	//협력사
	
	// mySheet5 B. 고객사 소재지역 거래실적(제조사,SG)
	var initsheet5 = {};
	initsheet5.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus",		EditLen:0}
					,{ Align:"Center",	Width:20,	Edit:true,	Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED"}
					,{ Align:"Center",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"순위",			SaveName:"RANK"}
					,{ Align:"Left",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유형",			SaveName:"TYPE_BEFORE_ONE"}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME"}
					,{ Align:"Rigt",	Width:100,	Edit:false,	Hidden:false,	Type:"Float",		Header:"매출금액",			SaveName:"ITEM_AMT",	Format:"${priceFormat}"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급평가",		SaveName:"DSS_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급메시지",	SaveName:"DSS_MSG"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"취급메이커",		SaveName:"REF_MAKER"}
	];
	
	IBS_InitSheet(mySheet5, initsheet5,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet5, "AGENT_NAME");	//협력사
	
	// mySheet6
	var initsheet6 = {};
	initsheet6.Cols = [ 					 
					 { Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus",		EditLen:0}
					,{ Align:"Center",	Width:20,	Edit:true,	Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED"}
					,{ Align:"Center",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"순위",			SaveName:"RANK"}
					,{ Align:"Left",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유형",			SaveName:"TYPE_BEFORE_ONE"}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME"}
					,{ Align:"Rigt",	Width:100,	Edit:false,	Hidden:false,	Type:"Float",		Header:"매출금액",			SaveName:"ITEM_AMT",	Format:"${priceFormat}"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급평가",		SaveName:"DSS_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급메시지",	SaveName:"DSS_MSG"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"취급메이커",		SaveName:"REF_MAKER"}
	];
	
	IBS_InitSheet(mySheet6, initsheet4,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet6, "AGENT_NAME");	//협력사
	
	// mySheet4 C. 전국 거래실적(제조사,SG) 
	var initsheet7 = {};
	initsheet7.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus",		EditLen:0}
					,{ Align:"Center",	Width:20,	Edit:true,	Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED"}
					,{ Align:"Center",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"순위",			SaveName:"RANK"}
					,{ Align:"Left",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유형",			SaveName:"TYPE_BEFORE_ONE"}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME"}
					,{ Align:"Rigt",	Width:100,	Edit:false,	Hidden:false,	Type:"Float",		Header:"매출금액",			SaveName:"ITEM_AMT",	Format:"${priceFormat}"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급평가",		SaveName:"DSS_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급메시지",	SaveName:"DSS_MSG"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"취급메이커",		SaveName:"REF_MAKER"}
	];
	
	IBS_InitSheet(mySheet7, initsheet7,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet7, "AGENT_NAME");	//협력사
	
	// mySheet8  C. 전국 거래실적(SG)
	var initsheet8 = {};
	initsheet8.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus",		EditLen:0}
					,{ Align:"Center",	Width:20,	Edit:true,	Hidden:false,	Type:"DummyCheck",	Header:"",			SaveName:"SELECTED"}
					,{ Align:"Center",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"순위",		SaveName:"RANK"}
					,{ Align:"Left",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유형",		SaveName:"TYPE_BEFORE_ONE"}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"협력사코드",	SaveName:"AGENT"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME"}
					,{ Align:"Rigt",	Width:90,	Edit:false,	Hidden:false,	Type:"Float",		Header:"매출금액",		SaveName:"ITEM_AMT",	Format:"${priceFormat}"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급평가",	SaveName:"DSS_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급메시지",SaveName:"DSS_MSG"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"취급메이커",	SaveName:"REF_MAKER"}
	];
	
	IBS_InitSheet(mySheet8, initsheet8,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet8, "AGENT_NAME");	//협력사
	
	// mySheet9 팝업 중간의 별도의 조회 결과 시트
	var initsheet9 = {};
	initsheet9.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus",		EditLen:0}
					,{ Align:"Center",	Width:20,	Edit:true,	Hidden:false,	Type:"DummyCheck",	Header:"",			SaveName:"SELECTED"}
					,{ Align:"Left",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유형",		SaveName:"TYPE_BEFORE_ONE"}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"협력사코드",	SaveName:"AGENT"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",		Header:"협력사",		SaveName:"AGENT_NAME"}
					,{ Align:"Left",	Width:130,	Edit:false,	Hidden:false,	Type:"Text",		Header:"지역",		SaveName:"AREA"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",		Header:"대표거래 고객사",SaveName:"MAJOR_COM"}
					,{ Align:"Right",	Width:90,	Edit:false,	Hidden:false,	Type:"Int",			Header:"거래횟수",		SaveName:"TCNT"}
					,{ Align:"Right",	Width:130,	Edit:false,	Hidden:false,	Type:"Float",		Header:"거래금액",		SaveName:"TAMT",		Format:"${priceFormat}"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급평가",	SaveName:"DSS_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급메시지",SaveName:"DSS_MSG"}
	];
	
	IBS_InitSheet(mySheet9, initsheet9,pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet9, "AGENT_NAME");	//협력사

	
	//mySheet10 팝업 맨 아래 시트
	var initsheet10 = {};
	initsheet10.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",		Header:"상태",				SaveName:"sStatus",			EditLen:0}
					,{ Align:"Center",	Width:20,	Edit:true,	Hidden:false,	Type:"DummyCheck",	Header:"",					SaveName:"SELECTED"}
					,{ Align:"Left",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유형",				SaveName:"TYPE_BEFORE_ONE"} 
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"협력사코드",			SaveName:"AGENT"}
					,{ Align:"Left",	Width:170,	Edit:false,	Hidden:false,	Type:"Text",		Header:"협력사",				SaveName:"AGENT_NAME"}
					,{ Align:"Left",	Width:60,	Edit:false,	Hidden:false,	Type:"Text",		Header:"대표자",				SaveName:"CEO_NAME_LOC"}
					,{ Align:"Left",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",		Header:"전화번호",				SaveName:"TEL_NO"}
					,{ Align:"Left",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",		Header:"FAX",				SaveName:"FAX_NO"}
					,{ Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type:"Float",		Header:"매출단가",				SaveName:"ATOB_UNIT_PRICE",	Format:"${priceFormat}"}
					,{ Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type:"Float",		Header:"매입단가",				SaveName:"STOA_LIST_PRICE",	Format:"${priceFormat}"}
					,{ Align:"Left",	Width:130,	Edit:false,	Hidden:false,	Type:"Text",		Header:"지역",				SaveName:"AREA"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",		Header:"대표거래 고객사"	,		SaveName:"MAJOR_COM"}
					,{ Align:"Right",	Width:70,	Edit:false,	Hidden:false,	Type:"Int",			Header:"거래횟수",				SaveName:"TCNT"}
					,{ Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type:"Float", 		Header:"거래금액",				SaveName:"TAMT",			Format:"${priceFormat}"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:true,	Type:"Text",		Header:"DSS_CHOICE",		SaveName:"DSS_CHOICE"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:true,	Type:"Text",		Header:"GPL_LIST_PRICE",	SaveName:"GPL_LIST_PRICE"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:true,	Type:"Text",		Header:"GPL_DLVRY_LT",		SaveName:"GPL_DLVRY_LT"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:true,	Type:"Text",		Header:"GPL_TAX_TYPE",		SaveName:"GPL_TAX_TYPE"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:true,	Type:"Text",		Header:"GPL_MIN_ORDER_QTY",	SaveName:"GPL_MIN_ORDER_QTY"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:true,	Type:"Text",		Header:"GPL_PUR_UNIT_QTY",	SaveName:"GPL_PUR_UNIT_QTY"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:true,	Type:"Text",		Header:"GPL_SELLER_AREA",	SaveName:"GPL_SELLER_AREA"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:true,	Type:"Text",		Header:"GPL_SELLER_ITEM_NO",SaveName:"GPL_SELLER_ITEM_NO"}
	];
	
	IBS_InitSheet(mySheet10, initsheet10,pagingMode);
	
	if ('${param.st_buyer_code}' == ""){
		mySheet10.SetColHidden("ATOB_UNIT_PRICE", true);
		mySheet10.SetColHidden("STOA_LIST_PRICE", true);
	}
	
	//하이퍼링크 설정
	setLinkCol(mySheet10, "AGENT_NAME");	//협력사
	
	// mySheet12 -G. GPL단가 기준 + 삼성단가 기준
	var initsheet12 = {};
	initsheet12.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:false,		Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus",			EditLen:0}
					,{ Align:"Center",	Width:20,	Edit:true,		Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED"}
					,{ Align:"Left",	Width:100,	Edit:false,		Hidden:false,	Type:"Text",		Header:"구분",			SaveName:"BUYER"}
					,{ Align:"Left",	Width:30,	Edit:false,		Hidden:false,	Type:"Text",		Header:"유형",			SaveName:"TYPE_BEFORE_ONE"} 
					,{ Align:"Left",	Width:100,	Edit:false,		Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
					,{ Align:"Left",	Width:190,	Edit:false,		Hidden:false,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME"}
					,{ Align:"Left",	Width:60,	Edit:false,		Hidden:false,	Type:"Text",		Header:"대표자",			SaveName:"CEO_NAME_LOC"}
					,{ Align:"Center",	Width:60,	Edit:false,		Hidden:false,	Type:"Text",		Header:"우편번호",			SaveName:"ZIP_CODE"}
					,{ Align:"Left",	Width:160,	Edit:false,		Hidden:false,	Type:"Text",		Header:"지역",			SaveName:"AREA"}
					,{ Align:"Rigt",	Width:80,	Edit:false,		Hidden:false,	Type:"Float",		Header:"매입단가",			SaveName:"LIST_PRICE",		Format:"${priceFormat}",}
					,{ Align:"Rigt",	Width:50,	Edit:false,		Hidden:false,	Type:"Float",		Header:"조달일수",			SaveName:"DELIVERY_LT",		Format:"${priceFormat}",}
					,{ Align:"Rigt",	Width:60,	Edit:false,		Hidden:false,	Type:"Date",		Header:"단가유효일",		SaveName:"TO_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,		Hidden:true,	Type:"Text",		Header:"신용등급평가",		SaveName:"DSS_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,		Hidden:true,	Type:"Text",		Header:"신용등급메시지",	SaveName:"DSS_MSG"}
					,{ Align:"Center",	Width:100,	Edit:false,		Hidden:true,	Type:"Text",		Header:"TAX_TYPE",		SaveName:"TAX_TYPE"}
					,{ Align:"Center",	Width:100,	Edit:false,		Hidden:true,	Type:"Text",		Header:"MIN_ORDER_QTY",	SaveName:"MIN_ORDER_QTY"}
					,{ Align:"Center",	Width:100,	Edit:false,		Hidden:true,	Type:"Text",		Header:"PUR_UNIT_QTY",	SaveName:"PUR_UNIT_QTY"}
					,{ Align:"Center",	Width:100,	Edit:false,		Hidden:true,	Type:"Text",		Header:"SELLER_AREA",	SaveName:"SELLER_AREA"}
					,{ Align:"Center",	Width:100,	Edit:false,		Hidden:true,	Type:"Text",		Header:"SELLER_ITEM_NO",SaveName:"SELLER_ITEM_NO"}
					
	];
	
	IBS_InitSheet(mySheet12, initsheet12,pagingMode);
	//하이퍼링크 설정
	setLinkCol(mySheet12, "AGENT_NAME");	//협력사
	
	//mysheet15 - 표준카탈로그에 매핑 된 타 고객사 계약정보
	var initsheet15 = {};
	initsheet15.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus",			EditLen:0}
					,{ Align:"Center",	Width:20,	Edit:true,	Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED"}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"고객사코드",		SaveName:"BUYER"}
					,{ Align:"Left",	Width:160,	Edit:false,	Hidden:false,	Type:"Text",		Header:"고객사",			SaveName:"BUYER_NAME"}
					,{ Align:"Left",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유형",			SaveName:"TYPE_BEFORE_ONE"} 
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME"}
					,{ Align:"Left",	Width:250,	Edit:false,	Hidden:false,	Type:"Text",		Header:"납품가능지역",		SaveName:"SELLER_AREA"}
					,{ Align:"Rigt",	Width:70,	Edit:false,	Hidden:false,	Type:"Float",		Header:"매입단가",			SaveName:"LIST_PRICE",		Format:"${priceFormat}"}
					,{ Align:"Rigt",	Width:70,	Edit:false,	Hidden:false,	Type:"Float",		Header:"조달일수",			SaveName:"DELIVERY_LT",		Format:"${priceFormat}"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급평가",		SaveName:"DSS_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급메시지",	SaveName:"DSS_MSG"}
	];
	
	IBS_InitSheet(mySheet15, initsheet15,pagingMode);
	//하이퍼링크 설정
	setLinkCol(mySheet15, "AGENT_NAME");	//협력사
	
	//mysheet17 - 지정협력사
	var initsheet17 = {};
	initsheet17.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus",			EditLen:0}
					,{ Align:"Center",	Width:20,	Edit:true,	Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED"}
					,{ Align:"Center",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"순위",			SaveName:"RANK"}
					,{ Align:"Left",	Width:30,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유형",			SaveName:"TYPE_BEFORE_ONE"}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
					,{ Align:"Left",	Width:190,	Edit:false,	Hidden:false,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME"}
					,{ Align:"Left",	Width:60,	Edit:false,	Hidden:true,	Type:"Text",		Header:"유통레벨코드",		SaveName:"DELY_LEVEL_CODE"}
					,{ Align:"Center",	Width:60,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유통레벨",			SaveName:"DELY_LEVEL_NAME"}
					,{ Align:"Left",	Width:60,	Edit:false,	Hidden:true,	Type:"Text",		Header:"납품가능지역",		SaveName:"DELY_AREA"}
					,{ Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type:"Float",		Header:"매출금액",			SaveName:"AGENT_AMT",		Format:"${priceFormat}"}
					,{ Align:"Left",	Width:80,	Edit:false,	Hidden:true,	Type:"Float",		Header:"KEP매출",			SaveName:"KEP_AMOUNT",		Format:"${priceFormat}"}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Float",		Header:"신평사자체매출",	SaveName:"CREDIT_AMOUNT",	Format:"${priceFormat}"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급평가",		SaveName:"DSS_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"신용등급메시지",	SaveName:"DSS_MSG"}
	];
	
	IBS_InitSheet(mySheet17, initsheet17,pagingMode);
	//하이퍼링크 설정
	setLinkCol(mySheet17, "AGENT_NAME");	//협력사
	
	//mysheet18 - 추천협력사
	var initsheet18 = {};
	initsheet18.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:false,		Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus",			EditLen:0}		
					,{ Align:"Center",	Width:20,	Edit:true,		Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED"}
					,{ Align:"Center",	Width:30,	Edit:false,		Hidden:false,	Type:"Text",		Header:"순위",			SaveName:"RANK"}
					,{ Align:"Left",	Width:30,	Edit:false,		Hidden:false,	Type:"Text",		Header:"유형",			SaveName:"TYPE_BEFORE_ONE"}					
					,{ Align:"Left",	Width:100,	Edit:false,		Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
					,{ Align:"Left",	Width:165,	Edit:false,		Hidden:false,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME"}
					,{ Align:"Left",	Width:60,	Edit:false,		Hidden:true,	Type:"Text",		Header:"유통레벨코드",		SaveName:"DELY_LEVEL_CODE"}
					,{ Align:"Center",	Width:45,	Edit:false,		Hidden:false,	Type:"Text",		Header:"유통레벨",			SaveName:"DELY_LEVEL_NAME"}
					,{ Align:"Left",	Width:60,	Edit:false,		Hidden:true,	Type:"Text",		Header:"납품가능지역",		SaveName:"DELY_AREA"}
					,{ Align:"Right",	Width:75,	Edit:false,		Hidden:false,	Type:"Float",		Header:"매출금액",			SaveName:"AGENT_AMT",		Format:"${priceFormat}"}
					,{ Align:"Left",	Width:80,	Edit:false,		Hidden:true,	Type:"Float",		Header:"KEP매출",			SaveName:"KEP_AMOUNT",		Format:"${priceFormat}"}
					,{ Align:"Left",	Width:100,	Edit:false,		Hidden:true,	Type:"Float",		Header:"신평사자체매출",	SaveName:"CREDIT_AMOUNT",	Format:"${priceFormat}"}
					,{ Align:"Center",	Width:45,	Edit:false,		Hidden:false,	Type:"Text",		Header:"지역구분",			SaveName:"AREA_CHECK"}
					,{ Align:"Center",	Width:100,	Edit:false,		Hidden:true,	Type:"Text",		Header:"신용등급평가",		SaveName:"DSS_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,		Hidden:true,	Type:"Text",		Header:"신용등급메시지",	SaveName:"DSS_MSG"}
	];
	
	IBS_InitSheet(mySheet18, initsheet18,pagingMode);
	//하이퍼링크 설정
	setLinkCol(mySheet18, "AGENT_NAME");	//협력사
	
	//mysheet19 - 운영사 견적특이사항
	var initsheet19 = {};
	initsheet19.Cols = [ 
					{ Align:"Center",	SaveName:"sStatus",	Header:"상태",	Type:"Status",	Width:50,	Hidden:1}
					,{ Align:"Left",	Width:430,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"특이사항",	SaveName:"ADD_NOTE"}
					,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"첨부",	SaveName:"IMAGE_KEY_IMG"}
					,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"첨부",	SaveName:"IMAGE_KEY"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"등록자",	SaveName:"ADD_USER_NM"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"등록일시",	SaveName:"ADD_DATE"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"수정자",	SaveName:"CHANGE_USER_NM"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"수정일시",	SaveName:"CHANGE_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BUYER",	SaveName:"BUYER"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"QUOTATION_NO",	SaveName:"QUOTATION_NO"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"QUOTATION_SEQ",	SaveName:"QUOTATION_SEQ"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"REVISION",	SaveName:"REVISION"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SEQ",	SaveName:"SEQ"}
					
	];
	
	IBS_InitSheet(mySheet19, initsheet19, pagingMode);
	
	mySheet19.SetImageList(2, diskOff);
	mySheet19.SetImageList(3, diskOn);
	
	//하이퍼링크 설정
	setLinkCol(mySheet19, "ADD_NOTE");	//특이사항
	setLinkCol(mySheet19, "IMAGE_KEY_IMG"); //첨부
	
	dssAgent();
	
	/*
	$("#st_sheet").val("1");
	kepSearchNoBar(document.searchCondition,  mySheet , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
	$("#st_sheet").val("2");
	kepSearchNoBar(document.searchCondition,  mySheet2 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
	$("#st_sheet").val("3");
	kepSearchNoBar(document.searchCondition,  mySheet3 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
	$("#st_sheet").val("4");
	kepSearchNoBar(document.searchCondition,  mySheet4 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
	$("#st_sheet").val("5");
	kepSearchNoBar(document.searchCondition,  mySheet5 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
	$("#st_sheet").val("6");
	kepSearchNoBar(document.searchCondition,  mySheet6 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
	$("#st_sheet").val("7");
	kepSearchNoBar(document.searchCondition,  mySheet7 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
	$("#st_sheet").val("8");
	kepSearchNoBar(document.searchCondition,  mySheet8 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
	
	*/
	$("#st_sheet").val("17");
	kepSearchNoBar(document.searchCondition,  mySheet17 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
	$("#st_sheet").val("18");
	kepSearchNoBar(document.searchCondition,  mySheet18 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
	$("#st_sheet").val("12");
	kepSearchNoBar(document.searchCondition,  mySheet12 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
	$("#st_sheet").val("15");
	kepSearchNoBar(document.searchCondition,  mySheet15 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
	$("#st_sheet").val("19");
	kepSearchNoBar(document.searchCondition,  mySheet19 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
	var multiAgent = "${param.st_multi_agent}";
	if (multiAgent != ""){
		$("#st_sheet").val("10");
		kepSearch(document.searchCondition,  mySheet10 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
	}
	
}
function dssAgent()
{
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mprq/getDssAgent.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { st_buyer_code: $("#st_buyer_code").val(),st_sg_id: $("#st_sg_id").val(),st_maker_code: $("#st_maker_code").val(),st_cms_categ_id: $("#st_cms_categ_id").val()},
	     async : false,
	     success:function( response ) {
		    	 if (response.data.length > 0){
		    		var D_AGENT = $.trim(eval("response.data[0].AGENT")); 
		    		$("#st_dss_agent").val(D_AGENT);
		    	 }
		      },
		 error:function( response ) {  		    	   
	    	 alert("오류발생하였습니다.");
		      }	
	 }); 
}
//조회 후처리
function mySheet13_OnSearchEnd(code, msg) {
	var totRow = mySheet13.RowCount();
	if( totRow<= 0) return;
	
	for(var i=1; i<=totRow;i++){
		var dss_yn = mySheet13.GetCellValue(i, 'DSS_YN');
		var dss_msg = mySheet13.GetCellValue(i, 'DSS_MSG');
		var ref_maker = mySheet13.GetCellValue(i, 'REF_MAKER');
		if(dss_yn == "N"){		
			mySheet13.SetCellEditable(i, "SELECTED", 0);
			mySheet13.SetToolTipText(i, "SELECTED", dss_msg);
		}
		mySheet13.SetToolTipText(i, "AGENT_NAME", ref_maker);
		if($("#st_dss_agent").val() == mySheet13.GetCellValue(i, 'AGENT')){
			mySheet13.SetCellFontColor(i,"AGENT_NAME","#FF0000");
		}
	}
	
	if (msg != "") {
		alert(msg);
	}
}
//조회 후처리
function mySheet14_OnSearchEnd(code, msg) {
	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;
	
	for(var i=1; i<=totRow;i++){
		var dss_yn = mySheet14.GetCellValue(i, 'DSS_YN');
		var dss_msg = mySheet14.GetCellValue(i, 'DSS_MSG');
		var ref_maker = mySheet14.GetCellValue(i, 'REF_MAKER');
		if(dss_yn == "N"){		
			mySheet14.SetCellEditable(i, "SELECTED", 0);
			mySheet14.SetToolTipText(i, "SELECTED", dss_msg);
		}
		mySheet14.SetToolTipText(i, "AGENT_NAME", ref_maker);
		if($("#st_dss_agent").val() == mySheet14.GetCellValue(i, 'AGENT')){
			mySheet14.SetCellFontColor(i,"AGENT_NAME","#FF0000");
		}
	}
	
	if (msg != "") {
		alert(msg);
	}
}
//조회 후처리
function mySheet_OnSearchEnd(code, msg) {
	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;
	
	for(var i=1; i<=totRow;i++){
		var dss_yn = mySheet.GetCellValue(i, 'DSS_YN');
		var dss_msg = mySheet.GetCellValue(i, 'DSS_MSG');
		var ref_maker = mySheet.GetCellValue(i, 'REF_MAKER');
		if(dss_yn == "N"){		
			mySheet.SetCellEditable(i, "SELECTED", 0);
			mySheet.SetToolTipText(i, "SELECTED", dss_msg);
		}
			mySheet.SetToolTipText(i, "AGENT_NAME", ref_maker);
		if($("#st_dss_agent").val() == mySheet.GetCellValue(i, 'AGENT')){
			mySheet.SetCellFontColor(i,"AGENT_NAME","#FF0000");
		}
	}
	
	if (msg != "") {
		alert(msg);
	}
}
function mySheet2_OnSearchEnd(code, msg) {
	var totRow = mySheet2.RowCount();
	if( totRow<= 0) return;
	
	for(var i=1; i<=totRow;i++){
		var dss_yn = mySheet2.GetCellValue(i, 'DSS_YN');
		var dss_msg = mySheet2.GetCellValue(i, 'DSS_MSG');
		var ref_maker = mySheet2.GetCellValue(i, 'REF_MAKER');
		if(dss_yn == "N"){		
			mySheet2.SetCellEditable(i, "SELECTED", 0);
			mySheet2.SetToolTipText(i, "SELECTED", dss_msg);
		}
			mySheet2.SetToolTipText(i, "AGENT_NAME", ref_maker);
		if($("#st_dss_agent").val() == mySheet2.GetCellValue(i, 'AGENT')){
			mySheet2.SetCellFontColor(i,"AGENT_NAME","#FF0000");
		}			
	}
	
	if (msg != "") {
		alert(msg);
	}
}
function mySheet3_OnSearchEnd(code, msg) {
	var totRow = mySheet3.RowCount();
	if( totRow<= 0) return;
	
	for(var i=1; i<=totRow;i++){
		var dss_yn = mySheet3.GetCellValue(i, 'DSS_YN');
		var dss_msg = mySheet3.GetCellValue(i, 'DSS_MSG');
		var ref_maker = mySheet3.GetCellValue(i, 'REF_MAKER');
		if(dss_yn == "N"){		
			mySheet3.SetCellEditable(i, "SELECTED", 0);
			mySheet3.SetToolTipText(i, "SELECTED", dss_msg);
		}
			mySheet3.SetToolTipText(i, "AGENT_NAME", ref_maker);
	}
	
	if (msg != "") {
		alert(msg);
	}
}
function mySheet4_OnSearchEnd(code, msg) {
	var totRow = mySheet4.RowCount();
	if( totRow<= 0) return;
	
	for(var i=1; i<=totRow;i++){
		var dss_yn = mySheet4.GetCellValue(i, 'DSS_YN');
		var dss_msg = mySheet4.GetCellValue(i, 'DSS_MSG');
		var ref_maker = mySheet4.GetCellValue(i, 'REF_MAKER');
		if(dss_yn == "N"){		
			mySheet4.SetCellEditable(i, "SELECTED", 0);
			mySheet4.SetToolTipText(i, "SELECTED", dss_msg);
		}
			mySheet4.SetToolTipText(i, "AGENT_NAME", ref_maker);
	}
	
	if (msg != "") {
		alert(msg);
	}
}
function mySheet5_OnSearchEnd(code, msg) {
	var totRow = mySheet5.RowCount();
	if( totRow<= 0) return;
	
	for(var i=1; i<=totRow;i++){
		var dss_yn = mySheet5.GetCellValue(i, 'DSS_YN');
		var dss_msg = mySheet5.GetCellValue(i, 'DSS_MSG');
		var ref_maker = mySheet5.GetCellValue(i, 'REF_MAKER');
		if(dss_yn == "N"){		
			mySheet5.SetCellEditable(i, "SELECTED", 0);
			mySheet5.SetToolTipText(i, "SELECTED", dss_msg);
		}
			mySheet5.SetToolTipText(i, "AGENT_NAME", ref_maker);
		if($("#st_dss_agent").val() == mySheet5.GetCellValue(i, 'AGENT')){
			mySheet5.SetCellFontColor(i,"AGENT_NAME","#FF0000");
		}
	}
	
	if (msg != "") {
		alert(msg);
	}
}
function mySheet6_OnSearchEnd(code, msg) {
	var totRow = mySheet6.RowCount();
	if( totRow<= 0) return;
	
	for(var i=1; i<=totRow;i++){
		var dss_yn = mySheet6.GetCellValue(i, 'DSS_YN');
		var dss_msg = mySheet6.GetCellValue(i, 'DSS_MSG');
		var ref_maker = mySheet6.GetCellValue(i, 'REF_MAKER');
		if(dss_yn == "N"){		
			mySheet6.SetCellEditable(i, "SELECTED", 0);
			mySheet6.SetToolTipText(i, "SELECTED", dss_msg);
		}
			mySheet6.SetToolTipText(i, "AGENT_NAME", ref_maker);
		if($("#st_dss_agent").val() == mySheet6.GetCellValue(i, 'AGENT')){
			mySheet6.SetCellFontColor(i,"AGENT_NAME","#FF0000");
		}
	}
	
	if (msg != "") {
		alert(msg);
	}
}
function mySheet7_OnSearchEnd(code, msg) {
	var totRow = mySheet7.RowCount();
	if( totRow<= 0) return;
	
	for(var i=1; i<=totRow;i++){
		var dss_yn = mySheet7.GetCellValue(i, 'DSS_YN');
		var dss_msg = mySheet7.GetCellValue(i, 'DSS_MSG');
		var ref_maker = mySheet7.GetCellValue(i, 'REF_MAKER');
		if(dss_yn == "N"){		
			mySheet7.SetCellEditable(i, "SELECTED", 0);
			mySheet7.SetToolTipText(i, "SELECTED", dss_msg);
		}
			mySheet7.SetToolTipText(i, "AGENT_NAME", ref_maker);
		if($("#st_dss_agent").val() == mySheet7.GetCellValue(i, 'AGENT')){
			mySheet7.SetCellFontColor(i,"AGENT_NAME","#FF0000");
		}
	}
	
	if (msg != "") {
		alert(msg);
	}
}
function mySheet8_OnSearchEnd(code, msg) {
	var totRow = mySheet8.RowCount();
	if( totRow<= 0) return;
	
	for(var i=1; i<=totRow;i++){
		var dss_yn = mySheet8.GetCellValue(i, 'DSS_YN');
		var dss_msg = mySheet8.GetCellValue(i, 'DSS_MSG');
		var ref_maker = mySheet8.GetCellValue(i, 'REF_MAKER');
		if(dss_yn == "N"){		
			mySheet8.SetCellEditable(i, "SELECTED", 0);
			mySheet8.SetToolTipText(i, "SELECTED", dss_msg);
		}
			mySheet8.SetToolTipText(i, "AGENT_NAME", ref_maker);
		if($("#st_dss_agent").val() == mySheet8.GetCellValue(i, 'AGENT')){
			mySheet8.SetCellFontColor(i,"AGENT_NAME","#FF0000");
		}
	}
	
	if (msg != "") {
		alert(msg);
	}
}
function mySheet9_OnSearchEnd(code, msg) {
	loader_obj("N");
	
	var totRow = mySheet9.RowCount();
	if( totRow<= 0) return;
	
	for(var i=1; i<=totRow;i++){
		var dss_yn = mySheet9.GetCellValue(i, 'DSS_YN');
		var dss_msg = mySheet9.GetCellValue(i, 'DSS_MSG');
		if(dss_yn == "N"){		
			mySheet9.SetCellEditable(i, "SELECTED", 0);
			mySheet9.SetToolTipText(i, "SELECTED", dss_msg);
		}
	}
	
	if (msg != "") {
		alert(msg);
	}
}
function mySheet10_OnSearchEnd(code, msg) {
	loader_obj("N");
	for ( var i =1; i <=mySheet10.RowCount(); i++) {
		mySheet10.SetCellValue(i,'SELECTED',1);
		if(mySheet10.GetCellValue(i,'DSS_CHOICE')=="H"){ //지정협력사는 edit 불가
			mySheet10.SetCellEditable(i, "SELECTED", 0);
		}		
	}
	if (msg != "") {
		alert(msg);
	}
}
function mySheet12_OnSearchEnd(code, msg) {
	loader_obj("N");
	
	var totRow = mySheet12.RowCount();
	if( totRow<= 0) return;
	for(var i=1; i<=totRow;i++){
		var dss_yn = mySheet12.GetCellValue(i, 'DSS_YN');
		var dss_msg = mySheet12.GetCellValue(i, 'DSS_MSG');
		if(dss_yn == "N"){		
			mySheet12.SetCellEditable(i, "SELECTED", 0);
			mySheet12.SetToolTipText(i, "SELECTED", dss_msg);
		}
	}
	if (msg != "") {
		alert(msg);
	}
}
function mySheet15_OnSearchEnd(code, msg) {
	loader_obj("N");
	
	var totRow = mySheet15.RowCount();
	if( totRow<= 0) return;
	for(var i=1; i<=totRow;i++){
		var dss_yn = mySheet15.GetCellValue(i, 'DSS_YN');
		var dss_msg = mySheet15.GetCellValue(i, 'DSS_MSG');
		if(dss_yn == "N"){	
			mySheet15.SetCellEditable(i, "SELECTED", 0);
			mySheet15.SetToolTipText(i, "SELECTED", dss_msg);
		}
	}
	if (msg != "") {
		alert(msg);
	}
}
function mySheet17_OnSearchEnd(code, msg) {
	loader_obj("N");
	
	var totRow = mySheet17.RowCount();
	if( totRow<= 0) return;
	
	mySheet17.RowDelete(1); //기존값 삭제

	if (msg != "") {
		alert(msg);
	}
}
function mySheet18_OnSearchEnd(code, msg) {

	loader_obj("N");
	//최찬규
	var totRow = mySheet18.RowCount();
	if( totRow<= 0) return;

	var max_count = 4; //제조,총판 제외한 최대 4개
	var rank = 1;
	var move_row = []; //지정협력사로 이동할 agent
	var delete_row = []; //추천협력사에서 지울 agent
	
	var buyer_dely_area = $("#st_dely_area").val(); //납품가능지역

	//제조사 & 총판 
	var kep_index1 = "";
	var kep_index2 = "";
	
	//대리점권 보유 하면서 kep거래금액 상위순서(최대 3개)
	var kep_rank1 = "";
	var kep_rank2 = "";
	var kep_rank3 = "";	
	var kep_index3 = "";
	var kep_index4 = "";
	var kep_index5 = "";
	
	//대리점권 보유 하면서 자체매출 상위 순서(최대 4개)
	var credit_rank1 = "";
	var credit_rank2 = "";
	var credit_rank3 = "";
	var credit_rank4 = "";
	var kep_index6 = "";
	var kep_index7 = "";
	var kep_index8 = "";
	var kep_index9 = "";
	
	//대리점권 미보유 kep 거래금액 상위순서(최대 4개)
	var kep_no_rank1 = "";
	var kep_no_rank2 = "";
	var kep_no_rank3 = "";
	var kep_no_rank4 = "";
	var kep_index10 = "";
	var kep_index11 = "";
	var kep_index12 = "";
	var kep_index13 = "";

	//지정협력사로 가야되는 협력사들 순위 정하기
	for(var i=1; i<=totRow;i++){
		var dely_level_code = mySheet18.GetCellValue(i,"DELY_LEVEL_CODE"); //유통레벨
		var agent_dely_area = mySheet18.GetCellValue(i,"DELY_AREA"); //납품가능지역
		var area_check = AreaCheck(buyer_dely_area,agent_dely_area); //납품가능지역 비교
		
		if(area_check == "TRUE"){//해당지역
			mySheet18.SetCellValue(i, 'AREA_CHECK', '지역內'); //지역내 표시
			if(dely_level_code =="AA"){ //제조사
				kep_index1 = i; 
			}else if(dely_level_code =="CC"){ //총판
				kep_index2 = i;
			}else if(dely_level_code == "BB"){//대리점권 보유
				var kepAmount =  mySheet18.GetCellValue(i,"KEP_AMOUNT");
				if(kepAmount > 0){//kep거래금액 있는 경우
					if(kepAmount > kep_rank1){
						kep_rank3 = kep_rank2;
						kep_rank2 = kep_rank1;
						kep_rank1 = kepAmount;
						kep_index5 = kep_index4;
						kep_index4 = kep_index3;
						kep_index3 = i;
					}else if(kepAmount > kep_rank2){
						kep_rank3 = kep_rank2;
						kep_rank2 = kepAmount;
						kep_index5 = kep_index4;
						kep_index4 = i;
					}else if(kepAmount > kep_rank3){
						kep_rank3 = kepAmount;
						kep_index5 = i;
					}
				}
				else{ //kep거래금액 없는 경우 , 자체매출로 순위
					var creditAmount =  mySheet18.GetCellValue(i,"CREDIT_AMOUNT");
					if(creditAmount > 0){ //자체매출 금액 있어야함
						if(creditAmount > credit_rank1){
							credit_rank4 = credit_rank3;
							credit_rank3 = credit_rank2;
							credit_rank2 = credit_rank1;
							credit_rank1 = creditAmount;
							kep_index9 = kep_index8;
							kep_index8 = kep_index7;
							kep_index7 = kep_index6;
							kep_index6 = i;
						}else if(creditAmount > credit_rank2){
							credit_rank4 = credit_rank3;
							credit_rank3 = credit_rank2;
							credit_rank2 = creditAmount;
							kep_index9 = kep_index8;
							kep_index8 = kep_index7;
							kep_index7 = i;						
						}else if(creditAmount > credit_rank3){
							credit_rank4 = credit_rank3;
							credit_rank3 = creditAmount;
							kep_index9 = kep_index8;
							kep_index8 = i;
						}else if(creditAmount > credit_rank4){
							credit_rank4 = creditAmount;
							kep_index9 = i;
						}
					}
				}
			}else{ //대리점권 미보유 - kep거래금액 순위 
				var kepNoAmount =  mySheet18.GetCellValue(i,"KEP_AMOUNT");
				if(kepNoAmount > 0){//kep거래금액 있어야함
					if(kepNoAmount > kep_no_rank1){
						kep_no_rank4 = kep_no_rank3;
						kep_no_rank3 = kep_no_rank2;
						kep_no_rank2 = kep_no_rank1;
						kep_no_rank1 = kepNoAmount;
						kep_index13 = kep_index12;
						kep_index12 = kep_index11;
						kep_index11 = kep_index10;
						kep_index10 = i;
					}else if(kepNoAmount > kep_no_rank2){
						kep_no_rank4 = kep_no_rank3;
						kep_no_rank3 = kep_no_rank2;
						kep_no_rank2 = kepNoAmount;
						kep_index13 = kep_index12;
						kep_index12 = kep_index11;
						kep_index11 = i;
					}else if(kepNoAmount > kep_no_rank3){
						kep_no_rank4 = kep_no_rank3;
						kep_no_rank3 = kepNoAmount;
						kep_index13 = kep_index12;
						kep_index12 = i;
					}else if(kepNoAmount > kep_no_rank4){
						kep_no_rank4 = kepNoAmount;
						kep_index13 = i;
					}
				}
			}
		}
		else{ //불가지역
			mySheet18.SetCellValue(i, 'AREA_CHECK', '지역外'); //지역외 표시
		}
	}
	//지정협력사로 옮겨야 할 인덱스
	for(var i = 1; i<=13;i++)
		move_row.push(eval("kep_index"+i));

	//지정협력사에 추가하기
	for(var i = 0; i<move_row.length; i++){
		if(mySheet18.GetCellValue(move_row[i],"AGENT_NAME") != -1){
			delete_row.push(mySheet18.GetCellValue(move_row[i],"AGENT"));
			var rows = mySheet17.DataInsert(-1);
	 		mySheet17.SetCellValue(rows, 'RANK',rank);
	 		mySheet17.SetCellValue(rows, 'AGENT', mySheet18.GetCellValue(move_row[i],"AGENT"));
	 		mySheet17.SetCellValue(rows, 'AGENT_NAME', mySheet18.GetCellValue(move_row[i],"AGENT_NAME"));
	 		mySheet17.SetCellValue(rows, 'DELY_LEVEL_CODE',mySheet18.GetCellValue(move_row[i],"DELY_LEVEL_CODE"));
	 		mySheet17.SetCellValue(rows, 'DELY_LEVEL_NAME', mySheet18.GetCellValue(move_row[i],"DELY_LEVEL_NAME"));
	 		mySheet17.SetCellValue(rows, 'DELY_AREA', mySheet18.GetCellValue(move_row[i],"DELY_AREA"));
	 		mySheet17.SetCellValue(rows, 'AGENT_AMT', mySheet18.GetCellValue(move_row[i],"KEP_AMOUNT"));
	 		mySheet17.SetCellValue(rows, 'KEP_AMOUNT', mySheet18.GetCellValue(move_row[i],"KEP_AMOUNT"));
	 		mySheet17.SetCellValue(rows, 'CREDIT_AMOUNT', mySheet18.GetCellValue(move_row[i],"CREDIT_AMOUNT"));
	 		mySheet17.SetCellValue(rows, 'DSS_YN', mySheet18.GetCellValue(move_row[i],"DSS_YN"));
	 		mySheet17.SetCellValue(rows, 'DSS_MSG', mySheet18.GetCellValue(move_row[i],"DSS_MSG"));
	 		mySheet17.SetCellValue(rows, 'TYPE_BEFORE_ONE', mySheet18.GetCellValue(move_row[i],"TYPE_BEFORE_ONE"));
			mySheet17.SetCellEditable(rows, "SELECTED", 0); //지정협력사는 edit 불가
			mySheet17.SetCellValue(rows, "SELECTED", 1); //무조건 체크표시		
	 		var dss_yn = mySheet17.GetCellValue(rows, 'DSS_YN');
			var dss_msg = mySheet17.GetCellValue(rows, 'DSS_MSG');
			if(dss_yn == "N"){
				mySheet17.SetCellValue(rows, "SELECTED", 0);
				mySheet17.SetCellEditable(rows, "SELECTED", 0);
				mySheet17.SetToolTipText(rows, "SELECTED", dss_msg);
			}
	 		rank++;
	 		if(i >= 2){ //제조,총판을 뺀 나머지 중 최대 4개
	 			max_count--;
	 			if(max_count == 0)
					break;
			}	
		}
	}
	
	//지정협력사로 옮긴 협력사들 , 추천협력사에서 삭제하기
	for(var i = 0; i<delete_row.length;i++){
		for(var j = 1; j<=totRow;j++){
			if(delete_row[i] == mySheet18.GetCellValue(j,"AGENT")){
				mySheet18.RowDelete(j); //추천협력사쪽에서 삭제
				continue;
			}
		}	
	}
	
	totRow = mySheet18.RowCount();
	rank = 1;
	for(var i = 1; i<=totRow;i++){
		mySheet18.SetCellValue(i, 'RANK',rank);
		rank++;
	}
	if (msg != "") {
		alert(msg);
	}
}

function mySheet19_OnSearchEnd(code, msg) {
	loader_obj("N");
	
	var totRow = mySheet19.RowCount();
	if( totRow<= 0) return;
	if (msg != "") {
		alert(msg);
	}
}
var st;
var mt;
var misumiPop;
// 기능함수
function doAction(str) {
	
	switch (str) {
	case "searchHead":	 // 조회
		$("#st_sheet").val("1");
		kepSearchNoBar(document.searchCondition,  mySheet , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
		$("#st_sheet").val("2");
		kepSearchNoBar(document.searchCondition,  mySheet2 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
		$("#st_sheet").val("3");
		kepSearchNoBar(document.searchCondition,  mySheet3 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
		$("#st_sheet").val("4");
		kepSearchNoBar(document.searchCondition,  mySheet4 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
		$("#st_sheet").val("5");
		kepSearchNoBar(document.searchCondition,  mySheet5 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
		$("#st_sheet").val("6");
		kepSearchNoBar(document.searchCondition,  mySheet6 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
		$("#st_sheet").val("7");
		kepSearchNoBar(document.searchCondition,  mySheet7 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
		$("#st_sheet").val("8");
		kepSearchNoBar(document.searchCondition,  mySheet8 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
		$("#st_sheet").val("13");
		kepSearchNoBar(document.searchCondition,  mySheet13 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
		$("#st_sheet").val("14");
		kepSearchNoBar(document.searchCondition,  mySheet14 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
		break;
	case "search":	 // 조회
		if (kepIsValueNull($('#st_agent_name').val()) && kepIsValueNull($('#st_maker_name2').val()) && kepIsValueNull($('#st_item_name').val()) ){
			alert('조회조건을 선택하세요.');
			return;
		}
	
		$("#st_sheet").val("9");
		kepSearch(document.searchCondition,  mySheet9 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
// 		kepReload('searchCondition');
		$('#st_agent_name').val('');
		$('#st_maker_name2').val('');
		$('#st_maker_code2').val('');
		$('#st_item_name').val('');
		$('#st_item_code').val('');
		mySheet9.RemoveAll();
		mySheet10.RemoveAll();
		break;
	case "misumiOepn":		
		
		var myForm	= document.qtKey;
		var conForm	= document.searchCondition;
		myForm.qt_buyer.value	= conForm.st_buyer_code.value;
		myForm.qt_quotation_no.value	= conForm.st_quotation_no.value;
		myForm.qt_quotation_seq.value	= conForm.st_quotation_seq.value;
		myForm.qt_revision.value	= conForm.st_revision.value;
		
		myForm.action	= "/misOpenPop.jsp";
		myForm.target	= "MisumiPop";

		misumiPop = window.open("about:blank","MisumiPop","width=1300,height=600,scrollbars=yes, resize=yes");
		
		myForm.submit();
		break;
	case "misumiAdd":	
		callbackMisumi();
		break;
		
	case "add_note":
		var st_buyer = document.searchCondition.st_buyer_code.value;
		var st_quotation_no = document.searchCondition.st_quotation_no.value;
		var st_quotation_seq = document.searchCondition.st_quotation_seq.value;
		var st_revision = document.searchCondition.st_revision.value;
		openSearchPopup("/mprq/showMasterMpRqQutationRemark.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "850,350,no");
		break;
	}
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction('search');
	}
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqDssSellerSelList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "commonCoCoLocationDetailPop": // 소재지역명
			openSearchPopup('/coco/showCommonCoCoLocationDetailPop.do','?st_ag_id='+$("#st_ag_id").val()+"&open=Y","500,400,no");
			popupSel = "commonCoCoLocationDetailPop";
			break;
		case "maker": // 제조사
			openSearchPopup("/common/agentRegMakerCodePop.do", '?st_ag_id='+$("#st_ag_id").val()+"&open=Y", "500,500,no");
			popupSel = "maker";
			break;
		case "commonCoCoTranGoodsPop": // 제조사
			openSearchPopup('/coco/getCommonCoCoTranGoodsPop.do','',"600,500,no");
			break;
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "maker") {	// 제조사
		$("#st_maker_code2").val(value1);
		$("#st_maker_name2").val(value2);
		
	} else if (popupSel == "commonCoCoTranGoodsPop") {	// 품목군
		$("#st_item_code").val(value1);
		$("#st_item_name").val(value2);
		
	}else if(popupSel == "remarkBAS") {	//고객사 비고
		mySheet.SetCellValue(grbRow, 'ATOB_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'ATOB_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
	
	}else if(popupSel == "remarkAtoS2") {	//고객사 비고
		mySheet.SetCellValue(grbRow, 'ATOS_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'ATOS_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
			
	}
	grbRow="";	//초기화
}
//그리드 셀클릭 이벤트
function mySheet13_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet13.ColSaveName(mySheet13.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet13.GetCellValue(Row,"AGENT");
		openSearchPopup("/mdcp/showMasterMdCpAgntcmpyInfoAlterPop.do", "?com_code=" + agent + "&simsaLevel=3", "950,670,no");
	}
}
//그리드 셀클릭 이벤트
function mySheet14_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet14.ColSaveName(mySheet14.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet14.GetCellValue(Row,"AGENT");
		openSearchPopup("/mdcp/showMasterMdCpAgntcmpyInfoAlterPop.do", "?com_code=" + agent + "&simsaLevel=3", "950,670,no");
	}
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
	}
}
// 그리드 셀클릭 이벤트
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet2.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
	}
}
// 그리드 셀클릭 이벤트
function mySheet3_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet3.ColSaveName(mySheet3.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet3.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
	}
}
// 그리드 셀클릭 이벤트
function mySheet4_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet4.ColSaveName(mySheet4.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet4.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
	}
}
// 그리드 셀클릭 이벤트
function mySheet5_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet5.ColSaveName(mySheet5.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet5.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
	}
}
// 그리드 셀클릭 이벤트
function mySheet6_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet6.ColSaveName(mySheet6.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet6.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
	}
}
// 그리드 셀클릭 이벤트
function mySheet7_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet7.ColSaveName(mySheet7.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet7.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
	}
}
// 그리드 셀클릭 이벤트
function mySheet8_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet8.ColSaveName(mySheet8.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet8.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
	}
}
// 그리드 셀클릭 이벤트
function mySheet9_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet9.ColSaveName(mySheet9.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet9.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
	}
}
// 그리드 셀클릭 이벤트
function mySheet10_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet10.ColSaveName(mySheet10.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet10.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
	}
}
//그리드 셀클릭 이벤트
function mySheet12_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet12.ColSaveName(mySheet12.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet12.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
	}
}
//그리드 셀클릭 이벤트
function mySheet15_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet15.ColSaveName(mySheet15.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet15.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
	}
}
//그리드 셀클릭 이벤트
function mySheet17_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet17.ColSaveName(mySheet17.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet17.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
	}
}
//그리드 셀클릭 이벤트
function mySheet18_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet18.ColSaveName(mySheet18.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet18.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
	}
}
//그리드 셀클릭 이벤트
function mySheet19_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet19.ColSaveName(mySheet19.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if(column == "IMAGE_KEY_IMG"){
		popupSel = "remarkFileUpload";
		var type="RFQ";
		var viewType="R";
		var image_key=mySheet19.GetCellValue(Row, "IMAGE_KEY");
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}else if(column == "ADD_NOTE" ){ //특이사항 입력
		var st_buyer = mySheet19.GetCellValue(Row,"BUYER");
		var st_quotation_no = mySheet19.GetCellValue(Row,"QUOTATION_NO");
		var st_quotation_seq = mySheet19.GetCellValue(Row,"QUOTATION_SEQ");
		var st_revision = mySheet19.GetCellValue(Row,"REVISION");
		openSearchPopup("/mprq/showMasterMpRqQutationRemark.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "850,350,no");
	}
}
//마우스 이동시 이벤트
function mySheet13_OnMouseMove(Button, Shift, X, Y) {
	//마우스 위치를 행과 컬럼과 값 가져오기
	var Row = mySheet13.MouseRow();
	var dss_yn = mySheet13.GetCellValue(Row, 'DSS_YN');
	if(dss_yn == "N"){		
		mySheet13.SetToolTipText(Row, "SELECTED", "신용등급 미평가로 거래불가");
	}
}
//마우스 이동시 이벤트
function mySheet14_OnMouseMove(Button, Shift, X, Y) {
	//마우스 위치를 행과 컬럼과 값 가져오기
	var Row = mySheet14.MouseRow();
	var dss_yn = mySheet14.GetCellValue(Row, 'DSS_YN');
	if(dss_yn == "N"){		
		mySheet14.SetToolTipText(Row, "SELECTED", "신용등급 미평가로 거래불가");
	}
}
// 마우스 이동시 이벤트
function mySheet2_OnMouseMove(Button, Shift, X, Y) {
	//마우스 위치를 행과 컬럼과 값 가져오기
	var Row = mySheet2.MouseRow();
// 	var Col = mySheet2.MouseCol();
	var dss_yn = mySheet2.GetCellValue(Row, 'DSS_YN');
	if(dss_yn == "N"){		
		mySheet2.SetToolTipText(Row, "SELECTED", "신용등급 미평가로 거래불가");
	}
}
// 비활성화
var gridFlag = "f";
function kepHidden(flag){
// 	alert($("#gridArea").is(':visible'));
	if (flag == 'hidden'){
		$("#minus").hide();
		$("#plus").show();
		$("#searchMode").hide();
		if ($("#gridArea").is(':visible') == true){
			$("#searchArea").css("height",  "268px");		
		} else {
			$("#searchArea").css("height",  "440px");
		}
	} else if (flag == 'show'){
		$("#minus").show();
		$("#plus").hide();
		$("#searchMode").show();
		if ($("#gridArea").is(':visible') == true){
			$("#searchArea").css("height",  "150px");		
		} else {
			$("#searchArea").css("height",  "440px");
		}
	} else if (flag == 'girdShow' && gridFlag == 'f'){ // 추천협력사
		$("#gridArea").hide();
		$("#searchArea").css("height",  "440px");
		$("#ms9").css("height",  "220px");
		$("#ms10").css("height",  "220px");
		gridFlag = 't';
	} else if (flag == 'girdShow' && gridFlag == 't'){
		$("#gridArea").show();
		$("#searchArea").css("height",  "150px");	
		$("#ms9").css("height",  "100px");
		$("#ms10").css("height",  "100px");
		gridFlag = 'f';
	}
}
function checkLoc(value){
	var search = kepSelectOptionVal('st_loc_dept1');
	kepAjaxCommonQueryIdSearchCombo("st_loc_dept2","common.getLocCode",search,"ALL","");
}
function getCheckedAgent(){
	//우선순위(A,B,C,S,N)
	var AgentList = "";
	var SearchAgentList = "";
	var AgentDssList = "";
	var SearchAgentDssList = "";
	for(var i = 1; i<= mySheet10.RowCount();i++){
		AgentList += mySheet10.GetCellValue(i,"AGENT") + ",";
		if(mySheet10.GetCellValue(i,"DSS_CHOICE")  == "G"){
			AgentDssList += mySheet10.GetCellValue(i,"AGENT") + mySheet10.GetCellValue(i,"DSS_CHOICE")
									+"^"+ mySheet10.GetCellValue(i,"GPL_LIST_PRICE")
									+"^"+ mySheet10.GetCellValue(i,"GPL_DLVRY_LT")
									+"^"+ mySheet10.GetCellValue(i,"GPL_TAX_TYPE")
									+"^"+ mySheet10.GetCellValue(i,"GPL_MIN_ORDER_QTY")
									+"^"+ mySheet10.GetCellValue(i,"GPL_PUR_UNIT_QTY")
									+"^"+ mySheet10.GetCellValue(i,"GPL_SELLER_AREA")
									+"^"+ mySheet10.GetCellValue(i,"GPL_SELLER_ITEM_NO")
									+",";
		}else{
			AgentDssList += mySheet10.GetCellValue(i,"AGENT") + mySheet10.GetCellValue(i,"DSS_CHOICE") + ",";
		}
		
	}
	if (AgentList != ""){
		SearchAgentList = AgentList + SearchAgentList;
		SearchAgentDssList = AgentDssList + SearchAgentDssList;
	}
	// 그리드가 보일 때에만 추가
	if ($("#gridArea").is(':visible') == true){
		
		var  arrDssI = new Array();
		
		// 추천협력사 리스트 추출 (추천에서 선택 안해도 추천으로 들어가게)
		for(var i = 1; i<= mySheet18.RowCount();i++){
			arrDssI.push(mySheet18.GetCellValue(i,"AGENT"));		
		}
		
		/* G (선택 시) >> H, I >> 그 외의 것 (I 중에 선택하지 않고 검색했을 경우 I로 들어감) ~> if(arrDssI.includes(cur_agent)) 이 구문 넣은 이유임.
		* >> 조회 시(원래 N으로 들어감) H, I 우선 순위.
		*/
		
		var selectedGrid12 = mySheet12.FindCheckedRow("SELECTED");
		var arrRow12 = selectedGrid12.split("|");
		if (selectedGrid12.length != 0){
			for(var i12=0; i12<arrRow12.length; i12++){
				if (SearchAgentList.indexOf(mySheet12.GetCellValue(arrRow12[i12],"AGENT")) == -1){
					SearchAgentList += mySheet12.GetCellValue(arrRow12[i12],"AGENT") + ",";
					SearchAgentDssList += mySheet12.GetCellValue(arrRow12[i12],"AGENT") + "G" 
					+"^"+ mySheet12.GetCellValue(arrRow12[i12],"LIST_PRICE")
					+"^"+ mySheet12.GetCellValue(arrRow12[i12],"DELIVERY_LT")
					+"^"+ mySheet12.GetCellValue(arrRow12[i12],"TAX_TYPE")
					+"^"+ mySheet12.GetCellValue(arrRow12[i12],"MIN_ORDER_QTY")
					+"^"+ mySheet12.GetCellValue(arrRow12[i12],"PUR_UNIT_QTY")
					+"^"+ mySheet12.GetCellValue(arrRow12[i12],"SELLER_AREA")
					+"^"+ mySheet12.GetCellValue(arrRow12[i12],"SELLER_ITEM_NO")
					+",";
					
				} 
			}
		}
		
		var selectedGrid17 = mySheet17.FindCheckedRow("SELECTED");
		var arrRow17 = selectedGrid17.split("|");
		if (selectedGrid17.length != 0){
			for(var i17=0; i17<arrRow17.length; i17++){
				if (SearchAgentList.indexOf(mySheet17.GetCellValue(arrRow17[i17],"AGENT")) == -1){
					SearchAgentList += mySheet17.GetCellValue(arrRow17[i17],"AGENT") + ",";
					SearchAgentDssList += mySheet17.GetCellValue(arrRow17[i17],"AGENT") + "H"
					+",";
					
				} 
			}
		}
		
		var selectedGrid18 = mySheet18.FindCheckedRow("SELECTED");
		var arrRow18 = selectedGrid18.split("|");
		if (selectedGrid18.length != 0){
			for(var i18=0; i18<arrRow18.length; i18++){
				if (SearchAgentList.indexOf(mySheet18.GetCellValue(arrRow18[i18],"AGENT")) == -1){
					SearchAgentList += mySheet18.GetCellValue(arrRow18[i18],"AGENT") + ",";
					SearchAgentDssList += mySheet18.GetCellValue(arrRow18[i18],"AGENT") + "I"
					+",";
					
				} 
			}
		}
		
		var selectedGrid3 = mySheet3.FindCheckedRow("SELECTED");
		var arrRow3 = selectedGrid3.split("|");
		if (selectedGrid3.length != 0){
			for(var i3=0; i3<arrRow3.length; i3++){
				var cur_agent = mySheet3.GetCellValue(arrRow3[i3],"AGENT");
//				if (AgentList.indexOf(mySheet3.GetCellValue(arrRow3[i3],"AGENT")) == -1){
				if (SearchAgentList.indexOf(cur_agent) == -1){
					SearchAgentList += cur_agent + ",";
					if(arrDssI.includes(cur_agent)){
						SearchAgentDssList += cur_agent + "I" + ",";
					}else{
						SearchAgentDssList += cur_agent + "A" + ",";
					}
				}
// 				else {
// 					alert("이미 선택된 협력사가 존재합니다.");
// 					return;
// 				}
			}
		}
		
		var selectedGrid4 = mySheet4.FindCheckedRow("SELECTED");
		var arrRow4 = selectedGrid4.split("|");
		if (selectedGrid4.length != 0){
			for(var i4=0; i4<arrRow4.length; i4++){
				var cur_agent = mySheet4.GetCellValue(arrRow4[i4],"AGENT");
//				if (AgentList.indexOf(mySheet4.GetCellValue(arrRow4[i4],"AGENT")) == -1){
				if (SearchAgentList.indexOf(cur_agent) == -1){
					SearchAgentList += cur_agent + ",";
					if(arrDssI.includes(cur_agent)){
						SearchAgentDssList += cur_agent + "I" + ",";
					}else{
						SearchAgentDssList += cur_agent + "A" + ",";
					}
				} 
// 				else {
// 					alert("이미 선택된 협력사가 존재합니다.");
// 					return;
// 				}
			}
		}
		
		var selectedGrid5 = mySheet5.FindCheckedRow("SELECTED");
		var arrRow5 = selectedGrid5.split("|");
		if (selectedGrid5.length != 0){
			for(var i5=0; i5<arrRow5.length; i5++){
				var cur_agent = mySheet5.GetCellValue(arrRow5[i5],"AGENT");
//				if (AgentList.indexOf(mySheet5.GetCellValue(arrRow5[i5],"AGENT")) == -1){
				if (SearchAgentList.indexOf(cur_agent) == -1){
					SearchAgentList +=  cur_agent + ",";
					if(arrDssI.includes(cur_agent)){
						SearchAgentDssList += cur_agent + "I" + ",";
					}else{
						SearchAgentDssList += cur_agent + "B" + ",";
					}
				} 
// 				else {
// 					alert("이미 선택된 협력사가 존재합니다.");
// 					return;
// 				}
			}
		}
		
		var selectedGrid6 = mySheet6.FindCheckedRow("SELECTED");
		var arrRow6 = selectedGrid6.split("|");
		if (selectedGrid6.length != 0){
			for(var i6=0; i6<arrRow6.length; i6++){
				var cur_agent = mySheet6.GetCellValue(arrRow6[i6],"AGENT");
//				if (AgentList.indexOf(mySheet6.GetCellValue(arrRow6[i6],"AGENT")) == -1){
				if (SearchAgentList.indexOf(cur_agent) == -1){
					SearchAgentList += cur_agent + ",";
					if(arrDssI.includes(cur_agent)){
						SearchAgentDssList += cur_agent + "I" + ",";
					}else{
						SearchAgentDssList += cur_agent + "B" + ",";
					}
				} 
// 				else {
// 					alert("이미 선택된 협력사가 존재합니다.");
// 					return;
// 				}
			}
		}
		
		var selectedGrid7 = mySheet7.FindCheckedRow("SELECTED");
		var arrRow7 = selectedGrid7.split("|");
		if (selectedGrid7.length != 0){
			for(var i7=0; i7<arrRow7.length; i7++){
				var cur_agent = mySheet7.GetCellValue(arrRow7[i7],"AGENT");			
//				if (AgentList.indexOf(mySheet7.GetCellValue(arrRow7[i7],"AGENT")) == -1){
				if (SearchAgentList.indexOf(mySheet7.GetCellValue(arrRow7[i7],"AGENT")) == -1){
					SearchAgentList += cur_agent + ",";
					if(arrDssI.includes(cur_agent)){
						SearchAgentDssList += cur_agent + "I" + ",";
					}else{
						SearchAgentDssList += cur_agent + "C" + ",";
					}
				} 
// 				else {
// 					alert("이미 선택된 협력사가 존재합니다.");
// 					return;
// 				}
			}
		}
		
		var selectedGrid8 = mySheet8.FindCheckedRow("SELECTED");
		var arrRow8 = selectedGrid8.split("|");
		if (selectedGrid8.length != 0){
			for(var i8=0; i8<arrRow8.length; i8++){
				var cur_agent = mySheet8.GetCellValue(arrRow8[i8],"AGENT");				
//				if (AgentList.indexOf(mySheet8.GetCellValue(arrRow8[i8],"AGENT")) == -1){
				if (SearchAgentList.indexOf(cur_agent) == -1){
					SearchAgentList += cur_agent + ",";
					if(arrDssI.includes(cur_agent)){
						SearchAgentDssList += cur_agent + "I" + ",";
					}else{
						SearchAgentDssList += cur_agent + "C" + ",";
					}
				} 
// 				else {
// 					alert("이미 선택된 협력사가 존재합니다.");
// 					return;
// 				}
			}
		}
		
		var selectedGrid15 = mySheet15.FindCheckedRow("SELECTED");
		var arrRow15 = selectedGrid15.split("|");
		if (selectedGrid15.length != 0){
			for(var i15=0; i15<arrRow15.length; i15++){
				var cur_agent = mySheet15.GetCellValue(arrRow15[i15],"AGENT");					
				if (SearchAgentList.indexOf(cur_agent) == -1){
					SearchAgentList += cur_agent + ",";
					if(arrDssI.includes(cur_agent)){
						SearchAgentDssList += cur_agent + "I" + ",";
					}else{
						SearchAgentDssList += cur_agent + "E" + ",";
					}
					
				} 
			}
		}
		
		var selectedGrid1 = mySheet.FindCheckedRow("SELECTED");
		var arrRow1 = selectedGrid1.split("|");
		if (selectedGrid1.length != 0){
			for(var i1=0; i1<arrRow1.length; i1++){
				var cur_agent = mySheet.GetCellValue(arrRow1[i1],"AGENT");
//				if (AgentList.indexOf(mySheet.GetCellValue(arrRow1[i1],"AGENT")) == -1){
				if (SearchAgentList.indexOf(cur_agent) == -1){
					SearchAgentList += cur_agent + ",";
					if(arrDssI.includes(cur_agent)){
						SearchAgentDssList += cur_agent + "I" + ",";
					}else{
						SearchAgentDssList += cur_agent + "S" + ",";
					}
				} 
// 				else {
// 					alert("이미 선택된 협력사가 존재합니다.");
// 					return;
// 				}
			}
		}
		
		var selectedGrid2 = mySheet2.FindCheckedRow("SELECTED");
		var arrRow2 = selectedGrid2.split("|");
		if (selectedGrid2.length != 0){
			for(var i2=0; i2<arrRow2.length; i2++){
				var cur_agent = mySheet2.GetCellValue(arrRow2[i2],"AGENT");
//				if (AgentList.indexOf(mySheet2.GetCellValue(arrRow2[i2],"AGENT")) == -1){
				if (SearchAgentList.indexOf(cur_agent) == -1){
					SearchAgentList += cur_agent + ",";
					if(arrDssI.includes(cur_agent)){
						SearchAgentDssList += cur_agent + "I" + ",";
					}else{
						SearchAgentDssList += cur_agent + "S" + ",";
					}
				} 
// 				else {
//					alert("이미 선택된 협력사가 존재합니다.");
// 					return;
// 				}
			}
		}
	}
		
	var selectedGrid13 = mySheet13.FindCheckedRow("SELECTED");
	var arrRow13 = selectedGrid13.split("|");
	if (selectedGrid13.length != 0){
		for(var i13=0; i13<arrRow13.length; i13++){
			var cur_agent = mySheet13.GetCellValue(arrRow13[i13],"AGENT");
			if (SearchAgentList.indexOf(cur_agent) == -1){
				SearchAgentList += cur_agent + ",";
				if(arrDssI.includes(cur_agent)){
					SearchAgentDssList += cur_agent + "I" + ",";
				}else{
					SearchAgentDssList += cur_agent + "D" + ",";
				}
			} 
		}
	}
	
	var selectedGrid14 = mySheet14.FindCheckedRow("SELECTED");
	var arrRow14 = selectedGrid14.split("|");
	if (selectedGrid14.length != 0){
		for(var i14=0; i14<arrRow14.length; i14++){
			var cur_agent = mySheet14.GetCellValue(arrRow14[i14],"AGENT");
			if (SearchAgentList.indexOf(cur_agent) == -1){
				SearchAgentList += cur_agent + ",";
				if(arrDssI.includes(cur_agent)){
					SearchAgentDssList += cur_agent + "I" + ",";
				}else{
					SearchAgentDssList += cur_agent + "D" + ",";
				}
			} 
		}
	}
	
	var selectedGrid9 = mySheet9.FindCheckedRow("SELECTED");
	var arrRow9 = selectedGrid9.split("|");
	if (selectedGrid9.length != 0){
		for(var i9=0; i9<arrRow9.length; i9++){
			var cur_agent = mySheet9.GetCellValue(arrRow9[i9],"AGENT");
//			if (AgentList.indexOf(mySheet9.GetCellValue(arrRow9[i9],"AGENT")) == -1){
			if (SearchAgentList.indexOf(cur_agent) == -1){
				SearchAgentList += cur_agent + ",";
				if(arrDssI.includes(cur_agent)){
					SearchAgentDssList += cur_agent + "I" + ",";
				}else{
					SearchAgentDssList += cur_agent + "N" + ",";
				}
			} 
// 			else {
// 				alert("이미 선택된 협력사가 존재합니다.");
// 				return;
// 			}
		}
	}
	
	if (SearchAgentList == ""){
		alert("선택된 협력사가 없습니다.");
		return;
	}
	$("#st_multi_agent").val(SearchAgentList);
	$("#st_multi_agent_dss").val(SearchAgentDssList);
	
	$("#st_sheet").val("10");
	kepSearch(document.searchCondition,  mySheet10 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
	
}

function callbackMisumi() {
	//우선순위(A,B,C,S,N)
	var AgentList = "";
	var SearchAgentList = "";
	var AgentDssList = "";
	var SearchAgentDssList = "";
	for(var i = 1; i<= mySheet10.RowCount();i++){
		AgentList += mySheet10.GetCellValue(i,"AGENT") + ",";
		if(mySheet10.GetCellValue(i,"DSS_CHOICE")  == "G"){
			AgentDssList += mySheet10.GetCellValue(i,"AGENT") + mySheet10.GetCellValue(i,"DSS_CHOICE")
									+"^"+ mySheet10.GetCellValue(i,"GPL_LIST_PRICE")
									+"^"+ mySheet10.GetCellValue(i,"GPL_DLVRY_LT")
									+"^"+ mySheet10.GetCellValue(i,"GPL_TAX_TYPE")
									+"^"+ mySheet10.GetCellValue(i,"GPL_MIN_ORDER_QTY")
									+"^"+ mySheet10.GetCellValue(i,"GPL_PUR_UNIT_QTY")
									+"^"+ mySheet10.GetCellValue(i,"GPL_SELLER_AREA")
									+"^"+ mySheet10.GetCellValue(i,"GPL_SELLER_ITEM_NO")
									+",";
		}else{
			AgentDssList += mySheet10.GetCellValue(i,"AGENT") + mySheet10.GetCellValue(i,"DSS_CHOICE") + ",";
		}
	}
	if (AgentList != ""){
		SearchAgentList = AgentList + SearchAgentList;
		SearchAgentDssList = AgentDssList + SearchAgentDssList;
	}
	
	if ( !(SearchAgentList.indexOf("KRMISU0004") > -1) ) {
		SearchAgentList += "KRMISU0004,";
		SearchAgentDssList += "KRMISU0004N,";
	}
	
	$("#st_multi_agent").val(SearchAgentList);
	$("#st_multi_agent_dss").val(SearchAgentDssList);
	
	$("#st_sheet").val("10");
	kepSearch(document.searchCondition,  mySheet10 , "/mprq/getMasterMpRqDssSellerSelList.do" , pagingMode );
}
	
function delCheckedAgent(){
	for ( var i = mySheet10.RowCount()+1; i >= 1; i--) {
	  if (mySheet10.GetCellValue(i,'SELECTED') == '1') {
		if(mySheet10.GetCellValue(i,'DSS_CHOICE')=="H"){ //지정협력사는 제거불가
			continue;
		}
		mySheet10.RowDelete(i);
	  }
	}

}

//확인
function kepConfirm()
{
	var selectedGrid = mySheet10.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	var AgentList = "";
	var AgentDssList = "";
	var AgentDssList2 = "";
	var checkFlag1 = "";
	var checkFlag2 = "";
	var checkFlag3 = "";
	var checkFlag4 = "";
	var strDssChoice = "";
	var mqt00001 = "<%=mqt00001%>";
	
	if (selectedGrid.length != 0){
		for(var i=0; i<arrRow.length; i++){
			strDssChoice =mySheet10.GetCellValue(arrRow[i],"DSS_CHOICE");
			AgentList += mySheet10.GetCellValue(arrRow[i],"AGENT") + ",";
			AgentDssList += mySheet10.GetCellValue(arrRow[i],"AGENT") + mySheet10.GetCellValue(arrRow[i],"DSS_CHOICE") +
			  "@@"+mySheet10.GetCellValue(arrRow[i],"GPL_LIST_PRICE") +
			  "@@"+mySheet10.GetCellValue(arrRow[i],"GPL_DLVRY_LT") +
			  "@@"+mySheet10.GetCellValue(arrRow[i],"GPL_TAX_TYPE") +
			  "@@"+mySheet10.GetCellValue(arrRow[i],"GPL_MIN_ORDER_QTY") +
			  "@@"+mySheet10.GetCellValue(arrRow[i],"GPL_PUR_UNIT_QTY") +
			  "@@"+mySheet10.GetCellValue(arrRow[i],"GPL_SELLER_AREA") +
			  "@@"+mySheet10.GetCellValue(arrRow[i],"GPL_SELLER_ITEM_NO") +
			  ",";
			AgentDssList2 += mySheet10.GetCellValue(arrRow[i],"AGENT") +"N" +
			  "@@"+mySheet10.GetCellValue(arrRow[i],"GPL_LIST_PRICE") +
			  "@@"+mySheet10.GetCellValue(arrRow[i],"GPL_DLVRY_LT") +
			  "@@"+mySheet10.GetCellValue(arrRow[i],"GPL_TAX_TYPE") +
			  "@@"+mySheet10.GetCellValue(arrRow[i],"GPL_MIN_ORDER_QTY") +
			  "@@"+mySheet10.GetCellValue(arrRow[i],"GPL_PUR_UNIT_QTY") +
			  "@@"+mySheet10.GetCellValue(arrRow[i],"GPL_SELLER_AREA") +
			  "@@"+mySheet10.GetCellValue(arrRow[i],"GPL_SELLER_ITEM_NO") +
			  ",";
			var CeoNameLoc = mySheet10.GetCellValue(arrRow[i],"CEO_NAME_LOC");
			var telNo = mySheet10.GetCellValue(arrRow[i],"TEL_NO");
			var faxNo = mySheet10.GetCellValue(arrRow[i],"FAX_NO");
			
			//대표자명, TEL,FAX 동일시 알림 발생. 현명환	+ 지정협력사 체크 한승준		
			for(var j=0; j<arrRow.length; j++){
				var CeoNameLoc2 = mySheet10.GetCellValue(arrRow[j],"CEO_NAME_LOC");
				var telNo2 = mySheet10.GetCellValue(arrRow[j],"TEL_NO");
				var faxNo2 = mySheet10.GetCellValue(arrRow[j],"FAX_NO");
				
				if(i != j){
					if(CeoNameLoc ==CeoNameLoc2 ){
						checkFlag1 ="대표자";
					}
					if(telNo ==telNo2 ){
						checkFlag2 =",전화번호 ";
					}
					if(faxNo ==faxNo2 ){
						checkFlag3 =",FAX ";
					}
				}	
			}
			
			if('${param.st_assign_agent_name}' == "없음" || ('${param.st_assign_agent_code}' == mySheet10.GetCellValue(arrRow[i],"AGENT")) ){
				checkFlag4 = "Y";
			}
		}
		if(checkFlag1 != ""|| checkFlag2 !=""||checkFlag3!=""){
			var msg = "지정된 협력사는"+checkFlag1+checkFlag2+checkFlag3+"가 동일합니다.";		
			alert(msg);
		}
		if(checkFlag4 != "Y"){
			alert("지정협력사( " + '${param.st_assign_agent_name}' + " )가 포함되지 않았습니다.");
			return;
		}
	} else {
		alert("선택한 행이 없습니다.");
		return;
	}
	//협력사 단수입찰 금지 현명환 임시주석처리.GPL은 예외처리 됨.(삼성전자, 삼성전기는 에외처리)
	if (!mqt00001 || mqt00001 == "false"){		
		if(strDssChoice != "G"){
		 	if(mySheet10.RowCount() < 2){
				alert("단수 입찰은 금지하며, 협력사 2개 이상 지정 시 견적 진행 가능합니다.");
				return;
			}		
		}
	}
	 opener.setPopupReturn(AgentList, arrRow.length,$("#st_multi_agent").val(),AgentDssList,AgentDssList2);
	 this.close();
}

//납품가능지역 체크 함수 
function AreaCheck(buyer_dely_area,agent_dely_area){
	var buyer_dely_area_list = buyer_dely_area.split("");
	var agent_dely_area_list = agent_dely_area.split("");
	
	for(var i = 0;i<buyer_dely_area_list.length;i++){
		if(buyer_dely_area_list[i] == "Y" &&  agent_dely_area_list[i] == "Y")
			return "TRUE";
	}
	return "FALSE";
}
	</script>
</head>

<body onload="kep_onload_view()">
<form name = "searchCondition" id="searchCondition" method = "post">
<!--내용 시작-->
<div id="popWrapper" style="height:702px;">
 	<div id="popHeader">
     	<h1 class="title">협력사선택</h1>
         <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
     </div>

	<div id="popContainer" style="height:727px;">
        <!--조회영역-->
		<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="st_sheet" name="st_sheet" value="1">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<input type="hidden" id="st_dss_agent" name="st_dss_agent" value="">
			<input type="hidden" id="st_multi_agent" name="st_multi_agent" value="${param.st_multi_agent}">
			<input type="hidden" id="st_multi_agent_dss" name="st_multi_agent_dss" value="${param.st_multi_agent_dss}">
			<input type="hidden" id="st_cms_caltlg_id" name="st_cms_caltlg_id" value="${param.st_cms_caltlg_id}">
			<input type="hidden" id="st_cms_categ_id" name="st_cms_categ_id" value="${param.st_cms_categ_id}">
			<input type="hidden" id="st_sg_id" name="st_sg_id" value="${param.st_sg_id}">
			<input type="hidden" name="st_quotation_no" id="st_quotation_no"  value="${param.st_quotation_no}">
			<input type="hidden" name="st_quotation_seq" id="st_quotation_seq" value="${param.st_quotation_seq}">
			<input type="hidden" name="st_revision" id="st_revision" value="${param.st_revision}">
			<input type="hidden" name="st_dely_area" id="st_dely_area" value="${param.st_dely_area}">
			<input type="hidden" name="st_assign_agent_code" id="st_assign_agent_code" value="${param.st_assign_agent_code}">
			<input type="hidden" name="st_assign_agent_name" id="st_assign_agent_name" value="${param.st_assign_agent_name}">
			
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
           	<table  class="cont_t_list01" style="width:100%;">
				<caption>협력사선택</caption>
				<colgroup>
					<col width="10%" />
					<col width="40%" />
					<col width="10%" />
					<col width="40%" />
				</colgroup>
					
				<tbody>
					<tr>
						<td>고객사</td>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:90%" value="${param.st_buyer_name}" readonly >
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="${param.st_buyer_code}">
						</td>
						<td>SG명</td>
						<td>
							<input type="text" class="input_type_text" name="st_sg_name" id="st_sg_name" style="width:90%" value="${param.st_sg_name}" readonly >
							<input type="hidden" name="st_sg_id" id="st_sg_id" style="width:80%" value="${param.st_sg_id}">
						</td>
					</tr>
					<tr> 
						<td>소재지역명</td>
						<td>
							<a href="javascript:doPop('commonCoCoLocationDetailPop');"><input type="text" class="input_type_text" name="st_ag_si" id="st_ag_si" style="width:90%;text-decoration:underline ; color:#003694" value="${param.st_ag_si}" readonly ></a>
							<input type="hidden" name="st_ag_id" id="st_ag_id" style="width:80%" value="${param.st_ag_id}">
						</td>
						<td>MAKER명</td>
						<td>
							<input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:90%" value="${param.st_maker_name}" readonly >
							<input type="hidden" name="st_maker_code" id="st_maker_code" style="width:80%" value="${param.st_maker_code}">
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div id="gridArea" style="height:475px;">
			<!--grid Start-->
			<div id="div_re_note" style="position:relative;width:830px;height:300px">
				<div style="text-align:right;line-height:25px" > 
					<span class="text11" style="float:left">- 운영특이사항 -</span>
					<span class="btn_06" style="height:28px;"><a href="javaScript:doAction('add_note');">운영특이사항 입력</a></span>
					<span class="btn_search"><a href="javaScript:doAction('searchHead');">조회</a></span>
				</div>
				
				<div style="border-top:2px solid #3c639c;width:830px;position:relative; left:0;">
	  				<script type="text/javascript">
	  					createIBSheet("mySheet19", "100%", "150px");
	  				</script>
  				</div>
  				<div style="height:20px;">
  					<span class="text11 fl">- 지정/선호협력사 리스트 -</span>
  				</div>
  				<div style="width:830px; position:relative; left:0;">
					<textarea id="st_dss_re_note" name="st_dss_re_note" style="width:100%;" rows="6" readonly><%=getCodeDSRMText%></textarea>
				</div>
  			</div>
			
			<div id="e" style="position:relative;width:830px;height:175px">
				<div style="height:20px;">
					<span class="text11 fl">H. 지정협력사&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; 
					&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					I. 추천협력사</span>
				</div>
					<div style="border-top:2px solid #3c639c;width:415px;position:absolute; left:0;">
		  				<script type="text/javascript">
		  					createIBSheet("mySheet17", "100%", "150px");
		  				</script>
	  				</div>
					<div style="border-top:2px solid #3c639c;width:415px;position:absolute; right:0;" >
					<!--  div style="display:none">-->
		  				<script type="text/javascript">
		  					createIBSheet("mySheet18", "100%", "150px");
		  				</script>
	  				</div>
  			</div>
			<div id="a" style="position:relative;width:830px;height:116px">
				<div style="height:20px;">
					<span class="text11 fl">S. 담당자 관리(제조사,SG)&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; 
					&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
					S. 담당자 관리(SG)</span>
				</div>
					<div style="border-top:2px solid #3c639c;width:415px;position:absolute; left:0;">
		  				<script type="text/javascript">
		  					createIBSheet("mySheet", "100%", "91px");
		  				</script>
	  				</div>
					<div style="border-top:2px solid #3c639c;width:415px;position:absolute; right:0;">
		  				<script type="text/javascript">
		  					createIBSheet("mySheet2", "100%", "91px");
		  				</script>
	  				</div>
  			</div>
			<div id="a" style="position:relative;width:830px;height:116px">
				<div style="height:20px;">
					<span class="text11 fl">D. 총판/대리점 관리(제조사,SG)&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; 
					&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
					D. 총판/대리점 관리(SG)</span>
				</div>
					<div style="border-top:2px solid #3c639c;width:415px;position:absolute; left:0;">
		  				<script type="text/javascript">
		  					createIBSheet("mySheet13", "100%", "91px");
		  				</script>
	  				</div>
					<div style="border-top:2px solid #3c639c;width:415px;position:absolute; right:0;">
		  				<script type="text/javascript">
		  					createIBSheet("mySheet14", "100%", "91px");
		  				</script>
	  				</div>
  			</div>
			<div id="b" style="position:relative;width:830px;height:116px">
  				<span class="text11">A. 고객사 거래실적(제조사,SG)&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; 
					&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;
					A. 고객사 거래실적(SG)</span>
  				<br>
					<div style="border-top:2px solid #3c639c;width:415px;position:absolute; left:0;">
		  				<script type="text/javascript">
		  					createIBSheet("mySheet3", "100%", "91px");
		  				</script>
	  				</div>
					<div style="border-top:2px solid #3c639c;width:415px;position:absolute; right:0;">
		  				<script type="text/javascript">
		  					createIBSheet("mySheet4", "100%", "91px");
		  				</script>
	  				</div>
			</div>
			
			<div id="c" style="position:relative;width:830px;height:116px">
  				<span class="text11">B. 고객사 소재지역 거래실적(제조사,SG)&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; 
					&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;
					B. 고객사 소재지역 거래실적(SG)</span>
  				<br>
					<div style="border-top:2px solid #3c639c;width:415px;position:absolute; left:0;">
		  				<script type="text/javascript">
		  					createIBSheet("mySheet5", "100%", "91px");
		  				</script>
	  				</div>
					<div style="border-top:2px solid #3c639c;width:415px;position:absolute; right:0;">
		  				<script type="text/javascript">
		  					createIBSheet("mySheet6", "100%", "91px");
		  				</script>
	  				</div>
  			</div>
			
			<div id="d" style="position:relative;width:830px;height:116px">
  				<span class="text11">C. 전국 거래실적(제조사,SG)&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; 
					&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
					C. 전국 거래실적(SG)</span>
  				<br>
					<div style="border-top:2px solid #3c639c;width:415px;position:absolute; left:0;">
		  				<script type="text/javascript">
		  					createIBSheet("mySheet7", "100%", "91px");
		  				</script>
	  				</div>
					<div style="border-top:2px solid #3c639c;width:415px;position:absolute; right:0;">
		  				<script type="text/javascript">
		  					createIBSheet("mySheet8", "100%", "91px");
		  				</script>
	  				</div>
  			</div>
			<div id="ms10" style="position:relative;width:830px;height:100px; clear:both">
  				<span class="text11">G. GPL단가 기준 + 삼성단가 기준</span>
  				<br>
  				<div style="border-top:2px solid #3c639c;width:830px;position:absolute; left:0;">
  				<script type="text/javascript">
  					createIBSheet("mySheet12", "100%", "91px");
  				</script>
  				</div>
  			</div>
  			<br>
  			<div id="ms10" style="position:relative;width:830px;height:100px; clear:both">
  				<span class="text11">E. 표준카탈로그 매핑단가</span>
  				<br>
  				<div style="border-top:2px solid #3c639c;width:830px;position:absolute; left:0;">
  				<script type="text/javascript">
  					createIBSheet("mySheet15", "100%", "91px");
  				</script>
  				</div>
  			</div>
  				<br>
  		<!-- grid End -->
		<div id="minus" style="position:relative;width:830px;height:20px;clear:both"> 
			<div style="width:690px;position:absolute; left:0;text-align:center;">
				<span class="text11 center" style="text-align:center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				( <a href="javascript:kepHidden('hidden');"><img src="/resources/images/btn_minus.gif"></a> 조회조건 비활성화)
				</span>
			</div>
			<div style="width:140px;position:absolute; right:0;">
				<span class="text11">거래현황(최근3개월기준)</span>
			</div>
  		</div>
		<div id="plus" style="position:relative;width:830px;height:20px">   
			<div style="width:690px;position:absolute; left:0;text-align:center;">
				<span class="text11" style="text-align:center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					( <a href="javascript:kepHidden('show');"><img src="/resources/images/btn_plus.gif"></a> 조회조건 활성화)
				</span>
			</div>
			<div style="width:140px;position:absolute; right:0;">
				<span class="text11">거래현황(최근3개월기준)</span>
			</div>
  		</div>
		<!--조회영역-->
		<div id="searchMode">
			<div id="cont_searchA">
			<!--HIDDEN-->
	          	<table  class="cont_t_list01" style="width:100%;">
				<caption>협력사선택</caption>
				<colgroup>
					<col width="90px" />
					<col width="40%" />
					<col width="90px" />
					<col width="40%" />
				</colgroup>
					
				<tbody>
					<tr>
						<th>협력사</th>
						<td>
							<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:90%" value="" onkeydown="javascript:kepEnter();">
						</td>
						<th>Maker 검색</th>
						<td>
							<input type="text" class="input_type_text" name="st_maker_name2" id="st_maker_name2" style="width:71%" value="" readonly >
							<input type="hidden" name="st_maker_code2" id="st_maker_code2" style="width:80%" value="">
							<a href="javascript:doPop('maker');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_maker_code2','st_maker_name2');"><img src="/resources/images/btn_eraser2.gif"></a> 
						</td>
					</tr>
					<tr> 
						<th>품목군 검색</th>
						<td>
							<input type="text" class="input_type_text" name="st_item_name" id="st_item_name" style="width:71%" value="" readonly >
							<input type="hidden" name="st_item_code" id="st_item_code" style="width:80%" value="">
							<a href="javascript:doPop('commonCoCoTranGoodsPop');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_item_code','st_item_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
						</td>
						<th></th>
						<td></td>
					</tr>
				</tbody>
			</table>
			</div>
  		
			<!-- 버튼영역 -->
	       	<div id="searchBtnA" style="width:830px;">
	        	<span class="btn_search"><a href="javascript:kepHidden('girdShow')">추천협력사</a></span> 
	        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
			    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	   		</div>      
   		</div>
   		
   		<div id="searchArea" style="height:286px;width:830px">
	   		<div id="ms9" class="mb10" style="border-top:2px solid #3c639c;width:830px;height:100px;">
				<script type="text/javascript">
					createIBSheet("mySheet9", "100%", "100%");
				</script>
			</div>
			<div>
				<span class="fl"><font color="RED">지정협력사 : ${param.st_assign_agent_name}</font></span>
			
				<div id="shift" style="text-align:center;width:830px">
					<a href="javascript:getCheckedAgent();"><img src="/resources/images/icn_arrowdown02.gif"></a>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="javascript:delCheckedAgent();"><img src="/resources/images/icn_arrowup02.gif"></a>
				</div>
			</div>
	   		<div id="ms10" style="border-top:2px solid #3c639c;width:830px;height:100px;">
				<script type="text/javascript">
					createIBSheet("mySheet10", "100%", "100%");
				</script>
			</div>
			<!--버튼영역-->
			<div class="btnArea mt05">
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:doAction('misumiOepn');">미스미견적</a></span>
					<span class="btn_02 mr04"><a href="javascript:doAction('misumiAdd');">미스미추가</a></span>
					<span class="btn_02 mr04"><a href="javascript:kepConfirm();">확인</a></span>
				</span>
			</div>
</div>  		
  	</div>		
	
<!--내용 종료-->
	</div>	   
	</div>              
	</form>
<form name = "qtKey" id="qtKey" method="post">
	<input type="hidden" id="qt_buyer" name="qt_buyer" value="">
	<input type="hidden" id="qt_quotation_no" name="qt_quotation_no" value="">
	<input type="hidden" id="qt_quotation_seq" name="qt_quotation_seq" value="">
	<input type="hidden" id="qt_revision" name="qt_revision" value="">
	<input type="hidden" id="qt_rfq_kep_user" name="qt_rfq_kep_user" value="${sessionInfo.userId}">
	<input type="hidden" id="p_flag" name="p_flag" value="MD">
</form>
</body>
</html>