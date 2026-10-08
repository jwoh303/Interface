<%--
**********************************************
* 메뉴(고객사, 운영사, 협력사) : 주문관리 > 유니폼 진행 관리
* 화면 : 유니폼 진행 관리
* 기능 : 
* 프로그램 ID : 
* 담당자 : HSJ
* 착수일 : 2020-04-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<%
    String moveToMaster = CommonUtil.nvl((String) request.getParameter("moveToMaster"),""); // 조회조건
    String business_cond = _sessionInfo.getBusinessCond();
    String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"), "");
    String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"), "");
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		{ Align:"Center",	Width:90,	Edit:false,	EditLen:30,		Hidden:false,	Type:"Text",		Header:"요청번호",	SaveName:"ST_NO"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:30,		Hidden:false,	Type:"Text",		Header:"요청항번",	SaveName:"ST_SEQ"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:30,		Hidden:true,	Type:"Text",		Header:"상태",	SaveName:"STATUS"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:30,		Hidden:false,	Type:"Text",		Header:"상태",	SaveName:"STATUS_TEXT"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:30,		Hidden:false,	Type:"Date",		Header:"요청일",	SaveName:"ADD_DATE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:30,		Hidden:true,	Type:"Text",		Header:"고객사",	SaveName:"BUYER"}
		,{ Align:"Left",	Width:150,	Edit:false,	EditLen:30,		Hidden:false,	Type:"Text",		Header:"고객사",	SaveName:"BUYER_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:30,		Hidden:false,	Type:"Text",		Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Left",	Width:250,	Edit:false,	EditLen:20,		Hidden:false,	Type:"Text",		Header:"품명",	SaveName:"DESCRIPTION"}
		,{ Align:"Left",	Width:250,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"규격",	SaveName:"SPECIFICATION"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"단위",	SaveName:"UNIT_MEASURE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:30,		Hidden:true,	Type:"Text",		Header:"결재자",	SaveName:"APRV_ID"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:30,		Hidden:false,	Type:"Text",		Header:"결재자",	SaveName:"APRV_USER_NAME"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		Header:"요청수량",	SaveName:"ITEM_QTY"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		Header:"입고수량",	SaveName:"GR_QTY"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"비고",	SaveName:"REQ_NOTE"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	kepAjaxCommonQueryIdSearchTwoCombo('st_buyer','buyer.mpso.selectBuyerMpSoUniformReqCompanyList', '${sessionInfo.comCode}', '${sessionInfo.userId}', 'ALL2','');
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "ST_NO"); // 요청번호
	setLinkCol(mySheet, "GR_QTY"); // 입고수량
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
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if ( str != "search" && str != "reload" && selectedGrid.length == 0 ) {
		alert("<%=CommonLang.msg("MSG78")%>");	//선택된 항목이 없습니다.
		return;
	}

	switch (str) {
		case "search": // 조회
			// 조회조건 체크
			if ( !searchValidate() )
				return;
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdam/getMasterMdAmUniformProgressList.do" , pagingMode );
			break;
		
		case "reload": // 초기화
			kepReload('searchCondition');
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			document.forms.searchCondition.st_period_ignore.checked = false;
			document.forms.searchCondition.st_period_ignore_value.value = "N";
			mySheet.RemoveAll();
			break;
	
	}
}
	
