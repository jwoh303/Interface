<%--
**********************************************
* 메뉴 : 상품관리>고객사 카탈로그 관리>카탈로그 소싱 요청
* 화면 : 카탈로그 소싱 요청
* 기능 : 조직효율화 후 카탈로그 소싱 요청
* 프로그램 ID : 
* 담당자 : HSJ ( 설계 : HMH )
* 착수일 : 2022-09-06
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<script src="/resources/js/kep_common.js"></script>

<script>
<%
String contract_no = CommonUtil.nvl((String) request.getParameter("contract_no"), "");
%>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var excelLoadType = "";
var button_Flag = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.HeaderMode = {Sort : 0};
	initsheet.Cols = [ 
						 { Align:"Center",	Width:60,	Edit:false,	Type:"Status",		Header:"상태",			SaveName:"sStatus",	Hidden : true}
						,{ Align:"Center",	Width:40,	Edit:true,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED"}
						,{ Align:"Center",	Width:40,	Edit:false,	Type:"Text",		Header:"NO",			SaveName:"SEQ",	Hidden : true}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"요청타입",			SaveName:"REQ_TYPE",	Hidden : true}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"요청타입",			SaveName:"REQ_TYPE_TEXT"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"카탈로그관리코드",	SaveName:"BUYER"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"계약서번호",		SaveName:"CONTRACT_NO"}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"계약서항번",		SaveName:"CONTRACT_SEQ"}
						,{ Align:"Left",	Width:120,	Edit:false,	Type:"Text",		Header:"품목코드",			SaveName:"BUYER_ITEM_NO"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"갱신구분",			SaveName:"ITEM_FLAG",	Hidden : true}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"갱신구분",			SaveName:"ITEM_FLAG_TEXT"}
						,{ Align:"Left",	Width:200,	Edit:false,	Type:"Text",		Header:"품목명",			SaveName:"DESCRIPTION"}
						,{ Align:"Left",	Width:200,	Edit:false,	Type:"Text",		Header:"품목명_영문",		SaveName:"DESCRIPTION_ENG"}
						,{ Align:"Left",	Width:400,	Edit:false,	Type:"Text",		Header:"규격",			SaveName:"SPECIFICATION"}
						,{ Align:"Left",	Width:400,	Edit:false,	Type:"Text",		Header:"규격_영문",		SaveName:"SPECIFICATION_ENG"}
						,{ Align:"Left",	Width:120,	Edit:false,	Type:"Text",		Header:"모델번호",			SaveName:"MAKER_PART_NO"}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"단위",			SaveName:"UNIT_MEASURE"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"카테고리코드",		SaveName:"CATEGORY_NO"}
						,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",		Header:"카테고리명",		SaveName:"CATEG_NAME"}
						,{ Align:"Left",	Width:200,	Edit:false,	Type:"Text",		Header:"비고",			SaveName:"REMARK"}
						,{ Align:"Left",	Width:60,	Edit:false,	Type:"Text",		Header:"이미지파일",		SaveName:"IMGFILE_NAME", Hidden : true}
						,{ Align:"Left",	Width:60,	Edit:false,	Type:"Text",		Header:"이미지경로",		SaveName:"IMGFILE_DIR", Hidden : true}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"표준카테고리ID",	SaveName:"CMS_CATEG_ID"}
						,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",		Header:"표준카테고리명",	SaveName:"CMS_CATEG_TEXT"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"표준카탈로그ID",	SaveName:"CMS_CATLG_ID"}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"단종여부",			SaveName:"PRODUCT_CLOSE_FLAG"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"품목구분코드",		SaveName:"ITEM_MAKE_TYPE", Hidden : true}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"품목구분",			SaveName:"ITEM_MAKE_TYPE_TEXT"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"과세구분코드",		SaveName:"TAX_TYPE", Hidden : true}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"과세구분",			SaveName:"TAX_TYPE_TEXT"}
						
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"적용구분",			SaveName:"BELOW_COMORG_CODE"}
						,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",		Header:"고객사명",			SaveName:"BUYER_TEXT"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT_CODE"}
						,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",		Header:"협력사명",			SaveName:"AGENT_CODE_TEXT"}
						,{ Align:"Right",	Width:80,	Edit:false,	Type:"Float",		Header:"매출단가",			SaveName:"UNIT_PRICE",	Format:"${priceFormat}"}
						,{ Align:"Right",	Width:80,	Edit:false,	Type:"Float",		Header:"매입단가",			SaveName:"LIST_PRICE",	Format:"${priceFormat}"}
						,{ Align:"Right",	Width:60,	Edit:false,	Type:"Text",		Header:"조달일수",			SaveName:"DELIVERY_LT"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"거래유형코드",		SaveName:"PROCESS_TYPE", Hidden : true}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"거래유형",			SaveName:"PROCESS_TYPE_TEXT"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"제조사코드",		SaveName:"MAKER_CODE"}
						,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",		Header:"제조사명",			SaveName:"MAKER_CODE_TEXT"}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"원산지코드",		SaveName:"ORIGIN_CODE", Hidden : true}
						,{ Align:"Left",	Width:80,	Edit:false,	Type:"Text",		Header:"원산지",			SaveName:"ORIGIN_CODE_TEXT"}
						,{ Align:"Left",	Width:120,	Edit:false,	Type:"Text",		Header:"협력사품목코드",	SaveName:"SELLER_ITEM_NO"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"물류센터공급사",	SaveName:"ORIGIN_AGENT"}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"MOQ",			SaveName:"MIN_ORDER_QTY"}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"발주배수",			SaveName:"PUR_UNIT_QTY"}
						,{ Align:"Left",	Width:100,	Edit:false,	Type:"Text",		Header:"납품지역",			SaveName:"SELLER_AREA"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Date",		Header:"매출단가유효일",	SaveName:"TO_DATE"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Date",		Header:"매입단가유효일",	SaveName:"BUY_CLOSE_DATE"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"대체제안사유코드",	SaveName:"ANOTHER_OFFER_FLAG"}
						,{ Align:"Left",	Width:180,	Edit:false,	Type:"Text",		Header:"대체제안사유",		SaveName:"ANOTHER_OFFER_FLAG_TEXT"}
						,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",		Header:"대체제안내용",		SaveName:"ANOTHER_OFFER_NOTE"}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Text",		Header:"고객사프로파일등록",	SaveName:"PROFILE_YN", Hidden : true}
						
						,{ Align:"Left",	Width:120,	Edit:false,	Type:"Text",		Header:"녹색구매제품_명칭",	SaveName:"BUY_GREEN_ITEM_NM"}
						,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",		Header:"녹색구매제품_인증번호",	SaveName:"BUY_GREEN_ITEM_CNO"}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Date",		Header:"녹색구매제품_시작일",	SaveName:"BUY_GREEN_ITEM_FROM_DATE"}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Date",		Header:"녹색구매제품_종료일",	SaveName:"BUY_GREEN_ITEM_TO_DATE"}
						
						,{ Align:"Left",	Width:60,	Edit:false,	Type:"Text",		Header:"KEP품목명",		SaveName:"KEP_DESCRIPTION", Hidden : true}
						,{ Align:"Left",	Width:60,	Edit:false,	Type:"Text",		Header:"KEP규격",			SaveName:"KEP_SPECIFICATION", Hidden : true}
						,{ Align:"Left",	Width:60,	Edit:false,	Type:"Text",		Header:"KEP단위",			SaveName:"KEP_UNIT_MEASURE", Hidden : true}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"KEP제조사코드",	SaveName:"KEP_MAKER_CODE", Hidden : true}
						,{ Align:"Left",	Width:60,	Edit:false,	Type:"Text",		Header:"KEP제조사명",		SaveName:"KEP_MAKER_NAME", Hidden : true}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"KEP원산지코드",	SaveName:"KEP_ORIGIN_CODE", Hidden : true}
						,{ Align:"Left",	Width:60,	Edit:false,	Type:"Text",		Header:"KEP원산지",		SaveName:"KEP_ORIGIN_NAME", Hidden : true}
						,{ Align:"Left",	Width:60,	Edit:false,	Type:"Text",		Header:"KEP모델번호",		SaveName:"KEP_MAKER_PART_NO", Hidden : true}
						
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"등록자ID",		SaveName:"ADD_USER_ID",	Hidden : true}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"등록자명",			SaveName:"ADD_USER_NAME",	Hidden : true}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"등록일시",			SaveName:"ADD_DATE",	Hidden : true}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"변경자ID",		SaveName:"CHANGE_USER_ID",	Hidden : true}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"변경자명",			SaveName:"CHANGE_USER_NAME",	Hidden : true}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"변경일시",			SaveName:"CHANGE_DATE",	Hidden : true}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:9};
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
}
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	var maxRow  = mySheet.RowCount();
	
	//선택된 항목 유무 체크
	if (str =="del" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		pagingMode = "N";
		kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmCatalogRegReqList.do" , pagingMode );
		
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		
		$("#st_buyer_code").val("");
		
		break;
	
	case "save": // 등록 요청
		var buyer	= $("#st_buyer_code").val();
		var buyer_name	= $("#st_buyer_name").val();
		button_flag = "save";
		
		if (mySheet.RowCount() == 0){
			alert("조회된 데이터가 없습니다.  ");
			return;
		}
		
		for(var i=1; i<=maxRow; i++){
			//표준카테고리 입력여부 확인.
			var cms_categ_name = mySheet.GetCellValue(i,"CMS_CATEG_TEXT");
			if(cms_categ_name == ""){
				mySheet.SelectCell(i, "CMS_CATEG_TEXT");
				alert("표준카테고리를 확인하여 주시기 바랍니다.");
				return;
			}
			
			//품목명,규격 좌우 공백 제거
			trimValue(arrRow[i]);
			
			// 품목명 확인
			var description = mySheet.GetCellValue(i,"DESCRIPTION");
			if(description == ""){
				mySheet.SelectCell(i, "DESCRIPTION");
				alert("품명은 필수 입력사항입니다.");
				return;
			}
			
			// 규격 확인
			var specification = mySheet.GetCellValue(i,"SPECIFICATION");
			if(specification == ""){
				mySheet.SelectCell(i, "SPECIFICATION");
				alert("규격은 필수 입력사항입니다.");
				return;
			}
			
			// 품목코드 입력여부 확인
			var buyer_item_no = mySheet.GetCellValue(i,"BUYER_ITEM_NO");
			if(buyer_item_no == ""){
				mySheet.SelectCell(i, "BUYER_ITEM_NO");
				alert("품목코드는 필수 입력사항입니다.");
				return;
			}
			
			// 고객사 프로파일 등록 여부
			var buyer_item_no = mySheet.GetCellValue(i,"PROFILE_YN");
			if(buyer_item_no == "N"){
				mySheet.SelectCell(i, "BELOW_COMORG_CODE");
				alert("고객사 프로파일을 먼저 등록하시기 바랍니다.");
				return;
			}
			
			// 적용구분 확인(CQDT 존재 확인용, 카탈로그 키값이 잘 맞다면 적용구분 존재할 것임)
			var below_comorg_code = mySheet.GetCellValue(i,"BELOW_COMORG_CODE");
			if(below_comorg_code == ""){
				mySheet.SelectCell(i, "BUYER_ITEM_NO");
				alert("해당 정보와 매칭되는 카탈로그가 존재하지 않습니다.");
				return;
			}
		}
		
<%if(!"".equals(contract_no)){%>
		cc = confirm("선택여부 상관없이 업로드된 모든 건이 등록됩니다.\n소싱요청번호가 존재하는 경우 모든 건들은 해당 소싱요청번호로 등록됩니다.\n전부 등록요청 하시겠습니까?");
<%}else{%>
		cc = confirm("선택여부 상관없이 업로드된 모든 건이 등록됩니다.\n전부 등록요청 하시겠습니까?");
<%}%>
		if(cc){
			kepSaveAll(document.searchCondition, mySheet, "/mdcm/saveMasterMdCmCatalogRegReqList.do");
		}else {
			return;
		}
		
		break;
		
	case "del":	//삭제
		if (mySheet.RowCount() == 0){
			alert("조회된 데이터가 없습니다.  ");
			return;
		}
		
		if (selectedGrid.length == 0){
			alert("삭제할 대상을 선택해 주십시요. ");
			return;
		}
		
		if (!confirm("선택된 내역을 삭제 하시겠습니까?  ")) {
			return;
		}else{
			kepSave(document.searchCondition ,  mySheet , "/mdcm/delMasterMdCmCatalogRegReqList.do" , "SELECTED" );	
		}
		
		break;	
		
	case "loadExcelReg": // 신규 업로드
		excelLoadType = str;	
		mySheet.RemoveAll();
		var params = { Mode : "HeaderMatch" };
		//var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"|||1||2|3||4|||5|6|7|8|9|10|11||12|32|33|13||14||15||16||17||18||19|20|21|22||24||25||26|23|27|28|29|30|31||||5|7|10|24||25||9|||||||"};
		mySheet.LoadExcel(params);

		break;
		
	case "loadExcelReNew": // 재계약 업로드
		excelLoadType = str;
		mySheet.RemoveAll();
		
		var params = { Mode : "HeaderMatch" };
		//var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"|||1||2|3|4|5||||||||||||||||||||||||||||||||||||||||||6||8|||||||||||||||"};
		mySheet.LoadExcel(params);

		break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
		,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
		,value21,value22,value23,value24,value25,value26,value27,value28,value29){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 고객사
		//그룹을 선택할 수 없도록 처리.
		if(value4 == "1"){
			alert("그룹은 선택할 수 없습니다.");
			return;
		}
		
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
		mySheet.RemoveAll();
	}
	
	mySheet.SetCellValue(grbRow, 'SELECTED', '1');
	grbRow="";	//초기화
}

