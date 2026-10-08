<%--
**********************************************
* 메뉴 : 선입고>선입고관리>선입고 입고등록
* 화면 : 선입고 입고등록
* 기능 : 
* 프로그램 ID : PG_08_M_021_00
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String _wareHouseCode = "";
	
	if ( _gridList != null ) {
		Map<String,String> _rowData = _gridList.get(0);
		_wareHouseCode = _rowData.get("WAREHOUSE_CODE");	
	}
	
	String _whAdmin = _sessionInfo.getWhAdmin();
%> 
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var CarOn = "/resources/images/btn_search03.gif";
var LocationOn = "/resources/images/btn_search03.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
		,{ Align:"Center",	Width:60,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"상태",				SaveName:"STATUS_TEXT"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:190,	Hidden:false,	Type:"Text",				Header:"요청번호",			SaveName:"BS_NO"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Date",				Header:"요청일자",			SaveName:"BEFORE_GR_DATE"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Date",				Header:"납품일자",			SaveName:"ADD_DATE"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Date",				Header:"입고일자",			SaveName:"GR_DATE"}
		,{ Align:"Left",	Width:180,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"고객사",				SaveName:"BUYER_NAME"}
		,{ Align:"Left",	Width:180,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"협력사",				SaveName:"AGENT_INFO"}
		,{ Align:"Left",	Width:180,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"제조사",				SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"품목코드",			SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"품목명",				SaveName:"DESCRIPTION"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"규격",				SaveName:"SPECIFICATION"}
		,{ Align:"Right",	Width:90,		Edit:false,	EditLen:190,	Hidden:false,	Type:"Float",				Header:"요청수량",			SaveName:"ITEM_QTY"}
		,{ Align:"Right",	Width:90,		Edit:false,	EditLen:190,	Hidden:false,	Type:"Float",				Header:"납품수량",			SaveName:"INV_QTY"}
		,{ Align:"Right",	Width:90,		Edit:false,	EditLen:190,	Hidden:false,	Type:"Float",				Header:"입고수량",			SaveName:"GR_QTY"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:190,	Hidden:false,	Type:"Text",				Header:"단위",				SaveName:"UNIT_MEASURE"}
		,{ Align:"Right",	Width:90,		Edit:false,	EditLen:190,	Hidden:true,	Type:"Float",				Header:"매출단가",			SaveName:"UNIT_PRICE"}
		,{ Align:"Right",	Width:90,		Edit:false,	EditLen:190,	Hidden:true,	Type:"Float",				Header:"매출금액",			SaveName:"UNIT_AMT"}
		,{ Align:"Right",	Width:90,		Edit:false,	EditLen:190,	Hidden:true,	Type:"Float",				Header:"매입단가",			SaveName:"AGENT_PRICE"}
		,{ Align:"Right",	Width:90,		Edit:false,	EditLen:190,	Hidden:true,	Type:"Float",				Header:"매입금액",			SaveName:"AGENT_AMT"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"배송처",				SaveName:"DELY_TO_LOCATION"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"요청자",				SaveName:"REQ_USER_INFO"}
		
		,{ Align:"Right",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"박스수량",			SaveName:"BOX_QTY",				KeyField:true,		Format:"${qtyFormat}",	BackColor:"${notnullColor}"}
		,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"출고예정일",		SaveName:"SCHEDULED_DATE",	KeyField:true,		Format:"Ymd",		BackColor:"${notnullColor}"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"차량아이디",		SaveName:"CAR_ID"}
		,{ Align:"Center",	Width:60,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",			Header:"차량번호", 			SaveName:"CAR_NO_IMG",													BackColor:"${optColor}"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"차량번호", 			SaveName:"CAR_NO"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"차량기사",	 		SaveName:"CAR_PERSON_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"연락처",				SaveName:"CAR_PERSON_TEL"}
		
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"고객사",				SaveName:"BUYER_CODE"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"협력사",				SaveName:"AGENT_CODE"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"물류센터",			SaveName:"WAREHOUSE_CODE"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"납품서번호",		SaveName:"INV_NO"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"납품서순번",		SaveName:"INV_SEQ"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"계약서번호",		SaveName:"CONTRACT_NO"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"계약서항번",		SaveName:"CONTRACT_SEQ"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:2};
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	// 비고이미지설정
	mySheet.SetImageList(0, remarkOn);
	mySheet.SetImageList(1, CarOn);
	mySheet.SetImageList(2, LocationOn);
	
	// 하이퍼링크 설정
	setLinkCol(mySheet, "CAR_NO_IMG");		// 차량번호
	setLinkCol(mySheet, "BS_NO");				// 요청번호
	setLinkCol(mySheet, "BUYER_NAME");		// 고객사
	setLinkCol(mySheet, "AGENT_INFO");			// 협력사
	setLinkCol(mySheet, "BUYER_ITEM_NO");	// 품목코드
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	kepSetCalender("in_ivk_date");
	
	// 초기화 설정
	resetValue();
}
	
