<%--
**********************************************
* 메뉴 : 재고관리>VMI 납품관리>권고발주접수
* 화면 : 권고발주접수
* 기능 : 
* 프로그램 ID : SU0504001
* 담당자 : 원지성
* 착수일 : 2015-08-28
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf"  %>

<!-- DatePicker Calendar CSS -->
<link rel="stylesheet" href="/resources/css/month.css">

<!-- IBSheet 래퍼 -->
<script src="/resources/js/common/IBSheetWrapper.js" type="text/javascript"></script>

<!-- HttpUtil & PopupUtil 로드 -->
<script src="/resources/js/common/HttpUtil.js" type="text/javascript"></script>
<script src="/resources/js/common/PopupUtil.js" type="text/javascript"></script>
</head>
<%
String menuId = (String) request.getParameter("menuId");

if(myMenuListHeader != null){ //null이 아닌 경우에만 체크
	for(int i = 0; i<myMenuListHeader.size(); i++){
		if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
			myMenuFlag = true;
			break;
		}
	}
}
%>
<body >
<div id="wrapper"> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader_sub_v2"/>
<c:param name="part" value="header_v2"/>
</c:import>
<c:import charEncoding="utf-8" url="/main/leftMenuData.do">
<c:param name="page" value="sellerLeft_v2"/>
</c:import>
	<div class="containerBoxSub">
      <div class="PDleft50">    
		<div class="SubTit">
          <%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star"></button>
     	<%} %> VMI 권고발주접수
          <div class="SummaryGuide">
      	    <ul>
        	  <li><img src="/resources/imgs/Icon_Home.png" /></li>
              <li>VMI 납품관리</li>
              <li>VMI 권고발주접수</li>
            </ul>
          </div>
        </div>
        
        <div class="containerSub">  
          <div class="Importance01"><img src="/resources/imgs/Icon_Importance.png" /> 권고발주번호 클릭 시 송장 등록 팝업이 열립니다. 팝업 내용 확인 후 [송장등록] 버튼을 눌러 송장을 등록하세요.</div> 
          <table class="SearchTable01" >
            <colgroup>
              <col width="10%" />
              <col width="90%" />
            </colgroup>          	
            <tr>
              <th>권고발주일</th>
              <td >
                <div class="datepicker-wrap" style=" width:230px">
                  <div class="date-input"><input type="text" placeholder="" id="fromDate" readonly /><span> </span></div>
                  <span class="dash">~</span>
                  <div class="date-input"><input type="text" placeholder="" id="toDate" readonly /><span></span></div>
                </div>

                <button class="But_Month" data-months="1">1개월</button>
                <button class="But_Month" data-months="2">2개월</button>
                <button class="But_Month" data-months="3">3개월</button>
                <button class="But_Month" data-months="12">1년</button>
               </td>
            </tr>
          </table>
          
          <div class="SearchBtnBoxNoTab">
         	<button class="ButSmall_Outline" onclick="reset()">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="kepSearch()">조회</button> 
          </div>
          <!--grid-->
          <div class="ib-container" >
              <script type="text/javascript">
                  createIBSheet("mySheet", "100%", "500px");
              </script>
          </div> 
          
           <div class="h5"></div> 
   
          <div class="h30"></div>             
        </div> 
             
      </div>
    </div>   
        <div class="h5" style="height: 50px;"></div> 
<%@ include file="/WEB-INF/views/common/include/sellerFooter_sub_v2.jsp" %>
    
</div>
</body>

<script type="text/javascript">

  var sessionComCode = "${sessionInfo.comCode}";
  var dateRangePicker = null;
  var popupSel = "";
  var datePickerInstance = null; // DatePicker 인스턴스
  var vmiColumns = [
      {Align:"Center", SaveName:"sStatus",        Header:"상태",         Type:"Status",    Width:0,  Edit:false, EditLen:0,   Sort:0, Hidden:true},
      {Align:"Left",   SaveName:"WMS_NAME",       Header:"물류센터명",   Type:"Text",      Width:265, Edit:false, EditLen:50,  Sort:1, Hidden:false},
      {Align:"Center", SaveName:"VPO_NO",         Header:"권고발주번호", Type:"Text",      Width:150, Edit:false, EditLen:20,  Sort:1, Hidden:false, Cursor:"Pointer", FontColor:"#007bff", FontUnderline:true},
      {Align:"Right",  SaveName:"ITEM_AMT",       Header:"금액",         Type:"Int",       Width:150, Edit:false, EditLen:15,  Sort:1, Hidden:false, Format:"#,###"},
      {Align:"Right",  SaveName:"ITEM_CNT",       Header:"품목수",       Type:"Int",       Width:100,  Edit:false, EditLen:10,  Sort:1, Hidden:false, Format:"#,###"},
      {Align:"Center", SaveName:"RD_DATE",        Header:"입고요청일",   Type:"Date",      Width:150, Edit:false, EditLen:10,  Sort:1, Hidden:false},
      {Align:"Center", SaveName:"VPO_DATE",       Header:"발주일",       Type:"Date",      Width:150, Edit:false, EditLen:10,  Sort:1, Hidden:false},
      {Align:"Left",   SaveName:"VPO_REMARK",     Header:"비고",         Type:"Text",      Width:600, Edit:false, EditLen:400, Sort:1, Hidden:false},
      {Align:"Center", SaveName:"BUYER",          Header:"구매자",       Type:"Text",      Width:0,   Edit:false, EditLen:20,  Sort:0, Hidden:true},
      {Align:"Left",   SaveName:"DELY_TO_LOCATION", Header:"배송지",     Type:"Text",      Width:0,   Edit:false, EditLen:100, Sort:0, Hidden:true}
  ];

  var mySheet = new IBSheetWrapper("mySheet", "VMI 권고발주접수");
  mySheet.initialize(vmiColumns);


