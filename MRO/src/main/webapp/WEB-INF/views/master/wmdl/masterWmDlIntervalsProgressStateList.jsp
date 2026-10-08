<%--
**********************************************
* 메뉴 : 배송>배차관리>고객사차량정보등록
* 화면 : 배차진행현황조회
* 기능 : * 배차진행 - 추가
* 프로그램 ID : PG_08_M_018_01
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-7-22
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
	String whAdmin = _sessionInfo.getWhAdmin();
	String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_po_user_id"),""); 
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
var agentImg = "/resources/images/btn_search03.gif";
var comWare = KepSheetComboQueryIdData('common.masterWareHosueCodeList','','');	// IBSHEET : 물류센터
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
						     { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
							,{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 50,	EditLen : 50,	Edit : true}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:50,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
							,{ Align:"Left",	Width:100,	Edit:true,	EditLen:20,	Hidden:true,	Type:"Text",	Header:"차량아이디",	SaveName:"CAR_ID"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",	Header:"*차량번호",	SaveName:"CAR_NO"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",	Header:"기사명",	SaveName:"CAR_PERSON_NAME"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",	Header:"연락처",	SaveName:"CAR_PERSON_TEL"}
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",	Header:"톤급",	SaveName:"TON"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:50,	Hidden:false,	Type:"Text",	Header:"소속사",	SaveName:"AFFILIATED_CMPY"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:8,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"차량등록일",	SaveName:"REGISTRATION_DATE"}
							,{ Align:"Left",	Width:180,	Edit:false,	EditLen:10,	Hidden:false,	Type:"Combo",	Header:"물류센터",	SaveName:"WAREHOUSE_CODE",ComboText:comWare.ComboText, 	ComboCode:comWare.ComboCode}
							,{ Align:"Center",	Width:100,	Edit:true,	EditLen:50,	Hidden:false,	Type:"Combo",	ComboText:"N|Y", 		ComboCode:"N|Y",	Header:"*기본차량여부",	SaveName:"BASE_YN", BackColor:"${notnullColor}"}
							,{ Align:"Left",	Width:100,	Edit:true,	EditLen:50,	Hidden:true,	Type:"Text",	Header:"*일일배송횟수",	SaveName:"CAR_DELIV_CNT"}
							,{ Align:"Center",	Width:100,	Edit:true,	EditLen:50,	Hidden:false,	Type:"Image",	Header:"일일배송횟수",	SaveName:"CAR_DELIV_CNT_IMG", BackColor:"${notnullColor}"}
							,{ Align:"Left",	Width:100,	Edit:true,	EditLen:50,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"SAVE_FLAG"}
							,{ Align:"Left",	Width:100,	Edit:true,	EditLen:50,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"BUYER"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	mySheet.SetImageList(0, agentImg);
	
	setLinkCol(mySheet, "CAR_DELIV_CNT_IMG");
	

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
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/wmdl/getMasterWmDlIntervalsProgressStateList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		break;

	case "save": // 저장
		if (!confirm('선택한 항목을 저장 하시겠습니까?')){
			return;
		}else{

		 	for(var i = 0 ; i <arrRow.length; i++){
	 	 		if(mySheet.GetCellValue(arrRow[i],'CAR_ID') == ""){
	 	 			alert('차량을 선택 하세요');
	 	 			mySheet.SelectCell(arrRow[i], 'CAR_NO', 1);
	 	 			return;
	 	 		}
	 	 	}
			kepSave(document.searchCondition ,  mySheet , "/wmdl/saveMasterWmDlIntervalsProgressStateList.do" , "SELECTED" );
		}	

		break;
		
	case "del": // 취소
		if (!confirm('선택한 항목을 삭제 하시겠습니까?')){
			return;
		}else{
		 	for(var i = 0 ; i <arrRow.length; i++){
	 	 		if(mySheet.GetCellValue(arrRow[i],'CAR_ID') == ""){
	 	 			alert('차량을 선택 하세요');
	 	 			mySheet.SelectCell(arrRow[i], 'CAR_NO', 1);
	 	 			return;
	 	 		}
	 	 	}
		}
		kepSave(document.searchCondition ,  mySheet , "/wmdl/delMasterWmDlIntervalsProgressStateList.do" , "SELECTED" );
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
		mySheet.SetCellValue(i, 'CAR_DELIV_CNT_IMG', agentImg);

	}
	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}

//TABLE의 ROW 데이타 생성
function addrows() {
	
	if(document.searchCondition.st_buyer_code.value == ''){
		alert('고객사를 선택 하셔야 합니다');
		return;
	}
	var rows = mySheet.DataInsert(-1);
	mySheet.SetCellValue(rows, 'CAR_DELIV_CNT_IMG', agentImg);
	mySheet.SetCellValue(rows, 'BUYER_NAME', document.searchCondition.st_buyer_name.value);
	mySheet.SetCellValue(rows, 'BUYER', document.searchCondition.st_buyer_code.value);

	mySheet.SetCellValue(rows, 'SAVE_FLAG', 'N');
	mySheet.SetCellValue(rows, 'WAREHOUSE_CODE', '');

	mySheet.SetCellImage(rows, 'CAR_NO', agentImg);
	mySheet.SetCellAlign(rows, 'CAR_NO', 'Center');
	mySheet.SetCellBackColor(rows, 'CAR_NO', '${notnullColor}');
	mySheet.SetDataLinkMouse('CAR_NO', 1);
	var info = { ImgWidth:"15px",ImgHeight:"15px"};
	mySheet.SetColProperty('CAR_NO', info);
}

function checkedDel() {

	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	if (mySheet.RowCount() == 0) {
		alert("행이 없습니다.");
	}

	if (selectedGrid.length == 0) {
		alert("선택하신 행이 없습니다.");
		return;
	}

	if (!confirm("선택한 행 중 행 추가 한 행은 삭제 합니다.\n삭제하시겠습니까?")) {
		return;
	}

	var rows = mySheet.RowCount();

	while (rows >= 0) {
		var chkedYn = mySheet.GetCellValue(rows, "SELECTED");
		if (chkedYn == "1" &&("Y" !=mySheet.GetCellValue(rows, "SAVE_FLAG"))){
			mySheet.RowDelete(rows);
		}
		rows--;
	}
	//순번 재배열
	mySheet.ReNumberSeq();
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if(code==1){
		//저장 성공시 재조회
		alert("고객사의 차량 정보가 등록 되었습니다. ");
		doAction('search');
	}else if(code==0){
		alert(msg);
	}else if(code==2){
		alert("고객사의 차량 정보가 삭제  되었습니다. ");
		doAction('search');
	}else if(code==3){
		alert(msg);
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmdl/getMasterWmDlIntervalsProgressStateList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
	case "buyer_s": // 고객사 M
		var st_warehouse_code = document.searchCondition.st_warehouse_code.value;
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
	if(column=="CAR_NO"&&"Y"!=mySheet.GetCellValue(Row,'SAVE_FLAG') )
	{
		    var st_warehouse_code = document.searchCondition.st_warehouse_code.value;
		    openSearchPopup('/wmdl/showMasterWmGrIntervalsInfoAllPop.do','?st_warehouse_code='+st_warehouse_code, "800,500,no"); 
			popupSel = "masterWmGrIntervalsInfoAllPop";
	
	}else if(column=="CAR_DELIV_CNT_IMG" ){
		 	var st_buyer_code = mySheet.GetCellValue(Row,'BUYER');
		 	var st_CAR_DELIV_CNT = mySheet.GetCellValue(Row,'CAR_DELIV_CNT');
		 	openSearchPopup('/wmdl/showMasterDlDelivCntPop.do','?st_buyer_code='+st_buyer_code, "500,220,no"); 
			popupSel = "masterDlDelivCntPop";
	}
	
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_s") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	
	}else if (popupSel == "masterWmGrIntervalsInfoAllPop") {	// 배송차량팝업

		var valueArr1 = value1.split('@');
	    var valueArr2 = value2.split('@');
		mySheet.SetCellValue(grbRow, 'CAR_ID', valueArr1[0]);
		mySheet.SetCellValue(grbRow, 'CAR_NO', valueArr1[1]);
		mySheet.SetCellValue(grbRow, 'CAR_PERSON_NAME', valueArr1[2]);
		mySheet.SetCellValue(grbRow, 'CAR_PERSON_TEL', valueArr2[0]);
		mySheet.SetCellValue(grbRow, 'TON', valueArr2[1]);
		mySheet.SetCellValue(grbRow, 'AFFILIATED_CMPY', valueArr2[2]);
		mySheet.SetCellValue(grbRow, 'REGISTRATION_DATE', valueArr2[3]);
		mySheet.SetCellValue(grbRow, 'WAREHOUSE_CODE', valueArr2[4]);
	
	}
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>고객사차량정보등록</h3>
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
			
            	<table  class="cont_t_list01" width="680" >
					<caption>고객사차량정보등록</caption>
					<colgroup>
							<col width="12%" />
							<col width="38%" />
							<col width="12%" />
							<col width="38%" />
					</colgroup>

					<tbody>
						<tr>
							<th>물류센터</th>
							<td colspan="3">
								<select id="st_warehouse_code" name="st_warehouse_code" style="width:55%" 	<%=whAdmin.equals("Y") ? "" : "disabled"%>>
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
							<th>고객사</th>
							<td >
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:60%" value="" readonly onclick="javascript:doPop('buyer_s');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer_s');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
						   <th>차량번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_car_no" name="st_car_no" style="width:90%" value="" onkeydown="kepEnter()"/>
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
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
  					<span class="btn_02 mr04"><a href="javascript:addrows();">행추가</a></span>
  					<span class="btn_02 mr04"><a href="javascript:checkedDel();">행삭제</a></span>
  				</span>
  				
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
