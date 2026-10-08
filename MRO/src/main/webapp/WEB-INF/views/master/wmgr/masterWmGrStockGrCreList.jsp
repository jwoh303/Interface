<%--
**********************************************
* 메뉴 : 입고>입고등록>재고입고
* 화면 : 재고입고
* 기능 : 재고입고 예정정보 조회 및 입고 확정
* 프로그램 ID : PG_08_M_002_00
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-5-23
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
	
	String whAdmin = _sessionInfo.getWhAdmin();
	String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_po_user_id"),""); // 조회조건

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

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
						 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
							,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태",	SaveName:"STATUS"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주번호",	SaveName:"PO_NO"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"LEGACY_NO",	SaveName:"LEGACY_PO_NO"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"입고번호",	SaveName:"IV_NO"}

							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date", Format:"Ymd",	Header:"발주일",	SaveName:"PO_CREATE_DATE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"납품요청일",	SaveName:"RD_DATE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date", Format:"Ymd",	Header:"입고예정일",	SaveName:"DS_DATE"}
							
							,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", Header:"협력사",	SaveName:"AGENT_NAME"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",  Header:"협력사전화번호",	SaveName:"AGENT_TEL"}
							
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Format:"${qtyFormat}", Header:"품목수",	SaveName:"COUNT"}
							,{ Align:"Right",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float", Format:"${priceFormat}", Header:"금액",	SaveName:"ITEM_AMT"}
							
							,{ Align:"Center",	Width:60,	    Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"요청자", SaveName:"ADD_USER_NAME_IMG"} 
							,{ Align:"Left",	Width:240,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자",	SaveName:"PR_ADD_USER_NAME"}
							
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",  Header:"협력사코드",	SaveName:"AGENT_CODE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",  Header:"고객사코드",	SaveName:"BUYER"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",  Header:"고객사명",	SaveName:"BUYER_NAME"}
							,{ Align:"Center",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",  Header:"요청자전화번호",	SaveName:"PR_USER_NAME"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",  Header:"비고",	SaveName:"POHD_REMARK"}
					
	];

	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "PO_NO");	//발주번호
	setLinkCol(mySheet, "IV_NO"); //입고번호
	setLinkCol(mySheet, "ADD_USER_NAME_IMG");
	setLinkCol(mySheet, "BUYER_NAME");
	setLinkCol(mySheet, "AGENT_NAME");
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_to_date").val( kepToMonthAdd("1","P"));
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	
	
	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);

	//콤보데이터 셋팅		



}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	//	var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("입고확정 대상을 선택해 주십시요.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		if(kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val())== false){
			return;
		}
		//기간무시
	    if(document.getElementById("st_checkbox").checked == true){
	    	$("#st_all_po").val('Y');		
	    	var po_no			= $("#st_po_no").val();
	    	var iv_no			= $("#st_iv_no").val();
			if( po_no =="" && iv_no == ""){
				alert("기간을 무시하고 조회시\n\n고객사 선택후\n\n발주번호, 입고번호 중\n\n한가지 이상을 정확히(전체입력) 기입해야 합니다.");	
				return;
			}			
		}else{
			$("#st_all_po").val('N');
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n3개월 이상의 데이타는 S/R 요청 바랍니다.");
				return ;
			}			
		}
			current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/wmgr/getMasterWmGrStockGrCreList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepToMonthAdd("1","P"));
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		document.getElementById("st_checkbox").checked = false;
		break;

	case "save": // 저장
		if (!confirm('선택사항을 센터 입고 하시겠습니까? '))
			return;
		kepSave(document.searchCondition ,  mySheet , "/wmgr/saveMasterWmGrStockGrCreList.do" , "SELECTED" );
		break;
		
	case "del": // 취소
		if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/wmgr/delMasterWmGrStockGrCreList.do" , "SELECTED" );
		break;

	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
		var param = {FileName:"MyExcel.xlsx",Merge:1,SheetDesign:1,
			DownCols:"STATUS|LEGACY_PO_NO|PO_NO|IV_NO|PO_CREATE_DATE|RD_DATE|DS_DATE|COUNT|AGENT_NAME|AGENT_TEL"};
		kepDownExcel(document.searchCondition ,mySheet , "/wmgr/excelMasterWmGrStockGrCreList.do", param);
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

   	
   	
	for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++)
	{
		
		if(mySheet.GetCellValue(i,"STATUS")=="발주")
		{
			mySheet.SetCellEditable(i, "SELECTED", 0);
		}
		if(mySheet.GetCellValue(i,"ADD_USER_NAME")!="")
		{
			mySheet.SetCellValue(i, 'ADD_USER_NAME_IMG', remarkOn);
		}
		else{
			mySheet.SetCellValue(i, 'ADD_USER_NAME_IMG', remarkOff);
		}
		
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
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	
	if(code ==1){
		alert("정상적으로 센터 입고확정 되었습니다.");		
		//저장 성공시 재조회
		doAction('search');
	}else{
		alert(msg);
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrStockGrCreList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
	case "agent_single": // 협력사 M
		openSearchPopup('/coco/showCommonCoCoCompanyPop.do','?com_type=S&multi_flag=M&safety_flag=undefined&save_flag=undefined', "500,500,no"); 
		popupSel = "agent_single";
		break;	
			
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	//발주번호를 클릭했을 때 
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
	else if (column == 'PO_NO') { // 발주 번호 
		
		if(mySheet.GetCellValue(Row,'PO_NO')!=""){
			
			var ware_house_name = document.searchCondition.st_warehouse_code.options[document.searchCondition.st_warehouse_code.selectedIndex].text;
			var ware_house_code = document.searchCondition.st_warehouse_code.value;
		    var PR_ADD_USER_NAME = mySheet.GetCellValue(Row,'PR_ADD_USER_NAME'); 
		    var PO_NO = mySheet.GetCellValue(Row,'PO_NO');
			var PO_CREATE_DATE = mySheet.GetCellText(Row,'PO_CREATE_DATE'); 
		    var RD_DATE = mySheet.GetCellText(Row,'RD_DATE');
		    var AGENT_NAME = mySheet.GetCellValue(Row,'AGENT_NAME');
		    var st_AGENT_TEL = mySheet.GetCellValue(Row,'AGENT_TEL');
		    var PR_USER_NAME = mySheet.GetCellValue(Row,'PR_USER_NAME');
		    var st_LEGACY_PO_NO = mySheet.GetCellValue(Row,'LEGACY_PO_NO');
		    var AGENT = mySheet.GetCellValue(Row,'AGENT_CODE');
		    openSearchPopup('/wmgr/showMasterWmGrStockGrDetailPop.do','?ware_house_code='+ware_house_code+'&PR_ADD_USER_NAME='+PR_ADD_USER_NAME+'&PO_NO='+PO_NO+'&PO_CREATE_DATE='+PO_CREATE_DATE+
		    		'&RD_DATE='+RD_DATE+'&AGENT_NAME='+AGENT_NAME+'&name_gubun=재고'+'&st_AGENT_TEL='+st_AGENT_TEL+'&PR_USER_NAME='+PR_USER_NAME+'&ware_house_name='+ware_house_name+'&st_LEGACY_PO_NO='+st_LEGACY_PO_NO+'&AGENT='+AGENT, "1200,500,no"); 

			popupSel = "masterWmGrStockGrDetailPop";
			
		}

		
	}
	else if(column == 'IV_NO')
	{
		var ware_house_name = document.searchCondition.st_warehouse_code.options[document.searchCondition.st_warehouse_code.selectedIndex].text;
		var ware_house_code = document.searchCondition.st_warehouse_code.value;
	    var PR_ADD_USER_NAME = mySheet.GetCellValue(Row,'PR_ADD_USER_NAME'); 
	    var PO_NO = mySheet.GetCellValue(Row,'PO_NO');
		var PO_CREATE_DATE = mySheet.GetCellText(Row,'PO_CREATE_DATE'); 
	    var RD_DATE = mySheet.GetCellText(Row,'RD_DATE');
	    var IV_NO = mySheet.GetCellValue(Row,'IV_NO');
	    var DS_DATE = mySheet.GetCellText(Row,'DS_DATE');
	    var AGENT_NAME = mySheet.GetCellValue(Row,'AGENT_NAME');
	    var STATUS = mySheet.GetCellValue(Row,'STATUS');
	    var st_AGENT_TEL = mySheet.GetCellValue(Row,'AGENT_TEL');
	    var st_LEGACY_NO = mySheet.GetCellValue(Row,'LEGACY_PO_NO');
	    var PR_USER_NAME = mySheet.GetCellValue(Row,'PR_USER_NAME');
	    var AGENT = mySheet.GetCellValue(Row,'AGENT_CODE');
	    openSearchPopup('/wmgr/showMasterWmGrStockOrderGrRegPop.do','?ware_house_code='+ware_house_code+'&PR_ADD_USER_NAME='+PR_ADD_USER_NAME+'&PO_NO='+PO_NO+'&PO_CREATE_DATE='+PO_CREATE_DATE+
	    		'&RD_DATE='+RD_DATE+'&IV_NO='+IV_NO+'&DS_DATE='+DS_DATE+'&AGENT_NAME='+AGENT_NAME+'&STATUS='+STATUS+'&name_gubun=재고'+'&ware_house_name='+ware_house_name+'&st_AGENT_TEL='
	    		+st_AGENT_TEL+'&st_LEGACY_NO='+st_LEGACY_NO+"&PR_USER_NAME="+PR_USER_NAME+'&AGENT='+AGENT, "1150,500,no"); 
	
		popupSel = "masterWmGrStockOrderGrRegPop";
	}
	else if(column=="ADD_USER_NAME_IMG" )
	{
		if(mySheet.GetCellValue(Row,'ADD_USER_NAME')!="")
		{
			var st_ADD_USER_NAME = mySheet.GetCellValue(Row,'PR_ADD_USER_NAME');
			var st_ADD_USER_TEL = mySheet.GetCellValue(Row,'PR_USER_NAME');
			var st_POHD_REMARK = mySheet.GetCellValue(Row,'POHD_REMARK');
			openSearchPopup('/wmco/showMasterWmCoRequestPop.do','?st_ADD_USER_NAME='+st_ADD_USER_NAME+'&st_ADD_USER_TEL='+st_ADD_USER_TEL+'&st_POHD_REMARK='+st_POHD_REMARK, "500,220,no"); 
			popupSel = "masterWmCoRequestPop.jsp";
		}		
	}else if(column=="AGENT_NAME" )
	{
		if(mySheet.GetCellValue(Row,'AGENT_NAME')!="")
		{
			 var com_code = mySheet.GetCellValue(Row,'AGENT_CODE');
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
			<h3>재고입고</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
			<input type="hidden" id="IV_NO_pop"  name="IV_NO_pop" value="N">
			<input type="hidden" id="pageflag" name="pageflag" value="1">				
			<input type="hidden" name="st_all_po"  id="st_all_po" value ="N">
            	<table  class="cont_t_list01" >
					<caption>재고입고</caption>
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
								<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox">&nbsp;기간무시				
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
					<caption>재고입고</caption>
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
								<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:80%" value="">
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
 
							<th>발주번호</th>
							<td>
								<input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:86%" value=""  onKeyUp="kepToUpper(id)" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							</td>
							<th>입고번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_iv_no" name="st_iv_no" style="width:86%;" value="" onKeyUp="kepToUpper(id)" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							</td>
							<th>상태</th>
							<td>
							    <select id="st_status_check" name="st_status_check" style="width:86%;height:20px">
									 <option value="전체">전 체</option>
              						 <option value="발주">발주</option>
              						<option  value="입고예정">입고예정</option>
              						<option  value="분할입고예정">분할입고예정</option>
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
					<select name="st_order_by" id="st_order_by" style="width: 100px;" >
        				<option value="BGR">입고예정일순</option>
        				<option value="BUY">고객사순</option>
        				<option value="AGE">협력사순</option>
        				<option value="BPO">발주번호순</option>
        				<option value="BGR">입고번호순</option>
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
  			
  			<!--버튼영역-->
  			<br/>
               <div class="btnArea">
  	          	<span class="fl">
  	          	<!-- 
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				-->
  				</span>
  				
  				<span class="fr">
  					<span class="btn_02"><a href="javascript:doAction('save');">입고확정</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
