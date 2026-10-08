<%--
**********************************************
* 메뉴 : 
* 화면 : 합의내역(지연사유조회)팝업
* 기능 : 합의내역(지연사유조회)팝업
* 프로그램 ID : 
* 담당자 : 고영일 ( 설계 : 권우재 )
* 착수일 : 2014-09-30
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
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> combo_data = (List<Map<String,String>>) request.getAttribute("combo_data"); // 조회된 결과 
List<Map<String,String>> reason_data = (List<Map<String,String>>) request.getAttribute("reason_data"); // 조회된 결과
List<Map<String,String>> detail_data = (List<Map<String,String>>) request.getAttribute("detail_data"); // 조회된 결과
String st_buyer			= CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String st_quotation_no	= CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");
String st_quotation_seq	= CommonUtil.nvl((String) request.getParameter("st_quotation_seq"),"");
String st_revision			= CommonUtil.nvl((String) request.getParameter("st_revision"),"");
String st_modify			= CommonUtil.nvl((String) request.getParameter("st_modify"),"");
String st_reasonText = "";
String st_reasonValue = "";
String st_detailText = "";
if(reason_data != null && reason_data.size() > 0){
	st_reasonText =CommonUtil.nvl(reason_data.get(0).get("DELAY_RESION_NOTE")); 
 	st_reasonValue = 	CommonUtil.nvl(reason_data.get(0).get("DELAY_REASON_CODE"));	
}
if(detail_data != null && detail_data.size() > 0){
	st_detailText = CommonUtil.nvl(detail_data.get(0).get("RETURN_VALUE")); 
}
%>

<script>
//<!--
function kep_onload_view(){
	doAction("search");
}
//기능함수
function setReason() {
	
	var st_reason_code = $("input:radio[name=st_reason_code]:checked").val();
	if(isEmpty(st_reason_code)){
		alert("견적지연 사유을 선택하여 주십시오.");
		return ;
	}

	if(confirm("저장하시겠습니까?")) {
		var pMethod = "insertDealyReason";
		kepAjaxFormCall("/mpiv/saveMasterMpIvQuotationSendDelayReasonPop.do", "searchCondition",pMethod);
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg.MSG;
	if ( pMethod == "insertDealyReason" ) {
		if(msg == "INSERT_OK"){
			alert("정상적으로 저장되었습니다.");
			opener.setDelayPopupReturn();
			this.close();
			return;
		}
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "insertDealyReason"){ 
		 alert("저장에 실패 하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}
}

//-->
</script> 
<body onload="kep_onload_view();">
<form id="searchCondition" name="searchCondition" method="post" onsubmit="return false" >
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=st_buyer%>">
	<input type="hidden" id="st_kep_user_id"  name="st_kep_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_quotation_no"  name="st_quotation_no" value="<%=st_quotation_no%>">
	<input type="hidden" id="st_quotation_seq"  name="st_quotation_seq" value="<%=st_quotation_seq%>">
	<input type="hidden" id="st_revision"  name="st_revision" value="<%=st_revision%>">
	<input type="hidden" id="st_mail_yn"  name="st_mail_yn" value="N">
	
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">견적지연 사유</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
			<table id="tblSearchApprover" class="cont_t_list02"  style="width:100% ">
				<caption>견적지연사유</caption>
				<colgroup>
					<col width="100%" /> 
				</colgroup>
				<tbody>
					<tr>
						<td class="left" style="padding-left: 20px;" >
<%
if(combo_data != null && combo_data.size() > 0){
	for(int inx = 0 ; inx < combo_data.size() ; inx++){
		Map<String, String> rowData = combo_data.get(inx);
%>
							<input type="radio" name="st_reason_code" style="vertical-align: middle;" value="<%=CommonUtil.nvl(rowData.get("CODE")) %>"  <% if (CommonUtil.nvl(rowData.get("CODE")).equals(st_reasonValue)) { %>checked="checked"<% } %><% if (CommonUtil.nvl(st_modify).equals("N")) { %>disabled<% } %> />&nbsp;<%=CommonUtil.nvl(rowData.get("TEXT2")) %><br/>
<%
	}
}
%>
						</td>
					</tr>
				</tbody>
			</table>
			
			<div style="text-align: center">
				<textarea id="st_reason_remark" name="st_reason_remark" rows="" cols="" style="width: 95%; height: 100px;" <% if (CommonUtil.nvl(st_modify).equals("N")) { %>disabled<% } %> /><%=st_reasonText%></textarea>
			</div>

<%
	if(!st_modify.equals("Y")){
		if(st_detailText != ""){
%>
			<br>
						
			<div style="text-align: center">
				<font color="RED" size="3">세부진행상태 : <%=st_detailText%></font>
			</div>
<%
		}
	}

	if(st_modify.equals("Y")){
%>
			<br>
			
        	<!--버튼영역-->
	        <div class="btnArea mr25">
				<span class="fl">
					<font color="#666666">※ 저장 이후에는 수정이 불가하오니 정확하게 입력하세요.</font>
				</span>
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:setReason();">저장</a></span>
				</span>
			</div>
		</div>
<%
	}
%>
    </div>
</form> 
</body>
</html>
