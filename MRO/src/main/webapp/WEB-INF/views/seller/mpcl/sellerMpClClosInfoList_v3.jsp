<%--
**********************************************
* 메뉴 : 정산관리
* 화면 : 정산관리 마더
* 기능 :  
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-09-22
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.JSONObject"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../../common/include/head_v2.jspf" %>

<!-- DetailViewPopup 라이브러리 -->
<script src="/resources/js/layerpopup/detailViewPopup.js" type="text/javascript"></script>

<!-- IBSheet 래퍼 (IBSheet 로드 후에 와야 함) -->
<script src="/resources/js/common/IBSheetWrapper.js" type="text/javascript"></script>

<!-- 탭 매니저 (클로저 패턴 모듈 관리) -->
<script src="/resources/js/common/TabManager.js" type="text/javascript"></script>

<!-- DatePicker 클래스 (MonthNew.js 기반 자체 구현) -->
<script src="/resources/js/DatePicker.js" type="text/javascript"></script>

</head>


<body>
<div id="wrapper"> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader_sub_v2"/>
<c:param name="part" value="header_v2"/>
</c:import>
<c:import charEncoding="utf-8" url="/main/leftMenuData.do">
<c:param name="page" value="sellerLeft_v2"/>
</c:import>


	<!-- 컨텐츠 -->
	<div class="containerBoxSub" >
	  
    <div class="PDleft50"><!--padding-left:50px; 시작 -->    
		<div class="SubTit">
      <div class="But_Star_on"></div> 마감관리
      <div class="SummaryGuide">
        <ul>
          <li><img src="/resources/imgs/Icon_Home.png" /></li>
          <li>마감관리</li>
        </ul>
      </div>
    </div>
    <div class="SubSearchTab">


      <button class="TabTit" data-tab="Search2">마감내역(계산서별)</button>
      <button class="TabTit" data-tab="Search1">마감내역(품목별)</button>
      <button class="TabTit" data-tab="Search4">물류비발행내역</button>
      <button class="TabTit" data-tab="Search3">미마감내역</button>
      <button class="TabTit" data-tab="Search5">마감현황</button>

    </div>
    
    <!-- 탭1: 마감내역(계산서별) -->
    <jsp:include page="tabs/sellerMpClClosInfo_tab1.jsp" />

    <!-- 탭2: 마감내역(품목별) -->
    <jsp:include page="tabs/sellerMpClClosInfo_tab2.jsp" />

	<!-- 탭3: 물류비발행내역 -->
    <jsp:include page="tabs/sellerMpClClosInfo_tab3_v3.jsp" />

	<!-- 탭4: 미마감내역 -->
    <jsp:include page="tabs/sellerMpClClosInfo_tab4_v3.jsp" />

	<!-- 탭5: 마감현황 -->
    <jsp:include page="tabs/sellerMpClClosInfo_tab5_v3.jsp" />

		</div> <!--padding-left:50px; 끝 -->
    </div><!--containerBoxSub-->
  </div><!--id="Search1" 전체 끝 -->   
     <div class="h5" style="height: 50px;"></div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter_sub_v2.jsp" %>

<!-- 통합 스크립트 -->
<script type="text/javascript">
$(document).ready(function() {
    // =========================
    // 1. TabManager 초기화
    // =========================
    
    // 공통 데이터 설정
    MRO.TabManager.setCommonData('sessionComCode', "${sessionInfo.comCode}");
    MRO.TabManager.setCommonData('sessionUserId', "${sessionInfo.userId}");
    
    // 모든 모듈 초기화
    MRO.TabManager.initAll();
    
    // 탭 이벤트 초기화 (기본 탭 자동 활성화 포함)
    MRO.TabManager.setDefaultTab('tab2');

    // 탭 전환 콜백 등록 (이 화면에서만)
    MRO.TabManager.setTabSwitchCallback(function(fromTab, toTab) {
		console.log('fromTab : '+fromTab)
		console.log('toTab : '+toTab)
    });


    
});


</script>

</body>
</html>