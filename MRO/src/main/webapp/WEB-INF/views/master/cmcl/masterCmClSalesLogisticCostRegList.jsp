<%--
**********************************************
* 메뉴 : 매출세금계산서>매출 물류비 등록
* 화면 : 매출 물류비 등록
* 기능 :
* 프로그램 ID : PG_10_M_007_00
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
   		 { Align:"Center",Width:30,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",						SaveName:"sStatus"}
   		,{ Align:"Center",	Width:30,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	Header:"",								SaveName:"SELECTED"}
   		,{ Align:"Center",	Width:60,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"생성여부",					SaveName:"STATUS"}
   		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:400,	Hidden:false,	Type:"Date",				Header:"입고일자",					SaveName:"ISSUE_DATE"}
   		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"당사사업장",				SaveName:"KEP_IRS_NAME"}
   		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"당사사업자번호",			SaveName:"KEP_IRS_NO"}
   		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"고객사코드",				SaveName:"BUYER"}
   		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"고객사명",					SaveName:"BUYER_NAME"}
   		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"사업자등록번호",			SaveName:"BUYER_IRS_NO"}
   		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"협력사코드",				SaveName:"AGENT"}
   		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"협력사명",					SaveName:"AGENT_NAME"}
   		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"협력사사업자등록번호",	SaveName:"AGENT_IRS_NO"}
   		,{ Align:"Center",	Width:60,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"팀구분",						SaveName:"KEP_DEPT"}
   		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"팀구분명",					SaveName:"KEP_DEPT_NAME"}
   		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,	Hidden:false,	Type:"Float",				Header:"입고금액",					SaveName:"GR_AMT"}
   		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:21,	Hidden:false,	Type:"Float",				Header:"수수료율",					SaveName:"FEE_PERCENT",		Format:"##0.0%"}
   		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,	Hidden:false,	Type:"Float",				Header:"물류Fee",					SaveName:"LOGISTICS_FEE"}
   		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,	Hidden:false,	Type:"Float",				Header:"공급가",						SaveName:"SUPP_PRICE"}
   		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,	Hidden:false,	Type:"Float",				Header:"세액",						SaveName:"TAX_PRICE"}
   		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,	Hidden:false,	Type:"Float",				Header:"합계",						SaveName:"AMT"}
   		,{ Align:"Center",	Width:60,		Edit:false,	EditLen:400,	Hidden:false,	Type:"Date",				Header:"마감월",						SaveName:"AR_MONTH",		Format:"Ym"}
   	];

	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]

	// 조회조건 초기화
	kepSetCalenderYearMonth("st_from_date");
	
	// 초기화 설정
	resetValue();
}

// 초기화 설정
function resetValue() {
	// 일자 설정
	$("#st_from_date").val( kepGetNowTimeStr('YYYYMM','/') );
	
	// 조회조건 hidden 설정
	$("#st_buyer_code").val("");
	
	// 기타 설정
	$("#job_kind").val("");
}

// 현재달의 마지막날(일자) 구하기
function lastDay(y , m , kind) {
	var d2, s = "";
    var year, month, day;

    d2 = new Date(y,m,"");

    year  = d2.getFullYear();
	month = (d2.getMonth()+1);
    day   = d2.getDate();

	if ( month < 10 ) {
		month = "0" + month;
    }
	if ( day < 10 ) {
		day = "0" + day;
    }

	s = String(year) + String(month) + String(day);

	return(s);
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
	if ( str !="search" && str !="reload" && str !="loadExcel" && selectedGrid.length == 0 ) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	// 마감일수(차수) 설정
	if ( str == "create" ) {
		var choiceRadio = $("input[name=st_close_type]:checked").val();

		if ( choiceRadio == "ALL" ) {
			var lastMonthDay = lastDay($("#st_from_date").val().substring(0,4), $("#st_from_date").val().substring(5,7) , "");
			$("#issue_last_day").val( lastMonthDay.substring(6,8) );
		} else {
			$("#issue_last_day").val( choiceRadio.substring(2,4) );
		}
		
		if ( choiceRadio == "0110" || choiceRadio == "0115" || choiceRadio == "0120" ) {
			$("#st_close_revision").val( "1" );
		} else {
			$("#st_close_revision").val( "2" );
		}
	}

	switch (str) {
		case "search": // 조회
			current_page = -1;
			$("#job_kind").val("");
			kepSearch(document.searchCondition, mySheet, "/cmcl/getMasterCmClSalesLogisticCostRegList.do", pagingMode );
			break;

		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;

		case "delete": // 삭제
			if ( !validationDelete() )
				return;
			if ( !confirm('선택한 내역을을 삭제하시겠습니까?') )
				return;
			$("#job_kind").val("delete");
			kepSave(document.searchCondition, mySheet, "/cmcl/delMasterCmClSalesLogisticCostRegList.do" , "SELECTED" );
			break;

		case "create": // 생성
			if ( !validationCreate() )
				return;
			if ( !confirm('세금계산서를 생성하시겠습니까?') )
				return;
			$("#job_kind").val("create");
			kepSave(document.searchCondition, mySheet, "/cmcl/saveMasterCmClSalesLogisticCostRegList.do", "SELECTED" );
			break;

		case "loadExcel": // 엑셀업로드
			mySheet.RemoveAll();
			var params = { Mode : "NoHeader", StartRow: "2", ColumnMapping:"|||1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18"};
			mySheet.LoadExcel(params);
			break;
	}
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if ( msg != "" ) {
		alert(msg);
	}
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if ( msg != "" ) {
		alert(msg);
	}

	if ( code > 0 ) {
		// 저장 성공시 재조회
		doAction('search');
	} else {
		if ( $("#job_kind").val() == "save" ) {
			mySheet.RemoveAll();
		}
	}
}

