<%--
**********************************************
* 메뉴(고객사) : 주문관리 > 유니폼 신청
* 화면 : 유니폼 신청
* 기능 : 
* 프로그램 ID : 
* 담당자 : HSJ
* 착수일 : 2020-04-07
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
	SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
    String buyer = _sessionInfo.getComCode();
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
		{ Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",	SaveName:"sStatus"}
		,{ Align:"Center",	Width:40,	Edit:true,	EditLen:30,		Hidden:false,	Type:"DummyCheck",	Header:"",		SaveName:"SELECTED"}
		,{ Align:"Center",	Width:130,	Edit:false,	EditLen:30,		Hidden:false,	Type:"Text",		Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Left",	Width:220,	Edit:false,	EditLen:20,		Hidden:false,	Type:"Text",		Header:"품명",	SaveName:"DESCRIPTION_LOC"}
		,{ Align:"Left",	Width:270,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"규격",	SaveName:"SPECIFICATION"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"단위",	SaveName:"UNIT_MEASURE"}
		,{ Align:"Right",	Width:80,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Float",		Header:"수량",	SaveName:"CART_QTY",	BackColor:"${notnullColor}"}
		,{ Align:"Left",	Width:380,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"비고",	SaveName:"REMARK"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:30,		Hidden:true,	Type:"Text",		Header:"계약번호",	SaveName:"CONTRACT_NO"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:30,		Hidden:true,	Type:"Text",		Header:"계약항번",	SaveName:"CONTRACT_SEQ"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:30,		Hidden:true,	Type:"Text",		Header:"순번",	SaveName:"SEQ"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	kepAjaxCommonQueryIdSearchTwoCombo('st_buyer','buyer.mpso.selectBuyerMpSoUniformReqCompanyList', '${sessionInfo.comCode}', '${sessionInfo.userId}', '','');
	
	doAction("search");
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
	if ( str != "search" && str != "loadExcel" && str != "reload" && selectedGrid.length == 0 ) {
		alert("<%=CommonLang.msg("MSG78")%>");	//선택된 항목이 없습니다.
		return;
	}

	switch (str) {
		case "search": // 조회
			// 조회조건 체크
			if ( !searchValidate() )
				return;
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpso/getBuyerMpSoUniformReqList.do" , pagingMode );
			break;
		
		case "reload": // 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
	
		case "save": // 저장
			if ( !searchValidate() )
				return;
		
			if ( !confirm('<%=CommonLang.msg("MSG292")%>') )	//선택한 항목을 저장 하시겠습니까?
				return;
			
			kepSave(document.searchCondition ,  mySheet , "/mpso/saveBuyerMpSoUniformReqList.do" , "SELECTED" );
			break;
			
		case "del": // 삭제
			if ( !confirm('<%=CommonLang.msg("MSG293")%>') )	//선택한 항목을 삭제 하시겠습니까?
				return;
			kepSave(document.searchCondition ,  mySheet , "/mpso/delBuyerMpSoUniformReqList.do" , "SELECTED" );
			break;
			
		case "loadExcel": // 파일 업로드
			if ( !searchValidate() )
				return;
		
			var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"||1||||2|3"};
			mySheet.LoadExcel(params);
			break;
			
		case "reg": // 등록
			var dup_item_chk = "";
			
			if ( !searchValidate() )
				return;
			
			for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
				if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
					dup_item_chk = mySheet.GetCellValue(i, "BUYER_ITEM_NO");
					
					for ( var j = i+1; j <= mySheet.RowCount(); j++ ) {
						if ( mySheet.GetCellValue(j, "SELECTED") == 1 ) {
							if(dup_item_chk == mySheet.GetCellValue(j, "BUYER_ITEM_NO")){
								alert("중복된 품목코드가 존재합니다.");
								mySheet.SelectCell(j, "BUYER_ITEM_NO");
					        	return;
							}
						}
					}
				}
			}

			if ( !confirm('선택한 항목을 등록하시겠습니까?') )
				return;
			
			kepSave(document.searchCondition ,  mySheet , "/mpso/regBuyerMpSoUniformReqList.do" , "SELECTED");
			break;
	}
}
	
// 조회조건 체크
function searchValidate() {
	if ( kepTrim("st_buyer") == '' ) {
		alert("<%=CommonLang.msg("MSG342")%>");	//고객사를 선택해 주십시오
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

//엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {
	var maxRow  = mySheet.RowCount();
	if(maxRow == 0){
		  return;
	}
	
	for(var i=1; i<= maxRow; i++){
		mySheet.SetCellValue(i,"SELECTED","1");
	}
	
	kepSave(document.searchCondition ,  mySheet , "/mpso/uploadBuyerMpSoUniformReqList.do" , "SELECTED" );
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getBuyerMpSoUniformReqList.do?page="+current_page , pagingMode );
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyerMpSoUniformChoicePop": // 고객사 M
			if ( !searchValidate() )
				return;
		
			popupSel = "buyerMpSoUniformChoicePop";
			openSearchPopup("/mpso/getBuyerMpSoUniformChoicePop.do", '?com_code='+$("#st_buyer").val(), "800,550,no");
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

		<h3><%=CommonLang.get("HTITLE926")%><!-- 유니폼 신청 --></h3>
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
					<caption><%=CommonLang.get("HTITLE926")%><!-- 유니폼 신청 --></caption>
					<colgroup>
						<col width="6%" />
						<col width="44%" />
						<col width="6%" />
						<col width="44%" />
					</colgroup>
								
					<tbody>
						<tr> 
							<th><%=CommonLang.get("HTITLE405")%><!-- 사업장명 --></th>
							<td>
								<select id="st_buyer" name="st_buyer" style="width:80%;height:20px"></select>
							</td>
							<th></th>
							<td></td>
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
				<span class="btn_05 mr04"><a href="javascript:doAction('loadExcel');">일괄 업로드</a></span>
				<span class="btn_02"><a href="/resources/excel/buyer_uniform_upload.xls"><%=CommonLang.get("HTITLE183") %><!-- 등록양식 --></a></span>
				<span class="btn_05 mr04"><a href="javascript:doPop('buyerMpSoUniformChoicePop');">유니폼 추가</a></span>
			</span>
	  				
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('save');"><%=CommonLang.get("HTITLE124")%><!-- 저장 --></a></span>
				<span class="btn_02"><a href="javascript:doAction('del');"><%=CommonLang.get("HTITLE25")%><!-- 삭제 --></a></span>
				<span class="btn_02"><a href="javascript:doAction('reg');"><%=CommonLang.get("HTITLE440")%><!-- 등록 --></a></span>
			</span>
		</div>
<!--내용 종료-->
	                 
	</div>
</div>

<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
</div>

</body>
</html>
