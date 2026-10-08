<%--
**********************************************
* 메뉴 : 상품관리>고객사 카탈로그 관리>카탈로그 조회 및 수정
* 화면 : 카탈로그 계약변경 일괄수정
* 기능 : 고객사 카탈로그 조회, 수정
* 프로그램 ID : PG_03_M_002_00
* 담당자 : CEJ ( 설계 : 권우재 )
* 착수일 : 2014-10-27
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var grbRow = "";
var popupSel = "";
var warehouse_code_list = []; //유효한 물류센터코드 리스트

var areaOn = "/resources/images/icon.gif";
var areaOff = "/resources/images/icon2.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var productGbn = KepSheetComboData("M132","SEL");
    var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};
    var productGbn2 = KepSheetComboData("M074","SEL");
    var comboInfo2 = {ComboCode: productGbn2.ComboCode, ComboText:productGbn2.ComboText};
	var initsheet = {};
	initsheet.Cols = [ 
				 
	     { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
		,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"검증상태",	SaveName:"CHECK_STATUS_TEXT"}     
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"카탈로그관리코드",	SaveName:"TARGET"}       // BUYER(BELOW_COMORG_CODE) 
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사코드",	SaveName:"KEY_6"} 
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사명",	SaveName:"BUYER_NAME"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}     
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AFTER_AGENT"}     
		,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사명",	SaveName:"AFTER_AGENT_TEXT"}     
		,{ Align:"Right",	Width:70,	Edit:true,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${priceFormat}",	Header:"매출가",	SaveName:"AFTER_UNIT_PRICE"}     
		,{ Align:"Right",	Width:70,	Edit:true,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${priceFormat}",	Header:"매입가",	SaveName:"AFTER_LIST_PRICE"}
		,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,  Type:"Combo", Header:"품목구분",	SaveName:"AFTER_ITEM_MAKE_TYPE"}
		,{ Align:"Right",	Width:70,	Edit:true,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${priceFormat}",	Header:"표준납기일",	SaveName:"AFTER_DELIVERY_LT"}
		,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,  Type:"Date",Format:"Ymd", Header:"매출단가유효일",	SaveName:"CH_SELL_CLOSE_DATE"}
		,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,  Type:"Date",Format:"Ymd", Header:"변경전매출단가유효일",	SaveName:"RE_SELL_CLOSE_DATE"}
		,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,  Type:"Date",Format:"Ymd", Header:"매입단가유효일",	SaveName:"CH_BUY_CLOSE_DATE"}
		,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,  Type:"Date",Format:"Ymd", Header:"변경전매입단가유효일",	SaveName:"RE_BUY_CLOSE_DATE"}		
		,{ Align:"Right",	Width:50,	Edit:true,	EditLen:10,		Hidden:false,	Type:"Text",	Header:"MOQ",				SaveName:"CH_MIN_ORDER_QTY"}
		,{ Align:"Right",	Width:60,	Edit:true,	EditLen:10,		Hidden:false,	Type:"Text",	Header:"발주배수",			SaveName:"CH_PUR_UNIT_QTY"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Image",	Header:"납품지역이미지",	SaveName:"SELLER_AREA_IMG"}
		
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"변경전거래유형코드",			SaveName:"RE_PROCESS_TYPE"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"변경전거래유형",			SaveName:"RE_PROCESS_TYPE_TEXT"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"거래유형코드",			SaveName:"CH_PROCESS_TYPE"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"거래유형",			SaveName:"CH_PROCESS_TYPE_TEXT"}
		,{ Align:"Center",	Width:110,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",	Header:"매출단가 변동사유",	SaveName:"UNIT_PRICE_CHANGE_REASON"}
		,{ Align:"Center",	Width:110,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",	Header:"매입단가 변동사유",	SaveName:"LIST_PRICE_CHANGE_REASON"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"변경전물류센터코드",			SaveName:"RE_WAREHOUSE_CODE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"변경전물류센터명",			SaveName:"RE_WAREHOUSE_CODE_TEXT"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"물류센터코드",			SaveName:"CH_WAREHOUSE_CODE"}
		,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"물류센터명",			SaveName:"CH_WAREHOUSE_CODE_TEXT"}
		
		,{ Align:"Center",	Width:50,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"납품지역",			SaveName:"CH_SELLER_AREA"}
		,{ Align:"Right",	Width:50,	Edit:true,	EditLen:10,		Hidden:true,	Type:"Text",	Header:"변경전MOQ",		SaveName:"RE_MIN_ORDER_QTY"}
		,{ Align:"Right",	Width:60,	Edit:true,	EditLen:10,		Hidden:true,	Type:"Text",	Header:"변경전발주배수",	SaveName:"RE_PUR_UNIT_QTY"}
		,{ Align:"Center",	Width:50,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"변경전납품지역",		SaveName:"RE_SELLER_AREA"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"MOQ_사용여부",	SaveName:"MOQ_USE_FLAG"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"납품지역_사용여부",	SaveName:"AREA_USE_FLAG"}
		
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"기존협력사",	SaveName:"AGENT"}     
		,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"전협력사명",	SaveName:"AGENT_TEXT"}     		
		,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${priceFormat}",	Header:"전매출가",	SaveName:"UNIT_PRICE"}     
		,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${priceFormat}",	Header:"전매입가",	SaveName:"LIST_PRICE"}     
		,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${rateFormat}",	Header:"전매익율",	SaveName:"RATE"}     
		,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${rateFormat}",	Header:"후매익율",	SaveName:"AFTER_RATE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,  Type:"Combo", Header:"전품목구분",	SaveName:"ITEM_MAKE_TYPE"}
		,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${priceFormat}",	Header:"전표준납기일",	SaveName:"DELIVERY_LT"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}     
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}     
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}     
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"노(역)마진사유",	SaveName:"MARGIN_RE"}     
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"노(역)마진사유",	SaveName:"MARGIN_RE_TEXT"}     
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준카탈로그",	SaveName:"CMS_CATLG_ID"}     
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"전거래유형",	SaveName:"PROCESS_TYPE"} // 여기 이름 전으로 변경
		
		
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"KEP_PRICE",	SaveName:"KEP_PRICE"}       
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"AFTER_KEP_PRICE",	SaveName:"AFTER_KEP_PRICE"}       
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"계약번호",	SaveName:"CONTRACT_NO"}       
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"계약순번",	SaveName:"CONTRACT_SEQ"}       
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BELOW_COMORG_CODE",	SaveName:"BELOW_COMORG_CODE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사",	SaveName:"BUYER"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"DOC_NAME",	SaveName:"DOC_NAME"}           // KEPMGPDT 
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"업로드 ID",	SaveName:"KEY_7"}       
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"KEY_8",	SaveName:"KEY_8"}       
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"KEY_9",	SaveName:"KEY_9"}
	];

	mySheet.SetImageList(5, areaOn);
	mySheet.SetImageList(4, areaOff);
	
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:24};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetColProperty("AFTER_ITEM_MAKE_TYPE", comboInfo);
	mySheet.SetColProperty("ITEM_MAKE_TYPE", comboInfo);
	mySheet.SetColProperty("UNIT_PRICE_CHANGE_REASON", comboInfo2);
	mySheet.SetColProperty("LIST_PRICE_CHANGE_REASON", comboInfo2);
	
	setLinkCol(mySheet, "SELLER_AREA_IMG");
	setLinkCol(mySheet, "CH_PROCESS_TYPE_TEXT");
	setLinkCol(mySheet, "CH_WAREHOUSE_CODE_TEXT");
	
	kepAjaxCall('/mdcm/getWarehouseCodeList.do','','GETWAREHOUSE'); //유효한 물류센터 코드 가져오기
}
	
