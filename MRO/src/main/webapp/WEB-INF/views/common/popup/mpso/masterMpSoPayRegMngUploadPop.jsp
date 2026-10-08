<%--
**********************************************
* 메뉴 : 주문관리 > 지급이슈 등록 및 조회  등록 팝업
* 화면 : 지급이슈 등록 및 조회
* 기능 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ page import="java.text.SimpleDateFormat"%> 
<%@ page import="java.util.Date"%> 
<%@ page import="java.util.Locale"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<style type="text/css">
<!--
table.ui-datepicker-calendar {
	display: none;
}
-->
</style>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<%
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_user_id = "";
if (sessionInfo != null){
	st_user_id = sessionInfo.getUserId();
}
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var zipOn="/resources/images/btn_search03.gif";
var calendar = "/resources/images/btn_calendar.gif";
var months = ["01","02","03","04","05","06","07","08","09","10","11","12"];
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [					 
					 { Align:"Center",	SaveName:"SELECTED",			Header:"|",				Type:"DummyCheck",	Width:30,	Edit:true,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"PO_NO",					Header:"발주번호|발주번호",		Type:"Text",		Width:90,	Edit:false,	EditLen:100,BackColor:"${notnullColor}"}
					,{ Align:"Center",	SaveName:"PO_SEQ",					Header:"발주항번|발주항번",	Hidden:true,	Type:"Text"}
					,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",					Header:"품목코드|품목코드",		Type:"Text",	Width:100,	Edit:false,	EditLen:100 ,BackColor:"${notnullColor}"}
					,{ Align:"Center",	SaveName:"BUYER_ITEM_NO_IMG",	Header:"품목코드|품목코드",			Type:"Image",	 Width:30}
					,{ Align:"Center",	SaveName:"AGENT_NAME",					Header:"협력사명|협력사명",			Type:"Text",	Edit:false,	Width:110}
					,{ Align:"Center",	SaveName:"AGENT_IRS_NO",					Header:"사업자번호(S)|사업자번호(S)",		Type:"Text",Edit:false,		Width:100}
					,{ Align:"Center",	SaveName:"BUYER",					Header:"고객사|고객사",	Type:"Text",	Hidden:true,	Edit:false, Width:100}
					,{ Align:"Center",	SaveName:"BUYER_NAME",					Header:"고객사명|고객사명",	Type:"Text",		Edit:false, Width:110}
					,{ Align:"Center",	SaveName:"BUYER_IRS_NO",					Header:"사업자번호(B)|사업자번호(B)",		Type:"Text",	Edit:false, Width:100}
					,{ Align:"Center",	SaveName:"SCHD_CLOSE_MONTH",	Width:60,		Header:"마감예정월|마감예정월",	KeyField:true,	Edit:false,	Type:"Text" ,BackColor:"${notnullColor}"}
					,{ Align:"Center",	SaveName:"SCHD_CLOSE_MONTH_IMG",	Width:30,		Header:"마감예정월|마감예정월",		Type:"Image" ,BackColor:"${notnullColor}"}
					,{ Align:"Center",	SaveName:"PAY_REG_TYPE",				Header:"지급이슈금액|지급이슈금액", 	Type:"Text",	Hidden:true,	Edit:false}
					,{ Align:"Right",	SaveName:"PAY_AMT1", 					Header:"지급이슈금액|선지급금",	Format:"${priceFormat}",	Type:"Float",		Width:80 ,BackColor:"${notnullColor}"}
					,{ Align:"Right",	SaveName:"PAY_AMT2",					Header:"지급이슈금액|지체상금",	Format:"${priceFormat}",	Type:"Float",		Width:80,		EditLen:100,	Hidden:false ,BackColor:"${notnullColor}"}
					,{ Align:"Right",	SaveName:"PAY_AMT3",					Header:"지급이슈금액|물류비",	 Format:"${priceFormat}",	Type:"Float",		Width:80,	EditLen:100,	Hidden:false,BackColor:"${notnullColor}"}
					,{ Align:"Right",	SaveName:"TAX_AMT",					Header:"지급이슈금액|물류비 확정세액",	 Format:"${priceFormat}",	Type:"Float",		Width:100,	EditLen:100,	Hidden:false,BackColor:"${notnullColor}"}
					,{ Align:"Left",	SaveName:"REMARK",					Header:"등록사유|등록사유",	Type:"Text",		Width:250, KeyField:true,	EditLen:100,	Hidden:false,BackColor:"${notnullColor}"}
					,{ Align:"Center",	SaveName:"ADD_USER_ID",					Header:"등록자|등록자",	Type:"Text",	Hidden:true}
					
					
					
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetHtmlHeaderValue(0, "PAY_AMT1", "<span class='GMKeyfield'>&nbsp;</span>지급이슈금액");
	mySheet.SetHtmlHeaderValue(0, "PAY_AMT2", "<span class='GMKeyfield'>&nbsp;</span>지급이슈금액");
	mySheet.SetHtmlHeaderValue(0, "PAY_AMT3", "<span class='GMKeyfield'>&nbsp;</span>지급이슈금액");
	mySheet.SetHtmlHeaderValue(0, "TAX_AMT", "<span class='GMKeyfield'>&nbsp;</span>지급이슈금액");


	//하이퍼링크 설정	
	setLinkCol(mySheet, "BUYER_ITEM_NO_IMG");	
	setLinkCol(mySheet, "SCHD_CLOSE_MONTH_IMG");
	//검색 이미지설정
	mySheet.SetImageList(1, zipOn);
	mySheet.SetImageList(2, calendar);	
	doAction('search');
	
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	
	// 선택된 항목 유무 체크
	if (str =="del"  && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mpso/getMasterMpSoPayRegMngUploadList.do" , pagingMode );
			break;			
		case "excelup":	// 엑셀업로드
			mySheet.RemoveAll();			
			var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"|2|3|||||1|||4||5|6|6|6|7|8|"};
			mySheet.LoadExcel(params);
			break;		
		case "save": // 등록
			if (checkSubmit()) {
				kepSave(document.searchCondition, mySheet, "/mpso/saveMasterMpSoPayRegMngUploadList.do", "SELECTED");
			}
			break;		
		case "add": // 추가
			var rows = mySheet.DataInsert(-1);
			mySheet.SetCellValue(rows, "SELECTED", "1");
			 <%if(st_user_id.equals("KEP2259018")) { // 자금팀 김연주 프로%>
				 mySheet.SetCellEditable(rows, "PO_NO", 1);
				 mySheet.SetCellEditable(rows, "BUYER_ITEM_NO", 1);
				 mySheet.SetCellEditable(rows, "AGENT_NAME", 1);
				 mySheet.SetCellEditable(rows, "AGENT_IRS_NO", 1);
				 mySheet.SetCellEditable(rows, "BUYER_NAME", 1);
				 mySheet.SetCellEditable(rows, "BUYER_IRS_NO", 1);				 				 
			 <%} else {%>
			 mySheet.SetCellValue(rows, "BUYER_ITEM_NO_IMG", zipOn);
			 <%}%>			
			mySheet.SetCellValue(rows, "SCHD_CLOSE_MONTH_IMG", calendar);
			break;
			
		case "del":	// 삭제		
			
			if (!confirm("선택되어 있는 행은 모두 삭제 됩니다.\n삭제하시겠습니까?")) {
				return;
			}
			kepSave(document.searchCondition, mySheet, "/mpso/deleteMasterMpSoPayRegMngUploadList.do", "SELECTED");
			break;		
	}
}



