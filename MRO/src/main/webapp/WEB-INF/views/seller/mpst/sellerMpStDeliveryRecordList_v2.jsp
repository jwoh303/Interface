<%--
**********************************************
* 메뉴 : 재고관리>VMI 납품관리>납품실적조회 [리뉴얼 버전]
* 화면 : 납품실적조회 (Renewal Version)
* 기능 : 
* 프로그램 ID : SU0504003
* 담당자 : 원지성

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
	
		<!-- 컨텐츠 -->
	<div class="containerBoxSub" >
      <div class="PDleft50"><!--padding-left:50px; 시작 -->    
		<div class="SubTit">
          <%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star"></button>
     	<%} %> VMI 납품실적조회
          <div class="SummaryGuide">
      	    <ul>
        	   <li><img src="/resources/imgs/Icon_Home.png" /></li>
              <li>VMI 납품관리</li>
              <li>VMI 납품실적조회</li>
            </ul>
          </div>
        </div>
        
        <div class="containerSub"><!--margin-right:50px; 설정 -->  
          <table class="SearchTable02" >
            <colgroup>
              <col width="10%" />
              <col width="55%" />
              <col width="10%" />
              <col width="25%" />
            </colgroup>          	
            <tr>
              <th>기간</th>
              <td >
                <select name="st_check_date" id="st_check_date" class="Select" style=" float:left;width:200px; margin-right:5px">
                  <option value="GR">납품확정일</option>
                  <option value="PO">권고발주일</option>
                </select>               
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
               <th>입고여부</th>
               <td>
                 <select name="st_status_ing" id="st_status_ing" class="Select" style="width:99%">
                  <option value="">전체</option>
                  <option value="A">권고발주</option>
                  <option value="B">송장생성</option>
                  <option value="C">입고완료</option>
                </select>
               </td>
            </tr>
          </table>
          <div class="SearchBtnBoxNoTab">
         	<button class="ButSmall_Outline" onclick="reset()">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="kepSearch()">조회</button> 
          </div>
          
          <!--엑셀 버튼 - 테이블 상단 이동-->
          <div class="ListBtnBox">
            <div class="left">
              <button class="But_ExcelDown40" onclick="doAction('excelDown')">엑셀다운로드</button>
            </div>
            <div class="right"></div>
          </div>
          
          <!--grid-->
          <div class="ib-container" >
              <script type="text/javascript">
                  createIBSheet("mySheet", "100%", "500px");
              </script>
          </div>   
          
           <div class="h5"></div> 
   
          <div class="h30"></div>                       
        </div><!-- containerSub 끝 --> 
             
      </div> <!--padding-left:50px; 끝 -->
    </div><!--containerBoxSub-->   
         <div class="h5" style="height: 50px;"></div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter_sub_v2.jsp" %>
    
</div>
</body>

<script type="text/javascript">

var sessionComCode = "${sessionInfo.comCode}";
var dateRangePicker = null;
var popupSel = "";
var datePickerInstance = null; // DatePicker 인스턴스

// 납품실적 컬럼 정의
var deliveryColumns = [
    {Align:"Center", SaveName:"sStatus",            Header:"상태",           Type:"Status",    Width:0,  Edit:false, EditLen:0,   Sort:0, Hidden:true},
    {Align:"Left",   SaveName:"BUYER",              Header:"고객사코드",     Type:"Text",      Width:0,  Edit:false, EditLen:20,  Sort:0, Hidden:true},
    {Align:"Left",   SaveName:"WMS_NAME",           Header:"물류센터명",     Type:"Text",      Width:200, Edit:false, EditLen:100, Sort:1, Hidden:false},
    {Align:"Center", SaveName:"RECV_FLAG_NAME",     Header:"입고여부",       Type:"Text",      Width:100, Edit:false, EditLen:20,  Sort:1, Hidden:false},
    {Align:"Center", SaveName:"VPO_NO",             Header:"발주송장번호",   Type:"Text",      Width:150, Edit:false, EditLen:20,  Sort:1, Hidden:false, Cursor:"Pointer", FontColor:"#007bff", FontUnderline:true},
    {Align:"Center", SaveName:"BUYER_ITEM_NO",      Header:"품목코드",       Type:"Text",      Width:120, Edit:false, EditLen:50,  Sort:1, Hidden:false},
    {Align:"Left",   SaveName:"SPECIFICATION",      Header:"규격",           Type:"Text",      Width:150, Edit:false, EditLen:100, Sort:1, Hidden:false},
    {Align:"Center", SaveName:"UNIT_MEASURE",       Header:"단위",           Type:"Text",      Width:80,  Edit:false, EditLen:10,  Sort:1, Hidden:false},
    {Align:"Right",  SaveName:"ITEM_QTY",           Header:"발주수량",       Type:"Int",       Width:100, Edit:false, EditLen:10,  Sort:1, Hidden:false, Format:"#,###"},
    {Align:"Right",  SaveName:"IV_QTY",             Header:"송장수량",       Type:"Int",       Width:100, Edit:false, EditLen:10,  Sort:1, Hidden:false, Format:"#,###"},
    {Align:"Right",  SaveName:"GR_QTY",             Header:"입고수량",       Type:"Int",       Width:100, Edit:false, EditLen:10,  Sort:1, Hidden:false, Format:"#,###"},
    {Align:"Center", SaveName:"VPO_DATE",           Header:"권고발주일",     Type:"Date",      Width:100, Edit:false, EditLen:10,  Sort:1, Hidden:false},
    {Align:"Center", SaveName:"VIV_DATE",           Header:"납품요청일",     Type:"Date",      Width:100, Edit:false, EditLen:10,  Sort:1, Hidden:false},
    {Align:"Center", SaveName:"VGR_DATE",           Header:"납품확정일",     Type:"Date",      Width:100, Edit:false, EditLen:10,  Sort:1, Hidden:false},
    {Align:"Left",   SaveName:"VPO_REMARK",         Header:"비고",           Type:"Text",      Width:200, Edit:false, EditLen:400, Sort:1, Hidden:false}
];

