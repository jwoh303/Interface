<%--
**********************************************
* 메뉴 : 입고>입고진행관리>TR입고진행관리
* 화면 : TR입고진행관리
* 기능 : TR 입고에 대한 진행관리 조회
* 프로그램 ID : PG_08_M_004_00
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-6-2
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
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
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
						 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태", SaveName:"STATUS"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"간선", SaveName:"DEST_WAREHOUSE"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"간선여부", SaveName:"HUB_YN"}
							
							,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주번호", SaveName:"PO_NO"} 
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"LEGACY_NO", SaveName:"LEGACY_PO_NO"}
							,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"입고번호", SaveName:"INV_NO"}

							,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"발주일", SaveName:"PO_CREATE_DATE"} 
							,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"납품요청일", SaveName:"RD_DATE"}
							,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"입고예정일", SaveName:"PORS_CD_DATE"} 
							,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"입고일", SaveName:"WMS_GR_DATE"}
							,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",  Format:"Ymd",	Header:"출고예정일",	SaveName:"SCHEDULED_DATE"}

							,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사", SaveName:"BUYER_NAME"} 
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"협력사", SaveName:"AGENT"}
							,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사", SaveName:"AGENT_NAME"}                   

							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준코드", SaveName:"STDCATLG_ID"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드", SaveName:"BUYER_ITEM_NO"} 
							,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품목명", SaveName:"DESCRIPTION"} 
							,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"규격", SaveName:"SPECIFICATION"}
							
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}", 	Header:"발주수량", SaveName:"PO_QTY"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}", 	Header:"납품수량", SaveName:"INV_QTY"} 
							,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	 Type : "Float", Format:"${qtyFormat}", 	Header:"기입고수량", SaveName:"GI_GR_QTY"} 

							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float", Format:"${priceFormat}",	Header:"매입단가", Format:"#,##0", SaveName:"AGENT_PRICE"}
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float", Format:"${priceFormat}",Header:"매입금액", SaveName:"AGENT_ITEM_AMT"} 
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	 Type : "Float", Format:"${priceFormat}", Header:"매출단가", SaveName:"UNIT_PRICE"} 
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	 Type : "Float", Format:"${priceFormat}",Header:"매출금액", SaveName:"ITEM_AMT"}
												
							,{ Align:"Center",	Width:60,	    Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"요청자", SaveName:"ADD_USER_NAME_IMG"} 
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자", SaveName:"ADD_USER_NAME"} 
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자전화번호", SaveName:"ADD_USER_TEL"} 
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자발주번호", SaveName:"POHD_REMARK"} 
							
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}", 	Header:"박스수량",	SaveName:"BOX_QTY"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"차량번호", 	SaveName:"CAR_NO"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"차량기사",	 SaveName:"CAR_PERSON_NAME"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"연락처",	SaveName:"CAR_PERSON_TEL"}
							
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"배송처",	SaveName:"DELY_TO_LOCATION_IMG"}
							,{ Align:"Left",	Width:290,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"배송처",	SaveName:"DELY_TO_LOCATION"}
							,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고",	SaveName:"PO_REMARK_IMG"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"비고", SaveName:"PO_REMARK"} 
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"비고", SaveName:"BUYER"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"비고", SaveName:"DOC_TYPE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"비고", SaveName:"MASTER_ITEM"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"비고", SaveName:"IMG_NO"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"비고", SaveName:"BYIT_COMORG_CODE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"비고", SaveName:"CONTRACT_NO"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"비고", SaveName:"CONTRACT_SEQ"}	
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"WMS_GR_QTY"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"WMS_IVK_QTY"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"POHD_REMARK"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"GUBUN"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"DOC_TEXT"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"STATUS_TEXT"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"AGENT_TEL_NO"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"AGENT_NAME_ORG"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(0, remarkOff);
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(2, LocationOn);
	mySheet.SetImageList(3, addUserName);

	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL','');
 
	//하이퍼링크 설정
	setLinkCol(mySheet, "INV_NO");	//입고번호
	setLinkCol(mySheet, "LEGACY_PO_NO");
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "DELY_TO_LOCATION_IMG");
	setLinkCol(mySheet, "PO_REMARK_IMG");
	setLinkCol(mySheet, "ADD_USER_NAME_IMG");
	setLinkCol(mySheet, "PO_NO");
	setLinkCol(mySheet, "BUYER_NAME");
	setLinkCol(mySheet, "AGENT_NAME");
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_to_date").val( kepToMonthAdd("1","P"));
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	
	
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크


	switch (str) {
	case "search":	 // 조회
		
		if(kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val())== false){
			return;
		}
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
			alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n3개월 이상의 데이타는 S/R 요청 바랍니다.");
			return ;
		}
		//센터예정일 일때만 적용 (센터입고일 일때는 적용x)
		if($("#st_date_type").val() == "RD_DATE"){
			//고객사 또는 협력사 조건 필수값 , 대신 품목명 입력하면 고객사,협력사입력 없어도 됨
			if($("#st_buyer_name").val() == "" && $("#st_agent_name").val() == "" && $("#st_description").val() == "" && $("#st_status").val() != "5"){
				alert("고객사 또는 협력사 또는 품목명을 입력하여 주십시요.");
				return;
			}
		}
		
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/wmgr/getMasterWmGrTrWarhsngProgressManageList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepToMonthAdd("1","P"));
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		break;


	case "excelDown": // 엑셀다운로드
		if(kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val())== false){
			return;
		}
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
			alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n3개월 이상의 데이타는 S/R 요청 바랍니다.");
			return ;
		}
		//고객사 또는 협력사 조건 필수값 , 대신 품목명 입력하면 고객사,협력사입력 없어도 됨
		if($("#st_buyer_name").val() == "" && $("#st_agent_name").val() == "" && $("#st_description").val() == "" && $("#st_status").val() != "5"){
			alert("고객사 또는 협력사 또는 품목명을 입력하여 주십시요.");
			return;
		}
	    $("#pageflag").val('0');
		var param = {FileName:"TR입고진행관리.xlsx",DownCols:"BUYER_NAME|PO_NO|INV_NO|STDCATLG_ID|PO_CREATE_DATE|WMS_GR_DATE|PO_QTY|STATUS|DEST_WAREHOUSE|LEGACY_PO_NO|PORS_CD_DATE|BUYER_ITEM_NO|RD_DATE|ADD_USER_NAME|ADD_USER_TEL|INV_QTY|DESCRIPTION|SPECIFICATION|AGENT_NAME|GI_GR_QTY|DELY_TO_LOCATION|PO_REMARK"};
		kepDownExcel(document.searchCondition ,mySheet , "/wmgr/excelMasterWmGrTrWarhsngProgressManageList.do", param);
		$("#pageflag").val('1');
		break;
	case "seller":
		openSearchPopup('/coco/showCommonCoCoCompanyPop.do','?com_type=S&multi_flag=M&safety_flag=undefined&save_flag=undefined', "500,500,no"); 
		popupSel = "agent_ban";
		break;
	}
}
function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

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
	for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++)
	{
		if(mySheet.GetCellValue(i,"DELY_TO_LOCATION")!="")
		{
			mySheet.SetCellValue(i, 'DELY_TO_LOCATION_IMG', remarkOn);
		}
		else{
			mySheet.SetCellValue(i, 'DELY_TO_LOCATION_IMG', remarkOff);
		}
		if(mySheet.GetCellValue(i,"PO_REMARK")!="")
		{
			mySheet.SetCellValue(i, 'PO_REMARK_IMG', remarkOn);
		}
		else{
			mySheet.SetCellValue(i, 'PO_REMARK_IMG', remarkOff);
		}
		if(mySheet.GetCellValue(i,"ADD_USER_NAME")!="")
		{
			mySheet.SetCellValue(i, 'ADD_USER_NAME_IMG', remarkOn);
		}else{
			mySheet.SetCellValue(i, 'ADD_USER_NAME_IMG', remarkOff);
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
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrTrWarhsngProgressManageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
	case "buyer_multi": // 고객사 M

	    var ware_house_code = document.searchCondition.st_warehouse_code.value;
	    var st_from_date = document.searchCondition.st_from_date.value;
	    var st_to_date = document.searchCondition.st_to_date.value;
	    var st_date_flag = "RD";
	    openSearchPopup('/wmco/showMasterWmCoMbrcmpyPop.do','?st_warehouse_code='+ware_house_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date+'&st_date_flag='+st_date_flag, "500,500,no"); 
        popupSel = "buyer_multi";
        break;	
	case "agent_single": // 협력사 M
		openSearchPopup('/coco/showCommonCoCoCompanyPop.do','?com_type=S&multi_flag=M&safety_flag=undefined&save_flag=undefined', "500,500,no"); 
		popupSel = "agent_single";
		break;	
	case "buyer_s": // 고객사 M
		//var st_warehouse_code = "<%=CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"") %>";	
		//openSearchPopup("/wmdl/showMasterDlCommpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
		
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
        popupSel = "buyer_s";
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
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}
	else if(column == 'PO_NO')
	{
		if(mySheet.GetCellValue(Row,'PO_NO')!=""){
			
			var buyer = mySheet.GetCellValue(Row,'BUYER');
	    	var po_no = mySheet.GetCellValue(Row,'PO_NO');
	  
	    	openSearchPopup('/wmgr/showMasterWmGrTrOrderGrRegPop.do','?BUYER='+buyer+'&PO_NO='+po_no, "900,500,no"); 
			popupSel = "masterWmGrTrOrderManagerPop";
		}
	}else if (column == 'INV_NO') { 
		if(mySheet.GetCellValue(Row, 'INV_NO') !=""){
			var BUYER = mySheet.GetCellValue(Row,"BUYER"); //BUYER
			var PO_NO = mySheet.GetCellValue(Row,"PO_NO"); //발주번호
			var INV_NO = mySheet.GetCellValue(Row,"INV_NO"); //입고번호
			var HUB_YN = mySheet.GetCellValue(Row,"HUB_YN"); //간선여부
			var STATUS = ""; //구분

			if("입고완료" == mySheet.GetCellValue(Row,"STATUS")){
				STATUS = "W";
			}else{
				if(HUB_YN == "Y" && mySheet.GetCellValue(Row,"WMS_IVK_QTY") == 0 && mySheet.GetCellValue(Row,"WMS_GR_QTY") == 0){ // 간선대상 중 간선출고 안되고 최종센터의 입고도 안되면 삭제 가능
					STATUS = "W";	
				}else{
					STATUS = "X";	
				}
			}
			
			openSearchPopup('/wmgr/showMasterWmGrWarehousingPop.do','?PO_NO='+PO_NO+'&INV_NO='+INV_NO+'&STATUS='+STATUS+'&BUYER='+BUYER+'&HUB_YN='+HUB_YN, "900,500,no");
			
			popupSel = "masterWmGrWarehousingPop";
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
			var PO_REMARK = mySheet.GetCellValue(Row,"POHD_REMARK"); //비고
			var BUYER = mySheet.GetCellValue(Row,"BUYER"); //BUYER
			var DOC_TEXT =mySheet.GetCellValue(Row,'DOC_TEXT');
			var DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
			openSearchPopup('/wmgr/showMasterWmGrLegacyNoPop.do','?BUYER_NAME='+BUYER_NAME+'&LEGACY_PO_NO='+LEGACY_PO_NO+'&STATUS='+STATUS+'&ADD_USER_NAME='+ADD_USER_NAME+'&PO_REMARK='+PO_REMARK+'&BUYER='+BUYER+'&DOC_TEXT='+DOC_TEXT+'&DELY_TO_LOCATION='+DELY_TO_LOCATION, "1300,500,no"); 
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
			openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ, "800,260,no"); 
		}
	}else if(column=="DELY_TO_LOCATION_IMG" )
	{
		if(mySheet.GetCellValue(Row,'DELY_TO_LOCATION')!="")
		{
			var DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
			openSearchPopup('/wmco/showMasterWmCoDlvryPop.do','?DELY_TO_LOCATION='+DELY_TO_LOCATION, "500,210,no"); 
			popupSel = "masterWmCoDlvryPop";
		}
	}else if(column=="PO_REMARK_IMG" )
	{
		if(mySheet.GetCellValue(Row,'PO_REMARK')!="")
		{
			var PO_REMARK = mySheet.GetCellValue(Row,'PO_REMARK');
			openSearchPopup('/common/remarkBtoAPop.do','?st_btoa_remark='+PO_REMARK, "500,220,no"); 
			popupSel = "remarkBtoA";
		}		
	}else if(column=="ADD_USER_NAME_IMG" )
	{
		if(mySheet.GetCellValue(Row,'ADD_USER_NAME')!="")
		{
			var st_ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME');
			var st_ADD_USER_TEL = mySheet.GetCellValue(Row,'ADD_USER_TEL');
			var st_POHD_REMARK = mySheet.GetCellValue(Row,'POHD_REMARK');
			openSearchPopup('/wmco/showMasterWmCoRequestPop.do','?st_ADD_USER_NAME='+st_ADD_USER_NAME+'&st_ADD_USER_TEL='+st_ADD_USER_TEL+'&st_POHD_REMARK='+st_POHD_REMARK, "500,215,no"); 
			popupSel = "masterWmCoRequestPop.jsp";
		}		
	}else 	if(column == 'AGENT_NAME'){
		if(mySheet.GetCellValue(Row,'AGENT_NAME')!=""){
			
			 var com_code = mySheet.GetCellValue(Row,'AGENT');
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
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
	}else 	if (popupSel == "buyer_multi") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}else if(popupSel == "agent_ban"){
	
		var buyer = 'KRKORE0127';
		var url ="/coco/showReportViewer.do";
		window.open( url +""+"?fileName=RD_08_M_001_00&param=["+value1+"]["+buyer+"]", "setWmsTrSheetMRD", "width=770,height=800,resizable=YES,top=0,left=0");
	} 
	
	if (popupSel == "buyer_s") {	// 다중 고객사
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
			<h3>TR입고진행관리</h3>
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
			
            	<table  class="cont_t_list01" >
					<caption>TR입고진행관리</caption>
					<colgroup>
							<col width="8%" />
							<col width="17%" />
							<col width="8%" />
							<col width="17%" />
							<col width="8%" />
							<col width="17%" />
							<col width="8%" />
							<col width="17%" />
					</colgroup>
						
					<tbody>
						<tr> 
							<th>
								<select name="st_date_type" id="st_date_type" class = "TitSelect">
									<option value="RD_DATE">센터예정일</option>
									<option value="WMS_GR_DATE">센터입고일</option>
								</select>
							
							</th>
							<td colspan="3">
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
											<a href="javascript:kepCalendar('st_from_date')"></a> -
										<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
											<a href="javascript:kepCalendar('st_to_date')"></a>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>														
							</td>
							<th>물류센터</th>
							<td>
								<select id="st_warehouse_code" name="st_warehouse_code" style="width:100%;height:20px" 	<%=whAdmin.equals("Y") ? "" : "disabled"%>>
								<%
						 			Map<String, String> _map = new HashMap<String, String>();
						 			_map.put("BUYER",buyer);
						 			_map.put("USERID",userid);
						 			_map.put("whAdmin",whAdmin);
								%>
								<%= CommonUtil.getCodeComboQueryIdList("common.getWareHouseIdSchList","",_map,st_warehouse_code) %>
								</select>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
				  										
							<th><font color="red"><b>*</b></font>고객사</th>
							<td> 
							    <input type="text" class="input_type_text" id="st_buyer_name" name="st_buyer_name" style="width:58%;" value=""  readonly onclick="javascript:doPop('buyer_s');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer_multi');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<th>발주번호</th>
							<td>
								<input type="text" name="st_po_no"  id="st_po_no"  style="width:58%" value=""  onKeyUp="kepToUpper(id)" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							</td>
							<th>입고번호</th>
							<td>  
								<input type="text" name="st_inv_no" id="st_inv_no"  style="width:58%" value=""  onKeyUp="kepToUpper(id)" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							</td>
							<th><font color="red"><b>*</b></font>품목명</th>
							<td>
								<input type="text" name="st_description" id="st_description" value="" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							</td>
					    </tr>
					    <tr>
							<th><font color="red"><b>*</b></font>협력사</th>
							<td >  
								<input type="text" class="input_type_text" id="st_agent_name" name="st_agent_name"  readonly style="width:58%;" value="" onclick="javascript:doPop('agent_single');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" value=""  style="width:80%" value="">
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
 
							<th>표준코드</th>
							<td  >
								<input type="text" name="st_stdcatlg_id"  id="st_stdcatlg_id"  style="width:58%" value=""  onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							</td>
							<th>품목코드</th>
							<td  >  
								<input type="text" name="st_buyer_item_no"   id="st_buyer_item_no"   style="width:58%" value=""  onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							</td>
							<th>상태</th>
							<td  >  
								<select name="st_status" id="st_status" >
									<option value="ALL" selected>전체</option>
									<option value="1">발주</option>
									<option value="2">입고예정</option>
									<option value="3">분할입고예정</option>
									<option value="4">입고완료</option>
									<option value="5">간선입고완료</option>
								</select>
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
						<option value="1" selected>센터예정순</option>
						<option value="2">고객사순</option>
						<option value="3">협력사순</option>
						<option value="4">발주번호순</option>
						<option value="5">입고번호순</option>
						<option value="6">표준코드</option>
						<option value="7">품목코드</option>
						<option value="8">품목명</option>
				</select>
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c;height:354px;">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "", "354px");
  				</script>
 				 <p class="paging" id="pageindex"></p>
  			</div>

  			<!--버튼영역-->  			<br/><br/>
               <div class="btnArea">
  	          	<span style="position:absolute; left:0;">
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  				
  				<span style="position:absolute; right:0;">
  					<span class="btn_06 mr04"><a href="javascript:doAction('seller');">수기거래명세서</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
