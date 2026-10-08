<%--
**********************************************
* 메뉴 : 회원사관리>고객사관리>법인그룹관리 조회
* 화면 : 법인그룹관리 조회
* 기능 : 고객사의 등록 상태별 목록 조회
* 프로그램 ID : PG_01_M_016_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-15
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
<%
String user_id = _sessionInfo.getUserId();
boolean getRoleYn = CommonUtil.getCodeCheckReturn("BGRM", user_id);

%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
					 {Align:"Center",	SaveName:"sStatus",			Header:"상태",			Type:"Status",			Width:60,		Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:60,		Edit:true,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"CORP_CODE",		Header:"법인코드",		Type:"Text",				Width:100,	Edit:false,	EditLen:6,		Hidden:false,		KeyField:true,		BackColor:"${notnullColor}"}
					,{ Align:"Left",	SaveName:"CORP_NAME",		Header:"법인명",			Type:"Text",				Width:300,	Edit:true,	EditLen:200,	Hidden:false,		KeyField:true,		BackColor:"${notnullColor}"}
					,{ Align:"Center",	SaveName:"GROUP_CODE",	Header:"그룹코드",		Type:"Text",				Width:160,	Edit:true,	EditLen:100,	Hidden:true}
					,{ Align:"Left",	SaveName:"GROUP_NAME",	Header:"고객사그룹",	Type:"Text",				Width:300,	Edit:false,	EditLen:100,	Hidden:false,		KeyField:true,		BackColor:"${notnullColor}"}
					,{ Align:"Center",	SaveName:"ADD_USER_ID",	Header:"생성자",			Type:"Text",				Width:120,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"ADD_DATE",		Header:"생성일자",		Type:"Text",				Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"USE_FLAG",			Header:"사용여부",		Type:"Combo",			Width:80,		Edit:true,	EditLen:1,		Hidden:false,		KeyField:true,		BackColor:"${notnullColor}",	ComboText:"Y|N",	ComboCode:"Y|N"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "GROUP_NAME");	//고객사코드
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str =="del" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mdct/getMasterMdCtCorpGroupManageList.do" , pagingMode );
			break;
		case "insert":	 // 조회
			var rows = mySheet.DataInsert(-1);
			mySheet.SetCellEditable(rows, 'CORP_CODE', 1);
			mySheet.SelectCell(rows, "CORP_CODE");
			break;	
		case "reload":	// 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case "save": // 수정
			if (checkSubmit()) {
				kepSave(document.searchCondition, mySheet, "/mdct/saveMasterMdCtCorpGroupManageList.do", -1 );
			}
			break;
		case "corpCheck":			// 법인코드 중복체크
			kepAjaxFormCall("/mdct/getMasterMdCtCorpGroupManageCorpCheck.do", "searchCondition", str);
			break;
		case "del":					// 법인코드 삭제
			if (chk_except()) {
				kepSave(document.searchCondition, mySheet, "/mdct/deleteMasterMdCtCorpGroupManageList.do", 1);
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
		for (var i=arrRow.length -1; i >= 0; i--) {
			if (mySheet.GetCellValue(arrRow[i], "sStatus") == "I") {
				mySheet.RowDelete(arrRow[i], 0);
			} else {
				if (kepTrimStr(mySheet.GetCellValue(arrRow[i], "CORP_CODE")) != "") {
					exceptArr += mySheet.GetCellValue(arrRow[i], "CORP_CODE") + "@@";
				}
			}
		}
		
		if (exceptArr == "") { return false };

		$("#st_corp_code").val(exceptArr);
		conf = confirm("법인그룹을 삭제하시겠습니까?");
	}
	return conf;
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

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
	kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdCtCorpGroupManageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val) {
	popupSel = str;
	
	switch (str) {
		case "groupChoice": // 고객사 M
			openSearchPopup("/mdct/showMasterMdCtBuyerGroupChoicePop.do", "?1=1", "500,500,no");
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'GROUP_NAME') { // 요청자
		doPop("groupChoice", mySheet.GetCellValue(Row,"GROUP_CODE"));
	}
	return;
}