// 기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && str !="excelUpload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	} 
	
	var buyer = TrimCommon($("#st_buyer_code").val());

	switch (str) {
	case "search":	 // 조회 
	
		pagingMode = "N";
		kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmCatalogMultiAlter.do" , pagingMode );
		
		break;
		
	case "reload":	// 초기화
		kepReload('searchCondition');
		$("#st_buyer_code").val(""); 
		$("#st_buyer_name").val(""); 
		$("#st_com_org_code").val(""); 
		mySheet.RemoveAll();
		break;
		
	case "del":	// 삭제 
	
	    if (confirm("선택된 내역을 삭제하시겠습니까?")==false) return;
	
		kepSave(document.searchCondition ,  mySheet , "/mdcm/delMasterMdCmCatalogMultiAlter.do" , "SELECTED" );
		break;		
		
	case "excelUpload":	// 엑셀업로드
	
		mySheet.RemoveAll();
		var params = {
			Mode : "HeaderMatch"
		};
		mySheet.LoadExcel(params); 
		break;

	case "excelDown":	// 양식다운로드 
		location.href = "/resources/excel/work/ORDER/masterMdCmCatalogMultiExcel.xlsx";
		break;		
		
	case "modify":	// modify	
		var codeFlag = 'N';
    	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
			if (mySheet.GetCellValue(i, "SELECTED") == "1"){
				var BUYER_ITEM_NO = mySheet.GetCellValue(i, "BUYER_ITEM_NO"); 
				if (BUYER_ITEM_NO == ""){
					alert(i+" 행은 수정대상이 아닙니다.");
					mySheet.SelectCell(i, "BUYER_ITEM_NO");
					return;
				}
				//매출가,매입가에 0원 들어가는 것 방지
				var AFTER_UNIT_PRICE = mySheet.GetCellValue(i, "AFTER_UNIT_PRICE");
				if (AFTER_UNIT_PRICE == "0"){
					alert(i+" 행 매출가에는 0원을 입력할 수 없습니다.");
					mySheet.SelectCell(i, "AFTER_UNIT_PRICE");
					return;
				}
				var AFTER_LIST_PRICE = mySheet.GetCellValue(i, "AFTER_LIST_PRICE");
				if (AFTER_LIST_PRICE == "0"){
					alert(i+" 행 매입가에는 0원을 입력할 수 없습니다.");
					mySheet.SelectCell(i, "AFTER_LIST_PRICE");
					return;
				}
				
				// MOQ, 발주배수
				var moq_use_flag = mySheet.GetCellValue(i, "MOQ_USE_FLAG");
				var min_order_qty = mySheet.GetCellValue(i, "CH_MIN_ORDER_QTY");
				var pur_unit_qty = mySheet.GetCellValue(i, "CH_PUR_UNIT_QTY");
				
				if(moq_use_flag == "Y"){
					if(min_order_qty < 1 || kepIsValueNull(min_order_qty)){
						alert("MOQ(숫자형식)를 입력하세요.(최소값:1)");
						mySheet.SelectCell(i, "CH_MIN_ORDER_QTY");
						return;
					}
					if(pur_unit_qty < 1 || kepIsValueNull(pur_unit_qty)){
						alert("발주배수(숫자형식)를 입력하세요.(최소값:1)");
						mySheet.SelectCell(i, "CH_PUR_UNIT_QTY");
						return;
					}
				}
				
				// 납품지역
				var area_use_flag = mySheet.GetCellValue(i, "AREA_USE_FLAG");
				var seller_area = mySheet.GetCellValue(i, "CH_SELLER_AREA");
				
				if(area_use_flag == "Y"){
					if(kepIsValueNull(seller_area)){
						alert("납품지역을 선택하여 주십시요.");
						mySheet.SelectCell(i, "SELLER_AREA_IMG");
						return;
					}
				}
				
				//거래유형,물류센터 체크
				var re_process_type = mySheet.GetCellValue(i, "RE_PROCESS_TYPE");
				var ch_process_type = mySheet.GetCellValue(i, "CH_PROCESS_TYPE");
				var ch_warehouse_code = mySheet.GetCellValue(i, "CH_WAREHOUSE_CODE");
				if(ch_process_type != "0" && ch_process_type != "1" && ch_process_type != "2" && ch_process_type != "3" ){ //거래유형 잘못입력
					alert(i+" 행 유효하지 않은 거래유형코드 입니다. ");
					mySheet.SelectCell(i, "CH_PROCESS_TYPE");
					return;
				}
				if(ch_process_type == "2" && ch_warehouse_code == ""){ //TR인데 물류센터 코드 없는 경우
					alert(i+" 행 TR은 물류센터코드가 있어야 합니다.");
					mySheet.SelectCell(i, "CH_WAREHOUSE_CODE");
					return;
				}
				if(ch_process_type == "0" && ch_warehouse_code != ""){ //직납인데 물류센터코드 있는 경우
// 					alert(i+" 행 직납은 물류센터코드가 없어야 합니다.");
// 					return;
//					2025.03.28 직납으로 변경할 때 센터가 있더라도 진행되도록 수정
					codeFlag = 'Y';
					mySheet.SetCellValue(i, 'CH_WAREHOUSE_CODE', "");
				}
				if(ch_process_type == "2"){ //유효한 물류센터코드 체크
					var warehouse_check = "N";
					for(var j = 0; j<warehouse_code_list.length ; j++){
						if(ch_warehouse_code == warehouse_code_list[j]){
							warehouse_check = "Y";
							break;
						}
					}
					if(warehouse_check == "N"){
						alert(i+"행 유효하지 않은 물류센터코드 입니다.");
						mySheet.SelectCell(i, "CH_WAREHOUSE_CODE");
						return;
					}
				}
				if(re_process_type != "0" && re_process_type != "2" ){ //기존 거래유형이 직납 or TR이 아닐 경우
					if(re_process_type != ch_process_type){ //거래유형이 변경 된 경우				
						alert(i+" 행 직납이나 TR만 거래유형 변경이 가능합니다.");
						mySheet.SelectCell(i, "CH_PROCESS_TYPE");
						return;
					}
				}
				if(re_process_type == "0" || re_process_type == "2" ){ //기존 거래유형이 직납 or TR일 때
					if(ch_process_type != "0" && ch_process_type != "2"){ //변경할 거래유형이 직납or TR이 아닌 경우				
						alert(i+" 행 직납이나 TR만 거래유형 변경이 가능합니다.");
						mySheet.SelectCell(i, "CH_PROCESS_TYPE");
						return;
					}
				}
				
				// 협력사 체크
				var check_status_text = mySheet.GetCellValue(i, "CHECK_STATUS_TEXT");
				
				if( check_status_text == "협력사정보 없음"){
					alert(i+ "번째 행의 협력사정보를 확인하세요.");
					mySheet.SelectCell(i, "AFTER_AGENT");
					return;
				}
				
				var BEFORE_UNIT_PRICE = mySheet.GetCellValue(i, "UNIT_PRICE");
				if(BEFORE_UNIT_PRICE == AFTER_UNIT_PRICE) {
					if(mySheet.GetCellValue(i, "UNIT_PRICE_CHANGE_REASON") != "") {
						alert(i+ " 행 매출단가 변동 없습니다. 매출단가 변동사유 확인바랍니다.");
						mySheet.SelectCell(i, "UNIT_PRICE");
						return;
					}
				}
				var BEFORE_LIST_PRICE = mySheet.GetCellValue(i, "LIST_PRICE");
				if(BEFORE_LIST_PRICE == AFTER_LIST_PRICE) {
					if(mySheet.GetCellValue(i, "LIST_PRICE_CHANGE_REASON") != "") {
						alert(i+ " 행 매입단가 변동 없습니다. 매입단가 변동사유 확인바랍니다.");
						mySheet.SelectCell(i, "LIST_PRICE");
						return;
					}
				}
				
				
			}
    	} 
    	
    	if (codeFlag == 'Y'){
    		alert("직납인데 물류센터가 있는 경우 직납으로 변경합니다.");
    	}
    	
	    if (confirm("선택된 내역을 수정하시겠습니까?")==false) return;
		
		kepSave(document.searchCondition ,  mySheet , "/mdcm/requestMasterMdCmCatalogSearchPop.do" , "SELECTED" );
		break;		 
	 
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	loader_obj("N");
	return DATA;
}

