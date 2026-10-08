<%--
**********************************************
* 메뉴 : 재고>재고현황>재고조회
* 화면 : 재고조회
* 기능 : 재고현황 및 금액 조회
* 프로그램 ID : PG_08_M_012_00
* 담당자 : 개발5 ( 설계 : 김상근 )
* 착수일 : 2014-8-21
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ include file="../../common/include/head.jspf"  %>
<%
	String buyer = "";
	String userid = "";
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
	} 
	String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_po_user_id"),""); 
	String whAdmin = _sessionInfo.getWhAdmin();
	
	//필드추가 권한여부
	boolean getRoleYn = CommonUtil.getCodeCheckReturn("M175", userid);
%>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",	Header:"팀명",	SaveName:"KEP_DEPT_NAME"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"그룹유형",	SaveName:"GROUP_TYPE"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"STDCATLG_ID"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"공급경로",	SaveName:"PROCESS_TYPE_TEXT"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"총재고",	SaveName:"TOT_QTY"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",		Header:"가용재고",	SaveName:"AVAIL_QTY"}
					,{ Align:"Right",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",		Header:"할당재고",	SaveName:"ALLOC_QTY"}
					,{ Align:"Right",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"입고예정재고",	SaveName:"PRE_GR_QTY"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"안전재고",	SaveName:"SAFE_STOCK_QTY"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",		Header:"최대재고",	SaveName:"MAX_STOCK_QTY"}
<%if(getRoleYn== false){ %>	,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${priceFormat}",	Header:"매출원가",	SaveName:"STC_SELLER_PRICE"} <%}%>
<%if(getRoleYn== true){ %>	,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float", Format:"${priceFormat}",	Header:"매출원가",	SaveName:"STC_SELLER_PRICE"} <%}%>
					,{ Align:"Left",	Width:220,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_VIEW"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd", Header:"최종입고일자",	SaveName:"LAST_REC_DATE"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"CONTRACT_NO"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"CONTRACT_SEQ"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사",	SaveName:"AGENT"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사전화번호",	SaveName:"AGENT_TEL"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float", Format:"${priceFormat}",	Header:"",	SaveName:"SUMVALUE"}
					
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	// 사업팀 콤보박스
	kepAjaxCommonQueryIdCombo('st_dept','getKepDeptList','ALL','');
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "STDCATLG_ID");	//품목코드
	setLinkCol(mySheet, "AGENT_VIEW");	//협력사

	if(document.searchCondition.st_warehouse_code_value.options.length == 1 )
	{
		for(var i = 0 ; i <document.searchCondition.st_warehouse_code.length; i++ ){
			if(document.searchCondition.st_warehouse_code.options[i].value == document.searchCondition.st_warehouse_code_value.options[0].value){
				
				document.searchCondition.st_warehouse_code.options[i].selected = true;
			}
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

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/wmst/getMasterWmStStockList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
// 		kepReload('searchCondition');
		document.forms.searchCondition.reset();
		mySheet.RemoveAll();
		$("#stckPriceSum").val("");
		$("#st_agent_code").val("");
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		break;

	case "excelDown": // 엑셀다운로드
		$("#pageflag").val("0");
		var param = {FileName:"재고조회.xlsx",
<%if(getRoleYn== false){ %>				
		DownCols:"KEP_DEPT|GROUP_TYPE|STDCATLG_ID|DESCRIPTION|SPECIFICATION|MAKER_NAME|PROCESS_TYPE_TEXT|UNIT_MEASURE|LOCATION_ID|TOT_QTY|AVAIL_QTY|ALLOC_QTY|PRE_GR_QTY|SAFE_STOCK_QTY|MAX_STOCK_QTY|STC_SELLER_PRICE|AGENT_NAME|AGENT_TEL"};
<%}else{%>
		DownCols:"KEP_DEPT|GROUP_TYPE|STDCATLG_ID|DESCRIPTION|SPECIFICATION|MAKER_NAME|PROCESS_TYPE_TEXT|UNIT_MEASURE|LOCATION_ID|TOT_QTY|AVAIL_QTY|ALLOC_QTY|PRE_GR_QTY|SAFE_STOCK_QTY|MAX_STOCK_QTY|AGENT_NAME|AGENT_TEL"};
<%}%>
		kepDownExcel(document.searchCondition ,mySheet , "/wmst/excelMasterWmStStockList.do", param);

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

   	
   	
	if (msg != "") {
		alert(msg);
	}
	if(mySheet.GetTotalRows()<1){
		$('#stckPriceSum').val("");
	}else{
		$('#stckPriceSum').val(mySheet.GetCellText(1, "SUMVALUE"));
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

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmst/getMasterWmStStockList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
	case "agent_multi": // 협력사 M
		openSearchPopup("/coco/showCommonCoCoCompanyPop.do","?com_type=S&multi_flag=M&safety_flag=undefined&save_flag=undefined","500,500,no");
		popupSel = "agent_multi";
		break;	
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if((column == 'STDCATLG_ID') )
	{
		if(mySheet.GetCellValue(Row, 'STDCATLG_ID') !="")
		{
			var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "STDCATLG_ID");
			var BYIT_COMORG_CODE =document.searchCondition.st_warehouse_code.value;
			var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
			var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
			
			openSearchPopup("/wmco/showMasterWmCoGoodsCodePop.do","?BUYER_ITEM_NO="+BUYER_ITEM_NO+"&BYIT_COMORG_CODE="+BYIT_COMORG_CODE+"&CONTRACT_NO="+CONTRACT_NO+"&CONTRACT_SEQ="+CONTRACT_SEQ,"800,255,no");
		}
	}
	else 	if(column=="AGENT_VIEW" )
	{
		if(mySheet.GetCellValue(Row,'AGENT_VIEW')!="")
		{
			var com_code = mySheet.GetCellValue(Row,'AGENT');
			openSearchPopup("/mdcp/showMasterMdCpCompyDetailViewPop.do","?com_code="+com_code,"800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	 if(popupSel == "agent_multi"){
			
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
			<h3>재고조회</h3>
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
			<div style="display:none;">
								<select id="st_warehouse_code_value" name="st_warehouse_code_value" style="width:80%;height:20px" 	<%=whAdmin.equals("Y") ? "" : "disabled"%>>
								<%
						 			Map<String, String> _mapValue = new HashMap<String, String>();
								_mapValue.put("BUYER",buyer);
								_mapValue.put("USERID",userid);
								_mapValue.put("whAdmin",whAdmin);
								%>
								<%= CommonUtil.getCodeComboQueryIdList("common.getWareHouseIdSchList","",_mapValue,"") %>
								</select>			
			
			</div>
            	<table  class="cont_t_list01" style="width:940px">
					<caption>재고조회</caption>
					<colgroup>
							<col width="80px" />
							<col width="20%" />
							<col width="80px" />
							<col width="25%" />
							<col width="80px" />
							<col width="20%" />
							<col width="80px" />
							<col width="10%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>표준코드</th>
							<td>
								<input type="text"  id="st_stdcatlg_id" name="st_stdcatlg_id" style="width:80%" value="" onkeydown="kepEnter()">						
							</td>
							<th>협력사</th>
							<td>
								<input type="text" class="input_type_text" id="st_agent_name" name="st_buyer_item_no" readonly style="width:60%;" value="" onclick="javascript:doPop('agent_multi');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" value=""  style="width:67%" value="">
								<a href="javascript:doPop('agent_multi');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<th>공급경로</th>	
							<td>
								<input type="radio" class="Noborder"  id="st_process_type" name="st_process_type" value="ALL" checked>전체 
								<input type="radio" class="Noborder"  id="st_process_type" name="st_process_type" value="1">재고
								<input type="radio" class="Noborder"  id="st_process_type"  name="st_process_type" value="3">VMI
							</td>	
							<th></th>
							<td></td>					
						</tr>
						<tr> 
							<th>물류센터</th>
							<td>
								<select id="st_warehouse_code" name="st_warehouse_code" style="width:90%;height:20px" 	>
								<%
						 			Map<String, String> _map = new HashMap<String, String>();
						 			_map.put("BUYER",buyer);
						 			_map.put("USERID",userid);
						 			_map.put("whAdmin",whAdmin);
								%>
								<%= CommonUtil.getCodeComboQueryIdList("common.getWareHouseIdSchStockList","",_map,st_warehouse_code) %>
								</select>
							</td>
							<th>제조사</th>
							<td>
								<input type="text" name="st_maker_name"  id="st_maker_name" style="width:90%" value="" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							</td>
							<th>재고유무</th>
							<td>
								<input type="radio" class="Noborder"  id = "st_isExist" name="st_isExist" value="ALL" checked>전체 
								<input type="radio" class="Noborder" id = "st_isExist"  name="st_isExist" value="Y">재고유
								<input type="radio" class="Noborder" id = "st_isExist"  name="st_isExist" value="N">재고무
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr> 

							<th>품목명</th>
							<td>
								<input type="text"  id="st_description" name="st_description" style="width:90%" value=""  onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							</td>
							<th>규격</th>
							<td>
								<input type="text"  id="st_specification" name="st_specification" style="width:90%" value="" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');">
							</td>
							<th>사업팀명</th>
							<td>
								<select id="st_dept" name="st_dept" style="width:120px; height:20px"></select>
							</td>
							<th>그룹유형</th>
							<td>
								<select id="st_group_type" name="st_group_type" style="width:80px;">
									<option value="ALL">전체</option>
									<option value="A">A</option>
									<option value="B">B</option>
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
				<option value="1" selected>공급경로순</option>
				<option value="2">표준코드순</option>
				<option value="3">협력사순</option>
				<option value="4">품목명순</option>
				<option value="5">규격순</option>
			</select>			
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c; height:310px">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "310px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl" >
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  				<span class="fr">
  				<span style="color:#4288C6;font-weight:bold">재고 금액 :</span><input type="text" name="stckPriceSum"  id="stckPriceSum" height="12" style="color:#F07624;font-weight:bold;font-size:11pt;text-align:right;border:0" > &nbsp;원 
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
