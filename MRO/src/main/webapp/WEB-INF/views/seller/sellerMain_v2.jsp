<%@page import="com.diquest.ir.util.common.DateUtil"%>
<%@page import="com.ctc.wstx.util.DataUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../common/include/head_v2.jspf"  %>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("total_data"); // 조회된결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _commonNoticeList = (List<Map<String,String>>) request.getAttribute("common_notice_data"); // 전체 공지사항
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _companyNoticeList = (List<Map<String,String>>) request.getAttribute("company_notice_data"); // 고객사별 공지사항
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _poMngList = (List<Map<String,String>>) request.getAttribute("po_mng_data"); // 조회된결과
Map<String,String> rowData = (_gridList != null && _gridList.size() > 0) ? _gridList.get(0) : new HashMap<String, String>();
Map<String,String> poMngData = (_poMngList != null && _poMngList.size() > 0) ? _poMngList.get(0) : new HashMap<String, String>();
String currentDate = DateTimeUtil.getFormatString("yyyyMMdd");
String currentYear = currentDate.substring(0,4);
String currentMonth = currentDate.substring(4,6);
String currentDay = currentDate.substring(6,8);


String SessionComCode		= _sessionInfo.getComCode();
String SessionComName		= _sessionInfo.getComNameLoc();
String SessionUserName		= _sessionInfo.getUserNameLoc();
String check_date			= currentDate;

// 미확인 공지사항 건수 (백엔드에서 전체 count 조회)
@SuppressWarnings (value="unchecked")
Map<String,Object> _unreadCountMap = (Map<String,Object>) request.getAttribute("unread_notice_count");
int unreadNoticeCount = 0;
if (_unreadCountMap != null && _unreadCountMap.get("TOTAL_UNREAD") != null) {
	unreadNoticeCount = ((java.math.BigDecimal) _unreadCountMap.get("TOTAL_UNREAD")).intValue();
}

%> 


<style>
/* FAQ p 태그 자동 너비 조정 */
.FAQ p {
    width: fit-content !important;
    width: -moz-fit-content !important;
    width: -webkit-fit-content !important;
    max-width: 100%;
    display: block !important;
}
</style>
</head>
<script type="text/javascript">

var popupSel = "";
function kep_init(){

	if (getCookie("ncookpopup") != "donepopup") {
// 		doPop("seller_popup");
	}

	var unreadCount = <%= unreadNoticeCount %>;
	if (unreadCount > 0) {
		// 미확인 공지 강제 팝업 우선 표시
		setTimeout(function() { showUnreadNoticePopup(); }, 500);
	}
}

/**
 * 미확인 공지사항 강제 팝업 호출
 */
function showUnreadNoticePopup() {
	var unreadCount = <%= unreadNoticeCount %>;
	if (unreadCount <= 0) return;
	PopupUtil.showUnreadNotice(function(popup) {
		popup.setCount(unreadCount)
			 .onGoToNotice(function() {
				 location.href = '/mscs/sellerMCSCNotice.do?menuId=sr00701000000';
			 });
	});
}

//팝업함수호출
function doPop(str, value1, value2) {
	popupSel = str;

	switch (str) {
		case "icomcmpyPop":	// 거래명세서 양식 팝업
			openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=B&MULTI=N','500,466,no');
			break;
		case "seller_notice":  // 협력사 공지사항
			openSearchPopup('/none/showSellerNoNeNoticeListPop.do','?st_company=<%=SessionComCode%>','700,455,no');
			break;
		case "seller_notice_detail":  // 협력사 공지사항 상세정보
			openSearchPopup("/none/showSellerNoNeNoticeDetailPop.do", "?st_btype="+value1+"&st_bid="+value2, "800,600,no");
			break;
		case "seller_popup":  // 협력사 팝업
			openSearchPopup("/none/showSellerNoNePopupListPop.do", "?st_com_code=<%=SessionComCode%>", "600,435,no");
			break;
	} 
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	var checkFlag = response.check_flag;
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("조회에 실패하였습니다.\n\n관리자에 문의 하여 주십시오."); 
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, name) {
	//팝업 조회후 해당 항목에 값을 셋팅
	
	switch (popupSel) {
		case "icomcmpyPop":
			
			var buyer = code;
			var seller = "<%=_sessionInfo.getComCode()%>";
			var reportId = "";
			
			if(buyer == "KRDAEW0016"){
				reportId = "RD_06_S_003_13";
			} else if(buyer=="KRDONG0110" || buyer=="KRDONG0107" || buyer=="KRDONG0128" || buyer=="KRDONG0099" || buyer=="KRDONG0153") {
				reportId = "RD_06_S_003_14";
			} else if(buyer=="KRDONG0119") {
				reportId = "RD_06_S_003_15";
			} else if(buyer=="KRDOOS0046") {
				reportId = "RD_06_S_003_16";
			} else {
				reportId = "RD_06_S_001_90";
			} 
			reportOpen(reportId, "["+buyer+"]["+seller+"]");
			if(buyer=="KRKORE0212" || buyer=="KRKEPB0004"){
				setTimeout("documentDownload()",1000); 
			}
			break;
	}
}

