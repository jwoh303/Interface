/**
 * IBSheet 래퍼 클래스
 * @param {string} sheetName - IBSheet 인스턴스명
 * @param {string} displayName - 고유명칭 (화면에 표시될 이름)
 */
function IBSheetWrapper(sheetName, displayName) {
    this.sheetName = sheetName;
    this.displayName = displayName || sheetName; // 고유명칭 없으면 시트명 사용
    this.sheet = null;
    this.lastSearchUrl = null; // 마지막 검색 URL 저장
    this.callbacks = {
        onSearchEnd: [],
        onBeforeSearch: [],
        onClick: [],
        onRowSearchEnd: [],
        onChange: []
    };

    // DoSearch 사용 여부 플래그 (기본값: true)
    this.enableSearch = true;

    // 데이터 없음 알림 설정 (기본값: true - 자동 알림)
    this.showNoDataAlert = true;
    this.noDataAlertType = 'row'; // 'alert' 또는 'row' (기본값: row)
    this.noDataMessage = '조회된 데이터가 없습니다.';

    // 전역 인스턴스 저장소에 등록
    window.ibsheetInstances[sheetName] = this;

    // 시트 인스턴스 자동 연결 (전역 변수에서 찾기)
    var self = this;

    // 즉시 연결 시도
    if (window[sheetName]) {
        self.sheet = window[sheetName];
    }

}

/**
 * IBSheet 인스턴스 수동 연결
 * createIBSheet 이후 호출하여 전역 변수와 연결
 * @returns {IBSheetWrapper} this 인스턴스 (체이닝 지원)
 */
IBSheetWrapper.prototype.connectSheet = function() {
    if (window[this.sheetName]) {
        this.sheet = window[this.sheetName];
    }
    return this;
};


/**
 * IBSheet 컬럼 % 적용
 * @returns {IBSheetWrapper} this 인스턴스 (체이닝 지원)
 */
IBSheetWrapper.prototype.FitColWidths = function(ColWidths) {
  this.sheet .FitColWidth(ColWidths); 
    return this;
};


/**
 * IBSheet 네이티브 인스턴스 가져오기
 * @returns {Object} IBSheet 네이티브 인스턴스
 */
IBSheetWrapper.prototype.getCheckedRows = function(Col) {
    return this.sheet.CheckedRows(Col);
};


/**
 * IBSheet 네이티브 인스턴스 가져오기
 * @returns {Object} IBSheet 네이티브 인스턴스
 */
IBSheetWrapper.prototype.getSheet = function() {
    return this.sheet;
};


/**
 * DoSearch 기능을 사용하지 않는 경우 호출
 * 검색 관련 이벤트 핸들러 등록을 생략함
 * @returns {IBSheetWrapper} this 인스턴스 (체이닝 지원)
 */
IBSheetWrapper.prototype.disableSearch = function() {
    this.enableSearch = false;
    return this;
};

/**
 * 데이터 없음 알림 설정
 * @param {boolean} enable - 활성화 여부 (기본값: true)
 * @param {string} customMessage - 커스텀 메시지 (선택)
 * @param {string} type - 알림 타입 ('alert' 또는 'row', 기본값: 'row')
 * @returns {IBSheetWrapper} this 인스턴스 (체이닝 지원)
 */
IBSheetWrapper.prototype.setNoDataAlert = function(enable, customMessage, type) {
    this.showNoDataAlert = enable !== false;
    if (customMessage) {
        this.noDataMessage = customMessage;
    }
    if (type === 'alert' || type === 'row') {
        this.noDataAlertType = type;
    }
    return this;
};

/**
 * 검색 완료 이벤트 설정 및 전역 핸들러 등록
 * @param {function} callback - 검색 완료 콜백 함수
 */
IBSheetWrapper.prototype.SetOnSearchEnd = function(callback) {
    if (typeof callback === 'function') {
        this.callbacks.onSearchEnd.push(callback);
    }
    return this;
};

/**
 * 행 조회 완료 이벤트 설정 및 전역 핸들러 등록
 * 조회 시 각 행이 로드될 때마다 호출되어 조건부 스타일 적용 가능
 * @param {function} callback - 행 조회 완료 콜백 함수 (파라미터: row)
 * @returns {IBSheetWrapper} this 인스턴스 (체이닝 지원)

 */
IBSheetWrapper.prototype.setOnRowSearchEnd = function(callback) {
    if (typeof callback === 'function') {
        this.callbacks.onRowSearchEnd.push(callback);
    }

    // 처음 호출 시 전역 이벤트 핸들러 등록
    if (this.callbacks.onRowSearchEnd.length === 1 && !window[this.sheetName + '_OnRowSearchEnd']) {
        this._setupRowSearchEndEventHandler();
    }

    return this;
};

