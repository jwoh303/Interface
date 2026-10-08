<%--
**********************************************
* 메뉴 : 선입고>선입고관리>선입고 현황조회
* 화면 : 선입고 현황조회
* 기능 : 
* 프로그램 ID : PG_08_M_021_04
* 담당자 : 고영일 ( 설계 : 김상근 )
* 착수일 : 2014-09-18
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	//공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String _wareHouseCode = "";
	
	if ( _gridList != null ) {
		Map<String,String> _rowData = _gridList.get(0);
		_wareHouseCode = _rowData.get("WAREHOUSE_CODE");	
	}

	String whAdmin = "";
	if (_sessionInfo != null){
		whAdmin =  CommonUtil.nvl((String)_sessionInfo.getWhAdmin());
	} 
%>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var print_icon="/resources/images/icon_print.gif";
var del_icon="/resources/images/btn_eraser2.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 3};
	initsheet.HeaderMode = {			Sort : 0,			ColMove : 1,			ColResize : 1		};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,		Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : true,	Type:"Radio",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태",	SaveName:"STATUS_TEXT"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"출고유형",	SaveName:"PROCESS_TEXT"}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청번호",	SaveName:"BS_NO"}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"요청일",	SaveName:"BEFORE_GR_DATE"}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납품일자",	SaveName:"ADD_DATE"}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"입고일자",	SaveName:"WMS_GR_DATE"}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"출고(지시)일자",	SaveName:"WMS_IVK_DATE"}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"출고일자",	SaveName:"DELIVERY_DATE"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"거래명세서 번호",	SaveName:"TRAN_INV_NO"}
					,{ Align:"Center",	Width:20,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"거래명세서 번호",	SaveName:"TRAN_PRINT_IMG"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"거래명세서 순번",	SaveName:"TRAN_INV_SEQ"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"운송업체",	SaveName:"DELIVERY_COMPANY_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"운송장번호",	SaveName:"DELIVERY_NO"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사연락처",	SaveName:"AGENT_TEL_NO"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
					,{ Align:"Left",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
					,{ Align:"Left",		Width:300,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"요청수량",	SaveName:"ITEM_QTY"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"납품수량",	SaveName:"INV_QTY"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"입고수량",	SaveName:"WMS_GR_QTY"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"출고(지시)수량",	SaveName:"WMS_IVK_QTY"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"출고수량",	SaveName:"DELIVERY_QTY"}
					,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float",  Format:"${priceFormat}",	Header:"단가",	SaveName:"UNIT_PRICE"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Int",	Header:"요청금액",	SaveName:"ITEM_AMT"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Int",	Header:"납품금액",	SaveName:"INV_AMT"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Int",	Header:"입고금액",	SaveName:"WMS_GR_AMT"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Int",	Header:"출고(지시)금액",	SaveName:"WMS_IVK_AMT"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Int",	Header:"출고금액",	SaveName:"DELIVERY_AMT"}
					,{ Align:"Left",		Width:300,	Edit:false,	EditLen:160,	Hidden:false,	Type:"Text",	Header:"배송처",	SaveName:"DELY_TO_LOCATION"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",	SaveName:"REQ_USER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자연락처",	SaveName:"REQ_USER_TEL_NO"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"Kep담당자",	SaveName:"KEP_USER_NAME"}
					,{ Align:"Left",		Width:300,	Edit:false,	EditLen:400,	Hidden:false,	Type:"Text",	Header:"비고",	SaveName:"REMARK"}
					,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"삭제",	SaveName:"DELETE_IMG"}
					
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"상태코드",	SaveName:"STATUS"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제조사코드",	SaveName:"MAKER_CODE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER_CODE"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사코드",	SaveName:"AGENT_CODE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"Kep담당자ID",	SaveName:"KEP_USER_ID"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서번호",	SaveName:"CONTRACT_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서항번",	SaveName:"CONTRACT_SEQ"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서항번",	SaveName:"WAREHOUSE_CODE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서항번",	SaveName:"INV_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서항번",	SaveName:"INV_SEQ"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"운송업체코드",	SaveName:"DELIVERY_COMPANY"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdSearchTwoCombo('st_warehouse_code','common.getWareHouseList2','<%=whAdmin%>','<%=_wareHouseCode%>','','');
	
	//비고이미지설정
	mySheet.SetImageList(0, print_icon);
	mySheet.SetImageList(1, del_icon);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "BS_NO");							//요청번호
	setLinkCol(mySheet, "BUYER_NAME");					//고객사
	setLinkCol(mySheet, "BUYER_ITEM_NO");				//품목코드
	setLinkCol(mySheet, "AGENT_NAME");					//협력사
	setLinkCol(mySheet, "TRAN_PRINT_IMG");			// 거래명세서 출력
	setLinkCol(mySheet, "DELETE_IMG", 24, 23);			// 삭제

	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	if($("#st_warehouse_code option").length <= 1){
		$("#st_warehouse_code").attr("disabled", true);
	}
}
	
	
var st;
var mt;
// 기능함수
function doAction(str, val1) {
	
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
		current_page = -1;
				if(kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val())== false){ return;}
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
			alert('조회는 3개월 이내만 가능 합니다.');
			return ;
		} 		
		kepSearch(document.searchCondition,  mySheet , "/wmpg/getMasterWmPgPrewarhsngStateList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		break;
	
	case "delete":	// 삭제
		var msg = "";
		if(val1 == "03") msg = "입고확정";
		if(val1 == "04") msg = "출고지시 확정";
		if(val1 == "05") msg = "배송확정";
		
		if(confirm(msg+" 상태를 삭제 하시겠습니까?")){
			kepSave(document.searchCondition ,  mySheet , "/wmpg/deleteMasterWmPgPrewarhsngState.do" , "SELECTED" );
		}
		
		break;

	case "excelDown": // 엑셀다운로드
	
	    $("#pageflag").val('0');
		var param = {FileName:"선입고_현황_조회.xlsx",DownCols:"STATUS_TEXT|PROCESS_TEXT|BS_NO|BEFORE_GR_DATE|ADD_DATE|WMS_GR_DATE|WMS_IVK_DATE|DELIVERY_DATE|BUYER_NAME|BUYER_CODE|AGENT_NAME|AGENT_CODE|AGENT_TEL_NO|MAKER_NAME|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|ITEM_QTY|INV_QTY|WMS_GR_QTY|WMS_IVK_QTY|DELIVERY_QTY|UNIT_MEASURE|DELY_TO_LOCATION|REQ_USER_NAME|REQ_USER_TEL_NO|KEP_USER_NAME|REMARK|"};
		kepDownExcel(document.searchCondition ,mySheet , "/wmpg/excelMasterWmPgPrewarhsngStateList.do", param);
		$("#pageflag").val('1');
		break;
	}
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

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
	for(var  i= 1 ; i<mySheet.GetTotalRows()+1 ;  i++){
		if(mySheet.GetCellValue(i,"STATUS") == "04" || mySheet.GetCellValue(i,"STATUS") == "05"){
			mySheet.SetCellValue(i, 'TRAN_PRINT_IMG', 0);
		}
		
		if(mySheet.GetCellValue(i,"STATUS") == "03" || mySheet.GetCellValue(i,"STATUS") == "04" || mySheet.GetCellValue(i,"STATUS") == "05"){
			mySheet.SetCellValue(i, 'DELETE_IMG', 1);
		}
	}
	
}

