<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
String initLoadFlag = CommonUtil.nvl((String) request.getParameter("initLoadFlag"),"N");  //  (조회조건)
String stItemNo = CommonUtil.nvl((String) request.getParameter("st_item_no"),"N");  //  (조회조건)
%>
<script type="text/javascript">
function init() {
}

function kepEnter() {
	if (event.keyCode == 13) {
		codeQuery();
	}
}

function codeQuery(){
	document.forms[0].country_search.value = document.forms[0].country_search.value.toUpperCase();   
	$('#countryCodePop').attr("action", "/common/commonList.do").submit();	
}

function setOnkey(key)
{
  if(key == "13")
  {
	codeQuery();
  }
}
function setReturn(value1,value2,value3)
{ 
  opener.setPopupReturn(value1,value2,value3);
  this.close();
}
function setZcode(){
	var st_zbcode = document.zcodeSelectPop.st_zbcode.value;
	if(st_zbcode == ""){
		alert("대표코드를 선택하시기 바랍니다.");
		return;
	}
	opener.setZcodePop(st_zbcode);
	parent.window.close();
}
</script> 
<body onload="init();">
	<form name=zcodeSelectPop id=zcodeSelectPop method=post >
		<input type="hidden" name="codeGubun" id="codeGubun"  value="countryCodePop">
		<input type="hidden" name="initLoadFlag" id="initLoadFlag"  value="Y">
		<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
		<div id="popWrapper" style="height:494px;">
			<div id="popHeader">
				<h1 class="title">대표코드조회</h1>
				<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
			</div>
			<div id="popContainer">
				<div id="cont_searchA">
					<table  class="cont_t_list01"  style="width:100%">
						<caption>대표코드</caption>
						<colgroup>
							<col width="20%" />
							<col width="80%" />
						</colgroup>
						<tbody>
							<tr>
								<td>상품코드</td>
								<td>
									<input type=text class="input_type_text" name=st_item_no id="st_item_no" size=20 value="${st_item_no }" onkeydown="kepEnter()" style="ime-mode:active">
								</td>
							</tr>
							<tr>
								<td>대표코드</td>
								<td>
									<select name="st_zbcode" id="st_zbcode">
										<c:out value="${zcodeList }" escapeXml="false"/>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btnArea" style="margin-top: 10px;">
					<c:if test="${!(data == null || fn:length(data) == 0) }">
						<span class="fr">
							<span class="btn_02"><a href="javascript:setZcode()" >확인</a></span>
						</span>
					</c:if>
				</div>
			</div>
		</div>
	</form> 
</body>
</html>
