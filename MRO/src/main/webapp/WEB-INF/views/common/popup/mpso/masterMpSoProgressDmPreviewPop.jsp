<%--
**********************************************
* 메뉴 : 주문진행>고객사DM발송>미리보기
* 화면 :
* 기능 :
* 프로그램 ID :
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<% 
	
	String st_mail_remark = CommonUtil.nvl((String) request.getParameter("st_mail_remark"),"");//(st_mail_remark)
	String dmissueObj = request.getParameter("dmissueObj");//(dmissueObj)
	String st_send_mail = CommonUtil.nvl((String) request.getParameter("st_send_mail"),"");//(userEmail)
	String st_mail_subject = CommonUtil.nvl((String) request.getParameter("st_mail_subject"),"");//(mailSubject)	
	String st_recv_mail = CommonUtil.nvl((String) request.getParameter("st_recv_mail"),"");//(recvInfo)
	String st_send_user_tel = CommonUtil.nvl((String) request.getParameter("st_send_user_tel"),"");//(st_send_user_tel)
	String st_send_user_name = CommonUtil.nvl((String) request.getParameter("st_send_user_name"),"");//(st_send_user_name)
	String st_send_user_mail = CommonUtil.nvl((String) request.getParameter("st_send_user_mail"),"");//(st_send_user_mail)	
	
	String st_polist = CommonUtil.nvl((String) request.getParameter("st_polist"),"");	
	
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
</style>
<script type="text/javascript">
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	const dateSeparator = ".";
	const timeSeparator = ":";
	
	// 현제시간을 메일 template에 적용
	$(".mailTime").html(getNowDatetime(dateSeparator, timeSeparator));

	hdQuery();
	var st_mail_remark = "<%=st_mail_remark%>";
	st_mail_remark = st_mail_remark.replaceAll('&lt;','<');
	st_mail_remark = st_mail_remark.replaceAll('&gt;','>');	
	$('#memoDiv2').html(st_mail_remark);
	
}

function hdQuery(){
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mpso/getMasterMpSoProgressDmPreviewPopList.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: { st_polist: $("#st_polist").val() },
		async: true,
		success: function( response ) {			
			if (response.data.length > 0){
				var po_no = "";
				var buyer_item_no = "";
				var description = "";
				var specification = "";
				var po_qty = "";
				var unit_price = "";
				var item_amt = "";
				var req_user_name = "";
				var contents_header = "<tr><th class='tblTh'>발주번호</th><th class='tblTh'>품목코드</th><th class='tblTh'>품명</th><th class='tblTh'>규격</th><th class='tblTh'>수량</th><th class='tblTh'>단가</th><th class='tblTh'>금액</th><th class='tblTh'>요청자</th></tr>";
				var contents_row = "";
				
				for(var i=0; i<response.data.length;i++){
					po_no = $.trim(eval("response.data[i].PO_NO"));
					buyer_item_no = $.trim(eval("response.data[i].BUYER_ITEM_NO"));
					description = $.trim(eval("response.data[i].DESCRIPTION"));
					specification = $.trim(eval("response.data[i].SPECIFICATION"));
					po_qty = $.trim(eval("response.data[i].PO_QTY"));
					unit_price = kepNumComma2(Number($.trim(eval("response.data[i].UNIT_PRICE"))));
					item_amt = kepNumComma2(Number($.trim(eval("response.data[i].ITEM_AMT"))));
					req_user_name = $.trim(eval("response.data[i].REQ_USER_NAME"));
					
					
					contents_row += "<tr><td style='width:90px'>"+po_no+"</td><td style='width:110px'>"+buyer_item_no+"</td><td>"+description+"</td><td>"+specification+"</td><td style='width:50px'>"+po_qty+"</td><td style='width:60px; text-align: right;'>"+unit_price+"</td><td style='width:60px; text-align: right;'>"+item_amt+"</td><td style='width:70px'>"+req_user_name+"</td></tr>";
				}
				
				$("#dmIssueTb").html(contents_header+contents_row);
			}
		},
		error: function( response ) {
			alert("오류발생하였습니다.");
		}
	});
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
	let month = ('0'+(now.getMonth()+1)).slice(-2);
	let day = ('0'+(now.getDate())).slice(-2);
	let hour = ('0'+(now.getHours())).slice(-2);
	let minute = ('0'+(now.getMinutes())).slice(-2);
	
	let dateTime = year + dateSeparator + month + dateSeparator + day + " "
					+ hour + ":" + minute;
	return dateTime;
}
</script> 
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
		<div id="popHeader">
			<h1 class="title">고객사 DM 발송 (미리보기)</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
		</div>
		
		<div class="mailHeader">
			<div class="mailTitleArea">
				<span class="mailTitle"><%=st_mail_subject%></span><span class="mailTime"></span>
			</div>
			<div class="mailSender">
				<span><%=st_send_mail%></span>
			</div>
			<div class="mailRecv">
				<span><span class="textBold">수신자 :</span> <%=st_recv_mail%></span>
			</div>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
			<input type="hidden" id="dmissueObj" name="dmissueObj" value="<%=dmissueObj%>">
			<input type="hidden" id="st_mail_remark" name="st_mail_remark" value="<%=st_mail_remark%>">
			<input type="hidden" id="st_polist" name="st_polist" value="<%=st_polist%>"> 
			
			
			<div style="margin:0 auto; width:940px; position:relative; color:#000;line-height:20px;  font-size:14px;  letter-spacing:-0.5px; font-family:맑은 고딕" >
				<div style="height:20px;border-bottom:8px solid #7b6f6c;margin: 40px 0 0 0;padding-bottom: 10px;" >
					<img src="/resources/images/mail/main_img/kep_en.png" width="180px">
				</div>
				<div style="height:100px; line-height:115px; text-align:center; font-size:25px; letter-spacing:-1px; font-weight:bold; background-color:#eeeceb">
					<span style="color:#e8340c">발주</span> 관련 확인 요청드립니다.</span>
				</div>
				<div style="padding:30px 20px 5px 20px; ">					
					<div class="memoDiv" style="height: 180px; background-color:#F2DCDB; margin:15px 0 15px 0; padding: 10px; display: block;">
						<span style="font-weight:bold;">※ KeP 요청사항 <span style="font-size:16px">(담당자: <%=st_send_user_name%> | <%=st_send_user_tel%> | <font color="RED"><%=st_send_user_mail%></font>)</span></span>
						<br><br>
						<div id="memoDiv2"><%=st_mail_remark%></div>
					</div>
					<h1 style="font-size:15px;font-weight:bold;color:#000;position: initial;margin: 5px 0 5px 0;">[확인요청 리스트]</h1>	
					<table id="dmIssueTb" class="dmIssueTb" width="900px" border="1" style="border:1px solid #d5d5d5;border-top:#6d6d6d 2px solid;border-collapse:collapse; font-size:13px;">					
					</table>
					<div>
						자세한 문의는 상단의 KeP 담당자에게 별도 메일 발송 부탁드립니다.
					</div>
				</div>
				<div style=" display:block; margin:0 auto; padding:10px; text-align:center;  background-color:#eeeceb; border-bottom:1px solid #7b6f6c">
					<img src="/resources/images/mail/main_img/mail_bottom_3.png" border="0"/>
				</div>
			</div>  
		</div>
	</div>
</body>
</html>
