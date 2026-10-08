<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%--
  탭3: 물류비발행내역
  부모 페이지: sellerMpClClosInfoList_v2.jsp
--%>
<div id="Search4" class="SearchContent">
          <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> "물류비발행내역"탭은 물류센터로 납품한 상품에 대한 물류수수료 발행 내역을 확인하실 수 있습니다. </div>
          <table class="TabSearchTable" >
            <colgroup>
              <col width="90px" />
              <col width="380px" />
              <col width="90px" />
              <col width="190px" />
              <col width="90px" />
              <col width="190px" />
              <col width="90px" />
              <col width="160px" />
            </colgroup>          	
            <tr>
              <th>마감년월</th>
              <td>
                <div class="datepicker-wrap" style="width:120px; display:inline-block; vertical-align:middle;">
                    <div class="date-input">
                        <input type="text" id="st_date" readonly />
                        <span></span>
                    </div>
                </div>
                <button class="But_Month" id="btnPrevMonth4">-1개월</button>
                <button class="But_Month" id="btnCurrentMonth4">당월</button>
              </td>
              <th>고객사명</th>
              <td>
                <!-- 텍스트 입력 형태로 변경 (2025-01-30) -->
                <input class="input30" style="width:170px; border:1px solid #d5d5d5;" name="st_buyer_name_tab4" id="st_buyer_name_tab4" type="text" placeholder="고객사명" />

                <%-- 기존 검색 버튼 형태 (주석 처리)
                <div class="SearchBuyer" style="width:180px ">
                  <input type="text" placeholder="고객사명" id="st_buyer_name_tab4" value="" style=" width:85%; " >
                  <button type="button" class="buyer-search-btn"
                          data-target-input="st_buyer_name_tab4"
                          data-target-code="st_buyer_code">고객사검색버튼</button>
                </div>
                --%>
			  </td>
              <th>물류센터명</th>
              <td><input class="input30" style="width:170px" id="st_warehouse_name_tab4" type="text" /></td>               
              <th>발주번호</th>
              <td><input class="input30" style="width:170px" id="st_po_no_tab4" type="text" /></td>

            </tr>            
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" >초기화</button> 
        	<button class="ButMSmallDarkGray" >조회</button> 
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40" >엑셀다운로드</button></div>
            <div class="right"> </div>
          </div>


    <!--grid-->
    <div class="ib-container">
        <script type="text/javascript">
            createIBSheet("sheet4", "100%", "500px");
        </script>
    </div>
</div><!--Search4 끝 -->

<!-- Tab4 전용 스크립트 (클로저 패턴) -->
<script type="text/javascript">

