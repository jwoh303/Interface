<%--
**********************************************
* 메뉴 : 출고>출고지시 및 거래명세표
* 화면 : 출고지시 및 거래명세표
* 기능 : 출고예정정보 확인 및 출고지시 생성하고, 납품지시서 출력
* 프로그램 ID : PG_08_M_006_00
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-
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
	
	String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_po_user_id"),""); 
	
	boolean P08_0000005_01 = CommonUtil.getSpecialCheckReturn( userid,"P08-0000005-01"); 
	 
	String whAdmin = _sessionInfo.getWhAdmin();
%> 
<script src="/resources/js/common.js"></script>
<script src="/resources/js/wms_tr_sheet.js"></script> 
<script>
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var LocationOn = "/resources/images/btn_search03.gif";
var agentImg = "/resources/images/btn_search03.gif";
var P08_0000005_01 ;
//	double iv_qty	  = Double.parseDouble(rowData.get("rtobj_d[4]));
//	double avail_qty  = Double.parseDouble(rowData.get("rtobj_d[35]));
// 						if(!String.valueOf(rtobj_d[32]").equals("X")){
// 						<a href="javascript:getSysopCatalogDisplayPop('Data.get("rtobj_d[24]")%>', 'Data.get("rtobj_d[12]")%>','Data.get("rtobj_d[25]")%>','Data.get("rtobj_d[26]")%>');">Data.get("rtobj_d[12]")%></a>
// 						}else if(!rowData.get("rtobj_d[34])).equals("0")){
// 						<a href="javascript:getItemimgPop('Data.get("rtobj_d[34]")%>', 'Data.get("rtobj_d[33]")%>');">Data.get("rtobj_d[12]")%></a>
// 						}else{
// 						Data.get("rtobj_d[12]")%>

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
						 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
							,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : true,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
							,{ Align:"Center",	Width:80,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"구분",	SaveName:"GUBUN_TEXT"}
							,{ Align:"Left",	Width:160,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
							
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"발주번호",	SaveName:"PO_NO"}
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"LEGACY_NO",	SaveName:"LEGACY_PO_NO"}
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"입고번호",	SaveName:"INV_NO"}
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"요청번호",	SaveName:"PR_NO"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"묶음배송",	SaveName:"DELY_BUNDLE_FLAG"}
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Date",Format:"Ymd",	Header:"납품요청일",	SaveName:"RD_DATE"}
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Date",Format:"Ymd",	Header:"출고예정일",	SaveName:"SCHEDULED_DATE"}
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Date",Format:"Ymd",	Header:"출고일자",	SaveName:"IVK_DATE"}

							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"협력사",	SaveName:"AGENT_IMG"}
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : true,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}	
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : true,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_TEL_NO"}	
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : true,	Type:"Text",	Header:"협력사",	SaveName:"AGENT"}	

							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"표준코드",	SaveName:"STDCATLG_ID"}
							,{ Align:"Center",	Width:150,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
							,{ Align:"Left",	Width:150,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
							,{ Align:"Left",	Width:200,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
							
							,{ Align:"Right",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type : "Float", Format:"${qtyFormat}",	Header:"발주수량",	SaveName:"PO_QTY"}
							,{ Align:"Right",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type : "Float", Format:"${qtyFormat}",Header:"입고(재고)수량",	SaveName:"WMS_GW_QTY1"}
							,{ Align:"Right",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type : "Float", Format:"${qtyFormat}",	Header:"출고수량",	SaveName:"WMS_GW_QTY"}
							,{ Align:"Right",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type : "Float", Format:"${qtyFormat}",Header:"기출고(지시)수량",	SaveName:"IV_QTY"}
							
							,{ Align:"Center",	Width:60,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
							,{ Align:"Right",	Width:100,	Edit : false,	EditLen:100,	Hidden : true,	Type : "Float", Format:"${priceFormat}",	Header:"출고단가",	SaveName:"UNIT_PRICE"}
							,{ Align:"Right",	Width:100,	Edit : false,	EditLen:100,	Hidden : true,	Type : "Float", Format:"${priceFormat}",	Header:"출고금액",	SaveName:"WMS_IVK_AMT"}
							
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"요청자",	SaveName:"ADD_USER_IMG"}
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : true,	Type:"Text",	Header:"요청자명",	SaveName:"ADD_USER_NAME"}
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : true,	Type:"Text",	Header:"요청자전화번호",	SaveName:"ADD_USER_TEL"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"배송처",	SaveName:"DELY_TO_LOCATION_IMG"}
							
							,{ Align:"Left",	Width:250,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"비고",	SaveName:"PO_REMARK"}	
							,{ Align:"Left",	Width:250,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"보급소",	SaveName:"ISS_REQ_LOC_NAME"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"BYIT_COMORG_CODE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"CONTRACT_NO"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"CONTRACT_SEQ"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"HD_REMARK"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"BUYER"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"DOC_TEXT"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"AVAIL_QTY"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Date",Format:"Ymd",	Header:"", SaveName:"WMS_GR_DATE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Date",Format:"Ymd",	Header:"", SaveName:"PO_CREATE_DATE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"IMG_NO"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"DOC_TYPE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"PROCESS_TYPE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ST_CART_QTY", SaveName:"ST_CART_QTY"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"PROCESS_TEXT_LEGACY"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"GUBUN"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"AGENT_CODE"}
							,{ Align:"Left",	Width:100,	Edit : false,	EditLen:100,	Hidden :true,	Type:"Text",	Header:"구분",	SaveName:"PROCESS_TEXT"}
							,{ Align:"Left",	Width:100,	Edit : false,	EditLen:100,	Hidden :true,	Type:"Text",	Header:"구분",	SaveName:"KTAG_USE_FLAG"}
							,{ Align:"Center",	Width:120,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"발주일시",	SaveName:"PODT_ADD_DATE"}
							,{ Align:"Left",	Width:500,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"배송처",	SaveName:"DELY_TO_LOCATION"}
							,{ Align:"Center",	Width:80,	Edit : false,	EditLen:100,	Hidden :true,	Type:"Text",	Header:"간선여부",	SaveName:"HUB_YN"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:2};
	IBS_InitSheet(mySheet, initsheet,pagingMode,'XLS');

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);
	mySheet.SetImageList(2, LocationOn);
	mySheet.SetImageList(3, agentImg);
	
	//콤보데이터 셋팅		
	var serch_text = "st_user_id="+document.searchCondition.st_user_id.value+"&st_com_code="+document.searchCondition.st_com_code.value;
	


	//하이퍼링크 설정
	setLinkCol(mySheet, "DELY_TO_LOCATION_IMG"); 
	setLinkCol(mySheet, "AGENT_IMG");
	setLinkCol(mySheet, "ADD_USER_IMG");
	setLinkCol(mySheet, "ISS_REQ_LOC_NAME");
	setLinkCol(mySheet, "INV_NO");
	setLinkCol(mySheet, "PO_NO");
	setLinkCol(mySheet, "PR_NO");
	setLinkCol(mySheet, "LEGACY_PO_NO");
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "BUYER_NAME");
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	kepSetCalender("st_scheduled_from_date");
	kepSetCalender("st_scheduled_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepToMonthAdd("1","P"));
	
	//삭제
	 //  document.searchCondition.st_buyer_code.value = "KRDOOD0001";
	
	if(document.searchCondition.st_warehouse_code.options.length == 1 )
	{
		document.searchCondition.st_warehouse_code.disabled = true;
		if("KRKORE0160"==document.searchCondition.st_warehouse_code.value){
			$("#st_buyer_code").val("KRDAEW0016");
			$("#st_buyer_name").val("대우조선해양(주)");
			
		}
	}
	
	//엑셀다운로드 sheet
	var initsheet2 = {};
	initsheet2.Cols = [  
	    			{Align : "Left",	Header : "고객사코드",	SaveName:"BUYER_CODE",	Type : "Text",	Width : 85,		EditLen : 110,	Hidden:false, Edit : false},
	    			{Align : "Left",	Header : "고객사명",	SaveName:"BUYER",		Type : "Text",	Width : 205,	EditLen : 20,	Hidden:false, Edit : false},
	    			{Align : "Right",	Header : "TR출고건수",  SaveName:"TRCOUNT",		Type : "Text",	Width : 70, 	EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",	Header : "재고출고건수",	SaveName:"STCKCOUNT", 	Type : "Text",	Width : 70, 	EditLen : 110,	Edit : false, Hidden : false}
	];
	
	IBS_InitSheet(mySheet2, initsheet2,pagingMode);
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");


	switch (str) {
	case "search":	 // 조회
		if(kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val())== false){
			return;
		}
		//기간무시
	    if(document.getElementById("st_checkbox").checked == true){
	    	$("#st_all_po").val('Y');		
	    	var po_no			= $("#st_po_no").val();
	    	var iv_no			= $("#st_inv_no").val();
			if( po_no =="" && iv_no == ""){
				alert("기간을 무시하고 조회시\n\n고객사 선택후\n\n발주번호, 입고번호 중\n\n한가지 이상을 정확히(전체입력) 기입해야 합니다.");	
				return;
			}			
		}else{
			$("#st_all_po").val('N');
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 186 ){
				alert("조회기간을 6개월 단위로 조회가 가능합니다.\n\n6개월 이상의 데이타는 S/R 요청 바랍니다.");
				return ;
			} 
		}

		if( ($("#st_scheduled_from_date").val() != "" &&  $("#st_scheduled_to_date").val() =="")
				|| ($("#st_scheduled_from_date").val()  == "" &&  $("#st_scheduled_to_date").val()  !="") ){
			alert('출고예정일의 시작일과 종료일을 함께 입력 하셔야 합니다.');
			return;
		}
		if(document.searchCondition.st_buyer_code.value == '' && document.searchCondition.gubun.value != 'HUB'){
			alert('고객사를 선택 하셔야 합니다');
			return;
		}

	    current_page = -1;

		kepSearch(document.searchCondition,  mySheet , "/wmgi/getMasterWmGiReleaseDirectionsTranList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepToMonthAdd("1","P"));
		kepEraser('st_scheduled_from_date','st_scheduled_to_date');
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		break;

		
	case "cart": 
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
 	 	var arrRow = selectedGrid.split("|");
 	 	var itemCount = 0;
 	 	var isStck = 'true';
 	    if(mySheet.GetTotalRows() ==0){
 			alert('조회된 제품이 없습니다');
 			return;
 	    }
 	 	if(selectedGrid.length == 0)
 	 	{
 	        alert(" 장바구니에 담을 제품을 선택 하세요.");
 	        return;
 	 	}
 	 	for(var i = 0 ; i <arrRow.length; i++){
 	 		if(mySheet.GetCellValue(arrRow[i],'PROCESS_TYPE') == "2"){
 	 			isStck = 'false';
 	 		}else{
				itemCount++;
			}
 	 	}
 		if(isStck == 'false'){
 			if(!confirm('재고/VMI 제품이 아닌것이 있습니다.\n계속 하시겠습니까')){
 				return;
 			}
 		}

 		if(itemCount == 0){
 			alert('선택한 제품들 중에 재고/VMI 제품이 없습니다');
 			return;
 		}
	    var ware_house_code = document.searchCondition.st_warehouse_code.value;
	    var st_STDCATLG_ID_arr ="";
	    var st_ST_CART_QTY_arr ="";
		for(var i = 0 ; i <arrRow.length; i++){
			
			st_STDCATLG_ID_arr = st_STDCATLG_ID_arr + mySheet.GetCellValue(arrRow[i], "STDCATLG_ID")+"@";
			st_ST_CART_QTY_arr = st_ST_CART_QTY_arr + mySheet.GetCellValue(arrRow[i], "STDCATLG_ID")+"," + mySheet.GetCellValue(arrRow[i], "ST_CART_QTY")+"@";
	
		}
		//alert(st_STDCATLG_ID_arr)
 		openSearchPopup('/wmgi/showMasterWmGiCartRegPop.do','?st_warehouse_code='+ware_house_code+'&st_STDCATLG_ID_arr='+st_STDCATLG_ID_arr+"&st_ST_CART_QTY_arr="+st_ST_CART_QTY_arr, "1000,400,no"); 
		popupSel = "masterWmGiCartRegPop";
		break;
		
	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
		var param = {FileName:"고객사별출고건수.xlsx"};
		kepDownExcel(document.searchCondition ,mySheet2 , "/wmgi/excelMasterWmGiBuyerReleaseList.do", param);
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

	

	var infoVal = {HoverUnderline:true, ImgWidth:"15px",ImgHeight:"15px"};

	for(var  i= 1 ; i<mySheet.GetTotalRows()+1 ;  i++)
	{
		if(mySheet.GetCellValue(i,"DELY_TO_LOCATION")!="")
		{
			mySheet.SetCellValue(i, 'DELY_TO_LOCATION_IMG', LocationOn);
		}
		if(mySheet.GetCellValue(i,"AGENT_NAME")!="")
		{
			mySheet.SetCellValue(i, 'AGENT_IMG', agentImg);
		}
		mySheet.SetCellValue(i, 'ADD_USER_IMG', agentImg);
		if(eval(mySheet.GetCellValue(i,"WMS_GW_QTY")) > eval(mySheet.GetCellValue(i,"AVAIL_QTY")) ){
			
			mySheet.SetCellFontColor(i,"WMS_GW_QTY","#FF0000") ;
			mySheet.SetCellFontBold(i, "WMS_GW_QTY", 1);
		}
		if((eval(mySheet.GetCellValue(i,"WMS_GW_QTY"))-eval(mySheet.GetCellValue(i,"AVAIL_QTY")) ) >0 ){
			mySheet.SetCellValue(i,"ST_CART_QTY",eval(mySheet.GetCellValue(i,"WMS_GW_QTY"))-eval(mySheet.GetCellValue(i,"AVAIL_QTY")));
	
		}else{
			mySheet.SetCellValue(i,"ST_CART_QTY",mySheet.GetCellValue(i,"WMS_GW_QTY"));
		}
		
	}
	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}
	


// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiReleaseDirectionsTranList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "masterWmCoMbrcmpyIKPop": 
		    var ware_house_code = document.searchCondition.st_warehouse_code.value;
		    var st_from_date = document.searchCondition.st_from_date.value;
		    var st_to_date = document.searchCondition.st_to_date.value;
		    var date_type = document.searchCondition.st_date_type.value;
		    openSearchPopup('/wmco/showMasterWmCoMbrcmpyNewIKPop.do','?st_warehouse_code='+ware_house_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date+'&date_type='+date_type, "400,500,no"); 
			popupSel = "masterWmCoMbrcmpyIKPop";
			break;
			
		case "agent_multi": // 협력사 M
			openSearchPopup('/coco/showCommonCoCoCompanyPop.do','?com_type=S&multi_flag=M&safety_flag=undefined&save_flag=undefined', "500,500,no"); 
			popupSel = "agent_multi";
			break;		
		case "buyer_s": // 고객사 M
			//var st_warehouse_code = "<%=CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"") %>";	
			//openSearchPopup("/wmdl/showMasterDlCommpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
			
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
	        popupSel = "buyer_s";
	        break;
		
		case "multiInvoice": // 다중출고지시
			if(document.searchCondition.st_buyer_code.value == ''){
				alert('고객사를 선택하여 대상건을 조회 후 사용해주세요.');
				return;
			}
		
			if(mySheet.GetCellValue(1,"BUYER") == "-1"){
				alert("대상건을 먼저 조회 후 사용해주세요.");
				return;
			}
			
			if(mySheet.GetCellValue(1,"BUYER") != document.searchCondition.st_buyer_code.value){
				alert("대상건을 먼저 조회 후 사용해주세요.");
				return;
			}

			// 조회된 첫 행의 정보 사용(조회조건만 따로 변경 가능성 고려)
			var st_buyer = mySheet.GetCellValue(1,"BUYER");
			var st_buyer_name = mySheet.GetCellValue(1,'BUYER_NAME');
			
			var st_warehouse_code = document.searchCondition.st_warehouse_code.value;
			var st_date_type = document.searchCondition.st_date_type.value;
			var st_from_date = document.searchCondition.st_from_date.value;
			st_from_date = st_from_date.replaceAll("/","");
			var st_to_date = document.searchCondition.st_to_date.value;
			st_to_date = st_to_date.replaceAll("/","");
			
			openSearchPopup('/wmgi/showMasterWmGiMultiReleaseTransPop.do','?st_buyer='+st_buyer+'&st_buyer_name='+st_buyer_name+'&st_warehouse_code='+st_warehouse_code+'&st_date_type='+st_date_type+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date, "1350,570,no");		
	        popupSel = "masterWmGiMultiReleaseTransPop";
	        
	        break;
	        
		case "hubMultiInvoice": // 간선다중출고지시
			var st_warehouse_code = document.searchCondition.st_warehouse_code.value;
			var st_warehouse_name = document.searchCondition.st_warehouse_code.options[document.searchCondition.st_warehouse_code.selectedIndex].text;
			var st_date_type = document.searchCondition.st_date_type.value;
			var st_from_date = document.searchCondition.st_from_date.value;
			st_from_date = st_from_date.replaceAll("/","");
			var st_to_date = document.searchCondition.st_to_date.value;
			st_to_date = st_to_date.replaceAll("/","");
			
			openSearchPopup('/wmgi/showMasterWmGiMultiHubReleaseTransPop.do','?st_warehouse_code='+st_warehouse_code+'&st_warehouse_name='+st_warehouse_name+'&st_date_type='+st_date_type+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date, "1350,570,no");		
	        popupSel = "masterWmGiMultiHubReleaseTransPop";
	        
	        break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

 	if(column=="DELY_TO_LOCATION_IMG" )
	{
		if(mySheet.GetCellValue(Row,'DELY_TO_LOCATION')!="")
		{
			var DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
			openSearchPopup('/wmco/showMasterWmCoDlvryPop.do','?DELY_TO_LOCATION='+DELY_TO_LOCATION, "500,210,no"); 
			popupSel = "masterWmCoDlvryPop";
		}
	}
 	else  	if(column=="AGENT_IMG" )
	{
		if(mySheet.GetCellValue(Row,'AGENT_NAME')!="")
		{
			 var com_code = mySheet.GetCellValue(Row,'AGENT');
			 var st_from_date = document.searchCondition.st_from_date.value;
			 var st_to_date = document.searchCondition.st_to_date.value;
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}
 	else if(column=="BUYER_NAME"){
		if(mySheet.GetCellValue(Row,'BUYER_NAME')!="")
		{
			 var com_code = mySheet.GetCellValue(Row,'BUYER');
			 var st_from_date = document.searchCondition.st_from_date.value;
			 var st_to_date = document.searchCondition.st_to_date.value;
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
 		
 	}else if(column=="ADD_USER_IMG" )
	{
		if(mySheet.GetCellValue(Row,'ADD_USER_NAME')!="")
		{
			var st_ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME');
			var st_ADD_USER_TEL = mySheet.GetCellValue(Row,'ADD_USER_TEL');
			var st_POHD_REMARK = mySheet.GetCellValue(Row,'HD_REMARK');
			openSearchPopup('/wmco/showMasterWmCoRequestPop.do','?st_ADD_USER_NAME='+st_ADD_USER_NAME+'&st_ADD_USER_TEL='+st_ADD_USER_TEL+'&st_POHD_REMARK='+st_POHD_REMARK, "800,220,no"); 
			popupSel = "masterWmCoRequestPop";
		}
	}	
 	else  	if(column=="ISS_REQ_LOC_NAME" )
	{
		if(mySheet.GetCellValue(Row,'ISS_REQ_LOC_NAME')!="")
		{
			var st_BUYER = mySheet.GetCellValue(Row,'BUYER');
			var st_BUYER_NAME = mySheet.GetCellValue(Row,'BUYER_NAME');
			var st_ISS_REQ_LOC_NAME = mySheet.GetCellValue(Row,'ISS_REQ_LOC_NAME');
			var st_ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME');
			var st_warehouse_code = document.searchCondition.st_warehouse_code.value;
			openSearchPopup('/wmgi/showMasterWmGiDstbtrPop.do','?st_buyer='+st_BUYER+'&st_bugup='+st_ISS_REQ_LOC_NAME+'&st_warehouse_code='+st_warehouse_code+'&st_BUYER_NAME='+st_BUYER_NAME+'&st_ADD_USER_NAME='+st_ADD_USER_NAME, "1000,500,no"); 
			popupSel = "masterWmGiDstbtrPop";
		}
	}else if(column=='INV_NO'){
		
		if(mySheet.GetCellValue(Row,'INV_NO')!=""){
			var st_BUYER = mySheet.GetCellValue(Row,'BUYER');
			var st_PO_NO = mySheet.GetCellValue(Row,'PO_NO');
			var st_INV_NO = mySheet.GetCellValue(Row,'INV_NO');
			var st_PO_CREATE_DATE = mySheet.GetCellText(Row,'PO_CREATE_DATE');
			var st_RD_DATE = mySheet.GetCellText(Row,'RD_DATE');
			var st_RD_DATE_value = mySheet.GetCellValue(Row,'RD_DATE');
			var st_warehouse_code = document.searchCondition.st_warehouse_code.value;
			var st_BUYER_NAME = mySheet.GetCellValue(Row,'BUYER_NAME');
			var st_PROCESS_TEXT = mySheet.GetCellValue(Row,'PROCESS_TEXT');
			var st_DOC_TEXT = mySheet.GetCellValue(Row,'DOC_TEXT');
			var st_ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME');
			var st_ADD_USER_TEL = mySheet.GetCellValue(Row,'ADD_USER_TEL');
			var st_WMS_GR_DATE = mySheet.GetCellText(Row,'WMS_GR_DATE');
			var st_AGENT = mySheet.GetCellValue(Row,'AGENT_CODE');
			var st_AGENT_NAME = mySheet.GetCellValue(Row,'AGENT_NAME');
			var st_AGENT_TEL_NO = mySheet.GetCellValue(Row,'AGENT_TEL_NO');
			var st_LEGACY_PO_NO = mySheet.GetCellValue(Row,'LEGACY_PO_NO');
			var st_DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
			var st_HD_REMARK = mySheet.GetCellValue(Row,'HD_REMARK');			
			var st_KTAG_USE_FLAG = mySheet.GetCellValue(Row,'KTAG_USE_FLAG');
			st_DELY_TO_LOCATION = st_DELY_TO_LOCATION.replace('#','_');
			var st_bd_flag = mySheet.GetCellValue(Row,'DELY_BUNDLE_FLAG');
			var st_hub_yn = mySheet.GetCellValue(Row,'HUB_YN');
			
			openSearchPopup('/wmgi/showMasterWmGiReleaseTransPop.do','?st_BUYER='+st_BUYER+'&st_warehouse_code='+st_warehouse_code+'&st_INV_NO='+st_INV_NO+'&st_PO_NO='+st_PO_NO+'&st_PO_CREATE_DATE='+st_PO_CREATE_DATE+
					'&st_RD_DATE='+st_RD_DATE+'&st_BUYER_NAME='+st_BUYER_NAME+'&st_PROCESS_TEXT='+st_PROCESS_TEXT+'&st_DOC_TEXT='+st_DOC_TEXT+'&st_WMS_GR_DATE='+st_WMS_GR_DATE+'&st_AGENT='+st_AGENT+'&st_AGENT_NAME='+st_AGENT_NAME+'&st_AGENT_TEL_NO='+st_AGENT_TEL_NO+'&st_ADD_USER_NAME='+st_ADD_USER_NAME+'&st_ADD_USER_TEL='+st_ADD_USER_TEL+'&st_LEGACY_PO_NO='+st_LEGACY_PO_NO+
					'&st_DELY_TO_LOCATION='+st_DELY_TO_LOCATION+'&st_HD_REMARK='+st_HD_REMARK+'&st_KTAG_USE_FLAG='+st_KTAG_USE_FLAG+'&st_RD_DATE_value='+st_RD_DATE_value+'&st_bd_flag='+st_bd_flag+'&HUB_YN='+st_hub_yn , "1000,570,no"); 
			popupSel = "masterWmGiReleaseTransPop";
		}
	}else if(column=='PO_NO'){
		if(mySheet.GetCellValue(Row,'HUB_YN') == "Y"){
			alert("간선은 입고번호를 눌러 출고지시 해주세요.");
			return;
		}
		
		if(mySheet.GetCellValue(Row,'PO_NO')!=""){
			var st_BUYER = mySheet.GetCellValue(Row,'BUYER');
			var st_PO_NO = mySheet.GetCellValue(Row,'PO_NO');
			var st_INV_NO = mySheet.GetCellValue(Row,'INV_NO');
			var st_PO_CREATE_DATE = mySheet.GetCellText(Row,'PO_CREATE_DATE');
			var st_RD_DATE = mySheet.GetCellText(Row,'RD_DATE');
			var st_RD_DATE_value = mySheet.GetCellValue(Row,'RD_DATE');
			var st_warehouse_code = document.searchCondition.st_warehouse_code.value;
			var st_BUYER_NAME = mySheet.GetCellValue(Row,'BUYER_NAME');
			var st_PROCESS_TEXT = mySheet.GetCellValue(Row,'PROCESS_TEXT');
			var st_DOC_TEXT = mySheet.GetCellValue(Row,'DOC_TEXT');
			var st_ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME');
			var st_ADD_USER_TEL = mySheet.GetCellValue(Row,'ADD_USER_TEL');
			var st_WMS_GR_DATE = mySheet.GetCellText(Row,'WMS_GR_DATE');
			var st_AGENT = mySheet.GetCellValue(Row,'AGENT_CODE');
			var st_AGENT_NAME = mySheet.GetCellValue(Row,'AGENT_NAME');
			var st_AGENT_TEL_NO = mySheet.GetCellValue(Row,'AGENT_TEL_NO');
			var st_DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
			var st_HD_REMARK = mySheet.GetCellValue(Row,'HD_REMARK');			
			var st_LEGACY_PO_NO = mySheet.GetCellValue(Row,'LEGACY_PO_NO');
			st_DELY_TO_LOCATION = st_DELY_TO_LOCATION.replace('#','_');
			var st_bd_flag = mySheet.GetCellValue(Row,'DELY_BUNDLE_FLAG');
			openSearchPopup('/wmgi/showMasterWmGiOrderNoPop.do','?st_BUYER='+st_BUYER+'&st_warehouse_code='+st_warehouse_code+'&st_INV_NO='+st_INV_NO+'&st_PO_NO='+st_PO_NO+'&st_PO_CREATE_DATE='+st_PO_CREATE_DATE+'&st_RD_DATE='+st_RD_DATE+'&st_BUYER_NAME='+st_BUYER_NAME+'&st_PROCESS_TEXT='+st_PROCESS_TEXT+'&st_DOC_TEXT='+st_DOC_TEXT+'&st_WMS_GR_DATE='+st_WMS_GR_DATE+'&st_AGENT='+st_AGENT+'&st_AGENT_NAME='+st_AGENT_NAME+'&st_AGENT_TEL_NO='+st_AGENT_TEL_NO+'&st_ADD_USER_NAME='+st_ADD_USER_NAME+'&st_ADD_USER_TEL='+st_ADD_USER_TEL
					+'&st_DELY_TO_LOCATION='+st_DELY_TO_LOCATION+'&st_HD_REMARK='+st_HD_REMARK+'&st_RD_DATE_value='+st_RD_DATE_value+'&st_LEGACY_PO_NO='+st_LEGACY_PO_NO+'&st_bd_flag='+st_bd_flag , "1000,570,no"); 
			popupSel = "masterWmGiOrderNoPop";
		}
	}else if(column=='LEGACY_PO_NO'){
		if(mySheet.GetCellValue(Row,'HUB_YN') == "Y"){
			alert("간선은 입고번호를 눌러 출고지시 해주세요.");
			return;
		}
		
		if(mySheet.GetCellValue(Row,'LEGACY_PO_NO')!=""){
			var st_BUYER = mySheet.GetCellValue(Row,'BUYER');
			var st_PO_NO = mySheet.GetCellValue(Row,'PO_NO');
			var st_INV_NO = mySheet.GetCellValue(Row,'INV_NO');
			var st_PO_CREATE_DATE = mySheet.GetCellText(Row,'PO_CREATE_DATE');
			var st_RD_DATE = mySheet.GetCellText(Row,'RD_DATE');
			var st_RD_DATE_value = mySheet.GetCellValue(Row,'RD_DATE');
			var st_warehouse_code = document.searchCondition.st_warehouse_code.value;
			var st_BUYER_NAME = mySheet.GetCellValue(Row,'BUYER_NAME');
			var st_PROCESS_TEXT = mySheet.GetCellValue(Row,'GUBUN');
			var st_DOC_TEXT = mySheet.GetCellValue(Row,'DOC_TEXT');
			var st_ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME');
			var st_ADD_USER_TEL = mySheet.GetCellValue(Row,'ADD_USER_TEL');
			var st_WMS_GR_DATE = mySheet.GetCellText(Row,'WMS_GR_DATE');
			var st_AGENT = mySheet.GetCellValue(Row,'AGENT_CODE');
			var st_AGENT_NAME = mySheet.GetCellValue(Row,'AGENT_NAME');
			var st_AGENT_TEL_NO = mySheet.GetCellValue(Row,'AGENT_TEL_NO');
			var st_DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
			var st_HD_REMARK = mySheet.GetCellValue(Row,'HD_REMARK');			
			var st_LEGACY_PO_NO = mySheet.GetCellValue(Row,'LEGACY_PO_NO');
			var st_bd_flag = mySheet.GetCellValue(Row,'DELY_BUNDLE_FLAG');
			openSearchPopup('/wmgi/showMasterWmGiLegacyNoPop.do','?st_BUYER='+st_BUYER+'&st_warehouse_code='+st_warehouse_code+'&st_INV_NO='+st_INV_NO+'&st_PO_NO='+st_PO_NO+'&st_PO_CREATE_DATE='+st_PO_CREATE_DATE+'&st_RD_DATE='+st_RD_DATE+'&st_BUYER_NAME='+st_BUYER_NAME+'&st_PROCESS_TEXT='+st_PROCESS_TEXT+'&st_DOC_TEXT='+st_DOC_TEXT+'&st_WMS_GR_DATE='+st_WMS_GR_DATE+'&st_AGENT='+st_AGENT
					+'&st_AGENT_NAME='+st_AGENT_NAME+'&st_AGENT_TEL_NO='+st_AGENT_TEL_NO+'&st_ADD_USER_NAME='+st_ADD_USER_NAME+'&st_ADD_USER_TEL='+st_ADD_USER_TEL+'&st_DELY_TO_LOCATION='+st_DELY_TO_LOCATION+'&st_HD_REMARK='+st_HD_REMARK+'&st_RD_DATE_value='+st_RD_DATE_value+'&st_LEGACY_PO_NO='+st_LEGACY_PO_NO+'&st_bd_flag='+st_bd_flag , "1000,510,no"); 
			popupSel = "masterWmGiLegacyNoPop";
		}
	}else if(column=='PR_NO'){
		    if(mySheet.GetCellValue(Row,'DELY_BUNDLE_FLAG') == "N"){
				alert("묶음배송건만 사용 가능 합니다.");
				return;		    	
		    }
		    
		    if(mySheet.GetCellValue(Row,'HUB_YN') == "Y"){
				alert("간선은 입고번호를 눌러 출고지시 해주세요.");
				return;
			}
		    
			//구매요청별 묶음배송 출고지시.
			if(mySheet.GetCellValue(Row,'PR_NO')!=""){
				var st_BUYER = mySheet.GetCellValue(Row,'BUYER');
				var st_PR_NO = mySheet.GetCellValue(Row,'PR_NO');
				var st_RD_DATE = mySheet.GetCellText(Row,'RD_DATE');
				var st_RD_DATE_value = mySheet.GetCellValue(Row,'RD_DATE');
				var st_warehouse_code = document.searchCondition.st_warehouse_code.value;
				var st_BUYER_NAME = mySheet.GetCellValue(Row,'BUYER_NAME');
				var st_DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
				st_DELY_TO_LOCATION = st_DELY_TO_LOCATION.replace('#','_');
				var st_KTAG_USE_FLAG = mySheet.GetCellValue(Row,'KTAG_USE_FLAG');
				st_DELY_TO_LOCATION = st_DELY_TO_LOCATION.replace('#','_');
				
				openSearchPopup('/wmgi/showMasterWmGiReleasePrPop.do','?st_BUYER='+st_BUYER+'&st_warehouse_code='+st_warehouse_code+'&st_PR_NO='+st_PR_NO+
						'&st_RD_DATE='+st_RD_DATE+'&st_BUYER_NAME='+st_BUYER_NAME+'&st_DELY_TO_LOCATION='+st_DELY_TO_LOCATION+'&st_KTAG_USE_FLAG='+st_KTAG_USE_FLAG+'&st_RD_DATE_value='+st_RD_DATE_value , "1000,570,no");  
				popupSel = "masterWmGiReleasePrPop";
			}
	}else if(column=='BUYER_ITEM_NO'){
		if(mySheet.GetCellValue(Row,'BUYER_ITEM_NO')!=""){

			if(mySheet.GetCellValue(Row,'DOC_TYPE')!="X"){
				var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
				var BYIT_COMORG_CODE =  mySheet.GetCellValue(Row, "BYIT_COMORG_CODE");
				var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
				var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
				openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ , "800,260,no"); 
			}

			
		}
	}
		
	
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	grbRow="";	//초기화
	if(popupSel == "masterWmCoMbrcmpyIKPop"){
		
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}else if(popupSel == "agent_multi"){
		
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
		
	}
	
	if (popupSel == "buyer_s") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	
	}
	
}

