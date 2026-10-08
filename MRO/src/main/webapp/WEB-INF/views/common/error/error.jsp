<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>시스템 점검중</title>
<%@ include file="/WEB-INF/views/common/include/head.jspf"%>
<script type="text/javascript">
function goHome() {
	//부모창이 존재하면 부모창을 redirect시킴.
	if(typeof parent == 'undefined'){
		location.href = "/";
		return;
	}else{
		parent.location.href = "/";
		return;
	}
}
</script>
</head>
<body style="text-align:center; margin-top:30px; font-family:맑은 고딕; color:#1d2a40; font-size:14px; line-height:18px;    ">

<div style="margin:0 auto; width:470px; height:500px; text-align:left;  background:url(/resources/images/check_bg.gif) no-repeat; padding-top:100px">
    
    <span style="color:#0f64ab; font-weight:bold; font-size:22px;letter-spacing:-1px; line-height:30px; ">죄송합니다.<br />
    요청하신 페이지를 찾을 수 없습니다.</span><br /><br /><br /><br />
    방문하시려는 페이지의 주소가 잘못 입력되었거나,<br />
    페이지의 주소가 변경 혹은 삭제되어 요청하신 페이지를 찾을 수 없습니다.<br /><br />
    관련 문의사항은 KeP에  알려주시면 친절하게 안내해 드리겠습니다.<br /><br />
    감사합니다. &nbsp;<br /><br /><br /><br />
    
    
    <span style="font-size:10px; line-height:18px; vertical-align:middle "> <img src="/resources/images/Check_logo.gif" alt="코리아e플랫폼" align="absmiddle" />&nbsp; Copyright KOREA e PLATFORM Ltd. All Rights Reserved. </span>
</div>
<!-- 일시 : 11월 20일 8:00(목) ~ 11월 21일 8:00(금)<br /> -->
<!-- 담당부서 :  정보시스템실<br /> -->
<!-- 연락처 : 02-3016-8989 -->
<%-- 	<%=request.getAttribute("error")%> --%>
<!-- 	<br /> -->
<%-- 	<a href="javascript:goHome();"><spring:message code="홈으로" /></a> --%>
</body>
</html>

