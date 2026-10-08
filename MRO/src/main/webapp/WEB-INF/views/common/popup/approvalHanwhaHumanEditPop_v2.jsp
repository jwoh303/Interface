<%--
**********************************************
* 메뉴 :  결재
* 화면 : 결재경로관리 팝업 (한화)
* 기능 : 결재경로관리 팝업 (한화)
* 프로그램 ID : BU0701003
* 담당자 : 최찬규
* 착수일 : 2026-03-30
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과

String USER_NAME_LOC = CommonUtil.nvl((String) request.getParameter("USER_NAME_LOC"),"");  //  (조회조건
String USER_FLAG = CommonUtil.nvl((String) request.getParameter("USER_FLAG"),"");  //  (조회조건  
String DOCU_NO = CommonUtil.nvl((String) request.getParameter("DOCU_NO"),"");  //  (조회조건
String PLANT = CommonUtil.nvl((String) request.getParameter("PLANT"),"");  //  (조회조건  
String PASS_LINE_FLAG = CommonUtil.nvl((String) request.getParameter("PASS_LINE_FLAG"),"N");  //나의 결재경로 리스트 보여주는지 여부 YN
String APP_PATH = CommonUtil.nvl((String) request.getParameter("APP_PATH"),"");  //상신팝업에서 넘어온 선택한 결재선
String SUBJECT = CommonUtil.nvl((String) request.getParameter("SUBJECT"),"");  //상신팝업에서 넘어온 선택한 결재선
String info = CommonUtil.nvl((String)request.getParameter("info"), ""); //상신팝업에서 넘어온 결재선
if(info == null || info.equals("")) info = "[]"; //null 방지

String passLineFlag = "N"; //디폴트 결재라인을 불러와야함
if(!DOCU_NO.equals("")){
	passLineFlag = "Y"; //해당 문서의 결재라인을 불러와야함
}

List<Map<String,String>> _list = (List<Map<String,String>>) request.getAttribute("approvalLine"); // 조회된결과
int _listSize = 0;
String defaultAppPath = APP_PATH;
String defaultAppSubject = SUBJECT;
if(defaultAppPath.equals("")){
	if(_list != null && _list.size() > 0){
		_listSize = _list.size();
		for(int i = 0; i<_list.size(); i++){
			if(_list.get(i).get("DEFAULT_FLAG").equals("Y")){
				defaultAppPath = _list.get(i).get("APP_PATH");
				defaultAppSubject = _list.get(i).get("SUBJECT");
			}
		}
		if(defaultAppPath.equals("")){ //기본결재선 없으면 첫번째 결재선 노출
			defaultAppPath = _list.get(0).get("APP_PATH");
			defaultAppSubject = _list.get(0).get("SUBJECT");
		}
	}
}

String COMPANY = "";
String SessionUserId = "";
if (_sessionInfo != null){  
	COMPANY =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 
	SessionUserId =  CommonUtil.nvl((String)_sessionInfo.getUserId()); 
} 

//p060000096 본인 결재선 지정
boolean p060000096= CommonUtil.getSpecialCheckReturn(COMPANY,"P06-0000096");

String myApprovalYn = "N";
//본인결재가 가능한 고객사 특수로직 : 코웨이, 일진다이아몬드
if (p060000096 == true){
	myApprovalYn = "Y";
}
//SLOGIC-END 
%>
<script type="text/javascript"> 

//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1funcReload = "javascript:thisPopReload(); return false;";
var but1width = "120px";

var mySheet1 = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N";

