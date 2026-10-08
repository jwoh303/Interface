<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>로그인</title>
<script type="text/javascript">
<!--
	function actionLogin() {
		if (document.loginForm.id.value == "") {
			alert("아이디를 입력하세요");
			return false;
		} else if (document.loginForm.password.value == "") {
			alert("비밀번호를 입력하세요");
			return false;
		} else {
			document.loginForm.action = "/login/login.do";
			document.loginForm.submit();
		}
	}

	function setCookie(name, value, expires) {
		document.cookie = name + "=" + escape(value) + "; path=/; expires=" + expires.toGMTString();
	}

	function getCookie(Name) {
		var search = Name + "="
		if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
			offset = document.cookie.indexOf(search)
			if (offset != -1) { // 쿠키가 존재하면
				offset += search.length
				// set index of beginning of value
				end = document.cookie.indexOf(";", offset)
				// 쿠키 값의 마지막 위치 인덱스 번호 설정
				if (end == -1)
					end = document.cookie.length
				return unescape(document.cookie.substring(offset, end))
			}
		}
		return "";
	}

	function saveid(form) {
		var expdate = new Date();
		// 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
		if (form.checkId.checked)
			expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
		else
			expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
		setCookie("saveid", form.id.value, expdate);
	}

	function getid(form) {
		form.checkId.checked = ((form.id.value = getCookie("saveid")) != "");
	}

	function fnInit() {
		var message = document.loginForm.message.value;
		if (message != "") {
			alert(message);
		}
		getid(document.loginForm);
	}
//-->
</script>
</head>
<body>
	<div align="center">
		<form name="loginForm" method="post">
			<fieldset>
				<legend>로그인 정보</legend>
				<div>
					<ul>
						<li><label for="userId">아이디</label> <input type="text" class="input_type_text" title="아이디를 입력하세요." id="userId" name="userId" maxlength="10"  value="11"/></li>
						<li><label for="password">비밀번호</label> <input type="text" class="input_type_text" maxlength="25" title="비밀번호를 입력하세요." id="password" name="password"
							onkeydown="javascript:if (event.keyCode == 13) { actionLogin(); }"  value="314731633215298"/></li>
						<li><input type="checkbox" name="checkId" title="로그인ID 저장여부" onclick="javascript:saveid(this.form);" id="checkId" />ID저장</li>
					</ul>
					<input type="submit" value="로그인" onclick="javascript:actionLogin();" />
				</div>
			</fieldset>
		</form>
		<div><%=request.getAttribute("message")%></div>
	</div>
</body>
</html>
