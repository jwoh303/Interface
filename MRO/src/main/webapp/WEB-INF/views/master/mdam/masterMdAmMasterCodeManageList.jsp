<%--
**********************************************
* 메뉴(운영사) : 회원사관리>고객업무대행>마스터코드관리>도착지코드관리
* 메뉴(고객사) : 관리자>마스터코드관리>도착지코드관리
* 화면 : 도착지코드관리
* 기능 : 
* 프로그램 ID : PG_90_B_400_13
* 담당자 : 최명진 ( 설계 : 공통 )
* 착수일 : 2014-
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
		,{ Align:"Center",	Width:40,		Edit:true,	EditLen:30,	Hidden:false,	Type:"Text",				Header:"순번",				SaveName:"RN"}
		,{ Align:"Center",	Width:40,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
		,{ Align:"Left",	Width:80,		Edit:true,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"코드",				SaveName:"CODE",			KeyField:true}
		,{ Align:"Left",	Width:200,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"도착지명",			SaveName:"TEXT1",			KeyField:true}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"우편번호",			SaveName:"ZIP_CODE",		KeyField:true}
		,{ Align:"Left",	Width:400,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"도착지주소",		SaveName:"ADDRESS01",	KeyField:true}
		,{ Align:"Left",	Width:400,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"도착지상세주소",	SaveName:"ADDRESS02"}
		
		,{ Align:"Left",	Width:400,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"ORG_CODE",		SaveName:"ORG_CODE"}
		,{ Align:"Left",	Width:400,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"TEXT2",				SaveName:"TEXT2"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"ZIP_KEY",			SaveName:"TEXT3"}
		,{ Align:"Left",	Width:400,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"TEXT4",				SaveName:"TEXT4"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	// 하이퍼링크 설정
	setLinkCol(mySheet, "ZIP_CODE"); // 요청자
	
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
	if ( str != "search" && str != "excelDown" && str != "reload" && str != "add" && selectedGrid.length == 0 ) {
		alert("<%=CommonLang.msg("MSG78")%>");	//선택된 항목이 없습니다.
		return;
	}

	switch (str) {
		case "search": // 조회
<%if("Y".equals(moveToMaster) ){%>
			// 조회조건 체크
			if ( !searchValidate() )
				return;
			$("#st_com_code").val($("#st_buyer_code").val());
<%} %>
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdam/getMasterMdAmMasterCodeManageList.do" , pagingMode );
			break;
		
		case "reload": // 초기화
			kepReload('searchCondition');
			$("#st_buyer_code").val("");
			mySheet.RemoveAll();
			break;
	
		case "add": // 추가
// 			if ( mySheet.RowCount() > 0 ) {
				var rows = mySheet.DataInsert(-1);
				mySheet.SetCellValue(rows, "SELECTED", "1");
// 			}
// 			else {
// 				alert("조회된 데이터가 없습니다.");
// 				return;
// 			}	
			break;
			
		case "save": // 저장
			if ( !confirm('<%=CommonLang.msg("MSG292")%>') )	//선택한 항목을 저장 하시겠습니까?
				return;

			beforeProcessSave();
			kepSave(document.searchCondition ,  mySheet , "/mdam/saveMasterMdAmMasterCodeManageList.do" , "SELECTED" );
			break;
			
		case "del": // 삭제
			if ( !confirm('<%=CommonLang.msg("MSG293")%>') )	//선택한 항목을 삭제 하시겠습니까?
				return;
			if ( !beforeProcessDelete() )
				return;
			kepSave(document.searchCondition ,  mySheet , "/mdam/delMasterMdAmMasterCodeManageList.do" , "SELECTED" );
			break;
	}
}
	
