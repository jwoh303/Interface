<%--
**********************************************
* 메뉴 : 고객센터 > 1:1 문의
* 화면 : 1:1 문의 탭
* 기능 : 
* 프로그램 ID :
* 담당자 : 원지성

**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!-- 탭2: 1:1 문의 -->
<div id="Search2" class="TabCont" style="display: none;">

        


  <div class="containerSub">
    <div class="h30"></div>
    
     <table class="ChatSearchTable" >
            <colgroup>
              <col width="80px" />
              <col width="500px" />
              <col width="60px" />
              <col width="240px" />
              <col width="60px" />
              <col width="230px" />
              <col width="110px" />
            </colgroup>         	
            <tr>
              <th height="70px">문의일자</th>
              <td>
                <div class="MonthBtnBox" style="width:230px">
                  <div class="date-range">
                    <div class="date-picker">
                      <input type="text" name="st_from_date" id="st_from_date" class="date-input" placeholder="" readonly>
                      <div class="calendar-btn"></div>
                    </div>
                    <span class="dash">~</span>
                    <div class="date-picker">
                      <input type="text" name="st_to_date" id="st_to_date" class="date-input" placeholder="" readonly>
                      <div class="calendar-btn"></div>
                    </div>
                  </div>
                </div>
                <button class="But_Month" data-months="1">1개월</button>
                <button class="But_Month" data-months="3">3개월</button>
                <button class="But_Month" data-months="6">6개월</button>
                <button class="But_Month" data-months="12">12개월</button>
              </td>
              <th>문의유형</th>
              <td><select name="st_qtype" class="Select" style="width:220px">
                  <option value="ALL">전체</option>
                  </select>
              </td>
              <th>진행상태</th>
              <td><select name="st_status" class="Select" style="width:220px">
                  <option value="ALL">전체</option>
                  </select>
              </td>
              <td><button class="ButMSmallDarkGray" style="width:80px" >조회</button> </td>           
            </tr>
          </table>


    <!-- 문의 목록 뷰 -->
    <div id="inquiry-list-view">
      <div class="Chat-container">
        <!-- 문의 목록은 JavaScript에서 동적으로 로드됩니다 -->
      </div>
      <div class="h30"></div>
      <div class="ListBtnBoxcenter"><button class="Butchat" id="show-inquiry-form">1:1 문의하기</button></div>
    </div>

    <!-- 문의 등록 폼 뷰 -->
    <div id="inquiry-form-view" style="display: none;">
      <div class="h20"></div>
      <table class="ChatTable" width="100%">
        <colgroup>
          <col width="130px" />
          <col width="230px" />
          <col width="*" />
        </colgroup>
        <tr>
          <th>문의유형</th>
          <td colspan="2">
            <select name="qtype" class="Select" style="width:250px">
              <option value="">문의유형을 선택해주세요</option>
            </select>
            <input class="input30" style="width:250px" name="item_code" placeholder="품목코드를 입력해주세요" type="text" />
            <input class="input30" style="width:250px" name="po_no" placeholder="발주번호를 입력해주세요" type="text" />
          </td>
        </tr>
        <tr>
          <th rowspan="2">내용</th>
          <td colspan="2" style="border-bottom:0px solid #eee;">
            <div class="TextField" id="limitedArea">
              <textarea id="message" name="context" maxlength="2000" placeholder="" rows="20" style="width:97%"></textarea>
              <div class="meta" aria-live="polite"> <span id="count">0</span>/2000 </div>
            </div>
            <script>
            (function () {
              var wrap = document.getElementById('limitedArea');
              var ta   = document.getElementById('message');
              var cnt  = document.getElementById('count');
              var MAX  = parseInt(ta.getAttribute('maxlength'), 10);
              function update() {
                var len = ta.value.length;
                cnt.textContent = len;
              }
              update();
              ta.addEventListener('input', update);
            })();
            </script>
          </td>
        </tr>
        <tr>
          <td><span style="font-size:85%">답변이 오면 알려드릴까요? (선택) </span></td>
          <td>
            <label class="CheckMediumLabel"><input type="checkbox" id="sms_check"><span class="CheckMediumCustom"></span> SMS</label> &nbsp; &nbsp; &nbsp; &nbsp;
            <input class="input30" style="width:45px" name="phone1" type="text" maxlength="3" /> -
            <input class="input30" style="width:62px" name="phone2" type="text" maxlength="4" /> -
            <input class="input30" style="width:62px" name="phone3" type="text" maxlength="4" />
            <span style="font-size:85%">* 알림방법을 선택하지 않아도 1:1문의는 가능합니다.</span>
          </td>
        </tr>
      </table>

      <div class="h30"></div>
      <div class="ListBtnBoxcenter">
        <button class="ButPrimary_large" style="width:150px" id="submitInquiry">등록</button>
        <button class="ButOutline_large" style="width:150px" id="cancel-inquiry-form">취소</button>
      </div>
    </div>

    <div class="h50"></div>
  </div>
