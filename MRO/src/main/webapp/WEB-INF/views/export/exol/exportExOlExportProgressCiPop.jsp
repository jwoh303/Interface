<%--
**********************************************
* 메뉴 : CI 상세정보 팝업
* 화면 : CI 상세정보 팝업
* 기능 : 
* 프로그램 ID :
* 담당자 : 한승준
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/wms_tr_sheet.js"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>  

</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

Map<String,String> rowData = null;

if(_dataList==null || _dataList.size()==0){
}else{
	rowData = _dataList.get(0);
}
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var iconOff = "/resources/images/icon2.gif";
var iconOn = "/resources/images/icon3.gif";
var searchOn = "/resources/images/btn_search03.gif";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view(){
	var initsheet = {};
	
	initsheet.Cols = [
		{ Align:"Center",	Width:30,	Edit:true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"|",BackColor:"${notnullColor}",	SaveName:"SELECTED"},
		{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품목코드|품목코드",							SaveName:"BUYER_ITEM_NO"},
		{Align:"Left",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품목명|품목명",								SaveName:"DESCRIPTION"},
		{Align:"Right",		Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"Enter per packing unit|Qty",				SaveName:"INV_QTY",			Format:"${qtyFormat}"},
		{Align:"Right",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"Enter per packing unit|Net Weight",		SaveName:"NET_WEIGHT",		Format:"${qtyFormat}"},
		{Align:"Right",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"Enter per packing unit|Gross Weight",	SaveName:"GROSS_WEIGHT",	Format:"${qtyFormat}"},
		{Align:"Right",		Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"Enter per packing unit|CBM",				SaveName:"CBM",				Format:"${qtyFormat}"},
		{Align:"Right",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"Enter per packing unit|CTN No. From",	SaveName:"CTN_NO_FROM",	Format:"${qtyFormat}"},
		{Align:"Right",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"Enter per packing unit|CTN No. To",		SaveName:"CTN_NO_TO",		Format:"${qtyFormat}"},
		{Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"Enter per packing unit|Lot",				SaveName:"LOT_IMG"},
		{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"PKG_COMPANY_CODE"},
		{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"BUYER"},
		{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"AGENT"},
		{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"CI_NO"},
		{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"CI_SEQ"},
		{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"INV_NO"},
		{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"INV_SEQ"},
		{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"PROCESS_TYPE"},
		{Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"LOT"},
		{Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"PKG_CI_QTY_2"},
		{Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"AGENT"},
		{Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"EXP_CUR"},
		{Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float",	Header:"", SaveName:"EXP_FOR_UNIT_PRICE"},
		{Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"LEGACY_PO_NO"},
		{Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"LEGACY_PO_SEQ"},
		{Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"SPECIFICATION"},
		{Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"UNIT_MEASURE"},
		{Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"MAKER_NAME"},
		{Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"PO_NO"},
		{Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"PO_SEQ"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
			
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	mySheet.SetImageList(1, searchOn);
	mySheet.SetImageList(4, iconOff);
	mySheet.SetImageList(5, iconOn);
	
	kepSearch(document.searchCondition ,  mySheet , "/exol/getExportExOlExportProgressCiList.do" ,pagingMode );
	
	// 하이퍼링크 설정
	setLinkCol(mySheet, "LOT_IMG");
}

var st;
var mt;
//기능함수
function doAction(str){
	st = new Date();
	switch (str){
		case "deleteRows": // 행삭제
			if(mySheet.RowCount() ==1){
				alert("1건일 경우 삭제가 불가능 합니다.");
				return;
			}else{
				if(confirm("선택하신 품목 삭제 하시겠습니까?")){
					var selectedRows = mySheet.FindCheckedRow("SELECTED");
					mySheet.RowDelete(selectedRows, 0);
					kepSaveAll(document.searchCondition, mySheet, "/exol/saveExportExOlExportProgressCiList.do" , "SELECTED");					
				}
			}
		break;
	}
}

function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
}

//트랜젝션(저장,삽입등) 후처리
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

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;
	
	if(column =="LOT_IMG"){
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var CI_NO = mySheet.GetCellValue(Row,"CI_NO");
		var CI_SEQ = mySheet.GetCellValue(Row,"CI_SEQ");

		var params= "?st_buyer="+BUYER+"&st_ci_no="+CI_NO+"&st_ci_seq="+CI_SEQ;
		openSearchPopup("/exol/showExportExOlExportProgressLotPop.do", params, "800,300,no");
	}
	return;
}

//팝업함수호출
function doPop(str, params) {
	popupSel = str;
	switch (str) {
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
}

</script> 
<body onload="kep_onload_view();">
<form name="searchCondition" id="searchCondition" method = "post">
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_pkg_cmpy_no" name="st_pkg_cmpy_no"  value="<%=CommonUtil.nvl((String) request.getParameter("st_pkg_cmpy_no"),"") %>">
	<input type="hidden" id="st_ci_no"  name="st_ci_no" value="<%=CommonUtil.nvl((String) request.getParameter("st_ci_no"),"") %>">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=CommonUtil.nvl((String) request.getParameter("st_buyer"),"") %>">

	<div id="popWrapper">
		<div id="popHeader">
			<h1 class="title">C/I, P/L 상세정보</h1>
			<p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:448px;">
			<!--버튼영역-->
            <!--조회영역-->
			<table class="cont_t_list07" style="width:100%;">
				<caption>조회</caption>
				<colgroup>
					<col width="20%"/>
					<col width="30%"/>
					<col width="20%"/>
					<col width="30%"/>
				</colgroup>
				
				<tbody>
					<tr>
						<th>C/I No</th>
						<td><%=CommonUtil.formatStrinigDate(rowData.get("CI_DATE"))%></td>
						<th>C/I Date</th>
						<td><%=CommonUtil.formatStrinigDate(rowData.get("CI_DATE"))%></td>
					</tr>
					<tr>
						<th>Sailing on or about</th>
						<td><%=CommonUtil.formatStrinigDate(rowData.get("CI_DATE"))%></td>
						<th>Ship method</th>
						<td><%=rowData.get("SHIP_METHOD")%></td>
					</tr>
					<tr>
						<th>Port of Loading</th>
						<td><%=rowData.get("PORT_OF_LOADING")%></td>
						<th>Final Destination</th>
						<td><%=rowData.get("FINAL_DESTINATION")%></td>
					</tr>
					<tr>
						<th>For Acc &<br>Risk of Messrs</th>
						<td><%=rowData.get("FOR_ACC_RISK_OF_MESSRS")%></td>
						
						<th>Notify Party</th>
						<td><%=rowData.get("NOTIFY_PARTY")%></td>
					</tr>
					<tr>
						<th>Carrier</th>
						<td><%=rowData.get("CARRIER")%></td>

						<th>Forwarder</th>
						<td><%=rowData.get("FORWARDER")%></td>
					</tr>
					<tr>
						<th>Shipper / Exporter</th>
						<td><%=rowData.get("SHIPPER_EXPORTER")%></td>
						<th>Incoterms</th>
						<td><%=rowData.get("INCOTERMS")%> / <%=rowData.get("INCOTERMS_DELAY")%></td>
					</tr>
					
					<tr>
						<th>Packing Unit</th>
						<td><%=rowData.get("PACKING_QTY")%> <%=rowData.get("PACKING_UNIT")%></td>
						
						<th>Payment Terms</th>
						<td><%=rowData.get("PAY_TERMS")%></td>
					</tr>

					<tr>
						<th>Weight</th>
						<td><%=rowData.get("PACKING_WEIGHT")%></td>
						
						<th>Remark</th>
						<td><%=rowData.get("REMARK")%></td>
					</tr>
				</tbody>
			</table>
            <!--grid-->
 			<div style="border-top:2px solid #3c639c; height:250px;">
				<script type="text/javascript"> 
					createIBSheet("mySheet", "", "250px");
				</script>
			</div>
			<div id="pageindex"></div>
			<%if(CommonUtil.nvl(rowData.get("COMPLETE_MARK"),"N").equals("N")){%>
				<!--납품미완료건은 CI 삭제가능함 -->
	             <div  class="btnArea" >
	  	          	<span class="fr">
	  	          		<span class="btn_02 mr04"><a href="javascript:doAction('deleteRows')">행삭제</a></span>
					</span>
		  		</div>
	  		<%}%>
		</div>	
    </div>
</form> 
</body>
</html>
