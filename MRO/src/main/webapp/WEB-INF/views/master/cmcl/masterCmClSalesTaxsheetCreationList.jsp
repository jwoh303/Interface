<%--
**********************************************
* 메뉴 : 매출세금계산서>매출 세금계산서 생성(금액분할)
* 화면 : 매출 세금계산서 생성(금액분할)
* 기능 : 
* 프로그램 ID : PG_10_M_005_00
* 담당자 : 최명진 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.text.SimpleDateFormat"%> 
<%@ page import="java.util.Calendar"%> 
<%@ page import="java.util.Date"%> 
<%@ page import="java.util.Locale"%> 
<%
	Calendar _calendar = Calendar.getInstance();
	Date _currentDate = new Date();
	SimpleDateFormat _formatter = new SimpleDateFormat ( "yyyyMMdd", Locale.KOREA );
	String _toDay = _formatter.format ( _currentDate ); // 현재일자
	_calendar.setTime( _currentDate );        
	
	String _closeDate = "";
// 	int _closeDay = "";
	
	_calendar.add(Calendar.MONTH, -1);	// 1개월전
	_closeDate = _formatter.format ( _calendar.getTime() );
// 	_closeDay =  _calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:60,		Edit:true,	EditLen:30,	Hidden:true,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"당사사업장",		SaveName:"KEP_IRS_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"사업자등록번호",	SaveName:"BUYER_IRS_NO"}
		,{ Align:"left",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"고객사명",			SaveName:"BUYER_NAME"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"팀구분",				SaveName:"KEP_DEPT"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,	Hidden:false,	Type:"Float",				Header:"입고금액",			SaveName:"GR_AMT"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,	Hidden:false,	Type:"Float",				Header:"세액",				SaveName:"TAX_AMT"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"당사사업자번호",	SaveName:"KEP_IRS_NO"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"사이트구분코드",	SaveName:"SITE_GUBUN_CODE"}
		,{ Align:"Center",	Width:70,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"부서코드",			SaveName:"KEP_DEPT_CODE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"고객사코드",		SaveName:"BUYER"}
	];

	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]

	// 콤보데이터 셋팅
	kepAjaxCommonQueryIdCombo('st_buyer_code','common.masterBuyerCodeList','SEL','');	// 조회조건 : 고객사

}

// 초기화 설정
function resetValue() {
	// 마감차수 설정
	$("#grMonth").html("");
	
	// 기타 설정
	$("#job_kind").val("");
	$("#grAmt").html("0");
	$("#grAmtExcel").html("0");
	$("#grTaxExcel").html("0");
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
	if ( str !="search" && str !="excelDown" && str !="reload" && str !="loadExcel" && str != "create" && selectedGrid.length == 0 ) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	if ( str == "create" && mySheet.RowCount() == 0 ) {
		alert("조회된 데이터가 없습니다.");
		return;
	}

	switch (str) {
		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;
	
		case "create": // 생성
			if ( !validationTardt() )
				return;
			if ( !confirm('세금계산서를 생성하시겠습니까?') )
				return;
			$("#issue_date").val($("#st_close_month").val());
			kepSave(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClSalesTaxsheetCreationList.do" , "SELECTED" );
			break;
	
		case "loadExcel": // ExcelImport
			mySheet.RemoveAll();
			var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"||1|2|3|4|5|6|7|8|9|10"};
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
		// 초기화 처리
		doAction("reload");
	}
}

// 엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {
	var maxRow = mySheet.RowCount();
	var totAmt = 0;
	var totAmtExcel = 0;
	var totTaxExcel = 0;
	
	for ( var i = 1; i <= maxRow; i++ ) {
		totAmt += Number(mySheet.GetCellValue(i, "GR_AMT"));
	}
	
	if ( totAmt > 0 ) {
		totAmtExcel = Math.floor(totAmt);
		totTaxExcel = Math.floor(totAmt * 0.1);
	} else {
		totAmtExcel = Math.cell(totAmt);
		totTaxExcel = Math.cell(totAmt * 0.1);
	}
	
	$("#st_gr_amt_excel").val(totAmt);
	$("#grAmtExcel").html(kepCommaNum(totAmtExcel));
	$("#grTaxExcel").html(kepCommaNum(totTaxExcel));
}

