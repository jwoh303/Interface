<%--
**********************************************
* 메뉴 : 회원사관리> 고객사 리포트 현황
* 화면 : 고객사 리포트 현황
* 기능 :
* 프로그램 ID :
* 담당자 :
* 착수일 :
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<style type="text/css">
	table.ui-datepicker-calendar { display:none; }
</style>
<script type="text/javascript">
<%
String org_name = CommonUtil.nvl((String) request.getParameter("org_name"), "");
String searchYn	= CommonUtil.nvl((String)request.getParameter("search_yn"));
%>

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var img_print ="/resources/images/icon_print.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var st_rpst = KepSheetComboData("RPST","SEL");
	var comboInfo = {ComboCode: st_rpst.ComboCode, ComboText: st_rpst.ComboText};
	var st_rpgbtp = KepSheetComboData("RPGBTP","SEL");
	var comboInfo2 = {ComboCode: st_rpgbtp.ComboCode, ComboText: st_rpgbtp.ComboText};
	var st_rpgst = KepSheetComboData("RPGBST","SEL");
	var comboInfo3 = {ComboCode: st_rpgst.ComboCode, ComboText: st_rpgst.ComboText};
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 6};
	initsheet.Cols = [ 
					 { Align:"Center",	SaveName:"sStatus",					Header:"상태|상태",					Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	Width:30,	Edit :true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"|",	SaveName:"SELECTED"}
					,{ Align:"Center",	SaveName:"REPORT_NO",				Header:"리포트번호|리포트번호",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"GROUP_CODE",				Header:"리포트 그룹코드|리포트 그룹코드",	Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"GROUP_NAME",				Header:"리포트 그룹명|리포트 그룹명",	Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"PRINT_IMG",			Header:"리포트\n출력|리포트\n출력",				Type:"Image",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"CLOSE_MONTH",			Header:"리포트\n기준년월|리포트\n기준년월",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"CLOSE_MONTH_M1",		Header:"리포트\n기준년월M1|리포트\n기준년월M1",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"CLOSE_MONTH_M12",		Header:"리포트\n기준년월M12|리포트\n기준년월M12",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"ADD_DATE",			Header:"등록일|등록일",			Type:"Date",		Width:80,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"STATUS",		Header:"진행상태|진행상태",		Type:"Combo",		Width:60,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"TR_YN",			Header:"거래현황|설정",			Type:"Text",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"TR_TYPE",			Header:"거래현황|구분",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"TR_STATUS",			Header:"거래현황|상태",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"TRDT_YN",			Header:"거래현황상세|설정",			Type:"Text",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"TRDT_TYPE",			Header:"거래현황상세|구분",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"TRDT_STATUS",			Header:"거래현황상세|상태",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"CONTRACT_YN",			Header:"계약/신규품목현황|설정",			Type:"Text",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"CONTRACT_TYPE",			Header:"계약/신규품목현황|구분",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"CONTRACT_STATUS",			Header:"계약/신규품목현황|상태",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"PD_YN",			Header:"품목별현황(SG)|설정",			Type:"Text",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"PD_TYPE",			Header:"품목별현황(SG)|구분",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"PD_STATUS",			Header:"품목별현황(SG)|상태",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"BUYER_CA_PD_YN",			Header:"품목별현황(카테고리)|설정",			Type:"Text",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"BUYER_CA_PD_TYPE",			Header:"품목별현황(카테고리)|구분",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"BUYER_CA_PD_STATUS",			Header:"품목별현황(카테고리)|상태",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"RD_YN",			Header:"절감현황(SG)|설정",			Type:"Text",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"RD_TYPE",			Header:"절감현황(SG)|구분",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"RD_STATUS",			Header:"절감현황(SG)|상태",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"BUYER_CA_RD_YN",			Header:"절감현황(카테고리)|설정",			Type:"Text",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"BUYER_CA_RD_TYPE",			Header:"절감현황(카테고리)|구분",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"BUYER_CA_RD_STATUS",			Header:"절감현황(카테고리)|상태",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"DE_CD_YN",			Header:"납기관리(C.D)|설정",			Type:"Text",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"DE_CD_TYPE",			Header:"납기관리(C.D)|구분",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"DE_CD_STATUS",			Header:"납기관리(C.D)|상태",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"DE_WD_YN",			Header:"납기관리(W.D)|설정",			Type:"Text",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"DE_WD_TYPE",			Header:"납기관리(W.D)|구분",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"DE_WD_STATUS",			Header:"납기관리(W.D)|상태",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"RE_CD_YN",			Header:"견적관리(C.D)|설정",			Type:"Text",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"RE_CD_TYPE",			Header:"견적관리(C.D)|구분",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"RE_CD_STATUS",			Header:"견적관리(C.D)|상태",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"RE_WD_YN",			Header:"견적관리(W.D)|설정",			Type:"Text",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"RE_WD_TYPE",			Header:"견적관리(W.D)|구분",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"RE_WD_STATUS",			Header:"견적관리(W.D)|상태",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"EVALUATION_YN",			Header:"총평|설정",			Type:"Text",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"EVALUATION_STATUS",			Header:"총평|상태",			Type:"Combo",		Width:40,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"GROUP_CODE_CNT",			Header:"GROUP_CODE_CNT|GROUP_CODE_CNT",			Type:"Float",		Width:40,	Edit:false,	EditLen:0,		Hidden:true}
	];
	
	IBS_InitSheet2(mySheet, initsheet,pagingMode,5);
	mySheet.SetCountPosition(4);

	//하이퍼링크 설정		
	setLinkCol(mySheet, "TR_YN");
	setLinkCol(mySheet, "TR_TYPE");	
	setLinkCol(mySheet, "TR_STATUS");
	setLinkCol(mySheet, "TRDT_YN");
	setLinkCol(mySheet, "TRDT_TYPE");	
	setLinkCol(mySheet, "TRDT_STATUS");
	setLinkCol(mySheet, "CONTRACT_YN");
	setLinkCol(mySheet, "CONTRACT_TYPE");	
	setLinkCol(mySheet, "CONTRACT_STATUS");
	setLinkCol(mySheet, "PD_YN");
	setLinkCol(mySheet, "PD_TYPE");	
	setLinkCol(mySheet, "PD_STATUS");
	setLinkCol(mySheet, "BUYER_CA_PD_YN");
	setLinkCol(mySheet, "BUYER_CA_PD_TYPE");	
	setLinkCol(mySheet, "BUYER_CA_PD_STATUS");
	setLinkCol(mySheet, "RD_YN");
	setLinkCol(mySheet, "RD_TYPE");	
	setLinkCol(mySheet, "RD_STATUS");
	setLinkCol(mySheet, "BUYER_CA_RD_YN");
	setLinkCol(mySheet, "BUYER_CA_RD_TYPE");	
	setLinkCol(mySheet, "BUYER_CA_RD_STATUS");
	setLinkCol(mySheet, "DE_CD_YN");
	setLinkCol(mySheet, "DE_CD_TYPE");	
	setLinkCol(mySheet, "DE_CD_STATUS");
	setLinkCol(mySheet, "DE_WD_YN");
	setLinkCol(mySheet, "DE_WD_TYPE");	
	setLinkCol(mySheet, "DE_WD_STATUS");
	setLinkCol(mySheet, "RE_CD_YN");
	setLinkCol(mySheet, "RE_CD_TYPE");	
	setLinkCol(mySheet, "RE_CD_STATUS");
	setLinkCol(mySheet, "RE_WD_YN");
	setLinkCol(mySheet, "RE_WD_TYPE");	
	setLinkCol(mySheet, "RE_WD_STATUS");
	setLinkCol(mySheet, "EVALUATION_YN");
	setLinkCol(mySheet, "EVALUATION_STATUS");
	setLinkCol(mySheet, "PRINT_IMG");
	
	mySheet.SetColProperty("STATUS", comboInfo);
	mySheet.SetColProperty("TR_TYPE", comboInfo2);
	mySheet.SetColProperty("TRDT_TYPE", comboInfo2);
	mySheet.SetColProperty("CONTRACT_TYPE", comboInfo2);
	mySheet.SetColProperty("PD_TYPE", comboInfo2);
	mySheet.SetColProperty("BUYER_CA_PD_TYPE", comboInfo2);
	mySheet.SetColProperty("RD_TYPE", comboInfo2);
	mySheet.SetColProperty("BUYER_CA_RD_TYPE", comboInfo2);
	mySheet.SetColProperty("DE_CD_TYPE", comboInfo2);
	mySheet.SetColProperty("DE_WD_TYPE", comboInfo2);
	mySheet.SetColProperty("RE_CD_TYPE", comboInfo2);
	mySheet.SetColProperty("RE_WD_TYPE", comboInfo2);
	mySheet.SetColProperty("TR_STATUS", comboInfo3);
	mySheet.SetColProperty("TRDT_STATUS", comboInfo3);
	mySheet.SetColProperty("CONTRACT_STATUS", comboInfo3);
	mySheet.SetColProperty("PD_STATUS", comboInfo3);
	mySheet.SetColProperty("BUYER_CA_PD_STATUS", comboInfo3);
	mySheet.SetColProperty("RD_STATUS", comboInfo3);
	mySheet.SetColProperty("BUYER_CA_RD_STATUS", comboInfo3);
	mySheet.SetColProperty("DE_CD_STATUS", comboInfo3);
	mySheet.SetColProperty("DE_WD_STATUS", comboInfo3);
	mySheet.SetColProperty("RE_CD_STATUS", comboInfo3);
	mySheet.SetColProperty("RE_WD_STATUS", comboInfo3);
	mySheet.SetColProperty("EVALUATION_STATUS", comboInfo3);

	mySheet.SetImageList(1, img_print);
	
	// 조회조건 초기화
	kepSetCalenderYearMonth("st_from_date");
	kepSetCalenderYearMonth("st_to_date");
	
	// 조회조건 일자 설정
	$("#st_from_date").val(kepToMonthAdd("12","M").substr(0,7));
	$("#st_to_date").val(kepGetNowTimeStr('YYYYMM','/'));
	
	var searchYn = "<%=searchYn%>";
	
	if(searchYn == "Y"){
		doAction("search");
	}
}

