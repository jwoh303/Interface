<%--
**********************************************
* 메뉴 : 매출세금계산서>매출 세금계산서 생성(Uploading)
* 화면 : 매출 세금계산서 생성(Uploading)
* 기능 : 
* 프로그램 ID : PG_10_M_004_00
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

var unit01 = KepSheetComboQueryIdData('common.masterCodeList','SEL','');	// IBSHEET : 팀구분

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			ColMerge:0,	Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	ColMerge:0,	Header:"",						SaveName:"SELECTED"}
		,{ Align:"Center",	Width:70,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				ColMerge:0,	Header:"생성여부",			SaveName:"IS_CREATE"}
		,{ Align:"Center",	Width:60,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				ColMerge:1,	Header:"연번",				SaveName:"TAX_SERIAL"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				ColMerge:0,	Header:"당사사업장",		SaveName:"KEP_IRS_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				ColMerge:0,	Header:"사업자등록번호",	SaveName:"BUYER_IRS_NO"}
		,{ Align:"left",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				ColMerge:0,	Header:"고객사명",			SaveName:"BUYER_NAME"}
		,{ Align:"Center",	Width:100,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Combo",			ColMerge:0,	Header:"팀구분",				SaveName:"KEP_DEPT", BackColor:"${notnullColor}", ComboText:unit01.ComboText, ComboCode:unit01.ComboCode}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:300,	Hidden:false,	Type:"Date",				ColMerge:0,	Header:"입고일",				SaveName:"GR_DATE"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,	Hidden:false,	Type:"AutoSum",			ColMerge:0,	Header:"입고금액",			SaveName:"GR_AMT"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				ColMerge:0,	Header:"발주번호",			SaveName:"PO_NO"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				ColMerge:0,	Header:"입고번호",			SaveName:"GR_NO"}
		,{ Align:"Center",	Width:70,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				ColMerge:0,	Header:"입고항번",			SaveName:"GR_SEQ"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				ColMerge:0,	Header:"고객사코드",		SaveName:"BUYER"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				ColMerge:0,	Header:"당사사업자번호",	SaveName:"KEP_IRS_NO"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				ColMerge:0,	Header:"사이트구분코드",	SaveName:"SITE_GUBUN_CODE"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:400,	Hidden:false,	Type:"Text",				ColMerge:0,	Header:"마감월",				SaveName:"CL_MON"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"CREDIT_LIMIT_FLAG",				SaveName:"CREDIT_LIMIT_FLAG"}
	];

	IBS_InitSheet(mySheet, initsheet,pagingMode);
// 	mySheet.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	
	var cfg = {MergeSheet:msAll};
	mySheet.SetConfig(cfg);
	
	var info = [ {StdCol:"TAX_SERIAL", SumCols:"GR_AMT", CaptionCol:"TAX_SERIAL", ShowCumulate:0, CaptionText:"- 소 계 -"} ];
	mySheet.ShowSubSum(info);
	mySheet.SetSumBackColor("#f0f0f0");
	
	// 초기화 설정
	resetValue();
}

// 초기화 설정
function resetValue() {
	// 조회조건 hidden 설정
	$("#st_buyer_code").val("");
	
	// 카운트 설정
	$("#count").text("[ 0 / 0 ]");
	
	// 마감차수 설정
	$("#grMonth").html("");
	
	// 기타 설정
	$("#job_kind").val("");
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
		case "search": // 조회
			// 조회조건 체크
			if ( !searchValidate() )
				return;
			current_page = -1;
			$("#job_kind").val("");
			kepSearch(document.searchCondition,  mySheet , "/cmcl/getMasterCmClSalesTaxsheetUploadingCreationList.do" , pagingMode );
			break;
	
		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;
	
		case "delete": // 삭제
			if ( !confirm('선택한 내역을을 삭제하시겠습니까?') )
				return;
			$("#job_kind").val("");
			kepSave(document.searchCondition ,  mySheet , "/cmcl/delMasterCmClSalesTaxsheetUploadingCreationList.do" , "SELECTED" );
			break;
	
		case "create": // 생성
			if ( !validationTardt() )
				return;
			if ( !confirm('체크 여부와 상관없이 조회된 모든 내역이 처리됩니다.\n\n세금계산서를 생성하시겠습니까?') )
				return;
			$("#issue_date").val($("#st_close_month").val());
			$("#job_kind").val("create");
			kepSave(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClSalesTaxsheetUploadingCreationList.do" , "SELECTED" );
			break;
	
		case "loadExcel": //  ExcelImport
			// 엑셀 업로드 조건 체크
			if ( !searchValidate() )
				return;
			mySheet.RemoveAll();
			var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"|||1|2|3|4|5|6|7|8|9|10|11|12|13|14|"};
			mySheet.LoadExcel(params);
			break;
			
// 		case "excelDown": // 엑셀다운로드
// 			var param = {FileName:"MyExcel.xlsx"};
// 			kepDownExcel(document.searchCondition ,mySheet , "/cmcl/excelMasterCmClSalesTaxsheetUploadingCreationList.do", param);
// 			break;
	}
}