/**
 * 서버 호출 없이 JSON 데이터를 직접 로드
 * @param {Object|String} jsonData - JSON 객체 또는 JSON 문자열
 * @param {Boolean} append - 기존 데이터에 추가할지 여부 (기본값: false, 대체)
 * @returns {IBSheetWrapper} this 인스턴스 (체이닝 지원)
 */
IBSheetWrapper.prototype.LoadSearchData = function(jsonData, append) {
    if (!this.sheet) {
        return this;
    }

    try {
        var data = typeof jsonData === 'string' ? JSON.parse(jsonData) : jsonData;

        // IBSheet는 소문자 "data" 키를 사용하지만, 서버 응답은 대문자 "Data"를 사용할 수 있음
        // 두 가지 케이스 모두 지원
        if (!data || (!data.data && !data.Data)) {
            data = { data: [] };
        } else if (data.Data && !data.data) {
            // 대문자 "Data"를 소문자 "data"로 변환 (IBSheet 표준 형식)
            data = { data: data.Data };
        }
        
//        showIBSheetLoading(this.sheetName, this.displayName + " 로드중...");
        
        
        showIBSheetLoading(this.sheetName,"");
        
        
        if (append) {
            this.sheet.LoadSearchData(data, {Append: 1});
        } else {
            this.sheet.LoadSearchData(data);
        }
        
        hideIBSheetLoading(this.sheetName);
        
        this._triggerEvent('onSearchEnd', [1, "LoadSearchData", "200", "Success", data]);
        
    } catch (error) {
        hideIBSheetLoading(this.sheetName);
        this._triggerEvent('onSearchEnd', [-1, error.message, "500", "Error", null]);
    }
    
    return this;
};

/**
 * DoSearch 실행
 * @param {string} url - 서버 URL
 * @param {string} params - 파라미터 문자열
 */
IBSheetWrapper.prototype.DoSearch = function(url, params) {
    if (!this.sheet) {
        return this;
    }

    if (!this.enableSearch) {
        return this;
    }

    if (url && typeof url === 'string') {
        this.lastSearchUrl = url;
    }

    // 통신 파라미터 콘솔 로그 출력
    console.log('%c[IBSheet DoSearch] ' + this.displayName, 'color: #2196F3; font-weight: bold;');
    console.log('URL:', url || this.lastSearchUrl);
    console.log('Params:', params);
    console.log('Sheet:', this.sheetName);
    console.log('Timestamp:', new Date().toLocaleString());
    console.log('---');

    if (this.sheet && this.sheet.SetWaitImageVisible) {
        this.sheet.SetWaitImageVisible(0);
    }

    this.sheet.DoSearch(url, params);
    return this;
};

/**
 * 클릭 이벤트 설정 및 전역 핸들러 등록
 * @param {string|function} columnOrCallback - 컬럼명 또는 콜백 함수
 * @param {function} callback - 콜백 함수 (첫 번째 파라미터가 컬럼명인 경우)
 */
IBSheetWrapper.prototype.setOnClick = function(columnOrCallback, callback) {
    
    // 처음 호출시 전역 이벤트 핸들러 등록
    if (!window[this.sheetName + '_OnClick']) {
        this._setupClickEventHandler();
    }
    
    // 컬럼별 클릭 이벤트 등록
    if (typeof columnOrCallback === 'string' && typeof callback === 'function') {
        var columnName = columnOrCallback;
        
        // 컬럼별 콜백 저장소 초기화
        if (!this.callbacks.onColumnClick) {
            this.callbacks.onColumnClick = {};
        }
        
        // 컬럼별 콜백 등록
        if (!this.callbacks.onColumnClick[columnName]) {
            this.callbacks.onColumnClick[columnName] = [];
        }
        this.callbacks.onColumnClick[columnName].push(callback);
        
        return this;
    }
    
    // 일반 클릭 이벤트 등록 (기존 방식)
    if (typeof columnOrCallback === 'function') {
        this.callbacks.onClick.push(columnOrCallback);
    }
    return this;
};

/**
 * 검색 시작 전 이벤트 설정 및 전역 핸들러 등록
 * @param {function} callback - 검색 시작 전 콜백 함수
 */
IBSheetWrapper.prototype.setOnBeforeSearch = function(callback) {
    if (typeof callback === 'function') {
        this.callbacks.onBeforeSearch.push(callback);
    }
    return this;
};

/**
 * 클릭한 컬럼 인덱스로 컬럼명(SaveName) 반환
 * @param {number} colIndex - 컬럼 인덱스 번호
 * @returns {string} 컬럼명 (SaveName)
 */
