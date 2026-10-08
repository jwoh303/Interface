<%--
**********************************************
* 메뉴 : 구매대행>주문관리>주문진행관리
* 화면 : TR진행관리
* 기능 : TR 입고에 대한 진행관리 조회
* 프로그램 ID : PG_06_M_003_00
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-7-30
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%

	String buyer = "";
	String userid = "";
	String comType = "";
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());
		comType =  CommonUtil.nvl((String)_sessionInfo.getComType());
	} 
	String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_po_user_id"),""); // 조회조건
	String whAdmin = _sessionInfo.getWhAdmin();
	
%>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var LocationOn = "/resources/images/btn_search03.gif";
var addUserName = "/resources/images/btn_search03.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view(){

	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태|상태",	SaveName:"sStatus"}
					,{ Align:"Left",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사|고객사", SaveName:"BUYER_NAME"} 
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태|상태", SaveName:"STATUS_TEXT"}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		ToolTip:1,	Header:"품목|품목명", SaveName:"DESCRIPTION"} 
					,{ Align:"Left",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	ToolTip:1, Header:"품목|품목코드", SaveName:"BUYER_ITEM_NO"} 
					,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목|표준코드", SaveName:"STDCATLG_ID"}
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	ToolTip:1,	Header:"품목|규격", SaveName:"SPECIFICATION" }
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주|발주번호", SaveName:"PO_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"발주|발주순번", SaveName:"PO_SEQ"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주|LEGACY_NO", SaveName:"LEGACY_PO_NO"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"발주|LEGACY_SEQ", SaveName:"LEGACY_PO_SEQ"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"발주|발주일", SaveName:"PO_CREATE_DATE"} 
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}", 	Header:"발주|발주수량", SaveName:"PO_QTY"} 
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"납품|납품요청일", SaveName:"RD_DATE"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"납품|납품일", SaveName:"DELIVERY_DATE"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}", 	Header:"납품|납품수량", SaveName:"INV_QTY"} 
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"납품|송장번호", SaveName:"IK_NO"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}", 	Header:"납품|박스수량", SaveName:"BOX_QTY"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"입고|입고번호", SaveName:"GR_NO"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"입고|입고일", SaveName:"GR_DATE"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}", 	Header:"입고|입고수량", SaveName:"GI_DELIVERY_QTY"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"출고|출고일", SaveName:"INV_DATE"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}", 	Header:"출고|출고수량", SaveName:"WMS_IVK_QTY"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}", 	Header:"출고|기출고수량", SaveName:"WMS_GR_QTY"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"배송처|배송처",	SaveName:"DELY_TO_LOCATION_IMG"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"배송처|배송처",	SaveName:"DELY_TO_LOCATION"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${priceFormat}",	Header:"매출매입|매입단가", Format:"#,##0", SaveName:"LIST_PRICE"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	 Type : "Float", Format:"${priceFormat}", Header:"매출매입|매출단가", SaveName:"UNIT_PRICE"} 
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${priceFormat}",Header:"매출매입|매입금액", SaveName:"LIST_AMT"} 
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	 Type : "Float", Format:"${priceFormat}",Header:"매출매입|매출금액", SaveName:"UNIT_AMT"}
					,{ Align:"Center",	Width:60,	    Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"요청자|요청자", SaveName:"ADD_USER_NAME_IMG"} 
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자|요청자", SaveName:"ADD_USER_NAME"} 
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자전화번호|요청자전화번호", SaveName:"ADD_USER_TEL"} 
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자발주번호|요청자발주번호", SaveName:"PO_HD_REMARK"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"구분|구분", SaveName:"DOC_TEXT"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"협력사|협력사", SaveName:"AGENT"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"협력사|협력사", SaveName:"AGENT_IMG"}
					,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고|비고",	SaveName:"PO_REMARK_IMG"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"비고|비고", SaveName:"PO_REMARK"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"고객사코드|고객사코드", SaveName:"BUYER"}					
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"카탈로그관리코드|카탈로그관리코드", SaveName:"BYIT_COMORG_CODE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"계약번호|계약번호", SaveName:"CONTRACT_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"계약순번|계약순번", SaveName:"CONTRACT_SEQ"}	
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"구분|구분", SaveName:"GUBUN"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"물류센터코드|물류센터코드", SaveName:"WAREHOUSE_CODE"} 
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"물류비(%)|물류비(%)", SaveName:"LOGISTICS_RATE"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"물류비코드|물류비코드", SaveName:"LOGIS_RATE_STATUS"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(0, remarkOff);
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(2, LocationOn);
	mySheet.SetImageList(3, addUserName);

	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL','');
 
	//하이퍼링크 설정
	setLinkCol(mySheet, "GR_NO");	//입고번호
	setLinkCol(mySheet, "IK_NO");	//송장번호
	setLinkCol(mySheet, "DELIVERY_DATE"); // 납품일
	setLinkCol(mySheet, "LEGACY_PO_NO");
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "DELY_TO_LOCATION_IMG");
	setLinkCol(mySheet, "PO_REMARK_IMG");
	setLinkCol(mySheet, "ADD_USER_NAME_IMG");
	setLinkCol(mySheet, "PO_NO");
	setLinkCol(mySheet, "BUYER_NAME");
	setLinkCol(mySheet, "AGENT_IMG");
	setLinkCol(mySheet, "LOGISTICS_RATE");
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val(  kepGetNowTimeStr('YYYYMMDD','/'));
	$("#st_to_date").val( kepToMonthAdd("1","P"));
	
	// 콤보데이터 셋팅
	kepAjaxCommonQueryIdCombo("st_warehouse_code", "master.mpso.getMasterMpSoStockMovemntRequestRegWareHouseFrList", "ALL", "<%=st_warehouse_code%>"); // 물류센터

	if(document.searchCondition.st_warehouse_code.options.length == 1 )
	{
		document.searchCondition.st_warehouse_code.disabled = true;
	}
	
}
	
	
var st;
var mt;
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
	case "search":	 // 조회
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		
		current_page = -1;
	 	var buyer_code      = $("#st_buyer_code").val();
		if(buyer_code == "" ) {
			alert("고객사를 선택하여 주십시요.\n\n필수 사항 입니다.");
			return;
		}
	 	var warehouse_code  = $("#st_warehouse_code").val();
		if(warehouse_code == "" ) {
			alert("물류센터를 선택하여 주십시요.\n\n필수 사항 입니다.");
			return;
		}
		var po_no = $("#st_po_no").val();
		if(document.getElementById("st_checkbox").checked == true){
			if( po_no ==""){
				alert("기간을 무시하고 조회시 고객사, 물류센터 선택후\n\n발주번호를 정확히(전체입력) 기입해야 합니다.");	
				return false;
			}			
			$("#st_all_po").val('Y');
		}else{
			var diff = kepGetDateDiff('st_from_date','st_to_date','D');
			if (eval(diff)>183){
				alert("6개월내 조회만 가능합니다.");
				return;
			}			
			$("#st_all_po").val('N');
		}
		
		
	
		kepSearch(document.searchCondition,  mySheet , "/wmgr/getMasterMpSoTrProgressManageList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
	
			mySheet.RemoveAll();
		break;

	case "save": // 저장
		if (!confirm('선택한 항목을 저장 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/wmgr/saveMasterMpSoTrProgressManageList.do" , "SELECTED" );
		break;
		
	case "del": // 취소
		if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/wmgr/delMasterMpSoTrProgressManageList.do" , "SELECTED" );
		break;

	case "excelDown": // 엑셀다운로드
		var buyer_code      = $("#st_buyer_code").val();
		if(buyer_code == "" ) {
			alert("고객사를 선택하여 주십시요.\n\n필수 사항 입니다.");
			return;
		}
	    $("#pageflag").val('0');
// 		var param = {FileName:"MyExcel.xlsx",DownCols:"sStatus|BUYER_NAME|PO_NO|GR_NO|IK_NO|STDCATLG_ID|PO_CREATE_DATE|WMS_GR_DATE|PO_QTY|LIST_PRICE|LIST_AMT|STATUS|LEGACY_PO_NO|PORS_CD_DATE|BUYER_ITEM_NO|RD_DATE|ADD_USER_NAME|ADD_USER_TEL|INV_QTY|UNIT_PRICE|UNIT_AMT|DESCRIPTION|SPECIFICATION|AGENT_NAME|GI_GR_QTY|DELIVERY_DATE|DELY_TO_LOCATION|PO_REMARK_IMG|PO_REMARK"};
		var param = {FileName:"TR진행관리.xlsx",DownCols:"BUYER_NAME|STATUS_TEXT|DESCRIPTION|BUYER_ITEM_NO|STDCATLG_ID|SPECIFICATION|PO_NO|PO_SEQ|LEGACY_PO_NO|LEGACY_PO_SEQ|PO_CREATE_DATE|PO_QTY|RD_DATE|DELIVERY_DATE|INV_QTY|IK_NO|BOX_QTY|GR_NO|GR_DATE|GI_DELIVERY_QTY|INV_DATE|WMS_IVK_QTY|WMS_GR_QTY|DELY_TO_LOCATION|LIST_PRICE|UNIT_PRICE|LIST_AMT|UNIT_AMT|ADD_USER_NAME|ADD_USER_TEL|PO_HD_REMARK|DOC_TEXT|AGENT|PO_REMARK|BUYER|BYIT_COMORG_CODE|CONTRACT_NO|CONTRACT_SEQ|GUBUN|WAREHOUSE_CODE|LOGISTICS_RATE|LOGIS_RATE_STATUS"};
		kepDownExcel(document.searchCondition ,mySheet , "/wmgr/excelMasterMpSoTrProgressManageList.do", param);
		$("#pageflag").val('1');
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

   	
   	
	if (msg != "") {
		alert(msg);
	}
// 	for(i= 1 ; i<mySheet.GetTotalRows()+1; i++)
// 	{
// 		if(mySheet.GetCellValue(i,"DELY_TO_LOCATION")!="")
// 		{
// 			mySheet.SetCellValue(i, 'DELY_TO_LOCATION_IMG', LocationOn);
// 		}
// 		if(mySheet.GetCellValue(i,"PO_REMARK")!="")
// 		{
// 			mySheet.SetCellValue(i, 'PO_REMARK_IMG', remarkOn);
// 		}
// 		if(mySheet.GetCellValue(i,"ADD_USER_NAME")!="")
// 		{
// 			mySheet.SetCellValue(i, 'ADD_USER_NAME_IMG', addUserName);
// 		}
// 	}
	
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
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
// 	alert(downloadType + ' 다운이 완료되었습니다. \n 다운로드 결과 : ' + ((result==true)?'성공':'실패'));
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterMpSoTrProgressManageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
	case "buyer_single": // 고객사 M

// 		if($("#st_warehouse_code").val() == ''){
// 			alert('물류센터를 선택해 주십시오.');return;
// 		}
// 	    var ware_house_code = document.searchCondition.st_warehouse_code.value;
// 	    var st_from_date = document.searchCondition.st_from_date.value;
// 	    var st_to_date = document.searchCondition.st_to_date.value;
// 	    var st_date_flag = "RD";
// 		var warehouse_agent = "";
// 		if(ware_house_code == "KRKORE0068"){
// 			warehouse_agent = "KRKORE0069";
// 		}else if(ware_house_code == "KRKORE0126"){
// 			warehouse_agent = "KRKORE0127";
// 		}
// 		openSearchPopup('/wmco/showMasterWmCoMbrcmpyPop.do','?st_warehouse_code='+ware_house_code+'&st_wareHouse_agent='+warehouse_agent+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date+'&st_date_flag='+st_date_flag,'500,500,no');
		
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
        popupSel = "buyer_single";
        break;	
	case "agent_single": // 협력사 M
		openSearchPopup('/coco/showCommonCoCoCompanyPop.do','?com_type=S&multi_flag=M&safety_flag=undefined&save_flag=undefined', '500,500,no');
		popupSel = "agent_single";
		break;	

	}
}
function localDateEval(RD_DATEval)
{
	 	var yyyy = RD_DATEval.substr(0,4);
	 	var mm = eval(RD_DATEval.substr(4,2) + "- 1") ;
		var dd = RD_DATEval.substr(6,2);
    	var dt3 = new Date(yyyy, mm, eval(dd + '-' +'2'));
	   	 yyyy = dt3.getFullYear();
		 mm = (dt3.getMonth()+1)<10? "0" + (dt3.getMonth()+1) : (dt3.getMonth()+1) ;
		 dd = dt3.getDate()<10 ? "0" + dt3.getDate() : dt3.getDate();
		 return  "" + yyyy + "/" + mm + "/" + dd ;
}	
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	
	
	if(column == 'BUYER_NAME')
	{
		if(mySheet.GetCellValue(Row,'BUYER_NAME')!=""){
			
			 var com_code = mySheet.GetCellValue(Row,'BUYER');
			 var st_from_date = document.searchCondition.st_from_date.value;
			 var st_to_date = document.searchCondition.st_to_date.value;
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date,'800,600,no'); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}
	else if(column == 'PO_NO')
	{
		if(mySheet.GetCellValue(Row,'PO_NO')!=""){
			
// 		    var ware_house_code = document.searchCondition.st_warehouse_code.value;
		    var ware_house_code = mySheet.GetCellValue(Row,'WAREHOUSE_CODE');
			var buyer = mySheet.GetCellValue(Row,'BUYER');
	    	var po_no = mySheet.GetCellValue(Row,'PO_NO');
	    	var inv_no = mySheet.GetCellValue(Row,'GR_NO');
	    	var BUYER_NAME  = mySheet.GetCellValue(Row,'BUYER_NAME');
	    	var PO_CREATE_DATE = mySheet.GetCellText(Row,'PO_CREATE_DATE');
	    	var st_RD_DATE = mySheet.GetCellText(Row,'RD_DATE');
	    	var DOC_TEXT =mySheet.GetCellValue(Row,'DOC_TEXT');
	    	var RD_DATEval = mySheet.GetCellValue(Row,'RD_DATE');
	    	var GR_DATE_RE =  localDateEval(RD_DATEval);
	    	var ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME');
	    	var DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
	    	var PO_REMARK = mySheet.GetCellValue(Row,'PO_HD_REMARK');
	    	var AGENT = mySheet.GetCellValue(Row,'AGENT');
	    	var AGENT_NAME = mySheet.GetCellValue(Row,'AGENT_NAME_ORG');
	    	var AGENT_TEL_NO = mySheet.GetCellValue(Row,'AGENT_TEL_NO');
	    	var st_STATUS = mySheet.GetCellValue(Row,"STATUS_TEXT"); 
	    	var st_LEGACY_PO_NO = mySheet.GetCellValue(Row,'LEGACY_PO_NO');
	    	var st_DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
	    	openSearchPopup('/wmgr/showMasterWmGrTrOrderGrRegPop.do','?BUYER='+buyer+'&PO_NO='+po_no+'&INV_NO='+inv_no+'&BUYER_NAME='+BUYER_NAME+'&PO_CREATE_DATE='+PO_CREATE_DATE+'&st_RD_DATE='
	    			+st_RD_DATE+'&DOC_TEXT='+DOC_TEXT+'&GR_DATE_RE='+GR_DATE_RE+'&ADD_USER_NAME='+ADD_USER_NAME+'&DELY_TO_LOCATION='+DELY_TO_LOCATION+'&PO_REMARK='+PO_REMARK+'&AGENT_NAME='+AGENT_NAME
	    			+'&ware_house_code='+ware_house_code+'&st_STATUS='+st_STATUS+'&st_LEGACY_PO_NO='+st_LEGACY_PO_NO+'&st_DELY_TO_LOCATION='+st_DELY_TO_LOCATION+'&AGENT='+AGENT+'&AGENT_TEL_NO='+AGENT_TEL_NO,'900,490,no'); 
			popupSel = "masterWmGrTrOrderManagerPop";
		}
	}else if (column == 'GR_NO') { 
		if(mySheet.GetCellValue(Row, 'GR_NO') !="")
		{		
				var BUYER_NAME = mySheet.GetCellValue(Row,"BUYER_NAME"); //고객사
				var PO_NO = mySheet.GetCellValue(Row,"PO_NO"); //발주번호
				var PO_CREATE_DATE = mySheet.GetCellText(Row,"PO_CREATE_DATE"); //발주일
				var RD_DATE = mySheet.GetCellText(Row,"RD_DATE"); //납품요청일
				var INV_NO = mySheet.GetCellValue(Row,"GR_NO"); //입고번호
				var DOC_TEXT =mySheet.GetCellValue(Row,'DOC_TEXT');
				var STATUS = mySheet.GetCellValue(Row,"STATUS"); //구분
				var WMS_GR_DATE = mySheet.GetCellText(Row,"GR_DATE"); //입고일
				var AGENT = mySheet.GetCellValue(Row,"AGENT"); //협력사
				var AGENT_NAME = mySheet.GetCellValue(Row,'AGENT_NAME_ORG');
				var AGENT_TEL_NO = mySheet.GetCellValue(Row,'AGENT_TEL_NO');
				var ADD_USER_NAME = mySheet.GetCellValue(Row,"ADD_USER_NAME"); //요청자
				var ADD_USER_TEL = mySheet.GetCellValue(Row,"ADD_USER_TEL"); //요청자
				var DELY_TO_LOCATION = mySheet.GetCellValue(Row,"DELY_TO_LOCATION"); //배송처
				var BUYER = mySheet.GetCellValue(Row,"BUYER"); //BUYER
				var WMS_GR_QTY = mySheet.GetCellValue(Row,"WMS_GR_QTY"); 
				var WMS_IVK_QTY = mySheet.GetCellValue(Row,"WMS_IVK_QTY"); 
				openSearchPopup('/wmgr/showMasterWmGrWarehousingPop.do','?workType=MP&BUYER_NAME='+BUYER_NAME+'&PO_NO='+PO_NO+'&PO_CREATE_DATE='+PO_CREATE_DATE+'&RD_DATE='+RD_DATE+
						'&INV_NO='+INV_NO+'&STATUS='+STATUS+'&WMS_GR_DATE='+WMS_GR_DATE+'&AGENT='+AGENT+
						'&ADD_USER_NAME='+ADD_USER_NAME+'&DELY_TO_LOCATION='+DELY_TO_LOCATION+'&BUYER='+BUYER+'&DOC_TEXT='+DOC_TEXT+'&ADD_USER_TEL='+ADD_USER_TEL+'&ADD_USER_NAME='+ADD_USER_NAME+
						'&AGENT_NAME='+AGENT_NAME+'&WMS_IVK_QTY='+WMS_IVK_QTY+'&WMS_GR_QTY='+WMS_GR_QTY+'&AGENT_TEL_NO='+AGENT_TEL_NO,'900,495,no');
				popupSel = "masterWmGrWarehousingPop";
		}
	} 
	else if(column == 'IK_NO')
	{
		if(mySheet.GetCellValue(Row,'IK_NO')!=""){
			var st_buyer = mySheet.GetCellValue(Row,'BUYER');
			var st_BUYER_NAME  = mySheet.GetCellValue(Row,'BUYER_NAME');
			var st_INV_DATE =mySheet.GetCellText(Row,'INV_DATE');
			var st_DELIVERY_DATE = mySheet.GetCellText(Row,'DELIVERY_DATE');  
			var st_IK_NO = mySheet.GetCellValue(Row,'IK_NO');  
			var st_STATUS_TEXT = mySheet.GetCellValue(Row,'STATUS_TEXT');
			var st_ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME');
			var st_ADD_USER_TEL = mySheet.GetCellValue(Row,'ADD_USER_TEL');
			var st_ADD_USER_ID = mySheet.GetCellValue(Row,'ADD_USER_ID');
			var st_DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
		    var st_WMS_GR_QTY = mySheet.GetCellValue(Row,'WMS_GR_QTY');
		    var st_ware_house_code = mySheet.GetCellValue(Row,'WAREHOUSE_CODE');
// 			var st_ware_house_code = document.searchCondition.st_warehouse_code.value;
			openSearchPopup('/wmgi/showMasterWmGiInvoiceNoPop.do','?workType=MP&st_BUYER_NAME='+st_BUYER_NAME+'&st_INV_DATE='+st_INV_DATE+'&st_DELIVERY_DATE='+st_DELIVERY_DATE+'&st_IK_NO='+st_IK_NO
					+'&st_STATUS_TEXT='+st_STATUS_TEXT+'&st_ADD_USER_NAME='+st_ADD_USER_NAME+'&st_ADD_USER_TEL='+st_ADD_USER_TEL+'&st_ADD_USER_ID='+st_ADD_USER_ID+'&st_DELY_TO_LOCATION='+st_DELY_TO_LOCATION+
					'&st_ware_house_code='+st_ware_house_code+'&st_buyer='+st_buyer+'&st_type=X&st_PODT_GR_QTY='+st_WMS_GR_QTY,'1000,500,no');
	
		}
	}
	else if(column == 'DELIVERY_DATE')
	{
		if(mySheet.GetCellValue(Row,'DELIVERY_DATE')!=""){
			var st_buyer = mySheet.GetCellValue(Row,'BUYER');
			var st_BUYER_NAME  = mySheet.GetCellValue(Row,'BUYER_NAME');
			var st_INV_DATE =mySheet.GetCellText(Row,'INV_DATE');
			var st_DELIVERY_DATE = mySheet.GetCellText(Row,'DELIVERY_DATE');  
			var st_IK_NO = mySheet.GetCellValue(Row,'IK_NO');  
			var st_STATUS_TEXT = mySheet.GetCellValue(Row,'STATUS_TEXT');
			var st_ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME');
			var st_ADD_USER_TEL = mySheet.GetCellValue(Row,'ADD_USER_TEL');
			var st_ADD_USER_ID = mySheet.GetCellValue(Row,'ADD_USER_ID');
			var st_DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
		    var st_WMS_GR_QTY = mySheet.GetCellValue(Row,'WMS_GR_QTY');
// 		    var st_MODIFIABLE = mySheet.GetCellValue(Row,'MODIFIABLE');
		    var st_MODIFIABLE = "";
		    var st_ware_house_code = mySheet.GetCellValue(Row,'WAREHOUSE_CODE');
// 			var st_ware_house_code = document.searchCondition.st_warehouse_code.value;
	
			openSearchPopup('/wmgi/showMasterWmIvkConfirmDeletePop.do','?workType=MP&st_BUYER_NAME='+st_BUYER_NAME+'&st_INV_DATE='+st_INV_DATE+'&st_DELIVERY_DATE='+st_DELIVERY_DATE+'&st_IK_NO='+st_IK_NO
					+'&st_STATUS_TEXT='+st_STATUS_TEXT+'&st_ADD_USER_NAME='+st_ADD_USER_NAME+'&st_ADD_USER_TEL='+st_ADD_USER_TEL+'&st_ADD_USER_ID='+st_ADD_USER_ID+'&st_DELY_TO_LOCATION='+st_DELY_TO_LOCATION+
					'&st_ware_house_code='+st_ware_house_code+'&st_buyer='+st_buyer+'&st_type=X&st_PODT_GR_QTY='+st_WMS_GR_QTY+'&st_MODIFIABLE='+st_MODIFIABLE,'1000,500,no');
		}
	}
	else if((column == 'LEGACY_PO_NO') )
	{
		if(mySheet.GetCellValue(Row, 'LEGACY_PO_NO') !="")
		{
			var BUYER_NAME = mySheet.GetCellValue(Row,"BUYER_NAME"); //고객사
			var LEGACY_PO_NO = mySheet.GetCellValue(Row,"LEGACY_PO_NO"); //LEGACY_NO 
			
			var STATUS =mySheet.GetCellValue(Row,"GUBUN"); 
			var ADD_USER_NAME = mySheet.GetCellValue(Row,"ADD_USER_NAME")+"("+mySheet.GetCellValue(Row,"ADD_USER_TEL")+")"; //요청자
			var PO_REMARK = mySheet.GetCellValue(Row,"PO_HD_REMARK"); //비고
			var BUYER = mySheet.GetCellValue(Row,"BUYER"); //BUYER
			var DOC_TEXT =mySheet.GetCellValue(Row,'DOC_TEXT');
			var DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
			openSearchPopup('/wmgr/showMasterWmGrLegacyNoPop.do','?BUYER_NAME='+BUYER_NAME+'&LEGACY_PO_NO='+LEGACY_PO_NO+'&STATUS='+STATUS+'&ADD_USER_NAME='+ADD_USER_NAME+'&PO_REMARK='+PO_REMARK+'&BUYER='+BUYER+'&DOC_TEXT='+DOC_TEXT+'&DELY_TO_LOCATION='+DELY_TO_LOCATION,'1300,500,no');
			popupSel = "masterWmGrLegacyNoPop";
		
		}
	}
	else if((column == 'BUYER_ITEM_NO') )
	{
		if(mySheet.GetCellValue(Row, 'BUYER_ITEM_NO') !="")
		{
			var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
			var BYIT_COMORG_CODE = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
			var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
			var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
			openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ,'800,255,no');
		}
	}else if(column=="DELY_TO_LOCATION_IMG" )
	{
		if(mySheet.GetCellValue(Row,'DELY_TO_LOCATION')!="")
		{
			var DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
			openSearchPopup('/wmco/showMasterWmCoDlvryPop.do','?DELY_TO_LOCATION='+DELY_TO_LOCATION,'500,205,no');
			popupSel = "masterWmCoDlvryPop";
		}
	}else if(column=="PO_REMARK_IMG" )
	{
		if(mySheet.GetCellValue(Row,'PO_REMARK')!="")
		{
			var PO_REMARK = mySheet.GetCellValue(Row,'PO_REMARK');
			openSearchPopup('/common/remarkBtoAPop.do','?st_btoa_remark='+PO_REMARK,'500,220,no');
			popupSel = "remarkBtoA";
		}		
	}else if(column=="ADD_USER_NAME_IMG" )
	{
		if(mySheet.GetCellValue(Row,'ADD_USER_NAME')!="")
		{
			var st_add_user_name = mySheet.GetCellValue(Row,'ADD_USER_NAME');
			var st_add_user_tel = mySheet.GetCellValue(Row,'ADD_USER_TEL');
			var st_po_hd_remark = mySheet.GetCellValue(Row,'PO_HD_REMARK');
			openSearchPopup('/wmco/showMasterWmCoRequestPop.do','?st_ADD_USER_NAME='+st_add_user_name+'&st_ADD_USER_TEL='+st_add_user_tel+'&st_POHD_REMARK='+st_po_hd_remark,'500,215,no');
			popupSel = "masterWmCoRequestPop.jsp";
		}		
	}else 	if(column == 'AGENT_IMG'){
		if(mySheet.GetCellValue(Row,'AGENT')!=""){
			
			 var com_code = mySheet.GetCellValue(Row,'AGENT');
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code,'800,600,no'); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}else if(column == "LOGISTICS_RATE"){ // 물류비
		if(mySheet.GetCellValue(Row,'LOGIS_RATE_STATUS')!=""){
			var code = mySheet.GetCellValue(Row, "LOGIS_RATE_STATUS");
			openSearchPopup('/common/getLogisFeeReasonPop.do','?st_reason_code=' + code, '600,180,no');// 물류비 책정 사유			
		}
	}
	return;
	
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	
	}else if(popupSel == "agent_single"){
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
	}else 	if (popupSel == "buyer_single") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	} 
	grbRow="";	//초기화
}



	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>TR진행관리</h3>
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
			<input type="hidden" name="st_all_po"  id="st_all_po" value ="N">
			
            	<table  class="cont_t_list01" style="width:1024px;">
					<caption>TR입고진행관리</caption>
					<colgroup>
						<col width="10%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
                        <col width="24%" />
					</colgroup>
						
					<tbody>
						<tr> 
							<th>
							<label for="b_code" class="hidden">기간선택</label>
				  			<select name = "st_date_type" id="st_date_type" style="height:20px" class="TitSelect">
					      		<option value="RD" selected="selected">납품요청일</option>
								<option value="PO" >발주일</option>
								<option value="GR" >센터입고일</option>
							</th>
							<td colspan="3">
								<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" > - 
								<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" >
									&nbsp;&nbsp;
 									<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>
									<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
