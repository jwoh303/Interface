<%--
**********************************************
* 메뉴 : 입고관리>자산인식표발행
* 화면 : 자산인식표발행
* 기능 : 중앙대학교(KRCHUN0208) 전용 화면
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
    String moveToMaster = CommonUtil.nvl((String) request.getParameter("moveToMaster"),""); // 조회조건
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

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:40,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
		,{ Align:"Center",	Width:120,		Edit:true,	EditLen:30,	Hidden:false,	Type:"Text",				Header:"주문번호",				SaveName:"ORDER_NO"}
		,{ Align:"Center",	Width:60,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	Header:"발행",						SaveName:"TAG_PRINT_CHECK" , BackColor:"${optColor}"}
		,{ Align:"Center",	Width:60,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	Header:"부착",						SaveName:"TAG_ATTACH_CHECK", BackColor:"${optColor}"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
		,{ Align:"Left",	Width:250,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"수량",	SaveName:"ITEM_QTY", Format:"${priceFormat}"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"판매단가",	SaveName:"UNIT_PRICE", Format:"${priceFormat}"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"주문금액",	SaveName:"ITEM_AMT", Format:"${priceFormat}"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"부서명",	SaveName:"REQ_DEPT_NM"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"예산부서명",	SaveName:"BUDGET_DEPT_NM"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"주문자",	SaveName:"REQ_USER_NM"} 
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"주문일자",	SaveName:"ADD_DATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"배송완료일자",	SaveName:"DELIVERY_DATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"입고일자",	SaveName:"GR_DATE"}
		,{ Align:"Left",	Width:500,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"호실정보",	SaveName:"DELY_TO_LOCATION"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BUYER",	SaveName:"BUYER",	Sort:0}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PO_NO",	SaveName:"PO_NO",	Sort:0}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PO_SEQ",	SaveName:"PO_SEQ",	Sort:0}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"발행",	SaveName:"TAG_PRINT_FLAG",	Sort:0}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"부착",	SaveName:"TAG_ATTACH_FLAG",	Sort:0}

	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	// 하이퍼링크 설정
	setLinkCol(mySheet, "ZIP_CODE"); // 요청자
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	$("#st_dept_type").val('');
	//doAction("search");
}
	
var st;
var mt;

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if ( str != "search" && str != "downexcel" && str != "reload"  && selectedGrid.length == 0 ) {
		alert("<%=CommonLang.msg("MSG78")%>");	//선택된 항목이 없습니다.
		return;
	}

	switch (str) {
		case "search": // 조회
			current_page = -1;
			
			if( $("#st_dept_cd").val() == "1JB10" ){ // 다빈치 캠퍼스 구매팀
				$("#st_dept_type").val('2');
			}else if( $("#st_dept_cd").val() == "1H310" ){ // 서울 캠퍼스 구매팀
				$("#st_dept_type").val('1');
			}
		
			kepSearch(document.searchCondition,  mySheet , "/wmgr/getBuyerWmGrAssetTagList.do" , pagingMode );
			break;
		
		case "reload": // 초기화
			mySheet.RemoveAll();
			$("#st_dept_type").val('');
			break;
		case "downexcel":
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		    $("#pageflag").val('0');
		    
		    if( $("#st_dept_cd").val() == "1JB10" ){ // 다빈치 캠퍼스 구매팀
				$("#st_dept_type").val('2');
			}else if( $("#st_dept_cd").val() == "1H310" ){ // 서울 캠퍼스 구매팀
				$("#st_dept_type").val('1');
			}
		    
			var param = {FileName:"자산인식표.xlsx",Merge:1,SheetDesign:1,DownCols:"ORDER_NO|TAG_PRINT_FLAG|TAG_ATTACH_FLAG|DESCRIPTION|SPECIFICATION|ITEM_QTY|UNIT_PRICE|ITEM_AMT|REQ_DEPT_NM|BUDGET_DEPT_NM|REQ_USER_NM|DELY_TO_LOCATION|ADD_DATE|DELIVERY_DATE|GR_DATE"};
			kepDownExcel(document.searchCondition ,mySheet , "/wmgr/excelBuyerWmGrAssetTagList.do", param);
			$("#pageflag").val('1');
			break;
		case "save": // 저장
			if ( !confirm('<%=CommonLang.msg("MSG292")%>') )	//선택한 항목을 저장 하시겠습니까?
				return;
			kepSave(document.searchCondition ,  mySheet , "/wmgr/saveBuyerWmGrAssetTagList.do" , "SELECTED" );
			break;

	}
}
	

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
   	
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
	
	if (msg != "") {
		alert(msg);
	}
	
	if(code>=0){
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getBuyerWmGrAssetTagList.do?page="+current_page , pagingMode );
}


// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'TAG_PRINT_CHECK'||column == 'TAG_ATTACH_CHECK') {//BM메인여부 지정시 체크박스 자동 체크
		mySheet.SetCellValue(Row,"SELECTED","1");
	} 
	return;
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {

	}
}
	
// 콜백함수(파일명은 모두 동일)
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4){
	if(value4=="dept"){
		$("#st_req_dept_code").val(value1);
		$("#st_req_dept_name").val(value2);
	}
}
function getDepartmentCode(){
	var com_code = $("#st_com_code").val();
	openSearchPopup("/common/deptCodeAdminPop.do", "?open=Y&com_code="+com_code, "500,500,no");
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
	<h3><%=CommonLang.get("HTITLE940")%><!-- 자산인식표 발행--></h3>
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
				<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
				<input type="hidden" id="st_dept_cd" name="st_dept_cd"  value="${sessionInfo.department}">
				<input type="hidden" id="st_type" name="st_type"  value="C012">
				<input type="hidden" id="st_dept_type" name="st_dept_type"  value="">
					
				<table  class="cont_t_list01" style="width:100%;">
					<caption><%=CommonLang.get("HTITLE368")%><!-- 도착지코드관리 --></caption>
					<colgroup>
						<col width="8%" />
						<col width="25%" />
						<col width="9%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
					</colgroup>
					<tbody>
						<tr> 
							<td><%=CommonLang.get("HTITLE283")%><!-- 입고일 --><input type="hidden" id="st_check_date" name="st_check_date" value="GR"></td>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_to_date')"></a>
								&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','6')">6<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span>
								<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>							
							</td>
							<td><%=CommonLang.get("HTITLE135")%><!-- 요청부서 --></td>
							<td>
								<input type="text" class="input_type_text" name="st_req_dept_name" id="st_req_dept_name" style="width:55%;ime-mode:active" value="" READONLY>
								<input type="hidden" name="st_req_dept_code" id="st_req_dept_code" value="">
						        <a href="javascript:getDepartmentCode();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
								<a href="javascript:kepEraser('st_req_dept_code','st_req_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
						</tr>
						<tr>
							<td><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></td>
							<td>
								<input type="text" id="st_desc" name="st_desc" style="width:90%"  value="" onKeyDown="kepEnter();">
							</td>
							<td><%=CommonLang.get("HTITLE186")%><!-- 주문번호 --></td>
							<td>
								<input type="text" id="st_po_no" name="st_po_no" style="width:90%" value="" onKeyDown="kepEnter();">
							</td>
							<td><%=CommonLang.get("HTITLE133")%><!-- 요청자 --></td>
							<td>
								<input type="text" id="st_pr_user" name="st_pr_user" style="width:90%" value="" onKeyDown="kepEnter();">
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
				<span class="btn_04 mr04" ><a href="javascript:doAction('downexcel');">엑셀다운로드</a></span>
			</span>
	  				
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('save');"><%=CommonLang.get("HTITLE124")%><!-- 저장 --></a></span>
			</span>
		</div>
<!--내용 종료-->
	                 
	</div>
</div>

<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
</div>
</body>
</html>
