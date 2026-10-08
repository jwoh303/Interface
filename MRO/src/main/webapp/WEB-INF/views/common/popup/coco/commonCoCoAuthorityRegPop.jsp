<%--
**********************************************
* 메뉴 : 
* 화면 : 권한등록
* 기능 : 
* 프로그램 ID : PG_90_C_900_62
* 담당자 :  ( 설계 : 공통 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
String role_code = CommonUtil.nvl((String) request.getParameter("st_role_code"),"");
String role1 = role_code.substring(0,1);
String role2 = role_code.substring(1, role_code.length());
String ori_role_code = CommonUtil.nvl((String) request.getParameter("st_ori_role_code"),"");
String ori_role2 = ori_role_code.substring(1, ori_role_code.length());
String user_type = CommonUtil.nvl((String) request.getParameter("st_user_type"),""); 
%>
<script type="text/javascript">
<!--
//기능함수
function doAction(str) {
	switch (str) {
		case "save":			// 저장
			var role_code = "";
			var role_name = "";
			var user_type = "<%=user_type%>";
			var role2 = "<%=ori_role2%>";
			//alert(role2);
			if (user_type == "A") {
				alert("관리자는 메뉴접근 권한 변경이 불가능 합니다.");
				return;
				role_code = "A+";
				role_name = "관리자";
			} else {
				if (role2 != "-" && $("#check_u").is(":checked")) {
					if ($("#check_p").is(":checked") && $("#check_g").is(":checked")) {
						role_code = "C+";
						role_name = "주문 : 발주 : 입고";
					} else if ($("#check_p").is(":checked")) {
						role_code = "P+";
						role_name = "주문 : 발주";
					} else if ($("#check_g").is(":checked")) {
						role_code = "G+";
						role_name = "주문 : 입고";
					} else {
						role_code = "U+";
						role_name = "주문";
					}
				} else {
					if ($("#check_p").is(":checked") && $("#check_g").is(":checked")) {
						role_code = "C-";
						role_name = "발주 : 입고";
					} else if ($("#check_p").is(":checked")) {
						role_code = "P-";
						role_name = "발주";
					} else if ($("#check_g").is(":checked")) {
						role_code = "G-";
						role_name = "입고";
					} else {
						role_code = "U-";
						role_name = "조회";
					}
				}
			}
			
			setReturn(role_code, role_name);
			break;
	}
}

function setReturn(value1,value2) {
	opener.setPopupReturn(value1,value2);
	this.close();
}
 //-->
</script> 
<body onload="">
<form name="commonCoCoAuthorityRegPop" id="commonCoCoAuthorityRegPop" method=post >

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="width:215px; height:194px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">권한등록</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
		</div>
        <!--팝업내용입니다-->
		<div id="popContainer">
			<!--grid-->
			<div class="contArea" style="width:215px;height:138px">
				<table  class="cont_t_list02"  style="width:100%">
					<caption>권한등록 리스트</caption>
					<colgroup>
						<col width="20%" /> 
						<col width="*" /> 
					</colgroup>
					<thead>
						<tr>
							<th scope="col">선택</th> 
							<th scope="col">권한명</th> 
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>
						 		<input type="checkbox" id="check_u" name="check_u" value="<%=role2%>" <%=(role2.equals("@")) ? "checked" : "" %>  />
							</td>
							<td>주문</td>
						</tr>
						<tr>
							<td>
						 		<input type="checkbox" id="check_p" name="check_p" value="P" <%=(role1.equals("P") || role1.equals("C")|| role1.equals("A")) ? "checked" : "" %>  />
							</td>
							<td>발주</td>
						</tr>
						<tr>
							<td>
						 		<input type="checkbox" id="check_g" name="check_g" value="G" <%=(role1.equals("G") || role1.equals("C")|| role1.equals("A")) ? "checked" : "" %>  />
							</td>
							<td>입고</td>
						</tr> 
					</tbody>
				</table>
				<div class="btnArea">
					<span class="fr">
						<span class="btn_02 mt10 mr04"><a href="javascript:doAction('save');">확인</a></span>
					</span>
				</div>                  
			</div>
			<!--버튼영역-->
			
		</div>        
	</div>
</form> 
</body>
</html>
