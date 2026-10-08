<%--
**********************************************
* 메뉴 : 
* 화면 : 발주생성
* 기능 : 상품을 검색하여 선택하고, 납품계획, 배송처, 필요에 따라 제조모집단, 비고등을 입력하고 발주를 생성할 수 있다.
* 프로그램 ID : PG_07_M_002_01
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>

<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var com_code = "${sessionInfo.comCode}";
var userId = "${sessionInfo.userId}";
var userNm = "${sessionInfo.userNameLoc}";
var delyToLocation = "${sessionInfo.delyToLocationName}";
var comType = "${param.st_com_type}";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:false}, 
	    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 320, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 190, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "AGENT_NAME",		Header : "협력사",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "BUYER",		Header : "고객사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "BELOW_COMORG_CODE",		Header : "요청공장",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "CONTRACT_NO",		Header : "계약번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "CONTRACT_SEQ",		Header : "계약순번",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "AGENT",		Header : "협력사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden :true}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	var user = "";
	
	var initsheet2 = {};
	initsheet2.HeaderMode = {			Sort : 0,			ColMove : 1,			ColResize : 1		};
	
	if(com_code == "KRKORE0001"){
		initsheet2.Cols = [ 
					{ Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}	// 0
					,{ Align:"Center",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}	// 1
					,{ Align:"Center",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo", "ComboCode" : "679312|JEJOA|LHM6821|LHM6821|EUNHOJEE","ComboText" : "정태호|조평래|이현민|권창규|지은호",	Header:"발주자",	SaveName:"PURCHASER_ID" ,	BackColor:"${optColor}"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Number",	Header:"수량",	SaveName:"ITEM_QTY"}	
					,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}	// 2
					,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"발주일",	SaveName:"PO_CREATE_DATE"}
					,{ Align:"Center",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",	Header:"납품요청일",	SaveName:"IV_DATE" , KeyField:true, ToolTip:true}
					,{ Align:"Center",	Width:80,	Edit:false,	Hidden:true,	Type:"Text",	Header:"요청일",	SaveName:"RD_DATE_ALL"}
					,{ Align:"Center",	Width:80,	Edit:false,	Hidden:true,	Type:"Text",	Header:"요청수량",	SaveName:"DS_QTY_ALL"}
					,{ Align:"Center",	Width:150,	Edit:true,	Hidden:false,	Type:"Text",	Header:"배송처",	SaveName:"DELY_TO_LOCATION" , BackColor:"${optColor}" , KeyField:true}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"협력사ID",	SaveName:"AGENT"}	// 8
					,{ Align:"Center",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME", BackColor:"${optColor}" , KeyField:true}	// 3
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"제조모집단",	SaveName:"REF_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Image",	Header:"제조모집단",	SaveName:"REF_NO_IMG"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"제조사",	SaveName:"REF_MAKER"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"비고",	SaveName:"REMARK"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Image",	Header:"비고",	SaveName:"REMARK_IMG"}
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"고객사",	SaveName:"BUYER"}	// 4
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"발주자",	SaveName:"BELOW_COMORG_CODE"}	// 5
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"계약번호",	SaveName:"CONTRACT_NO"}	// 6
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"계약순번",	SaveName:"CONTRACT_SEQ"}	// 7
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"단가",	SaveName:"UNIT_PRICE"}	// 9
					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"LIST_PRICE",	SaveName:"LIST_PRICE"}	// 10
	];
	}else{
		initsheet2.Cols = [ 
						{ Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
						,{ Align:"Center",	Width:60,	Edit : true,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}	// 0
						,{ Align:"Center",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}	// 1
 	 					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"발주자ID",	SaveName:"PURCHASER_ID"}
 	 					,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"발주자",	SaveName:"PURCHASER_NAME"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Number",	Header:"수량",	SaveName:"ITEM_QTY"}	
						,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}	// 2
						,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"발주일",	SaveName:"PO_CREATE_DATE"}
						,{ Align:"Center",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",	Header:"납품요청일",	SaveName:"IV_DATE" , BackColor:"${optColor}", ToolTip:true}
						,{ Align:"Center",	Width:80,	Edit:false,	Hidden:true,	Type:"Text",	Header:"요청일",	SaveName:"RD_DATE_ALL"}
						,{ Align:"Center",	Width:80,	Edit:false,	Hidden:true,	Type:"Text",	Header:"요청수량",	SaveName:"DS_QTY_ALL"}
						,{ Align:"Center",	Width:150,	Edit:true,	Hidden:false,	Type:"Text",	Header:"배송처",	SaveName:"DELY_TO_LOCATION" , BackColor:"${optColor}"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"협력사ID",	SaveName:"AGENT"}	// 8
						,{ Align:"Center",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME" , BackColor:"${optColor}"}	// 3
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"제조모집단",	SaveName:"REF_NO"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Image",	Header:"제조모집단",	SaveName:"REF_NO_IMG"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"제조사",	SaveName:"REF_MAKER"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"비고",	SaveName:"REMARK"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Image",	Header:"비고",	SaveName:"REMARK_IMG"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"고객사",	SaveName:"BUYER"}	// 4
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"발주자",	SaveName:"BELOW_COMORG_CODE"}	// 5
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"계약번호",	SaveName:"CONTRACT_NO"}	// 6
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"계약순번",	SaveName:"CONTRACT_SEQ"}	// 7
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"단가",	SaveName:"UNIT_PRICE"}	// 9
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"LIST_PRICE",	SaveName:"LIST_PRICE"}	// 10
		];
	}
	
	IBS_InitSheet(mySheet2, initsheet2,pagingMode);
	
	//비고이미지설정
	mySheet2.SetImageList(1, remarkOn);
	mySheet2.SetImageList(0, remarkOff);

	
	//하이퍼링크 설정
	setLinkCol(mySheet2, "IV_DATE");
 	setLinkCol(mySheet2, "DELY_TO_LOCATION");
 	setLinkCol(mySheet2, "AGENT_NAME");
 	setLinkCol(mySheet2, "REF_NO_IMG");
 	setLinkCol(mySheet2, "REMARK_IMG");

 	if(comType == 'buyer'){
	 	$("#st_req_buyer").val("${sessionInfo.comCode}");
	}
