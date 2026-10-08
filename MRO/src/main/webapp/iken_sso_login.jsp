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
   String st_emp_no       = null2sp(request.getParameter("st_emp_no"));
   String st_datetime     = null2sp(request.getParameter("st_datetime"));
   String st_link_gubun   = null2sp(request.getParameter("st_link_gubun"));
   String sessionkey      = null2sp(request.getParameter("sessionkey"));

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<script>
  location.href="http://old.koreab2b.com/iken_sso_login.jsp?st_emp_no=<%=st_emp_no%>&st_datetime=<%=st_datetime%>&st_link_gubun=<%=st_link_gubun%>&sessionkey=<%=sessionkey%>";
</script>
<body>

</body>
</html>
