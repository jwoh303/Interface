<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />


<link rel="stylesheet" href="/resources/css/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/css/main_com.css" type="text/css" />


<script type="text/javascript">
</script>
</head>
<div class="wrap">
    <!--TOP bar-->
	<section class="header" >
      <h1><a href="/main.do"><img src="/resources/imgs/logo.png" /></a></h1>
      <div class="FamilySite">
        <div class="FamilySite-btn">Family Site</div>
        <div class="FamilySite-content">
          <div onclick="openSite('https://safety.koreab2b.com')">건설MRO</div>
          <div onclick="openSite('https://kway.koreab2b.com')">Kway</div>
          <div onclick="openSite('http://www.kepchina.cn')">중국법인</div>
          <div onclick="openSite('http://www.koreab2b-eu.com')">유럽법인</div> 
        </div>
      </div>
      <script>
      function openSite(url) {
        window.open(url, "_blank");
      }
      </script>      
    </section>
	<!--TOP bar-->
	<div class="ComNavigation">
      <div class="navigationBar">
        <ul>
        <li onclick="location.href='Com_고객사가입안내.html'">고객사 가입 안내</li>
        <li onclick="location.href='Com_협력사가입안내.html'" class="ON">협력사 가입 안내</li>
        <li onclick="location.href='Com_자주묻는질문.html'">자주 묻는 질문</li>
        </ul>
      </div>
    </div>
	<!-- 컨텐츠 -->
	<div class="containerBox" >
      <div class="h80"></div> 
      <div class="ComJoinTitLarge" >협력사 유형 선택</div>
      <div class="h30"></div> 
      <div class="SellerChoice">
        <div class="SellerChoice-tabs">
          <div class="SellerChoice-tab" data-target="content1"><div class="TabTit" ><p>처음 거래하시나요?</p>처음 거래를 시작하시려는 협력사라면,<br/> 먼저 협력사 가입 신청이 필요합니다.</div> </div>
          <div class="SellerChoice-tab" data-target="content2"><div class="TabTit" ><p>기존 협력사이신가요?</p>이미 거래 중인 협력사의 직원이라면,<br/> 사이트 이용을 위해 사용자 등록을 요청해주세요.</div> </div>
        </div>
        <div class="h80"></div> 
        
        <div id="content1" class="SellerChoice-content">
          <div class="ComJoinTitMedium_center mb30" >신규가입 프로세스</div>
          <div class="JoinStepNew">
           <ul>
             <li><span>step. 1</span><br/><p>신규 가입 요청</p><img src="/resources/imgs/com_icon01.png" /><br/> 거래정보 입력 후<br/> 신규가입요청을 해주세요.</li>
             <li><span>step. 2</span><br/><p>내부 심사</p><img src="/resources/imgs/com_icon02.png" /><br/>등록정보와 제출 서류를<br/>  내부에서 심사합니다.</li>
             <li><span>step. 3</span><br/><p>전자계약 체결</p><img src="/resources/imgs/com_icon03.png" /><br/>협력사 등록을 위한 <br/> 전자 계약을 체결합니다.</li>
             <li><span>step. 4</span><br/><p>로그인</p><img src="/resources/imgs/com_icon04.png" /><br/> 계약체결이 완료되면 <br/> 사이트 이용이 가능합니다.</li>
           </ul>
          </div>
          <div class="h80"></div>
          <div class="ComButtonArea"><button class="ButtonLarge" onclick="location.href='/mdam/showMasterMdAmMbrUserReg.do'">신규 가입요청 바로 가기</button></div>              
        </div><!-- content1 끝 -->    
        <div id="content2" class="SellerChoice-content">
          <div class="ComJoinTitMedium_center mb30" >사용자가입 프로세스</div>
          <div class="JoinStepOld">
           <ul>
             <li><span>step. 1</span><br/><p>사용자 등록 요청</p><img src="/resources/imgs/com_icon01.png" /><br/> 사이트에서 사용자 등록을  <br/> 신청합니다.</li>
             <li><span>step. 2</span><br/><p>승인 절차</p><img src="/resources/imgs/com_icon05.png" /><br/>코리아e플랫폼 담당자가<br/>사용자 등록을 승인합니다.<br/>  <div class="contact">담당자 연락처 :  02-3016-7251</div></li>
             <li><span>step. 3</span><br/><p>로그인</p><img src="/resources/imgs/com_icon04.png" /><br/> 승인이 완료되면<br/>사이트를 이용하실 수 있습니다.</li>
           </ul>
          </div>
          <div class="h80"></div> 
          <div class="ComButtonArea"><button class="ButtonLarge" onclick="location.href='/mdam/showMasterPartnerUserReg.do'">사용자 등록 바로가기</button></div>            
        </div><!-- content2 끝 -->    
      </div><!-- SellerChoice 끝 -->     
	  <script>
          const tabs = document.querySelectorAll(".SellerChoice-tab");
          const contents = document.querySelectorAll(".SellerChoice-content");
        
          tabs.forEach(tab => {
            tab.addEventListener("click", () => {
              const targetId = tab.getAttribute("data-target");
              const targetContent = document.getElementById(targetId);
        
              const isOpen = targetContent.classList.contains("open");
        
              // 모든 탭/내용 초기화
              tabs.forEach(t => t.classList.remove("active"));
              contents.forEach(c => {
                c.classList.remove("open", "opening");
              });
        
              if (!isOpen) {
                tab.classList.add("active");
        
                // 열릴 때만 부드럽게
                targetContent.classList.add("opening");
        
                // 애니메이션이 끝나면 open으로 고정 (닫힐 땐 애니메이션 없음)
                setTimeout(() => {
                  targetContent.classList.remove("opening");
                  targetContent.classList.add("open");
                }, 500); // transition 시간과 동일
              }
            });
          });
        </script>       
      
      <div class="h80"></div> 
	</div><!-- containerBox 끝 -->
      
    
    <!-- 푸터 -->
    <footer class="footer" id="footer">
      <div class="footer_wrap">
        <section>
          <h2><img src="/resources/imgs/logo.png" /></h2>
        </section>
        <section>
          <div class="boardinfo">
            <ul>
              <li><a href="" target="_blank">개인정보처리방침</a></li>
              <li><a href="" target="_blank">이메일무단수집거부</a></li>
              <li><a href="" target="_blank">공인인증서 </a></li>
              <li><a href="" target="_blank">사업자정보확인</a></li>
            </ul>
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
</div><!-- warp 끝-->
 
</body>
</html>