// 생성 밸리데이션 체크
function validationTardt() {
	var maxRow = mySheet.RowCount();
	var firstIrsNo = '';
	var firstDept = '';
	var irscheckedIndex = 0;
	var deptcheckedIndex = 0;
	
	var gr_amt = Number($("#st_gr_amt").val());
	var gr_amt_excel = Number($("#st_gr_amt_excel").val());
	
	if ( gr_amt != gr_amt_excel ) {
		alert("입고금액과 공급가액(세금계산서금액)이 일치해야 합니다");
		return false;
	}
	
	var selBuyer = $("#st_buyer_code").val();
	
	for ( var i = 1; i <= maxRow; i++ ) {
		var gridBuyer = mySheet.GetCellValue(i, 'BUYER');
		var gridBuyerIrsNo = mySheet.GetCellValue(i, 'BUYER_IRS_NO');
		var gridBuyerDeptCode = mySheet.GetCellValue(i, 'KEP_DEPT_CODE');
		var gridGrAmt = mySheet.GetCellValue(i, 'GR_AMT');
		var gridTaxAmt = mySheet.GetCellValue(i, 'TAX_AMT');
		
		if ( gridBuyer == '' ) {
			alert(i + "번째 업로드한 고객사 코드가 비어 있습니다.\n\n확인 후 다시 업로드 해주시기 바랍니다");
			return false;
		}
		else if ( gridBuyerIrsNo == '' ) {
			alert(i + "번째 업로드한 고객사 사업자번호가 비어 있습니다.\n\n확인 후 다시 업로드 해주시기 바랍니다");
			return false;
		}
		else if ( gridBuyerDeptCode == '' ) {
			alert(i + "번째 업로드한 부서코드가 비어 있습니다.\n\n확인 후 다시 업로드 해주시기 바랍니다");
			return false;
		}
		else if ( gridGrAmt == '' ) {
			alert(i + "번째 업로드한 입고금액이 비어 있습니다.\n\n확인 후 다시 업로드 해주시기 바랍니다");
			return false;
		}
		else if ( gridTaxAmt == '' ) {
			alert(i + "번째 업로드한 세액이 비어 있습니다.\n\n확인 후 다시 업로드 해주시기 바랍니다");
			return false;
		}
		else if ( gridTaxAmt == '' ) {
			alert(i + "번째 업로드한 당사 사업자번호가 비어 있습니다.\n\n확인 후 다시 업로드 해주시기 바랍니다");
			return false;
		}
		
		if ( gridBuyer != selBuyer ) {
			alert(i + "번째 업로드한 고객사 코드와 선택된 고객사 코드가 다릅니다");
			return false;
		}
		
		var irsNo = mySheet.GetCellValue(i, 'BUYER_IRS_NO');	
		
		if ( irscheckedIndex == 0 ) {
			firstIrsNo = irsNo;
		} else {
			if ( firstIrsNo != irsNo ) {
				alert("사업자번호가 다른 내역을 함께 생성 할수 없습니다");
				return false;
			}
		}
		
		var deptCode = mySheet.GetCellValue(i, 'KEP_DEPT');	
		
		if ( deptcheckedIndex == 0 ) {
			firstDept = deptCode;
		} else {
			if ( firstDept != deptCode ) {
				alert("팀구분이 다른 내역을 함께 생성 할수 없습니다");
				return false;
			}
		}
		
		irscheckedIndex++;
		deptcheckedIndex++;
		
		mySheet.SetCellValue(i, "SELECTED", "1");
	}

	return true;
}

// ajax 마감차수 조회 호출 함수
function getCloseMonthList() {
	var from_date = $("#st_from_date").val();
	var buyer_code = $("#st_buyer_code").val();

	// kepAjaxCall 공통 ajax
	var data = {  from_date:from_date, buyer_code:buyer_code };
	kepAjaxCall("/cmcl/getMasterCmClIndividualList_getCloseMonthList.do",data,"getCloseMonthList");
}

