<%--
**********************************************
* 메뉴 : 주문관리>주문진행관리>주문진행>협력사 DM 발송>메일 읽기
* 화면 : 메일 읽기
* 기능 : 메일 읽기
* 프로그램 ID : 
* 담당자 : 임태성
* 착수일 : 2024-04-17
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<% 
	String st_com_code_name = CommonUtil.nvl((String) request.getParameter("st_com_code_name"),"");//(st_com_code_name)
	String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");//(st_com_code)
	String agentDmMemo = CommonUtil.nvl((String) request.getParameter("agentDmMemo"),"");//(agentDmMemo)
	String dmissueObj = request.getParameter("dmissueObj");//(dmissueObj)
	String userEmail = CommonUtil.nvl((String) request.getParameter("userEmail"),"");//(userEmail)
	String mailSubject = CommonUtil.nvl((String) request.getParameter("mailSubject"),"");//(mailSubject)
	String mailContents = request.getParameter("mailContents");//(mailContents)
	String recvInfo = CommonUtil.nvl((String) request.getParameter("recvInfo"),"");//(recvInfo)
	String sendTel = CommonUtil.nvl((String) request.getParameter("sendTel"),"");//(sendTel)
	String sendName = CommonUtil.nvl((String) request.getParameter("sendName"),"");//(sendName)
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
	const dateSeparator = ".";
	const timeSeparator = ":";
	const strHeaderName = "headerName";
	const strHeaderWidth = "headerWidth";
	const HeaderNameIdx = 0;
	const HeaderWidthIdx = 1;
	
	// 현제시간을 메일 template에 적용
	$(".mailTime").html(getNowDatetime(dateSeparator, timeSeparator));

	// 운영자 메모 표시/비표시
//	let agentDmMemo = $("#agentDmMemo").val();
//	if(agentDmMemo == '' || agentDmMemo == null){
//		$(".memoDiv").hide();
//	}

	// 메일 컨텐츠 내부 구분자 변환 처리
	$(".mailContents").html(convMailContents($(".mailContents")[0].innerHTML));

	// 이슈 정보 호출
	const dmIssueData = $("#dmissueObj").val();
	
	// 테이블 선택
	let tbl = document.getElementById("dmIssueTb");
	let headerFlg = true; // table 헤더 flg (첫줄은 헤더)
	// 넘어온 param에 따라 table 작성

	JSON.parse(reJsonParse(dmIssueData)).forEach((obj) => {
		// row 생성
		let row = addTableRow(tbl);
		// object의 키 개수 만큼 반복
		if(headerFlg){ // th삽입
			Object.keys(obj).forEach((key) => {
				setCellData(addTableCell(row), obj[key][HeaderNameIdx][strHeaderName], true, obj[key][HeaderWidthIdx][strHeaderWidth]);
			});
			headerFlg = false;
		}else {
			Object.keys(obj).forEach((key) => {
				setCellData(addTableCell(row), obj[key], false);
			});
		}
	});
	
	var memoDiv2 = "<%=agentDmMemo%>";
	memoDiv2 = memoDiv2.replaceAll('&lt;','<');
	memoDiv2 = memoDiv2.replaceAll('&gt;','>');	
	$('#memoDiv2').html(memoDiv2);
}

/*
 * tr 추가
 * param object table
 * return object row
 */
function addTableRow(table){
	return table.insertRow();
}

/*
 * td 추가
 * param object row
 * return object cell
 */
function addTableCell(row){
	return row.insertCell();
}

/*
 * param 데이터 세팅
 * param object cell
 * param String cellText
 * param boolean thFlg
 * param int width
 */
function setCellData(cell, cellText, thFlg, width){
	if(thFlg){
		let optionWidth = "";
		if(width != 0 || width != 'undefined' || width != null){
			optionWidth = "width=" + width + "px";
		}
		cell.outerHTML = '<th class="tblTh" '+ optionWidth +'>'+cellText+"</th>";
	}else{
		cell.appendChild(document.createTextNode(cellText));
	}
}

/**
 * jparse error 대응부분 복원(마지막 콤마 제외)
 * param String data
 * return String convData 
 */
