<%--
**********************************************
* 메뉴 : 고객센터 > 고객사별 공지사항
* 화면 : 고객사별 공지사항 탭 (ALL_CUSTOMER_FLAG = 'N')
* 기능 : 특정 고객사 선택 공지사항 조회
* 프로그램 ID :
* 담당자 : 원지성
* 생성일 : 2026-01-13 (공통/거래사별 분리)
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
    // Session에서 직접 SessionInfo 가져오기
    SessionInfo sessionInfo4 = (SessionInfo) session.getAttribute("sessionInfo");
    String comType4 = (sessionInfo4 != null) ? sessionInfo4.getComType() : "";
    String comCode4 = (sessionInfo4 != null) ? sessionInfo4.getComCode() : "";
    String userId4 = (sessionInfo4 != null) ? sessionInfo4.getUserId() : "";
%>

<!-- 탭4: 거래사별 공지사항 -->
<style>
/* 공지사항 첫 번째 항목의 상단 보더 제거 */
#Search4 .NoticeSub-item:first-of-type {
    border-top: none !important;
}

/* 버튼 영역과 첫 번째 항목 사이 여백 제거 */
#Search4 .NoticeSuBtnBox:first-child {
    margin-bottom: 0 !important;
}

#Search4 .NoticeSub-container > .NoticeSub-item:first-of-type {
    margin-top: 0 !important;
    padding-top: 0 !important;
}
</style>
<div id="Search4" class="TabCont" style="display: none;">
  <div class="containerSub">

    <div class="NoticeSub-container" id="noticeList4">
      <div class="NoticeSuBtnBox" style="display: none;">
        <div class="right"><button class="ButOutline_Medium" onclick="showNoticeForm4()">새 공지사항</button></div>
      </div>

      <!-- 동적 렌더링 영역: JavaScript에서 공지사항 목록이 여기에 추가됩니다 -->

      <div class="NoticeSuBtnBox">
        <div class="right"><span class="Number4">0건 선택됨</span> <button class="ButOutline_Medium"> 삭제</button></div>
      </div>
    </div>

    <!-- 새 공지사항 등록 폼 -->
    <div id="noticeForm4" style="display: none;">
      <div class="NoticeSuBtnBox">
        <div class="right"><button class="ButOutline_Medium" onclick="hideNoticeForm4()">목록으로</button></div>
      </div>

      <div class="SubTit">새 공지사항 등록</div>

      <table class="ChatTable" width="100%">
        <colgroup>
          <col width="130px" />
          <col width="*" />
        </colgroup>
        <tr>
          <th>제목</th>
          <td><input class="input30" style="width:99%" name="" placeholder="제목을 입력해주세요" type="text" /></td>
        </tr>
        <tr>
          <th>내용</th>
          <td><div style="height:300px">텍스트편집기</div></td>
        </tr>
        <tr>
          <th>첨부파일</th>
          <td><label for="FileUpload4" class="CustomUpload">파일 선택</label>
          <input id="FileUpload4" type="file" multiple>
          <div id="FileName4">선택된 파일이 없습니다.</div>
          <script>
            (function() {
                var fileInput4 = document.getElementById("FileUpload4");
                var fileName4 = document.getElementById("FileName4");

                if (fileInput4 && fileName4) {
                    fileInput4.addEventListener("change", function() {
                      if (this.files.length > 0) {
                        var names = [];
                        for (var i = 0; i < this.files.length; i++) {
                          names.push(this.files[i].name);
                        }
                        fileName4.textContent = names.join(", ");
                      } else {
                        fileName4.textContent = "선택된 파일이 없습니다.";
                      }
                    });
                }
            })();
          </script>
          </td>
        </tr>
      </table>
      <div class="h30"></div>
      <div class="ListBtnBoxcenter"><button class="ButPrimary_large" style="width:150px">등록</button></div>
      <div class="h50"></div>
    </div>

    <div class="h50"></div>
  </div>
</div>

<script type="text/javascript">
// ========================================
// Session 정보 및 사용자 권한 체크 (Tab4)
// ========================================
var sessionComType4 = '<%= comType4 %>';
var sessionComCode4 = '<%= comCode4 %>';
var sessionUserId4 = '<%= userId4 %>';
// 협력사 판별: COM_TYPE이 'S'이거나 빈값인 경우
var isSellerUser4 = (sessionComType4 === 'S' || sessionComType4 === '');