IBSheetWrapper.prototype.getColSaveName = function(colIndex) {
    if (!this.sheet || typeof colIndex !== 'number') {
        return '';
    }

    try {
        return this.sheet.ColSaveName(colIndex) || '';
    } catch (e) {
        return '';
    }
};
/**
 * 데이터 건수 반환
 * @returns {number} 데이터 행 개수
 */
IBSheetWrapper.prototype.getRowCount = function() {
    if (!this.sheet) return 0;
    
    try {
        if (typeof this.sheet.RowCount === 'function') {
            return this.sheet.RowCount();
        } else if (typeof this.sheet.GetDataRowCount === 'function') {
            return this.sheet.GetDataRowCount();
        }
    } catch (e) {
        // 에러 무시
    }
    return 0;
};

/**
 * 특정 셀 값 가져오기
 * @param {number} row - 행 번호
 * @param {string} col - 컬럼명
 * @returns {*} 셀 값
 */
IBSheetWrapper.prototype.getCellValue = function(row, col) {
    if (!this.sheet) return "";
    return this.sheet.GetCellValue(row, col);
};

/**
 * 특정 셀 값 설정하기
 * @param {number} row - 행 번호
 * @param {string} col - 컬럼명
 * @param {*} value - 설정할 값
 * @param {Object} options - 옵션 (선택적, 예: {event: 0})
 * @returns {IBSheetWrapper} this 인스턴스 (체이닝 지원)
 */
IBSheetWrapper.prototype.SetCellValue = function(row, col, value, options) {
    if (!this.sheet) return this;

    try {
        if (options) {
            this.sheet.SetCellValue(row, col, value, options);
        } else {
            this.sheet.SetCellValue(row, col, value);
        }
    } catch (error) {
        console.error('SetCellValue 오류:', error);
    }

    return this;
};

/**
 * 특정 행의 전체 데이터를 객체 형태로 가져오기
 * @param {number} row - 행 번호
 * @returns {Object} 행 데이터 객체 (컬럼명: 값 형태)
 */
IBSheetWrapper.prototype.GetRowData = function(row) {
    if (!this.sheet) return {};

    try {
        // IBSheet의 네이티브 GetRowData 메서드가 있으면 사용
        if (typeof this.sheet.GetRowData === 'function') {
            return this.sheet.GetRowData(row);
        }

        // GetRowData가 없으면 수동으로 구성
        var rowData = {};
        var colCount = this.sheet.GetColCount();

        for (var col = 0; col < colCount; col++) {
            var colName = this.sheet.ColSaveName(col);
            if (colName && colName !== "") {
                rowData[colName] = this.sheet.GetCellValue(row, colName);
            }
        }

        return rowData;

    } catch (error) {
           console.log('getRowData error: ', error);
        return {};
    }
};

/**
 * 시트 데이터 전체 제거
 */
IBSheetWrapper.prototype.removeAll = function() {
    if (this.sheet && typeof this.sheet.RemoveAll === 'function') {
        this.sheet.RemoveAll();
    }
    return this;
};

/**
 * IBSheet 초기화 (컬럼 설정 기반)
 * @param {Array} columns - 컬럼 설정 배열
 * @param {Object} options - 추가 옵션 설정
 * @param {function} callback - 초기화 완료 후 실행될 콜백 함수 (선택적)
 */
