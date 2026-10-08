<%--
**********************************************
* 메뉴 : 고객센터 > 자주묻는 질문
* 화면 : 자주묻는 질문 탭
* 기능 :
* 프로그램 ID :
* 담당자 : 원지성
* 수정일 : 2026-01-13 (주석 해제하여 다시 활성화)
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!-- 탭3: 자주묻는 질문 -->
<div id="Search3" class="TabCont" style="display: none;">
  <div class="containerSub">

    <div class="NoticeSub-container">
      <div class="NoticeSub-item">
        <button class="NoticeSub-question">
          <table>
            <tr>
              <th width="100px">Q</th>
              <td>주문 후 배송 기간은 얼마나 걸리나요?</td>
            </tr>
          </table>
          <span class="NoticeSubarrow"><img src="/resources/imgs/arrow_down.png" /></span>
        </button>
        <div class="NoticeSub-answer">
          <table>
            <tr>
              <th width="100px" align="center">A</th>
              <td>일반적으로 주문 후 2-3 영업일 이내 배송됩니다.<br/>긴급 주문의 경우 별도 문의 바랍니다.</td>
            </tr>
          </table>
        </div>
      </div>

      <div class="NoticeSub-item">
        <button class="NoticeSub-question">
          <table>
            <tr>
              <th width="100px">Q</th>
              <td>반품 절차는 어떻게 되나요?</td>
            </tr>
          </table>
          <span class="NoticeSubarrow"><img src="/resources/imgs/arrow_down.png" /></span>
        </button>
        <div class="NoticeSub-answer">
          <table>
            <tr>
              <th width="100px" align="center">A</th>
              <td>1:1 문의를 통해 반품 신청을 해주시면<br/>담당자가 확인 후 안내드립니다.</td>
            </tr>
          </table>
        </div>
      </div>
    </div>
    <div class="h50"></div>
  </div>
</div>

