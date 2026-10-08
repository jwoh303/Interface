<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%--
  탭4: "미마감내역"
  부모 페이지: sellerMpClClosInfoList_v2.jsp
--%>
<div id="Search3" class="SearchContent">
    <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> "미마감내역" 탭에서는 납품실적등록이 완료 된 건 중 아직 마감이 확정되지 않은 내역을 확인할 수 있습니다.</div>
    <table class="TabSearchTable" >
        <colgroup>
            <col width="100px" />
            <col width="540px" />
            <col width="100px" />
            <col width="540px" />
        </colgroup>
        <tr>
            <th>고객사명</th>
            <td>
                <input type="text" class="input30" placeholder="고객사명 입력" id="st_buyer_name_tab3" style="width:300px; border:1px solid #d5d5d5;" />
            </td>
            <th>KeP담당자</th>
            <td><input class="input30" style="width:300px" id="st_kep_manager_tab3" type="text" /></td>
        </tr>
    </table>
    <div class="SearchBtnBox">
        <button class="ButSmall_Outline" >초기화</button>
        <button class="ButMSmallDarkGray" id="btnSearch03">조회</button>
    </div>
    <div class="ListBtnBox">
        <div class="left"><button class="But_ExcelDown40" >엑셀다운로드</button></div>
        <div class="right"> </div>
    </div>
    <div class="ib-container">
        <script type="text/javascript">
            createIBSheet("mySheet3", "100%", "500px");
        </script>
    </div><!--IBSheet 끝 -->
</div><!--Search3 끝 -->

