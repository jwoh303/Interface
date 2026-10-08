<%--
**********************************************
* 메뉴 : 배송>고객사입고조회
* 화면 : 고객사입고조회
* 기능 : 고객사 입고현황 조회
* 프로그램 ID : PG_08_M_010_00
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-7-21
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
	String buyer = "";
	String userid = "";
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
	} 
	String whAdmin = _sessionInfo.getWhAdmin();
	String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_po_user_id"),"");
%>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var agentImg = "/resources/images/btn_search03.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
						 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태",	SaveName:"STATUS_TEXT"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주번호",	SaveName:"PO_NO"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"LEGACY_NO",	SaveName:"LEGACY_PO_NO"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"송장번호",	SaveName:"INV_NO"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"관리번호",	SaveName:"REF_PR_NO"}

							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"발주일",	SaveName:"PO_CREATE_DATE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납품요청일",	SaveName:"RD_DATE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"입고일",	SaveName:"GR_DATE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"출고일",	SaveName:"INV_DATE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납품일",	SaveName:"DELIVERY_DATE"}					

							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준코드",	SaveName:"STDCATLG_ID"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}					
							
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"발주수량",	SaveName:"PO_QTY"}
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"입고수량",	SaveName:"GR_QTY"}
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"출고수량",	SaveName:"INV_QTY"}
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"납품수량",	SaveName:"DELIVERY_QTY"}

							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float",  Format:"${priceFormat}",	Header:"매입단가",	SaveName:"LIST_PRICE"}					
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Int",	Header:"매입금액",	SaveName:"LIST_AMT"}
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float",  Format:"${priceFormat}",	Header:"매출단가",	SaveName:"UNIT_PRICE"}
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Int",	Header:"매출금액",	SaveName:"UNIT_AMT"}

							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"구분",	SaveName:"DOC_TEXT"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"협력사",	SaveName:"AGENT_IMG"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사",	SaveName:"AGENT"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사",	SaveName:"ADD_USER_TEL"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사",	SaveName:"ADD_USER_NAME"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"요청자",	SaveName:"ADD_USER_IMG"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자",	SaveName:"ADD_USER_NAME"}
							
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"배송처",	SaveName:"DELY_TO_LOCATION_IMG"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"배송처",	SaveName:"DELY_TO_LOCATION"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고",	SaveName:"PO_REMARK"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고",	SaveName:"PO_REMARK_IMG"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고",	SaveName:"BYIT_COMORG_CODE"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고",	SaveName:"CONTRACT_NO"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고",	SaveName:"CONTRACT_SEQ"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고",	SaveName:"DOC_TYPE"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고",	SaveName:"BUYER"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);
	mySheet.SetImageList(2, agentImg);
	
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "AGENT_IMG"); 
	setLinkCol(mySheet, "ADD_USER_IMG"); 
	setLinkCol(mySheet, "DELY_TO_LOCATION_IMG"); 
	setLinkCol(mySheet, "PO_REMARK_IMG");
	setLinkCol(mySheet, "DELAY_REMARK_IMG");
	
	setLinkCol(mySheet, "BUYER_NAME"); 
	setLinkCol(mySheet, "PO_NO"); 
	setLinkCol(mySheet, "INV_NO"); 
	setLinkCol(mySheet, "BUYER_ITEM_NO"); 
	
	
	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_status','getKepUserList','SEL','');

	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
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
		if(kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val())== false){
			return;
		}
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
			alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n3개월 이상의 데이타는 S/R 요청 바랍니다.");
			return ;
		} 
		var buyer_code = document.searchCondition.st_buyer_code.value;
        if( buyer_code == "" )
        {
           alert("고객사를 선택하여 주십시요.\n\n필수 사항 입니다.");
           return;
        }
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/wmdl/getMasterWmDlBuyerWarhsngList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
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

   	
   	
	for(var  i= 1 ; i<mySheet.GetTotalRows()+1 ;  i++)
	{
		if(mySheet.GetCellValue(i,"DELY_TO_LOCATION")!="")
		{
			mySheet.SetCellValue(i, 'DELY_TO_LOCATION_IMG', agentImg);
		}
		if(mySheet.GetCellValue(i,"ADD_USER_NAME")!="")
		{
			mySheet.SetCellValue(i, 'ADD_USER_IMG', agentImg);
		}
		if(mySheet.GetCellValue(i,"PO_REMARK")=="")
		{
			mySheet.SetCellValue(i, 'PO_REMARK_IMG', remarkOff);
		}else{
			mySheet.SetCellValue(i, 'PO_REMARK_IMG', remarkOn);
		}
		
		if(mySheet.GetCellValue(i,"AGENT")!="")
		{
			mySheet.SetCellValue(i, 'AGENT_IMG', agentImg);
		}
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
	kepSearch(document.searchCondition ,  mySheet , "/wmdl/getMasterWmDlBuyerWarhsngList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사 M
		    var ware_house_code = document.searchCondition.st_warehouse_code.value;
		    var st_from_date = document.searchCondition.st_from_date.value;
		    var st_to_date = document.searchCondition.st_to_date.value;
		    var st_date_flag = document.searchCondition.st_date_type.value;
		    openSearchPopup('/wmco/showMasterWmCoMbrcmpyPop.do','?st_warehouse_code='+ware_house_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date+'&st_date_flag='+st_date_flag, "500,500,no"); 
	        popupSel = "buyer_single";
	        break;	
		case "buyer_s": // 고객사 M
			//var st_warehouse_code = "<%=CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"")%>";	
			//openSearchPopup("/wmdl/showMasterDlCommpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");

			openSearchPopup("/common/icomcmpyPop.do",
					"?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_s";
			break;
		}
	}

	// 그리드 셀클릭 이벤트
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if (Row < 1)
			return;
		var column = mySheet.ColSaveName(mySheet.GetSelectCol());
		grbRow = Row; //현재 Row를 전역변수에 셋팅

		if (column == "AGENT_IMG") {
			if (mySheet.GetCellValue(Row, 'AGENT_NAME') != "") {
				var com_code = mySheet.GetCellValue(Row, 'AGENT');
				var st_from_date = document.searchCondition.st_from_date.value;
				var st_to_date = document.searchCondition.st_to_date.value;
				openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do',
						'?com_code=' + com_code + '&st_from_date='
								+ st_from_date + '&st_to_date=' + st_to_date,
						"800,600,no");
				popupSel = "masterMdCpCompyDetailViewPop";
			}
		} else if (column == "BUYER_NAME") {
			if (mySheet.GetCellValue(Row, 'BUYER_NAME') != "") {
				var com_code = mySheet.GetCellValue(Row, 'BUYER');
				var st_from_date = document.searchCondition.st_from_date.value;
				var st_to_date = document.searchCondition.st_to_date.value;
				openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do',
						'?com_code=' + com_code + '&st_from_date='
								+ st_from_date + '&st_to_date=' + st_to_date,
						"800,600,no");
				popupSel = "masterMdCpCompyDetailViewPop";
			}

		} else if (column == "ADD_USER_IMG") {
			if (mySheet.GetCellValue(Row, 'ADD_USER_NAME') != "") {
				var st_ADD_USER_NAME = mySheet.GetCellValue(Row,
						'ADD_USER_NAME');
				var st_ADD_USER_TEL = mySheet.GetCellValue(Row, 'ADD_USER_TEL');
				var st_POHD_REMARK = mySheet.GetCellValue(Row, 'HD_REMARK');
				openSearchPopup('/wmco/showMasterWmCoRequestPop.do',
						'?st_ADD_USER_NAME=' + st_ADD_USER_NAME
								+ '&st_ADD_USER_TEL=' + st_ADD_USER_TEL
								+ '&st_POHD_REMARK=' + st_POHD_REMARK,
						"500,220,no");
				popupSel = "masterWmCoRequestPop";
			}
		} else if (column == 'BUYER_ITEM_NO') {
			if (mySheet.GetCellValue(Row, 'BUYER_ITEM_NO') != "") {

				if (mySheet.GetCellValue(Row, 'DOC_TYPE') != "X") {
					var BUYER_ITEM_NO = mySheet.GetCellValue(Row,
							"BUYER_ITEM_NO");
					var BYIT_COMORG_CODE = mySheet.GetCellValue(Row,
							"BYIT_COMORG_CODE");
					var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
					var CONTRACT_SEQ = mySheet
							.GetCellValue(Row, "CONTRACT_SEQ");
					openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do',
							'?BUYER_ITEM_NO=' + BUYER_ITEM_NO
									+ '&BYIT_COMORG_CODE=' + BYIT_COMORG_CODE
									+ '&CONTRACT_NO=' + CONTRACT_NO
									+ '&CONTRACT_SEQ=' + CONTRACT_SEQ,
							"800,260,no");
				}

			}

		} else if (column == "DELY_TO_LOCATION_IMG") {
			if (mySheet.GetCellValue(Row, 'DELY_TO_LOCATION') != "") {
				var DELY_TO_LOCATION = mySheet.GetCellValue(Row,
						'DELY_TO_LOCATION');
				openSearchPopup('/wmco/showMasterWmCoDlvryPop.do',
						'?DELY_TO_LOCATION=' + DELY_TO_LOCATION, "500,210,no");
				popupSel = "masterWmCoDlvryPop";
			}
		} else if (column == "PO_REMARK_IMG") {
			var PO_REMARK = mySheet.GetCellValue(Row, 'PO_REMARK');
			openSearchPopup('/common/remarkBtoAPop.do', '?st_btoa_remark='
					+ PO_REMARK, "500,220,no");
			popupSel = "remarkBtoA";

		} else if (column == 'PO_NO') {
			if (mySheet.GetCellValue(Row, 'PO_NO') != "") {

				if (mySheet.GetCellValue(Row, 'PO_NO') != "") {

					var ware_house_code = document.searchCondition.st_warehouse_code.value;
					var buyer = mySheet.GetCellValue(Row, 'BUYER');
					var po_no = mySheet.GetCellValue(Row, 'PO_NO');
					openSearchPopup('/wmgr/showMasterWmGrTrOrderGrRegPop.do',
							'?BUYER=' + buyer + '&PO_NO=' + po_no, "900,500,no");
					popupSel = "masterWmGrTrOrderManagerPop";
				}
			}
		} else if (column == 'INV_NO') {
			if (mySheet.GetCellValue(Row, 'IK_NO') != "") {
				var st_type = "K";
				var st_buyer = mySheet.GetCellValue(Row, 'BUYER');
				var st_IK_NO = mySheet.GetCellValue(Row, 'INV_NO');
				var st_ware_house_code = document.searchCondition.st_warehouse_code.value;
				openSearchPopup('/wmgi/showMasterWmGiInvoiceNoPop.do',
						'?st_IK_NO=' + st_IK_NO + '&st_ware_house_code='
								+ st_ware_house_code + '&st_buyer=' + st_buyer
								+ '&st_type=' + st_type, "1000,500,no");

			}
		}

		return;
	}

	//콜백함수(파일명은 모두 동일)
	function setPopupReturn(value1, value2) {

		//팝업 조회후 해당 항목에 값을 셋팅
		if (popupSel == "buyer_single") { // 다중 고객사
			$("#st_buyer_code").val(value1);
			$("#st_buyer_name").val(value2);

		}
		if (popupSel == "buyer_s") { // 다중 고객사
			$("#st_buyer_code").val(value1);
			$("#st_buyer_name").val(value2);

		}
		grbRow = ""; //초기화
	}
