<%--
**********************************************
* 메뉴 : 상품관리>표준 카탈로그 관리>표준카탈로그 등록
* 화면 : 표준카탈로그 등록
* 기능 : 
* 프로그램 ID :
* 담당자 : 현명환
* 착수일 : 2016-08-09
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var manageDept = KepSheetComboQueryIdData('getKepDeptList','SEL','');	// IBSHEET : 담당부서

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
    var v_item_gubun = KepSheetComboData("M118","");
    var item_gubun_type = {ComboCode: v_item_gubun.ComboCode, ComboText: v_item_gubun.ComboText};
    
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:30,	Edit:true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:50,	Edit:false,	EditLen:110,	Type:"Text",	Header:"순서",	SaveName:"SEQ"}
					,{ Align:"Left",	Width:90,	Edit:false,	EditLen:20,	Type:"Text",	Header:"결재번호",	SaveName:"PM_NO"}
					,{ Align:"Left",	Width:80,	Edit:false,	EditLen:20,	Type:"Text",	Header:"결재순번",	SaveName:"PM_SEQ"}
					,{ Align:"Left",	Width:100,	Edit:false,	Hidden : false, EditLen:10,	Type:"Text",	Header:"표준카탈로그",	SaveName:"CMS_CATLG_ID"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:20,	Type:"Text",	Header:"표준카테고리ID",	SaveName:"CMS_CATEG_ID" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:20,	Type:"Text",	Header:"표준카테고리명",	SaveName:"CMS_CATEG_NAME" ,BackColor:"${optColor}"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:200,	Type:"Text",	Header:"상태",	SaveName:"STATUS"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:200,	Hidden : true,Type:"Text",	Header:"STATUS_CD",	SaveName:"STATUS_CD"}
					,{ Align:"Left",	Width:150,	Edit:true,	EditLen:25,	Type:"Text",	Header:"표준품목명",	SaveName:"DESCRIPTION_LOC" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:150,	Edit:true,	EditLen:25,	Type:"Text",	Header:"표준품목명(영문)",	SaveName:"DESCRIPTION_ENG" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:150,	Edit:true,	EditLen:200,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:150,	Edit:true,	EditLen:200,	Type:"Text",	Header:"규격(영문)",	SaveName:"SPECIFICATION_ENG" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:80,	Edit:true,	EditLen:10,	Type:"Text",	Header:"제조사코드",	SaveName:"MAKER_CODE" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:80,	Edit:true,	EditLen:20,	Type:"Text",	Header:"제조사명",	SaveName:"MAKER_NAME" ,BackColor:"${optColor}"} 
					,{ Align:"Left",	Width:50,	Edit:true,	EditLen:2,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_CODE" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:50,	Edit:true,	EditLen:4,	Type:"Text",	Header:"단위",	SaveName:"ORDER_MEASURE" ,BackColor:"${optColor}"}
					,{ Align:"Center",	Width:150,	Edit:true,	EditLen:200,	Type:"Text",	Header:"모델정보",	SaveName:"MODEL_INFO" }
					,{ Align:"Left",	Width:120,	Edit:true,	EditLen:200,	Type:"Text",	Header:"비고",	SaveName:"REMARK"}
					,{ Align:"Center",	Width:120,	Edit:true,	EditLen:120,	Type:"Combo",	Header:"팀코드",	SaveName:"KEP_DEPT" ,BackColor:"${optColor}", ComboText:manageDept.ComboText, 	ComboCode:manageDept.ComboCode}
					,{ Align:"Center",	Width:80,	Edit:true,	EditLen:80,	Type:"Text",	Header:"그룹유형",	SaveName:"STOCK_GROUP_TYPE" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:200,	Type:"Text",	Header:"상품이미지경로",	SaveName:"IMGFILE_DIR"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:200,	Type:"Text",	Header:"상품이미지파일명",	SaveName:"IMGFILE_NAME"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:200,	Type:"Text",	Header:"상품상세이미지경로",	SaveName:"DETAIL_IMGFILE_DIR"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:200,	Type:"Text",	Header:"상품상세이미지파일명",	SaveName:"DETAIL_IMGFILE_NAME"}
					,{ Align:"Left",	Width:80,	Edit:true,	EditLen:200,	Type:"Text",	Header:"표준화여부",	SaveName:"STD_FLAG",BackColor:"${optColor}"}
					,{ Align:"Center",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",Header:"품목구분",	SaveName:"ITEM_GUBUN"}
					];
	//InitHeaders의 두번째 인자
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(4);
	//하이퍼링크 설정
	setLinkCol(mySheet, "CMS_CATEG_NAME");
	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val(kepToDateAdd("7","M"));
	$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
	mySheet.SetColProperty("ITEM_GUBUN", item_gubun_type);
}
	
