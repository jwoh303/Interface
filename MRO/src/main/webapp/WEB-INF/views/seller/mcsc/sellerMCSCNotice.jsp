<%--
**********************************************
* 메뉴 : 고객센터 > 공지사항,1:1문의, 자주묻는 질문
* 화면 : 협력사 공지사항 목록
* 기능 : TabManager 기반 탭 구현
* 프로그램 ID :
* 담당자 : 원지성
* 착수일 : 2014-09-03
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf" %>

<!-- 탭 매니저 (클로저 패턴 모듈 관리) -->
<script src="/resources/js/common/TabManager.js" type="text/javascript"></script>

<!-- HttpUtil (리뉴얼 - AJAX 유틸리티) -->
<script src="/resources/js/common/HttpUtil.js" type="text/javascript"></script>

<!-- DatePicker 관련 라이브러리 (tab2: 1:1문의에서 사용) -->
<script src="/resources/js/flatpickr.js" type="text/javascript"></script>
<script src="/resources/js/ko.js" type="text/javascript"></script>
<script src="/resources/js/DatePicker.js" type="text/javascript"></script>
</head>

<body>
<div id="wrapper">
<!-- 메뉴 S -->
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader_sub_v2"/>
<c:param name="part" value="header_v2"/>
</c:import>
<c:import charEncoding="utf-8" url="/main/leftMenuData.do">
<c:param name="page" value="sellerLeft_v2"/>
</c:import>

<!-- 컨텐츠 -->
<div class="containerBoxSub">
  <div class="PDleft50"><!--padding-left:50px; 시작 -->
    <div class="h30"></div>
    <div class="SVCTitBox">
      <div class="SVCTit">고객센터</div>
      <form class="SVCSearch" onsubmit="return false;">
        <input type="text" placeholder="전체 공지사항 검색" id="searchKeyword" style="width:75%;">
        <button type="button" id="searchButton">검색</button>
      </form>
      <%-- 기능 보류: 1:1 문의하기 버튼
      <button class="Butchat" id="main-inquiry-btn">1:1 문의하기</button>
      --%>
    </div>
    <div class="h20"></div>
    <div class="containerSub"><!--margin-right:50px; 설정 -->
      <div class="SVCTab SubSearchTab">
        <div class="TabTit" data-tab="Search1">전체 공지사항</div>
        <%-- 기능 보류: 1:1 문의 탭
        <div class="TabTit" data-tab="Search2">1:1 문의</div>
        --%>
        <div class="TabTit" data-tab="Search4">고객사별 공지사항</div>
        <div class="TabTit" data-tab="Search3">자주묻는 질문</div>
      </div>
		<div class="h20"></div>
      <!-- 탭1: 전체 공지사항 -->
      <jsp:include page="tabs/sellerMCSCNotice_tab3.jsp" />

      <%-- 기능 보류: 탭2 - 1:1 문의
      <jsp:include page="tabs/sellerMCSCNotice_tab2.jsp" />
      --%>

      <!-- 탭4: 고객사별 공지사항 -->
      <jsp:include page="tabs/sellerMCSCNotice_tab4.jsp" />

      <!-- 탭3: 자주묻는 질문 -->
      <jsp:include page="tabs/sellerMCSCNotice_tab1.jsp" />

      <div class="h50"></div>
    </div><!-- containerSub 끝 -->
  </div> <!--padding-left:50px; 끝 -->
</div><!--containerBoxSub-->

