<%--
**********************************************
* 메뉴 : 견적관리 > 고객사 견적제출
* 화면 : 고객사 견적제출 
* 기능 : 고객사견적제출 버튼을 클릭하면 견적제출전 최종 상세정보를 확인하고 고객사견적제출 처리를 한다
* 프로그램 ID : PG_04_M_007_10
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-07-01
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>
<%
@SuppressWarnings (value="unchecked")
String buyer = (String) request.getParameter("st_buyer");

//p04404105 품명규격 영문 필수 고객사 SLOGIC 20171016 by HSJ
boolean p04404105 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4041-05");

//고객사 단위 사용 특수로직.
boolean p04405501 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4055-01");


//고객사견적제출 비고 표기
String getCodeQSRMText = CommonUtil.getCode2TextReturn("QSRM",buyer,"KRKORE0001","TEXT1");

//DSM 대상자 기준
String st_sour_dsm_yn = "";
String st_user_id = _sessionInfo.getUserId();
boolean st_sour_dsm = CommonUtil.getCodeCheckReturn("SOURDSM",st_user_id);
if(st_sour_dsm == true){
	st_sour_dsm_yn = "Y";
}else{
	st_sour_dsm_yn = "N";
}
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var productGbn = KepSheetComboData("M132","SEL");
var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var duplRegChk = "N"; // 중복 견적제출 방지용


function KepSheetComboCod2(queryId,gubun, type, buyer){
    var t = "";
    var c = ""; 
    var o = false;
    var st_queryId = queryId == "" ? "common.getUnitMeasureInfo" : queryId; 
	if (gubun == "SEL"){
		 t =  t + "선택";
		 c = c + "";
	}else if (gubun == "ALL"){
		t =  t + "전체";
		c = c + "";
	}else if (gubun == "SPACE"){
		t =  t + "";
		c = c + "";
	}else{
		o = true;
	}		
		$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: "/common/ajaxQueryIdCombo.do",
		      data: { QUERYID: st_queryId , TYPE : type, COM_CODE : buyer, BUYER : buyer},
		     async : false,
		     success:function( response ) {  		    	 
 		    	 if (response.data.length > 0){
	 		    	  for (var i=0; i<response.data.length; i++){ 
	 		    		 if ( o ) {
	 		    			 t += $.trim(response.data[i].TEXT1); // 쿼리 고정
	 		    			 c += $.trim(response.data[i].CODE); // 쿼리 고정
	 		    			 o = false;
	 		    		 } else {
	 		    			 t += $.trim("|"+response.data[i].TEXT1); // 쿼리 고정
	 		    			 c += $.trim("|"+response.data[i].CODE); // 쿼리 고정
	 		    		 }
		 		      }	 		    	   
 		    	  }
			      },
			 error:function( response ) {  		    	   
		    	 alert("오류발생하였습니다.");
			      }
	    });  
		
    var result = {}; 	 
    result.ComboCode = c.substring(0);
    result.ComboText = t.substring(0);
    return result;
   }


// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var cb_tax_type = KepSheetComboData("TX17","");
    var tax_type = {ComboCode: cb_tax_type.ComboCode, ComboText: cb_tax_type.ComboText};
    
	var initsheet = {};
	initsheet.HeaderMode = {			Sort : 0,			ColMove : 1,			ColResize : 1		};
	initsheet.Cols = [ 
						 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
							,{ Align:"Center",	Width:40,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사",	SaveName:"BUYER"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적번호",	SaveName:"QUOTATION_NO"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"순번",	SaveName:"QUOTATION_SEQ"}
							,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"차수",	SaveName:"REVISION"}
							,{ Align:"Center",	Width:80,	ImgWidth:50, Edit:false,		Type:"Image",	Header:"이미지",	SaveName:"IMG"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목구분",	SaveName:"BUYER_ITEM_NO_STATUS"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"계약서번호",	SaveName:"CONTRACT_NO", BackColor:"${optColor}"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서순번",	SaveName:"CONTRACT_SEQ"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"카테고리",	SaveName:"BUYER_CATEG_NAME", BackColor:"${optColor}"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"카테고리",	SaveName:"BUYER_CATEG_CODE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드(B)",	SaveName:"BUYER_ITEM_NO"}
							,{ Align:"Center",	Width:100,	Edit:true,	EditLen:20,	Hidden:false,	Type:"Text",	Header:"품목코드(S)",	SaveName:"ITEM_NO", BackColor:"${optColor}"}
							,{ Align:"Center",	Width:100,	Edit:true,	EditLen:20,	Hidden:false,	Type:"Text",	Header:"ITEM NO",	SaveName:"CQDT_ITEM_NO", BackColor:"${optColor}"}
							,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"품목명",	SaveName:"ORG_DESCRIPTION"}
							,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	ToolTip:1,	Header:"품목명",	SaveName:"DESCRIPTION"}
							,{ Align:"Left",	Width:200,	Edit:false,	EditLen:300,	Hidden:true,	Type:"Text",	Header:"규격",	SaveName:"ORG_SPECIFICATION"}
							,{ Align:"Left",	Width:200,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",	ToolTip:1,	Header:"규격",	SaveName:"SPECIFICATION"}
							,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	ToolTip:1,	Header:"품목명(영문)",	SaveName:"DESCRIPTION_ENG"}
							,{ Align:"Left",	Width:200,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",	ToolTip:1,	Header:"규격(영문)",	SaveName:"SPECIFICATION_ENG"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_CODE"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NAME"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_CODE"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Combo",	Header:"단위",	SaveName:"UNIT_MEASURE"}
							,{ Align:"Center",	Width:70,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"모델번호",	SaveName:"MAKER_PART_NO", BackColor:"${optColor}"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사 품목명",	SaveName:"CMS_DESCRIPTION"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사 규격",	SaveName:"CMS_SPECIFICATION"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사 제조사",	SaveName:"CMS_MAKER_NAME"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사 원산지",	SaveName:"CMS_ORIGIN_NAME"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사 단위",	SaveName:"CMS_UNIT_MEASURE"}
							,{ Align:"Center",	Width:85,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사 모델번호",	SaveName:"CMS_MAKER_PART_NO"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사",	SaveName:"AGENT"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"지정협력사",	SaveName:"ASSIGN_AGENT_CODE"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PLANT",	SaveName:"PLANT"}							
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"PLANT",	SaveName:"PLANT_NAME"}
							,{ Align:"Center",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"납품가능지역",	SaveName:"SELLER_AREA"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"물류협력사",	SaveName:"INIT_WAREHOUSE_NAME"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"거래유형",	SaveName:"INIT_PROCESS_TYPE"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"거래유형",	SaveName:"INIT_PROCESS_NAME"}
							,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사 모델번호",	SaveName:"ORIGN_NAME"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"적용구분",	SaveName:"INIT_BELOW_COMORG_CODE"}
							,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"적용구분",	SaveName:"INIT_BELOW_COMORG_NAME"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"담당팀",	SaveName:"TEAM"}
							,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}", 	Header:"요청단가",	SaveName:"BUYER_TARGET_PRICE"}
							,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}", 	Header:"목표단가",	SaveName:"ADMIN_TARGET_PRICE"}
							,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}", 	Header:"매출단가",	SaveName:"ATOB_UNIT_PRICE"}
							,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}", 	Header:"매입단가",	SaveName:"STOA_LIST_PRICE"}
							,{ Align:"Right",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}", 	Header:"시장단가",	SaveName:"MARKET_PRICE", BackColor:"${optColor}"}
							,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	 Format:"${qtyFormat}", 	Header:"조달일수",	SaveName:"LEAD_TIME"}
							,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float",  Format:"${qtyFormat}", 	Header:"수량",	SaveName:"ITEM_QTY"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ORG_CODE",	SaveName:"ORG_CODE"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PM_FLAG",	SaveName:"PM_FLAG"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"OPM_FLAG",	SaveName:"OPM_FLAG"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"RATE_FLAG",	SaveName:"RATE_FLAG"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AGENT_OPEN_FLAG",	SaveName:"AGENT_OPEN_FLAG"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ATOS_END_DATE",	SaveName:"ATOS_END_DATE"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ATOS_END_TIME",	SaveName:"ATOS_END_TIME"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ATOB_REMARK",	SaveName:"ATOB_REMARK"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SELLER_IMAGE_KEY",	SaveName:"SELLER_IMAGE_KEY"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CMS_MAKER_CODE",	SaveName:"CMS_MAKER_CODE"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CMS_ORIGIN_CODE",	SaveName:"CMS_ORIGIN_CODE"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CMS_CATLG_ID",	SaveName:"CMS_CATLG_ID"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"INIT_WAREHOUSE_CODE",	SaveName:"INIT_WAREHOUSE_CODE"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"INIT_WAREHOUSE_NAME",	SaveName:"INIT_WAREHOUSE_NAME"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ORIGIN_AGENT",	SaveName:"ORIGIN_AGENT"}
							,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"true",	 	Header:"매익율",	SaveName:"KEP_RATE"}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"true",	 	Header:"노/역마진사유",	SaveName:"MARGIN_RE_CODE"}
							,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"true",	 	Header:"노/역마진사유",	SaveName:"MARGIN_RE_NAME"}							
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"IMAGE_KEY",	SaveName:"IMAGE_KEY"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ITEM_DETAIL_DESC",	SaveName:"ITEM_DETAIL_DESC"}
							,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	ToolTip:1,	Header:"품의사유",	SaveName:"PM_REASON"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BID_SUCCESS_REASON",	SaveName:"BID_SUCCESS_REASON"}
							,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}", 	Header:"총금액",	SaveName:"TOTAL_UNIT_PRICE"}					
							,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",	Header:"품목구분",	SaveName:"ITEM_MAKE_TYPE" , BackColor:"${notnullColor}", KeyField:true}
							,{ Align:"Right",	Width:90,	Edit:true,	EditLen:100,	Hidden:true,	Type : "Float",  Format:"${qtyFormat}", 	Header:"최소수량",	SaveName:"MOQ_QTY"}
							,{ Align:"Center",	Width:90,	Edit:true,	EditLen:100,	Hidden:true,	Type : "Text",  	Header:"카테고리셋팅구분",	SaveName:"CATEGORY_CHOICE_TYPE"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"이미지필수",	SaveName:"RFQ_IMG_FLAG"}
							,{Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Combo",ComboText:"운영사|협력사|운영사(미완성)",ComboCode:"M|S|N",	Header:"이미지구분",	SaveName:"RFQ_IMG_TYPE"}
							,{Align : "Center",	SaveName : "IMGFILE_NAME_IMG",		Header : "이미지첨부",		Type : "Image",			Width : 70,		EditLen : 100,	Edit : false,	Hidden : true}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"IMGFILE_DIR",	SaveName:"IMGFILE_DIR"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"IMGFILE_NAME",	SaveName:"IMGFILE_NAME"}
							,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"협력사비고",	SaveName:"STOA_REMARK_IMG", BackColor:"${optColor}"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사비고",	SaveName:"STOA_REMARK"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Combo",	Header:"과세구분",	SaveName:"TAX_TYPE"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"환율코드",	SaveName:"EXP_CODE", BackColor:"${optColor}"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"통화단위",	SaveName:"EXP_CUR"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"환율",	SaveName:"EXP_CUR_PRICE"}
							,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"매출단가(KRW)",	SaveName:"EXP_KR_UNIT_PRICE"}
							,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"부대비용(KRW)",	SaveName:"EXP_INC_EXPENSE"}
							,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"외화매출단가",	SaveName:"EXP_FOR_UNIT_PRICE"}
							,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"영업담당부서",	SaveName:"MNG_DEPT_NM"}
							,{Align : "Center",SaveName : "TO_DATE", Hidden:false, Header : "매출\n단가유효일",	Type : "Date",	Width : 90,	EditLen : 110,	Edit : true, KeyField:true}
							,{Align : "Center",SaveName : "BUY_CLOSE_DATE",	Hidden:false, Header : "매입\n단가유효일",	Type : "Date",	Width : 90,	EditLen : 110,	Edit : true, KeyField:true}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:2000,	Hidden:true,	Type:"Text",	Header:"CONTRACT_INFO",	SaveName:"CONTRACT_INFO"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:2000,	Hidden:true,	Type:"Text",	Header:"QTT_CMPY_INFO",	SaveName:"QTT_CMPY_INFO"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:2000,	Hidden:true,	Type:"Text",	Header:"BTOA_NEGO_PRICE",	SaveName:"BTOA_NEGO_PRICE"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:2000,	Hidden:true,	Type:"Text",	Header:"BTOA_USER_ID",	SaveName:"BTOA_USER_ID"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:2000,	Hidden:true,	Type:"Text",	Header:"표준카테고리코드",	SaveName:"CMS_CATEG_ID"}
							
	];
	
	
	IBS_InitSheet2(mySheet, initsheet,pagingMode , "7");
	
	mySheet.SetColProperty("TAX_TYPE", tax_type);
	
	mySheet.SetCountPosition(4);
	mySheet.SetImageList(1, diskOn);
	mySheet.SetImageList(0, diskOff);
	mySheet.SetImageList(5, remarkOn);
	mySheet.SetImageList(6, remarkOff);

	mySheet.SetCellFontUnderline(0, "BUYER_CATEG_NAME", true);	
	mySheet.SetCellFontUnderline(0, "INIT_PROCESS_NAME", true);	
	mySheet.SetCellFontUnderline(0, "CONTRACT_NO", true);	
	mySheet.SetCellFontUnderline(0, "INIT_BELOW_COMORG_NAME", true);
	mySheet.SetCellFontUnderline(0, "ITEM_MAKE_TYPE", true);
	mySheet.SetColProperty("ITEM_MAKE_TYPE", comboInfo);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_CATEG_NAME"); // 제조사
	setLinkCol(mySheet, "CONTRACT_NO"); // 계약서번호
	setLinkCol(mySheet, "BUYER_ITEM_NO"); // 계약서번호
	setLinkCol(mySheet, "MARGIN_RE_NAME"); // 계약서번호
	setLinkCol(mySheet, "STOA_REMARK_IMG"); // 비고
	setLinkCol(mySheet, "EXP_CODE");
	setLinkCol(mySheet, "MAKER_NAME");
	setLinkCol(mySheet, "IMG");
	setLinkCol(mySheet, "ORIGIN_NAME");
	
	kepSearch(document.searchCondition,  mySheet , "/mprq/getMasterMpRqBuyerQuotationSendPop.do" , pagingMode );
}
	
