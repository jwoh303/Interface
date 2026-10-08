<%--
**********************************************
* 메뉴 : 견적관리>업체선정 및 견적제출
* 화면 : 업체선정 및 견적제출
* 기능 : 협력사에게 견적의뢰한 건에 대하여 협력사가 견적을 작성하여 견적을 접수하면 
*         운영사가 접수현황을 조회하고 접수마감처리를 하여 협력사를 선정하고 
*         접수결과를 고객사에게 통보하고 견적을 제출한다
* 프로그램 ID : PG_04_M_007_00
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-06-09
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>
<%
	String st_user_dept = _sessionInfo.getDepartment();
	String st_user_id = _sessionInfo.getUserId();
	
	//소싱부서 여부
	String st_sour_dept_yn = "";
	boolean st_sour_dept = CommonUtil.getCodeCheckReturn("SOURDEPT",st_user_dept);
	if(st_sour_dept == true){
		st_sour_dept_yn = "Y";
	}else{
		st_sour_dept_yn = "N";
	}
	
	// MRO사업팀 확인
	String st_mro_dept_yn = "";
	boolean st_mro_dept = CommonUtil.getCodeCheckReturn("MRODEPT",st_user_dept);
	if(st_mro_dept == true){
		st_mro_dept_yn = "Y";
	}else{
		st_mro_dept_yn = "N";
	}
	
	// SMART팀 확인( 견적담당자 전체 조회 시 견적이관 대상 SG 담당자 제외하고 조회 P04-4029-05 )
	String st_smart_dept_yn = "";
	boolean st_smart_dept = CommonUtil.getCodeCheckReturn("SMRTDEPT",st_user_dept);
	if(st_smart_dept == true){
		st_smart_dept_yn = "Y";
	}else{
		st_smart_dept_yn = "N";
	}
	
	// 고객사별 견적건 일괄제출 (ICOMCOD1.TYPE=ALRE) SQL = ALL_RQDT_FLAG
	// 고객사별 제출가능 단가범위 (P04-4041-09) SQL
	// 고객사별 제출 제한(P04-4032-13) SQL = QUOT_SEND_BLOCK_FLAG
	// 비고제출 필수 고객사(P04-4041-11) SQL = REMARK_FLAG
	
	// SMART팀 견적이관 대상 SG목록, 견적이관대상자ID, 견적이관대상자명
	String p04402905_col01 = CommonUtil.getSpecialCheckReturn("KRKORE0001","P04-4029-05","COL01_DATA");
	String p04402905_col02 = CommonUtil.getSpecialCheckReturn("KRKORE0001","P04-4029-05","COL02_DATA");
	String p04402905_col03 = CommonUtil.getSpecialCheckReturn("KRKORE0001","P04-4029-05","COL03_DATA");
	
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var iconR="/resources/images/icon_r.gif";
var iconY="/resources/images/icon_y.gif";
var iconG="/resources/images/icon_g.gif";
var iconPrint="/resources/images/icon_print.gif";
var reasonOn = "/resources/images/icon.gif";
var reasonOff = "/resources/images/icon2.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

