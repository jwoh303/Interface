<%--
**********************************************
* 메뉴 : 벌크소싱 견적현황 > 협력사 메일발송 > 미리보기
* 화면 : 메일 미리보기
* 기능 : 메일 미리보기
* 프로그램 ID : 
* 착수일 : 2025-10-01
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<% 
	String agentDmMemo = CommonUtil.nvl((String) request.getParameter("agentDmMemo"),"");// 이전 팝업에서 입력한 운영자메모
	String sendInfo = CommonUtil.nvl((String) request.getParameter("sendInfo"),""); // 보낸이 정보
	String recvInfo = CommonUtil.nvl((String) request.getParameter("recvInfo"),"");// 받는이 정보
	String agentMngUserName = CommonUtil.nvl((String) request.getParameter("st_agent_mng_user_name"),"");// 일괄담당자 이름
	String agentMngUserTel = CommonUtil.nvl((String) request.getParameter("st_agent_mng_user_tel"),"");// 일괄담당자 연락처
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
	
	.dmIssueTb td{
		padding:0 5px;
		text-align:center;
		height:41px;
	}
	.mailHeader {
		margin: 0 auto;
		width: 1020px;
		background-color: #eeeceb;
		height: 100px;
		position: relative;
		margin-top: 10px;
	}
	.mailTitleArea {
		display: flex;
		justify-content: space-between;
	}
	.mailTitle{
		font-family: "맑은 고딕";
		font-weight: bold;
		color: black;
		font-size: 25px;
		padding: 25px 0 0 15px;
		letter-spacing: -1px;
	}
	.mailTime{
		padding: 25px 15px 0 0;
	}
	.mailSender{
		padding: 15px;
		color:black;
	}
	.mailRecv{
		padding: 15px;
		color:black;
	}
	.textBold{
		font-weight: bold;
		color:black;
	}
	.mailContents{
		white-space: pre;
	}
	.tblTh{
		text-align:center;
		font-weight:bold; 
		background-color:#BDBDBD; 
		vertical-align:middle; 
		color:#313131;
		height:50px;
	}
-->
</style>
<script type="text/javascript">
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
}

</script> 
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
		<div id="popHeader">
			<h1 class="title">메일 읽기</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
		</div>
		
		<div class="mailHeader">
			<div class="mailTitleArea">
				<span class="mailTitle">[KoreaB2B.com] 견적요청 회신 부탁 드립니다.</span><span class="mailTime"></span>
			</div>
			<div class="mailSender">
				<span><%=sendInfo%></span>
			</div>
			<div class="mailRecv">
				<span><span class="textBold">받는이</span><%=recvInfo%></span>
			</div>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
			<div style="margin:0 auto; width:940px; position:relative; color:#000;line-height:20px;  font-size:14px;  letter-spacing:-0.5px; font-family:맑은 고딕" >
				
				 <div style="height:20px;border-bottom:8px solid #7b6f6c;margin: 40px 0 0 0;padding-bottom: 10px;" >
				 <img src="/resources/images/mail/main_img/kep_en.png" width="180px">
				 </div>
				 <div style="height:100px; line-height:115px; text-align:center; font-size:25px; letter-spacing:-1px; font-weight:bold; background-color:#eeeceb">
				 	 <span style="color:#e8340c">견적요청</span> 회신 부탁 드립니다.</span> 
				</div>
				 <div style="padding:30px 20px 5px 20px; ">
					<Contents class="mailContents">
안녕하세요, 코리아이플랫폼입니다.<br>귀사에 전달드린 견적요청 중 아직 회신되지 않은 건이 있어 안내드립니다.<br><br>📌 확인 방법<br>시스템(www.KoreaB2B.com)에 접속하신 후 , [견적관리 > 벌크견적요청 접수] 메뉴에서 미회신 건을 확인해 주세요.
						<br><br>📣 담당자 메시지<br>
<%=agentDmMemo%><br><br>※ 본 메일은 자동으로 발송되었습니다. 문의사항은 아래 담당자에게 연락 부탁드립니다.<br><br>문의: [<%=agentMngUserName %> ] / [<%=agentMngUserTel %> ]<br>감사합니다.
						
					</Contents>
				</div>
				<div style=" display:block; margin:0 auto; padding:10px; text-align:center;  background-color:#eeeceb; border-bottom:1px solid #7b6f6c">
					<img src="/resources/images/mail/main_img/mail_bottom_3.png" border="0" />
				</div>
			</div>  
		</div>
	</div>
</body>
</html>
