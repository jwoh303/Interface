<%--
**********************************************
* 메뉴 : 
* 화면 : 나의 메뉴 지정 팝업
* 기능 : 
* 프로그램 ID : SU0100005
* 담당자 :  최찬규
* 착수일 : 2025-09-15
**********************************************
--%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
</head>
<%
String st_user_id = (String)_sessionInfo.getUserId();
String st_com_type = (String)_sessionInfo.getBusinessCond();
String st_open_yn = CommonUtil.nvl((String) request.getParameter("st_open_yn"), "N");
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
<form name="myMenuPop" id="myMenuPop" method=post >
	<input type="hidden" name="s_SAVENAME" />
	<input type="hidden" id="st_user_id" name="st_user_id" value="<%=st_user_id %>" />
	<input type="hidden" id="st_com_type" name="st_com_type" value="<%=st_com_type %>" />
	<input type="hidden" id="st_open_yn" name="st_open_yn" value="Y" />
	<input type="hidden" id="st_query" name="st_query" value="" />
	
<div class="wrapPopup">
  <div class="PopupTit"><%=CommonLang.get("HTITLE1129")%><!--나의메뉴설정--></div>
  <div class="Importance01" style="min-width:580px"><img src="/resources/imgs/Icon_Importance.png" /> <%=CommonLang.msg("MSG703")%><!--전체 메뉴에서 선택한 항목을 [>] 버튼으로 추가하고, 나의 메뉴에서는--> 
  <img style="width:15px; height:15px; margin-left:5px; margin-right:2px; margin-top:-3px;"src="/resources/imgs/Icon_close03.png" /><%=CommonLang.msg("MSG704")%><!--삭제 버튼으로 제거할 수 있습니다.--> </div> 
  <table>
    <colgroup>
      <col width="320px" />
      <col width="90px" />
      <col width="320px" />
  	</colgroup>
    <tr>
      <td>
        <div class="PopupTitMyMenu"><%=CommonLang.get("HTITLE755") %><!-- 전체메뉴 --></div>
        <div class="MyMenuEdit">
			<div style="height:325px; width: 320px;">
        	<script type="text/javascript">
				createIBSheet("mySheet0", "100%", "100%");
			</script>
			</div>
        </div>
      </td>
      <td align="center"><button class="ArrowRight" id="DIVopenPopup" style="margin-top:50px;" onclick="javascript:moveToMyList(); return false;"></button></td>
      <td>
        <div class="PopupTitMyMenu"><Img src="/resources/imgs/star.png" class="star" /> <%=CommonLang.get("HTITLE1130")%><!--나의 메뉴 (최대 6개 등록 가능)--> <p class="BottomBox"><button class="ArrowUP" onclick="javascript:SheetMove('up'); return false;"></button><button class="ArrowDOWN" onclick="javascript:SheetMove('down'); return false;"></button></p></div>
        <div class="MyMenuEdit">
          	<div style="height:325px; width: 320px;">
        	<script type="text/javascript">
				createIBSheet("mySheet1", "100%", "100%");
			</script>
			</div>
        </div>
      </td>
    </tr>
  </table>
  
  <div class="h30"></div>
  <div class="PopupListBtnBox_Center">
    <button class="ButQuaternary_large" onclick="javascript:self.close(); return false;"><%=CommonLang.get("HTITLE229")%><!-- 취소 --></button>
    <button class="ButPrimary_large" onclick="javascript:insertMyMenuConfirm(); return false;"><%=CommonLang.get("HTITLE516")%><!-- 확인 --></button>
  </div>  
</div><!-- wrap 끝-->
</form> 

<script type="text/javascript">

