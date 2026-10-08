<%--
**********************************************
* 메뉴 : 도안관리>종자
* 화면 : 종자
* 기능 : 관리되는 종자 목록을 조회한다.
* 프로그램 ID : PG_07_M_004_00
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-05-27
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
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var iconRed = "/resources/images/icon_r.gif";
var iconYellow = "/resources/images/icon_y.gif";
var iconGreen = "/resources/images/icon_g.gif";
var iconWhite = "/resources/images/icon_w.gif";
var iconBlack = "/resources/images/icon_b.gif";
var iconBl = "/resources/images/icon_bl.gif";
var iconX = "/resources/images/icon_x.gif";


// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태|상태",	SaveName:"sStatus"}
					 ,{ Align:"Center",	Width:60,	Edit : true,	EditLen:60,	Hidden : true,	Type:"Radio",	Header:"선택|선택",	SaveName:"SELECTED"}
			        ,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"구분|구분",	SaveName:"USE_TEXT"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"구분|구분",	SaveName:"GUBUN"} 
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"진행상태|진행상태",	SaveName:"PROGRESS_STATUS"} 
			        ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드|품목코드",	SaveName:"BUYER_ITEM_NO"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약번호|계약번호",	SaveName:"CONTRACT_NO"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약순번|계약순번",	SaveName:"CONTRACT_SEQ"} 
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"시작일|시작일",	SaveName:"RD_DATE"} 
			        ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"디자인완료일|디자인완료일",	SaveName:"DD_DATE"} 
			        ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"1차컨펌완료일|1차컨펌완료일",	SaveName:"EE_DATE"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"최종확인일|최종확인일",	SaveName:"ES_DATE"} 
			        ,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명|품목명",	SaveName:"DESCRIPTION"}
			        ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격|규격",	SaveName:"SPECIFICATION"} 
			        ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사|제조사",	SaveName:"MAKER_NAME"} 

			        ,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"디자인|완료",	SaveName:"MM_STATUS"} 
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"1차확인|PM",	SaveName:"ES_MK1_STATUS"} 
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"1차확인|문안",	SaveName:"ES_PD1_STATUS"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"1차확인|사진",	SaveName:"ES_QA1_STATUS"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"1차확인|가공",	SaveName:"ES_PD_STATUS"} 
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"1차확인|영업",	SaveName:"ES_MK_STATUS"} 
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"최종확인|최종확인",	SaveName:"ES_FI_STATUS"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PLANT|PLANT",	SaveName:"PLANT"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"RECV_FLAG|RECV_FLAG",	SaveName:" RECV_FLAG"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"USE_FLAG|USE_FLAG",	SaveName:"USE_FLAG"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"GUBUN_FLAG|GUBUN_FLAG",	SaveName:"GUBUN_FLAG"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ES_STATUS|ES_STATUS",	SaveName:"ES_STATUS"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"DD_RECV_STATUS|DD_RECV_STATUS",	SaveName:"DD_RECV_STATUS"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"DD_ED_STATUS|DD_ED_STATUS",	SaveName:"DD_ED_STATUS"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"EE_RECV_STATUS|EE_RECV_STATUS",	SaveName:"EE_RECV_STATUS"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"EE_ED_STATUS|EE_ED_STATUS",	SaveName:"EE_ED_STATUS"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SAFETY_OPEN_FLAG|SAFETY_OPEN_FLAG",	SaveName:"SAFETY_OPEN_FLAG"} 
					
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"MM_STATUS_YN",	Header:"마케팅완료여부|마케팅완료여부"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"MM_WORK_DATE",	Header:"마케팅팀작업일시|마케팅팀작업일시"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"MM_REMARK",	Header:"마케팅비고|마케팅비고"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"DD_STATUS_YN",	Header:"문안완료여부|문안완료여부"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"DD_WORK_DATE",	Header:"문안팀작업일시|문안팀작업일시"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"DD_REMARK",	Header:"문안비고|문안비고"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"EE_STATUS_YN",	Header:"디자인완료여부|디자인완료여부"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"EE_WORK_DATE",	Header:"디자인작업일시|디자인작업일시"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"EE_REMARK",	Header:"디자인비고|디자인비고"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"ES_MK_STATUS_YN",	Header:"최종확정여부_MK|최종확정여부_MK"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"ES_MK_WORK_DATE",	Header:"최종확정작업일시_MK|최종확정작업일시_MK"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"ES_MK1_REMARK",	Header:"ES_MK1_REMARK|ES_MK1_REMARK"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"ES_PD1_STATUS_YN",	Header:"최종확정여부_PD1|최종확정여부_PD1"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"ES_PD_WORK_DATE",	Header:"최종확정작업일시_PD|최종확정작업일시_PD"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"ES_PD1_REMARK",	Header:"최종확정비고PD|최종확정비고PD"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"ES_QA1_STATUS_YN",	Header:"최종확정여부_QA1|최종확정여부_QA1"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"ES_QA_WORK_DATE",	Header:"최종확정작업일시QA|최종확정작업일시QA"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"ES_QA1_REMARK",	Header:"최종확정비고_QA|최종확정비고_QA"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"ES_FI_STATUS_YN",	Header:"최종확정여부_FI|최종확정여부_FI"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"ES_FI_WORK_DATE",	Header:"최종확정작업일시_FI|최종확정작업일시_FI"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"ES_FI_REMARK",	Header:"최종확정비고_FI|최종확정비고_FI"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"AGENT_SELECT",	Header:"지정공급사|지정공급사"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"BUYER_REQ",	Header:"요청공장|요청공장"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"CHANGE_DATE",	Header:"최종수정일|최종수정일"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"CHANGE_USER",	Header:"최종수정자|최종수정자"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BYCA_COMORG_CODE|BYCA_COMORG_CODE",	SaveName:"BYCA_COMORG_CODE"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사|고객사",	SaveName:"BUYER"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"OPKG_SEQ|OPKG_SEQ",	SaveName:"OPKG_SEQ"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"RETURN_CNT",	Header:"총반려수|총반려수"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	SaveName:"RETURN_TEAM_CNT",	Header:"팀별반려횟수|팀별반려횟수"}
					
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:5};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(0, remarkOff);
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(2, iconRed);
	mySheet.SetImageList(3, iconYellow);
	mySheet.SetImageList(4, iconGreen);
	mySheet.SetImageList(5, iconWhite);
	mySheet.SetImageList(6, iconBlack);
	mySheet.SetImageList(7, iconBl);
	mySheet.SetImageList(8, iconX);
	
	
	//콤보데이터 셋팅		
