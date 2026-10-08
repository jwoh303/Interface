<%--
**********************************************
* 메뉴 : HOME>WMS홈
* 화면 : WMS홈
* 기능 : 
* 프로그램 ID : PG_07_M_014_00
* 담당자 : 이수영 ( 설계 : 김상근 )
* 착수일 : 2014-08-18
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
//공통
@SuppressWarnings (value="unchecked")
List<Map<String, String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
%>
<script type="text/javascript">

var popupSel = "";
// 팝업 함수호출
function doPop(str, val) {
	popupSel = str;
	
	switch (str) {
		case "more":		// 물류 공지사항 리스트
			openSearchPopup('/wmst/showMasterWmstNoticeListPop.do','','680,480,no');
			break;
		case "detailView":		// 물류 공지사항 상세보기
			openSearchPopup("/wmst/showMasterWmstNoticeDetailPop.do", "?st_bid="+val, "800,560,no");
			break;	
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	
	switch (popupSel) {
		case "detailView":
			if (code == "OK") {
				document.location.reload();
			}
			break;
	}
}
</script>
</head>
<body>

<c:if test="${param.noHeaderGbn ne 'Y' }">
	<div id="wrapper">
	<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
	<c:import charEncoding="utf-8" url="/menu/menu.do" >
	<c:param name="page" value="masterHeader"/>
	<c:param name="part" value="masterHeader"/>
	<c:param name="upperId" value="${param.upperId}"/>
	</c:import>
</c:if>

	<!--물류 메인 내용시작-->
	<div id="admin_home">
		<div id="main_table_div">
			<div class="WmsBox" >
				<div class="WmsNotice">
					<p class="more"><a href="javascript:doPop('more');"><img src="/resources/images/b_btn_more.gif" /></a></p>
					<p class="Notice">Notice</p>
					<ul>
					<%
					if (_gridList != null && _gridList.size() > 0) { 
						for (int j=0; j<_gridList.size(); j++) {
							Map<String,String> rowData = _gridList.get(j);
					%>	
						<li><a href="javascript:doPop('detailView', '<%=rowData.get("BID")%>');"><span class="title">[<%=rowData.get("COM_NAME") %>] <%=CommonUtil.textMore(rowData.get("SUBJECT"), 20) %></span></a> 		<span class="date"><%=rowData.get("REG_USER_NAME") %> / <%=rowData.get("REG_DATE") %></span></li>
					<%
						}
					} else {
					%>
					<li><span class="title">&nbsp;</span></a><span class="date">&nbsp;</span></li>
					<% } %>
					</ul>
				</div>
			</div>
		</div>      
	</div>

<!--내용 종료-->	      
<c:if test="${param.noHeaderGbn ne 'Y' }"> 
	<%@ include file="/WEB-INF/views/common/include/masterFooter.jsp" %>
	</div>
</c:if>
</body>
</html>			
