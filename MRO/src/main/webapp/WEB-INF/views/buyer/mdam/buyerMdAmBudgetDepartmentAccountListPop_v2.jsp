<%--
**********************************************
* 메뉴 : 예산계정연결 추가 팝업
* 화면 : 예산계정연결 추가 팝업
* 기능 : 예산계정연결 추가 팝업
* 프로그램 ID : BU1005011
* 담당자 : 최찬규 
* 착수일 : 2026-03-16
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="java.sql.Timestamp"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");
String tab_id = CommonUtil.nvl((String) request.getParameter("tab_id"),""); // tab_id
String db_dept_code = CommonUtil.nvl((String) request.getParameter("db_dept_code"),"");
String dept_nm = CommonUtil.nvl((String) request.getParameter("dept_nm"),"");

%>  
<script type="text/javascript">

var mySheet0 = new ibsheetObject();
var mySheet1 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

</script>


<body onload="javascript:kep_onload();">
<form name="getDeptPop" id="getDeptPop" method=post >
<div class="wrapPopup"  >
	<input type="hidden" name="s_SAVENAME" />
	<input type="hidden" name="codeGubun" id="codeGubun"  value="commonCoCoAccountPop_v2">
	<input type="hidden" name="st_com_code" id="st_com_code"  value="<%=st_com_code%>">
	<input type="hidden" name="db_buyer_code" id="db_buyer_code"  value="<%=st_com_code%>">
	<input type="hidden" name="st_type" id="st_type"  value="C001">
	<input type="hidden" name="st_dept_type" id="st_dept_type" value="B">
	<input type="hidden" name="st_req_dept_name" id="st_req_dept_name" value="">
	<input type="hidden" name="db_dept_code" id="db_dept_code" value="<%=db_dept_code%>">
	<input type="hidden" name="st_dept_code" id="st_dept_code" value="<%=db_dept_code%>">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	
  <div class="PopupTit"><%=CommonLang.get("HTITLE1138")%><!--계정연결--><span><a href="javascript:self.close()" class="closePopup"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="Popup_GrayBox" style="padding: 10px;">'<%=dept_nm%>' <%=CommonLang.msg("MSG710")%><!--에 연결할 예산계정을 선택해주세요.--> <%=CommonLang.msg("MSG720")%><!-- 연결할 예산계정을 검색하여 선택한 후 저장하면, 해당 예산부서의 예산계정으로 등록됩니다.-->
  </div>

  <div class="BudgetPopBox">
    <div class="BudgetPopTitBox mt15"> <%=CommonLang.get("HTITLE966") %> <!-- 예산계정 -->
      <div class="SearchPopupInput32">
        <input type="text" placeholder="<%=CommonLang.msg("MSG711")%>" id="st_keyword" name="st_keyword" style=" width:85%; vertical-align: top;" onKeyDown="kepEnter_v2()"><!-- 계정코드 , 계정명으로 검색하세요 -->
        <button type="button" onclick="javascript:doAction('search')"><%=CommonLang.get("HTITLE511") %><!-- 검색 --></button>
      </div>      
      <div class="BudgetPopTit"><%=CommonLang.get("HTITLE1151")%><!--연결 예산계정--></div>
    </div>
    <div class="BudgetPop" style="width:450px; height:400px;">
      <script type="text/javascript">
			createIBSheet("mySheet0", "100%", "100%");
	  </script>    
    </div>
    <div class="BudgetPopBtn" style="width:80px;  "><button class="ArrowRight" id=" " onclick="javascript:moveToBudgetDept(); return false;" ></button></div>
    <div class="BudgetPop" style="width:700px; height:400px;">
      <script type="text/javascript">
			createIBSheet("mySheet1", "100%", "100%");
	  </script>   
    </div>   
  </div>  
  <div class="PopupListBtnBox_Center mt20"><button class="ButPrimary_large"  onclick="javascript:insertBudgetDeptAccountConfirm(); return false;"><%=CommonLang.get("HTITLE124") %><!-- 저장 --></button></div>         
</div><!-- wrapPopup 끝-->  
</form>
</body> 
<script type="text/javascript">

