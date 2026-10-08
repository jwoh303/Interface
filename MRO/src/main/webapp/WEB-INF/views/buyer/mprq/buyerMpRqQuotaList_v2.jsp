<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf"%>
</head>
<%
List<Map<String,String>> tab_data = (List<Map<String,String>>) request.getAttribute("tab_data"); // 탭
String menuId = CommonUtil.nvl((String) request.getParameter("menuId"),""); // 메뉴아이디
String tabIndex = CommonUtil.nvl((String) request.getParameter("tabIndex"),"1"); // tab Index
String selStatus = CommonUtil.nvl((String) request.getParameter("selStatus"),""); // selStatus

if(myMenuListHeader != null){ //null이 아닌 경우에만 체크
	for(int i = 0; i<myMenuListHeader.size(); i++){
		if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
			myMenuFlag = true;
			break;
		}
	}
}

String rowCnt = "30";
if (_sessionInfo != null){
	rowCnt = CommonUtil.nvl((String)_sessionInfo.getRowCnt(),"30");
	String pageString = "30,50,100,200,500,1000";
	if(!Arrays.asList(pageString.split(",")).contains(rowCnt)){
		rowCnt = "30";
	}
}

%>
<script>
var tabIndex = "<%=tabIndex%>";

function kep_onload_view(){
	//초기 날짜 셋팅
	var indexLength = $("input[name=st_from_date]").length;
	for(var i = 0; i < indexLength; i++){
		if($("input[name=st_from_date]").eq(i).val() ==  ""){
			$("input[name=st_from_date]").eq(i).val(kepToMonthAdd("1","M"));
			$("input[name=st_to_date]").eq(i).val(kepGetNowTimeStr('YYYYMMDD','/'));
		}
	}
	
	currIndex = tabIndex;
	//버튼에 active
	document.querySelectorAll('button[data-tab]').forEach(function(btn){
		btn.classList.toggle('active',btn.dataset.tab === 'Search'+tabIndex);
		tabs["buyerMpRqQuota_"+btn.id]["init"](); // 각 탭의 init() 함수 실행
	})
	
	//div에 active
	document.getElementById("Search"+tabIndex).classList.add("active");

	tabs["buyerMpRqQuota_tab"+tabIndex]["search"]();  
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
			<%=CommonLang.get("HTITLE520")%> <%if(myMenuFlag) {%>
	          <button class="But_Star_on"></button>
	     	<%}else{ %>
	     	  <button class="But_Star_off"></button>
	     	<%} %> 
			<div class="SubPageGuide">
		      	<ul>
		        	<li><img src="../../../../resources/imgs/Icon_Home.png" /></li><li><%=CommonLang.get("HTITLE1204")%></li><li><%=CommonLang.get("HTITLE1205")%></li>
				</ul>
			</div>   
		</div>
		<div class="container">
			<div class="SubSearchTab">
		     <%for(int i = 0; i<tab_data.size(); i++){ %>
				<%=tab_data.get(i).get("MENU_BUTTON") %>
		     <%} %>
		    </div>
	    
	    <c:forEach items="${tab_data}" var="item">
	    	<jsp:include page="${item.MENU_JSP}">
	    		<jsp:param name="rowCnt" value="<%=rowCnt %>" />
	    		<jsp:param name="selStatus" value="<%=selStatus %>" />
	    	</jsp:include>
	    </c:forEach>
	    
	    <script>
	    const tabLinks = document.querySelectorAll(".TabTit");
	    const tabContents = document.querySelectorAll(".SearchContent");

	    tabLinks.forEach(function(link,index){
	      link.addEventListener("click", function() {
	        // 모든 탭 버튼, 컨텐츠 비활성화
	        tabLinks.forEach(function(btn){btn.classList.remove("active")});
	        tabContents.forEach(function(content) {content.classList.remove("active")});

	        // 클릭한 탭 활성화
	        link.classList.add("active");
	        document.getElementById(link.dataset.tab).classList.add("active");
	        currIndex = index+1; //클릭한 index 를 현재 index 로 저장
	        
	        tabs["buyerMpRqQuota_tab"+currIndex]["search"]();
	      });
	    });
	    
	    </script>
	    </div>
	 <%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>
	</div>
 </div>
</body>
</html>