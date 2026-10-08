<%--
**********************************************
* 메뉴 : 도안관리>품질검사 진행관리>농약포장재
* 화면 : 농약포장재
* 기능 : 품질검사 진행목록을 조회하고 관리한다.
* 프로그램 ID : PG_07_M_006_00
* 담당자 : 개발2 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/icon_r.gif";
var remarkOff="/resources/images/icon_w.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";


// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태|상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"|",	SaveName:"SELECTED"}
                    ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사명|고객사명",	SaveName:"BUYER_TEXT"}    //[31] 34
                    ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주번호|발주번호",	SaveName:"PO_NO"}    //[01]
                    ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"구매전표|구매전표",	SaveName:"LEGACY_PO_NO"}    //[02]
                    ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드|품목코드",	SaveName:"BUYER_ITEM_NO"}    //[03]
                    ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"검사로트|검사로트",	SaveName:"ITEM_CHECK_NO"}    //[04]
                    ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"입고번호|입고번호",	SaveName:"GR_NO"}    //[05]
                    ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"자재문서|자재문서",	SaveName:"LEGACY_GR_NO"}    //[06]
                    ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납기요청일|납기요청일",	SaveName:"RD_DATE"}    //[07]COMPODT.RD_DATE < ICOMGRDT.GR_DATE 이면 font color = red
                    ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"입고일자|입고일자",	SaveName:"GR_DATE"}    //[08]IICOMPODT.RD_DATE < ICOMGRDT.GR_DATE 이면 font color = red
                    ,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",	Header:"입고수량|입고수량",	SaveName:"ITEM_QTY", Format:"${qtyFormat}"}    //[09]
                    ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"단위|단위",	SaveName:"UNIT_MEASURE"}    //[10]
                    ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"발주일자|발주일자",	SaveName:"PO_CREATE_DATE"}    //[11]
                    ,{ Align:"Left",	Width:170,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품명|품명",	SaveName:"DESCRIPTION"}    //[12]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격|규격",	SaveName:"SPECIFICATION"}    //[13]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"검사항목|외관",	SaveName:"APPEAR_VAL"}    //[14]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"검사항목|사이즈",	SaveName:"SIZE_VAL"}    //[15]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"검사항목|재질",	SaveName:"MATTER_VAL"}    //[16]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"검사항목|중량",	SaveName:"WEIGHT_VAL"}    //[17]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"검사항목|용량",	SaveName:"CAPACITY_VAL"}    //[18]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"검사항목|두께",	SaveName:"DENSITY_VAL"}    //[19]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"검사항목|압축",	SaveName:"COMPRESSION_F"}    //[20]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"검사항목|파일강도",	SaveName:"DISRUPTION_F"}    //[21]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"검사항목|수분",	SaveName:"MOISTURE_F"}    //[22]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|외관",	SaveName:"APPEAR_VAL_TEXT"}    //[14]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|외관평가_내역",	SaveName:"APPEAR_REJT"}
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|사이즈",	SaveName:"SIZE_VAL_TEXT"}    //[15]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|사이즈평가_내역",	SaveName:"SIZE_REJT"}
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|재질",	SaveName:"MATTER_VAL_TEXT"}    //[16]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|재질평가_내역",	SaveName:"MATTER_REJT"}
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|중량",	SaveName:"WEIGHT_VAL_TEXT"}    //[17]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|중량평가_내역",	SaveName:"WEIGHT_REJT"}
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|용량",	SaveName:"CAPACITY_VAL_TEXT"}    //[18]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|용량평가_내역",	SaveName:"CAPACITY_REJT"}
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|두께",	SaveName:"DENSITY_VAL_TEXT"}    //[19]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|두께평가_내역",	SaveName:"DENSITY_REJT"}
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|압축",	SaveName:"COMPRESSION_F_TEXT"}    //[20]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|압축강도평가_내역",	SaveName:"COMPRESSION_REJT"}
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|압축강도_내역",	SaveName:"COMPRESSION"}
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|파일강도",	SaveName:"DISRUPTION_F_TEXT"}    //[21]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|파열강도평가_내역",	SaveName:"DISRUPTION_REJT"}
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|파열강도_내역",	SaveName:"DISRUPTION"}
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|수분",	SaveName:"MOISTURE_F_TEXT"}    //[22]
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|수분평가_내역",	SaveName:"MOISTURE_REJT"}
                    ,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"검사항목|수분_내역",	SaveName:"MOISTURE"}

                    ,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사|협력사",	SaveName:"AGENT_TEXT"}    //[20] 23
                    ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"처리방법|처리방법",	SaveName:"UD_TEXT"}    //[21] 24
                    ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사코드|협력사코드",	SaveName:"AGENT"}    //[22] 25
                    ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"UD_CODE|UD_CODE",	SaveName:"UD_CODE"}    //[23] 26
                    ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"발주순번|발주순번",	SaveName:"PO_SEQ"}    //[24] 27
                    ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"구매전표순번|구매전표순번",	SaveName:"LEGACY_PO_SEQ"}    //[25] 28
                    ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"입고순번|입고순번",	SaveName:"GR_SEQ"}    //[26] 29
                    ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"자재문서순번|자재문서순번",	SaveName:"LEGACY_GR_SEQ"}    //[27] 30
                    ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BYCA_COMORG_CODE|BYCA_COMORG_CODE",	SaveName:"BYCA_COMORG_CODE"}    //[28] 31
                    ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PLANT_CODE|PLANT_CODE",	SaveName:"PLANT_CODE"}    //[29] 32
                    ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약번호|계약번호",	SaveName:"CONTRACT_NO"}    //[30] 33
                    ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약순번|계약순번",	SaveName:"CONTRACT_SEQ"}    //[31] 34
                    
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:5};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	var initsheet2 = {};
	initsheet2.Cols = [ 
				 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
				,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : true,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
                ,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"업체명",	SaveName:"AGENT_NAME"}
                ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"업체코드",	SaveName:"AGENT"}
                ,{ Align:"Right",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"납기준수율",	SaveName:"RATE"} 
	];
	IBS_InitSheet(mySheet2, initsheet2,pagingMode);
	
	
	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);

	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_agent','getMpdsSellerListCombo','ALL',''); //협력사
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "PO_NO");	//발주번호
	setLinkCol(mySheet, "BUYER_ITEM_NO");	//품목코드
	setLinkCol(mySheet, "AGENT_TEXT");	//협력사
	setLinkCol(mySheet, "APPEAR_VAL");
	setLinkCol(mySheet, "SIZE_VAL");
	setLinkCol(mySheet, "MATTER_VAL");
	setLinkCol(mySheet, "WEIGHT_VAL");
	setLinkCol(mySheet, "CAPACITY_VAL");
	setLinkCol(mySheet, "DENSITY_VAL");
	setLinkCol(mySheet, "COMPRESSION_F");
	setLinkCol(mySheet, "DISRUPTION_F");
	setLinkCol(mySheet, "MOISTURE_F");
	//Sub List
	setLinkCol(mySheet2, "AGENT_NAME");

    
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="searchSub" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpds/getMasterMpDsAgrchemiPckmtrlList.do" , pagingMode );
		break;
	
	case "searchSub":	 // 조회(Sub)
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
		kepSearch(document.searchCondition,  mySheet2 , "/mpds/getMasterMpDsAgrchemiPckmtrlListSub.do" , pagingMode );
		break;

	case "reload":	// 초기화
		kepReload('searchCondition');
			mySheet.RemoveAll();
		break;

	case "save": // 저장
		if (!confirm('선택한 항목을 저장 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mpds/saveMasterMpDsAgrchemiPckmtrlList.do" , "SELECTED" );
		break;
		
	case "del": // 취소
		if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mpds/delMasterMpDsAgrchemiPckmtrlList.do" , "SELECTED" );
		break;

	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
		var param = {FileName:"농약포장재목록.xlsx", Merge:1,SheetDesign:1,DownCols:"BUYER_TEXT|PO_NO|LEGACY_PO_NO|BUYER_ITEM_NO|ITEM_CHECK_NO|GR_NO|LEGACY_GR_NO|RD_DATE|GR_DATE|ITEM_QTY|UNIT_MEASURE|PO_CREATE_DATE|DESCRIPTION|SPECIFICATION|APPEAR_VAL_TEXT|APPEAR_REJT|SIZE_VAL_TEXT|SIZE_REJT|MATTER_VAL_TEXT|MATTER_REJT|WEIGHT_VAL_TEXT|WEIGHT_REJT|CAPACITY_VAL_TEXT|CAPACITY_REJT|DENSITY_VAL_TEXT|DENSITY_REJT|COMPRESSION_F_TEXT|COMPRESSION_REJT|COMPRESSION|DISRUPTION_F_TEXT|DISRUPTION_REJT|DISRUPTION|MOISTURE_F_TEXT|MOISTURE_REJT|MOISTURE|AGENT_TEXT|UD_TEXT|UD_CODE|PLANT_CODE"};
		kepDownExcel(document.searchCondition ,mySheet , "/mpds/excelMasterMpDsAgrchemiPckmtrlList.do", param);
		$("#pageflag").val('1');
		break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
	alert(DATA);
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	
	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
<%-- 	alert(<% request.getParameter("data2");%>);return; --%>
// 	mySheet2.LoadSearchData(makeB2BData('${data2}'));
doAction('searchSub');
}
//조회 후처리(Sub)
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		alert(msg);
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
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsAgrchemiPckmtrlList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "masterMpDsItemResultPop": 
		     var buyer_code = $("#st_buyer_code").val();
	         if(buyer_code == "")
	         {
	            alert("고객사를 선택하여 주십시요.");
	            return;
	         }
			openSearchPopup('/mpds/showMasterMpDsItemResultPop.do','?st_buyer_code='+buyer_code,'800,440,no');
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'PO_NO') { // 발주번호
		var BUYER = $("#st_buyer_code").val();
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		openSearchPopup('/mpiv/getCommonMpIvOrderDetailPop.do','?buyer='+BUYER+'&po_no='+PO_NO,'820,550,no');		
		
	} else if (column == 'BUYER_ITEM_NO') { // 품목코드
		var byca_comorg_code = mySheet.GetCellValue(Row,"BYCA_COMORG_CODE");
		var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
		var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		openSearchPopup('/common/catalogDetailPop.do','?BUYER='+byca_comorg_code+'&BUYER_ITEM_NO='+buyerItemNo+'&CONTRACT_NO='+contractNo+'&CONTRACT_SEQ='+contractSeq,'800,290,no');

	} else if (column == 'AGENT_TEXT') { // 협력사
		var agent = mySheet.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,'800,550,no');

	} else if (column == 'APPEAR_VAL' || column == 'APPEAR_VAL' || column == 'SIZE_VAL' || 	column == 'MATTER_VAL' || column == 'WEIGHT_VAL' || 	
			column == 'CAPACITY_VAL' || column == 'DENSITY_VAL' || 	column == 'COMPRESSION_F' || column == 'DISRUPTION_F' || column == 'MOISTURE_F' ){ // 검사세부 팝업
		
		var buyer = $("#st_buyer_code").val();
		var legacy_po_no = mySheet.GetCellValue(Row,"LEGACY_PO_NO");
		var legacy_po_seq = mySheet.GetCellValue(Row,"LEGACY_PO_SEQ");
		var po_no = mySheet.GetCellValue(Row,"PO_NO");
		var po_seq = mySheet.GetCellValue(Row,"PO_SEQ");
		var legacy_gr_no = mySheet.GetCellValue(Row,"LEGACY_GR_NO");
		var legacy_gr_seq = mySheet.GetCellValue(Row,"LEGACY_GR_SEQ");
		var gr_no = mySheet.GetCellValue(Row,"GR_NO");
		var gr_seq = mySheet.GetCellValue(Row,"GR_SEQ");
		
		openSearchPopup('/mpds/getMasterMpDsInspDetailItemPop.do','?st_buyer='+buyer+'&st_legacy_po_no='+legacy_po_no+'&st_legacy_po_seq='+legacy_po_seq+'&st_po_no='+po_no+'&st_po_seq='+po_seq+'&st_legacy_gr_no='+legacy_gr_no+'&st_legacy_gr_seq='+legacy_gr_seq+'&st_gr_no='+gr_no+'&st_gr_seq='+gr_seq,'630,716,no' );
	}
	return;
}

