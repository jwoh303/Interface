<%--
**********************************************
* 메뉴 : 매출세금계산서>매출 세금계산서 생성(건별/합산)>건별
* 화면 : 매출 세금계산서 생성(건별)
* 기능 :
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-09-17
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.text.SimpleDateFormat"%> 
<%@ page import="java.util.Calendar"%> 
<%@ page import="java.util.Date"%> 
<%@ page import="java.util.Locale"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
	Calendar _calendar = Calendar.getInstance();
	Date _currentDate = new Date();
	SimpleDateFormat _formatter = new SimpleDateFormat( "yyyyMMdd", Locale.KOREA );
	String _toDay = _formatter.format ( _currentDate ); // 현재일자
	_calendar.setTime( _currentDate );        
	
	String[] _closeDate = new String[6];
	int[] _closeDay = new int[6];
	
	_calendar.add( Calendar.MONTH, -4 ); // 4개월전
	_closeDate[0] = _formatter.format( _calendar.getTime() );
	_closeDay[0] = _calendar.getActualMaximum( Calendar.DAY_OF_MONTH );
	
	String _closeRevisionDate_1 = _closeDate[0].substring(0, 6) + String.valueOf( _closeDay[0] );
	
	_calendar.add( Calendar.MONTH, 1 ); // 3개월전
	_closeDate[1] = _formatter.format( _calendar.getTime() );
	_closeDay[1] = _calendar.getActualMaximum( Calendar.DAY_OF_MONTH );
	
	String _closeRevisionDate_2 = _closeDate[1].substring(0, 6) + String.valueOf( _closeDay[1] );
	
	_calendar.add( Calendar.MONTH, 1 ); // 2개월전
	_closeDate[2] = _formatter.format( _calendar.getTime() );
	_closeDay[2] = _calendar.getActualMaximum( Calendar.DAY_OF_MONTH );
	
	String _closeRevisionDate_3 = _closeDate[2].substring(0, 6) + String.valueOf( _closeDay[2] );
	
	_calendar.add( Calendar.MONTH, 1 ); // 1개월전
	_closeDate[3] = _formatter.format( _calendar.getTime() );
	_closeDay[3] = _calendar.getActualMaximum( Calendar.DAY_OF_MONTH );
	
	String _closeRevisionDate_4 = _closeDate[3].substring(0, 6) + String.valueOf( _closeDay[3] );
	
	_calendar.add( Calendar.MONTH, 1 ); // 현재월
	_closeDate[4] = _formatter.format( _calendar.getTime() );
	_closeDay[4] = _calendar.getActualMaximum( Calendar.DAY_OF_MONTH );
	
	String _closeRevisionDate_5 = _closeDate[4].substring(0, 6) + String.valueOf( _closeDay[4] );
	
	_calendar.add( Calendar.MONTH, 1 ); // 현재월+1개월
	_closeDate[5] = _formatter.format( _calendar.getTime() );
	_closeDay[5] = _calendar.getActualMaximum( Calendar.DAY_OF_MONTH );
	
	String _closeRevisionDate_6 = _closeDate[5].substring(0, 6) + String.valueOf( _closeDay[5] );
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