function reJsonParse(data){
	let convData;
	const singleQuote = "'";
	const doubleQuote = '"';
	const singleQuoteSeparator = "^s^s^s^";
	const doubleQuoteSeparator = "^d^d^d^";
	const comma = ",";

	// 복원 처리
	convData = data;
	convData = convData.replaceAll(singleQuoteSeparator, singleQuote);
	convData = convData.replaceAll(doubleQuoteSeparator, doubleQuote);

	return convData;
}

/**
 * 구분자 ^c^c^를 @로 복원후 반환
 * param  String target 변경 대상 메일 콘텐츠
 * return String mailContents
 */
function convMailContents(target){
	const templateSeparator = "@";
	const convSeparator = "^c^c^";

	// 앞 뒤 공백제거 및 구분자 복원
	return mailContents = target.trim().replaceAll(convSeparator, templateSeparator);
}

/*
 * 현재 시간을 형식에 맞춰서 가져옴 
 * param String dateSeparator 날짜 구분자 ex) 2024.04.20
 * param String timeSeparator 시간 구분자 ex) 11:04
 * return String dateTime ex) 2024.04.20 11:04
 */
function getNowDatetime(dateSeparator, timeSeparator){
	
	// 현재시간 mailTime에 넣기
	let now = new Date();
	let year = now.getFullYear();
	let month = ('0'+(now.getMonth()+1)).slice(-2); // getMonth의 return값은 0(1월) ~ 11(12월)이기 때문에 + 1을 가산
	let day = ('0'+(now.getDate())).slice(-2);
	let hour = ('0'+(now.getHours())).slice(-2);
	let minute = ('0'+(now.getMinutes())).slice(-2);
	
	let dateTime = year + dateSeparator + month + dateSeparator + day + " "
					+ hour + timeSeparator + minute;
	return dateTime;
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
				<span class="mailTitle"><%=mailSubject%></span><span class="mailTime"></span>
			</div>
			<div class="mailSender">
				<span><%=userEmail%></span>
			</div>
			<div class="mailRecv">
				<span><span class="textBold">받는이</span> <%=recvInfo%></span>
			</div>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
			<input type="hidden" id="dmissueObj" name="dmissueObj" value='<%=dmissueObj%>'> 
			<input type="hidden" id="agentDmMemo" name="agentDmMemo" value='<%=agentDmMemo%>'> 
			<!-- <div id="searchBtnA02">
			<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
			</div> -->
			<div style="margin:0 auto; width:940px; position:relative; color:#000;line-height:20px;  font-size:14px;  letter-spacing:-0.5px; font-family:맑은 고딕" >
				
				 <div style="height:20px;border-bottom:8px solid #7b6f6c;margin: 40px 0 0 0;padding-bottom: 10px;" >
				 <img src="/resources/images/mail/main_img/kep_en.png" width="180px">
				 </div>
				 <div style="height:100px; line-height:115px; text-align:center; font-size:25px; letter-spacing:-1px; font-weight:bold; background-color:#eeeceb"> <span style="color:#e8340c">수주내역</span>  확인요청 드립니다.</span> </div>
				 <div style="padding:30px 20px 5px 20px; ">
					<Contents class="mailContents">
						<%=mailContents%>
					</Contents>

					<div class="memoDiv" style="height: 110px; background-color:#F2DCDB; margin:15px 0 15px 0; padding: 10px; display: block;">
						<span style="font-weight:bold;">※ KeP 요청사항 (담당자: <%=sendName%> | <%=sendTel%>)</span><br>
						<div id="memoDiv2"></div>
					</div>

					<h1 style="font-size:15px;font-weight:bold;color:#000;position: initial;margin: 5px 0 5px 0;">[확인요청 리스트]</h1>	
					<table id="dmIssueTb" class="dmIssueTb" width="900px" border="1" style="border:1px solid #d5d5d5;border-top:#6d6d6d 2px solid;border-collapse:collapse; font-size:13px;">
					</table>

					<div style="margin-top: 15px;">
						본 메일은 발신전용 입니다. </br>
						자세한 문의는 KeP 담당자에게 연락 바랍니다.
					</div>
				</div>
				<div style=" display:block; margin:0 auto; padding:10px; text-align:center;  background-color:#eeeceb; border-bottom:1px solid #7b6f6c">
					<img src="/resources/images/mail/main_img/mail_bottom_3.png" border="0" />
				</div>
			</div>  
		</div>
	</div>
</body>
</html>
