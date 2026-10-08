<%--
**********************************************
* 메뉴 : 운영사 > 견적관리
* 화면 : 견적의뢰 접수
* 기능 : 고객으로부터 견적의뢰받은 품목에 대해 표준카테고리와 필수속성을 입력하는 표준화작업을 수행한다
			견적마감일과 협력사를 선정하여 협력사에게 견적요청을 한다
* 프로그램 ID : PG_04_M_005_00
* 담당자 : 김영미 ( 설계 : 권우재 )
* 생성일 : 2014-05-15
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
	String searchYn		= CommonUtil.nvl((String)request.getParameter("search_yn"));
	String buyerCode	= CommonUtil.nvl((String)request.getParameter("st_buyer_code"));
	String buyerName	= CommonUtil.nvl((String)request.getParameter("st_buyer_name"));
	String st_sg_dept	= CommonUtil.nvl((String)request.getParameter("st_sg_dept"));
	String st_user_id = _sessionInfo.getUserId();
	String st_user_dept = _sessionInfo.getDepartment();
	String st_authority = "N";
	if(st_user_dept.equals("093"))
		st_authority = "Y";
	
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
	
	// MRO사업팀 확인
	String st_mro_dept_yn = "";
	boolean st_mro_dept = CommonUtil.getCodeCheckReturn("MRODEPT",st_user_dept);
	if(st_mro_dept == true){
		st_mro_dept_yn = "Y";
	}else{
		st_mro_dept_yn = "N";
	}
		
	// SMART팀 확인( 견적이관 버튼 제어, 견적이관 시 SMS 발송 X(DAO 참고) )
	String st_smart_dept_yn = "";
	boolean st_smart_dept = CommonUtil.getCodeCheckReturn("SMRTDEPT",st_user_dept);
	if(st_smart_dept == true){
		st_smart_dept_yn = "Y";
	}else{
		st_smart_dept_yn = "N";
	}
	
	// RPA 아이디 체크
	String st_rpa_yn = "";
	boolean st_rpa_login_check = CommonUtil.getCodeCheckReturn("KEPRPA", st_user_id);
	if(st_rpa_login_check == true){
		st_rpa_yn = "Y";
	}else{
		st_rpa_yn = "N";
	}
	
	// SG지정건 조회 대상자 부서기준
	String st_sg_req_dept_yn = "";
	boolean st_sg_req_dept = CommonUtil.getCodeCheckReturn("SGRQDEPT",st_user_dept);
	if(st_sg_req_dept == true){
		st_sg_req_dept_yn = "Y";
	}else{
		st_sg_req_dept_yn = "N";
	}
	
	
	// SMART팀 견적이관 대상 SG목록, 견적이관대상자ID, 견적이관대상자명
	String p04402905_col01 = CommonUtil.getSpecialCheckReturn("KRKORE0001","P04-4029-05","COL01_DATA");
	String p04402905_col02 = CommonUtil.getSpecialCheckReturn("KRKORE0001","P04-4029-05","COL02_DATA");
	String p04402905_col03 = CommonUtil.getSpecialCheckReturn("KRKORE0001","P04-4029-05","COL03_DATA");
