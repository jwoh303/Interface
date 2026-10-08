<%--
**********************************************
* 메뉴 : 마감관리>물류수수료율 등록
* 화면 : 물류수수료율 등록 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>

<%
	
	String user_dept = "";
	String st_user_id = "";
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		user_dept =  CommonUtil.nvl((String)sessionInfo.getDepartment()); 
		st_user_id =  CommonUtil.nvl((String)sessionInfo.getUserId());
	}
boolean getRoleYn = CommonUtil.getCodeCheckReturn("LGRD", st_user_id);	
%>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var iconOn = "/resources/images/icon3.gif";
var cb_lgst_type = KepSheetComboData("LGST","SEL");
var lgst_type = {ComboCode: cb_lgst_type.ComboCode, ComboText: cb_lgst_type.ComboText};

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,		Hidden:false,	Type:"DummyCheck",	Header:"",			SaveName:"SELECTED"}
		,{ Align:"Center",	Width:170,	Edit:false,	EditLen:170,	Hidden:true,	Type:"Text",		Header:"협력사코드",	SaveName:"AGENT"}
		,{ Align:"Left",	Width:140,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"협력사명",		SaveName:"AGENT_NAME"}
		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:80,	    Hidden:false,	Type:"Text",		Header:"사업자번호(S)",	SaveName:"AGENT_IRS_NO"}
		,{ Align:"Center",	Width:30,	Edit:false,	EditLen:170,	Hidden:true,	Type:"Text",		Header:"고객사코드",	SaveName:"BUYER", Hidden : true}
		,{ Align:"Left",	Width:140,	Edit:false,	EditLen:80,	    Hidden:false,	Type:"Text",		Header:"고객사명",		SaveName:"BUYER_NAME"}
		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:80,	    Hidden:false,	Type:"Text",		Header:"사업자번호(B)",	SaveName:"BUYER_IRS_NO"}
		,{ Align:"Center",	Width:80,	Edit:true,	EditLen:90,	    Hidden:false,	Type:"Text",		Header:"수수료율(%)",		SaveName:"LOGIS_RATE"}
		,{ Align:"Left",	Width:230,	Edit:false,	EditLen:150,	Hidden:false,	Type:"Text",		Header:"수수료율 변경사유",	    SaveName:"REMARK"}	
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:90,	    Hidden:false,	Type:"Image",		Header:"예외기준",		SaveName:"LOGIS_CNT"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사담당자",	SaveName:"AGENT_USER_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:80,		Hidden:true,	Type:"DATE",		Header:"등록일자",		SaveName:"ADD_DATE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"등록일자",		SaveName:"START_DATE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"등록자",		SaveName:"ADD_USER_NAME"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",		Header:"KeP담당자",	SaveName:"KEP_USER_NAME"}	
		,{ Align:"Center",	Width:130,	Edit:true,	EditLen:120,	Hidden:false,	Type:"Text",		Header:"협의기한(마감월)",		SaveName:"END_DATE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",		Header:"국내해외구분",		SaveName:"EXP_FLAG"}
				
		
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetColProperty("LOGIS_RATE_STATUS", lgst_type);
	mySheet.SetCountPosition(4);
	//하이퍼링크 설정	
	setLinkCol(mySheet, "LOGIS_CNT");
	
	mySheet.SetImageList(8, iconOn);	
	
}


