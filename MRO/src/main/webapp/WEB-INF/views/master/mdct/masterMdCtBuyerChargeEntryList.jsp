<%--
**********************************************
* 메뉴 : 회원사관리>고객사관리>고객사별 담당자 입력
* 화면 : 고객사별 담당자 입력
* 기능 : 고객사의 등록 상태별 목록 조회
* 프로그램 ID : PG_01_M_017_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-17
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="java.text.SimpleDateFormat"%> 
<%@ page import="java.util.Date"%> 
<%@ page import="java.util.Locale"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
String user_id = _sessionInfo.getUserId();
String com_code =  _sessionInfo.getComCode();
String user_dept =  _sessionInfo.getDepartment();
Date _currentDate = new Date();
SimpleDateFormat _formatter = new SimpleDateFormat ( "yyyy", Locale.KOREA );
int _toYear = Integer.parseInt(_formatter.format ( _currentDate ));	// 현재년도
boolean getRoleYn = CommonUtil.getCodeCheckReturn("BMNG", user_id);
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

var manageDept = KepSheetComboQueryIdData('common.getMdcdBuyerCardManageDeptList','SEL','');	// IBSHEET : 담당부서

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
					 { Align:"Center",	SaveName:"sStatus",				Header:"상태",			Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELECTED",			Header:"",				Type:"DummyCheck",	Width:60,	Edit:true,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"COM_CODE",			Header:"고객사코드",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"COM_CODE_ORG",		Header:"고객사코드 ORG",	Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Left",	SaveName:"COM_NAME",			Header:"고객사",			Type:"Text",		Width:300,	Edit:false,	EditLen:200,	Hidden:false,	KeyField:true,	BackColor:"${notnullColor}"}
					,{ Align:"Center",	SaveName:"YEAR",				Header:"년도",			Type:"Text",		Width:80,	Edit:true,	EditLen:4,		Hidden:false,	KeyField:true,	BackColor:"${notnullColor}"}
					,{ Align:"Center",	SaveName:"YEAR_ORG",			Header:"년도 ORG",		Type:"Text",		Width:80,	Edit:true,	EditLen:4,		Hidden:true}
					,{ Align:"Center",	SaveName:"KEP_DEPT_ORG",		Header:"담당부서코드 ORG",	Type:"Text",		Width:160,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"KEP_DEPT",			Header:"담당부서",			Type:"Combo",		Width:160,	Edit:true,	EditLen:100,	Hidden:false,	KeyField:true,	BackColor:"${notnullColor}",	ComboText:manageDept.ComboText, 	ComboCode:manageDept.ComboCode}
					,{ Align:"Center",	SaveName:"POSITION_GROUP",		Header:"업무구분",			Type:"Combo",		Width:80,	Edit:true,	EditLen:2,		Hidden:false,	KeyField:true,	BackColor:"${notnullColor}",	ComboText:"BM|PM",					ComboCode:"BM|PM"}
					,{ Align:"Center",	SaveName:"POSITION_GROUP_ORG",	Header:"업무구분 ORG",		Type:"Text",		Width:80,	Edit:true,	EditLen:2,		Hidden:true}
					,{ Align:"Center",	SaveName:"KEP_USER_ID_MASK",	Header:"담당자ID",		Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	KeyField:true,	BackColor:"${notnullColor}"}
					,{ Align:"Center",	SaveName:"KEP_USER_ID",			Header:"담당자ID",		Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"KEP_USER_ID_ORG",		Header:"담당자ID ORG",	Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"KEP_USER_NAME",		Header:"담당자명",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"MAIN_CLERK",			Header:"메인영업",			Type:"DummyCheck",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	BackColor:"${optColor}"}
					,{ Align:"Center",	SaveName:"PRIORITY",			Header:"메인운영",			Type:"DummyCheck",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	BackColor:"${optColor}"}
					,{ Align:"Center",	SaveName:"ITEM_GROUP",			Header:"업무구분",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
					//,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"공개",	SaveName:"AGENT_OPEN_FLAG", BackColor:"${optColor}",	Sort:0}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "COM_NAME");	//고객사코드
	setLinkCol(mySheet, "KEP_USER_ID_MASK");	//고객사코드
	
	kepAjaxCommonQueryIdCombo('st_kep_dept','common.getMdcdBuyerCardManageDeptList','ALL', '<%=user_dept%>');							// 조회조건 : 부서
	
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
			kepSearch(document.searchCondition, mySheet, "/mdct/getMasterMdCtBuyerChargeEntryList.do" , pagingMode );
			break;
		case "insert":	 // 조회
			var rows = mySheet.DataInsert(-1);
			mySheet.SetCellEditable(rows, "COM_CODE", 1);
			mySheet.SelectCell(rows, "COM_CODE");
			break;	
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_year").val("<%=_toYear%>");
			$("#st_kep_dept").val('<%=user_dept%>');
			$("#st_com_code").val('');
			$("#st_kep_user_id").val('');
			mySheet.RemoveAll();
			break;
		case "save": // 수정
			if (checkSubmit()) {
				kepSave(document.searchCondition, mySheet, "/mdct/saveMasterMdCtBuyerChargeEntryList.do", "SELECTED");
			}
			break;
		case "kepUserIDCheck":			//  담당자 중복체크
			kepAjaxFormCall("/mdct/selectMasterMdCtBuyerChargeEntryUserIdCheck.do", "searchCondition", str);
			break;
		case "del":					// 고객사별 담당자 삭제
			if (checkDelete()) {
				var delCnt = 0;

				for (var i = arrRow.length-1; i >= 0; i--) {
					if (mySheet.GetCellValue(arrRow[i], "sStatus") == "I") {
						mySheet.RowDelete(arrRow[i], 0);
					} else {
						delCnt++;
					}
				}

				if (delCnt > 0) {
					kepSave(document.searchCondition, mySheet, "/mdct/deleteMasterMdCtBuyerChargeEntryList.do", 1);
				}
			}
			break;		
	}
}