%>
<script>
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
	var grbRow;
	var popupSel = "";
	var remarkOn="/resources/images/but_icon01.gif";
	var remarkOff="/resources/images/but_icon02.gif";
	var diskOn = "/resources/images/disk_on.gif";
	var diskOff = "/resources/images/disk_off.gif";
	var itemGubun = "/resources/images/rd_pin.gif";
	var initHistory = "/resources/images/icon_19.png";
	var dbClean = "/resources/images/but_DBClean_info_input.gif";
	var calendar = "/resources/images/btn_calendar.gif";
	var iconR="/resources/images/icon_r.gif";
	var iconG="/resources/images/icon_g.gif";
	var iconOn = "/resources/images/icon2.gif";
	var reasonOn = "/resources/images/icon.gif";
	var reasonOff = "/resources/images/icon2.gif";
	var eraser = "/resources/images/btn_eraser2.gif";
	
	var productGbn = KepSheetComboData("M132","SEL");
    var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};
	
    var cb_item_chg_req_type = KepSheetComboData("DM04","SEL");
    var item_chg_req_type = {ComboCode: cb_item_chg_req_type.ComboCode, ComboText: cb_item_chg_req_type.ComboText};
    
	//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function kep_onload_view() {
	    
		var initsheet = {};
		initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 2};
		initsheet.HeaderMode = {			ColMove : 1,			ColResize : 1		};
		initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus",	Sort:0}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED",	Sort:0}
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER",	Sort:0}
					,{ Align:"Center",	Width:20,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"",	SaveName:"CMS_REJECT_GUBUN",	Sort:0}
					,{ Align:"Center",	Width:140,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적번호",	SaveName:"QUOTATION_NO",	Sort:0}
					,{ Align:"Center",	Width:20,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"",	SaveName:"INIT_YN",	Sort:0}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"순번",	SaveName:"QUOTATION_SEQ",	Sort:0}
					,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"차수(B)",	SaveName:"REVISION",	Sort:0}
					,{ Align:"Center",	Width:20,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"품목코드",	SaveName:"ITEM_GUBUN",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO" , BackColor:"${optColor}",	Sort:0}
					,{ Align:"Center",	Width:30,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"",	SaveName:"ITEM_GUBUN_IMG",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"표준카테고리",	SaveName:"CMS_CATEG_ID",	Sort:0}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",  Header:"표준카테고리",	SaveName:"CATEG_PATH", BackColor:"${notnullColor}", KeyField:true,	Sort:0}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SG_ID",	SaveName:"SG_ID",	Sort:0}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"SG",	SaveName:"SG_NAME", BackColor:"${notnullColor}", KeyField:true,	Sort:1}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"DB클랜징정보입력", SaveName:"DB_CLEAN", BackColor:"${notnullColor}", KeyField:true,	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준카탈로그코드",	SaveName:"CMS_CATLG_ID", BackColor:"${notnullColor}",	Sort:0}
					,{ Align:"Center",	Width:30,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"표준카탈로그코드",	SaveName:"CMS_CATLG_IMG",	Sort:0}
					,{ Align:"Left",	Width:28,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"표준카탈로그코드",	SaveName:"ERASE_CMS_CATLG_ID",	Sort:0}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사\n등록여부",	SaveName:"RPA_REG_YN", Sort:0}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"실적가격",	SaveName:"RPA_HIST_PRICE", Sort:0}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:4000,	Hidden:false,	Type:"Text",	Header:"운영사비고",	SaveName:"ATOA_REMARK",	Sort:0}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"운영\n특이사항",	SaveName:"NOTE_MNG_IMG",ColMerge:0,Sort:0}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", 	ToolTip:1,	Header:"품목명",	SaveName:"DESCRIPTION",	Sort:0}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",   	Header:"품목명(영문)",	SaveName:"DESCRIPTION_ENG",	Sort:0}
					,{ Align:"Left",	Width:200,	Edit:false,	EditLen:2000,	Hidden:false,	Type:"Text",   ToolTip:1,	Header:"규격",	SaveName:"SPECIFICATION",	Sort:0}
					,{ Align:"Left",	Width:200,	Edit:false,	EditLen:2000,	Hidden:true,	Type:"Text",   	Header:"규격(고)",	SaveName:"KEP_SPECIFICATION",	Sort:0}
					,{ Align:"Left",	Width:200,	Edit:false,	EditLen:2000,	Hidden:true,	Type:"Text",   	Header:"규격(영문)",	SaveName:"SPECIFICATION_ENG",	Sort:0}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제조사코드",	SaveName:"MAKER_CODE",	Sort:0}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME",	Sort:0}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"원산지코드",	SaveName:"ORIGIN_CODE",	Sort:0}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NAME",	Sort:0}
					,{ Align:"Right",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type : "Float",	Format:"${qtyFormat}", Header:"수량",	SaveName:"ITEM_QTY" ,	BackColor:"${notnullColor}",	Sort:0}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE",	Sort:0}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"모델번호",	SaveName:"MAKER_PART_NO", Sort:0}
					,{ Align:"Right",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"시장가격",	SaveName:"RPA_MARKET_PRICE", Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"RPA_BUYER",	SaveName:"RPA_BUYER", Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"RPA_ITEM_NO",	SaveName:"RPA_ITEM_NO", Sort:0}
					,{ Align:"'Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"관리번호",	SaveName:"REF_NO",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Combo",	Header:"품목구분",	SaveName:"ITEM_MAKE_TYPE" ,	BackColor:"${notnullColor}", KeyField:true,	Sort:0}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",	 Format:"${priceFormat}", 	Header:"요청단가",	SaveName:"BUYER_TARGET_PRICE",	Sort:0}
					,{ Align:"Right",	Width:90,	Edit:true,	EditLen:100,	Hidden:false,	Type : "Float",	 Format:"${priceFormat}", 	Header:"목표단가",	SaveName:"ADMIN_TARGET_PRICE",	 BackColor:"${optColor}",	Sort:0}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"견적의뢰일",	SaveName:"BTOA_DATE",	BackColor:"${optColor}",	Sort:0}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"회신요청일",	SaveName:"BTOA_END_DATE", BackColor:"${optColor}",	Sort:0}
					,{ Align:"Center",	Width:90,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"회신요청일시",	SaveName:"BTOA_END_TIME", BackColor:"${optColor}",	Sort:0}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"진행구분",	SaveName:"SG_GBN",	Sort:1}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SG담당자YN",	SaveName:"SG_KEP_YN",	Sort:0}
					,{ Align:"Center",	Width:90,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적마감일",	SaveName:"ATOS_END_DATE2", BackColor:"${notnullColor}", KeyField:true,	Sort:0}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"견적마감일",	SaveName:"ATOS_END_DATE",	Sort:0}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적마감일시",	SaveName:"ATOS_END_TIME2",	Sort:0}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"견적마감일시",	SaveName:"ATOS_END_TIME",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자ID",	SaveName:"BTOA_USER_ID",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",	SaveName:"BTOA_USER_NAME", Sort:1}
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자전화번호",	SaveName:"BTOA_USER_TEL", Sort:1}
					,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"공개",	SaveName:"AGENT_OPEN_FLAG", BackColor:"${optColor}",	Sort:0}
					,{ Align:"Left",	Width:200,	Edit:false,	Hidden:false,	EditLen:4000,	Type:"Text",	Header:"고객사비고",	SaveName:"BTOA_REMARK",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	EditLen:4000,	Type:"Text",	Header:"운영사비고",	SaveName:"ATOS_REMARK",	Sort:0}
	    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고",	SaveName:"BTOA_REMARK_IMG", BackColor:"${optColor}",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"협력사ID",	SaveName:"PICKUP_AGENT_ID",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"협력사지정",	SaveName:"PICKUP_AGENT_ID2",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"협력사지정",	SaveName:"PICKUP_AGENT_DSS",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"협력사지정",	SaveName:"PICKUP_AGENT_DSS2",	Sort:0}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적담당자",	SaveName:"JOB_TRANSFER_NM",	Sort:0}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적이관일시",	SaveName:"JOB_TRANSFER_DATE",	Sort:0}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"견적담당자ID",	SaveName:"JOB_TRANSFER_ID",	Sort:0}
					,{ Align:"Center",	Width:80,	Edit:false, EditLen:110,	SaveName : "DELY_AREA_IMG",	Header : "고객사\n납품가능지역",	Type : "Image"	}
					,{ Align:"Left",	Width:120,	Edit:false,	Hidden:true,	Type:"Text",	Header:"고객사납품가능지역",	SaveName:"DELY_AREA",	Sort:0}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사지정",	SaveName:"PICKUP_AGENT_NAME",	Sort:0}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"기존협력사",	SaveName:"AGENT_NAME",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"지정협력사",	SaveName:"ASSIGN_AGENT_CODE",	Sort:0}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"지정협력사(B)",	SaveName:"BUYER_ASSIGN_AGENT_CODE",	Sort:0}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"지정협력사",	SaveName:"ASSIGN_AGENT_NAME",	Sort:0}
					,{ Align:"Left",	Width:28,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"지정협력사",	SaveName:"ERASE_ASSIGN_AGENT",	Sort:0}
	    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"첨부\n(B)",	SaveName:"IMAGE_KEY_IMG",	Sort:0}
	    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"첨부\n(B)",	SaveName:"IMAGE_KEY",	Sort:0}
	    			,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",ComboText:"Y|N",ComboCode:"Y|N",	Header:"이미지필수(S)",	SaveName:"RFQ_IMG_FLAG",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"첨부(B)\n협력사전달",	SaveName:"IMAGE_PASS_FLAG", BackColor:"${optColor}",	Sort:0}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"첨부\n(ATOS)",	SaveName:"SELLER_IMAGE_KEY_IMG",	Sort:0}
	    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"첨부\n(ATOS)",	SaveName:"SELLER_IMAGE_KEY",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:4000,	Hidden:true,	Type:"Text",	Header:"견적취소사유",	SaveName:"CANCEL_REMARK",	Sort:0}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"견적취소사유",	SaveName:"CANCEL_REMARK_IMG",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"취소사유코드",	SaveName:"CANCEL_REMARK_CODE",	Sort:0}
					,{Align : "Center",SaveName : "DELAY_REASON_IMG",	Header : "견적지연사유",	Type : "Image",	Width : 90,	EditLen : 110,	Edit : false}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"DELAY_REASON_CODE",	SaveName:"DELAY_REASON_CODE",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"URL",	SaveName:"REMARK_URL",	Sort:0}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"MSDS",	SaveName:"MSDS_YN", BackColor:"${optColor}",	Sort:0}
					,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"선입고",	SaveName:"PRE_GR_FLAG" , HeaderCheck:0, BackColor:"${optColor}",	Sort:0}
					,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"긴급여부",	SaveName:"KEP_FAST_FLAG" , HeaderCheck:0, BackColor:"${optColor}",	Sort:0}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"DB클렌징최초처리일",	SaveName:"ITEM_CLEANSING_DATE",	Sort:0}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"DB클렌징최초처리자",	SaveName:"ITEM_CLEANSING_USER_NM",	Sort:0}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Date",	Header:"DB클렌징처리일",	SaveName:"CMS_RECV_DATE",	Sort:0}
					,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"DB클렌징처리일시",	SaveName:"CMS_RECV_DATM",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"품목유형",	SaveName:"ITEM_TYPE",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float",	Header:"연간예상소요량",	SaveName:"YEAR_QTY",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"이미지번호",	SaveName:"IMGFILE_NAME",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"IMGFILE_DIR",	SaveName:"IMGFILE_DIR",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"상세설명",	SaveName:"ITEM_DETAIL_DESC",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성1",	SaveName:"ATTB1_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성2",	SaveName:"ATTB2_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성3",	SaveName:"ATTB3_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성4",	SaveName:"ATTB4_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성5",	SaveName:"ATTB5_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성6",	SaveName:"ATTB6_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성7",	SaveName:"ATTB7_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성8",	SaveName:"ATTB8_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성9",	SaveName:"ATTB9_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성10",	SaveName:"ATTB10_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성11",	SaveName:"ATTB11_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성12",	SaveName:"ATTB12_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성13",	SaveName:"ATTB13_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성14",	SaveName:"ATTB14_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성15",	SaveName:"ATTB15_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성16",	SaveName:"ATTB16_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성17",	SaveName:"ATTB17_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성18",	SaveName:"ATTB18_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성19",	SaveName:"ATTB19_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"속성20",	SaveName:"ATTB20_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"소재지역ID",	SaveName:"AG_ID",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"소재지역명",	SaveName:"AG_SI",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사공개여부",	SaveName:"CP_AGENT_OPEN_FLAG",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CHOICE_TYPE",	SaveName:"CATEGORY_CHOICE_TYPE",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"DB클렌징처리자",	SaveName:"CM_USER_NM",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준카테고리셋팅",	SaveName:"CATEGORY_CHOICE_TYPE_NM",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CMS_REJECT_YN_2",	SaveName:"CMS_REJECT_YN_2",	Sort:0}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"SG담당자",	SaveName:"SOUR_MNG", Sort:1}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CATLG_CHOICE_TYPE",	SaveName:"CATALOG_CHOICE_TYPE",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준카탈로그셋팅",	SaveName:"CATALOG_CHOICE_TYPE_NM",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SEL_SELLER_ITEM_NO",	SaveName:"SEL_SELLER_ITEM_NO",	Sort:0}
					,{Align : "Center",	SaveName : "DELAY_SEND_MAIL_FLAG",			Header : "DELAY_SEND_MAIL_FLAG",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"ENG_DESC_YN",	SaveName:"ENG_DESC_YN",	Sort:0}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"MSDS요청(B)",	SaveName:"BUYER_MSDS_YN", Sort:1}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"안전인증서상태",	SaveName:"SAFETY_FLAG_TEXT", Sort:1}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"PLANT담당자",	SaveName:"PLANT_USER_NM", Sort:1}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"SG지정",	SaveName:"SG_D_FLAG", Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"SG지정일시",	SaveName:"SG_D_DATE", Sort:1}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"SG지정자",	SaveName:"SG_D_USER_NM", Sort:0}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"SG담당자",	SaveName:"SG_MNG_NM", Sort:0}
					,{ Align:"Center",	Width:60,	Edit:false,	Hidden:false,	Type:"Text",	Header:"품목정비",	SaveName:"CMS_REJECT_YN" ,	Sort:0}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목정비 요청자",	SaveName:"ITEM_CHG_REQ_NM", Sort:0}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목정비 요청일시",	SaveName:"ITEM_CHG_REQ_DATE", Sort:0}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",	Header:"정비구분",			SaveName:"ITEM_CHG_REQ_TYPE", Sort:0}
					,{ Align:"Left",	Width:300,	Edit:true,	EditLen:2000,	Hidden:false,	Type:"Text",	Header:"품목정비 요청사유",	SaveName:"ITEM_CHG_REQ_NOTE", BackColor:"${optColor}", Sort:0}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"품목정비\n첨부",	SaveName:"ITEM_CHG_REQ_IMAGE_KEY_IMG",	Sort:0}
	    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"품목정비\n첨부",	SaveName:"ITEM_CHG_REQ_IMAGE_KEY",	Sort:0}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목정비 제출자",	SaveName:"ITEM_MD_USER_NM", Sort:0}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목정비 제출일시",	SaveName:"ITEM_MD_DATE", Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ITEM_MD_REVISION",	SaveName:"ITEM_MD_REVISION",	Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ITEM_CHG_REQ_ID",	SaveName:"ITEM_CHG_REQ_ID",	Sort:0}
					,{ Align:"Center",	Width:60,	Edit:false,	Hidden:false,	Type:"Text",	Header:"견적첨부",	SaveName:"RQDT_IMAGE_KEY_YN" ,	Sort:0}
					,{ Align:"Center",	Width:130,	Edit:false,	EditLen:2000,	Hidden:true,	Type:"Text",	Header:"ADMIN_REMARK",	SaveName:"ADMIN_REMARK",	Sort:1}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SG_D_REVISION",	SaveName:"SG_D_REVISION",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"DELAY_FLAG",	SaveName:"DELAY_FLAG",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SG_REQ_YN",	SaveName:"SG_REQ_YN",	Sort:0}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:300,	Hidden:true,	Type:"Text",	Header:"EntityMaker사유",	SaveName:"MAKER_NOT_REASON",	Sort:0}
		];
		
		IBS_InitSheet2(mySheet, initsheet,pagingMode , 2);
		
		
		//조회조건 초기값 설정SO
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		$("#st_from_date").val(kepToDateAdd("7","M"));
		$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
		
		//비고이미지설정
		mySheet.SetImageList(1, remarkOn);
		mySheet.SetImageList(0, remarkOff);
		mySheet.SetImageList(10, iconR);
		mySheet.SetImageList(11, iconG);
		//파일첨부이미지설정
		mySheet.SetImageList(2, diskOff);
		mySheet.SetImageList(3, diskOn);

		//기등록구분 설정
		mySheet.SetImageList(4, itemGubun);
		//초기화이력 설정
		mySheet.SetImageList(5, initHistory);
		mySheet.SetImageList(6, dbClean);
		mySheet.SetImageList(7, iconOn);
		mySheet.SetImageList(9, reasonOn);
		mySheet.SetImageList(8, reasonOff);
		//지정협력사 삭제
		mySheet.SetImageList(12, eraser);
		
		
		//PLANT담당자 콤보데이터 셋팅. 로그인  부서 기준 사용자 리스트
		var st_user_dept = "<%=st_user_dept%>";
		kepAjaxCommonQueryIdSearchTwoCombo('st_plant_user_id','common.masterDepartmentUserList','',st_user_dept,'ALL','<%=st_smart_dept_yn.equals("Y") ? st_user_id : ""%>');
		
		// 콤보데이터 셋팅
		kepAjaxCommonQueryIdSearchTwoCombo('st_job_transfer_id','common.masterDepartmentUserList','PG_10_M_006_00','','ALL',''); // 조회조건 : 견적 담당자
		//하이퍼링크 설정
		setLinkCol(mySheet, "BUYER_NAME"); //고객사
		setLinkCol(mySheet, "QUOTATION_NO");	//견적번호
		setLinkCol(mySheet, "INIT_YN");	//견적초기화이력
		setLinkCol(mySheet, "SG_NAME");	//SG
		setLinkCol(mySheet, "BTOA_USER_NAME");	//요청자
		setLinkCol(mySheet, "ATOS_END_DATE2");	//견적마감일
		setLinkCol(mySheet, "CATEG_PATH");	//표준카테고리
		setLinkCol(mySheet, "SG_NAME");	//SG명
		setLinkCol(mySheet, "PICKUP_AGENT_NAME");	//협력사 지정
		setLinkCol(mySheet, "AGENT_NAME");	//기존협력사
		setLinkCol(mySheet, "ASSIGN_AGENT_NAME");	//지정협력사
		setLinkCol(mySheet, "ERASE_ASSIGN_AGENT");	//지정협력사 삭제
		setLinkCol(mySheet, "ATOA_REMARK");
		setLinkCol(mySheet, "BTOA_REMARK_IMG");
		setLinkCol(mySheet, "CANCEL_REMARK_IMG");
		setLinkCol(mySheet, "IMAGE_KEY_IMG");
		setLinkCol(mySheet, "SELLER_IMAGE_KEY_IMG");
		setLinkCol(mySheet, "CMS_CATLG_ID");
		setLinkCol(mySheet, "CMS_CATLG_IMG");
		setLinkCol(mySheet, "ERASE_CMS_CATLG_ID");
		setLinkCol(mySheet, "ITEM_GUBUN_IMG");
		setLinkCol(mySheet, "ITEM_GUBUN_IMG");
		setLinkCol(mySheet, "JOB_TRANSFER_NM");
		setLinkCol(mySheet, "DELAY_REASON_IMG");
		setLinkCol(mySheet, "DELY_AREA_IMG");
		setLinkCol(mySheet, "RFQ_IMG_FLAG"); //이미지 필수
		setLinkCol(mySheet, "ITEM_CHG_REQ_DATE"); //품목정비 요청일시
		setLinkCol(mySheet, "ITEM_MD_DATE"); //품목정비 제출일시
		setLinkCol(mySheet, "NOTE_MNG_IMG"); //특이사항 입력
		setLinkCol(mySheet, "ITEM_CHG_REQ_IMAGE_KEY_IMG"); //품목정비 첨부
		setLinkCol(mySheet, "SG_D_DATE"); // SG지정일시
		
		mySheet.SetCellFontUnderline(0, "ATOS_END_DATE2", true);
		mySheet.SetCellFontUnderline(0, "CATEG_PATH", true);
		mySheet.SetCellFontUnderline(0, "BTOA_REMARK_IMG", true);
		mySheet.SetCellFontUnderline(0, "CANCEL_REMARK_IMG", true);
		mySheet.SetCellFontUnderline(0, "ITEM_MAKE_TYPE", true);
		mySheet.SetCellFontUnderline(0, "JOB_TRANSFER_NM", true);
		mySheet.SetCellFontUnderline(0, "PICKUP_AGENT_NAME", true);
		mySheet.SetCellFontUnderline(0, "ORIGIN_NAME", true);
		mySheet.SetCellFontUnderline(0, "MAKER_NAME", true);
		mySheet.SetCellFontUnderline(0, "RFQ_IMG_FLAG", true); //이미지 필수
		mySheet.SetCellFontUnderline(0, "ITEM_CHG_REQ_TYPE", true);
		mySheet.SetCellFontUnderline(0, "ITEM_CHG_REQ_NOTE", true);
		
		mySheet.SetColProperty("ITEM_MAKE_TYPE", comboInfo);
		mySheet.SetColProperty("ITEM_CHG_REQ_TYPE", item_chg_req_type);
		
		var searchYn = "<%=searchYn%>";
		
		$("#st_buyer_code").val("<%=buyerCode%>");
		$("#st_buyer_name").val("<%=buyerName%>");
		
		if(searchYn == "Y"){
			doAction("search");
		}
	}		
	var st;
	var mt;
	var smartSG;	
	//기능함수
	function doAction(str, gbn) {
		
		st = new Date();
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");

		//선택된 항목 유무 체크
		if (str !="search" && str !="reload" && selectedGrid.length == 0 && str != "downexcel" && str != "categ" && str != "catlg") {
			alert("선택된 항목이 없습니다.");
			return;
		}
		
		switch (str) {
		case "search":
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n3개월 이상의 데이타는 S/R 요청 바랍니다.");
				return;
			}

			//RPA 아이디 고객사 필수 해제
			if($("#st_rpa_yn").val() == "N"){ // RPA 아이디 아니면 이하 모두 적용
				//소싱부서가 아닐 경우 고객사코드 필수 값.
				if($("#st_sour_dept_yn").val() == "N"){					
						if($("#st_buyer_code").val() == null||$("#st_buyer_code").val() == ""){
							alert("고객사은(는) 필수입력 항목입니다.");
							return;
						}					
				} 
			}
			
			if(document.getElementById("st_recheckbox").checked == true){
				 $("#st_doc_type").val('Y');		
			}else{
				 $("#st_doc_type").val('N');					
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
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mprq/searchMasterMpRqReqQuotReceiptList.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			$('#st_buyer_code').val("");	
			
			mySheet.RemoveAll();
			$("#st_from_date").val(kepToDateAdd("7","M"));
			$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
			document.getElementById("st_recheckbox").checked = false;
			document.getElementById("st_req_itemcheck").checked = false;
			if( $('#st_rpa_yn').val() == "Y" ){
				document.getElementById("st_exits_itemcheck").checked = false;
			}
			
			// SG 지정 초기화
			if( $('#st_sour_supl_yn').val() == "Y" ){
				document.getElementById("st_sg_d_falg").selectedIndex = 2;
			}else if( $('#st_sg_req_dept_yn').val() == "Y" ){
				document.getElementById("st_sg_d_falg").selectedIndex = 1;
			}
			break;
		case "dss":
			//SLOGIC-BEGIN(P04-4029-02)
			var beforeSg = mySheet.GetCellValue(arrRow[0],"SG_ID");
			
			// 지정협력사
			var before_assign_agent = mySheet.GetCellValue(arrRow[0], "ASSIGN_AGENT_CODE");
			
			var buyer = "";
			var maker_code = "";
			var maker_name = "";
			var quotation_no = "";
			var quotation_seq = "";
			var revision = "";
			
			var buyer_name = "";
 			var sg_id = "";
 			var sg_name = "";
 			var ag_id = "";
 			var ag_si = "";
			var multi_agent = "";
			var eng_desc_yn = "";
			
			var assign_agent_code = "";
			var assign_agent_name = "";
			
			for (var i=0; i<arrRow.length; i++){
				var sg    = mySheet.GetCellValue(arrRow[i],"SG_ID");
				if(sg != beforeSg) {
					alert("동일한 SG 품목끼리만 기능을 사용 할수 있습니다");
					return;
				}
				
				var assign_agent = mySheet.GetCellValue(arrRow[i], "ASSIGN_AGENT_CODE");
				if(assign_agent != before_assign_agent) {
					alert("동일한 지정협력사만 기능을 사용 할수 있습니다");
					return;
				}

				if (arrRow.length == 1){
					buyer = mySheet.GetCellValue(arrRow[0], "BUYER");
					maker_code = mySheet.GetCellValue(arrRow[0],"MAKER_CODE"); // 제조사ID
					maker_name = mySheet.GetCellValue(arrRow[0],"MAKER_NAME"); // 제조사명
					quotation_no = mySheet.GetCellValue(arrRow[0], "QUOTATION_NO");
					quotation_seq = mySheet.GetCellValue(arrRow[0], "QUOTATION_SEQ");
					revision = mySheet.GetCellValue(arrRow[0], "REVISION");
					
					buyer_name = mySheet.GetCellValue(arrRow[0],"BUYER_NAME");
		 			sg_id = mySheet.GetCellValue(arrRow[0],"SG_ID");
		 			sg_name = mySheet.GetCellValue(arrRow[0],"SG_NAME");
		 			ag_id = mySheet.GetCellValue(arrRow[0],"AG_ID");
		 			ag_si = mySheet.GetCellValue(arrRow[0],"AG_SI");
					multi_agent = mySheet.GetCellValue(arrRow[0],"PICKUP_AGENT_ID");
					multi_agent_dss = mySheet.GetCellValue(arrRow[0],"PICKUP_AGENT_DSS");
					
					// 지정협력사
					assign_agent_code = mySheet.GetCellValue(arrRow[0], "ASSIGN_AGENT_CODE");
					assign_agent_name = mySheet.GetCellValue(arrRow[0], "ASSIGN_AGENT_NAME");
					
					//DB클렌징 확인 체크 로직 추가
					/*if (mySheet.GetCellValue(arrRow[0],"CM_USER_NM") == ""){
		 				alert(mySheet.GetCellValue(arrRow[0],"BUYER_ITEM_NO")+" 품목의 DB클렌징 작업을 먼저 수행하세요.");
		 				return;						
					}*/		 			
					if (mySheet.GetCellValue(arrRow[0],"CMS_CATEG_ID") == "" && mySheet.GetCellValue(arrRow[0],"SG_ID") == ""){
		 				alert(mySheet.GetCellValue(arrRow[0],"BUYER_ITEM_NO")+" 품목의 표준카테고리와 DB클렌징 작업을 먼저 수행하세요.");
		 				return;
		 			}
		 			
					if (mySheet.GetCellValue(arrRow[0],"CMS_CATEG_ID") == "" || sg_id == "" || maker_code == "" || mySheet.GetCellValue(arrRow[0],"ORIGIN_CODE") == ""){
		 				alert(mySheet.GetCellValue(arrRow[0],"BUYER_ITEM_NO")+" 품목의 표준카테고리와 DB클렌징 작업을 먼저 수행하세요.");
		 				return;
		 			}
					//영문 품명, 규격 필수값일때 체크 로직 추가
		 			if (mySheet.GetCellValue(arrRow[0],"ENG_DESC_YN") == "Y"){
		 				if(mySheet.GetCellValue(arrRow[0],"DESCRIPTION_ENG") == ""||mySheet.GetCellValue(arrRow[0],"SPECIFICATION_ENG") == ""){
			 				alert(mySheet.GetCellValue(arrRow[0],"BUYER_ITEM_NO")+" 품목 DB클렌징 작업 통해서 영문 품명, 규격 입력 바랍니다.");
			 				return;		 					
		 				}
		 			}
		 			if (mySheet.GetCellValue(arrRow[0],"ATOS_END_DATE") == ""){
		 				alert(mySheet.GetCellValue(arrRow[0],"BUYER_ITEM_NO")+" 품목의 견적마감일을 먼저 선택하세요.");
		 				return;
		 			}
				} else if (arrRow.length >= 2){
					maker_code = maker_code + mySheet.GetCellValue(arrRow[i],"MAKER_CODE")+ "@";
					maker_name = maker_name + mySheet.GetCellValue(arrRow[i],"MAKER_NAME")+ "@";

					buyer = mySheet.GetCellValue(arrRow[arrRow.length-1], "BUYER");
					quotation_no = mySheet.GetCellValue(arrRow[arrRow.length-1], "QUOTATION_NO");
					quotation_seq = mySheet.GetCellValue(arrRow[arrRow.length-1], "QUOTATION_SEQ");
					revision = mySheet.GetCellValue(arrRow[arrRow.length-1], "REVISION");
					
					buyer_name = mySheet.GetCellValue(arrRow[arrRow.length-1],"BUYER_NAME");
		 			sg_id = mySheet.GetCellValue(arrRow[0],"SG_ID");
		 			sg_name = mySheet.GetCellValue(arrRow[0],"SG_NAME");
		 			ag_id = mySheet.GetCellValue(arrRow[arrRow.length-1],"AG_ID");
		 			ag_si = mySheet.GetCellValue(arrRow[arrRow.length-1],"AG_SI");
					multi_agent = "";
					multi_agent_dss = "";
					
					// 지정협력사 (위에서 지정협력사 통일 확인했기 때문에 아무 열에 있는거 사용 가능)
					assign_agent_code = mySheet.GetCellValue(arrRow[0], "ASSIGN_AGENT_CODE");
					assign_agent_name = mySheet.GetCellValue(arrRow[0], "ASSIGN_AGENT_NAME");
					
					//DB클렌징 확인 체크 로직 추가
					/*if (mySheet.GetCellValue(arrRow[i],"CM_USER_NM") == ""){
		 				alert(mySheet.GetCellValue(arrRow[i],"BUYER_ITEM_NO")+" 품목의 DB클렌징 작업을 먼저 수행하세요.");
		 				return;						
					}*/
					if (mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID") == "" && mySheet.GetCellValue(arrRow[i],"SG_ID") == ""){
						alert(mySheet.GetCellValue(arrRow[i],"BUYER_ITEM_NO")+" 품목의 표준카테고리와 DB클렌징 작업을 먼저 수행하세요.");
		 				return;
		 			}
					if (mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID") == "" || mySheet.GetCellValue(arrRow[i],"SG_ID") == "" || maker_code.replace("@","") == "" || mySheet.GetCellValue(arrRow[i],"ORIGIN_CODE") == ""){
		 				alert(mySheet.GetCellValue(arrRow[i],"BUYER_ITEM_NO")+" 품목의 표준카테고리와 DB클렌징 작업을 먼저 수행하세요.");
		 				return;
		 			}
					//영문 품명, 규격 필수값일때 체크 로직 추가
		 			if (mySheet.GetCellValue(arrRow[i],"ENG_DESC_YN") == "Y" ){
		 				if(mySheet.GetCellValue(arrRow[i],"DESCRIPTION_ENG") == "" || mySheet.GetCellValue(arrRow[i],"SPECIFICATION_ENG") == ""){
			 				alert(mySheet.GetCellValue(arrRow[i],"BUYER_ITEM_NO")+" 품목 DB클렌징 작업 통해서 영문 품명, 규격 입력 바랍니다.");
			 				return;		 					
		 				}
		 			}					
		 			if (mySheet.GetCellValue(arrRow[i],"ATOS_END_DATE") == ""){
		 				alert(mySheet.GetCellValue(arrRow[i],"BUYER_ITEM_NO")+" 품목의 견적마감일을 먼저 선택하세요.");
		 				return;
		 			}
				}
			} 
			// 중복제거
			var mknm = removeArrayDuplicate(maker_name.split("@"));
			maker_name = mknm.toString().substring(0, mknm.toString().length-1);
			grbRow = "";
			
			// 지정협력사
		    if(assign_agent_name == "" || assign_agent_name == null){
		    	assign_agent_name = "없음";	
		    }
		    
		    //OpenPopup
			popupSel = "masterMpRqDssSellerSelPop";
 			// 고객사코드, 고객사명, 소싱그룹ID, 소싱그룹명, 제조사코드
 			openSearchPopup('/mprq/showMasterMpRqDssSellerSelPop.do','?st_buyer_code='+buyer+"&st_buyer_name="+buyer_name
 										+"&st_sg_id="+sg_id+"&st_sg_name="+sg_name+"&st_maker_code="+maker_code
 										+"&st_maker_name="+maker_name+"&st_ag_id="+ag_id+"&st_ag_si="+ag_si
 										+"&st_quotation_no="+quotation_no+"&st_quotation_seq="+quotation_seq+"&st_revision="+revision
 										+"&st_multi_agent="+multi_agent+"&st_multi_agent_dss="+multi_agent_dss+"&st_assign_agent_code="+assign_agent_code+"&st_assign_agent_name="+assign_agent_name
 										,"900,800,yes"); // DSS 추천 협력사 조회 팝업
			break;
			//SLOGIC-END
		case "save":
			
			mySheet.SetColProperty("ATOS_END_DATE2",{KeyField:false});
			mySheet.SetColProperty("CATEG_PATH",{KeyField:false});
			mySheet.SetColProperty("SG_NAME",{KeyField:false});
			mySheet.SetColProperty("DB_CLEAN",{KeyField:false});
			mySheet.SetColProperty("ITEM_MAKE_TYPE",{KeyField:false});
			
			var image_pass_alert = "N";
			
			for(var i=0; i<arrRow.length; i++){
				var seller_image_key = mySheet.GetCellValue(arrRow[i],"SELLER_IMAGE_KEY");
				var image_pass_flag = mySheet.GetCellValue(arrRow[i],"IMAGE_PASS_FLAG");
				
				if(seller_image_key != "" && image_pass_flag == "1"){
					image_pass_alert = "Y";
				}
			}
			
			if(image_pass_alert == "Y"){ // 첨부(ATOS)를 등록하고 협력사전달을 체크한 경우
				if (!confirm('첨부(ATOS)가 아닌 첨부(B)를 그대로 협력사에 전달합니다.\n견적정보를 수정하시겠습니까?'))
					return;
				kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqReqQuotReceipt.do" , "SELECTED" );	
			}else{
				if (!confirm('견적정보를 수정하시겠습니까?'))
					return;
				kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqReqQuotReceipt.do" , "SELECTED" );
			}
			
			break;
		case "transfer":
			for (var i=0; i<arrRow.length; i++){

				var cms_categ_id = mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID"); // 카테고리ID
				var sg_id = mySheet.GetCellValue(arrRow[i],"SG_ID");
				var maker_code = mySheet.GetCellValue(arrRow[i],"MAKER_CODE"); // 제조사ID
				var origin_code = mySheet.GetCellValue(arrRow[i],"ORIGIN_CODE"); // 원산지코드
	 			
				if($("#st_smart_dept_yn").val()=="N"){ // SMART팀 클린징 체크 제외
					if (cms_categ_id == "" || sg_id == "" || maker_code == "" || origin_code == ""){
		 				alert('표준카테고리와 DB클렌징 작업을 먼저 수행하세요. ['+arrRow[i]+' 번째 ]');
		 				return;
		 			}	

				}
				if (kepIsValueNull(mySheet.GetCellValue(arrRow[i],"JOB_TRANSFER_ID"))){
					alert('견적이관 대상자 지정 바랍니다. ['+arrRow[i]+' 번째 ]');
					return;
				}
			}
			mySheet.SetColProperty("ATOS_END_DATE2",{KeyField:false});
			mySheet.SetColProperty("CATEG_PATH",{KeyField:false});
			mySheet.SetColProperty("SG_NAME",{KeyField:false});
			mySheet.SetColProperty("DB_CLEAN",{KeyField:false});
			mySheet.SetColProperty("ITEM_MAKE_TYPE",{KeyField:false});
			
			if (!confirm('견적이관 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqReqQuotTrans.do" , "SELECTED" );
			break;
		case "AgentOrder":
			var image_pass_alert = "N";
			
			mySheet.SetColProperty("ATOS_END_DATE2",{KeyField:true});
			mySheet.SetColProperty("CATEG_PATH",{KeyField:true});
			mySheet.SetColProperty("SG_NAME",{KeyField:true});
			mySheet.SetColProperty("DB_CLEAN",{KeyField:true});
			mySheet.SetColProperty("ITEM_MAKE_TYPE",{KeyField:false});
			
			for (var i=0; i<arrRow.length; i++){
				var atos_remark    = mySheet.GetCellValue(arrRow[i],"ATOS_REMARK");
				var item_type  = mySheet.GetCellValue(arrRow[i],"ITEM_TYPE");
				var year_qty   = mySheet.GetCellValue(arrRow[i],"YEAR_QTY");
				var atos_end_date = mySheet.GetCellValue(arrRow[i],"ATOS_END_DATE");
				var atos_end_time = mySheet.GetCellValue(arrRow[i],"ATOS_END_TIME");
				var pickup_agent = mySheet.GetCellValue(arrRow[i],"PICKUP_AGENT_NAME");
				var buyer = mySheet.GetCellValue(arrRow[i],"BUYER");
				var cms_categ_id = mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID"); // 카테고리ID
				var cms_categ_path = mySheet.GetCellValue(arrRow[i],"CATEG_PATH"); // 표준카테고리경로
				var sg_id = mySheet.GetCellValue(arrRow[i],"SG_ID");
				var maker_code = mySheet.GetCellValue(arrRow[i],"MAKER_CODE"); // 제조사ID
				var maker_name = mySheet.GetCellValue(arrRow[i],"MAKER_NAME"); // 제조사
				var origin_code = mySheet.GetCellValue(arrRow[i],"ORIGIN_CODE"); // 원산지코드
				var origin_name = mySheet.GetCellValue(arrRow[i],"ORIGIN_NAME"); // 원산지
				var item_qty = mySheet.GetCellValue(arrRow[i],"ITEM_QTY"); // 수량
				var st_sg_d_flag = mySheet.GetCellValue(arrRow[i],"SG_D_FLAG"); // SG 지정 여부
				var cms_reject_gubun = mySheet.GetCellValue(arrRow[i],"CMS_REJECT_GUBUN"); // 품목정비 미완료
				var seller_image_key = mySheet.GetCellValue(arrRow[i],"SELLER_IMAGE_KEY");
				var image_pass_flag = mySheet.GetCellValue(arrRow[i],"IMAGE_PASS_FLAG");
				var delay_flag = mySheet.GetCellValue(arrRow[i],"DELAY_FLAG");
				var delay_reason_img = mySheet.GetCellValue(arrRow[i],"DELAY_REASON_IMG");
				var st_sg_req_yn = mySheet.GetCellValue(arrRow[i],"SG_REQ_YN"); // SG지정 통제 여부
				
				if(seller_image_key != "" && image_pass_flag == "1"){
					image_pass_alert = "Y";
				}
				
				if( $('#st_sg_req_dept_yn').val() == "Y" && st_sg_req_yn == "Y"){ //SG 지정 체크 대상(DSM + 일반 사업팀)
					if(st_sg_d_flag != "지정"){
						alert("SG 미지정 된 건 이므로 처리 불가능 합니다.["+arrRow[i]+"번째]");
						return;
					}
				}
				
				if(cms_reject_gubun == "/resources/images/icon_r.gif") {
					alert('품목정비 요청 후 미제출건은 진행할 수 없습니다. ['+arrRow[i]+' 번째 ]');
					return;
				}
				
				if (kepIsValueNull(mySheet.GetCellValue(arrRow[i],"BUYER_ITEM_NO"))){
					alert("품목 정보가 없습니다.");
					return;
				}
				
				if (kepIsValueNull(mySheet.GetCellValue(arrRow[i],"DESCRIPTION"))){
					alert("품목명 정보가 없습니다.");
					return;
				}
				
				if (kepIsValueNull(mySheet.GetCellValue(arrRow[i],"SPECIFICATION"))){
					alert("규격 정보가 없습니다.");
					return;
				}
				
				if (kepIsValueNull(mySheet.GetCellValue(arrRow[i],"PICKUP_AGENT_ID"))){
					alert('협력사지정은 필수 입력항목입니다. ['+arrRow[i]+' 번째 ]');
					return;
				}
				if (cms_categ_path == "" || cms_categ_id == "" || sg_id == "" || maker_code == "" || maker_name == "" || origin_code == "" || origin_name == ""){
	 				alert('표준카테고리와 DB클렌징 작업을 먼저 수행하세요. ['+arrRow[i] +' 번째 ]');
	 				return;
	 			}
				if(kepIsValueNull(atos_end_date)) {
					alert('견적마감일은 필수 입력항목입니다. ['+arrRow[i] +' 번째 ]');
					return;
				}
				if(kepIsValueNull(atos_end_time)) {
					alert('견적마감시간은 필수 입력항목입니다. ['+arrRow[i] +' 번째 ]');
					return;
				}
				if(pickup_agent == "미지정") {
					alert('협력사지정은 필수 입력항목입니다. ['+arrRow[i]+' 번째 ]');
					return;
				}
				if(item_qty <= 0) {
					alert('0보다 큰 수량은 필수 입력항목입니다. ['+arrRow[i]+' 번째 ]');
					return;
				}
				
				// 지연사유 입력 필수 체크
				if(delay_reason_img != "/resources/images/icon.gif" && delay_flag == "Y"){
					alert('견적지연사유를 입력해주세요. ['+arrRow[i]+' 번째 ]');
					return;
				}
				
	 			var rqdtGbnYn = getSgInfo(arrRow[i]);
	 			var rqdtCategnYn = getCategInfo(arrRow[i]);
	 			var rqdtBuyerYn = getBuyerSgInfo(arrRow[i]);
	 			if(rqdtBuyerYn == "N"){
		 			if(rqdtGbnYn== "N"&&rqdtCategnYn=="Y"){
						alert('전략소싱팀 담당자 진행건이므로 협력사 견적 요청을 할수없습니다.['+arrRow[i]+' 번째 ]');
						return;
		 			}	 				
	 			}

				if (buyer =="KRDOOD0001"){
					if (kepIsValueNull(kepTrimStr(atos_remark))) { 
						atos_remark = "품목구분 : "+item_type+"\r\n년간예상소요량 : "+year_qty;
					} else{
						atos_remark = atos_remark + "<br>품목구분 : "+item_type+"<br>년간예상소요량 : "+year_qty; 
					}
				} else if(buyer =="KRILJI0003" || buyer =="KRILJI0026"){
					if(kepIsValueNull(kepTrimStr(atos_remark))) {
						atos_remark = "년간예상소요량 : "+year_qty;
					}else{
						atos_remark = atos_remark + "<br>년간예상소요량 : "+year_qty; 
					}
				}
				mySheet.SetCellValue(arrRow[i], 'ATOS_REMARK', atos_remark);
				//SLOGIC-END
			}

			if(image_pass_alert == "Y"){ // 첨부(ATOS)를 등록하고 협력사전달을 체크한 경우
				if (!confirm('첨부(ATOS)가 아닌 첨부(B)를 그대로 협력사에 전달합니다.\n견적요청 하시겠습니까?'))
					return;
				kepSave(document.searchCondition ,  mySheet , "/mprq/orderMasterMpRqReqQuotReceipt.do" , "SELECTED" );	
			}else{
				if (!confirm('견적요청 하시겠습니까?'))
					return;
				kepSave(document.searchCondition ,  mySheet , "/mprq/orderMasterMpRqReqQuotReceipt.do" , "SELECTED" );
			}
			
			break;
		case "del":
			
			for (var i=0; i<selectedGrid.length; i++){
				var CANCEL_REMARK = mySheet.GetCellValue(arrRow[i],"CANCEL_REMARK");
				var CANCEL_REMARK_CODE = mySheet.GetCellValue(arrRow[i],"CANCEL_REMARK_CODE");
				if(CANCEL_REMARK == "" && CANCEL_REMARK_CODE == ""){
					alert("견적 취소 사유를 입력하여 주십시요");
					mySheet.SelectCell(arrRow[i], "CANCEL_REMARK_IMG");
					return;
				}
			}
			mySheet.SetColProperty("ATOS_END_DATE2",{KeyField:false});
			mySheet.SetColProperty("CATEG_PATH",{KeyField:false});
			mySheet.SetColProperty("SG_NAME",{KeyField:false});
			mySheet.SetColProperty("DB_CLEAN",{KeyField:false});
			mySheet.SetColProperty("ITEM_MAKE_TYPE",{KeyField:false});
			
			if (!confirm('견적취소 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mprq/delMasterMpRqReqQuotReceipt.do" , "SELECTED" );
			break;
		case "downexcel":
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			
		    $("#pageflag").val('0');
			var param = {FileName:"견적의뢰조회.xlsx",Merge:1,SheetDesign:1,DownCols:"BUYER_NAME|BUYER|QUOTATION_NO|QUOTATION_SEQ|REVISION|BUYER_ITEM_NO|CMS_CATEG_ID|CATEG_PATH|DESCRIPTION|SPECIFICATION|KEP_SPECIFICATION|MAKER_CODE|MAKER_NAME|ORIGIN_CODE|ORIGIN_NAME|ITEM_QTY|UNIT_MEASURE|MAKER_PART_NO|REF_NO|ITEM_MAKE_TYPE |BUYER_TARGET_PRICE|ADMIN_TARGET_PRICE|BTOA_DATE|BTOA_END_DATE|BTOA_END_TIME|ATOS_END_DATE|ATOS_END_TIME2|BTOA_USER_ID|BTOA_USER_NAME|BTOA_USER_TEL|AGENT_OPEN_FLAG|BTOA_REMARK|ATOS_REMARK|IMAGE_KEY|PICKUP_AGENT_ID|PICKUP_AGENT_NAME|AGENT_NAME|SG_ID|SG_NAME|IMAGE_PASS_FLAG|CANCEL_REMARK|ITEM_TYPE|MSDS_YN|ITEM_CLEANSING_DATE|ITEM_CLEANSING_USER_NM|PLANT_USER_NM|ITEM_CHG_REQ_NM|ITEM_CHG_REQ_DATE|ITEM_CHG_REQ_NOTE"};
			kepDownExcel(document.searchCondition ,mySheet , "/mprq/excelMasterMpRqReqQuotReceiptList.do", param);
			$("#pageflag").val('1');
			break;
		case "categ":
			var totRow = mySheet.RowCount();
			
			if( totRow<= 0) return;
		
			for(var i=1; i<=totRow;i++){
				if(mySheet.GetCellValue(i,"SG_ID") == ""){
					var st_categ_desc = mySheet.GetCellValue(i,"DESCRIPTION"); // 품목명
					var st_categ_spec = mySheet.GetCellValue(i,"SPECIFICATION"); // 규격
					var st_categ_maker = mySheet.GetCellValue(i,"MAKER_NAME"); // 제조사명
					var st_categ_model = mySheet.GetCellValue(i,"MAKER_PART_NO"); // 모델번호
					
					document.categForm.categ_row_no.value = i;
					document.categForm.categ_desc.value = st_categ_desc;
					document.categForm.categ_spec.value = st_categ_spec;
					document.categForm.categ_maker.value = st_categ_maker;
					document.categForm.categ_model.value = st_categ_model;
					
					kepAjaxFormCall("/mprq/searchCategAutoSetting.do","categForm","DQCAT");	
				}
			}
/*	체크박스 내용으로 세팅		
			for (var i=0; i<arrRow.length; i++){
				var st_categ_desc = mySheet.GetCellValue(arrRow[i],"DESCRIPTION"); // 품목명
				document.categForm.categ_desc.value = st_categ_desc;
				document.categForm.categ_row_no.value = arrRow[i];
				
				kepAjaxFormCall("/mprq/searchCategAutoSetting.do","categForm","DQCAT");
			}
*/			
/* 무조건 올 그리드				
			var totRow = mySheet.RowCount();
			
			if( totRow<= 0) return;
		
			for(var i=1; i<=totRow;i++){
				var st_categ_description = mySheet.GetCellValue(i,"DESCRIPTION"); // 품목명
				document.categForm.categ_description.value = st_categ_description;
				document.categForm.categ_row_no.value = i;
				//alert(document.categForm.categ_description.value + document.categForm.categ_row_no.value);
				kepAjaxFormCall("/mprq/searchCategAutoSetting.do","categForm","DQCAT");
			}
*/			
			break;
			
		case "catlg":
			totRow = mySheet.RowCount();
			
			if( totRow<= 0) return;

			for(i=1; i<=totRow;i++){
				if(mySheet.GetCellValue(i,"CMS_CATLG_ID") == ""){
					var st_catlg_desc = mySheet.GetCellValue(i,"DESCRIPTION"); // 품목명
					var st_catlg_spec = mySheet.GetCellValue(i,"SPECIFICATION"); // 규격
					var st_catlg_maker = mySheet.GetCellValue(i,"MAKER_NAME"); // 제조사명
					var st_catlg_model = mySheet.GetCellValue(i,"MAKER_PART_NO"); // 모델번호
					
					document.catlgForm.catlg_row_no.value = i;
					document.catlgForm.catlg_desc.value = st_catlg_desc;
					document.catlgForm.catlg_spec.value = st_catlg_spec;
					document.catlgForm.catlg_maker.value = st_catlg_maker;
					document.catlgForm.catlg_model.value = st_catlg_model;
					
					kepAjaxFormCall("/mprq/searchCatlgAutoSetting.do","catlgForm","CATLG_RCMD");	
				}
			}
			
			break;
			
		case "item_chg_req":
			
			for(var i=0; i<arrRow.length;i++){
				var st_cms_reject_yn = mySheet.GetCellValue(arrRow[i],"CMS_REJECT_YN");
				var st_item_md_date = mySheet.GetCellValue(arrRow[i],"ITEM_MD_DATE");
				if(st_cms_reject_yn == "Y" && st_item_md_date == ""){
					alert("이미 품목정비 요청중인 견적건입니다.["+arrRow[i]+"번째]");
					return;
				}
				
				var st_req_type = mySheet.GetCellValue(arrRow[i],"ITEM_CHG_REQ_TYPE");
				if(st_req_type == ""){
					alert("정비구분을 선택하여 주십시요.["+arrRow[i]+"번째]");
					mySheet.SelectCell(arrRow[i], "ITEM_CHG_REQ_TYPE", 1, "");
					return;
				}
				
				var st_req_note = mySheet.GetCellValue(arrRow[i],"ITEM_CHG_REQ_NOTE");
				if(st_req_note.length == 0){
					alert("요청사유를 입력하여 주십시요.["+arrRow[i]+"번째]");
					mySheet.SelectCell(arrRow[i], "ITEM_CHG_REQ_NOTE", 1, "");
					return;
				}
			}
			//Confirm 처리 방식.
			g_confirm_type = "ItemChgReq"; // Confirm 타입 선언
			$("#confirmMsgDiv").text("품목재정비를 요청하시겠습니까?"); //Confirm 문구 입력
			$("#confirmAreaDiv").show(); //Confirm 창 확인.
			
			break;
		case "sg_set": //sg지정
			for(var i=0; i<arrRow.length;i++){
				var st_sg_d_flag = mySheet.GetCellValue(arrRow[i],"SG_D_FLAG");
				if(st_sg_d_flag == "지정"){
					alert("SG 지정 된 건이므로 처리 불가능 합니다.["+arrRow[i]+"번째]");
					return;
				}
				
				var st_sg_id = mySheet.GetCellValue(arrRow[i],"SG_ID");
				if(st_sg_id == ""){
					alert("SG 선택이 안 된 건이므로 처리 불가능 합니다.["+arrRow[i]+"번째]");
					mySheet.SelectCell(arrRow[i], "SG_NAME", 1, "");
					return;
				}
			}
			mySheet.SetColProperty("ATOS_END_DATE2",{KeyField:false});
			mySheet.SetColProperty("CATEG_PATH",{KeyField:false});
			mySheet.SetColProperty("SG_NAME",{KeyField:false});
			mySheet.SetColProperty("DB_CLEAN",{KeyField:false});
			mySheet.SetColProperty("ITEM_MAKE_TYPE",{KeyField:false});
			//Confirm 처리 방식.
			if(confirm("SG 지정 하시겠습니까?")){
				kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqSGInfo.do" , "SELECTED" );	
			}
			break;
		case "sg_cancle": //sg지정 취소 or 재요청
			for(var i=0; i<arrRow.length;i++){
				var st_sg_d_flag = mySheet.GetCellValue(arrRow[i],"SG_D_FLAG");
				if(st_sg_d_flag == "미지정"){
					alert("SG 미지정 된 건 이므로 처리 불가능 합니다.["+arrRow[i]+"번째]");
					return;
				}
			}
			mySheet.SetColProperty("ATOS_END_DATE2",{KeyField:false});
			mySheet.SetColProperty("CATEG_PATH",{KeyField:false});
			mySheet.SetColProperty("SG_NAME",{KeyField:false});
			mySheet.SetColProperty("DB_CLEAN",{KeyField:false});
			mySheet.SetColProperty("ITEM_MAKE_TYPE",{KeyField:false});
			//SG 지정 타입 Y:지정, N:미지정, R:재요청
			$("#st_sg_type").val(gbn);
			var st_msg = "";
			if(gbn == "N"){
				st_msg = "SG 취소 하시겠습니까?";
			}else if(gbn == "R"){
				st_msg = "SG지정 재요청 하시겠습니까?";				
			}
			//Confirm 처리 방식.
			if(confirm(st_msg)){
				kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqSGCancle.do" , "SELECTED" );	
			}
			break;
			
		case "imageCopy":
			if(arrRow.length < 2){
				alert("둘 이상의 선택이 필요합니다.");
				return;
			}
			
			var st_imgfile_name = mySheet.GetCellValue(arrRow[0],"IMGFILE_NAME");
			
			if(st_imgfile_name == ""){
				alert("체크된 첫 행의 이미지가 비어있습니다.");
				return;
			}
			
			//Confirm 처리 방식.
			g_confirm_type = "imageCopy"; // Confirm 타입 선언
			$("#confirmMsgDiv").html("체크된 첫 행의 상품이미지로 모두 복사합니다.<br/>이대로 진행하시겠습니까?"); //Confirm 문구 입력
			$("#confirmAreaDiv").show(); //Confirm 창 확인.
			
			break;
			
		case "cleansingCopy":
			if(arrRow.length < 2){
				alert("둘 이상의 선택이 필요합니다.");
				return;
			}
			
			var st_cleansing_date = mySheet.GetCellValue(arrRow[0],"CMS_RECV_DATE");
			var st_categ_path_firstRow = mySheet.GetCellValue(arrRow[0],"CATEG_PATH");
			
			for(var i=0; i<arrRow.length;i++){
				var st_categ_path = mySheet.GetCellValue(arrRow[i],"CATEG_PATH");
				
				if(st_categ_path_firstRow != st_categ_path){ // 표준카테고리 미일치
					alert("동일한 표준카테고리만 가능합니다.");
					return;
				}
			}
			
			if(st_cleansing_date == ""){
				alert("체크된 첫 행의 DB클랜징이 안되어 있습니다.");
				return;
			}
			
			//Confirm 처리 방식.
			g_confirm_type = "cleansingCopy"; // Confirm 타입 선언
			$("#confirmMsgDiv").html("체크된 첫 행의 DB클랜징(이미지포함)으로 모두 복사합니다.<br/>이대로 진행하시겠습니까?"); //Confirm 문구 입력
			$("#confirmAreaDiv").show(); //Confirm 창 확인.
			
			break;
		}
	}
	
	//Confirm창 확인처리
	function confirmAreaDivSearch(){
		$("#confirmAreaDiv").hide();	
		if(g_confirm_type == "ItemChgReq"){ //품목재정비 요청
			mySheet.SetColProperty("ATOS_END_DATE2",{KeyField:false});
			mySheet.SetColProperty("CATEG_PATH",{KeyField:false});
			mySheet.SetColProperty("SG_NAME",{KeyField:false});
			mySheet.SetColProperty("DB_CLEAN",{KeyField:false});
			mySheet.SetColProperty("ITEM_MAKE_TYPE",{KeyField:false});
			
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow = selectedGrid.split("|");
			for(var i = 0; i<arrRow.length;i++){
				var st_req_note = mySheet.GetCellValue(arrRow[i],"ITEM_CHG_REQ_NOTE");
				var st_req_id = $("#USR_ID").val();
				var st_req_image_key = mySheet.GetCellValue(arrRow[i],"ITEM_CHG_REQ_IMAGE_KEY");
				mySheet.SetCellValue(arrRow[i], 'CMS_REJECT_YN', "Y"); //품목재정비 Y로 
				mySheet.SetCellValue(arrRow[i], 'ITEM_CHG_REQ_ID', st_req_id);
				mySheet.SetCellValue(arrRow[i], 'ITEM_CHG_REQ_NOTE', st_req_note);				
				mySheet.SetCellValue(arrRow[i], 'ITEM_CHG_REQ_IMAGE_KEY', st_req_image_key);
			}
			kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqItemChgReq.do" , "SELECTED" );
		}else if(g_confirm_type == "imageCopy"){ //이미지복사
			mySheet.SetColProperty("ATOS_END_DATE2",{KeyField:false});
			mySheet.SetColProperty("CATEG_PATH",{KeyField:false});
			mySheet.SetColProperty("SG_NAME",{KeyField:false});
			mySheet.SetColProperty("DB_CLEAN",{KeyField:false});
			mySheet.SetColProperty("ITEM_MAKE_TYPE",{KeyField:false});
			
			kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqDbCleansingImageCopy.do" , "SELECTED" );
		}else if(g_confirm_type == "cleansingCopy"){ //클랜징복사
			mySheet.SetColProperty("ATOS_END_DATE2",{KeyField:false});
			mySheet.SetColProperty("CATEG_PATH",{KeyField:false});
			mySheet.SetColProperty("SG_NAME",{KeyField:false});
//			mySheet.SetColProperty("DB_CLEAN",{KeyField:false});
			mySheet.SetColProperty("ITEM_MAKE_TYPE",{KeyField:false});
			
			kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqDbCleansingCopy.do" , "SELECTED" );
		}
	}
	
	// ajax 공통 호출후 성공시 처리 함수
	function kepAjaxSuccess(pMethod , response){
		if(pMethod == "DQCAT"){
			// response.categ_row_no1 = 매치율 1순위 리턴값만 사용 (ex response.categ_row_no5 = 5순위 리턴값)
			var totRow = mySheet.RowCount();
			var categ_row_no = response.categ_row_no1;
			var choice_type = response.choice_type1; // 선택구분(DQCAT01: 자동추천, DQCAT02 : 추천팝업, OFFCATE : 수동)
			
			mySheet.SetCellValue(categ_row_no, "CATEG_PATH", response.categPath1);
			mySheet.SetCellValue(categ_row_no, "CMS_CATEG_ID", response.cmsCategId1);
			mySheet.SetCellValue(categ_row_no, "SG_ID", response.sgId1);
			mySheet.SetCellValue(categ_row_no, "SG_NAME", response.sgName1);
			mySheet.SetCellValue(categ_row_no, "CATEGORY_CHOICE_TYPE", response.choice_type1);
			if(choice_type == "DQCAT01"){
				mySheet.SetCellValue(categ_row_no, "CATEGORY_CHOICE_TYPE_NM", "자동추천");	
			}
			
			for(var i=1; i<=totRow;i++){
				mySheet.SetToolTipText(i, "SG_NAME", mySheet.GetCellValue(i, "SG_ID"));
			}		
		
        }
		else if(pMethod == "saveMasterMpRqDelyArea"){ //납품가능지역 저장 성공 후
			var row_no = $("#dely_row").val();
			mySheet.SetCellValue(row_no, "DELY_AREA_IMG", "/resources/images/icon.gif");
		}
		
		/* 그리드 모두		
		var totRow = mySheet.RowCount();
		var categ_row_no = response.categ_row_no0;

		for(var i=1; i<=totRow;i++){
			if(mySheet.GetCellValue(i,"CATEG_PATH") == ""){
				mySheet.SetCellValue(categ_row_no, 'CATEG_PATH', response.category0);
			}
		}
		*/
		/*
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");
		var categ_row_no = response.categ_row_no0;
		for (var i=0; i<arrRow.length; i++){
			mySheet.SetCellValue(categ_row_no, 'CATEG_PATH', response.category0);
		}
		*/
	}

	/**
	 * ajax 공통 호출후 에러시 처리 함수
	 */
	function  kepAjaxError(pMethod , response) {
		alert("오류가 발생하였습니다."); 
	} 
	
	function removeArrayDuplicate(array) {  
		var a = [];
		for(var i=0; i <array.length; i++){  
		
		if(typeof a[array[i]] == "undefined")  
			a[array[i]] = 1;  
		}  
		array.length = 0;  
		for(var i in a)  
			array[array.length] = i;  
		
		return array;  
	} 

	function mySheet_OnLoadData(DATA) {
		mt = new Date();
		return DATA;
	}
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

    	if (msg != "") {
			alert(msg);
		}

		for(var i=1; i<=totRow;i++){
			
			mySheet.SetCellValue(i, 'PICKUP_AGENT_NAME', '미지정');

			// 3021_02
			if (mySheet.GetCellValue(i, "BUYER") == "KRDHIM0001" && mySheet.GetCellValue(i, "REMARK_URL") != ""){
				mySheet.SetCellFontColor(i,"REMARK_URL","#0100FF");
			}
			
			//SLOGIC-BEGIN(P04-4031-06)
			if (mySheet.GetCellValue(i, "BUYER") == "KRSSAN0025"){ // 협력사 공개 여부
				mySheet.SetCellEditable(i,"AGENT_OPEN_FLAG",0);
			}
			
			if($("#st_rpa_yn").val() == "N"){ // RPA 아이디 아니면 이하 모두 적용{
				mySheet.SetCellEditable(i,"RPA_MARKET_PRICE",0);
			}
			
			//SLOGIC-END
			mySheet.SetToolTipText(i, "SG_NAME", mySheet.GetCellValue(i, "SG_ID"));
		}
		doAction("categ");
	}
	function mySheet_OnMouseMove(Button, Shift, X, Y) { 
		var row = mySheet.MouseRow();
		var cellFont = mySheet.GetCellFontColor(row, "REMARK_URL");
		if(mySheet.GetCellValue(row, "BUYER") == "KRDHIM0001" && cellFont == "#0100ff") {
			mySheet.SetDataLinkMouse("REMARK_URL", true);
		} else {
			mySheet.SetDataLinkMouse("REMARK_URL", false);
		}
	}
	function mySheet_OnSaveEnd(code, msg, stCode) {
		mySheet.SetColProperty("ATOS_END_DATE2",{KeyField:true});
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
	
	function mySheet_OnReadyExcelDown(frm) {
		frm.removeAttribute("encoding");
		frm.removeAttribute("enctype");
		frm.submit();
	}
	
	//페이지 인덱스 눌렀을 경우 조회
	function pageSearch(param){
		//조회
		current_page = param.page;
		kepSearch(document.searchCondition ,  mySheet , "/mprq/searchMasterMpRqReqQuotReceiptList.do?page="+current_page , pagingMode );
	}

	
	//팝업함수호출
	function doPop(str) {
		popupSel = str;
		
		switch (str) {
			case "buyer_newsourcing":
				openSearchPopup("/common/mprq/newSourcingBuyerListPop.do", "", "500,350,no");
				break;
			case "buyerMulti": // 고객사 M
				openSearchPopup("/none/showCommonNoNeBuyerChoiceMultiPop.do","?search_opt=2&disable_yn=Y",'1000,500,no');
				popupSel = "buyerMulti";
				break;
			case "buyercatalog": // 고객사카탈로그조회
				openSearchPopup("/coco/showCommonCoCoCatalogAlterPop.do", "", "1000,600,no");
				break;
			case "sg_info"://SG정보
				openSearchPopup("/mprq/showMasterMpRqSgChoicePop.do", "", "500,500,no");
				break;
			case "manual": // 매뉴얼 호출
				openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=0000007zk&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
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
			case "itemChgSend": // 품목정비제출
				var selectedGrid = mySheet.FindCheckedRow("SELECTED");
				var arrRow     = selectedGrid.split("|");
				// 선택된 항목 유무 체크
				if (selectedGrid.length == 0) {
					alert("선택된 항목이 없습니다.");
					return;
				}
				for(var i=0; i<arrRow.length;i++){
					var st_cms_reject_flag = mySheet.GetCellValue(arrRow[i],"CMS_REJECT_YN");
					if(st_cms_reject_flag != "Y"){
						alert("품목정비 요청 먼저 해주시기 바랍니다.["+arrRow[i]+"번째]");
						return;
					}
					
					var st_item_md_date_flag = mySheet.GetCellValue(arrRow[i],"ITEM_MD_DATE");
					if(st_item_md_date_flag != ""){
						alert("품목정비 제출 된 상태입니다.["+arrRow[i]+"번째]");
						return;
					}
				}
				openSearchPopup("/common/remarkReturn2Pop.do", "?st_gubun=ITEMCHG", "600,230,no");
				break;
			case "sgDReq": // SG지정 재요청
				var selectedGrid = mySheet.FindCheckedRow("SELECTED");
				var arrRow     = selectedGrid.split("|");
				// 선택된 항목 유무 체크
				if (selectedGrid.length == 0) {
					alert("선택된 항목이 없습니다.");
					return;
				}
				for(var i=0; i<arrRow.length;i++){
					var st_sg_d_flag = mySheet.GetCellValue(arrRow[i],"SG_D_FLAG");
					if(st_sg_d_flag == "미지정"){
						alert("SG 미지정 된 건 이므로 처리 불가능 합니다.["+arrRow[i]+"번째]");
						return;
					}
					
					var st_sg_d_revision = mySheet.GetCellValue(arrRow[i],"SG_D_REVISION");
					if(st_sg_d_revision > "2"){
						alert("SG지정 재요청은 2회까지만 가능합니다.["+arrRow[i]+"번째]");
						return;
					}
				}
				openSearchPopup("/common/remarkReturn2Pop.do", "?st_gubun=SGDCHG", "600,230,no");
				break;
		}
	}
	// 헤더 더블클릭시 복사
	function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
		if ( Row > 0 ) return;
		
		var checkRows = mySheet.FindCheckedRow("SELECTED");
		if (checkRows.length == 0){
			alert("복사할 행을 선택하여 주십시요.");
			return;
		}
		var arrRow = checkRows.split("|");
		
		if (mySheet.ColSaveName(Col) == "ATOS_END_DATE2"){ // 견적마감일
			var value1 = mySheet.GetCellValue(arrRow[0], "ATOS_END_DATE2");
			var value2 = mySheet.GetCellValue(arrRow[0], "ATOS_END_DATE");
			var value3 = mySheet.GetCellValue(arrRow[0], "ATOS_END_TIME");
			var value4 = mySheet.GetCellValue(arrRow[0], "ATOS_END_TIME2");
			if(kepIsValueNull(value1)){
				alert("복사할 견적마감일을 선택하여 주십시요.");
				return;
			}
			for(var idx=0; idx<arrRow.length; idx++){
				mySheet.SetCellValue(arrRow[idx], "ATOS_END_DATE2", value1);
				mySheet.SetCellValue(arrRow[idx], "ATOS_END_DATE", value2);
				mySheet.SetCellValue(arrRow[idx], "ATOS_END_TIME", value3);
				mySheet.SetCellValue(arrRow[idx], "ATOS_END_TIME2", value4);
			}
		} else if (mySheet.ColSaveName(Col) == "CATEG_PATH"){ // 표준카테고리
			var value1 = mySheet.GetCellValue(arrRow[0], "SG_ID");
			var value2 = mySheet.GetCellValue(arrRow[0], "SG_NAME");
			var value3 = mySheet.GetCellValue(arrRow[0], "CMS_CATEG_ID");
			var value4 = mySheet.GetCellValue(arrRow[0], "CATEG_PATH");
 			
			if(kepIsValueNull(value1)){
				alert("복사할 표준카테고리를 선택하여 주십시요.");
				return;
			}
			for(var idx=1; idx<arrRow.length; idx++){
	 			mySheet.SetCellValue(arrRow[idx], 'SG_ID', value1);
	 			mySheet.SetCellValue(arrRow[idx], 'SG_NAME', value2);
	 			mySheet.SetCellValue(arrRow[idx], 'CMS_CATEG_ID', value3);
	 			mySheet.SetCellValue(arrRow[idx], 'CATEG_PATH', value4);
	 			mySheet.SetCellValue(arrRow[idx], 'CATEGORY_CHOICE_TYPE', 'OFFCATE');
	 			mySheet.SetCellValue(arrRow[idx], 'CATEGORY_CHOICE_TYPE_NM', '수동선택');
			}
		} else if (mySheet.ColSaveName(Col) == "BTOA_REMARK_IMG"){ // 비고
			var value1 = mySheet.GetCellValue(arrRow[0], "ATOS_REMARK");
			if(kepIsValueNull(value1)){
				alert("복사할 비고를 입력하여 주십시요.");
				return;
			}
			for(var idx=0; idx<arrRow.length; idx++){
				mySheet.SetCellValue(arrRow[idx], "ATOS_REMARK", value1);
				mySheet.SetCellValue(arrRow[idx], "BTOA_REMARK_IMG", (value1!="")? remarkOn : remarkOff);
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
		} else if (mySheet.ColSaveName(Col) == "ORIGIN_NAME"){ // 원산지
			var value1 = mySheet.GetCellValue(arrRow[0], "ORIGIN_CODE");
			var value2 = mySheet.GetCellValue(arrRow[0], "ORIGIN_NAME");
			if(kepIsValueNull(value1)){
				alert("복사할 원산지를 선택하여 주십시요.");
				return;
			}
			for(var idx=0; idx<arrRow.length; idx++){
				mySheet.SetCellValue(arrRow[idx], "ORIGIN_CODE", value1);
				mySheet.SetCellValue(arrRow[idx], "ORIGIN_NAME", value2);
			}
		} else if (mySheet.ColSaveName(Col) == "MAKER_NAME"){ // 제조사
			var value1 = mySheet.GetCellValue(arrRow[0], "MAKER_CODE");
			var value2 = mySheet.GetCellValue(arrRow[0], "MAKER_NAME");
			if(kepIsValueNull(value1)){
				alert("복사할 제조사를 선택하여 주십시요.");
				return;
			}
			for(var idx=0; idx<arrRow.length; idx++){
				mySheet.SetCellValue(arrRow[idx], "MAKER_CODE", value1);
				mySheet.SetCellValue(arrRow[idx], "MAKER_NAME", value2);
			}
		} else if (mySheet.ColSaveName(Col) == "RFQ_IMG_FLAG"){ // 이미지 필수
			var value1 = mySheet.GetCellValue(arrRow[0], "RFQ_IMG_FLAG");
			if(kepIsValueNull(value1)){
				alert("복사할 이미지 필수(S)를 선택하여 주십시요.");
				return;
			}
			for(var idx=0; idx<arrRow.length; idx++){
				mySheet.SetCellValue(arrRow[idx], "RFQ_IMG_FLAG", value1);
			}
		} else if (mySheet.ColSaveName(Col) == "ITEM_MAKE_TYPE"){ // 품목구분
			var value1 = mySheet.GetCellValue(arrRow[0], "ITEM_MAKE_TYPE");
			for(var idx=0; idx<arrRow.length; idx++){
				mySheet.SetCellValue(arrRow[idx], "ITEM_MAKE_TYPE", value1);
			}
		} else if (mySheet.ColSaveName(Col) == "JOB_TRANSFER_NM"){ // 견적담당자
			var value1 = mySheet.GetCellValue(arrRow[0], "JOB_TRANSFER_ID");
			var value2 = mySheet.GetCellValue(arrRow[0], "JOB_TRANSFER_NM");
			for(var idx=0; idx<arrRow.length; idx++){
				mySheet.SetCellValue(arrRow[idx], "JOB_TRANSFER_ID", value1);
				mySheet.SetCellValue(arrRow[idx], "JOB_TRANSFER_NM", value2);
			}
		} else if (mySheet.ColSaveName(Col) == "PICKUP_AGENT_NAME"){ //  협력사지정
			var value1 = mySheet.GetCellValue(arrRow[0], "PICKUP_AGENT_ID");
			var value2 = mySheet.GetCellValue(arrRow[0], "PICKUP_AGENT_NAME");
			var value3 = mySheet.GetCellValue(arrRow[0], "PICKUP_AGENT_ID2");
			var value4 = mySheet.GetCellValue(arrRow[0], "PICKUP_AGENT_DSS2");
			for(var idx=1; idx<arrRow.length; idx++){
				mySheet.SetCellValue(arrRow[idx], "PICKUP_AGENT_ID", value1);
				mySheet.SetCellValue(arrRow[idx], "PICKUP_AGENT_NAME", value2);
				mySheet.SetCellValue(arrRow[idx], "PICKUP_AGENT_ID2", value3);
				mySheet.SetCellValue(arrRow[idx], "PICKUP_AGENT_DSS", value4);
				mySheet.SetCellValue(arrRow[idx], "PICKUP_AGENT_DSS2", value4);
			}
		} else if (mySheet.ColSaveName(Col) == "ITEM_CHG_REQ_TYPE"){ // 정비구분
			var value1 = mySheet.GetCellValue(arrRow[0], "ITEM_CHG_REQ_TYPE");
			for(var idx=0; idx<arrRow.length; idx++){
				mySheet.SetCellValue(arrRow[idx], "ITEM_CHG_REQ_TYPE", value1);
			}
		} else if (mySheet.ColSaveName(Col) == "ITEM_CHG_REQ_NOTE"){ // 품목정비요청사유
			var value1 = mySheet.GetCellValue(arrRow[0], "ITEM_CHG_REQ_NOTE");
			if(kepIsValueNull(value1)){
				alert("복사할 요청사유를 입력하여 주십시요.");
				return;
			}
			for(var idx=0; idx<arrRow.length; idx++){
				mySheet.SetCellValue(arrRow[idx], "ITEM_CHG_REQ_NOTE", value1);
				
			}
		}
	}
	//그리드 셀클릭 이벤트
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if ( Row  < 1) return;
		var column = mySheet.ColSaveName(mySheet.GetSelectCol());
		grbRow = Row;		//현재 Row를 전역변수에 셋팅
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var remarkUrl = mySheet.GetCellValue(Row, "REMARK_URL");
		var maker_code = mySheet.GetCellValue(Row,"MAKER_CODE"); // 제조사ID
		var maker_name = mySheet.GetCellValue(Row,"MAKER_NAME"); // 제조사명
		var cms_categ_id = mySheet.GetCellValue(Row,"CMS_CATEG_ID"); // 카테고리ID
		var quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
		var quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
		var revision = mySheet.GetCellValue(Row, "REVISION");
		var origin_code = mySheet.GetCellValue(Row,"ORIGIN_CODE"); // 원산지코드
		var choice_type = mySheet.GetCellValue(Row,"CATEGORY_CHOICE_TYPE"); // 선택구분(DQCAT01: 자동추천, DQCAT02 : 추천팝업, OFFCATE : 수동)
		var st_sg_id = mySheet.GetCellValue(Row,"SG_ID"); // SG_ID
		
 		if (column == "QUOTATION_NO" ){ //  견적번호 
			popupSel = "quotationReDetailPop";
			openSearchPopup("/common/mprq/quotationReDetailPop.do", '?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_revision='+revision, "1020,500,no");
 		} else if (column == "BUYER_NAME" ){ //  고객사 
 			//고객사 정보 팝업 호출
			openSearchPopup("/mdct/showMasterMdCtBuyerJoinAlterRequestApprovalPop.do", "?com_code="+buyer,  "900,700,no");
 		} else if (column == "INIT_YN" ){ //  견적초기화이력 
			popupSel = "quotationInitListPop";
 			if (mySheet.GetCellValue(Row,"INIT_YN") == "/resources/images/icon_19.png") {
				openSearchPopup("/common/mprq/quotationInitListPop.do", '?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_quotation_seq='+quotation_seq, "980,400,no");
	 		}
		
 		} else if (column == "REMARK_URL" ){ // 품목코드
 			// 3021_02
 			if (buyer == "KRDHIM0001" && remarkUrl != ""){
	 			getRemarkUrL(remarkUrl);
 			} 
 		} else if (column == "BTOA_USER_NAME" ){ // 요청자
 			var ID = mySheet.GetCellValue(Row,"BTOA_USER_ID");
 			if (ID == ""){
 				alert("요청자ID 정보가 없습니다.");
 				return;
 			}
 			openSearchPopup("/common/userDisplayPop.do", '?user_id='+ID, "800,500,no");
			
 		} else if (column == "CATEG_PATH" ){ // 표준카테고리
 			var st_sg_req_yn = mySheet.GetCellValue(Row,"SG_REQ_YN"); // SG지정 통제 여부
 			
 			if($("#st_authority").val() == "Y"){ //소싱팀일 경우
 				alert("권한이 없습니다");
 				return;
 			}
 		
 			// 구매팀+전담은 SG 미지정건을 임의로 변경하지 않는다. (표준카테고리 선택으로도 SG가 변경되니)
 			var st_sg_d_flag = mySheet.GetCellValue(Row,"SG_D_FLAG"); // SG 지정 여부
 			if( $('#st_sg_req_dept_yn').val() == "Y" && st_sg_req_yn == "Y"){ //SG 지정 체크 대상(DSM + 일반 사업팀)
				if(st_sg_d_flag != "지정"){
					alert("SG 미지정 된 건 이므로 불가능합니다.");
					return;
				}
			}
 			
 			var desc = mySheet.GetCellValue(Row,"DESCRIPTION"); // 품목명
 			var spec = mySheet.GetCellValue(Row,"SPECIFICATION"); // 규격
 			var maker = mySheet.GetCellValue(Row,"MAKER_NAME"); // 제조사명
 			var model = mySheet.GetCellValue(Row,"MAKER_PART_NO"); // 모델번호
 			
			var popupUrl = "";
 			
			// 일반고객사+전담고객사 모두 SG 내에서만 선택
			if($("#st_sg_req_dept_yn").val() == "Y" && st_sg_req_yn == "Y"){
				if(st_sg_d_flag != "지정"){
					alert("SG 지정 후 표준카테고리 선택이 가능합니다.");
					return;
				}
				
 				document.categFlow.st_sg_id.value = st_sg_id;
 				popupUrl = "/mprq/showMasterMpRqKepStndrdCategorySelPop.do";
 			}else{
 				document.categFlow.st_sg_id.value = "";
 				popupUrl = "/mprq/showMasterMpRqKepStndrdCategorySelPop.do";
 				//popupUrl = "/mprq/showMasterMpRqKepStndrdCategoryRcmdPop.do";
 			}
		    document.categFlow.action = popupUrl
		    document.categFlow.target = "categ";
		    document.categFlow.method = "post";
		    
		    document.categFlow.categ_desc_flow.value = escape(desc);
		    document.categFlow.categ_spec_flow.value = escape(spec);
		    document.categFlow.categ_maker_flow.value = escape(maker);
		    document.categFlow.categ_model_flow.value = escape(model);
		    document.categFlow.st_sour_dept_yn.value = $("#st_sour_dept_yn").val();
		    document.categFlow.st_sg_req_yn.value = st_sg_req_yn;
		    
		    popupSel = "masterMpRqKepStndrdCategorySelPop";
			var new_popup = window.open('','categ','scrollbars=no,width=721,height=670,resizable=no'); // width=728,height=510
			
		    document.categFlow.submit();
		    new_popup.focus();
		    
 		} else if (column == "DB_CLEAN" ){ // DB클렌징정보입력
 			var quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO"); // 견적번호
 			var quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ"); // 견적항번
 			var revision = mySheet.GetCellValue(Row,"REVISION"); // 고객사차수
 			var description = mySheet.GetCellValue(Row,"DESCRIPTION"); // 품목명
 			var kep_specification = mySheet.GetCellValue(Row,"KEP_SPECIFICATION"); // 규격(고)
 			var specification = mySheet.GetCellValue(Row,"SPECIFICATION"); // 규격(운)
 			var unit_measure = mySheet.GetCellValue(Row,"UNIT_MEASURE"); // 단위
 			var origin_name = mySheet.GetCellValue(Row,"ORIGIN_NAME"); // 원산지명
 			var imgfile_name = mySheet.GetCellValue(Row,"IMGFILE_NAME"); // 이미지
 			var imgfile_dir = mySheet.GetCellValue(Row,"IMGFILE_DIR"); // 이미지경로
 			var item_detail_desc = mySheet.GetCellValue(Row,"ITEM_DETAIL_DESC"); // 상세설명
 			var sg_id = mySheet.GetCellValue(Row,"SG_ID"); // SG ID
 			var attb1_nm = mySheet.GetCellValue(Row,"ATTB1_NM"); // 속성1
 			var attb2_nm = mySheet.GetCellValue(Row,"ATTB2_NM"); // 속성2
 			var attb3_nm = mySheet.GetCellValue(Row,"ATTB3_NM"); // 속성3
 			var attb4_nm = mySheet.GetCellValue(Row,"ATTB4_NM"); // 속성4
 			var attb5_nm = mySheet.GetCellValue(Row,"ATTB5_NM"); // 속성5
 			var attb6_nm = mySheet.GetCellValue(Row,"ATTB6_NM"); // 속성6
 			var attb7_nm = mySheet.GetCellValue(Row,"ATTB7_NM"); // 속성7
 			var attb8_nm = mySheet.GetCellValue(Row,"ATTB8_NM"); // 속성8
 			var attb9_nm = mySheet.GetCellValue(Row,"ATTB9_NM"); // 속성9
 			var attb10_nm = mySheet.GetCellValue(Row,"ATTB10_NM"); // 속성10
 			var attb11_nm = mySheet.GetCellValue(Row,"ATTB11_NM"); // 속성11
 			var attb12_nm = mySheet.GetCellValue(Row,"ATTB12_NM"); // 속성12
 			var attb13_nm = mySheet.GetCellValue(Row,"ATTB13_NM"); // 속성13
 			var attb14_nm = mySheet.GetCellValue(Row,"ATTB14_NM"); // 속성14
 			var attb15_nm = mySheet.GetCellValue(Row,"ATTB15_NM"); // 속성15
 			var attb16_nm = mySheet.GetCellValue(Row,"ATTB16_NM"); // 속성16
 			var attb17_nm = mySheet.GetCellValue(Row,"ATTB17_NM"); // 속성17
 			var attb18_nm = mySheet.GetCellValue(Row,"ATTB18_NM"); // 속성18
 			var attb19_nm = mySheet.GetCellValue(Row,"ATTB19_NM"); // 속성19
 			var attb20_nm = mySheet.GetCellValue(Row,"ATTB20_NM"); // 속성20

 			var description_eng = mySheet.GetCellValue(Row,"DESCRIPTION_ENG"); // 품목명(영문)
 			var specification_eng = mySheet.GetCellValue(Row,"SPECIFICATION_ENG"); // 규격(영문)
 			
 			var maker_part_no = mySheet.GetCellValue(Row,"MAKER_PART_NO"); // 모델명

 			// 구매팀+전담은 SG 미지정건을 임의로 변경하지 않는다. (표준카테고리 선택으로도 SG가 변경되니)
 			var st_sg_req_yn = mySheet.GetCellValue(Row,"SG_REQ_YN"); // SG지정 통제 여부
 			var st_sg_d_flag = mySheet.GetCellValue(Row,"SG_D_FLAG"); // SG 지정 여부
 			if( $('#st_sg_req_dept_yn').val() == "Y" && st_sg_req_yn == "Y"){ //SG 지정 체크 대상(DSM + 일반 사업팀)
				if(st_sg_d_flag != "지정"){
					alert("SG 미지정 된 건 이므로 불가능합니다.");
					return;
				}
			}
 			
 			if(cms_categ_id == ""){
 				alert("표준카테고리를 선택하세요.");
 				return;
 			}
			
		    document.flow.action = "/mprq/showMasterMpRqDbStndrdProgressPop.do";
		    document.flow.target = "contFlow";
		    document.flow.method = "post";
		    document.flow.buyer_code.value = buyer;
		    document.flow.quotation_no.value = quotation_no;
		    document.flow.quotation_seq.value = quotation_seq;
		    document.flow.revision.value = revision;
		    document.flow.cms_categ_id.value = cms_categ_id;
		    document.flow.description.value = escape(description);
		    document.flow.kep_specification.value = escape(kep_specification);
		    document.flow.specification.value = escape(specification);
		    document.flow.unit_measure.value = unit_measure;
		    document.flow.maker_code.value = maker_code;
		    document.flow.maker_name.value = maker_name;
		    document.flow.origin_code.value = origin_code;
		    document.flow.origin_name.value = origin_name;
		    document.flow.imgfile_name.value = imgfile_name;
		    document.flow.imgfile_dir.value = imgfile_dir;
		    document.flow.item_detail_desc.value = item_detail_desc;
		    document.flow.sg_id.value = sg_id;
		    document.flow.attb1_nm.value = escape(attb1_nm);
		    document.flow.attb2_nm.value = escape(attb2_nm);
		    document.flow.attb3_nm.value = escape(attb3_nm);
		    document.flow.attb4_nm.value = escape(attb4_nm);
		    document.flow.attb5_nm.value = escape(attb5_nm);
		    document.flow.attb6_nm.value = escape(attb6_nm);
		    document.flow.attb7_nm.value = escape(attb7_nm);
		    document.flow.attb8_nm.value = escape(attb8_nm);
		    document.flow.attb9_nm.value = escape(attb9_nm);
		    document.flow.attb10_nm.value = escape(attb10_nm);
		    document.flow.attb11_nm.value = escape(attb11_nm);
		    document.flow.attb12_nm.value = escape(attb12_nm);
		    document.flow.attb13_nm.value = escape(attb13_nm);
		    document.flow.attb14_nm.value = escape(attb14_nm);
		    document.flow.attb15_nm.value = escape(attb15_nm);
		    document.flow.attb16_nm.value = escape(attb16_nm);
		    document.flow.attb17_nm.value = escape(attb17_nm);
		    document.flow.attb18_nm.value = escape(attb18_nm);
		    document.flow.attb19_nm.value = escape(attb19_nm);
		    document.flow.attb20_nm.value = escape(attb20_nm);
		    
		    document.flow.description_eng.value = escape(description_eng);
		    document.flow.specification_eng.value = escape(specification_eng);
		    document.flow.maker_part_no.value = escape(maker_part_no);
		    
		    popupSel = "masterMpRqDbStndrdProgressPop";
		    var new_popup = window.open('','contFlow','scrollbars=no,width=700,height=740,resizable=no');
			
		    document.flow.submit();
		    new_popup.focus();

 		} else if (column == "ATOS_END_DATE2" ){ 	// 견적마감일
 			/*견적진행구분이 사업부일경우만 진행가능. 
 			진행구분이 전략소싱팀일경우 해당 SG담당자만 입력 가능*/
 			var rqdtGbnYn = getSgInfo(Row);
 			var rqdtCategnYn = getCategInfo(Row);
 			var rqdtBuyerSgYn = getBuyerSgInfo(Row);
 			if(rqdtBuyerSgYn == "N"){
	 			if(rqdtGbnYn== "N"&&rqdtCategnYn=="Y"){
					alert("전략소싱팀 담당자 진행건이므로 협력사 견적 요청을 할수없습니다.");
					return;
	 			}
 			}
 			popupSel = "calendarHour";
 			openSearchPopup("/common/calendarAndHourPop.do",'',"300,300,no");
 			
 		} else if (column == "PICKUP_AGENT_NAME" ){ 	//협력사 지정
 			var buyer_name = mySheet.GetCellValue(Row,"BUYER_NAME");
 			var sg_id = mySheet.GetCellValue(Row,"SG_ID");
 			var sg_name = mySheet.GetCellValue(Row,"SG_NAME");
 			var atos_end_dt = mySheet.GetCellValue(Row,"ATOS_END_DATE");
 			var ag_id = mySheet.GetCellValue(Row,"AG_ID");
 			var ag_si = mySheet.GetCellValue(Row,"AG_SI");
			var multi_agent = mySheet.GetCellValue(Row,"PICKUP_AGENT_ID2");
			var multi_agent_dss = mySheet.GetCellValue(Row,"PICKUP_AGENT_DSS");
			var cms_caltlg_id = mySheet.GetCellValue(Row,"CMS_CATLG_ID");
			var dely_area = mySheet.GetCellValue(Row,"DELY_AREA");
			var assign_agent_code = mySheet.GetCellValue(Row,"ASSIGN_AGENT_CODE");
			var assign_agent_name = mySheet.GetCellValue(Row,"ASSIGN_AGENT_NAME");
			
			///DB클렌징 확인 체크 로직 추가
			/*if (mySheet.GetCellValue(Row,"CM_USER_NM") == ""){
 				alert(mySheet.GetCellValue(Row,"BUYER_ITEM_NO")+" 품목의 DB클렌징 작업을 먼저 수행하세요.");
 				return;						
			}*/
 			if (cms_categ_id == "" || sg_id == "" || maker_code == "" || origin_code == ""){
 				alert("표준카테고리와 DB클렌징 작업을 먼저 수행하세요.");
 				return;
 			}
 			//영문 품명, 규격 필수값일때 체크 로직 추가
 			if (mySheet.GetCellValue(Row,"ENG_DESC_YN")  == "Y"){
 				if(mySheet.GetCellValue(Row,"DESCRIPTION_ENG") == ""||mySheet.GetCellValue(Row,"SPECIFICATION_ENG") == ""){
 	 				alert("DB클렌징 작업 통해서 영문 품명, 규격 입력 바랍니다.");
 	 				return; 					
 				}
 			} 			
 			if (atos_end_dt == ""){
 				alert("견적마감일을 먼저 선택하세요.");
 				return;
 			}

			popupSel = "masterMpRqDssSellerSelPop";
 			// 고객사코드, 고객사명, 소싱그룹ID, 소싱그룹명, 제조사코드
 			
 			window.open('','dssFlow','scrollbars=yes,width=900,height=800,resizable=yes');
		    document.dss.action = "/mprq/showMasterMpRqDssSellerSelPop.do";
		    document.dss.target = "dssFlow";
		    document.dss.method = "post";
		    
		    document.dss.st_buyer_code.value = buyer;
		    document.dss.st_buyer_name.value = buyer_name;
		    document.dss.st_sg_id.value = sg_id;
		    document.dss.st_sg_name.value = sg_name;
		    document.dss.st_maker_code.value = maker_code;
		    document.dss.st_maker_name.value = maker_name;
		    document.dss.st_ag_id.value = ag_id;
		    document.dss.st_ag_si.value = ag_si;
		    document.dss.st_quotation_no.value = quotation_no;
		    document.dss.st_quotation_seq.value = quotation_seq;
		    document.dss.st_revision.value = revision;
		    document.dss.st_multi_agent.value = multi_agent;
		    document.dss.st_multi_agent_dss.value = multi_agent_dss;
		    document.dss.st_cms_caltlg_id.value = cms_caltlg_id;
		    document.dss.st_cms_categ_id.value = cms_categ_id;
		    document.dss.st_dely_area.value = dely_area;
		    document.dss.st_assign_agent_code.value = assign_agent_code;
		    if(assign_agent_name == "" || assign_agent_name == null){
		    	document.dss.st_assign_agent_name.value = "없음";	
		    }else{
		    	document.dss.st_assign_agent_name.value = assign_agent_name;
		    }
		    
		    document.dss.submit();

 		} else if (column == "BTOA_REMARK_IMG" ){ 
			popupSel = "remarkBtoA2";
			var btoaRemark = mySheet.GetCellValue(Row, "BTOA_REMARK");
			var atosRemark = mySheet.GetCellValue(Row, "ATOS_REMARK");
			var atoaRemark = mySheet.GetCellValue(Row, "ATOA_REMARK");
			var st_buyer = mySheet.GetCellValue(Row, "BUYER");
			var st_quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
			var st_quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
			var st_revision = mySheet.GetCellValue(Row, "REVISION");
			
			$("#st_btoa_remark").val(btoaRemark);
			$("#st_atos_remark").val(atosRemark);
			$("#st_atoa_remark").val(atoaRemark);
			$("#st_buyer").val(st_buyer);
			$("#st_quotation_no").val(st_quotation_no);
			$("#st_quotation_seq").val(st_quotation_seq);
			$("#st_revision").val(st_revision);
			
			openSearchPopupPost("/common/remarkBtoA2Pop.do",'postPopForm',"remarkBtoA2Pop","width=1000,height=450,resizable=no,scrollbars=no,top=0,left=0");
		} else if(column == "CANCEL_REMARK_IMG"){
			popupSel = "cancelRemark";
			var viewType="kepRfqCancel";
			var cancel_remark = mySheet.GetCellValue(Row, "CANCEL_REMARK");
			var cancel_remark_code = mySheet.GetCellValue(Row, "CANCEL_REMARK_CODE");
			openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType+'&cancel_remark_code='+cancel_remark_code,"500,320,no");
			
		} else if(column == "IMAGE_KEY_IMG"){
			//SLOGIC-BEGIN(P04-4029-03)
			if (buyer == "KRKORE0254"){
				var image_key = mySheet.GetCellValue(Row, "IMAGE_KEY");
				attach_popup(image_key);
			//SLOGIC-END				
			} else {
				popupSel = "fileUpload";
				var type="RFQ";
				var viewType="VI";
				var image_key=mySheet.GetCellValue(Row, "IMAGE_KEY");
				openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
			}
		} else if(column == "SELLER_IMAGE_KEY_IMG"){
			popupSel = "sellerFileUpload";
			var type="RFQ";
			var viewType="VI";
			var image_key=mySheet.GetCellValue(Row, "SELLER_IMAGE_KEY");
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		} else if (column == "ORIGIN_NAME" ){ // 원산지
			popupSel = "country";
			openSearchPopup("/common/countryCodePop.do", "", "500,500,no");
		} else if (column == "MAKER_NAME" ){ // 제조사
			popupSel = "maker";
			var st_del_name = mySheet.GetCellValue(Row, "MAKER_NAME");
			openSearchPopup("/common/agentRegMakerCodePop.do", '?st_del_name='+st_del_name+'&st_buyer_code='+buyer+'&st_ent_confirm=Y', "500,500,no");
		}  else if (column == "AGENT_NAME" ){ // 기존협력사
			openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=S&MULTI=N', '500,466,no');
			popupSel = "seller";
		}  else if (column == "ASSIGN_AGENT_NAME" ){ // 지정협력사
			var pickup_agent = mySheet.GetCellValue(Row,"PICKUP_AGENT_NAME");
			if(pickup_agent != "미지정"){
				alert("협력사지정 후에는 변경할 수 없습니다.");
				return;
			}
			openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=S&MULTI=N', '500,466,no');
			popupSel = "assign_agent_name";
		} else if (column == "ERASE_ASSIGN_AGENT" ){ // 지정협력사 삭제
			var pickup_agent = mySheet.GetCellValue(Row,"PICKUP_AGENT_NAME");
			if(pickup_agent != "미지정"){
				alert("협력사지정 후에는 변경할 수 없습니다.");
				return;
			}
			mySheet.SetCellValue(Row, 'ASSIGN_AGENT_CODE', '');
			mySheet.SetCellValue(Row, 'ASSIGN_AGENT_NAME', '');
		} else if (column == "CMS_CATLG_ID" ){
			var st_cms_catlg_id = mySheet.GetCellValue(Row,"CMS_CATLG_ID"); //표준카탈로그
			if(st_cms_catlg_id == ""){
				alert("매핑된 표준카탈로그코드가 없습니다.");
				return ;
			}
			var st_cms_categ_id = mySheet.GetCellValue(Row,"CMS_CATEG_ID"); //표준카테고리
			openSearchPopup("/mdcm/showMasterMdCmGoodsInfoDetailPop.do", '?st_cms_categ_id='+st_cms_categ_id+'&st_cms_catlg_id='+st_cms_catlg_id, "800,700,no");// 품목정보 상세보기
		} else if (column == "CMS_CATLG_IMG" ){
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
		    document.catlgFlow.catlg_buyer.value = buyer;
		    document.catlgFlow.catlg_quotation_no.value = quotation_no;
		    document.catlgFlow.catlg_quotation_seq.value = quotation_seq;
		    document.catlgFlow.catlg_revision.value = revision;
		    
		    document.catlgFlow.submit();
		    new_popup.focus();
		} else if (column == "ERASE_CMS_CATLG_ID" ){ // 표준카탈로그 삭제
			var st_cms_catlg_id = mySheet.GetCellValue(Row,"CMS_CATLG_ID");
			if(st_cms_catlg_id == ""){
				alert("매핑된 표준카탈로그코드가 없습니다.");
				return;
			}
			mySheet.SetCellValue(Row, 'SELECTED', 1);
			mySheet.SetCellValue(Row, 'CMS_CATLG_ID', '');
			mySheet.SetCellValue(Row, 'CATALOG_CHOICE_TYPE', '');
			mySheet.SetCellValue(Row, "CATALOG_CHOICE_TYPE_NM", '');
			
			//그리드 필수값 제외
			mySheet.SetColProperty("ATOS_END_DATE2",{KeyField:false});
			mySheet.SetColProperty("CATEG_PATH",{KeyField:false});
			mySheet.SetColProperty("SG_NAME",{KeyField:false});
			mySheet.SetColProperty("DB_CLEAN",{KeyField:false});
			mySheet.SetColProperty("ITEM_MAKE_TYPE",{KeyField:false});
			
			kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqReqQuotReceipt.do" , "SELECTED" );
		} else if (column == "CMS_REJECT_YN" ){ 
			var st_department = "<%=st_user_dept%>";
			var cms_reject_yn_2 = mySheet.GetCellValue(Row, "CMS_REJECT_YN_2");
				if(st_department !="093" && st_department !="095"){
					alert("품목재정비 변경은 전략소싱팀만 가능합니다.");
					mySheet.SetCellValue(Row, 'CMS_REJECT_YN', cms_reject_yn_2);
					return;
				}
		} else if (column == "ATOA_REMARK" ){ 
			popupSel = "remarkAtoAPop";
			var st_buyer = mySheet.GetCellValue(Row, "BUYER");
			var st_quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
			var st_quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
			var st_revision = mySheet.GetCellValue(Row, "REVISION");
			var st_atoa_remark = mySheet.GetCellValue(Row, "ATOA_REMARK");
			openSearchPopup("/common/remarkAtoAPop.do",'?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_atoa_remark='+st_atoa_remark,"500,200,no");// 운영사비고
		} else if(column == "ITEM_GUBUN_IMG"){ //품목코드 확인.
			popupSel = "byitPop"; 
			var buyer = mySheet.GetCellValue(Row, "BUYER");
			var quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
			var quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
			var revision = mySheet.GetCellValue(Row, "REVISION");
			openSearchPopup("/coco/showCommonCoCoSamsungByitPop.do", '?p_buyer='+buyer+'&p_quotation_no='+quotation_no+'&p_quotation_seq='+quotation_seq+'&p_revision='+revision, "900,600,no");
		} else 	if (column == "JOB_TRANSFER_NM" ){ //  견적담당자 
			popupSel = "kepUserSelectAllPop";
			openSearchPopup("/common/kepUserSelectAllPop.do", '', "500,485,no");
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

 			return;
 		} else if (column == "DELY_AREA_IMG" ){
 			popupSel = "getBuyerDelyAreaInfoPop";
 			var st_dely_area = mySheet.GetCellValue(Row,"DELY_AREA");
 			openSearchPopup('/common/getBuyerDelyAreaInfoPop.do','?st_dely_area='+st_dely_area,'520,270,no');

 			return;
 		} else if (column == "SG_NAME" ){ // SG선택 화면
 			if($("#st_sour_supl_yn").val()=="Y"){
 				popupSel = "sg_name";
 				openSearchPopup("/mprq/showMasterMpRqSgChoicePop.do", "", "500,500,no");
 			}else{
 				alert("SG선택 권한이 없습니다.");
 				return;
 			}
 		} else if (column == "ITEM_CHG_REQ_DATE" ){ //  품목정비 이력팝업
			popupSel = "itemChgRegDatePop";
 			var st_buyer = mySheet.GetCellValue(Row,"BUYER");
 			var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
 			var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
 			var st_revision = mySheet.GetCellValue(Row,"REVISION");
			openSearchPopup("/mprq/showMasterMpRqItemMdReqHistPop.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "840,300,no");
 		}  else if (column == "ITEM_MD_DATE" ){ //  품목정비 이력팝업
			popupSel = "itemChgRegDatePop";
 			var st_buyer = mySheet.GetCellValue(Row,"BUYER");
 			var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
 			var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
 			var st_revision = mySheet.GetCellValue(Row,"REVISION");
			openSearchPopup("/mprq/showMasterMpRqItemMdReqHistPop.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "840,300,no");
 		} else if(column == "NOTE_MNG_IMG" ){ //특이사항 입력
 			var st_buyer = mySheet.GetCellValue(Row,"BUYER");
 			var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
 			var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
 			var st_revision = mySheet.GetCellValue(Row,"REVISION");
 			openSearchPopup("/mprq/showMasterMpRqQutationRemark.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision, "850,350,no");
 		} else if(column == "ITEM_CHG_REQ_IMAGE_KEY_IMG"){
			popupSel = "itemChgReqfileUpload";
			var type="RFQ";
			var viewType="VI";
			var st_cms_reject_yn = mySheet.GetCellValue(Row,"CMS_REJECT_YN");
			var st_req_user_id = mySheet.GetCellValue(Row,"ITEM_CHG_REQ_ID");
			var image_key=mySheet.GetCellValue(Row, "ITEM_CHG_REQ_IMAGE_KEY");
			var item_md_date = mySheet.GetCellValue(Row,"ITEM_MD_DATE");
			
			// 정비요청 이력 있고, 정비제출일시 비었고 --> 정비요청 중
			if(st_cms_reject_yn == "Y" && item_md_date == ""){
				viewType = "R";
			}
			
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		} else if (column == "SG_D_DATE" ){ // SG지정이력팝업
			popupSel = "sgDatePop";
 			var st_buyer = mySheet.GetCellValue(Row,"BUYER");
 			var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
 			var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
 			var st_revision = mySheet.GetCellValue(Row,"REVISION");

 			var st_popup_url = "/mprq/showMasterMpRqSgDHistPop.do";
			var st_popup_param = "st_buyer@@"+st_buyer+"^||^st_quotation_no@@"+st_quotation_no+"^||^st_quotation_seq@@"+st_quotation_seq+"^||^st_revision@@"+st_revision;
			var st_popup_option = "840,300,no";
			openSearchPopupAppendPost("sgDatePopForm",st_popup_url,st_popup_param,st_popup_option);
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
	        var loc = "http://safety.koreab2b.com/file/view.wu?fileUploadId=fileUploadPop&bizType=BOARD&fileUuid="+image_key+"&callback=setFileImage&callbackParam=0%2CCSTMR_ATTCH_FILE_NO_IMAGE%2CCSTMR_ATTCH_FILE_NO&removeBtnUnvisible=false";
	        window.open(loc,'attach_popup', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	} 
	
	//콜백함수(파일명은 모두 동일)
   function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
									,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
									,value21,value22,value23,value24,value25,value26,value27,value28,value29,value30
									,value31,value32,value33,value34){
		//팝업 조회후 해당 항목에 값을 셋팅
		if (popupSel == "buyer_newsourcing") {	// 고객사
			$("#st_buyer_code").val(value1);
			$("#st_buyer_name").val(kepMultiName(value2,"@"));
		} else if (popupSel == "buyerMulti") {	// 다중 고객사
			$("#st_buyer_code").val(value1);
			$("#st_buyer_name").val(kepMultiName(value2,"@"));
		} else if (popupSel == "masterMpRqKepStndrdCategorySelPop") {	// 표준카테고리
 			mySheet.SetCellValue(grbRow, 'SG_ID', value1);
 			mySheet.SetCellValue(grbRow, 'SG_NAME', value2);
 			mySheet.SetCellValue(grbRow, 'CMS_CATEG_ID', value3);
 			mySheet.SetCellValue(grbRow, 'CATEG_PATH', value4);
 			mySheet.SetCellValue(grbRow, 'CATEGORY_CHOICE_TYPE', value6);
 			if(value6 == "DQCAT02"){
				mySheet.SetCellValue(grbRow, "CATEGORY_CHOICE_TYPE_NM", "추천팝업");	
			}else if(value6 == "OFFCATE"){
				mySheet.SetCellValue(grbRow, "CATEGORY_CHOICE_TYPE_NM", "수동선택");	
			}
		} else if (popupSel =="masterMpRqDbStndrdProgressPop"){
			// 품목명, 규격(운), 단위, 제조사ID, 제조사명, 원산지코드, 원산지명, 속성1-20 값, 상세설명, 이미지정보
			
 			mySheet.SetCellValue(grbRow, 'DESCRIPTION', value1);
 			mySheet.SetCellValue(grbRow, 'SPECIFICATION', value2);
 			mySheet.SetCellValue(grbRow, 'UNIT_MEASURE', value3);
 			mySheet.SetCellValue(grbRow, 'MAKER_CODE', value4);
 			mySheet.SetCellValue(grbRow, 'MAKER_NAME', value5);
 			mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value6);
 			mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value7);
 			mySheet.SetCellValue(grbRow, 'ATTB1_NM', unescape(value8));
 			mySheet.SetCellValue(grbRow, 'ATTB2_NM', unescape(value9));
 			mySheet.SetCellValue(grbRow, 'ATTB3_NM', unescape(value10));
 			mySheet.SetCellValue(grbRow, 'ATTB4_NM', unescape(value11));
 			mySheet.SetCellValue(grbRow, 'ATTB5_NM', unescape(value12));
 			mySheet.SetCellValue(grbRow, 'ATTB6_NM', unescape(value13));
 			mySheet.SetCellValue(grbRow, 'ATTB7_NM', unescape(value14));
 			mySheet.SetCellValue(grbRow, 'ATTB8_NM', unescape(value15));
 			mySheet.SetCellValue(grbRow, 'ATTB9_NM', unescape(value16));
 			mySheet.SetCellValue(grbRow, 'ATTB10_NM', unescape(value17));
 			mySheet.SetCellValue(grbRow, 'ATTB11_NM', unescape(value18));
 			mySheet.SetCellValue(grbRow, 'ATTB12_NM', unescape(value19));
 			mySheet.SetCellValue(grbRow, 'ATTB13_NM', unescape(value20));
 			mySheet.SetCellValue(grbRow, 'ATTB14_NM', unescape(value21));
 			mySheet.SetCellValue(grbRow, 'ATTB15_NM', unescape(value22));
 			mySheet.SetCellValue(grbRow, 'ATTB16_NM', unescape(value23));
 			mySheet.SetCellValue(grbRow, 'ATTB17_NM', unescape(value24));
 			mySheet.SetCellValue(grbRow, 'ATTB18_NM', unescape(value25));
 			mySheet.SetCellValue(grbRow, 'ATTB19_NM', unescape(value26));
 			mySheet.SetCellValue(grbRow, 'ATTB20_NM', unescape(value27));
 			mySheet.SetCellValue(grbRow, 'ITEM_DETAIL_DESC', value28);
 			mySheet.SetCellValue(grbRow, 'IMGFILE_NAME', value29);
 			mySheet.SetCellValue(grbRow, 'IMGFILE_DIR', value30);
 			mySheet.SetCellValue(grbRow, 'DESCRIPTION_ENG', value31);
 			mySheet.SetCellValue(grbRow, 'SPECIFICATION_ENG', value32);
 			mySheet.SetCellValue(grbRow, 'CM_USER_NM', value33);
 			mySheet.SetCellValue(grbRow, 'MAKER_PART_NO', value34);
		} else if (popupSel == "masterMpRqDssSellerSelPop") {	// 추천협력사
			if (grbRow != ""){
				mySheet.SetCellValue(grbRow, 'PICKUP_AGENT_ID', value1);
	 			mySheet.SetCellValue(grbRow, 'PICKUP_AGENT_NAME', value2);
	 			mySheet.SetCellValue(grbRow, 'PICKUP_AGENT_ID2', value3);
	 			mySheet.SetCellValue(grbRow, 'PICKUP_AGENT_DSS', value4);
	 			mySheet.SetCellValue(grbRow, 'PICKUP_AGENT_DSS2', value5);
			} else {
				var selectedGrid = mySheet.FindCheckedRow("SELECTED");
				var arrRow     = selectedGrid.split("|");
				for (var i=0; i<arrRow.length; i++){
					mySheet.SetCellValue(arrRow[i], 'PICKUP_AGENT_ID', value1);
		 			mySheet.SetCellValue(arrRow[i], 'PICKUP_AGENT_NAME', value2);
		 			mySheet.SetCellValue(arrRow[i], 'PICKUP_AGENT_ID2', value3);
		 			mySheet.SetCellValue(arrRow[i], 'PICKUP_AGENT_DSS', value4);
		 			mySheet.SetCellValue(arrRow[i], 'PICKUP_AGENT_DSS2', value5);
				}
			}
		} else if(popupSel == "remarkBtoA2") {	//고객사 비고운영사 비고
 			mySheet.SetCellValue(grbRow, 'ATOS_REMARK', value2);
 			mySheet.SetCellValue(grbRow, 'ATOA_REMARK', value3);
 			mySheet.SetCellValue(grbRow, 'BTOA_REMARK_IMG', (value2!="")? remarkOn : remarkOff);
		} else if(popupSel == "cancelRemark") {	//견적 취소
 			mySheet.SetCellValue(grbRow, 'CANCEL_REMARK', value1);
 			mySheet.SetCellValue(grbRow, 'CANCEL_REMARK_IMG', (value2!="")? remarkOn : remarkOff);
 			mySheet.SetCellValue(grbRow, 'CANCEL_REMARK_CODE', value2);
		} else if(popupSel == "fileUpload") {	//파일 첨부(B)
 			mySheet.SetCellValue(grbRow, 'IMAGE_KEY', value1);
 			mySheet.SetCellValue(grbRow, 'IMAGE_KEY_IMG', (value2=='on')? diskOn : diskOff);
		} else if(popupSel == "sellerFileUpload") {	//파일 첨부(ATOS)
 			mySheet.SetCellValue(grbRow, 'SELLER_IMAGE_KEY', value1);
 			mySheet.SetCellValue(grbRow, 'SELLER_IMAGE_KEY_IMG', (value2=='on')? diskOn : diskOff);
		} else if(popupSel == "calendarHour") {	//견적마감일
 			mySheet.SetCellValue(grbRow, 'ATOS_END_DATE2', value1.substr(0,4) + "/" + value1.substr(4,2) + "/" + value1.substr(6,2));
 			mySheet.SetCellValue(grbRow, 'ATOS_END_DATE', value1);
 			mySheet.SetCellValue(grbRow, 'ATOS_END_TIME', value2);
 			mySheet.SetCellValue(grbRow, 'ATOS_END_TIME2', value2.substr(0,2) + ":" + value2.substr(2,2) + ":" + value2.substr(4,2));
		} else if (popupSel == "country"){ // 원산지
			mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value1);
			mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value3);
		} else if (popupSel == "maker"){ // 제조사
			mySheet.SetCellValue(grbRow, 'MAKER_CODE', value1);
			mySheet.SetCellValue(grbRow, 'MAKER_NAME', value2);
			mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value3);
			mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value4);
			mySheet.SetCellValue(grbRow, 'MAKER_NOT_REASON', (value5 == null || value5 == undefined) ? '' : value5);
		} else if (popupSel == "seller"){ // 기존협력사
			var strAgentName= value2+"("+value1+")";
			mySheet.SetCellValue(grbRow, 'AGENT_NAME', strAgentName);
		} else if (popupSel == "assign_agent_name"){ // 지정협력사
			var strAssignAgentName= value2+"("+value1+")";
			mySheet.SetCellValue(grbRow, 'ASSIGN_AGENT_CODE', value1);
			mySheet.SetCellValue(grbRow, 'ASSIGN_AGENT_NAME', strAssignAgentName);
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
				mySheet.SetCellValue(value2, "CATALOG_CHOICE_TYPE_NM", "추천팝업");
			}else if(value3 == "OFFCATE"){
				mySheet.SetCellValue(value2, 'CMS_CATLG_ID', value1);
				mySheet.SetCellValue(value2, 'CATALOG_CHOICE_TYPE', value3);
				mySheet.SetCellValue(value2, "CATALOG_CHOICE_TYPE_NM", "수동선택");	
			}	
		} else if(popupSel=="sg_info"){
			$("#st_c_sg_id").val(value1);
			$("#st_c_sg_nm").val(value2);
		}else if(popupSel == "remarkAtoAPop") {	//운영사 비고
			mySheet.SetCellValue(grbRow, 'ATOA_REMARK', value1);
		}else if(popupSel == "byitPop") {	//카탈로그 품목코드변경
			mySheet.SetCellValue(grbRow, 'BUYER_ITEM_NO', value1);
			mySheet.SetCellValue(grbRow, 'CMS_CATLG_ID', value2);
		} else if (popupSel == "kepUserSelectAllPop"){ //견적담당자
			mySheet.SetCellValue(grbRow, 'JOB_TRANSFER_ID', value1);
			mySheet.SetCellValue(grbRow, 'JOB_TRANSFER_NM', value2);
		} else if (popupSel == "getBuyerDelyAreaInfoPop"){ //고객사납품가능지역
			mySheet.SetCellValue(grbRow, 'DELY_AREA', value1);
			
			var st_dely_area = value1;
			var st_buyer = mySheet.GetCellValue(grbRow, "BUYER");
			var st_quotation_no = mySheet.GetCellValue(grbRow, "QUOTATION_NO");
			var st_quotation_seq = mySheet.GetCellValue(grbRow, "QUOTATION_SEQ");
			var st_revision = mySheet.GetCellValue(grbRow, "REVISION");
			
			$("#dely_dely_area").val(st_dely_area);
			$("#dely_buyer").val(st_buyer);
			$("#dely_quotation_no").val(st_quotation_no);
			$("#dely_quotation_seq").val(st_quotation_seq);
			$("#dely_revision").val(st_revision);
			$("#dely_row").val(grbRow);
			
			kepAjaxFormCall("/mprq/saveMasterMpRqDelyArea.do","DelyAreaChoice", "saveMasterMpRqDelyArea");
		}else if(popupSel == "sg_name") {	//SG 선택 팝업
 			mySheet.SetCellValue(grbRow, 'SG_ID', value1);
 			mySheet.SetCellValue(grbRow, 'SG_NAME', value2);
 			mySheet.SetCellValue(grbRow, 'CMS_CATEG_ID', "");
 			mySheet.SetCellValue(grbRow, 'CATEG_PATH', "");
		} else if(popupSel == "itemChgReqfileUpload") {	//품목정비 첨부
 			mySheet.SetCellValue(grbRow, 'ITEM_CHG_REQ_IMAGE_KEY', value1);
 			mySheet.SetCellValue(grbRow, 'ITEM_CHG_REQ_IMAGE_KEY_IMG', (value2=='on')? diskOn : diskOff);
		}
		
		grbRow="";	//초기화
   }
   
	// 견적지연사유 팝업 리턴
	function setDelayPopupReturn(){
		mySheet.SetCellValue(grbRow, 'DELAY_REASON_IMG', 9);
	}
   
   function getRemarkUrL(remark_url) {
		var loc = "http://ez-van.doosaninfracore.co.kr/data/APPENDIX/"+remark_url;
	    window.open(loc, "doosaninfracore", "left=0,top=0");
	}

   function mySheet_OnDownFinish(downloadType, result) {
		loader_obj("N");
	}
   function getSgInfo(row) {  
	   var strBuyer = "KRKORE0001";
	   var strType = "SG";
		var srtID =$("#USR_ID").val();
		var strCtNo =mySheet.GetCellValue(row, "CMS_CATEG_ID");
		var rtnData = "";
		$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: "/mdcm/getSgInfo.do",
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: { param1: strBuyer,param2: strType,param3:srtID,param4:strCtNo},
		     async : false,
		     success:function( response ) {  		    	  
		    	 	 		    	  
	    	 	if (response.data.length > 0){
	 		    	  for (var i=0; i<response.data.length; i++){ 
	 		    		  
	 		    		rtnData = $.trim(eval("response.data["+i+"].DATA_YN")); 
		 		      }	 		    
	    		  }
			      },
			 error:function( response ) {  		    	   
		    	 alert("오류발생하였습니다.");
			      }
	    });  
		return rtnData;
	}
   function getCategInfo(row) {  
	   var strBuyer = "KRKORE0001";
	   var strType = "SG";
		var strCtNo =mySheet.GetCellValue(row, "CMS_CATEG_ID");
		var rtnData = "";
		$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: "/mdcm/getCategInfo.do",
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: { param1: strBuyer,param2: strType,param3:strCtNo},
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
   
   
    //운영비고일괄 입력
   function setRemarkPopupReturn(val){
   	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
   	var arrRow     = selectedGrid.split("|");
   	for (var i=0; i<arrRow.length; i++){
   		mySheet.SetCellValue(arrRow[i],"ADMIN_REMARK",val);
   	}
   	//그리드 필수값 제외
	mySheet.SetColProperty("ATOS_END_DATE2",{KeyField:false});
	mySheet.SetColProperty("CATEG_PATH",{KeyField:false});
	mySheet.SetColProperty("SG_NAME",{KeyField:false});
	mySheet.SetColProperty("DB_CLEAN",{KeyField:false});
	mySheet.SetColProperty("ITEM_MAKE_TYPE",{KeyField:false});
   	kepSave(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqReqQuotAdminRemark.do" , "SELECTED" );
   }
   //품목정비제출 저장
   function setItemChgPopupReturn(val){
	   
   	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
   	var arrRow     = selectedGrid.split("|");
   	var st_admin_remark = "[품목정비제출] "+val;
   	for (var i=0; i<arrRow.length; i++){
   		mySheet.SetCellValue(arrRow[i],"ADMIN_REMARK",st_admin_remark);
   	}
   	//그리드 필수값 제외
	mySheet.SetColProperty("ATOS_END_DATE2",{KeyField:false});
	mySheet.SetColProperty("CATEG_PATH",{KeyField:false});
	mySheet.SetColProperty("SG_NAME",{KeyField:false});
	mySheet.SetColProperty("DB_CLEAN",{KeyField:false});
	mySheet.SetColProperty("ITEM_MAKE_TYPE",{KeyField:false});
	kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqItmCheSend.do" , "SELECTED" );	
   }

   // SG지정 재요청
   function setSgDChgPopupReturn(val){
	   
   	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
   	var arrRow     = selectedGrid.split("|");
   	var st_admin_remark = val;
   	for (var i=0; i<arrRow.length; i++){
   		mySheet.SetCellValue(arrRow[i],"ADMIN_REMARK",st_admin_remark);
   	}
   	//그리드 필수값 제외
	mySheet.SetColProperty("ATOS_END_DATE2",{KeyField:false});
	mySheet.SetColProperty("CATEG_PATH",{KeyField:false});
	mySheet.SetColProperty("SG_NAME",{KeyField:false});
	mySheet.SetColProperty("DB_CLEAN",{KeyField:false});
	mySheet.SetColProperty("ITEM_MAKE_TYPE",{KeyField:false});
	kepSave(document.searchCondition ,  mySheet , "/mprq/updateMasterMpRqSgDReq.do" , "SELECTED" );	
   }
</script>
<title>견적의뢰 접수</title>
</head>

<body onload="kep_onload_view()">
<!--내용 시작-->
			<!--버튼영역-->
	       	<div id="searchBtnA"  >
	       		<h3>견적의뢰 접수</h3>
				<span class="btn_search"><a href="javaScript:doAction('search');">조회</a></span>
				<span class="btn_reset"><a href="javaScript:doAction('reload');">초기화</a></span>
				<span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
	   		</div>        		        	
            <!--조회영역-->
            <form name = "postPopForm" method="post">
            <input type="hidden" name="st_buyer"  id="st_buyer" value ="">
            <input type="hidden" name="st_quotation_no"  id="st_quotation_no" value ="">
            <input type="hidden" name="st_quotation_seq"  id="st_quotation_seq" value ="">
            <input type="hidden" name="st_revision"  id="st_revision" value ="">
           <input type="hidden" name="st_btoa_remark" id="st_btoa_remark"  value="">
            <input type="hidden" name="st_atos_remark"  id="st_atos_remark" value="">
            <input type="hidden" name="st_atoa_remark"  id="st_atoa_remark" value ="">
            </form>
        	<form name = "searchCondition" method = "post" onsubmit="return false" >
            <div id="cont_searchA">
 			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag"  value="1">
            <input type="hidden" id="USR_ID" name="USR_ID"  value="${sessionInfo.userId}">
            <input type="hidden" id="st_userNameLoc"  name="st_userNameLoc" value="${sessionInfo.userNameLoc}">
            <input type="hidden" name="st_doc_type"  id="st_doc_type" value ="">
            <input type="hidden" name="st_exits_item"  id="st_exits_item" value ="">
            <input type="hidden" name="st_req_item"  id="st_req_item" value ="">
            <input type="hidden" name="st_authority"  id="st_authority" value ="<%=st_authority%>">
            <input type="hidden" name="st_sour_dept_yn"  id="st_sour_dept_yn" value ="<%=st_sour_dept_yn%>">
            <input type="hidden" name="st_sour_supl_yn"  id="st_sour_supl_yn" value ="<%=st_sour_supl_yn%>">
            <input type="hidden" name="st_sg_req_dept_yn"  id="st_sg_req_dept_yn" value ="<%=st_sg_req_dept_yn%>">
            <input type="hidden" name="st_user_id"  id="st_user_id" value ="<%=st_user_id%>">
            <input type="hidden" name="st_sg_type"  id="st_sg_type" value ="">
            <input type="hidden" name="st_rpa_yn"  id="st_rpa_yn" value ="<%=st_rpa_yn%>">
            <input type="hidden" name="st_smart_dept_yn"  id="st_smart_dept_yn" value ="<%=st_smart_dept_yn%>">
            <input type="hidden" name="st_mro_dept_yn"  id="st_mro_dept_yn" value ="<%=st_mro_dept_yn%>">
            
            	<table  class="cont_t_list01" >
						<caption>견적의뢰 접수</caption>
						<colgroup>
							<col width="10%" />
							<col width="15%" />
							<col width="8%" />
							<col width="15%" />
							<col width="8%" />
	                        <col width="19%" />
	                        <col width="7%" />
	                        <col width="18%" />
						</colgroup>
						
						<tbody>
						<tr>
							<td>
								<label for="b_code" class="hidden">기간선택</label>
					  			<select name = "st_date_type" id="st_date_type" style="height:20px">
						      		<option value="REQ" selected="selected">견적의뢰일</option>
									<option value="RES" >회신요청일</option>
	                           </select>
							</td>
							
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								-
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
							</td>
							
							<td><font color="#FF6600">*</font>고객사</td>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:50%" value="" readonly onclick="javascript:doPop('buyerMulti');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer_newsourcing');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							
							<td>견적번호</td>
							<td>
								<input type="text" class="input_type_text" id="st_quotation_no" name="st_quotation_no" style="width:80%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
							</td>
						</tr>
						<tr>
							<td>신규/기등록 여부</td>
							<td>
								<select name = "st_buyer_item_no_new" id="st_buyer_item_no_new" style="width:40%;height:20px;">
					  				<option value = "ALL" selected>전체</option>
					  				<option value = "S" >신규</option>
					  				<option value = "K">기등록</option>
	                           </select>
							</td>
							
							<td>품목코드</td>
							<td>
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:80%;" value="" onkeydown="kepEnter()">
							</td>
							
							<td>품목명/규격</td>
							<td>
								<input type="text" class="input_type_text" id="st_desc_spec" name="st_desc_spec" style="width:80%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
							</td>
							
							<td>관리번호</td>
							<td>
								<input type="text" class="input_type_text" id="st_ref_no" name="st_ref_no" style="width:80%;" value="" onkeydown="kepEnter()">
							</td>
						</tr>
						<tr>
<%if(st_sour_supl_yn.equals("Y")){%>
							<td>사업팀</td>
							<td>
								<select id="st_sg_dept" name="st_sg_dept" style="width:90%;">
					  				<option value = "">전체</option>
					  				<option value = "131" <%=(st_sg_dept.equals("131") ? "selected" : "")%>>MRO사업 1팀</option>
					  				<option value = "132" <%=(st_sg_dept.equals("132") ? "selected" : "")%>>MRO사업 2팀</option>
					  				<option value = "133" <%=(st_sg_dept.equals("133") ? "selected" : "")%>>MRO사업 3팀</option>
					  				<option value = "149" <%=(st_sg_dept.equals("149") ? "selected" : "")%>>Bio Lab사업팀</option>
					  				<option value = "131A" <%=(st_sg_dept.equals("131A") ? "selected" : "")%>>1팀+Bio+2팀</option>
					  				<option value = "131B" <%=(st_sg_dept.equals("131B") ? "selected" : "")%>>1팀+Bio+3팀</option>
					  				<option value = "131C" <%=(st_sg_dept.equals("131C") ? "selected" : "")%>>1팀+Bio</option>
					  				<option value = "132A" <%=(st_sg_dept.equals("132A") ? "selected" : "")%>>2팀+3팀</option>
								</select>
								<select id="st_plant_user_id" name="st_plant_user_id" style="display:none;"></select>
							</td>
<%}else{%>
							<td>PLANT 담당자</td>
							<td>
								<select id="st_sg_dept" name="st_sg_dept" style="display:none;">
					  				<option value = "">전체</option>
					  				<option value = "131" <%=(st_sg_dept.equals("131") ? "selected" : "")%>>수도권사업팀</option>
					  				<option value = "132" <%=(st_sg_dept.equals("132") ? "selected" : "")%>>중부사업팀</option>
					  				<option value = "133" <%=(st_sg_dept.equals("133") ? "selected" : "")%>>남부사업팀</option>
					  				<option value = "149" <%=(st_sg_dept.equals("149") ? "selected" : "")%>>Bio Lab사업팀</option>
					  				<option value = "131A" <%=(st_sg_dept.equals("131A") ? "selected" : "")%>>수도권+중부+Bio</option>
					  				<option value = "131B" <%=(st_sg_dept.equals("131B") ? "selected" : "")%>>수도권+남부+Bio</option>
					  				<option value = "132A" <%=(st_sg_dept.equals("132A") ? "selected" : "")%>>중부+남부</option>
								</select>
								<select id="st_plant_user_id" name="st_plant_user_id" style="width:90%;height:20px"></select>
							</td>
<%}%>
							<td>견적담당자</td>
							<td>
								<select id="st_job_transfer_id" name="st_job_transfer_id" style="width:80%;height:20px"></select>
							</td>
							
							<td>제조사</td>
							<td>
								<input type="text" class="input_type_text" id="st_maker_name" name="st_maker_name" style="width:80%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
							</td>
							
							<td>요청자</td>
							<td>
								<input type="text" class="input_type_text" id="st_btoa_user_name" name="st_btoa_user_name" style="width:80%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
							</td>
						</tr>
						<tr>
							<td>SG</td>
							<td>
								<input type="text" id="st_c_sg_nm" name="st_c_sg_nm" class="input_type_text" style="width:50%;" value=""  readonly onclick="javascript:doPop('sg_info');">
								<input type="hidden" name="st_c_sg_id" id="st_c_sg_id" style="width:80%" value="">
								<a href="javascript:doPop('sg_info');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_c_sg_id','st_c_sg_nm');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							
							<td>SG지정</td>
							<td>
								<select id="st_sg_d_falg" name="st_sg_d_falg" style="width:80%;">
					  				<option value = "">전체</option>
					  				<option value = "Y" <%=(st_sg_req_dept_yn.equals("Y") ? "selected" : "")%>>지정</option>
					  				<option value = "N" <%=(st_sour_supl_yn.equals("Y") ? "selected" : "")%>>미지정(재요청제외)</option>
					  				<option value = "R">재요청</option>
								</select>
							</td>
							 
							<td>품목정비 여부</td>
							<td colspan="3">
					  			<select name = "st_cms_reject_yn" id="st_cms_reject_yn" style="width:15%;height:20px;">
					  				<option value = "" selected>전체</option>
					  				<option value = "Y" >Y</option>
					  				<option value = "N">N</option>
	                           </select>
	                           <input type="checkbox"  class="Noborder" name="st_recheckbox" id="st_recheckbox" >&nbsp;긴급건&nbsp;
	                           <input type="checkbox"  class="Noborder" name="st_exits_itemcheck" id="st_exits_itemcheck" <%if ("N".equals(st_rpa_yn)) {%>checked<%}%>>&nbsp;품목정비 미제출 제외&nbsp;
	                           <input type="checkbox"  class="Noborder" name="st_req_itemcheck" id="st_req_itemcheck">&nbsp;품목정비 요청건만 조회&nbsp;
							</td>
						</tr>
						<tr> 
							
						</tr>
					</tbody>
				</table>
				
            </div>
            	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
                	<label for="b_no02" class="hidden">정렬개수선택</label>
						<select id="onepagerow"  name="onepagerow" style="width: 70px;" >
						<option value="10" selected>10건</option>
						<option value="20">20건</option>
						<option value="30">30건</option>
						<option value="40">40건</option>
						<option value="50">50건</option>
						<option value="100">100건</option>
						<option value="200">200건</option>
					</select>
					&nbsp;<img src="/resources/images/icon_g.gif"> 품목정비 미요청 및 제출완료
					&nbsp;<img src="/resources/images/icon_r.gif"> 품목정비 요청 후 미제출
					&nbsp;<img src="/resources/images/icon_19.png"> 초기화이력
					&nbsp;<img src="/resources/images/rd_pin.gif"> 기등록 품목(※ 견적 진행시 기등록 품목은 계약정보만 반영 됩니다.)
				</span>
				<br>
					
          	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "354px");
				</script>
			</div>
			<div class="paging" id="pageindex"></div>
			
		</form>
			<!--버튼영역-->
               <div class="btnArea">
		          	<span class="fl">
						<span class="btn_04 mr04" ><a href="javascript:doAction('downexcel');">엑셀다운로드</a></span>
						<span class="btn_07 mr04"><a href="javascript:doPop('buyercatalog');">고객사카탈로그 조회</a></span>
						<span class="btn_04 mr04"><a href="javascript:doAction('imageCopy');">이미지복사</a></span>
						<span class="btn_04 mr04"><a href="javascript:doAction('cleansingCopy');">DB클랜징복사</a></span>
					</span>
					
					<span class="fr">
					<%  //소싱지원 권한 SG지정, 지정취소 버튼 활성화 기능.
						if(st_sour_supl_yn.equals("Y")){
					%>
						<span class="btn_04 mr04"><a href="javascript:doAction('sg_set');">SG지정</a></span>
						<!--<span class="btn_04 mr04"><a href="javascript:doAction('sg_cancle','N');">SG지정취소</a></span>--><!-- SG지정 취소 기능 제거 2024.05.03 HSJ -->
						<span class="btn_06 mr04"><a href="javascript:doAction('item_chg_req');">품목정비요청</a></span>
						<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
					<%
						}else{
					%>
						<span class="btn_06 mr04"><a href="javascript:doAction('item_chg_req');">품목정비요청</a></span>
						<span class="btn_04 mr04"><a href="javascript:doPop('sgDReq');">SG지정 재요청</a></span>
						<span class="btn_06 mr04"><a href="javascript:doPop('itemChgSend');">품목정비제출</a></span>
						<span class="btn_06 mr04"><a href="javascript:doAction('dss');">일괄협력사지정</a></span>
						<span class="btn_06"><a href="javascript:doPop('remark');">운영특이사항 입력</a></span>						
						<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
						<span class="btn_02 mr04"><a href="javascript:doAction('AgentOrder');">견적요청</a></span>
					
					<%  //구매팀 견적취소 삭제 - 조직개편 2025.08.18
							if(st_sour_dept_yn.equals("N")){
					%>
						<span class="btn_02"><a href="javascript:doAction('del');">견적취소</a></span>
					<%
							}
						}
					%>
					</span>
			 </div>
<form name="flow" method="post" action ="">
	<input type="hidden" name="buyer_code" id="buyer_code" value="">
	<input type="hidden" name="quotation_no" id="quotation_no" value="">
	<input type="hidden" name="quotation_seq" id="quotation_seq" value="">
	<input type="hidden" name="revision" id="revision" value="">
	<input type="hidden" name="cms_categ_id" id="cms_categ_id" value="">
	<input type="hidden" name="description" id="description" value="">
	<input type="hidden" name="kep_specification" id="kep_specification" value="">
	<input type="hidden" name="specification" id="specification" value="">
	<input type="hidden" name="unit_measure" id="unit_measure" value="">
	<input type="hidden" name="maker_code" id="maker_code" value="">
	<input type="hidden" name="maker_name" id="maker_name" value="">
	<input type="hidden" name="origin_code" id="origin_code" value="">
	<input type="hidden" name="origin_name" id="origin_name" value="">
	<input type="hidden" name="imgfile_name" id="imgfile_name" value="">
	<input type="hidden" name="imgfile_dir" id="imgfile_dir" value="">
	<input type="hidden" name="item_detail_desc" id="item_detail_desc" value="">
	<input type="hidden" name="sg_id" id="sg_id" value="">
	<input type="hidden" name="attb1_nm" id="attb1_nm" value="">
	<input type="hidden" name="attb2_nm" id="attb2_nm" value="">
	<input type="hidden" name="attb3_nm" id="attb3_nm" value="">
	<input type="hidden" name="attb4_nm" id="attb4_nm" value="">
	<input type="hidden" name="attb5_nm" id="attb5_nm" value="">
	<input type="hidden" name="attb6_nm" id="attb6_nm" value="">
	<input type="hidden" name="attb7_nm" id="attb7_nm" value="">
	<input type="hidden" name="attb8_nm" id="attb8_nm" value="">
	<input type="hidden" name="attb9_nm" id="attb9_nm" value="">
	<input type="hidden" name="attb10_nm" id="attb10_nm" value="">
	<input type="hidden" name="attb11_nm" id="attb11_nm" value="">
	<input type="hidden" name="attb12_nm" id="attb12_nm" value="">
	<input type="hidden" name="attb13_nm" id="attb13_nm" value="">
	<input type="hidden" name="attb14_nm" id="attb14_nm" value="">
	<input type="hidden" name="attb15_nm" id="attb15_nm" value="">
	<input type="hidden" name="attb16_nm" id="attb16_nm" value="">
	<input type="hidden" name="attb17_nm" id="attb17_nm" value="">
	<input type="hidden" name="attb18_nm" id="attb18_nm" value="">
	<input type="hidden" name="attb19_nm" id="attb19_nm" value="">
	<input type="hidden" name="attb20_nm" id="attb20_nm" value="">
	<input type="hidden" name="description_eng" id="description_eng" value="">
	<input type="hidden" name="specification_eng" id="specification_eng" value="">
	<input type="hidden" name="maker_part_no" id="maker_part_no" value="">
</form>	
<form name="dss" id="dss" method="post" action ="">
	<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
    <input type="hidden" name="st_buyer_name" id="st_buyer_name" value="">
    <input type="hidden" name="st_sg_id" id="st_sg_id" value="">
    <input type="hidden" name="st_sg_name" id="st_sg_name" value="">
    <input type="hidden" name="st_maker_code" id="st_maker_code" value="">
    <input type="hidden" name="st_maker_name" id="st_maker_name" value="">
    <input type="hidden" name="st_ag_id" id="st_ag_id" value="">
    <input type="hidden" name="st_ag_si" id="st_ag_si" value="">
    <input type="hidden" name="st_quotation_no" id="st_quotation_no" value="">
    <input type="hidden" name="st_quotation_seq" id="st_quotation_seq" value="">
    <input type="hidden" name="st_revision" id="st_revision" value="">
    <input type="hidden" name="st_multi_agent" id="st_multi_agent" value="">
    <input type="hidden" name="st_multi_agent_dss" id="st_multi_agent_dss" value="">
    <input type="hidden" name="st_cms_caltlg_id" id="st_cms_caltlg_id" value="">
    <input type="hidden" name="st_cms_categ_id" id="st_cms_categ_id" value="">
    <input type="hidden" name="st_dely_area" id="st_dely_area" value="">
    <input type="hidden" name="st_assign_agent_code" id="st_assign_agent_code" value="">
    <input type="hidden" name="st_assign_agent_name" id="st_assign_agent_name" value="">    
</form>
<form name="categForm" id="categForm" method="post" action ="">
	<input type="hidden" name="categ_target_rate" id="categ_target_rate" value="60">
	<input type="hidden" name="categ_target_count" id="categ_target_count" value="1">
	<input type="hidden" name="categ_row_no" id="categ_row_no" value="">
    <input type="hidden" name="categ_desc" id="categ_desc" value="">
    <input type="hidden" name="categ_spec" id="categ_spec" value="">
    <input type="hidden" name="categ_maker" id="categ_maker" value="">
    <input type="hidden" name="categ_model" id="categ_model" value="">
    <input type="hidden" name="categ_desc_flag" id="categ_desc_flag" value="true">
    <input type="hidden" name="categ_spec_flag" id="categ_spec_flag" value="true">
    <input type="hidden" name="categ_maker_flag" id="categ_maker_flag" value="true">
    <input type="hidden" name="categ_model_flag" id="categ_model_flag" value="false">
</form>
<form name="categFlow" id="categFlow" method="post" action ="">
    <input type="hidden" name="categ_desc_flow" id="categ_desc_flow" value="">
    <input type="hidden" name="categ_spec_flow" id="categ_spec_flow" value="">
    <input type="hidden" name="categ_maker_flow" id="categ_maker_flow" value="">
    <input type="hidden" name="categ_model_flow" id="categ_model_flow" value="">
    <input type="hidden" name="st_sour_dept_yn" id="st_sour_dept_yn" value="">
    <input type="hidden" name="st_sg_req_yn" id="st_sg_req_yn" value="">
    <input type="hidden" name="st_sg_id" id="st_sg_id" value="">
</form>
<form name="catlgForm" id="catlgForm" method="post" action ="">
	<input type="hidden" name="catlg_target_rate" id="catlg_target_rate" value="60">
	<input type="hidden" name="catlg_target_count" id="catlg_target_count" value="1">
	<input type="hidden" name="catlg_row_no" id="catlg_row_no" value="">
    <input type="hidden" name="catlg_desc" id="catlg_desc" value="">
    <input type="hidden" name="catlg_spec" id="catlg_spec" value="">
    <input type="hidden" name="catlg_maker" id="catlg_maker" value="">
    <input type="hidden" name="catlg_model" id="catlg_model" value="">
    <input type="hidden" name="catlg_desc_flag" id="catlg_desc_flag" value="true">
    <input type="hidden" name="catlg_spec_flag" id="catlg_spec_flag" value="true">
    <input type="hidden" name="catlg_maker_flag" id="catlg_maker_flag" value="true">
    <input type="hidden" name="catlg_model_flag" id="catlg_model_flag" value="false">
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
<form name="DelyAreaChoice" id="DelyAreaChoice" method="post" >
	 <input type="hidden" name="dely_dely_area" id="dely_dely_area"  value="">
	 <input type="hidden" name="dely_buyer" id="dely_buyer"  value=""> 
	 <input type="hidden" name="dely_quotation_no" id="dely_quotation_no"  value=""> 
	 <input type="hidden" name="dely_quotation_seq" id="dely_quotation_seq"  value=""> 
	 <input type="hidden" name="dely_revision" id="dely_revision"  value="">
	 <input type="hidden" name="dely_row" id="dely_row"  value="">  
</form>
<!--내용 종료-->	                 
</body>
</html>
