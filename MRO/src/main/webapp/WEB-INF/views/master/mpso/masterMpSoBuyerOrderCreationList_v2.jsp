<%--
**********************************************
* 메뉴 : 주문관리>고객사 주문생성
* 화면 : 고객사 주문생성
* 기능 : 고객사의 업무대행으로 발주데이터를 생성하기 위한 화면
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-09-17
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String toDate			  = CommonUtil.formatDate(new Date(),1,"/");


%>
<script type="text/javascript">
</script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = ""; 
var tractionSel = "";
var searchSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:50,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태|상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:50,	Edit : true,	EditLen:80,	Hidden : false,	Type:"DummyCheck",	Header:"선택|선택",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"엑셀|담당자",	SaveName:"KEP_USER_ID"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"엑셀|고객사코드",	SaveName:"BUYER"}
					,{ Align:"Center",	Width:140,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"엑셀|고객사명",	SaveName:"BUYER_NAME"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"엑셀|협력사코드",	SaveName:"AGENT"} 
					,{ Align:"Center",	Width:140,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"엑셀|협력사명",	SaveName:"AGENT_NAME"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"엑셀|품목코드",	SaveName:"BUYER_ITEM_NO"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:80,	Hidden:true,	Type:"Text",	Header:"엑셀|관리번호",	SaveName:"REF_PR_NO"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"엑셀|매출단가",	SaveName:"UNIT_PRICE"} 
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"엑셀|매입단가",	SaveName:"LIST_PRICE"} 
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"엑셀|주문수량",	SaveName:"ITEM_QTY"} 
					
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"업로딩결과|업로딩결과 ->",	SaveName:"X"}  
					,{ Align:"Center",	Width:140,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"업로딩결과|협력사명",	SaveName:"AGENT_NAME1"} 
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"업로딩결과|품목코드",	SaveName:"BUYER_ITEM_NO1"} 
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"업로딩결과|매출단가",	SaveName:"CHANGE_UNIT_PRICE"} 
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"업로딩결과|매입단가",	SaveName:"CHANGE_LIST_PRICE"} 
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:150,	Hidden:false,	Type:"Text",	Header:"업로딩결과|벌크 업로딩결과",	SaveName:"TOT_FLAG_TEXT" ,FontColor:"red"}  
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사카탈로그|고객사카탈로그 ->",	SaveName:"X"}  
					,{ Align:"Center",	Width:140,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"고객사카탈로그|협력사명",	SaveName:"AGENT_NAME2"} 
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"고객사카탈로그|품목코드",	SaveName:"BUYER_ITEM_NO2"} 
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"고객사카탈로그|매출단가",	SaveName:"UNIT_PRICE2"} 
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"고객사카탈로그|매입단가",	SaveName:"LIST_PRICE2"} 					
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사카탈로그|벌크 업로딩결과",	SaveName:"TOT_FLAG"}  
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사카탈로그|AGENT1",	SaveName:"AGENT1"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사카탈로그|MSDS미매핑",	SaveName:"MSDS_ERR"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:12};
	IBS_InitSheet(mySheet, initsheet,pagingMode); 
	
	// 조회조건 초기화 
	kepSetCalender("st_create_date");
	kepSetCalender("st_rddate_date");
	kepSetCalender("st_dsdate_date");
	kepSetCalender("st_invoice_date");
	kepSetCalender("st_delivery_date");
	kepSetCalender("st_gr_date"); 
	 
	
	$("#st_process").val("N");
	$("#st_confirm_flag").val("N");
	$("#st_process_del").val("N");
	 
}

