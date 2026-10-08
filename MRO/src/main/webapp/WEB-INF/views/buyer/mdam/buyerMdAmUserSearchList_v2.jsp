<%--
**********************************************
* 메뉴 : 관리자설정관리 > 사용자관리
* 화면 : 사용자관리 (리뉴얼 v2 통합 화면)
* 기능 : 4개 탭(전체/승인완료/승인대기/승인거절) 구성
*        레거시 2개 화면 통합:
*          - buyerMdAmUserSearchList.jsp (PG_01_B_002_00)
*          - buyerMdAmUserRegRequestReceiptList.jsp (PG_01_B_003_00)
* 프로그램 ID : BU0A01001 (신규)
* 착수일 : 2026-04-22
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
<script src="/resources/js/common/HttpUtil.js" type="text/javascript"></script>
<script src="/resources/js/common/PopupUtil.js" type="text/javascript"></script>																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																		
</head>
<%
// 그리드 데이터는 IBSheet 가 클라이언트에서 비동기 적재. JSP 시점에 _gridList 사용 안 함.

String com_code = CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());

// TGCM(계열사 통합 관리) 권한 보유 여부 → SQL <choose> 분기 결정용 group_mng_flag
// 미설정 시 SQL의 COM_CODE 필터가 통째로 빠져 ICOMLUSR 전체 행이 반환되므로 필수
// 레거시 buyerMdAmUserSearchList.jsp:43-47 동일 로직
String SessionUserId = _sessionInfo.getUserId();
boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", SessionUserId, com_code);
String group_mng_flag = getCodeTGCM ? "Y" : "N";

// 현재 활성 탭 (ALL / APPROVED / PENDING / REJECTED)
String st_tab = CommonUtil.nvl((String) request.getParameter("st_tab"), "ALL");

// 검색조건
String st_search_user_name = CommonUtil.nvl((String) request.getParameter("st_search_user_name"), "");
String st_btoa_user_dept_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_name"), "");

// 사용자 유형: "A"=관리자만 승인/거절 가능 (레거시 buyerMdAmUserRegRequestReceiptList.jsp:377 동일)
// 화면 자체 접근 제한은 메뉴 권한(myMenuList)에서 처리되므로 여기서는 별도 체크 없음 (레거시와 동일)
String user_type = _sessionInfo.getUserType();
boolean isAdmin = "A".equals(user_type);

// 메뉴 ID 및 즐겨찾기 flag 처리 (타 _v2 파일과 동일 패턴 — head_v2.jspf가 myMenuListHeader 세팅)
String menuId = CommonUtil.nvl((String) request.getParameter("menuId"), "");
if (myMenuListHeader != null) {
	for (int i = 0; i < myMenuListHeader.size(); i++) {
		if (myMenuListHeader.get(i).get("MENU_ID").equals(menuId)) {
			myMenuFlag = true;
			break;
		}
	}
}

// 탭 권한 데이터 처리 (selectMenuTabInfo_v2 SQL 결과를 Controller가 tab_data로 전달)
// - SQL 반환 컬럼: MENUID, MENU_JSP(=MENU.URL), MENU_BUTTON(=MENU.MENU_DC), ROLEID, MENU_ORDER
// - MENU_BUTTON에는 완전한 <button> HTML이 저장됨 (buyerMdAmBudgetInfo_v2.jsp:86 동일 컨벤션)
// - 권한 필터링은 selectMenuTabInfo_v2가 처리 (KX_MENUAUTH/KX_USERAUTH + KX_MENUINFO.ROLE_ID/KX_USERROLE)
@SuppressWarnings("unchecked")
List<Map<String,String>> _tabData = (List<Map<String,String>>) request.getAttribute("tab_data");
Set<String> _allowedTabs = new LinkedHashSet<String>();
if (_tabData != null) {
	// MENU_BUTTON HTML에서 data-tab 속성 추출 → 허용 탭 식별자 Set 구성
	java.util.regex.Pattern _tabPattern = java.util.regex.Pattern.compile("data-tab=[\"']([^\"']+)[\"']");
	for (Map<String,String> t : _tabData) {
		String html = CommonUtil.nvl(t.get("MENU_BUTTON"));
		if ("".equals(html)) continue;
		java.util.regex.Matcher m = _tabPattern.matcher(html);
		if (m.find()) _allowedTabs.add(m.group(1));
	}
}
// 요청 탭이 허용 범위 밖이면 첫 허용 탭으로 보정 (권한 없는 탭 직접 접근 차단)
if (!_allowedTabs.isEmpty() && !_allowedTabs.contains(st_tab)) {
	st_tab = _allowedTabs.iterator().next();
}

