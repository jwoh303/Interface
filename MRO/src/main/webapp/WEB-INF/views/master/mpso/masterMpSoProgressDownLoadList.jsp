<%--
**********************************************
* 메뉴 : 
* 화면 : 주문진행관리(다운로드)
* 기능 : 
* 프로그램 ID : 
* 담당자 : 고영일 ( 설계 : 김지현 )
* 착수일 : 2014-10-22
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String defualtCol = "1,0,1,1,0,1,1,1,1,0,0,1,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";
String my_col_info = CommonUtil.nvl((String) request.getAttribute("my_col_info"), defualtCol);
String[] myColInfo = CommonUtil.StrToArray(my_col_info, ",");
int colInx = 0;

String userid = "";
String st_user_dept = ""; //사용자 부서
if (_sessionInfo != null){
	userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());
	st_user_dept = CommonUtil.nvl((String)_sessionInfo.getDepartment());
} 
//필드추가 권한여부
boolean getRoleYn = CommonUtil.getCodeCheckReturn("M174",userid);
%>

<!-- 다중선택콤보(공통) - 사용시 필수 선언 start -->
<script src="/resources/js/jquery.multiple.select.js"></script>
<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<!-- 다중선택콤보(공통) - 사용시 필수 선언 end -->

<title>Insert title here</title>
<script>
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
	var popupSel = "";
	var diskOn = "/resources/images/disk_on.gif";
	var diskOff = "/resources/images/disk_off.gif";
	var remarkOn="/resources/images/but_icon01.gif";
	var remarkOff="/resources/images/but_icon02.gif";
	var iconR="/resources/images/icon_r.gif";
	var iconG="/resources/images/icon_g.gif";
	
	//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function initPage() {
		
		var initsheet = {};
		initsheet.Cols = [ 
			 {Align : "Center",	SaveName : "sStatus",		Header:"상태",		Type : "Status",		EditLen : 0,	Width:60,		Edit:false,		Hidden:true}
			,{Align : "Center", SaveName : "SELECTED",		Header:"",			Type : "DummyCheck",	Width : 30,		Edit : true,	Sort:0}
			,{Align : "Center",	SaveName : "SCM_REMARK",	Header : "운영자\n메모",	Type : "Text",			EditLen : 60,	Width : 50,		Edit : false}
			,{Align : "Center",	SaveName : "ISSUE_IMG",	Header : "발주\n이슈",	Type : "Image",			EditLen : 60,	Width : 60,		Edit : false}
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "BUYER_NAME",		Header : "고객사",		Type : "Text",		EditLen : 100,	Width : 120,	Edit : false} 	<% } %>	
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "BUYER",				Header : "고객사코드",		Type : "Text",		EditLen : 100,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "STATUS_TEXT",		Header : "진행상태",		Type : "Text",		EditLen : 100,	Width : 100,	Edit : false,	ToolTip:true}	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Left",	SaveName : "AGENT_NAME",		Header : "협력사명",		Type : "Text",		EditLen : 100,	Width : 110,	Edit : false,	ToolTip:true}	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "AGENT_CODE",		Header : "협력사코드",		Type : "Text",		EditLen : 100,	Width : 80,		Edit : false} 	<% } %>	
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "PO_NO",				Header : "발주번호",		Type : "Text",		EditLen : 100,	Width : 80,		Edit : false,	ToolTip:true}	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "PO_SEQ",			Header : "발주항번",		Type : "Text",		EditLen : 100,	Width : 60,		Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Right",	SaveName : "PO_QTY",			Header : "발주수량",		Type : "AutoSum",	EditLen : 100,	Width : 60,		Edit : false,	Format:"Float"}	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "LEGACY_PO_NO",		Header : "IF발주번호",		Type : "Text",		EditLen : 100,	Width : 60,		Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "LEGACY_PO_SEQ",		Header : "주문항번",		Type : "Text",		EditLen : 100,	Width : 60,		Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "ADD_DATE",			Header : "생성일",		Type : "Date",		EditLen : 100,	Width : 80,		Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "PO_DATE",			Header : "발주일",		Type : "Date",		EditLen : 100,	Width : 80,		Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "PO_DEPT_NAME",		Header : "발주부서",		Type : "Text",		EditLen : 100,	Width : 100,	Edit : false,	ToolTip:true}	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>
	,{Align : "Center",	SaveName : "PO_USER_NAME",			Header : "발주자",		Type : "Text",		EditLen : 100,	Width : 60,		Edit : false,	Hidden : true}
	,{Align : "Center",	SaveName : "PO_USER_NAME_MASK",		Header : "발주자",		Type : "Text",		EditLen : 100,	Width : 60,		Edit : false}
<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>
	,{Align : "Center",	SaveName : "PO_USER_ID",			Header : "발주자ID",		Type : "Text",		EditLen : 100,	Width : 60,		Edit : false,	Hidden : true}
	,{Align : "Center",	SaveName : "PO_USER_ID_MASK",		Header : "발주자ID",		Type : "Text",		EditLen : 100,	Width : 60,		Edit : false}
<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "BUYER_ITEM_NO",		Header : "품목코드",		Type : "Text",		EditLen : 50,	Width : 80,		Edit : false,	ToolTip:true}	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Left",	SaveName : "DESCRIPTION",		Header : "품목명",		Type : "Text",		EditLen : 250,	Width : 130,	Edit : false,	ToolTip:true}	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "SPECIFICATION",		Header : "규격",			Type : "Text",		EditLen : 100,	Width : 80,		Edit : false,	ToolTip:true}	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "MAKER_NAME",		Header : "제조사",		Type : "Text",		EditLen : 100,	Width : 100,	Edit : false,	ToolTip:true}	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "UNIT_MEASURE",		Header : "단위",			Type : "Text",		EditLen : 100,	Width : 55,		Edit : false,	ToolTip:true}	<% } %>
			
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Right",	SaveName : "UNIT_PRICE",		Header : "매출단가",		Type : "Float",		EditLen : 100,	Width : 70,		Edit : false, 	Format:"${priceFormat}"} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Right",	SaveName : "UNIT_SUM",			Header : "매출금액",		Type : "AutoSum",	EditLen : 100,	Width : 80,		Edit : false, 	Format:"${priceFormat}"}	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Right",	SaveName : "AGENT_PRICE",		Header : "매입단가",		Type : "Float",		EditLen : 100,	Width : 70,		Edit : false,	Format:"${priceFormat}"} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Right",	SaveName : "AGENT_SUM",			Header : "매입금액",		Type : "AutoSum",	EditLen : 100,	Width : 80,		Edit : false,	Format:"${priceFormat}"}	<% } %>

<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "REF_PR_NO",			Header : "관리번호",		Type : "Text",		EditLen : 100,	Width : 70,		Edit : false} 	<% } %>

<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "RD_DATE",			Header : "납기요청일",		Type : "Date",		EditLen : 100,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "HA_DATE",			Header : "납품합의일",		Type : "Text",		EditLen : 100,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "CD_DATE",			Header : "협력사납품예정일",	Type : "Date",		EditLen : 100,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "BUYER_DS_DATE",		Header : "KeP납품예정일",	Type : "Date",		EditLen : 100,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "INVOICE_DATE",		Header : "납품일",		Type : "Date",		EditLen : 100,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Right",	SaveName : "INV_QTY",			Header : "납품수량",		Type : "AutoSum",	EditLen : 100,	Width : 70,		Edit : false,	Format:"Float"}	<% } %>

<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "DELIVERY_DATE",		Header : "확정일",		Type : "Date",		EditLen : 200,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Right",	SaveName : "DELIVERY_QTY",		Header : "확정수량",		Type : "AutoSum",	EditLen : 100,	Width : 70,		Edit : false,	Format:"Float"}	<% } %>

<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "GR_DATE",			Header : "입고일",		Type : "Date",		EditLen : 100,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Right",	SaveName : "GR_QTY1",			Header : "입고수량",		Type : "AutoSum",	EditLen : 100,	Width : 70,		Edit : false,	Format:"Float"}	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Right",	SaveName : "GR_UNIT_SUM",		Header : "입고매출금액",	Type : "Float",		EditLen : 100,	Width : 80,		Edit : false,	Format:"${priceFormat}"} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Right",	SaveName : "GR_AGENT_SUM",		Header : "입고매입금액",	Type : "Float",		EditLen : 100,	Width : 80,		Edit : false,	Format:"${priceFormat}"} 	<% } %>