function kep_onload(){
	var initsheet0 = {};
	initsheet0.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet0.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"SELECTED",			Header:"",				Type:"DummyCheck",	Width:70,	Edit:true,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"NAME",				Header:"<%=CommonLang.get("HTITLE1131")%>",				Type:"Text",		Width:233,	Edit:false,	EditLen:100,	Hidden:false} /*메뉴명*/
			,{ Align:"Center",	SaveName:"MENU_ID",				Header:"메뉴ID",				Type:"Text",		Width:230,	Edit:false,	EditLen:100,	Hidden:true} /*메뉴ID*/
	];

	var initsheet1 = {};
	initsheet1.Cfg = {MergeSheet:msHeaderOnly, RowHeightResize:0,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet1.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"SELECTED",			Header:"",				Type:"DummyCheck",	Width:70,	Edit:true,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"NAME",				Header:"<%=CommonLang.get("HTITLE1131")%>",				Type:"Text",		Width:250,	Edit:false,	EditLen:100,	Hidden:false}/*메뉴명*/
			,{ Align:"Center",	SaveName:"MENU_ID",				Header:"메뉴ID",				Type:"Text",		Width:230,	Edit:false,	EditLen:100,	Hidden:true}/*메뉴ID*/
			,{ Align:"Center",	SaveName:"DELETE",				Header:"",					Type:"Image",		Cursor:"Pointer",Width:70,	Edit:false,	EditLen:100,	Hidden:false, ImgHeight:15}
			,{ Align:"Center",	SaveName:"SEQ",					Header:"<%=CommonLang.get("HTITLE1064")%>",				Type:"Text",		Width:50,	Edit:false,	EditLen:100,	Hidden:true}/*순서*/
	];


	IBS_InitSheet(mySheet0, initsheet0, pagingMode);
	IBS_InitSheet(mySheet1, initsheet1, pagingMode);

	mySheet0.SetHeaderBackColor("#f2f7ff");
	mySheet1.SetHeaderBackColor("#f2f7ff");
	
	mySheet0.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
	mySheet1.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
	
	mySheet0.SetTheme("DB", "DeepBlue");
	mySheet1.SetTheme("DB", "DeepBlue");
	
	kepSearch(document.myMenuPop, mySheet0, "/mprq/getCommonNoNeMyMenuAllList.do" , pagingMode);
}