var st;
var mt;
var grbRow = "";
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
	if (str !="search" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search": // 조회
			current_page =-1;
			kepSearch(document.searchCondition,  mySheet , "/cmcl/getMasterCmClLogisRateMngList.do" , pagingMode );
			break;
	
		case "reload": // 초기화
			kepReload('searchCondition');
			$("#st_buyer_code").val("");
			$("#st_buyer_name").val("");
			$("#st_agent_code").val("");
			$("#st_agent_name").val("");			
			$("#st_agent_irs_no").val("");
			mySheet.RemoveAll();
			break;
		case "save":	 // 저장			
			if(checkSaveValid()) {
				if (!confirm('선택한 항목을 저장 하시겠습니까?')) {
					return;
				}
				popupSel = "logisSaveReasonPop";
				openSearchPopup("/cmcl/showMasterCmClLogisRateMngReasonPop.do", "?st_type=R", "600, 260, no");
			}			
			break;
		case "delete":	 // 삭제			
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow     = selectedGrid.split("|");	
			// 선택된 항목 유무 체크
			if (selectedGrid.length == 0) {
				alert("선택된 항목이 없습니다.");
				return false;
			}
			for(var i=0; i< arrRow.length; i++){					
				if(mySheet.GetCellValue(arrRow[i], "LOGIS_CNT") == '/resources/images/icon3.gif') {
					alert("품목별 예외기준이 있으면 삭제가 불가능합니다.\nSR을 통해 예외기준 삭제 후 삭제바랍니다.");
					return;
				}
			}
			
			
			if (!confirm('선택한 항목을 삭제 하시겠습니까?')) {
				return;
			}
			popupSel = "logisDeleteReasonPop";
			openSearchPopup("/cmcl/showMasterCmClLogisRateMngReasonPop.do", "?st_type=D", "600, 260, no");
			break;
		
	}
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	
	switch (str) {
		case "masterCmCoBuyerAgntcmpyPop1": // 고객사 팝업
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
			popupSel = "masterCmCoBuyerAgntcmpyPop1";
			break;			
		case "masterCmCoBuyerAgntcmpyPop2": // 협력사 팝업
			openSearchPopup("/cmco/showMasterCmCoBuyerAgntcmpyPop.do", "?st_com_type=S&st_sys_change_flag=N&st_sys_type=KA", "500,500,no");
			popupSel = "masterCmCoBuyerAgntcmpyPop2";
			break;		
		case "insert" : // 등록 팝업
			openSearchPopup("/cmcl/showMasterCmClLogisRateMngUploadPop.do", "", "1200,580,no");
			popupSel = "insert";
			break;
		case "calendarHour1":
			kepCalendarOpenPopup();
			break;
			
			
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if (column == 'LOGIS_CNT') { // 예외기준 조회 팝업 KEP_LOGISTIC_FEE_MNG	
		if(mySheet.GetCellValue(Row, "LOGIS_CNT") != '/resources/images/icon3.gif') {
			return;
		}
		var st_agent = mySheet.GetCellValue(Row, "AGENT");
		var st_buyer = mySheet.GetCellValue(Row, "BUYER");
		var st_exp_flag = mySheet.GetCellValue(Row, "EXP_FLAG") == '국내' ? 'N' : 'Y';
		
		openSearchPopup("/cmcl/showMasterCmClLogisRateMngFeePop.do", "?st_agent="+st_agent+"&st_buyer="+st_buyer+"&st_exp_flag="+st_exp_flag, "900,450,no");
		popupSel = "LOGIS_CNT";
	}
	return;
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7, value8){
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterCmCoBuyerAgntcmpyPop1") {	// 고객사, 협력사 팝업
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	} else if (popupSel == "masterCmCoBuyerAgntcmpyPop2") {	// 고객사, 협력사 팝업
		$("#st_agent_code").val(value2);
		$("#st_agent_name").val(value3);
	} else if (popupSel == "logisSaveReasonPop") {	// 저장 시 사유
		if(value2 == "R") {
			for(var i = 0; i < arrRow.length; i++) {
				mySheet.SetCellValue(arrRow[i],"REMARK", value1);
			}
			kepSave(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClLogisRateMngList.do" , "SELECTED" );
		}
	} else if (popupSel == "logisDeleteReasonPop") {	// 삭제 시 사유
		if(value2 == "D") {
			for(var i = 0; i < arrRow.length; i++) {
				mySheet.SetCellValue(arrRow[i],"REMARK", value1);
			}
			kepSave(document.searchCondition ,  mySheet , "/cmcl/deleteMasterCmClLogisRateMngList.do" , "SELECTED" );			
		}
	} 
	
	grbRow="";	//초기화
}

