<%--
**********************************************
* 메뉴 : VMI 납품관리>VMI 마감조회
* 화면 : VMI 마감조회 리뉴얼 버전
* 기능 : 
* 프로그램 ID : PG_08_A_604_00
* 담당자 : 원지성 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../../common/include/head_v2.jspf" %>

<!-- DatePicker Calendar CSS -->
<link rel="stylesheet" href="/resources/css/month.css">

<!-- IBSheet 래퍼 (IBSheet 로드 후에 와야 함) -->
<script src="/resources/js/common/IBSheetWrapper.js" type="text/javascript"></script>

<!-- HttpUtil (리뉴얼 - customerSelectPopup 의존성) -->
<script src="/resources/js/common/HttpUtil.js" type="text/javascript"></script>

<!-- PopupUtil (리뉴얼 - 범용 팝업 유틸리티) -->
<script src="/resources/js/common/PopupUtil.js" type="text/javascript"></script>

<!-- LayerPopup 라이브러리 (리뉴얼) -->
<link rel="stylesheet" href="/resources/css/layerPopup.css">
<link rel="stylesheet" href="/resources/css/customerSelectPopup.css">
<script src="/resources/js/layerpopup/layerPopup.js" type="text/javascript"></script>
<script src="/resources/js/layerpopup/customerSelectPopup.js" type="text/javascript"></script>
</head>

<%
	// 세션 정보
	String st_com_code = (String) session.getAttribute("comCode");
	String st_user_id = (String) session.getAttribute("userId");
	
	// 조회조건 초기값
	String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");
	String st_buyer_name = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");
%>

<body>
<div id="wrapper"> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader_sub_v2"/>
<c:param name="part" value="header_v2"/>
</c:import>
<c:import charEncoding="utf-8" url="/main/leftMenuData.do">
<c:param name="page" value="sellerLeft_v2"/>
</c:import>

	<!-- 컨텐츠 시작 -->
	<div class="containerBoxSub">
		<div class="PDleft50">
			<div class="SubTit">
				<button class="But_Star"><!-- 즐겨찾기저장 class="But_Star_on" --></button> VMI 마감조회
				<div class="SummaryGuide">
					<ul>
						<li><img src="/resources/imgs/Icon_Home.png" /></li>
						<li>VMI 납품관리</li>
						<li>VMI 마감조회</li>
					</ul>
				</div>
			</div>
			
			<div class="containerSub">
				<table class="SearchTable02">
					<colgroup>
						<col width="10%" />
						<col width="50%" />
						<col width="10%" />
						<col width="30%" />
					</colgroup>
					<tr>
						<th>출고일자</th>
						<td>
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
						<th>고객사명</th>
						<td>
							<input type="text" id="st_buyer_name" name="st_buyer_name" class="input30" placeholder="고객사명을 입력하세요" value="<%=st_buyer_name%>" style="width:95%;">
						</td>
					</tr>
				</table>
				
				<div class="SearchBtnBoxNoTab">
					<button class="ButSmall_Outline" onclick="reset()">초기화</button>
					<button class="ButMSmallDarkGray" onclick="kepSearch();">조회</button>
				</div>
				
				<!-- 엑셀 다운로드 버튼을 테이블 상단 왼쪽으로 이동 -->
				<div class="ListBtnBox" style="margin-bottom: 10px;">
					<div class="left">
						<button class="But_ExcelDown40" onclick="doAction('excelDown')">엑셀다운로드</button>
					</div>
				</div>
				
				<!--grid-->
				<div class="ib-container">
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

<script type="text/javascript">