function mySheet_OnLoadExcel() {
	loader_obj("N");
	
	if (4001 < mySheet.RowCount() + 1) {
		alert("4000건이하의 파일만 업로드하여 주세요.");
		mySheet.RemoveAll();
		return;
	}
	
	setSaveGridtoDB();
}


function setSaveGridtoDB(){	  
	var maxRow = mySheet.RowCount() + 1;     
	 
    for(var i =1; i<=maxRow; i++){
    	mySheet.SetCellValue(i,"SELECTED","1");
    	
    	var v_seller_area = mySheet.GetCellValue(i,"CH_SELLER_AREA");
		var v_seller_area_chk = "";
  		
  		if(v_seller_area.length > 2){ // 납품지역 입력이 있으면
  			v_seller_area_chk = v_seller_area.substr(v_seller_area.length - 2, 2);
  			if(v_seller_area_chk != "__"){ // 마지막 구분자 체크
  				alert("엑셀 "+ i +"번째 행의 납품지역 코드를 확인하여 주십시오.");
  				mySheet.RemoveAll();
  				return;
  			}
  		}
    }   
	kepSave(document.searchCondition ,  mySheet , "/mdcm/batchMasterMdCmCatalogMultiAlter.do" , "SELECTED" );
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
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) { 
	loader_obj("N");
	
	if(!checkedSession(stCode)){return;}  
	
	var msgType = msg.substring(0,2);
	if (msgType == "PM"){ 
		openSearchPopup('/common/approval/buyerCommonApprovalPop.do','?DOC_TYPE=CAM&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg+'&PARAM1=KRKORE0001', "1000,500,no");
	}else{
		if (msg != "") {
			alert(msg);
		}
	}
	
   	doAction('search');
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	pagingMode = "P"; 
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmCatalogMultiAlter.do?page=1" , pagingMode );
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	
	var st_buyer = TrimCommon($("#st_buyer_code").val());
	var st_buyer_name = TrimCommon($("#st_buyer_name").val());
	var st_com_org_code = TrimCommon($("#st_com_org_code").val());
	
	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;  

		case "CatalogExisting": // 기존카탈로그 조회
		
	        if(st_buyer == "")
	        {
	            alert("고객사를 선택해 주십시요.");
	            return;
	        }
		
			openSearchPopup("/mdcm/showMasterMdCmCatalogExistingAlterPop.do", "?st_buyer="+st_buyer+"&st_buyer_name="+st_buyer_name+"&st_com_org_code="+st_com_org_code, "1000,550,no");
			popupSel = "CatalogExisting";
			break;  
			
		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=0000007zi&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
	}
}



