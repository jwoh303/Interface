<%--
**********************************************
* 메뉴 : 주문관리>협력사 업무대행
* 화면 : 협력사 업무대행
* 기능 : 주문목록을 보여주고 운영사가 협력사의 업무를 대행할 수 있게 한다.
* 프로그램 ID : PG_07_M_001_00
* 담당자 : 개발3 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String st_user_id = _sessionInfo.getUserId();

//필드추가 권한여부
boolean getRoleYn = CommonUtil.getCodeCheckReturn("M175",st_user_id);
%>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

var today = kepGetNowTimeStr("YYYYMMDD","");
var fromDate = kepToDateAdd("7","M","noslash");
var toDate = kepToDateAdd("7","P","noslash");

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};	
	initsheet.Cols = [ 
					 { Align:"Center",	SaveName:"PO_STATUS_NM", 	Header:"진행상태", 		Type:"Text", Width:80,	Edit:false}
					,{ Align:"Left",	SaveName:"BUYER_NAME", 		Header:"고객사명", 		Type:"Text", Width:130, Edit:false}
					,{ Align:"Center",	SaveName:"BUYER_ITEM_NO", 	Header:"품목코드", 		Type:"Text", Width:100, Edit:false}
					,{ Align:"Left",	SaveName:"DESCRIPTION", 	Header:"품목명", 		Type:"Text", Width:150, Edit:false}
					,{ Align:"Center",	SaveName:"PO_NO", 			Header:"발주번호", 		Type:"Text", Width:100, Edit:false}
<%if(getRoleYn== false){ %>	,{ Align:"Right",	SaveName:"UNIT_PRICE", 		Header:"단가", 			Type:"Float",	 Format:"${priceFormat}",	 Width:80, 	Edit:false} <%}%>
					,{ Align:"Right",	SaveName:"ITEM_QTY", 		Header:"발주수량", 		Type:"Float",	 Format:"${priceFormat}",	 Width:80, 	Edit:false}
					,{ Align:"Right",	SaveName:"REMAIN_QTY", 		Header:"납품잔량", 		Type:"Float",	 Format:"${priceFormat}",	 Width:80, 	Edit:false}
					,{ Align:"Center",	SaveName:"PO_DATE", 		Header:"발주일", 		Type:"Date", Width:80, 	Edit:false}
					,{ Align:"Center",	SaveName:"DS_DATE", 		Header:"납품예정일", 	Type:"Date", Width:80, 	Edit:false}
					,{ Align:"Center",	SaveName:"INVOICE_NO", 		Header:"거래명세서", 	Type:"Text", Width:100, Edit:false}
					,{ Align:"Left",	SaveName:"AGENT_NAME", 		Header:"협력사명", 		Type:"Text", Width:130, Edit:false}
					,{ Align:"Center",	SaveName:"UNIT_MEASURE", 	Header:"단위", 			Type:"Text", Width:60, 	Edit:false}
					,{ Align:"Left",	SaveName:"SPECIFICATION", 	Header:"규격", 			Type:"Text", Width:150, Edit:false}
					,{ Align:"Center",	SaveName:"LEGACY_PO_NO", 	Header:"IF발주번호", 	Type:"Text", Width:120, Edit:false}
<%if(getRoleYn== false){ %>	,{ Align:"Right",	SaveName:"UNIT_SUM", 		Header:"금액", 			Type:"Float",	 Format:"${priceFormat}",  Width:80, 	Edit:false} <%}%>
					,{ Align:"Right",	SaveName:"INV_QTY", 		Header:"납품수량", 		Type:"Float",	 Format:"${priceFormat}",  Width:80,	Edit:false}
					,{ Align:"Center",	SaveName:"RD_DATE", 		Header:"납기요청일", 	Type:"Date", Width:80,	Edit:false}
					,{ Align:"Right",	SaveName:"DELIVERY_QTY", 	Header:"확정수량", 		Type:"Float",	 Format:"${priceFormat}",  Width:80,	Edit:false}
					,{ Align:"Center",	SaveName:"DELIVERY_DATE", 	Header:"확정일", 		Type:"Date", Width:80,	Edit:false}
					,{ Align:"Left",	SaveName:"PARCEL_COM_NM", 		Header:"택배사", 		Type:"Text", Width:130, Edit:false}
					,{ Align:"Left",	SaveName:"PARCEL_INV_NO", 		Header:"운송장번호", 	Type:"Text", Width:100, Edit:false}
					
					,{ SaveName:"BUYER",			Header:"BUYER",	Hidden:true}
					,{ SaveName:"AGENT_USER_ID",	Header:"AGENT_USER_ID",	Hidden:true}
					,{ SaveName:"PROCESS_TYPE",		Header:"PROCESS_TYPE",	Hidden:true}
					,{ SaveName:"TR_BUYER",			Header:"TR_BUYER",	Hidden:true}
					,{ SaveName:"DELY_TO_LOCATION",	Header:"DELY_TO_LOCATION",	Hidden:true}
					,{ SaveName:"ADD_USER_ID",		Header:"ADD_USER_ID",	Hidden:true}
					,{ SaveName:"REF_PR_NO",		Header:"REF_PR_NO",	Hidden:true}
					,{ SaveName:"H_DS_FLAG",		Header:"H_DS_FLAG",	Hidden:true}
					,{ SaveName:"AGENT_CODE",		Header:"AGENT_CODE",	Hidden:true}
					,{ SaveName:"GR_DATE",			Header:"GR_DATE",	Hidden:true}
					,{ SaveName:"COMPLETE_MARK",	Header:"COMPLETE_MARK",	Hidden:true}
					,{ SaveName:"LEGACY_IV_SERIAL",	Header:"LEGACY_IV_SERIAL",	Hidden:true}
					
					,{ SaveName:"PO_STATUS_CD",		Header:"PO_STATUS_CD",	Hidden:true}
					,{ SaveName:"POP_UP_URL",		Header:"POP_UP_URL",	Hidden:true}
					,{ SaveName:"POP_UP_TYPE",		Header:"POP_UP_TYPE",	Hidden:true}
					,{ SaveName:"BUYER_SLG",		Header:"BUYER_SLG",	Hidden:true}
					,{ SaveName:"BFRE_STCK_YN",		Header:"BFRE_STCK_YN",	Hidden:true}
					,{ SaveName:"PX_NO",			Header:"PX_NO",	Hidden:true}
					,{ SaveName:"DO_QTY",		Header:"DO_QTY",	Hidden:true}
					
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "PO_NO");	//발주번호
	setLinkCol(mySheet, "INVOICE_NO");	//거래명세서
	//setLinkCol(mySheet, "DS_DATE");	//납품예정일
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	//$("#st_from_date").val("2014/02/01");
	
	//$("#st_buyer_code").val("KRKOLO0031");	// 코오롱베니트
	//$("#st_buyer_name").val("코오롱베니트 주식회사");	// 코오롱베니트
	
	//$("#st_agent_code").val("KRBEST0003");	// 오피스디포
	//$("#st_agent_name").val("오피스디포");	// 오피스디포
	
}
	
