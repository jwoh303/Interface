<%--
**********************************************
* 메뉴 : 주문관리>주문진행관리>고객사입고관리
* 화면 : 고객사입고관리
* 기능 : 
* 프로그램 ID :
* 담당자 : 최찬규
* 착수일 : 2026-09-11
**********************************************
--%>
<%@page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<!-- 다중선택콤보(공통) - 사용시 필수 선언 start -->
<script src="/resources/js/jquery.multiple.select.js"></script>
<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<!-- 다중선택콤보(공통) - 사용시 필수 선언 end -->
<%
	String st_user_id = _sessionInfo.getUserId();	
	String st_gr_date_lock_yn = "";
	boolean st_gr_date_lock = CommonUtil.getCodeCheckReturn("SRHIDE", st_user_id);
	if(st_gr_date_lock == true){
		st_gr_date_lock_yn = "Y";
	}else{
		st_gr_date_lock_yn = "N";
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

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:50,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus"}
					,{ Align:"Center",	Width:50,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED"}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사",			SaveName:"BUYER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"입고번호",			SaveName:"GR_NO"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"입고항번",			SaveName:"GR_SEQ"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주번호",			SaveName:"PO_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"IF발주번호",		SaveName:"LEGACY_PO_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"IF입고번호",		SaveName:"LEGACY_GR_NO"}
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사",			SaveName:"AGENT"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품목코드",			SaveName:"BUYER_ITEM_NO"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"관리번호",			SaveName:"REF_PR_NO"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"발주일",			SaveName:"PO_CREATE_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"실적등록일",			SaveName:"DELIVERY_DATE"}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"입고일",			SaveName:"GR_DATE",				BackColor:"${optColor}"}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품명",			SaveName:"DESCRIPTION"}
					,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"규격",			SaveName:"SPECIFICATION"}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"제조사",			SaveName:"MAKER_NAME"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"단위",			SaveName:"UNIT_MEASURE"}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"원산지",			SaveName:"ORIGIN_NAME"}
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"모델번호",			SaveName:"MAKER_PART_NO"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"발주수량",			SaveName:"PO_QTY"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"입고수량",			SaveName:"GR_QTY"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"매출단가",			SaveName:"UNIT_PRICE"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"매출금액",			SaveName:"UNIT_SUM"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"매입단가",			SaveName:"AGENT_PRICE"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"매입금액",			SaveName:"AGENT_SUM"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주부서",			SaveName:"PURCHASER_DEPT_NAME"}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주자",			SaveName:"PURCHASER_NAME"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"요청부서",			SaveName:"REQ_DEPT_NAME"}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"요청자",			SaveName:"REQ_USER_NAME"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주항번",			SaveName:"PO_SEQ"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"IF발주항번",		SaveName:"LEGACY_PO_SEQ"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"거래명세서번호",	SaveName:"INV_NO"}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"거래명세서항번",	SaveName:"INV_SEQ"}
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"택배정보",			SaveName:"PARCEL_INFO"}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"배송증빙첨부",		SaveName:"IMAGE_KEY_INV_IMG",	Sort:0}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"배송증빙서명",		SaveName:"IMAGE_KEY_SIGN_IMG",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"자동입고여부",		SaveName:"AUTO_GR_FLAG"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"IMAGE_KEY_SIGN",SaveName:"IMAGE_KEY_SIGN"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"IMAGE_KEY_INV",	SaveName:"IMAGE_KEY_INV"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"PROCESS_TYPE",	SaveName:"PROCESS_TYPE"}
					,{ Align:"Center",	Width:90,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"정산담당자",		SaveName:"GR_CREATOR_NAME",		BackColor:"${optColor}"}
					,{ Align:"Left",	Width:150,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"정산담당자이메일",	SaveName:"GR_CREATOR_EMAIL",	BackColor:"${optColor}"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"거래유형",			SaveName:"PROCESS_TYPE_NAME"}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"물류수수료(%)",	SaveName:"LOGIS_RATE"}
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"책정사유",			SaveName:"LOGIS_RATE_STATUS"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"매출세금계산서번호",	SaveName:"AR_TAX_BILL_NO"}
					,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"예산부서코드",		SaveName:"BUDGET_DEPT"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"계정코드",			SaveName:"ACCOUNT_TYPE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"주문번호",			SaveName:"PR_NO"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"주문항번",			SaveName:"PR_SEQ"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"매출마감여부",		SaveName:"AR_BILL_FLAG"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"고객사코드",		SaveName:"BUYER"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"제조사코드",		SaveName:"MAKER_CODE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"발주자ID",		SaveName:"PURCHASER_ID"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"요청자ID",		SaveName:"REQ_USER_ID"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:150,	Hidden:false,	Type:"Text",		Header:"비고2",			SaveName:"PO_REMARK_HD"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:150,	Hidden:true,	Type:"Text",		Header:"보충발주여부",		SaveName:"WAREHOUSE_BUYER_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Date",		Header:"입고일",			SaveName:"GR_DATE_ORG"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:150,	Hidden:true,	Type:"Text",		Header:"AP_BILL_FLAG",		SaveName:"AP_BILL_FLAG"}
	];
	initsheet.HeaderMode = {Sort : 0}; // 더블클릭 사용 위해 정렬기능 사용 안함
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:5};
	IBS_InitSheet(mySheet, initsheet,pagingMode); 
	
	// 복사할 컬럼 밑줄 표시
	mySheet.SetCellFontUnderline(0, "GR_DATE", true);
	mySheet.SetCellFontUnderline(0, "GR_CREATOR_NAME", true);
	mySheet.SetCellFontUnderline(0, "GR_CREATOR_EMAIL", true);
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	//파일첨부이미지설정
	mySheet.SetImageList(2, diskOff);
	mySheet.SetImageList(3, diskOn);
	setLinkCol(mySheet, "IMAGE_KEY_INV_IMG");
	setLinkCol(mySheet, "IMAGE_KEY_SIGN_IMG");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	<%
	if("Y".equals(st_gr_date_lock_yn)){
	%>
		mySheet.SetColEditable("GR_DATE", 0);
		mySheet.SetColBackColor("GR_DATE", "");
		mySheet.SetCellFontUnderline(0, "GR_DATE", false);
	<%
	}
	%>
}
	
