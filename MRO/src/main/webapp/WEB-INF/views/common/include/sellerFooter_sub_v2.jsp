<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String fsslurl = CommonUtil.getSslURL(request, "http");
SessionInfo _sessionInfoFooter = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String SessionComCodeFooter		= _sessionInfoFooter.getComCode();
%>
<script type="text/javascript">
//팝업함수호출
function doPopFooter(str) {
	popupSel = str;
	
	switch (str) {
		case "privacy": // 개인정보취급
			window.open("/common/pop_privacy.do","pop_privacy","width=1000, height=600, scrollbars =yes");
			break;
		case "icomcmpyPop":	// 거래명세서 양식 팝업
			openSearchPopup("/mpiv/getCommonMpIvTranBuyerInfoPop.do", "?st_com_code=<%=SessionComCodeFooter%>"+"&popup_flag=2", "440,500,no");
// 			openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=B&MULTI=N','500,466,no');
			break;
		case "centerInfoPop":
			openSearchPopup('/common/pop_centerInfo.do','','1120,750,no');
	}
}
</script>
<footer class="footerSub" id="footer">
      <div class="footer_wrap">
        <section>
          <h2><img src="/resources/imgs/logo.png" /></h2>
          <div class="Guide">
            <ul>
<!--               <li><a href=""><img src="/resources/imgs/footerGuide01.png" />물류비 발행내역</a></li> -->
              <li><a href="javascript:doPopFooter('centerInfoPop','');"><img src="/resources/imgs/footerGuide02.png" />물류센터 안내</a></li>
<!--               <li><a href="javascript:doPopFooter('icomcmpyPop','');"><img src="/resources/imgs/footerGuide03.png" />거래명세서 양식 다운로드</a></li> -->
              <li><a href="/resources/excel/work/MAIN/Kep_Supplier_Manual_v2026.zip"><img src="/resources/imgs/footerGuide04.png" />매뉴얼 다운로드</a></li>
            </ul>
          </div>
        </section>
        <section>
          <div class="boardinfo">
            <ul>
              <li><a href="javascript:doPopFooter('privacy');">개인정보처리방침</a></li>
              <li><a href="javascript:poptype01('<%=fsslurl%>');">이메일무단수집거부</a></li>
              <li><a href="https://www.tradesign.net/ra/koreab2b" target="_blank">공인인증서 </a></li>
              <li><a href="https://www.ftc.go.kr/bizCommPop.do?wrkr_no=1078185880" target="_blank">사업자정보확인</a></li>
            </ul>
            <div class="Callcenter" ><p><span>고객센터</span>02-3016-8989</p>  <p><span>팩스</span>02-569-9724</p></div>
          </div>

        </section>
        <section>
          <address>
            <ul>
              <li><span>대표이사</span>오승엽</li>
              <li><span>주소</span>서울특별시 강남구 개포로 619 서울강남우체국빌딩 7층</li>
              <li><span>사업자등록번호</span>107-81-85880</li>
              <li><span>통신판매업신고번호</span>2015-서울강남-03012 </li>
            </ul>
          </address>
          <div class="copy">CopyrightⓒKorea e Platform. All Right Reserbed. </div>
          <!--div class="isms"><img src="images/isms.png"></img><p>[인증범위] 온라인 구매대행 서비스 운영(코리아비투비)<br />[유효기간] 2021.11.03 ~ 2024.11.02</p></div-->
        </section>
      </div>
</footer>