<%--
**********************************************
* 메뉴 : I/F 관리>I/F진행현황>품목정보I/F현황
* 화면 : 품목정보I/F현황
* 기능 :
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
	String searchYn		= CommonUtil.nvl((String)request.getParameter("search_yn"));
	String buyerCode	= CommonUtil.nvl((String)request.getParameter("st_buyer_code"));
	String buyerName	= CommonUtil.nvl((String)request.getParameter("st_buyer_name"));
	String st_user_check = CommonUtil.nvl((String)request.getParameter("st_user_check"));
	String st_user_dept = CommonUtil.nvl((String)request.getParameter("st_user_dept"));
	String processYN = CommonUtil.nvl((String)request.getParameter("processYN"));
%>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var imageG="/resources/images/icon_g.gif";
var imageY="/resources/images/icon_y.gif";
var imageR="/resources/images/icon_r.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var cancelRemarkOn="/resources/images/but_icon01.gif";
var cancelRemarkOff="/resources/images/but_icon02.gif";
var searchYn = "<%=searchYn%>";
var processYN ="<%=processYN%>";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	//var unit = KepSheetComboQueryIdData("getUnitMeasureInfo", "");
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 2};
	initsheet.HeaderMode = {			ColMove : 1,			ColResize : 1		};
	initsheet.Cols = [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태|상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,		Hidden:false,	Type:"DummyCheck",	Header:"|",					SaveName:"SELECTED"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Image",		Header:"I/F결과|기본정보",		SaveName:"MASTER_IF_FLAG_IMG"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Image",		Header:"I/F결과|상세정보",		SaveName:"DETAIL_IF_FLAG_IMG"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Image",		Header:"I/F결과|가격정보",		SaveName:"PRICE_IF_FLAG_IMG"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Image",		Header:"I/F결과|매핑정보",		SaveName:"RTN_IF_FLAG_IMG"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"담당자|담당자",				SaveName:"PC_CHRG_NM"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"요청번호|요청번호",				SaveName:"REQ_ID"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"견적번호|견적번호",				SaveName:"QUOTATION_NO"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"견적항번|견적항번",				SaveName:"QUOTATION_SEQ"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"고객사품목코드|고객사품목코드",		SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"상태|상태",				SaveName:"STATUS"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:95,		Hidden:true,	Type:"Text",		Header:"카탈로그|등록건수",		SaveName:"CNT_MCODE"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:95,		Hidden:true,	Type:"Text",		Header:"카탈로그|중복여부",				SaveName:"CNT_MCODE_YN"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"표준품목코드|표준품목코드",		SaveName:"CMS_CATLG_ID", BackColor:"${notnullColor}"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"카테고리|카테고리",				SaveName:"CATEGORY_TEXT"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"품명|품명",				SaveName:"ITEM_NM"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"규격|규격",				SaveName:"STD"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"모델번호|모델번호",				SaveName:"MODEL_NM"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"제조사|제조사",				SaveName:"MAKER"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"배송지코드|배송지코드",		SaveName:"DLV_AREA_CD"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Image",		Header:"견적취소|견적취소",				SaveName:"CANCEL_REMARK_IMG", Sort:0, BackColor:"${notnullColor}"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"견적취소사유|견적취소사유",			SaveName:"CANCEL_REMARK"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"리드타임|리드타임",				SaveName:"PROD_PMT_LT"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"최소발주수량|최소발주수량",			SaveName:"MIN_ORD_QUT"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"포장단위|포장단위",				SaveName:"PK_UNIT_QUT"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"국내단가(원)|국내단가(원)",			SaveName:"DMS_PC"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"해외법인|해외법인단가",			SaveName:"EXP_PC"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"해외법인|단위",		SaveName:"EXP_PC_UNIT"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"매입가(원)|매입가(원)",			SaveName:"PCS_PC"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"수수료(원)|수수료(원)",			SaveName:"FEE"}
		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"해외부대비용(원)|해외부대비용(원)",		SaveName:"OVS_COST"}
		
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Date",		Header:"기본정보|IF생성일",	SaveName:"MASTER_CREATE_DATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,		Hidden:true,	Type:"Text",		Header:"기본정보|IF처리구분",	SaveName:"MASTER_IF_FLAG"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Date",		Header:"기본정보|IF처리일",	SaveName:"MASTER_IF_DATE"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"기본정보|IF메세지",	SaveName:"MASTER_IF_MSG"}
		
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Date",		Header:"상세정보|IF생성일",	SaveName:"DETAIL_CREATE_DATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,		Hidden:true,	Type:"Text",		Header:"상세정보|IF처리구분",	SaveName:"DETAIL_IF_FLAG"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Date",		Header:"상세정보|IF처리일",	SaveName:"DETAIL_IF_DATE"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"상세정보|IF메세지",	SaveName:"DETAIL_IF_MSG"}
		
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Date",		Header:"가격정보|IF생성일",	SaveName:"PRICE_CREATE_DATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,		Hidden:true,	Type:"Text",		Header:"가격정보|IF처리구분",	SaveName:"PRICE_IF_FLAG"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Date",		Header:"가격정보|IF처리일",	SaveName:"PRICE_IF_DATE"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"가격정보|IF메세지",	SaveName:"PRICE_IF_MSG"}
		
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Date",		Header:"매핑정보|IF생성일",	SaveName:"RTN_CREATE_DATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,		Hidden:true,	Type:"Text",		Header:"매핑정보|IF처리구분",	SaveName:"RTN_IF_FLAG"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Date",		Header:"매핑정보|IF처리일",	SaveName:"RTN_IF_DATE"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"매핑정보|IF메세지",	SaveName:"RTN_IF_MSG"}
		
		// 히든필드 시작...
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:95,		Hidden:true,	Type:"Text",		Header:"고객사코드",				SaveName:"BUYER"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:95,		Hidden:true,	Type:"Text",		Header:"차수",				SaveName:"REVISION"}
		,{ Align:"Center",	Width:90,	Edit:false, EditLen:110,	Hidden:true,	Type:"Text",		Header:"이미지경로",			SaveName:"IMGFILE_DIR"}
		,{ Align:"Center",	Width:90,	Edit:false, EditLen:110,	Hidden:true,	Type:"Text",		Header:"이미지파일",			SaveName:"IMGFILE_NAME"}	
		,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"COMP_ITEM_ID",		SaveName:"COMP_ITEM_ID"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"CATEGORY_NO",		SaveName:"CATEGORY_NO"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,		Hidden:true,	Type:"Text",		Header:"MAIN_IMAGE_URL",	SaveName:"MAIN_IMAGE_URL"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,		Hidden:true,	Type:"Text",		Header:"IMAGE_URL",			SaveName:"IMAGE_URL"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float",		Header:"단가",				SaveName:"UNIT_PRICE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Image",		Header:"이미지첨부(M)",		SaveName:"IMGFILE_NAME_IMG"}
	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);

	// 상태이미지설정
	mySheet.SetImageList(0, imageG);
	mySheet.SetImageList(1, imageY);
	mySheet.SetImageList(2, imageR);
	mySheet.SetImageList(3, cancelRemarkOn);
	mySheet.SetImageList(4, cancelRemarkOff);
	mySheet.SetImageList(5, diskOff);
	mySheet.SetImageList(6, diskOn);

	// 하이퍼링크 설정
	setLinkCol(mySheet, "CMS_CATLG_ID");
	setLinkCol(mySheet, "CANCEL_REMARK_IMG"); // 취소
	
	mySheet.SetCellFontUnderline(0, "CANCEL_REMARK_IMG", true);	
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");

	// 초기화 설정
	resetValue();
	
	$("#st_buyer_code").val("<%=buyerCode%>");
	$("#st_buyer_name").val("<%=buyerName%>");
	var st_user_check = "<%=st_user_check%>";

	// 콤보데이터 셋팅
	if(st_user_check== "Y"){
		$('#st_user_check').prop('checked',true);
	}
	if(processYN == "Y"){
		kepAjaxCommonQueryIdCombo('st_user_dept','getKepDeptList','','<%=st_user_dept%>');
		doAction("search");
	}
}

