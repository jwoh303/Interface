<%--
**********************************************
* 메뉴 : 회원사관리> 고객사 리포트 현황 > 계약/신규 품목현황 상세
* 화면 : 고객사 리포트 현황
* 기능 :
* 프로그램 ID :
* 담당자 :
* 착수일 :
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%   
	String st_group_code = CommonUtil.nvl((String) request.getParameter("st_group_code"), ""); //그룹코드
	String st_group_nm = CommonUtil.nvl((String) request.getParameter("st_group_nm"), ""); //그룹명
	String st_close_month = CommonUtil.nvl((String) request.getParameter("st_close_month"), ""); //생성년월
	String st_report_no = CommonUtil.nvl((String) request.getParameter("st_report_no"), ""); //리포트번호
	String st_status_gbn = CommonUtil.nvl((String) request.getParameter("st_status_gbn"), ""); //구분 가공:M, 자동:A
	
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script>
var popupSel = "";
var mySheet = new ibsheetObject();
var grbRow = "";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var st_rcflag = KepSheetComboData("NCFLAG","SEL");
	var comboInfo = {ComboCode: st_rcflag.ComboCode, ComboText: st_rcflag.ComboText};
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",	Width:120,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus"}					
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"거래년월",		SaveName:"TOTAL_MONTH"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Combo",		Header:"품목구분",		SaveName:"TYPE"}
		,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",		Format:"${priceFormat}",		Header:"당월\n등록건수",		SaveName:"THAT_MONTH_CNT"}
		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",		Format:"${priceFormat}",		Header:"당월\n등록금액",		SaveName:"THAT_MONTH_AMT"}
		,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",		Format:"${priceFormat}",		Header:"전월\n등록건수",		SaveName:"LAST_MONTH_CNT"}
		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",		Format:"${priceFormat}",		Header:"전월\n등록금액",		SaveName:"LAST_MONTH_AMT"}
		,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",		Format:"${priceFormat}",		Header:"작년누적\n등록건수",		SaveName:"LAST_YEAR_CNT"}
		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",		Format:"${priceFormat}",		Header:"작년누적\n등록금액",		SaveName:"LAST_YEAR_AMT"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	var initsheet2 = {};
	initsheet2.Cols = [
	     { Align:"Center",	Width:60,	Edit :false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
		,{ Align:"Center",	Width:60,	Edit :true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
		,{ Align:"Center",	Width:140,	Edit :false,	EditLen:100,	Hidden:false,	Type:"Combo",		Header:"품목구분",		SaveName:"TYPE"}
		,{ Align:"Right",	Width:230,	Edit :true,	EditLen:100,	Hidden:false,	Type : "Float",		Format:"${priceFormat}",		Header:"당월 등록건수",		SaveName:"TOTAL_CNT" ,BackColor:"${optColor}"}
		,{ Align:"Right",	Width:230,	Edit :true,	EditLen:100,	Hidden:false,	Type : "Float",		Format:"${priceFormat}",		Header:"당월 등록금액",		SaveName:"TOTAL_AMT" ,BackColor:"${optColor}"}
	];
	//데이터 셋팅
	IBS_InitSheet(mySheet2, initsheet2, pagingMode);
	mySheet2.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	//데이터콤보 셋팅
	mySheet.SetColProperty("TYPE", comboInfo);
	mySheet2.SetColProperty("TYPE", comboInfo);
	doAction("search"); 
	
}

//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search":
			kepSearch(document.searchCondition, mySheet, "/mdct/getMasterMdCtReportSalesNewPop.do" , pagingMode );
			kepSearch(document.searchCondition, mySheet2, "/mdct/getMasterMdCtReportSalesNewInputPop.do" , pagingMode );
			break;
		case "save": // 저장
			if (checkSaveSubmit()) {
			    if(confirm("저장 하시겠습니까?")) {
			    	kepSave(document.searchCondition, mySheet2, "/mdct/saveMasterMdCtReportSalesNewPop.do", "SELECTED");
			    }else{			    	
			    	return;			    	
			    }
			}		
			break;
		case "del":
			//고객사 매핑정보 필수
			var selectedGrid = mySheet2.FindCheckedRow("SELECTED");
			if(selectedGrid.length == 0){
				alert("고객사 선택 바랍니다.");
				mySheet2.SelectCell(1, "COM_CODE");
				return;		
			}
		    if(confirm("삭제 하시겠습니까?")) {
		    	kepSave(document.searchCondition, mySheet2, "/mdct/deleteMasterMdCtReportSalesNewPop.do", "SELECTED");
		    }else{			    	
		    	return;			    	
		    }
			break;
	}

}
//
//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	return DATA;
}
	
