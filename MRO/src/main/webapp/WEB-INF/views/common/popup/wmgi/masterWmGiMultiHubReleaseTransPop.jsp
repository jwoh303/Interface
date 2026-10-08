<%--
**********************************************
* 메뉴 : wms > 출고 > 출고지시 및 거래명세표 > 간선다중출고지시
* 화면 : 출고지시 및 거래명세표 > 간선다중출고지시
* 기능 : 출고지시 및 거래명세표 > 간선다중출고지시
* 프로그램 ID :
* 담당자 : HSJ
* 착수일 : 2025-12-19
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
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css"/>
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css"/>
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
<script src="/resources/js/wms_tr_sheet.js"></script>
<script src="/resources/js/wms_tr_multi_sheet.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>  
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	// 주의! SQL ORDER BY와 리스트 순서 고정되어야 함. 리스트 순서대로 출고지시 생성되어야 함.
	initsheet.HeaderMode = {Sort:1, ColMove:0, ColResize:1};
	initsheet.Cols = [  
 		{Align:"Center",	Type:"Status",		Width:60,	Hidden:true,	SaveName:"sStatus",				Header:"상태"}, 
		{Align:"Center",	Type:"DummyCheck",	Width:30,	Hidden:false,	SaveName:"SELECTED",			Header:""},
		{Align:"Center",	Type:"Text",		Width:50,	Hidden:true, 	SaveName:"ARRV_CENTER",			Header:"입고센터코드",		Edit : false},
		{Align:"Center",	Type:"Text",		Width:50,	Hidden:false, 	SaveName:"ARRV_CENTER_NAME",	Header:"간선",			Edit : false},
		{Align:"Center",	Type:"Text",		Width:50,	Hidden:true, 	SaveName:"DEPT_CENTER",			Header:"출고센터코드",		Edit : false},
		{Align:"Center",	Type:"Text",		Width:50,	Hidden:true, 	SaveName:"DEPT_CENTER_NAME",	Header:"출고센터",			Edit : false},
		{Align:"Center",	Type:"Text",		Width:80,	Hidden:true, 	SaveName:"BUYER",				Header:"고객사코드",		Edit : false},
		{Align:"Left",		Type:"Text",		Width:170,	Hidden:false, 	SaveName:"BUYER_NAME",			Header:"고객사명",			Edit : false},
		{Align:"Center",	Type:"Text",		Width:80,	Hidden:false, 	SaveName:"INV_NO",				Header:"입고번호",			Edit : false},
		{Align:"Center",	Type:"Text",		Width:80,	Hidden:true, 	SaveName:"INV_SEQ",				Header:"입고항번",			Edit : false},
		{Align:"Center",	Type:"Text",		Width:80,	Hidden:false, 	SaveName:"PO_NO",				Header:"발주번호",			Edit : false},
		{Align:"Center",	Type:"Text",		Width:80,	Hidden:true, 	SaveName:"PO_SEQ",				Header:"발주항번",			Edit : false},
		{Align:"Left",		Type:"Text",		Width:100,	Hidden:false, 	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",			Edit : false},
		{Align:"Center",	Type:"Date",		Width:80,	Hidden:false, 	SaveName:"PO_CREATE_DATE",		Header:"발주일",			Edit : false},
		{Align:"Center",	Type:"Date",		Width:80,	Hidden:false, 	SaveName:"RD_DATE",				Header:"납품요청일",		Edit : false},
		{Align:"Center",	Type:"Date",		Width:80,	Hidden:false, 	SaveName:"SCHEDULED_DATE",		Header:"출고예정일",		Edit : false},
		{Align:"Left",		Type:"Text",		Width:150,	Hidden:false, 	SaveName:"DESCRIPTION",			Header:"품명",			Edit : false},
		{Align:"Left",		Type:"Text",		Width:220,	Hidden:false, 	SaveName:"SPECIFICATION",		Header:"규격",			Edit : false},
		{Align:"Center",	Type:"Text",		Width:50,	Hidden:false, 	SaveName:"UNIT_MEASURE",		Header:"단위",			Edit : false},
		{Align:"Right",		Type:"Text",		Width:60,	Hidden:false, 	SaveName:"WMS_IK_QTY",			Header:"출고수량",			Edit : false},
		{Align:"Right",		Type:"Text",		Width:60,	Hidden:false, 	SaveName:"BOX_QTY",				Header:"박스수량",			Edit : false},
		{Align:"Center",	Type:"Text",		Width:100,	Hidden:true, 	SaveName:"BYIT_COMORG_CODE",	Header:"카탈로그관리코드",	Edit : false},
		{Align:"Center",	Type:"Text",		Width:100,	Hidden:true, 	SaveName:"CONTRACT_NO",			Header:"계약서번호",		Edit : false},
		{Align:"Center",	Type:"Text",		Width:100,	Hidden:true, 	SaveName:"CONTRACT_SEQ",		Header:"계약서항번",		Edit : false}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:4};
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetCountPosition(4);
	
	kepSetCalender("st_inv_date");
	$("#st_inv_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
	
	kepSetCalender("st_scheduled_date");
	$("#st_scheduled_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
	$("#st_scheduled_date").val(kepToDateAdd("1","P"));
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");
 	
	kepSearch(document.searchCondition, mySheet, "/wmgi/getMasterWmGiMultiHubReleaseTransPop.do", pagingMode);
}

var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiMultiHubReleaseTransPop.do" , pagingMode );
			break;
			
		case "save":
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	 	 	var arrRow = selectedGrid.split("|");
	 	 	
	 	 	if(selectedGrid.length == 0){
	 	        alert("출고지시 대상을 선택해 주십시요.");
	 	        return;
	 	 	}
	 	 	
		    if(!confirm("간선다중출고지시를 하시겠습니까?")){
		        return;
		    }else{
				kepSave(document.searchCondition, mySheet, "/wmgi/saveMasterWmGiMultiHubReleaseTransPop.do", "SELECTED");
		    }
			break;
	}
}

