<%--
**********************************************
* 메뉴 : 주문관리>주문진행관리>외자납품관리(PO기준)
* 화면 : 외자납품관리(PO기준)
* 기능 : 
* 프로그램 ID :
* 담당자 : HSJ
* 착수일 : 2018-05-28
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<!-- 다중선택콤보(공통) - 사용시 필수 선언 start -->
<script src="/resources/js/jquery.multiple.select.js"></script>
<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<!-- 다중선택콤보(공통) - 사용시 필수 선언 end -->
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var iconOff = "/resources/images/icon2.gif";
var iconOn = "/resources/images/icon3.gif";
var searchOn = "/resources/images/btn_search03.gif";

var grbRow = "";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
		{ Align:"Center",	Width:40,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",				Header:"상태",						SaveName:"sStatus"}
		,{ Align:"Center",	Width:40,	Edit:true,	EditLen:0,		Hidden:false,	Type:"DummyCheck",	Header:"",							SaveName:"SELECTED"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"패킹업체코드",			SaveName:"PKG_COMPANY_CODE"}
		,{ Align:"Left",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"패킹업체",				SaveName:"PKG_COMPANY_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"고객사코드",			SaveName:"BUYER"}
		,{ Align:"Left",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"고객사",					SaveName:"BUYER_NAME"}
		,{ Align:"Center",	Width:250,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"협력사코드",			SaveName:"AGENT"}
		,{ Align:"Left",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"협력사",					SaveName:"AGENT_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"진행상태",				SaveName:"STATUS"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"발주번호",				SaveName:"PO_NO"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"발주항번",				SaveName:"PO_SEQ"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"IF발주번호",				SaveName:"LEGACY_PO_NO"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"IF발주항번",				SaveName:"LEGACY_PO_SEQ"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"납품서번호",			SaveName:"INV_NO"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"납품서항번",			SaveName:"INV_SEQ"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"품목코드",				SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"HSCODE",				SaveName:"HS_CODE",	BackColor:"${notnullColor}",	KeyField:true}
		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float", 				Header:"매출단가(외화)",		SaveName:"EXP_FOR_UNIT_PRICE"}
		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float", 				Header:"매출금액(외화)",		SaveName:"EXP_FOR_ITEM_AMT"}
		,{ Align:"Left",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"품명",						SaveName:"DESCRIPTION"}
		,{ Align:"Left",		Width:180,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"규격",						SaveName:"SPECIFICATION"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"C/I No.",					SaveName:"CI_NO"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"C/I Seq.",				SaveName:"CI_SEQ"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"Invoice Date",			SaveName:"CI_DATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"B/L No.",					SaveName:"BL_NO"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"Forwarder",				SaveName:"FORWARDER"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"Forwarder",				SaveName:"FORWARDER_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"Ship Method",			SaveName:"SHIP_METHOD"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"Currency",				SaveName:"CURRENCY_CODE"}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"발주수량",				SaveName:"PO_ITEM_QTY"}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"납품수량",				SaveName:"IV_ITEM_QTY"}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"C/I Qty",					SaveName:"INV_QTY"}
		,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"Net Weight",			SaveName:"NET_WEIGHT"}
		,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"Gross Weight",			SaveName:"GROSS_WEIGHT"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"CBM",					SaveName:"CBM"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"CTN NO. FROM",		SaveName:"CTN_NO_FROM"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"CTN NO. TO",			SaveName:"CTN_NO_TO"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",				Header:"C/I Sheet",				SaveName:"CI_SHEET"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",				Header:"P/L Sheet",				SaveName:"PL_SHEET"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"B/L 첨부",				SaveName:"BL_IMAGE_KEY"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",				Header:"B/L 첨부",				SaveName:"BL_IMAGE_KEY_IMG"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",				Header:"Lot",						SaveName:"LOT_IMG"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"수출신고일",			SaveName:"EXP_REPORT_DATE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"선적일",					SaveName:"EXP_SHIP_DATE"}
		,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"통관환율",				SaveName:"ENTRY_EXCHANGE_RATE"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"수출신고필증첨부",	SaveName:"CI_IMAGE_KEY"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",				Header:"수출신고필증첨부",	SaveName:"CI_IMAGE_KEY_IMG"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"BL완료여부",			SaveName:"BL_COMPLETE_MARK"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"납품완료여부",			SaveName:"COMPLETE_MARK"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"거래유형코드",			SaveName:"PROCESS_TYPE"}
		];
		IBS_InitSheet(mySheet, initsheet,pagingMode);
		
		//비고이미지설정
		mySheet.SetImageList(0, remarkOn);
		mySheet.SetImageList(1, remarkOff);
		
		mySheet.SetImageList(2, diskOn);
		mySheet.SetImageList(3, diskOff);
		
		mySheet.SetImageList(4, iconOff);
		mySheet.SetImageList(5, iconOn);
		
		mySheet.SetImageList(6, searchOn);
		
		//하이퍼링크 설정
		setLinkCol(mySheet, "CI_SHEET");
		setLinkCol(mySheet, "PL_SHEET");
		setLinkCol(mySheet, "BL_IMAGE_KEY_IMG");
		setLinkCol(mySheet, "LOT_IMG");
		setLinkCol(mySheet, "CI_IMAGE_KEY_IMG");
		setLinkCol(mySheet, "AGENT_NAME");
		setLinkCol(mySheet, "CI_NO");
		setLinkCol(mySheet, "BL_NO");
		
		// 조회조건 초기화
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepToMonthAdd("1","P"));
		
		kepAjaxCommonComboDataValue('st_pkg_cmpy_no','EP07','ALL');
}
	