function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}

function mySheet2_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>출고지시 및 거래명세표</h3>
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
			<input type="hidden" name="st_all_po"  id="st_all_po" value ="N">
            	<table  class="cont_t_list01" >
					<caption>출고지시 및 거래명세표</caption>
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
							<th>
								<select name="st_date_type" class="TitSelect">
									<option value="rd_date">납품요청일</option>
									<option value="po_create_date">발주일</option>
									<option value="sc_date">출고예정일</option>
								</select>
							</th>
							<td colspan="3">
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value=""  onclick="javascript:kepCalendar('st_from_date')">
											<a href="javascript:kepCalendar('st_from_date')"></a> - 
										<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
											<a href="javascript:kepCalendar('st_to_date')"></a>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
								<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox">&nbsp;기간무시		
							</td>
							<th></th>
							<td></td>
							</tr>
						<tr>	
						<th>물류센터</th>
							<td > 
								<select id="st_warehouse_code" name="st_warehouse_code" style="width:80%;height:20px" 	<%=whAdmin.equals("Y") ? "" : "disabled"%>>
								<%
						 			Map<String, String> _map = new HashMap<String, String>();
						 			_map.put("BUYER",buyer);
						 			_map.put("USERID",userid);
						 			_map.put("whAdmin",whAdmin);
								%>
								<%= CommonUtil.getCodeComboQueryIdList("common.getWareHouseIdSchList","",_map,st_warehouse_code) %>
								</select>
							</td>
							<th>구분</th>
							<td >
								<input type="radio" name="gubun" value="ALL" checked  style="background:no-repeat; border:0"/>
								전체 
								<input type="radio" name="gubun" value="TR" style="background:no-repeat; border:0"/>
								TR 
								<input type="radio" name="gubun" value="STCK"  style="background:no-repeat; border:0"/>
								재고(VMI)
								<input type="radio" name="gubun" value="HUB" style="background:no-repeat; border:0"/>
								간선
							</td>
						</tr>
						<tr> 
							<th><font color="red"><b>*</b></font>고객사</th>
							<td>
							  <input type="text" name="st_buyer_name" id="st_buyer_name" style="width:68%" value="" readonly  onclick="javascript:doPop('buyer_s')">
								<a href="javascript:doPop('masterWmCoMbrcmpyIKPop')"><img src="/resources/images/btn_search03.gif"  align="absmiddle" border="0"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>  
								<input type="hidden" name="st_buyer_code"  id="st_buyer_code"  value="">