<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "BUYER_CATEG_ID",	Header : "카테고리ID",		Type : "Text",		EditLen : 150,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "BUYER_CATEG_NAME",	Header : "카테고리명",		Type : "Text",		EditLen : 150,	Width : 100,	Edit : false,	ToolTip:true}	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "BUYER_CATEG_PATH",	Header : "카테고리경로",	Type : "Text",		EditLen : 150,	Width : 150,	Edit : false,	ToolTip:true}	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "CMS_CATEG_ID",		Header : "표준카테고리ID",	Type : "Text",		EditLen : 150,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "CATEG_PATH",		Header : "표준카테고리경로",	Type : "Text",		EditLen : 150,	Width : 150,	Edit : false,	ToolTip:true}	<% } %>

<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "REQ_DEPT_NAME",		Header : "요청부서",		Type : "Text",		EditLen : 100,	Width : 70,		Edit : false,	ToolTip:true}	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>
	,{Align : "Center",	SaveName : "REQ_USER_NAME",			Header : "요청자",		Type : "Text",		EditLen : 100,	Width : 60,		Edit : false,	Hidden : true}
	,{Align : "Center",	SaveName : "REQ_USER_NAME_MASK",	Header : "요청자",		Type : "Text",		EditLen : 100,	Width : 60,		Edit : false}
<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>
	,{Align : "Center",	SaveName : "REQ_USER_ID",			Header : "요청자ID",		Type : "Text",		EditLen : 100,	Width : 60,		Edit : false,	Hidden : true}
	,{Align : "Center",	SaveName : "REQ_USER_ID_MASK",		Header : "요청자ID",		Type : "Text",		EditLen : 100,	Width : 60,		Edit : false}
<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "CANCEL_REMARK",		Header : "발주삭제사유",	Type : "Text",		EditLen : 150,	Width : 100,	Edit : false} 	<% } %>
			
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "REF_IF_NO",			Header : "I/F관리번호",	Type : "Text",		EditLen : 150,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Left",	SaveName : "PO_REMARK",			Header : "비고",			Type : "Text",		EditLen : 150,	Width : 100,	Edit : false}	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "PROCESS_TEXT",		Header : "거래유형",		Type : "Text",		EditLen : 150,	Width : 100,	Edit : false} 	<% } %>
		
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "AGENT_IRS_NO",		Header : "협력사사업자번호",	Type : "Text",		EditLen : 150,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Left",	SaveName : "ORIGIN_AGENT",		Header : "실협력사코드",	Type : "Text",		EditLen : 150,	Width : 150,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "ORIGIN_AGENT_NAME",	Header : "실협력사명",		Type : "Text",		EditLen : 150,	Width : 100,	Edit : false} 	<% } %>

<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Left",	SaveName : "WAREHOUSE_NAME",	Header : "물류센터명",		Type : "Text",		EditLen : 150,	Width : 150,	Edit : false,	ToolTip:true}	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>
	,{Align : "Left",	SaveName : "PO_REMARK_HD",			Header : "비고2",			Type : "Text",		EditLen : 150,	Width : 100,	Edit : false,	ToolTip:true,	Hidden : true}
	,{Align : "Left",	SaveName : "PO_REMARK_HD_MASK",		Header : "비고2",			Type : "Text",		EditLen : 150,	Width : 100,	Edit : false,	ToolTip:true}
