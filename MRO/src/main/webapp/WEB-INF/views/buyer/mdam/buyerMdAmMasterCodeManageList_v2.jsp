<%--
**********************************************
* 메뉴 : 관리자설정관리 > 마스터코드관리
* 화면 : 마스터코드관리 (리뉴얼 v2 — 5탭 통합)
* 기능 : 도착지/직급/부서/계정/관리 5종 마스터코드를 단일 화면에서 관리
*        레거시 5개 화면 통합:
*          - masterMdAmMasterCodeManageList.jsp     (도착지, PG_90_B_400_13, st_type=C012)
*          - masterMdAmMasterCodePositionList.jsp   (직급, PG_90_B_400_24, st_type=C003)
*          - masterMdAmMasterCodeDepartmentList.jsp (부서, PG_90_B_400_25, st_type=C001)
*          - masterMdAmMasterCodeAccountList.jsp    (계정, PG_90_B_400_26, st_type=Z014)
*          - masterMdAmMasterCodeRefNoList.jsp      (관리, PG_90_B_400_27, st_type=M014)
* 백엔드  : master 모듈 4개 엔드포인트 무수정 재사용
*          - /mdam/getMasterMdAmMasterCodeManageList.do  (조회, st_type 분기)
*          - /mdam/saveMasterMdAmMasterCodeManageList.do (저장)
*          - /mdam/delMasterMdAmMasterCodeManageList.do  (삭제)
* 진입 URL : /mdam/showBuyerMdAmMasterCodeManage.do
* 메뉴 ID  : br00503000000 (depth-2), 탭 br00503010000~br00503050000 (depth-3)
* 착수일   : 2026-05-12
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.LinkedHashSet"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf" %>
<style>
.input-error  { border:2px solid #F6495F !important; background:#FFF5F5 !important; }
.select-error { border:2px solid #F6495F !important; background:#FFF5F5 !important; }
.IBSheetBuyer { min-height:400px; }
.SearchContent { display:none; }
.SearchContent.active { display:block; }
/* 우편번호 셀 파란색 링크 시각화 */
.zip-link { color:#3a72c7; cursor:pointer; text-decoration:underline; }
</style>
</head>
<%
// 회사 예산모드 — 부서 콤보 분기용 (레거시 masterMdAmMasterCodeDepartmentList.jsp:51-58 동일 분기)
String budget_flag = CommonUtil.nvl(_sessionInfo != null ? _sessionInfo.getBudgetFlag() : "", "N");

// 메뉴 ID & 즐겨찾기 (head_v2.jspf 가 myMenuListHeader 노출)
String menuId = CommonUtil.nvl((String) request.getParameter("menuId"), "br00503000000");
if (myMenuListHeader != null) {
	for (int i = 0; i < myMenuListHeader.size(); i++) {
		if (menuId.equals(myMenuListHeader.get(i).get("MENU_ID"))) {
			myMenuFlag = true;
			break;
		}
	}
}

// 탭 권한 데이터 (selectMenuTabInfo_v2 SQL → Controller 가 tab_data attribute 로 전달)
@SuppressWarnings("unchecked")
List<Map<String,String>> _tabData = (List<Map<String,String>>) request.getAttribute("tab_data");
Set<String> _allowedTabs = new LinkedHashSet<String>();
if (_tabData != null) {
	java.util.regex.Pattern _tabPattern = java.util.regex.Pattern.compile("data-tab=[\"']([^\"']+)[\"']");
	for (Map<String,String> t : _tabData) {
		String html = CommonUtil.nvl(t.get("MENU_BUTTON"));
		if ("".equals(html)) continue;
		java.util.regex.Matcher m = _tabPattern.matcher(html);
		if (m.find()) _allowedTabs.add(m.group(1));
	}
}
// 요청 탭이 허용 범위 밖이면 첫 허용 탭으로 보정
String st_tab = CommonUtil.nvl((String) request.getParameter("st_tab"), "Search1");
if (!_allowedTabs.isEmpty() && !_allowedTabs.contains(st_tab)) {
	st_tab = _allowedTabs.iterator().next();
}
%>
<body>
<div id="wrapper">
<c:import charEncoding="utf-8" url="/menu/menu.do">
	<c:param name="page" value="buyerHeader_v2"/>
	<c:param name="part" value="buyerHeader_v2"/>
</c:import>
<div id="container2">
	<!-- 서브타이틀 -->
	<div class="SubPageTit">
		마스터코드관리
		<% if (myMenuFlag) { %>
			<button class="But_Star_on"></button>
		<% } else { %>
			<button class="But_Star_off"></button>
		<% } %>
		<div class="SubPageGuide">
			<ul>
				<li><img src="/resources/imgs/Icon_Home.png" /></li>
				<li>관리자설정관리</li>
				<li>마스터코드관리</li>
			</ul>
		</div>
	</div>

	<div class="container">
		<!-- 탭: KX_MENUINFO.UPPER_ID=br00503000000 하위 노드의 MENU_DC(=button HTML) 직접 출력 -->
		<div class="SubSearchTab">
		<% if (_tabData != null && !_tabData.isEmpty()) {
			for (int i = 0; i < _tabData.size(); i++) { %>
			<%=_tabData.get(i).get("MENU_BUTTON") %>
		<%	}
		} else { %>
			<%-- Fallback: tab_data 비어있을 때 (DB 미등록/권한 없음 대응) --%>
			<button type="button" class="TabTit" data-tab="Search1">도착지코드</button>
			<button type="button" class="TabTit" data-tab="Search2">직급코드</button>
			<button type="button" class="TabTit" data-tab="Search3">부서코드</button>
			<button type="button" class="TabTit" data-tab="Search4">계정코드</button>
			<button type="button" class="TabTit" data-tab="Search5">관리코드</button>
		<% } %>
		</div>

		<%-- ─── 탭1: 도착지코드 (st_type=C012) ─── --%>
		<div id="Search1" class="SearchContent">
		<div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /><%=CommonLang.msg("MSG965") %> <!-- 도착지 코드를 등록, 수정, 삭제할 수 있습니다. --></div>
			<form name="searchForm1" id="searchForm1" method="post">
				<input type="hidden" name="s_SAVENAME" />
				<input type="hidden" name="menuId" value="<%=menuId%>" />
				<input type="hidden" name="st_user_id" value="${sessionInfo.userId}" />
				<input type="hidden" name="st_com_code" value="${sessionInfo.comCode}" />
				<input type="hidden" name="st_type" id="st_type_1" value="C012" />
				<table class="TabSearchTable">
					<colgroup><col width="100px"/><col width="630px"/><col width="80px"/><col width="470px"/></colgroup>
					<tr>
						<th>도착지코드</th>
						<td><input class="input40" style="width:450px" type="text" name="st_code" id="st_code_1" onkeyup="kepToUpper('st_code_1')" onkeydown="if(event.keyCode==13){fn_search(1);return false;}" /></td>
						<th>도착지명</th>
						<td><input class="input40" style="width:450px" type="text" name="st_name" id="st_name_1" onkeydown="if(event.keyCode==13){fn_search(1);return false;}" /></td>
					</tr>
				</table>
				<div class="SearchBtnBox">
					<button type="button" class="ButOutline_Medium" onclick="fn_reset(1)">초기화</button>
					<button type="button" class="ButDarkGray_Medium" onclick="fn_search(1)">조회</button>
				</div>
			</form>
			<div class="ArraySub mt30 mb10">
				<div class="buttonRight">
					<button type="button" class="ButOutline_Medium" onclick="fn_add(1)">행추가</button>
					<button type="button" class="ButOutline_Medium" onclick="fn_delete(1)">삭제</button>
					<button type="button" class="ButPrimary_Medium" onclick="fn_save(1)">저장</button>
				</div>
			</div>
			<div class="IBSheetBuyer">
				<script type="text/javascript">createIBSheet("mySheet1", "", "100%");</script>
			</div>
		</div>

		<%-- ─── 탭2: 직급코드 (st_type=C003) ─── --%>
		<div id="Search2" class="SearchContent">
		<div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /><%=CommonLang.msg("MSG966") %> <!-- 직급 코드를 등록, 수정, 삭제할 수 있습니다. --></div>
			<form name="searchForm2" id="searchForm2" method="post">
				<input type="hidden" name="s_SAVENAME" />
				<input type="hidden" name="menuId" value="<%=menuId%>" />
				<input type="hidden" name="st_user_id" value="${sessionInfo.userId}" />
				<input type="hidden" name="st_com_code" value="${sessionInfo.comCode}" />
				<input type="hidden" name="st_type" id="st_type_2" value="C003" />
				<table class="TabSearchTable">
					<colgroup><col width="100px"/><col width="630px"/><col width="80px"/><col width="470px"/></colgroup>
					<tr>
						<th>직급코드</th>
						<td><input class="input40" style="width:450px" type="text" name="st_code" id="st_code_2" onkeyup="kepToUpper('st_code_2')" onkeydown="if(event.keyCode==13){fn_search(2);return false;}" /></td>
						<th>직급명</th>
						<td><input class="input40" style="width:450px" type="text" name="st_name" id="st_name_2" onkeydown="if(event.keyCode==13){fn_search(2);return false;}" /></td>
					</tr>
				</table>
				<div class="SearchBtnBox">
					<button type="button" class="ButOutline_Medium" onclick="fn_reset(2)">초기화</button>
					<button type="button" class="ButDarkGray_Medium" onclick="fn_search(2)">조회</button>
				</div>
			</form>
			<div class="ArraySub mt30 mb10">
				<div class="buttonRight">
					<button type="button" class="ButOutline_Medium" onclick="fn_add(2)">행추가</button>
					<button type="button" class="ButOutline_Medium" onclick="fn_delete(2)">삭제</button>
					<button type="button" class="ButPrimary_Medium" onclick="fn_save(2)">저장</button>
				</div>
			</div>
			<div class="IBSheetBuyer">
				<script type="text/javascript">createIBSheet("mySheet2", "", "100%");</script>
			</div>
		</div>

		<%-- ─── 탭3: 부서코드 (st_type=C001, _Dept SQL 분기) ─── --%>
		<div id="Search3" class="SearchContent">
		<div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /><%=CommonLang.msg("MSG967") %> <!-- 부서 코드를 등록, 수정, 삭제할 수 있으며, 등록한 부서에 발주 권한을 부여할지 선택합니다. --></div>
			<form name="searchForm3" id="searchForm3" method="post">
				<input type="hidden" name="s_SAVENAME" />
				<input type="hidden" name="menuId" value="<%=menuId%>" />
				<input type="hidden" name="st_user_id" value="${sessionInfo.userId}" />
				<input type="hidden" name="st_com_code" value="${sessionInfo.comCode}" />
				<input type="hidden" name="st_type" id="st_type_3" value="C001" />
				<table class="TabSearchTable">
					<colgroup><col width="100px"/><col width="630px"/><col width="80px"/><col width="470px"/></colgroup>
					<tr>
						<th>부서코드</th>
						<td><input class="input40" style="width:450px" type="text" name="st_code" id="st_code_3" onkeyup="kepToUpper('st_code_3')" onkeydown="if(event.keyCode==13){fn_search(3);return false;}" /></td>
						<th>부서명</th>
						<td><input class="input40" style="width:450px" type="text" name="st_name" id="st_name_3" onkeydown="if(event.keyCode==13){fn_search(3);return false;}" /></td>
					</tr>
				</table>
				<div class="SearchBtnBox">
					<button type="button" class="ButOutline_Medium" onclick="fn_reset(3)">초기화</button>
					<button type="button" class="ButDarkGray_Medium" onclick="fn_search(3)">조회</button>
				</div>
			</form>
			<div class="ArraySub mt30 mb10">
				<div class="buttonRight">
					<button type="button" class="ButOutline_Medium" onclick="fn_add(3)">행추가</button>
					<button type="button" class="ButOutline_Medium" onclick="fn_delete(3)">삭제</button>
					<button type="button" class="ButPrimary_Medium" onclick="fn_save(3)">저장</button>
				</div>
			</div>
			<div class="IBSheetBuyer">
				<script type="text/javascript">createIBSheet("mySheet3", "", "100%");</script>
			</div>
		</div>

		<%-- ─── 탭4: 계정코드 (st_type=Z014) ─── --%>
		<div id="Search4" class="SearchContent">
		<div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /><%=CommonLang.msg("MSG968") %> <!-- 계정 코드를 등록, 수정, 삭제할 수 있으며, 금액 통제 여부를 선택합니다. --></div>
			<form name="searchForm4" id="searchForm4" method="post">
				<input type="hidden" name="s_SAVENAME" />
				<input type="hidden" name="menuId" value="<%=menuId%>" />
				<input type="hidden" name="st_user_id" value="${sessionInfo.userId}" />
				<input type="hidden" name="st_com_code" value="${sessionInfo.comCode}" />
				<input type="hidden" name="st_type" id="st_type_4" value="Z014" />
				<table class="TabSearchTable">
					<colgroup><col width="100px"/><col width="630px"/><col width="80px"/><col width="470px"/></colgroup>
					<tr>
						<th>계정코드</th>
						<td><input class="input40" style="width:450px" type="text" name="st_code" id="st_code_4" onkeyup="kepToUpper('st_code_4')" onkeydown="if(event.keyCode==13){fn_search(4);return false;}" /></td>
						<th>계정명</th>
						<td><input class="input40" style="width:450px" type="text" name="st_name" id="st_name_4" onkeydown="if(event.keyCode==13){fn_search(4);return false;}" /></td>
					</tr>
				</table>
				<div class="SearchBtnBox">
					<button type="button" class="ButOutline_Medium" onclick="fn_reset(4)">초기화</button>
					<button type="button" class="ButDarkGray_Medium" onclick="fn_search(4)">조회</button>
				</div>
			</form>
			<div class="ArraySub mt30 mb10">
				<div class="buttonRight">
					<button type="button" class="ButOutline_Medium" onclick="fn_add(4)">행추가</button>
					<button type="button" class="ButOutline_Medium" onclick="fn_delete(4)">삭제</button>
					<button type="button" class="ButPrimary_Medium" onclick="fn_save(4)">저장</button>
				</div>
			</div>
			<div class="IBSheetBuyer">
				<script type="text/javascript">createIBSheet("mySheet4", "", "100%");</script>
			</div>
		</div>

		<%-- ─── 탭5: 관리코드 (st_type=M014) ─── --%>
		<div id="Search5" class="SearchContent">
		<div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /><%=CommonLang.msg("MSG969") %> <!-- 관리 코드를 등록, 수정, 삭제할 수 있으며, 사용 여부를 선택합니다. --></div>
			<form name="searchForm5" id="searchForm5" method="post">
				<input type="hidden" name="s_SAVENAME" />
				<input type="hidden" name="menuId" value="<%=menuId%>" />
				<input type="hidden" name="st_user_id" value="${sessionInfo.userId}" />
				<input type="hidden" name="st_com_code" value="${sessionInfo.comCode}" />
				<input type="hidden" name="st_type" id="st_type_5" value="M014" />
				<table class="TabSearchTable">
					<colgroup><col width="100px"/><col width="630px"/><col width="80px"/><col width="470px"/></colgroup>
					<tr>
						<th>관리코드</th>
						<td><input class="input40" style="width:450px" type="text" name="st_code" id="st_code_5" onkeyup="kepToUpper('st_code_5')" onkeydown="if(event.keyCode==13){fn_search(5);return false;}" /></td>
						<th>관리명</th>
						<td><input class="input40" style="width:450px" type="text" name="st_name" id="st_name_5" onkeydown="if(event.keyCode==13){fn_search(5);return false;}" /></td>
					</tr>
				</table>
				<div class="SearchBtnBox">
					<button type="button" class="ButOutline_Medium" onclick="fn_reset(5)">초기화</button>
					<button type="button" class="ButDarkGray_Medium" onclick="fn_search(5)">조회</button>
				</div>
			</form>
			<div class="ArraySub mt30 mb10">
				<div class="buttonRight">
					<button type="button" class="ButOutline_Medium" onclick="fn_add(5)">행추가</button>
					<button type="button" class="ButOutline_Medium" onclick="fn_delete(5)">삭제</button>
					<button type="button" class="ButPrimary_Medium" onclick="fn_save(5)">저장</button>
				</div>
			</div>
			<div class="IBSheetBuyer">
				<script type="text/javascript">createIBSheet("mySheet5", "", "100%");</script>
			</div>
		</div>

		<div class="h50"></div>
	</div><!-- container -->
</div><!-- container2 -->
<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>
</div><!-- wrapper -->

<script type="text/javascript">
// ────────────────────────────────────────────────────────────
// 전역 변수
// ────────────────────────────────────────────────────────────
var pagingMode = "N";              // 스크롤 모드 (마스터코드는 회사당 수십~수백건 — 페이징 불필요)
var currentTab = "<%=st_tab%>";
var BUDGET_FLAG = "<%=budget_flag%>";  // 부서 콤보 분기용 (Y=예산회사 4지, N=일반회사 2지)
var grbRow1 = 0;                   // 도착지 탭 우편번호 팝업 호출 시 현재 행 추적

// 데이터 엔드포인트 — master 모듈 재사용 (5탭 공통)
var URL_SEARCH = "/mdam/getMasterMdAmMasterCodeManageList.do";
var URL_SAVE   = "/mdam/saveMasterMdAmMasterCodeManageList.do";
var URL_DELETE = "/mdam/delMasterMdAmMasterCodeManageList.do";

// 허용 탭 (KX_MENUAUTH 권한 필터링 결과) — 빈 경우 5탭 모두 허용 (fallback)
var allowedTabs = [<%
	if (_allowedTabs.isEmpty()) {
		out.print("\"Search1\",\"Search2\",\"Search3\",\"Search4\",\"Search5\"");
	} else {
		boolean _first = true;
		for (String _k : _allowedTabs) {
			if (!_first) out.print(",");
			out.print("\"" + _k + "\"");
			_first = false;
		}
	}
%>];

// ────────────────────────────────────────────────────────────
// 초기화
// ────────────────────────────────────────────────────────────
$(function() {
	fn_initSheet1();
	fn_initSheet2();
	fn_initSheet3();
	fn_initSheet4();
	fn_initSheet5();

	// 탭 활성화
	$(".TabTit").removeClass("active");
	$(".TabTit[data-tab='" + currentTab + "']").addClass("active");
	$(".SearchContent").removeClass("active");
	$("#" + currentTab).addClass("active");

	// 탭 클릭 이벤트 위임 (XSS 필터로 onclick 제거되므로 JS 바인딩 필수)
	$(document).on("click", ".SubSearchTab .TabTit[data-tab]", function() {
		var tab = $(this).attr("data-tab");
		if (tab) fn_switchTab(tab);
	});

	// 최초 진입 시 활성 탭만 자동조회 (lazy 패턴 — 사용자관리 _v2 동일)
	// 5탭 동시 호출하면 (a) loader 동기화 어려움 (b) 백엔드 5개 동시 부하 (c) 비활성 시트의 reflow 미발생 → display:none 시트는 빈 화면
	var initIdx = parseInt(currentTab.replace("Search", ""), 10);
	if (!isNaN(initIdx) && allowedTabs.indexOf(currentTab) >= 0) {
		// 최초 진입 탭은 fn_switchTab 을 거치지 않으므로 여기서 폭을 맞춘다
		// (탭 권한에 따라 도착지가 아닌 부서/계정/관리 탭으로 바로 진입할 수 있다)
		fn_showSheet(initIdx);
		fn_search(initIdx);
	}
});

// 탭 처음 진입 시 lazy 조회 (한번 조회된 탭은 SearchedTabs 에 기록 → 재진입 시 재조회 안 함)
var searchedTabs = {};

// ────────────────────────────────────────────────────────────
// 탭 전환
// ────────────────────────────────────────────────────────────
function fn_switchTab(tab) {
	if (allowedTabs.indexOf(tab) < 0) {
		alert("접근 권한이 없는 탭입니다.");
		return;
	}
	$(".TabTit").removeClass("active");
	$(".TabTit[data-tab='" + tab + "']").addClass("active");
	$(".SearchContent").removeClass("active");
	$("#" + tab).addClass("active");
	currentTab = tab;

	var idx = parseInt(tab.replace("Search", ""), 10);
	fn_showSheet(idx);

	// 탭 처음 진입 시 자동조회 (이미 조회한 탭은 스킵 — 재진입 시 사용자 검색결과 유지)
	if (!isNaN(idx) && !searchedTabs[idx]) {
		fn_search(idx);
	}
}

// 시트가 보이게 된 시점 처리
//  - Render : 숨김 상태에서는 head_v2 의 refreshAllIBSheets 가 갱신을 건너뛰므로 여기서 1회 그린다
//  - FitColWidth : 선언 폭 합계가 컨테이너(1280)보다 작은 탭(부서/계정/관리)에서 우측 공백이 남는 것을 방지
//    (조회는 비동기지만 데이터 도착 후에도 폭이 유지되므로 여기서 한 번만 호출하면 된다)
function fn_showSheet(idx) {
	var sheet = fn_getSheet(idx);
	if (!sheet) return;
	if (typeof sheet.Render === "function") sheet.Render();
	if (typeof sheet.FitColWidth === "function") sheet.FitColWidth();
}


function fn_initSheet1() { // 도착지 (C012)
	var initsheet1 = {};
	initsheet1.Cfg = {MergeSheet:msHeaderOnly, HeaderRowHeight:35, DataRowHeight:30, Alternate:0, UseNoDataRow:1};
	initsheet1.Cols = [
		{Type:"Status",     SaveName:"sStatus",   Header:"상태",         Width:60,  Align:"Center", Edit:false, Hidden:true},
		{Type:"Text",       SaveName:"RN",        Header:"순번",         Width:40,  Align:"Center", Edit:false, Hidden:true},
		{Type:"DummyCheck", SaveName:"SELECTED",  Header:"",             Width:40,  Align:"Center", Edit:true},
		{Type:"Text",       SaveName:"CODE",      Header:"코드",         Width:80,  Align:"Left",   Edit:true,  KeyField:true, EditLen:20},
		{Type:"Text",       SaveName:"TEXT1",     Header:"도착지명",     Width:200, Align:"Left",   Edit:true,  KeyField:true, EditLen:200},
		{Type:"Text",       SaveName:"ZIP_CODE",  Header:"우편번호",     Width:80,  Align:"Center", Edit:false, KeyField:true, FontColor:"#3a72c7", Cursor:"Pointer"},
		{Type:"Text",       SaveName:"ADDRESS01", Header:"도착지주소",   Width:490, Align:"Left",   Edit:false, KeyField:true, EditLen:200},
		{Type:"Text",       SaveName:"ADDRESS02", Header:"도착지상세",   Width:390, Align:"Left",   Edit:false, EditLen:200},
		{Type:"Text",       SaveName:"ORG_CODE",  Header:"ORG_CODE",     Hidden:true},
		{Type:"Text",       SaveName:"TEXT2",     Header:"TEXT2",        Hidden:true},
		{Type:"Text",       SaveName:"TEXT3",     Header:"ZIP_KEY",      Hidden:true},
		{Type:"Text",       SaveName:"TEXT4",     Header:"TEXT4",        Hidden:true}
	];
	IBS_InitSheet(mySheet1, initsheet1, pagingMode);
	mySheet1.SetHeaderBackColor("#f2f7ff");
	mySheet1.SetTheme("DB", "DeepBlue");
}

function fn_initSheet2() { // 직급 (C003)
	var initsheet2 = {};
	initsheet2.Cfg = {MergeSheet:msHeaderOnly, HeaderRowHeight:35, DataRowHeight:30, Alternate:0, UseNoDataRow:1};
	initsheet2.Cols = [
		{Type:"Status",     SaveName:"sStatus",   Header:"상태",         Width:60,  Align:"Center", Edit:false, Hidden:true},
		{Type:"Text",       SaveName:"RN",        Header:"순번",         Width:40,  Align:"Center", Edit:false, Hidden:true},
		{Type:"DummyCheck", SaveName:"SELECTED",  Header:"",             Width:40,  Align:"Center", Edit:true},
		{Type:"Text",       SaveName:"CODE",      Header:"코드",         Width:180, Align:"Left",   Edit:true,  KeyField:true, EditLen:20, AcceptKeys:"N|E"},
		{Type:"Text",       SaveName:"TEXT1",     Header:"직급명",       Width:500, Align:"Left",   Edit:true,  KeyField:true, EditLen:200},
		{Type:"Text",       SaveName:"TEXT2",     Header:"직급명(영문)", Width:540, Align:"Left",   Edit:true,  EditLen:200},
		{Type:"Text",       SaveName:"ORG_CODE",  Header:"ORG_CODE",     Hidden:true},
		{Type:"Text",       SaveName:"TEXT3",     Header:"TEXT3",        Hidden:true},
		{Type:"Text",       SaveName:"TEXT4",     Header:"TEXT4",        Hidden:true}
	];
	IBS_InitSheet(mySheet2, initsheet2, pagingMode);
	mySheet2.SetHeaderBackColor("#f2f7ff");
	mySheet2.SetTheme("DB", "DeepBlue");
}

function fn_initSheet3() { // 부서 (C001) — DEPT_TYPE 콤보 분기 (예산회사 4지 / 일반회사 2지)
	var initsheet3 = {};
	initsheet3.Cfg = {TooltipHtml:1,MergeSheet:msHeaderOnly, HeaderRowHeight:35, DataRowHeight:30, Alternate:0, UseNoDataRow:1};
// 	var deptCombo = (BUDGET_FLAG === "Y")
// 		? {ComboCode:"N|B|D|Y", ComboText:"예산부서겸용|예산부서전용|일반부서전용|발주부서"}
// 		: {ComboCode:"N|Y",     ComboText:"일반부서|발주부서"};
	initsheet3.Cols = [
		{Type:"Status",     SaveName:"sStatus",       Header:"상태",         Width:60,  Align:"Center", Edit:false, Hidden:true},
		{Type:"Text",       SaveName:"RN",            Header:"순번",         Width:40,  Align:"Center", Edit:false, Hidden:true},
		{Type:"DummyCheck", SaveName:"SELECTED",      Header:"",             Width:40,  Align:"Center", Edit:true},
		{Type:"Text",       SaveName:"CODE",          Header:"부서코드",     Width:80,  Align:"Left",   Edit:false,  KeyField:true, EditLen:20},
		{Type:"Text",       SaveName:"TEXT1",         Header:"약식부서명",   Width:400, Align:"Left",   Edit:true,  KeyField:true, EditLen:200},
		{Type:"Text",       SaveName:"TEXT2",         Header:"전체부서명",   Width:400, Align:"Left",   Edit:true,  EditLen:200},
		{Type:"CheckBox", 	SaveName:"DEPT_TYPE_TEXT",	  Header:"발주권한",		Width:120,Align:"Center",	Edit:true,	EditLen:100,	Hidden:false, ItemText:"가능|불가능",  ItemCode:"Y|N", MaxCheck:1, RadioIcon:1,BackColor:"${optColor}"},
		{Type:"Text",       SaveName:"DEPT_TYPE",     Header:"DEPT_TYPE",          Hidden:true, Edit:false},
// 		$.extend({Type:"Combo", SaveName:"DEPT_TYPE", Header:"발주가능여부", Width:120, Align:"Center", Edit:true, EditLen:200}, deptCombo),
		{Type:"Text",       SaveName:"ORG_CODE",      Header:"ORG_CODE",       Hidden:true},
		{Type:"Text",       SaveName:"ORG_DEPT_TYPE", Header:"ORG_DEPT_TYPE",  Hidden:true},
		{Type:"Text",       SaveName:"TEXT3",         Header:"TEXT3",          Hidden:true},
		{Type:"Text",       SaveName:"TEXT4",         Header:"TEXT4",          Hidden:true},
	];
	IBS_InitSheet(mySheet3, initsheet3, pagingMode);
	mySheet3.SetHeaderBackColor("#f2f7ff");
	mySheet3.SetTheme("DB", "DeepBlue");
}

function fn_initSheet4() { // 계정 (Z014)
	var initsheet4 = {};
	initsheet4.Cfg = {MergeSheet:msHeaderOnly, HeaderRowHeight:35, DataRowHeight:30, Alternate:0, UseNoDataRow:1};
	initsheet4.Cols = [
		{Type:"Status",     SaveName:"sStatus",     Header:"상태",         Width:60,  Align:"Center", Edit:false, Hidden:true},
		{Type:"Text",       SaveName:"RN",          Header:"순번",         Width:50,  Align:"Center", Edit:false, Hidden:true},
		{Type:"DummyCheck", SaveName:"SELECTED",    Header:"",             Width:50,  Align:"Center", Edit:true},
		{Type:"Text",       SaveName:"CODE",        Header:"계정코드",     Width:100, Align:"Left",   Edit:true,  KeyField:true, EditLen:20},
		{Type:"Text",       SaveName:"TEXT1",       Header:"계정명",       Width:300, Align:"Left",   Edit:true,  KeyField:true, EditLen:200},
		{Type:"Text",       SaveName:"TEXT5",       Header:"관리부서코드", Width:100, Align:"Left",   Edit:true,  EditLen:20},
		{Type:"Text",       SaveName:"TEXT6",       Header:"관리부서명",   Width:300, Align:"Left",   Edit:true,  EditLen:200},
		{Type:"Combo",      SaveName:"FLAG",        Header:"금액통제여부", Width:120, Align:"Center", Edit:true,  EditLen:200, ComboCode:"N|Y", ComboText:"미적용|적용"},
		{Type:"Text",       SaveName:"MODIFY_FLAG", Header:"MODIFY_FLAG",  Hidden:true},
		{Type:"Text",       SaveName:"ORG_CODE",    Header:"ORG_CODE",     Hidden:true},
		{Type:"Text",       SaveName:"TEXT2",       Header:"TEXT2",        Hidden:true},
		{Type:"Text",       SaveName:"TEXT3",       Header:"TEXT3",        Hidden:true},
		{Type:"Text",       SaveName:"TEXT4",       Header:"TEXT4",        Hidden:true}
	];
	IBS_InitSheet(mySheet4, initsheet4, pagingMode);
	mySheet4.SetHeaderBackColor("#f2f7ff");
	mySheet4.SetTheme("DB", "DeepBlue");
}

function fn_initSheet5() { // 관리 (M014)
	var initsheet5 = {};
	initsheet5.Cfg = {MergeSheet:msHeaderOnly, HeaderRowHeight:35, DataRowHeight:30, Alternate:0, UseNoDataRow:1};
	initsheet5.Cols = [
		{Type:"Status",     SaveName:"sStatus",     Header:"상태",     Width:60,  Align:"Center", Edit:false, Hidden:true},
		{Type:"Text",       SaveName:"RN",          Header:"순번",     Width:50,  Align:"Center", Edit:false, Hidden:true},
		{Type:"DummyCheck", SaveName:"SELECTED",    Header:"",         Width:50,  Align:"Center", Edit:true},
		{Type:"Text",       SaveName:"CODE",        Header:"관리코드", Width:120, Align:"Left",   Edit:false,  KeyField:true, EditLen:20},
		{Type:"Text",       SaveName:"TEXT1",       Header:"관리명",   Width:500, Align:"Left",   Edit:true,  KeyField:true, EditLen:200},
		{Type:"Combo",      SaveName:"FLAG",        Header:"적용여부", Width:120, Align:"Center", Edit:true,  EditLen:200, ComboCode:"N|Y", ComboText:"미사용|사용"},
		{Type:"Text",       SaveName:"MODIFY_FLAG", Header:"MODIFY_FLAG", Hidden:true},
		{Type:"Text",       SaveName:"ORG_CODE",    Header:"ORG_CODE",    Hidden:true},
		{Type:"Text",       SaveName:"TEXT2",       Header:"TEXT2",       Hidden:true},
		{Type:"Text",       SaveName:"TEXT3",       Header:"TEXT3",       Hidden:true},
		{Type:"Text",       SaveName:"TEXT4",       Header:"TEXT4",       Hidden:true}
	];
	IBS_InitSheet(mySheet5, initsheet5, pagingMode);
	mySheet5.SetHeaderBackColor("#f2f7ff");
	mySheet5.SetTheme("DB", "DeepBlue");
}

// ────────────────────────────────────────────────────────────
// 액션 함수 — 5탭 공통 (탭 인덱스 1~5 인자로 분기)
// ────────────────────────────────────────────────────────────
function fn_getSheet(idx)     { return window["mySheet" + idx]; }
function fn_getForm(idx)      { return document["searchForm" + idx]; }

function fn_search(idx) {
	var sheet = fn_getSheet(idx);
	var form  = fn_getForm(idx);
	if (!sheet || !form) return;
	searchedTabs[idx] = true;  // lazy 자동조회 중복 방지용 마킹
	kepSearch(form, sheet, URL_SEARCH, pagingMode);
}

function fn_reset(idx) {
	$("#st_code_" + idx).val("");
	$("#st_name_" + idx).val("");
	fn_search(idx);
}

function fn_add(idx) {
	var sheet = fn_getSheet(idx);
	if (!sheet) return;
	var row = sheet.DataInsert(-1);
	sheet.SetCellValue(row, "SELECTED", 1);
	sheet.SetCellEditable(row,"CODE",true);
}

function fn_delete(idx) {
	var sheet = fn_getSheet(idx);
	var form  = fn_getForm(idx);
	if (!sheet || !form) return;

	// sStatus='I'(신규 행) 인 행은 즉시 RowDelete, 나머지는 SELECTED 체크된 행만 서버 전송
	for (var i = sheet.RowCount(); i >= 1; i--) {
		if (sheet.GetCellValue(i, "SELECTED") == 1 && sheet.GetCellValue(i, "sStatus") == "I") {
			sheet.RowDelete(i, 0);
		}
	}
	if (sheet.FindCheckedRow("SELECTED").length == 0) {
		alert("삭제할 항목을 선택해 주십시오.");
		return;
	}
	if (!confirm("선택한 행을 삭제하시겠습니까?")) return;
	kepSave(form, sheet, URL_DELETE, "SELECTED");
}

function fn_save(idx) {
	var sheet = fn_getSheet(idx);
	var form  = fn_getForm(idx);
	if (!sheet || !form) return;

	// 필수 항목 검증
	if (!fn_validate(idx)) return;

	// 도착지 탭: 저장 직전 TEXT2 (공백 조합) + TEXT4 (@ 조합) 셋팅 — 레거시 beforeProcessSave 동일
	if (idx === 1) {
		for (var i = 1; i <= sheet.RowCount(); i++) {
			if (sheet.GetCellValue(i, "SELECTED") == 1) {
				var zip = sheet.GetCellValue(i, "ZIP_CODE")  + "";
				var a1  = sheet.GetCellValue(i, "ADDRESS01") + "";
				var a2  = sheet.GetCellValue(i, "ADDRESS02") + "";
				sheet.SetCellValue(i, "TEXT2", zip + " " + a1 + " " + a2);
				sheet.SetCellValue(i, "TEXT4", zip + "@" + a1 + "@" + a2);
			}
		}
	}

	kepSave(form, sheet, URL_SAVE, "SELECTED");
}

// 탭별 필수 필드 검증
function fn_validate(idx) {
	var sheet = fn_getSheet(idx);
	if (!sheet) return false;

	var required = [];
	switch (idx) {
		case 1: required = ["CODE", "TEXT1"]; break;
		case 2: required = ["CODE", "TEXT1"]; break;
		case 3: required = ["CODE", "TEXT1", "DEPT_TYPE"]; break;
		case 4: required = ["CODE", "TEXT1", "FLAG"]; break;
		case 5: required = ["CODE", "TEXT1"]; break;
	}

	// 미입력 행 전체를 누적 (한 행에 여러 필드가 비어도 행 번호는 1회만 기록)
	var failRows = [];
	var firstRow = -1, firstCol = "";
	for (var i = 1; i <= sheet.RowCount(); i++) {
		if (sheet.GetCellValue(i, "SELECTED") != 1) continue;
		for (var c = 0; c < required.length; c++) {
			var v = sheet.GetCellValue(i, required[c]);
			if (v == null || v === "") {
				failRows.push(i);
				if (firstRow < 0) { firstRow = i; firstCol = required[c]; }
				break;
			}
		}
	}
	if (failRows.length > 0) {
		alert("필수 항목을 입력해주세요. (" + failRows.join("행, ") + "행)");
		try { sheet.SelectCell(firstRow, firstCol, true); } catch (e) {}
		return false;
	}
	return true;
}

// ────────────────────────────────────────────────────────────
// 도착지 탭 — 우편번호 팝업 / 콜백 / 조회 후처리
// ────────────────────────────────────────────────────────────
// 그리드 셀 클릭 (탭1 전용) — 우편번호 컬럼 클릭 시 팝업 호출
// 도착지주소/도착지상세 컬럼은 직접 입력 차단 (Edit:false) + 클릭 시 우편번호 입력 안내
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if (Row < 1) return;
	var column = mySheet1.ColSaveName(mySheet1.GetSelectCol());
	grbRow1 = Row;
	if (column == "ZIP_CODE") {
		fn_openZipPopup();
	} else if (column == "ADDRESS01" || column == "ADDRESS02") {
		var zip = (mySheet1.GetCellValue(Row, "ZIP_CODE") + "").replace(/\s/g, "");
		if (!zip) alert("우편번호를 입력해주세요.");
	}
}

//부서코드 발주권한(가능/불가능 선택 시 )
function mySheet3_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if (Row < 1) return;
	var column = mySheet3.ColSaveName(mySheet3.GetSelectCol());
	if (column == "DEPT_TYPE_TEXT") {
		if(mySheet3.GetCellValue(Row,"DEPT_TYPE_TEXT") == "Y:1|N:0"){
			mySheet3.SetCellValue(Row,"DEPT_TYPE","Y");
		}else{
			mySheet3.SetCellValue(Row,"DEPT_TYPE","N");
		}
	}
}

// CODE 중복 체크 (탭1~5 공통) — KeyField 무결성
function mySheet1_OnAfterEdit(Row, Col) { fn_checkCodeDup(mySheet1, Row, Col); }
function mySheet2_OnAfterEdit(Row, Col) { fn_checkCodeDup(mySheet2, Row, Col); }
function mySheet3_OnAfterEdit(Row, Col) { fn_checkCodeDup(mySheet3, Row, Col); }
function mySheet4_OnAfterEdit(Row, Col) { fn_checkCodeDup(mySheet4, Row, Col); }
function mySheet5_OnAfterEdit(Row, Col) { fn_checkCodeDup(mySheet5, Row, Col); }

function fn_checkCodeDup(sheet, Row, Col) {
	var column = sheet.ColSaveName(sheet.GetSelectCol());
	if (column !== "CODE") return;
	// 방금 편집한 행의 CODE 값 — 빈값/공백이면 중복 체크 제외 (신규 빈 행 오인식 방지)
	var code = (sheet.GetCellValue(Row, "CODE") + "").replace(/\s/g, "");
	if (code === "") return;
	// 다른 행과 직접 비교 (자기 자신 행 제외, 빈값 행 건너뜀)
	for (var i = 1; i <= sheet.RowCount(); i++) {
		if (i === Row) continue;
		var other = (sheet.GetCellValue(i, "CODE") + "").replace(/\s/g, "");
		if (other === "") continue;
		if (other === code) {
			alert("입력하신 코드는 이미 존재합니다.");
			sheet.SetCellValue(Row, "CODE", "");
			return;
		}
	}
}

// 저장/삭제 후처리 (탭별로 동일 — 성공 시 재조회) — loader_obj("N") 명시 호출 (master JSP:198 동일)
function mySheet1_OnSaveEnd(code, msg, stCode) { loader_obj("N"); fn_afterSave(1, code, msg); }
function mySheet2_OnSaveEnd(code, msg, stCode) { loader_obj("N"); fn_afterSave(2, code, msg); }
function mySheet3_OnSaveEnd(code, msg, stCode) { loader_obj("N"); fn_afterSave(3, code, msg); }
function mySheet4_OnSaveEnd(code, msg, stCode) { loader_obj("N"); fn_afterSave(4, code, msg); }
function mySheet5_OnSaveEnd(code, msg, stCode) { loader_obj("N"); fn_afterSave(5, code, msg); }

function fn_afterSave(idx, code, msg) {
	if (msg) alert(msg);
	if (code >= 0) fn_search(idx);
}

// 조회 후처리 — 모든 탭에 loader_obj("N") 호출 필수 (kepSearch 가 시작 시 loader_obj("Y") 호출하므로)
// 탭2~5 는 추가 로직 없이 loader 만 닫기, 탭1(도착지)은 TEXT4/TEXT2 분해 추가 처리
function mySheet2_OnSearchEnd(code, msg, stCode) { loader_obj("N"); }
function mySheet3_OnSearchEnd(code, msg, stCode) { loader_obj("N"); 
//가능 : 발주권한이 있는 부서<br/>불가능 : 발주 권한이 없는 부서
mySheet3.SetToolTipText(0,"DEPT_TYPE_TEXT","<%=CommonLang.get("HTITLE1465")%>"); 
}
function mySheet4_OnSearchEnd(code, msg, stCode) { loader_obj("N"); }
function mySheet5_OnSearchEnd(code, msg, stCode) { loader_obj("N"); }

// 도착지 조회 결과 후처리 — TEXT4(@ 구분) 또는 TEXT2(공백 구분)에서 ZIP/ADDR 분해
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	for (var i = 1; i <= mySheet1.RowCount(); i++) {
		var t4 = (mySheet1.GetCellValue(i, "TEXT4") + "") || "";
		var t2 = (mySheet1.GetCellValue(i, "TEXT2") + "") || "";
		if (t4) {
			var arr = t4.split("@");
			mySheet1.SetCellValue(i, "ZIP_CODE",  arr[0] || "");
			mySheet1.SetCellValue(i, "ADDRESS01", arr[1] || "");
			mySheet1.SetCellValue(i, "ADDRESS02", arr[2] || "");
		} else if (t2) {
			var chk = t2.substring(5, 6);
			if (chk == " ") {
				mySheet1.SetCellValue(i, "ZIP_CODE",  t2.substring(0, 5));
				mySheet1.SetCellValue(i, "ADDRESS01", t2.substring(6));
			} else {
				mySheet1.SetCellValue(i, "ZIP_CODE",  t2.substring(0, 7));
				mySheet1.SetCellValue(i, "ADDRESS01", t2.substring(8));
			}
		}
	}
}

// 우편번호 팝업 호출
function fn_openZipPopup() {
	openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481");
}

// 우편번호 팝업 콜백 — newZipCodeSearchPop.jsp 가 호출
function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn) {
	if (!grbRow1) return;
	mySheet1.SetCellValue(grbRow1, "ZIP_CODE",  (zipNo || "").replace(/[^0-9]/g, ""));
	mySheet1.SetCellValue(grbRow1, "TEXT3",     bdMgtSn || "");
	mySheet1.SetCellValue(grbRow1, "ADDRESS01", (roadAddrPart1 || "") + " " + (roadAddrPart2 || ""));
	mySheet1.SetCellValue(grbRow1, "ADDRESS02", addrDetail || "");
}
</script>
</body>
</html>