var g_gubun = "";

// 기능함수
function doAction(str) {
	g_gubun = "";
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	
	var maxRow = mySheet.RowCount();
	// 선택된 항목 유무 체크
	if ((str =="del" || str =="save" || str =="saveAppr" || str =="tempSave") && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
	
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
			alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n3개월 이상의 데이타는 S/R 요청 바랍니다.");
			return;
		}
		kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmStndCatalogRegList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$("#st_from_date").val(kepToDateAdd("7","M"));
		$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
		mySheet.RemoveAll();
		break;

	case "saveAppr": // 저장

		for(var i=0; i<arrRow.length; i++){

			var st_status_cd = mySheet.GetCellValue(arrRow[i],"STATUS_CD");
			if(st_status_cd == "P"||st_status_cd == "C"||st_status_cd == "R"){
				alert("상태가 미생성, 반려일 경우만 품의상신 가능 합니다.");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID") == ""){
				alert("표준카테고리를 입력 해주세요");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID").substr(0,1) != "K"){
				alert("표준카테고리 체계를 확인 해주세요");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"DESCRIPTION_LOC")==""){
				alert("품명을 입력 해주세요");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"DESCRIPTION_ENG")==""){
				alert("품명(영문)을 입력 해주세요");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"SPECIFICATION")==""){
				alert("규격을 입력 해주세요");
				return;
			}	
			if(mySheet.GetCellValue(arrRow[i],"MAKER_CODE")==""){
				alert("제조사코드를 입력 해주세요");
				return;
			}	
			if(mySheet.GetCellValue(arrRow[i],"ORIGIN_CODE")==""){
				alert("원산지를 입력 해주세요");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"ORIGIN_CODE")=="Z1"){
				alert("원산지 미지정은 입력 불가능 합니다");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"ORDER_MEASURE")==""){
				alert("단위를 입력 해주세요");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"ITEM_GUBUN")==""){
				alert("상품구분을 입력 해주세요");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"ITEM_GROUP")==""){
				alert("자재구분을 입력 해주세요");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"ONOFF_TYPE")==""){
				alert("등록유형을 입력 해주세요");
				return;
			}

		}
		
		if (!confirm('표준 카탈로그 등록 품의 상신 하시겠습니까?')){
			return;
		}else{
			document.searchCondition.DOC_TYPE.value = "SCA";
			g_gubun= "saveMasterMdCmStndCatalogApprList";
			kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMdCmStndCatalogApprList.do" , "SELECTED" );
		}
		
		break;

	case "excelDown": // 엑셀다운로드
		if (maxRow == 0){
			alert("조회된 데이터가 없습니다.  ");
			return;
		}
		
		var param = {FileName:"표준카탈로그등록.xls",Merge:1,SheetDesign:1,DownCols:"SEQ|CMS_CATLG_ID|CMS_CATEG_ID|STATUS|DESCRIPTION_LOC|DESCRIPTION_ENG|REP_SEPCIFICATION|SPECIFICATION|MAKER_CODE|MAKER_NAME|ORIGIN_CODE|ORDER_MEASURE|ATTB1_NM|ATTB2_NM|ATTB3_NM|ATTB4_NM|ATTB5_NM|ATTB6_NM|ATTB7_NM|ATTB8_NM|ATTB9_NM|ATTB10_NM|ATTB11_NM|ATTB12_NM|ATTB13_NM|ATTB14_NM|ATTB15_NM|ATTB16_NM|ATTB17_NM|ATTB18_NM|ATTB19_NM|ATTB20_NM|DELIVERY_LT|ITEM_GUBUN|ITEM_GROUP|ONOFF_TYPE|STD_FLAG|REMARK|CMS_PRICE|TEAM_CODE|GROUP_TYPE|IMGFILE_DIR|IMGFILE_NAME|DETAIL_IMGFILE_DIR|DETAIL_IMGFILE_NAME|STD_FLAG|ITEM_GUBUN"};
		kepDownExcel(document.searchCondition ,mySheet , "/mdcm/excelMasterMdCmStndCatalogRegList.do", param);

		break;
		
	case "del":	//삭제
	
		if (maxRow == 0){
			alert("조회된 데이터가 없습니다.  ");
			return;
		}
		
		if (selectedGrid.length == 0){
			alert("삭제할 대상을 선택해 주십시요. ");
			return;
		}
		for(var i=0; i<arrRow.length; i++){
			var st_status_cd = mySheet.GetCellValue(arrRow[i],"STATUS_CD");
			if(st_status_cd == "P"){
				alert("품의 상신건은 삭제가 불가능 합니다.");
				return;
			}
		}
		if (!confirm("선택된 내역을 삭제 하시겠습니까?  ")) {
			return;
		}else{
			kepSave(document.searchCondition ,  mySheet , "/mdcm/delMasterMdCmStndCatalogRegList.do" , "SELECTED" );	
		}		
		
		break;	
	case "loadExcel": // 파일 업로드
		mySheet.RemoveAll();
		var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"||||||1||||2|3|4|5|6||7|8|9|10|11|12|13|14|15|16|17|18|"};
		mySheet.LoadExcel(params);
	  	
		break;
	case "tempSave": // 임시저장저장

		for(var i=0; i<arrRow.length; i++){
			var st_status_cd = mySheet.GetCellValue(arrRow[i],"STATUS_CD");
			if(st_status_cd == "P"||st_status_cd == "C"||st_status_cd == "R"){
				alert("상태가 미생성, 반려건만 임시저장 가능 합니다.");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"CMS_CATLG_ID") != ""){
				alert("이미 등록된 상품 입니다");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID") == ""){
				alert("표준카테고리를 입력 해주세요");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID").substr(0,1) != "K"){
				alert("표준카테고리 체계를 확인 해주세요");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"DESCRIPTION_LOC")==""){
				alert("품명을 입력 해주세요");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"SPECIFICATION")==""){
				alert("규격을 입력 해주세요");
				return;
			}	
			if(mySheet.GetCellValue(arrRow[i],"MAKER_CODE")==""){
				alert("제조사코드를 입력 해주세요");
				return;
			}	
			if(mySheet.GetCellValue(arrRow[i],"ORIGIN_CODE")==""){
				alert("원산지를 입력 해주세요");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"ORDER_MEASURE")==""){
				alert("단위를 입력 해주세요");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"ITEM_GUBUN")==""){
				alert("상품구분을 입력 해주세요");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"ITEM_GROUP")==""){
				alert("자재구분을 입력 해주세요");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"ONOFF_TYPE")==""){
				alert("등록유형을 입력 해주세요");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"STD_FLAG")==""){
				alert("표준화여부를 입력 해주세요");
				return;
			}
		}
		
		if (!confirm('표준카탈로그 저장 하시겠습니까?')){
			return;
		}else{
			kepSave(document.searchCondition ,  mySheet , "/mdcm/saveTempMasterMdCmStndCatalogRegList.do" , "SELECTED" );
		}
		
		break; 
	case "categ": //추천
		AjaxCallCount = 0;
		AjaxSuccCount = 0;
		AjaxFailFlag = "N";
		
		for (var i=0; i<arrRow.length; i++){
			var st_categ_desc = mySheet.GetCellValue(arrRow[i],"DESCRIPTION_LOC"); // 품목명
			var st_categ_spec = mySheet.GetCellValue(arrRow[i],"SPECIFICATION"); // 규격
			
			if(kepIsValueNull(st_categ_desc)) {
				alert('품목명은 필수 입력항목입니다. ['+i+' 번째]');
				mySheet.SelectCell(i, "DESCRIPTION", 1, "");
				return;
			}
			
			if(kepIsValueNull(st_categ_spec)) {
				alert('규격은 필수 입력항목입니다. ['+i+' 번째]');
				mySheet.SelectCell(i, "SPECIFICATION", 1, "");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"STATUS_CD")!="S"){
				alert("미생성 상태만 추천 가능합니다.");
				return;
			}
		}
		
		if(confirm("데이터량에 따라 최대 3분 정도 소요될 수 있습니다. \n자동추천을 실행하시겠습니까?")){
			for (var i=0; i<arrRow.length; i++){
				var st_categ_desc = mySheet.GetCellValue(arrRow[i],"DESCRIPTION_LOC"); // 품목명
				var st_categ_spec = mySheet.GetCellValue(arrRow[i],"SPECIFICATION"); // 규격
				var st_categ_maker = mySheet.GetCellValue(arrRow[i],"MAKER_NAME"); // 제조사명
				var st_categ_model = mySheet.GetCellValue(arrRow[i],"MODEL_INFO"); // 모델번호
				
				document.categForm.categ_row_no.value = arrRow[i];
				document.categForm.categ_desc.value = st_categ_desc;
				document.categForm.categ_spec.value = st_categ_spec;
				document.categForm.categ_maker.value = st_categ_maker;
				document.categForm.categ_model.value = st_categ_model;
				
				kepAjaxFormCall("/mprq/searchCategAutoSetting.do","categForm","DQCAT");
			}
		}
		break;
	}
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {

	return DATA;
}
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	if (msg != "") {
		alert(msg);
	}		

}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(g_gubun== "saveMasterMdCmStndCatalogApprList"){
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=SCA&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg.usrmsg+'&requesTemptYn=N&PARAM1=KRKORE0001', "1000,500,no");
	}else{
		if(!checkedSession(stCode)){return;}
		if (msg != "") {
			alert(msg);
		}
		if(code>0){
			//저장 성공시 재조회
			doAction('search');
		}
	}
		

}

//엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {
	var maxRow  = mySheet.RowCount();
	if(maxRow == 0){
		  return;
	}
	
	for(var i=1; i<= maxRow; i++){
		mySheet.SetCellValue(i,"SELECTED","1");
	}
	
	kepSave(document.searchCondition ,  mySheet , "/mdcm/batchMasterMdCmStndCatalogRegList.do" , "SELECTED" );
}


//TABLE의 ROW 데이타 생성
function addrows() {
	
	var rows = mySheet.DataInsert(-1);
}
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if (column == 'CMS_CATEG_NAME') { // KEP 표준카테고리 선택
		popupSel = "masterMpRqKepStndrdCategorySelPop";
		var desc = mySheet.GetCellValue(Row,"DESCRIPTION_LOC"); // 품목명
		var spec = mySheet.GetCellValue(Row,"SPECIFICATION"); // 규격
		var maker = mySheet.GetCellValue(Row,"MAKER_NAME"); // 제조사명
		var model = mySheet.GetCellValue(Row,"MODEL_INFO"); // 모델번호
		
		var new_popup = window.open('','categ','scrollbars=no,width=728,height=510,resizable=no');
	    document.categFlow.action = "/mprq/showMasterMpRqKepStndrdCategoryRcmdPop.do";
	    document.categFlow.target = "categ";
	    document.categFlow.method = "post";
	    
	    document.categFlow.categ_desc_flow.value = escape(desc);
	    document.categFlow.categ_spec_flow.value = escape(spec);
	    document.categFlow.categ_maker_flow.value = escape(maker);
	    document.categFlow.categ_model_flow.value = escape(model);
	    
	    document.categFlow.submit();
	    new_popup.focus();
		
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
		,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
		,value21,value22,value23,value24,value25,value26,value27,value28,value29){
	
	 if (popupSel == "masterMpRqKepStndrdCategorySelPop") {	//KEP 표준카테고리 선택 
			mySheet.SetCellValue(grbRow, 'CMS_CATEG_ID', value3);
			mySheet.SetCellValue(grbRow, 'CMS_CATEG_NAME', value5);
		}
}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	if(pMethod == "DQCAT"){
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow = selectedGrid.split("|");
		
		AjaxCallCount++;
		AjaxSuccCount++;
		
		loader_obj("Y");
		
		// response.categ_row_no1 = 매치율 1순위 리턴값만 사용 (ex response.categ_row_no5 = 5순위 리턴값)
		var categ_row_no = response.categ_row_no1;
		
		mySheet.SetCellValue(categ_row_no, "CMS_CATEG_NAME", response.categName1);
		mySheet.SetCellValue(categ_row_no, "CMS_CATEG_ID", response.cmsCategId1);
		
		if(AjaxCallCount == arrRow.length){
			if(AjaxSuccCount == arrRow.length){
				loader_obj("N");
				AjaxFailFlag = "N";
				alert("추천이 성공적으로 완료되었습니다.");
			}else{
				loader_obj("N");
				alert("추천 중 오류가 발생하였습니다. 관리자에게 문의 바랍니다.");
			}
		}
	}
}
//결재성공시 재조회
function kepApprovalReturn(flag,docu_no){
	doAction('search');
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>표준카탈로그 등록</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>  
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id = "searchCondition" name = "searchCondition" method = "post" >
            <div id="cont_searchA">
 			<input type="hidden" name="s_SAVENAME">
			<!--HIDDEN-->
			<!-- 공통 -->
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
			<input type="hidden" id="DOC_TYPE" name="DOC_TYPE"  value="">
			<input type="hidden" id="pageflag" name="pageflag"  value="0">
            <input type="hidden" id="USR_ID" name="USR_ID"  value="${sessionInfo.userId}">
            <input type="hidden" name="st_doc_type"  id="st_doc_type" value ="">
            	<table  class="cont_t_list01" >
						<caption>견적의뢰 접수</caption>
						<colgroup>
							<col width="10%" />
							<col width="23%" />
							<col width="9%" />
							<col width="25%" />
							<col width="8%" />
	                        <col width="23%" />
						</colgroup>
						
						<tbody>
							<tr>
							<td>등록일</td>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								-
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
							</td>
							<td>진행상태</td>
							<td>
								<select name="st_status" id="st_status" >
				                    <option value="">전체</option>
				                    <option value="S">미생성</option>
				                    <option value="P">품의상신</option>
				                    <option value="B">반려</option>
				                    <option value="C">승인</option>
			                  </select>
							</td>
						</tr>
						<tr> 
							<td>품목명</td>
							<td>
								<input type="text" class="input_type_text" id="st_description_loc" name="st_description_loc" style="width:80%;" value=""  onkeydown="kepEnter()">
							</td>
							<td>규격</td>
							<td>
								<input type="text" class="input_type_text" id="st_sepcification" name="st_sepcification" style="width:80%;" value=""  onkeydown="kepEnter()">
							</td>
							<td></td>
							<td>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
		</form>
		<form name="categFlow" id="categFlow" method="post" action ="">
		    <input type="hidden" name="categ_desc_flow" id="categ_desc_flow" value="">
		    <input type="hidden" name="categ_spec_flow" id="categ_spec_flow" value="">
		    <input type="hidden" name="categ_maker_flow" id="categ_maker_flow" value="">
		    <input type="hidden" name="categ_model_flow" id="categ_model_flow" value="">
		</form>
		<form name="categForm" id="categForm" method="post" action ="">
			<input type="hidden" name="categ_target_rate" id="categ_target_rate" value="60">
			<input type="hidden" name="categ_target_count" id="categ_target_count" value="1">
			<input type="hidden" name="categ_row_no" id="categ_row_no" value="">
		    <input type="hidden" name="categ_desc" id="categ_desc" value="">
		    <input type="hidden" name="categ_spec" id="categ_spec" value="">
		    <input type="hidden" name="categ_maker" id="categ_maker" value="">
		    <input type="hidden" name="categ_model" id="categ_model" value="">
		    <input type="hidden" name="categ_desc_flag" id="categ_desc_flag" value="true">
		    <input type="hidden" name="categ_spec_flag" id="categ_spec_flag" value="true">
		    <input type="hidden" name="categ_maker_flag" id="categ_maker_flag" value="true">
		    <input type="hidden" name="categ_model_flag" id="categ_model_flag" value="false">
		</form>
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			
  			<!--버튼영역-->
               <div class="btnArea">
				<span class="fl">
  					<span class="btn_05 mr04"><a href="javascript:doAction('loadExcel');">일괄 업로드</a></span>
  					<span class="btn_04"><a href="/resources/excel/work/CATALOG/masterMdCmStndCatalogRegList.xls">등록양식</a></span>
  				</span>
  	          	<span class="fr">
  					<span class="btn_04 mr04" style="display:none"><a href="javascript:doAction('excelDown');">다운로드</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('categ');">추천</a></span>  
  					<!--span class="btn_02 mr04"><a href="javascript:addrows();">행추가</a></span-->
					<span class="btn_02 mr04"><a href="javascript:doAction('tempSave');">저장</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
  					<span class="btn_02"><a href="javascript:doAction('saveAppr');">품의상신</a></span>
  				</span> 
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
