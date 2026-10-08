<%--
**********************************************
* 메뉴 : 
* 화면 : 계약취소사유 등록
* 기능 : 
* 프로그램 ID : PG_02_M_003_02
* 담당자 : 개발자3 ( 설계 : 권우재 )
* 착수일 : 2014-
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
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
String mode = CommonUtil.nvl((String) request.getParameter("mode"),"");  //  (조회조건)
String modeTitle = "";
if (mode.equals("contWithdraw")) {
	modeTitle = "회수사유";
} else if (mode.equals("contRevoke")) {
	modeTitle = "취소사유";
} else if (mode.equals("contRevokeOS2")) {
	modeTitle = "계약취소사유";	
} else if (mode.equals("contCancel")) {
	modeTitle = "계약해지사유";
} else if (mode.equals("contReject")) {
	modeTitle = "반려사유";
} else if (mode.equals("contChange")) {
	modeTitle = "계약변경사유";
}
%>

<script type="text/javascript">
<!--
//기능함수
function doAction(str) {
	switch (str) {
		case "save":	 // 조회
			if (checkSubmit()) {
				setReturn($("#notice").val());
			}
			break;
	}
}

function checkSubmit() {
	if (kepTrimStr($("#notice").val()) == "") {
		alert("사유를 입력하세요");
		return false;
	}
	return true;
}
	
function setReturn(value1, value2) { 
  opener.setPopupReturn(value1, value2);
  this.close();
}
 //-->
</script> 
<body onload="">
<form name="masterMdCtContractCancleRegPop" id="masterMdCtContractCancleRegPop" method="post">
<input type="hidden" name="mode" id="mode"  value="<%=mode%>" />
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:294px;">
    	<div id="popHeader">
        	<h1 class="title"><%=modeTitle%> 등록</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
			<!--grid-->
			<div class="contArea" style="height:140px">
				<table  class="cont_t_list02"  style="width:100%">
					<caption><%=modeTitle%></caption>
					<colgroup>
						<col width="20%" /> 
						<col width="*" /> 
					</colgroup>
					<tbody>
						<tr>
							<th>비고</th>
							<td><textarea id="notice" name="notice" style="width:98%; height:100px;"></textarea></td>
						</tr> 
					</tbody>
				</table>                  
			</div>
			<!--버튼영역-->
			<div class="btnArea mb05">
				<span class="fr">
					<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
				</span>	
			</div>
		</div>        
	</div>
</form> 
</body>
</html>
