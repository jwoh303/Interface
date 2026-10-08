<%--
**********************************************
* 메뉴 : I/F 관리>오류현황>오류현황 발주
* 화면 : 오류현황 발주
* 기능 :
* 프로그램 ID : PG_11_M_002_00
* 담당자 : 최명진 ( 설계 : 김상근 )
* 착수일 : 2014-
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
<%
	String searchYn		= CommonUtil.nvl((String)request.getParameter("search_yn"));
	String buyerCode	= CommonUtil.nvl((String)request.getParameter("st_buyer_code"));
	String buyerName	= CommonUtil.nvl((String)request.getParameter("st_buyer_name"));
	String st_user_check = CommonUtil.nvl((String)request.getParameter("st_user_check"));
	String st_user_dept = CommonUtil.nvl((String)request.getParameter("st_user_dept"));
	String processYN = CommonUtil.nvl((String)request.getParameter("processYN"));
	String sessionEmpNo = _sessionInfo.getEmpNo();
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var imageG="/resources/images/icon_g.gif";
var imageY="/resources/images/icon_y.gif";
var imageR="/resources/images/icon_r.gif";
var imageB="/resources/images/icon_b.gif";
var imageBl="/resources/images/icon_bl.gif";
var imagePrifC="/resources/images/icon_prif_c.gif";
var imagePrifR="/resources/images/icon_prif_r.gif";
var imagePrifCancel="/resources/images/icon_prif_cancel.gif";
var imagePrifDelete="/resources/images/icon_prif_delete.gif";
var searchYn = "<%=searchYn%>";
var processYN ="<%=processYN%>";
var selectDiv = 'E';
var isBtnAcc = true;

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
		,{ Align:"Center",	Width:50,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Image",			Header:"I/F상태",			SaveName:"IF_PROGRESS_PODT"}
		,{ Align:"Center",	Width:50,		Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"I/F상태",			SaveName:"IF_FLAG_PROGRESS"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"고객사명",			SaveName:"BUYER_NAME"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"고객사코드",		SaveName:"BUYER"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"KeP부서",			SaveName:"KEP_DEPT"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"주문번호",			SaveName:"LEGACY_PO_NO"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"주문항번",			SaveName:"LEGACY_PO_SEQ"}
		,{ Align:"Center",	Width:55,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Image",			Header:"상태(IF)",			SaveName:"IF_STATUS",				FontColor:"#1e90ff"}
		,{ Align:"Center",	Width:55,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Image",			Header:"상태(PR)",			SaveName:"PR_STATUS",				FontColor:"#1e90ff"}
		,{ Align:"Center",	Width:55,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Image",			Header:"상태(PO)",			SaveName:"PO_STATUS",				FontColor:"#1e90ff"}
		,{ Align:"Center",	Width:55,		Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"상태(IF)",			SaveName:"IF_EXCEL"}
		,{ Align:"Center",	Width:55,		Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"상태(PR)",			SaveName:"PR_EXCEL"}
		,{ Align:"Center",	Width:55,		Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"상태(PO)",			SaveName:"PO_EXCEL"}
		,{ Align:"Left",	Width:160,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"오류내역",			SaveName:"ERROR_MSG"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:25,	Hidden:false,	Type:"Text",				Header:"품목코드",			SaveName:"BUYER_ITEM_NO",			FontColor:"#1e90ff"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"품목명",				SaveName:"DESCRIPTION"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"규격",				SaveName:"SPECIFICATION"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"매입단가",				SaveName:"PRCHS"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"매입가",				SaveName:"PRCHS_AMT"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"매출가",				SaveName:"UNIT_PRICE_AMT"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"매익",				SaveName:"PRF_AMN"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"매익율",				SaveName:"MARGIN_RETE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"관리번호",			SaveName:"LEGACY_PR_NO"}
		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"판매단가",			SaveName:"UNIT_PRICE_PAN"}
		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"IF단가",				SaveName:"UNIT_PRICE_IF"}
		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"발주단가",			SaveName:"UNIT_PRICE_PO"}		
		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"IF외화단가",			SaveName:"EXP_FOR_UNIT_PRICE_PODT"}
		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"IF외화금액",			SaveName:"EXP_FOR_ITEM_AMT"}
		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"판매외화단가",			SaveName:"EXP_FOR_UNIT_PRICE_CUR"}
		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"판매외화금액",			SaveName:"EXP_FOR_UNIT_PRICE_AMT"}
		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"외화단가 변동률",			SaveName:"EXP_FOR_RATE"}
		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"외화 손익금액",			SaveName:"EXP_FOR_LOSS_AMT"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"외화화폐단위",			SaveName:"EXP_CUR"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"환율",			SaveName:"BUYER_EXP_CUR_PRICE"}
		,{ Align:"Center",	Width:140,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"고객사 단가반영 매출단가",			SaveName:"BUYER_PRICE_PAN"}
		,{ Align:"Center",	Width:140,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"고객사 단가반영 매출가",			SaveName:"BUYER_PRICE_AMT"}
		,{ Align:"Center",	Width:140,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"고객사 단가반영 매익",			SaveName:"BUYER_PRF_AMN"}
		,{ Align:"Center",	Width:140,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"고객사 단가반영 후 매익율",			SaveName:"BUYER_MARGIN_RETE"}
		,{ Align:"Right",	Width:60,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"IF수량",				SaveName:"ITEM_QTY_IF"}
		,{ Align:"Right",	Width:60,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"발주수량",			SaveName:"ITEM_QTY_PO"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"IF협력사",			SaveName:"COM_NAME_IF"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"협력사",				SaveName:"COM_NAME_PO"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"IF요청일",			SaveName:"RD_DATE_IF"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"납품요구일",		SaveName:"RD_DATE_PO"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:190,	Hidden:false,	Type:"Text",				Header:"발주자ID",			SaveName:"PURCHASER_USER_ID",	FontColor:"#1e90ff",			Sort:0}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"발주부서",			SaveName:"PURCHASER_USER_DEPT"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"그룹코드",			SaveName:"BYIT_COMORG_CODE"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"적용조직레벨",		SaveName:"COMORG_LEVEL"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"IF발주일",			SaveName:"ADD_DATE"}
		,{ Align:"Left",	Width:150,	Edit:false,	EditLen:190,	Hidden:false,	Type:"Text",				Header:"요청자정보",		SaveName:"REQ_USER_INFO"}
		,{ Align:"Center",	Width:70,		Edit:false,	EditLen:190,	Hidden:false,	Type:"Text",				Header:"도착지코드",		SaveName:"DELY_TO_LOCATION",	Sort:0}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:90,	Hidden:false,	Type:"Text",				Header:"IF도착지정보",				SaveName:"DELY_TO_LOCATION_TEXT"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:190,	Hidden:true,	Type:"Text",				Header:"계약서번호",		SaveName:"CONTRACT_NO"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:190,	Hidden:true,	Type:"Text",				Header:"계약서행번",		SaveName:"CONTRACT_SEQ"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:190,	Hidden:true,	Type:"Text",				Header:"납품유형",			SaveName:"DOC_TYPE"}
		,{ Align:"Center",	Width:70,		Edit:false,	EditLen:190,	Hidden:false,	Type:"Text",				Header:"발주유형",			SaveName:"PO_TYPE",					FontColor:"#1e90ff",		KeyField:true,		Sort:0}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:90,	Hidden:false,	Type:"Text",				Header:"선입고정보",		SaveName:"REMARK2"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:90,	Hidden:false,	Type:"Text",				Header:"참조",				SaveName:"REF_IF_NO"}
		,{ Align:"Left",	Width:300,	Edit:false,	EditLen:90,	Hidden:false,	Type:"Text",				Header:"비고",				SaveName:"REMARK"}
		,{ Align:"Left",	Width:70,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Text",				Header:"거래유형",			SaveName:"IVDT_TYPE"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"협력사코드",		SaveName:"AGENT"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:90,	Hidden:false,	Type:"Text",				Header:"협력사명",			SaveName:"AGENT_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"ORG품목코드",		SaveName:"ORG_BUYER_ITEM_NO"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"발주자미등록",		SaveName:"PURCHASER_USER_ID_ERR_FLAG"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"요구일오류",		SaveName:"RD_DATE_ERR_FLAG"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"발주일오류",		SaveName:"PO_DATE_ERR_FLAG"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"품목코드미등록",	SaveName:"BUYER_ITEM_ERR_FLAG"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"판매단가불일치",	SaveName:"UNIT_PRICE_ERR_FLAG"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Date",				Header:"생성일자",			SaveName:"CREATE_DATE"}
		,{ Align:"Center",	Width:70,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Date",				Header:"생성시간",			SaveName:"CREATE_TIME",			Format:"Hms"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Date",				Header:"작업일자",			SaveName:"LOAD_DATE"}
		,{ Align:"Center",	Width:70,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Date",				Header:"작업시간",			SaveName:"LOAD_TIME",				Format:"Hms"}
		,{ Align:"Left",	Width:90,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",			Header:"구매요청번호",			SaveName:"PR_NO_B"}
		,{ Align:"Left",	Width:90,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",			Header:"구매요청순번",			SaveName:"PR_SEQ_B"}		
		,{ Align:"Left",	Width:90,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",			Header:"발주번호",			SaveName:"PO_NO"}
		,{ Align:"Left",	Width:90,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",			Header:"발주항번",			SaveName:"PO_SEQ"}		
		,{ Align:"Left",	Width:90,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",			Header:"플랜트",			SaveName:"PLANT"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Date",			Header:"삭제일자",			SaveName:"CANCEL_DATE"}
		,{ Align:"Left",	Width:300,	Edit:false,	EditLen:90,	Hidden:false,	Type:"Text",			Header:"삭제사유",			SaveName:"CANCEL_RSON"}		
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:190,	Hidden:false,	Type:"Text",		Header:"삭제자ID",			SaveName:"CANCEL_ID"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:190,	Hidden:false,	Type:"Text",		Header:"상신번호",			SaveName:"GW_NO"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:190,	Hidden:false,	Type:"Text",		Header:"상신상태",			SaveName:"GW_STATUS"}
	];

// 	initsheet.HeaderMode = { Sort : 0, ColMove : 1, ColResize : 1 };
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	// 상태이미지설정
	mySheet.SetImageList(0, imageG);
	mySheet.SetImageList(1, imageY);
	mySheet.SetImageList(2, imageR);
	mySheet.SetImageList(7, imageB);
	mySheet.SetImageList(8, imageBl);

	mySheet.SetImageList(3, imagePrifC);
	mySheet.SetImageList(4, imagePrifR);
	mySheet.SetImageList(5, imagePrifCancel);
	mySheet.SetImageList(6, imagePrifDelete);

	// 하이퍼링크 설정
	setLinkCol(mySheet, "IF_STATUS");				//상태(IF)
	setLinkCol(mySheet, "PR_STATUS");				//상태(PR)
	setLinkCol(mySheet, "PO_STATUS");				//상태(PO)
	setLinkCol(mySheet, "BUYER_ITEM_NO");		//품목코드
	setLinkCol(mySheet, "PURCHASER_USER_ID");	//발주자ID
	setLinkCol(mySheet, "PO_TYPE");					//발주유형
	setLinkCol(mySheet, "DELY_TO_LOCATION");	// 도착지코드

	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	// 초기화 설정
	resetValue();
	
	$("#st_buyer_code").val("<%=buyerCode%>");
	$("#st_buyer_name").val("<%=buyerName%>");
	var st_user_check = "<%=st_user_check%>";
	if(st_user_check== "Y"){
		$('#st_user_check').prop('checked',true);
	}
	if(processYN == "Y"){
		kepAjaxCommonQueryIdCombo('st_user_dept','getKepDeptList','', '<%=st_user_dept%>'); // 조회조건 : 부서
	}
	if(searchYn == "Y"|| processYN == "Y"){
		doAction("search");
	}
}

// 초기화 설정
function resetValue() {
	// 조회일자 설정
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));

	// 콤보데이터 셋팅
	kepAjaxCommonQueryIdCombo('st_user_dept','getKepDeptList','ALL','${sessionInfo.department}');


	// checkbox 설정
	$("input:checkbox[id='st_user_check']").attr("checked",false);
	$("input:checkbox[id='st_date_flag']").attr("checked",false);
	$("input:checkbox[id='st_date_flag']").attr("checked",false);
	/* $("input:checkbox[id='st_if_flag']").attr("checked",true); */	

	// 조회조건 hidden 설정
	$("#st_buyer_code").val("");
}

var st;
var mt;

// 그리드 표시후 처리
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	
	// 선택된 항목 유무 체크
	if ( str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0 ) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	// 삭제만 조회 버튼 비활성화
	if ( str !="search" && str !="excelDown" && str !="reload" && !isBtnAcc ) {
		alert("이미 삭제된 데이터 입니다.");
		return;
	}
	
	if ( str == "search" ) {
		isBtnAcc = selectDiv == 'D' ? false : true;
		// 담당자 무시 checkbox
		var isCheckUser = $("#st_user_check").is(":checked");

		if ( isCheckUser ) {
			$("#st_user_check_value").val("Y");
		} else {
			$("#st_user_check_value").val("N");
		}

		// 삭제만 조회 checkbox
		if( selectDiv == 'D' && $("#st_legacy_po_no").val() == ""){						
			alert('주문번호를 입력해주세요');
			return;
		}			
// 			 $('.fr').children('span').bind('click',false).addClass('btn_disabled');
// 		}else{
// 			 $('.fr').children('span').unbind('click',false).removeClass('btn_disabled');
// 		}	 
		
		// 기간 무시 checkbox
		var isCheckDate = $("#st_date_flag").is(":checked");		
		if ( isCheckDate ) {
			if(($("#st_legacy_pr_no").val() == "" && $("#st_legacy_po_no").val() == "") ){
				alert('주문번호나 관리번호를 입력해주세요');
				return;
			}
			$("#st_date_flag_value").val("Y");
		} else {
			$("#st_date_flag_value").val("N");
		}

		// 20230823 select list로 변경
		// 오류만 조회 checkbox
		/* var isCheckIF = $("#st_if_flag").is(":checked"); */

		/* if ( isCheckIF ) {
			$("#st_if_flag_value").val("Y");
		} else {
			$("#st_if_flag_value").val("N");
		} */	
		
	}	
	
	switch (str) {
		case "search": // 조회
			// 조회조건 체크
			if ( !searchValidate() )
				return;
			current_page = -1;
			$("#job_kind").val("");
			kepSearch(document.searchCondition,  mySheet , "/mpif/getMasterMpIfErrorStateMainList.do" , pagingMode );
			break;

		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;

		case "execute": // 실행
			if (!validationChange())
				return;
			if (!confirm('선택한 항목을 실행 하시겠습니까?'))
				return;
			$("#job_kind").val("execute");
			kepSave(document.searchCondition, mySheet, "/mpif/saveMasterMpIfErrorStateMainList.do", "SELECTED");
			break;

		case "partial": // 부분발주
			if (!validationChange())
				return;
			if (!confirm('선택한 항목의 오류건을 제외하고 발주처리 하시겠습니까?'))
				return;
			$("#job_kind").val("partial");
			kepSave(document.searchCondition, mySheet, "/mpif/saveMasterMpIfErrorStateMainList.do", "SELECTED");
			break;

		case "save": // 저장
			if (!gwStatusChk()) //상신중 체크
				return;
			if (!confirm('선택한 항목을 저장 하시겠습니까?'))
				return;
			$("#job_kind").val("save");
			kepSave(document.searchCondition, mySheet, "/mpif/saveMasterMpIfErrorStateMainList.do", "SELECTED");
			break;

		case "delete": // 발주 삭제(종결)
			if (!gwStatusChk()) //상신중 체크
				return;
			if (!validationChange())
				return;
			$("#job_kind").val("delete");
			kepSave(document.searchCondition ,  mySheet , "/mpif/delMasterMpIfErrorStateMainList.do" , "SELECTED" );
			break;

		case "excelDown": // 엑셀다운로드
		    $("#pageflag").val('0');
			var param = {FileName:"오류현황_발주.xlsx",Merge:1,SheetDesign:1,DownCols:"IF_FLAG_PROGRESS|BUYER_NAME|LEGACY_PO_NO|LEGACY_PO_SEQ|PO_NO|PO_SEQ|IF_EXCEL|PR_EXCEL|PO_EXCEL|ERROR_MSG|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|PRCHS|PRCHS_AMT|UNIT_PRICE_AMT|PRF_AMN|MARGIN_RETE|LEGACY_PR_NO|UNIT_PRICE_PAN|UNIT_PRICE_IF|UNIT_PRICE_PO|ITEM_QTY_IF|ITEM_QTY_PO|COM_NAME_IF|COM_NAME_PO|RD_DATE_IF|RD_DATE_PO|PURCHASER_USER_ID|ADD_DATE|REQ_USER_INFO|DELY_TO_LOCATION|PLANT|EXP_FOR_UNIT_PRICE_PODT|EXP_FOR_UNIT_PRICE_CUR|BUYER_EXP_CUR_PRICE|BUYER_PRICE_PAN|BUYER_PRICE_AMT|BUYER_PRF_AMN|BUYER_MARGIN_RETE|PO_TYPE|REMARK2|REF_IF_NO|REMARK|IVDT_TYPE|AGENT_NAME|CREATE_DATE|CREATE_TIME|LOAD_DATE|LOAD_TIME"};
			kepDownExcel(document.searchCondition ,mySheet , "/mpif/excelMasterMpIfErrorStateMainList.do", param);
			$("#pageflag").val('1');
			break;
		
		case "modDate":
			var arrRow = selectedGrid.split("|");
			for(var i = 0 ; i <arrRow.length; i++){
 	 			if(isEmpty(mySheet.GetCellValue(arrRow[i],'RD_DATE_IF'))){
	 					alert('납품요구일 정보가 없습니다. ');
	 					mySheet.SelectCell(arrRow[i], 'RD_DATE_IF', 1);
	 					return;
	 			}
 	 			if(isEmpty(mySheet.GetCellValue(arrRow[i],'BUYER'))){
 					alert('고객사정보가 없습니다.');
 					mySheet.SelectCell(arrRow[i], 'BUYER_NAME', 1);
 					return;
 				}
 	 			if(isEmpty(mySheet.GetCellValue(arrRow[i],'PR_NO_B') )){
 					alert('구매요청번호 정보가 없습니다. ');
 					mySheet.SelectCell(arrRow[i], 'PR_NO_B', 1);
 					return;
 			    }
 	 			if(isEmpty(mySheet.GetCellValue(arrRow[i],'PR_SEQ_B') )){
 					alert('구매요청순번 정보가 없습니다.');
 					mySheet.SelectCell(arrRow[i], 'PR_SEQ_B', 1);
 					return;
 			    }
 	 
 	 			if(mySheet.GetCellValue(arrRow[i],'PR_STATUS') == imagePrifDelete){
 	 				alert('상태(PR)가  없음 상태에서는 변경 할 수 없습니다.');
 					mySheet.SelectCell(arrRow[i], 'PR_STATUS', 1);
 					return;
 	 			}
 	 			if(mySheet.GetCellValue(arrRow[i],'PO_STATUS') ==imagePrifDelete){
 	 				alert('상태(PO)가  없음 상태에서는 변경 할 수 없습니다.');
 					mySheet.SelectCell(arrRow[i], 'PO_STATUS', 1);
 					return;
 	 			}
 	 			
			}
			if (!confirm('선택한 항목의 납품요구일을 변경 하시겠습니까?'))
				return;
			$("#job_kind").val("modDate");
			kepSave(document.searchCondition, mySheet, "/mpif/updateMasterMpIfErrorStateMain_RdDateIF.do", "SELECTED");
			break;
		case "SandApprl": //삼성전자 품의 상신 
			if (!gwStatusChk()) //상신중 체크  
				return;
			if (!errCurChk()) //상신중 체크  
				return;
			$("#job_kind").val("SandApprl");
			kepSave(document.searchCondition, mySheet, "/mpif/updateIfPoListInfoApprList.do", "SELECTED");
			break;
	}
}
function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

}
// 조회조건 체크
function searchValidate() {
	var start_date = $("#st_from_date").val().replace(/[/]/gi,"");
	var end_date = $("#st_to_date").val().replace(/[/]/gi,"");

	if ( start_date > end_date ) {
		alert("발주 종료일은 시작일보다 작을 수 없습니다.");
		return false;
	}
	if ( kepTrim("st_buyer_code") == '' ) {
		alert("고객사를 선택해 주십시오");
		return false;
	}

	return true;
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if (msg != "") {
		alert(msg);
	}

	if ( current_page == -1 ) {
		makePageIndex2(mySheet, 1, document.searchCondition.onepagerow.value);
	}
	else {
		makePageIndex2(mySheet, current_page, document.searchCondition.onepagerow.value);
	}


		for( var k = 1;  k<mySheet.GetTotalRows()+1 ; k++ ) {
			// 품목코드 미등록시
			
			if ( mySheet.GetCellValue(k, "BUYER_ITEM_ERR_FLAG") == 'Y' ) {
				mySheet.SetCellEditable(k, "BUYER_ITEM_NO", 1);
				
			}
			// 요청일 오류시
			if ( mySheet.GetCellValue(k, "RD_DATE_ERR_FLAG") == 'Y' ) {
				mySheet.SetCellEditable(k, "RD_DATE_IF", 1);
			}
			// 발주자 미등록시
			if ( mySheet.GetCellValue(k, "PURCHASER_USER_ID_ERR_FLAG") == 'X' ) {
				mySheet.SetCellBackColor(k, "PURCHASER_USER_ID", "#F9C9DF");
			}
			// 발주일 오류시
			if ( mySheet.GetCellValue(k, "PO_DATE_ERR_FLAG") == 'Y' ) {
				mySheet.SetCellEditable(k, "ADD_DATE", 1);
			}
			
			//발주유형이 없을때 
			if ( mySheet.GetCellValue(k, "DOC_TYPE") == '' ) {
				mySheet.SetCellValue(k, "DOC_TYPE", 'N');
				mySheet.SetCellValue(k, "PO_TYPE", '일반');
			}
		}

}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if ( msg != "" ) {
		if ( $("#job_kind").val() != "SandApprl" ) { //삼성전자 품의 상신 
			alert(msg);
		}
	}

	if ( code >= 0 ) {
		if ( $("#job_kind").val() == "delete" ) {
			$("#st_cancel_remark").val("");
		}
		
		if ( $("#job_kind").val() == "modDate" ) {
			alert('정상적으로 변경 되었습니다.');
		}
		if ( $("#job_kind").val() == "SandApprl" ) { //삼성전자 품의 상신 
			gw_aprv(msg);
		}
		// 저장 성공시 재조회
		doAction("search");
	}
}

