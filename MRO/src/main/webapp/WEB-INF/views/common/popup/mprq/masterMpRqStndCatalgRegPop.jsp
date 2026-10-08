<%--
**********************************************
* 메뉴 : 표준카탈로그등록 팝업
* 화면 : 표준카탈로그등록
* 기능 :
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
</head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
<%
// 공통
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
String total_cnt =CommonUtil.nvl((String)request.getAttribute("totalCnt"),"0"); // 조회된 결과

String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.

String st_maker_nm = CommonUtil.nvl((String) request.getParameter("st_maker_nm"),"");
String st_category_path = CommonUtil.nvl((String) request.getParameter("st_category_path"),""); 
String st_categ_id = CommonUtil.nvl((String) request.getParameter("st_categ_id"),""); 
String st_mast_check = CommonUtil.nvl((String) request.getParameter("st_mast_check"),"");
String st_categ_name = CommonUtil.nvl((String) request.getParameter("st_categ_name"),"");
String st_sg_nm = CommonUtil.nvl((String) request.getParameter("st_sg_nm"),""); 
String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");
String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");
String st_status = CommonUtil.nvl((String) request.getParameter("st_status"),"");

String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");
String st_quotation_seq = CommonUtil.nvl((String) request.getParameter("st_quotation_seq"),"");
String st_revision = CommonUtil.nvl((String) request.getParameter("st_revision"),"");
String st_cms_catalgid = CommonUtil.nvl((String) request.getParameter("st_cms_catalgid"),"");



boolean list = true;
 if (_gridList == null || _gridList.size() == 0){
	 list = false;
 }