// 팝업함수호출
function doPop(str, val) {
	popupSel = str;
	
	switch (str) {
		case "po_search":
			openSearchPopup("/mpso/showMasterMpSoPayRegMngUploadPoSearchPop.do", "", "900,350,no");
			break;
		case "calendarHour":
			kepCalendarOpenPopup();
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'BUYER_ITEM_NO_IMG') { // 품목코드
		<%if(st_user_id.equals("KEP2259018")) { // 자금팀 김연주 프로%>
		<%} else {%>
				doPop("po_search");
		<%}%>
		
	} else if (column == 'SCHD_CLOSE_MONTH_IMG') { // 마감 예정일
		doPop('calendarHour');
	} else if (column == 'MAIN_CLERK'||column == 'PRIORITY') {//BM메인여부 지정시 체크박스 자동 체크
		mySheet.SetCellValue(Row,"SELECTED","1");
	} 
	return;
}

function mySheet_OnChange(Row, Col, Value) {

	if ( Row  < 1) return;

	
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	alert(msg);
	loader_obj("N");	
	if(!checkedSession(stCode)){return;}
	if ( msg != "저장에 실패하였습니다." ) {		
		doAction('search');
	}
	if ( msg == "저장완료.") {
		this.close();
		opener.doAction('search');
	}
	if ( msg == "삭제완료.") {		
		doAction('search');
	}
	
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7, value8) {
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "po_search") { // 발주정보		
		mySheet.SetCellValue(grbRow,"BUYER", value1);
		mySheet.SetCellValue(grbRow,"PO_NO", value2);
		mySheet.SetCellValue(grbRow,"PO_SEQ", value3);
		mySheet.SetCellValue(grbRow,"BUYER_ITEM_NO", value4);
		mySheet.SetCellValue(grbRow,"AGENT_NAME", value5);
		mySheet.SetCellValue(grbRow,"AGENT_IRS_NO", value6);
		mySheet.SetCellValue(grbRow,"BUYER_NAME", value7);
		mySheet.SetCellValue(grbRow,"BUYER_IRS_NO", value8);
	}

	grbRow="";	//초기화
}

