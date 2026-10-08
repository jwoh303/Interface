<%--
**********************************************
* 메뉴 : 
* 화면 : 요청수량 변경사유
* 기능 : 요청수량 변경사유 입력 팝업
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-04-27
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
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

String tab_id = CommonUtil.nvl((String) request.getParameter("tab_id"),"");

%>

<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";



function setSave(){
	var tab_id = "<%=tab_id%>";
	
    var value = document.forms.buyerPrRecvReturnReasonPop.return_reason.value;

	if(isEmpty(value) || value.length<=5) {
		//사유를 입력해주세요(6자 이상)
		var text = "<%=CommonLang.msg("MSG799") %>  ";  
	  	openLayerPopText2(text,but1text,but1func,but1width);
	  	
// 		document.forms.buyerPrRecvReturnReasonPop.return_reason.value='';
		document.forms.buyerPrRecvReturnReasonPop.return_reason.focus();
		return;
	}
 
    if(value != "")  opener.tabs[tab_id]["setReturnReason"]( KepFilterString(value) ); 
 
    //document.forms.buyerPrRecvReturnReasonPop.action = "/kr/customer/proxybuy/pr_recv_return_reason_reg2.jsp?st_account_type="+account_type+"&st_budget_dept="+budget_dept+"&st_old_amt="+old_amt+"&st_new_amt="+new_amt+"&st_row="+row;
    kepAjaxPopFormCall("/mppo/savePrRecvReturnReasonReg.do","buyerPrRecvReturnReasonPop","PR_RECV_RETURN_REASON_REG2"); 

    
}


 
	/**
	 * ajax 공통 호출후 성공시 처리 함수
	 */
	function kepAjaxPopSuccess(pMethod , response){  
		
	    var result =  response.msg.MSG;   
	    var row    = "<%=row%>";
	    var tab_id = "<%=tab_id%>";
	    
		if (pMethod == "PR_RECV_RETURN_REASON_REG2"){
			 opener.tabs[tab_id]["prRecvReturnReasonResult"](result);
		     self.close();
		}  
	}

	/**
	 * ajax 공통 호출후 에러시 처리 함수
	 */
	function  kepAjaxPopError(pMethod , response) { 
		if (pMethod == "PR_RECV_RETURN_REASON_REG2"){
			//저장에 실패하였습니다.다시한번 시도해 주시기 바랍니다.  
			var text = "<%=CommonLang.msg("MSG237") %>  ";  
			openLayerPopText2(text,but1text,but1func,but1width);
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
	<div class="wrapPopupAlert">
    <div class="PopupTit"><%=CommonLang.get("HTITLE1255")%><!--수량 변경 사유--><span><a href="javascript:self.close();" class="closePopup"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
    <div class="AlertTxtM mt15 mb30">
      <div class="TextField mt10" id="limitedArea">
       <textarea id="return_reason" name="return_reason" style=" width:92%; height:50px;" maxlength="200" placeholder="<%=CommonLang.msg("MSG799") %>"><%=return_reason %></textarea><!-- 사유를 입력해주세요(6자 이상) -->
        <div class="meta" aria-live="polite"> <span id="count">0</span>/200 </div>
      </div>
    </div>
    <div class="PopupListBtnBox_Center">
      <button class="ButQuaternary_large closePopup" onclick="javascript:self.close(); return false;"><%=CommonLang.get("HTITLE229")%><!-- 취소 --></button>
      <button class="ButPrimary_large" onclick="javascript:setSave(); return false;"><%=CommonLang.get("HTITLE440")%><!-- 등록 --></button>
      <script>
          (function () {
            const wrap = document.getElementById('limitedArea');
            const ta   = document.getElementById('return_reason');
            const cnt  = document.getElementById('count');
            const MAX  = parseInt(ta.getAttribute('maxlength'), 10);
            function update() {
              const len = ta.value.length;
              cnt.textContent = len;
            }
            // 초기 상태 반영 및 입력 시 업데이트
            update();
            ta.addEventListener('input', update);
          })();
		  </script>   
    </div>
  </div>
</form> 
</body>
</html>
