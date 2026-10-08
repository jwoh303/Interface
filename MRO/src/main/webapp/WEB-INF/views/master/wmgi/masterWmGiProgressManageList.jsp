<%--
**********************************************
* 메뉴 : 출고>진행관리
* 화면 : 진행관리
* 기능 : 출고지시에 대한 진행관리 조회
* 프로그램 ID : PG_08_M_008_00
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-7-10
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="java.util.HashMap"%> 
<%@ page import="java.util.Map"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
String buyer = "";
String userid = "";
if (_sessionInfo != null){
	buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
	userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
} 

String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_po_user_id"),""); 

String whAdmin = _sessionInfo.getWhAdmin();
//SLOGIC-BEGIN(P08-0000005-01)
boolean pP08_0000005_01 = CommonUtil.getSpecialCheckReturn(CommonUtil.nvl((String) request.getParameter("st_BUYER"),""),"P08-0000005-01");
//SLOGIC-END
//필드추가 권한여부
boolean getRoleYn = CommonUtil.getCodeCheckReturn("M174",userid);
%>
<script src="/resources/js/wms_tr_multi_sheet.js"></script>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var agentImg = "/resources/images/btn_search03.gif";
var remarkOn="/resources/images/but_icon01.gif";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
	      			{ Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
	      			,{ Align:"Center",	Width:40,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사코드", SaveName : "BUYER"} 
	    			,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사", SaveName:"BUYER_NAME"} /* javascript:getCompanyDisplayPop*/
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태", SaveName:"STATUS_TEXT"} /* rtobj[12]")%></td><!--  --> */
	    			
	    			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주번호", SaveName:"PO_NO"} /*:"rtobj[2]")%><!-- 발주번호 -->*/
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"LEGACY_NO", SaveName:"LEGACY_PO_NO"} /* rtobj[13]")%></td><!--  --> */
	    			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"입고번호", SaveName:"GR_NO"} /* :"rtobj[3]")%><!-- --> */
	    			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"송장번호", SaveName:"IK_NO"} /* rtobj[14]")%> */
	    			
	    			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"발주일", SaveName:"PO_CREATE_DATE"} /* CommonUtil.formatStrinigDate(rowData.get("rtobj[5]")%></td><!--  --> */
	    			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"납품요청일", SaveName:"RD_DATE"} /* CommonUtil.formatStrinigDate(rowData.get("rtobj[16]")%></td><!--  --> */			
	    			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"입고일", SaveName:"GR_DATE"} /* CommonUtil.formatStrinigDate(rowData.get("rtobj[6]")%></td><!--  --> */
	    			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"출고예정일", SaveName:"SCHEDULED_DATE"} 
	    			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"출고일", SaveName:"INV_DATE"} /* CommonUtil.formatStrinigDate(rowData.get("rtobj[17]")%></td><!--  --> */
	    			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"납품일", SaveName:"DELIVERY_DATE"} /* CommonUtil.formatStrinigDate(rowData.get("rtobj[7]")%><!--  --> */
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준코드", SaveName:"STDCATLG_ID"} /* :"rtobj[4]")%></td><!--  --> */
	                ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드", SaveName:"BUYER_ITEM_NO"} /* <a href="javascript:getItemimgPop('rowData.get("rtobj[41]")%>','rowData.get("rtobj[40]")%>');">rowData.get("rtobj[15]")%></a> */
	    			,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명", SaveName:"DESCRIPTION"} /*  colspan="2" align="left">rowData.get("rtobj[23]")%></td><!--  --> */
	    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격", SaveName:"SPECIFICATION"} /*  colspan="4" align="left">rowData.get("rtobj[24]")%></td><!--  --> */
	    			,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주수량", SaveName:"PO_QTY"} /* WisehubString.WiseNumberType(rowData.get("rtobj[8]"),true,0,3)%></td><!--  --> */
	    			,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}", 	Header:"납품수량", SaveName:"DELIVERY_QTY"} /* WisehubString.WiseNumberType(rowData.get("rtobj[20]"),true,0,3)%></td><!--  --> */
	    			,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}", Header:"입고수량", SaveName:"WMS_GR_QTY"} /* WisehubString.WiseNumberType(rowData.get("rtobj[19]"),true,0,3)%></td><!--  --> */
	    			,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}", 	Header:"기출고수량", SaveName:"GI_DELIVERY_QTY"} /*  WisehubString.WiseNumberType(rowData.get("rtobj[26]"),true,0,3)</td> */
	    			,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}", Header:"출고수량", SaveName:"WMS_IVK_QTY"} /* WisehubString.WiseNumberType(rowData.get("rtobj[9]"),true,0,3)%></td><!--  --> */
	    			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float",  Format:"${priceFormat}", Header:"매입단가", SaveName:"LIST_PRICE"} /* WisehubString.WiseNumberType(rowData.get("rtobj[10]"),true,0,3)%></td><!--  --> */
	    			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Int", 	Header:"매입금액", SaveName:"LIST_AMT"} /* WisehubString.WiseNumberType(rowData.get("rtobj[11]"),true,0,3)%></td><!--  --> */		
	    			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float",  Format:"${priceFormat}", Header:"매출단가", SaveName:"UNIT_PRICE"} /* WisehubString.WiseNumberType(rowData.get("rtobj[21]"),true,0,3)%></td><!--  --> */
	    			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Int", 	Header:"매출금액", SaveName:"UNIT_AMT"} /* WisehubString.WiseNumberType(rowData.get("rtobj[22]"),true,0,3)%></td><!--  --> */
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"구분", SaveName:"DOC_TEXT"} /* rtobj[18]")%></td><!--  --> */
	    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"협력사",	SaveName:"AGENT_IMG"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사코드", SaveName:"AGENT"} /* <a href="javascript:getCompanyDisplayPop('rowData.get("rtobj[25]")%>');"> <img src="/resources/images/btn_search03.gif" width="18" height="18" align="absmiddle" border="0"><!--  --> */		
	    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"요청자",	SaveName:"ADD_USER_IMG"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자명", SaveName:"ADD_USER_NAME"} /* <a href="javascript:setPurchaserDt('rowData.get("rtobj[27]")%>', 'rowData.get("rtobj[28]")%>', 'rowData.get("rtobj[38]")%>');"><img src="/resources/images/btn_search03.gif" width="18" height="18" align="absmiddle" border="0"><!-- 요청자 --> */
	    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"배송처",	SaveName:"DELY_TO_LOCATION_IMG"}
	    			,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}", 	Header:"박스수량", SaveName:"BOX_QTY"} 
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"차량아이디", SaveName:"CAR_ID"} 
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"차량번호", SaveName:"CAR_NO"} 
	    			,{ Align:"Left",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"차량기사", SaveName:"CAR_PERSON_NAME"} 
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"연락처", SaveName:"CAR_PERSON_TEL"} 
	    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"지연사유",	SaveName:"DELAY_REMARK_IMG",BackColor:"${optColor}" }
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"지연사유", SaveName:"DELAY_REMARK"} 
	    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고",	SaveName:"PO_REMARK_IMG"}
	    			,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"택배회사", SaveName:"DELIVERY_COMPANY"} 
	    			,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"택배회사", SaveName:"DELIVERY_COMPANY_NAME"} 
	    			,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"운송장번호", SaveName:"DELIVERY_NO"} 
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고", SaveName:"PO_REMARK"} /* <a href="javascript:setRemarkDt('rowData.get("rtobj[30]")%>')"><img src="/resources/images/btn_search03.gif" width="18" height="18" align="absmiddle" border="0"></a><!-- 비고 --> */
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사명", SaveName:"AGENT_NAME"} 
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사전화번호", SaveName:"AGENT_TEL_NO"} 
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PO_HD_REMARK", SaveName:"PO_HD_REMARK"} 
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"BYIT_COMORG_CODE"} 
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"CONTRACT_NO"} 
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"CONTRACT_SEQ"} 
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자전화번호", SaveName:"ADD_USER_TEL"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"ADD_USER_ID"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"PODT_GR_QTY"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"MODIFIABLE"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Int",	Header:"발주항번", SaveName:"PO_SEQ"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Int",	Header:"센타입고항번", SaveName:"GR_SEQ"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Int",	Header:"센타송장항번", SaveName:"IK_SEQ"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"GUBUN_TEXT"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"PROCESS_TYPE"}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",				Header:"배송증빙첨부",							SaveName:"IMAGE_KEY_INV_IMG",	Sort:0}
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",				Header:"배송증빙서명",							SaveName:"IMAGE_KEY_SIGN_IMG",	Sort:0}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"IMAGE_KEY_SIGN",				SaveName:"IMAGE_KEY_SIGN"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"IMAGE_KEY_INV",				SaveName:"IMAGE_KEY_INV"}
					,{ Align:"Left",	Width:500,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"배송처", SaveName:"DELY_TO_LOCATION"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"자동입고", SaveName:"AUTO_GR_YN"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"WMS_RD_ID",		SaveName:"WMS_RD_ID"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"LEGACY_IV_SERIAL",		SaveName:"LEGACY_IV_SERIAL"}
					<%if(getRoleYn== true){ %>
					,{Align : "Center",	SaveName : "PR_USER_NAME",			Header : "인수자",		Type : "Text",	EditLen : 100,	Width : 60,		Edit : false}
					,{Align : "Center",	SaveName : "PR_USER_MOBILE_PHONE",	Header : "인수자휴대폰",	Type : "Text",	EditLen : 100,	Width : 120,	Edit : false}
					<% } %>
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:2};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);
	mySheet.SetImageList(2, agentImg);
	//파일첨부이미지설정
	mySheet.SetImageList(5, diskOff);
	mySheet.SetImageList(6, diskOn);
	setLinkCol(mySheet, "IMAGE_KEY_INV_IMG");
	setLinkCol(mySheet, "IMAGE_KEY_SIGN_IMG");
	//하이퍼링크 설정
	setLinkCol(mySheet, "AGENT_IMG"); 
	setLinkCol(mySheet, "ADD_USER_IMG"); 
	setLinkCol(mySheet, "DELY_TO_LOCATION_IMG"); 
	setLinkCol(mySheet, "PO_REMARK_IMG");
	setLinkCol(mySheet, "DELAY_REMARK_IMG");
	
	setLinkCol(mySheet, "DELIVERY_DATE");
	setLinkCol(mySheet, "BUYER_NAME"); 
	setLinkCol(mySheet, "PO_NO"); 
	setLinkCol(mySheet, "GR_NO"); 
	setLinkCol(mySheet, "IK_NO"); 
	setLinkCol(mySheet, "BUYER_ITEM_NO"); 
	
	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL','');

	//콤보데이터 셋팅		
	var serch_text = "st_user_id="+document.searchCondition.st_user_id.value+"&st_com_code="+document.searchCondition.st_com_code.value;


	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	kepSetCalender("st_dlvry_date");

	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepToMonthAdd("1","P"));
	$("#st_dlvry_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}

function calDate() {
	permit_search_date = kepGetDateDiff('st_from_date','st_to_date','D');

	if(permit_search_date<=92) {
		return true;
	}else {
		return false;
	}

}	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");

	switch (str) {
	case "search":	 // 조회
		var st_status_text = document.searchCondition.st_status_text.value;
		var st_date_flag = document.searchCondition.st_dateFlag.value;
		
		if((st_status_text == "출고예정" || st_status_text == "분할출고예정") && st_date_flag == "IV"){
			document.searchCondition.st_dateFlag.focus();
			alert("출고일 외 기간구분을 선택해주세요.");
			return;
		}else if(st_status_text == "간선출고" && st_date_flag == "DL"){
			document.searchCondition.st_dateFlag.focus();
			alert("배송확정일 외 기간구분을 선택해주세요.");
			return;
		} 
	
		if(kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val())== false){
			return;
		}
	
		if($("#st_buyer_name").val() == '구매대행구매사 전체'){
			if(kepGetDateDiff("st_to_date" ,"st_from_date" ,'D' ) +31 < 0 ){
				alert("구매사 전체인 경우는 조회기간을 1개월 단위로 조회가 가능합니다.");
				return;
			}
		}else{
			if(kepGetDateDiff("st_to_date" ,"st_from_date" ,'D' ) +92 < 0 ){
				alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n3개월 이상의 데이타는 S/R 요청 바랍니다.");
				return;
			}
		}
		
		if(document.searchCondition.st_process_type.value != '9'){ // 간선이 아닌 경우만 고객사 체크
			if(document.searchCondition.st_buyer_code.value == ''){
				alert("고객사를 선택하여 주십시요.\n\n필수 사항 입니다.");
				return;
			}
		}
		
		if( ($("#st_scheduled_from_date").val() != "" &&  $("#st_scheduled_to_date").val() =="")
				|| ($("#st_scheduled_from_date").val()  == "" &&  $("#st_scheduled_to_date").val()  !="") ){
			alert('출고예정일의 시작일과 종료일을 함께 입력 하셔야 합니다.');
			return;
		}
		
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/wmgi/getMasterWmGiProgressManageList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepToMonthAdd("1","P"));
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		break;


	
	case "excelDown": // 엑셀다운로드
		// 간선이 아닌 경우만 고객사 체크
		if(document.searchCondition.st_process_type.value != '9' && document.searchCondition.st_buyer_code.value == ''){
			alert("고객사를 선택하여 주십시요.\n\n필수 사항 입니다.");
			return;
		}        
	
		if(!calDate()){
			alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n 3개월 이상의 데이타는 S/R 요청 바랍니다.");
			return;
		}  
		 $("#pageflag").val('0');
		var param = {FileName:"진행관리.xlsx",
		DownCols:"BUYER_NAME|STATUS_TEXT|PO_NO|LEGACY_PO_NO|GR_NO|IK_NO|STDCATLG_ID|BUYER_ITEM_NO|PO_CREATE_DATE|RD_DATE|INV_DATE|GR_DATE|DELIVERY_DATE|DOC_TEXT|PO_QTY|WMS_GR_QTY|GI_DELIVERY_QTY|DELIVERY_QTY|WMS_IVK_QTY|DESCRIPTION|SPECIFICATION|AGENT_NAME|AGENT|DELY_TO_LOCATION|PO_REMARK|BUYER|PO_SEQ|GR_SEQ|IK_SEQ|PO_HD_REMARK|DELIVERY_COMPANY_NAME|DELIVERY_NO|BOX_QTY"};
		kepDownExcel(document.searchCondition ,mySheet , "/wmgi/excelMasterWmGiProgressManageList.do", param);
		$("#pageflag").val('1');
		break;
		
	case "report":	// report 
		if(document.searchCondition.st_buyer_code.value == ''){
			alert("고객사를 선택하여 주십시요.\n\n필수 사항 입니다.");
			return;
		}
	
	    var st_date_gubun = kepSelectOptionVal("st_date_gubun");
	    var st_dlvry_date = $("#st_dlvry_date").val().replace(/[/]/gi,""); 
	    var st_warehouse_code = $("#st_warehouse_code").val(); 
	    var st_buyer_code = $("#st_buyer_code").val(); 
	    var loc = "";
	    if (st_date_gubun == "INV_DATE"){ // 출고일
	    	loc = "RD_08_M_005_02_01";
	    }else if (st_date_gubun == "DELIVERY_DATE") { // 배송확정일
	    	loc = "RD_08_M_005_02_02";
	    }else{
	    	return;
	    }
	    reportOpen(loc,"["+st_warehouse_code+"]["+st_buyer_code+"]["+st_dlvry_date+"]");
		break;
		
	case "invoice":	// 거래명세서 출력
		var ik_no_list = "";
		var legacy_po_list = "";
		var legacy_iv_list = "";
		
		if (selectedGrid.length == 0) {
			alert("선택된 항목이 없습니다.");
			return;
		}else{
			for(var i=0; i<arrRow.length; i++){
				if(mySheet.GetCellValue(arrRow[0],"BUYER") != mySheet.GetCellValue(arrRow[i],"BUYER")){
					alert("여러 건을 선택하는 경우 동일한 고객사만 가능합니다.");
					return;
				}
				
				ik_no_list += mySheet.GetCellValue(arrRow[i],"IK_NO") + "@@";
				legacy_po_list += mySheet.GetCellValue(arrRow[i],"LEGACY_PO_NO") + "@@";
				legacy_iv_list += mySheet.GetCellValue(arrRow[i],"LEGACY_IV_SERIAL") + "@@";
			}
		}
	
		var st_wms_rd_id = mySheet.GetCellValue(1, "WMS_RD_ID");
		var st_warehouse_code = $("#st_warehouse_code").val();
		var st_buyer = mySheet.GetCellValue(1, "BUYER");
		var st_user_id = $("#st_user_id").val();
		
		setWmsTrMultiSheet(st_wms_rd_id, "", "", st_warehouse_code, st_buyer, ik_no_list, st_user_id, legacy_po_list, "", legacy_iv_list, "");
		break;
		
	case "hubReport":	// 간선 패킹리스트 
	    // 일자구분 선택 상관없이 출고일로만 작동
	    var st_warehouse_code = $("#st_warehouse_code").val();
		var st_dlvry_date = $("#st_dlvry_date").val().replace(/[/]/gi,"");
	    var loc = "RD_08_M_005_07";

	    reportOpen(loc,"["+st_warehouse_code+"]["+st_dlvry_date+"]");
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

	for(var i=1; i<mySheet.GetTotalRows()+1; i++){
		if(mySheet.GetCellValue(i,"DELY_TO_LOCATION")!=""){
			mySheet.SetCellValue(i, 'DELY_TO_LOCATION_IMG', remarkOn);
		}else{
			mySheet.SetCellValue(i, 'DELY_TO_LOCATION_IMG', remarkOff);
		}
		
		if(mySheet.GetCellValue(i,"ADD_USER_NAME")!=""){
			mySheet.SetCellValue(i, 'ADD_USER_IMG', remarkOn);
		}else{
			mySheet.SetCellValue(i, 'ADD_USER_IMG', remarkOff);
		}
		
		if(mySheet.GetCellValue(i,"PO_REMARK")!=""){
			mySheet.SetCellValue(i, 'PO_REMARK_IMG', remarkOn);
		}else{
			mySheet.SetCellValue(i, 'PO_REMARK_IMG', remarkOff);
		}
		
		if(mySheet.GetCellValue(i,"AGENT")!=""){
			mySheet.SetCellValue(i, 'AGENT_IMG', remarkOn);
		}else{
			mySheet.SetCellValue(i, 'AGENT_IMG', remarkOff);
		}
		
		if(mySheet.GetCellValue(i,"DELAY_REMARK")!=""){
			mySheet.SetCellValue(i, 'DELAY_REMARK_IMG', remarkOn);
		}else{
			mySheet.SetCellValue(i, 'DELAY_REMARK_IMG', remarkOff);
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
	kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiProgressManageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
	case "buyer_single": // 고객사 s
	    var ware_house_code = document.searchCondition.st_warehouse_code.value;
	    var st_from_date = document.searchCondition.st_from_date.value;
	    var st_to_date = document.searchCondition.st_to_date.value;
	    var st_date_flag = document.searchCondition.st_dateFlag.value;
	    openSearchPopup('/wmco/showMasterWmCoMbrcmpyPop.do','?st_warehouse_code='+ware_house_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date+'&st_date_flag='+st_date_flag, "500,500,no"); 
        popupSel = "buyer_single";
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

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}else if(popupSel == "agent_single"){
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
	}else if(popupSel == "masterWmCoDelayPop") {
		mySheet.SetCellValue(grbRow, 'DELAY_REMARK', value1);
		if(value1==""||value1==null){
			mySheet.SetCellValue(grbRow, 'DELAY_REMARK_IMG', remarkOff);
		}else{
			mySheet.SetCellValue(grbRow, 'DELAY_REMARK_IMG', remarkOn);
		}
	}
	
	if (popupSel == "buyer_s") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	
	}
	grbRow="";	//초기화
}