MRO.TabManager.registerModule('tab4', function(parent) {
    'use strict';

    var sheetWrapper = null;
    var sheet = null;
    var datePicker = null;
    var searchParams = {};
    var tagBox = null;

    // 폼 필드 전역 참조
    var paramFields = {
        date: null,

        buyerName: null,
        warehouseName: null,
        poNo: null,
        logisType: null
    };
    
    // Private 함수 - 외부에서 접근 불가
    function validateSearchForm() {
        // ValidationManager 제거됨 - 항상 true 반환
        return true;
    }

    // 실시간 validation 이벤트 설정 함수 (ValidationManager 제거됨)
    function setupValidationEvents() {
        // ValidationManager 제거로 인해 함수 비어있음
    }

    function buildSearchParams() {
        // datePicker를 통해 날짜 가져오기 (month 타입 - YYYYMM 형식)
        var monthRange = datePicker ? datePicker.getMonthRangePure() : {from: '', to: ''};

        // month 타입은 이미 YYYYMM 형식이므로 그대로 사용
        var st_from_date = monthRange.from;

        // 세션 정보
        var st_user_id = parent.getCommonData('sessionUserId') || '';
        var st_com_code = parent.getCommonData('sessionComCode') || '';
        var st_buyer_code = ''; // 고객사 코드는 빈 값으로 설정 (텍스트 입력 형태로 변경)
        var st_buyer_name = paramFields.buyerName ? paramFields.buyerName.value : ''; // 고객사명 텍스트 입력
        var st_warehouse_name = paramFields.warehouseName ? paramFields.warehouseName.value : '';
        var st_po_no = paramFields.poNo ? paramFields.poNo.value : '';
        var st_logis_type = 'ALL'; // HTML에 선택 옵션이 없으므로 기본값

        var params = "st_com_code=" + encodeURIComponent(st_com_code) +
               "&st_user_id=" + encodeURIComponent(st_user_id) +
               "&st_from_date=" + encodeURIComponent(st_from_date) +
               "&st_buyer_code=" + encodeURIComponent(st_buyer_code) +
               "&st_buyer_name=" + encodeURIComponent(st_buyer_name) +
               "&st_warehouse_name=" + encodeURIComponent(st_warehouse_name) +
               "&st_po_no=" + encodeURIComponent(st_po_no) +
               "&st_logis_type=" + encodeURIComponent(st_logis_type) +
               "&s_SAVENAME=";

        return params;
    }
    
    function calculateTotalLogisAmount(data) {
        var total = 0;
        if (data && data.length > 0) {
            for (var i = 0; i < data.length; i++) {
                var amount = parseFloat(data[i].LOGIS_AMT || 0);
                total += amount;
            }
        }
        
        // 총 금액 표시 (천 단위 콤마)
        var totalElement = document.getElementById('total-logis-amount-tab4');
        if (totalElement) {
            totalElement.textContent = total.toLocaleString();
        }
    }
    
    function setupEventHandlers() {
        // Search4 컨테이너 내에서 버튼 찾기
        var searchBtn = tagBox.querySelector('.ButMSmallDarkGray');  // 조회 버튼
        var resetBtn = tagBox.querySelector('.ButSmall_Outline');    // 초기화 버튼
        var excelBtn = tagBox.querySelector('.But_ExcelDown40');     // 엑셀다운로드 버튼
        var prevMonthBtn = tagBox.querySelector('#btnPrevMonth4');   // -1개월
        var currentMonthBtn = tagBox.querySelector('#btnCurrentMonth4'); // 당월

        // 조회 버튼 이벤트
        if (searchBtn) {
            searchBtn.onclick = function() {
                publicAPI.search();
            };
        }

        if (resetBtn) {
            resetBtn.onclick = function() {
                publicAPI.reset();
            };
        }

        if (excelBtn) {
            excelBtn.onclick = function() {
                publicAPI.exportExcel();
            };
        }

        // -1개월 버튼 이벤트
        if (prevMonthBtn) {
            prevMonthBtn.onclick = function() {
                setCurrentMonth(-1);
            };
        }

        // 당월 버튼 이벤트
        if (currentMonthBtn) {
            currentMonthBtn.onclick = function() {
                setCurrentMonth(0);
            };
        }

        // Enter key event handlers for text search inputs
        if (paramFields.buyerName) {
            $(paramFields.buyerName).on("keypress", function(e) {
                if (e.which === 13 || e.keyCode === 13) {
                    e.preventDefault();
                    publicAPI.search();
                }
            });
        }

        if (paramFields.warehouseName) {
            $(paramFields.warehouseName).on("keypress", function(e) {
                if (e.which === 13 || e.keyCode === 13) {
                    e.preventDefault();
                    publicAPI.search();
                }
            });
        }

        if (paramFields.poNo) {
            $(paramFields.poNo).on("keypress", function(e) {
                if (e.which === 13 || e.keyCode === 13) {
                    e.preventDefault();
                    publicAPI.search();
                }
            });
        }



    }

    function setCurrentMonth(monthOffset) {
        if (!datePicker) return;

        var currentDate = datePicker.selectedDate || new Date();
        if (monthOffset === 0) {
            // 당월
            datePicker.setDate(new Date());
        } else {
            // -1개월
            var newDate = new Date(currentDate);
            newDate.setMonth(currentDate.getMonth() + monthOffset);
            datePicker.setDate(newDate);
        }
    }
    
    // ============ Public API (외부 노출) ============
    var publicAPI = {
        // 초기화
        init: function() {
            // Search4 컨테이너 초기화
            tagBox = document.getElementById('Search4');
            if (!tagBox) {
                return;
            }

            // 폼 필드 참조 초기화 (실제 HTML ID에 맞춰 수정)
            paramFields.date = tagBox.querySelector('#st_date');
            paramFields.buyerName = tagBox.querySelector('#st_buyer_name_tab4');
            paramFields.warehouseName = tagBox.querySelector('#st_warehouse_name_tab4');
            paramFields.poNo = tagBox.querySelector('#st_po_no_tab4');

            // 물류 구분 선택 필드는 HTML에 없으므로 null로 설정
            paramFields.logisType = null;

            // IBSheet 초기화 및 설정
            this.initIBSheet();

            // Month Picker 초기화 (DatePicker.js 사용 - type: 'month')
            if (typeof DatePicker !== 'undefined') {
                if (paramFields.date) {
                    try {
                        datePicker = new DatePicker({
                            type: 'month',              // 년/월만 선택
                            targetId: 'st_date',
                            dateFormat: '/',            // YYYY/MM 형식
                            locale: 'ko',
                            defaultDate: 'today'
                        });

                        datePicker.init();
                    } catch (error) {
                        // DatePicker 초기화 실패 시 무시
                    }
                }
            }

            setupEventHandlers();

            // 실시간 validation 이벤트 설정
            setupValidationEvents();
        },
        
        // IBSheetWrapper를 사용한 IBSheet 초기화 및 컬럼 설정
        initIBSheet: function() {
            // IBSheetWrapper 인스턴스 생성
            if (!window.IBSheetWrapper) {
                return;
            }

            // IBSheet 컬럼 정의 - 픽셀 단위로 전체 화면 채우기 (총 1280px 기준)
            var columns = [
                {Align:"Center", SaveName:"sStatus", Header:"상태", Type:"Status", Width:0, Edit:false, EditLen:0, Sort:0, Hidden:true},
                {Align:"Left",   SaveName:"WAREHOUSE_CODE_TEXT", Header:"물류센터명", Type:"Text", Width:210, Edit:false, EditLen:100, Sort:1, Hidden:false},
                {Align:"Left",   SaveName:"BUYER_NAME", Header:"고객사명", Type:"Text", Width:200, Edit:false, EditLen:100, Sort:1, Hidden:false},
                {Align:"Center", SaveName:"ISSUE_DATE", Header:"발행일", Type:"Text", Width:100, Edit:false, EditLen:10, Sort:1, Hidden:false},
                {Align:"Center", SaveName:"PO_NO", Header:"발주번호", Type:"Text", Width:100, Edit:false, EditLen:20, Sort:1, Hidden:false},
                {Align:"Center", SaveName:"PO_SEQ", Header:"발주항번", Type:"Text", Width:100, Edit:false, EditLen:10, Sort:1, Hidden:true},
                {Align:"Center", SaveName:"BUYER_ITEM_NO", Header:"품목코드", Type:"Text", Width:150, Edit:false, EditLen:20, Sort:1, Hidden:false},
                {Align:"Left",   SaveName:"DESCRIPTION", Header:"품명", Type:"Text", Width:150, Edit:false, EditLen:100, Sort:1, Hidden:false},
                {Align:"Left",   SaveName:"SPECIFICATION", Header:"규격", Type:"Text", Width:150, Edit:false, EditLen:50, Sort:1, Hidden:false},
                {Align:"Right",  SaveName:"AGENT_PRICE", Header:"단가", Type:"Int", Width:70, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
                {Align:"Center", SaveName:"UNIT_MEASURE", Header:"단위", Type:"Text", Width:50, Edit:false, EditLen:10, Sort:1, Hidden:true},
                {Align:"Right",  SaveName:"GR_QTY", Header:"입고수량", Type:"Int", Width:75, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
                {Align:"Right",  SaveName:"AGENT_ITEM_AMT", Header:"입고금액", Type:"Int", Width:100, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
                {Align:"Right",  SaveName:"LOGIS_AMT", Header:"물류위탁수수료", Type:"Int", Width:100, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
                {Align:"Left", SaveName:"KEP_USER_NAME", Header:"물류수수료 협의 담당자", Type:"Text", Width:170, Edit:false, EditLen:50, Sort:1, Hidden:false},
                {Align:"Left", SaveName:"KEP_USER_PHONE", Header:"연락처", Type:"Text", Width:100, Edit:false, EditLen:20, Sort:1, Hidden:true},
                {Align:"Center", SaveName:"LOGIS_TYPE", Header:"구분", Type:"Text", Width:50, Edit:false, EditLen:10, Sort:1, Hidden:true}
            ];

            try {
                sheetWrapper = new IBSheetWrapper("sheet4", "물류비발행내역");
                sheetWrapper.initialize(columns);
                sheetWrapper.setOnClick(function() {});
                sheetWrapper.SetOnSearchEnd(function(data) {
                    calculateTotalLogisAmount(data);
                });

                // OnRowSearchEnd 이벤트 설정 - 날짜 포맷 변환
                sheetWrapper.setOnRowSearchEnd(function(row) {
                    // 발행일(ISSUE_DATE) 포맷 변경: 모든 형식을 YYYY/MM/DD로 변환
                    var issueDate = this.sheet.GetCellValue(row, "ISSUE_DATE");
                    if (issueDate) {
                        var formatted = '';
                        issueDate = String(issueDate).trim();

                        // YYYYMMDD 형식 (20251114)
                        if (/^\d{8}$/.test(issueDate)) {
                            formatted = issueDate.substring(0, 4) + '/' + issueDate.substring(4, 6) + '/' + issueDate.substring(6, 8);
                        }
                        // YYYY-MM-DD, YYYY.MM.DD 형식
                        else if (issueDate.indexOf('-') > -1 || issueDate.indexOf('.') > -1) {
                            formatted = issueDate.replace(/[-\.]/g, '/');
                        }
                        // 이미 YYYY/MM/DD 형식이면 그대로
                        else {
                            formatted = issueDate;
                        }

                        if (formatted && formatted !== issueDate) {
                            this.sheet.SetCellValue(row, "ISSUE_DATE", formatted);
                        }
                    }
                });
            } catch (e) {
                throw e;
            }
        },
        
        // 탭 활성화 시
        activate: function() {
            console.log('[Tab4] 물류비발행내역 탭 활성화됨');
            console.log('[Tab4] 현재 검색 파라미터:', searchParams);
            // 탭 활성화 시 자동 조회
            this.search();
        },

        // 탭 비활성화 시
        deactivate: function() {
            // 필요시 리소스 정리
        },

        // 검색 실행
        search: function() {
            var isValid = validateSearchForm();

            if (!isValid) {
                return false;
            }

            searchParams = buildSearchParams();

            // IBSheetWrapper를 통한 DoSearch (자동 로딩 및 검증 포함)
            if (sheetWrapper && sheetWrapper.DoSearch) {
                sheetWrapper.DoSearch('/mpcl/getSellerMpClLogisRateDetailList_v2.do', searchParams);
                return true;
            }

            return false;
        },
        
        // 초기화
        reset: function() {
            // Month Picker 초기화 - 현재 월로 설정
            if (datePicker) {
                datePicker.setDate(new Date());
            }

            // 폼 필드 초기화 (공통 필드는 TabManager에서 관리)
            if (paramFields.buyerName) paramFields.buyerName.value = '';
            if (paramFields.warehouseName) paramFields.warehouseName.value = '';
            if (paramFields.poNo) paramFields.poNo.value = '';
            // buyerCode는 공통 필드이므로 탭 전환 시 자동 초기화됨
            // logisType 필드는 HTML에 없으므로 생략

            // IBSheet 초기화
            if (sheetWrapper && sheetWrapper.removeAll) {
                sheetWrapper.removeAll();
            }

            // ValidationManager 제거됨 - Validation 상태 초기화 불필요

            // 검색 파라미터 초기화
            searchParams = {};
        },
        
        // 엑셀 다운로드
        exportExcel: function() {
            // IBSheetWrapper의 downloadExcel 메서드 사용 (자동 검증 포함)
            if (sheetWrapper && sheetWrapper.downloadExcel) {
                sheetWrapper.downloadExcel({
                    FileName: '물류비발행내역',
                    SheetName: '물류비발행내역',
                    HiddenColumn: 1
                });
            } else {
                alert('엑셀 다운로드 기능을 사용할 수 없습니다.');
            }
        },
        
        // 현재 검색 파라미터 조회 (다른 탭에서 필요시)
        getSearchParams: function() {
            return searchParams;
        },
        
        // Sheet 객체 조회 (필요시)
        getSheet: function() {
            return sheet;
        },
        
        // IBSheetWrapper 인스턴스 조회 (필요시)
        getSheetWrapper: function() {
            return sheetWrapper;
        },
        
    };
    
    return publicAPI;
});

</script>