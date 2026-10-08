<%--
**********************************************
* 메뉴 : 상품관리>고객사 카탈로그 관리>카탈로그 조회 및 수정
* 화면 : 카탈로그 조회 및 수정
* 기능 : 고객사 카탈로그 조회, 수정
* 프로그램 ID : PG_03_M_002_00
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-06-12
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	String userid = "";
	if (_sessionInfo != null){
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());
	} 

	// 물질정보 권한자
	String st_msds_user_yn = "N";
	boolean bool_msds_user_yn = CommonUtil.getCodeCheckReturn("CM10", userid);
	
	if(bool_msds_user_yn == true){
		st_msds_user_yn = "Y";
	}
%>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var productGbn = KepSheetComboData("M132","SPACE");
    var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};
    var diskOn = "/resources/images/disk_on.gif";
    var areaOn="/resources/images/icon.gif";
    var areaOff = "/resources/images/icon2.gif";
    var eraser = "/resources/images/btn_eraser2.gif";
    
	var initsheet = {};
	initsheet.Cols = [
			 { Align:"Center",	Width:60,	Type:"Status",		Header:"상태",			SaveName:"sStatus",				Edit:false,		EditLen:0,		Hidden:true}
			,{ Align:"Center",	Width:30,   Type:"DummyCheck",	Header:"",				SaveName :"SELECTED",			Edit:true,		Sort:0}
			,{ Align:"Center",	Width:80,	Type:"Image",		Header:"이미지",			SaveName:"ITEM_IMAGE", 			Edit:false,		ImgWidth:50, 	ImgHeight:40}
			,{ Align:"Center",	Width:80,	Type:"Image",		Header:"상세이미지",		SaveName:"DETAIL_ITEM_IMAGE",	Edit:false,		ImgWidth:50,	ImgHeight:40}
			,{ Align:"Left",	Width:105,	Type:"Text",		Header:"품목코드",			SaveName:"BUYER_ITEM_NO",		Edit:false,		EditLen:100, 	FontColor:"#003694"}
			,{ Align:"Left",	Width:105,	Type:"Text",		Header:"표준카탈로그코드",	SaveName:"STDCATLG_ID",			Edit:false,		EditLen:100}
			,{ Align:"Left",	Width:236,	Type:"Text",		Header:"품목명",			SaveName:"DESCRIPTION",			Edit:false,		EditLen:400}
			,{ Align:"Left",	Width:236,	Type:"Text",		Header:"규격",			SaveName:"SPECIFICATION",		Edit:false,		EditLen:300}
			,{ Align:"Left",	Width:236,	Type:"Text",		Header:"품목명(영문)",		SaveName:"DESCRIPTION_ENG",		Edit:false,		EditLen:400}
			,{ Align:"Left",	Width:236,	Type:"Text",		Header:"규격(영문)",		SaveName:"SPECIFICATION_ENG",	Edit:false,		EditLen:300}
			,{ Align:"Left",	Width:236,	Type:"Text",		Header:"KeP표준화규격",	SaveName:"REFINE_NOTE",			Edit:false,		EditLen:300}
			,{ Align:"Left",	Width:80,	Type:"Text",		Header:"표준화담당자",		SaveName:"REFINE_USER_NM",		Edit:false,		EditLen:300}
			,{ Align:"Right",	Width:60,	Type:"Float", 		Header:"납품가능협력사",	SaveName:"BTOA_MNG_CNT",		Edit:false,		EditLen:300,	Format:"${priceFormat}"}
			,{ Align:"Left",	Width:201,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME",			Edit:false,		EditLen:300,	FontColor:"#003694"}
			,{ Align:"Left",	Width:134,	Type:"Text",		Header:"제조사명",			SaveName:"MAKER_NAME",			Edit:false,		EditLen:300}
			,{ Align:"Center",	Width:100,	Type:"Text",		Header:"계약번호",			SaveName:"CONTRACT_NO"}
			,{ Align:"Center",	Width:80,	Type:"Text",		Header:"계약항번",			SaveName:"CONTRACT_SEQ",		Edit:false,		EditLen:300}
			,{ Align:"Right",	Width:86,	Type:"Float", 		Header:"매출단가",			SaveName:"UNIT_PRICE",			Edit:false,		EditLen:300,	Format:"${priceFormat}"}
			,{ Align:"Right",	Width:86,	Type:"Float", 		Header:"매입단가",			SaveName:"LIST_PRICE",			Edit:false,		EditLen:300,	Format:"${priceFormat}"}
			,{ Align:"Left",	Width:57,	Type:"Text",		Header:"단위",			SaveName:"UNIT_MEASURE",		Edit:false,		EditLen:300}
			,{ Align:"Left",	Width:105,	Type:"Text",		Header:"적용구분",			SaveName:"BELOW_TEXT",			Edit:false,		EditLen:300}
			,{ Align:"Right",	Width:90,	Type:"Text",		Header:"표준납기일",		SaveName:"DELIVERY_LT",			Edit:false,		EditLen:300}
			,{ Align:"Center",	Width:100,  Type:"Combo",		Header:"품목구분",			SaveName:"ITEM_MAKE_TYPE",		Edit:false,		EditLen:100,	Hidden:false}
			,{ Align:"Center",	Width:96,	Type:"Text",		Header:"상태",			SaveName:"STATUS_TEXT",			Edit:false,		EditLen:300}
			,{ Align:"Left",	Width:77,	Type:"Text",		Header:"등록일",			SaveName:"ADD_DATE",			Edit:false,		EditLen:300,	Format:"Ymd"}
			,{ Align:"Left",	Width:77,	Type:"Text",		Header:"수정일",			SaveName:"CHANGE_DATE",			Edit:false,		EditLen:300,	Format:"Ymd"}
			,{ Align:"Center",	Width:18,	Type:"Image",		Header:"MSDS NO",		SaveName:"PRINT",				Edit:true,		EditLen:100,	Hidden:false,	ColMerge:1,	Sort:0}
			,{ Align:"Left",	Width:100,	Type:"Text",		Header:"MSDS NO",		SaveName:"MSDS_NO",				Edit:false,		EditLen:100,	Hidden:false,	ColMerge:1,	Sort:0}
	<%if(st_msds_user_yn.equals("Y")){%>
			,{ Align:"Left",	Width:28,	Type:"Image",		Header:"MSDS NO",		SaveName:"ERASE_MSDS_NO",		Edit:false,		EditLen:100,	Hidden:false,	ColMerge:1,	Sort:0}
	<%}%>
			,{ Align:"Center",	Width:80,	Type:"Text",		Header:"MSDS URL",		SaveName:"MSDS_URL_YN",			Edit:false,		EditLen:100,	Hidden:false,	ColMerge:1,	Sort:0}
			,{ Align:"Left",	Width:100,	Type:"Text",		Header:"MSDS URL",		SaveName:"MSDS_URL",			Edit:false,		EditLen:100,	Hidden:true,	ColMerge:1,	Sort:0}
			,{ Align:"Left",	Width:100,	Type:"Text",		Header:"모델번호",			SaveName:"MAKER_PART_NO",		Edit:false,		EditLen:100,	Hidden:false,	ColMerge:1,	Sort:0}
			,{ Align:"Center",	Width:60,	Type:"Image",		Header:"결재정보",			SaveName:"APPR_INFO",			Edit:false,		EditLen:300}
			,{ Align:"Left",	Width:0, 	Type:"Text",		Header:"",				SaveName:"MAPP_TEXT",			Hidden:true}
			,{ Align:"Left",	Width:0,	Type:"Text",		Header:"",				SaveName:"BUYER",				Hidden:true}
			,{ Align:"Left",	Width:0, 	Type:"Text",		Header:"",				SaveName:"BYIT_STATUS",			Hidden:true}
			,{ Align:"Left",	Width:0, 	Type:"Text",		Header:"",				SaveName:"STDCATEG_ID",			Hidden:true}
			,{ Align:"Left",	Width:0, 	Type:"Text",		Header:"",				SaveName:"PRODUCT_CLOSE_FLAG",	Hidden:true}
			,{ Align:"Left",	Width:0, 	Type:"Text",		Header:"",				SaveName:"BELOW_COMORG_CODE",	Hidden:true}
			,{ Align:"Left",	Width:0, 	Type:"Text",		Header:"",				SaveName:"CQDT_STATUS",			Hidden:true}
			,{ Align:"Left",	Width:0,	Type:"Text",		Header:"",				SaveName:"AGENT",				Hidden:true}
			,{ Align:"Left",	Width:0, 	Type:"Text",		Header:"",				SaveName:"CQEP_CNT",			Hidden:true}
			,{ Align:"Center",	Width:80, 	Type:"Text",		Header:"유해화학물질",		SaveName:"CMC_HARMFUL_YN",		Edit:false,		Hidden:false}
			,{ Align:"Center",	Width:80,	Type:"Text",		Header:"화학물질여부",		SaveName:"MSDS_YN",				Edit:false,		EditLen:100,	Hidden:false}
			,{ Align:"Center",	Width:80,	Type:"Text",		Header:"MSDS발송",		SaveName:"MSDS_MAIL_SEND",		Edit:false,		EditLen:100,	Hidden:false}
			,{ Align:"Center",	Width:80,	Type:"Text",		Header:"MSDS수신",		SaveName:"MSDS_MAIL_RECV",		Edit:false,		EditLen:100,	Hidden:false}
			,{ Align:"Center",	Width:80,	Type:"Text",		Header:"KEY1",			SaveName:"KEY1",				Edit:false,		EditLen:100,	Hidden:true}
			,{ Align:"Center",	Width:80, 	Type:"Text",		Header:"KEY2",			SaveName:"KEY2",				Edit:false,		EditLen:100,	Hidden:true}
			,{ Align:"Center",	Width:80,	Type:"Text",		Header:"KEY3",			SaveName:"KEY3",				Edit:false,		EditLen:100,	Hidden:true}
			,{ Align:"Center",	Width:80,	Type:"Text",		Header:"KEY4",			SaveName:"KEY4",				Edit:false,		EditLen:100,	Hidden:true}
			,{ Align:"Center",	Width:8,	Type:"Text",		Header:"KEY5",			SaveName:"KEY5",				Edit:false,		EditLen:1000,	Hidden:true}
			,{ Align:"Center",	Width:80,	Type:"Text",		Header:"KEY6",			SaveName:"KEY6",				Edit:false,		EditLen:100,	Hidden:true}
			,{ Align:"Center",	Width:80,	Type:"Text",		Header:"KEY7",			SaveName:"KEY7",				Edit:false,		EditLen:100,	Hidden:true}
			,{ Align:"Center",	Width:80,	Type:"Text",		Header:"KEY8",			SaveName:"KEY8",				Edit:false,		EditLen:400,	Hidden:true}
			,{ Align:"Left",	Width:150,	Type:"Text",		Header:"이미지경로",		SaveName:"IMGFILE_DIR",			Edit:false,		EditLen:300}
			,{ Align:"Left",	Width:90,	Type:"Text",		Header:"이미지파일",		SaveName:"IMGFILE_NAME",		Edit:false,		EditLen:300}
			,{ Align:"Left",	Width:150,	Type:"Text",		Header:"이미지경로",		SaveName:"DETAIL_IMGFILE_DIR",	Edit:false,		EditLen:300}
			,{ Align:"Left",	Width:90,	Type:"Text",		Header:"이미지파일",		SaveName:"DETAIL_IMGFILE_NAME",	Edit:false,		EditLen:300}
			,{ Align:"Center",	Width:70,	Type:"Text",		Header:"갱신구분", 		SaveName:"ITEM_FLAG",			Edit:false,		EditLen:80,		Hidden:false, 	ColMerge:1,	Sort:0}
			,{ Align:"Center",	Width:70,	Type:"Text",		Header:"SG담당자\n(SM)",	SaveName:"SM_MNG_NM",			Edit:false,		EditLen:80,		Hidden:false, 	ColMerge:1,	Sort:0}
			,{ Align:"Center",	Width:70,	Type:"Text",		Header:"SG담당자\n(DSM)",	SaveName:"DSM_MNG_NM",			Edit:false,		EditLen:80,		Hidden:false, 	ColMerge:1,	Sort:0}
			,{ Align:"Center",	Width:77,	Type:"Text",		Header:"매츌\n단가유효일",	SaveName:"SELL_CLOSE_DATE",		Edit:false,		EditLen:300,	Format:"Ymd"}
			,{ Align:"Center",	Width:77,	Type:"Text", 		Header:"매입\n단가유효일",	SaveName:"BUY_CLOSE_DATE",		Edit:false,		EditLen:300,	Format:"Ymd"}
			,{ Align:"Left",	Width:150,	Type:"Text",		Header:"녹색구매제품",		SaveName:"BUY_GREEN_ITEM_NM",	Edit:false,		EditLen:300}
			,{ Align:"Center",	Width:80,	Type:"Text",		Header:"인증번호",			SaveName:"BUY_GREEN_ITEM_CNO",	Edit:false,		EditLen:300}
			,{ Align:"Center",	Width:100,	Type:"Text",		Header:"녹색구매제품\n유효기간시작일",	SaveName:"BUY_GREEN_ITEM_FROM_DATE",	Edit:false,		EditLen:300,	Format:"Ymd"}
			,{ Align:"Center",	Width:100,	Type:"Text",		Header:"녹색구매제품\n유효기간종료일",	SaveName:"BUY_GREEN_ITEM_TO_DATE",		Edit:false,		EditLen:300,	Format:"Ymd"}
			,{ Align:"Center",	Width:80,	Type:"Text",		Header:"CLOSE_STATUS_CODE",	SaveName:"CLOSE_STATUS_CODE",				Edit:false,		EditLen:100,	Hidden:true}
			,{ Align:"Center",	Width:80, 	Type:"Text",		Header:"DEL_STATUS_CODE",	SaveName:"DEL_STATUS_CODE",	Edit:false,		EditLen:100,	Hidden:true}
			,{ Align:"Center",	Width:80, 	Type:"Text",		Header:"CH_CQDT_STATUS",	SaveName:"CH_CQDT_STATUS",	Edit:false,		EditLen:100,	Hidden:true}
			,{ Align:"Center",	Width:80, 	Type:"Text",		Header:"CH_PRODUCT_CLOSE_FLAG",	SaveName:"CH_PRODUCT_CLOSE_FLAG",		Edit:false,		EditLen:100,	Hidden:true}
			,{ Align:"Center",	Width:80, 	Type:"Text",		Header:"CH_DEL_STATUS_CODE",	SaveName:"CH_DEL_STATUS_CODE",			Edit:false,		EditLen:100,	Hidden:true}
			,{ Align:"Center",	Width:80, 	Type:"Text",		Header:"CH_CLOSE_STATUS_CODE",	SaveName:"CH_CLOSE_STATUS_CODE",		Edit:false,		EditLen:100,	Hidden:true}
			,{ Align:"Center",	Width:80, 	Type:"Text",		Header:"CURRENCY_CNT",	SaveName:"CURRENCY_CNT",		Edit:false,		EditLen:100,	Hidden:true}
			,{ Align:"Center",	Width:80, 	Type:"Text",		Header:"COM_NAME_LOC",	SaveName:"COM_NAME_LOC",		Edit:false,		EditLen:100,	Hidden:true}
					
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4);
	
	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	//비고이미지설정
	mySheet.SetImageList(1, diskOn);
	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getSgKepUserList','ALL2','');
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "AGENT_NAME");
	setLinkCol(mySheet, "MSDS_NO");
	setLinkCol(mySheet, "PRINT"); // MSDS 등록 및 매핑
	setLinkCol(mySheet, "BTOA_MNG_CNT"); //납품가능 협력사
	setLinkCol(mySheet, "APPR_INFO");
	setLinkCol(mySheet, "ITEM_IMAGE");//품목이미지
	setLinkCol(mySheet, "DETAIL_ITEM_IMAGE");//품목상세이미지
	setLinkCol(mySheet, "MSDS_URL_YN");//MSDS 링크
	setLinkCol(mySheet, "ERASE_MSDS_NO"); // MSDS 매핑해제
	mySheet.SetImageList(3, areaOn);
	mySheet.SetImageList(4, areaOff);
	mySheet.SetImageList(5, eraser);
	
	//콤보셋팅
	mySheet.SetColProperty("ITEM_MAKE_TYPE", comboInfo);
	// 콤보데이터 셋팅
	kepAjaxCommonQueryIdSearchTwoCombo('st_add_user_id','common.masterDepartmentUserList','PG_10_M_006_00','','ALL',''); // 조회조건 : 담당자
	//엑셀다운로드 sheet
	var initsheet2 = {};
	initsheet2.Cols = [  
	      			 {Align : "Left",SaveName : "CATEGORY_NAME",		Header : "카테고리",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			,{Align : "Right",SaveName : "CATEG_TYPE_CNT",		Header : "등록품목수",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			,{Align : "Left",SaveName : "STD_CATEG_ID",		Header : "카테고리번호",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			,{Align : "Left",SaveName : "CATEG_NAME",		Header : "카테고리명",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			,{Align : "Center",SaveName : "CATEG_TYPE",		Header : "카테고리유형",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	];
	
	IBS_InitSheet(mySheet2, initsheet2,pagingMode);
}
//매핑후 조회	
function opener_searchData(){
	doAction( "search");
}	
// 기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	var buyer = TrimCommon($("#st_buyer_code").val());
	var agent = TrimCommon($("#st_agent_code").val());
	var categ_id = TrimCommon($("#st_categ_id").val());
	var buyer_item_no = TrimCommon($("#st_buyer_item_no").val());
	var description = TrimCommon($("#st_description").val());
	var specification = TrimCommon($("#st_specification").val());
	var maker_name = TrimCommon($("#st_maker_name").val());
	var from_date = TrimCommon($("#st_from_date").val());
    var to_date = TrimCommon($("#st_to_date").val());
    var st_kep_user_id = TrimCommon($("#st_kep_user_id").val());
    var st_maker_part_no = TrimCommon($("#st_maker_part_no").val());
    var st_stdcatlg_id = TrimCommon($("#st_stdcatlg_id").val());
    
	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		
        if(buyer == "" && agent == "")
        {
            alert("고객사 또는 협력사를 선택해 주십시요.");
            return;
        }

		if(from_date != "" || to_date != ""){
			if(from_date != "" && to_date == ""){
				$("#st_to_date").val(from_date);
			}

			if(from_date == "" && to_date != ""){
				alert("조회를 원하시는 시작일을 입력하여 주시기 바랍니다.");
				return;
			}
			
			if (kep_dateSearchCheck(from_date,to_date) == false) return;
		}
		if(st_stdcatlg_id != ""){
			if(st_stdcatlg_id.length < 5){
				alert("표준카탈로그 코드 5자이상 입력 바랍니다..");
				return;			
			}			
		}

	 	if(!$("#searchInResult").is(":checked") && (buyer != "" || agent != "")){
			if (categ_id == "" && from_date == "" && to_date == "" && buyer_item_no == "" && description == "" && specification == "" && maker_name == "" && st_maker_part_no==""&& st_stdcatlg_id=="" ){
				alert("고객사, 협력사, SG담당자 조건 이외에 하나의 조건을 추가해야 합니다.");
				return;
			}
		}
		
		//결과내 검색
		setQuerySearchInResult();
		pagingMode = "N";
		
		if (!kepIsValueNull($("#st_from_date").val()) || !kepIsValueNull($("#st_to_date").val())){
	    	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		}
	    
		kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmCatalogAlterList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$("#st_buyer_code").val("");
		$("#st_categ_id").val("");
		$("#st_agent_code").val("");
		$("#st_description_field").val("");
		$("#st_specification_field").val("");
		$("#st_maker_name_field").val("");
		$("#st_from_date").val("");
		$("#st_to_date").val("");
		$("#st_status").val("N");
		$("#st_date").val("RE");
		$("#searchInResult").attr("checked", false);
		mySheet.RemoveAll();
		break;

	case "excelDown": // 엑셀다운로드
		if(buyer == ""){
            alert("고객사를 선택해 주십시요.");
            return;
        }
	
	    $("#pageflag").val('0');
		var param = {FileName:"MdcmBuyerCategory.xlsx"};
		kepDownExcel(document.searchCondition ,mySheet2 , "/mdcm/excelMasterMdCmCatalogAlterList.do", param);
		$("#pageflag").val('1');
		
		break;
	case "confirm": // 거래
		if (selectedGrid.length == 0) {
			alert("선택된 항목이 없습니다.");
			return;
		}
		for(var i=1; i<mySheet.GetTotalRows()+1; i++){
			if (mySheet.GetCellValue(i, "SELECTED") == '1'){
				if(mySheet.GetCellValue(i, "PRODUCT_CLOSE_FLAG") == "N"&& (mySheet.GetCellValue(i, "CQDT_STATUS") == "C"||mySheet.GetCellValue(i, "CQDT_STATUS") == "R")){
					alert(i+"번째 거래 중인 품목 입니다.");
					mySheet.SelectCell(i, "BUYER_ITEM_NO");
					return;					
				}
			}
			mySheet.SetCellValue(i, "CH_CQDT_STATUS", "R");
			mySheet.SetCellValue(i, "CH_PRODUCT_CLOSE_FLAG", "N");
		}
		$("#st_gubun").val('C');
		kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMdCmBuyerCatalogStatus.do" , "SELECTED" );
		break;
	case "del": //카탈로그 삭제
		if (selectedGrid.length == 0) {
			alert("선택된 항목이 없습니다.");
			return;
		}
		for(var i=1; i<mySheet.GetTotalRows()+1; i++){
			if (mySheet.GetCellValue(i, "SELECTED") == '1'){
				if(mySheet.GetCellValue(i, "CQDT_STATUS") == "D"){
					alert(i+"번째 삭제 품목 입니다.");
					mySheet.SelectCell(i, "BUYER_ITEM_NO");
					return;					
				}
				if(mySheet.GetCellValue(i, "CURRENCY_CNT") != "0"){
					alert(i+"번째 외화단가 매핑건이 존재합니다. 외화 매핑삭제 후 진행 바랍니다.");
					mySheet.SelectCell(i, "BUYER_ITEM_NO");
					return;			
				}
			}
		}
		popupSel = "delReasonPop";
		openSearchPopup("/common/catlgCloseDelReasonPop.do", "?st_type=D", "500, 150, no");
		break;
	case "close": //단종
		if (selectedGrid.length == 0) {
			alert("선택된 항목이 없습니다.");
			return;
		}
		for(var i=1; i<mySheet.GetTotalRows()+1; i++){
			if (mySheet.GetCellValue(i, "SELECTED") == '1'){
				if(mySheet.GetCellValue(i, "PRODUCT_CLOSE_FLAG") == "Y"){
					alert(i+"번째 단종 품목 입니다.");
					mySheet.SelectCell(i, "BUYER_ITEM_NO");
					return;					
				}
			}
		}
		popupSel = "closeReasonPop";
		openSearchPopup("/common/catlgCloseDelReasonPop.do", "?st_type=C", "500, 150, no");
		break;
	case "IFconfirm": // 거래(I/F)
		if (selectedGrid.length == 0) {
			alert("선택된 항목이 없습니다.");
			return;
		}
		for(var i=1; i<mySheet.GetTotalRows()+1; i++){
			if (mySheet.GetCellValue(i, "SELECTED") == '1'){
				if(mySheet.GetCellValue(i, "PRODUCT_CLOSE_FLAG") == "T"){
					alert(i+"번째 I/F 거래 중인 품목 입니다.");
					mySheet.SelectCell(i, "BUYER_ITEM_NO");
					return;					
				}
			}
			mySheet.SetCellValue(i, "CH_CQDT_STATUS", "R");
			mySheet.SetCellValue(i, "CH_PRODUCT_CLOSE_FLAG", "T");
		}
		$("#st_gubun").val('T');
		kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMdCmBuyerCatalogStatus.do" , "SELECTED" );
		break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	
	return DATA;
}
function mySheet2_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
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
		var cqepCnt = mySheet.GetCellValue(i,"CQEP_CNT");
		if(cqepCnt > 1){
			mySheet.SetCellFontColor(i,"UNIT_PRICE","#ed5e00");
			mySheet.SetCellFontBold(i, "UNIT_PRICE",1);
			mySheet.SetCellFontColor(i,"LIST_PRICE","#ed5e00");
			mySheet.SetCellFontBold(i, "LIST_PRICE",1);
			mySheet.SetDataLinkMouse("UNIT_PRICE", 1);
			mySheet.SetDataLinkMouse("LIST_PRICE", 1);
		}
		
		var msds_url_yn = mySheet.GetCellValue(i,"MSDS_URL_YN");
		if(msds_url_yn == "미등록"){
			mySheet.SetCellFontColor(i,"MSDS_URL_YN","BLACK");
			mySheet.SetDataLinkMouse("MSDS_URL_YN", 0);
		}
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if(msg.usrmsg != "" && msg.usrmsg != undefined){
		var st_buyer_code = mySheet.GetCellValue(1, "BELOW_COMORG_CODE");
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=CAST&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg.usrmsg+'&PARAM1='+st_buyer_code, "1000,500,no");
	}else{
		if (msg != "") {
			alert(msg);
		}
		if(code>0){
			doAction('search');
		}		
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	pagingMode = "P";
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmCatalogAlterList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;
		
		case "agent_single": // 협력사 M
			openSearchPopup("/common/icomcmpyPop.do", '?BUSINESS_COND=S&MULTI=N', "500,466,no");
			popupSel = "agent_single";
			break;	
		
		case "commonCoCoBuyerCategoryChoicePop": 
			//SLOGIC-BEGIN(P03-3020-02) 
			// 고객사카테고리 선택
			var buyer_code = TrimCommon($("#st_buyer_code").val());
			popupSel = "commonCoCoBuyerCategoryChoicePop";
			
	        if(buyer_code == "")
	        {
	            alert("고객사를 선택해 주십시요.");
	            return;
	        }else {

			if( buyer_code == "KRKEPB0007" || buyer_code == "KRDDDD0001" || buyer_code == "KRHYUN0026" || buyer_code == "KRHYUN0033" || buyer_code == "KRKYUN0002" || buyer_code == "KRISUC0002" || buyer_code == "KRISUC0007")
			{
				popupSel = "commonCoCoBuyerCategoryChoiceTreePop";
		    	openSearchPopup('/coco/getCommonCoCoBuyerCategoryChoiceTreePop.do','?st_buyer='+buyer_code,'400,500,no');
			}else if( buyer_code == "KRDOOD0001" || buyer_code == "KRDOOS0004" || buyer_code == "KRILJI0003" || buyer_code == "KRILJI0026" || buyer_code == "KRILJI0043" || buyer_code == "KRHSDE0003" || buyer_code == "KRDOOS0072"){
				openSearchPopup('/coco/getCommonCoCoBuyerSpecialCategoryChoicePop.do','?st_buyer='+buyer_code+'&st_flag=REG','728,710,no');
	          }else {
	        	  openSearchPopup('/coco/getCommonCoCoBuyerCategoryChoicePop.do','?st_buyer='+buyer_code+'&st_flag=REG','728,510,no');
	          }
	        }
			break;
			//SLOGIC-END
		
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
			
			for(var i=1; i<mySheet.GetTotalRows()+1; i++){ // 그룹사 다른지 체크
				if (mySheet.GetCellValue(i, "SELECTED") == '1'){
					selected_row_cnt ++;
					buyer_af = mySheet.GetCellValue(i, "BELOW_COMORG_CODE");
					
					if(selected_row_cnt == 1){
						buyer_bf = mySheet.GetCellValue(i, "BELOW_COMORG_CODE");
					}
					
					if(buyer_bf != buyer_af){
						alert("동일 고객사만 선택 가능합니다.");
						return;
					}
					
					msds_mapping = mySheet.GetCellValue(i, "MSDS_NO");
					
					if(msds_mapping == "" || msds_mapping == " "){
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
			var st_buyer = "";
			var st_buyer_item_no = "";
			var st_buyer_name = "";
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
					st_buyer            = mySheet.GetCellValue(i, "BELOW_COMORG_CODE");
					st_buyer_item_no 	 = mySheet.GetCellValue(i, "BUYER_ITEM_NO");
					st_buyer_name 	 = mySheet.GetCellValue(i, "COM_NAME_LOC");
				}
			}
			openSearchPopup('/mpvo/showMasterMpVoVocRegPop.do', '?st_buyer_code='+st_buyer+'&st_buyer_name='+st_buyer_name+'&st_type=ITM&st_insert_yn=Y&st_buyer_item_no='+st_buyer_item_no,'1000,380,no');
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'UNIT_PRICE') { // 매출단가 선택
		setSysopCqepHistory(Row);
		
	} else if (column == 'LIST_PRICE') { // 매입단가 선택
		setSysopCqepHistory(Row);

	} else if(column == 'BUYER_ITEM_NO'){ // 품목코드 선택
		var catalog_com_code = mySheet.GetCellValue(Row,"BUYER");
		//var buyer = $("#st_buyer_code").val();
		var buyer = mySheet.GetCellValue(Row,"BELOW_COMORG_CODE");
		var buyer_item_no = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		
		openSearchPopup("/mdcm/showMasterMdCmBuyerCatalogAlterPop.do","?st_buyer_code="+buyer+"&st_catalog_com_code="+catalog_com_code+"&st_buyer_item_no="+buyer_item_no,"988,710,no");
		
	}else if(column == 'AGENT_NAME'){ // 협력사 선택
		var agent = mySheet.GetCellValue(Row,"AGENT");
		openSearchPopup("/mdcp/showMasterMdCpCompyDetailViewPop.do",'?com_code='+agent,"800,600,no");		

	} else if(column == "PRINT"){
		var buyer = mySheet.GetCellValue(Row,"BUYER");
		var p_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
		var p_description = mySheet.GetCellValue(Row, "DESCRIPTION");
		var p_specification = mySheet.GetCellValue(Row, "SPECIFICATION");
		var p_maker_name = mySheet.GetCellValue(Row, "MAKER_NAME");
		var p_unit = mySheet.GetCellValue(Row, "UNIT_MEASURE");	
		
		openSearchPopup("/coco/showCommonCoCoMsdsPop.do", '?p_buyer='+buyer +'&p_buyer_item_no='+p_buyer_item_no+'&p_description='+p_description+'&p_specification='+p_specification+'&p_maker_name='+p_maker_name+'&p_unit='+p_unit, "950,600,no");
	
	}else if(column == 'MSDS_NO'){ // MSDS_NO 확인 및 추가 매핑
		var msds_no = mySheet.GetCellValue(Row,"MSDS_NO");
		
		if(kepIsValueNull(msds_no)){
			
		} else {
		    openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+msds_no+"&st_btn_yn=Y",'750,580,no');
	    }
	}else if(column =='BTOA_MNG_CNT'){
		var catalog_com_code = mySheet.GetCellValue(Row,"BUYER");
		var buyer = mySheet.GetCellValue(Row,"BELOW_COMORG_CODE");
		var buyer_item_no = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		openSearchPopup("/mdcm/showMasterMdCmBuyerCatalogBtoaPop.do","?st_buyer_code="+buyer+"&st_catalog_com_code="+catalog_com_code+"&st_buyer_item_no="+buyer_item_no,"500,350,no");		
	}else if(column == 'APPR_INFO'){
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
		var st_below_comorg_code = mySheet.GetCellValue(Row, "BELOW_COMORG_CODE");

		openSearchPopup("/mdcm/showMasterMdCmCatalogApprInfoPop.do", '?st_buyer='+buyer+'&st_buyer_item_no='+st_buyer_item_no+'&st_below_comorg_code='+st_below_comorg_code, "930,400,no");
	} else if (column == 'ITEM_IMAGE') { // 품목이미지
		var st_imgfile_dir = mySheet.GetCellValue(Row,"IMGFILE_DIR");
		var st_imagfile_name = mySheet.GetCellValue(Row,"IMGFILE_NAME");
		if(st_imgfile_dir ==""){
			alert("등록된 이미지가 없습니다.");
			return;		
		}else{
			//품목이미지 팝업
			var st_img_dr = "<%=CommonUtil.realImgS3UploadPath%>"+"/"+st_imgfile_dir+"/"+st_imagfile_name;
			window.open(st_img_dr,'catalogImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=550,height=550');			
		}
	} else if (column == 'DETAIL_ITEM_IMAGE') { // 품목상세이미지
		var st_imgfile_dir = mySheet.GetCellValue(Row,"DETAIL_IMGFILE_DIR");
		var st_imagfile_name = mySheet.GetCellValue(Row,"DETAIL_IMGFILE_NAME");
		if(st_imgfile_dir ==""){
			alert("등록된 이미지가 없습니다.");
			return;		
		}else{
			//품목이미지 팝업
			var st_img_dr = "<%=CommonUtil.realImgS3UploadPath%>"+"/"+st_imgfile_dir+"/"+st_imagfile_name;
			window.open(st_img_dr,'catalogImage','status=no,resizable=no,menubar=no,scrollbars=yes,"","",width=770,height=770');			
		}
	} else if(column == 'MSDS_URL_YN'){ // MSDS_URL 링크
		var msds_url = mySheet.GetCellValue(Row,"MSDS_URL");
		
		if(kepIsValueNull(msds_url)){
		} else {
		    window.open(msds_url,'msdsUrl','');
	    }
	} else if(column == 'ERASE_MSDS_NO'){ // MSDS 매핑해제
		var msds_no = mySheet.GetCellValue(Row,"MSDS_NO");
	
<%if(!st_msds_user_yn.equals("Y")){%>
		alert("물질정보 권한자만 실행 가능합니다.");
		return;
<%}%>
		
		if(kepIsValueNull(msds_no)){
			alert("매핑된 MSDS가 없습니다.");
			return;
		}else{
			if(!confirm("선택한 " + msds_no + " 매핑 해제하시겠습니까?")) {
	    		return;
			}	
		}
		
		mySheet.SetCellValue(Row, 'SELECTED', 1);

		kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMdCmBuyerCatalogMsdsClean.do" , "SELECTED" );
	}
	
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 고객사
		//그룹을 선택할 수 없도록 처리.
		if(value4 == "1"){
			alert("그룹은 선택할 수 없습니다.");
			return;
		}
		
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
		$("#st_com_org_code").val(value3);
		
// 		chItemStatusList(value1);
	
	} else if (popupSel == "agent_single") {	// 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
		
		chItemStatusList(value1);
	} else if (popupSel == "commonCoCoBuyerCategoryChoicePop") {	// 카테고리	
		$("#st_categ_id").val(value1);
		$("#st_category_path").val(value4);

	}else if (popupSel == "commonCoCoBuyerCategoryChoiceTreePop") {	// 고객사카테고리 트리형
		$("#st_categ_id").val(value1);
		$("#st_category_path").val(value7);
	}else if (popupSel == "msdsMailSendPop") {	// MSDS 메일 전송
		for(var i=1; i<mySheet.GetTotalRows()+1; i++){
			if (mySheet.GetCellValue(i, "SELECTED") == '1'){
				mySheet.SetCellValue(i, "KEY6", value1); // RECV_USER_NAME
				mySheet.SetCellValue(i, "KEY7", value2); // RECV_EMAIL
				mySheet.SetCellValue(i, "KEY8", value3); // REMARK
			}
		}
		
		kepSave(document.searchCondition, mySheet, "/mdcm/saveMasterMdcmMsdsMailSendPop.do", "SELECTED");
	}else if (popupSel == "delReasonPop"){ //카탈로그 상태 삭제팝업
		for(var i=1; i<mySheet.GetTotalRows()+1; i++){ // 그룹사 다른지 체크
			if (mySheet.GetCellValue(i, "SELECTED") == '1'){
				mySheet.SetCellValue(i, "CH_CQDT_STATUS", "D");
				mySheet.SetCellValue(i, "CH_DEL_STATUS_CODE", value1);
			}
		}
		$("#st_gubun").val('D');//카탈로그 상태 삭제
		kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMdCmBuyerCatalogStatus.do" , "SELECTED" );
	}else if (popupSel == "closeReasonPop"){ //카탈로그단종
		for(var i=1; i<mySheet.GetTotalRows()+1; i++){ // 그룹사 다른지 체크
			if (mySheet.GetCellValue(i, "SELECTED") == '1'){
				mySheet.SetCellValue(i, "CH_PRODUCT_CLOSE_FLAG", "Y");
				mySheet.SetCellValue(i, "CH_CLOSE_STATUS_CODE", value1);
			}
		}
		$("#st_gubun").val('Y');//카탈로그 단종처리
		kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMdCmBuyerCatalogStatus.do" , "SELECTED" );
	}
	grbRow="";	//초기화
}

