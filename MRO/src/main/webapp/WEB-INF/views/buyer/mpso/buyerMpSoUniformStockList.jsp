<%--
**********************************************
* 메뉴(고객사) : 주문관리 > 유니폼 재고현황
* 화면 : 유니폼 재고현황
* 기능 : 
* 프로그램 ID : 
* 담당자 : HSJ
* 착수일 : 2020-05-06
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
	SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/smoothness/jquery-ui.min.css"/>   
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/common.js"></script>
<style type="text/css">
	table.ui-datepicker-calendar { display:none; }
</style>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
		{ Align:"Left",		Width:200,	Edit:false,	EditLen:20,		Hidden:true,	Type:"Text",		Header:"사업장",	SaveName:"BUYER"}
		,{ Align:"Left",	Width:180,	Edit:false,	EditLen:20,		Hidden:false,	Type:"Text",		Header:"사업장명",	SaveName:"BUYER_NAME"}
		,{ Align:"Center",	Width:150,	Edit:false,	EditLen:30,		Hidden:false,	Type:"Text",		Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Left",	Width:230,	Edit:false,	EditLen:20,		Hidden:false,	Type:"Text",		Header:"품명",	SaveName:"DESCRIPTION"}
		,{ Align:"Left",	Width:230,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"규격",	SaveName:"SPECIFICATION"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"생산요청",	SaveName:"REQ_QTY"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"생산입고",	SaveName:"GR_QTY"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"출고",	SaveName:"CHUL_QTY"}
		,{ Align:"Right",	Width:70,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"반품",	SaveName:"RTN_QTY"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"남은수량",	SaveName:"STOCK_QTY"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	kepAjaxCommonQueryIdSearchTwoCombo('st_buyer','buyer.mpso.selectBuyerMpSoUniformReqCompanyList', '${sessionInfo.comCode}', '${sessionInfo.userId}', 'ALL','');
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "GR_QTY"); // 생산입고
}
	
var st;
var mt;

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {
	
	st = new Date();

	switch (str) {
		case "search": // 조회
			// 조회조건 체크
			if ( !searchValidate() )
				return;
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpso/getBuyerMpSoUniformStockList.do" , pagingMode );
			break;
		
		case "reload": // 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
			
		case "excelDown": // 엑셀다운로드
			// 조회조건 체크
			if ( !searchValidate(str) )
				return;
			
		    $("#pageflag").val('0');
		    var param = {FileName:"유니폼재고현황.xlsx",Merge:1,SheetDesign:1,DownCols:"BUYER_NAME|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|REQ_QTY|GR_QTY|CHUL_QTY|RTN_QTY|STOCK_QTY"};
			kepDownExcel(document.searchCondition ,mySheet , "/mpso/excelBuyerMpSoUniformStockList.do", param);
			$("#pageflag").val('1');
			break;
	}
}
	
// 조회조건 체크
function searchValidate(value) {
	if(value == "excelDown" && mySheet.RowCount() == 0){
		alert("조회 후 이용하여 주시기 바랍니다.");
		return false;
	}

	return true;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
   	
	if (msg != "") {
		alert(msg);
	}

	var totRow = mySheet.RowCount();
	for(var i=1; i<=totRow;i++){
		var GR_QTY = mySheet.GetCellValue(i, 'GR_QTY'); 
		
		if(GR_QTY > 0) { // 생산입고수량 존재 
			mySheet.SetCellFontColor(i,"GR_QTY","blue");
		}else{
			mySheet.SetCellFontColor(i,"GR_QTY","black");
		}
	}
	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
}

// 상신 기능에서 코드 중복 활용 예정
function mySheet_OnAfterEdit(Row, Col) {
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getBuyerMpSoUniformStockList.do?page="+current_page , pagingMode );
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if(Row < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	var st_buyer = mySheet.GetCellValue(Row, "BUYER");
	var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
	
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if (column == "GR_QTY") {
		doPop("buyerMpSoUniformGrHistoryPop", st_buyer, st_buyer_item_no);
	}
	
	return;
}

// 팝업함수호출
function doPop(str, val1, val2) {
	popupSel = str;
	
	switch (str) {
		case "buyerMpSoUniformGrHistoryPop": // 생산입고 이력관리 팝업
			popupSel = "buyerMpSoUniformGrHistoryPop";
			openSearchPopup("/mpso/getBuyerMpSoUniformGrHistoryPop.do", '?buyer='+val1+'&st_buyer_item_no='+val2, "700,500,no");
			break;
	}
}
	
// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {
}

</script>
</head>
<body onload="kep_onload_view()">
<!-- 메뉴 S --> 
<div id="wrapper"> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
	<c:param name="page" value="buyerLeft"/>
	<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->

<!--내용 시작-->
<div id="container2">
	<div id="ContArea">
		<h3>유니폼 재고현황</h3>
    	<div id="searchBtnA">
			<!--버튼영역-->
	        <span class="btn_search"><a href="javascript:doAction('search')"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></a></span> 
			<span class="btn_reset"><a href="javascript:doAction('reload')"><%=CommonLang.get("HTITLE8")%><!-- 초기화 --></a></span>
	   	</div>        	
    
	    <!--조회영역-->
		<form name = "searchCondition" method = "post">
			<div id="cont_searchA">
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="pageflag" name="pageflag" value="1">
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_byca_comorg_code" name="st_byca_comorg_code"  value="${sessionInfo.bycaComorgCode}">
				<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
					
				<table  class="cont_t_list01" style="width:100%;">
					<caption>유니폼 재고현황</caption>
					<colgroup>
						<col width="10%" />
						<col width="23%" />
						<col width="10%" />
						<col width="23%" />
						<col width="10%" />
						<col width="24%" />
					</colgroup>
								
					<tbody>
						<tr>
							<th><%=CommonLang.get("HTITLE405")%><!-- 사업장명 --></th>
							<td>
								<select id="st_buyer" name="st_buyer" style="width:80%;height:20px"></select>
							</td>
							
							<th></th>
							<td></td>
							
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th>상품코드</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:80%;" value="" onKeyDown="kepEnter()">
							</td>
							
							<th>품명</th>
							<td>
								<input type="text" class="input_type_text" name="st_description" id="st_description" style="width:80%;" value="" onKeyDown="kepEnter()">
							</td>
							
							<th>규격</th>
							<td>
								<input type="text" class="input_type_text" name="st_specification" id="st_specification" style="width:80%;" value="" onKeyDown="kepEnter()">
							</td>
						</tr>
					</tbody>
				</table>
			</div>
	            
			<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
				<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
					<option value="20">20<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
					<option value="30">30<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
					<option value="40">40<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
					<option value="50">50<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
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
				<span class="btn_02"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
			</span>
		</div>
<!--내용 종료-->
	                 
	</div>
</div>

<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
</div>

</body>
</html>
