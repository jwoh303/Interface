<%--
**********************************************
* 메뉴(운영사) : 상품관리>재고카탈로그 조회>협력사 재고관리
* 메뉴(고객사) :
* 화면 : 협력사 재고관리
* 기능 : 
* 프로그램 ID :
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
    String st_business_cond = ""; 
    SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		st_business_cond =  CommonUtil.nvl((String)sessionInfo.getBusinessCond());
	}
%>
<!DOCTYPE html>
<html>
<head>
<%if("B".equals(st_business_cond) ){%>
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
<%}else if("M".equals(st_business_cond)||"S".equals(st_business_cond)){%>
	<%@ include file="../../common/include/head.jspf"  %>
<%}%>
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
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER"}
		,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사명",	SaveName:"BUYER_NAME"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태",	SaveName:"STATUS_TEXT"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION_LOC"}
		,{ Align:"Left",	Width:250,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
		,{ Align:"right",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type :"Float",  Format:"${qtyFormat}",	Header:"재고",	SaveName:"STOCK_CNT"}
		,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사코드",	SaveName:"AGENT"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"계약번호",	SaveName:"CONTRACT_NO"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"계약순번",	SaveName:"CONTRACT_SEQ"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"담당자",	SaveName:"ADD_USER_NM"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"담당자 연락처",	SaveName:"ADD_USER_TEL"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"수정일",	SaveName:"ADD_DATE"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
}
	
var st;
var mt;

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

//기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if ((str == "save" || str == "del") && selectedGrid.length == 0 ) {
		alert("<%=CommonLang.msg("MSG78")%>");	//선택된 항목이 없습니다.
		return;
	}

	switch (str) {
		case "search": // 조회
<%if("M".equals(st_business_cond) ){%>
			// 조회조건 체크
			if ( !searchValidate() )
				return;
<%} %>
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/wmst/getMasterWmStStockManageList.do" , pagingMode );
			break;
		
		case "reload": // 초기화
			kepReload('searchCondition');
			$("#st_buyer_item_no").val("");
			$("#st_description").val("");
			mySheet.RemoveAll();
			break;
		case "save": // 저장
			var st_buyer = "";
			var st_buyer_item_no = "";
			var st_contract_no = "";
			var st_contract_seq = "";
			var st_agnet = "";
			var st_stock_cnt = "";
			for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
				if (mySheet.GetCellValue(i, "SELECTED") == "1"){
					st_buyer = 	mySheet.GetCellValue(i, "BUYER");
					st_buyer_item_no = 	mySheet.GetCellValue(i, "BUYER_ITEM_NO");
					st_contract_no = 	mySheet.GetCellValue(i, "CONTRACT_NO");
					st_contract_seq = 	mySheet.GetCellValue(i, "CONTRACT_SEQ");
					st_agnet = 	mySheet.GetCellValue(i, "AGENT");
					st_stock_cnt = 	mySheet.GetCellValue(i, "STOCK_CNT");
					if(st_buyer == ""){
						alert(i+"번째 고객사 코드 입력 바랍니다.");
						mySheet.SelectCell(i, "BUYER");
						return;
					}
					if(st_buyer_item_no == ""){
						alert(i+"번째 품목 코드 입력 바랍니다.");
						mySheet.SelectCell(i, "BUYER_ITEM_NO");
						return;
					}
					if(st_contract_no == ""){
						alert(i+"번째 계약번호 입력 바랍니다.");
						mySheet.SelectCell(i, "CONTRACT_NO");
						return;
					}
					if(st_contract_seq == ""){
						alert(i+"번째 계약순번 입력 바랍니다.");
						mySheet.SelectCell(i, "CONTRACT_SEQ");
						return;
					}
					if(st_agnet == ""){
						alert(i+"번째 협력사 코드 입력 바랍니다.");
						mySheet.SelectCell(i, "AGENT");
						return;
					}
					if(st_contract_seq == ""){
						alert(i+"번째 재고수량 입력 바랍니다.");
						mySheet.SelectCell(i, "STOCK_CNT");
						return;
					}
					
				}
	    	}
			if ( !confirm("선택한 항목을 저장 하시겠습니까?" ))
				return;
			kepSave(document.searchCondition ,  mySheet , "/wmst/saveMasterWmStStockManageList.do" , "SELECTED" );
			break;
		case "del": // 삭제
			if ( !confirm("선택한 항목을 삭제 하시겠습니까?" ))
				return;
			kepSave(document.searchCondition ,  mySheet , "/wmst/delMasterWmStStockManageList.do" , "SELECTED" );
			break;
		case "excelUpload":	// 엑셀업로드
			mySheet.RemoveAll();
			var params = {
				Mode : "HeaderMatch"
			};
			mySheet.LoadExcel(params); 
			break;
		case "excelDown":	// 양식다운로드 
			location.href = "/resources/excel/work/WMST/masterWmStAgentStockList.xlsx";
			break;		
		case "excelDownload": // 조회
			<%if("M".equals(st_business_cond) ){%>
						// 조회조건 체크
						if ( !searchValidate() )
							return;
			<%} %>
			$("#pageflag").val('0');
		    var downCol = "";
			for(var i=0;i<=mySheet.LastCol();i++){
				if(!mySheet.GetColHidden(i) && mySheet.ColSaveName(i) !="SELECTED"){
					downCol += "|"+i;	
				}
			}
			var param = {FileName:"재고관리.xlsx",DownCols:downCol.substring(1)};
			kepDownExcel(document.searchCondition ,mySheet , "/wmst/excelMasterWmStStockManageList.do", param);
			$("#pageflag").val('1');
	}
}