<!-- 통합 스크립트 -->
<script type="text/javascript">
// =========================
// TabManager 초기화
// =========================
document.addEventListener('DOMContentLoaded', function() {
    console.log('=== DOM 로드 완료 ===');

    // DOM 확인
    var tabButtons = document.querySelectorAll('.SubSearchTab .TabTit');
    var tabContainers = document.querySelectorAll('[id^="Search"]');
    console.log('탭 버튼 수:', tabButtons.length);
    console.log('탭 컨테이너 수:', tabContainers.length);

    tabButtons.forEach(function(btn) {
        console.log('버튼:', btn.dataset.tab, btn.textContent);
    });

    tabContainers.forEach(function(cont) {
        console.log('컨테이너:', cont.id);
    });

    // 공통 데이터 설정
    MRO.TabManager.setCommonData('sessionComCode', "${sessionInfo.comCode}");
    MRO.TabManager.setCommonData('sessionUserId', "${sessionInfo.userId}");

    // 탭 UI 스타일 적용 함수
    function applyTabStyle(activeTabName) {
        // 모든 탭 버튼의 스타일 초기화 (비활성)
        var tabButtons = document.querySelectorAll('.SubSearchTab .TabTit');
        tabButtons.forEach(function(button) {
            button.style.border = '';
            button.style.borderBottom = '1px solid #2172ec';
            button.style.backgroundColor = '';
            button.style.color = '';
        });

        // 활성 탭 스타일 적용
        var searchId = activeTabName.replace('tab', 'Search');
        var activeButton = document.querySelector('.SubSearchTab .TabTit[data-tab="' + searchId + '"]');
        if (activeButton) {
            activeButton.style.border = '1px solid #2172ec';
            activeButton.style.borderBottom = '0px solid #2172ec';
            activeButton.style.backgroundColor = '#fff';
            activeButton.style.color = '#2172ec';
        }
    }

    // 탭 클릭 이벤트 초기화
    MRO.TabManager.initTabClickEvents();

    // Controller에서 전달받은 탭 번호 (기본값: 1 - 공지사항)
    var defaultTab = '${defaultTab}' || '1';
    var menuId = '${menuId}' || 'null';
    console.log('===== 디버깅 =====');
    console.log('defaultTab:', defaultTab);
    console.log('menuId:', menuId);
    console.log('전환할 탭:', 'tab' + defaultTab);
    console.log('==================');

    // 기본 탭 설정
    MRO.TabManager.setDefaultTab('tab' + defaultTab);

    // 초기 탭 스타일 적용
    applyTabStyle('tab' + defaultTab);

    // 탭 전환 콜백 등록 (UI 스타일 적용 + placeholder 업데이트)
    MRO.TabManager.setTabSwitchCallback(function(fromTab, toTab) {
        console.log('탭 전환:', fromTab, '->', toTab);
        applyTabStyle(toTab);
        updateSearchPlaceholder(toTab);
        // 탭 전환 시 검색어 초기화
        document.getElementById('searchKeyword').value = '';
    });

    // 자동 확장 로직 - URL에서 bid, btype 파라미터가 있으면 해당 공지사항 자동 확장
    var autoExpandBid = '${bid}' || '';
    var autoExpandBtype = '${btype}' || '';

    if (autoExpandBid && autoExpandBtype && defaultTab === '1') {
        console.log('전체 공지사항 자동 확장 준비:', 'bid=' + autoExpandBid, 'btype=' + autoExpandBtype);

        // TabManager 초기화 및 목록 로드를 기다린 후 자동 확장
        setTimeout(function() {
            var tab1Module = MRO.TabManager.getModule('tab1');
            if (tab1Module && typeof tab1Module.autoExpandNotice === 'function') {
                console.log('tab1.autoExpandNotice 호출');
                tab1Module.autoExpandNotice(autoExpandBid, autoExpandBtype);
            } else {
                console.warn('tab1 모듈 또는 autoExpandNotice 함수를 찾을 수 없습니다.');
            }
        }, 500);
    }

    // 자동 확장 로직 - 고객사별 공지사항 (tab4)
    if (autoExpandBid && autoExpandBtype && defaultTab === '4') {
        console.log('고객사별 공지사항 자동 확장 준비:', 'bid=' + autoExpandBid, 'btype=' + autoExpandBtype);

        // TabManager 초기화 및 목록 로드를 기다린 후 자동 확장
        setTimeout(function() {
            var tab4Module = MRO.TabManager.getModule('tab4');
            if (tab4Module && typeof tab4Module.autoExpandNotice === 'function') {
                console.log('tab4.autoExpandNotice 호출');
                tab4Module.autoExpandNotice(autoExpandBid, autoExpandBtype);
            } else {
                console.warn('tab4 모듈 또는 autoExpandNotice 함수를 찾을 수 없습니다.');
            }
        }, 500);
    }

    // 자동 확장 로직 - FAQ
    var autoExpandFaqId = '${faqId}' || '';

    if (autoExpandFaqId && defaultTab === '3') {
        console.log('FAQ 자동 확장 준비:', 'faqId=' + autoExpandFaqId);

        // TabManager 초기화 및 목록 로드를 기다린 후 자동 확장
        setTimeout(function() {
            var tab3Module = MRO.TabManager.getModule('tab3');
            if (tab3Module && typeof tab3Module.autoExpandFAQ === 'function') {
                console.log('tab3.autoExpandFAQ 호출');
                tab3Module.autoExpandFAQ(autoExpandFaqId);
            } else {
                console.warn('tab3 모듈 또는 autoExpandFAQ 함수를 찾을 수 없습니다.');
            }
        }, 500);
    }

    // 검색창 placeholder 업데이트 함수
    function updateSearchPlaceholder(tabName) {
        var searchInput = document.getElementById('searchKeyword');
        if (!searchInput) return;

        // tabName은 'tab1', 'tab4', 'tab3' 형태
        if (tabName === 'tab1') {
            searchInput.placeholder = '전체 공지사항 검색';
        } else if (tabName === 'tab4') {
            searchInput.placeholder = '고객사별 공지사항 검색';
        } else if (tabName === 'tab3') {
            searchInput.placeholder = '자주묻는 질문 검색';
        }
    }

    // 검색 기능 (검색어가 비어있으면 전체 조회)
    function performSearch() {
        var keyword = document.getElementById('searchKeyword').value.trim();
        console.log('검색 키워드:', keyword || '(전체 조회)');

        // 현재 활성 탭 확인
        var activeTab = document.querySelector('.SubSearchTab .TabTit.active');
        var tabDataId = activeTab ? activeTab.getAttribute('data-tab') : 'Search1';
        console.log('현재 활성 탭 data-tab:', tabDataId);

        // data-tab (Search1, Search4, Search3) → TabManager 모듈명 (tab1, tab4, tab3) 매핑
        var moduleMap = {
            'Search1': 'tab1',  // 전체 공지사항
            'Search4': 'tab4',  // 고객사별 공지사항
            'Search3': 'tab3'   // 자주묻는 질문
        };
        var moduleName = moduleMap[tabDataId] || 'tab1';
        var tabModule = MRO.TabManager.getModule(moduleName);

        if (tabModule) {
            if (moduleName === 'tab3') {
                // 자주묻는 질문: 클라이언트 사이드 필터링 (기존 방식)
                if (typeof tabModule.performSearch === 'function') {
                    tabModule.performSearch(keyword);
                }
            } else {
                // 전체 공지사항, 고객사별 공지사항: 서버 API 검색
                if (typeof tabModule.search === 'function') {
                    tabModule.search(keyword);
                } else {
                    console.warn(moduleName + ' 모듈에 search 함수가 없습니다.');
                }
            }
        } else {
            console.warn('탭 모듈을 찾을 수 없습니다:', moduleName);
        }
        return false;
    }

    // 검색 버튼 클릭
    var searchBtn = document.getElementById('searchButton');
    if (searchBtn) {
        searchBtn.addEventListener('click', function(e) {
            e.preventDefault();
            performSearch();
        });
    }

    // 검색 입력창 엔터 키 처리
    var searchInput = document.getElementById('searchKeyword');
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter' || e.keyCode === 13) {
                e.preventDefault();
                performSearch();
            }
        });
    }

    // form submit 방지
    var searchForm = document.querySelector('.SVCSearch');
    if (searchForm) {
        searchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            performSearch();
            return false;
        });
    }

    /* 기능 보류: 1:1 문의하기 버튼 클릭 이벤트
    var mainInquiryBtn = document.getElementById('main-inquiry-btn');
    if (mainInquiryBtn) {
        mainInquiryBtn.addEventListener('click', function(e) {
            e.preventDefault();
            console.log('1:1 문의하기 버튼 클릭 - tab2로 이동');
            // 1:1 문의 탭으로 이동
            MRO.TabManager.switchTab('tab2');
            // 탭 전환 후 등록 화면 표시 (약간의 딜레이 후 실행)
            setTimeout(function() {
                var tab2Module = MRO.TabManager.getModule('tab2');
                if (tab2Module && typeof tab2Module.showFormView === 'function') {
                    tab2Module.showFormView();
                }
            }, 100);
        });
    }
    */
});
</script>

<%@ include file="/WEB-INF/views/common/include/sellerFooter_sub_v2.jsp" %>
</div><!-- warp 끝-->

</body>
</html>
