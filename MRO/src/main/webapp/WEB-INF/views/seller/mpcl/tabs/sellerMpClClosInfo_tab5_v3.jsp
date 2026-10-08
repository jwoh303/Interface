<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%--
  탭5: 마감내역
  부모 페이지: sellerMpClClosInfoList_v2.jsp
--%>
<div id="Search5" class="SearchContent">
          <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> 선택한 기간과 고객사 기준으로 발주·납품 등 거래의 마감 진행 현황을 조회하는 화면입니다. </div>
          <table class="TabSearchTable" >
            <colgroup>
              <col width="90px" />
              <col width="380px" />
              <col width="90px" />
              <col width="190px" />
              <col width="90px" />
              <col width="190px" />
            </colgroup>
            <tr>
              <th>마감기간</th>
              <td>
                <div class="datepicker-wrap" style="width:230px;">
                  <div class="date-input" data-datepicker><input type="text" id="st_from_date_tab5" readonly /><span></span></div>
                  <span class="dash">~</span>
                  <div class="date-input" data-datepicker><input type="text" id="st_to_date_tab5" readonly /><span></span></div>
                </div>
                <button class="But_Month" data-months="1">1개월</button>
                <button class="But_Month" data-months="0">당월</button>
              </td>
              <th>고객사명</th>
              <td>
                <input class="input30" style="width:170px; border:1px solid #d5d5d5;" name="st_buyer_name_tab5" id="st_buyer_name_tab5" type="text" placeholder="고객사명" />
              </td>
              <th>정산여부</th>
              <td>
                <select class="input30" style="width:170px; border:1px solid #d5d5d5;" id="st_settle_yn_tab5">
                  <option value="">전체</option>
                  <option value="Y">Y</option>
                  <option value="N">N</option>
                </select>
              </td>
            </tr>
          </table>
          <div class="SearchBtnBox">
            <button type="button" class="ButSmall_Outline" id="btnReset5">초기화</button>
            <button type="button" class="ButMSmallDarkGray" id="btnSearch5">조회</button>
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40">엑셀다운로드</button></div>
            <div class="right"><button class="ButOutline_Medium" id="btnBuyerSummary5">고객사별 집계</button></div>
          </div>

    <!--grid-->
    <div class="ib-container">
        <script type="text/javascript">
            createIBSheet("sheet5", "100%", "500px");
        </script>
    </div>
</div><!--Search5 끝 -->

<!-- Tab5 전용 스크립트 (클로저 패턴) -->
<script type="text/javascript">

