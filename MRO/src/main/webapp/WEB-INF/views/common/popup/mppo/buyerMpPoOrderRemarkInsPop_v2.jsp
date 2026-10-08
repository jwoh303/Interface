<%--
**********************************************
* 메뉴 : 
* 화면 : 발주자 비고입력
* 기능 : 구매요청자의 비고를 확인할 수 있고, 구매발주자의 비고를 입력할 수 있다.
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-06-08
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
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
</head>
<%
@SuppressWarnings (value="unchecked")
String po_remark = CommonUtil.nvl((String) request.getParameter("remark"),"");
// po_remark = po_remark.replaceAll("&lt;br&gt;","\n");
String tab_id = CommonUtil.nvl((String) request.getParameter("tab_id"),"");

%>

<script type="text/javascript">
 
function confirm(){
	var remark = document.forms.buyerMpPoOrderRemarkInsPop.po_remark.value; 
	remark = remark.replace(/\r?\n/g, '');
	var tab_id = "<%=tab_id%>";
	if(tab_id != ""){
		opener.tabs[tab_id]["setPopupReturn"](remark);
	}else{
		opener.setPopupReturn(remark);
	}
	self.close();
}


</script> 
<body>
<form name="buyerMpPoOrderRemarkInsPop" id="buyerMpPoOrderRemarkInsPop" method=post > 
	
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE122")%><!--비고--><span><a href="javascript:self.close();" class="closePopup"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="AlertTxtM mt15 mb30" style="text-align: left;">
      <div class="TextField mt10" id="limitedArea">
       <textarea id="po_remark" name="po_remark" style=" width:92%; height:100px;" ><%=po_remark%></textarea>
      </div>
    </div>   
  <div class="PopupListBtnBox_Center mt30">
    <button class="ButQuaternary_large closePopup" onclick="javascript:self.close(); return false;"><%=CommonLang.get("HTITLE229")%><!-- 취소 --></button>
    <button class="ButPrimary_large" onclick="javascript:confirm();return false;"><%=CommonLang.get("HTITLE516")%><!-- 확인 --></button>
  </div>  
</div><!-- wrapPopup 끝-->
</form> 
</body>
</html>
