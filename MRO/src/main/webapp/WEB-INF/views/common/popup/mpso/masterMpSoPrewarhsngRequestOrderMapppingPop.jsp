<%--
**********************************************
* 메뉴 : 
* 화면 : 선입고요청 발주매핑
* 기능 : 선입고요청과 선입고발주와의 매핑처리를 하기위한 팝업
* 프로그램 ID : PG_06_M_012_04
* 담당자 : 고영일 ( 설계 : 김지현 )
* 착수일 : 2014-08-01
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<%
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String st_bs_no = CommonUtil.nvl((String) request.getParameter("st_bs_no"),"");
String st_close_item_qty = CommonUtil.nvl((String) request.getParameter("st_close_item_qty"),"");
String st_item_qty = CommonUtil.nvl((String) request.getParameter("st_item_qty"),"");
String st_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");
String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");
String st_desc_spec = CommonUtil.nvl((String) request.getParameter("st_desc_spec"),"");
%> 
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",	SaveName : "sStatus",				Header : "상태",		Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",	SaveName : "SELECTED",			Header : "",				Type : "DummyCheck",	Width : 60,	EditLen : 50,			Hidden : false}, 
	    			{Align : "Center",	SaveName : "PO_NO",				Header : "발주번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",	SaveName : "BUYER_ITEM_NO",	Header : "품목코드",	Type : "Text",	Width : 120, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",		SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",	SaveName : "UNIT_PRICE",			Header : "매출단가",	Type : "Float",  Format:"${priceFormat}",		Width : 80,   EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",	SaveName : "AGENT_PRICE",		Header : "매입단가",	Type : "Float",  Format:"${priceFormat}",		Width : 80,   EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",	SaveName : "ITEM_QTY",			Header : "수량",		Type : "Float",  Format:"${qtyFormat}",		Width : 60, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",	SaveName : "UNIT_MEASURE",	Header : "단위",		Type : "Text",	Width : 60, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",	SaveName : "SPECIFICATION",	Header : "규격",		Type : "Text",	Width : 250, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",	SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 120, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",	SaveName : "ORIGIN_NAME",		Header : "원산지",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",	SaveName : "AGENT_NAME",		Header : "협력사",	Type : "Text",	Width : 120, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",	SaveName : "REQ_DEPT_NAME",	Header : "요청부서",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",	SaveName : "REQ_USER_NAME",	Header : "요청자",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",	SaveName : "PO_SEQ",				Header : "발주항번",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	];
	
	initsheet.Cfg = {FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}


var st;
var mt;
//기능함수 
function doAction(str) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str != "setBeforeStockedMappingCancel" && str != "search" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	switch (str) {
		case "search": //조회
			pagingMode = "N";
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoPrewarhsngRequestOrderMapppingPop.do" , pagingMode );
			break;
			
		case "setBeforeStockedFinish": //발주완료
			var st_po_no = $("#st_po_no").val();
			for(var inx = 0 ; inx < arrRow.length ; inx++){
				var po_no = mySheet.GetCellValue(arrRow[inx],"PO_NO");
				if(st_po_no.indexOf(po_no) > -1){
					alert(arrRow[inx]+"번째 행은 이미 발주된 발주번호입니다.");
					return;
				}
			}

			if(!$.isNumeric($("#st_close_item_qty").val()) || Number($("#st_close_item_qty").val()) <= 0) {
				alert("정산수량을 입력하여 주십시오.");
				$("#st_close_item_qty_text").val("0");
				$("#st_close_item_qty").val("0");
				$("#st_close_item_qty_text").focus();
				return ;
			}
		
			if(confirm("발주완료 하시겠습니까?")){
				kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoPrewarhsngMappingReg.do" , "SELECTED" );
			}
		
			break;
			
		case "setBeforeStockedPartialFinish": //부분발주완료
			if(!$.isNumeric($("#st_close_item_qty").val()) || Number($("#st_close_item_qty").val()) <= 0) {
				alert("정산수량을 입력하여 주십시오.");
				$("#st_close_item_qty_text").val("0");
				$("#st_close_item_qty").val("0");
				$("#st_close_item_qty_text").focus();
				return ;
			}
		
			if(confirm("부분발주완료 하시겠습니까?")){
				kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoPrewarhsngMappingPartialReg.do" , "SELECTED" );
			}
			
			break;
			
		case "setBeforeStockedMappingCancel": //매핑 취소 ( 발주 취소 )
		
			if(isEmpty($("#st_po_no").val())){
				alert("발주매핑 정보가 없어 취소 할 수 없습니다.");
				return;
			}
		
			if(confirm("매핑취소 하시겠습니까?")){
				popupSel = "setBeforeStockedMappingCancel";
				kepSearch(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoPrewarhsngMappingCancelReg.do", pagingMode );
			}
			
			break;
			
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			
			// 조회조건 초기화
			kepSetCalender("st_from_date");
			kepSetCalender("st_to_date");
			
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			
			break;
	}

}