/*   mySheet.SetOnSearchEnd(function(code, Msg, StCode, StMsg, response) {

  }); */

  // DatePicker.js 달력 초기화 (년월일 범위 선택)
  if (typeof DatePicker !== 'undefined') {
      datePickerInstance = new DatePicker({
          type: 'range',
          fromId: 'fromDate',
          toId: 'toDate',
          dateFormat: '/',  // YYYY/MM/DD 형식
          locale: 'ko'
      });
      datePickerInstance.init();
      // 초기 날짜 설정 (3개월 전 ~ 오늘)
      datePickerInstance.setRangeByMonths(3);
      console.log('[VMI권고발주접수] DatePicker.js 달력 초기화 완료');
  } else {
      console.error('[VMI권고발주접수] DatePicker.js가 로드되지 않았습니다.');
  }



  
  mySheet.setOnClick(function(Row, Col, Value, CellX, CellY, CellW, CellH) {
      var st_vpo_no = this.getCellValue(Row, "VPO_NO");
      if (!st_vpo_no || st_vpo_no.trim() === "") {
          return;
      }

      var st_agent = sessionComCode || "";
      var st_item_amt = this.getCellValue(Row, "ITEM_AMT");
      var st_rd_date = this.getCellValue(Row, "RD_DATE");
      var st_vpo_date = this.getCellValue(Row, "VPO_DATE");
      var st_buyer = this.getCellValue(Row, "BUYER");
      var st_dely_to_location_text = this.getCellValue(Row, "DELY_TO_LOCATION");

      // ========== 기존 팝업 호출 (주석 처리) ==========
      // doPop("commonMpIvDetailInvoiceCreationPop", st_vpo_no, st_item_amt, st_rd_date, st_vpo_date, st_buyer, st_dely_to_location_text);

      // ========== 새로운 PopupUtil 팝업 호출 ==========
      openRecommandOrderDetailPopup(st_vpo_no, st_item_amt, st_rd_date, st_vpo_date, st_buyer, st_dely_to_location_text);
  });

  function reset() {
      // 날짜 초기화 (DatePicker.js 사용 - 3개월 전 ~ 오늘)
      if (datePickerInstance) {
          datePickerInstance.setRangeByMonths(3);
          console.log('[VMI권고발주접수] DatePicker 날짜 초기화 완료');
      }

      if (mySheet) {
          mySheet.removeAll();
      }
  }

  function kepSearch(){
      // MonthNew.js 달력에서 직접 날짜 가져오기 (YYYY/MM/DD 형식)
      var fromDateValue = document.getElementById('fromDate').value || '';
      var toDateValue = document.getElementById('toDate').value || '';

      // "/" 제거하여 YYYYMMDD 형식으로 변환
      var fromDate = fromDateValue.replace(/\//g, '');
      var toDate = toDateValue.replace(/\//g, '');

      var searchParams = "st_from_date=" + fromDate + "&st_to_date=" + toDate;

      if (!mySheet) {
          console.error("IBSheetWrapper 인스턴스를 찾을 수 없습니다 - mySheet 초기화 필요");
          alert("시스템 초기화 오류. 새로고침 해주세요.");
          return;
      }
      mySheet.DoSearch("/mpst/getSellerMpStRecmndOrderReceiptList_v2.do", searchParams);
  }

  // ========== 기존 팝업 함수 (주석 처리) ==========
  /*
  function doPop(str, value1, value2, value3, value4, value5, value6) {
      switch (str) {
          case "commonMpIvDetailInvoiceCreationPop":
              var st_agent = "${sessionInfo.comCode}";
              var st_vpo_no = value1;
              var st_item_amt = value2;
              var st_rd_date = value3;
              var st_vpo_date = value4;
              var st_buyer = value5;
              var st_dely_to_location_text = value6;
              var param = "?st_agent="+st_agent+"&st_vpo_no="+st_vpo_no+"&st_item_amt="+st_item_amt+"&st_rd_date="+st_rd_date+"&st_vpo_date="+st_vpo_date+"&st_buyer="+st_buyer+"&st_dely_to_location_text="+st_dely_to_location_text+"&popup_width=1150&popup_height=580";

              popupSel = "commonMpIvDetailInvoiceCreationPop";
              openCenterPopup("/mpiv/getCommonMpIvDetailInvoiceCreationPop.do" + param, "invoicePopup", 1215, 500);
              break;
      }
  }
  */

  // 가운데 위치 팝업 함수
  function openCenterPopup(url, name, width, height) {
      // 듀얼 모니터 환경 고려
      var screenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
      var screenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
      
      // 현재 창의 크기
      var innerWidth = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
      var innerHeight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
      
      // 팝업 위치 계산 (가운데)
      var left = ((innerWidth / (2)) - (width / (2))) + screenLeft;
      var top = ((innerHeight / (2)) - (height / (2))) + screenTop;
      
      // 팝업 옵션 설정 - resizable=no로 변경하여 크기 조정 불가능하게 설정
      var features = 'scrollbars=yes,width=' + width + ',height=' + height + ',top=' + top + ',left=' + left;
      features += ',directories=no,location=no,menubar=no,resizable=no,status=no,toolbar=no';
      
      // 팝업 열기
      var popup = window.open(url, name, features);
      
      // 포커스
      if (popup && popup.focus) {
          popup.focus();
      }
      
      return popup;
  }

  function setPopupReturn(code, text){
      if (popupSel == "commonMpIvDetailInvoiceCreationPop") {
          kepSearch();
      }
  }

  // ========== PopupUtil을 사용한 권고발주 상세 팝업 ==========
  /**
   * 권고발주 상세 팝업 열기
   * @param {string} vpoNo - 권고발주번호
   * @param {string} itemAmt - 금액합계
   * @param {string} rdDate - 입고요청일
   * @param {string} vpoDate - 권고발주일
   * @param {string} buyer - 구매자 코드
   * @param {string} delyLocation - 배송지
   */
  function openRecommandOrderDetailPopup(vpoNo, itemAmt, rdDate, vpoDate, buyer, delyLocation) {
      console.log('[권고발주접수] 팝업 열기 시작:', {
          vpoNo: vpoNo,
          itemAmt: itemAmt,
          rdDate: rdDate,
          vpoDate: vpoDate,
          buyer: buyer,
          delyLocation: delyLocation
      });

      // PopupUtil 사용 가능 여부 확인
      if (typeof PopupUtil === 'undefined') {
          console.error('[권고발주접수] PopupUtil이 로드되지 않았습니다.');
          alert('팝업 유틸리티를 불러올 수 없습니다. 페이지를 새로고침 해주세요.');
          return;
      }

      // PopupUtil.callback 패턴 사용
      PopupUtil.callback(function(api) {
          console.log('[권고발주접수] 팝업 API 받음:', api);

          // 팝업 데이터 설정 (agent, buyer 추가)
          api.setData({
              vpoNo: vpoNo || '-',
              vpoDate: vpoDate || '-',
              itemAmt: itemAmt || '-',
              rdDate: rdDate || '-',
              delyLocation: delyLocation || '-',
              agent: sessionComCode || '',  // 공급사 코드
              buyer: buyer || ''  // 구매자 코드 (IBSheet에서 전달받음)
          });

          // 송장등록 성공 콜백 설정
          api.onInvoice(function(response) {
              console.log('[권고발주접수] 송장등록 성공:', response);

              // 리스트 새로고침
              kepSearch();
          });

          // 팝업 닫기 콜백 설정 (선택사항)
          api.onClose(function() {
              console.log('[권고발주접수] 팝업이 닫혔습니다.');
          });

      }).show(PopupUtil.POPUP_URLS.RECOMMAND_ORDER_DETAIL);
  }

  // ========================================
  // 월별 버튼 이벤트 핸들러 (DatePicker.js 사용)
  // ========================================
  $(document).ready(function() {
      // 월별 버튼 이벤트
      $('.But_Month').each(function() {
          $(this).on('click', function() {
              var months = parseInt($(this).attr('data-months'), 10);
              if (datePickerInstance && !isNaN(months)) {
                  datePickerInstance.setRangeByMonths(months);
                  console.log('[VMI권고발주접수] 날짜 범위 설정:', months + '개월');
              }
              return false;
          });
      });

      // 화면 진입 시 자동 조회
      kepSearch();
  });

</script>
</html>