// 	kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsOrderCreationPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	
	switch (str) {
		case "search": //조회
			current_page = -1;
		
			var desc_spec = document.forms.searchCondition.st_desc_spec.value;
			var buyer_item_no = document.forms.searchCondition.st_buyer_item_no.value;

			if(desc_spec=="" && buyer_item_no=="") {
				alert("품목명/규격이나 품목코드를 입력하여 주십시오.");
				return ;
			}
		
			kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsOrderCreationPop.do" , pagingMode );
			break;
		case "setPoItem": //이동
			current_page = -1;
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow     = selectedGrid.split("|");
			var totRow2 = mySheet2.RowCount();

			// 선택된 항목 유무 체크
			if (selectedGrid.length == 0) {
				alert("선택된 항목이 없습니다.");
				return;
			}
			
			var st_query_list ="";
			var st_query_list2 ="";
			for(i=0; i<arrRow.length; i++){
				var catlg_buyer		= mySheet.GetCellValue(arrRow[i],"BUYER");
				var contract_no		= mySheet.GetCellValue(arrRow[i],"CONTRACT_NO");
				var contract_seq	= mySheet.GetCellValue(arrRow[i],"CONTRACT_SEQ");
				st_query_list += "'"+catlg_buyer+contract_no+contract_seq+"'";

				if(i<arrRow.length-1) {
					st_query_list += ",";
				}
			}
			$("#st_query_list").val(st_query_list);
			kepSearch(document.searchCondition ,  mySheet2 , "/mpds/moveMasterMpDsOrderCreationPop.do" , pagingMode );
			break;
		case "delPoItem": //취소
			current_page = -1;
			var selectedGrid2 = mySheet2.FindCheckedRow("SELECTED");
			var arrRow2     = selectedGrid2.split("|");

			for(i=0; i<arrRow2.length; i++){
				mySheet2.RowDelete(arrRow2[i], 0);
			}
			break;
		case "setPoCreate": //주문
			current_page = -1;
			var selectedGrid2 = mySheet2.FindCheckedRow("SELECTED");
			var arrRow2     = selectedGrid2.split("|");

			// 선택된 항목 유무 체크
			if (selectedGrid2.length == 0) {
				alert("선택된 항목이 없습니다.");
				return;
			}

			for(i=0; i<arrRow2.length; i++){
				var item_qty		= mySheet2.GetCellValue(arrRow2[i],"ITEM_QTY");
				var create_date = mySheet2.GetCellValue(arrRow2[i],"PO_CREATE_DATE");
				var dely_to_location = mySheet2.GetCellValue(arrRow2[i],"DELY_TO_LOCATION");
				if(isEmpty(item_qty)) {
					alert("수량을 입력하여 주십시오.");
					return;
				}
				if(isEmpty(create_date)) {
					alert("발주일을 선택하여 주십시오.");
					return;
				}
				if(isEmpty(dely_to_location)) {
					alert("배송처를 선택하여 주십시오.");
					return;
				}
			}
			
			

			if(confirm("주문하시겠습니까?")) {
				kepSave(document.searchCondition ,  mySheet2 , "/mpds/insertMasterMpDsOrderCreationPop.do" , "SELECTED" );
			}
			
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
	}

}