%>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var manageDept = KepSheetComboQueryIdData('getKepDeptList','SEL','');	// IBSHEET : 담당부서
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
    var v_item_gubun = KepSheetComboData("M118","");
    var item_gubun_type = {ComboCode: v_item_gubun.ComboCode, ComboText: v_item_gubun.ComboText};
    
	var initsheet = {};
	initsheet.HeaderMode = {Sort : 0};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:30,	Edit:true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:50,	Edit:false,	EditLen:110,	Hidden : true,Type:"Text",	Header:"순서",	SaveName:"SEQ"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:10,	Type:"Text",	Hidden : true,Header:"표준카탈로그ID",	SaveName:"CMS_CATLG_ID"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:20,	Type:"Text",	Header:"표준카테고리ID",	SaveName:"CMS_CATEG_ID"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:200,	Type:"Text",	Header:"표준카테고리명",	SaveName:"CMS_CATEG_NAME" ,BackColor:"${optColor}"}
					,{ Align:"Center",	Width:40,	Edit:false,	EditLen:200,	Hidden : true,Type:"Text",	Header:"상태",	SaveName:"STATUS"}
					,{ Align:"Left",	Width:150,	Edit:true,	EditLen:300,	Type:"Text",	Header:"표준품목명",	SaveName:"DESCRIPTION_LOC" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:150,	Edit:true,	EditLen:300	,	Type:"Text",	Header:"표준품목명(영문)",	SaveName:"DESCRIPTION_ENG" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:150,	Edit:true,	EditLen:300,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:150,	Edit:true,	EditLen:300,	Type:"Text",	Header:"규격(영문)",	SaveName:"SPECIFICATION_ENG" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:80,	Edit:true,	EditLen:10,	Type:"Text",	Header:"제조사코드",	SaveName:"MAKER_CODE"}
					,{ Align:"Left",	Width:80,	Edit:true,	EditLen:200,	Type:"Text",	Header:"제조사명",	SaveName:"MAKER_NAME" ,BackColor:"${optColor}"} 
					,{ Align:"Left",	Width:80,	Edit:true,	EditLen:2,	Type:"Text",	Header:"원산지코드",	SaveName:"ORIGIN_CODE"}
					,{ Align:"Left",	Width:80,	Edit:true,	EditLen:10,	Type:"Text",	Header:"원산지명",	SaveName:"ORIGIN_NAME" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:60,	Edit:true,	EditLen:4,	Type:"Text",	Header:"단위",	SaveName:"ORDER_MEASURE" ,BackColor:"${optColor}"}
					,{ Align:"Center",	Width:150,	Edit:true,	EditLen:200,	Type:"Text",	Header:"모델정보",	SaveName:"MODEL_INFO" }
					,{ Align:"Left",	Width:120,	Edit:true,	EditLen:200,	Type:"Text",	Header:"비고",	SaveName:"REMARK"}
					,{ Align:"Center",	Width:120,	Edit:true,	EditLen:120,	Type:"Combo",	Header:"팀코드",	SaveName:"KEP_DEPT" ,BackColor:"${optColor}", ComboText:manageDept.ComboText, 	ComboCode:manageDept.ComboCode}
					,{ Align:"Center",	Width:80,	Edit:true,	EditLen:80,	Type:"Text",	Header:"그룹유형",	SaveName:"STOCK_GROUP_TYPE" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:200,	Type:"Text",	Header:"상품이미지경로",	SaveName:"IMGFILE_DIR"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:200,	Type:"Text",	Header:"상품이미지파일명",	SaveName:"IMGFILE_NAME"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:200,	Type:"Text",	Header:"상품상세이미지경로",	SaveName:"DETAIL_IMGFILE_DIR"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:200,	Type:"Text",	Header:"상품상세이미지파일명",	SaveName:"DETAIL_IMGFILE_NAME"}
					,{ Align:"Left",	Width:80,	Edit:true,	EditLen:300,	Type:"Combo",	ComboText:"N|Y", 		ComboCode:"N|Y",	 Header:"표준화여부",	SaveName:"STD_FLAG"  ,BackColor:"${optColor}"}
					,{ Align:"Center",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",Header:"품목구분",	SaveName:"ITEM_GUBUN"}
					];
	//InitHeaders의 두번째 인자
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(4);
	//하이퍼링크 설정
	setLinkCol(mySheet, "CMS_CATEG_NAME");
	setLinkCol(mySheet, "MAKER_NAME");
	setLinkCol(mySheet, "ORIGIN_NAME");
	
	// 복사가능 컬럼 언더라인 표시
	mySheet.SetCellFontUnderline(0, "DESCRIPTION_LOC", true);
	mySheet.SetCellFontUnderline(0, "DESCRIPTION_ENG", true);
	mySheet.SetCellFontUnderline(0, "SPECIFICATION", true);
	mySheet.SetCellFontUnderline(0, "SPECIFICATION_ENG", true);
	mySheet.SetCellFontUnderline(0, "MAKER_NAME", true);
	mySheet.SetCellFontUnderline(0, "ORIGIN_NAME", true);
	mySheet.SetCellFontUnderline(0, "ORDER_MEASURE", true);
	mySheet.SetCellFontUnderline(0, "CMS_CATEG_NAME", true);
	mySheet.SetCellFontUnderline(0, "KEP_DEPT", true);
	
	mySheet.SetColProperty("ITEM_GUBUN", item_gubun_type);

}
//기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	
	var maxRow = mySheet.RowCount();
	// 선택된 항목 유무 체크
	if ((str =="del" || str =="save") && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "save": // 저장
		for(var i=0; i<arrRow.length; i++){

			if(mySheet.GetCellValue(arrRow[i],"CMS_CATLG_ID") != ""){
				alert("이미 등록된 상품 입니다");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID") == ""){
				alert("표준카테고리를 입력 해주세요");
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
			if(mySheet.GetCellValue(arrRow[i],"ONOFF_TYPE")==""){
				alert("등록유형을 입력 해주세요");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"STD_FLAG")==""){
				alert("표준화여부를 입력 해주세요");
				return;
			}
		}
		
		if (!confirm('표준 카탈로그 등록 품의 상신 하시겠습니까?')){
			return;
		}else{
			document.searchCondition.DOC_TYPE.value = "SCA";
			g_gubun= "saveMasterMdCmStndCatalogApprList";
			kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMdCmStndCatalogApprPop.do" , "SELECTED" );
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
		this.close();		
	}

}

//TABLE의 ROW 데이타 생성
function addrows() {
	
	var rows = mySheet.DataInsert(-1);
	mySheet.SetCellValue(rows, 'STD_FLAG', "Y");
	mySheet.SetCellValue(rows, 'ITEM_GUBUN', "G");
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
		
	}else  if (column == "MAKER_NAME" ){  // 제조사 선택
		popupSel = "maker";
			
		openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
	
	}else if (column == "ORIGIN_NAME" ){ // 원산지 선택
		popupSel = "country";
		openSearchPopup("/common/countryCodePop.do", "", "500,500,no");
	
	}
}

