<%--
**********************************************
* 메뉴 : 입고>입고등록
* 화면 : 입고등록
* 기능 : 입고등록
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script type="text/javascript"> 
var popupSel = "";
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var grbRow = "";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view(){
	var initsheet = {};
	initsheet.Cols = [ 
			 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus"}
			,{ Align:"Center",	Width:60,	Edit:true,	EditLen:0,		Hidden:false,	Type:"DummyCheck",	Header:"",			SaveName:"SELECTED", Sort:0}
			,{ Align:"Left",	Width:60,	Edit:false,	EditLen:0,		Hidden:false,	Type:"Text", 		Header:"상태",		SaveName:"STATUS"}
			,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"고객사코드",	SaveName:"BUYER"}
			,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사",		SaveName:"BUYER_NAME"}
			,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주번호",		SaveName:"PO_NO"}
			,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"I/F발주번호",	SaveName:"LEGACY_PO_NO"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"납품서번호",	SaveName:"INV_NO"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"발주일",		SaveName:"PO_CREATE_DATE",	Format:"Ymd"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"납품요청일",	SaveName:"RD_DATE",			Format:"Ymd"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"납품일자",		SaveName:"INV_DATE",		Format:"Ymd"}
			,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"* 출고예정일",	SaveName:"SCHEDULED_DATE",  Format:"Ymd", BackColor:"${notnullColor}"}
			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사",		SaveName:"AGENT_NAME"}					
			,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int", 		Header:"총 품목건수",	SaveName:"PO_CNT", 			Format:"Integer"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"총 금액(원화)",	SaveName:"ITEM_AMT", 		Format:"Integer"}
			,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"PLANT",		SaveName:"PLANT"}
			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"해외배송처",	SaveName:"OVERSEA_TO_LOCATION"}
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"배송처",		SaveName:"DELY_TO_LOCATION_IMG",BackColor:"${optColor}"}
			,{ Align:"Left",	Width:290,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"배송처",		SaveName:"DELY_TO_LOCATION"}
			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주부서",		SaveName:"PURCHASE_DEPT"}
			,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"요청자",		SaveName:"ADD_USER_NAME"}
			,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"요청자ID",	SaveName:"BTOA_USER_ID"}
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"지연사유",		SaveName:"DELAY_REMARK_IMG",	BackColor:"${optColor}" }
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"지연사유",		SaveName:"DELAY_REMARK"}
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"비고",		SaveName:"PO_REMARK_IMG",	BackColor:"${optColor}" }
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"비고",		SaveName:"PO_REMARK"}
			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"협력사코드",	SaveName:"AGENT"}
			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"구매사발주번호",SaveName:"LEGACY"}
			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"요청자명",		SaveName:"ADD_USER_NAME_ORG"}
			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"협력사명",		SaveName:"AGENT_NAME_ORG"}
			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"요청자TEL",	SaveName:"ADD_USER_TEL"}
			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"공급사TEL",	SaveName:"AGENT_TEL_NO"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"",			SaveName:"PROCESS_TYPE"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"발주항번",		SaveName:"PO_SEQ"}
			,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"품목코드",		SaveName:"BUYER_ITEM_NO"}
			,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"품목명(영문)",	SaveName:"DESCRIPTION_ENG"}
			,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"품목명",		SaveName:"DESCRIPTION"}
			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"규격",		SaveName:"SPECIFICATION"}
			,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Int",			Header:"납품수량",		SaveName:"INV_QTY"}
			,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"단위",		SaveName:"UNIT_MEASURE"}
			,{ Align:"Cente",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"발주자",		SaveName:"PURCHASER"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float",		Header:"외화단가", 	SaveName:"EXP_FOR_UNIT_PRICE",	Format:"#,##0.00"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float",		Header:"외화매출금액", 	SaveName:"EXP_FOR_ITEM_AMT",	Format:"#,##0.00"}
			,{ Align:"Cente",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"원산지",		SaveName:"ORIGIN_NAME"}
			,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"예산계정코드",	SaveName:"ACCOUNT_TYPE"}
			,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"I/F발주항번",	SaveName:"LEGACY_PO_SEQ"}
			,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"제조사",		SaveName:"MAKER"}
			,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:" ",		SaveName:"EMPTY"}
			,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"  ",		SaveName:"EMPTY2"}
			,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"요청자",		SaveName:"RECIPIENT_NAME"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:2};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(0, remarkOn);
	mySheet.SetImageList(1, remarkOff);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "INV_NO"); 
	setLinkCol(mySheet, "DELY_TO_LOCATION_IMG"); 
	setLinkCol(mySheet, "DELAY_REMARK_IMG"); 
	setLinkCol(mySheet, "PO_REMARK_IMG"); 
	setLinkCol(mySheet, "PO_NO");
	setLinkCol(mySheet, "AGENT_NAME");
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	
}
	
