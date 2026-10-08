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
		document.saveForm.action = "<c:url value='/auth/saveAuth.do'/>";
		document.saveForm.submit();
	}
//-->
</script>
</head>
<body>
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="masterHeader"/>
<c:param name="part" value="header"/>
</c:import>
		<div id="container2">
				<c:import charEncoding="utf-8" url="/menu/menu.do">
				<c:param name="page" value="masterLeft"/>
				<c:param name="part" value="${param.upperId}"/>
				</c:import>
			<div id="rightCont">
				<!-------------------------------------------------------------------------------------------work------------------------------------------------------------------------------------------------------->
				<div>
					<form name="saveForm" method="post">
						<table>
							<tr>
								<td>권한 코드</td>
								<td><input type="text" class="input_type_text" id="authId" name="authId" maxlength="10"  <c:if test='${null ne auth}'> readonly="true"</c:if> value="<c:out value='${auth.authId}'/>" /></td>
							</tr>
							<tr>
								<td>권한 명</td>
								<td><input type="text" class="input_type_text" id="name" name="name" maxlength="10" value="<c:out value='${auth.name}'/>" /></td>
							</tr>
							<tr>
								<td>권한 설명</td>
								<td><input type="text" class="input_type_text" id="authDc" name="authDc" maxlength="10" value="<c:out value='${auth.authDc}'/>" /></td>
							</tr>
							<tr>
								<td>생성일시</td>
								<td><input type="text" class="input_type_text" id="createDt" name="createDt" maxlength="10" value="<c:out value='${auth.createDt}'/>" /></td>
							</tr>
						</table>
						<br>
						<div>
							<a href="<c:url value='/auth/getAuths.do'/>">목록 </a> <a href="#LINK" onclick="JavaScript:fnSave(); return false;">저장 </a>
						</div>

					</form>
					<!-------------------------------------------------------------------------------------------------work------------------------------------------------------------------------------------------------------->
				</div>
			</div>
			</div>
		<%@ include file="/WEB-INF/views/common/include/masterFooter.jsp" %>  
	</div>
</body>
</html>

