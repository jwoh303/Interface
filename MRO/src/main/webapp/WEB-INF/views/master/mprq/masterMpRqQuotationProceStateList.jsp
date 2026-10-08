<%--
**********************************************
* 메뉴 : 견적관리>견적진행조회
* 화면 : 견적진행조회
* 기능 : 견적진행상태를 조회하고 상세정보를 확인하여 견적취소하거나 견적복원처리를 한다
* 프로그램 ID : PG_04_M_009_00
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-07-16
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<!-- 다중선택콤보(공통) - 사용시 필수 선언 start -->
<script src="/resources/js/jquery.multiple.select.js"></script>
<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<!-- 다중선택콤보(공통) - 사용시 필수 선언 end -->
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
	//소싱부서 지원 여부
	String st_sour_supl_yn = "";
	boolean st_sour_supl = CommonUtil.getCodeCheckReturn("SOURSUPL",st_user_id);
	if(st_sour_supl == true){
		st_sour_supl_yn = "Y";
	}else{
		st_sour_supl_yn = "N";
	}
	// SM 대상자 기준
	String st_sour_sm_yn = "";
	boolean st_sour_sm = CommonUtil.getCodeCheckReturn("SOURSM",st_user_id);
	if(st_sour_sm == true){
		st_sour_sm_yn = "Y";
	}else{
		st_sour_sm_yn = "N";
	}
	// DSM 대상자 기준
	String st_sour_dsm_yn = "";
	boolean st_sour_dsm = CommonUtil.getCodeCheckReturn("SOURDSM",st_user_id);
	if(st_sour_dsm == true){
		st_sour_dsm_yn = "Y";
	}else{
		st_sour_dsm_yn = "N";
	}
	
	// MSDS 담당자
	boolean getRoleYn = CommonUtil.getCodeCheckReturn("CM10",st_user_id);
	
	// MRO사업팀 확인
	String st_mro_dept_yn = "";
	boolean st_mro_dept = CommonUtil.getCodeCheckReturn("MRODEPT",st_user_dept);
	if(st_mro_dept == true){
		st_mro_dept_yn = "Y";
	}else{
		st_mro_dept_yn = "N";
	}
	// SMART팀 확인
	String st_smart_dept_yn = "";
	boolean st_smart_dept = CommonUtil.getCodeCheckReturn("SMRTDEPT",st_user_dept);
	if(st_smart_dept == true){
		st_smart_dept_yn = "Y";
	}else{
		st_smart_dept_yn = "N";
	}
	
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var iconR="/resources/images/icon_r.gif";
var iconY="/resources/images/icon_y.gif";
var iconG="/resources/images/icon_g.gif";
var reasonOn = "/resources/images/icon.gif";
var reasonOff = "/resources/images/icon2.gif";

