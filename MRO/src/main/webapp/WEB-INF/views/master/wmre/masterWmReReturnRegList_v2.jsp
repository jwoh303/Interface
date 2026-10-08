<%--
**********************************************
* 메뉴 : 반품>반품관리>반품등록
* 화면 : 반품등록
* 기능 : 
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-09-15
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
	String buyer = "";
	String userid = "";
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
	} 
	String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_po_user_id"),""); 
	String whAdmin = _sessionInfo.getWhAdmin();
	String hyunYN = _sessionInfo.getUserId();
%> 
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var fileOn = "/resources/images/disk_on.gif";
var comWare = KepSheetComboQueryIdData('common.getTypeWM01','','');	
var comWare = KepSheetComboQueryIdData('common.getTypeWM01','','');	
var comWare = KepSheetComboQueryIdData('common.getTypeWM01','','');
var tr_yn = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() { 
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"선택|선택",				SaveName:"SELECTED"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"접수번호|접수번호",			SaveName:"WMRE_NO"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"발주정보 |고객사코드",		SaveName:"BUYER"}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"발주정보 |고객사명",			SaveName:"BUYER_NAME"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주정보 |발주번호",			SaveName:"PO_NO"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주정보 |발주순번",			SaveName:"PO_SEQ"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주정보 |IF발주번호",		SaveName:"LEGACY_PO_NO"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주정보 |IF발주순번",		SaveName:"LEGACY_PO_SEQ"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"발주정보 |품목코드",			SaveName:"BUYER_ITEM_NO"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주정보 |품목명",			SaveName:"DESCRIPTION"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주정보 |규격",			SaveName:"SPECIFICATION"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"발주정보 |제조사명",			SaveName:"MAKER_NAME"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"발주정보 |발주수량",			SaveName:"ITEM_QTY",		Format:"${qtyFormat}"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"발주정보 |납품수량",			SaveName:"IV_QTY",			Format:"${qtyFormat}"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주정보 |단위",			SaveName:"UNIT_MEASURE"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"발주정보 |협력사코드",		SaveName:"SELLER"}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주정보 |협력사명",			SaveName:"SELLER_NAME"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주정보 |출고구분명",		SaveName:"PROCESS_TYPE_NM"}
					
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사요청정보 |고객요청부서명",	SaveName:"BUYER_DEPT_NAME"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사요청정보 |고객요청자",	SaveName:"BUYER_PERSON_NAME"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사요청정보 |고객연락처",	SaveName:"BUYER_PERSON_TEL"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float",		Header:"고객사요청정보 |매출단가",		SaveName:"UNIT_PRICE",		Format:"${qtyFormat}"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float",		Header:"고객사요청정보 |반품금액",		SaveName:"WMRE_AMT",		Format:"${qtyFormat}"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"고객사요청정보 |요청수량",		SaveName:"WMRE_QTY",		Format:"${qtyFormat}"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사요청정보 |요청구분",		SaveName:"WMRE_TYPE_NAME"}
					
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"운영사접수정보 |접수센터명",	SaveName:"WAREHOUSE_NAME"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"운영사접수정보 |접수자명",		SaveName:"M_REC_USER_NAME"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"운영사접수정보 |고객사담당팀",	SaveName:"KEP_DEPT_NAME"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"운영사접수정보 |고객사담당자",	SaveName:"KEP_USER_NAME"}
					
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"사유정보 |귀책대상",			SaveName:"WMRE_TYPE2_NAME"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"사유정보 |귀책사유",			SaveName:"WMRE_TYPE3_NAME"}
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"사유정보 |귀책상세사유",		SaveName:"WMRE_TYPE_DETAIL"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"사유정보 |파일첨부",			SaveName:"WMRE_FILE_IMG"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"사유정보 |진행상태",			SaveName:"FLAG_NAME"}
					
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"반품진행정보 |고객사 요청",		SaveName:"B_REQ_DATE",		Format:"Ymd"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"반품진행정보 |운영사 접수",		SaveName:"M_REC_DATE",		Format:"Ymd"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"반품진행정보 |협력사 접수",		SaveName:"S_REC_DATE",		Format:"Ymd"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"반품진행정보 |물류센터 회수",	SaveName:"W_GR_DATE",		Format:"Ymd"}
					,{ Align:"Right",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"반품진행정보 |물류센터 회수 수량",SaveName:"W_GR_QTY",		Format:"${qtyFormat}"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"반품진행정보 |물류센터 반출",	SaveName:"W_RIV_DATE",		Format:"Ymd"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"반품진행정보 |물류센터 출고방법",SaveName:"W_IVK_TYPE_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"반품진행정보 |협력사 입고",		SaveName:"S_GR_DATE",		Format:"Ymd"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"반품진행정보 |물류센터 교환입고",SaveName:"W_CHGR_DATE",		Format:"Ymd"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"반품진행정보 |물류센터 교환납품",SaveName:"W_CHDELI_DATE",	Format:"Ymd"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"반품진행정보 |협력사 교환납품",	SaveName:"S_CHDELI_DATE",	Format:"Ymd"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"반품진행정보 |운영사 마감",		SaveName:"M_CLOSE_DATE",	Format:"Ymd"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"반품진행정보 |종결",			SaveName:"END_DATE",		Format:"Ymd"}		
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"반품진행정보 |운영사 취소",		SaveName:"CANCEL_DATE",		Format:"Ymd"}
					
					,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"결재상태|결재상태",				SaveName:"APPR_STATUS_NM"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Text",	Header:"APPR_STATUS|APPR_STATUS",	SaveName:"APPR_STATUS"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태|상태",					SaveName:"sStatus"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"WMRE_TYPE|WMRE_TYPE",		SaveName:"WMRE_TYPE"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"WMRE_REMARK|WMRE_REMARK",	SaveName:"WMRE_REMARK"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ADD_USER_ID|ADD_USER_ID",	SaveName:"ADD_USER_ID"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"WAREHOUSE_CODE|WAREHOUSE_CODE",	SaveName:"WAREHOUSE_CODE"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"M_CLOSE_FLAG|M_CLOSE_FLAG",	SaveName:"M_CLOSE_FLAG"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CANCEL_FLAG|CANCEL_FLAG",	SaveName:"CANCEL_FLAG"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"발주번호 |출고구분",				SaveName:"PROCESS_TYPE"}
					,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"WMRE_FILE|WMRE_FILE",		SaveName:"WMRE_FILE"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"사유정보 |진행상태",				SaveName:"FLAG"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"B_REQ_FLAG|B_REQ_FLAG",		SaveName:"B_REQ_FLAG"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"반품진행정보 |운영사 접수",			SaveName:"M_REC_FLAG"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"S_REC_FLAG|S_REC_FLAG",		SaveName:"S_REC_FLAG"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"W_GR_FLAG|W_GR_FLAG",		SaveName:"W_GR_FLAG"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"W_RIV_FLAG|W_RIV_FLAG",		SaveName:"W_RIV_FLAG"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"W_IVK_FLAG|W_IVK_FLAG",		SaveName:"W_IVK_FLAG"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"S_GR_FLAG|S_GR_FLAG",		SaveName:"S_GR_FLAG"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"W_CHGR_FLAG|W_CHGR_FLAG",	SaveName:"W_CHGR_FLAG"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"W_CHDELI_FLAG|W_CHDELI_FLAG",	SaveName:"W_CHDELI_FLAG"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"S_CHDELI_FLAG|S_CHDELI_FLAG",	SaveName:"S_CHDELI_FLAG"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"APPR_GW_NO|APPR_GW_NO",		SaveName:"APPR_GW_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Date",	Header:"반품진행정보 |물류센터 출고",		SaveName:"W_IVK_DATE",		Format:"Ymd"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"물품수령여부|물품수령여부",		SaveName:"DELIVERY_FLAG"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);
	
	kepAjaxCommonQueryIdSearchTwoCombo('st_add_usr_id','common.masterDepartmentUserList','PG_10_M_006_00','','ALL','${sessionInfo.userId}'); 
	kepAjaxCommonQueryIdCombo('st_dept_code','master.mdcd.selectMasterMdCdBuyerCardManageDeptList99','ALL', '');
	
	//하이퍼링크 설정
	mySheet.SetDataLinkMouse('B_REQ_DATE', 1);
	mySheet.SetDataLinkMouse('M_REC_DATE', 1);
	mySheet.SetDataLinkMouse('S_REC_DATE', 1);
	mySheet.SetDataLinkMouse('S_PRT_DATE', 1);
	mySheet.SetDataLinkMouse('W_GR_DATE', 1);
	mySheet.SetDataLinkMouse('W_RIV_DATE', 1);
	mySheet.SetDataLinkMouse('W_IVK_DATE', 1);
	mySheet.SetDataLinkMouse('S_GR_DATE', 1);
	mySheet.SetDataLinkMouse('W_CHGR_DATE', 1);
	mySheet.SetDataLinkMouse('W_CHDELI_DATE', 1);
	mySheet.SetDataLinkMouse('S_CHDELI_DATE', 1);
	mySheet.SetDataLinkMouse('M_CLOSE_DATE', 1);
	mySheet.SetDataLinkMouse('END_DATE', 1);
	setLinkCol(mySheet, "APPR_STATUS_NM");	//결재상태
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	//getAddUsr();

}
	
	
var st;
var mt;
var g_gubun = "";
// 기능함수
function doAction(str) {
	g_gubun = "";
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

		if(kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val())== false){ return;}

		if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
			alert('조회는 3개월 이내만 가능 합니다.');
			return ;
		}	
		mySheet.RemoveAll();
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/wmre/getMasterWmReReturnRegList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		kepReload('searchCondition');
		mySheet.RemoveAll();
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		break;

	case "save": // 저장
		if (!confirm('선택한 항목을 저장 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/wmre/saveMasterWmReReturnRegList.do" , "SELECTED" );
		break;
		
	case "del": // 취소
		if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/wmre/delMasterWmReReturnRegList.do" , "SELECTED" );
		break;

	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
		var param = {FileName:"반품관리.xlsx",
				DownCols:"WMRE_NO|BUYER|BUYER_NAME|PO_NO|PO_SEQ|LEGACY_PO_NO|LEGACY_PO_SEQ|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|MAKER_NAME|ITEM_QTY|UNIT_MEASURE|SELLER|SELLER_NAME|PROCESS_TYPE_NM|BUYER_DEPT_NAME|BUYER_PERSON_NAME|BUYER_PERSON_TEL|WMRE_QTY|WMRE_TYPE_NAME|WAREHOUSE_NAME|KEP_USER_NAME|KEP_DEPT_NAME|WMRE_TYPE2_NAME|WMRE_TYPE3_NAME|WMRE_TYPE_DETAIL|FLAG_NAME|B_REQ_DATE|M_REC_DATE|S_REC_DATE|W_GR_DATE|W_GR_QTY|W_RIV_DATE|W_IVK_TYPE_NAME|S_GR_DATE|W_CHGR_DATE|W_CHDELI_DATE|S_CHDELI_DATE|M_CLOSE_DATE|END_DATE|CANCEL_DATE|APPR_STATUS_NM|DELIVERY_FLAG"};
		kepDownExcel(document.searchCondition ,mySheet , "/wmre/excelMasterWmReReturnRegList.do", param);
		$("#pageflag").val('1');
		break;
	case "saveCancle":	// 발주취소
		//수주접수 이전 체크.
		SelectPoCheck = checkPoDup();
		if (SelectPoCheck != "OK"){
			alert("발주 중복 등록 건이 있습니다.");
			return;
		}
		var SelectPoChack = checkSaveCancle(); 
		if (SelectPoChack == "OK"){
			g_gubun = "saveCancle";
			if (!confirm('선택한 항목을 발주 취소시 품의가 필요합니다.\n품의 진행 하시겠습니까?'))
				return;
			document.searchCondition.DOC_TYPE.value = "REC";
			
			kepSave(document.searchCondition ,  mySheet , "/wmre/saveMasterWmReCancleReturn.do" , "SELECTED" );
		}
		break;
	case "saveMinus": //마이너스발주
		SelectPoCheck = checkPoDup();
		if (SelectPoCheck != "OK"){
			alert("발주 중복 등록 건이 있습니다.");
			return;
		}
		var SelectPoChack = checkSaveMinus(); 
		if (SelectPoChack == "OK"){
			if (!confirm('선택한 항목을 마이너스시 품의가 필요합니다.\n품의 진행 하시겠습니까?'))
				return;
			g_gubun = "saveMinus";
			document.searchCondition.DOC_TYPE.value = "REM";
			kepSave(document.searchCondition ,  mySheet , "/wmre/saveMasterWmReCancleReturn.do" , "SELECTED" );
		}
		break;
	case "saveEnd": //발주종결
		SelectPoCheck = checkPoDup();
		if (SelectPoCheck != "OK"){
			alert("발주 중복 등록 건이 있습니다.");
			return;
		}
		var SelectPoChack = checkSaveEnd(); 
		if (SelectPoChack == "OK"){
			if (!confirm('선택한 항목을 발주종결시 품의가 필요합니다.\n품의 진행 하시겠습니까?'))
				return;
			g_gubun = "saveEnd";
			document.searchCondition.DOC_TYPE.value = "REE";
			kepSave(document.searchCondition ,  mySheet , "/wmre/saveMasterWmReCancleReturn.do" , "SELECTED" );
		}		
		break;
	case "saveEndAll": //반품일괄종결
		var SelectPoChack = checkSaveEndAll();
		if (SelectPoChack == "OK" && tr_yn != "Y"){
			if (!confirm('운영사접수 일자부터 모든 일자가 현재일자로 변경됩니다.\n반품일괄종결 진행하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/wmre/saveMasterWmReReturnEndAll.do" , "SELECTED" );
		}
		break;
	}
}
//발주취소 상태 체크
var tbuyer = ""; //고객사코드
function checkSaveCancle(){
	// 선택한 목록 체크 
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	
	if(selectedGrid.length == 0){ 
		alert("선택된 목록이 없습니다.");
		return "NO";
	}
	var check_result = "";
	var max_index = mySheet.RowCount();
	for(i=2; i<=max_index+1; i++) {
		check_result = mySheet.GetCellValue(i,"SELECTED");
		if(check_result == "1"){ 
			//반품종결체크
			//수주접수이력체크
			tbuyer = mySheet.GetCellValue(i,"BUYER");
			var po_no = mySheet.GetCellValue(i,"PO_NO");
			var po_seq = mySheet.GetCellValue(i,"PO_SEQ");
			var vFlag = mySheet.GetCellValue(i,"FLAG");
			var vApprStatus = mySheet.GetCellValue(i,"APPR_STATUS");
			var porsYn = getPorsYn(tbuyer,po_no,po_seq);
			var arapYn = getArApYn(tbuyer,po_no,po_seq);
			var arYn = arapYn.AR_YN;
			var apYn = arapYn.AP_YN;
			var vItemQty = mySheet.GetCellValue(i,"ITEM_QTY");
			var vWmreQty = mySheet.GetCellValue(i,"WMRE_QTY");
			var vWmreType = mySheet.GetCellValue(i,"WMRE_TYPE");
			
			for(var j=2; j<=max_index+1; j++) {
				var jbuyer = mySheet.GetCellValue(j,"BUYER");
				var jcheck_result = mySheet.GetCellValue(j,"SELECTED");
				if(jcheck_result =="1"){
					if(tbuyer != jbuyer){
						alert("동일한 고객사만 발주취소가 가능 합니다.");
						return "NO";	
					}					
				}
			}
			if(arYn == "Y" || apYn == "Y"){
				alert(po_no+"("+tbuyer+") 매입이나 매출 세금계산서가 발행된건 입니다.\n마이너스 발주 처리로 진행 바랍니다.");
				return "NO";				
			}
			if((vWmreType == "01") && (vItemQty != vWmreQty)){
				alert(po_no+"("+tbuyer+") 발주취소 대상이 아닙니다.\n마감완료 했으면 마이너스 발주 미마감건은 발주종결 버튼을 클릭하시기 바랍니다.");
				return "NO";
			}			
			if(vFlag != "13"){
				alert(po_no+"("+tbuyer+") 반품 종결건만 발주취소 가능합니다.");
				return "NO";
			}
			if(vApprStatus !="B" && vApprStatus !="D" && vApprStatus != ""){
				alert(po_no+"("+tbuyer+") 결재상태가 반려, 삭제, 미상신 일 때 결재상신이 가능합니다.");
				return "NO";				
			}
			if(porsYn =="N"){
				alert(po_no+"("+tbuyer+") 수주접수 이력이 없기때문에\n주문정보 수정화면에서 취소하시길 바랍니다.");
				return "NO";				
			}
		}
	}
	return "OK";
}
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(g_gubun =="saveCancle"){
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=REC&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg.usrmsg+'&requesTemptYn=N&PARAM1='+tbuyer, "1000,500,no");
	}else if(g_gubun =="saveMinus"){
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=REM&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg.usrmsg+'&requesTemptYn=N&PARAM1='+tbuyer, "1000,500,no");
	}else if(g_gubun =="saveEnd"){
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=REE&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg.usrmsg+'&requesTemptYn=N&PARAM1='+tbuyer, "1000,500,no");
	}else{
		if(!checkedSession(stCode)){return;}
		if (msg != "") {
			alert(msg);
		}
		if(code>0){
			//저장 성공시 재조회
			doAction('search');
		}
	}

}
//마이너스 발주
function checkSaveMinus(){
	// 선택한 목록 체크 
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	
	if(selectedGrid.length == 0){ 
		alert("선택된 목록이 없습니다.");
		return "NO";
	}
	var check_result = "";
	var max_index = mySheet.RowCount();
	for(i=2; i<=max_index+1; i++) {
		check_result = mySheet.GetCellValue(i,"SELECTED");
		if(check_result == "1"){ 
			//반품종결체크
			//수주접수이력체크
			tbuyer = mySheet.GetCellValue(i,"BUYER");
			var po_no = mySheet.GetCellValue(i,"PO_NO");
			var po_seq = mySheet.GetCellValue(i,"PO_SEQ");
			var vFlag = mySheet.GetCellValue(i,"FLAG");
			var vApprStatus = mySheet.GetCellValue(i,"APPR_STATUS");
			var vProcess_type = mySheet.GetCellValue(i,"PROCESS_TYPE");
			for(var j=2; j<=max_index+1; j++) {
				var jbuyer = mySheet.GetCellValue(j,"BUYER");
				var jcheck_result = mySheet.GetCellValue(j,"SELECTED");
				if(jcheck_result =="1"){
					if(tbuyer != jbuyer){
						alert("동일한 고객사만 발주취소가 가능 합니다.");
						return "NO";	
					}					
				}
			}
			if(vFlag != "13"){
				alert(po_no+"("+tbuyer+") 반품 종결건만 마이너스 발주가 가능합니다.");
				return "NO";
			}
			if(vApprStatus !="B" && vApprStatus !="D" &&vApprStatus != ""){
				alert(po_no+"("+tbuyer+") 결재상태가 반려, 삭제, 미상신일 때 결재상신이 가능합니다.");
				return "NO";				
			}
			var arapYn = getArApYn(tbuyer,po_no,po_seq);
			var apYn = arapYn.AP_YN;
			var grYn = arapYn.GR_YN;
			//VMI 발주건 계산서 발행 상관없이 마이너스 발주 생성되도록 로직 변경.
			if(vProcess_type !=="3"){
				//매입세금계산서 발행 x -> 불가능 / 매입세금계산서 발행 o && 전체수량 입고처리 완료x -> 불가능
				if(apYn == "N"){
					alert(po_no+"("+tbuyer+") 매입세금계산서가 미 발행된건 입니다.\n마이너스 발주가 불가능 합니다.");
					return "NO";				
				}else{
					if(grYn == "N"){
						alert(po_no+"("+tbuyer+") 입고처리되지 않았습니다.\n마이너스 발주가 불가능 합니다.");
						return "NO";
					}
				}				
			}
		}
	}
	return "OK";
}
//발주종결
function checkSaveEnd(){
	// 선택한 목록 체크 
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	
	if(selectedGrid.length == 0){ 
		alert("선택된 목록이 없습니다.");
		return "NO";
	}
	var check_result = "";
	var max_index = mySheet.RowCount();
	for(i=2; i<=max_index+1; i++) {
		check_result = mySheet.GetCellValue(i,"SELECTED");
		if(check_result == "1"){ 
			//반품종결체크
			//수주접수이력체크
			tbuyer = mySheet.GetCellValue(i,"BUYER");
			var po_no = mySheet.GetCellValue(i,"PO_NO");
			var po_seq = mySheet.GetCellValue(i,"PO_SEQ");
			var vFlag = mySheet.GetCellValue(i,"FLAG");
			var vApprStatus = mySheet.GetCellValue(i,"APPR_STATUS");
			var itemQty = mySheet.GetCellValue(i,"ITEM_QTY");
			var wmreQty = mySheet.GetCellValue(i,"WMRE_QTY");
			var vWmreType = mySheet.GetCellValue(i,"WMRE_TYPE");
			for(var j=2; j<=max_index+1; j++) {
				var jbuyer = mySheet.GetCellValue(j,"BUYER");
				var jcheck_result = mySheet.GetCellValue(j,"SELECTED");
				if(jcheck_result =="1"){
					if(tbuyer != jbuyer){
						alert("동일한 고객사만 발주취소가 가능 합니다.");
						return "NO";	
					}					
				}
			}
			//var ivgrYn = getIvGrYn(tbuyer,po_no,po_seq);
			if(vFlag != "13"){
				alert(po_no+"("+tbuyer+") 반품진행 종결건만 발주종결이 가능합니다.");
				return "NO";
			}
			if(vApprStatus !="B" && vApprStatus !="D" &&vApprStatus != ""){
				alert(po_no+"("+tbuyer+") 결재상태가 반려, 삭제, 미상신 일 때 결재상신이 가능합니다.");
				return "NO";				
			}
			if(itemQty == wmreQty){
				alert(po_no+"("+tbuyer+") 발주수량과 반품수량이 동일하므로 발주취소를 이용해주세요.");
				return "NO";
			}
			if(vWmreType == "09"){ // 주문취소
				alert(po_no+"("+tbuyer+")\n주문취소 요청건은 주문정보수정 화면에서 삭제하세요.");
				return "NO";
			}
			/*
			if(ivgrYn != "Y"){
				alert(po_no+"("+tbuyer+")입고 수량이거래명세서 수량보다\n크거나 같을경우만 발주종결이 가능합니다.");
				return "NO";				
			}*/
		}
	}
	return "OK";
}