// 조회조건 체크
function searchValidate() {
	if ( kepTrim("st_buyer") == '' ) {
		alert("<%=CommonLang.msg("MSG342")%>");	//고객사를 선택해 주십시오
		return false;
	}
	
	if(document.forms.searchCondition.st_period_ignore.checked == false){
		document.forms.searchCondition.st_period_ignore_value.value = "N";
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false)
			return false;
		
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 92 ){
			alert("조회기간은 최대 3개월 단위로 조회가 가능합니다.");
			return false;
		}	
	}else{
		document.forms.searchCondition.st_period_ignore_value.value = "Y";
		
		if(kepTrim("st_st_no") == '' && kepTrim("st_buyer_item_no") == ''){
			alert("요청번호 혹은 품목코드는 필수 입력입니다.");
			return false;
		}
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
		var STATUS = mySheet.GetCellValue(i, 'STATUS'); 
		
		if(STATUS == "SC" || STATUS == "GP" || STATUS == "GC") { // 협력사결재, 부분입고, 입고완료 
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

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdam/getMasterMdAmUniformProgressList.do?page="+current_page , pagingMode );
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if(Row < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	var st_buyer = mySheet.GetCellValue(Row, "BUYER");
	var st_st_no = mySheet.GetCellValue(Row, "ST_NO");
	var st_st_seq = mySheet.GetCellValue(Row, "ST_SEQ");
	var st_user_id = document.forms.searchCondition.st_user_id.value;
	
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if (column == "ST_NO") {
		doPop("masterMpSoUniformDetailPop", st_buyer, st_st_no, st_user_id);
	}
	
	if (column == "GR_QTY") {
		var st_status = mySheet.GetCellValue(Row, "STATUS");
		
		if(st_status == "SC" || st_status == "GP" || st_status == "GC"){
			doPop("masterMpSoUniformGrDetailPop", st_buyer, st_st_no, st_st_seq);	
		}
	}
	return;
}

// 팝업함수호출
function doPop(str, val1, val2, val3) {
	popupSel = str;
	
	switch (str) {
		case "masterMpSoUniformDetailPop": // 요청 상세 팝업
			popupSel = "masterMpSoUniformDetailPop";
			openSearchPopup("/mpso/getMasterMpSoUniformDetailPop.do", '?buyer='+val1+'&st_no='+val2+'&st_user_id='+val3, "1000,600,no");
			break;
			
		case "masterMpSoUniformGrDetailPop": // 요청입고수량 팝업
			popupSel = "masterMpSoUniformGrDetailPop";
			openSearchPopup("/mpso/getMasterMpSoUniformGrDetailPop.do", '?buyer='+val1+'&st_no='+val2+'&st_seq='+val3, "500,400,no");
			break;
	}
}
	
// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {
	grbRow="";	// 초기화
}

</script>
</head>
<body onload="kep_onload_view()">

<!-- 메뉴 구성 고객사,운영사 -->
<%if(!"S".equals(business_cond) ){%>
	
	<!-- 메뉴 구성 고객사 -->
	<%if(!"Y".equals(moveToMaster)){%>
	<div id="wrapper">
	<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   
	<c:import charEncoding="utf-8" url="/menu/menu.do">
		<c:param name="page" value="buyerLeft"/>
		<c:param name="part" value="${param.upperId}"/>
	</c:import>
	
	<div id="container2">
		<div id="ContArea">
			<h3>유니폼 진행관리</h3>
	<%}else{%>
	     	<h3 style="position:absolute; width:500px; font-family:맑은 고딕; font-weight:bold; font-size:18px; color:#333333; text-align:left; letter-spacing:-1px ">유니폼 진행관리</h3>
	<%}%>
	
<!-- 메뉴 구성 협력사 -->
<%}else{%>
	<!-- 메뉴 S -->
	<div id="wrapper">
	<c:import charEncoding="utf-8" url="/menu/menu.do" >
	<c:param name="page" value="sellerHeader"/>
	<c:param name="part" value="header"/>
	</c:import>
	
	<div id="container2">
	<c:import charEncoding="utf-8" url="/menu/menu.do">
	<c:param name="page" value="sellerLeft"/>
	<c:param name="part" value="${param.upperId}"/>
	</c:import>

	<!--내용 시작-->
	<div id="ContArea">
		<h3>유니폼 진행관리</h3>

<%}%>

		<!--버튼영역-->
		<div id="searchBtnA">
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
					
				<table  class="cont_t_list01">
					<caption>유니폼 진행관리</caption>
					<colgroup>
						<col width="6%" />
						<col width="27%" />
						<col width="6%" />
						<col width="27%" />
						<col width="6%" />
						<col width="27%" />
					</colgroup>
								
					<tbody>
						<tr> 
							<th><%=CommonLang.get("HTITLE405")%><!-- 사업장명 --></th>
							<td>
								<select id="st_buyer" name="st_buyer" style="width:80%;height:20px"></select>
							</td>
							<th><%=CommonLang.get("HTITLE220")%><!-- 요청일 --></th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="<%=st_from_date%>">
								<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="<%=st_to_date%>">
								<a href="javascript:kepCalendar('st_to_date')"></a>
								&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
								<input type="checkbox" style="vertical-align: middle;" name="st_period_ignore" id="st_period_ignore"/>
								<input type="hidden" name="st_period_ignore_value" id="st_period_ignore_value" value="N"/>
								<font>기간무시</font>
							</td>
						</tr>
						<tr> 
							<th><%=CommonLang.get("HTITLE216")%><!-- 요청번호 --></th>
							<td><input type="text" style="width:80%;" id="st_st_no"  name="st_st_no" value=""></td>
							<th><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
							<td><input type="text" style="width:80%;" id="st_buyer_item_no"  name="st_buyer_item_no" value=""></td>
							<th><%=CommonLang.get("HTITLE136")%><!-- 진행상태 --></th>
							<td>
								<select id="st_status_text" name="st_status_text" style="width:80%;height:20px">
									<option value="ALL" selected>전체</option>
									<option value="BS" >고객사 상신</option>
									<option value="BC" >고객사 결재</option>
									<option value="BB" >고객사 반려</option>
									<option value="MC" >운영사 결재</option>
									<option value="MB" >운영사 반려</option>
									<option value="SC" >협력사 결재</option>
									<option value="SB" >협력사 반려</option>
									<option value="GP" >생산부분입고</option>
									<option value="GC" >생산입고완료</option>
								</select>
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
		</div>
<!--내용 종료-->
<%if(!"S".equals(business_cond) ){%>	                 
	<%if(!"Y".equals(moveToMaster) ){%>
	</div>
	<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
	</div>
</div>
	<%}%>
<%}else{%>
	</div>
	<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>
	</div>
</div>
<%}%>

</body>
</html>
