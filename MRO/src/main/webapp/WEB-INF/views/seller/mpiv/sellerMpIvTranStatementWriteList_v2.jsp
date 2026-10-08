<%--
**********************************************
* 메뉴 : 납품관리>거래명세서
* 화면 : 거래명세서
* 기능 : 거래명세서를 생성하기 위한 화면
* 프로그램 ID : SU0503001
* 담당자 : 최찬규
* 착수일 : 2025-10-01
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
 
 

<%
	//공통
	@SuppressWarnings (value="unchecked")
	String menuId = (String) request.getParameter("menuId");
	String user_id      = _sessionInfo.getUserId();
	String com_code 	= _sessionInfo.getComCode();

	if(myMenuListHeader != null){ //null이 아닌 경우에만 체크
    	for(int i = 0; i<myMenuListHeader.size(); i++){
    		if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
    			myMenuFlag = true;
    			break;
    		}
    	}
    }
	
	// 운영사 업무대행에서 호출시 사용. (p_proxy_yn == Y)
	String p_proxy_yn	= CommonUtil.nvl((String)request.getAttribute("st_proxy_yn"));
	String p_agent		= CommonUtil.nvl((String)request.getAttribute("st_agent"));
	String p_user_id	= CommonUtil.nvl((String)request.getAttribute("st_add_user_id"));
	String p_kep_id		= CommonUtil.nvl(_sessionInfo.getUserId());
	
	// TR 협력사 납품 변경 팝업 확인
	String st_tr_notice_check_yn = "N";
	
	if(!p_proxy_yn.equals("Y")){
		p_agent = CommonUtil.nvl(_sessionInfo.getComCode());
		p_user_id	= CommonUtil.nvl(_sessionInfo.getUserId());
		
		boolean st_tr_notice_check = CommonUtil.getCodeCheckReturn("TRNOTICE", p_user_id);
		if(st_tr_notice_check == true){
			st_tr_notice_check_yn = "Y";
		}else{
			st_tr_notice_check_yn = "N";
		}
	}
%> 

<script type="text/javascript">
var today = kepGetNowTimeStr("YYYYMMDD","");
// var fromDate = kepToDateAdd("7","M","noslash");
// var toDate = kepToDateAdd("7","P","noslash");

var mySheet0 = new ibsheetObject();
var mySheet1 = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var mySheet3 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

var currIndex=0;
var Sheet;


var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var g_query = "";
//최초 화면 함수 
function kep_onload_view(){
	Sheet = mySheet0; //첫화면에선 mySheet0;
	
	//초기 날짜 셋팅
	var indexLength = $("input[name=st_from_date]").length;
	for(var i = 0; i<indexLength; i++){
		if($("input[name=st_from_date]").eq(i).val() ==  ""){
			$("input[name=st_from_date]").eq(i).val(kepToMonthAdd("3","M"));
			$("input[name=st_to_date]").eq(i).val(kepGetNowTimeStr('YYYYMMDD','/'));
		}
	}
	
	//거래명세서 출력 화면은 1개월로
	kepMonth_v2('st_from_date_3','st_to_date_3','1');
	
	var initsheet0 = {};
	initsheet0.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet0.Cols = [
						{ Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
						,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,		Hidden:false}
						,{ Align:"Center",	SaveName:"PORS_ADD_DATE",		Header:"수주접수일",				Type:"Date",		Width:100,	Edit:false,		Hidden:false,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"PO_NO",				Header:"발주번호",				Type:"Button",		Width:100,	Edit:false,		Hidden:false,ClassName:'Type02'}
						,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",				Type:"Text", 		Width:200,	Edit:false,		Hidden:false}
						,{ Align:"Center",	SaveName:"BUYER",				Header:"고객사코드",			Type:"Text",		Width:80,	Edit:false,	 	Hidden:true}
						,{ Align:"Center",	SaveName:"PROCESS_TYPE_TEXT",	Header:"거래유형",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"PO_CREATE_DATE",		Header:"발주일",				Type:"Date",		Width:100,	Edit:false,		Hidden:false,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"RD_DATE",				Header:"고객수령희망일",			Type:"Date",		Width:100,	Edit:false,		Hidden:false,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"DS_DATE",				Header:"납품예정일",			Type:"Date",		Width:100,	Edit:false,		Hidden:false,Format:"yyyy-MM-dd"}
						,{ Align:"Left",	SaveName:"DESCRIPTION_INFO",	Header:"품목명",			Type:"Text",		Width:200,	Edit:false,	 	Hidden:false}
						,{ Align:"Right",	SaveName:"DS_ITEM_QTY",			Header:"품목수",				Type:"Int",			Width:80,	Edit:false,		Hidden:true}
						,{ Align:"Right",	SaveName:"AGENT_SUM_PRICE",		Header:"발주총금액",			Type:"Float",		Width:100,	Edit:false,		Hidden:false, Format:"${priceFormat}"}
						,{ Align:"Center",	SaveName:"SBUTTON",				Header:"거래명세서",			Type:"Image",		Cursor:"Pointer",Width:120,	Edit:false,		Hidden:false,BackColor:"${optColor}"}
						,{ Align:"Left",	SaveName:"DELIVERY_REMARK",		Header:"배송특이사항",			Type:"Text",		Width:395,	Edit:false,		Hidden:false}
						,{ Align:"Left",	SaveName:"KEP_USER_INFO",		Header:"KeP담당자",			Type:"Text",		Width:160,	Edit:false,		Hidden:false}
						,{ Align:"Center",	SaveName:"ST_DATE",				Header:"표준납품일",			Type:"Date",		Width:100,	Edit:false,		Hidden:true,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"BUYER2",				Header:"BUYER2",			Type:"Text",		Width:80,	Edit:false,	 	Hidden:true}
						,{ Align:"Center",	SaveName:"POP_UP_URL",			Header:"POP_UP_URL",		Type:"Text",		Width:350,	Edit:false,		Hidden:true}
						,{ Align:"Center",	SaveName:"POP_UP_TYPE",			Header:"POP_UP_TYPE",		Type:"Text",		Width:350,	Edit:false,		Hidden:true}
						,{ Align:"Center",	SaveName:"LEGACY_PO_NO",		Header:"LEGACY_PO_NO",		Type:"Text",		Width:350,	Edit:false,		Hidden:true}
						,{ Align:"Center",	SaveName:"TR_BUYER",			Header:"TR_BUYER",			Type:"Text",		Width:350,	Edit:false,		Hidden:true}
						,{ Align:"Center",	SaveName:"SELLER",				Header:"SELLER",			Type:"Text",		Width:350,	Edit:false,		Hidden:true}
						,{ Align:"Center",	SaveName:"REF_PR_NO",			Header:"REF_PR_NO",			Type:"Text",		Width:350,	Edit:false,		Hidden:true}
						,{ Align:"Center",	SaveName:"DELY_TO_LOCATION",	Header:"DELY_TO_LOCATION",	Type:"Text",		Width:350,	Edit:false,		Hidden:true}
						,{ Align:"Center",	SaveName:"H_DS_FLAG",			Header:"H_DS_FLAG",			Type:"Text",		Width:350,	Edit:false,		Hidden:true}
						,{ Align:"Center",	SaveName:"AGENT",				Header:"AGENT",				Type:"Text",		Width:350,	Edit:false,		Hidden:true}
						,{ Align:"Center",	SaveName:"BUYER_SLG",			Header:"BUYER_SLG",			Type:"Text",		Width:350,	Edit:false,		Hidden:true}
						,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"PROCESS_TYPE",		Type:"Text",		Width:350,	Edit:false,		Hidden:true}
						,{ Align:"Center",	SaveName:"ADD_USER_ID",			Header:"ADD_USER_ID",		Type:"Text",		Width:350,	Edit:false,		Hidden:true}
						,{ Align:"Center",	SaveName:"INFO_CHANGE_REQ_YN",	Header:"INFO_CHANGE_REQ_YN",Type:"Text",		Width:350,	Edit:false,		Hidden:true}
						,{ Align:"Center",	SaveName:"AGENT_RPT_URL",		Header:"AGENT_RPT_URL",		Type:"Text",		Width:350,	Edit:false,		Hidden:true}
	];
	
	var initsheet1 = {};
	initsheet1.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet1.Cols = [
					{ Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,		Hidden:false}
					,{ Align:"Center",	SaveName:"PORS_ADD_DATE",		Header:"수주접수일",				Type:"Date",		Width:100,	Edit:false,		Hidden:false,Format:"yyyy-MM-dd"}
					,{ Align:"Center",	SaveName:"PO_NO",				Header:"발주번호",				Type:"Text",		FontColor:"#3a72c7", Cursor:"Pointer",Width:100,	Edit:false,		Hidden:false}
					,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",				Type:"Text",		Width:200,	Edit:false,		Hidden:false}							
					,{ Align:"Center",	SaveName:"BUYER",				Header:"고객사코드",			Type:"Text",		Width:80,	Edit:false,	 	Hidden:true}
					,{ Align:"Center",	SaveName:"BUYER2",				Header:"BUYER2",			Type:"Text",		Width:80,	Edit:false,	 	Hidden:true}
					,{ Align:"Center",	SaveName:"PROCESS_TYPE_TEXT",	Header:"거래유형",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"PO_SEQ",				Header:"발주항번",				Type:"Text",		Width:150,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"DS_DATE",				Header:"납품예정일",			Type:"Date",		Width:100,	Edit:false,		Hidden:false,Format:"yyyy-MM-dd"}
					,{ Align:"Center",	SaveName:"PO_CREATE_DATE",		Header:"발주일",				Type:"Date",		Width:100,	Edit:false,		Hidden:false,Format:"yyyy-MM-dd"}
					,{ Align:"Center",	SaveName:"RD_DATE",				Header:"고객수령희망일",			Type:"Date",		Width:100,	Edit:false,		Hidden:false,Format:"yyyy-MM-dd"}
					,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text", 		Width:140,	Edit:false,		Hidden:false}
					,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"거래유형",				Type:"Combo",		Width:90,	Edit:false,		Hidden:true,	ComboText:"직납|TR",	ComboCode:"0|2"}
					,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"품목명",				Type:"Text",		Width:200,	Edit:false,		Hidden:false}
					,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",				Type:"Text",		Width:420,	Edit:false,		Hidden:false}
					,{ Align:"Left",	SaveName:"MAKER_PART_NO",		Header:"모델번호",				Type:"Text",		Width:110,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"ITEM_PO_REMARK",		Header:"품목비고",				Type:"Text",		Width:180,	Edit:false,		Hidden:false}
					,{ Align:"Right",	SaveName:"INV_POSS_QTY",		Header:"납품수량",				Type:"Float",		Width:70,	Edit:false,		Hidden:false}
					,{ Align:"Right",	SaveName:"CD_QTY",				Header:"납품수량",				Type:"Float",		Width:70,	Edit:false,		Hidden:true}
					,{ Align:"Right",	SaveName:"ITEM_QTY",			Header:"발주수량",				Type:"Float",		Width:70,	Edit:false,		Hidden:false}
					,{ Align:"Right",	SaveName:"AGENT_PRICE",			Header:"단가",				Type:"Float",		Width:90,	Edit:false,		Hidden:false,	Format:"${priceFormat}"}
