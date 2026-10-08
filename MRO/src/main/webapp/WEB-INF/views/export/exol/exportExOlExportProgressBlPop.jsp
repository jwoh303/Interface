<%--
**********************************************
* 메뉴 : BL 상세정보 팝업
* 화면 : BL 상세정보 팝업
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

var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view(){
	var initsheet = {};
	
	initsheet.Cols = [
		{Align:"Left",		Width:180,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사",			SaveName:"BUYER_NAME"},
		{Align:"Left",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"Forwarder",		SaveName:"FORWARDER_NAME"},
		{Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"C/I 번호",		SaveName:"CI_NO"},
		{Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"C/I Date",		SaveName:"CI_DATE"},
		{Align:"Right",		Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"Quantity",		SaveName:"QUANTITY",			Format:"${qtyFormat}"},
		{Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"Currency",		SaveName:"CURRENCY_CODE"},
		{Align:"Right",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"Amount",		SaveName:"ITEM_AMT",			Format:"${qtyFormat}"},
		{Align:"Right",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"Gross Weight",	SaveName:"GROSS_WEIGHT",		Format:"${qtyFormat}"},
		{Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"Weight",			SaveName:"WEIGHT"},
	];
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	kepSearch(document.searchCondition ,  mySheet , "/exol/getExportExOlExportProgressBlList.do" ,pagingMode );
	
	mySheet.SetImageList(0, diskOn);
	mySheet.SetImageList(1, diskOff);
}

var st;
var mt;

//기능함수
function doAction(str){
	st = new Date();
	switch (str){
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
}

//팝업함수호출
function doPop(str, params) {
	switch (str) {
	case "attachSet"://파일 첨부(등록)
		var type="EXP_BL";
		var viewType="R";
		var image_key =  $("input[name=st_image_key]").val();
		popupSel = "attachSet";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		break;
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
	<input type="hidden" id="st_bl_no"  name="st_bl_no" value="<%=CommonUtil.nvl((String) request.getParameter("st_bl_no"),"") %>">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=CommonUtil.nvl((String) request.getParameter("st_buyer"),"") %>">

	<div id="popWrapper">
		<div id="popHeader">
			<h1 class="title">B/L 상세정보</h1>
			<p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:448px;">
			<!--버튼영역-->
            <!--조회영역-->
			<table class="cont_t_list07" style="width:100%;">
				<caption>조회</caption>
				<colgroup>
					<col width="16%"/>
					<col width="34%"/>
					<col width="18%"/>
					<col width="32%"/>
				</colgroup>
				
				<tbody>
					<tr>
						<th>House B/L No</th>
						<td><%=rowData.get("BL_NO")%></td>
						
						<th>Flight/Vessel No</th>
						<td><%=rowData.get("FLIGHT_VESSEL_NO")%></td>
					</tr>
					
					<tr>
						<th>Port of Loading</th>
						<td><%=rowData.get("DEPARTURE_PORT")%></td>
						
						<th>Final Destination</th>
						<td><%=rowData.get("DESTINATION_PORT")%></td>
					</tr>
					
					<tr>
						<th>B/L Issue Date</th>
						<td><%=CommonUtil.formatStrinigDate(rowData.get("BL_ISSUE_DATE"))%></td>
						
						<th>On Board Date</th>
						<td><%=CommonUtil.formatStrinigDate(rowData.get("ON_BOARD_DATE"))%></td>
					</tr>

					<tr>
						<th>Shipper</th>
						<td><%=rowData.get("SHIPPER")%></td>

						<th>Consignee`s</th>
						<td><%=rowData.get("CONSIGNEES")%></td>
					</tr>
						
					<tr>
						<th>ETD Date</th>
						<td><%=CommonUtil.formatStrinigDate(rowData.get("ETD_DATE"))%></td>
						
						<th>ETA Date</th>
						<td><%=CommonUtil.formatStrinigDate(rowData.get("ETA_DATE"))%></td>
					</tr>
					
					<tr>
						<th>Master B/L No</th>
						<td><%=rowData.get("MASTER_BL_NO")%></td>
						
						<th>Chargable Weight</th>
						<td><%=rowData.get("CHARGABLE_WEIGHT")%> KG</td>
					</tr>

					<tr>
						<th>Ship method</th>
						<td><%=rowData.get("SHIPPING_METHOD")%></td>
						
						<th>Carrier</th>
						<td><%=rowData.get("CARRIER")%></td>
					</tr>
					
					<tr>
						<th>B/L 첨부</th>
						<td colspan="3"><a href="javascript:doPop('attachSet');"><img src="/resources/images/disk_on.gif" name="st_image_key_img" id="st_image_key_img" border="0"></a>
								<input type="hidden" name="st_image_key" id="st_image_key" value="<%=rowData.get("IMAGE_KEY")%>"></td>
					</tr>
				</tbody>
			</table>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c; height:225px;">
				<script type="text/javascript"> 
					createIBSheet("mySheet", "", "225px");
				</script>
			</div>
			<div id="pageindex"></div>
		</div>	
    </div>
</form> 
</body>
</html>