// 조회조건 체크
function searchValidate() {
	if ( kepTrim("st_buyer_code") == '' ) {
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
	
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		var zip_code_04 = mySheet.GetCellValue(i, "TEXT4");
		var zip_code_02 = mySheet.GetCellValue(i, "TEXT2");
		var zip_arr = new Array();
		var chkSpace6 = zip_code_02.substring(5,6);
		zip_arr = zip_code_04.split("@");
		
		if ( zip_code_04 != '' ) {
			mySheet.SetCellValue(i, "ZIP_CODE", zip_arr[0]);
			mySheet.SetCellValue(i, "ADDRESS01", zip_arr[1]);
			mySheet.SetCellValue(i, "ADDRESS02", zip_arr[2]);
		}
		else {
			if(chkSpace6 ==" "){
				mySheet.SetCellValue(i, "ZIP_CODE", zip_code_02.substring(0,5));
				mySheet.SetCellValue(i, "ADDRESS01", zip_code_02.substring(6));				
			}else{
				mySheet.SetCellValue(i, "ZIP_CODE", zip_code_02.substring(0,7));
				mySheet.SetCellValue(i, "ADDRESS01", zip_code_02.substring(8));				
			}
			
		}
	}
	
}

function mySheet_OnAfterEdit(Row, Col) {
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
    if(column=='CODE'){
    	var dupIdx = mySheet.ColValueDup("CODE");
    	if(dupIdx > -1){
        	alert("<%=CommonLang.msg("MSG294")%>");	//입력하신 코드는 이미 존재합니다.
        	mySheet.SetCellValue(dupIdx,"CODE",'');return;
    	}
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
	kepSearch(document.searchCondition ,  mySheet , "/mdam/getMasterMdAmMasterCodeManageList.do?page="+current_page , pagingMode );
}

// 저장 선행 처리
function beforeProcessSave() {
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			var tempText2 = mySheet.GetCellValue(i, "ZIP_CODE") + ' ' + mySheet.GetCellValue(i, "ADDRESS01") + ' ' + mySheet.GetCellValue(i, "ADDRESS02");
			var tempText4 = mySheet.GetCellValue(i, "ZIP_CODE") + '@' + mySheet.GetCellValue(i, "ADDRESS01") + '@' + mySheet.GetCellValue(i, "ADDRESS02");
			mySheet.SetCellValue(i, "TEXT2", tempText2);
			mySheet.SetCellValue(i, "TEXT4", tempText4);
		}
	}
}

// 행삭제 선행 처리
function beforeProcessDelete() {
	for ( var i = mySheet.RowCount(); i >= 1; i-- ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 && mySheet.GetCellValue(i, "sStatus") == 'I' ) {
			mySheet.RowDelete(i, 0);
		}
	}
	
	if ( mySheet.FindCheckedRow("SELECTED").length == 0 ) {
		return false;
	}
	
	return true;
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
/*  
	if (column == 'ZIP_CODE') { // 우편번호	 ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
		doPop("zipcode"	);
	}
 */
	if (column == 'ZIP_CODE') { // 우편번호
		doPop("newzipcode"	);
	}

	return;
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		/* case "zipcode": //우편번호 검색	ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
			openSearchPopup("/common/zipCodeSearchPop.do", "?1=1", "500,666");
			break; */
		case "newzipcode": //우편번호 검색
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481");
			break;
		case "buyer_single": // 고객사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
	}
}
	
// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {
// 	alert("value1 / value2 => " + value1 + " / " + value2);

	// 팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") { // 단일 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}

	grbRow="";	// 초기화
}
/* 
// 콜백함수(우편번호)	ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
function setZipPopupReturn(str_zipcode, str_zip_key, str_sido, str_gugun, str_roadNm, str_buildingNo, str_buildingName, str_dong) {
	mySheet.SetCellValue(grbRow, "ZIP_CODE", str_zipcode);
	mySheet.SetCellValue(grbRow, "TEXT3", str_zip_key);
	mySheet.SetCellValue(grbRow, "ADDRESS01", str_sido + " " + str_gugun + " " + str_roadNm + " " + str_buildingNo);
	mySheet.SetCellValue(grbRow, "ADDRESS02", str_buildingName);
	
	grbRow="";	//초기화
}
 */
 
function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
	mySheet.SetCellValue(grbRow, "ZIP_CODE", zipNo.replace(/[^0-9]/gi, ''));
	mySheet.SetCellValue(grbRow, "TEXT3", bdMgtSn);
	mySheet.SetCellValue(grbRow, "ADDRESS01", roadAddrPart1 + " " + roadAddrPart2);
	mySheet.SetCellValue(grbRow, "ADDRESS02", addrDetail);
}

