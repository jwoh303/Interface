<%@page import="com.diquest.ir.util.common.DateUtil"%>
<%@page import="com.ctc.wstx.util.DataUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../common/include/head.jspf"  %>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("total_data"); // 조회된결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _noticeList = (List<Map<String,String>>) request.getAttribute("notice_data"); // 조회된결과
Map<String,String> rowData = (_gridList != null && _gridList.size() > 0) ? _gridList.get(0) : new HashMap<String, String>();
String currentDate = DateTimeUtil.getFormatString("yyyyMMdd");
String currentYear = currentDate.substring(0,4);
String currentMonth = currentDate.substring(4,6);
String currentDay = currentDate.substring(6,8);

String SessionComCode		= _sessionInfo.getComCode();
String SessionComName		= _sessionInfo.getComNameLoc();
String check_date			= currentDate;

%> 
</head>
<script type="text/javascript">
var popupSel = "";
function kep_init(){
	
	if (getCookie("ncookpopup") != "donepopup") {
		doPop("seller_popup");
	}

}

//팝업함수호출
function doPop(str, value1, value2) {
	popupSel = str;

	switch (str) {
		case "commonMpIvTranBuyerChoicePop": // 고객사선택
			openSearchPopup("/mpiv/getCommonMpIvTranBuyerChoicePop.do", "?st_com_code=<%=SessionComCode%>", "720,505,no");
			break;
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
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->

	<div id="container">
		<div style="margin-top:20px"><a href="https://kway.koreab2b.com/main.do"; target="_blank"><img src="/resources/images/AD_kway.jpg" /></a></div>
		<div class="viewBox">
            <div class="delivery_case">	
                <div>납기준수율(최근 1개월)<br> 기준일시: [ <span class="black"><%=String.valueOf(rowData.get("MV_CREATE_DATE"))%></span> ]</div>
                <div><h3>총 납품건수</h3><p><%=CommonUtil.formatNumber(rowData.get("TOTAL_DELIVERY_CNT"),true,0,3)%> 건</p></div>
                <div><h3>납기 준수건수</h3><p><%=CommonUtil.formatNumber(rowData.get("DEADLINE_DELIVERY_CNT"),true,0,3)%> 건</p></div>
                <div><h3>납기 준수율</h3><p><%=Math.round( (Double.parseDouble(String.valueOf(rowData.get("DEADLINE_DELIVERY_CNT"))) / Double.parseDouble(String.valueOf(rowData.get("TOTAL_DELIVERY_CNT")))) *100 )%>%</p></div>
            </div>
            <div class="delivery_num">		
                <div><h3>납기지연 건수</h3><p><a href="/mpiv/showSellerMpIvDeliveryDelayState.do?upperId=s00300000000"><%=CommonUtil.formatNumber(rowData.get("DELIVERY_DELAY_CNT"),true,0,3)%></a></p>
                    <span> 납품예정일이 지났으나 납품실적이 등록안된 건수</span></div>
                <div><h3>납기도래 건수</h3><p><a href="/mdam/showSellerMdAmDeadlineAdventCnt.do"><%=CommonUtil.formatNumber(rowData.get("DELIVERY_COMMING_CNT"),true,0,3)%></a></p><span>5일 이내에 납품 대상 건수</span></div>
                <div><h3>물질정보 등록 대상 건수</h3><p><a href="/mdct/showSellerMdCmChemicalMatSendList.do?upperId=s00900000000"><%=CommonUtil.formatNumber(rowData.get("MATERIAL_REQUEST_CNT"),true,0,3)%></a></p><span>30일 이내에 미작성 건수</span></div>
                <div><h3>이미지 등록 요청 건수</h3><p><a href="/mpcl/showSellerMpClCmsReqList.do?upperId=s00900000000"><%=CommonUtil.formatNumber(rowData.get("CATALOG_REQUEST_CNT"),true,0,3)%></a></p><span>30일 이내에 미작성 건수</span></div>
            </div>
        </div>
        <div class="viewList">
            <ul>
                <li><a href="/mpiv/showSellerMpIvObtnodrReceipt.do?upperId=s00300000000">수주접수<p><%=CommonUtil.formatNumber(rowData.get("ORDER_RECEIVE_CNT"),true,0,3)%></p></a></li>
                <li><a href="/mpiv/showSellerMpIvTranStatementWrite.do?upperId=s00300000000">거래명세서 작성대상<p><%=CommonUtil.formatNumber(rowData.get("INVOICE_CRE_CNT"),true,0,3)%></p></a></li>
                <li><a href="/mpiv/showSellerMpIvDeliveryRecordReg.do?upperId=s00300000000">납품실적 등록대상<p><%=CommonUtil.formatNumber(rowData.get("DELIVERY_RSLT_CRE_CNT"),true,0,3)%></p></a></li>
                <li><a href="/mprq/showSellerMpRqQuotReqList.do?upperId=s00200000000">신규등록 견적대상<p><%=CommonUtil.formatNumber(rowData.get("ACCEPT_SOURCING_WRITE_CNT"),true,0,3)%></p></a></li>
                <li><a href="/mpcl/showSellerMpClCatalogRecharterList.do?upperId=s00200000000">재계약 제출대상<p><%=CommonUtil.formatNumber(rowData.get("CATALOG_RECHATER_CNT"),true,0,3)%></p></a></li>
                <li><a href="/wmre/showMasterWmReReturnProgressState.do?upperId=s003000000000">반품처리건<p><%=CommonUtil.formatNumber(rowData.get("RETURN_PROGRESS_STATE_CNT"),true,0,3)%></p></a></li>
                <li><a href="/mpiv/showSellerMpIvDeliveryDateList.do?upperId=s003000000000">납기일변경 미 확인건<p><%=CommonUtil.formatNumber(rowData.get("DELIVERYDELAYDATE_CNT"),true,0,3)%></p></a></li>
            </ul>
            <div><a href="/none/showSellerNoNeBuyerVoice.do">고객의 소리</a></div>
        </div>
        <div class="downList">
            <ul>
                <li><a href="/mdam/showSellerMdAmUserInfo.do"><img src="/resources/images/201905_icon02.png" /><br/> 개인정보</a> </li>
                <li><a href="javascript:doPop('icomcmpyPop','');"><img src="/resources/images/201905_icon03.png" /><br/> 거래명세서 양식</a> </li>
                <li><a href="/resources/excel/work/MAIN/Kep_Supplier_Manual_v2025.zip"><img src="/resources/images/201905_icon04.png" /><br/> 매뉴얼(일반용)</a> </li>
                <li><a href="/resources/excel/work/MAIN/Kep_Supplier_Manual_Sourcing_v2024.zip"><img src="/resources/images/201905_icon04.png" /><br/> 매뉴얼(견적용)</a> </li>
                <li><a href="/resources/excel/work/MAIN/Kep_Supplier_Manual_Mobile_v2018.zip"><img src="/resources/images/201905_icon05.png" /><br/> 매뉴얼(모바일)</a> </li>
            </ul>
        </div>  
        <div class="noticeList">
            <h3>공지사항 <a href="javascript:doPop('seller_notice');"><img src="/resources/images/s_btn_more.gif" alt="더보기" /></a></h3>
                <!--ul>
                    <li style="text-align:center;">현재 목록에 나와 있는 자료가 없습니다</l>
                    <li><div><a href="#">[안내] 코리아이플랫폼 개인정보처리방침 개정 (3/14일 시행)</a></div><p>2019.03.06</p> </li>
                    <li><div><a href="#">효성중공업 협력사 공급자재 납기준수 요청의 건.  2015.09.08</a></div><p>2019.03.06 </p> </li>
                    <li><div><a href="#">효성중공업 외주구매품 불량제로화를 위한 전수검사 실시 요청 건</a></div> <p>2019.03.06 </p> </li>
                </ul-->
				<ul>
<%
	if (_noticeList == null || _noticeList.size() == 0){
%>
                	<li style="text-align:center"> 현재 목록에 나와 있는 자료가 없습니다. </li>
<%
	}else{
		for (int j=0; j<_noticeList.size(); j++) {
			Map<String,String> noticeData = _noticeList.get(j);
%> 
					<li>
                        <a href="javascript:doPop('seller_notice_detail','<%=CommonUtil.nvl(noticeData.get("BTYPE"))%>','<%=CommonUtil.bnvl(noticeData.get("BID"))%>');"><div><%=CommonUtil.nvl(noticeData.get("SUBJECT"))%></div></a>
                        <p><%=CommonUtil.formatStrinigDate(noticeData.get("REG_DATE")).replaceAll("/", ".")%></p>
					</li>
 <%
		}
	}
%>
				</ul>
		</div>       
        <div class="callList">
            <ul>
                <li>신속하고 친절한 상담을 약속드립니다.</li>
                <li>KEP 담당자 찾기 &nbsp;<a href="javascript:doPop('commonMpIvTranBuyerChoicePop');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a><p>(거래이력 고객사)</p></li>
                <li>서울본사<p>T.02-3016-8989</p><p>F.02-569-6724</p></li>
                <li>창원지점<p>T.055-270-6201</p><p>F.055-270-6230</p></li>
            </ul>
        </div>
	</div>
    
 <!-----------------------------------------------------------------------------------------------footer------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>
<!-----------------------------------------------------------------------------------------------footer------------------------------------------------------------------------------------------------------->
    
</div>
</body>
</html>
