/**
 * HttpUtil.js - Fetch 기반 HTTP 통신 유틸리티
 */
(function(window) {
    'use strict';

    /**
     * HttpUtil 생성자
     */
    function HttpUtil() {
        // 기본 설정
        this.defaults = {
            timeout: 10000,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest'
            },
            credentials: 'same-origin'
        };

        // 인터셉터 등록 배열
        this.requestInterceptors = [];
        this.responseInterceptors = [];
        this.errorInterceptors = [];

        // 디버그 모드 (개발환경에서 true)
        this.debug = window.location.hostname === 'localhost' ||
                    window.location.hostname === '127.0.0.1';

        // 상세 로깅 모드 (기본값: false, 수동으로 활성화 필요)
        this.enableDetailedLogging = false;

        // 로깅 시스템
        this.logger = {
            info: this.createLogger('INFO'),
            warn: this.createLogger('WARN'),
            error: this.createLogger('ERROR'),
            debug: this.createLogger('DEBUG')
        };

        // 성능 메트릭 수집
        this.metrics = {
            totalRequests: 0,
            successfulRequests: 0,
            failedRequests: 0,
            averageResponseTime: 0,
            responseTimeHistory: []
        };

        // 초기화
        this.init();
    }

    /**
     * 초기화 함수
     */
    HttpUtil.prototype.init = function() {
        // 기본 요청 인터셉터 등록
        this.addRequestInterceptor(this.defaultRequestInterceptor.bind(this));

        // 기본 응답 인터셉터 등록
        this.addResponseInterceptor(this.defaultResponseInterceptor.bind(this));

        // 기본 에러 인터셉터 등록
        this.addErrorInterceptor(this.defaultErrorInterceptor.bind(this));

        // 로딩바 함수 확인 및 초기화
        this.initLoaderFunction();

        // 글로벌 에러 핸들러 등록
        this.initGlobalErrorHandler();

        this.logger.info('HttpUtil initialized', {
            debug: this.debug,
            version: '1.0.0'
        });
    };

    /**
     * 로딩바 함수 초기화
     */
    HttpUtil.prototype.initLoaderFunction = function() {
        var self = this;

        // 강제로 HttpUtil 자체 로딩바 사용 (기존 loader_obj 무시)
        console.log('[HttpUtil] 로딩바 초기화 - 새로운 SVG 로더 사용');

        this.showLoader = function() {
            console.log('[HttpUtil] showLoader 호출 - SVG 로더 표시');
            self.showHttpUtilLoader();
        };
        this.hideLoader = function() {
            console.log('[HttpUtil] hideLoader 호출 - SVG 로더 숨김');
            self.hideHttpUtilLoader();
        };
    };

    /**
     * HttpUtil 전용 로딩바 표시
     */
    HttpUtil.prototype.showHttpUtilLoader = function() {
        console.log('[HttpUtil] showHttpUtilLoader 함수 실행됨!');

        // 기존 로딩바가 있으면 제거
        this.hideHttpUtilLoader();

        // 기존 kep_sub_loader가 있으면 제거
        var existingKepLoader = document.querySelector('.kep_sub_loader');
        if (existingKepLoader) {
            console.log('[HttpUtil] 기존 kep_sub_loader 발견, 제거함');
            existingKepLoader.parentNode.removeChild(existingKepLoader);
        }
        var existingKepOverlay = document.querySelector('.kep_ajax_loader');
        if (existingKepOverlay) {
            console.log('[HttpUtil] 기존 kep_ajax_loader 발견, 제거함');
            existingKepOverlay.parentNode.removeChild(existingKepOverlay);
        }

        // 오버레이 생성
        var overlay = document.createElement('div');
        overlay.id = 'httputil_loader_overlay';
        overlay.style.cssText = [
            'position: fixed',
            'top: 0',
            'left: 0',
            'width: 100%',
            'height: 100%',
            'background: rgba(0, 0, 0, 0.5)',
            'z-index: 99999',
            'display: flex',
            'justify-content: center',
            'align-items: center',
            'flex-direction: column'
        ].join(';');

        // 로더 컨테이너 생성
        var loaderContainer = document.createElement('div');
        loaderContainer.id = 'httputil_loader_container';
        loaderContainer.style.cssText = [
            'background: white',
            'padding: 30px',
            'border-radius: 10px',
            'box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3)',
            'text-align: center'
        ].join(';');

        // SVG 로딩 이미지
        var loadingImg = document.createElement('img');
        loadingImg.src = '/resources/libs/ibsheet7/js/DeepBlue/loading.svg';
        loadingImg.alt = '로딩중';
        loadingImg.style.cssText = [
            'width: 150px',
            'height: 100px',
            'margin-bottom: 15px'
        ].join(';');

        // 로딩 텍스트
        var loadingText = document.createElement('div');
        loadingText.style.cssText = [
            'color: #333',
            'font-size: 16px',
            'font-weight: bold',
            'margin-top: 15px'
        ].join(';');
//        loadingText.textContent = '조회중...';
        loadingText.textContent = '';
        // 닫기 버튼 제거 (필요시 나중에 추가)

        // 요소 조립
        loaderContainer.appendChild(loadingImg);
        loaderContainer.appendChild(loadingText);
        overlay.appendChild(loaderContainer);

        // DOM에 추가
        document.body.appendChild(overlay);
    };

    /**
     * HttpUtil 전용 로딩바 숨김
     */
    HttpUtil.prototype.hideHttpUtilLoader = function() {
        console.log('[HttpUtil] hideHttpUtilLoader 함수 실행됨!');

        // 로딩바 요소 제거
        var overlay = document.getElementById('httputil_loader_overlay');
        if (overlay && overlay.parentNode) {
            overlay.parentNode.removeChild(overlay);
        }
    };

    /**
     * 요청 인터셉터 추가
     */
    HttpUtil.prototype.addRequestInterceptor = function(interceptor) {
        this.requestInterceptors.push(interceptor);
    };

    /**
     * 응답 인터셉터 추가
     */
    HttpUtil.prototype.addResponseInterceptor = function(interceptor) {
        this.responseInterceptors.push(interceptor);
    };

    /**
     * 에러 인터셉터 추가
     */
    HttpUtil.prototype.addErrorInterceptor = function(interceptor) {
        this.errorInterceptors.push(interceptor);
    };

    /**
     * 로거 생성
     */
    HttpUtil.prototype.createLogger = function(level) {
        var self = this;
        return function(message, data) {
            if (!self.debug && level === 'DEBUG') return;

            var timestamp = new Date().toISOString();
            var logEntry = {
                timestamp: timestamp,
                level: level,
                message: message,
                data: data || null
            };

            // 콘솔 출력
            var consoleMethod = level === 'ERROR' ? 'error' :
                               level === 'WARN' ? 'warn' :
                               level === 'DEBUG' ? 'debug' : 'log';

            if (console[consoleMethod]) {
                console[consoleMethod]('[HttpUtil:' + level + ']', message, data || '');
            }

            // 로컬 스토리지에 에러 로그 저장 (에러만)
            if (level === 'ERROR') {
                self.saveErrorLog(logEntry);
            }
        };
    };

    /**
     * 민감한 정보 마스킹 처리
     */
    HttpUtil.prototype.maskSensitiveData = function(data) {
        if (!data) return data;

        var sensitiveFields = ['password', 'passwd', 'pwd', 'token', 'accessToken', 'refreshToken', 'secret', 'apiKey', 'authorization'];
        var masked = {};

        try {
            // 객체 복사 및 민감 필드 마스킹
            for (var key in data) {
                if (data.hasOwnProperty(key)) {
                    var lowerKey = key.toLowerCase();
                    var isSensitive = false;

                    for (var i = 0; i < sensitiveFields.length; i++) {
                        if (lowerKey.indexOf(sensitiveFields[i].toLowerCase()) !== -1) {
                            isSensitive = true;
                            break;
                        }
                    }

                    masked[key] = isSensitive ? '***' : data[key];
                }
            }
            return masked;
        } catch (e) {
            return data;
        }
    };

    /**
     * FormData 내용 추출
     */
    HttpUtil.prototype.extractFormDataContent = function(formData) {
        if (!formData || !(formData instanceof FormData)) {
            return formData;
        }

        var extracted = {};
        try {
            // FormData.entries()를 사용하여 내용 추출
            var iterator = formData.entries();
            var entry = iterator.next();

            while (!entry.done) {
                var key = entry.value[0];
                var value = entry.value[1];

                // 파일 객체인 경우
                if (value instanceof File) {
                    extracted[key] = {
                        type: 'File',
                        name: value.name,
                        size: value.size,
                        mimeType: value.type
                    };
                } else {
                    extracted[key] = value;
                }

                entry = iterator.next();
            }

            return this.maskSensitiveData(extracted);
        } catch (e) {
            return '[FormData - 내용 추출 실패]';
        }
    };

    /**
     * 상세 박스 스타일 로그 포맷팅
     */
    HttpUtil.prototype.formatDetailedLog = function(type, data) {
        var border = '═══════════════════════════════════════════════════════════════';
        var lines = [];

        lines.push('\n╔' + border);

        // 헤더 라인
        if (type === 'request') {
            lines.push('║ 🚀 [HTTP Request] ' + new Date().toISOString());
        } else if (type === 'success') {
            lines.push('║ ✅ [HTTP Success] ' + new Date().toISOString());
        } else if (type === 'error') {
            lines.push('║ ❌ [HTTP Error] ' + new Date().toISOString());
        }

        lines.push('╠' + border);

        // 데이터 라인들
        for (var key in data) {
            if (data.hasOwnProperty(key)) {
                var value = data[key];
                var displayValue = '';

                // 값 타입에 따른 처리
                if (value === null || value === undefined) {
                    displayValue = 'null';
                } else if (typeof value === 'object') {
                    try {
                        displayValue = JSON.stringify(value, null, 2).replace(/\n/g, '\n║           ');
                    } catch (e) {
                        displayValue = '[Object]';
                    }
                } else {
                    displayValue = String(value);
                }

                // 키 패딩 (10자리 고정)
                var paddedKey = (key + '          ').substring(0, 10);
                lines.push('║ ' + paddedKey + ': ' + displayValue);
            }
        }

        lines.push('╚' + border);

        return lines.join('\n');
    };

    /**
     * 에러 로그 저장
     */
    HttpUtil.prototype.saveErrorLog = function(logEntry) {
        try {
            var existingLogs = JSON.parse(localStorage.getItem('httputil_error_logs') || '[]');
            existingLogs.push(logEntry);

            // 최대 50개까지만 저장
            if (existingLogs.length > 50) {
                existingLogs = existingLogs.slice(-50);
            }

            localStorage.setItem('httputil_error_logs', JSON.stringify(existingLogs));
        } catch (e) {
            // localStorage 사용 불가 시 무시
        }
    };

    /**
     * 글로벌 에러 핸들러 초기화
     */
    HttpUtil.prototype.initGlobalErrorHandler = function() {
        var self = this;

        // 전역 unhandled promise rejection 처리
        if (window.addEventListener) {
            window.addEventListener('unhandledrejection', function(event) {
                self.logger.error('Unhandled Promise Rejection', {
                    reason: event.reason,
                    promise: event.promise
                });
            });
        }
    };

    /**
     * 기본 요청 인터셉터
     */
    HttpUtil.prototype.defaultRequestInterceptor = function(config) {
        // 요청 시작 시간 기록
        config.startTime = Date.now();

        // 메트릭 업데이트
        this.metrics.totalRequests++;

        // 로딩바 표시 (명시적으로 showLoader: true로 설정된 경우에만 표시)
        console.log('[HttpUtil] defaultRequestInterceptor: showLoader 설정값 =', config.showLoader);
        if (config.showLoader === true) {
            console.log('[HttpUtil] 로딩바를 표시합니다.');
            this.showLoader();
        } else {
            console.log('[HttpUtil] 로딩바 표시를 건너뛁니다. (showLoader =', config.showLoader, ')');
        }

        // 요청 로깅 (상세 로깅 모드가 활성화된 경우)
        if (this.enableDetailedLogging || config.enableDetailedLogging) {
            var requestData = config.data;

            // FormData인 경우 내용 추출
            if (requestData instanceof FormData) {
                requestData = this.extractFormDataContent(requestData);
            }
            // 일반 객체인 경우 민감 정보 마스킹
            else if (typeof requestData === 'object' && requestData !== null) {
                requestData = this.maskSensitiveData(requestData);
            }

            var logData = {
                Method: config.method,
                Endpoint: config.url,
                Parameters: requestData
            };

            console.log(this.formatDetailedLog('request', logData));
        } else {
            // 기존 debug 로깅
            this.logger.debug('Request started', {
                url: config.url,
                method: config.method,
                data: config.data,
                headers: config.headers
            });
        }

        return config;
    };

    /**
     * 기본 응답 인터셉터
     */
    HttpUtil.prototype.defaultResponseInterceptor = function(response, config) {
        // 응답 시간 계산
        var responseTime = Date.now() - config.startTime;
        this.updateMetrics(responseTime, true);

        // 로딩바 숨김 (명시적으로 showLoader: true로 설정된 경우에만 숨김)
        if (config.showLoader === true) {
            this.hideLoader();
        }

        // 응답 로깅 (상세 로깅 모드가 활성화된 경우)
        if (this.enableDetailedLogging || config.enableDetailedLogging) {
            var responseData = response.data;

            // 응답 데이터 민감 정보 마스킹
            if (typeof responseData === 'object' && responseData !== null) {
                responseData = this.maskSensitiveData(responseData);
            }

            var logData = {
                Endpoint: config.url,
                Duration: responseTime + 'ms',
                Size: this.getDataSize(response.data),
                Status: response.status + ' ' + response.statusText,
                Response: responseData
            };

            console.log(this.formatDetailedLog('success', logData));
        } else {
            // 기존 debug 로깅
            this.logger.debug('Response received', {
                url: config.url,
                status: response.status,
                responseTime: responseTime + 'ms',
                dataSize: this.getDataSize(response.data)
            });
        }

        return response;
    };

    /**
     * 기본 에러 인터셉터
     */
    HttpUtil.prototype.defaultErrorInterceptor = function(error, config) {
        // 응답 시간 계산 (에러 시에도)
        var responseTime = config.startTime ? Date.now() - config.startTime : 0;
        this.updateMetrics(responseTime, false);

        // 에러 로깅 (상세 로깅 모드가 활성화된 경우)
        if (this.enableDetailedLogging || config.enableDetailedLogging) {
            var logData = {
                Endpoint: config.url,
                Method: config.method,
                Duration: responseTime + 'ms',
                Status: error.status || 'Error',
                Error: error.message,
                UserMessage: error.userMessage
            };

            console.error(this.formatDetailedLog('error', logData));
        } else {
            // 기존 에러 로깅
            this.logger.error('Request failed', {
                url: config.url,
                method: config.method,
                error: error.message,
                responseTime: responseTime + 'ms',
                userMessage: error.userMessage
            });
        }

        // 메트릭 업데이트
        this.metrics.failedRequests++;

        return error;
    };

    /**
     * 메트릭 업데이트
     */
    HttpUtil.prototype.updateMetrics = function(responseTime, isSuccess) {
        if (isSuccess) {
            this.metrics.successfulRequests++;
        }

        // 응답 시간 히스토리 추가
        this.metrics.responseTimeHistory.push(responseTime);

        // 최대 100개 응답시간만 보관
        if (this.metrics.responseTimeHistory.length > 100) {
            this.metrics.responseTimeHistory.shift();
        }

        // 평균 응답 시간 계산
        var total = this.metrics.responseTimeHistory.reduce(function(sum, time) {
            return sum + time;
        }, 0);
        this.metrics.averageResponseTime = Math.round(total / this.metrics.responseTimeHistory.length);
    };

    /**
     * 데이터 크기 계산
     */
    HttpUtil.prototype.getDataSize = function(data) {
        if (!data) return '0B';

        var size;
        if (typeof data === 'string') {
            size = data.length;
        } else {
            try {
                size = JSON.stringify(data).length;
            } catch (e) {
                return 'Unknown';
            }
        }

        if (size < 1024) return size + 'B';
        if (size < 1024 * 1024) return Math.round(size / 1024) + 'KB';
        return Math.round(size / (1024 * 1024)) + 'MB';
    };

    /**
     * 메트릭 조회
     */
    HttpUtil.prototype.getMetrics = function() {
        var successRate = this.metrics.totalRequests > 0 ?
            Math.round((this.metrics.successfulRequests / this.metrics.totalRequests) * 100) : 0;

        return {
            totalRequests: this.metrics.totalRequests,
            successfulRequests: this.metrics.successfulRequests,
            failedRequests: this.metrics.failedRequests,
            successRate: successRate + '%',
            averageResponseTime: this.metrics.averageResponseTime + 'ms'
        };
    };

    /**
     * 에러 로그 조회
     */
    HttpUtil.prototype.getErrorLogs = function() {
        try {
            return JSON.parse(localStorage.getItem('httputil_error_logs') || '[]');
        } catch (e) {
            return [];
        }
    };

    /**
     * 메트릭 초기화
     */
    HttpUtil.prototype.resetMetrics = function() {
        this.metrics = {
            totalRequests: 0,
            successfulRequests: 0,
            failedRequests: 0,
            averageResponseTime: 0,
            responseTimeHistory: []
        };
        this.logger.info('Metrics reset');
    };

    /**
     * 객체를 FormData로 변환
     */
    HttpUtil.prototype.objectToFormData = function(obj) {
        if (!obj) return '';

        var formData = [];
        for (var key in obj) {
            if (obj.hasOwnProperty(key)) {
                var value = obj[key];
                if (value !== null && value !== undefined) {
                    formData.push(encodeURIComponent(key) + '=' + encodeURIComponent(value));
                }
            }
        }
        return formData.join('&');
    };

    /**
     * 요청 설정 병합
     */
    HttpUtil.prototype.mergeConfig = function(config, overrides) {
        var merged = {};

        // 기본값 복사
        for (var key in this.defaults) {
            if (this.defaults.hasOwnProperty(key)) {
                merged[key] = this.defaults[key];
            }
        }

        // config 복사
        for (var key in config) {
            if (config.hasOwnProperty(key)) {
                merged[key] = config[key];
            }
        }

        // overrides 복사
        if (overrides) {
            for (var key in overrides) {
                if (overrides.hasOwnProperty(key)) {
                    merged[key] = overrides[key];
                }
            }
        }

        // 헤더 병합
        if (config.headers || overrides && overrides.headers) {
            merged.headers = {};

            // 기본 헤더
            for (var key in this.defaults.headers) {
                merged.headers[key] = this.defaults.headers[key];
            }

            // config 헤더
            if (config.headers) {
                for (var key in config.headers) {
                    merged.headers[key] = config.headers[key];
                }
            }

            // overrides 헤더
            if (overrides && overrides.headers) {
                for (var key in overrides.headers) {
                    merged.headers[key] = overrides.headers[key];
                }
            }
        }

        return merged;
    };

    /**
     * 핵심 요청 함수
     */
    HttpUtil.prototype.request = function(config) {
        var self = this;

        // 요청 인터셉터 실행
        for (var i = 0; i < this.requestInterceptors.length; i++) {
            config = this.requestInterceptors[i](config) || config;
        }

        // 타임아웃 처리를 위한 AbortController 대신 setTimeout 사용 (IE 호환성)
        var timeoutId;
        var timeoutPromise = new Promise(function(resolve, reject) {
            timeoutId = setTimeout(function() {
                reject(new Error('Request timeout after ' + config.timeout + 'ms'));
            }, config.timeout);
        });

        // 실제 fetch 요청
        var fetchOptions = {
            method: config.method,
            headers: config.headers,
            credentials: config.credentials
        };

        // POST 데이터 처리
        if (config.data && (config.method === 'POST' || config.method === 'PUT')) {
            if (typeof config.data === 'string') {
                fetchOptions.body = config.data;
            } else {
                fetchOptions.body = this.objectToFormData(config.data);
            }
        }

        var fetchPromise = fetch(config.url, fetchOptions)
            .then(function(response) {
                clearTimeout(timeoutId);

                if (!response.ok) {
                    throw new Error('HTTP Error: ' + response.status + ' ' + response.statusText);
                }

                // Content-Type에 따른 응답 파싱
                var contentType = response.headers.get('content-type') || '';
                if (contentType.indexOf('application/json') !== -1) {
                    return response.json().then(function(data) {
                        return {
                            status: response.status,
                            statusText: response.statusText,
                            headers: response.headers,
                            data: data,
                            response: response
                        };
                    });
                } else {
                    return response.text().then(function(text) {
                        return {
                            status: response.status,
                            statusText: response.statusText,
                            headers: response.headers,
                            data: text,
                            response: response
                        };
                    });
                }
            })
            .then(function(result) {
                // 응답 인터셉터 실행
                for (var i = 0; i < self.responseInterceptors.length; i++) {
                    result = self.responseInterceptors[i](result, config) || result;
                }
                return result;
            })
            .catch(function(error) {
                clearTimeout(timeoutId);

                // 로딩바 숨김 (에러 시에도)
                if (config.showLoader !== false) {
                    self.hideLoader();
                }

                // 사용자 친화적 에러 메시지 생성
                var userMessage = self.getUserFriendlyErrorMessage(error);
                error.userMessage = userMessage;

                // 에러 인터셉터 실행
                for (var i = 0; i < self.errorInterceptors.length; i++) {
                    error = self.errorInterceptors[i](error, config) || error;
                }

                // 공통 에러 처리
                self.handleCommonError(error, config);

                // 화면별 에러 콜백 실행
                if (config.onError && typeof config.onError === 'function') {
                    try {
                        config.onError(error, config);
                    } catch (callbackError) {
                        self.logger.error('Error callback failed', {
                            originalError: error.message,
                            callbackError: callbackError.message
                        });
                    }
                }

                throw error;
            });

        // 타임아웃과 fetch 중 먼저 완료되는 것 반환
        return Promise.race([fetchPromise, timeoutPromise]);
    };

    /**
     * 에러 메시지 생성
     */
    HttpUtil.prototype.getUserFriendlyErrorMessage = function(error) {
        var message = error.message || '';

        if (message.indexOf('timeout') !== -1) {
            return '요청 시간이 초과되었습니다. 잠시 후 다시 시도해주세요.';
        } else if (message.indexOf('Network Error') !== -1 || message.indexOf('Failed to fetch') !== -1) {
            return '네트워크 연결을 확인해주세요.';
        } else if (message.indexOf('HTTP Error: 500') !== -1) {
            return '서버 내부 오류가 발생했습니다. 관리자에게 문의해주세요.';
        } else if (message.indexOf('HTTP Error: 404') !== -1) {
            return '요청한 페이지를 찾을 수 없습니다.';
        } else if (message.indexOf('HTTP Error: 403') !== -1) {
            return '접근 권한이 없습니다.';
        } else {
            return '데이터 로드 중 오류가 발생했습니다.';
        }
    };

    /**
     * 공통 에러 처리
     */
    HttpUtil.prototype.handleCommonError = function(error, config) {
        // 기본 alert 표시 (showDefaultAlert가 false가 아닌 경우)
        if (config.showDefaultAlert !== false) {
            // onError 콜백이 있으면 기본 alert는 표시하지 않음
            if (!config.onError) {
                alert(error.userMessage || '오류가 발생했습니다.');
            }
        }

        // 개발 모드에서 상세 에러 로깅
        if (this.debug) {
            console.group('HttpUtil Error Details');
            console.error('URL:', config.url);
            console.error('Method:', config.method);
            console.error('Error:', error.message);
            console.error('User Message:', error.userMessage);
            if (error.stack) {
                console.error('Stack:', error.stack);
            }
            console.groupEnd();
        }
    };

    /**
     * GET 요청
     */
    HttpUtil.prototype.get = function(url, params, options) {
        options = options || {};

        // URL에 쿼리 파라미터 추가
        if (params) {
            var queryString = this.objectToFormData(params);
            if (queryString) {
                url += (url.indexOf('?') === -1 ? '?' : '&') + queryString;
            }
        }

        var config = this.mergeConfig({
            url: url,
            method: 'GET'
        }, options);

        return this.request(config);
    };

    /**
     * POST 요청
     */
    HttpUtil.prototype.post = function(url, data, options) {
        options = options || {};

        console.log('[HttpUtil] POST 요청 options:', options);
        console.log('[HttpUtil] POST 요청 showLoader 설정:', options.showLoader);

        var config = this.mergeConfig({
            url: url,
            method: 'POST',
            data: data
        }, options);

        console.log('[HttpUtil] POST 병합된 config:', config);
        console.log('[HttpUtil] POST 병합된 showLoader:', config.showLoader);

        return this.request(config);
    };

    /**
     * FormData POST 요청 (파일 업로드용)
     * FormData 객체를 전송할 때는 Content-Type을 설정하지 않아야 함
     * (브라우저가 자동으로 multipart/form-data와 boundary를 설정)
     */
    HttpUtil.prototype.postFormData = function(url, formData, options) {
        options = options || {};

        console.log('[HttpUtil] postFormData 요청 options:', options);
        console.log('[HttpUtil] postFormData 요청 showLoader 설정:', options.showLoader);

        // FormData 전송을 위한 특별한 설정
        var config = this.mergeConfig({
            url: url,
            method: 'POST'
        }, options);

        // FormData는 헤더의 Content-Type을 제거해야 함 (브라우저가 자동 설정)
        if (config.headers && config.headers['Content-Type']) {
            delete config.headers['Content-Type'];
        }

        console.log('[HttpUtil] postFormData 병합된 config:', config);
        console.log('[HttpUtil] postFormData 병합된 showLoader:', config.showLoader);

        // FormData를 직접 body에 전달하기 위한 특별 처리
        return this.requestWithFormData(config, formData);
    };

    /**
     * FormData를 처리하는 특별한 요청 함수
     */
    HttpUtil.prototype.requestWithFormData = function(config, formData) {
        var self = this;

        // 요청 인터셉터 실행
        for (var i = 0; i < this.requestInterceptors.length; i++) {
            config = this.requestInterceptors[i](config) || config;
        }

        // 타임아웃 처리
        var timeoutId;
        var timeoutPromise = new Promise(function(resolve, reject) {
            timeoutId = setTimeout(function() {
                reject(new Error('Request timeout after ' + config.timeout + 'ms'));
            }, config.timeout);
        });

        // fetch 옵션 구성
        var fetchOptions = {
            method: config.method,
            headers: config.headers,
            credentials: config.credentials,
            body: formData  // FormData 객체를 직접 전달
        };

        var fetchPromise = fetch(config.url, fetchOptions)
            .then(function(response) {
                clearTimeout(timeoutId);

                if (!response.ok) {
                    throw new Error('HTTP Error: ' + response.status + ' ' + response.statusText);
                }

                // Content-Type에 따른 응답 파싱
                var contentType = response.headers.get('content-type') || '';
                if (contentType.indexOf('application/json') !== -1) {
                    return response.json().then(function(data) {
                        return {
                            status: response.status,
                            statusText: response.statusText,
                            headers: response.headers,
                            data: data,
                            response: response
                        };
                    });
                } else {
                    return response.text().then(function(text) {
                        return {
                            status: response.status,
                            statusText: response.statusText,
                            headers: response.headers,
                            data: text,
                            response: response
                        };
                    });
                }
            })
            .then(function(result) {
                // 응답 인터셉터 실행
                for (var i = 0; i < self.responseInterceptors.length; i++) {
                    result = self.responseInterceptors[i](result, config) || result;
                }
                return result;
            })
            .catch(function(error) {
                clearTimeout(timeoutId);

                // 로딩바 숨김 (에러 시에도)
                if (config.showLoader !== false) {
                    self.hideLoader();
                }

                //  에러 메시지 생성
                var userMessage = self.getUserFriendlyErrorMessage(error);
                error.userMessage = userMessage;

                // 에러 인터셉터 실행
                for (var i = 0; i < self.errorInterceptors.length; i++) {
                    error = self.errorInterceptors[i](error, config) || error;
                }

                // 공통 에러 처리
                self.handleCommonError(error, config);

                // 화면별 에러 콜백 실행
                if (config.onError && typeof config.onError === 'function') {
                    try {
                        config.onError(error, config);
                    } catch (callbackError) {
                        self.logger.error('Error callback failed', {
                            originalError: error.message,
                            callbackError: callbackError.message
                        });
                    }
                }

                throw error;
            });

        // 타임아웃과 fetch 중 먼저 완료되는 것 반환
        return Promise.race([fetchPromise, timeoutPromise]);
    };

    /**
     * 전역 설정 변경
     */
    HttpUtil.prototype.setDefaults = function(newDefaults) {
        for (var key in newDefaults) {
            if (newDefaults.hasOwnProperty(key)) {
                this.defaults[key] = newDefaults[key];
            }
        }
    };

    /**
     * 상세 로깅 모드 토글
     * @param {Boolean} enabled - true: 상세 로깅 활성화, false: 비활성화
     *
     * 사용 예시:
     * HttpUtil.setDetailedLogging(true);  // 전역 활성화
     * HttpUtil.setDetailedLogging(false); // 전역 비활성화
     */
    HttpUtil.prototype.setDetailedLogging = function(enabled) {
        this.enableDetailedLogging = !!enabled;
        console.log('[HttpUtil] 상세 로깅 모드: ' + (this.enableDetailedLogging ? '활성화됨 ✅' : '비활성화됨 ❌'));
    };

    // 전역 인스턴스 생성
    var httpUtil = new HttpUtil();

    // 전역 객체에 등록
    window.HttpUtil = httpUtil;

    // CommonJS/AMD 지원
    if (typeof module !== 'undefined' && module.exports) {
        module.exports = httpUtil;
    }

})(window);