IBSheetWrapper.prototype.initialize = function(columns, options, callback) {
    if (!this.sheet) {
        return this;
    }
    
    if (!columns || !Array.isArray(columns)) {
        return this;
    }
    
    
    try {
        // 기본 옵션 설정 (JSP에서 사용되던 initOptions와 동일)
        var defaultOptions = {
            pagingMode: typeof pagingMode !== 'undefined' ? pagingMode : 'N', // 전역 변수 사용 또는 'N'
            mergeSheet: 'msHeaderOnly',
            frozenCol: 0,
            colMove: 1,
            colResize: 1,
            headerCheck: 1,
            useNoDataRow: 1,    //  0 '조회된 데이터가 없습니다' 메시지를 사용 안 함, 1= 사용함
            theme: 'DB',
            themePath: 'DeepBlue',
            waitImageVisible: false
        };
        
        // 사용자 옵션으로 기본값 오버라이드
        var config = defaultOptions;
        if (options) {
            for (var key in options) {
                if (options.hasOwnProperty(key)) {
                    config[key] = options[key];
                }
            }
        }
        
        // IBSheet 초기화 객체 생성
        var initsheet = {};
        
        // 컬럼 설정
        initsheet.Cols = columns;
        
        // IBSheet 구성 설정
        initsheet.Cfg = {
            MergeSheet: config.mergeSheet === 'msHeaderOnly' ? (typeof msHeaderOnly !== 'undefined' ? msHeaderOnly : 0) : config.mergeSheet,
            FrozenCol: config.frozenCol
        };
        
        // 헤더 모드 설정
        initsheet.HeaderMode = {
            ColMove: config.colMove,
            ColResize: config.colResize,
            HeaderCheck: config.headerCheck
        };
        
      
        
        
        
        // IBSheet 초기화 실행
        
        IBS_InitSheet(this.sheet, initsheet, config.pagingMode, '');
        
        // 테마 설정
        this.sheet.SetTheme(config.theme, config.themePath);
        this.sheet.SetClipCopyMode(0);
        // 추가 설정
        var cfg = {
            UseNoDataRow: config.useNoDataRow, // 데이터 없을 때 "조회된 데이터가 없습니다" 자동 표시
            HeaderRowHeight: 100, 
            Alternate : 0,
            DataRowHeight: 30,
            CountPosition: 3,
            AutoRowHeight :0,
            CountFormat: " 총  ROWCOUNT 건 " 
        };
        this.sheet.SetConfig(cfg);
        
        // 로딩 이미지 비활성화 (기본 이미지 사용 안 함)
        this.sheet.SetWaitImageVisible(0); // 0 = 비활성화, 1 = 활성화
        this.sheet.SetHeaderBackColor("#f2f7ff"); 
        this.sheet.RemoveAll()
//        this.sheet.SetCountFormat(" 총  ROWCOUNT 건 ");
        this.sheet.SetHeaderRowHeight(50);
        
        // DoSearch 사용 여부에 따라 검색 이벤트 핸들러 조건부 등록
        if (this.enableSearch) {
            this._setupBeforeSearchEventHandler();
            this._setupSearchEndEventHandler();
        }
        
        // 초기화 작업이 모두 완료되었을 때 콜백 실행
        if (typeof callback === 'function') {
            callback.call(this);
        }
        
    } catch (error) {
        throw error;
    }
    
    return this;
};

/**
 * 내부적으로 사용되는 이벤트 트리거 함수
 * @param {string} eventType - 이벤트 타입
 * @param {Array} args - 이벤트 파라미터들
 */
IBSheetWrapper.prototype._triggerEvent = function(eventType, args) {
    var callbacks = this.callbacks[eventType];
    if (callbacks && callbacks.length > 0) {
        for (var i = 0; i < callbacks.length; i++) {
            try {
                callbacks[i].apply(this, args);
            } catch (e) {
                // 에러 무시
            }
        }
    }
};


/**
 * 검색 완료 이벤트 핸들러 설정
 * @private
 */
IBSheetWrapper.prototype._setupSearchEndEventHandler = function() {
    var instance = this;
    var sheetName = this.sheetName;

    window[sheetName + '_OnSearchEnd'] = function(code, Msg, StCode, StMsg, response) {
        hideIBSheetLoading(sheetName);

        // 응답 로그 출력
        console.log('%c[IBSheet Response] ' + instance.displayName, 'color: #4CAF50; font-weight: bold;');
        console.log('Code:', code);
        console.log('Message:', Msg);
        console.log('Status Code:', StCode);
        console.log('Status Message:', StMsg);
        console.log('Response Data:', response);
        console.log('Row Count:', instance.getRowCount());
        console.log('Timestamp:', new Date().toLocaleString());
        console.log('---');

        if (code < 0) {
            var errorMessage = "조회 중 오류가 발생했습니다.";
            if (Msg && Msg.trim() !== "") {
                errorMessage = Msg;
            }
            alert(errorMessage);
            instance._triggerEvent('onSearchEnd', [code, Msg, StCode, StMsg, response]);
            return;
        }

        var validationResult = instance._validateServerData(code, Msg, StCode, StMsg, response, instance.getRowCount());

        // 데이터 없음 자동 알림 (기본 활성화)
/*        if (instance.showNoDataAlert && validationResult.isValid && validationResult.data.rowCount === 0) {
            if (instance.noDataAlertType === 'alert') {
                // alert 방식
                alert(instance.noDataMessage);
            } else {
                // row 방식 (기본값) - 시트에 메시지 행 추가
                instance._showNoDataRow();
            }
        }*/

        instance._triggerEvent('onSearchEnd', [code, Msg, StCode, StMsg, response, validationResult]);
    };

};


IBSheetWrapper.prototype.SetCountFormat = function() {
	

	 this.sheet.SetCountFormat("▶ 현재 {BOTTOMDATA}행 위치 / 총 {ROWCOUNT}건 (DB 전체 {TOTALROWS}건)");
};



/**
 * 데이터 없음 메시지를 시트에 행으로 표시
 * @private
 */