var cb_item_chg_req_type = KepSheetComboData("DM04","SEL");
var item_chg_req_type = {ComboCode: cb_item_chg_req_type.ComboCode, ComboText: cb_item_chg_req_type.ComboText};

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
// 	initsheet.HeaderMode = {			Sort : 0,			ColMove : 1,			ColResize : 1		};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 7};
	initsheet.Cols = [ 
	 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
	,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED",ColMerge:0,Sort:1}
	,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME",ColMerge:0,Sort:1}
	,{ Align:"Left",	Width:110,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:15,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"진행상태",	SaveName:"DELAY_STATUS_IMG",ColMerge:1,Sort:1}
	,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"진행상태",	SaveName:"SOURCING_STATUS",ColMerge:1,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적번호",	SaveName:"QUOTATION_NO",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"순번",	SaveName:"QUOTATION_SEQ",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"차수(B/S)",	SaveName:"REVICNT",ColMerge:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO",ColMerge:0,Sort:1}
	,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION",ColMerge:0,Sort:1}
	,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION",ColMerge:0,Sort:1}
	,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명(영문)",	SaveName:"DESCRIPTION_ENG",ColMerge:0,Sort:1}
	,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격(영문)",	SaveName:"SPECIFICATION_ENG",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사코드",	SaveName:"MAKER_CODE",	Sort:0}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NAME",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단가구분",	SaveName:"REQ_PRICE_TYPE_TEXT",ColMerge:0,Sort:1}
	,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",	 Format:"${priceFormat}",	Header:"요청단가",	SaveName:"BUYER_TARGET_PRICE",ColMerge:0,Sort:1}
	,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",	 Format:"${priceFormat}",	Header:"목표단가",	SaveName:"ADMIN_TARGET_PRICE",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"견적의뢰일",	SaveName:"BTOA_DATE",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"회신요청일",	SaveName:"BTOA_END_DATE",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적마감일",	SaveName:"ATOS_END_DATE",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",	SaveName:"BTOA_USER_NAME",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청부서",	SaveName:"BTOA_USER_DEPT",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자",	SaveName:"BTOA_USER_ID",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"공개",	SaveName:"AGENT_OPEN_FLAG",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고",	SaveName:"BTOA_REMARK_IMG",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"SCM비고",	SaveName:"SCM_REMARK_IMG",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사비고",	SaveName:"BTOA_REMARK",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사비고",	SaveName:"ATOB_REMARK",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"운영사비고",	SaveName:"ATOA_REMARK",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사비고",	SaveName:"SCM_REMARK",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"취소사유",	SaveName:"CANCEL_REMARK_IMG",ColMerge:0,Sort:0}
	,{ Align:"Left",	Width:200,	Edit:false,	EditLen:4000,	Hidden:true,	Type:"Text",	Header:"취소사유",	SaveName:"CANCEL_REMARK",ColMerge:0,Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"취소사유코드",	SaveName:"CANCEL_REMARK_CODE",ColMerge:0,Sort:0}
	,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"취소사유유형",	SaveName:"CANCEL_REMARK_TEXT",ColMerge:0,Sort:0}
	,{Align : "Center",SaveName : "DELAY_REASON_IMG",	Header : "견적지연사유",	Type : "Image",	Width : 90,	EditLen : 110,	Edit : false}
	,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"DELAY_REASON_CODE",	SaveName:"DELAY_REASON_CODE",	Sort:0}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"첨부파일\n(B)",	SaveName:"IMAGE_KEY_IMG",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"첨부파일\n(B)",	SaveName:"IMAGE_KEY",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"첨부파일\n(ATOS)",	SaveName:"SELLER_IMAGE_KEY_IMG",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"첨부파일\n(ATOS)",	SaveName:"SELLER_IMAGE_KEY",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적제출자",	SaveName:"KEP_USER_NAME",ColMerge:0,Sort:1}
	,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",	Format:"${qtyFormat}", Header:"수량",	SaveName:"ITEM_QTY",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"관리번호",	SaveName:"REF_NO",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"견적요청일",	SaveName:"ATOS_DATE",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적제출일",	SaveName:"ATOB_DATE",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",    Header:"접수건수",	SaveName:"QUOTA_CNT",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적요청자(S)",	SaveName:"QTDT_ADD_USER_NM",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"선정협력사",	SaveName:"AGENT_NAME",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"선정협력사",	SaveName:"AGENT",ColMerge:0,Sort:1}
	,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"선정협력사\n조달일수",	SaveName:"LEAD_TIME",ColMerge:0,Sort:1}
	,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"기존협력사",	SaveName:"BUYER_AGENT_NAME",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"지정협력사",	SaveName:"ASSIGN_AGENT_NAME",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"지정협력사",	SaveName:"ASSIGN_AGENT_CODE",ColMerge:0,Sort:1}
	,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float",	 Format:"${priceFormat}",	Header:"매익율",	SaveName:"RATE",ColMerge:0,Sort:1}
	,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",	 Format:"${priceFormat}", 		Header:"매출단가",	SaveName:"ATOB_UNIT_PRICE", BackColor:"#FF6",ColMerge:0}
	,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",	 Format:"${priceFormat}", 		Header:"매입단가",	SaveName:"STOA_LIST_PRICE", BackColor:"#FF6",ColMerge:0,Sort:1}
	,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사품명",	SaveName:"KEP_DESCRIPTION",ColMerge:0,Sort:1}
	,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사규격",	SaveName:"KEP_SPECIFICATION",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사제조사",	SaveName:"KEP_MAKER_NAME",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"과세구분",	SaveName:"TAX_TYPE",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"MSDS",	SaveName:"MSDS_YN",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",    Header:"MSDS_NO",	SaveName:"MSDS_NO",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",    Header:"MSDS요청번호",	SaveName:"CMC_REQ_NO",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",    Header:"MSDS진행상태",	SaveName:"CMC_REQ_STATUS",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"MSDS요청일시",	SaveName:"CMC_REQ_DATE",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",    Header:"협력사선정일시",	SaveName:"BID_SUCCESS_DATM",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"REVISION",	SaveName:"REVISION",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ATOS_END_FLAG",	SaveName:"ATOS_END_FLAG",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PLANT",	SaveName:"PLANT",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"합의일자",	SaveName:"CONFIRM_DATE",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"거래유형",	SaveName:"PROCESS_TYPE",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"수입여부",	SaveName:"IMPORT_FLAG",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"물류센터",	SaveName:"WAREHOUSE_CODE",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"DOCU_NO",	SaveName:"DOCU_NO",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"MSDS_YN_FIX",	SaveName:"MSDS_YN_FIX",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"표준카테고리ID",	SaveName:"RQDT_CMS_CATEG_ID",	ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"표준카테코리명",	SaveName:"RQDT_CMS_CATEG_NAME",	ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SG_ID",	SaveName:"SG_ID",	ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SG명",	SaveName:"SG_NAME",	ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사비고",	SaveName:"STOA_REMARK",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",    Header:"SG담당자",	SaveName:"SOUR_MNG",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",    Header:"모델명",	SaveName:"MAKER_PART_NO",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",    Header:"시장가확인",	SaveName:"MARKET_UNIT_PRICE_YN",ColMerge:0,Sort:1}
	,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",    Header:"고객사카테고리",	SaveName:"CATEG_NAME",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"환율코드",	SaveName:"EXP_CODE"}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"통화단위",	SaveName:"EXP_CUR"}
	,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"환율",	SaveName:"EXP_CUR_PRICE"}
	,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"매출단가(KRW)",	SaveName:"EXP_KR_UNIT_PRICE"}
	,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"부대비용(KRW)",	SaveName:"EXP_INC_EXPENSE"}
	,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"외화매출단가",	SaveName:"EXP_FOR_UNIT_PRICE"}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적담당자",	SaveName:"JOB_TRANSFER_NM",	Sort:1}
	,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적이관일시",	SaveName:"JOB_TRANSFER_DATE",	Sort:1}
	,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"DB클렌징최초처리일",	SaveName:"ITEM_CLEANSING_DATE",	Sort:1}
	,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"DB클렌징최초처리자",	SaveName:"ITEM_CLEANSING_USER_NM",	Sort:1}
	,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"DB클렌징처리일시",	SaveName:"CMS_RECV_DATM",	Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"DB클렌징처리자",	SaveName:"CM_USER_NM",	Sort:1}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"견적담당자ID",	SaveName:"JOB_TRANSFER_ID",	Sort:0}
	,{Align : "Center",	SaveName : "DELAY_SEND_MAIL_FLAG",			Header : "DELAY_SEND_MAIL_FLAG",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true}
	,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",    Header:"표준카탈로그",	SaveName:"CMS_CATLG_ID",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"MSDS요청(B)",	SaveName:"BUYER_MSDS_YN", Sort:1}
	,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"안전인증서상태",	SaveName:"SAFETY_FLAG_TEXT", Sort:1}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"PLANT담당자",	SaveName:"PLANT_USER_NM", Sort:1}
	,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"URL",	SaveName:"REMARK_URL",	Sort:1}
	,{ Align : "Center",SaveName : "PRE_GR_FLAG",		Header : "선입고",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:false}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ATOB_SEND_FLAG",	SaveName:"ATOB_SEND_FLAG",	ColMerge:0,Sort:1}
	,{ Align : "Center",SaveName : "VAT_YN",		Header : "부가세포함",	Type : "Text",	Width : 60,	EditLen : 110,	Edit : false, Hidden:false}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"운영\n특이사항",	SaveName:"NOTE_MNG_IMG",ColMerge:0,Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"견적복원가능여부",	SaveName:"SAVE_YN"}
	
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"정비완료구분",	SaveName:"ANY_ITEM_MD_COMPLETE", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",	Header:"정비구분",		SaveName:"ANY_ITEM_MD_REQ_TYPE", Sort:0}
	,{ Align:"Left",	Width:300,	Edit:false,	EditLen:2000,	Hidden:false,	Type:"Text",	Header:"정비요청사유",	SaveName:"ANY_ITEM_MD_REQ_NOTE", Sort:0}
	,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"정비요청일시",	SaveName:"ANY_ITEM_MD_REQ_DATE", Sort:1}
	,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"DM발송일시",	SaveName:"DM_SENT_DATE", Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"취소예정일자",	SaveName:"DELETE_SCHD_DATE", Sort:1}
	,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"정비제출일시",	SaveName:"ANY_ITEM_MD_DATE", Sort:1}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"정비\n제출자",	SaveName:"ANY_ITEM_MD_USER_NAME", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ANY_ITEM_MD_REQ_REVISION",	SaveName:"ANY_ITEM_MD_REQ_REVISION",	Sort:0}
	
	,{ Align:"Center",	Width:77,	Edit:false,	EditLen:300,	Type:"Date",	Format:"Ymd", Header:"매츌\n단가유효일",	SaveName:"SELL_CLOSE_DATE"}
	,{ Align:"Center",	Width:77,	Edit:false,	EditLen:300,	Type:"Date",	Format:"Ymd", Header:"매입\n단가유효일",	SaveName:"BUY_CLOSE_DATE"}
	,{ Align:"Right",	Width:60,	Edit:false,	EditLen:300,	Type:"Text",	Format:"Text", Header:"MOQ",	SaveName:"MIN_ORDER_QTY"}
	,{ Align:"Right",	Width:60,	Edit:false,	EditLen:300,	Type:"Text",	Format:"Text", Header:"발주배수",	SaveName:"PUR_UNIT_QTY"}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:300,	Type:"Text",	Format:"Text", Header:"구매 담당팀",	SaveName:"DSM_MNG_DEPT"}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:300,	Type:"Text",	Format:"Text", Header:"영업 담당팀",	SaveName:"MNG_DEPT"}
	,{ Align:"Center",	Width:130,	Edit:false,	EditLen:2000,	Hidden:true,	Type:"Text",	Header:"ADMIN_REMARK",	SaveName:"ADMIN_REMARK",	Sort:1}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"지정SG_ID",	SaveName:"SOUR_SG_ID", Sort:1}
	,{ Align:"Left",	Width:100,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"지정SG명",	SaveName:"SOUR_SG_NAME", Sort:1}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"SG지정차수",	SaveName:"SG_CNT", Sort:1}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"DSM담당자",	SaveName:"DSM_MNG_NM", Sort:1}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:80,	Hidden:true,	Type:"Text",	Header:"DSM_MNG_ID",SaveName:"DSM_MNG_ID", Sort:0}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"SM담당자",	SaveName:"SM_MNG_NM", Sort:1}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:80,	Hidden:true,	Type:"Text",	Header:"SM_MNG_ID",	SaveName:"SM_MNG_ID", Sort:0}
	
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"품목정비요청자ID",	SaveName:"ITEM_CHG_REQ_ID", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"품목정비요청자명",	SaveName:"ITEM_CHG_REQ_USER_NAME", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"품목정비요청일시",	SaveName:"ITEM_CHG_REQ_DATE", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"품목정비요청사유",	SaveName:"ITEM_CHG_REQ_NOTE", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"품목정비제출자ID",	SaveName:"ITEM_MD_USER_ID", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"품목정비제출자명",	SaveName:"ITEM_MD_USER_NAME", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"품목정비제출일시",	SaveName:"ITEM_MD_DATE", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"추가정비요청자ID",	SaveName:"AFTER_ITEM_CHG_REQ_ID", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"추가정비요청자명",	SaveName:"AFTER_ITEM_CHG_REQ_USER_NAME", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"추가정비요청일시",	SaveName:"AFTER_ITEM_CHG_REQ_DATE", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"추가정비요청사유",	SaveName:"AFTER_ITEM_CHG_REQ_NOTE", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"추가정비제출자ID",	SaveName:"AFTER_ITEM_MD_USER_ID", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"추가정비제출자명",	SaveName:"AFTER_ITEM_MD_USER_NAME", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"추가정비제출일시",	SaveName:"AFTER_ITEM_MD_DATE", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"네고정비요청자ID",	SaveName:"NEGO_ITEM_CHG_REQ_ID", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"네고정비요청자명",	SaveName:"NEGO_ITEM_CHG_REQ_USER_NAME", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"네고정비요청일시",	SaveName:"NEGO_ITEM_CHG_REQ_DATE", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"네고정비요청사유",	SaveName:"NEGO_ITEM_CHG_REQ_NOTE", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"네고정비제출자ID",	SaveName:"NEGO_ITEM_MD_USER_ID", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"네고정비제출자명",	SaveName:"NEGO_ITEM_MD_USER_NAME", Sort:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"네고정비제출일시",	SaveName:"NEGO_ITEM_MD_DATE", Sort:0}
	];
	
	IBS_InitSheet2(mySheet, initsheet,pagingMode,5);

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);
	mySheet.SetImageList(3, diskOn);
	mySheet.SetImageList(2, diskOff);
	mySheet.SetImageList(4, iconR);
	mySheet.SetImageList(6, iconY);
	mySheet.SetImageList(5, iconG);
	mySheet.SetImageList(9, reasonOn);
	mySheet.SetImageList(8, reasonOff);

	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL','');
	//PLANT담당자 콤보데이터 셋팅. 로그인  부서 기준 사용자 리스트
	var st_user_dept = "<%=st_user_dept%>";
	kepAjaxCommonQueryIdSearchTwoCombo('st_plant_user_id','common.masterDepartmentUserList','',st_user_dept,'ALL','<%=st_smart_dept_yn.equals("Y") ? st_user_id : ""%>');
	//하이퍼링크 설정
	setLinkCol(mySheet, "BTOA_USER_NAME");	//요청자
	setLinkCol(mySheet, "BUYER_ITEM_NO");	//품목코드
	setLinkCol(mySheet, "QUOTATION_NO");	//견적번호
	setLinkCol(mySheet, "QUOTATION_SEQ");	//견적순번
	setLinkCol(mySheet, "REVICNT");	//차수
	setLinkCol(mySheet, "AGENT_NAME");	//협력사
	setLinkCol(mySheet, "BTOA_REMARK_IMG"); // 비고
	setLinkCol(mySheet, "SCM_REMARK_IMG"); // 비고
	setLinkCol(mySheet, "CANCEL_REMARK_IMG"); // 취소
	setLinkCol(mySheet, "IMAGE_KEY_IMG"); // 첨부파일(B)
	setLinkCol(mySheet, "SELLER_IMAGE_KEY_IMG"); // 첨부파일(ATOS)
	setLinkCol(mySheet, "MSDS_NO"); // MSDS 등록 및 매핑
	setLinkCol(mySheet, "DELAY_REASON_IMG"); //견적지연 사유
	setLinkCol(mySheet, "NOTE_MNG_IMG"); //특이사항 입력
	setLinkCol(mySheet, "BUYER_NAME"); //고객사
	setLinkCol(mySheet, "ANY_ITEM_MD_REQ_DATE"); //정비요청일시
	setLinkCol(mySheet, "DM_SENT_DATE"); //DM발송일시
	setLinkCol(mySheet, "ANY_ITEM_MD_DATE"); //정비제출일시
	setLinkCol(mySheet, "SG_CNT"); // SG지정차수
	
	mySheet.SetCellFontUnderline(0, "CANCEL_REMARK_IMG", true);	
	
	mySheet.SetColProperty("ANY_ITEM_MD_REQ_TYPE", item_chg_req_type);
	
	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val(kepToDateAdd("7","M"));
	$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
	// 다중선택콤보(공통) - 생성
	kepAjaxCommonTotalMultiCombo('st_status', 'M126', 'ALL', '');
	// 콤보데이터 셋팅 조회조건 : 견적 담당자
	kepAjaxCommonQueryIdSearchTwoCombo('st_job_transfer_id','common.masterDepartmentUserList','PG_10_M_006_00','','ALL','');
	