function mySheet_OnLoadExcel() {
	var maxRow  = mySheet.RowCount();
	
	if(maxRow == 0){
		  return;
	}
	
	if (5001 < maxRow + 1) {
		alert("5000건이하의 파일만 업로드하여 주세요.");
		mySheet.RemoveAll();
		return;
	}
	
	for(var i=1; i<=maxRow; i++){
		mySheet.SetCellValue(i,"SELECTED","1");
		
		var g_buyer = mySheet.GetCellValue(i,"BUYER");
		var g_contract_no = mySheet.GetCellValue(i,"CONTRACT_NO");
		var g_contract_seq = mySheet.GetCellValue(i,"CONTRACT_SEQ");
		var g_buyer_item_no = mySheet.GetCellValue(i,"BUYER_ITEM_NO");
			
		if(excelLoadType == "loadExcelReg"){ // 신규등록
			if(g_buyer == "" || g_contract_no == "" || g_buyer_item_no == ""){
				mySheet.RemoveAll();
				alert("업로드 파일의 필수값을 확인하시기 바랍니다.");
				return;
			}
		
			if(g_contract_seq != ""){
				mySheet.RemoveAll();
				alert("업로드 양식 유형을 확인하시기 바랍니다.");
				return;
			}
		}else{ // 기등록
			if(g_buyer == "" || g_contract_no == "" || g_contract_seq == "" || g_buyer_item_no == ""){
				mySheet.RemoveAll();
				alert("업로드 양식 유형 or 필수값을 확인하시기 바랍니다.");
				return;
			}
		}
	}
	
	if(excelLoadType == "loadExcelReg"){
		kepSave(document.searchCondition ,  mySheet , "/mdcm/batchMasterMdCmCatalogRegReq.do" , "SELECTED" );
	}else{
		kepSave(document.searchCondition ,  mySheet , "/mdcm/batchMasterMdCmCatalogRegRenew.do" , "SELECTED" );
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
		alert(msg.msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		if(button_Flag == "save"){ // 등록요청 클릭 후 소싱요청번호 초기화 
			$("#st_contract_no").val("");	
		}
		button_flag = "";
		excelLoadType = "";
		doAction('search');
	}
}

//페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/mdcm/getMasterMdCmCatalogRegReqList.do?page="+current_page, pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;
	}
}