function localDateEval(RD_DATEval){
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

	if(column == 'BUYER_NAME'){
		if(mySheet.GetCellValue(Row,'BUYER_NAME')!=""){
		//	alert( mySheet.GetCellValue(Row,'BUYER'));
			 var com_code = mySheet.GetCellValue(Row,'BUYER');
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}else if(column == 'PO_NO'){
		if(mySheet.GetCellValue(Row,'PO_NO')!=""){
			if(mySheet.GetCellValue(Row,'PO_NO')!=""){
			    var ware_house_code = document.searchCondition.st_warehouse_code.value;
				var buyer = mySheet.GetCellValue(Row,'BUYER');
		    	var po_no = mySheet.GetCellValue(Row,'PO_NO');
		    	var inv_no = mySheet.GetCellValue(Row,'INV_NO');
		    	var BUYER_NAME  = mySheet.GetCellValue(Row,'BUYER_NAME');
		    	var PO_CREATE_DATE = mySheet.GetCellText(Row,'PO_CREATE_DATE');
		    	var st_RD_DATE = mySheet.GetCellText(Row,'RD_DATE');
		    	var DOC_TEXT ="";
		    	var RD_DATEval = mySheet.GetCellValue(Row,'RD_DATE');
		    	var GR_DATE_RE =  localDateEval(RD_DATEval);
		    	var ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME');
		    	var DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
		    	var PO_REMARK = mySheet.GetCellValue(Row,'PO_HD_REMARK');
		    	var AGENT = mySheet.GetCellValue(Row,'AGENT');
		    	var AGENT_NAME = mySheet.GetCellValue(Row,'AGENT_NAME');
		    	var AGENT_TEL_NO = mySheet.GetCellValue(Row,'AGENT_TEL_NO');
		    	var st_STATUS = mySheet.GetCellValue(Row,'DOC_TEXT');
		    	var st_LEGACY_PO_NO = mySheet.GetCellValue(Row,'LEGACY_PO_NO');
		    	var st_DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
		    	openSearchPopup('/wmgr/showMasterWmGrTrOrderGrRegPop.do','?BUYER='+buyer+'&PO_NO='+po_no+'&INV_NO='+inv_no+'&BUYER_NAME='+BUYER_NAME+'&PO_CREATE_DATE='+PO_CREATE_DATE+'&st_RD_DATE='
		    			+st_RD_DATE+'&DOC_TEXT='+DOC_TEXT+'&GR_DATE_RE='+GR_DATE_RE+'&ADD_USER_NAME='+ADD_USER_NAME+'&DELY_TO_LOCATION='+DELY_TO_LOCATION+'&PO_REMARK='+PO_REMARK+'&AGENT_NAME='+AGENT_NAME
		    			+'&ware_house_code='+ware_house_code+'&st_STATUS='+st_STATUS+'&st_LEGACY_PO_NO='+st_LEGACY_PO_NO+'&st_DELY_TO_LOCATION='+st_DELY_TO_LOCATION+'&AGENT='+AGENT+'&AGENT_TEL_NO='+AGENT_TEL_NO , "900,500,no"); 
				popupSel = "masterWmGrTrOrderManagerPop";
			}
		}
	}else if(column == 'GR_NO'){
		if(mySheet.GetCellValue(Row,'GR_NO')!=""){
			var st_type;
			var HUB_YN = "N";
			
			if("출고예정" == mySheet.GetCellValue(Row,'STATUS_TEXT')&& "2"==mySheet.GetCellValue(Row,'PROCESS_TYPE')){
			   st_type = "W";
			}else{
				st_type = "X";
			}
			
			if("간선출고" == mySheet.GetCellValue(Row,'STATUS_TEXT')){
				HUB_YN = "Y";
			}
			
			var BUYER_NAME = mySheet.GetCellValue(Row,"BUYER_NAME"); //고객사
			var PO_NO = mySheet.GetCellValue(Row,"PO_NO"); //발주번호
			var PO_CREATE_DATE = mySheet.GetCellText(Row,"PO_CREATE_DATE"); //발주일
			var RD_DATE = mySheet.GetCellText(Row,"RD_DATE"); //납품요청일
			var INV_NO = mySheet.GetCellValue(Row,"GR_NO"); //입고번호
			var DOC_TEXT =mySheet.GetCellValue(Row,'GUBUN_TEXT');
			var STATUS = ''; //구분
			var WMS_GR_DATE = mySheet.GetCellText(Row,"GR_DATE"); //입고일
			var AGENT = mySheet.GetCellValue(Row,"AGENT"); //협력사
			var AGENT_NAME = mySheet.GetCellValue(Row,'AGENT_NAME');
			var AGENT_TEL_NO = mySheet.GetCellValue(Row,'AGENT_TEL_NO');
			var ADD_USER_NAME = mySheet.GetCellValue(Row,"ADD_USER_NAME"); //요청자
			var ADD_USER_TEL = mySheet.GetCellValue(Row,"ADD_USER_TEL"); //요청자
			var DELY_TO_LOCATION = mySheet.GetCellValue(Row,"DELY_TO_LOCATION"); //배송처
			var BUYER = mySheet.GetCellValue(Row,"BUYER"); //BUYER
			var WMS_GR_QTY = mySheet.GetCellValue(Row,"WMS_GR_QTY"); 
			var WMS_IVK_QTY = mySheet.GetCellValue(Row,"WMS_IVK_QTY"); 
			var st_LEGACY_PO_NO = mySheet.GetCellValue(Row,'LEGACY_PO_NO');
			openSearchPopup('/wmgr/showMasterWmGrWarehousingPop.do','?BUYER_NAME='+BUYER_NAME+'&PO_NO='+PO_NO+'&PO_CREATE_DATE='+PO_CREATE_DATE+'&RD_DATE='+RD_DATE+
					'&INV_NO='+INV_NO+'&STATUS='+STATUS+'&WMS_GR_DATE='+WMS_GR_DATE+'&AGENT='+AGENT+
					'&ADD_USER_NAME='+ADD_USER_NAME+'&DELY_TO_LOCATION='+DELY_TO_LOCATION+'&BUYER='+BUYER+'&DOC_TEXT='+DOC_TEXT+'&ADD_USER_TEL='+ADD_USER_TEL+
					'&ADD_USER_NAME='+ADD_USER_NAME+'&AGENT_NAME='+AGENT_NAME+'&WMS_IVK_QTY='+WMS_IVK_QTY+'&WMS_GR_QTY='+WMS_GR_QTY
					+'&st_type='+st_type+'&AGENT_TEL_NO='+AGENT_TEL_NO+'&st_LEGACY_PO_NO='+st_LEGACY_PO_NO+'&HUB_YN='+HUB_YN, "900,500,no"); 
			popupSel = "masterWmGrWarehousingPop";
		}
	}else if(column == 'IK_NO'){
		if(mySheet.GetCellValue(Row,'IK_NO')!=""){
			var st_type;
			if("출고"==mySheet.GetCellValue(Row,'STATUS_TEXT') || "분할출고" == mySheet.GetCellValue(Row,'STATUS_TEXT') ){
				st_type= "W";
			}else{
				st_type = "X";
			}	
			
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
		    var st_PODT_GR_QTY = mySheet.GetCellValue(Row,'PODT_GR_QTY');
			var st_ware_house_code = document.searchCondition.st_warehouse_code.value;
			openSearchPopup('/wmgi/showMasterWmGiInvoiceNoPop.do','?st_BUYER_NAME='+st_BUYER_NAME+'&st_INV_DATE='+st_INV_DATE+'&st_DELIVERY_DATE='+st_DELIVERY_DATE+'&st_IK_NO='+st_IK_NO
					+'&st_STATUS_TEXT='+st_STATUS_TEXT+'&st_ADD_USER_NAME='+st_ADD_USER_NAME+'&st_ADD_USER_TEL='+st_ADD_USER_TEL+'&st_ADD_USER_ID='+st_ADD_USER_ID+'&st_DELY_TO_LOCATION='+st_DELY_TO_LOCATION+
					'&st_ware_house_code='+st_ware_house_code+'&st_buyer='+st_buyer+'&st_type='+st_type+'&st_PODT_GR_QTY='+st_PODT_GR_QTY , "1000,500,no"); 

		}
	}else if(column == 'DELIVERY_DATE'){
		if(mySheet.GetCellValue(Row,'DELIVERY_DATE')!=""){
			var st_type;
			if("배송확정"==mySheet.GetCellValue(Row,'STATUS_TEXT')  ){
				st_type= "W";
			}else{
				st_type = "X";
			}
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
		    var st_PODT_GR_QTY = mySheet.GetCellValue(Row,'PODT_GR_QTY');
		    var st_MODIFIABLE = mySheet.GetCellValue(Row,'MODIFIABLE');
		    var st_AUTO_GR_YN = mySheet.GetCellValue(Row,'AUTO_GR_YN');
			var st_ware_house_code = document.searchCondition.st_warehouse_code.value;

			openSearchPopup('/wmgi/showMasterWmIvkConfirmDeletePop.do','?st_BUYER_NAME='+st_BUYER_NAME+'&st_INV_DATE='+st_INV_DATE+'&st_DELIVERY_DATE='+st_DELIVERY_DATE+'&st_IK_NO='+st_IK_NO
					+'&st_STATUS_TEXT='+st_STATUS_TEXT+'&st_ADD_USER_NAME='+st_ADD_USER_NAME+'&st_ADD_USER_TEL='+st_ADD_USER_TEL+'&st_ADD_USER_ID='+st_ADD_USER_ID+'&st_DELY_TO_LOCATION='+st_DELY_TO_LOCATION+
					'&st_ware_house_code='+st_ware_house_code+'&st_buyer='+st_buyer+'&st_type='+st_type+'&st_PODT_GR_QTY='+st_PODT_GR_QTY+'&st_MODIFIABLE='+st_MODIFIABLE+'&st_AUTO_GR_YN='+st_AUTO_GR_YN, "1000,500,no"); 
		}
	}else if(column == 'BUYER_ITEM_NO'){
		if(mySheet.GetCellValue(Row, 'BUYER_ITEM_NO') !=""){
			var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
			var BYIT_COMORG_CODE = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
			var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
			var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
			openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ, "800,260,no"); 
		}
	}else 	if(column=="DELY_TO_LOCATION_IMG" ){
		if(mySheet.GetCellValue(Row,'DELY_TO_LOCATION')!=""){
			var DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
			openSearchPopup('/wmco/showMasterWmCoDlvryPop.do','?DELY_TO_LOCATION='+DELY_TO_LOCATION, "500,210,no"); 
			popupSel = "masterWmCoDlvryPop";
		}
	}else if(column=="ADD_USER_IMG" ){
			var st_ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME');
			var st_ADD_USER_TEL = mySheet.GetCellValue(Row,'ADD_USER_TEL');
			var st_POHD_REMARK = mySheet.GetCellValue(Row,'PO_HD_REMARK');
			openSearchPopup('/wmco/showMasterWmCoRequestPop.do','?st_ADD_USER_NAME='+st_ADD_USER_NAME+'&st_ADD_USER_TEL='+st_ADD_USER_TEL+'&st_POHD_REMARK='+st_POHD_REMARK, "500,220,no"); 
			popupSel = "masterWmCoRequestPop";
	}else if(column=="PO_REMARK_IMG" ){
			var PO_REMARK = mySheet.GetCellValue(Row,'PO_REMARK');
			openSearchPopup('/common/remarkBtoAPop.do','?st_btoa_remark='+PO_REMARK, "500,220,no"); 
			popupSel = "remarkBtoA";
	}else if(column=="AGENT_IMG" ){
		if(mySheet.GetCellValue(Row,'AGENT_NAME')!=""){
			 var com_code = mySheet.GetCellValue(Row,'AGENT');
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}else if(column=="DELAY_REMARK_IMG" ){
		var st_DELAY_REMARK = mySheet.GetCellValue(Row,'DELAY_REMARK');
		var st_BUYER = mySheet.GetCellValue(Row,'BUYER');
		var st_PO_NO = mySheet.GetCellValue(Row,'PO_NO');
		openSearchPopup('/wmco/showMasterWmCoDelayPop.do','?st_DELAY_REMARK='+st_DELAY_REMARK+'&st_BUYER='+st_BUYER+'&st_PO_NO='+st_PO_NO, "500,220,no"); 
		popupSel = "masterWmCoDelayPop";
	}else if (column == "IMAGE_KEY_INV_IMG" ){ //  배송증빙 첨부
		var type="IV";
		var viewType="R";
		var image_key =  mySheet.GetCellValue(Row, "IMAGE_KEY_INV");
		var st_buyer =  mySheet.GetCellValue(Row, "BUYER");
		var st_inv_no =  mySheet.GetCellValue(Row, "INV_NO");
		popupSel = "attachDly";
		openSearchPopup('/common/imageFileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType+'&BUYER='+st_buyer+'&INVOICE='+st_inv_no,'500,430,no');// 파일첨부
	}else if(column == "IMAGE_KEY_SIGN_IMG"){ //배송증빙서명
		var type="IV";
		var viewType="R";
		var image_key =  mySheet.GetCellValue(Row, "IMAGE_KEY_SIGN");
		var st_buyer =  mySheet.GetCellValue(Row, "BUYER");
		var st_inv_no =  mySheet.GetCellValue(Row, "INV_NO");
		popupSel = "attachDlySign";
		openSearchPopup('/common/imageFileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType+'&BUYER='+st_buyer+'&INVOICE='+st_inv_no,'500,430,no');// 파일첨부
	}
	
	return;
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>출고진행관리</h3>
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
			
    		<table  class="cont_t_list01" width="940" >
					<caption>진행관리</caption>
					<colgroup>
							<col width="8%" />
							<col width="25%" />
							<col width="10%" />
							<col width="25%" />
							<col width="8%" />
							<col width="25%" />
					</colgroup>
						
					<tbody>
		                <tr> 
		                    <th>
                        <select name="st_dateFlag" class="TitSelect">
                             <option value="IV">출고일</option>
                            <option value="RD">납품요청일</option>
                            <option value="DL">배송확정일</option>
                            <option value="SD">출고예정일</option>
                        </select>
		                    </th>
							<td td colspan="3"> 
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
											<a href="javascript:kepCalendar('st_from_date')"></a> - 
										<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
											<a href="javascript:kepCalendar('st_to_date')"></a>
											&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>		
							</td>
						   <th>물류센터&nbsp;</th>
							<td> 
								<select id="st_warehouse_code" name="st_warehouse_code"  	<%=whAdmin.equals("Y") ? "" : "disabled"%>>
								<%
						 			Map<String, String> _map = new HashMap<String, String>();
						 			_map.put("BUYER",buyer);
						 			_map.put("USERID",userid);
						 			_map.put("whAdmin",whAdmin);
								%>
								<%= CommonUtil.getCodeComboQueryIdList("common.getWareHouseIdSchList","",_map,st_warehouse_code) %>
								</select>
							</td>
							</tr>
						<tr>
						<th><font color="red"><b>*</b></font>고객사</th>
							<td> 
								<input type="text" name="st_buyer_name" id="st_buyer_name" style="width:68%" value="" readonly onclick="javascript:doPop('buyer_s')">
								<a href="javascript:doPop('buyer_single')"><img src="/resources/images/btn_search03.gif"   alt="검색"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif" alt="초기화"></a>  
								<input type="hidden" name="st_buyer_code"  id="st_buyer_code"  value="">
<%-- 								<input type="text" name="st_buyer_name" style="width:80%" value="<%=warehouse_code.equals("KRKORE0160")?"대우조선해양(주)":""%>" readonly> --%>
<%-- 								<a href="javascript:BuyerIkCount('<%=warehouse_code%>','<%=warehouse_agent%>')"><img src="/resources/images/btn_search03.gif" width="18" height="18" align="absmiddle" border="0"></a>  --%>
<%-- 								<input type="hidden" name="st_buyer_code" value="<%=warehouse_code.equals("KRKORE0160")?"KRDAEW0016":""%>"> --%>
							</td>
							<th>발주번호</th>
							<td>  
								<input type="text" name="st_po_no" id="st_po_no"  style="width:87%" value="" onKeyUp="kepToUpper('st_po_no')" onkeydown="kepEnter()">
							</td>
							<th>송장번호</th>
							<td > 
								<input type="text" name="st_ik_no"  id="st_ik_no"  style="width:87%" value="" onKeyUp="kepToUpper('st_ik_no')" onkeydown="kepEnter()">
							</td>							
</tr>	
<tr>
							<th>협력사</th>
							<td>
								<input type="text" name="st_agent_name"  id="st_agent_name"  style="width:68%" value="" readonly>
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
								<input type="hidden" name="st_agent_code"  id="st_agent_code"  value="">
							</td>
							<th>표준/품목코드</th>
							<td >
								<input type="text" name="st_buyer_item_no" id="st_buyer_item_no"  style="width:87%" value="" onkeydown="kepEnter()">
							</td>							
</tr>	
<tr>
					<th>구분</th>
                    <td>
                    	<input type="radio" name="st_process_type" value="1,2,3,9" checked  style="background:no-repeat; border:0"/>
                    	전체
                    	<input type="radio" name="st_process_type" value="2"  style="background:no-repeat; border:0"/>
                    	TR
                    	<input type="radio" name="st_process_type" value="1,3"  style="background:no-repeat; border:0"/>
                    	재고(VMI)
                    	<input type="radio" name="st_process_type" value="9"  style="background:no-repeat; border:0"/>
                    	간선
                    </td>
                    <th >상태</th>
		                    <td >  
		                        <select name = "st_status_text" >
		                            <option value="ALL">전체</option>
		                            <option value="출고예정">출고예정</option>
		                            <option value="분할출고예정">분할출고예정</option>                          
		                            <option value="출고">출고</option>
		                            <option value="분할출고">분할출고</option>                          
		                            <option value="배송확정">배송확정</option>
		                            <option value="간선출고">간선출고</option>
		                        </select>
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
					<option value="200">200건</option>
				</select>
			</span>
			  	<span class="fr">
			     <select name="st_order_by">
                <option value = "1">납품요청일순</option>
                <option value = "2">고객사순</option>
                <option value = "3">협력사순</option>
                <option value = "4">발주번호순</option>
                <option value = "5">입고번호순</option>
                <option value = "6">송장번호순</option>
                <option value = "7">품목코드순</option>
                <option value = "8">배송처순</option>
            </select>
           </span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c;height:320px;">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "", "320px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  	          	<span class="fr">
	  	      	<select name="st_date_gubun" id="st_date_gubun">
	                <option value = "INV_DATE">출고일</option>
	                <option value = "DELIVERY_DATE">배송확정일</option> 
	            </select>
            <input type="text" class="input_type_text" name="st_dlvry_date" id="st_dlvry_date" readOnly style="width:80px; text-align:center;" value="" >
			 
            		<span class="btn_06 mr04"><a href="javascript:doAction('hubReport');">간선패킹리스트</a></span>
  					<span class="btn_06 mr04"><a href="javascript:doAction('report');">패킹리스트출력</a></span>
  					<!-- span class="btn_06 mr04"><a href="javascript:doAction('invoice');">거래명세서출력</a></span-->
  				</span>  				
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