// 조회조건 체크
function searchValidate() {
	if ( kepTrim("st_buyer_code") == '' ) {
		alert("고객사를 선택해 주십시오");
		return false;
	}

	return true;
}

// 소계행 정보
var subarr = null;
var subcnt = 0;

// 행 전체 갯수
var totalCnt = 0;

// 세로 스크롤이 움직일때, 
function mySheet_OnVScroll() {
	getCurrentRow();
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if ( msg != "" ) {
		alert(msg);
	}
	
	// 시트 내 전체행을 가져온다.
	var totalRow = mySheet.GetTotalRows();
	
	if ( totalRow > 0 ) {
		// 시트 내 소계행을 가져온다.
		var row = mySheet.FindSubSumRow();
		
		subarr = row.split("|");
		subcnt = subarr.length;
		
		// 전체행에서 소계행 갯수를 뺀다.
		totalCnt = totalRow - subcnt;
		
		getCurrentRow();
	} else {
		// 카운트 설정
		$("#count").text("[ 0 / 0 ]");
	}
	
	// 합계 행 다듬기
	mySheet.SetSumValue(1,"- 합 계 -");
	mySheet.SetCellAlign(mySheet.LastRow(),1,"Center");
	mySheet.SetMergeCell (mySheet.LastRow(), 1, 1, 2);
}

// 소계행을 제외하기 위한 함수
function getCurrentRow() {
	var bottomRow = mySheet.LastRow(1);		// 화면 하단에 있는 행의 번호
	var currRow = bottomRow;
	
	// 행 중에 소계행을 제회한 행 번호를 계산한다.
	for ( var i = 0; i < subcnt; i++ ) {
		if( bottomRow >= subarr[i] ) {
			currRow--;
		}
	}
	
	// 실제 카운트를 나타낼 부분
	$("#count").text("[ " + currRow + " / " + totalCnt + " ]");
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if ( msg != "" ) {
		alert(msg);
	}

	if ( code > 0 ) {
		//저장 성공시 재조회
		doAction('search');
	}
	else {
		if ( $("#job_kind").val() == "save" ) {
			mySheet.RemoveAll();
		}
	}
}

// 엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {
	// 합계 행 다듬기
	mySheet.SetSumValue(1,"- 합 계 -");
	mySheet.SetCellAlign(mySheet.LastRow(),1,"Center");
	mySheet.SetMergeCell (mySheet.LastRow(), 1, 1, 2);
	
	// 저장 처리
	$("#job_kind").val("save");
	
	var maxRow = mySheet.RowCount();
	for ( var  i = 1; i <= maxRow; i++ ) {  
	
		var BUYER_IRS_NO = mySheet.GetCellValue(i, "BUYER_IRS_NO") ;
		var KEP_DEPT = mySheet.GetCellValue(i, "KEP_DEPT") ; 
		var TAX_SERIAL = mySheet.GetCellValue(i, "TAX_SERIAL") ; 
	  
	 	if (TAX_SERIAL != "- 소 계 -"){
			if (BUYER_IRS_NO == ""){
				alert(i + " 행 사업자등록번호 필수입니다.\n다시 엑셀업로드 부탁드립니다.");
				mySheet.RemoveAll();
	   			return;
	  		}
			if (KEP_DEPT == ""){
				alert(i + " 행 팀구분 필수입니다.\n다시 엑셀업로드 부탁드립니다.");
				mySheet.RemoveAll();
				return;
			}
		}
	} 
	kepSaveAll(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClSalesTaxsheetUploadingCreationList.do" );
}

