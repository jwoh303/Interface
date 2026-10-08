<%--
**********************************************
* 메뉴 : wms > 출고 > 출고지시 및 거래명세표 > TR다중출고지시 및 거래명세표
* 화면 : 출고지시 및 거래명세표 > 다중출고지시
* 기능 : 출고지시 및 거래명세표 > 다중출고지시
* 프로그램 ID :
* 담당자 : HSJ
* 착수일 : 2025-08-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
//출고 후 거래 명세서 띄우기 금지
//SLOGIC-BEGIN(P08-0000001-02) 
boolean pP08_0000007_01= CommonUtil.getSpecialCheckReturn(CommonUtil.nvl((String) request.getParameter("st_buyer"),""),"P08-0000007-01");
//SLOGIC-END

//화승네트워크여부 
String pP08_0000011id ="";

Map<String, String> _map = CommonUtil.getSpecialCheckReturnSheetMap(CommonUtil.nvl((String) request.getParameter("st_buyer"),""));
if(_map!=null){
	pP08_0000011id = _map.get("SLG_ID");
}

// 아무 조건 없이 단순 출력하는 경우만 다중 출고지시 가능
String st_wms_multi_inv_not = "";
boolean wms_multi_inv_not = CommonUtil.getCodeCheckReturn("W_M_IV_N", pP08_0000011id);
if(wms_multi_inv_not == true){
	st_wms_multi_inv_not = "Y";
}else{
	st_wms_multi_inv_not = "N";
}
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String userid = "";
if (_sessionInfo != null){	 	
	userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
} 


%>
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
<script src="/resources/js/wms_tr_multi_sheet.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>  
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var checkpP08_0000007_01 = "<%=pP08_0000007_01%>";
var pP08_0000011id = "<%=pP08_0000011id%>";

var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	// 주의! SQL ORDER BY와 리스트 순서 고정되어야 함. 리스트 순서대로 출고지시 생성되어야 함.
	initsheet.HeaderMode = {Sort:0, ColMove:0, ColResize:1};
	initsheet.Cols = [  
 		{Align:"Center",	Type:"Status",		Width:60,	Hidden:true,	SaveName:"sStatus",			Header:"상태"}, 
		{Align:"Center",	Type:"DummyCheck",	Width:30,	Hidden:false,	SaveName:"SELECTED",		Header:""},
		{Align:"Center",	Type:"Text",		Width:90,	Hidden:true, 	SaveName:"BUYER",			Header:"고객사코드",		Edit : false},
		{Align:"Center",	Type:"Text",		Width:90,	Hidden:false, 	SaveName:"INV_NO",			Header:"입고번호",			Edit : false},
		{Align:"Center",	Type:"Text",		Width:90,	Hidden:true, 	SaveName:"INV_SEQ",			Header:"입고항번",			Edit : false},
		{Align:"Center",	Type:"Text",		Width:90,	Hidden:false, 	SaveName:"PO_NO",			Header:"발주번호",			Edit : false},
		{Align:"Center",	Type:"Text",		Width:90,	Hidden:true, 	SaveName:"PO_SEQ",			Header:"발주항번",			Edit : false},
		{Align:"Center",	Type:"Text",		Width:100,	Hidden:false, 	SaveName:"BUYER_ITEM_NO",	Header:"품목코드",			Edit : false},
		{Align:"Center",	Type:"Date",		Width:80,	Hidden:false, 	SaveName:"PO_CREATE_DATE",	Header:"발주일",			Edit : false},
		{Align:"Center",	Type:"Date",		Width:80,	Hidden:false, 	SaveName:"RD_DATE",			Header:"납품요청일",		Edit : false},
		{Align:"Left",		Type:"Text",		Width:150,	Hidden:false, 	SaveName:"DESCRIPTION",		Header:"품명",			Edit : false},
		{Align:"Left",		Type:"Text",		Width:220,	Hidden:false, 	SaveName:"SPECIFICATION",	Header:"규격",			Edit : false},
		{Align:"Right",		Type:"Text",		Width:70,	Hidden:false, 	SaveName:"WMS_GW_QTY",		Header:"출고수량",			Edit : false},
		{Align:"Right",		Type:"Text",		Width:70,	Hidden:false, 	SaveName:"BOX_QTY",			Header:"박스수량",			Edit : false},
		{Align:"Center",	Type:"Image",		Width:50,	Hidden:false, 	SaveName:"CAR_NO_IMG",		Header:"차량",			Edit : false,	BackColor:"${optColor}"},
		{Align:"Center",	Type:"Text",		Width:100,	Hidden:true, 	SaveName:"CAR_ID",			Header:"차량ID",			Edit : false},
		{Align:"Center",	Type:"Text",		Width:100,	Hidden:false, 	SaveName:"CAR_NO",			Header:"차량번호",			Edit : false},
		{Align:"Center",	Type:"Text",		Width:60,	Hidden:false, 	SaveName:"CAR_PERSON_NAME",	Header:"기사",			Edit : false},
		{Align:"Center",	Type:"Text",		Width:100,	Hidden:false, 	SaveName:"CAR_PERSON_TEL",	Header:"연락처",			Edit : false},
		{Align:"Center",	Type:"Text",		Width:100,	Hidden:true, 	SaveName:"BYIT_COMORG_CODE",Header:"카탈로그관리코드",	Edit : false},
		{Align:"Center",	Type:"Text",		Width:100,	Hidden:true, 	SaveName:"CONTRACT_NO",		Header:"계약서번호",		Edit : false},
		{Align:"Center",	Type:"Text",		Width:100,	Hidden:true, 	SaveName:"CONTRACT_SEQ",	Header:"계약서항번",		Edit : false}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:7};
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetCountPosition(4);
	
	kepSetCalender("st_inv_date");
	$("#st_inv_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
	
	kepSetCalender("st_scheduled_date");
	$("#st_scheduled_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
	$("#st_scheduled_date").val(kepToDateAdd("1","P"));
	
	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "CAR_NO_IMG");
 	mySheet.SetCellFontUnderline(0, "CAR_NO", true);
 	
 	if("<%=st_wms_multi_inv_not%>" == "Y"){
 		alert("TR다중출고지시가 불가한 고객사입니다.");
 		this.close();
 	}
 	
	kepSearch(document.searchCondition, mySheet, "/wmgi/getMasterWmGiMultiReleaseTransPop.do", pagingMode);
}

