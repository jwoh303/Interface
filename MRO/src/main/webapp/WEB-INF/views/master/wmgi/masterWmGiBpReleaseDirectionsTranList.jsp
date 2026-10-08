<%--
**********************************************
* 메뉴 : 출고>일괄출고지시 및 거래명세표
* 화면 : 일괄출고지시 및 거래명세표
* 기능 : 일괄출고예정정보 확인 및 출고지시 생성하고, 납품지시서 출력
* 프로그램 ID : PG_08_M_006_00
* 담당자 : 현명환
* 착수일 : 2015-
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


	String whAdmin = _sessionInfo.getWhAdmin();
%> 
<script src="/resources/js/wms_tr_sheet.js"></script> 
<script src="/resources/js/kep_common.js"></script> 
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var LocationOn = "/resources/images/btn_search03.gif";
var agentImg = "/resources/images/btn_search03.gif";
var stock_item_yn = "N"; // VMI or 재고 품목 확인 + 고객사 전용 품목라벨 사용

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
						 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
							,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED", Sort:0}
							,{ Align:"Left",	Width:160,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
							
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"발주번호",	SaveName:"PO_NO"}
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"LEGACY_NO",	SaveName:"LEGACY_PO_NO"}
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"입고번호",	SaveName:"INV_NO"}
							,{Align : "Center",SaveName : "MSDS_NO",		Header : "MSDS NO",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false}
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Date",Format:"Ymd",	Header:"납품요청일",	SaveName:"RD_DATE"}
							,{ Align:"Right",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type : "Float", Format:"${qtyFormat}",Header:"입고(재고)수량",	SaveName:"WMS_GR_QTY"}
							,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"WMS_GW_QTY"}							
							,{ Align:"Right",	Width:100,	Edit : true,	EditLen:100,	Hidden : false,	Format:"${qtyFormat}", Type : "Float", Format:"${qtyFormat}",	Header:"*출고수량",	SaveName:"IVK_QTY", BackColor:"${notnullColor}"}
							,{ Align:"Right",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type : "Float", Format:"${qtyFormat}",Header:"기출고(지시)수량",	SaveName:"IV_QTY"}
							,{ Align:"Center",	Width:100,	Edit : true,	EditLen:100,	Hidden : false,	Type:"Date",Format:"Ymd",	Header:"*출고일자",	SaveName:"IVK_DATE", BackColor:"${notnullColor}"}
							,{ Align:"Center",	Width:100,	Edit : true,	EditLen:100,	Hidden : false,	Type:"Date",Format:"Ymd",	Header:"*출고예정일",	SaveName:"SCHEDULED_DATE", BackColor:"${optColor}"}
			    			,{Align : "Center",SaveName : "CAR_ID",		Header : "차량아이디",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false ,Hidden:true}
			    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"차량", 	SaveName:"CAR_NO_IMG",BackColor:"${optColor}" }
			    			,{Align : "Left",SaveName : "CAR_NO",		Header : "차량번호",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
			    			,{Align : "Left",SaveName : "CAR_PERSON_NAME",		Header : "차량기사",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
			    			,{Align : "Left",SaveName : "CAR_PERSON_TEL",		Header : "연락처",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
			    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"지연사유",	SaveName:"DELAY_REMARK_IMG",BackColor:"${optColor}"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"협력사",	SaveName:"AGENT_IMG"}
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : true,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}	
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : true,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_TEL_NO"}	
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : true,	Type:"Text",	Header:"협력사",	SaveName:"AGENT"}	
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"표준코드",	SaveName:"STDCATLG_ID"}
							,{ Align:"Center",	Width:150,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
							,{ Align:"Left",	Width:150,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
							,{ Align:"Left",	Width:200,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
							,{ Align:"Right",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type : "Float", Format:"${qtyFormat}",	Header:"발주수량",	SaveName:"PO_QTY"}
							,{ Align:"Left",	Width:60,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
							,{ Align:"Right",	Width:100,	Edit : false,	EditLen:100,	Hidden : true,	Type : "Float", Format:"${priceFormat}",	Header:"출고단가",	SaveName:"UNIT_PRICE"}
							,{ Align:"Right",	Width:100,	Edit : false,	EditLen:100,	Hidden : true,	Type : "Float", Format:"${priceFormat}",	Header:"출고금액",	SaveName:"WMS_IVK_AMT"}
							,{ Align:"Left",	Width:100,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"구분",	SaveName:"GUBUN_TEXT"}
							,{ Align:"Center",	Width:60,	Edit : false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"요청자",	SaveName:"ADD_USER_IMG"}
							,{ Align:"Center",	Width:180,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"요청자 정보",	SaveName:"HD_REMARK"}
							,{ Align:"Center",	Width:180,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"발주자 정보",	SaveName:"ADD_USER"}
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : true,	Type:"Text",	Header:"발주자명",	SaveName:"ADD_USER_NAME"}
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:100,	Hidden : true,	Type:"Text",	Header:"발주자전화번호",	SaveName:"ADD_USER_TEL"}
							,{ Align:"Center",	Width:60,	Edit : false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"배송처",	SaveName:"DELY_TO_LOCATION_IMG"}
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
			    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"PO_SEQ"}
			    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"INV_SEQ"}
			    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"P08_0000011_DATA"}
			    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"P08_0000007_01_YN"}
			    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"P08_0000012_01_YN"}
			    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"M206_YN"}
			    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"묶음배송",	SaveName:"DELY_BUNDLE_FLAG"}
			    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"PR_USER_ID"}
			    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"BOX_QTY"}
							,{ Align:"Center",	Width:120,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"발주일시",	SaveName:"PODT_ADD_DATE"}
							,{ Align:"Left",	Width:500,	Edit : false,	EditLen:100,	Hidden : false,	Type:"Text",	Header:"배송처",	SaveName:"DELY_TO_LOCATION"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:2};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	//하이퍼링크 설정
	setLinkCol(mySheet, "MSDS_NO");
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
	setLinkCol(mySheet, "LEGACY_PO_NO");
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "BUYER_NAME");
	setLinkCol(mySheet, "CAR_NO_IMG");
	setLinkCol(mySheet, "CAR_NO");	
 	mySheet.SetCellFontUnderline(0,"CAR_NO", true);
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	kepSetCalender("st_scheduled_from_date");
	kepSetCalender("st_scheduled_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepToMonthAdd("1","P"));
	
	if(document.searchCondition.st_warehouse_code.options.length == 1 )
	{
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
		if(document.searchCondition.st_buyer_code.value == ''){
			alert('고객사를 선택 하셔야 합니다');
			return;
		}

	    current_page = -1;

		kepSearch(document.searchCondition,  mySheet , "/wmgi/getMasterWmGiBpReleaseDirectionsTranList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepToMonthAdd("1","P"));
		const noneOption = document.querySelector('#select_deliCompany_form option[value="N"]');
		noneOption.style.display = '';
		$("#select_deliCompany_form").val('N');		
		kepEraser('st_scheduled_from_date','st_scheduled_to_date');
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		break;
	case "save":
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
 	 	var arrRow = selectedGrid.split("|");
 	 	var ktag_box_qty = $("#ktag_box_qty").val();
 	 	if(selectedGrid.length == 0)
 	 	{
 	        alert(" 출고지시 대상을 선택해 주십시요.");
 	        return;
 	 	}
 	 	var curMonth = kepGetNowTimeStr('YYYYMMDD','').substring(0, 6);
 	 	
 	 	// VMI or 재고 품목 확인 + 고객사 전용 품목라벨 사용 FLAG 초기화
 	 	stock_item_yn = "N";
 	 	
		for(var i = 0 ; i <arrRow.length; i++)
		{
			// VMI or 재고 품목 확인 + 고객사 전용 품목라벨 사용
			if(mySheet.GetCellValue(arrRow[i],'PROCESS_TYPE') != "2" && mySheet.GetCellValue(arrRow[i],'M206_YN') == "Y"){
				stock_item_yn = "Y";
			}
			
 	 		if(mySheet.GetCellValue(arrRow[i],'BUYER') == "KRDAEW0016"){
 	 			
 	 			if(mySheet.GetCellValue(arrRow[i],'CAR_NO') == ''){
 	 					alert('차량정보를 입력 해주세요 ');
 	 					mySheet.SelectCell(arrRow[i], 'CAR_NO_IMG', 1);
 	 					return;
 	 			}
 	 			
 	 		}
 	 		//박스수량 셋팅
 	 		mySheet.SetCellValue(arrRow[i], 'BOX_QTY', ktag_box_qty);
 	 		//구매요청자 ID
			var st_pr_user_id =mySheet.GetCellValue(arrRow[i],'PR_USER_ID'); 
			for(var j = 0 ; j <arrRow.length; j++)
			{
				if(mySheet.GetCellValue(arrRow[i],'IVK_DATE') !=mySheet.GetCellValue(arrRow[j],'IVK_DATE'))
				{
					alert('출고일자가 다른 것끼리 출고지시 할 수 없습니다');
					return;
				}
	 	 		//묶음배송
	 	 		if(mySheet.GetCellValue(arrRow[i],'DELY_BUNDLE_FLAG') == "Y"){
	 					alert('묶음배송건은 일괄출고지시 불가능 합니다.\n출고지시 및 거래명세표 화면 통해서 진행 바랍니다.  ');
 	 					return;	 	 			
	 	 		}
	 	 		//구매요청자 ID가 다르면 출고지시 불가능.
	 	 		if(mySheet.GetCellValue(arrRow[i],'P08_0000012_01_YN') == "Y"){
	 	 			if(mySheet.GetCellValue(arrRow[i],'PR_USER_ID') != mySheet.GetCellValue(arrRow[j],'PR_USER_ID')){
	 					alert('구매 요청자가 다르므로 일괄 출고지시가 불가합니다.');
 	 					return;	 	 				 	 				
	 	 			}
	 	 		}
			}
			if(eval(mySheet.GetCellValue(arrRow[i],'IVK_QTY')) > eval(mySheet.GetCellValue(arrRow[i],'WMS_GR_QTY')))
			{
				alert('재고가 부족한 제품이 있습니다');					
				return;
			}
	 		// (주)두산 모트롤BG 창원공장 출고지시 제한
			if(mySheet.GetCellValue(arrRow[i],'P08_0000007_01_YN')=="Y" &&(mySheet.GetCellValue(arrRow[i],'RD_DATE')).substring(0, 6)  > curMonth ){
				alert("(주)두산 모트롤BG 창원공장은 납품요청일이 익월일 경우\n출고지시를 할 수 없습니다");
				return;
			}
			if(("KRX"==mySheet.GetCellValue(arrRow[i],'BUYER')) && eval(mySheet.GetCellValue(arrRow[i],'IVK_QTY')) != eval(mySheet.GetCellValue(arrRow[i],'WMS_GR_QTY'))  )
			{
				alert('KEPMRO 주문은 발주수량을 분할 하여 출고 할 수 없습니다.');
				return;
			}
		}
		//박스수량 파라미터 셋팅
		$("#st_box_qty").val(ktag_box_qty);
		// 택배사 select box 세팅
		var select_deliCompany_form = $("#select_deliCompany_form").val();
		$("#select_deliCompany").val(select_deliCompany_form);
	    if(!confirm("출고지시를 하시겠습니까?")) {
	        return;
	    }else{
	    	
	    	carExist = "";
	    	for(var m = 0 ; m <arrRow.length; m++)
	    	{
	    		if(mySheet.GetCellValue(arrRow[m],'CAR_NO' ) != ""){
	    			carExist = "Y";
	    		}	
	    	}
	    	$("#st_BUYER").val(mySheet.GetCellValue(arrRow[0],'BUYER'));
			kepSave(document.searchCondition ,  mySheet , "/wmgi/saveMasterWmGiReleaseTransPop.do" , "SELECTED" );
	    }
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
		if(document.searchCondition.st_buyer_code.value == ''){
			alert('고객사를 선택 하셔야 합니다');
			return;
		}
		
		$("#pageflag").val("0");
		var param = {FileName:"일괄출고지시.xlsx",
			DownCols:"BUYER_NAME|PO_NO|INV_NO|IV_QTY|IVK_DATE|STDCATLG_ID|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|PO_QTY|UNIT_MEASURE|DELY_TO_LOCATION"};
	    kepDownExcel(document.searchCondition ,mySheet , "/wmgi/excelMasterWmGiBpReleaseDirectionsTranList.do", param);
	    $("#pageflag").val('1');
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
	var st_buyer = document.searchCondition.st_buyer_code.value;
	getDeliCompany(st_buyer);

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
		if(mySheet.GetCellValue(i,"DOC_TYPE")=="0")
		{
			mySheet.SetCellEditable(i, "IVK_QTY", 0);
		}else {
			mySheet.SetCellEditable(i, "IVK_QTY", 1);
		}
		if(eval(mySheet.GetCellValue(i,"WMS_GW_QTY")) > eval(mySheet.GetCellValue(i,"WMS_GR_QTY")) ){
			
			mySheet.SetCellFontColor(i,"IVK_QTY","#FF0000") ;
			mySheet.SetCellValue(i,"IVK_QTY",mySheet.GetCellValue(i,"WMS_GW_QTY")) ;
			
		}
		else
		{	
			mySheet.SetCellValue(i,"IVK_QTY",mySheet.GetCellValue(i,"WMS_GW_QTY")) ;
		}		
		mySheet.SetCellValue(i, 'CAR_NO_IMG', remarkOn);
		if(mySheet.GetCellValue(i,"DELAY_REMARK") == "" )
		{
			mySheet.SetCellValue(i, 'DELAY_REMARK_IMG', remarkOff);
		}
		else{
			mySheet.SetCellValue(i, 'DELAY_REMARK_IMG', remarkOn);
		}
		
	}
	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	var msgArrr = msg.split("@@");
	var ik_no = msgArrr[0].substring(2);
	var st_buyer = document.searchCondition.st_BUYER.value;
	var st_user_id = document.searchCondition.st_user_id.value;
	var st_warehouse_code = document.searchCondition.st_warehouse_code.value;
 	var ktag_flag =mySheet.GetCellValue(1,'KTAG_USE_FLAG');
	if(code =="1" )
	{
	      alert("정상적으로 출고지시가 되었습니다.\n\n거래명세서 번호는  " + ik_no + " 입니다.");
	      
		// VMI or 재고 품목 확인 + 고객사 전용 품목라벨 사용
	  	if(stock_item_yn == "Y"){
			alert("고객사 전용 품목 TAG는 출고진행관리에서 입고라벨로 별도 출력바랍니다.");
		}
	  	
			if(mySheet.GetCellValue(1,'P08_0000007_01_YN') == "N"){
				if("P08-0000011-23"==mySheet.GetCellValue(1,'P08_0000011_DATA')){
					//화승 네트워크인 경우에는 부서를 조회
					setWmsTrSheet(mySheet.GetCellValue(1,'P08_0000011_DATA'),carExist,msgArrr[2],st_warehouse_code,st_buyer, ik_no, st_user_id , mySheet.GetCellValue(1,'LEGACY_PO_NO'),'','', '');
				}else{
					setWmsTrSheet(mySheet.GetCellValue(1,'P08_0000011_DATA'),carExist,"", st_warehouse_code, st_buyer, ik_no, st_user_id , mySheet.GetCellValue(1,'LEGACY_PO_NO'),'','', '');
				}
			}
			if ($("#ktag_selectbox2").val() == "1") {
	 			sheetTagListWin1(st_buyer,ik_no);
			}else if ($("#ktag_selectbox2").val() == "4") {
	 			sheetTagListWin4(st_buyer,ik_no);
			}else 	if ($("#ktag_selectbox2").val() == "12") {
				sheetTagListWin12(st_buyer,ik_no);	
			}
			
			//일양택배 택배라벨 출력기능
			if(msgArrr[1] == "Y"){
				var url ="/coco/showReportViewer.do";
				var param = encodeURI("?fileName=RD_06_X_002_16&param=[" + st_buyer + "][" + ik_no + "]");
				window.open(url + "" + param, "", "width=770,height=800,resizable=YES,top=0,left=0");
			}
			//한진택배 택배라벨 출력기능
			if(msgArrr[1] == "HJ"){
				var url ="/coco/showReportViewer.do";
				var param = encodeURI("?fileName=RD_06_X_002_81&param=[" + st_buyer + "][" + ik_no + "]");
				window.open(url + "" + param, "", "width=770,height=800,resizable=YES,top=0,left=0");
			}
	      doAction('search');
	}else {
		  if(msg!= ''){
		      alert(msg);
		  }
	      return;
	 }
}
function sheetTagListWin1(buyer,ik_no) {
	
	var seller = "KRKORE0001";
	var legacy_po_no = "";
	var pur_id = "";
	var ktag_start = $("#ktag_selectbox").val();
	var url ="/coco/showReportViewer.do";
	var ktag_box_qty = $("#ktag_box_qty").val();
	
	//var param = encodeURI("?fileName=RD_06_X_002_12&param=["+ik_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]&inv_no="+ik_no+"&buyer="+buyer);
	//window.open(url +""+param, "", "width=770,height=600,resizable=YES,top=0,left=200");
   	var param = "["+ik_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]&inv_no="+ik_no+"&buyer="+buyer; 
    reportOpen("RD_06_X_002_17", param); 
	return;
}	
function sheetTagListWin4(buyer,ik_no) {
	var seller = "KRKORE0001";
	var legacy_po_no = "";
	var pur_id = "";
	var ktag_start = $("#ktag_selectbox").val();
	var url ="/coco/showReportViewer.do";
	var ktag_box_qty = 1;	// 품목태그는 수량 관계없이 항상 기본 1장씩 출력(한애희)
	var fileName = "";
	var print_size = $("#ktag_selectbox3").val();

	//var param = encodeURI("?fileName=RD_06_X_002_12&param=["+ik_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]&inv_no="+ik_no+"&buyer="+buyer);
	//window.open(url +""+param, "", "width=770,height=600,resizable=YES,top=0,left=200");
   	var param = "["+ik_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]";   
    
    if(print_size == "L"){
 		fileName = "RD_06_X_002_20";
 	}else if(print_size == "N"){
 		fileName = "RD_06_X_002_19";
 	}
    
    reportOpen(fileName, param);
	return;
}
function sheetTagListWin12(buyer,ik_no) {

	var seller = "KRKORE0001";
	var legacy_po_no = "";
	var pur_id = "";
	var ktag_start = $("#ktag_selectbox").val();
	var url ="/coco/showReportViewer.do";
	var ktag_box_qty = $("#ktag_box_qty").val();

	//var param = encodeURI("?fileName=RD_06_X_002_11&param=["+ik_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]&inv_no="+ik_no+"&buyer="+buyer);
	//window.open(url +""+param, "", "width=770,height=800,resizable=YES,top=0,left=200");
   	var param = "["+ik_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]&inv_no="+ik_no+"&buyer="+buyer;   
    reportOpen("RD_06_X_002_11", param); 
	return;
}
//셀의 값을 편집 완료하고, 기존 값이 변경되었을 때 이벤트가 발생한다.
function mySheet_OnChange(Row, Col, Value) {
	
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	if(column=='IVK_QTY')
	{
	       var ivk_qty      = mySheet.GetCellValue(Row,'IVK_QTY');          // 출고수량
	       var org_ivk_qty  = mySheet.GetCellValue(Row,'WMS_GW_QTY');           // ORG_출고수량
	        if( isEmpty(ivk_qty) || eval(ivk_qty) > eval(org_ivk_qty) || eval(ivk_qty) <= 0){
	            alert("출고수량을 확인 후 다시 입력해 주십시요");
	            mySheet.SetCellValue(Row,"IVK_QTY",mySheet.GetCellValue(Row,"WMS_GW_QTY")) ;
	            return;
	        }else{
				if(eval(mySheet.GetCellValue(Row,"IVK_QTY")) >= eval(mySheet.GetCellValue(Row,"WMS_GR_QTY")) ){
					
					mySheet.SetCellFontColor(Row,"IVK_QTY","#FF0000") ;
				}
	        }
	}else if(column=='IVK_DATE'){
		
		mySheet.SetCellValue(Row,"SELECTED","1");
		
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
		    openSearchPopup("/mpiv/getCommonMpIvBpTranBuyerChoicePop.do", "?invoice_flag=Y&st_com_code="+ware_house_code, "720,505,no");
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
		case "masterWmCoMbrcmpyBpIKPop": 
		    var ware_house_code = document.searchCondition.st_warehouse_code.value;
		    var st_from_date = document.searchCondition.st_from_date.value;
		    var st_to_date = document.searchCondition.st_to_date.value;
		    var date_type = document.searchCondition.st_date_type.value;
		    openSearchPopup('/wmco/showMasterWmCoMbrcmpyBpIKPop.do','?st_warehouse_code='+ware_house_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date+'&date_type='+date_type, "500,500,no"); 
			popupSel = "masterWmCoMbrcmpyBpIKPop";
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
			var st_bd_flag = mySheet.GetCellValue(Row,'DELY_BUNDLE_FLAG');
			openSearchPopup('/wmgi/showMasterWmGiReleaseTransPop.do','?st_BUYER='+st_BUYER+'&st_warehouse_code='+st_warehouse_code+'&st_INV_NO='+st_INV_NO+'&st_PO_NO='+st_PO_NO+'&st_PO_CREATE_DATE='+st_PO_CREATE_DATE+
					'&st_RD_DATE='+st_RD_DATE+'&st_BUYER_NAME='+st_BUYER_NAME+'&st_PROCESS_TEXT='+st_PROCESS_TEXT+'&st_DOC_TEXT='+st_DOC_TEXT+'&st_WMS_GR_DATE='+st_WMS_GR_DATE+'&st_AGENT='+st_AGENT+'&st_AGENT_NAME='+st_AGENT_NAME+'&st_AGENT_TEL_NO='+st_AGENT_TEL_NO+'&st_ADD_USER_NAME='+st_ADD_USER_NAME+'&st_ADD_USER_TEL='+st_ADD_USER_TEL+'&st_LEGACY_PO_NO='+st_LEGACY_PO_NO+
					'&st_DELY_TO_LOCATION='+st_DELY_TO_LOCATION+'&st_HD_REMARK='+st_HD_REMARK+'&st_KTAG_USE_FLAG='+st_KTAG_USE_FLAG+'&st_RD_DATE_value='+st_RD_DATE_value+'&st_bd_flag='+st_bd_flag , "1000,570,no"); 
			popupSel = "masterWmGiReleaseTransPop";
		}
	}else if(column=='PO_NO'){
		
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
			var st_bd_flag = mySheet.GetCellValue(Row,'DELY_BUNDLE_FLAG');
			openSearchPopup('/wmgi/showMasterWmGiOrderNoPop.do','?st_BUYER='+st_BUYER+'&st_warehouse_code='+st_warehouse_code+'&st_INV_NO='+st_INV_NO+'&st_PO_NO='+st_PO_NO+'&st_PO_CREATE_DATE='+st_PO_CREATE_DATE+'&st_RD_DATE='+st_RD_DATE+'&st_BUYER_NAME='+st_BUYER_NAME+'&st_PROCESS_TEXT='+st_PROCESS_TEXT+'&st_DOC_TEXT='+st_DOC_TEXT+'&st_WMS_GR_DATE='+st_WMS_GR_DATE+'&st_AGENT='+st_AGENT+'&st_AGENT_NAME='+st_AGENT_NAME+'&st_AGENT_TEL_NO='+st_AGENT_TEL_NO+'&st_ADD_USER_NAME='+st_ADD_USER_NAME+'&st_ADD_USER_TEL='+st_ADD_USER_TEL
					+'&st_DELY_TO_LOCATION='+st_DELY_TO_LOCATION+'&st_HD_REMARK='+st_HD_REMARK+'&st_RD_DATE_value='+st_RD_DATE_value+'&st_LEGACY_PO_NO='+st_LEGACY_PO_NO+'&st_bd_flag='+st_bd_flag , "1000,570,no"); 
			popupSel = "masterWmGiOrderNoPop";
		}
	}else if(column=='LEGACY_PO_NO'){
		
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
	}else if(column=='BUYER_ITEM_NO')
	{
		if(mySheet.GetCellValue(Row,'BUYER_ITEM_NO')!=""){

			if(mySheet.GetCellValue(Row,'DOC_TYPE')!="X"){
				var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
				var BYIT_COMORG_CODE =  mySheet.GetCellValue(Row, "BYIT_COMORG_CODE");
				var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
				var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
				openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ , "800,260,no"); 
			}

			
		}
	}else 	if(column=="DELAY_REMARK_IMG" )
	{
		var st_DELAY_REMARK = mySheet.GetCellValue(Row,'DELAY_REMARK');
		var st_BUYER = mySheet.GetCellValue(Row,'BUYER');
		var st_PO_NO = mySheet.GetCellValue(Row,'PO_NO');
		openSearchPopup('/wmco/showMasterWmCoDelayPop.do','?st_DELAY_REMARK='+st_DELAY_REMARK+'&st_BUYER='+st_BUYER+'&st_PO_NO='+st_PO_NO, "500,220,no"); 
		popupSel = "masterWmCoDelayPop";

	}else	if(column=="CAR_NO_IMG" )
	{
			var buyer = mySheet.GetCellValue(Row,'BUYER');
			openSearchPopup('/wmgr/showMasterWmGrIntervalsInfoPop.do','?BUYER='+buyer, "800,380,no"); 
			popupSel = "masterWmGrIntervalsInfoPop";		
	}else	if(column=="MSDS_NO" )
	{
			var st_msds_no = mySheet.GetCellValue(Row,'MSDS_NO');
			if(st_msds_no == ""){
				alert("선택한 MSDS 정보가 없습니다.");
				return;
			}else{
				openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+st_msds_no+"&st_btn_yn=N",'750,580,no'); 
				popupSel = "msdsDetailPop";
			}
	}
		
	
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
		
	if(popupSel == "masterWmCoMbrcmpyIKPop"||popupSel =="masterWmCoMbrcmpyBpIKPop"){
		
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}else if(popupSel == "agent_multi"){
		
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
		
	}else if(popupSel == "masterWmGrIntervalsInfoPop") {	// 배송차량팝업
		var valueArr1 = value1.split('@');
	    var valueArr2 = value2.split('@');
		mySheet.SetCellValue(grbRow, 'CAR_ID', valueArr1[0]);
		mySheet.SetCellValue(grbRow, 'CAR_NO', valueArr1[1]);
		mySheet.SetCellValue(grbRow, 'CAR_PERSON_NAME', valueArr2[0]);
		mySheet.SetCellValue(grbRow, 'CAR_PERSON_TEL', valueArr2[1]);
	
	}else if(popupSel == "masterWmCoDelayPop") {
		mySheet.SetCellValue(grbRow, 'DELAY_REMARK', value1);
		if(value1 == ""){
			mySheet.SetCellValue(grbRow, 'DELAY_REMARK_IMG', remarkOff);
		}
		else{
			mySheet.SetCellValue(grbRow, 'DELAY_REMARK_IMG', remarkOn);
		}
	}
	
	if (popupSel == "buyer_s") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	
	}
	grbRow="";	//초기화	
}
function setBuyerChoiceReturn(buyer, com_name){
	$("#st_buyer_code").val(buyer);
	$("#st_buyer_name").val(com_name);
}