//삼성전자 품의 상신 
function gw_aprv(msg){
	var gw_kep_no = msg;
	var bodyContents =	
		"<style> .SmallTB{border:1px solid #000; font-size:12px} .SmallTB th{ text-align:center; background-color:#e8f3f9;border-right:1px solid #000;border-bottom:1px solid #000;} .SmallTB td{ height:25px;border-bottom:1px solid #000; padding-left:5px}</style>"+
		"<table class=\"SmallTB\" cellSpacing=\"0\" cellPadding=\"0\">"+
		"<tbody>"+
		"<tr >"+
	 	"<th >주문번호</th>"+
		"<th >주문항번</th>"+
		"<th >발주일</th>"+
		"<th >납품요구일</th>"+
		"<th >품번</th>"+
		"<th >발주수량</th>"+
		"<th >단가</th>"+
		"<th >삼성외화단가</th>"+
		"<th >삼성외화금액</th>"+
		"<th >KEP외화단가</th>"+
		"<th >KEP외화금액</th>"+
		"<th >외화단가 변동률</th>"+
		"<th >외화 손익금액</th>"+
		"</tr>";
		for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++){	
			if (mySheet.GetCellValue(i, "SELECTED") == '1'){
				bodyContents += "<tr>"  
				+"<td>"+ mySheet.GetCellValue(i, "LEGACY_PO_NO") +"</td>"
				+"<td>"+ mySheet.GetCellValue(i, "LEGACY_PO_SEQ") +"</td>"
				+"<td>"+ mySheet.GetCellValue(i, "ADD_DATE") +"</td>"
				+"<td>"+ mySheet.GetCellValue(i, "RD_DATE_IF") +"</td>"
				+"<td>"+ mySheet.GetCellValue(i, "BUYER_ITEM_NO") +"</td>"
				+"<td>"+ mySheet.GetCellValue(i, "ITEM_QTY_IF") +"</td>"
				+"<td>"+ mySheet.GetCellValue(i, "UNIT_PRICE_PAN") +"</td>"
				+"<td>"+ mySheet.GetCellValue(i, "EXP_FOR_UNIT_PRICE_PODT") +"</td>"
				+"<td>"+ mySheet.GetCellValue(i, "EXP_FOR_ITEM_AMT") +"</td>"
				+"<td>"+ mySheet.GetCellValue(i, "EXP_FOR_UNIT_PRICE_CUR") +"</td>"
				+"<td>"+ mySheet.GetCellValue(i, "EXP_FOR_UNIT_PRICE_AMT") +"</td>"
				+"<td>"+ mySheet.GetCellValue(i, "EXP_FOR_RATE") +"</td>"
				+"<td>"+ mySheet.GetCellValue(i, "EXP_FOR_LOSS_AMT") +"</td>"
				+"</tr>";
			}
		}
	 	"</tbody>"+
		"</table>"
		;
		
	 	var form = document.createElement("form");
		form.setAttribute("method", "post");
		form.setAttribute("target", "_blank");
		form.setAttribute("action", "https://gw.koreab2b.com/jsp/kep_linkage/InQdbData.jsp");

		var hiddenField01 = document.createElement("input");
		hiddenField01.setAttribute("type", "hidden");
		hiddenField01.setAttribute("name", "DrafterCode");
		hiddenField01.setAttribute("value", <%=sessionEmpNo%>);
		form.appendChild(hiddenField01);
		var hiddenField02 = document.createElement("input");
		hiddenField02.setAttribute("type", "hidden");
		hiddenField02.setAttribute("name", "FormID");
		hiddenField02.setAttribute("value", "JHOMS160070008591000,LINK001");
		form.appendChild(hiddenField02);
		
		var hiddenField03 = document.createElement("input");
		hiddenField03.setAttribute("type", "hidden");
		hiddenField03.setAttribute("name", "LinkageKey");
		hiddenField03.setAttribute("value", "B07");
		form.appendChild(hiddenField03);
		
		var hiddenField04 = document.createElement("input");
		hiddenField04.setAttribute("type", "hidden");
		hiddenField04.setAttribute("name", "LinkageSub1");
		hiddenField04.setAttribute("value", gw_kep_no);
		form.appendChild(hiddenField04);
		
		var LinkageSub2 = document.createElement("input");
		LinkageSub2.setAttribute("type", "hidden");
		LinkageSub2.setAttribute("name", "LinkageSub2");
		LinkageSub2.setAttribute("value", "");
		form.appendChild(LinkageSub2);
		
		var LinkageSub3 = document.createElement("input");
		LinkageSub3.setAttribute("type", "hidden");
		LinkageSub3.setAttribute("name", "LinkageSub3");
		LinkageSub3.setAttribute("value", "");
		form.appendChild(LinkageSub3);
		
		var LinkageSub4 = document.createElement("input");
		LinkageSub4.setAttribute("type", "hidden");
		LinkageSub4.setAttribute("name", "LinkageSub4");
		LinkageSub4.setAttribute("value", "");
		form.appendChild(LinkageSub4);
		
		var LinkageSub5 = document.createElement("input");
		LinkageSub5.setAttribute("type", "hidden");
		LinkageSub5.setAttribute("name", "LinkageSub5");
		LinkageSub5.setAttribute("value", "");
		form.appendChild(LinkageSub5);			
		
		var hiddenField05 = document.createElement("input");
		hiddenField05.setAttribute("type", "hidden");
		hiddenField05.setAttribute("name", "SancTitle");
		hiddenField05.setAttribute("value", "[품의] 환율변경에 따른 발주정보 수정의 건");
		form.appendChild(hiddenField05);
		
		var SacnBodyType = document.createElement("input");
		SacnBodyType.setAttribute("type", "hidden");
		SacnBodyType.setAttribute("name", "SacnBodyType");
		SacnBodyType.setAttribute("value", "TEXT");
		form.appendChild(SacnBodyType);	
		
		var hiddenField06 = document.createElement("input");
		hiddenField06.setAttribute("type", "hidden");
		hiddenField06.setAttribute("name", "SancBody");
		hiddenField06.setAttribute("value", bodyContents);
		form.appendChild(hiddenField06);
		
		var AttachYN = document.createElement("input");
		AttachYN.setAttribute("type", "hidden");
		AttachYN.setAttribute("name", "AttachYN");
		AttachYN.setAttribute("value", "N");
		form.appendChild(AttachYN);
		
		var AttachInfo = document.createElement("input");
		AttachInfo.setAttribute("type", "hidden");
		AttachInfo.setAttribute("name", "AttachInfo");
		AttachInfo.setAttribute("value", "");
		form.appendChild(AttachInfo);
		
		document.charset="UTF-8";
		document.body.appendChild(form);
		form.submit();
		
		// 그룹웨어 전송 후 캐릭터 셋 복원
		document.charset="utf-8";
		doAction('search'); 
}


