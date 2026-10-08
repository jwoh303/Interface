<%--
**********************************************
* 메뉴 : 고객센터
* 화면 : 고객센터 메인 (1:1 문의 / 공지사항 / 내부 공지사항)
* 기능 : 고객센터 탭 구조 부모 페이지
* 프로그램 ID : BU0900001
* 담당자 :
* 착수일 : 2026-04-13
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf" %>
<style>
/* 공지사항 본문 스타일 */
.notice-content { line-height:1.8; font-size:14px; color:#333; }
.notice-content h1, .notice-content h2, .notice-content h3 { color:#2172ec; margin:15px 0 10px; }
.notice-content h2 { font-size:18px; border-bottom:2px solid #2172ec; padding-bottom:8px; }
.notice-content table { width:100%; border-collapse:collapse; margin:12px 0; }
.notice-content table th, .notice-content table td { border:1px solid #ddd; padding:10px; text-align:left; font-size:14px; }
.notice-content table th { background:#f0f4ff; font-weight:600; width:120px; }
.notice-content table thead tr:first-child th,
.notice-content table thead tr:first-child td { background:#f0f4ff; }
.notice-content ul, .notice-content ol { padding-left:20px; margin:8px 0; }
.notice-content li { margin:4px 0; }
.notice-content strong { font-weight:700; }
.notice-content em { font-style:italic; }
.notice-content img { max-width:100%; height:auto; }
</style>
<!-- IBSheet postMessage 핸들러 보호: 비문자열 메시지 필터링 -->
<script type="text/javascript">window.addEventListener("message",function(e){if(typeof e.data!=="string"){e.stopImmediatePropagation();}},false);</script>

</head>
<%
String menuId = CommonUtil.nvl((String) request.getParameter("menuId"),"");
String tabIndex = CommonUtil.nvl((String) request.getParameter("tabIndex"),"1");

if(myMenuListHeader != null){
	for(int i = 0; i<myMenuListHeader.size(); i++){
		if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
			myMenuFlag = true;
			break;
		}
	}
}

String isAdmin = "N";
if (_sessionInfo != null) {
	String role = CommonUtil.nvl((String)_sessionInfo.getRole());
	if (role.indexOf("A") > -1 || role.indexOf("M") > -1) {
		isAdmin = "Y";
	}
}

String bycaComorgCode = "";
if (_sessionInfo != null) {
	bycaComorgCode = CommonUtil.nvl(_sessionInfo.getBycaComorgCode());
}
%>
<body>
<script>
var g_tabIndex = "<%=tabIndex%>";
var g_isAdmin = "<%=isAdmin%>";
var g_bycaComorgCode = "<%=bycaComorgCode%>";
var g_userId = "<%=_sessionInfo != null ? CommonUtil.nvl(_sessionInfo.getUserId()) : ""%>";

function kep_onload_view(){
	fn_tabChange(g_tabIndex);

	// 화면 진입 시 비활성 탭의 탭 제목 아이콘도 표시되도록 모든 탭 목록을 미리 로드한다.
	// 각 init은 *InitDone 가드로 1회만 로드되며(기본 탭은 fn_tabChange에서 이미 로드되어 중복 없음),
	// 렌더 직후 MROBuyerNoticeTabIndicator.refresh로 미확인 아이콘을 토글한다.
	if (typeof fn_inquiryInit === 'function') fn_inquiryInit();
	if (typeof fn_noticeInit === 'function') fn_noticeInit();
	if (typeof fn_internalNoticeInit === 'function') fn_internalNoticeInit();
}

function fn_tabChange(idx) {
	g_tabIndex = idx;
	// 탭 버튼 active 전환
	var tabs = document.querySelectorAll('.SVCTab > div');
	tabs.forEach(function(tab) {
		tab.style.borderBottom = '1px solid #2172ec';
		tab.style.backgroundColor = '';
		tab.style.color = '';
		tab.style.border = '';
	});
	var activeTab = tabs[parseInt(idx) - 1];
	if (activeTab) {
		activeTab.style.border = '1px solid #2172ec';
		activeTab.style.borderBottom = '0px solid #2172ec';
		activeTab.style.backgroundColor = '#fff';
		activeTab.style.color = '#2172ec';
	}

	// 컨텐츠 show/hide
	document.querySelectorAll('.SvcContent').forEach(function(el) {
		el.style.display = 'none';
	});
	var content = document.getElementById('SvcContent' + idx);
	if (content) {
		content.style.display = 'block';
	}

	// 탭별 초기 로드
	if (idx == '1' && typeof fn_inquiryInit === 'function') fn_inquiryInit();
	if (idx == '2' && typeof fn_noticeInit === 'function') fn_noticeInit();
	if (idx == '3' && typeof fn_internalNoticeInit === 'function') fn_internalNoticeInit();
}

// =========================
// 공지사항 탭 좌측 미확인 인디케이터 헬퍼
// 지정한 탭의 #SvcContentN 내부 .NoticeSub-item[data-read="N"] 존재 여부를 진실원으로
// .SVCTab > div 의 N번째 버튼 좌측(제목 앞)에 N 아이콘을 토글한다.
// 인자 미지정 시 기본 2(공지사항). tab2 호환성을 위해 기본값 유지.
// =========================
window.MROBuyerNoticeTabIndicator = (function() {
	var ICON_HTML = '<img src="/resources/imgs/seller_new.png" '
				  + 'class="tab-new-indicator" alt="N" '
				  + 'style="margin-right:5px;vertical-align:middle;" />';

	function refresh(tabIdx) {
		var idx = tabIdx || 2;
		var tabBtns = document.querySelectorAll('.SVCTab > div');
		var tabBtn = tabBtns[idx - 1];
		if (!tabBtn) return
		// 공통 [data-read="N"] 셀렉터 — NoticeSub-item(공지) / Chat-item(1:1 문의) 모두 포괄
		var hasUnread = document.querySelectorAll(
			'#SvcContent' + idx + ' [data-read="N"]').length > 0;

		var existing = tabBtn.querySelector('.tab-new-indicator');
		if (hasUnread && !existing) {
			tabBtn.insertAdjacentHTML('afterbegin', ICON_HTML);
		} else if (!hasUnread && existing) {
			existing.remove();
		}
	}

	return { refresh: refresh };
})();
</script>
<div id="wrapper">
	<c:import charEncoding="utf-8" url="/menu/menu.do">
		<c:param name="page" value="buyerHeader_v2"/>
		<c:param name="part" value="buyerHeader_v2"/>
	</c:import>
	<div id="container2">
		<div class="container">
			<!-- 고객센터 타이틀 영역 -->
			<div class="SVCTitBox mt30">
				<div class="SVCTit">고객센터</div>
			</div>

			<!-- 탭 버튼 -->
			<div class="SVCTab mt30">
				<div onclick="fn_tabChange('1')">1:1 문의</div>
				<div onclick="fn_tabChange('2')">공지사항</div>
				<div onclick="fn_tabChange('3')">내부 공지사항</div>
			</div>

			<!-- 탭1: 1:1 문의 -->
			<div id="SvcContent1" class="SvcContent" style="display:none;">
				<jsp:include page="buyerMcScCustomerCenter_tab1.jsp" />
			</div>

			<!-- 탭2: 공지사항 -->
			<div id="SvcContent2" class="SvcContent" style="display:none;">
				<jsp:include page="buyerMcScCustomerCenter_tab2.jsp" />
			</div>

			<!-- 탭3: 내부 공지사항 -->
			<div id="SvcContent3" class="SvcContent" style="display:none;">
				<jsp:include page="buyerMcScCustomerCenter_tab3.jsp" />
			</div>

			<div class="h80"></div>
		</div>
		<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>
	</div>
</div>
<script>
function fn_globalSearch() {
	// 현재 활성 탭에 따라 검색 수행
	var keyword = document.getElementById('searchInput').value.trim();
	if (!keyword) return;
	if (g_tabIndex == '2' && typeof fn_noticeSearch === 'function') fn_noticeSearch();
	if (g_tabIndex == '3' && typeof fn_internalNoticeSearch === 'function') fn_internalNoticeSearch();
}

// 페이지 하단: 모든 탭 JSP 파싱 완료 후 초기화 실행
kep_onload_view();
</script>
</body>
</html>
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																													