// 조회조건 체크
function searchValidate() {
	if ( kepTrim("st_buyer_code") == '' ) {
		alert("<%=CommonLang.msg("MSG1")%>");	//고객사를 선택해 주십시오
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
	var st_biz_cond = "<%=st_business_cond%>";
	var totRow = mySheet.RowCount();
	for(var i=1; i<=totRow;i++){
		if(st_biz_cond == "M"){
			mySheet.SetCellBackColor(i, "STOCK_CNT", "${optColor}");
		}else{
			mySheet.SetCellEditable(i, "STOCK_CNT", 0);
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
	kepSearch(document.searchCondition ,  mySheet , "/wmst/getMasterWmStStockManageList.do?page="+current_page , pagingMode );
}


// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
		case "agent_single": // 협력사 M
			openSearchPopup("/common/icomcmpyPop.do", '?BUSINESS_COND=S&MULTI=N', "500,466,no");
			popupSel = "agent_single";
			break;	
	}
}
	
// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {
	// 팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") { // 단일 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	} else if (popupSel == "agent_single") {// 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
	}
	grbRow="";	// 초기화
}
function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}
</script>
</head>
<body onload="kep_onload_view()">
<%if("B".equals(st_business_cond) ){%>
<div id="wrapper"> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   
	<c:import charEncoding="utf-8" url="/menu/menu.do">
		<c:param name="page" value="buyerLeft"/>
		<c:param name="part" value="${param.upperId}"/>
	</c:import>
	<div id="container2">
		<div id="ContArea">
			<h3><%=CommonLang.get("HTITLE746")%><!-- 재고관리 --></h3>
	    	<div id="searchBtnA">
<%}else if("S".equals(st_business_cond) ){%>
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
	<div id="ContArea">
		<h3>재고관리</h3>
		<div id="searchBtnA"  >
<%}else if("M".equals(st_business_cond) ){%>
    <div id="searchBtnA"  >
    <h3>협력사 재고관리</h3>
<%} %>    
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
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
				<input type="hidden" id="st_type" name="st_type"  value="C003">
					
<%if("B".equals(st_business_cond) ){%>
				<table  class="cont_t_list01" style="width:100%;">
					<colgroup>
						<col width="6%" />
						<col width="44%" />
						<col width="6%" />
						<col width="44%" />
					</colgroup>
								
					<tbody>
						<tr> 
							<th><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
							<td>
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="${sessionInfo.comCode}">
								<input type="hidden" name="st_agent_code" id="st_agent_code" value="">
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:87%;" value="" onkeyup="kepToUpper('st_code')" onkeydown="kepEnter()">
							</td>
							<th><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></th>
							<td>
								<input type="text" class="input_type_text" id="st_description" name="st_description" style="width:87%;" value="" onkeydown="kepEnter()">
							</td>
						</tr>
					</tbody>
<%}else if("S".equals(st_business_cond) ){%>
				<table  class="cont_t_list01">
					<colgroup>
						<col width="6%" />
						<col width="44%" />
						<col width="6%" />
						<col width="44%" />
					</colgroup>
								
					<tbody>
						<tr> 
							<th>품목코드</th>
							<td>
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
								<input type="hidden" name="st_agent_code" id="st_agent_code" value="${sessionInfo.comCode}">
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:87%;" value="" onkeyup="kepToUpper('st_code')" onkeydown="kepEnter()">
							</td>
							<th>품목명</th>
							<td>
								<input type="text" class="input_type_text" id="st_description" name="st_description" style="width:87%;" value="" onkeydown="kepEnter()">
							</td>
						</tr>
					</tbody>
<%}else if("M".equals(st_business_cond) ){%>
				<table  class="cont_t_list01" >
					<colgroup>
							<col width="80px" />
							<col width="20%" />
							<col width="80px" />
							<col width="20%" />
							<col width="80px" />
							<col width="20%" />
							<col width="80px" />
							<col width="20%" />
					</colgroup>
					<tbody>
						<tr>
							<th><font color="#FF6600">*</font>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:55%" value="" readonly>
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
								<input type="hidden" name="st_com_org_code" id="st_com_org_code" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>협력사</th>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:55%"  readonly>
								<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:80%">
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:87%;" value="" onkeyup="kepToUpper('st_code')" onkeydown="kepEnter()">
							</td>
							<th>품목명</th>
							<td>
								<input type="text" class="input_type_text" id="st_description" name="st_description" style="width:87%;" value="" onkeydown="kepEnter()">
							</td>
						</tr>
					</tbody>
<%} %>
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
		<div class="ib_product" style="border-top:2px solid #3c639c; height:354px">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
		<!--버튼영역-->
		<div class="btnArea">
			<span class="fl">
	  			<span class="btn_06"><a href="javascript:doAction('excelDownload');">엑셀다운로드</a></span>
			<!--운영사일때만 해당 버튼 활성화-->
			<%if("M".equals(st_business_cond) ){%>
					<span class="btn_05 mr04"><a href="javascript:doAction('excelUpload');">엑셀업로드</a></span>
	  				<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀양식</a></span>
				</span>
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
					<span class="btn_02"><a href="javascript:doAction('del');">삭제</a></span>
				</span>
			<%}else{%>
				</span>
			<%}%>
		</div>
<!--내용 종료-->
 </div>
<%if("B".equals(st_business_cond) ){%>
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
</div>
<%}else if("S".equals(st_business_cond) ){%>
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>
</div>    
<%}%>
</body>
</html>
