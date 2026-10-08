<%--
**********************************************
* 메뉴 : 입고 > 마감관리
* 화면 : 마감관리 (마감현황/마감상세조회)
* 기능 : 마감관리
* 프로그램 ID : BU0601001
* 담당자 :
* 착수일 : 2026-04-06
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf"%>
<script src="/resources/js/common/HttpUtil.js" type="text/javascript"></script>
<script src="/resources/js/common/PopupUtil.js" type="text/javascript"></script>
</head>
<%
List<Map<String,String>> tab_data = (List<Map<String,String>>) request.getAttribute("tab_data"); // 탭
String menuId = CommonUtil.nvl((String) request.getParameter("menuId"),""); // 메뉴아이디
String tabIndex = CommonUtil.nvl((String) request.getParameter("tabIndex"),"1"); // tab Index

if(myMenuListHeader != null){
	for(int i = 0; i<myMenuListHeader.size(); i++){
		if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
			myMenuFlag = true;
			break;
		}
	}
}

String sessionComCode = _sessionInfo.getComCode();
String sessionUserId = _sessionInfo.getUserId();
String rowCnt = CommonUtil.nvl((String)_sessionInfo.getRowCnt(),"30");
String pageString = "30,50,100,200,500,1000";
if(!Arrays.asList(pageString.split(",")).contains(rowCnt)){
	rowCnt = "30";
}

// 엑셀다운로드 기능 통제
boolean p170000001 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P17-0000001");
String p170000001_str = String.valueOf(p170000001);

// grSttsType: A=계정번호, B=관리번호, N=사용안함 (부서별입고집계 컬럼 분기용)
String grSttsType = CommonUtil.getKepBuyerFlagColumnReturn(sessionComCode, "GR_STTS_TYPE");
%>
<script>
var tabIndex = "<%=tabIndex%>";

function kep_onload_view(){
	currIndex = tabIndex;
	// 각 탭의 init() 함수 실행
	document.querySelectorAll('button[data-tab]').forEach(function(btn){
		btn.classList.toggle('active', btn.dataset.tab === 'Search'+tabIndex);
		tabs["buyerWmGrClosing_"+btn.id]["init"]();
	});

	// 활성 탭 표시
	document.getElementById("Search"+tabIndex).classList.add("active");
	// 첫 탭 조회
	tabs["buyerWmGrClosing_tab"+tabIndex]["search"]();
}
</script>
<body onload="kep_onload_view()">
	<div id="wrapper">
		<c:import charEncoding="utf-8" url="/menu/menu.do">
			<c:param name="page" value="buyerHeader_v2"/>
			<c:param name="part" value="buyerHeader_v2"/>
		</c:import>
		<div id="container2">
		<!--서브타이틀-->
		<div class="SubPageTit">
			<%=CommonLang.get("HTITLE1464")%><!--마감관리--> <%if(myMenuFlag) {%>
				<button class="But_Star_on"></button>
			<%}else{ %>
				<button class="But_Star_off"></button>
			<%} %>
			<div class="SubPageGuide">
				<ul>
					<li><img src="/resources/imgs/Icon_Home.png" /></li>
					<li><%=CommonLang.get("HTITLE1321")%><!--입고--></li>
					<li><%=CommonLang.get("HTITLE1464")%><!--마감관리--></li>
				</ul>
			</div>
		</div>
		<div class="container">
			<div id='TabUI'  class="SubSearchTab">
				<%for(int i = 0; i<tab_data.size(); i++){ %>
					<%=tab_data.get(i).get("MENU_BUTTON") %>
				<%} %>
			</div>

			<c:forEach items="${tab_data}" var="item">
				<jsp:include page="${item.MENU_JSP}">
					<jsp:param name="p170000001" value="<%=p170000001_str %>" />
					<jsp:param name="grSttsType" value="<%=grSttsType %>" />
					<jsp:param name="rowCnt" value="<%=rowCnt %>" />
				</jsp:include>
			</c:forEach>

			<script>
			
			
			
			
			var currIndex = 1;
			const tabLinks = document.querySelectorAll(".TabTit");
			const tabContents = document.querySelectorAll(".SearchContent");
			// 탭하나라 숨김
// 			const TabUI = document.getElementById("TabUI");
// 			TabUI.style.display = "none"; 
			
			tabLinks.forEach(function(link, index){
				link.addEventListener("click", function() {
					tabLinks.forEach(function(btn){btn.classList.remove("active")});
					tabContents.forEach(function(content) {content.classList.remove("active")});
					link.classList.add("active");
					document.getElementById(link.dataset.tab).classList.add("active");
					currIndex = index+1;
					tabs["buyerWmGrClosing_tab"+currIndex]["search"]();
				});
			});
			</script>
		</div>
		<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>
	</div>
</div>
</body>
</html>
