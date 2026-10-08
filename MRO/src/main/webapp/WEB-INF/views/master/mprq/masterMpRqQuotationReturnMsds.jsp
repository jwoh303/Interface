<%--
**********************************************
* 메뉴 : 견적관리>MSDS반려조회
* 화면 : MSDS반려조회
* 기능 : MSDS 반려조회
* 프로그램 ID :
* 담당자 : 현명환
* 착수일 : 2015-08-27
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<!-- 다중선택콤보(공통) - 사용시 필수 선언 start -->
<script src="/resources/js/jquery.multiple.select.js"></script>
<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<!-- 다중선택콤보(공통) - 사용시 필수 선언 end -->

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

var diskOn = "/resources/images/disk_on.gif";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 7};
	initsheet.Cols = [ 
	 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
	,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED",ColMerge:0,Sort:1}
	,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME",ColMerge:0,Sort:1}
	,{ Align:"Left",	Width:110,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사",	SaveName:"BUYER",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적번호",	SaveName:"QUOTATION_NO",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"순번",	SaveName:"QUOTATION_SEQ",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"차수",	SaveName:"REVISION",ColMerge:0}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"MSDS",	SaveName:"MSDS_YN", BackColor:"${optColor}"}
	,{ Align:"Center",	Width:18,	Edit : true,	EditLen:100,	Hidden : false,	Type:"Image",	Header:"MSDS NO",	SaveName:"PRINT",ColMerge:1,Sort:0}
	,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"MSDS NO",	SaveName:"MSDS_NO", ColMerge:1,Sort:0}
	,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",    Header:"MSDS반려사유",	SaveName:"MSDS_NOTE",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO",ColMerge:0,Sort:1}
	,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION",ColMerge:0,Sort:1}
	,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NAME",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"견적의뢰일",	SaveName:"BTOA_DATE",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"회신요청일",	SaveName:"BTOA_END_DATE",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",	SaveName:"BTOA_USER_NAME",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청부서",	SaveName:"BTOA_USER_DEPT",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"공개",	SaveName:"AGENT_OPEN_FLAG",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고",	SaveName:"BTOA_REMARK_IMG",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사비고",	SaveName:"BTOA_REMARK",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사비고",	SaveName:"ATOB_REMARK",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"담당자",	SaveName:"KEP_USER_NAME",ColMerge:0,Sort:1}
	,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",	Format:"${qtyFormat}", Header:"수량",	SaveName:"ITEM_QTY",ColMerge:0,Sort:1}
	,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",	 Format:"${priceFormat}", 		Header:"매출단가",	SaveName:"ATOB_UNIT_PRICE", ColMerge:0}
	,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",	 Format:"${priceFormat}", 		Header:"매입단가",	SaveName:"STOA_LIST_PRICE", ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"MSDS_YN_FIX",	SaveName:"MSDS_YN_FIX",ColMerge:0,Sort:1}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"취소사유",	SaveName:"CANCEL_REMARK_IMG",ColMerge:0,Sort:0}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"취소사유",	SaveName:"CANCEL_REMARK",ColMerge:0,Sort:0}
	
	];
	
	IBS_InitSheet2(mySheet, initsheet,pagingMode,5);

	//비고이미지설정
	mySheet.SetImageList(1, diskOn);
	//비고이미지설정
	mySheet.SetImageList(2, remarkOn);
	mySheet.SetImageList(3, remarkOff);

	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL','');

	//하이퍼링크 설정
	setLinkCol(mySheet, "BTOA_USER_NAME");	//요청자
	setLinkCol(mySheet, "REVISION");	//차수
	setLinkCol(mySheet, "BTOA_REMARK_IMG"); // 비고
	setLinkCol(mySheet, "MSDS_NO"); // MSDS 등록 및 매핑
	setLinkCol(mySheet, "PRINT"); // MSDS 등록 및 매핑
	setLinkCol(mySheet, "CANCEL_REMARK_IMG"); // 취소
	
	mySheet.SetCellFontUnderline(0, "CANCEL_REMARK_IMG", true);	
	
	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val(kepToDateAdd("7","M"));
	$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
	
}
//매핑후 조회	
function opener_searchData(){
	doAction( "search");
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

		if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
			alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n3개월 이상의 데이타는 S/R 요청 바랍니다.");
			return;
		}
		current_page = -1;

		if (kepIsValueNull($('#st_buyer_code').val())){
			alert("고객사는 필수입니다.");
			return;
		}
		if($('#st_checkbox')[0].checked) {
			$("#st_date_type").val("BTOA");
			if(kepIsValueNull($('#st_quotation_no').val()) 
					&& kepIsValueNull($('#st_kep_user_id').val()) 
					&& kepIsValueNull($('#st_btoa_user_name').val()) 
					&& kepIsValueNull($('#st_desc_spec').val()) 
					&& kepIsValueNull($('#st_buyer_item_no').val())
					&& kepIsValueNull($('#st_maker_code').val())
					){
				alert('견적번호, 담당자, 요청자, 품목명/규격, 품목코드, 제조사 중 한 값은 필수 입니다.');
				return;
			}
		}
		kepSearch(document.searchCondition,  mySheet , "/mprq/getMasterMpRqQuotationReturnMsds.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$('#st_buyer_code').val("");
		$('#st_maker_code').val("");
		mySheet.RemoveAll();
		
		
		$("#st_from_date").val(kepToDateAdd("7","M"));
		$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
		break;
		
	case "save": // 견적제출
	
		if (!confirm('선택한 항목을 견적제출 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqQuotationReturnMsds.do" , "SELECTED" );
		break;
		
	case "cancel": // 견적취소
		
		for (var i=0; i<arrRow.length; i++){
			if (mySheet.GetCellValue(arrRow[i],"SOURCING_STATUS") == "견적취소"){
				alert("이미 취소된 견적 입니다.");
				return;
			}

			if (mySheet.GetCellValue(arrRow[i],"SOURCING_STATUS") == "합의완료"){
				alert("합의완료건은 취소가 불가능 합니다.");
				return;
			}
			var CANCEL_REMARK    = mySheet.GetCellValue(arrRow[i],"CANCEL_REMARK");
			if(CANCEL_REMARK == ""){
				alert("견적 취소 사유를 입력하여 주십시요");
				return;
			}
		}
		if (!confirm('선택한 항목을 견적취소 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mprq/delMasterMpRqReqQuotReceipt.do" , "SELECTED" );
		break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
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
	

	if (msg != "") {
		alert(msg);
	}

}

function mySheet_OnMouseMove(Button, Shift, X, Y) { 

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
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqQuotationProceStateList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyerMulti": // 고객사 M
			popupSel = "buyerMulti";
			openSearchPopup("/none/showCommonNoNeBuyerChoiceMultiPop.do","?search_opt=2&disable_yn=Y",'1000,500,no')
			break;
		case "maker": // 제조사
			popupSel = "maker";
			openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
			break;

	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	var buyer = mySheet.GetCellValue(Row, "BUYER");
	var quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
	var quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
	var revision = mySheet.GetCellValue(Row, "REVISION");
	var agent = mySheet.GetCellValue(Row,"AGENT");
	
	if (column == 'SOURCING_STATUS') { // 요청자
		var docu_no = mySheet.GetCellValue(Row, "DOCU_NO");
		if(!kepIsValueNull(docu_no)){
			openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do','?COMPANY=KRKORE0001&DOCU_NO='+docu_no+'&PASS_TP=1&FLAG=COMPLETE' , '1200,700,no');
		}
	} else if (column == 'BTOA_USER_NAME') { // 요청자
		var ID = mySheet.GetCellValue(Row,"BTOA_USER_ID");
		if (ID!=""){
			openSearchPopup("/common/userDisplayPop.do", '?user_id='+ID, "800,500,no");
		}
	} else if(column == "REVISION"){ // 차수
		popupSel = "masterMpRqQuotationUnitpriceHistoryPop";
		openSearchPopup("/mprq/showMasterMpRqQuotationUnitpriceHistoryPop.do", '?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_quotation_seq='+quotation_seq+'&st_revision='+revision, "900,600,no");
	} else if (column == 'AGENT_NAME') { // 협력사
		if (!kepIsValueNull(agent)){
			openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");
		}
	} else if(column == "CANCEL_REMARK_IMG"){	
		popupSel = "cancelRemark";
		var viewType="R";
		var cancel_remark = mySheet.GetCellValue(Row, "CANCEL_REMARK");
		openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType,"500,230,no");
	}else if (column == "BTOA_REMARK_IMG" ){ 
		popupSel = "remark";
		var btoa_remark = mySheet.GetCellValue(Row, "BTOA_REMARK");
		var atob_remark = mySheet.GetCellValue(Row, "ATOB_REMARK");
		openSearchPopup("/common/remarkPop.do", '?st_btoa_remark='+btoa_remark+'&st_atob_remark='+atob_remark+'&viewType=R'+'&title=A', "500,310,no");

	}else if (column == "SCM_REMARK_IMG" ){ // SCM비고 
		popupSel = "remarkReturn2Pop"; 
		var scm_remark = mySheet.GetCellValue(Row, "SCM_REMARK");
		openSearchPopup("/common/remarkReturn2Pop.do", '?st_return_remark='+scm_remark+"&st_buyer=" + buyer + "&st_quotation_no="+ quotation_no + "&st_quotation_seq=" + quotation_seq + "&st_revision=" + revision + "&st_gubun=RQ", "500,230,no");

	} else if(column == "PRINT"){	
		var p_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
		var p_description = mySheet.GetCellValue(Row, "DESCRIPTION");
		var p_specification = mySheet.GetCellValue(Row, "SPECIFICATION");
		var p_maker_name = mySheet.GetCellValue(Row, "MAKER_NAME");
		var p_unit = mySheet.GetCellValue(Row, "UNIT_MEASURE");
		
		openSearchPopup("/coco/showCommonCoCoMsdsPop.do", '?p_buyer='+buyer+'&p_quotation_no='+quotation_no+'&p_quotation_seq='+quotation_seq+'&p_revision='+revision+'&p_return='+"R"+'&p_buyer_item_no='+p_buyer_item_no+'&p_description='+p_description+'&p_specification='+p_specification+'&p_maker_name='+p_maker_name+'&p_unit='+p_unit, "950,600,no");
	
	}else if (column == "MSDS_NO" ){ // MSDS 등록 및 매핑
		popupSel = "msdsregmapPop"; 
		var sourcing_status = mySheet.GetCellValue(Row, "SOURCING_STATUS");
		if (sourcing_status == "합의완료" || sourcing_status == "장바구니" || sourcing_status == "발주" ){
				alert("합의완료상태나 카탈로그 등록완료된 견적은 \n\nMSDS 등록 및 매핑 불가합니다. \n\n카탈로그 조회 및 수정화면에서 진행하시기 바랍니다. ");
				return;
		}	
		
		var msds_no = mySheet.GetCellValue(Row, "MSDS_NO");
		openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+msds_no+"&st_btn_yn=Y",'750,580,no');
	
	}
	return;
}


//헤더 더블클릭시 복사
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
}	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyerMulti") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	
	} else if(popupSel == "cancelRemark") {	//견적 취소
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
	} else if (popupSel == "maker"){ // 제조사
		$("#st_maker_code").val(value1);
		$("#st_maker_name").val(value2);
		
	}
	grbRow="";	//초기화
}