function kepOnload(){
	
	var initsheet1 = {};
	initsheet1.HeaderMode={HeaderCheck:0};
	initsheet1.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet1.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}/*상태*/
			 ,{ Align:"Center",	SaveName:"SELECTED",			Header:"<%=CommonLang.get("HTITLE178")%>",					Type:"CheckBox",	Width:60,	Edit:true,	EditLen:100,	Hidden:false}/*선택*/
			 ,{ Align:"Center",	SaveName:"USER_NAME_LOC",					Header:"<%=CommonLang.get("HTITLE325")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false} /*이름*/
			,{ Align:"Center",	SaveName:"POSITION",		Header:"<%=CommonLang.get("HTITLE476")%>",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false} /*직급*/
			,{ Align:"Center",	SaveName:"DEPARTMENT",		Header:"<%=CommonLang.get("HTITLE329")%>",				Type:"Text",		Width:130,	Edit:false,	EditLen:100,	Hidden:false} /*부서*/
			
			,{ Align:"Center",	SaveName:"LEGACY_USER_ID",				Header:"LEGACY_USER_ID",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PASS_KN",				Header:"PASS_KN",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			
// 			,{ Align:"Center",	SaveName:"LEGACY_USER_ID",				Header:"LEGACY_USER_ID",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"POSITION_CODE",				Header:"POSITION_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"DEPT_CODE",				Header:"DEPT_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PLANT",				Header:"PLANT",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"EMP_NO",				Header:"EMP_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"POSITION_EN",				Header:"POSITION_EN",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"DEPT_ID",				Header:"DEPT_ID",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"DEPT_PATH",				Header:"DEPT_PATH",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"DEPT_EN",				Header:"DEPT_EN",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
	];
	
	IBS_InitSheet(mySheet1, initsheet1, pagingMode);
	mySheet1.SetHighlightAfterSort(2);
	
	mySheet1.SetHeaderBackColor("#f2f7ff");
	mySheet1.SetTheme("DB", "DeepBlue");
	
	var initsheet2 = {};
	initsheet2.HeaderMode={Sort:0,HeaderCheck:0};
	initsheet2.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet2.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}/*상태*/
			 ,{ Align:"Center",	SaveName:"SELECTED",			Header:"<%=CommonLang.get("HTITLE178")%>",					Type:"CheckBox",	Width:60,	Edit:true,	EditLen:100,	Hidden:true}/*선택*/
			 ,{ Align:"Center",	SaveName:"ORDER_SEQ",			Header:"<%=CommonLang.get("HTITLE1064")%>",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false} /*순서*/
			,{ Align:"Center",	SaveName:"GUBUN",				Header:"<%=CommonLang.get("HTITLE314")%>",				Type:"Combo",		Width:90,	Edit:true,	EditLen:100,	Hidden:false, ComboText:"<%=CommonLang.get("HTITLE310")%>|<%=CommonLang.get("HTITLE792")%>|<%=CommonLang.get("HTITLE311")%>",ComboCode:"C|H|R"}/*결재|합의|참조*/ /*구분*/
			,{ Align:"Center",	SaveName:"PASS_TP",		Header:"<%=CommonLang.get("HTITLE314")%>",				Type:"Combo",		Width:90,	Edit:false,	EditLen:100,	Hidden:true, ComboText:"<%=CommonLang.get("HTITLE310")%>|<%=CommonLang.get("HTITLE792")%>|<%=CommonLang.get("HTITLE311")%>",ComboCode:"1|3|2"}/*결재|합의|참조*/ /*구분*/
			,{ Align:"Center",	SaveName:"APPR_NAME",			Header:"<%=CommonLang.get("HTITLE325")%>",				Type:"Text",		Width:160,	Edit:false,	EditLen:100,	Hidden:false} /*이름*/
			,{ Align:"Center",	SaveName:"POSITION",			Header:"<%=CommonLang.get("HTITLE476")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false} /*직급*/
			,{ Align:"Center",	SaveName:"DEPT",				Header:"<%=CommonLang.get("HTITLE329")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}/*부서*/
			,{ Align:"Center",	SaveName:"DELETE",			Header:"<%=CommonLang.get("HTITLE25")%>",				Type:"Image",		Width:60,	Edit:false,	EditLen:100,	Hidden:false, Cursor:"Pointer", ImgHeight:15}/*삭제*/

			 ,{ Align:"Center",	SaveName:"GUBUN_TEXT",			Header:"<%=CommonLang.get("HTITLE314")%>",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:true}/*구분*/
			,{ Align:"Center",	SaveName:"PASS_KN",				Header:"PASS_KN",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"APPR_ID",				Header:"APPR_ID",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"APPR_USER_ID",		Header:"APPR_USER_ID",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}

	];

	IBS_InitSheet(mySheet2, initsheet2, pagingMode);
	mySheet2.SetHighlightAfterSort(2);
	
	mySheet2.SetHeaderBackColor("#f2f7ff");
	mySheet2.SetTheme("DB", "DeepBlue");
    
	
	var passLineFlag = "<%=passLineFlag%>";
	if(passLineFlag == "N"){ //디폴트 결재라인 불러오기
		var appPath = "<%=defaultAppPath%>";
		var appSubject = "<%=defaultAppSubject%>";
		
		if("<%=APP_PATH%>" != ""){
			$("#APP_PATH").val(appPath);
			
			const selectText = document.querySelector(".select-text");
			selectText.textContent = appSubject;
			kepSearch(document.approvalHumanEditPop, mySheet2, "/common/approval/getMultiPassLine_v2.do" ,pagingMode);
		}else{ //여기서 이미 선택해서 갔거나, 결재선이 없는 경우
			var info = <%=info%>;
			if(info.length != 0){ //넘어온 결재라인(사람들) 있을 때 해당 사람들로 만들어주기
				const selectText = document.querySelector(".select-text");
				selectText.textContent = "";
				setCurrentPassLine();
			}else{
				$("#APP_PATH").val(appPath);
				
				const selectText = document.querySelector(".select-text");
				selectText.textContent = appSubject;
				kepSearch(document.approvalHumanEditPop, mySheet2, "/common/approval/getMultiPassLine_v2.do" ,pagingMode);
			}
		}
		
		
		
	}else{ //해당 문서 결재라인 불러오기
		kepSearch(document.approvalHumanEditPop, mySheet2, "/common/approval/getCurrentPassLine_v2.do" ,pagingMode);
	}
}