//반품일괄종결
function checkSaveEndAll(){
	$("#st_all_w_ivk_type").val("");
	
	// 선택한 목록 체크
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	
	if(selectedGrid.length == 0){ 
		alert("선택된 목록이 없습니다.");
		return "NO";
	}
	
	var check_result = "";
	var max_index = mySheet.RowCount();
	for(var i=2; i<=max_index+1; i++){
		check_result = mySheet.GetCellValue(i,"SELECTED");
		if(check_result == "1"){ 
			tbuyer = mySheet.GetCellValue(i,"BUYER");
			var po_no = mySheet.GetCellValue(i,"PO_NO");
			var vFlag = mySheet.GetCellValue(i,"FLAG");
			var vWmreType = mySheet.GetCellValue(i,"WMRE_TYPE");
			var vProcess_type = mySheet.GetCellValue(i,"PROCESS_TYPE");
			
			if(vWmreType != "01"){ // 반품이 아니면
				alert(po_no+"("+tbuyer+")\n요청구분 반품만 반품일괄종결이 가능합니다.");
				return "NO";
			}
			
			if(vFlag == "01"){ // 고객사요청
				alert(po_no+"("+tbuyer+")\n운영사접수 이상 단계에서 반품일괄종결이 가능합니다.\n운영사접수를 먼저 해주세요.");
				return "NO";
			}else if(vFlag == "13" || vFlag == "19"){ // 종결 or 취소
				alert(po_no+"("+tbuyer+")\n종결이나 취소 건은 반품일괄종결이 불가능합니다.");
				return "NO";
			}
			
			if(vProcess_type == "2"){ // TR
				tr_yn = "Y";
			}
		}
	}
	
	if(tr_yn == "Y"){
		doPop("end_all_ivk_type");
	}else{
		return "OK";
	}
}