function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

//헤더 더블클릭시 복사
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if(Row > 0){
		return;
	}
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if(code =="1"){
		alert("정상적으로 간선 출고지시가 되었습니다.");
		this.close();
	}else{
		if(msg!= ''){
			alert(msg);
		}
		
		return;
	 }
}

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiMultiHubReleaseTransPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;
	
	if(column == "BUYER_ITEM_NO"){
		if(mySheet.GetCellValue(Row,"BUYER_ITEM_NO") != ""){
			var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
			var BYIT_COMORG_CODE = mySheet.GetCellValue(Row, "BYIT_COMORG_CODE");
			var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
			var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
			openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ, "800,260,no"); 
		}
	}
	
	return;
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	grbRow="";	//초기화
}
</script>
<body onload="kep_onload_view();">
<form name="searchCondition" method="post" onsubmit="return false">
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag" name="pageflag" value="1">
	<input type="hidden" id="st_user_id" name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_date_type" name="st_date_type" value="<%=CommonUtil.nvl((String) request.getParameter("st_date_type"),"") %>">
	<input type="hidden" id="st_from_date" name="st_from_date" value="<%=CommonUtil.nvl((String) request.getParameter("st_from_date"),"") %>">
	<input type="hidden" id="st_to_date" name="st_to_date" value="<%=CommonUtil.nvl((String) request.getParameter("st_to_date"),"") %>">
	<input type="hidden" id="st_warehouse_code" name="st_warehouse_code" value="<%=CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"") %>">
	
	<div id="popWrapper" style="height:565px;">
    	<div id="popHeader">
        	<h1 class="title">간선다중출고지시</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <!--조회영역-->
            <table class="cont_t_list06" style="width:100%">
				<caption>조회</caption>
				<colgroup>
					<col width="100px" />
					<col width="25%" />
					<col width="100px" />
					<col width="25%" />
					<col width="100px" />
					<col width="25%" />
				</colgroup>

				<tbody>
					<tr>
						<th>물류센터</th>
						<td>
							<b><%=CommonUtil.nvl((String) request.getParameter("st_warehouse_name"),"") %></b>
						</td>
						<th>출고일자</th>
						<td>
							<input type="text" class="input_type_text" name="st_inv_date" id="st_inv_date" readOnly style="width:100px; text-align:center;" value="">
							<a href="javascript:kepCalendar('st_inv_date')"></a>
						</td>
						<th>출고예정일</th>
						<td>
							<input type="text" class="input_type_text" name="st_scheduled_date" id="st_scheduled_date" readOnly style="width:100px; text-align:center;" value="">
							<a href="javascript:kepCalendar('st_scheduled_date')"></a>
						</td>
					</tr>
				</tbody>
			</table>

			<font color="#006699">※ 해당 화면은 </font>
			<font color="#FF0000"><b>센터명 / 출고지시 화면의 일자 조회조건 기준</b></font>
			<font color="#006699">으로 간선 다중출고지시가 가능한 전체 리스트를 노출합니다. 상단의 선택된 출고일과 출고예정일로 정보를 저장합니다.</font>
			
			<!--grid-->
 			<div style="border-top:2px solid #3c639c;height:420px;">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "100%");
				</script>
			</div>
		</div>
        
        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
				<span class="btn_06 mr04"><a href="javascript:doAction('save');">간선다중출고지시</a></span>
			</span>
       </div>
    </div>
</form>
</body>
</html>