// 기능함수
function doAction(str) {

	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			var buyer_code      = $("#st_buyer_code").val();
			var agent_code      = $("#st_agent_code").val();
			
			if(buyer_code == "" && agent_code == "") {
				alert("고객사 또는 협력사를 선택해 주십시요.");
				return;
			}
			
			
			var diff = kepGetDateDiff('st_from_date','st_to_date','D');
			if (eval(diff)>92){
				alert("3개월내 조회만 가능합니다.");
				return;
			}

			current_page = -1;
			pagingMode = "N";
			kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoSellerWorkProxyList.do" , pagingMode );
			
			break;
		case "excelDown":	 // 엑셀다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			var buyer_code      = $("#st_buyer_code").val();
			var agent_code      = $("#st_agent_code").val();
			
			if(buyer_code == "" && agent_code == "") {
				alert("고객사 또는 협력사를 선택해 주십시요.");
				return;
			}
			
			
			var diff = kepGetDateDiff('st_from_date','st_to_date','D');
			if (eval(diff)>92){
				alert("3개월내 조회만 가능합니다.");
				return;
			}
		    $("#pageflag").val('0');
			var fromTo =  $("#st_from_date").val().replace(/\//gi, "") + "_" + $("#st_to_date").val().replace(/\//gi, "");
		    var param = {FileName:"협력사업무대행_"+fromTo+".xlsx",Merge:1,SheetDesign:1,DownCols:"PO_STATUS_NM|BUYER_NAME|BUYER_ITEM_NO|DESCRIPTION|PO_NO|UNIT_PRICE|ITEM_QTY|REMAIN_QTY|PO_DATE|DS_DATE|INVOICE_NO|AGENT_NAME|UNIT_MEASURE|SPECIFICATION|LEGACY_PO_NO|UNIT_SUM|INV_QTY|RD_DATE|DELIVERY_QTY|DELIVERY_DATE|PARCEL_COM_NM|PARCEL_INV_NO"};
			kepDownExcel(document.searchCondition ,mySheet , "/mpso/excelMasterMpSoSellerWorkProxyList.do", param);
			$("#pageflag").val('1');
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition'); 
			$("#st_buyer_code").val("");
			$("#st_agent_code").val("");
			$("#st_po_dept_code").val("");
			$("#st_req_dept_code").val("");
			 
			mySheet.RemoveAll();
	
			$("#st_from_date").val( kepToMonthAdd("1","M") );
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
			
			break;
	}
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
	
	/*
	var rowCnt = mySheet.RowCount();
	console.log("rowCnt ==>> " + rowCnt);
	
	for(var i = 1; i <= rowCnt; i++){
		
		var dsDateVal = mySheet.GetCellValue(i, "DS_DATE");
		var status = mySheet.GetCellValue(i, "STATUS_TEXT");
		
		console.log("i ==================================" + i);
		console.log("dsDateVal ==>> " + dsDateVal);
		console.log("status ==>> " + status);
		
		if(status != "수주접수" && !isEmpty(dsDateVal)){
			//setLinkCol(mySheet, "DS_DATE");	//납품예정일
			
			mySheet.SetCellFontColor(i, "DS_DATE", "#000000");
			
		}
	}
	*/
	
	var rowCnt = mySheet.RowCount();
	for(var i=1; i<=rowCnt;i++){
		var status = mySheet.GetCellValue(i, 'PO_STATUS_CD'); 
		
		if(status == "PO30" || status == "PO60") { 
			mySheet.SetCellFontColor(i,"DS_DATE","blue");
		}
	}
	
	
}
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}
// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	
	//current_page = param.page;
	//kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoSellerWorkProxyList.do?page="+current_page , pagingMode );
	
	//조회
	current_page = param.page;
	
	//$("#page").val(current_page);
	
