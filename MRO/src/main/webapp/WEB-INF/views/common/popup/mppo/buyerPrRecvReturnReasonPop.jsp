<%--
**********************************************
* 메뉴 : 
* 화면 : 요청수량 변경사유
* 기능 : 요청수량 변경사유 입력 팝업
* 프로그램 ID : PG_06_B_016_03
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-06-23
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
String SessionUserId	= "";
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
if (sessionInfo != null){ 
 SessionUserId	= sessionInfo.getUserId();
}
String return_reason = CommonUtil.nvl((String) request.getParameter("return_reason"),"");
String recv_qty      = CommonUtil.nvl((String) request.getParameter("recv_qty"),"");
String com_code      = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");
String pr_no         = CommonUtil.nvl((String) request.getParameter("st_pr_no"),"");
String pr_seq        = CommonUtil.nvl((String) request.getParameter("st_pr_seq"),"");

String old_amt       = CommonUtil.nvl((String) request.getParameter("st_old_amt"),"");
String new_amt       = CommonUtil.nvl((String) request.getParameter("st_new_amt"),"");
String account_type  = CommonUtil.nvl((String) request.getParameter("st_account_type"),"");
String budget_dept   = CommonUtil.nvl((String) request.getParameter("st_budget_dept"),"");
String budget_flag   = CommonUtil.nvl((String) request.getParameter("st_budget_flag"),"");
String row           = CommonUtil.nvl((String) request.getParameter("st_row"),"");

%>

<script type="text/javascript">
<!--



function setSave(){

	
    var value = document.forms.buyerPrRecvReturnReasonPop.return_reason.value;

	if(isEmpty(value) || value.length<=5) {
		alert("사유를 입력하여 주십시요.(한글6자리이상)");
		document.forms.buyerPrRecvReturnReasonPop.return_reason.value='';
		document.forms.buyerPrRecvReturnReasonPop.return_reason.focus();
		return;
	}
 
    if(value != "")  opener.setReturnReason( KepFilterString(value) ); 
 
    //document.forms.buyerPrRecvReturnReasonPop.action = "/kr/customer/proxybuy/pr_recv_return_reason_reg2.jsp?st_account_type="+account_type+"&st_budget_dept="+budget_dept+"&st_old_amt="+old_amt+"&st_new_amt="+new_amt+"&st_row="+row;
    kepAjaxPopFormCall("/mppo/savePrRecvReturnReasonReg.do","buyerPrRecvReturnReasonPop","PR_RECV_RETURN_REASON_REG2"); 

    
}


function chk_byte(max_byte){

  if (kepGetByteLength("return_reason") > max_byte) {
          alert("사유는 한글 200자(영문 400자) 이상 입력할 수 없습니다.");
          ta_name.focus();          
  }
 
	     
}
 
	/**
	 * ajax 공통 호출후 성공시 처리 함수
	 */
	function kepAjaxPopSuccess(pMethod , response){  
		
	    var result =  response.msg.MSG;   
	    var row    = "<%=row%>";
	    
		if (pMethod == "PR_RECV_RETURN_REASON_REG2"){
			  alert("저장되었습니다.");
			 opener.prRecvReturnReasonResult(result, row);
		     self.close();
		}  
	}

	/**
	 * ajax 공통 호출후 에러시 처리 함수
	 */
	function  kepAjaxPopError(pMethod , response) { 
		if (pMethod == "PR_RECV_RETURN_REASON_REG2"){
			 alert("저장에 실패하였습니다. 당사 기술연구소로 연락바랍니다.");
		} 
	} 

	
 //-->
</script> 
<body onload="">
<form name="buyerPrRecvReturnReasonPop" id="buyerPrRecvReturnReasonPop" method=post >
<input type="hidden" name="x" size="10" maxlength="10" value="">
<input type="hidden" name="y" size="10" maxlength="10" value="">
<input type="hidden" name="recv_qty" value="<%=recv_qty%>">
<input type="hidden" name="st_com_code" value="<%=com_code%>">
<input type="hidden" name="st_pr_no" value="<%=pr_no%>">
<input type="hidden" name="st_pr_seq" value="<%=pr_seq%>">
<input type="hidden" name="st_budget_flag" value="<%=budget_flag%>">
<input type="hidden" name="st_account_type" value="<%=account_type%>">
<input type="hidden" name="st_new_amt" value="<%=new_amt%>">
<input type="hidden" name="st_old_amt" value="<%=old_amt%>">	
<input type="hidden" name="st_budget_dept" value="<%=budget_dept%>">	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:400px;">
    	<div id="popHeader">
        	<h1 class="title">사유 등록</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
                 
     			<table class="cont_t_list05" style="background-color: #FAF9CF;">
				<tr > 
					<td style="width:100%">사유</td> 
				</tr>

            </table>
 			<table >
                <tr>
                    <td height="5"></td>
                </tr>
            </table >
             <table class="cont_t_list05">
                <tr> 
                    <td >
                        <textarea   cols="70" rows="5" name="return_reason"  id="return_reason" onkeyup="chk_byte( 400);"><%=return_reason%></textarea>
                    </td>
                </tr>
            </table>   
            <br>
 		<div class="btnArea">
		 <span class="btn_02 mr04" title="확인" > <a href="javascript:setSave();">확인</a></span>
		            </div>
		            
		            
    </div>        
</div>
</form> 
</body>
</html>