// 디버깅: Session 정보 확인
console.log('[Tab4 Session Info]');
console.log('  - sessionComType4:', sessionComType4, '(빈값:', sessionComType4 === '', ')');
console.log('  - sessionComCode4:', sessionComCode4);
console.log('  - sessionUserId4:', sessionUserId4);
console.log('  - isSellerUser4:', isSellerUser4);

// ========================================
// 첨부파일 다운로드 함수 (Tab4)
// ========================================
function fileDownload4(imgKey) {
    if (imgKey && imgKey !== '') {
        location.href = '/common/download_v2.do?DOC_NO=' + imgKey;
    } else {
        alert('다운로드할 파일이 없습니다.');
    }
}

// 공지사항 폼 표시/숨김 함수 (Tab4)
function showNoticeForm4() {
    document.getElementById('noticeList4').style.display = 'none';
    document.getElementById('noticeForm4').style.display = 'block';
}

function hideNoticeForm4() {
    document.getElementById('noticeForm4').style.display = 'none';
    document.getElementById('noticeList4').style.display = 'block';
}

// ========================================
// 거래사별 공지사항 목록 조회 (HttpUtil 사용)
// keyword 파라미터: 검색어 (제목/내용 검색)
// ========================================
function loadNoticeList4(keyword) {
    var comCode = sessionComCode4;

    var params = {
        st_company: comCode,
        st_user_id: sessionUserId4,  // 읽음 여부 판단용
        notice_type: 'COMPANY'  // 고객사별 공지사항 - ALL_CUSTOMER_FLAG = 'N'
    };

    // 검색어가 있으면 파라미터 추가
    if (keyword && keyword.trim() !== '') {
        params.st_keyword = keyword.trim();
        console.log('[loadNoticeList4] 검색어:', keyword);
    }

    HttpUtil.post('/mcsc/getSellerMCSCNoticeListJson.do', params, {
        showLoader: true,
        timeout: 15000,
        showDefaultAlert: false,
        onError: function(error) {
            console.error('[거래사별 공지사항 조회 실패]', error);
            if (error.message && error.message.indexOf('timeout') !== -1) {
                alert('조회 시간이 초과되었습니다. 다시 시도해주세요.');
            } else {
                alert('거래사별 공지사항을 불러올 수 없습니다.');
            }
        }
    }).then(function(response) {
        console.log('[거래사별 공지사항 조회 성공] response:', response);
        console.log('[거래사별 공지사항 조회 성공] response.data:', response.data);

        // response.data가 서버 JSON 응답
        if (response.data && response.data.success) {
            console.log('[renderNoticeList4 호출 직전] 데이터:', response.data.data);
            renderNoticeList4(response.data.data);
        } else {
            console.error('[조회 실패]', response.data ? response.data.message : '알 수 없는 오류');
            alert('조회 중 오류가 발생했습니다: ' + (response.data ? response.data.message : '알 수 없는 오류'));
        }
    });
}