//콜백함수(파일명은 모두 동일)
function setPopupCalendar(year,month,day) {
	
	if(popupSel == "calendarHour") { // 마감예정일
		mySheet.SetCellValue(grbRow,"SCHD_CLOSE_MONTH", year+"/"+month);
	}

	grbRow="";	//초기화
}


function checkSubmit() {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	if (selectedGrid.length == 0) {
		alert("선택하신 행이 없습니다.");
		return;
	}
	
		for(var i=0; i< arrRow.length; i++){			
			mySheet.SetCellValue(arrRow[i],"ADD_USER_ID", '<%=st_user_id%>');
			var PO_NO = mySheet.GetCellValue(arrRow[i], "PO_NO");
			var BUYER_ITEM_NO = mySheet.GetCellValue(arrRow[i], "BUYER_ITEM_NO");
			var AGENT_NAME = mySheet.GetCellValue(arrRow[i], "AGENT_NAME");
			var AGENT_IRS_NO = mySheet.GetCellValue(arrRow[i], "AGENT_IRS_NO");
			var BUYER_NAME = mySheet.GetCellValue(arrRow[i], "BUYER_NAME");
			var BUYER_IRS_NO = mySheet.GetCellValue(arrRow[i], "BUYER_IRS_NO");
			var SCHD_CLOSE_MONTH = mySheet.GetCellValue(arrRow[i], "SCHD_CLOSE_MONTH");
			mySheet.SetCellValue(arrRow[i], "SCHD_CLOSE_MONTH", SCHD_CLOSE_MONTH.replace("/",""));
			var cnt = 0;
			var PAY_AMT1 = mySheet.GetCellValue(arrRow[i], "PAY_AMT1");			
			var PAY_AMT2 = mySheet.GetCellValue(arrRow[i], "PAY_AMT2");			
			var PAY_AMT3 = mySheet.GetCellValue(arrRow[i], "PAY_AMT3");			
			var TAX_AMT = mySheet.GetCellValue(arrRow[i], "TAX_AMT");
			if(PO_NO == "") {
				alert("발주번호를 입력하세요.");
				return;
			}
			if(BUYER_ITEM_NO == "") {
				alert("품목코드를 입력하세요.");
				return;
			}
			if(AGENT_NAME == "") {
				alert("협력사명을 입력하세요.");
				return;
			}
			if(AGENT_IRS_NO == "") {
				alert("협력사 사업자번호를 입력하세요.");
				return;
			}
			if(BUYER_NAME == "") {
				alert("고객사명을 입력하세요.");
				return;
			}
			if(BUYER_IRS_NO == "") {
				alert("고객사 사업자번호를 입력하세요.");
				return;
			}
			if(SCHD_CLOSE_MONTH == "") {
				alert("마감예정월을 입력하세요.");
				return;
			}
			if(PAY_AMT1 == "" && PAY_AMT2 == "" && PAY_AMT3 == "") {
				alert("지급이슈금액을 입력하세요.");
				return;
			}
			if(PAY_AMT1.toString().indexOf('.') != -1) {
				alert(arrRow[i] - 1 + "번째 선지급금에 소숫점은 포함할 수 없습니다.");				
				mySheet.SelectCell(arrRow[i], 'PAY_AMT1', 1);				
				return;
			}
			if(PAY_AMT2.toString().indexOf('.') != -1) {
				alert(arrRow[i] - 1 + "번째 지체상금에 소숫점은 포함할 수 없습니다.");				
				mySheet.SelectCell(arrRow[i], 'PAY_AMT2', 1);				
				return;
			}
			if(PAY_AMT3.toString().indexOf('.') != -1) {
				alert(arrRow[i] - 1 + "번째 물류비에 소숫점은 포함할 수 없습니다.");				
				mySheet.SelectCell(arrRow[i], 'PAY_AMT3', 1);				
				return;
			}
			if(TAX_AMT.toString().indexOf('.') != -1) {
				alert(arrRow[i] - 1 + "번째 물류비 확정세액에 소숫점은 포함할 수 없습니다.");				
				mySheet.SelectCell(arrRow[i], 'TAX_AMT', 1);				
				return;
			}
						
			if(PAY_AMT1 != "") {
				cnt++;
			}
			if(PAY_AMT2 != "") {
				cnt++;
			}
			if(PAY_AMT3 != "") {
				if(TAX_AMT == "") {
					alert("물류비의 경우 세액 필수 입력입니다.");
					return;
				}
				var TAX_AMT_TEMP = PAY_AMT3 * 0.1;
				if(TAX_AMT_TEMP >= TAX_AMT) {
					if(TAX_AMT_TEMP - TAX_AMT >= 10) {
						alert("물류비 확정세액이 10원 이상 차이가 발생합니다. 확정세액 확인바랍니다.");
						return;
					}
				}
				if(TAX_AMT >= TAX_AMT_TEMP) {
					if(TAX_AMT - TAX_AMT_TEMP >= 10) {
						alert("물류비 확정세액이 10원 이상 차이가 발생합니다. 확정세액 확인바랍니다.");
						return;
					}
				}
				cnt++;
			}
			if(cnt > 1) {
				alert("지급이슈금액 중 하나만 입력하세요.")
				return;
			}
			
		
		
	}
		return true;
	
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	
	
}

