<%--
**********************************************
* 메뉴 : 운영사 > 견적관리
* 화면 : 견적의뢰 접수(예)
* 기능 : 고객이 네고 견적의뢰 한 건을 운영담당자가 접수처리를 한다
* 프로그램 ID : PG_04_M_006_00
* 담당자 : 김영미 (설계:권우재)
* 생성일 : 2014-08-07
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
	String st_user_id = _sessionInfo.getUserId();
	String st_user_dept = _sessionInfo.getDepartment();
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
	
	// SMART팀 확인
	String st_smart_dept_yn = "";
	boolean st_smart_dept = CommonUtil.getCodeCheckReturn("SMRTDEPT",st_user_dept);
	if(st_smart_dept == true){
		st_smart_dept_yn = "Y";
	}else{
		st_smart_dept_yn = "N";
	}
	
	// 고객사별 제출가능 단가범위 (P04-4041-09) SQL
%>
<script>
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
	var popupSel = "";
	var remarkOn="/resources/images/but_icon01.gif";
	var remarkOff="/resources/images/but_icon02.gif";
	var diskOn = "/resources/images/disk_on.gif";
	var diskOff = "/resources/images/disk_off.gif";
	var reasonOn = "/resources/images/icon.gif";
	var reasonOff = "/resources/images/icon2.gif";
	
	var cb_item_chg_req_type = KepSheetComboData("DM04","SEL");
	var item_chg_req_type = {ComboCode: cb_item_chg_req_type.ComboCode, ComboText: cb_item_chg_req_type.ComboText};
	
	//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function initPage() {
		var initsheet = {};
		//alert(initsheet.Cols.length);
		initsheet.HeaderMode = {Sort : 0,ColMove : 1,ColResize : 1	};
		initsheet.Cols = [ 
						 {Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
						,{Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적번호",	SaveName:"QUOTATION_NO"}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적순번",	SaveName:"QUOTATION_SEQ"}
						,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"차수(B)",	SaveName:"REVISION"}
						,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"진행구분",	SaveName:"SG_GBN"}
						,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"추가라운드요청",	SaveName:"KEP_RFQ_FLAG" , HeaderCheck:0}
						,{ Align:"Center",	Width:90,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SG담당자YN",	SaveName:"SG_KEP_YN"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
						,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
						,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NAME"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단가구분",	SaveName:"REQ_PRICE_TYPE_TEXT"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}", 	Header:"요청단가",	SaveName:"BUYER_TARGET_PRICE"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}", 	Header:"목표단가",	SaveName:"ADMIN_TARGET_PRICE"}
						,{ Align:"Center",	Width:120,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"회신요청일",	SaveName:"BTOA_END_DT"}
						,{ Align:"Center",	Width:120,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적마감일",	SaveName:"ATOS_END_DT"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",	SaveName:"BTOA_USER_NAME"}
						,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자전화번호",	SaveName:"BTOA_USER_TEL"}
						,{ Align:"Left",	Width:150,	Edit:false,	EditLen:4000,	Hidden:false,	Type:"Text",	Header:"고객사제출비고",	SaveName:"ATOB_REMARK",	Sort:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고(고객사)",	SaveName:"ATOB_REMARK_IMG"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고(협력사)",	SaveName:"ATOS_REMARK_IMG"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고(운영사)",	SaveName:"ATOA_REMARK_IMG"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:4000,	Hidden:false,	Type:"Image",	Header:"취소사유",	SaveName:"CANCEL_REMARK_IMG"}
						,{Align : "Center",SaveName : "DELAY_REASON_IMG",	Header : "견적지연사유",	Type : "Image",	Width : 90,	EditLen : 110,	Edit : false}
						,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"DELAY_REASON_CODE",	SaveName:"DELAY_REASON_CODE",	Sort:0}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"담당자",	SaveName:"KEP_USER_NAME"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
						,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", 		Format:"${qtyFormat}",	Header:"수량",	SaveName:"ITEM_QTY"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Format:"${priceFormat}", 	Header:"매입단가",	SaveName:"STOA_LIST_PRICE"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Format:"${priceFormat}",	Header:"선정업체\n매출단가",	SaveName:"QTDT_ATOB_UNIT_PRICE"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Format:"${priceFormat}",	Header:"네고제출\n매익율(%)",	SaveName:"NEGO_MARGIN_RATE"}
						,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"NEGO요청사유",	SaveName:"REJECT_REMARK"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Format:"${priceFormat}", 	Header:"네고단가",	SaveName:"BTOA_NEGO_PRICE"}
						,{ Align:"Right",	Width:90,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",	Format:"${priceFormat}", 	Header:"제시단가",	SaveName:"ATOB_UNIT_PRICE", BackColor:"${optColor}"}
						,{ Align:"Center",	Width:130,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"추가라운드\n견적마감일",	SaveName:"ATOS_END_DATE2", BackColor:"${optColor}"}
						,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"추가라운드\n견적마감시간",	SaveName:"ATOS_END_TIME2", BackColor:"${optlColor}"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"추가라운드\n견적마감일",	SaveName:"ATOS_END_DATE3"}
						,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"추가라운드\n견적마감시간",	SaveName:"ATOS_END_TIME3"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"추가라운드\n협력사",	SaveName:"AGENT_CNT"}
						,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"영업담당부서",	SaveName:"MNG_DEPT_NM"}
						,{ Align:"Left",	Width:300,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"결재특이사항",	SaveName:"APPROVAL_REMARK"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"상태",	SaveName:"NEGO_STATUS"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자ID",	SaveName:"BTOA_USER_ID"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"담당자",	SaveName:"KEP_USER_ID"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사",	SaveName:"AGENT"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제조사코드",	SaveName:"MAKER_CODE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SG코드",	SaveName:"SG_ID"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"원산지CD",	SaveName:"ORIGIN_CODE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"상품번호",	SaveName:"REG_ITEM_NO"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약번호",	SaveName:"CONTRACT_NO"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약순번",	SaveName:"CONTRACT_SEQ"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BYCA_COMORG_CODE",	SaveName:"BYCA_COMORG_CODE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PASS_FLAG",	SaveName:"PASS_FLAG"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PM_FLAG",	SaveName:"PM_FLAG"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고(고객사)",	SaveName:"BTOA_REMARK"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고(협력사)",	SaveName:"STOA_REMARK"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고(협력사)",	SaveName:"REJECT_REMARK"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고(협력사)",	SaveName:"ATOS_REMARK"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고(협력사)",	SaveName:"ATOS_REMARK2"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고(협력사)",	SaveName:"STOA_REMARK"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고(운영사)",	SaveName:"ATOA_REMARK"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"취소사유",	SaveName:"CANCEL_REMARK"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"취소사유코드",	SaveName:"CANCEL_REMARK_CODE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"RATE_FLAG",	SaveName:"RATE_FLAG"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BUYER_RATE",	SaveName:"BUYER_RATE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SG_NAME",	SaveName:"SG_NAME"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AG_ID",	SaveName:"AG_ID"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AG_SI",	SaveName:"AG_SI"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:2000,	Hidden:true,	Type:"Text",	Header:"추가라운드협력사",	SaveName:"AGENT_LIST"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"MSDS",	SaveName:"MSDS_YN"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",    Header:"MSDS_NO",	SaveName:"MSDS_NO"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",    Header:"MSDS요청번호",	SaveName:"CMC_REQ_NO"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",    Header:"MSDS진행상태",	SaveName:"CMC_REQ_STATUS"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"MSDS요청일시",	SaveName:"CMC_REQ_DATE"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"BUYER_MNG_YN",	SaveName:"BUYER_MNG_YN"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"신용등급평가",	SaveName:"DSS_YN"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"DSS_CHOICE",	SaveName:"DSS_CHOICE"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"OPM_FLAG",	SaveName:"OPM_FLAG"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"RATE",	SaveName:"RATE"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"INIT_BELOW_COMORG_CODE",	SaveName:"INIT_BELOW_COMORG_CODE"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"KEP_RFQ_ORJ_FLAG",	SaveName:"KEP_RFQ_ORJ_FLAG"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"CMPY_QTT_RATE",	SaveName:"CMPY_QTT_RATE"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적담당자",	SaveName:"JOB_TRANSFER_NM",	Sort:0}
						,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적이관일시",	SaveName:"JOB_TRANSFER_DATE",	Sort:0}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"견적담당자ID",	SaveName:"JOB_TRANSFER_ID",	Sort:0}
						,{Align : "Center",	SaveName : "DELAY_SEND_MAIL_FLAG",			Header : "DELAY_SEND_MAIL_FLAG",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"PLANT\n담당자",	SaveName:"PLANT_USER_NM", Sort:1}
						,{Align : "Center",SaveName : "SELL_CLOSE_DATE", Hidden:false, Header : "매출\n단가유효일",	Type : "Date",	Width : 90,	EditLen : 110,	Edit : false}
						,{Align : "Center",SaveName : "BUY_CLOSE_DATE",	Hidden:false, Header : "매입\n단가유효일",	Type : "Date",	Width : 90,	EditLen : 110,	Edit : false}
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제출단가\n확인여부",	SaveName:"UNIT_PRICE_CHECK_FLAG"}
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float",	Format:"${priceFormat}", 	Header:"제출가능\n최저단가",	SaveName:"MIN_UNIT_PRICE"}
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float",	Format:"${priceFormat}", 	Header:"제출가능\n최고단가",	SaveName:"MAX_UNIT_PRICE"}
						,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"선입고",	SaveName:"PRE_GR_FLAG",	Sort:0}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"첨부\n(B)",	SaveName:"IMAGE_KEY_IMG",	Sort:0}
		    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"첨부\n(B)",	SaveName:"IMAGE_KEY",	Sort:0}
		    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"첨부\n(ATOS)",	SaveName:"SELLER_IMAGE_KEY_IMG",	Sort:0}
		    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"첨부\n(ATOS)",	SaveName:"SELLER_IMAGE_KEY",	Sort:0}
		    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"운영\n특이사항",	SaveName:"NOTE_MNG_IMG",	Sort:0}
		    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"네고정비",	SaveName:"NEGO_CMS_REJECT_YN",	Sort:0}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"네고정비\n요청자",	SaveName:"NEGO_ITEM_CHG_REQ_NM", Sort:0}
						,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"네고정비 요청일시",	SaveName:"NEGO_ITEM_CHG_REQ_DATE", Sort:0}
						,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",	Header:"정비구분",			SaveName:"NEGO_ITEM_CHG_REQ_TYPE", Sort:0}
						,{ Align:"Left",	Width:300,	Edit:true,	EditLen:2000,	Hidden:false,	Type:"Text",	Header:"네고정비 요청사유",	SaveName:"NEGO_ITEM_CHG_REQ_NOTE", Sort:0}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"네고정비\n첨부",	SaveName:"NEGO_ITEM_CHG_REQ_IMAGE_KEY_IMG",	Sort:0}
		    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"네고정비\n첨부",	SaveName:"NEGO_ITEM_CHG_REQ_IMAGE_KEY",	Sort:0}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"네고정비\n제출자",	SaveName:"NEGO_ITEM_MD_USER_NM", Sort:0}
						,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"네고정비 제출일시",	SaveName:"NEGO_ITEM_MD_DATE", Sort:0}
						,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"네고정비 제출완료",	SaveName:"NEGO_ITEM_MD_COMPLETE", Sort:0}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"NEGO_ITEM_MD_REVISION",	SaveName:"NEGO_ITEM_MD_REVISION",	Sort:0}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"NEGO_ITEM_CHG_REQ_ID",	SaveName:"NEGO_ITEM_CHG_REQ_ID",	Sort:0}
						,{ Align:"Center",	Width:130,	Edit:false,	EditLen:2000,	Hidden:true,	Type:"Text",	Header:"ADMIN_REMARK",	SaveName:"ADMIN_REMARK",	Sort:1}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:2000,	Hidden:true,	Type:"Text",	Header:"DELAY_FLAG",	SaveName:"DELAY_FLAG",	Sort:1}
		];
		
		IBS_InitSheet2(mySheet, initsheet,pagingMode, 7);

		//비고이미지설정
		mySheet.SetImageList(0, remarkOff);
		mySheet.SetImageList(1, remarkOn);
		mySheet.SetImageList(2, diskOff);
		mySheet.SetImageList(3, diskOn);
		mySheet.SetImageList(8, reasonOff);
		mySheet.SetImageList(9, reasonOn);

		//콤보데이터 셋팅		
		kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','ALL','');
		//PLANT담당자 콤보데이터 셋팅. 로그인한 사용자 부서살마만 나오게 변경.
		var st_user_dept = "<%=st_user_dept%>";
		kepAjaxCommonQueryIdSearchTwoCombo('st_plant_user_id','common.masterDepartmentUserList','',st_user_dept,'ALL','<%=st_smart_dept_yn.equals("Y") ? st_user_id : ""%>');
		//조회조건 초기값 설정
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		$("#st_from_date").val(kepToDateAdd("60","M"));
		$("#st_to_date").val(kepToDateAdd("20","P")); 
		
		//하이퍼링크 설정
		setLinkCol(mySheet, "BTOA_USER_NAME");	//요청자
		setLinkCol(mySheet, "BUYER_ITEM_NO");	//품목코드
		setLinkCol(mySheet, "QUOTATION_NO");	//견적번호
		setLinkCol(mySheet, "REVISION");	//견적번호
		setLinkCol(mySheet, "AGENT_NAME");	//협력사
		setLinkCol(mySheet, "ATOB_REMARK_IMG");
		setLinkCol(mySheet, "ATOS_REMARK_IMG");
		setLinkCol(mySheet, "ATOA_REMARK_IMG");
		setLinkCol(mySheet, "CANCEL_REMARK_IMG");
		setLinkCol(mySheet, "ATOS_END_DATE2");
		setLinkCol(mySheet, "AGENT_CNT");
		setLinkCol(mySheet, "DELAY_REASON_IMG");
		setLinkCol(mySheet, "BUYER_NAME"); //고객사
		setLinkCol(mySheet, "ATOB_REMARK"); // 고객사제출비고
		setLinkCol(mySheet, "NEGO_ITEM_CHG_REQ_DATE"); //네고정비 요청일시
		setLinkCol(mySheet, "NEGO_ITEM_MD_DATE"); //네고정비 제출일시
		setLinkCol(mySheet, "NEGO_ITEM_CHG_REQ_IMAGE_KEY_IMG"); //네고정비 첨부
		setLinkCol(mySheet, "NOTE_MNG_IMG"); //특이사항 입력
		setLinkCol(mySheet, "IMAGE_KEY_IMG"); // 첨부(B)
		setLinkCol(mySheet, "SELLER_IMAGE_KEY_IMG"); // 첨부(ATOS)
		setLinkCol(mySheet, "MSDS_NO"); // MSDS
		
		mySheet.SetCellFontUnderline(0, "ATOS_END_DATE2", true);	
		mySheet.SetCellFontUnderline(0, "CANCEL_REMARK_IMG", true);
		mySheet.SetCellFontUnderline(0, "ATOB_REMARK", true);
		mySheet.SetCellFontUnderline(0, "NEGO_ITEM_CHG_REQ_TYPE", true);
		mySheet.SetCellFontUnderline(0, "NEGO_ITEM_CHG_REQ_NOTE", true);
		
		mySheet.SetColProperty("NEGO_ITEM_CHG_REQ_TYPE", item_chg_req_type);
		
		// 콤보데이터 셋팅
		kepAjaxCommonQueryIdSearchTwoCombo('st_job_transfer_id','common.masterDepartmentUserList','PG_10_M_006_00','','ALL',''); // 조회조건 : 견적 담당자
		
	}
	
	
	var st;
	var mt;
	var gubun = "";
	var pbuyer = "";
	//기능함수
	function doAction(str) {
		gubun = str;
		st = new Date();
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");

		//선택된 항목 유무 체크
		if (str !="search" && str !="downexcel" && str !="reload" && selectedGrid.length == 0) {
			alert("선택된 항목이 없습니다.");
			return;
		}

		switch (str) {
		case "search":	//조회
 			current_page = -1;
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				alert("조회기간을 3개월 단위로 조회가 가능합니다.");
				return;
			}
			//소싱부서가 아닐 경우 고객사코드 필수 값.
			if($("#st_sour_dept_yn").val() == "N"){
				if($("#st_buyer_code").val() == null||$("#st_buyer_code").val() == ""){
					alert("고객사은(는) 필수입력 항목입니다.");
					return;
				}
			}
			
			if(document.getElementById("st_nego_md_except_check").checked == true){
				 $("#st_nego_md_except").val('Y');		
			}else{
				 $("#st_nego_md_except").val('N');					
			}
			
			if(document.getElementById("st_nego_req_check").checked == true){
				 $("#st_nego_req").val('Y');
			}else{
				 $("#st_nego_req").val('N');					
			}
			
			kepSearch(document.searchCondition,  mySheet , "/mprq/searchMasterMpRqReqNegoReceiptList.do" , pagingMode );
			break;
		case "reload":	//초기화
			kepReload('searchCondition');
			$('#st_buyer_code').val("");
			
			//조회조건 초기값 설정
			kepSetCalender("st_from_date");
			kepSetCalender("st_to_date");
			$("#st_from_date").val(kepToDateAdd("60","M"));
			$("#st_to_date").val(kepToDateAdd("20","P"));
			
			document.getElementById("st_nego_md_except_check").checked = true;
			document.getElementById("st_nego_req_check").checked = false;
			
			mySheet.RemoveAll();
			break;
		case "round": // 추가 라운드 요청
			if (selectedGrid.length == 0) {
				alert("추가라운드 요청할 협력사를 선택하여 주십시요.");
				return;
			}else {
				for (var i=0; i<arrRow.length; i++){
					var SG_GBN    = mySheet.GetCellValue(arrRow[i],"SG_GBN");
					var SG_KEP_YN   = mySheet.GetCellValue(arrRow[i],"SG_KEP_YN");
					var KEP_RFQ_ORJ_FLAG    = mySheet.GetCellValue(arrRow[i],"KEP_RFQ_ORJ_FLAG");
					var QUOTATION_NO    = mySheet.GetCellValue(arrRow[i],"QUOTATION_NO");
					var QUOTATION_SEQ    = mySheet.GetCellValue(arrRow[i],"QUOTATION_SEQ");
					
					if(mySheet.GetCellValue(arrRow[i], "NEGO_ITEM_MD_COMPLETE") != "Y"){
						alert("견적번호: "+QUOTATION_NO+" 견적항번: "+QUOTATION_SEQ+"\n네고정비 요청 후 미제출건은 진행할 수 없습니다.");
						return;
					}
					
					if(SG_GBN == "전략소싱팀"){
						if(KEP_RFQ_ORJ_FLAG == "0"){
							alert("견적번호: "+QUOTATION_NO+" 견적항번: "+QUOTATION_SEQ+"\n전략소싱팀 진행건은 사업팀의 추가라운드 요청이 있어야 가능합니다.");
							return;
						}
						if(SG_KEP_YN =="N"){
							alert("견적번호: "+QUOTATION_NO+" 견적항번: "+QUOTATION_SEQ+"\n전략소싱팀 진행건은 전략 소싱팀만 추가라운드 가능합니다.");
							return;							
						}
					}
					var ATOS_END_DATE    = mySheet.GetCellValue(arrRow[i],"ATOS_END_DATE3");
					var ATOS_END_TIME    = mySheet.GetCellValue(arrRow[i],"ATOS_END_TIME3");
					if (IsEmpty(ATOS_END_DATE) || IsEmpty(ATOS_END_TIME)){
						alert("추가라운드 요청 마감시간을 설정하여 주십시요.");
						mySheet.SelectCell(arrRow[i], "ATOS_END_DATE2");  
						return;
					}
				}
				
				if (!confirm('추가 라운드 요청을 하시겠습니까?'))
					return;
				kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqReqNegoReceipt.do" , "SELECTED" );
				
			}
			break;
		case "nego": //네고의뢰
			if (!getNegoList()) return;
			if (!confirm('Nego 제출을 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mprq/negoMasterMpRqQuotationReceiptSendList.do" , "SELECTED" );
			break;
		case "del":		//견적취소
			
			for (var i=0; i<selectedGrid.length; i++){
				var CANCEL_REMARK    = mySheet.GetCellValue(arrRow[i],"CANCEL_REMARK");
				var CANCEL_REMARK_CODE = mySheet.GetCellValue(arrRow[i],"CANCEL_REMARK_CODE");
				if(CANCEL_REMARK == "" && CANCEL_REMARK_CODE == ""){
					alert("견적 취소 사유를 입력하여 주십시요");
					mySheet.SelectCell(arrRow[i], "CANCEL_REMARK_IMG");
					return;
				}
			}
			if (!confirm('견적취소 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mprq/delMasterMpRqReqQuotReceipt.do" , "SELECTED" );
			break;
		case "so_round":		//소싱팀추가라운드
			
			for (var i=0; i<selectedGrid.length; i++){
				var buyerMngYn = mySheet.GetCellValue(arrRow[i], "BUYER_MNG_YN");
				var sgGbn = mySheet.GetCellValue(arrRow[i], "SG_GBN");
				var quotationNo = mySheet.GetCellValue(arrRow[i], "QUOTATION_NO");
				var quotationSeq = mySheet.GetCellValue(arrRow[i], "QUOTATION_SEQ");
				//진행구분이 사업팀인 경우 추가라운드 할 필요가 없음.
				if(sgGbn == "사업팀"){
					alert("견적번호: "+quotationNo+" 견적항번: "+quotationSeq+"\n진행구분이 사업팀이므로 소싱팀 추가라운드 요청을 할 필요가 없습니다.");
					return;
				}
				//사업팀 담당자만 소싱팀 추가라운드 요청 가능함.
				if(buyerMngYn == "N"){
					alert("견적번호: "+quotationNo+" 견적항번: "+quotationSeq+"\n고객사 담당자만 소싱팀 추가라운드 요청 가능합니다.");
					return;				
				}
			}
			if (!confirm('저장 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mprq/updateSoMasterMpRqReqNegoReceipt.do" , "SELECTED" );
			break;
		case "downexcel":
			//소싱부서가 아닐 경우 고객사코드 필수 값.
			if($("#st_sour_dept_yn").val() == "N"){
				if($("#st_buyer_code").val() == null||$("#st_buyer_code").val() == ""){
					alert("고객사은(는) 필수입력 항목입니다.");
					return;
				}
			}
		    // 엑셀다운로드
		    $("#pageflag").val('0');
			var param = {FileName:"고객사Nego의뢰접수.xlsx",Merge:1,SheetDesign:1,DownCols:"BUYER_NAME|BUYER_ITEM_NO|BTOA_END_DT|ATOS_END_DT|QUOTATION_NO|QUOTATION_SEQ|REVISION|BTOA_USER_NAME|DESCRIPTION|SPECIFICATION|ORIGIN_NAME|UNIT_MEASURE|MAKER_NAME|ITEM_QTY|STOA_LIST_PRICE|BTOA_NEGO_PRICE|KEP_USER_NAME|AGENT_NAME|BUYER_TARGET_PRICE|ADMIN_TARGET_PRICE|NEGO_ITEM_CHG_REQ_NM|NEGO_ITEM_CHG_REQ_DATE|NEGO_ITEM_CHG_REQ_NOTE"};
			kepDownExcel(document.searchCondition ,mySheet , "/mprq/excelMasterMpRqReqNegoReceiptList.do", param);
			$("#pageflag").val('1');
			break;
			
		case "nego_item_chg_req":
			gubun = "nego_item_chg";
			for(var i=0; i<arrRow.length;i++){
				var st_cms_reject_yn = mySheet.GetCellValue(arrRow[i],"NEGO_CMS_REJECT_YN");
				var st_item_md_date = mySheet.GetCellValue(arrRow[i],"NEGO_ITEM_MD_DATE");
				if(st_cms_reject_yn == "Y" && st_item_md_date == ""){
					alert("이미 네고정비 요청중인 견적건입니다.["+arrRow[i]+"번째]");
					return;
				}
				
				var st_req_type = mySheet.GetCellValue(arrRow[i],"NEGO_ITEM_CHG_REQ_TYPE");
				if(st_req_type == ""){
					alert("정비구분을 선택하여 주십시요.["+arrRow[i]+"번째]");
					mySheet.SelectCell(arrRow[i], "NEGO_ITEM_CHG_REQ_TYPE", 1, "");
					return;
				}
				
				var st_req_note = mySheet.GetCellValue(arrRow[i],"NEGO_ITEM_CHG_REQ_NOTE");
				if(st_req_note.length == 0){
					alert("요청사유를 입력하여 주십시요.["+arrRow[i]+"번째]");
					mySheet.SelectCell(arrRow[i], "NEGO_ITEM_CHG_REQ_NOTE", 1, "");
					return;
				}
			}
			//Confirm 처리 방식.
			g_confirm_type = "negoItemChgReq"; // Confirm 타입 선언
			$("#confirmMsgDiv").text("네고정비를 요청하시겠습니까?"); //Confirm 문구 입력
			$("#confirmAreaDiv").show(); //Confirm 창 확인.
			break;
			
		case "msds":
			gubun = "msds";
			if (!confirm('선택한 항목을 협력사에 MSDS 요청 하시겠습니까?\n현재 매핑된 MSDS_NO는 해제됩니다.'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqQuotationProceStateList2.do" , "SELECTED" );
			break;
		}
	}
	
	function getNegoList(){
		var bFlag = true;
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		// 선택된 항목 유무 체크
		if (selectedGrid.length == 0) {
			alert("선택된 항목이 없습니다.\n\n품목을 선택하여 주십시요.");
			return false;
		}
		var arrRow     = selectedGrid.split("|");
		var buyer = mySheet.GetCellValue(arrRow[0],"BUYER");
		pbuyer = buyer;
		var unit_price = 0;
		var list_price = 0;
		var margin_val = 0;
		//세션 로그인 ID
		var sessionUserId = document.searchCondition.st_user_id.value;
		for (var i=0; i<arrRow.length; i++){
			// 정비요청의 미제출건은 진행 불가
			if(mySheet.GetCellValue(arrRow[i],"NEGO_ITEM_MD_COMPLETE") != "Y"){
				alert(arrRow[i] + "번째 네고정비 요청 후 미제출건은 진행할 수 없습니다.");
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
			if (buyer !=  mySheet.GetCellValue(arrRow[i],"BUYER")){
				alert("같은 고객사 단위로 견적제출 할수 있습니다.");
				bFlag = false;
				break;
			} 
			
		//SLOGIC-BEGIN(P04-4030-02)
			if(buyer == "KRDOOD0001"){
				if (!getCheckedQuotationNoList()){
					alert("같은 견적번호 단위로 견적제출 할수 있습니다.");
					bFlag = false;
					break;
				}
			}
		//SLOGIC-END
			if(mySheet.GetCellValue(arrRow[i], "APPROVAL_REMARK") !=""){
				mySheet.SetCellValue(arrRow[i], 'PM_FLAG', 'Y');
			}else{
				mySheet.SetCellValue(arrRow[i], 'PM_FLAG', '');
			}
		//SLOGIC-BEGIN(P04-4030-03)
			if(	buyer=="KRKOLO0001" || buyer=="KRKOLO0002" || buyer =="KRKOLO0003" ||buyer == "KRDOOD0001" || buyer =="KRKOLO0099" || buyer =="KRKOLO0107" || buyer =="KRKOLO0106" || buyer =="KRKOLO0108" || buyer =="KRKOLO0111" || buyer =="KRKOLO0110" || buyer =="KRKOLO0109") {
				mySheet.SetCellValue(arrRow[i], 'PM_FLAG', 'Y');
			}
			// 두산인프라코어 9 고객사의 경우 항상 품의(20130531)
			if(	buyer=="KRDAEW0043" || buyer =="KRDAEW0045" || buyer =="KRDOOS0046" || buyer =="KRDIGU0001" || buyer =="KRDHIM0005" || buyer =="KRDHIM0002" || buyer =="KRDHIM0003" || buyer =="KRDHIM0001") {
				mySheet.SetCellValue(arrRow[i], 'PM_FLAG', 'Y');
			}
			
			unit_price = mySheet.GetCellValue(arrRow[i],"ATOB_UNIT_PRICE");
			list_price = mySheet.GetCellValue(arrRow[i],"STOA_LIST_PRICE");
			margin_val = eval(unit_price)-eval(list_price);
			
			if(mySheet.GetCellValue(arrRow[i], "OPM_FLAG")=="PM" || eval(margin_val)<=0 || mySheet.GetCellValue(arrRow[i],"RATE_FLAG")=="Y") {
				mySheet.SetCellValue(arrRow[i], 'PM_FLAG', 'Y');
			}
		//SLOGIC-END
			
			if(kepIsValueNull(mySheet.GetCellValue(arrRow[i],"ATOB_UNIT_PRICE"))){
				alert("제시단가를 입력하여 주십시요");
				mySheet.SelectCell(arrRow[i], "ATOB_UNIT_PRICE");  
				bFlag = false;
				break;
			}
			
			if(!kepChkDecimal(mySheet.GetCellValue(arrRow[i],"ATOB_UNIT_PRICE"),3)){
				alert("제시단가(숫자형식)를 입력하여 주십시요.");
				mySheet.SelectCell(arrRow[i], "ATOB_UNIT_PRICE");
				bFlag = false;
				break;
			}
			
			if(mySheet.GetCellValue(arrRow[i],"UNIT_PRICE_CHECK_FLAG") == "Y"){
				if(mySheet.GetCellValue(arrRow[i],"MIN_UNIT_PRICE") >= mySheet.GetCellValue(arrRow[i],"ATOB_UNIT_PRICE")){
					alert("해당 고객사의 최저단가는 " + mySheet.GetCellValue(arrRow[i],"MIN_UNIT_PRICE") + " 원 이하 제출 불가합니다.");
					mySheet.SelectCell(arrRow[i], "ATOB_UNIT_PRICE");
					bFlag = false;
					break;
				}
				if(mySheet.GetCellValue(arrRow[i],"MAX_UNIT_PRICE") <= mySheet.GetCellValue(arrRow[i],"ATOB_UNIT_PRICE")){
					alert("해당 고객사의 최고단가는 " + mySheet.GetCellValue(arrRow[i],"MAX_UNIT_PRICE") + " 원 이상 제출 불가합니다.");
					mySheet.SelectCell(arrRow[i], "ATOB_UNIT_PRICE");
					bFlag = false;
					break;
				}
			}
			
			// 네고단가 & 고객사제출비고 확인 -- > 20250425 비고제출 필수 고객사 추가 X
			if(mySheet.GetCellValue(arrRow[i], "BTOA_NEGO_PRICE") != "0" && mySheet.GetCellValue(arrRow[i], "ATOB_REMARK") == ""){
				alert("네고 제출건으로 고객사제출비고 입력이 필수입니다.");
				mySheet.SelectCell(arrRow[i], "ATOB_REMARK");
				bFlag = false;
				break;			
			}
			
			if (mySheet.GetCellValue(arrRow[i], "MSDS_YN") == "1" && kepIsValueNull(mySheet.GetCellValue(arrRow[i], "MSDS_NO"))){
				alert(arrRow[i] + "번째는 MSDS 등록 및 매핑이 필요한 견적입니다.\n\nMSDS요청(협력사)로 진행하여 주십시요.");
				mySheet.SelectCell(arrRow[i], "MSDS_NO");
				bFlag = false;
				break;
			}
			
			// 지연사유 입력 필수 체크
			var delay_flag = mySheet.GetCellValue(arrRow[i],"DELAY_FLAG");
			var delay_reason_img = mySheet.GetCellValue(arrRow[i],"DELAY_REASON_IMG");
			
			if(delay_reason_img != "/resources/images/icon.gif" && delay_flag == "Y"){
				alert(arrRow[i] + "번째 견적지연사유를 입력해주세요.");
				bFlag = false;
				break;
			}
		}
		return bFlag;
	}

	function getCheckedQuotationNoList(){
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");
		var bFlag = true;
		var quotation_no = mySheet.GetCellValue(arrRow[0], "QUOTATION_NO");
		for (var i=1; i<arrRow.length; i++){
			if (quotation_no != mySheet.GetCellValue(arrRow[i], "QUOTATION_NO")){
				bFlag = false;
				break;
			}
		}
		return bFlag;
	}
	 
	function mySheet_OnLoadData(DATA) {
		mt = new Date();
		return DATA;
	}
	function mySheet_OnDownFinish(downloadType, result) {
	    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
	}
	function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

    	
    	
		if (msg != "") {
			alert(msg);
		}

		if(current_page==-1){
			makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		}else{
			makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
		}
		
	}
	//트랜젝션(저장,삽입등) 후처리
	function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
		if (code != 1 && msg != ""){
			alert(msg);
			doAction('search');
			return;
		}
		if (gubun == "del"||gubun == "so_round"||gubun=="nego_item_chg"||gubun=="msds") {
			alert(msg);
			
			if(code>0){
				//저장 성공시 재조회
				doAction('search');
			}
			return;
		}
		if (msg.msg != "") {
			alert(msg.msg);
		}
		if(code == 1 && msg.usrmsg != "" && msg.usrmsg != "undefined" && msg.usrmsg != "N"){
			if (gubun == "nego"){
				type = "SO";
			}
			// st_buyer 넣는 부분 
			openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg.usrmsg+'&PARAM1='+pbuyer+"&gubun="+gubun, "1000,500,no");
		}
		
		if(code>0 && gubun != "nego"){
			//저장 성공시 재조회
			doAction('search');
		}
	}

	function kepApprovalReturn(flag,docu_no){
		doAction('search');
	}
	
	//페이지 인덱스 눌렀을 경우 조회
	function pageSearch(param){
		//조회
		current_page = param.page;
		kepSearch(document.searchCondition ,  mySheet , "/mprq/searchMasterMpRqReqNegoReceiptList.do?page="+current_page , pagingMode );
	}
	
	//팝업함수호출
	function doPop(str) {
		popupSel = str;
		
		switch (str) {
			case "negobuyer":
				openSearchPopup("/common/mprq/newSourcingNegoBuyerListPop.do","","500,350,no");
				break;
			case "buyerMulti": // 고객사 M
				openSearchPopup("/none/showCommonNoNeBuyerChoiceMultiPop.do","?search_opt=2&disable_yn=Y",'1000,500,no')
				popupSel = "buyerMulti";
				break;
			case "manual": // 매뉴얼 호출
				openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=0000007zm&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
				break;
			case "negoItemChgSend": // 네고정비제출
				var selectedGrid = mySheet.FindCheckedRow("SELECTED");
				var arrRow     = selectedGrid.split("|");
				// 선택된 항목 유무 체크
				if (selectedGrid.length == 0) {
					alert("선택된 항목이 없습니다.");
					return;
				}
				for(var i=0; i<arrRow.length;i++){
					var st_cms_reject_flag = mySheet.GetCellValue(arrRow[i],"NEGO_CMS_REJECT_YN");
					if(st_cms_reject_flag != "Y"){
						alert("네고정비 요청 먼저 해주시기 바랍니다.["+arrRow[i]+"번째]");
						return;
					}
					
					var st_nego_item_md_flag = mySheet.GetCellValue(arrRow[i],"NEGO_ITEM_MD_DATE");
					if(st_nego_item_md_flag != ""){
						alert("네고정비 제출 된 상태입니다.["+arrRow[i]+"번째]");
						return;
					}
				}
				openSearchPopup("/common/remarkReturn2Pop.do", "?st_gubun=NEGOITEMCHG", "600,230,no");
				break;
		}
	}

	
	//그리드 셀클릭 이벤트
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if ( Row  < 1) return;
		var column = mySheet.ColSaveName(mySheet.GetSelectCol());
		grbRow = Row;		//현재 Row를 전역변수에 셋팅

		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var buyer_name = mySheet.GetCellValue(Row, "BUYER_NAME");
		var quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
		var quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
		var revision = mySheet.GetCellValue(Row, "REVISION");
		var agent_list = mySheet.GetCellValue(Row, "AGENT_LIST");
		if (column == 'BTOA_USER_NAME') { // 요청자
			var ID = mySheet.GetCellValue(Row,"BTOA_USER_ID");
			if (ID!=""){
				openSearchPopup("/common/userDisplayPop.do", '?user_id='+ID, "800,500,no");
			}
 		} else if (column == "BUYER_NAME" ){ //  고객사 
 			//고객사 정보 팝업 호출
			openSearchPopup("/mdct/showMasterMdCtBuyerJoinAlterRequestApprovalPop.do", "?com_code="+buyer,  "900,700,no");
		} else if (column == 'REVISION') { // 단가이력
			popupSel = "masterMpRqQuotationUnitpriceHistoryPop";
			openSearchPopup("/mprq/showMasterMpRqQuotationUnitpriceHistoryPop.do", '?st_buyer='+buyer+'&st_buyer_name='+buyer_name+'&st_quotation_no='+quotation_no+'&st_quotation_seq='+quotation_seq+'&st_revision='+revision, "900,600,no");
			
		} else if (column == 'BUYER_ITEM_NO') { // 품목코드
			popupSel = "masterMpRqSellerChoicePop";
			openSearchPopup("/mprq/showMasterMpRqSellerChoicePop.do","?st_buyer_code="+buyer+"&st_quotation_no="+quotation_no+"&st_quotation_seq="+quotation_seq+"&st_revision="+revision+"&st_agent_list="+agent_list,"900,400,no");
			
		} else if (column == 'AGENT_CNT') { // 접수건수
			popupSel = "agentSel";
			openSearchPopup("/mprq/showMasterMpRqSellerChoicePop.do","?st_buyer_code="+buyer+"&st_quotation_no="+quotation_no+"&st_quotation_seq="+quotation_seq+"&st_revision="+revision+"&st_agent_list="+agent_list+"&st_gubun=nego","900,400,no");
			
 		}else if (column == "QUOTATION_NO" ){ 
			popupSel = "quotationReDetailPop";
			openSearchPopup("/common/remarkStoAPop.do", '?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_revision='+revision, "500,310,no");
		} else if (column == 'AGENT_NAME') { // 협력사
			var agent = mySheet.GetCellValue(Row,"AGENT");
			openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
			
 		}else if (column == "ATOS_END_DATE2" ){ 	// 견적마감일
 			popupSel = "calendarHour";
 			openSearchPopup("/common/calendarAndHourPop.do",'',"300,300,no");
 			
 		}else if (column == "ATOB_REMARK_IMG" ){ 
			popupSel = "remarkBAS";
			var btoa_remark = mySheet.GetCellValue(Row, "BTOA_REMARK");
			var atos_remark = mySheet.GetCellValue(Row, "ATOS_REMARK");
			var stoa_remark = mySheet.GetCellValue(Row, "STOA_REMARK");
			var atob_remark = mySheet.GetCellValue(Row, "ATOB_REMARK");
			openSearchPopup("/common/remarkBASPop.do",'?st_btoa_remark='+btoa_remark+'&st_atos_remark='+atos_remark+'&st_stoa_remark='+stoa_remark+'&st_atob_remark='+atob_remark,"500,600,no");// 고객사 비고

 		}else if (column == "ATOA_REMARK_IMG" ){ 
			popupSel = "remarkAtoAPop";
			var st_buyer = mySheet.GetCellValue(Row, "BUYER");
			var st_quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
			var st_quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
			var st_revision = mySheet.GetCellValue(Row, "REVISION");
			var st_atoa_remark = mySheet.GetCellValue(Row, "ATOA_REMARK");
			
			openSearchPopup("/common/remarkAtoAPop.do",'?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_atoa_remark='+st_atoa_remark,"500,200,no");// 운영사비고
			
 		}else if (column == "ATOS_REMARK_IMG" ){ 
			popupSel = "remarkAtoS2";
			var viewType="R";
			var atos_remark = mySheet.GetCellValue(Row, "ATOS_REMARK2"); // 작성비고
			var atos_remark2 = mySheet.GetCellValue(Row, "ATOS_REMARK"); // 기존비고
			var reject_remark = mySheet.GetCellValue(Row, "REJECT_REMARK");
			openSearchPopup("/common/remarkAtoS2Pop.do",'?st_atos_remark='+atos_remark+'&st_atos_remark2='+atos_remark2+'&st_reject_remark='+reject_remark+'&viewType='+viewType,"500,270,no");// 협력사 비고
			
		} else if(column == "CANCEL_REMARK_IMG"){
			popupSel = "cancelRemark";
			var viewType="kepRfqCancel";
			var cancel_remark = mySheet.GetCellValue(Row, "CANCEL_REMARK");
			var cancel_remark_code = mySheet.GetCellValue(Row, "CANCEL_REMARK_CODE");
			openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType+'&cancel_remark_code='+cancel_remark_code,"500,320,no");
		} else if(column == "KEP_RFQ_FLAG"){
			var buyerMngYn = mySheet.GetCellValue(Row, "BUYER_MNG_YN");
			var sgGbn = mySheet.GetCellValue(Row, "SG_GBN");
			var orjFlag = mySheet.GetCellValue(Row, "KEP_RFQ_ORJ_FLAG");
			//진행구분이 사업팀인 경우 추가라운드 할 필요가 없음.
			if(sgGbn == "사업팀"){
				alert("진행구분이 사업팀이므로 소싱팀 추가라운드 요청을 할 필요가 없습니다.");
				mySheet.SetCellValue(Row, "KEP_RFQ_FLAG", orjFlag);
				return;
			}
			//사업팀 담당자만 소싱팀 추가라운드 요청 가능함.
			if(buyerMngYn == "N"){
				alert("고객사 담당자만 소싱팀 추가라운드 요청 가능합니다.");
				mySheet.SetCellValue(Row, "KEP_RFQ_FLAG", orjFlag);
				return;				
			}
			var kepRfqFlag = mySheet.GetCellValue(Row, "KEP_RFQ_FLAG");
			mySheet.SetCellValue(Row, "SELECTED", kepRfqFlag);
 		} else 	if (column == "DELAY_REASON_IMG" ){
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

 		} else if (column == "ATOB_REMARK" ){ 
 			popupSel = "remarkAtoBPop";
 			var st_form_name = "remarkAtoBPopForm";
 			var st_popup_url = "/mprq/remarkAtoB2Pop.do";
 			var st_popup_param = "st_buyer@@"+mySheet.GetCellValue(Row, "BUYER")+"^||^"+"st_quotation_no@@"+mySheet.GetCellValue(Row, "QUOTATION_NO")+"^||^"+"st_quotation_seq@@"+mySheet.GetCellValue(Row, "QUOTATION_SEQ")+"^||^"+"st_revision@@"+mySheet.GetCellValue(Row, "REVISION")+"^||^"+"st_atob_remark@@"+mySheet.GetCellValue(Row, "ATOB_REMARK");
 			var st_popup_option = "500,450,no";
 			//post 팝업 호출
 			openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
 		} else if (column == "NEGO_ITEM_CHG_REQ_DATE" ){ //  네고정비 이력팝업
 			popupSel = "negoItemChgRegDatePop";
 			var st_buyer = mySheet.GetCellValue(Row,"BUYER");
 			var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
 			var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
 			var st_revision = mySheet.GetCellValue(Row,"REVISION");
 			openSearchPopup("/mprq/showMasterMpRqNegoItemMdReqHistPop.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "840,300,no");
 		}  else if (column == "NEGO_ITEM_MD_DATE" ){ //  네고정비 이력팝업
 			popupSel = "negoItemChgRegDatePop";
 			var st_buyer = mySheet.GetCellValue(Row,"BUYER");
 			var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
 			var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
 			var st_revision = mySheet.GetCellValue(Row,"REVISION");
 			openSearchPopup("/mprq/showMasterMpRqNegoItemMdReqHistPop.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "840,300,no");
 		} else if(column == "NEGO_ITEM_CHG_REQ_IMAGE_KEY_IMG"){
 			popupSel = "negoItemChgReqfileUpload";
 			var type="RFQ";
 			var viewType="VI";
 			var image_key=mySheet.GetCellValue(Row, "NEGO_ITEM_CHG_REQ_IMAGE_KEY");
 			var st_nego_cms_reject_yn = mySheet.GetCellValue(Row,"NEGO_CMS_REJECT_YN");
 			var st_req_user_id = mySheet.GetCellValue(Row,"NEGO_ITEM_CHG_REQ_ID");
 			var st_nego_item_md_date = mySheet.GetCellValue(Row,"NEGO_ITEM_MD_DATE");
 			var sessionUserId = document.searchCondition.st_user_id.value;
 			
 			// 정비요청 이력 있고, 정비제출일시 비었고 --> 정비요청 중
 			if(st_nego_cms_reject_yn == "Y" && st_nego_item_md_date == ""){
				viewType = "R";
 			}
 			
 			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
 		} else if(column == "NOTE_MNG_IMG" ){ //특이사항 입력
 			var st_buyer = mySheet.GetCellValue(Row,"BUYER");
 			var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
 			var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
 			var st_revision = mySheet.GetCellValue(Row,"REVISION");
 			openSearchPopup("/mprq/showMasterMpRqQutationRemark.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "850,350,no");
 		} else if(column == "IMAGE_KEY_IMG"){
			popupSel = "fileUpload";
			var type="RFQ";
			var viewType="VI";
			var image_key=mySheet.GetCellValue(Row, "IMAGE_KEY");
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
 		} else if(column == "SELLER_IMAGE_KEY_IMG"){
			popupSel = "sellerFileUpload";
			var type="RFQ";
			var viewType="VI";
			var image_key=mySheet.GetCellValue(Row, "SELLER_IMAGE_KEY");
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
 		} else if (column == "MSDS_NO" ){ // MSDS
 			popupSel = "msdsregmapPop"; 
 			
 			var msds_no = mySheet.GetCellValue(Row, "MSDS_NO");

			if(kepIsValueNull(msds_no)){
			} else {
			    openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+msds_no+"&st_btn_yn=Y",'750,580,no');
		    }
		}
		return;
	}
	
	// 헤더 더블클릭시 복사
	function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {
		if ( Row > 0 ) return;
		
		if (mySheet.ColSaveName(Col) == "ATOS_END_DATE2" || mySheet.ColSaveName(Col) == "CANCEL_REMARK_IMG" || mySheet.ColSaveName(Col) == "ATOB_REMARK" || mySheet.ColSaveName(Col) == "NEGO_ITEM_CHG_REQ_TYPE" || mySheet.ColSaveName(Col) == "NEGO_ITEM_CHG_REQ_NOTE"){
			var checkRows = mySheet.FindCheckedRow("SELECTED");
			if (checkRows.length == 0){
				alert("복사할 행을 선택하여 주십시요.");
				return;
			}
			
			var arrRow = checkRows.split("|");

			if (mySheet.ColSaveName(Col) == "ATOS_END_DATE2"){ // 견적마감일
				var value1 = mySheet.GetCellValue(arrRow[0], "ATOS_END_DATE2");
				var value2 = mySheet.GetCellValue(arrRow[0], "ATOS_END_DATE3");
				var value3 = mySheet.GetCellValue(arrRow[0], "ATOS_END_TIME2");
				var value4 = mySheet.GetCellValue(arrRow[0], "ATOS_END_TIME3");
			
				if(kepIsValueNull(value1)){
					alert("복사할 견적마감일을 선택하여 주십시요.");
					return;
				}
			
				for(var idx=0; idx<arrRow.length; idx++){
					mySheet.SetCellValue(arrRow[idx], "ATOS_END_DATE2", value1);
					mySheet.SetCellValue(arrRow[idx], "ATOS_END_DATE3", value2);
					mySheet.SetCellValue(arrRow[idx], "ATOS_END_TIME2", value3);
					mySheet.SetCellValue(arrRow[idx], "ATOS_END_TIME3", value4);
				}
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
			} else if (mySheet.ColSaveName(Col) == "ATOB_REMARK"){ // 고객사제출비고
				var value1 = mySheet.GetCellValue(arrRow[0], "ATOB_REMARK");
				if(kepIsValueNull(value1)){
					alert("복사할 고객사제출비고를 입력하여 주십시요.");
					return;
				}
				for(var idx=0; idx<arrRow.length; idx++){
					mySheet.SetCellValue(arrRow[idx], "ATOB_REMARK", value1);
					mySheet.SetCellValue(arrRow[idx], "ATOB_REMARK_IMG", (value1!="")? remarkOn : remarkOff);
				}
				alert("현재 복사된 고객사제출비고는 저장되지 않았으니 고객사NEGO 견적제출 전 확인하시기 바랍니다.");
			} else if (mySheet.ColSaveName(Col) == "NEGO_ITEM_CHG_REQ_TYPE"){ // 정비구분
				var value1 = mySheet.GetCellValue(arrRow[0], "NEGO_ITEM_CHG_REQ_TYPE");
				for(var idx=0; idx<arrRow.length; idx++){
					mySheet.SetCellValue(arrRow[idx], "NEGO_ITEM_CHG_REQ_TYPE", value1);
				}
			} else if (mySheet.ColSaveName(Col) == "NEGO_ITEM_CHG_REQ_NOTE"){ // 네고정비요청사유
				var value1 = mySheet.GetCellValue(arrRow[0], "NEGO_ITEM_CHG_REQ_NOTE");
				if(kepIsValueNull(value1)){
					alert("복사할 요청사유를 입력하여 주십시요.");
					return;
				}
				for(var idx=0; idx<arrRow.length; idx++){
					mySheet.SetCellValue(arrRow[idx], "NEGO_ITEM_CHG_REQ_NOTE", value1);
				}
			}
		} else {
			return;
		}
	}
	
	// 그리드 셀 변경시 이벤트
	function mySheet_OnChange(Row, Col, Value) {
		var column = mySheet.ColSaveName(Col);
		grbRow = Row; //현재 Row를 전역변수에 셋팅
		
		if (column == "ATOB_UNIT_PRICE") {
			var st_list_price =mySheet.GetCellValue(Row,"STOA_LIST_PRICE");
			var st_atob_price =mySheet.GetCellValue(Row,"ATOB_UNIT_PRICE");
			var st_qtt_rate =mySheet.GetCellValue(Row,"CMPY_QTT_RATE");
			var st_atob_Rate = ((st_atob_price-st_list_price)/st_list_price)*100;
			
			var st_nego_margin_Rate = kepGetRound((((st_atob_price-st_list_price)/st_atob_price)*100), 2);
			mySheet.SetCellValue(Row, "NEGO_MARGIN_RATE", st_nego_margin_Rate);
			
			if(st_qtt_rate != "EXCCMPY"){
				if(st_atob_Rate > st_qtt_rate){//품의 불필요
					mySheet.SetCellValue(Row, "APPROVAL_REMARK", "");
				}else{//품의 필요
					mySheet.SetCellValue(Row, "APPROVAL_REMARK", "고객사 견적제출(사업팀장 결재필요)");	
				}				
			}

		}
	}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "negobuyer") {	// 고객사
		if (value2 != "-1") {
			$("#st_buyer_code").val(value1);
			$("#st_buyer_name").val(value2);
		}
	} else if (popupSel == "buyerMulti") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	}else if(popupSel == "remarkBAS") {	//고객사 비고
			mySheet.SetCellValue(grbRow, 'ATOB_REMARK', value1);
			mySheet.SetCellValue(grbRow, 'ATOB_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
	}else if(popupSel == "remarkAtoS2") {	//고객사 비고
			mySheet.SetCellValue(grbRow, 'ATOS_REMARK2', value1);
			mySheet.SetCellValue(grbRow, 'ATOS_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
	}else if(popupSel == "remarkAtoAPop") {	//운영사 비고
			mySheet.SetCellValue(grbRow, 'ATOA_REMARK', value1);
			mySheet.SetCellValue(grbRow, 'ATOA_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
	}else if(popupSel == "cancelRemark") {	//견적 취소
			mySheet.SetCellValue(grbRow, 'CANCEL_REMARK', value1);
			mySheet.SetCellValue(grbRow, 'CANCEL_REMARK_IMG', (value2!="")? remarkOn : remarkOff);
			mySheet.SetCellValue(grbRow, 'CANCEL_REMARK_CODE', value2);
	} else if(popupSel == "calendarHour") {	//견적마감일
			mySheet.SetCellValue(grbRow, 'ATOS_END_DATE2', value1.substr(0,4) + "/" + value1.substr(4,2) + "/" + value1.substr(6,2));
			mySheet.SetCellValue(grbRow, 'ATOS_END_DATE3', value1);
			mySheet.SetCellValue(grbRow, 'ATOS_END_TIME3', value2);
			mySheet.SetCellValue(grbRow, 'ATOS_END_TIME2', value2.substr(0,2) + ":" + value2.substr(2,2) + ":" + value2.substr(4,2));
	} else if(popupSel == "agentSel") {	//품목코드, 추가라운드협력사
		mySheet.SetCellValue(grbRow, 'AGENT_LIST', value1);
			mySheet.SetCellValue(grbRow, 'AGENT_CNT', value2);
	} else if(popupSel == "remarkAtoBPop") {	// 고객사 제출비고
		mySheet.SetCellValue(grbRow, 'ATOB_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'ATOB_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
	} else if(popupSel == "negoItemChgReqfileUpload") {	//네고정비 첨부
		mySheet.SetCellValue(grbRow, 'NEGO_ITEM_CHG_REQ_IMAGE_KEY', value1);
		mySheet.SetCellValue(grbRow, 'NEGO_ITEM_CHG_REQ_IMAGE_KEY_IMG', (value2=='on')? diskOn : diskOff);
	} else if(popupSel == "fileUpload") {	//파일 첨부
			mySheet.SetCellValue(grbRow, 'IMAGE_KEY', value1);
			mySheet.SetCellValue(grbRow, 'IMAGE_KEY_IMG', (value2=='on')? diskOn : diskOff);
	} else if(popupSel == "sellerFileUpload") {	//파일 첨부(ATOS)
			mySheet.SetCellValue(grbRow, 'SELLER_IMAGE_KEY', value1);
			mySheet.SetCellValue(grbRow, 'SELLER_IMAGE_KEY_IMG', (value2=='on')? diskOn : diskOff);
	}
	grbRow="";	//초기화
}

//Confirm창 확인처리
function confirmAreaDivSearch(){
	$("#confirmAreaDiv").hide();	
	if(g_confirm_type == "negoItemChgReq"){ //네고정비 요청
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow = selectedGrid.split("|");
		for(var i = 0; i<arrRow.length;i++){
			var st_req_note = mySheet.GetCellValue(arrRow[i],"NEGO_ITEM_CHG_REQ_NOTE");
			var st_req_id = $("#st_user_id").val();
			var st_req_image_key = mySheet.GetCellValue(arrRow[i],"NEGO_ITEM_CHG_REQ_IMAGE_KEY");
			mySheet.SetCellValue(arrRow[i], 'NEGO_CMS_REJECT_YN', "Y"); //네고정비 Y로 
			mySheet.SetCellValue(arrRow[i], 'NEGO_ITEM_CHG_REQ_ID', st_req_id);
			mySheet.SetCellValue(arrRow[i], 'NEGO_ITEM_CHG_REQ_NOTE', st_req_note);				
			mySheet.SetCellValue(arrRow[i], 'NEGO_ITEM_CHG_REQ_IMAGE_KEY', st_req_image_key);
		}
		kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqNegoItemChgReq.do" , "SELECTED" );
	}
}

//추가정비제출 저장
function setNegoItemChgPopupReturn(val){
	gubun = "nego_item_chg";

	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	var st_admin_remark = "[네고정비제출] "+val;
	
	for (var i=0; i<arrRow.length; i++){
		mySheet.SetCellValue(arrRow[i],"ADMIN_REMARK",st_admin_remark);
	}

	kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqNegoItmCheSend.do" , "SELECTED" );
}

//견적지연사유 팝업 리턴
function setDelayPopupReturn(){
	mySheet.SetCellValue(grbRow, 'DELAY_REASON_IMG', 9);
}

</script>
</head>
<body onload="initPage()">
<!--내용 시작-->
			<!--버튼영역-->
	       	<div id="searchBtnA"  >
	       		<h3>고객사 Nego의뢰 접수</h3>
				<span class="btn_search"><a href="javaScript:doAction('search');">조회</a></span>
				<span class="btn_reset"><a href="javaScript:doAction('reload');">초기화</a></span>
				<span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
	   		</div>       		          	
            <!--조회영역-->
        	<form name = "searchCondition" method = "post" onsubmit="return false" >
            <div id="cont_searchA">
 			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<input type="hidden" id="USER_ID" name="USER_ID" value="${sessionInfo.userId}">
			<input type="hidden" id="USR_ID" name="USR_ID" value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_id" name="st_user_id" value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_dept" name="st_user_dept" value="${sessionInfo.department}">
			<input type="hidden" id="st_date_type" name="st_date_type" value="REQ">
			<input type="hidden" id="st_sour_dept_yn" name="st_sour_dept_yn"  value ="<%=st_sour_dept_yn%>">
			<input type="hidden" id="st_nego_md_except" name="st_nego_md_except" value ="">
			<input type="hidden" id="st_nego_req" name="st_nego_req" value ="">
			<input type="hidden" id="st_mro_dept_yn" name="st_mro_dept_yn"  value ="<%=st_mro_dept_yn%>">
			
            	<table  class="cont_t_list01" >
						<caption>고객사 Nego의뢰 접수</caption>
						<colgroup>
							<col width="8%"/>
							<col width="17%"/>
							<col width="8%"/>
							<col width="17%"/>
							<col width="8%"/>
	                        <col width="17%"/>
	                        <col width="8%"/>
	                        <col width="17%"/>
						</colgroup>
						
						<tbody>
							<tr>
								<th>견적의뢰일</th>
								<td colspan="3">
									<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:80px; text-align:center;" value="">
										<a href="javascript:kepCalendar('st_from_date')"></a>
									-
									<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:80px; text-align:center;" value="">
										<a href="javascript:kepCalendar('st_to_date')"></a>
										&nbsp;&nbsp;
									<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
									<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
									<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
								</td>
								<th><font color="#FF6600">*</font>고객사</th>
								<td>
									<input type="hidden" id="st_buyer_code" name="st_buyer_code" value="" >
									<input type="text" id="st_buyer_name"  name="st_buyer_name" style="width:55%;" value="" readonly onclick="doPop('buyerMulti');" ondblclick="cl">
									<a href="javascript:doPop('negobuyer');"><img src="/resources/images/btn_search03.gif"></a>
									<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
								</td>
								<th></th>
								<td></td>
							</tr>
							<tr>
								<th>견적번호</th>
								<td>
									<input type="text" id="st_quotation_no" name="st_quotation_no" style="width:87%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
								</td>
								<th>품목코드</th>
								<td>
									<input type="text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:87%;" value="" onkeydown="kepEnter()">
								</td>
								<th>품목명</th>
								<td>
									<input type="text" id="st_description" name="st_description" style="width:87%;" value="" onkeydown="kepEnter()">
								</td>
								<th>규격</th>
								<td>
									<input type="text" id="st_specification" name="st_specification" style="width:87%;" value="" onkeydown="kepEnter()">
								</td>
							</tr>
							<tr>
								<th>담당자</th>
								<td>
									<select id="st_kep_user_id" name="st_kep_user_id" style="width:90%;height:20px" ></select>
								</td>
								<td>전략SG담당자</td>
								<td>
									<select id="st_sg_user_id" name="st_sg_user_id" style="width:90%;height:20px"></select>
								</td>
								<th>PLANT 담당자</th>
								<td>
									<select id="st_plant_user_id" name="st_plant_user_id" style="width:90%;height:20px"></select>
								</td> 
								<th>견적담당자</th>
								<td>
									<select id="st_job_transfer_id" name="st_job_transfer_id" style="width:90%;height:20px"></select>
								</td>
							</tr>
							<tr>
								<td>네고정비 여부</td>
								<td colspan="7">
						  			<select name = "st_nego_cms_reject_yn" id="st_nego_cms_reject_yn" style="width:8%;height:20px;">
						  				<option value = "" selected>전체</option>
						  				<option value = "Y" >Y</option>
						  				<option value = "N">N</option>
		                           </select>
		                           <input type="checkbox"  class="Noborder" name="st_nego_md_except_check" id="st_nego_md_except_check" checked>&nbsp;네고정비 미제출 제외&nbsp;
		                           <input type="checkbox"  class="Noborder" name="st_nego_req_check" id="st_nego_req_check">&nbsp;네고정비 요청건만 조회&nbsp;
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
					</select></span>
			<br>		
		</form>
					
       	<!--grid-->
		<div style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
		
		<!--버튼영역-->
            <p class="btnArea">
	          	<span class="fl" style="display:none">
					<span class="btn_04"><a href="javascript:doAction('downexcel');">엑셀다운로드</a></span>
				</span>
				
				<span class="fr">
					<span class="btn_06 mr04"><a href="javascript:doAction('nego_item_chg_req');">네고정비요청</a></span>
					<span class="btn_06 mr04"><a href="javascript:doPop('negoItemChgSend');">네고정비제출</a></span>
					<span class="btn_05 mr04"><a href="javascript:doAction('round');">추가라운드요청</a></span>
					<span class="btn_06 mr04"><a href="javascript:doAction('msds');">MSDS요청(협력사)</a></span>
					<span class="btn_08 mr04"><a href="javascript:doAction('nego');">고객사NEGO 견적제출</a></span>
				
				<%  //구매팀 견적취소 삭제 - 조직개편 2025.08.18
					if(st_sour_dept_yn.equals("N")){
				%>
					<span class="btn_02"><a href="javascript:doAction('del');">견적취소</a></span>
				<%
					}
				%>
				</span>
		 </p>
<!--내용 종료-->	                 
</body>
</html>