function chk_except() {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	var exceptArr = "";
	var conf = false;
	
	if (selectedGrid.length != 0) {
		for (var i=0; i <  arrRow.length; i++) {
			exceptArr += mySheet.GetCellValue(arrRow[i], "CORP_CODE") + "@@";
		}
		
		$("#st_corp_code").val(exceptArr);
		conf = confirm("법인그룹을 삭제하시겠습니까?");
	}
	return conf;
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if(mySheet.RowCount() <= 0){
   		return;
   	}else{
   		for(var i=1; i<mySheet.RowCount()+1; i++){
   			mySheet.SetCellValue(i, "KEP_USER_ID_MASK", kepMaskingName(mySheet.GetCellValue(i, "KEP_USER_ID")));
   			mySheet.SetCellValue(i, "KEP_USER_NAME", kepMaskingName(mySheet.GetCellValue(i, "KEP_USER_NAME")));
   		}
   	}
	
	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2(mySheet, 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2(mySheet, current_page , document.searchCondition.onepagerow.value);	
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdCtBuyerChargeEntryList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val) {
	popupSel = str;
	
	switch (str) {
		case "kepDamdang":		// KeP담당자
			openSearchPopup("/mdcp/getMasterMdCpUserChoicePop.do", "?st_buyer=KRKORE0001", "500,500,no");
			break;	
		case "kepManagerPop":		// KeP담당자
			openSearchPopup("/mdcp/getMasterMdCpUserChoicePop.do", "?st_buyer=" + val, "500,500,no");	
			break;		
		case "comCode": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N&AUTH=ALL", "500,466,no");
			break;
		case "company": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N&AUTH=ALL", "500,466,no");
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'COM_NAME') { // 요청자
		doPop("company", mySheet.GetCellValue(Row,"COM_CODE"));
	} else if (column == 'KEP_USER_ID_MASK') {
		doPop("kepDamdang");
	} else if (column == 'MAIN_CLERK'||column == 'PRIORITY') {//BM메인여부 지정시 체크박스 자동 체크
		mySheet.SetCellValue(Row,"SELECTED","1");
	} 
	return;
}

function mySheet_OnChange(Row, Col, Value) {

	if ( Row  < 1) return;

	var column = mySheet.ColSaveName(Col);
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'YEAR') { // 요청자
		if (kepTrimStr(Value) != "") {
			if (!kepIsNumberString(Value)) {
				alert("년도는 숫자만 입력할수 있습니다.");
				mySheet.SetCellValue(Row, "YEAR", "", 0);
				mySheet.SelectCell(Row, "YEAR");
				return;
			}
		}
	}
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg);
	}
	
 	if ( code >= 0 ) { // 저장  실패 시에도 초기화하도록 변경
		doAction("search");
 	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	if (pMethod == "corpCheck") {
		if (sMsg != "0") {
			alert("중복된 법인코드가 있습니다.");
			mySheet.ReturnCellData(Row, "CORP_CODE");
			mySheet.SelectCell(Row, "CORP_CODE");
			return;
		}
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "kepDamdang") {	// 다중 고객사
		mySheet.SetCellValue(grbRow,"KEP_USER_ID", code);
		mySheet.SetCellValue(grbRow,"KEP_USER_ID_MASK", code);
		mySheet.SetCellValue(grbRow,"KEP_USER_NAME", text);
	} else if (popupSel == "kepManagerPop") {	// 다중 고객사
		$("#st_kep_user_id").val(code);
		$("#st_kep_user_name").val(text);
	} else if (popupSel == "comCode") {	// 다중 고객사
		$("#st_com_code").val(code);
		$("#st_com_name").val(text);
	} else if (popupSel == "company") {	// 다중 고객사
		mySheet.SetCellValue(grbRow,"COM_CODE", code);
		mySheet.SetCellValue(grbRow,"COM_NAME", text);
	} else if (popupSel == "cominfo") {
		doAction("search");
	}

	grbRow="";	//초기화
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction("search");
	}
}

