<%--
**********************************************
* 메뉴 : 매출세금계산서>매출 세금계산서 생성(수출)
* 화면 : 매출 세금계산서 생성(수출)
* 기능 : 
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Locale"%>
<%
	Calendar _calendar = Calendar.getInstance();
	Date _currentDate = new Date();
	SimpleDateFormat _formatter = new SimpleDateFormat("yyyyMMdd",
			Locale.KOREA);
	String _toDay = _formatter.format(_currentDate); // 현재일자
	_calendar.setTime(_currentDate);

	String[] _closeDate = new String[5];
	int[] _closeDay = new int[5];

	_calendar.add(Calendar.MONTH, -4); // 4개월전
	_closeDate[0] = _formatter.format(_calendar.getTime());
	_closeDay[0] = _calendar.getActualMaximum(Calendar.DAY_OF_MONTH);

	String _closeRevisionDate_1 = _closeDate[0].substring(0, 6)
			+ String.valueOf(_closeDay[0]);

	_calendar.add(Calendar.MONTH, 1); // 3개월전
	_closeDate[1] = _formatter.format(_calendar.getTime());
	_closeDay[1] = _calendar.getActualMaximum(Calendar.DAY_OF_MONTH);

	String _closeRevisionDate_2 = _closeDate[1].substring(0, 6)
			+ String.valueOf(_closeDay[1]);

	_calendar.add(Calendar.MONTH, 1); // 2개월전
	_closeDate[2] = _formatter.format(_calendar.getTime());
	_closeDay[2] = _calendar.getActualMaximum(Calendar.DAY_OF_MONTH);

	String _closeRevisionDate_3 = _closeDate[2].substring(0, 6)
			+ String.valueOf(_closeDay[2]);

	_calendar.add(Calendar.MONTH, 1); // 1개월전
	_closeDate[3] = _formatter.format(_calendar.getTime());
	_closeDay[3] = _calendar.getActualMaximum(Calendar.DAY_OF_MONTH);

	String _closeRevisionDate_4 = _closeDate[3].substring(0, 6)
			+ String.valueOf(_closeDay[3]);

	_calendar.add(Calendar.MONTH, 1); // 현재월
	_closeDate[4] = _formatter.format(_calendar.getTime());
	_closeDay[4] = _calendar.getActualMaximum(Calendar.DAY_OF_MONTH);

	String _closeRevisionDate_5 = _closeDate[4].substring(0, 6)
			+ String.valueOf(_closeDay[4]);
%>
<!DOCTYPE html>
<html>
<head>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ include file="../../common/include/head.jspf"%>
<script src="/resources/js/common.js"></script>