//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7, value8){
	
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
		 
	}  else 	if (popupSel == "AFTER_AGENT" ||popupSel == "AFTER_AGENT_TEXT") {
		
		mySheet.SetCellValue(grbRow, 'AFTER_AGENT', value1);   
		mySheet.SetCellValue(grbRow, 'AFTER_AGENT_TEXT', value2);   
		 
	}  else 	if (popupSel == "MARGIN_RE" ||popupSel == "MARGIN_RE_TEXT") {
		
		mySheet.SetCellValue(grbRow, 'MARGIN_RE', value1);   
		mySheet.SetCellValue(grbRow, 'MARGIN_RE_TEXT', value2);   
		 
	}else if (popupSel == "deliAreaPop"){ // 납품지역
		mySheet.SetCellValue(grbRow, 'CH_SELLER_AREA', value1);
	 	 if(value1 ==""){
	 		mySheet.SetCellValue(grbRow, 'SELLER_AREA_IMG', areaOff);
	 	 }else{
	 		mySheet.SetCellValue(grbRow, 'SELLER_AREA_IMG', areaOn);
	 	 }
	}else if(popupSel == "commonCoCoGoodsDlvyClssifyPop2"){
		if(value1 == "0"){ //직납
			mySheet.SetCellValue(grbRow, 'CH_PROCESS_TYPE', value1);
			mySheet.SetCellValue(grbRow, 'CH_PROCESS_TYPE_TEXT', value2);
			mySheet.SetCellValue(grbRow, 'CH_WAREHOUSE_CODE', "");
			mySheet.SetCellValue(grbRow, 'CH_WAREHOUSE_CODE_TEXT', "");
		}
		else{ //TR
			mySheet.SetCellValue(grbRow, 'CH_PROCESS_TYPE', value1);
			mySheet.SetCellValue(grbRow, 'CH_PROCESS_TYPE_TEXT', value2);
			mySheet.SetCellValue(grbRow, 'CH_WAREHOUSE_CODE', value3);
			mySheet.SetCellValue(grbRow, 'CH_WAREHOUSE_CODE_TEXT', value4);
		}
	}  
	grbRow="";	//초기화
}

