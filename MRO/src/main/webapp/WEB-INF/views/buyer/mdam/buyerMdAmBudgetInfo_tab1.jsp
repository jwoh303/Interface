<%--
**********************************************
* 메뉴 : 예산기준정보
* 화면 : 예산부서관리 탭
* 기능 : 예산부서관리 탭
* 프로그램 ID : BU1005001
* 담당자 : 최찬규  
* 착수일 : 2026-03-13
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="java.sql.Timestamp"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>

<script type="text/javascript">
var mySheet1 = new ibsheetObject();

window.tabs = window.tabs || {};
tabs.buyerMdAmBudgetInfo_tab1 = {
	//alert layer용
	but1text : "<%=CommonLang.get("HTITLE516")%>",/* 확인 */
	but1func : "javascript:closePopText2(); return false;",
	but1funcSearch : "javascript:tabs.buyerMdAmBudgetInfo_tab1.thisPopClose(); return false;",
	but1width : "120px",
	pagingMode : "N",
	current_page : "1",
	popupSel : "",
	init:function(){
		
		var initsheet1 = {};
		initsheet1.HeaderMode={ColResize:0 , ColMove:0};
		initsheet1.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet1.Cols = [
				 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true} /*상태*/
				,{ Align:"Center",	SaveName:"SELECTED",			Header:"",		Type:"DummyCheck",	Width:40,	Edit:true,	Hidden:false}
				,{ Align:"Center",	SaveName:"NO",					Header:"<%=CommonLang.get("HTITLE44")%>",				Type:"Text",		Width:200,	Edit:false,	Hidden:true} /*번호*/
				,{ Align:"Center",	SaveName:"DEPT_CD",				Header:"<%=CommonLang.get("HTITLE568")%>",				Type:"Text",		Width:130,	Edit:false, EditLen:10,	Hidden:false} /*예산부서코드*/
				,{ Align:"Left",	SaveName:"DEPT_NM",				Header:"<%=CommonLang.get("HTITLE268")%>",				Type:"Text",		Width:1090,	Edit:true,	Hidden:false} /*예산부서*/
				,{ Align:"Left",	SaveName:"TYPE_FLAG",				Header:"TYPE_FLAG",				Type:"Text",		Width:550,	Edit:true,	Hidden:true} 
		];
		
		IBS_InitSheet(mySheet1, initsheet1, this.pagingMode);
		mySheet1.SetHighlightAfterSort(2);
		
		mySheet1.SetHeaderBackColor("#f2f7ff");
		mySheet1.SetTheme("DB", "DeepBlue");
		
	},
	
	search:function(){
		kepSearch_v2(document.searchCondition1, mySheet1, "/mdam/getBuyerMdAmBudgetDepartmentListAll_v2.do", this.pagingMode);
	},
	reload:function(){
		kepReload_v2('searchCondition1');
		mySheet1.RemoveAll();
	},
	doAction:function(str,value1,value2,value3){
		switch (str) {
		case "addRow": //행추가
			var insertRow = mySheet1.DataInsert(-1);
			mySheet1.SetCellValue(insertRow, "NO", insertRow);
			mySheet1.SetCellEditable(insertRow, "DEPT_CD", true);
			break;
		case "delRow": //삭제
			var checkRows = mySheet1.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			
			if(checkRows == ""){
				//하나 이상의 대상이 선택되어야 합니다.
				var text = "<%=CommonLang.msg("MSG259") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			
			//선택된 내용을 삭제하시겠습니까?
			var text = "<%=CommonLang.msg("MSG71")%>";
			var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
			var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
			var but1funcC = "javascript:tabs.buyerMdAmBudgetInfo_tab1.delRow(); return false;";
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "120px";
			var but2widthC = "120px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			
			break;
			
		case "saveRow": //저장
			var checkRows = mySheet1.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			
			if(checkRows == ""){
				//하나 이상의 대상이 선택되어야 합니다.
				var text = "<%=CommonLang.msg("MSG259") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			
			for(var idx=0; idx<arrRow.length; idx++){
				if(mySheet1.GetCellValue(arrRow[idx],"DEPT_CD") == ""){
					//예산부서코드를 입력해주세요.
					var text = "<%=CommonLang.msg("MSG708") %>";
					openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
					mySheet1.SelectCell(arrRow[idx],"DEPT_CD");
					return;
				}
				if(mySheet1.GetCellValue(arrRow[idx],"DEPT_NM") == ""){
					//예산부서를 입력해주세요.
					var text = "<%=CommonLang.msg("MSG709") %>";
					openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
					mySheet1.SelectCell(arrRow[idx],"DEPT_NM");
					return;
				}
				
				var dupIdx = mySheet1.ColValueDup("DEPT_CD");
		    	if(dupIdx > -1){
		        	var text = "<%=CommonLang.msg("MSG294")%>";//입력하신 코드는 이미 존재합니다.
		    		openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		        	mySheet1.SetCellValue(dupIdx,"DEPT_CD",'');
		        	return;
		    	}
			}
			
			//선택된 내용을 저장하시겠습니까?
			var text = "<%=CommonLang.msg("MSG358")%>";
			var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
			var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
			var but1funcC = "javascript:tabs.buyerMdAmBudgetInfo_tab1.saveRow(); return false;";
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "120px";
			var but2widthC = "120px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			
			break;

		default:
			break;
		}
	},
	delRow:function(){
		closePopText1();
		
		var checkRows = mySheet1.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		var delArr = new Array();
		for(var idx=0; idx<arrRow.length; idx++){
			var status = mySheet1.GetCellValue(arrRow[idx],"sStatus");
			if(status == "I" || status == "R"){ //행추가한 상태
				delArr.push(mySheet1.GetCellValue(arrRow[idx],"NO"));
			}
		}
		delArr.forEach(function(num){
			for(var i = 1; i<=mySheet1.RowCount(); i++){
				if(mySheet1.GetCellValue(i,"NO") == num){
					mySheet1.RowDelete(i, 0);
				}
			}
		})
		
		for(var i = 1; i<=mySheet1.RowCount(); i++){
			mySheet1.SetCellValue(i,"NO",i);
		}
		
		var checkRows2 = mySheet1.FindCheckedRow("SELECTED");
		var arrRow2 = checkRows2.split("|");
		if(checkRows2 != "" ){
			kepSave(document.searchCondition1, mySheet1, "/mdam/delBuyerMdAmBudgetDepartmentList_v2.do","SELECTED");
		}
		
	},
	saveRow:function(){
		closePopText1();
		kepSave(document.searchCondition1, mySheet1, "/mdam/saveBuyerMdAmBudgetDepartmentList_v2.do","SELECTED");
		
	},
	doPop:function(str,value1,value2,value3,value4){
		switch (str) {
		case "getDept": // 부서 불러오기
			openSearchPopup("/mdam/showBuyerMdAmDepartmentListPop_v2.do", "?tab_id=buyerMdAmBudgetInfo_tab1&st_com_code="+$("#st_buyer_1").val()+"&st_user_id="+$("#st_user_id_1").val(), "1050,700,no");
			break;

		default:
			break;
		}
	},
	thisPopClose:function(){
		closePopText2();
		this.search();
	}
};
//조회 후처리
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,tabs.buyerMdAmBudgetInfo_tab1.but1text,tabs.buyerMdAmBudgetInfo_tab1.but1func,tabs.buyerMdAmBudgetInfo_tab1.but1width);
	}
	
	for(var i = 1; i<=mySheet1.RowCount(); i++){
		mySheet1.SetCellValue(i,"NO",i);
	}
}
//그리드 셀클릭 이벤트
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet1.ColSaveName(mySheet1.GetSelectCol());
	
	if(column != "SELECTED"){
		mySheet1.SetCellValue(Row,"SELECTED",true);
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
			openLayerPopText2(text,tabs.buyerMdAmBudgetInfo_tab1.but1text,tabs.buyerMdAmBudgetInfo_tab1.but1funcSearch,tabs.buyerMdAmBudgetInfo_tab1.but1width);
		}else{
			var text = msg.msg;
			openLayerPopText2(text,tabs.buyerMdAmBudgetInfo_tab1.but1text,tabs.buyerMdAmBudgetInfo_tab1.but1func,tabs.buyerMdAmBudgetInfo_tab1.but1width);
		}