// 					,{ Align:"Right",	SaveName:"INV_POSS_QTY",		Header:"INV_POSS_QTY",				Type:"Float",		Width:60,	Edit:false,		Hidden:true}
					
					,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:60,	Edit:false,		Hidden:false}
					,{ Align:"Right",	SaveName:"AGENT_TOT_AMT",		Header:"주문금액",				Type:"Float",		Width:100,	Edit:false,		Hidden:false, Format:"${priceFormat}"}
					,{ Align:"Left",	SaveName:"KEP_USER_INFO",		Header:"KeP담당자",			Type:"Text",		Width:200,	Edit:false,		Hidden:false}
					,{ Align:"Center",	SaveName:"CD_QTY",				Header:"CD_QTY",			Type:"Float",		Width:200,	Edit:false,		Hidden:true}
					
					,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",	Header:"BYIT_COMORG_CODE",	Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"CONTRACT_NO",			Header:"CONTRACT_NO",		Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"CONTRACT_SEQ",		Header:"CONTRACT_SEQ",		Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELLER",				Header:"SELLER",			Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					
					,{ Align:"Center",	SaveName:"DS_FLAG",				Header:"DS_FLAG",			Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"COD_CHECK",			Header:"MSDS대상",			Type:"Text",		Width:80,	Edit:false,		Hidden:false}
					,{ Align:"Center",	SaveName:"MSDS_CHECK",			Header:"MSDS매핑필요",			Type:"Text",		Width:110,	Edit:false,		Hidden:false}
					,{ Align:"Center",	SaveName:"REQ_CHECK",			Header:"REQ_CHECK",			Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"TEMP_REQ_CHECK",		Header:"TEMP_REQ_CHECK",			Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					
					,{ Align:"Center",	SaveName:"TEMP_CHECK",			Header:"TEMP_CHECK",		Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"HARMFUL_CHECK",		Header:"유해화학물질",			Type:"Text",		Width:100,	Edit:false,		Hidden:false}
					,{ Align:"Center",	SaveName:"SG118_CHECK",			Header:"SG118_CHECK",		Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"TEMP_COND",			Header:"TEMP_COND",			Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"QUERY_TEXT",			Header:"QUERY_TEXT",		Type:"Text",		Width:80,	Edit:false,	Hidden:true}
					
					,{ Align:"Center",	SaveName:"BUY_CLOSE_DATE_CHK",	Header:"BUY_CLOSE_DATE_CHK",Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"P070000033",			Header:"P070000033",		Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"P060000080",			Header:"P060000080",		Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"POP_UP_URL",			Header:"POP_UP_URL",		Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"POP_UP_TYPE",			Header:"POP_UP_TYPE",		Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					
					,{ Align:"Center",	SaveName:"W001_FLAG",			Header:"W001_FLAG",			Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"GROUP_NO",			Header:"GROUP_NO",			Type:"Int",			Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Left",	SaveName:"SIZE_YN",				Header:"SIZE_YN",			Type:"Text",		Width:60,	Edit:false,		Hidden:true}
					,{ Align:"Left",	SaveName:"SIZE_LEN",			Header:"SIZE_LEN",			Type:"Text",		Width:60,	Edit:false,		Hidden:true}
					,{ Align:"Left",	SaveName:"SIZE_QTY",			Header:"SIZE_QTY",			Type:"Text",		Width:60,	Edit:false,		Hidden:true}
	];
	var initsheet2 = {};
	initsheet2.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet2.Cols = [
					{ Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,		Hidden:false}
					,{ Align:"Center",	SaveName:"PORS_ADD_DATE",		Header:"수주접수일",				Type:"Date",		Width:100,	Edit:false,		Hidden:false,Format:"yyyy-MM-dd"}
					,{ Align:"Center",	SaveName:"PO_NO",				Header:"발주번호",				Type:"Text",		FontColor:"#3a72c7", Cursor:"Pointer",Width:100,	Edit:false,		Hidden:false}
					,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",				Type:"Text", FontColor:"#3a72c7", Cursor:"Pointer",		Width:200,	Edit:false,		Hidden:false}							
					,{ Align:"Center",	SaveName:"BUYER",				Header:"고객사코드",			Type:"Text",		Width:80,	Edit:false,	 	Hidden:true}
					,{ Align:"Center",	SaveName:"BUYER2",				Header:"BUYER2",			Type:"Text",		Width:80,	Edit:false,	 	Hidden:true}
					,{ Align:"Center",	SaveName:"PROCESS_TYPE_TEXT",	Header:"거래유형",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"PO_SEQ",				Header:"발주항번",				Type:"Text",		Width:150,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"REF_ADD_USER_NAME",	Header:"요청자",			Type:"Text",		Width:60,	Edit:false,		Hidden:false}
					,{ Align:"Center",	SaveName:"REF_ADD_USER_ID",				Header:"REF_ADD_USER_ID",			Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Left",	SaveName:"DELY_TO_LOCATION",		Header:"납품장소",			Type:"Text",		Width:510,	Edit:false,		Hidden:false}
					,{ Align:"Center",	SaveName:"DS_DATE",				Header:"납품예정일",			Type:"Date",		Width:100,	Edit:false,		Hidden:false,Format:"yyyy-MM-dd"}
					,{ Align:"Center",	SaveName:"PO_CREATE_DATE",		Header:"발주일",				Type:"Date",		Width:100,	Edit:false,		Hidden:false,Format:"yyyy-MM-dd"}
					,{ Align:"Center",	SaveName:"RD_DATE",				Header:"고객수령희망일",			Type:"Date",		Width:100,	Edit:false,		Hidden:false,Format:"yyyy-MM-dd"}
					,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text", FontColor:"#3a72c7", Cursor:"Pointer",		Width:100,	Edit:false,		Hidden:false}
					,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"거래유형",				Type:"Combo",		Width:90,	Edit:false,		Hidden:true,	ComboText:"직납|TR",	ComboCode:"0|2"}
					,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"품목명",				Type:"Text",		Width:200,	Edit:false,		Hidden:false}
					,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",				Type:"Text",		Width:370,	Edit:false,		Hidden:false}
					,{ Align:"Left",	SaveName:"MAKER_PART_NO",		Header:"모델번호",				Type:"Text",		Width:110,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"ITEM_PO_REMARK",		Header:"품목비고",				Type:"Text",		Width:180,	Edit:false,		Hidden:false}
					,{ Align:"Right",	SaveName:"DS_INV_QTY",			Header:"납품수량",				Type:"Float",		Width:70,	Edit:false,		Hidden:false}
					,{ Align:"Right",	SaveName:"ITEM_QTY",			Header:"발주수량",				Type:"Float",		Width:70,	Edit:false,		Hidden:false}
					,{ Align:"Right",	SaveName:"AGENT_PRICE",			Header:"단가",				Type:"Float",		Width:90,	Edit:false,		Hidden:false,	Format:"${priceFormat}"}
					,{ Align:"Center",	SaveName:"INV_POSS_QTY",		Header:"INV_POSS_QTY",				Type:"Float",		Width:200,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"CD_QTY",				Header:"CD_QTY",			Type:"Float",		Width:200,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:60,	Edit:false,		Hidden:false}
					,{ Align:"Right",	SaveName:"AGENT_TOT_AMT",		Header:"주문금액",				Type:"Float",		Width:100,	Edit:false,		Hidden:false, Format:"${priceFormat}"}
					,{ Align:"Left",	SaveName:"KEP_USER_INFO",		Header:"KeP담당자",			Type:"Text",		Width:200,	Edit:false,		Hidden:false}
					,{ Align:"Center",	SaveName:"IV_QTY",		Header:"IV_QTY",				Type:"Float",		Width:200,	Edit:false,		Hidden:true}
					
					
					,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",	Header:"BYIT_COMORG_CODE",	Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"CONTRACT_NO",			Header:"CONTRACT_NO",		Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"CONTRACT_SEQ",		Header:"CONTRACT_SEQ",		Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELLER",				Header:"SELLER",			Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"LEGACY_PO_NO",				Header:"LEGACY_PO_NO",			Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"PURCHASER_ID",				Header:"PURCHASER_ID",			Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"TR_BUYER",				Header:"TR_BUYER",			Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					
					,{ Align:"Center",	SaveName:"DS_FLAG",				Header:"DS_FLAG",			Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"DS_YN",				Header:"DS_YN",				Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					
					,{ Align:"Center",	SaveName:"COD_CHECK",			Header:"COD_CHECK",			Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"MSDS_CHECK",			Header:"MSDS_CHECK",		Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"REQ_CHECK",			Header:"REQ_CHECK",			Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"TEMP_REQ_CHECK",			Header:"TEMP_REQ_CHECK",			Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					
					,{ Align:"Center",	SaveName:"POP_KEY",			Header:"POP_KEY",			Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					
					,{ Align:"Center",	SaveName:"BUY_CLOSE_DATE_CHK",	Header:"BUY_CLOSE_DATE_CHK",Type:"Text",		Width:80,	Edit:false,		Hidden:true}
	];
	
	var initsheet3 = {};
	initsheet3.Cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge,PrevColumnMergeMode:0,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet3.Cols = [
					{ Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true,ColMerge:0}
					,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,		Hidden:false,ColMerge:0}
					,{ Align:"Center",	SaveName:"IVDT_ADD_DATE",		Header:"거래명세서 생성일",			Type:"Date",		Width:120,	Edit:false,		Hidden:false,Format:"yyyy-MM-dd",ColMerge:0}
					,{ Align:"Center",	SaveName:"STATUS_BUTTON",		Header:"진행상태",				Type:"Image",		Cursor:"Pointer",Width:120,	Edit:false,		Hidden:false,ColMerge:0}
					,{ Align:"Center",	SaveName:"STATUS",				Header:"진행상태",				Type:"Text",		Width:150,	Edit:false,		Hidden:true,ColMerge:0}
					,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",				Type:"Text",		Width:200,	Edit:false,		Hidden:false,ColMerge:0}							
					,{ Align:"Center",	SaveName:"BUYER",				Header:"고객사코드",			Type:"Text",		Width:80,	Edit:false,	 	Hidden:true}
					,{ Align:"Center",	SaveName:"BUYER2",				Header:"BUYER2",			Type:"Text",		Width:80,	Edit:false,	 	Hidden:true}
					,{ Align:"Center",	SaveName:"PROCESS_TYPE_TEXT",	Header:"거래유형",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"INV_NO",				Header:"거래명세서번호",			Type:"Button",		Width:100,	Edit:false,		Hidden:false,ClassName:'Type02',ColMerge:1}
					,{ Align:"Center",	SaveName:"PO_NO",				Header:"발주번호",				Type:"Button",		Width:100,	Edit:false,		Hidden:false,ClassName:'Type02',ColMerge:0}
					,{ Align:"Center",	SaveName:"INVOICE_DATE",		Header:"납품일",				Type:"Date",		Width:100,	Edit:false,		Hidden:true,Format:"yyyy-MM-dd",ColMerge:0}
					,{ Align:"Center",	SaveName:"PARCEL_YN_TEXT",		Header:"배송유형",				Type:"Text",		Width:65,	Edit:false,		Hidden:false,ColMerge:0}
					,{ Align:"Left",	SaveName:"DESCRIPTION_INFO",	Header:"품목명",				Type:"Text",			Width:230,	Edit:false,	 	Hidden:false,ColMerge:0}
					,{ Align:"Center",	SaveName:"PARCEL_YN",			Header:"PARCEL_YN",			Type:"Text",		Width:80,	Edit:false,		Hidden:true,ColMerge:0}
					,{ Align:"Center",	SaveName:"PRINT_SIZE",			Header:"라벨출력방식",			Type:"Combo",		Width:150,	Edit:true,		Hidden:true,	ComboText:"선택|일반프린터(A4 4분할)|라벨프린터(10x10cm)",	ComboCode:"|N|L",ColMerge:0}
					,{ Align:"Right",	SaveName:"KTAG_BOX_QTY",		Header:"박스수량",				Type:"Int",			Width:70,	Edit:true,		EditLen:2,Hidden:false,ColMerge:0,BackColor:"${optColor}"}
					,{ Align:"Center",	SaveName:"SBUTTON",				Header:"거래명세서",			Type:"Button",		Width:120,	Edit:false,		Hidden:false,ClassName:'Type07',ColMerge:0,BackColor:"${optColor}"}
					,{ Align:"Center",	SaveName:"SBUTTON2",			Header:"품목라벨",				Type:"Button",		Width:120,	Edit:false,		Hidden:false,ClassName:'Type07',ColMerge:0,BackColor:"${optColor}"}
					,{ Align:"Right",	SaveName:"DS_ITEM_CNT",			Header:"납품수량",				Type:"Int",			Width:70,	Edit:false,		Hidden:false,ColMerge:0}
					,{ Align:"Right",	SaveName:"PO_AMT",				Header:"납품총금액",			Type:"Float",		Width:100,	Edit:false,		Hidden:false, Format:"${priceFormat}",ColMerge:0}
					,{ Align:"Center",	SaveName:"RD_DATE",				Header:"고객수령희망일",			Type:"Date",		Width:100,	Edit:false,		Hidden:false,Format:"yyyy-MM-dd",ColMerge:0}
					,{ Align:"Center",	SaveName:"DS_DATE",				Header:"납품예정일",			Type:"Date",		Width:100,	Edit:false,		Hidden:false,Format:"yyyy-MM-dd",ColMerge:0}
					,{ Align:"Left",	SaveName:"KEP_USER_INFO",		Header:"KeP담당자",			Type:"Text",		Width:160,	Edit:false,		Hidden:false,ColMerge:0}
					
					,{ Align:"Center",	SaveName:"PORS_DATE",			Header:"PORS_DATE",			Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"IVDT_DATE",			Header:"IVDT_DATE",			Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"DELIVERY_ADD_DATE",	Header:"DELIVERY_ADD_DATE",	Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"DELIVERY_DATE",		Header:"DELIVERY_DATE",		Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"KTAG_YN",				Header:"KTAG_YN",		Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"RPT_URL",				Header:"거래명세서RD",		Type:"Text",		Width:200,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"PO_CREATE_DATE",		Header:"발주일",				Type:"Date",		Width:100,	Edit:false,		Hidden:true,Format:"yyyy-MM-dd"}
					,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"거래유형",				Type:"Combo",		Width:90,	Edit:false,		Hidden:true,	ComboText:"직납|TR",	ComboCode:"0|2"}
					,{ Align:"Center",	SaveName:"PO_REMARK",			Header:"PO_REMARK",			Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELLER",				Header:"SELLER",			Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"PURCHASER_ID",		Header:"PURCHASER_ID",			Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"NO_TAG_CHECK_YN",		Header:"입고라벨미사용고객사",			Type:"Text",		Width:200,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"NO_ITEMTAG_CHECK_YN",		Header:"품목라벨자체사용고객사",			Type:"Text",		Width:200,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"P070000034",		Header:"고객사고유품목라벨고객사",			Type:"Text",		Width:200,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"DHIM_LEGACY_PO_NO",		Header:"DHIM_LEGACY_PO_NO",		Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"SOLB_IF_BUYER",		Header:"SOLB_IF_BUYER",		Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"LEGACY_PO_NO",		Header:"LEGACY_PO_NO",		Type:"Text",		Width:350,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"REF_IF_NO",			Header:"REF_IF_NO",			Type:"Text",		Width:80,	Edit:false,	 	Hidden:true}
					,{ Align:"Center",	SaveName:"TR_BUYER",			Header:"TR_BUYER",			Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"DELY_TO_LOCATION",	Header:"DELY_TO_LOCATION",	Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"ADD_USER_ID",			Header:"ADD_USER_ID",		Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"DI_REMAIN_QTY",		Header:"DI_REMAIN_QTY",		Type:"Float",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"GR_REMAIN_QTY",		Header:"GR_REMAIN_QTY",		Type:"Float",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"DELIVERY_QTY",		Header:"DELIVERY_QTY",		Type:"Float",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"GR_QTY",				Header:"GR_QTY",			Type:"Float",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"WMS_GR_QTY",			Header:"WMS_GR_QTY",		Type:"Float",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"REF_PR_NO",			Header:"REF_PR_NO",			Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"REF_NO",				Header:"REF_NO",			Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"LEGACY_INVOICE_KEY",	Header:"LEGACY_INVOICE_KEY",Type:"Text",		Width:80,	Edit:false,		Hidden:true}
					,{ Align:"Center",	SaveName:"BFRE_STCK_YN",		Header:"BFRE_STCK_YN",		Type:"Text",		Width:80,	Edit:false,	Hidden:true}
					,{ Align:"Center",	SaveName:"INV_REMARK",			Header:"INV_REMARK",		Type:"Text",		Width:80,	Edit:false,	Hidden:true}
					,{ Align:"Center",	SaveName:"SIV00001_TYPE",		Header:"SIV00001_TYPE",		Type:"Text",		Width:80,	Edit:false,	Hidden:true}
					,{ Align:"Center",	SaveName:"SIV00001_RD1",		Header:"SIV00001_RD1",		Type:"Text",		Width:80,	Edit:false,	Hidden:true}
					,{ Align:"Center",	SaveName:"SIV00001_RD2",		Header:"SIV00001_RD2",		Type:"Text",		Width:80,	Edit:false,	Hidden:true}
	];
	
	IBS_InitSheet(mySheet0, initsheet0, pagingMode);
	IBS_InitSheet(mySheet1, initsheet1, pagingMode);
	IBS_InitSheet(mySheet2, initsheet2, pagingMode);
	IBS_InitSheet(mySheet3, initsheet3, pagingMode);
	
	mySheet0.SetHighlightAfterSort(2);
	mySheet1.SetHighlightAfterSort(2);
	mySheet2.SetHighlightAfterSort(2);
	mySheet3.SetHighlightAfterSort(2);
	
	mySheet0.SetCountFormat(" 총  ROWCOUNT 건 ");
	mySheet1.SetCountFormat(" 총  ROWCOUNT 건 ");
	mySheet2.SetCountFormat(" 총  ROWCOUNT 건 ");
	mySheet3.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet0.SetHeaderBackColor("#f2f7ff");
	mySheet1.SetHeaderBackColor("#f2f7ff");
	mySheet2.SetHeaderBackColor("#f2f7ff");
	mySheet3.SetHeaderBackColor("#f2f7ff");
	
	mySheet0.SetTheme("DB", "DeepBlue");
	mySheet1.SetTheme("DB", "DeepBlue");
	mySheet2.SetTheme("DB", "DeepBlue");
	mySheet3.SetTheme("DB", "DeepBlue");
	
	doAction('search');
}

//조회 후처리
function mySheet0_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
//조회 후처리
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	//group번호 부여(거래명세서 같이 만들 group)
	var rowCnt = Sheet.RowCount();
	var tmp_buyer = "";
	var tmp_po_no = "";
	var tmp_ds_date = "";
	var group_no = 0;
	for(var i = 1;i<=rowCnt; i++){
		if(tmp_buyer != Sheet.GetCellValue(i,"BUYER") || tmp_po_no != Sheet.GetCellValue(i,"PO_NO") || tmp_ds_date != Sheet.GetCellValue(i,"DS_DATE")){
			group_no ++;
			Sheet.SetCellValue(i,"GROUP_NO",group_no);
		}else{
			Sheet.SetCellValue(i,"GROUP_NO",group_no);
		}
		
		tmp_buyer = Sheet.GetCellValue(i,"BUYER");
		tmp_po_no = Sheet.GetCellValue(i,"PO_NO");
		tmp_ds_date = Sheet.GetCellValue(i,"DS_DATE");
	}
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
//조회 후처리
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	var rowCnt = Sheet.RowCount();
	for(var i = 1;i<=rowCnt; i++){
		if(Sheet.GetCellValue(i,"DS_FLAG") == "Y"){
			Sheet.SetCellValue(i,"DS_INV_QTY",Sheet.GetCellValue(i,"INV_POSS_QTY"));
			Sheet.SetCellEditable(i, "DS_INV_QTY", true);
			Sheet.SetCellBackColor(i, "DS_INV_QTY", "${optColor}");
		}else{
			Sheet.SetCellValue(i,"DS_INV_QTY",Sheet.GetCellValue(i,"CD_QTY"));
			Sheet.SetCellEditable(i, "DS_INV_QTY", false);
			Sheet.SetCellBackColor(i, "DS_INV_QTY", "");
		}
	}
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
//조회 후처리
function mySheet3_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	for(var i = 1; i<=Sheet.RowCount();i++){
		var legacy_po_no = Sheet.GetCellValue(i,"LEGACY_PO_NO");
		Sheet.SetCellValue(i,"DHIM_LEGACY_PO_NO",legacy_po_no.substring(0,1));
		
		Sheet.SetCellValue(i,"KTAG_BOX_QTY",1);
	}
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}

function mySheet3_OnChange(Row, Col, Value, OldValue, RaiseFlag){
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if(column == "KTAG_BOX_QTY"){
		if(Sheet.GetCellValue(Row,"KTAG_BOX_QTY") <=0){
// 			alert("최소 박스수량은 1개입니다.");
			var text = "최소 박스수량은 1개입니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			Sheet.SetCellValue(Row,"KTAG_BOX_QTY",1);
			return;
		}
		if(Sheet.GetCellValue(Row,"KTAG_BOX_QTY") > 50){
// 			alert("최대 50개까지 입력 가능합니다.");
			var text = "최대 50개까지 입력 가능합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			Sheet.SetCellValue(Row,"KTAG_BOX_QTY",1);
			return;
		}
	}

}

//그리드 셀클릭 이벤트
function mySheet0_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_buyer = Sheet.GetCellValue(Row, "BUYER");
	var st_buyer2 = Sheet.GetCellValue(Row, "BUYER2");
	var st_po_no = Sheet.GetCellValue(Row, "PO_NO");
	var st_po_seq = Sheet.GetCellValue(Row, "PO_SEQ");
	var ds_date = Sheet.GetCellValue(Row,"DS_DATE");
	var rd_date = Sheet.GetCellValue(Row,"RD_DATE");
	var seller = Sheet.GetCellValue(Row,"SELLER");
	var process_type = Sheet.GetCellValue(Row,"PROCESS_TYPE");
	var legacy_po_no = Sheet.GetCellValue(Row,"LEGACY_PO_NO");
	var tr_buyer = Sheet.GetCellValue(Row,"TR_BUYER");
	var dely_to_location = Sheet.GetCellValue(Row,"DELY_TO_LOCATION");
	var add_user_id = Sheet.GetCellValue(Row,"ADD_USER_ID");
	var ref_pr_no = Sheet.GetCellValue(Row,"REF_PR_NO");
	var ds_flag = Sheet.GetCellValue(Row,"H_DS_FLAG");
	var agent = Sheet.GetCellValue(Row,"AGENT");
	var buyer_name = Sheet.GetCellValue(Row,"BUYER_NAME");
	var pop_up_url = Sheet.GetCellValue(Row,"POP_UP_URL");
	var pop_up_type = Sheet.GetCellValue(Row,"POP_UP_TYPE");
	var buyer_slg = Sheet.GetCellValue(Row,"BUYER_SLG");
	var user_id = $("#st_user_id"+currIndex).val();
	
// 	if(column == "BUYER_NAME"){
// 		openSearchPopup("/common/agentInfoDisplayPop.do", '?st_com_code='+st_buyer2, "825,700,no");
// 	}
	if(column == "PO_NO"){
		var src = "/mpiv/commonMpIvOrderInfoPop_v2.do?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status=거래명세서 생성대상"; 
		openLayerPop(src,"1240px","800px");
		
// 		openSearchPopup("/mpiv/commonMpIvOrderInfoPop_v2.do", "?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status=거래명세서 생성대상", "1240,770,no");
	}
	if(column == "SBUTTON"){ //거래명세서 생성 버튼
		var popParams = {};
	
		var option = buildOption('1245,800,no'); //width, height, scroll
	 	
	 	var url = "";
	 	//var win = window.open("about:blank", "sellerMpIvTranStatementWritePop", option);
	 	
	 	//SLOGIC-BEGIN(P06-0000003) - 팝업이 상이한 특수로직
	 	if (pop_up_type == "TYPE2" && !isEmpty(pop_up_url)) {			// 두산인프라코어용..
	 		option = buildOption('1100,700,no'); //width, height, scroll
	 		
	 		// DB pop_up_url data =->>  "/kr/agent/invoice/agent_invoice_di_pop.jsp"
	 		// /mpiv/sellerMpIvTranStatementWriteDirectPop.do
	 		url = pop_up_url;
	 		
	 		// test id : DMT0115	동명엠티에스
	 		// 고객사 : 두산인프라코어(주)창원 
	 	
			// test용 DB데이터 변경후 삭제
	 		//url = "/mpiv/getSellerMpIvTranStatementWriteDiPop.do";
	 		
// 	 		document.forms.postPopForm.st_buyer.value=st_buyer;
// 			document.forms.postPopForm.st_process_type.value=process_type;
// 			document.forms.postPopForm.st_buyer_name.value=buyer_name;
// 			document.forms.postPopForm.st_com_code.value=$("#st_com_code"+currIndex).val();
			
			popParams.st_buyer = st_buyer;
			popParams.st_process_type = process_type;
			popParams.st_buyer_name = buyer_name;
			popParams.st_com_code = $("#st_com_code"+currIndex).val();
			
			openLayerPop3(url,"",popParams,"1100px","700px");
			
	 	}else if ( pop_up_type == "TYPE3" || ds_flag == "Y" ) {		// 분할납품 가능
	 		
	 	 	// test id : DMT0115	동명엠티에스 
	 	 	//KRDONG0596	동명엠티에스주식회사	
	 	 	
			// DB pop_up_url data =->>  "/kr/agent/invoice/agent_invoice_cre_doosanmeca_pop.jsp"
			
			// /mpiv/getSellerMpIvTranStatementWriteDoosanmecaPop.do
				
			//url = pop_up_url;
			
			url = "/mpiv/showSellerMpIvTranStatementWriteDoosanmecaPop_v2.do";

// 			document.forms["postPopForm"].st_buyer.value=st_buyer;
// 			document.forms["postPopForm"].st_po_no.value=st_po_no;
// 			document.forms["postPopForm"].st_ds_date.value=ds_date;
// 			document.forms["postPopForm"].st_seller.value=seller;
// 			document.forms["postPopForm"].st_process_type.value=process_type;
// 			document.forms["postPopForm"].st_legacy_po_no.value=legacy_po_no;
// 			document.forms["postPopForm"].st_tr_buyer.value=tr_buyer;
// 			document.forms["postPopForm"].st_dely_to_location.value=dely_to_location;
// 			document.forms["postPopForm"].st_add_user_id.value=add_user_id;
// 			document.forms["postPopForm"].st_ref_pr_no.value=ref_pr_no;
// 			document.forms["postPopForm"].st_user_id.value=user_id;
// 			document.forms["postPopForm"].st_agent.value=agent;

			popParams.st_buyer = st_buyer;
			popParams.st_po_no = st_po_no;
			popParams.st_ds_date = ds_date;
			popParams.st_seller = seller;
			popParams.st_process_type = process_type;
			popParams.st_legacy_po_no = legacy_po_no;
			popParams.st_tr_buyer = tr_buyer;
			popParams.st_dely_to_location = dely_to_location;
			popParams.st_add_user_id = add_user_id;
			popParams.st_ref_pr_no = ref_pr_no;
			popParams.st_user_id = user_id;
			popParams.st_agent = agent;
			
			openLayerPop3(url,"",popParams,"1245px","850px");
	 	}else {
	 		// test id : YUHANADS
	 		// po_no : PO14003184
			
			// default
			url = "/mpiv/showSellerMpIvTranStatementWritePop_v2.do";
			//url = "/kr/agent/invoice/agent_invoice_cre_pop.jsp";
			
// 			document.forms["postPopForm"].st_buyer.value=st_buyer;
// 			document.forms["postPopForm"].st_po_no.value=st_po_no;
// 			document.forms["postPopForm"].st_ds_date.value=ds_date;
// 			document.forms["postPopForm"].st_seller.value=seller;
// 			document.forms["postPopForm"].st_process_type.value=process_type;
// 			document.forms["postPopForm"].st_legacy_po_no.value=legacy_po_no;
// 			document.forms["postPopForm"].st_tr_buyer.value=tr_buyer;
// 			document.forms["postPopForm"].st_dely_to_location.value=dely_to_location;
// 			document.forms["postPopForm"].st_add_user_id.value=add_user_id;
// 			document.forms["postPopForm"].st_ref_pr_no.value=ref_pr_no;
// 			document.forms["postPopForm"].st_user_id.value=user_id;
			
			popParams.st_buyer = st_buyer;
			popParams.st_po_no = st_po_no;
			popParams.st_ds_date = ds_date;
			popParams.st_seller = seller;
			popParams.st_process_type = process_type;
			popParams.st_legacy_po_no = legacy_po_no;
			popParams.st_tr_buyer = tr_buyer;
			popParams.st_dely_to_location = dely_to_location;
			popParams.st_add_user_id = add_user_id;
			popParams.st_ref_pr_no = ref_pr_no;
			popParams.st_user_id = user_id;
			
			openLayerPop3(url,"",popParams,"1245px","850px");
			
	 	}
		//SLOGIC-END

		/*
	 	console.log("=========== 거래명세서 팝업 정보 START =======");
	 	console.log("pop_up_type ==>> " + pop_up_type);
	 	console.log("legacy_po_no_delimeter ==>> " + TrimCommon(legacy_po_no_delimeter));
	 	console.log("process_type ==>> " + process_type);
	 	console.log("ds_flag ==>> " + ds_flag);
	 	console.log("url ==>> " + url);
	 	console.log("param ==>> " + param);
	 	console.log("=========== 거래명세서 팝업 정보 END =======");
	 	*/
//	  	var win = window.open(url+param, "sellerMpIvTranStatementWritePop", option);
	 	
// 	 	openSearchPopupPost(url, "postPopForm", "sellerMpIvTranStatementWrite",option);
	
	
	
	
	
	
	
// 		openSearchPopup("/mpiv/sellerMpIvObtnodrReceiptDetailPop_v2.do", "?st_buyer="+st_buyer+"&st_po_no="+st_po_no, "1240,770,no");
	}
	
	return;
}
//그리드 셀클릭 이벤트
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_buyer = Sheet.GetCellValue(Row, "BUYER");
	var st_buyer2 = Sheet.GetCellValue(Row, "BUYER2");
	var st_po_no = Sheet.GetCellValue(Row, "PO_NO");
	var st_po_seq = Sheet.GetCellValue(Row, "PO_SEQ");
	var st_buyer_item_no = Sheet.GetCellValue(Row,"BUYER_ITEM_NO");
	var st_byit_comorg_code = Sheet.GetCellValue(Row,"BYIT_COMORG_CODE");
	var st_contract_no = Sheet.GetCellValue(Row,"CONTRACT_NO");
	var st_contract_seq = Sheet.GetCellValue(Row,"CONTRACT_SEQ");
	