function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if(popupSel == "setBeforeStockedMappingCancel"){
		if(code>0){
			popupSel = "";
			alert("저장완료.");
			opener.doAction('search');
			self.close();
			return;
		}
	}
	
	if(mySheet.RowCount() <= 0) return;
	
	if (msg != "") {
		alert(msg);
	}
	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if(code>0){
		opener.doAction('search');
		self.close();
	}
}

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	pagingMode = "P";
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoPrewarhsngRequestOrderMapppingPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "SELECTED" ){
		var item_qty = mySheet.GetCellValue(Row,"ITEM_QTY");
		var item_cnt = Number($("#st_close_item_qty").val());
		if(mySheet.GetCellValue(Row,"SELECTED") == "1"){
			item_cnt += Number(item_qty);
		}else{
			item_cnt -= Number(item_qty);
		}
		$("#st_close_item_qty_text").val(item_cnt);
		$("#st_close_item_qty_text").val(kepNumComma("st_close_item_qty_text"));
		$("#st_close_item_qty").val(item_cnt);
	}
	return;
}

function mySheet_OnCheckAllEnd(Col, Value) {
	if(Value){
		var sum = 0;
		for( var i = 1; i <= mySheet.RowCount(); i++ ) {
			sum += Number(mySheet.GetCellValue(i, "ITEM_QTY"));
		}
		$("#st_close_item_qty_text").val(sum);
		$("#st_close_item_qty_text").val(kepNumComma("st_close_item_qty_text"));
		$("#st_close_item_qty").val(sum);
	}else{
		$("#st_close_item_qty_text").val("0");
		$("#st_close_item_qty").val("0");
	}
}

function displayNumber(obj){
	$("#st_close_item_qty").val(obj.value);
	obj.value = kepNumComma(obj.id);
}


//확인
function kepConfirm()
{ 
 var value1 = mySheet.GetCellValue(grbRow, "BUYER")+"@";
 var value2 = mySheet.GetCellValue(grbRow, "BUYER_NAME");
 
 opener.setPopupReturn(value1,value2);
 
 this.close();
}
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	
	<input type="hidden" id="st_po_no" name="st_po_no" value="<%=st_po_no%>">
	<input type="hidden" id="st_buyer" name="st_buyer" value="<%=st_buyer%>">
	<input type="hidden" id="st_bs_no" name="st_bs_no" value="<%=st_bs_no%>">
	<input type="hidden" id="st_check" name="st_check" value="">
	<input type="hidden" id="st_query" name="st_query" value="">
	
	<div id="popWrapper" style="height:610px;">
    	<div id="popHeader">
        	<h1 class="title">선입고요청 발주매핑</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
            	<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
            </div>
            <!--조회영역-->
        	<div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="12%" />
							<col width="21%" />
							<col width="12%" />
							<col width="21%" />
							<col width="12%" />
							<col width="*" />
						</colgroup>
						
						<tbody>
						<tr>
							<td>발주일</td>
							<td colspan="5">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
			                </td>
						</tr>
						<tr>
							<td>품목코드</td>
							<td>
								<input type="text" name="st_buyer_item_no" id="st_buyer_item_no" value="<%=st_buyer_item_no %>" class="input_type_text" title="" style="width:80%;" onkeyup="kepToUpper('st_buyer_item_no')" onkeydown="kepEnter()" />
							</td>
							<td>협력사</td>
							<td>
								<input type="text" name="st_agent_name" id="st_agent_name" class="input_type_text" title="" style="width:80%; ime-mode:active" onkeydown="kepEnter()" />
							</td>
							<td>관리번호</td>
							<td>
								<input type="text" name="st_ref_pr_no" id="st_ref_pr_no" class="input_type_text" title="" style="width:80%; ime-mode:inactive" onkeydown="kepEnter()" />
							</td>
						</tr>
						<tr>
							<td>품목명/규격</td>
							<td>
								<input type="text" name="st_desc_spec" id="st_desc_spec" value="<%=st_desc_spec %>" class="input_type_text" title="" style="width:80%; ime-mode:active" onkeydown="kepEnter()" />
							</td>
							<td>제조사</td>
							<td>
								<input type="text" name="st_maker_name" id="st_maker_name" class="input_type_text" title="" style="width:80%; ime-mode:active" onkeydown="kepEnter()" />
							</td>
							<td>요청자</td>
							<td>
								<input type="text" name="st_req_user_nmae" id="st_req_user_nmae" class="input_type_text" title="" style="width:80%; ime-mode:active" onkeydown="kepEnter()" />
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "325px");
				</script>
			</div>
			<div id="pageindex"></div>
			
			<!--버튼영역-->
			<div class="btnArea" style="margin-top: 10px;">
  	          	<span class="fl">
  					<span>선입고 요청 수량 : <%=CommonUtil.formatNumber(st_item_qty, true, 0, 3) %>&nbsp;&nbsp;현재 총 정산수량 : <%=CommonUtil.formatNumber(st_close_item_qty, true, 0, 3)%>&nbsp;&nbsp;
				 정산수량 : <input type="text" id="st_close_item_qty_text" name="st_close_item_qty_text" value="0" style="width:50px;text-align:right;" onblur="displayNumber(this);">&nbsp;&nbsp;
  					<input type="hidden" id="st_close_item_qty" name="st_close_item_qty" value="0"></span>
  				</span>
  				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:doAction('setBeforeStockedFinish');">발주 완료</a></span>
					<span class="btn_04 mr04"><a href="javascript:doAction('setBeforeStockedPartialFinish');">부분발주 완료</a></span>
					<span class="btn_02 mr04"><a href="javascript:doAction('setBeforeStockedMappingCancel');">매핑 취소</a></span>
  				</span>
  			</div>
		</div>	
    </div>
</form> 
</body>
</html>
