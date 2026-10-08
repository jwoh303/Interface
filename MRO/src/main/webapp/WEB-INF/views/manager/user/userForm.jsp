<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script type="text/javaScript">
<!--
	function fnSave() {
		document.saveForm.action = "<c:url value='/user/saveUser.do'/>";
		document.saveForm.submit();
	}
//-->
</script>
</head>
<body>
	<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<div id="container2">
			<div id="rightCont">
				<!-------------------------------------------------------------------------------------------work------------------------------------------------------------------------------------------------------->
				<div>
					<form name="saveForm" method="post">
						<table>
							<tr>
								<td>사용자 아이디</td>
								<td><input type="text" class="input_type_text" id="userId" name="userId" maxlength="30"  <c:if test='${null ne user}'> readonly="true"</c:if> value="<c:out value='${user.userId}'/>" /></td>
							</tr>
							<tr>
								<td>사용자 명</td>
								<td><input type="text" class="input_type_text" id="userNm" name="userNm" maxlength="30" value="<c:out value='${user.userNm}'/>" /></td>
							</tr>
							<tr>
								<td>비밀번호</td>
								<td><input type="text" class="input_type_text" id="password" name="password" maxlength="30" value="<c:out value='${user.password}'/>" /></td>
							</tr>
							<tr>
								<td>활성화 여부</td>
								<td><input type="text" class="input_type_text" id="userActive" name="userActive" maxlength="30" value="<c:out value='${user.userActive}'/>" /></td>
							</tr>
							<tr>
								<td>생성일시</td>
								<td><input type="text" class="input_type_text" id="createDt" name="createDt" maxlength="30" value="<c:out value='${user.createDt}'/>" /></td>
							</tr>
							<tr>
								<td>권한</td>
								<td><input type="text" class="input_type_text" id="authors" name="authors" maxlength="100" value="<c:out value='${user.authors}'/>" /></td>
							</tr>
							
						</table>
						<br>
						<div>
							<a href="<c:url value='/user/getUsers.do'/>">목록 </a> <a href="#LINK" onclick="JavaScript:fnSave(); return false;">저장 </a>
						</div>

					</form>
					<!-------------------------------------------------------------------------------------------------work------------------------------------------------------------------------------------------------------->
				</div>
			</div>
		</div>
	</div>
</body>
</html>