// 연번별 사업자번호 중복 여부 체크
function validationTardt() {
	var maxRow = mySheet.RowCount();
	var taxSerialArr = new Array();
	var taxSerial = '';
	var firstTaxSerial = '';
	var index = 0;
	var indexCount = 1;
	var checkedIndex = 0;
	
	for ( var i = 1; i <= maxRow; i++ ) {
		var creditLimitFlag = mySheet.GetCellValue(i, 'CREDIT_LIMIT_FLAG');
		var buyerName = mySheet.GetCellValue(i, 'BUYER_NAME');
		var kep_irs_no = mySheet.GetCellValue(i, 'KEP_IRS_NO');
		
		if(creditLimitFlag == "Y"){
			alert(buyerName+" 고객사 기초여신이 등록되어 있지 않거나\n여신이 초과되어 매출 세금계산서를 생성 할 수 없습니다.");
			return false;				
		}
		
		if ( mySheet.GetCellValue(i, "sStatus") != '' ) {
			if ( mySheet.GetCellValue(i, "IS_CREATE") != "미생성" ) {
				alert("미생성건만 처리 할 수 있습니다.\n\n생성 또는 오류건을 삭제하여주세요");
				return false;
			}
			
			if(kep_irs_no == ""){
				alert(i+"번째 행 당사사업자번호가 올바르지 않습니다. 업로드하신 파일 내에서 확인해보시기 바랍니다.");
				return false;			
			}
			
			taxSerial = mySheet.GetCellValue(i, 'TAX_SERIAL');
			
			if (  i == 1 || (taxSerial != firstTaxSerial) ) {
				firstTaxSerial = taxSerial;
				taxSerialArr[index++] = taxSerial;
			}
			
		}
		
	}

    for ( var i = 0; i < taxSerialArr.length; i++ ) {
		var firstIrsNo = '';
		
		for ( var j = indexCount; j <= maxRow ; j++ ) {
			if ( mySheet.GetCellValue(j, "sStatus") != '' ) {
				var taxSeq = mySheet.GetCellValue(j, 'TAX_SERIAL');
				
				if ( taxSerialArr[i] ==  taxSeq ) {
					var irsNo = mySheet.GetCellValue(j, 'BUYER_IRS_NO');
					
					if ( checkedIndex == 0 ) {
						firstIrsNo = irsNo;
					} else {
						if ( firstIrsNo != irsNo ) {
							alert("연번 "+taxSerialArr[i]+"에서 사업자번호가 다른 내역을 함께 생성 할수 없습니다");
							return false;
						}
					}
				} else {
					indexCount = j;
					checkedIndex = 0;
					break;
				}
				
				checkedIndex++;
			}
		}
    }

    for ( var i = 1; i <= maxRow; i++ ) {
    	if ( mySheet.GetCellValue(i, "sStatus") != '' ) {
			mySheet.SetCellValue(i, "SELECTED", "1");
    	}
	}

    var issueDate = $("#st_close_month").val();

    for ( var  i = 1; i <= maxRow; i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			if ( issueDate.substring(0, 6) != mySheet.GetCellValue(i, "GR_DATE").substring(0, 6) ) {
				alert("입고일과 마감차수가 일치 하지 않습니다");
				return false;
			}
		}
    }

	return true;
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;

	switch (str) {
		case "buyer_single": // 고객사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
			
		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=0000007zw&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {
// 	alert("value1 / value2 => " + value1 + " / " + value2);

	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") { // 단일 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
		getCloseMonthList();
	}

	grbRow="";	//초기화
}

// ajax 마감차수 조회 호출 함수
function getCloseMonthList() {
	var from_date = $("#st_from_date").val();
	var buyer_code = $("#st_buyer_code").val();

	// kepAjaxCall 공통 ajax
	var data = { from_date:from_date, buyer_code:buyer_code };
	kepAjaxCall("/cmcl/getMasterCmClIndividualList_getCloseMonthList.do", data, "getCloseMonthList");
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var MSG = response.msg.MSG;

	if ( MSG == "null" || MSG == null ) {
		MSG = "";
	}

	if ( pMethod == "getCloseMonthList" ) {
		$("#grMonth").html( MSG );
	}
}

// ajax 공통 호출후 에러시 처리 함수
function kepAjaxError(pMethod , response) {
	if (pMethod == "getCloseMonthList"){
		alert("마감차수 조회 오류 발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.");
	}
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>매출 세금계산서 생성(Uploading)</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
		    <span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
   		</div>
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME" >
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="job_kind" name="job_kind" value="">
			<input type="hidden" id="issue_date" name="issue_date" value="">
			<input type="hidden" id="st_from_date" name="st_from_date" value="<%=_closeDate%>">
			<div id="cont_searchA">
            	<table  class="cont_t_list01" >
					<caption>매출 세금계산서 생성(Uploading)</caption>
					<colgroup>
						<col width="6%" />
						<col width="44%" />
						<col width="6%" />
						<col width="44%" />
					</colgroup>

					<tbody>
						<tr>
							<th><font color="#FF6600">*</font>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:50%" value="" readonly onclick="javascript:doPop('buyer_single');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>상태</th>
							<td>
								<select id="st_status" name="st_status" style="width:20%;height:20px">
									<option value="ALL">전체</option>
									<option value="Y">생성</option>
									<option value="N">미생성</option>
									<option value="E">오류</option>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
		</form>

      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c;">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
		
		<!--카운트영역-->
  		<p class="paging3" id="count"></p>

		<!--버튼영역-->
		<div class="btnArea" style="padding-top:30px;">
			<span class="fl">
				<span class="btn_04 mr04"><a href="javascript:doAction('loadExcel');">EXCEL업로드</a></span>
				<span class="btn_04"><a href="/resources/excel/work/CLOSE/masterCmClSalesTaxsheetUploadingCreation.xls">양식다운로드</a></span>
			</span>

			<!-- 마감차수영역 -->
			<span id="grMonth">
			</span>
			마감&nbsp;&nbsp;

			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('delete');">삭제</a></span>
				<span class="btn_02"><a href="javascript:doAction('create');">생성</a></span>
			</span>
		</div>

<!--내용 종료-->
</body>
</html>