var sessionComCode = "${sessionInfo.comCode}";
var dateRangePicker = null;
var popupSel = "";
var datePickerInstance = null; // DatePicker 인스턴스
var closingColumns = [
    {Align:"Center", SaveName:"sStatus", Header:"상태", Type:"Status", Width:0, Edit:false, EditLen:0, Sort:0, Hidden:true},
    {Align:"Center", SaveName:"GR_DATE", Header:"출고일자", Type:"Date", Width:150, Edit:false, EditLen:10, Sort:1, Hidden:false},
    {Align:"Left",   SaveName:"BUYER_NAME", Header:"고객사명", Type:"Text", Width:200, Edit:false, EditLen:50, Sort:1, Hidden:false},
    {Align:"Center", SaveName:"PO_NO", Header:"발주번호", Type:"Text", Width:200, Edit:false, EditLen:20, Sort:1, Hidden:false},
    {Align:"Center", SaveName:"GR_NO", Header:"출고번호", Type:"Text", Width:200, Edit:false, EditLen:20, Sort:1, Hidden:false},
    {Align:"Left",   SaveName:"DESCRIPTION", Header:"품목명", Type:"Text", Width:300, Edit:false, EditLen:100, Sort:1, Hidden:false},
    {Align:"Left",   SaveName:"SPECIFICATION", Header:"규격", Type:"Text", Width:300, Edit:false, EditLen:50, Sort:1, Hidden:false},
    {Align:"Right",  SaveName:"ITEM_QTY", Header:"출고수량", Type:"Int", Width:120, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
    {Align:"Right",  SaveName:"AGENT_PRICE", Header:"단가", Type:"Int", Width:150, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
    {Align:"Right",  SaveName:"AGENT_ITEM_AMT", Header:"총금액", Type:"Int", Width:150, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"}
];

var mySheet = new IBSheetWrapper("mySheet", "VMI 마감조회");
mySheet.initialize(closingColumns);

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
    console.log('[VMI마감조회] DatePicker.js 달력 초기화 완료');
} else {
    console.error('[VMI마감조회] DatePicker.js가 로드되지 않았습니다.');
}

function reset() {
    // 날짜 초기화 (DatePicker.js 사용 - 3개월 전 ~ 오늘)
    if (datePickerInstance) {
        datePickerInstance.setRangeByMonths(3);
        console.log('[VMI마감조회] DatePicker 날짜 초기화 완료');
    }

    document.getElementById('st_buyer_name').value = '';
    if (mySheet) {
        mySheet.removeAll();
    }
}

function doAction(str) {
    if (str === "excelDown") {
        mySheet.downloadExcel({
            FileName: "VMI마감조회_" + new Date().toISOString().slice(0, 10).replace(/-/g, ''),
            SheetName: "VMI마감조회",
            HiddenColumn: 1
        });
    }
}

function kepSearch() {
    // MonthNew.js 달력에서 직접 날짜 가져오기 (YYYY/MM/DD 형식)
    var fromDateValue = document.getElementById('fromDate').value || '';
    var toDateValue = document.getElementById('toDate').value || '';

    // "/" 제거하여 YYYYMMDD 형식으로 변환
    var fromDate = fromDateValue.replace(/\//g, '');
    var toDate = toDateValue.replace(/\//g, '');

    console.log("날짜 범위:", fromDate, "~", toDate);

    // 조회조건 검증
    if (fromDate > toDate) {
        alert("출고 종료일은 시작일보다 작을 수 없습니다");
        return false;
    }

    var buyerName = document.getElementById('st_buyer_name').value.trim();
    console.log("고객사명:", buyerName);

    var searchParams = "st_from_date=" + fromDate + "&st_to_date=" + toDate +
                      "&st_buyer_name=" + encodeURIComponent(buyerName) +
                      "&st_com_code=" + encodeURIComponent(sessionComCode);

    console.log("검색 파라미터:", searchParams);

    if (!mySheet) {
        console.error("IBSheetWrapper 인스턴스를 찾을 수 없습니다 - mySheet 초기화 필요");
        alert("시스템 초기화 오류. 새로고침 해주세요.");
        return;
    }

    console.log("DoSearch 호출 직전");
    mySheet.DoSearch("/mpst/getSellerMpStClosingList_v2.do", searchParams);
}

// 고객사명 직접 입력 방식으로 변경됨 - 팝업 관련 코드 제거

// ========================================
// 월별 버튼 이벤트 핸들러 (DatePicker.js 사용)
// ========================================
$(document).ready(function() {
    // Enter key event handler for buyer name search input
    $("#st_buyer_name").on("keypress", function(e) {
        if (e.which === 13 || e.keyCode === 13) {
            e.preventDefault();
            kepSearch();
        }
    });

    // 월별 버튼 이벤트
    $('.But_Month').each(function() {
        $(this).on('click', function() {
            var months = parseInt($(this).attr('data-months'), 10);
            if (datePickerInstance && !isNaN(months)) {
                datePickerInstance.setRangeByMonths(months);
                console.log('[VMI마감조회] 날짜 범위 설정:', months + '개월');
            }
            return false;
        });
    });
});
</script>

</body>
</html>