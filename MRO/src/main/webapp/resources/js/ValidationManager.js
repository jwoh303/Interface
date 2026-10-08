/**
 * ValidationManager.js
 * 재사용 가능한 입력 필드 검증 모듈
 *
 *
 * @example
 * // 초기화
 * ValidationManager.init({
 *     autoValidate: true,
 *     realtime: true,
 *     scrollOnError: true
 * });
 *
 * // 검증 규칙 추가
 * ValidationManager.addRule('company_name', {
 *     required: true,
 *     minLength: 2,
 *     maxLength: 100,
 *     pattern: /^[A-Za-z0-9\s.,&-]+$/,
 *     errorMessage: '회사명을 올바르게 입력하세요.'
 * });
 *
 * // 전체 검증
 * if (ValidationManager.validateAll()) {
 *     // 검증 통과
 * }
 */

var ValidationManager = (function() {
    'use strict';

    // ==================== 설정 ====================
    var config = {
        autoValidate: true,      // blur 이벤트 시 자동 검증
        realtime: false,         // input 이벤트 시 실시간 검증
        scrollOnError: true,     // 에러 시 첫 번째 에러 필드로 스크롤
        scrollOffset: 100,       // 스크롤 오프셋
        errorClass: 'validation-error',
        successClass: 'validation-success',
        errorMessageClass: 'error-message',
        showSuccessState: false  // 성공 상태 표시 여부
    };

    // 검증 규칙 저장소
    var rules = {};

    // 에러 상태 저장소
    var errors = {};

    // ==================== 내장 검증 함수 ====================

    var validators = {
        /**
         * 필수 입력 검증
         */
        required: function(value, param) {
            if (Array.isArray(value)) {
                return value.length > 0;
            }
            return value !== null && value !== undefined && value.trim() !== '';
        },

        /**
         * 최소 길이 검증
         */
        minLength: function(value, param) {
            if (!value) return true; // 빈 값은 required에서 체크
            return value.length >= parseInt(param);
        },

        /**
         * 최대 길이 검증
         */
        maxLength: function(value, param) {
            if (!value) return true;
            return value.length <= parseInt(param);
        },

        /**
         * 정확한 길이 검증
         */
        length: function(value, param) {
            if (!value) return true;
            return value.length === parseInt(param);
        },

        /**
         * 정규표현식 패턴 검증
         */
        pattern: function(value, param) {
            if (!value) return true;
            var regex = typeof param === 'string' ? new RegExp(param) : param;
            return regex.test(value);
        },

        /**
         * 숫자만 허용
         */
        number: function(value, param) {
            if (!value) return true;
            return /^\d+$/.test(value);
        },

        /**
         * 한글만 허용
         */
        korean: function(value, param) {
            if (!value) return true;
            return /^[가-힣\s]+$/.test(value);
        },

        /**
         * 영문만 허용
         */
        english: function(value, param) {
            if (!value) return true;
            return /^[A-Za-z\s]+$/.test(value);
        },

        /**
         * 큰따옴표(")와 작은따옴표(') 금지
         */
        noQuotes: function(value, param) {
            if (!value) return true;
            return !/["']/.test(value);
        },

        /**
         * 휴대폰 번호가 아닌 지역번호 검증 (01로 시작하지 않음)
         */
        areaCode: function(value, param) {
            if (!value) return true;
            return !/^01/.test(value);
        },

        /**
         * 영문+숫자만 허용
         */
        alphanumeric: function(value, param) {
            if (!value) return true;
            return /^[A-Za-z0-9]+$/.test(value);
        },

        /**
         * 전화번호 형식 검증 (XXX-XXXX-XXXX 또는 XX-XXXX-XXXX)
         */
        phone: function(value, param) {
            if (!value) return true;
            return /^0\d{1,2}-\d{3,4}-\d{4}$/.test(value);
        },

        /**
         * 휴대폰 형식 검증 (010-XXXX-XXXX)
         */
        mobile: function(value, param) {
            if (!value) return true;
            return /^01[0-9]-\d{3,4}-\d{4}$/.test(value);
        },

        /**
         * 이메일 형식 검증
         */
        email: function(value, param) {
            if (!value) return true;
            return /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(value);
        },

        /**
         * URL 형식 검증
         */
        url: function(value, param) {
            if (!value) return true;
            return /^https?:\/\/.+/.test(value);
        },

        /**
         * 날짜 형식 및 범위 검증
         * param: 'past' (과거만), 'future' (미래만), 'YYYY-MM-DD' (특정 날짜 이후/이전)
         */
        date: function(value, param) {
            if (!value) return true;

            // 날짜 파싱 (YYYY/MM/DD 또는 YYYY-MM-DD)
            var dateStr = value.replace(/\//g, '-');
            var date = new Date(dateStr);

            if (isNaN(date.getTime())) {
                return false; // 유효하지 않은 날짜
            }

            if (param === 'past') {
                return date < new Date();
            } else if (param === 'future') {
                return date > new Date();
            } else if (param && param.match(/^\d{4}-\d{2}-\d{2}$/)) {
                var compareDate = new Date(param);
                return date >= compareDate;
            }

            return true;
        },

        /**
         * 최소 체크박스 선택 수 검증
         */
        minChecked: function(value, param) {
            // value는 체크된 요소의 배열
            return Array.isArray(value) && value.length >= parseInt(param);
        },

        /**
         * 최대 체크박스 선택 수 검증
         */
        maxChecked: function(value, param) {
            return Array.isArray(value) && value.length <= parseInt(param);
        }
    };

    // ==================== 에러 메시지 템플릿 ====================

    var errorMessages = {
        required: '필수 입력 항목입니다.',
        minLength: '최소 {param}자 이상 입력해야 합니다.',
        maxLength: '최대 {param}자까지 입력 가능합니다.',
        length: '{param}자를 입력해야 합니다.',
        pattern: '올바른 형식으로 입력하세요.',
        number: '숫자만 입력 가능합니다.',
        korean: '한글만 입력 가능합니다.',
        english: '영문만 입력 가능합니다.',
        alphanumeric: '영문과 숫자만 입력 가능합니다.',
        phone: '올바른 전화번호 형식이 아닙니다. (예: 02-1234-5678)',
        mobile: '올바른 휴대폰 번호 형식이 아닙니다. (예: 010-1234-5678)',
        email: '올바른 이메일 형식이 아닙니다.',
        url: '올바른 URL 형식이 아닙니다. (http:// 또는 https://로 시작)',
        date: '올바른 날짜 형식이 아닙니다.',
        minChecked: '최소 {param}개 이상 선택해야 합니다.',
        maxChecked: '최대 {param}개까지 선택 가능합니다.'
    };

    // ==================== 유틸리티 함수 ====================

    /**
     * 요소의 값 가져오기
     */
    function getFieldValue(fieldId) {
        var element = document.getElementById(fieldId);
        if (!element) return null;

        // 체크박스/라디오 그룹
        if (element.type === 'checkbox' || element.type === 'radio') {
            var name = element.name || fieldId;
            var elements = document.querySelectorAll('[name="' + name + '"]');
            var values = [];
            for (var i = 0; i < elements.length; i++) {
                if (elements[i].checked) {
                    values.push(elements[i].value);
                }
            }
            return element.type === 'radio' ? (values[0] || '') : values;
        }

        return element.value;
    }

    /**
     * 에러 메시지 생성
     */
    function generateErrorMessage(ruleName, param, customMessage) {
        if (customMessage) return customMessage;

        var template = errorMessages[ruleName] || '입력값이 올바르지 않습니다.';
        return template.replace('{param}', param);
    }

    /**
     * 요소에 에러 클래스 추가
     */
    function addErrorClass(fieldId) {
        var element = document.getElementById(fieldId);
        if (!element) return;

        element.classList.remove(config.successClass);
        element.classList.add(config.errorClass);

        // 체크박스/라디오 그룹인 경우 모든 요소에 적용
        if (element.type === 'checkbox' || element.type === 'radio') {
            var name = element.name || fieldId;
            var elements = document.querySelectorAll('[name="' + name + '"]');
            for (var i = 0; i < elements.length; i++) {
                elements[i].classList.add(config.errorClass);
            }
        }
    }

    /**
     * 요소에서 에러 클래스 제거
     */
    function removeErrorClass(fieldId) {
        var element = document.getElementById(fieldId);
        if (!element) return;

        element.classList.remove(config.errorClass);

        if (config.showSuccessState) {
            element.classList.add(config.successClass);
        }

        // 체크박스/라디오 그룹인 경우 모든 요소에서 제거
        if (element.type === 'checkbox' || element.type === 'radio') {
            var name = element.name || fieldId;
            var elements = document.querySelectorAll('[name="' + name + '"]');
            for (var i = 0; i < elements.length; i++) {
                elements[i].classList.remove(config.errorClass);
                if (config.showSuccessState) {
                    elements[i].classList.add(config.successClass);
                }
            }
        }
    }

    /**
     * 에러 메시지 표시
     */
    function showErrorMessage(fieldId, message) {
        // data-error-for 속성으로 연결된 에러 메시지 요소 찾기
        var errorElement = document.querySelector('[data-error-for="' + fieldId + '"]');

        if (errorElement) {
            errorElement.textContent = message;
            errorElement.classList.add('show');
        }
    }

    /**
     * 에러 메시지 숨김
     */
    function hideErrorMessage(fieldId) {
        var errorElement = document.querySelector('[data-error-for="' + fieldId + '"]');

        if (errorElement) {
            errorElement.textContent = '';
            errorElement.classList.remove('show');
        }
    }

    /**
     * 첫 번째 에러 필드로 스크롤
     */
    function scrollToFirstError() {
        var errorFields = document.querySelectorAll('.' + config.errorClass);
        if (errorFields.length > 0) {
            var firstError = errorFields[0];
            var offsetTop = firstError.getBoundingClientRect().top + window.pageYOffset - config.scrollOffset;

            window.scrollTo({
                top: offsetTop,
                behavior: 'smooth'
            });

            // 하이라이트 애니메이션
            firstError.classList.add('highlight');
            setTimeout(function() {
                firstError.classList.remove('highlight');
            }, 600);

            // 포커스
            setTimeout(function() {
                firstError.focus();
            }, 300);
        }
    }

    // ==================== 공개 API ====================

    return {
        /**
         * ValidationManager 초기화
         * @param {Object} options - 설정 옵션
         */
        init: function(options) {
            // 설정 병합
            if (options) {
                for (var key in options) {
                    if (options.hasOwnProperty(key)) {
                        config[key] = options[key];
                    }
                }
            }

            // data-validate 속성을 가진 모든 요소 자동 등록
            this.autoRegisterFields();

            // 이벤트 리스너 등록
            if (config.autoValidate) {
                this.attachEventListeners();
            }
        },

        /**
         * data-validate 속성을 가진 필드 자동 등록
         */
        autoRegisterFields: function() {
            var fields = document.querySelectorAll('[data-validate]');
            console.log('[ValidationManager] 찾은 필드 수:', fields.length);

            for (var i = 0; i < fields.length; i++) {
                var field = fields[i];
                var fieldId = field.id;
                var validateStr = field.getAttribute('data-validate');
                var errorMessage = field.getAttribute('data-error-message');

                if (!fieldId || !validateStr) {
                    console.log('[ValidationManager] 스킵된 필드:', field.name || field.tagName, '(ID 없음:', !fieldId, ', 검증규칙 없음:', !validateStr, ')');
                    continue;
                }

                // 검증 규칙 파싱
                var ruleObj = this.parseValidationString(validateStr);
                if (errorMessage) {
                    ruleObj.errorMessage = errorMessage;
                }

                this.addRule(fieldId, ruleObj);
                console.log('[ValidationManager] 필드 등록:', fieldId, '규칙:', validateStr);
            }
        },

        /**
         * 검증 문자열 파싱 (예: "required|minLength:2|maxLength:100")
         */
        parseValidationString: function(str) {
            var ruleObj = {};
            var parts = str.split('|');

            for (var i = 0; i < parts.length; i++) {
                var part = parts[i].trim();
                var colonIndex = part.indexOf(':');

                if (colonIndex > -1) {
                    var ruleName = part.substring(0, colonIndex);
                    var param = part.substring(colonIndex + 1);
                    ruleObj[ruleName] = param;
                } else {
                    ruleObj[part] = true;
                }
            }

            return ruleObj;
        },

        /**
         * 검증 규칙 추가
         * @param {String} fieldId - 필드 ID
         * @param {Object} ruleObj - 검증 규칙 객체
         */
        addRule: function(fieldId, ruleObj) {
            rules[fieldId] = ruleObj;
        },

        /**
         * 검증 규칙 제거
         * @param {String} fieldId - 필드 ID
         */
        removeRule: function(fieldId) {
            delete rules[fieldId];
            delete errors[fieldId];
            this.clearError(fieldId);
        },

        /**
         * 단일 필드 검증
         * @param {String} fieldId - 필드 ID
         * @returns {Boolean} 검증 통과 여부
         */
        validateField: function(fieldId) {
            var rule = rules[fieldId];
            if (!rule) return true;

            var value = getFieldValue(fieldId);
            var isValid = true;
            var errorMsg = '';

            // 각 검증 규칙 수행
            for (var ruleName in rule) {
                if (!rule.hasOwnProperty(ruleName)) continue;
                if (ruleName === 'errorMessage') continue;

                var validator = validators[ruleName];
                if (!validator) continue;

                var param = rule[ruleName];
                var result = validator(value, param);

                if (!result) {
                    isValid = false;
                    errorMsg = generateErrorMessage(ruleName, param, rule.errorMessage);
                    break;
                }
            }

            // 결과 처리
            if (isValid) {
                this.clearError(fieldId);
                delete errors[fieldId];
            } else {
                this.showError(fieldId, errorMsg);
                errors[fieldId] = errorMsg;
            }

            return isValid;
        },

        /**
         * 모든 필드 검증
         * @returns {Boolean} 전체 검증 통과 여부
         */
        validateAll: function() {
            var isValid = true;
            errors = {};

            for (var fieldId in rules) {
                if (rules.hasOwnProperty(fieldId)) {
                    if (!this.validateField(fieldId)) {
                        isValid = false;
                    }
                }
            }

            // 첫 번째 에러로 스크롤
            if (!isValid && config.scrollOnError) {
                scrollToFirstError();
            }

            return isValid;
        },

        /**
         * 에러 표시
         * @param {String} fieldId - 필드 ID
         * @param {String} message - 에러 메시지
         */
        showError: function(fieldId, message) {
            addErrorClass(fieldId);
            showErrorMessage(fieldId, message);
        },

        /**
         * 에러 제거
         * @param {String} fieldId - 필드 ID
         */
        clearError: function(fieldId) {
            removeErrorClass(fieldId);
            hideErrorMessage(fieldId);
        },

        /**
         * 모든 에러 제거
         */
        clearAllErrors: function() {
            for (var fieldId in errors) {
                if (errors.hasOwnProperty(fieldId)) {
                    this.clearError(fieldId);
                }
            }
            errors = {};
        },

        /**
         * 에러 목록 가져오기
         * @returns {Object} 에러 객체 {fieldId: errorMessage}
         */
        getErrors: function() {
            return errors;
        },

        /**
         * 첫 번째 에러 필드로 스크롤
         */
        scrollToFirstError: function() {
            scrollToFirstError();
        },

        /**
         * 이벤트 리스너 등록
         */
        attachEventListeners: function() {
            var self = this;

            for (var fieldId in rules) {
                if (!rules.hasOwnProperty(fieldId)) continue;

                var element = document.getElementById(fieldId);
                if (!element) continue;

                // blur 이벤트
                element.addEventListener('blur', function() {
                    self.validateField(this.id);
                });

                // input 이벤트 (실시간 검증)
                if (config.realtime) {
                    element.addEventListener('input', function() {
                        if (errors[this.id]) {
                            self.validateField(this.id);
                        }
                    });
                }

                // 체크박스/라디오는 change 이벤트
                if (element.type === 'checkbox' || element.type === 'radio') {
                    var name = element.name || fieldId;
                    var elements = document.querySelectorAll('[name="' + name + '"]');

                    for (var i = 0; i < elements.length; i++) {
                        elements[i].addEventListener('change', function() {
                            self.validateField(fieldId);
                        });
                    }
                }
            }
        },

        /**
         * 커스텀 검증 함수 추가
         * @param {String} name - 검증 규칙 이름
         * @param {Function} validatorFn - 검증 함수
         * @param {String} errorMessage - 에러 메시지 템플릿
         */
        addValidator: function(name, validatorFn, errorMessage) {
            validators[name] = validatorFn;
            if (errorMessage) {
                errorMessages[name] = errorMessage;
            }
        }
    };
})();