var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiMultiReleaseTransPop.do" , pagingMode );
			break;
			
		case "save":
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	 	 	var arrRow = selectedGrid.split("|");
	 	 	
	 	 	if(selectedGrid.length == 0){
	 	        alert(" 출고지시 대상을 선택해 주십시요.");
	 	        return;
	 	 	}
	 	 	
		    if(!confirm("TR다중출고지시를 하시겠습니까?")){
		        return;
		    }else{
				kepSave(document.searchCondition, mySheet, "/wmgi/saveMasterWmGiMultiReleaseTransPop.do", "SELECTED");
		    }
			break;
	}
}

function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

//헤더 더블클릭시 복사
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if(Row > 0){
		return;
	}
	
	if(mySheet.ColSaveName(Col) != "CAR_NO"){
		return;
	}
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	
	if(checkRows.length == 0){
		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	
	var arrRow = checkRows.split("|");
	
	if(mySheet.ColSaveName(Col) == "CAR_NO"){ // 차량번호 
		var varCAR_ID = mySheet.GetCellValue(arrRow[0], "CAR_ID");
		var varCAR_NO = mySheet.GetCellValue(arrRow[0], "CAR_NO");
		var varCAR_PERSON_NAME = mySheet.GetCellValue(arrRow[0], "CAR_PERSON_NAME");
		var varCAR_PERSON_TEL = mySheet.GetCellValue(arrRow[0], "CAR_PERSON_TEL");
		
		if(kepIsValueNull(varCAR_NO)){
			alert("차량을 먼저 선택하여 주십시요.");
			return;
		}
		
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "CAR_ID", varCAR_ID);
			mySheet.SetCellValue(arrRow[idx], "CAR_NO", varCAR_NO);
			mySheet.SetCellValue(arrRow[idx], "CAR_PERSON_NAME", varCAR_PERSON_NAME);
			mySheet.SetCellValue(arrRow[idx], "CAR_PERSON_TEL", varCAR_PERSON_TEL);
		}
	}
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	var st_buyer = document.searchCondition.st_buyer.value;
	getDeliCompany(st_buyer);
	
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	var msgArrr = msg.split("^^");
	var ik_no_list = msgArrr[0].substring(2);
	var legacy_po_list = msgArrr[1];
	var box_qty_list = msgArrr[2];
	
	var st_buyer = document.searchCondition.st_buyer.value;
	var st_user_id = document.searchCondition.st_user_id.value;
	var st_warehouse_code = document.searchCondition.st_warehouse_code.value; 
 	var ktag_flag = document.searchCondition.st_KTAG_USE_FLAG.value;
 	
 	var print_size = $("#ktag_selectbox3").val();
	
	if(code =="1"){
		alert("정상적으로 출고지시가 되었습니다.");
		
		if(checkpP08_0000007_01 == "false"){
			setWmsTrMultiSheet("<%=pP08_0000011id%>", "", "", st_warehouse_code, st_buyer, ik_no_list, st_user_id , legacy_po_list, "", "", "");
		}
		
		sheetTagListWin4(st_buyer, ik_no_list, legacy_po_list, box_qty_list, print_size);
		
		//일양택배 택배라벨 출력기능
		if(msgArrr[3] == "IY"){
			sheetTagListIyHj(st_buyer, ik_no_list, 'IY');
		}
		//한진택배 택배라벨 출력기능
		if(msgArrr[3] == "HJ"){
			sheetTagListIyHj(st_buyer, ik_no_list, 'HJ');
		}		
		
		opener.doAction('search');
		this.close();
	}else{
		if(msg!= ''){
			alert(msg);
		}
		
		return;
	 }
}

