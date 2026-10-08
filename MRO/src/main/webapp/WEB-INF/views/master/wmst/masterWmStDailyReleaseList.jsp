<%--
**********************************************
* 메뉴 : 재고일일수불_일일입출고List
* 화면 : 재고일일수불_일일입출고List
* 기능 : 일자별 일일 수불 리스트를 조회함.
* 프로그램 ID : PG_08_M_014_00
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-8-28
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


String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_po_user_id"),""); 
String whAdmin = _sessionInfo.getWhAdmin();
%> 
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
		      			{Align : "Center",SaveName : "ROWSEQ",	Header : "순번|순번",	Type : "Text",	Width : 60,	Hidden : 0}, 
		    			{Align : "Left",SaveName : "STDCATLG_ID",		Header : "품목코드|품목코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
		    			{Align : "Left",SaveName : "DESCRIPTION_LOC",		Header : "품목명|품목명",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격|규격",	Type : "Text",	Width : 250, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Left",SaveName : "MAKER_PART_NO",		Header : "모델번호|모델번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "SAFE_STOCK_QTY",		Header : "안전재고|안전재고",Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "STCOK_DAY",		Header : "재고일수|재고일수",	Type : "Float",  Format:"${qtyFormat}",Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "YESTERDAY_QTY",		Header : "전일|재고",	Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "TO_GR_QTY",		Header : "당일|입고",	Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "TO_IV_QTY",		Header : "당일|출고",	Type : "Float",  Format:"${qtyFormat}",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Right",SaveName : "CUR_QTY",		Header : "당일|재고",	Type : "Float",  Format:"${qtyFormat}",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Right",SaveName : "CONTRACT_SEQ",		Header : "CONTRACT_SEQ|CONTRACT_SEQ",	Type:"Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
		    			{Align : "Right",SaveName : "CONTRACT_NO",		Header : "CONTRACT_NO|CONTRACT_NO",	Type:"Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
		    			{Align : "Right",SaveName : "CONTRACT_NO",		Header : "CONTRACT_NO|CONTRACT_NO",	Type:"Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true}
	];
    initsheet.HeaderMode = { Sort : 0, ColMove : 1, ColResize : 1 };
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	var initsheet2 = {};
	initsheet2.Cols = [ 
		      			
		    			{Align : "Left",SaveName : "STDCATLG_ID",		Header : "상품코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
		    			{Align : "Left",SaveName : "DESCRIPTION_LOC",		Header : "품목명",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 250, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Left",SaveName : "MAKER_PART_NO",		Header : "모델번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "YESTERDAY_QTY",		Header : "전일재고",	Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "TO_GR_QTY",		Header : "당일입고",	Type : "Float",  Format:"${qtyFormat}",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Right",SaveName : "TO_IV_QTY",		Header : "당일출고",	Type : "Float",  Format:"${qtyFormat}",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Right",SaveName : "CUR_QTY",		Header : "당일재고",	Type : "Float",  Format:"${qtyFormat}",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Right",SaveName : "SAFE_STOCK_QTY",		Header : "안전재고",Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "MAX_STOCK_QTY",		Header : "최대재고",Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "PO_LIMIT_QTY",		Header : "발주점",Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "TO_PO_QTY",		Header : "발주량",Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "AGENT_NAME",		Header : "매입처",Type:"Int", Format:"Integer",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "MONTHLY_AVG_PO_QTY",		Header : "월평균소요량",Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "DAILY_AVG_PO_QTY",		Header : "일평균소요량",Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "STCOK_DAY",		Header : "재고일수",	Type:"Int", Format:"Integer",Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "PRE_GR_QTY",		Header : "입고예정재고",	Type : "Float",  Format:"${qtyFormat}",Width : 100, EditLen : 110,	Edit : false, Hidden : false}
	];
	initsheet2.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	IBS_InitSheet(mySheet2, initsheet2,pagingMode);
	
	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);

	//콤보데이터 셋팅		
	if(document.searchCondition.st_warehouse_code.options.length == 1 )
	{
		document.searchCondition.st_warehouse_code.disabled = true;
	}
	//하이퍼링크 설정
	setLinkCol(mySheet, "STDCATLG_ID");	
	
	// 조회조건 초기화
	kepSetCalender("st_cur_date");
	
	$("#st_cur_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
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
		kepSearch(document.searchCondition ,  mySheet , "/wmst/getMasterWmStDailyReleaseList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$("#st_cur_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
		mySheet.RemoveAll();
		break;
		
		
	case "excelDown": // 엑셀다운로드
		var param = {FileName:"일일입출고List.xlsx"}
	    kepDownExcel(document.searchCondition ,mySheet2 ,  "/wmst/excelMasterWmStDailyReleaseList.do", param);
		break;
	}
}
function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	
	if (msg != "") {
		alert(msg);
	}

}
//조회 후처리
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	
	if (msg != "") {
		alert(msg);
	}

}	
	
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}




}


// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {

	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if(column=='STDCATLG_ID')
	{
		if(mySheet.GetCellValue(Row,'STDCATLG_ID')!=""){

				var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "STDCATLG_ID");
				var BYIT_COMORG_CODE =  document.searchCondition.st_warehouse_code.value;
				var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
				var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
				openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ, "800,250,no"); 

		}
	}
	
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	

	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>일일입출고List</h3>
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
			
            	<table  class="cont_t_list01"  width="940px" >
					<caption>일일입출고List</caption>
					<colgroup>
							<col width="12%" />
							<col width="38%" />
							<col width="12%" />
							<col width="38%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>조회일자</th>
							<td>
								<input type="text" class="al" name="st_cur_date" id="st_cur_date" readOnly style="width:32%; text-align:center;" value="">	
								&nbsp;&nbsp;&nbsp;<input type="checkbox" name="st_isZero" value="Y"  onclick="doAction('search')">수량 0 제외			
							</td>
							
						   <th>물류센터</th>
							<td>
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
					</tbody>
				</table>
            </div>
            
           
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			 <div class="ib_product" style="border-top:2px solid #3c639c; display:none;">
  				<script type="text/javascript">
  					createIBSheet("mySheet2", "100%", "354px");
  				</script>
  			</div>
  			</br>
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
  	          	<!-- 
					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
				 -->
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