function formReset() {      $('#searchCondition').each(function(){         this.reset();   

$("#st_buyer_code").val("");
$("#st_req_user_id").val("");
$("#st_purchaser_id").val("");
$("#st_location_code").val("");
$("#st_reason_text").val("");
$("#st_reason_attkey").val("");
$("#st_purchaser_dept").val(""); 

});  }
		
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	tractionSel = "";
	
	// 선택된 항목 유무 체크
	if (str !="search1" && str !="search" && str !="excelDown" && str !="excelUpload" && str !="orderCreate"  && str !="reload" && str !="del_buyer_single" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	
	case "search1":	 // 조회
	
	
		var buyer = $("#st_buyer_code").val();  	 
		if(buyer == "") {
			alert("고객사를 선택해 주십시오.  ");
			return;
		}
		
		$("#st_process").val("N");
		$("#st_confirm_flag").val("N");
		$("#st_process_del").val("N");
		current_page = -1;  
		kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoBuyerOrderCreationListExcelResult.do" , pagingMode );  
		break;
		
	case "search":	 // 조회 
	
		var buyer = $("#st_buyer_code").val();  	 
		if(buyer == "") {
			alert("고객사를 선택해 주십시오.  ");
			return;
		}
		current_page = -1;  
		kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoBuyerOrderCreationListExcelResult.do" , pagingMode );  
		break;
	
	case "reload":	// 초기화
		formReset();
		mySheet.RemoveAll();
		$("#st_process").val("N");
		$("#st_confirm_flag").val("N");
		$("#st_process_del").val("N");
		$("#st_buyer_code").val("");
		$("#st_req_user_id").val("");
		$("#st_req_user_dept").val("");
		$("#st_purchaser_id").val("");
		$("#st_location_code").val("");
		$("#st_purchaser_dept").val("");
		$("#st_reason_attkey").val("");
	   	$("#diskimg").attr("src","/resources/images/disk_off.gif");  
	   	$("#st_aply_range").hide();
		$("#st_aply_range").val("PO");
		break;
		
	case "excelUpload":	// 엑셀업로드
		mySheet.RemoveAll();
		var params = {
			Mode : "HeaderMatch"
		};
		mySheet.LoadExcel(params);
		/*
		
      select buyer, BUYER_ITEM_NO ,UNIT_PRICE , LIST_PRICE ,AGENT  from ICOMCQDT where STATUS      <> 'D'  and buyer = 'KRKOLO0031';
        */
		break;

	case "excelDown":	// 양식다운로드 
		location.href = "/resources/excel/work/ORDER/buyerorder.xlsx";
		break;
		
	case "excelCheck":	// 업로드검증 사용안함
		alert("엑셀업로드 검증 준비중"); 
		break;
		
	case "save":	// 업로드검증 결과를 저장 
	
		$("#st_process_del").val("N");
		if ($("#st_process").val() == "N"){ // 엑셀 업로드 검증 후 결과 조회 
			alert("엑셀업로드 검증이 진행되지 않았습니다. 엑셀업로드 다시 부탁드립니다.");
		}else{
		    if (confirm("엑셀업로드 검증 진행하시겠습니까?")==false) return; 
		    $("#st_process").val("AFTER");
			kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoBuyerOrderCreationListExcelCheckResult.do" , "SELECTED" );
		}
		break;
		
	case "del":	// 삭제
	
		$("#st_process_del").val("DEL");
	    if (confirm("선택된 내역을 정말로 삭제하시겠습니까?")==false) return;
		kepSave(document.searchCondition ,  mySheet , "/mpso/delMasterMpSoBuyerOrderCreationList.do" , "SELECTED" );
		break;
		
	case "orderCreate":	// 주문생성
	 
	/*
		var confirm_flag = $("#st_confirm_flag").val(); 
		if(confirm_flag != "Y"){
			 alert("Uploading 검증되지 않았습니다. \n\n 파일 업로드 후 검증해주세요..!!  ");
			 return;
		}	  
		*/
		var aply_type = $("#st_aply_range").val();
		var cnt = 0;
		var errCnt=0;
		var title = "";
		var maxRow = mySheet.RowCount() + 1;     
	    for(var i = 2; i<=maxRow; i++){
// 	    	if (mySheet.GetCellValue(i, "SELECTED") == "1"){
				var TOT_FLAG_TEXT = mySheet.GetCellValue(i, "TOT_FLAG_TEXT");
				if (TOT_FLAG_TEXT != "정상"){
					title = title + (i-1) + "행  ["+TOT_FLAG_TEXT + "] \n";
					cnt ++;
					errCnt++;
				}
				else if (TOT_FLAG_TEXT == ""){
					title = title + (i-1) + "행  [검증안한상태] \n";
					cnt ++;
				}
				
				var MSDS_ERR = mySheet.GetCellValue(i, "MSDS_ERR");
				var BUYER_ITEM_NO = mySheet.GetCellValue(i, "BUYER_ITEM_NO");
				if(MSDS_ERR == "Y" && aply_type != "PO"){
					alert("고객사 카탈로그의 MSDS 미매핑 품목입니다. 매핑 후 진행하시기 바랍니다.");
					mySheet.SelectCell(i, "BUYER_ITEM_NO");
					return;
				}
// 	    	}
	    }  
	    
		if (cnt != 0){ 
			title = title + "주문생성 대상이 아닙니다.";
			alert(title);
			return;
		}
		
		if (errCnt != 0){ 
			title = title + "검증에 실패한 건이 존재 합니다. \n데이터를 다시 한번 확인해 주십시오.";
			alert(title);
			return;
		}
		
		 
		var buyer = $("#st_buyer_code").val(); 
		var req_user_id = $("#st_req_user_id").val(); 
		var purchaser_id = $("#st_purchaser_id").val(); 
		var location_code = $("#st_location_code").val();
		var location_name = $("#st_location_name").val();
		var reason_text = $("#st_reason_text").val(); 
		var reason_attkey = $("#st_reason_attkey").val(); 
		 
	 
		if(buyer == "") {
			alert("고객사를 선택해 주십시오.  ");
			return;
		}
		if(req_user_id == "") {
			alert("주문요청자를 지정해 주십시오.  ");
			return;
		}
		if(purchaser_id == "") {
			alert("발주자를 지정해 주십시오.  ");
			return;
		}
		if(location_code == "" && location_name == "") {
			alert("배송처를 지정해 주십시오.  ");
			return;
		}
		if(reason_text == "") {
			alert("근거내용을 입력해 주십시오.  "); 
			$("#st_reason_text").focus();
			return;
		}
	 
		if(reason_attkey == "") {
			alert("근거내용 첨무분서를 등록해 주십시오.  ");
			return;
		}
		 
		
		var maxRow = mySheet.RowCount() + 1;     
	    for(var i = 2; i<=maxRow; i++){
	    	//mySheet.SetCellValue(i,"SELECTED","1");
	    }  
		
		$("#st_process").val("ORDERCREATE"); 
		$("#st_process_del").val("N");
// 		kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoBuyerOrderCreationList.do" , "SELECTED" );
		kepSaveAll(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoBuyerOrderCreationList.do");
		break;
		
	case "del_buyer_single":
		$("#st_buyer_code").val("");
		$("#st_buyer_name").val("");
		$("#st_aply_range").hide();
		$("#st_aply_range").val("PO");
		break;
	}
}

