<%--
**********************************************
* 메뉴 : 예산기준정보
* 화면 : 예산부서연결 탭
* 기능 : 예산부서연결 탭
* 프로그램 ID : BU1005001
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

<script type="text/javascript">
var mySheet2 = new ibsheetObject();
var mySheet3 = new ibsheetObject();

window.tabs = window.tabs || {};
tabs.buyerMdAmBudgetInfo_tab2 = {
	//alert layer용
	but1text : "<%=CommonLang.get("HTITLE516")%>",/* 확인 */
	but1func : "javascript:closePopText2(); return false;",
	but1funcSearch : "javascript:tabs.buyerMdAmBudgetInfo_tab2.thisPopClose(); return false;",
	but1width : "120px",
	pagingMode : "N",
	current_page : "1",
	popupSel : "",
	grbRow : "",
	init:function(){
		
		var initsheet2 = {};
		initsheet2.HeaderMode={ColResize:0, ColMove:0};
		initsheet2.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet2.Cols = [
				{ Align:"Center",	SaveName:"CODE",		Header:"<%=CommonLang.get("HTITLE380") %>",				Type:"Text",		Width:130,	Edit:false,	EditLen:100,	Hidden:false}/*부서|부서코드*/
				,{ Align:"Left",	SaveName:"TEXT1",			Header:"<%=CommonLang.get("HTITLE329") %>",				Type:"Text",		Width:280,	Edit:false,	EditLen:100,	Hidden:false}/*부서|부서*/
				,{ Align:"Center",	SaveName:"ADD",				Header:"<%=CommonLang.get("HTITLE1147")%>",					Type:"Button",		Cursor:"Pointer",Width:100,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type03'}/*부서|예산부서 연결*/
		];
		
		var initsheet3 = {};
		initsheet3.HeaderMode={ColResize:0, ColMove:0};
		initsheet3.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet3.Cols = [
				 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true} /*연결 예산부서|상태*/
				,{ Align:"Center",	SaveName:"SELECTED",			Header:"",				Type:"DummyCheck",	Width:70,	Edit:true,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"DEPT_CD",				Header:"<%=CommonLang.get("HTITLE568")%>",				Type:"Text",		Width:130,	Edit:false, EditLen:10,	Hidden:false} /*연결 예산부서|예산부서코드*/
				,{ Align:"Left",	SaveName:"DEPT_NM",				Header:"<%=CommonLang.get("HTITLE268")%>",				Type:"Text",		Width:495,	Edit:false,	Hidden:false} /*연결 예산부서|예산부서*/
				,{ Align:"Center",	SaveName:"DELETE",				Header:"<%=CommonLang.get("HTITLE25")%>",					Type:"Image",		Cursor:"Pointer",Width:70,	Edit:false,	EditLen:100,	Hidden:false, ImgHeight:15}/*연결 예산부서|삭제*/
		];
		
		IBS_InitSheet(mySheet2, initsheet2, this.pagingMode);
		mySheet2.SetHighlightAfterSort(2);
		
		mySheet2.SetHeaderBackColor("#f2f7ff");
		mySheet2.SetTheme("DB", "DeepBlue");
		
		IBS_InitSheet(mySheet3, initsheet3, this.pagingMode);
		mySheet3.SetHighlightAfterSort(2);
		
		mySheet3.SetHeaderBackColor("#f2f7ff");
		mySheet3.SetTheme("DB", "DeepBlue");
		
	},
	
	search:function(){
		kepSearch_v2(document.searchCondition2, mySheet2, "/common/commonList_v3.do", this.pagingMode);
	},
	search2:function(){
		kepSearch_v2(document.searchCondition2, mySheet3, "/mdam/getBuyerMdAmBudgetDepartmentList_v2.do", this.pagingMode);
	},
	reload:function(){
		kepReload_v2('searchCondition2');
		mySheet2.RemoveAll();
		kepReload_v2('searchCondition2');
		mySheet3.RemoveAll();
	},
	doAction:function(str,value1,value2,value3){
		switch (str) {

		default:
			break;
		}
	},
	doPop:function(str,value1,value2,value3,value4){
		switch (str) {

		default:
			break;
		}
	},
	thisPopClose:function(){
		closePopText2();
		
		kepSearch_v2(document.searchCondition2, mySheet3, "/mdam/getBuyerMdAmBudgetDepartmentList_v2.do", this.pagingMode);
	},
	delRow:function(Row){
		closePopText1();
		
		mySheet3.SetCellValue(Row,"SELECTED",true);
		kepSave(document.searchCondition2, mySheet3, "/mdam/delBuyerMdAmBudgetDepartmentConList_v2.do", "SELECTED");
	}
};
//조회 후처리
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,tabs.buyerMdAmBudgetInfo_tab2.but1text,tabs.buyerMdAmBudgetInfo_tab2.but1func,tabs.buyerMdAmBudgetInfo_tab2.but1width);
	}
	
	for(var i = 1; i<=mySheet2.RowCount(); i++){
		mySheet2.SetCellValue(i, "ADD", "<%=CommonLang.get("HTITLE1120")%>"); //추가
	}
	
	$("#st_dept_code_2").val(mySheet2.GetCellValue(1,"CODE"));
	$("#db_dept_code_2").val(mySheet2.GetCellValue(1,"CODE"));
	tabs.buyerMdAmBudgetInfo_tab2.grbRow = 1;
	mySheet2.SetRowBackColor(1, "${optColor}");
	kepSearch_v2(document.searchCondition2, mySheet3, "/mdam/getBuyerMdAmBudgetDepartmentList_v2.do", tabs.buyerMdAmBudgetInfo_tab2.pagingMode);
}
//조회 후처리
function mySheet3_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,tabs.buyerMdAmBudgetInfo_tab2.but1text,tabs.buyerMdAmBudgetInfo_tab2.but1func,tabs.buyerMdAmBudgetInfo_tab2.but1width);
	}
	
	for(var i = 1; i<=mySheet3.RowCount(); i++){
		mySheet3.SetCellValue(i, "DELETE", "/resources/imgs/Icon_close03.png");
	}
}
//그리드 셀클릭 이벤트
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	mySheet2.SetRowBackColor(tabs.buyerMdAmBudgetInfo_tab2.grbRow, "");
	tabs.buyerMdAmBudgetInfo_tab2.grbRow = Row;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	
	mySheet2.SetRowBackColor(Row, "${optColor}");
	
	if(column == "CODE" || column == "TEXT1"){ //부서코드,명 클릭
		$("#st_dept_code_2").val(mySheet2.GetCellValue(Row,"CODE"));
		$("#db_dept_code_2").val(mySheet2.GetCellValue(Row,"CODE"));
		kepSearch_v2(document.searchCondition2, mySheet3, "/mdam/getBuyerMdAmBudgetDepartmentList_v2.do", tabs.buyerMdAmBudgetInfo_tab2.pagingMode);
	}else if(column == "ADD"){ //추가 팝업
		$("#st_dept_code_2").val(mySheet2.GetCellValue(Row,"CODE"));
		$("#db_dept_code_2").val(mySheet2.GetCellValue(Row,"CODE"));
		kepSearch_v2(document.searchCondition2, mySheet3, "/mdam/getBuyerMdAmBudgetDepartmentList_v2.do", tabs.buyerMdAmBudgetInfo_tab2.pagingMode);
		openSearchPopup("/mdam/showBuyerMdAmBudgetDepartmentListPop_v2.do", "?tab_id=buyerMdAmBudgetInfo_tab2&st_com_code="+$("#st_buyer_2").val()+"&db_dept_code="+$("#db_dept_code_2").val()+"&dept_nm="+mySheet2.GetCellValue(Row,"TEXT1"), "1050,700,no");
	}
	return;
}
function mySheet3_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet3.ColSaveName(mySheet3.GetSelectCol());
	
	if(column == "DELETE"){ //삭제
		var text = "<%=CommonLang.msg("MSG71")%>";
		var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
		var but1funcC = "javascript:tabs.buyerMdAmBudgetInfo_tab2.delRow('"+Row+"'); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	}
	return;
}
//트랜젝션(저장,삽입등) 후처리
function mySheet2_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		if ( code > 0 ) {
			//저장 성공시 처리
			var text = msg.msg;
			openLayerPopText2(text,tabs.buyerMdAmBudgetInfo_tab2.but1text,tabs.buyerMdAmBudgetInfo_tab2.but1funcSearch,tabs.buyerMdAmBudgetInfo_tab2.but1width);
		}else{
			var text = msg.msg;
			openLayerPopText2(text,tabs.buyerMdAmBudgetInfo_tab2.but1text,tabs.buyerMdAmBudgetInfo_tab2.but1func,tabs.buyerMdAmBudgetInfo_tab2.but1width);
		}