//	console.log("pageSearch current_page ==>> " + JSONtoString(param));
//	console.log("pageSearch param.page ==>> " + param.page);
	
	pagingMode = "P";
	kepSearch(document.searchCondition, mySheet, "/mpso/getMasterMpSoSellerWorkProxyList.do?page="+current_page, pagingMode );
}

// 팝업함수호출
function doPop(str) {
	var st_buyer = kepReplaceAll("st_buyer_code","@","");
	
	switch (str) {
		case "prdept": // 요청부서
			if(st_buyer == "") {
				alert("고객사를 선택해 주십시요.");
				break;
			}
			st_buyer = st_buyer.substr(0,10);
			openSearchPopup("/common/deptCodeAdminPop.do", "?com_code="+st_buyer, "500,500,no");
			popupSel = "prdept";
			break;
		case "podept": // 발주부서
			if(st_buyer == "") {
				alert("고객사를 선택해 주십시요.");
				break;
			}
			st_buyer = st_buyer.substr(0,10);
			openSearchPopup("/common/deptCodeAdminPop.do", "?com_code="+st_buyer, "500,500,no");
			popupSel = "podept";
			break;
		case "buyerMulti": // 고객사 M
			openSearchPopup("/common/safetyCompanyCodePop.do", "?COM_TYPE=B", "880,450,no");
			popupSel = "buyerMulti";
			break;
		case "seller": // 협력사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			popupSel = "seller";
			break;
		case "sheetQuery":	// 거래명세서 수기작성
			setSheetQuery();
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var colVal = mySheet.GetCellValue(Row, Col);
	
	if(isEmpty(colVal)){
		return;				
	}
	
	if (column == 'PO_NO') { // 발주번호 - 수주접수 팝업
		// setAgentDeliverySchedule(STATUS_TEXT, BUYER, PO_NO, AGENT_USER_ID)
	
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var po_no = mySheet.GetCellValue(Row, "PO_NO");
		var agent_user_id = mySheet.GetCellValue(Row, "AGENT_USER_ID");
		
		var status = mySheet.GetCellValue(Row, "PO_STATUS_CD");
		
		var do_qty = mySheet.GetCellValue(Row, "DO_QTY");
		
		var param = "";
			
		if(status == "PO20" ||  do_qty == "0" ){		//수주미접수
			// 수주접수 팝업
			//var loc = "/kr/sysop/proxbuy/order/buyer_gr/order_receive_pop.jsp?";
			param = "?st_buyer="+buyer+"&st_po_no="+po_no+"&st_agent_user_id="+agent_user_id;
			
			openSearchPopup("/mpso/getMasterMpSoOrderReceiptDetailPop.do", param, "930,600,no");
			
		} else {
			// 발주상세조회
			//var loc = "/kr/sysop/proxbuy/common/popup/sysop_proxybuy_po_display_pop_2.jsp?";
			param = "?st_buyer="+buyer+"&st_po_no="+po_no;
			
			// 주문진행화면에서 사용하는 팝업 - 내용이 동일한거같은데...
			openSearchPopup("/common/mpso/poDetailPop.do", param, "900,550,no");
		}
		
	} else if (column == 'DS_DATE') { // 납품예정일 - 거래명세서 작성 팝업
		
		// setInvoiceCreate(STATUS_TEXT, BUYER, PO_NO, DS_DATE, RD_DATE, PROCESS_TYPE, LEGACY_PO_NO, TR_BUYER, DELY_TO_LOCATION, ADD_USER_ID
		//					, REF_PR_NO, H_DS_FLAG, AGENT_CODE, BUYER_NAME, AGENT_USER_ID, AGENT_NAME, COMPLETE_MARK )
		
		var po_status_cd = mySheet.GetCellValue(Row, "PO_STATUS_CD");
		
		if(po_status_cd != "PO30" && po_status_cd != "PO60"){		// 수주접수
			 return;
		}
		
		//거래명세서 작성
		
		var process_type = mySheet.GetCellValue(Row, "PROCESS_TYPE");
		var complete_mark = mySheet.GetCellValue(Row, "COMPLETE_MARK");
		
		if(process_type == "2" && complete_mark == "Y"){
			alert(" 해당건은 TR로 협력사 송장은 이미 생성되었습니다.  ");
			return;
		}	   

		var rd_date = mySheet.GetCellValue(Row, "RD_DATE");
		var buyer_slg = mySheet.GetCellValue(Row, "BUYER_SLG");
		
//		console.log("buyer_slg ==>> " + buyer_slg);
//		console.log("rd_date ==>> " + rd_date);
		
		// test id : MOOHAN
		// PO_NO : PO14002026
		// SLOGIC-BEGIN(P07-0000015) - 거래명세서 작성작업에 기한을 둠
		if(!isEmpty(buyer_slg)){
			
			var dateArr = setDateMsg(rd_date);
			
			var msg = "고객사 납품요구일이 " + dateArr[0] +" 입니다.\n\n" 
					+ dateArr[1] + " ~ " + dateArr[2] + " 기간내에만 작업이 가능합니다.\n\n"
					+ "(문의사항: 변상남 대리, 055-270-6208 / 010-2058-4564)";
			
			var from_date = dateArr[1].replace(/[/]/gi,"");
			var to_date = dateArr[2].replace(/[/]/gi,"");
			
			if( eval(today) < eval(from_date) || eval(today) > eval(to_date) ){
				alert(msg);
				return;
			}
		}
		//SLOGIC-END
		
		var pop_up_url = mySheet.GetCellValue(Row, "POP_UP_URL");
		var pop_up_type =  mySheet.GetCellValue(Row, "POP_UP_TYPE");
		
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var po_no = mySheet.GetCellValue(Row, "PO_NO");
		var ds_date = mySheet.GetCellValue(Row, "DS_DATE");
		
		var legacy_po_no = mySheet.GetCellValue(Row, "LEGACY_PO_NO");
		var tr_buyer = mySheet.GetCellValue(Row, "TR_BUYER");
		var dely_to_location = mySheet.GetCellValue(Row, "DELY_TO_LOCATION");
		var add_user_id = mySheet.GetCellValue(Row, "AGENT_USER_ID");
		var ref_pr_no = mySheet.GetCellValue(Row, "REF_PR_NO");
		var ds_flag = mySheet.GetCellValue(Row, "H_DS_FLAG");
		var agent = mySheet.GetCellValue(Row, "AGENT_CODE");
		var buyer_name = mySheet.GetCellValue(Row, "BUYER_NAME");
		var agent_user_id = mySheet.GetCellValue(Row, "AGENT_USER_ID");
		var agent_name = mySheet.GetCellValue(Row, "AGENT_NAME");
		
		var gr_flag = "ALL";		// 입고완료제외 default
			
		var url = "";
	 	var param = "";
	 	var option = buildOption('930,600,no'); //width, height, scroll
	 	
	 	var seller = "KRKORE0001";
	 	var legacy_po_no_delimeter = legacy_po_no.substring(0,2);
		
//	 	var win = window.open("about:blank", "masterMpSoTranStatementWritePop", option);
	 	
//	 	console.log("pop_up_type ==>> " + pop_up_type);
//		console.log("pop_up_url ==>> " + pop_up_url);
		
		if(pop_up_type == "TYPE1" && TrimCommon(legacy_po_no_delimeter) == "20" && !isEmpty(pop_up_url)){
			
			// DB pop_up_url data =->>  "http://ez-van.doosandst.co.kr/dhivan2/kep/index.asp?kepvndno="
			url = pop_up_url;
	 		param = agent;
	 		
		} else if (pop_up_type == "TYPE2" && !isEmpty(pop_up_url)) {			// 두산인프라코어용..
			
			url = pop_up_url;
			//url = "/mpiv/getSellerMpIvTranStatementWriteDiPop.do";
		
			param = "?st_buyer="+encodeURIComponent(buyer);
			param += "&st_gr_flag="+encodeURIComponent(gr_flag);
			param += "&st_process_type="+encodeURIComponent(process_type);
			param += "&st_buyer_name="+encodeURIComponent(buyer_name);
			param += "&st_com_code="+encodeURIComponent(agent);
			param += "&st_agent="+encodeURIComponent(agent);
			param += "&st_agent_name="+encodeURIComponent(agent_name);
			param += "&st_proxy_yn=Y";
			
			// 협력사 거래명세서작성에서 사용 - 참고용
			//param = "?st_buyer="+buyer;
			//param += "&st_gr_flag="+gr_flag;
			//param += "&st_process_type="+process_type;
			//param += "&st_buyer_name="+buyer_name;
			//param += "&st_com_code="+$("#st_com_code").val();
			
			
		} else if (pop_up_type == "TYPE3" || ds_flag == "Y") {		// 분할납품 가능
			
			//url = pop_up_url;
		
			url = "/mpiv/getSellerMpIvTranStatementWriteDoosanmecaPop.do";
		
			param = "?st_buyer="+encodeURIComponent(buyer);
			param += "&st_po_no="+encodeURIComponent(po_no);
			param += "&st_ds_date="+encodeURIComponent(ds_date);
			param += "&st_seller="+encodeURIComponent(seller);
			param += "&st_process_type="+encodeURIComponent(process_type);
			param += "&st_legacy_po_no="+encodeURIComponent(legacy_po_no);
			param += "&st_tr_buyer="+encodeURIComponent(tr_buyer);
			param += "&st_dely_to_location="+encodeURIComponent(dely_to_location);
			param += "&st_add_user_id="+encodeURIComponent(add_user_id);
			param += "&st_ref_pr_no="+encodeURIComponent(ref_pr_no);
			param += "&st_agent="+encodeURIComponent(agent);
			param += "&st_user_id="+encodeURIComponent(agent_user_id);
			param += "&st_proxy_yn=Y";
			
		} else {
	 		
	 		// test id : YUHANADS
	 		// po_no : PO14003184
			
			// default
			//url = "/mpso/getMasterMpSoTranStatementDetailPop.do";
			url = "/mpiv/getSellerMpIvTranStatementWritePop.do";
			//url = "/kr/sysop/proxbuy/order/buyer_gr/invoice_create_pop.jsp";
		
			
			param  = "?st_buyer="+encodeURIComponent(buyer);
			param += "&st_po_no="+encodeURIComponent(po_no);
			param += "&st_ds_date="+encodeURIComponent(ds_date);
			param += "&st_seller="+encodeURIComponent(seller);
			param += "&st_process_type="+encodeURIComponent(process_type);
			param += "&st_legacy_po_no="+encodeURIComponent(legacy_po_no);
			param += "&st_tr_buyer="+encodeURIComponent(tr_buyer);
			param += "&st_dely_to_location="+encodeURIComponent(dely_to_location);
			param += "&st_add_user_id="+encodeURIComponent(add_user_id);
			param += "&st_ref_pr_no="+encodeURIComponent(ref_pr_no);
			param += "&st_agent="+encodeURIComponent(agent);
			param += "&st_user_id="+encodeURIComponent(agent_user_id);
			param += "&st_proxy_yn=Y";
			
	 	}
		// param = encodeURI(param);
		var win = window.open(url+param, "masterMpSoTranStatementWritePop", option);
		//win.location.href = url+param;
		
	} else if (column == "INVOICE_NO"){ // 거래명세서번호 - 납품실적등록 팝업
		
		// getInvoiceDisplayPop(BUYER, PO_NO, INVOICE_NO, LEGACY_IV_SERIAL, AGENT_CODE)
		// var loc = "/kr/sysop/proxbuy/order/buyer_gr/invoice_delivery_create_pop.jsp?";
		
		var buyer 				= mySheet.GetCellValue(Row, "BUYER");
		var po_no 				= mySheet.GetCellValue(Row, "PO_NO");
		var inv_no 				= mySheet.GetCellValue(Row, "INVOICE_NO");
		var legacy_iv_serial	= mySheet.GetCellValue(Row, "LEGACY_IV_SERIAL");
		var agent 				= mySheet.GetCellValue(Row, "AGENT_CODE");
		
		var param = "?st_buyer="+buyer+"&st_po_no="+po_no+"&st_inv_no="+inv_no+"&st_legacy_iv_serial="+legacy_iv_serial+"&st_agent="+agent;
		
		//openSearchPopup("/common/mpiv/invoiceDisplayPop.do", '?INV_NO='+INV_NO+'&BUYER='+BUYER, "600,550,no");
		
		if(inv_no.substring(0,2) == "IK"){
			openSearchPopup("/common/mpiv/invoiceDisplayPop.do", '?INV_NO='+inv_no+'&BUYER='+buyer, "800,550,no");
		} else {
			openSearchPopup("/mpso/getMasterMpSoTranStatementDetailPop.do", param, "930,630,no");
		}
	}
	
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	
	if (popupSel == "prdept") {	
		$("#st_req_dept_code").val(code);
		$("#st_req_dept_name").val(text);
	} else if (popupSel == "podept") {	
		$("#st_po_dept_code").val(code);
		$("#st_po_dept_name").val(text);
	} else if (popupSel == "buyerMulti") {	
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(kepMultiName(text,"@"));
	} else if (popupSel == "seller") {	
		$("#st_agent_code").val(code);
		$("#st_agent_name").val(text);
	}		
}

function setDateMsg(date){
	
	$("#st_rd_date").val(date);
	
	var fRdDate = kepDateSlashAdd(date);
	var fFromDate = kepDateAdd("st_rd_date", 7, "M");
	var fToDate = kepDateAdd("st_rd_date", 7, "P");
	
	dateForm = new Array(fRdDate, fFromDate, fToDate );
	return dateForm ;
	 
}

// 거래명세서 수기작성
function setSheetQuery(){
	
	var buyer_code	= $("#st_buyer_code").val();
	var agent_code	= $("#st_agent_code").val();
	
	if(buyer_code == "" || agent_code == "") {
		alert("고객사와 협력사를 선택해 주십시요.");
		return;
	}
	
	var buyer = buyer_code.split("@");
	
	var param =  "["+buyer[0]+"]["+agent_code+"]";
	var fileName = "RD_06_S_001_90";
	
	//alert("RD_ID : " + fileName + ", param : " + param);
	
	reportOpen(fileName,param);
	
	/*
	수발주 거래명세서(수기)
	파라미터 : /rp [BuyerCode][AgentCode]
	RD명 : RD_06_S_001_90
	*/
	/*
	if(buyer == "KRDAEW0016"){
	  window.open("/kr/epro/buy/sheet/inv_prn_empty_daew.jsp?buyer="+buyer+"&seller="+seller, "sheetWin","width=975,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
	}else if(buyer=="KRDONG0110" || buyer=="KRDONG0107" || buyer=="KRDONG0128" || buyer=="KRDONG0099" || buyer=="KRDONG0153") {
		window.open("/kr/epro/buy/sheet/inv_prn_dongbu.jsp?buyer="+buyer+"&seller="+seller, "sheetWin","width=700,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
	}else if(buyer=="KRDONG0119") {
		window.open("/kr/epro/buy/sheet/inv_prn_dongbu_ansan_blank.jsp?buyer="+buyer+"&seller="+seller, "sheetWin","width=700,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
	}else if(buyer=="KRDOOS0046") {
	   window.open("/kr/epro/buy/sheet/inv_prn_gunsan.jsp?buyer="+buyer+"&seller="+seller, "sheetWin","width=700,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
	}else{
	   window.open("/kr/epro/buy/sheet/inv_prn_empty.jsp?buyer="+buyer+"&seller="+seller, "sheetWin","width=700,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
	}
	*/
} 
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>협력사 업무대행</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" id="searchCondition" method = "post" onsubmit="return false" >
			<!--HIDDEN-->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- input type="hidden" id="page" name="page" value="1"  -->
			
			<input type="hidden" id="st_rd_date" name="st_rd_date" value="" />
			
			<div id="cont_searchA">
			<!-- 화면 내 정의 -->
			<table  class="cont_t_list01">
				<caption>협력사 업무대행</caption>
				<colgroup>
					<col width="8%" />
					<col width="20%" />
					<col width="8%" />
					<col width="20%" />
					<col width="8%" />
					<col width="20%" />
					<col width="8%" />
					<col width="10%" />
				</colgroup>
				<tbody>
					<tr>
						<th>
							<label for="b_code" class="hidden">기간선택</label>
				  			<select name = "st_date_type" id="st_date_type" style="height:20px">
					      		<option value="PO" selected="selected">발주일</option>
								<option value="GR" >입고일</option>
								<option value="RD" >요청일</option>
                           </select>
						</th>
						<td colspan="3">
							<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" > - 
							<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" >
								&nbsp;&nbsp;
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
						</td>
					    <th>진행상태</th>
					    <td>
                           	<label for="b_delivery" class="hidden">진행상태선택</label>
                     		<select name = "st_status" id="st_status" >
                     			
                     			<script type="text/javascript">kepAjaxCommonComboDataValue('st_status', 'C018', 'ALL', '');</script>
                     			
                     			<!--
								<option value = "" selected>전체</option>
								<option value = "발주삭제">발주삭제</option>
								<option value = "수주미접수">수주미접수</option>
								<option value = "수주접수">수주접수/송장미생성</option>
								<option value = "송장생성">송장생성 </option>
								<option value = "부분입고">부분입고</option>
								<option value = "입고완료">입고완료</option>
								--> 
			             	</select>
						</td>
					</tr>
					<tr>
						<th><font color="red"><b>*</b></font>고객사</th>
						<td>
	                        <input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:70%;" value = "">
	                        <input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:100px;" value ="">
	                        <a href="javascript:doPop('buyerMulti');"><img src="/resources/images/btn_search03.gif"></a>
	                        <a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th><font color="red"><b>*</b></font>협력사</th>
							<td>
		                        <input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:70%;" value ="" READONLY>
		                        <input type="hidden" name="st_agent_code" id="st_agent_code" style="width:100px;" value ="">
		                        <a href="javascript:doPop('seller');"><img src="/resources/images/btn_search03.gif"></a>
		                        <a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
                            </td>
						<th>품목코드</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:80%;" value =""  onKeyDown="kepEnter()">
						</td>
					</tr>
					<tr>
						<th>발주부서</th>
	                    <td class ="font1_table_font">
	                        <input type="text" class="input_type_text" name="st_po_dept_name" id="st_po_dept_name" style="width:70%;" value ="" READONLY>
	                        <input type="hidden" name="st_po_dept_code" id="st_po_dept_code" style="width:100px;" value ="">
	                        <a href="javascript:doPop('podept');"><img src="/resources/images/btn_search03.gif"></a>
	                        <a href="javascript:kepEraser('st_po_dept_code','st_po_dept_name');"><img src="/resources/images/btn_eraser2.gif"></a>
	                    </td>
	                    <th>요청부서</th>
	                    <td class ="font1_table_font">
	                        <input type="text" class="input_type_text" name="st_req_dept_name" id="st_req_dept_name" style="width:70%;" value="" READONLY>
	                        <input type="hidden" name="st_req_dept_code" id="st_req_dept_code" value="">
	                        <a href="javascript:doPop('prdept');"><img src="/resources/images/btn_search03.gif"></a>
	                        <a href="javascript:kepEraser('st_req_dept_code','st_req_dept_name');"><img src="/resources/images/btn_eraser2.gif"></a>
	                    </td>
	                    <th>I/F 발주번호</th>
	                    <td class ="font1_table_font">
	                    	<input type="text" class="input_type_text" name="st_if_po_no" id="st_if_po_no" size="25" style="width:80%;" value ="" onKeyDown="kepEnter()">
	                    </td>
					</tr>
					<tr>
						<th>발주번호</th>
	                    <td class ="font1_table_font">
	                    	<input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:90%;" value ="" onKeyDown="kepEnter()">
	                    </td>
	                    <th>관리번호</th>
	                    <td class ="font1_table_font" >
	                    	<input type="text" class="input_type_text" name="st_ref_no" id="st_ref_no" style="width:90%;" value ="" onKeyDown="kepEnter()">
	                    </td>
						<th>I/F 관리번호</th>
	                    <td class ="font1_table_font" >
	                    	<input type="text" class="input_type_text" name="st_ref_if_no" id="st_ref_if_no" size="25"  style="width:80%;" value ="" onKeyDown="kepEnter()">
	                    </td>
	                    <th>거래유형</th>
	                    <td>
	                    	<label for="b_process_type" class="hidden">거래유형선택</label>
	                   		<select name = "st_process_type" id="st_process_type" >                  			
	                  			<script type="text/javascript">kepAjaxCommonTotalCombo('st_process_type', 'M034', 'ALL','','','TEXT2');</script>
			             	</select>
		             	<td>
					</tr>
				</tbody>
			</table>
			</div>
					<span class="fl"  style="padding-top:8px;">
						<img src="/resources/images/txt_no.gif" alt="정렬개수" />
						<label for="b_no02" class="hidden">정렬개수선택</label>
						<select name="onepagerow" style="width: 70px;" >
							<option value="10" selected>10건</option>
							<option value="20">20건</option>
							<option value="30">30건</option>
							<option value="40">40건</option>
							<option value="50">50건</option>
						</select>&nbsp;
					</span>	
						<span class="btn_10 mr04" style="padding-bottom:3px;">
							<a href="javascript:doPop('sheetQuery');">거래명세서 수기작성</a>
						</span>	
						&nbsp; * 오른쪽마우스 클릭 후 편집모드로 변경하여 수기명세서 작성할 수 있습니다.

		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			<!--버튼영역-->
<%  
		if(st_user_id.indexOf("KEPC") < 0){ %>
               <div class="btnArea">
  	          	<span class="fr">
  					<span class="btn_04 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  			 </div>
<%	}%>
<!--내용 종료-->	                 

</body>
</html>