function sheetTagListWin4(buyer, ik_no, legacy_po_no, box_qty, print_size) {
	var seller = "KRKORE0001";
	var legacy_po_no = "";
	var pur_id = "";
	var ktag_start = "1";
	var url ="/coco/showReportMultiViewer.do";
	var ktag_box_qty = box_qty;
	var params = "";
	var fileName = "";
	var rdParams = [];
	
	var ik_no_arr = [];
	var legacy_po_arr = [];
	var box_qty_arr = [];
	
	ik_no_arr = ik_no.split("@@");
	legacy_po_arr = legacy_po_no.split("@@");
	box_qty_arr = box_qty.split("@@");
	
 	// IK번호 갯수만큼 반복
	for(i=0; i<ik_no_arr.length-1; i++){
		if(i == (ik_no_arr.length-2)){
			end_flag = "^^";
		}else{
			end_flag = "@@";
		}
		
		box_qty_arr[i] = 1; // 품목태그는 수량 관계없이 항상 기본 1장씩 출력(한애희)
		params += "[" + ik_no_arr[i] + "][" + seller + "][" + buyer + "][" + legacy_po_arr[i] + "][" + pur_id + "][" + ktag_start + "][" + box_qty_arr[i] + "]" + end_flag;
	}
    
 	if(print_size == "L"){
 		fileName = "RD_06_X_002_20";
 	}else if(print_size == "N"){
 		fileName = "RD_06_X_002_19";
 	}
 	
	rdParams.push({key:"fileName", value:fileName});
	rdParams.push({key:"param", value:params});
	OpenReportPost(url, "TAGPOP", rdParams);
	
	return;
}

function sheetTagListIyHj(buyer, ik_no, flag) {
	var url ="/coco/showReportMultiViewer.do";
	
	var params = "";
	var fileName = "";
	var rdParams = [];
	
	var ik_no_arr = [];
	
	ik_no_arr = ik_no.split("@@");
	
	
 	// IK번호 갯수만큼 반복
	for(i=0; i<ik_no_arr.length-1; i++){
		if(i == (ik_no_arr.length-2)){
			end_flag = "^^";
		}else{
			end_flag = "@@";
		}
				
		params += "[" + buyer + "][" + ik_no_arr[i] + "]" + end_flag;
	}
    
 	if(flag == "IY"){
 		fileName = "RD_06_X_002_16";
 	}else if(flag == "HJ"){
 		fileName = "RD_06_X_002_81";
 	} 	

	rdParams.push({key:"fileName", value:fileName});
	rdParams.push({key:"param", value:params});
	OpenReportPost(url, "IYHJPOP", rdParams);
	
	return;
}

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiMultiReleaseTransPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if(column == "BUYER_ITEM_NO"){
		if(mySheet.GetCellValue(Row,"BUYER_ITEM_NO") != ""){
			var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
			var BYIT_COMORG_CODE = mySheet.GetCellValue(Row, "BYIT_COMORG_CODE");
			var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
			var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
			openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ, "800,260,no"); 
		}
	}else if(column == "CAR_NO_IMG"){
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		openSearchPopup('/wmgr/showMasterWmGrIntervalsInfoPop.do','?BUYER='+buyer, "800,380,no");
		popupSel = "masterWmGrIntervalsInfoPop";		
	}	
	
	return;
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	if (popupSel == "masterWmGrIntervalsInfoPop") {	// 배송차량팝업
		var valueArr1 = value1.split('@');
	    var valueArr2 = value2.split('@');
	    
		mySheet.SetCellValue(grbRow, 'CAR_ID', valueArr1[0]);
		mySheet.SetCellValue(grbRow, 'CAR_NO', valueArr1[1]);
		mySheet.SetCellValue(grbRow, 'CAR_PERSON_NAME', valueArr2[0]);
		mySheet.SetCellValue(grbRow, 'CAR_PERSON_TEL', valueArr2[1]);
	}
	
	grbRow="";	//초기화
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
	    	 const noneOption = document.querySelector('#select_deliCompany option[value="N"]');
    	 	 if(response.Message == "IY") {	    	 		
	    	 	// 없음 값 숨기기
	    	 	noneOption.style.display = 'none';
	    	 	document.getElementById('select_deliCompany').value = 'IY';
    	 	 } else if(response.Message == "HJ") {
    	 		// 없음 값 숨기기
    	 		noneOption.style.display = 'none';
    	 		document.getElementById('select_deliCompany').value = 'HJ';
    	 	 } else {
    	 		noneOption.style.display = '';
    	 		document.getElementById('select_deliCompany').value = 'N';
    	 	 }
		 },
		 error:function( response ) {  		    	   
	    	 alert("오류발생하였습니다.");
		 }
    });
}

