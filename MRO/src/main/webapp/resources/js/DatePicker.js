/**
 * DatePicker 클래스 - MonthNew.js 기반 자체 구현
 * 특징:
 * - 단일/범위 날짜 선택 지원
 * - MonthNew.js 구현 방식 사용
 * - month.css 스타일 사용
 */

/**
 * DatePicker 클래스 생성자
 * @param {string|object} config - 설정 객체 또는 타겟 요소 ID
 */
function DatePicker(config) {
    // 설정 초기화
    if (typeof config === 'string') {
        this.config = {
            targetId: config,
            type: 'single'
        };
    } else {
        this.config = this._mergeConfig(config);
    }

    // 인스턴스 변수
    this.targetElement = null;
    this.calendar = null;
    this.isInitialized = false;

    // 날짜 관련 변수
    this.today = new Date();
    this.current = new Date();
    this.selectedDate = null;
    this.selectedFromDate = null;
    this.selectedToDate = null;
    this.activeInput = null;

    // 한국어 로케일
    this.weekdaysKR = ['일','월','화','수','목','금','토'];
    this.monthsKR = ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];

    // 달력 DOM 요소들
    this.calendarContainer = null;
    this.weekdaysEl = null;
    this.daysEl = null;
    this.yearSelect = null;
    this.monthSelect = null;
    this.prevBtn = null;
    this.nextBtn = null;

    // 자동 초기화
    if (this.config.autoInit) {
        this.init();
    }
}

/**
 * 프로토타입 메서드 정의
 */
