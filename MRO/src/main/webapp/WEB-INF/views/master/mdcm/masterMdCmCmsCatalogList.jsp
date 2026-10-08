<%--
**********************************************
* 메뉴 : 상품관리>표준 카탈로그 관리>CMS카탈로그
* 화면 : CMS카탈로그
* 기능 : 
* 프로그램 ID : PG_03_M_003_00
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-06-27
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:50,	ImgWidth:50, Edit:false,		Type:"Image",	Header:"이미지",	SaveName:"IMG"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:200,	Type:"Text",	Header:"MASTER코드",	SaveName:"CMS_CATLG_ID"}
					,{ Align:"Left",	Width:236,	Wrap:1, Edit:false,	EditLen:400,	Type:"Html",	Header:"품목명(영문)",	SaveName:"DESCRIPTION"}
					,{ Align:"Left",	Width:150,	Wrap:1, Edit:false,	Hidden:true, EditLen:400,	Type:"Text",	Header:"품목명_영문",	SaveName:"DESCRIPTION_ENG"}
					,{ Align:"Left",	Width:236,	Wrap:1, Edit:false,	EditLen:300,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
					,{ Align:"Left",	Width:80,	Edit:false,	EditLen:300,	Type:"Text",	Header:"SG",	SaveName:"SG_NAME"}
					,{ Align:"Left",	Width:240,	Wrap:1, Edit:false,	EditLen:400,	Type:"Text",	Header:"카테고리",	SaveName:"CATEG_PATH"}
					,{ Align:"Left",	Width:80,	Edit:false,	EditLen:300,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
					,{ Align:"Left",	Width:60,	Edit:false,	EditLen:200,	Type:"Text",	Header:"원산지명",	SaveName:"ORIGIN_NAME"}
					,{ Align:"Left",	Width:40,	Edit:false,	EditLen:300,	Type:"Text",	Header:"단위",	SaveName:"ORDER_MEASURE"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:300,	Type:"Text",	Header:"표준단가",	SaveName:"CMS_PRICE"}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:300,	Type:"Text",	Format:"Ymd", Header:"표준단가수정일",	SaveName:"CHANGE_DATE"}
					,{ Align:"Center",	Width:110,	Edit:false,	EditLen:300,	Type:"Text",	Header:"유통시너지품목여부",	SaveName:"KWAY_SYNERGY_FLAG"}
					,{ Align:"Center",	Width:75,	Edit:false,	EditLen:300,	Type:"Text",	Header:"유통취급여부",	SaveName:"KWAY_HANDLING_FLAG"}
					,{Align:"Center" ,Width:60, Edit:true, EditLen:110, Type : "Image", 	Header : "비고", SaveName : "REMARK_IMG"}
	    			,{Align:"Center" ,Width:100, Edit:true,	Hidden:true, Type : "Text", EditLen : 110,	 Header : "비고" ,SaveName : "REMARK"}
					,{ Align:"Right",	Width:50,	Edit:false,	EditLen:300,	Type:"Int", Format:"${qtyFormat}", Header:"매핑개수",	SaveName:"TOT_CNT"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:300,	Type:"Text",	Header:"매핑정보",	SaveName:"MAPPING"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"IMG_NO"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"DELIVERY_LT"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"ITEM_GROUP_TEXT"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"STD_TEXT"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"ITEM_GUBUN_TEXT"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"ON_OFF_TEXT"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"IMG_FLAG_TEXT"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"CMS_CATEG_ID"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"MAKER_CODE"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"ORIGIN_CODE"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"ITEM_GROUP"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"STD_FLAG"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"ITEM_GUBUN"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"ONOFF_TYPE"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"IMG_FLAG"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"CMS_USER_NAME"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"DESCRIPTION_ENG"}
					,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"CATEG_PATH"} ];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:4};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "CMS_CATLG_ID");
	setLinkCol(mySheet, "REMARK_IMG");
	setLinkCol(mySheet, "MAPPING");
	mySheet.SetDataLinkMouse("IMG", 1);
	//setLinkCol(mySheet, "IMG");
	
	//엑셀다운로드 sheet
	var initsheet2 = {};
	initsheet2.Cols = [  
	      			{Align : "Left",SaveName : "CATEG_PATH",		Header : "카테고리",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "SG_NAME",		Header : "소싱그룹",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "ADD_DATE",		Header : "등록일자",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "CMS_CATLG_ID",		Header : "MASTER코드",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "ADD_USER_NAME",		Header : "생성담당",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "DESCRIPTION_LOC",		Header : "품목명(한글)",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "DESCRIPTION_ENG",		Header : "품목명(영문)",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "ORIGIN_NAME",		Header : "원산지",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Right",SaveName : "CMS_PRICE",		Header : "표준단가",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "ORDER_MEASURE",		Header : "단위",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "KWAY_SYNERGY_FLAG",		Header : "유통시너지여부",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "CHANGE_DATE",		Header : "표준단가수정일",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "KWAY_HANDLING_FLAG",		Header : "유통취급여부",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "BUYER",		Header : "고객사",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "MAIN_PERSON",		Header : "담당자",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "REFER_MAPPING_FLAG",		Header : "매핑구분(완전/참조)",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "DESCRIPTION_LOC",		Header : "품목명",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Right",SaveName : "TARGET_PRICE",		Header : "매출단가",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Right",SaveName : "LIST_PRICE",		Header : "매입단가",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "CHANGE_DATE",		Header : "매입단가수정일",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "PO_ADD_DATE",		Header : "최종발주일(입고기준)",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "AGENT_NAME",		Header : "협력사",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "ABLE_DERIVERY_AREA",		Header : "배송가능지역",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	      			, {Align : "Left",SaveName : "DELIVERY_LT",		Header : "조달일수",	Type : "Text",	Width : 50,	Hidden:false, Edit : false}
	];
	
	IBS_InitSheet(mySheet2, initsheet2,pagingMode);
	
}
	
	
// 기능함수
function doAction(str) {

	// 항목 입력 유무 체크
	if (str =="search" || str =="excelDown") {
		var categ_id         = common.Trim($("#st_categ_id").val());
		var cmscatlg         = common.Trim($("#st_cmscatlg").val());
		var description_loc  = common.Trim($("#st_description_loc").val());
		var specification    = common.Trim($("#st_specification").val());
		var maker_name       = common.Trim($("#st_maker_name").val());
		var sg_name       = common.Trim($("#st_sg_name").val());
		
		$("#st_categ_id").val(categ_id);
		$("#st_cmscatlg").val(cmscatlg);
		$("#st_description_loc").val(description_loc);
		$("#st_specification").val(specification);
		$("#st_maker_name").val(maker_name);
		$("#st_sg_name").val(sg_name);
		
		if(categ_id == "" && cmscatlg == "" && description_loc == "" && specification == "" && maker_name == "" && sg_name == ""){
			alert("최소 한가지의 검색조건은 입력하여 주십시요");
			return;
		}
	}

	switch (str) {
	case "search":	 // 조회
		var categ_id         = common.Trim($("#st_categ_id").val());
		if(categ_id != ""){
			
			var property_search1 = $("#property_search1").val();
			var property_search2 = $("#property_search2").val();
			var property_search3 = $("#property_search3").val();
			var property_search4 = $("#property_search4").val();
			var property_search5 = $("#property_search5").val();
			var property_search6 = $("#property_search6").val();
			var property_search7 = $("#property_search7").val();
			var property_search8 = $("#property_search8").val();
			var property_search9 = $("#property_search9").val();
			var property_search10 = $("#property_search10").val();
			var property_search11 = $("#property_search11").val();
			var property_search12 = $("#property_search12").val();
			var property_search13 = $("#property_search13").val();
			var property_search14 = $("#property_search14").val();
			var property_search15 = $("#property_search15").val();
			var property_search16 = $("#property_search16").val();
			var property_search17 = $("#property_search17").val();
			var property_search18 = $("#property_search18").val();
			var property_search19 = $("#property_search19").val();
			var property_search20 = $("#property_search20").val();
			
			$("#st_value1").val(property_search1);
			$("#st_value2").val(property_search2);
			$("#st_value3").val(property_search3);
			$("#st_value4").val(property_search4);
			$("#st_value5").val(property_search5);
			$("#st_value6").val(property_search6);
			$("#st_value7").val(property_search7);
			$("#st_value8").val(property_search8);
			$("#st_value9").val(property_search9);
			$("#st_value10").val(property_search10);
			$("#st_value11").val(property_search11);
			$("#st_value12").val(property_search12);
			$("#st_value13").val(property_search13);
			$("#st_value14").val(property_search14);
			$("#st_value15").val(property_search15);
			$("#st_value16").val(property_search16);
			$("#st_value17").val(property_search17);
			$("#st_value18").val(property_search18);
			$("#st_value19").val(property_search19);
			$("#st_value20").val(property_search20);
		}
		
		current_page = -1;
		pagingMode = "N";
		kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmCmsCatalogList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$("#st_std_flag").val('Y');
		$("#cont_hiddenA").hide();
		
		$("#st_maker_code").val("");
		$("#st_categ_id").val("");
		$("#st_mast_check").val("");
		$("#st_categ_name").val("");
		$("#st_value1").val("");
		$("#st_value2").val("");
		$("#st_value3").val("");
		$("#st_value4").val("");
		$("#st_value5").val("");
		$("#st_value6").val("");
		$("#st_value7").val("");
		$("#st_value8").val("");
		$("#st_value9").val("");
		$("#st_value10").val("");
		$("#st_value11").val("");
		$("#st_value12").val("");
		$("#st_value13").val("");
		$("#st_value14").val("");
		$("#st_value15").val("");
		$("#st_value16").val("");
		$("#st_value17").val("");
		$("#st_value18").val("");
		$("#st_value19").val("");
		$("#st_value20").val("");
		
		mySheet.RemoveAll();
		break;

	case "excelDown": // 엑셀다운로드
		if (mySheet.RowCount() == 0){
			alert("조회된 데이터가 없습니다.  ");
			return;
		}
		
	    $("#pageflag").val('0');
		var param = {FileName:"masterMdCmCmsCatalogList.xlsx"};
		kepDownExcel(document.searchCondition ,mySheet2 , "/mdcm/excelMasterMdCmCmsCatalogList.do", param);
		$("#pageflag").val('1');
		break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	
	return DATA;
}
	
// 조회 후처리
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
	pagingMode = "P";
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmCmsCatalogList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "masterMpRqKepStndrdCategorySelPop": // 표준카테고리
			popupSel = "masterMpRqKepStndrdCategorySelPop";
			openSearchPopup("/mprq/showMasterMpRqKepStndrdCategorySelPop.do", "", "721,670,no");
			break;
			
		case "maker": // 제조사
			popupSel = "maker";
			openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if (column == "REMARK_IMG" ){ // 비고
		popupSel = "masterMdCmCmsCatalogRemarkPop";
		var remark = mySheet.GetCellValue(Row, "REMARK");
		openSearchPopup("/mdcm/getMasterMdCmCmsCatalogRemarkPop.do", '?st_remark='+remark, "700,310,no"); // CMS카탈로그 비고
	} else if (column == "MAPPING" ){ // 매핑정보
		popupSel = "masterMdCmGoodsInfoDetailPop";
		var st_cms_categ_id = mySheet.GetCellValue(Row, "CMS_CATEG_ID");
		var st_cms_catlg_id = mySheet.GetCellValue(Row, "CMS_CATLG_ID");
		openSearchPopup("/mdcm/showMasterMdCmGoodsInfoDetailPop.do", '?st_cms_categ_id='+st_cms_categ_id+'&st_cms_catlg_id='+st_cms_catlg_id, "800,700,no");// 품목정보 상세보기
		
	} else if (column == "IMG" ){ // 이미지
		var img_no = mySheet.GetCellValue(Row, "IMG_NO");
		var cms_catlg_id = mySheet.GetCellValue(Row, "CMS_CATLG_ID");
		//이미지 팝업 호출.
		getCmsImgPop(img_no, cms_catlg_id);

	} else if(column == "CMS_CATLG_ID"){ //MASTER코드 선택
		popupSel = "masterMdCmStndrdCatalogDetailViewPop";	
		var st_cms_categ_id = mySheet.GetCellValue(Row, "CMS_CATEG_ID");
		var st_cms_catlg_id = mySheet.GetCellValue(Row, "CMS_CATLG_ID");
		openSearchPopup("/mdcm/getMasterMdCmStndrdCatalogDetailViewPop.do", '?st_cms_categ_id='+st_cms_categ_id+'&st_cms_catlg_id='+st_cms_catlg_id, "990,710,no");
	}
 
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5){
	if (popupSel == "masterMpRqKepStndrdCategorySelPop") {	//KEP 표준카테고리 선택

		$("#st_categ_id").val(value3);
		$("#st_category_path").val(value4);
		$("#st_categ_name").val(value5);
		
		$("#st_value1").val("");
		$("#st_value2").val("");
		$("#st_value3").val("");
		$("#st_value4").val("");
		$("#st_value5").val("");
		$("#st_value6").val("");
		$("#st_value7").val("");
		$("#st_value8").val("");
		$("#st_value9").val("");
		$("#st_value10").val("");
		$("#st_value11").val("");
		$("#st_value12").val("");
		$("#st_value13").val("");
		$("#st_value14").val("");
		$("#st_value15").val("");
		$("#st_value16").val("");
		$("#st_value17").val("");
		$("#st_value18").val("");
		$("#st_value19").val("");
		$("#st_value20").val("");
		
		//표준카테고리 선택에 따른 속성 조회조건 추가.
		setSysopKssCategorySearch(value3, value5);
		
	}else if (popupSel == "maker") {	// 제조사
		$("#st_maker_code").val(value1);
		$("#st_maker_name").val(value2);
	}
 
	grbRow="";	//초기화
}

