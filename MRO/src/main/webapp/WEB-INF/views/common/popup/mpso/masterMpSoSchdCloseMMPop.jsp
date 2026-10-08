<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%

String st_user_id = ""; //사용자 아이디
if (_sessionInfo != null){
	st_user_id = _sessionInfo.getUserId();
}

String pay_reg_no = CommonUtil.nvl((String) request.getParameter("pay_reg_no"),"");
String pay_reg_seq = CommonUtil.nvl((String) request.getParameter("pay_reg_seq"),"");
String schd_close_month = CommonUtil.nvl((String) request.getParameter("schd_close_month"),"");

%>
<script type="text/javascript"> 


function kepConfirm()
{ 	
	var st_remark = $("#st_remark").val();
	document.forms.remarkform.st_user_id.value  = '<%=st_user_id%>';
	document.forms.remarkform.re_pay_reg_no.value  = '<%=pay_reg_no%>';
	document.forms.remarkform.re_pay_reg_seq.value  = '<%=pay_reg_seq%>';
	document.forms.remarkform.re_remark.value  = st_remark;
	document.forms.remarkform.re_schd_close_month.value  = '<%=schd_close_month%>';
	kepAjaxFormCall("/mpso/saveMasterMpSoPayRegMngRemarkPop.do","remarkform","masterMpSoSchdCloseMMPop");
}



/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	  
    if(pMethod == "masterMpSoSchdCloseMMPop")  
    { 
    	alert("저장하였습니다.");    	    	      
    }   	 
    this.close();
    opener.doAction('search');
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {	
	if(pMethod == "masterMpSoSchdCloseMMPop")  
    { 
		alert("<%=CommonLang.msg("MSG228") %>");    	      
    }  	
	
} 

</script>  
<body onload="">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:250px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">사유 입력</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">        
			<table class="cont_t_list05" style="background-color: #FAF9CF;">
                <tr>
                    <th>변경 사유</th>
                    <td>
                        <textarea id="st_remark" name="st_remark" style="width:100%; overflow:auto; border-color:white; border-width:0; background-color: #FAF9CF;" rows="5" cols="35"></textarea>
                    </td>
                </tr>
            </table>
              	
	       	<div class="btnArea ac mt20" style="margin-bottom:0px;"> 
			           	<span class="fr btn_02"><a href="javascript:kepConfirm()">저장</a></span> 
			</div>		 		
        </div>
    </div>
    <form name="remarkform" id="remarkform" method="post">
   		<input type="hidden" name="st_user_id" id="st_user_id" value="" />	
		<input type="hidden" name="re_pay_reg_no" id="re_pay_reg_no" value="" />				 
		<input type="hidden" name="re_pay_reg_seq" id="re_pay_reg_seq" value="" />
		<input type="hidden" name="re_remark" id="re_remark" value="" />
		<input type="hidden" name="re_schd_close_month" id="re_schd_close_month" value="" />		
	</form>
</body>
</html>
