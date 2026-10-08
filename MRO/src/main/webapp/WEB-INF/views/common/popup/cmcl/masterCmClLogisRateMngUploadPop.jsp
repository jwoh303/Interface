<%--
**********************************************
* 메뉴 : 마감관리 > 물류 수수료율 등록 팝업
* 화면 : 물류 수수료율 등록 화면 내 추가
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


// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [					 
			 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus"}
			,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,		Hidden:false,	Type:"DummyCheck",	Header:"",			SaveName:"SELECTED"}
			,{ Align:"Center",	Width:170,	Edit:false,	EditLen:170,	Hidden:true,	Type:"Text",		Header:"등록자",		SaveName:"ADD_USER_ID"}
			,{ Align:"Center",	Width:170,	Edit:false,	EditLen:170,	Hidden:true,	Type:"Text",		Header:"협력사코드",	SaveName:"AGENT"}
			,{ Align:"Left",	Width:140,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"협력사명",		SaveName:"AGENT_NAME"}
			,{ Align:"Center",	Width:30,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Image",		Header:"협력사명",		SaveName:"AGENT_NAME_IMG" }			
			,{ Align:"Center",	Width:30,	Edit:false,	EditLen:170,	Hidden:true,	Type:"Text",		Header:"고객사코드",	SaveName:"BUYER", Hidden : true}
			,{ Align:"Left",	Width:140,	Edit:false,	EditLen:80,	    Hidden:false,	Type:"Text",		Header:"고객사명",		SaveName:"BUYER_NAME"}
			,{ Align:"Center",	Width:30,	Edit:false,	EditLen:80,	    Hidden:false,	Type:"Image",			Header:"고객사명",		SaveName:"BUYER_NAME_IMG"}			
			,{ Align:"Center",	Width:100,	Edit:true,	EditLen:90,	    Hidden:false,	Type:"Text",		Header:"수수료율(%)",		SaveName:"LOGIS_RATE" ,KeyField:true, BackColor:"${notnullColor}"}
			,{ Align:"Left",	Width:220,	Edit:true,	EditLen:150,	Hidden:false,	Type:"Text",		Header:"수수료율 변경사유",	    SaveName:"REMARK",KeyField:true, BackColor:"${notnullColor}"}
			,{ Align:"Center",	Width:110,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사담당자",	SaveName:"AGENT_USER_NAME" ,KeyField:true, BackColor:"${notnullColor}"}
			,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:true,	Type:"Date",		Header:"등록일자",		SaveName:"ADD_DATE", BackColor:"${notnullColor}"}			
			,{ Align:"Center",	Width:120,	Edit:true,	EditLen:120,	Hidden:false,	Type:"Text",		Header:"협의기한(마감월)",		SaveName:"END_DATE",KeyField:true, BackColor:"${notnullColor}"}
			,{ Align:"Center",	Width:100,	Edit:true,	EditLen:120,	Hidden:false,	Type:"Text",		Header:"국내해외구분",		SaveName:"EXP_FLAG",KeyField:true, BackColor:"${notnullColor}"}
			,{ Align:"Center",	Width:110,	Edit:false,	EditLen:110,	Hidden:true,	Type:"Text",		Header:"KeP담당자",	SaveName:"KEP_USER_NAME", BackColor:"${notnullColor}"}
				
					
					
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	

	//하이퍼링크 설정	
	setLinkCol(mySheet, "AGENT_NAME_IMG");
	setLinkCol(mySheet, "BUYER_NAME_IMG");	

	//검색 이미지설정
	mySheet.SetImageList(1, zipOn);
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
			kepSearch(document.searchCondition, mySheet, "/cmcl/getMasterCmClLogisRateMngUploadList.do" , pagingMode );
			break;			
		case "excelup":	// 엑셀업로드
			mySheet.RemoveAll();			
			var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"|||1|||6|||2|3|4||5|7|"};
			mySheet.LoadExcel(params);
			break;		
		case "save": // 등록
			if (checkSubmit()) {
				if (!confirm("선택되어 있는 행과 상관없이 모두 등록됩니다.\n등록하시겠습니까?")) {
					return;
				}
				kepSave(document.searchCondition, mySheet, "/cmcl/saveMasterCmClLogisRateMngUploadList.do", "SELECTED");
			}
			break;		
		case "add": // 추가
			var rows = mySheet.DataInsert(-1);
			mySheet.SetCellValue(rows, "SELECTED", "1");
		 	mySheet.SetCellValue(rows, "AGENT_NAME_IMG", zipOn);
		 	mySheet.SetCellValue(rows, "BUYER_NAME_IMG", zipOn);		
			
			break;
		case "del":					// 삭제			
						
			if (!confirm("선택되어 있는 행은 모두 삭제 됩니다.\n삭제하시겠습니까?")) {
				return;
			}
			var rows = mySheet.RowCount();
			while (rows >= 0) {
				var chkedYn = mySheet.GetCellValue(rows, "SELECTED");
				if (chkedYn == "1") {
					mySheet.RowDelete(rows);
				}
				rows--;
			}
			//순번 재배열
			mySheet.ReNumberSeq();
			break;		
	}
}