//조회조건 (결과내검색)
function setQuerySearchInResult() {
	// 결과 내 검색 로직 추가
	if($("#searchInResult").is(":checked")){ // 체크를 한 경우
		//===============품명==================//
		if($("#st_description_field").val()=="ALL") {
			$("#st_description_field").val("");
		}
		
		if(!isEmpty($("#st_description").val())) {
			$("#st_description_field").val($("#st_description_field").val()+$("#st_description").val()+"/");
		}

		//===============규격==================//
		if($("#st_specification_field").val()=="ALL") {
			$("#st_specification_field").val("");
		}
		
		if(!isEmpty($("#st_specification").val())) {
			$("#st_specification_field").val($("#st_specification_field").val()+$("#st_specification").val()+"/");
		}

		//===============제조사==================//
		if($("#st_maker_name_field").val()=="ALL") {
			$("#st_maker_name_field").val("");
		}
		
		if(!isEmpty($("#st_maker_name").val())) {
			$("#st_maker_name_field").val($("#st_maker_name_field").val()+$("#st_maker_name").val()+"/");
		}
	}else{ // 체크를 하지 않은 경우
		if(!isEmpty($("#st_description").val())) {
			$("#st_description_field").val($("#st_description").val() +"/");
		}else {
			$("#st_description_field").val("ALL");
		}
	
		if(!isEmpty($("#st_specification").val())) {
			$("#st_specification_field").val($("#st_specification").val() +"/");
		}else {
			$("#st_specification_field").val("ALL");
		}
		
		if(!isEmpty($("#st_maker_name").val())) {
			$("#st_maker_name_field").val($("#st_maker_name").val() +"/");
		}else {
			$("#st_maker_name_field").val("ALL");
		}
	}
}

