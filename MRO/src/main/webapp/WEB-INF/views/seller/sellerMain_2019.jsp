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
String check_date					= currentDate;

boolean p150000001 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P15-0000001"); // 결재방법 변경 팝업 대상 협력사리스트(최성범 과장) 2016년 10월 15일까지
boolean p150000002 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P15-0000002"); // 마감 세금계산서 발행 관련 공지(한애희) 2017년 3월 10일까지
%> 
</head>
<script type="text/javascript">
//<!--
var popupSel = "";
function kep_init(){
<%if(p150000001 == true){%>
	popup_pay_change_20161018(); // 2016년 11월 10일까지
<%}%>
<%if(p150000002 == true){%>
	popup_20170119(); // 2017년 03월 10일까지
<%}%>
	doPop("popup_han_20180122"); //2999년 12월 31일까지
	doPop("popup_han_20180816"); //2020년 12월 31일까지
	doPop("popup_drb_20180828"); //2020년 12월 31일까지
	doPop("popup_sam_20181002"); //2019년 12월 31일까지
	doPop("popup_lot_20181128"); //2019년 6월 30일까지
	doPop("popup_sma_20190127"); //2019년 2월 18일까지
	doPop("popup_sys_20190213"); //2019년 4월 30일까지
	doPop("popup_cel_20190214"); //2019년 3월 10일까지
	doPop("popup_lot_20190216"); //2019년 5월 31일까지
	doPop("popup_lot_20190218"); //2019년 3월 25일까지
	doPop("popup_lot_20190306"); //2019년 3월 29일까지
	doPop("popup_you_20190305"); //2999년 12월 31일까지
	doPop("popup_cel_20190314"); //2019년 4월 10일까지
	doPop("popup_dae_20190321"); //2019년 4월 1일까지
	doPop("popup_coa_20190405"); //2019년 12월 31일까지
	popup_20190408();	//2019년 4월 30일까지 전 협력사 공지
	doPop("popup_coa_20190405"); //2019년 12월 31일까지
	doPop("popup_sam_20190411"); //2999년 12월 31일까지	
	doPop("popup_sys_20190412"); //2019년 5월 10일까지
	doPop("popup_sys_20190413"); //2019년 5월 10일까지
	doPop("popup_cel_20190419"); //2019년 5월 10일까지
}