// 		alert(msg.msg);
	}
	
}

function mySheet1_OnAfterEdit(Row, Col) {
	var column = mySheet1.ColSaveName(mySheet1.GetSelectCol());
    if(column=='DEPT_CD'){
    	var dupIdx = mySheet1.ColValueDup("DEPT_CD");
    	if(dupIdx > -1){
        	var text = "<%=CommonLang.msg("MSG294")%>";//입력하신 코드는 이미 존재합니다.
    		openLayerPopText2(text,tabs.buyerMdAmBudgetInfo_tab1.but1text,tabs.buyerMdAmBudgetInfo_tab1.but1func,tabs.buyerMdAmBudgetInfo_tab1.but1width);
        	mySheet1.SetCellValue(dupIdx,"DEPT_CD",'');
        	return;
    	}
    }
}
</script>
<form id="searchCondition1" name="searchCondition1" method="post">
		<input type="hidden" name="s_SAVENAME" />
	 	<input type="hidden" name="codeGubun" id="codeGubun"  value="deptCodeAdminPop">
		<input type="hidden" id="st_buyer_1"  name="st_buyer" value="${sessionInfo.comCode}">
	 <input type="hidden" name="st_user_id" id="st_user_id_1"  value="${sessionInfo.userId}"> 
	 <input type="hidden" name="st_type" id="st_type"  value="C001">
	 <input type="hidden" name="group_mng_flag" id="group_mng_flag"  value="<%=request.getParameter("group_mng_flag")%>">
	 <input type="hidden" name="st_dept_type" id="st_dept_type_1" value="B">
	 <input type="hidden" name="dept_type" id="dept_type_1" value="B">
	<div id="Search1" class="SearchContent">
      <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> <%=CommonLang.msg("MSG698")%><!--예산부서를 등록하거나 수정할 수 있으며, [부서 불러오기]로 일반부서를 예산부서로 불러와 활용할 수 있습니다.--> </div>
      <table class="TabSearchTable" >
        <colgroup>
          <col width="100px" />
          <col width="620px" />
          <col width="90px" />
          <col width="470px" />
        </colgroup>           	
        <tr>
          <th><%=CommonLang.get("HTITLE568") %><!-- 예산부서코드 --></th>
          <td><input class="input40" style="width:450px" name="st_req_dept_code" id="st_req_dept_code_1" type="text" onKeyDown="kepEnter_v3('buyerMdAmBudgetInfo_tab1')"/></td>
          <th><%=CommonLang.get("HTITLE268") %><!-- 예산부서 --></th>
          <td><input class="input40" style="width:450px" name="st_req_dept_name" id="st_req_dept_name_1" type="text" onKeyDown="kepEnter_v3('buyerMdAmBudgetInfo_tab1')"/></td> 
      </table>
      <div class="SearchBtnBox">
        <button class="ButOutline_Medium" onclick="javascript:tabs.buyerMdAmBudgetInfo_tab1.reload(); return false;"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
        <button class="ButDarkGray_Medium" onclick="javascript:tabs.buyerMdAmBudgetInfo_tab1.search(); return false;"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
      </div>
      <div class="ArraySub mt30 mb10">
      	
        <div class="buttonLeft">
          <button class="ButOutline_Medium" onclick="javascript:tabs.buyerMdAmBudgetInfo_tab1.doAction('addRow'); return false;"><%=CommonLang.get("HTITLE36")%><!-- 행추가 --></button>
          <button class="ButOutline_Medium" onclick="javascript:tabs.buyerMdAmBudgetInfo_tab1.doPop('getDept'); return false;"><%=CommonLang.get("HTITLE1127")%><!--부서 불러오기--></button>
        </div>
        <div class="buttonRight">
          <button class="ButOutline_Medium" onclick="javascript:tabs.buyerMdAmBudgetInfo_tab1.doAction('delRow'); return false;"><%=CommonLang.get("HTITLE25")%><!-- 삭제 --></button>
          <button class="ButPrimary_Medium" onclick="javascript:tabs.buyerMdAmBudgetInfo_tab1.doAction('saveRow'); return false;"><%=CommonLang.get("HTITLE124")%><!-- 저장 --></button>
        </div>
	  </div>
	  <div class="BudgetScroll" style="height:500px">
        <div class="IBSheetBuyer">
	      	<script type="text/javascript">
	          	createIBSheet("mySheet1", "", "100%");
	        </script>
      	</div><!--IBSheetBuyer 끝 -->
      </div><!--BudgetScroll -->
      <div class="ArraySub mt10 mb10">
      	<div class="buttonLeft">
          <button class="ButOutline_Medium" onclick="javascript:tabs.buyerMdAmBudgetInfo_tab1.doAction('addRow'); return false;"><%=CommonLang.get("HTITLE36")%><!-- 행추가 --></button>
          <button class="ButOutline_Medium" onclick="javascript:tabs.buyerMdAmBudgetInfo_tab1.doPop('getDept'); return false;"><%=CommonLang.get("HTITLE1127")%><!--부서 불러오기--></button>
        </div>
        <div class="buttonRight">
          <button class="ButOutline_Medium" onclick="javascript:tabs.buyerMdAmBudgetInfo_tab1.doAction('delRow'); return false;"><%=CommonLang.get("HTITLE25")%><!-- 삭제 --></button>
          <button class="ButPrimary_Medium" onclick="javascript:tabs.buyerMdAmBudgetInfo_tab1.doAction('saveRow'); return false;"><%=CommonLang.get("HTITLE124")%><!-- 저장 --></button>
        </div>
	  </div> 
      <div class="h50"></div>         
    </div><!--Tab1끝 -->
</form> 