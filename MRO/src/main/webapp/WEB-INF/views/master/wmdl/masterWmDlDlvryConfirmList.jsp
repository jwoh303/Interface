<%--
**********************************************
* 메뉴 : 배송>배송확정
* 화면 : 배송확정
* 기능 : 배송확정 대상내역 조회
* 프로그램 ID : PG_08_M_007_00
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.util.HashMap"%> 
<%@ page import="java.util.Map"%>


<%
String buyer = "";
String userid = "";
if (_sessionInfo != null){
	buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
	userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
} 
String whAdmin = _sessionInfo.getWhAdmin();

boolean P08_0000005_01 = CommonUtil.getSpecialCheckReturn( buyer,"P08-0000005-01"); 

%> 
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",					SaveName:"SELECTED"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"구분",				SaveName:"PROCESS_TYPE"}
		,{ Align:"Left",	Width:250,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사",				SaveName:"BUYER_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"송장번호",				SaveName:"IK_NO"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"출고일",				SaveName:"INV_DATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"총 품목수",			SaveName:"CNT",	Format:"${qtyFormat}"}
		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float",		Header:"총 금액",				SaveName:"UNIT_AMT",	Format:"${priceFormat}"}
		,{ Align:"Left",	Width:700,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"배송처",				SaveName:"DELY_TO_LOCATION"}
		,{ Align:"Left",	Width:250,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"",					SaveName:"BUYER"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"택배사",				SaveName:"DELIVERY_COMPANY_NM"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"택배사송장번호",		SaveName:"DELIVERY_NO"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"배송증빙첨부",			SaveName:"IMAGE_KEY_INV_IMG",	Sort:0}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Image",		Header:"배송증빙서명",			SaveName:"IMAGE_KEY_SIGN_IMG",	Sort:0}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"자동입고여부",			SaveName:"AUTO_GR_FLAG"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"IMAGE_KEY_SIGN",	SaveName:"IMAGE_KEY_SIGN"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"IMAGE_KEY_INV",		SaveName:"IMAGE_KEY_INV"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"PROCESS_TYPE",		SaveName:"PROCESS_TYPE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"EXE_GR_FLAG",		SaveName:"EXE_GR_FLAG"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"DLVR_ATCH_FLAG",	SaveName:"DLVR_ATCH_FLAG"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(1, diskOn);

	//콤보데이터 셋팅		
	
	//파일첨부이미지설정
	mySheet.SetImageList(2, diskOff);
	mySheet.SetImageList(3, diskOn);
	setLinkCol(mySheet, "IMAGE_KEY_INV_IMG");
	setLinkCol(mySheet, "IMAGE_KEY_SIGN_IMG");
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NAME");	
	setLinkCol(mySheet, "IK_NO");	
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	kepSetCalender("st_dlvry_date");
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepToMonthAdd("1","P"));
	$("#st_dlvry_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	$("#st_backDate").val( kepToDateAdd(7,"M","noslash"));
	
	if(document.searchCondition.st_warehouse_code.options.length == 1 ){
		document.searchCondition.st_warehouse_code.disabled = true;
		
		if("KRKORE0160"==document.searchCondition.st_warehouse_code.value){
			$("#st_buyer_code").val("KRDAEW0016");
			$("#st_buyer_name").val("대우조선해양(주)");
		}
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
	switch (str) {
		case "search":	// 조회
			if(kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val())== false){
				return;
			}
			
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n3개월 이상의 데이타는 S/R 요청 바랍니다.");
				return;
			}
			
			if(document.getElementById("chk_except_flag").checked == true){
				$("#st_chk_except_flag").val('Y');
			}else{
				$("#st_chk_except_flag").val('N');
			}
			
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/wmdl/getMasterWmDlDlvryConfirmList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			kepReload('searchConditionB');
			mySheet.RemoveAll();
			
			// 조회조건 초기화
			kepSetCalender("st_from_date");
			kepSetCalender("st_to_date");
			kepSetCalender("st_dlvry_date");
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepToMonthAdd("1","P"));
			$("#st_dlvry_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
			$("#st_chk_except_flag").val('Y');
			break;

		case "saveDlv":
	    	var delivery_company = document.searchConditionB.delivery_company.value;
	    	var delivery_no =document.searchConditionB.st_delivery_no.value;
	    
			if((delivery_company == "JIKNAB" || delivery_company == "CENTER")){
		    	alert("직접배송 혹은 허브센터는 택배사저장 대상이 아닙니다.");
	    		return;
        	}
	    	
			if(selectedGrid.length == 0){
	        	alert(" 택배사 저장 대상을 선택해 주십시요.");
	        	return;
	    	}

			if(selectedGrid.length > 1 ){
				alert("택배사 저장 대상은 한건만 선택 가능 합니다.");
				return;
			}
			
			if((delivery_company != "JIKNAB" && delivery_company != "CENTER")){
				if( delivery_no == "" ){
					alert("운송장 번호를 입력하여 주십시요.");
					document.searchConditionB.st_delivery_no.focus();
					return;
				}
				
				if(delivery_company == "D002" && delivery_no.length <8){
					alert("대신택배인 경우는 운송장번호가 8자리 이상이어야 합니다.");
					return;
				}
			}
			
			if(!confirm("택배사 저장을 하시겠습니까?")) {
	        	return;
	        }else{
	        	document.searchCondition.st_delivery_company.value = document.searchConditionB.delivery_company.value;
	        	document.searchCondition.st_delivery_no.value = document.searchConditionB.st_delivery_no.value;
	        	kepSave(document.searchCondition ,  mySheet , "/wmdl/saveMasterWmDlDlvryCenter.do" , "SELECTED" );
	        }
			break;
		case "save": // 저장
			if(selectedGrid.length == 0){
	        	alert(" 배송확정 대상을 선택해 주십시요.");
	        	return;
	        }
		
			var delivery_company = document.searchConditionB.delivery_company.value;
		    var delivery_no =document.searchConditionB.st_delivery_no.value;
		    if((delivery_company != "JIKNAB" && delivery_company != "CENTER")){
		    	if( delivery_no == "" ){
		    		alert("운송장 번호를 입력하여 주십시요.");
		    		document.searchConditionB.st_delivery_no.focus();
		    		return;
		    	}
		    }
		    
		    var delivery_date = (document.searchConditionB.st_dlvry_date.value).replace(/[/]/gi,"");
		    var backDate = document.searchCondition.st_backDate.value;
		    
		    if(eval(delivery_date) <=eval(backDate)){
		    	alert("현재일에서 7일 이전으로 배송확정 하실수 없습니다");
		    	return;
		    }
		    
		    for(var i=1; i<=mySheet.RowCount(); i++){
		    	if(mySheet.GetCellValue(i, "SELECTED") == 1){
		    		var PARCEL_INFO = mySheet.GetCellValue(i, "DELIVERY_COMPANY_NM");
		    		var AUTO_GR_FLAG = mySheet.GetCellValue(i, "AUTO_GR_FLAG");
		    		var IMAGE_KEY_INV = mySheet.GetCellValue(i, "IMAGE_KEY_INV");
		    		var INV_NO = mySheet.GetCellValue(i, "IK_NO");
		    		var IMAGE_KEY_SIGN = mySheet.GetCellValue(i, "IMAGE_KEY_SIGN");
		    		var BUYER_NAME = mySheet.GetCellValue(i, "BUYER_NAME");
		    		var DLVR_ATCH_FLAG = mySheet.GetCellValue(i, "DLVR_ATCH_FLAG");
		    		var DELIVERY_NO = mySheet.GetCellValue(i, "DELIVERY_NO");
		    		
		    		// 택배 송장번호 있는 경우 택배사 저장으로 등록할 수 있도록 안내
		    		if(PARCEL_INFO != "" || DELIVERY_NO != "") {
		    			alert("이미 택배사 송장번호가 등록되어있습니다.\n수정이 필요한 경우 택배사 저장 버튼으로 수정 바랍니다.");
		    			return;
		    		}
					
		    		/*
					고객사 옵션이 자동입고 로직
					1. 직납일때만 첨부기능.(협력사)
					2. 택배송장번호 입력건은 배송증빙처리 불필요
					3. 택번거 이외 모든건 배송증빙 처리 해야함
					
					DLVR_ATCH_FLAG = P07-0000031 배송증빙 필수 고객사
					*/
					if(AUTO_GR_FLAG =="Y" || DLVR_ATCH_FLAG == "Y"){
						if(PARCEL_INFO =="" || PARCEL_INFO == null){
							if(IMAGE_KEY_INV==""&&IMAGE_KEY_SIGN==""){
								alert("고객사: "+BUYER_NAME+ " 거래명세서번호: "+INV_NO+"\n배송완료 증빙 처리 바랍니다.");
								return;
							}
							
							if(AUTO_GR_FLAG == "Y"){
								mySheet.SetCellValue(i, "EXE_GR_FLAG", "Y");
							}else{
								mySheet.SetCellValue(i, "EXE_GR_FLAG", "N");
							}
						}else{
							mySheet.SetCellValue(i, "EXE_GR_FLAG", "N");
						}
					}else{
						mySheet.SetCellValue(i, "EXE_GR_FLAG", "N");
					}
		    	}
		    }
		    
		    if(!confirm("배송확정을 하시겠습니까?")){
		    	return;
		    }else{
		    	document.searchCondition.st_delivery_date.value = document.searchConditionB.st_dlvry_date.value;
		    	document.searchCondition.st_delivery_company.value = document.searchConditionB.delivery_company.value;
		    	document.searchCondition.st_delivery_no.value = document.searchConditionB.st_delivery_no.value;
		    	kepSave(document.searchCondition ,  mySheet , "/wmdl/saveMasterWmDlDlvryConfirmList.do" , "SELECTED" );
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
   	
	if (msg != "") {
		alert(msg);
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
	
	if (code == 1) {
		alert("정상적으로 배송확정 되었습니다.");
		//저장 성공시 재조회
		kepReload('searchConditionB');
		kepSetCalender("st_dlvry_date");
		doAction('search');
	}else if(code == 2){
		alert("정상적으로 택배사저장이 되었습니다.");
		kepReload('searchConditionB');
		kepSetCalender("st_dlvry_date");
		$("#st_dlvry_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		doAction('search');
		window.open( msg, "택배사조회", "width=1000,height=800,resizable=YES,top=0,left=0");
	}else if(code == 3){
		alert("택배저장에 실패 하였습니다.\n\n본사 시스템운영팀으로 연락바랍니다");
		return;
	}else{
		alert("배송확정이 실패 하였습니다.\n\n본사 시스템운영팀으로 연락바랍니다");
		return;
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmdl/getMasterWmDlDlvryConfirmList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
	case "buyer_s": // 고객사 M
	    var ware_house_code = document.searchCondition.st_warehouse_code.value;
	    var st_from_date = document.searchCondition.st_from_date.value;
	    var st_to_date = document.searchCondition.st_to_date.value;
	    openSearchPopup('/wmco/showMasterWmCoMbrcmpyCountSinglePop.do','?ware_house_code='+ware_house_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date , "500,500,no"); 
        popupSel = "buyer_s";
        break;
	case "buyer_sel": // 고객사 M
		//var st_warehouse_code = "<%=CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"") %>";	
		//openSearchPopup("/wmdl/showMasterDlCommpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
		
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
        popupSel = "buyer_sel";
        break;	        
	}
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
	}else if(column == 'IK_NO'){
		if(mySheet.GetCellValue(Row,'IK_NO')!=""){
			var st_buyer = mySheet.GetCellValue(Row,'BUYER');
			var st_warehouse_code = document.searchCondition.st_warehouse_code.value;
			var st_ik_no = mySheet.GetCellValue(Row,'IK_NO');
			openSearchPopup('/wmdl/showMasterWmDlInvoiceNoPop.do','?st_warehouse_code='+st_warehouse_code+'&st_buyer='+st_buyer+'&st_ik_no='+st_ik_no, "800,500,no"); 
			popupSel = "masterWmDlInvoiceNoPop";
		}
	}else if (column == "IMAGE_KEY_INV_IMG" ){ //  배송증빙 첨부
		var type="IV";
		var viewType="VI";
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

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_s") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}
	
	if (popupSel == "buyer_sel") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}else if (popupSel == "attachDly") {	//이미지첨부
		mySheet.SetCellValue(grbRow, 'IMAGE_KEY_INV', value1);
		mySheet.SetCellValue(grbRow, 'IMAGE_KEY_INV_IMG', (value1!='')? diskOn : diskOff);
	}else  if (popupSel == "buyer_multi") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}
	grbRow="";	//초기화
}

//barcode reader
function fnCheckInputBacode(obj){
	$('#st_ivk_no_barcode').val($('#st_ivk_no_barcode').val()+",");
}

//barcode display
function fnBarcodeDisplay(obj){
	if(obj == "hide"){
		document.getElementById('hidebarcode').style.display = "block";  
		document.getElementById('showbarcode').style.display = "none";  
		$('#st_ivk_no').val('');
	}
	
	if(obj == "show"){
		$('#st_ivk_no_barcode').val('');
		document.getElementById('hidebarcode').style.display = "none";  
		document.getElementById('showbarcode').style.display = "block";  
	}
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>배송확정</h3>
		<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
		<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   	</div>
   	
   	<!--조회영역-->
   	<form name = "searchCondition" method = "post" onsubmit="return false">
   		<div id="cont_searchA">
	   		<!--HIDDEN-->
	   		<!-- 공통 -->
   			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">			
			<input type="hidden" id="st_backDate" name="st_backDate"  value="">
			<input type="hidden" id="st_delivery_date" name="st_delivery_date"  value="">
			<input type="hidden" id="st_delivery_company" name="st_delivery_company"  value="">
			<input type="hidden" id="st_delivery_no" name="st_delivery_no"  value="">
			<input type="hidden" id="st_chk_except_flag" name="st_chk_except_flag" value ="Y">
			
			<table class="cont_t_list01" width="940px;">
				<caption>배송확정</caption>
				<colgroup>
					<col width="10%" />
					<col width="35%" />
					<col width="12%" />
					<col width="35%" />
				</colgroup>
				
				<tbody>
					<tr>
						<th>출고일</th>
						<td>
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
							<a href="javascript:kepCalendar('st_from_date')"></a> -
							<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
							<a href="javascript:kepCalendar('st_to_date')"></a>
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
						</td>
						
						<th>고객사</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:50%"value="" readonly onclick="javascript:doPop('buyer_sel');">
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
							<a href="javascript:doPop('buyer_s');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							&nbsp;
							<input type="checkbox" class="Noborder" name="chk_except_flag" id="chk_except_flag" checked>&nbsp;입력 대상 건
						</td>
						
						<th>
							
						</th>
					</tr>
					
					<tr>
						<th>물류센터</th>
						<td>
							<select id="st_warehouse_code" name="st_warehouse_code"  style="width:65%" 	<%=whAdmin.equals("Y") ? "" : "disabled"%>>
								<%
									Map<String, String> _map = new HashMap<String, String>();
									_map.put("BUYER",buyer);
									_map.put("USERID",userid);
									_map.put("whAdmin",whAdmin);
								%>
								<%= CommonUtil.getCodeComboQueryIdList("common.getWareHouseIdSchList","",_map,"") %>
							</select>
						</td>
						
						<th>
							<select name="barcodeFlag" class="TitSelect" onchange="fnBarcodeDisplay(this.value);" style="width:90%" >
								<option value="hide">송장번호</option>
								<option value="show">송장번호바코드</option>
							</select>
						</th>
						<td>
							<div name="hidebarcode" id="hidebarcode"><input type="text" class="input_type_text" id="st_ivk_no" name="st_ivk_no" style="width:95%" value="" onkeyup="kepToUpper('st_ivk_no')" ></div>
							<div name="showbarcode" id="showbarcode" style="display:none;"><input type="text" class="input_type_text" id="st_ivk_no_barcode" name="st_ivk_no_barcode" style="width:95%" value="" onkeydown="if(event.keyCode == 13) JavaScript:fnCheckInputBacode(this);" ></div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
			<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" style="width: 70px;" >
				<option value="10" >10건</option>
				<option value="20">20건</option>
				<option value="30">30건</option>
				<option value="40">40건</option>
				<option value="50">50건</option>
				<option value="100" selected>100건</option>
			</select>
			
			<font color="RED">※ 택배출고는 송장 입력 시 시스템 상 배송흐름 조회 후 자동 실적등록(배송확정 처리 불필요)</font>
		</div>
		
		<div class="fr">
			<label for="b_no02" class="hidden">정렬기준</label>
			<select name="st_order_by"  id="st_order_by" style="width:90px;" >
				<option value="IV_DATE">출고일순</option>
				<option value="BUYER">고객사순</option>
				<option  value="IK_NO">송장번호순</option>
			</select>
		</div>
	</form>
	
	<br>
	
	<!--grid-->
	<div class="ib_product" style="border-top:2px solid #3c639c">
		<script type="text/javascript">
			createIBSheet("mySheet", "100%", "354px");
		</script>
	</div>
	
	<p class="paging" id="pageindex"></p>
	
	<!--버튼영역-->
	<form name = "searchConditionB" method = "post" onsubmit="return false" >
		<div class="btnArea">
			<span class="fl">
				<select  name="delivery_company" id="delivery_company">
					<%= CommonUtil.getCodeComboQueryIdList("common.getDeliveryCompany","NO","st_delivery_company") %>
				</select>
				
				<input type="text" name="st_delivery_no" id="st_delivery_no" style="width:150px" value="">
				<span class="btn_06 mr04""><a href="javascript:doAction('saveDlv');">택배사 저장</a></span>
  			</span>
  			<span class="fr">
  				<span class="text11">배송확정일 : </span>
  				<input type="text" class="input_type_text" name="st_dlvry_date" id="st_dlvry_date" readOnly style="width:80px; text-align:center;" value="" onChange="javascript:getDayList()">
  				<a href="javascript:kepCalendar('st_dlvry_date')"></a>
  				
  				<span class="btn_04 mr04"">
  					<a href="javascript:doAction('save');">배송확정</a>
  				</span>
  			</span>
  		</div>
  	</form>
<!--내용 종료-->	                 
</body>
</html>