function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if(Row > 0) return;
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	if (checkRows.length == 0){
		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	var arrRow = checkRows.split("|");
	
	if(mySheet.ColSaveName(Col) == "DESCRIPTION_LOC"){ // 표준품명
		var value1 = mySheet.GetCellValue(arrRow[0], "DESCRIPTION_LOC");
		if(kepIsValueNull(value1)){
			alert("복사할 표준품목명을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "DESCRIPTION_LOC", value1);
		}
	}else if(mySheet.ColSaveName(Col) == "DESCRIPTION_ENG"){ // 표준품명(영문)
		var value1 = mySheet.GetCellValue(arrRow[0], "DESCRIPTION_ENG");
		if(kepIsValueNull(value1)){
			alert("복사할 표준품목명(영문)을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "DESCRIPTION_ENG", value1);
		}
	}else if(mySheet.ColSaveName(Col) == "SPECIFICATION"){ // 규격
		var value1 = mySheet.GetCellValue(arrRow[0], "SPECIFICATION");
		if(kepIsValueNull(value1)){
			alert("복사할 규격을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "SPECIFICATION", value1);
		}
	}else if(mySheet.ColSaveName(Col) == "SPECIFICATION_ENG"){ // 규격(영문))
		var value1 = mySheet.GetCellValue(arrRow[0], "SPECIFICATION_ENG");
		if(kepIsValueNull(value1)){
			alert("복사할 규격(영문)을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "SPECIFICATION_ENG", value1);
		}
	}else if(mySheet.ColSaveName(Col) == "MAKER_NAME"){ // 제조사
		var value1 = mySheet.GetCellValue(arrRow[0], "MAKER_NAME");
		var value2 = mySheet.GetCellValue(arrRow[0], "MAKER_CODE");
		if(kepIsValueNull(value1)){
			alert("복사할 제조사명을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "MAKER_NAME", value1);
			mySheet.SetCellValue(arrRow[idx], "MAKER_CODE", value2);
		}
	}else if(mySheet.ColSaveName(Col) == "ORIGIN_NAME"){ // 원산지
		var value1 = mySheet.GetCellValue(arrRow[0], "ORIGIN_NAME");
		var value2 = mySheet.GetCellValue(arrRow[0], "ORIGIN_CODE");
		if(kepIsValueNull(value1)){
			alert("복사할 원산지명을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "ORIGIN_NAME", value1);
			mySheet.SetCellValue(arrRow[idx], "ORIGIN_CODE", value2);
		}
	}else if(mySheet.ColSaveName(Col) == "ORDER_MEASURE"){ // 단위
		var value1 = mySheet.GetCellValue(arrRow[0], "ORDER_MEASURE");
		if(kepIsValueNull(value1)){
			alert("복사할 단위를 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "ORDER_MEASURE", value1);
		}
	}else if(mySheet.ColSaveName(Col) == "CMS_CATEG_NAME"){ // 표준카테고리
		var value1 = mySheet.GetCellValue(arrRow[0], "CMS_CATEG_NAME");
		var value2 = mySheet.GetCellValue(arrRow[0], "CMS_CATEG_ID");
		if(kepIsValueNull(value1)){
			alert("복사할 표준카테고리명을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "CMS_CATEG_NAME", value1);
			mySheet.SetCellValue(arrRow[idx], "CMS_CATEG_ID", value2);
		}
	}else if(mySheet.ColSaveName(Col) == "KEP_DEPT"){ // 팀코드
		var value1 = mySheet.GetCellValue(arrRow[0], "KEP_DEPT");
		if(kepIsValueNull(value1)){
			alert("복사할 팀코드를 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "KEP_DEPT", value1);
		}
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
		,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
		,value21,value22,value23,value24,value25,value26,value27,value28,value29){
	
	 if (popupSel == "masterMpRqKepStndrdCategorySelPop") {	//KEP 표준카테고리 선택 
			mySheet.SetCellValue(grbRow, 'CMS_CATEG_ID', value3);
			mySheet.SetCellValue(grbRow, 'CMS_CATEG_NAME', value5);
	}else if (popupSel == "maker") {	// 제조사
			mySheet.SetCellValue(grbRow, 'MAKER_CODE', value1);
			mySheet.SetCellValue(grbRow, 'MAKER_NAME', value2);
			mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value3);
			mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value4);
	} else if (popupSel == "country") {	// 원산지
		mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value1);
		mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value3);
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
	this.close();
}
</script>

<body onload="kep_onload_view()">
<!--내용 시작-->
        <!--조회영역-->
       	<form id = "searchCondition" name = "searchCondition" method = "post" >
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME">
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
				<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
				<input type="hidden" id="DOC_TYPE" name="DOC_TYPE"  value="">
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
	<div id="popWrapper" style="height:504px;">
    	<div id="popHeader">
        	<h1 class="title">표준카탈로그 등록</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <br>
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "99%", "200px");
  				</script>
  			</div>
  			<!--버튼영역-->
  			<br>
               <div class="btnArea">
  	          	<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('categ');">추천</a></span> 
  					<span class="btn_02 mr04"><a href="javascript:addrows();">행추가</a></span> 
  					<span class="btn_02"><a href="javascript:doAction('save');">품의상신</a></span>
  				</span> 
  			 </div>
</div>
<!--내용 종료-->	                 
</body>
</html>
