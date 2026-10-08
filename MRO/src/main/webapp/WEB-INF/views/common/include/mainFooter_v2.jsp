<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script type="text/javascript">
function doPopFooter(str) {
	popupSel = str;
	switch (str) {
		case "privacy":
			window.open("/common/pop_privacy_v2.do","pop_privacy","width=1000, height=600, scrollbars=yes");
			break;
		case "email":
			openSearchPopup("/common/pop_email_v2.do","", "400,260,no");
			break;
	}
}
</script>

<footer class="footer" id="footer">
  <div class="footer_wrap">
    <section>
      <h2><img src="/resources/imgs/logo.png" /></h2>
    </section>
    <section>
      <div class="boardinfo">
        <ul>
          <li><a href="javascript:doPopFooter('privacy');">개인정보처리방침</a></li>
          <li><a href="javascript:doPopFooter('email');">이메일무단수집거부</a></li>
          <li><a href="https://www.tradesign.net/ra/koreab2b" target="_blank">공인인증서</a></li>
          <li><a href="https://www.ftc.go.kr/bizCommPop.do?wrkr_no=1078185880" target="_blank">사업자정보확인</a></li>
        </ul>
      </div>
    </section>
    <section>
      <address>
        <ul>
          <li><span>대표이사</span>오승엽</li>
          <li><span>주소</span>서울특별시 강남구 개포로 619 서울강남우체국빌딩 7층</li> <br/>
          <li><span>사업자등록번호</span>107-81-85880</li>
          <li><span>통신판매업신고번호</span>2015-서울강남-03012</li>
        </ul>
      </address>
      <div class="copy">CopyrightⓒKorea e Platform. All Right Reserbed.</div>
    </section>
    <div class="customerTime"><span>운영시간</span> 평일 08:30 ~ 17:30 </div>
    <div class="remoteSupport" onclick="window.open('http://113366.com/koreab2b','_blank')"><img src="/resources/imgs/Icon_remote.png" /><span>원격지원 바로가기</span></div>
  	<div class="isms"><img src="/resources/imgs/isms.svg" alt="정보보호 관리체계 인증 마크" /> <p>[인증범위] 온라인 구매대행 서비스 운영(코리아비투비)<br/>[유효기간] 2024.11.03 ~ 2027.11.02</p></div>
  </div>
</footer>