// 	if(column == "BUYER_NAME"){
// 		openSearchPopup("/common/agentInfoDisplayPop.do", '?st_com_code='+st_buyer2, "825,700,no");
// 	}
	if(column == "PO_NO"){
		var src = "/mpiv/commonMpIvOrderInfoPop_v2.do?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status=거래명세서 생성대상"; 
		openLayerPop(src,"1240px","850px");
		
// 		openSearchPopup("/mpiv/commonMpIvOrderInfoPop_v2.do", "?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status=거래명세서 생성대상", "1240,770,no");
	}
// 	if(column == "BUYER_ITEM_NO"){
// 		openSearchPopup("/common/catalogDetailPop.do","?open=Y&BUYER="+st_byit_comorg_code+"&BUYER_ITEM_NO="+escape(st_buyer_item_no)+"&CONTRACT_NO="+st_contract_no+"&CONTRACT_SEQ="+st_contract_seq,"650,600,no");
// 	}
	return;
} 
//그리드 셀클릭 이벤트
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_buyer = Sheet.GetCellValue(Row, "BUYER");
	var st_buyer2 = Sheet.GetCellValue(Row, "BUYER2");
	var st_po_no = Sheet.GetCellValue(Row, "PO_NO");
	var st_po_seq = Sheet.GetCellValue(Row, "PO_SEQ");
	var st_buyer_item_no = Sheet.GetCellValue(Row,"BUYER_ITEM_NO");
	var st_byit_comorg_code = Sheet.GetCellValue(Row,"BYIT_COMORG_CODE");
	var st_contract_no = Sheet.GetCellValue(Row,"CONTRACT_NO");
	var st_contract_seq = Sheet.GetCellValue(Row,"CONTRACT_SEQ");
	
	if(column == "BUYER_NAME"){
		var src = "/common/agentInfoDisplayPop.do?st_com_code="+st_buyer2; 
		openLayerPop(src,"825px","700px");
		
// 		openSearchPopup("/common/agentInfoDisplayPop.do", '?st_com_code='+st_buyer2, "825,700,no");
	}
	if(column == "PO_NO"){
		var src = "/mpiv/commonMpIvOrderInfoPop_v2.do?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status=거래명세서 생성대상"; 
		openLayerPop(src,"1240px","850px");
		
// 		openSearchPopup("/mpiv/commonMpIvOrderInfoPop_v2.do", "?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status=거래명세서 생성대상", "1240,770,no");
	}
	if(column == "BUYER_ITEM_NO"){
		var src = "/common/catalogDetailPop.do?open=Y&BUYER="+st_byit_comorg_code+"&BUYER_ITEM_NO="+escape(st_buyer_item_no)+"&CONTRACT_NO="+st_contract_no+"&CONTRACT_SEQ="+st_contract_seq+"&popupCheck=N";
		openLayerPop(src,"650px","600px");
		
// 		openSearchPopup("/common/catalogDetailPop.do","?open=Y&BUYER="+st_byit_comorg_code+"&BUYER_ITEM_NO="+escape(st_buyer_item_no)+"&CONTRACT_NO="+st_contract_no+"&CONTRACT_SEQ="+st_contract_seq,"650,600,no");
	}
	return;
}
//그리드 셀클릭 이벤트
function mySheet3_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = Sheet.ColSaveName(Sheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_buyer = Sheet.GetCellValue(Row, "BUYER");
	var st_seller = Sheet.GetCellValue(Row, "SELLER");
	var st_buyer2 = Sheet.GetCellValue(Row, "BUYER2");
	var st_po_no = Sheet.GetCellValue(Row, "PO_NO");
	var st_po_seq = Sheet.GetCellValue(Row, "PO_SEQ");
	var st_status = Sheet.GetCellValue(Row, "STATUS");
	var st_inv_no = Sheet.GetCellValue(Row, "INV_NO");
	var st_legacy_iv_serial = Sheet.GetCellValue(Row, "LEGACY_INVOICE_KEY");
	var st_tr_buyer = Sheet.GetCellValue(Row, "TR_BUYER");
	
	var st_invoice_date = Sheet.GetCellValue(Row,"INVOICE_DATE");
	var st_pors_date = Sheet.GetCellValue(Row,"PORS_DATE");
	var st_ivdt_date = Sheet.GetCellValue(Row,"IVDT_DATE");
	var st_delivery_add_date = Sheet.GetCellValue(Row,"DELIVERY_ADD_DATE");
	
	if(column == "SELECTED"){
		for(var i = 1; i<=Sheet.RowCount(); i++){
			if(Sheet.GetCellValue(i,"BUYER") == st_buyer && Sheet.GetCellValue(i,"INV_NO") == st_inv_no){
				Sheet.SetCellValue(i,"SELECTED",Value);
			}
		}
	}
	if(column == "STATUS_BUTTON"){
		param = "?st_status="+st_status
		param += "&st_po_no="+st_po_no;
		param += "&st_inv_no="+st_inv_no;
		param += "&st_pors_date="+st_pors_date;
		param += "&st_ivdt_date="+st_ivdt_date;
		param += "&st_invoice_date="+st_invoice_date;
		param += "&st_delivery_add_date="+st_delivery_add_date;
		
		var src = "/mpiv/sellerMpIvDeliveryProgressStatusPop.do"+param; 
		openLayerPop(src,"650px","350px");
		
// 		openSearchPopup("/mpiv/sellerMpIvDeliveryProgressStatusPop.do", param, "650,350,no");
	}
	if(column == "INV_NO"){
		if(st_inv_no != ""){
			param  = "?st_buyer="+st_buyer;
			param += "&st_po_no="+st_po_no;
			param += "&st_inv_no="+st_inv_no;
			param += "&st_seller="+st_seller;
			param += "&st_legacy_iv_serial="+st_legacy_iv_serial;
			param += "&st_tr_buyer="+st_tr_buyer;
			param += "&st_user_id="+$("#st_user_id"+currIndex).val();
			
			var src = "/mpiv/commonMpIvTranStatementDetailIVPop_v2.do"+param;
			openLayerPop(src,"1240px","900px");
// 			openSearchPopup("/mpiv/commonMpIvTranStatementDetailIVPop_v2.do", param, "1240,850,no");
		}
	}
// 	if(column == "BUYER_NAME"){
// 		openSearchPopup("/common/agentInfoDisplayPop.do", '?st_com_code='+st_buyer2, "825,700,no");
// 	}
	if(column == "PO_NO"){
		var src = "/mpiv/commonMpIvOrderInfoPop_v2.do?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status="+st_status; 
		openLayerPop(src,"1240px","850px");
		
// 		openSearchPopup("/mpiv/commonMpIvOrderInfoPop_v2.do", "?st_buyer="+st_buyer+"&st_po_no="+st_po_no+"&st_status="+st_status, "1240,770,no");
	}
	if(column == "SBUTTON"){
		var process_type = Sheet.GetCellValue(Row,"PROCESS_TYPE");
		var solb_legacy_po_no = Sheet.GetCellValue(Row,"DHIM_LEGACY_PO_NO");
		var solb_if_buyer_flag = Sheet.GetCellValue(Row,"SOLB_IF_BUYER");
		var legacy_iv_serial = Sheet.GetCellValue(Row, "LEGACY_INVOICE_KEY");
		
		if(solb_if_buyer_flag == "Y" && solb_legacy_po_no == "4" && process_type == "0" && legacy_iv_serial == ""){ // 솔브레인 IF 발주
// 			alert("거래명세서를 고객사 시스템에 등록중입니다.(납품서 출력은 약 20분 후 가능합니다)\n출력이 지연되면 KeP담당자에게 문의하시기 바랍니다.");
			var text = "거래명세서를 고객사 시스템에 등록중입니다.(납품서 출력은 약 20분 후 가능합니다)</br>출력이 지연되면 KeP담당자에게 문의하시기 바랍니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		var rpt_url = Sheet.GetCellValue(Row,"RPT_URL");
		if(rpt_url == ""){
			$("#st_query_rpt_url").val(Sheet.GetCellValue(Row,"BUYER")+"@@"+Sheet.GetCellValue(Row,"PO_NO")+"@@"+Sheet.GetCellValue(Row,"INV_NO")+"@@"+$("#st_user_id"+currIndex).val()+"##");
			kepAjaxFormCall("/mpiv/getSellerMpIvTranStatementWriteRptUrl_v2.do","tranStatementWriteRptUrlForm","getRptUrl");
		}else{
			sheetWin("S");
		}
		
	}
	if(column == "SBUTTON2"){
		if(Sheet.GetCellValue(Row,"SBUTTON2") == ""){
			return;
		}
		sheetTagListWin4("S");
	}
	return;
}
function doAction(str) {
	switch (str) {
	case "search":	 //조회
		if (kep_dateSearchCheck($("#st_from_date_"+currIndex).val(),$("#st_to_date_"+currIndex).val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_'+currIndex,'st_to_date_'+currIndex,'D');
		
		if(currIndex == 3){
			if (eval(diff)>93){
// 				alert("3개월 이내 조회만 가능합니다.");
				var text = "3개월 이내 조회만 가능합니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
		}else{
			if (eval(diff)>372){
// 				alert("1년 이내 조회만 가능합니다.");
				var text = "1년 이내 조회만 가능합니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}	
		}
		
		
		if(currIndex == 0){
			kepSearch(document.searchCondition0, Sheet, "/mpiv/getSellerMpIvTranStatementWriteListPO_v2.do" , pagingMode);
		}else if(currIndex == 1){
			kepSearch(document.searchCondition1, Sheet, "/mpiv/getSellerMpIvTranStatementWriteListItem_v2.do" , pagingMode);
		}else if(currIndex == 2){
			if($("#st_buyer_code_2").val() == ""){
// 				alert("고객사를 선택해주십시오.");
				var text = "고객사를 선택해주세요.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			kepSearch(document.searchCondition2, Sheet, "/mpiv/getSellerMpIvTranStatementWriteListItem_v2.do" , pagingMode);
		}else if(currIndex == 3){
			kepSearch(document.searchCondition3, Sheet, "/mpiv/getSellerMpIvTranStatementWritePrintList_v2.do" , pagingMode);
		}
		break;
		
	case "reload":	//초기화
		kepReload_v2('searchCondition'+currIndex);
		if(currIndex == 3){
			kepMonth_v2('st_from_date_'+currIndex,'st_to_date_'+currIndex,'1');
			$("#st_dely_type").val("DELY_NO");
		}else{
			kepMonth_v2('st_from_date_'+currIndex,'st_to_date_'+currIndex,'3');
		}
		Sheet.RemoveAll();
		
		// hidden값은 공통에서 처리안됨.
		$("#st_buyer_code_"+currIndex).val("");
		break;

	case "excelDown": // 엑셀다운로드
		excelDownload();
		break;
	}
}
function setBuyerChoiceReturn(buyer, com_name){
	$("#st_buyer_code_"+currIndex).val(buyer);
	$("#st_buyer_name_"+currIndex).val(com_name);
}
 
// 팝업 함수호출
function doPop(str,value1, value2) {
	switch (str) {		
		case "commonMpIvTranBuyerChoicePop": // 고객사선택
			if(currIndex == 2){
				var src = "/mpiv/getCommonMpIvTranBuyerChoicePop.do?st_com_code="+$("#st_com_code"+currIndex).val()+"&invoice_flag=Y"; 
				openLayerPop(src,"440px","530px");
				
// 				openSearchPopup("/mpiv/getCommonMpIvTranBuyerChoicePop.do", "?st_com_code="+$("#st_com_code"+currIndex).val()+"&invoice_flag=Y", "440,530,no");
			}else{
				openSearchPopup("/mpiv/getCommonMpIvTranBuyerChoicePop.do", "?st_com_code="+$("#st_com_code"+currIndex).val(), "750,530,no");
			}
			break;
		case "setInvoiceCreateItem": //품목별 - 선택한 여러 발주 건을 각각 개별 거래명세서로 한 번에 생성(다중생성)
			doSetInvoiceCreateItem();
			
			break;
		case "setInvoiceCreateAll": //일괄생성
			doSetInvoiceCreateAll();
			break;
			
	}
}

/* function setCheckBox(){
	
	if($("#st_gr_flag_check").is(":checked")){
		$("#st_gr_flag").val("GR");
		
	} else {
		$("#st_gr_flag").val("ALL");
		
	}
} */
function doSetInvoiceCreateItem(){
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	// 선택된 항목 유무 체크
	if (checkRows.length == 0) {
// 		alert("거래명세서를 생성할 항목을 선택하여 주세요.");
		var text = "거래명세서를 생성할 항목을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var buyer           = "";
	var ds_date         = "";
	var po_no           = "";
	var po_seq          = "";
	var cd_qty          = "";
	var iv_qty          = "";
	var po_qty          = "";
	
	var size_yn			= "";
	var size_len			= "";
	var size_qty		= "";
	
	//유해화학물질 여부
	var harmful_yn = "";	
	// MSDS 진행 통제
	var cod_check	= ""; //ICOMCOD1 에 있는지 체크하는 변수
	var msds_check	= ""; //BYIT.MSDS_NO의 null여부
	var req_check   = ""; //KEP_CMC_REQ 의 상태 체크
	var temp_req_check = "" //KEP_CMC_REQ 의 상태체크(TEMP_COND 입력 여부)
	var buyer_item_no_arr = []; //등록해야할 품목코드
	var msds_no_reg_buyer_item_no_arr = []; //카탈로그에 MSDS 미등록 품목코드
	var tempMng_no_reg_buyer_item_no_arr = []; //카탈로그에 보관조건 미등록 품목코드
	
	var temp_check   = ""; //보관조건 체크
	var sg118_check = ""; // 시약류 체크
	var p070000033 = ""; // 보관조건이 필수인 고객사 목록
	var temp_cond = ""; // 보관조건 유형(실온/정온/냉장/냉동/극냉동)
	
	// 매입단가유효일 진행 통제
	var buy_close_date_chk = ""; // 매입단가유효일 체크
	
	var rowList = new Array();
	var rowJson = "";
	var gridJsonList = "";
	
	var msds_po_no = "";
	var msds_po_no_bef = ""; // 동일 발주번호 중복 제출요청 방지용
	var msds_query = ""; // MSDS 등록용
	
	var popParams = {};
	popParams.trCheck = "N";
	popParams.p_user_id_item ="<%=p_user_id%>";
	popParams.p_kep_id = "<%=p_kep_id%>";
	
	for(var idx = 0; idx<arrRow.length; idx++){
		if(idx>0){
			msds_po_no_bef = Sheet.GetCellValue(arrRow[idx-1],"PO_NO");
		}
		
		var rd_date = Sheet.GetCellValue(arrRow[idx],"RD_DATE");
		var pop_up_url = Sheet.GetCellValue(arrRow[idx],"POP_UP_URL");
		var pop_up_type = Sheet.GetCellValue(arrRow[idx],"POP_UP_TYPE");
		
		if(pop_up_type == "TYPE2" && !isEmpty(pop_up_url)){
// 			alert("해당 고객사는 거래명세서를 한 번에 생성할 수 없습니다.");
			var text = "해당 고객사는 거래명세서를 한 번에 생성할 수 없습니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		var process_type = Sheet.GetCellValue(arrRow[idx],"PROCESS_TYPE");
		var w001_flag = Sheet.GetCellValue(arrRow[idx],"W001_FLAG");
		
		if( (process_type == "1" || process_type == "3") && w001_flag == "N") {
// 			alert('재고나 VMI는 거래명세서 생성이 불가능 합니다.');
			var text = "재고나 VMI는 거래명세서 생성이 불가능 합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		//cck
		
		var p060000080 = Sheet.GetCellValue(arrRow[idx],"P060000080");
		
		buyer       = Sheet.GetCellValue(arrRow[idx],"BUYER");
		po_no       = Sheet.GetCellValue(arrRow[idx],"PO_NO");
		msds_po_no	= Sheet.GetCellValue(arrRow[idx],"PO_NO");
		po_seq      = Sheet.GetCellValue(arrRow[idx],"PO_SEQ");
		cd_qty      = Sheet.GetCellValue(arrRow[idx],"INV_POSS_QTY");
		ds_date      = Sheet.GetCellValue(arrRow[idx],"DS_DATE");
		po_qty      = Sheet.GetCellValue(arrRow[idx],"ITEM_QTY");
		
		harmful_yn = Sheet.GetCellValue(arrRow[idx],"HARMFUL_CHECK");
		
		if(process_type!="0"&&harmful_yn=="Y"){
//             alert("유해 화학물질은 물류센터로 납품 불가능합니다.\nKeP담당자에게 연락 바랍니다.");
            var text = "유해 화학물질은 물류센터로 납품 불가능합니다.</br>KeP담당자에게 연락 바랍니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
            return ;				
		}
		
		// MSDS 진행 통제 체크
		cod_check = Sheet.GetCellValue(arrRow[idx],"COD_CHECK");
    	msds_check = Sheet.GetCellValue(arrRow[idx],"MSDS_CHECK");
    	req_check = Sheet.GetCellValue(arrRow[idx],"REQ_CHECK");
    	temp_req_check = Sheet.GetCellValue(arrRow[idx],"TEMP_REQ_CHECK");
    	
    	temp_check = Sheet.GetCellValue(arrRow[idx],"TEMP_CHECK");
    	p070000033 = Sheet.GetCellValue(arrRow[idx],"P070000033");
    	sg118_check = Sheet.GetCellValue(arrRow[idx],"SG118_CHECK");
    	temp_cond = Sheet.GetCellValue(arrRow[idx],"TEMP_COND");
    	
    	var flag1 = false;
    	var flag2 = false;
    	var flag3 = false;
    	
    	if(cod_check=="Y" && msds_check=="Y" && req_check=="N"){ //물질정보등록 대상이면서 msds미매핑 건 이면서 입력요청 외에 다른 상태 건 이 없는 경우 거래명세서 작성 통제
    		flag1 = true;
    		for(var i = 0; i<buyer_item_no_arr.length;i++){ //buyer_item_no 중복 출력 방지
    			if(Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO")==buyer_item_no_arr[i]){
    				flag1 = false;
		    		break;		
    			}
    		}
    		if(flag1){
    			buyer_item_no_arr.push(Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO"));
    		}
     	}
    	
    	if(cod_check=="Y" && msds_check=="Y"){ // MSDS 대상 표준카테고리에 해당하고 카탈로그 MSDS 미매핑 품목 리스트 - 통제 2024.07.19 HSJ
    		flag2 = true;
    	 	for(var i = 0; i<msds_no_reg_buyer_item_no_arr.length;i++){ //buyer_item_no 중복출력 방지
     			if(Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO")==msds_no_reg_buyer_item_no_arr[i]){
     				flag2 = false;
 		    		break;		
     			}
     		}
     		if(flag2){
     			msds_no_reg_buyer_item_no_arr.push(Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO"));
     		}
     	}
    	
    	if(p070000033 != "" && sg118_check == "Y" && temp_check == "Y"){ // 보관조건 입력 필수 고객사 & 카탈로그에 보관조건 미등록 품목 통제 - 2025.06.27 HSJ
    		if(temp_req_check == "Y"){ //협력사제출,제출(오분류) 상태이고 보관조건을 입력한 데이터가 있는 경우 -> 진행하지말고 기다리라고 안내
    			var text = "해당 품목 ("+Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO")+") 은 보관온도 조건 입력 요청이 접수되어 현재 KeP 담당자 검토 단계에서 처리 중입니다.</br>동일 품목에 대한 추가 요청은 접수되지 않으니 검토 완료까지 잠시만 기다려 주세요.";
    			openLayerPopText2(text,but1text,but1func,but1width);
    			return
    		}else{
    			flag3 = true;
        		for(var i = 0; i<tempMng_no_reg_buyer_item_no_arr.length;i++){ //buyer_item_no 중복출력 방지
        			if(Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO")==tempMng_no_reg_buyer_item_no_arr[i]){
        				flag3 = false;
    		    		break;		
        			}
        		}
        		if(flag3){
        			tempMng_no_reg_buyer_item_no_arr.push(Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO"));
        		}
    		}
    	}
    	if(flag1==true || flag3==true){
    		if(msds_po_no != msds_po_no_bef){ // 중복 발주번호는 전송하지 않음, 대상 품목 있는 발주번호만 전송
				msds_query +=  buyer      + "@@";
				msds_query +=  msds_po_no + "@@";
				msds_query +=  "^||^";	
			}
    	}
    	
    	// 매입단가유효일 진행 통제
    	buy_close_date_chk = Sheet.GetCellValue(arrRow[idx],"BUY_CLOSE_DATE_CHK");
		if(buy_close_date_chk == "Y"){
// 			alert("해당 건 진행할 수 없습니다.\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
			var text = "해당 건 진행할 수 없습니다.</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
    	
		<%if(!p_proxy_yn.equals("Y")){%>
			// 보관조건에 따른 거래유형 검증(아모레퍼시픽(TYPE1))
	    	if(p070000033 == "TYPE1"){ // 아모레퍼시픽(TYPE1)
	    		if(sg118_check == "Y"){ // 시약류
	    			if(harmful_yn != "Y"){ // 유해화학물질 여부
	    				if(temp_cond != ""){
		        			if(temp_cond == "A" || temp_cond == "B"){ // 실온(A), 정온(B)
		            			if(process_type != "2"){
// 		            				alert("실온/정온은 TR로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
		            				var text = "실온/정온은 TR로만 가능합니다.(거래유형오류)</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
		            				openLayerPopText2(text,but1text,but1func,but1width);
		               				return;
		            			}
		            		}else{
		            			if(process_type != "0"){
// 		            				alert("냉장/냉동은 직납으로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
		            				var text = "냉장/냉동은 직납으로만 가능합니다.(거래유형오류)</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
		            				openLayerPopText2(text,but1text,but1func,but1width);
		               				return;
		            			}
		            		}
	    				}
	        		}	
	    		}
	    	}
		<%}%>

		if(process_type == "2" && "<%=p_proxy_yn%>" != "Y" && "<%=st_tr_notice_check_yn%>" == "N"){
// 			$("#trCheck").val("Y"); //하나라도 TR이면 TYPE90인 팝업 띄워줘야함
			popParams.trCheck = "Y";//하나라도 TR이면 TYPE90인 팝업 띄워줘야함
		}
		
		var param = {
				"BUYER" : Sheet.GetCellValue(arrRow[idx],"BUYER")
				,"PO_NO" : Sheet.GetCellValue(arrRow[idx],"PO_NO")
				,"PO_SEQ" : Sheet.GetCellValue(arrRow[idx],"PO_SEQ")
				,"CD_QTY" : Sheet.GetCellValue(arrRow[idx],"INV_POSS_QTY")
				,"DS_DATE" : Sheet.GetCellValue(arrRow[idx],"DS_DATE")
				,"PROCESS_TYPE" : Sheet.GetCellValue(arrRow[idx],"PROCESS_TYPE")
				,"SIZE_YN" : Sheet.GetCellValue(arrRow[idx],"SIZE_YN")
				,"SIZE_LEN" : Sheet.GetCellValue(arrRow[idx],"SIZE_LEN")
				,"SIZE_QTY" : Sheet.GetCellValue(arrRow[idx],"SIZE_QTY")
				,"P060000080" : Sheet.GetCellValue(arrRow[idx],"P060000080")
				,"GROUP_NO" : Sheet.GetCellValue(arrRow[idx],"GROUP_NO")
				,"SELLER" : Sheet.GetCellValue(arrRow[idx],"SELLER")
				,"PO_QTY" : Sheet.GetCellValue(arrRow[idx],"ITEM_QTY")
			};
		rowJson = JSON.stringify(param);
		rowList.push(rowJson);
	}
	
	gridJsonList =  "[" + rowList.toString() + "]";
	
	 
// 	$("#infoItem").val(gridJsonList);
<%-- 	$("#p_user_id_item").val("<%=p_user_id%>"); --%>
	
	
	if(buyer_item_no_arr.length != 0){ //수주접수 통제해야되는 건이 있는 경우
		g_query = msds_query;
		
		var text = "해당 품목 ("+buyer_item_no_arr+") 은 MSDS 제출이 필요합니다.</br>MSDS 등록 후 KeP 승인이 완료되면 거래명세서 생성을 진행할 수 있습니다.</br>KeP 승인완료 전에는 거래명세서 생성이 제한됩니다.";
		var but1textC = "확인";
		var but2textC = "MSDS관리 바로가기";
		var but1funcC = "javascript:reqAndClose(); return false;";
		var but2funcC = "javascript:reqAndMove(); return false;";
		var but1widthC = "120px";
		var but2widthC = "170px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		
// 		if(confirm("해당 품목 ("+buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n\n카탈로그 관리 > 물질정보 제출 화면으로 이동하셔서 MSDS 및 물질정보 제출 후 KEP에서 MSDS매핑이 완료되면 거래명세서 작성하시기 바랍니다.\n\n*문의사항은 거래명세서 작성 화면에 있는 KeP담당자 통해서 하시길 바랍니다.")){
// 			//KEP_CMC_REQ insert 코드
// 			document.forms.setChemInfoForm.st_query.value = msds_query;
// 			kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteChemicalInfo.do","setChemInfoForm","saveChemInfo");
// 		}
		return;
	}
	
	if(tempMng_no_reg_buyer_item_no_arr.length != 0){ //수주접수 통제해야되는 건이 있는 경우
		g_query = msds_query;
		
		var text = "해당 품목 ("+tempMng_no_reg_buyer_item_no_arr+") 은 보관온도 조건 제출이 필요합니다.</br>등록 후 KeP 승인이 완료되면 거래명세서 생성을 진행할 수 있습니다.</br>KeP 승인완료 전에는 거래명세서 생성이 제한됩니다.";
		var but1textC = "확인";
		var but2textC = "MSDS관리 바로가기";
		var but1funcC = "javascript:reqAndClose(); return false;";
		var but2funcC = "javascript:reqAndMove(); return false;";
		var but1widthC = "120px";
		var but2widthC = "170px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		
// 		if(confirm("해당 품목 ("+tempMng_no_reg_buyer_item_no_arr+") 은 보관조건(온도) 확인이 필요한 대상입니다.\n카탈로그 관리 > 물질정보 제출 화면으로 이동하셔서 물질정보 제출 후 KEP에서 승인되면 거래명세서 작성하시기 바랍니다.\n\n*문의사항은 거래명세서 작성 화면에 있는 KeP담당자 통해서 하시길 바랍니다.")){
// 			//KEP_CMC_REQ insert 코드
// 			document.forms.setChemInfoForm.st_query.value = msds_query;
// 			kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteChemicalInfo.do","setChemInfoForm","saveChemInfo");
// 		}
		return;
	}
	
	if(msds_no_reg_buyer_item_no_arr.length != 0){
		g_query = msds_query;
		var text = "해당 품목 ("+msds_no_reg_buyer_item_no_arr+") 은 MSDS 제출이 필요합니다.</br>MSDS 등록 후 KeP 승인이 완료되면 거래명세서 생성을 진행할 수 있습니다.</br>KeP 승인완료 전에는 거래명세서 생성이 제한됩니다.";
		var but1textC = "확인";
		var but2textC = "MSDS관리 바로가기";
		var but1funcC = "javascript:layerPopClose(); return false;";
		var but2funcC = "javascript:layerPopMove(); return false;";
		var but1widthC = "120px";
		var but2widthC = "170px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
// 		alert("해당 품목 ("+msds_no_reg_buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n현재 MSDS가 매핑되어 있지 않아 진행이 불가하니 확인하여 주시기 바랍니다.\n*문의사항은 거래명세서 작성 화면에 있는 KeP담당자 통해서 하시길 바랍니다.");
		return;
	}
	
	var url = "/mpiv/showSellerMpIvTranStatementWriteItemPop_v2.do";
	
	openLayerPop3(url,gridJsonList,popParams,"890px","420px");
	
// 	openSearchPopupPost("/mpiv/showSellerMpIvTranStatementWriteItemPop_v2.do","tranStatementWriteItemForm","tranStatementWriteItemForm", "width=890,height=420,resizable=no,scrollbars=no, top=200, left=400");
	
}

function doSetInvoiceCreateAll(){
	var buyer           = $("#st_buyer_code_"+currIndex).val();
// 	$("#st_buyer_code_all").val(buyer);
	
	// 일괄 거래명세서 작성 막기(아모레, 중외) 보관조건에 따라 납품방법 통제 등이 까다로워 빠른 오픈 위해 임시방편 하드코딩 2025.06.27 HSJ(아이디어 있는 사람이 수정해보세요)
	if(buyer == "KRAMOR0003" || buyer == "KRAMOR0004" || buyer == "KRAMOR0005" || buyer == "KRAMOS0006" || buyer == "KRESPO0003" || buyer == "KRETUD0002" ||
			buyer == "KRINNI0002" || buyer == "KRJW-L0001" || buyer == "KRJWPH0001" || buyer == "KROSUL0002"){
// 		alert("해당 고객사는 일괄 거래명세서 작성을 사용할 수 없습니다.");
		var text = "해당 고객사는 일괄 거래명세서 작성을 사용할 수 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	// 선택된 항목 유무 체크
	if (checkRows.length == 0) {
// 		alert("거래명세서를 생성할 항목을 선택하여 주세요.");
		var text = "거래명세서를 생성할 항목을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var ds_date         = "";
	var po_no           = "";
	var po_seq          = "";
	var cd_qty          = "";
	var iv_qty          = "";
	var item_qty          = "";
	var inv_poss_qty	= "";
	var process_type	= "";
	
	// MSDS 진행 통제
	var cod_check	= ""; //ICOMCOD1 에 있는지 체크하는 변수
	var msds_check	= ""; //BYIT.MSDS_NO의 null여부
	var req_check   = ""; //KEP_CMC_REQ 의 상태 체크
	var temp_req_check = ""; //KEP_CMC_REQ 의 상태 체크(TEMP_CODE 여부)
	var buyer_item_no_arr = []; //등록해야할 품목코드
	var msds_no_reg_buyer_item_no_arr = []; //카탈로그에 MSDS 미등록 품목코드
	
	// 매입단가유효일 진행 통제
	var buy_close_date_chk = ""; // 매입단가유효일 체크
	
	var rowList = new Array();
	var rowJson = "";
	var gridJsonList = "";
	
	var msds_po_no = "";
	var msds_po_no_bef = ""; // 동일 발주번호 중복 제출요청 방지용
	var msds_query = ""; // MSDS 등록용
	
	var dely_to_location = "";
	var ref_add_user_id = "";
	var pop_key = "";
	var query = "";
	
	var popParams = {};
	popParams.trCheck = "N";
	popParams.p_user_id_all ="<%=p_user_id%>";
	popParams.st_user_id = "<%=p_kep_id%>";
	popParams.st_buyer_code = buyer;
	popParams.st_com_code = "${sessionInfo.comCode}";
	
	for(var idx = 0; idx<arrRow.length; idx++){
		if(idx== 0){
// 			$("#st_po_no_all").val(Sheet.GetCellValue(arrRow[idx],"PO_NO"));
			popParams.st_po_no_all = Sheet.GetCellValue(arrRow[idx],"PO_NO");
		}
		
		dely_to_location = Sheet.GetCellValue(arrRow[idx],"DELY_TO_LOCATION");
		ref_add_user_id = Sheet.GetCellValue(arrRow[idx],"REF_ADD_USER_ID");
		if(idx>0){
			msds_po_no_bef = Sheet.GetCellValue(arrRow[idx-1],"PO_NO");
			if(dely_to_location != Sheet.GetCellValue(arrRow[idx-1],"DELY_TO_LOCATION") || ref_add_user_id != Sheet.GetCellValue(arrRow[idx-1],"REF_ADD_USER_ID")){ //요청자나 납품장소가 다른 경우 일괄 생성 불가능
// 				alert("요청자가 다르거나 납품장소가 다른 경우 거래명세서를 일괄 생성할 수 없습니다.");
				var text = "요청자가 다르거나 납품장소가 다른 경우 거래명세서를 일괄 생성할 수 없습니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
		}
		
		
		process_type = Sheet.GetCellValue(arrRow[idx],"PROCESS_TYPE");
		po_no       = Sheet.GetCellValue(arrRow[idx],"PO_NO");
		msds_po_no	= Sheet.GetCellValue(arrRow[idx],"PO_NO");
		po_seq      = Sheet.GetCellValue(arrRow[idx],"PO_SEQ");
		cd_qty      = Sheet.GetCellValue(arrRow[idx],"DS_INV_QTY");
		inv_poss_qty = Sheet.GetCellValue(arrRow[idx],"INV_POSS_QTY");
		ds_date      = Sheet.GetCellValue(arrRow[idx],"DS_DATE");
		item_qty      = Sheet.GetCellValue(arrRow[idx],"ITEM_QTY");
		iv_qty			=Sheet.GetCellValue(arrRow[idx],"IV_QTY");
		
		pop_key=Sheet.GetCellValue(arrRow[idx],"POP_KEY");
		// MSDS 진행 통제 체크
		cod_check = Sheet.GetCellValue(arrRow[idx],"COD_CHECK");
    	msds_check = Sheet.GetCellValue(arrRow[idx],"MSDS_CHECK");
    	req_check = Sheet.GetCellValue(arrRow[idx],"REQ_CHECK");
    	temp_req_check = Sheet.GetCellValue(arrRow[idx],"TEMP_REQ_CHECK");
    	
    	var flag1 = false;
    	var flag2 = false;
    	
    	if(cod_check=="Y" && msds_check=="Y" && req_check=="N"){ //물질정보등록 대상이면서 msds미매핑 건 이면서 입력요청 외에 다른 상태 건 이 없는 경우 거래명세서 작성 통제
    		flag1 = true;
    		for(var i = 0; i<buyer_item_no_arr.length;i++){ //buyer_item_no 중복 출력 방지
    			if(Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO")==buyer_item_no_arr[i]){
    				flag1 = false;
		    		break;		
    			}
    		}
    		if(flag1){
    			buyer_item_no_arr.push(Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO"));
    		}
     	}
    	
    	if(cod_check=="Y" && msds_check=="Y"){ // MSDS 대상 표준카테고리에 해당하고 카탈로그 MSDS 미매핑 품목 리스트 - 통제 2024.07.19 HSJ
    		flag2 = true;
    	 	for(var i = 0; i<msds_no_reg_buyer_item_no_arr.length;i++){ //buyer_item_no 중복출력 방지
     			if(Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO")==msds_no_reg_buyer_item_no_arr[i]){
     				flag2 = false;
 		    		break;		
     			}
     		}
     		if(flag2){
     			msds_no_reg_buyer_item_no_arr.push(Sheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO"));
     		}
     	}
    	
    	if(flag1==true){
    		if(msds_po_no != msds_po_no_bef){ // 중복 발주번호는 전송하지 않음, 대상 품목 있는 발주번호만 전송
				msds_query +=  buyer      + "@@";
				msds_query +=  msds_po_no + "@@";
				msds_query +=  "^||^";	
			}
    	}
    	
    	// 매입단가유효일 진행 통제
    	buy_close_date_chk = Sheet.GetCellValue(arrRow[idx],"BUY_CLOSE_DATE_CHK");
		if(buy_close_date_chk == "Y"){
// 			alert("해당 건 진행할 수 없습니다.\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
			var text = "해당 건 진행할 수 없습니다.</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
    	
		if(cd_qty > item_qty){
// 			alert("납품수량이 발주수량보다 클 수 없습니다");
			var text = "납품수량이 발주수량보다 클 수 없습니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			Sheet.SelectCell(arrRow[idx],"DS_INV_QTY");
			return;
		}
		if(cd_qty > inv_poss_qty){
// 			alert("납품가능수량("+inv_poss_qty+") 이하로 입력해주십시오.");
			var text = "납품가능수량("+inv_poss_qty+") 이하로 입력해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			Sheet.SelectCell(arrRow[idx],"DS_INV_QTY");
			return;
		}
		
		var param = {
				"BUYER" : buyer
				,"PO_NO" : po_no
				,"PO_SEQ" : po_seq
				,"CD_QTY" : cd_qty
				,"DS_DATE" : ds_date
				,"PO_QTY" : item_qty
				,"IV_QTY" : iv_qty
				,"INV_POSS_QTY" : inv_poss_qty
				,"PROCESS_TYPE" : process_type
				,"SELLER" : Sheet.GetCellValue(arrRow[idx],"SELLER")
			};
		rowJson = JSON.stringify(param);
		rowList.push(rowJson);
		
		query +=  pop_key + "@@";
		query +=  cd_qty;                
		query +=  "^||^";
	}
	
	gridJsonList =  "[" + rowList.toString() + "]";
// 	$("#infoAll").val(gridJsonList);
<%-- 	$("#p_user_id_all").val("<%=p_user_id%>"); --%>
// 	$("#st_query_all").val(query);

	popParams.st_query_all = query;
	
	
	if(buyer_item_no_arr.length != 0){ //수주접수 통제해야되는 건이 있는 경우
		g_query = msds_query;
		var text = "해당 품목 ("+buyer_item_no_arr+") 은 MSDS 제출이 필요합니다.</br>MSDS 등록 후 KeP 승인이 완료되면 거래명세서 생성을 진행할 수 있습니다.</br>KeP 승인완료 전에는 거래명세서 생성이 제한됩니다.";
		var but1textC = "확인";
		var but2textC = "MSDS관리 바로가기";
		var but1funcC = "javascript:reqAndClose(); return false;";
		var but2funcC = "javascript:reqAndMove(); return false;";
		var but1widthC = "120px";
		var but2widthC = "170px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
// 		if(confirm("해당 품목 ("+buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n\n카탈로그 관리 > 물질정보 제출 화면으로 이동하셔서 MSDS 및 물질정보 제출 후 KEP에서 MSDS매핑이 완료되면 거래명세서 작성하시기 바랍니다.\n\n*문의사항은 거래명세서 작성 화면에 있는 KeP담당자 통해서 하시길 바랍니다.")){
// 			//KEP_CMC_REQ insert 코드
// 			document.forms.setChemInfoForm.st_query.value = msds_query;
// 			kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteChemicalInfo.do","setChemInfoForm","saveChemInfo");
// 		}
		return;
	}
	
	if(msds_no_reg_buyer_item_no_arr.length != 0){
		var text = "해당 품목 ("+msds_no_reg_buyer_item_no_arr+") 은 MSDS 제출이 필요합니다.</br>MSDS 등록 후 KeP 승인이 완료되면 거래명세서 생성을 진행할 수 있습니다.</br>KeP 승인완료 전에는 거래명세서 생성이 제한됩니다.";
		var but1textC = "확인";
		var but2textC = "MSDS관리 바로가기";
		var but1funcC = "javascript:layerPopClose(); return false;";
		var but2funcC = "javascript:layerPopMove(); return false;";
		var but1widthC = "120px";
		var but2widthC = "160px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
// 		alert("해당 품목 ("+msds_no_reg_buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n현재 MSDS가 매핑되어 있지 않아 진행이 불가하니 확인하여 주시기 바랍니다.\n*문의사항은 거래명세서 작성 화면에 있는 KeP담당자 통해서 하시길 바랍니다.");
		return;
	}
	
	var hdnKey = "st_buyer_code|st_req_user_info|st_gr_flag|st_com_code";
	var hdnVal = "${st_buyer_code}|${st_req_user_info}|${st_gr_flag}|${sessionInfo.comCode}";
	
	$("#contentForm").append(kepHiddenString(hdnKey, hdnVal));
	
	var url = "/mpiv/showSellerMpIvTranStatementWriteAllPop_v2.do";
	openLayerPop3(url,gridJsonList,popParams,"890px","420px");
	
// 	openSearchPopupPost("/mpiv/showSellerMpIvTranStatementWriteAllPop_v2.do","tranStatementWriteAllForm","tranStatementWriteAllForm", "width=890,height=420,resizable=no,scrollbars=no, top=200, left=400");
	
}
function sheetWin(flag){
	if(flag == "S"){
		var buyer = Sheet.GetCellValue(grbRow,"BUYER");
		var process_type = Sheet.GetCellValue(grbRow,"PROCESS_TYPE");
		var solb_legacy_po_no = Sheet.GetCellValue(grbRow,"DHIM_LEGACY_PO_NO");
		var solb_if_buyer_flag = Sheet.GetCellValue(grbRow,"SOLB_IF_BUYER");
		var seller = Sheet.GetCellValue(grbRow,"SELLER");
		var inv_no = Sheet.GetCellValue(grbRow,"INV_NO");
		var rpt_url = Sheet.GetCellValue(grbRow,"RPT_URL");
		var legacy_po_no = Sheet.GetCellValue(grbRow,"LEGACY_PO_NO"); 
		var pur_id = Sheet.GetCellValue(grbRow,"PURCHASER_ID"); 
		var legacy_iv_serial = Sheet.GetCellValue(grbRow, "LEGACY_INVOICE_KEY");
		var tr_buyer = Sheet.GetCellValue(grbRow, "TR_BUYER");
		var no_tag_check_yn = Sheet.GetCellValue(grbRow, "NO_TAG_CHECK_YN");
		var no_itemTag_check_yn = Sheet.GetCellValue(grbRow, "NO_ITEMTAG_CHECK_YN");
		var p070000034 = Sheet.GetCellValue(grbRow, "P070000034");
		var siv00001_TYPE = Sheet.GetCellValue(grbRow, "SIV00001_TYPE");
		var siv00001_RD1 = Sheet.GetCellValue(grbRow, "SIV00001_RD1");
		var siv00001_RD2 = Sheet.GetCellValue(grbRow, "SIV00001_RD2");
		var dely_to_location_code = Sheet.GetCellValue(grbRow, "DELY_TO_LOCATION"); 
		var cqdt_item_no = Sheet.GetCellValue(grbRow, "CQDT_ITEM_NO");
		
		var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]";
		
		if(solb_if_buyer_flag == "Y" && solb_legacy_po_no == "4" && process_type == "0" && legacy_iv_serial == ""){ // 솔브레인 IF 발주
// 			alert("거래명세서를 고객사 시스템에 등록중입니다.(납품서 출력은 약 20분 후 가능합니다)\n출력이 지연되면 KeP담당자에게 문의하시기 바랍니다.");
			var text = "거래명세서를 고객사 시스템에 등록중입니다.(납품서 출력은 약 20분 후 가능합니다)</br>출력이 지연되면 KeP담당자에게 문의하시기 바랍니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		if(process_type == "2" && no_tag_check_yn == "N"){
			var print_size = $("#st_print_size").val();
			var ktag_box_qty = Sheet.GetCellValue(grbRow, "KTAG_BOX_QTY");
			
			
			if(print_size == "N"){
	   			rpt_url = "RD_06_S_001_170";
	   		}else if(print_size == "L"){
	   			rpt_url = "RD_06_S_001_171";
	   		}
			
			param = "["+inv_no+"]["+seller+"]["+buyer+"]["+ktag_box_qty+"]";
			
			openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
			
			if(no_itemTag_check_yn == "Y"){
				rpt_url = p070000034;
				param = "["+inv_no+"]["+seller+"]["+buyer+"]";
				
				openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
			}
		}else{
			openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
		}
		
		// 특수 상황에 RD파일 추가 출력 필요 고객사 START
    	if(siv00001_TYPE != ""){
    		if(siv00001_TYPE == "TYPE01"){ // 세스코
    			if(dely_to_location_code == "DS431" && cqdt_item_no != ""){ // DS431 : 안성물류센터
    				// 기본 박스라벨 출력
    				rpt_url = siv00001_RD1;
        			param = "["+inv_no+"]["+seller+"]["+buyer+"]";
        			
        			openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
        			
					if(cqdt_item_no != "X"){ // X가 아니면 품목바코드도 출력
						rpt_url = siv00001_RD2;
	        			param = "["+inv_no+"]["+seller+"]["+buyer+"]";
	        			
	        			openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
    				}
    			}
    		}
		}
    	// 특수 상황에 RD파일 추가 출력 필요 고객사 END
	}else if(flag == "M"){
		var url ="/coco/showReportMultiViewer.do";
		
		var checkRows = Sheet.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");

		var rptList = {};
		var param = "";
		
		var invStr = "";
		var buyer = "";
		var inv_no = "";
		
		var checkCount = 0;
		for(var idx = 0; idx<arrRow.length;idx++){
			if(invStr.indexOf(Sheet.GetCellValue(arrRow[idx],"INV_NO")) <0){ //같은 inv_no는 안합쳐도됨
				inv_no = Sheet.GetCellValue(arrRow[idx],"INV_NO");
				invStr = invStr + inv_no + ",";
				checkCount ++;
			}else{
				continue;
			}
		}
		if(checkCount >5){
// 			alert("최대 5개까지 출력가능합니다.");
			var text = "최대 5개까지 출력가능합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		invStr = "";
		
		for(var idx = 0; idx<arrRow.length;idx++){
			if(buyer == ""){
				buyer = Sheet.GetCellValue(arrRow[idx],"BUYER");
			}else{
				if(buyer != Sheet.GetCellValue(arrRow[idx],"BUYER")){
// 					alert("동일 고객사만 한번에 여러 건 출력이 가능합니다.");
					var text = "동일 고객사만 한번에 여러 건 출력이 가능합니다.";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
			}
			
			if(invStr.indexOf(Sheet.GetCellValue(arrRow[idx],"INV_NO")) <0){ //같은 inv_no는 안합쳐도됨
				inv_no = Sheet.GetCellValue(arrRow[idx],"INV_NO");
				invStr = invStr + inv_no + ",";
			}else{
				continue;
			}
			
			var process_type = Sheet.GetCellValue(arrRow[idx],"PROCESS_TYPE");
			var solb_legacy_po_no = Sheet.GetCellValue(arrRow[idx],"DHIM_LEGACY_PO_NO");
			var solb_if_buyer_flag = Sheet.GetCellValue(arrRow[idx],"SOLB_IF_BUYER");
			var seller = Sheet.GetCellValue(arrRow[idx],"SELLER");
			var rpt_url = Sheet.GetCellValue(arrRow[idx],"RPT_URL");
			var legacy_po_no = Sheet.GetCellValue(arrRow[idx],"LEGACY_PO_NO"); 
			var pur_id = Sheet.GetCellValue(arrRow[idx],"PURCHASER_ID"); 
			var legacy_iv_serial = Sheet.GetCellValue(arrRow[idx], "LEGACY_INVOICE_KEY");
			var tr_buyer = Sheet.GetCellValue(arrRow[idx], "TR_BUYER");
			var no_tag_check_yn = Sheet.GetCellValue(arrRow[idx], "NO_TAG_CHECK_YN");
			var no_itemTag_check_yn = Sheet.GetCellValue(arrRow[idx], "NO_ITEMTAG_CHECK_YN");
			var p070000034 = Sheet.GetCellValue(arrRow[idx], "P070000034");
			
			param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]" + "@@";
			
			if(solb_if_buyer_flag == "Y" && solb_legacy_po_no == "4" && process_type == "0" && legacy_iv_serial == ""){ // 솔브레인 IF 발주
// 				alert("거래명세서를 고객사 시스템에 등록중입니다.(납품서 출력은 약 20분 후 가능합니다)\n출력이 지연되면 KeP담당자에게 문의하시기 바랍니다.");
				var text = "거래명세서를 고객사 시스템에 등록중입니다.(납품서 출력은 약 20분 후 가능합니다)</br>출력이 지연되면 KeP담당자에게 문의하시기 바랍니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			if((buyer=="KRKOLO0097" || buyer=="KRKOLO0098" || buyer=="KRKOLO0099" || 
					   buyer=="KRKOLO0100" || buyer=="KRKOLO0101" || buyer=="KRKOLO0102" ||
					   buyer=="KRKOLO0103" || buyer=="KRKOLO0104" || buyer=="KRKOLO0105" ||
					   buyer=="KRKOLO0106" || buyer=="KRKOLO0107" || buyer=="KRKOLO0108" ||
					   buyer=="KRKOLO0109" || buyer=="KRKOLO0110" || buyer=="KRKOLO0111" ||
					   buyer=="KRKOLO0112" || buyer=="KRKOLO0113" || buyer=="KRKOLO0114" ||
					   buyer=="KRKOLO0115" || buyer=="KRKOLO0116" || buyer=="KRKOLO0117" ||
					   buyer=="KRKTPI0002"|| buyer=="KRKOLO0145")&& buyer == tr_buyer ) {
				if(legacy_iv_serial == ""){
// 					alert("고객사 시스템에 등록중입니다.\n(납품서 출력은 약 20분 후 가능합니다)");
					var text = "고객사 시스템에 등록중입니다.</br>(납품서 출력은 약 20분 후 가능합니다)";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				} 
			}
			if(buyer=="KRKORE0212" && buyer == tr_buyer ) {
				if(legacy_iv_serial == ""){
// 					alert("고객사 시스템에 등록중입니다.\n(납품서 출력은 약 20분 후 가능합니다)");
					var text = "고객사 시스템에 등록중입니다.</br>(납품서 출력은 약 20분 후 가능합니다)";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
			}
			
			if(process_type == "2" && no_tag_check_yn == "N"){
				var print_size = $("#st_print_size").val();
				var ktag_box_qty = Sheet.GetCellValue(arrRow[idx], "KTAG_BOX_QTY");
				
				if(print_size == "N"){
		   			rpt_url = "RD_06_S_001_170";
		   		}else if(print_size == "L"){
		   			rpt_url = "RD_06_S_001_171";
		   		}
				
				param = "["+inv_no+"]["+seller+"]["+buyer+"]["+ktag_box_qty+"]" + "@@";
				
				var rptTemp = rpt_url.split("^");
				for(var i = 0; i<rptTemp.length; i++){
					if(rptList[rptTemp[i]] == undefined){
						rptList[rptTemp[i]] = param;
					}else{
						rptList[rptTemp[i]] += param;
					}
				}
// 				openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
				
				if(no_itemTag_check_yn == "Y"){
					rpt_url = p070000034;
					param = "["+inv_no+"]["+seller+"]["+buyer+"]" + "@@";
					
					if(rptList[rpt_url] == undefined){
						rptList[rpt_url] = param;
					}else{
						rptList[rpt_url] += param;
					}
// 					openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
				}
			}else{
				var rptTemp = rpt_url.split("^");
				for(var i = 0; i<rptTemp.length; i++){
					if(rptList[rptTemp[i]] == undefined){
						rptList[rptTemp[i]] = param;
					}else{
						rptList[rptTemp[i]] += param;
					}
				}
// 				openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
			}
		}

		for(var key in rptList){
			var params = rptList[key].substr(0,rptList[key].length-2);
			params += "^^"
			var rdParams = [];
			rdParams.push({key:"fileName", value:key});
			rdParams.push({key:"param", value:params});
			
			OpenReportPost(url, key, rdParams);
		}
		
		
	}
	
}
function sheetTagListWin4(flag) {
	if(flag == "S"){
		var ktag_start = 1;
		var url ="/coco/showReportViewer.do";
		var ktag_box_qty = 1;	// 품목태그는 수량 관계없이 항상 기본 1장씩 출력(한애희)
		var ktag_rpt = Sheet.GetCellValue(grbRow,"KTAG_YN");
		var fileName = "";
		var buyer = Sheet.GetCellValue(grbRow,"BUYER");
		var process_type = Sheet.GetCellValue(grbRow,"PROCESS_TYPE");
		var seller = Sheet.GetCellValue(grbRow,"SELLER");
		var inv_no = Sheet.GetCellValue(grbRow,"INV_NO");
		var legacy_po_no = Sheet.GetCellValue(grbRow,"LEGACY_PO_NO"); 
		var pur_id = Sheet.GetCellValue(grbRow,"PURCHASER_ID"); 
		var tr_buyer = Sheet.GetCellValue(grbRow, "TR_BUYER");
		var no_itemTag_check_yn = Sheet.GetCellValue(grbRow, "NO_ITEMTAG_CHECK_YN");
		if(ktag_rpt == "Y" || (tr_buyer == "KRKORE0068" && no_itemTag_check_yn=="N")){
			var print_size = $("#st_print_size").val();
			
			
			if(print_size == "L"){
		 		fileName = "RD_06_X_002_20";
		 	}else if(print_size == "N"){
		 		fileName = "RD_06_X_002_19";
		 	}
			
		   	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]";   
		   	
		   	reportOpen(fileName, param); 
		}else{
// 			alert("품목라벨 제출이 필요한 고객사만 출력 가능합니다.");
			var text = "품목라벨 제출이 필요한 고객사만 출력 가능합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
			
	}else{
		var url ="/coco/showReportMultiViewer.do";
		
		var checkRows = Sheet.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		// 선택된 항목 유무 체크
		if (checkRows.length == 0) {
// 			alert("항목을 선택해주세요.");
			var text = "항목을 선택해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		var fileName = "";
		var param = "";
		var rdParams = [];
		
		var invStr = "";
		var buyer = "";
		var inv_no = "";
		
		var checkCount = 0;
		for(var idx = 0; idx<arrRow.length;idx++){
			if(invStr.indexOf(Sheet.GetCellValue(arrRow[idx],"INV_NO")) <0){ //같은 inv_no는 안합쳐도됨
				inv_no = Sheet.GetCellValue(arrRow[idx],"INV_NO");
				invStr = invStr + inv_no + ",";
				checkCount ++;
			}else{
				continue;
			}
		}
		if(checkCount >5){
// 			alert("최대 5개까지 출력가능합니다.");
			var text = "최대 5개까지 출력가능합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		invStr = "";
		
		for(var idx = 0; idx<arrRow.length;idx++){
			if(buyer == ""){
				buyer = Sheet.GetCellValue(arrRow[idx],"BUYER");
			}else{
				if(buyer != Sheet.GetCellValue(arrRow[idx],"BUYER")){
// 					alert("동일 고객사만 한번에 여러 건 출력이 가능합니다.");
					var text = "동일 고객사만 한번에 여러 건 출력이 가능합니다.";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
			}
			
			if(invStr.indexOf(Sheet.GetCellValue(arrRow[idx],"INV_NO")) <0){ //같은 inv_no는 안합쳐도됨
				inv_no = Sheet.GetCellValue(arrRow[idx],"INV_NO");
				invStr = invStr + inv_no + ",";
			}else{
				continue;
			}
			
			var ktag_start = 1;
// 			var url ="/coco/showReportViewer.do";
			var ktag_box_qty = 1;	// 품목태그는 수량 관계없이 항상 기본 1장씩 출력(한애희)
			var ktag_rpt = Sheet.GetCellValue(arrRow[idx],"KTAG_YN");
			
// 			var buyer = Sheet.GetCellValue(arrRow[idx],"BUYER");
			var process_type = Sheet.GetCellValue(arrRow[idx],"PROCESS_TYPE");
			var seller = Sheet.GetCellValue(arrRow[idx],"SELLER");
// 			var inv_no = Sheet.GetCellValue(arrRow[idx],"INV_NO");
			var legacy_po_no = Sheet.GetCellValue(arrRow[idx],"LEGACY_PO_NO"); 
			var pur_id = Sheet.GetCellValue(arrRow[idx],"PURCHASER_ID"); 
			var tr_buyer = Sheet.GetCellValue(arrRow[idx], "TR_BUYER");
			var no_itemTag_check_yn = Sheet.GetCellValue(arrRow[idx], "NO_ITEMTAG_CHECK_YN");
			if(ktag_rpt == "Y" || (tr_buyer == "KRKORE0068" && no_itemTag_check_yn=="N")){
				var print_size = $("#st_print_size").val();
				
				
				if(print_size == "L"){
			 		fileName = "RD_06_X_002_20";
			 	}else if(print_size == "N"){
			 		fileName = "RD_06_X_002_19";
			 	}
				
			   	param += "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]" + "@@";   
			   	
// 			   	reportOpen(fileName, param); 
			}else{
// 				alert("품목라벨 제출이 필요한 고객사만 출력 가능합니다.");
				var text = "품목라벨 제출이 필요한 고객사만 출력 가능합니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			
		}
		
		var params = param.substr(0,param.length-2);
		params += "^^"
		rdParams.push({key:"fileName", value:fileName});
		rdParams.push({key:"param", value:params});
		
		OpenReportPost(url, "TAGPOP", rdParams);
	}
	

	return;
}
function excelDownload(){
	if(Sheet.RowCount() == 0){
// 		alert("조회된 데이터가 없습니다.");
		var text = "조회된 데이터가 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	// 선택된 항목 유무 체크
	if (checkRows.length == 0) {
// 		alert("상품을 선택해주세요.");
		var text = "항목을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	Sheet.SetWaitImageVisible(true);
	
	var downRow = "|0";
	for(var i=1; i<=Sheet.RowCount(); i++) {
		if(Sheet.GetCellValue(i,"SELECTED"))
			downRow += "|"+i;
	}
	
	var downCol = "";
	for(var i=0; i<=Sheet.LastCol(); i++){
		if(!Sheet.GetColHidden(i) && Sheet.ColSaveName(i) !="SELECTED" && Sheet.GetCellProperty(1, i, "Type") != "Image"){
			downCol += "|"+i;
		}
	}
	
	if(downRow == "|0"){
		downRow = "";
	}
	var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
	
	var fileName = "";
	if(currIndex == 0){
		fileName = "거래명세서_PO별_";
	}else if(currIndex == 1){
		fileName = "거래명세서_품목별_";
	}else if(currIndex == 2){
		fileName = "거래명세서_일괄_";
	}else{
		fileName = "거래명세서_출력_";
	}
	var param = {FileName:fileName+nowTime, SheetName:fileName, DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
	Sheet.Down2Excel(param);
}
function getReportUrl(){
	var checkRows = Sheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	// 선택된 항목 유무 체크
	if (checkRows.length == 0) {
// 		alert("항목을 선택해주세요.");
		var text = "항목을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var query = "";
	
	var invStr = "";
	var buyer = "";
	var inv_no = "";
	
	var checkCount = 0;
	for(var idx = 0; idx<arrRow.length;idx++){
		if(invStr.indexOf(Sheet.GetCellValue(arrRow[idx],"INV_NO")) <0){ //같은 inv_no는 안합쳐도됨
			inv_no = Sheet.GetCellValue(arrRow[idx],"INV_NO");
			invStr = invStr + inv_no + ",";
			checkCount ++;
		}else{
			continue;
		}
	}
	if(checkCount >5){
// 		alert("최대 5개까지 출력가능합니다.");
		var text = "최대 5개까지 출력가능합니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	invStr = "";
	
	var rpt_url_check = false;
	for(var idx = 0 ; idx<arrRow.length;idx++){
		if(buyer == ""){
			buyer = Sheet.GetCellValue(arrRow[idx],"BUYER");
		}else{
			if(buyer != Sheet.GetCellValue(arrRow[idx],"BUYER")){
// 				alert("동일 고객사만 한번에 여러 건 출력이 가능합니다.");
				var text = "동일 고객사만 한번에 여러 건 출력이 가능합니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
		}
		
		if(invStr.indexOf(Sheet.GetCellValue(arrRow[idx],"INV_NO")) <0){ //같은 inv_no는 안합쳐도됨
			inv_no = Sheet.GetCellValue(arrRow[idx],"INV_NO");
			invStr = invStr + inv_no + ",";
		}else{
			continue;
		}
		
		var process_type = Sheet.GetCellValue(arrRow[idx],"PROCESS_TYPE");
		var solb_legacy_po_no = Sheet.GetCellValue(arrRow[idx],"DHIM_LEGACY_PO_NO");
		var solb_if_buyer_flag = Sheet.GetCellValue(arrRow[idx],"SOLB_IF_BUYER");
		var rpt_url = Sheet.GetCellValue(arrRow[idx],"RPT_URL");
		if(rpt_url == ""){
			rpt_url_check = true;
		}
		var legacy_iv_serial = Sheet.GetCellValue(arrRow[idx], "LEGACY_INVOICE_KEY");
		var tr_buyer = Sheet.GetCellValue(arrRow[idx], "TR_BUYER");
		
		if(solb_if_buyer_flag == "Y" && solb_legacy_po_no == "4" && process_type == "0" && legacy_iv_serial == ""){ // 솔브레인 IF 발주
// 			alert("거래명세서를 고객사 시스템에 등록중입니다.(납품서 출력은 약 20분 후 가능합니다)\n출력이 지연되면 KeP담당자에게 문의하시기 바랍니다.");
			var text = "거래명세서를 고객사 시스템에 등록중입니다.(납품서 출력은 약 20분 후 가능합니다)</br>출력이 지연되면 KeP담당자에게 문의하시기 바랍니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		if((buyer=="KRKOLO0097" || buyer=="KRKOLO0098" || buyer=="KRKOLO0099" || 
				   buyer=="KRKOLO0100" || buyer=="KRKOLO0101" || buyer=="KRKOLO0102" ||
				   buyer=="KRKOLO0103" || buyer=="KRKOLO0104" || buyer=="KRKOLO0105" ||
				   buyer=="KRKOLO0106" || buyer=="KRKOLO0107" || buyer=="KRKOLO0108" ||
				   buyer=="KRKOLO0109" || buyer=="KRKOLO0110" || buyer=="KRKOLO0111" ||
				   buyer=="KRKOLO0112" || buyer=="KRKOLO0113" || buyer=="KRKOLO0114" ||
				   buyer=="KRKOLO0115" || buyer=="KRKOLO0116" || buyer=="KRKOLO0117" ||
				   buyer=="KRKTPI0002"|| buyer=="KRKOLO0145")&& buyer == tr_buyer ) {
			if(legacy_iv_serial == ""){
// 				alert("고객사 시스템에 등록중입니다.\n(납품서 출력은 약 20분 후 가능합니다)");
				var text = "고객사 시스템에 등록중입니다.</br>(납품서 출력은 약 20분 후 가능합니다)";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			} 
		}
		if(buyer=="KRKORE0212" && buyer == tr_buyer ) {
			if(legacy_iv_serial == ""){
// 				alert("고객사 시스템에 등록중입니다.\n(납품서 출력은 약 20분 후 가능합니다)");
				var text = "고객사 시스템에 등록중입니다.</br>(납품서 출력은 약 20분 후 가능합니다)";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
		}
		query = query+Sheet.GetCellValue(arrRow[idx],"BUYER")+"@@"+Sheet.GetCellValue(arrRow[idx],"PO_NO")+"@@"+Sheet.GetCellValue(arrRow[idx],"INV_NO")+"@@"+$("#st_user_id"+currIndex).val()+"##";
	}
	
	if(rpt_url_check){
		$("#st_query_rpt_url").val(query);
		kepAjaxFormCall("/mpiv/getSellerMpIvTranStatementWriteRptUrl_v2.do","tranStatementWriteRptUrlForm","getRptUrlMulti");
	}else{
		sheetWin("M");
	}
}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	g_query = "";
	if(pMethod == "saveChemInfo"){
		doAction('search');
	}else if(pMethod == "saveChemInfoMove"){
		location.href = "/mdct/showSellerMdCmChemicalMatMngList.do?menuId=sr00202000000";
	}else if(pMethod == "getRptUrlMulti"){
		var rptUrlQuery = response.rptUrl;
		var rowTemp = rptUrlQuery.split("^||^");
		for(var i = 0; i<rowTemp.length-1; i++){
			var colTemp = rowTemp[i].split("@@");
			
			var checkRows = Sheet.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			
			for(var idx = 0; idx<arrRow.length; idx++ ){
				if(Sheet.GetCellValue(arrRow[idx],"BUYER") == colTemp[0] && Sheet.GetCellValue(arrRow[idx],"INV_NO") == colTemp[1]){
					Sheet.SetCellValue(arrRow[idx],"RPT_URL",colTemp[2]);
				}
			}
		}
		
		sheetWin("M");
		
	}else if(pMethod == "getRptUrl"){
		var rptUrlQuery = response.rptUrl;
		var rowTemp = rptUrlQuery.split("^||^");
		for(var i = 0; i<rowTemp.length-1; i++){
			var colTemp = rowTemp[i].split("@@");
			Sheet.SetCellValue(grbRow,"RPT_URL",colTemp[2]);
		}
		
		sheetWin("S");
		
	}
	
	// 특수로직 추가 후 주석 풀기!!! 
	//opener.setQuery();
	//window.close();
	
	return;
}
//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response,msg){
	var msg = response.msg;
	
	if (!isEmpty(msg)){
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	return;
}
function reqAndClose(){
	closePopText1();
    
    document.forms["setChemInfoForm"].st_query.value = g_query;
	kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteChemicalInfo.do","setChemInfoForm","saveChemInfo");
}
function reqAndMove(){
	closePopText1();
    document.forms["setChemInfoForm"].st_query.value = g_query;
	kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteChemicalInfo.do","setChemInfoForm","saveChemInfoMove");
}
function layerPopClose(){
	closePopText1();
}
function layerPopMove(){
	closePopText1();
    location.href = "/mdct/showSellerMdCmChemicalMatMngList.do?menuId=sr00202000000";
}

function msdsMove(){
	location.href = "/mdct/showSellerMdCmChemicalMatMngList.do?menuId=sr00202000000";
}
</script>
</head>
<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader_sub_v2"/>
<c:param name="part" value="header_v2"/>
</c:import>
<div id="container2">
<c:import charEncoding="utf-8" url="/main/leftMenuData.do">
<c:param name="page" value="sellerLeft_v2"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
	<!-- 컨텐츠 -->
	<div class="containerBoxSub" >
	  
      <div class="PDleft50"><!--padding-left:50px; 시작 -->    
		<div class="SubTit">
		<%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star"></button>
     	<%} %>
          거래명세서
          <div class="SummaryGuide">
      	    <ul>
        	  <li><img src="/resources/imgs/Icon_Home.png" /></li>
              <li>납품관리</li>
              <li>거래명세서</li>
            </ul>
          </div>
        </div>
        <div class="SubSearchTab">
         <button class="TabTit active" data-tab="Search1">거래명세서(PO별)</button>
         <button class="TabTit" data-tab="Search2">거래명세서(품목별)</button>
         <button class="TabTit" data-tab="Search3">거래명세서(일괄)</button> 
         <button class="TabTit" data-tab="Search4">거래명세서 출력 및 삭제</button>
        </div>
        <form id="searchCondition0" name="searchCondition0" method="post">
        <input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_com_code" id="st_com_code0" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id0" value="${sessionInfo.userId}">
		<input type="hidden" name="st_rd_date" id="st_rd_date0" value="">
        <div id="Search1" class="SearchContent active">
          <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> 발주번호(PO)별 거래명세서를 생성 할 수 있습니다. </div>
          <table class="TabSearchTable" >
            <colgroup>
              <col width="79px" />
              <col width="600px" /> 
              <col width="70px" />
              <col width="400px" />
            </colgroup>            	
            <tr>
              <th>기간</th>
              <td >
                <select name="st_date_type" class="Select" style=" float:left;width:120px; margin-right:5px">
                  <option value="st_add_date" selected>수주접수일</option>
                  <option value="st_ds_date">납품예정일</option>
                  <option value="st_po_create_date">발주일</option>
                  <option value="st_rd_date">고객수령희망일</option>
                </select>
                <div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date_0" name="st_from_date" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_0" name="st_to_date" readonly /><span></span></div>
                </div>
                
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','1'); return false;">1개월</button> 
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','2'); return false;">2개월</button>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','3'); return false;">3개월</button>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_0','st_to_date_0','12'); return false;">1년</button>                 
              </td>
              <th>고객사</th>
              <td>
                  <input type="text" class="input30" id="st_buyer_name_0"  name="st_buyer_name" style=" width:250px;"onKeyDown="kepEnter_v2();">
<!--                   <input type="hidden" name="st_buyer_code" id="st_buyer_code_0" value=""> -->
<!--                   <button type="button" onclick="javascript:doPop('commonMpIvTranBuyerChoicePop'); return false;">고객사명</button> -->
			  </td>               
            </tr>
            <tr>           
              <th>발주번호</th>
              <td><input class="input30" style="width:513px" name="st_po_no" type="text" placeholder="여러 개의 발주번호로 조회 가능하며 띄어쓰기 없이 콤마(,)로 구분해서 입력해주세요." onKeyDown="kepEnter_v2();" /></td>
            </tr>
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="doAction('search');return false;">조회</button>
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40" onclick="javascript:excelDownload(); return false;">엑셀다운로드</button>
            </div>
          </div>
          <div class="IBSheet">
          	<script type="text/javascript">
          		createIBSheet("mySheet0", "", "100%");
          	</script>
          </div><!--IBSheet 끝 --> 
          <div class="h50" style="height: 50px;"></div>              
        </div><!--id="Search1" 거래명세서(PO별) 끝 -->
        </form>
        <form id="searchCondition1" name="searchCondition1" method="post">
        <input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_com_code" id="st_com_code1" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id1" value="${sessionInfo.userId}">
		<input type="hidden" name="st_proxy_yn" id="st_proxy_yn" value="<%=p_proxy_yn%>"> 
		<input type="hidden" name="st_rd_date" id="st_rd_date1" value="">     
        <div id="Search2" class="SearchContent">
          <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> 선택한 여러 발주 건을 각각 개별 거래명세서로 한 번에 생성합니다. </div>
          <table class="TabSearchTable" >
            <colgroup>
              <col width="90px" />
              <col width="580px" /> 
              <col width="80px" />
              <col width="220px" />
              <col width="80px" />
              <col width="190px" />
            </colgroup>            	
            <tr>
              <th>기간</th>
              <td >
                <select name="st_date_type" class="Select" style=" float:left;width:120px; margin-right:5px">
                  <option value="st_add_date" selected>수주접수일</option>
                  <option value="st_ds_date">납품예정일</option>
                  <option value="st_po_create_date">발주일</option>
                  <option value="st_rd_date">고객수령희망일</option>
                </select>
                <div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date_1" name="st_from_date" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_1" name="st_to_date" readonly /><span></span></div>
                </div>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','1'); return false;">1개월</button> 
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','2'); return false;">2개월</button>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','3'); return false;">3개월</button>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','12'); return false;">1년</button>            
              </td>
              <th>고객사</th>
              <td>
                  <input type="text" class="input30" id="st_buyer_name_1"  name="st_buyer_name" style=" width:210px; "onKeyDown="kepEnter_v2();">
<!--                   <input type="hidden" name="st_buyer_code" id="st_buyer_code_1" value=""> -->
<!--                   <button type="button" onclick="javascript:doPop('commonMpIvTranBuyerChoicePop'); return false;">고객사명</button> -->
			  </td> 
              <th>품목코드</th>
              <td><input class="input30" style="width:210px" name="st_buyer_item_no" type="text" onKeyDown="kepEnter_v2();"/></td> 
                        
            </tr>
            <tr>           
              <th>발주번호</th>
              <td><input class="input30" style="width:513px" name="st_po_no" type="text" placeholder="여러 개의 발주번호로 조회 가능하며 띄어쓰기 없이 콤마(,)로 구분해서 입력해주세요."  onKeyDown="kepEnter_v2();"/></td>
		      <th>품목명</th>
              <td><input class="input30" style="width:210px" name="st_description" type="text" onKeyDown="kepEnter_v2();"/></td>
              <th>규격</th>
              <td><input class="input30" style="width:210px" name="st_specification" type="text" onKeyDown="kepEnter_v2();"/></td>                                                      
            </tr>
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="doAction('search');return false;">조회</button>
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40" onclick="javascript:excelDownload(); return false;">엑셀다운로드</button></div>
            <div class="right">
              <button class="ButPrimary_Medium" onclick="javascript:doPop('setInvoiceCreateItem'); return false;">거래명세서 생성</button>
            </div>
          </div>
          <div class="IBSheet">
          	<script type="text/javascript">
          		createIBSheet("mySheet1", "", "100%");
          	</script>
          </div><!--IBSheet 끝 --> 
          <div class="h50" style="height: 50px;"></div>    
        </div><!--id="Search2" 거래명세서(품목별) 끝 -->
        </form>
        <form id="searchCondition2" name="searchCondition2" method="post">
        <input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_com_code" id="st_com_code2" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id2" value="${sessionInfo.userId}">      
        <div id="Search3" class="SearchContent">
          <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> 특정 고객사의 거래명세서 생성 시에만 가능한 기능이며, 선택한 여러 발주 건을 하나의 거래명세서로 합쳐 생성합니다. </div>
          <table class="TabSearchTable" >
            <colgroup>
              <col width="90px" />
              <col width="580px" /> 
              <col width="80px" />
              <col width="220px" />
              <col width="80px" />
              <col width="190px" />
            </colgroup>            	
            <tr>
              <th>기간</th>
              <td >
                <select name="st_date_type" class="Select" style=" float:left;width:120px; margin-right:5px">
                  <option value="st_add_date" selected>수주접수일</option>
                  <option value="st_ds_date">납품예정일</option>
                  <option value="st_po_create_date">발주일</option>
                  <option value="st_rd_date">고객수령희망일</option>
                </select>
                <div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date_2" name="st_from_date" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_2" name="st_to_date" readonly /><span></span></div>
                </div>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','1'); return false;">1개월</button> 
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','2'); return false;">2개월</button>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','3'); return false;">3개월</button>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','12'); return false;">1년</button>            
              </td>
              <th><font color="red">*</font>고객사</th>
              <td><div class="SearchBuyer" onSubmit=" " style="width:230px " >
                  <input type="text" placeholder=" " id="st_buyer_name_2"  name="st_buyer_name_2" style=" width:85%; " readonly>
                  <input type="hidden" name="st_buyer_code" id="st_buyer_code_2" value="">
                  <button type="button" onclick="javascript:doPop('commonMpIvTranBuyerChoicePop'); return false;">고객사명</button>
                </div>
			  </td> 
              <th>요청자</th>
              <td><input class="input30" style="width:210px" name="st_ref_add_user_name" type="text" onKeyDown="kepEnter_v2();"/></td>
                        
            </tr>
            <tr>           
              <th>발주번호</th>
              <td><input class="input30" style="width:513px" name="st_po_no" type="text" placeholder="여러 개의 발주번호로 조회 가능하며 띄어쓰기 없이 콤마(,)로 구분해서 입력해주세요."  onKeyDown="kepEnter_v2();"/></td>
		      <th>&nbsp;&nbsp;품목명</th>
              <td><input class="input30" style="width:210px" name="st_description" type="text" onKeyDown="kepEnter_v2();"/></td>
              <th>품목코드</th>
              <td><input class="input30" style="width:210px" name="st_buyer_item_no" type="text" onKeyDown="kepEnter_v2();"/></td>                                                      
            </tr>
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="doAction('search');return false;">조회</button>
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40" onclick="javascript:excelDownload(); return false;">엑셀다운로드</button></div>
            <div class="right">
              <button class="ButPrimary_Medium" onclick="javascript:doPop('setInvoiceCreateAll'); return false;">거래명세서 생성</button>
            </div>
          </div>
          <div class="IBSheet">
          	<script type="text/javascript">
          		createIBSheet("mySheet2", "", "100%");
          	</script>
          </div><!--IBSheet 끝 --> 
          <div class="h50" style="height: 50px;"></div>    
        </div><!--id="Search3" 거래명세서(일괄) 끝 -->
        </form>
        <form id="searchCondition3" name="searchCondition3" method="post">
        <input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_com_code" id="st_com_code3" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id3" value="${sessionInfo.userId}"> 
        <div id="Search4" class="SearchContent">
        <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> 거래명세서를 건별 또는 동일 고객사 기준으로 최대 5건까지 한 번에 출력할 수 있습니다. </div>
<!--           <div class="Importance_row2" style="height: 90px;"> -->
<!--           <img src="/resources/imgs/Icon_Importance.png" />  -->
<!--           		생성된 거래명세서를 한 번에 여러 건을 출력 또는 건별로 출력 하실 수 있습니다.<br/><br/> -->
<!--           <img src="/resources/imgs/Icon_Importance.png" /> -->
<!--           		동일 고객사의 경우 한번에 여러 건을 출력하실 수 있습니다.<br/><br/> -->
<!--           <img src="/resources/imgs/Icon_Importance.png" /> -->
<!--           		거래명세서는 한번에 최대 5개 까지 출력 가능합니다. -->
<!--           </div> -->
          <table class="TabSearchTable" >
            <colgroup>
              <col width="90px" />
              <col width="580px" /> 
              <col width="80px" />
              <col width="220px" />
              <col width="80px" />
              <col width="190px" />
            </colgroup>            	
            <tr>
              <th>기간</th>
              <td >
                <select name="st_date_type" class="Select" style=" float:left;width:160px; margin-right:5px">
                  <option value="st_add_date" selected>거래명세서 생성일</option>
                </select>
                <div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_from_date_3" name="st_from_date" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_to_date_3" name="st_to_date" readonly /><span></span></div>
                </div>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_3','st_to_date_3','1'); return false;">1개월</button> 
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_3','st_to_date_3','2'); return false;">2개월</button>
                <button class="But_MonthSmall" onclick="javascript:kepMonth_v2('st_from_date_3','st_to_date_3','3'); return false;">3개월</button>
              </td>
              <th>고객사</th>
              <td>
                  <input type="text" class="input30" id="st_buyer_name_3"  name="st_buyer_name" style=" width:210px; "onKeyDown="kepEnter_v2();">
<!--                   <input type="hidden" name="st_buyer_code" id="st_buyer_code_3" value=""> -->
<!--                   <button type="button" onclick="javascript:doPop('commonMpIvTranBuyerChoicePop'); return false;">고객사명</button> -->
			  </td>  
              <th>진행상태</th>
              <td><select name="st_dely_type" id ="st_dely_type" class="Select" style="width:232px;">
                  <option value="">전체</option>
                  <option value="DELY_NO" selected>납품실적 등록대상</option>
                  <option value="DELY_YES">납품완료</option>
                </select> </td>
            </tr>
            <tr>           
              <th>발주번호</th>
              <td><input class="input30" style="width:508px" name="st_po_no" type="text" placeholder="여러 개의 발주번호로 조회 가능하며 띄어쓰기 없이 콤마(,)로 구분해서 입력해주세요."  onKeyDown="kepEnter_v2();"/></td>              
              <th>배송유형</th>
              <td><select name="st_parcel_yn" class="Select" style="width:232px;">
                  <option value="" selected>전체</option>
                  <option value="Y">택배</option>
                  <option value="N">자차</option>
                </select> </td>
              <th>거래명세서번호</th>
              <td><input class="input30" style="width:210px" name="st_inv_no" type="text" onKeyDown="kepEnter_v2();"/></td>                                                  
            </tr>
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" onclick="doAction('reload'); return false;">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="doAction('search');return false;">조회</button>
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40" onclick="javascript:excelDownload(); return false;">엑셀다운로드</button></div>
            <div class="right">
            라벨출력방식 
                <select name="st_print_size" id="st_print_size" class="Select" >
                  <option value="N" selected>일반프린터(A4 4분할)</option>
                  <option value="L">라벨프린터(10x10cm)</option>
                </select>  
<!--             				   <button class="ButPrimary_Medium" onclick="javascript:sheetTagListWin4('M'); return false;">품목라벨 출력</button> -->
<!--             					<button class="ButPrimary_Medium" onclick="javascript:getReportUrl(); return false;">거래명세서 출력</button> -->
            </div>
          </div> 
          <div class="IBSheet">
          	<script type="text/javascript">
          		createIBSheet("mySheet3", "", "100%");
          	</script>
          </div><!--IBSheet 끝 --> 
          <div class="h50" style="height: 50px;"></div>    
        </div><!--id="Search4" 거래명세서출력 끝 -->       
        </form>
		<!-- 탭 스크립트 -->     
		<script>
          const tabLinks = document.querySelectorAll(".TabTit");
          const tabContents = document.querySelectorAll(".SearchContent");
        
          tabLinks.forEach(function(link,index)  {
            link.addEventListener("click", function() {
              // 모든 탭 버튼, 컨텐츠 비활성화
              tabLinks.forEach(function(btn){btn.classList.remove("active")});
              tabContents.forEach(function(content){content.classList.remove("active")});
        
              // 클릭한 탭 활성화
              link.classList.add("active");
              document.getElementById(link.dataset.tab).classList.add("active");
              
              currIndex = index; //현재 탭 index를 저장
              if(currIndex == 0){
            	  Sheet = mySheet0;
              }else if(currIndex == 1){
            	  Sheet = mySheet1;
              }else if(currIndex == 2){
            	  Sheet = mySheet2;
              }else if(currIndex == 3){
            	  Sheet = mySheet3;
              }
              if(currIndex != 2){ //거래명세서(일괄)은 고객사 필수조건이라 바로 조회 안함
	              doAction('search');
              }
            });
          });
          
        //입력했을때 앞 공백 제거
        const inputs = document.querySelectorAll("input[name=st_po_no],input[name=st_description],input[name=st_buyer_item_no],input[name=st_inv_no]");
        inputs.forEach(function(input){
        	  input.addEventListener("input",function(){
        		  this.value = this.value.trimStart();
        	  });
          });
        </script>
      </div> <!--padding-left:50px; 끝 -->
</div><!--containerBoxSub-->
<!--내용 종료-->	        
<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<div id="process">
	
	</div>
</form>
<form name="postPopForm" id="postPopForm" method="post" action ="">
	<input type="hidden" name="st_com_code"  id="st_com_code" value="">
    <input type="hidden" name="st_buyer"  id="st_buyer" value="">
    <input type="hidden" name="st_buyer_name"  id="st_buyer_name" value="">
    <input type="hidden" name="st_po_no"  id="st_po_no" value="">
    <input type="hidden" name="st_ds_date"  id="st_ds_date" value="">
    <input type="hidden" name="st_seller"  id="st_seller" value="">
    <input type="hidden" name="st_process_type"  id="st_process_type" value="">
    <input type="hidden" name="st_legacy_po_no"  id="st_legacy_po_no" value="">
    <input type="hidden" name="st_tr_buyer"  id="st_tr_buyer" value="">
    <input type="hidden" name="st_dely_to_location"  id="st_dely_to_location" value="">
    <input type="hidden" name="st_add_user_id"  id="st_add_user_id" value="">
    <input type="hidden" name="st_ref_pr_no"  id="st_ref_pr_no" value="">
    <input type="hidden" name="st_user_id"  id="st_user_id" value="">    
    <input type="hidden" name="st_agent"  id="st_agent" value="">    
    <!-- <input type="hidden" name="st_gr_flag"  id="st_gr_flag" value=""> -->
</form>
<form name="tranStatementWriteItemForm" id="tranStatementWriteItemForm" method="post">	
	<input type="hidden" name="infoItem" id="infoItem"  value="">
	<input type="hidden" name="trCheck" id="trCheck"  value="N">
	<input type="hidden" name="p_user_id_item" id="p_user_id_item"  value="">
	<input type="hidden" name="p_kep_id" id="p_kep_id"  value="<%=p_kep_id%>">
</form>
<form name="tranStatementWriteAllForm" id="tranStatementWriteAllForm" method="post">	
	<input type="hidden" name="infoAll" id="infoAll"  value="">
	<input type="hidden" name="p_user_id_all" id="p_user_id_all"  value="">
	<input type="hidden" name="st_buyer_code" id="st_buyer_code_all"  value="">
	<input type="hidden" name="st_user_id" id="p_kep_id"  value="<%=p_kep_id%>">
	<input type="hidden" name="st_query_all" id="st_query_all"  value="">
	<input type="hidden" name="st_com_code" id="st_com_code_all" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_po_no_all" id="st_po_no_all"  value="">
</form>
<form name="setChemInfoForm" id="setChemInfoForm" method="post">	
	<input type="hidden" name="st_query" id="st_query"  value="">
	<input type="hidden" name="st_user_id" value="${sessionInfo.userId}">
</form>  	  
<form name="tranStatementWriteRptUrlForm" id="tranStatementWriteRptUrlForm" method="post">	
	<input type="hidden" name="st_query_rpt_url" id="st_query_rpt_url"  value="">
</form>        
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter_sub_v2.jsp" %> 
</div>
</body>
</html>
