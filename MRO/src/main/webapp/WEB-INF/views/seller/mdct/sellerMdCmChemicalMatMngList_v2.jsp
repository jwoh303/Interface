<%--
**********************************************
* 메뉴 : 품목관리 > MSDS관리
* 화면 : MSDS관리 조회
* 기능 : 
* 프로그램 ID : SU0303001
* 파일명 : sellerMdCmChemicalMatMngList_v2.jsp
* 담당자 : 원지성
* 착수일 : 
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

<!-- DatePicker Calendar CSS -->
<link rel="stylesheet" href="/resources/css/month.css">

<!-- LayerPopup 라이브러리 -->
<link rel="stylesheet" href="/resources/css/layerPopup.css">
<link rel="stylesheet" href="/resources/css/customerSelectPopup.css">
<script src="/resources/js/layerpopup/layerPopup.js" type="text/javascript"></script>
<script src="/resources/js/layerpopup/customerSelectPopup.js" type="text/javascript"></script>
<script src="/resources/js/layerpopup/detailViewPopup.js" type="text/javascript"></script>

<!-- IBSheet 래퍼 (IBSheet 로드 후에 와야 함) -->
<script src="/resources/js/common/IBSheetWrapper.js" type="text/javascript"></script>
<!-- 탭 매니저 (클로저 패턴 모듈 관리) -->
<script src="/resources/js/common/TabManager.js" type="text/javascript"></script>
<!-- HttpUtil (리뉴얼 - AJAX 유틸리티) -->
<script src="/resources/js/common/HttpUtil.js" type="text/javascript"></script>
<!-- PopupUtil (리뉴얼 - 범용 팝업 유틸리티) -->
<script src="/resources/js/common/PopupUtil.js" type="text/javascript"></script>


<style type="text/css">

.DBCellButtonCustomBtn {
    height: 24px;
    line-height: 24px;
    width: 70px;
    font-size: 13px;
    font-weight: 400;
    letter-spacing: -0.2px;
    color: #1a5bbd;
    background-color: #f2f7ff;
    border: 1px solid #809fcf;
    border-radius: 4px;
    cursor: pointer;
    vertical-align: middle
}


</style>


</head>
<%
String menuId = (String) request.getParameter("menuId");

if(myMenuListHeader != null){ //null이 아닌 경우에만 체크
	for(int i = 0; i<myMenuListHeader.size(); i++){
		if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
			myMenuFlag = true;
			break;
		}
	}
}
%>
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
          <%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star"></button>
     	<%} %> MSDS 관리 
          <div class="SummaryGuide">
      	    <ul>
        	  <li><img src="/resources/imgs/Icon_Home.png" /></li>
              <li>품목관리</li>
              <li>MSDS 관리</li>
            </ul>
          </div>
        </div>
        <div class="SubSearchTab">
         <button class="TabTit active" data-tab="Search1">전체</button>
         <button class="TabTit" data-tab="Search2">MSDS 제출요청</button>
        </div>
        
    <!-- 탭1: 전체 -->
    <jsp:include page="tabs/sellerMdCmChemicalMatMngList_tab1.jsp" /> 
   
    <!-- 탭2: MSDS 제출요청 -->
    <jsp:include page="tabs/sellerMdCmChemicalMatMngList_tab2.jsp" />    
        

<!-- 통합 스크립트 -->
<script type="text/javascript">


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
    console.log('탭 전환 감지:', fromTab, '->', toTab);


});




</script>
      </div> <!--padding-left:50px; 끝 -->
    </div><!--containerBoxSub-->   
    
   
<%@ include file="/WEB-INF/views/common/include/sellerFooter_sub_v2.jsp" %>
</div><!-- warp 끝-->





	
	



</body>
</html>
