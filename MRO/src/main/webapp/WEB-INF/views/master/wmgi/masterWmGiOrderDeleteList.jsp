<%--
**********************************************
* 메뉴 : 출고>발주삭제 조회
* 화면 : 발주삭제 조회
* 기능 : 삭제된 발주내역 조회
* 프로그램 ID : PG_08_M_009_00
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-7-15
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

String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_po_user_id"),""); 

%> 
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var agentImg = "/resources/images/btn_search03.gif";
var remarkOn="/resources/images/but_icon01.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
						{ Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태",	SaveName:"STATUS_TEXT"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주번호",	SaveName:"PO_NO"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"LEGACY_NO",	SaveName:"LEGACY_PO_NO"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"입고번호",	SaveName:"GR_NO"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"송장번호",	SaveName:"IK_NO"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"발주일",	SaveName:"PO_CREATE_DATE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"납품요청일",	SaveName:"RD_DATE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"입고일",	SaveName:"GR_DATE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"출고일",	SaveName:"INV_DATE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"납품일",	SaveName:"DELIVERY_DATE"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준코드",	SaveName:"STDCATLG_ID"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION,"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}						
						
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}",		Header:"발주수량",	SaveName:"PO_QTY"}
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}",		Header:"입고수량",	SaveName:"WMS_GR_QTY"}
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}",		Header:"기출고수량",	SaveName:"GI_DELIVERY_QTY"}
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}",		Header:"출고수량",	SaveName:"WMS_IVK_QTY"}
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}",		Header:"납품수량",	SaveName:"DELIVERY_QTY"}

						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float", Format:"${priceFormat}",	Header:"매입단가",	SaveName:"LIST_PRICE"}
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float", Format:"${priceFormat}",	Header:"매출단가",	SaveName:"UNIT_PRICE"}
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float", Format:"${priceFormat}",Header:"매입금액",	SaveName:"LIST_AMT"}
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float", Format:"${priceFormat}",	Header:"매출금액",	SaveName:"UNIT_AMT"}

						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"구분",	SaveName:"DOC_TEXT"}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"협력사",	SaveName:"AGENT_IMG"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사",	SaveName:"AGENT"}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"요청자",	SaveName:"ADD_USER_IMG"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자",	SaveName:"ADD_USER_NAME"}
						
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"배송처",	SaveName:"DELY_TO_LOCATION_IMG"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"배송처",	SaveName:"DELY_TO_LOCATION"}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고",	SaveName:"PO_REMARK_IMG"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고",	SaveName:"PO_REMARK"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"ADD_USER_TEL"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"BYIT_COMORG_CODE"} 
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"CONTRACT_NO"} 
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"CONTRACT_SEQ"} 
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PO_HD_REMARK", SaveName:"PO_HD_REMARK"} 
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PO_HD_REMARK", SaveName:"BUYER"} 
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	IBS_InitSheet2(mySheet, initsheet,pagingMode,5);

	//비고이미지설정
	mySheet.SetImageList(1, agentImg);
	mySheet.SetImageList(0, remarkOn);

	//콤보데이터 셋팅		
	var serch_text = "st_user_id="+document.searchCondition.st_user_id.value+"&st_com_code="+document.searchCondition.st_com_code.value;
	

	//하이퍼링크 설정
	setLinkCol(mySheet, "AGENT_IMG"); 
	setLinkCol(mySheet, "ADD_USER_IMG"); 
	setLinkCol(mySheet, "DELY_TO_LOCATION_IMG"); 
	setLinkCol(mySheet, "PO_REMARK_IMG");
	
	setLinkCol(mySheet, "BUYER_NAME"); 
	setLinkCol(mySheet, "PO_NO"); 
	setLinkCol(mySheet, "BUYER_ITEM_NO"); 
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	kepSetCalender("st_scheduled_from_date");
	kepSetCalender("st_scheduled_to_date");
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepToMonthAdd("1","P"));
	

}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
						if(kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val())== false){
							return;
						}
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
			alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n3개월 이상의 데이타는 S/R 요청 바랍니다.");
			return ;
		} 
		if(document.searchCondition.st_buyer_code.value == ''){
			alert("고객사를 선택하여 주십시요.\n\n필수 사항 입니다.");
			return;
		}
		if( ($("#st_scheduled_from_date").val() != "" &&  $("#st_scheduled_to_date").val() =="")
				|| ($("#st_scheduled_from_date").val()  == "" &&  $("#st_scheduled_to_date").val()  !="") ){
			alert('출고예정일의 시작일과 종료일을 함께 입력 하셔야 합니다.');
			return;
		}
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/wmgi/getMasterWmGiOrderDeleteList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		kepEraser('st_scheduled_from_date','st_scheduled_to_date');
		mySheet.RemoveAll();
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepToMonthAdd("1","P"));
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
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

   	
   	
	for(var  i= 1 ; i<mySheet.GetTotalRows()+1 ;  i++)
	{
		if(mySheet.GetCellValue(i,"DELY_TO_LOCATION")!="")
		{
			mySheet.SetCellValue(i, 'DELY_TO_LOCATION_IMG', agentImg);
		}
		if(mySheet.GetCellValue(i,"ADD_USER_NAME")!="")
		{
			mySheet.SetCellValue(i, 'ADD_USER_IMG', agentImg);
		}
		if(mySheet.GetCellValue(i,"PO_REMARK")!="")
		{
			mySheet.SetCellValue(i, 'PO_REMARK_IMG', remarkOn);
		}
		if(mySheet.GetCellValue(i,"AGENT")!="")
		{
			mySheet.SetCellValue(i, 'AGENT_IMG', agentImg);
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
	kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiOrderDeleteList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
	case "buyer_single": // 고객사 M

	    var ware_house_code = document.searchCondition.st_warehouse_code.value;
	    var st_from_date = document.searchCondition.st_from_date.value;
	    var st_to_date = document.searchCondition.st_to_date.value;
	    var st_date_flag ='PO';
	    openSearchPopup('/wmco/showMasterWmCoMbrcmpyPop.do','?st_warehouse_code='+ware_house_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date+'&st_date_flag='+st_date_flag, "500,500,no"); 
        popupSel = "buyer_single";
        break;	
	case "buyer_s": // 고객사 M
		//var st_warehouse_code = "<%=CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"") %>";	
		//openSearchPopup("/wmdl/showMasterDlCommpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
		
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
        popupSel = "buyer_s";
        break;		        
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if(column == 'BUYER_NAME')
	{
		if(mySheet.GetCellValue(Row,'BUYER_NAME')!=""){
		//	alert( mySheet.GetCellValue(Row,'BUYER'));
			 var com_code = mySheet.GetCellValue(Row,'BUYER');
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}else if(column == 'BUYER_ITEM_NO')
	{
		if(mySheet.GetCellValue(Row, 'BUYER_ITEM_NO') !="")
		{
			var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
			var BYIT_COMORG_CODE = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
			var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
			var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
			openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ, "800,260,no"); 
		}
	}else 	if(column=="DELY_TO_LOCATION_IMG" )
	{
		if(mySheet.GetCellValue(Row,'DELY_TO_LOCATION')!="")
		{
			var DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
			openSearchPopup('/wmco/showMasterWmCoDlvryPop.do','?DELY_TO_LOCATION='+DELY_TO_LOCATION, "500,210,no"); 
			popupSel = "masterWmCoDlvryPop";
		}
	}else if(column=="ADD_USER_IMG" )
	{
		if(mySheet.GetCellValue(Row,'ADD_USER_NAME')!="")
		{
			var st_ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME');
			var st_ADD_USER_TEL = mySheet.GetCellValue(Row,'ADD_USER_TEL');
			var st_POHD_REMARK = mySheet.GetCellValue(Row,'PO_HD_REMARK');
			openSearchPopup('/wmco/showMasterWmCoRequestPop.do','?st_ADD_USER_NAME='+st_ADD_USER_NAME+'&st_ADD_USER_TEL='+st_ADD_USER_TEL+'&st_POHD_REMARK='+st_POHD_REMARK, "500,220,no"); 
			popupSel = "masterWmCoRequestPop";
		}
	}else 	if(column=="PO_REMARK_IMG" )
	{
		if(mySheet.GetCellValue(Row,'PO_REMARK')!="")
		{
			var PO_REMARK = mySheet.GetCellValue(Row,'PO_REMARK');
			openSearchPopup('/common/remarkBtoAPop.do','?st_btoa_remark='+PO_REMARK, "500,220,no"); 
			popupSel = "remarkBtoA";
		}		
	}else  if(column=="AGENT_IMG" )
	{
		if(mySheet.GetCellValue(Row,'AGENT_NAME')!="")
		{
			 var com_code = mySheet.GetCellValue(Row,'AGENT');
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}else  if(column=="PO_NO" )
	{
		if(mySheet.GetCellValue(Row,'PO_NO')!="")
		{
			 var buyer = mySheet.GetCellValue(Row,'BUYER');
			 var po_no = mySheet.GetCellValue(Row,'PO_NO');
			 var warehouse_codes = document.searchCondition.st_warehouse_code.value ;
			 var com_code = document.searchCondition.st_com_code.value ;
			 var user_id = document.searchCondition.st_user_id.value ;
			 openSearchPopup('/wmgi/showMasterWmGiOrderDeletePop.do','?st_buyer='+buyer+'&st_po_no='+po_no+'&st_warehouse_code='+warehouse_codes+'&com_code='+com_code+'&user_id='+user_id, "1000,500,no"); 
			popupSel = "masterWmGiOrderDeletePop";
		}
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
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
			<h3>발주삭제 조회</h3>
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
			
            	<table  class="cont_t_list01" style="width:940px;">
					<caption>발주삭제 조회</caption>
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
		                    <td>	발주일 </td>
							<td colspan="5">
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
											<a href="javascript:kepCalendar('st_from_date')"></a> -
										<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
											<a href="javascript:kepCalendar('st_to_date')"></a>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>		
							</td>

							</tr>
						<tr>
						   <td>물류센터</td>
							<td width="23%"> 
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
							<td>구분</td>
                    <td  width="23%">  
                        <input type="radio" name="st_process_type" value="ALL" checked style="background:no-repeat; border:0">
                        전체 
                        <input type="radio" name="st_process_type" value="2" style="background:no-repeat; border:0">
                        TR 
                        <input type="radio" name="st_process_type" value="1" style="background:no-repeat; border:0">
                        재고(VMI)
                    </td>
						</tr>
						<tr> 
							<td><font color="red"><b>*</b></font>고객사</td>
							<td  width="23%">  
								<input type="text" name="st_buyer_name" id="st_buyer_name" style="width:60%" value="" readonly  onclick="javascript:doPop('buyer_s');">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>  
								<input type="hidden" name="st_buyer_code"  id="st_buyer_code"  value="">
<%-- 								<input type="text" name="st_buyer_name" style="width:80%" value="<%=warehouse_code.equals("KRKORE0160")?"대우조선해양(주)":""%>" readonly> --%>
<%-- 								<a href="javascript:BuyerIkCount('<%=warehouse_code%>','<%=warehouse_agent%>')"><img src="/resources/images/btn_search03.gif" width="18" height="18" align="absmiddle" border="0"></a>  --%>
<%-- 								<input type="hidden" name="st_buyer_code" value="<%=warehouse_code.equals("KRKORE0160")?"KRDAEW0016":""%>"> --%>
							</td>
							<td>발주번호</td>
							<td  width="23%">  
								<input type="text" name="st_po_no" id="st_po_no"  style="width:80%" value="" onKeyUp="kepToUpper('st_po_no')" onkeydown="kepEnter()">
							</td>	
							<td>
								<!-- 공간이 부족한 상태라 표준이나 품목 둘다 조회 가능-->표준/품목코드</td>
							<td >  
								<input type="text" name="st_buyer_item_no"  id="st_buyer_item_no" style="width:80%" value="" onkeydown="kepEnter()">
							</td>
						</tr>
						<tr> 
							<td>송장번호</td>
							<td  width="23%">  
								<input type="text" name="st_ik_no"  id="st_ik_no" style="width:60%"  value="" onKeyUp="kepToUpper('id')">
							</td>
							<td>입고번호</td>
							<td  width="23%">  
								<input type="text" name="st_iv_no"  id="st_iv_no"  style="width:80%" value="" onKeyUp="kepToUpper('st_inv_no')" onkeydown="kepEnter()">
							</td>
		                    <td  align="right"  width="10%">상태</td>
		                    <td >     
            <select name = "st_status_text">
              <option value="ALL">전체</option>
			<option value="입고완료">입고완료</option>
              <option value="출고예정">출고예정</option>
              <option value="분할출고예정">분할출고예정</option>
              <option value="출고">출고</option>
              <option value="분할출고">분할출고</option>
              <option value="배송확정">배송확정</option>
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
				</select>
			</span>
           	<span class="fr">      <select name="st_order_by">
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
   			<div class="ib_product" style="border-top:2px solid #3c639c;height:300px;">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "", "300px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>

<!--내용 종료-->	                 

</body>
</html>
