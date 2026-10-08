/**
 * IBSheetDatePicker - IBSheet 컬럼에 달력 기능을 추가하는 모듈
 * DatePicker.js 기반 구현 (flatpickr 의존성 제거)
 *
 * @version 2.0
 * @author MRO Development Team
 */

(function(window) {
    'use strict';

    /**
     * IBSheetDatePicker 생성자
     * @param {Object} ibsheet - IBSheet 인스턴스 또는 시트ID
     * @param {Object} config - 설정 객체
     */
    function IBSheetDatePicker(ibsheet, config) {
        // IBSheet 인스턴스 저장 (문자열인 경우 window[sheetId]로 접근)
        this.ibsheet = typeof ibsheet === 'string' ? window[ibsheet] : ibsheet;

        if (!this.ibsheet) {
            console.error('[IBSheetDatePicker] IBSheet 인스턴스를 찾을 수 없습니다:', ibsheet);
            return;
        }

        this.config = this._mergeConfig(config);
        this.activePickers = {}; // 활성화된 달력 인스턴스 관리

        // 자동 초기화
        if (this.config.autoInit) {
            this.init();
        }
    }

    /**
     * 기본 설정 병합
     * @private
     */
    IBSheetDatePicker.prototype._mergeConfig = function(userConfig) {
        var defaultConfig = {
            columns: [],                    // 달력을 적용할 컬럼명 배열 (예: ['PROGRESS_DATE', 'START_DATE'])
            dateFormat: '.',                // 날짜 구분자: '.', '/', '-'
            displayFormat: 'YYYY.MM.DD',    // 화면 표시 형식
            saveFormat: 'YYYY.MM.DD',       // 저장 형식
            locale: 'ko',                   // 언어 설정
            autoClose: false,               // 날짜 선택 시 자동 닫기
            position: 'auto',               // 달력 위치
            yearFirst: true,                // 년도를 월 앞에 표시 (DatePicker.js는 기본적으로 년도 우선)
            autoInit: false,                // 자동 초기화
            onChange: null,                 // 날짜 변경 콜백
            onOpen: null,                   // 달력 열림 콜백
            onClose: null                   // 달력 닫힘 콜백
        };

        var merged = {};
        for (var key in defaultConfig) {
            if (defaultConfig.hasOwnProperty(key)) {
                merged[key] = userConfig && userConfig.hasOwnProperty(key) ?
                              userConfig[key] : defaultConfig[key];
            }
        }
        return merged;
    };

    /**
     * 달력 초기화
     */
    IBSheetDatePicker.prototype.init = function() {
        if (!this.ibsheet) {
            console.error('[IBSheetDatePicker] IBSheet 인스턴스가 필요합니다.');
            return;
        }

        if (!window.DatePicker) {
            console.error('[IBSheetDatePicker] DatePicker 클래스가 로드되지 않았습니다.');
            return;
        }

        // 각 컬럼에 대해 클릭 이벤트 등록
        var self = this;
        for (var i = 0; i < this.config.columns.length; i++) {
            this._attachDatePickerToColumn(this.config.columns[i]);
        }

        console.log('[IBSheetDatePicker] 초기화 완료 - 컬럼:', this.config.columns);
    };

    /**
     * 특정 컬럼에 달력 기능 추가
     * @private
     */
    IBSheetDatePicker.prototype._attachDatePickerToColumn = function(columnName) {
        var self = this;
        var sheet = this.ibsheet;

        // IBSheet ID 가져오기
        var sheetId = sheet.id || this._getSheetId();

        if (!sheetId) {
            console.error('[IBSheetDatePicker] IBSheet ID를 찾을 수 없습니다.');
            return;
        }

        console.log('[IBSheetDatePicker] 컬럼 이벤트 등록:', columnName, ', Sheet ID:', sheetId);

        // 컬럼별 콜백 저장소 초기화
        if (!this.columnCallbacks) {
            this.columnCallbacks = {};
        }

        // 컬럼별 콜백 등록
        if (!this.columnCallbacks[columnName]) {
            this.columnCallbacks[columnName] = [];
        }

        // 달력 핸들러 추가
        this.columnCallbacks[columnName].push(function(row, col, value, cellX, cellY, cellW, cellH) {
            var currentValue = sheet.GetCellValue(row, columnName);

            console.log('[IBSheetDatePicker] 셀 클릭 - 컬럼:', columnName, ', 행:', row, ', 값:', currentValue);
            console.log('[IBSheetDatePicker] 셀 위치 정보:', { cellX: cellX, cellY: cellY, cellW: cellW, cellH: cellH });

            // 클릭 위치 정보 저장
            self._lastClickInfo = {
                row: row,
                col: col,
                cellX: cellX,
                cellY: cellY,
                cellW: cellW,
                cellH: cellH
            };

            // 기존 달력이 열려있으면 닫기
            self._closeAllPickers();

            // 셀 위치 계산
            var cellRect = self._getCellRect(sheet, row, col);

            // 임시 input 생성 (셀 위치 정보 전달)
            var tempInput = self._createTempInput(row, col, currentValue, cellRect);
            document.body.appendChild(tempInput);

            // DatePicker 초기화
            var dpInstance = self._createDatePicker(tempInput, row, columnName, currentValue, cellRect);

            // 활성 달력 저장
            var pickerId = columnName + '_' + row;
            self.activePickers[pickerId] = {
                instance: dpInstance,
                input: tempInput,
                row: row,
                column: columnName
            };

            // 달력 열기 - 약간의 지연 후 open
            setTimeout(function() {
                console.log('[IBSheetDatePicker] 달력 열기 시도...');
                try {
                    dpInstance._openCalendar(tempInput);
                    console.log('[IBSheetDatePicker] _openCalendar() 호출 완료');
                } catch (error) {
                    console.error('[IBSheetDatePicker] _openCalendar() 오류:', error);
                }
            }, 100);
        });

        // 전역 이벤트 핸들러 설정 (처음 한 번만)
        if (!this._clickHandlerSetup) {
            this._setupGlobalClickHandler(sheetId);
            this._clickHandlerSetup = true;
        }
    };

    /**
     * IBSheet ID 가져오기 (여러 방법 시도)
     * @private
     */
    IBSheetDatePicker.prototype._getSheetId = function() {
        var sheet = this.ibsheet;

        // 방법 1: sheet.id
        if (sheet.id) return sheet.id;

        // 방법 2: window 객체에서 찾기
        for (var key in window) {
            if (window[key] === sheet) {
                return key;
            }
        }

        return null;
    };

    /**
     * 전역 클릭 이벤트 핸들러 설정 (IBSheetWrapper 방식)
     * @private
     */
    IBSheetDatePicker.prototype._setupGlobalClickHandler = function(sheetId) {
        var self = this;
        var sheet = this.ibsheet;

        var eventName = sheetId + '_OnClick';

        // 기존 핸들러 백업
        var originalHandler = window[eventName];

        // 전역 이벤트 핸들러 등록
        window[eventName] = function(Row, Col, Value, CellX, CellY, CellW, CellH) {
            // 기존 핸들러 호출
            if (originalHandler && typeof originalHandler === 'function') {
                originalHandler.call(this, Row, Col, Value, CellX, CellY, CellW, CellH);
            }

            // 헤더 행 무시
            if (Row < 1) return;

            // 컬럼명 가져오기
            var columnName = sheet.ColSaveName(Col);

            console.log('[IBSheetDatePicker] 글로벌 onClick - Row:', Row, ', Col:', Col, ', Column:', columnName);

            // 해당 컬럼에 등록된 콜백 실행
            if (columnName && self.columnCallbacks && self.columnCallbacks[columnName]) {
                var callbacks = self.columnCallbacks[columnName];
                for (var i = 0; i < callbacks.length; i++) {
                    try {
                        callbacks[i].call(sheet, Row, Col, Value, CellX, CellY, CellW, CellH);
                    } catch (e) {
                        console.error('[IBSheetDatePicker] 콜백 실행 오류:', e);
                    }
                }
            }
        };

        console.log('[IBSheetDatePicker] 전역 클릭 핸들러 등록 완료:', eventName);
    };

    /**
     * 임시 input 엘리먼트 생성
     * @private
     */
    IBSheetDatePicker.prototype._createTempInput = function(row, col, currentValue, cellRect) {
        var tempInput = document.createElement('input');
        tempInput.type = 'text';
        tempInput.id = 'ibsheet_datepicker_' + row + '_' + col + '_' + Date.now();
        tempInput.className = 'ibsheet-calendar-temp';
        tempInput.value = currentValue ? this._formatDateForDisplay(currentValue) : '';
        tempInput.readOnly = true;

        // 셀 위치 정보가 있으면 셀 바로 아래에 배치
        if (cellRect) {
            tempInput.style.cssText = 'position: fixed; left: ' + cellRect.left + 'px; top: ' + cellRect.bottom + 'px; width: 1px; height: 1px; opacity: 0; border: none; padding: 0; margin: 0; z-index: 9999;';
        } else {
            // 셀 위치 정보가 없으면 기본 위치
            tempInput.style.cssText = 'position: absolute; left: 0; top: 0; width: 0; height: 0; opacity: 0; border: none; padding: 0; margin: 0; z-index: -1;';
        }

        return tempInput;
    };

    /**
     * 셀 위치 가져오기
     * @private
     */
    IBSheetDatePicker.prototype._getCellRect = function(sheet, row, col) {
        try {
            // 방법 1: onClick 이벤트에서 전달된 위치 정보 사용 (CellX, CellY, CellW, CellH)
            if (this._lastClickInfo && this._lastClickInfo.row === row && this._lastClickInfo.col === col) {
                var clickInfo = this._lastClickInfo;
                console.log('[IBSheetDatePicker] 클릭 정보 사용:', clickInfo);

                // 달력 위치 오프셋
                // 셀 바로 아래 위치 계산 (셀 하단 + 간격)
                var offsetY = -10;  // 음수 = 위로, 양수 = 아래로

                return {
                    left: clickInfo.cellX,
                    top: clickInfo.cellY + clickInfo.cellH + offsetY,  // 셀 하단 기준
                    bottom: clickInfo.cellY + clickInfo.cellH + offsetY,
                    right: clickInfo.cellX + clickInfo.cellW,
                    width: clickInfo.cellW,
                    height: clickInfo.cellH
                };
            }

            // 방법 2: IBSheet 컨테이너 DOM 요소에서 셀 요소 직접 찾기
            var sheetId = sheet.id || this._getSheetId();
            if (sheetId) {
                // IBSheet의 실제 테이블 구조 탐색
                var sheetDiv = document.getElementById(sheetId + '_div') || document.getElementById(sheetId);
                if (sheetDiv) {
                    // 데이터 셀 찾기 (IBSheet의 DOM 구조에 따라 다를 수 있음)
                    var cellSelector = '[row="' + row + '"][col="' + col + '"]';
                    var cellElement = sheetDiv.querySelector(cellSelector);

                    if (!cellElement) {
                        // 대안: 테이블 구조에서 직접 찾기
                        var tables = sheetDiv.querySelectorAll('table');
                        for (var i = 0; i < tables.length; i++) {
                            var rows = tables[i].querySelectorAll('tr');
                            if (rows[row]) {
                                var cells = rows[row].querySelectorAll('td');
                                if (cells[col]) {
                                    cellElement = cells[col];
                                    break;
                                }
                            }
                        }
                    }

                    if (cellElement) {
                        var rect = cellElement.getBoundingClientRect();
                        console.log('[IBSheetDatePicker] DOM 요소에서 위치 가져옴:', rect);

                        return {
                            left: rect.left,
                            top: rect.top,
                            bottom: rect.bottom,
                            right: rect.right,
                            width: rect.width,
                            height: rect.height
                        };
                    }
                }
            }

            console.warn('[IBSheetDatePicker] 셀 위치를 찾을 수 없습니다');
        } catch (e) {
            console.warn('[IBSheetDatePicker] 셀 위치 가져오기 실패:', e);
        }
        return null;
    };

    /**
     * DatePicker 인스턴스 생성
     * @private
     */
    IBSheetDatePicker.prototype._createDatePicker = function(tempInput, row, columnName, currentValue, cellRect) {
        var self = this;
        var sheet = this.ibsheet;

        // DatePicker 설정
        var dpConfig = {
            type: 'single',
            targetId: tempInput.id,
            dateFormat: this._getDatePickerFormat(),
            locale: this.config.locale,
            defaultDate: currentValue ? this._formatDateForDisplay(currentValue) : 'today',
            onChange: function(data) {
                console.log('[IBSheetDatePicker] onChange 콜백 시작:', data);

                // 선택된 날짜를 설정된 형식으로 변환
                var formattedDate = self._formatDateForSave(data.formatted);

                console.log('[IBSheetDatePicker] 날짜 선택:', data.formatted, '→', formattedDate);
                console.log('[IBSheetDatePicker] IBSheet 정보 - row:', row, ', column:', columnName, ', sheet:', sheet);

                // IBSheet 셀에 값 설정
                try {
                    sheet.SetCellValue(row, columnName, formattedDate);
                    console.log('[IBSheetDatePicker] SetCellValue 성공');

                    // 값이 제대로 설정되었는지 확인
                    var verifyValue = sheet.GetCellValue(row, columnName);
                    console.log('[IBSheetDatePicker] 설정된 값 확인:', verifyValue);
                } catch (e) {
                    console.error('[IBSheetDatePicker] SetCellValue 오류:', e);
                }

                // 사용자 정의 onChange 콜백 호출
                if (self.config.onChange && typeof self.config.onChange === 'function') {
                    self.config.onChange({
                        row: row,
                        column: columnName,
                        value: formattedDate,
                        rawDate: data.date,
                        dateStr: data.formatted
                    });
                }

                // 자동 닫기 옵션이 활성화된 경우
                if (self.config.autoClose) {
                    setTimeout(function() {
                        dpInstance._closeCalendar();
                    }, 100);
                }
            },
            onCalendarClose: function() {
                console.log('[IBSheetDatePicker] 달력 닫힘');

                // 사용자 정의 onClose 콜백 호출
                if (self.config.onClose && typeof self.config.onClose === 'function') {
                    self.config.onClose({
                        row: row,
                        column: columnName
                    });
                }

                // 정리
                setTimeout(function() {
                    if (dpInstance) {
                        // DatePicker cleanup은 내부에서 처리됨
                    }
                    if (tempInput.parentNode) {
                        document.body.removeChild(tempInput);
                    }

                    // 활성 달력 목록에서 제거
                    var pickerId = columnName + '_' + row;
                    delete self.activePickers[pickerId];
                }, 100);
            }
        };

        // DatePicker 인스턴스 생성
        var dpInstance = new DatePicker(dpConfig);
        dpInstance.init();

        // onOpen 콜백 호출
        if (self.config.onOpen && typeof self.config.onOpen === 'function') {
            setTimeout(function() {
                self.config.onOpen({
                    row: row,
                    column: columnName,
                    instance: dpInstance
                });
            }, 150);
        }

        return dpInstance;
    };

    /**
     * DatePicker 날짜 포맷 가져오기
     * @private
     */
    IBSheetDatePicker.prototype._getDatePickerFormat = function() {
        // DatePicker.js는 구분자만 필요 ('.', '/', '-')
        return this.config.dateFormat;
    };

    /**
     * 날짜를 화면 표시 형식으로 변환
     * @private
     */
    IBSheetDatePicker.prototype._formatDateForDisplay = function(dateStr) {
        if (!dateStr) return '';

        // 이미 구분자가 있는 경우
        if (dateStr.indexOf('.') > -1 || dateStr.indexOf('/') > -1 || dateStr.indexOf('-') > -1) {
            // 구분자를 설정된 포맷으로 변경
            return dateStr.replace(/[\.\/-]/g, this.config.dateFormat);
        }

        // YYYYMMDD 형식인 경우
        if (dateStr.length === 8) {
            return dateStr.substring(0, 4) + this.config.dateFormat +
                   dateStr.substring(4, 6) + this.config.dateFormat +
                   dateStr.substring(6, 8);
        }

        return dateStr;
    };

    /**
     * 날짜를 저장 형식으로 변환
     * @private
     */
    IBSheetDatePicker.prototype._formatDateForSave = function(dateStr) {
        if (!dateStr) return '';

        // saveFormat에 따라 변환
        var separator = this.config.saveFormat.indexOf('.') > -1 ? '.' :
                       this.config.saveFormat.indexOf('/') > -1 ? '/' :
                       this.config.saveFormat.indexOf('-') > -1 ? '-' : '';

        if (separator) {
            // 구분자가 있는 형식
            return dateStr.replace(/[\.\/-]/g, separator);
        } else {
            // 구분자 없는 형식 (YYYYMMDD)
            return dateStr.replace(/[\.\/-]/g, '');
        }
    };

    /**
     * 모든 열린 달력 닫기
     */
    IBSheetDatePicker.prototype._closeAllPickers = function() {
        for (var pickerId in this.activePickers) {
            if (this.activePickers.hasOwnProperty(pickerId)) {
                var picker = this.activePickers[pickerId];
                if (picker.instance && picker.instance._closeCalendar) {
                    picker.instance._closeCalendar();
                }
            }
        }
    };

    /**
     * 특정 컬럼에 달력 기능 추가 (동적)
     */
    IBSheetDatePicker.prototype.addColumn = function(columnName) {
        if (this.config.columns.indexOf(columnName) === -1) {
            this.config.columns.push(columnName);
            this._attachDatePickerToColumn(columnName);
            console.log('[IBSheetDatePicker] 컬럼 추가:', columnName);
        }
    };

    /**
     * 특정 컬럼에서 달력 기능 제거
     */
    IBSheetDatePicker.prototype.removeColumn = function(columnName) {
        var index = this.config.columns.indexOf(columnName);
        if (index > -1) {
            this.config.columns.splice(index, 1);
            console.log('[IBSheetDatePicker] 컬럼 제거:', columnName);
        }
    };

    /**
     * 모든 달력 정리
     */
    IBSheetDatePicker.prototype.destroy = function() {
        this._closeAllPickers();
        this.config.columns = [];
        console.log('[IBSheetDatePicker] 정리 완료');
    };

    // 전역 네임스페이스에 등록
    window.IBSheetDatePicker = IBSheetDatePicker;

})(window);
