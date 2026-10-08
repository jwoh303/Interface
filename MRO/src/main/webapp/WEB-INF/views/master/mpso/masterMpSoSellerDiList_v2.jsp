<%--
**********************************************
* 메뉴 : 주문관리>협력사 실적등록 조회
* 화면 : 협력사 실적등록 조회
* 기능 : 
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-09-30
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>
<style type="text/css">
<!--
	table.ui-datepicker-calendar { display:none; }
-->
</style>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var iconR="/resources/images/icon_r.gif";
var iconG="/resources/images/icon_g.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"} 
					,{ Align:"Center",	SaveName : "SCM_REMARK",	Header : "운영자\n메모",	Type : "Text",			EditLen : 60,	Width : 50,		Edit : false}
					,{ Align:"Center",	SaveName : "ISSUE_IMG",		Header : "발주\n이슈",	Type : "Image",			EditLen : 60,	Width : 60,		Edit : false}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"매출마감상태",	SaveName:"AR_BILL_FLAG"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"매입마감상태",	SaveName:"AP_BILL_FLAG"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER"}   
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사코드",	SaveName:"AGENT_CODE"}   
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주번호",	SaveName:"PO_NO"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주항번",	SaveName:"PO_SEQ"}  
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"IF발주번호",	SaveName:"LEGACY_PO_NO"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"} 
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품명",	SaveName:"DESCRIPTION"} 
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"} 
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"수량",	SaveName:"DELIVERY_QTY"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"매출단가",	SaveName:"UNIT_PRICE",Format:"${priceFormat}"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"매출금액",	SaveName:"UNIT_SUM",Format:"${priceFormat}"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"매입단가",	SaveName:"AGENT_PRICE",Format:"${priceFormat}"}  
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"매입금액",	SaveName:"AGENT_SUM",Format:"${priceFormat}"}  
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"거래유형",	SaveName:"PROCESS_TEXT"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"실적등록일",	SaveName:"DELIVERY_DATE"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"등록담당자",	SaveName:"CHANGE_USER_NAME"} 
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"증빙자료",	SaveName:"IMAGE_KEY_INV_IMG"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"증빙자료",	SaveName:"IMAGE_KEY_SIGN_IMG"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"증빙자료",	SaveName:"IMAGE_KEY_INV"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"증빙자료",	SaveName:"IMAGE_KEY_SIGN"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"입고일",	SaveName:"GR_DATE"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"매출담당(운영)",	SaveName:"KEP_AR_USER_ID"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"매입담당(SM)",	SaveName:"CHANGE_USER_NAME"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"IV번호",	SaveName:"INV_NO"}
					,{ Align:"Center",	Width:120,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",	Header:"과세구분\n(카탈로그정보)",	SaveName:"TAX_TYPE",BackColor:"${optColor}",ComboText:"과세|면세|영세|상품권",	ComboCode:"11|12|13|99"}
					,{ Align:"Center",	Width:120,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Combo",	Header:"과세구분\n(카탈로그정보)",	SaveName:"ORG_TAX_TYPE",ComboText:"과세|면세|영세|상품권",	ComboCode:"11|12|13|99"}
// 					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"과세구분\n(카탈로그정보)",	SaveName:"TAX_TYPE_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"과세구분\n변경담당자",	SaveName:"CHANGE_USER_NAME"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"선지급여부\n(N/Y)",	SaveName:"PRE_PAY_YN"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"수출여부\n(N/Y)",	SaveName:"EXPORT_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"계산서\n발행구분",	SaveName:"BILL_TYPE_NM"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"통합발행여부\n(N/Y)",	SaveName:"CHANGE_USER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"AR번호",	SaveName:"AR_BILL_TAX_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"AP번호",	SaveName:"AP_BILL_TAX_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"증빙제외사유",	SaveName:""}
					
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CONTRACT_NO",	SaveName:"CONTRACT_NO"}   
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CONTRACT_SEQ",	SaveName:"CONTRACT_SEQ"}   
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BYIT_COMORG_CODE",	SaveName:"BYIT_COMORG_CODE"}   
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:2};
	IBS_InitSheet(mySheet, initsheet,pagingMode); 
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "PO_NO");	//발주번호
	setLinkCol(mySheet, "AGENT_NAME");	//협력사
	setLinkCol(mySheet, "BUYER_NAME");	//고객사
	setLinkCol(mySheet, "SCM_REMARK");
	setLinkCol(mySheet, "ISSUE_IMG");
	setLinkCol(mySheet, "BUYER_ITEM_NO");	//품목코드
	
	setLinkCol(mySheet, "IMAGE_KEY_INV_IMG");	//배송증빙
	setLinkCol(mySheet, "IMAGE_KEY_SIGN_IMG");	//배송증빙
	mySheet.SetImageList(2, diskOff);
	mySheet.SetImageList(3, diskOn);
	mySheet.SetImageList(10, iconR);
	mySheet.SetImageList(11, iconG);
	
	// 조회조건 초기화
	kepSetCalenderYearMonth("st_from_date");
	kepSetCalenderYearMonth("st_to_date");
	kepYearMonth('st_from_date','st_to_date',0);
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
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
		if($("#st_checkbox").is(":checked")){
			var com_buyer =	$("#st_buyer_code").val();
			var com_agent = $("#st_agent_code").val();
			if (com_buyer == "" && com_agent == "") {
				alert("기간무시는 고객사 또는 협력사가 필수입니다.");
				return;
			}
			
			var ap_bill_flag = $("#st_ap_bill_flag").val();
			var ar_bill_flag = $("#st_ar_bill_flag").val();
			if(ap_bill_flag != "N" || ar_bill_flag != "N"){
				alert("기간무시는 마감상태가 미완료인 건만 조회 가능합니다.");
				return;
			}
		}else{
			
		}
		
	 
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoSellerDiList_v2.do" , pagingMode );
		break;
	
	case "reload":	// 초기화

		$( '#searchCondition' )[0].reset();
	
		kepYearMonth('st_from_date','st_to_date',0);
		mySheet.RemoveAll();
		
		$("#st_buyer_code").val("");
		$("#st_agent_code").val(""); 

		break;

	case "save": // 저장
	
		var gridHeaderCount = mySheet.RowCount();
		
		
		for ( var i = 0; i <= gridHeaderCount; i++ ) {				 
				if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
					var tax_type  = mySheet.GetCellValue( i  , "TAX_TYPE");
					if(tax_type == ""){
						alert(i+"번째 행 과세구분을 선택하시기 바랍니다.");
						return;
					}
				}
		}
		
		if (!confirm('선택한 항목을 저장하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mpso/saveMpSoSellerDiTaxType_v2.do" , "SELECTED" );
		break;
		

	case "excelDown": // 엑셀다운로드
		if(mySheet.RowCount() == 0){
			alert("데이터 조회 후 다운로드하시기 바랍니다.");
			return;
		}
	
	    $("#pageflag").val('0');
	    var downCol = "";
		for(var i=0; i<=mySheet.LastCol(); i++){
			if(!mySheet.GetColHidden(i) && mySheet.ColSaveName(i) !="SELECTED" && mySheet.GetCellProperty(1, i, "Type") != "Image"){
				downCol += "|"+i;
			}
		}
		var param = {FileName:"협력사실적등록조회.xlsx",DownCols:downCol};
		kepDownExcel(document.searchCondition ,mySheet , "/mpso/excelMasterMpSoSellerDiList_v2.do", param);
		$("#pageflag").val('1');
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
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoSellerDiList_v2.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	var com_buyer =	$("#st_buyer_code").val();
	switch (str) {
	case "buyer_single": // 고객사 M
// 		openSearchPopup("/common/safetyCompanyCodePop.do", "?COM_TYPE=B&MULTI=N", "880,450,no"); 
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
		break;
		
	case "agent": // 협력사
// 		if (com_buyer == "") {
// 			alert("고객사를 선택하세요.");
// 			return;
// 		}
		openSearchPopup('/common/icomcmpyPop.do', "?open=Y&BUSINESS_COND=S" ,"500,466,no");
		break;
		
	case "customerSum": //고객사합계표
		openSearchPopup('/mpso/masterMpSoSellerDiCompanyStockSumPop_v2.do', "?BUSINESS_COND=B&com_code="+$("#st_buyer_code").val()+"&com_name="+$("#st_buyer_name").val()+"&st_from_date="+$("#st_from_date").val()+"&st_to_date="+$("#st_to_date").val() ,"1180,610,no");
		break;
	case "supplierSum": //협력사합계표
		openSearchPopup('/mpso/masterMpSoSellerDiCompanyStockSumPop_v2.do', "?BUSINESS_COND=S&com_code="+$("#st_agent_code").val()+"&com_name="+$("#st_agent_name").val()+"&st_from_date="+$("#st_from_date").val()+"&st_to_date="+$("#st_to_date").val() ,"1180,610,no");
		break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	if (Value == "") return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var BUYER = mySheet.GetCellValue(Row,"BUYER");
	var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
	var PO_SEQ = mySheet.GetCellValue(Row,"PO_SEQ");
	var AGENT = mySheet.GetCellValue(Row,"AGENT_CODE");
	var BYIT_COMORG_CODE = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
	var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
	var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
	var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
	
	if (column == 'PO_NO') { // 발주번호
		openSearchPopup('/mpiv/getCommonMpIvOrderDetailPop.do','?buyer='+BUYER+'&po_no='+PO_NO , "820,550,no");
	} else if (column == 'AGENT_NAME') { // 협력사
		getAgentDisplayPop(AGENT); 
	} 
	else if (column == 'BUYER_ITEM_NO') { // 품목코드
		getBuyerCatalogDisplayPop(BYIT_COMORG_CODE,buyerItemNo,contractNo,contractSeq); 
	} 
	else if (column == "SCM_REMARK") { // 운영자메모
		openSearchPopup("/coco/getCommonCoCoScmActionDetailPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO+"&st_po_seq="+PO_SEQ, "520,500,no");
	} else if (column == "BUYER_NAME"){
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+BUYER, '800,550,no');
	} else if (column == "IMAGE_KEY_INV_IMG"){
		var image_key =  mySheet.GetCellValue(Row,"IMAGE_KEY_INV");
		if(image_key != ""){
			var type="IV";
			var viewType="R";
			openSearchPopup('/common/imageFileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		}
	} else if (column == "IMAGE_KEY_SIGN_IMG"){
		var image_key =  mySheet.GetCellValue(Row,"IMAGE_KEY_SIGN");
		if(image_key != ""){
			var type="IV";
			var viewType="R";
			openSearchPopup('/common/imageFileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		}
	} else if (column == 'ISSUE_IMG') { // 발주관리 팝업
		st_popup_url = "/mpso/masterMpSoIssueManageRemarkPop.do";
		st_popup_param = "st_buyer@@"+mySheet.GetCellValue(Row,"BUYER")+"^||^st_po_no@@"+mySheet.GetCellValue(Row,"PO_NO")+"^||^st_po_seq@@"+mySheet.GetCellValue(Row,"PO_SEQ");
		st_popup_option = "1300,800,no";
		
		openSearchPopupAppendPost("IssueRemarkPopForm1",st_popup_url,st_popup_param,st_popup_option);
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 고객사 
		
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2); 
		
	}else 	if (popupSel == "agent") {	// 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2); 
	}
	grbRow="";	//초기화
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>협력사 실적등록 조회</h3>
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
			
            	<table  class="cont_t_list01" >
					<caption>협력사 실적등록 조회</caption>
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
							<th>실적등록월</th>
							<td colspan="5">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:80px; text-align:center;" value="">
								~
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:80px; text-align:center;" value="">
								<span class="btn_month"><a href="javascript:kepYearMonth('st_from_date','st_to_date',-1)">-1개월</a></span>
								<span class="btn_month"><a href="javascript:kepYearMonth('st_from_date','st_to_date',0)">당월</a></span> 
								<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox">&nbsp;기간무시 
							</td>
						</tr>
						<tr> 
							<th>고객사</th>
							<td>
						 			<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:66%;" value = "" READONLY>
			                       <input type="hidden" name="st_buyer_code" id="st_buyer_code" value ="">
			                       <a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
			                       <a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>매출 마감상태</th>
							<td>
								<select id="st_ar_bill_flag" name="st_ar_bill_flag" style="width:80%;">
									<option value="">전체</option>
									<option value="Y">완료</option>
									<option value="N">미완료</option>
								</select>
							</td>
							<th>발주번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_po_no" name="st_po_no" style="width:80%;" value=""   onkeydown="kepEnter()">
							</td>
							
						</tr>
				      <tr>	  
				      		<th>협력사</th>
							<td>
							    <input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:66%;" value ="" READONLY>
					        	<input type="hidden" name="st_agent_code" id="st_agent_code" value=""> 
		                        <a href="javascript:doPop('agent');"><img src="/resources/images/btn_search03.gif"></a>
		                        <a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>매입 마감상태</th>
							<td>
								<select id="st_ap_bill_flag" name="st_ap_bill_flag" style="width:80%;">
									<option value="">전체</option>
									<option value="Y">완료</option>
									<option value="N">미완료</option>
								</select>
							</td>   
							<th>담당자</th>
							<td>
								<input type="text" class="input_type_text" id="st_kep_user_id" name="st_kep_user_id" style="width:80%;" value=""  onkeydown="kepEnter()">
							</td>
						</tr>						
					</tbody>
				</table>
            </div>
<!--            	<span style="position:absolute; left:0;"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/> -->
<!--                	<label for="b_no02" class="hidden">정렬개수선택</label> -->
<!-- 					<select name="onepagerow"  id="onepagerow" style="width: 70px;" > -->
<!-- 					<option value="10" selected>10건</option> -->
<!-- 					<option value="20">20건</option> -->
<!-- 					<option value="30">30건</option> -->
<!-- 					<option value="40">40건</option> -->
<!-- 					<option value="50">50건</option> -->
<!-- 				</select> -->
<!-- 			</span> -->
<!-- 			<br> -->
			 <input type="hidden" name="onepagerow" id="onepagerow" value="1000">
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
  				<!-- 관리팀만 보이도록 -->
  					<span class="btn_04 mr04"><a href="javascript:doPop('customerSum');">고객사합계표</a></span> 	
  					<span class="btn_04 mr04"><a href="javascript:doPop('supplierSum');">협력사합계표</a></span>
  				<!-- 여기까지 --> 	
  					<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span> 	
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