// 팝업함수호출
function doPop(str, val) {
	popupSel = str;
	
	switch (str) {
		case "masterCmCoBuyerAgntcmpyPop1": // 고객사 팝업
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
			popupSel = "masterCmCoBuyerAgntcmpyPop1";
			break;			
		case "masterCmCoBuyerAgntcmpyPop2": // 협력사 팝업
			openSearchPopup("/cmco/showMasterCmCoBuyerAgntcmpyPop.do", "?st_com_type=S&st_sys_change_flag=N&st_sys_type=KA", "500,500,no");
			popupSel = "masterCmCoBuyerAgntcmpyPop2";
			break;		
		case "calendarHour1":
			kepCalendarOpenPopup();
			break;		
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'AGENT_NAME_IMG') { // 협력사명
		doPop("masterCmCoBuyerAgntcmpyPop2");
	} else if (column == 'BUYER_NAME_IMG') { // 고객사명
		doPop('masterCmCoBuyerAgntcmpyPop1');
	} 
	return;
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
	
	if (popupSel == "masterCmCoBuyerAgntcmpyPop1") {	// 고객사 팝업
		mySheet.SetCellValue(grbRow,"BUYER", value1);
		mySheet.SetCellValue(grbRow,"BUYER_NAME", value2);
	} else if (popupSel == "masterCmCoBuyerAgntcmpyPop2") {	// 협력사 팝업
		mySheet.SetCellValue(grbRow,"AGENT", value2);
		mySheet.SetCellValue(grbRow,"AGENT_NAME", value3);		
	}

	grbRow="";	//초기화
}