//변경 여부 체크
function checkRow() {
	var check = true;

	for (var i = 1; i <= mySheet.RowCount(); i++ ) {
		if (mySheet.GetCellValue(i, "sStatus") != 'R' ) {
        	check = false;
        	break;
		}
	}
	if (check) {
		alert("변경된 항목이 없습니다.");
		return false;
	}
	return true;
}

function checkDelete() {
	var user_dept = "<%=user_dept%>";		
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	var mainCnt = 0;
	
	for (var i = 0; i < arrRow.length; i++) {
		if (mySheet.GetCellValue(arrRow[i], "PRIORITY") == "1") {
			mainCnt++;
		}
		if (mySheet.GetCellValue(arrRow[i], "MAIN_CLERK") == "1") {
			mainCnt++;
		}		
		
		if(mySheet.GetCellValue(arrRow[i],'KEP_DEPT_ORG') != "") { // ROW 추가한건에 대한 처리			
			if (kepTrimStr(mySheet.GetCellValue(arrRow[i], "KEP_DEPT")) != kepTrimStr(mySheet.GetCellValue(arrRow[i], "KEP_DEPT_ORG"))) { // 타부서로 변경 못하도록			
				alert("본인 부서만 저장 및 삭제가 가능합니다.");			
				return false;
			}
			if (kepTrimStr(mySheet.GetCellValue(arrRow[i], "KEP_DEPT")) != user_dept) { // 저장 및 삭제 시 본인 부서가 아닌경우			
				alert("본인 부서만 저장 및 삭제가 가능합니다.");			
				return false;
			}
		}
		
	}
	if (mainCnt > 0) {
		alert("메인담당자는 삭제 할수 없습니다.\n메인담당자 변경후 삭제 하십시요.");
		return false;
	}
	
	//BM, PM체크 함수	
	if(checkBmPmData()){
		var conf = confirm("고객사별 담당자를 삭제하시겠습니까?");
		return conf;		
	}

}

