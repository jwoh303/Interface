<%--
**********************************************
* 메뉴 : 재계약 진행조회
* 화면 : 재계약 진행조회
* 기능 : 
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
						{ Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
						,{ Align:"Left",	SaveName:"BUYER_NM",			Header:"고객사",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"RC_NO",		Header:"요청번호",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"RC_SEQ",		Header:"요청순번",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"REVISION",		Header:"차수",				Type:"Text",		Width:40,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"RC_TEXT",		Header:"진행상태",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"DESCRIPTION_LOC",		Header:"품명",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Right",	SaveName:"STOA_LIST_PRICE",		Header:"제출단가\n(VAT별도)",		Type:"Float",		Width:80,	Edit:false ,EditLen:100,	Hidden:false,	Format:"${priceFormat}"}
						, {Align : "Center",SaveName : "STOA_CLOSE_DATE",		Header : "제출\n계약종료일",	Type : "Date",	Width : 90,	EditLen : 110,	Edit :false}
						,{ Align:"Left",	SaveName:"MAKER_NAME",			Header:"제조사",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"ORIGIN_NM",			Header:"원산지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"MAKER_PART_NO",		Header:"모델번호",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"ATOB_DATE",			Header:"재계약\마감일",				Type:"Date",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"CLOSE_DATE",		Header:"계약종료일",				Type:"Date",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Right",	SaveName:"MIN_ORDER_QTY",		Header:"MOQ",				Type:"Int",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Right",	SaveName:"PUR_UNIT_QTY",		Header:"발주배수",				Type:"Int",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"USER_NM",		Header:"KeP담당자",				Type:"Text",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"USER_PHONE_NUMBER",		Header:"담당자연락처",				Type:"Text",			Width:90,	Edit:true,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"ATOS_DATE",			Header:"요청일",				Type:"Date",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"A_NOTE",			Header:"운영사비고",				Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"S_NOTE",			Header:"협력사비고",				Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false }
						,{ Align:"Left",	SaveName:"G_NOTE",			Header:"포기사유",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"BUYER",				Header:"BUYER",				Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
						,{ Align:"Center",	SaveName:"AGENT",				Header:"AGENT",				Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "REVISION");
	$("#st_from_date").val(kepToDateAdd("31","M"));
	$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/'));	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				alert("조회기간을 3개월 단위로 조회가 가능합니다.");
				return;
			}
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mpcl/getSellerMpClCatalogRecharterMngList.do" , pagingMode );
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			dateEraser();
			mySheet.RemoveAll();
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
		makePageIndex2(mySheet, 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2(mySheet, current_page , document.searchCondition.onepagerow.value);	
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpcl/getSellerMpClCatalogRecharterMngList.do?page="+current_page , pagingMode );
}

	
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	var st_rc_no = mySheet.GetCellValue(Row, "RC_NO");
	var st_rc_seq = mySheet.GetCellValue(Row, "RC_SEQ");	
	if(column == "REVISION"){
		popupSel = "sellerMpClCatalogRechaterHistoryPop";
		openSearchPopup("/mpcl/showSellerMpRqQuotationUnitpriceHistoryPop.do", '?st_rc_no='+st_rc_no+'&st_rc_seq='+st_rc_seq, "900,400,no");
	}
}

function mySheet_OnChange(Row, Col, Value) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(Col);
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg);
	}
	if ( code > 0 ) {
		//저장 성공시 처리
		doAction("search");
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	alert(sMsg);
}


// ajax 공통 호출후 에러시 처리 함수
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}



function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction("search");
	}
}

function dateEraser() {
	
}

</script>
</head>
<%
@SuppressWarnings (value="unchecked")

String userID = _sessionInfo.getUserId();
%>
<body onload="kep_onload_view()">
<div id="wrapper">
<!-- 메뉴 S --> 
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
<!--내용 시작-->
<div id="ContArea">
	<h3>재계약 진행조회</h3>
		<!--버튼영역-->
       	<div id="searchBtnA"  >
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition" name="searchCondition" method="post" onsubmit="return false;" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME" />
			<input type="hidden" id="pageflag" name="pageflag" value="1" />
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}" />
			<table  class="cont_t_list01" >
					<caption>물질정보 제출</caption>
					<colgroup>
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
                        <col width="21%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>
								요청일
							</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								-
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
							</td>
							<th>요청번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_rc_no" name="st_rc_no" style="width:87%;" value=""  onkeydown="kepEnter()"> 
							</td>
							
						</tr>
						<tr>
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:87%;" value=""  onkeydown="kepEnter()">
							</td> 
							<th>품명</th>
							<td>
								<input type="text" class="input_type_text" id="st_desc" name="st_desc" style="width:87%;" value=""  onkeydown="kepEnter()">
							</td>
							<th>규격</th>
							<td>
								<input type="text" class="input_type_text" id="st_sepc" name="st_sepc" style="width:87%;" value=""  onkeydown="kepEnter()">
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
			<br>
		</form>
					
      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
		<!--내용 종료-->	    
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>
</div>    
</body>
</html>
