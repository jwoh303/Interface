<%--
**********************************************
* 메뉴 : 재고관리>VMI 납품관리>재고현황조회 [리뉴얼 버전]
* 화면 : 재고현황조회 (Renewal Version)
* 기능 : 
* 프로그램 ID : SU0504004
* 담당자 : 원지성
* 리뉴얼 : 2025-09-02
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

<!-- IBSheet 래퍼 -->
<script src="/resources/js/common/IBSheetWrapper.js" type="text/javascript"></script>
</head>

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
          <button class="But_Star" ><!-- 즐겨찾기저장 class="But_Star_on" -->  </button> VMI 재고현황조회
          <div class="SummaryGuide">
      	    <ul>
        	  <li><img src="/resources/imgs/Icon_Home.png" /></li>
              <li>VMI 납품관리</li>
              <li>VMI 재고현황조회</li>
            </ul>
          </div>
        </div>
        
        <div class="containerSub"><!--margin-right:50px; 설정 -->  
          <table class="SearchTable02" >
            <colgroup>
              <col width="6%" />
              <col width="19%" />
              <col width="6%" />
              <col width="19%" />
              <col width="6%" />
              <col width="19%" />
              <col width="6%" />
              <col width="19%" />
            </colgroup>          	
            <tr>
              <th>물류센터</th>
              <td >
                <select name="st_buyer" id="st_buyer" class="Select" style="width:95%;">
                  <option value="">선택</option>
                 <option value="KRKORE0562">코리아이플랫폼㈜ IT</option><option value="KRKORE0592">코리아이플랫폼㈜ SPC</option><option value="KRKORE0160">코리아이플랫폼㈜ 거제센터</option><option value="KRKORE0522">코리아이플랫폼㈜ 광주센터</option><option value="KRKORE0192">코리아이플랫폼㈜ 구미센터</option><option value="KRKORE0608">코리아이플랫폼㈜ IT남동물류센터</option><option value="KRKORE0404">코리아이플랫폼㈜ 대전센터</option><option value="KRKORE0500">코리아이플랫폼㈜ 석포 물류센터</option><option value="KRKORE0440">코리아이플랫폼㈜ 중앙HUB</option><option value="KRKORE0668">코리아이플랫폼㈜ 수출검수센터</option><option value="KRKORE0412">코리아이플랫폼㈜ 안산센터</option><option value="KRKORE0424">코리아이플랫폼㈜ 여수센터(GS)</option><option value="KRKORE0370">코리아이플랫폼㈜ 울산센터</option><option value="KRKORE0068">코리아이플랫폼㈜ 창원센터</option>

                </select>               
               </td>
               <th>품목명</th>
               <td><input class="input30" style="width:92%" name="st_description" id="st_description" type="text" /></td>
               <th>규격</th>
               <td><input class="input30" style="width:92%" name="st_specification" id="st_specification" type="text" /></td>
               <th>품목코드</th>
               <td><input class="input30" style="width:92%" name="st_buyer_item_no" id="st_buyer_item_no" type="text" /></td>                        
            </tr>
          </table>
          <div class="SearchBtnBoxNoTab">
         	<button class="ButSmall_Outline" onclick="reset()">초기화</button> 
        	<button class="ButMSmallDarkGray" onclick="kepSearch()">조회</button> 
          </div>
          <div class="ListBtnBox">
            <div class="left"><button class="But_ExcelDown40" onclick="doAction('excelDown')">엑셀다운로드</button></div>
            <div class="right"> </div>
          </div>          
          <div class="IBSheet">
              <!--grid-->
              <div class="ib-container" >
                  <script type="text/javascript">
                      createIBSheet("mySheet", "100%", "500px");
                  </script>
              </div>   
              
               <div class="h5"></div> 
   
          <div class="h30"></div>                       
          </div><!--IBSheet 끝 --> 
     
        </div><!-- containerSub 끝 --> 
             
      </div> <!--padding-left:50px; 끝 -->
    </div><!--containerBoxSub-->   
         <div class="h5" style="height: 50px;"></div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter_sub_v2.jsp" %>
    
</div>
</body>

<script type="text/javascript">

var sessionComCode = "${sessionInfo.comCode}";
var popupSel = "";

