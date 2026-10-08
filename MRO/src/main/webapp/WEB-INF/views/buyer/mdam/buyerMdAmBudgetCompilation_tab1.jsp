<%--
**********************************************
* 메뉴 : 예산편성
* 화면 : 예산편성 탭
* 기능 : 예산편성 탭
* 프로그램 ID : BU1005005
* 담당자 : 최찬규  
* 착수일 : 2026-03-17
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="java.sql.Timestamp"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>

<%
String toDate = CommonUtil.formatDateNoDateGubun(new Date(),1);
%>
<script type="text/javascript">
var mySheet1 = new ibsheetObject();

window.tabs = window.tabs || {};
tabs.buyerMdAmBudgetCompilation_tab1 = {
	//alert layer용
	but1text : "<%=CommonLang.get("HTITLE516")%>",/* 확인 */
	but1func : "javascript:closePopText2(); return false;",
	but1funcSearch : "javascript:tabs.buyerMdAmBudgetCompilation_tab1.thisPopClose(); return false;",
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
				$('#st_year_1').append('<option value="' + (year+i) + '" selected>' + (year+i) + '</option>');
			}else{
				$('#st_year_1').append('<option value="' + (year+i) + '">' + (year+i) + '</option>');
			}
		}
		
		var initsheet1 = {};
		initsheet1.Cfg = {FrozenCol:7,MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet1.Cols = [
		  				 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true} /*상태*/
		  				,{ Align:"Center",	SaveName:"SELECTED",			Header:"",		Type:"DummyCheck",	Width:80,	Edit:true,	Hidden:false}
		  				,{ Align:"Center",	SaveName:"DEPT",				Header:"<%=CommonLang.get("HTITLE568")%>",				Type:"Text",		Width:100,	Edit:false,	Hidden:false} /*예산부서코드*/
		  				,{ Align:"Left",	SaveName:"DEPT_NAME",				Header:"<%=CommonLang.get("HTITLE268")%>",				Type:"Text",		Width:160,	Edit:false,	Hidden:false} /*예산부서*/
		  				,{ Align:"Center",	SaveName:"ACCOUNT_TYPE",				Header:"<%=CommonLang.get("HTITLE984")%>",				Type:"Text",		Width:100,	Edit:false,	Hidden:false} /*예산계정코드*/
		  				,{ Align:"Left",	SaveName:"ACCOUNT_TEXT",				Header:"<%=CommonLang.get("HTITLE966")%>",				Type:"Text",		Width:100,	Edit:false,	Hidden:false} /*예산계정*/
		  				,{ Align:"Center",	SaveName:"TERM_TYPE",				Header:"<%=CommonLang.get("HTITLE1140")%>",				Type:"Combo",		Width:100,	Edit:false, EditLen:10,	Hidden:false,ComboText:"|<%=CommonLang.get("HTITLE424")%>|<%=CommonLang.get("HTITLE425")%>|<%=CommonLang.get("HTITLE426")%>|<%=CommonLang.get("HTITLE427")%>" , ComboCode:"|Y|H|Q|M"} /*통제기간*/
		  				,{ Align:"Right",	SaveName:"TOTAL_PLAN_AMT",				Header:"<%=CommonLang.get("HTITLE1141")%>",				Type:"Float",		Width:120,	Edit:true,	Hidden:false,Format:"${priceFormat2}"} /*편성총금액*/
		  				,{ Align:"Center",	SaveName:"TOTAL_PLAN_AMT_BUTTON",				Header:"<%=CommonLang.get("HTITLE1141")%>",				Type:"Button",		Width:100,	Edit:false,	Hidden:false,ClassName:'Type03',Cursor:"Pointer"} /*편성총금액*/
		  				,{ Align:"Right",	SaveName:"MONTH_01_PLAN_AMT",				Header:"1",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:false,Format:"${priceFormat2}"} 
		  				,{ Align:"Right",	SaveName:"MONTH_02_PLAN_AMT",				Header:"2",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:false,Format:"${priceFormat2}"} 
		  				,{ Align:"Right",	SaveName:"MONTH_03_PLAN_AMT",				Header:"3",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:false,Format:"${priceFormat2}"} 
		  				,{ Align:"Right",	SaveName:"MONTH_04_PLAN_AMT",				Header:"4",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:false,Format:"${priceFormat2}"} 
		  				,{ Align:"Right",	SaveName:"MONTH_05_PLAN_AMT",				Header:"5",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:false,Format:"${priceFormat2}"} 
		  				,{ Align:"Right",	SaveName:"MONTH_06_PLAN_AMT",				Header:"6",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:false,Format:"${priceFormat2}"} 
		  				,{ Align:"Right",	SaveName:"MONTH_07_PLAN_AMT",				Header:"7",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:false,Format:"${priceFormat2}"}
		  				,{ Align:"Right",	SaveName:"MONTH_08_PLAN_AMT",				Header:"8",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:false,Format:"${priceFormat2}"}
		  				,{ Align:"Right",	SaveName:"MONTH_09_PLAN_AMT",				Header:"9",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:false,Format:"${priceFormat2}"}
		  				,{ Align:"Right",	SaveName:"MONTH_10_PLAN_AMT",				Header:"10",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:false,Format:"${priceFormat2}"} 
		  				,{ Align:"Right",	SaveName:"MONTH_11_PLAN_AMT",				Header:"11",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:false,Format:"${priceFormat2}"}
		  				,{ Align:"Right",	SaveName:"MONTH_12_PLAN_AMT",				Header:"12",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:false,Format:"${priceFormat2}"}
		  				,{ Align:"Right",	SaveName:"MONTH_01_ORG_PLAN_AMT",				Header:"1",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"} 
		  				,{ Align:"Right",	SaveName:"MONTH_02_ORG_PLAN_AMT",				Header:"2",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"} 
		  				,{ Align:"Right",	SaveName:"MONTH_03_ORG_PLAN_AMT",				Header:"3",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"} 
		  				,{ Align:"Right",	SaveName:"MONTH_04_ORG_PLAN_AMT",				Header:"4",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"} 
		  				,{ Align:"Right",	SaveName:"MONTH_05_ORG_PLAN_AMT",				Header:"5",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"} 
		  				,{ Align:"Right",	SaveName:"MONTH_06_ORG_PLAN_AMT",				Header:"6",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"} 
		  				,{ Align:"Right",	SaveName:"MONTH_07_ORG_PLAN_AMT",				Header:"7",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}
		  				,{ Align:"Right",	SaveName:"MONTH_08_ORG_PLAN_AMT",				Header:"8",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}
		  				,{ Align:"Right",	SaveName:"MONTH_09_ORG_PLAN_AMT",				Header:"9",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}
		  				,{ Align:"Right",	SaveName:"MONTH_10_ORG_PLAN_AMT",				Header:"10",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"} 
		  				,{ Align:"Right",	SaveName:"MONTH_11_ORG_PLAN_AMT",				Header:"11",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}
		  				,{ Align:"Right",	SaveName:"MONTH_12_ORG_PLAN_AMT",				Header:"12",				Type:"Float",		Width:100,	Edit:false, EditLen:100,	Hidden:true,Format:"${priceFormat2}"}
		  				,{ Align:"Center",	SaveName:"BIGO_BUTTON",				Header:"<%=CommonLang.get("HTITLE122")%>",				Type:"Button",		Width:100,	Edit:false,	Hidden:false,ClassName:'Type03',Cursor:"Pointer"} /*비고*/
		  				,{ Align:"Center",	SaveName:"FLAG",				Header:"FLAG",				Type:"Text",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"FROM_DATE",			Header:"FROM_DATE",				Type:"Text",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"TO_DATE",				Header:"TO_DATE",				Type:"Text",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"TERM",				Header:"TERM",				Type:"Text",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_01_RESULT_AMT",				Header:"MONTH_01_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_02_RESULT_AMT",				Header:"MONTH_02_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_03_RESULT_AMT",				Header:"MONTH_03_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_04_RESULT_AMT",				Header:"MONTH_04_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_05_RESULT_AMT",				Header:"MONTH_05_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_06_RESULT_AMT",				Header:"MONTH_06_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_07_RESULT_AMT",				Header:"MONTH_07_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_08_RESULT_AMT",				Header:"MONTH_08_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_09_RESULT_AMT",				Header:"MONTH_09_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_10_RESULT_AMT",				Header:"MONTH_10_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_11_RESULT_AMT",				Header:"MONTH_11_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_12_RESULT_AMT",				Header:"MONTH_12_RESULT_AMT",				Type:"Float",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_01_REMARK",				Header:"MONTH_01_REMARK",				Type:"Text",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_02_REMARK",				Header:"MONTH_02_REMARK",				Type:"Text",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_03_REMARK",				Header:"MONTH_03_REMARK",				Type:"Text",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_04_REMARK",				Header:"MONTH_04_REMARK",				Type:"Text",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_05_REMARK",				Header:"MONTH_05_REMARK",				Type:"Text",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_06_REMARK",				Header:"MONTH_06_REMARK",				Type:"Text",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_07_REMARK",				Header:"MONTH_07_REMARK",				Type:"Text",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_08_REMARK",				Header:"MONTH_08_REMARK",				Type:"Text",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_09_REMARK",				Header:"MONTH_09_REMARK",				Type:"Text",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_10_REMARK",				Header:"MONTH_10_REMARK",				Type:"Text",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_11_REMARK",				Header:"MONTH_11_REMARK",				Type:"Text",		Width:100,	Edit:false,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"MONTH_12_REMARK",				Header:"MONTH_12_REMARK",				Type:"Text",		Width:100,	Edit:false,	Hidden:true}
		  		];
		
		IBS_InitSheet(mySheet1, initsheet1, this.pagingMode);
		mySheet1.SetHighlightAfterSort(2);
		
		mySheet1.SetHeaderBackColor("#f2f7ff");
		mySheet1.SetTheme("DB", "DeepBlue");
		
	},
	
	search:function(){
		var year = $("#st_year_1").val();
		if(year == "" || year == null){
			var text = "<%=CommonLang.msg("MSG717")%>"; //예산년도를 선택해주세요.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		$("#st_from_date_1").val(year+"0101");
		$("#st_to_date_1").val(year+"1231");
		
		this.current_page = 1;
		kepSearch_v2(document.searchCondition1, mySheet1, "/mdam/getBuyerMdAmBudgetCompilationList_v2.do?page="+this.current_page, this.pagingMode);
	},
	reload:function(){
		kepReload_v2('searchCondition1');
		var default_term = "<%=request.getParameter("default_term")%>";
		$("st_term_type_1").val(default_term);
		$("#st_year_1").val(this.gYear);
		mySheet1.RemoveAll();
	},
	doAction:function(str,value1,value2,value3){
		switch (str) {
		
		case "reCompilation": 
			var checkRows = mySheet1.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			
			if(checkRows == ""){
				//하나 이상의 대상이 선택되어야 합니다.
				var text = "<%=CommonLang.msg("MSG259") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			
			for(var i = 0 ; i<arrRow.length; i++){
				if(mySheet1.GetCellValue(arrRow[i],"FLAG") != "UPDATE"){
					//예산편성을 먼저 진행해주시기 바랍니다.
					var text = "<%=CommonLang.msg("MSG722") %>";
					openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
					return;
				}
				for(var j = 1; j<=12; j++){
					var index = j;
					if(index < 10 ){
						index = "0" + index;
					}
					if(mySheet1.GetCellValue(arrRow[i],"MONTH_"+index+"_RESULT_AMT") != 0){
						//실적금액이 있는 경우 편성초기화를 할 수 없습니다.
						var text = "<%=CommonLang.msg("MSG721") %>";
						openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
						return;
					}
				}
			}
			
			//선택된 내용을 편성초기화 하시겠습니까?
			var text = "<%=CommonLang.msg("MSG723")%>";
			var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
			var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
			var but1funcC = "javascript:tabs.buyerMdAmBudgetCompilation_tab1.reCompilation(); return false;";
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "120px";
			var but2widthC = "120px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			
			break;
		case "save" : 
			
			if(this.gYear > $("#st_year_1").val()){ //과거날짜
				//과거년도는 수정할 수 없습니다.
				var text = "<%=CommonLang.msg("MSG997") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			
			var checkRows = mySheet1.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			
			if(checkRows == ""){
				//하나 이상의 대상이 선택되어야 합니다.
				var text = "<%=CommonLang.msg("MSG259") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			
			for(var i = 0 ; i<arrRow.length; i++){
				if(mySheet1.GetCellValue(arrRow[i],"TERM_TYPE") == ""){
					//통제기간을 선택해주세요.	
					var text = "<%=CommonLang.msg("MSG724")%>";
					openLayerPopText2(text,tabs.buyerMdAmBudgetCompilation_tab1.but1text,tabs.buyerMdAmBudgetCompilation_tab1.but1func,tabs.buyerMdAmBudgetCompilation_tab1.but1width);
					return;
				}
			}
			
			//0원 수정가능하도록 변경하기위해 아래 로직 제거
// 			var checkFlag = true;
// 			for(var i = 0 ; i<arrRow.length; i++){
// 				var term_type = mySheet1.GetCellValue(arrRow[i],"TERM_TYPE");
// 				if(term_type == "Y"){
// 					if(mySheet1.GetCellValue(arrRow[i],"MONTH_01_PLAN_AMT") != "0"){
// 						checkFlag = false;
// 					}
// 				}else if(term_type == "H"){
// 					if(mySheet1.GetCellValue(arrRow[i],"MONTH_01_PLAN_AMT") != "0" || mySheet1.GetCellValue(arrRow[i],"MONTH_02_PLAN_AMT") != "0"){
// 						checkFlag = false;
// 					}
// 				}else if(term_type == "Q"){
// 					if(mySheet1.GetCellValue(arrRow[i],"MONTH_01_PLAN_AMT") != "0" || mySheet1.GetCellValue(arrRow[i],"MONTH_02_PLAN_AMT") != "0" || mySheet1.GetCellValue(arrRow[i],"MONTH_03_PLAN_AMT") != "0" || mySheet1.GetCellValue(arrRow[i],"MONTH_04_PLAN_AMT") != "0"){
// 						checkFlag = false;
// 					}
// 				}else if(term_type == "M"){
// 					for(var j = 1; j<=12; j++){
// 						var index = j;
// 						if(j <10){
// 							index = "0"+j;
// 						}
// 						if(mySheet1.GetCellValue(arrRow[i],"MONTH_"+index+"_PLAN_AMT") != 0){
// 							checkFlag = false;
// 							break;
// 						}
// 					}
// 				}
				
// 				if(checkFlag){
// 					//예산금액이 입력되지 않았습니다. 확인 후 다시 입력해 주십시요
<%-- 					var text = "<%=CommonLang.msg("MSG6") %>"; --%>
// 					openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
// 					return;
// 				}
// 			}
			
			//선택된 내용을 저장하시겠습니까?
			var text = "<%=CommonLang.msg("MSG358")%>";
			var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
			var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
			var but1funcC = "javascript:tabs.buyerMdAmBudgetCompilation_tab1.save(); return false;";
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "120px";
			var but2widthC = "120px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			break;
		default:
			break;
		}
	},
	doPop:function(str,value1,value2,value3,value4){
		switch (str) {
		case "allCompilation": // 일괄편성
			openSearchPopup("/mdam/showBuyerMdAmBudgetUploadPop.do", "?tab_id=buyerMdAmBudgetCompilation_tab1", "805,750,no");
			break;

		default:
			break;
		}
	},
	thisPopClose:function(){
		closePopText2();
		this.search();
	},
	cellInit:function(row){
		for(var i = 1; i<=12; i++){
			var index = i;
			if(index < 10){
				index = "0"+index;
			}
			mySheet1.SetCellEditable(row,"MONTH_"+index+"_PLAN_AMT",false);
			mySheet1.SetCellValue(row,"MONTH_"+index+"_PLAN_AMT","0");
			mySheet1.SetCellBackColor(row,"MONTH_"+index+"_PLAN_AMT","");
		}
	},
	reCompilation:function(){
		closePopText1();
		kepSave(document.searchCondition1, mySheet1, "/mdam/delBuyerMdAmBudgetCompilationList_v2.do","SELECTED");
	},
	save:function(){
		closePopText1();
		kepSave(document.searchCondition1, mySheet1, "/mdam/saveBuyerMdAmBudgetCompilationList_v2.do","SELECTED");
	},
	setPopupReturn:function(value1,value2,value3,value4,value5){
		if(this.popupSel == "buyerMdAmBudgetCompilationBigoPop_v2"){
			var tmpLength = value1.length;
			for(var i = 0; i<tmpLength; i++){
				var index = i+1;
				if(index < 10){
					index = "0"+index;
				}
				mySheet1.SetCellValue(this.grbRow,"MONTH_"+index+"_REMARK",value1[i]);
			}
		}
	},
	pageSearch:function(param){
		this.current_page = param.page;
		kepSearch_v2(document.searchCondition1, mySheet1, "/mdam/getBuyerMdAmBudgetCompilationList_v2.do?page="+this.current_page, this.pagingMode);
	}
};

//현시점 기준으로 시작,끝 정하기 위한 함수
function getEditableRange(term_type){
	var toDate = "<%=toDate%>"; //20260323
	var toYear = toDate.substring(0, 4); //2026
	var toMonth = toDate.substring(4, 6);//03
	var toMonth2 = Number(toMonth);//3
	var selYear = $("#st_year_1").val();
	
	var startIndex = 0;
	var endIndex = 0;
	
	if(selYear == toYear){
		if(term_type == "Y"){
			startIndex = 1;
			endIndex = 1;
		}else if(term_type == "H"){
			startIndex = 2;
			if(toMonth < "07"){
				endIndex = 1;
			}else{
				endIndex = 2;
			}
		}else if(term_type == "Q"){
			startIndex = 4;
			if(toMonth < "04"){
				endIndex = 1;
			}else if(toMonth < "07"){
				endIndex = 2;
			}else if(toMonth < "10"){
				endIndex = 3;
			}else{
				endIndex = 4;
			}
		}else{
			startIndex = 12;
			endIndex = toMonth2;
		}
	}else if(selYear > toYear){
		if(term_type == "Y"){
			startIndex = 1;
			endIndex = 1;
		}else if(term_type == "H"){
			startIndex = 2;
			endIndex = 1;
		}else if(term_type == "Q"){
			startIndex = 4;
			endIndex = 1;
		}else{
			startIndex = 12;
			endIndex = 1;
		}
	}else{ //과거년도는 편집 불가능하도록
		startIndex = 0;
		endIndex = 1; 
	}
	
	return { start: startIndex, end: endIndex };
}

// 특정 Row 의 TOTAL_PLAN_AMT 를, 현시점 기준 편집 가능 범위(startIndex~endIndex)만 합산해서 재계산
function recalcTotalPlanAmt(row){
	var term_type = mySheet1.GetCellValue(row,"TERM_TYPE");
	if(term_type == ""){
		return;
	}
	var range = getEditableRange(term_type);
	
	var total_amt = 0;
	for(var j = range.start; j>=range.end; j--){
		var index = j;
		if(index < 10){
			index = "0"+index;
		}
		total_amt += mySheet1.GetCellValue(row,"MONTH_"+index+"_PLAN_AMT");
	}
	mySheet1.SetCellValue(row,"TOTAL_PLAN_AMT",total_amt);
}

//조회 후처리
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,tabs.buyerMdAmBudgetCompilation_tab1.but1text,tabs.buyerMdAmBudgetCompilation_tab1.but1func,tabs.buyerMdAmBudgetCompilation_tab1.but1width);
	}
	
	makePageIndex_v3( mySheet1 , tabs.buyerMdAmBudgetCompilation_tab1.current_page , document.searchCondition1.onepagerow.value,"buyerMdAmBudgetCompilation_tab","1");	
	var currYear = tabs.buyerMdAmBudgetCompilation_tab1.gYear;
	var selYear = $("#st_year_1").val();
	
	for(var i = 1; i<=mySheet1.RowCount(); i++){
		if(selYear < currYear){
			mySheet1.SetCellEditable(i,"TOTAL_PLAN_AMT",false); //편성총금액 막기(과거날짜면)
			mySheet1.SetCellBackColor(i, "TOTAL_PLAN_AMT", "");
		}else{
			mySheet1.SetCellBackColor(i, "TOTAL_PLAN_AMT", "${optColor}");
		}
		mySheet1.SetCellValue(i,"TOTAL_PLAN_AMT_BUTTON","<%=CommonLang.get("HTITLE1142")%>"); //배분
		mySheet1.SetCellValue(i,"BIGO_BUTTON","<%=CommonLang.get("HTITLE122")%>"); //비고
		if(mySheet1.GetCellValue(i,"FLAG") == "INSERT"){
			mySheet1.SetCellEditable(i,"TERM_TYPE",true);
		}
		if(mySheet1.GetCellValue(i,"FLAG") == "UPDATE"){
			var term_type = mySheet1.GetCellValue(i,"TERM_TYPE");
			var range = getEditableRange(term_type);
			
			for(var j = range.start; j>=range.end; j--){
				var index = j;
				if(index < 10){
					index = "0"+index;
				}
				mySheet1.SetCellEditable(i,"MONTH_"+index+"_PLAN_AMT",true);
				mySheet1.SetCellBackColor(i,"MONTH_"+index+"_PLAN_AMT","${optColor}");
			}
			
			// 편성총금액 = 현시점 기준 수정 가능한 범위(range.start~range.end)만 합산
			recalcTotalPlanAmt(i);
		}
	}
}
//그리드 셀클릭 이벤트
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet1.ColSaveName(mySheet1.GetSelectCol());
	tabs.buyerMdAmBudgetCompilation_tab1.grbRow = Row;
	
	if(column == "TOTAL_PLAN_AMT_BUTTON"){
		var term_type = mySheet1.GetCellValue(Row,"TERM_TYPE");
		var total_amt = mySheet1.GetCellValue(Row,"TOTAL_PLAN_AMT");
		if(term_type == ""){
			//통제기간을 선택해주세요.
			var text = "<%=CommonLang.msg("MSG724")%>";
			openLayerPopText2(text,tabs.buyerMdAmBudgetCompilation_tab1.but1text,tabs.buyerMdAmBudgetCompilation_tab1.but1func,tabs.buyerMdAmBudgetCompilation_tab1.but1width);
			return;
		}

		var range = getEditableRange(term_type);
		var startIndex = range.start;
		var endIndex = range.end;
		
		var split_amt = Math.floor(total_amt / (startIndex-endIndex+1));
		for(var j = startIndex; j>=endIndex; j--){
			var index = j;
			if(index < 10){
				index = "0"+index;
			}
			mySheet1.SetCellValue(Row,"MONTH_"+index+"_PLAN_AMT",split_amt);
		}
	}
	
	if(column == "BIGO_BUTTON"){
		
		var term_type = mySheet1.GetCellValue(Row,"TERM_TYPE");
		if(term_type == ""){
			//통제기간을 선택해주세요.
			var text = "<%=CommonLang.msg("MSG724")%>";
			openLayerPopText2(text,tabs.buyerMdAmBudgetCompilation_tab1.but1text,tabs.buyerMdAmBudgetCompilation_tab1.but1func,tabs.buyerMdAmBudgetCompilation_tab1.but1width);
			return;
		}
		
		var forLength = 1;
		if(term_type == "Y"){
			forLength = 1;
		}else if(term_type == "H"){
			forLength = 2;
		}else if(term_type == "Q"){
			forLength = 4;
		}else{
			forLength = 12;
		}
		
		$("#st_term_type").val(term_type);
		$("#st_tab_id").val("buyerMdAmBudgetCompilation_tab1");
// 		var remark_param = "?st_term_type="+term_type;
		for(var i = 1; i<=forLength; i++){
			var index = i;
			if(index < 10){
				index = "0"+index;
			}
			var remark = mySheet1.GetCellValue(Row,"MONTH_"+index+"_REMARK");
			var flag = mySheet1.GetCellEditable(Row,"MONTH_"+index+"_PLAN_AMT");
			$("#st_remark_"+index).val(remark);
			$("#st_flag_"+index).val(flag);
		}
		
		tabs.buyerMdAmBudgetCompilation_tab1.popupSel = "buyerMdAmBudgetCompilationBigoPop_v2";
		//비고팝업 사이즈 조절
		if(term_type == "M"){
			openSearchPopupPost("/mdam/buyerMdAmBudgetCompilationBigoPop_v2.do", 'bigoForm', 'buyerMdAmBudgetCompilationBigoPop_v2', "width=600,height=1000,resizable=no,scrollbars=no, top=0, left=0");
		}else{
			openSearchPopupPost("/mdam/buyerMdAmBudgetCompilationBigoPop_v2.do", 'bigoForm', 'buyerMdAmBudgetCompilationBigoPop_v2', "width=600,height=700,resizable=no,scrollbars=no, top=0, left=0");
		}
	}
	return;
}

function mySheet1_OnChange(Row, Col, Value,oldValue, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet1.ColSaveName(mySheet1.GetSelectCol());
	
	if(column != "SELECTED"){
		mySheet1.SetCellValue(Row,"SELECTED",true);
	}
	
	if(column == "TERM_TYPE"){
		tabs.buyerMdAmBudgetCompilation_tab1.cellInit(Row);
		var term_type = mySheet1.GetCellValue(Row,"TERM_TYPE");
		var range = getEditableRange(term_type);
		
		for(var j = range.start; j>=range.end; j--){
			var index = j;
			if(index < 10){
				index = "0"+index;
			}
			mySheet1.SetCellEditable(Row,"MONTH_"+index+"_PLAN_AMT",true);
			mySheet1.SetCellBackColor(Row,"MONTH_"+index+"_PLAN_AMT","${optColor}");
		}
	}else if(Col == "9" || Col == "10" || Col == "11" || Col == "12" || Col == "13" || Col == "14" || Col == "15" || Col == "16" || Col == "17" || Col == "18" || Col == "19" || Col == "20"){
		var resultColumn = column.replace("PLAN","RESULT");
		var result_amt = mySheet1.GetCellValue(Row,resultColumn);
		if(Value < result_amt){
			//예산금액은 실적금액보다 큰 경우만 수정 가능합니다.(xx원)
			var text = "<%=CommonLang.msg("MSG7")%>"+"("+result_amt+"<%=CommonLang.get("HTITLE660")%>"+")";
			openLayerPopText2(text,tabs.buyerMdAmBudgetCompilation_tab1.but1text,tabs.buyerMdAmBudgetCompilation_tab1.but1func,tabs.buyerMdAmBudgetCompilation_tab1.but1width);
			mySheet1.SetCellValue(Row,column,oldValue);
			return;
		}
		
		// 편성총금액 = 현시점 기준 수정 가능한 범위만 합산
		recalcTotalPlanAmt(Row);
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
			openLayerPopText2(text,tabs.buyerMdAmBudgetCompilation_tab1.but1text,tabs.buyerMdAmBudgetCompilation_tab1.but1funcSearch,tabs.buyerMdAmBudgetCompilation_tab1.but1width);
		}else{
			var text = msg.msg;
			openLayerPopText2(text,tabs.buyerMdAmBudgetCompilation_tab1.but1text,tabs.buyerMdAmBudgetCompilation_tab1.but1func,tabs.buyerMdAmBudgetCompilation_tab1.but1width);
		}
// 		alert(msg.msg);
	}
	
}
</script>
<form id="searchCondition1" name="searchCondition1" method="post">
		<input type="hidden" name="s_SAVENAME" />
	 	<input type="hidden" name="st_com_code" id="st_com_code_1" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_dept" id="st_dept_1" value="${sessionInfo.department}">
		<input type="hidden" name="st_user_id" id="st_user_id_1" value="${sessionInfo.userId}">
		<input type="hidden" name="onepagerow" id="onepagerow_1" value="<%=request.getParameter("rowCnt")%>">
        <input type="hidden" id="pageflag_1" name="pageflag" value="1" />
	<div id="Search1" class="SearchContent">
      <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> <%=CommonLang.msg("MSG714")%><!--예산부서별로 계정 단위 금액을 편성할 수 있습니다. 미사용 건에 한해 통제 기간과 금액을 변경할 수 있으며, 사용한 계정의 변경이 필요하면 KeP 담당자에게 문의해 주세요.--></div>
      <table class="TabSearchTable" >
        <colgroup>
          <col width="110px" />
          <col width="327px" />
          <col width="110px" />
          <col width="317px" />
          <col width="110px" />
          <col width="317px" />
        </colgroup>           	
        <tr>
          <th><%=CommonLang.get("HTITLE1143")%><!--예산년도--> <span class="F6495F">*</span></th>
          <td>
          	<select name="st_year" id="st_year_1" class="Select40" style="width:230px;" onchange="tabs.buyerMdAmBudgetCompilation_tab1.search();">
<%--         <option value=""><%=CommonLang.get("HTITLE1143")%><!--예산년도--></option> --%>
      		</select>
      
<!--           <div class="Buyer-datepicker-wrap" style="width:240px"> <div class="Buyer-date-input" data-yearpicker style="width:230px"><input type="text" readonly name="st_year" id="st_year_1"/><span></span></div></div>             -->
          <input type="hidden" readonly name="st_from_date" id="st_from_date_1"/>
          <input type="hidden" readonly name="st_to_date" id="st_to_date_1"/>
          </td>
          <th><%=CommonLang.get("HTITLE268")%><!-- 예산부서 --></th>        
          <td><input class="input40" style="width:230px" name="st_dept_name" id="st_dept_name_1" type="text" onKeyDown="kepEnter_v3('buyerMdAmBudgetCompilation_tab1')"/></td> 
          <th><%=CommonLang.get("HTITLE966")%><!-- 예산계정 --></th>        
          <td><input class="input40" style="width:230px" name="st_account_text" id="st_account_text_1" type="text" onKeyDown="kepEnter_v3('buyerMdAmBudgetCompilation_tab1')"/></td> 
      </table>
      <div class="SearchBtnBox">
        <button class="ButOutline_Medium" onclick="tabs.buyerMdAmBudgetCompilation_tab1.reload(); return false;" ><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
        <button class="ButDarkGray_Medium" onclick="tabs.buyerMdAmBudgetCompilation_tab1.search(); return false;"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
      </div>
      <div class="ArraySub mt30 mb10">
        <div class="buttonLeft">
          <button class="ButOutline_Medium" onclick="javascript:tabs.buyerMdAmBudgetCompilation_tab1.doPop('allCompilation'); return false;"><%=CommonLang.get("HTITLE703")%><!-- 일괄편성 --></button>
          <button class="ButOutline_Medium" onclick="javascript:tabs.buyerMdAmBudgetCompilation_tab1.doAction('reCompilation'); return false;"><%=CommonLang.get("HTITLE1144")%><!--편성초기화--></button>
        </div>
        <div class="buttonRight">
          <button class="ButPrimary_Medium" onclick="javascript:tabs.buyerMdAmBudgetCompilation_tab1.doAction('save'); return false;"><%=CommonLang.get("HTITLE124")%><!-- 저장 --></button>
        </div>
	  </div>
        <div class="BudgetScroll" style="width:1280px;">
            <script type="text/javascript">
				createIBSheet("mySheet1", "100%", "100%");
	  		</script>
	  	</div>
      <div class="ArraySub mt10 mb10">
      	<div class="buttonLeft">
          <button class="ButOutline_Medium" onclick="javascript:tabs.buyerMdAmBudgetCompilation_tab1.doPop('allCompilation'); return false;"><%=CommonLang.get("HTITLE703")%><!-- 일괄편성 --></button>
          <button class="ButOutline_Medium" onclick="javascript:tabs.buyerMdAmBudgetCompilation_tab1.doAction('reCompilation'); return false;" ><%=CommonLang.get("HTITLE1144")%><!--편성초기화--></button>
        </div>
        <div class="buttonRight">
          <button class="ButPrimary_Medium" onclick="javascript:tabs.buyerMdAmBudgetCompilation_tab1.doAction('save'); return false;"><%=CommonLang.get("HTITLE124")%><!-- 저장 --></button>
        </div>
	  </div>
	  <div class="PagingCenter mt10" id="pageindex1"></div> 
      <div class="h50"></div>         
    </div><!--Tab1끝 -->
</form>
<form id="bigoForm" name="bigoForm" method="post">
<input type="hidden" name="st_term_type" id="st_term_type"/>
<input type="hidden" name="st_tab_id" id="st_tab_id"/>
<input type="hidden" name="st_remark_01" id="st_remark_01"/>
<input type="hidden" name="st_remark_01" id="st_remark_01"/>
<input type="hidden" name="st_remark_02" id="st_remark_02"/>
<input type="hidden" name="st_remark_03" id="st_remark_03"/>
<input type="hidden" name="st_remark_04" id="st_remark_04"/>
<input type="hidden" name="st_remark_05" id="st_remark_05"/>
<input type="hidden" name="st_remark_06" id="st_remark_06"/>
<input type="hidden" name="st_remark_07" id="st_remark_07"/>
<input type="hidden" name="st_remark_08" id="st_remark_08"/>
<input type="hidden" name="st_remark_09" id="st_remark_09"/>
<input type="hidden" name="st_remark_10" id="st_remark_10"/>
<input type="hidden" name="st_remark_11" id="st_remark_11"/>
<input type="hidden" name="st_remark_12" id="st_remark_12"/>
<input type="hidden" name="st_flag_01" id="st_flag_01"/>
<input type="hidden" name="st_flag_02" id="st_flag_02"/>
<input type="hidden" name="st_flag_03" id="st_flag_03"/>
<input type="hidden" name="st_flag_04" id="st_flag_04"/>
<input type="hidden" name="st_flag_05" id="st_flag_05"/>
<input type="hidden" name="st_flag_06" id="st_flag_06"/>
<input type="hidden" name="st_flag_07" id="st_flag_07"/>
<input type="hidden" name="st_flag_08" id="st_flag_08"/>
<input type="hidden" name="st_flag_09" id="st_flag_09"/>
<input type="hidden" name="st_flag_10" id="st_flag_10"/>
<input type="hidden" name="st_flag_11" id="st_flag_11"/>
<input type="hidden" name="st_flag_12" id="st_flag_12"/>
</form>
