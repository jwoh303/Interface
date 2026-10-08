      <%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%-- 
  탭1: MSDS 관리 > 전체
  부모 페이지: sellerMdCmChemicalMatMngList_v2.jsp
--%>
   <div id="Search1" class="SearchContent active">
          <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> “전체”탭은 모든 진행상태의 MSDS 등록 리스트 확인하실 수 있으며, 상단 탭을 선택하시거나 상세조회에서 진행상태를 변경하실 수 있습니다.</div>
          <table class="TabSearchTable" >
            <colgroup>
              <col width="80px" />
              <col width="600px" />
              <col width="80px" />
              <col width="220px" />
              <col width="80px" />
              <col width="220px" />
            </colgroup>           	
            <tr>
              <th>조회일자</th>
              <td colspan="1">
                <select name="st_date_type" id="st_date_type" class="Select search-date-type" style=" float:left; width:120px; margin-right:5px">
                  <option value="R">요청일</option>
                  <option value="S">제출일</option>
                  <option value="C">승인일</option>
                </select>
                <div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input"><input type="text" placeholder="" id="st_from_date" name="st_from_date" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input"><input type="text" placeholder="" id="st_to_date" name="st_to_date" readonly /><span></span></div>
                </div>
                <button class="But_Month" data-months="1">1개월</button>
                <button class="But_Month" data-months="2">2개월</button>
                <button class="But_Month" data-months="3">3개월</button>
                <button class="But_Month" data-months="12">1년</button>
              </td>
              <th style="white-space: nowrap;">요청번호</th>
              <td style="white-space: nowrap;"><input class="input30 request-no-input" name="st_request_no" id="st_request_no" style="width:128px" type="text" /></td>
              <th style="white-space: nowrap;">견적번호</th>
              <td style="white-space: nowrap;"><input class="input30 quotation-no-input" name="st_quotation_no" id="st_quotation_no" style="width:128px" type="text" /></td>
            </tr>
            <tr>
              <th>검색어</th>
              <td>
                <div style="white-space: nowrap;">
                  <select name="st_search_type" id="st_search_type" class="Select search-type-select" style="float:left;width:120px; margin-right:5px">
                   <option value="C">품목명</option>
                    <option value="N">품목코드</option>
                    <option value="S">규격</option>
                  </select>
                  <input class="input30 search-keyword-input" name="st_search_keyword" id="st_search_keyword" style="width:445px" type="text" />
                </div>
              </td>
              <th style="white-space: nowrap;">구분</th>
              <td style="white-space: nowrap;">
              		<select name="st_gubun" id="st_gubun" class="Select gubun-select" style="width:150px">
					<option value="">전체</option>
					<option value="QUOTATION">견적</option>
					<option value="ORDER">발주</option>
                  </select>
               </td>
              <th style="white-space: nowrap;">진행상태</th>
              <td style="white-space: nowrap;">
              		<select name="st_status" id="st_status" class="Select status-select" style="width:150px">
						<option value="">전체</option>
						<option value="Q">요청</option>  <!-- 입력요청 -->
						<!-- <option value="D">삭제</option>       사용 안함-->
						<option value="P">협력사제출(오분류)</option> <!-- 유지  -->
						<option value="S">협력사제출</option>          <!-- 유지  -->
						<option value="R">재요청</option>              <!-- 반려재요청  -->
						<!-- <option value="M">검토요청</option>           사용 안함-->
						<option value="A">발주후제출(요청)</option> <!-- 발주후제출(협력사)  -->
						<option value="B">발주후제출(승인)</option> <!--  발주후제출(승인) -->
						<option value="C">승인완료</option> <!-- 최종승인 -->
						<!-- <option value="T">오분류(종결)</option> 사용 안함  -->
					    <!-- <option value="N">취소</option>       사용 안함  -->
                  </select>
               </td>
            </tr>
          </table>
          <div class="SearchBtnBox">
         	<button class="ButSmall_Outline" >초기화</button> 
        	<button class="ButMSmallDarkGray" >조회</button> 
          </div>
          <div class="h30"></div>

          <!--grid-->
          <div class="ib-container">
              <script type="text/javascript">
                  createIBSheet("mySheet1", "100%", "500px");
              </script>
          </div>
          <div class="h50"></div>
        </div><!--id="Search1" 전체 끝 -->