<script type="text/javascript">
(function() {
    'use strict';

    // ========================================
    // FAQ 데이터
    // ========================================
    var faqData = {
        "common": [
            {
                "category": "전체공통",
                "question": "원격지원서비스",
                "answer": "<a href=\"http://113366.com/koreab2b\"><b style=\"color:#06F; text-decoration:underline\">[원격지원 서비스]</b> <b>바로가기</b></a>"
            },
            {
                "category": "전체공통",
                "question": "Koreab2b.com 이용시 접속 환경은?",
                "answer": "우선 LAN, FAX Modem, Internet 전용선을 갖추고 계셔야 합니다."
            },
            {
                "category": "전체공통",
                "question": "출력물 관련",
                "answer": "HTML5 뷰어를 정상적으로 이용하기 위해서 Acrobat Reader DC 이상 버전의 PDF 뷰어를 이용하여 주시기 바랍니다.<br/><a href=\"https://get.adobe.com/kr/reader/otherversions/\" target=\"_blank\"><b>[PDF뷰어 다운로드]</b></a><br/><br/>출력물 버튼이 클릭 안될 경우 Adobe reader DC > 관리자모드 실행 > 상단 \"편집\" > 기본 설정 > 보안(고급) > 시작할 때 보호 모드 활성화 체크 해제 후 PC 재부팅 하시길 바랍니다."
            },
            {
                "category": "전체공통",
                "question": "메뉴얼은 어디에서 볼 수 있습니까?",
                "answer": "고객사 사이트 또는 공급사 사이트로 로그인하신 후 좌측메뉴에 [메뉴얼 다운로드]라는 버튼을 클릭하시면<br/>메뉴얼을 다운로드 하실 수 있습니다."
            },
            {
                "category": "전체공통",
                "question": "당사의 공급업체로 등록을 하시려면?",
                "answer": "당사는 귀사와의 거래를 함에 있어 아래의 서류들을 필히 보관하고 있어야 하오니 아래 서류를 당사로<br/>(Tel. 02-3016-8900) 우편 송부하여 주시면 감사하겠습니다. 아래서류 중 물품거래기본계약서는 다운로드에서 물품거래기본계약서를<br/>클릭하셔서 당사 소정양식을 프린트하시어 2부를 작성 날인하여 당사로 송부해 주시면 당사에서 날인하여 1부를<br/>재송부해 드리겠습니다.<br/><br/><b>당사 요청자료</b><br/>1. 사업자사본<br/>2. 통장사본(정산용으로 법인명의 혹은 대표이사 명의 통장)<br/>3. <a href=\"/resources/excel/work/MAIN/Basic_goods_trading_contract_W.docx\"><u>물품거래기본계약서</u></a>(MS_WORD양식), <a href=\"/resources/excel/work/MAIN/useSeal.zip\"><u>사용인감계</u></a>(MS_WORD양식)<br/>4. 결제계좌신고서 (당사 Site 회원등록 시, 작성 및 출력)<br/>5. 법인인감증명서<br/><span class=\"FontBlue\">※ [거래 약정서] 및 [사용 인감계]가 다운로드 되지 않을 경우엔 브라우저 상단의 [도구] >> [고급] >><br/>[인터텟옵션] >> [URL을 항상 UTP-8로보냄(다시 시작해야함)] 항목을 찾으시어 \"체크\" 표시를 없애시면 됩니다.<br/>※ 관련문의 : 메인페이지 담당자 연락처 참조.</span><br/><br/><b>구매카드 사용안내</b><br/>1. <u><a href=\"/resources/excel/work/MAIN/buyCardUseGuide.zip\">구매카드이용안내</a></u>(MS_WORD양식), <u><a href=\"/resources/excel/work/MAIN/buyCardUseGuide_H.zip\">구매카드이용안내</a></u>(아래한글양식)<br/>- 자세한 문의는 하나은행 구매카드 담당부서나 당사 경영지원팀으로 연락주시기 바랍니다.<br/><span class=\"FontBlue\">※ ☎ 하나은행 구매카드 담당부서 02) 3709-6381~3 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;당사경영지원팀 구매카드 담당 02) 3016-8904</span>"
            },
            {
                "category": "전체공통",
                "question": "당사의 전자입찰/역경매 참여 공급업체로 등록을 하시려면?",
                "answer": "당사는 귀사와의 거래를 함에 있어 아래의 서류들을 필히 보관하고 있어야 하오니 아래 서류를 당사로<br/>(Tel. 02-3016-8900) 우편 송부하여 주시면 감사하겠습니다. 아래서류 중 기본계약서는 다운로드에서 기본계약서를<br/>클릭하셔서 당사 소정양식을 프린트하시어 2부를 작성 날인하여 당사로 송부해 주시면 당사에서 날인하여 1부를<br/>재송부해 드리겠습니다.<br/><br/><b>당사 요청자료</b><br/>1. 사업자사본<br/>2. <u><a href=\"/resources/excel/work/MAIN/elecBidContract.zip\">기본계약서</a></u>(MS_WORD양식), <u><a href=\"/resources/excel/work/MAIN/elecBidContract_H.zip\">기본계약서</a></u>(아래한글양식)<br/>3. 법인인감증명서<br/><span class=\"FontBlue\">※ 관련문의 : 메인페이지 담당자 연락처 참조</span>"
            },
            {
                "category": "회원가입",
                "question": "회원사 및 사용자 가입은 어떻게 하나요?",
                "answer": "http://www.koreab2b.com 접속후, \"회원가입 > 회원사등록 \"에서 회원사 등록에 필요한 정보를 입력하고,<br/>등록승인에 필요한 제출서류를 우편으로 송부하시면 됩니다."
            },
            {
                "category": "회원가입",
                "question": "회원사 등록 승인이 지연됩니다.",
                "answer": "회원사 등록승인은 송부하신 서류 도착 후 1~2일 정도가 소요됩니다.<br/>등록승인이 지연되면 당사 마켓지원팀으로 문의하시기 바랍니다."
            },
            {
                "category": "회원가입",
                "question": "ID, 비밀번호가 기억이 안나요.",
                "answer": "ID 또는 비밀번호를 잊었을 경우,<br/>첫 화면 상단의 ID/PW 찾기를 통해 확인이 가능합니다.<br/>비밀번호 찾기는 정보 확인 후 등록된 휴대폰 혹은 이메일주소로 임시비밀번호가 발송됩니다."
            },
            {
                "category": "회원가입",
                "question": "회사정보를 변경할 수 있나요?",
                "answer": "회사의 담당자 및 연락처 정보는 Admin사용자가 수정하실 수 있습니다. 다만, 귀사의 사업자 등록증이 변경된 경우는<br/>당사 마켓지원팀 담당자에게 변경된 사업자등록증 사본을 송부해 주시면 변경해 드립니다."
            },
            {
                "category": "회원가입",
                "question": "회원가입 시 입력하는 개인정보에 대한 유출의 우려는 없나요?",
                "answer": "koreab2b.com은 개인정보에 대한 수집, 보유 등의 활동에 있어 철저한 보안을 유지하기 위한 개인보호정책을<br/>마련하여 관리하고 있습니다. 자세한 내용은 \"개인정보 보호정책\"을 참고하시기 바랍니다.<br/><br/><span class=\"FontBlue\"><b>※ 회원가입 관련문의 : 마켓지원팀 (02-3016-8989)</b></span>"
            },
            {
                "category": "카탈로그관련",
                "question": "Koreab2b.com 에서 취급하는 상품은 어떤 것인가요?",
                "answer": "Koreab2b.com은 기업의 생산 및 경영활동에 필요한 모든 상품 및 서비스를 제공합니다.<br/>KeP에서 현재 보유 중인 기업소모성 자재 MRO(Maintenance, Repair and Operation) 품목은 아래와 같습니다.<br/>◑ 사무자재 - 사무용품, 정보통신, 가정용품 &nbsp;&nbsp;&nbsp;//&nbsp;&nbsp;&nbsp; ◑ 석유화학 - 유류, 가스, 윤활유, 화학약품, 합성수지/고무<br/>◑ 토건 - 토목, 일반건설, 마감재&nbsp;&nbsp;&nbsp;//&nbsp;&nbsp;&nbsp;◑ 기계요소 - 체결부품, 실링재, 베어링/부싱, 설비부품<br/>◑ 전기자재 - 전기부품, 배선/조명기구, 전선 및 부속재료, 전력/배전기기 &nbsp;&nbsp;&nbsp;//&nbsp;&nbsp;&nbsp; ◑ 소방안전 - 소방, 안전<br/>◑ 공구 - 작업공구, 전동공구, 공압/유압공구, 절삭공구, 측정공구 &nbsp;&nbsp;&nbsp;//&nbsp;&nbsp;&nbsp; ◑ 전자제어 - PCB, 직접회로, 계장<br/>◑ 동력기기 - 동력원, 변속기, 동력전달부품 &nbsp;&nbsp;&nbsp;//&nbsp;&nbsp;&nbsp; ◑ 환경/공해방지 - 세척, 정수처리, 연선/청소기기<br/>◑ 포장/운송/저장 - 포장, 운송, 저장 &nbsp;&nbsp;&nbsp;//&nbsp;&nbsp;&nbsp; ◑ 실험/계측 - 실험기자재, 계측기기<br/>◑ 유체/유공압 - 유압, 공압, 공조, 배관재, 펌프, 필터/정화기기 &nbsp;&nbsp;&nbsp;//&nbsp;&nbsp;&nbsp; ◑ 기타 - 제작물, 생활용품"
            },
            {
                "category": "카탈로그관련",
                "question": "카탈로그는 어떻게 구성되어 있나요?",
                "answer": "koreab2b.com의 카탈로그는 Master Catalog(제품 마스터정보)와 Seller Catalog(판매자 정보)로 구분됩니다.<br/>분류체계 검색을 이용한 Directory Search나 키워드 검색을 통한 제품 검색시 조회된 정보는<br/>Master Catalog에 해당되며, 품명을 클릭하여 조회된 판매자명 및 가격정보 등은 Seller Catalog에 해당합니다."
            },
            {
                "category": "카탈로그관련",
                "question": "카탈로그에서 조회된 상품의 정보가 부족합니다.",
                "answer": "카탈로그에서 조회된 상품의 규격, 제조원, 원산지, 이미지, 사용법 등이 부족해서 원하는 상품을 찾기가<br/>어려우시면 코리아이플랫폼㈜의 전문 구매담당자에게 연락주십시오. 해당상품에 대한 자료 제공은<br/>물론 타제품과의 장단점 비교 및 귀사의 작업환경에 적합한 추천상품까지 상담해 드립니다."
            }
        ],
"seller": [
            {
                "faqId": "faq-seller-1",
                "category": "납품관리",
                "question": "납품실적등록(택배 송장번호 등록, 납품완료일 입력)을 왜 해야 하나요?",
                "answer": "납품실적등록은 납품 완료를 확인하는 필수 증빙 절차입니다. 등록이 누락되면 고객사 입고확정 및 마감·정산이 지연되거나 누락될 수 있으니 납품 완료 즉시 등록해 주세요."
            },
            {
                "faqId": "faq-seller-2",
                "category": "마감관리",
                "question": "월마감 내역은 어디서 확인할 수 있나요?",
                "answer": "[마감관리 &gt; 마감관리] 화면에서 계산서별/품목별 마감내역, 물류비 발행내역, 미마감내역을 조회할 수 있습니다. 미마감내역은 입고처리 되었지만 아직 마감되지 않은 건입니다."
            },
            {
                "faqId": "faq-seller-3",
                "category": "수주관리",
                "question": "수주접수를 잘못했어요. 취소는 어디서 하나요?",
                "answer": "[납품관리 &gt; 납품진행현황]에서 '수주접수 초기화' 버튼으로 KeP 운영담당자에게 초기화 요청할 수 있습니다. 진행상태가 '거래명세서 생성대상'인 건만 요청 가능하며, 승인 완료 시 해당 수주접수가 초기화됩니다."
            },
            {
                "faqId": "faq-seller-4",
                "category": "수주관리",
                "question": "수주접수할때 입력한 납품예정일을 바꾸고 싶어요.",
                "answer": "[납품관리 &gt; 납품진행현황]에서 '납품예정일 변경' 버튼으로 KeP 운영담당자에게 변경 요청할 수 있습니다. 진행상태가 '거래명세서 생성대상'인 건만 요청 가능하며, 승인 완료 시 납품예정일이 변경됩니다."
            },
            {
                "faqId": "faq-seller-5",
                "category": "수주관리",
                "question": "수주접수 초기화/납품예정일 변경을 하고싶은데 납품진행현황에서 품목 선택이 안되요!",
                "answer": "수주접수 초기화/납품예정일 변경은 진행상태가 '거래명세서 생성대상'일 때만 가능합니다. 이미 요청한 건은 KeP 운영담당자 회신 전까지 선택/수정이 제한됩니다."
            },
            {
                "faqId": "faq-seller-6",
                "category": "수주관리",
                "question": "수주거부는 어떻게 하나요?",
                "answer": "수주거부는 [납품관리 &gt; 수주접수] 화면에서 신청할 수 있습니다. 수주거부는 품목 단위로는 신청할 수 없고 PO(발주서) 단위로만 요청 가능합니다."
            },
            {
                "faqId": "faq-seller-7",
                "category": "납품관리",
                "question": "KeP에 요청한 내역(수주거부/납품예정일 변경/수주접수 초기화/거래유형변경 요청)은 어디서 확인하나요?",
                "answer": "KeP에 요청한 내역은 [납품관리 &gt; 납품이슈현황]에서 진행현황을 확인할 수 있습니다."
            }
        ]
    };

    // ========================================
    // 자주묻는 질문 탭 모듈
    // ========================================
    MRO.TabManager.registerModule('tab3', function(tabManager) {
        return {
            faqData: faqData,
            filteredData: [],
            currentCategory: 'all',

            init: function() {
                console.log('[tab1] 자주묻는 질문 탭 초기화');
                this.bindFAQData();
                this.initAccordion();
                this.initSearch();
            },

            activate: function() {
                console.log('[tab1] 자주묻는 질문 탭 활성화');
            },

            deactivate: function() {
                console.log('[tab1] 자주묻는 질문 탭 비활성화');
            },

            // 특정 FAQ 자동 확장 함수
            autoExpandFAQ: function(faqId) {
                console.log('[tab3] autoExpandFAQ 호출:', 'faqId=' + faqId);

                // 목록이 로드될 때까지 대기 (100ms 간격으로 체크)
                var checkInterval = setInterval(function() {
                    var targetItem = document.querySelector('#Search3 .NoticeSub-item[data-faq-id="' + faqId + '"]');

                    if (targetItem) {
                        clearInterval(checkInterval);
                        console.log('[tab3] 대상 FAQ 찾음:', targetItem);

                        // 스크롤 이동 - 부드럽게 중앙으로
                        targetItem.scrollIntoView({ behavior: 'smooth', block: 'center' });

                        // 300ms 후 클릭 이벤트 발생 (아코디언 확장)
                        setTimeout(function() {
                            var question = targetItem.querySelector('.NoticeSub-question');
                            if (question) {
                                console.log('[tab3] FAQ 클릭 시뮬레이션');
                                question.click();
                            } else {
                                console.warn('[tab3] .NoticeSub-question 버튼을 찾을 수 없습니다.');
                            }
                        }, 300);
                    }
                }, 100);

                // 5초 후에도 찾지 못하면 중단
                setTimeout(function() {
                    clearInterval(checkInterval);
                    console.warn('[tab3] 5초 내에 대상 FAQ를 찾지 못했습니다.');
                }, 5000);
            },

            bindFAQData: function() {
                // FAQ 데이터를 HTML에 바인딩
                var container = document.querySelector('#Search3 .NoticeSub-container');
                if (!container) return;

                var html = '';
                var sellerFAQs = this.faqData['seller'];

                sellerFAQs.forEach(function(item) {
                    html += '<div class="NoticeSub-item" data-faq-id="' + item.faqId + '">';
                    html += '  <button class="NoticeSub-question">';
                    html += '    <table>';
                    html += '      <tr>';
                    html += '        <th width="100px">Q</th>';
                    html += '        <td>' + item.question + '</td>';
                    html += '      </tr>';
                    html += '    </table>';
                    html += '    <span class="NoticeSubarrow"><img src="/resources/imgs/arrow_down.png" /></span>';
                    html += '  </button>';
                    html += '  <div class="NoticeSub-answer">';
                    html += '    <table>';
                    html += '      <tr>';
                    html += '        <th width="100px" align="center">A</th>';
                    html += '        <td>' + item.answer + '</td>';
                    html += '      </tr>';
                    html += '    </table>';
                    html += '  </div>';
                    html += '</div>';
                });

                container.innerHTML = html;
            },

            initAccordion: function() {
                // 아코디언 기능 초기화
                var questions = document.querySelectorAll('#Search3 .NoticeSub-question');
                questions.forEach(function(question) {
                    question.addEventListener('click', function() {
                        var item = this.parentElement; // .NoticeSub-item
                        var answer = this.nextElementSibling;

                        if (item.classList.contains('active')) {
                            answer.style.maxHeight = null;
                            item.classList.remove('active');
                        } else {
                            // 다른 열린 항목 모두 닫기
                            var allItems = document.querySelectorAll('#Search3 .NoticeSub-item.active');
                            allItems.forEach(function(openItem) {
                                var openAnswer = openItem.querySelector('.NoticeSub-answer');
                                if (openAnswer) {
                                    openAnswer.style.maxHeight = null;
                                }
                                openItem.classList.remove('active');
                            });

                            answer.style.maxHeight = answer.scrollHeight + 'px';
                            item.classList.add('active');
                        }
                    });
                });
            },

            initSearch: function() {
                var self = this;
                var searchInput = document.querySelector('#searchKeyword');

                if (!searchInput) {
                    console.warn('[tab1] 검색 입력창을 찾을 수 없습니다.');
                    return;
                }

                // 실시간 검색 (input 이벤트)
                searchInput.addEventListener('input', function() {
                    var keyword = this.value.trim();
                    self.performSearch(keyword);
                });

                console.log('[tab1] 검색 기능 초기화 완료');
            },

            performSearch: function(keyword) {
                var sellerFAQs = this.faqData['seller'];
                var filteredResults;

                // 검색어가 없으면 전체 목록
                if (!keyword) {
                    filteredResults = sellerFAQs;
                } else {
                    // 대소문자 구분 없이 검색
                    var lowerKeyword = keyword.toLowerCase();

                    filteredResults = sellerFAQs.filter(function(item) {
                        var questionMatch = item.question.toLowerCase().indexOf(lowerKeyword) > -1;
                        var answerMatch = item.answer.toLowerCase().indexOf(lowerKeyword) > -1;
                        var categoryMatch = item.category.toLowerCase().indexOf(lowerKeyword) > -1;

                        return questionMatch || answerMatch || categoryMatch;
                    });
                }

                console.log('[tab1] 검색 결과: ' + filteredResults.length + '건');
                this.renderFilteredResults(filteredResults);
            },

            renderFilteredResults: function(results) {
                var container = document.querySelector('#Search3 .NoticeSub-container');
                if (!container) return;

                var html = '';

                // 검색 결과가 없을 때
                if (results.length === 0) {
                    html = '<div class="NoticeSub-noResult" style="padding: 40px; text-align: center; color: #999;">';
                    html += '  <p style="font-size: 16px; margin-bottom: 10px;">검색 결과가 없습니다.</p>';
                    html += '  <p style="font-size: 14px;">다른 키워드로 검색해보세요.</p>';
                    html += '</div>';
                } else {
                    // 검색 결과 렌더링
                    results.forEach(function(item) {
                        html += '<div class="NoticeSub-item" data-faq-id="' + item.faqId + '">';
                        html += '  <button class="NoticeSub-question">';
                        html += '    <table>';
                        html += '      <tr>';
                        html += '        <th width="100px">Q</th>';
                        html += '        <td>' + item.question + '</td>';
                        html += '      </tr>';
                        html += '    </table>';
                        html += '    <span class="NoticeSubarrow"><img src="/resources/imgs/arrow_down.png" /></span>';
                        html += '  </button>';
                        html += '  <div class="NoticeSub-answer">';
                        html += '    <table>';
                        html += '      <tr>';
                        html += '        <th width="100px" align="center">A</th>';
                        html += '        <td>' + item.answer + '</td>';
                        html += '      </tr>';
                        html += '    </table>';
                        html += '  </div>';
                        html += '</div>';
                    });
                }

                container.innerHTML = html;

                // 아코디언 이벤트 재등록
                this.initAccordion();
            }
        };
    });
})();
</script>