// Valitation - 변경 여부
function validationChange() {
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
        if ( mySheet.GetCellValue(i, "sStatus") != 'R' ) {
			alert(i + "번째 데이터에 변경된 내역이 존재합니다.\n\n수정내역을 저장해 주십시오.");
			return false;
		}
	}

	return true;
}

//상신중 체크 발리데이터 체크 
function gwStatusChk() {
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
        if ( mySheet.GetCellValue(i, "GW_NO") != '' && mySheet.GetCellValue(i,"SELECTED") =="1" ) {
			alert("상신중인 발주가 포함되어 있습니다.\n\n상신중인 발주는 저장, 삭제, 품의가 불가 합니다.\n\n필요시 SR요청 부탁드립니다.");
			return false;
		}
	}

	return true;
}

//상신중 체크 발리데이터 체크 
function errCurChk() {
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
        if (mySheet.GetCellValue(i, "ERROR_MSG").indexOf('외화단가 불일치') == -1 && mySheet.GetCellValue(i,"SELECTED") =="1") {
			alert("외화단가 불일치 오류 상태가 아닌 발주가 포함되어 있습니다.\n\n외화단가 불일치 오류가 아닌 발주는 해당 기능 사용 불가 합니다.");
			return false;
		}else if(mySheet.GetCellValue(i, "BUYER") != 'KRSAMS0123' && mySheet.GetCellValue(i,"SELECTED") =="1" & mySheet.GetCellValue(i, "BUYER") != 'KRSAMS0140' && mySheet.GetCellValue(i,"SELECTED") =="1"){
			alert("해당 기능은 삼성만 사용 가능 하십니다.");
			return false;
		}
	}
	return true;
}