//표준 카테고리 속성 조회조건 추가
function setSysopKssCategorySearch(st_category_no,st_category_text,
		value1, value2, value3, value4, value5, value6, value7, value8, value9, value10,   
		value11, value12, value13, value14, value15, value16, value17, value18, value19, value20){

	var param =  { st_categ_id: st_category_no,st_category_text: st_category_text
							,st_value1: value1 ,st_value2: value2 ,st_value3: value3 ,st_value4: value4 ,st_value5: value5 
							,st_value6: value6 ,st_value7: value7 ,st_value8: value8 ,st_value9: value9 ,st_value10: value10 
							,st_value11: value11 ,st_value12: value12 ,st_value13: value13 ,st_value14: value14 ,st_value15: value15 
							,st_value16: value16 ,st_value17: value17 ,st_value18: value18 ,st_value19: value19 ,st_value20: value20 };
	kepAjaxHtmlCall("/mdcm/getCategoriAttributeList.do",param,"setSysopKssCategorySearch");
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxHtmlSuccess(pMethod , data) {

	if (pMethod == "setSysopKssCategorySearch") {
		$("#cont_hiddenA").show();
   	 	$("#cont_hiddenA").html(data);
		return;
	}
}

//ajax 공통 호출후 오류시 처리 함수
function  kepAjaxHtmlError(pMethod , response) {
	
	if (pMethod == "setSysopKssCategorySearch") {
		$("#cont_hiddenA").hide();
   	 	alert("오류발생하였습니다.");
		return;
	}
} 

function fn_categ_subPro(idx){
	var value = $("#property_search"+idx).val(); 
	$("#st_value"+idx).val(value);

	//콤보 재구성.
	setSysopKssCategorySearch(
	$("#st_categ_id").val(), $("#st_categ_name").val(),
	$("#st_value1").val(), $("#st_value2").val(), $("#st_value3").val(), $("#st_value4").val(), $("#st_value5").val(),
	$("#st_value6").val(), $("#st_value7").val(), $("#st_value8").val(), $("#st_value9").val(), $("#st_value10").val(), 
	$("#st_value11").val(), $("#st_value12").val(), $("#st_value13").val(), $("#st_value14").val(), $("#st_value15").val(), 
	$("#st_value16").val(), $("#st_value17").val(), $("#st_value18").val(), $("#st_value19").val(), $("#st_value20").val()
	);
	
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>CMS카탈로그</h3>
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
			<input type="hidden" id="st_value1" name="st_value1"  value ="">
			<input type="hidden" id="st_value2" name="st_value2"  value ="">
			<input type="hidden" id="st_value3" name="st_value3"  value ="">
			<input type="hidden" id="st_value4" name="st_value4"  value ="">
			<input type="hidden" id="st_value5" name="st_value5"  value ="">
			<input type="hidden" id="st_value6" name="st_value6"  value ="">
			<input type="hidden" id="st_value7" name="st_value7"  value ="">
			<input type="hidden" id="st_value8" name="st_value8"  value ="">
			<input type="hidden" id="st_value9" name="st_value9"  value ="">
			<input type="hidden" id="st_value10" name="st_value10"  value ="">
			<input type="hidden" id="st_value11" name="st_value11"  value ="">
			<input type="hidden" id="st_value12" name="st_value12"  value ="">
			<input type="hidden" id="st_value13" name="st_value13"  value ="">
			<input type="hidden" id="st_value14" name="st_value14"  value ="">
			<input type="hidden" id="st_value15" name="st_value15"  value ="">
			<input type="hidden" id="st_value16" name="st_value16"  value ="">
			<input type="hidden" id="st_value17" name="st_value17"  value ="">
			<input type="hidden" id="st_value18" name="st_value18"  value ="">
			<input type="hidden" id="st_value19" name="st_value19"  value ="">
			<input type="hidden" id="st_value20" name="st_value20"  value ="">
			
            	<table  class="cont_t_list01" >
					<caption>CMS카탈로그</caption> 
					<colgroup> 
						<col width="70px" /> 
						<col width="20%" />
						<col width="70px" /> 
						<col width="20%" />
						<col width="70px" /> 
						<col width="20%" />
						<col width="60px" />
						<col width="15%" />
					</colgroup> 				
					<tbody>
						<tr> 
							<th>제조사</th>
							<td>
								<input type="text" id="st_maker_name" name="st_maker_name"  maxlength="25"  value = "" class="input_type_text"  readonly>
								<a href="javascript:doPop('maker');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_maker_code','st_maker_name');"><img src="/resources/images/btn_eraser2.gif"></a>
								<input type="hidden" id="st_maker_code" name="st_maker_code" value = "">
							</td>
							<th>Master코드</th>
							<td>
								<input type="text" id="st_cmscatlg" name="st_cmscatlg" maxlength="25" value = "" class="input_type_text" onKeyDown="kepEnter()" onKeyUp="ToUpper(this)"> 
							</td> 
							<th>표준카테고리</th>
							<td colspan="3">
								<input type="text" id="st_category_path" name="st_category_path" maxlength="25"  value = "" class="input_type_text"  readonly>
								<a href="javascript:doPop('masterMpRqKepStndrdCategorySelPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_categ_id','st_category_path');"><img src="/resources/images/btn_eraser2.gif"></a>
								<input type="hidden" id="st_categ_id" name="st_categ_id" value = "">
              					<input type="hidden" id="st_mast_check" name="st_mast_check" value = "">
              					<input type="hidden" id="st_categ_name" name="st_categ_name"  value ="">
							</td>
						</tr>
						<tr>
							<th>SG</th>
							<td>
								<input type="text" id="st_sg_name"  name="st_sg_name"  maxlength="25" value = "" class="input_type_text" onKeyDown="kepEnter()"> 
							</td> 
							<th>품목명</th>
							<td>
								<input type="text" id="st_description_loc"  name="st_description_loc"  maxlength="25"  value = "" class="input_type_text" onKeyDown="kepEnter()"> 
							</td> 
							<th>규격</th>
							<td>
								<input type="text" id="st_specification"  name="st_specification"  maxlength="25"  value = "" class="input_type_text" onKeyDown="kepEnter()"> 
							</td> 
							<th>표준화여부</th>
							<td>
								<select id="st_std_flag" name="st_std_flag" style="width:60%;">
									<option value="Y" selected="selected">표준화</option>
									<option value="N" >미표준화</option>
								</select> 
							</td> 
						</tr> 
					</tbody>
				</table>
            </div>
            
            <div id="cont_hiddenA">
            	
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
				</select>
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
<!--                <div class="btnArea"> -->
<!--   	          	<span class="fl"> -->
<!--   					<span class="btn_03 mr04"><a href="javascript:doAction('excelDown');">다운로드</a></span> -->
<!--   				</span>  -->
<!--   			 </div> -->

<!--내용 종료-->	                 

</body>
</html>