function setIcomTrxlUpload(query){
	//alert(query);
	$("#st_query").val(query);		
	kepAjaxFormCall("/mdcm/popBatchMasterMdCmCatalogMultiAlter.do","searchCondition","POPBATCH"); 
}

function mySheet_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
	if ( Row  < 1) return;  	
	var column = mySheet.ColSaveName(0 ,Col );   
	
	var AFTER_AGENT = Value;
	var AGENT = mySheet.GetCellValue(Row, 'AGENT');
	
	if (column == "AFTER_AGENT" ){  
		if (AGENT == AFTER_AGENT){
			mySheet.SetCellValue(Row, 'CHECK_STATUS_TEXT', "협력사변경없음");   
		}else{
			mySheet.SetCellValue(Row, 'CHECK_STATUS_TEXT', "정상");   
		}
		fn_AFTER_RATE(Row);
		setKepPricSubValue(Row);
	}
	
	if (RaiseFlag != "0") return; // 직접수정이 아니면 모두 return	
	
	if (column == "AFTER_UNIT_PRICE" ){   // 매출가
		 fn_AFTER_RATE(Row);
		 setKepPricSubValue(Row);
	} else 	if (column == "AFTER_LIST_PRICE" ){   // 매입가
		fn_AFTER_RATE(Row);
		setKepPricSubValue(Row);
	}
	
	
}


