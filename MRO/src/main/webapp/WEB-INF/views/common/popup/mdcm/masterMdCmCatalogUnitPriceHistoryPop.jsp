<%--
**********************************************
* 메뉴 : 단가이력 팝업
* 화면 : 단가이력 팝업 
* 기능 : 
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>

<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var grbRow = "";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {

	var initsheet = {};
	initsheet.Cols = [
			 {Align:"Center",	SaveName:"sStatus",				Header:"상태",		Type:"Status",			Width:60,		Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",					Header:"품목코드",		Type:"Text",				Width:100,		Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"CONTRACT_NO",				Header:"계약번호",		Type:"Text",				Width:80,	Edit:false,	EditLen:200,	Hidden:false}
			,{ Align:"Center",	SaveName:"CONTRACT_SEQ",			Header:"계약항번",	Type:"Text",				Width:60,	Edit:false,	EditLen:20,	Hidden:false}
			,{ Align:"Right",	SaveName:"PRICE_SEQ",		Header:"순번",	Type:"Text",				Width:40,	Edit:false,	EditLen:30,	Hidden:false}
			,{ Align:"Center",	SaveName:"ADD_DATE",			Header:"등록일",		Type:"Text",				Width:80,		Edit:false,	EditLen:12,	Hidden:false}
			,{ Align:"Center",	SaveName:"ADD_TIME",			Header:"등록시간",		Type:"Text",				Width:60,		Edit:false,	EditLen:12,	Hidden:false}
			,{ Align:"Center",	SaveName:"ADD_USER_ID",	Header:"등록자",		Type:"Text",				Width:70,		Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"UNIT_PRICE",			Header:"매출단가",		Type:"Float",	Format:"${priceFormat}",				Width:80,		Edit:false,	EditLen:12,	Hidden:false}
			,{ Align:"Right",	SaveName:"LIST_PRICE",		Header:"매입단가",		Type:"Float",	Format:"${priceFormat}",			Width:80,		Edit:false,	EditLen:2,		Hidden:false}
			,{ Align:"Center",	SaveName:"UNIT_PRICE_CHANGE_REASON_TEXT",	Header:"매출단가 변동사유",		Type:"Text",				Width:110,		Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"LIST_PRICE_CHANGE_REASON_TEXT",	Header:"매입단가 변동사유",		Type:"Text",				Width:110,		Edit:false,	EditLen:100,	Hidden:false}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	doAction("search");
}


var mt;
//기능함수
function doAction(str, flag) {
	switch (str) {
		case "search":
			current_page = -1;
			kepSearch(document.searchForm, mySheet, "/mdcm/getMasterMdCmCatalogUnitPriceHistoryPop.do" , pagingMode );
			break;
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	return;
}

function mySheet_OnChange(Row, Col, Value) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(Col);
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

}
//그리드 표시후 처리	 
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

	if (current_page==-1) {
		makePageIndex2(mySheet, 1, document.searchForm.onepagerow.value);
	} else {
		makePageIndex2(mySheet, current_page, document.searchForm.onepagerow.value);	
	}
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	if (code > 0) {
		//저장 성공시 재조회
		doAction('search');
	}
}
// 페이지 인덱스 클릭시 재조회
function pageSearch(param) {
	//조회
	current_page = param.page;
	kepSearch(document.searchForm ,  mySheet , "/mdcm/getMasterMdCmCatalogUnitPriceHistoryPop.do?page="+current_page , pagingMode );
}
</script> 
<body onload="kep_onload_view();">
<form name="searchForm" id="searchForm" method=post >
<input type="hidden" id=st_user_id  name="st_user_id" value="${sessionInfo.userId}">
<input type="hidden" id="st_buyer"  name="st_buyer" value="${param.st_buyer}">
<input type="hidden" id="st_contract_no"  name="st_contract_no" value="${param.st_contract_no}">
<input type="hidden" id="st_contract_seq"  name="st_contract_seq" value="${param.st_contract_seq}">
<input type="hidden" id="st_buyer_item_no"  name="st_buyer_item_no" value="${param.st_buyer_item_no}">
<input type="hidden" id="s_SAVENAME"  name="s_SAVENAME" />
<input type="hidden" id="pageflag" name="pageflag" value="1" />
<input type="hidden" name="onepagerow" id="onepagerow" value="10" />

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:400px;">
    	<div id="popHeader">
        	<h1 class="title">단가이력</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        
        <div id="popContainer">
            <div class="contArea" style="height:340px;" >
				<div class="ib_product" style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "100%", "288px");
					</script>
				</div>
				<p class="paging" id="pageindex"></p>
			</div>
			
		</div>
	</div>
</form> 
</body>
</html>