//그리드 셀 변경시 이벤트
//SLOGIC-BEGIN(P03-3010-01)
function mySheet_OnChange(Row, Col, Value) {
	var column = mySheet.ColSaveName(Col);
	grbRow = Row; //현재 Row를 전역변수에 셋팅
	
	if(column == "DESCRIPTION"){    //품목명 입력시
		mySheet.SetCellValue(Row,"DESCRIPTION", FilterString(Value));
		mySheet.SetCellValue(Row,"DESCRIPTION_ENG", FilterString(Value));
		mySheet.SetCellValue(Row,"KEP_DESCRIPTION", FilterString(Value));
	}
	
	if(column == "SPECIFICATION"){ //규격 입력시
		mySheet.SetCellValue(Row,"SPECIFICATION", FilterString(Value));
		mySheet.SetCellValue(Row,"SPECIFICATION_ENG", FilterString(Value));
		mySheet.SetCellValue(Row,"KEP_SPECIFICATION", FilterString(Value));
	}
}
//SLOGIC-END

function FilterString(val){

    var str= "";
    // 특수문자 아스키코드 값
    // $    ==> 36
    // '    ==> 39
    // "    ==> 34
    // ^    ==> 94
    for(var i=0;i<val.length;i++){
        if(val.charCodeAt(i) == 36){
		      str+=val.charAt(i).replace("$", "＄");
			}else if(val.charCodeAt(i) == 39) {
				  str+=val.charAt(i).replace("'", "′");
			}else if(val.charCodeAt(i) == 34) {
				  str+=val.charAt(i).replace("\"", "″");
			}else if(val.charCodeAt(i) == 94) {
				  str+=val.charAt(i).replace("^", "＾");
			}else if(val.charCodeAt(i) == 60) {
				  str+=val.charAt(i).replace("<", "〈");
			}else if(val.charCodeAt(i) == 62) {
				  str+=val.charAt(i).replace(">", "〉");
			}else {
				  str+=val.charAt(i);
			}
    }
    return str;
}

