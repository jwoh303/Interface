<%--
**********************************************
* 메뉴 : 회원사관리>협력사관리>이메일/문자 발송내역 관리>발송 내용
* 화면 : 발송 내용
* 기능 : 
* 프로그램 ID : 
* 담당자 : 임태성
* 착수일 : 2024-03-21
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<% 
	String SMS_CONTENTS = CommonUtil.nvl((String) request.getParameter("SMS_CONTENTS"),"");
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
 
</head>
<style type="text/css">
<!--
	h2 { 
		width: 500px;
		font-family: "맑은 고딕";
		font-weight: bold;
		font-size: 18px;
		color: #333333;
		text-align: left;
		letter-spacing: -1px;
		margin-bottom: 10px; 
	}
	.cont_t_list02 td,th{
		border: 1px solid #cdcdcd;
	}
-->
</style>
<script type="text/javascript">
$(function(){
	// POST 전송시 separator로 인해 변경한 문자열 복원
	let smsContents = $("#smsContents").val();
	$("#smsTextArea").val(smsContents.replace("^&^&", "@@"));
});
</script> 
<body>
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:270px;">
		<div id="popHeader">
			<h1 class="title">발송 내용</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
			<!-- SMS 영역 -->
			<div class="mail_area">
				<table class="cont_t_list06 mb15" summary="발신 내용" style="width:100%;">
					<caption>발신 내용</caption>
					<colgroup>
						<col width="25%" />
						<col width="65%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">SMS발송문구<!-- 발송문구 --></th>
							<td style="padding-left: 0px;">
								<input type="hidden" name="smsContents" id="smsContents" value="<%=SMS_CONTENTS%>">
								<textarea rows="12" name="smsTextArea" id="smsTextArea" style="padding-left: 5px; width:99.5%" readonly></textarea>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</body>
</html>