// ========================================
// 거래사별 공지사항 목록 렌더링
// ========================================
function renderNoticeList4(dataList) {
    console.log('[renderNoticeList4] 데이터 개수:', dataList ? dataList.length : 0, '데이터:', dataList);

    var container = document.getElementById('noticeList4');
    var btnBoxes = container.querySelectorAll('.NoticeSuBtnBox');
    var firstBtnBox = btnBoxes[0];

    console.log('[renderNoticeList4] container:', container, 'firstBtnBox:', firstBtnBox);

    // 기존 항목 제거
    var existingItems = container.querySelectorAll('.NoticeSub-item');
    console.log('[renderNoticeList4] 기존 항목 개수:', existingItems.length);
    existingItems.forEach(function(item) {
        item.remove();
    });

    if (!dataList || dataList.length === 0) {
        console.log('[renderNoticeList4] 데이터 없음 - 빈 메시지 표시');
        var emptyHtml = '<div class="NoticeSub-item">' +
            '<p style="text-align:center;padding:50px;color:#999;">' +
            '<img src="/resources/imgs/Icon_Warning01.png" alt="경고" style="display: block; margin: 0 auto 20px; width: 80px; height: 80px;" />' +
            '등록된 거래사별 공지사항이 없습니다.' +
            '</p>' +
            '</div>';
        firstBtnBox.insertAdjacentHTML('afterend', emptyHtml);
        return;
    }

    // 데이터 렌더링
    var html = '';
    dataList.forEach(function(item, idx) {
        console.log('[renderNoticeList4] 아이템 ' + idx + ':', item);

        // 읽음 여부 (N: 미확인, Y: 확인)
        var readYn = item.READ_YN || 'N';
        var newIcon = (readYn === 'N') ? '<img src="/resources/imgs/seller_new.png" class="new-icon" style="margin-right:5px;vertical-align:middle;" />' : '';

        html += '<div class="NoticeSub-item" data-bid="' + escapeHtml4(item.BID) + '" data-btype="' + escapeHtml4(item.BTYPE) + '" data-read="' + readYn + '">';
        html += '  <button class="NoticeSub-question">';
        html += '    <table width="100%">';
        html += '      <tr>';
        // 협력사 사용자는 체크박스 숨김
        html += '        <td width="50px"' + (isSellerUser4 ? ' style="display:none;"' : '') + '>';
        html += '          <label class="CheckLargeLabel">';
        html += '            <input type="checkbox" value="' + escapeHtml4(item.BID) + '">';
        html += '            <span class="CheckLargeCustom"></span>';
        html += '          </label>';
        html += '        </td>';
        html += '        <td width="*">' + newIcon + escapeHtml4(item.SUBJECT) + '</td>';
        html += '        <td width="100px">' + formatDate4(item.REG_DATE) + '</td>';
        html += '      </tr>';
        html += '    </table>';
        html += '    <span class="NoticeSubarrow"><img src="/resources/imgs/arrow_down.png" /></span>';
        html += '  </button>';
        html += '  <div class="NoticeSub-answer">';
        html += '    <div class="loading" style="text-align:center;padding:20px;color:#999;">내용을 불러오는 중...</div>';
        html += '  </div>';
        html += '</div>';
    });

    console.log('[renderNoticeList4] HTML 생성 완료, 길이:', html.length);
    firstBtnBox.insertAdjacentHTML('afterend', html);
    console.log('[renderNoticeList4] DOM 삽입 완료');

    // 이벤트 재초기화 - DOM 삽입 직후 즉시 실행
    console.log('[renderNoticeList4] 이벤트 초기화 시작');
    initNoticeAccordion4();
    initNoticeCheckbox4();
    console.log('[renderNoticeList4] 이벤트 초기화 완료');
}

// ========================================
// 거래사별 공지사항 상세 조회 (HttpUtil 사용)
// ========================================
function loadNoticeDetail4(bid, btype, answerDiv, callback) {
    console.log('[loadNoticeDetail4 호출됨] BID:', bid, 'BTYPE:', btype);

    HttpUtil.post('/mcsc/getSellerMCSCNoticeDetailJson.do', {
        st_bid: bid,
        st_btype: btype
    }, {
        showLoader: false,
        showDefaultAlert: false,
        onError: function(error) {
            console.error('[상세 조회 실패]', error);
            answerDiv.innerHTML = '<p style="text-align:center;padding:20px;color:#f00;">상세 정보를 불러올 수 없습니다.</p>';
            // 에러 시에도 callback 호출하여 maxHeight 재계산
            if (callback) callback();
        }
    }).then(function(response) {
        console.log('[상세 조회 응답]', response);

        if (response.data && response.data.success) {
            console.log('[상세 데이터]', response.data.data);
            renderNoticeDetail4(response.data.data, answerDiv);
        } else {
            console.error('[상세 조회 실패] 응답:', response.data);
            answerDiv.innerHTML = '<p style="text-align:center;padding:20px;color:#f00;">상세 정보를 불러올 수 없습니다.</p>';
        }

        // AJAX 완료 후 callback 호출하여 maxHeight 재계산
        if (callback) callback();
    });
}

