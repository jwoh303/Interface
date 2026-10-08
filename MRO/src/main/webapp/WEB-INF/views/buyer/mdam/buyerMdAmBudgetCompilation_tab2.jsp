<%--
**********************************************
* 메뉴 : 예산편성
* 화면 : 예산조회 탭
* 기능 : 예산조회 탭
* 프로그램 ID : BU1005005
* 담당자 : 최찬규  
* 착수일 : 2026-03-25
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="java.sql.Timestamp"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>

<%
%>
<script type="text/javascript">
var mySheet2 = new ibsheetObject();
var mySheet3 = new ibsheetObject();
var mySheet4 = new ibsheetObject();

window.tabs = window.tabs || {};
tabs.buyerMdAmBudgetCompilation_tab2 = {
	//alert layer용
	but1text : "<%=CommonLang.get("HTITLE516")%>",/* 확인 */
	but1func : "javascript:closePopText2(); return false;",
	but1funcSearch : "javascript:tabs.buyerMdAmBudgetCompilation_tab2.thisPopClose(); return false;",
	but1width : "120px",
	pagingMode : "N",
	current_page : "1",
	popupSel : "",
	grbRow : "",
	gYear : "",
	init:function(){
		
		var date = new Date();
		year = date.getFullYear();
		month = date.getMonth()+1;
		for(var i=-1;i<=1;i++) {
			if(i == 0){
				this.gYear = year+i;
				$('#st_year_2').append('<option value="' + (year+i) + '" selected>' + (year+i) + '</option>');
			}else{
				$('#st_year_2').append('<option value="' + (year+i) + '">' + (year+i) + '</option>');
			}
		}
		
		var initsheet2 = {};
		initsheet2.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet2.Cols = [
		  				 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true} /*상태*/
		  				,{ Align:"Center",	SaveName:"SELECTED",			Header:"",		Type:"DummyCheck",	Width:80,	Edit:true,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"DEPT",				Header:"<%=CommonLang.get("HTITLE568")%>",				Type:"Text",		Width:100,	Edit:false,	Hidden:false} /*예산부서코드*/
		  				,{ Align:"Left",	SaveName:"DEPT_NAME",				Header:"<%=CommonLang.get("HTITLE268")%>",				Type:"Text",		Width:160,	Edit:false,	Hidden:false} /*예산부서*/
		  				,{ Align:"Center",	SaveName:"ACCOUNT_TYPE",				Header:"<%=CommonLang.get("HTITLE984")%>",				Type:"Text",		Width:100,	Edit:false,	Hidden:false} /*예산계정코드*/
		  				,{ Align:"Left",	SaveName:"ACCOUNT_TYPE_TEXT",				Header:"<%=CommonLang.get("HTITLE966")%>",				Type:"Text",		Width:100,	Edit:false,	Hidden:false} /*예산계정*/
		  				,{ Align:"Left",	SaveName:"TERM_TEXT",				Header:"<%=CommonLang.get("HTITLE433")%>",				Type:"Text",		Width:100,	Edit:false,	Hidden:false} /*기간구분*/
		  				,{ Align:"Right",	SaveName:"PLAN_AMT",				Header:"<%=CommonLang.get("HTITLE430")%>",				Type:"Float",		Width:120,	Edit:false,	Hidden:false,Format:"${priceFormat2}"} /*예산금액*/
		  				,{ Align:"Right",	SaveName:"RESULT_AMT",				Header:"<%=CommonLang.get("HTITLE434")%>",				Type:"Float",		Width:120,	Edit:false,	Hidden:false,Format:"${priceFormat2}"} /*실적금액*/
		  				,{ Align:"Right",	SaveName:"TEMP_AMT",				Header:"<%=CommonLang.get("HTITLE435")%>",				Type:"Float",		Width:120,	Edit:false,	Hidden:false,Format:"${priceFormat2}"} /*임시실적금액*/
		  				,{ Align:"Right",	SaveName:"TEMP_AMT_TEXT",				Header:"<%=CommonLang.get("HTITLE436")%>",				Type:"Float",		Width:120,	Edit:false,	Hidden:false,Format:"${priceFormat2}"} /*잔액*/
		  				,{ Align:"Left",	SaveName:"REMARK",			Header:"<%=CommonLang.get("HTITLE122")%>",				Type:"Text",		Width:300,	Edit:false,	EditLen:100,	Hidden:false}/*비고*/
		  				,{ Align:"Center",	SaveName:"REMARK_YN",		Header:"<%=CommonLang.get("HTITLE122")%>",				Type:"Image",		Cursor:"Pointer",Width:90,	Edit:false,	EditLen:100,	Hidden:true}/*비고*/
		  				,{ Align:"Center",	SaveName:"PLAN_DATE",				Header:"<%=CommonLang.get("HTITLE437")%>",				Type:"Text",		Width:100,	Edit:false,	Hidden:false,Format:"yyyy/MM/dd"} /*예산수립일*/
		  				,{ Align:"Center",	SaveName:"LAST_RESULT_DATE",				Header:"<%=CommonLang.get("HTITLE438")%>",				Type:"Text",		Width:100,	Edit:false,	Hidden:false,Format:"yyyy/MM/dd"} /*최근실적발생일*/
		  		];
		
		IBS_InitSheet(mySheet2, initsheet2, this.pagingMode);
		IBS_InitSheet(mySheet4, initsheet2, this.pagingMode);
		mySheet2.SetHighlightAfterSort(2);
		
		mySheet2.SetHeaderBackColor("#f2f7ff");
		mySheet2.SetTheme("DB", "DeepBlue");
		
		var initsheet3 = {};
		initsheet3.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet3.Cols = [
		  				 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true} /*상태*/
		  				,{ Align:"Center",	SaveName:"SELECTED",			Header:"",		Type:"DummyCheck",	Width:80,	Edit:true,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"TERM_TYPE_TEXT",				Header:"<%=CommonLang.get("HTITLE433")%>",				Type:"Text",		Width:60,	Edit:false,	Hidden:false} /*기간구분*/
		  				,{ Align:"Center",	SaveName:"TERM_TEXT",				Header:"<%=CommonLang.get("HTITLE423")%>",				Type:"Text",		Width:100,	Edit:false,	Hidden:false} /*기간*/
		  				,{ Align:"Center",	SaveName:"REVISION",				Header:"<%=CommonLang.get("HTITLE140")%>",				Type:"Text",		Width:60,	Edit:false,	Hidden:false} /*순번*/
		  				,{ Align:"Center",	SaveName:"DEPT",				Header:"<%=CommonLang.get("HTITLE568")%>",				Type:"Text",		Width:100,	Edit:false,	Hidden:false} /*예산부서코드*/
		  				,{ Align:"Left",	SaveName:"DEPT_NAME",				Header:"<%=CommonLang.get("HTITLE268")%>",				Type:"Text",		Width:160,	Edit:false,	Hidden:false} /*예산부서*/
		  				,{ Align:"Center",	SaveName:"ACCOUNT_TYPE",				Header:"<%=CommonLang.get("HTITLE984")%>",				Type:"Text",		Width:100,	Edit:false,	Hidden:false} /*예산계정코드*/
		  				,{ Align:"Left",	SaveName:"ACCOUNT_TYPE_TEXT",				Header:"<%=CommonLang.get("HTITLE966")%>",				Type:"Text",		Width:100,	Edit:false,	Hidden:false} /*예산계정*/
		  				,{ Align:"Right",	SaveName:"BEFORE_AMT",				Header:"<%=CommonLang.get("HTITLE1158")%>",				Type:"Float",		Width:120,	Edit:false,	Hidden:false,Format:"${priceFormat2}"} /*변경전 예산금액*/
		  				,{ Align:"Right",	SaveName:"CHANGE_AMT",				Header:"<%=CommonLang.get("HTITLE1159")%>",				Type:"Float",		Width:120,	Edit:false,	Hidden:false,Format:"${priceFormat2}"} /*변경 예산금액*/
		  				,{ Align:"Right",	SaveName:"AFTER_AMT",				Header:"<%=CommonLang.get("HTITLE1160")%>",				Type:"Float",		Width:120,	Edit:false,	Hidden:false,Format:"${priceFormat2}"} /*변경후 예산금액*/
		  				,{ Align:"Left",	SaveName:"REMARK",			Header:"<%=CommonLang.get("HTITLE122")%>",				Type:"Text",		Width:300,	Edit:false,	EditLen:100,	Hidden:false}/*비고*/
		  				,{ Align:"Center",	SaveName:"ADD_USER_ID",				Header:"<%=CommonLang.get("HTITLE1161")%>",				Type:"Text",		Width:100,	Edit:false,	Hidden:false} /*수정자ID*/
		  				,{ Align:"Center",	SaveName:"ADD_USER_NAME",				Header:"<%=CommonLang.get("HTITLE1162")%>",				Type:"Text",		Width:100,	Edit:false,	Hidden:false} /*수정자명*/
		  				,{ Align:"Center",	SaveName:"ADD_DATE",				Header:"<%=CommonLang.get("HTITLE1163")%>",				Type:"Text",		Width:100,	Edit:false,	Hidden:false,Format:"yyyy/MM/dd"} /*예산변경일시*/
		  		];
		
		IBS_InitSheet(mySheet3, initsheet3, this.pagingMode);
		mySheet3.SetHighlightAfterSort(2);
		
		mySheet3.SetHeaderBackColor("#f2f7ff");
		mySheet3.SetTheme("DB", "DeepBlue");
		
		var default_term = "<%=CommonUtil.nvl(request.getParameter("default_term"),"ALL")%>";
		$("#st_term_type_2").val(default_term);
		var termElements = document.getElementsByName('st_term_sel');
		for (var i = 0; i < termElements.length; i++) {
		    termElements[i].style.display = 'none';
		}
		$('select[name="st_term_sel"]').val("");
		if($("#st_term_type_2").val() == "ALL" || $("#st_term_type_2").val() == "Y"){
			$("#Y_sel").show();
		}else{
			$("#"+$("#st_term_type_2").val()+"_sel").show();
		}
		
		
	},
	
	search:function(){
		var year = $("#st_year_2").val();
		if(year == "" || year == null){
			var text = "<%=CommonLang.msg("MSG717")%>"; //예산년도를 선택해주세요.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		var termType = $("#st_term_type_2").val();
		
		if(termType == "ALL"){
			$("#st_term_2").val("");
			$("#st_term_dt_2").val("");
		}else{
			if(termType == "Y"){
				$("#st_term_2").val(year);
				$("#st_term_dt_2").val("");
			}else if(termType == "M"){
				var stMonth = $("#M_sel").val();
				if(stMonth != "" && stMonth <= 9){
					stMonth = "0"+stMonth;
				}
				$("#st_term_2").val(year+stMonth);
				$("#st_term_dt_2").val($("#M_sel").val());
			}else{
				$("#st_term_2").val(year+""+$("#st_term_type_2").val()+""+$("#"+$("#st_term_type_2").val()+"_sel").val());
				$("#st_term_dt_2").val($("#"+$("#st_term_type_2").val()+"_sel").val());
			}
		}
		$("#st_from_date_2").val(year+"0101");
		$("#st_to_date_2").val(year+"1231");
		$("#st_all_page").val("N");
		this.current_page = 1;
		kepSearch_v2(document.searchCondition2, mySheet2, "/mdam/getBuyerMdAmBudgetList_v2.do?page="+this.current_page, this.pagingMode);
	},
	search2:function(){
		var year = $("#st_year_2").val();
		if(year == "" || year == null){
			var text = "<%=CommonLang.msg("MSG717")%>"; //예산년도를 선택해주세요.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		$("#st_from_date_2").val(year+"0101");
		$("#st_to_date_2").val(year+"1231");
		kepSearch_v2(document.searchCondition2, mySheet3, "/mdam/excelBuyerMdAmBudgetHistList_v2.do", this.pagingMode);
	},
	searchExcel:function(){
		var year = $("#st_year_2").val();
		if(year == "" || year == null){
			var text = "<%=CommonLang.msg("MSG717")%>"; //예산년도를 선택해주세요.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		var termType = $("#st_term_type_2").val();
		
		if(termType == "ALL"){
			$("#st_term_2").val("");
			$("#st_term_dt_2").val("");
		}else{
			if(termType == "Y"){
				$("#st_term_2").val(year);
				$("#st_term_dt_2").val("");
			}else if(termType == "M"){
				var stMonth = $("#M_sel").val();
				if(stMonth != "" && stMonth <= 9){
					stMonth = "0"+stMonth;
				}
				$("#st_term_2").val(year+stMonth);
				$("#st_term_dt_2").val($("#M_sel").val());
			}else{
				$("#st_term_2").val(year+""+$("#st_term_type_2").val()+""+$("#"+$("#st_term_type_2").val()+"_sel").val());
				$("#st_term_dt_2").val($("#"+$("#st_term_type_2").val()+"_sel").val());
			}
		}
		$("#st_from_date_2").val(year+"0101");
		$("#st_to_date_2").val(year+"1231");
		$("#st_all_page").val("Y");
		kepSearch_v2(document.searchCondition2, mySheet4, "/mdam/getBuyerMdAmBudgetList_v2.do", this.pagingMode);
	},
	reload:function(){
		kepReload_v2('searchCondition2');
		var default_term = "<%=CommonUtil.nvl(request.getParameter("default_term"),"ALL")%>";
		$("#st_term_type_2").val(default_term);
		$("#st_year_2").val(this.gYear);
		var termElements = document.getElementsByName('st_term_sel');
		for (var i = 0; i < termElements.length; i++) {
		    termElements[i].style.display = 'none';
		}
		$("#Y_sel").show();
		mySheet2.RemoveAll();
	},
	doAction:function(str,value1,value2,value3){
		switch (str) {
		
		case "excelDown" :
			this.excelDown();
			break;
		case "histExcelDown":
			this.search2();
			break;
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
		this.search();
	},
	pageSearch:function(param){
		this.current_page = param.page;
		kepSearch_v2(document.searchCondition2, mySheet2, "/mdam/getBuyerMdAmBudgetList_v2.do?page="+this.current_page, this.pagingMode);
	},
	excelDown:function(){
		if(mySheet4.RowCount() == 0){
//	 		조회된 데이터가 없습니다.
			var text = "<%=CommonLang.msg("MSG347")%>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		mySheet4.SetWaitImageVisible(true);
		
		var downRow = "|0";
		for(var i=1; i<=mySheet4.RowCount(); i++) {
			downRow += "|"+i;
		}
		
		var downCol = "";
		for(var i=0; i<=mySheet4.LastCol(); i++){
			if(!mySheet4.GetColHidden(i) && mySheet4.ColSaveName(i) !="SELECTED" && mySheet4.GetCellProperty(1, i, "Type") != "Image"){
				downCol += "|"+i;
			}
		}
		
		if(downRow == "|0"){
			downRow = "";
		}
		var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
		
		var fileName = "<%=CommonLang.get("HTITLE431")%>" +"_"; //예산조회_
		
		var param = {FileName:fileName+nowTime, SheetName:fileName, DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
		mySheet4.Down2Excel(param);
	},
	histExcelDown:function(){
		if(mySheet3.RowCount() == 0){
//	 		조회된 데이터가 없습니다.
			var text = "<%=CommonLang.msg("MSG347")%>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		mySheet3.SetWaitImageVisible(true);
		
		var downRow = "|0";
		for(var i=1; i<=mySheet3.RowCount(); i++) {
			downRow += "|"+i;
		}
		
		var downCol = "";
		for(var i=0; i<=mySheet3.LastCol(); i++){
			if(!mySheet3.GetColHidden(i) && mySheet3.ColSaveName(i) !="SELECTED" && mySheet3.GetCellProperty(1, i, "Type") != "Image"){
				downCol += "|"+i;
			}
		}
		
		if(downRow == "|0"){
			downRow = "";
		}
		var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
		
		var fileName = "<%=CommonLang.get("HTITLE1157")%>" +"_"; //변경이력조회_
		
		var param = {FileName:fileName+nowTime, SheetName:fileName, DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
		mySheet3.Down2Excel(param);
	},
	termChange:function(){
		//select박스 display none 처리
		var termElements = document.getElementsByName('st_term_sel');
		for (var i = 0; i < termElements.length; i++) {
		    termElements[i].style.display = 'none';
		}
		$('select[name="st_term_sel"]').val("");
		
		var term = $("#st_term_type_2").val();
		if(term == "ALL" || term == "Y"){
			$("#Y_sel").show();
		}else{
			$("#"+term+"_sel").show();
		}
	}
};
//조회 후처리
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,tabs.buyerMdAmBudgetCompilation_tab2.but1text,tabs.buyerMdAmBudgetCompilation_tab2.but1func,tabs.buyerMdAmBudgetCompilation_tab2.but1width);
	}
	makePageIndex_v3( mySheet2 , tabs.buyerMdAmBudgetCompilation_tab2.current_page , document.searchCondition2.onepagerow.value,"buyerMdAmBudgetCompilation_tab","2");	
	
}
//조회 후처리
function mySheet3_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,tabs.buyerMdAmBudgetCompilation_tab2.but1text,tabs.buyerMdAmBudgetCompilation_tab2.but1func,tabs.buyerMdAmBudgetCompilation_tab2.but1width);
	}
	tabs.buyerMdAmBudgetCompilation_tab2.histExcelDown();
	
}
function mySheet4_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,tabs.buyerMdAmBudgetCompilation_tab2.but1text,tabs.buyerMdAmBudgetCompilation_tab2.but1func,tabs.buyerMdAmBudgetCompilation_tab2.but1width);
	}
	tabs.buyerMdAmBudgetCompilation_tab2.excelDown();
	
}
//그리드 셀클릭 이벤트
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	tabs.buyerMdAmBudgetCompilation_tab2.grbRow = Row;
	
	return;
}