<%
	if("Y".equals(st_mro_dept_yn)){ // MRO사업팀 경우만
%>
		document.getElementById("st_md_req_check").checked = true;
<%
	}else{
%>
		document.getElementById("st_md_req_check").checked = false;
<%
	}
%>
}
	
	
var st;
var mt;
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

		if (kepGetDateDiff('st_from_date','st_to_date','D') > 62 ){
			alert("조회기간을 2개월 단위로 조회가 가능합니다.\n\n2개월 이상의 데이타는 S/R 요청 바랍니다.");
			return;
		}
		current_page = -1;

		//소싱부서가 아닐 경우 고객사코드 필수 값.
		if($("#st_sour_dept_yn").val() == "N"){
			if($("#st_buyer_code").val() == null||$("#st_buyer_code").val() == ""){
				alert("고객사은(는) 필수입력 항목입니다.");
				return;
			}
		}
		//표준카탈로그 코드 5자리 이상 입력 후 나오도록
		var st_stdcatlg_id = TrimCommon($("#st_stdcatlg_id").val());
		if(st_stdcatlg_id != ""){
			if(st_stdcatlg_id.length < 5){
				alert("표준카탈로그 코드 5자이상 입력 바랍니다..");
				return;			
			}			
		}
		if($('#st_checkbox')[0].checked) {
			$("#st_date_type").val("BTOA");
			if(kepIsValueNull($('#st_quotation_no').val()) 
					&& kepIsValueNull($('#st_kep_user_id').val()) 
// 					&& kepIsValueNull($('#st_status').val())
					&& kepIsValueNull($('#st_btoa_user_name').val()) 
					&& kepIsValueNull($('#st_desc_spec').val()) 
					&& kepIsValueNull($('#st_buyer_item_no').val())
					&& kepIsValueNull($('#st_maker_code').val())
					){
				alert('견적번호, 담당자, 요청자, 품목명/규격, 품목코드, 제조사 중 한 값은 필수 입니다.');
				return;
			}
		}
		
		if($('#st_md_except_check')[0].checked) {
			$("#st_md_except_flag").val("Y");
		}else{
			$("#st_md_except_flag").val("N");
		}
		
		if($('#st_md_req_check')[0].checked) {
			$("#st_md_req_flag").val("Y");
		}else{
			$("#st_md_req_flag").val("N");
		}
		
		if($('#st_md_req_mail_check')[0].checked) {
			$("#st_md_req_mail_flag").val("Y");
		}else{
			$("#st_md_req_mail_flag").val("N");
		}
		
		kepSearch(document.searchCondition, mySheet, "/mprq/getMasterMpRqQuotationProceStateList.do", pagingMode);
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$('#st_buyer_code').val("");
		$('#st_maker_code').val("");
		
		document.getElementById("st_checkbox").checked = false;
		document.getElementById("st_gr_checkbox").checked = false;
		document.getElementById("st_md_except_check").checked = false;

<%		
		if("Y".equals(st_mro_dept_yn)){ // MRO사업팀 경우만
%>
			document.getElementById("st_md_req_check").checked = true;
<%
		}else{
%>
			document.getElementById("st_md_req_check").checked = false;
<%
		}