</script>
</head>
<body onload="kep_onload_view()">
	<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA">
		<h3>고객사입고조회</h3>
		<span class="btn_search"><a
			href="javascript:doAction('search')">조회</a></span> <span class="btn_reset"><a
			href="javascript:doAction('reload')">초기화</a></span>
	</div>
	<!--조회영역-->
	<form name="searchCondition" method="post" onsubmit="return false">
		<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME"> <input type="hidden"
				id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"
				value="${sessionInfo.userId}">

			<table class="cont_t_list01" width="940px;">
				<caption>고객사입고조회</caption>
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
						<th><label for="b_code" class="hidden">기간선택</label> <select
							name="st_date_type" id="st_date_type" class="TitSelect">
								<option value="PO" selected="selected">발주일</option>
								<option value="RD">납기요청일</option>
						</select></th>
						<td colspan="3"><input type="text" class="input_type_text"
							name="st_from_date" id="st_from_date" readOnly
							style="width: 20%; text-align: center;" value=""> <a
							href="javascript:kepCalendar('st_from_date')"></a> - <input
							type="text" class="input_type_text" name="st_to_date"
							id="st_to_date" readOnly style="width: 20%; text-align: center;"
							value=""> <a href="javascript:kepCalendar('st_to_date')"></a>
							<span class="btn_month"><a
								href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>
							<span class="btn_month"><a
								href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
							<span class="btn_month"><a
								href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
						</td>
						<th><span><font color="red"><b>*</b></font>고객사</th>
						<td><input type="text" class="input_type_text"
							name="st_buyer_name" id="st_buyer_name" style="width: 55%"
							value="" readonly onclick="javascript:doPop('buyer_s');">
							<input type="hidden" name="st_buyer_code" id="st_buyer_code"
							style="width: 80%" value=""> <a
							href="javascript:doPop('buyer_single');"><img
								src="/resources/images/btn_search03.gif"></a> <a
							href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img
								src="/resources/images/btn_eraser2.gif"></a></td>
					</tr>
					<tr>
						<th>발주번호</th>
						<td><input type="text" class="input_type_text" id="st_po_no"
							name="st_po_no" style="width: 80%;" value=""
							onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
						</td>
						<th>송장번호</th>
						<td><input type="text" class="input_type_text" id="st_ik_no"
							name="st_ik_no" style="width: 80%;" value=""
							onkeydown="kepEnter()"></td>
						<th>상태</th>
						<td><select id="st_status_text" name="st_status_text"
							style="width: 60%; height: 20px">
								<option value="">전체</option>
								<option value="미입고">미입고</option>
								<option value="입고완료">입고완료</option>
								<option value="분할입고">분할입고</option>
						</select></td>
					</tr>
					<tr>
						<th>물류센터</th>
						<td><select id="st_warehouse_code" name="st_warehouse_code"
							style="width: 80%; height: 20px"
							<%=whAdmin.equals("Y") ? "" : "disabled"%>>
								<%
									Map<String, String> _map = new HashMap<String, String>();
												 			_map.put("BUYER",buyer);
												 			_map.put("USERID",userid);
												 			_map.put("whAdmin",whAdmin);
								%>
								<%=CommonUtil.getCodeComboQueryIdList("common.getWareHouseIdSchList","",_map,"")%>
						</select></td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="fl">
			<img src="/resources/images/txt_no.gif" alt="정렬개수"
				style="padding-top: 3px;" /> <label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" style="width: 70px;">
				<option value="10" selected>10건</option>
				<option value="20">20건</option>
				<option value="30">30건</option>
				<option value="40">40건</option>
				<option value="50">50건</option>
			</select>
		</div>
		<div class="fr">
			<label for="b_no02" class="hidden">정렬기준</label> <select
				name="st_order_by" id="st_order_by" style="width: 110px;">
				<option value="1">납품요청일순</option>
				<option value="2">고객사순</option>
				<option value="3">발주번호순</option>
				<option value="4">송장번호순</option>
				<option value="5">입고일</option>
			</select>
		</div>
		<br>
	</form>

	<!--grid-->
	<div class="ib_product" style="border-top: 2px solid #3c639c">
		<script type="text/javascript">
			createIBSheet("mySheet", "100%", "354px");
		</script>
	</div>
	<p class="paging" id="pageindex"></p>

	<!--내용 종료-->

</body>
</html>