//조회 후처리
function mySheet0_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	kepSearch(document.myMenuPop, mySheet1, "/mprq/getCommonNoNeMyMenuList.do" , pagingMode);
}
//조회 후처리
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	var rowCount0 = mySheet0.RowCount();
	var rowCount1 = mySheet1.RowCount();
	//나의 메뉴 리스트에 있는 메뉴는 체크불가능
	for(var i = 1; i<= rowCount0; i++){
		for(var j = 1;j <=rowCount1;j++){
			if(mySheet0.GetCellValue(i, "MENU_ID") == mySheet1.GetCellValue(j, "MENU_ID")){
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
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet1.ColSaveName(mySheet1.GetSelectCol());
	
	if(column == "DELETE"){
		mySheet1.RenderSheet(0);
		
		//삭제할 메뉴는 다시 전체메뉴에서 체크가능하도록
		var rowCount = mySheet0.RowCount();
		for(var i = 1;i<=rowCount;i++){
			if(mySheet0.GetCellValue(i, "MENU_ID") == mySheet1.GetCellValue(Row, "MENU_ID")){
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
			var dataList = msg.menuList;
			opener.setMenu(dataList);
		}
		var text = msg.msg;
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
	}
	
}
function thisPopClose(){
	parent.closePopText2();
	self.close();
}
function moveToMyList(){
    
	var checkRows = mySheet0.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	if(checkRows == ""){
// 		alert("선택된 항목이 없습니다.");
		var text = "<%=CommonLang.msg("MSG78")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	//메뉴 최대 6개 등록
	if(arrRow.length + mySheet1.RowCount() >6){
// 		alert("나의 메뉴는 최대 6개까지 등록 가능합니다.");
		var text = "<%=CommonLang.msg("MSG702")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return
	}
	
	mySheet0.RenderSheet(0);
	mySheet1.RenderSheet(0);
	for(var i = 0; i<arrRow.length; i++){
		
		//이미 포함되어있는지 체크
		var menuName = mySheet0.GetCellValue(arrRow[i],"NAME");
		var menuId = mySheet0.GetCellValue(arrRow[i],"MENU_ID");
		for(var j = 0; j<mySheet1.RowCount(); j++){
			if(menuName == mySheet1.GetCellValue(j+1, "NAME")){
// 				alert(menuName + "은(는) 이미 나의 메뉴에 포함되어 있습니다.");	
				var text = menuName + "은(는) 이미 나의 메뉴에 포함되어 있습니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			if(menuId == mySheet1.GetCellValue(j+1, "MENU_ID")){
// 				alert(menuName + "은(는) 이미 나의 메뉴에 포함되어 있습니다.");	
				var text = menuName + "은(는) 이미 나의 메뉴에 포함되어 있습니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
		}
		
		var newIndex = 0;
		newIndex = mySheet1.DataInsert(-1);
		mySheet1.SetCellValue(newIndex, "NAME",mySheet0.GetCellValue(arrRow[i],"NAME"));
		mySheet1.SetCellValue(newIndex, "MENU_ID",mySheet0.GetCellValue(arrRow[i],"MENU_ID"));
		mySheet1.SetCellValue(newIndex, "DELETE", "/resources/imgs/Icon_close03.png");

		//전체메뉴에서는 체크 해제
		mySheet0.SetCellValue(arrRow[i],"SELECTED",false);
		mySheet0.SetCellEditable(arrRow[i],"SELECTED",false);
	}
	
	mySheet0.RenderSheet(1);
	mySheet1.RenderSheet(1);
	
}

function insertMyMenuConfirm(){
	//설정한 내용으로 반영하시겠습니까?
	var text = "<%=CommonLang.msg("MSG632")%>";
	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	var but1funcC = "javascript:insertMyMenu(); return false;";
	var but2funcC = "javascript:parent.closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
// 	if(!confirm("설정한 내용으로 반영하시겠습니까?")){
// 		return;
// 	}
}
function insertMyMenu(){
	parent.closePopText1();
	var query = "";
	for(var i = 1; i<=mySheet1.RowCount(); i++){
		mySheet1.SetCellValue(i,"SEQ",i);
		mySheet1.SetCellValue(i,"SELECTED",true);
		
		query +=  mySheet1.GetCellValue(i,"NAME")         + "@@";
        query +=  mySheet1.GetCellValue(i,"MENU_ID")         + "@@";
        query +=  i + "^||^";
		
	}
	
	document.forms["myMenuPop"].st_query.value = query;
// 	if(setGridData(query)){
		kepAjaxPopFormCall("/none/saveCommonNoNeMyMenuAjax.do","myMenuPop","updateMenu");
// 	}
// 	kepSave(document.myMenuPop, mySheet1, "/none/saveCommonNoNeMyMenu.do", "SELECTED");
}

function setGridData(query) {
	var returnValue = true;

	var resultArr = new Array(2);
	resultArr = ['',''];
	var name = new Array(2);
	name = ['NAME','MENU_ID','SEQ'];

	//resultArr[0] = name;
	
	var st_query = query.split("^||^");
	
	for(var j = 0; j < st_query.length-1; j++){
		
		var value = st_query[j].split("@@",-1);
		
		for(var k = 0; k < name.length; k++){
			
			
			resultArr[0] = resultArr[0]+ name[k] + "|";
			resultArr[1] = resultArr[1]+ "<input type='hidden' name='"+name[k]+"' id='"+name[k]+"' value='"+value[k]+"'>";
		}
	}

	//마지막에 | 를 없애기 위함
	if (resultArr[0] != "")  resultArr[0] = resultArr[0].substr(0, resultArr[0].length -1);
		
	if(resultArr != null && resultArr !=""){
		
		document.forms["myMenuPop"].s_SAVENAME.value = resultArr[0];
		$("#process").html(resultArr[1]);
		
	} else {
// 		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
		var text = "그리드 데이터 변환에 실패하였습니다.[getFormToArr]";
		openLayerPopText2(text,but1text,but1func,but1width);
		returnValue = false;
	}
	
	return returnValue;
}

function kepAjaxPopSuccess(pMethod , response){
	var msg = response.msg;
	
	if(pMethod == "updateMenu"){
		//저장 성공시 처리
		var dataList = response.MY_MENU_LIST;
		opener.setMenu(dataList);
		
		var text = msg;
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
		
	}
	
	return;
}
//ajax 공통 호출후 실패시 처리 함수
function kepAjaxPopError(pMethod , response,msg){
	var msg = response.msg;
	
	if (!isEmpty(msg)){
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	return;
}
function SheetMove(flag){
	var row = mySheet1.GetSelectRow();
	if(flag == "up"){
		if(row <= 1) return; //첫 행이면 이동 x
		mySheet1.DataMove(row-1);
	}else{
		if(row >= mySheet1.LastRow()) return; //마지막 행이면 이동 x
		mySheet1.DataMove(row+2);
	}
}

</script>
</body>
</html>
