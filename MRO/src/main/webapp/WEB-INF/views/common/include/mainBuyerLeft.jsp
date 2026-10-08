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
		$(".lnb_ul_3depth").hide();
			$(".lnb_li_2depth a").click(function() {
				$(this).parent().parent().find(".lnb_ul_3depth").toggle();
			}); 

		var obj2;
		var w2;

			$(window).resize(function() { // 화면 리사이즈시 다시검사....
				var winWidth = $(window).width();
				//alert(winWidth);
				if (winWidth < 1200) {
					$("#ContArea").css("width", "995px"); 
					$(".cont_searchA").css("width", "995px");
				} else  {
					$("#ContArea").css("width", "97%");		
				}  
			});
			
			$("#ContArea").css("width", "97%");

		});
</script>
 
<div id="lnbArea" style="display:none;">
	<p class="lnb_title"><a href="/mdcm/showBuyerMdCmCategoryGoodsSearch.do?upperId=b00100000000"><font color="white"><%=request.getAttribute("title")%></font></a></p>
	<p class="lnb_hide">
		<a href="javascript:leftShowTopHidden('hide')"><img src="/resources/images/lnb_btn_hide.gif" alt="숨기기버튼" /></a>
	</p>
	<div id="lnbBox">
		<ul class="lnb_1depth">
			<%=request.getAttribute("menu")%> 
		</ul>
	</div>
</div>
 