var st;
var mt;
// 기능함수
function doAction(str){
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excel" && str !="reload" && selectedGrid.length == 0){
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			
			current_page = -1;
			pagingMode = "N";
			
			var buyer_code = $("#st_buyer_code").val();
			var if_po_no = $("#st_legacy_po_no").val();
			var po_no = $("#st_po_no").val();
			
			if(buyer_code == "") {
				alert("고객사를 선택해 주십시요.");
				return;
			}
			
			if(document.getElementById("st_checkbox").checked == true){
				if(if_po_no =="" && po_no ==""){
					alert("기간을 무시하고 조회 시\n\n고객사 선택 후\n\n발주번호, I/F발주번호 중\n\n한가지 이상을 정확히(전체입력) 기입해야 조회가 됩니다.");	
					return;
				}
				$("#st_all_po").val('Y');
			}else{
				$("#st_all_po").val('N');
			}
			
			kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoExportProgressPoList.do" , pagingMode );
			break;
	
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_buyer_code").val("");
			$("#st_agent_code").val("");
			$("#st_complete_mark").val("N");
			mySheet.RemoveAll();
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepToMonthAdd("1","P"));
			document.getElementById("st_checkbox").checked = false;
			$("#st_all_po").val('N');
			break;
			
		case "save": // 저장
	 	    if(!confirm("저장하시겠습니까?")){
	 	    	return;
	 	    }else{
	 	    	kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoExportProgressPo.do", "SELECTED");
	 	    }
			break;
			
		case "excel":
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			
			var buyer_code = $("#st_buyer_code").val();
			
			if(buyer_code == "") {
				alert("고객사를 선택해 주십시요.");
				return;
			}
			
		    $("#pageflag").val('0');
			var param = {FileName:"외자납품관리(PO기준).xlsx",Merge:1,SheetDesign:1,DownCols:"PKG_COMPANY_NAME|BUYER_NAME|AGENT_NAME|STATUS|PO_NO|PO_SEQ|LEGACY_PO_NO|LEGACY_PO_SEQ|INV_NO|INV_SEQ|BUYER_ITEM_NO|HS_CODE|EXP_FOR_UNIT_PRICE|EXP_FOR_ITEM_AMT|DESCRIPTION|SPECIFICATION|CI_NO|CI_SEQ|CI_DATE|BL_NO|FORWARDER_NAME|SHIP_METHOD|CURRENCY_CODE|PO_ITEM_QTY|IV_ITEM_QTY|INV_QTY|NET_WEIGHT|GROSS_WEIGHT|CBM|CTN_NO_FROM|CTN_NO_TO|EXP_REPORT_DATE|EXP_SHIP_DATE|ENTRY_EXCHANGE_RATE"};
			kepDownExcel(document.searchCondition ,mySheet , "/mpso/excelMasterMpSoExportProgressList.do", param);
			$("#pageflag").val('1');
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

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoExportProgressPoList.do?page="+current_page , pagingMode );
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if(column == "CI_SHEET"){
		var PKG_CMPY_NO = mySheet.GetCellValue(Row,"PKG_COMPANY_CODE");
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var CI_NO = mySheet.GetCellValue(Row,"CI_NO");
		
		var fileName = "RD_06_S_001_134";
		var param = "["+PKG_CMPY_NO+"]["+BUYER+"]["+CI_NO+"]";
		
		openSearchPopup("/coco/showReportViewer.do","?fileName=" + fileName + "&param=" + param,"800,850,no,yes");
	}else 	if(column=="PL_SHEET"){
		var PKG_CMPY_NO = mySheet.GetCellValue(Row,"PKG_COMPANY_CODE");
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var CI_NO = mySheet.GetCellValue(Row,"CI_NO");
		
		var fileName = "RD_06_S_001_135";
		var param = "["+PKG_CMPY_NO+"]["+BUYER+"]["+CI_NO+"]";
		
		openSearchPopup("/coco/showReportViewer.do","?fileName=" + fileName + "&param=" + param,"800,850,no,yes");
	}else 	if(column=="AGENT_NAME"){
		 var com_code = mySheet.GetCellValue(Row,'AGENT');
		 var st_from_date = document.searchCondition.st_from_date.value;
		 var st_to_date = document.searchCondition.st_to_date.value;
		 
		 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date, "800,600,no"); 
	}else if(column == "BL_IMAGE_KEY_IMG"){
		var type="EXP_BL";
		var viewType="R";
		var image_key=mySheet.GetCellValue(Row, "BL_IMAGE_KEY");
		
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}else if(column == "CI_IMAGE_KEY_IMG"){
		var type="EXP_CI";
		var viewType="R";
		var image_key=mySheet.GetCellValue(Row, "CI_IMAGE_KEY");
		
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}else if(column == "LOT_IMG"){
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var CI_NO = mySheet.GetCellValue(Row,"CI_NO");

		var params= "?st_buyer="+BUYER+"&st_ci_no="+CI_NO;
		
		openSearchPopup("/exol/showExportExOlExportProgressLotPop.do", params, "800,300,no");
	}else if(column == "CI_NO"){
		var PKG_CMPY_NO = mySheet.GetCellValue(Row,"PKG_COMPANY_CODE");
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var CI_NO = mySheet.GetCellValue(Row,"CI_NO");
		var CI_SEQ = mySheet.GetCellValue(Row,"CI_SEQ");

		var params= "?st_pkg_cmpy_no="+PKG_CMPY_NO+"&st_buyer="+BUYER+"&st_ci_no="+CI_NO+"&st_ci_seq="+CI_SEQ;
		
		openSearchPopup('/exol/getExportExOlExportProgressCiData.do', params, "900,660,no");
	}else if(column == "BL_NO" && (mySheet.GetCellValue(Row,"BL_NO") != "")){
		var PKG_CMPY_NO = mySheet.GetCellValue(Row,"PKG_COMPANY_CODE");
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var BL_NO = mySheet.GetCellValue(Row,"BL_NO");
		
		var params= "?st_pkg_cmpy_no="+PKG_CMPY_NO+"&st_buyer="+BUYER+"&st_bl_no="+BL_NO;
		
		openSearchPopup('/exol/getExportExOlExportProgressBlData.do', params, "900,660,no");
	}
}