// ajax 입고금액 합산 조회 호출 함수
function getBuyerGrAmt() {
	$("#issue_date").val($("#st_close_month").val());
	var issue_date = $("#issue_date").val();
	var buyer_code = $("#st_buyer_code").val();

	// kepAjaxCall 공통 ajax
	var data = {  issue_date:issue_date, buyer_code:buyer_code };
	kepAjaxCall("/cmcl/getMasterCmClSalesTaxsheetCreationList_getBuyerGrAmt.do",data,"getBuyerGrAmt");
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var MSG = response.msg.MSG;

	if ( MSG == "null" || MSG == null ) {
		MSG = "";
	}

	if ( pMethod == "getCloseMonthList" ) {
		$("#grMonth").html( MSG );
		$("#st_close_month").val($("#st_close_month option:eq(0)").val());
		getBuyerGrAmt();
	}

	if ( pMethod == "getBuyerGrAmt" ) {
		var amt = Number(MSG);
		
		if ( amt >= 0 ) {
			amt = Math.floor(amt);
		} else {
			amt = Math.cell(amt);
		}
		
		$("#grAmt").html(kepCommaNum(MSG));
		$("#st_gr_amt").val(amt);
	}
}

// ajax 공통 호출후 에러시 처리 함수
function kepAjaxError(pMethod , response) {
	if (pMethod == "getCloseMonthList"){
		alert("마감차수 조회 오류 발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
	}
	if (pMethod == "getBuyerGrAmt"){
		alert("입고금액 조회 오류 발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
	}
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>매출 세금계산서 생성(금액분할)</h3>
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
			<input type="hidden" id="issue_date" name="issue_date" value="">
			<input type="hidden" id="st_from_date" name="st_from_date" value="<%=_closeDate%>">
			<input type="hidden" id="st_gr_amt" name="st_gr_amt" value="0">
			<input type="hidden" id="st_gr_amt_excel" name="st_gr_amt_excel" value="0">

            	<table  class="cont_t_list01" >
					<caption>매출 세금계산서 생성(금액분할)</caption>
					<colgroup>
						<col width="80px" />
						<col width="20%" />
						<col width="30px" />
						<col width="" />
					</colgroup>

					<tbody>
						<tr>
							<th>고객사</th>
							<td>
								<select id="st_buyer_code" name="st_buyer_code" style="width:80%;height:20px" onChange="getCloseMonthList();"></select>
							</td>
							<th>&nbsp;</th>
							<td>&nbsp;</td>
						</tr>
					</tbody>
				</table>
            </div>
		</form>

      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
		
		<!-- 금액영역 -->
		<div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="200" align="left"	style="font-weight:bold" height="30">입고금액: <span id="grAmt" name="grAmt" style="font-weight:bold; color:orange;">0</span> 원</td>
					<td width="200" align="left"	style="font-weight:bold">공급가액: <span id="grAmtExcel" name="grAmtExcel" style="font-weight:bold; color:orange;">0</span> 원</td>
					<td width="200" align="left"	style="font-weight:bold">부가가치액: <span id="grTaxExcel" name="grTaxExcel" style="font-weight:bold; color:orange;">0</span> 원</td>
				</tr>
			</table>
		</div>

		<!--버튼영역-->
		<div class="btnArea">
			<span class="fl">
				<span class="btn_04 mr04"><a href="javascript:doAction('loadExcel');">EXCEL업로드</a></span>
				<span class="btn_04"><a href="/resources/excel/work/CLOSE/masterCmClSalesTaxsheetCreation.xls">양식다운로드</a></span>
			</span>

			<!-- 마감차수영역 -->
			<span id="grMonth">
			</span>
			마감&nbsp;&nbsp;

			<span class="fr">
				<span class="btn_02"><a href="javascript:doAction('create');">생성</a></span>
			</span>
		</div>

<!--내용 종료-->
</body>
</html>