function documentDownload(){
	if(confirm("품질보증서 양식을 다운로드 하시겠습니까?")){
		document.location.href = "/resources/excel/work/INVOICE/sellerWarrantyForm.doc";
	}
}

/**
 * 화면 로드 시 자동 팝업 표시
 * - 캐시 삭제 후 자동 재표시 기능 포함
 * - 상태: null → pending → cache_cleared → completed
 */
function showAutoPopup() {
	var OLD_KEY = 'mro_renewal_notice_shown';
	var NOTICE_POPUP_KEY = 'mro_renewal_notice_state';

	// 마이그레이션: 기존 키가 있으면 새 키로 변환 (기존 사용자 호환)
	if (localStorage.getItem(OLD_KEY) === 'true') {
		localStorage.setItem(NOTICE_POPUP_KEY, 'completed');
		localStorage.removeItem(OLD_KEY);
	}

	var state = localStorage.getItem(NOTICE_POPUP_KEY);

	// completed 상태면 팝업 표시 안 함
	if (state === 'completed') {
		return;
	}

	// 최초 방문 여부와 캐시 삭제 완료 여부 확인
	var isFirstVisit = !state;  // state가 null이면 최초 방문
	var isCacheCleared = (state === 'cache_cleared');

	// 최초 방문 시 pending 상태로 설정
	if (!state) {
		localStorage.setItem(NOTICE_POPUP_KEY, 'pending');
	}

	PopupUtil.open({
		url: '/resources/html/common/popup/popup_auto_notice.html',
		animation: 'fromButton',
		data: {
			isFirstVisit: isFirstVisit,
			isCacheCleared: isCacheCleared  // 캐시 삭제 완료 여부 전달
		}
	});
}

//공지문 쿠키
function getCookie(name) {
	var nameOfCookie = name + "=";
	var x = 0

	while ( x <= document.cookie.length ) {
		var y = (x+nameOfCookie.length);
		if ( document.cookie.substring( x, y ) == nameOfCookie ) {
			if ( (endOfCookie=document.cookie.indexOf( ";",y )) == -1 )
				endOfCookie = document.cookie.length;
				return unescape( document.cookie.substring(y, endOfCookie ) );
		}
		x = document.cookie.indexOf( " ", x ) + 1;
		if ( x == 0 )
		break;
	}
	return "";
}  
</script>
<body onLoad="kep_init();">
<div id="wrapper">
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader_sub_v2"/>
<c:param name="part" value="header_v2"/>
</c:import>
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<!-----------------------------------------------------------------------------------------------left------------------------------------------------------------------------------------------------------->
<c:import charEncoding="utf-8" url="/main/leftMenuData.do">
<c:param name="page" value="sellerLeft_v2"/>
</c:import>

