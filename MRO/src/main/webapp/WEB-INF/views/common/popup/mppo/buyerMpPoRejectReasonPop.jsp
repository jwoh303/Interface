<%--
**********************************************
* 메뉴 : 
* 화면 : 반려사유
* 기능 : 구매요청 반려 시 반려사유 입력 팝업
* 프로그램 ID : PG_06_B_016_02
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-06-23
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
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
<script src="/resources/js/kep_common.js"></script> 
</head>  
<%
 
String openYn           = CommonUtil.nvl((String) request.getParameter("openYn"),"");
String returnGbn           = CommonUtil.nvl((String) request.getParameter("returnGbn"),"");
String title = "반려 ";
String title2 = "반려 ";

if("R".equals(returnGbn)){
	title = "불채택 ";
	title2 = "불채택";
}else{
	if ("O".equals(openYn)){
		title = "";
		title2 = "진행";
	}
}
%>

<script type="text/javascript">
function setSave(){
	var value = TrimCommon(document.forms.buyerMpPoRejectReasonPop.textarea2.value); 
    
	if(!isEmpty(value)) {
		
	   if(!confirm("선택한 목록을 <%=title2%> 하시겠습니까?  ")) {
	        return;
	    }
		opener.setReason(value);
	}
	self.close();
}

function chk_byte(max_byte){

  if (kepGetByteLength("textarea2") > max_byte) {
          alert("사유는 한글 50자(영문 100자) 이상 입력할 수 없습니다.");
         // $("#textarea2").val("");
          $("#textarea2").focus();
  }
 
	     
}
</script> 
<body onload="">
<form name="buyerMpPoRejectReasonPop" id="buyerMpPoRejectReasonPop" method=post > 
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:270px;">
    	<div id="popHeader">
        	<h1 class="title"><%=title%>사유</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
                 
     			<table class="cont_t_list05" style="background-color: #FAF9CF;">
				<tr > 
					<td style="width:100%"><%=title%>사유</td> 
				</tr>

            </table>
 			<table >
                <tr>
                    <td height="5"></td>
                </tr>
            </table >
             <table class="cont_t_list05">
                <tr> 
                    <td >
                        <textarea name="textarea2" id="textarea2"  style="width:100%; overflow:auto; border-color:white; border-width:0;" rows="4" cols="15"   onkeyup="chk_byte( 100);"></textarea>
                    </td>
                </tr>
            </table>   
            <br>
 		<div class="btnArea">
		 <span class="btn_02 mr04" title="확인" > <a href="javascript:setSave();">확인</a></span>
	    </div>
		            
		            
    </div>        
</div>
</form> 
</body>
</html>