//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;  
	
	var column = mySheet.ColSaveName(0 ,Col );  
	
	popupSel = column;	  
	grbRow = Row; 
	
	var AFTER_UNIT_PRICE = mySheet.GetCellValue(Row, 'AFTER_UNIT_PRICE');
	var AFTER_LIST_PRICE = mySheet.GetCellValue(Row, 'AFTER_LIST_PRICE');
	
	if (column == "AFTER_AGENT" || column == "AFTER_AGENT_TEXT" ){  // 협력사협력사변경  
		
		openSearchPopup("/common/icomcmpyPop.do", '?BUSINESS_COND=S&MULTI=N', "500,466,no");
		
	}else 	if (column == "MARGIN_RE" || column == "MARGIN_RE_TEXT"  ){   // 노역마진사유
		
		if (AFTER_UNIT_PRICE == "" || eval(AFTER_UNIT_PRICE) < 1){
			alert("노/역마진일 때만 입력가능합니다.");
			return;
		}else if (AFTER_LIST_PRICE == "" || eval(AFTER_LIST_PRICE) < 1){
			alert("노/역마진일 때만 입력가능합니다.");
			return;
		}else{
			if (eval(AFTER_LIST_PRICE)>=eval(AFTER_UNIT_PRICE)){ 
				openSearchPopup("/mprq/showMasterMpRqMarginReSelectPop.do",'','500,360,no');
			} else {
				alert("노/역마진일 때만 입력가능합니다.");
				return;
			}

		}
		
	}else if(column == "SELLER_AREA_IMG"){
		popupSel = "deliAreaPop";
		var buyer = $("#st_buyer_code").val();
		var seller_area = mySheet.GetCellValue(Row, "CH_SELLER_AREA");
		openSearchPopup("/common/getDeliveryAreaPop.do", '?st_com_code='+buyer+'&st_area_list='+seller_area+'&mod_yn=Y&st_area_chk_flag=N', "400,270,no");
	
	}else if(column == "CH_PROCESS_TYPE_TEXT" || column == "CH_WAREHOUSE_CODE_TEXT"){ //거래유형 , 물류센터명 클릭한 경우
		popupSel = "commonCoCoGoodsDlvyClssifyPop2";
		openSearchPopup("/coco/getCommonCoCoGoodsDlvyClssifyPop2.do?st_gubun=RQ", "", "500,250,no");
	}
}

	