function getDeliCompany(buyer) {  
	   
		$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: "/wmgi/getMasterWmGiBpReleaseDirectionsTranDeliCompany.do",
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: { buyer: buyer},
		     async : false,
		     success:function( response ) {
		    	 const noneOption = document.querySelector('#select_deliCompany_form option[value="N"]');
	    	 	 if(response.Message == "IY") {	    	 		
		    	 	// 없음 값 숨기기
		    	 	noneOption.style.display = 'none';
		    	 	document.getElementById('select_deliCompany_form').value = 'IY';
	    	 	 } else if(response.Message == "HJ") {
	    	 		// 없음 값 숨기기
	    	 		noneOption.style.display = 'none';
	    	 		document.getElementById('select_deliCompany_form').value = 'HJ';
	    	 	 } else {
	    	 		noneOption.style.display = '';
	    	 		document.getElementById('select_deliCompany_form').value = 'N';
	    	 	 }
			 },
			 error:function( response ) {  		    	   
		    	 alert("오류발생하였습니다.");
			 }
	    });
	}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>일괄출고지시 및 거래명세표</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
       		<input type="hidden" name="st_BUYER"  id="st_BUYER"  value="">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
			<input type="hidden" name="st_all_po"  id="st_all_po" value ="N">
			<input type="hidden" name="st_box_qty"  id="st_box_qty"  value ="">
			<input type="hidden" name="select_deliCompany"  id="select_deliCompany"  value ="">
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
						</tr>
						<tr> 
							<th><font color="red"><b>*</b></font>고객사</th>
							<td>
							  <input type="text" name="st_buyer_name" id="st_buyer_name" style="width:68%" value="" readonly  onclick="javascript:doPop('masterWmCoMbrcmpyIKPop')">
								<a href="javascript:doPop('masterWmCoMbrcmpyBpIKPop')"><img src="/resources/images/btn_search03.gif"  align="absmiddle" border="0"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>  
								<input type="hidden" name="st_buyer_code"  id="st_buyer_code"  value="">
								<input type="hidden" name="gubun"  id="gubun"  value="TR">
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
					<option value="100">100건</option>
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
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
               	<span class="fl">
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  					<span class="btn_10_blue" style="color:#FFF;">
						택배사 선택&nbsp;
						<select id="select_deliCompany_form" name="select_deliCompany_form" style="width:65px; margin-top:3px">
		                    <option value="N" selected>없음</option>
		                    <option value="HJ">한진택배</option>
		                    <option value="IY">일양택배</option>		                    
	                    </select>
					</span>
  					
  				</span>
				<span class ="btn_10_blue" style="color:#FFF; display: none;">
					KTAG출력위치
					<select id="ktag_selectbox" name="ktag_selectbox" style="width:40px; margin-top:3px">
                    <option value="1" selected>1</option>
                    <option value="2" >2</option>
                    <option value="3" >3</option>
                    <option value="4" >4</option>
                    <option value="5" >5</option>
                    <option value="6" >6</option>
                    <option value="7" >7</option>
                    <option value="8" >8</option>
                    <option value="9" >9</option>
                    <option value="10" >10</option>
                    <option value="11" >11</option>
                    <option value="12" >12</option>
                    </select> 
      				       </span>

				<span class ="btn_10_blue" style="width:115px; color:#FFF">
						박스수량 : 
						<input type="text" name="ktag_box_qty"  id="ktag_box_qty" style="width:30px; margin-top:3px" value="" maxlength="3" onkeyup="kepNumcheck(this);">
				</span>
				
				<span class="btn_10_blue" style="color:#FFF; display: none;">
					K tag출력
					<select id="ktag_selectbox2" name="ktag_selectbox2" style="width:60px; margin-top:3px">
	                    <option value="12" >12칸</option>
	                    <option value="4" selected>4칸</option>
	                    <option value="1" >1칸</option>
                    </select>
				</span>
				
				<span class="btn_10_blue" style="color:#FFF;">
					출력방식&nbsp;&nbsp;
					<select id="ktag_selectbox3" name="ktag_selectbox3" style="width:60px; margin-top:3px">
	                    <option value="L">라벨</option>
	                    <option value="N" selected>일반</option>
                    </select>
				</span>
				
				<span class="btn_02 mr04"><a href="javascript:doAction('save');">출고지시</a></span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
