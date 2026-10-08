<%--
**********************************************
* 메뉴 : HOME>고객의 소리
* 화면 : 고객의 소리
* 기능 : 
* 프로그램 ID : 
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-09-03
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
 
</head>
<%

%>
<script type="text/javascript">
//<!--
function send() {

	if(isEmpty($("#st_company_name").val())) {
		alert("회사명을 입력하여 주십시요.");
		$("#st_company_name").focus()
		return ;
	}

	if(isEmpty($("#st_user_name").val())) {
		alert("이름을 입력하여 주십시요.");
		$("#st_user_name").focus();
		return ;
	}

	if(isEmpty($("#st_email").val())) {
		alert("메일주소를 입력하여 주십시요.");
		$("#st_email").focus();
		return ;
	}

	if(isEmpty($("#st_content").val())) {
		alert("문의내용을 입력하여 주십시요.");
		$("#st_content").focus();
		return ;
	}

	if(confirm("문의하시겠습니까?")) {
		alert("고객의 소리를 준비 중 입니다.");
	}

}
 //-->
</script>
<body onload="">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>

<div id="container2" style="margin-right: 20px;">
<%-- <c:import charEncoding="utf-8" url="/menu/menu.do"> --%>
<%-- <c:param name="page" value="sellerLeft"/> --%>
<%-- <c:param name="part" value="${param.upperId}"/> --%>
<%-- </c:import> --%>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>고객의 소리</h3>
	<div id="searchBtnA">
	</div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="${param.upperId}"/>    	
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	<!-- 공통 -->
	  	
       	<table  class="cont_t_list06" style="width:100%;">
           <caption>고객의 소리</caption>
           <colgroup>
               <col width="150px" />
               <col width="*" />
           </colgroup>
           <tbody>
				<tr>
					<th scope="row">회사명</th>
					<td><input type="text" id="st_company_name" name="st_company_name" class="input_type_text" title="회사명" style="width:80%;" /></td>
				</tr>
				<tr>
					<th scope="row">이름</th>
					<td><input type="text" id="st_user_name" name="st_user_name" class="input_type_text" title="회사명" style="width:80%;" /></td>
				</tr>
				<tr>
					<th scope="row">메일주소</th>
					<td><input type="text" id="st_email" name="st_email" class="input_type_text" title="회사명" style="width:80%;" /></td>
				</tr>
				<tr>
					<th scope="row">문의사항</th>
					<td><textarea rows="5" cols="70" id="st_content" name="st_content" style="text-align:left; width:80%;"></textarea></td>
				</tr>
			</tbody>
		</table>	

		<!-- 버튼영역 -->
		<div class="btnArea mt10 mb05">
			<div class="fr">
				<span class="btn_05">
					<a href="javascript:send();">메일보내기</a>
				</span>	
            </div>
        </div>
</form>

<form name="processForm" id="processForm" method="post">	
	<div id="process">
	</div>
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>   
</div>
</body>
</html>