<!-- Tab3 전용 스크립트 -->
<script type="text/javascript">
MRO.TabManager.registerModule('tab3', function(parent) {
    'use strict';

    var sheetWrapper = null;
    var sheet = null;
    var searchParams = {};
    var tagBox = null;

    // 폼 필드 전역 참조 (고객사명 직접 입력 방식)
    var paramFields = {
        buyerName: null,
        kepManager: null
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
        // 오늘 기준 1년 전부터 오늘까지
        var now = new Date();
        var year = now.getFullYear();
        var month = now.getMonth() + 1;
        var day = now.getDate();

        // 오늘 날짜 포맷 (YYYYMMDD)
        var monthStr = month < 10 ? '0' + month : month.toString();
        var dayStr = day < 10 ? '0' + day : day.toString();
        var toDate = year + monthStr + dayStr;

        // 1년 전 날짜 계산
        var oneYearAgo = new Date(now);
        oneYearAgo.setFullYear(year - 1);
        var fromYear = oneYearAgo.getFullYear();
        var fromMonth = oneYearAgo.getMonth() + 1;
        var fromDay = oneYearAgo.getDate();
        var fromMonthStr = fromMonth < 10 ? '0' + fromMonth : fromMonth.toString();
        var fromDayStr = fromDay < 10 ? '0' + fromDay : fromDay.toString();
        var fromDate = fromYear + fromMonthStr + fromDayStr;

        var st_com_code = parent.getCommonData('sessionComCode') || '';
        var st_buyer_name = paramFields.buyerName ? paramFields.buyerName.value : '';
        var st_ap_yn = 'N';// 마감 대상내역은 항상 N으로 고정 (미확정)
        var st_kep_manager = paramFields.kepManager ? paramFields.kepManager.value : '';

       return  "st_com_code=" + encodeURIComponent(st_com_code) +
                          "&st_from_date=" + encodeURIComponent(fromDate) +
                          "&st_to_date=" + encodeURIComponent(toDate) +
                          "&st_buyer_name=" + encodeURIComponent(st_buyer_name) +
                          "&st_ap_yn=" + encodeURIComponent(st_ap_yn) +
                          "&st_kep_manager=" + encodeURIComponent(st_kep_manager) +
                          "&s_SAVENAME=";
    }

    function setupEventHandlers() {
        // Search3 컨테이너 내에서 버튼 찾기
        var searchBtn = tagBox.querySelector('#btnSearch03');
        var resetBtn = tagBox.querySelector('.ButSmall_Outline');
        var excelBtn = tagBox.querySelector('.But_ExcelDown40');

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

        // Enter key event handlers for text search inputs
        if (paramFields.buyerName) {
            $(paramFields.buyerName).on("keypress", function(e) {
                if (e.which === 13 || e.keyCode === 13) {
                    e.preventDefault();
                    publicAPI.search();
                }
            });
        }

        if (paramFields.kepManager) {
            $(paramFields.kepManager).on("keypress", function(e) {
                if (e.which === 13 || e.keyCode === 13) {
                    e.preventDefault();
                    publicAPI.search();
                }
            });
        }

    }

    // ============ Public API (외부 노출) ============
    var publicAPI = {
        // 초기화
        init: function() {
            // Search3 컨테이너 초기화
            tagBox = document.getElementById('Search3');
            if (!tagBox) {
                return;
            }

            // 폼 필드 참조 초기화 (고객사명 직접 입력 방식)
            paramFields.buyerName = tagBox.querySelector('#st_buyer_name_tab3');
            paramFields.kepManager = tagBox.querySelector('#st_kep_manager_tab3');

            // IBSheet 초기화 및 설정
            this.initIBSheet();

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

            // IBSheet 컬럼 정의 - 요청된 컬럼 구조로 변경 (총 1280px 기준)
            var columns = [
			{Align:"Center", SaveName:"sStatus", Header:"상태", Type:"Status", Width:0, Edit:false, EditLen:0, Sort:0, Hidden:true},
			{Align:"Center", SaveName:"NO", Header:"NO", Type:"Int", Width:80, Edit:false, EditLen:10, Sort:1, Hidden:true},
			{Align:"Left",   SaveName:"BUYER_NAME", Header:"고객사명", Type:"Text", Width:250, Edit:false, EditLen:100, Sort:1, Hidden:false},
			{Align:"Center", SaveName:"PO_NO", Header:"발주번호", Type:"Text", Width:150, Edit:false, EditLen:20, Sort:1, Hidden:false},
			{Align:"Center",   SaveName:"BUYER_ITEM_NO", Header:"품목코드", Type:"Text", Width:150, Edit:false, EditLen:20, Sort:1, Hidden:false},
			{Align:"Left",   SaveName:"DESCRIPTION", Header:"품명", Type:"Text", Width:200, Edit:false, EditLen:100, Sort:1, Hidden:false},
			{Align:"Left",   SaveName:"SPECIFICATION", Header:"규격", Type:"Text", Width:200, Edit:false, EditLen:50, Sort:1, Hidden:false},
			{Align:"Right",  SaveName:"DELIVERY_QTY", Header:"납품실적등록수량", Type:"Int", Width:120, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
			{Align:"Right",  SaveName:"AGENT_PRICE", Header:"납품실적등록단가", Type:"Int", Width:120, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
			{Align:"Right",  SaveName:"AGENT_ITEM_AMT", Header:"납품실적등록금액", Type:"Int", Width:120, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
			{Align:"Center", SaveName:"CONFIRM_DATE", Header:"납품실적등록일", Type:"Date", Width:100, Edit:false, EditLen:10, Sort:1, Hidden:false, Format:"yyyy/MM/dd"},
			{Align:"Left",   SaveName:"KEP_USER_NAME", Header:"KeP담당자", Type:"Text", Width:100, Edit:false, EditLen:20, Sort:1, Hidden:false},
			{Align:"Left",   SaveName:"KEP_USER_PHONE", Header:"KeP담당자연락처", Type:"Text", Width:120, Edit:false, EditLen:20, Sort:1, Hidden:false}
		];

            try {
                sheetWrapper = new IBSheetWrapper("mySheet3", "마감대상내역");
                sheetWrapper.initialize(columns);
            } catch (e) {
                throw e;
            }
        },

        // 탭 활성화 시
        activate: function() {
            console.log('[Tab3] 미마감내역 탭 활성화됨');
            console.log('[Tab3] 현재 검색 파라미터:', searchParams);
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
                sheetWrapper.DoSearch('/mpcl/getSellerMpClClosTargetInfoList_v3.do', searchParams);
                return true;
            }

            return false;
        },

        // 초기화
        reset: function() {
            // 폼 필드 초기화 (buyerCode 제거됨)
            if (paramFields.buyerName) paramFields.buyerName.value = '';
            if (paramFields.kepManager) paramFields.kepManager.value = '';

            // IBSheet 초기화
            if (sheetWrapper && sheetWrapper.removeAll) {
                sheetWrapper.removeAll();
            }

            // 검색 파라미터 초기화
            searchParams = {};
        },

        // 엑셀 다운로드
        exportExcel: function() {
            // IBSheetWrapper의 downloadExcel 메서드 사용 (자동 검증 포함)
            if (sheetWrapper && sheetWrapper.downloadExcel) {
                sheetWrapper.downloadExcel({
                    FileName: '마감대상내역',
                    SheetName: '마감대상내역',
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
        }
    };

    return publicAPI;
});

// 전역 함수 제거됨 - 클로저 모듈에서 직접 처리
</script>