var st;
var mt;
// 기능함수
var tbuyer = "";
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	var quotation_sum = 0;
	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && str !="back" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
			current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mprq/getMasterMpRqBuyerQuotationSendPop.do" , pagingMode );
		break;
	
	case "regByitAdd": // 고객사 견적제출
		//SLOGIC-BEGIN(P04-4032-05) 
		var buyer = mySheet.GetCellValue(arrRow[0], "BUYER");
		tbuyer = buyer;

		if (arrRow.length != mySheet.RowCount() && buyer == "KRDOOD0001"){
			alert("해당 견적의 모든 ITEM을 선택하여 주십시요.\n\n견적단위로 제출 가능합니다.");
			return; 
		}
		var margin_val	= 0;
		var unit_price = 0;
		var list_price = 0;
		var item_qty = 0;
		var item_flag = "";
		var contract_no = "";
		var contract_seq = "";
		var item_make_type = "";
		var unit_measure = "";
		
		for (var i=0; i<arrRow.length; i++){
			unit_price = mySheet.GetCellValue(arrRow[i],"ATOB_UNIT_PRICE");
			list_price = mySheet.GetCellValue(arrRow[i],"STOA_LIST_PRICE");
			item_qty = mySheet.GetCellValue(arrRow[i],"ITEM_QTY");
			item_flag = mySheet.GetCellValue(arrRow[i],"BUYER_ITEM_NO_STATUS");
			contract_no = mySheet.GetCellValue(arrRow[i],"CONTRACT_NO");
			contract_seq = mySheet.GetCellValue(arrRow[i],"CONTRACT_SEQ");
			margin_val = eval(unit_price)-eval(list_price);
			item_make_type = mySheet.GetCellValue(arrRow[i],"ITEM_MAKE_TYPE");
			unit_measure = mySheet.GetCellValue(arrRow[i],"UNIT_MEASURE");

			// 지정협력사 체크
			if(mySheet.GetCellValue(arrRow[i], 'ASSIGN_AGENT_CODE') != ""){
				if(mySheet.GetCellValue(arrRow[i], 'ASSIGN_AGENT_CODE') != mySheet.GetCellValue(arrRow[i], 'AGENT')){
					alert(arrRow[i]+"번째 지정협력사로 제출하시기 바랍니다.");
					return;
				}	
			}
			
			//매출단가 유효일이 설정 안되어 있을 경우(중앙소싱 안하는 고객사는 예외)
			if(mySheet.GetCellValue(arrRow[i], 'TO_DATE') == ""){
				alert(arrRow[i]+"번째 매출단가 유효일 설정 필요합니다.\n영업 담당자에게 문의 바랍니다.");
				return;
			}
			//매출단가 유효일이 설정 안되어 있을 경우
			if(mySheet.GetCellValue(arrRow[i], 'QTT_CMPY_INFO') == "E"){
				alert(arrRow[i]+"번째 고객사의 거래유형 또는 SG별 매익율 설정이 필요합니다. \n영업 담당자에게 문의 바랍니다.");
				return;
			}
			if(kepIsValueNull(kepTrimStr(mySheet.GetCellValue(arrRow[i], "MAKER_CODE")))){
				alert("제조사 코드 맵핑을 하셔야 합니다");
				return;
			}
			
			if(mySheet.GetCellValue(arrRow[i], "OPM_FLAG")=="PM" || eval(margin_val)<=0) {
				$('#st_doos_pm_flag').val("PM");
				mySheet.SetCellValue(arrRow[i], 'PM_FLAG', 'Y');
			}
			// 코오롱인더스트리(주)구미공장, 경산공장, 김천공장 경우 항상 품의(2012/03/20)
			if(	buyer=="KRKOLO0001" || buyer=="KRKOLO0002" || buyer =="KRKOLO0003" ||buyer == "KRDOOD0001"|| buyer =="KRKOLO0099" || buyer =="KRKOLO0107" || buyer =="KRKOLO0106" || buyer =="KRKOLO0108" || buyer =="KRKOLO0111" || buyer =="KRKOLO0110" || buyer =="KRKOLO0109") {
				mySheet.SetCellValue(arrRow[i], 'PM_FLAG', 'Y');
			}
			// 두산인프라코어 9 고객사의 경우 항상 품의(20130531)
			if(	 buyer=="KRDAEW0043" || buyer =="KRDAEW0045" || buyer =="KRDOOS0046" || buyer =="KRDIGU0001" || buyer =="KRDHIM0005" || buyer =="KRDHIM0002" || buyer =="KRDHIM0003" || buyer =="KRDHIM0001") {
				mySheet.SetCellValue(arrRow[i], 'PM_FLAG', 'Y');
			}
			
			if(kepIsValueNull(contract_no)) {
				alert(arrRow[i]+"번째 계약서를 지정하여 주십시요.");
				return;
			}

			if(kepIsValueNull(mySheet.GetCellValue(arrRow[i], "INIT_PROCESS_TYPE")) || kepIsValueNull(mySheet.GetCellValue(arrRow[i], "INIT_PROCESS_NAME"))) {
				alert("거래유형을 지정하여 주십시요.");
				return;
			}
			
			if(kepIsValueNull(mySheet.GetCellValue(arrRow[i], "BUYER_CATEG_NAME"))) {
				alert("카테고리를 지정하여 주십시요.");
				return;
			}
			
			if(kepIsValueNull(mySheet.GetCellValue(arrRow[i], "INIT_BELOW_COMORG_CODE"))) {
				alert("적용구분을 입력하여 주십시요.");
				return;
			}

			if(kepIsValueNull(mySheet.GetCellValue(arrRow[i], "AGENT"))) {
				alert("협력사를 지정하여 주십시요.");
				return;
			}
			if(kepIsValueNull(mySheet.GetCellValue(arrRow[i], "ITEM_MAKE_TYPE"))) {
				alert("품목구분을 지정하여 주십시요.");
				return;
			}
			if(kepIsValueNull(mySheet.GetCellValue(arrRow[i], "UNIT_MEASURE"))) {
				alert("단위를 지정하여 주십시요.");
				return;
			}

			if(kepIsValueNull(list_price) || kepIsValueNull(unit_price)) {
                alert("협력사 지정이 되지 않은 품목은 고객사 제출을 할수 없습니다.\n\n협력사 및 매출단가 지정후 견적제출 바랍니다.");
                mySheet.SetCellValue(arrRow[i], 'SELECTED', 0);
                return ;
            }
			
			quotation_sum += eval(item_qty) * eval(list_price);

			if($("#st_sour_dsm_yn").val() == "Y"){
				if( (quotation_sum >= 500000) && ( mySheet.GetCellValue(arrRow[i], "MAKER_NAME") == "시중품" || mySheet.GetCellValue(arrRow[i], "MAKER_CODE") == "MK011721" ) ){
					alert("시중품 매입금액 50만원 이상 건으로 담당 SM의 합의를 포함하여 주시기 바랍니다.");
				}
			}

			if(item_flag=="기등록") {
				if(kepIsValueNull(contract_no) || kepIsValueNull(contract_seq)) {
					alert(arrRow[i]+"번째 견적건은 기등록건 입니다.\n\n품목코드 클릭후 계약서를 설정하여 주십시요.");
					return;
				}
			}

			if(kepIsValueNull(mySheet.GetCellValue(arrRow[i], "AGENT_OPEN_FLAG"))) {
				agent_open_flag="N";
			}
			
			if(kepIsValueNull(mySheet.GetCellValue(arrRow[i], "ORIGIN_CODE"))) {
				alert(arrRow[i]+"번째 원산지를 입력하여 주십시요.");
				return;
			}
			
			if(buyer=="KRHANW0013" && kepIsValueNull(mySheet.GetCellValue(arrRow[i], "ITEM_NO"))) {
				alert("품목코드(S)를 입력하여 주십시오.");
				return ;
			}
			//삼성전자 이미지 없을경우 제출 안되도록
			if(buyer=="KRSAMS0123" && kepIsValueNull(mySheet.GetCellValue(arrRow[i], "IMGFILE_NAME"))) {
				alert(arrRow[i]+"번째 이미지를 입력하여 주십시요.");
				return ;
			}else if(buyer=="KRSAMS0140" && kepIsValueNull(mySheet.GetCellValue(arrRow[i], "IMGFILE_NAME"))) {
				//삼성전기일때 이미지 없을 겨웅 제출 안되도록
				alert(arrRow[i]+"번째 이미지를 입력하여 주십시요.");
				return ;
			}else if(buyer=="KRSAMS0192" && kepIsValueNull(mySheet.GetCellValue(arrRow[i], "IMGFILE_NAME"))) {
				//삼성전자 서비스일때 이미지 없을 겨웅 제출 안되도록
				alert(arrRow[i]+"번째 이미지를 입력하여 주십시요.");
				return ;
			}
			
			if(<%=p04404105%> == true){
				if(kepIsValueNull(mySheet.GetCellValue(arrRow[i], "DESCRIPTION_ENG"))){
					alert(arrRow[i]+"번째 품목명(영문)을 입력하여 주십시오.");
					return;
				}
				
				if(kepIsValueNull(mySheet.GetCellValue(arrRow[i], "SPECIFICATION_ENG"))){
					alert(arrRow[i]+"번째 규격(영문)을 입력하여 주십시오.");
					return;
				}
			}
			// 품명규격 변경 여부 체크 - 품의사유 및 품의FLAG 수정
			var ORG_DESC = mySheet.GetCellValue(arrRow[i], 'ORG_DESCRIPTION');
			var DESC = mySheet.GetCellValue(arrRow[i], 'DESCRIPTION');
			
			var ORG_SPEC = mySheet.GetCellValue(arrRow[i], 'ORG_SPECIFICATION');
			var SPEC = mySheet.GetCellValue(arrRow[i], 'SPECIFICATION');
			
			var PM_DESC_SPEC_REASON = ",품목정보변경";
			
			// 품목정보변경이 입력되었는지 확인
			var Row1 = mySheet.FindText("PM_REASON", "품목정보변경", arrRow[i], 2);
			
			if(mySheet.GetCellValue(arrRow[i], 'PM_REASON') == ""){
				PM_DESC_SPEC_REASON = "품목정보변경";
			}
			
			if((ORG_DESC != DESC || ORG_SPEC != SPEC) && Row1 != arrRow[i]){
				mySheet.SetCellValue(arrRow[i], 'PM_REASON', mySheet.GetCellValue(arrRow[i], 'PM_REASON') + PM_DESC_SPEC_REASON);
				mySheet.SetCellValue(arrRow[i], 'PM_FLAG', 'Y');
			}
			
			// 매출단가 0원 확인
			if(mySheet.GetCellValue(arrRow[i], "ATOB_UNIT_PRICE") =="0"){
				alert(arrRow[i] + "번째 견적건은 매출단가 0원이므로 고객사 견적제출이 불가능 합니다.\n시스템팀 확인바랍니다.");			
                return;				
			}
			if(mySheet.GetCellValue(arrRow[i], "CMS_CATEG_ID") == ""){
				alert(arrRow[i] + "번째  표준카테고리 코드가 없습니다. 시스템팀에 확인바랍니다.");
				return;
			}
		}
		
		if(duplRegChk == "Y"){ // 제출 중복 클릭 체크
			alert("견적제출 진행중인 미완료건입니다. 뒤로가기 후에 다시 제출하여 주시기 바랍니다.");
			return;
		}
		
		//SLOGIC-END
		if (!confirm('견적제출 하시겠습니까?'))
			return;
			duplRegChk = "Y";
			kepSave(document.searchCondition ,  mySheet , "/mprq/saveBuyerQuotationSend.do" , "SELECTED" );
		break;
	case "back": 
		var buyer = "${param.st_buyer}";
		var quotation_list = "${param.st_quotation_list}";
		if ("${param.st_gubun}" == "cmpy"){
			location.href = '/mprq/showMasterMpRqCmpySelQuotationSend.do';
		} else {
			location.href = '/mprq/showMasterMpRqQuotationReceiptSend.do?st_buyer='+buyer+"&st_quotation_list="+quotation_list+"&st_quotation_no="+"${param.st_quotation_no}"+"&st_revision="+"${param.st_revision}";
		}
		break;	
	}
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

	var totRow = mySheet.RowCount();

	if( totRow<= 0) return;
	
	if (msg != "") {
		alert(msg);
	}
	
	
	
	for(var i=1; i<=totRow;i++){
		var userDept = $("#st_user_dept").val();
		if(userDept=="123"){
			mySheet.SetCellEditable(i,"LEAD_TIME", 1);
			mySheet.SetCellBackColor(i, "LEAD_TIME", "${optColor}");			
		}
		// 품명규격 변경 가능 고객사 && 신규품목일 때만 품명규격 수정
		if(mySheet.GetCellValue(i, "BUYER_ITEM_NO_STATUS") == "신규"){
			mySheet.SetCellEditable(i,"DESCRIPTION", 1);
			mySheet.SetCellEditable(i,"SPECIFICATION", 1);
			mySheet.SetCellBackColor(i, "DESCRIPTION", "${optColor}");
			mySheet.SetCellBackColor(i, "SPECIFICATION", "${optColor}");
			
			mySheet.SetCellEditable(i,"DESCRIPTION_ENG", 1);
			mySheet.SetCellEditable(i,"SPECIFICATION_ENG", 1);
			mySheet.SetCellBackColor(i, "DESCRIPTION_ENG", "${optColor}");
			mySheet.SetCellBackColor(i, "SPECIFICATION_ENG", "${optColor}");
		}
		
		if (mySheet.GetCellValue(i, "BUYER")  == "KRDOOD0001"){
			mySheet.SetCellEditable(i,"DESCRIPTION",1);
			mySheet.SetCellEditable(i,"SPECIFICATION",1);
			mySheet.SetDataLinkMouse("MAKER_NAME" , 1);
			mySheet.SetColFontColor("MAKER_NAME", "#0100FF");
			mySheet.SetDataLinkMouse("ORIGIN_NAME" , 1);
			mySheet.SetColFontColor("ORIGIN_NAME", "#0100FF");
		}
		
		if (mySheet.GetCellValue(i, "BUYER_ITEM_NO_STATUS") == "신규"){		
			<%	//고객사 단위 사용
			if(p04405501 == true) {		
			%>	
				var cb_unit_measure = KepSheetComboCod2("common.getBComboICOMCOD2","SEL","UNIT", mySheet.GetCellValue(i, "BUYER"));
			    var unit_measure = {ComboCode: cb_unit_measure.ComboCode, ComboText: cb_unit_measure.ComboText};	    
				mySheet.SetColProperty("UNIT_MEASURE", unit_measure);
				mySheet.SetCellEditable(i,"UNIT_MEASURE", 1);
			<% } else { %>
				var cb_unit_measure = KepSheetComboCod2("","SEL","", "");
			    var unit_measure = {ComboCode: cb_unit_measure.ComboCode, ComboText: cb_unit_measure.ComboText};	    
				mySheet.SetColProperty("UNIT_MEASURE", unit_measure);
				mySheet.SetCellEditable(i,"UNIT_MEASURE", 1);		
			<% }%>
		} else {
			<%	//고객사 단위 사용
			if(p04405501 == true) {		
			%>
				var cb_unit_measure = KepSheetComboCod2("common.getBComboICOMCOD2","SEL","UNIT", mySheet.GetCellValue(i, "BUYER"));
			    var unit_measure = {ComboCode: cb_unit_measure.ComboCode, ComboText: cb_unit_measure.ComboText};	    
				mySheet.SetColProperty("UNIT_MEASURE", unit_measure);
				mySheet.SetCellEditable(i,"UNIT_MEASURE", 0);
			<% } else { %>
				var cb_unit_measure = KepSheetComboCod2("","SEL","", "");
			    var unit_measure = {ComboCode: cb_unit_measure.ComboCode, ComboText: cb_unit_measure.ComboText};	    
				mySheet.SetColProperty("UNIT_MEASURE", unit_measure);
				mySheet.SetCellEditable(i,"UNIT_MEASURE", 0);
			<% } %>
		} 
	}
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (code != 1){
		alert(msg);
		return;
	}
	
	if (msg.msg != "") {
		alert(msg.msg);
	}
	if(code>0 && msg.usrmsg == "EXP"){
		//저장 성공시 재조회
		duplRegChk = "N"; // 중복방지 flag 초기화
		doAction("search");
		return;
	}
	if(code == 1 && msg.usrmsg != "" && msg.usrmsg != "undefined" && msg.usrmsg != "N"){
		var type = "SO";
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg.usrmsg+'&PARAM1='+tbuyer, "1000,500,no");
	}
	
	if(code>0 && msg.usrmsg == "N"){
		//저장 성공시 재조회
		duplRegChk = "N"; // 중복방지 flag 초기화
		location.href = "/mprq/showMasterMpRqCmpySelQuotationSend.do";
	}

}