// var getMultiApprFlag = "";
function kep_onload(){
	var initsheet0 = {};
	initsheet0.HeaderMode={ColResize:0, ColMove:0};
	initsheet0.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet0.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"SELECTED",			Header:"",				Type:"DummyCheck",	Width:40,	Edit:true,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"CODE",				Header:"<%=CommonLang.get("HTITLE984")%>",				Type:"Text",		Width:110,	Edit:false,	EditLen:100,	Hidden:false}/*예산계정코드*/
			,{ Align:"Left",	SaveName:"TEXT1",				Header:"<%=CommonLang.get("HTITLE966")%>",				Type:"Text",		Width:280,	Edit:false,	EditLen:100,	Hidden:false}/*예산계정*/
	];

	var initsheet1 = {};
	initsheet1.HeaderMode={ColResize:0, ColMove:0};
	initsheet1.Cfg = {MergeSheet:msHeaderOnly, RowHeightResize:0,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet1.Cols = [
			{ Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"SELECTED",			Header:"",				Type:"DummyCheck",	Width:70,	Edit:true,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"ACCOUNT_CODE",				Header:"<%=CommonLang.get("HTITLE984")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*예산계정코드*/
			,{ Align:"Left",	SaveName:"ACCOUNT_NAME",				Header:"<%=CommonLang.get("HTITLE966")%>",				Type:"Text",		Width:280,	Edit:false,	EditLen:100,	Hidden:false}/*예산계정*/
			,{ Align:"Center",	SaveName:"GUBUN",				Header:"<%=CommonLang.get("HTITLE1150")%>",				Type:"CheckBox",		Width:250,	Edit:true, EditLen:10,	Hidden:false, ItemText:"<%=CommonLang.get("HTITLE1136")%>|<%=CommonLang.get("HTITLE1137")%>",  ItemCode:"Y|N", MaxCheck:1, RadioIcon:1} /*사용구분*/
			,{ Align:"Center",	SaveName:"DELETE",				Header:"<%=CommonLang.get("HTITLE25")%>",					Type:"Image",		Cursor:"Pointer",Width:70,	Edit:false,	EditLen:100,	Hidden:false, ImgHeight:15}/*삭제*/

	];


	IBS_InitSheet(mySheet0, initsheet0, pagingMode);
	IBS_InitSheet(mySheet1, initsheet1, pagingMode);

	mySheet0.SetHeaderBackColor("#f2f7ff");
	mySheet1.SetHeaderBackColor("#f2f7ff");
	
	mySheet0.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
	mySheet1.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
	
	mySheet0.SetTheme("DB", "DeepBlue");
	mySheet1.SetTheme("DB", "DeepBlue");
	
	kepSearch(document.getDeptPop, mySheet0, "/common/commonList_v3.do" , pagingMode);
}
function doAction(str) {
	

	switch (str) {
		case "search":	 // 조회
			kepSearch(document.getDeptPop, mySheet0, "/common/commonList_v3.do" , pagingMode);
			break;
	}
}
//조회 후처리
function mySheet0_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	kepSearch(document.getDeptPop, mySheet1, "/mdam/getBuyerMdAmDepartmentAccountList_v2.do" , pagingMode);
}
//조회 후처리
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	var rowCount0 = mySheet0.RowCount();
	var rowCount1 = mySheet1.RowCount();
	//이미 예산부서 리스트에 있는 부서는 체크불가능
	for(var i = 1; i<= rowCount0; i++){
		for(var j = 1;j <=rowCount1;j++){
			if(mySheet0.GetCellValue(i, "CODE") == mySheet1.GetCellValue(j, "ACCOUNT_CODE")){
				mySheet0.SetCellEditable(i, "SELECTED", false);
				break;
			}
		}
	}
	
	for(var i = 1; i<=rowCount1; i++){
		mySheet1.SetCellValue(i, "DELETE", "/resources/imgs/Icon_close03.png");
	}
}
//그리드 셀클릭 이벤트
function mySheet0_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet0.ColSaveName(mySheet0.GetSelectCol());
	
	if(column != "SELECTED"){
		if(mySheet0.GetCellEditable(Row,"SELECTED") == 1){
			mySheet0.SetCellValue(Row,"SELECTED",true);
		}
	}
	return;
}
//그리드 셀클릭 이벤트
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet1.ColSaveName(mySheet1.GetSelectCol());
	
	if(column == "DELETE"){
		mySheet1.RenderSheet(0);
		
		//삭제할 부서는 다시 전체부서에서 체크가능하도록
		var rowCount = mySheet0.RowCount();
		for(var i = 1;i<=rowCount;i++){
			if(mySheet0.GetCellValue(i, "CODE") == mySheet1.GetCellValue(Row, "ACCOUNT_CODE")){
				mySheet0.SetCellEditable(i, "SELECTED", true);
				break;
			}
		}
		mySheet1.RowDelete(Row);
		mySheet1.RenderSheet(1);
	}
	return;
}
//트랜젝션(저장,삽입등) 후처리
function mySheet1_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if ( msg != "" ) {
		if ( code > 0 ) {
			//저장 성공시 처리
			var text = msg.msg;
			openLayerPopText2(text,but1text,but1funcSearch,but1width);
		}else{
			var text = msg.msg;
			openLayerPopText2(text,but1text,but1func,but1width);
		}
	}
	
}
function thisPopClose(){
	var tab_id = "<%=tab_id%>";
	opener.tabs[tab_id]["search2"]();
	self.close();
}
function moveToBudgetDept(){
    
	var checkRows = mySheet0.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	if(checkRows == ""){
// 		alert("선택된 항목이 없습니다.");
		var text = "<%=CommonLang.msg("MSG78")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	mySheet0.RenderSheet(0);
	mySheet1.RenderSheet(0);
	for(var i = 0; i<arrRow.length; i++){
		
		var newIndex = 0;
		newIndex = mySheet1.DataInsert(-1);
		mySheet1.SetCellValue(newIndex, "ACCOUNT_CODE",mySheet0.GetCellValue(arrRow[i],"CODE"));
		mySheet1.SetCellValue(newIndex, "ACCOUNT_NAME",mySheet0.GetCellValue(arrRow[i],"TEXT1"));
		mySheet1.SetCellValue(newIndex, "GUBUN","Y");
		mySheet1.SetCellValue(newIndex, "DELETE", "/resources/imgs/Icon_close03.png");

		//전체에서는 체크 해제
		mySheet0.SetCellValue(arrRow[i],"SELECTED",false);
		mySheet0.SetCellEditable(arrRow[i],"SELECTED",false);
	}
	
	mySheet0.RenderSheet(1);
	mySheet1.RenderSheet(1);
	
}

function insertBudgetDeptAccountConfirm(){
	//설정한 내용으로 반영하시겠습니까?
	var text = "<%=CommonLang.msg("MSG632")%>";
	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	var but1funcC = "javascript:insertBudgetDeptAccount(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
// 	if(!confirm("설정한 내용으로 반영하시겠습니까?")){
// 		return;
// 	}
}
function insertBudgetDeptAccount(){
	closePopText1();
	for(var i = 1; i<=mySheet1.RowCount(); i++){
		mySheet1.SetCellValue(i,"SELECTED",true);
	}
	kepSave(document.getDeptPop, mySheet1, "/mdam/saveBuyerMdAmBudgetDepartmentAccountListPop_v2.do", "SELECTED");
}
</script>