function mySheet2_OnChange(Row, Col, Value,oldValue, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	
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
			openLayerPopText2(text,tabs.buyerMdAmBudgetCompilation_tab2.but1text,tabs.buyerMdAmBudgetCompilation_tab2.but1funcSearch,tabs.buyerMdAmBudgetCompilation_tab2.but1width);
		}else{
			var text = msg.msg;
			openLayerPopText2(text,tabs.buyerMdAmBudgetCompilation_tab2.but1text,tabs.buyerMdAmBudgetCompilation_tab2.but1func,tabs.buyerMdAmBudgetCompilation_tab2.but1width);
		}
// 		alert(msg.msg);
	}
	
}
</script>
<form id="searchCondition2" name="searchCondition2" method="post">
		<input type="hidden" name="s_SAVENAME" />
	 	<input type="hidden" name="st_com_code" id="st_com_code_2" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_dept" id="st_dept_2" value="${sessionInfo.department}">
		<input type="hidden" name="st_user_id" id="st_user_id_2" value="${sessionInfo.userId}">
		<input type="hidden" name="onepagerow" id="onepagerow_2" value="<%=request.getParameter("rowCnt")%>">
        <input type="hidden" id="pageflag_2" name="pageflag" value="1" />
        <input type="hidden" id="st_all_page" name="st_all_page" value="N" />
        <input type="hidden" id="st_term_2" name="st_term" value="">
        <input type="hidden" id="st_term_dt_2" name="st_term_dt" value="">
	<div id="Search2" class="SearchContent">
      <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> <%=CommonLang.msg("MSG734")%><!--편성된 예산 내용과 사용 현황을 확인할 수 있습니다.--></div>
      <table class="TabSearchTable" >
        <colgroup>
          <col width="90px" />
          <col width="155px" />
          <col width="80px" />
          <col width="275px" />
          <col width="90px" />
          <col width="245px" />
          <col width="90px" />
          <col width="195px" />
        </colgroup>           	
        <tr>
          <th><%=CommonLang.get("HTITLE1143") %><!-- 예산년도 --> <span class="F6495F">*</span></th>
          <td>
          <select name="st_year" id="st_year_2" class="Select40" style="width:150px;">