<!-----------------------------------------------------------------------------------------------left------------------------------------------------------------------------------------------------------->
	<div class="containerBox" >
	  <div class="container">
	  <div class="h50"></div>
        <div class="SellerState">
        <div class="Hello"><span><%=SessionUserName %>님 </span> 안녕하세요! <p>집계기준: 최근 3개월</p></div>
        <div class="OrderBox">
            <div class="StateTit"><img src="/resources/imgs/seller_StateIcon01.png" /> 주문현황</div>
            <div class="OrderListrBox">
              <a class="OrderListLink" href="/mpiv/showSellerMpIvObtnodrReceipt.do?menuId=sr00402000000" /><p><%=CommonUtil.formatNumber(rowData.get("ORDER_RECEIVE_CNT"),true,0,3)%></p> 수주접수</a> 
              <span class="OrderListLinkBr"></span> 
              <a class="OrderListLink" href="/mpiv/showSellerMpIvTranStatementWrite.do?menuId=sr00403000000" /><p><%=CommonUtil.formatNumber(rowData.get("INVOICE_CRE_CNT"),true,0,3)%></p> 거래명세서 생성</a> 
              <span class="OrderListLinkBr"></span> 
              <a class="OrderListLink" href="/mpiv/showSellerMpIvDeliveryRecordReg.do?menuId=sr00404000000" /><p><%=CommonUtil.formatNumber(rowData.get("DELIVERY_RSLT_CRE_CNT"),true,0,3)%></p> 납품실적등록</a> 
            </div>
          </div>
           
          <div class="EstimateBox">
            <div class="StateTit"><img src="/resources/imgs/seller_StateIcon03.png" /> 견적현황</div>
            <div class="EstimateListrBox">
              <a class="EstimateListLink" href="/mprq/showSellerMpRqQuotList.do?menuId=sr00301000000" /><p><%=CommonUtil.formatNumber(rowData.get("ACCEPT_SOURCING_WRITE_CNT"),true,0,3)%></p> 일반 견적</a>
              <span class="EstimateListLinkBr"></span> 
              <a class="EstimateListLink" href="/mpcl/showSellerMpClCatalogRecharterList.do?menuId=sr00302000000" /><p><%=CommonUtil.formatNumber(rowData.get("ACCEPT_SOURCING_RE_WRITE_CNT"),true,0,3)%></p> 재계약 견적</a> 
              <span class="EstimateListLinkBr"></span> 
              <a class="EstimateListLink" href="/mprq/showSellerMpRqBulkQuotList.do?menuId=sr00303000000" /><p><%=CommonUtil.formatNumber(rowData.get("PROJECT_SOURCING_WRITE_CNT"),true,0,3)%></p> 프로젝트 견적</a>
            </div>
          </div>            
            
          <div class="ProductBox">
            <div class="StateTit"><img src="/resources/imgs/seller_StateIcon02.png" /> 상품현황</div>
            <div class="ProductListrBox"><a class="ProductListLink" href="/mdct/showSellerMdCmChemicalMatMngList.do?menuId=sr00202000000" /><p><%=CommonUtil.formatNumber(rowData.get("MATERIAL_REQUEST_CNT"),true,0,3)%></p>MSDS 대상</a></div>
          </div>
        </div><!-- SellerState 끝 -->
        
<!--         <div class="BeltBanner"><a href="/띠베너"><img src="/resources/imgs/seller_MBeltBanner.png" /></a></div> -->
         <div class="SellerBoard">
          <div class="BoardBox">
          	<div class="BoardBoxTit">요청현황<button class="ButSmall_Outline_RightIcon" onclick="location.href='/mpiv/showSellerMpIvDeliChangeReqList.do?menuId=sr00405000000'">더보기</button></div>
            <div class="Request">수주거부        <div><p>요청<span><%=CommonUtil.formatNumber(poMngData.get("ES_CNT"),true,0,3)%></span></p> <p>회신<span><%=CommonUtil.formatNumber(poMngData.get("EBC_CNT"),true,0,3)%></span></p></div></div>
            <div class="Request">거래유형 변경   <div><p>요청<span><%=CommonUtil.formatNumber(poMngData.get("DS_CNT"),true,0,3)%></span></p> <p>회신<span><%=CommonUtil.formatNumber(poMngData.get("DBC_CNT"),true,0,3)%></span></p></div></div>
            <div class="Request">납품예정일 변경 <div><p>요청<span><%=CommonUtil.formatNumber(poMngData.get("GS_CNT"),true,0,3)%></span></p> <p>회신<span><%=CommonUtil.formatNumber(poMngData.get("GBC_CNT"),true,0,3)%></span></p></div></div>
            <div class="Request">수주접수 초기화 <div><p>요청<span><%=CommonUtil.formatNumber(poMngData.get("IS_CNT"),true,0,3)%></span></p> <p>회신<span><%=CommonUtil.formatNumber(poMngData.get("IBC_CNT"),true,0,3)%></span></p></div></div>
          </div>
          <div class="BoardBox">
            <div class="BoardBoxTit">전체 공지사항 <button class="ButSmall_Outline_RightIcon" onclick="location.href='/mscs/sellerMCSCNotice.do?menuId=sr00701000000';">더보기</button></div>
            <%
	if (_commonNoticeList == null || _commonNoticeList.size() == 0){
%>
                	<div class="Notice"> 현재 목록에 나와 있는 자료가 없습니다. </div>
<%
	}else{
		for (int j=0; j<_commonNoticeList.size(); j++) {
			Map<String,String> noticeData = _commonNoticeList.get(j);
			String regDate = noticeData.get("REG_DATE");
			String readYn = noticeData.get("READ_YN");
			if (readYn == null || "".equals(readYn)) readYn = "N";
			boolean showNewIcon = "N".equals(readYn);
%>
					<div class="Notice"><p><%=CommonUtil.formatStrinigDate(regDate).replaceAll("/", ".")%></p><p><% if (showNewIcon) { %><img src="/resources/imgs/seller_new.png" style="margin-right:5px;vertical-align:middle;" /><% } %><a href="/mscs/sellerMCSCNotice.do?menuId=sr00701000000&bid=<%=CommonUtil.bnvl(noticeData.get("BID"))%>&btype=<%=CommonUtil.nvl(noticeData.get("BTYPE"))%>"><%=CommonUtil.nvl(noticeData.get("SUBJECT"))%></a></p></div>
 <%
		}
	}