String legacyName = CommonUtil.getSpecialCheckReturn(com_code,"P01-1010-05","COL01_DATA", request); // 고객사별 사번 라벨명
if(legacyName == null){
	legacyName = CommonLang.get("HTITLE454");	//사번
}else if("".equals(legacyName)){
	legacyName = CommonLang.get("HTITLE454");	//사번
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
		<%=CommonLang.get("HTITLE1316")%><!--사용자관리-->
		<% if (myMenuFlag) { %>
			<button class="But_Star_on"></button>
		<% } else { %>
			<button class="But_Star_off"></button>
		<% } %>
		<div class="SubPageGuide">
			<ul>
				<li><img src="/resources/imgs/Icon_Home.png" /></li>
				<li><%=CommonLang.get("HTITLE1126")%><!--관리자설정관리--></li>
				<li><%=CommonLang.get("HTITLE1316")%><!--사용자관리--></li>
			</ul>
		</div>
	</div>

	<div class="container">
		<div class="SubSearchTab">
		<% if (_tabData != null && !_tabData.isEmpty()) {
			for (int i = 0; i < _tabData.size(); i++) { %>
			<%=_tabData.get(i).get("MENU_BUTTON") %>
		<%	}
		} else { %>
			<%-- Fallback: tab_data 비어있을 때 기본 탭 (DB 미등록/권한 없음 대응) --%>
			<button type="button" class="TabTit" data-tab="ALL"><%=CommonLang.get("HTITLE29")%><!--전체--></button>
			<button type="button" class="TabTit" data-tab="APPROVED"><%=CommonLang.get("HTITLE1317")%><!--승인완료--></button>
			<button type="button" class="TabTit" data-tab="PENDING"><%=CommonLang.get("HTITLE1318")%><!--승인대기--></button>
			<button type="button" class="TabTit" data-tab="REJECTED"><%=CommonLang.get("HTITLE1319")%><!--승인거절--></button>
		<% } %>
		</div>

		<!-- 화면 안내 문구 (탭 전환 시 fn_renderImportanceRow 가 텍스트 갱신) -->
		<!-- mt10: 소스 buyerWmGrClosing_tab1.jsp:132 의 부모 .SearchContent(padding-top:10px) 시각 간격 보정 -->
		<div class="Importance mt10" id="importanceRow"><img src="/resources/imgs/Icon_Importance.png" />
			<span id="importanceRowText"></span>
		</div>

		<!-- 검색 영역 (4개 탭 공통) -->
		<form name="searchForm" id="searchForm" method="post"z>
			<input type="hidden" name="s_SAVENAME" />
			<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>" />
			<input type="hidden" name="menuId" id="menuId" value="<%=menuId%>" />
			<input type="hidden" name="st_tab" id="st_tab" value="<%=st_tab%>" />
			<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}" />
			<input type="hidden" name="st_del_yn" id="st_del_yn" value="N" />
			<input type="hidden" name="st_buyer_select" id="st_buyer_select" value="" />
			<input type="hidden" name="st_group_info" id="st_group_info" value="" />
			<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=group_mng_flag%>" />

			<table class="TabSearchTable" style="margin-top:10px;">
			<%if(group_mng_flag.equals("Y")){%>
				<colgroup>
					<col width="70px" />
					<col width="330px" />
					<col width="80px" />
					<col width="400px" />
					<col width="80px" />
					<col width="300px" />
				</colgroup>
				<tr>
					<th><%=CommonLang.get("HTITLE325")%><!--이름--></th>
					<td><input class="input40" style="width:170px" type="text" name="st_search_user_name" id="st_search_user_name" value="<%=st_search_user_name%>" onkeydown="if(event.keyCode==13){fn_search(1);return false;}" /></td>
					<th><%=CommonLang.get("HTITLE323")%><!--부서명--></th>
					<td><input class="input40" style="width:270px" type="text" name="st_btoa_user_dept_name" id="st_btoa_user_dept_name" value="<%=st_btoa_user_dept_name%>" onkeydown="if(event.keyCode==13){fn_search(1);return false;}" /></td>
					<th><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
					<td>
					        <select name="st_com_code" id="st_com_code"  class="Select40" style="width:90%;">
					        	<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TGCM",_sessionInfo.getUserId(), "ICOMCOD3", com_code, "") %>
					        </select>
				      	</td>
				</tr>
			<%}else{ %>
				<colgroup>
					<col width="70px" />
					<col width="630px" />
					<col width="80px" />
					<col width="500px" />
				</colgroup>
				<tr>
					<th><%=CommonLang.get("HTITLE325")%><!--이름--></th>
					<td><input class="input40" style="width:470px" type="text" name="st_search_user_name" id="st_search_user_name" value="<%=st_search_user_name%>" onkeydown="if(event.keyCode==13){fn_search(1);return false;}" /></td>
					<th><%=CommonLang.get("HTITLE323")%><!--부서명--></th>
					<td><input class="input40" style="width:470px" type="text" name="st_btoa_user_dept_name" id="st_btoa_user_dept_name" value="<%=st_btoa_user_dept_name%>" onkeydown="if(event.keyCode==13){fn_search(1);return false;}" /></td>
				</tr>
				<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}" />
			<%} %>
			</table>
			<div class="SearchBtnBox">
				<button type="button" class="ButOutline_Medium" onclick="fn_reset()"><%=CommonLang.get("HTITLE8")%><!--초기화--></button>
				<button type="button" class="ButDarkGray_Medium" onclick="fn_search(1)"><%=CommonLang.get("HTITLE7")%><!--조회--></button>
			</div>
		</form>

		<!-- 액션 버튼 영역 (총 건수는 IBSheet SetCountFormat 가 그리드 하단에 자동 표시) -->
		<div class="ArraySub mt30 mb10">
			<div class="buttonRight" id="actionBtnBox">
				<%-- 탭별 액션 버튼은 fn_renderActionButtons()에서 렌더링 --%>
			</div>
		</div>

		<%-- 저장(삭제/승인/거절) 액션용 form (검색 form 은 위쪽 #searchForm 을 그대로 kepSearch_v2 인자로 사용) --%>
		<form name="contentForm" id="contentForm" method="post">
			<input type="hidden" name="st_user_id" value="${sessionInfo.userId}" />
			<input type="hidden" name="st_com_code" value="${sessionInfo.comCode}" />
			<input type="hidden" name="st_checked_id" id="st_checked_id" value="" />
			<input type="hidden" name="st_status" id="st_status" value="" />
			<input type="hidden" name="st_reject_reason" id="st_reject_reason" value="" />
		</form>

		<div class="IBSheetBuyer">
			<script type="text/javascript">
				createIBSheet("mySheet1", "", "100%");
			</script>
		</div><!-- IBSheetBuyer 끝 -->

		<div class="h50"></div>
	</div><!-- container -->
</div><!-- container2 -->
<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>
</div><!-- wrapper -->

<script type="text/javascript">
// mySheet1 은 body 의 createIBSheet("mySheet1", ...) 호출이 window 전역에 실제 IBSheet 인스턴스로 생성.
// 여기서 `var mySheet1 = new ibsheetObject();` 를 추가하면 그 실제 인스턴스를 stub 으로 덮어쓰게 되므로 절대 금지.
var pagingMode = "N";  // smLazyLoad — MpSo / mdam Budget 와 동일
var popupSel = "";
var currentTab = "<%=st_tab%>";
var currentUserType = "<%=user_type%>";
// 관리자 권한 플래그: 레거시 buyerMdAmUserRegRequestReceiptList.jsp:377의 "A".equals(user_type) 체크와 동일
var isAdmin = <%= isAdmin ? "true" : "false" %>;

// 허용 탭 목록 (selectMenuTabInfo_v2 결과 — 사용자 권한에 따라 일부 탭만 포함)
// Fallback: tab_data 비어있으면 4개 모두 허용 (DB 미등록 시 임시 대응)
var allowedTabs = [<%
	if (_allowedTabs.isEmpty()) {
		out.print("\"ALL\",\"APPROVED\",\"PENDING\",\"REJECTED\"");
	} else {
		boolean _first = true;
		for (String _k : _allowedTabs) {
			if (!_first) out.print(",");
			out.print("\"" + _k + "\"");
			_first = false;
		}
	}
%>];

$(function() {
	var initsheet1 = {};
	// CountPosition:3 → 그리드 하단 "총 N 건" 캡션 위치 (MpSo tab1:67 동일)
	initsheet1.Cfg = {MergeSheet:msHeaderOnly, HeaderRowHeight:50, DataRowHeight:30, Alternate:0, UseNoDataRow:1};
	// 컬럼 폭 합계 = 50+100+200+180+280+180+290 = 1280px (.container 1280px 와 일치)
	initsheet1.Cols = [
		// 첫 컬럼은 sentinel(IBS_InitSheet 의 Cols[0].Header 검사 통과용) — buyerMdAmBudgetInfo_tab1.jsp:37 동일 컨벤션
		{ Type:"Status",     SaveName:"sStatus",       Header:"<%=CommonLang.get("HTITLE255")%>",   Width:60,  Align:"Center", Edit:false, Hidden:true }, /*상태*/
		{ Type:"DummyCheck", SaveName:"SELECTED",      Header:"",       Width:50,  Align:"Center", Edit:true },
		{ Type:"Text",       SaveName:"STATUS_TEXT",   Header:"<%=CommonLang.get("HTITLE255")%>",     Width:100, Align:"Center", Edit:false }, /*상태*/
		{ Type:"Text",       SaveName:"COM_NAME_LOC",    Header:"<%=CommonLang.get("HTITLE291")%>",      Width:100, Align:"Left", Hidden:true, Edit:false }, /*고객사명*/
		{ Type:"Text",       SaveName:"USER_ID",       Header:"<%=CommonLang.get("HTITLE324")%>",       Width:200, Align:"Left",   Edit:false, FontColor:"#3a72c7", Cursor:"Pointer" }, /*ID*/
		{ Type:"Text",       SaveName:"USER_NAME_LOC", Header:"<%=CommonLang.get("HTITLE325")%>",     Width:180, Align:"Left",   Edit:false }, /*이름*/
		{ Type:"Text",       SaveName:"DEPT_NAME",     Header:"<%=CommonLang.get("HTITLE323")%>",   Width:280, Align:"Left",   Edit:false }, /*부서명*/
		{ Type:"Text",       SaveName:"PHONE_NUMBER",  Header:"<%=CommonLang.get("HTITLE326")%>", Width:180, Align:"Left",   Edit:false }, /*전화번호*/
		{ Type:"Text",       SaveName:"EMAIL",         Header:"<%=CommonLang.get("HTITLE41")%>",   Width:290, Align:"Left",   Edit:false }, /*이메일*/
		{ Type:"Text",       SaveName:"CONFIRM_USER_NAME",  Header:"<%=CommonLang.get("HTITLE1509")%>", Width:100, Align:"Left",   Edit:false, Hidden:true }, /*처리자*/
		{ Type:"Text",       SaveName:"REJECT_REASON",  Header:"<%=CommonLang.get("HTITLE1510")%>", Width:120, Align:"Left",   Edit:false,Hidden:true }, /*거절사유*/
		{ Type:"Text",       SaveName:"COM_CODE",      Header:"COM_CODE",      Hidden:true },
		{ Type:"Text",       SaveName:"USER_ID_RAW",   Header:"USER_ID_RAW",   Hidden:true },
		{ Type:"Text",       SaveName:"STATUS",        Header:"STATUS",        Hidden:true },
		{ Type:"Text",       SaveName:"CONFIRM_USER_NAME_RAW",  Header:"<%=CommonLang.get("HTITLE1509")%>", Width:100, Align:"Left",   Edit:false, Hidden:true }, /*처리자*/
	];
	IBS_InitSheet(mySheet1, initsheet1, pagingMode);
	mySheet1.SetHeaderBackColor("#f2f7ff");
	mySheet1.SetTheme("DB", "DeepBlue");

	// 초기 활성 탭 표시
	$(".TabTit").removeClass("active");
	$(".TabTit[data-tab='" + currentTab + "']").addClass("active");
	fn_renderActionButtons(currentTab);
	fn_renderImportanceRow(currentTab);
	fn_applyCheckColumnLayout(currentTab);

	$(document).on("click", ".SubSearchTab .TabTit[data-tab]", function() {
		var tab = $(this).attr("data-tab");
		if (tab) fn_switchTab(tab);
	});

	// 최초 진입 시 자동 조회
	fn_search(1);
});

// 탭 전환 — 권한 가드 포함
function fn_switchTab(tab) {
	if (allowedTabs.indexOf(tab) < 0) {
		alert("<%=CommonLang.msg("MSG819")%>"); /*접근 권한이 없는 탭입니다.*/
		return;
	}
	$(".TabTit").removeClass("active");
	$(".TabTit[data-tab='" + tab + "']").addClass("active");
	currentTab = tab;
	$("#st_tab").val(tab);
	fn_renderActionButtons(tab);
	fn_renderImportanceRow(tab);
	fn_applyCheckColumnLayout(tab);
	fn_search(1);
}

// 탭별 안내 문구 갱신 (.ImportanceRow)
function fn_renderImportanceRow(tab) {
	var msg = "";
	switch (tab) {
		case "ALL":
			//사이트를 이용 중인 사용자 계정을 조회하고 가입 승인 상태를 관리할 수 있으며, ID를 클릭하면 상세 정보를 확인하거나 수정할 수 있습니다.
			msg = "<%=CommonLang.msg("MSG836")%>";
			break;
		case "APPROVED":
			//승인이 완료된 사용자 계정을 조회할 수 있으며, ID를 클릭해 정보를 수정하거나 계정을 삭제할 수 있습니다.
			msg = "<%=CommonLang.msg("MSG837")%>";
			break;
		case "PENDING":
			//승인을 기다리는 사용자 계정을 조회할 수 있으며, 체크박스 선택 후 승인 또는 거절 처리를 할 수 있습니다.
			msg = "<%=CommonLang.msg("MSG838")%>";
			break;
		case "REJECTED":
			//승인이 거절된 사용자 계정을 조회할 수 있으며, 체크박스 선택 후 재승인 처리를 할 수 있습니다.
			msg = "<%=CommonLang.msg("MSG839")%>";
			break;
	}
	$("#importanceRowText").text(msg);
	$("#importanceRow").toggle(msg !== "");
}

// 체크박스 컬럼(50px) 노출/숨김 시 EMAIL 컬럼 폭으로 50px 흡수 → 항상 컨테이너 1280px 와 일치
function fn_applyCheckColumnLayout(tab) {
	var hide = (tab === "ALL" || allowedTabs.indexOf(tab) < 0);
	var hide2 = (tab != "REJECTED"); //승인거절 탭만 컬럼 노출
	mySheet1.SetColHidden("SELECTED", hide);
	mySheet1.SetColWidth("EMAIL", hide ? 340 : 290); // 290 + 50 = 340
	
	mySheet1.SetColHidden("CONFIRM_USER_NAME",hide2);
	mySheet1.SetColHidden("REJECT_REASON",hide2);
}

// 조회 — IBSheet AJAX 호출 (kepSearch_v2 → DoSearch → JSON 응답을 IBSheet 가 적재)
function fn_search(curPage) {
	var url = null;
	$("#st_buyer_select").val($("#st_com_code").val());
	switch (currentTab) {
		case "ALL":
			url = "/mdam/getBuyerMdAmUserSearchList_v2.do";
			$("#st_del_yn").val("Y");
			break;
		case "APPROVED":
			url = "/mdam/getBuyerMdAmUserSearchList_v2.do";
			$("#st_del_yn").val("N"); // STATUS='C' 위주
			break;
		case "PENDING":
			url = "/mdam/getBuyerMdAmUserRegRequestReceiptList_v2.do";
			break;
		case "REJECTED":
			url = "/mdam/getBuyerMdAmUserRegRequestReceiptList_v2.do";
			break;
	}
	if (!url) { mySheet1.RemoveAll(); return; }
	kepSearch_v2(document.searchForm, mySheet1, url + "?page=" + curPage, pagingMode);
}

// 초기화
function fn_reset() {
	$("#st_search_user_name").val("");
	$("#st_btoa_user_dept_name").val("");
	fn_search(1);
}

// 삭제 (승인완료 탭)
function fn_delete() {
	var ids = fn_getCheckedIds();
	if (ids.length === 0) { alert("<%=CommonLang.msg("MSG821")%>"); return; } /*삭제할 사용자를 선택하여 주십시오.*/
	if (!confirm("<%=CommonLang.get("HTITLE921")%> " + ids.length + "<%=CommonLang.msg("MSG831")%>\n<%=CommonLang.msg("MSG830")%>")) return;
	var plainIds = [];
	for (var i = 0; i < ids.length; i++) plainIds.push(ids[i].split("@@")[0]);
	$("#st_checked_id").val(plainIds.join("|") + "|");
	$("#st_status").val("D");
	jQuery.ajax({
		url: "/mdam/saveBuyerMdAmUserSearchList.do",
		type: "POST",
		data: $("#contentForm").serialize(),
		dataType: "json",
		success: function(res) {
			if (res && res.msg === "OK") {
				alert("<%=CommonLang.msg("MSG824")%>"); /*삭제가 완료되었습니다.*/
				fn_search(1);
			} else {
				alert("<%=CommonLang.msg("MSG840")%>\n<%=CommonLang.msg("MSG393")%>"); /*삭제가 실패하였습니다. + 담당자에게 전화해 주십시오.*/
			}
		},
		error: function() {
			alert("<%=CommonLang.msg("MSG833")%>"); /*삭제 처리 중 오류가 발생했습니다.*/
		}
	});
}

// 승인 (승인대기/승인거절 탭 공통) — 관리자("A") 전용
function fn_confirm() {
	if (!isAdmin) { alert("<%=CommonLang.msg("MSG820")%>"); return; } /*권한이 없습니다.*/
	var ids = fn_getCheckedIds();
	if (ids.length === 0) { alert("<%=CommonLang.msg("MSG822")%>"); return; } /*승인할 사용자를 선택하여 주십시오.*/
	if (!confirm("<%=CommonLang.get("HTITLE921")%> " + ids.length + "<%=CommonLang.msg("MSG832")%>")) return;
	$("#st_checked_id").val(ids.join("|") + "|");
	$("#st_status").val("C");
	jQuery.ajax({
		url: "/mdam/saveBuyerMdAmUserRegRequestReceiptList.do",
		type: "POST",
		data: $("#contentForm").serialize(),
		dataType: "json",
		success: function(res) {
			if (res && res.msg === "OK") {
				alert("<%=CommonLang.msg("MSG825")%>"); /*승인완료 처리 되었습니다.*/
				fn_search(1);
			} else {
				alert("<%=CommonLang.msg("MSG826")%>\n<%=CommonLang.msg("MSG393")%>"); /*승인이 실패하였습니다. + 담당자에게 전화해 주십시오.*/
			}
		},
		error: function() {
			alert("<%=CommonLang.msg("MSG834")%>"); /*승인 처리 중 오류가 발생했습니다.*/
		}
	});
}

// 거절 (승인대기 탭) — 거절사유 PopupUtil 레이어 팝업 — 관리자("A") 전용. 다중 일괄 거절 지원.
function fn_reject() {
	if (!isAdmin) { alert("<%=CommonLang.msg("MSG820")%>"); return; } /*권한이 없습니다.*/
	var ids = fn_getCheckedIds();
	if (ids.length === 0) { alert("<%=CommonLang.msg("MSG823")%>"); return; } /*거절할 사용자를 선택하여 주십시오.*/
	if (ids.length > 1) { alert("<%=CommonLang.msg("MSG265")%>"); return; } /*사용자 거절은 한명씩만 가능합니다.*/
	$("#st_checked_id").val(ids.join("|") + "|");
	fn_openPopup("reject", ids.length);
}

// 팝업 호출
function fn_openPopup(type, val, val1) {
	popupSel = type;
	switch (type) {
		case "userDetail": // BU1001002 사용자 상세조회 — PopupUtil 레이어 팝업
			var legacyName = "<%=legacyName%>";
			PopupUtil.open({
				url: PopupUtil.POPUP_URLS.BUYER_USER_DETAIL,
				data: { userId: val, comCode: val1, legacyName: legacyName},
				onInit: function(api) {
					api.onSaved(function() { fn_search(1); });
				}
			});
			break;
		case "reject": // BU1001003 거절사유 입력 — PopupUtil 레이어 팝업
			PopupUtil.open({
				url: PopupUtil.POPUP_URLS.REJECT_REASON,
				data: { selectedCount: val }, // 팝업 상단 "총 N건 선택" 표시 (val = ids.length)
				onInit: function(api) {
					api.onConfirm(function(reason) { // '등록' 클릭 + 빈값 검증 통과 시 호출
						fn_doReject(reason);
					});
				}
			});
			break;
	}
}

// 거절 처리 제출 — reject_reason 팝업의 onConfirm 콜백에서 호출 (사유 입력/검증은 팝업이 담당)
function fn_doReject(reason) {
	$("#st_reject_reason").val(reason);
	$("#st_status").val("D");
	jQuery.ajax({
		url: "/mdam/saveBuyerMdAmUserRegRequestReceiptList.do",
		type: "POST",
		data: $("#contentForm").serialize(),
		dataType: "json",
		success: function(res) {
			if (res && res.msg === "OK") {
				alert("<%=CommonLang.msg("MSG827")%>"); /*거절 처리되었습니다.*/
				fn_search(1);
			} else {
				alert("<%=CommonLang.msg("MSG828")%>"); /*거절이 실패하였습니다.*/
			}
		},
		error: function() {
			alert("<%=CommonLang.msg("MSG835")%>"); /*거절 처리 중 오류가 발생했습니다.*/
		}
	});
}

// 팝업 콜백 (레거시 표준) — 거절은 PopupUtil(onConfirm)로 전환됨
function setPopupReturn(code, text) {
	if (popupSel === "userDetail") {
		fn_search(1);
	}
}

// 체크된 ID 추출 — IBSheet 의 SELECTED(DummyCheck) 컬럼 기반
// USER_ID_RAW 는 마스킹 전 원본(키). update 쿼리가 마스킹된 값으로 매칭 실패하지 않도록 필수.
function fn_getCheckedIds() {
	var ids = [];
	var rows = mySheet1.FindCheckedRow("SELECTED");
	if (!rows) return ids;
	var arr = rows.split("|");
	for (var i = 0; i < arr.length; i++) {
		if (arr[i] === "" || arr[i] === undefined) continue;
		var uid = mySheet1.GetCellValue(arr[i], "USER_ID_RAW");
		var com = mySheet1.GetCellValue(arr[i], "COM_CODE");
		ids.push(uid + "@@" + com);
	}
	return ids;
}

// IBSheet 이벤트 핸들러 (legacy 명명규칙: <sheetName>_<EventName> 글로벌 함수)
// 검색 응답 적재 완료 — kepSearch_v2 가 켠 로딩바를 끔 (MpSo tab1:334-336 동일)
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if (typeof checkedSession === "function" && !checkedSession(stCode)) return;
	
	var st_group_mng_flag = $("#st_group_mng_flag").val();
	if(st_group_mng_flag == "Y"){
		mySheet1.SetColHidden("COM_NAME_LOC",false);
	}
	
	
	for(var i = 1; i<=mySheet1.RowCount(); i++){
		if(mySheet1.GetCellValue(i,"STATUS_TEXT") == "삭제"){
			mySheet1.SetCellFontColor(i, "USER_ID", "#000000");
			mySheet1.SetCellCursor(i, "USER_ID", "Default");
		}
		mySheet1.SetToolTipText(i,"CONFIRM_USER_NAME",mySheet1.GetCellValue(i,"CONFIRM_USER_NAME_RAW"));
	}
}