// Valitation - 발주 삭제(종결)
function validationDelete() {
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
        if ( mySheet.GetCellValue(i, "SELECTED") == 1 && mySheet.GetCellValue(i, "IF_FLAG_PROGRESS") == 'D' ) {
			alert("이미 종결된 건이 존재합니다.");
			return false;
		}
	}

	return true;
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param) {
	// 조회
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpIfErrorStateMainList.do?page="+current_page , pagingMode);
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;

	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if ( column == 'IF_STATUS' || column == 'PR_STATUS' || column == 'PO_STATUS' ) { // 상태(IF, PR, PO)
		window.open( "/resources/html/common/popup/mpif/masterMpIfOrderPop.html" ,"mpIfErrorState", "width=400,height=250,toolbar=no,location=no,resizable=yes,menubar=no,status=no,scrollbars=no");

	} else if ( column == 'BUYER_ITEM_NO' ) { // 품목코드
		if ( mySheet.GetCellValue(Row, "BUYER_ITEM_ERR_FLAG") == 'N' ) {
			var buyer = mySheet.GetCellValue(Row, "BUYER");
			var buyerItemNo = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
			var purchaserUserDept = mySheet.GetCellValue(Row, "PURCHASER_USER_DEPT");
			var byitComorgCode = mySheet.GetCellValue(Row, "BYIT_COMORG_CODE");
			var comorgLevel = mySheet.GetCellValue(Row, "COMORG_LEVEL");
			var params = '?BUYER='+buyer+'&BUYER_ITEM_NO='+buyerItemNo+'&PURCHASER_USER_DEPT='+purchaserUserDept+'&BYIT_COMORG_CODE='+byitComorgCode+'&COMORG_LEVEL='+comorgLevel;

			doPop("masterMpIfOrderStatusPop", params);
		}

	} else if ( column == 'PURCHASER_USER_ID' ) { // 발주자ID
		if ( mySheet.GetCellValue(Row, "PURCHASER_USER_ID_ERR_FLAG") == 'X' ) {
			var com_code = mySheet.GetCellValue(Row, "BUYER");
			var params = '?com_code='+com_code+'&open=O';

			doPop("user", params);
		}

	} else if ( column == 'PO_TYPE' ) { // 발주유형
		doPop("masterMpIfOrderTypePop", '');

	} else if ( column == 'DELY_TO_LOCATION' ){ // 도착지코드
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var params = '?com_code='+buyer+'&open=Y';

		doPop("delLocationPop", params);
	}

	return;
}

