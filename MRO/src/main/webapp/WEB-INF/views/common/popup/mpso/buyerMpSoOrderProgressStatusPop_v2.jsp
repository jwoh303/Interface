<%--
**********************************************
* 메뉴 : 주문/배송조회
* 화면 : 진행상태 팝업
* 기능 : 진행상태 팝업
* 프로그램 ID :  BU0402004
* 담당자 : 최찬규
* 착수일 : 2026-04-03
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
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
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	
	String status_code = (String) request.getParameter("st_status_code");
	String status_text = (String) request.getParameter("st_status_text");
	String pr_jobdate = (String) request.getParameter("st_pr_jobdate");
	String po_jobdate = (String) request.getParameter("st_po_jobdate");
	String iv_jobdate = (String) request.getParameter("st_iv_jobdate");
	String gr_jobdate = (String) request.getParameter("st_gr_jobdate");

%>

<script type="text/javascript">

function kep_onload(){
	
}
</script> 
<body onload="kep_onload()">
<div class="wrapPopup">
  <div class="PopupTit"><%=CommonLang.get("HTITLE1208")%><!--진행상태현황--><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="Popup_StateProcess mt20" >
  <%if(status_code.equals("PR10") || status_code.equals("PR20") || status_code.equals("PR30") || status_code.equals("PR40")) {%>
    <ul>
      <li class="BlueArrow"><div class="BallBlue"><img src="/resources/imgs/StateProcess_01.png" /></div> <div class="StateTxt"><%=status_text %> <br/><span></span></div></li>
      <li class="GrayLine01"><div class="BallGray"><img src="/resources/imgs/StateProcess_06.png" /></div> <div class="StateTxt"><br/><span></span></div></li>
      <li class="GrayLine02"><div class="BallGray"><img src="/resources/imgs/StateProcess_04.png" /></div> <div class="StateTxt"><br/><span></span></div></li>
      <li class="GrayLine04"><div class="BallGray"><img src="/resources/imgs/StateProcess_03.png" /></div> <div class="StateTxt"><br/><span></span></div></li>
    </ul>
  <%}else if(status_code.equals("PR50") || status_code.equals("PR60") || status_code.equals("PR70") || status_code.equals("PR80") || status_code.equals("PR90")) {%>
    <ul>
      <li class="BlueLine01"><div class="BallBlue"><img src="/resources/imgs/StateProcess_05.png" /></div> <div class="StateTxt">요청완료 <br/><span><%=pr_jobdate %></span></div></li>
      <li class="BlueArrowCenter"><div class="BallBlue"><img src="/resources/imgs/StateProcess_06.png" /></div> <div class="StateTxt"><%=status_text %><br/><span></span></div></li>
      <li class="GrayLine01"><div class="BallGray"><img src="/resources/imgs/StateProcess_04.png" /></div> <div class="StateTxt"> <br/><span></span></div></li>
      <li class="GrayLine04"><div class="BallGray"><img src="/resources/imgs/StateProcess_03.png" /></div> <div class="StateTxt"> <br/><span></span></div></li>
    </ul>
  <%}else if(status_code.equals("PX10") || status_code.equals("PX20") || status_code.equals("PX30") || status_code.equals("PX40") || status_code.equals("PX50") || status_code.equals("PX60")) {%> 
    <ul>
      <li class="BlueLine01"><div class="BallBlue"><img src="/resources/imgs/StateProcess_05.png" /></div> <div class="StateTxt">요청완료 <br/><span><%=pr_jobdate %></span></div></li>
      <li class="BlueLine02"><div class="BallBlue"><img src="/resources/imgs/StateProcess_05.png" /></div> <div class="StateTxt">주문완료 <br/><span><%=po_jobdate %></span></div></li>
      <li class="BlueArrowCenter"><div class="BallBlue"><img src="/resources/imgs/StateProcess_04.png" /></div> <div class="StateTxt"><%=status_text %> <br/><span></span></div></li>
      <li class="GrayLine03"><div class="BallGray"><img src="/resources/imgs/StateProcess_03.png" /></div> <div class="StateTxt"> <br/><span></span></div></li>
    </ul> 
  <%}else{ %>
    <ul >
      <li class="BlueLine01"><div class="BallBlue"><img src="/resources/imgs/StateProcess_05.png" /></div> <div class="StateTxt">요청완료 <br/><span><%=pr_jobdate %></span></div></li>
      <li class="BlueLine02"><div class="BallBlue"><img src="/resources/imgs/StateProcess_05.png" /></div> <div class="StateTxt">주문완료 <br/><span><%=po_jobdate %></span></div></li>
      <li class="BlueLine02"><div class="BallBlue"><img src="/resources/imgs/StateProcess_05.png" /></div> <div class="StateTxt">배송완료 <br/><span><%=iv_jobdate %></span></div></li>
      <li class="BlueLine03"><div class="BallBlue"><img src="/resources/imgs/StateProcess_03.png" /></div> <div class="StateTxt"><%=status_text %><br/><%if(status_code.equals("GR20")) {%><span> <%=gr_jobdate %> </span><%}else{ %><span></span> <%} %></div></li>
    </ul>
  <%} %>       
  </div>
  <div class="Importance mt30"><img src="/resources/imgs/Icon_Importance04.png" /> <%=CommonLang.msg("MSG777")%><!--번호는--> <span class="font500"><%=CommonLang.msg("MSG778")%><!--주문요청번호, 발주번호, 송장번호--></span> <%=CommonLang.msg("MSG779")%><!--최초 생성일시가 표기됩니다.--></div>
  <div class="ScrollBox mt20" style="height:342px">
  <table class="Table14px"  style="width:100%">
    <colgroup>
      <col width="7%" />
      <col width="30%" />
      <col width="15%" />
      <col width="15%" />
      <col width="10%" />
      <col width="23%" />
    </colgroup>
    <tr>
      <th><%=CommonLang.get("HTITLE140")%><!-- 순번 --></th>
      <th><%=CommonLang.get("HTITLE255")%><!-- 상태 --></th>
      <th><%=CommonLang.get("HTITLE44")%><!-- 번호 --></th>
      <th><%=CommonLang.get("HTITLE325")%><!-- 이름 --></th>
      <th><%=CommonLang.get("HTITLE476")%><!-- 직급 --></th>
      <th><%=CommonLang.get("HTITLE1209")%><!--일시--></th>
    </tr>
    <%if(_gridList.size()>0 && _gridList != null) {
    	for(int i = 0; i<_gridList.size(); i++){
    %>
	    <tr>
	      <td align="center"><%=i+1 %></td>
	      <td align="left"><%=CommonUtil.nvl(_gridList.get(i).get("STTS_NM"))%></td>
	      <td align="center"><%=CommonUtil.nvl(_gridList.get(i).get("MEMO"))%></td>
	      <td align="center"><%=CommonUtil.nvl(_gridList.get(i).get("NAME"))%></td>
	      <td align="center"><%=CommonUtil.nvl(_gridList.get(i).get("POSITION"))%></td>
	      <td align="center"><%=CommonUtil.nvl(_gridList.get(i).get("JOBDATE"))%></td>
	    </tr>
	    <%} %>
    <%} %>
    
  </table>
  </div>

   
</div><!-- warp 끝-->
</body>
</html>
