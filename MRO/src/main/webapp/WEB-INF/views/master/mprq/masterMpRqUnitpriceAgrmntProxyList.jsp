<%--
**********************************************
* 메뉴 : 견적관리>단가합의대행
* 화면 : 단가합의대행
* 기능 : 운영사에서 고객사를 대신하여 최종단가합의 대상 목록을 조회하고 최종단가합의를 대행해준다 
* 프로그램 ID : PG_04_M_010_00
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-07-25
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
	String st_user_dept = _sessionInfo.getDepartment();
	//소싱부서 여부
	String st_sour_dept_yn = "";
	boolean st_sour_dept = CommonUtil.getCodeCheckReturn("SOURDEPT",st_user_dept);
	if(st_sour_dept == true){
		st_sour_dept_yn = "Y";
	}else{
		st_sour_dept_yn = "N";
	}
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.HeaderMode = {			Sort : 0,			ColMove : 1,			ColResize : 1		};
	initsheet.Cols = [ 
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",					SaveName:"SELECTED"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사",				SaveName:"BUYER_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"고객사",				SaveName:"BUYER"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"진행상태",				SaveName:"SOURCING_STATUS"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"견적번호",				SaveName:"QUOTATION_NO"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"견적순번",				SaveName:"QUOTATION_SEQ"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"견적차수",				SaveName:"REVISION"}
		,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"실코드",				SaveName:"REG_ITEM_NO",			BackColor:"${optColor}"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품목코드",				SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품목명",				SaveName:"DESCRIPTION"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"규격",				SaveName:"SPECIFICATION"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"제조사",				SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"원산지",				SaveName:"ORIGIN_NAME"}
		,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"요청단가",				SaveName:"BUYER_TARGET_PRICE",	Format:"${priceFormat}"}
		,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"목표단가",				SaveName:"ADMIN_TARGET_PRICE",	Format:"${priceFormat}"}
		,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"견적단가",				SaveName:"ATOB_UNIT_PRICE", 	Format:"${priceFormat}"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"견적의뢰일",			SaveName:"BTOA_DATE"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"회신요청일",			SaveName:"BTOA_END_DATE"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"요청자",				SaveName:"BTOA_USER_NAME"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"요청자",				SaveName:"BTOA_USER_ID"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"요청부서",				SaveName:"BTOA_USER_DEPT"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"비고",				SaveName:"ATOB_REMARK_IMG"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"비고(고객사->운영자)",	SaveName:"BTOA_REMARK"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"비고(운영자->고객사)",	SaveName:"ATOB_REMARK"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"취소사유",				SaveName:"CANCEL_REMARK_IMG"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"취소사유",				SaveName:"CANCEL_REMARK"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"취소사유코드",			SaveName:"CANCEL_REMARK_CODE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"단위",				SaveName:"UNIT_MEASURE"}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"수량",				SaveName:"ITEM_QTY",			Format:"${qtyFormat}"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사",				SaveName:"AGENT_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"MSDS_NO",			SaveName:"MSDS_NO"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"협력사",				SaveName:"AGENT"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"상태",				SaveName:"PRODUCT_CLOSE_FLAG"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"PROCESS_TYPE",		SaveName:"PROCESS_TYPE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"WAREHOUSE_CODE",	SaveName:"WAREHOUSE_CODE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"ORIGIN_CODE",		SaveName:"ORIGIN_CODE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"IMPORT_FLAG",		SaveName:"IMPORT_FLAG"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"BELOW_COMORG_CODE",	SaveName:"BELOW_COMORG_CODE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"CONTRACT_NO",		SaveName:"CONTRACT_NO"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"CONTRACT_SEQ",		SaveName:"CONTRACT_SEQ"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"CMS_CATEG_ID",		SaveName:"CMS_CATEG_ID"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"CMS_CATLG_ID",		SaveName:"CMS_CATLG_ID"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"ITEM_GROUP",		SaveName:"ITEM_GROUP"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float",		Header:"STOA_LIST_PRICE",	SaveName:"STOA_LIST_PRICE",		Format:"${priceFormat}"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Int",			Header:"조달일수",				SaveName:"LEAD_TIME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"IMAGE_KEY",			SaveName:"IMAGE_KEY"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"ITEM_DETAIL_DESC",	SaveName:"ITEM_DETAIL_DESC"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"IMGFILE_NAME",		SaveName:"IMGFILE_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"IMGFILE_DIR",		SaveName:"IMGFILE_DIR"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"MSDS_YN",			SaveName:"MSDS_YN"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"MSDS_STATUS",		SaveName:"MSDS_STATUS"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"선입고여부",			SaveName:"PRE_GR_FLAG"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:110,	Hidden:false, 	Type:"Date",		Header:"매출\n단가유효일",		SaveName:"SELL_CLOSE_DATE"}
		,{ Align:"Center",	Width:90,	Edit:false, EditLen:110,	Hidden:false,	Type:"Date",		Header:"매입\n단가유효일",		SaveName:"BUY_CLOSE_DATE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"MOQ",				SaveName:"MIN_ORDER_QTY"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"발주배수",				SaveName:"PUR_UNIT_QTY"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);

	mySheet.SetCellFontUnderline(0, "CANCEL_REMARK_IMG", true);	
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "BTOA_USER_NAME");	//요청자
	setLinkCol(mySheet, "QUOTATION_NO");	//견적번호
	setLinkCol(mySheet, "AGENT_NAME");	//협력사
	setLinkCol(mySheet, "ATOB_REMARK_IMG"); // 비고
	setLinkCol(mySheet, "CANCEL_REMARK_IMG"); // 취소
	setLinkCol(mySheet, "MSDS_NO"); // MSDS 정보
	
}
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	$("#st_if_change").val("N"); 
	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		//소싱부서가 아닐 경우 고객사코드 필수 값.
		if($("#st_sour_dept_yn").val() == "N"){
			if($("#st_buyer_code").val() == null||$("#st_buyer_code").val() == ""){
				alert("고객사은(는) 필수입력 항목입니다.");
				return;
			}
		}
		kepSearch(document.searchCondition,  mySheet , "/mprq/getMasterMpRqUnitpriceAgrmntProxyList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$('#st_buyer_code').val("");
		mySheet.RemoveAll();
		break;

	case "save": // 가합의
		
		var regItemNo = mySheet.GetCellValue(arrRow[0], "REG_ITEM_NO");
		for (var i=0; i<arrRow.length; i++){
	
			if (regItemNo == mySheet.GetCellValue(arrRow[i+1], "REG_ITEM_NO")){
				alert("중복 코드가 존재합니다.");
				return;
			}
			// 매출단가 0원 확인
			if(mySheet.GetCellValue(arrRow[i], "ATOB_UNIT_PRICE") =="0"){
				alert(arrRow[i] + "번째 견적건은 견적단가 0원이므로 가합의 불가능 합니다.\n시스템팀 확인바랍니다.");			
                return;				
			}
			//SLOGIC-BEGIN(P04-4035-01)
			// KEP_건설_두산메카텍 담당자 합의 제한.
			if (mySheet.GetCellValue(arrRow[i], "BUYER") == 'KRKORE0254'){
				alert("KEP_건설_두산메카텍 고객사 견적건은\n\n담당자 합의가 불가합니다.");
				return;
			}
			//SLOGIC-END
			
			if (mySheet.GetCellValue(arrRow[i], "PRODUCT_CLOSE_FLAG") != 'G'){
				alert(arrRow[i] + "번째 품목은 가합의 상태의 품목이 아닙니다.\n\n아래의 고객사 단가합의 버튼을 클릭하여 합의하여 주십시요.");
				return;
			}
			if (kepIsValueNull(mySheet.GetCellValue(arrRow[i], "REG_ITEM_NO")) ||  mySheet.GetCellValue(arrRow[i], "REG_ITEM_NO") == "NO_CODE"){
				alert("카탈로그 등록 코드를 입력하여 주십시요.");
				mySheet.SelectCell(arrRow[i], "REG_ITEM_NO"); 
				return;
			}
		}	
			
		if (!confirm('고객사 단가합의 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqUnitpriceAgrmntProxyList.do" , "SELECTED" );
		break;
		
	case "agrmnt": // 고객사 단가합의
		var status = mySheet.GetCellValue(arrRow[0], "SOURCING_STATUS");
		var msds_yn = mySheet.GetCellValue(arrRow[0], "MSDS_YN");
		for (var i=1; i<=arrRow.length; i++){
			
			if (status != mySheet.GetCellValue(arrRow[i-1], "SOURCING_STATUS")){
				status = "";
			}
			//SLOGIC-BEGIN(P04-4035-02)
			// KEP_건설_두산메카텍 담당자 합의 제한.
			if (mySheet.GetCellValue(arrRow[i-1], "BUYER") == 'KRKORE0254'){
				alert("KEP_건설_두산메카텍 고객사 견적건은\n\n담당자 합의가 불가합니다.");
				return;
			}
			//SLOGIC-END
			/* MSDS 승인프로세스 불필요 제거
			var msds_status = mySheet.GetCellValue(arrRow[i-1], "MSDS_STATUS");
			if(msds_status == "C"){
                alert("MSDS가 승인(승인대행)되지 않았습니다. \n\nMSDS를 확인하시기 바랍니다.");
                return;
            }
			*/
		}
		if (status == ""){
			return;
		}
		if (status == "결재진행중"){
			alert("결재진행중 입니다.단가합의를 할수 없습니다.");
	        return;
		}
		
		if (status == "가합의대상"){
			alert("가합의 대상 실코드 입력후 가합의 버튼을 클릭하여 주십시요.");
	        return;
		}
		var regItemNo = mySheet.GetCellValue(arrRow[0], "REG_ITEM_NO");
		for (var j=0; j<arrRow.length; j++){
			if (kepIsValueNull(mySheet.GetCellValue(arrRow[j], "REG_ITEM_NO"))){
				alert("카탈로그 등록 코드를 입력하여 주십시요.");
				mySheet.SelectCell(arrRow[j], "REG_ITEM_NO"); 
				return;
			}
			
			if (regItemNo == mySheet.GetCellValue(arrRow[j+1], "REG_ITEM_NO")){
				alert("중복 코드가 존재합니다.");
				return;
			}
			// 매출단가 0원 확인
			if(mySheet.GetCellValue(arrRow[i], "ATOB_UNIT_PRICE") =="0"){
				alert(arrRow[i] + "번째 견적건은 견적단가 0원이므로 단가합의 불가능 합니다.\n시스템팀 확인바랍니다.");			
                return;				
			}
		}
		
		if (!confirm('고객사 단가합의 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqUnitpriceAgrmntProxyList.do" , "SELECTED" );
		break;
		
	case "del": // 견적취소
		
		for (var i=0; i<arrRow.length; i++){
			if (mySheet.GetCellValue(arrRow[i],"SOURCING_STATUS") == "견적취소"){
				alert("이미 취소된 견적 입니다.");
				return;
			}
			
			var CANCEL_REMARK    = mySheet.GetCellValue(arrRow[i],"CANCEL_REMARK");
			var CANCEL_REMARK_CODE = mySheet.GetCellValue(arrRow[i],"CANCEL_REMARK_CODE");
			if(CANCEL_REMARK == "" && CANCEL_REMARK_CODE == ""){
				alert("견적 취소 사유를 입력하여 주십시요");
				return;
			}
		}
		if (!confirm('선택한 항목을 견적취소 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mprq/delMasterMpRqReqQuotReceipt.do" , "SELECTED" );
		break;

	case "excelDown": // 엑셀다운로드
		//소싱부서가 아닐 경우 고객사코드 필수 값.
		if($("#st_sour_dept_yn").val() == "N"){
			if($("#st_buyer_code").val() == null||$("#st_buyer_code").val() == ""){
				alert("고객사은(는) 필수입력 항목입니다.");
				return;
			}
		}
	    $("#pageflag").val('0');
		var param = {FileName:"단가합의대행.xlsx",Merge:1,SheetDesign:1,DownCols:"SOURCING_STATUS|BUYER_NAME|REG_ITEM_NO|QUOTATION_NO|BUYER_ITEM_NO|BTOA_DATE|BTOA_END_DATE|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|ITEM_QTY|MAKER_NAME|ORIGIN_NAME|AGENT_NAME|BUYER_TARGET_PRICE|ADMIN_TARGET_PRICE|ATOB_UNIT_PRICE|BTOA_USER_NAME|BTOA_USER_DEPT|ATOB_REMARK|BTOA_REMARK|LEAD_TIME"};
		kepDownExcel(document.searchCondition ,mySheet , "/mprq/excelMasterMpRqUnitpriceAgrmntProxyList.do", param);
		$("#pageflag").val('1');
		break;
	case "IFsave": // IF합의
		
		var status = mySheet.GetCellValue(arrRow[0], "SOURCING_STATUS");
		var msds_yn = mySheet.GetCellValue(arrRow[0], "MSDS_YN");
		for (var i=1; i<=arrRow.length; i++){
			
			
			
			if (status != mySheet.GetCellValue(arrRow[i-1], "SOURCING_STATUS")){
				status = "";
			}
			//SLOGIC-BEGIN(P04-4035-02)
			// KEP_건설_두산메카텍 담당자 합의 제한.
			if (mySheet.GetCellValue(arrRow[i-1], "BUYER") == 'KRKORE0254'){
				alert("KEP_건설_두산메카텍 고객사 견적건은\n\n담당자 합의가 불가합니다.");
				return;
			}
			//SLOGIC-END
			/* MSDS 승인프로세스 불필요 제거
			var msds_status = mySheet.GetCellValue(arrRow[i-1], "MSDS_STATUS");
			if(msds_status == "C"){
                alert("MSDS가 승인(승인대행)되지 않았습니다. \n\nMSDS를 확인하시기 바랍니다.");
                return;
            }
			*/
		}
		if (status == ""){
			return;
		}
		if (status == "결재진행중"){
			alert("결재진행중 입니다.단가합의를 할수 없습니다.");
	        return;
		}
		
		if (status == "가합의대상"){
			alert("가합의 대상 실코드 입력후 가합의 버튼을 클릭하여 주십시요.");
	        return;
		}
		var regItemNo = mySheet.GetCellValue(arrRow[0], "REG_ITEM_NO");
		for (var j=0; j<arrRow.length; j++){
			if (kepIsValueNull(mySheet.GetCellValue(arrRow[j], "REG_ITEM_NO"))){
				alert("카탈로그 등록 코드를 입력하여 주십시요.");
				mySheet.SelectCell(arrRow[j], "REG_ITEM_NO"); 
				return;
			}
			
			if (regItemNo == mySheet.GetCellValue(arrRow[j+1], "REG_ITEM_NO")){
				alert("중복 코드가 존재합니다.");
				return;
			}
			// 매출단가 0원 확인
			if(mySheet.GetCellValue(arrRow[i], "ATOB_UNIT_PRICE") =="0"){
				alert(arrRow[i] + "번째 견적건은 견적단가 0원이므로 I/F합의 불가능 합니다.\n시스템팀 확인바랍니다.");			
                return;				
			}
			
		}
		$("#st_if_change").val('Y'); 
		
		if (!confirm('고객사 I/F합의 하시겠습니까?'))
			return;
		
		kepSave(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqUnitpriceAgrmntProxyList.do" , "SELECTED" );
		break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}	
// 조회 후처리
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
	
	for(var i=1; i<=totRow;i++){
		if (mySheet.GetCellValue(i, "PRODUCT_CLOSE_FLAG") == "G" || (mySheet.GetCellValue(i, "PRODUCT_CLOSE_FLAG") == "S" && mySheet.GetCellValue(i, "BUYER_ITEM_NO").substring(0,7) == "NO_CODE")){
		} else {
			mySheet.SetCellEditable(i,"REG_ITEM_NO",0);
		} 	
	}
   	
	if (msg != "") {
		alert(msg);
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
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqUnitpriceAgrmntProxyList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;
		case "agrmntCntPop": // 고객사 M
			openSearchPopup('/mprq/showMasterMpRqBuyerFinalUnitpriceAgrmntCntPop.do','',"500,350,no");
			popupSel = "agrmntCntPop";
			break;
		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=0000007zo&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'BTOA_USER_NAME') { // 요청자
		var ID = mySheet.GetCellValue(Row,"BTOA_USER_ID");
		if (ID!=""){
			openSearchPopup("/common/userDisplayPop.do", '?user_id='+ID, "800,500,no");
		}
		
	} else if (column == "QUOTATION_NO" ){ 
		popupSel = "quotationReDetailPop";
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
		var revision = mySheet.GetCellValue(Row, "REVISION");
		openSearchPopup("/common/mprq/quotationReDetailPop.do", '?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_revision='+revision, "1020,500,no");

	} else if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");

	} else if (column == "ATOB_REMARK_IMG" ){ 
		popupSel = "remark";
		var btoa_remark = mySheet.GetCellValue(Row, "BTOA_REMARK");
		var atob_remark = mySheet.GetCellValue(Row, "ATOB_REMARK");
		openSearchPopup("/common/remarkPop.do", '?st_btoa_remark='+btoa_remark+'&st_atob_remark='+atob_remark+'&viewType=R'+'&title=ATOB', "500,310,no");
	} else if(column == "CANCEL_REMARK_IMG"){
		popupSel = "cancelRemark";
		var viewType="kepRfqCancel";
		var cancel_remark = mySheet.GetCellValue(Row, "CANCEL_REMARK");
		var cancel_remark_code = mySheet.GetCellValue(Row, "CANCEL_REMARK_CODE");
		openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType+'&cancel_remark_code='+cancel_remark_code,"500,320,no");
	
	} else if(column == "MSDS_NO"){
		popupSel = "getMsdsView";
		var msds_no = mySheet.GetCellValue(Row, "MSDS_NO");
		var msds_yn = mySheet.GetCellValue(Row, "MSDS_YN");
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
		var quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
		var description = mySheet.GetCellValue(Row, "DESCRIPTION");
		var specification = mySheet.GetCellValue(Row, "SPECIFICATION");
		var maker_name = mySheet.GetCellValue(Row, "MAKER_NAME");
		var origin_name = mySheet.GetCellValue(Row, "ORIGIN_NAME");
		var unit_measue = mySheet.GetCellValue(Row, "UNIT_MEASURE");
		
		if(msds_yn == "Y"){
			if(kepIsValueNull(msds_no)){
			   openSearchPopup("/coco/showCommonCoCoMsdsPop.do", '?p_buyer='+buyer+'&p_quotation_no='+quotation_no+'&p_quotation_seq='+quotation_seq+'&p_revision='+revision+'&p_description='+description+'&p_specification='+specification+'&p_maker_name='+maker_name+'&p_origin='+origin_name+'&p_unit='+unit_measue, "950,600,no");
			} else {
			    openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+msds_no+"&st_btn_yn=Y",'750,580,no');
		    }
		}
	}
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
	
	if (mySheet.ColSaveName(Col) == "CANCEL_REMARK_IMG"){ // 견적취소
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
	}
}	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	
	} else if (popupSel == "agrmntCntPop") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	
	}else if(popupSel == "cancelRemark") {	//견적 취소
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK_IMG', (value2!="")? remarkOn : remarkOff);
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK_CODE', value2);
			
	}
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>단가합의대행</h3>
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
			<input type="hidden" id="USR_ID" name="USR_ID"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_group" name="st_user_group"  value="${sessionInfo.userGroup}">
			<input type="hidden" name="st_sour_dept_yn"  id="st_sour_dept_yn" value ="<%=st_sour_dept_yn%>">
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_if_change" name="st_if_change"  value="N">
            	<table  class="cont_t_list01" >
					<caption>단가합의대행</caption>
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
							<th><font color="#FF6600">*</font>고객사</th>
							<td>
								<input type="text" name="st_buyer_name" id="st_buyer_name" style="width:55%" value="" readonly onclick="javascript:doPop('buyer_single');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('agrmntCntPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<th>품목코드</th>
							<td>
								<input type="text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:87%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
							</td>
							<th>진행상태</th>
							<td>
								<select id="st_status" name="st_status" style="width:90%;height:20px">
									<option value="">전체</option>
		                            <option value="합의대상">합의대상</option>
		                            <option value="NEGO합의대상">NEGO합의대상</option>
		                            <option value="결재진행중">결재진행중</option>
		                            <option value="가합의대상">가합의대상</option>
								</select>
							</td>
						</tr>
						<tr> 
							<th>견적번호</th>
							<td>
								<input type="text" id="st_quotation_no" name="st_quotation_no" style="width:87%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
							</td>
							<th>요청자</th>
							<td>
								<input type="text" id="st_btoa_user_name" name="st_btoa_user_name" style="width:87%;" value="" onkeydown="kepEnter()">
							</td>
							<th>품목명/규격</th>
							<td>
								<input type="text" id="st_desc_spec" name="st_desc_spec" style="width:87%;" value="" onkeydown="kepEnter()">
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
  					<span class="btn_04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  				
  				<span class="fr">
  				<%  //구매팀 견적취소 삭제 - 조직개편 2025.08.18
					if(st_sour_dept_yn.equals("N")){
				%>
  					<span class="btn_02 mr04"><a href="javascript:doAction('IFsave');">(I/F)합의</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('save');">가합의</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('agrmnt');">고객사 단가합의</a></span>
  					<span class="btn_02"><a href="javascript:doAction('del');">견적취소</a></span>
  				<%
  					}
  				%>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
