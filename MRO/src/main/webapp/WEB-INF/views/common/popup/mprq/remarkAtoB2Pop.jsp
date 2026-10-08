<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.util.Map"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"%>
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
Map<String,String> _dataList = (Map<String,String>) request.getAttribute("data"); // 조회된 결과
Map<String,String> rowData = null;
if (_dataList==null || _dataList.size()==0){	
}else{
	rowData = _dataList;
}

%>
<script type="text/javascript">
function init(){
	$("#st_atob_remark").focus();
}

function kepConfirm(){ 
	doAction("save");
}

//기능함수
function doAction(str) {
	switch (str) {
		case "save": // 저장
			kepAjaxPopFormCall("/mprq/saveMasterMprqQuotationAtoB.do","searchCondition", str);				
			break; 
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxPopSuccess(pMethod , response) {
	var value1 = $("#st_atob_remark").val();
	value1 = value1.replace(/\r?\n/g, '<br>');
  	var value2 = "";
	
  	opener.setPopupReturn(value1,value2);
  	this.close();
}

function kepAjaxPopError(pMethod , response) {
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
	<div id="popWrapper" style="height:400px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">비고</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <table class="cont_t_list05">
                <tr> 
                	<td style="width:100px">고객사 제출 비고</td>
					<td>
                        <textarea name="st_atob_remark" id="st_atob_remark" style="width:97%; ime-mode:active;" rows="12"><%=st_atob_remark%></textarea>
					</td>
				</tr>
				<tr>
					<td style="width:100px; text-align:center; background-color:#EAEAEA;">예   문</td>
					<td style="background-color:#EAEAEA;">
<%if (_dataList == null || _dataList.size() == 0){%>
                        <textarea name="st_atob_remark_guide" id="st_atob_remark_guide" style="width:97%; border-width:0; background-color:#EAEAEA;" rows="12" readonly></textarea>
<%}else{%>
						<textarea name="st_atob_remark_guide" id="st_atob_remark_guide" style="width:97%; border-width:0; background-color:#EAEAEA;" rows="12" readonly><%=CommonUtil.nvl(rowData.get("ASRMGD_REMARK"))%></textarea>
<%}%>
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
