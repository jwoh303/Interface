<%--
**********************************************
* 메뉴 : 예산편성
* 화면 : 예산편성
* 기능 : 예산편성
* 프로그램 ID : BU1005005
* 담당자 : 최찬규 
* 착수일 : 2026-03-17
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="java.sql.Timestamp"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")

	List<Map<String,String>> tab_data = (List<Map<String,String>>) request.getAttribute("tab_data"); // 탭
	String menuId = CommonUtil.nvl((String) request.getParameter("menuId"),""); // 메뉴아이디
	String tabIndex = CommonUtil.nvl((String) request.getParameter("tabIndex"),"1"); // tab Index
	
	if(myMenuListHeader != null){ //null이 아닌 경우에만 체크
		for(int i = 0; i<myMenuListHeader.size(); i++){
			if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
				myMenuFlag = true;
				break;
			}
		}
	}
	
	String buyer = "";
	String userid = "";
	String businessCond = "";
	String rowCnt = "30";
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId()); 
		businessCond = CommonUtil.nvl((String)_sessionInfo.getBusinessCond());
		rowCnt = CommonUtil.nvl((String)_sessionInfo.getRowCnt(),"30");
		String pageString = "30,50,100,200,500,1000";
		if(!Arrays.asList(pageString.split(",")).contains(rowCnt)){
			rowCnt = "30";
		}
	}
	
	//통제기간 default 특수로직
	String p070000027 = CommonUtil.getSpecialCheckReturn(buyer,"P07-0000027","COL01_DATA");
	
	//엑셀다운로드 기능 통제
	boolean p170000001 = CommonUtil.getSpecialCheckReturn(buyer,"P17-0000001");
	String excel_control = String.valueOf(p170000001);
%>  
<body onload="kepOnload()">
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerHeader_v2"/>
<c:param name="part" value="buyerHeader_v2"/>
</c:import>   
<div id="container2">
		<!--서브타이틀-->  
  <div class="SubPageTit">
    <%=CommonLang.get("HTITLE422")%><!--예산편성--><%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star_off"></button>
     	<%} %> 
    <div class="SubPageGuide">
      <ul>
        <li><img src="/resources/imgs/Icon_Home.png" /></li>
        <li><%=CommonLang.get("HTITLE1126")%><!--관리자설정관리--></li>
        <li><%=CommonLang.get("HTITLE422")%><!--예산편성--></li>
      </ul>
    </div>   
  </div>
  <div class="container">
    <div class="SubSearchTab">
     <%for(int i = 0; i<tab_data.size(); i++){ %>
     	<%=tab_data.get(i).get("MENU_BUTTON") %>
     <%} %>
    </div>
    
    <c:forEach items="${tab_data }" var="item">
    	<jsp:include page="${item.MENU_JSP }" >
    		<jsp:param name="rowCnt" value="<%=rowCnt %>" />
    		<jsp:param name="default_term" value="<%=p070000027 %>" />
    		<jsp:param name="excel_control" value="<%=excel_control %>" />
    	</jsp:include>
    </c:forEach>
    
    <script>
      const tabLinks = document.querySelectorAll(".TabTit");
      const tabContents = document.querySelectorAll(".SearchContent");
    
      tabLinks.forEach(function(link){
        link.addEventListener("click", function() {
          // 모든 탭 버튼, 컨텐츠 비활성화
          tabLinks.forEach(function(btn){btn.classList.remove("active")});
          tabContents.forEach(function(content) {content.classList.remove("active")});
    
          // 클릭한 탭 활성화
          link.classList.add("active");
          document.getElementById(link.dataset.tab).classList.add("active");
	      tabs["buyerMdAmBudgetCompilation_"+link.id]["search"]();
        });
      });
    </script>
  </div>
</div>
 
<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>
</div>
</div>
</body> 
<script type="text/javascript">

var PASS_KN = "";
var st;
var popupSel = "";
// var getMultiApprFlag = "";
function kepOnload() {
	
	var tabIndex = "<%=tabIndex%>";
	
	//버튼에 active
	document.querySelectorAll('button[data-tab]').forEach(function(btn){
		btn.classList.toggle('active',btn.dataset.tab === 'Search'+tabIndex);
		tabs["buyerMdAmBudgetCompilation_"+btn.id]["init"](); // 각 탭의 init() 함수 실행
	})
	
	//div에 active
	document.getElementById("Search"+tabIndex).classList.add("active");
	tabs["buyerMdAmBudgetCompilation_tab"+tabIndex]["search"]();
}
</script>