%>
          </div>
          <div class="BoardBox">
            <div class="BoardBoxTit">고객사별 공지사항 <button class="ButSmall_Outline_RightIcon" onclick="location.href='/mscs/sellerMCSCNotice.do?menuId=sr00701000000&tab=4';">더보기</button></div>
            <%
	if (_companyNoticeList == null || _companyNoticeList.size() == 0){
%>
                	<div class="Notice"> 현재 목록에 나와 있는 자료가 없습니다. </div>
<%
	}else{
		for (int j=0; j<_companyNoticeList.size(); j++) {
			Map<String,String> companyNoticeData = _companyNoticeList.get(j);
			String regDate4 = companyNoticeData.get("REG_DATE");
			String readYn4 = companyNoticeData.get("READ_YN");
			if (readYn4 == null || "".equals(readYn4)) readYn4 = "N";
			boolean showNewIcon4 = "N".equals(readYn4);
%>
					<div class="Notice"><p><%=CommonUtil.formatStrinigDate(regDate4).replaceAll("/", ".")%></p><p><% if (showNewIcon4) { %><img src="/resources/imgs/seller_new.png" style="margin-right:5px;vertical-align:middle;" /><% } %><a href="/mscs/sellerMCSCNotice.do?menuId=sr00701000000&tab=4&bid=<%=CommonUtil.bnvl(companyNoticeData.get("BID"))%>&btype=<%=CommonUtil.nvl(companyNoticeData.get("BTYPE"))%>"><%=CommonUtil.nvl(companyNoticeData.get("SUBJECT"))%></a></p></div>
 <%
		}
	}
%>
<%-- ===== 자주 묻는 질문 섹션 주석 처리 (2026-01-13) =====
            <div class="FAQ"><p>납품관리</p><p><a href="/mscs/sellerMCSCNotice.do?menuId=sr00703000000&faqId=faq-seller-1">납품실적등록(택배 송장번호 등록, 납품완료일 입력)을 왜 해야 하나요?</a></p></div>
            <div class="FAQ"><p>마감관리</p><p><a href="/mscs/sellerMCSCNotice.do?menuId=sr00703000000&faqId=faq-seller-2">월마감 내역은 어디서 확인할 수 있나요?</a></p></div>
            <div class="FAQ"><p>수주관리</p><p><a href="/mscs/sellerMCSCNotice.do?menuId=sr00703000000&faqId=faq-seller-3">수주접수를 잘못했어요. 취소는 어디서 하나요?</a></p></div>
===== 자주 묻는 질문 섹션 주석 처리 끝 ===== --%>
          </div>
        </div>
	  </div>
    </div>
    
 <!-----------------------------------------------------------------------------------------------footer------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/sellerFooter_sub_v2.jsp" %>
<!-----------------------------------------------------------------------------------------------footer------------------------------------------------------------------------------------------------------->
    
</div>
</body>
</html>
