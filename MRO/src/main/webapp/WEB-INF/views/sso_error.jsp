<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<title>SSO 접근오류</title>
</head>
<body style="margin:0 auto; text-align:center; margin-top:120px; font-family:맑은 고딕; color:#1d2a40; font-size:18px; line-height:30px;    ">
<img src="/resources/images//Check.gif" alt="SSO 접근오류" /><br />
<span style="color:#0f64ab; font-weight:bold; font-size:22px;letter-spacing:-1px">허가되지 않은 접근입니다.</span><br /><br />
접근 사이트 : <%=request.getHeader("REFERERE")%><br/>
담당부서 :  정보시스템실<br />
연락처 : 02-3016-8914
</body>
</html>