// 재고현황 컬럼 정의
var stockColumns = [
    {Align:"Center", SaveName:"sStatus",            Header:"상태",           Type:"Status",    Width:0,  Edit:false, EditLen:0,   Sort:0, Hidden:true,RowMerge: 0},
    {Align:"Left",   SaveName:"WAREHOUSE_NAME",     Header:"물류센터명",     Type:"Text",      Width:200, Edit:false, EditLen:100, Sort:1, Hidden:false,RowMerge: 0},
    {Align:"Center",   SaveName:"BUYER_ITEM_NO",      Header:"품목코드",       Type:"Text",      Width:150, Edit:false, EditLen:50,  Sort:1, Hidden:false,RowMerge: 0},
    {Align:"Left",   SaveName:"DESCRIPTION",        Header:"품목명",         Type:"Text",      Width:250, Edit:false, EditLen:200, Sort:1, Hidden:false,RowMerge: 0},
    {Align:"Left",   SaveName:"SPECIFICATION",      Header:"규격",           Type:"Text",      Width:250, Edit:false, EditLen:100, Sort:1, Hidden:false,RowMerge: 0},
    {Align:"Center", SaveName:"UNIT_MEASURE",       Header:"단위",           Type:"Text",      Width:120,  Edit:false, EditLen:10,  Sort:1, Hidden:false,RowMerge: 0},
    {Align:"Right",  SaveName:"TOT_QTY",            Header:"총재고",         Type:"Int",       Width:120, Edit:false, EditLen:10,  Sort:1, Hidden:false, Format:"#,###",RowMerge: 0},
    {Align:"Right",  SaveName:"AVAIL_QTY",          Header:"가용재고",       Type:"Int",       Width:120, Edit:false, EditLen:10,  Sort:1, Hidden:false, Format:"#,###",RowMerge: 0},
    {Align:"Right",  SaveName:"ALLOC_QTY",          Header:"출하대기 재고",  Type:"Int",       Width:120, Edit:false, EditLen:10,  Sort:1, Hidden:false, Format:"#,###", RowMerge: 0},
    {Align:"Right",  SaveName:"MAX_STOCK_QTY",      Header:"최대재고",       Type:"Int",       Width:120, Edit:false, EditLen:10,  Sort:1, Hidden:false, Format:"#,###",RowMerge: 0},
    {Align:"Right",  SaveName:"MIN_ORDER_QTY",      Header:"최소재고",       Type:"Int",       Width:120, Edit:false, EditLen:10,  Sort:1, Hidden:false, Format:"#,###",RowMerge: 0}
];

var mySheet = new IBSheetWrapper("mySheet", "재고현황조회");
mySheet.initialize(stockColumns);

function reset() {
    $("#st_description").val("");
    $("#st_specification").val("");
    $("#st_buyer_item_no").val("");
    $("#st_buyer").val("");
    if (mySheet) {
        mySheet.removeAll();
    }
}

function kepSearch() {
    var searchParams = "st_description=" + encodeURIComponent($("#st_description").val());
    searchParams += "&st_specification=" + encodeURIComponent($("#st_specification").val());
    searchParams += "&st_buyer_item_no=" + encodeURIComponent($("#st_buyer_item_no").val());
    searchParams += "&st_buyer=" + encodeURIComponent($("#st_buyer").val());
    searchParams += "&st_com_code=" + sessionComCode;

    if (!mySheet) {
        console.error("IBSheetWrapper 인스턴스를 찾을 수 없습니다 - mySheet 초기화 필요");
        alert("시스템 초기화 오류. 새로고침 해주세요.");
        return;
    }
    mySheet.DoSearch("/mpst/getSellerMpStStockStateList_v2.do", searchParams);
}

function doAction(str) {
    switch (str) {
    case "excelDown": // 엑셀다운로드 - IBSheetWrapper 사용
        mySheet.downloadExcel({
            FileName: "재고현황조회_" + new Date().toISOString().slice(0, 10).replace(/-/g, ''),
            SheetName: "재고현황조회",
            HiddenColumn: 1
        });
        break;
    }
}

// 페이지 로드 시 물류센터 목록 로드
$(document).ready(function() {
    // Enter key event handlers for search inputs
    $("#st_description").on("keypress", function(e) {
        if (e.which === 13 || e.keyCode === 13) {
            e.preventDefault();
            kepSearch();
        }
    });

    $("#st_specification").on("keypress", function(e) {
        if (e.which === 13 || e.keyCode === 13) {
            e.preventDefault();
            kepSearch();
        }
    });

    $("#st_buyer_item_no").on("keypress", function(e) {
        if (e.which === 13 || e.keyCode === 13) {
            e.preventDefault();
            kepSearch();
        }
    });

    // 물류센터 옵션 로드 (기존 로직 활용)
    loadWarehouseOptions();
});

function loadWarehouseOptions() {
    // 서버에서 물류센터 목록을 가져와서 select 옵션으로 설정
    // 기존 CommonUtil.getCodeComboQueryIdList 로직을 AJAX로 구현 필요
    // 임시로 빈 상태로 둡니다 (실제 구현시 추가)
}

// ========================================
// 화면 진입 시 자동 조회
// ========================================
$(document).ready(function() {
    // 화면 진입 시 자동 조회
    kepSearch();
});

</script>
</html>