<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<% 
String _sendUrl			= (String)request.getParameter("_sendUrl");
String _punchoutOrderMessageXML	= (String)request.getParameter("_punchoutOrderMessageXML");
String _pForm	= (String)request.getParameter("_pForm");
String _pMethod		= (String)request.getParameter("_pMethod");
System.out.println("_sendUrl11================"+_sendUrl);
%>
<!doctype html>
<html >
<head>
<title>코리아 e 플랫폼</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script language="JavaScript" type="text/javascript"> //popup에 들어갈 내용

function kep_onload_view(){
	 alert("ddd=============");
	  $.ajax({
	      data: {"cxml-urlencoded": ""},
	      type: "POST",
	      url: "<%=_sendUrl%>",
	      contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	      crossDomain: true,
	      dataType: "text",
	      success : function( response ) {
	    	  		alert("success");
	    	  		loader_obj("N");
	      },
	      error : function ( response, textStatus ){
	    	  	  alert("sendPunchoutOrderMessage error");
	    	  	  loader_obj("N");
	      }
	  });
	}
</script>
</head>
<body onload="kep_onload_view()">
<form name="checkClose">
  <div id="Popup">
    <div class="popuptxt" >
        감사합니다.222 
    </div>
  </div>
</form>
</body>
</html>
