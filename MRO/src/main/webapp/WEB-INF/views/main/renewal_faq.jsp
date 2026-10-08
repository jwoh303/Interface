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
        <li onclick="location.href='/main/renewal_seller_join.do'">협력사 가입 안내</li>
        <li onclick="location.href='/main/renewal_faq.do'" class="ON">자주 묻는 질문</li>
        </ul>
      </div>
    </div>
	<!-- 컨텐츠 -->
      <div class="containerBox_1280px">
        <div class="h30"></div>
        <div class="SVCTitBox">
          <div class="SVCTit">고객센터</div>
          <form class="SVCSearch" onsubmit="searchFaq(); return false;">
            <input type="text" placeholder="자주묻는 질문 검색" id="faqSearchInput" style="width:75%;">
            <button type="submit">검색</button>
          </form>
          <button class="Butchat" onclick="alert('로그인 후 확인 가능합니다.')">1:1 문의하기</button>
        </div>
        <div class="h20"></div>
        <div class="SVCTab">
          <div style="border:1px solid #2172ec;border-bottom:0px solid #2172ec; background-color:#fff; color:#2172ec;" onclick="location.href='/main/renewal_faq.do'">자주묻는 질문</div>
          <div style="border-bottom:1px solid #2172ec;" onclick="alert('로그인 후 확인 가능합니다.')">1:1 문의</div>
          <div style="border-bottom:1px solid #2172ec;" onclick="alert('로그인 후 확인 가능합니다.')">공지사항</div>
        </div>
        <div class="h20"></div>
        <div class="Faq-container">
          <!-- 공용 FAQ -->
          <div class="Faq-item">
            <button class="Faq-question">
              <table>
                <tr>
                  <th width="100px">Q</th>
                  <td>[시스템] 매뉴얼은 어디서 볼 수 있나요?</td>
                </tr>
              </table>
              <span class="Faqarrow"><img src="/resources/imgs/arrow_down.png" /></span>
            </button>
            <div class="Faq-answer">
               <table>
                <tr>
                  <th width="100px" align="center">A</th>
                  <td>고객사 사이트 또는 협력사 사이트로 로그인하신 후 아랫쪽 [매뉴얼 다운로드]에서 해당 매뉴얼을 다운로드 하실수 있습니다.</td>
                </tr>
              </table>
            </div>
          </div>
          <div class="Faq-item">
            <button class="Faq-question">
              <table>
                <tr>
                  <th width="100px">Q</th>
                  <td>[시스템] 비밀번호 및 주소변경은 어디서 할 수 있나요?</td>
                </tr>
              </table>
              <span class="Faqarrow"><img src="/resources/imgs/arrow_down.png" /></span>
            </button>
            <div class="Faq-answer">
               <table>
                <tr>
                  <th width="100px" align="center">A</th>
                  <td>고객사는 마이페이지>개인정보에서, 협력사는 정보수정에서 수정이 가능합니다.</td>
                </tr>
              </table>
            </div>
          </div>
          <div class="Faq-item">
            <button class="Faq-question">
              <table>
                <tr>
                  <th width="100px">Q</th>
                  <td>[회원가입] 회원사 및 사용자 가입은 어떻게 하나요?</td>
                </tr>
              </table>
              <span class="Faqarrow"><img src="/resources/imgs/arrow_down.png" /></span>
            </button>
            <div class="Faq-answer">
               <table>
                <tr>
                  <th width="100px" align="center">A</th>
                  <td>고객사 신규 가입은 KeP 담당자가 진행해드리며, 고객사 사용자 등록 및 협력사 신규가입/사용자 가입은 koreab2b.com 접속 후 고객사/협력사 회원가입에서 가능합니다.</td>
                </tr>
              </table>
            </div>
          </div>
          <div class="Faq-item">
            <button class="Faq-question">
              <table>
                <tr>
                  <th width="100px">Q</th>
                  <td>[회원가입] ID, 비밀번호를 잊어버렸어요.</td>
                </tr>
              </table>
              <span class="Faqarrow"><img src="/resources/imgs/arrow_down.png" /></span>
            </button>
            <div class="Faq-answer">
               <table>
                <tr>
                  <th width="100px" align="center">A</th>
                  <td>koreab2b.com에서 아이디찾기/비밀번호 찾기를 통해 확인이 가능합니다.</td>
                </tr>
              </table>
            </div>
          </div>
          <!-- 주문배송 FAQ -->
          <div class="Faq-item">
            <button class="Faq-question">
              <table>
                <tr>
                  <th width="100px">Q</th>
                  <td>[배송문의] 언제쯤 상품을 받을 수 있나요?</td>
                </tr>
              </table>
              <span class="Faqarrow"><img src="/resources/imgs/arrow_down.png" /></span>
            </button>
            <div class="Faq-answer">
               <table>
                <tr>
                  <th width="100px" align="center">A</th>
                  <td>협력사가 수주접수 후 예상 납품예정일을 메일로 발송해드리고 있습니다. (알림 수신 동의 시 발송)</td>
                </tr>
              </table>
            </div>
          </div>
          <div class="Faq-item">
            <button class="Faq-question">
              <table>
                <tr>
                  <th width="100px">Q</th>
                  <td>[발주배송관련] 납품된 수량이 발주낸 수량보다 모자랍니다.</td>
                </tr>
              </table>
              <span class="Faqarrow"><img src="/resources/imgs/arrow_down.png" /></span>
            </button>
            <div class="Faq-answer">
               <table>
                <tr>
                  <th width="100px" align="center">A</th>
                  <td>납품된 수량이 거래명세서의 수량보다 작을 경우, 아래 세가지 방법 중 하나를 택하시면 됩니다.<br/><br/>
                      ① 전체수량이 준비될 때 함께 납품하도록 납품받지 않는 방법<br/>
                      ② 납품된 수량만 납품을 받고 시스템상에 그 수량 만큼만 입고처리하는 방법. 이때, 부족한 수량은 다시 발주 내시면 됩니다.<br/>
                      ③ 납품된 수량만큼은 납품을 받고 나머지 수량이 납품되면 입고처리하는 방법
                  </td>
                </tr>
              </table>
            </div>
          </div>
          <div class="Faq-item">
            <button class="Faq-question">
              <table>
                <tr>
                  <th width="100px">Q</th>
                  <td>[교환/반품] 주문한 상품을 교환/반품 하고 싶어요.</td>
                </tr>
              </table>
              <span class="Faqarrow"><img src="/resources/imgs/arrow_down.png" /></span>
            </button>
            <div class="Faq-answer">
               <table>
                <tr>
                  <th width="100px" align="center">A</th>
                  <td>품질불만, 고객의 변심 등에 의해 교환/반품을 원하실 경우 주문 > 주문/배송조회에서 교환/반품 신청을 해주세요. 
                  </td>
                </tr>
              </table>
            </div>
          </div>
          <!-- 정산결제 FAQ -->
          <div class="Faq-item">
            <button class="Faq-question">
              <table>
                <tr>
                  <th width="100px">Q</th>
                  <td>[정산] 당월 정산내역은 어디서 확인 가능한가요?</td>
                </tr>
              </table>
              <span class="Faqarrow"><img src="/resources/imgs/arrow_down.png" /></span>
            </button>
            <div class="Faq-answer">
               <table>
                <tr>
                  <th width="100px" align="center">A</th>
                  <td>고객사 : 입고 > 마감관리에서 당월 마감건에 대해 확인 가능</br>
						협력사 : 마감관리 메뉴에서 계산서별/품목별/물류비발행내역/미마감내역/마감현황 조회 가능</td>
                </tr>
              </table>
            </div>
          </div>
          <div class="Faq-item">
            <button class="Faq-question">
              <table>
                <tr>
                  <th width="100px">Q</th>
                  <td>[정산] 대금결제방식은 어떤 것이 있나요?</td>
                </tr>
              </table>
              <span class="Faqarrow"><img src="/resources/imgs/arrow_down.png" /></span>
            </button>
            <div class="Faq-answer">
               <table>
                <tr>
                  <th width="100px" align="center">A</th>
                  <td>현금지급, 어음지급, 구매자금대출, 구매카드 등 다양한 형태의 결제방식이 있습니다.
                  </td>
                </tr>
              </table>
            </div>
          </div>
        </div><!-- Faq-container 끝 -->
        <script>
          var faqItems = document.querySelectorAll(".Faq-item");
          faqItems.forEach(function(item) {
            var question = item.querySelector(".Faq-question");
            var answer = item.querySelector(".Faq-answer");

            question.addEventListener("click", function() {
              if (item.classList.contains("active")) {
                answer.style.maxHeight = null;
                item.classList.remove("active");
              } else {
                answer.style.maxHeight = answer.scrollHeight + "px";
                item.classList.add("active");
              }
            });
          });

          function searchFaq() {
            var keyword = document.getElementById("faqSearchInput").value.trim().toLowerCase();
            if (!keyword) {
              faqItems.forEach(function(item) { item.style.display = ""; });
              return;
            }
            faqItems.forEach(function(item) {
              var text = item.textContent.toLowerCase();
              item.style.display = text.indexOf(keyword) >= 0 ? "" : "none";
            });
          }
        </script>
        <div class="h30"></div>
      </div><!-- containerBox_1280px 끝 -->

    <%@ include file="/WEB-INF/views/common/include/mainFooter_v2.jsp" %>
</div><!-- wrap 끝-->

</body>
</html>