function kepApprovalReturn(flag,docu_no){
// 	location.href = "/mprq/showMasterMpRqCmpySelQuotationSend.do";
	var buyer = "${param.st_buyer}";
	var quotation_list = "${param.st_quotation_list}";
	if ("${param.st_gubun}" == "cmpy"){
		duplRegChk = "N"; // 중복방지 flag 초기화
		location.href = '/mprq/showMasterMpRqCmpySelQuotationSend.do';
	} else {
		location.href = '/mprq/showMasterMpRqQuotationReceiptSend.do?st_buyer='+buyer+"&st_quotation_list="+quotation_list+"&st_quotation_no="+"${param.st_quotation_no}"+"&st_revision="+"${param.st_revision}";
	}
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;
		case "masterMpRqBuyerQuotationReceiptSendCntPop": // 고객사 M
			openSearchPopup('/mprq/showMasterMpRqBuyerQuotationReceiptSendCntPop.do','?buyer_flag=2',"500,350,no"); // buyer_flag = 1(두중)
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	var buyer = mySheet.GetCellValue(Row, "BUYER");
	var org_code = mySheet.GetCellValue(Row, "ORG_CODE");
	var quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
	var quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
	var revision = mySheet.GetCellValue(Row, "REVISION");
	var agent = mySheet.GetCellValue(Row,"AGENT");
	var openflag = mySheet.GetCellValue(Row,"AGENT_OPEN_FLAG");
	var btoa_user_id = mySheet.GetCellValue(Row,"BTOA_USER_ID"); //견적요청자
	
	if ( column == 'SELECTED' ){
		setAmt(Row, Value);
	}
	if (column == 'BUYER_CATEG_NAME') { // 카테고리
		if (org_code=='KRDDDD0001' || org_code=='KRHYUN0026' || org_code=='KRHYUN0033' || org_code=='KRKYUN0002' ||
				org_code=='KRISUC0002' || org_code=='KRISUC0007' ){
			popupSel = "commonCoCoBuyerCategoryChoiceTreePop";
			openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoiceTreePop.do",'?st_buyer='+org_code,"400,500,no");
			
		} else if (org_code=='KRDOOS0004' || org_code=='KRILJI0003' || org_code=='KRILJI0015' || org_code=='KRILJI0026' || 
				org_code=='KRILJI0043' || org_code=='KRHSDE0003' ){
			popupSel = "commonCoCoBuyerSpecialCategoryChoicePop";
			openSearchPopup("/coco/getCommonCoCoBuyerSpecialCategoryChoicePop.do",'?st_buyer='+org_code,'728,710,no');
		} else if (org_code == 'KRDOOD0001' ){ // 두산중공업 전용

			popupSel = "commonCoCoBuyerSpecialCategoryChoiceDooPop";
			openSearchPopup("/coco/showCommonCoCoBuyerCategoryChoiceDooPop.do",'?st_buyer='+org_code,"728,510,no");
		} else {
			popupSel = "commonCoCoBuyerCategoryChoicePop";
			openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoicePop.do",'?st_buyer='+org_code+'&st_user_id='+btoa_user_id,"740,510,no");
		}
		
	} else if (column == 'MARGIN_RE_NAME') { // 노/역마진 사유
		if (mySheet.GetCellValue(Row,"STOA_LIST_PRICE")>=mySheet.GetCellValue(Row,"ATOB_UNIT_PRICE")){
			popupSel = "masterMpRqMarginReSelectPop";
			openSearchPopup("/mprq/showMasterMpRqMarginReSelectPop.do",'','500,360,no');
		} else {
			alert("노/역마진일 때만 입력가능합니다.");
			return;
		}
	} else if (column == 'BUYER_ITEM_NO') { // 품목코드
		popupSel = "constractNo";
		if (mySheet.GetCellValue(Row,"BUYER_ITEM_NO_STATUS") == "기등록"){ // 기등록일 때만
			var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
			openSearchPopup("/common/mprq/masterMpRqGroupContractLisPop.do",'?st_buyer='+buyer+'&st_buyer_item_no='+buyerItemNo,"800,350,no");
		}else if (mySheet.GetCellValue(Row,"BUYER_ITEM_NO_STATUS") == "신규"){ // 신규일 때만
			popupSel = "masterMpRqBuyerItemNoChangePop";
			//post 팝업 파라미터 설정
			var st_form_name = "buyerItemNoChangeForm";
			var st_popup_url = "/mprq/getMasterMpRqBuyerItemNoChangePop.do";
			var st_popup_param = "st_buyer@@"+buyer+"^||^"+"st_buyer_item_no@@"+mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
			var st_popup_option = "500,250,no";
			//post 팝업 호출
			openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
		}
	} else if (column == 'CONTRACT_NO') { // 계약서번호
		popupSel = "masterMdCmContractSelPop";
		if (mySheet.GetCellValue(Row,"BUYER_ITEM_NO_STATUS") != "기등록"){ // 신규일때만
			openSearchPopup("/mdcm/getMasterMdCmContractSelPop.do",'?st_buyer='+org_code,"700,250,no");
		}
	} else if (column == 'MAKER_NAME') { // 제조사
		popupSel = "maker";
		openSearchPopup("/common/agentRegMakerCodePop.do",'','500,500,no'); 
	} else if (column == 'ORIGIN_NAME') { // 원산지
		popupSel = "country";
		openSearchPopup("/common/countryCodePop.do",'','500,500,no');	
	}else if(column == "IMG"){
		popupSel = "addImgPop";
		var st_imgfile_dir = mySheet.GetCellValue(Row, "IMGFILE_DIR");
		var st_imgfile_name = mySheet.GetCellValue(Row, "IMGFILE_NAME");
		var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
		var mod_yn = "Y"; //수정여부
		var st_type = "S"; //협력사일경우
		openSearchPopup("/common/addImagePop.do", '?st_imgfile_dir='+st_imgfile_dir+'&st_imgfile_name='+st_imgfile_name+'&st_buyer_item_no='+st_buyer_item_no+'&mod_yn='+mod_yn+'&st_type='+st_type, "590,670,no");
	}else if (column == "STOA_REMARK_IMG" ){ 
		popupSel = "remarkAtoS";
		var stoa_remark = mySheet.GetCellValue(Row, "STOA_REMARK");
		openSearchPopup("/common/remarkReturn2Pop.do", "?st_return_remark="+stoa_remark+"&st_gubun=KEP", "500,230,no"); // 협력사 비고
	}else if (column == 'EXP_CODE') { //환율코드
		var st_status = mySheet.GetCellValue(Row, "BUYER_ITEM_NO_STATUS");
		if(st_status == "신규"){ //신규품목만 외화단가 매핑 가능
			popupSel = "currencyPop";
			var st_buyer = mySheet.GetCellValue(Row, "BUYER");
			openSearchPopup("/coco/showCommonCoCoCurrencyPop.do", '?st_buyer='+st_buyer,"550,350,no");
		}else{
			alert("기등록건은 외화단가 매핑이 불가능 합니다.\n카탈로그 조회 및 수정화면 통해서 진행 바랍니다.");
			return;
		}
	}
	return;
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
	
	if (mySheet.ColSaveName(Col) == "BUYER_CATEG_NAME"){ // 카테고리
		var value1 = mySheet.GetCellValue(arrRow[0], "BUYER_CATEG_CODE");
		var value2 = mySheet.GetCellValue(arrRow[0], "BUYER_CATEG_NAME");
		if(kepIsValueNull(value1)){
			alert("복사할 카테고리를 선택하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "BUYER_CATEG_CODE", value1);
			mySheet.SetCellValue(arrRow[idx], "BUYER_CATEG_NAME", value2);
		}
	} else if (mySheet.ColSaveName(Col) == "INIT_PROCESS_NAME"){ // 거래유형
		var value1 = mySheet.GetCellValue(arrRow[0], "INIT_PROCESS_TYPE");
		var value2 = mySheet.GetCellValue(arrRow[0], "INIT_PROCESS_NAME");
		var value3 = mySheet.GetCellValue(arrRow[0], "INIT_WAREHOUSE_CODE");
		var value4 = mySheet.GetCellValue(arrRow[0], "INIT_WAREHOUSE_NAME");
		var value5 = mySheet.GetCellValue(arrRow[0], "AGENT");
		var value6 = mySheet.GetCellValue(arrRow[0], "AGENT_NAME");
		
		if(kepIsValueNull(value1)){
			alert("복사할 거래유형을 선택하여 주십시요.");
			return;
		}

		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "INIT_PROCESS_TYPE", value1);
			mySheet.SetCellValue(arrRow[idx], "INIT_PROCESS_NAME", value2);
			if (value1 == "0"){
				mySheet.SetCellValue(arrRow[idx], "INIT_WAREHOUSE_CODE", "");
				mySheet.SetCellValue(arrRow[idx], "INIT_WAREHOUSE_NAME", "");
			} else {
				mySheet.SetCellValue(arrRow[idx], "INIT_WAREHOUSE_CODE", value3);
				mySheet.SetCellValue(arrRow[idx], "INIT_WAREHOUSE_NAME", value4);
			}
			if (value3 == "3") {
				mySheet.SetCellValue(arrRow[idx], "AGENT", value5);
				mySheet.SetCellValue(arrRow[idx], "AGENT_NAME", value6);
			}
		}
	} else if (mySheet.ColSaveName(Col) == "CONTRACT_NO"){ // 계약서번호
		var value1 = mySheet.GetCellValue(arrRow[0], "CONTRACT_NO");
		var value2 = mySheet.GetCellValue(arrRow[0], "CONTRACT_SEQ");
		if(kepIsValueNull(value1)){
			alert("복사할 계약서를 선택하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			if (mySheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO_STATUS") != "기등록"){
				mySheet.SetCellValue(arrRow[idx], "CONTRACT_NO", value1);
				mySheet.SetCellValue(arrRow[idx], "CONTRACT_SEQ", '');
			}
		}
			
	} else if (mySheet.ColSaveName(Col) == "INIT_BELOW_COMORG_NAME"){ // 적용구분
		var value1 = mySheet.GetCellValue(arrRow[0], "INIT_BELOW_COMORG_CODE");
		var value2 = mySheet.GetCellValue(arrRow[0], "INIT_BELOW_COMORG_NAME");
		if(kepIsValueNull(value1)){
			alert("복사할 적용구분을 선택하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "INIT_BELOW_COMORG_CODE", value1);
			mySheet.SetCellValue(arrRow[idx], "INIT_BELOW_COMORG_NAME", value2);
		}
	}
}
var totAmt = 0;
//금액정보 처리
function setAmt(index, value) {
	var buyerAmt = 0;

	var sItemQty = Number( kepFilterNum( String( mySheet.GetCellValue(index, "ITEM_QTY") ) ) );
	var sUnitPrice = Number( kepFilterNum( String( mySheet.GetCellValue(index, "ATOB_UNIT_PRICE") ) ) );



	if( value == "1" ) {
		buyerAmt = totAmt + sItemQty*sUnitPrice;
	} else {
		buyerAmt = totAmt -  sItemQty*sUnitPrice;
	}

	totAmt = buyerAmt;
	// 금액합계 셋팅
	$("#buyerAmtSel").html( kepCommaNum(buyerAmt) );
}
//그리드 헤더 전체 체크박스 클릭 이벤트
function mySheet_OnCheckAllEnd(Col, Value) {

	var totCnt = mySheet.RowCount();

	if ( totCnt < 1 ) return;


	if ( Value ) {
		var buyerAmt = 0;
		for( var i = 1; i <= totCnt; i++ ) {
			var sItemQty = Number( kepFilterNum( String( mySheet.GetCellValue(i, "ITEM_QTY") ) ) );
			var sUnitPrice = Number( kepFilterNum( String( mySheet.GetCellValue(i, "ATOB_UNIT_PRICE") ) ) );
			buyerAmt = buyerAmt + sItemQty*sUnitPrice;			
	    }
		
		totAmt = buyerAmt;
		// 금액합계 셋팅
		$("#buyerAmtSel").html( kepCommaNum(buyerAmt) );
	} else {
		totAmt ='0';
		// 금액합계 셋팅
		$("#buyerAmtSel").html( '0');
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	
	} else if (popupSel == "masterMpRqBuyerQuotationReceiptSendCntPop") {	// 고객사 견적접수 및 제출 건수
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	
	} else if (popupSel == "constractNo") {	// 품목코드(기등록)
		mySheet.SetCellValue(grbRow, 'CONTRACT_NO', value1);
		mySheet.SetCellValue(grbRow, 'CONTRACT_SEQ', value2);
		mySheet.SetCellValue(grbRow, 'CONTRACT_INFO', value3);
		
	} else if (popupSel == "masterMpRqMarginReSelectPop") {	// 노/역마진 사유
		mySheet.SetCellValue(grbRow, 'MARGIN_RE_CODE', value1);
		mySheet.SetCellValue(grbRow, 'MARGIN_RE_NAME', value2);
	
	} else if (popupSel == "masterMdCmContractSelPop") {	// 계약서번호(신규)
		mySheet.SetCellValue(grbRow, 'CONTRACT_NO', value1);
	
	} else if (popupSel == "commonCoCoBuyerCategoryChoiceTreePop") {	// 카테고리팝업
		mySheet.SetCellValue(grbRow, 'BUYER_CATEG_CODE', value1);
		mySheet.SetCellValue(grbRow, 'BUYER_CATEG_NAME', value2);
		
	} else if (popupSel == "commonCoCoBuyerCategoryChoicePop") {	// 카테고리팝업
		mySheet.SetCellValue(grbRow, 'BUYER_CATEG_CODE', value1);
		mySheet.SetCellValue(grbRow, 'BUYER_CATEG_NAME', value2);
		
	} else if (popupSel == "commonCoCoBuyerSpecialCategoryChoicePop") {	// 카테고리팝업
		mySheet.SetCellValue(grbRow, 'BUYER_CATEG_CODE', value1);
		mySheet.SetCellValue(grbRow, 'BUYER_CATEG_NAME', value2);
		
	} else if (popupSel == "commonCoCoBuyerSpecialCategoryChoiceDooPop") {	// 카테고리팝업(두중)
		mySheet.SetCellValue(grbRow, 'BUYER_CATEG_CODE', value1);
		mySheet.SetCellValue(grbRow, 'BUYER_CATEG_NAME', value2);
	
	} else if(popupSel == "cancelRemark") {	//견적 취소
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK_IMG', (value1!="")? remarkOn : remarkOff);

	} else if(popupSel == "masterMpRqReqUserSelPop") {
		mySheet.SetCellValue(grbRow, 'RFQ_KEP_USER', value1);
		mySheet.SetCellValue(grbRow, 'RFQ_KEP_USER_NAME', value2);
	} else if (popupSel == "maker"){ // 제조사
		mySheet.SetCellValue(grbRow, 'MAKER_CODE', value1);
		mySheet.SetCellValue(grbRow, 'MAKER_NAME', value2);
		mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value3);
		mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value4);
	} else if (popupSel == "country"){ // 원산지
		mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value1);
		mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value3);
	} else if(popupSel =="currencyPop"){//환율팝업
		mySheet.SetCellValue(grbRow,"EXP_CODE",value1);
		mySheet.SetCellValue(grbRow,"EXP_CUR",value2);
		mySheet.SetCellValue(grbRow,"EXP_CUR_PRICE",value3);
		mySheet.SetCellValue(grbRow,"SELECTED", "1");
		kepSave(document.searchCondition ,  mySheet , "/mprq/saveExpBuyerQuotationSend.do" , "SELECTED" );
	} else if (popupSel == "masterMpRqBuyerItemNoChangePop") {	// 품목코드(신규)
		mySheet.SetCellValue(grbRow, 'BUYER_ITEM_NO', value1);
	} else if(popupSel == "addImgPop") {	// 이미지첨부
		mySheet.SetCellValue(grbRow, 'IMGFILE_DIR', value1);
		mySheet.SetCellValue(grbRow, 'IMGFILE_NAME', value2);
		mySheet.SetCellValue(grbRow, 'RFQ_IMG_TYPE', "M");
		
		var img_url = "https://keps3.koreab2b.com/" + value1 + "/" + value2;
		mySheet.SetCellValue(grbRow, "IMG", img_url);
	}
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>고객사 견적제출</h3>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
			<input type="hidden" id="st_quotation_list" name="st_quotation_list"  value="${param.st_quotation_list}">
			<input type="hidden" id="st_doos_pm_flag" name="st_doos_pm_flag"  value="">
			<input type="hidden" id="st_buyer_rate_flag" name="st_buyer_rate_flag"  value="N">
			<input type="hidden" id="st_pm_flag" name="st_pm_flag"  value="">
			<input type="hidden" id="st_pass_flag" name="st_pass_flag"  value="N">
			<input type="hidden" name="st_sour_dsm_yn"  id="st_sour_dsm_yn" value ="<%=st_sour_dsm_yn%>">
           	
           	<textarea id="st_re_note" name="st_re_note" style="width:99%;" rows="10" readonly><%=getCodeQSRMText%></textarea>
           	<br><br>
           	
           	<span class="fl">
			<b>품목코드(B)</b> : 고객사 품목코드, <b>품목코드(S)</b> : 협력사 품목코드 가 카달로그 등록
				&nbsp;&nbsp;&nbsp;※ <font color="red" style="text-decoration:underline;font-weight:bold;">기등록품목</font>은 <font color="blue" style="text-decoration:underline;font-weight:bold;">품목코드(품번)</font>을 클릭 후 <font color="green" style="text-decoration:underline;font-weight:bold;">계약서를 설정</font>하여 주시기 바랍니다. 
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			
  			<!--버튼영역-->
            <div class="btnArea mt05">
	            <span class="fl"> <b>매출금액합계:</b><span id="buyerAmtSel" style="font-weight:bold; color:orange;">0</span>원 </span>
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('back');">뒤로가기</a></span>
  					<span class="btn_05"><a href="javascript:doAction('regByitAdd');">고객사 견적제출</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