//기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="reload" && str !="downexcel"  && str !="detailexcel" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			
			current_page = -1;
			pagingMode = "N";
			
			kepSearch(document.searchCondition,  mySheet , "/exiv/getExportExIvExportWarhsngProcList.do" , pagingMode );
			break;
			
		case "downexcel":
			$("#pageflag").val('0');
		    var downCol = "";
			for(var i=0;i<=mySheet.LastCol();i++){
				if(!mySheet.GetColHidden(i) && mySheet.ColSaveName(i) !="SELECTED"){
					downCol += "|"+i;	
				}
			}
			var param = {FileName:"입고등록.xlsx",Merge:1,SheetDesign:1,DownCols:downCol.substring(1)};
			kepDownExcel(document.searchCondition ,mySheet , "/exiv/excelExportExIvExportWarhsngProcList.do", param);
			$("#pageflag").val('1');
			break;
		case "detailexcel":
			$("#pageflag").val('0');
			var param = {FileName:"입고상세리스트.xlsx", DownCols:"EMPTY|BUYER_NAME|EMPTY|PURCHASE_DEPT|RECIPIENT_NAME|EMPTY|EMPTY2|PO_NO|PO_SEQ|EMPTY|LEGACY_PO_NO|BUYER_ITEM_NO|DESCRIPTION_ENG|SPECIFICATION|PO_NO|AGENT_NAME|INV_QTY|UNIT_MEASURE|EMPTY|PO_REMARK|EXP_FOR_UNIT_PRICE|ITEM_AMT|EMPTY|EMPTY2|PO_REMARK|ORIGIN_NAME|ACCOUNT_TYPE|MAKER|EMPTY|EMPTY2|EMPTY|EMPTY2|EMPTY|EMPTY2|EMPTY|EXP_FOR_ITEM_AMT|PURCHASER"};
			kepDownExcel(document.searchCondition ,mySheet , "/exiv/excelExportExIvExportWarhsngProcDetail.do", param);
			$("#pageflag").val('1');
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_buyer_code").val("");
			$("#st_agent_code").val("");
			mySheet.RemoveAll();
			$("#st_to_date").val( kepToMonthAdd("1","P"));
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_po_multi").val("");
			break;

		case "save": // 저장
	 	 	for(var i = 0 ; i <arrRow.length; i++){
	 	 		if(mySheet.GetCellValue(arrRow[i],"INV_NO") == ""){
	 	 			alert(arrRow[i]+"번째 납품서 미생성건은 입고등록 불가능 합니다.");
	 	 			return;
	 	 		}
	 	 	}
	 	    if(!confirm("입고등록 하시겠습니까?")) {
	 	    	return;
	 	    }else{
	 	    	kepSave(document.searchCondition ,  mySheet , "/exiv/saveExportExIvExportWarhsngProc.do", "SELECTED" );
	 	    }
			break;
	}
}
	
