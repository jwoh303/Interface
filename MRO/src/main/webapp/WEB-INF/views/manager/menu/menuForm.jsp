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
		document.saveForm.action = "<c:url value='/menu/saveMenu.do'/>";
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
				<form name="saveForm" method="post">
					<table>
						<tr>
							<td>메뉴 아이디</td>
							<td><input type="text" class="input_type_text" id="menuId" name="menuId" maxlength="30"  <c:if test='${null ne menu}'> readonly="true"</c:if> value="<c:out value='${menu.menuId}'/>" /></td>
						</tr>
						<tr>
							<td>상위메뉴 아이디</td>
							<td><input type="text" class="input_type_text" id="upperId" name="upperId" maxlength="30" value="<c:out value='${menu.upperId}'/>" /></td>
						</tr>
						<tr>
							<td>메뉴 명</td>
							<td><input type="text" class="input_type_text" id="name" name="name" maxlength="30" value="<c:out value='${menu.name}'/>" /></td>
						</tr>
						<tr>
							<td>깊이</td>
							<td><input type="text" class="input_type_text" id="depth" name="depth" maxlength="30" value="<c:out value='${menu.depth}'/>" /></td>
						</tr>
						<tr>
							<td>타입</td>
							<td><input type="text" class="input_type_text" id="type" name="type" maxlength="30" value="<c:out value='${menu.type}'/>" /></td>
						</tr>
						<tr>
							<td>요청 경로</td>
							<td><input type="text" class="input_type_text" id="url" name="url" maxlength="30" value="<c:out value='${menu.url}'/>" /></td>
						</tr>
						<tr>
							<td>권한</td>
							<td><input type="text" class="input_type_text" id="authId" name="authId" maxlength="30" value="<c:out value='${menu.authId}'/>" /></td>
						</tr>
						<tr>
							<td>메뉴 순서</td>
							<td><input type="text" class="input_type_text" id="menuOrder" name="menuOrder" maxlength="30" value="<c:out value='${menu.menuOrder}'/>" /></td>
						</tr>
						<tr>
							<td>메뉴 설명</td>
							<td><input type="text" class="input_type_text" id="menuDc" name="menuDc" maxlength="30" value="<c:out value='${menu.menuDc}'/>" /></td>
						</tr>
						<tr>
							<td>생성일시</td>
							<td><input type="text" class="input_type_text" id="createDt" name="createDt" maxlength="30" value="<c:out value='${menu.createDt}'/>" /></td>
						</tr>
					</table>
					<br>
					<div>
						<a href="<c:url value='/menu/getMenus.do'/>">목록 </a> <a href="#LINK" onclick="JavaScript:fnSave(); return false;">저장 </a>
					</div>
				
				</form>
			</div>
			</div>
		<%@ include file="/WEB-INF/views/common/include/masterFooter.jsp" %>  
	</div>
</body>
</html>