</script>
</head>
<body onload="kep_onload_view()">
<!-- 메뉴 S --> 
<%if(!"Y".equals(moveToMaster) ){%>
<div id="wrapper"> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   
<%} %>

<%if(!"Y".equals(moveToMaster) ){%>
<c:import charEncoding="utf-8" url="/menu/menu.do">
	<c:param name="page" value="buyerLeft"/>
	<c:param name="part" value="${param.upperId}"/>
</c:import>
<%} %>
<!-- 메뉴 E -->

<!--내용 시작-->
<div id="container2">
<%if(!"Y".equals(moveToMaster) ){%>
	<div id="ContArea">
<%}else{%>
	<div id="ContArea2">
<%} %>

<%if(!"Y".equals(moveToMaster) ){%>
		<h3><%=CommonLang.get("HTITLE368")%><!-- 도착지코드관리 --></h3>
    	<div id="searchBtnA">
<%}else{%>
     	<h3 style="position:absolute; width:500px; font-family:맑은 고딕; font-weight:bold; font-size:18px; color:#333333; text-align:left; letter-spacing:-1px "><%=CommonLang.get("HTITLE690")%><!-- 마스터코드관리 --></h3>
     	<div id="searchBtnA" style="position:relative;  text-align:right; width:950px; height:32px; border: solid 0px; margin-top:5px; ">
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
				<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
				<input type="hidden" id="st_type" name="st_type"  value="C012">
					
				<table  class="cont_t_list01" style="width:100%;">
					<caption><%=CommonLang.get("HTITLE368")%><!-- 도착지코드관리 --></caption>
<%if(!"Y".equals(moveToMaster) ){%>
					<colgroup>
						<col width="6%" />
						<col width="44%" />
						<col width="6%" />
						<col width="44%" />
					</colgroup>
								
					<tbody>
						<tr> 
							<th><%=CommonLang.get("HTITLE369")%><!-- 도착지코드 --></th>
							<td>
								<input type="text" class="input_type_text" id="st_code" name="st_code" style="width:80%;" value="" onkeyup="kepToUpper('st_code')" onkeydown="kepEnter()">
							</td>
							<th><%=CommonLang.get("HTITLE370")%><!-- 도착지명 --></th>
							<td>
								<input type="text" class="input_type_text" id="st_name" name="st_name" style="width:80%;" value="" onkeydown="kepEnter()">
							</td>
						</tr>
					</tbody>
<%}else{%>
					<colgroup>
						<col width="6%" />
						<col width="34%" />
						<col width="6%" />
						<col width="24%" />
						<col width="6%" />
						<col width="24%" />
					</colgroup>
								
					<tbody>
						<tr> 
							<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE604")%><!-- 고객사 --></th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:71%" value="" readonly onclick="javascript:doPop('buyer_single');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th><%=CommonLang.get("HTITLE369")%><!-- 도착지코드 --></th>
							<td>
								<input type="text" class="input_type_text" id="st_code" name="st_code" style="width:80%;" value="" onkeyup="kepToUpper('st_code')" onkeydown="kepEnter()">
							</td>
							<th><%=CommonLang.get("HTITLE370")%><!-- 도착지명 --></th>
							<td>
								<input type="text" class="input_type_text" id="st_name" name="st_name" style="width:80%;" value="" onkeydown="kepEnter()">
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
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
	  			
		<!--버튼영역-->
		<div class="btnArea">
			<span class="fl">
			</span>
	  				
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('add');"><%=CommonLang.get("HTITLE36")%><!-- 행추가 --></a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('save');"><%=CommonLang.get("HTITLE124")%><!-- 저장 --></a></span>
				<span class="btn_02"><a href="javascript:doAction('del');"><%=CommonLang.get("HTITLE25")%><!-- 삭제 --></a></span>
			</span>
		</div>
<!--내용 종료-->
	                 
	</div>
</div>

<%if(!"Y".equals(moveToMaster) ){%>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
</div>
<%} %>

</body>
</html>