<%--         <option value=""><%=CommonLang.get("HTITLE1143")%><!--예산년도--></option> --%>
      		</select>
<!--           <div class="Buyer-datepicker-wrap" style="width:185px"> <div class="Buyer-date-input" data-yearpicker style="width:175px"><input type="text" placeholder="" id="st_year_2" name="st_year" readonly /><span></span></div></div>             -->
          </td>
          <input type="hidden" readonly name="st_from_date" id="st_from_date_2"/>
          <input type="hidden" readonly name="st_to_date" id="st_to_date_2"/>
          <th><%=CommonLang.get("HTITLE1140") %><!-- 통제기간 --></th>
          <td><select name="st_term_type" id="st_term_type_2" class="Select40" style="width:115px;" onchange="javascript:tabs.buyerMdAmBudgetCompilation_tab2.termChange();">
              <option value="ALL"><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
              <option value="Y"><%=CommonLang.get("HTITLE424") %><!-- 년 --></option> 
              <option value="H"><%=CommonLang.get("HTITLE425") %><!-- 반기 --></option> 
              <option value="Q"><%=CommonLang.get("HTITLE426") %><!-- 분기 --></option>
              <option value="M"><%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
            </select>
    <select name="st_term_sel" class="Select40 mr20" style="width:100px;" id="Y_sel" disabled>
     	<option value=""></option>
     </select> 
    <select name="st_term_sel" class="Select40 mr20" style="width:100px; display: none;" id="H_sel">
      <option value=""><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
      <option value="1"><%=CommonLang.get("HTITLE1152") %><!-- 상반기 --></option>
      <option value="2"><%=CommonLang.get("HTITLE1153") %><!-- 하반기 --></option>
    </select>
    <select name="st_term_sel" class="Select40 mr20" style="width:100px; display: none;" id="Q_sel">
      <option value=""><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
      <option value="1">1<%=CommonLang.get("HTITLE426") %><!-- 분기 --></option>
      <option value="2">2<%=CommonLang.get("HTITLE426") %><!-- 분기 --></option>
      <option value="3">3<%=CommonLang.get("HTITLE426") %><!-- 분기 --></option> 
      <option value="4">4<%=CommonLang.get("HTITLE426") %><!-- 분기 --></option> 
    </select>
    <select name="st_term_sel" class="Select40 mr20" style="width:100px; display: none;" id="M_sel">
      <option value=""><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
      <option value="1">1<%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
      <option value="2">2<%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
      <option value="3">3<%=CommonLang.get("HTITLE427") %><!-- 월 --></option> 
      <option value="4">4<%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
      <option value="5">5<%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
      <option value="6">6<%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
      <option value="7">7<%=CommonLang.get("HTITLE427") %><!-- 월 --></option> 
      <option value="8">8<%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
      <option value="9">9<%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
      <option value="10">10<%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
      <option value="11">11<%=CommonLang.get("HTITLE427") %><!-- 월 --></option> 
      <option value="12">12<%=CommonLang.get("HTITLE427") %><!-- 월 --></option> 
    </select> 
          </td>
           
          <th><%=CommonLang.get("HTITLE268") %><!-- 예산부서 --></th>        
          <td><input class="input40" style="width:175px" name="st_dept_name" id="st_dept_name_2" type="text" onKeyDown="kepEnter_v3('buyerMdAmBudgetCompilation_tab2')"/></td> 
          <th><%=CommonLang.get("HTITLE966") %><!-- 예산계정 --></th>        
          <td><input class="input40" style="width:175px" name="st_account_type_text" id="st_account_type_text_2" type="text" onKeyDown="kepEnter_v3('buyerMdAmBudgetCompilation_tab2')"/></td> 
      </table>
      <div class="SearchBtnBox">
        <button class="ButOutline_Medium" onclick="tabs.buyerMdAmBudgetCompilation_tab2.reload(); return false;" ><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
        <button class="ButDarkGray_Medium" onclick="tabs.buyerMdAmBudgetCompilation_tab2.search(); return false;" ><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
      </div>
      <div class="ArraySub mt30 mb10">
        <div class="buttonLeft">
          
          <%if(request.getParameter("excel_control").equals("false")){%>
          <button class="But_ExcelDown40"  onclick="tabs.buyerMdAmBudgetCompilation_tab2.searchExcel(); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
          <%} %>
          <button class="ButOutline_Medium" onclick="tabs.buyerMdAmBudgetCompilation_tab2.doAction('histExcelDown'); return false;"><%=CommonLang.get("HTITLE1156")%><!--변경이력다운로드--></button>
        </div>
        <div class="buttonRight"></div>
	  </div>
      <div class="BudgetScroll" style=" width:1280px;">
      	<script type="text/javascript">
			createIBSheet("mySheet2", "100%", "100%");
	  	</script>
      </div><!--BudgetScrollBox -->
      <div class="BudgetScroll" style="display: none;">
      	<script type="text/javascript">
 			createIBSheet("mySheet4", "100%", "100%");
 	  	</script>
      </div><!-- BudgetScrollBox -->  
      <div class="BudgetScroll" style=" width:1280px; display: none;">
      	<script type="text/javascript">
			createIBSheet("mySheet3", "100%", "100%");
	  	</script>
      </div><!--BudgetScrollBox -->
      <div class="ArraySub mt10 mb10">
        <div class="buttonLeft">
        <%if(request.getParameter("excel_control").equals("false")){%>
          <button class="But_ExcelDown40" onclick="tabs.buyerMdAmBudgetCompilation_tab2.searchExcel(); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
        <%} %>  
          <button class="ButOutline_Medium" onclick="tabs.buyerMdAmBudgetCompilation_tab2.doAction('histExcelDown'); return false;"><%=CommonLang.get("HTITLE1156")%><!--변경이력다운로드--></button>
        </div>
        <div class="buttonRight"></div>
	  </div>
	  <div class="PagingCenter mt10" id="pageindex2"></div> 
      <div class="h50"></div>         
    </div><!--Tab2끝 -->  
</form>