var cb_item_chg_req_type = KepSheetComboData("DM04","SEL");
var item_chg_req_type = {ComboCode: cb_item_chg_req_type.ComboCode, ComboText: cb_item_chg_req_type.ComboText};

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 7};
// 	initsheet.HeaderMode = {			Sort : 0,			ColMove : 1,			ColResize : 1 		};
	initsheet.Cols = [ 
						 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
							,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED", ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:18,	Edit : true,	EditLen:100,	Hidden : false,	Type:"Image",	Header:"고객사",	SaveName:"PRINT",ColMerge:1,Sort:1}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME", ColMerge:1,Sort:1}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사",	SaveName:"BUYER",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"진행상태",	SaveName:"STATUS",ColMerge:0,Sort:1}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"구분",	SaveName:"GUBUN,",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적번호",	SaveName:"QUOTATION_NO",ColMerge:0,Sort:1}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"순번",	SaveName:"QUOTATION_SEQ",ColMerge:0,Sort:1}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"순번",	SaveName:"REVISION",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:65,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"차수(B/S)",	SaveName:"REVICNT",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"회신요청일",	SaveName:"BTOA_END_DT", FontBold:1,ColMerge:0,Sort:1}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적마감일",	SaveName:"ATOS_END_DT",ColMerge:0,Sort:1}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",    Header:"접수건수",	SaveName:"QUOTA_CNT",ColMerge:0,Sort:1}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"선정협력사",	SaveName:"AGENT_NAME",ColMerge:0,Sort:1}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"지정협력사",	SaveName:"ASSIGN_AGENT_CODE",ColMerge:0,Sort:1}
							,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}", 	Header:"매출단가",	SaveName:"ATOB_UNIT_PRICE",ColMerge:0,Sort:1}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"진행구분",	SaveName:"SG_GBN",ColMerge:0,Sort:1}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SG담당자",	SaveName:"SOUR_MNG", Sort:1}
							,{ Align:"Center",	Width:90,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SG담당자YN",	SaveName:"SG_KEP_YN",Sort:1}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"선정협력사코드",	SaveName:"AGENT",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:15,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"품목코드",	SaveName:"SIGNAL",ColMerge:1,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO",ColMerge:1,Sort:1}
							,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	ToolTip:1,	Header:"품목명",	SaveName:"DESCRIPTION",ColMerge:0,Sort:1}
							,{ Align:"Left",	Width:300,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	ToolTip:1,	Header:"규격",	SaveName:"SPECIFICATION",Wrap:1,ColMerge:0,Sort:1}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME",ColMerge:0,Sort:1}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"원산지",	SaveName:"ORIGN_NAME",ColMerge:0,Sort:1}
							,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Format:"${priceFormat}", 	Header:"요청단가",	SaveName:"BUYER_TARGET_PRICE",ColMerge:0,Sort:1}
							,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Format:"${priceFormat}", 	Header:"목표단가",	SaveName:"ADMIN_TARGET_PRICE",ColMerge:0,Sort:1}
							,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Format:"${priceFormat}", 	Header:"네고단가",	SaveName:"BTOA_NEGO_PRICE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적의뢰일",	SaveName:"BTOA_DATE",ColMerge:0,Sort:1}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"END_TIME_FLAG",	SaveName:"END_TIME_FLAG",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:120,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SEND_FLAG",	SaveName:"SEND_FLAG",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자ID",	SaveName:"BTOA_USER_ID",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",	SaveName:"BTOA_USER_NAME",ColMerge:0,Sort:1}
							,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자전화번호",	SaveName:"BTOA_USER_TEL",ColMerge:0,Sort:1}
							,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"공개",	SaveName:"AGENT_OPEN_FLAG",ColMerge:0, BackColor:"${optColor}",Sort:0}
							,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"공개",	SaveName:"CP_AGENT_OPEN_FLAG",ColMerge:0,Sort:0}
							,{ Align:"Left",	Width:150,	Edit:false,	EditLen:4000,	Hidden:false,	Type:"Text",	Header:"운영사비고",	SaveName:"ATOA_REMARK",	Sort:0}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고",	SaveName:"STOA_REMARK_IMG",ColMerge:0, BackColor:"${optColor}",Sort:0}
							,{ Align:"Left",	Width:150,	Edit:false,	EditLen:4000,	Hidden:false,	Type:"Text",	Header:"고객사제출비고",	SaveName:"ATOB_REMARK",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사비고",	SaveName:"STOA_REMARK",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고(운영자-협력사)",	SaveName:"ATOS_REMARK",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:2000,	Hidden:true,	Type:"Text",	Header:"고객사비고",	SaveName:"BTOA_REMARK",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"취소사유",	SaveName:"CANCEL_REMARK_IMG",ColMerge:0, BackColor:"${optColor}",Sort:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:4000,	Hidden:true,	Type:"Text",	Header:"취소사유",	SaveName:"CANCEL_REMARK",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"취소사유코드",	SaveName:"CANCEL_REMARK_CODE",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"선정담당자",	SaveName:"RFQ_KEP_USER",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"선정담당자",	SaveName:"RFQ_KEP_USER_NAME",ColMerge:0, BackColor:"${optColor}",Sort:1}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적요청일",	SaveName:"ATOS_DATE",ColMerge:0,Sort:1}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"매익율",	SaveName:"RATE",ColMerge:0,Sort:1}
							,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}", 	Header:"매입단가",	SaveName:"STOA_LIST_PRICE",ColMerge:0,Sort:1}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"MSDS요청(B)",	SaveName:"BUYER_MSDS_YN", Sort:1}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"MSDS",	SaveName:"MSDS_YN",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"MSDS_NO",	SaveName:"MSDS_NO",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"MSDS요청번호",	SaveName:"CMC_REQ_NO",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"MSDS진행상태",	SaveName:"CMC_REQ_STATUS",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"MSDS요청일시",	SaveName:"CMC_REQ_DATE",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서번호",	SaveName:"CONTRACT_NO",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서순번",	SaveName:"CONTRACT_SEQ",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ITEM_GROUP",	SaveName:"ITEM_GROUP",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float",  Format:"${priceFormat}",	Header:"AGENT_MIN_PRICE",	SaveName:"AGENT_MIN_PRICE",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SG_ID",	SaveName:"SG_ID",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"DUTY_KEP",	SaveName:"DUTY_KEP",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PM_FLAG",	SaveName:"PM_FLAG",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"RATE_FLAG",	SaveName:"RATE_FLAG",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float",  Format:"${qtyFormat}",	Header:"수량",	SaveName:"ITEM_QTY",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PLANT",	SaveName:"PLANT",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"INIT_BELOW_COMORG_CODE",	SaveName:"INIT_BELOW_COMORG_CODE",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준카탈로그코드",	SaveName:"CMS_CATLG_ID", BackColor:"${notnullColor}",Sort:1}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"표준카탈로그필수여부",	SaveName:"MAP_YN",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ATOS_END_DATE",	SaveName:"ATOS_END_DATE",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ADMIN_CLOSE_FLAG",	SaveName:"ADMIN_CLOSE_FLAG",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ADMIN_CLOSE_FLAG",	SaveName:"ADMIN_CLOSE_FLAG",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"TO_ATOS_END_DATE",	SaveName:"TO_ATOS_END_DATE",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"TO_ATOS_END_TIME",	SaveName:"TO_ATOS_END_TIME",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AGENT_REVISION",	SaveName:"AGENT_REVISION",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"EARLY_END_FLAG",	SaveName:"EARLY_END_FLAG",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PGM_VARIABLE",	SaveName:"PGM_VARIABLE",ColMerge:0,Sort:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적담당자",	SaveName:"JOB_TRANSFER_NM",	Sort:1}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적이관일시",	SaveName:"JOB_TRANSFER_DATE",	Sort:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"견적담당자ID",	SaveName:"JOB_TRANSFER_ID",	Sort:0}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"모델번호",	SaveName:"MAKER_PART_NO",	Sort:0}
							,{ Align:"Center",	Width:90,	Edit:false, EditLen:110,	Type:"Image",	Header:"견적지연사유",	SaveName:"DELAY_REASON_IMG",	Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"관리번호",	SaveName:"REF_NO", Sort:1}
							,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"DELAY_REASON_CODE",	SaveName:"DELAY_REASON_CODE",	Sort:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제조사코드",	SaveName:"MAKER_CODE",	Sort:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CATALOG_CHOICE_TYPE",	SaveName:"CATALOG_CHOICE_TYPE",	Sort:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"EXTEND_FLAG",	SaveName:"EXTEND_FLAG",	Sort:0}
							,{Align : "Center",	SaveName : "DELAY_SEND_MAIL_FLAG",			Header : "DELAY_SEND_MAIL_FLAG",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"거래유형",	SaveName:"PROCESS_TYPE",	Sort:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"조달일수",	SaveName:"LEAD_TIME",		Sort:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"MOQ",	SaveName:"MIN_ORDER_QTY",	Sort:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"발주배수",	SaveName:"PUR_UNIT_QTY",	Sort:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"PLANT담당자",	SaveName:"PLANT_USER_NM", Sort:1}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"최근 견적요청\n메일 발송일시",	SaveName:"QTDT_MAIL_SEND_DATE", Sort:1}
							,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"BYIT_STATUS",	SaveName:"BYIT_STATUS",	Sort:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적요청자(S)",	SaveName:"QTDT_ADD_USER_NM",	Sort:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"WAREHOUSE_CODE",	SaveName:"WAREHOUSE_CODE",	Sort:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"RQDT_PROCESS_TYPE",	SaveName:"RQDT_PROCESS_TYPE",	Sort:0}
							,{ Align:"Center",	Width:70,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"SG담당자",	SaveName:"DSM_MNG_NM", ColMerge:1,Sort:0}
							,{ Align:"Center",	Width:60,	Edit:false,	Hidden:false,	Type:"Text",	Header:"추가정비",	SaveName:"AFTER_CMS_REJECT_YN" ,	Sort:0}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"추가정비 요청자",	SaveName:"AFTER_ITEM_CHG_REQ_NM", Sort:0}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"추가정비 요청일시",	SaveName:"AFTER_ITEM_CHG_REQ_DATE", Sort:0}
							,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",	Header:"정비구분",			SaveName:"AFTER_ITEM_CHG_REQ_TYPE", Sort:0}
							,{ Align:"Left",	Width:300,	Edit:true,	EditLen:2000,	Hidden:false,	Type:"Text",	Header:"추가정비 요청사유",	SaveName:"AFTER_ITEM_CHG_REQ_NOTE", BackColor:"${optColor}", Sort:0}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"추가정비\n첨부",	SaveName:"AFTER_ITEM_CHG_REQ_IMAGE_KEY_IMG",	Sort:0}
			    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"추가정비\n첨부",	SaveName:"AFTER_ITEM_CHG_REQ_IMAGE_KEY",	Sort:0}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"추가정비 제출자",	SaveName:"AFTER_ITEM_MD_USER_NM", Sort:0}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"추가정비 제출일시",	SaveName:"AFTER_ITEM_MD_DATE", Sort:0}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"추가정비 제출완료",	SaveName:"AFTER_ITEM_MD_COMPLETE", Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AFTER_ITEM_MD_REVISION",	SaveName:"AFTER_ITEM_MD_REVISION",	Sort:0}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AFTER_ITEM_CHG_REQ_ID",	SaveName:"AFTER_ITEM_CHG_REQ_ID",	Sort:0}
							,{ Align:"Center",	Width:130,	Edit:false,	EditLen:2000,	Hidden:true,	Type:"Text",	Header:"ADMIN_REMARK",	SaveName:"ADMIN_REMARK",	Sort:1}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"견적총건수",	SaveName:"RQDT_CNT",	Sort:0}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"일괄제출여부",	SaveName:"ALL_RQDT_FLAG",	Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제출단가\n확인여부",	SaveName:"UNIT_PRICE_CHECK_FLAG",	Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제출가능\n최저단가",	SaveName:"MIN_UNIT_PRICE",	Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제출가능\n최고단가",	SaveName:"MAX_UNIT_PRICE",	Sort:0}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"견적제출제한",	SaveName:"QUOT_SEND_BLOCK_FLAG",	Sort:0}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고필수",	SaveName:"REMARK_FLAG",	Sort:0}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"표준카테고리코드",	SaveName:"CMS_CATEG_ID",	Sort:0}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"DELAY_FLAG",	SaveName:"DELAY_FLAG",	Sort:0}
							
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode );

	//비고이미지설정
	mySheet.SetImageList(1, iconR);
	mySheet.SetImageList(2, iconY);
	mySheet.SetImageList(3, iconG);
	mySheet.SetImageList(4, iconPrint);
	mySheet.SetImageList(5, remarkOn);
	mySheet.SetImageList(6, remarkOff);
	mySheet.SetImageList(9, reasonOn);
	mySheet.SetImageList(8, reasonOff);
	mySheet.SetImageList(10, diskOff);
	mySheet.SetImageList(11, diskOn);

	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','ALL2','${sessionInfo.userId}');
	// 콤보데이터 셋팅 조회조건 : 견적 담당자
	kepAjaxCommonQueryIdSearchTwoCombo('st_job_transfer_id','common.masterDepartmentUserList','PG_10_M_006_00','','ALL','');  
	//하이퍼링크 설정
	setLinkCol(mySheet, "PRINT");
	setLinkCol(mySheet, "BUYER_NAME");	
	setLinkCol(mySheet, "BTOA_USER_NAME");	//요청자
	setLinkCol(mySheet, "QUOTATION_NO");	//견적번호
	setLinkCol(mySheet, "AGENT_NAME");	//협력사
	setLinkCol(mySheet, "STOA_REMARK_IMG");
	setLinkCol(mySheet, "CANCEL_REMARK_IMG");
	setLinkCol(mySheet, "REVICNT");
	setLinkCol(mySheet, "RFQ_KEP_USER_NAME");
	setLinkCol(mySheet, "MSDS_NO");
	setLinkCol(mySheet, "CMS_CATLG_ID");
	setLinkCol(mySheet, "DELAY_REASON_IMG"); //견적지연 사유kep
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "STATUS"); //진행상태
	setLinkCol(mySheet, "ATOA_REMARK"); // 운영사비고
	setLinkCol(mySheet, "ATOB_REMARK"); // 고객사제출비고
	setLinkCol(mySheet, "AFTER_ITEM_CHG_REQ_DATE"); //추가정비 요청일시
	setLinkCol(mySheet, "AFTER_ITEM_MD_DATE"); //추가정비 제출일시
	setLinkCol(mySheet, "AFTER_ITEM_CHG_REQ_IMAGE_KEY_IMG"); //추가정비 첨부
	
	//PLANT담당자 콤보데이터 셋팅. 로그인한 사용자 부서살마만 나오게 변경.
	var st_user_dept = "<%=st_user_dept%>";
	kepAjaxCommonQueryIdSearchTwoCombo('st_plant_user_id','common.masterDepartmentUserList','',st_user_dept,'ALL','<%=st_smart_dept_yn.equals("Y") ? st_user_id : ""%>');
	
	mySheet.SetCellFontUnderline(0, "ATOB_REMARK", true);	
	mySheet.SetCellFontUnderline(0, "CANCEL_REMARK_IMG", true);
	mySheet.SetCellFontUnderline(0, "AFTER_ITEM_CHG_REQ_TYPE", true);
	mySheet.SetCellFontUnderline(0, "AFTER_ITEM_CHG_REQ_NOTE", true);
	
	mySheet.SetColProperty("AFTER_ITEM_CHG_REQ_TYPE", item_chg_req_type);
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("2","M"));
	$("#st_to_date").val( kepToMonthAdd("1","P"));
	
	
	
}
	