var unit01 = KepSheetComboQueryIdData('common.masterCodeList','','');	// IBSHEET : 팀구분

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var cb_tax_type = KepSheetComboData("TX17","");
    var tax_type = {ComboCode: cb_tax_type.ComboCode, ComboText: cb_tax_type.ComboText};
    
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"당사사업장",		SaveName:"KEP_IRS_NAME",	FontColor:"#1e90ff"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"사업자등록번호",	SaveName:"BUYER_IRS_NO",	FontColor:"#1e90ff"  , Sort:0} 
		,{ Align:"left",		Width:150,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"고객사명",			SaveName:"BUYER_NAME", 	FontColor:"#1e90ff"}
		,{ Align:"Center",	Width:100,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Combo",			Header:"팀구분",				SaveName:"KEP_DEPT",			BackColor:"${notnullColor}",	KeyField:true,		Sort:0,		ComboText:unit01.ComboText, 	ComboCode:unit01.ComboCode}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"팀구분DB값",			SaveName:"KEP_DEPT_OLD"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Date",				Header:"실적등록일",				SaveName:"DELIVERY_DATE"}
		,{ Align:"Center",	Width:100,	Edit:true,	EditLen:300,	Hidden:false,	Type:"Date",				Header:"입고일",				SaveName:"GR_DATE",			BackColor:"${notnullColor}",	KeyField:true,		Sort:0}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"일고일DB값",			SaveName:"GR_DATE_OLD"}
		,{ Align:"right",	Width:100,	Edit:false,	EditLen:21,	Hidden:false,	Type:"Float",				Header:"입고금액",			SaveName:"GR_AMT"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"발주번호",			SaveName:"PO_NO"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"입고번호",			SaveName:"GR_NO"}
		,{ Align:"Center",	Width:60,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"입고항번",			SaveName:"GR_SEQ"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"고객사코드",		SaveName:"BUYER"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"당사사업자번호",	SaveName:"KEP_IRS_NO"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"사이트구분코드",	SaveName:"SITE_GUBUN_CODE"}
		,{ Align:"left",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"품명",				SaveName:"DESCRIPTION"}
		,{ Align:"left",		Width:120,	Edit:false,	EditLen:250,	Hidden:false,	Type:"Text",				Header:"규격",				SaveName:"SPECIFICATION"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"팀구분코드",		SaveName:"KEP_DEPT_CODE"}
		,{ Align:"left",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"협력사명",			SaveName:"AGENT_NAME"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"협력사코드",		SaveName:"AGENT"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"발주자ID",			SaveName:"PO_USER_ID"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"발주자명",			SaveName:"PO_USER_NAME"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"발주부서",			SaveName:"PO_DEPT"}
		,{ Align:"left",		Width:80,		Edit:false,	EditLen:400,	Hidden:false,	Type:"Text",				Header:"발주비고",			SaveName:"PO_REMARK"}
		,{ Align:"left",		Width:100,	Edit:false,	EditLen:400,	Hidden:false,	Type:"Text",				Header:"IF_PO_NO",			SaveName:"LEGACY_PO_NO"}
		,{ Align:"left",		Width:100,	Edit:false,	EditLen:400,	Hidden:false,	Type:"Text",				Header:"IF_PO_SEQ",			SaveName:"LEGACY_PO_SEQ"}
		,{ Align:"left",		Width:100,	Edit:false,	EditLen:400,	Hidden:false,	Type:"Text",				Header:"관리번호1",			SaveName:"REF_IF_NO"}
		,{ Align:"left",		Width:100,	Edit:false,	EditLen:400,	Hidden:false,	Type:"Text",				Header:"관리번호2",			SaveName:"REF_PR_NO"}
		,{ Align:"left",		Width:100,	Edit:false,	EditLen:400,	Hidden:false,	Type:"Text",				Header:"카테고리명",		SaveName:"CATEG_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:400,	Hidden:false,	Type:"Text",				Header:"카테고리코드",		SaveName:"CATEG_CODE"}
		,{ Align:"left",		Width:100, 	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"품목코드",			SaveName:"ITEM_NO"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"요청자",				SaveName:"PURCHASER_NAME"}
		,{ Align:"Center",	Width:0,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"카드사용구분",		SaveName:"CARD_USE_FLAG"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"연번",				SaveName:"TAX_SERIAL"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"매입마감여부",				SaveName:"AP_BILL_FLAG"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Combo",		Header:"과세구분",			SaveName:"TAX_TYPE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"CREDIT_LIMIT_FLAG",				SaveName:"CREDIT_LIMIT_FLAG"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:150,	Hidden:true,	Type:"Text",		Header:"INV_NO",		SaveName:"INV_NO"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:150,	Hidden:true,	Type:"Text",		Header:"INV_SEQ",		SaveName:"INV_SEQ"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:150,	Hidden:true,	Type:"Text",		Header:"PROCESS_TYPE",		SaveName:"PROCESS_TYPE"}
	];
	