// ========================================
// 거래사별 공지사항 상세 렌더링
// ========================================
function renderNoticeDetail4(detail, answerDiv) {
    console.log('[renderNoticeDetail4] 상세 데이터:', detail);
    console.log('[renderNoticeDetail4] IMAGE_KEY:', detail.IMAGE_KEY);

    var html = '<table width="100%">';
    html += '  <tr>';
    html += '    <td width="*">' + (sanitizeHtml4(detail.CONTEXT) || sanitizeHtml4(detail.SUBJECT) || '내용 없음') + '</td>';
    // [2026-02-06] 작성자를 항상 "관리자"로 표기 (기존 코드 주석 처리)
    // html += '    <td width="200px" style="text-align: right; vertical-align: top;">작성자: ' + escapeHtml4(detail.REG_USER_NAME || '알 수 없음') + '</td>';
    html += '    <td width="200px" style="text-align: right; vertical-align: top;">작성자: 관리자</td>';
    html += '  </tr>';

    // 첨부파일이 있는 경우
    if (detail.IMAGE_KEY && detail.IMAGE_KEY.trim() !== '') {
        console.log('[renderNoticeDetail4] 첨부파일 버튼 생성 중...');
        html += '  <tr>';
        html += '    <td class="addfile">';
        html += '      <button class="ButDownload_Tiny_Outline" style="cursor:pointer" onclick="fileDownload4(\'' + escapeHtml4(detail.IMAGE_KEY) + '\')">다운로드</button>';
        html += '      첨부파일';
        html += '    </td>';
        html += '    <td></td>';
        html += '  </tr>';
    }

    html += '</table>';

    answerDiv.innerHTML = html;
    console.log('[renderNoticeDetail4] 렌더링 완료');
}

// ========================================
// 유틸리티 함수 (Tab4)
// ========================================
function formatDate4(dateStr) {
    if (!dateStr || dateStr.length !== 8) return dateStr || '';
    return dateStr.substring(0, 4) + '.' + dateStr.substring(4, 6) + '.' + dateStr.substring(6, 8);
}

function escapeHtml4(text) {
    if (!text) return '';
    var div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// HTML 태그 중 안전한 태그만 허용하는 함수 (Tab4)
function sanitizeHtml4(text) {
    if (!text) return '';

    // 1. 먼저 모든 HTML을 escape
    var escaped = escapeHtml4(text);

    // 2. 허용할 태그 목록 (화이트리스트 방식 - XSS 방지)
    var allowedTags = [
        // 표 관련
        'table', 'tr', 'td', 'th', 'thead', 'tbody', 'tfoot', 'colgroup', 'col', 'caption',
        // 이미지
        'img',
        // 레이아웃
        'p', 'div', 'span', 'br', 'hr',
        // 텍스트 서식
        'strong', 'b', 'em', 'i', 'u', 's', 'sub', 'sup',
        // 목록
        'ul', 'ol', 'li',
        // 제목
        'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
        // 기타
        'blockquote', 'pre', 'code'
    ];

    // 각 허용 태그 복원
    allowedTags.forEach(function(tag) {
        // 여는 태그 (속성 포함): &lt;tag ...&gt; → <tag ...>
        var openRegex = new RegExp('&lt;' + tag + '(\\s[^&]*?)?&gt;', 'gi');
        escaped = escaped.replace(openRegex, '<' + tag + '$1>');

        // 닫는 태그: &lt;/tag&gt; → </tag>
        var closeRegex = new RegExp('&lt;/' + tag + '&gt;', 'gi');
        escaped = escaped.replace(closeRegex, '</' + tag + '>');
    });

    // 셀프클로징 태그 처리 (br, hr, img 등): &lt;tag /&gt; → <tag />
    var selfClosingTags = ['br', 'hr', 'img', 'col'];
    selfClosingTags.forEach(function(tag) {
        var selfCloseRegex = new RegExp('&lt;' + tag + '(\\s[^&]*?)?/&gt;', 'gi');
        escaped = escaped.replace(selfCloseRegex, '<' + tag + '$1/>');
    });

    // 3. <a href="..." download target="_blank"> 태그 복원
    escaped = escaped.replace(/&lt;a\s+href="([^"]+)"\s+download\s+target="_blank"&gt;([^<]+)&lt;\/a&gt;/gi,
        '<a href="$1" download target="_blank" style="color:#0066cc; text-decoration:underline;">$2</a>');

    escaped = escaped.replace(/&lt;a\s+href="([^"]+)"\s+target="_blank"&gt;([^<]+)&lt;\/a&gt;/gi,
        '<a href="$1" target="_blank" style="color:#0066cc; text-decoration:underline;">$2</a>');

    // 4. <video> 태그 복원
    escaped = escaped.replace(/&lt;video\s+([\s\S]*?)&gt;([\s\S]*?)&lt;\/video&gt;/gi, function(match, attrs, content) {
        var videoContent = content.replace(/&lt;source\s+([\s\S]*?)&gt;/gi, function(m, srcAttrs) {
            return '<source ' + srcAttrs + '>';
        });
        return '<video ' + attrs + '>' + videoContent + '</video>';
    });

    // 5. 줄바꿈을 <br/>로 변환
    escaped = escaped.replace(/\n/g, '<br/>');

    return escaped;
}

