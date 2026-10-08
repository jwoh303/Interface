<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%-- 탭1: 마감내역(계산서별) --%>
<div id="Search2" class="SearchContent">
    <%-- <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> "전자세금계산서내역"탭은 계산서 발행단위로 금액과 담당자를 확인하실 수 있습니다. 상세내역 [보기] 버튼 클릭 시, 해당 계산서의 상세 발주내역 확인 가능합니다.</div> --%>
<div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> “마감내역(계산서별)” 탭에서는 계산서 발행 단위로 금액과 담당자를 확인할 수 있습니다. 상세내역란의 [보기] 버튼을 클릭하면 해당 계산서의 발주 세부내역을 확인할 수 있습니다.</div>
    <table class="TabSearchTable" >
        <colgroup>
            <col width="90px" />
            <col width="380px" />
            <col width="90px" />
            <col width="720px" />
        </colgroup>           	
        <tr>
            <th>마감년월</th>
            <td>
                <div class="datepicker-wrap" style="width:120px; display:inline-block; vertical-align:middle;">
                    <div class="date-input">
                        <input type="text" id="st_cl_date" readonly />
                        <span></span>
                    </div>
                </div>
                <button class="But_Month" id="btnPrevMonth2">-1개월</button>
                <button class="But_Month" id="btnCurrentMonth2">당월</button>
            </td>
            <th>KeP담당자</th>
            <td><input class="input30" style="width:300px" name="st_kep_manager" id="st_kep_manager" type="text" /></td>                   
        </tr>
    </table>
    <input type="hidden" id="st_site" value="KA" />
    
    <div class="SearchBtnBox">
        <button class="ButSmall_Outline">초기화</button> 
        <button class="ButMSmallDarkGray" id="btnSearch02">조회</button> 
    </div>
    <div class="ListBtnBox">
        <div class="left"><button class="But_ExcelDown40">엑셀다운로드</button></div>
       
    </div> 
    
    <!--grid-->
    <div class="ib-container">
        <script type="text/javascript">
            createIBSheet("mySheet2", "100%", "500px");
        </script>
    </div>
</div><!--Search2 끝 -->