// 	initsheet.HeaderMode = { Sort : 0, ColMove : 1, ColResize : 1 };
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]

	mySheet.SetColProperty("TAX_TYPE", tax_type);
	
	// 행복사 타이틀 설정
	mySheet.SetCellFontUnderline(0, "KEP_DEPT", true);
	mySheet.SetCellFontUnderline(0, "BUYER_IRS_NO", true);
	mySheet.SetCellFontUnderline(0, "GR_DATE", true);
	
	// 하이퍼링크 설정
	setLinkCol(mySheet, "KEP_IRS_NAME"); // 당사사업장
	setLinkCol(mySheet, "BUYER_IRS_NO"); // 사업자등록번호
	setLinkCol(mySheet, "BUYER_NAME"); // 고객사명

	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	// 초기화 설정
	resetValue();
}

// 초기화 설정
function resetValue() {
	// 조회조건 일자 설정
	var tempDate = kepGetNowTimeStr('YYYYMMDD','/').replace(/[/]/gi,"");
	var tempYear = tempDate.substring(0,4);
	var tempMonth = tempDate.substring(4,6);
	var tempDay = lastDay(tempYear, tempMonth, "");
	$("#st_from_date").val( kepGetDateStr(tempYear+tempMonth+"01", "/") );
	$("#st_to_date").val( kepGetDateStr(tempDay, "/") );
	
	// 조회조건 hidden 설정
	$("#st_buyer_code").val("");
	$("#st_agent_code").val("");
	
	// 마감차수 설정
// 	$("#grMonth").html(""); -- 마감차수 로직 변경 : 2014.07.31
	
	// 기타 설정
	$("#job_kind").val("");
	$("#buyerAmtSel").html("0");
	$("#buyerTaxAmtSel").html("0");
	$("#buyerAmt").html("0");
	$("#buyerTaxAmt").html("0");
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
	if ( str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0 ) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	// 마감일수(차수) 설정
	if ( str == "search" ) {
		var choiceRadio = $("input[name=st_close_type]:checked").val();

		if ( choiceRadio == "ALL" ) {
			$("#issue_last_day").val( $("#st_close_month").val().substring(6,8) );
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
			// 조회조건 체크
			if ( !searchValidate() )
				return;
			current_page = -1;
			$("#job_kind").val("");
			kepSearch(document.searchCondition, mySheet, "/cmcl/getMasterCmClIndividualList_v2.do", pagingMode);
			break;
	
		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;
	
		case "save": // 저장
			if ( !checkCardUse() )
				return;
			if ( !confirm('선택한 항목을 저장 하시겠습니까?') )
				return;
			$("#job_kind").val("save");
			kepSave(document.searchCondition, mySheet, "/cmcl/saveMasterCmClIndividualList_v2.do" , "SELECTED");
			break;
	
		case "create": // 생성
			if ( !checkCardUse() )
				return;
			if ( !validationTardt() )
				return;
			if ( !confirm('세금계산서를 생성하시겠습니까?') )
				return;
// 			$("#issue_date").val($("#st_close_month").val());
			$("#issue_date").val($("#st_close_month").val().substring(0,6));
			$("#job_kind").val("create");
			kepSave(document.searchCondition, mySheet, "/cmcl/saveMasterCmClIndividualList_v2.do" , "SELECTED");
			break;
	
		case "excelDown": // 엑셀다운로드
			var param = {FileName:"매출세금계산서(건별).xlsx",Merge:1,SheetDesign:1,DownCols:"TAX_SERIAL|KEP_IRS_NAME|BUYER_IRS_NO|BUYER_NAME|KEP_DEPT|GR_DATE|GR_AMT|PO_NO|GR_NO|GR_SEQ|BUYER|KEP_IRS_NO|SITE_GUBUN_CODE|DESCRIPTION|SPECIFICATION|AGENT_NAME|AGENT|PO_USER_ID|PO_USER_NAME|PO_DEPT|PO_REMARK|LEGACY_PO_NO|LEGACY_PO_SEQ|REF_IF_NO|REF_PR_NO|CATEG_NAME|CATEG_CODE|ITEM_NO|PURCHASER_NAME|KEP_DEPT_CODE|TAX_TYPE"};
			kepDownExcel(document.searchCondition, mySheet, "/cmcl/excelMasterCmClIndividualList_v2.do", param);
			break;
	}
}

function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

}

