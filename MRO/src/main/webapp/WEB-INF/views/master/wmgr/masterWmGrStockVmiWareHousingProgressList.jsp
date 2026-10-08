<%--
**********************************************
* 메뉴 : 입고>입고진행관리>재고/VMI입고진행관리
* 화면 : 재고/VMI입고진행관리
* 기능 : 재고/VMI 입고에 대한 진행관리 조회
* 프로그램 ID : PG_08_M_005_00
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-6-4
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
var addUserName = "/resources/images/btn_search03.gif";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
						 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"대상", SaveName:"TARGET"} 
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태", SaveName:"STATUS"} 

							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주번호", SaveName:"PO_NO"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"LEGACY_NO", SaveName:"LEGACY_PO_NO"} 
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"입고번호", SaveName:"INV_NO"} 

							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"발주일", SaveName:"PO_CREATE_DATE"} /* CommonUtil.formatStrinigDate(rowData.get("obj[6]"))%></td><!-- 발주일 -->*/
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"납품요청일", SaveName:"RD_DATE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"입고예정일", SaveName:"DS_DATE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"입고일", SaveName:"WMS_GR_DATE"} 

							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사", SaveName:"MAKER_NAME"} /*rowData.get("obj[5]")%></td><!-- 제조사 -->*/
							
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준코드", SaveName:"BUYER_ITEM_NO"}					
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명", SaveName:"DESCRIPTION"} 
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격", SaveName:"SPECIFICATION"} 		
							
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}", 	Header:"발주수량", SaveName:"PO_QTY"} /* WisehubString.WiseNumberType(rowData.get("obj[8]"))%></td><!-- 발주수량 -->*/
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}", Header:"납품수량", SaveName:"INV_QTY"} /*  align="right">=WisehubString.WiseNumberType(rowData.get("obj[17]"))%></td><!-- 납품수량 -->*/
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}", Header:"기입고수량", SaveName:"GI_GR_QTY"} /*  align="right">=WisehubString.WiseNumberType(rowData.get("obj[18]"))%></td><!-- 기입고수량 -->*/

							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위", SaveName:"UNIT_MEASURE"} /*  align="center">=rowData.get("obj[13]")%></td><!-- 단위 -->*/
												
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float", Format:"${priceFormat}",	Header:"매입단가", SaveName:"AGENT_PRICE"} /* WisehubString.WiseNumberType(rowData.get("obj[9]"))%></td><!-- 매입단가 -->*/
							
							,{ Align:"Center",	Width:60,Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"협력사", SaveName:"AGENT_IMG"} 
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사명", SaveName:"AGENT_NAME"}	
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사", SaveName:"AGENT"} 
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자", SaveName:"ADD_USER_NAME"}
							,{ Align:"Center",	Width:60,Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"요청자", SaveName:"ADD_USER_NAME_IMG"} 
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자전화번호", SaveName:"ADD_USER_TEL"}	
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자", SaveName:"ADD_USER_ID"}		
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사전화번호", SaveName:"AGENT_TEL_NO"}	
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"구분", SaveName:"GUBUN"}	
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"BYIT_COMORG_CODE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"CONTRACT_NO"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"CONTRACT_SEQ"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"VPO_SEQ"} 
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"비고", SaveName:"POHD_REMARK"} 
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);
	mySheet.SetImageList(2, addUserName);

	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL','');

	//하이퍼링크 설정
	setLinkCol(mySheet, "PO_NO");	//발주번호
	setLinkCol(mySheet, "INV_NO");	//입고번호
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "ADD_USER_NAME_IMG");
	setLinkCol(mySheet, "AGENT_IMG");
	
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
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/wmgr/getMasterWmGrStockVmiWareHousingProgressList.do" , pagingMode );
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
	    $("#pageflag").val('0');
		var param = {FileName:"MyExcel.xlsx",DownCols:"TARGET|STATUS|LEGACY_PO_NO|PO_NO|BUYER_ITEM_NO|INV_NO|DESCRIPTION|SPECIFICATION|MAKER_NAME|UNIT_MEASURE|PO_CREATE_DATE|RD_DATE|DS_DATE|WMS_GR_DATE|PO_QTY|INV_QTY|GI_GR_QTY||AGENT_NAME|ADD_USER_NAME|ADD_USER_TEL|POHD_REMARK"};
		kepDownExcel(document.searchCondition ,mySheet , "/wmgr/excelMasterWmGrStockVmiWareHousingProgressList.do", param);
		$("#pageflag").val('1');
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
		if(mySheet.GetCellValue(i,"ADD_USER_NAME")!="")
		{
			mySheet.SetCellValue(i, 'ADD_USER_NAME_IMG', remarkOn);
		}
		else{
			mySheet.SetCellValue(i, 'ADD_USER_NAME_IMG', remarkOff);
		}
		if(mySheet.GetCellValue(i,"AGENT_NAME")!="")
		{
			mySheet.SetCellValue(i, 'AGENT_IMG', remarkOn);
		}else{
			mySheet.SetCellValue(i, 'AGENT_IMG', remarkOff);
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
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrStockVmiWareHousingProgressList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
	case "agent_single": // 협력사 M
		openSearchPopup('/coco/showCommonCoCoCompanyPop.do','?com_type=S&multi_flag=M&safety_flag=undefined&save_flag=undefined' , "500,500,no"); 
		popupSel = "agent_single";
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
			
			 var ware_house_code = document.searchCondition.st_warehouse_code.value;
			 var st_from_date = document.searchCondition.st_from_date.value;
			 var st_to_date = document.searchCondition.st_to_date.value;
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?ware_house_code='+ware_house_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}
	else if (column == 'PO_NO')  //발주번호 클릭
	{ 
		if(""!=mySheet.GetCellValue(Row,"PO_NO"))
		{
			var ware_house_code = document.searchCondition.st_warehouse_code.value;
		    var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		    var GUBUN = mySheet.GetCellValue(Row,"GUBUN");
		    var STATUS = mySheet.GetCellValue(Row,"STATUS");
		    openSearchPopup('/wmgr/showMasterWmGrStockOrderManagerPop.do','?ware_house_code='+ware_house_code+'&PO_NO='+PO_NO+'&st_status='+STATUS+'&GUBUN='+GUBUN, "900,480,no"); 
			popupSel = "masterWmGrStockOrderManagerPop";
		}

	} 
	else if(column == 'INV_NO') //입고번호 클릭 
	{
		if(""!=mySheet.GetCellValue(Row,"INV_NO"))
		{
			var ware_house_code = document.searchCondition.st_warehouse_code.value;
		    var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		    var GUBUN = mySheet.GetCellValue(Row,"GUBUN");
		    var STATUS = mySheet.GetCellValue(Row,"STATUS");
		    var INV_NO = mySheet.GetCellValue(Row,"INV_NO");
		    
		    openSearchPopup('/wmgr/showMasterWmGrStockWarehousingManagerPop.do','?ware_house_code='+ware_house_code+'&PO_NO='+PO_NO+'&GUBUN='+GUBUN+'&STATUS='+STATUS+'&INV_NO='+INV_NO, "900,500,no"); 
			popupSel = "masterWmGrStockWarehousingManagerPop";
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
	}
	else if(column=="ADD_USER_NAME_IMG" )
	{
		if(mySheet.GetCellValue(Row,'ADD_USER_NAME')!="")
		{
			var st_ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME');
			var st_ADD_USER_TEL = mySheet.GetCellValue(Row,'ADD_USER_TEL');
			openSearchPopup('/wmco/showMasterWmCoRequestPop.do','?st_ADD_USER_NAME='+st_ADD_USER_NAME+'&st_ADD_USER_TEL='+st_ADD_USER_TEL, "500,220,no"); 
			popupSel = "masterWmCoRequestPop.jsp";
		}		
	}	
	else if(column=="AGENT_IMG" )
	{
		if(mySheet.GetCellValue(Row,'AGENT_NAME')!="")
		{
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
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(text);
	
	}else if(popupSel == "agent_single"){
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
	}
	
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>재고/VMI입고진행관리</h3>
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
					<caption>재고/VMI입고진행관리</caption>
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
								<select name="st_date_type" class = "TitSelect">
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
								<select id="st_warehouse_code" name="st_warehouse_code"  style="width:90%" 	<%=whAdmin.equals("Y") ? "" : "disabled"%>>
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
							<th>발주번호</th>
							<td >  
								<input type="text" name="st_po_no" id="st_po_no"  style="width:78%" value="" onKeyUp="kepToUpper('st_po_no')" onKeyUp="kepToUpper(id)" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							</td>
							<th>입고번호</th>
							<td  >  
								<input type="text" name="st_inv_no"  id="st_inv_no"   style="width:78%" value="" onKeyUp="kepToUpper('st_inv_no')" onKeyUp="kepToUpper(id)" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							</td>
							<th>협력사</th>
							<td >  
								<input type="text" name="st_agent_name"  id="st_agent_name"   style="width:65%" value="" readonly>
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif" align="absmiddle" border="0"></a>
								<input type="hidden" name="st_agent_code"  id="st_agent_code" value="">
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
						</tr>
						<tr> 
							<th>표준코드</th>
							<td  >  
								<input type="text" name="st_stdcatlg_id"  id = "st_stdcatlg_id" style="width:78%" value=""  onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							</td>
							<th>대상</th>
							<td    >  
								<input class="Noborder"   type="radio" name="st_target" value="ALL" checked>
								전체 
								<input class="Noborder"  type="radio" name="st_target" value="STCK">
								재고 
								<input class="Noborder"  type="radio" name="st_target" value="VMI">
								VMI </td>
							<th>상태</th>
							<td >  
								<select name="st_status"  style="width:90%" >
									<option value="ALL" selected>전체</option>
									<option value="1">발주</option>
									<option value="2">입고예정</option>
									<option value="3">분할입고예정</option>
									<option value="4">입고완료</option>
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
			 <span class="fr">
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="st_order_by"  id="st_order_by" style="width: 100px;" >
						<option value="1" selected>센터예정순</option>
						<option value="2">협력사순</option>
						<option value="3">발주번호순</option>
						<option value="4">입고번호순</option>
						<option value="5">표준코드</option>
						<option value="6">품목코드</option>
						<option value="7">품목명</option>
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

  			<br/><br/>
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  				
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
