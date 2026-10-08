<%--
**********************************************
* 메뉴 : 벌크소싱 프로젝트 관리 > 벌크소싱 프로젝트 중단사유 입력 팝업
* 화면 : 벌크소싱 프로젝트 중단사유 입력 팝업
* 기능 : 
*****************
--%>
<%@page import="java.math.BigDecimal"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>

<!doctype html>
<html>
<head>
<!-- <script src="/resources/js/common.js"></script> -->
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%

String st_burq_no = CommonUtil.nvl((String) request.getParameter("burq_no"),"");
String user_id = _sessionInfo.getUserId();
%>
<script type="text/javascript">


function kep_onload_view(){
	kepAjaxCommonTotalCombo('st_abort_reason', 'BURQ07', 'SEL','','','');
}

//기능함수
function doAction(str) {
	
	switch (str) {
		case "save":
			if(isEmpty($('#st_abort_reason').val())){
				alert("중단사유를 선택하시기 바랍니다.");
				return;
			}
			kepAjaxFormCall("/mprq/delMasterMpRqBulkQuotationProjectList.do","masterMpRqBulkQuotationAbortReasonPop","save");
			break;
	}
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){  
	if (pMethod == "save"){
		var msg = response.Msg;
		if (msg != "") {
			alert(msg);
		}else{
			alert("프로젝트가 중단되었습니다.");
			setReturn('1');
		}
		window.close();
	}
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) { 
	var msg = response.Message;

	if (!isEmpty(msg)){	
		alert(msg);
	}
	return;
}
function setReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9)
{ 
  opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9);
  this.close();
}
</script> 
<body onLoad="kep_onload_view()">
<form name="masterMpRqBulkQuotationAbortReasonPop" id="masterMpRqBulkQuotationAbortReasonPop" method=post >
	<input type="hidden" id= "st_burq_no" name="st_burq_no" value="<%=st_burq_no %>">
	<input type="hidden" id= "st_user_id" name="st_user_id" value="<%=user_id %>">
	
<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
<div id="popWrapper" style="height:120px;">
   	<div id="popHeader">
		<h1 class="title">벌크소싱 중단 사유를 입력해주세요.</h1>
<!-- 		<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p> -->
	</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
            <!--조회영역-->
            <div>
            	<table style="width:100%;margin-top:10px;">
					<tr>
						<td  style="text-align:center;" >
							<select id="st_abort_reason" name="st_abort_reason" style="width:90%;height:20px">
							</select>
						<td>
					</tr>
					<tr>						<td><br></td>					</tr>
					<tr>
						<td style="text-align:center;">
			            	<span class="btn_04 mr04"><a href="javascript:doAction('save');">확인</a></span>
			            	<span class="btn_04 mr04"><a href="javascript:self.close()">취소</a></span>
	            		</td>
	            	</tr>
				</table>
            </div>
        </div>
    </div>        
</div>
</form> 
</body>
</html>