<!-- Tab1 전용 스크립트 (클로저 패턴) -->
<script type="text/javascript">
MRO.TabManager.registerModule('tab1', function(parent) {
    'use strict';

    // ============ Private 영역 ============
    var sheetWrapper = null;  // IBSheetWrapper 인스턴스 (주 사용)
    var sheet = null;
    var datePicker = null;
    var searchParams = {};
    var tagBox = null;

    // 폼 필드 전역 참조
    var paramFields = {
        clDate: null,
        kepManager: null,
        site: null
    };
    
    // Private 함수 - 외부에서 접근 불가
    function validateSearchForm() {
        var clDate = paramFields.clDate;
        if (!clDate || !clDate.value) {
            alert('마감월을 선택해주세요');
            return false;
        }
        return true;
    }

    function buildSearchParams() {
        // datePicker를 통해 날짜 가져오기 (month 타입 - YYYYMM 형식)
        var monthRange = datePicker ? datePicker.getMonthRangePure() : {from: '', to: ''};

        // month 타입은 이미 YYYYMM 형식이므로 그대로 사용
        var st_cl_month = monthRange.from;

        var st_cl_year = '';
        var st_cl_month_only = '';

        if (st_cl_month && st_cl_month.length === 6) {
            st_cl_year = st_cl_month.substring(0, 4);
            st_cl_month_only = st_cl_month.substring(4, 6);
        }

        var st_com_code = parent.getCommonData('sessionComCode') || '';
        var st_site = paramFields.site ? paramFields.site.value : 'KA';
        var st_kep_manager = paramFields.kepManager ? paramFields.kepManager.value : '';

        var params = "st_com_code=" + encodeURIComponent(st_com_code) +
                "&st_cl_year=" + encodeURIComponent(st_cl_year) +
                "&st_cl_month=" + encodeURIComponent(st_cl_month_only) +
                "&st_site=" + encodeURIComponent(st_site) +
                "&st_kep_manager=" + encodeURIComponent(st_kep_manager) +
                "&st_pg_row=9999" +
                "&st_page=1" +
                "&onepagerow=9999" +
                "&s_SAVENAME=";

        return params;
    }
    
    function setupEventHandlers() {
        // Search2 컨테이너 내에서 버튼 찾기
        var searchBtn = tagBox.querySelector('#btnSearch02');
        var resetBtn = tagBox.querySelector('.ButSmall_Outline');
        var excelBtn = tagBox.querySelector('.But_ExcelDown40');
        var prevMonthBtn = tagBox.querySelector('#btnPrevMonth2');
        var currentMonthBtn = tagBox.querySelector('#btnCurrentMonth2');

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

        // Enter key event handler for KeP manager search input
        if (paramFields.kepManager) {
            $(paramFields.kepManager).on("keypress", function(e) {
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
            // Search2 컨테이너 초기화
            tagBox = document.getElementById('Search2');
            if (!tagBox) {
                return;
            }

            // 폼 필드 참조 초기화
            paramFields.clDate = tagBox.querySelector('#st_cl_date');
            paramFields.kepManager = tagBox.querySelector('#st_kep_manager');
            paramFields.site = tagBox.querySelector('#st_site');

            // IBSheet 초기화 및 설정
            this.initIBSheet();

            // Month Picker 초기화 (DatePicker.js 사용 - type: 'month')
            if (typeof DatePicker !== 'undefined') {
                if (paramFields.clDate) {
                    try {
                        datePicker = new DatePicker({
                            type: 'month',              // 년/월만 선택
                            targetId: 'st_cl_date',
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
        },
        
        // IBSheetWrapper를 사용한 IBSheet 초기화 및 컬럼 설정
        initIBSheet: function() {
            // IBSheetWrapper 인스턴스 생성
            if (!window.IBSheetWrapper) {
                return;
            }

            // IBSheet 컬럼 정의 - 새로운 13개 컬럼 구성
            var columns = [
                {Align:"Center", SaveName:"sStatus", Header:"상태", Type:"Status", Width:0, Edit:false, EditLen:0, Sort:0, Hidden:true},
                {Align:"Center", SaveName:"ROW_NUM", Header:"NO", Type:"Seq", Width:80, Edit:false, EditLen:0, Sort:0, Hidden:true},
                {Align:"Center", SaveName:"CL_MONTH", Header:"마감월", Type:"Text", Width:120, Edit:false, EditLen:10, Sort:1, Hidden:false},
                {Align:"Center", SaveName:"ISSUE_DATE", Header:"발행일", Type:"Date", Width:100, Edit:false, EditLen:10, Sort:1, Hidden:false, Format:"yyyy/MM/dd"},
                {Align:"Right",  SaveName:"TOT_SUPP_PRICE", Header:"금액", Type:"Int", Width:120, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
                {Align:"Right",  SaveName:"TOT_TAX_PRICE", Header:"세액", Type:"Int", Width:120, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
                {Align:"Right",  SaveName:"TOT_AMT", Header:"합계", Type:"Int", Width:120, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
                {Align:"Left", SaveName:"KEP_MANAGER_NAME", Header:"KeP담당자", Type:"Text", Width:100, Edit:false, EditLen:50, Sort:1, Hidden:false},
                {Align:"Left", SaveName:"KEP_MANAGER_CONTACT", Header:"KeP담당자연락처", Type:"Text", Width:150, Edit:false, EditLen:20, Sort:1, Hidden:false},
                {Align:"Center", SaveName:"TAX_TYPE", Header:"세무구분", Type:"Text", Width:100, Edit:false, EditLen:20, Sort:1, Hidden:false},

                {Align:"Center", SaveName:"BILL_TYPE", Header:"발행구분", Type:"Text", Width:100, Edit:false, EditLen:30, Sort:1, Hidden:false},
                {Align:"Center", SaveName:"APPROVAL_STATUS", Header:"승인여부", Type:"Text", Width:100, Edit:false, EditLen:10, Sort:1, Hidden:false},
                {Align:"Center", SaveName:"DETAIL_VIEW", Header:"상세내역", Type:"Button", Width:100, Edit:false, EditLen:10, Sort:0, Hidden:false, Cursor:"Pointer", ClassName :'Type03'},
                {Align:"Center", SaveName:"CLOSING_STATEMENT", Header:"마감거래명세서", Type:"Button", Width:120, Edit:false, EditLen:10, Sort:0, Hidden:false, Cursor:"Pointer", ClassName :'Type03'},
                {Align:"Center",   SaveName:"TAX_BILL_NO", Header:"계산서번호", Type:"Text", Width:200, Edit:false, EditLen:50, Sort:1, Hidden:false}
            ];

            try {
                sheetWrapper = new IBSheetWrapper("mySheet2", "전자세금계산서내역");
                sheetWrapper.initialize(columns);
                sheetWrapper.SetOnSearchEnd(function(code, Msg, StCode, StMsg, response) {});

                // OnRowSearchEnd 이벤트 설정 - 각 행 로드 시 조건부 스타일 적용 및 날짜 포맷 변환
                sheetWrapper.setOnRowSearchEnd(function(row) {
                    // 승인여부(APPROVAL_STATUS)에 따른 텍스트 색상 변경
                    var approvalStatus = this.sheet.GetCellValue(row, "APPROVAL_STATUS");
                    if (approvalStatus === "미승인") {
                        this.sheet.SetCellFontColor(row, "APPROVAL_STATUS", "#FF0000");
                    }

                    // 마감월(CL_MONTH) 포맷 변경: 모든 형식을 YYYY/MM으로 변환
                    var clMonth = this.sheet.GetCellValue(row, "CL_MONTH");
                    if (clMonth) {
                        var formatted = '';
                        clMonth = String(clMonth).trim();

                        // YYYYMM 형식 (202511)
                        if (/^\d{6}$/.test(clMonth)) {
                            formatted = clMonth.substring(0, 4) + '/' + clMonth.substring(4, 6);
                        }
                        // YYYY-MM, YYYY.MM 형식
                        else if (clMonth.indexOf('-') > -1 || clMonth.indexOf('.') > -1) {
                            formatted = clMonth.replace(/[-\.]/g, '/');
                        }
                        // 이미 YYYY/MM 형식이면 그대로
                        else {
                            formatted = clMonth;
                        }

                        if (formatted && formatted !== clMonth) {
                            this.sheet.SetCellValue(row, "CL_MONTH", formatted);
                        }
                    }
                });

                sheetWrapper.setOnClick( function(row, col, value, cellX, cellY, colSaveName) {
                    // IBSheetWrapper 인스턴스의 getColSaveName 함수 사용
                    var actualColSaveName = sheetWrapper.getColSaveName(col);

                    // 상세내역 컬럼 클릭 시 DetailViewPopup 호출
                    if (actualColSaveName === 'DETAIL_VIEW') {
                        var rowData = sheetWrapper.GetRowData(row);
                        openDetailViewPopup(rowData);
                    } else if (actualColSaveName === 'CLOSING_STATEMENT') {
                        // 마감거래명세서 출력 - 고객사별 마감금액 팝업 호출
                             console.log('마감거래명세서 출력 - 고객사별 마감금액 팝업 호출');
                        var taxBillNo = sheetWrapper.getCellValue(row, "TAX_BILL_NO");
                        console.log('taxBillNo:',taxBillNo);
        
                            PopupUtil.open({
                                url: PopupUtil.POPUP_URLS.BUYER_CLOSING_AMT,
                                data: { taxBillNo: taxBillNo },
                                onInit: function(popup) {
                                    if (popup && popup.loadData) {
                                        popup.loadData(taxBillNo);
                                    }
                                }
                            });

                    }
                });
            } catch (e) {


                console.error('IBSheet 초기화 오류:', e);
                throw e;
            }
        },
        
        // 탭 활성화 시
        activate: function() {

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
                try {
                    sheetWrapper.DoSearch('/mpcl/getSellerMpClTaxsheetIssueStateList_v2.do', searchParams);
                    return true;
                } catch (error) {
                    alert('검색 중 오류가 발생했습니다: ' + error.message);
                    return false;
                }
            }

            alert('시트가 초기화되지 않았습니다. 페이지를 새로고침해주세요.');
            return false;
        },
        
        // 초기화
        reset: function() {
            // Month Picker 초기화 - 현재 월로 설정
            if (datePicker) {
                datePicker.setDate(new Date());
            }

            // 폼 필드 초기화
            if (paramFields.kepManager) paramFields.kepManager.value = '';
            // site는 항상 KA로 고정되므로 초기화하지 않음

            // IBSheet 초기화
            if (sheetWrapper && sheetWrapper.removeAll) {
                sheetWrapper.removeAll();
            }

            // 검색 파라미터 초기화
            searchParams = {};
        },
        
        // 엑셀 다운로드
        exportExcel: function() {
            // 검색 조건 검증
            if (!validateSearchForm()) {
                return false;
            }

            // IBSheetWrapper의 downloadExcel 메서드 사용 (자동 검증 포함)
            if (sheetWrapper && sheetWrapper.downloadExcel) {
                sheetWrapper.downloadExcel({
                    FileName: '전자세금계산서내역',
                    SheetName: '전자세금계산서내역',
                    HiddenColumn: 1
                });
            } else {
                alert('엑셀 다운로드 기능을 사용할 수 없습니다.');
            }
        },
        
        
        getSearchParams: function() {
            return searchParams;
        },

        getSheet: function() {
            return sheet;
        },

        getSheetWrapper: function() {
            return sheetWrapper;
        }
    };
    
    // Private 함수 - 상세 팝업 표시 (DetailViewPopup 사용)
    function openDetailViewPopup(rowData) {
        // 세금계산서 관련 정보 추출
        var taxBillNo = rowData.TAX_BILL_NO ;
        var issueDate = rowData.ISSUE_DATE || new Date().toISOString().slice(0, 10);
        var totalAmt = rowData.TOT_AMT || 0;

        // 담당자 정보 추출
        var managerName = rowData.KEP_MANAGER_NAME || '-';
        var managerContact = rowData.KEP_MANAGER_CONTACT ||'-';

        // DetailViewPopup 호출
        if (typeof DetailViewPopup !== 'undefined' && DetailViewPopup.open) {
            DetailViewPopup.open({
                title: '전자세금계산서 상세내역',
                width: 900,
                height: 500,
                taxBillNo: taxBillNo,
                managerName: managerName,
                managerContact: managerContact,
                onConfirm: function(selectedItems) {},
                onExcel: function(data) {
                    alert('세금계산서 상세내역 엑셀 다운로드를 시작합니다.');
                }
            });
        } else {
            alert('상세 팝업 기능을 사용할 수 없습니다.');
        }
    }


    return publicAPI;
});

</script>