function mySheet_OnLoadExcel() {
	var maxRow  = mySheet.RowCount();
	if(maxRow == 0){
		  return;
	}
	var maxRow = mySheet.RowCount() + 1;  
	
	
		for(var i=1; i<= maxRow; i++){
			var BUYER = mySheet.GetCellValue(i,"BUYER");
			var PO_NO = mySheet.GetCellValue(i,"PO_NO");
			var PO_SEQ = mySheet.GetCellValue(i,"PO_SEQ");
			var SCHD_CLOSE_MONTH = mySheet.GetCellValue(i,"SCHD_CLOSE_MONTH");
		
			if(i > 1) {
				if(SCHD_CLOSE_MONTH.length != 6) {
					alert("마감예정월 형식 오류");
					mySheet.RemoveAll();
					return;
				}
				var SCHD_CLOSE_MONTH_mh = SCHD_CLOSE_MONTH.substr(4);
				
				if(!months.includes(SCHD_CLOSE_MONTH_mh)) {					
					alert("마감예정월 값이 유효하지 않은 날짜입니다.");
					mySheet.RemoveAll();
					return;
				}
			}
			var PAY_REG_TYPE = mySheet.GetCellValue(i,"PAY_REG_TYPE");
			var PAY = PAY_REG_TYPE == "A" ? mySheet.GetCellValue(i,"PAY_AMT1") : PAY_REG_TYPE == "B" ? mySheet.GetCellValue(i,"PAY_AMT2") : mySheet.GetCellValue(i,"PAY_AMT3");
			var REMARK = mySheet.GetCellValue(i,"REMARK");
			if(BUYER == "" || PO_NO == "" || PO_SEQ == "" || SCHD_CLOSE_MONTH == "" || PAY_REG_TYPE == "" || PAY == "" || REMARK == "") {
				alert("빈값이 존재합니다. 확인 바랍니다.");
				mySheet.RemoveAll();
				return;
			}
			
			if(PAY_REG_TYPE == "A") {
				mySheet.SetCellValue(i,"PAY_AMT2","");
				mySheet.SetCellValue(i,"PAY_AMT3","");
				mySheet.SetCellValue(i,"TAX_AMT","");
			} else if(PAY_REG_TYPE == "B") {
				mySheet.SetCellValue(i,"PAY_AMT1","");
				mySheet.SetCellValue(i,"PAY_AMT3","");
				mySheet.SetCellValue(i,"TAX_AMT","");
			} else if(PAY_REG_TYPE == "C") {
				mySheet.SetCellValue(i,"PAY_AMT1","");
				mySheet.SetCellValue(i,"PAY_AMT2","");
			}	
			
			
			mySheet.SetCellValue(i,"SELECTED","1");
			mySheet.SetCellValue(i, "ADD_USER_ID", '<%=st_user_id%>');
			mySheet.SetCellValue(i, "BUYER_ITEM_NO_IMG", zipOn);
			mySheet.SetCellValue(i, "SCHD_CLOSE_MONTH_IMG", calendar);			
		
	}	
	kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoPayRegMngUploadExcel.do" , "SELECTED" );
	
}