<script>
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; // Y: 번호 페이징, N : 스크롤
	var popupSel = "";

	var unit01 = KepSheetComboQueryIdData('common.masterCodeList', '', ''); // IBSHEET : 팀구분

	// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function kep_onload_view() {
		var initsheet = {};
		initsheet.Cols = [ 
		  {Align : "Center", Width : 60, Edit : false, EditLen : 0, Hidden : true, Type : "Status", ColMerge : 0, Header : "상태", SaveName : "sStatus"}
		, {Align : "Center", Width : 30, Edit : true,  EditLen : 30, Hidden : false, Type : "DummyCheck", ColMerge : 0, Header : "", SaveName : "SELECTED"}
		, {Align : "Center", Width : 150,Edit : false,EditLen : 200,Hidden : true, Type : "Text", ColMerge : 0, Header : "당사사업장", SaveName : "KEP_IRS_NAME"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				ColMerge:0,	Header:"사업자등록번호",	SaveName:"BUYER_IRS_NO"	,Sort:0}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				ColMerge:0,	Header:"고객사코드",		SaveName:"BUYER"}
		,{ Align:"left",		Width:180,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				ColMerge:0,	Header:"고객사명",			SaveName:"BUYER_NAME"}
		,{ Align:"Center",		Width:150,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				ColMerge:0,	Header:"신고번호",			SaveName:"EXP_GR_NO"}
		,{ Align:"Center",		Width:90,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Date",				ColMerge:0,	Header:"선적일자",			SaveName:"EXP_DATE_OF_SHIPMENT"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				ColMerge:0,	Header:"통화단위",	SaveName:"EXP_CUR"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,	Hidden:false,	Type:"Float",			ColMerge:0,	Header:"환율",			SaveName:"EXP_CUR_PRICE"}
		, {Align : "Center", Width : 100, Edit : true, EditLen : 200, Hidden : false, Type : "Combo", ColMerge : 0, Header : "팀구분", SaveName : "KEP_DEPT", BackColor : "${notnullColor}", KeyField:true,	ComboText : unit01.ComboText, ComboCode : unit01.ComboCode, Sort:0}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,	Hidden:false,	Type:"Float",			ColMerge:0,	Header:"입고금액",			SaveName:"GR_AMT"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,	Hidden:false,	Type:"Float",			ColMerge:0,	Header:"입고외화금액",			SaveName:"EXP_FOR_ITEM_AMT"}
		,{ Align:"Center",	Width:150,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				ColMerge:0,	Header:"당사사업자번호",	SaveName:"KEP_IRS_NO"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				ColMerge:0,	Header:"사이트구분코드",	SaveName:"SITE_GUBUN_CODE"}
		,{ Align:"Center",	Width:70,		Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				ColMerge:0,	Header:"팀구분코드",		SaveName:"KEP_DEPT_CODE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Date",				ColMerge:0,	Header:"GR_FROM_DATE",	SaveName:"GR_FROM_DATE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Date",				ColMerge:0,	Header:"GR_TO_DATE",		SaveName:"GR_TO_DATE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"CREDIT_LIMIT_FLAG",				SaveName:"CREDIT_LIMIT_FLAG"}
	];

		IBS_InitSheet(mySheet, initsheet, pagingMode);
		var cfg = {MergeSheet:msAll};
		mySheet.SetCountPosition(4);
		mySheet.SetConfig(cfg);
		// 행복사 타이틀 설정
		mySheet.SetCellFontUnderline(0, "KEP_DEPT", true);
		mySheet.SetCellFontUnderline(0, "BUYER_IRS_NO", true);
		
		// 하이퍼링크 설정
		setLinkCol(mySheet, "BUYER_IRS_NO"); // 사업자등록번호
		setLinkCol(mySheet, "BUYER_NAME"); // 고객사명
		
		// 조회조건 초기화
		// 조회조건 일자 초기화
		// kepSetCalenderYearMonth("st_from_date");
		// 조회조건 일자 설정]
		// 조회조건 초기화
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
	
		// 초기화 설정
		resetValue();
	}

	// 초기화 설정
	function resetValue() {
		// 조회조건 일자 설정
		var tempDate = kepToMonthAdd("1","M").replace(/[/]/gi,"");
		var tempYear = tempDate.substring(0,4);
		var tempMonth = tempDate.substring(4,6);
		var tempDay = lastDay(tempYear, tempMonth, "");
		$("#st_from_date").val( kepGetDateStr(tempYear+tempMonth+"01", "/") );
		$("#st_to_date").val( kepGetDateStr(tempDay, "/") );
		
		// 조회조건 hidden 설정
		$("#st_buyer_code").val("");
		$("#st_agent_code").val("");

		// 기타 설정
		$("#job_kind").val("");
		$("#buyerAmtSel").html("0");
		$("#buyerTaxAmtSel").html("0");
		$("#buyerAmt").html("0");
		$("#buyerTaxAmt").html("0");
	}

	// 현재달의 마지막날(일자) 구하기
	function lastDay(y, m, kind) {
		var d2, s = "";
		var year, month, day;

		d2 = new Date(y, m, "");

		year = d2.getFullYear();
		month = (d2.getMonth() + 1);
		day = d2.getDate();

		if (month < 10) {
			month = "0" + month;
		}
		if (day < 10) {
			day = "0" + day;
		}

		s = String(year) + String(month) + String(day);

		return (s);
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
		st = new Date();
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");

		// 선택된 항목 유무 체크
		if (str != "search" && str != "excelDown" && str != "reload" && selectedGrid.length == 0) {
			alert("선택된 항목이 없습니다.");
			return;
		}
		var choiceRadio = $("input[name=st_close_type]:checked").val();
		if ( choiceRadio == "ALL" ) {
			$("#issue_last_day").val( $("#st_close_month").val().substring(6,8) );
		} else {
			$("#issue_last_day").val( choiceRadio.substring(2,4) );
		}
		// 마감일수(차수) 설정
		if (str == "search") {
			var choiceRadio = $("input[name=st_close_type]:checked").val();

			if ( choiceRadio == "0110" || choiceRadio == "0115" || choiceRadio == "0120" ) {
				$("#st_close_revision").val( "1" );
			} else {
				$("#st_close_revision").val( "2" );
			}
		}

		switch (str) {
		case "search": // 조회
			// 조회조건 체크
			current_page = -1;
			$("#job_kind").val("");
			kepSearch(document.searchCondition, mySheet, "/cmcl/getMasterCmClSalesTaxExportSumList.do", pagingMode);
			break;

		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;
		case "create": // 생성
			if (!validationTardt())
				return;
			if (!confirm('세금계산서를 생성하시겠습니까?'))
				return;
			$("#issue_date").val($("#st_close_month").val().substring(0, 6));
			kepSave(document.searchCondition, mySheet, "/cmcl/saveMasterCmClSalesTaxExportSumList.do", "SELECTED");
			break;

		case "excelDown": // 엑셀다운로드
			var param = {
				FileName : "매출세금계산서(수출).xlsx",
				Merge : 1,
				SheetDesign : 1,
				DownCols : "KEP_IRS_NAME|BUYER_IRS_NO|BUYER|BUYER_NAME|EXP_GR_NO|EXP_DATE_OF_SHIPMENT|EXP_CUR|EXP_CUR_PRICE|KEP_DEPT|GR_AMT|EXP_FOR_ITEM_AMT|KEP_IRS_NO"
			};
			kepDownExcel(document.searchCondition, mySheet, "/cmcl/excelMasterCmClSalesTaxExportSumList.do", param);
			break;
		}
	}

	function mySheet_OnDownFinish(downloadType, result) {

		loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

	}
	// 행 전체 갯수
	var totalCnt = 0;
	// 조회 후처리
	function mySheet_OnSearchEnd(code, msg, stCode) {
		loader_obj("N");
		if (!checkedSession(stCode)) {
			return;
		}

		if (msg != "") {
			alert(msg);
		}
		setSumAmt();
	}
	// 트랜젝션(저장,삽입등) 후처리
	function mySheet_OnSaveEnd(code, msg, stCode) {
		loader_obj("N");
		if (!checkedSession(stCode)) {
			return;
		}

		if (msg != "") {
			alert(msg);
		}
		if (code > 0) {
			//저장 성공시 재조회
			doAction('search');
		}
	}
	// 금액정보 초기화 및 설정
	function setSumAmt() {
		// 선택한 공급가액, 부가가치세액, 누적공급가액, 누적 과세대상 금액 초기화
		$("#buyerAmtSel").html("0");
		$("#buyerTaxAmtSel").html("0");
		$("#st_totAmt").val('0');
		$("#st_totAmt_taxation").val('0');

		var buyerAmt = 0 ;
		var buyerTaxAmt = 0;
		
		// 과세 적용대상 금액
		var buyerAmt_taxation = 0 ;
		var tax_type = "";

		for( var i = 1; i <= mySheet.RowCount(); i++ ) {
			buyerAmt = buyerAmt + Number( kepFilterNum( String( mySheet.GetCellValue(i, "GR_AMT") ) ) );
			
			tax_type = mySheet.GetCellValue(i, "TAX_TYPE");
			
			// 과세구분-면세 = 세액 0
			if(tax_type == "11" || tax_type == ""){
				buyerAmt_taxation = buyerAmt_taxation + Number( kepFilterNum( String( mySheet.GetCellValue(i, "GR_AMT") ) ) );
			}
	    }

		buyerTaxAmt = Math.floor( buyerAmt_taxation * 0.1 );

		// 총 공급가액, 총 부가가치세액 설정
		$("#buyerAmt").html( kepCommaNum(buyerAmt) );
		$("#buyerTaxAmt").html( kepCommaNum(buyerTaxAmt) );
	}

	// 금액정보 처리
	function setAmt(index, value) {
		var buyerAmt = 0;
		var buyerTaxAmt = 0;
		
		var selAmt = Number( kepFilterNum( String( mySheet.GetCellValue(index, "GR_AMT") ) ) );
		var totAmt = Number( $("#st_totAmt").val() );

		// 과세 적용대상 금액
		var buyerAmt_taxation = 0 ;
		var totAmt_taxation = Number($("#st_totAmt_taxation").val());
		var selTaxType = mySheet.GetCellValue(index, "TAX_TYPE");
		
		if( value == "1" ) {
			buyerAmt = totAmt + selAmt;
			
			// 이전 과세 금액 + 선택 과세 금액
			buyerAmt_taxation = totAmt_taxation;
			if(selTaxType == "11" || selTaxType == ""){
				buyerAmt_taxation = totAmt_taxation + selAmt;
			}
		} else {
			buyerAmt = totAmt - selAmt;
			
			// 이전 과세 금액 - 선택 과세 금액
			buyerAmt_taxation = totAmt_taxation;
			if(selTaxType == "11" || selTaxType == ""){
				buyerAmt_taxation = totAmt_taxation - selAmt;
			}
		}

		buyerTaxAmt = Math.floor( buyerAmt_taxation * 0.1 );

		// 선택한 공급가액, 부가가치세액, 누적공급가액, 누적 과세 대상금액 설정
		$("#buyerAmtSel").html( kepCommaNum(buyerAmt) );
		$("#buyerTaxAmtSel").html( kepCommaNum(buyerTaxAmt) );
		$("#st_totAmt").val(buyerAmt);
		$("#st_totAmt_taxation").val(buyerAmt_taxation);
	}

	// Valitation - 생성
	function validationTardt() {
		var maxRow = mySheet.RowCount();
	    var issueDate = $("#st_close_month").val();
	    var checkedIndex = 0;
	   	var firstIrsNo = '';
		
	    for ( var i = 1; i <= maxRow; i++ ) {
	        if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
	            if ( mySheet.GetCellValue(i, "KEP_DEPT") == "" ) {
	                alert("실적 부서를 선택해주세요");
	                return false;
	            }
				if ( issueDate.substring(0,6) != mySheet.GetCellValue(i, "GR_TO_DATE").substring(0,6) ) {
					alert("입고일과 마감차수가 일치 하지 않습니다");
					return false;
				}
				var expDate = mySheet.GetCellValue(i, 'EXP_DATE_OF_SHIPMENT');
				if(expDate ==""){
					alert(i+"번째 선적일자 정보가 없습니다.");
					return false;					
				}
				var expCur = mySheet.GetCellValue(i, 'EXP_CUR');
				if(expCur ==""){
					alert(i+"번째 통화단위 정보가 없습니다.");
					return false;					
				}
				var expCurPrice = mySheet.GetCellValue(i, 'EXP_CUR_PRICE');
				if(expCurPrice ==""){
					alert(i+"번째 환율 정보가 없습니다.");
					return false;					
				}
				
	        	var creditLimitFlag = mySheet.GetCellValue(i, 'CREDIT_LIMIT_FLAG');
	        	var buyerName = mySheet.GetCellValue(i, 'BUYER_NAME');
	        	
				if(creditLimitFlag == "Y"){
					alert(buyerName+" 고객사 기초여신이 등록되어 있지 않거나\n여신이 초과되어매출 세금계산서를 생성 할 수 없습니다.");
					return false;				
				}
				
				var irsNo = mySheet.GetCellValue(i, 'BUYER_IRS_NO');
				if ( checkedIndex == 0 ) {
					firstIrsNo = irsNo;
				} else {
					if ( firstIrsNo != irsNo ) {
						alert("사업자번호가 다른 내역을 함께 생성 할수 없습니다");
						return false;
					}
				}
				checkedIndex++;
	        }
	    }


		return true;
	}

	// 그리드 헤더 전체 체크박스 클릭 이벤트
	function mySheet_OnCheckAllEnd(Col, Value) {

		var totCnt = mySheet.RowCount();

		if (totCnt < 1)
			return;

		var buyerAmt = 0;
		var buyerTaxAmt = 0;

		if (Value) {
			for (var i = 1; i <= totCnt; i++) {
				if (mySheet.GetCellValue(i, "sStatus") != '') {
					buyerAmt = buyerAmt + Number(kepFilterNum(String(mySheet.GetCellValue(i, "GR_AMT"))));
				}
			}

			buyerTaxAmt = Math.floor(buyerAmt * 0.1);

			// 선택한 공급가액, 부가가치세액, 누적공급가액 설정
			$("#buyerAmtSel").html(kepCommaNum(buyerAmt));
			$("#buyerTaxAmtSel").html(kepCommaNum(buyerTaxAmt));
			$("#st_totAmt").val(buyerAmt);
		} else {
			// 선택한 공급가액, 부가가치세액, 누적공급가액 설정
			$("#buyerAmtSel").html("0");
			$("#buyerTaxAmtSel").html("0");
			$("#st_totAmt").val('0');
		}
	}

	// 그리드 셀클릭 이벤트
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

		if (Row < 1)
			return;
		
		var column = mySheet.ColSaveName(mySheet.GetSelectCol());
		grbRow = Row; //현재 Row를 전역변수에 셋팅

		if (Col == 1 && mySheet.GetCellValue(Row, "sStatus") != '') {
			setAmt(Row, Value);
		}
		
		
		if (column == 'BUYER_IRS_NO' || column == 'BUYER_NAME') { // 사업자등록번호(고객사명) - 고객사 사업자번호 목록
			doPop('buyer_corp_regno');
		}

		return;
	}

	// 헤더 더블클릭 이벤트
	function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {
		if (Row > 0)
			return;

		var checkRows = mySheet.FindCheckedRow("SELECTED");

		if (checkRows.length == 0) {
			return;
		}

		var arrRow = checkRows.split("|");

		if (mySheet.ColSaveName(Col) == "KEP_DEPT") { // 팀구분
			var value1 = mySheet.GetCellValue(arrRow[0], "KEP_DEPT");

			for (var idx = 0; idx < arrRow.length; idx++) {
				mySheet.SetCellValue(arrRow[idx], "KEP_DEPT", value1);
			}
		}else if (mySheet.ColSaveName(Col) == "BUYER_IRS_NO"){ // 사업자번호
			var value1 = mySheet.GetCellValue(arrRow[0], "BUYER_IRS_NO");
			var value2 = mySheet.GetCellValue(arrRow[0], "BUYER_NAME");
			if(kepIsValueNull(value1)){
				alert("복사할 카테고리명을 입력하여 주십시요.");
				return;
			}
			for(var idx=0; idx<arrRow.length; idx++){
				mySheet.SetCellValue(arrRow[idx], "BUYER_IRS_NO", value1);
				mySheet.SetCellValue(arrRow[idx], "BUYER_NAME", value2);
			}
		}
	}
	// 검색일자 및 마감차수 설정
	function closeCnt(value) {
		var from_year = $("#st_close_month").val().substring(0,4);
		var from_month = $("#st_close_month").val().substring(4,6);
		var from_day = "01";
		var to_year = $("#st_close_month").val().substring(0,4);
		var to_month = $("#st_close_month").val().substring(4,6);
		var to_day = $("#st_close_month").val().substring(6,8);
		
		if ( value != "ALL" ) {
			from_day = value.substring(0,2);
			to_day = value.substring(2,4);
		}

		alert("아래 조건으로 "+from_year+"년 " + from_month + "월 " + "매출마감 대상 내역을 조회합니다.\n\n1. 입고일("+from_year+"/"+from_month+"/"+from_day+"~" +to_year+"/"+to_month+"/"+to_day+")");

		$("#st_from_date").val( kepGetDateStr(from_year + from_month + from_day, "/") );
		$("#st_to_date").val( kepGetDateStr(to_year + to_month + to_day, "/") );
	}

	// 팝업함수호출
	function doPop(str) {
		popupSel = str;

		switch (str) {
			case "buyer_single": // 고객사
				openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
				break;
				
			case "agent_single": // 협력사
				openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
				break;
				
			case "buyer_corp_regno": // 고객사 사업자번호 목록
				var buyer = mySheet.GetCellValue(grbRow, "BUYER");
				var st_dept_no =  mySheet.GetCellValue(grbRow, "KEP_DEPT");
				if(st_dept_no == ""){
					alert("팀구분 먼저 선택 바랍니다.");
					return;
				}
				var params = "?st_buyer="+buyer+"&st_dept_no="+st_dept_no;
				openSearchPopup("/cmco/showMasterCmCoBuyerCorpRegNoListPop.do", params, "600,250,no");
				break;
		}
	}
	// 콜백함수(파일명은 모두 동일)
	function setPopupReturn(value1, value2) {
		// 팝업 조회후 해당 항목에 값을 셋팅
		if (popupSel == "buyer_single") { // 단일 고객사
			$("#st_buyer_code").val(value1);
			$("#st_buyer_name").val(value2);
		// 	getCloseMonthList(); -- 마감차수 로직 변경 : 2014.07.31
	
		} else if (popupSel == "agent_single") { // 단일 협력사
			$("#st_agent_code").val(value1);
			$("#st_agent_name").val(value2);
	
		} else if (popupSel == "buyer_corp_regno") { // 고객사 사업자번호 목록
			mySheet.SetCellValue(grbRow, 'BUYER_IRS_NO', value1);
			mySheet.SetCellValue(grbRow, 'BUYER_NAME', value2);
		}
		
		grbRow="";	// 초기화
	}
	