DatePicker.prototype = {

    /**
     * 기본 설정과 사용자 설정 병합
     * @private
     */
    _mergeConfig: function(userConfig) {
        var defaultConfig = {
            targetId: null,
            type: 'single',          // 'single', 'range' 또는 'month'
            fromId: null,
            toId: null,
            dateFormat: '/',         // '.' 또는 '/'
            locale: 'ko',
            defaultDate: 'today',
            minDate: null,
            maxDate: null,
            maxRangeMonths: null,    // 최대 선택 가능 개월 수 (null이면 제한 없음)
            autoInit: false,
            showMonthButtons: false,
            monthButtonsContainer: null,
            onChange: null,
            onReady: null
        };

        var merged = {};
        for (var key in defaultConfig) {
            if (defaultConfig.hasOwnProperty(key)) {
                merged[key] = userConfig.hasOwnProperty(key) ?
                              userConfig[key] : defaultConfig[key];
            }
        }
        return merged;
    },

    /**
     * 날짜 포맷 헬퍼
     * @private
     */
    _pad: function(n) {
        return n < 10 ? ('0' + n) : n;
    },

    /**
     * Date 객체를 표시 형식으로 변환
     * @private
     */
    _formatDate: function(date) {
        if (!date) return '';
        var sep = this.config.dateFormat === '.' ? '.' : '/';

        // month 타입일 경우 년/월만 표시
        if (this.config.type === 'month') {
            return date.getFullYear() + sep +
                   this._pad(date.getMonth() + 1);
        }

        return date.getFullYear() + sep +
               this._pad(date.getMonth() + 1) + sep +
               this._pad(date.getDate());
    },

    /**
     * Date 객체를 YYYYMMDD 형식으로 변환 (month 타입은 YYYYMM)
     * @private
     */
    _formatDatePlain: function(date) {
        if (!date) return '';

        // month 타입일 경우 년/월만 표시 (YYYYMM)
        if (this.config.type === 'month') {
            return '' + date.getFullYear() +
                   this._pad(date.getMonth() + 1);
        }

        return '' + date.getFullYear() +
               this._pad(date.getMonth() + 1) +
               this._pad(date.getDate());
    },

    /**
     * ISO 형식 (YYYY-MM-DD)
     * @private
     */
    _iso: function(date) {
        if (!date) return '';
        return date.getFullYear() + '-' +
               this._pad(date.getMonth() + 1) + '-' +
               this._pad(date.getDate());
    },

    /**
     * 달력 HTML 생성
     * @private
     */
    _createCalendar: function() {
        // 기존 달력이 있으면 재사용
        if (document.getElementById('datepickerCalendar')) {
            this.calendarContainer = document.getElementById('datepickerCalendar');
            this._initCalendarElements();
            this._fillYearMonthSelect();  // 재사용 시에도 연도/월 초기화 필요
            return;
        }

        var calendar = document.createElement('div');
        calendar.id = 'datepickerCalendar';
        calendar.className = 'calendar';
        calendar.style.display = 'none';
        document.body.appendChild(calendar);

        calendar.innerHTML =
            '<div class="calendar-header">' +
                '<button type="button" class="dp-prev-btn"></button>' +
                '<div>' +
                    '<select class="dp-year-select"></select>' +
                    '<select class="dp-month-select"></select>' +
                '</div>' +
                '<button type="button" class="dp-next-btn"></button>' +
            '</div>' +
            '<div class="weekdays dp-weekdays"></div>' +
            '<div class="days dp-days"></div>';

        this.calendarContainer = calendar;
        this._initCalendarElements();
        this._renderWeekdays();
        this._fillYearMonthSelect();
        this._attachCalendarEvents();
    },

    /**
     * 달력 DOM 요소 초기화
     * @private
     */
    _initCalendarElements: function() {
        // 컨테이너 내에서 querySelector로 자식 요소 찾기 (ID 충돌 방지)
        this.weekdaysEl = this.calendarContainer.querySelector('.dp-weekdays');
        this.daysEl = this.calendarContainer.querySelector('.dp-days');
        this.yearSelect = this.calendarContainer.querySelector('.dp-year-select');
        this.monthSelect = this.calendarContainer.querySelector('.dp-month-select');
        this.prevBtn = this.calendarContainer.querySelector('.dp-prev-btn');
        this.nextBtn = this.calendarContainer.querySelector('.dp-next-btn');

        console.log('[DatePicker] 달력 요소 초기화:', {
            yearSelect: !!this.yearSelect,
            monthSelect: !!this.monthSelect,
            weekdaysEl: !!this.weekdaysEl,
            daysEl: !!this.daysEl
        });
    },

    /**
     * 요일 헤더 렌더링
     * @private
     */
    _renderWeekdays: function() {
        if (!this.weekdaysEl) return;
        this.weekdaysEl.innerHTML = this.weekdaysKR.map(function(w) {
            return '<div>' + w + '</div>';
        }).join('');
    },

    /**
     * 년/월 선택 드롭다운 채우기
     * @private
     */
    _fillYearMonthSelect: function() {
        if (!this.yearSelect || !this.monthSelect) {
            console.warn('[DatePicker] yearSelect 또는 monthSelect를 찾을 수 없습니다');
            return;
        }

        var currentYear = this.today.getFullYear();
        var htmlY = '';
        // 설립일자 등 과거 날짜를 위해 범위 확대: 1950년 ~ 현재+10년
        for (var y = 1950; y <= currentYear + 10; y++) {
            htmlY += '<option value="' + y + '">' + y + '</option>';
        }
        this.yearSelect.innerHTML = htmlY;
        console.log('[DatePicker] yearSelect 옵션 설정 완료, 옵션 개수:', this.yearSelect.options.length);

        var htmlM = '';
        for (var m = 0; m < 12; m++) {
            htmlM += '<option value="' + m + '">' + this.monthsKR[m] + '</option>';
        }
        this.monthSelect.innerHTML = htmlM;
        console.log('[DatePicker] monthSelect 옵션 설정 완료, 옵션 개수:', this.monthSelect.options.length);
    },

    /**
     * 달력 이벤트 연결
     * @private
     */
    _attachCalendarEvents: function() {
        var self = this;

        // 이전/다음 월 버튼
        if (this.prevBtn) {
            this.prevBtn.onclick = function(e) {
                e.stopPropagation();
                self.current = new Date(self.current.getFullYear(), self.current.getMonth() - 1, 1);
                self._renderCalendar();
            };
        }

        if (this.nextBtn) {
            this.nextBtn.onclick = function(e) {
                e.stopPropagation();
                self.current = new Date(self.current.getFullYear(), self.current.getMonth() + 1, 1);
                self._renderCalendar();
            };
        }

        // 년/월 선택 드롭다운
        if (this.yearSelect) {
            this.yearSelect.onchange = function() {
                self.current = new Date(parseInt(self.yearSelect.value), self.current.getMonth(), 1);

                // month 타입일 경우 년/월 선택 즉시 값 입력
                if (self.config.type === 'month') {
                    self._onMonthSelect(self.current);
                } else {
                    self._renderCalendar();
                }
            };
        }

        if (this.monthSelect) {
            this.monthSelect.onchange = function() {
                self.current = new Date(self.current.getFullYear(), parseInt(self.monthSelect.value), 1);

                // month 타입일 경우 년/월 선택 즉시 값 입력
                if (self.config.type === 'month') {
                    self._onMonthSelect(self.current);
                } else {
                    self._renderCalendar();
                }
            };
        }

        // 문서 클릭 이벤트 (달력 외부 클릭시 닫기)
        document.addEventListener('click', function(e) {
            if (!self.calendarContainer.contains(e.target) &&
                e.target !== self.activeInput &&
                !self._isCalendarButton(e.target)) {
                self._closeCalendar();
            }
        });
    },

    /**
     * 달력 이벤트 핸들러 재설정
     * (여러 DatePicker 인스턴스가 같은 달력을 공유할 때 현재 인스턴스로 재바인딩)
     * @private
     */
    _reattachCalendarEvents: function() {
        var self = this;

        // 이전/다음 월 버튼 핸들러 재설정
        if (this.prevBtn) {
            this.prevBtn.onclick = function(e) {
                e.stopPropagation();
                self.current = new Date(self.current.getFullYear(), self.current.getMonth() - 1, 1);
                self._renderCalendar();
            };
        }

        if (this.nextBtn) {
            this.nextBtn.onclick = function(e) {
                e.stopPropagation();
                self.current = new Date(self.current.getFullYear(), self.current.getMonth() + 1, 1);
                self._renderCalendar();
            };
        }

        // 년/월 선택 드롭다운 핸들러 재설정
        if (this.yearSelect) {
            this.yearSelect.onchange = function(e) {
                e.stopPropagation();
                self.current = new Date(parseInt(self.yearSelect.value), self.current.getMonth(), 1);
                self._renderCalendar();
            };
        }

        if (this.monthSelect) {
            this.monthSelect.onchange = function(e) {
                e.stopPropagation();
                self.current = new Date(self.current.getFullYear(), parseInt(self.monthSelect.value), 1);
                self._renderCalendar();
            };
        }
    },

    /**
     * 날짜 범위 유효성 검사 (maxRangeMonths 옵션)
     * @private
     * @param {Date} fromDate - 시작 날짜
     * @param {Date} toDate - 종료 날짜
     * @returns {boolean} 유효하면 true, 초과하면 false
     */
    _validateDateRange: function(fromDate, toDate) {
        // maxRangeMonths가 설정되지 않았거나 날짜가 없으면 유효
        if (!this.config.maxRangeMonths || !fromDate || !toDate) {
            return true;
        }


        var maxToDate = new Date(fromDate.getTime());
        maxToDate.setMonth(maxToDate.getMonth() + this.config.maxRangeMonths);

		 if (toDate.getTime() > maxToDate.getTime()) {
            alert('조회 기간은 최대 ' + this.config.maxRangeMonths + '개월을 초과할 수 없습니다.');
            return false;
        }
        return true;
    },

    /**
     * 달력 버튼 클릭 여부 확인
     * @private
     */
    _isCalendarButton: function(element) {
        var parent = element.parentElement;
        for (var i = 0; i < 3 && parent; i++) {
            if (parent.hasAttribute && parent.hasAttribute('data-datepicker')) {
                return true;
            }
            parent = parent.parentElement;
        }
        return false;
    },

    /**
     * 달력 내용 렌더링
     * @private
     */
    _renderCalendar: function() {
        if (!this.activeInput) return;

        var year = this.current.getFullYear();
        var month = this.current.getMonth();

        this.yearSelect.value = year;
        this.monthSelect.value = month;

        // month 타입일 경우 요일 헤더 숨기고 월 버튼 표시
        if (this.config.type === 'month') {
            if (this.weekdaysEl) this.weekdaysEl.style.display = 'none';
            if (this.daysEl) this.daysEl.style.display = '';
            this._renderMonthButtons();
            return; // 날짜 렌더링 생략
        }

        // single/range 타입일 경우 요일 헤더와 날짜 그리드 표시
        if (this.weekdaysEl) this.weekdaysEl.style.display = '';
        if (this.daysEl) this.daysEl.style.display = '';

        if (!this.daysEl) return;

        var firstDay = new Date(year, month, 1);
        var lastDate = new Date(year, month + 1, 0).getDate();
        var prevLastDate = new Date(year, month, 0).getDate();
        var startDayIndex = firstDay.getDay();

        var cells = [];

        // 이전 달 날짜
        for (var i = startDayIndex - 1; i >= 0; i--) {
            var d = prevLastDate - i;
            cells.push({
                day: d,
                other: true,
                date: new Date(year, month - 1, d)
            });
        }

        // 현재 달 날짜
        for (var d = 1; d <= lastDate; d++) {
            cells.push({
                day: d,
                other: false,
                date: new Date(year, month, d)
            });
        }

        // 다음 달 날짜
        var nextMonthDay = 1;
        while (cells.length % 7 !== 0) {
            cells.push({
                day: nextMonthDay,
                other: true,
                date: new Date(year, month + 1, nextMonthDay)
            });
            nextMonthDay++;
        }

        var self = this;
        this.daysEl.innerHTML = cells.map(function(cell) {
            var isToday = self._iso(cell.date) === self._iso(self.today);
            var isSelected = false;

            if (self.config.type === 'single') {
                isSelected = self.selectedDate && self._iso(cell.date) === self._iso(self.selectedDate);
            } else {
                // 범위 선택에서는 from과 to 날짜만 표시 (사이 날짜는 표시하지 않음)
                if (self.selectedFromDate && self.selectedToDate) {
                    var cellTime = cell.date.getTime();
                    var fromTime = self.selectedFromDate.getTime();
                    var toTime = self.selectedToDate.getTime();
                    isSelected = cellTime === fromTime || cellTime === toTime;
                }
            }

            var cls = ['day'];
            if (cell.other) cls.push('other');
            if (isToday) cls.push('today');
            if (isSelected) cls.push('selected');

            return '<div class="' + cls.join(' ') + '" data-date="' + self._iso(cell.date) + '">' + cell.day + '</div>';
        }).join('');

        // 날짜 셀 클릭 이벤트
        var dayCells = this.daysEl.querySelectorAll('.day');
        for (var i = 0; i < dayCells.length; i++) {
            (function(cell) {
                cell.onclick = function() {
                    self._onDateSelect(new Date(cell.getAttribute('data-date')));
                };
            })(dayCells[i]);
        }
    },

    /**
     * 월 버튼 렌더링 (month 타입 전용)
     * @private
     */
    _renderMonthButtons: function() {
        if (!this.daysEl) return;

        var self = this;
        var year = this.current.getFullYear();
        var monthsKR = ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'];

        var buttons = [];
        for (var m = 0; m < 12; m++) {
            var monthDate = new Date(year, m, 1);
            var isSelected = this.selectedDate &&
                            this.selectedDate.getFullYear() === year &&
                            this.selectedDate.getMonth() === m;

            var cls = ['month-btn'];
            if (isSelected) cls.push('selected');

            buttons.push('<button type="button" class="' + cls.join(' ') + '" data-month="' + m + '">' + monthsKR[m] + '</button>');
        }

        this.daysEl.innerHTML = '<div class="month-buttons">' + buttons.join('') + '</div>';

        // 월 버튼 클릭 이벤트
        var monthBtns = this.daysEl.querySelectorAll('.month-btn');
        for (var i = 0; i < monthBtns.length; i++) {
            (function(btn) {
                btn.onclick = function() {
                    var month = parseInt(btn.getAttribute('data-month'));
                    var selectedDate = new Date(self.current.getFullYear(), month, 1);
                    self._onMonthSelect(selectedDate);
                };
            })(monthBtns[i]);
        }
    },

    /**
     * 날짜 선택 처리
     * @private
     */
    _onDateSelect: function(date) {
        console.log('[DatePicker] _onDateSelect 호출, date:', date, ', type:', this.config.type);

        if (this.config.type === 'single') {
            this.selectedDate = date;
            console.log('[DatePicker] selectedDate 설정:', this.selectedDate);

            if (this.activeInput) {
                this.activeInput.value = this._formatDate(date);
                console.log('[DatePicker] activeInput.value 설정:', this.activeInput.value);

                // change 이벤트 발생
                var event = new Event('change', {bubbles: true});
                this.activeInput.dispatchEvent(event);
            } else {
                console.warn('[DatePicker] activeInput이 없습니다');
            }

            // 사용자 콜백
            if (this.config.onChange) {
                console.log('[DatePicker] onChange 콜백 호출 시작');
                this.config.onChange.call(this, {
                    date: date,
                    dateStr: this._formatDate(date),
                    formatted: this._formatDate(date),  // IBSheetDatePicker 호환성
                    type: 'single',
                    instance: this
                });
                console.log('[DatePicker] onChange 콜백 완료');
            } else {
                console.warn('[DatePicker] onChange 콜백이 설정되지 않았습니다');
            }

            this._closeCalendar();
        } else {
            // 범위 선택
            var isFromInput = this.activeInput && this.activeInput.id === this.config.fromId;

            // 기간 유효성 검사를 위한 임시 변수
            var tempFromDate = isFromInput ? date : this.selectedFromDate;
            var tempToDate = isFromInput ? this.selectedToDate : date;

            // maxRangeMonths 유효성 검사
            if (!this._validateDateRange(tempFromDate, tempToDate)) {
                // 유효하지 않으면 달력만 닫고 값 변경하지 않음
                this._closeCalendar();
                return;
            }

            if (isFromInput) {
                this.selectedFromDate = date;
                this.activeInput.value = this._formatDate(date);
            } else {
                this.selectedToDate = date;
                this.activeInput.value = this._formatDate(date);
            }

            // change 이벤트 발생
            if (this.activeInput) {
                var event = new Event('change', {bubbles: true});
                this.activeInput.dispatchEvent(event);
            }

            // 사용자 콜백
            if (this.config.onChange) {
                this.config.onChange.call(this, {
                    fromDate: this.selectedFromDate ? this._formatDate(this.selectedFromDate) : '',
                    toDate: this.selectedToDate ? this._formatDate(this.selectedToDate) : '',
                    type: 'range',
                    changedType: isFromInput ? 'from' : 'to',
                    instance: this
                });
            }

            this._closeCalendar();
        }
    },

    /**
     * 년/월 선택 처리 (month 타입 전용)
     * @private
     */
    _onMonthSelect: function(date) {
        this.selectedDate = date;

        if (this.activeInput) {
            this.activeInput.value = this._formatDate(date);

            // change 이벤트 발생
            var event = new Event('change', {bubbles: true});
            this.activeInput.dispatchEvent(event);
        }

        // 사용자 콜백
        if (this.config.onChange) {
            this.config.onChange.call(this, {
                date: date,
                dateStr: this._formatDate(date),
                formatted: this._formatDate(date),  // IBSheetDatePicker 호환성
                type: 'month',
                instance: this
            });
        }

        this._closeCalendar();
    },

    /**
     * 달력 열기
     * @private
     */
    _openCalendar: function(input) {
        this.activeInput = input;

        var rect = input.getBoundingClientRect();
        this.calendarContainer.style.top = (rect.bottom + window.scrollY + 8) + 'px';
        this.calendarContainer.style.left = (rect.left + window.scrollX) + 'px';
        this.calendarContainer.style.display = 'block';

        // 이벤트 핸들러를 현재 인스턴스로 재설정
        // (여러 DatePicker 인스턴스가 같은 달력을 공유할 때 필요)
        this._reattachCalendarEvents();

        // 현재 입력값 파싱
        var parts = input.value.split(this.config.dateFormat === '.' ? '.' : '/');

        // month 타입: YYYY/MM 형식
        if (this.config.type === 'month' && parts.length === 2) {
            var y = parseInt(parts[0], 10);
            var m = parseInt(parts[1], 10) - 1;
            this.selectedDate = new Date(y, m, 1);
            this.current = new Date(y, m, 1);
        }
        // single/range 타입: YYYY/MM/DD 형식
        else if (parts.length === 3) {
            var y = parseInt(parts[0], 10);
            var m = parseInt(parts[1], 10) - 1;
            var d = parseInt(parts[2], 10);

            if (this.config.type === 'single') {
                this.selectedDate = new Date(y, m, d);
                this.current = new Date(y, m, 1);
            } else {
                if (input.id === this.config.fromId) {
                    this.selectedFromDate = new Date(y, m, d);
                    this.current = new Date(y, m, 1);
                } else {
                    this.selectedToDate = new Date(y, m, d);
                    this.current = new Date(y, m, 1);
                }
            }
        } else {
            if (this.config.type === 'single' || this.config.type === 'month') {
                this.selectedDate = null;
            }
            this.current = new Date();
        }

        this._renderCalendar();
    },

    /**
     * 달력 닫기
     * @private
     */
    _closeCalendar: function() {
        if (this.calendarContainer) {
            this.calendarContainer.style.display = 'none';
        }
        this.activeInput = null;

        // onCalendarClose 콜백 호출
        if (this.config.onCalendarClose && typeof this.config.onCalendarClose === 'function') {
            this.config.onCalendarClose.call(this);
        }
    },

    /**
     * DatePicker 초기화
     */
    init: function() {
        if (this.isInitialized) {
            console.warn('DatePicker 이미 초기화됨:', this.config.targetId || this.config.type);
            return this;
        }

        try {
            // 달력 생성
            this._createCalendar();

            if (this.config.type === 'single') {
                this._initSingle();
            } else if (this.config.type === 'range') {
                this._initRange();
            } else if (this.config.type === 'month') {
                this._initSingle();  // month 타입도 single과 동일하게 초기화
            }

            // 월 버튼 초기화
            if (this.config.showMonthButtons) {
                this._initMonthButtons();
            }

            this.isInitialized = true;

            // 초기화 완료 콜백
            if (this.config.onReady) {
                this.config.onReady.call(this);
            }

            console.log('DatePicker v4.0 초기화 완료:', this.config.type);
        } catch (e) {
            console.error('DatePicker 초기화 실패:', e);
        }

        return this;
    },

    /**
     * 단일 날짜 선택기 초기화
     * @private
     */
    _initSingle: function() {
        var targetElement = document.getElementById(this.config.targetId);
        if (!targetElement) {
            throw new Error('타겟 요소를 찾을 수 없습니다: ' + this.config.targetId);
        }

        this.targetElement = targetElement;

        // 기본 날짜 설정
        var defaultDate = this._getDefaultDate();
        if (defaultDate) {
            this.selectedDate = defaultDate;
            targetElement.value = this._formatDate(defaultDate);
        }

        // 클릭 이벤트
        var self = this;
        targetElement.onclick = function() {
            self._openCalendar(targetElement);
        };

        // 달력 버튼 찾아서 연결
        this._attachInputButton(targetElement);
    },

    /**
     * 범위 날짜 선택기 초기화
     * @private
     */
    _initRange: function() {
        if (!this.config.fromId || !this.config.toId) {
            throw new Error('범위 선택시 fromId와 toId가 필요합니다');
        }

        var fromElement = document.getElementById(this.config.fromId);
        var toElement = document.getElementById(this.config.toId);

        if (!fromElement || !toElement) {
            throw new Error('From 또는 To 요소를 찾을 수 없습니다');
        }

        // 기본 날짜 설정 (한달 전 ~ 오늘)
        var today = new Date();
        var oneMonthAgo = new Date(today.getTime());
        oneMonthAgo.setMonth(today.getMonth() - 1);

        this.selectedFromDate = oneMonthAgo;
        this.selectedToDate = today;

        fromElement.value = this._formatDate(oneMonthAgo);
        toElement.value = this._formatDate(today);

        // 클릭 이벤트
        var self = this;
        fromElement.onclick = function() {
            self._openCalendar(fromElement);
        };
        toElement.onclick = function() {
            self._openCalendar(toElement);
        };

        // 달력 버튼 연결
        this._attachInputButton(fromElement);
        this._attachInputButton(toElement);
    },

    /**
     * input 옆 달력 버튼 연결
     * @private
     */
    _attachInputButton: function(inputElement) {
        var self = this;
        var parent = inputElement.parentElement;

        // 부모에서 span 요소 찾기 (MonthNew 방식)
        if (parent && parent.querySelector('span')) {
            var span = parent.querySelector('span');
            span.onclick = function(e) {
                if (e && e.stopPropagation) e.stopPropagation();
                self._openCalendar(inputElement);
            };
            span.style.cursor = 'pointer';
        }
    },

    /**
     * 기본 날짜 계산
     * @private
     */
    _getDefaultDate: function() {
        if (this.config.defaultDate === 'today' || !this.config.defaultDate) {
            return new Date();
        } else {
            return new Date(this.config.defaultDate);
        }
    },

    /**
     * 월 버튼 초기화
     * @private
     */
    _initMonthButtons: function() {
        if (!this.config.monthButtonsContainer) return;

        var container = document.getElementById(this.config.monthButtonsContainer);
        if (!container) return;

        var self = this;
        var buttons = container.getElementsByTagName('button');

        for (var i = 0; i < buttons.length; i++) {
            (function(button) {
                var months = parseInt(button.getAttribute('data-months'));
                if (!isNaN(months)) {
                    button.onclick = function() {
                        self.setRangeByMonths(months);
                    };
                }
            })(buttons[i]);
        }
    },

    /**
     * 현재 선택된 날짜 가져오기 (Date 객체)
     */
    getDate: function() {
        if (this.config.type === 'single') {
            return this.selectedDate;
        } else {
            return {
                from: this.selectedFromDate,
                to: this.selectedToDate
            };
        }
    },

    /**
     * 날짜 범위 가져오기 (표시 형식)
     * @returns {object} {from: 'YYYY/MM/DD', to: 'YYYY/MM/DD'}
     */
    getDateRange: function() {
        if (this.config.type !== 'range') {
            console.warn('getDateRange()는 범위 달력에서만 사용 가능합니다');
            return { from: '', to: '' };
        }

        var fromElement = document.getElementById(this.config.fromId);
        var toElement = document.getElementById(this.config.toId);

        return {
            from: fromElement ? fromElement.value : '',
            to: toElement ? toElement.value : ''
        };
    },

    /**
     * Date 객체를 YYYYMMDD 형식으로 변환
     * @param {Date} date
     * @returns {string}
     */
    formatDatePure: function(date) {
        return this._formatDatePlain(date);
    },

    /**
     * 순수 날짜 문자열 가져오기 (YYYYMMDD)
     */
    getDatePure: function() {
        if (this.config.type === 'single') {
            return this._formatDatePlain(this.selectedDate);
        } else {
            return {
                from: this._formatDatePlain(this.selectedFromDate),
                to: this._formatDatePlain(this.selectedToDate)
            };
        }
    },

    /**
     * 날짜 범위 순수 문자열 가져오기
     */
    getDateRangePure: function() {
        if (this.config.type !== 'range') {
            console.warn('getDateRangePure()는 범위 달력에서만 사용 가능합니다');
            return { from: '', to: '' };
        }
        return this.getDatePure();
    },

    /**
     * 날짜 설정
     */
    setDate: function(date) {
        if (this.config.type === 'single') {
            this.selectedDate = new Date(date);
            if (this.targetElement) {
                this.targetElement.value = this._formatDate(this.selectedDate);
            }
        } else if (this.config.type === 'month') {
            // month 타입 지원 추가
            this.selectedDate = new Date(date);
            this.current = new Date(date);
            if (this.targetElement) {
                this.targetElement.value = this._formatDate(this.selectedDate);
            }
            // 달력 UI 업데이트
            this._renderCalendar();
        } else {
            // range 타입: 기간 유효성 검사
            var tempFromDate = date.from ? new Date(date.from) : this.selectedFromDate;
            var tempToDate = date.to ? new Date(date.to) : this.selectedToDate;

            // maxRangeMonths 유효성 검사
            if (!this._validateDateRange(tempFromDate, tempToDate)) {
                return this;  // 유효하지 않으면 변경하지 않음
            }

            if (date.from) {
                this.selectedFromDate = new Date(date.from);
                var fromEl = document.getElementById(this.config.fromId);
                if (fromEl) {
                    fromEl.value = this._formatDate(this.selectedFromDate);
                }
            }
            if (date.to) {
                this.selectedToDate = new Date(date.to);
                var toEl = document.getElementById(this.config.toId);
                if (toEl) {
                    toEl.value = this._formatDate(this.selectedToDate);
                }
            }
        }
        return this;
    },

    /**
     * 월 단위로 날짜 범위 설정
     */
    setRangeByMonths: function(months) {
        if (this.config.type !== 'range') {
            console.warn('범위 타입이 아닙니다');
            return this;
        }

        var today = new Date();
        var startDate = new Date(today.getTime());

        if (months === 12) {
            startDate.setFullYear(today.getFullYear() - 1);
        } else {
            startDate.setMonth(today.getMonth() - months);
        }


        console.log('setRangeByMonths 호출, months:', months, ', startDate:', startDate, ', today:', today);

        this.setDate({ from: startDate, to: today });
        return this;
    },

    /**
     * 특정 날짜의 당월 첫날과 마지막날
     */
    getMonthRange: function(date) {
        var baseDate = date || new Date();
        var firstDay = new Date(baseDate.getFullYear(), baseDate.getMonth(), 1);
        var lastDay = new Date(baseDate.getFullYear(), baseDate.getMonth() + 1, 0);

        return {
            firstDay: firstDay,
            lastDay: lastDay
        };
    },

    /**
     * 이번 달 전체 기간으로 설정
     */
    setThisMonth: function(baseDate) {
        if (this.config.type !== 'range') {
            console.warn('setThisMonth()는 범위 달력에서만 사용 가능합니다');
            return this;
        }

        var monthRange = this.getMonthRange(baseDate);
        this.setDate({
            from: monthRange.firstDay,
            to: monthRange.lastDay
        });

        return this;
    },

    /**
     * 당월 범위 순수 날짜 가져오기
     * month 타입: YYYYMM 형식 반환
     * 기타 타입: YYYYMMDD 형식 반환 (선택된 년/월의 첫날~마지막날)
     */
    getMonthRangePure: function() {
        var baseDate;

        // month 타입일 경우 selectedDate 사용
        if (this.config.type === 'month') {
            baseDate = this.selectedDate || new Date();
        } else {
            var selectedDate = this.getDate();
            baseDate = selectedDate || new Date();
        }

        var monthRange = this.getMonthRange(baseDate);

        return {
            from: this._formatDatePlain(monthRange.firstDay),  // month: YYYYMM, 기타: YYYYMMDD
            to: this._formatDatePlain(monthRange.lastDay)      // month: YYYYMM, 기타: YYYYMMDD
        };
    },

    /**
     * 현재 월 기준 상대적 날짜 설정
     */
    setCurrentMonth: function(monthOffset) {
        monthOffset = monthOffset || 0;
        var targetDate = new Date();

        if (monthOffset !== 0) {
            targetDate.setMonth(targetDate.getMonth() + monthOffset);
        }

        if (this.config.type === 'single') {
            this.setDate(targetDate);
        } else {
            // 범위 달력 - To 날짜만 변경
            this.setDate({
                from: this.selectedFromDate,
                to: targetDate
            });
        }

        return this;
    },

    /**
     * 활성화
     */
    enable: function() {
        if (this.config.type === 'single') {
            if (this.targetElement) {
                this.targetElement.disabled = false;
            }
        } else {
            var fromEl = document.getElementById(this.config.fromId);
            var toEl = document.getElementById(this.config.toId);
            if (fromEl) fromEl.disabled = false;
            if (toEl) toEl.disabled = false;
        }
        return this;
    },

    /**
     * 비활성화
     */
    disable: function() {
        if (this.config.type === 'single') {
            if (this.targetElement) {
                this.targetElement.disabled = true;
            }
        } else {
            var fromEl = document.getElementById(this.config.fromId);
            var toEl = document.getElementById(this.config.toId);
            if (fromEl) fromEl.disabled = true;
            if (toEl) toEl.disabled = true;
        }
        return this;
    },

    /**
     * 인스턴스 정리
     */
    destroy: function() {
        // 달력 숨기기
        this._closeCalendar();

        // 이벤트 제거
        if (this.targetElement) {
            this.targetElement.onclick = null;
        }

        if (this.config.type === 'range') {
            var fromEl = document.getElementById(this.config.fromId);
            var toEl = document.getElementById(this.config.toId);
            if (fromEl) fromEl.onclick = null;
            if (toEl) toEl.onclick = null;
        }

        this.isInitialized = false;
        console.log('DatePicker 인스턴스 정리 완료');
    }
};