</script>
</head>
<body onload="kep_onload_view()">
<form name = "searchCondition" method = "post" onsubmit="return false" >
<input type="hidden" name="s_SAVENAME">
<input type="hidden" id="st_user_id" name="st_user_id"  value="<%=st_user_id %>" />
	<div id="popWrapper" style="height:510px;">	
    	<div id="popHeader">
        	<h1 class="title">지급이슈 등록 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--grid-->
            <div>
            	<div class="ib_product" style="border-top:2px solid #3c639c">
	  				<script type="text/javascript">
	  					createIBSheet("mySheet", "100%", "480px");
	  				</script>
	  			</div>
	  			<p class="paging" id="pageindex"></p>
  			<!--버튼영역-->
               <div class="btnArea02" >
               <span class="fl">
               <%if(!st_user_id.equals("KEP2259018")) { // 자금팀 김연주 프로%>
              		 <span class="btn_05 mr04"><a href="/resources/excel/work/MPSO/masterMpSoPayRegMngUpload.xls">양식다운로드</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelup');">엑셀업로드</a></span>
               <% }%>
  					<span class="btn_02 mr04"><a href="javascript:doAction('add');">행추가</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
  				</span>
  	          	<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('save');">등록</a></span>
  				</span>
  			 </div>
        	</div>
    	</div>
	</div>   
</form>              
</body>
</html>