<script type="text/javascript">
// MSDS 탭1 모듈 등록
MRO.TabManager.registerModule('tab1', function(parent) {
    'use strict';

    var sheetWrapper = null; // IBSheetWrapper 인스턴스
    var tagBox = null; // Search1 컨테이너 참조
    var datePickerInstance = null; // DatePicker 인스턴스

    // 폼 필드 전역 참조
    var paramFields = {
        dateTypeSelect: null,
        fromDate: null,
        toDate: null,
        searchTypeSelect: null,
        searchKeyword: null,
        gubunSelect: null,
        statusSelect: null,
        requestNo: null,
        quotationNo: null
    };

    function buildSearchParams() {
        // MonthNew.js 달력에서 직접 날짜 가져오기 (YYYY/MM/DD 형식)
        var fromDateValue = paramFields.fromDate ? paramFields.fromDate.value : '';
        var toDateValue = paramFields.toDate ? paramFields.toDate.value : '';

        // "/" 제거하여 YYYYMMDD 형식으로 변환
        var fromDate = fromDateValue.replace(/\//g, '');
        var toDate = toDateValue.replace(/\//g, '');

        var sessionComCode = parent.getCommonData('sessionComCode') || '';
        var sessionUserId = parent.getCommonData('sessionUserId') || '';
        var dateType = paramFields.dateTypeSelect ? paramFields.dateTypeSelect.value : '요청일';
        var searchType = paramFields.searchTypeSelect ? paramFields.searchTypeSelect.value : '품목명';
        var searchKeyword = paramFields.searchKeyword ? paramFields.searchKeyword.value : '';
        var gubun = paramFields.gubunSelect ? paramFields.gubunSelect.value : '';
        var status = paramFields.statusSelect ? paramFields.statusSelect.value : '';
        var requestNo = paramFields.requestNo ? paramFields.requestNo.value : '';
        var quotationNo = paramFields.quotationNo ? paramFields.quotationNo.value : '';

        return "sessionComCode=" + encodeURIComponent(sessionComCode) +
               "&sessionUserId=" + encodeURIComponent(sessionUserId) +
               "&dateType=" + encodeURIComponent(dateType) +
               "&fromDate=" + encodeURIComponent(fromDate) +
               "&toDate=" + encodeURIComponent(toDate) +
               "&searchType=" + encodeURIComponent(searchType) +
               "&searchKeyword=" + encodeURIComponent(searchKeyword) +
               "&gubun=" + encodeURIComponent(gubun) +
               "&status=" + encodeURIComponent(status) +
               "&requestNo=" + encodeURIComponent(requestNo) +
               "&quotationNo=" + encodeURIComponent(quotationNo) +
               "&s_SAVENAME=";
    }

    // 이벤트 핸들러 설정 (참조 파일 패턴)
    function setupEventHandlers() {
        var searchBtn = tagBox.querySelector('.ButMSmallDarkGray');
        var resetBtn = tagBox.querySelector('.ButSmall_Outline');

        // 조회 버튼 이벤트
        if (searchBtn) {
            searchBtn.onclick = function() {
                publicAPI.search();
            };
        }

        // 초기화 버튼 이벤트
        if (resetBtn) {
            resetBtn.onclick = function() {
                publicAPI.reset();
            };
        }

        // 월별 버튼 이벤트 (DatePicker.js 사용)
        var monthButtons = tagBox.querySelectorAll('.But_Month');
        for (var i = 0; i < monthButtons.length; i++) {
            (function(button) {
                button.onclick = function() {
                    var months = parseInt(button.getAttribute('data-months'), 10);
                    if (datePickerInstance && !isNaN(months)) {
                        datePickerInstance.setRangeByMonths(months);
                    }
                    return false;
                };
            })(monthButtons[i]);
        }

        // Enter key event handlers for text search inputs
        if (paramFields.requestNo) {
            $(paramFields.requestNo).on("keypress", function(e) {
                if (e.which === 13 || e.keyCode === 13) {
                    e.preventDefault();
                    publicAPI.search();
                }
            });
        }

        if (paramFields.quotationNo) {
            $(paramFields.quotationNo).on("keypress", function(e) {
                if (e.which === 13 || e.keyCode === 13) {
                    e.preventDefault();
                    publicAPI.search();
                }
            });
        }

        if (paramFields.searchKeyword) {
            $(paramFields.searchKeyword).on("keypress", function(e) {
                if (e.which === 13 || e.keyCode === 13) {
                    e.preventDefault();
                    publicAPI.search();
                }
            });
        }
    }

    // ============ Public API (외부 노출) ============
    var publicAPI = {
        // 탭 활성화 (탭 클릭 시 자동 호출)
        activate: function() {
            // DatePicker 인스턴스에서 이미 초기 날짜가 설정되어 있음
            // 탭 활성화 시 자동 조회
            this.search();
        },

        // 모듈 초기화
        init: function() {
            // Search1 컨테이너 초기화
            tagBox = document.getElementById('Search1');
            if (!tagBox) {
                return;
            }

            // 폼 필드 참조 초기화
            paramFields.dateTypeSelect = tagBox.querySelector('#st_date_type');
            paramFields.fromDate = tagBox.querySelector('#st_from_date');
            paramFields.toDate = tagBox.querySelector('#st_to_date');
            paramFields.searchTypeSelect = tagBox.querySelector('#st_search_type');
            paramFields.searchKeyword = tagBox.querySelector('#st_search_keyword');
            paramFields.gubunSelect = tagBox.querySelector('#st_gubun');
            paramFields.statusSelect = tagBox.querySelector('#st_status');
            paramFields.requestNo = tagBox.querySelector('#st_request_no');
            paramFields.quotationNo = tagBox.querySelector('#st_quotation_no');

            // DatePicker.js 달력 초기화 (년월일 범위 선택)
            if (typeof DatePicker !== 'undefined') {
                datePickerInstance = new DatePicker({
                    type: 'range',
                    fromId: 'st_from_date',
                    toId: 'st_to_date',
                    dateFormat: '/',  // YYYY/MM/DD 형식
                    locale: 'ko',
                    maxRangeMonths: 12  // 최대 1년(12개월) 제한
                });
                datePickerInstance.init();

                // 초기 날짜 설정 (1개월 전 ~ 오늘)
                datePickerInstance.setRangeByMonths(1);
            }

            this.initIBSheet();
            setupEventHandlers();
        },

        // IBSheet 초기화 및 컬럼 설정
        initIBSheet: function() {
            if (!window.IBSheetWrapper) {
                return;
            }

            try {
              
                var columns = [
                	{Align:"Center", SaveName:"SSTATUS", Header:"상태", Type:"Status", Width:0, Edit:false, EditLen:0, Sort:0, Hidden:true},
				    {Align:"Center", SaveName:"NO", Header:"NO", Type:"Seq", Width:30, Edit:false, EditLen:10, Sort:0, Hidden:true},
				    {Align:"Center", SaveName:"REQUEST_DATE", Header:"요청일", Type:"Text", Width:100, Edit:false, EditLen:10, Sort:0, Hidden:false},
				    {Align:"Center", SaveName:"REQUEST_NO", Header:"요청번호", Type:"Text", Width:120, Edit:false, EditLen:20, Sort:0, Hidden:false},
				  	{Align:"Center", SaveName:"STATUS", Header:"진행상태", Type:"Text", Width:100, Edit:false, EditLen:20, Sort:0, Hidden:false},
				    {Align:"Center", SaveName:"MSDS", Header:"MSDS", Type:"Image", Cursor:"Pointer", Width:80, Edit:false, EditLen:10, Sort:0, Hidden:false},
				    {Align:"Center", SaveName:"GUBUN", Header:"구분", Type:"Text",  Width:80, Edit:false, EditLen:10, Sort:0, Hidden:false},
				    {Align:"Center", SaveName:"QUOTATION_NO", Header:"견적번호", Type:"Text", Width:120, Edit:false, Sort:0, Hidden:false},
				    {Align:"Center", SaveName:"REVISION", Header:"견적차수", Type:"Text", Width:80, Edit:false, Sort:0, Hidden:false},
				    {Align:"Center", SaveName:"QUOTATION_SEQ", Header:"견적순번", Type:"Text", Width:80, Edit:false, Sort:0, Hidden:true},
                    {Align:"Left",	 SaveName:"CUSTOMER_NAME", Header:"고객사", Type:"Text", Width:150, Edit:false, EditLen:50, Sort:0, Hidden:false},
				    {Align:"Center", SaveName:"ITEM_CODE", Header:"품목코드", Type:"Text", Width:120, Edit:false, EditLen:20, Sort:0, Hidden:false},
				    {Align:"Left",   SaveName:"ITEM_NAME", Header:"품목명", Type:"Text", Width:200, Edit:false, EditLen:100, Sort:0, Hidden:false},
				    {Align:"Left",   SaveName:"SPEC", Header:"규격", Type:"Text", Width:150, Edit:false, EditLen:50, Sort:0, Hidden:false},
				    {Align:"Left",   SaveName:"MANUFACTURER", Header:"제조사", Type:"Text", Width:150, Edit:false, EditLen:50, Sort:0, Hidden:false},
				    {Align:"Left",   SaveName:"KEP_MANAGER", Header:"KeP담당자", Type:"Text", Width:100, Edit:false, EditLen:20, Sort:0, Hidden:false},
				    {Align:"Left",	 SaveName:"KEP_CONTACT", Header:"KeP 담당자 연락처", Type:"Text", Width:150, Edit:false, EditLen:30, Sort:0, Hidden:false},
				    {Align:"Center", SaveName:"SUBMIT_DATE", Header:"제출일", Type:"Text", Width:100, Edit:false, EditLen:10, Sort:0, Hidden:false},
				    {Align:"Center", SaveName:"REQ_STATUS", Header:"상태코드", Type:"Text", Width:0, Edit:false, Sort:0, Hidden:true},
					{Align:"Center", SaveName:"APPROVE_DATE", Header:"승인일", Type:"Text", Width:100, Edit:false, EditLen:10, Sort:0, Hidden:false},
					{Align:"Center", SaveName:"SUBMITTER", Header:"제출자", Type:"Text", Width:100, Edit:false, EditLen:20, Sort:0, Hidden:true},
				 	{Align:"Center", SaveName:"APPROVER", Header:"승인자", Type:"Text", Width:100, Edit:false, EditLen:20, Sort:0, Hidden:true},
				    {Align:"Center", SaveName:"BUYER", Header:"구매조직", Type:"Text", Width:80, Edit:false, Sort:0, Hidden:true}
                 ];

                // IBSheetWrapper 인스턴스 생성 및 초기화
                sheetWrapper = new IBSheetWrapper("mySheet1", "MSDS관리");
                sheetWrapper.initialize(columns);

                // OnRowSearchEnd 이벤트 설정 - 날짜 포맷 변환
                sheetWrapper.setOnRowSearchEnd(function(row) {
                    // 날짜 포맷 변환 함수
                    var formatDate = function(dateStr) {
                        if (!dateStr) return dateStr;
                        dateStr = String(dateStr).trim();

                        // YYYYMMDD 형식 (20251114)
                        if (/^\d{8}$/.test(dateStr)) {
                            return dateStr.substring(0, 4) + '/' + dateStr.substring(4, 6) + '/' + dateStr.substring(6, 8);
                        }
                        // YYYY-MM-DD, YYYY.MM.DD 형식
                        else if (dateStr.indexOf('-') > -1 || dateStr.indexOf('.') > -1) {
                            return dateStr.replace(/[-\.]/g, '/');
                        }
                        return dateStr;
                    };

                    // REQUEST_DATE (요청일) 포맷 변경
                    var requestDate = this.sheet.GetCellValue(row, "REQUEST_DATE");
                    var formattedRequestDate = formatDate(requestDate);
                    if (formattedRequestDate && formattedRequestDate !== requestDate) {
                        this.sheet.SetCellValue(row, "REQUEST_DATE", formattedRequestDate);
                    }

                    // SUBMIT_DATE (제출일) 포맷 변경
                    var submitDate = this.sheet.GetCellValue(row, "SUBMIT_DATE");
                    var formattedSubmitDate = formatDate(submitDate);
                    if (formattedSubmitDate && formattedSubmitDate !== submitDate) {
                        this.sheet.SetCellValue(row, "SUBMIT_DATE", formattedSubmitDate);
                    }

                    // APPROVE_DATE (승인일) 포맷 변경
                    var approveDate = this.sheet.GetCellValue(row, "APPROVE_DATE");
                    var formattedApproveDate = formatDate(approveDate);
                    if (formattedApproveDate && formattedApproveDate !== approveDate) {
                        this.sheet.SetCellValue(row, "APPROVE_DATE", formattedApproveDate);
                    }
                });

                // MSDS 컬럼 클릭 이벤트 설정
                sheetWrapper.setOnClick('MSDS', function(row, col, colName) {
                    // MSDS 버튼 클릭 - 모든 데이터 추출
                    var requestNo = this.getCellValue(row, 'REQUEST_NO');
                    var customerName = this.getCellValue(row, 'CUSTOMER_NAME') || '';
                    var itemCode = this.getCellValue(row, 'ITEM_CODE') || '';
                    var itemName = this.getCellValue(row, 'ITEM_NAME') || '';
                    var spec = this.getCellValue(row, 'SPEC') || '';
                    var manufacturer = this.getCellValue(row, 'MANUFACTURER') || '';
                    var status = this.getCellValue(row, 'STATUS');
                    var reqStatus = this.getCellValue(row, 'REQ_STATUS') || ''; // REQ_STATUS 추출

                    // 견적정보 추출
                    var quotationNo = this.getCellValue(row, 'QUOTATION_NO') || '';
                    var quotationSeq = this.getCellValue(row, 'QUOTATION_SEQ') || '';
                    var revision = this.getCellValue(row, 'REVISION') || '0';
                    var buyer = this.getCellValue(row, 'BUYER') || '';

                    // itemCode가 "NO_CODE"인 경우 빈 값으로 변환 (미등록 품목)
                    var buyerItemNo = (itemCode === 'NO_CODE') ? '' : itemCode;

                    // 서버 데이터를 저장할 변수 (submit 시 재사용)
                    var serverData = null;



                    // ========== 신규 reg_msds2.html 호출 (개선 버전 - onClose 콜백 적용) ==========
                    try {
                        PopupUtil.openPopup(PopupUtil.POPUP_URLS.MSDS2, {
                            params: {
                                st_req_no: requestNo,
                                st_buyer_item_no: buyerItemNo,
                                st_buyer: buyer,
                                st_quotation_no: quotationNo,
                                st_quotation_seq: quotationSeq,
                                st_revision: revision
                            },
                            onClose: function(result) {
                                // ✅ MSDS 저장 완료 시 그리드 자동 갱신
                                if (result && result.saved) {
                                    publicAPI.search();
                                }
                            }
                        });

                    } catch (error) {
                        console.error('[MSDS Tab1] 팝업 호출 중 에러 발생:', error);
                        alert('팝업 열기 실패: ' + error.message);
                    }
                }); // setOnClick 끝

            } catch (e) {
                console.error('[MSDS Tab1] IBSheetWrapper 초기화 중 오류:', e);
                throw e;
            }
        },


        // 폼 초기화 (참조 파일 패턴)
        reset: function() {
            try {
                // 검색 조건 초기화
                this._resetSelectField('dateTypeSelect', 0);
                this._resetSelectField('searchTypeSelect', 0);
                this._resetSelectField('gubunSelect', 0);
                this._resetSelectField('statusSelect', 0);
                this._resetInputField('searchKeyword', '');
                this._resetInputField('requestNo', '');
                this._resetInputField('quotationNo', '');

                // 날짜 초기화 (DatePicker.js 사용 - 1개월 전 ~ 오늘)
                if (datePickerInstance) {
                    datePickerInstance.setRangeByMonths(1);
                }

                // 시트 초기화
                if (sheetWrapper && sheetWrapper.removeAll) {
                    sheetWrapper.removeAll();
                }

            } catch (error) {
                console.error('[MSDS Tab1] 폼 초기화 중 오류:', error);
            }
        },

        // 안전한 Select 필드 초기화 헬퍼 함수
        _resetSelectField: function(fieldName, selectedIndex) {
            try {
                var field = paramFields[fieldName];
                if (field && typeof field.selectedIndex !== 'undefined') {
                    field.selectedIndex = selectedIndex;
                }
            } catch (error) {
                console.error('[MSDS Tab1] Select 필드 초기화 오류:', fieldName, error);
            }
        },

        // 안전한 Input 필드 초기화 헬퍼 함수
        _resetInputField: function(fieldName, value) {
            try {

                var field = paramFields[fieldName];
                if (field && typeof field.value !== 'undefined') {
                    field.value = value;
                }

            } catch (error) {
                console.error('[MSDS Tab1] Input 필드 초기화 오류:', fieldName, error);
            }
        },

        // 데이터 조회 (참조 파일 패턴)
        search: function() {
            try {
                var paramString = buildSearchParams();

                // IBSheetWrapper를 통한 DoSearch
                if (sheetWrapper && sheetWrapper.DoSearch) {
                    sheetWrapper.DoSearch('/mdct/getMSDSList.do', paramString);
                    return true;
                }

                return false;

            } catch (error) {
                console.error('[MSDS Tab1] 검색 중 오류:', error);
                return false;
            }
        },

        // 안전한 필드 값 추출 헬퍼 함수
        _getFieldValue: function(fieldName, defaultValue) {
            try {
                var field = paramFields[fieldName];
                if (field && typeof field.value !== 'undefined') {
                    return field.value || defaultValue;
                }
                return defaultValue;
            } catch (error) {
                console.error('[MSDS Tab1] 필드 값 추출 오류:', fieldName, error);
                return defaultValue;
            }
        }
    };

    return publicAPI;
});
</script>      