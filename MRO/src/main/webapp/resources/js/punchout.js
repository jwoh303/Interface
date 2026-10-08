
/**
 * 
 */

function getPunchoutOrderMessageFromCart(pUrl,pForm,pMethod){

	  var _pForm = pForm;
	  var _pMethod = pMethod;
	  loader_obj("Y");

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
		    		  loader_obj("N");
		    		  alert("getPunchoutOrderMessageFromCart1 error");
			    	  kepAjaxError(_pMethod, response);
		    	  }else if(response.msg.MSG != 'UPDATE_OK'){
		    		  loader_obj("N");
		    		  alert("getPunchoutOrderMessageFromCart1 error");
			    	  kepAjaxError(_pMethod, response);
			      }else{
			    	  deletePunchoutCart(pForm, pMethod, response.msg.URL, response.msg.XML);
			      }
	      },
	      error:function( response ) {
			   	loader_obj("N");
			   	//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
				if(response.status == '403'){
					alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
					location.href = "/login/sub_login.do";
					return;
				}
				alert("getPunchoutOrderMessageFromCart2 error");
				kepAjaxError(pMethod, response);
		   }
	  });

	}


function deletePunchoutCart(pForm, pMethod, sendUrl, cxml){
	var _pForm = pForm;
	var _pMethod = pMethod;
	var _sendUrl = sendUrl;
	var _cxml = cxml;
	$.ajax({
		  type: "POST",
	      dataType:"json",
	      url: "/mpso/deletePunchoutOrderMessageShoppingcart.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: $("#"+_pForm+"").serialize(),
	      //async : false,
	      timeout: 600000, //milisecond기준 10분(600000ms) TIMEOUT 
	      success:function( response ) {
	    	  
		    	  var _form = document.forms.punchoutexit;

		    	  var obj = document.getElementById("cxml-urlencoded");
		    	  obj.value = _cxml;
		    	  
		    	  _form.action = _sendUrl;
		    	  _form.target = "_top";
		    	  _form.submit();
		    	  
		    	  loader_obj("N");
	      },
	      error:function( response, textStatus ) {
			   	loader_obj("N");
			   	alert("deletePunchoutCart error");
			   	kepAjaxError(_pMethod, response);
		   }
	  });
}
function emulAcceptCharset(form) {

    if (form.canHaveHTML) { // detect IE
        document.charset = form.acceptCharset;
    }
    return true;
}



/*
function getPunchoutOrderMessageFromCart(pUrl,pForm,pMethod){

  var _pForm = pForm;
  var _pMethod = pMethod;
  loader_obj("Y");

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
	    		  loader_obj("N");
	    		  alert("getPunchoutOrderMessageFromCart1 error");
		    	  kepAjaxError(_pMethod, response);
	    	  }else if(response.msg.MSG != 'UPDATE_OK'){
	    		  loader_obj("N");
	    		  alert("getPunchoutOrderMessageFromCart1 error");
		    	  kepAjaxError(_pMethod, response);
		      }else{
		    	  sendPunchoutOrderMessage(response.msg.URL, response.msg.XML, pForm, pMethod);
		      }
      },
      error:function( response ) {
		   	loader_obj("N");
		   	//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
			if(response.status == '403'){
				alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
				location.href = "/login/sub_login.do";
				return;
			}
			alert("getPunchoutOrderMessageFromCart2 error");
			kepAjaxError(pMethod, response);
	   }
  });

}


function sendPunchoutOrderMessage(sendUrl, punchoutOrderMessageXML, pForm, pMethod){

  var _sendUrl = sendUrl;
  var _punchoutOrderMessageXML = punchoutOrderMessageXML;
  var _pForm = pForm;
  var _pMethod = pMethod;
  //원복하려면 하기 주석 삭제.
  //popup_dev(_sendUrl,_punchoutOrderMessageXML,_pForm,_pMethod);
  //return;
 //////////////////////
  $.ajax({
      data: {"cxml-urlencoded":_punchoutOrderMessageXML},
      type: "POST",
      url: _sendUrl,
      contentType: "application/x-www-form-urlencoded; charset=UTF-8",
      crossDomain: true,
//      dataType: "jsonp",
      dataType: "text",
      success : function( response ) {
		        deletePunchoutCart(_pForm,_pMethod,_sendUrl);
      },
      error : function ( response, textStatus ){
    	  	  loader_obj("N");
    	  	  alert("sendPunchoutOrderMessage error");
    	  	  kepAjaxError(_pMethod, response);
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
		    	  loader_obj("N");
			      
//		    	  top.location.href = _sendUrl;
		    	  
		    	  var _form = document.forms.purchoutexit;
		    	  _form.action = _sendUrl;
		    	  _form.target = "_top";
		    	  _form.submit();
	      },
	      error:function( response, textStatus ) {
			   	loader_obj("N");
			   	alert("deletePunchoutCart3 error");
			   	kepAjaxError(_pMethod, response);
		   }
	  });
}

*/
/**/