// 초기화 설정
function resetValue() {
	// 조회조건 일자 설정
	$("#st_to_date").val( kepToMonthAdd("1","P"));
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#in_ivk_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	// 콤보데이터 셋팅
	kepAjaxCommonQueryIdCombo("st_warehouse_code", "master.mpso.getMasterMpSoStockMovemntRequestRegWareHouseFrList", "ALL", "<%=_wareHouseCode%>"); // 물류센터
	
	// 조회조건 hidden 설정
	$("#st_buyer_code").val("");
	$("#st_agent_code").val("");
}
	
var st;
var mt;

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {
	if ( "<%=_whAdmin%>" != "A" && "<%=_wareHouseCode%>" == "") {
		alert("페이지 권한이 없습니다.\n관리자에게 문의 바랍니다.");
		return;
	}
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var ivk_flag = document.getElementById('st_ivk_flag').checked;
	var chk_msg = '';
	var sel_msg = '';

	if ( str =="save" ) {
		if ( ivk_flag ) {
			chk_msg = "출고지시 대상을 선택해 주십시요.";
			sel_msg = '선택사항을 센터 입고 및 출고를 하시겠습니까?';
			$("#st_ivk_yn").val("Y");
			$("#st_ivk_date").val( $("#in_ivk_date").val() );
		} else {
			chk_msg = "입고확정 대상을 선택해 주십시요.";
			sel_msg = '선택사항을 센터 입고 하시겠습니까?';
		}
	}
	
	// 선택된 항목 유무 체크
	if ( str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0 ) {
		alert(chk_msg);
		return;
	}

	switch (str) {
		case "search": // 조회
					if(kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val())== false){ return;}
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				alert('조회는 3개월 이내만 가능 합니다.');
				return ;
			} 				
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/wmpg/getMasterWmPgPrewarhsngWarhsngRegList.do" , pagingMode );
			break;
		
		case "reload": // 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			resetValue();
			break;
	
		case "save": // 저장
			if ( !confirm(sel_msg) )
				return;
			kepSave(document.searchCondition ,  mySheet , "/wmpg/saveMasterWmPgPrewarhsngWarhsngRegList.do" , "SELECTED" );
			break;
			
		case "excelDown": // 엑셀다운로드
			var param = {FileName:"선입고_입고등록.xlsx",Merge:1,SheetDesign:1,DownCols:"STATUS_TEXT|BS_NO|BEFORE_GR_DATE|ADD_DATE|GR_DATE|BUYER_NAME|AGENT_INFO|MAKER_NAME|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|ITEM_QTY|INV_QTY|GR_QTY|UNIT_MEASURE|DELY_TO_LOCATION|REQ_USER_INFO|BOX_QTY|SCHEDULED_DATE|CAR_ID|CAR_NO|CAR_PERSON_NAME|CAR_PERSON_TEL"};
			kepDownExcel(document.searchCondition ,mySheet , "/wmpg/excelMasterWmPgPrewarhsngWarhsngRegList.do", param);
			break;
		
	}
}
function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

}	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		alert(msg);
	}
	
	if ( current_page==-1 ) {
		makePageIndex2(mySheet, 1, document.searchCondition.onepagerow.value);
	} else {
		makePageIndex2(mySheet, current_page, document.searchCondition.onepagerow.value);	
	}
	
	for ( var i = 1 ; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i,"CAR_NO") != "" )
		{
			mySheet.SetCellValue(i, 'CAR_NO_IMG', CarOn);
		}
	}
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
	
	if ( code > 0 ) {
		if ( $("#st_ivk_yn").val() == 'Y' ) {
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow = selectedGrid.split("|");
			var st_user_id = $("#st_user_id").val();
			
			for ( var i=0; i < arrRow.length; i++ ) {
				doPop("offPrint", mySheet.GetCellValue(arrRow[i],"BUYER_CODE"), mySheet.GetCellValue(arrRow[i],"WAREHOUSE_CODE"), mySheet.GetCellValue(arrRow[i],"INV_NO"), st_user_id, i);
			}
		}
		
		// 저장 성공시 재조회
		doAction('search');
		// 출고지시 checkbox 초기화
		$("#st_ivk_yn").val("");
	}
}

	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if ( column=="CAR_NO_IMG" ) {
	    if ( mySheet.GetCellValue(Row,'CAR_NO') != "" ) {
	        var buyer = mySheet.GetCellValue(Row, 'BUYER_CODE');
// 	        kepOpenSearchPopup('masterWmGrIntervalsInfoPop', '?BUYER='+buyer);
	        openSearchPopup("/wmgr/showMasterWmGrIntervalsInfoPop.do", '?BUYER='+buyer, "800,380,no");
	        popupSel = "masterWmGrIntervalsInfoPop";
	    }
	} else 	if (column == 'BS_NO') { // 요청번호
		var bs_no = mySheet.GetCellValue(Row,"BS_NO");
		var buyer_code = mySheet.GetCellValue(Row,"BUYER_CODE");
		openSearchPopup("/mpso/getMasterMpSoPrewarhsngRequestDetailInfoPop.do", "?st_buyer="+buyer_code+"&st_bs_no="+bs_no, "800,500,no");
		return;
	} else if (column == 'BUYER_NAME') { // 고객사 정보
		var buyer_code = mySheet.GetCellValue(Row,"BUYER_CODE");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+buyer_code,'800,550,no');
	} else if (column == 'AGENT_INFO') { // 협력사 정보
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
	}
	
	return;
}

