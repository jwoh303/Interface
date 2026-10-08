<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
String com_code = CommonUtil.nvl((String) request.getParameter("com_code"), "");
String type = CommonUtil.nvl((String) request.getParameter("type"), "");
%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<%@ include file="/WEB-INF/views/common/include/mainHeader_v2.jsp" %>
</head>
<body>
<div class="wrap">
	<div class="ComNavigation">
      <div class="navigationBar">
        <ul>
        <li onclick="location.href='/main/renewal_buyer_join.do'" class="ON">고객사 가입 안내</li>
        <li onclick="location.href='/main/renewal_seller_join.do'">협력사 가입 안내</li>
        <li onclick="location.href='/main/renewal_faq.do'">자주 묻는 질문</li>
        </ul>
      </div>
    </div>
	<!-- 컨텐츠 -->
	<div class="containerBox">
      <div class="containerSub">
        <div class="h80"></div>
        <div class="ComJoinTitLarge">사용자 등록 요청이 정상적으로 접수되었습니다.</div>
        <div class="JoinEndIcon mt80"></div>
        <div class="JoinEndTxt mt50">해당 요청은 고객사 내부 관리자의 승인 후에 최종 완료됩니다.<br/>
        승인이 완료되면 사이트 이용이 가능하며,<br/>
        등록하신 이메일로 승인 결과를 안내드릴 예정입니다.
        </div>
        <div class="ComButtonArea mt80"><button class="ButtonMedium" onclick="location.href='/main.do'" style="width:250px">확인</button></div>
        <div class="h80"></div>
      </div><!-- containerSub 끝 -->
	</div><!-- containerBox 끝 -->

    <%@ include file="/WEB-INF/views/common/include/mainFooter_v2.jsp" %>
</div><!-- wrap 끝-->

</body>
</html>
