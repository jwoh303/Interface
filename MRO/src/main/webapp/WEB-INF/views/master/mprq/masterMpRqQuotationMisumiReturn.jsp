<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%

String RESULT = (String)request.getAttribute("RESULT");

%>
<script type="text/javascript">

function callback() {

	if ("SUCCESS" == "<%=RESULT %>") {
		alert("저장되었습니다.");
	} else {
		alert("실패했습니다. 관리자에게 문의하시기 바랍니다.");
	}
	window.close();
}

</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body onload="callback();">
</body>
</html>