function mySheet_OnChange(Row, Col, Value) {

	if ( Row  < 1) return;

	var column = mySheet.ColSaveName(Col);
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'CORP_CODE') { // 요청자
		if (kepTrimStr(Value) != "") {
			if ( mySheet.GetCellValue(Row, "CORP_CODE").length < chkKorea(mySheet.GetCellValue(Row, "CORP_CODE"))) {
				alert("법인코드에 한글을 입력할수 없습니다.");
				mySheet.SetCellValue(Row, "CORP_CODE", "", 0);
				mySheet.SelectCell(Row, "CORP_CODE");
				return;
			}
			
			$("#st_corp_code").val(Value.toUpperCase());
			mySheet.SetCellValue(Row, "CORP_CODE", Value.toUpperCase(), 0);
			doAction("corpCheck");
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

	if ( code > 0 ) {
		//저장 성공시 처리
		doAction("search");
	}
	$("#st_corp_code").val("");
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	if (pMethod == "corpCheck") {
		if (sMsg != "0") {
			alert("중복된 법인코드가 있습니다.");
			mySheet.ReturnCellData(grbRow, "CORP_CODE");
			mySheet.SelectCell(grbRow, "CORP_CODE");
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
	if (popupSel == "groupChoice") {	// 다중 고객사
		mySheet.SetCellValue(grbRow,"GROUP_CODE", code);
		mySheet.SetCellValue(grbRow,"GROUP_NAME", text);
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

function checkSubmit() {
	if (!checkRow()) return false;
	
	for (var i = 1; i <= mySheet.RowCount(); i++ ) {

		if (mySheet.GetCellValue(i, "sStatus") != 'R' ) {
			if (kepTrimStr(mySheet.GetCellValue(i, "CORP_CODE")) == "") {
				alert("법인코드를 입력해주세요.");
				mySheet.SelectCell(i, "CORP_CODE");
				return false;
			}
			
			if ( mySheet.GetCellValue(i, "CORP_CODE").length < chkKorea(mySheet.GetCellValue(i, "CORP_CODE"))) {
				alert("법인코드에 한글을 입력할수 없습니다.");
				mySheet.SelectCell(i, "CORP_CODE");
				return false;
			}
			
			if (kepTrimStr(mySheet.GetCellValue(i, "CORP_NAME")) == "") {
				alert("법인명을 입력해주세요.");
				mySheet.SelectCell(i, "CORP_NAME");
				return false;
			}
			
			if (!fnCheckInputByteStr(mySheet.GetCellValue(i, "CORP_NAME"), 200)) {
				alert("법인명은 영문 200자, 한글 100자 까지 입력할수 있습니다.");
				mySheet.SelectCell(i, "CORP_NAME");
				return false;
			}

			if (kepTrimStr(mySheet.GetCellValue(i, "GROUP_CODE")) == "") {
				alert("그룹을 선택해주세요.");
				mySheet.SelectCell(i, "GROUP_CODE");
				return false;
			}

		}
	}
	
	var conf = confirm("법인정보를 저장하시겠습니까?");
	return conf;
}

</script>
</head>
<%
@SuppressWarnings (value="unchecked")

String userID = _sessionInfo.getUserId();
%>
<body onload="kep_onload_view()">
	<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>법인그룹관리 조회</h3>
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
					<caption>법인그룹관리 조회</caption>
					<colgroup>
						<col width="8%" />
						<col width="92%" />
					</colgroup>
						
					<tbody>
						<tr> 
							<td>법인명</td>
							<td style="text-align:left;">
								<input type="text" id="st_corp_name" name="st_corp_name" class="input_type_text" style="width:30%" value=""  onkeydown="kepEnter();" />
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
  		<div class="btnArea">
  		<% if (getRoleYn == true) { %>
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('insert');">행추가</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
				<span class="btn_02"><a href="javascript:doAction('del');">삭제</a></span>
			</span>
		<% } %>
		</div>
		<!--내용 종료-->                 
</body>
</html>