//그리드 표시후 처리	
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	if (!isEmpty(msg)){
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
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/exiv/getExportExIvExportWarhsngProcList.do?page="+current_page , pagingMode );
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if(column == "PO_NO"){
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		openSearchPopup('/common/mpso/poDetailPop.do','?st_buyer='+BUYER+'&st_po_no='+PO_NO,'900,550,no'); 
		popupSel = "poDetailPop";
	}else if(column == "INV_NO"){
		var buyer = mySheet.GetCellValue(Row,'BUYER');
    	var po_no = mySheet.GetCellValue(Row,'PO_NO');
    	var inv_no = mySheet.GetCellValue(Row,'INV_NO');
    	if(inv_no == ""){
    		alert("납품서번호 미생성건 입니다.");
    		return;
    	}
    	openSearchPopup('/exiv/getExportExIvExportWarhsngProcDetail.do','?st_buyer='+buyer+'&st_po_no='+po_no+'&st_inv_no='+inv_no, "900,520,no"); 
		popupSel = "exportExIvExportWarhsngProcDetail";
	}else 	if(column=="PO_REMARK_IMG" ){
		var PO_REMARK = mySheet.GetCellValue(Row,'PO_REMARK');
		openSearchPopup('/common/remarkBtoAPop.do','?st_btoa_remark='+PO_REMARK, "500,220,no"); 
		popupSel = "remarkBtoA";
	}else 	if(column=="DELY_TO_LOCATION_IMG" ){
		var DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
		openSearchPopup('/wmco/showMasterWmCoDlvryPop.do','?DELY_TO_LOCATION='+DELY_TO_LOCATION, "500,210,no"); 
		popupSel = "masterWmCoDlvryPop";
	}else 	if(column=="DELAY_REMARK_IMG" ){
		var st_DELAY_REMARK = mySheet.GetCellValue(Row,'DELAY_REMARK');
		var st_BUYER = mySheet.GetCellValue(Row,'BUYER');
		var st_PO_NO = mySheet.GetCellValue(Row,'PO_NO');
		openSearchPopup('/wmco/showMasterWmCoDelayPop.do','?st_DELAY_REMARK='+st_DELAY_REMARK+'&st_BUYER='+st_BUYER+'&st_PO_NO='+st_PO_NO, "500,220,no"); 
		popupSel = "masterWmCoDelayPop";
	}else 	if(column=="AGENT_NAME" ){
		 var com_code = mySheet.GetCellValue(Row,'AGENT');
		 var st_from_date = document.searchCondition.st_from_date.value;
		 var st_to_date = document.searchCondition.st_to_date.value;
		 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date, "800,600,no"); 
		popupSel = "masterMdCpCompyDetailViewPop";
	}
}

//그리드 헤더 전체 체크박스 클릭 이벤트
function mySheet_OnCheckAllEnd(Col, Value) {
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	if (column == 'SELECTED') { // 선택
		getCheckGrAmtSum();
	} 
}


// 그리드 셀 변경시 이벤트
function mySheet_OnChange(Row, Col, Value) {

}
//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_multi_b": // 고객사 M
			openSearchPopup('/common/safetyCompanyCodePop.do','?COM_TYPE=B', '880,450,no');
	        popupSel = "buyer_multi_b";
		break;
		case "agent_multi": // 협력사 M
			openSearchPopup('/coco/showCommonCoCoCompanyPop.do','?com_type=S&multi_flag=M&safety_flag=undefined&save_flag=undefined', "500,500,no"); 
			popupSel = "agent_multi";
			break;		
		case "poMulti":
			if($("#st_po_no_type").val() == "MI"){
				openSearchPopup('/common/multiSearchCondPop.do','?header_text=발주번호',"300,400,no");
				popupSel = "poMulti";
				break;	
			}
			
	
	}
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
	 if (popupSel == "buyer_multi") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}else if(popupSel == "buyer_multi_b") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	}else if(popupSel == "agent_multi"){
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
		
	}else if(popupSel == "poMulti"){	
		$("#st_po_no_multi").val(value1);
		$("#st_po_no").val(kepMultiName(value1,"@"));
	}
	grbRow="";	//초기화
}
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}