var st;
var mt;
// 기능함수
function doAction(str){
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0){
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str){
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			var com_buyer =	$("#st_buyer_code").val();
			if (com_buyer == "") {
				alert("고객사를 선택하세요.");
				return;
			}
			
			if(document.getElementById("st_ar_closedcheck").checked == true){
				 $("#st_ar_closed").val('Y');		
			}else{
				 $("#st_ar_closed").val('N');					
			}
		 
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoGrDetailList_v2.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			$( '#searchCondition' )[0].reset();
		
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
			mySheet.RemoveAll();
			
			$("#st_buyer_code").val("");
			$("#st_agent_code").val(""); 
			break;
	
		case "save": // 저장
			if(!saveValidCheck()){
				return;
			}
				
			if(!confirm('선택한 항목을 저장하시겠습니까?')){
				return;
			}
	
			kepSave(document.searchCondition, mySheet, "/mpso/saveMasterMpSoGrDetailList_v2.do", "SELECTED");
			break;
		
		case "cancel": // 입고취소
			if(!cancelValidCheck()){
				return;
			}
			
			if (!confirm('선택한 항목을 입고취소하시겠습니까?')){
				return;
			}
	
			kepSave(document.searchCondition, mySheet, "/mpso/saveGrDelChange_Item_v2.do", "SELECTED");
			break;
			
		case "excelDown": // 엑셀다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			var com_buyer =	$("#st_buyer_code").val();
			if (com_buyer == "") {
				alert("고객사를 선택하세요.");
				return;
			}
			
		    $("#pageflag").val('0');
			var param = {FileName:"고객사입고관리.xlsx",DownCols:"BUYER|BUYER_NAME|GR_NO|GR_SEQ|PO_NO|LEGACY_PO_NO|AGENT_NAME|BUYER_ITEM_NO|REF_PR_NO|PO_DATE|GR_DATE|DESCRIPTION|SPECIFICATION|MAKER_CODE|MAKER_CODE|MAKER_NAME|UNIT_MEASURE|ORIGIN_NAME|MAKER_PART_NO|PO_QTY|GR_QTY|UNIT_PRICE|UNIT_SUM|AGENT_PRICE|AGENT_SUM|PURCHASER_DEPT_NAME|PURCHASER_NAME|REQ_DEPT_NAME|REQ_USER_NAME|PO_SEQ|LEGACY_PO_SEQ|INV_NO|INV_SEQ|GR_CREATOR_NAME|GR_CREATOR_EMAIL|PROCESS_TYPE|PROCESS_TYPE_NAME|LOGIS_RATE|LOGIS_RATE_STATUS|AR_BILL_FLAG|AR_TAX_BILL_NO|BUDGET_DEPT|PO_REMARK_HD|"};
			kepDownExcel(document.searchCondition ,mySheet , "/mpso/excelMasterMpSoGrDetailList.do", param);
			$("#pageflag").val('1');
			break;
	}
}

