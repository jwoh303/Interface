/**
 * 상세내역보기 팝업 컴포넌트
 * CustomerSelectPopup과 동일한 구조로 구현
 */
(function(window) {
    'use strict';
    
    var DetailViewPopup = {

        // 현재 팝업 데이터
        currentPopup: null,
        currentData: [],

        // IBSheetWrapper 인스턴스
        sheetWrapper: null,
        
        /**
         * 상세내역보기 팝업 열기
         * @param {Object} options - 팝업 옵션 (필수)
         */
        open: function(options) {
            if (!options) {
                console.error('[DetailViewPopup] options가 필요합니다.');
                return;
            }

            // 필수 옵션 검증
            this.validateOptions(options);
            
            var popupId = 'detailViewPopup_' + Date.now();
            this.currentPopup = {
                id: popupId,
                options: options
            };
      
            // DIVpopup 방식으로 팝업 생성
            this.createDivPopup(popupId, options);
            
            // 이벤트 바인딩 (DOM 완전 로드 후)
            var self = this;
            setTimeout(function() {
                // IBSheet 초기화 (초기화 완료 후 자동으로 데이터 로드됨)
                self.initIBSheet();
                self.bindEvents();
            }, 100);
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
            overlay.id = 'detailViewOverlay';
            overlay.style.display = 'block';
            overlay.style.zIndex = '9998';
            
            // 팝업 컨테이너 생성
            var popup = document.createElement('div');
            popup.className = 'DIVpopup';
            popup.id = 'detailViewPopup';
            popup.style.display = 'block';
            popup.style.zIndex = '9999';
            
            // 팝업 내용 생성
            var content = this.createContent(options);
            popup.innerHTML = content;
            
            // DOM에 추가
            document.body.appendChild(overlay);
            document.body.appendChild(popup);
            
            // 오버레이 클릭 시 닫기
            var self = this;
            overlay.onclick = function() {
                self.close();
            };
        },
        
        /**
         * DIVpopup 제거
         */
        removeDivPopup: function() {
            var overlay = document.getElementById('detailViewOverlay');
            var popup = document.getElementById('detailViewPopup');
            
            if (overlay) {
                overlay.parentNode.removeChild(overlay);
            }
            if (popup) {
                popup.parentNode.removeChild(popup);
            }
        },
        
        /**
         * 팝업 내용 HTML 생성
         */
        createContent: function(options) {
            var html = '<div class="wrapPopup">';
            
            // 팝업 타이틀
            html += '<div class="PopupTit">' + options.title;
            html += '<span><a href="javascript:void(0)" id="detailViewClose"><img src="/resources/imgs/Icon_close.png" /></a></span>';
            html += '</div>';
            html += '<div class="h10"></div>';
            
            // AP번호 등 정보 영역 (항상 표시)
            html += '<table class="SearchTable02" style="min-width:1200px; width:1200px;">';
            html += '<colgroup>';
            html += '<col width="100px" />';
            html += '<col width="250px" />';
            html += '<col width="120px" />';
            html += '<col width="250px" />';
            html += '<col width="120px" />';
            html += '<col width="360px" />';
            html += '</colgroup>';
            html += '<tr>';
            html += '<th>AP번호</th>';
            html += '<td><input class="input30" style="width:210px" id="detail_ap_number" value="' + (options.taxBillNo || '') + '" type="text" readonly/></td>';
            html += '<th>KeP담당자명</th>';
            html += '<td><input class="input30" style="width:210px" id="detail_manager_name" value="' + (options.managerName || '') + '" type="text" readonly/></td>';
            html += '<th>담당자연락처</th>';
            html += '<td><input class="input30" style="width:320px" id="detail_manager_contact" value="' + (options.managerContact || '') + '" type="text" readonly/></td>';
            html += '</tr>';
            html += '</table>';
            
            // IBSheet 영역 (기본 ID 사용)
            html += '<div id="popupDetailSheetContainer" class="ib-container" style="margin-top: 20px; width: 100%; height: 400px;">';
            html += '</div>';
            
            html += '<div class="h30"></div>';
            
            // 버튼 영역
            html += '<div class="PopupListBtnBox">';
            // html += '<div class="left"><button class="But_ExcelDown40" id="detailExcelBtn">엑셀다운로드</button>&nbsp;<button class="ButM_Outline" id="detailReportBtn">마감거래명세서 출력</button></div>';
            
            
            
              html += '<div class="left"><button class="But_ExcelDown40" id="detailExcelBtn">엑셀다운로드</button></div>';
            
            html += '<div class="right"><button class="ButMPrimary" id="detailConfirmBtn">확인</button></div>';





            html += '</div>';
            
            html += '</div>';
            
            return html;
        },
        
        /**
         * 이벤트 바인딩
         */
        bindEvents: function() {
            var self = this;

            // 닫기 버튼
            var closeBtn = document.getElementById('detailViewClose');
            if (closeBtn) {
                closeBtn.onclick = function() {
                    self.close();
                    return false;
                };
            }

            // 엑셀 다운로드 버튼
            var excelBtn = document.getElementById('detailExcelBtn');
            if (excelBtn) {
                excelBtn.onclick = function() {
                    self.downloadExcel();
                };
            }

            var reportBtn = document.getElementById('detailReportBtn');
            if (reportBtn) {
            	reportBtn.onclick = function() {
                    self.reportOpen();
                };
            }
            // 확인 버튼
            var confirmBtn = document.getElementById('detailConfirmBtn');
            if (confirmBtn) {
                confirmBtn.onclick = function() {
                    self.confirm();
                };
            }
        },
        
        
        /**
         * IBSheetWrapper를 사용한 IBSheet 초기화 및 컬럼 설정
         */
        initIBSheet: function() {
            console.log('[DetailViewPopup] IBSheet 초기화 시작');

            // IBSheetWrapper 인스턴스 생성
            if (!window.IBSheetWrapper) {
                console.error('[DetailViewPopup] IBSheetWrapper가 로드되지 않았습니다.');
                return;
            }

            // IBSheet 컬럼 정의 - 세금계산서 상세내역용
            var columns = [
                {Align:"Center", SaveName:"sStatus",        Header:"상태",           Type:"Status", Width:0, Edit:false, EditLen:0, Sort:0, Hidden:true},
                {Align:"Center", SaveName:"NO",             Header:"NO",             Type:"Seq", Width:50, Edit:false, EditLen:10, Sort:0, Hidden:false},
                {Align:"Left",   SaveName:"BUYER",     		Header:"BUYER",        Type:"Text", Width:150, Edit:false, EditLen:100, Sort:1, Hidden:true},
                {Align:"Left",   SaveName:"COMPYNAME",     Header:"고객사명",        Type:"Text", Width:150, Edit:false, EditLen:100, Sort:1, Hidden:false},
                {Align:"Center", SaveName:"PONO",          Header:"발주번호",        Type:"Text", Width:120, Edit:false, EditLen:20, Sort:1, Hidden:false},
                {Align:"Center", SaveName:"ORDER_DATE",     Header:"발주일",          Type:"Text", Width:100, Edit:false, EditLen:10, Sort:1, Hidden:false},
                {Align:"Left",   SaveName:"PURCHASER_DEPT", Header:"요청부서",        Type:"Text", Width:100, Edit:false, EditLen:100, Sort:1, Hidden:false},
                {Align:"Left",   SaveName:"REQUESTER_NAME", Header:"요청자",          Type:"Text", Width:80, Edit:false, EditLen:80, Sort:1, Hidden:false},
                {Align:"Center", SaveName:"ITEMCODE",      Header:"품목코드",        Type:"Text", Width:120, Edit:false, EditLen:20, Sort:1, Hidden:false},
                {Align:"Left",   SaveName:"ITEMNAME",     Header:"품명",           Type:"Text", Width:180, Edit:false, EditLen:100, Sort:1, Hidden:false},
                {Align:"Left",   SaveName:"SPEC",         Header:"규격",           Type:"Text", Width:150, Edit:false, EditLen:50, Sort:1, Hidden:false},
                {Align:"Right",  SaveName:"RECEIPTQTY",   Header:"입고수량",       Type:"Int", Width:80, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
                {Align:"Right",  SaveName:"RECEIPTPRICE", Header:"입고단가",       Type:"Int", Width:100, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
                {Align:"Right",  SaveName:"RECEIPTAMOUNT", Header:"입고금액",      Type:"Int", Width:120, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
                {Align:"Center", SaveName:"CONFIRMDATE",  Header:"확정일",         Type:"Date", Width:100, Edit:false, EditLen:10, Sort:1, Hidden:false},
                {Align:"Center", SaveName:"RECEIPTDATE",  Header:"입고일",         Type:"Date", Width:100, Edit:false, EditLen:10, Sort:1, Hidden:false}
            ];

            try {
                // IBSheetWrapper 초기화 (직접 createIBSheet 호출)
                var self = this;
                console.log('[DetailViewPopup] IBSheet 초기화 시작');

                // 1. 컨테이너 확인
                var container = document.getElementById('popupDetailSheetContainer');
                if (!container) {
                    console.error('[DetailViewPopup] ❌ IBSheet 컨테이너를 찾을 수 없습니다.');
                    return;
                }

                // 2. createIBSheet2 사용 (기본 시트 ID로 생성)
                console.log('[DetailViewPopup] createIBSheet2 호출');
                console.log('[DetailViewPopup] 컨테이너:', container);
                createIBSheet2(container, "popupDetailSheet", "100%", "400px");

                // 3. IBSheet 생성 확인 및 IBSheetWrapper 초기화

                    console.log('[DetailViewPopup] IBSheet 인스턴스 확인: popupDetailSheet');

                    if (typeof window.popupDetailSheet === 'undefined') {
                        console.error('[DetailViewPopup] ❌ IBSheet 인스턴스가 생성되지 않았습니다: popupDetailSheet');
                        console.log('[DetailViewPopup] createIBSheet2 함수 존재 여부:', typeof createIBSheet2 !== 'undefined');
                        console.log('[DetailViewPopup] 컨테이너 내용:', container.innerHTML);
                        return;
                    }

                    console.log('[DetailViewPopup] ✅ IBSheet 생성 성공: popupDetailSheet');

                    // IBSheetWrapper 초기화 (기본 시트 ID 사용)
                    self.sheetWrapper = new IBSheetWrapper("popupDetailSheet", "전자세금계산서상세내역");
                    self.sheetWrapper.initialize(columns, null, function() {
                        console.log('[DetailViewPopup] ✅ IBSheetWrapper 초기화 완료');
                        console.log('[DetailViewPopup] 시트 인스턴스:', this.sheet ? '준비완료' : '실패');

                        // 초기화 완료 후 즉시 데이터 로드
                        if (self.currentPopup && self.currentPopup.options && self.currentPopup.options.taxBillNo) {
                            var taxBillNo = self.currentPopup.options.taxBillNo;
                            console.log('[DetailViewPopup] 데이터 로드 시작:', taxBillNo);

                            // 검색 파라미터 구성
                            var searchParams = 'taxBillNo=' + encodeURIComponent(taxBillNo);

                            // IBSheetWrapper DoSearch 호출
                            if (self.sheetWrapper && self.sheetWrapper.DoSearch) {
                                self.sheetWrapper.DoSearch('/mpcl/getSellerMpClTaxDetailList.do', searchParams);
                            } else {
                                console.error('[DetailViewPopup] DoSearch 메서드를 찾을 수 없습니다.');
                            }
                        } else {
                            console.warn('[DetailViewPopup] taxBillNo가 없어 데이터를 로드하지 않습니다.');
                        }
                    });

                    self.sheetWrapper.setOnClick(function() {});
                    console.log('[DetailViewPopup] IBSheetWrapper 초기화 완료');

           

            } catch (e) {
                console.error('[DetailViewPopup] IBSheetWrapper 초기화 중 오류:', e);
                throw e;
            }
        },
        
        
        
        /**
         * 숫자 포맷팅
         */
        formatNumber: function(num) {
            if (!num) return '0';
            return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        },
        
        /**
         * 옵션 검증 함수
         */
        validateOptions: function(options) {
            // 필수 정보 검증
            if (!options.taxBillNo) {
                console.error('[DetailViewPopup] taxBillNo가 필요합니다.');
                throw new Error('taxBillNo가 필요합니다.');
            }

            if (!options.title) {
                console.warn('[DetailViewPopup] title이 설정되지 않았습니다.');
            }

            if (!options.width || !options.height) {
                console.warn('[DetailViewPopup] width 또는 height가 설정되지 않았습니다.');
            }

            // 콜백 함수 검증
            if (options.onConfirm && typeof options.onConfirm !== 'function') {
                console.error('[DetailViewPopup] onConfirm은 함수여야 합니다.');
            }

            if (options.onExcel && typeof options.onExcel !== 'function') {
                console.error('[DetailViewPopup] onExcel은 함수여야 합니다.');
            }
        },
        
        /**
         * IBSheetWrapper를 사용한 엑셀 다운로드
         */
        downloadExcel: function() {
            if (this.sheetWrapper && this.sheetWrapper.downloadExcel) {
                console.log('[DetailViewPopup] IBSheetWrapper를 사용한 엑셀 다운로드 실행');
                this.sheetWrapper.downloadExcel({
                    FileName: '전자세금계산서상세내역',
                    SheetName: '상세내역',
                    HiddenColumn: 1
                });
            } else {
                console.error('[DetailViewPopup] IBSheetWrapper가 초기화되지 않았거나 downloadExcel 메서드를 찾을 수 없습니다.');
                alert('엑셀 다운로드 기능을 사용할 수 없습니다.');
            }
        },
        /**
         * 마감거래명세서 출력
         */
        reportOpen: function() {
        	var customerCode = popupDetailSheet.GetCellValue(1,"BUYER");
        	reportOpen("RD_06_S_001_92","["+this.currentPopup.options.taxBillNo+"]["+customerCode+"]");
        },
        
        /**
         * 확인
         */
        confirm: function() {
            if (this.currentPopup && this.currentPopup.options && this.currentPopup.options.onConfirm) {
                console.log('[DetailViewPopup] 확인 버튼 클릭');
                this.currentPopup.options.onConfirm(this.currentData);
            } else {
                console.log('[DetailViewPopup] onConfirm 콜백이 설정되지 않아 팝업만 닫습니다.');
            }
            this.close();
        },
        
        /**
         * 팝업 닫기
         */
        close: function() {
            console.log('[DetailViewPopup] 팝업을 닫습니다.');

            // 1. IBSheet 완전 정리 (Dispose 호출)
            if (window.popupDetailSheet) {
                try {
                    console.log('[DetailViewPopup] IBSheet Dispose 호출');
                    if (typeof window.popupDetailSheet.Dispose === 'function') {
                        window.popupDetailSheet.Dispose();
                    }
                    window.popupDetailSheet = null;
                    delete window.popupDetailSheet;
                    console.log('[DetailViewPopup] ✅ IBSheet 인스턴스 완전 정리 완료');
                } catch (e) {
                    console.warn('[DetailViewPopup] IBSheet 정리 중 오류:', e);
                }
            }

            // 2. IBSheetWrapper 정리
            if (this.sheetWrapper) {
                try {
                    // IBSheetWrapper에 destroy 메서드가 있다면 호출
                    if (typeof this.sheetWrapper.destroy === 'function') {
                        this.sheetWrapper.destroy();
                    }
                    this.sheetWrapper = null;
                    console.log('[DetailViewPopup] ✅ IBSheetWrapper 정리 완료');
                } catch (e) {
                    console.warn('[DetailViewPopup] IBSheetWrapper 정리 중 오류:', e);
                }
            }

            // 3. DOM 요소 정리
            var container = document.getElementById('popupDetailSheetContainer');
            if (container) {
                try {
                    container.innerHTML = '';
                    console.log('[DetailViewPopup] ✅ 컨테이너 DOM 정리 완료');
                } catch (e) {
                    console.warn('[DetailViewPopup] 컨테이너 정리 중 오류:', e);
                }
            }

            // 4. 팝업 DOM 제거
            this.removeDivPopup();

            // 5. 상태 초기화
            this.currentPopup = null;
            this.currentData = [];
            this.currentSheetId = null;

            console.log('[DetailViewPopup] ✅ 팝업 정리 완료');
        },
        
        /**
         * IBSheetWrapper를 사용한 데이터 로드
         */
        loadDataWithIBSheet: function(taxBillNo) {
            console.log('[DetailViewPopup] IBSheet를 사용하여 데이터를 로드합니다. 세금계산서번호:', taxBillNo);

            if (!taxBillNo) {
                console.error('[DetailViewPopup] 세금계산서 번호가 없습니다.');
                return;
            }

            if (!this.sheetWrapper) {
                console.error('[DetailViewPopup] IBSheetWrapper가 초기화되지 않았습니다.');
                return;
            }

            // 검색 파라미터 구성
            var searchParams = 'taxBillNo=' + encodeURIComponent(taxBillNo);

            // IBSheetWrapper를 통한 DoSearch (자동 로딩 및 검증 포함)
            if (this.sheetWrapper && this.sheetWrapper.DoSearch) {
                this.sheetWrapper.DoSearch('/mpcl/getSellerMpClTaxDetailList.do', searchParams);
                console.log('[DetailViewPopup] IBSheetWrapper DoSearch 실행 완료');
            } else {
                console.error('[DetailViewPopup] IBSheetWrapper DoSearch 메서드를 찾을 수 없습니다.');
            }
        }
        

    };
    
    // 전역 객체로 등록
    window.DetailViewPopup = DetailViewPopup;
    
})(window);