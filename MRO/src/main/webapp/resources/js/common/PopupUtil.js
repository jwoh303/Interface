/**
 * PopupUtil.js
 * 레이어 팝업 전용 유틸리티 모듈
 *
 * 사용 예시 1 (Builder 패턴 - 추천):
 * PopupUtil.callback(function(api) {
 *     api.setMessage('선택한 품목이 없습니다.')
 *        .onConfirm(function() { console.log('확인 클릭'); });
 * }).show(PopupUtil.POPUP_URLS.CONFIRM);
 *
 * 사용 예시 2 (콜백 기반):
 * PopupUtil.showConfirm(function(popup) {
 *     popup.setMessage('선택한 품목이 없습니다.')
 *          .onConfirm(function() { console.log('확인 클릭'); });
 * });
 *
 * 사용 예시 3 (범용):
 * PopupUtil.open({
 *     url: PopupUtil.POPUP_URLS.CONFIRM,
 *     onInit: function(popup) { popup.setMessage('메시지'); }
 * });
 *
 * 다중 팝업 지원:
 * - 여러 팝업을 동시에 열어도 충돌 없음
 * - 각 팝업은 독립적인 API 객체 보유
 *
 * 명명 규칙:
 * - 모든 팝업 HTML 파일은 window.createPopupAPI 함수를 정의해야 함
 * - 매핑 테이블이나 파일명 규칙 불필요 (통일된 함수명 사용)
 */