IBSheetWrapper.prototype._showNoDataRow = function() {
    if (!this.sheet) return;
    
    this.sheet.DataInsert(-1); // [3]
    
    
    var lastColIndex =  this.sheet.LastCol(); 
    
    this.sheet.SetMergeCell(1, 1, 1, lastColIndex, 1)
    
    this.sheet.SetCellAlign(1, 1, "Center");
//      mySheetDiv.SetCellValue(1, 0, "메롱", {event: 0});
    
    var newProps = { Type: "Html", Align: "Center", Edit: 0 };
    this.sheet.InitCellProperty(1, 1, newProps);

    // 2. HTML 태그가 포함된 값을 설정합니다 (화면 전체 기준 가운데 정렬, 스크롤 가능)
    var htmlValue =
        "<div >" +
        "<div>" +
        "<img src='/resources/imgs/Icon_Warning01.png' alt='알림' style='display: block; margin: 0 auto 10px; width: 64px; height: 64px;' />" +
        "<span style='display: block; color: #999999; font-size: 14px;'>" + this.noDataMessage + "</span>" +
        "</div>" +
        "</div>";

    this.sheet.SetCellValue(1, 1, htmlValue, {event: 0}); 
    
    this.sheet.SetRowHeight(1,120)
    try {
      

    } catch (error) {
        console.log('[NoDataRow] Error:', error);
        console.log('[NoDataRow] Error stack:', error.stack);
    }
};

/**
 * 서버 데이터 검증 로직 (공통)
 * @param {number} code - 응답 코드
 * @param {string} Msg - 응답 메시지
 * @param {string} StCode - 상태 코드
 * @param {string} StMsg - 상태 메시지
 * @param {Object} response - 서버 응답 객체
 * @param {number} rowCount - 조회된 행 수
 * @returns {Object} 검증 결과 객체
 * @private
 */
IBSheetWrapper.prototype._validateServerData = function(code, Msg, StCode, StMsg, response, rowCount) {
    var result = {
        isValid: true,
        message: "",
        data: {
            code: code,
            message: Msg,
            statusCode: StCode,
            statusMessage: StMsg,
            rowCount: rowCount
        }
    };
    
    try {
        if (code < 0) {
            result.isValid = false;
            result.message = "서버 응답 오류 (코드: " + code + ")";
            if (Msg && Msg.trim() !== "") {
                result.message += " - " + Msg;
            }
            return result;
        }
        
        var statusCode = String(StCode);
        if (StCode && statusCode !== "200" && statusCode !== "0" && statusCode !== "") {
            result.isValid = false;
            result.message = "비정상 상태 코드: " + StCode;
            if (StMsg && StMsg.trim() !== "") {
                result.message += " - " + StMsg;
            }
            return result;
        }
        
        result.message = "서버 데이터 검증 통과";
        
    } catch (error) {
        result.isValid = false;
        result.message = "데이터 검증 처리 오류: " + error.message;
    }
    
    return result;
};


/**
 * 검색 시작 전 이벤트 핸들러 설정
 * @private
 */
IBSheetWrapper.prototype._setupBeforeSearchEventHandler = function() {
    var instance = this;
    var sheetName = this.sheetName;
    
    window[sheetName + '_OnBeforeSearch'] = function() {
    	   showIBSheetLoading(sheetName,"");
    	
    	//        showIBSheetLoading(sheetName, instance.displayName + " 조회중...");
        instance._triggerEvent('onBeforeSearch', []);
    };
};

/**
 * 클릭 이벤트 핸들러 설정
 * @private
 */
IBSheetWrapper.prototype._setupClickEventHandler = function() {
    var instance = this;
    var sheetName = this.sheetName;

    window[sheetName + '_OnClick'] = function(Row, Col, Value, CellX, CellY, CellW, CellH) {
        if (Row < 1) return;

        var column = instance.sheet ? instance.sheet.ColSaveName(Col) : null;

        var hasColumnCallback = false;
        if (column && instance.callbacks.onColumnClick && instance.callbacks.onColumnClick[column]) {
            var columnCallbacks = instance.callbacks.onColumnClick[column];
            for (var i = 0; i < columnCallbacks.length; i++) {
                try {
                    columnCallbacks[i].call(instance, Row, Col, Value, CellX, CellY, CellW, CellH);
                    hasColumnCallback = true;
                } catch (e) {
                    // 에러 무시
                }
            }
        }

        if (!hasColumnCallback) {
            instance._triggerEvent('onClick', [Row, Col, Value, CellX, CellY, CellW, CellH]);
        }
    };

};

/**
 * 행 조회 완료 이벤트 핸들러 설정
 * 각 행이 로드될 때마다 호출되어 조건부 스타일 적용
 * @private
 */