// 후매익율 계산
function fn_AFTER_RATE(row){
	//DECODE(X.UNIT_PRICE,0,0,ROUND(((X.UNIT_PRICE - X.LIST_PRICE)/X.UNIT_PRICE) *100,1)) 
	var AFTER_UNIT_PRICE = mySheet.GetCellValue(row, 'AFTER_UNIT_PRICE');
	var AFTER_LIST_PRICE = mySheet.GetCellValue(row, 'AFTER_LIST_PRICE');
	var UNIT_PRICE = mySheet.GetCellValue(row, 'UNIT_PRICE');
	var LIST_PRICE = mySheet.GetCellValue(row, 'LIST_PRICE');
	var AFTER_AGENT = mySheet.GetCellValue(row, 'AFTER_AGENT');
	var AGENT = mySheet.GetCellValue(row, 'AGENT');
	var after_rate = 0;
	if (AFTER_UNIT_PRICE == "" || eval(AFTER_UNIT_PRICE) < 1){
		after_rate = 0;
	}else if (AFTER_LIST_PRICE == "" || eval(AFTER_LIST_PRICE) < 1){
		after_rate = 0;
	}else{
		after_rate = kepGetRound(eval(((eval(AFTER_UNIT_PRICE)-eval(AFTER_LIST_PRICE))/eval(AFTER_UNIT_PRICE))*100),3);
	}
	mySheet.SetCellValue(row, 'AFTER_RATE', after_rate);    
	
	if (UNIT_PRICE == AFTER_UNIT_PRICE || AFTER_UNIT_PRICE == 0){
		mySheet.SetCellValue(row, 'CHECK_STATUS_TEXT', "매출가변경없음");   
	}
	else if (LIST_PRICE == AFTER_LIST_PRICE  || AFTER_LIST_PRICE == 0){
		mySheet.SetCellValue(row, 'CHECK_STATUS_TEXT', "매입가변경없음");   
	}	
	else if (AGENT == AFTER_AGENT){
		mySheet.SetCellValue(row, 'CHECK_STATUS_TEXT', "협력사변경없음");   
	}else{
		mySheet.SetCellValue(row, 'CHECK_STATUS_TEXT', "정상");   
	}
}


//매출원가
function setKepPricSubValue(row) {  
	//매출원가 계산
	/* TOBE에서는 매출원가가 삭제됨으로 인해 계산하는 펑션도 주석처리. */
	/* 똑같은걸 옮긴다 */
	var KEP_PRICE = mySheet.GetCellValue(row, 'KEP_PRICE');
	mySheet.SetCellValue(row, 'AFTER_KEP_PRICE', KEP_PRICE); // 매출원가
	
	 
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){

	
	if(pMethod == "GETWAREHOUSE"){ //물류센터코드 조회
		warehouse_code_list = response.TEXT1.split('@');
		return;
	}
 	//var sMsg = response.msg.MSG;    

     if(pMethod == "POPBATCH")  // 카탈로그조회 등록 일괄 (팝업에서)
     { 
  	   alert("등록 되었습니다.   ");        
     }
   	 // 처리후 재조회
   	doAction('search');
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {

	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");  
	 
	
} 

function kepApprovalReturn(ERR,GW_NO){ 
   	doAction('search');
}
 
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>카탈로그 계약변경 일괄수정</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
		    <span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition"  id="searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
			<input type="hidden" id="trxl_gubun" name="trxl_gubun"  value="CAM">
			<input type="hidden" id="onepagerow" name="onepagerow"  value="1000">
			<input type="hidden" id="st_query" name="st_query"  value="">
			
            	<table  class="cont_t_list01" >
					<caption>카탈로그 조회 및 수정</caption>
					<colgroup>
						<col width="8%" />
						<col width="35%" />
						<col width="8%" />
						<col width="35%" /> 
						<col width="*" /> 
					</colgroup>
						
					<tbody>
						<tr>
							<th>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:55%" value="" readonly>
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
								<input type="hidden" name="st_com_org_code" id="st_com_org_code" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>기안정보</th>
							<td> 
							${sessionInfo.departmentName} ${sessionInfo.userNameLoc} 님							
							</td>	 
							<td>
							<span class="btn_gray_08" title="품목코드" ><a href="javascript:doPop('CatalogExisting');">기존카탈로그 조회</a></span> 
        					 </td>
						</tr>							
					</tbody>
				</table>
            </div>
  
		</form>
		&nbsp;<font color="red">* 엑셀 업로드시 고객사, 품목코드, 계약번호, 계약순번은 필수입니다. 변경 없으면 기존 값 입력후  엑셀 업로드 하여야 조회가 됩니다.</font>
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div> 
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
  			<div class="btnArea02">
  				<span class="fl">
  					<font  size: 12px;">※ 엑셀업로드시 노란셀에 입력한 값만 반영되며, 미입력 항목은 기존 계약정보로 반영됩니다.</font>
  	          	</span>
  	          	<br>
  				<span class="fl">
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelUpload');">엑셀업로드</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀양식</a></span>
  				</span>
  				
  	          	<span class="fr">
  					<span class="btn_05 mr04"><a href="javascript:doAction('del');">삭제</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('modify');">일괄수정</a></span>
  				</span>  				
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