// 조회조건 체크
function searchValidate() {
	var start_date = $("#st_from_date").val().replace(/[/]/gi,"");
	var end_date = $("#st_to_date").val().replace(/[/]/gi,"");
	
	if ( start_date > end_date ) {
		alert("입고 종료일은 시작일보다 작을 수 없습니다");
		return false;
	}
	if ( kepTrim("st_buyer_code") == '' ) {
		alert("고객사를 선택해 주십시오");
		return false;
	}

	return true;
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

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if ( msg != "" ) {
		alert(msg);
	}

	setSumAmt();
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

// 카드&일반 중복 선택 여부 체크
function checkCardUse() {
    var firstCheckRowCardValue = "";
	var j = 0;

    for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
        if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
            j++;

            if ( j == 1 ) {
                firstCheckRowCardValue = mySheet.GetCellValue(i, "CARD_USE_FLAG");
            }

            if ( firstCheckRowCardValue != mySheet.GetCellValue(i, "CARD_USE_FLAG") ) {
                alert('카드결제건과 일반발주건은 동시에 생성할 수 없습니다.');
                return false;
            }

            if ( mySheet.GetCellValue(i, "KEP_DEPT") == "" ) {
                alert("실적 부서를 선택해주세요");
                return false;
            }
            
            if ( mySheet.GetCellValue(i, "GR_DATE") == "" ) {
                alert("일고일을 지정해주세요");
                return false;
            }
            
//             if ( mySheet.GetCellValue(i, "GR_DATE") != mySheet.GetCellValue(i, "GR_DATE_OLD") ) {
//                 if ( mySheet.GetCellValue(i, "AP_BILL_FLAG") == "Y" ) {
//             		alert(i +"번째 입고건은 매입마감되어 입고일을 변경할 수 없습니다.");
// 	                return false;
//                 }
//         	}
            if ( mySheet.GetCellValue(i, "GR_DATE") != mySheet.GetCellValue(i, "GR_DATE_OLD") ) {
            	if(mySheet.GetCellValue(i, "DELIVERY_DATE") > mySheet.GetCellValue(i, "GR_DATE")){ //실적등록일 > 입고일 될 수 없음
					alert("입고일은 실적등록일 이전 날짜로 할 수 없습니다.");
					return;
    			}
            }
            
        }
    }

	return true;
}

// 사업자번호 중복 선택 여부 체크
function validationTardt() {
	var maxRow = mySheet.RowCount();
	var firstIrsNo = '';
	var firstKepIrsNo = '';
	var checkedIndex = 0;

    for ( var i = 1; i <= maxRow; i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			var irsNo = mySheet.GetCellValue(i, 'BUYER_IRS_NO');
			var kepIrsNo = mySheet.GetCellValue(i, 'KEP_IRS_NO');
			var creditLimitFlag = mySheet.GetCellValue(i, 'CREDIT_LIMIT_FLAG');
			var buyerName = mySheet.GetCellValue(i, 'BUYER_NAME');
			
            if ( mySheet.GetCellValue(i, "GR_DATE") != mySheet.GetCellValue(i, "GR_DATE_OLD") ) {
        		alert(i +"번째 입고일이 변경 되었습니다. 저정 후 생성 바랍니다.");
                return false;            	
            }
            
			if(creditLimitFlag == "Y"){ // 여신통제
				alert(buyerName+" 고객사 기초여신이 등록되어 있지 않거나\n여신이 초과되어 매출 세금계산서를 생성 할 수 없습니다.");
				return false;				
			}
			
			if ( checkedIndex == 0 ) {
				firstKepIrsNo = kepIrsNo;
			} else {
				if ( firstKepIrsNo != kepIrsNo ) {
					alert("KEP 사업자번호가 다른 내역을 함께 생성 할수 없습니다");
					return false;
				}
			}

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

    var issueDate = $("#st_close_month").val();

    for ( i = 1; i <= maxRow; i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			if ( issueDate.substring(0,6) != mySheet.GetCellValue(i, "GR_DATE").substring(0,6) ) {
				alert("입고일과 마감차수가 일치 하지 않습니다");
				return false;
			}
		}
    }

	return true;
}