function checkSubmit() {
	//if (!checkRow()) return false; 체크박스 변경으로 인한 로직 불필요.
	var user_dept = "<%=user_dept%>";	
	for (var i = 1; i <= mySheet.RowCount(); i++ ) {
		if (kepTrimStr(mySheet.GetCellValue(i, "COM_CODE")) == "") {
			alert("고객사를 선택해주세요.");
			mySheet.SelectCell(i, "COM_CODE");
			return false;
		}

		if (kepTrimStr(mySheet.GetCellValue(i, "YEAR")) == "") {
			alert("년도를 입력해주세요.");
			mySheet.SelectCell(i, "YEAR");
			return false;
		}
		
		if (kepTrimStr(mySheet.GetCellValue(i, "KEP_DEPT")) == "") {
			alert("담당부서를 선택해주세요.");
			mySheet.SelectCell(i, "KEP_DEPT");
			return false;
		}
		
		if (kepTrimStr(mySheet.GetCellValue(i, "POSITION_GROUP")) == "") {
			alert("업무구분을 입력해주세요.");
			mySheet.SelectCell(i, "POSITION_GROUP");
			return false;
		}

		if (kepTrimStr(mySheet.GetCellValue(i, "KEP_USER_ID_MASK")) == "") {
			alert("담당자를 선택해주세요.");
			mySheet.SelectCell(i, "KEP_USER_ID_MASK");
			return false;
		}
		if(mySheet.GetCellValue(i,'KEP_DEPT_ORG') != "") { // ROW 추가한건에 대한 처리
			if (kepTrimStr(mySheet.GetCellValue(i, "KEP_DEPT")) != kepTrimStr(mySheet.GetCellValue(i, "KEP_DEPT_ORG"))) { // 타부서로 변경 못하도록			
				alert("본인 부서만 저장 및 삭제가 가능합니다.");			
				return false;
			}
		}		
		if (kepTrimStr(mySheet.GetCellValue(i, "KEP_DEPT")) != user_dept) { // 저장 및 삭제 시 본인 부서가 아닌경우			
			alert("본인 부서만 저장 및 삭제가 가능합니다.");			
			return false;
		}
	}
	
	// BM, PM체크 함수	
	if(checkBmPmData()){
		var conf = confirm("고객사별 담당자를 저장하시겠습니까?");
		return conf;		
	}
}
//BM, PM체크 함수
function checkBmPmData(){

	var st_com_name = "";	
	for (var i = 1; i <= mySheet.RowCount(); i++ ) {
		var st_com_code = kepTrimStr(mySheet.GetCellValue(i, "COM_CODE"));
		var st_bm_check = 0;
		var st_pm_check = 0;
		var st_process_check = 0;
		for (var j = 1; j <= mySheet.RowCount(); j++ ) {
			//고객사코드 기준 메인 bm,pm 지정여부 검색 없으면 삭제 불가
			if(st_com_code == kepTrimStr(mySheet.GetCellValue(j, "COM_CODE"))){
				var st_bm_main =  kepTrimStr(mySheet.GetCellValue(j, "MAIN_CLERK"));
				var st_pm_main =  kepTrimStr(mySheet.GetCellValue(j, "PRIORITY"));
				st_com_name =  kepTrimStr(mySheet.GetCellValue(i, "COM_NAME"));
				if(st_bm_main =="1"){
					st_bm_check++;
				}
				if(st_pm_main =="1"){
					st_pm_check++;
				}
				//고객사 기준 BM, PM지정이 되어야 다음스탭으로 넘어감
				if(st_bm_check > 0 && st_pm_check > 0){
					st_process_check++;
				}
			}				
		}
		//고객사 기준 메인 BM,PM 지정이 되어있어야 다음스텝 진행 가능.
		if(st_process_check == 0){
			break;
		}
	}
	if(st_process_check == 0){
		alert(st_com_name + "는(은) 메인BM, 메인PM 지정이 안되어 수정 불가능 합니다. 메인BM, PM 먼저 지정 바랍니다.");
		return  false;
	}else{
		return  true;	
	}
	
}
</script>
</head>
<body onload="kep_onload_view()">
	<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA">
			<h3>고객사별 담당자 입력</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition" name="searchCondition" method="post" onsubmit="return false;" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME" />
			<input type="hidden" id="pageflag" name="pageflag" value="1" />
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}" />
			<input type="hidden" id="st_corp_code" name="st_corp_code"  value="" />
			
            	<table  class="cont_t_list01" >
					<caption>고객사별 담당자 입력</caption>
					<colgroup>
						<col width="8%" />
						<col width="35%" />
						<col width="8%" />
						<col width="15%" />
						<col width="8%" />
						<col width="*" />
					</colgroup>
						
					<tbody>
						<tr> 
							<td>고객사</td>
							<td style="text-align:left;">
								<input type="hidden" id="st_com_code" name="st_com_code" value="" />
								<input type="text" id="st_com_name" name="st_com_name" class="input_type_text" style="width:65%" value=""  readonly  />
								<a href="javascript:doPop('comCode');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_com_code','st_com_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<td>기준년도</td>
							<td style="text-align:left;">
								<select id="st_year" name="st_year" style="width:80%">
								<% for (int i=_toYear-4; i <= _toYear; i++) { %>
									<option value="<%=i%>" <%=i == _toYear ? "selected" : "" %>><%=i %></option>
								<% } %>
								</select>
							</td>
							<td>담당부서</td>
							<td style="text-align:left;">
								<select id="st_kep_dept" name="st_kep_dept" style="width:80%">
								</select>
							</td>
						</tr>
						<tr>	
							<td>담당자</td>
							<td style="text-align:left;">
								<input type="hidden" id="st_kep_user_id" name="st_kep_user_id" value=""  />
								<input type="text" id="st_kep_user_name" name="st_kep_user_name" class="input_type_text" style="width:65%" value=""  readonly onclick="javascript:doPop('kepManagerPop', '<%=com_code%>');" />
								<a href="javascript:doPop('kepManagerPop', '<%=com_code%>');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_kep_user_id','st_kep_user_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<td>메인담당자</td>
							<td style="text-align:left;">
								<select id="st_priority" name="st_priority" style="width:80%">
									<option value="">전체</option>
									<option value="B">메인BM</option>
									<option value="P">메인PM</option>
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
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>

		<!--버튼영역-->
  		<!--SMART팀 추연희  -->
  		<!--SMART팀 김초롱  -->
  		<!--LINK팀 박형근  -->
  		<!--건설사업팀 정찬일  -->
  		<!--판촉사업파트 김성민  -->
  		<!--제조1사업팀 조민서  -->
  		<!--제조2사업팀 황인희  -->
  		<!--제조3사업팀 정영설  -->
  		<!--IT유통파트 전지수  -->
  		<div class="btnArea">
    		<% if (getRoleYn == true) { %>
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('insert');">행추가</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
				<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>				
			</span>
			<% } %>
		</div>
		<!--내용 종료-->                 
</body>
</html>