function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if(mySheet.RowCount() <= 0) return;
	
	if (msg != "") {
		alert(msg);
	}

	mySheet2.RemoveAll();
	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	var totRow = mySheet2.RowCount();
	if(totRow <= 0) return;
	
	if (msg != "") {
		alert(msg);
	}
	for(var i=1; i<=totRow;i++){
		mySheet2.SetCellValue(i,"PO_CREATE_DATE", kepGetNowTimeStr('YYYYMMDD',''));		
		mySheet2.SetCellValue(i,"IV_DATE", "납품계획을 입력 바랍니다.");
		
		if(com_code != "KRKORE0001"){	//고객사의 경우 해당 고객사의 주소를 셋팅
			mySheet2.SetCellValue(i,"DELY_TO_LOCATION", delyToLocation);
			mySheet2.SetCellValue(i,"PURCHASER_ID", userId);
			mySheet2.SetCellValue(i,"PURCHASER_NAME", userNm);
		
		}
		
		
	}
}

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsOrderCreationPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트(Grid1)
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;
	
	if (column == "BUYER_NAME" ){ 
			kepConfirm();
	}
	return;
}
//그리드 셀클릭 이벤트(Grid2)
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	grbRow = Row;
	
	if (column == "ITEM_QTY" ){ 
			alert('납품계획을 입력하여 주시면, 수량이 자동 입력됩니다.');
			
	}else if(column == "IV_DATE"){ 
		popupSel = "masterMpDsClosingDateChoicePop";
		openSearchPopup('/mpds/showMasterMpDsClosingDateChoicePop.do','','400,300,no');
		
	}else if(column == "DELY_TO_LOCATION"){ 	//배송처 선택
		popupSel = "commonMpIvDlvryChoicePop";
// 		var st_buyer_code = mySheet2.GetCellValue(Row,'BUYER');
		openSearchPopup('/mpiv/getCommonMpIvDlvryChoicePop.do','?st_buyer_code=ALL','500,500,no');

	}else if(column == "AGENT_NAME"){ 	//협력사 선택
		openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=S&MULTI=N','500,466,no');
		popupSel = "agent";

	}else if(column == "REF_NO_IMG"){ 	//
		popupSel = "remarkReturnRefNoPop";
		var remark = mySheet2.GetCellValue(Row, "REF_NO");
		openSearchPopup('/common/remarkReturn2Pop.do','?st_return_remark='+remark,'500,230,no');// 제조모집단

	}else if(column == "REMARK_IMG"){ 	//
		popupSel = "remarkReturn2Pop";
		var remark = mySheet2.GetCellValue(Row, "REMARK");
		openSearchPopup("/common/remarkReturn2Pop.do", "?st_return_remark="+remark, "500,230,no");// 비고

	}

	return;
}