// ========================================
// 협력사 사용자용 관리 UI 숨김 처리 (Tab4)
// ========================================
function hideManagementUIForSeller4() {
    if (isSellerUser4) {
        console.log('[hideManagementUIForSeller4] 협력사 사용자 - 관리 UI 숨김 처리');

        // 새 공지사항 버튼 숨김
        var newNoticeBtn = document.querySelector('#noticeList4 .NoticeSuBtnBox:first-child .right');
        if (newNoticeBtn) {
            newNoticeBtn.style.display = 'none';
        }

        // 선택 카운트 및 삭제 버튼 숨김
        var selectionBox = document.querySelector('#noticeList4 .NoticeSuBtnBox:last-child .right');
        if (selectionBox) {
            selectionBox.style.display = 'none';
        }
    } else {
        console.log('[hideManagementUIForSeller4] 고객사/운영사 사용자 - 관리 UI 표시');
    }
}

// ========================================
// 아코디언 이벤트 초기화 (Tab4)
// ========================================
function initNoticeAccordion4() {
    var items = document.querySelectorAll('#Search4 .NoticeSub-item');
    console.log('[initNoticeAccordion4] 발견된 공지사항 아이템 수:', items.length);

    items.forEach(function(item, index) {
        var question = item.querySelector('.NoticeSub-question');
        var answer = item.querySelector('.NoticeSub-answer');

        if (!question || !answer) {
            console.error('[initNoticeAccordion4] 버튼 또는 답변 영역을 찾을 수 없음:', index);
            return;
        }

        // 기존 이벤트 제거를 위해 클론
        var newQuestion = question.cloneNode(true);
        question.parentNode.replaceChild(newQuestion, question);

        newQuestion.addEventListener('click', function(e) {
            console.log('[아코디언4 클릭] 인덱스:', index, 'target:', e.target.tagName, 'className:', e.target.className);

            // 체크박스 클릭은 아코디언 동작 제외
            if (e.target.type === 'checkbox' || e.target.closest('.CheckLargeLabel')) {
                console.log('[아코디언4 클릭] 체크박스 클릭 - 무시');
                e.stopPropagation();
                return;
            }

            var bid = item.dataset.bid;
            var btype = item.dataset.btype;

            console.log('[아코디언4 클릭] BID:', bid, 'BTYPE:', btype, 'loaded:', item.dataset.loaded);

            if (item.classList.contains('active')) {
                console.log('[아코디언4 클릭] 닫기');
                answer.style.maxHeight = null;
                item.classList.remove('active');
            } else {
                // 다른 열린 항목 모두 닫기
                var allItems = document.querySelectorAll('#Search4 .NoticeSub-item.active');
                allItems.forEach(function(openItem) {
                    var openAnswer = openItem.querySelector('.NoticeSub-answer');
                    if (openAnswer) {
                        openAnswer.style.maxHeight = null;
                    }
                    openItem.classList.remove('active');
                });

                console.log('[아코디언4 클릭] 열기');
                item.classList.add('active');

                // ========================================
                // 읽음 처리: N 아이콘 즉시 숨김 및 서버 기록
                // ========================================
                if (item.dataset.read === 'N') {
                    console.log('[읽음 처리] 미확인 공지사항 - N 아이콘 숨김 및 서버 기록');

                    // N 아이콘 즉시 숨김
                    var newIcon = item.querySelector('.new-icon');
                    if (newIcon) {
                        newIcon.style.display = 'none';
                    }
                    item.dataset.read = 'Y';

                    // 서버에 읽음 기록 저장 (비동기)
                    HttpUtil.post('/mcsc/markNoticeAsRead.do', {
                        bid: bid,
                        btype: btype
                    }, {
                        showLoader: false,
                        showDefaultAlert: false
                    }).then(function(response) {
                        console.log('[읽음 처리 완료]', response);
                    });
                }

                // 상세 조회 (최초 1회만)
                if (!item.dataset.loaded) {
                    console.log('[상세 조회 시작] BID:', bid, 'BTYPE:', btype);

                    // AJAX 완료 후 maxHeight 재계산하는 callback
                    loadNoticeDetail4(bid, btype, answer, function() {
                        console.log('[Callback4] AJAX 완료 - maxHeight 재계산');
                        setTimeout(function() {
                            var video = answer.querySelector('video');
                            if (video) {
                                video.addEventListener('loadedmetadata', function() {
                                    answer.style.maxHeight = answer.scrollHeight + 100 + 'px';
                                });
                            }
                            answer.style.maxHeight = answer.scrollHeight + 100 + 'px';
                            console.log('[Callback4] maxHeight 설정 완료:', answer.scrollHeight + 100 + 'px');
                        }, 100);
                    });

                    item.dataset.loaded = 'true';
                } else {
                    console.log('[상세 조회 건너뜀] 이미 로드됨');
                    answer.style.maxHeight = answer.scrollHeight + 100 + 'px';
                }
            }
        });
    });
}

