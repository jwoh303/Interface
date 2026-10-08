<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.menu.domain.Menu"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String leftMenu = CommonUtil.nvl(
			(String) request.getParameter("leftMenu"), ""); // 좌측메뉴 초기 출력여부
	String upperId = CommonUtil.nvl(
			(String) request.getParameter("upperId"), ""); // 좌측메뉴 초기 출력여부
%>
<script type="text/javascript">
	$(document).ready(function() {
<%if ("b00100000000".equals(upperId)
					|| "b00000000000".equals(upperId)) {%>
	$(".lnb_ul_3depth").hide();
		$(".lnb_li_2depth a").click(function() {
			$(this).parent().parent().find(".lnb_ul_3depth").toggle();
		});
<%}%>
	});
	function leftShowHidden(flag) {	
		if (flag == "onload_show" || flag == "show") {
			$("#lnbArea1").hide();
			$("#lnbArea").show();  
		} else {
			$("#lnbArea1").show();
			$("#lnbArea").hide();
		} 
		$.cookie('leftShowHidden', flag);

	}
</script>
<div id="lnbArea" class="lnbArea"  style="display:none;">
		<ul class="lnb_1depth">
			<%=request.getAttribute("menu")%>
		</ul>
		<p class="lnb_hide"> <a href="javascript:leftShowHidden('hide')"><img src="/resources/images/close_01.png" alt="닫기" /></a> </p>
</div>