function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	for(var i = 1; i<= mySheet1.RowCount(); i++){
		for(var j = 1;j <=mySheet2.RowCount();j++){
			if(mySheet1.GetCellValue(i, "LEGACY_USER_ID") == mySheet2.GetCellValue(j, "APPR_ID")){
				mySheet1.SetCellEditable(i, "SELECTED", false);
				break;
			}
		}
	}
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	for(var i = 1; i<=mySheet2.RowCount(); i++){
		if(mySheet2.GetCellValue(i,"PASS_KN")==""){
// 			mySheet2.SetCellValue(i, "DELETE", "/resources/imgs/Icon_WasteBasket.png");
			mySheet2.SetCellValue(i, "DELETE", "/resources/imgs/Icon_close03.png");
			
		}
		if(mySheet2.GetCellValue(i,"PASS_KN")=="1"){
			mySheet2.SetCellEditable(i,"GUBUN",false);
		}
	}
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
//그리드 셀클릭 이벤트
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	
	if(column == "DELETE"){
		if(mySheet2.GetCellValue(Row,"PASS_KN")=="1"){ //결재된사람들은 제외
			return;
		}
		mySheet2.RenderSheet(0);
		
		//삭제할 메뉴는 다시 전체메뉴에서 체크가능하도록
		for(var i = 1;i<=mySheet1.RowCount();i++){
			if(mySheet1.GetCellValue(i, "LEGACY_USER_ID") == mySheet2.GetCellValue(Row, "APPR_ID")){
				mySheet1.SetCellEditable(i, "SELECTED", true);
				break;
			}
		}
		mySheet2.RowDelete(Row);
		mySheet2.RenderSheet(1);
		
		setOrderSeq();
	}
	return;
}
function getApprUserMap(arrRow){
	var legacyIds = "";
	for(var i = 0; i<arrRow.length; i++){
		if(i > 0){
			legacyIds += ",";
		}
		legacyIds += mySheet1.GetCellValue(arrRow[i],"LEGACY_USER_ID");
	}

	var userMap = {};
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mpso/getHanwhaAppUserIds_v2.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: { LEGACY_USER_IDS : legacyIds },
		async: false,
		success: function( response ) {
			if(response.userMap){
				userMap = response.userMap;
			}
		}
	});

	return userMap;
}
//트랜젝션(저장,삽입등) 후처리
function mySheet1_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if ( msg != "" ) {
		if ( code > 0 ) {
			//저장 성공시 처리
			mySheet1.RenderSheet(0);
			mySheet2.RenderSheet(0);
			
			var checkRows = mySheet1.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			
			if(checkRows == ""){
				//선택된 항목이 없습니다.
				var text = "<%=CommonLang.msg("MSG78")%>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}

			var apprUserMap = getApprUserMap(arrRow);
			for(var i = 0; i<arrRow.length; i++){
				if(!apprUserMap[mySheet1.GetCellValue(arrRow[i],"LEGACY_USER_ID")]){
					mySheet1.RenderSheet(1);
					mySheet2.RenderSheet(1);
					var text = mySheet1.GetCellValue(arrRow[i],"USER_NAME_LOC") + "<%=CommonLang.msg("MSG996")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
			}

			for(var i = 0; i<arrRow.length; i++){

				//이미 포함되어있는지 체크
				for(var j = 0; j<mySheet2.RowCount(); j++){
					if(mySheet1.GetCellValue(arrRow[i], "LEGACY_USER_ID") == mySheet2.GetCellValue(j+1, "APPR_ID")){
						//은(는) 이미 포함되어 있습니다.
						var text = mySheet2.GetCellValue(j+1,"APPR_NAME") + "<%=CommonLang.msg("MSG631")%>";//은(는) 이미 포함되어 있습니다.
						openLayerPopText2(text,but1text,but1func,but1width);
						return;
					}
				}

				var apprUserId = apprUserMap[mySheet1.GetCellValue(arrRow[i],"LEGACY_USER_ID")];
				var newIndex = 0;
				newIndex = mySheet2.DataInsert(-1);
				mySheet2.SetCellValue(newIndex, "APPR_NAME",mySheet1.GetCellValue(arrRow[i],"USER_NAME_LOC") + "(" + apprUserId + ")");
				mySheet2.SetCellValue(newIndex, "APPR_ID",mySheet1.GetCellValue(arrRow[i],"LEGACY_USER_ID"));
				mySheet2.SetCellValue(newIndex, "APPR_USER_ID", apprUserId);
				mySheet2.SetCellValue(newIndex, "DEPT",mySheet1.GetCellValue(arrRow[i],"DEPARTMENT"));
				mySheet2.SetCellValue(newIndex, "POSITION",mySheet1.GetCellValue(arrRow[i],"POSITION"));
//		 		mySheet2.SetCellValue(newIndex, "DELETE", "/resources/imgs/Icon_WasteBasket.png");
				mySheet2.SetCellValue(newIndex, "DELETE", "/resources/imgs/Icon_close03.png");
				

				//전체메뉴에서는 체크 해제
				mySheet1.SetCellValue(arrRow[i],"SELECTED",false);
				mySheet1.SetCellEditable(arrRow[i],"SELECTED",false);
			}
			
			mySheet1.RenderSheet(1);
			mySheet2.RenderSheet(1);
			
			setOrderSeq();
		}else{
			
		}
	}
	
}
function mySheet2_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if ( msg != "" ) {
		if ( code > 0 ) {
			//저장 성공시 처리
			var text = msg.msg;
			if(msg.code == "100"){ //팝업 안닫음
				var htmlStr = "";
				var appPath = msg.appPath;
				var appSubject = $("#SUBJECT").val();
				htmlStr += '<li value ="'+appPath+'">'+appSubject+'<button class="delete-btn" value="'+appPath+'"></button></li>';
				$("#optionList").append(htmlStr);
				var DOCU_NO = "<%=DOCU_NO%>";
				if(DOCU_NO == ""){//상신창에서 나의 결재라인 추가한 경우 상신창쪽도 만들어주기위함
					opener.addMyPassLine(appPath,appSubject); 
				}
				openLayerPopText2(text,but1text,but1func,but1width);
			}else{
				openLayerPopText2(text,but1text,but1funcSearch,but1width);
			}
		}else{
			var text = msg.msg;
			openLayerPopText2(text,but1text,but1func,but1width);
		}
	}
	
}
function thisPopClose(){
	closePopText2();
	opener.location.reload();
	self.close();
}
function thisPopReload(){
	closePopText2();
	location.reload();
}
function goAppPathChange(appPath){ 	   
	$("#APP_PATH").val(appPath);
	kepSearch(document.approvalHumanEditPop, mySheet2, "/common/approval/getMultiPassLine_v2.do" ,pagingMode);
// 	kepAjaxPopFormCall("/common/approval/getMultiPassLine.do","buyerCommonApprovalPop","goAppPathChange","Y"); 
}