//그리드 셀클릭 이벤트
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet2.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,'800,550,no');
	}
	return;
}


//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 다중 고객사
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(text);
	
	}
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>농약포장재</h3>
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
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
			
            	<table class="cont_t_list01" width="780"><!-- 마이페이지 닫힐때 width="887"-->
					<caption>농약포장재</caption>
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
				          <th  >
				            <select id="st_date_type" name="st_date_type" class="TitSelect">
				              <option value= "GR">입고일</option>
				              <option value= "PO">주문일</option>
				            </select>
				          </th>
				          <td  colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value=""> - 
		                        <input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value=""> 
		                        <span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>	
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>								
							</td>
				          <th  >결과값</th>
				          <td  >
				           <select  id="st_ud_code" name="st_ud_code">
				              <option value="ALL">전체</option>
				              <option value="A">가용</option>
				              <option value="AS">특채</option>
				              <option value="R">보류</option>
				            </select>
			              </td>
				        </tr>
				        <tr>
				          <th>검사항목</th>
				          <td>
				            <select  id="st_attr" name="st_attr">
				              <option value="ALL">전체</option>
				              <option value="APPEAR">외관 부적합</option>
				              <option value="SIZE">사이즈 부적합</option>
				              <option value="MATTER">재질 부적합</option>
				              <option value="WEIGHT">중량 부적합</option>
				              <option value="CAPACITY">용량 부적합</option>
				              <option value="DENSITY">두께 부적합</option>
				              <option value="COMPRESSION">압축강도 부적합</option>
				              <option value="DISRUPTION">파열강도 부적합</option>
				              <option value="MOISTURE">수분 부적합</option>
				            </select>
				          </td>
				          <th  >발주번호</th>
				          <td  >
				             <input type="text" id="st_po_no"  name="st_po_no"  maxlength="20" style="width:87%" value="" onKeyUp="kepToUpper('st_po_no')" onKeyDown="kepEnter()">
				          </td>
				          <th>협력사</th>
				          <td  >
								<select name="st_agent" id="st_agent" ></select>
				          </td>
				        </tr>
				        <tr>
				          <th >품목명/규격</th>
				          <td>
				            <input type="text" name="st_desc_spec" style="ime-mode:active;width:87%" value="" onKeyDown="kepEnter()">
				          </td>
				          <th  >검사로트</th>
				          <td  >
				            <input type="text" name="st_item_check_no" style="width:87%" value="" onKeyDown="kepEnter()">
				          </td>
				          <th >고객사</th>
				          <td >
				           <select  id="st_buyer_code" name="st_buyer_code">
				              <option value="KRKEPB0004">테스트 고객사</option>
				              <option value="KRDONG0107">주식회사 동부한농 구미</option>
				              <option value="KRDONG0110">주식회사 동부한농 인천공장</option>
				              <option value="KRDONG0128">동부정밀화학(주)전주공장</option>
				            </select>
				          </td>
					</tbody>
				</table>
            </div>

			<table style="width:100%;">
				<tr>
					<td align="left">
			           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
			               	<label for="b_no02" class="hidden">정렬개수선택</label>
								<select name="onepagerow" style="width: 70px;" >
								<option value="10" selected>10건</option>
								<option value="20">20건</option>
								<option value="30">30건</option>
								<option value="40">40건</option>
								<option value="50">50건</option>
							</select>
				            <img src="/resources/images/icon_r.gif" style="padding-top:3px;"/>부적합&nbsp;&nbsp;
				            <img src="/resources/images/icon_w.gif" style="padding-top:3px;"/>적합
						</span>
					</td>
			        <td align="right">
						<span class="btn_05"><a href="javascript:doPop('masterMpDsItemResultPop');">항목별결과</a></span>
			        </td>
		   		</tr>
			</table>
			            
		</form>
					
      	<!--grid 1-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "234px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
               <span class="fl">
               		<h3>업체별 납기 준수율</h3>
               </span>
  				<span class="fr">
  					<span class="btn_05 mr04" style="display:none"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  			 </div>

      	<!--grid 2-->
			
   			<div class="ib_product" style="border-top:0px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet2", "100%", "110px");
  				</script>
  			</div>

<!--내용 종료-->	                 

</body>
</html>
