<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  
String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");
String st_quotation_seq = CommonUtil.nvl((String) request.getParameter("st_quotation_seq"),"");
String st_atob_remark = CommonUtil.nvl((String) request.getParameter("st_atob_remark"),"");
String st_revision = CommonUtil.nvl((String) request.getParameter("st_revision"),"");
String st_req_no = CommonUtil.nvl((String) request.getParameter("st_req_no"),"");

st_atob_remark = st_atob_remark.replaceAll("&lt;br&gt;","\n");
String viewType = CommonUtil.nvl((String) request.getParameter("viewType"),"");  //  (조회조건)

%>
<script type="text/javascript">
function init(){
	$("#st_atob_remark").focus();
}
function kepConfirm()
{ 
	doAction("save");
}
//기능함수
function doAction(str) {
	switch (str) {
		case "save": // 저장
			kepAjaxFormCall("/mprq/saveMasterMprqQuotationAtoB.do","searchCondition", str);				
			break; 
	}
}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var value1 = $("#st_atob_remark").val();
	value1 = value1.replace(/\r?\n/g, '<br>');
  	var value2 = "";
	
  	opener.setPopupReturn(value1,value2);
  	this.close();
}
function  kepAjaxError(pMethod , response) {
	Company_Create_flag = "N"; 	
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
} 
</script>  
<body onload="init(); " >
	<form id ="searchCondition" name="searchCondition" method = "post" onsubmit="return false" >
        <input type="hidden" name="s_SAVENAME">
        <input type="hidden" id="st_buyer" name="st_buyer" value="<%=st_buyer%>"/>
        <input type="hidden" id="st_quotation_no" name="st_quotation_no" value="<%=st_quotation_no%>"/>
        <input type="hidden" id="st_quotation_seq" name="st_quotation_seq" value="<%=st_quotation_seq%>"/>
        <input type="hidden" id="st_revision" name="st_revision" value="<%=st_revision%>"/>
        <input type="hidden" id="st_req_no" name="st_req_no" value="<%=st_req_no%>"/>		
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:214px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">비고</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <table class="cont_t_list05">
                <tr> 
                	<td style="width:100px">고객사 제출 비고 </td>
                    <td>
                        <textarea name="st_atob_remark" id="st_atob_remark" placeholder="- 기존 대비 __% NEGO하여 제출 드립니다.&#13;&#10;- __을 사유로 요청하신 단가로는 견적 제출 불가하여 가능 단가로 제출드립니다.&#13;&#10;- 운임비 포함하여 견적 제출드립니다.&#13;&#10;- 단위 오류 건으로 요청 단위로의 견적 단가 제출드립니다.&#13;&#10;- 오견적으로 인한 정상단가 제출 건입니다.&#13;&#10;&#13;&#10;와 같이 상세사유로 입력바랍니다." style="width:100%;ime-mode:active; overflow:auto; border-color:white; border-width:0;" rows="12" cols="35" ><%=st_atob_remark%></textarea>
                    </td>
                </tr>
            </table> 
	       	<div class="btnArea ac" style="margin-bottom:0px;"> 
			     <span class="fr btn_02"><a href="javascript:kepConfirm()">확인</a></span> 
			</div> 		
        </div>
    </div>
    </form>
</body>
</html>