// 헤더 더블클릭 이벤트
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	
	if ( checkRows.length == 0 ) {
// 		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	
	var arrRow = checkRows.split("|");
	
	if ( mySheet.ColSaveName(Col) == "PURCHASER_USER_ID" ) { // 발주자ID
		var value1 = mySheet.GetCellValue(arrRow[0], "PURCHASER_USER_ID");
// 		if ( kepIsValueNull(value1) ) {
// 			alert("복사할 부서를 입력하여 주십시요.");
// 			return;
// 		}
		for ( var idx=0; idx<arrRow.length; idx++ ) {
			if ( mySheet.GetCellValue(arrRow[idx], "PURCHASER_USER_ID_ERR_FLAG") == 'X' ) { // 발주자 미등록시
				mySheet.SetCellValue(arrRow[idx], "PURCHASER_USER_ID", value1);
			}
		}
	}
	else if ( mySheet.ColSaveName(Col) == 'PO_TYPE' ) { // 발주유형
		var value1 = mySheet.GetCellValue(arrRow[0], "DOC_TYPE");
		var value2 = mySheet.GetCellValue(arrRow[0], "PO_TYPE");
	
		for ( var idx=0; idx<arrRow.length; idx++ ) {
			mySheet.SetCellValue(arrRow[idx], "DOC_TYPE", value1);
			mySheet.SetCellValue(arrRow[idx], "PO_TYPE", value2);
		}
	}
	else if ( mySheet.ColSaveName(Col) == 'DELY_TO_LOCATION' ) { // 도착지코드
		var value1 = mySheet.GetCellValue(arrRow[0], "DELY_TO_LOCATION");
	
		for ( var idx=0; idx<arrRow.length; idx++ ) {
			mySheet.SetCellValue(arrRow[idx], "DELY_TO_LOCATION", value1);
		}
	}
}

