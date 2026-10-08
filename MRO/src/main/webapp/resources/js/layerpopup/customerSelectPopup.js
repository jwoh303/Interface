/**
 * 고객사 선택 팝업 컴포넌트
 *
 * 필요 의존성:
 * - HttpUtil.js (fetch 기반 HTTP 통신 유틸리티)
 *
 * JSP에서 사용 시 다음과 같이 스크립트를 로드해야 함:
 * <script type="text/javascript" src="/resources/js/utils/HttpUtil.js"></script>
 * <script type="text/javascript" src="/resources/js/customerSelectPopup.js"></script>
 */
(function(window) {
    'use strict';
    
    var CustomerSelectPopup = {

        // 현재 팝업 데이터
        currentPopup: null,
        currentData: [],
        allData: [],  // 서버에서 받은 전체 데이터 (필터링용)
        
        /**
         * 고객사 선택 팝업 열기 (DIVpopup 방식)
         * @param {Object} options - 팝업 옵션 (필수)
         */
        open: function(options) {
            // options가 없으면 에러
            if (!options) {
                console.error('[CustomerSelectPopup] options 파라미터가 필요합니다.');
                return;
            }

            // 필수 옵션 체크
            if (!options.apiUrl) {
                options.apiUrl = '/common/commonList_v2.do';
            }

            var popupId = 'customerSelectPopup_' + Date.now();
            this.currentPopup = {
                id: popupId,
                options: options
            };
            
            // DIVpopup 방식으로 팝업 생성
            this.createDivPopup(popupId, options);
            
            // 이벤트 바인딩 (DOM 완전 로드 후)
            var self = this;
            setTimeout(function() {
                self.bindEvents();
            }, 10);
            
            // 초기 데이터 로드 (전체 데이터)
            this.loadData('');
        },
        
        
        /**
         * DIVpopup 방식으로 팝업 생성
         */
        createDivPopup: function(popupId, options) {
            // 기존 팝업이 있으면 제거
            this.removeDivPopup();
            
            // 오버레이 생성
            var overlay = document.createElement('div');
            overlay.className = 'DIVpopup-overlay';
            overlay.id = 'customerPopupOverlay';
            overlay.style.display = 'block';
            
            // 팝업 컨테이너 생성
            var popup = document.createElement('div');
            popup.className = 'DIVpopup';
            popup.id = 'customerPopup';
            popup.style.display = 'block';
            popup.style.width = (options.width || 1000) + 'px';
            popup.style.height = (options.height || 600) + 'px';
            popup.style.minHeight = (options.height || 600) + 'px';
            popup.style.maxHeight = (options.height || 600) + 'px';
            
            // 팝업 내용 생성
            var content = this.createContent(options);
            popup.innerHTML = content;
            
            // DOM에 추가
            document.body.appendChild(overlay);
            document.body.appendChild(popup);
            
            // 오버레이 클릭 시 닫기
            var self = this;
            overlay.onclick = function() {
                self.cancel();
            };
        },
        
        /**
         * DIVpopup 제거
         */
        removeDivPopup: function() {
            var overlay = document.getElementById('customerPopupOverlay');
            var popup = document.getElementById('customerPopup');
            
            if (overlay) {
                overlay.parentNode.removeChild(overlay);
            }
            if (popup) {
                popup.parentNode.removeChild(popup);
            }
        },
        
        /**
         * 팝업 내용 HTML 생성 (리뉴얼 UI 적용)
         */
        createContent: function(options) {
            var html = '<style>';
            html += '.IBSheetTablePopup { height: auto !important; }';
            html += '.IBSheetTablePopup tr { height: 25px !important; }';
            html += '.IBSheetTablePopup td { height: 25px !important; }';
            html += '</style>';
            html += '<div class="wrapPopup" style="height: 100%; box-sizing: border-box; display: flex; flex-direction: column;">';

            // 팝업 타이틀
            html += '<div class="PopupTit">' + options.title;
            html += '<span><a href="javascript:void(0)" id="customerSelectClose" onclick="CustomerSelectPopup.cancel()"><img src="/resources/imgs/Icon_close.png" /></a></span>';
            html += '</div>';
            html += '<div class="h10"></div>';
            
            // 검색 영역
            html += '<div class="SearchPopupInputBox">';
            html += '<form class="SearchPopupInput" onSubmit="return false;" style="width:100%">';
            html += '<input type="text" id="customerSearchInput" placeholder="고객사명을 입력하세요." style="width:85%;">';
            html += '<button type="submit" id="customerSearchBtn">고객사검색버튼</button>';
            html += '</form>';
            html += '</div>';
            
            // 테이블 영역 (헤더 고정, 바디 스크롤)
            html += '<div class="IBSheetPopup" style="flex: 1; border: 1px solid #ddd; min-height: 0; display: flex; flex-direction: column;">';

            // 고정 헤더
            html += '<div style="flex-shrink: 0; overflow: hidden;">';
            html += '<table style="width:100%; border-collapse: collapse; table-layout: fixed;">';
            html += '<colgroup>';
            html += '<col width="10%" />';
            html += '<col width="60%" />';
            html += '<col width="30%" />';
            html += '</colgroup>';
            html += '<thead>';
            html += '<tr>';
            html += '<th style="background-color: #f8f9fa; border-bottom: 2px solid #dee2e6; padding: 8px; font-weight: bold;">선택</th>';
            html += '<th style="background-color: #f8f9fa; border-bottom: 2px solid #dee2e6; padding: 8px; font-weight: bold;">고객사명</th>';
            html += '<th style="background-color: #f8f9fa; border-bottom: 2px solid #dee2e6; padding: 8px; font-weight: bold;">확정마감건수</th>';
            html += '</tr>';
            html += '</thead>';
            html += '</table>';
            html += '</div>';

            // 스크롤 가능한 바디
            html += '<div style="flex: 1; overflow-y: auto; min-height: 0;">';
            html += '<table class="IBSheetTablePopup" id="customerTable" style="width:100%; height: auto; border-collapse: collapse; table-layout: fixed;">';
            html += '<colgroup>';
            html += '<col width="10%" />';
            html += '<col width="60%" />';
            html += '<col width="30%" />';
            html += '</colgroup>';
            html += '<tbody id="customerTableBody">';
            html += this.createLoadingMessage().replace('<tr>', '').replace('</tr>', '');
            html += '</tbody>';
            html += '</table>';
            html += '</div>';
            html += '</div>';
            
            html += '<div class="h30"></div>';

            // 버튼 영역 (하단 고정)
            html += '<div class="PopupListBtnBox_Center" style="flex-shrink: 0;">';
            html += '<button type="button" id="customerSelectConfirm" class="ButPrimary_large" onclick="CustomerSelectPopup.confirmSelection()">확인</button>';
            html += '</div>';
            
            html += '</div>';
            
            return html;
        },
        
        /**
         * 이벤트 바인딩
         */
        bindEvents: function() {
            var self = this;

            // 검색 버튼 - 클라이언트 사이드 필터링 사용
            document.getElementById('customerSearchBtn').onclick = function(e) {
                e = e || window.event;
                if (e.preventDefault) e.preventDefault();
                var keyword = document.getElementById('customerSearchInput').value;
                self.performClientSearch(keyword);
                return false;
            };

            // 엔터키 검색 (form submit 이벤트) - 클라이언트 사이드 필터링 사용
            var searchForm = document.querySelector('.SearchPopupInput');
            if (searchForm) {
                searchForm.onsubmit = function(e) {
                    e = e || window.event;
                    if (e.preventDefault) e.preventDefault();
                    var keyword = document.getElementById('customerSearchInput').value;
                    self.performClientSearch(keyword);
                    return false;
                };
            }

            // 실시간 검색 (입력할 때마다 필터링)
            var searchInput = document.getElementById('customerSearchInput');
            if (searchInput) {
                searchInput.oninput = function() {
                    var keyword = this.value;
                    self.performClientSearch(keyword);
                };
            }
            
            // 전체 선택 기능 제거됨
            
            // 확인 버튼
            document.getElementById('customerSelectConfirm').onclick = function() {
                self.confirmSelection();
            };
            
            // 닫기 버튼 (X 아이콘)
            var closeBtn = document.getElementById('customerSelectClose');
            if (closeBtn) {
                closeBtn.onclick = function(e) {
                    e = e || window.event;
                    if (e.preventDefault) e.preventDefault();
                    self.cancel();
                    return false;
                };
            }
        },
        
        /**
         * 데이터 로드 (HttpUtil 사용) - apiUrl 사용
         */
        loadData: function(keyword) {
            var self = this;
            var tbody = document.getElementById('customerTableBody');
            
            // currentPopup이 null인 경우 기본값 설정
            if (!this.currentPopup) {
                this.currentPopup = {
                    options: this.extend(this.defaults, {
                        apiUrl: '/common/commonList.do'
                    })
                };
            }
            
            // 로딩 표시 (tbody가 존재하는 경우에만)
            if (tbody) {
                tbody.innerHTML = this.createLoadingMessage();
            }
            
            var options = this.currentPopup.options;
            var businessCond = options.businessCond || 'B'; // B: 고객사, S: 협력사

            // AJAX 파라미터 구성
            var ajaxParams = {
                codeGubun: 'icomcmpyPop',
                BUSINESS_COND: businessCond,
                MULTI: 'N'  // 단일 선택만 지원
            };

            if (keyword) {
                ajaxParams.COM_NAME_LOC = keyword;
            }

            console.log('전송 파라미터:', ajaxParams);

            // HttpUtil을 사용한 POST 요청 (로딩바 비활성화)
            HttpUtil.post(options.apiUrl, ajaxParams, {
                timeout: options.timeout || 30000,  // 리뉴얼: 기본 30초, options로 변경 가능
                showLoader: false,  // 로딩바 숨김
                onError: function(error, config) {
                    // 화면별 특화 에러 처리
                    console.log('=== [DEBUG] 고객사 선택 팝업 에러 처리 ===');
                    console.log('Error:', error.message);
                    console.log('User Message:', error.userMessage);

                    // tbody에 에러 메시지 표시 (화면별 특화 처리)
                    if (tbody) {
                        tbody.innerHTML = '<tr style="height: 25px; cursor: default;"><td colspan="3" style="height: 25px; padding: 2px 5px; vertical-align: middle; text-align: center; color: #dc3545; border-bottom: 1px solid #dee2e6;">데이터 로드 중 오류가 발생했습니다.</td></tr>';
                    }

                    // 사용자에게 알림 (공통 처리에서 기본 alert가 표시되지 않으므로 여기서 표시)
                    alert(error.userMessage || '고객사 정보를 불러오는 중 오류가 발생했습니다.');
                }
            })
            .then(function(response) {
                console.log('=== [DEBUG] HttpUtil 응답 시작 ===');
                console.log(response.data);

                var data = self.parseExistingAPIResponse(response.data);
                if (data && data.length > 0) {
                    // 검색어가 없는 경우(초기 로드)에만 전체 데이터 저장
                    if (!keyword) {
                        self.allData = data;  // 전체 데이터 저장
                    }
                    self.currentData = data;
                    self.renderTable(self.currentData);
                } else {
                    if (tbody) {
                        tbody.innerHTML = '<tr style="height: 25px; cursor: default;"><td colspan="3" style="height: 25px; padding: 2px 5px; vertical-align: middle; text-align: center; color: #6c757d; font-style: italic; border-bottom: 1px solid #dee2e6;">조회된 데이터가 없습니다.</td></tr>';
                    }
                }
            })
            .catch(function(error) {
                // 추가적인 에러 처리가 필요한 경우에만 사용
                // 일반적인 에러 처리는 onError 콜백에서 처리됨
                console.error('=== 예상치 못한 에러 ===', error);
            });
     
        },

        /**
         * 데이터 필터링 (클라이언트 사이드)
         */
        filterData: function(data, keyword) {
            if (!keyword || keyword.trim() === '') {
                return data;
            }

            var filteredData = [];
            var searchKeyword = keyword.toLowerCase().trim();

            for (var i = 0; i < data.length; i++) {
                var item = data[i];
                var companyName = (item.COM_NAME_LOC || '').toLowerCase();
                var companyCode = (item.COM_CODE || '').toLowerCase();

                // 고객사명 또는 고객사코드에 검색어가 포함되어 있으면 포함
                if (companyName.indexOf(searchKeyword) > -1 ||
                    companyCode.indexOf(searchKeyword) > -1) {
                    filteredData.push(item);
                }
            }

            return filteredData;
        },

        /**
         * 실시간 검색 (서버 데이터 기반)
         */
        performClientSearch: function(keyword) {
            if (this.allData.length === 0) {
                // 전체 데이터가 없으면 서버에서 다시 로드
                this.loadData(keyword);
                return;
            }

            // 클라이언트에서 필터링
            this.currentData = this.filterData(this.allData, keyword);
            this.renderTable(this.currentData);

            console.log('클라이언트 검색 완료:', keyword, '결과:', this.currentData.length + '건');
        },

        /**
         * 기존 API 응답 파싱 (JSP 응답에서 데이터 추출)
         */
        parseExistingAPIResponse: function(responseText) {
            console.log('=== [DEBUG] parseExistingAPIResponse 시작 ===');
            console.log('응답 데이터 타입:', typeof responseText);
            console.log('응답 데이터:', responseText);

            try {
                var jsonData;

                // 이미 객체인 경우 (AJAX dataType이 json인 경우)
                if (typeof responseText === 'object') {
                    jsonData = responseText;
                } else {
                    // 문자열인 경우 JSON 파싱
                    jsonData = JSON.parse(responseText);
                }

                console.log('처리된 JSON 데이터:', jsonData);

                // Data 속성 확인 (IBSheetResponseUtil은 대문자 D로 응답)
                if (!jsonData.Data) {
                    console.error('응답에 Data 속성이 없습니다.');
                    console.error('전체 응답 구조:', jsonData);
                    return [];
                }

                var data = jsonData.Data;

                console.log('원본 데이터:', data);
                return data;

            } catch (e) {
                console.error('JSON 파싱 에러:', e);
                return [];
            }

        },
        
        
     
        
        /**
         * 테이블 렌더링 (리뉴얼 UI 적용)
         */
        renderTable: function(data) {
            var tbody = document.getElementById('customerTableBody');
            var options = this.currentPopup.options;
            var html = '';
            
            if (data.length === 0) {
                html = '<tr style="height: 25px; cursor: default;"><td colspan="3" style="height: 25px; padding: 2px 5px; vertical-align: middle; text-align: center; color: #6c757d; font-style: italic; border-bottom: 1px solid #dee2e6;">검색 결과가 없습니다.</td></tr>';
            } else {
                for (var i = 0; i < data.length; i++) {
                    var item = data[i];
                    html += '<tr style="cursor: pointer; height: 25px;" data-index="' + i + '">'

                    // 라디오 버튼 컬럼 - 단일 선택
                    html += '<td style="text-align: center; vertical-align: middle; height: 25px; padding: 2px;">';
                    html += '<input type="radio" ';
                    html += 'name="customerSelect" value="' + item.COM_CODE + '" ';
                    html += 'data-compy-name="' + (item.COM_NAME_LOC || '') + '" ';
                    html += 'data-index="' + i + '" ';
                    html += 'style="display: inline-block !important; width: 15px; height: 15px; cursor: pointer; margin: 0; vertical-align: middle;">';
                    html += '</td>';

                    // 고객사명 컬럼
                    html += '<td style="height: 25px; padding: 2px 5px; vertical-align: middle; text-align: left;">' + (item.COM_NAME_LOC || '') + '</td>';

                    // 확정마감건수 컬럼
                    html += '<td style="height: 25px; padding: 2px 5px; vertical-align: middle; text-align: right;">' + this.formatNumber(item.LOGISTICS_CENTER_CNT || 0) + '</td>';

                    html += '</tr>';
                }
            }
            
            tbody.innerHTML = html;

            console.log('=== [DEBUG] renderTable 완료 ===');
            console.log('생성된 HTML:', html.substring(0, 200) + '...');
            console.log('tbody에 HTML 삽입 완료, 이제 이벤트 바인딩 시작...');

            // 체크박스 이벤트 바인딩
            this.bindCheckboxEvents();
        },
        
        /**
         * 체크박스 이벤트 바인딩 (jQuery + 네이티브 혼용)
         */
        bindCheckboxEvents: function() {
            var self = this;

            // 체크박스/라디오 버튼 change 이벤트 바인딩
            $(document).on('change', 'input[name="customerSelect"]', function() {
                var checkbox = this;

                console.log('체크박스 상태 변경:', checkbox.value, checkbox.checked);

                // 단일 선택 모드인 경우 다른 체크박스 해   제


                $(this).prop('checked', true);



                // 시각적 상태 업데이트
                // self.updateRowVisualState(checkbox);

                // // 선택된 항목 업데이트
                // self.updateSelectedItems();

                // console.log('현재 선택된 항목:', self.selectedItems);
            });
        },

        /**
         * 선택 확인
         */
        confirmSelection: function() {
            // 선택된 라디오 버튼 찾기
            var selectedRadio = document.querySelector('input[name="customerSelect"]:checked');

            if (!selectedRadio) {
                alert('고객사를 선택해주세요.');
                return;
            }

            // 선택된 항목 데이터 가져오기
            var dataIndex = selectedRadio.getAttribute('data-index');
            var selectedItem = this.currentData[parseInt(dataIndex)];

            var options = this.currentPopup.options;

            // targetNameField에 고객사명 자동 설정
            if (options.targetNameField) {
                var nameField = document.getElementById(options.targetNameField);
                if (nameField) {
                    nameField.value = selectedItem.COM_NAME_LOC || '';
                } else {
                    console.warn('[CustomerSelectPopup] targetNameField 요소를 찾을 수 없습니다:', options.targetNameField);
                }
            }

            // targetCodeField에 고객사코드 자동 설정
            if (options.targetCodeField) {
                var codeField = document.getElementById(options.targetCodeField);
                if (codeField) {
                    codeField.value = selectedItem.COM_CODE || '';
                } else {
                    console.warn('[CustomerSelectPopup] targetCodeField 요소를 찾을 수 없습니다:', options.targetCodeField);
                }
            }

            // 사용자 정의 콜백 실행 (단일 항목을 배열로 전달)
            if (options.onSelect) {
                options.onSelect([selectedItem]);
            }

            this.close();
        },

        /**
         * 취소
         */
        cancel: function() {
            if (this.currentPopup && this.currentPopup.options && this.currentPopup.options.onCancel) {
                this.currentPopup.options.onCancel();
            }
            this.close();
        },
        
        /**
         * 팝업 닫기
         */
        close: function() {
            this.removeDivPopup();
            this.onClose();
        },
        
        /**
         * 팝업 닫기 콜백
         */
        onClose: function() {
            this.currentPopup = null;
            this.currentData = [];
            return true;
        },
        
        /**
         * 숫자 포맷팅
         */
        formatNumber: function(num) {
            if (!num) return '0';
            return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        },

        /**
         * 로딩 메시지 생성 (애니메이션 효과 포함)
         */
        createLoadingMessage: function() {
            var animationCSS = '<style>' +
                '@keyframes shimmer {' +
                '  0% { color: #6c757d; }' +
                '  50% { color:rgba(255,255,255,1); text-shadow: 0 0 10px rgba(255,255,255,1); }' +
                '  100% { color: #6c757d; }' +
                '}' +
                '.loading-text span {' +
                '  animation: shimmer 1.5s ease-in-out infinite;' +
                '}' +
                '.loading-text span:nth-child(1) { animation-delay: 0s; }' +
                '.loading-text span:nth-child(2) { animation-delay: 0.1s; }' +
                '.loading-text span:nth-child(3) { animation-delay: 0.2s; }' +
                '.loading-text span:nth-child(4) { animation-delay: 0.3s; }' +
                '.loading-text span:nth-child(5) { animation-delay: 0.4s; }' +
                '.loading-text span:nth-child(6) { animation-delay: 0.5s; }' +
                '</style>';

            var messageText = '검색중입니다.';
            var spanElements = '';

            for (var i = 0; i < messageText.length; i++) {
                spanElements += '<span>' + messageText.charAt(i) + '</span>';
            }

            return animationCSS +
                   '<tr><td colspan="3" style="padding: 30px 20px; text-align: center; border-bottom: 1px solid #dee2e6;">' +
                   '<div class="loading-text" style="font-style: italic; font-size: 24px; font-weight:500">' + spanElements + '</div>' +
                   '</td></tr>';
        }

    };
    
    // 전역 객체로 등록
    window.CustomerSelectPopup = CustomerSelectPopup;
    
})(window);