IBSheetWrapper.prototype._setupRowSearchEndEventHandler = function() {
    var instance = this;
    var sheetName = this.sheetName;

    window[sheetName + '_OnRowSearchEnd'] = function(row) {
        if (row < 1) return;

        // 등록된 모든 콜백 실행
        var callbacks = instance.callbacks.onRowSearchEnd;
        if (callbacks && callbacks.length > 0) {
            for (var i = 0; i < callbacks.length; i++) {
                try {
                    callbacks[i].call(instance, row);
                } catch (e) {
                    console.error('[IBSheet OnRowSearchEnd] 콜백 실행 오류:', e);
                }
            }
        }
    };
};

/**
 * 셀 값 변경 이벤트 설정 및 전역 핸들러 등록
 * @param {string|function} columnOrCallback - 컬럼명 또는 콜백 함수
 * @param {function} callback - 콜백 함수 (첫 번째 파라미터가 컬럼명인 경우)
 * @returns {IBSheetWrapper} this 인스턴스 (체이닝 지원)
 * @example
 * // 특정 컬럼에 대한 이벤트
 * mySheet.setOnChange('Price', function(Row, Col, Value) {
 *     console.log('Price 변경:', Value);
 *     // 가격 변경시 금액 재계산
 *     var qty = this.getCellValue(Row, 'Qty');
 *     var amount = Value * qty;
 *     this.SetCellValue(Row, 'Amount', amount, {event: 0});
 * });
 *
 * // 전체 셀 변경 이벤트
 * mySheet.setOnChange(function(Row, Col, Value) {
 *     console.log('셀 변경 - Row:', Row, 'Col:', Col, 'Value:', Value);
 * });
 */
IBSheetWrapper.prototype.setOnChange = function(columnOrCallback, callback) {

    // 처음 호출시 전역 이벤트 핸들러 등록
    if (!window[this.sheetName + '_OnChange']) {
        this._setupChangeEventHandler();
    }

    // 컬럼별 변경 이벤트 등록
    if (typeof columnOrCallback === 'string' && typeof callback === 'function') {
        var columnName = columnOrCallback;

        // 컬럼별 콜백 저장소 초기화
        if (!this.callbacks.onColumnChange) {
            this.callbacks.onColumnChange = {};
        }

        // 컬럼별 콜백 등록
        if (!this.callbacks.onColumnChange[columnName]) {
            this.callbacks.onColumnChange[columnName] = [];
        }
        this.callbacks.onColumnChange[columnName].push(callback);

        return this;
    }

    // 일반 변경 이벤트 등록 (모든 셀 변경)
    if (typeof columnOrCallback === 'function') {
        this.callbacks.onChange.push(columnOrCallback);
    }
    return this;
};

/**
 * 셀 값 변경 이벤트 핸들러 설정
 * @private
 */
IBSheetWrapper.prototype._setupChangeEventHandler = function() {
    var instance = this;
    var sheetName = this.sheetName;

    window[sheetName + '_OnChange'] = function(Row, Col, Value) {
        if (Row < 1) return;

        var column = instance.sheet ? instance.sheet.ColSaveName(Col) : null;

        // 컬럼별 변경 콜백 실행
        var hasColumnCallback = false;
        if (column && instance.callbacks.onColumnChange && instance.callbacks.onColumnChange[column]) {
            var columnCallbacks = instance.callbacks.onColumnChange[column];
            for (var i = 0; i < columnCallbacks.length; i++) {
                try {
                    columnCallbacks[i].call(instance, Row, Col, Value);
                    hasColumnCallback = true;
                } catch (e) {
                    console.error('[IBSheet OnChange] 컬럼 콜백 실행 오류:', e);
                }
            }
        }

        // 전체 변경 콜백 실행 (컬럼별 콜백이 없는 경우만)
        if (!hasColumnCallback) {
            instance._triggerEvent('onChange', [Row, Col, Value]);
        }
    };
};


/**
 * 컬럼 너비를 비율로 설정 (FitColWidth 래퍼 메서드)
 * @param {string|Array} widths - 컬럼별 비율 (파이프 구분 문자열 또는 배열)
 * @returns {IBSheetWrapper} this 인스턴스 (체이닝 지원)
 */
IBSheetWrapper.prototype.fitColWidth = function(widths) {
    if (!this.sheet || !this.sheet.FitColWidth) {
        return this;
    }

    try {
        var widthParam = '';

        if (Array.isArray(widths)) {
            widthParam = widths.join('|');
        } else if (typeof widths === 'string') {
            widthParam = widths;
        } else {
            return this;
        }

        this.sheet.FitColWidth(widthParam);

    } catch (error) {
        // 에러 무시
    }

    return this;
};