function resetItem(item_type){
	 if(item_type == "SI"){
		 $("#st_po_no").val("");
		 $("#st_po_no_multi").val("");
		 $("#st_po_no").attr("readonly", false);
	 }else if(item_type == "MI"){
		 $("#st_po_no").val("");
		 $("#st_po_no_multi").val("");
		 $("#st_po_no").attr("readonly", true);
	 }
}

</script>
</head>

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="exportHeader"/>
<c:param name="part" value="eheader"/>
</c:import>

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="exportLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>입고등록</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
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
			<input type="hidden" id="st_pkg_cmpy_no" name="st_pkg_cmpy_no"  value="${sessionInfo.comCode}">
			
			<table  class="cont_t_list01" style="width:1024px;">
				<caption>입고등록</caption>
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
							<th>발주일</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a> - 
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>					
							</td>							
							<th>고객사</th>
							<td>
							    <input type="text" class="input_type_text" id="st_buyer_name" name="st_buyer_name" style="width:70%;" value=""  readonly onclick="javascript:doPop('buyer_multi_b');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer_multi_b');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							</tr>
							<tr>
							<th>협력사</th>
							<td>
								<input type="text" class="input_type_text" id="st_agent_name" name="st_buyer_item_no" readonly style="width:70%;" value="" onclick="javascript:doPop('agent_multi');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" value=""  style="width:80%" value="">
								<a href="javascript:doPop('agent_multi');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
 
							<th>
								<select name = "st_po_no_type" id="st_po_no_type" style="height:20px" class="TitSelect" onchange="resetItem(this.value)">
						      		<option value="SI" selected="selected">발주번호</option>
									<option value="MI" >다중 발주번호</option>
                           		</select>
							</th>
							<td>
								<input type="text" class="al" name="st_po_no" id="st_po_no" style="width:70%;ime-mode:disabled; " value =""  maxlength="50" onblur="kepToUpper('st_po_no')" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');" onclick="javascript:doPop('poMulti')">
								<input type="hidden" name="st_po_no_multi" id="st_po_no_multi" style="width:100px;" value ="">
								<a href="javascript:kepEraser('st_po_no','st_po_no_multi');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>
							    I/F발주번호
							<td>
								<input type="text" class="al" name="st_legacy_po_no" id="st_legacy_po_no" style="width:78%" value=""   onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');"  />
							</td>
							</tr>	
																			
						<tr> 
							<th>납품서번호</th>
							<td>
								<input type="text" class="al" name="st_inv_no" id="st_inv_no" style="width:78%" value=""   onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');"  /> 
							</td>
							<th>상태</th>
							<td>
								<select id="st_status_check" name="st_status_check" style="width:80%;height:20px">
									 <option value="">전 체</option>
              						 <option value="발주">발주</option>
              						<option  value="입고예정">입고예정</option>
              						<option  value="분할입고예정">분할입고예정</option>
								</select>
							</td>
							<th>발주부서</th>
							<td>
								<input type="text" class="al" name="st_purchase_dept" id="st_purchase_dept" style="width:78%" value=""   onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');"  />
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
			createIBSheet("mySheet", "100%", "324px");
		</script>
	</div>
	<p class="paging" id="pageindex"></p>
	<!--버튼영역-->
	<div class="btnArea mb0">
		<span class="fl">
			<span class="btn_04 mr04" ><a href="javascript:doAction('downexcel');">엑셀다운로드</a></span>
			<span class="btn_04 mr04" ><a href="javascript:doAction('detailexcel');">상세다운로드</a></span>
		</span>
		<span class="fr">
			<span class="btn_02 mr04"><a href="javascript:doAction('save');">입고등록</a></span> 
		</span>
	</div>

</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/exportFooter.jsp" %>
</div>
</body>
</html>