// ========================================
// 체크박스 이벤트 초기화 (Tab4)
// ========================================
function initNoticeCheckbox4() {
    var checkboxes = document.querySelectorAll('#Search4 .CheckLargeLabel input[type="checkbox"]');
    console.log('[initNoticeCheckbox4] 발견된 체크박스 수:', checkboxes.length);

    checkboxes.forEach(function(checkbox) {
        checkbox.addEventListener('change', function() {
            updateNoticeSelectionCount4();
        });
    });
}

// ========================================
// 선택 카운트 업데이트 (Tab4)
// ========================================
function updateNoticeSelectionCount4() {
    var checkedCount = document.querySelectorAll('#Search4 .CheckLargeLabel input[type="checkbox"]:checked').length;
    var countElement = document.querySelector('#Search4 .Number4');
    if (countElement) {
        countElement.textContent = checkedCount + '건 선택됨';
    }
    console.log('[updateNoticeSelectionCount4] 선택된 항목:', checkedCount);
}

(function() {
    'use strict';

    // ========================================
    // 거래사별 공지사항 탭 모듈 (TabManager 통합)
    // ========================================
    MRO.TabManager.registerModule('tab4', function(tabManager) {
        return {
            init: function() {
                console.log('[tab4] 거래사별 공지사항 탭 초기화');
                initNoticeAccordion4();
                initNoticeCheckbox4();
            },

            activate: function() {
                console.log('[tab4] 거래사별 공지사항 탭 활성화');
                loadNoticeList4(); // HttpUtil로 데이터 로드
                hideNoticeForm4();

                hideManagementUIForSeller4(); // 협력사 사용자용 UI 숨김 처리
            },

            deactivate: function() {
                console.log('[tab4] 거래사별 공지사항 탭 비활성화');
            },

            // 검색 함수 (메인 페이지에서 호출)
            search: function(keyword) {
                console.log('[tab4] 검색 호출:', keyword);
                loadNoticeList4(keyword);
            },

            // 특정 공지사항 자동 확장 함수
            autoExpandNotice: function(bid, btype) {
                console.log('[tab4] autoExpandNotice 호출:', 'bid=' + bid, 'btype=' + btype);

                // 목록이 로드될 때까지 대기 (100ms 간격으로 체크)
                var checkInterval = setInterval(function() {
                    var targetItem = document.querySelector('#Search4 .NoticeSub-item[data-bid="' + bid + '"][data-btype="' + btype + '"]');

                    if (targetItem) {
                        clearInterval(checkInterval);
                        console.log('[tab4] 대상 공지사항 찾음:', targetItem);

                        // 스크롤 이동 - 부드럽게 중앙으로
                        targetItem.scrollIntoView({ behavior: 'smooth', block: 'center' });

                        // 300ms 후 클릭 이벤트 발생 (아코디언 확장)
                        setTimeout(function() {
                            var question = targetItem.querySelector('.NoticeSub-question');
                            if (question) {
                                console.log('[tab4] 공지사항 클릭 시뮬레이션');
                                question.click();
                            } else {
                                console.warn('[tab4] .NoticeSub-question 버튼을 찾을 수 없습니다.');
                            }
                        }, 300);
                    }
                }, 100);
            }
        };
    });
})();
</script>