/**
 * 컬럼 너비를 백분율로 설정 (픽셀을 백분율로 변환)
 * @param {Array} percentages - 컬럼별 백분율 배열
 * @param {number} containerWidth - 컨테이너 총 너비 (기본값: 1200px)
 * @returns {IBSheetWrapper} this 인스턴스 (체이닝 지원)
 */
IBSheetWrapper.prototype.setColWidthPercent = function(percentages, containerWidth) {
    if (!this.sheet || !Array.isArray(percentages)) {
        return this;
    }

    try {
        var totalWidth = containerWidth || 1200;
        var totalPercent = 0;

        for (var i = 0; i < percentages.length; i++) {
            totalPercent += percentages[i];
        }

        for (var i = 0; i < percentages.length; i++) {
            if (this.sheet.SetColWidth) {
                var pixelWidth = percentages[i] === 0 ? 0 : Math.round((percentages[i] / totalPercent) * totalWidth);
                this.sheet.SetColWidth(i, pixelWidth);
            }
        }

    } catch (error) {
        // 에러 무시
    }

    return this;
};



/**
 * 헤더 행 높이 설정
 * @param {number} height - 헤더 행 높이 (픽셀 단위)
 * @returns {IBSheetWrapper} this 인스턴스 (체이닝 지원)
 */
IBSheetWrapper.prototype.SetHeaderRowHeight = function(height) {
    if (!this.sheet) {
        return this;
    }

    this.sheet.SetHeaderRowHeight(height);

    return this;
};

/**
 * 데이터 행 높이 설정 (모든 행에 일괄 적용)
 * @param {number} height - 데이터 행 높이 (픽셀 단위)
 * @returns {IBSheetWrapper} this 인스턴스 (체이닝 지원)
 */
IBSheetWrapper.prototype.SetDataRowHeight = function(height) {
    if (!this.sheet) {
        return this;
    }

    if (typeof height !== 'number' || height <= 0) {
        console.warn('[IBSheetWrapper] SetDataRowHeight: 유효하지 않은 높이 값입니다.');
        return this;
    }

    try {
        // 1. 기본 행 높이 설정 (새로 추가되는 행에 적용)
        if (typeof this.sheet.SetConfig === 'function') {
            this.sheet.SetConfig({
                RowHeight: height
            });
        }

        // 2. 기존 데이터 행의 높이 일괄 설정
        var rowCount = this.getRowCount();
        if (rowCount > 0 && typeof this.sheet.SetRowHeight === 'function') {
            for (var i = 1; i <= rowCount; i++) {
                this.sheet.SetRowHeight(i, height);
            }
        }

        console.log('[IBSheetWrapper] SetDataRowHeight: ' + height + 'px 적용 (총 ' + rowCount + '개 행)');
    } catch (error) {
        console.error('[IBSheetWrapper] SetDataRowHeight 오류:', error);
    }

    return this;
};

/**
 * 엑셀 다운로드 실행
 * @param {Object} options - 엑셀 다운로드 옵션
 * @param {string} options.FileName - 파일명 (확장자 제외)
 * @param {string} options.SheetName - 시트명 (선택적)
 * @param {number} options.HiddenColumn - 숨김컬럼 포함여부 (0: 제외, 1: 포함)
 */
IBSheetWrapper.prototype.downloadExcel = function(options) {
    if (!this.sheet) {
        alert('시스템 오류: IBSheet가 초기화되지 않았습니다.');
        return this;
    }
    
    var rowCount = this.getRowCount();
    if (rowCount <= 0) {
        alert('다운로드할 데이터가 없습니다. 먼저 조회를 실행하세요.');
        return this;
    }
    
    var defaultOptions = {
        FileName: this.displayName + '_' + new Date().toISOString().slice(0, 10).replace(/-/g, ''),
        SheetName: this.displayName,
        HiddenColumn: 1
    };
    
    var excelOptions = {};
    for (var key in defaultOptions) {
        excelOptions[key] = options && options[key] !== undefined ? options[key] : defaultOptions[key];
    }
    
    try {
        this.sheet.Down2Excel(excelOptions);
    } catch (e) {
        alert('엑셀 다운로드 중 오류가 발생했습니다.');
    }
    
    return this;
};

/**
 * IBSheetWrapper 인스턴스들을 저장하는 전역 객체
 */
window.ibsheetInstances = {};


/**
 * 로딩 오버레이 표시
 * @param {string} sheetName - 시트명
 * @param {string} message - 로딩 메시지
 */