//mySheet 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	if (msg != "") {
		alert(msg);
	}
}
//mySheet2 조회 후처리
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	mySheet2.SetColProperty("TYPE",{Edit:false});
	if(!checkedSession(stCode)){return;}	
	if (msg != "") {
		alert(msg);
	}
}
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {	
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	doAction("search");
}
function mySheet2_OnSaveEnd(code, msg, stCode) {	
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	this.close();
	opener.doAction("search");
}
function mySheet2_OnLoadExcel() {
	for (var i=1; i<=mySheet2.RowCount(); i++){
		mySheet2.SetCellValue(i,"SELECTED", "1");
	}
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {	
	
	if (pMethod == "save"||pMethod == "end"||pMethod == "restart"){ 
		 alert("저장에 실패 하였습니다. 다시 시도 하여 주십시오"); 
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	var result = response.msg.MSG;  
	if(pMethod=="update"){
		if(result=="Ok"){
			alert("정상적으로 저장 되었습니다.");
		}else{
			alert(result);
		}
	}
}


//팝업함수호출
function doPop(str, val1, val2, val3, val4) {
	
}
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2){
	 
}
//TABLE의 ROW 데이타 생성
function addrows() {
	var rows = mySheet2.DataInsert(-1);
	mySheet2.SetCellValue(rows, 'SELECTED', "1");	
	mySheet2.SetColProperty("TYPE",{Edit:true});
}
function checkSaveSubmit(){
	var selectedGrid = "";
	var arrRow = "";
	for (var i=1; i<=mySheet2.RowCount(); i++){
		mySheet2.SetCellValue(i,"SELECTED", "1");
	}
	selectedGrid = mySheet2.FindCheckedRow("SELECTED");
	arrRow = selectedGrid.split("|");
	for (var i=0; i<arrRow.length; i++){
		if (mySheet2.GetCellValue(arrRow[i], "TYPE") == ""){
			alert(arrRow[i]+"번째 품목구분 입력이 필요 합니다.");
			mySheet2.SelectCell(arrRow[i], "TYPE");
			return false;
		}
		if (mySheet2.GetCellValue(arrRow[i], "TOTAL_CNT") == ""){
			alert(arrRow[i]+"번째 당월 등록건수 입력이 필요 합니다.");
			mySheet2.SelectCell(arrRow[i], "TOTAL_CNT");
			return false;
		}
		if (mySheet2.GetCellValue(arrRow[i], "TOTAL_AMT") == ""){
			alert(arrRow[i]+"번째 당월 등록금액 입력이 필요 합니다.");
			mySheet2.SelectCell(arrRow[i], "TOTAL_AMT");
			return false;
		}
	}
	return true;
}
</script> 
</head>
<body onload="kep_onload_view(); ">
<form name = "searchCondition"  id = "searchCondition" method = "post" onsubmit="return false" >	
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="s_SAVENAME"  name="s_SAVENAME" />
	<input type="hidden" id="st_report_no"  name="st_report_no" value="<%=st_report_no%>">
	<input type="hidden" id="st_group_code"  name="st_group_code" value="<%=st_group_code%>">
	<input type="hidden" id="st_group_nm"  name="st_group_nm" value="<%=st_group_nm%>">
	<input type="hidden" id="st_close_month"  name="st_close_month" value="<%=st_close_month%>">
	<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
	<!-- 화면 내 정의 -->
	<div id="popWrapper" style="height:100%;">
    	<div id="popHeader">
			<h1 class="title">계약/신규 품목현황 상세</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"  style="height:518px;">
            <!--조회영역-->
            <h4><b>계약/신규 품목현황 상세</b><b style="float: right;">단위: 원</b></h4>		
			<div class="ib_product" style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "100%", "170px");
				</script>
			</div>
			<br>
			<h4><b>계약/신규 품목현황 입력</b></h4>
			<div class="ib_product" style="border-top:2px solid #3c639c">
		    <script type="text/javascript">
						createIBSheet("mySheet2", "100%", "190px");
			</script>        
		    </div>
		    <%if(st_status_gbn.equals("M")){ %>
			    <!--버튼영역-->
			    <p class="btnArea mt10 mb05">
	  	          	<span class="fl">
	  	          		※ 품목구분 계약, 신규 각 1건씩만 입력 가능 합니다.
	  	          	</span>
	  	          	<span class="fr">
						<span class="btn_02"><a href="javascript:addrows();">행추가</a></span>
						<span class="btn_02"><a href="javascript:doAction('del');">삭제</a></span>
						<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>	
	  				</span>
	  			</p>
  			<%} %>		
		</div>
	</div>
</form> 
</body>
</html>
