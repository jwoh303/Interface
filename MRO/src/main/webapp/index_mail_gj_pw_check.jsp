<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%!
public String null2sp(String str){
  if ( str == null || str == "" || str == "null" || str.equals("") || str.equals("null") || str.equals(null)) return "";
  else return str;
    }
%>
<%
   String kita_id			= null2sp(request.getParameter("st_gj_user_id"));
   String gw_no				= null2sp(request.getParameter("st_gw_no"));
   String gw_gj_type		= null2sp(request.getParameter("st_gj_type"));
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>코리아 e 플랫폼</title>
</head>
<script type="text/javascript">

function nextPage() {
	location.href="/login/mailLoginPwCheck.do?st_gj_user_id=<%=kita_id%>&st_gw_no=<%=gw_no%>&st_gj_type=<%=gw_gj_type%>";
}

</script>
<body onload='nextPage();'>
</body>
</html>
