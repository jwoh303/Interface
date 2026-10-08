<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%--
  탭2: 마감내역(품목별)
  부모 페이지: sellerMpClClosInfoList_v2.jsp
--%>
<div id="Search1" class="SearchContent active">
    <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> “마감내역(품목별)” 탭에서는 현재 기준으로 확정된 상세 마감내역을 확인할 수 있습니다.</div>
    <table class="TabSearchTable" >
        <colgroup>
            <col width="90px" />
            <col width="380px" />
            <col width="90px" />
            <col width="320px" />
            <col width="90px" />
            <col width="310px" />
        </colgroup>           	
        <tr>
            <th>마감년월</th>
            <td>
                <div class="datepicker-wrap" style="width:120px; display:inline-block; vertical-align:middle;">
                    <div class="date-input">
                        <input type="text" id="st_from_date" readonly />
                        <span></span>
                    </div>
                </div>
                <button class="But_Month" id="btnPrevMonth">-1개월</button>
                <button class="But_Month" id="btnCurrentMonth">당월</button>
            </td>
            <th>고객사명</th>
            <td>
                <!-- 텍스트 입력 형태로 변경 (2025-01-30) -->
                <input class="input30" style="width:260px" name="st_buyer_name" id="st_buyer_name" type="text" placeholder="고객사명" />

                <%-- 기존 검색 버튼 형태 (주석 처리)
                <div class="SearchBuyer" style="width:280px ">
                    <input type="text" placeholder="고객사명" id="st_buyer_name" value="" style=" width:85%; " >
                    <button type="button" class="buyer-search-btn"
                            data-target-input="st_buyer_name"
                            data-target-code="st_buyer_code">고객사검색버튼</button>
                </div>
                --%>
            </td>
            <th>발주번호</th>
            <td><input class="input30" style="width:260px" name="st_order_no" id="st_order_no" type="text" /></td>               
        </tr>
        <tr>
            <th>품목코드</th>
            <td><input class="input30" style="width:239px" name="st_item_code" id="st_item_code" type="text" /></td>
            <th>담당자명</th>
            <td><input class="input30" style="width:260px" name="st_manager_name" id="st_manager_name" type="text" /></td>
            <th>계산서번호</th>
            <td><input class="input30" style="width:260px" name="st_invoice_no" id="st_invoice_no" type="text" /></td>
        </tr>
    </table>
    <div class="SearchBtnBox">
        <button class="ButSmall_Outline">초기화</button>
        <button class="ButMSmallDarkGray" id="btnSearch01">조회</button>
    </div>
    <div class="ListBtnBox">
        <div class="left"><button class="But_ExcelDown40">엑셀다운로드</button></div>

    </div>
    
    <!--grid-->
    <div class="ib-container">
        <script type="text/javascript">
            createIBSheet("mySheet1", "100%", "500px");
        </script>
    </div>
</div><!--Search1 끝 -->

