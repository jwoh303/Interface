<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
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
        <li onclick="location.href='/main/renewal_buyer_join.do'">고객사 가입 안내</li>
        <li onclick="location.href='/main/renewal_seller_join.do'" class="ON">협력사 가입 안내</li>
        <li onclick="location.href='/main/renewal_faq.do'">자주 묻는 질문</li>
        </ul>
      </div>
    </div>
	<!-- 컨텐츠 -->
	<div class="containerBox">
      <div class="containerSub">
        <div class="h80"></div>

<% if (type.equals("B") || type.equals("S")) { %>
        <%-- ===== type=B,S: 협력사 등록 완료 (Com_협력사등록완료.html 디자인) ===== --%>
        <div class="ComJoinTitLarge">협력사 사용자 등록 요청이 정상적으로 접수되었습니다.</div>
        <div class="JoinEndIcon mt80"></div>
        <div class="JoinEndTxt mt50">코리아이플랫폼 담당자의 승인 후 사이트 이용이 가능합니다.<br/>승인 완료 시 등록하신 이메일로 안내드릴 예정입니다.</div>
        <div class="ComButtonArea mt80"><button class="ButtonMedium" onclick="location.href='/main.do'" style="width:250px">확인</button></div>
<% } else { %>
        <%-- ===== type=U: 사용자 등록 완료 (Com_협력사사용자등록완료.html 디자인) ===== --%>
        <div class="ComJoinTitLarge">사용자 등록 요청이 접수되었습니다.</div>
        <div class="JoinEndIcon mt30"></div>
        <div class="JoinEndTxt mt50">사이트 이용을 위해 KeP 담당자에게 <span class="F6495F">전화로 승인 요청</span>을 해주세요.<br/>승인 완료 후, 사이트 사용이 가능하며 등록하신 이메일로 결과를 안내해드립니다.</div>
<!--         <div class="JoinCustomer mt30"> -->
<!--           <p><img src="/resources/imgs/com_icon06.png"/></p> -->
<!--           <p>승인 담당자<br/> -->
<!--           박지수 선임(02-3016-7251)</p> -->
<!--         </div> -->
        <div class="ComButtonArea mt80"><button class="ButtonMedium" onclick="location.href='/main.do'" style="width:300px">메인으로 돌아가기</button></div>
<% } %>

        <div class="h80"></div>
      </div><!-- containerSub 끝 -->
	</div><!-- containerBox 끝 -->

    <%@ include file="/WEB-INF/views/common/include/mainFooter_v2.jsp" %>
</div><!-- wrap 끝-->

</body>
</html>
