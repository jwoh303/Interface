<%--
**********************************************
* 메뉴 : 상품관리>고객사 카탈로그 관리>카탈로그 재계약 관리
* 화면 : 카탈로그 재계약 관리
* 기능 : 카탈로그 재계약 관리
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 2020-04-07
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script>
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
    var diskOn = "/resources/images/disk_on.gif";
    var areaOn="/resources/images/icon.gif";
    var areaOff = "/resources/images/icon2.gif";
    
    var productGbn = KepSheetComboData("M074","SEL");
    var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};
    
	var initsheet = {};
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 2};
	initsheet.Cols = [
					 { Align:"Center",	SaveName:"sStatus",						Header:"상태",			Type:"Status",		Width:60,	Edit:false,	Hidden:true,	EditLen:0}
					 ,{ Align:"Center",	SaveName:"SELECTED",					Header:"",				Type:"DummyCheck",	Width:30,	Edit:true,	Hidden:false,	EditLen:100,	Sort:0}
					 ,{ Align:"Left",	SaveName:"BUYER_NM",					Header:"고객사",			Type:"Text",		Width:120,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"RC_NO",						Header:"요청번호",			Type:"Text",		Width:100,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"RC_SEQ",						Header:"요청순번",			Type:"Text",		Width:60,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"REVISION",					Header:"차수",			Type:"Text",		Width:40,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"RC_TEXT",						Header:"진행상태",			Type:"Text",		Width:80,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",				Header:"품목코드",			Type:"Text",		Width:100,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Left",	SaveName:"DESCRIPTION_LOC",				Header:"품명",			Type:"Text",		Width:200,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Left",	SaveName:"SPECIFICATION",				Header:"규격",			Type:"Text",		Width:200,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"UNIT_MEASURE",				Header:"단위",			Type:"Text",		Width:70,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Right",	SaveName:"ATOB_UNIT_PRICE",				Header:"변경\n매출단가",	Type:"Float",		Width:80,	Edit:true,	Hidden:false,	EditLen:100,	Format:"${priceFormat}",	BackColor:"${optColor}"}
					 ,{ Align:"Center",	SaveName:"UNIT_PRICE_CHANGE_REASON",	Header:"매출단가\n변동사유",	Type:"Combo",	Sort:0,	Width:110,	Edit:true,	Hidden:false,	EditLen:20,   	BackColor:"${optColor}"}
					 ,{ Align:"Right",	SaveName:"LIST_PRICE",					Header:"변경\n매입단가",	Type:"Float",		Width:80,	Edit:false,	Hidden:false,	EditLen:100,	Format:"${priceFormat}"}
					 ,{ Align:"Center",	SaveName:"LIST_PRICE_CHANGE_REASON",	Header:"매입단가\n변동사유",	Type:"Combo",	Sort:0,	Width:110,	Edit:false,	Hidden:false,	EditLen:20}
					 ,{ Align:"Center",	SaveName:"STOA_CLOSE_DATE_2",			Header:"변경\n매출유효일",	Type:"Date",		Width:90,	Edit:false,	Hidden:false,	EditLen:110}
					 ,{ Align:"Right",	SaveName:"INCR_RATE",					Header:"매입단가\n인상율",	Type:"Float",		Width:80,	Edit:false,	Hidden:false, 	EditLen:100,	Format:"${priceFormat}"}
					 ,{ Align:"Right",	SaveName:"RE_UNIT_PRICE",				Header:"현재\n매출단가",	Type:"Float",		Width:80,	Edit:false,	Hidden:false, 	EditLen:100,	Format:"${priceFormat}"}
					 ,{ Align:"Right",	SaveName:"RE_LIST_PRICE",				Header:"현재\n매입단가",	Type:"Float",		Width:80,	Edit:false,	Hidden:false,	EditLen:100,	Format:"${priceFormat}"}
					 ,{ Align:"Center",	SaveName:"RE_TO_DATE",					Header:"현재\n매출유효일",	Type:"Date",		Width:90,	Edit:false,	Hidden:false,	EditLen:110}
					 ,{ Align:"Left",	SaveName:"MAKER_NAME",					Header:"제조사",			Type:"Text",		Width:120,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Left",	SaveName:"ORIGIN_NM",					Header:"원산지",			Type:"Text",		Width:80,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Left",	SaveName:"MAKER_PART_NO",				Header:"모델번호",			Type:"Text",		Width:120,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"ATOB_DATE",					Header:"재계약\마감일",		Type:"Date",		Width:80,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"CLOSE_DATE",					Header:"계약종료일",		Type:"Date",		Width:80,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"USER_NM",						Header:"담당자",			Type:"Text",		Width:70,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Left",	SaveName:"AGENT_NM",					Header:"협력사",			Type:"Text",		Width:120,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"STOA_USER_NM",				Header:"협력사\n제출자",	Type:"Text",		Width:70,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"STOA_USER_PHONE",				Header:"협력사\n연락처",	Type:"Text",		Width:100,	Edit:true,	Hidden:false,	EditLen:100}
					 ,{ Align:"Right",	SaveName:"MIN_ORDER_QTY",				Header:"MOQ",			Type:"Int",			Width:60,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"LAST_PO_DATE",				Header:"최근발주일",		Type:"Date",		Width:90,	Edit:false,	Hidden:false,	EditLen:110}
					 ,{ Align:"Right",	SaveName:"PUR_UNIT_QTY",				Header:"발주배수",			Type:"Int",			Width:60,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"ATOS_DATE",					Header:"요청일",			Type:"Date",		Width:80,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Left",	SaveName:"A_NOTE",						Header:"운영사비고(재요청)",	Type:"Text",		Width:180,	Edit:true,	Hidden:false,	EditLen:100,	BackColor:"${optColor}"}
					 ,{ Align:"Left",	SaveName:"S_NOTE",						Header:"협력사비고",		Type:"Text",		Width:180,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Left",	SaveName:"G_NOTE",						Header:"포기사유",			Type:"Text",		Width:80,	Edit:false,	Hidden:false,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"BUYER",						Header:"고객사코드",		Type:"Text",		Width:80,	Edit:false, Hidden:true,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"AGENT",						Header:"협력사코드",		Type:"Text",		Width:80,	Edit:false,	Hidden:true,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"RC_TYPE",						Header:"상태코드",			Type:"Text",		Width:80,	Edit:false,	Hidden:true,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",			Header:"카탈로그관리코드",	Type:"Text",		Width:80,	Edit:false,	Hidden:true,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"CONTRACT_NO",					Header:"계약번호",			Type:"Text",		Width:80,	Edit:false,	Hidden:true,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"CONTRACT_SEQ",				Header:"계약순번",			Type:"Text",		Width:80,	Edit:false,	Hidden:true,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"STOA_CLOSE_DATE",				Header:"매입유효일",		Type:"Date",		Width:80,	Edit:false,	Hidden:true,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"RE_BUY_CLOSE_DATE",			Header:"현재\n매입유효일",	Type:"Date",		Width:80,	Edit:false,	Hidden:true,	EditLen:100}
					 ,{ Align:"Center",	SaveName:"RE_SELL_CLOSE_DATE",			Header:"현재\n매출유효일",	Type:"Date",		Width:80,	Edit:false,	Hidden:true,	EditLen:100}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4);
	
	//조회조건 초기값 설정
	$("#st_from_date").val(kepToDateAdd("31","M"));
	$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/'));	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "REVISION");
	
	// 콤보데이터 셋팅
	kepAjaxCommonQueryIdSearchTwoCombo('st_mng_id','common.masterDepartmentUserList','PG_10_M_006_00','','ALL','${sessionInfo.userId}'); // 조회조건 : 담당자
	mySheet.SetColProperty("UNIT_PRICE_CHANGE_REASON", comboInfo);
	mySheet.SetColProperty("LIST_PRICE_CHANGE_REASON", comboInfo);
}
	
// 기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	var buyer = TrimCommon($("#st_buyer_code").val());
	
    
	switch (str) {
	case "search":	 // 조회
		current_page = -1;
        if(buyer == "")
        {
            alert("고객사를 선택해 주십시요.");
            return;
        }
		kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmCatalogRecharterList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		document.forms.searchCondition.st_buyer_code.value = ""; // 초기화 시 고객사코드가 남아있어 추가 HSJ 2021.01.26
		mySheet.RemoveAll();
		break;
	case "cancle": //재계약건 취소
		if ( !validationConfirm("C")) return;
		if ( !confirm("취소 처리 하시겠습니까?") ) return;
		kepSave(document.searchCondition, mySheet, "/mdcm/cancleMasterMdCmCatalogRecharter.do", "SELECTED");
		break;
	case "save": //재계약건 저장
		if ( !validationConfirm("S")) return;
		if ( !confirm("저장 하시겠습니까?") ) return;
		kepSave(document.searchCondition, mySheet, "/mdcm/saveMasterMdCmCatalogRecharter.do", "SELECTED");
		break;
	case "req": //재요청
		if ( !validationConfirm("C")) return;
		if ( !confirm("협력사에게 재계약 재요청 하시겠습니까?") ) return;
		kepSave(document.searchCondition, mySheet, "/mdcm/reqMasterMdCmCatalogRecharter.do", "SELECTED");
		break;
	case "approval": //단가반영요청
		if ( !validationConfirm("S")) return;
		if ( !confirm("선택 된 품목 단가반영 요청 하시겠습니까?") ) return;
		kepSave(document.searchCondition, mySheet, "/mdcm/approvalMasterMdCmCatalogRecharter.do", "SELECTED");
		break;
	case "excelDown": // 엑셀다운로드
		if(buyer == ""){
            alert("고객사를 선택해 주십시요.");
            return;
        }
	    $("#pageflag").val('0');
		var param = {FileName:"masterMdCmCatalogRecharterList.xlsx"};
		kepDownExcel(document.searchCondition ,mySheet , "/mdcm/excelMasterMdCmCatalogRecharter.do", param);
		$("#pageflag").val('1');
		break;
	}
}
// 진행상태 체크
function validationConfirm(st_gbn) {
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			var st_rc_type = mySheet.GetCellValue(i, "RC_TYPE");
			if(st_gbn == "C"){//재계약 취소는 재계약 취소, 반영요청,결재상신,완료,반려 처리 불가
				if ( st_rc_type == "Q"||st_rc_type == "W"||st_rc_type == "Y"||st_rc_type == "D"||st_rc_type == "E") {
					alert(i+"번째 재계약 취소처리가 불가능 합니다.");
					return false;
				}	
			}else{
				if (st_rc_type != "S") {
					alert(i+"번째 재계약 제출 상태가 아니므로 처리 불가능 합니다.");
					return false;
				}	
			}
			if(st_gbn == "S"){
				//단가반영요청 전 수수료율 체크
				var st_unit_price = mySheet.GetCellValue(i, "ATOB_UNIT_PRICE");
				var st_list_price =mySheet.GetCellValue(i, "LIST_PRICE");
				var st_re_unit_price = mySheet.GetCellValue(i, "RE_UNIT_PRICE");
				var st_unit_price_change_reason = mySheet.GetCellValue(i, "UNIT_PRICE_CHANGE_REASON");
				
				var rate = (st_unit_price-st_list_price)/st_list_price*100;
				if(st_unit_price ==""){
			    	alert("변경 할 매출단가를 입력 바랍니다.");
			    	mySheet.SelectCell(i, "ATOB_UNIT_PRICE");
			    	return false;
				}
				
				if((st_unit_price != st_re_unit_price) && (st_unit_price_change_reason == "")){
			    	alert("매출단가변동사유를 입력 바랍니다.");
			    	mySheet.SelectCell(i, "UNIT_PRICE_CHANGE_REASON");
			    	return false;
				}
				
				//최종 수수료율 체크 로직.
			    if(rate < 3){
			    	var agentName = mySheet.GetCellValue(i, "AGENT_NM");
			    	alert(agentName+"는 고정 매입 수수료율은"+kepGetRound2(rate,4)+"이며, 3% 미만건 입니다.\n 고정 매입 수수료율 수정 바랍니다.");
			    	mySheet.SelectCell(i, "ATOB_UNIT_PRICE");
			    	return false;
			     }
			    if(rate > 4.5){
			    	var agentName = mySheet.GetCellValue(i, "AGENT_NM");
			    	alert(agentName+"는 고정 매입 수수료율은"+kepGetRound2(rate,4)+"이며, 4.5% 초과건 입니다.\n 고정 매입 수수료율 수정 바랍니다.");
			    	mySheet.SelectCell(i, "ATOB_UNIT_PRICE");
			    	return false;
			    }				
			}
		}
	}
	return true;
}
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	return DATA;
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
	var msgType = msg.substring(0,2);
	if (msgType == "PM"){
		var st_buyer = mySheet.GetCellValue(1,"BUYER");
		openSearchPopup('/common/approval/buyerCommonApprovalPop.do','?DOC_TYPE=RCT&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg+'&PARAM1='+st_buyer, "1000,500,no");
	}else{
		if (msg != "") {
			alert(msg);
		}
	}
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	pagingMode = "P";
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmCatalogRecharterList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "buyer_single": // 고객사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;
		case "agent_single": // 협력사
			openSearchPopup("/common/icomcmpyPop.do", '?BUSINESS_COND=S&MULTI=N', "500,466,no");
			popupSel = "agent_single";
			break;	
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if(column == 'BUYER_ITEM_NO'){ // 품목코드 선택
		var catalog_com_code = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
		var buyer = mySheet.GetCellValue(Row,"BUYER");
		var buyer_item_no = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		openSearchPopup("/mdcm/showMasterMdCmBuyerCatalogAlterPop.do","?st_buyer_code="+buyer+"&st_catalog_com_code="+catalog_com_code+"&st_buyer_item_no="+buyer_item_no,"988,710,no");
	}else if(column == "REVISION"){
		var st_rc_no = mySheet.GetCellValue(Row, "RC_NO");
		var st_rc_seq = mySheet.GetCellValue(Row, "RC_SEQ");
		popupSel = "sellerMpClCatalogRechaterHistoryPop";
		openSearchPopup("/mpcl/showSellerMpRqQuotationUnitpriceHistoryPop.do", '?st_rc_no='+st_rc_no+'&st_rc_seq='+st_rc_seq, "900,400,no");
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7){
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
	} else if (popupSel == "agent_single") {	// 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
		
		chItemStatusList(value1);
	}
	grbRow="";	//초기화
}
//엑셀다운로드 종료
function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}
//결재상신 후 재조회.
function kepApprovalReturn(ERR,GW_NO){ 
   	doAction('search');
}