// 팝업함수호출
function doPop(str, params) {
	popupSel = str;

	if(str == 'cancelRemark' && !isBtnAcc){
		alert("이미 삭제된 데이터 입니다.");
		return;	
	}
	
	switch (str) {
		case "masterWmCoTranBuyerPop": // 다중 거래고객사
			var st_user_dept = $("#st_user_dept").val();			
			var ischecked = $("#st_user_check").is(":checked");
			var check_yn = '';
			if ( ischecked ) {
				check_yn = "Y";
			} else {
				check_yn = "N";
			}
// 			kepOpenSearchPopup(popupSel, '?st_user_dept='+st_user_dept+'&st_user_check='+check_yn);
			openSearchPopup("/wmco/showMasterWmCoTranBuyerPop.do", "?st_user_dept="+st_user_dept+"&st_user_check="+check_yn+'&Gubun=PO', "500,500,no");
			break;

		case "buyerMulti": // 다중 고객사
// 	        openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=Y", "500,466,no"); // 1Grid
	        openSearchPopup('/common/safetyCompanyCodePop.do','?COM_TYPE=B', '880,450,no'); // 2Grid
			break;
			
		case "user": // 사용자선택
// 			kepOpenSearchPopup(popupSel, params);
			openSearchPopup("/common/misUserSelectAllPop.do", params, "500,500,no");
			break;

		case "masterMpIfOrderStatusPop": // 협력사 변경
// 			kepOpenSearchPopup('masterMpIfOrderStatusPop',params);
			openSearchPopup("/mpif/showMasterMpIfOrderStatusPop.do", params, "800,340,no");
			break;

		case "masterMpIfOrderTypePop": // 발주유형 변경
// 			kepOpenPopup('masterMpIfOrderTypePop');
			openSearchPopup("/mpif/showMasterMpIfOrderTypePop.do", params, "400,220,no");
			break;

		case "cancelRemark": // I/F 종결 사유
			//if ( !validationDelete() )
			//	return;
			var cancel_remark = $("#st_cancel_remark").val();
// 			kepOpenSearchPopup(popupSel, '?viewType=interfaceCancel&cancel_remark='+cancel_remark);
			openSearchPopup("/common/remarkCancelPop.do", '?viewType=interfaceCancel&cancel_remark='+cancel_remark, "500,230,no");
			break;
			
		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=00000083p&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
			
		case "delLocationPop": // 도착지코드 팝업
			openSearchPopup("/common/delLocationPop.do", params, "500,500,no");
			break;
		
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7, value8, value9){
// 	alert(value1 + ":" + value2 + ":" + value3 + ":" + value4 + ":" + value5);

	// 팝업 조회후 해당 항목에 값을 셋팅
	if ( popupSel == "masterWmCoTranBuyerPop" ) { // 다중 거래고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}
	else if ( popupSel == "buyerMulti" ) { // 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	}
	else if ( popupSel == "user" ) { // 사용자선택
		mySheet.SetCellValue(grbRow, "PURCHASER_USER_ID", value1);
	}
	else if ( popupSel == "masterMpIfOrderStatusPop" ) { // 협력사 변경
		var UNIT_PRICE_IF = mySheet.GetCellValue(grbRow, "UNIT_PRICE_IF");

		mySheet.SetCellValue(grbRow, "AGENT", value1);
		mySheet.SetCellValue(grbRow, "AGENT_NAME", value2);
		mySheet.SetCellValue(grbRow, "CONTRACT_NO", value3);
		mySheet.SetCellValue(grbRow, "CONTRACT_SEQ", value4);

		if ( mySheet.GetCellValue(grbRow, "UNIT_PRICE_ERR_FLAG") == 'Y' ) {
			if(UNIT_PRICE_IF == 0 || value9 == "Y"){
				mySheet.SetCellValue(grbRow, "UNIT_PRICE_IF", value8);
			}
		}
	}
	else if ( popupSel == "masterMpIfOrderTypePop" ) { //발주유형 변경
		if(value1== 'N'|| value1=='S'){
			mySheet.SetCellValue(grbRow, "DOC_TYPE", value1);
			mySheet.SetCellValue(grbRow, "PO_TYPE", value2);
		}

	}
	else if ( popupSel == "cancelRemark" ) { // I/F 종결 사유
		$("#st_cancel_remark").val(value1);
		doAction('delete');
	}
	else if ( popupSel == "delLocationPop" ){ // 도착지코드
		mySheet.SetCellValue(grbRow, "DELY_TO_LOCATION", value1);
	}

	grbRow="";	//초기화
}

// 삭제만 조회 컨트롤러
function delete_OnChange(value){	
	selectDiv = $("#st_select_div").val();
	if(selectDiv == 'D'){
		$("#st_date_flag_value").val("Y");	
		$("input:checkbox[id='st_date_flag']").prop("checked",true);
		$("input:checkbox[id='st_date_flag']").prop("disabled",true);
	}else{		
		$("input:checkbox[id='st_date_flag']").prop("disabled",false);
	}	
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>발주오류현황</h3>
		<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
	    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	    <span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
	</div>

	<!--조회영역-->
    <form name = "searchCondition" method = "post" onsubmit="return false" >
		<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="job_kind" name="job_kind" value="">
			<input type="hidden" id="st_cancel_remark" name="st_cancel_remark" value="">

           	<table  class="cont_t_list01">
				<caption>발주오류현황</caption>
				<colgroup>
					<col width="5%" />
					<col width="20%" />
					<col width="5%" />
					<col width="30%" />
					<col width="5%" />
					<col width="17%" />
				</colgroup>

				<tbody>
					<tr>
						<th><font color="#FF6600">*</font>고객사</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:70%" value="" readonly onclick="javascript:doPop('buyerMulti','');">
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
							<a href="javascript:doPop('masterWmCoTranBuyerPop','');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th>KeP팀명</th>
						<td>
							<select id="st_user_dept" name="st_user_dept" style="width:70%;height:20px"></select>
							<input type="checkbox" class="Noborder" id="st_user_check" name="st_user_check" value="N"> 담당자 무시
							<input type="hidden" id="st_user_check_value" name="st_user_check_value" value="N">
						</td>
						<th>오류내역</th>	
						<td>
							<input type="text" class="input_type_text" id="st_err_text" name="st_err_text" style="width:80%;" value="" onkeydown="kepEnter()"></td>
					</tr>
					<tr>
						<th>주문번호</th>
						<td>
							<input type="text" class="input_type_text" id="st_legacy_po_no" name="st_legacy_po_no" style="width:80%;" value="" onkeydown="kepEnter()">
						</td>
						<th>발주일자</th>
						<td>
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:80px; text-align:center;" value="">
							&nbsp;~&nbsp;
							<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:80px; text-align:center;" value="">
							<input type="checkbox" class="Noborder" id="st_date_flag" name="st_date_flag" value="N"> 기간 무시
							<input type="hidden" id="st_date_flag_value" name="st_date_flag_value" value="N">
						</td>
						
							<th>발주상태</th>
						<td>
							<select id="st_select_div" name="st_select_div" style="width:80%;height:20px" onchange="delete_OnChange(value)">
									<option value='A'>전체조회(삭제데이터 제외)</option>
									<option value='E' selected>오류만 조회</option>
									<option value='D'>삭제만 조회</option>
							</select>
							<!-- <input type="checkbox" class="Noborder" id="st_if_flag" name="st_if_flag" value="N"> 오류만 조회
							<input type="hidden" id="st_if_flag_value" name="st_if_flag_value" value="N"> -->
						</td>
					</tr>
					<tr>
						<th>관리번호</th>
						<td>
							<input type="text" class="input_type_text" id="st_legacy_pr_no" name="st_legacy_pr_no" style="width:80%;" value="" onkeydown="kepEnter()">
						</td>
						<th>품목코드</th>
						<td>
							<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:80%;" value="" onkeydown="kepEnter()">
						</td>
						<th>&nbsp;&nbsp;
							
						</th>
						<td></td>
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
		</span>
		<span class="fl">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
		<span class="fl">
			<img src="/resources/images/icon_g.gif" style="padding-top:3px;"/>&nbsp;정상&nbsp;&nbsp;
			<img src="/resources/images/icon_r.gif" style="padding-top:3px;"/>&nbsp;오류건&nbsp;&nbsp;
			<img src="/resources/images/icon_y.gif" style="padding-top:3px;"/>&nbsp;발주생성중&nbsp;&nbsp;
			<img src="/resources/images/icon_b.gif" style="padding-top:3px;"/>&nbsp;삭제건&nbsp;&nbsp;
			<img src="/resources/images/icon_bl.gif" style="padding-top:3px;"/>&nbsp;품의상신중&nbsp;&nbsp;
		</span>
		<br>
	</form>

    <!--grid-->
   	<div class="ib_product" style="border-top:2px solid #3c639c">
		<script type="text/javascript">
			createIBSheet("mySheet", "100%", "333px");
		</script>
  	</div>
  	<p class="paging" id="pageindex"></p>

	<!--버튼영역-->
	<div class="btnArea">
  		<span class="fl">
  			<span class="btn_05 mr04" ><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  		</span>

  		<span class="fr">
  			<c:if test="${sessionInfo.department eq '123' || sessionInfo.department eq '095'}">
   				<span class="btn_08 mr04"><a href="javascript:doAction('SandApprl');">삼성외화단가품의</a></span> 	
   			</c:if>
   			<span class="btn_07 mr04"><a href="javascript:doAction('modDate');">납품요구일변경</a></span> 		
  			<span class="btn_02 mr04"><a href="javascript:doAction('execute');">실행</a></span>
  			<span class="btn_04 mr04"><a href="javascript:doAction('partial');">제외발주</a></span>
  			<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
  			<span class="btn_02"><a href="javascript:doPop('cancelRemark','');">삭제</a></span>
  		</span>
	</div>

<!--내용 종료-->

</body>
</html>
