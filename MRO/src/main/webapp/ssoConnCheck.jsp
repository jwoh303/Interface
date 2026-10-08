<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<script type="text/javascript">

function nextPage(gubun, com_code, user_id, v) {
	document.forms[0].st_com_code.value = com_code;
	document.forms[0].st_user_id.value = user_id;
	document.forms[0].v.value = v;
	var url	= "";
	if (gubun == "창성") {
		url	= "/changsung_sso_login.jsp";
	} else if (gubun == "우송") {
		url	= "/woosong_sso_login.jsp";
	} else {
		url	= "/sso_login.jsp";
	}
	
	document.forms[0].target	= "_self";
	document.forms[0].action	= url;
	document.forms[0].method 	= "post";
	document.forms[0].submit();
}


function callEvent() {
	window.open("http://localhost:8080/mpso/setGRCompareEvent.do?st_buyer=KRYOUN0301&st_close_month=201802");
}

</script>
<body>
<input type="button" value="코웨이" onclick="javascript:nextPage('코웨이','KRCOWA0001','20315792');"> 
<input type="button" value="일진" onclick="javascript:nextPage('일진전기','KRILJIG002','360070');"> 
<input type="button" value="영풍" onclick="javascript:nextPage('영풍','KRKEPB0004','MHY820');"> 
<input type="button" value="롯데알미늄" onclick="javascript:nextPage('롯데알미늄','','','0mk8LLyjp+n5hY6L15TMSNPewcw325A/JZTepk5G6BmBJUQSU3ToRP7GvX4QXF8jgsC5tp+9QAb5gjrJuhnGjTiV3x8XikpMRRqLbWjNs/TAjHWvZMPeTYn3SYMmueEH+d0JcMHTpW3fTjTuTXI09XsrWaY7fDnffug6CwdI+Xd8Y9FcpLbBO6TiQdm/o0v1');">

<input type="button" value="Event" onclick="javascript:callEvent();">

  <form name="form1">
  	<input type="hidden" name="st_com_code" value="">
  	<input type="hidden" name="st_user_id" value="">
  	<input type="hidden" name="v" value="">
  </form>
</body>
</html>