</div>

<script type="text/javascript">
(function() {
    'use strict';

    // ========================================
    // 1:1 문의 탭 모듈
    // ========================================
    MRO.TabManager.registerModule('tab2', function(tabManager) {
        var inquiryListData = []; // 문의 목록 데이터
        var dateRangePicker = null; // DatePicker 인스턴스

        return {
            init: function() {
                console.log('[tab2] 1:1 문의 탭 초기화');
                this.initDatePicker(); // DatePicker 초기화 추가
                this.initAccordion();
                this.initEvents();
                this.loadQtypeCodes(); // 문의유형 코드 로드
            },

            activate: function() {
                console.log('[tab2] 1:1 문의 탭 활성화');
                this.showListView(); // 목록 뷰 표시
                this.loadInquiryList(); // 목록 로드
            },

            deactivate: function() {
                console.log('[tab2] 1:1 문의 탭 비활성화');
            },

            // DatePicker 초기화 (range 타입)
            initDatePicker: function() {
                if (typeof DatePicker !== 'undefined') {
                    dateRangePicker = new DatePicker({
                        type: 'range',
                        fromId: 'st_from_date',
                        toId: 'st_to_date',
                        dateFormat: '.',
                        onChange: function(data) {
                            console.log('[tab2] 날짜 범위 변경:', data.fromDate, '~', data.toDate);
                        }
                    });
                    dateRangePicker.init();
                    console.log('[tab2] DatePicker 초기화 완료');
                } else {
                    console.error('[tab2] DatePicker.js가 로드되지 않았습니다.');
                }
            },

            // 목록 뷰 표시
            showListView: function() {
                document.getElementById('inquiry-list-view').style.display = 'block';
                document.getElementById('inquiry-form-view').style.display = 'none';
            },

            // 등록 폼 표시
            showFormView: function() {
                var self = this;
                document.getElementById('inquiry-list-view').style.display = 'none';
                document.getElementById('inquiry-form-view').style.display = 'block';

                // 검색 필터의 문의유형 옵션들을 등록 폼에 복사
                var searchQtypeSelect = document.querySelector('#Search2 select[name="st_qtype"]');
                var formQtypeSelect = document.querySelector('#Search2 select[name="qtype"]');

                if (searchQtypeSelect && formQtypeSelect) {
                    // 기존 옵션 초기화
                    formQtypeSelect.innerHTML = '<option value="">문의유형을 선택해주세요</option>';

                    // 검색 필터의 옵션들을 복사 (전체 제외)
                    var searchOptions = searchQtypeSelect.options;
                    for (var i = 0; i < searchOptions.length; i++) {
                        if (searchOptions[i].value !== 'ALL') {
                            var option = document.createElement('option');
                            option.value = searchOptions[i].value;
                            option.text = searchOptions[i].text;
                            formQtypeSelect.appendChild(option);
                        }
                    }

                    // 문의유형 변경 이벤트 등록
                    formQtypeSelect.addEventListener('change', function() {
                        self.toggleInputFields(this.value);
                    });
                }

                // 폼 초기화
                this.resetForm();
            },

            // 문의유형에 따른 입력 필드 활성화/비활성화
            toggleInputFields: function(qtypeValue) {
                var itemCodeInput = document.querySelector('#Search2 input[name="item_code"]');
                var poNoInput = document.querySelector('#Search2 input[name="po_no"]');

                if (!itemCodeInput || !poNoInput) return;

                // 기본: 모두 비활성화
                itemCodeInput.disabled = true;
                itemCodeInput.value = '';
                itemCodeInput.style.backgroundColor = '#f5f5f5';
                poNoInput.disabled = true;
                poNoInput.value = '';
                poNoInput.style.backgroundColor = '#f5f5f5';

                // 문의유형별 활성화 규칙
                switch(qtypeValue) {
                    case 'PR':  // 가격: 품목코드만
                        itemCodeInput.disabled = false;
                        itemCodeInput.style.backgroundColor = '#fff';
                        break;
                    case 'OR':  // 발주: 품목코드 + 발주번호
                    case 'DL':  // 배송: 품목코드 + 발주번호
                    case 'EX':  // 교환/반품: 품목코드 + 발주번호
                    case 'DD':  // 마감: 품목코드 + 발주번호
                        itemCodeInput.disabled = false;
                        itemCodeInput.style.backgroundColor = '#fff';
                        poNoInput.disabled = false;
                        poNoInput.style.backgroundColor = '#fff';
                        break;
                    case 'NR':  // 신규등록: 해당 없음
                    case 'SY':  // 시스템: 해당 없음
                    case 'ET':  // 기타: 해당 없음
                    default:
                        // 모두 비활성화 (이미 위에서 처리됨)
                        break;
                }
            },

            // 폼 초기화
            resetForm: function() {
                var itemCodeInput = document.querySelector('#Search2 input[name="item_code"]');
                var poNoInput = document.querySelector('#Search2 input[name="po_no"]');

                document.querySelector('#Search2 select[name="qtype"]').value = '';

                // 품목코드, 발주번호 필드 초기화 및 비활성화
                itemCodeInput.value = '';
                itemCodeInput.disabled = true;
                itemCodeInput.style.backgroundColor = '#f5f5f5';

                poNoInput.value = '';
                poNoInput.disabled = true;
                poNoInput.style.backgroundColor = '#f5f5f5';

                document.querySelector('#Search2 textarea[name="context"]').value = '';
                document.getElementById('sms_check').checked = false;
                document.querySelector('#Search2 input[name="phone1"]').value = '';
                document.querySelector('#Search2 input[name="phone2"]').value = '';
                document.querySelector('#Search2 input[name="phone3"]').value = '';
                document.getElementById('count').textContent = '0';
            },

            // 이벤트 초기화
            initEvents: function() {
                var self = this;

                // 월별 버튼 클릭 이벤트
                var monthBtns = document.querySelectorAll('#Search2 .But_Month');
                for (var i = 0; i < monthBtns.length; i++) {
                    (function(btn) {
                        btn.addEventListener('click', function() {
                            var months = parseInt(this.getAttribute('data-months'));
                            if (dateRangePicker && months) {
                                dateRangePicker.setRangeByMonths(months);
                            }
                        });
                    })(monthBtns[i]);
                }

                // 조회 버튼 클릭
                document.querySelector('#Search2 .ButMSmallDarkGray').addEventListener('click', function() {
                    self.loadInquiryList();
                });

                // 1:1 문의하기 버튼 클릭
                document.getElementById('show-inquiry-form').addEventListener('click', function() {
                    self.showFormView();
                });

                // 취소 버튼 클릭
                document.getElementById('cancel-inquiry-form').addEventListener('click', function() {
                    self.showListView();
                });

                // 등록 버튼 클릭
                document.getElementById('submitInquiry').addEventListener('click', function() {
                    self.submitInquiry();
                });

                // 문의취소 버튼 클릭 (이벤트 위임)
                document.querySelector('#Search2 .Chat-container').addEventListener('click', function(e) {
                    if (e.target && e.target.classList.contains('cancel-inquiry-btn')) {
                        var qid = e.target.getAttribute('data-qid');
                        if (qid) {
                            self.cancelInquiry(qid);
                        }
                    }
                    // 새로운 문의하기 버튼 클릭 (답변완료 내부)
                    if (e.target && e.target.classList.contains('ButMSmallDarkGray') &&
                        e.target.textContent.indexOf('새로운 문의하기') > -1) {
                        self.showFormView();
                    }
                });

                // 전화번호 입력 필드 - 숫자만 입력 가능하도록 제한
                var phoneInputs = [
                    document.querySelector('#Search2 input[name="phone1"]'),
                    document.querySelector('#Search2 input[name="phone2"]'),
                    document.querySelector('#Search2 input[name="phone3"]')
                ];

                for (var i = 0; i < phoneInputs.length; i++) {
                    (function(input) {
                        if (input) {
                            input.addEventListener('input', function(e) {
                                // 숫자가 아닌 문자 제거
                                this.value = this.value.replace(/[^0-9]/g, '');
                            });

                            // 붙여넣기 시에도 숫자만 허용
                            input.addEventListener('paste', function(e) {
                                var pastedData = e.clipboardData.getData('text');
                                if (!/^[0-9]+$/.test(pastedData)) {
                                    e.preventDefault();
                                    // 숫자만 추출하여 입력
                                    var numbersOnly = pastedData.replace(/[^0-9]/g, '');
                                    this.value = numbersOnly;
                                }
                            });

                            // 키 입력 시 숫자키, 백스페이스, 탭, 방향키만 허용
                            input.addEventListener('keydown', function(e) {
                                var key = e.keyCode || e.which;
                                // 숫자키(48-57, 96-105), 백스페이스(8), 탭(9), 방향키(37-40), Del(46), Home(36), End(35)
                                var allowedKeys = [8, 9, 35, 36, 37, 38, 39, 40, 46];
                                var isNumberKey = (key >= 48 && key <= 57) || (key >= 96 && key <= 105);

                                if (!isNumberKey && allowedKeys.indexOf(key) === -1) {
                                    e.preventDefault();
                                }
                            });
                        }
                    })(phoneInputs[i]);
                }
            },

            // 문의유형 코드 로드
            loadQtypeCodes: function() {
                var self = this;

                HttpUtil.post('/mcsc/getQtypeCodeListJson.do', {}, { showDefaultAlert: false })
                .then(function(response) {
                    if (response.data.success && response.data.data) {
                        var qtypeSelect = document.querySelector('#Search2 select[name="st_qtype"]');
                        if (!qtypeSelect) {
                            // name 속성 추가
                            var selects = document.querySelectorAll('#Search2 .Select');
                            if (selects.length >= 1) {
                                qtypeSelect = selects[0];
                                qtypeSelect.setAttribute('name', 'st_qtype');
                            }
                        }

                        if (qtypeSelect) {
                            qtypeSelect.innerHTML = '<option value="ALL">전체</option>';
                            for (var i = 0; i < response.data.data.length; i++) {
                                var item = response.data.data[i];
                                var option = document.createElement('option');
                                option.value = item.CODE;
                                option.text = item.CODE_NAME;
                                qtypeSelect.appendChild(option);
                            }
                        }

                        // 진행상태 셀렉트박스에 name 속성 추가
                        var statusSelect = document.querySelectorAll('#Search2 .Select')[1];
                        if (statusSelect) {
                            statusSelect.setAttribute('name', 'st_status');
                            statusSelect.innerHTML = '<option value="ALL">전체</option>' +
                                '<option value="C">답변대기</option>' +
                                '<option value="A">답변완료</option>';
                        }
                    }
                })
                .catch(function(error) {
                    console.error('[1:1문의] 문의유형 코드 로드 실패:', error);
                });
            },

            // 1:1 문의 목록 로드
            loadInquiryList: function() {
                var self = this;

                // DatePicker를 통해 날짜 가져오기
                var dateRange = dateRangePicker ? dateRangePicker.getDatePure() : {from: '', to: ''};

                // 검색 조건 수집
                var params = {
                    st_from_date: dateRange.from,
                    st_to_date: dateRange.to,
                    st_qtype: document.querySelector('#Search2 select[name="st_qtype"]').value,
                    st_status: document.querySelector('#Search2 select[name="st_status"]').value
                };

                HttpUtil.post('/mcsc/getInquiryListJson.do', params, { showDefaultAlert: false })
                .then(function(response) {
                    if (response.data.success) {
                        inquiryListData = response.data.data || [];
                        self.renderInquiryList(inquiryListData);
                    } else {
                        alert('문의 목록 조회 실패: ' + (response.data.message || '알 수 없는 오류'));
                    }
                })
                .catch(function(error) {
                    console.error('[1:1문의] 목록 조회 실패:', error);
                    alert('문의 목록 조회 중 오류가 발생했습니다.');
                });
            },

            // 문의 목록 렌더링
            renderInquiryList: function(dataList) {
                var container = document.querySelector('#Search2 .Chat-container');

                if (!dataList || dataList.length === 0) {
                    container.innerHTML = '<div style="padding: 50px; text-align: center;">' +
                        '<img src="/resources/imgs/Icon_Warning01.png" alt="경고" style="display: block; margin: 0 auto 20px; width: 150px; height: 150px;" />' +
                        '등록하신 1:1문의가 없습니다.' +
                        '</div>';
                    return;
                }

                var html = '';

                for (var i = 0; i < dataList.length; i++) {
                    var item = dataList[i];

                    // 답변완료 상태 스타일
                    var statusHtml = item.STATUS === 'A'
                        ? '<span class=" " style="color:#2172ec">' + (item.STATUS_NAME || '') + '</span>'
                        : (item.STATUS_NAME || '');

                    html += '<div class="Chat-item" data-qid="' + item.QID + '">' +
                        '<button class="Chat-question">' +
                        '<table width="100%">' +
                        '<tr>' +
                        '<th width="100px">' + statusHtml + '</th>' +
                        '<td width="80px">' + (item.QTYPE_NAME || '') + '</td>' +
                        '<td width="*">' + (item.SUBJECT || '제목 없음') + '</td>' +
                        '<td width="100px">' + (item.REG_DATE_DIS || '') + '</td>' +
                        '</tr>' +
                        '</table>' +
                        '<span class="Chatarrow"><img src="/resources/imgs/arrow_down.png" /></span>' +
                        '</button>' +
                        '<div class="Chat-answer">' +
                        '<table width="100%">' +
                        '<tr>' +
                        '<td width="100px"></td>' +
                        '<td width="80px"></td>' +
                        '<td width="*"><div class="inquiry-content">로딩중...</div></td>' +
                        '</tr>' +
                        '</table>' +
                        '</div>' +
                        '</div>';
                }

                container.innerHTML = html;
                this.initAccordion();
            },

            // 아코디언 기능 초기화
            initAccordion: function() {
                var self = this;
                var questions = document.querySelectorAll('#Search2 .Chat-question');

                for (var i = 0; i < questions.length; i++) {
                    (function(question) {
                    question.addEventListener('click', function() {
                        var item = this.parentElement;
                        var answer = this.nextElementSibling;
                        var qid = item.getAttribute('data-qid');

                        if (item.classList.contains('active')) {
                            // 닫기
                            answer.style.maxHeight = null;
                            item.classList.remove('active');
                        } else {
                            // 열기 - 상세 데이터 로드
                            self.loadInquiryDetail(qid, function(detailHtml) {
                                // 전체 테이블 HTML을 교체
                                answer.innerHTML = detailHtml;
                                answer.style.maxHeight = answer.scrollHeight + 'px';
                                item.classList.add('active');
                            });
                        }
                    });
                    })(questions[i]);
                }
            },

            // 문의 상세 조회
            loadInquiryDetail: function(qid, callback) {
                var params = { st_qid: qid };

                HttpUtil.post('/mcsc/getInquiryDetailJson.do', params, { showDefaultAlert: false })
                .then(function(response) {
                    if (response.data.success && response.data.data) {
                        var questionData = null;
                        var answerData = null;

                        // 문의(Q)와 답변(A) 분리
                        for (var i = 0; i < response.data.data.length; i++) {
                            var item = response.data.data[i];
                            if (item.ROW_TYPE === 'Q') {
                                questionData = item;
                            } else if (item.ROW_TYPE === 'A') {
                                answerData = item;
                            }
                        }

                        var html = '';

                        // 답변이 없는 경우: 디자인 파일 Line 339-352 구조
                        if (!answerData) {
                            html = '<table width="100%">' +
                                '<tr>' +
                                '<td width="100px"></td>' +
                                '<td width="80px"></td>' +
                                '<td width="*">' + (questionData ? (questionData.CONTEXT || '').replace(/\n/g, '<br>') : '') + '</td>' +
                                '</tr>' +
                                '<tr>' +
                                '<td></td>' +
                                '<td></td>' +
                                '<td valign="bottom"><button class="ChipsDefault_Gray cancel-inquiry-btn" data-qid="' + qid + '" style="cursor:pointer">문의취소하기</button></td>' +
                                '</tr>' +
                                '</table>';
                        } else {
                            // 답변이 있는 경우: 디자인 파일 Line 366-401 구조
                            html = '<table width="100%">' +
                                '<tr>' +
                                '<td width="180px"></td>' +
                                '<td width="*">' + (questionData ? (questionData.CONTEXT || '').replace(/\n/g, '<br>') : '') + '</td>' +
                                '</tr>' +
                                '<tr>' +
                                '<td></td>' +
                                '<td style="padding-right:80px">' +
                                '<table width="100%" class="Kepanswer">' +
                                '<tr>' +
                                '<td width="50px"><span class="ChipsRound_Blue">답변</span></td>' +
                                '<td width="*">' + (answerData.CONTEXT || '').replace(/\n/g, '<br>') + '</td>' +
                                '<td width="100px" style="text-align:right">' + (answerData.REG_DATE_DIS || '') + '</td>' +
                                '</tr>' +
                                '<tr>' +
                                '<td></td>' +
                                '<td colspan="2" class="NewChat">문의에 대한 답변이 부족하거나 추가문의사항이 있으시면 새로운 문의사항으로 등록해주세요 ' +
                                '<button class="ButMSmallDarkGray">새로운 문의하기</button></td>' +
                                '</tr>' +
                                '</table>' +
                                '</td>' +
                                '</tr>' +
                                '</table>';
                        }

                        callback(html);
                    } else {
                        callback('<table width="100%"><tr><td>상세 정보를 불러오는 데 실패했습니다.</td></tr></table>');
                    }
                })
                .catch(function(error) {
                    console.error('[1:1문의] 상세 조회 실패:', error);
                    callback('<table width="100%"><tr><td>상세 정보를 불러오는 데 실패했습니다.</td></tr></table>');
                });
            },

            // 문의 등록
            submitInquiry: function() {
                var self = this;
                var qtype = document.querySelector('#Search2 select[name="qtype"]').value;
                var itemCode = document.querySelector('#Search2 input[name="item_code"]').value;
                var poNo = document.querySelector('#Search2 input[name="po_no"]').value;
                var context = document.querySelector('#Search2 textarea[name="context"]').value;
                var smsCheck = document.getElementById('sms_check').checked;
                var phone1 = document.querySelector('#Search2 input[name="phone1"]').value;
                var phone2 = document.querySelector('#Search2 input[name="phone2"]').value;
                var phone3 = document.querySelector('#Search2 input[name="phone3"]').value;

                // 유효성 검사
                if (!qtype) {
                    alert('문의유형을 선택해주세요.');
                    return;
                }

                if (!context || context.trim() === '') {
                    alert('문의 내용을 입력해주세요.');
                    return;
                }

                // SMS 알림 선택 시 전화번호 체크
                var phone = '';
                if (smsCheck) {
                    // 전화번호 입력 여부 체크
                    if (!phone1 || !phone2 || !phone3) {
                        alert('SMS 알림을 받으시려면 전화번호를 입력해주세요.');
                        document.querySelector('#Search2 input[name="phone1"]').focus();
                        return;
                    }

                    // 전화번호 공백 제거 후 체크
                    phone1 = phone1.trim();
                    phone2 = phone2.trim();
                    phone3 = phone3.trim();

                    // 숫자만 입력 체크
                    var phoneRegex = /^[0-9]+$/;
                    if (!phoneRegex.test(phone1) || !phoneRegex.test(phone2) || !phoneRegex.test(phone3)) {
                        alert('전화번호는 숫자만 입력 가능합니다.');
                        document.querySelector('#Search2 input[name="phone1"]').focus();
                        return;
                    }

                    // 첫 번째 자리 유효성 체크 (010, 011, 016, 017, 018, 019, 02, 031~070)
                    var validFirstDigits = ['010', '011', '016', '017', '018', '019', '02', '031', '032', '033',
                        '041', '042', '043', '044', '051', '052', '053', '054', '055', '061', '062', '063', '064', '070'];
                    if (validFirstDigits.indexOf(phone1) === -1) {
                        alert('올바른 전화번호 형식이 아닙니다.\n(예: 010-1234-5678, 02-1234-5678)');
                        document.querySelector('#Search2 input[name="phone1"]').focus();
                        return;
                    }

                    // 두 번째, 세 번째 자리 길이 체크
                    if (phone1 === '02') {
                        // 02 지역번호: 3-4 또는 4-4 자리
                        if ((phone2.length < 3 || phone2.length > 4) || phone3.length !== 4) {
                            alert('서울 지역번호는 02-123(4)-5678 형식으로 입력해주세요.');
                            document.querySelector('#Search2 input[name="phone2"]').focus();
                            return;
                        }
                    } else if (phone1.indexOf('01') === 0) {
                        // 휴대폰: 3-4 또는 4-4 자리
                        if ((phone2.length < 3 || phone2.length > 4) || phone3.length !== 4) {
                            alert('휴대폰 번호는 010-123(4)-5678 형식으로 입력해주세요.');
                            document.querySelector('#Search2 input[name="phone2"]').focus();
                            return;
                        }
                    } else {
                        // 기타 지역번호: 3-4 또는 4-4 자리
                        if ((phone2.length < 3 || phone2.length > 4) || phone3.length !== 4) {
                            alert('전화번호는 0XX-123(4)-5678 형식으로 입력해주세요.');
                            document.querySelector('#Search2 input[name="phone2"]').focus();
                            return;
                        }
                    }

                    phone = phone1 + phone2 + phone3;
                }

                // 제목 자동 생성 (내용 일부 사용)
                var subject = context.substring(0, 50);

                var params = {
                    st_qtype: qtype,
                    st_subject: subject,
                    st_context: context,
                    st_item_code: itemCode,
                    st_po_no: poNo,
                    st_sms_flag: smsCheck ? 'Y' : 'N',
                    st_phone: phone
                };

                HttpUtil.post('/mcsc/registerInquiryJson.do', params, { showDefaultAlert: false })
                .then(function(response) {
                    if (response.data.success) {
                        alert('문의가 등록되었습니다.');
                        self.showListView();
                        self.loadInquiryList(); // 목록 새로고침
                    } else {
                        alert('문의 등록 실패: ' + (response.data.message || '알 수 없는 오류'));
                    }
                })
                .catch(function(error) {
                    console.error('[1:1문의 등록] 등록 실패:', error);
                    alert('문의 등록 중 오류가 발생했습니다.');
                });
            },

            // 문의 취소
            cancelInquiry: function(qid) {
                var self = this;

                if (!confirm('정말 문의를 취소하시겠습니까?')) {
                    return;
                }

                var params = { st_qid: qid };

                HttpUtil.post('/mcsc/cancelInquiryJson.do', params, { showDefaultAlert: false })
                .then(function(response) {
                    if (response.data.success) {
                        alert('문의가 취소되었습니다.');
                        self.loadInquiryList(); // 목록 새로고침
                    } else {
                        alert('문의 취소 실패: ' + (response.data.message || '알 수 없는 오류'));
                    }
                })
                .catch(function(error) {
                    console.error('[1:1문의 취소] 취소 실패:', error);
                    alert('문의 취소 중 오류가 발생했습니다.');
                });
            }
        };
    });
})();
</script>
