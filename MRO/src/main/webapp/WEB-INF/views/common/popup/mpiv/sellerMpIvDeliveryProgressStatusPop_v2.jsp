<%--
**********************************************
* 메뉴 : 
* 화면 : 협력사 납품진행현황 > 진행상태에 따른 팝업
* 기능 : 
* 프로그램 ID : SU0501002 
* 담당자 :  최찬규
* 착수일 : 2025-09-19
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
</head>
<%
	String st_status = CommonUtil.nvl((String) request.getParameter("st_status"),"");
	String st_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");
	String st_inv_no = CommonUtil.nvl((String) request.getParameter("st_inv_no"),"");
	String st_pors_date = CommonUtil.nvl((String) request.getParameter("st_pors_date"),"");
	String st_ivdt_date = CommonUtil.nvl((String) request.getParameter("st_ivdt_date"),"");
	String st_invoice_date = CommonUtil.nvl((String) request.getParameter("st_invoice_date"),"");
	String st_delivery_add_date = CommonUtil.nvl((String) request.getParameter("st_delivery_add_date"),"");
	if(!st_invoice_date.equals("")){
		st_invoice_date = st_invoice_date.substring(0,4) + "-" + st_invoice_date.substring(4,6) + "-" + st_invoice_date.substring(6,8) ;
	}
%>

<body>
	<form name="sellerMpIvDeliveryProgressStatusPop" id="sellerMpIvDeliveryProgressStatusPop" method=post>
<div class="wrapPopup">
  <div class="PopupTit">진행상태현황<span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h20"></div>
  <div class="Popup_StateProcess">
  <%if(st_status.equals("수주접수대상")) {%>
    <ul>
      <li class="BlueArrow"><div class="BallBlue"><img src="/resources/imgs/StateProcess_01.png" /></div> <div class="StateTxt">수주접수 전 <br/><span></span></div></li>
      <li class="GrayLine01"><div class="BallGray"><img src="/resources/imgs/StateProcess_02.png" /></div> <div class="StateTxt"><br/><span></span></div></li>
      <li class="GrayLine02"><div class="BallGray"><img src="/resources/imgs/StateProcess_03.png" /></div> <div class="StateTxt"><br/><span></span></div></li>
      <li class="GrayLine04"><div class="BallGray"><img src="/resources/imgs/StateProcess_04.png" /></div> <div class="StateTxt"><br/><span></span></div></li>
    </ul>
   <%}else if(st_status.equals("거래명세서 생성대상")){ %> 
    <ul>
      <li class="BlueLine01"><div class="BallBlue"><img src="/resources/imgs/StateProcess_05.png" /></div> <div class="StateTxt">수주접수완료 <br/><span><%=st_pors_date %></span></div></li>
      <li class="BlueArrowCenter"><div class="BallBlue"><img src="/resources/imgs/StateProcess_02.png" /></div> <div class="StateTxt">거래명세서 생성 전 <br/><span></span></div></li>
      <li class="GrayLine01"><div class="BallGray"><img src="/resources/imgs/StateProcess_03.png" /></div> <div class="StateTxt"> <br/><span></span></div></li>
      <li class="GrayLine04"><div class="BallGray"><img src="/resources/imgs/StateProcess_04.png" /></div> <div class="StateTxt"> <br/><span></span></div></li>
    </ul>
    <%}else if(st_status.equals("납품실적 등록대상")){ %>
    <ul>
      <li class="BlueLine01"><div class="BallBlue"><img src="/resources/imgs/StateProcess_05.png" /></div> <div class="StateTxt">수주접수완료 <br/><span><%=st_pors_date %></span></div></li>
      <li class="BlueLine02"><div class="BallBlue"><img src="/resources/imgs/StateProcess_05.png" /></div> <div class="StateTxt">거래명세서 생성완료 <br/><span><%=st_ivdt_date %></span></div></li>
      <li class="BlueArrowCenter"><div class="BallBlue"><img src="/resources/imgs/StateProcess_01.png" /></div> <div class="StateTxt">납품실적 등록 전 <br/><span></span></div></li>
      <li class="GrayLine03"><div class="BallGray"><img src="/resources/imgs/StateProcess_04.png" /></div> <div class="StateTxt"> <br/><span></span></div></li>
    </ul>
    <%}else{ %> 
    <ul>
      <li class="BlueLine01"><div class="BallBlue"><img src="/resources/imgs/StateProcess_05.png" /></div> <div class="StateTxt">수주접수완료 <br/><span><%=st_pors_date %></span></div></li>
      <li class="BlueLine02"><div class="BallBlue"><img src="/resources/imgs/StateProcess_05.png" /></div> <div class="StateTxt">거래명세서 생성완료 <br/><span><%=st_ivdt_date %></span></div></li>
      <li class="BlueLine02"><div class="BallBlue"><img src="/resources/imgs/StateProcess_05.png" /></div> <div class="StateTxt">납품실적 등록완료 <br/><span><%=st_delivery_add_date %></span></div></li>
      <li class="BlueLine03"><div class="BallBlue"><img src="/resources/imgs/StateProcess_03.png" /></div> <div class="StateTxt">납품완료 <br/><span><%=st_invoice_date %></span></div></li>
    </ul>
    <%} %>       
  </div>
  <div class="h30"></div>
  <table class="PopTableThLTdL" style="width:600px">
    <colgroup>
      <col width="15%" />
      <col width="35%" /> 
      <col width="20%" />
      <col width="30%" />    
    <tr>
      <th>발주번호</th>
      <td><%=st_po_no %></td>
      <th>거래명세서 번호</th>
      <td><%=st_inv_no %></td>
    </tr>
  </table>
  </div>
</div><!-- warp 끝-->
	</form>
</body>
</html>