<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Right",	SaveName : "UNIT_TAX",			Header : "목표가",		Type : "Int",		EditLen : 150,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Left",	SaveName : "LOG_TEXT",			Header : "도착지",		Type : "Text",		EditLen : 150,	Width : 150,	Edit : false,	ToolTip:true}	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "ACCOUNT_TYPE",		Header : "예산계정",		Type : "Text",		EditLen : 100,	Width : 100,	Edit : false} 	<% } %>
		
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "PR_NO",				Header : "요청번호\n(주문이력)",	Type : "Text",	EditLen : 100,	Width : 80,		Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "PR_SEQ",			Header : "요청항번",		Type : "Text",		EditLen : 100,	Width : 70,		Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "CARD_USE_FLAG",		Header : "카드사용여부",	Type : "Text",		EditLen : 120,	Width : 120,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "CARD_CONFIRM_NO",	Header : "카드승인번호",	Type : "Text",		EditLen : 160,	Width : 150,	Edit : false} 	<% } %>
			
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "CONTRACT_NO",		Header : "계약서번호",		Type : "Text",		EditLen : 100,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "CONTRACT_SEQ",		Header : "계약서항번",		Type : "Text",		EditLen : 100,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "BYIT_COMORG_CODE",	Header : "카탈로그관리코드",	Type : "Text",		EditLen : 100,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "DS_REMARK",			Header : "DS_REMARK",	Type : "Text",		EditLen : 100,	Width : 150,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "ST_DATE",			Header : "표준납기일",		Type : "Date",		EditLen : 100,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Center",	SaveName : "ITEM_MAKE_TYPE",	Header : "품목구분",		Type : "Text",		EditLen : 100,	Width : 100,	Edit : false} 	<% } %>
<%if("1".equals(myColInfo[colInx++])){ %>	,{Align : "Right",	SaveName : "FIRST_UNIT_PRICE",	Header : "주문매출단가(수출)",Type : "Float",	EditLen : 100,	Width : 110,	Edit : false,	Format:"${priceFormat}"}<% } %>
			
			,{ Align : "Right",		SaveName : "LOGISTICS_RATE",	Header : "물류비(%)",		Type : "Text",	EditLen : 160,	Width : 70,		Edit : false}
			,{ Align : "Center",	SaveName : "LOGIS_RATE_STATUS",	Header : "물류비 책정 사유",	Type : "Text",	EditLen : 160,	Width : 70,		Edit : false,	Hidden : true}
			,{ Align : "Center",	SaveName : "IMAGE_KEY_YN",		Header : "첨부",			Type : "Image",	EditLen : 160,	Width : 70,		Edit : false}
			,{ Align : "Center",	SaveName : "IMAGE_KEY",			Header : "첨부",			Type : "Text",	EditLen : 160,	Width : 0,		Edit : false,	Hidden : true}
			,{ Align : "Center",	SaveName : "DOC_TYPE",			Header : "DOC_TYPE",	Type : "Text",	EditLen : 160,	Width : 0,		Edit : false,	Hidden : true}
			,{ Align : "Center",	SaveName : "SOUR_MNG",			Header : "SG담당자",		Type : "Text",	EditLen : 160,	Width : 70,		Edit : false}
			,{ Align : "Center",	SaveName : "MAKER_PART_NO",		Header : "모델명",		Type : "Text",	EditLen : 160,	Width : 100,	Edit : false}
			,{ Align : "Center",	SaveName : "EXP_CUR",			Header : "통화단위",		Type : "Text",	EditLen : 100,	Width : 60,		Edit : false,	Hidden : false}
			,{ Align : "Right",		SaveName : "PR_EXP_CUR_PRICE",	Header : "환율(주문)",		Type : "Float",	EditLen : 100,	Width : 60,		Edit : false,	Hidden : false}
			,{ Align : "Right",		SaveName : "GR_EXP_CUR_PRICE",	Header : "환율(입고)",		Type : "Float",	EditLen : 100,	Width : 60,		Edit : false,	Hidden : false}
			,{ Align : "Right",		SaveName : "EXP_FOR_UNIT_PRICE",Header : "외화매출단가",	Type : "Float",	EditLen : 100,	Width : 90,		Edit : false,	Hidden : false}
			,{ Align : "Right",		SaveName : "EXP_FOR_ITEM_AMT",	Header : "외화매출금액",	Type : "Float",	EditLen : 100,	Width : 90,		Edit : false,	Hidden : false}
			,{ Align : "Center",	SaveName : "BUDGET_ACCOUNT",	Header : "예산계정코드",	Type : "Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : false}
			,{ Align : "Center",	SaveName : "BUDGET_DEPT",		Header : "예산부서코드",	Type : "Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : false}
			,{ Align : "Center",	SaveName : "BUDGET_DEPT_NM",	Header : "예산부서명",		Type : "Text",	EditLen : 100,	Width : 150,	Edit : false,	Hidden : false}
			,{ Align : "Center",	SaveName : "PKG_COMPANY_NAME",	Header : "패킹업체",		Type : "Text",	EditLen : 100,	Width : 100,	Edit : false,	Hidden : false}
			,{ Align : "Center",	SaveName : "PKG_COMPANY_CODE",	Header : "패킹업체코드",	Type : "Text",	EditLen : 100,	Width : 100,	Edit : false,	Hidden : true}
			,{ Align : "Center",	SaveName : "MSDS_YN",			Header : "화학물질여부",	Type :  "Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : false}
			,{ Align : "Center",	SaveName : "PLANT_USER_NM",		Header : "PLANT담당자",	Type : "Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : false}
			,{ Align : "Center",	SaveName : "MSDS_MAIL_SEND",	Header : "MSDS발송",		Type : "Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : false}
			,{ Align : "Center",	SaveName : "MSDS_MAIL_RECV",	Header : "MSDS수신",		Type : "Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : false}
			,{ Align : "Center",	SaveName : "MSDS_MAPPING_YN",	Header : "MSDS매핑",		Type : "Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : false}
			,{ Align : "Left",		SaveName : "SCM_REMARK_TEXT",	Header : "운영자메모 이력",	Type : "Text",	EditLen : 100,	Width : 200,	Edit : false,	Hidden : false}
			,{ Align : "Left",		SaveName : "DOC_TYPE_NM",		Header : "발주타입",		Type : "Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : false}
			,{ Align : "Center",	SaveName : "BUY_CLOSE_DATE_YN",	Header : "매입단가\n유효일 만료",		Type:"Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : false}
			,{ Align : "Center",	SaveName : "SELL_CLOSE_DATE_YN",Header : "매출단가\n유효일 만료",		Type:"Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : false}
			,{ Align : "Center",	SaveName : "KEY1",				Header : "KEY1",		Type : "Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : true}
			,{ Align : "Center",	SaveName : "KEY2",				Header : "KEY2",		Type : "Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : true}
			,{ Align : "Center",	SaveName : "KEY3",				Header : "KEY3",		Type : "Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : true}
			,{ Align : "Center",	SaveName : "KEY4",				Header : "KEY4",		Type : "Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : true}
			,{ Align : "Center",	SaveName : "KEY5",				Header : "KEY5",		Type : "Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : true}
			,{ Align : "Center",	SaveName : "KEY6",				Header : "KEY6",		Type : "Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : true}
			,{ Align : "Center",	SaveName : "KEY7",				Header : "KEY7",		Type : "Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : true}
			,{ Align : "Center",	SaveName : "KEY8",				Header : "KEY8",		Type : "Text",	EditLen : 100,	Width : 80,		Edit : false,	Hidden : true}
<%if(getRoleYn== true){ %>	,{Align : "Center",	SaveName : "PR_USER_NAME",			Header : "인수자",		Type : "Text",	EditLen : 100,	Width : 60,		Edit : false} 	<% } %>
<%if(getRoleYn== true){ %>	,{Align : "Center",	SaveName : "PR_USER_MOBILE_PHONE",	Header : "인수자휴대폰",	Type : "Text",	EditLen : 100,	Width : 120,	Edit : false} 	<% } %>
		];
		
		initsheet.Cfg = {MergeSheet:msHeaderOnly};
		IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
		mySheet.SetCountPosition(4);
		
		//합계행을 감춘다.
		mySheet.SetRowHidden(mySheet.LastRow(),1);
		//조회조건 초기값 설정
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		$("#st_from_date").val( kepToMonthAdd("1","M") );
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );

		//파일첨부이미지설정
		mySheet.SetImageList(2, diskOff);
		mySheet.SetImageList(3, diskOn);
		mySheet.SetImageList(10, iconR);
		mySheet.SetImageList(11, iconG);
		
		if(isCheckCol("SCM_REMARK"))		setLinkCol(mySheet, "SCM_REMARK"); // 비고
		if(isCheckCol("BUYER_NAME"))		setLinkCol(mySheet, "BUYER_NAME");
		if(isCheckCol("PR_NO")) 				setLinkCol(mySheet, "PR_NO");
		if(isCheckCol("PO_NO")) 				setLinkCol(mySheet, "PO_NO");
		if(isCheckCol("PO_USER_NAME")) 	setLinkCol(mySheet, "PO_USER_NAME_MASK");
		if(isCheckCol("AGENT_NAME")) 		setLinkCol(mySheet, "AGENT_NAME");
		if(isCheckCol("BUYER_ITEM_NO")) 	setLinkCol(mySheet, "BUYER_ITEM_NO");
		if(isCheckCol("HA_DATE")) 			setLinkCol(mySheet, "HA_DATE");
		if(isCheckCol("GR_DATE")) 			setLinkCol(mySheet, "GR_DATE"); //일고일
		if(isCheckCol("CD_DATE")) 			setLinkCol(mySheet, "CD_DATE"); //납품예정일
		if(isCheckCol("INVOICE_DATE")) 	setLinkCol(mySheet, "INVOICE_DATE"); // 납품일
		if(isCheckCol("REQ_USER_NAME"))	setLinkCol(mySheet, "REQ_USER_NAME_MASK");
		setLinkCol(mySheet, "IMAGE_KEY_YN");
		setLinkCol(mySheet, "LOGISTICS_RATE");
		setLinkCol(mySheet, "ISSUE_IMG");
		
		// 다중선택콤보(공통) - 생성
// 		var test = "PO10,PO30,PO50";		// 초기화 시 아이템 선택 값
		kepAjaxCommonTotalMultiComboMpso('st_status', 'C018', 'ALL', '');
		
		// 다중선택콤보(공통) - 생성
		kepAjaxCommonTotalMultiCombo('st_issue_type', 'PMNGTYPE', 'ALL', '');
		
		//콤보데이터 셋팅		
		kepAjaxCommonQueryIdCombo('st_kep_user_id','getSgKepUserList','ALL2','');
		//PLANT담당자 콤보데이터 셋팅. 로그인  부서 기준 사용자 리스트
		var st_user_dept = "<%=st_user_dept%>";
		kepAjaxCommonQueryIdSearchTwoCombo('st_plant_user_id','common.masterDepartmentUserList','',st_user_dept,'ALL','');
		//패킹업체 셋팅
		kepAjaxCommonComboDataValue('st_pkg_cmpy_no','EP07','ALL');
		if(isCheckCol("PO_QTY"))				$("#span_po_tot_cnt").show();
		if(isCheckCol("GR_QTY1"))				$("#span_gr_tot_cnt").show();
		if(isCheckCol("INV_QTY"))				$("#span_iv_tot_cnt").show();
		if(isCheckCol("DELIVERY_QTY"))		$("#span_di_tot_cnt").show();
		if(isCheckCol("UNIT_SUM"))			$("#span_tot_item_amt").show();
		if(isCheckCol("AGENT_SUM"))		$("#span_tot_agent_item_amt").show();
		
	}

	
	var mt;
	//기능함수
	function doAction(str) {
		
		switch (str) {
		case "search":
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;

			if(!validCheck('true')){
				return;
			}
			
			// 마스킹 설정
			$("#st_non_masking_flag").val('N');
			
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoProgressDownLoad.do" , pagingMode );
			
			break;
		case "excelDown": // 엑셀다운로드
			if(!validCheck('true')){
				return;
			}
		
		    $("#pageflag").val('0');
	
		    var downCol = "";
			for(var i=0;i<=mySheet.LastCol();i++){
				if(!mySheet.GetColHidden(i) && mySheet.ColSaveName(i) !="SELECTED"){
					if(mySheet.ColSaveName(i) == "IMAGE_KEY_YN"){
						downCol += "|IMAGE_KEY";
					}else{
						downCol += "|"+i;
					}
				}
			}
			
			// 마스킹 해제
			$("#st_non_masking_flag").val('Y');
			
			var param = {FileName:"주문진행관리.xlsx",DownCols:downCol.substring(1)};
			kepDownExcel(document.searchCondition ,mySheet , "/mpso/excelMasterMpSoProgressDownLoad.do", param);
			$("#pageflag").val('1');
			break;
		case "reload":
			kepReload('searchCondition');
			$("#st_buyer_code").val('');
			$("#st_agent_code").val('');
			$("#st_po_dept_code").val('');
			$("#st_req_dept_code").val('');
			$("#st_status").val('');
			$("#st_issue_type").val('');
			mySheet.RemoveAll();
			
			// 다중선택콤보(공통) - 초기화
			init_multiCombo("st_status");
			
			// 다중선택콤보(공통) - 초기화
			init_multiCombo("st_issue_type");
			
			$("#st_from_date").val( kepToMonthAdd("1","M") );
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
			
			document.getElementById("st_checkbox").checked = false;
			document.getElementById("st_pocheckbox").checked = false;			
			break;
		}
	}

	function validCheck() {
	 	var buyer_code      = $("#st_buyer_code").val();
		var agent_code      = $("#st_agent_code").val();
		
		if(buyer_code == "" && agent_code == "") {
			alert("고객사 또는 협력사를 선택해 주십시요.");
			return false;
		}

		var buyer_item_no   = $("#st_buyer_item_no").val();//f.st_buyer_item_no.value;
		var if_po_no        = $("#st_if_po_no").val();//f.st_if_po_no.value;
		var po_no           = $("#st_po_no").val();
		var ref_no			= $("#st_ref_no").val();
	   
		var checkAll = 'N';
		
		if(document.getElementById("st_pocheckbox").checked == true){
			 $("#st_doc_type").val('F');		
		}else{
			 $("#st_doc_type").val('N');					
		}
	    if(document.getElementById("st_checkbox").checked == true){
			if( buyer_item_no =="" &&  if_po_no =="" && po_no =="" && ref_no == ""){
				alert("기간을 무시하고 조회시\n\n고객사 선택후\n\n품목코드, I/F발주번호, 발주번호, 관리번호 중\n\n한가지 이상을 정확히(전체입력) 기입해야 합니다.");	
				return false;
			}
			checkAll ="Y";
			$("#st_all_po").val('Y');
		}else{
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 62 ){
				alert("조회기간을 2개월 단위로 조회가 가능합니다.\n\n2개월 이상의 데이타는 S/R 요청 바랍니다.");
				return false;
			}
			checkAll = 'N';
			$("#st_all_po").val('N');
		}
		return true;
	}
	
	function mySheet_OnLoadData(DATA) {
		return DATA;
	}
	
	function mySheet_OnSearchEnd(code, msg, stCode) {
		loader_obj("N");
		if(!checkedSession(stCode)){return;}

		if (msg != "") {
			alert(msg);
		}
		
		if(isCheckCol("PO_QTY"))			document.forms.searchCondition.st_po_tot_cnt.value =  mySheet.GetCellText(mySheet.LastRow(),"PO_QTY"); //  kepCommaNum(po_tot_cnt);
		if(isCheckCol("GR_QTY1"))			document.forms.searchCondition.st_gr_tot_cnt.value =  mySheet.GetCellText(mySheet.LastRow(),"GR_QTY1"); //kepCommaNum(gr_tot_cnt);
		if(isCheckCol("INV_QTY"))			document.forms.searchCondition.st_iv_tot_cnt.value =  mySheet.GetCellText(mySheet.LastRow(),"INV_QTY"); //kepCommaNum(iv_tot_cnt);
		if(isCheckCol("DELIVERY_QTY"))	document.forms.searchCondition.st_di_tot_cnt.value =  mySheet.GetCellText(mySheet.LastRow(),"DELIVERY_QTY"); //kepCommaNum(di_tot_cnt);
		if(isCheckCol("UNIT_SUM"))		document.forms.searchCondition.st_tot_item_amt.value =  mySheet.GetCellText(mySheet.LastRow(),"UNIT_SUM"); //kepCommaNum(tot_item_amt);
		if(isCheckCol("AGENT_SUM"))	document.forms.searchCondition.st_tot_agent_item_amt.value =  mySheet.GetCellText(mySheet.LastRow(),"AGENT_SUM"); //kepCommaNum(tot_agent_item_amt);
		
		//합계행을 감춘다.
		mySheet.SetRowHidden(mySheet.LastRow(),1);
		
		var totRow = mySheet.RowCount();
		for(var i=1; i<=totRow;i++){
			if(isCheckCol("PO_USER_ID"))	mySheet.SetToolTipText(i, "PO_USER_ID_MASK", mySheet.GetCellValue(i, "PO_USER_ID"));
			if(isCheckCol("PO_USER_NAME"))	mySheet.SetToolTipText(i, "PO_USER_NAME_MASK", mySheet.GetCellValue(i, "PO_USER_NAME"));
			if(isCheckCol("REQ_USER_ID"))	mySheet.SetToolTipText(i, "REQ_USER_ID_MASK", mySheet.GetCellValue(i, "REQ_USER_ID"));
			if(isCheckCol("REQ_USER_NAME"))	mySheet.SetToolTipText(i, "REQ_USER_NAME_MASK", mySheet.GetCellValue(i, "REQ_USER_NAME"));
			if(isCheckCol("PO_REMARK_HD"))	mySheet.SetToolTipText(i, "PO_REMARK_HD_MASK", mySheet.GetCellValue(i, "PO_REMARK_HD"));
			
			var doc_type = mySheet.GetCellValue(i, 'DOC_TYPE'); 
			var st_buy_close_date_yn = mySheet.GetCellValue(i, 'BUY_CLOSE_DATE_YN');
			var st_sell_close_date_yn = mySheet.GetCellValue(i, 'SELL_CLOSE_DATE_YN');
			if(doc_type == "F") { 
				mySheet.SetCellFontColor(i,"PO_NO","red");
			} 
			//매출단가, 매입단가 만료되었을때 배경색 지정
			if(st_buy_close_date_yn == "Y"||st_sell_close_date_yn == "Y"){
				mySheet.SetCellBackColor(i,"BUYER","yellow");
				mySheet.SetCellBackColor(i,"BUYER_NAME","yellow");
				mySheet.SetCellBackColor(i,"AGENT_NAME","yellow");
				mySheet.SetCellBackColor(i,"AGENT_CODE","yellow");
				mySheet.SetCellBackColor(i,"STATUS_TEXT","yellow");
				mySheet.SetCellBackColor(i,"PO_NO","yellow");
				mySheet.SetCellBackColor(i,"PO_SEQ","yellow");
			}
		}
	}
	
	function mySheet_OnSaveEnd(code, msg, stCode) {
		loader_obj("N");
		if(!checkedSession(stCode)){return;}
		javascript:doAction('search');
		if (msg != "") {
			alert(msg);
		}
	}

	function mySheet_OnDownFinish(downloadType, result) {
		loader_obj("N");
// 		alert(downloadType + ' 다운이 완료되었습니다. \n 다운로드 결과 : ' + ((result==true)?'성공':'실패'));
	}
	
	//팝업함수호출
	function doPop(str) {
		var st_buyer = kepReplaceAll("st_buyer_code","@","");

		switch (str) {
		case "prdept": // 요청부서
			if(st_buyer == "") {
				alert("고객사를 선택해 주십시요.");
				break;
			}
			var comCodeArr = st_buyer.split("@");
			if(comCodeArr[1]){
				alert("1개 고객사 선택시에만 사용 가능합니다.");
				break;
			}
			openSearchPopup('/common/deptCodeAdminPop.do','?open=Y&com_code='+comCodeArr[0], '500,500,no');
			popupSel = "prdept";
			break;
		case "podept": // 발주부서
			if(st_buyer == "") {
				alert("고객사를 선택해 주십시요.");
				break;
			}
			var comCodeArr = st_buyer.split("@");
			if(comCodeArr[1]){
				alert("1개 고객사 선택시에만 사용 가능합니다.");
				break;
			}
			openSearchPopup('/common/deptCodeAdminPop.do','?open=Y&com_code='+comCodeArr[0], '500,500,no');
			popupSel = "podept";
			break;
		case "buyerMulti": // 고객사 M
			//openSearchPopup('/common/safetyCompanyCodePop.do','?COM_TYPE=B', '880,450,no'); // 기존 팝업
			openSearchPopup("/none/showCommonNoNeBuyerChoiceMultiPop.do","?search_opt=2&disable_yn=Y",'1000,500,no'); // DX납기개선 이슈 여러건 보이게 해달라는 사유로 견적의뢰접수 사용 팝업 HSJ 2024.02.18
			popupSel = "buyerMulti";
			break;
		case "seller": // 협력사
			openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=S&MULTI=N', '500,466,no');
			popupSel = "seller";
			break;
		case "setMyCol": // 나의 컬럼 설정 관리 팝업
			var st_user_id = $("#SessionUserId").val();
			openSearchPopup('/mpso/showMasterMpSoMyColManagePop.do','?st_user_id='+st_user_id, '1000,550,no');
			popupSel = "setMyCol";
			break;
		case "regReturn": // 반품등록
			var checkRows = mySheet.FindCheckedRow("SELECTED");
			var checkRowsArr = checkRows.split("|");	
			var buyer = "";
			var po_no = "";
			var po_seq = "";
			
			if (mySheet.RowCount() == 0){
				alert("조회된 데이터가 없습니다.");
				return;
			}
			
			if (checkRows.length == 0){
				alert("선택하신 품목이 없습니다.");
				return;
			}
			
			if (checkRowsArr.length > 1){
				alert("반품등록은 한 건만 선택 가능합니다.");
				return;
			}
			
			for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++){
				if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
					buyer            = mySheet.GetCellValue(i, "BUYER");
					po_no            = mySheet.GetCellValue(i, "PO_NO");
					po_seq           = mySheet.GetCellValue(i, "PO_SEQ");
				}
			}
			
			if(buyer==-1||po_no==-1||po_seq==-1){
				alert("반품등록시 고객사코드,발주번호,발주항번 정보가 필요하니\n해당컬럼을 추가 바랍니다.");
				return;
			}
			
			regReturnPop(buyer,po_no,po_seq);
			break;
		case "itemMulti":
			if($("#st_buyer_item_type").val() == "MI"){
				openSearchPopup('/common/multiSearchCondPop.do','?header_text=품목코드',"300,400,no");
				popupSel = "itemMulti";
					
			}
			break;
		case "msdsMailSend":
			popupSel = "msdsMailSendPop";
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var buyer_bf = "";
			var buyer_af = "";
			var buyer_item_no_bf = "";
			var buyer_item_no_af = "";
			var msds_mapping = "";
			var selected_row_cnt = 0;
			
			if (selectedGrid.length == 0) {
				alert("선택된 항목이 없습니다.");
				return;
			}
			
			for(var i=1; i<mySheet.GetTotalRows()+1; i++){
				if (mySheet.GetCellValue(i, "SELECTED") == '1'){
					selected_row_cnt ++;
					buyer_af = mySheet.GetCellValue(i, "BUYER");
					
					if(selected_row_cnt == 1){
						buyer_bf = buyer_af;
					}
					
					if(buyer_bf != buyer_af){
						alert("동일 고객사만 선택 가능합니다.");
						return;
					}
					//화학물질 이 아닐경우 전송 할 필요 없음
					if(mySheet.GetCellValue(i, "MSDS_YN") =="N"){
						alert(i + "번째 항목은 화학물질이 아니므로 전송 불가능 합니다.");
						return;						
					}
					msds_mapping = mySheet.GetCellValue(i, "MSDS_MAPPING_YN");
					if(msds_mapping == "N"){
						alert(i + "번째 항목은 MSDS 미매핑건입니다.");
						return;
					}
				}
			}
			
			for(var i=1; i<mySheet.GetTotalRows()+1; i++){
				if (mySheet.GetCellValue(i, "SELECTED") == '1'){
					buyer_item_no_bf = mySheet.GetCellValue(i, "BUYER_ITEM_NO");
					
					for(var j=i+1; j<mySheet.GetTotalRows()+1; j++){
						if (mySheet.GetCellValue(j, "SELECTED") == '1'){
							buyer_item_no_af = mySheet.GetCellValue(j, "BUYER_ITEM_NO");
							
							if(buyer_item_no_bf == buyer_item_no_af){
								alert("중복 품목을 선택할 수 없습니다.");
								return;
							}
						}
					}
				}
			}
			
			openSearchPopup("/mdcm/showMasterMdCmMsdsMailSendPop.do", '?p_buyer='+buyer_af, "900,480,no");
			break;
		case "regVoc": // VOC 등록
			var checkRows = mySheet.FindCheckedRow("SELECTED");
			var checkRowsArr = checkRows.split("|");	
			var buyer = "";
			var po_no = "";
			var po_seq = "";
			var buyer_item_no = "";
			
			if (mySheet.RowCount() == 0){
				alert("조회된 데이터가 없습니다.");
				return;
			}
			
			if (checkRows.length == 0){
				alert("선택하신 품목이 없습니다.");
				return;
			}
			
			if (checkRowsArr.length > 1){
				alert("VOC 등록은 한 건만 선택 가능합니다.");
				return;
			}
			
			for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++){
				if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
					buyer            = mySheet.GetCellValue(i, "BUYER");
					po_no            = mySheet.GetCellValue(i, "PO_NO");
					po_seq           = mySheet.GetCellValue(i, "PO_SEQ");
					buyer_item_no 	 = mySheet.GetCellValue(i, "BUYER_ITEM_NO");
				}
			}
			
			if(buyer==-1||po_no==-1||po_seq==-1){
				alert("VOC 등록시 고객사코드,발주번호,발주항번 정보가 필요하니\n해당컬럼을 추가 바랍니다.");
				return;
			}
			
			regVocPop(buyer,po_no,po_seq, buyer_item_no);
			break;
			
		case "gr_lock":
			openSearchPopup("/mpso/showMasterMpSoBuyerGrLockPop.do", "", "900,500,no");
			popupSel = "gr_lock";
			
			break;
			
		case "Dmsend":
			popupSel = "Dmsend";
			const separator = "@";
			const formSeparator = "@@";
			const paramSeparator = "^||^";
			const commaSeparator = ",";
			let firstParamFlg = true;
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var checkRowsArr = selectedGrid.split("|");
			// 선택된 항목 유무 체크
			if (str !="search" && selectedGrid.length == 0) {
				alert("선택된 값이 없습니다.");
				return;
			}
			if (checkRowsArr.length > 10){
				alert("10건 이하로 DM발송 가능합니다.");
				return;
			}
			// var dataArr = selectedGrid.split(separator);// 삭제대상
			var st_popup_url = "/mpso/getMasterMpSoProgressDmSendPop.do";
			var st_popup_option = "900,850,no";			
			var st_polist_param	= "";
			
			for(var i=1; i<mySheet.GetTotalRows()+1; i++){
				// 첫 실행에서 구분자 없이 붙이기
				if (mySheet.GetCellValue(i, "SELECTED") == '1'){
					if(firstParamFlg) {
						firstParamFlg			= false; // 구분자 없이 붙이기 위한 flg 					
						st_com_code_param		= mySheet.GetCellValue(i,"BUYER") + "'";			
						st_po_no_param			= "'" + mySheet.GetCellValue(i,"PO_NO") + "'";
						st_po_seq_param			= "'" + mySheet.GetCellValue(i,"PO_SEQ");
						st_polist_param         = "st_polist@@" + st_com_code_param + commaSeparator + st_po_no_param + commaSeparator + st_po_seq_param
					}else{
						st_com_code_param		= mySheet.GetCellValue(i,"BUYER") + "'";
						st_po_no_param			= "'" + mySheet.GetCellValue(i,"PO_NO") + "'";
						st_po_seq_param			= "'" + mySheet.GetCellValue(i,"PO_SEQ");
						st_polist_param         += separator + st_com_code_param + commaSeparator + st_po_no_param + commaSeparator + st_po_seq_param
						
					}
				}
			}			
			openSearchPopupAppendPost("ProgressDmSendPopForm",st_popup_url,st_polist_param,st_popup_option);
			break;
			
			
		}
	}
	//반품등록 팝업
	function regReturnPop(buyer,po_no,po_seq){
		openSearchPopup('/wmre/showMasterWmReReturnPoInfo.do', '?st_buyer_code='+buyer+'&st_po_no='+po_no+'&st_po_seq='+po_seq+'&st_insert_yn=Y' ,'1000,610,no');
	}
	//VOC 등록 팝업
	function regVocPop(buyer,po_no,po_seq, buyer_item_no){
		openSearchPopup('/mpvo/showMasterMpVoVocRegPop.do', '?st_buyer_code='+buyer+'&st_po_no='+po_no+'&st_po_seq='+po_seq+'&st_type=PO&st_insert_yn=Y&st_buyer_item_no='+buyer_item_no,'1000,380,no');
	}
	//콜백함수(파일명은 모두 동일)
	function setPopupReturn(value1,value2,value3){
		if (popupSel == "user") {	
			$("#st_buyer").val(value1);
			$("#st_buyer_name").val(value2);
		} else if (popupSel == "prdept") {	
			$("#st_req_dept_code").val(value1);
			$("#st_req_dept_name").val(value2);
		} else if (popupSel == "podept") {	
			$("#st_po_dept_code").val(value1);
			$("#st_po_dept_name").val(value2);
		} else if (popupSel == "buyerMulti") {	
			$("#st_buyer_code").val(value1);
			$("#st_buyer_name").val(kepMultiName(value2,"@"));
			
			// 고객사 재선택 시 발주부서,요청부서 초기화(2개 이상 고객사에서 사용 불가)
			$("#st_req_dept_code").val("");
			$("#st_req_dept_name").val("");
			$("#st_po_dept_code").val("");
			$("#st_po_dept_name").val("");
		} else if (popupSel == "seller") {	
			$("#st_agent_code").val(value1);
			$("#st_agent_name").val(value2);
		} else if (popupSel == "masterMpSoStockApplyPop") {
			doAction('search');
		} else if (popupSel == "itemMulti") {	
			$("#st_buyer_item_no_multi").val(value1);
			$("#st_buyer_item_no").val(kepMultiName(value1,"@"));
		} else if (popupSel == "msdsMailSendPop") {
			for(var i=1; i<mySheet.GetTotalRows()+1; i++){
				if (mySheet.GetCellValue(i, "SELECTED") == '1'){
					mySheet.SetCellValue(i, 'KEY6', value1); // RECV_USER_NAME
					mySheet.SetCellValue(i, 'KEY7', value2); // RECV_EMAIL
					mySheet.SetCellValue(i, 'KEY8', value3); // REMARK
				}
			}
			
			kepSave(document.searchCondition, mySheet, "/mdcm/saveMasterMdcmMsdsMailSendPop.do", "SELECTED");
		}
	}
	
	 //그리드 셀클릭 이벤트
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if ( Row  < 1) return;  
		
		var column = mySheet.ColSaveName(Col);
		if (column == "SCM_REMARK") { // 비고
			var BUYER = mySheet.GetCellValue(Row,"BUYER");
			var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
			var PO_SEQ = mySheet.GetCellValue(Row,"PO_SEQ");

			if(BUYER == -1){
				alert("컬럼설정에서 고객사코드를 추가 후 사용하시기 바랍니다.");
				return;
			}
			if(PO_NO == -1){
				alert("컬럼설정에서 발주번호를 추가 후 사용하시기 바랍니다.");
				return;
			}
			if(PO_SEQ == -1){
				alert("컬럼설정에서 발주항번을 추가 후 사용하시기 바랍니다.");
				return;
			}
			
			openSearchPopup("/coco/getCommonCoCoScmActionDetailPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO+"&st_po_seq="+PO_SEQ, "520,500,no");

		}else if (column == 'BUYER_NAME') { // 고객사
			if(!isCheckColMsg("BUYER", "고객사코드")) return;
			var BUYER = mySheet.GetCellValue(Row,"BUYER");
			openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+BUYER, '800,550,no');

		} else if (column == 'PR_NO') { // 요청번호
			if(!isCheckColMsg("BUYER", "고객사코드")) return;
			var BUYER = mySheet.GetCellValue(Row,"BUYER");
			var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
			var PR_NO = mySheet.GetCellValue(Row,"PR_NO");
			openSearchPopup('/mpso/showMasterMpSoDlvyAgrmntHistoryManagePop.do','?st_buyer='+BUYER+'&st_po_no='+PO_NO+'&st_pr_no='+PR_NO, '750,380,no');

		} else if (column == 'PO_NO') { // 발주번호
			if(!isCheckColMsg("BUYER", "고객사코드")) return;
			var BUYER = mySheet.GetCellValue(Row,"BUYER");
			var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
			openSearchPopup('/common/mpso/poDetailPop.do','?st_buyer='+BUYER+'&st_po_no='+PO_NO,'900,550,no');
			
		} else if (column == 'AGENT_NAME') { // 협력사
			if(!isCheckColMsg("AGENT_CODE", "협력사코드")) return;
			
			var st_popup_url="";
			var st_popup_param = "";
			var st_popup_option = "";
			
			st_popup_url = "/common/agentPoMngPop.do";
			st_popup_param = "st_com_code@@"+mySheet.GetCellValue(Row,"AGENT_CODE");
			st_popup_option = "890,800,no";

			openSearchPopupAppendPost("IssueRemarkPopForm2",st_popup_url,st_popup_param,st_popup_option);
		} else if (column == 'PO_USER_NAME_MASK') { // 발주자
			if(!isCheckColMsg("PO_USER_ID", "발주자ID")) return;
			var ID = mySheet.GetCellValue(Row,"PO_USER_ID");
			openSearchPopup('/common/userDisplayPop.do','?user_id='+ID,'800,500,no');
			
		} else if (column == 'HA_DATE') { // 납품합의일
			if(!isCheckColMsg("BUYER", "고객사코드")) return;
			if(!isCheckColMsg("PO_SEQ", "발주항번")) return;
			var buyer = mySheet.GetCellValue(Row,"BUYER");
			var po_no = mySheet.GetCellValue(Row,"PO_NO");
			var po_seq = mySheet.GetCellValue(Row,"PO_SEQ");
			openSearchPopup('/mppo/showBuyerMpPoDvlyAgrmntHistoryPop.do', "?open=Y&st_buyer="+ buyer + "&st_po_no="+po_no + "&st_po_seq="+po_seq, '800,450,no');

		} else if (column == 'GR_DATE') { // 입고일
			if(!isCheckColMsg("BUYER", "고객사코드")) return;
			if(!isCheckColMsg("PO_SEQ", "발주항번")) return;
			var gr_date = mySheet.GetCellValue(Row,"GR_DATE");
			if(gr_date == "") {
				alert("해당 입고자료가 없습니다.");
				return;
			}
			var buyer = mySheet.GetCellValue(Row,"BUYER");
			var po_no = mySheet.GetCellValue(Row,"PO_NO");
			var po_seq = mySheet.GetCellValue(Row,"PO_SEQ");
			openSearchPopup('/mpiv/getCommonMpIvWarehousingDetailPop.do', "?open=Y&st_buyer="+ buyer + "&st_po_no="+po_no + "&st_po_seq="+po_seq,'840,500,no');

		} else if (column == 'CD_DATE'){ // 납품예정일
			if(!isCheckColMsg("BUYER", "고객사코드")) return;
			if(!isCheckColMsg("PO_SEQ", "발주항번")) return;
			if(!isCheckColMsg("RD_DATE", "납기요청일")) return;
			if(!isCheckColMsg("PO_QTY", "발주수량")) return;
			if(!isCheckColMsg("AGENT_CODE", "협력사코드")) return;
			if(!isCheckColMsg("PO_USER_ID", "발주자ID")) return;
			
			var BUYER = mySheet.GetCellValue(Row,"BUYER");
			var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
			var PO_SEQ = mySheet.GetCellValue(Row,"PO_SEQ");
			
			var RD_DATE = mySheet.GetCellValue(Row,"RD_DATE");
			var ITEM_QTY = mySheet.GetCellValue(Row,"PO_QTY");
			
			var SELLER = mySheet.GetCellValue(Row,"AGENT_CODE");
			var ADD_USER_ID = mySheet.GetCellValue(Row,"PO_USER_ID");
			
			openSearchPopup("/mpiv/getMasterMpIvMultiDeliveryPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO+"&st_po_seq="+PO_SEQ+"&st_rd_date="+RD_DATE+"&st_item_qty="+ITEM_QTY+"&st_seller="+SELLER+"&st_add_user_id="+ADD_USER_ID, "550,600,no");
			
			
		} else if (column == 'INVOICE_DATE') { // 납품일
			if(!isCheckColMsg("BUYER", "고객사코드")) return;
			if(!isCheckColMsg("PO_SEQ", "발주항번")) return;
			
			var invoice_date = mySheet.GetCellValue(Row,"INVOICE_DATE");
			if(invoice_date == "") {
				alert("해당 거래명세서가 없습니다.");
				return;
			}
			var buyer = mySheet.GetCellValue(Row,"BUYER");
			var po_no = mySheet.GetCellValue(Row,"PO_NO");
			var po_seq = mySheet.GetCellValue(Row,"PO_SEQ");
			openSearchPopup('/wmgr/getMasterWmGrWarehousingNoPop.do', "?open=Y&st_buyer="+ buyer + "&st_po_no="+po_no + "&st_po_seq="+po_seq, '840,500,no');

		} else if (column == 'REQ_USER_NAME_MASK') { // 요청자
			if(!isCheckColMsg("REQ_USER_ID", "요청자ID")) return;
			var ID = mySheet.GetCellValue(Row,"REQ_USER_ID");
			openSearchPopup('/common/userDisplayPop.do','?user_id='+ID,'800,500,no');
		} else if (column == 'BUYER_ITEM_NO') { // 품목코드
			if(!isCheckColMsg("BYIT_COMORG_CODE", "카탈로그관리코드")) return;
			if(!isCheckColMsg("CONTRACT_NO", "계약서번호")) return;
			if(!isCheckColMsg("CONTRACT_SEQ", "계약서항번")) return;
			
			var buyer = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
			var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
			var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
			var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
			openSearchPopup('/common/catalogDetailPop.do','?BUYER='+buyer+'&BUYER_ITEM_NO='+buyerItemNo+'&CONTRACT_NO='+contractNo+'&CONTRACT_SEQ='+contractSeq,'800,290,no');
		} else if(column == "IMAGE_KEY_YN"){ // 파일첨부
			popupSel = "fileUpload";
			var type="PO";
			var viewType="R"; // 보기전용
			var image_key=mySheet.GetCellValue(Row, "IMAGE_KEY");
			if (image_key != "") {
				openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
			}
		} else if(column == "LOGISTICS_RATE"){ // 물류비
			var code = mySheet.GetCellValue(Row, "LOGIS_RATE_STATUS");
			openSearchPopup('/common/getLogisFeeReasonPop.do','?st_reason_code=' + code, '600,180,no');// 물류비 책정 사유
		} else if (column == 'ISSUE_IMG') { // 발주관리 팝업
			var BUYER = mySheet.GetCellValue(Row,"BUYER");
			var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
			var PO_SEQ = mySheet.GetCellValue(Row,"PO_SEQ");

			if(BUYER == -1){
				alert("컬럼설정에서 고객사코드를 추가 후 사용하시기 바랍니다.");
				return;
			}
			if(PO_NO == -1){
				alert("컬럼설정에서 발주번호를 추가 후 사용하시기 바랍니다.");
				return;
			}
			if(PO_SEQ == -1){
				alert("컬럼설정에서 발주항번을 추가 후 사용하시기 바랍니다.");
				return;
			}
			
			st_popup_url = "/mpso/masterMpSoIssueManageRemarkPop.do";
			st_popup_param = "st_buyer@@"+mySheet.GetCellValue(Row,"BUYER")+"^||^st_po_no@@"+mySheet.GetCellValue(Row,"PO_NO")+"^||^st_po_seq@@"+mySheet.GetCellValue(Row,"PO_SEQ");
			st_popup_option = "1300,800,no";
			
			openSearchPopupAppendPost("IssueRemarkPopForm1",st_popup_url,st_popup_param,st_popup_option);
		}
	}
	 
	 function isCheckCol(col_id){
		 if( mySheet.SaveNameCol(col_id) > -1){
			 return true;
		 } else {
			 return false;
		 }
	 }
	 
	 function isCheckColMsg(col_id, col_name){
		 if( mySheet.SaveNameCol(col_id) == -1){
			 alert(col_name + " 컬럼이 선택 되지 않아 이용에 제한 되었습니다.\n기능을 이용하시려면 컬럼설정에서 " + col_name + " 컬럼을 선택해 주세요.");
			 return false;
		 }
		 return true;
	 }
	 
	 function resetItem(item_type){
		 if(item_type == "SI"){
			 $("#st_buyer_item_no").val("");
			 $("#st_buyer_item_no_multi").val("");
			 $("#st_buyer_item_no").attr("readonly", false);
		 }else if(item_type == "MI"){
			 $("#st_buyer_item_no").val("");
			 $("#st_buyer_item_no_multi").val("");
			 $("#st_buyer_item_no").attr("readonly", true);
		 }
	 }
</script>
</head>
<body onload="initPage()">
<!--내용 시작-->	
		<!--버튼영역-->
       	<div id="searchBtnA"  >
       			<h3>주문진행</h3>
				<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
				<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
   		</div>             				
		<form name="searchCondition" id="searchCondition">
			<!-- HIDDEN -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" name="SessionUserId" id="SessionUserId"  value="${sessionInfo.userId}"> <!-- MSDS 메일전송 공통 파라미터로 사용중 -->
			<input type="hidden" name="st_all_po"  id="st_all_po" value ="N">
			<input type="hidden" name="st_doc_type"  id="st_doc_type" value ="">		
			<input type="hidden" name="my_col_info"  id="my_col_info" value ="<%=my_col_info%>">
			<input type="hidden" name="st_msds_mail_reg_type"  id="st_msds_mail_reg_type" value ="PO"> <!-- MSDS 메일전송 공통 파라미터로 사용중 -->
			<input type="hidden" name="st_non_masking_flag" id="st_non_masking_flag" value ="N">
			
			<div id="cont_searchA">
				<table  class="cont_t_list01"  >
					<caption>진행상태조회</caption>
					<colgroup>
						<col width="10%" />
						<col width="23%" />
						<col width="10%" />
						<col width="23%" />
						<col width="10%" />
                        <col width="23%" />
					</colgroup>
					
					<tbody>
					<tr>
						<th>
							<label for="b_code" class="hidden">기간선택</label>
				  			<select name = "st_date_type" id="st_date_type" class="TitSelect">
					      		<option value="PO" selected="selected">발주일</option>
								<option value="GR" >입고일</option>
								<option value="RD" >요청일</option>
								<option value="DS" >예정일</option>
								<option value="AD" >생성일</option>
                           </select>
						</th>
						<td colspan="3">
							<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:12%; text-align:center;" > - 
							<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:12%; text-align:center;" >
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
							<span class="btn_month"><a href="javascript:kepFromMonth('st_from_date','st_to_date','1')">-1개월</a></span> 
							&nbsp;&nbsp;
							<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox">&nbsp;기간무시
							<img src="/resources/images/but_query.png" title="[기간무시 조회기준]&#10;1. 고객사 입력&#10;2. 품목코드, I/F발주번호, 발주번호,&#10;관리번호 중 1개 이상 정확 입력">
							&nbsp;
							<input type="checkbox"  class="Noborder" name="st_pocheckbox" id="st_pocheckbox" >
							<select name = "st_po_doc_type" id="st_po_doc_type" style="height:20px;width:80px;vertical-align:middle" class="TitSelect">
					      		<option value="F" selected="selected">긴급발주</option>
								<option value="S" >선입고</option>
                           </select>
						</td>
					    <th>진행상태</th>
					    <td>
                            	<label for="b_delivery" class="hidden">진행상태선택</label>
                 				<!-- 다중선택콤보(공통) - input박스의 type은 hidden으로 생성 할것 , style, class는 select 박스에 상속 됨. -->
                 				<input type="hidden" name="st_status" id="st_status" value ="" style="width:80%;">
		             	</td> 
	             	</tr>
					<tr>
						<th><font color="red"><b>*</b></font>고객사</th>
						<td>
	                        <input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:70%;" value = "">
	                        <input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:100px;" value ="">
	                        <a href="javascript:doPop('buyerMulti');"><img src="/resources/images/btn_search03.gif"></a>
	                        <a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th><font color="red"><b>*</b></font>협력사</th>
							<td>
		                        <input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:70%;" value ="" READONLY>
		                        <input type="hidden" name="st_agent_code" id="st_agent_code" style="width:100px;" value ="">
		                        <a href="javascript:doPop('seller');"><img src="/resources/images/btn_search03.gif"></a>
		                        <a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
                            </td>
						<th>
							<select name = "st_buyer_item_type" id="st_buyer_item_type" class="TitSelect" onchange="resetItem(this.value)">
					      		<option value="SI" selected="selected">품목코드</option>
								<option value="MI" >다중 품목코드</option>
                           </select>
						</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:70%;ime-mode:disabled; " value =""  maxlength="50"  onblur="kepToUpper('st_buyer_item_no')" onKeyDown="kepEnter()" onclick="javascript:doPop('itemMulti')">
							<input type="hidden" name="st_buyer_item_no_multi" id="st_buyer_item_no_multi" style="width:100px;" value ="">
							<a href="javascript:kepEraser('st_buyer_item_no','st_buyer_item_no_multi');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
					</tr>
					<tr>
						<th>발주부서</th>
	                    <td class ="font1_table_font">
	                        <input type="text" class="input_type_text" name="st_po_dept_name" id="st_po_dept_name" style="width:70%;" value ="" READONLY>
	                        <input type="hidden" name="st_po_dept_code" id="st_po_dept_code" style="width:100px;" value ="">
	                        <a href="javascript:doPop('podept');"><img src="/resources/images/btn_search03.gif"></a>
	                        <a href="javascript:kepEraser('st_po_dept_code','st_po_dept_name');"><img src="/resources/images/btn_eraser2.gif"></a>
	                    </td>
	                    <th>요청부서</th>
	                    <td class ="font1_table_font">
	                        <input type="text" class="input_type_text" name="st_req_dept_name" id="st_req_dept_name" style="width:70%;" value="" READONLY>
	                        <input type="hidden" name="st_req_dept_code" id="st_req_dept_code" value="">
	                        <a href="javascript:doPop('prdept');"><img src="/resources/images/btn_search03.gif"></a>
	                        <a href="javascript:kepEraser('st_req_dept_code','st_req_dept_name');"><img src="/resources/images/btn_eraser2.gif"></a>
	                    </td>
	                    <th>I/F 발주번호</th>
	                    <td class ="font1_table_font">
	                    	<input type="text" class="input_type_text" name="st_if_po_no" id="st_if_po_no" size="25" style="width:80%;ime-mode:disabled;" value ="" maxlength="30"  onblur="kepToUpper('st_if_po_no')" onKeyDown="kepEnter()">
	                    </td>
					</tr>
					<tr>
						<th>발주번호</th>
	                    <td class ="font1_table_font">
	                    	<input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:90%;ime-mode:disabled;" value ="" maxlength="20"  onblur="kepToUpper('st_po_no')" onKeyDown="kepEnter()">
	                    </td>
	                    <th>관리번호</th>
	                    <td class ="font1_table_font" >
	                    	<input type="text" class="input_type_text" name="st_ref_no" id="st_ref_no" style="width:90%;" value ="" onKeyDown="kepEnter()">
	                    </td>
						<th>I/F 관리번호</th>
	                    <td class ="font1_table_font" >
	                    	<input type="text" class="input_type_text" name="st_ref_if_no" id="st_ref_if_no" size="25"  style="width:80%;" value ="" onKeyDown="kepEnter()">
	                    </td>
					</tr>
					<tr>
						<th>전략SG담당자</th>
	                    <td class ="font1_table_font" >
	                    	<select id="st_kep_user_id" name="st_kep_user_id" style="width:90%;"></select>
	                    </td>
	                    <td>PLANT 담당자</td>
	                    <td class ="font1_table_font" >
	                    	<select id="st_plant_user_id" name="st_plant_user_id" style="width:90%;"></select>
	                    </td>
						<th>패킹업체</th>
						<td>
							<select id="st_pkg_cmpy_no" name="st_pkg_cmpy_no" style="width:80%;"></select>
						</td>
					</tr>
					<tr>
						<th>SCM</th>
	                    <td class ="font1_table_font" >
	                    	<input type="text" class="input_type_text" name="st_scm_remark" id="st_scm_remark" style="width:90%;" value ="" maxlength="20"   onKeyDown="kepEnter()">
	                    </td>
						<th>요청번호</th>
	                    <td class ="font1_table_font">
	                    	<input type="text" class="input_type_text" name="st_pr_no" id="st_pr_no" style="width:90%;ime-mode:disabled;" value ="" maxlength="20"  onblur="kepToUpper('st_pr_no')" onKeyDown="kepEnter()">
	                    </td>
						<th>발주이슈</th>
					    <td>
                            	<label for="b_delivery" class="hidden">진행상태선택</label>
                 				<!-- 다중선택콤보(공통) - input박스의 type은 hidden으로 생성 할것 , style, class는 select 박스에 상속 됨. -->
                 				<input type="hidden" name="st_issue_type" id="st_issue_type" value ="" style="width:80%;">
		             	</td>
					</tr>
					</tbody>
				</table>
			</div>
			
			<table style="width:100%;">
				<tr>
					<td align="left">
							&nbsp;<img src="/resources/images/icon_r.gif"> : 발주이슈 미처리
							&nbsp;<img src="/resources/images/icon_g.gif"> : 발주이슈 처리완료
					</td>
					<td style="text-align: right;">
						<span class="btn_04"><a href="javascript:doPop('setMyCol');">컬럼설정</a></span>
					</td>
		   		</tr>
			</table>
			
			<div class="ib_product" style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "350px");
				</script>
			</div>
			
			<table style="width:100%;">
				<tr>
					<td colspan="2" height="25" align="left">
			            <span id="span_po_tot_cnt" style="display: none;">■ 발주수량 합계 : <input type="text" class="input_type_text" name="st_po_tot_cnt" id="st_po_tot_cnt" style="border-width:0px;" value="0" size="10" readonly></span>
			            <span id="span_gr_tot_cnt" style="display: none;">■ 입고수량 합계 : <input type="text" class="input_type_text" name="st_gr_tot_cnt" id="st_gr_tot_cnt" style="border-width:0px;" value="0" size="10" readonly></span>
			            <span id="span_iv_tot_cnt" style="display: none;">■ 납품수량 합계 : <input type="text" class="input_type_text" name="st_iv_tot_cnt" id="st_iv_tot_cnt" style="border-width:0px;" value="0" size="10" readonly></span>
			            <span id="span_di_tot_cnt" style="display: none;">■ 확정수량 합계 : <input type="text" class="input_type_text" name="st_di_tot_cnt" id="st_di_tot_cnt" style="border-width:0px;" value="0" size="10" readonly></span>
			            <span id="span_tot_item_amt" style="display: none;">■ 매출금액 합계 : <input type="text" class="input_type_text" name="st_tot_item_amt" id="st_tot_item_amt" style="border-width:0px;" value="0" size="11" readonly></span>
			            <span id="span_tot_agent_item_amt" style="display: none;">■ 매입금액 합계 : <input type="text" class="input_type_text" name="st_tot_agent_item_amt" id="st_tot_agent_item_amt" style="border-width:0px;" value="0" size="11" readonly></span>
			        </td>
				</tr>
			    <tr>
			        <td height="25" align="left">
			            <font color="#666666">&nbsp;&nbsp;* 모든 금액은 VAT 별도이며, 노랜색 음영 표기건은 매출단가 또는 매입단가 유효일이 만료 된 발주건입니다.</font><br>
			        </td>
			        <td height="25" align = "right" valign="middle">
			      		<span class="btn_04"><a href="javascript:doPop('Dmsend');">DM발송</a></span>
			            <span class="btn_06"><a href="javascript:doPop('gr_lock');">입고잠금/해제</a></span>
			            <span class="btn_06"><a href="javascript:doPop('msdsMailSend');">MSDS 메일 전송</a></span>
			            <span class="btn_06"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
 			            <span class="btn_04"><a href="javascript:doPop('regVoc');">VOC등록</a></span>
			            <span class="btn_02"><a href="javascript:doPop('regReturn');">반품등록</a></span>
			        </td>
			    </tr>
			</table>
			
		</form>
	
<!--내용 종료-->	       
	
</body>
</html>			