// 초기화 설정
function resetValue() {
	// 조회일자 설정
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));

}

var st;
var mt;

// 그리드 표시후 처리
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {

	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search": // 조회
			
			if ( !searchValidate() )
				return;
			current_page = -1;

			kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpIfSemItemInfoList.do", pagingMode);
			break;

		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;

			/*
		case "excelDown": // 엑셀다운로드
		    $("#pageflag").val('0');
			var param = {FileName:"삼성전기IF오류_품목.xlsx",Merge:1,SheetDesign:1,DownCols:"QUOTATION_NO|QUOTATION_SEQ|BUYER_ITEM_NO|CMS_CATLG_ID|REVISION|CATEGORY_TEXT|ITEM_NM|STD|MODEL_NM|MAKER|PROD_PMT_LT|MIN_ORD_QUT|PK_UNIT_QUT|DMS_PC|EXP_PC|EXP_PC_UNIT|PCS_PC|FEE|OVS_COST"};
			kepDownExcel(document.searchCondition ,mySheet , "/mpif/excelMasterMpIfSeMItemInfoList.do", param);
			$("#pageflag").val('1');
			break;*/
			
		case "cancel": // 견적 취소.
			var arrRow     = selectedGrid.split("|");
			for (var i=0; i<arrRow.length; i++){
				var CANCEL_REMARK    = mySheet.GetCellValue(arrRow[i],"CANCEL_REMARK");
				if(CANCEL_REMARK == ""){
					alert("견적 취소 사유를 입력하여 주십시요");
					return;
				}
			}
			if (!confirm('선택한 항목을 견적취소 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mpif/cancelQuotationMasterMpIfSemItemInfo.do" , "SELECTED" );
			break;

		case "update": // 품목정보 수정.
			if (!confirm('선택한 항목을 수정 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mpif/updateItemMasterMpIfSemItemInfo.do" , "SELECTED" );
			break;

		case "reQuotation": // 재견적
			if (!confirm('선택한 항목을 재견적 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mpif/requotationMasterMpIfSemItemInfo.do" , "SELECTED" );
			break;
	}
}
function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

}
// 조회조건 체크
function searchValidate() {
	var start_date = $("#st_from_date").val().replace(/[/]/gi,"");
	var end_date = $("#st_to_date").val().replace(/[/]/gi,"");

	if ( start_date > end_date ) {
		alert("I/F 종료일은 시작일보다 작을 수 없습니다");
		return false;
	}

	return true;
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if (msg != "") {
		alert(msg);
	}

	if ( current_page == -1 ) {
		makePageIndex2(mySheet, 1, document.searchCondition.onepagerow.value);
	}
	else {
		makePageIndex2(mySheet, current_page, document.searchCondition.onepagerow.value);
	}

}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if ( msg != "" ) {
		alert(msg);
	}

	if ( code >= 0 ) {
		doAction("search");
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param) {
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpIfSemItemInfoList.do?page="+current_page , pagingMode);
}

function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	if (checkRows.length == 0){
		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	var arrRow = checkRows.split("|");
	
	if (mySheet.ColSaveName(Col) == "CANCEL_REMARK_IMG"){ // 견적취소
		var value1 = mySheet.GetCellValue(arrRow[0], "CANCEL_REMARK");
		if(kepIsValueNull(value1)){
			alert("복사할 견적 취소사유를 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "CANCEL_REMARK", value1);
			mySheet.SetCellValue(arrRow[idx], "CANCEL_REMARK_IMG", (value1!="")? cancelRemarkOn : cancelRemarkOff);
		}
	}
}
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;

	//var cms_categ_id = mySheet.GetCellValue(Row,"CMS_CATEG_ID"); // 카테고리ID
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == "CMS_CATLG_ID" ){ 
		popupSel = "stndCatlg";
		
		var st_buyer = mySheet.GetCellValue(Row, "BUYER");
		var st_quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
		var st_quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
		var st_revision = mySheet.GetCellValue(Row, "REVISION");

		openSearchPopup("/mprq/showMasterMpRqStndCatalgListPop.do","?st_buyer="+st_buyer+"&st_quotation_no="+st_quotation_no+"&st_quotation_seq="+st_quotation_seq+"&st_revision="+st_revision+"&st_type=RCMD&st_row_no="+Row,"900,800,no");
	} else if(column == "CANCEL_REMARK_IMG"){	
		popupSel = "cancelRemark";
		var viewType="R";
		var cancel_remark = mySheet.GetCellValue(Row, "CANCEL_REMARK");
		openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType,"500,230,no");
	}

	return;
}

function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
		,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
		,value21,value22,value23,value24,value25,value26,value27,value28,value29,value30){

	if (popupSel == "stndCatlg"){
		mySheet.SetCellValue(grbRow, 'CMS_CATLG_ID', value1);
	} else if (popupSel == "commonCoCoBuyerCategoryChoicePop") {	// 카테고리팝업
		mySheet.SetCellValue(grbRow, 'CATEGORY_NO', value1);
		mySheet.SetCellValue(grbRow, 'CATEGORY_TEXT', value2);
	}  else if(popupSel == "cancelRemark") {	//견적 취소
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK_IMG', (value1!="")? cancelRemarkOn : cancelRemarkOff);
	}
	
	grbRow="";	//초기화
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>삼성전기 품목정보 I/F현황</h3>
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

           	<table  class="cont_t_list01">
				<caption>삼성전기 품목정보 I/F현황</caption>
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
						<th>I/F 일자</th>
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
						<th>담당자</th>
						<td>
							<input type="text" id="st_suser_name" name="st_suser_name" style="width:80%;" value="${sessionInfo.userNameLoc}">
						</td>
					</tr>
					<tr>
						<th>고객사품목코드</th>
						<td>
							<input type="text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:80%;" value="">
						</td>
						<th>표준품목코드</th>
						<td>
							<input type="text" id="st_cms_catlg_id" name="st_cms_catlg_id" style="width:80%;" value="">
						</td>
						<th>요청번호</th>
						<td>
							<input type="text" id="st_req_id" name="st_req_id" style="width:80%;" value="">
						</td>
					</tr>
					<tr>
						<th>처리결과</th>
						<td>
							<select id="st_result" name="st_result">
								<option value="">전체</option>
								<option value="S">완료</option>
								<option value="N">진행중</option>
								<option value="F">오류</option>
							</select>
						</td>
						<td>&nbsp;</td><td>&nbsp;</td>
						<td>&nbsp;</td><td>&nbsp;</td>
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
			</select>
		</span>
		<span class="fl">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
		<span class="fl">
			<img src="/resources/images/icon_g.gif" style="padding-top:3px;"/>&nbsp;정상&nbsp;&nbsp;
			<img src="/resources/images/icon_y.gif" style="padding-top:3px;"/>&nbsp;진행중&nbsp;&nbsp;
			<img src="/resources/images/icon_r.gif" style="padding-top:3px;"/>&nbsp;오류&nbsp;&nbsp;
		</span>
		<br>
	</form>

    <!--grid-->
   	<div class="ib_product" style="border-top:2px solid #3c639c">
		<script type="text/javascript">
			createIBSheet("mySheet", "100%", "333px");
		</script>
  	</div>
  	<p class="paging" id="pageindex"></p>

	<!--버튼영역-->
	<div class="btnArea">
  		<span class="fl">
  			<!--  <span class="btn_05 mr04" ><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span> -->
  		</span>

  		<span class="fr">
  		<!-- 
  			<span class="btn_02" id="btnUpdateItem" name="btnUpdateItem" ><a href="javascript:doAction('update');">수정/저장</a></span>
  			<span class="btn_02" id="btnRequotItem" name="btnRequotItem" ><a href="javascript:doAction('reQuotation');">재견적</a></span>
  			<span class="btn_02" id="btnCancelItem" name="btnCancelItem" ><a href="javascript:doAction('cancel');">견적취소</a></span>
  		 -->
  		</span>
	</div>

<!--내용 종료-->

</body>
</html>