// 	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL','');

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");	//품목코드
	setLinkCol(mySheet, "MM_STATUS");
	setLinkCol(mySheet, "ES_MK1_STATUS");
	setLinkCol(mySheet, "ES_PD1_STATUS");
	setLinkCol(mySheet, "ES_QA1_STATUS");
	setLinkCol(mySheet, "ES_PD_STATUS");
	setLinkCol(mySheet, "ES_MK_STATUS");
	setLinkCol(mySheet, "ES_FI_STATUS");

	//구분컬럼 머지
	mySheet.SetMergeCell(0, 2, 1, 2);
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	if("${param.popflag}" == 'Y'){
		kepSearch(document.searchCondition,  mySheet , "/mpds/getMasterMpDsSeedList.do" , pagingMode );
	}
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpds/getMasterMpDsSeedList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
			mySheet.RemoveAll();
		break;

	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
		var param = {FileName:"종자리스트.xls",Merge:1,SheetDesign:1,DownCols:"USE_TEXT|GUBUN|PROGRESS_STATUS|RECV_FLAG|BUYER_ITEM_NO|RD_DATE|DD_DATE|EE_DATE|ES_DATE|DESCRIPTION|SPECIFICATION|MAKER_NAME|MM_STATUS|ES_MK1_STATUS|ES_PD1_STATUS|ES_QA1_STATUS|ES_PD_STATUS|ES_MK_STATUS|ES_FI_STATUS|MM_STATUS_YN|MM_WORK_DATE|MM_REMARK|DD_STATUS_YN|DD_WORK_DATE|DD_REMARK|EE_STATUS_YN|EE_WORK_DATE|EE_REMARK|ES_MK_STATUS_YN|ES_MK_WORK_DATE|ES_MK1_REMARK|ES_PD1_STATUS_YN|ES_PD_WORK_DATE|ES_PD1_REMARK|ES_QA1_STATUS_YN|ES_QA_WORK_DATE|ES_QA1_REMARK|ES_FI_STATUS_YN|ES_FI_WORK_DATE|ES_FI_REMARK|AGENT_SELECT|BUYER_REQ|CHANGE_DATE|CHANGE_USER|BYCA_COMORG_CODE|BUYER|OPKG_SEQ|RETURN_CNT|RETURN_TEAM_CNT"};
		kepDownExcel(document.searchCondition ,mySheet , "/mpds/excelMasterMpDsSeedList.do", param);
		$("#pageflag").val('1');
		break;
		
	case "setMapping": // 맵핑

		if(confirm("매핑 하시겠습니까?")) {
			kepSave(document.searchCondition ,  mySheet , "/mpds/saveMasterMpDsOrderMapping.do" , "SELECTED" );
		}
		break;
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

	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}
	
	var nextDate = kepToDateAdd("1","P","noslash");

	for(var i=1; i<=totRow;i++){
		var use_text = mySheet.GetCellValue(i, 'USE_TEXT');
		var mm_date = mySheet.GetCellValue(i, 'MM_DATE');
		var ee_date = mySheet.GetCellValue(i, 'EE_DATE');
		var es_date = mySheet.GetCellValue(i, 'ES_DATE');

		if(use_text == "긴급") { 
			mySheet.SetCellFontColor(i,"USE_TEXT","#FF0000");
		}
		if(mm_date == nextDate) { 
			mySheet.SetCellFontColor(i,"MM_DATE","#FF0000");
		}
		if(ee_date == nextDate) { 
			mySheet.SetCellFontColor(i,"EE_DATE","#FF0000");
		}
		if(es_date == nextDate) { 
			mySheet.SetCellFontColor(i,"ES_DATE","#FF0000");
		}
		
		if("${param.popflag}" == "Y"){
			mySheet.SetColHidden("SELECTED", false );
		}
	}
	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
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
	}}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsSeedList.do?page="+current_page , pagingMode );
}