// 그리드 헤더 전체 체크박스 클릭 이벤트
function mySheet_OnCheckAllEnd(Col, Value) {
// 	alert("Col / Value => " + Col + " / " + Value);

	var totCnt = mySheet.RowCount();

	if ( totCnt < 1 ) return;

	var buyerAmt	= 0;
	var buyerTaxAmt	= 0;

	// 과세 적용대상 금액
	var buyerAmt_taxation = 0 ;
	var tax_type = "";
	
	if ( Value ) {
		for( var i = 1; i <= totCnt; i++ ) {
			buyerAmt = buyerAmt + Number( kepFilterNum( String( mySheet.GetCellValue(i, "GR_AMT") ) ) );
			
			tax_type = mySheet.GetCellValue(i, "TAX_TYPE");
			
			// 과세구분-면세 = 세액 0
			if(tax_type == "11" || tax_type == ""){
				buyerAmt_taxation = buyerAmt_taxation + Number( kepFilterNum( String( mySheet.GetCellValue(i, "GR_AMT") ) ) );
			}
	    }

		buyerTaxAmt = Math.floor( buyerAmt_taxation * 0.1 );

		// 선택한 공급가액, 부가가치세액, 누적공급가액, 누적 과세대상 금액 설정
		$("#buyerAmtSel").html( kepCommaNum(buyerAmt) );
		$("#buyerTaxAmtSel").html( kepCommaNum(buyerTaxAmt) );
		$("#st_totAmt").val(buyerAmt);
		$("#st_totAmt_taxation").val(buyerAmt_taxation);
	} else {
		// 선택한 공급가액, 부가가치세액, 누적공급가액, 누적 과세대상 금액 설정
		$("#buyerAmtSel").html( "0" );
		$("#buyerTaxAmtSel").html( "0" );
		$("#st_totAmt").val( '0' );
		$("#st_totAmt_taxation").val( '0' );
	}
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
// 	alert("Row / Col / Value => " + Row + " / " + Col + " / " + Value);

	if ( Row < 1 ) return;

	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if ( Col == 1 ) {
		setAmt(Row, Value);
	}

	if (column == 'BUYER_IRS_NO' || column == 'BUYER_NAME') { // 사업자등록번호(고객사명) - 고객사 사업자번호 목록
		doPop('buyer_corp_regno');

	} else if (column == 'KEP_IRS_NAME') { // 당사사업장 - KEP 사업자번호 목록
		doPop('kep_corp_regno');
	}

	return;
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
	
	if ( mySheet.ColSaveName(Col) == "KEP_DEPT" ) { // 팀구분
		var value1 = mySheet.GetCellValue(arrRow[0], "KEP_DEPT");
	
// 		if ( kepIsValueNull(value1) ) {
// 			alert("복사할 부서를 입력하여 주십시요.");
// 			return;
// 		}
		
		for ( var idx=0; idx<arrRow.length; idx++ ) {
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
	}else if ( mySheet.ColSaveName(Col) == "GR_DATE" ) { // 입고일
		var value1 = mySheet.GetCellValue(arrRow[0], "GR_DATE");
		for ( var idx=0; idx<arrRow.length; idx++ ) {
			mySheet.SetCellValue(arrRow[idx], "GR_DATE", value1);
		}
	}
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;

	switch (str) {
		case "buyer_single": // 고객사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
		
		case "deptMulti": // 부서 M
			var buyer = $("#st_buyer_code").val();
			if ( kepTrim("st_buyer_code") == '' ) {
				alert("고객사를 선택해 주십시오");
				return;
			}
			
			openSearchPopup("/none/showCommonNoNeDeptChoiceMultiPop.do","?search_opt=2&disable_yn=Y&st_buyer="+buyer,'1000,500,no');
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
			
		case "kep_corp_regno": // KEP 사업자번호 목록
			openSearchPopup("/cmco/showMasterCmCoKEPCorpRegNoListPop.do", "", "500,250,no");
			break;
			
		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=0000007zu&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {
// 	alert("value1 / value2 => " + value1 + " / " + value2);

	// 팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") { // 단일 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
// 		getCloseMonthList(); -- 마감차수 로직 변경 : 2014.07.31

	} else if (popupSel == "agent_single") { // 단일 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);

	} else if (popupSel == "buyer_corp_regno") { // 고객사 사업자번호 목록
		mySheet.SetCellValue(grbRow, 'BUYER_IRS_NO', value1);
		mySheet.SetCellValue(grbRow, 'BUYER_NAME', value2);

	} else if (popupSel == "kep_corp_regno") { // KEP 사업자번호 목록
		mySheet.SetCellValue(grbRow, 'KEP_IRS_NO', value1);
		mySheet.SetCellValue(grbRow, 'KEP_IRS_NAME', value2);

	} else if (popupSel == "deptMulti") {	// 다중 부서
		$("#st_dept_code").val(value1);
		$("#st_dept_name").val(kepMultiName(value2,"@"));
	}

	grbRow="";	// 초기화
}

function fnSetIssueDate(){
	var choiceRadio = $("input[name=st_close_type]:checked").val();
	if ( choiceRadio == "ALL" ) {
		$("#issue_last_day").val( ($("#st_close_month").val()).substring(6,8) );
	} else {
		$("#issue_last_day").val( choiceRadio.substring(2,4) );
	}
}

/*
// ajax 마감차수 조회 호출 함수 -- 마감차수 로직 변경 : 2014.07.31
function getCloseMonthList() {
	var from_date = $("#st_from_date").val();
	var buyer_code = $("#st_buyer_code").val();

	// kepAjaxCall 공통 ajax
	var data = { from_date:from_date, buyer_code:buyer_code };
	kepAjaxCall("/cmcl/getMasterCmClIndividualList_getCloseMonthList.do", data, "getCloseMonthList");
}

// ajax 공통 호출후 성공시 처리 함수 -- 마감차수 로직 변경 : 2014.07.31
function kepAjaxSuccess(pMethod , response) {
	var MSG = response.msg.MSG;

	if ( MSG == "null" || MSG == null ) {
		MSG = "";
	}

	if ( pMethod == "getCloseMonthList" ) {
		$("#grMonth").html( MSG );
	}
}

// ajax 공통 호출후 에러시 처리 함수 -- 마감차수 로직 변경 : 2014.07.31
function kepAjaxError(pMethod , response) {
	if (pMethod == "getCloseMonthList"){
		alert("마감차수 조회 오류 발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.");
	}
}
*/
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>매출 세금계산서 생성(건별)</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
		    <span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
   		</div>
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_dept_no" name="st_dept_no"  value="${sessionInfo.department}">
			<input type="hidden" id="job_kind" name="job_kind" value="">
			<input type="hidden" id="issue_date" name="issue_date" value="">
			<input type="hidden" id="issue_last_day" name="issue_last_day" value="">
			<input type="hidden" id="st_close_revision" name="st_close_revision" value="">
			<input type="hidden" id="st_totAmt" name="st_totAmt"  value="0">
			<input type="hidden" id="st_totAmt_taxation" name="st_totAmt_taxation"  value="0">

            	<table  class="cont_t_list01" >
					<caption>매출 세금계산서 생성(건별)</caption>
					<colgroup>
						<col width="5%" />
						<col width="19%" />
						<col width="5%" />
						<col width="15%" />
						<col width="6%" />
                        <col width="10%" />
						<col width="4%" />
                        <col width="6%" />
						<col width="4%" />
                        <col width="6%" />
                        <col width="5%" />
                        <col width="*" />
					</colgroup>

					<tbody>
						<tr>
							<th><font color="#FF6600">*</font>입고일</th>
							<td>
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:65px; text-align:center;" value="">
								~
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:65px; text-align:center;" value="">
							</td>
							<th>마감차수</th>
							<td colspan="7">
								<input type="radio" class="Noborder"  id="st_close_type_a1" name="st_close_type" value="ALL"  onClick="closeCnt(this.value)" checked>전체(~말일)&nbsp;
								<input type="radio" class="Noborder"  id="st_close_type_a2" name="st_close_type" value="0115" onClick="closeCnt(this.value)">1-1차(1~15일)&nbsp;
								<input type="radio" class="Noborder"  id="st_close_type_a3" name="st_close_type" value="0120" onClick="closeCnt(this.value)">1-2차(1~20일)&nbsp;
								<input type="radio" class="Noborder"  id="st_close_type_a4" name="st_close_type" value="0110" onClick="closeCnt(this.value)">1차(1~10일)&nbsp;
								<input type="radio" class="Noborder"  id="st_close_type_a5" name="st_close_type" value="1120" onClick="closeCnt(this.value)">2차(11~20일)
							</td>
							<th><font color="#FF6600">*</font>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:60%" value="" readonly onclick="javascript:doPop('buyer_single');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
						<tr>
							<th>발주부서</th>
							<td>
								<input type="text" class="input_type_text" name="st_dept_name" id="st_dept_name" style="width:65%" value="" readonly onclick="javascript:doPop('deptMulti');">
								<input type="hidden" name="st_dept_code" id="st_dept_code" style="width:80%" value="">
								<a href="javascript:doPop('deptMulti');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_dept_code','st_dept_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>협력사</th>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:60%" value="" readonly onclick="javascript:doPop('agent_single');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:80%" value="">
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>PO/GR NO</th>
							<td>
								<input type="text" class="input_type_text" id="st_po_no" name="st_po_no" style="width:80%;" value="" onkeydown="kepEnter()">
							</td>
							<th>발주자</th>
							<td>
								<input type="text" class="input_type_text" name="st_purchaser_name" id="st_purchaser_name" style="width:80%" value="" onkeydown="kepEnter()">
							</td>
							<th>요청자</th>
							<td>
								<input type="text" class="input_type_text" name="st_req_user_name" id="st_req_user_name" style="width:80%" value="" onkeydown="kepEnter()">
							</td>
							<th>과세구분</th>
							<td>
								<select id="st_tax_type" name="st_tax_type" style="width:40%"><%= CommonUtil.getCodeComboList("TX17", "ALL", "", "", "", "") %></select>
							</td>
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

		<!--금액영역-->
		<div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" border="1" bgcolor="#FFFFFF">
				<tr>
					<td height="35" align="right" style="font-weight:bold" align="center">
						공급가액:<span id="buyerAmtSel" style="font-weight:bold; color:orange;">0</span>원&nbsp;&nbsp;&nbsp;
						부가가치세액:<span id="buyerTaxAmtSel" style="font-weight:bold; color:orange;">0</span>원
					</td>
					<td height="35" align="right" style="font-weight:bold" align="center">
						총 공급가액:<span id="buyerAmt" style="font-weight:bold; color:orange;">0</span>원&nbsp;&nbsp;&nbsp;
						총 부가가치세액:<span id="buyerTaxAmt" style="font-weight:bold; color:orange;">0</span>원
					</td>
				</tr>
			</table>
		</div>

		<!--버튼영역-->
		<div class="btnArea">
			<span class="fl">
				<span class="btn_05 mr04" ><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
			</span>

			<!-- 마감차수영역 -->
			<span id="grMonth">
				<select id="st_close_month" name="st_close_month"  onChange="fnSetIssueDate();">
					<option value='<%=_closeRevisionDate_1%>'><%=_closeRevisionDate_1.substring(0,4)%>년 <%=_closeRevisionDate_1.substring(4,6)%>월</option>
					<option value='<%=_closeRevisionDate_2%>'><%=_closeRevisionDate_2.substring(0,4)%>년 <%=_closeRevisionDate_2.substring(4,6)%>월</option>
					<option value='<%=_closeRevisionDate_3%>'><%=_closeRevisionDate_3.substring(0,4)%>년 <%=_closeRevisionDate_3.substring(4,6)%>월</option>
					<option value='<%=_closeRevisionDate_4%>' selected><%=_closeRevisionDate_4.substring(0,4)%>년 <%=_closeRevisionDate_4.substring(4,6)%>월</option>
					<option value='<%=_closeRevisionDate_5%>'><%=_closeRevisionDate_5.substring(0,4)%>년 <%=_closeRevisionDate_5.substring(4,6)%>월</option>
					<option value='<%=_closeRevisionDate_6%>'><%=_closeRevisionDate_6.substring(0,4)%>년 <%=_closeRevisionDate_6.substring(4,6)%>월</option>
				</select>
			</span>
			마감&nbsp;&nbsp;

			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
				<span class="btn_02"><a href="javascript:doAction('create');">생성</a></span>
			</span>
		</div>

<!--내용 종료-->
</body>
</html>