function setTermPassFlag(){
	if($('#st_checkbox')[0].checked) {
		$("#st_term_pass_flag").val("Y");
		$("#st_date_type").val("BTOA");
		
	} else {
		$("#st_term_pass_flag").val("N");
		
	}
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>MSDS반려조회</h3>
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
			<input type="hidden" id="USR_ID" name="USR_ID"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>견적진행조회</caption>
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
							<th>
								<label for="b_code" class="hidden">기간선택</label>
						  			<select name = "st_date_type" id="st_date_type" class="TitSelect" style="height:20px;">
							      		<option value="BTOA" selected="selected">견적의뢰일</option>
										<option value="ATOS" >견적요청일</option>
										<option value="BTOAE" >회신요청일</option>
										<option value="ATOSE" >견적마감일</option>
		                           </select>
							</th>
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
								<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox" onclick="setTermPassFlag()">&nbsp;기간무시
								<input type="hidden" name="st_term_pass_flag" id="st_term_pass_flag" value="N">
							</td>
							<th><font color="#FF6600">*</font>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:55%" value="" readonly onclick="javascript:doPop('buyerMulti');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:55%" value="">
								<a href="javascript:doPop('buyerMulti');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							
						</tr>
						<tr> 
							<th>견적번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_quotation_no" name="st_quotation_no" style="width:87%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
							</td>
							<th>담당자</th>
							<td>
								<select id="st_kep_user_id" name="st_kep_user_id" style="width:90%;height:20px"></select>
							</td>
							<th>제조사</th>
							<td>
								<input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:55%" value="" readonly onclick="javascript:doPop('buyerMulti');">
								<input type="hidden" name="st_maker_code" id="st_maker_code" style="width:55%" value="">
								<a href="javascript:doPop('maker');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_maker_code','st_maker_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
						</tr>
						<tr> 
							<th>요청자</th>
							<td>
								<input type="text" class="input_type_text" id="st_btoa_user_name" name="st_btoa_user_name" style="width:87%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
							</td>
							<th>품목명/규격</th>
							<td>
								<input type="text" class="input_type_text" id="st_desc_spec" name="st_desc_spec" style="width:87%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
							</td>
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:87%;" value="" onkeydown="kepEnter()">
							</td>
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
  				<span class="fr">
  					<span class="btn_02"><a href="javascript:doAction('cancel');">견적취소</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('save');">견적제출</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