function mySheet_OnLoadExcel() {
 
	if (1000 < mySheet.RowCount() + 1) {
		alert("1000건이하의 파일만 업로드하여 주세요.");
		mySheet.RemoveAll();
		return;
	} 
	setSaveGridtoDB();
}


function setSaveGridtoDB(){	  
	var maxRow = mySheet.RowCount() + 1;     
	 
    for(var i = 2; i<=maxRow; i++){
    	mySheet.SetCellValue(i,"SELECTED","1");
    }  
	$("#st_confirm_flag").val("N");
	$("#st_process").val("BEFORE");
	kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoBuyerOrderCreationListExcelCheck.do" , "SELECTED" );
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

   	
	var maxRow = mySheet.RowCount() + 1;     
	if (msg != "") { 
		alert(msg);
	}
	
	if ($("#st_process_del").val() == "DEL") {    // 삭제
	}else{		
		if ($("#st_process").val() == "BEFORE"){ // 엑셀 업로드 검증 후 결과 조회 를 보고 저장실행		
		    for(var i = 2; i<=maxRow; i++){
		    	mySheet.SetCellValue(i,"SELECTED","1");
		    }  
			doAction('save');
		} else if ($("#st_process").val() == "AFTER"){ 
			/*
		    for(var i = 2; i<=maxRow; i++){
		    	mySheet.SetCellValue(i,"SELECTED","1");
		    }  
		    $("#st_process").val("ORDERCREATE");
			doAction('orderCreate');// 주문생성
			*/
		} else{ 
			$("#st_process").val("N"); 
		}		
	}  
	if ($("#st_process").val() == "ORDERCREATESUCCESS" || $("#st_process").val() == "ORDERCREATE") {// 주문생성
	}else{
	    for(var i = 2; i<=maxRow; i++){ 
	    	if (kepTrimStr(mySheet.GetCellValue(i,"TOT_FLAG_TEXT")) != ""){
	    		 $("#st_process").val("AFTER");
	    	}
	    }  
	}
	

	/*
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	*/
	
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	var docu_no = "";
	if ($("#st_process").val() == "ORDERCREATE"){ // 주문생성
		if (msg != "") {
			docu_no = msg;
		}
	}else{
		if (msg != "") {
		//	alert(msg);
		}
	}
	if(code == 0){
		alert(msg);
		mySheet.RemoveAll();
		return;
	}
	 
	$("#st_confirm_flag").val("N");	 
	if ($("#st_process_del").val() == "DEL") {    // 삭제
	}else{		
		if ($("#st_process").val() == "BEFORE"){ // 엑셀 업로드 검증 후 결과 조회  
			doAction("search");
			return;
		} else if ($("#st_process").val() == "AFTER"){  // 엑셀업로드 검증결과 저장 
			$("#st_confirm_flag").val("Y");
			doAction("search");
			return;
		} else if ($("#st_process").val() == "ORDERCREATE"){ // 주문생성 
		    //alert("결재상신 요청을 위한 전처리 결과 PM을 이용하여 호출"); 
		
		   var PARAM1 = ""; 
			var maxRow = mySheet.RowCount() + 1;     
		    for(var i = 2; i<=maxRow; i++){
// 				var selectedGrid = mySheet.FindCheckedRow("SELECTED");
// 				if(selectedGrid.length == 0){  
// 				}else{
					
// 					if (mySheet.GetCellValue(i,"SELECTED")=="1")
// 					{			
						PARAM1 +=  mySheet.GetCellValue(i,"BUYER") +"@@"+ mySheet.GetCellValue(i,"BUYER_ITEM_NO") +"@@"+ mySheet.GetCellValue(i,"KEP_USER_ID")+"@@^||^";
// 					}
// 				}
			}  
		    openSearchPopup('/common/approval/buyerCommonApprovalPop.do','?DOC_TYPE=OF&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+docu_no+'&PARAM1='+PARAM1 , "1000,500,no");
			return;
		}
	}
 
	 
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

function kepApprovalReturn(flag,docu_no){
	
	$("#st_confirm_flag").val("N");	  
	$("#st_process").val("ORDERCREATESUCCESS");	  
	$("#st_process_del").val("N");
	
	doAction("search");
}

function setFileAttach_Insert() {
	var type = "OF";
	var viewType = "C";
	var img_key = $("#st_reason_attkey").val(); 	   	
	popupSel = "setFileAttach_Insert";
	kepFileUploadOpenPopup(img_key,type,viewType); 
}
 
// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	//current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoBuyerOrderCreationList.do" , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	var com_buyer =	$("#st_buyer_code").val();
	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no"); 
			break;
			
		case "req_user_name": // 주문요청자
			if (com_buyer == "") {
				alert("고객사를 선택하세요.");
				return;
			} 
			openSearchPopup('/common/misUserSelectAllPop.do', "?open=O&com_code="+com_buyer , "500,500,no"); 
			break;

		case "purchaser_name": // 발주자명
			if (com_buyer == "") {
				alert("고객사를 선택하세요.");
				return;
			}
			openSearchPopup('/common/misUserSelectAllPop.do', "?open=O&com_code="+com_buyer , "500,500,no"); 
			break;
			
		/* case "zipCode": // ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
			openSearchPopup("/common/zipCodeSearchPop.do", "?1=1", "500,666,no");
			break;	 */
		
		case "newzipCode": // 우편번호검색
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");
			break;
			
		case "DelyToLocation": // 도착지선택
			if (com_buyer == "") {
				alert("고객사를 선택하세요.");
				return;
			}
			openSearchPopup("/common/delLocationPop.do","?com_code="+com_buyer+"&open=Y" , "500,500,no"); 
			break;			
			
		case "purchaser_dept_name": // 발주부서 
			if (com_buyer == "") {
				alert("고객사를 선택하세요.");
				return;
			}
			openSearchPopup("/common/deptCodeAdminBuyerPop.do","?com_code="+com_buyer+"&open=Y" , "500,500,no"); 
			break;			 
	

	}
	
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 2) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
 
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5 ,value6, value7, value8, value9){
	
	if (popupSel == "buyer_single") {	// 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
		specialCheck(value1);
// 		doAction("search1");
		
	}else 	if (popupSel == "req_user_name") {	// 주문요청자
		$("#st_req_user_id").val(value1);
		$("#st_req_user_name").val(value2);
		$("#st_req_user_dept").val(value3);
		$("#st_req_user_dept_name").val(value4);
		
		$("#st_req_user_phone").val(value9);
		$("#st_req_user_fax").val(value7);
		$("#st_req_user_email").val(value6);
		
		
	}else 	if (popupSel == "purchaser_name") {	// 발주자명
		$("#st_purchaser_id").val(value1);
		$("#st_purchaser_name").val(value2);
		$("#st_purchaser_dept").val(value3);
		$("#st_purchaser_dept_name").val(value4);
	}else 	if (popupSel == "zipCode") {	// 우편번호검색
	//	$("#st_buyer_code").val(value1);
	//	$("#st_buyer_name").val(value2);
	}else 	if (popupSel == "DelyToLocation") {	// 도착지선택
		$("#st_location_code").val(value1);
		$("#st_location_name").val(value2);
	}else 	if (popupSel == "purchaser_dept_name") {	// 발주부서
		$("#st_purchaser_dept").val(value1);
		$("#st_purchaser_dept_name").val(value2);
	}else 	if (popupSel == "setFileAttach_Insert") {	 // 파일첨부
	   	$("#st_reason_attkey").val(value1); 	   	 
	   	$("#diskimg").attr("src","/resources/images/disk_"+value2+".gif");  
	}
	
	 
	grbRow="";	//초기화
}
/* 
// ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
function setZipPopupReturn(str_zipcode, str_zip_key, str_si, str_gu, str_do, str_bd, str_bdnm, str_dong)
{      
	$("#st_location_name").val(str_zipcode+"  " +str_si+" "+str_gu+" "+str_do+" "+str_bd);
	grbRow="";	//초기화
}
 */

