<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String fsslurl = CommonUtil.getSslURL(request, "http"); 
%>
<script type="text/javascript">
//팝업함수호출
function doPopFooter(str) {
	popupSel = str;
	
	switch (str) {
		case "privacy": // 개인정보취급
			window.open("/common/pop_privacy.do","pop_privacy","width=1000, height=600, scrollbars =yes");
			break;
	}
}
</script>
    <div id="footWrap">
    	<div id="footer">
        	<!--p class="logo"><img src="/resources/images/img_footlogo.gif" alt="코리아 e 플랫폼 로고" /></p-->
            <ul class="article">
                <li class="first"><a href="javascript:doPopFooter('privacy');"><img src="/resources/images/btn_foot02.gif" alt="개인정보처리방침" /></a></li>
                <!--  <li><a href="/kr/customer/main/2014_home/member/member_join.jsp"><img src="/resources/images/btn_foot03.gif" alt="이용약관안내" /></a></li> -->
                <li><a href="#" onClick="poptype01('<%=fsslurl%>');"><img src="/resources/images/btn_foot04.gif" alt="이메일무단수집거부" /></a></li>
            	<li><a href="http://ftc.go.kr/info/bizinfo/communicationView.jsp?apv_perm_no=2015322016230203012&area1=&area2=&currpage=1&searchKey=04&searchVal=1078185880&stdate=&enddate=" target="_blank"><img src="/resources/images/btn_foot06.gif" alt="사업자정보확인"  /></a></li>
            </ul>
            <address><img src="/resources/images/icn_addr.gif" alt="서울특별시 서초구 강남대로 331 광일빌딩 13.14.15.19층   전화:02.3016.8989   팩스:02.569.6724   대표이사:이우석   사업자등록번호:107-81-85880   통신판매업신고번호:2007-서울서초-10658  COPYRIGHT(C) 2011 korea e platform  ALL RIGHT RESERVED" usemap="#Map" border="0" />
            <map name="Map">
              <area shape="rect" coords="172,27,242,39" href="#">
            </map>
            </address>
            <ul class="footCate">
            	<li><img src="/resources/images/img_footcate01.gif" alt="e-비즈니스대상"/></li>
                <li><img src="/resources/images/img_footcate02.gif" alt="e-biz브랜드혁신대상" /></li>
            </ul>
        </div>
    </div>
