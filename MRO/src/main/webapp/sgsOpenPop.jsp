<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<% 
String st_use_flag			= (String)request.getParameter("st_use_flag");
String st_move_flag	= (String)request.getParameter("st_move_flag");
String st_query2	= (String)request.getParameter("st_query2");
String next_status		= (String)request.getParameter("next_status");
String st_update	= (String)request.getParameter("st_update");
String upperId	= (String)request.getParameter("upperId");
String st_dup_add_flag	= (String)request.getParameter("st_dup_add_flag");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SGSOpen</title>
</head>
<body onload='getPunchoutOrderMessageFromCart("/mpso/getPunchoutOrderMessage.do","processForm","CHECKOUT")'>
<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="<%=st_use_flag %>" />
	<input type="hidden" name="st_move_flag" id="st_move_flag"  value="<%=st_move_flag %>"/>
	<input type="hidden" name="st_query2" id="st_query2"  value="<%=st_query2 %>"/>	
	<input type="hidden" name="next_status" id="next_status"  value="<%=next_status %>"/> 
	<input type="hidden" name="st_update" id="st_update"  value="<%=st_update %>"/> 
	<input type="hidden" id="upperId"  name="upperId" value="<%=upperId %>">
	<input type="hidden" name="st_dup_add_flag" id="st_dup_add_flag" value="<%=st_dup_add_flag %>" />
</form>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script type="text/javascript">
function getPunchoutOrderMessageFromCart(pUrl,pForm,pMethod){

  var _pForm = pForm;
  var _pMethod = pMethod;
  window.opener.loader_obj("Y");
 
  alert(_pMethod);
  alert(pUrl);
  $.ajax({
	  type: "POST",
      dataType:"json",
      url: pUrl,
      headers: { 'X-Requested-With': 'XMLHttpRequest' },
      data: $("#"+_pForm+"").serialize(),
      //async : false,
      timeout: 600000, //milisecond기준 10분(600000ms) TIMEOUT 
      success:function( response ) {
	    	  
	    	  if(typeof(response.Message) != "undefined" ){
	    		  window.opener.loader_obj("N");
	    		  alert("getPunchoutOrderMessageFromCart1 error");
	    		  window.opener.kepAjaxError(_pMethod, response);
	    	  	  window.close();
	    	  }else if(response.msg.MSG != 'UPDATE_OK'){
	    		  window.opener.loader_obj("N");
	    		  alert("getPunchoutOrderMessageFromCart1 error");
	    		  window.opener.kepAjaxError(_pMethod, response);
	    	  	  window.close();
		      }else{
		    	  sendPunchoutOrderMessage(response.msg.URL, response.msg.XML, pForm, pMethod);
		      }
      },
      error:function( response ) {
		   	//loader_obj("N");
		   	//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
			if(response.status == '403'){
				alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
				window.opener.location.href = "/login/sub_login.do";
				return;
			}
			alert("getPunchoutOrderMessageFromCart2 error");
			window.opener.kepAjaxError(_pMethod, response);
  	  	  	window.close();
	   }
  });

}

function sendPunchoutOrderMessage(sendUrl, punchoutOrderMessageXML, pForm, pMethod){

  var _sendUrl = sendUrl;
  var _punchoutOrderMessageXML = punchoutOrderMessageXML;
  var _pForm = pForm;
  var _pMethod = pMethod;
 
  alert("XML : "+_punchoutOrderMessageXML);
  $.ajax({
      data: {"cxml-urlencoded":_punchoutOrderMessageXML},
      type: "POST",
      url: _sendUrl,
      contentType: "application/x-www-form-urlencoded; charset=UTF-8",
      crossDomain: true,
      dataType: "text",
      success : function( response ) {
		        deletePunchoutCart(_pForm,_pMethod,_sendUrl);
    	  		//alert("success");
      },
      error : function ( response, textStatus ){
    	      window.opener.loader_obj("N");
    	  	  alert("sendPunchoutOrderMessage error");
    	  	  window.opener.kepAjaxError(_pMethod, response);
    	  	  window.close();
      }
  });
}

function deletePunchoutCart(pForm, pMethod, sendUrl){
	var _pForm = pForm;
	var _pMethod = pMethod;
	var _sendUrl = sendUrl;
	$.ajax({
		  type: "POST",
	      dataType:"json",
	      url: "/mpso/deletePunchoutOrderMessageShoppingcart.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: $("#"+_pForm+"").serialize(),
	      //async : false,
	      timeout: 600000, //milisecond기준 10분(600000ms) TIMEOUT 
	      success:function( response ) {
	    	      window.opener.loader_obj("N");
		    	  window.opener.location.href = _sendUrl;
		    	  window.close();
	      },
	      error:function( response, textStatus ) {
	    	    window.opener.loader_obj("N");
			   	alert("deletePunchoutCart3 error");
			   	window.opener.kepAjaxError(_pMethod, response);
			   	window.close();
		   }
	  });
}
</script>
</body>
</html>