function doAction(str){
	switch (str) {
	case "search":
		kepSearch(document.approvalHumanEditPop, mySheet1, "/mpso/getHanwhaUserInfo_v2.do" ,pagingMode);
		break;

	default:
		break;
	}
}

function moveToPassList(){
	var checkRows = mySheet1.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	if(checkRows == ""){
		//선택된 항목이 없습니다.
		var text = "<%=CommonLang.msg("MSG78")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	kepSave(document.approvalHumanEditPop, mySheet1, "/mpso/saveHanwhaUserInfo_v2.do", "SELECTED");
}
function SheetMove(flag){
	var row = mySheet2.GetSelectRow();
	
	if(mySheet2.GetCellValue(row,"PASS_KN")=="1"){ //결재된사람들은 제외
		return;
	}
	
	if(flag == "up"){
		if(mySheet2.GetCellValue(row-1,"PASS_KN")=="1"){
			return;
		}
		if(row <= 1) return; //첫 행이면 이동 x
		mySheet2.DataMove(row-1);
	}else{
		if(row >= mySheet2.LastRow()) return; //마지막 행이면 이동 x
		mySheet2.DataMove(row+2);
	}
	
	setOrderSeq();
}
function setOrderSeq(){
	for(var i = 1; i<=mySheet2.RowCount(); i++){
		mySheet2.SetCellValue(i,"ORDER_SEQ",i);
	}
}
function setPassLine(){
	if(mySheet2.RowCount() <= 0){
		//선택된 항목이 없습니다.
		var text = "<%=CommonLang.msg("MSG78")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var passFlag = true;
	
	for(var i = 1; i<=mySheet2.RowCount(); i++){
		if(mySheet2.GetCellValue(i,"PASS_KN") == ""){ //결재 안 된 사람들 중 결재,합의 없으면 alert
			if(mySheet2.GetCellValue(i,"GUBUN") == "C" || mySheet2.GetCellValue(i,"GUBUN") == "H"){
				passFlag = false;
				break;
			}
		}
	}
	
	if(passFlag){
		//결재자가 없습니다.
		var text = "<%=CommonLang.msg("MSG647")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	//설정한 내용으로 반영하시겠습니까?
	var text = "<%=CommonLang.msg("MSG632")%>";
	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	var but1funcC = "javascript:insertPassLine(); return false;";
	var but2funcC = "javascript:parent.closePopText1(); return false;";
	var but1widthC = "100px";
	var but2widthC = "100px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
}
function setPassLine2(){
	
	//설정한 내용으로 반영하시겠습니까?
	var text = "<%=CommonLang.msg("MSG632")%>";
	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	var but1funcC = "javascript:setPassLineOpener(); return false;";
	var but2funcC = "javascript:parent.closePopText1(); return false;";
	var but1widthC = "100px";
	var but2widthC = "100px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
}
function setPassLineOpener(){
	parent.closePopText1();
	
	var arr = [];
	
	for(var i = 1; i<=mySheet2.RowCount(); i++){
		var obj = {
			ORDER_SEQ : mySheet2.GetCellValue(i,"ORDER_SEQ"),
			GUBUN_TEXT : mySheet2.GetCellValue(i,"GUBUN_TEXT"),
			GUBUN : mySheet2.GetCellValue(i,"GUBUN"),
			PASS_TP : mySheet2.GetCellValue(i,"PASS_TP"),
			APPR_NAME : mySheet2.GetCellValue(i,"APPR_NAME"),
			POSITION : mySheet2.GetCellValue(i,"POSITION"),
			DEPT : mySheet2.GetCellValue(i,"DEPT"),
			PASS_KN : mySheet2.GetCellValue(i,"PASS_KN"),
			APPR_ID : mySheet2.GetCellValue(i,"APPR_ID"),
			APPR_USER_ID : mySheet2.GetCellValue(i,"APPR_USER_ID")
		}
		
		arr.push(obj);
	}
	
	opener.setPopupReturn(arr);
	self.close();
}
function insertPassLine(){
	parent.closePopText1();
	
	for(var i = 1; i<= mySheet2.RowCount(); i++){
		mySheet2.SetCellValue(i,"SELECTED",true); //전체선택
	}
	
	kepSave(document.approvalHumanEditPop, mySheet2, "/common/approval/updatePassLine_v2.do", "SELECTED");
}

function setDefaultFlag(){
	if($("#defaultFlagCheck").is(":checked")){
		$("#defaultFlag").val("Y");
	}else{
		$("#defaultFlag").val("N");
	}
}
function insertMyPassLine(){
	if(mySheet2.RowCount() <= 0){
		//선택된 항목이 없습니다.
		var text = "<%=CommonLang.msg("MSG78")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	if(kepIsEmpty("SUBJECT")){
		//결재경로명을 입력해주세요.
		var text = "<%=CommonLang.msg("MSG633")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	if(kepTrim("SUBJECT") == "최근 결재경로"){
		//해당 결재명을 사용할 수 없습니다.
		var text = "<%=CommonLang.msg("MSG648")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var text = "<%=CommonLang.msg("MSG632")%>";/*설정한 내용으로 반영하시겠습니까?*/
	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	var but1funcC = "javascript:insertMyPassLineProcess(); return false;";
	var but2funcC = "javascript:parent.closePopText1(); return false;";
	var but1widthC = "100px";
	var but2widthC = "100px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
}
function insertMyPassLineProcess(){
	parent.closePopText1();
	
	for(var i = 1; i<= mySheet2.RowCount(); i++){
		mySheet2.SetCellValue(i,"SELECTED",true); //전체선택
	}
	
	kepSave(document.approvalHumanEditPop, mySheet2, "/common/approval/insertAppPath_v2.do", "SELECTED");
}

function deleteMyPassLine(appPath){
	$("#APP_PATH_DEL").val(appPath);
	kepAjaxFormCall("/common/approval/deleteMyPassLine_v2.do","approvalHumanEditPop","deleteMyPassLine_v2");
}

function kepAjaxSuccess(pMethod , response){
	
	if (pMethod == "deleteMyPassLine_v2"){
		var text = "<%=CommonLang.msg("MSG634")%>";//결재경로가 삭제되었습니다.
		if($("#APP_PATH").val() == $("#APP_PATH_DEL").val()){
			openLayerPopText2(text,but1text,but1funcReload,but1width);
		}else{
			openLayerPopText2(text,but1text,but1func,but1width);
		}
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {

	if (pMethod == "deleteMyPassLine_v2"){
		var text = "<%=CommonLang.get("HTITLE1066")%>";//결재경로 삭제
		text += "<%=CommonLang.msg("MSG624")%>";//실패하였습니다.</br>다시 한 번 시도해 주시기 바랍니다.
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}

function setCurrentPassLine(){
	var infoList = <%=info%>;
	
	mySheet2.RemoveAll();
	
	mySheet2.RenderSheet(0);
	for(var i = 0; i<infoList.length; i++){
		// 대상품목 그려주기
		var newIndex = 0;
		newIndex = mySheet2.DataInsert(-1);
		mySheet2.SetCellValue(newIndex, "ORDER_SEQ", infoList[i].ORDER_SEQ);
		mySheet2.SetCellValue(newIndex, "GUBUN_TEXT", infoList[i].GUBUN_TEXT);
		mySheet2.SetCellValue(newIndex, "GUBUN", infoList[i].GUBUN);
		mySheet2.SetCellValue(newIndex, "PASS_TP", infoList[i].PASS_TP);
		mySheet2.SetCellValue(newIndex, "APPR_NAME", infoList[i].APPR_NAME);
		mySheet2.SetCellValue(newIndex, "POSITION", infoList[i].POSITION);
		mySheet2.SetCellValue(newIndex, "DEPT", infoList[i].DEPT);
		mySheet2.SetCellValue(newIndex, "PASS_KN", infoList[i].PASS_KN);
		mySheet2.SetCellValue(newIndex, "APPR_ID", infoList[i].APPR_ID);
		mySheet2.SetCellValue(newIndex, "APPR_USER_ID", infoList[i].APPR_USER_ID ? infoList[i].APPR_USER_ID : "");
		mySheet2.SetCellValue(newIndex, "DELETE", "/resources/imgs/Icon_close03.png");
	}
	mySheet2.RenderSheet(1);
}
</script> 
<body onload="kepOnload();">
	 <form name=approvalHumanEditPop id=approvalHumanEditPop method=post >
	 <input type="hidden" name="s_SAVENAME" />
	 <input type="hidden" name="APP_PATH" id="APP_PATH" value="" />
	 <input type="hidden" name="APP_PATH_DEL" id="APP_PATH_DEL" value="" />
	 <input type="hidden" name="defaultFlag" id="defaultFlag" value="" />
	 <input type="hidden" name="st_category_no" id="st_category_no" value="" />
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="approvalHumanEditPop_v2"> 
	  <input type="hidden" name="COMPANY" id="COMPANY"  value="<%=COMPANY%>">  
	   <input type="hidden" name="DOCU_NO" id="DOCU_NO"  value="<%=DOCU_NO%>">  
	   <input type="hidden" name="myApprovalYn" id="myApprovalYn"  value="<%=myApprovalYn%>">  
	   <input type="hidden" name="USER_ID" id="USER_ID"  value="<%=SessionUserId%>">  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopupApproval">
  <div class="PopupTit"><%=CommonLang.get("HTITLE1062")%><!--결재경로 관리--><span><a href="javascript:self.close();" class="closePopup"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="Approvalinline">
    <div class="ApprovalPopTitBox">
    	<select name="PLANT" id="PLANT" class="Select44" style="float:left;width:110px; margin-right:4px" >
        	<%if ("KRHANW0090".equals(COMPANY) || "KRHANW0085".equals(COMPANY) || "KRHANW0087".equals(COMPANY) || "KRHANW0086".equals(COMPANY) ||
				"KRHANW0088".equals(COMPANY) || "KRHANW0089".equals(COMPANY) || "KRHANW0091".equals(COMPANY) || "KRHANW0107".equals(COMPANY)) { %> 								
				<option value = "501" >한화에어로스페이스</option>
			<% } else { %>
				<option value = "403" >글로벌</option>
				<option value = "410" >기계</option>
			<% } %>
        </select>
        <select name="USER_FLAG" id="USER_FLAG" class="Select44" style="float:left;width:110px; margin-right:4px" >
     		<option value = "NAME" >이름</option>
			<option value = "EMPNO" >사번</option>
			<option value = "ID" >ID</option>
        </select>
        <div class="SearchPopupInput mb08" style="width:190px;float:left;">
        
          <input type="text" name="USER_NAME_LOC" id="USER_NAME_LOC" style=" width:50%; " onKeyDown="kepEnter_v2()">
          <button onclick="javascript:doAction('search'); return false;"><%=CommonLang.get("HTITLE511")%><!-- 검색 --></button>
        </div>      
    </div>      
    <div class="ApprovalPop mt05" style="width:420px; height:400px;">
      	<script type="text/javascript">
          	createIBSheet("mySheet1", "", "100%");
        </script>    
<!-- 	  <div class="NoData mt50"><img src="/resources/imgs/Icon_Warning01.png" /><br/>검색된 정보가 없습니다.</div>  -->
    </div>
  </div>
  <div class="ApprovalPopBtn" style="width:60px;"><button class="ArrowRight" id="" onclick="javascript:moveToPassList(); return false;"  ></button></div>
  <div class="Approvalinline">    
    <div class="ApprovalPopTit"><%=CommonLang.get("HTITLE1067")%><!--결재경로--> 
      <div class="ApprovalPopTitSelect">
      
      <%if(PASS_LINE_FLAG.equals("Y")) {%>
        <div class="ApprovalPopTitSmall" ><%=CommonLang.get("HTITLE1068")%><!--결재경로 불러오기--></div>
        <div class="ApprovaSelect">
          <div class="select-box" id="selectBox"><span class="select-text"><%=CommonLang.get("HTITLE1063")%><!--나의 결재경로--></span> <img src="/resources/imgs/arrow_down.png" class="arrow" id="arrowIcon"></div>
          <ul class="option-list" id="optionList" >
<%
if (_list == null || _list.size() == 0){ 
}else{
	for (int j=0; j<_list.size(); j++) {
		Map<String,String> rowData = _list.get(j);
%>
<li value = "<%=CommonUtil.nvl(rowData.get("APP_PATH"))%>"><%=CommonUtil.nvl(rowData.get("SUBJECT"))%><% if (!"Y".equals(rowData.get("DEFAULT_FLAG"))) { %><button class="delete-btn" value="<%=CommonUtil.nvl(rowData.get("APP_PATH"))%>"></button><%} %></li> 
<% }
}%>
          </ul>
        </div>
        <%} %>
                
        <p class="BottomBox"><button class="ArrowUP32" onclick="javascript:SheetMove('up'); return false;" ></button><button class="ArrowDOWN32" onclick="javascript:SheetMove('down'); return false;"></button></p>   
      </div>  
    </div>
	<script>
	const selectBox = document.getElementById("selectBox");
	const optionList = document.getElementById("optionList");
	const selectText = document.querySelector(".select-text");
	
	// 열기 / 닫기
	selectBox.addEventListener("click", function(){
	  const isOpen = optionList.style.display === "block";
	
	  optionList.style.display = isOpen ? "none" : "block";
	  selectBox.classList.toggle("active", !isOpen);
	});
	
	// 옵션 선택
	optionList.addEventListener("click", function(e){
	  	if (e.target.tagName === "LI") {
		  e.target.childNodes.forEach(function(node){
			  if(node.nodeType === Node.TEXT_NODE){
				  selectText.textContent =  node.textContent;
			  }
		  })
		optionList.style.display = "none";
		selectBox.classList.remove("active");
		goAppPathChange(e.target.value);
	  }
	
	  // 삭제 버튼
	  if (e.target.classList.contains("delete-btn")) {
		e.stopPropagation();
		e.target.parentElement.remove();
		deleteMyPassLine(e.target.value);
	  }
	});
	
	// 외부 클릭 시 닫기
	document.addEventListener("click", function(e){
	  if (!e.target.closest(".ApprovaSelect")) {
		optionList.style.display = "none";
		selectBox.classList.remove("active");
	  }
	});
	</script>  
    <div class="ApprovalPop mt10" style="width:610px; height:350px;">
      <script type="text/javascript">
          	createIBSheet("mySheet2", "", "100%");
        </script>
<!--       <div class="NoData mt50"><img src="/resources/imgs/Icon_Warning01.png" /><br/>결재경로를 선택하세요</div>  -->
    </div>
    <div class="ApprovalPopTitMy">
      <%=CommonLang.get("HTITLE1063")%><!--나의 결재경로--> <input class="input30 ml15" style="width:300px" placeholder="<%=CommonLang.msg("MSG633")%>" name="SUBJECT" id="SUBJECT" type="text" /><!-- 결재경로명을 입력해주세요. --> 
      <button class="ButDarkGray_Small" style="width:100px;" onclick="javascript:insertMyPassLine(); return false;"><%=CommonLang.get("HTITLE1506") %><!-- 결재경로 저장 --></button>
<%--       <label class="CheckMediumLabel"><input type="checkbox" id="defaultFlagCheck" name="defaultFlagCheck" onchange="javascript:setDefaultFlag();"><span class="CheckMediumCustom"></span> <%=CommonLang.get("HTITLE1069")%><!--기본 결재경로--></label> --%>
    </div> 
  </div>      
  <div class="PopupListBtnBox_Center mt30">
  <%if(!DOCU_NO.equals("")) {%>
  	<button class="ButOutline_large"  onclick="javascript:self.close(); return false;"><%=CommonLang.get("HTITLE229") %><!-- 취소 --></button>
    <button class="ButPrimary_large"  onclick="javascript:setPassLine(); return false;"><%=CommonLang.get("HTITLE516") %><!-- 확인 --></button>
  <%}else{ %>
  	<button class="ButOutline_large"  onclick="javascript:self.close(); return false;"><%=CommonLang.get("HTITLE497") %><!-- 닫기 --></button>
  	<button class="ButPrimary_large"  onclick="javascript:setPassLine2(); return false;"><%=CommonLang.get("HTITLE516") %><!-- 확인 --></button>
  <%} %>
    
  </div>         
</div><!-- wrapPopup 끝-->
</form>
</body>
</html>