//품목명,규격 좌우 공백 제거
function trimValue(row){ 
	  var ch_desc = $.trim(mySheet.GetCellValue(row,"DESCRIPTION"));
	  var ch_spec = $.trim(mySheet.GetCellValue(row,"SPECIFICATION"));
	  mySheet.SetCellValue(row, "DESCRIPTION", ch_desc);
	  mySheet.SetCellValue(row, "SPECIFICATION", ch_spec);
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA">
			<h3>카탈로그 소싱 요청</h3>
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
			<input type="hidden" id="st_user_name" name="st_user_name"  value="${sessionInfo.userNameLoc}">
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
			
            	<table  class="cont_t_list01" >
					<caption>카탈로그 소싱 요청</caption>
					<colgroup>
						<col width="10%" />
						<col width="40%" />
						<col width="10%" />
						<col width="40%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:55%" value="" readonly onclick="doPop('buyer_single');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:80%;" value="" onkeydown="kepEnter()">
							</td>
						</tr>
						<tr> 
							<th>품목명</th>
				      		<td>
				      			<input type="text" class="input_type_text"  name="st_description" id="st_description" style="width:80%;" value="" onKeyDown="kepEnter()">
				      		</td>
				      		<th>규격</th>
				      		<td>
				      			<input type="text" class="input_type_text"  name="st_specification" id="st_specification" style="width:80%;" value="" onKeyDown="kepEnter()">
				      		</td>
						</tr>
					</tbody>
				</table>
            </div>
            
			<span style="position:absolute; left:0;"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
				<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="50">50건</option>
					<option value="100">100건</option>
					<option value="500">500건</option>
					<option value="1000">1000건</option>
					<option value="5000">5000건</option>
				</select>
			</span>
			<br/>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea" style="margin-bottom:0px;">
  	          	<span class="fl">
  					<span class="btn_06 mr04"><a href="/resources/excel/work/CATALOG/masterMdCmCatalogRegReq.xls">신규등록양식</a></span>
  					<span class="btn_04 mr04"><a href="javascript:doAction('loadExcelReg');">신규업로드</a></span>
  					<span class="btn_04 mr04"><a href="/resources/excel/work/CATALOG/masterMdCmCatalogRegReNew.xls">기등록양식</a></span>
  					<span class="btn_06 mr04"><a href="javascript:doAction('loadExcelReNew');">기등록업로드</a></span>
  				</span>
  				
  				<span style="text-align: center; vertical-align:center;">
  				소싱요청번호 : 
  				<input type="text" id="st_contract_no" name="st_contract_no" style="width:100px;" ReadOnly value="<%=contract_no%>"/>
  				</span>&nbsp;&nbsp;
  				
  				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
					<span class="btn_02 mr04"><a href="javascript:doAction('save');">등록요청</a></span>
  				</span>
  			 </div>
  			 <br>
  			 <b><font color="red">※ 신규/기등록에 따른 업로드 양식을 주의하시기 바랍니다.</font></b><br>
  			 <b><font color="red">※ 업로드 시 기존의 업로드 내용은 동일 업로드 유형은 전부 삭제 후, 새로 업로드됩니다.</font></b>
		</form>
<!--내용 종료-->	                 
</body>
</html>