function showIBSheetLoading(sheetName, message) {
    var loadingId = 'ibsheet_loading_' + sheetName;
    var existing = document.getElementById(loadingId);
    if (existing) {
        existing.remove();
    }
    
    
    
    message = '';
    
    var loadingHtml = '<div id="' + loadingId + '" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 99999; display: flex; justify-content: center; align-items: center; flex-direction: column;">';
    loadingHtml += '<div style="background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 20px rgba(0,0,0,0.3); text-align: center;">';
    loadingHtml += '<img src="/resources/libs/ibsheet7/js/DeepBlue/loading.svg" alt="조회중..." style="width: 150px; height: 100px;" />';
   // loadingHtml += '<div style="color: #333; font-size: 16px; font-weight: bold; margin-top: 15px;">' + (message || '조회중...') + '</div>';
    loadingHtml += '</div></div>';
    
    document.body.insertAdjacentHTML('beforeend', loadingHtml);
}

/**
 * 로딩 오버레이 제거
 * @param {string} sheetName - 시트명
 */
function hideIBSheetLoading(sheetName) {
    var loadingId = 'ibsheet_loading_' + sheetName;
    var loadingOverlay = document.getElementById(loadingId);
    if (loadingOverlay) {
        loadingOverlay.remove();
    }
}

// ========================================
// 무한 스크롤 페이징 메서드 (신규)
// - 기존 메서드 수정 없음
// - 호출하지 않으면 동작하지 않음
// ========================================

/**
 * 페이징 상태 초기화
 * @param {string} url - 데이터 조회 URL
 * @param {string} params - 검색 파라미터 (쿼리스트링 형태)
 * @param {number} pageSize - 페이지당 건수 (기본값: 50)
 * @returns {IBSheetWrapper} this 인스턴스 (체이닝 지원)
 */
IBSheetWrapper.prototype.initPaging = function(url, params, pageSize) {
    this.pagingState = {
        url: url,
        params: params,
        pageIndex: 0,
        pageSize: pageSize || 50,
        totalCount: 0,
        hasMore: true,
        loading: false
    };
    return this;
};

/**
 * 다음 페이지 로드
 * @returns {Promise} 로드 완료 후 resolve (hasMore 반환)
 */
IBSheetWrapper.prototype.loadNextPage = function() {
    var self = this;

    if (!this.pagingState || !this.pagingState.hasMore || this.pagingState.loading) {
        return Promise.resolve(false);
    }

    this.pagingState.loading = true;
    this.pagingState.pageIndex++;

    var fullParams = this.pagingState.params +
        "&pageIndex=" + this.pagingState.pageIndex +
        "&pageSize=" + this.pagingState.pageSize;

    return HttpUtil.post(this.pagingState.url, fullParams, { showLoader: false })
        .then(function(response) {
            var data = response.data;
            var rows = data.Data || [];

            if (rows.length > 0) {
                // 첫 페이지면 기존 방식, 추가 페이지면 Append 모드
                if (self.pagingState.pageIndex === 1) {
                    self.LoadSearchData({ Data: rows });
                } else {
                    self.LoadSearchData({ Data: rows }, true);
                }
            }

            self.pagingState.totalCount = data.Total || 0;
            self.pagingState.hasMore = rows.length >= self.pagingState.pageSize;
            self.pagingState.loading = false;

            // 콜백 호출
            if (self.onPageLoaded) {
                self.onPageLoaded(self.pagingState.pageIndex, rows.length, self.pagingState.hasMore);
            }

            return self.pagingState.hasMore;
        })
        .catch(function(error) {
            self.pagingState.loading = false;
            console.error('[IBSheetWrapper] 페이지 로드 실패:', error);
            return false;
        });
};

/**
 * 더 로드할 데이터 있는지 확인
 * @returns {boolean} 더 로드할 데이터 유무
 */
IBSheetWrapper.prototype.hasMoreData = function() {
    return this.pagingState && this.pagingState.hasMore && !this.pagingState.loading;
};

/**
 * 현재 로딩 중인지 확인
 * @returns {boolean} 로딩 중 여부
 */
IBSheetWrapper.prototype.isLoading = function() {
    return this.pagingState && this.pagingState.loading;
};

/**
 * 페이징 상태 초기화 (리셋)
 * @returns {IBSheetWrapper} this 인스턴스 (체이닝 지원)
 */
IBSheetWrapper.prototype.resetPaging = function() {
    this.pagingState = null;
    this.onPageLoaded = null;
    return this;
};

/**
 * 페이징 총 건수 가져오기
 * @returns {number} 총 건수
 */
IBSheetWrapper.prototype.getPagingTotalCount = function() {
    return this.pagingState ? this.pagingState.totalCount : 0;
};

/**
 * 현재 페이지 인덱스 가져오기
 * @returns {number} 현재 페이지 인덱스
 */
IBSheetWrapper.prototype.getCurrentPageIndex = function() {
    return this.pagingState ? this.pagingState.pageIndex : 0;
};

