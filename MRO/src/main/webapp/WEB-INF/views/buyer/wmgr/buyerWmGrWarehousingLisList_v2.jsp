<%--
**********************************************
* 메뉴 : 입고관리
* 화면 : 입고관리
* 기능 : 입고관리
* 프로그램 ID : BU0402003
* 담당자 : 최찬규
* 착수일 : 2026-04-30
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
<%@ include file="../../common/include/head_v2.jspf"  %>
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> tab_data = (List<Map<String,String>>) request.getAttribute("tab_data"); // 탭
	String menuId = CommonUtil.nvl((String) request.getParameter("menuId"),""); // 메뉴아이디
	String tabIndex = CommonUtil.nvl((String) request.getParameter("tabIndex"),String.valueOf(tab_data.get(0).get("MENU_ORDER"))); // tab Index
	if(tabIndex.equals("1")){ //메뉴 눌러서 진입 시 입고권한 있는 사람들은 입고현황이 아닌 입고대상으로
		tabIndex = "2";
	}
	
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
	String prMngFlag = "";
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId()); 
		businessCond = CommonUtil.nvl((String)_sessionInfo.getBusinessCond());
		prMngFlag = CommonUtil.nvl((String)_sessionInfo.getPrMngFlag());
		rowCnt = CommonUtil.nvl((String)_sessionInfo.getRowCnt(),"30");
		String pageString = "30,50,100,200,500,1000";
		if(!Arrays.asList(pageString.split(",")).contains(rowCnt)){
			rowCnt = "30";
		}
	}
%>  
<body onLoad="kep_onload_view();">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerHeader_v2"/>
<c:param name="part" value="buyerHeader_v2"/>
</c:import>   
<div id="container2">
		<!--서브타이틀-->  
  <div class="SubPageTit">
    <%=CommonLang.get("HTITLE532")%><!--입고관리--><%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star_off"></button>
     	<%} %> 
    <div class="SubPageGuide">
      <ul>
        <li><img src="/resources/imgs/Icon_Home.png" /></li>
        <li><%=CommonLang.get("HTITLE270") %><!-- 입고 --></li>
        <li><%=CommonLang.get("HTITLE532")%><!--입고관리--></li>
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
    		<jsp:param name="buyer" value="<%=buyer %>" />
    		<jsp:param name="userId" value="<%=userid %>" />
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
	      tabs["buyerWmGrWarehousingLis_"+link.id]["search"]();
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
function kep_onload_view() {
	var tabIndex = "<%=tabIndex%>";
	
	//버튼에 active
	document.querySelectorAll('button[data-tab]').forEach(function(btn){
		btn.classList.toggle('active',btn.dataset.tab === 'Search'+tabIndex);
		tabs["buyerWmGrWarehousingLis_"+btn.id]["init"](); // 각 탭의 init() 함수 실행
	})
	
	//div에 active
	document.getElementById("Search"+tabIndex).classList.add("active");
	tabs["buyerWmGrWarehousingLis_tab"+tabIndex]["search"]();
}
</script>
</html>