<!-- Tab2 전용 스크립트 (클로저 패턴) -->
<script type="text/javascript">
MRO.TabManager.registerModule('tab2', function(parent) {
    'use strict';

    var sheetWrapper = null;
    var sheet = null;
    var datePicker = null;
    var searchParams = {};
    var tagBox = null;
    
    // 폼 필드 전역 참조
    var paramFields = {
        fromDate: null,
        // buyerCode: null,  // 기존 고객사 코드 (주석 처리 - 2025-01-30: 텍스트 입력 형태로 변경)
        orderNo: null,
        itemCode: null,
        managerName: null,
        invoiceNo: null,
        buyerName: null   // 고객사명 텍스트 입력 필드
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
        var st_cl_month = monthRange.from;

        var st_com_code = parent.getCommonData('sessionComCode') || '';
        var st_buyer_code = ''; // 고객사 코드는 빈 값으로 설정 (텍스트 입력 형태로 변경)
        var st_buyer_name = paramFields.buyerName ? paramFields.buyerName.value : ''; // 고객사명 텍스트 입력 추가 (2025-01-30)
        var st_ap_yn = 'Y';// 마감 확정내역은 항상 Y로 고정
        var st_order_no = paramFields.orderNo ? paramFields.orderNo.value : '';
        var st_item_code = paramFields.itemCode ? paramFields.itemCode.value : '';
        var st_manager_name = paramFields.managerName ? paramFields.managerName.value : '';
        var st_invoice_no = paramFields.invoiceNo ? paramFields.invoiceNo.value : '';

        var params = "st_com_code=" + encodeURIComponent(st_com_code) +
                  "&st_cl_month=" + encodeURIComponent(st_cl_month) +
                  "&st_from_date=" + encodeURIComponent(monthRange.from) +
                  "&st_to_date=" + encodeURIComponent(monthRange.to) +
                  "&st_buyer_code=" + encodeURIComponent(st_buyer_code) +
                  "&st_buyer_name=" + encodeURIComponent(st_buyer_name) +
                  "&st_ap_yn=" + encodeURIComponent(st_ap_yn) +
                  "&st_order_no=" + encodeURIComponent(st_order_no) +
                  "&st_item_code=" + encodeURIComponent(st_item_code) +
                  "&st_manager_name=" + encodeURIComponent(st_manager_name) +
                  "&st_invoice_no=" + encodeURIComponent(st_invoice_no) +
                  "&s_SAVENAME=";

        return params;
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

    function setupEventHandlers() {
        // Search1 컨테이너 내에서 버튼 찾기
        var searchBtn = tagBox.querySelector('#btnSearch01');
        var resetBtn = tagBox.querySelector('.ButSmall_Outline');
        var excelBtn = tagBox.querySelector('.But_ExcelDown40');
        var prevMonthBtn = tagBox.querySelector('#btnPrevMonth');
        var currentMonthBtn = tagBox.querySelector('#btnCurrentMonth');

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

        // 월 이동 버튼 이벤트
        if (prevMonthBtn) {
            prevMonthBtn.onclick = function() {
                setCurrentMonth(-1);
            };
        }

        if (currentMonthBtn) {
            currentMonthBtn.onclick = function() {
                setCurrentMonth(0);
            };
        }

        // Enter key event handlers for all text search inputs
        if (paramFields.buyerName) {
            $(paramFields.buyerName).on("keypress", function(e) {
                if (e.which === 13 || e.keyCode === 13) {
                    e.preventDefault();
                    publicAPI.search();
                }
            });
        }

        if (paramFields.orderNo) {
            $(paramFields.orderNo).on("keypress", function(e) {
                if (e.which === 13 || e.keyCode === 13) {
                    e.preventDefault();
                    publicAPI.search();
                }
            });
        }

        if (paramFields.itemCode) {
            $(paramFields.itemCode).on("keypress", function(e) {
                if (e.which === 13 || e.keyCode === 13) {
                    e.preventDefault();
                    publicAPI.search();
                }
            });
        }

        if (paramFields.managerName) {
            $(paramFields.managerName).on("keypress", function(e) {
                if (e.which === 13 || e.keyCode === 13) {
                    e.preventDefault();
                    publicAPI.search();
                }
            });
        }

        if (paramFields.invoiceNo) {
            $(paramFields.invoiceNo).on("keypress", function(e) {
                if (e.which === 13 || e.keyCode === 13) {
                    e.preventDefault();
                    publicAPI.search();
                }
            });
        }

        /* 기존 고객사명 검색 버튼 로직 (주석 처리 - 2025-01-30)
        // 고객사명 필드 변경 시 코드 동기화
        var buyerNameInput = tagBox.querySelector('#st_buyer_name');
        if (buyerNameInput) {
            buyerNameInput.oninput = function() {
                if (this.value === '') {
                    // 고객사명이 비워지면 코드도 비움
                    if (paramFields.buyerCode) {
                        paramFields.buyerCode.value = '';
                    }
                }
            };
        }
        */

    }
    
    
    
    
    
    // ============ Public API (외부 노출) ============
    var publicAPI = {
        // 초기화
        init: function() {
            // Search1 컨테이너 초기화
            tagBox = document.getElementById('Search1');
            if (!tagBox) {
                return;
            }

            // 폼 필드 참조 초기화
            paramFields.fromDate = tagBox.querySelector('#st_from_date');
            paramFields.orderNo = tagBox.querySelector('#st_order_no');
            paramFields.itemCode = tagBox.querySelector('#st_item_code');
            paramFields.managerName = tagBox.querySelector('#st_manager_name');
            paramFields.invoiceNo = tagBox.querySelector('#st_invoice_no');
            paramFields.buyerName = tagBox.querySelector('#st_buyer_name'); // 고객사명 텍스트 입력 필드

            // IBSheet 초기화 및 설정
            this.initIBSheet();

            // Month Picker 초기화 (DatePicker.js 사용 - type: 'month')
            if (typeof DatePicker !== 'undefined') {
                if (paramFields.fromDate) {
                    try {
                        datePicker = new DatePicker({
                            type: 'month',              // 년/월만 선택
                            targetId: 'st_from_date',
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

            // IBSheet 컬럼 정의 - 실제 데이터가 있는 필드들로 구성 (픽셀 단위, 총 1280px)
            var columns = [
			{Align:"Center", SaveName:"sStatus",        Header:"상태",           Type:"Status", Width:100, Edit:false, EditLen:0, Sort:0, Hidden:true},
			{Align:"Center", SaveName:"NO",             Header:"NO",             Type:"Seq", Width:30, Edit:false, EditLen:10, Sort:0, Hidden:true},
			{Align:"Center", SaveName:"CLOSE_MONTH",    Header:"마감년월",        Type:"Text", Width:100, Edit:false, EditLen:10, Sort:1, Hidden:false, Format:"yyyy/MM"},
			{Align:"Left",   SaveName:"BUYER_NAME",     Header:"고객사명",        Type:"Text", Width:200, Edit:false, EditLen:100, Sort:1, Hidden:false},
			{Align:"Center", SaveName:"BUYER",          Header:"고객사코드",      Type:"Text", Width:100, Edit:false, EditLen:20, Sort:1, Hidden:false},
			{Align:"Center", SaveName:"PO_NO",          Header:"발주번호",        Type:"Text", Width:120, Edit:false, EditLen:20, Sort:1, Hidden:false},
			{Align:"Center", SaveName:"PO_SEQ",         Header:"발주항번",        Type:"Text", Width:70, Edit:false, EditLen:10, Sort:1, Hidden:false},
			{Align:"Center", SaveName:"ORDER_DATE",     Header:"발주일",          Type:"Text", Width:100, Edit:false, EditLen:10, Sort:1, Hidden:false, Format:"yyyy/MM/dd"},
			{Align:"Left",   SaveName:"PURCHASER_DEPT", Header:"요청부서",        Type:"Text", Width:100, Edit:false, EditLen:100, Sort:1, Hidden:false},
			{Align:"Left",   SaveName:"REQUESTER_NAME", Header:"요청자",          Type:"Text", Width:80, Edit:false, EditLen:80, Sort:1, Hidden:false},
			{Align:"Center", SaveName:"BUYER_ITEM_NO",  Header:"품목코드",        Type:"Text", Width:120, Edit:false, EditLen:20, Sort:1, Hidden:false},
			{Align:"Left",   SaveName:"DESCRIPTION",    Header:"품명",           Type:"Text", Width:150, Edit:false, EditLen:100, Sort:1, Hidden:false},
			{Align:"Left",   SaveName:"SPECIFICATION",  Header:"규격",           Type:"Text", Width:150, Edit:false, EditLen:50, Sort:1, Hidden:false},
			{Align:"Right",  SaveName:"GR_QTY",         Header:"입고수량",       Type:"Int", Width:80, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
			{Align:"Right",  SaveName:"AGENT_PRICE",    Header:"입고단가",       Type:"Int", Width:100, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
			{Align:"Right",  SaveName:"GR_AMT",         Header:"입고금액",       Type:"Int", Width:100, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
			{Align:"Center", SaveName:"DELIVERY_DATE",  Header:"확정일",         Type:"Date", Width:100, Edit:false, EditLen:10, Sort:1, Hidden:true, Format:"yyyy/MM/dd"},
			{Align:"Center", SaveName:"DS_DATE",        Header:"입고일",         Type:"Date", Width:100, Edit:false, EditLen:10, Sort:1, Hidden:false, Format:"yyyy/MM/dd"},
			{Align:"Left", SaveName:"KEP_USER_NAME",  Header:"KeP담당자",      Type:"Text", Width:80, Edit:false, EditLen:50, Sort:1, Hidden:false},
			{Align:"Left", SaveName:"KEP_USER_PHONE", Header:"KeP담당자연락처", Type:"Text", Width:120, Edit:false, EditLen:20, Sort:1, Hidden:false},
			{Align:"Center", SaveName:"CONTRACT_NO",    Header:"계산서번호",      Type:"Text", Width:200, Edit:false, EditLen:20, Sort:1, Hidden:false}
		];


                // IBSheetWrapper 초기화
                sheetWrapper = new IBSheetWrapper("mySheet1", "마감확정내역");
                sheetWrapper.initialize(columns);
                sheetWrapper.setOnClick(function() {});
                sheetWrapper.SetOnSearchEnd(function(code, Msg, StCode, StMsg, response) {});


        },
        
        // 탭 활성화 시
        activate: function() {
            console.log('[Tab2] 마감내역(품목별) 탭 활성화됨');
            console.log('[Tab2] 현재 검색 파라미터:', searchParams);
            // 탭 활성화 시 자동 조회
            this.search();
        },

        // 탭 비활성화 시
        deactivate: function() {
            // 필요시 리소스 정리
        },

        // 검색 실행
        search: function search() {
            var isValid = validateSearchForm();

            if (!isValid) {
                return false;
            }

            searchParams = buildSearchParams();

            // IBSheetWrapper를 통한 DoSearch (자동 로딩 및 검증 포함)
            if (sheetWrapper && sheetWrapper.DoSearch) {
                sheetWrapper.DoSearch('/mpcl/getSellerMpClClosInfoList_v2.do', searchParams);
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

            // 폼 필드 초기화
            // if (paramFields.buyerCode) paramFields.buyerCode.value = ''; // 기존 고객사 코드 초기화 (주석 처리 - 2025-01-30)
            if (paramFields.orderNo) paramFields.orderNo.value = '';
            if (paramFields.itemCode) paramFields.itemCode.value = '';
            if (paramFields.managerName) paramFields.managerName.value = '';
            if (paramFields.invoiceNo) paramFields.invoiceNo.value = '';
            if (paramFields.buyerName) paramFields.buyerName.value = ''; // 고객사명 텍스트 입력 초기화

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
                    FileName: '마감확정내역',
                    SheetName: '마감확정내역',
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
            return sheetWrapper ? sheetWrapper.sheet : null;
        },
        
        // IBSheetWrapper 인스턴스 조회 (필요시)
        getSheetWrapper: function() {
            return sheetWrapper;
        },
        
    };
    
    return publicAPI;
});
</script>