//SLOGIC-BEGIN(P03-3020-01)
//카탈로그 품목구분을 변경. [두산중공업 / 듀폰 울산]
function chItemStatusList(com_code){ 
	var statusCode ; 
	var statusName ;   
	var fm = document.forms[0]; 

	for(var z=0; z<fm.st_status.length; z++){
		fm.st_status.options[z] = null; 
	} 

	if(com_code =="KRDUPO0001" || com_code =="KRDUPO0002" || com_code =="KRDUPO0003"){ 
		statusCode = new Array("ALL", "N", "Y", "A", "C", "B", "D");                                    
		statusName = new Array("전체", "승인", "단종", "일회용_미발주", "일회용_기발주", "BLOCKED", "삭제"); 
	}else if(com_code =="KRDOOD0001" || com_code =="KRDOOS0004" || com_code =="KRHSDE0003" || com_code =="KRDOOS0072"){ 
		statusCode = new Array("ALL", "N", "Y", "A", "C", "D");                             
		statusName = new Array("전체", "승인", "단종", "일회용_미발주", "신규요청품목", "삭제"); 
	}else{ 
		statusCode = new Array("ALL", "N", "Y", "D");                             
		statusName = new Array("전체", "승인", "미승인/단종", "삭제");  
	}
	
	/* 기존 else 주석()
	else{ 
		statusCode = new Array("ALL", "N", "Y", "D");                             
		statusName = new Array("전체", "승인", "단종", "삭제");  
	}   
	*/
	for (var i=0; i < statusCode.length ; i++ ){
		o = new Option( statusName[i], statusCode[i] );   
		fm.st_status.options[i] = o; 
	}
	
	$("#st_status").val("N");
}
//SLOGIC-END