//팝업함수호출
function doPop(str, value1, value2) {
	popupSel = str;
	
	switch (str) {
		case "icomcmpyPop":	// 거래명세서 양식 팝업
			openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=B&MULTI=N','500,466,no');
			break;
		case "seller_notice":  // 협력사 공지사항
			openSearchPopup('/none/showSellerNoNeNoticeListPop.do','?st_company=<%=_sessionInfo.getComCode()%>','700,455,no');
			break;
		case "seller_notice_detail":  // 협력사 공지사항 상세정보
			openSearchPopup("/none/showSellerNoNeNoticeDetailPop.do", "?st_btype="+value1+"&st_bid="+value2, "800,600,no");
			break;
		case "popup_han_20180122":
			var pData = {st_buyer_list : "KRHANK0126", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_han_20180816":
			var pData = {st_buyer_list : "KRHANK0126", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_drb_20180828":
			var pData = {st_buyer_list : "KRDONG0595,KRDRB-0001", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_sam_20181002":
			var pData = {st_buyer_list : "KRSAMS0123,KRSAMS0149,KRDAED0079,KRS-1-0001,KRSAMS0140", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_lot_20181128":
			var pData = {st_buyer_list : "KRLOTT0007", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_sma_20190127":
			var pData = {st_buyer_list : "KRSAMS0123,KRSAMS0149,KRSAMS0140", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_sys_20190213":
			var pData = {st_buyer_list : "KRSYSR0001", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_cel_20190214":
			var pData = {st_buyer_list : "KRCELL0004", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_lot_20190216":
			var pData = {st_buyer_list : "KRLOTT0007,KRLOTT0008,KRLOTT0009,KRLOTT0011,KRLOTT0010,KRCOAV0001", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_lot_20190218":
			var pData = {st_buyer_list : "KRLOTT0033,KRLOTT0034,KRLOTT0031", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_lot_20190306":
			var pData = {st_buyer_list : "KRLOTT0034", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_you_20190305":
			var pData = {st_buyer_list : "KRYOUN0301", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_cel_20190314":
			var pData = {st_buyer_list : "KRCELL0004", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_dae_20190321":
			var pData = {st_buyer_list : "KRDAEH0196, KRDAEH0198", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_coa_20190405":
			var pData = {st_buyer_list : "KRCOAV0001", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_sam_20190411":
			var pData = {st_buyer_list : "KRSAMS0140,KRSAMS0152", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_sys_20190412":
			var pData = {st_buyer_list : "KRSYSJ0001", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_sys_20190413":
			var pData = {st_buyer_list : "KRSYPA0001", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
		case "popup_cel_20190419":
			var pData = {st_buyer_list : "KRCELL0004", st_com_code : "<%=SessionComCode%>", st_from_date : "20110101"};
			kepAjaxCallNoBar("/common/getCheckedPoAgentList.do",pData,popupSel);
			break;
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	var checkFlag = response.check_flag;
	
	if ( pMethod == "popup_sky_20170518" ) {
		if(checkFlag == "TRUE")	popup_sky_20170518();
	}else if ( pMethod == "popup_han_20180122" ) {
		if(checkFlag == "TRUE")	popup_han_20180122();
	}else if ( pMethod == "popup_han_20180816" ) {
		if(checkFlag == "TRUE")	popup_han_20180816();
	}else if ( pMethod == "popup_drb_20180828" ) {
		if(checkFlag == "TRUE")	popup_drb_20180828();
	}else if ( pMethod == "popup_sam_20181002" ) {
		if(checkFlag == "TRUE")	popup_sam_20181002();
	}else if ( pMethod == "popup_lot_20181128" ) {
		if(checkFlag == "TRUE")	popup_lot_20181128();
	}else if ( pMethod == "popup_sma_20190127" ) {
		if(checkFlag == "TRUE")	popup_sma_20190127();
	}else if ( pMethod == "popup_sys_20190213" ) {
		if(checkFlag == "TRUE")	popup_sys_20190213();
	}else if ( pMethod == "popup_cel_20190214" ) {
		if(checkFlag == "TRUE")	popup_cel_20190214();
	}else if ( pMethod == "popup_lot_20190216" ) {
		if(checkFlag == "TRUE")	popup_lot_20190216();
	}else if ( pMethod == "popup_lot_20190218" ) {
		if(checkFlag == "TRUE")	popup_lot_20190218();
	}else if ( pMethod == "popup_lot_20190306" ) {
		if(checkFlag == "TRUE")	popup_lot_20190306();
	}else if ( pMethod == "popup_you_20190305" ) {
		if(checkFlag == "TRUE")	popup_you_20190305();
	}else if ( pMethod == "popup_cel_20190314" ) {
		if(checkFlag == "TRUE")	popup_cel_20190314();
	}else if ( pMethod == "popup_dae_20190321" ) {
		if(checkFlag == "TRUE")	popup_dae_20190321();
	}else if ( pMethod == "popup_coa_20190405" ) {
		if(checkFlag == "TRUE")	popup_coa_20190405();
	}else if ( pMethod == "popup_sam_20190411" ) {
		if(checkFlag == "TRUE")	popup_sam_20190411();
	}else if ( pMethod == "popup_sys_20190412" ) {
		if(checkFlag == "TRUE")	popup_sys_20190412();
	}else if ( pMethod == "popup_sys_20190413" ) {
		if(checkFlag == "TRUE")	popup_sys_20190413();
	}else if ( pMethod == "popup_cel_20190419" ) {
		if(checkFlag == "TRUE")	popup_cel_20190419();
	}		
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("조회에 실패하였습니다.\n\n관리자에 문의 하여 주십시오."); 
}

//[SR18000528] 한국제지 납품공지
function popup_han_20180122() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("29991231")) {
if (getCookie("ncook20180122") != "done20180122") {
noticeWindow = window.open("/resources/html/main/notice/popup_20180122.htm","popup_20180122","width=616, height=327, scrollbars = no");
noticeWindow.opener = self;
}
}
}
//[SR18005482] 김은지 한국제지 발주관련 주의 공지
function popup_han_20180816() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("20201231")) {
if (getCookie("ncook20180814") != "done20180814") {
noticeWindow = window.open("/resources/html/main/notice/popup_20180814.htm","popup_20180814","width=570, height=309, scrollbars = no");
noticeWindow.opener = self;
}
}
}//[SR18005719] 최효영 안전운행 공지
function popup_drb_20180828() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("20201231")) {
if (getCookie("ncook20180828") != "done20180828") {
noticeWindow = window.open("/resources/html/main/notice/popup_20180828.htm","popup_20180828","width=743, height=817, scrollbars = no");
noticeWindow.opener = self;
}
}
}
//[SR18006475] 심재운 특정고객사 공지	(SR18007528 김민수 팝업 수정 요청)
function popup_sam_20181002() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("20191231")) {
if (getCookie("ncook20181117") != "done20181117") {
noticeWindow = window.open("/resources/html/main/notice/popup_20181117.htm","popup_20181117","width=825, height=555, scrollbars = no");
noticeWindow.opener = self;
}
}
}
//[SR18007806] 백미현 롯데푸드 공지
function popup_lot_20181128() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("20190630")) {
if (getCookie("ncook20181128") != "done20181128") {
noticeWindow = window.open("/resources/html/main/notice/popup_20181128.htm","popup_20181128","width=450, height=370, scrollbars = no");
noticeWindow.opener = self;
}
}
}
//삼성전자 공지 김초롱
function popup_sma_20190127() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20190218")) {
	if (getCookie("ncook20190127") != "done20190127") {
	noticeWindow = window.open("/resources/html/main/notice/popup_20190127.htm","popup_20190127","width=430, height=655, scrollbars = no");
	noticeWindow.opener = self;
	}
	}
	}
//[SR19001035] 김연희 에스와이에스리테일 공지
function popup_sys_20190213() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("20190430")) {
if (getCookie("ncook20190213") != "done20190213") {
noticeWindow = window.open("/resources/html/main/notice/popup_20190213.htm","popup_20190213","width=460, height=370, scrollbars = no");
noticeWindow.opener = self;
}
}
}
//[SR19001096] 임한나 셀트리온 공지
function popup_cel_20190214() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("20190310")) {
if (getCookie("ncook20190214") != "done20190214") {
noticeWindow = window.open("/resources/html/main/notice/popup_20190214.htm","popup_20190214","width=435, height=320, scrollbars = no");
noticeWindow.opener = self;
}
}
}
//[SR19001105] 백미현 롯데푸드 공지
function popup_lot_20190216() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("20190531")) {
if (getCookie("ncook20190216") != "done20190216") {
noticeWindow = window.open("/resources/html/main/notice/popup_20190216.htm","popup_20190216","width=550, height=390, scrollbars = no");
noticeWindow.opener = self;
}
}
}
//[SR19001159] 조민서 롯데알미늄 공지
function popup_lot_20190218() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("20190325")) {
if (getCookie("ncook20190218") != "done20190218") {
noticeWindow = window.open("/resources/html/main/notice/popup_20190218.htm","popup_20190218","width=455, height=520, scrollbars = no");
noticeWindow.opener = self;
}
}
}
//[SR19001728] 조민서 롯데알미늄 공지
function popup_lot_20190306() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("20190430")) {
if (getCookie("ncook20190319") != "done20190319") {
noticeWindow = window.open("/resources/html/main/notice/popup_20190319.htm","popup_20190319","width=690, height=340, scrollbars = no");
noticeWindow.opener = self;
}
}
}
//[SR19001392] 한애희 (주)영풍 석포제련소 공지
function popup_you_20190305() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("20991231")) {
if (getCookie("ncook20190305") != "done20190305") {
noticeWindow = window.open("/resources/html/main/notice/popup_20190305.htm","popup_20190305","width=550, height=375, scrollbars = no");
noticeWindow.opener = self;
}
}
}
//[SR19001096] 임한나 셀트리온 공지
function popup_cel_20190314() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("20190410")) {
if (getCookie("ncook20190314") != "done20190314") {
noticeWindow = window.open("/resources/html/main/notice/popup_20190314.htm","popup_20190314","width=445, height=350, scrollbars = no");
noticeWindow.opener = self;
}
}
}
//[SR19001777] 임한나 대한제분 공지
function popup_dae_20190321() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("20190401")) {
if (getCookie("ncook20190321") != "done20190321") {
noticeWindow = window.open("/resources/html/main/notice/popup_20190321.htm","popup_20190321","width=480, height=310, scrollbars = no");
noticeWindow.opener = self;
}
}
}
//[SR19002192] 백미현 코아비스
function popup_coa_20190405() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("20191231")) {
if (getCookie("ncook20190405") != "done20190405") {
noticeWindow = window.open("/resources/html/main/notice/popup_20190405.htm","popup_20190405","width=540, height=330, scrollbars = no");
noticeWindow.opener = self;
}
}
}
//[SR19002289] 박홍민 전체 협력사 공지
function popup_20190408() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("20190430")) {
if (getCookie("ncook20190408") != "done20190408") {
noticeWindow = window.open("/resources/html/main/notice/popup_20190408.htm","popup_20190408","width=780, height=490, scrollbars = no");
noticeWindow.opener = self;
}
}
}
//[SR19002362] 민홍준 삼성전기
function popup_sam_20190411() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("29991231")) {
if (getCookie("ncook20190411") != "done20190411") {
noticeWindow = window.open("/resources/html/main/notice/popup_20190411.htm","popup_20190411","width=445, height=275, scrollbars = no");
noticeWindow.opener = self;
}
}
}
//[SR19002377] 김명선
function popup_sys_20190412() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("20190510")) {
if (getCookie("ncook20190412") != "done20190412") {
noticeWindow = window.open("/resources/html/main/notice/popup_20190412.htm","popup_20190412","width=510, height=210, scrollbars = no");
noticeWindow.opener = self;
}
}
}
//[SR19002375] 김명선
function popup_sys_20190413() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("20190510")) {
if (getCookie("ncook20190413") != "done20190413") {
noticeWindow = window.open("/resources/html/main/notice/popup_20190413.htm","popup_20190413","width=460, height=210, scrollbars = no");
noticeWindow.opener = self;
}
}
}
//[SR19002514] 임한나 셀트리온 공지
function popup_cel_20190419() {
var check_date = "<%=check_date%>";
if(parseInt(check_date)<=parseInt("20190510")) {
if (getCookie("ncook20190419") != "done20190419") {
noticeWindow = window.open("/resources/html/main/notice/popup_20190419.htm","popup_20190419","width=480, height=310, scrollbars = no");
noticeWindow.opener = self;
}
}
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
 //-->
</script>
<body onload="kep_init();">
<div id="wrapper">
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->

    
       <div id="container">
       <div id="leftCont">
<!--        		<div id="leftWork2">
		    	<div class="specialGift">
		            <ul class="specialGift1">
		            	<li><a href="/promote_index.html"  target="_blank"><img src="/resources/images/banner_h1.jpg" alt="홍보베너" /></a></li>
						<li><a href="/promote_index.html"  target="_blank"><img src="/resources/images/banner_k1.jpg" alt="홍보베너" /></a></li>
		            </ul>
		       <script> $(".specialGift").slide({ titCell:".num ul" , mainCell:".specialGift1" , effect:"fold", autoPlay:true, delayTime:1000 , autoPage:true }); </script>
       			</div>
       		</div> -->
       </div>
    	<div id="leftCont2">
        	<!--주요업무처리-->
        	<div style="height:200px;">
        		<!--h2 class="height20"><img src="/resources/images/s_tit_work.gif" alt="주요업무처리" /></h2-->
                <div id="leftWork">
                	<div id="work01">
                    	<p class="leftWorkTit">납기지연건수</p>
                        <p class="circle"><a href="/mpiv/showSellerMpIvDeliveryDelayState.do?upperId=s00300000000"><%=CommonUtil.formatNumber(rowData.get("DELIVERY_DELAY_CNT"),true,0,3)%></a> 건</p>
                        <p ><img src="/resources/images/s_txt_work03.gif" alt="납품 예정일이 지났으나 납품 실적이 등록되지 않은 건수" /></p>
                        <p class="leftWorkBtn"><a href="/mpiv/showSellerMpIvDeliveryDelayState.do?upperId=s00300000000"><img src="/resources/images/s_btn_go.gif" alt="바로가기" /></a></p>
                    </div>
                    <div id="work02">
                    	<p class="leftWorkTit">납기도래건수</p>
                        <p class="circle"><a href="/mdam/showSellerMdAmDeadlineAdventCnt.do"><%=CommonUtil.formatNumber(rowData.get("DELIVERY_COMMING_CNT"),true,0,3)%></a> 건</p>
                        <p ><img src="/resources/images/s_txt_work04.gif" alt="5일 이내에 납품대상인 건수" /></p>
                        <p class="leftWorkBtn"><a href="/mdam/showSellerMdAmDeadlineAdventCnt.do"><img src="/resources/images/s_btn_go.gif" alt="바로가기" /></a></p>
                    </div>
                </div>
                <div id="rightWork">
                	<div id="date">
                    	<p><img src="/resources/images/s_txt_work05.gif" alt="납기준수율(최근1개월)" /></p>
                        <p class="marginB05">[<span class="black"><%=currentYear %>년 <%=currentMonth %>월 <%=currentDay %>일</span>] 기준</p>
                    </div>
                    <div id="status">
                    	<ul>
                         <li class="status01"><span><%=CommonUtil.formatNumber(rowData.get("TOTAL_DELIVERY_CNT"),true,0,3)%> 건</span></br>총 납품건수</li>
                         <li class="status02"><span><%=CommonUtil.formatNumber(rowData.get("DEADLINE_DELIVERY_CNT"),true,0,3)%> 건</span></br>납기 준수건수</li>
                         <li class="status03"><span><%=Math.round( (Double.parseDouble(String.valueOf(rowData.get("DEADLINE_DELIVERY_CNT"))) / Double.parseDouble(String.valueOf(rowData.get("TOTAL_DELIVERY_CNT")))) *100 )%>%</span></br>납기 준수율</li>
<!--                          <li class="status03"><span>0%</span></br>납기 준수율</li> -->
                        </ul>
                    </div>
                </div>
            </div>
            <div id="BottomCont">
            	<!--전화상담서비스-->
            	<div id="callArea">
                	<!--h2 class="height20 lineB01"><img src="/resources/images/s_tit_call.gif" alt="전화상담서비스" /></h2-->
                    <div id="callBg">
                    	<span class="call01">02-3016-8989</span>
                        <span class="call02">02-569-6724</span>
                        <span class="call03">02-3016-8989</span>
                        <span class="call04">02-569-6724</span>
                        <span class="call05">02-3016-8989</span>
                        <span class="call06">02-569-6724</span>
                    </div>
                </div>
                <!--공지사항-->
                <div id="noticeArea">
                	<h2 class="height20" ><img src="/resources/images/s_tit_notice.gif" alt="공지사항" /></h2>
                    <p class="more"><a href="javascript:doPop('seller_notice');"><img src="/resources/images/s_btn_more.gif" alt="더보기" /></a></p>
                    <ul>
<%
	if (_noticeList == null || _noticeList.size() == 0){
%>
                    	<li style="text-align: center; height: 108px;"><span class="title">현재 목록에 나와 있는 자료가 없습니다.</span></li>
<%
	}else{
		for (int j=0; j<_noticeList.size(); j++) {
			Map<String,String> noticeData = _noticeList.get(j);
%> 
						<li>
							<a href="javascript:doPop('seller_notice_detail','<%=CommonUtil.nvl(noticeData.get("BTYPE"))%>','<%=CommonUtil.bnvl(noticeData.get("BID"))%>');">
								<span class="title"><%=CommonUtil.nvl(noticeData.get("SUBJECT"))%></span>
							</a>
							<span class="date"><%=CommonUtil.formatStrinigDate(noticeData.get("REG_DATE")).replaceAll("/", ".")%></span>
						</li>
 <%
		}
	}
%>
                    </ul>
                </div>
            </div>
        </div>
        <div id="rightCont">
        	<!--work info-->
        	<div style="height:220px;">
                <!--h2 class="height20"><img src="/resources/images/s_tit_workinfo.gif" alt="메뉴바로가기" /></h2-->
                <div id="mInfoA">
                    <ul class="mInfo">
                        <li><img src="/resources/images/s_icn_info01.gif" alt="수주접수" class="mr10 mt05" /><a href="/mpiv/showSellerMpIvObtnodrReceipt.do?upperId=s00300000000"><span class="infoStyle"><%=CommonUtil.formatNumber(rowData.get("ORDER_RECEIVE_CNT"),true,0,3)%></span></a></li>
                        <li><img src="/resources/images/s_icn_info02.gif" alt="거래명세서 작성대상" class="mr10 mt05" /><a href="/mpiv/showSellerMpIvTranStatementWrite.do?upperId=s00300000000"><span class="infoStyle"><%=CommonUtil.formatNumber(rowData.get("INVOICE_CRE_CNT"),true,0,3)%></span></a></li>
                        <li><img src="/resources/images/s_icn_info03.gif" alt="납품실적등록대상" class="mr10 mt05" /><a href="/mpiv/showSellerMpIvDeliveryRecordReg.do?upperId=s00300000000"><span class="infoStyle"><%=CommonUtil.formatNumber(rowData.get("DELIVERY_RSLT_CRE_CNT"),true,0,3)%></span></a></li>
                        <li><img src="/resources/images/s_icn_info04.gif" alt="신규등록견적대상" class="mr10 mt05" /><a href="/mprq/showSellerMpRqEstiReqList.do?upperId=s002000000000"><span class="infoStyle"><%=CommonUtil.formatNumber(rowData.get("ACCEPT_SOURCING_WRITE_CNT"),true,0,3)%></span></a></li>
                        <li><img src="/resources/images/s_icn_info05.gif" alt="반품처리건" class="mr10 mt05" /><a href="/wmre/showMasterWmReReturnProgressState.do?upperId=s003000000000"><span class="infoStyle"><%=CommonUtil.formatNumber(rowData.get("RETURN_PROGRESS_STATE_CNT"),true,0,3)%></span></a></li>
                        <li class="last"><img src="/resources/images/s_icn_info06.gif" alt="반품처리건" class="mr10 mt05" /><a href="/mpiv/showSellerMpIvDeliveryDateList.do?upperId=s003000000000"><span class="infoStyle"><%=CommonUtil.formatNumber(rowData.get("DELIVERYDELAYDATE_CNT"),true,0,3)%></span></a></li>
                    </ul>
                </div>
            </div>
        </div>
        <!--바로가기 배너-->
        <div id="mainBannerA">
        	<span class="BannerLine"><a href="/mdam/showSellerMdAmUserInfo.do"><img src="/resources/images/s_img_bn01.gif" alt="개인정보" /></a></span>
            <span class="BannerLine"><a href="javascript:doPop('icomcmpyPop','');"><img src="/resources/images/s_img_bn03.gif" alt="거래명세서양식" /></a></span>
            <span class="BannerLine"><a href="/resources/excel/work/MAIN/Kep_Supplier_Manual_v2019.zip"><img src="/resources/images/s_img_bn06.gif" alt="메뉴얼다운로드(일반용)" /></a></span>
            <span class="BannerLine"><a href="/resources/excel/work/MAIN/Kep_Supplier_Manual_Sourcing_v2019.zip"><img src="/resources/images/s_img_bn04.gif" alt="메뉴얼다운로드(소싱용)" /></a></span>
            <span class="BannerLine"><a href="/resources/excel/work/MAIN/Kep_Supplier_Manual_Mobile_v2018.zip"><img src="/resources/images/s_icn_info09.gif" alt="메뉴얼다운로드(모바일)" /></a></span>
            <span class="BannerLast"><a href="/none/showSellerNoNeBuyerVoice.do"><img src="/resources/images/s_img_bn08.gif" alt="고객의 소리" /></a></span>
        </div>
    </div>
    
 <!-----------------------------------------------------------------------------------------------footer------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>
<!-----------------------------------------------------------------------------------------------footer------------------------------------------------------------------------------------------------------->
    
</div>
</body>
</html>
