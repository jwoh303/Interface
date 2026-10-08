<%--
**********************************************
* 메뉴 : 
* 화면 : 역발행 메일 요청 팝업
* 기능 : 
* 프로그램 ID :
* 담당자 :
* 착수일 :
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	SessionInfo _sessionInfo = (SessionInfo)request.getSession().getAttribute("sessionInfo");
	String st_recv_mail	= CommonUtil.nvl((String)request.getParameter("recv_email"),"");
%>

<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="screen" href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/js/smartbill_common.js"></script>
<script>
var popupSel = "";
function popupOnload(){
}

//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case  "save":
			if (checkSubmit()) {
				var value1 = $("#st_new_email").val();
				opener.setPopupReturn(value1);
				this.close();
			}
			
			break;
	}
}
function checkSubmit() {
    if(isEmpty($("#st_new_email").val())){
        alert("수신자 이메일을 입력해주세요.");
        $("#st_new_email").select();
        return false;
    }
    return true;
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod, response) {	
	if(pMethod == "save"){
		alert("처리중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
	}
	else if (pMethod == "select"){
		alert("처리중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");	
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod, response){
	var sMsg = response.msg;
	if (sMsg == "OK") {
		alert("정상적으로 요청되었습니다.");
		parent.opener.doAction("search");
		this.close();
		return;
	} else {
		alert("요청 처리하던중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
		parent.opener.doAction("search");
		this.close();
		return;
	}
}
</script> 
</head>
<body onload="popupOnload(); ">
<form name = "contentForm"  id = "contentForm" method = "post" onsubmit="return false">
	<input type="hidden" id="st_user_id" name="st_user_id" value="${sessionInfo.userId}">
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">역발행 메일 재전송</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <!--조회영역-->
				<h4><b>역발행 메일 재전송</b></h4>
            	<table class="cont_t_list07" style="width:100%">
						<caption>역발행 메일 재전송</caption>
						<colgroup>
							<col width="30%" />
							<col width="70%" />
						</colgroup>
						<tbody>
	                  	<tr>
							<th scope="row">수신자이메일</th>
							<td>
								<input type="text" id="st_new_email" name="st_new_email" class="input_type_text" title="수신자이메일" value="<%=st_recv_mail%>" style="width:90%"/>
							</td>
						</tr>
					</tbody>
				</table>	
		
            <!--grid-->
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('save')">요청</a></span>
			</span>
			<br/>
		</div>	
        <!--버튼영역-->
    </div>
</form> 
</body>
</html>