<!-- 								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>														 -->
									<span class="btn_month"><a href="javascript:kepFromMonth('st_from_date','st_to_date','1')">-1개월</a></span>
									<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox">&nbsp;기간무시
							<img src="/resources/images/but_query.png" title="[기간무시 조회기준]&#10;1. 고객사 입력, 물류센터 선택&#10;2. 발주번호 필수 입력">
							</td>
							<th><font color="red"><b>*</b></font>물류센터</th>
							<td>
								<select id="st_warehouse_code" name="st_warehouse_code" style="width:90%;height:20px" 	>
								<%
						 			Map<String, String> _map = new HashMap<String, String>();
						 			_map.put("BUYER",buyer);
						 			_map.put("USERID",userid);
						 			_map.put("whAdmin",whAdmin);
								%>
								<%= CommonUtil.getCodeComboQueryIdList("common.getWareHouseIdSchStockList","",_map,st_warehouse_code) %>
								</select>
<!-- 					            <select id = "st_warehouse_code"  name = "st_warehouse_code" > -->
<!-- 					              <option value="KRKORE0068">창원물류센타</option> -->
<!-- 					              <option value="KRKORE0126">경기물류센타</option> -->
<!-- 								  <option value="KRKORE0160">거제물류센타</option> -->
<!-- 								  <option value="KRKORE0192">구미물류센타</option> -->
<!-- 					            </select> -->
							</td>							
						</tr>
						<tr> 
							<th>발주번호</th>
							<td>
								<input type="text" name="st_po_no"  id="st_po_no"  style="width:87%" value="" onKeyUp="kepToUpper('st_po_no')" onkeydown="kepEnter()">
							</td>
							<th>입고번호</th>
							<td  width="23%"> 
								<input type="text" name="st_iv_no" id="st_iv_no"  style="width:87%" value="" onKeyUp="kepToUpper('st_iv_no')" onkeydown="kepEnter()">
							</td>
							<th><font color="red"><b>*</b></font>고객사</th>
							<td >
							    <input type="text" class="input_type_text" id="st_buyer_name" name="st_buyer_name" style="width:65%;" value=""  readonly onclick="javascript:doPop('buyer_single');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:87%" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>	
						</tr>
						<tr> 
							<th>송장번호</th>
							<td  width="23%">
								<input type="text" name="st_ik_no"  id="st_ik_no"  style="width:87%" value="" onKeyUp="kepToUpper('st_ik_no')" onkeydown="kepEnter()">
							</td>
							<th>상태</th>
							<td > 
					            <select id = "st_status" name = "st_status"  >
					              <option value="ALL">전체</option>
					              <option value="발주">발주</option>
					              <option value="입고예정">입고예정</option>
					              <option value="분할입고예정">분할입고예정</option>
					              <option value="미입고">미입고</option>
					              <option value="출고예정">출고예정</option>
					              <option value="분할출고예정">분할출고예정</option>
					              <option value="미출고">미출고</option>
					              <option value="출고">출고</option>
					              <option value="분할출고">분할출고</option>
					              <option value="출고전체">출고전체</option>
					              <option value="배송확정">배송확정</option>
					            </select>
							</td>
							<th>협력사</th>
							<td > 
								<input type="text" class="input_type_text" id="st_agent_name" name="st_agent_name"  readonly style="width:65%;" value="" onclick="javascript:doPop('agent_single');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" value=""  style="width:70%" value="">
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
						</tr>
					</tbody>
				</table>
            </div>
             <span style="position:absolute; left:0;"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow"  id="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
				</select>
			</span>
			 <span style="position:absolute; right:0;">
					<select name="st_order_by"  id="st_order_by" style="width: 100px;" >
				        <option value = "1">납품요청일순</option>
				        <option value = "2">고객사순</option>
				        <option value = "3">협력사순</option>
				        <option value = "4">발주번호순</option>
				        <option value = "5">입고번호순</option>
				        <option value = "6">송장번호순</option>
				        <option value = "7">품목코드</option>
				        <option value = "8">보급소</option>
				</select>
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c;height:354px;">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "", "324px");
  				</script>
 				 <p class="paging" id="pageindex"></p>
  			</div>
			<% if(comType.equals("M")){ %>
	  			<!--버튼영역-->  		
	               <div class="btnArea">
	  				<span style="position:absolute; right:0;">
	  					<span class="btn_05 mr04"  ><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
	  				</span>
	  			 </div>
			<%}%>
<!--내용 종료-->	                 

</body>
</html>
