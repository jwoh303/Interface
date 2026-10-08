<%--
**********************************************
* 메뉴 : 매출세금계산서>매출 세금계산서 생성(삼성전자용 합산)
* 화면 : 매출 세금계산서 생성(삼성전자용 합산)
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
<style type="text/css">
<!--
table.ui-datepicker-calendar {
	display: none;
}
-->
</style>
<script>
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; // Y: 번호 페이징, N : 스크롤
	var popupSel = "";

	var unit01 = KepSheetComboQueryIdData('common.masterCodeList', '', ''); // IBSHEET : 팀구분

	// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function kep_onload_view() {
		var initsheet = {};
		initsheet.Cols = [ {
			Align : "Center",
			Width : 60,
			Edit : false,
			EditLen : 0,
			Hidden : true,
			Type : "Status",
			ColMerge : 0,
			Header : "상태",
			SaveName : "sStatus"
		}, {
			Align : "Center",
			Width : 30,
			Edit : true,
			EditLen : 30,
			Hidden : false,
			Type : "DummyCheck",
			ColMerge : 0,
			Header : "",
			SaveName : "SELECTED"
		}, {
			Align : "Center",
			Width : 100,
			Edit : false,
			EditLen : 200,
			Hidden : true,
			Type : "Text",
			ColMerge : 0,
			Header : "당사사업장",
			SaveName : "KEP_IRS_NAME"
		}, {
			Align : "Center",
			Width : 90,
			Edit : false,
			EditLen : 200,
			Hidden : false,
			Type : "Text",
			ColMerge : 0,
			Header : "사업자등록번호",
			SaveName : "BUYER_IRS_NO"
		}, {
			Align : "Center",
			Width : 90,
			Edit : false,
			EditLen : 200,
			Hidden : true,
			Type : "Text",
			ColMerge : 0,
			Header : "고객사코드",
			SaveName : "BUYER"
		}, {
			Align : "left",
			Width : 100,
			Edit : false,
			EditLen : 200,
			Hidden : false,
			Type : "Text",
			ColMerge : 0,
			Header : "고객사명",
			SaveName : "BUYER_NAME"
		}, {
			Align : "Center",
			Width : 100,
			Edit : true,
			EditLen : 200,
			Hidden : false,
			Type : "Combo",
			ColMerge : 0,
			Header : "팀구분",
			SaveName : "KEP_DEPT",
			BackColor : "${notnullColor}",
			ComboText : unit01.ComboText,
			ComboCode : unit01.ComboCode
		}, {
			Align : "left",
			Width : 80,
			Edit : false,
			EditLen : 200,
			Hidden : false,
			Type : "Text",
			ColMerge : 0,
			Header : "PLANT코드",
			SaveName : "REQ_DEPT"
		}, {
			Align : "left",
			Width : 180,
			Edit : false,
			EditLen : 200,
			Hidden : false,
			Type : "Text",
			ColMerge : 0,
			Header : "PLANT명",
			SaveName : "REQ_DEPT_NM"
		}, {
			Align : "left",
			Width : 80,
			Edit : false,
			EditLen : 200,
			Hidden : false,
			Type : "Text",
			ColMerge : 0,
			Header : "마감구분",
			SaveName : "REQ_DEPT_GBN"
		}, {
			Align : "left",
			Width : 100,
			Edit : false,
			EditLen : 200,
			Hidden : false,
			Type : "Text",
			ColMerge : 0,
			Header : "예산부서 코드",
			SaveName : "BUDGET_DEPT"
		}, {
			Align : "left",
			Width : 100,
			Edit : false,
			EditLen : 200,
			Hidden : false,
			Type : "Text",
			ColMerge : 0,
			Header : "예산부서명",
			SaveName : "BUDGET_DEPT_NM"
		}, {
			Align : "Center",
			Width : 60,
			Edit : false,
			EditLen : 200,
			Hidden : false,
			Type : "Text",
			ColMerge : 0,
			Header : "과세구분",
			SaveName : "TAX_TYPE_NM"
		}, {
			Align : "Center",
			Width : 60,
			Edit : false,
			EditLen : 200,
			Hidden : false,
			Type : "Text",
			ColMerge : 0,
			Header : "자산여부",
			SaveName : "ASSET_YN"
		}, {
			Align : "Center",
			Width : 60,
			Edit : false,
			EditLen : 200,
			Hidden : false,
			Type : "Text",
			ColMerge : 0,
			Header : "STSTEM ID",
			SaveName : "SYSTEM_ID"
		}, {
			Align : "Center",
			Width : 90,
			Edit : false,
			EditLen : 200,
			Hidden : false,
			Type : "Text",
			ColMerge : 0,
			Header : "정산담당자명",
			SaveName : "GR_CREATOR_NAME"
		}, {
			Align : "left",
			Width : 180,
			Edit : false,
			EditLen : 200,
			Hidden : false,
			Type : "Text",
			ColMerge : 0,
			Header : "정산담당자E-MAIL",
			SaveName : "GR_CREATOR_EMAIL"
		}, {
			Align : "right",
			Width : 100,
			Edit : false,
			EditLen : 21,
			Hidden : false,
			Type : "AutoSum",
			ColMerge : 0,
			Header : "입고금액",
			SaveName : "GR_AMT"
		}, {
			Align : "Center",
			Width : 90,
			Edit : false,
			EditLen : 100,
			Hidden : false,
			Type : "Text",
			ColMerge : 0,
			Header : "당사사업자번호",
			SaveName : "KEP_IRS_NO"
		}, {
			Align : "Center",
			Width : 110,
			Edit : false,
			EditLen : 100,
			Hidden : true,
			Type : "Text",
			ColMerge : 0,
			Header : "사이트구분코드",
			SaveName : "SITE_GUBUN_CODE"
		}, {
			Align : "Center",
			Width : 70,
			Edit : false,
			EditLen : 100,
			Hidden : true,
			Type : "Text",
			ColMerge : 0,
			Header : "팀구분코드",
			SaveName : "KEP_DEPT_CODE"
		}, {
			Align : "Center",
			Width : 70,
			Edit : false,
			EditLen : 100,
			Hidden : true,
			Type : "Text",
			ColMerge : 0,
			Header : "GR_FROM_DATE",
			SaveName : "GR_FROM_DATE"
		}, {
			Align : "Center",
			Width : 70,
			Edit : false,
			EditLen : 100,
			Hidden : true,
			Type : "Text",
			ColMerge : 0,
			Header : "GR_TO_DATE",
			SaveName : "GR_TO_DATE"
		}, {
			Align : "Center",
			Width : 70,
			Edit : false,
			EditLen : 100,
			Hidden : true,
			Type : "Text",
			ColMerge : 0,
			Header : "CREDIT_LIMIT_FLAG",
			SaveName : "CREDIT_LIMIT_FLAG"
		}, {
			Align : "Center",
			Width : 60,
			Edit : false,
			EditLen : 200,
			Hidden : true,
			Type : "Text",
			ColMerge : 0,
			Header : "TAX_TYPE",
			SaveName : "TAX_TYPE"
		} ];

		IBS_InitSheet(mySheet, initsheet, pagingMode);
		var cfg = {MergeSheet:msAll};
		mySheet.SetCountPosition(4);
		mySheet.SetConfig(cfg);
		// 조회조건 초기화
		// 조회조건 일자 초기화
		kepSetCalenderYearMonth("st_from_date");
		// 조회조건 일자 설정]
		$("#st_from_date").val(kepGetReTimeStr('YYYYMM', '/'));

		// 초기화 설정
		resetValue();
	}

	// 초기화 설정
	function resetValue() {
		// 조회조건 일자 설정
		// 조회조건 일자 초기화
		kepSetCalenderYearMonth("st_from_date");

		// 조회조건 일자 설정
		$("#st_from_date").val(kepGetNowTimeStr('YYYYMM', '/'));

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

		// 마감일수(차수) 설정
		if (str == "search") {
			var choiceRadio = $("input[name=st_close_type]:checked").val();

			if (choiceRadio == "A" || choiceRadio == "B") {
				$("#st_close_revision").val("1");
			} else {
				$("#st_close_revision").val("2");
			}
		}

		switch (str) {
		case "search": // 조회
			// 조회조건 체크
			current_page = -1;
			$("#job_kind").val("");
			kepSearch(document.searchCondition, mySheet, "/cmcl/getMasterCmClSalesTaxGroupSumList.do", pagingMode);
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
			kepSave(document.searchCondition, mySheet, "/cmcl/saveMasterCmClSalesTaxGroupSumList.do", "SELECTED");
			break;

		case "excelDown": // 엑셀다운로드
			var param = {
				FileName : "매출세금계산서(합산).xlsx",
				Merge : 1,
				SheetDesign : 1,
				DownCols : "KEP_IRS_NAME|BUYER_IRS_NO|BUYER|BUYER_NAME|KEP_DEPT|REQ_DEPT|REQ_DEPT_NM|REQ_DEPT_GBN|BUDGET_DEPT|TAX_TYPE_NM|GR_CREATOR_NAME|GR_CREATOR_EMAIL|GR_AMT"
			};
			kepDownExcel(document.searchCondition, mySheet, "/cmcl/excelMasterCmClSalesTaxGroupSumList.do", param);
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
		for (var i = 1; i <= maxRow; i++) {
			if (mySheet.GetCellValue(i, "SELECTED") == 1) {
				var creditLimitFlag = mySheet.GetCellValue(i, 'CREDIT_LIMIT_FLAG');
				if(creditLimitFlag == "Y"){
					alert("기초여신이 등록되어 있지 않거나\n여신이 초과되어 매출 세금계산서를 생성 할 수 없습니다.");
					return false;				
				}
				
				if (mySheet.GetCellValue(i, "KEP_DEPT") == "") {
					alert("실적 부서를 선택해주세요");
					return false;
				}
				if (mySheet.GetCellValue(i, "TAX_TYPE") == "") {
					alert("과세구분 정보가 없습니다.\n카탈로그 화면에서 과세정보 입력 바랍니다.");
					return false;
				}
				if (mySheet.GetCellValue(i, "GR_CREATOR_NAME") == "") {
					alert("정산담당자 정보가 없습니다.");
					return false;
				}
				if (mySheet.GetCellValue(i, "GR_CREATOR_EMAIL") == "") {
					alert("정산담당자 이메일 정보가 없습니다.");
					return false;
				}

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
		grbRow = Row; //현재 Row를 전역변수에 셋팅

		if (Col == 1 && mySheet.GetCellValue(Row, "sStatus") != '') {
			setAmt(Row, Value);
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
		}
	}
</script>
</head>
<body onload="kep_onload_view()">
	<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA">
		<h3>매출 세금계산서 생성(삼성전자 합산)</h3>
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
				<caption>매출 세금계산서 생성(합산)</caption>
				<colgroup>
					<col width="7%" />
					<col width="23%" />
					<col width="7%" />
					<col width="23%" />
					<col width="7%" />
					<col width="13%" />
					<col width="7%" />
					<col width="13%" />
				</colgroup>

				<tbody>
					<tr>
						<th><font color="#FF6600">*</font>입고월</th>
						<td><input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width: 100px; text-align: center;"
							value=""></td>
						<th>마감차수</th>
						<td colspan="5"><input type="radio" class="Noborder" id="st_close_type_a1" name="st_close_type" value="A" checked>전체(~말일)&nbsp;&nbsp;
							<input type="radio" class="Noborder" id="st_close_type_a2" name="st_close_type" value="B">1차(1~25일)&nbsp;&nbsp; <input type="radio"
							class="Noborder" id="st_close_type_a3" name="st_close_type" value="C">2차(26~말일)&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<th>PLANT</th>
						<td><select name="st_plant" id="st_plant" style="width: 80%">
								<%=CommonUtil.getCodeBComboList("KRSAMS0123", "ALL", "C001",
					"ICOMCOD2", "", "")%>
						</select></td>
						<th>과세구분</th>
						<td><select name="st_tax_type" id="st_tax_type" style="width: 80%">
								<%=CommonUtil.getCode3ComboList("", "ALL", "TX17", "",
					"ICOMCOD1", "", "")%>
						</select></td>
						<th>정산담당자</th>
						<td><input type="text" class="input_type_text" id="st_ar_mng" name="st_ar_mng" style="width: 80%;" value="" onkeydown="kepEnter()"></td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>PLANT코드</th>
						<td><input type="text" class="input_type_text" id="st_plant_cd" name="st_plant_cd" style="width: 80%;" value="" onkeydown="kepEnter()"></td>
						<th>예산부서코드</th>
						<td><input type="text" class="input_type_text" id="st_budgt_cd" name="st_budgt_cd" style="width: 80%;" value="" onkeydown="kepEnter()"></td>
						<th></th>
						<td></td>
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
					부가가치세액:<span id="buyerTaxAmtSel" style="font-weight: bold; color: orange;">0</span>원
				</td>
				<td height="35" align="right" style="font-weight: bold" align="center">총 공급가액:<span id="buyerAmt" style="font-weight: bold; color: orange;">0</span>원&nbsp;&nbsp;&nbsp;
					총 부가가치세액:<span id="buyerTaxAmt" style="font-weight: bold; color: orange;">0</span>원
				</td>
			</tr>
		</table>
	</div>

	<!--버튼영역-->
	<div class="btnArea">
		<span class="fl"> <span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
		</span>

		<!-- 마감차수영역 -->
		<span id="grMonth"> <select id="st_close_month" name="st_close_month">
				<option value='<%=_closeRevisionDate_1%>'><%=_closeRevisionDate_1.substring(0, 4)%>년
					<%=_closeRevisionDate_1.substring(4, 6)%>월
				</option>
				<option value='<%=_closeRevisionDate_2%>'><%=_closeRevisionDate_2.substring(0, 4)%>년
					<%=_closeRevisionDate_2.substring(4, 6)%>월
				</option>
				<option value='<%=_closeRevisionDate_3%>'><%=_closeRevisionDate_3.substring(0, 4)%>년
					<%=_closeRevisionDate_3.substring(4, 6)%>월
				</option>
				<option value='<%=_closeRevisionDate_4%>' selected><%=_closeRevisionDate_4.substring(0, 4)%>년
					<%=_closeRevisionDate_4.substring(4, 6)%>월
				</option>
				<option value='<%=_closeRevisionDate_5%>'><%=_closeRevisionDate_5.substring(0, 4)%>년
					<%=_closeRevisionDate_5.substring(4, 6)%>월
				</option>
		</select>
		</span> 마감&nbsp;&nbsp; <span class="fr"> <span class="btn_02"><a href="javascript:doAction('create');">생성</a></span>
		</span>
	</div>

	<!--내용 종료-->
</body>
</html>