// 헤더 더블클릭시 복사
function mySheet2_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	var checkRows = mySheet2.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	if (mySheet2.ColSaveName(Col) == "IV_DATE"){ 
		var iv_date = mySheet2.GetCellValue(arrRow[0], "IV_DATE");
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet2.SetCellValue(arrRow[idx], "IV_DATE", iv_date);
		}
	}else if(mySheet2.ColSaveName(Col) == "DELY_TO_LOCATION"){
		var dely_to_location = mySheet2.GetCellValue(arrRow[0], "DELY_TO_LOCATION");
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet2.SetCellValue(arrRow[idx], "DELY_TO_LOCATION", dely_to_location);
		}
	}else if(mySheet2.ColSaveName(Col) == "AGENT_NAME"){
		var agent = mySheet2.GetCellValue(arrRow[0], "AGENT");
		var agent_name = mySheet2.GetCellValue(arrRow[0], "AGENT_NAME");
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet2.SetCellValue(arrRow[idx], "AGENT", agent);
			mySheet2.SetCellValue(arrRow[idx], "AGENT_NAME", agent_name);
		}
	}
}

function mySheet2_OnSaveEnd(code, msg) {
	loader_obj("N");
	
	if (code > 0){
		alert("주문완료.");
		mySheet2.RemoveAll();
		//저장 성공시 창닫기
// 		doAction('search');
		kepConfirm();
		return;
	} else {
		alert("주문에 실패하였습니다.\n\n\관리자에게 문의하여 주시길 바랍니다.");
		return;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3){

// 	alert(grbRow +":::"+value1+":::"+value2+":::"+value3);
	if (popupSel == "masterMpDsClosingDateChoicePop") {	// 납품계획
		mySheet2.SetCellValue(grbRow, 'RD_DATE_ALL', value1); // 요청일
		mySheet2.SetCellValue(grbRow, 'DS_QTY_ALL', value2); // 요청수량
		mySheet2.SetCellValue(grbRow, 'ITEM_QTY', value3); // 수량
		
		var ivStr = "";
		if(value1.indexOf("@@") > -1){
			var ivdate = value1.split("@@");
			var ivqty = value2.split("@@");
			for(var idx=0; idx<ivdate.length; idx++){
				ivStr += "날짜 : " + ivdate[idx] + " , 수량 : "+ivqty[idx] +"\n";
			}
		}else{
			ivStr = "날짜 : " + value1 + " , 수량 : "+ value2;
		}
			
		mySheet2.SetCellValue(grbRow, 'IV_DATE', ivStr); // 납품요청일
		
	}else if (popupSel == "commonMpIvDlvryChoicePop") {	// 배송처팝업
		mySheet2.SetCellValue(grbRow, 'DELY_TO_LOCATION', value1);
	
	}else if (popupSel == "agent") {	// 협력사
		mySheet2.SetCellValue(grbRow, 'AGENT', value1);
		mySheet2.SetCellValue(grbRow, 'AGENT_NAME', value2);

	}else if (popupSel == "remarkReturnRefNoPop") {	//
		mySheet2.SetCellValue(grbRow, 'REF_NO', value1);
		mySheet2.SetCellValue(grbRow, 'REF_NO_IMG', (value1!="")? remarkOn : remarkOff);

	}else if (popupSel == "remarkReturn2Pop") {	// 비고
		mySheet2.SetCellValue(grbRow, 'REMARK', value1);
		mySheet2.SetCellValue(grbRow, 'REMARK_IMG', (value1!="")? remarkOn : remarkOff);

	}
	
	grbRow="";	//초기화
}


//확인
function kepConfirm()
{ 
 var value1 = mySheet.GetCellValue(grbRow, "BUYER")+"@";
 var value2 = mySheet.GetCellValue(grbRow, "BUYER_NAME");
 
 opener.setPopupReturn(value1,value2);
 
 this.close();
}
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_com_code"  name="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" id="st_byca_comorg_code"  name="st_byca_comorg_code" value="${sessionInfo.bycaComorgCode}">
	<input type="hidden" id="st_com_type"  name="st_com_type" value="${param.st_com_type}">
	<input type="hidden" id="st_query_list"	 name="st_query_list"		value ="">
	<input type="hidden" id="st_po_query_list"	 name="st_po_query_list"	value ="">
	
	<div id="popWrapper" style="height:644px;">
    	<div id="popHeader">
        	<h1 class="title">발주생성</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
            	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
            </div>
            <!--조회영역-->
        	<div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
						</colgroup>
						<tbody>
							<tr >
								<th>카탈로그 검색</th>
								<td>
									<c:if test ="${param.st_com_type eq 'buyer'}" >
										<c:if test="${sessionInfo.comCode eq 'KRDONG0732'}">
												<select id="st_req_buyer" name="st_req_buyer">
													<option value="KRDONG0732" >(주)동부한농 안성공장</option>
												</select>
										</c:if>
										<c:if test="${sessionInfo.comCode ne 'KRDONG0732'}">
											<select id="st_req_buyer" name="st_req_buyer">
												<option value="ALL">전체</option>
												<option value="KRDONG0110" >(주)동부한농 인천공장</option>
												<option value="KRDONG0107" >(주)동부한농 구미공장</option>
												<option value="KRDONG0128" >(주)동부아그로텍 전주공장</option>
											</select>									
										</c:if>
									</c:if>
									<c:if test ="${param.st_com_type ne 'buyer'}" >
										<c:if test="${sessionInfo.comCode eq 'KRKORE0002'}">
												<select id="st_req_buyer" name="st_req_buyer">
													<option value="ALL">전체</option>
													<option value="KRDONG0732" >(주)동부한농 안성공장</option>
												</select>
										</c:if>
										<c:if test="${sessionInfo.comCode ne 'KRKORE0002'}">
												<select id="st_req_buyer" name="st_req_buyer">
													<option value="ALL">전체</option>
													<option value="KRDONG0110" >(주)동부한농 인천공장</option>
													<option value="KRDONG0107" >(주)동부한농 구미공장</option>
													<option value="KRDONG0128" >(주)동부아그로텍 전주공장</option>
													<option value="KRDONG0732" >(주)동부한농 안성공장</option>
												</select>
										</c:if>
									</c:if>
								</td>
								<th>품목코드</th>
								<td><input type="text" name="st_buyer_item_no" style="width:95%" value="" onKeyDown="kepEnter()"></td>
							</tr>
							<tr >
								<th>품목명/규격</th>
								<td align="center" ><input type="text" name="st_desc_spec" style="width:95%;ime-mode:active" value="" onKeyDown="kepEnter()"></td>
								<th>협력사</th>
								<td align="center" ><input type="text" name="st_agent_name" style="width:95%;ime-mode:active" value="" onKeyDown="kepEnter()"></td>
							</tr>
					</tbody>
				</table>
            </div>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "100%", "150px");
				</script>
			</div>
			<div id="pageindex"></div>
			
 			<table align="center">
				<tr>
					<td height="50" >
  					<a href="javascript:doAction('setPoItem');"><img src="/resources/images/arrow_move.gif" border="0"></a>&nbsp;&nbsp;&nbsp;
  					<a href="javascript:doAction('delPoItem');"><img src="/resources/images/arrow_cancel.gif"  border="0"></a>
					</td>
				</tr>
			</table>
			<c:if test="${sessionInfo.comCode eq 'KRKORE0001'}">
				<table width="900" border="0" cellspacing="0" cellpadding="0" height="1" bgcolor="#60A7E6">
					<tr>
						<td bgcolor="#FFFFFF"><b>요청 공장 </b>: 
				  			<input class="Noborder" type="radio" name="st_buyer_code" value="KRDONG0107" checked>주식회사 동부하이텍 구미공장 
							<input class="Noborder" type="radio" name="st_buyer_code" value="KRDONG0110">주식회사 동부하이텍 인천공장
							<input class="Noborder" type="radio" name="st_buyer_code" value="KRDONG0128">(주)동부아그로텍 전주공장
							<input class="Noborder" type="radio" name="st_buyer_code" value="KRDONG0732">동부팜한농 (주) 안성공장  <!-- SM000010  --> 
						</td>
					</tr>
				</table>		
			</c:if>	
			<c:if test="${sessionInfo.comCode ne 'KRKORE0001'}">
				<table width="900" border="0" cellspacing="0" cellpadding="0" height="1" bgcolor="#60A7E6">
					<tr>
						<td bgcolor="#FFFFFF"><b>요청 공장 </b>: 
				  			<input type="hidden" name="st_buyer_code" value="${sessionInfo.comCode}" /> 
						</td>
					</tr>
				</table>		
			</c:if>	
			<div style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet2", "100%", "150px");
  				</script>
			</div>
			
		</div>	
        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('setPoCreate')">주문</a></span>
			</span>
       </div>
        
    </div>
</form> 
</body>
</html>