function checkSubmit() {
	var totCnt = mySheet.RowCount();
 	
	if (totCnt < 1)
		return;
	
		for( var i = 1; i <= mySheet.RowCount(); i++){			
			mySheet.SetCellValue(i,"ADD_USER_ID", '<%=st_user_id%>');
			mySheet.SetCellValue(i,"SELECTED", '1');
			var AGENT = mySheet.GetCellValue(i, "AGENT");
			var LOGIS_RATE = mySheet.GetCellValue(i, "LOGIS_RATE");			
			var AGENT_USER_NAME = mySheet.GetCellValue(i, "AGENT_USER_NAME");
			var END_DATE = mySheet.GetCellValue(i, "END_DATE");		
			var EXP_FLAG = mySheet.GetCellValue(i,"EXP_FLAG"); 		
						
			if(AGENT == "") {
				alert("협력사를 선택하세요.");
				return;
			}
			if(LOGIS_RATE == "") {
				alert("물류수수료율을 입력하세요.");
				return;
			}
			
			if(AGENT_USER_NAME == "") {
				alert("협력사 담당자를 입력하세요.");
				return;
			}
			if(END_DATE == "") {
				alert("협의기한을 입력하세요.");
				return;
			}			
			if(Number(END_DATE) < Number(toCompactDate()) ) {
				alert("협의기한이 과거날짜입니다.");
				return;
			}
			if(END_DATE.length != 6) {
				alert("협의기한 확인바랍니다. YYYYMM 형태로 입력바랍니다.");
				return;
			}
			var END_DATE_mm = Number(END_DATE.substr(4,2));	
			if(END_DATE_mm < 1 || END_DATE_mm > 12) {
				alert("협의기한 월 확인바랍니다.");				
				return;
			}
			if(!(EXP_FLAG == 'Y' || EXP_FLAG == 'N' || EXP_FLAG == "") ) {
				alert("국내(N)/해외(Y) 값 형식 오류");				
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
	
	
	
		for(var i=1; i<= maxRow; i++){
			var AGENT = mySheet.GetCellValue(i,"AGENT");
			var LOGIS_RATE = mySheet.GetCellValue(i,"LOGIS_RATE");			
			var AGENT_USER_NAME = mySheet.GetCellValue(i,"AGENT_USER_NAME");
			var END_DATE = mySheet.GetCellValue(i,"END_DATE");			
			var REMARK = mySheet.GetCellValue(i,"REMARK");
			var EXP_FLAG = mySheet.GetCellValue(i,"EXP_FLAG"); 
			
			console.log(EXP_FLAG);
			if(Number(END_DATE) < Number(toCompactDate()) ) {
				alert("협의기한이 과거날짜입니다.");
				return;
			}
			
			if(END_DATE.length != 6) {
				alert("협의기한 형식 오류");
				mySheet.RemoveAll();
				return;
			}
			
			var END_DATE_mm = Number(END_DATE.substr(4,2));			
			
			
			if(END_DATE_mm < 1 || END_DATE_mm > 12) {
				alert("협의기한 월 확인바랍니다.");
				mySheet.RemoveAll();
				return;
			}
			
			
			
			if(AGENT == "" || LOGIS_RATE == "" || AGENT_USER_NAME == "" || END_DATE == "" || REMARK == "") {
				alert("빈값이 존재합니다. 확인 바랍니다.");
				mySheet.RemoveAll();
				return;
			}
			
			
			
			if(!(EXP_FLAG == 'Y' || EXP_FLAG == 'N' || EXP_FLAG == "") ) {
				alert("국내(N)/해외(Y) 값 형식 오류");
				mySheet.RemoveAll();
				return;
			}
			
			if(EXP_FLAG == "") {
				mySheet.SetCellValue(i,"EXP_FLAG","N");
			}
			
			
			mySheet.SetCellValue(i,"SELECTED","1");
			mySheet.SetCellValue(i, "ADD_USER_ID", '<%=st_user_id%>');
			
		
	}	
	kepSave(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClLogisRateMngUploadExcel.do" , "SELECTED" );
	
}

function toCompactDate() { // 오늘날짜 yyyymm 형태로 구하기	
	var today = new Date();
	var yyyy = today.getFullYear();	
	var mm = String(today.getMonth() + 1).padStart(2, "0");		
	return yyyy+mm;
}

</script>
</head>
<body onload="kep_onload_view()">
<form name = "searchCondition" method = "post" onsubmit="return false" >
<input type="hidden" name="s_SAVENAME">
	<div id="popWrapper" style="height:510px;">	
    	<div id="popHeader">
        	<h1 class="title">물류수수료율 등록 </h1>
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
              		 <span class="btn_05 mr04"><a href="/resources/excel/work/CLOSE/masterCmClLogisRateMngUpload.xls">양식다운로드</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelup');">엑셀업로드</a></span>
               
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