var mySheet = new IBSheetWrapper("mySheet", "VMI 납품실적조회");
mySheet.initialize(deliveryColumns);

mySheet.setOnClick("VPO_NO", function(Row, Col, Value, CellX, CellY, CellW, CellH) {
    var st_vpo_no = this.getCellValue(Row, "VPO_NO");
    if (!st_vpo_no || st_vpo_no.trim() === "") {
        return;
    }

    var st_buyer = this.getCellValue(Row, "BUYER") || "";
    var st_agent = sessionComCode || "";

    // 납품명세서 RD 오픈
    doAction('reportOpen', st_buyer, st_vpo_no);
});

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
    console.log('[VMI납품실적조회] DatePicker.js 달력 초기화 완료');
} else {
    console.error('[VMI납품실적조회] DatePicker.js가 로드되지 않았습니다.');
}

function reset() {
    // 날짜 초기화 (DatePicker.js 사용 - 3개월 전 ~ 오늘)
    if (datePickerInstance) {
        datePickerInstance.setRangeByMonths(3);
        console.log('[VMI납품실적조회] DatePicker 날짜 초기화 완료');
    }

    $("#st_check_date").val("GR");
    $("#st_status_ing").val("");
    if (mySheet) {
        mySheet.removeAll();
    }
}

function kepSearch() {
    // MonthNew.js 달력에서 직접 날짜 가져오기 (YYYY/MM/DD 형식)
    var fromDateValue = document.getElementById('fromDate').value || '';
    var toDateValue = document.getElementById('toDate').value || '';

    // "/" 제거하여 YYYYMMDD 형식으로 변환
    var fromDate = fromDateValue.replace(/\//g, '');
    var toDate = toDateValue.replace(/\//g, '');
    var checkDate = $("#st_check_date").val();
    var statusIng = $("#st_status_ing").val();

    var searchParams = "st_from_date=" + fromDate + "&st_to_date=" + toDate;
    searchParams += "&st_check_date=" + checkDate;
    searchParams += "&st_status_ing=" + statusIng;

    if (!mySheet) {
        console.error("IBSheetWrapper 인스턴스를 찾을 수 없습니다 - mySheet 초기화 필요");
        alert("시스템 초기화 오류. 새로고침 해주세요.");
        return;
    }
    mySheet.DoSearch("/mpst/getSellerMpStDeliveryRecordList_v2.do", searchParams);
}

function doAction(str, value1, value2) {
    switch (str) {
    case "excelDown": // 엑셀다운로드 - IBSheetWrapper 사용
        mySheet.downloadExcel({
            FileName: "VMI_납품실적조회_" + new Date().toISOString().slice(0, 10).replace(/-/g, ''),
            SheetName: "VMI 납품실적조회",
            HiddenColumn: 1
        });
        break;

    case "reportOpen": // 납품명세서 RD
        var st_buyer = value1;
        var st_vpo_no = value2;
        var st_agent = sessionComCode;
        var rpt_url = "";
        
        // 고객사에 따른 REPORT 양식(기본 : RD_06_S_003_04)
        if(st_buyer == "KRKORE0424"){ // GS칼텍스 여수 물류센터
            rpt_url = "RD_06_S_003_50";
        }else{
            rpt_url = "RD_06_S_003_04";
        }
        
        reportOpen(rpt_url,"["+value1+"]["+value2+"]["+st_agent+"]"); 
        break;
    }
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
                console.log('[VMI납품실적조회] 날짜 범위 설정:', months + '개월');
            }
            return false;
        });
    });

    // 화면 진입 시 자동 조회
    kepSearch();
});

</script>
</html>