// 팝업함수호출
function doPop(str, val1, val2, val3, val4, val5) {
	if ( "<%=_whAdmin%>" != "A" && "<%=_wareHouseCode%>" == "") {
		alert("페이지 권한이 없습니다.\n관리자에게 문의 바랍니다.");
		return;
	}
	
	popupSel = str;
	
	switch (str) {
		case "masterWmCoMbrcmpyCountPop": // 고객사 M
		    var ware_house_code = document.searchCondition.st_warehouse_code.value;
		    var st_from_date = document.searchCondition.st_from_date.value;
		    var st_to_date = document.searchCondition.st_to_date.value;
// 			kepOpenSearchPopup('masterWmCoMbrcmpyCountPop','?ware_house_code='+ware_house_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date);
			openSearchPopup("/wmco/showMasterWmCoMbrcmpyCountPop.do", '?st_job_type=01&ware_house_code='+ware_house_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date, "500,500,no");
			break;
			
		case "buyerMulti": // 다중 고객사
// 	        openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=Y", "500,466,no"); // 1Grid
	        openSearchPopup('/common/safetyCompanyCodePop.do','?COM_TYPE=B', '880,450,no'); // 2Grid
			break;
			
		case "agentSingle": // 협력사 S
// 			kepOpenSearchPopup('commonCoCoCompanyPop','?com_type=S&multi_flag=M&safety_flag=undefined&save_flag=undefined');
			openSearchPopup("/coco/showCommonCoCoCompanyPop.do", '?com_type=S', "500,500,no");
			break;
			
		case "offPrint": // 리포트 호출
			var param =  "["+val1+"]["+val2+"]["+val3+"]["+val4+"]";
			//var rpt_url = "RD_08_M_006_68^RD_08_M_006_68_01^RD_08_M_005_05";
			//openTranStatReportOpen(rpt_url, param, val5);
			var url ="/coco/showReportViewer.do";
			window.open( url +""+"?fileName=RD_08_M_006_68&param="+param, "trPrewMRD", "width=770,height=800,resizable=YES,top=0,left=50");
			window.open( url +""+"?fileName=RD_08_M_006_68_01&param="+param, "trPrewMRD2", "width=770,height=800,resizable=YES,top=100,left=50");
			window.open( url +""+"?fileName=RD_08_M_005_05&param="+param, "trPickingMRD", "width=770,height=800,resizable=YES,top=200,left=250");
			break;	
	}
}
	
// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {
	// 팝업 조회후 해당 항목에 값을 셋팅
     if ( popupSel == "masterWmCoMbrcmpyCountPop" ) { // 고객사 M
        $("#st_buyer_code").val(value1);
        $("#st_buyer_name").val(value2);
        
 	} else if ( popupSel == "buyerMulti" ) { // 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
        
     } else if ( popupSel == "agentSingle" ) { // 단일 협력사
         $("#st_agent_code").val(value1);
         $("#st_agent_name").val(value2);
	
     } else if (popupSel == "masterWmGrIntervalsInfoPop") { // 배송차량팝업
         var valueArr1 = value1.split('@');
         var valueArr2 = value2.split('@');
         mySheet.SetCellValue(grbRow, 'CAR_ID', valueArr1[0]);
         mySheet.SetCellValue(grbRow, 'CAR_NO', valueArr1[1]);
         mySheet.SetCellValue(grbRow, 'CAR_PERSON_NAME', valueArr2[0]);
         mySheet.SetCellValue(grbRow, 'CAR_PERSON_TEL', valueArr2[1]);
	}
	
	grbRow="";	//초기화
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>선입고 입고등록</h3>
		<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
	    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	</div>

	<!--조회영역-->
    <form name = "searchCondition" method = "post" onsubmit="return false" >
		<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
			<input type="hidden" id="st_ivk_yn" name="st_ivk_yn" value="">
			<input type="hidden" id="st_ivk_date" name="st_ivk_date" value="">

           	<table  class="cont_t_list01" >
				<caption>선입고 입고등록</caption>
				<colgroup>
					<col width="8%" />
					<col width="26%" />
					<col width="8%" />
					<col width="25%" />
					<col width="8%" />
                    <col width="25%" />
				</colgroup>

				<tbody>
					<tr>
						<th>요청일</th>
						<td colspan="3">
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:80px; text-align:center;" value="">
							 - 
							<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:80px; text-align:center;" value="">
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>물류센터</th>
						<td>
							<select id="st_warehouse_code" name="st_warehouse_code" style="width:80%;height:20px" <%=_whAdmin.equals("Y") ? "" : "disabled"%>>
							</select>
						</td>
						<th>고객사</th>
						<td>
						    <input type="text" class="input_type_text" id="st_buyer_name" name="st_buyer_name" style="width:70%;" value=""  readonly onclick="javascript:doPop('buyerMulti');">
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
							<a href="javascript:doPop('masterWmCoMbrcmpyCountPop');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
						</td>
						<th>협력사</th>
						<td>
							<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:71%" value="" readonly onclick="javascript:doPop('agentSingle');">
							<input type="hidden" name="st_agent_code" id="st_agent_code" value="">
							<a href="javascript:doPop('agentSingle');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
					</tr>
					<tr>
						<th>요청번호</th>
						<td>
							<input type="text" class="input_type_text" id="st_bs_no" name="st_bs_no" style="width:80%;" value="" onkeydown="kepEnter()">
						</td>
						<th>품목코드</th>
						<td>
							<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:80%;" value="" onkeydown="kepEnter()">
						</td>
						<th>품목명</th>
						<td>
							<input type="text" class="input_type_text" id="st_buyer_item_name" name="st_buyer_item_name" style="width:80%;" value="" onkeydown="kepEnter()">
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
			createIBSheet("mySheet", "100%", "333px");
		</script>
  	</div>
  	<p class="paging" id="pageindex"></p>

	<!--버튼영역-->
	<br/>
	<div class="btnArea">
  		<span class="fl">
  		<!-- 
  			<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  		 -->
  		</span>
  		
  		<span class="fr">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td> 
						<input type="checkbox" name="st_ivk_flag" id="st_ivk_flag" value="Y" style="cursor:pointer;"/><label for="st_ivk_flag" >출고지시</label>
						<input type="text" class="input_type_text" name="in_ivk_date" id="in_ivk_date" size="10" readOnly style="width:80px; text-align:center;" value=""/>
						<a href="javascript:kepCalendar('st_ivk_date')"></a>
					</td>
					<td>&nbsp;<span class="btn_02"><a href="javascript:doAction('save');" style="text-align:center;cursor:hand">입고확정</a></span> </td>
				</tr>
			</table>
  		</span>
	</div>

<!--내용 종료-->

</body>
</html>
