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
String st_atoa_remark = CommonUtil.nvl((String) request.getParameter("st_atoa_remark"),"");
String st_revision = CommonUtil.nvl((String) request.getParameter("st_revision"),"");
String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"");
String st_req_no = CommonUtil.nvl((String) request.getParameter("st_req_no"),"");

st_atoa_remark = st_atoa_remark.replaceAll("&lt;br&gt;","\n");
String viewType = CommonUtil.nvl((String) request.getParameter("viewType"),"");  //  (조회조건)

%>
<script type="text/javascript">
function init(){
	$("#st_atoa_remark").focus();
}
function kepConfirm()
{ 
	doAction("save");
}
//기능함수
function doAction(str) {
	switch (str) {
		case "save": // 저장
			var st_type = $("#st_type").val();		
			/*
				ST_TPYE
				1.REQ = 카톨로그 운영사 비고.
				그외   = 견적 운영사 비고.
			*/
			if(st_type == "REQ"){
				kepAjaxFormCall("/mdcm/saveMasterMdcmReqRemarkAtos.do","searchCondition", str);
			}else{
				kepAjaxFormCall("/mprq/saveMasterMprqQuotationAtoA.do","searchCondition", str);				
			}
			break; 
	}
}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var value1 = $("#st_atoa_remark").val();
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
        <input type="hidden" id="st_type" name="st_type" value="<%=st_type%>"/>	
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
                	<td style="width:100px">운영사 비고 </td>
                    <td>
                        <textarea name="st_atoa_remark" id="st_atoa_remark"  style="width:100%;ime-mode:active; overflow:auto; border-color:white; border-width:0;" rows="4" cols="35" ><%=st_atoa_remark%></textarea>
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
