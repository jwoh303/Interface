<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../include/head_v2.jspf"  %>
</head>
<%
	String atos_remark = CommonUtil.nvl((String) request.getParameter("st_atos_remark"),"");  //  (조회조건)
	atos_remark = atos_remark.replaceAll("&lt;br&gt;","\n");
	atos_remark = atos_remark.replaceAll("%26","&");
	
	String viewType = CommonUtil.nvl((String) request.getParameter("viewType"),"");
	
%>
<script type="text/javascript">

function kepConfirm()
{ 
  var value1 = $("#st_atos_remark").val();
  value1 = value1.replace(/\r?\n/g, '<br>');
  parent.setPopupReturn(value1,"");
  parent.closePop();
}

</script>  
<body >

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup">
  <div class="PopupTit">KeP 비고 <span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
<!--   <div class="Importance_Popup" style="width:480px; height:65px;line-height:30px; vertical-align: middle;" >▪ 코리아이플랫폼에 전달할 내용을 입력해주세요.</br>▪ 요청사항, 문의사항, 참고 메시지 등을 자유롭게 작성하실 수 있습니다.</div> -->
  <div class="h15"></div>
  <div class="TextField" id="limitedArea" style="width:500px">
  <%if(!viewType.equals("R")){ %>
    <textarea maxlength="400" placeholder=""  rows="6" style=" width:470px" id="st_atos_remark"><%=atos_remark%></textarea>
  <%}else{ %>
  	<textarea maxlength="400" placeholder=""  rows="6" style=" width:470px" id="st_atos_remark" readonly><%=atos_remark%></textarea>
  <%} %>
    <div class="meta" aria-live="polite"> <span id="count">0</span>/400 </div>
  </div>
	<script>
      (function () {
        const wrap = document.getElementById('limitedArea');
        const ta   = document.getElementById('st_atos_remark');
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
  <div class="h30"></div>
  <%if(!viewType.equals("R")){ %>
  <div class="PopupListBtnBox_Center" style="width:500px;">
    <button class="ButQuaternary_large" onclick="javascript:parent.closePop();" >취소</button>
    <button class="ButPrimary_large" onclick="javascript:kepConfirm(); return false;">등록</button>
  <%} %>
  </div> 

    
</div><!-- warp 끝-->    
</body>
</html>