// ID 셀 클릭 → 사용자상세 팝업 (마스킹 전 원본 USER_ID_RAW 사용)
function mySheet1_OnClick(row, col) {
	if (row < 1) return;
	if (mySheet1.ColSaveName(col) === "USER_ID") {
		if(mySheet1.GetCellValue(row,"STATUS_TEXT") == "삭제"){
			return;
		}
		var rawId = mySheet1.GetCellValue(row, "USER_ID_RAW");
		var comCd = mySheet1.GetCellValue(row, "COM_CODE");
		fn_openPopup("userDetail", rawId, comCd);
	}
}

// 탭별 액션 버튼/체크박스 렌더링
// 권한 정책 (레거시 동일):
//   - [전체] 탭: 조회만 — 체크박스/버튼 없음
//   - [승인완료] 탭: 삭제 버튼 — 전체 사용자 노출 (레거시 buyerMdAmUserSearchList.jsp 동일)
//   - [승인대기]/[승인거절] 탭: 승인/거절 — 관리자(user_type='A')만 노출 (레거시 ReqReceiptList:377 동일)
function fn_renderActionButtons(tab) {
	var html = "";
	var showCheck = true;
	if (allowedTabs.indexOf(tab) < 0) {
		$("#actionBtnBox").html("");
		return;
	}
	switch (tab) {
		case "ALL":
			showCheck = false;
			break;
		case "APPROVED":
			html = '<button type="button" class="ButPrimary_Medium" onclick="fn_delete()"><%=CommonLang.get("HTITLE25")%></button>'; /*삭제*/
			break;
		case "PENDING":
			if (isAdmin) {
				html = '<button type="button" class="ButPrimary_Medium" onclick="fn_confirm()"><%=CommonLang.get("HTITLE321")%></button> ' /*승인*/
				     + '<button type="button" class="ButOutline_Medium" onclick="fn_reject()"><%=CommonLang.get("HTITLE320")%></button>'; /*거절*/
			}
			break;
		case "REJECTED":
			if (isAdmin) {
				html = '<button type="button" class="ButPrimary_Medium" onclick="fn_confirm()"><%=CommonLang.get("HTITLE321")%></button>'; /*승인*/
			}
			break;
	}
	$("#actionBtnBox").html(html);
}
</script>
</body>
</html>