<%-- 								<input type="text" name="st_buyer_name" style="width:80%" value="<%=warehouse_code.equals("KRKORE0160")?"대우조선해양(주)":""%>" readonly> --%>
<%-- 								<a href="javascript:BuyerIkCount('<%=warehouse_code%>','<%=warehouse_agent%>')"><img src="/resources/images/btn_search03.gif" width="18" height="18" align="absmiddle" border="0"></a>  --%>
<%-- 								<input type="hidden" name="st_buyer_code" value="<%=warehouse_code.equals("KRKORE0160")?"KRDAEW0016":""%>"> --%>
							</td>
							<th>발주번호</th>
							<td >
								<input type="text" name="st_po_no" id="st_po_no"  style="width:87%" value="" onKeyUp="kepToUpper('st_po_no')" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							</td>	
							<th>
								<!-- 공간이 부족한 상태라 표준이나 품목 둘다 조회 가능-->표준/품목코드</th>
							<td > &nbsp; 
								<input type="text" name="st_item_no" style="width:87%" value="" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							</td>
						</tr>
						<tr> 
							<th>협력사</th>
							<td > 
								<input type="text" name="st_agent_name"  id="st_agent_name"  style="width:68%" value="" readonly>
								<a href="javascript:doPop('agent_multi');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
								<input type="hidden" name="st_agent_code"  id="st_agent_code"  value="">
							</td>
							<th>입고번호</th>
							<td >
								<input type="text" name="st_inv_no"  id="st_inv_no"  style="width:87%" value="" onKeyUp="kepToUpper('st_inv_no')" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							</td>
							<th>품목명&nbsp;</th>
							<td > &nbsp; 
								<input type="text" name="st_description" style="width:87%" value="" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
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
				<option value="BRD" selected>납품요청일순</option>
				<option value="BUY">고객사순</option>
				<option value="AGE">협력사순</option>
				<option value="BPO">발주번호순</option>
				<option value="BGR">입고번호순</option>
				<option value="STD">표준코드</option>
				<option value="BIT">품목코드</option>
				<option value="DES">품목명</option>
				<option value="BOG">보급소</option>
				<option value="DLY">배송처</option>
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
  			<div style="display:none;">
  				<script type="text/javascript">
  					createIBSheet("mySheet2", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
			<div class="btnArea">
				<span class="fl">
					<span class="btn_06 mr04"><a href="javascript:doAction('excelDown');">출고건수다운로드</a></span>
  				</span>
				<span class="fr">
					<font color="#006699">출고수량이</font>
					<font color="#FF0000"><b>빨간색</b></font>
					<font color="#006699">은 가용재고가  부족한 상태입니다.</font>
  					<span class="btn_06 mr04"><a href="javascript:doPop('hubMultiInvoice');">간선다중출고지시</a></span>
  					<span class="btn_06 mr04"><a href="javascript:doPop('multiInvoice');">TR다중출고지시</a></span>
  				</span>
			</div>

<!--내용 종료-->	                 

</body>
</html>
