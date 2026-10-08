<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyerLayout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
	String role_code = CommonUtil.nvl(request.getParameter("st_role_code"));
	//String role_code = Wsession.getRole();
	String role1 = "";
	String role2 = "";
	
	if (role_code.length() > 1){
		role1 = role_code.substring(0,1);
		role2 = role_code.substring(1,role_code.length());
	}

	String user_type = CommonUtil.nvl(request.getParameter("st_user_type"));

	
%> 
<script type="text/javascript">
<!--

function save(){
	var role_code;
	var role_name;
	var user_type = "<%=user_type%>";

	if(user_type =="A"){
		role_code = "A+";
		role_name = "관리자";		
	}else {

		if(document.forms[0].check_u.checked == true) {
		

			if(document.forms[0].check_p.checked == true && document.forms[0].check_g.checked == true){
				role_code = "C+";
				role_name = "주문 : 발주 : 입고";
			}else if(document.forms[0].check_p.checked == true){
				role_code = "P+";
				role_name = "주문 : 발주";
			}else if(document.forms[0].check_g.checked == true){
				role_code = "G+";
				role_name = "주문 : 입고";
			}else{
				role_code = "U+";
				role_name = "주문";
			}

		}else {

			if(document.forms[0].check_p.checked == true && document.forms[0].check_g.checked == true){
				role_code = "C-";
				role_name = "발주 : 입고";
			}else if(document.forms[0].check_p.checked == true){
				role_code = "P-";
				role_name = "발주";
			}else if(document.forms[0].check_g.checked == true){
				role_code = "G-";
				role_name = "입고";
			}else{
				role_code = "U-";
				role_name = "주문";
			}

		}

	}
	
	opener.setPopupReturn( role_code , role_name );
	self.close();
}

//-->
</script>
</head>
<body onload="">
<form method="POST">
<div class="PopTitle">권한등록</div>
<div id="POPMargin20">
<div class="TableWrit">
   <div class="TableListRrow2">
	 <table style="width:300">   
		<tr>
		  <td class="TTit01_33px" width="20%">선택</td>
		  <td class="TTit02_33px" width="80%">권한명</td>
		</tr>
	<tr bgcolor="#FFFFFF" >
	  <td height="25" align="center" width="35%" title="선택" class="td02">
		<input id="check" type="checkbox" name="check_u" id = "check" <% if( role2.equals("@")) out.println("checked");%>  >
	  </td>
	  <td height="20" width="65%" align="center" title="선택" class="td02">
		주문&nbsp;
	  </td>
	</tr>
	<tr bgcolor="#f4f5f9" >
	  <td height="25" align="center" width="35%" title="선택" class="td02">
		<input id="check" type="checkbox" name="check_p" id = "check" <% if( role1.equals("P") || role1.equals("C")) out.println("checked");%>  >
	  </td>
	  <td height="20" width="65%" align="center" title="선택" class="td02">
		발주&nbsp;
	  </td>
	</tr>
	<tr bgcolor="#FFFFFF" >
	  <td height="25" align="center" width="35%" title="선택" class="td02">
		<input id="check" type="checkbox" name="check_g" id = "check" <% if( role1.equals("G") || role1.equals("C")) out.println("checked");%>  >
	  </td>
	  <td height="20" width="65%" align="center" title="선택" class="td02">
		입고&nbsp;
	  </td>
	</tr>
   </table>
  </div>	
 </div>
 </div>
<table style="width:300px">
  <tr align="right" valign="middle" >
	<td height="40" colspan="2">
		<A href="javascript:save()"><img src="/kr/coway_buyer/images_new/but_save.gif" alt="저장"></a>
		<A href="javascript:self.close()"><img src="/kr/coway_buyer/images_new/but_close.gif" alt="닫기"></a>&nbsp;
	</td>
  </tr>
</table>
  </form>
</body>
</html>