// Valitation - 삭제
function validationDelete() {
	var maxRow = mySheet.RowCount();
	
    for ( var i = 1; i <= maxRow; i++ ) {
        if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
            if ( mySheet.GetCellValue(i, "STATUS") == "생성" ) {
                alert("세금계산서가 생성된 건은 삭제 할 수 없습니다.\n\n다시 확인해 주시기 바랍니다.");
                return false;
            }
        }
    }

	return true;
}

// Valitation - 생성
function validationCreate() {
	var maxRow = mySheet.RowCount();
	
    for ( var i = 1; i <= maxRow; i++ ) {
        if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
            if ( mySheet.GetCellValue(i, "STATUS") == "생성" ) {
                alert("세금계산서가 생성된 건이 있습니다.\n\n다시 확인해 주시기 바랍니다.");
                return false;
            }
        }
    }

	return true;
}

// 엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {
	$("#job_kind").val("save");
	kepSave(document.searchCondition, mySheet, "/cmcl/saveMasterCmClSalesLogisticCostRegList.do", -1 );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;

	switch (str) {
		case "buyer_single": // 고객사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {
// 	alert("value1 / value2 => " + value1 + " / " + value2);

	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 단일 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}

	grbRow="";	//초기화
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>매출 물류비 등록(Uploading)</h3>
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
			<input type="hidden" id="job_kind" name="job_kind" value="">
			<input type="hidden" id="issue_date" name="issue_date" value="">
			<input type="hidden" id="issue_last_day" name="issue_last_day" value="">
			<input type="hidden" id="st_close_revision" name="st_close_revision" value="">

            	<table  class="cont_t_list01" >
					<caption>매출 물류비 등록(Uploading)</caption>
					<colgroup>
						<col width="6%" />
						<col width="14%" />
						<col width="6%" />
						<col width="14%" />
						<col width="6%" />
						<col width="54%" />
					</colgroup>

					<tbody>
						<tr>
							<th><font color="#FF6600">*</font>입고월</th>
							<td>
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:70px; text-align:center;" value="">
							</td>
							<th>&nbsp;</th>
							<td>&nbsp;</td>
							<th>생성차수</th>
							<td>
								<input type="radio" class="Noborder"  id="st_close_type_a1" name="st_close_type" value="ALL" checked>전체(~말일)&nbsp;&nbsp;
								<input type="radio" class="Noborder"  id="st_close_type_a2" name="st_close_type" value="0115">1-1차(1~15일)&nbsp;&nbsp;
								<input type="radio" class="Noborder"  id="st_close_type_a3" name="st_close_type" value="0120">1-2차(1~20일)&nbsp;&nbsp;
								<input type="radio" class="Noborder"  id="st_close_type_a4" name="st_close_type" value="0110">두중1차(1~10일)&nbsp;&nbsp;
								<input type="radio" class="Noborder"  id="st_close_type_a5" name="st_close_type" value="1120">두중2차(11~20일)
							</td>
						</tr>
						<tr>
							<th>고객사</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:71%" value="" readonly onclick="javascript:doPop('buyer_single');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>&nbsp;</th>
							<td>&nbsp;</td>
						</tr>
					</tbody>
				</table>
            </div>
		</form>

      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c; padding-bottom:10px;">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>

		<!--버튼영역-->
		<div class="btnArea">
          	<span class="fl">
				<span class="btn_04 mr04"><a href="javascript:doAction('loadExcel');">엑셀업로드</a></span>
				<span class="btn_04"><a href="/resources/excel/work/CLOSE/masterCmClSalesLogisticCostReg.xls">양식다운로드</a></span>
			</span>

			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('delete');">삭제</a></span>
				<span class="btn_02"><a href="javascript:doAction('create');">생성</a></span>
			</span>
		</div>

<!--내용 종료-->
</body>
</html>