function getPorsYn(buyer,po_no,po_seq) {  
	var rtnData = "";
	$.ajax({
		type: "POST",
		dataType:"json",
		url: "/wmre/getPorsYn.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: { param1: buyer,param2: po_no,param3:po_seq},
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
function getArApYn(buyer,po_no,po_seq) {  
	var rtnData = {AR_YN:"",AP_YN:"",GR_YN:""};
	$.ajax({
		type: "POST",
		dataType:"json",
		url: "/wmre/getArApYn_v2.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: { param1: buyer,param2: po_no,param3:po_seq},
		async : false,
		success:function( response ) {  		    	  
			if (response.data.length > 0){
				for (var i=0; i<response.data.length; i++){ 
					rtnData.AR_YN = $.trim(eval("response.data["+i+"].AR_YN")); 
					rtnData.AP_YN = $.trim(eval("response.data["+i+"].AP_YN")); 
					rtnData.GR_YN = $.trim(eval("response.data["+i+"].GR_YN")); 
				}	 		    
			}
		},
		error:function( response ) {  		    	   
			alert("오류발생하였습니다.");
		}
	});  
	return rtnData;
}
function getIvGrYn(buyer,po_no,po_seq) {  
	var rtnData = "";
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/wmre/getIvGrYn.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param1: buyer,param2: po_no,param3:po_seq},
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
function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

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
	
	for(var  i= 2 ; i<mySheet.GetTotalRows()+2 ;  i++)
	{
		if(mySheet.GetCellValue(i,'WMRE_FILE') != ""){
			mySheet.SetCellImage(i, 'WMRE_FILE_IMG', fileOn);
		}
		
		if('13'==mySheet.GetCellValue(i,'FLAG')){
			
			mySheet.SetCellFontColor(i,"B_REQ_DATE","#FF0000") ;
			mySheet.SetCellFontColor(i,"M_REC_DATE","#FF0000") ;
			mySheet.SetCellFontColor(i,"S_REC_DATE","#FF0000") ;
			mySheet.SetCellFontColor(i,"S_PRT_DATE","#FF0000") ;
			mySheet.SetCellFontColor(i,"W_GR_DATE","#FF0000") ;
			mySheet.SetCellFontColor(i,"W_RIV_DATE","#FF0000") ;
			mySheet.SetCellFontColor(i,"W_IVK_DATE","#FF0000") ;
			mySheet.SetCellFontColor(i,"S_GR_DATE","#FF0000") ;
			mySheet.SetCellFontColor(i,"W_CHGR_DATE","#FF0000");
			mySheet.SetCellFontColor(i,"W_CHDELI_DATE","#FF0000");
			mySheet.SetCellFontColor(i,"S_CHDELI_DATE","#FF0000");
			mySheet.SetCellFontColor(i,"M_CLOSE_DATE","#FF0000");
			mySheet.SetCellFontColor(i,"END_DATE","#FF0000");
			mySheet.SetCellFontColor(i,'CANCEL_FLAG', "#FF0000");
		
		}else if('13'!= mySheet.GetCellValue(i,'FLAG')){
			
			mySheet.GetCellValue(i,'B_REQ_FLAG')=='02'?mySheet.SetCellFontColor(i,"B_REQ_DATE","#0054FF"):mySheet.SetCellFontColor(i,"B_REQ_DATE","#000000");
			mySheet.GetCellValue(i,'M_REC_FLAG')=='02'?mySheet.SetCellFontColor(i,"M_REC_DATE","#0054FF"):mySheet.SetCellFontColor(i,"M_REC_DATE","#000000");
			mySheet.GetCellValue(i,'S_REC_FLAG')=='02'?mySheet.SetCellFontColor(i,"S_REC_DATE","#0054FF"):mySheet.SetCellFontColor(i,"S_REC_DATE","#000000");
			mySheet.GetCellValue(i,'S_PRT_FLAG')=='02'?mySheet.SetCellFontColor(i,"S_PRT_DATE","#0054FF"):mySheet.SetCellFontColor(i,"S_PRT_DATE","#000000");
			mySheet.GetCellValue(i,'W_GR_FLAG')=='02'?mySheet.SetCellFontColor(i,"W_GR_DATE","#0054FF"):mySheet.SetCellFontColor(i,"W_GR_DATE","#000000");
			mySheet.GetCellValue(i,'W_RIV_FLAG')=='02'?mySheet.SetCellFontColor(i,"W_RIV_DATE","#0054FF"):mySheet.SetCellFontColor(i,"W_RIV_DATE","#000000");
			mySheet.GetCellValue(i,'W_IVK_FLAG')=='02'?mySheet.SetCellFontColor(i,"W_IVK_DATE","#0054FF"):mySheet.SetCellFontColor(i,"W_IVK_DATE","#000000");
			mySheet.GetCellValue(i,'S_GR_FLAG')=='02'?mySheet.SetCellFontColor(i,"S_GR_DATE","#0054FF"):mySheet.SetCellFontColor(i,"S_GR_DATE","#000000");
			mySheet.GetCellValue(i,'W_CHGR_FLAG')=='02'?mySheet.SetCellFontColor(i,"W_CHGR_DATE","#0054FF"):mySheet.SetCellFontColor(i,"W_CHGR_DATE","#000000");
			mySheet.GetCellValue(i,'W_CHDELI_FLAG')=='02'?mySheet.SetCellFontColor(i,"W_CHDELI_DATE","#0054FF"):mySheet.SetCellFontColor(i,"W_CHDELI_DATE","#000000");
			mySheet.GetCellValue(i,'S_CHDELI_FLAG')=='02'?mySheet.SetCellFontColor(i,"S_CHDELI_DATE","#0054FF"):mySheet.SetCellFontColor(i,"S_CHDELI_DATE","#000000");
			mySheet.GetCellValue(i,'M_CLOSE_FLAG')=='02'?mySheet.SetCellFontColor(i,"M_CLOSE_DATE","#0054FF"):mySheet.SetCellFontColor(i,"M_CLOSE_DATE","#000000");
			mySheet.GetCellValue(i,'END_FLAG')=='02'?mySheet.SetCellFontColor(i,"END_DATE","#0054FF"):mySheet.SetCellFontColor(i,"END_DATE","#000000");
			mySheet.GetCellValue(i,'CANCEL_FLAG')=='02'?mySheet.SetCellFontColor(i,"CANCEL_DATE","#0054FF"):mySheet.SetCellFontColor(i,"CANCEL_DATE","#000000");
		}
		
		
		//취소 
		if('09' ==mySheet.GetCellValue(i,'WMRE_TYPE')  ){ 

			mySheet.SetCellBackColor(i, 'B_REQ_DATE', "#FFE08C"); //노랑
			mySheet.SetCellBackColor(i, 'M_REC_DATE', "#FFE08C"); //노랑

			if(mySheet.GetCellValue(i,'M_REC_DATE')  != ""){
				mySheet.SetCellBackColor(i, 'END_DATE', "#FFE08C");//노랑
			}
			
			
		}
		//불량 
		if('03' ==mySheet.GetCellValue(i,'WMRE_TYPE')  ){ 

			mySheet.SetCellBackColor(i, 'B_REQ_DATE', "#FFE08C"); //노랑
			mySheet.SetCellBackColor(i, 'M_REC_DATE', "#FFE08C"); //노랑

			if(mySheet.GetCellValue(i,'M_REC_DATE')  != ""){
				mySheet.SetCellBackColor(i, 'END_DATE', "#FFE08C");//노랑
				mySheet.SetCellBackColor(i, 'S_REC_DATE', "#FFE08C");//노랑
			}
			
			
		}
	   	 //TR , 교환 
	   	 if('02' ==mySheet.GetCellValue(i,'WMRE_TYPE') &&  '2' == mySheet.GetCellValue(i,'PROCESS_TYPE') ){
	   		 
			
					
					mySheet.SetCellBackColor(i, 'B_REQ_DATE', "#FFE08C"); //노랑
					mySheet.SetCellBackColor(i, 'M_REC_DATE', "#FFE08C"); //노랑
 		

				if(mySheet.GetCellValue(i,'M_REC_DATE')  != ""){
					
					mySheet.SetCellBackColor(i, 'W_GR_DATE', "#FFE08C"); //노랑
					mySheet.SetCellBackColor(i, 'W_RIV_DATE', "#FFE08C"); //노랑
				
					mySheet.SetCellBackColor(i, 'S_REC_DATE', "#FFE08C"); //노랑
					mySheet.SetCellBackColor(i, 'S_GR_DATE', "#FFE08C"); //노랑
					
					mySheet.SetCellBackColor(i, 'W_CHDELI_DATE', "#FFE08C"); //노랑
					mySheet.SetCellBackColor(i, 'W_CHGR_DATE', "#FFE08C"); //노랑
				
				
					mySheet.SetCellBackColor(i, 'M_CLOSE_DATE', "#FFE08C");//노랑
					mySheet.SetCellBackColor(i, 'END_DATE', "#FFE08C");//노랑
					mySheet.SetCellBackColor(i, 'CANCEL_DATE', "#FFE08C");//노랑
				}
	   		 
	   	 }
	   	 //TR , 반품 
	   	 if('01' ==mySheet.GetCellValue(i,'WMRE_TYPE') &&  '2' == mySheet.GetCellValue(i,'PROCESS_TYPE') ){
	
				mySheet.SetCellBackColor(i, 'B_REQ_DATE', "#FFE08C"); //노랑
				mySheet.SetCellBackColor(i, 'M_REC_DATE', "#FFE08C"); //노랑


	   		
	   		if(mySheet.GetCellValue(i,'M_REC_DATE')  != ""){
	   			
				mySheet.SetCellBackColor(i, 'S_REC_DATE', "#FFE08C"); //노랑
				mySheet.SetCellBackColor(i, 'S_GR_DATE', "#FFE08C"); //노랑
	   			
				mySheet.SetCellBackColor(i, 'W_GR_DATE', "#FFE08C"); //노랑
				mySheet.SetCellBackColor(i, 'W_RIV_DATE', "#FFE08C"); //노랑
				
				mySheet.SetCellBackColor(i, 'M_CLOSE_DATE', "#FFE08C");//노랑
				mySheet.SetCellBackColor(i, 'END_DATE', "#FFE08C");//노랑
				mySheet.SetCellBackColor(i, 'CANCEL_DATE', "#FFE08C");//노랑
	   		}
	   		 
	   	 }
	   	 
	   	 //직납, 교환 
	   	  if('02' ==mySheet.GetCellValue(i,'WMRE_TYPE') &&  '0' == mySheet.GetCellValue(i,'PROCESS_TYPE') ){
	   		
				mySheet.SetCellBackColor(i, 'B_REQ_DATE', "#FFE08C"); //노랑
				mySheet.SetCellBackColor(i, 'M_REC_DATE', "#FFE08C"); //노랑

	
	   		
	   		if(mySheet.GetCellValue(i,'M_REC_DATE')  != ""){
				mySheet.SetCellBackColor(i, 'S_GR_DATE', "#FFE08C"); //노랑
				mySheet.SetCellBackColor(i, 'S_REC_DATE', "#FFE08C"); //노랑
				mySheet.SetCellBackColor(i, 'S_CHDELI_DATE', "#FFE08C"); //노랑
				
				mySheet.SetCellBackColor(i, 'M_CLOSE_DATE', "#FFE08C");//노랑
				mySheet.SetCellBackColor(i, 'END_DATE', "#FFE08C");//노랑
				mySheet.SetCellBackColor(i, 'CANCEL_DATE', "#FFE08C");//노랑
	   		}
	   		  
	   	  }
	   	 //직납,반품 
	   	  if('01' ==mySheet.GetCellValue(i,'WMRE_TYPE') &&  '0' == mySheet.GetCellValue(i,'PROCESS_TYPE') ){

				mySheet.SetCellBackColor(i, 'B_REQ_DATE', "#FFE08C"); //노랑
				mySheet.SetCellBackColor(i, 'M_REC_DATE', "#FFE08C"); //노랑
				

	   		if(mySheet.GetCellValue(i,'M_REC_DATE')  != ""){
				mySheet.SetCellBackColor(i, 'S_GR_DATE', "#FFE08C"); //노랑
				mySheet.SetCellBackColor(i, 'S_REC_DATE', "#FFE08C"); //노랑
				
				mySheet.SetCellBackColor(i, 'M_CLOSE_DATE', "#FFE08C");//노랑
				mySheet.SetCellBackColor(i, 'END_DATE', "#FFE08C");//노랑
				mySheet.SetCellBackColor(i, 'CANCEL_DATE', "#FFE08C");//노랑
	   		}
	   		  
	   	  }
	   	 

	   	  if('01' ==mySheet.GetCellValue(i,'WMRE_TYPE') &&   ( '1' == mySheet.GetCellValue(i,'PROCESS_TYPE')  ||  '3' == mySheet.GetCellValue(i,'PROCESS_TYPE')  ) ){
	
	   		  	mySheet.SetCellBackColor(i, 'B_REQ_DATE', "#FFE08C"); //노랑
			  	mySheet.SetCellBackColor(i, 'M_REC_DATE', "#FFE08C"); //노랑

	   
	   		if(mySheet.GetCellValue(i,'M_REC_DATE')  != ""){
	   			mySheet.SetCellBackColor(i, 'W_GR_DATE', "#FFE08C"); //노랑

				mySheet.SetCellBackColor(i, 'M_CLOSE_DATE', "#FFE08C");//노랑
				mySheet.SetCellBackColor(i, 'END_DATE', "#FFE08C");//노랑
				mySheet.SetCellBackColor(i, 'CANCEL_DATE', "#FFE08C");//노랑
	   		}
				
	   	  }

	   	  if('02' ==mySheet.GetCellValue(i,'WMRE_TYPE') &&   ( '1' == mySheet.GetCellValue(i,'PROCESS_TYPE')  ||  '3' == mySheet.GetCellValue(i,'PROCESS_TYPE')  ) ){
	   		
	   		  	mySheet.SetCellBackColor(i, 'B_REQ_DATE', "#FFE08C"); //노랑
			  	mySheet.SetCellBackColor(i, 'M_REC_DATE', "#FFE08C"); //노랑

	   		if(mySheet.GetCellValue(i,'M_REC_DATE')  != ""){
			  	mySheet.SetCellBackColor(i, 'W_GR_DATE', "#FFE08C"); //노랑
			  	mySheet.SetCellBackColor(i, 'W_CHDELI_DATE', "#FFE08C"); //노랑
			  	
				mySheet.SetCellBackColor(i, 'M_CLOSE_DATE', "#FFE08C");//노랑
				mySheet.SetCellBackColor(i, 'END_DATE', "#FFE08C");//노랑
				mySheet.SetCellBackColor(i, 'CANCEL_DATE', "#FFE08C");//노랑
	   		}
	   		  
	   	  }

	   		
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}
	

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmre/getMasterWmReReturnRegList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사 M
			//var st_warehouse_code = document.searchCondition.st_warehouse_code.value;
			//openSearchPopup('/wmdl/showMasterDlCommpyPop.do', '?BUSINESS_COND=B&MULTI=N&st_warehouse_code='+st_warehouse_code, "500,466,no"); 
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
	        popupSel = "buyer_single";
	        break;
		case "save_refund": 
			var st_warehouse_code = document.searchCondition.st_warehouse_code.value;
		//	alert(st_warehouse_code);
			openSearchPopup('/wmre/showMasterWmReReturnEntryPop.do', '?st_warehouse_code='+st_warehouse_code+'&st_insert_yn=Y','1000,610,no');
	        popupSel = "save_refund";
	        break;
		case "agent_single": // 협력사 M
			openSearchPopup('/coco/showCommonCoCoCompanyPop.do','?com_type=S&multi_flag=M&safety_flag=undefined&save_flag=undefined', "500,500,no"); 
			popupSel = "agent_single";
			break;
		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=000000801&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
		case "end_all_ivk_type": // 반품일괄종결(TR 있을 경우)
			openSearchPopup('/wmre/showMasterWmReReturnEndAllPop.do','', "500,150,no"); 
			popupSel = "end_all_ivk_type";
			break;
		case "PrSheet": // 매뉴얼 호출
			wmrePrSheet();
			break;	
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	//결재팝업.
	if(column == "APPR_STATUS_NM" && mySheet.GetCellValue(Row,'APPR_STATUS_NM')  != "" ){
		var gw_no = mySheet.GetCellValue(Row, 'APPR_GW_NO');
		openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do', '?COMPANY=KRKORE0001&DOCU_NO='+gw_no+'&PASS_TP=2&FLAG=RECV' ,'1200,700,no');
		
	}
	if	(mySheet.GetCellBackColor(Row, Col) == "#ffe08c"  ){
		
		if(  (column == "B_REQ_DATE" || column =="M_REC_DATE" ) ){
					
				var st_warehouse_code = document.searchCondition.st_warehouse_code.value;
				var st_req_flag = "N";
				if(mySheet.GetCellValue(Row,'FLAG') == "13"||  mySheet.GetCellValue(Row,'FLAG') == "19"){
					st_req_flag = "Y";
				}
				openSearchPopup('/wmre/showMasterWmReReturnEntryPopForUpdate.do', '?st_WMRE_NO='+mySheet.GetCellValue(Row,'WMRE_NO')+'&st_warehouse_code='+st_warehouse_code+'&st_req_flag='+st_req_flag ,'1000,610,no');


		
		}else{
			if(mySheet.GetCellValue(Row,'M_REC_DATE')  != ""  ){
				openSearchPopup('/wmre/showMasterWmReReturnWmNoPop.do','?st_PROCESS_TYPE='+mySheet.GetCellValue(Row, 'PROCESS_TYPE')+'&st_WMRE_TYPE='+mySheet.GetCellValue(Row, 'WMRE_TYPE') +'&st_WMRE_NO='+mySheet.GetCellValue(Row,'WMRE_NO')+
						 '&st_item_qty='+mySheet.GetCellText(Row, 'ITEM_QTY') +'&st_PROCESS_TYPE_NM='+mySheet.GetCellValue(Row, 'PROCESS_TYPE_NM')+'&st_WMRE_TYPE_NAME='+mySheet.GetCellValue(Row, 'WMRE_TYPE_NAME')+'&st_flag='+mySheet.GetCellValue(Row, 'FLAG')  ,'850,700,no'); 
			}

			
		}
		popupSel = "masterWmReReturnWmNoPop";
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 다중 고객사
			$("#st_buyer_code").val(value1);
			$("#st_buyer_name").val(value2);
	
	}else if(popupSel == "agent_single"){
		
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
		
	}else if(popupSel == "end_all_ivk_type"){
		$("#confirmMsgDiv").html("운영사접수 일자부터 모든 일자가 현재일자로 변경됩니다.</br>반품일괄종결 진행하시겠습니까?"); <%-- 		Confirm 문구 입력 --> 개행을 위해 text 대신 html 사용  (br 태그 인식용) --%>
		$("#st_all_w_ivk_type").val(value1);
		$("#confirmAreaDiv").show(); //Confirm 창 확인.
		
	}
	grbRow="";	//초기화
}

//Confirm창 확인처리
function confirmAreaDivSearch(){
	$("#confirmAreaDiv").hide();
	kepSave(document.searchCondition ,  mySheet , "/wmre/saveMasterWmReReturnEndAll.do" , "SELECTED" );
}


function getAddUsr(){
	var search = kepSelectOptionVal('st_warehouse_code');

	kepAjaxCommonQueryIdSearchCombo('st_add_usr_id','getWareHouseAddUsr',search,'SEL','<%=userid%>');
}
//결재성공시 재조회
function kepApprovalReturn(flag,docu_no){
	doAction('search');
}
/**
 * 회수요청서 출력
 */
function wmrePrSheet(){

 	// 선택한 목록 체크 
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
 	
	if(selectedGrid.length == 0){
    	alert("선택된 항목이 없습니다.");
        return;
    }
	var check_result = "";
	var process_type = "";
	var wmre_no = "";
	var query = "";
	var max_index = mySheet.RowCount();
	for(i=2; i<=max_index+1; i++) {
		check_result = mySheet.GetCellValue(i,"SELECTED");
		process_type = mySheet.GetCellValue(i,'PROCESS_TYPE');

		if(check_result == "1"){
			if(process_type != "2"){ // TR일때만 출력
				alert(i-1+"번째 건은 출고구분이 TR이 아닙니다. TR건만 회수요청서를 출력할 수 있습니다.");
				return;
			}
			wmre_no = mySheet.GetCellValue(i,'WMRE_NO');
	        query += wmre_no + "@@";
	    }
    }//end loop
    
	reportOpen("RD_08_M_006_83","["+query+"]");	// 회수요청서 출력.
    
}
/**
 * 오른쪽 하단 3개 버튼(발주취소, 마이너스발주, 발주종결) 클릭시 중복발주 확인 (고객사코드, 발주번호, 발주항번 확인)
 */
function checkPoDup(){
	var last_index = mySheet.RowCount()+1; // index 1은 헤더 -> row갯수 +1 해야 마지막 행

	for ( var i = 2; i < last_index ; i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			var check1 = mySheet.GetCellValue(i,"BUYER")+mySheet.GetCellValue(i,"PO_NO")+mySheet.GetCellValue(i,"PO_SEQ");
			
			for ( var j = i+1; j <= last_index ; j++ ) {
				if ( mySheet.GetCellValue(j, "SELECTED") == 1 ) {
					var check2 = mySheet.GetCellValue(j,"BUYER")+mySheet.GetCellValue(j,"PO_NO")+mySheet.GetCellValue(j,"PO_SEQ");
					
					if( check1 == check2 ){
			        	return "NO";
					}
				}
			}
		}
	}
	return "OK";
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>반품등록</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
		    <span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
   		</div>        	
        <!--조회영역-->
       	<form name ="searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
			<input type="hidden" id="DOC_TYPE" name="DOC_TYPE"  value="">
			<input type="hidden" id="st_all_w_ivk_type" name="st_all_w_ivk_type"  value="">
			
            	<table  class="cont_t_list01" width="940" >
					<caption>반품등록</caption>
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
								<select name="st_date_type" class = "TitSelect">
									<option value="ADD_DATE">요청일자</option>
									<option value="REC_DATE">접수일자</option>
								</select>					
							</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a> - 
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
							</td>
							<th>접수자</th>
							<td>
								<select id="st_add_usr_id"  name="st_add_usr_id" style="width:80%;height:20px">
							</td>
						</tr>
						<tr> 
							<th>접수번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_wmre_no" name="st_wmre_no" style="width:87%;" value=""  onchange="fnCheckInputByte(this, 20);"  onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');" >
							</td>
							<th>물류센터</th>
							<td>
								<select id="st_warehouse_code"  name="st_warehouse_code" style="width:80%;height:20px" >
								<%
						 			Map<String, String> _map = new HashMap<String, String>();
						 			_map.put("BUYER",buyer);
						 			_map.put("USERID",userid);
						 			_map.put("whAdmin",whAdmin);
								%>
								<%= CommonUtil.getCodeComboQueryIdList("common.getWareHouseIdSchList","ALL",_map,"") %>
								</selec>
							</td>
							<th>유형</th>
							<td>
								 <select id="st_WMRE_TYPE" name="st_WMRE_TYPE" style="width:80%;height:20px">
								<%= CommonUtil.getCodeComboQueryIdList("common.getTypeWM01","SEL","") %>
								</select>
							</td>
						</tr>
						<tr>
							 <th>고객사</th>
							  <td>
								 <input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:60%" value="" readonly onclick="javascript:doPop('buyer_single');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:60%" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<th>발주번호</th>
							<td><input type="text" class="input_type_text" id="st_po_no" name="st_po_no" style="width:78%;" value="" onchange="fnCheckInputByte(this, 20);" onKeyUp="kepToUpper('st_po_no')" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');" ></td>
							<th>출고구분</th>
							<td>
							<select name="st_wmre_type"  id="st_wmre_type" style="width:80%;height:20px" >
								<option value="" selected>전체</option>
								<option value="0">직납</option>
								<option value="1">재고</option>
								<option value="2">TR</option>
								<option value="3">VMI</option>
							</select>
							</td>
						</tr>
						<tr>
							 <th>협력사</th>
							  <td>
								 <input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:60%" value="" readonly onclick="javascript:doPop('agent_single');">
								<input type="hidden" name="st_agnet_code" id="st_agent_code" style="width:60%" value="">
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agnet_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<th>진행상태</th>
							<td>								 
							  <select  name="st_flag" id= "st_flag" style="width:80%;height:20px">
							  <%= CommonUtil.getCodeComboQueryIdList("common.getTypeWM07","SEL","") %>
								</select>
							</td>
							<th>사업팀</th>
							<td>
								<select id="st_dept_code" name="st_dept_code" style="width:80%;">
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
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c; height:320px;">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "320px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  				<span class="fl">
  				  	<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				  	<span class="btn_05 mr04"><a href="javascript:doPop('PrSheet');">회수요청서</a></span>
  				</span>
  				<span class="fr">
  					<span class="btn_04 mr04"><a href="javascript:doAction('saveEndAll');">반품일괄종결</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doPop('save_refund');">반품등록</a></span>
					<span class="btn_02 mr04"><a href="javascript:doAction('saveCancle')">발주취소</a></span>
					<span class="btn_04 mr04"><a href="javascript:doAction('saveMinus')">마이너스발주</a></span>
					<span class="btn_02 mr04"><a href="javascript:doAction('saveEnd')">발주종결</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