/*
	function getPunchoutOrderMessageFromCart3(pUrl,pForm,pMethod){

		  var _pForm = pForm;
		  var _pMethod = pMethod;
		  loader_obj("Y");

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
			    		  loader_obj("N");
			    		  alert("getPunchoutOrderMessageFromCart1 error");
				    	  kepAjaxError(_pMethod, response);
			    	  }else if(response.msg.MSG != 'UPDATE_OK'){
			    		  loader_obj("N");
			    		  alert("getPunchoutOrderMessageFromCart1 error");
				    	  kepAjaxError(_pMethod, response);
				      }else{
				    	  sendPunchoutOrderMessage3(response.msg.URL, response.msg.XML, pForm, pMethod, response);
				      }
		      },
		      error:function( response ) {
				   	loader_obj("N");
				   	//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
					if(response.status == '403'){
						alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
						location.href = "/login/sub_login.do";
						return;
					}
					alert("getPunchoutOrderMessageFromCart2 error");
					kepAjaxError(pMethod, response);
			   }
		  });

		}


		function sendPunchoutOrderMessage3(sendUrl, punchoutOrderMessageXML, pForm, pMethod, response){

		  var _sendUrl = sendUrl;
		  var _punchoutOrderMessageXML = punchoutOrderMessageXML;
		  var _pForm = pForm;
		  var _pMethod = pMethod;

		  //원복하려면 하기 주석 삭제.
		  //popup_dev(_sendUrl,_punchoutOrderMessageXML,_pForm,_pMethod);
		  //return;
		  //////////////////////
		  $.ajax({
		      data: {"cxml-urlencoded":_punchoutOrderMessageXML },
		      type: "POST",
		      url: _sendUrl,
		      //url: "https://dsgd8i.oracleoutsourcing.com/OA_HTML/OA.jsp",
		      contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		      crossDomain: true,
		      //dataType: "text",
		      dataType: "jsonp",
		      jsonp: "callback",
		      success : function( response ) {
				        deletePunchoutCart(_pForm,_pMethod,_sendUrl);
		      },
		      error : function ( response, textStatus ){
		    	  	  loader_obj("N");
		    	  	  alert("sendPunchoutOrderMessage error");
		    	  	  kepAjaxError(_pMethod, response);
		      }
		  });
		}
*/
/*테스트 JS*/
/*
function getPunchoutOrderMessageFromCartTEST(pUrl,pForm,pMethod,charset){

  var _pForm = pForm;
  var _pMethod = pMethod;
  loader_obj("Y");

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
	    		  loader_obj("N");
	    		  alert("getPunchoutOrderMessageFromCart1 error");
		    	  kepAjaxError(_pMethod, response);
	    	  }else if(response.msg.MSG != 'UPDATE_OK'){
	    		  loader_obj("N");
	    		  alert("getPunchoutOrderMessageFromCart1 error");
		    	  kepAjaxError(_pMethod, response);
		      }else{
		    	  sendPunchoutOrderMessageTEST(response.msg.URL, response.msg.XML, pForm, pMethod, charset);
		      }
      },
      error:function( response ) {
		   	loader_obj("N");
		   	//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
			if(response.status == '403'){
				alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
				location.href = "/login/sub_login.do";
				return;
			}
			alert("getPunchoutOrderMessageFromCart2 error");
			kepAjaxError(pMethod, response);
	   }
  });

}
*/
	/*
function sendPunchoutOrderMessageTEST(sendUrl, punchoutOrderMessageXML, pForm, pMethod, charset){

  var _sendUrl = sendUrl;
  var _punchoutOrderMessageXML = punchoutOrderMessageXML;
  var _pForm = pForm;
  var _pMethod = pMethod;

  var _charset = charset;
  alert("CHARSET : "+_charset);
  if(_charset != ""){
	  _charset = "; charset="+_charset;
  }
  alert("CHARSET : "+_charset);
  alert("XML : "+_punchoutOrderMessageXML);
  $.ajax({
      data: {"cxml-urlencoded":_punchoutOrderMessageXML},
      type: "POST",
      url: _sendUrl,
      contentType: "application/x-www-form-urlencoded"+_charset,
      crossDomain: true,
      dataType: "text",
      success : function( response ) {
		        deletePunchoutCart(_pForm,_pMethod,_sendUrl);
    	  		//alert("success");
      },
      error : function ( response, textStatus ){
    	      $("#st_xmlText").val(_punchoutOrderMessageXML);
    	  	  loader_obj("N");
    	  	  alert("sendPunchoutOrderMessage error");
    	  	  kepAjaxError(_pMethod, response);
      }
  });
}

*/

