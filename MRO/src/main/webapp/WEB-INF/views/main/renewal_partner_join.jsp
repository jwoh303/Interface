<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<%@ include file="/WEB-INF/views/common/include/mainHeader_v2.jsp" %>
</head>
<body>
<div class="wrap">
	<div class="ComNavigation">
      <div class="navigationBar">
        <ul>
        <li onclick="location.href='/main/renewal_buyer_join.do'">고객사 가입 안내</li>
        <li onclick="location.href='/main/renewal_seller_join.do'" class="ON">협력사 가입 안내</li>
        <li onclick="location.href='/main/renewal_faq.do'">자주 묻는 질문</li>
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
             <li><span>step. 2</span><br/><p>승인 절차</p><img src="/resources/imgs/com_icon05.png" /><br/>코리아e플랫폼 담당자가<br/>사용자 등록을 승인합니다.<br/>  
				<button class="ButDarkGray_Small mt10" onclick="javascript:openPop(); return false;"  >가입 승인 담당자 찾기</button></li>
             <li><span>step. 3</span><br/><p>로그인</p><img src="/resources/imgs/com_icon04.png" /><br/> 승인이 완료되면<br/>사이트를 이용하실 수 있습니다.</li>
           </ul>
          </div>
          <div class="h80"></div>
          <div class="ComButtonArea"><button class="ButtonLarge" onclick="location.href='/mdam/showMasterMdAmMbrUserReg.do'">사용자 등록 바로가기</button></div>
        </div><!-- content2 끝 -->    
      </div><!-- SellerChoice 끝 -->     
	  <script>
          var tabs = document.querySelectorAll(".SellerChoice-tab");
          var contents = document.querySelectorAll(".SellerChoice-content");

          tabs.forEach(function(tab) {
            tab.addEventListener("click", function() {
              var targetId = tab.getAttribute("data-target");
              var targetContent = document.getElementById(targetId);

              var isOpen = targetContent.classList.contains("open");

              // 모든 탭/내용 초기화
              tabs.forEach(function(t) { t.classList.remove("active"); });
              contents.forEach(function(c) {
                c.classList.remove("open", "opening");
              });

              if (!isOpen) {
                tab.classList.add("active");

                // 열릴 때만 부드럽게
                targetContent.classList.add("opening");

                // 애니메이션이 끝나면 open으로 고정 (닫힐 땐 애니메이션 없음)
                setTimeout(function() {
                  targetContent.classList.remove("opening");
                  targetContent.classList.add("open");
                }, 500); // transition 시간과 동일
              }
            });
          });
          
          function openPop(){
        	  openSearchPopup("/main/renewal_kep_manager.do","?business_cond=S&init=Y", "560,360,no");
          }
        </script>       
      
      <div class="h80"></div> 
	</div><!-- containerBox 끝 -->
      
    
    <%@ include file="/WEB-INF/views/common/include/mainFooter_v2.jsp" %>
</div><!-- wrap 끝-->

</body>
</html>