var st;
var mt;
// 기능함수
function doAction(str) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		
			var diff = kepGetDateDiff('st_from_date','st_to_date','D');
			if (eval(diff)>372){
				alert("1년 이내 조회만 가능합니다.");
				return;
			}
			
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdct/getMasterMdctBuyerReportManageList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			
			// 조회조건 일자 설정
			$("#st_from_date").val(kepToMonthAdd("12","M").substr(0,7));
			$("#st_to_date").val(kepGetNowTimeStr('YYYYMM','/'));
			break;
		case "singleProc": //개별처리
			var today_date = kepGetNowTimeStr('YYYYMMDD','');
			today_date = today_date.substr(6,2);
			
			if(today_date >= 10){
				alert("1일~10일 외에는 개별처리가 불가합니다.\n관리자에게 문의하시기 바랍니다.");
				return;
			}
		
		    if(confirm("개별처리 하시겠습니까?")) {
		    	kepSave(document.searchCondition, mySheet, "/mdct/saveMasterMdctBuyerReportManageOneProc.do", "SELECTED");
		    }
			break;
		case "save": //재생성
			var selectedGrid = "";
			var arrRow = "";
			selectedGrid = mySheet.FindCheckedRow("SELECTED");
			arrRow = selectedGrid.split("|");
			for (var i=0; i<arrRow.length; i++){
				if (mySheet.GetCellValue(arrRow[i], "STATUS") == "A"){
					alert(arrRow[i]-1+"번째 결재중 상태는 재생성 불가능 합니다.");
					mySheet.SelectCell(arrRow[i], "STATUS");
					return;
				}
			}
		    if(confirm("재생성 하시겠습니까?")) {
		    	kepSave(document.searchCondition, mySheet, "/mdct/saveMasterMdctBuyerReportManageList.do", "SELECTED");
		    }
			break;
		case "appr": //품의
			var selectedGrid = "";
			var arrRow = "";
			selectedGrid = mySheet.FindCheckedRow("SELECTED");
			arrRow = selectedGrid.split("|");
			for (var i=0; i<arrRow.length; i++){
				if (mySheet.GetCellValue(arrRow[i], "STATUS") != "R"){
					alert(arrRow[i]-1+"번째 등록 상태만 품의 가능 합니다.");
					mySheet.SelectCell(arrRow[i], "STATUS");
					return;
				}
				if (mySheet.GetCellValue(arrRow[i], "TR_YN") == "Y" && mySheet.GetCellValue(arrRow[i], "TR_STATUS") == "N"){
					alert(arrRow[i]-1+"번째 거래현황 입력 바랍니다.");
					mySheet.SelectCell(arrRow[i], "TR_YN");
					return;
				}
				if (mySheet.GetCellValue(arrRow[i], "TRDT_YN") == "Y" && mySheet.GetCellValue(arrRow[i], "TRDT_STATUS") == "N"){
					alert(arrRow[i]-1+"번째 거래현황 상세 입력 바랍니다.");
					mySheet.SelectCell(arrRow[i], "TRDT_YN");
					return;
				}
				if (mySheet.GetCellValue(arrRow[i], "CONTRACT_YN") == "Y" && mySheet.GetCellValue(arrRow[i], "CONTRACT_STATUS") == "N"){
					alert(arrRow[i]-1+"번째 계약/신규 품목현황 입력 바랍니다.");
					mySheet.SelectCell(arrRow[i], "CONTRACT_YN");
					return;
				}
				if (mySheet.GetCellValue(arrRow[i], "PD_YN") == "Y" && mySheet.GetCellValue(arrRow[i], "PD_STATUS") == "N"){
					alert(arrRow[i]-1+"번째 품목별 현황(SG) 입력 바랍니다.");
					mySheet.SelectCell(arrRow[i], "PD_YN");
					return;
				}
				if (mySheet.GetCellValue(arrRow[i], "BUYER_CA_PD_YN") == "Y" && mySheet.GetCellValue(arrRow[i], "BUYER_CA_PD_STATUS") == "N"){
					alert(arrRow[i]-1+"번째 품목별 현황(카테고리) 입력 바랍니다.");
					mySheet.SelectCell(arrRow[i], "BUYER_CA_PD_YN");
					return;
				}
				if (mySheet.GetCellValue(arrRow[i], "RD_YN") == "Y" && mySheet.GetCellValue(arrRow[i], "RD_STATUS") == "N"){
					alert(arrRow[i]-1+"번째 절감현황(SG) 입력 바랍니다.");
					mySheet.SelectCell(arrRow[i], "RD_YN");
					return;
				}
				if (mySheet.GetCellValue(arrRow[i], "BUYER_CA_RD_YN") == "Y" && mySheet.GetCellValue(arrRow[i], "BUYER_CA_RD_STATUS") == "N"){
					alert(arrRow[i]-1+"번째 절감현황(카테고리) 입력 바랍니다.");
					mySheet.SelectCell(arrRow[i], "BUYER_CA_RD_YN");
					return;
				}
				if (mySheet.GetCellValue(arrRow[i], "DE_CD_YN") == "Y" && mySheet.GetCellValue(arrRow[i], "DE_CD_STATUS") == "N"){
					alert(arrRow[i]-1+"번째 납기관리(C.D) 입력 바랍니다.");
					mySheet.SelectCell(arrRow[i], "DE_CD_YN");
					return;
				}
				if (mySheet.GetCellValue(arrRow[i], "DE_WD_YN") == "Y" && mySheet.GetCellValue(arrRow[i], "DE_WD_STATUS") == "N"){
					alert(arrRow[i]-1+"번째 납기관리(W.D) 입력 바랍니다.");
					mySheet.SelectCell(arrRow[i], "DE_WD_YN");
					return;
				}
				if (mySheet.GetCellValue(arrRow[i], "RE_CD_YN") == "Y" && mySheet.GetCellValue(arrRow[i], "RE_CD_STATUS") == "N"){
					alert(arrRow[i]-1+"번째 견적관리(C.D) 입력 바랍니다.");
					mySheet.SelectCell(arrRow[i], "RE_CD_YN");
					return;
				}
				if (mySheet.GetCellValue(arrRow[i], "RE_WD_YN") == "Y" && mySheet.GetCellValue(arrRow[i], "RE_WD_STATUS") == "N"){
					alert(arrRow[i]-1+"번째 견적관리(W.D) 입력 바랍니다.");
					mySheet.SelectCell(arrRow[i], "RE_WD_YN");
					return;
				}
				if (mySheet.GetCellValue(arrRow[i], "EVALUATION_YN") == "Y" && mySheet.GetCellValue(arrRow[i], "EVALUATION_STATUS") == "N"){
					alert(arrRow[i]-1+"번째 총평 입력 바랍니다.");
					mySheet.SelectCell(arrRow[i], "EVALUATION_YN");
					return;
				}
				
			}
		    if(confirm("품의 하시겠습니까?")) {
		    	kepSave(document.searchCondition, mySheet, "/mdct/approvalMasterMdctBuyerReportManageList.do", "SELECTED");
		    }
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
	var totRow = mySheet.RowCount();
	//설정이 Y고 상태 미완료일 경우 배경색 노란색 처리.
	for(var i=2; i<=totRow+1;i++){
		if(mySheet.GetCellValue(i, 'TR_STATUS') == "N"){
			mySheet.SetCellBackColor(i,"TR_YN","yellow");
			mySheet.SetCellBackColor(i,"TR_TYPE","yellow");
			mySheet.SetCellBackColor(i,"TR_STATUS","yellow");
		}
		if(mySheet.GetCellValue(i, 'TRDT_STATUS') == "N"){
			mySheet.SetCellBackColor(i,"TRDT_YN","yellow");
			mySheet.SetCellBackColor(i,"TRDT_TYPE","yellow");
			mySheet.SetCellBackColor(i,"TRDT_STATUS","yellow");
		}
		if(mySheet.GetCellValue(i, 'CONTRACT_STATUS') == "N"){
			mySheet.SetCellBackColor(i,"CONTRACT_YN","yellow");
			mySheet.SetCellBackColor(i,"CONTRACT_TYPE","yellow");
			mySheet.SetCellBackColor(i,"CONTRACT_STATUS","yellow");
		}
		if(mySheet.GetCellValue(i, 'PD_STATUS') == "N"){
			mySheet.SetCellBackColor(i,"PD_YN","yellow");
			mySheet.SetCellBackColor(i,"PD_TYPE","yellow");
			mySheet.SetCellBackColor(i,"PD_STATUS","yellow");
		}
		if(mySheet.GetCellValue(i, 'BUYER_CA_PD_STATUS') == "N"){
			mySheet.SetCellBackColor(i,"BUYER_CA_PD_YN","yellow");
			mySheet.SetCellBackColor(i,"BUYER_CA_PD_TYPE","yellow");
			mySheet.SetCellBackColor(i,"BUYER_CA_PD_STATUS","yellow");
		}
		if(mySheet.GetCellValue(i, 'RD_STATUS') == "N"){
			mySheet.SetCellBackColor(i,"RD_YN","yellow");
			mySheet.SetCellBackColor(i,"RD_TYPE","yellow");
			mySheet.SetCellBackColor(i,"RD_STATUS","yellow");
		}
		if(mySheet.GetCellValue(i, 'BUYER_CA_RD_STATUS') == "N"){
			mySheet.SetCellBackColor(i,"BUYER_CA_RD_YN","yellow");
			mySheet.SetCellBackColor(i,"BUYER_CA_RD_TYPE","yellow");
			mySheet.SetCellBackColor(i,"BUYER_CA_RD_STATUS","yellow");
		}
		if(mySheet.GetCellValue(i, 'DE_CD_STATUS') == "N"){
			mySheet.SetCellBackColor(i,"DE_CD_YN","yellow");
			mySheet.SetCellBackColor(i,"DE_CD_TYPE","yellow");
			mySheet.SetCellBackColor(i,"DE_CD_STATUS","yellow");
		}
		if(mySheet.GetCellValue(i, 'DE_WD_STATUS') == "N"){
			mySheet.SetCellBackColor(i,"DE_WD_YN","yellow");
			mySheet.SetCellBackColor(i,"DE_WD_TYPE","yellow");
			mySheet.SetCellBackColor(i,"DE_WD_STATUS","yellow");
		}
		if(mySheet.GetCellValue(i, 'RE_CD_STATUS') == "N"){
			mySheet.SetCellBackColor(i,"RE_CD_YN","yellow");
			mySheet.SetCellBackColor(i,"RE_CD_TYPE","yellow");
			mySheet.SetCellBackColor(i,"RE_CD_STATUS","yellow");
		}
		if(mySheet.GetCellValue(i, 'RE_WD_STATUS') == "N"){
			mySheet.SetCellBackColor(i,"RE_WD_YN","yellow");
			mySheet.SetCellBackColor(i,"RE_WD_TYPE","yellow");
			mySheet.SetCellBackColor(i,"RE_WD_STATUS","yellow");
		}
		if(mySheet.GetCellValue(i, 'EVALUATION_STATUS') == "N"){
			mySheet.SetCellBackColor(i,"EVALUATION_YN","yellow");
			mySheet.SetCellBackColor(i,"EVALUATION_STATUS","yellow");
		}
	}
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdctBuyerReportManageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val) {
	popupSel = str;
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if(Row < 2) return; // 헤더 병합으로 2번째 줄부터 유효한 클릭	
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());	
	grbRow = Row;		//현재 Row를 전역변수에 셋팅	
	if(column == "TR_YN"||column == "TR_TYPE"||column == "TR_STATUS") {//거래현황
		if(mySheet.GetCellValue(Row,"TR_YN") == "N"){
			alert("미사용 항목 입니다.");
			return;
		}
		var st_group_gbn = "";
		//그룹코드매핑이 
		if(mySheet.GetCellValue(Row,"GROUP_CODE_CNT") > 1){
			st_group_gbn = "CMPY";
		}else{
			st_group_gbn = "DEPT";
		}
		var st_status_gbn = mySheet.GetCellValue(Row,"TR_TYPE");
		var st_form_name = "reportSalesForm";
		var st_popup_type = "TR";
		var st_popup_url = "/mdct/showMasterMdCtReportSalesPop.do"; // URL 경로
		var st_popup_param = "st_popup_type@@"+st_popup_type+"^||^"+"st_status_gbn@@"+st_status_gbn+"^||^"+"st_report_no@@"+mySheet.GetCellValue(Row,"REPORT_NO")+"^||^"+"st_group_code@@"+mySheet.GetCellValue(Row,"GROUP_CODE")+"^||^"+"st_group_nm@@"+mySheet.GetCellValue(Row,"GROUP_NAME")+"^||^"+"st_close_month@@"+mySheet.GetCellValue(Row,"CLOSE_MONTH")+"^||^"+"st_group_gbn@@"+st_group_gbn; 
		var st_popup_option = "700,600,no";	
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}else if(column == "TRDT_YN"||column == "TRDT_TYPE"||column == "TRDT_STATUS") {//거래현황상세
		if(mySheet.GetCellValue(Row,"TRDT_YN") == "N"){
			alert("미사용 항목 입니다.");
			return;
		}
		var st_group_gbn = "";
		//그룹코드매핑이 
		if(mySheet.GetCellValue(Row,"GROUP_CODE_CNT") > 1){
			st_group_gbn = "CMPY";
		}else{
			st_group_gbn = "DEPT";
		}
		var st_status_gbn = mySheet.GetCellValue(Row,"TRDT_TYPE");
		var st_form_name = "reportSalesDetailForm";
		var st_popup_type = "TRDT";
		var st_popup_url = "/mdct/showMasterMdCtReportSalesPop.do"; // URL 경로
		var st_popup_param = "st_popup_type@@"+st_popup_type+"^||^"+"st_status_gbn@@"+st_status_gbn+"^||^"+"st_report_no@@"+mySheet.GetCellValue(Row,"REPORT_NO")+"^||^"+"st_group_code@@"+mySheet.GetCellValue(Row,"GROUP_CODE")+"^||^"+"st_group_nm@@"+mySheet.GetCellValue(Row,"GROUP_NAME")+"^||^"+"st_close_month@@"+mySheet.GetCellValue(Row,"CLOSE_MONTH")+"^||^"+"st_group_gbn@@"+st_group_gbn; 
		var st_popup_option = "700,600,no";	
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}else if(column == "CONTRACT_YN"||column == "CONTRACT_TYPE"||column == "CONTRACT_STATUS") {//계약신규
		if(mySheet.GetCellValue(Row,"CONTRACT_YN") == "N"){
			alert("미사용 항목 입니다.");
			return;
		}
		var st_status_gbn = mySheet.GetCellValue(Row,"CONTRACT_TYPE");
		var st_form_name = "reportSalesNewForm";
		var st_popup_url = "/mdct/showMasterMdCtReportSalesNewPop.do"; // URL 경로
		var st_popup_param = "st_status_gbn@@"+st_status_gbn+"^||^"+"st_report_no@@"+mySheet.GetCellValue(Row,"REPORT_NO")+"^||^"+"st_group_code@@"+mySheet.GetCellValue(Row,"GROUP_CODE")+"^||^"+"st_group_nm@@"+mySheet.GetCellValue(Row,"GROUP_NAME")+"^||^"+"st_close_month@@"+mySheet.GetCellValue(Row,"CLOSE_MONTH")+"^||^"+"st_group_gbn@@"+st_group_gbn; 
		var st_popup_option = "700,600,no";	
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}else if(column == "PD_YN"||column == "PD_TYPE"||column == "PD_STATUS") {//SG 품목별 현황
		if(mySheet.GetCellValue(Row,"PD_YN") == "N"){
			alert("미사용 항목 입니다.");
			return;
		}
		var st_status_gbn = mySheet.GetCellValue(Row,"PD_TYPE");
		var st_form_name = "reportSalesSgForm";
		var st_popup_type = "PD";
		var st_popup_url = "/mdct/showMasterMdCtReportSalesSgPop.do"; // URL 경로
		var st_popup_param = "st_popup_type@@"+st_popup_type+"^||^"+"st_status_gbn@@"+st_status_gbn+"^||^"+"st_report_no@@"+mySheet.GetCellValue(Row,"REPORT_NO")+"^||^"+"st_group_code@@"+mySheet.GetCellValue(Row,"GROUP_CODE")+"^||^"+"st_group_nm@@"+mySheet.GetCellValue(Row,"GROUP_NAME")+"^||^"+"st_close_month@@"+mySheet.GetCellValue(Row,"CLOSE_MONTH"); 
		var st_popup_option = "700,600,no";	
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}else if(column == "RD_YN"||column == "RD_TYPE"||column == "RD_STATUS") {//SG 절감현황
		if(mySheet.GetCellValue(Row,"RD_YN") == "N"){
			alert("미사용 항목 입니다.");
			return;
		}
		var st_status_gbn = mySheet.GetCellValue(Row,"RD_TYPE");
		var st_form_name = "reportSalesRdSgForm";
		var st_popup_type = "RD";
		var st_popup_url = "/mdct/showMasterMdCtReportSalesSgPop.do"; // URL 경로
		var st_popup_param = "st_popup_type@@"+st_popup_type+"^||^"+"st_status_gbn@@"+st_status_gbn+"^||^"+"st_report_no@@"+mySheet.GetCellValue(Row,"REPORT_NO")+"^||^"+"st_group_code@@"+mySheet.GetCellValue(Row,"GROUP_CODE")+"^||^"+"st_group_nm@@"+mySheet.GetCellValue(Row,"GROUP_NAME")+"^||^"+"st_close_month@@"+mySheet.GetCellValue(Row,"CLOSE_MONTH"); 
		var st_popup_option = "700,600,no";	
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}else if(column == "BUYER_CA_PD_YN"||column == "BUYER_CA_PD_TYPE"||column == "BUYER_CA_PD_STATUS") {//카테고리 품목별 현황
		if(mySheet.GetCellValue(Row,"BUYER_CA_PD_YN") == "N"){
			alert("미사용 항목 입니다.");
			return;
		}
		var st_status_gbn = mySheet.GetCellValue(Row,"BUYER_CA_PD_TYPE");
		var st_form_name = "reportSalesCaPdForm";
		var st_popup_type = "PD";
		var st_popup_url = "/mdct/showMasterMdCtReportSalesCaPop.do"; // URL 경로
		var st_popup_param = "st_popup_type@@"+st_popup_type+"^||^"+"st_status_gbn@@"+st_status_gbn+"^||^"+"st_report_no@@"+mySheet.GetCellValue(Row,"REPORT_NO")+"^||^"+"st_group_code@@"+mySheet.GetCellValue(Row,"GROUP_CODE")+"^||^"+"st_group_nm@@"+mySheet.GetCellValue(Row,"GROUP_NAME")+"^||^"+"st_close_month@@"+mySheet.GetCellValue(Row,"CLOSE_MONTH"); 
		var st_popup_option = "700,600,no";	
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}else if(column == "BUYER_CA_RD_YN"||column == "BUYER_CA_RD_TYPE"||column == "BUYER_CA_RD_STATUS") {//카테고리 절감 현황
		if(mySheet.GetCellValue(Row,"BUYER_CA_RD_YN") == "N"){
			alert("미사용 항목 입니다.");
			return;
		}
		var st_status_gbn = mySheet.GetCellValue(Row,"BUYER_CA_RD_TYPE");
		var st_form_name = "reportSalesCaRdForm";
		var st_popup_type = "RD";
		var st_popup_url = "/mdct/showMasterMdCtReportSalesCaPop.do"; // URL 경로
		var st_popup_param = "st_popup_type@@"+st_popup_type+"^||^"+"st_status_gbn@@"+st_status_gbn+"^||^"+"st_report_no@@"+mySheet.GetCellValue(Row,"REPORT_NO")+"^||^"+"st_group_code@@"+mySheet.GetCellValue(Row,"GROUP_CODE")+"^||^"+"st_group_nm@@"+mySheet.GetCellValue(Row,"GROUP_NAME")+"^||^"+"st_close_month@@"+mySheet.GetCellValue(Row,"CLOSE_MONTH"); 
		var st_popup_option = "700,600,no";	
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}else if(column == "DE_CD_YN"||column == "DE_CD_TYPE"||column == "DE_CD_STATUS") {//납기관리 CD
		if(mySheet.GetCellValue(Row,"DE_CD_YN") == "N"){
			alert("미사용 항목 입니다.");
			return;
		}
		var st_status_gbn = mySheet.GetCellValue(Row,"DE_CD_TYPE");
		var st_form_name = "reportSalesDeCdForm";
		var st_popup_type = "DECD";
		var st_popup_url = "/mdct/showMasterMdCtReportSalesDeRePop.do"; // URL 경로
		var st_popup_param = "st_popup_type@@"+st_popup_type+"^||^"+"st_status_gbn@@"+st_status_gbn+"^||^"+"st_report_no@@"+mySheet.GetCellValue(Row,"REPORT_NO")+"^||^"+"st_group_code@@"+mySheet.GetCellValue(Row,"GROUP_CODE")+"^||^"+"st_group_nm@@"+mySheet.GetCellValue(Row,"GROUP_NAME")+"^||^"+"st_close_month@@"+mySheet.GetCellValue(Row,"CLOSE_MONTH"); 
		var st_popup_option = "700,600,no";	
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}else if(column == "DE_WD_YN"||column == "DE_WD_TYPE"||column == "DE_WD_STATUS") {//납기관리 WD
		if(mySheet.GetCellValue(Row,"DE_WD_YN") == "N"){
			alert("미사용 항목 입니다.");
			return;
		}
		var st_status_gbn = mySheet.GetCellValue(Row,"DE_WD_TYPE");
		var st_form_name = "reportSalesDeWdForm";
		var st_popup_type = "DEWD";
		var st_popup_url = "/mdct/showMasterMdCtReportSalesDeRePop.do"; // URL 경로
		var st_popup_param = "st_popup_type@@"+st_popup_type+"^||^"+"st_status_gbn@@"+st_status_gbn+"^||^"+"st_report_no@@"+mySheet.GetCellValue(Row,"REPORT_NO")+"^||^"+"st_group_code@@"+mySheet.GetCellValue(Row,"GROUP_CODE")+"^||^"+"st_group_nm@@"+mySheet.GetCellValue(Row,"GROUP_NAME")+"^||^"+"st_close_month@@"+mySheet.GetCellValue(Row,"CLOSE_MONTH"); 
		var st_popup_option = "700,600,no";	
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}else if(column == "RE_CD_YN"||column == "RE_CD_TYPE"||column == "RE_CD_STATUS") {//견적관리 CD
		if(mySheet.GetCellValue(Row,"RE_CD_YN") == "N"){
			alert("미사용 항목 입니다.");
			return;
		}
		var st_status_gbn = mySheet.GetCellValue(Row,"RE_CD_TYPE");
		var st_form_name = "reportSalesReCdForm";
		var st_popup_type = "RECD";
		var st_popup_url = "/mdct/showMasterMdCtReportSalesDeRePop.do"; // URL 경로
		var st_popup_param = "st_popup_type@@"+st_popup_type+"^||^"+"st_status_gbn@@"+st_status_gbn+"^||^"+"st_report_no@@"+mySheet.GetCellValue(Row,"REPORT_NO")+"^||^"+"st_group_code@@"+mySheet.GetCellValue(Row,"GROUP_CODE")+"^||^"+"st_group_nm@@"+mySheet.GetCellValue(Row,"GROUP_NAME")+"^||^"+"st_close_month@@"+mySheet.GetCellValue(Row,"CLOSE_MONTH"); 
		var st_popup_option = "700,600,no";	
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}else if(column == "RE_WD_YN"||column == "RE_WD_TYPE"||column == "RE_WD_STATUS") {//견적관리 WD
		if(mySheet.GetCellValue(Row,"RE_WD_YN") == "N"){
			alert("미사용 항목 입니다.");
			return;
		}
		var st_status_gbn = mySheet.GetCellValue(Row,"RE_WD_TYPE");
		var st_form_name = "reportSalesReWdForm";
		var st_popup_type = "REWD";
		var st_popup_url = "/mdct/showMasterMdCtReportSalesDeRePop.do"; // URL 경로
		var st_popup_param = "st_popup_type@@"+st_popup_type+"^||^"+"st_status_gbn@@"+st_status_gbn+"^||^"+"st_report_no@@"+mySheet.GetCellValue(Row,"REPORT_NO")+"^||^"+"st_group_code@@"+mySheet.GetCellValue(Row,"GROUP_CODE")+"^||^"+"st_group_nm@@"+mySheet.GetCellValue(Row,"GROUP_NAME")+"^||^"+"st_close_month@@"+mySheet.GetCellValue(Row,"CLOSE_MONTH"); 
		var st_popup_option = "700,600,no";	
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}else if(column == "EVALUATION_YN"||column == "EVALUATION_STATUS") {// 총평
		if(mySheet.GetCellValue(Row,"EVALUATION_YN") == "N"){
			alert("미사용 항목 입니다.");
			return;
		}
		var st_form_name = "reportSalesEvaluationForm";
		var st_popup_url = "/mdct/getMasterMdCtReportSalesEvaluationPop.do"; // URL 경로
		var st_popup_param = "st_report_no@@"+mySheet.GetCellValue(Row,"REPORT_NO"); 
		var st_popup_option = "700,600,no";	
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}else if(column == "PRINT_IMG") {//출력물
		if (mySheet.GetCellValue(Row, "TR_YN") == "Y" && mySheet.GetCellValue(Row, "TR_STATUS") == "N"){
			alert("거래현황 입력 바랍니다.");
			mySheet.SelectCell(Row, "TR_YN");
			return;
		}
		if (mySheet.GetCellValue(Row, "TRDT_YN") == "Y" && mySheet.GetCellValue(Row, "TRDT_STATUS") == "N"){
			alert("거래현황상세 입력 바랍니다.");
			mySheet.SelectCell(Row, "TRDT_YN");
			return;
		}
		if (mySheet.GetCellValue(Row, "CONTRACT_YN") == "Y" && mySheet.GetCellValue(Row, "CONTRACT_STATUS") == "N"){
			alert("계약/신규 품목현황 입력 바랍니다.");
			mySheet.SelectCell(Row, "CONTRACT_YN");
			return;
		}
		if (mySheet.GetCellValue(Row, "PD_YN") == "Y" && mySheet.GetCellValue(Row, "PD_STATUS") == "N"){
			alert("품목별현황(SG) 입력 바랍니다.");
			mySheet.SelectCell(Row, "PD_YN");
			return;
		}
		if (mySheet.GetCellValue(Row, "BUYER_CA_PD_YN") == "Y" && mySheet.GetCellValue(Row, "BUYER_CA_PD_STATUS") == "N"){
			alert("품목별현황(카테고리) 입력 바랍니다.");
			mySheet.SelectCell(Row, "BUYER_CA_PD_YN");
			return;
		}
		if (mySheet.GetCellValue(Row, "RD_YN") == "Y" && mySheet.GetCellValue(Row, "RD_STATUS") == "N"){
			alert("절감현황(SG) 입력 바랍니다.");
			mySheet.SelectCell(Row, "RD_YN");
			return;
		}
		if (mySheet.GetCellValue(Row, "BUYER_CA_RD_YN") == "Y" && mySheet.GetCellValue(Row, "BUYER_CA_RD_STATUS") == "N"){
			alert("절감현황(카테고리) 입력 바랍니다.");
			mySheet.SelectCell(Row, "BUYER_CA_RD_YN");
			return;
		}
		if (mySheet.GetCellValue(Row, "DE_CD_YN") == "Y" && mySheet.GetCellValue(Row, "DE_CD_STATUS") == "N"){
			alert("납기관리(C.D) 입력 바랍니다.");
			mySheet.SelectCell(Row, "DE_CD_YN");
			return;
		}
		if (mySheet.GetCellValue(Row, "DE_WD_YN") == "Y" && mySheet.GetCellValue(Row, "DE_WD_STATUS") == "N"){
			alert("납기관리(W.D) 입력 바랍니다.");
			mySheet.SelectCell(Row, "DE_WD_YN");
			return;
		}
		if (mySheet.GetCellValue(Row, "RE_CD_YN") == "Y" && mySheet.GetCellValue(Row, "RE_CD_STATUS") == "N"){
			alert("견적관리(C.D) 입력 바랍니다.");
			mySheet.SelectCell(Row, "RE_CD_YN");
			return;
		}
		if (mySheet.GetCellValue(Row, "RE_WD_YN") == "Y" && mySheet.GetCellValue(Row, "RE_WD_STATUS") == "N"){
			alert("견적관리(W.D) 입력 바랍니다.");
			mySheet.SelectCell(Row, "RE_WD_YN");
			return;
		}
		if (mySheet.GetCellValue(Row, "EVALUATION_YN") == "Y" && mySheet.GetCellValue(Row, "EVALUATION_STATUS") == "N"){
			alert("총평 입력 바랍니다.");
			mySheet.SelectCell(Row, "EVALUATION_YN");
			return;
		}
		
		var st_report_no = mySheet.GetCellValue(Row,"REPORT_NO");
		var st_group_code = mySheet.GetCellValue(Row,"GROUP_CODE");
		var st_status = mySheet.GetCellValue(Row,"STATUS");
		var st_close_month = mySheet.GetCellValue(Row,"CLOSE_MONTH");
		var st_close_month_M1 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M1");
		var st_close_month_M12 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M12");
		
		var st_tr_yn = mySheet.GetCellValue(Row,"TR_YN"); // 거래현황
		var st_trdt_yn = mySheet.GetCellValue(Row,"TRDT_YN"); // 거래현황상세
		var st_new_contract_yn = mySheet.GetCellValue(Row,"CONTRACT_YN"); // 계약_신규품목현황
		var st_pd_yn = mySheet.GetCellValue(Row,"PD_YN"); // 품목별현황_SG
		var st_buyer_ca_pd_yn = mySheet.GetCellValue(Row,"BUYER_CA_PD_YN"); // 품목별현황_카테고리
		var st_rd_yn = mySheet.GetCellValue(Row,"RD_YN"); // 절감현황_SG
		var st_buyer_ca_rd_yn = mySheet.GetCellValue(Row,"BUYER_CA_RD_YN"); // 절감현황_카테고리
		var st_de_cd_yn = mySheet.GetCellValue(Row,"DE_CD_YN"); // 납기관리_CD
		var st_de_wd_yn = mySheet.GetCellValue(Row,"DE_WD_YN"); // 납기관리_WD
		var st_re_cd_yn = mySheet.GetCellValue(Row,"RE_CD_YN"); // 견적관리_CD
		var st_re_wd_yn = mySheet.GetCellValue(Row,"RE_WD_YN"); // 견적관리_WD
		var st_evaluation_yn = mySheet.GetCellValue(Row,"EVALUATION_YN"); // 총평
		
		var param = "";
		param = "["+st_report_no+"]["+st_group_code+"]["+st_close_month+"]["+st_close_month_M1+"]["+st_close_month_M12+"]["+st_tr_yn+"]["+st_trdt_yn+"]["+st_new_contract_yn+"]["+st_pd_yn+"]["+st_buyer_ca_pd_yn+"]["+st_rd_yn+"]["+st_buyer_ca_rd_yn+"]["+st_de_cd_yn+"]["+st_de_wd_yn+"]["+st_re_cd_yn+"]["+st_re_wd_yn+"]["+st_evaluation_yn+"]";

		//alert(param);
		
		var params = [];
		var url = "/coco/showChartViewer.do";
		params.push({ key: "fileName", value: "CT_01_B_001_01" });
		params.push({ key: "param", value: param });
		
		if(st_status != "C"){ // 등록(R), 결재중(A) 인 경우. N = 문서프로그램 연결 아이콘 숨김, 기본 Y로 넘김
			params.push({ key: "download_flag", value: "N" });	
		}
		
		OpenReportPost(url, "POP", params);
		return;
	}
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	var msgType = msg.substring(0,2);
	if (msgType == "PM"){	// 품의 버튼 후 처리 
		openSearchPopup('/common/approval/buyerCommonApprovalPop.do','?DOC_TYPE=RPT&BIZ_DOCU_NO='+msg, "1000,500,no");
	}else{
		if (msg != "") {
			alert(msg);
		}
	}
	if (code > 0) {
		//저장 성공시 재조회
		doAction("search");
	}
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction("search");
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	grbRow="";	//초기화
}
function kepApprovalReturn(ERR,GW_NO){ 
   	doAction('search');
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>고객사 리포트 현황</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition" name="searchCondition" method="post" onsubmit="return false;" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
			
            	<table  class="cont_t_list01" >
					<caption>고객사 리포트 현황</caption>
					<colgroup>
						<col width="10%" />
						<col width="23%" />
						<col width="15%" />
						<col width="35%" />
						<col width="6%" />
                        <col width="10%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th><font color="#FF6600">* </font>리포트 기준년월</th>
							<td>
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:90px; text-align:center;" value=""> -
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:90px; text-align:center;" value="">
							</td>
							<td>리포트 그룹코드/그룹명</td>
							<td>
								<input type="text" class="input_type_text" name="st_group_code" id="st_group_code" style="width:30%" value=""  onkeydown="kepEnter();" />
								/
								<input type="text" class="input_type_text" name="st_group_nm" id="st_group_nm" style="width:50%" value=""  onkeydown="kepEnter();" />
							</td>
							<td>진행상태</td>
							<td>
								<select id="st_contract_status" name="st_contract_status" style="width:100px;">
									<script>kepAjaxCommonComboDataValue('st_contract_status', 'RPST', 'ALL', '');</script>
								</select>
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
				createIBSheet("mySheet", "100%", "400px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
	    <!--버튼영역-->
	    <p class="btnArea mt10 mb05">
	    	<span class="fl">  					
				* 노란색 표시 컬럼 : 가공 리포트 내용 미입력 건<br>
			</span>
			<span class="fr">
				<span class="btn_03"><a href="javascript:doAction('singleProc');">개별처리</a></span>
				<span class="btn_03"><a href="javascript:doAction('save');">재생성</a></span>
				<span class="btn_02"><a href="javascript:doAction('appr');">품의</a></span>	
			</span>
			<br>
			<span class="fl">
				<font color=RED>* 리포트는 매월 10일 자동 생성(자동생성일 이후 그룹핑한 고객사는 익월 10일 리포트 생성) 자동생성일 이전 리포트 필요 시 개별처리 클릭</font>
			</span>
 		</p>
<!--내용 종료-->	                 
</body>
</html>