// 저장 전 체크
function saveValidCheck(){
// 	var date = new Date();
// 	var year = date.getFullYear();
// 	var month = date.getMonth()+1;
// 	if(month <= 9){
// 		month = "0"+month;
// 	}
// 	var yearMonth = year+month;
	
    for(var i=1; i<=mySheet.RowCount(); i++){
        if(mySheet.GetCellValue(i, "SELECTED") == 1){
        	var PO_NO = mySheet.GetCellValue(i, "PO_NO");
        	var PARCEL_INFO = mySheet.GetCellValue(i, "PARCEL_INFO");
        	var AUTO_GR_FLAG = mySheet.GetCellValue(i, "AUTO_GR_FLAG");
        	var IMAGE_KEY_INV = mySheet.GetCellValue(i, "IMAGE_KEY_INV");
        	var INV_NO = mySheet.GetCellValue(i, "INV_NO");
        	var IMAGE_KEY_SIGN = mySheet.GetCellValue(i, "IMAGE_KEY_SIGN");
        	var BUYER_NAME = mySheet.GetCellValue(i, "BUYER_NAME");
        	
            if(mySheet.GetCellValue(i, "GR_DATE") == ""){
                alert("입고일을 지정해주세요");
                return false;
            }
			/*
			고객사 옵션이 자동입고 로직
			1. 직납일때만 첨부기능.(협력사)
			2. 택배송장번호 입력건은 배송증빙처리 불필요
			3. 택번거 이외 모든건 배송증빙 처리 해야함
			*/
			if(AUTO_GR_FLAG =="Y"){
				if(PARCEL_INFO =="" || PARCEL_INFO == null){
					if(IMAGE_KEY_INV==""&&IMAGE_KEY_SIGN==""){
						alert("고객사: "+BUYER_NAME+ " 거래명세서번호: "+INV_NO+"\n배송완료 증빙 처리 바랍니다.");
						return;						
					}
				}
			}
			
			if(mySheet.GetCellValue(i, "AR_BILL_FLAG") == "Y"){
				alert(PO_NO + " 매출 세금계산서가 발행되었습니다.\n저장 할 수 없습니다.");
                return false;
            }
			
			//
			if ( mySheet.GetCellValue(i, "GR_DATE") != mySheet.GetCellValue(i, "GR_DATE_ORG") ) {
				if(mySheet.GetCellValue(i, "DELIVERY_DATE") > mySheet.GetCellValue(i, "GR_DATE")){ //실적등록일 > 입고일 될 수 없음
					alert("입고일은 실적등록일 이전 날짜로 할 수 없습니다.");
					return;
				}
			}
        }
    }

	return true;
}
//입고취소 전 체크
function cancelValidCheck(){
    for(var i=1; i<=mySheet.RowCount(); i++){
        if(mySheet.GetCellValue(i, "SELECTED") == 1){
        	var PO_NO = mySheet.GetCellValue(i, "PO_NO");
        	var PROCESS_TYPE = mySheet.GetCellValue(i, "PROCESS_TYPE");
        	var WAREHOUSE_BUYER_YN = mySheet.GetCellValue(i, "WAREHOUSE_BUYER_YN");
        	
        	if(PROCESS_TYPE == "1" && WAREHOUSE_BUYER_YN == "Y"){
        		alert("재고보충발주는 처리할 수 없습니다.");
        		return false;
        	}
        	
            if(mySheet.GetCellValue(i, "GR_DATE") == ""){
                alert("입고일을 지정해주세요");
                return false;
            }
            
			if(mySheet.GetCellValue(i, "AR_BILL_FLAG") == "Y"){
				alert(PO_NO + " 매출 세금계산서가 발행되었습니다.\n입고취소 할 수 없습니다.");
                return false;
            }
			
			if(mySheet.GetCellValue(i, "AGENT") == "KR00000002"){
				alert(PO_NO + " 관리팀 재고생성 건은 입고취소 할 수 없습니다.");
                return false;
            }
        }
    }

	return true;
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
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
// 	alert(downloadType + ' 다운이 완료되었습니다. \n 다운로드 결과 : ' + ((result==true)?'성공':'실패'));
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoGrDetailList_v2.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	var com_buyer =	$("#st_buyer_code").val();
	switch (str) {
	case "buyer_single": // 고객사 M
		openSearchPopup("/common/safetyCompanyCodePop.do", "?COM_TYPE=B&MULTI=Y", "880,450,no"); 
		break;
		
	case "req_user_name": // 협력사
		if (com_buyer == "") {
			alert("고객사를 선택하세요.");
			return;
		}
		openSearchPopup('/common/icomcmpyPop.do', "?open=Y&BUSINESS_COND=S" ,"500,466,no");
		break;
	}
}
var grbRow  ="";
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	if (Value == "") return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	var BUYER = mySheet.GetCellValue(Row,"BUYER");
	
	if (BUYER == "") return;
	if (column == "IMAGE_KEY_INV_IMG" ){ //  배송증빙 첨부
		var type="IV";
		var viewType="VI";
		var image_key =  mySheet.GetCellValue(Row, "IMAGE_KEY_INV");
		var st_buyer =  BUYER;
		var st_inv_no =  mySheet.GetCellValue(Row, "INV_NO");
		popupSel = "attachDly";
		openSearchPopup('/common/imageFileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType+'&BUYER='+st_buyer+'&INVOICE='+st_inv_no,'500,430,no');// 파일첨부
	}else if(column == "IMAGE_KEY_SIGN_IMG"){ //배송증빙서명
		var type="IV";
		var viewType="R";
		var image_key =  mySheet.GetCellValue(Row, "IMAGE_KEY_SIGN");
		var st_buyer =  BUYER;
		var st_inv_no =  mySheet.GetCellValue(Row, "INV_NO");
		popupSel = "attachDlySign";
		openSearchPopup('/common/imageFileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType+'&BUYER='+st_buyer+'&INVOICE='+st_inv_no,'500,430,no');// 파일첨부
	}
	return;
}

//헤더 더블클릭 이벤트
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH){
	if(Row > 0) return;
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	
	if (checkRows.length == 0){
 		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	
	var arrRow = checkRows.split("|");
	
	if(mySheet.ColSaveName(Col) == "GR_DATE"){ // 입고일자
		var value1 = mySheet.GetCellValue(arrRow[0], "GR_DATE");
	
 		if(kepIsValueNull(value1)){
 			alert("복사할 입고일자를 입력하여 주십시요.");
 			return;
 		}
		
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "GR_DATE", value1);
		}
	}else if(mySheet.ColSaveName(Col) == "GR_CREATOR_NAME"){// 정산담당자
		var value1 = mySheet.GetCellValue(arrRow[0], "GR_CREATOR_NAME");

		if(kepIsValueNull(value1)){
			alert("복사할 정산담당자를 입력하여 주십시요.");
			return;
		}
		
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "GR_CREATOR_NAME", value1);
		}
	}else if(mySheet.ColSaveName(Col) == "GR_CREATOR_EMAIL"){// 정산담당자이메일
		var value1 = mySheet.GetCellValue(arrRow[0], "GR_CREATOR_EMAIL");

		if(kepIsValueNull(value1)){
			alert("복사할 정산담당자이메일을 입력하여 주십시요.");
			return;
		}
		
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "GR_CREATOR_EMAIL", value1);
		}
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 고객사 
		
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@")); 
		
	}else 	if (popupSel == "req_user_name") {	// 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2); 
	} else if (popupSel == "attachDly") {	//이미지첨부
		mySheet.SetCellValue(grbRow, 'IMAGE_KEY_INV', value1);
		mySheet.SetCellValue(grbRow, 'IMAGE_KEY_INV_IMG', (value1!='')? diskOn : diskOff);
		
	} 
	grbRow="";	//초기화
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>고객사입고관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" id="searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_buyer" name="st_buyer"  value="${sessionInfo.comCode}">
			<input type="hidden" id="st_ar_closed" name = "st_ar_closed" value="">
            	<table  class="cont_t_list01" >
					<caption>고객사입고관리</caption>
					<colgroup>
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
                        <col width="25%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>조회일</th>
							<td colspan="3">
							 <select name="st_date_type" style="width:10%" class="TitSelect">
	                            <option value = "PO">발주일</option>
	                            <option value = "GR">입고일</option>
                       	 	</select>
                        
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:80px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:80px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
							</td>
							<th></th>
							<td>
							</td>
						</tr>
						<tr> 
							<th><font color="red"><b>*</b></font>고객사</th>
							<td>
						 			<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:67%;" value = "" READONLY>
			                       <input type="hidden" name="st_buyer_code" id="st_buyer_code" value ="">
			                       <a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
			                       <a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>협력사</th>
							<td>
							    <input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:60%;" value ="" READONLY>
					        	<input type="hidden" name="st_agent_code" id="st_agent_code" value=""> 
		                        <a href="javascript:doPop('req_user_name');"><img src="/resources/images/btn_search03.gif"></a>
		                        <a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>입고번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_search_gr_no" name="st_search_gr_no" style="width:80%;" value=""   onkeydown="kepEnter()">
							</td>
						</tr>
				      <tr>	       
				       		<th>발주번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_search_po_no" name="st_search_po_no" style="width:80%;" value=""   onkeydown="kepEnter()">
							</td>
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_search_buyer_item_no" name="st_search_buyer_item_no" style="width:80%;" value=""  onkeydown="kepEnter()">
							</td>
							<th>품명규격</th>
							<td>
								<input type="text" class="input_type_text" id="st_search_desc_spec" name="st_search_desc_spec" style="width:80%;" value=""  onkeydown="kepEnter()">
							</td>							
						</tr>
				      <tr>	       
				       		<th>예산부서코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_budget_dept" name="st_budget_dept" style="width:80%;" value=""   onkeydown="kepEnter()">
							</td>
							<td colspan="3">
								 <label><input type="checkbox" name="st_ar_closedcheck" id="st_ar_closedcheck" checked>&nbsp;매출마감 완료건 제외&nbsp;</label>
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
					<select id="onepagerow" name="onepagerow" style="width: 70px;" >
					<option value="50" selected>50건</option>
					<option value="100">100건</option>
					<option value="300">300건</option>
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
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
  					<span class="btn_05 mr04" ><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  				
  				<span class="fr">
  					<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
   					<span class="btn_02"><a href="javascript:doAction('cancel');">입고취소</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