//콜백함수(파일명은 모두 동일)
function setPopupCalendar(year,month,day) {
	if(popupSel == "calendarHour1") { // 협의기한 
		mySheet.SetCellValue(grbRow,"END_DATE", year+"/"+month+"/"+day);
	}
	grbRow="";	//초기화
}

//페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
    current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/cmcl/getMasterCmClLogisRateMngList.do?page="+current_page , pagingMode );
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	
	if(!checkedSession(stCode)){return;}
	
	
	
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

function checkSaveValid() {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");	
	// 선택된 항목 유무 체크
	if (selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return false;
	}
	
	for(var i=0; i< arrRow.length; i++){		
		var END_DATE = mySheet.GetCellValue(arrRow[i], "END_DATE");
		
		if(Number(END_DATE) < Number(toCompactDate()) ) {
			alert("협의기한이 과거날짜입니다.");
			return;
		}
		var END_DATE_mm = Number(END_DATE.substr(4,2));	
		if(END_DATE_mm < 1 || END_DATE_mm > 12) {
			alert("협의기한 월 확인바랍니다.");				
			return;
		}
		if(END_DATE.length != 6) {
			alert("협의기한 확인바랍니다. YYYYMM 형태로 입력바랍니다.");
			return;
		}
		
		
	
	}
	
	
	return true;
	
}

function toCompactDate() { // 오늘날짜 yyyymm 형태로 구하기	
	var today = new Date();
	var yyyy = today.getFullYear();	
	var mm = String(today.getMonth() + 1).padStart(2, "0");		
	return yyyy+mm;
}


/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function kepAjaxError(pMethod, response){
	
}



</script>
</head>

<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>물류 수수료율 등록</h3>
       	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
	    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	</div>
	<!--조회영역-->
    <form name = "searchCondition" method = "post" onsubmit="return false" >
		<div id="cont_searchA">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="pageflag" name="pageflag" value="1">
		<input type="hidden" name="s_SAVENAME">
		<!-- 화면 내 정의 -->
		<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">		
           	<table  class="cont_t_list01" >
				<caption>물류 수수료율 등록</caption>
				<colgroup>
					<col width="5%" />
					<col width="21%" />
					<col width="5%" />
					<col width="21%" />
					<col width="9%"/>
                    <col width="23%" />
                    <col width="*" />
				</colgroup>

				<tbody>
					<tr>
						<td>고객사</td>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" value="" readonly onclick="javascript:doPop('masterCmCoBuyerAgntcmpyPop1');">
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">								
							<a href="javascript:doPop('masterCmCoBuyerAgntcmpyPop1');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
						</td>
						<td>협력사</td>
						<td>
							<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" value="" readonly onclick="javascript:doPop('masterCmCoBuyerAgntcmpyPop2');">
							<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:80%" value="">								
							<a href="javascript:doPop('masterCmCoBuyerAgntcmpyPop2');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
						</td>						
						<td>사업자번호(S)</td>
						<td>
							<input type="text" class="input_type_text" name="st_agent_irs_no" id="st_agent_irs_no" value="">								
						</td>
						<td></td>
					</tr>					
					
				</tbody>
			</table>
		</div>           	
      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c; padding-bottom:10px;">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "450px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
		<div class="btnArea">
			<% if (getRoleYn == true) { %>
	          <span class="fl" >
	          <span class="btn_02 mr04"><a href="javascript:doAction('delete');">삭제</a></span> 				
 			  </span>
  			  <span class="fr">
	  			<span class="btn_02 mr04"><a href="javascript:doPop('insert');">추가</a></span>
	  			<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>				 				
  			  </span>
  			  <% } %>
		 </div>
 	</form>
<!--내용 종료-->

</body>
</html>