//그리드 헤더 전체 체크박스 클릭 이벤트
function mySheet_OnCheckAllEnd(Col, Value) {
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	if (column == 'SELECTED') { // 선택
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
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
	 if(popupSel == "buyer_multi_b") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	}else if(popupSel == "agent_multi"){
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
			<h3>외자납품 관리(PO기준)</h3>
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
			<input type="hidden" name="st_all_po"  id="st_all_po" value ="N">
			
            	<table  class="cont_t_list01" >
					<caption>외자납품 관리(PO기준)</caption>
					<colgroup>
						<col width="7%"/>
						<col width="21%"/>
						<col width="7%"/>
						<col width="21%"/>
						<col width="7%"/>
						<col width="15%"/>
						<col width="7%"/>
						<col width="15%"/>
					</colgroup>
						
					<tbody>
						<tr>
							<th>C/I Date</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:18%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a> -
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:18%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
								<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox" >&nbsp;기간무시
							</td>
							
							<th>패킹업체</th>
							<td>
								<select id="st_pkg_cmpy_no" name="st_pkg_cmpy_no" style="width:80%;"></select>
							</td>
							
							<th>진행상태</th>
							<td style="font-weight:normal;">
								<select id="st_recv_flag" name="st_recv_flag" style="width:80%;">
									<option value="ALL" selected>전체</option>
									<option value="CI">C/I, P/L생성</option>
									<option value="BL">B/L생성</option>
									<option value="CMPL">납품완료</option>
					            </select>
							</td>
						</tr>
						
						<tr> 
							<th><font color="red"><b>*</b></font>고객사</th>
							<td>
							    <input type="text" class="input_type_text" id="st_buyer_name" name="st_buyer_name" style="width:60%;" value="" readonly onclick="javascript:doPop('buyer_multi_b');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:60%" value="">
								<a href="javascript:doPop('buyer_multi_b');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							
							<th>협력사</th>
							<td>
								<input type="text" class="input_type_text" id="st_agent_name" name="st_agent_name" readonly style="width:60%;" value="" onclick="javascript:doPop('agent_multi');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" value=""  style="width:60%" value="">
								<a href="javascript:doPop('agent_multi');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>

							<th>발주번호</th>
							<td>
								<input type="text" class="al" name="st_po_no" id="st_po_no" style="width:78%" value="" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');"  />
							</td>
							
							<th>I/F발주번호</th>
							<td>
								<input type="text" class="al" name="st_legacy_po_no" id="st_legacy_po_no" style="width:78%" value="" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');"  />
							</td>
						</tr>

				      	<tr>
				       		<th>C/I No</th>
							<td>
								<input type="text" class="al" name="st_ci_no" id="st_ci_no" style="width:78%" value="" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');"  />
							</td>
							
							<th>B/L No</th>
							<td>
								<input type="text" class="al" name="st_bl_no" id="st_bl_no" style="width:78%" value=""   onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');"  />
							</td>
							
							<th>납품서번호</th>
							<td>
								<input type="text" class="al" name="st_inv_no" id="st_inv_no" style="width:78%" value="" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');"  />
							</td>
							
							<th></th>
							<td></td>
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
				createIBSheet("mySheet", "100%", "324px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
  			
		<!--버튼영역-->
		<div class="btnArea">
			<span class="fl">
				<span class="btn_04"><a href="javascript:doAction('excel');">엑셀다운로드</a></span> 
			</span>
			<span class="fr">
				<span class="btn_04"><a href="javascript:doAction('save');">HS CODE 등록</a></span> 
			</span>
		</div>

<!--내용 종료-->	                 

</body>
</html>