</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
	<input type="hidden" id="st_buyer"  name="st_buyer"  value="<%=CommonUtil.nvl((String) request.getParameter("st_buyer"),"") %>">
	<input type="hidden" id="st_date_type"  name="st_date_type" value="<%=CommonUtil.nvl((String) request.getParameter("st_date_type"),"") %>">
	<input type="hidden" id="st_from_date"  name="st_from_date" value="<%=CommonUtil.nvl((String) request.getParameter("st_from_date"),"") %>">
	<input type="hidden" id="st_to_date"  name="st_to_date" value="<%=CommonUtil.nvl((String) request.getParameter("st_to_date"),"") %>">
	<input type="hidden" id="st_warehouse_code"  name="st_warehouse_code" value="<%=CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"") %>">
	<input type="hidden" id="st_KTAG_USE_FLAG"  name="st_KTAG_USE_FLAG" value="<%=CommonUtil.nvl((String) request.getParameter("st_KTAG_USE_FLAG"),"") %>">
	
	<div id="popWrapper" style="height:565px;">
    	<div id="popHeader">
        	<h1 class="title">TR다중출고지시 및 거래명세표</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <!--조회영역-->
            <table class="cont_t_list06" style="width:100%">
				<caption>조회</caption>
				<colgroup>
					<col width="100px" />
					<col width="25%" />
					<col width="100px" />
					<col width="25%" />
					<col width="100px" />
					<col width="25%" />
				</colgroup>

				<tbody>
					<tr>
						<th>고객사</th>
						<td>
							<b><%=CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"") %></b>
						</td>
						<th>출고일자</th>
						<td>
							<input type="text" class="input_type_text" name="st_inv_date" id="st_inv_date" readOnly style="width:100px; text-align:center;" value="">
							<a href="javascript:kepCalendar('st_inv_date')"></a>
						</td>
						<th>출고예정일</th>
						<td>
							<input type="text" class="input_type_text" name="st_scheduled_date" id="st_scheduled_date" readOnly style="width:100px; text-align:center;" value="">
							<a href="javascript:kepCalendar('st_scheduled_date')"></a>
						</td>
					</tr>
				</tbody>
			</table>

			<font color="#006699">해당 화면은 </font>
			<font color="#FF0000"><b>고객사명 / 센터명 / 조회일자 기준</b></font>
			<font color="#006699">으로 TR 다중 출고지시가 가능한 전체 리스트를 노출합니다.</font>
			
			<!--grid-->
 			<div style="border-top:2px solid #3c639c;height:420px;">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "100%");
				</script>
			</div>
		</div>
        
        <!--버튼영역-->
        <div class="btnArea mr25">        
        	<span class="fl" style="padding: 5px 20px;">	
  					<span class="btn_10_blue" style="color:#FFF;">
						택배사 선택&nbsp;
						<select id="select_deliCompany" name="select_deliCompany" style="width:65px; margin-top:3px">
		                    <option value="N" selected>없음</option>
		                    <option value="HJ">한진택배</option>
		                    <option value="IY">일양택배</option>		                    
	                    </select>
					</span>
 			</span> 		
			<span class="fr">
				<span class="btn_10_blue" style="color:#FFF;">
					출력방식&nbsp;&nbsp;
					<select id="ktag_selectbox3" name="ktag_selectbox3" style="width:60px; margin-top:3px">
	                    <option value="L">라벨</option>
	                    <option value="N" selected>일반</option>
                    </select>
				</span>
				<span class="btn_06 mr04"><a href="javascript:doAction('save');">TR다중출고지시</a></span>
			</span>
       </div>
    </div>
</form>
</body>
</html>