function chkIncrRate() {
	var chk_rate = kepTrimStr(document.forms.searchCondition.st_incr_rate.value);
	
	if(!kepIsNumChkStr(chk_rate, 2)){
		alert("숫자와 소숫점만 입력 가능합니다.");
		document.forms.searchCondition.st_incr_rate.focus();
		return;
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
	
	if (mySheet.ColSaveName(Col) == "UNIT_PRICE_CHANGE_REASON"){ //표준납기일
		var value1 = mySheet.GetCellValue(arrRow[0], "UNIT_PRICE_CHANGE_REASON");
		if(kepIsValueNull(value1)){
			alert("복사할 매출단가 변동사유를 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "UNIT_PRICE_CHANGE_REASON", value1);
		}
		
	} else if (mySheet.ColSaveName(Col) == "LIST_PRICE_CHANGE_REASON"){ // 품목명
		var value1 = mySheet.GetCellValue(arrRow[0], "LIST_PRICE_CHANGE_REASON");
		if(kepIsValueNull(value1)){
			alert("복사할 매입단가 변동사유를 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "LIST_PRICE_CHANGE_REASON", value1);			
		}
	} 
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>카탈로그 재계약 관리</h3>
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
			<input type="hidden" id="st_dept_cd" name="st_dept_cd"  value="${sessionInfo.department}">
            	<table  class="cont_t_list01" >
					<caption>카탈로그 재계약 관리</caption>
					<colgroup>
						<col width="10%" />
						<col width="15%" />
						<col width="8%" />
						<col width="17%" />
						<col width="8%" />
						<col width="17%" />
						<col width="8%" />
						<col width="17%" />
					</colgroup>
						
					<tbody>
						<tr>
							<td>
								<label for="b_code" class="hidden">기간선택</label>
					  			<select name = "st_date_type" id="st_date_type" style="height:20px">
						      		<option value="REQ" selected="selected">재계약요청일</option>
									<option value="RES" >회신요청일</option>
									<option value="TAG" >재계약대상일</option>
	                           </select>
							</td>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								-
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
							</td>
							<th><font color="red"><b>*</b></font>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:55%" value="" readonly>
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
								<input type="hidden" name="st_com_org_code" id="st_com_org_code" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>협력사</th>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:55%"  readonly>
								<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:80%">
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
						<tr>
							<th>요청번호</th>
							<td>
								<input type="text"   class="input_type_text" name="st_rc_no" id="st_rc_no" style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:87%"  value="" onKeyUp="kepToUpper('st_buyer_item_no')" onkeydown="kepEnter()">
							</td>
							<th>진행상태</th>
							<td>
	                     		<select name = "st_rc_type" id="st_rc_type" >
	                     			<script type="text/javascript">kepAjaxCommonComboDataValue('st_rc_type', 'RC01', 'ALL', '');</script> 
				             	</select>
				            </td>
				            <th>매입단가인상율</th>
							<td>
								<input type="text" class="input_type_text" name="st_incr_rate" id="st_incr_rate" style="width:40%; text-align:right;" value="" onKeyDown="kepEnter()" onBlur="chkIncrRate();">
								<select id="st_incr_type" name="st_incr_type" style="width:30%">
									<option value = "U" selected>이상</option>
									<option value = "D">이하</option>
					            </select>
							</td>
						</tr>
						<tr>
							<th>품목명</th>
							<td>
								<input type="text"   class="input_type_text" name="st_description" id="st_description" style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
							<th>규격</th>
							<td>
								<input type="text"   class="input_type_text" name="st_specification" id="st_specification" style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
							<th>매출단가변경</th>
							<td>
								<select id="st_unit_price_yn" name="st_unit_price_yn">
									<option value = "ALL"  selected>전체</option>
									<option value = "Y">Y</option>
									<option value = "N" >N</option>
					            </select>
							</td>
							<th>매입단가변경</th>
							<td>
								<select id="st_price_yn" name="st_price_yn">
									<option value = "ALL"  selected>전체</option>
									<option value = "Y">Y</option>
									<option value = "N" >N</option>
					            </select>
							</td>
						</tr>
						<tr>
							<th>담당자</th>
							<td>
								<select id="st_mng_id" name="st_mng_id" style="width:80%;height:20px"></select>
							</td>
							<th></th>
							<td></td>
							<th></th>
							<td></td>
							<th></th>
							<td></td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="50">50건</option>
					<option value="100">100건</option>
					<option value="1000">1000건</option>
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
        <div class="btnArea02" >
         	<span class="fl">
				<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
			</span>
			<span class="fr">
				<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
				<span class="btn_02"><a href="javascript:doAction('cancle');">취소</a></span>
				<span class="btn_03"><a href="javascript:doAction('req');">재요청</a></span>
				<span class="btn_06"><a href="javascript:doAction('approval');">단가반영요청</a></span>
			</span>
		 </div>
  			 <br>
  			 ※ <b><font color="red">재계약 진행 시 매입단가가 변경여부 상관없이 반드시 매출단가 검증 후 단가반영 요청 바랍니다.</font></b><br>
		<!--내용 종료-->	    
</body>
</html>