var st;
var mt;
var gubun = "";
var tbuyer = "";
var st_buyer = "";
var st_quotation_list = "";
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
			alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n3개월 이상의 데이타는 S/R 요청 바랍니다.");
			return;
		}
		//소싱부서가 아닐 경우 고객사코드 필수 값.
		if($("#st_sour_dept_yn").val() == "N"){
			if($("#st_buyer_code").val() == null||$("#st_buyer_code").val() == ""){
				alert("고객사은(는) 필수입력 항목입니다.");
				return;
			}
		}
		if(document.getElementById("st_exits_itemcheck").checked == true){
			 $("#st_exits_item").val('Y');		
		}else{
			 $("#st_exits_item").val('N');					
		}
		if(document.getElementById("st_req_itemcheck").checked == true){
			 $("#st_req_item").val('Y');		
		}else{
			 $("#st_req_item").val('N');					
		}
		if(document.getElementById("st_all_req_exce_check").checked == true){
			 $("#st_all_req_except").val('Y');		
		}else{
			 $("#st_all_req_except").val('N');					
		}
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mprq/getMasterMpRqCmpySelQuotationSendList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$('#st_buyer_code').val("");	
	
		kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','ALL2','${sessionInfo.userId}');
		// 조회조건 초기화
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		
		$("#st_from_date").val( kepToMonthAdd("2","M"));
		$("#st_to_date").val( kepToMonthAdd("1","P"));
		
		mySheet.RemoveAll();
		
		document.getElementById("st_req_itemcheck").checked = false;
		document.getElementById("st_all_req_exce_check").checked = false;
		
		break;

	case "nego": // 고객사 NEGO 견적제출
		gubun = "nego";
		var margin_val	= 0;
		var unit_price = 0;
		var list_price = 0;
		var status = mySheet.GetCellValue(arrRow[0], "SIGNAL");
		
		for (var i=0; i<arrRow.length; i++){
			var atob_unit_price    = mySheet.GetCellValue(arrRow[i],"ATOB_UNIT_PRICE");
			if(atob_unit_price == ""){
				alert("매출단가를 입력하여 주십시요");
				return;
			}
			
			if (status != mySheet.GetCellValue(arrRow[i], "SIGNAL")){
				alert("품목코드의 상태가 다릅니다.\n\n같은 상태의 품목코드를 선택후 고객사 견적제출 하여 주십시요.");
		        return;				
			}
			
	        if(mySheet.GetCellValue(arrRow[i], "SIGNAL") =="/resources/images/icon_r.gif") { // 기등록
	            alert("기등록 견적제출 버튼을 클릭하여 주십시요.");
	            return;
	        }

	        if(mySheet.GetCellValue(arrRow[i], "SIGNAL") == "/resources/images/icon_g.gif") { //신규
	            alert("신규품목은 고객사 견적제출 하여 주십시요.");
	            return;
	        }
	        unit_price = mySheet.GetCellValue(arrRow[i],"ATOB_UNIT_PRICE");
			list_price = mySheet.GetCellValue(arrRow[i],"STOA_LIST_PRICE");
	        margin_val = eval(unit_price)-eval(list_price);
	        if(mySheet.GetCellValue(arrRow[i], "RATE_FLAG") == "Y" || eval(margin_val)<=0 ) { //결재여부
	        	mySheet.SetCellValue(arrRow[i],"PM_FLAG","Y");
	        } else {
	        	mySheet.SetCellValue(arrRow[i],"PM_FLAG","N");
	        }
	        
			if(kepIsValueNull(unit_price)){
				alert("매출단가를 입력하여 주십시요");
				return;
			}
			
			if(!kepChkDecimal(unit_price,3)){
				alert("매출단가(숫자형식)를 입력하여 주십시요.");
				return;
			}
		}

		tbuyer = mySheet.GetCellValue(arrRow[0],"BUYER");
		
		if (!confirm('선택한 항목을 고객사 NEGO 견적제출 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mprq/negoMasterMpRqQuotationReceiptSendList.do" , "SELECTED" );
		break;
		
	case "save": // 고객사 견적제출
		gubun = "save";
		st_buyer = mySheet.GetCellValue(arrRow[0], "BUYER"); // 첫 행 고객사 저장
		var sessionUserId = document.searchCondition.st_user_id.value;
		for (var i=0; i<arrRow.length; i++){
			if(mySheet.GetCellValue(arrRow[i], "SIGNAL") == "/resources/images/icon_g.gif" && mySheet.GetCellValue(arrRow[i], "QUOT_SEND_BLOCK_FLAG") == "Y") { //신규견적 제출 제한(그룹카탈로그 전환 등 작업 시 사용)
	            alert("사업팀에 의해 해당 고객사의 신규견적은 제출 제한되었습니다.\n" + "(" + mySheet.GetCellValue(arrRow[i], "BUYER_NAME") + ")");
	            return;
	        }
			
			// 정비요청의 미제출건은 진행 불가
			if(mySheet.GetCellValue(arrRow[i],"AFTER_ITEM_MD_COMPLETE") != "Y"){
				alert(arrRow[i] + "번째  추가정비 요청 후 미제출건은 진행할 수 없습니다.");
				return;
			}
			
			// 견적담당자로 이관 된 건은 이관된 처리 담당자만 진행 가능.
			var job_transfer_id = mySheet.GetCellValue(arrRow[i], "JOB_TRANSFER_ID");
			if(job_transfer_id != ""){
				if(sessionUserId != job_transfer_id){
					alert("견적 이관건이므로 이관 된 담당자만 처리 가능 합니다");
					return;							
				}
			}
			// (1)	견적제출하기 위해서 먼저 협력사로부터 모든 견적이 회신되어야 하고, 
			// 마감시간이 지나 마감처리를 해야하며 협력사 선정 및 매출단가(ATOB_UNIT_PRICE)가 지정 되어야 한다.
			//표준카탈로그 필수여부 체크.
			if(mySheet.GetCellValue(arrRow[i], "MAP_YN") == "Y"){
				if(mySheet.GetCellValue(arrRow[i], "CMS_CATLG_ID") == ""){
					alert(arrRow[i] + "번째  표준카탈로그 매핑이되어야 견적제출 가능합니다.");
					return;
				}				
			}
			if(mySheet.GetCellValue(arrRow[i], "CMS_CATEG_ID") == ""){
				alert(arrRow[i] + "번째  표준카테고리 코드가 없습니다. 시스템팀에 확인바랍니다.");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i], "EARLY_END_FLAG") == "N" ){
				if (mySheet.GetCellValue(arrRow[i], "END_TIME_FLAG") == "N"){
					if (mySheet.GetCellValue(arrRow[i], "SEND_FLAG") == "N"){
						alert("협력사로 부터 모든 견적이 회신후 견적제출 가능합니다.");
	                    return;
					}
				}
			}
			if(mySheet.GetCellValue(arrRow[i], "ATOB_UNIT_PRICE") =="0"){
				alert(arrRow[i] + "번째 견적건은 매출단가 0원이므로 고객사 견적제출이 불가능 합니다.");
				mySheet.SelectCell(arrRow[i], "ATOB_UNIT_PRICE");
                return;				
			}
			
			// 지정협력사 체크
			if(mySheet.GetCellValue(arrRow[i], 'ASSIGN_AGENT_CODE') != ""){
				if(mySheet.GetCellValue(arrRow[i], 'ASSIGN_AGENT_CODE') != mySheet.GetCellValue(arrRow[i], 'AGENT')){
					alert(arrRow[i]+"번째 지정협력사로 제출하시기 바랍니다.");
					return;
				}	
			}
			
			// 네고단가 & 고객사제출비고 확인
			if(mySheet.GetCellValue(arrRow[i], "BTOA_NEGO_PRICE") != "0" && mySheet.GetCellValue(arrRow[i], "ATOB_REMARK") == ""){
				alert(arrRow[i] + "번째 견적건은 네고 제출건으로 고객사제출비고 입력이 필수입니다.");
				mySheet.SelectCell(arrRow[i], "ATOB_REMARK");
                return;				
			}
			
			if(mySheet.GetCellValue(arrRow[i], "REMARK_FLAG") == "Y" &&  mySheet.GetCellValue(arrRow[i], "ATOB_REMARK") == ""){
				alert("비고 필수 입력 후 제출 바랍니다.");
				mySheet.SelectCell(arrRow[i], "ATOB_REMARK");
                return;		
			}
			
			// 제출가능 단가 범위
			if(mySheet.GetCellValue(arrRow[i],"UNIT_PRICE_CHECK_FLAG") == "Y"){
				if(mySheet.GetCellValue(arrRow[i],"MIN_UNIT_PRICE") >= mySheet.GetCellValue(arrRow[i],"ATOB_UNIT_PRICE")){
					alert(arrRow[i]+"번째 고객사의 최저단가는 " + mySheet.GetCellValue(arrRow[i],"MIN_UNIT_PRICE") + " 원 이하 제출 불가합니다.");
					mySheet.SelectCell(arrRow[i], "ATOB_UNIT_PRICE");
					return;
				}
				if(mySheet.GetCellValue(arrRow[i],"MAX_UNIT_PRICE") <= mySheet.GetCellValue(arrRow[i],"ATOB_UNIT_PRICE")){
					alert(arrRow[i]+"번째 고객사의 최고단가는 " + mySheet.GetCellValue(arrRow[i],"MAX_UNIT_PRICE") + " 원 이상 제출 불가합니다.");
					mySheet.SelectCell(arrRow[i], "ATOB_UNIT_PRICE");
					return;
				}
			}
			
			if (kepIsValueNull(mySheet.GetCellValue(arrRow[i], "STOA_LIST_PRICE")) || kepIsValueNull(mySheet.GetCellValue(arrRow[i], "ATOB_UNIT_PRICE"))){
				alert("협력사 지정이 되지 않은 품목은 고객사 제출을 할수 없습니다.\n\n협력사 및 매출단가 지정후 견적제출 바랍니다.");
                return;
			}
			// 견적제출건들이 동일한 고객사인지 고객사네고요청건이 아닌지 체크	
			if (st_buyer != mySheet.GetCellValue(arrRow[i], "BUYER")){
				alert("동일한 고객사를 선택하여 고객사 견적제출(카탈로그 등록)을 하여 주십시요.");
		        return;				
			}
			
			// 해당 고객사는 견적번호별 일괄제출(ICOMCOD1.ALRE)
			if(mySheet.GetCellValue(arrRow[i], "ALL_RQDT_FLAG") == "Y"){
				var k=0;
				for (var j=0; j<arrRow.length; j++){
					if(mySheet.GetCellValue(arrRow[i], "QUOTATION_NO") == mySheet.GetCellValue(arrRow[j], "QUOTATION_NO")){
						k++;
					}
				}
				if(sessionUserId != "KEP2129072" && sessionUserId != "KEP2099019"){ // 장지은, 임태헌 프로 임시로 견적 건별로 제출되도록 권한 부여(피유코어)
					if(k != mySheet.GetCellValue(arrRow[i], "RQDT_CNT")){
						alert(arrRow[i] + "번째 견적번호 [" + mySheet.GetCellValue(arrRow[i], "QUOTATION_NO") + "]는 일괄 제출되어야 합니다.");
						return;
					}	
				}
			}
			
			if (mySheet.GetCellValue(arrRow[i], "MSDS_YN") == "1" && kepIsValueNull(mySheet.GetCellValue(arrRow[i], "MSDS_NO"))){
				alert(arrRow[i] + "번째는 MSDS 등록 및 매핑이 필요한 견적입니다.\n\nMSDS요청(협력사)로 진행하여 주십시요.");
		        return;
				
			}
			//TR일때 물류센터 공백 체크
			if (mySheet.GetCellValue(arrRow[i], "RQDT_PROCESS_TYPE") == "2" && kepIsValueNull(mySheet.GetCellValue(arrRow[i], "WAREHOUSE_CODE"))){
				alert(arrRow[i] + "번째 물류센터 지정이 필요합니다.");
		        return;
				
			}
			//카탈로그 삭제건 견적제출시 카탈로그 복원후 견적제출 되도록 로직 추가
			if(mySheet.GetCellValue(arrRow[i], "BYIT_STATUS") == "D"){
				alert(arrRow[i] + "번째  카탈로그 삭제상태 입니다.\n해당 품목 복원 후 견적 제출 바랍니다.");
				mySheet.SelectCell(arrRow[i], 'SELECTED', 1);
				return;				
			}
			
			// 지연사유 입력 필수 체크
			var delay_flag = mySheet.GetCellValue(arrRow[i],"DELAY_FLAG");
			var delay_reason_img = mySheet.GetCellValue(arrRow[i],"DELAY_REASON_IMG");
			
			if(delay_reason_img != "/resources/images/icon.gif" && delay_flag == "Y"){
				alert(arrRow[i] + "번째 견적번호 [" + mySheet.GetCellValue(arrRow[i], "QUOTATION_NO") + "] 견적지연사유를 입력해주세요.");
				mySheet.SelectCell(arrRow[i], 'DELAY_REASON_IMG', 1);
				return;
			}
			
			st_quotation_list += mySheet.GetCellValue(arrRow[i], "BUYER") + mySheet.GetCellValue(arrRow[i], "QUOTATION_NO") 
			+ mySheet.GetCellValue(arrRow[i], "QUOTATION_SEQ") + mySheet.GetCellValue(arrRow[i], "REVISION") +"@";
		}
		
		if (confirm('견적제출 하시겠습니까?')){			
			kepSave(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqCmpySelQuotationSendList.do" , "SELECTED" );
// 			location.href = "/mprq/showMasterMpRqBuyerQuotationSendPop.do?st_buyer="+st_buyer+"&st_quotation_list="+st_quotation_list+"&st_gubun=cmpy";
		}
		
		break;
		
	case "cancel": // 견적취소
		gubun = "cancel";
		
		for (var i=0; i<arrRow.length; i++){
			var CANCEL_REMARK = mySheet.GetCellValue(arrRow[i],"CANCEL_REMARK");
			var CANCEL_REMARK_CODE = mySheet.GetCellValue(arrRow[i],"CANCEL_REMARK_CODE");
			if(CANCEL_REMARK == "" && CANCEL_REMARK_CODE == ""){
				alert("견적 취소 사유를 입력하여 주십시요");
				return;
			}
		}
		if (!confirm('선택한 항목을 견적취소 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mprq/delMasterMpRqCmpySelQuotationSendList.do" , "SELECTED" );
		break;
	
	case "init": // 견적초기화
		gubun = "init";
		var buyer = mySheet.GetCellValue(arrRow[0],"BUYER");
		for(var i=0; i<arrRow.length; i++){
			if (buyer != mySheet.GetCellValue(arrRow[i],"BUYER")){
				alert("동일한 고객사별로 진행가능합니다.");
				return;
			}
		}	
		tbuyer = buyer;		
		if (!confirm('선택한 항목을 견적초기화 하시겠습니까?'))
			return;
		
		kepSave(document.searchCondition ,  mySheet , "/mprq/initNewMasterMpRqCmpySelQuotationSendList.do" , "SELECTED" );
		break;

	case "excelDown": // 엑셀다운로드
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
			alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n3개월 이상의 데이타는 S/R 요청 바랍니다.");
			return;
		}
		//소싱부서가 아닐 경우 고객사코드 필수 값.
		if($("#st_sour_dept_yn").val() == "N"){
			if($("#st_buyer_code").val() == null||$("#st_buyer_code").val() == ""){
				alert("고객사은(는) 필수입력 항목입니다.");
				return;
			}
		}
		
	    $("#pageflag").val('0');
		var param = {FileName:"업체선정및견적제출.xlsx",Merge:1,SheetDesign:1,DownCols:"BUYER_NAME|GUBUN|QUOTATION_NO|QUOTATION_SEQ|BUYER_ITEM_NO|STATUS|REVICNT|BTOA_DATE|BTOA_END_DT|DESCRIPTION|SPECIFICATION|MAKER_NAME|ORIGN_NAME|QUOTA_CNT|AGENT_NAME|BUYER_TARGET_PRICE|ATOB_UNIT_PRICE|BTOA_NEGO_PRICE|STOA_LIST_PRICE|RATE|ATOS_DATE|ATOS_END_DTRFQ_KEP_USER_NAME|RFQ_KEP_USER_NAME|BTOA_USER_NAME|ATOA_REMARK|ATOS_REMARK|UNIT_MEASURE|ITEM_QTY|PLANT|ADMIN_TARGET_PRICE|JOB_TRANSFER_NM|CMS_CATLG_ID|MAKER_PART_NO|MAKER_CODE|SOUR_MNG|PROCESS_TYPE|LEAD_TIME|MIN_ORDER_QTY|PUR_UNIT_QTY|PLANT_USER_NM|QTDT_ADD_USER_NM|DSM_MNG_NM|AFTER_ITEM_CHG_REQ_NM|AFTER_ITEM_CHG_REQ_DATE|AFTER_ITEM_CHG_REQ_NOTE"}; 
		kepDownExcel(document.searchCondition ,mySheet , "/mprq/excelMasterMpRqCmpySelQuotationSendList.do", param);
		$("#pageflag").val('1');
		break;
		
	case "msds":
		gubun = "msds";
		mySheet.SetColProperty("MSDS_YN",{KeyField:false});
		
		for(var i=0; i<arrRow.length; i++){
			if ("협력사선정완료" != mySheet.GetCellValue(arrRow[i],"STATUS")){
				alert("협력사선정완료된 견적만 요청 가능합니다.");
				return;
			}
		}
		
		if (!confirm('선택한 항목을 협력사에 MSDS 요청 하시겠습니까?\n현재 매핑된 MSDS_NO는 해제됩니다.'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqQuotationProceStateList2.do" , "SELECTED" );
		break;
	case "stoa":
		popupSel = "masterMpRqQuotationStoATimePop";
		// 파라미터는 수정 해야 함
		openSearchPopup("/mprq/showMasterMpRqQuotationStoATimePop.do","","420,150,no");
		break;
		
	case "round": //일괄 추가라운드 요청
		
		//선택한 건중에 추가라운드 불가능한 건이 있는지 체크하기
		for(var i=1; i<=mySheet.RowCount(); i++){
			if(mySheet.GetCellValue(i, "SELECTED") == 1){
				if (mySheet.GetCellValue(i, "SEND_FLAG") == "N" && mySheet.GetCellValue(i, "END_TIME_FLAG") == "N"){
					alert(i+"번째 견적건("+mySheet.GetCellValue(i, "QUOTATION_NO")+")은 추가라운드 요청이 불가능한 상태입니다.");
					return;
				}
				
				if(mySheet.GetCellValue(i, "AFTER_ITEM_MD_COMPLETE") != "Y"){
					alert(i + "번째  추가정비 요청 후 미제출건은 진행할 수 없습니다.");
					return;
				}
			}
		}
		
		popupSel = "masterMpRqQuotationSelectedRoundPop";
		
		openSearchPopup("/mprq/showMasterMpRqQuotationSelectedRoundPop.do","","620,200,no");
		break;
	case "mail":
		gubun = "mail";
		//선택한 건중에 추가라운드 불가능한 건이 있는지 체크하기
		for(var i=1; i<=mySheet.RowCount(); i++){
			if(mySheet.GetCellValue(i, "SELECTED") == 1){
				var quota_cnt = mySheet.GetCellValue(i, "QUOTA_CNT").split("/");
		        if(quota_cnt[0] == quota_cnt[1]){
					alert(i+"번째 견적건은 협력사에서 모두 견적 제출된 건이므로 메일발송이 불가능 합니다.");
					return;
		        }
			}
		}
		if (!confirm('선택한 항목을 협력사에게 견적요청 메일 전송 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqQuotationMailList.do" , "SELECTED" );
		break;
		
	case "after_item_chg_req":
		gubun = "after_item_chg";
		for(var i=0; i<arrRow.length;i++){
			var st_cms_reject_yn = mySheet.GetCellValue(arrRow[i],"AFTER_CMS_REJECT_YN");
			var st_item_md_date = mySheet.GetCellValue(arrRow[i],"AFTER_ITEM_MD_DATE");
			if(st_cms_reject_yn == "Y" && st_item_md_date == ""){
				alert("이미 추가정비 요청중인 견적건입니다.["+arrRow[i]+"번째]");
				return;
			}
			
			var st_req_note = mySheet.GetCellValue(arrRow[i],"AFTER_ITEM_CHG_REQ_TYPE");
			if(st_req_note.length == 0){
				alert("정비구분을 선택하여 주십시요.["+arrRow[i]+"번째]");
				mySheet.SelectCell(arrRow[i], "AFTER_ITEM_CHG_REQ_TYPE", 1, "");
				return;
			}
			
			var st_req_note = mySheet.GetCellValue(arrRow[i],"AFTER_ITEM_CHG_REQ_NOTE");
			if(st_req_note.length == 0){
				alert("요청사유를 입력하여 주십시요.["+arrRow[i]+"번째]");
				mySheet.SelectCell(arrRow[i], "AFTER_ITEM_CHG_REQ_NOTE", 1, "");
				return;
			}
		}
		//Confirm 처리 방식.
		g_confirm_type = "afterItemChgReq"; // Confirm 타입 선언
		$("#confirmMsgDiv").text("추가정비를 요청하시겠습니까?"); //Confirm 문구 입력
		$("#confirmAreaDiv").show(); //Confirm 창 확인.
		
		break;
	}
}

//Confirm창 확인처리
function confirmAreaDivSearch(){
	$("#confirmAreaDiv").hide();	
	if(g_confirm_type == "afterItemChgReq"){ //추가정비 요청
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow = selectedGrid.split("|");
		for(var i = 0; i<arrRow.length;i++){
			var st_req_note = mySheet.GetCellValue(arrRow[i],"AFTER_ITEM_CHG_REQ_NOTE");
			var st_req_id = $("#st_user_id").val();
			var st_req_image_key = mySheet.GetCellValue(arrRow[i],"AFTER_ITEM_CHG_REQ_IMAGE_KEY");
			mySheet.SetCellValue(arrRow[i], 'AFTER_CMS_REJECT_YN', "Y"); //추가정비 Y로 
			mySheet.SetCellValue(arrRow[i], 'AFTER_ITEM_CHG_REQ_ID', st_req_id);
			mySheet.SetCellValue(arrRow[i], 'AFTER_ITEM_CHG_REQ_NOTE', st_req_note);				
			mySheet.SetCellValue(arrRow[i], 'AFTER_ITEM_CHG_REQ_IMAGE_KEY', st_req_image_key);
		}
		kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqAfterItemChgReq.do" , "SELECTED" );
	}
}

function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
//     alert(downloadType + ' 다운이 완료되었습니다. \n 다운로드 결과 : ' + ((result==true)?'성공':'실패'));
}

function mySheet_OnSaveEnd(code, msg, stCode) {	
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	//msds정보 변경후 재조회.
	if(gubun =="msds"||gubun =="atos"||gubun =="round"||gubun =="mail"||gubun=="after_item_chg"||gubun=="init"){
		if (msg != "") {
			if(gubun == "init"){
				if(code != 0) {
					alert(msg.msg);	
				} else {
					alert(msg);					
				}					
			}else{
				alert(msg);	
			}
		}
		if(code>0){
			//저장 성공시 재조회
			doAction('search');
		}
	}else{
		if (msg.msg != "" && gubun != "save") {
			alert(msg.msg);
		}
		if (msg.msg != "" && gubun == "save" && code != 1) {
			if(code != 0) {
				alert(msg.msg);	
			} else {
				alert(msg);
			}
		}
		 
		if (gubun == "save" && code == 1) {
			location.href = "/mprq/showMasterMpRqBuyerQuotationSendPop.do?st_buyer="+st_buyer+"&st_quotation_list="+st_quotation_list+"&st_gubun=cmpy";
		}
		
		if(code == 1 && msg.usrmsg != "" && msg.usrmsg != "undefined" && msg.usrmsg != "N"){
			var type = "";
			if (gubun == "nego"){
				type = "SO";
			}
				openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg.usrmsg+'&PARAM1='+tbuyer, "1000,500,no");
		}
		if (gubun == "cancel"){
			doAction('search');
		}
	}
	gubun="";
}	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;
	
	for(var i=1; i<=totRow;i++){
		if (mySheet.GetCellValue(i, "BUYER_ITEM_NO_STATUS") != "신규"){
			mySheet.SetCellFontColor(i,"BUYER_ITEM_NO_STATUS","#FF0000");
		}
		if (mySheet.GetCellValue(i, "SEND_FLAG") == "Y" || mySheet.GetCellValue(i, "END_TIME_FLAG") == "Y"){
			mySheet.SetCellFontColor(i,"QUOTA_CNT","#0100FF");
// 			mySheet.SetCellFontUnderline(i,"QUOTA_CNT",1);
		}
		//SLOGIC-BEGIN(P04-4031-06)
// 		if (mySheet.GetCellValue(i, "CP_AGENT_OPEN_FLAG") == "N"){ // 협력사 공개 여부
		if (mySheet.GetCellValue(i, "BUYER") == "KRSSAN0025"){ // 협력사 공개 여부
			mySheet.SetCellEditable(i,"AGENT_OPEN_FLAG",0);
		} 
		//SLOGIC-END
		if (mySheet.GetCellValue(i, "RFQ_KEP_USER") != ""){ // 담당자
			mySheet.SetCellEditable(i,"RFQ_KEP_USER",0);
		} 
		if (mySheet.GetCellValue(i, "ITEM_GROUP") == "O"){ 
			mySheet.SetToolTipText(i, "RFQ_KEP_USER", "(사무자재:OPA팀) 담당자로 지정되어 있어 견적제출이 불가할 경우, 기획팀에 문의하세요.");
		} else {
			mySheet.SetToolTipText(i, "RFQ_KEP_USER", "(사무자재外 자재:사업팀) 담당자로 지정되어 있어 견적제출이 불가할 경우, 기획팀에 문의하세요.");
		}
		if (mySheet.GetCellValue(i, "END_TIME_FLAG") == "Y"){
			mySheet.SetCellFontColor(i,"ATOS_END_DT","#FF0000");
			mySheet.SetCellFontBold(i, "ATOS_END_DT",1);
		}
		if (!kepIsValueNull(mySheet.GetCellValue(i, "RATE"))){
			mySheet.SetCellValue(i,"RATE",mySheet.GetCellValue(i, "RATE")+"%");
		}
		
	}
   	
	if (msg != "") {
		alert(msg);
	}

}

function mySheet_OnMouseMove(Button, Shift, X, Y) { 
	var row = mySheet.MouseRow();
	var cellFont = mySheet.GetCellFontColor(row, "QUOTA_CNT");
	if(cellFont == "#0100ff") {
		mySheet.SetDataLinkMouse("QUOTA_CNT", true);
	} else {
		mySheet.SetDataLinkMouse("QUOTA_CNT", false);
	}
}

	
// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqCmpySelQuotationSendList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyerMulti": // 고객사 M
			openSearchPopup("/none/showCommonNoNeBuyerChoiceMultiPop.do","?search_opt=2&disable_yn=Y",'1000,500,no')
			popupSel = "buyerMulti";
			break;
		case "masterMpRqBuyerQuotationReceiptSendCntPop": // 고객사 M
			openSearchPopup('/mprq/showMasterMpRqBuyerQuotationReceiptSendCntPop.do','?buyer_flag=2','500,350,no'); // buyer_flag = 1(두중)
			popupSel = "masterMpRqBuyerQuotationReceiptSendCntPop";
			break;
		case "sg_info"://SG정보
			openSearchPopup("/mprq/showMasterMpRqSgChoicePop.do", "", "500,500,no");
			break;
		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=0000007zl&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
		case "afterItemChgSend": // 추가정비제출
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow     = selectedGrid.split("|");
			// 선택된 항목 유무 체크
			if (selectedGrid.length == 0) {
				alert("선택된 항목이 없습니다.");
				return;
			}
			for(var i=0; i<arrRow.length;i++){
				var st_cms_reject_flag = mySheet.GetCellValue(arrRow[i],"AFTER_CMS_REJECT_YN");
				if(st_cms_reject_flag != "Y"){
					alert("추가정비 요청 먼저 해주시기 바랍니다.["+arrRow[i]+"번째]");
					return;
				}
				
				var st_sg_d_flag = mySheet.GetCellValue(arrRow[i],"AFTER_ITEM_MD_DATE");
				if(st_sg_d_flag != ""){
					alert("추가정비 제출 된 상태입니다.["+arrRow[i]+"번째]");
					return;
				}
			}
			openSearchPopup("/common/remarkReturn2Pop.do", "?st_gubun=AFTERITEMCHG", "600,230,no");
			break;
			
		case "buyercatalog": // 고객사카탈로그조회
			openSearchPopup("/coco/showCommonCoCoCatalogAlterPop.do", "", "1000,600,no");
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	var buyer = mySheet.GetCellValue(Row, "BUYER");
	var buyer_name = mySheet.GetCellValue(Row, "BUYER_NAME");
	var quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
	var quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
	var revision = mySheet.GetCellValue(Row, "REVISION");
	var agent = mySheet.GetCellValue(Row,"AGENT");
	var openflag ="N";
	if(mySheet.GetCellValue(Row,"AGENT_OPEN_FLAG")== "1"){
		openflag = "Y";
	}
	
	if (column == 'BTOA_USER_NAME') { // 요청자
		var ID = mySheet.GetCellValue(Row,"BTOA_USER_ID");
		if (ID == ""){
			alert("요청자ID 정보가 없습니다.");
			return;
		}
		openSearchPopup("/common/userDisplayPop.do", '?user_id='+ID, "800,500,no");
	} else if (column == 'BUYER_NAME') {
			//고객사 정보 팝업 호출
		openSearchPopup("/mdct/showMasterMdCtBuyerJoinAlterRequestApprovalPop.do", "?com_code="+buyer,  "900,700,no");
	} else if (column == 'STATUS') {
		// 협력사별 견적요청서 양식출력 팝업
		openSearchPopup('/mprq/showMasterMpRqSellerQuotationRequestFormPop.do','?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_quotation_seq='+quotation_seq+'&st_revision='+revision,'500,350,no');// 견적상세
	} else if (column == 'PRINT') { // 출력물
		if(kepIsValueNull(agent)){
			alert("협력사 선정이 되지 않았습니다.\n\n 협력사 선정후 견적서 출력 할수 있습니다.");
			return;
		}
		//SLOGIC-BEGIN(P04-4039-01)
		openflag = "N";
		var param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+agent+"]["+openflag+"]";
		// 협력사 선정 이후 견적서 출력 가능
		if (mySheet.GetCellValue(Row,"STATUS") == "협력사선정완료"){
			if(buyer=="KRDOOS0015"||buyer=="KRHWAS0031"||buyer=="KRSSAN0025"||buyer=="KRSSAN0028") {
				var fileName = "RD_04_M_004_09";//"RD_04_M_004_03";
				reportOpen(fileName,param);
				return;	
			}else {
				var fileName = "RD_04_M_003_03";
				reportOpen(fileName,param);
				return;	
			}
		}
		//SLOGIC-END
	} else if (column == 'BUYER_ITEM_NO') { // 품목코드
		if (mySheet.GetCellValue(Row,"SIGNAL") == "/resources/images/icon_r.gif"){ // 기등록일 때만
			var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
			openSearchPopup('/common/mprq/masterMpRqContractLisPop.do','?st_buyer='+buyer+'&st_buyer_item_no='+buyerItemNo,'800,300,no');
		}else{
			alert("기등록건만 계약정보 조회 가능 합니다.");
			return;
		}
	} else if (column == "QUOTATION_NO" ){ 
		popupSel = "quotationReDetailPop";
		openSearchPopup("/common/mprq/quotationReDetailPop.do", '?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_revision='+revision+'&viewflag=HANDOUT', "1020,500,no");

	} else if (column == 'AGENT_NAME') { // 협력사
		if (agent != ""){
			openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
		}
		
	} else if (column == "STOA_REMARK_IMG" ){ 
		
		var st_popup_url = "/common/remarkBASPop.do";
		var st_popup_param = "st_type@@SOUR^||^st_btoa_remark@@"+ mySheet.GetCellValue(Row, "BTOA_REMARK") +"^||^st_atos_remark@@"+  mySheet.GetCellValue(Row, "ATOS_REMARK")
					+"^||^st_stoa_remark@@"+mySheet.GetCellValue(Row, "STOA_REMARK")+"^||^st_atob_remark@@"+mySheet.GetCellValue(Row, "ATOB_REMARK")
					+"^||^st_buyer@@"+mySheet.GetCellValue(Row, "BUYER")+"^||^st_quotation_no@@"+mySheet.GetCellValue(Row, "QUOTATION_NO")+"^||^st_quotation_seq@@"+mySheet.GetCellValue(Row, "QUOTATION_SEQ")
					+"^||^st_revision@@"+mySheet.GetCellValue(Row, "REVISION");
		var st_popup_option = "1000,730,no";
		
		openSearchPopupAppendPost("remarkBASPopForm",st_popup_url,st_popup_param,st_popup_option);// 고객사 비고
		
	} else if(column == "CANCEL_REMARK_IMG"){
		popupSel = "cancelRemark";
		var viewType="kepRfqCancel";
		var cancel_remark = mySheet.GetCellValue(Row, "CANCEL_REMARK");
		var cancel_remark_code = mySheet.GetCellValue(Row, "CANCEL_REMARK_CODE");
		openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType+'&cancel_remark_code='+cancel_remark_code,"500,320,no");
	} else if(column == "RFQ_KEP_USER_NAME"){ // 담당자
// 		if (mySheet.GetCellValue(Row,"RFQ_KEP_USER") != ""){
// 			return;
// 		}
		popupSel = "masterMpRqReqUserSelPop";
		var itemGroup = mySheet.GetCellValue(Row, "ITEM_GROUP");
		var dept = '${sessionInfo.department}';
		var agentMinPrice = mySheet.GetCellValue(Row, "AGENT_MIN_PRICE");
		openSearchPopup("/mprq/showMasterMpRqReqUserSelPop.do",'?st_buyer='+buyer+'&st_item_group='+itemGroup+'&st_kep_dept='+dept+'&st_agent_min_price='+agentMinPrice,"400,350,no");
		
	} else if(column == "QUOTA_CNT"){ // 견적건수
		//특정고객사만 조기 마감 가능하도록 변경
		if(mySheet.GetCellValue(Row,"EARLY_END_FLAG") == "N"  ){
			if (mySheet.GetCellValue(Row,"END_TIME_FLAG") == "N" && mySheet.GetCellValue(Row,"SEND_FLAG") == "N"){
				return;
			}
		}
	
		// 해당품목의 담당자 확인
		// 협력사 선정 팝업
		//SLOGIC-BEGIN(P04-4031-05)
		
		var rfq_kep_user = mySheet.GetCellValue(Row,"DUTY_KEP"); 

		/*
		if (kepIsValueNull(mySheet.GetCellValue(Row,"RFQ_KEP_USER"))){
			rfq_kep_user = mySheet.GetCellValue(Row,"DUTY_KEP");
		}
		*/
		
		/*견적진행구분이 사업부일경우만 진행가능. 
		진행구분이 전략소싱팀일경우 해당 SG담당자만 입력 가능*/
		var sg_kep_yn = mySheet.GetCellValue(Row,"SG_KEP_YN");
		var sg_gbn_org = mySheet.GetCellValue(Row,"SG_GBN");
		var sg_gbn = "";
		var st_sour_dept_yn = $("#st_sour_dept_yn").val();
		if(sg_gbn_org =="전략소싱팀"){
			sg_gbn = "SO";
		}else{
			sg_gbn = "PM";
		}
		
		// 구매부서는 담당자 여부 따지지 않음. 사업팀은 담당자 지정된 사람만 가능
		if(st_sour_dept_yn == "N"){
			if (rfq_kep_user.indexOf('${sessionInfo.userId}') == -1){
				if(sg_kep_yn == "N"){
					alert("해당 견적건에 대한 담당자가 아닙니다.");
					return;
				}
			}			
		}
		var sessionUserId = document.searchCondition.st_user_id.value;
		// 견적담당자로 이관 된 건은 이관된 처리 담당자만 진행 가능.
		var job_transfer_id = mySheet.GetCellValue(Row, "JOB_TRANSFER_ID");
		if(job_transfer_id != ""){
			if(sessionUserId != job_transfer_id){
				alert("견적 이관건이므로 이관 된 담당자만 처리 가능 합니다");
				return;							
			}
		}
		popupSel = "masterMpRqSellerChoice3Pop";
		var end_time_flag = mySheet.GetCellValue(Row, "END_TIME_FLAG");
		var rcv_agent_flag = mySheet.GetCellValue(Row, "SEND_FLAG");
		var sg_id = mySheet.GetCellValue(Row, "SG_ID");
		
		//업체선정시 구매팀전담 담당자와 구매팀 sg담당자 동일하게 업체선정 팝업에서 시스템 기능 이용 가능.
		var st_pur_sour_yn = "";
		if($("#st_sour_dept_yn").val() == "Y" || $("#st_mro_dept_yn").val() == "Y"){ // 구매팀 + 일반 사업팀(SMART팀 제외)
			st_pur_sour_yn = "Y";	
		}else{
			st_pur_sour_yn = "N";
		}
		
		openSearchPopup("/mprq/showMasterMpRqSellerChoice3Pop.do",'?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_quotation_seq='+quotation_seq+'&st_revision='+revision+'&st_end_time_flag='+end_time_flag+'&st_rcv_agent_flag='+rcv_agent_flag+'&st_sg_id='+sg_id+'&st_rfq_kep_user='+'${sessionInfo.userId}'+'&st_sg_kep_yn='+sg_kep_yn+'&st_sg_gbn='+sg_gbn+'&st_sour_dept_yn='+st_pur_sour_yn,"1520,800,no");	
		//SLOGIC-END
	} else if(column == "REVICNT"){ // 차수
		popupSel = "masterMpRqQuotationUnitpriceHistoryPop";
		openSearchPopup("/mprq/showMasterMpRqQuotationUnitpriceHistoryPop.do", '?st_buyer='+buyer+'&st_buyer_name='+buyer_name+'&st_quotation_no='+quotation_no+'&st_quotation_seq='+quotation_seq+'&st_revision='+revision, "900,600,no");
	} else if(column == "MSDS_NO"){ // MSDS 정보확인
		popupSel = "msdsregmapPop"; 
		
		var msds_no = mySheet.GetCellValue(Row, "MSDS_NO");

		if(kepIsValueNull(msds_no)){
		} else {
		    openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+msds_no+"&st_btn_yn=Y",'750,580,no');
	    }
		
	} else if (column == "CMS_CATLG_ID" ){ 

		popupSel = "stndCatlg";
		
		var desc = mySheet.GetCellValue(Row,"DESCRIPTION"); // 품목명
		var spec = mySheet.GetCellValue(Row,"SPECIFICATION"); // 규격
		var maker = mySheet.GetCellValue(Row,"MAKER_NAME"); // 제조사명
		var model = mySheet.GetCellValue(Row,"MAKER_PART_NO"); // 모델번호
		var row_num = Row;
			
		var new_popup = window.open('','categ','scrollbars=no,width=1000,height=600,resizable=no');
	    document.catlgFlow.action = "/mprq/showMasterMpRqCmsCatlgRcmdPop.do";
	    document.catlgFlow.target = "categ";
	    document.catlgFlow.method = "post";
	    
	    document.catlgFlow.catlg_desc_flow.value = escape(desc);
	    document.catlgFlow.catlg_spec_flow.value = escape(spec);
	    document.catlgFlow.catlg_maker_flow.value = escape(maker);
	    document.catlgFlow.catlg_model_flow.value = escape(model);
	    document.catlgFlow.catlg_row_num.value = escape(row_num);
	    
		// 견적은 표준카탈로그 선택 후 바로 표준카탈로그ID, 이미지 저장 - 견적정보 전송
	    document.catlgFlow.catlg_buyer.value = mySheet.GetCellValue(Row, "BUYER");
	    document.catlgFlow.catlg_quotation_no.value = mySheet.GetCellValue(Row, "QUOTATION_NO");
	    document.catlgFlow.catlg_quotation_seq.value = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
	    document.catlgFlow.catlg_revision.value = mySheet.GetCellValue(Row, "REVISION");
	    
	    document.catlgFlow.submit();
	    new_popup.focus();
	}else if(column == "DELAY_REASON_IMG" ){
 			var st_buyer = mySheet.GetCellValue(Row,"BUYER");
 			var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
 			var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
 			var st_revision = mySheet.GetCellValue(Row,"REVISION");
 			var st_mail_flag =  mySheet.GetCellValue(Row,"DELAY_SEND_MAIL_FLAG");
 			var st_modify = "";
 			if(st_mail_flag=="Y"){
 				st_modify = "N";
 			}else{
 				st_modify = "Y";
 			}
 			openSearchPopup('/mpiv/getMasterMpIvQuotationSendDelayReasonPop.jsp.do','?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_modify='+st_modify,'550,350,no');

 			return;
	} else if (column == "ATOA_REMARK" ){ 
		popupSel = "remarkAtoAPop";
		var st_buyer = mySheet.GetCellValue(Row, "BUYER");
		var st_quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
		var st_quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
		var st_revision = mySheet.GetCellValue(Row, "REVISION");
		var st_atoa_remark = mySheet.GetCellValue(Row, "ATOA_REMARK");
		openSearchPopup("/common/remarkAtoAPop.do",'?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_atoa_remark='+st_atoa_remark,"500,200,no");// 운영사비고
	} else if (column == "ATOB_REMARK" ){
		popupSel = "remarkAtoBPop";
		var st_form_name = "remarkAtoBPopForm";
		var st_popup_url = "/mprq/remarkAtoB2Pop.do";
		var st_popup_param = "st_buyer@@"+mySheet.GetCellValue(Row, "BUYER")+"^||^"+"st_quotation_no@@"+mySheet.GetCellValue(Row, "QUOTATION_NO")+"^||^"+"st_quotation_seq@@"+mySheet.GetCellValue(Row, "QUOTATION_SEQ")+"^||^"+"st_revision@@"+mySheet.GetCellValue(Row, "REVISION")+"^||^"+"st_atob_remark@@"+mySheet.GetCellValue(Row, "ATOB_REMARK");
		var st_popup_option = "500,450,no";
		//post 팝업 호출
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);		
	} else if (column == "AFTER_ITEM_CHG_REQ_DATE" ){ //  추가정비 이력팝업
		popupSel = "afterItemChgRegDatePop";
		var st_buyer = mySheet.GetCellValue(Row,"BUYER");
		var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
		var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
		var st_revision = mySheet.GetCellValue(Row,"REVISION");
		openSearchPopup("/mprq/showMasterMpRqAfterItemMdReqHistPop.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "840,300,no");
	}  else if (column == "AFTER_ITEM_MD_DATE" ){ //  추가정비 이력팝업
		popupSel = "afterItemChgRegDatePop";
		var st_buyer = mySheet.GetCellValue(Row,"BUYER");
		var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
		var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
		var st_revision = mySheet.GetCellValue(Row,"REVISION");
		openSearchPopup("/mprq/showMasterMpRqAfterItemMdReqHistPop.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "840,300,no");
	} else if(column == "NOTE_MNG_IMG" ){ //특이사항 입력
		var st_buyer = mySheet.GetCellValue(Row,"BUYER");
		var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
		var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
		var st_revision = mySheet.GetCellValue(Row,"REVISION");
		openSearchPopup("/mprq/showMasterMpRqQutationRemark.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "850,350,no");
	} else if(column == "AFTER_ITEM_CHG_REQ_IMAGE_KEY_IMG"){
		popupSel = "afterItemChgReqfileUpload";
		var type="RFQ";
		var viewType="VI";
		var image_key=mySheet.GetCellValue(Row, "AFTER_ITEM_CHG_REQ_IMAGE_KEY");
		var st_after_cms_reject_yn = mySheet.GetCellValue(Row,"AFTER_CMS_REJECT_YN");
		var st_req_user_id = mySheet.GetCellValue(Row,"AFTER_ITEM_CHG_REQ_ID");
		var st_after_item_md_date = mySheet.GetCellValue(Row,"AFTER_ITEM_MD_DATE");
		
		// 정비요청 이력 있고, 정비제출일시 비었고 --> 정비요청 중
		if(st_after_cms_reject_yn == "Y" && st_after_item_md_date == ""){
			viewType = "R";
		}
		
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}
	
	return;
}
//헤더 더블클릭시 복사
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	
	if (mySheet.ColSaveName(Col) == "ATOB_REMARK" || mySheet.ColSaveName(Col) == "CANCEL_REMARK_IMG" || mySheet.ColSaveName(Col) == "AFTER_ITEM_CHG_REQ_TYPE" || mySheet.ColSaveName(Col) == "AFTER_ITEM_CHG_REQ_NOTE"){
		var checkRows = mySheet.FindCheckedRow("SELECTED");
		if (checkRows.length == 0){
			alert("복사할 행을 선택하여 주십시요.");
			return;
		}
		var arrRow = checkRows.split("|");
		
		if (mySheet.ColSaveName(Col) == "ATOB_REMARK"){ // 고객사제출비고
			var value1 = mySheet.GetCellValue(arrRow[0], "ATOB_REMARK");
			if(kepIsValueNull(value1)){
				alert("복사할 비고를 입력하여 주십시요.");
				return;
			}
			for(var idx=0; idx<arrRow.length; idx++){
				mySheet.SetCellValue(arrRow[idx], "ATOB_REMARK", value1);
				mySheet.SetCellValue(arrRow[idx], "STOA_REMARK_IMG", (value1!="")? remarkOn : remarkOff);
			}
			alert("현재 복사된 고객사제출비고는 저장되지 않았으니 고객사 견적제출 전 확인하시기 바랍니다.");
		} else if (mySheet.ColSaveName(Col) == "CANCEL_REMARK_IMG"){ // 견적취소
			var value1 = mySheet.GetCellValue(arrRow[0], "CANCEL_REMARK");
			var value2 = mySheet.GetCellValue(arrRow[0], "CANCEL_REMARK_CODE");
			if(kepIsValueNull(value1) && kepIsValueNull(value2)){
				alert("복사할 견적 취소사유를 입력하여 주십시요.");
				return;
			}
			for(var idx=0; idx<arrRow.length; idx++){
				mySheet.SetCellValue(arrRow[idx], "CANCEL_REMARK", value1);
				mySheet.SetCellValue(arrRow[idx], "CANCEL_REMARK_CODE", value2);
				mySheet.SetCellValue(arrRow[idx], "CANCEL_REMARK_IMG", (value1!="")? remarkOn : remarkOff);
			}
		} else if (mySheet.ColSaveName(Col) == "AFTER_ITEM_CHG_REQ_TYPE"){ // 정비구분
			var value1 = mySheet.GetCellValue(arrRow[0], "AFTER_ITEM_CHG_REQ_TYPE");
			for(var idx=0; idx<arrRow.length; idx++){
				mySheet.SetCellValue(arrRow[idx], "AFTER_ITEM_CHG_REQ_TYPE", value1);
			}
		} else if (mySheet.ColSaveName(Col) == "AFTER_ITEM_CHG_REQ_NOTE"){ // 추가정비요청사유
			var value1 = mySheet.GetCellValue(arrRow[0], "AFTER_ITEM_CHG_REQ_NOTE");
			if(kepIsValueNull(value1)){
				alert("복사할 요청사유를 입력하여 주십시요.");
				return;
			}
			for(var idx=0; idx<arrRow.length; idx++){
				mySheet.SetCellValue(arrRow[idx], "AFTER_ITEM_CHG_REQ_NOTE", value1);
			}
		}
	} else {
		return;
	}
}	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyerMulti") {	// 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	
	} else if (popupSel == "masterMpRqBuyerQuotationReceiptSendCntPop") {	// 고객사 견적접수 및 제출 건수
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	
	} else if (popupSel == "constractNo") {	// 품목코드
		mySheet.SetCellValue(grbRow, 'CONTRACT_NO', value1);
		mySheet.SetCellValue(grbRow, 'CONTRACT_SEQ', value2);
	
	}else if(popupSel == "remarkBAS") {	//고객사 비고
		mySheet.SetCellValue(grbRow, 'ATOB_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'STOA_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
	
	}else if(popupSel == "cancelRemark") {	//견적 취소
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK_IMG', (value2!="")? remarkOn : remarkOff);
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK_CODE', value2);

	}else if(popupSel == "masterMpRqReqUserSelPop") {
		mySheet.SetCellValue(grbRow, 'RFQ_KEP_USER', value1);
		mySheet.SetCellValue(grbRow, 'RFQ_KEP_USER_NAME', value2);
			
	} else if (popupSel == "stndCatlg"){ // 표준카탈로그코드
		
		if(value1 == "manual"){ // 직접선택 시 표준카탈로그조회 팝업
			var st_buyer = mySheet.GetCellValue(grbRow, "BUYER");
			var st_quotation_no = mySheet.GetCellValue(grbRow, "QUOTATION_NO");
			var st_quotation_seq = mySheet.GetCellValue(grbRow, "QUOTATION_SEQ");
			var st_revision = mySheet.GetCellValue(grbRow, "REVISION");
			this.focus();

			openSearchPopup("/mprq/showMasterMpRqStndCatalgListPop.do","?st_buyer="+st_buyer+"&st_quotation_no="+st_quotation_no+"&st_quotation_seq="+st_quotation_seq+"&st_revision="+st_revision+"&st_type=RCMD&st_row_no="+value2,"900,800,no");
		}else if(value1 == "rcmd"){
			popupSel = "stndCatlg";
			var desc = mySheet.GetCellValue(value2,"DESCRIPTION"); // 품목명
 			var spec = mySheet.GetCellValue(value2,"SPECIFICATION"); // 규격
 			var maker = mySheet.GetCellValue(value2,"MAKER_NAME"); // 제조사명
 			var model = mySheet.GetCellValue(value2,"MAKER_PART_NO"); // 모델번호
 			var row_num = value2;
			var new_popup = window.open('','categ','scrollbars=no,width=1000,height=600,resizable=no');
		    document.catlgFlow.action = "/mprq/showMasterMpRqCmsCatlgRcmdPop.do";
		    document.catlgFlow.target = "categ";
		    document.catlgFlow.method = "post";
		    document.catlgFlow.catlg_desc_flow.value = escape(desc);
		    document.catlgFlow.catlg_spec_flow.value = escape(spec);
		    document.catlgFlow.catlg_maker_flow.value = escape(maker);
		    document.catlgFlow.catlg_model_flow.value = escape(model);
		    document.catlgFlow.catlg_row_num.value = escape(row_num);
			// 견적은 표준카탈로그 선택 후 바로 표준카탈로그ID, 이미지 저장 - 견적정보 전송
			var st_buyer = mySheet.GetCellValue(value2, "BUYER");
			var st_quotation_no = mySheet.GetCellValue(value2, "QUOTATION_NO");
			var st_quotation_seq = mySheet.GetCellValue(value2, "QUOTATION_SEQ");
			var st_revision = mySheet.GetCellValue(value2, "REVISION");
			
		    document.catlgFlow.catlg_buyer.value = st_buyer;
		    document.catlgFlow.catlg_quotation_no.value = st_quotation_no;
		    document.catlgFlow.catlg_quotation_seq.value = st_quotation_seq;
		    document.catlgFlow.catlg_revision.value = st_revision;
		    
		    document.catlgFlow.submit();
		    new_popup.focus();
		}else if(value3 == "DQCAT02"){
			mySheet.SetCellValue(value2, 'CMS_CATLG_ID', value1);
			mySheet.SetCellValue(value2, 'CATALOG_CHOICE_TYPE', value3);
		}else if(value3 == "OFFCATE"){
			mySheet.SetCellValue(value2, 'CMS_CATLG_ID', value1);
			mySheet.SetCellValue(value2, 'CATALOG_CHOICE_TYPE', value3);
		}
	} else if(popupSel=="sg_info"){
		$("#st_c_sg_id").val(value1);
		$("#st_c_sg_nm").val(value2);
	} else if(popupSel=="masterMpRqQuotationStoATimePop"){
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");
		var atosDate = "";
		var toBe_atosDate = value1+value2;
		for(var i=0; i<arrRow.length; i++){
			atosDate =  mySheet.GetCellValue(arrRow[i],"ATOS_END_DATE");
			var st_buyer =  mySheet.GetCellValue(arrRow[i],"BUYER_NAME");
			var st_qutation_no = mySheet.GetCellValue(arrRow[i],"QUOTATION_NO");
			//견적마감 시간 도래건은 변경 불가 로직 추가. Y면 수정가능. N이면 수정불가.
			if(mySheet.GetCellValue(arrRow[i],"EXTEND_FLAG") != "Y"){
				alert(st_buyer+"("+st_qutation_no+")건  견적마감 시간이 도래한 견적건은 연장 불가능 합니다.");
				return;				
			}
			if(mySheet.GetCellValue(arrRow[i],"ADMIN_CLOSE_FLAG") == "Y"){
				alert(st_buyer+"("+st_qutation_no+")건  조기마감건은 견적마감 시간 연장 불가능 합니다.");
				return;				
			}
			if(atosDate > toBe_atosDate){
				alert(st_buyer+"("+st_qutation_no+")건 견적마감 시간 연장 대상건이 아닙니다.");
				return;
			}
			mySheet.SetCellValue(arrRow[i], 'TO_ATOS_END_DATE', value1);
			mySheet.SetCellValue(arrRow[i], 'TO_ATOS_END_TIME', value2);
		}
		gubun = "atos";
		kepSave(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqQuotationAtoSDate.do" , "SELECTED" );
	} else if(popupSel=="masterMpRqQuotationSelectedRoundPop"){
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");
		for(var i=0; i<arrRow.length; i++){
			mySheet.SetCellValue(arrRow[i], 'TO_ATOS_END_DATE', value1);
			mySheet.SetCellValue(arrRow[i], 'TO_ATOS_END_TIME', value2);
			mySheet.SetCellValue(arrRow[i], 'ATOS_REMARK', value3);
		}
		gubun = "round";
		kepSave(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqQuotationSelectedRound.do" , "SELECTED" );
	} else if(popupSel == "remarkAtoAPop") {	//운영사 비고
		mySheet.SetCellValue(grbRow, 'ATOA_REMARK', value1);
	} else if(popupSel == "remarkAtoBPop") {	// 고객사 제출비고
		mySheet.SetCellValue(grbRow, 'ATOB_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'STOA_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
	} else if(popupSel == "afterItemChgReqfileUpload") {	//추가정비 첨부
		mySheet.SetCellValue(grbRow, 'AFTER_ITEM_CHG_REQ_IMAGE_KEY', value1);
		mySheet.SetCellValue(grbRow, 'AFTER_ITEM_CHG_REQ_IMAGE_KEY_IMG', (value2=='on')? diskOn : diskOff);

	}
	grbRow="";	//초기화
}
function kepApprovalReturn(flag,docu_no){
	doAction('search');
}
function getBuyerSgInfo(row) {  
	   var strComcode = "KRKORE0001";
	   var strType = "SGC";
		var strBuyer =mySheet.GetCellValue(row, "BUYER");
		var rtnData = "";
		$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: "/mdcm/getBuyerSgInfo.do",
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: { param1: strComcode,param2: strType,param3:strBuyer},
		     async : false,
		     success:function( response ) {  		    	  
		    	 	 		    	  
	    	 	if (response.data.length > 0){
	 		    	  for (var i=0; i<response.data.length; i++){ 
	 		    		  
	 		    		rtnData = $.trim(eval("response.data["+i+"].CATE_DATA_YN")); 
		 		      }	 		    
	    		  }
			      },
			 error:function( response ) {  		    	   
		    	 alert("오류발생하였습니다.");
			      }
	    });  
		return rtnData;
	}

//추가정비제출 저장
function setAfterItemChgPopupReturn(val){
	gubun = "after_item_chg";
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	var st_admin_remark = "[추가정비제출] "+val;
	
	for (var i=0; i<arrRow.length; i++){
		mySheet.SetCellValue(arrRow[i],"ADMIN_REMARK",st_admin_remark);
	}

	kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqAfterItmCheSend.do" , "SELECTED" );
}

//견적지연사유 팝업 리턴
function setDelayPopupReturn(){
	mySheet.SetCellValue(grbRow, 'DELAY_REASON_IMG', 9);
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>업체선정 및 견적제출</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
		    <span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
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
			<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
			<input type="hidden" name="st_sour_dept_yn"  id="st_sour_dept_yn" value ="<%=st_sour_dept_yn%>">
			<input type="hidden" name="st_exits_item" id="st_exits_item" value ="">
            <input type="hidden" name="st_req_item" id="st_req_item" value ="">
            <input type="hidden" name="st_all_req_except" id="st_all_req_except" value ="">
            <input type="hidden" name="st_smart_dept_yn" id="st_smart_dept_yn" value ="<%=st_smart_dept_yn%>">
            <input type="hidden" name="st_mro_dept_yn"  id="st_mro_dept_yn" value ="<%=st_mro_dept_yn%>">            
            
            	<table  class="cont_t_list01" >
					<caption>업체선정 및 견적제출</caption>
					<colgroup>
						<col width="10%" />
						<col width="15%" />
						<col width="7%" />
						<col width="12%" />
						<col width="8%" />
                        <col width="21" />
                        <col width="11%" />
                        <col width="16%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>
								<select name = "st_date_type" id="st_date_type" style="width:80%;height:20px">
						      		<option value="REQ" selected="selected">견적의뢰일</option>
						      		<option value="RES">회신요청일</option>
	                           </select>
							</th>
							<td colspan="3">
								<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								-
								<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
							</td>
							
							<th><font color="#FF6600">*</font>고객사</th>
							<td>
								<input type="text" name="st_buyer_name" id="st_buyer_name" style="width:65%" value="" readonly onclick="javascript:doPop('buyerMulti');">
								<input type=hidden name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('masterMpRqBuyerQuotationReceiptSendCntPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							
							<th>견적번호</th>
							<td>
								<input type="text" id="st_quotation_no" name="st_quotation_no" style="width:87%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
							</td>
						</tr>
						
						<tr> 
							<th>PLANT담당자</th>
							<td>
								<select id="st_plant_user_id" name="st_plant_user_id" style="width:80%;height:20px"></select>
							</td>
							
							<th><font color="#FF6600">*</font>담당자</th>
							<td>
								<select id="st_kep_user_id" name="st_kep_user_id" style="width:90%;height:20px" required="담당자" ></select>
							</td>
							
							<th>품목코드</th>
							<td>
								<input type="text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:87%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
							</td>
							
							<th>요청자</th>
							<td>
								<input type="text" id="st_btoa_user_name" name="st_btoa_user_name" style="width:87%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
							</td>
						</tr>
						
						<tr>
							<th>견적담당자</th>
							<td>
								<select id="st_job_transfer_id" name="st_job_transfer_id" style="width:80%;height:20px"></select>
							</td>
							
							<th>상태</th>
							<td>
								<select id="st_status" name="st_status" style="width:90%;height:20px" >
									<option value="" selected>전체</option>
									<option value="협력사견적요청">협력사견적요청</option>
									<option value="협력사재견적요청">협력사재견적요청</option>
									<option value="협력사선정완료">협력사선정완료</option>
								</select>
							</td>
							
							<th>품목명/규격</th>
							<td>
								<input type="text" id="st_desc_spec" name="st_desc_spec" style="width:87%;" value="" onkeydown="kepEnter()">
							</td>
							
							<th>SG</th>
							<td>
								<input type="text" id="st_c_sg_nm" name="st_c_sg_nm" class="input_type_text" style="width:65%;" value=""  readonly onclick="javascript:doPop('sg_info');">
								<input type="hidden" name="st_c_sg_id" id="st_c_sg_id" style="width:80%" value="">
								<a href="javascript:doPop('sg_info');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_c_sg_id','st_c_sg_nm');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
						
						<tr>
							<td>추가정비 여부</td>
							<td colspan="5">
					  			<select name = "st_after_cms_reject_yn" id="st_after_cms_reject_yn" style="width:8%;height:20px;">
					  				<option value = "" selected>전체</option>
					  				<option value = "Y" >Y</option>
					  				<option value = "N">N</option>
	                           </select>
	                           <input type="checkbox"  class="Noborder" name="st_exits_itemcheck" id="st_exits_itemcheck" checked>&nbsp;추가정비 미제출 제외&nbsp;
	                           <input type="checkbox"  class="Noborder" name="st_req_itemcheck" id="st_req_itemcheck">&nbsp;추가정비 요청건만 조회&nbsp;
	                           <input type="checkbox"  class="Noborder" name="st_all_req_exce_check" id="st_all_req_exce_check">&nbsp;일괄제출 선정 제외&nbsp;
							</td>
							<td>신규/기등록 여부</td>
							<td>
								<select name = "st_buyer_item_no_new" id="st_buyer_item_no_new" style="width:35%;height:20px;">
					  				<option value = "ALL" selected>전체</option>
					  				<option value = "S" >신규</option>
					  				<option value = "K">기등록</option>
	                           </select>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
					<option value="100">100건</option>
					<option value="200">200건</option>
				</select>
				&nbsp;<img src="/resources/images/icon_r.gif"> 기등록
<!-- 				&nbsp;<img src="/resources/images/icon_y.gif"> 고객사NEGO건 -->
				&nbsp;<img src="/resources/images/icon_g.gif"> 신규
			</span>
			<br>
		</form>
		<form name="catlgFlow" id="catlgFlow" method="post" action ="">
		    <input type="hidden" name="catlg_desc_flow" id="catlg_desc_flow" value="">
		    <input type="hidden" name="catlg_spec_flow" id="catlg_spec_flow" value="">
		    <input type="hidden" name="catlg_maker_flow" id="catlg_maker_flow" value="">
		    <input type="hidden" name="catlg_model_flow" id="catlg_model_flow" value="">
		    <input type="hidden" name="catlg_row_num" id="catlg_row_num" value="">
		    
		    <input type="hidden" name="catlg_buyer" id="catlg_buyer" value="">
		    <input type="hidden" name="catlg_quotation_no" id="catlg_quotation_no" value="">
		    <input type="hidden" name="catlg_quotation_seq" id="catlg_quotation_seq" value="">
		    <input type="hidden" name="catlg_revision" id="catlg_revision" value="">
		    <input type="hidden" name="catlg_type" id="catlg_type" value="RQDT">
		</form>
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
            <div class="btnArea">
  	          	<span class="fl" >
  					<span class="btn_04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  					<span class="btn_07 mr04"><a href="javascript:doPop('buyercatalog');">고객사카탈로그 조회</a></span>
  				</span>
  				
  				<span class="fr">
<!--   					<span class="btn_08 mr04"><a href="javascript:doAction('nego');">고객사NEGO 견적제출</a></span> -->
					<span class="btn_02"><a href="javascript:doAction('init');">견적초기화</a></span>
					<span class="btn_06 mr04"><a href="javascript:doAction('after_item_chg_req');">추가정비요청</a></span>
					<span class="btn_06 mr04"><a href="javascript:doPop('afterItemChgSend');">추가정비제출</a></span>
					<span class="btn_08 mr04"><a href="javascript:doAction('mail')">협력사 견적요청메일</a></span>
					<span class="btn_05 mr04"><a href="javascript:doAction('round')">추가라운드요청</a></span>
					<span class="btn_05 mr04"><a href="javascript:doAction('stoa');">견적마감시간연장</a></span>
					<span class="btn_06 mr04"><a href="javascript:doAction('msds');">MSDS요청(협력사)</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('save');">고객사 견적제출</a></span>
  				
  				<%  //구매팀 견적취소 삭제 - 조직개편 2025.08.18
					if(st_sour_dept_yn.equals("N")){
				%>
  					<span class="btn_02 mr04"><a href="javascript:doAction('cancel');">견적취소</a></span>
  				<%
  					}
  				%>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