function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){      
	$("#st_location_name").val(zipNo.replace(/[^0-9]/gi, '') + "  " + roadAddrPart1 + " " + roadAddrPart2 + " " + addrDetail);
	grbRow="";	//초기화
}

function aply_range_change(){
	var aply_type = $("#st_aply_range").val();
	var today_date = "<%=toDate%>";
	
	if(aply_type == "PO"){
		$("#st_dsdate_date").val("");
		$("#st_dsdate_date").datepicker("option", "disabled", true);
		$("#st_invoice_date").val("");
		$("#st_invoice_date").datepicker("option", "disabled", true);
		$("#st_delivery_date").val("");
		$("#st_delivery_date").datepicker("option", "disabled", true);
		$("#st_gr_date").val("");
		$("#st_gr_date").datepicker("option", "disabled", true);
	}else if(aply_type == "DO"){
		$("#st_dsdate_date").val(today_date);
		$("#st_dsdate_date").datepicker("option", "disabled", false);
		$("#st_invoice_date").val("");
		$("#st_invoice_date").datepicker("option", "disabled", true);
		$("#st_delivery_date").val("");
		$("#st_delivery_date").datepicker("option", "disabled", true);
		$("#st_gr_date").val("");
		$("#st_gr_date").datepicker("option", "disabled", true);
	}else if(aply_type == "IV"){
		$("#st_dsdate_date").val(today_date);
		$("#st_dsdate_date").datepicker("option", "disabled", false);
		$("#st_invoice_date").val(today_date);
		$("#st_invoice_date").datepicker("option", "disabled", false);
		$("#st_delivery_date").val("");
		$("#st_delivery_date").datepicker("option", "disabled", true);
		$("#st_gr_date").val("");
		$("#st_gr_date").datepicker("option", "disabled", true);
	}else if(aply_type == "DI"){
		$("#st_dsdate_date").val(today_date);
		$("#st_dsdate_date").datepicker("option", "disabled", false);
		$("#st_invoice_date").val(today_date);
		$("#st_invoice_date").datepicker("option", "disabled", false);
		$("#st_delivery_date").val(today_date);
		$("#st_delivery_date").datepicker("option", "disabled", false);
		$("#st_gr_date").val("");
		$("#st_gr_date").datepicker("option", "disabled", true);
	}else if(aply_type == "GR"){
		$("#st_dsdate_date").val(today_date);
		$("#st_dsdate_date").datepicker("option", "disabled", false);
		$("#st_invoice_date").val(today_date);
		$("#st_invoice_date").datepicker("option", "disabled", false);
		$("#st_delivery_date").val(today_date);
		$("#st_delivery_date").datepicker("option", "disabled", false);
		$("#st_gr_date").val(today_date);
		$("#st_gr_date").datepicker("option", "disabled", false);
	}
}
function specialCheck(com_code){
	$("#comCode").val(com_code);
	$("#slgId").val("MCA00001");
	kepAjaxFormCallNoBar("/mdam/getSpecialCheckReturn.do","slgForm","specialCheck");
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod, response) {
	var sMsg = response.msg;
	if (pMethod == "specialCheck"){
		var data = response.data;
		if(data.length != 0){
			$("#st_aply_range").show();
			$("#st_aply_range").val("GR");
		}else{
			$("#st_aply_range").hide();
			$("#st_aply_range").val("PO");
		}
		
	}
}

