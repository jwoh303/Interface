<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<script type="text/javascript">
  function popctrl_cookie_test(){ 
    if ($("#popctrl").val() == "Y"){
     $.cookie('popctrl_cookie', 'close', { expires: 1}); 
     window.close();
    }
   } 
 </script>
<body>
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">팝업예제</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<p>공지사항샘플</p> 
        </div>
    </div>
           		 <!--버튼영역-->
			<div class="btnArea">
				  
				 <span class="mr04">오늘하루 열지 않습니다.
				 <input type="checkbox" name="popctrl" id="popctrl" value="Y" onclick="javascript:popctrl_cookie_test()">			
				</span>      
            </div>
</body>
</html>