%>
		
		mySheet.RemoveAll();
		
		// 다중선택콤보(공통) - 초기화
		init_multiCombo("st_status");
		
		$("#st_from_date").val(kepToDateAdd("7","M"));
		$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
		break;
		
	case "msds":
		mySheet.SetColProperty("MSDS_YN",{KeyField:false});
		
		for(var i=0; i<arrRow.length; i++){
			if ("협력사선정완료" != mySheet.GetCellValue(arrRow[i],"SOURCING_STATUS") && "고객사NEGO의뢰" != mySheet.GetCellValue(arrRow[i],"SOURCING_STATUS")){
				alert("요청 가능 진행상태 확인바랍니다.(협력사선정완료, 고객사NEGO의뢰)");
				return;
			}
		}
		
		if (!confirm('선택한 항목을 협력사에 MSDS 요청 하시겠습니까?\n현재 매핑된 MSDS_NO는 해제됩니다.'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqQuotationProceStateList2.do" , "SELECTED" );
		break;
		

	case "save": // 견적복원
		for (var i=0; i<arrRow.length; i++){
			if (mySheet.GetCellValue(arrRow[i],"SOURCING_STATUS") != "견적취소"){
				alert("정상 진행 견적 입니다.");
				return;
			}
			//고객사 견적제출건은 견적복원 불가능.
			if (mySheet.GetCellValue(arrRow[i],"ATOB_SEND_FLAG") == "Y"){
				alert("선택한 항목은 고객사 견적제출 건이므로 견적복원이 불가능 합니다.\n신규견적 진행 바랍니다.");
				return;
			}
			
			//고객사 견적 품의 사용하는 경우 품의가 없는 견적은 복원 불가능
			if (mySheet.GetCellValue(arrRow[i], "SAVE_YN") == "N"){
				alert("선택한 항목은 고객사 내부품의 미진행 건이므로 견적복원이 불가합니다.\n신규견적 진행 바랍니다.");
				return;
			}
		}

		if (!confirm('선택한 항목을 견적복원 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqQuotationProceStateList.do" , "SELECTED" );
		break;
		
	case "cancel": // 견적취소
		for (var i=0; i<arrRow.length; i++){
			if (mySheet.GetCellValue(arrRow[i],"SOURCING_STATUS") == "견적취소"){
				alert("이미 취소된 견적 입니다.");
				return;
			}

			if (mySheet.GetCellValue(arrRow[i],"SOURCING_STATUS") == "합의완료"){
				alert("합의완료건은 취소가 불가능 합니다.");
				return;
			}
			
			var CANCEL_REMARK = mySheet.GetCellValue(arrRow[i],"CANCEL_REMARK");
			var CANCEL_REMARK_CODE = mySheet.GetCellValue(arrRow[i],"CANCEL_REMARK_CODE");
			
			if(CANCEL_REMARK == "" && CANCEL_REMARK_CODE == ""){
				alert("견적 취소 사유를 입력하여 주십시요");
				mySheet.SelectCell(arrRow[i], "CANCEL_REMARK_IMG");
				return;
			}
		}
	
		if (!confirm('선택한 항목을 견적취소 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mprq/delMasterMpRqReqQuotReceipt.do" , "SELECTED" );
		break;
		
	case "excelDown": // 엑셀다운로드
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 62 ){
			alert("조회기간을 2개월 단위로 조회가 가능합니다.\n\n2개월 이상의 데이타는 S/R 요청 바랍니다.");
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
		var fromTo =  $("#st_from_date").val().replace(/\//gi, "") + "_" + $("#st_to_date").val().replace(/\//gi, "");
	    var param = {FileName:"견적진행조회_"+fromTo+".xlsx",Merge:1,SheetDesign:1,DownCols:"BUYER|BUYER_NAME|SOURCING_STATUS|BUYER_ITEM_NO|QUOTATION_NO|QUOTATION_SEQ|REVICNT|BTOA_DATE|BTOA_END_DATE|ATOB_DATE|DESCRIPTION|SPECIFICATION|DESCRIPTION_ENG|SPECIFICATION_ENG|MAKER_CODE|MAKER_NAME|ORIGIN_NAME|UNIT_MEASURE|RQDT_CMS_CATEG_ID|RQDT_CMS_CATEG_NAME|SG_NAME|CATEG_NAME|ATOS_DATE|ATOS_END_DATE|ITEM_QTY|REQ_PRICE_TYPE_TEXT|BUYER_TARGET_PRICE|ADMIN_TARGET_PRICE|ATOB_UNIT_PRICE|STOA_LIST_PRICE|AGENT_NAME|BUYER_AGENT_NAME|ASSIGN_AGENT_NAME|BTOA_USER_NAME|BTOA_USER_DEPT|KEP_USER_NAME|BTOA_REMARK|ATOB_REMARK|ATOA_REMARK|STOA_REMARK|CONFIRM_DATE|PROCESS_TYPE|WAREHOUSE_CODE|PLANT|KEP_DESCRIPTION|KEP_SPECIFICATION|KEP_MAKER_NAME|TAX_TYPE|BID_SUCCESS_DATM|CMS_RECV_DATM|MSDS_NO|SOUR_MNG|MAKER_PART_NO|MARKET_UNIT_PRICE_YN|JOB_TRANSFER_NM|JOB_TRANSFER_DATE|CMS_CATLG_ID|ITEM_CLEANSING_DATE|ITEM_CLEANSING_USER_NM|CMS_RECV_DATM|CM_USER_NM|REF_NO|BUYER_MSDS_YN|SAFETY_FLAG_TEXT|PLANT_USER_NM|REMARK_URL|CANCEL_REMARK_TEXT|CANCEL_REMARK|LEAD_TIME|MIN_ORDER_QTY|PUR_UNIT_QTY|DSM_MNG_DEPT|MNG_DEPT|SOUR_SG_ID|SOUR_SG_NAME|SG_CNT|DSM_MNG_NM|SM_MNG_NM|PRE_GR_FLAG|ITEM_CHG_REQ_USER_NAME|ITEM_CHG_REQ_DATE|ITEM_CHG_REQ_NOTE|ITEM_MD_USER_NAME|ITEM_MD_DATE|AFTER_ITEM_CHG_REQ_USER_NAME|AFTER_ITEM_CHG_REQ_DATE|AFTER_ITEM_CHG_REQ_NOTE|AFTER_ITEM_MD_USER_NAME|AFTER_ITEM_MD_DATE|NEGO_ITEM_CHG_REQ_USER_NAME|NEGO_ITEM_CHG_REQ_DATE|NEGO_ITEM_CHG_REQ_NOTE|NEGO_ITEM_MD_USER_NAME|NEGO_ITEM_MD_DATE"};
		kepDownExcel(document.searchCondition ,mySheet , "/mprq/excelMasterMpRqQuotationProceStateList.do", param);
		$("#pageflag").val('1');
		break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
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
		if (mySheet.GetCellValue(i, "ATOS_END_FLAG") == "Y"){
			mySheet.SetCellFontColor(i,"ATOS_END_DATE","#FF0000");
// 			mySheet.SetCellFontBold(i, "ATOS_END_DATE",1);
		}
		if (!kepIsValueNull(mySheet.GetCellValue(i, "DOCU_NO"))){
			mySheet.SetCellFontColor(i,"SOURCING_STATUS","#0100FF");
		}
	}
	if (msg != "") {
		alert(msg);
	}

}

function mySheet_OnMouseMove(Button, Shift, X, Y) { 
	var row = mySheet.MouseRow();
	var cellFont = mySheet.GetCellFontColor(row, "SOURCING_STATUS");
	if(cellFont == "#0100ff") {
		mySheet.SetDataLinkMouse("SOURCING_STATUS", true);
	} else {
		mySheet.SetDataLinkMouse("SOURCING_STATUS", false);
	}
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
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqQuotationProceStateList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyerMulti": // 고객사 M
			popupSel = "buyerMulti";
			openSearchPopup("/none/showCommonNoNeBuyerChoiceMultiPop.do","?search_opt=2&disable_yn=Y",'1000,500,no')
			break;
		case "maker": // 제조사
			popupSel = "maker";
			openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
			break;
			
		case "dooSan":// 두산 재고코드 입력
			if (kepIsValueNull($('#st_buyer_code').val())){
				alert("고객사를 선택하여 주십시요.");
				return;
			}
			
			popupSel = "masterMpRqDoosanStockCodeInsPop";
			openSearchPopup("/mprq/showMasterMpRqDoosanStockCodeInsPop.do",'?st_buyer='+$('#st_buyer_code').val(),"720,450,no");
			break;
		case "sg_info"://SG정보
			openSearchPopup("/mprq/showMasterMpRqSgChoicePop.do", "", "500,500,no");
			break;
			
		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=0000007zn&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
			
		case "remark": // 운영특이사항 일괄입력기능
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			// 선택된 항목 유무 체크
			if (selectedGrid.length == 0) {
				alert("선택된 항목이 없습니다.");
				return;
			}
			openSearchPopup("/common/remarkReturn2Pop.do", "?st_gubun=REMARK", "600,230,no");
			break;
		case "regVoc": // VOC 등록
			var checkRows = mySheet.FindCheckedRow("SELECTED");
			var checkRowsArr = checkRows.split("|");	
			var st_buyer = "";
			var st_buyer_name = "";
			var st_quotation_no_arr = "";
			var st_sg_mng_id = "";//SG 담당자ID
			if (mySheet.RowCount() == 0){
				alert("조회된 데이터가 없습니다.");
				return;
			}
			if (checkRows.length == 0){
				alert("선택하신 품목이 없습니다.");
				return;
			}
			for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++){
				if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
					st_sg_mng_id = mySheet.GetCellValue(i, "DSM_MNG_ID");
					st_buyer = mySheet.GetCellValue(i, "BUYER");
					st_buyer_name = mySheet.GetCellValue(i, "BUYER_NAME");
					//SG담당자 ID비교
					for(var j= 1 ; j<mySheet.GetTotalRows()+1; j++){
						if ( mySheet.GetCellValue(j, "SELECTED") == '1' ) {
							//고객사가 다른 경우가 있으면 처리 불가
							if(st_buyer!= mySheet.GetCellValue(j, "BUYER")){
								alert(j+"번째 고객사가 달라 VOC 일괄 등록이 불가능 합니다.");
								return;
							}
							//SG 담당자 ID가 다른 경우가 있으면 처리 불가
							if(st_sg_mng_id != mySheet.GetCellValue(j, "DSM_MNG_ID")){
								alert(j+"번째 SG담당자가 달라 VOC 일괄 등록이 불가능 합니다.");
								return;
							}
						}
					}
					st_quotation_no_arr += "견적번호: "+mySheet.GetCellValue(i, "QUOTATION_NO")+"견적순번: "+mySheet.GetCellValue(i, "QUOTATION_SEQ")+"/";
				}
			}
			//POST PARAM 셋팅
			document.forms.vocRegPop.st_voc_buyer.value = st_buyer;
			document.forms.vocRegPop.st_voc_buyer_name.value = st_buyer_name;
			document.forms.vocRegPop.st_type.value = "RE";
			document.forms.vocRegPop.st_sg_mng_id.value = st_sg_mng_id;
			document.forms.vocRegPop.st_quotation_no_arr.value = st_quotation_no_arr;
			openSearchPopupPost("/mpvo/showMasterMpVoVocRegPop.do", "vocRegPop", 'showMasterMpVoVocRegPop', "width=1000,height=390,resizable=no,scrollbars=no, top=0, left=0");
			break;
			
		case "itemChgSend": // 정비제출
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow     = selectedGrid.split("|");
			// 선택된 항목 유무 체크
			if (selectedGrid.length == 0) {
				alert("선택된 항목이 없습니다.");
				return;
			}
			for(var i=0; i<arrRow.length;i++){
				var st_status_flag = mySheet.GetCellValue(arrRow[i],"SOURCING_STATUS");
				if(st_status_flag != "고객사견적의뢰" && st_status_flag != "협력사견적요청" && st_status_flag != "협력사재견적요청" && st_status_flag != "협력사선정완료" && st_status_flag != "고객사NEGO의뢰"){
					alert("가능한 진행상태가 아닙니다.["+arrRow[i]+"번째]");
					return;
				}
				
				var st_cms_reject_flag = mySheet.GetCellValue(arrRow[i],"ANY_ITEM_MD_COMPLETE");
				if(st_cms_reject_flag != "N1" && st_cms_reject_flag != "N2" && st_cms_reject_flag != "N3"){
					alert("정비 제출 대상이 아닙니다.["+arrRow[i]+"번째]");
					return;
				}
				
				if(st_cms_reject_flag == "Y1" && st_cms_reject_flag == "Y2" && st_cms_reject_flag == "Y3"){
					alert("정비 제출 된 상태입니다.["+arrRow[i]+"번째]");
					return;
				}
				
				// 모든 선택 건이 일치하는 내용인지 확인
				var st_buyer_base = mySheet.GetCellValue(arrRow[0],"BUYER");
				var st_quotation_no_base = mySheet.GetCellValue(arrRow[0],"QUOTATION_NO");
				var st_item_md_req_type_base = mySheet.GetCellValue(arrRow[0],"ANY_ITEM_MD_REQ_TYPE");
				var st_item_md_req_note_base = mySheet.GetCellValue(arrRow[0],"ANY_ITEM_MD_REQ_NOTE");
				
				var st_buyer = mySheet.GetCellValue(arrRow[i],"BUYER");
				var st_quotation_no = mySheet.GetCellValue(arrRow[i],"QUOTATION_NO");
				var st_item_md_req_type = mySheet.GetCellValue(arrRow[i],"ANY_ITEM_MD_REQ_TYPE");
				var st_item_md_req_note = mySheet.GetCellValue(arrRow[i],"ANY_ITEM_MD_REQ_NOTE");
				
				if(st_buyer_base != st_buyer || st_quotation_no_base != st_quotation_no || st_item_md_req_type_base != st_item_md_req_type || st_item_md_req_note_base != st_item_md_req_note){
					alert("동일한 고객사/견적번호/정비구분/정비요청사유만 가능합니다.");
					return;
				}
			}
			openSearchPopup("/common/remarkReturn2Pop.do", "?st_gubun=ANYITEMCHG", "600,230,no");
			break;
			
		case "quotationDmSend":
			popupSel = "quotationDmSendPop";

			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow = selectedGrid.split("|");
			
			// 선택된 항목 유무 체크
			if (selectedGrid.length == 0) {
				alert("선택된 항목이 없습니다.");
				return;
			}

			for(var i=0; i<arrRow.length;i++){
				// 모든 선택 건이 일치하는 내용인지 확인
				var st_buyer_base = mySheet.GetCellValue(arrRow[0],"BUYER");
				var st_quotation_no_base = mySheet.GetCellValue(arrRow[0],"QUOTATION_NO");
				var st_item_md_req_type_base = mySheet.GetCellValue(arrRow[0],"ANY_ITEM_MD_REQ_TYPE");
				var st_item_md_req_note_base = mySheet.GetCellValue(arrRow[0],"ANY_ITEM_MD_REQ_NOTE");
				
				var st_buyer = mySheet.GetCellValue(arrRow[i],"BUYER");
				var st_quotation_no = mySheet.GetCellValue(arrRow[i],"QUOTATION_NO");
				var st_item_md_req_type = mySheet.GetCellValue(arrRow[i],"ANY_ITEM_MD_REQ_TYPE");
				var st_item_md_req_note = mySheet.GetCellValue(arrRow[i],"ANY_ITEM_MD_REQ_NOTE");
				
				var st_status_flag = mySheet.GetCellValue(arrRow[i],"SOURCING_STATUS");
				if(st_status_flag != "고객사견적의뢰" && st_status_flag != "협력사견적요청" && st_status_flag != "협력사재견적요청" && st_status_flag != "협력사선정완료" && st_status_flag != "고객사NEGO의뢰"){
					alert("가능한 진행상태가 아닙니다.["+arrRow[i]+"번째]");
					return;
				}
				
				var st_cms_reject_flag = mySheet.GetCellValue(arrRow[i],"ANY_ITEM_MD_COMPLETE");
				if(st_cms_reject_flag != "N1" && st_cms_reject_flag != "N2" && st_cms_reject_flag != "N3"){
					alert("DM발송 대상이 아닙니다.["+arrRow[i]+"번째]");
					return;
				}
				
				if(st_cms_reject_flag == "Y1" && st_cms_reject_flag == "Y2" && st_cms_reject_flag == "Y3"){
					alert("정비 제출 된 상태입니다.["+arrRow[i]+"번째]");
					return;
				}
				
				var st_req_type = mySheet.GetCellValue(arrRow[i],"ANY_ITEM_MD_REQ_TYPE");
				if(st_req_type == ""){
					alert("정비구분을 선택하여 주십시요.["+arrRow[i]+"번째]");
					mySheet.SelectCell(arrRow[i], "ANY_ITEM_MD_REQ_TYPE", 1, "");
					return;
				}
				
				if(st_buyer_base != st_buyer || st_quotation_no_base != st_quotation_no || st_item_md_req_type_base != st_item_md_req_type || st_item_md_req_note_base != st_item_md_req_note){
					alert("동일한 고객사/견적번호/정비구분/정비요청사유만 가능합니다.");
					return;
				}
			}
			
			var st_send_quotation_seq_arr = "";
			
			for(var i=0; i<arrRow.length;i++){
				var st_send_buyer = mySheet.GetCellValue(arrRow[0],"BUYER");
				var st_send_quotation_no = mySheet.GetCellValue(arrRow[0],"QUOTATION_NO");
				var st_send_item_md_req_type = mySheet.GetCellValue(arrRow[0],"ANY_ITEM_MD_REQ_TYPE");
				var st_send_item_md_req_type_text = mySheet.GetCellText(arrRow[0],"ANY_ITEM_MD_REQ_TYPE");
				var st_send_item_md_req_note = mySheet.GetCellValue(arrRow[0],"ANY_ITEM_MD_REQ_NOTE");
				var st_send_item_md_complete = mySheet.GetCellValue(arrRow[0],"ANY_ITEM_MD_COMPLETE");
				
				var st_send_quotation_seq = mySheet.GetCellValue(arrRow[i],"QUOTATION_SEQ") + "@";

				st_send_quotation_seq_arr += st_send_quotation_seq;
			}
			
			st_send_item_md_complete = st_send_item_md_complete.substr(1,1);
			
			//post 팝업 파라미터 설정
			var st_form_name = "quotationDmSendPopForm";
			var st_popup_url = "/mdcm/showMasterMpRqQuotationDmSendPop.do";
			var st_popup_param = "st_buyer@@" + st_send_buyer + "^||^" +
								"st_quotation_no@@" + st_send_quotation_no + "^||^" +
								"st_req_type@@" + st_send_item_md_req_type + "^||^" +
								"st_req_type_text@@" + st_send_item_md_req_type_text + "^||^" +
								"st_req_kind@@" + st_send_item_md_complete + "^||^" +
								"st_quotation_seq_arr@@" + st_send_quotation_seq_arr;
			var st_popup_option = "900,850,no";
			//post 팝업 호출
			openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
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
	var quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
	var quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
	var revision = mySheet.GetCellValue(Row, "REVISION");
	var agent = mySheet.GetCellValue(Row,"AGENT");
	if (column == 'SOURCING_STATUS') { // 요청자
		var docu_no = mySheet.GetCellValue(Row, "DOCU_NO");
		if(!kepIsValueNull(docu_no)){
			openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do','?COMPANY=KRKORE0001&DOCU_NO='+docu_no+'&PASS_TP=1&FLAG=COMPLETE' , '1200,700,no');
		}
	} else if (column == 'BUYER_NAME') { // 고객사
		//고객사 정보 팝업 호출
		openSearchPopup("/mdct/showMasterMdCtBuyerJoinAlterRequestApprovalPop.do", "?com_code="+buyer,  "900,700,no");
	} else if (column == 'BTOA_USER_NAME') { // 요청자
		var ID = mySheet.GetCellValue(Row,"BTOA_USER_ID");
		if (ID!=""){
			openSearchPopup("/common/userDisplayPop.do", '?user_id='+ID, "800,500,no");
		}
	} else if (column == 'BUYER_ITEM_NO') { // 품목코드
		//SLOGIC-BEGIN(P04-4034-04)
		if(kepIsValueNull(agent)){
			alert("견적서가 발행되지 않은 품목입니다.");
			return;
		}
		var openflag = "N";
		 if(buyer == "KRHITE0006") {
			 openflag = "Y";
	    }else {
	    	openflag = "N";
	    }
		var fileName = "";
		var param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+agent+"]["+openflag+"]";
		if(buyer == 'KRFAGB0001' || buyer == 'KRFAGB0002' || buyer =='KRFAGB0003' || buyer == 'KRDONG0099' || buyer=="KRSCHA0001") {
			fileName = "RD_04_B_004_01";//"RD_04_M_004_00";
			param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+openflag+"]";
//        		st_buyer="+buyer+"&st_quotation_no="+quotation_no+"&st_quotation_seq="+quotation_seq+"&st_revision="+revision+"&st_open_flag="+open_flag, 
	    }else if(buyer == 'KRILJI0009' || buyer=="KRDAIN0003" || buyer=="KRILSH0001" || buyer=="KRILSH0002" || buyer=="KRILSH0003" || buyer=="KRILSH0004" || buyer=="KRILSI0004" || buyer == 'KRDHIM0003' || buyer=='KRKOOG0001'|| buyer=="KRHWAS0031"|| buyer=="KRSSAN0025"|| buyer=="KRSSAN0028" || buyer=="KRSEOJ0022" || buyer=="KRSEOJ0023" || buyer=="KRSEOJ0024" ) {
	    	fileName = "RD_04_B_004_05";//"RD_04_M_004_01";
//        		st_buyer="+buyer+"&st_quotation_no="+quotation_no+"&st_quotation_seq="+quotation_seq+"&st_revision="+revision+"&st_agent="+agent+"&st_open_flag="+open_flag,
//	    }else if(buyer == 'KRILJI0003' || buyer == 'KRILJI0026' || buyer == 'KRILJI0043'){  //SR14012381	한다연 요청사항으로 제거
//	    	fileName = "RD_04_M_004_02";
//    			st_buyer="+buyer+"&st_quotation_no="+quotation_no+"&st_quotation_seq="+quotation_seq+"&st_revision="+revision+"&st_agent="+agent+"&st_open_flag="+open_flag,
	    }else if(buyer == 'KRYUHA0013'){
	    	fileName = "RD_04_M_001_05";
	    	param =  "["+"${sessionInfo.userId}"+"]["+buyer+"]["+quotation_no+"]";
	    }else {
	    	fileName = "RD_04_M_004_03";
//        		st_buyer="+buyer+"&st_quotation_no="+quotation_no+"&st_quotation_seq="+quotation_seq+"&st_revision="+revision+"&st_agent="+agent+"&st_open_flag="+open_flag,
	    } 
		reportOpen(fileName,param);
		return;	
		//SLOGIC-END
	}else if (column == "QUOTATION_NO" ){ 
		popupSel = "quotationReDetailPop";
		openSearchPopup("/common/mprq/quotationReDetailPop.do", '?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_quotation_seq='+quotation_seq+'&st_revision='+revision+'&st_agent='+agent, "1020,500,no");
	}else if (column == "QUOTATION_SEQ" ){ 
		if((buyer == 'KRDOOD0001') || (buyer == 'KRDOOS0009')|| (buyer == 'KRHWAS0031')){
			openSearchPopup("/mprq/showMasterMpRqPumPrintPop.do","?st_buyer="+buyer+"&st_quotation_no="+quotation_no+"&st_revision="+revision+"&st_agent="+agent,"500,400,no");
			
		} else {
			return;
		}
	
	} else if(column == "REVICNT"){ // 차수
		popupSel = "masterMpRqQuotationUnitpriceHistoryPop";
		openSearchPopup("/mprq/showMasterMpRqQuotationUnitpriceHistoryPop.do", '?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_quotation_seq='+quotation_seq+'&st_revision='+revision, "900,600,no");
	} else if (column == 'AGENT_NAME') { // 협력사
		if (!kepIsValueNull(agent)){
			openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
		}

	}else if (column == "BTOA_REMARK_IMG" ){		
		var st_buyer = mySheet.GetCellValue(Row,"BUYER");
		var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
		var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
		var st_revision = mySheet.GetCellValue(Row,"REVISION");
		//POST PARAM 셋팅		
		document.forms.remarkPostPop.re_buyer.value = st_buyer;
		document.forms.remarkPostPop.re_quotation_no.value = st_quotation_no;
		document.forms.remarkPostPop.re_quotation_seq.value = st_quotation_seq;
		document.forms.remarkPostPop.re_revision.value = st_revision;
		openSearchPopupPost("/mprq/getMasterRemarkPostPop.do", "remarkPostPop", 'getMasterRemarkPostPop', "width=450,height=400,resizable=no,scrollbars=no");		

	}else if (column == "SCM_REMARK_IMG" ){ // SCM비고 
		popupSel = "remarkReturn2Pop"; 
		var scm_remark = mySheet.GetCellValue(Row, "SCM_REMARK");
		openSearchPopup("/common/remarkReturn2Pop.do", '?st_return_remark='+scm_remark+"&st_buyer=" + buyer + "&st_quotation_no="+ quotation_no + "&st_quotation_seq=" + quotation_seq + "&st_revision=" + revision + "&st_gubun=RQ", "600,230,no");

	} else if(column == "CANCEL_REMARK_IMG"){
		var viewType="";
		if (mySheet.GetCellValue(Row,"SOURCING_STATUS") == "합의완료"){
			alert("합의완료건은 취소가 불가능 합니다.");
			return;
		}else if(mySheet.GetCellValue(Row,"SOURCING_STATUS") == "견적취소"){
			if(mySheet.GetCellValue(Row,"CANCEL_REMARK_CODE") != ""){
				viewType="kepRfqCancel_READONLY";	
			}else{
				viewType="READONLY";
			}
		}else{
			viewType="kepRfqCancel";
		}
		
		popupSel = "cancelRemark";
		var cancel_remark = mySheet.GetCellValue(Row, "CANCEL_REMARK");
		var cancel_remark_code = mySheet.GetCellValue(Row, "CANCEL_REMARK_CODE");
		openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType+'&cancel_remark_code='+cancel_remark_code,"500,320,no");
	} else if(column == "IMAGE_KEY_IMG"){
		//SLOGIC-BEGIN(P04-4034-03)
		if (buyer == "KRKORE0254"){
			var image_key = mySheet.GetCellValue(Row, "IMAGE_KEY");
			attach_popup(image_key);
		//SLOGIC-END				
		} else {
			popupSel = "fileUpload";
			var type="RFQ";
			var viewType="R";
			var image_key=mySheet.GetCellValue(Row, "IMAGE_KEY");
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		}
	} else if(column == "SELLER_IMAGE_KEY_IMG"){
		popupSel = "sellerFileUpload";
		var type="RFQ";
		var viewType="R";
		var image_key=mySheet.GetCellValue(Row, "SELLER_IMAGE_KEY");
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	} else if (column == "MSDS_NO" ){ // MSDS 등록 및 매핑
		popupSel = "msdsregmapPop"; 
		
		var msds_no = mySheet.GetCellValue(Row, "MSDS_NO");
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
		var quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
		var revision = mySheet.GetCellValue(Row, "REVISION");
		var description = mySheet.GetCellValue(Row, "DESCRIPTION");
		var specification = mySheet.GetCellValue(Row, "SPECIFICATION");
		var maker_name = mySheet.GetCellValue(Row, "MAKER_NAME");
		var origin_name = mySheet.GetCellValue(Row, "ORIGIN_NAME");
		var unit_measure = mySheet.GetCellValue(Row, "UNIT_MEASURE");
		
		if(kepIsValueNull(msds_no)){
			if(mySheet.GetCellValue(Row, "MSDS_YN") == "1"){
				<%if(getRoleYn == true){%>
					openSearchPopup("/coco/showCommonCoCoMsdsPop.do", '?p_buyer='+buyer+'&p_quotation_no='+quotation_no+'&p_quotation_seq='+quotation_seq+'&p_revision='+revision, "950,600,no");
				<%}%>
			}else{
				alert("MSDS 대상 품목이 아닙니다.");
				return;		
			}
		} else if(msds_no == "MS88888888" || msds_no == "MS99999999"){
			<%if(getRoleYn == true){%>
				openSearchPopup("/coco/showCommonCoCoMsdsPop.do", '?p_buyer='+buyer+'&p_quotation_no='+quotation_no+'&p_quotation_seq='+quotation_seq+'&p_revision='+revision, "950,600,no");
			<%}else{%>
				openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+msds_no+"&st_btn_yn=Y",'750,580,no');
			<%}%>
		} else {
		    openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+msds_no+"&st_btn_yn=Y",'750,580,no');
	    }
		
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
 		}else if(column == "NOTE_MNG_IMG" ){ //특이사항 입력
 			var st_buyer = mySheet.GetCellValue(Row,"BUYER");
 			var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
 			var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
 			var st_revision = mySheet.GetCellValue(Row,"REVISION");
 			openSearchPopup("/mprq/showMasterMpRqQutationRemark.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "850,350,no");
 			return;
 		}else if(column == "ANY_ITEM_MD_REQ_DATE" || column == "ANY_ITEM_MD_DATE"){ //정비요청일시, 정비제출일시
 			var st_buyer = mySheet.GetCellValue(Row,"BUYER");
 			var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
 			var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
 			var st_revision = mySheet.GetCellValue(Row,"REVISION");
 			
 			var item_md_kind = mySheet.GetCellValue(Row,"ANY_ITEM_MD_COMPLETE");
 			item_md_kind = item_md_kind.substr(1,2);
 			
 			if(item_md_kind == "1"){
 				openSearchPopup("/mprq/showMasterMpRqItemMdReqHistPop.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "840,300,no");
 			}else if(item_md_kind == "2"){
 				openSearchPopup("/mprq/showMasterMpRqAfterItemMdReqHistPop.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "840,300,no");
 			}else if(item_md_kind == "3"){
 				openSearchPopup("/mprq/showMasterMpRqNegoItemMdReqHistPop.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "840,300,no");
 			}else{
 				alert("정비요청 이력이 없습니다.");
 				return;
 			}
 		}else if(column == "DM_SENT_DATE" ){ //DM발송일시
 			var st_buyer = mySheet.GetCellValue(Row,"BUYER");
 			var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
 			var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
 			var st_revision = mySheet.GetCellValue(Row,"REVISION");
			openSearchPopup("/mprq/showMasterMpRqQuotationDmRemindHistPop.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "840,300,no");
 		} else if (column == "SG_CNT" ){ // SG지정이력팝업
			popupSel = "sgCntPop";
 			var st_buyer = mySheet.GetCellValue(Row,"BUYER");
 			var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
 			var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
 			var st_revision = mySheet.GetCellValue(Row,"REVISION");

 			var st_popup_url = "/mprq/showMasterMpRqSgDHistPop.do";
			var st_popup_param = "st_buyer@@"+st_buyer+"^||^st_quotation_no@@"+st_quotation_no+"^||^st_quotation_seq@@"+st_quotation_seq+"^||^st_revision@@"+st_revision;
			var st_popup_option = "840,300,no";
			openSearchPopupAppendPost("sgCntPopForm",st_popup_url,st_popup_param,st_popup_option);
 		}
	return;
}

function attach_popup(image_key){
    var left = 0;
    var top = 0;
    var width = 800;
    var height = 400;
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'no';
    var scrollbars = 'yes';
    var resizable = 'no';
//  var loc = "http://safety.koreab2b.com/kr/common/popup/attach_view_pop_doosanmeca.jsp?st_image_key="+image_key;
    var loc = "http://safety.koreab2b.com/file/view.wu?fileUploadId=fileUploadPop&bizType=BOARD&fileUuid="+image_key+"&callback=setFileImage&callbackParam=0%2CCSTMR_ATTCH_FILE_NO_IMAGE%2CCSTMR_ATTCH_FILE_NO&removeBtnUnvisible=false";
    window.open(loc,'attach_popup', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

//헤더 더블클릭시 복사
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	if (checkRows.length == 0){
		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	var arrRow = checkRows.split("|");
	
	if (mySheet.ColSaveName(Col) == "CANCEL_REMARK_IMG"){ // 견적취소
		var value1 = mySheet.GetCellValue(arrRow[0], "CANCEL_REMARK");
		var value2 = mySheet.GetCellValue(arrRow[0], "CANCEL_REMARK_CODE");
		if(kepIsValueNull(value1) && kepIsValueNull(value2)){
			alert("복사할 견적 취소사유를 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "CANCEL_REMARK", value1);
			mySheet.SetCellValue(arrRow[idx], "CANCEL_REMARK_CODE", value2);
			mySheet.SetCellValue(arrRow[idx], "CANCEL_REMARK_IMG", (value2!="")? remarkOn : remarkOff);
		}
	}
}	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyerMulti") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	
	} else if(popupSel == "cancelRemark") {	//견적 취소
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK_IMG', (value2!="")? remarkOn : remarkOff);
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK_CODE', value2);
		
	} else if(popupSel == "remarkReturn2Pop") {	// SCM비고
		mySheet.SetCellValue(grbRow, 'SCM_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'SCM_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
		
	} else if (popupSel == "maker"){ // 제조사
		$("#st_maker_code").val(value1);
		$("#st_maker_name").val(value2);
		
	} else if(popupSel=="sg_info"){
		$("#st_c_sg_id").val(value1);
		$("#st_c_sg_nm").val(value2);
		
	}
	grbRow="";	//초기화
}

function setTermPassFlag(){
	if($('#st_checkbox')[0].checked) {
		$("#st_term_pass_flag").val("Y");
		$("#st_date_type").val("BTOA");
		
	} else {
		$("#st_term_pass_flag").val("N");
		
	}
}
//선입고 체크 데이터 치환
function setPreGrFlag(){
	if($('#st_gr_checkbox')[0].checked) {
		$("#st_pre_gre_flag").val("Y");
	} else {
		$("#st_pre_gre_flag").val("N");
		
	}
}
//운영비고일괄 입력
function setRemarkPopupReturn(val){
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	for (var i=0; i<arrRow.length; i++){
		mySheet.SetCellValue(arrRow[i],"ADMIN_REMARK",val);
	}
	kepSave(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqReqQuotAdminRemark.do" , "SELECTED" );
}

// 견적지연사유 팝업 리턴
function setDelayPopupReturn(){
	mySheet.SetCellValue(grbRow, 'DELAY_REASON_IMG', 9);
}

// ANY 정비제출 저장
function setAnyItemChgPopupReturn(val){
	gubun = "any_item_chg";

	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	var st_send_item_md_kind = "";
	var st_admin_remark = "";
	
	for (var i=0; i<arrRow.length; i++){
		st_send_item_md_kind = mySheet.GetCellValue(arrRow[i],"ANY_ITEM_MD_COMPLETE");
		st_send_item_md_kind = st_send_item_md_kind.substr(1,2);
		
		if(st_send_item_md_kind == "1"){
			st_admin_remark = "[품목정비제출] "+val;
		}else if(st_send_item_md_kind == "2"){
			st_admin_remark = "[추가정비제출] "+val;
		}else if(st_send_item_md_kind == "3"){
			st_admin_remark = "[네고정비제출] "+val;
		}else{
			st_admin_remark = val;
		}
		
		mySheet.SetCellValue(arrRow[i],"ADMIN_REMARK",st_admin_remark);
	}

	kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqAnyItmCheSend.do" , "SELECTED" );
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>견적진행조회</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
		    <span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
   		</div>        	
        <!--VOC등록 FORM POST-->
    	<form name="vocRegPop" id="vocRegPop" method="post">
    		<input type="hidden" name="st_voc_buyer" id="st_voc_buyer" value="">
    		<input type="hidden" name="st_voc_buyer_name" id="st_voc_buyer_name" value="">
    		<input type="hidden" name="st_type" id="st_type" value="">
    		<input type="hidden" name="st_sg_mng_id" id="st_sg_mng_id" value="">
    		<input type="hidden" name="st_quotation_no_arr" id="st_quotation_no_arr" value="">
		</form>
		
		<!--견적비고 FORM POST-->
    	<form name="remarkPostPop" id="remarkPostPop" method="post">
    		<input type="hidden" name="re_buyer" id="re_buyer" value="">
    		<input type="hidden" name="re_quotation_no" id="re_quotation_no" value="">
    		<input type="hidden" name="re_quotation_seq" id="re_quotation_seq" value="">
    		<input type="hidden" name="re_revision" id="re_revision" value="">
    		<input type="hidden" name="viewType" id="viewType" value="R">
    		<input type="hidden" name="st_title" id="st_title" value="ATOA">    		
		</form>		
		
		<!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="USR_ID" name="USR_ID"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_department" name="st_department"  value="${sessionInfo.department}">
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_type" name="st_user_type"  value="${sessionInfo.userType}">
			<input type="hidden" name="st_sour_dept_yn"  id="st_sour_dept_yn" value ="<%=st_sour_dept_yn%>">
			<input type="hidden" name="st_sour_supl_yn"  id="st_sour_supl_yn" value ="<%=st_sour_supl_yn%>">
			<input type="hidden" name="st_sour_sm_yn"  id="st_sour_sm_yn" value ="<%=st_sour_sm_yn%>">
			<input type="hidden" name="st_sour_dsm_yn"  id="st_sour_dsm_yn" value ="<%=st_sour_dsm_yn%>">
            	<table  class="cont_t_list01" >
					<caption>견적진행조회</caption>
					<colgroup>
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
                        <col width="21%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>
								<label for="b_code" class="hidden">기간선택</label>
						  			<select name = "st_date_type" id="st_date_type" class="TitSelect" style="height:20px;">
							      		<option value="BTOA" selected="selected">견적의뢰일</option>
										<option value="ATOS" >견적요청일</option>
										<option value="BTOAE" >회신요청일</option>
										<option value="ATOSE" >견적마감일</option>
										<option value="ATOB" >견적제출일</option>
		                           </select>
							</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								-
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
								<span class="btn_month"><a href="javascript:kepFromMonth('st_from_date','st_to_date','1')">-1개월</a></span> 
								<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox" onclick="setTermPassFlag()">&nbsp;기간무시&nbsp;
								<input type="checkbox"  class="Noborder" name="st_gr_checkbox" id="st_gr_checkbox" onclick="setPreGrFlag()">&nbsp;선입고
								<input type="hidden" name="st_term_pass_flag" id="st_term_pass_flag" value="N">
								<input type="hidden" name="st_pre_gre_flag" id="st_pre_gre_flag" value="N">
							</td>
							<th><font color="#FF6600">*</font>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:55%" value="" readonly onclick="javascript:doPop('buyerMulti');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:55%" value="">
								<a href="javascript:doPop('buyerMulti');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							
						</tr>
						<tr> 
							<th>견적번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_quotation_no" name="st_quotation_no" style="width:87%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
							</td>
							<th>담당자</th>
							<td>
								<select id="st_kep_user_id" name="st_kep_user_id" style="width:90%;height:20px"></select>
							</td>
							<th>진행상태</th>
							<td>
									<!-- 다중선택콤보(공통) - input박스의 type은 hidden으로 생성 할것 , style, class는 select 박스에 상속 됨. -->
									<input type="hidden" name="st_status" id="st_status" value ="" style="width:200px;">
							</td>
						</tr>
						<tr> 
							<th>요청자</th>
							<td>
								<input type="text" class="input_type_text" id="st_btoa_user_name" name="st_btoa_user_name" style="width:87%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
							</td>
							<th>품목명/규격</th>
							<td>
								<input type="text" class="input_type_text" id="st_desc_spec" name="st_desc_spec" style="width:87%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
							</td>
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:87%;" value="" onkeydown="kepEnter()">
							</td>
						</tr>
						<tr>
							<th>제조사</th>
							<td>
								<input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:55%" value="" readonly onclick="javascript:doPop('maker');">
								<input type="hidden" name="st_maker_code" id="st_maker_code" style="width:55%" value="">
								<a href="javascript:doPop('maker');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_maker_code','st_maker_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<th>PLANT 담당자</th>
							<td>
								<select id="st_plant_user_id" name="st_plant_user_id" style="width:90%;height:20px"></select>
							</td>
							<th>SG</th>
							<td>
								<input type="text" id="st_c_sg_nm" name="st_c_sg_nm" class="input_type_text" style="width:71%;" value=""  readonly onclick="javascript:doPop('sg_info');">
								<input type="hidden" name="st_c_sg_id" id="st_c_sg_id" style="width:80%" value="">
								<a href="javascript:doPop('sg_info');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_c_sg_id','st_c_sg_nm');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
						<tr>
							<th>견적담당자</th>
							<td>
								<select id="st_job_transfer_id" name="st_job_transfer_id" style="width:90%;height:20px"></select>
							</td>
							<th>표준카탈로그코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_stdcatlg_id" name="st_stdcatlg_id" style="width:87%;" value="" onkeydown="kepEnter()">
							</td>
							<th colspan="3">
								<input type="checkbox"  class="Noborder" name="st_md_except_check" id="st_md_except_check">&nbsp;정비 미제출 제외&nbsp;
								<input type="checkbox"  class="Noborder" name="st_md_req_check" id="st_md_req_check">&nbsp;정비 요청건만 조회&nbsp;
								<input type="checkbox"  class="Noborder" name="st_md_req_mail_check" id="st_md_req_mail_check">&nbsp;DM미발송 조회&nbsp;
								<input type="hidden" name="st_md_except_flag" id="st_md_except_flag" value="N">
								<input type="hidden" name="st_md_req_flag" id="st_md_req_flag" value="N">
								<input type="hidden" name="st_md_req_mail_flag" id="st_md_req_mail_flag" value="N">
							</th>
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
				</select>
				&nbsp;<img src="/resources/images/icon_y.gif"> 견적진행중
				&nbsp;<img src="/resources/images/icon_g.gif"> 납기내 견적완료
				&nbsp;<img src="/resources/images/icon_r.gif"> 견적지연
			</span>
			<br>
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
  	          	<span class="fl">
  					<span class="btn_04 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  					<span class="btn_07 mr04"><a href="javascript:doPop('buyercatalog');">고객사카탈로그 조회</a></span>
  					<span class="btn_04 mr04"><a href="javascript:doPop('quotationDmSend');">고객사DM발송</a></span>
  				</span>
  				
  				<span class="fr">
  					<span class="btn_06"><a href="javascript:doPop('itemChgSend');">정비제출</a></span>
  					<span class="btn_06"><a href="javascript:doPop('remark');">운영특이사항 입력</a></span>
  					<span class="btn_04"><a href="javascript:doPop('regVoc');">VOC등록</a></span>
  				    <span class="btn_06 mr04"><a href="javascript:doAction('msds');">MSDS요청(협력사)</a></span>
  				
  				<%  //구매팀 견적취소 삭제 - 조직개편 2025.08.18
					if(st_sour_dept_yn.equals("N")){
				%>
					<span class="btn_02"><a href="javascript:doAction('save');">견적복원</a></span>
  					<span class="btn_02"><a href="javascript:doAction('cancel');">견적취소</a></span>
  				<%
					}
				%>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