// 		alert(msg.msg);
	}
	
}
function mySheet3_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		if ( code > 0 ) {
			//저장 성공시 처리
			var text = msg.msg;
			openLayerPopText2(text,tabs.buyerMdAmBudgetInfo_tab2.but1text,tabs.buyerMdAmBudgetInfo_tab2.but1funcSearch,tabs.buyerMdAmBudgetInfo_tab2.but1width);
		}else{
			var text = msg.msg;
			openLayerPopText2(text,tabs.buyerMdAmBudgetInfo_tab2.but1text,tabs.buyerMdAmBudgetInfo_tab2.but1func,tabs.buyerMdAmBudgetInfo_tab2.but1width);
		}
// 		alert(msg.msg);
	}
	
}

</script>

<form id="searchCondition2" name="searchCondition2" method="post">
		<input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="com_code" id="com_code_2" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id_2" value="${sessionInfo.userId}">
		
	 	<input type="hidden" name="codeGubun" id="codeGubun"  value="deptCodeAdminPop_v2">
		<input type="hidden" name="st_buyer" id="st_buyer_2"  value="${sessionInfo.comCode}">
		<input type="hidden" name="st_type" id="st_type_2"  value="C001">
		<input type="hidden" name="db_buyer_code" id="db_buyer_code_2"  value="${sessionInfo.comCode}">
		<input type="hidden" name="st_dept_type" id="st_dept_type" value="D">
		<input type="hidden" name="st_dept_code" id="st_dept_code_2" value="">
		<input type="hidden" name="db_dept_code" id="db_dept_code_2" value="">
	
	<div id="Search2" class="SearchContent">
      <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> <%=CommonLang.msg("MSG705")%><!--등록한 예산부서 아래에 함께 사용할 예산부서를 연결할 수 있으며, [추가] 버튼을 눌러 연결합니다.--></div>
      <table class="TabSearchTable" >
        <colgroup>
          <col width="100px" />
          <col width="620px" />
          <col width="90px" />
          <col width="470px" />
        </colgroup>      	
        <tr>
          <th><%=CommonLang.get("HTITLE380") %><!-- 부서코드 --></th>
          <td><input class="input40" style="width:450px" name="st_req_dept_code" id="st_req_dept_code_2" type="text" onKeyDown="kepEnter_v3('buyerMdAmBudgetInfo_tab2')"/></td>
          <th><%=CommonLang.get("HTITLE329") %><!-- 부서 --></th>
          <td><input class="input40" style="width:450px" name="st_req_dept_name" id="st_req_dept_name_2" type="text" onKeyDown="kepEnter_v3('buyerMdAmBudgetInfo_tab2')"/></td> 
      </table>
      <div class="SearchBtnBox">
        <button class="ButOutline_Medium" onclick="javascript:tabs.buyerMdAmBudgetInfo_tab2.reload(); return false;"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
        <button class="ButDarkGray_Medium" onclick="javascript:tabs.buyerMdAmBudgetInfo_tab2.search(); return false;"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button>
      </div>
      <div class="BudgetScrollBox mt50">
      <table>
         <tr>
         <td style="width:530px;">
         <div class="BudgetScrollBoxTit"><img src="/resources/imgs/Department01.png" /> <%=CommonLang.get("HTITLE329") %><!-- 부서 --></div>
        <div class="BudgetScroll" style="width:530px;">
          	<script type="text/javascript">
				createIBSheet("mySheet2", "100%", "100%");
	  		</script>
        </div>
        </td>
        <td style="width: 50px;"></td>
        <td style="width:695px;">
        <div class="BudgetScrollBoxTit"><img src="/resources/imgs/Department04.png" /> <%=CommonLang.get("HTITLE1146") %><!-- 연결 예산부서 --></div>
        <div class="BudgetScroll" style=" width:695px;">
          	<script type="text/javascript">
				createIBSheet("mySheet3", "100%", "100%");
	  		</script>
        </div>
        </td>
        </tr>
        </table>
      </div><!--BudgetScrollBox --> 
      <div class="h50"></div>         
    </div><!--Tab2끝 --> 
</form> 