<%--
**********************************************
* 메뉴 : 입고>입고등록>VMI입고
* 화면 : VMI입고
* 기능 : VMI 입고 예정정보 조회 및 입고확정
* 프로그램 ID : PG_08_M_003_00
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-5-29
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

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
						 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
							,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태",	SaveName:"STATUS"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주번호",	SaveName:"VPO_NO"}
							,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date", Format:"Ymd",	Header:"발주일",	SaveName:"VPO_DATE"}
							,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date", Format:"Ymd",	Header:"납품요청일",	SaveName:"RD_DATE"}
							,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date", Format:"Ymd",	Header:"입고예정일",	SaveName:"VIV_DATE"}
							,{ Align:"Right",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int", Format:"${qtyFormat}", 	Header:"품목수",	SaveName:"VPO_SEQ"}
							,{ Align:"Right",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float", Format:"${priceFormat}", Header:"금액",	SaveName:"ITEM_AMT"}
							,{ Align:"Left",	Width:300,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",	SaveName:"USER_NAME_LOC"}
							,{ Align:"Left",	Width:300,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"COM_NAME_LOC"}
							,{ Align:"Left",	Width:300,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사전번",	SaveName:"AGENT_TEL"}	
							,{ Align:"Left",	Width:300,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"AGENT"}	
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정


	//하이퍼링크 설정
	setLinkCol(mySheet, "VPO_NO");	//발주번호
	setLinkCol(mySheet, "BUYER_NAME");
	setLinkCol(mySheet, "COM_NAME_LOC");
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_to_date").val( kepToMonthAdd("1","P"));
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	
	//콤보데이터 셋팅		
	var serch_text = "st_user_id="+document.searchCondition.st_user_id.value+"&st_com_code="+document.searchCondition.st_com_code.value;
	

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
		kepSearch(document.searchCondition,  mySheet , "/wmgr/getMasterWmGrVmiWarhsngList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepToMonthAdd("1","P"));
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		break;

	case "save": // 저장
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
 	 	var arrRow = selectedGrid.split("|");
 	 	if(selectedGrid.length == 0)
 	 	{
 	 		alert('입고등록 대상을 선택 하세요');
 	        return;
 	 	}
 		if(!confirm('VMI 상품들을 센터 입고 하시겠습니까?')){
 			return;
 		}
		kepSave(document.searchCondition ,  mySheet , "/wmgr/saveMasterWmGrVmiWarhsngList.do" , "SELECTED" );
		break;

	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
		var param = {FileName:"MyExcel.xlsx",DownCols:"STATUS|PO_NO|VPO_DATE|RD_DATE|DS_DATE|VIV_DATE|VPO_SEQ|USER_NAME_LOC|COM_NAME_LOC"};
		kepDownExcel(document.searchCondition ,mySheet , "/wmgr/excelMasterWmGrVmiWarhsngList.do", param);
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
		
		if(mySheet.GetCellValue(i,"STATUS")=="권고발주")
		{
			mySheet.SetCellEditable(i, "SELECTED", 0);
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

	if(code==1){
		//저장 성공시 재조회
		alert('입고등록이 완료되었습니다');
		doAction('search');
	}else{
		alert(msg);
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrVmiWarhsngList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "agent_single": // 고객사 M
			openSearchPopup('/coco/showCommonCoCoCompanyPop.do','?com_type=S&multi_flag=M&safety_flag=undefined&save_flag=undefined',"500,500,no");
			popupSel = "agent_single";
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'BTOA_USER_NAME') { // 요청자
		var ID = mySheet.GetCellValue(Row,"BTOA_USER_ID");
		openSearchPopup('/common/userDisplayPop.do','?user_id='+ID, "800,500,no"); 
		
	} 
	else if(column == 'BUYER_NAME')
	{
		if(mySheet.GetCellValue(Row,'BUYER_NAME')!=""){
			
			 var ware_house_code = document.searchCondition.st_warehouse_code.value;
			 var st_from_date = document.searchCondition.st_from_date.value;
			 var st_to_date = document.searchCondition.st_to_date.value;
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?ware_house_code='+ware_house_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}
	else if (column == 'VPO_NO') { // 발주 번호 
		
		if(mySheet.GetCellValue(Row,'VPO_NO')!=""){
			
			var ware_house_name = document.searchCondition.st_warehouse_code.options[document.searchCondition.st_warehouse_code.selectedIndex].text;
			var ware_house_code = document.searchCondition.st_warehouse_code.value;
		    var USER_NAME_LOC = mySheet.GetCellValue(Row,'USER_NAME_LOC'); 
		    var PO_NO = mySheet.GetCellValue(Row,'VPO_NO');
			var VPO_DATE = mySheet.GetCellText(Row,'VPO_DATE'); 
		    var RD_DATE = mySheet.GetCellText(Row,'RD_DATE');
		    var COM_NAME_LOC = mySheet.GetCellValue(Row,'COM_NAME_LOC');
		    var STATUS = mySheet.GetCellValue(Row,'STATUS');
		    var AGENT = mySheet.GetCellValue(Row,'AGENT');
		    openSearchPopup('/wmgr/showMasterWmGrStockGrDetailPop.do','?ware_house_code='+ware_house_code+'&PR_ADD_USER_NAME='+USER_NAME_LOC+'&PO_NO='+PO_NO+'&PO_CREATE_DATE='+VPO_DATE+
		    		'&RD_DATE='+RD_DATE+'&AGENT_NAME='+COM_NAME_LOC+'&name_gubun=VMI'+'&ware_house_name='+ware_house_name+'&STATUS='+STATUS+'&AGENT='+AGENT, "1200,500,no"); 

			popupSel = "masterWmGrStockGrDetailPop";
		}
	}
	else if(column=="COM_NAME_LOC" )
	{
		if(mySheet.GetCellValue(Row,'AGENT')!="")
		{
			 var com_code = mySheet.GetCellValue(Row,'AGENT');
			 var st_from_date = document.searchCondition.st_from_date.value;
			 var st_to_date = document.searchCondition.st_to_date.value;
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if(popupSel == "agent_single"){
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
			<h3>VMI입고</h3>
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
			
            	<table  class="cont_t_list01" >
					<caption>VMI입고</caption>
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
							<th>센터예정일</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a> - 
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
								 <span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>				
						    <th>물류센터</th>
							<td>
								<select id="st_warehouse_code" name="st_warehouse_code" style="width:90%;height:20px" 	<%=whAdmin.equals("Y") ? "" : "disabled"%>>
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
					</tbody>
				</table>		
				
				    <table  class="cont_t_list01" >
					<caption>VMI입고</caption>
						<colgroup>
							<col width="8%" />
							<col width="17%" />
                            <col width="8%" />
							<col width="17%" />
                            <col width="8%" />
							<col width="17%" />
                            <col width="8%" />
							<col width="17%" />
						</colgroup>
						<tbody>		
						<tr>							
							<th>협력사</th>
							<td>
							    <input type="text" class="input_type_text" id="st_agent_name" name="st_agent_name" style="width:58%;" value="" onclick="javascript:doPop('agent_single');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" value="">
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<th>발주번호</th>
							<td>
								<input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:80%" value=""  onKeyUp="kepToUpper(id)" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							</td>
							<th>입고번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_iv_no" name="st_iv_no" style="width:80%;" value="" onKeyUp="kepToUpper(id)" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							<th>상태</th>
							<td>
							    <select id="st_status_check" name="st_status_check" style="width:80%;height:20px">
									 <option value="">전 체</option>
              						 <option value="A">발주</option>
              						<option  value="B">입고예정</option>
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
			<select name="st_orderBy">
				<option value="1" selected>입고예정일순</option>
				<option value="2">고객사순</option>
				<option value="3">공급사순</option>
				<option value="4">발주번호순</option>
				<option value="5">입고번호순</option>
			</select>
			</span>	
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  					<p class="paging" id="pageindex"></p>
  			</div>
  			<br/>
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
  	          	<!-- 
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				 -->
  				</span>
  				
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('save');">입고확정</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
