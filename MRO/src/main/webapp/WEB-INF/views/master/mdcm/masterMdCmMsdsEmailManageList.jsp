<%--
**********************************************
* 메뉴(운영사) : 카탈로그관리 >물질정보 관리 >MSDS 메일수신자 관리
* 화면 : MSDS 메일수신자 관리
* 기능 : MSDS 메일 수신자 등록/수정/삭제
* 프로그램 ID : 
* 담당자 : 한승준
* 착수일 : 2019-04-25
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
		{ Align:"Center",	Width:60,	Edit:false,		EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus"}
		,{ Align:"Center",	Width:40,	Edit:true,		EditLen:30,		Hidden:false,	Type:"DummyCheck",	Header:"",			SaveName:"SELECTED"}
		,{ Align:"Center",	Width:60,	Edit:false,		EditLen:0,		Hidden:true,	Type:"Text",		Header:"순번",		SaveName:"SEQ"}
		,{ Align:"Center",	Width:100,	Edit:false,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"고객사코드",		SaveName:"BUYER",			KeyField:true,	Sort:0}
		,{ Align:"Left",	Width:200,	Edit:false,		EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사명",		SaveName:"BUYER_NAME",		KeyField:true,	Sort:0}
		,{ Align:"Left",	Width:100,	Edit:true,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"수신자명",		SaveName:"RECV_USER_NAME",	KeyField:true}
		,{ Align:"Left",	Width:200,	Edit:true,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"수신자이메일",	SaveName:"RECV_EMAIL",		KeyField:true}
		,{ Align:"Left",	Width:400,	Edit:true,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"비고",		SaveName:"REMARK"}
		,{ Align:"Center",	Width:100,	Edit:false,		EditLen:20,		Hidden:true,	Type:"Text",		Header:"등록자ID",		SaveName:"ADD_USER_ID"}
		,{ Align:"Center",	Width:100,	Edit:false,		EditLen:20,		Hidden:false,	Type:"Text",		Header:"등록자명",		SaveName:"ADD_USER_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,		EditLen:20,		Hidden:false,	Type:"Date",		Header:"등록일",		SaveName:"ADD_DATE"}
		,{ Align:"Center",	Width:100,	Edit:false,		EditLen:20,		Hidden:true,	Type:"Text",		Header:"수정자ID",		SaveName:"CHANGE_USER_ID"}
		,{ Align:"Center",	Width:100,	Edit:false,		EditLen:20,		Hidden:false,	Type:"Text",		Header:"수정자명",		SaveName:"CHANGE_USER_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,		EditLen:20,		Hidden:false,	Type:"Date",		Header:"수정일",		SaveName:"CHANGE_DATE"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER");	//고객사
	setLinkCol(mySheet, "BUYER_NAME");	//고객사명
	
	// 복사기능 언더라인
	mySheet.SetCellFontUnderline(0, "BUYER", true);
	mySheet.SetCellFontUnderline(0, "BUYER_NAME", true);
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if ( str != "search" && str != "reload" && str != "add" && selectedGrid.length == 0 ) {
		alert("<%=CommonLang.msg("MSG78")%>");	//선택된 항목이 없습니다.
		return;
	}
	
	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mdcm/getMasterMdCmMsdsEmailManageList.do", pagingMode);
			break;
		case "reload":	// 초기화
			$("#re_current_page").val(1);
			$( '#searchCondition')[0].reset();
			mySheet.RemoveAll();
			$("#st_buyer_code").val("");
			$("#st_buyer_name").val("");
			break;
		case "add": // 추가
			var rows = mySheet.DataInsert(-1);
			mySheet.SetCellValue(rows, "SELECTED", "1");
			break;
		case "save": // 저장
			if ( !confirm('<%=CommonLang.msg("MSG292")%>') )	//선택한 항목을 저장 하시겠습니까?
				return;
			if ( !beforeProcessSave() )
				return;
			kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMdCmMsdsEmailManageList.do" , "SELECTED" );
			break;
		case "del": // 삭제
			if ( !confirm('<%=CommonLang.msg("MSG293")%>') )	//선택한 항목을 삭제 하시겠습니까?
				return;
			if ( !beforeProcessDelete() )
				return;
			kepSave(document.searchCondition ,  mySheet , "/mdcm/delMasterMdCmMsdsEmailManageList.do" , "SELECTED" );
			break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
   	
	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
	
	if(code>=0){
		//저장 성공시 재조회
		doAction('search');
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
    pagingMode = "P";
	current_page = param.page;
	$("#re_current_page").val(current_page);
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmMsdsEmailManageList.do?page="+current_page , pagingMode );
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "buyer_single": // 조회조건 고객사 클릭
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
		case "buyer_single_grid": // 그리드 고객사 클릭
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
	}
}
	
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if(column == 'BUYER' || column == 'BUYER_NAME'){ // 고객사
		doPop("buyer_single_grid");
	}

	return;
}

//헤더 더블클릭시 복사
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	if (checkRows.length == 0){
		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	var arrRow = checkRows.split("|");
	
	if (mySheet.ColSaveName(Col) == "BUYER"){ // 고객사코드
		var value1 = mySheet.GetCellValue(arrRow[0], "BUYER");
		var value2 = mySheet.GetCellValue(arrRow[0], "BUYER_NAME");
		if(kepIsValueNull(value1)){
			alert("복사할 고객사코드를 선택하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "BUYER", value1);
			mySheet.SetCellValue(arrRow[idx], "BUYER_NAME", value2);
		}
	} else if (mySheet.ColSaveName(Col) == "BUYER_NAME"){ // 고객사명
		var value1 = mySheet.GetCellValue(arrRow[0], "BUYER");
		var value2 = mySheet.GetCellValue(arrRow[0], "BUYER_NAME");
		if(kepIsValueNull(value1)){
			alert("복사할 고객사명을 선택하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "BUYER", value1);
			mySheet.SetCellValue(arrRow[idx], "BUYER_NAME", value2);
		}
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}
	if (popupSel == "buyer_single_grid") {	// 고객사
		mySheet.SetCellValue(grbRow, "BUYER", value1);
		mySheet.SetCellValue(grbRow, "BUYER_NAME", value2);
	}
	grbRow="";	//초기화
}

//저장 선행 처리
function beforeProcessSave() {
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			var cell_status = mySheet.GetCellValue(i, "sStatus");
			
			if(cell_status == "R"){ // 변경사항 없음
				alert("변경사항이 없는 행이 선택되었습니다.");
				return false;
			}
		}
	}
	return true;
}

//행삭제 선행 처리
function beforeProcessDelete() {
	for ( var i = mySheet.RowCount(); i >= 1; i-- ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 && mySheet.GetCellValue(i, "sStatus") == 'I' ) {
			mySheet.RowDelete(i, 0);
		}
	}
	
	if ( mySheet.FindCheckedRow("SELECTED").length == 0 ) {
		return false;
	}
	return true;
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>MSDS 메일수신자 관리</h3>
		<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
	    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	</div>        	
        
	<!--조회영역-->
	<form name = "searchCondition" id="searchCondition" method = "post" onsubmit="return false" >
		<div id="cont_searchA">
		<!--HIDDEN-->
		<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<input type="hidden" name="st_all_po"  id="st_all_po" value ="N">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="re_current_page" name="re_current_page"  value="">
			
			<table  class="cont_t_list01">
				<caption></caption>
				<colgroup>
					<col width="8%" />
				    <col width="25%" />
				    <col width="8%" />
				    <col width="25%" />
				    <col width="8%" />
				    <col width="25%" />
		    	</colgroup>
		    	
		    	<tbody>
		      		<tr>
						<th>고객사</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:67%;" value = "" READONLY><!-- KRKOLO0031 -->
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" value ="">
							<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th>수신자명</th>
						<td><input type="text" class="input_type_text" id="st_recv_user_name" name="st_recv_user_name" style="width:87%;" value=""></td>
						<th></th>
						<td></td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;">
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
	<div class="btnArea">
		<span class="fr">
			<span class="btn_02 mr04"><a href="javascript:doAction('add');"><%=CommonLang.get("HTITLE36")%><!-- 행추가 --></a></span>
			<span class="btn_02 mr04"><a href="javascript:doAction('save');"><%=CommonLang.get("HTITLE124")%><!-- 저장 --></a></span>
			<span class="btn_02"><a href="javascript:doAction('del');"><%=CommonLang.get("HTITLE25")%><!-- 삭제 --></a></span>
		</span>
	</div>
<!--내용 종료-->	                 
</body>
</html>
