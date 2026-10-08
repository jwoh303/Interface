<%--
**********************************************
* 메뉴 : 카탈로그관리>카탈로그 매핑관리
* 화면 :카탈로그 매핑 관리
* 기능 : 카탈로그 매핑 관리
* 프로그램 ID : 
* 담당자 : 현명환 
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String SessionUserId         = sessionInfo.getUserId();
	//카탈로그 매핑업로드 권한 체크
	boolean getRoleYn = CommonUtil.getCodeCheckReturn("M157",SessionUserId);
%>
<!-- 다중선택콤보(공통) - 사용시 필수 선언 start -->
<script src="/resources/js/jquery.multiple.select.js"></script>
<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<!-- 다중선택콤보(공통) - 사용시 필수 선언 end -->

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 2};
	initsheet.Cols = [ 
	 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
	,{ Align:"Center",	Width:30,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED",ColMerge:0}
	,{ Align:"Center",	Width:100,	Wrap:1, Edit:false,	EditLen:300,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER"}
	,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,	EditLen:300,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME_LOC"}
	,{ Align:"Center",	Width:100,	Wrap:1, Edit:false,	EditLen:300,	Type:"Text",	Header:"요청번호",	SaveName:"REQ_NO"}
	,{ Align:"Center",	Width:100,	Wrap:1, Edit:false,		Type:"Text",	Header:"카탈로그상태",	SaveName:"BYIT_STATUS"}
	,{ Align:"Center",	Width:100,	Wrap:1, Edit:false,		Type:"Text",	Header:"진행상태",	SaveName:"STATUS_NM"}
	,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,		Type:"Text",	Header:"담당자부서",	SaveName:"DEPARTMENT_NAME"}
	,{ Align:"Left",	Width:80,	Wrap:1, Edit:false,		Type:"Text",	Header:"담당자ID",	SaveName:"KEP_USER_ID"}
	,{ Align:"Center",	Width:80,	Wrap:1, Edit:false,		Type:"Text",	Header:"담당자",	SaveName:"KEP_USER_NAME"}
	,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,		Type:"Text",	Header:"SG명",	SaveName:"SG_NAME"}
	,{ Align:"Left",	Width:110,	Wrap:1, Edit:false,		Type:"Text",	Header:"표준카테고리",	SaveName:"CMS_CATEG_NAME"}
	,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,		Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
	,{ Align:"Left",	Width:150,	Wrap:1, Edit:false,		Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION_LOC"}
	,{ Align:"Left",	Width:150,	Wrap:1, Edit:false,		Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
	,{ Align:"Left",	Width:80,	Wrap:1, Edit:false,		Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
	,{ Align:"Center",	Width:80,	Wrap:1, Edit:false,		Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NAME"}
	,{ Align:"Center",	Width:50,	Wrap:1, Edit:false,		Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
	,{ Align:"Center",	Width:50,	Wrap:1, Edit:false,		Type:"Text",	Header:"MSDS",	SaveName:"MSDS_YN"}
	,{ Align:"Center",	Width:80,	Wrap:1, Edit:false,		Type:"Image",	Header:"폼목이미지",	SaveName:"IMGFILE_NAME_IMG", BackColor:"${optColor}"}
	,{ Align:"Center",	Width:80,	Wrap:1, Edit:false,		Type:"Image",	Header:"운영사비고",	SaveName:"ATOS_REMARK_IMG", BackColor:"${optColor}"}
	,{ Align:"Center",	Width:90,	Wrap:1, Edit:false,		Type:"Text",	Header:"협력사코드",	SaveName:"AGENT"}
	,{ Align:"Center",	Width:90,	Wrap:1, Edit:false,		Type:"Text",	Header:"품목구분코드",	SaveName:"ITEM_TYPE"}
	,{ Align:"Center",	Width:90,	Wrap:1, Edit:false,		Type:"Text",	Header:"품목구분",	SaveName:"ITEM_TYPE_NM"}
	,{ Align:"Center",	Width:90,	Wrap:1, Edit:false,		Type:"Text",	Header:"작업코드",	SaveName:"JOB_TYPE"}
	,{ Align:"Center",	Width:90,	Wrap:1, Edit:false,		Type:"Text",	Header:"작업구분",	SaveName:"JOB_TYPE_NM"}
	,{ Align:"Center",	Width:100,	Wrap:1, Edit:false,		Type:"Text",	Header:"표준카탈로그코드",	SaveName:"CMS_CATLG_ID", BackColor:"${optColor}"}
	,{ Align:"Center",	Width:70,	Wrap:1, Edit:false,	Hidden : true,	Type:"Text",	Header:"추천구분",	SaveName:"CATALOG_CHOICE_TYPE"}
	,{ Align:"Center",	Width:70,	Wrap:1, Edit:false,		Type:"Text",	Header:"추천구분",	SaveName:"CATALOG_CHOICE_TYPE_NM"}
	,{ Align:"Left",	Width:120,	Wrap:1, Edit:true,		Type:"Text",	Header:"반려사유",	SaveName:"REJECT_REMARK", BackColor:"${optColor}"}
	,{ Align:"Center",	Width:50,	Wrap:1, Edit:false,		Type:"Text",	Header:"계약여부",	SaveName:"CONTRACT_YN"}
	,{ Align:"Center",	Width:80,	Wrap:1, Edit:false,		Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME_LOC"}
	,{ Align:"Center",	Width:50,	Wrap:1, Edit:false,		Type:"Text",	Header:"차수",	SaveName:"REVISION", BackColor:"${optColor}"}
	,{ Align:"Center",	Width:150,	Wrap:1, Edit:false,		Type:"Text",	Header:"보완요청 품목명",	SaveName:"S_DESCRIPTION_LOC"}
	,{ Align:"Left",	Width:150,	Wrap:1, Edit:false,		Type:"Text",	Header:"보완요청 규격",	SaveName:"S_SPECIFICATION"}
	,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,		Type:"Text",	Header:"보완요청 제조사",	SaveName:"S_MAKER_NAME"}
	,{ Align:"Left",	Width:90,	Wrap:1, Edit:false,		Type:"Text",	Header:"보완요청 원산지",	SaveName:"S_ORIGIN_NAME"}
	,{ Align:"Left",	Width:80,	Wrap:1, Edit:false,		Type:"Text",	Header:"보완요청 단위",	SaveName:"S_UNIT_MEASURE"}
	,{ Align:"Center",	Width:90,	Wrap:1, Edit:false,		Type:"Text",	Header:"보완요청 MSDS",	SaveName:"S_MSDS_YN"}
	,{ Align:"Left",	Width:120,	Wrap:1, Edit:false,		Type:"Text",	Header:"보완요청 모델",	SaveName:"S_MAKER_PART_NO"}
	,{ Align:"Center",	Width:100,	Wrap:1, Edit:false,		Type:"Image",	Header:"이미지(협력사)",	SaveName:"S_IMGFILE_NAME_IMG", BackColor:"${optColor}"}
	,{ Align:"Center",	Width:100,	Wrap:1, Edit:false,		Type:"Image",	Header:"파일첨부(협력사)",	SaveName:"IMAGE_KEY_IMG", BackColor:"${optColor}"}
	,{ Align:"Center",	Width:80,	Wrap:1, Edit:false,		Type:"Image",	Header:"협력사비고",	SaveName:"STOA_REMARK_IMG", BackColor:"${optColor}"}
	,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,	Hidden : true,	Type:"Text",	Header:"ATOS_REMARK",	SaveName:"ATOS_REMARK"}
	,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,	Hidden : true,	Type:"Text",	Header:"STOA_REMARK",	SaveName:"STOA_REMARK"}
	,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,	Hidden : true,	Type:"Text",	Header:"IMGFILE_DIR",	SaveName:"IMGFILE_DIR"}
	,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,	Hidden : true,	Type:"Text",	Header:"IMGFILE_NAME",	SaveName:"IMGFILE_NAME"}
	,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,	Hidden : true,	Type:"Text",	Header:"S_IMGFILE_DIR",	SaveName:"S_IMGFILE_DIR"}
	,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,	Hidden : true,	Type:"Text",	Header:"S_IMGFILE_NAME",	SaveName:"S_IMGFILE_NAME"}
	,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,	Hidden : true,	Type:"Text",	Header:"CMS_CATEG_ID",	SaveName:"CMS_CATEG_ID"}
	,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,	Hidden : true,	Type:"Text",	Header:"STATUS",	SaveName:"STATUS"}
	,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,	Hidden : true,	Type:"Text",	Header:"BYCA_COMORG_CODE",	SaveName:"BYCA_COMORG_CODE"}
	,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,	Hidden : true,	Type:"Text",	Header:"STATUS_CD",	SaveName:"STATUS_CD"}
	,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,	Hidden : true,	Type:"Text",	Header:"IMAGE_KEY",	SaveName:"IMAGE_KEY"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);
	mySheet.SetImageList(3, diskOn);
	mySheet.SetImageList(2, diskOff);
	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val(kepToDateAdd("30","M"));
	$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
	
	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_sg_user_id','getSsgKepUserList','ALL2','');
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "IMGFILE_NAME_IMG");
	setLinkCol(mySheet, "ATOS_REMARK_IMG");
	setLinkCol(mySheet, "S_IMGFILE_NAME_IMG");
	setLinkCol(mySheet, "STOA_REMARK_IMG");
	setLinkCol(mySheet, "CMS_CATEG_NAME");
	setLinkCol(mySheet, "CMS_CATLG_ID");
	setLinkCol(mySheet, "REVISION");
	setLinkCol(mySheet, "IMAGE_KEY_IMG");
	// 콤보데이터 셋팅
	kepAjaxCommonQueryIdSearchTwoCombo('st_add_user_id','common.masterDepartmentUserList','PG_10_M_006_00','','ALL','${sessionInfo.userId}'); // 조회조건 : 담당자
}

	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");

	switch (str) {
	case "search":	 // 조회
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
			alert("조회기간을 3개월 단위로 조회가 가능합니다.");
			return;
		}

		kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmCatalogMappingList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$('#st_buyer_code').val("");
		mySheet.RemoveAll();
		
		// 다중선택콤보(공통) - 초기화
		init_multiCombo("st_status");
		
		$("#st_from_date").val(kepToDateAdd("7","M"));
		$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
		break;
	case "mapping": // 매핑
		for (var i=0; i<arrRow.length; i++){
			var cmsCatlgId    = mySheet.GetCellValue(arrRow[i],"CMS_CATLG_ID");
			if(cmsCatlgId == ""){
				alert(i+1+"번째 매핑된 표준카탈로그가 정보가 없어 처리 불가능합니다.");
				return;
			}
		}
		if (!confirm("선택한 항목을 품목매핑 처리 하시겠습니까?"))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMdCmCatalogMapping.do","SELECTED");
		break;
	case "reject": // 매핑반려
		for (var i=0; i<arrRow.length; i++){
			var cmsCatlgId    = mySheet.GetCellValue(arrRow[i],"CMS_CATLG_ID");
			if(cmsCatlgId == ""){
				alert(i+1+"번째 매핑된 표준카탈로그가 정보가 없어 처리 불가능합니다.");
				return;
			}
			var remark    = mySheet.GetCellValue(arrRow[i],"REJECT_REMARK");
			if(remark == ""){
				alert(i+1+"번째 반려사유를 입력 바랍니다.");
				return;				
			}
			var st_status = mySheet.GetCellValue(arrRow[i],"STATUS");
			if(st_status != "M"){
				alert(i+1+"번째 진행상태가 매핑건만 반려 가능 합니다.");
				return;				
			}
		}
		if (!confirm('선택한 항목을 매핑반려 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mdcm/rejectMasterMdCmCatalogMapping.do" , "SELECTED" );
		break;
	case "mappingCompl": // 매핑완료
		for (var i=0; i<arrRow.length; i++){
			var cmsCatlgId    = mySheet.GetCellValue(arrRow[i],"CMS_CATLG_ID");
			if(cmsCatlgId == ""){
				alert(i+1+"번째 매핑된 표준카탈로그가 정보가 없어 처리 불가능합니다.");
				return;
			}
			var st_status = mySheet.GetCellValue(arrRow[i],"STATUS");
			if(st_status != "M"){
				alert(i+1+"번째 진행상태가 매핑건만 매핑완료 처리 가능 합니다.");
				return;				
			}
		}
		if (!confirm('선택한 항목을 매핑완료 처리 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMdCmCatalogMappingCompl.do" , "SELECTED" );
		break;
	case "mappingDel": // 삭제
		for (var i=0; i<arrRow.length; i++){
			var st_status = mySheet.GetCellValue(arrRow[i],"STATUS");
			if(st_status != "S"){
				alert(i+1+"번째 진행상태가 미매핑건만 삭제 처리 가능 합니다.");
				return;				
			}
		}
		if (!confirm('선택한 항목을 삭제 처리 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMdCmCatalogMappingDel.do" , "SELECTED" );
		break;
	case "reqItem": // 보완요청
		for (var i=0; i<arrRow.length; i++){
			var st_status = mySheet.GetCellValue(arrRow[i],"STATUS");
			if(st_status != "S"&&st_status != "A"&&st_status != "B"){
				alert(i+1+"번째 진행상태가 미매핑, 협력사 보완완료, 매핑반려\n상태가 아니므로 품목 보완요청이 불가능 합니다.");
				return;				
			}
			var st_contract_yn = mySheet.GetCellValue(arrRow[i],"CONTRACT_YN");
			if(st_contract_yn == "N"){
				alert(i+1+"번째 협력사 미계약 품목이므로 보완요청이 불가능 합니다.");
				return;				
			}
			
		}
		if (!confirm('선택한 항목을 품목보완 요청처리 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMdCmReqAgentCatalog.do" , "SELECTED" );
		break;
	case "req": //매핑요청
		for (var i=0; i<arrRow.length; i++){
			var st_buyer    = mySheet.GetCellValue(arrRow[i],"BUYER");
			var st_buyer_item_no    = mySheet.GetCellValue(arrRow[i],"BUYER_ITEM_NO");
			var st_kep_user_id    = mySheet.GetCellValue(arrRow[i],"KEP_USER_ID");
			var st_item_type    = mySheet.GetCellValue(arrRow[i],"ITEM_TYPE");
			var st_job_type    = mySheet.GetCellValue(arrRow[i],"JOB_TYPE");
			if(st_buyer == ""){
				alert(i+1+"번째 고객사코드 정보가 없습니다.");
				return;
			}
			if(st_buyer_item_no == ""){
				alert(i+1+"번째 품목코드 정보가 없습니다.");
				return;
			}
			if(st_kep_user_id == ""){
				alert(i+1+"번째 담당자 정보가 없습니다.");
				return;
			}
			if(st_item_type == ""){
				alert(i+1+"번째 품목구분 정보가 없습니다.");
				return;
			}
			if(st_job_type == ""){
				alert(i+1+"번째 작업구분 정보가 없습니다.");
				return;
			}
		}
		if (!confirm("선택한 항목을 품목매핑 요청 하시겠습니까?"))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMdcmReqMapping.do","SELECTED");
		break;
	case "loadExcel": // 일괄 업로드
		mySheet.RemoveAll();
		var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"||1||||||4||||2|||||||||3|5||6|"};
		mySheet.LoadExcel(params);

		break;
	case "excelDown": // 엑셀다운로드
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		
		if (kepGetDateDiff('st_from_date','st_to_date','D') >  93 ){
			alert("조회기간을 3개월 단위로 조회가 가능합니다.");
			return;
		}
	
	    $("#pageflag").val('0');
		var fromTo =  $("#st_from_date").val().replace(/\//gi, "") + "_" + $("#st_to_date").val().replace(/\//gi, "");
	    var param = {FileName:"카탈로그매핑관리_"+fromTo+".xlsx",Merge:1,SheetDesign:1,DownCols:"BUYER|BUYER_NAME_LOC|REQ_NO|BYIT_STATUS|STATUS_NM|DEPARTMENT_NAME|KEP_USER_ID|KEP_USER_NAME|SG_NAME|CMS_CATEG_NAME|BUYER_ITEM_NO|ITEM_TYPE|ITEM_TYPE_NM|DESCRIPTION_LOC|SPECIFICATION|MAKER_NAME|ORIGIN_NAME|UNIT_MEASURE|CMS_CATLG_ID|REJECT_REMARK|CONTRACT_YN|AGENT|AGENT_NAME_LOC|REVISION|S_DESCRIPTION_LOC|S_SPECIFICATION|S_MAKER_NAME|S_ORIGIN_NAME|S_UNIT_MEASURE"};
		kepDownExcel(document.searchCondition ,mySheet , "/mdcm/excelMasterMdCmCatalogMappingList.do", param);
		$("#pageflag").val('1');
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

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;

	if (msg != "") {
		alert(msg);
	}
	
}
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}
function mySheet_OnMouseMove(Button, Shift, X, Y) { 
	var row = mySheet.MouseRow();

}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmCatalogMappingList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;  
		case "agent_single": // 협력사 M
			openSearchPopup("/common/icomcmpyPop.do", '?BUSINESS_COND=S&MULTI=N', "500,466,no");
			popupSel = "agent_single";
			break;	
		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=000000916&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
		case "maker": // 제조사
			popupSel = "maker";
			var st_del_name = $('#st_maker_name').val();
			openSearchPopup("/common/agentRegMakerCodePop.do", "?st_del_name="+st_del_name, "500,500,no");
			break;
		case "sg_info"://SG정보
			openSearchPopup("/mprq/showMasterMpRqSgChoicePop.do", "", "500,500,no");
			break;
	}
}
//엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {

	//alert("저장");
	return;
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == "ATOS_REMARK_IMG"){
		var st_buyer = mySheet.GetCellValue(Row,"BUYER");
		var st_req_no = mySheet.GetCellValue(Row,"REQ_NO");
		var st_atos_remark = mySheet.GetCellValue(Row,"ATOS_REMARK");
		popupSel = "ATOS_REMARK_IMG";
		openSearchPopup("/common/remarkAtoAPop.do",'?st_buyer='+st_buyer+'&st_req_no='+st_req_no+'&st_type=REQ'+'&st_atoa_remark='+st_atos_remark,"500,200,no");// 운영사비고

	}else if (column == "STOA_REMARK_IMG"){
			var remark = mySheet.GetCellValue(Row,"STOA_REMARK");
			if(remark == ""){
				alert("등록된 비고 내용이 없습니다.");
				return;
			}else{
				openSearchPopup('/common/remarkBtoAPop.do', '?st_btoa_remark='+remark , "500,220,no");	
			}
	}else if(column == "IMGFILE_NAME_IMG"){//운영사 품목 이미지
		var st_imgfile_dir = mySheet.GetCellValue(Row, "IMGFILE_DIR");
		var st_imgfile_name = mySheet.GetCellValue(Row, "IMGFILE_NAME");
		var mod_yn = "N"; //수정여부
		var st_type = "S"; //협력사일경우
		if(st_imgfile_name == ""){
			alert("품목 이미지가 없습니다.");
			return;
		}
		openSearchPopup("/common/addImagePop.do", '?st_imgfile_dir='+st_imgfile_dir+'&st_imgfile_name='+st_imgfile_name+'&mod_yn='+mod_yn+'&st_type='+st_type, "590,670,no");
	}else if(column == "S_IMGFILE_NAME_IMG"){//협력사 품목 이미지
		var st_imgfile_dir = mySheet.GetCellValue(Row, "S_IMGFILE_DIR");
		var st_imgfile_name = mySheet.GetCellValue(Row, "S_IMGFILE_NAME");
		var mod_yn = "N"; //수정여부
		var st_type = "S"; //협력사일경우
		if(st_imgfile_name == ""){
			alert("협력사에서 첨부한 이미지가 없습니다.");
			return;
		}
		openSearchPopup("/common/addImagePop.do", '?st_imgfile_dir='+st_imgfile_dir+'&st_imgfile_name='+st_imgfile_name+'&mod_yn='+mod_yn+'&st_type='+st_type, "590,670,no");
	}else if(column == "CMS_CATEG_NAME"){//카테고리속성.
		var st_cms_categ_id = mySheet.GetCellValue(Row, "CMS_CATEG_ID");
		openSearchPopup("/mdcm/showMasterMdCmCmscategAttb.do", '?cms_categ_id='+st_cms_categ_id, "400,300,no");
	} else if (column == "CMS_CATLG_ID" ){ 
		popupSel = "stndCatlg";

		// 조회 팝업		
		openSearchPopup("/mprq/showMasterMpRqStndCatalgListPop.do","?st_type=CATLG_REG&st_row_no="+Row,"900,800,no");
/*		// 추천 팝업
		var desc = mySheet.GetCellValue(Row,"DESCRIPTION_LOC"); // 품목명
		var spec = mySheet.GetCellValue(Row,"SPECIFICATION"); // 규격
		var maker = mySheet.GetCellValue(Row,"MAKER_NAME"); // 제조사명
		var row_num = Row;
			
		var new_popup = window.open('','categ','scrollbars=no,width=1000,height=600,resizable=no');
	    document.catlgFlow.action = "/mprq/showMasterMpRqCmsCatlgRcmdPop.do";
	    document.catlgFlow.target = "categ";
	    document.catlgFlow.method = "post";
	    
	    document.catlgFlow.catlg_desc_flow.value = escape(desc);
	    document.catlgFlow.catlg_spec_flow.value = escape(spec);
	    document.catlgFlow.catlg_maker_flow.value = escape(maker);
	    document.catlgFlow.catlg_row_num.value = escape(row_num);
	    
	    document.catlgFlow.submit();
	    new_popup.focus();
*/
	    
	} else if (column == "REVISION" ){
		var st_buyer = mySheet.GetCellValue(Row, "BUYER");
		var st_req_no = mySheet.GetCellValue(Row, "REQ_NO");
		popupSel = "masterMdCmCmsComplementHistoryPop";
		openSearchPopup("/mdcm/showMasterMdCmCmsComplementHistoryPop.do", '?st_buyer='+st_buyer+'&st_req_no='+st_req_no, "900,410,no");
	} else if (column == "IMAGE_KEY_IMG" ){
		popupSel = "fileUpload";
		var type="RFQ";
		var viewType="R";
		var image_key=mySheet.GetCellValue(Row, "IMAGE_KEY");
		if(image_key == ""){
			alert("협력사에서 첨부한 파일이 없습니다.");
			return;
		}
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}
	return;
}


//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2,value3,value4){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 고객사 
		
		//그룹을 선택할 수 없도록 처리.
		if(value4 == "1"){
			alert("그룹은 선택할 수 없습니다.");
			return;
		}
	
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2); 
		$("#st_com_org_code").val(value3); 

		 
	} else if (popupSel == "agent_single") {	// 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
		
		chItemStatusList(value1);
	}else if(popupSel == "ATOS_REMARK_IMG") {	//운영사 비고
			mySheet.SetCellValue(grbRow, 'ATOS_REMARK', value1);
			mySheet.SetCellValue(grbRow, 'ATOS_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
	} else if (popupSel == "stndCatlg"){ // 표준카탈로그코드
		if(value1 == "manual"){ // 직접선택 시 표준카탈로그조회 팝업
			this.focus();

			openSearchPopup("/mprq/showMasterMpRqStndCatalgListPop.do","?st_type=CATLG_REG&st_row_no="+value2,"900,800,no");
		}else if(value1 == "rcmd"){
			popupSel = "stndCatlg";
			
			var desc = mySheet.GetCellValue(value2,"DESCRIPTION_LOC"); // 품목명
 			var spec = mySheet.GetCellValue(value2,"SPECIFICATION"); // 규격
 			var maker = mySheet.GetCellValue(value2,"MAKER_NAME"); // 제조사명
 			var row_num = value2;
 			
			var new_popup = window.open('','categ','scrollbars=no,width=1000,height=600,resizable=no');
		    document.catlgFlow.action = "/mprq/showMasterMpRqCmsCatlgRcmdPop.do";
		    document.catlgFlow.target = "categ";
		    document.catlgFlow.method = "post";
		    
		    document.catlgFlow.catlg_desc_flow.value = escape(desc);
		    document.catlgFlow.catlg_spec_flow.value = escape(spec);
		    document.catlgFlow.catlg_maker_flow.value = escape(maker);
		    document.catlgFlow.catlg_row_num.value = escape(row_num);
		    
		    document.catlgFlow.submit();
		    new_popup.focus();
		}else{
			mySheet.SetCellValue(value2, 'CMS_CATLG_ID', value1);
			mySheet.SetCellValue(value2, 'CATALOG_CHOICE_TYPE', value3);
			
			if(value3 == "DQCAT02"){
				mySheet.SetCellValue(value2, "CATALOG_CHOICE_TYPE_NM", "추천팝업");
			}else if(value3 == "OFFCATE"){
				mySheet.SetCellValue(value2, "CATALOG_CHOICE_TYPE_NM", "수동선택");
			}
		}
	} else 	if (popupSel == "maker") {	// 제조사
		$("#st_maker_code").val(value1);
		$("#st_maker_name").val(value2);
	} else if(popupSel=="sg_info"){
		$("#st_c_sg_id").val(value1);
		$("#st_c_sg_nm").val(value2);
	}
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>카탈로그 매핑관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
		    <span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
   		</div>
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="USR_ID" name="USR_ID"  value="${sessionInfo.userId}">
			<input type="hidden" name="st_doc_type"  id="st_doc_type" value ="">
			
            	<table  class="cont_t_list01" >
					<caption>카탈로그 매핑관리</caption>
					<colgroup>
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
                        <col width="21%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>등록일자</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								-
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
							</td>
							<th>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:55%" value="" readonly>
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
								<input type="hidden" name="st_com_org_code" id="st_com_org_code" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							
						</tr>
						<tr> 
							<th>협력사</th>
							<td>
		                        <input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:70%;" value ="" READONLY>
		                        <input type="hidden" name="st_agent_code" id="st_agent_code" style="width:100px;" value ="">
		                        <a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
		                        <a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>품목명</th>
							<td>
								<input type="text"   class="input_type_text" name="st_description" id="st_description" style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
							<th>진행상태</th>
							<td>
								  <select name="st_req_status" id="st_req_status" style="width:80%">           
						         	 <%= CommonUtil.getCode3ComboList("", "ALL", "M152","", "ICOMCOD1", "", "") %>
						         </select>
							</td>
						</tr>
						<tr> 
							<th>품목코드</th>
							<td>
		                        <input type="text"   class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
							<th>규격</th>
							<td>
								<input type="text"   class="input_type_text" name="st_sepc" id="st_sepc" style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
							<th>담당자</th>
							<td>
								<select id="st_add_user_id" name="st_add_user_id" style="width:80%;height:20px"></select>
							</td>
						</tr>
						<tr> 
							<th>제조사</th>
							<td>
		                        <input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:70%;" value ="" READONLY>
		                        <input type="hidden" name="st_maker_code" id="st_maker_code" style="width:100px;" value ="">
		                        <a href="javascript:doPop('maker');"><img src="/resources/images/btn_search03.gif"></a>
		                        <a href="javascript:kepEraser('st_maker_code','st_maker_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>계약여부</th>
							<td>
							<select name="st_contract_yn" style="width: 100px;" >
								<option value="" selected>전체</option>
								<option value="Y">Y</option>
								<option value="N">N</option>
							</select>
							</td>
							<th>SG</th>
							<td>
								<input type="text" id="st_c_sg_nm" name="st_c_sg_nm" class="input_type_text" style="width:71%;" value=""  readonly onclick="javascript:doPop('sg_info');">
								<input type="hidden" name="st_c_sg_id" id="st_c_sg_id" style="width:80%" value="">
								<a href="javascript:doPop('sg_info');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_c_sg_id','st_c_sg_nm');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
						<tr> 
							<th>품목구분</th>
							<td>
		                        <select id="st_cond_item_type" name="st_cond_item_type" style="width: 100px;">
									<option value="" selected>전체</option>
									<option value="S">신규</option>
									<option value="K">기존</option>
								</select>
							</td>
							<th>카탈로그 상태</th>
							<td>
								<select id="st_catlg_status" name="st_catlg_status" style="width: 100px;">
									<option value="ALL">전체</option>
									<option value="N" selected>승인</option>
									<option value="Y">미승인/단종</option>
									<option value="D">삭제</option>
					            </select>
				            </td>
							<th></th>
							<td></td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
					<option value="100">100건</option>
					<option value="500">500건</option>
				</select>
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
    		<%if(getRoleYn== true){ %>
  	          	<span class="fl">
  					<span class="btn_02 mr04"><a href="/resources/excel/work/CATALOG/masterMdCatalogMappingList.xls">등록양식</a></span>
  					<span class="btn_04 mr04"><a href="javascript:doAction('loadExcel');">일괄 업로드</a></span>
  					<span class="btn_04 mr04"><a href="javascript:doAction('req');">품목매핑 요청</a></span>
  					<span class="btn_04 mr04"><a href="javascript:doAction('reject');">매핑반려</a></span>
  					<span class="btn_04 mr04"><a href="javascript:doAction('mappingDel');">삭제</a></span>
  					<span class="btn_04 mr04"><a href="javascript:doAction('mappingCompl');">매핑완료</a></span>
  				</span>
  			<%} %>
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('mapping');">품목매핑</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('reqItem');">보완요청</a></span>
  					<span class="btn_04 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

		<form name="catlgForm" id="catlgForm" method="post" action ="">
			<input type="hidden" name="catlg_target_rate" id="catlg_target_rate" value="60">
			<input type="hidden" name="catlg_target_count" id="catlg_target_count" value="1">
			<input type="hidden" name="catlg_row_no" id="catlg_row_no" value="">
		    <input type="hidden" name="catlg_desc" id="catlg_desc" value="">
		    <input type="hidden" name="catlg_spec" id="catlg_spec" value="">
		    <input type="hidden" name="catlg_maker" id="catlg_maker" value="">
		    <input type="hidden" name="catlg_model" id="catlg_model" value="">
		    <input type="hidden" name="catlg_desc_flag" id="catlg_desc_flag" value="true">
		    <input type="hidden" name="catlg_spec_flag" id="catlg_spec_flag" value="true">
		    <input type="hidden" name="catlg_maker_flag" id="catlg_maker_flag" value="true">
		    <input type="hidden" name="catlg_model_flag" id="catlg_model_flag" value="false">
		</form>
		<form name="catlgFlow" id="catlgFlow" method="post" action ="">
		    <input type="hidden" name="catlg_desc_flow" id="catlg_desc_flow" value="">
		    <input type="hidden" name="catlg_spec_flow" id="catlg_spec_flow" value="">
		    <input type="hidden" name="catlg_maker_flow" id="catlg_maker_flow" value="">
		    <input type="hidden" name="catlg_model_flow" id="catlg_model_flow" value="">
		    <input type="hidden" name="catlg_row_num" id="catlg_row_num" value="">
		</form>

</body>
</html>