MRO.TabManager.registerModule('tab5', function(parent) {
    'use strict';

    var sheetWrapper = null;
    var datePicker = null;
    var searchParams = {};
    var tagBox = null;

    // 폼 필드 참조
    var paramFields = {
        fromDate: null,
        toDate: null,
        buyerName: null,
        settleYn: null
    };

    // 날짜 기간 검증 (31일 초과 체크)
    function validateDateRange() {
        var st_from_date = paramFields.fromDate ? paramFields.fromDate.value.replace(/\//g, '') : '';
        var st_to_date = paramFields.toDate ? paramFields.toDate.value.replace(/\//g, '') : '';

        if (!st_from_date || !st_to_date) {
            alert('조회기간을 선택해주세요.');
            return false;
        }

        var fromDate = new Date(
            parseInt(st_from_date.substring(0, 4)),
            parseInt(st_from_date.substring(4, 6)) - 1,
            parseInt(st_from_date.substring(6, 8))
        );
        var toDate = new Date(
            parseInt(st_to_date.substring(0, 4)),
            parseInt(st_to_date.substring(4, 6)) - 1,
            parseInt(st_to_date.substring(6, 8))
        );

        var diffDays = Math.floor((toDate - fromDate) / (1000 * 60 * 60 * 24));

        if (diffDays > 31) {
            alert('조회기간은 1개월 단위로 조회가 가능합니다.');
            return false;
        }

        if (diffDays < 0) {
            alert('시작일이 종료일보다 클 수 없습니다.');
            return false;
        }

        return true;
    }

    function buildSearchParams() {
        // 날짜 값 직접 가져오기
        var st_from_date = paramFields.fromDate ? paramFields.fromDate.value.replace(/\//g, '') : '';
        var st_to_date = paramFields.toDate ? paramFields.toDate.value.replace(/\//g, '') : '';
        var st_com_code = parent.getCommonData('sessionComCode') || '';
        var st_buyer_name = paramFields.buyerName ? paramFields.buyerName.value : '';
        var st_ap_yn = paramFields.settleYn ? paramFields.settleYn.value : '';

        var params = "st_com_code=" + encodeURIComponent(st_com_code) +
               "&st_from_date=" + encodeURIComponent(st_from_date) +
               "&st_to_date=" + encodeURIComponent(st_to_date) +
               "&st_buyer_name=" + encodeURIComponent(st_buyer_name) +
               "&st_ap_yn=" + encodeURIComponent(st_ap_yn) +
               "&s_SAVENAME=";

        return params;
    }

    function setupEventHandlers() {
        var searchBtn = tagBox.querySelector('#btnSearch5');
        var resetBtn = tagBox.querySelector('#btnReset5');
        var excelBtn = tagBox.querySelector('.But_ExcelDown40');
        var buyerSummaryBtn = tagBox.querySelector('#btnBuyerSummary5');

        if (searchBtn) {
            searchBtn.onclick = function() {
                publicAPI.search();
                return false;
            };
        }

        if (resetBtn) {
            resetBtn.onclick = function() {
                publicAPI.reset();
                return false;
            };
        }

        if (excelBtn) {
            excelBtn.onclick = function() {
                publicAPI.exportExcel();
                return false;
            };
        }

        if (buyerSummaryBtn) {
            buyerSummaryBtn.onclick = function() {
                publicAPI.showBuyerSummary();
                return false;
            };
        }

        // 월별 버튼 이벤트 (DatePicker.js 사용)
        $(tagBox).find('.But_Month').each(function() {
            $(this).on('click', function() {
                var months = parseInt($(this).attr('data-months'), 10);
                if (datePicker && !isNaN(months)) {
                    if (months === 0) {
                        // 당월: 이번 달 1일 ~ 말일
                        var today = new Date();
                        var firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
                        var lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0);
                        datePicker.setDate({ from: firstDay, to: lastDay });
                    } else {
                        // N개월: N개월 전 ~ 오늘
                        datePicker.setRangeByMonths(months);
                    }
                }
                return false;
            });
        });

        // Enter key 이벤트
        if (paramFields.buyerName) {
            $(paramFields.buyerName).on("keypress", function(e) {
                if (e.which === 13 || e.keyCode === 13) {
                    e.preventDefault();
                    publicAPI.search();
                }
            });
        }
    }

    // ============ Public API ============
    var publicAPI = {
        init: function() {
            tagBox = document.getElementById('Search5');
            if (!tagBox) return;

            paramFields.fromDate = tagBox.querySelector('#st_from_date_tab5');
            paramFields.toDate = tagBox.querySelector('#st_to_date_tab5');
            paramFields.buyerName = tagBox.querySelector('#st_buyer_name_tab5');
            paramFields.settleYn = tagBox.querySelector('#st_settle_yn_tab5');

            this.initIBSheet();

            // DatePicker.js 달력 초기화 (년월일 범위 선택)
            if (typeof DatePicker !== 'undefined') {
                datePicker = new DatePicker({
                    type: 'range',
                    fromId: 'st_from_date_tab5',
                    toId: 'st_to_date_tab5',
                    dateFormat: '/',  // YYYY/MM/DD 형식
                    locale: 'ko'
                });
                datePicker.init();
                // 초기 날짜 설정 (당월 1일 ~ 말일)
                var today = new Date();
                var firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
                var lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0);
                datePicker.setDate({ from: firstDay, to: lastDay });
            }

            setupEventHandlers();
        },

        initIBSheet: function() {
            if (!window.IBSheetWrapper) return;

            var columns = [
                {Align:"Center", SaveName:"sStatus", Header:"상태", Type:"Status", Width:60, Edit:false, EditLen:0, Hidden:true},
                {Align:"Center", SaveName:"SELECTED", Header:"", Type:"DummyCheck", Width:60, Edit:false, EditLen:100, Hidden:true},
                {Align:"Left",   SaveName:"BUYER_NAME", Header:"고객사", Type:"Text", Width:200, Edit:false, EditLen:100, Hidden:false},
                 // BUYER: 원본 고객사 코드 (테이블 값 그대로)
                {Align:"Center", SaveName:"BUYER", Header:"고객사코드", Type:"Text", Width:120, Edit:false, EditLen:100, Hidden:false},
                {Align:"Center", SaveName:"PROCESS_TYPE_TEXT",	Header:"거래유형",	Type:"Text",Width:90,	Edit:false,	EditLen:100,	Hidden:false},
                {Align:"Center", SaveName:"PO_CREATE_DATE", Header:"발주일", Type:"Date", Width:95, Edit:false, EditLen:100, Hidden:false},
                {Align:"Center", SaveName:"PO_NO", Header:"발주번호", Type:"Text", Width:100, Edit:false, EditLen:100, Hidden:false},
                {Align:"Center", SaveName:"PO_SEQ", Header:"발주항번", Type:"Text", Width:80, Edit:false, EditLen:100, Hidden:false},
                {Align:"Center",   SaveName:"BUYER_ITEM_NO", Header:"품목코드", Type:"Text", Width:120, Edit:false, EditLen:100, Hidden:false},
                {Align:"Left",   SaveName:"DESCRIPTION", Header:"품명", Type:"Text", Width:150, Edit:false, EditLen:100, Hidden:false},
                {Align:"Left",   SaveName:"SPECIFICATION", Header:"규격", Type:"Text", Width:250, Edit:false, EditLen:100, Hidden:false},
                {Align:"Right",  SaveName:"AGENT_PRICE", Header:"단가", Type:"Int", Width:80, Edit:false, EditLen:15, Hidden:false, Format:"#,###"},
                {Align:"Center", SaveName:"UNIT_MEASURE", Header:"단위", Type:"Text", Width:50, Edit:false, EditLen:100, Hidden:false},
                {Align:"Right",  SaveName:"PO_QTY", Header:"발주수량", Type:"Int", Width:80, Edit:false, EditLen:15, Hidden:false, Format:"#,###"},
                {Align:"Right",  SaveName:"PO_AMT", Header:"발주금액", Type:"Int", Width:100, Edit:false, EditLen:15, Hidden:false, Format:"#,###"},
                {Align:"Right",  SaveName:"DELIVERY_QTY", Header:"납품총수량", Type:"Int", Width:80, Edit:false, EditLen:15, Hidden:false, Format:"#,###"},
                {Align:"Right",  SaveName:"DELIVERY_AMT", Header:"납품금액", Type:"Int", Width:100, Edit:false, EditLen:15, Hidden:false, Format:"#,###"},
                {Align:"Center", SaveName:"DS_DATE", Header:"납품예정일", Type:"Date", Width:95, Edit:false, EditLen:100, Hidden:false},
                {Align:"Center", SaveName:"DELIVERY_DATE", Header:"납품실적등록일", Type:"Date", Width:100, Edit:false, EditLen:100, Hidden:false},
                {Align:"Left",   SaveName:"LEGACY_PO_NO", Header:"고객사발주번호", Type:"Text", Width:180, Edit:false, EditLen:100, Hidden:false},
                {Align:"Left", SaveName:"KEP_USER_NAME", Header:"KeP담당자", Type:"Text", Width:80, Edit:false, EditLen:100, Hidden:false},
                {Align:"Left", SaveName:"KEP_USER_PHONE", Header:"담당자연락처", Type:"Text", Width:150, Edit:false, EditLen:100, Hidden:false},
           
                {Align:"Left",   SaveName:"LEGACY_PO_SEQ", Header:"고객사발주항번", Type:"Text", Width:100, Edit:false, EditLen:100, Hidden:true},
                {Align:"Center", SaveName:"PURCHASER_NAME", Header:"발주자", Type:"Text", Width:80, Edit:false, EditLen:100, Hidden:true},
                {Align:"Center", SaveName:"CHANGE_USER_MOBILE_PHONE", Header:"인수자연락처", Type:"Text", Width:100, Edit:false, EditLen:100, Hidden:true},
               
                // BUYER2: F_GET_HIDDEN_BUYER_NAME(BUYER, '01') 함수로 변환된 고객사 코드 - BUYER와 다른 값
                {Align:"Center", SaveName:"BUYER2", Header:"고객사코드2", Type:"Text", Width:80, Edit:false, EditLen:100, Hidden:true},
                {Align:"Center", SaveName:"BYIT_COMORG_CODE", Header:"카탈로그관리코드", Type:"Text", Width:100, Edit:false, EditLen:100, Hidden:true},
                {Align:"Center", SaveName:"CONTRACT_NO", Header:"계약서번호", Type:"Text", Width:80, Edit:false, EditLen:100, Hidden:true},
                {Align:"Center", SaveName:"CONTRACT_SEQ", Header:"계약서항번", Type:"Text", Width:80, Edit:false, EditLen:100, Hidden:true}
            ];

            try {
                sheetWrapper = new IBSheetWrapper("sheet5", "마감내역");
                sheetWrapper.initialize(columns);
                sheetWrapper.setOnClick(function() {});
            } catch (e) {
                throw e;
            }
        },

        activate: function() {
            // 자동 조회 비활성화
        },

        deactivate: function() {
            // 필요시 리소스 정리
        },

        search: function() {
            // 날짜 기간 검증
            if (!validateDateRange()) {
                return false;
            }

            searchParams = buildSearchParams();

            if (sheetWrapper && sheetWrapper.DoSearch) {
                sheetWrapper.DoSearch('/mpcl/getSellerMpClClosInfoTab5List_v2.do', searchParams);
                return true;
            }
            return false;
        },

        reset: function() {
            // 날짜 초기화 - 당월 1일 ~ 말일로 설정
            if (datePicker) {
                var today = new Date();
                var firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
                var lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0);
                datePicker.setDate({ from: firstDay, to: lastDay });
            }

            if (paramFields.buyerName) paramFields.buyerName.value = '';
            if (paramFields.settleYn) paramFields.settleYn.value = '';

            if (sheetWrapper && sheetWrapper.removeAll) {
                sheetWrapper.removeAll();
            }

            searchParams = {};
        },

        exportExcel: function() {
            if (sheetWrapper && sheetWrapper.downloadExcel) {
                sheetWrapper.downloadExcel({
                    FileName: '마감내역',
                    SheetName: '마감내역',
                    HiddenColumn: 1
                });
            } else {
                alert('엑셀 다운로드 기능을 사용할 수 없습니다.');
            }
        },

        getSearchParams: function() {
            return searchParams;
        },

        getSheetWrapper: function() {
            return sheetWrapper;
        },

        showBuyerSummary: function() {
            // 날짜 기간 검증
            if (!validateDateRange()) {
                return;
            }

            var st_from_date = paramFields.fromDate ? paramFields.fromDate.value.replace(/\//g, '') : '';
            var st_to_date = paramFields.toDate ? paramFields.toDate.value.replace(/\//g, '') : '';
            var agent_code = parent.getCommonData('sessionComCode') || '';

            if (typeof reportOpen === 'function') {
                reportOpen("RD_06_S_001_91", "[" + agent_code + "][" + st_from_date + "][" + st_to_date + "]");
            } else {
                alert('리포트 기능을 사용할 수 없습니다.');
            }
        }
    };

    return publicAPI;
});

</script>
