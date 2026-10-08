<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>상품정보 조회 및 관리 > 상세 팝업 > 기준가 변경이력 보기
* 화면 : (팝업) 기준가 변경이력 조회
* 기능 : 기준가 변경이력 조회
*        - 최상단 = 등록 초기값, 변경일자 오름차순
*        - CMSCATLG_HST 의 JOB_COLUMN='BASE_PRICE' 행만. 기준가유형은 그 행의 사유 텍스트 컬럼에 담긴다
* 담당자 : 홍준우
* 착수일 : 2026-09-04
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>

<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<!-- IBSheet 라이브러리 (head_pop.jspf 에는 미포함이라 직접 로드) -->
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>
<%
String st_catlg_id = CommonUtil.nvl((String) request.getParameter("st_catlg_id"),"");
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,	Hidden:true,	Type:"Status",	Header:"상태",			SaveName:"sStatus"}
		,{ Align:"Center",	Width:130,	Edit:false,	EditLen:20,		Type:"Text",	Header:"변경일시",				SaveName:"CHANGE_DATE"}
		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:20,		Type:"Text",	Header:"기준가",				SaveName:"BASE_PRICE"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:200,	Type:"Text",	Header:"기준가유형",			SaveName:"BASE_PRICE_TYPE_NM"}
		,{ Align:"Left",	Width:230,	Edit:false,	EditLen:500,	Type:"Text",	Header:"변경사유",				SaveName:"CHANGE_REASON"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:20,		Type:"Text",	Header:"변경담당자",			SaveName:"CHANGE_USER"}
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0, UseNoDataRow:1};
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	doAction("search");
}

//기능함수
function doAction(str){
	switch(str){
		case "search": // 기준가 변경이력 조회
			current_page = -1;
			kepSearch(document.searchForm, mySheet, "/mdam/getMasterMdCmCmsItemBasePriceHistoryList.do", pagingMode);
			break;
	}
}

//그리드 표시후 처리
function mySheet_OnLoadData(DATA){ return DATA; }

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode){
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
}

//페이지 인덱스 클릭시 재조회
function pageSearch(param){
	current_page = param.page;
	kepSearch(document.searchForm, mySheet, "/mdam/getMasterMdCmCmsItemBasePriceHistoryList.do?page="+current_page, pagingMode);
}
</script>

<style>
.PopGuide{ display:block; margin:10px 0 8px; color:#444; font-size:13px; }
#popContainer .btnArea{ margin-bottom:0; }
</style>

<body onLoad="kep_onload_view()">
	<form name="searchForm" id="searchForm" method="post">
		<input type="hidden" id="st_catlg_id" name="st_catlg_id" value="<%=st_catlg_id%>">
		<input type="hidden" id="s_SAVENAME" name="s_SAVENAME" />
		<input type="hidden" id="pageflag" name="pageflag" value="1" />
		<input type="hidden" name="onepagerow" id="onepagerow" value="100" />
	</form>

	<div id="popWrapper" style="width:823px;">
		<div id="popHeader">
			<h1 class="title">기준가 변경이력</h1>
			<p class="popClose"><a href="javascript:self.close()">
				<img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
			</a></p>
		</div>

		<!--팝업내용입니다-->
		<div id="popContainer" style="background-color:#f5f5f5">

			<span class="PopGuide">※ 최상단 라인은 등록 초기 값이며, 변경일자 오름차순으로 정렬됩니다.</span>

			<!--기준가 변경이력 그리드 (IBSheet)-->
			<div style="background-color:#fff; border-radius:5px; padding:10px 12px;">
				<div class="ib_product" style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "100%", "200px");
					</script>
				</div>
			</div>

			<!--하단 버튼-->
			<div class="btnArea mt05" style="text-align:center; padding:10px 0;">
				<span class="btn_06"><a href="javascript:self.close();">닫기</a></span>
			</div>
		</div>
	</div>
</body>
</html>
