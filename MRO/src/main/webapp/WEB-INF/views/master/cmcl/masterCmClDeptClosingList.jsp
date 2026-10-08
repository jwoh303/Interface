<%--
**********************************************
* 메뉴 : 마감관리>부서별마감설정
* 화면 : 부서별마감설정
* 기능 :
* 프로그램 ID : PG_10_M_020_00
* 담당자 : 최명진 ( 설계 : 김상근 )
* 착수일 : 2014-
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

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"부서코드",			SaveName:"DEPT_CODE"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"부서명",				SaveName:"DEPT_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Date",				Header:"마감월",				SaveName:"CLOSE_YYYYMM",		Format:"Ym"}
		,{ Align:"Center",	Width:80,		Edit:true,	EditLen:80,	Hidden:false,	Type:"Combo",			Header:"마감상태",			SaveName:"CLOSE_YN",				BackColor:"${notnullColor}",	KeyField:true,		Sort:0,		ComboText:"Y|N", 	ComboCode:"Y|N"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Date",				Header:"수정일시",			SaveName:"CHANGE_DATE"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Date",				Header:"수정시간",			SaveName:"CHANGE_TIME",		Format:"Hm"}
		,{ Align:"Right",	Width:120,	Edit:false,	EditLen:90,	Hidden:false,	Type:"Float",				Header:"매출금액",			SaveName:"AR_AMT"}
		,{ Align:"Right",	Width:120,	Edit:false,	EditLen:90,	Hidden:false,	Type:"Float",				Header:"매입금액",			SaveName:"AP_AMT"}
	];

// 	initsheet.HeaderMode = { Sort : 0, ColMove : 1, ColResize : 1 };
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	
	// 행복사 타이틀 설정
	mySheet.SetCellFontUnderline(0, "CLOSE_YN", true);

	// 콤보데이터 셋팅
	kepAjaxCommonQueryIdCombo('st_dept','common.masterCodeList','ALL',''); // 조회조건 : 해당팀
	
	// 조회조건 일자 초기화
	kepSetCalenderYearMonth("st_from_date");
	$("#st_from_date").val( kepGetNowTimeStr('YYYYMM','/') );
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
	if ( str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0 ) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search": // 조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/cmcl/getMasterCmClDeptClosingList.do", pagingMode);
			break;

		case "reload": // 초기화
			kepReload('searchCondition');
			$("#st_from_date").val( kepGetNowTimeStr('YYYYMM','/') );
			mySheet.RemoveAll();
			break;

		case "save": // 저장
			if (!validationSave())
				return;
			if (!confirm('선택한 항목을 저장 하시겠습니까?'))
				return;
			kepSave(document.searchCondition, mySheet, "/cmcl/saveMasterCmClDeptClosingList.do", "SELECTED");
			break;
	}
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if (msg != "") {
		alert(msg);
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

// Valitation - 저장
function validationSave() {
	// 마감(Y)설정은 누구나~ 마감(Y)에서 마감취소(N)설정은 회계부서만~
	var userDept = $("#st_dept_code").val(); // 사용자부서
	var misDept = "005"; // 회계부서
	
	for ( var i = 1 ; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 && mySheet.GetCellValue(i, "CLOSE_YN") == 'N' && mySheet.CellSearchValue(i, "CLOSE_YN") == 'Y' ) {
			if ( userDept != misDept ) {
				alert("마감설정 취소는 경영지원실 회계파트에서 처리합니다.");
				return false;
			}
		}
	}

	return true;
}

// 헤더 더블클릭 이벤트
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	
	if ( checkRows.length == 0 ) {
// 		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	
	var arrRow = checkRows.split("|");
	
	if ( mySheet.ColSaveName(Col) == "CLOSE_YN" ) { // 마감여부
		var value1 = mySheet.GetCellValue(arrRow[0], "CLOSE_YN");
	
// 		if ( kepIsValueNull(value1) ) {
// 			alert("복사할 부서를 입력하여 주십시요.");
// 			return;
// 		}
		
		for ( var idx=0; idx<arrRow.length; idx++ ) {
			mySheet.SetCellValue(arrRow[idx], "CLOSE_YN", value1);
		}
	}
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>부서별마감설정</h3>
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
		<input type="hidden" id="st_dept_code" name="st_dept_code"  value="${sessionInfo.department}">

           	<table  class="cont_t_list01" >
				<caption>부서별마감설정</caption>
				<colgroup>
					<col width="8%" />
					<col width="22%" />
					<col width="8%" />
					<col width="32%" />
					<col width="30%" />
				</colgroup>

				<tbody>
					<tr>
						<th><font color="#FF6600">*</font>마감월</th>
						<td>
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:80px; text-align:center;" value="">
						</td>
						<th>부서</th>
						<td>
							<select id="st_dept" name="st_dept" style="width:30%;height:20px" ></select>
						</td>
						<td>&nbsp;</td>
					</tr>
				</tbody>
			</table>
		</div>

      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c; padding-bottom:10px;">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>

		<!--버튼영역-->
        <div class="btnArea">
			<span class="fr">
				<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
			</span>
		</div>
	</form>
<!--내용 종료-->

</body>
</html>
