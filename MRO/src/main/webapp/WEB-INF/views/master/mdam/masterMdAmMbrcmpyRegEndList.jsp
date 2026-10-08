<%--
**********************************************
* 메뉴 : 회원가입>회원가입 완료
* 화면 : 회원가입 완료
* 기능 : 
* 프로그램 ID : PG_01_M_013_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-09
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
String com_code =  CommonUtil.nvl((String) request.getParameter("com_code"), "");
String type =  CommonUtil.nvl((String) request.getParameter("type"), "");
String bImg = "";
String sImg = "";
String uImg = "";
if (type.equals("U")) {
	uImg = "<img src='/resources/images/main/br_List.gif' alt=''/>";
} else if (type.equals("B")) {
	bImg = "<img src='/resources/images/main/br_List.gif' alt=''/>";
} else if (type.equals("S")) {
	sImg = "<img src='/resources/images/main/br_List.gif' alt=''/>";
}
%>
<script type="text/javascript">
<% if (type.equals("S")) { %>
alert("공급사등록("+ "<%=com_code%>" +")이 정상적으로 이루어 졌습니다.\n\n확인버튼 클릭시 결제계좌 신고서가 자동으로 나타납니다.\n\n출력하시어 저희쪽으로 FAX 부탁드립니다.");
var param =  "["+ "<%=com_code%>" +"]";
var fileName = "RD_04_B_008_02";
reportOpen(fileName, param);

<% } %>

</script>
</head>
<body onload="">
<div class="wrap" >
	<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
	<c:set var="jqueryGbn"  value="Y"/>
	<%@ include file="/WEB-INF/views/common/include/mainHeader.jsp" %>
	<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
	
	<!--내용 시작-->
	<div class="Subwrap">
		<!------------------------------------------------------------------------------------------------left-------------------------------------------------------------------------------------------------------------->
		<c:import charEncoding="utf-8" url="/main/mainLeft.do" >
			<c:param name="subNo" value="None"/>
		</c:import>
		<!------------------------------------------------------------------------------------------------left-------------------------------------------------------------------------------------------------------------->     
		<div class="SubCenter" >
			<div class="CenterVisual_MemberJoin"></div>
			<div class="MentLocation"><img src="/resources/images/main/br_home.gif" alt=""> > 회원가입 > 회원가입 완료</div>
			<div class="CenterBody" >
				<h2> 회원가입 완료</h2>
				<div class="MemberJoin" >
					<div>Koreab2b.com 회원가입을 환영합니다.</div>
					<div class="joinend">
						<br /><br />
						<% if (type.equals("U")) { %>
						<b>사용자 등록이 완료 되었습니다.</b><br /><br />
						<% } else if (type.equals("B")) { %>
						<b>고객사 등록<span class="FontRed">(<%=com_code%>)</span>및 사용자 등록이 완료 되었습니다.</b><br /><br />
						<% } else if (type.equals("S")) { %>
						<b>협력사 등록<span class="FontRed">(<%=com_code%>)</span>및 사용자 등록이 완료 되었습니다.</b><br /><br />
						<% } %>
						
						인터넷 전자상거래 업체의 최고를 추구하는 KeP(www.koreab2b.com)에<br />
						회원가입 하신것을 진심으로 감사드리며, 별도의 연락을 드린 후<br />
						소정의 회원승인 심사 기간을 거쳐 승인이 이루어 집니다.<br /><br />
						승인관련 문의 및 이용 관련 문의가 있으시면<br />
						언제든지 연락(Tel.02-3016-8989)주시기 바랍니다.<br />
						고객서비스 향상에 더욱 충실한 KeP가 될것이며<br />
						회원가입 하심에 대해 다시 한번 감사드립니다.<br /><br /><br /><br />
						<a href="/main.do"><span class="BtnBlue">확인</span></a>
					</div>
					
					<div class="h80"></div>   
				</div>
			</div>
		</div>
	</div> 
	
	<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	<%@ include file="/WEB-INF/views/common/include/mainFooter.jsp" %>
	<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
</div>
<!--내용 종료-->	                 
</body>
</html>
<script type="text/javascript">
<!--

//-->
</script>