//트랜젝션(저장,삽입등) 후처리
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
	kepSearch(document.searchCondition ,  mySheet , "/wmpg/getMasterWmPgPrewarhsngStateList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사 S
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;
		case "seller_single": // 협력서 S
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			popupSel = "seller_single";
			break;
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'BS_NO') { // 요청번호
		var bs_no = mySheet.GetCellValue(Row,"BS_NO");
		var buyer_code = mySheet.GetCellValue(Row,"BUYER_CODE");
		openSearchPopup("/mpso/getMasterMpSoPrewarhsngRequestDetailInfoPop.do", "?st_buyer="+buyer_code+"&st_bs_no="+bs_no, "800,500,no");
		return;
	} else if (column == 'BUYER_NAME') { // 고객사 정보
		var buyer_code = mySheet.GetCellValue(Row,"BUYER_CODE");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+buyer_code,'800,550,no');
	} else if (column == 'AGENT_NAME') { // 협력사 정보
		var agent_code = mySheet.GetCellValue(Row,"AGENT_CODE");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent_code,'800,550,no');
	} else if (column == 'BUYER_ITEM_NO') { // 협력사 정보
		var buyer_code = mySheet.GetCellValue(Row,"BUYER_CODE");
		var buyer_item_no = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		var contract_no = mySheet.GetCellValue(Row,"CONTRACT_NO");
		var contract_seq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		
		if(isEmpty(contract_no) || isEmpty(contract_seq)){
			alert("상품 정보가 없습니다.");
			return;
		}
		
		openSearchPopup("/common/catalogDetailPop.do","?open=Y&BUYER="+buyer_code+"&BUYER_ITEM_NO="+buyer_item_no+"&CONTRACT_NO="+contract_no+"&CONTRACT_SEQ="+contract_seq,"800,300,no");
	} else if( column == "TRAN_PRINT_IMG" ){	// 거래명세서 출력
		if(mySheet.GetCellValue(Row,"STATUS") == "04" || mySheet.GetCellValue(Row,"STATUS") == "05"){
			var buyer = mySheet.GetCellValue(Row,"BUYER_CODE");
			var warehouse_code = mySheet.GetCellValue(Row,"WAREHOUSE_CODE");
			var inv_no = mySheet.GetCellValue(Row,"INV_NO");
			var user_id = $("#st_user_id").val();
			var url ="/coco/showReportViewer.do";
			
			window.open( url +""+"?fileName=RD_08_M_006_68&param=["+buyer+"]["+warehouse_code+"]["+inv_no+"]", "trPrewMRD", "width=770,height=800,resizable=YES,top=0,left=50");
			window.open( url +""+"?fileName=RD_08_M_006_68_01&param=["+buyer+"]["+warehouse_code+"]["+inv_no+"]", "trPrewMRD2", "width=770,height=800,resizable=YES,top=100,left=50");
			window.open( url +""+"?fileName=RD_08_M_005_05&param=["+buyer+"]["+warehouse_code+"]["+inv_no+"]["+user_id+"]", "trPickingMRD", "width=770,height=800,resizable=YES,top=200,left=250");
// 			window.open( url +""+"?fileName=RD_08_M_005_04&param=["+buyer+"]["+warehouse_code+"]["+inv_no+"]", "trPackingMRD", "width=770,height=800,resizable=YES,top=0,left=450");
		}
	} else if( column == "DELETE_IMG" ){	// 입고, 출고지시, 배송확정 삭제
		if(mySheet.GetCellValue(Row,"STATUS") == "03" || mySheet.GetCellValue(Row,"STATUS") == "04" || mySheet.GetCellValue(Row,"STATUS") == "05"){
			mySheet.SetCellValue(Row, 'SELECTED', 1);
			doAction("delete", mySheet.GetCellValue(Row,"STATUS"));
		}
	}
	
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	} else if (popupSel == "seller_single") {	// 협력사
		$("#st_seller_code").val(value1);
		$("#st_seller_name").val(value2);
	}
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>선입고 현황조회</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
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
			<input type="hidden" id="whAdmin" name="whAdmin"  value="<%=whAdmin%>">
			
            	<table  class="cont_t_list01" style="width:1024px;">
					<caption>선입고 현황조회</caption>
					<colgroup>
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
						<col width="10%" />
                        <col width="23%" />
					</colgroup>
						
					<tbody>
						<tr>
							<td>
								<select id="st_date_type" name="st_date_type" class="TitSelect">
									<option value="BEFORE_GR_DATE">요청일</option>
									<option value="ADD_DATE">납품일</option>
									<option value="WMS_IVK_DATE">출고지시일</option>
									<option value="DELIVERY_DATE">출고일</option>
								</select>
							</td>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
							</td>
							<td>물류센터</td>
							<td>
								<select id="st_warehouse_code" name="st_warehouse_code" style="width:80%;height:20px"></select>
							</td>
						</tr>
						<tr> 
							<td>고객사</td>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:71%" value="" readonly onclick="javascript:doPop('buyer_single');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<td>협력사</td>
							<td>
								<input type="text" class="input_type_text" name="st_seller_name" id="st_seller_name" style="width:71%" value="" readonly onclick="javascript:doPop('seller_single');">
								<input type="hidden" name="st_seller_code" id="st_seller_code" style="width:80%" value="">
								<a href="javascript:doPop('seller_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_seller_code','st_seller_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<td>선입고번호</td>
							<td>
								<input type="text" class="input_type_text" id="st_bs_no" name="st_bs_no" style="width:80%;" value="" onkeyup="kepToUpper('st_bs_no')" onkeydown="kepEnter()">
							</td>
						</tr>
						<tr> 
							<td>품목코드</td>
							<td>
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:80%;" value="" onkeyup="kepToUpper('st_buyer_item_no')" onkeydown="kepEnter()">
							</td>
							<td>품목명</td>
							<td>
								<input type="text" class="input_type_text" id="st_description" name="st_description" style="width:80%;" value="" onkeydown="kepEnter()"/>
							</td>
							<td>거래명세서 번호</td>
							<td>
								<input type="text" class="input_type_text" id="st_tran_inv_no" name="st_tran_inv_no" style="width:80%;" value="" onkeyup="kepToUpper('st_tran_inv_no')" onkeydown="kepEnter()">
							</td>
						</tr>
						<tr> 
							<td>출고구분</td>
							<td>
								<select id="st_delivery_type" name="st_delivery_type" style="width:80%;height:20px">
									<option value="">전체</option>
									<option value="2">TR</option>
									<option value="1">재고</option>
									<option value="3">VMI</option>
								</select>
							</td>
							<td>진행상태</td>
							<td>
								<select id="st_status_type" name="st_status_type" style="width:80%;height:20px">
									<option value="">전체</option>
									<option value="01">요청</option>
									<option value="02">납품</option>
									<option value="03">입고</option>
									<option value="04">출고(지시)</option>
									<option value="05">배송확정</option>
								</select>
							</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
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
  	        	<!-- 
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				 -->
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