/**
 * 사용 예시:
 *
 * // 1. 기본 사용법 (공통 에러 처리)
 * HttpUtil.post('/api/data', {id: 123})
 *     .then(function(response) {
 *         console.log(response.data);
 *     });
 * // 에러 시 자동으로 사용자 친화적 메시지 alert 표시
 *
 * // 2. 화면별 에러 처리 (권장)
 * HttpUtil.post('/api/save', data, {
 *     onError: function(error, config) {
 *         // 화면별 특화 처리
 *         document.getElementById('errorDiv').innerHTML = error.userMessage;
 *         hideLoadingSpinner();
 *     }
 * })
 * .then(function(response) {
 *     // 성공 처리
 * });
 *
 * // 3. 기본 alert 비활성화
 * HttpUtil.post('/api/save', data, {
 *     showDefaultAlert: false,
 *     onError: function(error) {
 *         // 커스텀 에러 처리만 실행
 *         showCustomErrorModal(error.userMessage);
 *     }
 * });
 *
 * // 4. 기존 방식과의 호환성
 * HttpUtil.post('/api/save', data)
 *     .then(function(response) {
 *         // 성공 처리
 *     })
 *     .catch(function(error) {
 *         // 추가 에러 처리 (공통 처리 후 실행됨)
 *         logErrorToServer(error);
 *     });
 *
 * // 5. 복합 옵션 사용
 * HttpUtil.post('/api/save', data, {
 *     timeout: 15000,
 *     showLoader: false,
 *     showDefaultAlert: false,
 *     onError: function(error, config) {
 *         if (error.message.indexOf('timeout') !== -1) {
 *             showRetryDialog();
 *         } else {
 *             showErrorNotification(error.userMessage);
 *         }
 *     },
 *     headers: {
 *         'Authorization': 'Bearer token123'
 *     }
 * });
 *
 * // 6. 성능 메트릭 조회
 * var metrics = HttpUtil.getMetrics();
 * console.log('Success Rate:', metrics.successRate);
 *
 * // 7. 에러 로그 조회
 * var errorLogs = HttpUtil.getErrorLogs();
 * console.log('Recent errors:', errorLogs.slice(-5));
 */