//function getPunchoutOrderMessageFromCartTest3(pUrl,pForm,pMethod){
//
//	  var _pForm = pForm;
//	  var _pMethod = pMethod;
//	  loader_obj("Y");
//
//	  $.ajax({
//		  type: "POST",
//	      dataType:"json",
//	      url: pUrl,
//	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
//	      data: $("#"+_pForm+"").serialize(),
//	      //async : false,
//	      timeout: 600000, //milisecond기준 10분(600000ms) TIMEOUT 
//	      success:function( response ) {
//		    	  
//		    	  if(typeof(response.Message) != "undefined" ){
//		    		  loader_obj("N");
//		    		  alert("getPunchoutOrderMessageFromCart1 error");
//			    	  kepAjaxError(_pMethod, response);
//		    	  }else if(response.msg.MSG != 'UPDATE_OK'){
//		    		  loader_obj("N");
//		    		  alert("getPunchoutOrderMessageFromCart1 error");
//			    	  kepAjaxError(_pMethod, response);
//			      }else{
//			    	  sendPunchoutOrderMessageTest3(response.msg.URL, response.msg.XML, pForm, pMethod);
//			      }
//	      },
//	      error:function( response ) {
//			   	loader_obj("N");
//			   	//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
//				if(response.status == '403'){
//					alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
//					location.href = "/login/sub_login.do";
//					return;
//				}
//				alert("getPunchoutOrderMessageFromCart2 error");
//				kepAjaxError(pMethod, response);
//		   }
//	  });
//
//	}
//function sendPunchoutOrderMessageTest3(sendUrl, punchoutOrderMessageXML, pForm, pMethod){
//
//	  var _sendUrl = sendUrl;
//	  var _punchoutOrderMessageXML = punchoutOrderMessageXML;
//	  var _pForm = pForm;
//	  var _pMethod = pMethod;
//	  //원복하려면 하기 주석 삭제.
//	  popup_dev(_sendUrl,_punchoutOrderMessageXML,_pForm,_pMethod);
//	  return;
//	}