//단가변경이력 팝업
function setSysopCqepHistory(Row){ 
	var buyer = mySheet.GetCellValue(Row,"BUYER");
	var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
	var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
	var cqepCnt = mySheet.GetCellValue(Row,"CQEP_CNT");
	if(cqepCnt > 1){
		openSearchPopup('/mdcm/showMasterMdCmUnitpriceAlterHistoryPop.do','?st_buyer='+buyer+'&st_contract_no='+contractNo+'&st_contract_seq='+contractSeq,'840,250,no');
	}
}
function kepApprovalReturn(flag,docu_no){
	//결재상신시에 페이지 새로고침.
	//location.reload();
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>카탈로그 조회 및 수정</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
			<input type="hidden" name="SessionUserId" id="SessionUserId"  value="${sessionInfo.userId}"> <!-- MSDS 메일전송 공통 파라미터로 사용중 -->
			<input type="hidden" name="st_msds_mail_reg_type"  id="st_msds_mail_reg_type" value ="CA"> <!-- MSDS 메일전송 공통 파라미터로 사용중 -->
			<input type="hidden" name="st_group_type"  id="st_group_type" value ="N">
			<input type="hidden" name="st_gubun"  id="st_gubun" value ="">
			
            	<table  class="cont_t_list01" >
					<caption>카탈로그 조회 및 수정</caption>
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
							<th><font color="red"><b>*</b></font>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:55%" value="" readonly>
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
								<input type="hidden" name="st_com_org_code" id="st_com_org_code" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>카테고리</th>
							<td>
								<input type="text" class="input_type_text" name="st_category_path" id="st_category_path" style="width:55%" readonly>
								<input type="hidden" name="st_categ_id" id="st_categ_id" >
								<a href="javascript:doPop('commonCoCoBuyerCategoryChoicePop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_categ_id','st_category_path');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>	
							<th>
								<select  class="TitSelect" id="st_date" name="st_date">
									<option value= "RE" selected>등록일</option>
									<option value = "CH">변경일</option>
								</select>
							</th>
							<td colspan="3">
								<input type="text"  class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:63px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								~
								<input type="text"  class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:63px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
							</td>
						</tr>
						<tr>
							<th><font color="red"><b>*</b></font>협력사</th>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:55%"  readonly>
								<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:80%">
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:87%"  value="" onKeyUp="kepToUpper('st_buyer_item_no')" onkeydown="kepEnter()">
							</td>
							<th>상태</th>
							<td>
								<select id="st_status" name="st_status">
									<option value = "ALL" >전체</option>
									<option value = "N"  selected>승인</option>
									<option value = "Y">미승인/단종</option>
									<option value = "D">삭제</option>
									<option value = "T">I/F품목</option>
					            </select>
				            </td>
						</tr>
						<tr> 
							<th>품목명</th>
							<td>
								<input type="text"   class="input_type_text" name="st_description" id="st_description" style="width:87%" value="" onKeyDown="kepEnter()">
								<input type="hidden" id="st_description_field" name="st_description_field" value=""> 
							</td>
							<th>규격</th>
							<td>
								<input type="text"   class="input_type_text" name="st_specification" id="st_specification" style="width:87%" value="" onKeyDown="kepEnter()">
								<input type="hidden" id="st_specification_field"  name="st_specification_field" value=""> 
							</td>
							<th>제조사</th>
							<td>
								<input type="text"   class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:87%" value="" onKeyDown="kepEnter()">
								<input type="hidden" id="st_maker_name_field"  name="st_maker_name_field" value=""> 
							</td>
						</tr>
						<tr> 
							<th>품목구분</th>
							<td>
                            	<label for="b_delivery" class="hidden">품목구분선택</label>
	                     		<select name = "st_item_make_type" id="st_item_make_type" >	                     			
	                     			<script type="text/javascript">kepAjaxCommonComboDataValue('st_item_make_type', 'M132', 'ALL', '');</script>
				             	</select>
							</td>
							<th>등록자</th>
							<td>
								<select id="st_add_user_id" name="st_add_user_id" style="width:80%;height:20px"></select>
							</td>
							<th>매출단가유효일</th>
							<td>
								<select id="st_todate_cqdt" name="st_todate_cqdt">
									<option value = ""  selected>전체</option>
									<option value = "60">60일 미만</option>
									<option value = "90">90일 미만</option>
					            </select>
							</td>
						</tr>
						<tr>
							<th>모델번호</th>
							<td>
								<input type="text"   class="input_type_text" name="st_maker_part_no" id="st_maker_part_no" style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
							<th>표준카탈로그코드</th>
							<td>
								<input type="text"   class="input_type_text" name="st_stdcatlg_id" id="st_stdcatlg_id" style="width:87%" value="" onKeyDown="kepEnter()">
							</td> 
							<th></th>
							<td>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            
     	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="30">30건</option>
					<option value="50">50건</option>
					<option value="100">100건</option>
				</select>
				&nbsp;&nbsp;<input type="checkbox" id="searchInResult" name="searchInResult">결과 내 검색
<!-- 			</span> -->
<!-- 			<span class="fr"> -->
<!-- 				<select id="st_order_by" name="st_order_by"> -->
<!--                   <option value = "1">제품코드순</option> -->
<!--                   <option value = "2">품명순</option> -->
<!--                   <option value = "3">규격순</option> -->
<!--                   <option value = "4">협력사순</option> -->
<!--                   <option value = "5">제조사순</option> -->
<!--                   <option value = "6">매출가격순</option> -->
<!--                 </select>		 -->
		</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			<div style="display:none;">
  				<script type="text/javascript">
  					createIBSheet("mySheet2", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea02" >
  	          	<span class="fl">
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">카테고리DOWN</a></span>
  				</span>
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('IFconfirm');">거래(I/F)</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('confirm');">거래</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('close');">단종</a></span>
  					<span class="btn_04"><a href="javascript:doPop('regVoc');">VOC등록</a></span>
  					<span class="btn_06"><a href="javascript:doPop('msdsMailSend');">MSDS 메일 전송</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