</script>
</head>
<body onload="kep_onload_view()">
	<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA">
		<h3>매출 세금계산서 생성(수출)</h3>
		<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> <span class="btn_reset"><a
			href="javascript:doAction('reload')">초기화</a></span>
	</div>
	<!--조회영역-->
	<form name="searchCondition" method="post" onsubmit="return false">
		<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id" value="${sessionInfo.userId}"> <input type="hidden" id="job_kind" name="job_kind"
				value=""> <input type="hidden" id="issue_date" name="issue_date" value=""> <input type="hidden" id="issue_last_day"
				name="issue_last_day" value=""> <input type="hidden" id="st_close_revision" name="st_close_revision" value=""> <input
				type="hidden" id="st_totAmt" name="st_totAmt" value="0"> <input type="hidden" id="st_totAmt_taxation" name="st_totAmt_taxation" value="0">
			<table class="cont_t_list01">
				<caption>매출 세금계산서 생성(수출)</caption>
				<colgroup>
						<col width="6%" />
						<col width="24%" />
						<col width="6%" />
						<col width="24%" />
						<col width="6%" />
                        <col width="14%" />
						<col width="6%" />
                        <col width="14%" />
				</colgroup>

				<tbody>
					<tr>
						<th><font color="#FF6600">*</font>입고일</th>
						<td>
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:80px; text-align:center;" value="">
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:80px; text-align:center;" value="">
						</td>
						<th>마감차수</th>
						<td colspan="5">
								<input type="radio" class="Noborder" id="st_close_type_a1" name="st_close_type" value="ALL"  onClick="closeCnt(this.value)" checked>전체(~말일)&nbsp;&nbsp;
								<input type="radio" class="Noborder" id="st_close_type_a2" name="st_close_type" value="0115" onClick="closeCnt(this.value)">1-1차(1~15일)&nbsp;&nbsp;
								<input type="radio" class="Noborder" id="st_close_type_a3" name="st_close_type" value="0120" onClick="closeCnt(this.value)">1-2차(1~20일)&nbsp;&nbsp;
						</td>
					</tr>
					<tr>
						<th>고객사</th>
						<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:71%" value="" readonly onclick="javascript:doPop('buyer_single');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th>협력사</th>
						<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:71%" value="" readonly onclick="javascript:doPop('agent_single');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" value="">
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th>사업자번호</th>
						<td><input type="text" class="input_type_text" id="st_irs_no" name="st_irs_no" style="width:80%;" value="" onkeydown="kepEnter()"></td>
						<th></th>
						<td></td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>

	<!--grid-->
	<div class="ib_product" style="border-top: 2px solid #3c639c">
		<script type="text/javascript">
			createIBSheet("mySheet", "100%", "354px");
		</script>
	</div>

	<!--카운트영역-->
	<p class="paging3" id="count"></p>

	<!--금액영역-->
	<div>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" border="1" bgcolor="#FFFFFF">
			<tr>
				<td height="35" align="right" style="font-weight: bold" align="center">공급가액:<span id="buyerAmtSel" style="font-weight: bold; color: orange;">0</span>원&nbsp;&nbsp;&nbsp;
				</td>
				<td height="35" align="right" style="font-weight: bold" align="center">총 공급가액:<span id="buyerAmt" style="font-weight: bold; color: orange;">0</span>원&nbsp;&nbsp;&nbsp;
				</td>
			</tr>
		</table>
	</div>

	<!--버튼영역-->
	<div class="btnArea">
		<span class="fl"> <span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
		</span>

		<!-- 마감차수영역 -->
			<span id="grMonth">
				<select id="st_close_month" name="st_close_month"  onChange="fnSetIssueDate();">
					<option value='<%=_closeRevisionDate_1%>'><%=_closeRevisionDate_1.substring(0,4)%>년 <%=_closeRevisionDate_1.substring(4,6)%>월</option>
					<option value='<%=_closeRevisionDate_2%>'><%=_closeRevisionDate_2.substring(0,4)%>년 <%=_closeRevisionDate_2.substring(4,6)%>월</option>
					<option value='<%=_closeRevisionDate_3%>'><%=_closeRevisionDate_3.substring(0,4)%>년 <%=_closeRevisionDate_3.substring(4,6)%>월</option>
					<option value='<%=_closeRevisionDate_4%>' selected><%=_closeRevisionDate_4.substring(0,4)%>년 <%=_closeRevisionDate_4.substring(4,6)%>월</option>
					<option value='<%=_closeRevisionDate_5%>'><%=_closeRevisionDate_5.substring(0,4)%>년 <%=_closeRevisionDate_5.substring(4,6)%>월</option>
				</select>
			</span>
		마감&nbsp;&nbsp; <span class="fr"> <span class="btn_02"><a href="javascript:doAction('create');">생성</a></span>
		</span>
	</div>

	<!--내용 종료-->
</body>
</html>
