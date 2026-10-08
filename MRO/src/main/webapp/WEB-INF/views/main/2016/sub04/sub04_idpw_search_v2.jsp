<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_v2.jspf" %>
<%
String sslurl2 = CommonUtil.getSslURL(request, "https");
%>
<style>
body {margin:0;background:#ecf2fd;display:flex;justify-content:center;align-items:center;height:100vh;}
.container {width:450px;text-align:center;padding:40px 50px 60px 50px;border-radius:20px;background:#fff;box-shadow:0 10px 30px rgba(0,0,0,0.08);}
.logo {width:60px;margin-bottom:15px;}
.title {font-size:37px;font-weight:700;margin-bottom:20px;}
.desc {font-size:15px;color:#595959;margin-bottom:25px;line-height:20px;}
/* 아이디비번찾기 탭 */
.IdPwtabs {display:flex;border-bottom:1px solid #dedede;margin-bottom:20px;}
.IdPwtab {flex:1;text-align:center;padding:10px;margin-top:5px;cursor:pointer;font-size:18px;font-weight:400;color:#888;}
.IdPwtab.active {color:#000;border-bottom:2px solid #000;font-weight:600;}
.IdPwForm {display:none;}
.IdPwForm.active {display:block;}
.IdPwForm button {width:100%;margin-top:20px;}
.input-box {display:flex;align-items:center;margin-bottom:10px;}
.input-box label {width:80px;font-size:16px;font-weight:500;text-align:left;}
.input-box input {flex:1;}
.resend-btn {white-space:nowrap;padding:0 12px;color:#2172EC;font-size:14px;border:0px;background:#ebf3ff;border-radius:6px;cursor:pointer;}
.resend-btn:hover {background:#2172EC;color:#fff;}
.btn {width:380px;height:45px;line-height:45px;font-size:16px;font-weight:500;color:#fff;border:none;border-radius:8px;cursor:pointer;transition:0.2s;background:#2172EC;}
.btn:hover {background:#1a5bbd;}
.blue {color:#2172EC;}
.find-Info-desc {font-size:32px;font-weight:700;letter-spacing:-0.2px;color:#24252B;text-align:center;}
.find-Info-desc img {vertical-align:middle;width:35px;margin-right:15px;}
.find-NoInfo {font-size:22px;font-weight:700;line-height:40px;letter-spacing:-0.2px;color:#000;text-align:center;}
.find-NoInfo img {vertical-align:middle;width:90px;margin-bottom:10px;}
.find-Info {font-size:30px;line-height:50px;font-weight:600;letter-spacing:-0.2px;color:#2172ec;text-align:center;}
.find-Info-BtnBox {display:flex;align-items:center;gap:15px;margin-top:25px;}
.find-Info-BtnBox button {flex:1;}
.InfoBtn {height:45px;line-height:45px;font-size:16px;font-weight:500;color:#fff;border:none;border-radius:8px;cursor:pointer;transition:0.2s;background:#595d7e;}
.InfoBtn:hover {background:#1a5bbd;}
.CustomerCenter {font-size:16px;font-weight:400;line-height:35px;letter-spacing:-0.5px;color:#000;text-align:center;width:auto;height:auto;background-color:transparent;border-radius:0;box-shadow:none;position:static;}
.CustomerCenter span {font-size:18px;padding:8px 25px;font-weight:600;border-radius:50px;}
.CustomerCenter span img {width:30px;margin-right:10px;vertical-align:middle;}
.Popup_GrayBox {background:#f5f5f5;border-radius:10px;padding:15px 20px;font-size:14px;color:#666;line-height:22px;}
.al {text-align:left;}
.mt10 {margin-top:10px;}
.mt20 {margin-top:20px;}
.mt40 {margin-top:40px;}
.mt50 {margin-top:50px;}
.mb40 {margin-bottom:40px;}
.step-wrap {display:none;}
.step-wrap.active {display:block;}
</style>
</head>
<body>
<div>
	<!-- step01: 검색 폼 -->
	<div id="stepSearch" class="step-wrap active">
		<div class="container">
			<img src="/resources/imgs/Icon_key.png" alt="lock" class="logo">
			<div class="title">아이디 / 비밀번호찾기</div>
			<div class="desc">가입한 정보를 입력해 본인 확인을 진행해 주세요.</div>
			<div class="IdPwtabs">
				<div class="IdPwtab active" onclick="switchTab(0)">아이디 찾기</div>
				<div class="IdPwtab" onclick="switchTab(1)">비밀번호 재설정</div>
			</div>
			<!-- 아이디 찾기 폼 -->
			<form id="idSearchForm" class="IdPwForm active">
				<div style="height:50px"></div>
				<div class="input-box"><label>이름</label><input class="input42" type="text" id="id_st_name" name="st_name" placeholder="이름을 입력해주세요."></div>
				<div class="input-box"><label>이메일</label><input class="input42" type="email" id="id_st_mail" name="st_mail_addr" placeholder="이메일 주소를 입력해주세요." onkeydown="if(event.keyCode==13){findId(); return false;}"></div>
				<div style="height:50px"></div>
				<button type="button" class="btn" onclick="findId()">다음</button>
			</form>
			<!-- 비밀번호 재설정 폼 -->
			<form id="pwSearchForm" class="IdPwForm">
				<div class="input-box"><label>이름</label><input class="input42" type="text" id="pw_st_name" name="st_name" placeholder="이름을 입력해주세요."></div>
				<div class="input-box"><label>휴대폰</label>
					<input class="input42" style="width:40px;margin-right:3px" id="pw_phone1" name="st_phone_num1" type="text" maxlength="3" /> -
					<input class="input42" style="width:50px;margin-right:3px;margin-left:3px" id="pw_phone2" name="st_phone_num2" type="text" maxlength="4" /> -
					<input class="input42" style="width:50px;margin-left:3px" id="pw_phone3" name="st_phone_num3" type="text" maxlength="4" />
				</div>
				<div class="input-box"><label>아이디</label><input class="input42" type="text" id="pw_st_id" name="st_id" placeholder="아이디를 입력해주세요." onkeyup="kepToUpper('pw_st_id')"></div>
				<div class="input-box"><label>이메일</label><input class="input42" type="email" id="pw_st_mail" name="st_mail_addr" placeholder="이메일 주소를 입력해주세요." onkeydown="if(event.keyCode==13){findPw(); return false;}"></div>
				<button type="button" class="btn" onclick="findPw()">다음</button>
			</form>
		</div>
		<div class="CustomerCenter mt40" style="clear:both">가입 당시 정보가 기억나지 않거나 변경되었다면 유선으로 문의해 주세요<br /><span><img src="/resources/imgs/com_icon06.png" />02-3016-7251</span></div>
	</div>

	<!-- step02-ID: 일치하는 아이디 정보가 있을 경우 -->
	<div id="stepIdFound" class="step-wrap">
		<div class="container">
			<div class="find-Info-desc mt20"><img src="/resources/imgs/Check_blue_big.png" />회원님의 ID를 찾았어요!</div>
			<div class="find-Info mt40 mb40" id="foundIdDisplay"></div>
			<div class="Popup_GrayBox mt10 al">- 보안을 위해 ID의 일부만 보여집니다.</div>
			<div class="find-Info-BtnBox"><button class="InfoBtn" onclick="goToPwReset()">비밀번호 재설정</button></div>
		</div>
	</div>

	<!-- step02-PW: 일치하는 비밀번호 정보가 있을 경우 -->
	<div id="stepPwFound" class="step-wrap">
		<div class="container">
			<div class="find-Info-desc mt20"><img src="/resources/imgs/Check_black_big.png" />비밀번호 재설정</div>
			<div class="find-Info mt40 mb40" id="foundPwDisplay"></div>
			<div class="Popup_GrayBox mt10 al">- 선택한 방법으로 비밀번호 재설정 안내를 보내드립니다.<br />
			- 이메일 발송은 최대 5분 정도 소요될 수 있습니다.<br />
			- 등록된 이메일 또는 휴대폰 사용 불가 시 고객센터로 문의주세요.</div>
			<div class="find-Info-BtnBox"><button class="InfoBtn" onclick="sendNewPw('email')">이메일로 인증 발급</button> <button class="InfoBtn" onclick="sendNewPw('sms')">휴대폰으로 인증 발급</button></div>
		</div>
	</div>

	<!-- step03: 일치하는 정보가 없을 경우 (ID/PW 공용) -->
	<div id="stepNotFound" class="step-wrap">
		<div class="container">
			<div class="find-NoInfo mt20"><img src="/resources/imgs/Icon_Warning01.png" /><br /><span id="notFoundMsg">입력한 정보와 일치하는 아이디가 없습니다.</span></div>
			<button class="InfoBtn mt50" style="margin:0 auto;width:180px;display:block;" onclick="goBack()">이전 단계</button>
		</div>
		<div class="CustomerCenter mt40" style="clear:both">가입 당시 정보가 기억나지 않거나 변경되었다면 유선으로 문의해 주세요<br /><span><img src="/resources/imgs/com_icon06.png" />02-3016-7251</span></div>
	</div>
</div>

<script type="text/javascript">
// 현재 찾은 사용자 정보 저장
var foundUserData = {};
var lastSearchType = ""; // "id" or "pw"

// 탭 전환
function switchTab(index) {
	var tabs = document.querySelectorAll('.IdPwtab');
	var forms = document.querySelectorAll('.IdPwForm');
	for (var i = 0; i < tabs.length; i++) {
		if (i === index) {
			tabs[i].className = 'IdPwtab active';
			forms[i].className = 'IdPwForm active';
		} else {
			tabs[i].className = 'IdPwtab';
			forms[i].className = 'IdPwForm';
		}
	}
}

// 스텝 전환
function showStep(stepId) {
	var steps = document.querySelectorAll('.step-wrap');
	for (var i = 0; i < steps.length; i++) {
		steps[i].className = 'step-wrap';
	}
	document.getElementById(stepId).className = 'step-wrap active';
}

// 아이디 찾기
function findId() {
	var name = $.trim($("#id_st_name").val());
	var email = $.trim($("#id_st_mail").val());

	if (name === "") { alert("이름을 입력해주세요."); $("#id_st_name").focus(); return; }
	if (email === "") { alert("이메일 주소를 입력해주세요."); $("#id_st_mail").focus(); return; }

	lastSearchType = "id";
	jQuery.ajax({
		url: "/main/2016/sub04/getIdFindUserInfo.do",
		type: "POST",
		data: { st_name: name, st_mail_addr: email },
		dataType: "json",
		success: function(data) {
			if (data.status === "success" && data.idList && data.idList.length > 0) {
				foundUserData = data;
				// 마스킹 ID 표시
				var html = "";
				for (var i = 0; i < data.idList.length; i++) {
					html += data.idList[i].maskedId;
					if (i < data.idList.length - 1) html += "<br />";
				}
				$("#foundIdDisplay").html(html);
				showStep("stepIdFound");
			} else {
				$("#notFoundMsg").text("입력한 정보와 일치하는 아이디가 없습니다.");
				showStep("stepNotFound");
			}
		},
		error: function() {
			alert("조회 중 오류가 발생했습니다.");
		}
	});
}

// 비밀번호 찾기
function findPw() {
	var name = $.trim($("#pw_st_name").val());
	var phone1 = $.trim($("#pw_phone1").val());
	var phone2 = $.trim($("#pw_phone2").val());
	var phone3 = $.trim($("#pw_phone3").val());
	var userId = $.trim($("#pw_st_id").val());
	var email = $.trim($("#pw_st_mail").val());

	if (name === "") { alert("이름을 입력해주세요."); $("#pw_st_name").focus(); return; }
	if (phone1 === "" || phone2 === "" || phone3 === "") { alert("휴대폰 번호를 입력해주세요."); $("#pw_phone1").focus(); return; }
	if (userId === "") { alert("아이디를 입력해주세요."); $("#pw_st_id").focus(); return; }
	if (email === "") { alert("이메일 주소를 입력해주세요."); $("#pw_st_mail").focus(); return; }

	lastSearchType = "pw";
	jQuery.ajax({
		url: "/main/2016/sub04/getPwFind.do",
		type: "POST",
		data: {
			st_name: name,
			st_phone_num1: phone1,
			st_phone_num2: phone2,
			st_phone_num3: phone3,
			st_id: userId,
			st_mail_addr: email
		},
		dataType: "json",
		success: function(data) {
			if (data.status === "success") {
				foundUserData = data;
				$("#foundPwDisplay").html(data.email + "<br />" + data.phone);
				showStep("stepPwFound");
			} else {
				$("#notFoundMsg").text("입력한 정보와 일치하는 회원정보가 없습니다.");
				showStep("stepNotFound");
			}
		},
		error: function() {
			alert("조회 중 오류가 발생했습니다.");
		}
	});
}

// 비밀번호 재발급 (이메일/SMS)
function sendNewPw(type) {
	var userId = foundUserData.userId || "";
	if (userId === "") { alert("사용자 정보가 없습니다."); return; }

	jQuery.ajax({
		url: "/main/sub05/setNewPw.do",
		type: "POST",
		data: { st_id: userId, st_type: type },
		dataType: "json",
		success: function() {
			alert("정상적으로 발송 되었습니다.");
		},
		error: function() {
			alert("처리중 오류가 발생하였습니다.");
		}
	});
}

// 전체 ID 확인 (기존 OTP 인증 페이지로 이동)
function goFullIdCheck() {
	if (foundUserData.idList && foundUserData.idList.length > 0) {
		var firstUser = foundUserData.idList[0];
		var form = document.createElement("form");
		form.method = "POST";
		form.action = "<%=sslurl2%>/main/sub04/sub04_search_certificate_id_2016.do";

		var fields = {
			st_id_no: "1",
			st_user_id: firstUser.userId,
			p_num: firstUser.phone
		};
		for (var key in fields) {
			var input = document.createElement("input");
			input.type = "hidden";
			input.name = key;
			input.value = fields[key];
			form.appendChild(input);
		}
		document.body.appendChild(form);
		form.submit();
	}
}

// 비밀번호 재설정 탭으로 이동
function goToPwReset() {
	showStep("stepSearch");
	switchTab(1);
	$("#pw_st_name").focus();
}

// 이전 단계로 돌아가기
function goBack() {
	showStep("stepSearch");
	if (lastSearchType === "pw") {
		switchTab(1);
	} else {
		switchTab(0);
	}
}
</script>
</body>
</html>