var PopupUtil = (function() {
    'use strict';

    // 팝업 URL 상수 관리
    var POPUP_URLS = {
        CONFIRM: '/resources/html/common/popup/popup_confirm.html',
        CONFIRM_WITH_CANCEL: '/resources/html/common/popup/popup_confirm_with_cancel.html',  // 취소 버튼이 있는 확인 팝업
        MSDS: '/resources/html/common/popup/reg_msds.html',
        MSDS2: '/resources/html/common/popup/reg_msds2.html',  // 신규 MSDS 팝업 (개선 버전)
        RECOMMAND_ORDER_DETAIL: '/resources/html/common/popup/recommand_order_detail.html',
        CUSTOMER: '/resources/html/common/popup/customer.html',
        TRAN_BUYER_CHOICE: '/resources/html/common/popup/tran_buyer_choice.html',
        PERSONAL_INFORMATION: '/resources/html/common/popup/personal_information.html',  // 개인정보 관리 팝업
        IMAGE_REGISTER: '/resources/html/seller/popup/image_register.html',  // 이미지 첨부 팝업
        ITEM_INFO: '/resources/html/seller/popup/item_info.html',  // 품목정보 팝업
        IMAGE_VIEWER: '/resources/html/common/popup/image_viewer.html',  // 이미지 뷰어 팝업
        BUYER_CLOSING_AMT: '/resources/html/common/popup/buyer_closing_amt.html',  // 고객사별 마감금액 팝업
        UNREAD_NOTICE: '/resources/html/common/popup/popup_unread_notice.html',  // 미확인 공지사항 강제 팝업
        DEPT_CODE: '/resources/html/common/popup/dept_code_list.html',  // 부서 검색 팝업
        POSITION_CODE: '/resources/html/common/popup/position_code_list.html',  // 직급 검색 팝업
        FILE_ATTACH: '/resources/html/common/popup/file_attach.html',  // 서류 파일첨부 팝업
        FILE_ATTACH2: '/resources/html/common/popup/file_attach2.html',  // 서류 파일첨부 팝업(최대 1개)
        DEL_LOCATION: '/resources/html/common/popup/del_location_list.html',  // 배송지(도착지) 검색 팝업
        BUYER_USER_DETAIL: '/resources/html/common/popup/buyer_user_detail.html',  // 구매사 사용자 상세조회 팝업
        BUYER_APPROVAL_PATH: '/resources/html/common/popup/buyer_approval_path.html',  // 결재경로 관리 팝업
        PURCHASE_DEPT: '/resources/html/common/popup/purchase_dept_list.html',  // 발주부서 검색 팝업
        MENU_AUTH: '/resources/html/common/popup/menu_auth_list.html',  // 메뉴 권한 선택 팝업
        REJECT_REASON: '/resources/html/common/popup/reject_reason.html'  // 승인거절 사유 입력 팝업
    };

    // 팝업 카운터 (고유 ID 생성용)
    var popupCounter = 0;

    /**
     * 통일된 API 함수명 (모든 팝업에서 동일한 이름 사용)
     */
    var UNIFIED_API_FUNCTION = 'createPopupAPI';





    /**
     * 팝업 열기 (범용)
     * @param {Object} options 팝업 설정 객체
     * @param {string} options.url - 팝업 HTML URL (필수)
     * @param {Function} [options.onInit] - 팝업 초기화 콜백 (API 객체 전달)
     * @param {string} [options.overlayId] - 오버레이 커스텀 ID (기본: popup-overlay-{counter})
     * @param {string} [options.containerId] - 컨테이너 커스텀 ID (기본: popup-container-{counter})
     *
     * 명명 규칙:
     * - 모든 팝업 HTML은 window.createPopupAPI 함수를 정의해야 함
     * - API는 즉시 생성 후 delete하여 다중 팝업 충돌 방지
     * - 생성된 API는 클로저로 보관하여 콜백에 전달
     */
    function open(options) {
        if (!options || !options.url) {
            console.error('[PopupUtil] URL이 필요합니다.');
            return;
        }

        // 고유 ID 생성
        popupCounter++;
        var overlayId = options.overlayId || 'popup-overlay-' + popupCounter;
        var containerId = options.containerId || 'popup-container-' + popupCounter;

        // 캐시 버스팅: URL에 타임스탬프 추가 (개발 환경에서 HTML 파일 변경 즉시 반영)
        var loadUrl = options.url;
        if (loadUrl.indexOf('?') === -1) {
            loadUrl += '?_t=' + Date.now();
        } else {
            loadUrl += '&_t=' + Date.now();
        }
        console.log('[PopupUtil] 팝업 열기 시작:', loadUrl);

        // HttpUtil로 팝업 HTML 로드
        if (typeof HttpUtil === 'undefined' || typeof HttpUtil.get !== 'function') {
            console.error('[PopupUtil] HttpUtil이 로드되지 않았습니다.');
            return;
        }

        HttpUtil.get(loadUrl, null, {
            showLoader: false,
            showDefaultAlert: false
        }).then(function(response) {
            var html = response.data;

            // 기존 팝업이 있다면 제거 (같은 ID)
            $('#' + overlayId).remove();
            $('#' + containerId).remove();

            // 애니메이션 타입 결정 (기본: 'default', 옵션: 'fromButton')
            var animationType = options.animation || 'default';
            var containerClass = animationType === 'fromButton' ? ' popup-from-button' : '';
            var enterClass = animationType === 'fromButton' ? 'popup-button-enter' : 'popup-enter';

            // 전체 화면 오버레이 및 팝업 HTML 추가
            $('body').append('<div id="' + overlayId + '" class="DIVpopup-overlay" style="z-index:999; position:fixed; top:0; left:0; width:100%; height:100%;"></div>');
            $('body').append('<div id="' + containerId + '" class="' + containerClass.trim() + '" style="z-index:9999; position:fixed;">' + html + '</div>');

            // 애니메이션 타입 저장 (닫기 시 사용)
            $('#' + containerId).data('animationType', animationType);

            // ✅ body 스크롤 방지 (팝업 열릴 때)
            // overflow-y: scroll로 스크롤바 공간 유지, position: fixed로 스크롤 막기
            var scrollY = window.scrollY || window.pageYOffset;
            $('body').css({
                'position': 'fixed',
                'top': -scrollY + 'px',
                'left': '0',
                'right': '0',
                'overflow-y': 'scroll'
            });
            $('body').data('scrollY', scrollY);

            // 팝업 표시 (애니메이션 적용)
            var $overlay = $('#' + overlayId);
            var $popup = $('#' + containerId).find('.DIVpopup');

            // 초기 상태로 표시 (CSS 애니메이션이 처리)
            $overlay.show();
            $popup.show();

            // 애니메이션 클래스 추가 (리플로우 후)
            setTimeout(function() {
                $overlay.addClass('popup-enter');
                $popup.addClass(enterClass);
            }, 10);

            // 즉시 API 생성 (다른 팝업과 충돌 방지)
            var popupAPI = null;
            if (typeof window[UNIFIED_API_FUNCTION] === 'function') {
                // options 객체 생성 (팝업 API에 전달)
                var apiOptions = {
                    onClose: options.onClose || null,
                    autoLoad: options.autoLoad,
                    loadParams: options.loadParams,
                    data: options.data || null  // 사용자 정의 데이터 전달
                };

                popupAPI = window[UNIFIED_API_FUNCTION](overlayId, containerId, apiOptions);
                console.log('[PopupUtil] 팝업 API 생성 완료:', UNIFIED_API_FUNCTION);

                // 생성 후 즉시 삭제하여 다음 팝업과 충돌 방지
                delete window[UNIFIED_API_FUNCTION];
                console.log('[PopupUtil] 전역 API 함수 정리 완료 (충돌 방지)');
            } else {
                console.warn('[PopupUtil] window.' + UNIFIED_API_FUNCTION + ' 함수를 찾을 수 없습니다.');
            }

            // API 생성 및 초기화 콜백 호출
            setTimeout(function() {
                // 초기화 콜백 호출 (클로저로 보관된 popupAPI 전달)
                if (options.onInit && typeof options.onInit === 'function') {
                    options.onInit(popupAPI);
                    console.log('[PopupUtil] onInit 콜백 실행 완료');
                }

                console.log('[PopupUtil] 팝업 로드 완료');
            }, 100);

        }, function(error) {
            console.error('[PopupUtil] 팝업 로드 실패:', error);
            alert('팝업을 불러오는 중 오류가 발생했습니다.');
        });
    }

    /**
     * 확인 팝업 (간편 함수 - 콜백 기반)
     * @param {Function} callback - 팝업 초기화 콜백 (popup API 전달)
     *
     * 사용 예시:
     * PopupUtil.showConfirm(function(popup) {
     *     popup.setMessage('선택한 품목이 없습니다.')
     *          .onConfirm(function() { console.log('확인 클릭'); });
     *     // .init() 불필요: popup_confirm.html에서 자동 실행
     * });
     */
    function showConfirm(callback) {
        open({
            url: POPUP_URLS.CONFIRM,
            onInit: callback
            // window.createPopupAPI 자동 호출 (모든 팝업 공통)
            // overlayId, containerId는 PopupUtil에서 자동 생성
        });
    }

    /**
     * 확인 팝업 (레거시 호환 - 메시지 기반)
     * @param {string} message - 표시할 메시지
     * @param {Function} [onConfirmCallback] - 확인 버튼 콜백
     * @deprecated 콜백 기반 showConfirm 사용 권장
     */
    function showConfirmLegacy(message, onConfirmCallback) {
        showConfirm(function(popup) {
            popup.setMessage(message);
            if (onConfirmCallback) {
                popup.onConfirm(onConfirmCallback);
            }
            // init() 제거: popup_confirm.html에서 자동 실행
        });
    }

    /**
     * 취소 버튼이 있는 확인 팝업 (간편 함수 - 콜백 기반)
     * @param {Function} callback - 팝업 초기화 콜백 (popup API 전달)
     *
     * 사용 예시:
     * PopupUtil.showConfirmWithCancel(function(popup) {
     *     popup.setMessage('수정한 정보로 저장하시겠습니까?')
     *          .onConfirm(function() { console.log('확인 클릭'); })
     *          .onCancel(function() { console.log('취소 클릭'); });
     * });
     */
    function showConfirmWithCancel(callback) {
        open({
            url: POPUP_URLS.CONFIRM_WITH_CANCEL,
            onInit: callback
        });
    }

    /**
     * 취소 버튼이 있는 확인 팝업 (레거시 호환 - 메시지 기반)
     * @param {string} message - 표시할 메시지
     * @param {Function} [onConfirmCallback] - 확인 버튼 콜백
     * @param {Function} [onCancelCallback] - 취소 버튼 콜백
     */
    function showConfirmWithCancelLegacy(message, onConfirmCallback, onCancelCallback) {
        showConfirmWithCancel(function(popup) {
            popup.setMessage(message);
            if (onConfirmCallback) {
                popup.onConfirm(onConfirmCallback);
            }
            if (onCancelCallback) {
                popup.onCancel(onCancelCallback);
            }
        });
    }

    /**
     * MSDS 팝업 (간편 함수)
     * @param {Object} data - MSDS 데이터 객체
     * @param {Function} [onClose] - 닫힐 때 콜백
     */
    function showMsds(data, onClose) {
        open({
            url: POPUP_URLS.MSDS,
            data: data,
            initFunctionName: 'initMsdsPopupEvents',
            setDataFunctionName: 'setMsdsPopupData',
            onClose: onClose
            // overlayId, containerId는 PopupUtil에서 자동 생성
        });
    }

    /**
     * 모든 팝업 닫기 (PopupUtil이 관리하는 팝업만, 애니메이션 적용)
     */
    function closeAll() {
        var $overlays = $('[id^="popup-overlay-"]');
        var $containers = $('[id^="popup-container-"]');

        if ($overlays.length === 0) {
            console.log('[PopupUtil] 닫을 팝업이 없습니다.');
            return;
        }

        // 닫기 애니메이션 시작
        $overlays.removeClass('popup-enter').addClass('popup-exit');
        $containers.find('.DIVpopup').removeClass('popup-enter').addClass('popup-exit');

        // 애니메이션 완료 후 제거 (200ms)
        setTimeout(function() {
            $overlays.remove();
            $containers.remove();

            // ✅ body 스크롤 복원
            var scrollY = $('body').data('scrollY') || 0;
            $('body').css({
                'position': '',
                'top': '',
                'left': '',
                'right': '',
                'overflow-y': ''
            });
            window.scrollTo(0, scrollY);

            console.log('[PopupUtil] 모든 팝업 닫기 완료');
        }, 200);
    }

    /**
     * 특정 팝업 닫기 (애니메이션 적용)
     * @param {string} overlayId - 오버레이 ID
     * @param {string} containerId - 컨테이너 ID
     */
    function close(overlayId, containerId) {
        var $overlay = $('#' + overlayId);
        var $container = $('#' + containerId);
        var $popup = $container.find('.DIVpopup');

        // 이미 닫는 중인지 확인 (중복 호출 방지)
        if ($popup.hasClass('popup-exit')) {
            return;
        }

        // 닫기 애니메이션 시작
        $overlay.removeClass('popup-enter').addClass('popup-exit');
        $popup.removeClass('popup-enter').addClass('popup-exit');

        // 애니메이션 완료 후 제거 (200ms)
        setTimeout(function() {
            $overlay.remove();
            $container.remove();

            // ✅ 모든 팝업이 닫혔는지 확인 후 body 스크롤 복원
            if ($('[id^="popup-overlay-"]').length === 0) {
                var scrollY = $('body').data('scrollY') || 0;
                $('body').css({
                    'position': '',
                    'top': '',
                    'left': '',
                    'right': '',
                    'overflow-y': ''
                });
                window.scrollTo(0, scrollY);
                console.log('[PopupUtil] body 스크롤 복원');
            }

            console.log('[PopupUtil] 팝업 닫기:', overlayId, containerId);
        }, 200);
    }

    /**
     * 고객사 선택 팝업 (간편 함수 - 콜백 기반)
     * @param {Function} callback - 팝업 초기화 콜백 (popup API 전달)
     *
     * 사용 예시:
     * PopupUtil.showCustomer(function(popup) {
     *     popup.setAllowMultiple(false)
     *          .setCustomerData([
     *              { code: 'C001', name: '코리아이플랫폼㈜', itemCount: 235 },
     *              { code: 'C002', name: '삼성전자㈜', itemCount: 150 }
     *          ])
     *          .onConfirm(function(selectedCustomers) {
     *              console.log('선택된 고객사:', selectedCustomers);
     *          });
     * });
     */
    function showCustomer(callback) {
        open({
            url: POPUP_URLS.CUSTOMER,
            onInit: callback
        });
    }

    /**
     * 거래고객사 선택 팝업 (간편 함수 - 콜백 기반)
     * @param {Function} callback - 팝업 초기화 콜백 (popup API 전달)
     *
     * 사용 예시:
     * PopupUtil.showTranBuyerChoice(function(popup) {
     *     popup.setAllowMultiple(false)
     *          .onConfirm(function(selectedCustomers) {
     *              console.log('선택된 거래고객사:', selectedCustomers);
     *          });
     * });
     */
    function showTranBuyerChoice(callback) {
        open({
            url: POPUP_URLS.TRAN_BUYER_CHOICE,
            onInit: callback
        });
    }

    /**
     * 개인정보 관리 팝업 (간편 함수 - 콜백 기반)
     * @param {Function} [callback] - 팝업 초기화 콜백 (popup API 전달, 선택사항)
     *
     * 사용 예시:
     * PopupUtil.showPersonalInfo();  // 기본 호출
     *
     * PopupUtil.showPersonalInfo(function(popup) {
     *     // 필요시 초기화 로직 추가 가능
     * });
     */
    function showPersonalInfo(callback) {
        open({
            url: POPUP_URLS.PERSONAL_INFORMATION,
            onInit: callback
        });
    }

    /**
     * 미확인 공지사항 강제 팝업 (간편 함수 - 콜백 기반)
     * @param {Function} [callback] - 팝업 초기화 콜백 (popup API 전달)
     *
     * 사용 예시:
     * PopupUtil.showUnreadNotice(function(popup) {
     *     popup.setCount(5)
     *          .onGoToNotice(function() { location.href = '/notice'; });
     * });
     */
    function showUnreadNotice(callback) {
        open({
            url: POPUP_URLS.UNREAD_NOTICE,
            onInit: callback
        });
    }

    /**
     * 범용 팝업 열기 (간편 함수)
     * @param {string} url - 팝업 URL (PopupUtil.POPUP_URLS 사용 권장)
     * @param {Object} config - 설정 객체
     * @param {Object} [config.params] - API 호출 시 loadParams로 전달할 파라미터
     * @param {Function} [config.onInit] - 팝업 초기화 콜백 (API 객체 전달)
     * @param {Function} [config.onClose] - 팝업 닫힐 때 콜백 (결과 데이터 전달)
     * @param {number} [config.width] - 팝업 너비 (미사용, 향후 확장용)
     * @param {number} [config.height] - 팝업 높이 (미사용, 향후 확장용)
     *
     * 사용 예시:
     * PopupUtil.openPopup(PopupUtil.POPUP_URLS.MSDS2, {
     *     params: {
     *         st_req_no: 'REQ001',
     *         st_buyer_item_no: 'ITEM001'
     *     },
     *     onClose: function(result) {
     *         if (result && result.saved) {
     *             console.log('저장 완료:', result);
     *             // 그리드 갱신
     *             sheetWrapper.DoSearch('/api/endpoint.do', searchParams);
     *         }
     *     }
     * });
     */
    function openPopup(url, config) {
        config = config || {};

        open({
            url: url,
            // ✅ onClose를 open() 함수의 options로 전달 (createPopupAPI에 전달됨)
            onClose: config.onClose || null,
            autoLoad: config.params ? true : false,
            loadParams: config.params || null,
            onInit: function(popupAPI) {
                // 사용자 정의 onInit 콜백 실행
                if (config.onInit && typeof config.onInit === 'function') {
                    config.onInit(popupAPI);
                }

                // params가 있으면 자동 로드
                if (config.params && popupAPI && popupAPI.loadAndBindData) {
                    popupAPI.loadAndBindData(config.params);
                }
            }
        });
    }

    /**
     * Builder 패턴 - 콜백 설정 (체이닝 방식)
     * @param {Function} callbackFn - 팝업 API를 받을 콜백 함수
     * @returns {Object} show 메서드를 가진 빌더 객체
     *
     * 사용 예시:
     * PopupUtil.callback(function(api) {
     *     api.setMessage('메시지');
     * }).show(PopupUtil.POPUP_URLS.CONFIRM);
     */
    function callback(callbackFn) {
        return {
            /**
             * 팝업 표시
             * @param {string} url - 팝업 URL (PopupUtil.POPUP_URLS.CONFIRM 등)
             */
            show: function(url) {
                open({
                    url: url,
                    onInit: callbackFn
                });
            }
        };
    }

    // Public API
    return {
        POPUP_URLS: POPUP_URLS,
        open: open,
        openPopup: openPopup,  // 범용 팝업 열기 (간편 함수)
        showConfirm: showConfirm,
        showConfirmLegacy: showConfirmLegacy,
        showConfirmWithCancel: showConfirmWithCancel,
        showConfirmWithCancelLegacy: showConfirmWithCancelLegacy,
        showMsds: showMsds,
        showCustomer: showCustomer,
        showTranBuyerChoice: showTranBuyerChoice,
        showPersonalInfo: showPersonalInfo,
        showUnreadNotice: showUnreadNotice,
        close: close,
        closeAll: closeAll,
        callback: callback
    };
})();