// 팝업함수호출
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "masterMpDsSeedKindPop": //종자구분
			var item_code = document.forms[0].st_item_code.value;
			openSearchPopup('/mpds/showMasterMpDsSeedKindPop.do','?st_item_code='+item_code,'500,330,no');
			break;
		case "masterMpDsPckpaprDesignManageSeedRegPop": // 도안 등록
			openSearchPopup('/mpds/showMasterMpDsPckpaprDesignManageSeedRegPop.do','','617,530,no');
			break;			
	}
	
	
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	 if (column == 'BUYER_ITEM_NO') { // 품목코드
		var buyer = mySheet.GetCellValue(Row, "BYCA_COMORG_CODE");
		var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		openSearchPopup('/common/catalogDetailDongbuPop.do','?BUYER='+buyer+'&BUYER_ITEM_NO='+buyerItemNo,'800,255,no');

	}else if ("MM_STATUS|ES_MK1_STATUS|ES_PD1_STATUS|ES_QA1_STATUS|ES_PD_STATUS|ES_MK_STATUS|ES_FI_STATUS".indexOf(column) > -1){ 
		popupSel = "masterMpDsDongbuPckpaprDesignSeedManagePop";
        var plant = mySheet.GetCellValue(Row, "PLANT"); // [20]
        var byca_comorg_code = mySheet.GetCellValue(Row, "BYCA_COMORG_CODE"); // [21]
        var buyer = mySheet.GetCellValue(Row, "BUYER"); // [22]
        var opkg_seq = mySheet.GetCellValue(Row, "OPKG_SEQ"); // [23]
        var rd_date = mySheet.GetCellValue(Row, "RD_DATE"); // [17]
        var buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");// [02]
		
        openSearchPopup('/mpds/showMasterMpDsDongbuPckpaprDesignSeedManagePop.do','?st_plant='+plant+'&st_byca_comorg_code='+byca_comorg_code+'&st_buyer='+buyer+'&st_opkg_seq='+opkg_seq+'&st_rd_date='+rd_date+'&st_buyer_item_no='+buyer_item_no+'&st_open_type=dongbu','720,650,1,1');// 견적상세

	} else if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,'800,550,no');
		
		}else if (column == "ORIGIN_NAME" ){ 
		popupSel = "country";
		openSearchPopup('/common/countryCodePop.do');// 원산지

		}else  if (column == "MAKER_NAME" ){ 
		popupSel = "maker";
		openSearchPopup('/common/agentRegMakerCodePop.do');// 제조사


		

	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterMpDsSeedKindPop") {	// 종자구분
		document.forms[0].st_item_code.value = value1;
		document.forms[0].st_item_name.value = value2;
	}
	//팝업 조회후 재조회
	else if (popupSel == "masterMpDsDongbuPckpaprDesignSeedManagePop" || popupSel == "masterMpDsPckpaprDesignManageSeedRegPop") {	// 도안관리(종자)상세 또는 도안 등록
		doAction('search');	
	} 		
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<c:if test="${param.popflag eq 'Y'}">
	<div id="popWrapper" >
    	<div id="popHeader">
        	<h1 class="title">종자</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
	</c:if>

		<!--버튼영역-->
       	<div id="searchBtnA"  >
	       	<c:if test="${param.popflag ne 'Y'}">
				<h3>종자</h3>
			</c:if>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" name="st_off_buyer"		value ="${param.st_off_buyer}">
			<input type="hidden" name="st_off_add_date"		value ="${param.st_off_add_date}">
			<input type="hidden" name="st_off_seq"			value ="${param.st_off_seq}">
						
	            <table class="cont_t_list01" ><!-- 마이페이지 닫힐때 width="887"-->
					<caption>종자</caption>
					<colgroup>
	                    <col width="8%" />
	                    <col width="25%" />
	                    <col width="8%" />
	                    <col width="25%" />
	                    <col width="8%" />
	                    <col width="25%" />
					</colgroup>
						
					<tbody>
				        <tr>
				          <th  align="right" >
				            <select  name="st_date_type" name="st_date_type" class="TitSelect">
                              <option value= "1">시작일</option>
				              <option value= "2">디자인완료일</option>
							  <option value= "3">1차컴펌완료일</option>
				              <option value= "4">최종확인일</option>
				            </select>
				          </th>
					      <td colspan="3"> 
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value=""> - 
		                        <input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value=""> 
		                        <span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>	
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>								
							</td>
				          <th  >디자인</th>
				          <td  >
				            <select   name="st_mm_status">
				              <option value="ALL" selected>전체</option>
				              <option value="N">미완료</option>
              				   <option value="ED">완료</option>
				            </select>
				          </td>
				        </tr>
				        <tr>
				          <th >품목코드</th>
				          <td >
				            <input type="text" name="st_buyer_item_no" id="st_buyer_item_no"  style="width:87%" value="${param.st_buyer_item_no}" onKeyUp="kepToUpper('st_buyer_item_no')" onKeyDown="kepEnter()">
				          </td>
				          <th  >최종확인</th>
				          <td  >
				            <select  name="st_fi_status">
				              <option value="ALL" selected>전체</option>
				              <option value="N">미확인</option>
				              <option value="Y">확인</option>
				            </select>
				          </td>
				          <th>제품구분</th>
				          <td  >
				            <select   name="st_product_flag">
				              <option value="ALL" selected>전체</option>
				              <option value="H1">흥농</option>
				              <option value="H2">한농</option>
							  <option value="D1">대농</option>
				            </select>
				          </td>
				        </tr>
				        <tr>
				          <th >품목명/규격</th>
				          <td >
				            <input type="text" name="st_desc_spec" style="ime-mode:active;width:87%" value="" onKeyDown="kepEnter()">
				          </td>
				          <th >종자구분</th>
				          <td >
								<input type="text" name="st_item_name" id="st_item_name" style="width:67%" value="" readonly onclick="javascript:doPop('masterMpDsSeedKindPop');">
								<input type="hidden" name="st_item_code" id="st_item_code" style="width:80%" value="">
								<a href="javascript:doPop('masterMpDsSeedKindPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_item_code','st_item_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
				          </td>
				          <th  >진행상태</th>
				          <td >
				            <select   name="st_recv_flag">
				              <option value="ALL" selected>전체</option>
				              <option value="NW">등록</option>
				              <option value="IG">진행중</option>
				              <option value="ED">종료</option>
				              <option value="FY">종결</option>
				              <option value="GB">반려</option>
				            </select>
				          </td>
				        </tr>
					</tbody>
				</table>
            </div>

			<table style="width:100%;">
				<tr>
					<td align="left">
		           		<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
		               	<label for="b_no02" class="hidden">정렬개수선택</label>
							<select name="onepagerow" style="width: 70px;" >
							<option value="10" selected>10건</option>
							<option value="20">20건</option>
							<option value="30">30건</option>
							<option value="40">40건</option>
							<option value="50">50건</option>
							</select>
					      <select name="st_order_by" id="st_order_by">
					        <option value= "1" >시작일</option>
					        <option value= "2" >디자인완료일</option>
					        <option value= "3" >1차컴펌완료일</option>
					        <option value= "4" >최종확인일</option>
					      </select>
					      기준											
						<img src="/resources/images/icon_w.gif"  align="middle" >미처리 
						<img src="/resources/images/icon_r.gif"  align="middle">처리 
						<img src="/resources/images/icon_y.gif"  align="middle">종료 
						<img src="/resources/images/icon_g.gif"  align="middle">종결 
						<img src="/resources/images/icon_b.gif"  align="middle">반려 &nbsp;&nbsp;&nbsp;<span style="color:blue">※</span>날짜에 <span style="color:red">붉은표시</span>는 완료 1일 전입니다.
					</td>
		   		</tr>
			</table>
            
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "314px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
  					<label>※ PM:마케팅팀 종자PM /문안:마케팅팀 등록 문안 담당/사진: 마케팅팀 사진기획담당 /가공: 가공팀 / 영업 : 영업관리팀</label>
  				</span>

  				<span class="fr">
  				<c:if test="${param.popflag ne 'Y'}">
  					<span class="btn_02 mr04"><a href="javascript:doPop('masterMpDsPckpaprDesignManageSeedRegPop');">등록</a></span>
  				</c:if>
  				<c:if test="${param.popflag eq 'Y'}">
  					<span class="btn_02 mr04"><a href="javascript:doAction('setMapping');">맵핑</a></span>
  				</c:if>
  					<span class="btn_06" style="display:none"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  			 </div>
	<c:if test="${param.popflag eq 'Y'}">
		</div>
	</div>
	</c:if>  	
<!--내용 종료-->	                 

</body>
</html>
