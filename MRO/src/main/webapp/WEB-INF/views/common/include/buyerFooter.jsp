<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	SessionInfo _f_sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String fsslurl = CommonUtil.getSslURL(request, "http");
	String footer_session_user_lang = "";//로그인 사용자 언어 정보
	if (_f_sessionInfo != null){
		footer_session_user_lang = CommonUtil.nvl((String)_f_sessionInfo.getLang());
	}
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
    <div class="FootWrap">
		<%
		//사용자 언어타입이 영어일 경우 주소만 표기
		if(footer_session_user_lang.equals("EN")) {
		%>  
            <div class="Footer">
              <p class="FooterLogo"><img src="/resources/images/KepLogo_Footer_en.gif" alt="로고" /></p>
              <p class="Address">Seoul Gangnam Post Office Bld 7th floor, Gaepo-Ro 619, Gangnam-Gu, Seoul-Si, Korea │CEO : Bae Sung Bae <br/> Business Registration No : 107-81-85880  │  Online Marketing Business Registration 2015-서울강남-02012 │ Tel +82-2-3016-8989 │ Fax +82-2-569-6724</p>
              <p class="InfoMark"><img src="/resources/images/img_footcate02.gif" alt="정보보호마크" /></p>
            </div>
		<%}else{%>
        <div class="Article">
        	<div class="ArticleIn">
                <p><a href="javascript:doPopFooter('privacy');" >개인정보처리방침</a></p>
                <p><a href="#" onClick="poptype01('<%=fsslurl%>');">이메일무단수집거부</a></p>
                <p><a href="https://www.tradesign.net/ra/koreab2b" target="_blank">공동인증서발급안내</a></p>
                <p><a href="http://ftc.go.kr/info/bizinfo/communicationView.jsp?apv_perm_no=2015322016230203012&area1=&area2=&currpage=1&searchKey=04&searchVal=1078185880&stdate=&enddate=" target="_blank">사업자정보확인</a></p>
        	</div>
        </div >
        <div class="Footer">
          <p class="FooterLogo"><img src="/resources/images/KepLogo_Footer.png" alt="로고" /></p>
          <p class="Address">  서울시 강남구 개포로 619 서울강남우체국빌딩 7층 │ 대표이사 : 오승엽 │ 사업자등록번호 : 107-81-85880 <br/> 통신판매업신고번호 2015-서울강남-02012 │ 전화 02-3016-8989 │ 팩스 02-569-6724 </p>
          <p class="InfoMark"><img src="/resources/images/img_footcate02.gif" alt="정보보호마크" /></p>
    	</div>
		<%}%>
    </div> 
    
    
 