// ajax 공통 호출후 에러시 처리 함수
function kepAjaxError(pMethod, response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다. ");
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>고객사 주문생성</h3>
        	<span class="btn_search"><a href="javascript:doAction('search1')">조회</a></span> 
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
			<input type="hidden" id="st_kep_user_id" name="st_kep_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" name="st_confirm_flag" id="st_confirm_flag" value="">
			<input type="hidden" name="st_process" id="st_process" value="">
			<input type="hidden" name="st_process_del" id="st_process_del" value="">
			<input type="hidden" name="st_user_remark" id="st_user_remark" value="">
            	<table  class="cont_t_list01" >
					<caption>고객사 주문생성</caption>
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
							<th><font color="red"><b>*</b></font>고객사</th>
									<td>
			                       <input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:60%;" value = "" READONLY> <!-- KRKOLO0031 -->
			                       <input type="hidden" name="st_buyer_code" id="st_buyer_code" value ="">
			                       <a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
			                       <a href="javascript:doAction('del_buyer_single');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>적용범위</th>
								<td>
									발주 ~ 
									<select id="st_aply_range" name="st_aply_range" style="width:70px; vertical-align:bottom; display: none;" onChange="aply_range_change()" >
										<option value="PO">발주</option>
										<option value="DO">수주</option>
										<option value="IV">납품</option>
										<option value="DI">확정</option>
										<option value="GR" selected>입고</option>
									</select>
								</td>
							<td>
							</td>
							<td>
							</td>
						</tr>
						<tr>
							<th><font color="red"><b>*</b></font>주문요청자</th>
							<td>
		                        <input type="text" class="input_type_text" name="st_req_user_name" id="st_req_user_name" style="width:60%;" value ="" READONLY>
					        	<input type="hidden" name="st_req_user_id" id="st_req_user_id" value="">
					        	<input type="hidden" name="st_req_user_dept"  id="st_req_user_dept" value="">
					        	<input type="hidden" name="st_req_user_dept_name"  id="st_req_user_dept_name"  value="">
		                        <a href="javascript:doPop('req_user_name');"><img src="/resources/images/btn_search03.gif"></a>
		                        <a href="javascript:kepEraser('st_req_user_id','st_req_user_name');"><img src="/resources/images/btn_eraser2.gif"></a>
	                           </td>  
							<th><font color="red"><b>*</b></font>발주자명</th>
							<td>
			                       <input type="text" class="input_type_text" name="st_purchaser_name" id="st_purchaser_name" style="width:67%;" value = "" READONLY><!-- 1209005 -->
			                       <input type="hidden" name="st_purchaser_id" id="st_purchaser_id" value ="">
			                       <a href="javascript:doPop('purchaser_name');"><img src="/resources/images/btn_search03.gif"></a>
			                       <a href="javascript:kepEraser('st_purchaser_id','st_purchaser_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th><font color="red"><b>*</b></font>근거내용</th>
							<td>
		                      	<input type="text" class="input_type_text"  name="st_reason_text"  id="st_reason_text"  style="width:85%" value="">
        						<input type="hidden" name="st_reason_attkey"   id="st_reason_attkey"  value="">
  								<a href="javascript:setFileAttach_Insert();"><img src="/resources/images/ico_file.gif" id="diskimg"  border="0" alt="파일"></a>    
	                           </td> 
				       </tr>				       
						 <tr>
							<th>배송처</th>
							<td colspan="2">
						        <input type="text"  class="input_type_text"  name="st_location_name" id="st_location_name" style="width:90%" value="" ><br/>
						        <input type="hidden" name="st_location_code" id="st_location_code" value=""> 
							</td>
							<td colspan="3">
						          <!-- <a href="javascript:doPop('zipCode');"><span class="btn_gray_05" title="우편번호검색">우편번호</span></a> (ex.지정되지 않은 도착지일 경우 사용)>	ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 -->
						          <a href="javascript:doPop('newzipCode');"><span class="btn_gray_05" title="우편번호검색">우편번호</span></a> (ex.지정되지 않은 도착지일 경우 사용)
						          <a href="javascript:doPop('DelyToLocation');"><span class="btn_gray_04" title="도착지선택">도착지</span></a> (ex.지정된 도착지를 선택) 
							</td>
				       </tr>			
				      <tr>	       
				       		<th>전화번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_req_user_phone" name="st_req_user_phone" style="width:80%;" value=""  READONLY onkeydown="kepEnter()">
							</td>
							<th>팩스번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_req_user_fax" name="st_req_user_fax" style="width:80%;" value="" READONLY onkeydown="kepEnter()">
							</td>
							<th>이메일</th>
							<td>
								<input type="text" class="input_type_text" id="st_req_user_email" name="st_req_user_email" style="width:80%;" value="" READONLY onkeydown="kepEnter()">
							</td>							
						</tr>
				      <tr>	       
				       		<th>발주부서</th>
							<td>
									 <input type="text" class="input_type_text" name="st_purchaser_dept_name" id="st_purchaser_dept_name" style="width:67%;" value = "" READONLY>  <!-- KRKOLO0031 -->
			                       <input type="hidden" name="st_purchaser_dept" id="st_purchaser_dept" value ="">
			                       <a href="javascript:doPop('purchaser_dept_name');"><img src="/resources/images/btn_search03.gif"></a>
			                       <a href="javascript:kepEraser('st_purchaser_dept','st_purchaser_dept_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>휴대전화</th>
							<td>
								<input type="text" class="input_type_text" id="st_user_mobile" name="st_user_mobile" style="width:80%;" value=""   onkeydown="kepEnter()">
							</td>
							<th></th>
							<td>
							</td>							
						</tr>
						<tr>
							<th>발주일</th>
							<td>
								<input type="text" class="input_type_text" name="st_create_date" id="st_create_date" readOnly style="width:80px; text-align:center;" value="<%=toDate%>"> 						
							</td>
							<th>납기요청일</th>
							<td>
								<input type="text" class="input_type_text" name="st_rddate_date" id="st_rddate_date" readOnly style="width:80px; text-align:center;" value="<%=toDate%>"> 					
							</td>
							<th>납품예정일</th>
							<td>
								<input type="text" class="input_type_text" name="st_dsdate_date" id="st_dsdate_date" readOnly style="width:80px; text-align:center;" value="<%=toDate%>"> 						
							</td>							
						</tr>
						<tr>
							<th>송장일</th>
							<td>
								<input type="text" class="input_type_text" name="st_invoice_date" id="st_invoice_date" readOnly style="width:80px; text-align:center;" value="<%=toDate%>"> 							
							</td>
							<th>납품확정일</th>
							<td>
								<input type="text" class="input_type_text" name="st_delivery_date" id="st_delivery_date" readOnly style="width:80px; text-align:center;" value="<%=toDate%>"> 									
							</td>
							<th>입고일</th>
							<td>
								<input type="text" class="input_type_text" name="st_gr_date" id="st_gr_date" readOnly style="width:80px; text-align:center;" value="<%=toDate%>"> 							
							</td>							
						</tr> 				       
					</tbody>
				</table>
            </div>
            &nbsp;<font color="red">* 엑셀 업로드시 로그인한 사용자아이디로 엑셀 작성후 업로드 하여야 조회가 됩니다.</font>
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
  					createIBSheet("mySheet", "100%", "254px");
  				</script>
  			</div>  			
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
			<table style="width:100%;">
				<tr>
					<td colspan="2" height="25" align="left">
						&nbsp;&nbsp;* <font color="red">선택(체크)여부와 상관없이 화면에 조회된 모든 데이터가 주문생성됩니다.</font>
			        </td>
				</tr>
			    <tr>
			        <td height="25" align="left">
	  					<span class="btn_05 mr04"><a href="javascript:doAction('excelUpload');">엑셀업로드</a></span>
	  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">양식다운로드</a></span> 
	  					<!-- <span class="btn_07 mr04"><a href="javascript:doAction('save');">업로드검증결과저장</a></span> -->
			        </td>
			        <td height="25" align = "right" valign="middle">
	  					<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
	  					<span class="btn_06"><a href="javascript:doAction('save');">Uploding검증</a></span>
	  					<span class="btn_02"><a href="javascript:doAction('orderCreate');">주문생성</a></span>
			        </td>
			    </tr>
			</table>
	
	               
<!--   	          	<span class="fl"> -->
<!--   				</span> -->
  				
<!--   				<span class="fr"> -->
<!--   				</span> -->
  			 </div>

<!--내용 종료-->	                 
<form name="slgForm" id="slgForm" method="post">
	<input type="hidden" id="comCode" name="comCode" value="" />
	<input type="hidden" id="slgId" name="slgId" value="" />
	<input type="hidden" id="returnColumn" name="returnColumn" value="" />
</form>
</body>
</html>
