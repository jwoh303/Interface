<%@page import="com.diquest.ir.util.common.DateUtil"%>
<%@page import="com.ctc.wstx.util.DataUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" buffer="1024kb" autoFlush="true"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../common/include/head_v2.jspf"  %>
<script src="/resources/js/common/HttpUtil.js" type="text/javascript"></script>
<script src="/resources/js/common/PopupUtil.js" type="text/javascript"></script>
</head>
<%  
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _buyerBoard = (List<Map<String,String>>) request.getAttribute("buyerBoard"); // 조회된 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _ntBoard = (List<Map<String,String>>) request.getAttribute("ntBoard"); // 조회된 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _internalNtBoard = (List<Map<String,String>>) request.getAttribute("internalNtBoard"); // 내부 공지사항 조회 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _vocUser = (List<Map<String,String>>) request.getAttribute("vocUser"); // 조회된 결과 PM
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _bmUser = (List<Map<String,String>>) request.getAttribute("bmUser"); // 조회된 결과 BM
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _statusCount = (List<Map<String,String>>) request.getAttribute("statusCount"); // 조회된 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _companyPass = (List<Map<String,String>>) request.getAttribute("companyPass"); // 조회된 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _manualInfo = (List<Map<String,String>>) request.getAttribute("manualInfo"); // 조회된 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _shotcutSsso = (List<Map<String,String>>) request.getAttribute("shotcutSsso"); // 조회된 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _historyGoodsList = (List<Map<String,String>>) request.getAttribute("historyGoodsList"); // 조회된 결과 구매이력상품
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _myGoodsList = (List<Map<String,String>>) request.getAttribute("myGoodsList"); // 조회된 결과 구매이력상품
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _bdgtAmtList = (List<Map<String,String>>) request.getAttribute("bdgtAmt"); // 조회된 결과 예산조회

	String currentDate = DateTimeUtil.getFormatString("yyyyMMdd");
	String currentYear = currentDate.substring(0,4);
	String currentMonth = currentDate.substring(4,6);
	String currentDay = currentDate.substring(6,8);
	String check_date					= currentDate;

	// 미확인 공지(공지사항 + 내부공지) 건수 - 메인 진입 시 화면 전체 덮는 강제 팝업용
	Map _unreadNotice = (Map) request.getAttribute("unread_notice_count");
	long unreadNoticeCount = 0L;       // 전체 미확인
	long unreadNoticeOnly = 0L;        // 공지사항(tab2) 미확인
	long unreadInternalOnly = 0L;      // 내부 공지사항(tab3) 미확인
	if (_unreadNotice != null) {
		if (_unreadNotice.get("TOTAL_UNREAD") != null)    unreadNoticeCount  = ((Number) _unreadNotice.get("TOTAL_UNREAD")).longValue();
		if (_unreadNotice.get("NOTICE_UNREAD") != null)   unreadNoticeOnly   = ((Number) _unreadNotice.get("NOTICE_UNREAD")).longValue();
		if (_unreadNotice.get("INTERNAL_UNREAD") != null) unreadInternalOnly = ((Number) _unreadNotice.get("INTERNAL_UNREAD")).longValue();
	}
	// 바로가기 탭: 공지사항 미확인이 있으면 공지사항 탭(2), 내부공지만 있으면 내부공지 탭(3)
	int gotoNoticeTab = (unreadNoticeOnly > 0) ? 2 : 3;
	
	Map<String,String> _vocUserData1 = null;//BM정보
	Map<String,String> _vocUserData2 = null;//PM정보
	if (_bmUser == null || _bmUser.size() == 0){
	}else{
		for (int i=0; i<_bmUser.size(); i++){
			_vocUserData1 = _bmUser.get(0);  
		}
	}
	if (_vocUser == null || _vocUser.size() == 0){
	}else{
		for (int i=0; i<_vocUser.size(); i++){
			_vocUserData2 = _vocUser.get(0);  
		}
	}
	Map<String,String> _statusCountData = null;
	if (_statusCount == null || _statusCount.size() == 0){
	}else{
		_statusCountData = _statusCount.get(0);
	}
	
	Map<String,String> _companyPassData = null;
	String PASS_FLAG = "";
	if (_companyPass == null || _companyPass.size() == 0){
	}else{
		_companyPassData = _companyPass.get(0);
		PASS_FLAG = _companyPassData.get("PASS_FLAG"); 
	}
	
	Map<String,String> _manualInfoData = null;
	String MANUAL_FLAG = "";
	if (_manualInfo == null || _manualInfo.size() == 0){
	}else{
		_manualInfoData = _manualInfo.get(0);
		MANUAL_FLAG = _manualInfoData.get("MANUAL_FLAG"); 
	}
	
	String SSO_COM_CODE = "";
	String SSO_USER_ID = "";
	String SSO_PASSWORD = "";
	Map<String,String> _shotcutSssoData = null;
	if (_shotcutSsso == null || _shotcutSsso.size() == 0){
	}else{
		/*
		_shotcutSssoData = _shotcutSsso.get(0); 
		SSO_COM_CODE = _shotcutSssoData.get("COM_CODE"); 
		SSO_USER_ID = _shotcutSssoData.get("USER_ID"); 
		SSO_PASSWORD = _shotcutSssoData.get("PASSWORD"); 
		
		request.getSession().setAttribute("session_SSO_COM_CODE", SSO_COM_CODE); 
		request.getSession().setAttribute("session_SSO_USER_ID", SSO_USER_ID); 
		request.getSession().setAttribute("session_SSO_PASSWORD", SSO_PASSWORD); 
		*/
	}
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String sessionUserName = "";
	String sessionComCode = "";
	String sessionBycaComorgCode = "";
	String sessionUserId = "";
	String sessionRole = "";
	String budget_flag       = "";     // 고객사 예산 사용여부
	String sessionUserAuth = "";
	String sessionUserGroup = "";
	if (sessionInfo != null){ 
		sessionUserName =  CommonUtil.nvl((String)sessionInfo.getComNameLoc());  
		sessionUserId =  CommonUtil.nvl((String)sessionInfo.getUserId());  
		sessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode());  
		sessionBycaComorgCode =  CommonUtil.nvl((String)sessionInfo.getBycaComorgCode());
		sessionRole =  CommonUtil.nvl((String)sessionInfo.getRole());
		budget_flag =  CommonUtil.nvl((String)sessionInfo.getBudgetFlag());
		sessionUserAuth = CommonUtil.nvl((String)sessionInfo.getUserAuth());
		sessionUserGroup = CommonUtil.nvl((String)sessionInfo.getUserGroup());
	}  
	String ADMIN_FLAG = "N";
	String ADMIN_STRING = "ROLE_BSAMYANG_ALL_GE,ROLE_BADM001,ROLE_HONG_AD,ROLE_BGEN002,ROLE_BBDM001";
	if(ADMIN_STRING.contains(sessionUserAuth)){
		ADMIN_FLAG = "Y";
	}
	
	// 발주대상 접근권한 제어
	String PO_FLAG = "Y";
	
	if(sessionRole.indexOf("U")>-1 || sessionRole.indexOf("G")>-1){
		PO_FLAG = "N";
	}
	
	//단가합의 권한
	String QA_FLAG = "N";
	if(sessionUserGroup.indexOf("N")>-1 || sessionUserGroup.indexOf("C")>-1 || sessionUserGroup.indexOf("A")>-1){
		QA_FLAG = "Y";
	}
	
	String GR_FLAG = "N";
	if(sessionRole.indexOf("G")>-1 || sessionRole.indexOf("A")>-1){
		GR_FLAG = "Y";
	}
	
	 //SLOGIC-BEGIN(P06-0000036)
	String defaultUrl = "/mpso/getBuyerMpSoCartList.do";
	String p060000036 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P06-0000036","COL01_DATA", request); // 권한별URL
	if (p060000036 == null){
		p060000036 = defaultUrl;
	}else if ("".equals(p060000036)){
		p060000036 = defaultUrl;
	}
	//SLOGIC-END
	
	boolean cowayFlag = false;
	//SLOGIC-BEGIN(P06-0000036) 
    //고객사 대시보드 타입 가져오기
    String p060000106_type = CommonUtil.getSpecialCheckReturn(sessionComCode,"P06-0000106","COL01_DATA"); // 권한특수로직
    //SLOGIC-END 
    
    // SLOGIC-BEGIN(P06-0000093) - 단종 단가표기 안되며, 장바구니 나의 상품등록이 불가능.
	boolean p060000093 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P06-0000093");
	String g_product_close_flag = "N";
	if ( p060000093 == true ) {
		g_product_close_flag = "Y";
	}
	
	//SLOGIC-BEGIN(P06-0000072) - 장바구니 중복 등록 허용 고객사
	boolean p060000072 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P06-0000072");
	
	String dup_add_posb_yn = "N";
	
	if(p060000072 == true){
		dup_add_posb_yn = "Y";
    }
%>  


<body onload="kep_onload_view();">

<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var popupSel = "";
 
/**
 * 미확인 공지사항(공지사항 + 내부공지) 강제 팝업 호출
 */
function showUnreadNoticePopup() {
	var unreadCount = <%= unreadNoticeCount %>;
	if (unreadCount <= 0) return;
	PopupUtil.showUnreadNotice(function(popup) {
		popup.setCount(unreadCount)
			 .onGoToNotice(function() {
				 // 공지사항 미확인이 있으면 공지사항 탭(2), 내부공지만 있으면 내부공지 탭(3)
				 location.href = '/mcsc/showBuyerMcScCustomerCenter.do?tabIndex=<%= gotoNoticeTab %>&menuId=br00602000000';
			 });
	});
}

//최초 화면 함수
function kep_onload_view(){
	$('#top_cart_cnt').html($('#main_cart_cnt').val());

	// 미확인 공지가 있으면 화면 전체 덮는 강제 팝업 우선 노출
	var unreadCount = <%= unreadNoticeCount %>;
	if (unreadCount > 0) {
		setTimeout(function() { showUnreadNoticePopup(); }, 500);
	}
}

//코웨이 마감안내 팝업 (매월 24 ~ 매월 27)
function popup_coway() {
	var buyer="<%=sessionComCode%>";
	var currentDay = "<%=currentDay%>";
    if(buyer=="KRCOWA0001" || buyer=="KRCOWA0005" || buyer=="KRCOWA0006"){
  	  if(parseInt(currentDay)>=parseInt("22") && parseInt(currentDay)<=parseInt("26")) {
          if (getCookie("ncookCoway") != "doneCoway") {
              noticeWindow = window.open("/resources/html/main/notice/popup_coway.htm","popup_coway","left=0, top=0, width=420, height=278, scrollbars = no");
              noticeWindow.opener = self;
      	  }
    	}
	}
}

//SR17007291  20171109 - 29991231
function popup_20171109() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKOLO0006"){
	  if(parseInt(check_date)<=parseInt("29991231")) {
		if (getCookie("ncook20171109") != "done20171109") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20171109.htm","popup_20171109","width=515, height=228, scrollbars = no");
			noticeWindow.opener = self;
			 }
		}
	}
}
//SR18003714	2018.05.29(화)~영구	
function popup_20180529() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KR3G-T0001"||buyer=="KROJC-0002"||buyer=="KRGEUM0021"||buyer=="KRDAEJ0091"||buyer=="KRA-PA0002"||buyer=="KRDUCK0031"){
		if(parseInt(check_date)<=parseInt("29991231")) {
			if (getCookie("ncook20180529") != "done20180529") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20180529.htm","popup_20180529","width=504, height=224, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR19000536	2019.01.21 ~ 영구
function popup_20190121() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRSIEM0010"){
		if(parseInt(check_date)<=parseInt("29991231")) {
			if (getCookie("ncook20190121") != "done20190121") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20190121.htm","popup_20190121","width=425, height=380, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR19004367	2019.07.18 ~ 2999.12.31
function popup_20190717() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRNONA0001"){
		if(parseInt(check_date)<=parseInt("29991231")) {
			if (getCookie("ncook20190717") != "done20190717") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20190717.htm","popup_20190717","width=475, height=415, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR19005514 ,SR21005130 	2019.09.10 ~ 2999.12.31
function popup_20190911() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRVOLV0001"||buyer=="KRKOLO0119"||buyer=="KRKOLO0006"||buyer=="KRYUYU0004"||buyer=="KRLOTT0029"||buyer=="KRFNCK0002"||
			buyer=="KRKOLO0068"||buyer=="KRKOLO0080"||buyer=="KRKG-Z0001"||buyer=="KREDAI0001"||buyer=="KRKGIN0001"||buyer=="KRKGMO0001"||buyer=="KRKG-E0004"
				||buyer=="KRKG-I0001"||buyer=="KRKG-H0001"||buyer=="KRKFC-0002"||buyer=="KRKG-S0001"){
		if(parseInt(check_date)<=parseInt("29991231")) {
			if (getCookie("ncook20190911") != "done20190911") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20190911.htm","popup_20190911","width=450, height=400, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR19008041	2019.01.02 ~ 영구
function popup_20191231() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRCOWA0001"){
		if(parseInt(check_date)<=parseInt("29991231")) {
			if (getCookie("ncook20191231") != "done20191231") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20191231.htm","popup_20191231","width=550, height=395, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}

//SR20000527 동원그룹 사원증 관련 팝업 등록 - SR23004928 popup_20200119에서 popup_20230523으로 수정
function popup_20230523() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRDONG0832"||buyer=="KRDONG0820"||buyer=="KRDONG0837"||buyer=="KRDONG0833"||buyer=="KRDONG0831"||buyer=="KRDONG0836"||buyer=="KRDONG0834"||
			buyer=="KRDONG0835"||buyer=="KRDONG0838"||buyer=="KRDONG0903"){
	  if(parseInt(check_date)<=parseInt("29991229")) {
		if (getCookie("ncook20230523") != "done20230523") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20230523.htm","popup_20230523","width=500, height=330, scrollbars = no");
			noticeWindow.opener = self;
			 }
		}
	}
}

//SR20000694	영구
function popup_20200124() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRDONG0837"||buyer=="KRDONG0831"||buyer=="KRDONG0836"||buyer=="KRDONG0838"){
		if(parseInt(check_date)<=parseInt("29991231")) {
			if (getCookie("ncook20200124") != "done20200124") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20200124.htm","popup_20200124","width=505, height=285, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR20005182 메가스터디 입고 처리 관련 팝업 우민아 요청
function popup_20200629() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRMEGA0005"){
		if(parseInt(check_date)<=parseInt("29991231")) {
			if (getCookie("ncook20200629") != "done20200629") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20200629.htm","popup_20200629","width=480, height=365, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR20006879 발주 관련 팝업 우민아 요청
function popup_20200831() {
	var buyer="<%=sessionComCode%>";
	if(buyer=="KRNONA0001"){
		if (getCookie("ncook20200831") != "done20200831") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20200831.htm","popup_20200831","width=430, height=340, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR20006924 에스원 보안공사자재 팝업창 요청의 건 곽원기
function popup_20200902() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20200929")) {
		if (getCookie("ncook20200902") != "done20200902") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20200902.htm","popup_20200902","width=480, height=360, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR20006925 에스원 보안공사자재 팝업창 요청의 건 심재운
function popup_20200925() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20201006")) {
		if (getCookie("ncook20200925") != "done20200925") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20200925.htm","popup_20200925","width=560, height=495, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR20009162 동원홈푸드_단체급식소  결재자변경방법 팝업 우민아 요청
function popup_20201125() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRDONG1104"){
		if(parseInt(check_date)<=parseInt("20211231")) {
			if (getCookie("ncook20201125") != "done20201125") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20201125.htm","popup_20201125","width=460, height=260, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR20009968 에스원 보안공사자재 팝업창 요청의 건 곽원기
function popup_20201230() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20210106")) {
		if (getCookie("ncook20201230") != "done20201230") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20201230.htm","popup_20201230","width=560, height=330, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR21000869 택배,kep휴무 관련 팝업 우민아 요청
function popup_20210129() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20210219")) {
		if (getCookie("ncook20210129") != "done20210129") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20210129.htm","popup_20210129","width=395, height=480, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR21000979 에스원공사 공지 곽원기
function popup_20210201() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20210218")) {
		if (getCookie("ncook20210201") != "done20210201") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20210201.htm","popup_20210201","width=520, height=440, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR21001743 코웨이 인쇄물 주문안내 관련 팝업 홍성은 요청
function popup_20210225() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRCOWA0002"||buyer=="KRCOWA0008"||buyer=="KRCOWA0007"){
	  if(parseInt(check_date)<=parseInt("20211231")) {
		if (getCookie("ncook20210225") != "done20210225") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20210225.htm","popup_20210225","width=640, height=450, scrollbars = no");
			noticeWindow.opener = self;
			 }
		}
	}
}
//SR21001806 에스원공사 공지 곽원기
function popup_20210226() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20210305")) {
		if (getCookie("ncook20210226") != "done20210226") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20210226.htm","popup_20210226","width=480, height=400, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR21002758 엠캐피탈 개인정보확인,결재지정방법 공지 우민아 요청
function popup_20210330() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRM-CA0001"){
		if(parseInt(check_date)<=parseInt("20211230")) {
			if (getCookie("ncook20210330") != "done20210330") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20210330.htm","popup_20210330","width=470, height=390, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR21002508 에스원공사 공지 곽원기
function popup_20210322() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20210405")) {
		if (getCookie("ncook20210322") != "done20210322") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20210322.htm","popup_20210322","width=540, height=470, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR21003742 넥센타이어 사무용품 SAP 예산 안내 이송희 요청
function popup_20210430() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRNEXE0010"){
		if(parseInt(check_date)<=parseInt("29991231")) {
			if (getCookie("ncook20210430") != "done20210430") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20210430.htm","popup_20210430","width=650, height=410, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR21004090 동원에프앤비 결재선,회원가입 관련 팝업 우민아 요청
function popup_20210512() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRDONG0832"){
		if(parseInt(check_date)<=parseInt("20221230")) {
			if (getCookie("ncook20210512") != "done20210512") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20210512.htm","popup_20210512","width=470, height=540, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR21004324 동원 결재자,회원가입관련 팝업 우민아 요청
function popup_20210524() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRDONG0835"){
		if(parseInt(check_date)<=parseInt("20221230")) {
			if (getCookie("ncook20210524") != "done20210524") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20210524_KRDONG0835.htm","popup_20210524","width=510, height=560, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}else if(buyer=="KRDONG0833"){
		if(parseInt(check_date)<=parseInt("20221230")) {
			if (getCookie("ncook20210524") != "done20210524") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20210524_KRDONG0833.htm","popup_20210524","width=510, height=560, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}else if(buyer=="KRDONG0903"){
		if(parseInt(check_date)<=parseInt("20221230")) {
			if (getCookie("ncook20210524") != "done20210524") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20210524_KRDONG0903.htm","popup_20210524","width=510, height=560, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}else if(buyer=="KRDONG0841"){
		if(parseInt(check_date)<=parseInt("20221230")) {
			if (getCookie("ncook20210524") != "done20210524") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20210524_KRDONG0841.htm","popup_20210524","width=510, height=560, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR21005182 에스원공사 공지 곽원기
function popup_20210621() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20210623")) {
		if (getCookie("ncook20210621") != "done20210621") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20210621.htm","popup_20210621","width=620, height=330, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR21005480 코웨이 공지 팝업 생성 요청의 건 이기민
function popup_20210632() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRCOWA0001"||buyer=="KRCOWA0005"||buyer=="KRCOWA0006"){
		if(parseInt(check_date)<=parseInt("20211231")) {
			if (getCookie("ncook20210632") != "done20210632") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20210632.htm","popup_20210632","width=480, height=340, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR21005921 코웨이 공지 팝업 생성 요청의 건 이기민
function popup_20210712() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRCOWA0001"||buyer=="KRCOWA0005"||buyer=="KRCOWA0006"){
		if(parseInt(check_date)<=parseInt("20221231")) {
			if (getCookie("ncook20210712") != "done20210712") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20210712.htm","popup_20210712","width=500, height=250, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR21006119 동원 우민아 고객사 코드 동원산업(주)(KRDONG0834)
function popup_20210722() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRDONG0834"){
		if(parseInt(check_date)<=parseInt("20221231")) {
			if (getCookie("ncook20210722") != "done20210722") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20210722.htm","popup_20210722","width=540, height=540, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR21006119 동원 우민아  (주)동원엔터프라이즈(KRDONG0820)
function popup_20210722_1() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRDONG0820"){
		if(parseInt(check_date)<=parseInt("20221231")) {
			if (getCookie("ncook20210722") != "done20210722") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20210722_1.htm","popup_20210722_1","width=540, height=540, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR21006223 납기공지 배수빈
function popup_20210727() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20210813")) {
		if (getCookie("ncook20210727") != "done20210727") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20210727.htm","popup_20210727","width=500, height=280, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}

//SR21006236 택배,kep휴무 관련 팝업 우민아 요청
function popup_20210728() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20210806")) {
		if (getCookie("ncook20210728") != "done20210728") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20210728.htm","popup_20210728","width=500, height=280, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}

//SR21009248 코웨이 HC (KRCOWA0007) 홍성은
function popup_20211122() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRCOWA0007"){
		if(parseInt(check_date)<=parseInt("20221122")) {
			if (getCookie("ncook20211122") != "done20211122") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20211122.htm","popup_20211122","width=550, height=310, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}

//SR23000178  김연희 택배공지
function popup_20230105() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20230126")) {
		if (getCookie("ncook20230105") != "done20230105") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20230105.htm","popup_20230105","width=540, height=380, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
function chsngeEmp(){
	
	var value = kepSelectOptionVal("st_emp"); 
	var tmpArrp = value.split("@@");
    document.getElementById("emp_pos").innerText = tmpArrp[3] ;
    document.getElementById("emp_name").innerText = tmpArrp[2] + tmpArrp[3] ;
    document.getElementById("emp_tel").innerText = tmpArrp[5] ;
    document.getElementById("emp_email").href = "mailto:"+tmpArrp[4];
    document.getElementById("emp_email").innerText = tmpArrp[4] ;
    document.getElementById("emp_user_id").vlaue  = tmpArrp[1] ;
    document.getElementById("emp_dept").vlaue       = tmpArrp[7] ;
    document.getElementById("emp_dept_nm").vlaue       = tmpArrp[8] ;
    
}
//SR21005431 에스원공사 공지 곽원기
function popup_20210630() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20210720")) {
		if (getCookie("ncook20210630") != "done20210630") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20210630.htm","popup_20210630","width=500, height=450, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR21005431 에스원공사 공지 곽원기
function popup_20210631() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20210720")) {
		if (getCookie("ncook20210631") != "done20210631") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20210631.htm","popup_20210631","width=830, height=670, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR21007541 에스원공사 공지 곽원기
function popup_20210913() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20210927")) {
		if (getCookie("ncook20210927") != "done20210927") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20210913.htm","popup_20210913","width=760, height=410, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR21009472 보나비 공지 우민아
function popup_20211201() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRNONA0001"){
		if(parseInt(check_date)<=parseInt("20211203")) {
			if (getCookie("ncook20211201") != "done20211201") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20211201.htm","popup_20211201","width=500, height=295, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR21009599 에스원공사 공지 곽원기
function popup_20211203() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20220110")) {
		if (getCookie("ncook20211203") != "done20211203") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20211203.htm","popup_20211203","width=500, height=590, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR21009798 에스원공사 공지 곽원기
function popup_20211213() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20211217")) {
		if (getCookie("ncook20211213") != "done20211213") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20211213.htm","popup_20211213","width=580, height=360, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR21010088 에스원공사 공지 곽원기
function popup_20211229() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20220103")) {
		if (getCookie("ncook20211229") != "done20211229") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20211229.htm","popup_20211229","width=580, height=510, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR22000415 보나비 공지 우민아
function popup_20220112() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRNONA0001"){
		if(parseInt(check_date)<=parseInt("20220131")) {
			if (getCookie("ncook20220112") != "done20220112") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20220112.htm","popup_20220112","width=500, height=230, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR22000736 에스원공사 공지 김민영
function popup_20220125() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20220203")) {
		if (getCookie("ncook20220125") != "done20220125") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20220125.htm","popup_20220125","width=510, height=570, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR22000787 휴온스 사용불가 공지 백승엽
function popup_20220126() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHUON0004"||buyer=="KRBIOT0004"){
		if(parseInt(check_date)<=parseInt("20220425")) {
			if (getCookie("ncook20220126") != "done20220126") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20220126.htm","popup_20220126","width=700, height=395, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR22001189 코웨이 공지 김연희
function popup_20220208() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRCOWA0001"||buyer=="KRCOWA0005"||buyer=="KRCOWA0006"||buyer=="KRCOWA0009"||
			buyer=="KRCOWA0004"||buyer=="KRCOWA0002"||buyer=="KRCOWA0003"||buyer=="KRCOWA0007"||buyer=="KRCOWA0008"){
		if(parseInt(check_date)<=parseInt("20220320")) {
			if (getCookie("ncook20220212") != "done20220212") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20220212.htm","popup_20220212","width=715, height=450, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR22001029  휴온스메디컬 공지 백승엽
function popup_20220210() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRPANA0006"){
		if(parseInt(check_date)<=parseInt("20220506")) {
			if (getCookie("ncook20220208") != "done20220208") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20220208.htm","popup_20220208","width=760, height=400, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR22001504 경농 경주연구소 공지 김한나
function popup_20220217() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKYUN0206"){
		if(parseInt(check_date)<=parseInt("20220331")) {
			if (getCookie("ncook20220224") != "done20220224") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20220224.htm","popup_20220224","width=560, height=420, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR22001619 - 성아진
function popup_20220227() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRLOTT0058"){
		if(parseInt(check_date)<=parseInt("20220303")) {
			if (getCookie("ncook20220227") != "done20220227") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20220227.htm","popup_20220227","width=700, height=420, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR22001729 에스원공사 공지 김민영
function popup_20220228() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20220331")) {
		if (getCookie("ncook20220228") != "done20220228") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20220228.htm","popup_20220228","width=700, height=580, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR22001739  - 성아진
function popup_20220302() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRLOTT0058"){
		if(parseInt(check_date)<=parseInt("20220224")) {
			if (getCookie("ncook20220302") != "done20220302") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20220302.htm","popup_20220302","width=840, height=470, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR22001746 에스원공사 공지 고은해
function popup_20220303() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20220320")) {
		if (getCookie("ncook20220303") != "done20220303") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20220303.htm","popup_20220303","width=650, height=610, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR22002068  - 성아진
function popup_20220305() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRLOTT0058"){
		if(parseInt(check_date)<=parseInt("20220317")) {
			if (getCookie("ncook20220305") != "done20220305") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20220305.htm","popup_20220305","width=745, height=435, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR22002556  - 롯데칠성음료 성아진주임
function popup_20220310() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRLOTT0058"){
		if(parseInt(check_date)<=parseInt("20220331")) {
			if (getCookie("ncook20220310") != "done20220310") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20220310.htm","popup_20220310","width=745, height=460, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR22002834   - 롯데칠성음료 성아진주임
function popup_20220316() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRLOTT0058"){
		if(parseInt(check_date)<=parseInt("20220428")) {
			if (getCookie("ncook20220316") != "done20220316") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20220316.htm","popup_20220316","width=530, height=755, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR22003372 - 휴온스 윤성찬
function popup_20220401() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHUON0001"){
		if(parseInt(check_date)<=parseInt("20220531")) {
			if (getCookie("ncook20220401") != "done20220401") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20220401.htm","popup_20220401","width=590, height=370, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR22004483 배수빈
function popup_20220512() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20220516")) {
		if (getCookie("ncook20220512") != "done20220512") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20220512.htm","popup_20220512","width=380, height=230, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR22005586 배수빈 홍익대학교(KRHONG0020)
function popup_20220614() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHONG0020"){
	  if(parseInt(check_date)<=parseInt("29991231")) {
		if (getCookie("ncook20220614") != "done20220614") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20220614.htm","popup_20220614","width=570, height=370, scrollbars = no");
			noticeWindow.opener = self;
			 }
		}
	}
}
//SR22005767 백승엽 고객사 코드 : KRHABE0001
function popup_20220621() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHABE0001"){
	  if(parseInt(check_date)<=parseInt("20220921")) {
		if (getCookie("ncook20220621") != "done20220621") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20220621.htm","popup_20220621","width=600, height=260, scrollbars = no");
			noticeWindow.opener = self;
			 }
		}
	}
}

//SR22006590 우민아 고객사 코드 : KRCHUN0208
function popup_20220716() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRCHUN0208"){
	  if(parseInt(check_date)<=parseInt("20220715")) {
		if (getCookie("ncook20220716") != "done20220716") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20220716.htm","popup_20220716","width=520, height=280, scrollbars = no");
			noticeWindow.opener = self;
			 }
		}
	}
}
//SR22007428 홍윤희 에스와이에스리테일 KRSYSR0001
function popup_20220809() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRSYSR0001"){
	  if(parseInt(check_date)<=parseInt("20220819")) {
		if (getCookie("ncook20220809") != "done20220809") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20220809.htm","popup_20220809","width=500, height=370, scrollbars = no");
			noticeWindow.opener = self;
			 }
		}
	}
}
//SR22007845 김연희 고객사 공지팝업 등록의 건
function popup_20220826() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20220914")) {
		if (getCookie("ncook20220826") != "done20220826") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20220826.htm","popup_20220826","width=540, height=350, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR22007907 홍윤희 에스와이에스리테일 KRSYSR0001
function popup_20220829() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRSYSR0001"){
	  if(parseInt(check_date)<=parseInt("20220902")) {
		if (getCookie("ncook20220829") != "done20220829") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20220829.htm","popup_20220829","width=580, height=420, scrollbars = no");
			noticeWindow.opener = self;
			 }
		}
	}
}
//SR22008159 고승범 롯데칠성음료(주) KRLOTT0058
function popup_20220901() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRLOTT0058"){
	  if(parseInt(check_date)<=parseInt("20220912")) {
		if (getCookie("ncook20220901") != "done20220901") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20220901.htm","popup_20220901","width=510, height=330, scrollbars = no");
			noticeWindow.opener = self;
			 }
		}
	}
}
//SR22008267 백승엽 휴온스
function popup_20220905() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHUON0001"||buyer=="KRHUME0001"||buyer=="KRHUON0006"||buyer=="KRHUON0010"||buyer=="KRHUON0011"||buyer=="KRUONS0001"||buyer=="KRHUON0005"||buyer=="KRHUON0003"){
	  if(parseInt(check_date)<=parseInt("20220916")) {
		if (getCookie("ncook20220905") != "done20220905") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20220905.htm","popup_20220905","width=650, height=270, scrollbars = no");
			noticeWindow.opener = self;
			 }
		}
	}
}
//SR22008318 에스원공사 공지 고은해
function popup_20220906() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20220913")) {
		if (getCookie("ncook20220906") != "done20220906") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20220906.htm","popup_20220906","width=520, height=390, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR22008956 이송희 윈체2
function popup_20220928() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRWINC0004"){
	  if(parseInt(check_date)<=parseInt("20221007")) {
		if (getCookie("ncook20220928") != "done20220928") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20220928.htm","popup_20220928","width=620, height=320, scrollbars = no");
			noticeWindow.opener = self;
			 }
		}
	}
}
//SR22009070 에스원공사 단가 공지 김민영
function popup_20220930() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20221014")) {
		if (getCookie("ncook20220930") != "done20220930") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20220930.htm","popup_20220930","width=500, height=420, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR22009304 홍윤희
function popup_20221007() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRSYSR0001"){
	  if(parseInt(check_date)<=parseInt("20221021")) {
		if (getCookie("ncook20221007") != "done20221007") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20221007.htm","popup_20221007","width=500, height=300, scrollbars = no");
			noticeWindow.opener = self;
			 }
		}
	}
}
//SR22010108 동원엔터프라이즈 서동욱
function popup_20221101() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRDONG0820"){
	  if(parseInt(check_date)<=parseInt("29991231")) {
		if (getCookie("ncook20221101") != "done20221101") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20221101.htm","popup_20221101","width=500, height=520, scrollbars = no");
			noticeWindow.opener = self;
			 }
		}
	}
}
//SR22011333 롯데칠성 최예나
function popup_20221208() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRLOTT0058"){
	  if(parseInt(check_date)==parseInt("20221209")) {
		if (getCookie("ncook20221208") != "done20221208") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20221208.htm","popup_20221208","width=550, height=360, scrollbars = no");
			noticeWindow.opener = self;
			 }
		}
	}
}
//SR22011413 배수빈
function popup_20221209() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)==parseInt("20221209")) {
		if (getCookie("ncook20221209") != "done20221209") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20221209.htm","popup_20221209","width=460, height=360, scrollbars = no");
			noticeWindow.opener = self;
			 }
	}
}
//SR22011438 롯데칠성 최예나
function popup_20221210() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRLOTT0058"){
	  if(parseInt(check_date)<=parseInt("20221214")) {
		if (getCookie("ncook20221210") != "done20221210") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20221210.htm","popup_20221210","width=450, height=400, scrollbars = no");
			noticeWindow.opener = self;
			 }
		}
	}
}
//SR22011657  (주)노랑풍선(KRYELL0001) 오연주
function popup_20221217() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRYELL0001"){
		if(parseInt(check_date)<=parseInt("29991231")) {
			if (getCookie("ncook20221217") != "done20221217") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20221217.htm","popup_20221217","width=460, height=230, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR22011825  	롯데칠성음료(주)  회원사코드: KRLOTT0058 고승범
function popup_20221222() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRLOTT0058"){
		if(parseInt(check_date)<=parseInt("20230106")) {
			if (getCookie("ncook20221222") != "done20221222") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20221222.htm","popup_20221222","width=530, height=430, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR22011883  	롯데칠성음료(주)  회원사코드: KRLOTT0058 고승범
function popup_20221224() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRLOTT0058"){
		if(parseInt(check_date)<=parseInt("20221230")) {
			if (getCookie("ncook20221224") != "done20221224") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20221224.htm","popup_20221224","width=450, height=300, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR22012129 에스원공사 단가 공지 고은해
function popup_20221230() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20230120")) {
		if (getCookie("ncook20221230") != "done20221230") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20221230.htm","popup_20221230","width=500, height=480, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR23000249 애경케미칼 울산공장 김한나
function popup_20230106() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRAEKY0006"){
		if(parseInt(check_date)<=parseInt("20230131")) {
			if (getCookie("ncook20230106") != "done20230106") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230106.htm","popup_20230106","width=590, height=430, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23000391 에스원공사 단가 공지 고은해
function popup_20230110() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20230125")) {
		if (getCookie("ncook20230110") != "done20230110") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20230110.htm","popup_20230110","width=530, height=460, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR23000451 귀뚜라미 비공장 공지 팝업 등록의 건 서동욱
function popup_20230111() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKITU0005"){
		if(parseInt(check_date)<=parseInt("20230131")) {
			if (getCookie("ncook20230111") != "done20230111") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230111.htm","popup_20230111","width=450, height=260, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23000603 롯데칠성음료(주) 고승범
function popup_20230116() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRLOTT0058"){
		if(parseInt(check_date)<=parseInt("20230124")) {
			if (getCookie("ncook20230116") != "done20230116") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230116.htm","popup_20230116","width=520, height=380, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23000787 롯데칠성음료(주) 고승범
function popup_20230125() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRLOTT0058"){
		if(parseInt(check_date)<=parseInt("20230129")) {
			if (getCookie("ncook20230125") != "done20230125") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230125.htm","popup_20230125","width=500, height=350, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23000803 코오롱글로텍  서동욱
function popup_20230126() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKOLO0006"){
		if(parseInt(check_date)<=parseInt("20991231")) {
			if (getCookie("ncook20230126") != "done20230126") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230126.htm","popup_20230126","width=500, height=360, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23000863 롯데칠성음료(주) 공지 팝업 요청의 건 - 고승범
function popup_20230128() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRLOTT0058"){
		if(parseInt(check_date)<=parseInt("20230228")) {
			if (getCookie("ncook20230128") != "done20230128") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230128.htm","popup_20230128","width=520, height=500, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23002837 코오롱모빌리티그룹 외 홍윤희
function popup_20230323() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKOLO0119"||buyer=="KRKOLO0152"||buyer=="KRVOLV0001"){
		if(parseInt(check_date)<=parseInt("20230407")) {
			if (getCookie("ncook20230323") != "done20230323") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230323.htm","popup_20230323","width=500, height=430, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23003466 코오롱모빌리티그룹 외 홍윤희
function popup_20230411() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKOLO0119"||buyer=="KRKOLO0152"||buyer=="KRVOLV0001"){
		if(parseInt(check_date)<=parseInt("20230531")) {
			if (getCookie("ncook20230411") != "done20230411") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230411.htm","popup_20230411","width=600, height=400, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23003768 (주)조선호텔앤리조트 김연희
function popup_20230418(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRJOSU0003"){
		if(parseInt(check_date)<=parseInt("20230520")) {
			if (getCookie("ncook20230418") != "done20230418") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230418.htm","popup_20230418","width=630, height=420, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23005168 한화갤러리아(주) 홍윤희
function popup_20230530(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHANW0020"){
		if(parseInt(check_date)<=parseInt("202300616")) {
			if (getCookie("ncook20230530") != "done20230530") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230530.htm","popup_20230530","width=450, height=490, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23005175 서비스사업팀 전체고객사 배수빈
function popup_20230531(){
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20230606")) {
		if (getCookie("ncook20230531") != "done20230531") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20230531.htm","popup_20230531","width=420, height=315, scrollbars = no");
			noticeWindow.opener = self;
			 }
		}
}
//SR23005417 금호석유화학 박순찬
function popup_20230602(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKUMH0043"||buyer=="KRKUMH0044"||buyer=="KRKUMH0045"||buyer=="KRKUMH0046"||buyer=="KRKUMH0047"||buyer=="KRKUMH0048"||buyer=="KRKUMH0049"||buyer=="KRKUMH0050"||buyer=="KRKUMH0051"||buyer=="KRKUMH0052"||buyer=="KRKUMH0053"){
		if(parseInt(check_date)<=parseInt("20230831")) {
			if (getCookie("ncook20230602") != "done20230602") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230602.htm","popup_20230602","width=510, height=460, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23005438 금호석유화학 박순찬
function popup_20230603(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKUMH0043"||buyer=="KRKUMH0044"||buyer=="KRKUMH0045"||buyer=="KRKUMH0046"||buyer=="KRKUMH0047"||buyer=="KRKUMH0048"||buyer=="KRKUMH0049"||buyer=="KRKUMH0050"||buyer=="KRKUMH0051"||buyer=="KRKUMH0052"||buyer=="KRKUMH0053"){
		if(parseInt(check_date)<=parseInt("20230831")) {
			if (getCookie("ncook20230603") != "done20230603") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230603.htm","popup_20230603","width=550, height=300, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}

//SR23005725 (주)조선호텔앤리조트 김연희
function popup_20230614(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRJOSU0003"){
		if(parseInt(check_date)<=parseInt("20230616")) {
			if (getCookie("ncook20230614") != "done20230614") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230614.htm","popup_20230614","width=470, height=320, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23005725 	(주)에스와이에스홀딩스	에스와이에스리테일
function popup_20230615(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRSYS-0001"||buyer=="KRSYSR0001"){
		if(parseInt(check_date)<=parseInt("20230616")) {
			if (getCookie("ncook20230615") != "done20230615") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230615.htm","popup_20230615","width=470, height=320, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23005759 금호석유화학 정영설
function popup_20230616(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKUMH0043"||buyer=="KRKUMH0044"||buyer=="KRKUMH0045"||buyer=="KRKUMH0046"||buyer=="KRKUMH0047"||buyer=="KRKUMH0048"||buyer=="KRKUMH0049"||buyer=="KRKUMH0050"||buyer=="KRKUMH0051"||buyer=="KRKUMH0052"||buyer=="KRKUMH0053"){
		if(parseInt(check_date)<=parseInt("20230930")) {
			if (getCookie("ncook20230616") != "done20230616") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230616.htm","popup_20230616","width=580, height=510, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23005873 금호석유화학 한세휘
function popup_20230620(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKUMH0043"||buyer=="KRKUMH0044"||buyer=="KRKUMH0045"||buyer=="KRKUMH0046"||buyer=="KRKUMH0047"||buyer=="KRKUMH0048"||buyer=="KRKUMH0049"||buyer=="KRKUMH0050"||buyer=="KRKUMH0051"||buyer=="KRKUMH0052"||buyer=="KRKUMH0053"){
		if(parseInt(check_date)<=parseInt("20230930")) {
			if (getCookie("ncook20230620") != "done20230620") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230620.htm","popup_20230620","width=690, height=660, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23005998 경농 구동윤
function popup_20230621(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKYUN0184"){
		if(parseInt(check_date)<=parseInt("20230628")) {
			if (getCookie("ncook20230621") != "done20230621") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230621.htm","popup_20230621","width=450, height=460, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23006472 담당고객사 배수빈 
function popup_20230706(){
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20230716")) {
		if (getCookie("ncook20230706") != "done20230706") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20230706.htm","popup_20230706","width=500, height=380, scrollbars = no");
			noticeWindow.opener = self;
			 }
		}
}
//SR23006572 서비스사업팀 담당고객사 김연희
function popup_20230711(){
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20230714")) {
		if (getCookie("ncook20230711") != "done20230711") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20230711.htm","popup_20230711","width=500, height=430, scrollbars = no");
			noticeWindow.opener = self;
			}
		}
}
//SR23006645 에스원 휴무 공지 고은해
function popup_20230714() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20230714")) {
		if (getCookie("ncook20230714") != "done20230714") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20230714.htm","popup_20230714","width=590, height=550, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR23006721 넥센타이어 사무용품 백희영
function popup_20230717(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRNEXE0010"){
		if(parseInt(check_date)<=parseInt("20230731")) {
			if (getCookie("ncook20230717") != "done20230717") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230717.htm","popup_20230717","width=480, height=310, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23006887 조광페인트 그룹 임태헌
function popup_20230720(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRCHOK0005" || buyer=="KRCHOK0003" || buyer=="KRCHOK0004" || buyer=="KRCHOK0006"){
		if(parseInt(check_date)<=parseInt("20230920")) {
			if (getCookie("ncook20230720") != "done20230720") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230720.htm","popup_20230720","width=500, height=430, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23007072 조선호텔앤리조트 김연희
function popup_20230726(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRJOSU0003"){
		if(parseInt(check_date)<=parseInt("29991231")) {
			if (getCookie("ncook20230726") != "done20230726") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230726.htm","popup_20230726","width=650, height=295, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR23007557 서비스사업팀 배수빈
function popup_20230807(){
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20230815")) {
		if (getCookie("ncook20230807") != "done20230807") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20230807.htm","popup_20230807","width=500, height=350, scrollbars = no");
			noticeWindow.opener = self;
			}
		}
}
//SR23007740 LINK팀 노민수
function popup_20230816(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRLAND0003"){	
		if(parseInt(check_date)>=parseInt("20230821") && parseInt(check_date)<=parseInt("20230930")) {
			if (getCookie("ncook20230816") != "done20230816") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230816.htm","popup_20230816","width=500, height=270, scrollbars = no");
				noticeWindow.opener = self;
				}
			}
	}
}
//SR23008394 제조사업3팀 백희영
function popup_20230904(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRNEXE0010"){	
		if(parseInt(check_date)<=parseInt("20230927")) {
			if (getCookie("ncook20230904") != "done20230904") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230904.htm","popup_20230904","width=500, height=350, scrollbars = no");
				noticeWindow.opener = self;
				}
			}
	}
}
//SR23008610 서비스사업팀 담당고객사 김연희
function popup_20230911(){
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20231006")) {
		if (getCookie("ncook20230911") != "done20230911") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20230911.htm","popup_20230911","width=530, height=370, scrollbars = no");
			noticeWindow.opener = self;
			}
		}
}
//SR23008800 SMART팀 고은해
function popup_20230918(){
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20231006")) {
		if (getCookie("ncook20230918") != "done20230918") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20230918.htm","popup_20230918","width=550, height=510, scrollbars = no");
			noticeWindow.opener = self;
			}
		}
}
//SR23008823 코웨이 김은혜
function popup_20230919(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRCOWA0001"|| buyer=="KRCOWA0002" ||  buyer=="KRCOWA0003" || buyer=="KRCOWA0005"|| buyer=="KRCOWA0006"|| buyer=="KRCOWA0007" || buyer=="KRCOWA0008" || buyer=="KRCOWA0009" ){	
		if(parseInt(check_date)<=parseInt("20231004")) {
			if (getCookie("ncook20230919") != "done20230919") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20230919.htm","popup_20230919","width=610, height=430, scrollbars = no");
				noticeWindow.opener = self;
				}
			}
	}
}
//SR23008898 제조사업1팀 SPC고객사 최영욱
function popup_20230921(){
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20231006")) {
		if (getCookie("ncook20230921") != "done20230921") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20230921.htm","popup_20230921","width=650, height=695, scrollbars = no");
			noticeWindow.opener = self;
			}
		}
}
//SR23009208 하이트 송기원
function popup_20231005(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRJINR0004"|| buyer=="KRHITE0003"){	
		if(parseInt(check_date)<=parseInt("20231231")) {
			if (getCookie("ncook20231005") != "done20231005") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20231005.htm","popup_20231005","width=520, height=590, scrollbars = no");
				noticeWindow.opener = self;
				}
			}
	}
}
//SR23009825 제조사업3팀 임태헌
function popup_20231030(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRTCTE0002"){	
		if(parseInt(check_date)<=parseInt("20231231")) {
			if (getCookie("ncook20231030") != "done20231030") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20231030.htm","popup_20231030","width=480, height=320, scrollbars = no");
				noticeWindow.opener = self;
				}
			}
	}
}
//SR23009859 동화그룹 김선후
function popup_20231031() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRDONG1108"||buyer=="KRDONG1107"||buyer=="KRDONG1109"||buyer=="KRSUNR0004"){
		if(parseInt(check_date)<=parseInt("20231231")) {
			if (getCookie("ncook20231031") != "done20231031") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20231031.htm","popup_20231031","width=1030, height=570, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}

//SR23010433 서비스사업팀 김연희
function popup_20231117() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRJOSU0003"||buyer=="KRHOBA0004"||buyer=="KRHOBA0005"||buyer=="KRHOBA0003"||buyer=="KRHAEV0001"||buyer=="KRHAEV0002"){
		if(parseInt(check_date)<=parseInt("20231126")) {
			if (getCookie("ncook20231117") != "done20231117") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20231117.htm","popup_20231117","width=490, height=300, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}

//SR23010433 서비스사업팀 김연희
function popup_20231118() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRSYS-0001"||buyer=="KRSYSR0001"){
		if(parseInt(check_date)<=parseInt("20231126")) {
			if (getCookie("ncook20231118") != "done20231118") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20231118.htm","popup_20231118","width=490, height=300, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}

//SR23010596 서비스사업팀 조현주
function popup_20231123() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRCOWA0001"){
		if(parseInt(check_date)<=parseInt("20231201")) {
			if (getCookie("ncook20231123") != "done20231123") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20231123.htm","popup_20231123","width=460, height=240, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR23010949 SMART팀 고은해
function popup_20231204() {
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20241231")) {
		if (getCookie("ncook20231204") != "done20231204") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20231204.htm","popup_20231204","width=570, height=510, scrollbars = no");
			noticeWindow.opener = self;
			}
		}
}
//SR23011665 서비스사업팀 김연희
function popup_20231229() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHANW0020"){
		if(parseInt(check_date)<=parseInt("20240630")) {
			if (getCookie("ncook20231229") != "done20231229") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20231229.htm","popup_20231229","width=570, height=260, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR24000213 MRO사업1팀 박지수
function popup_20240104() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRINNO0066" || buyer=="KRINNO0067" || buyer=="KRINNO0068" || buyer=="KRINNO0069"){
		if(parseInt(check_date)<=parseInt("20240131")) {
			if (getCookie("ncook20240104") != "done20240104") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240104.htm","popup_20240104","width=500, height=440, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR24000846 MRO사업1팀 서동욱
function popup_20240124() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRJOSU0003"){
		if (getCookie("ncook20240124") != "done20240124") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20240124.htm","popup_20240124","width=520, height=340, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR24001011 MRO사업1팀 배수빈, SR24001251 MRO사업1팀 유현진
function popup_20240130() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20240214")) {
		if (getCookie("ncook20240130") != "done20240130") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20240130.htm","popup_20240130","width=500, height=440, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR24001150 MRO사업1팀 윤성찬
function popup_20240131() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHUGE0001"){
		if(parseInt(check_date)<=parseInt("20240430")) {
			if (getCookie("ncook20240131") != "done20240131") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240131.htm","popup_20240131","width=500, height=330, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR24001318 SMART팀 고은해
function popup_20240202() {	
	var check_date = "<%=check_date%>";	
		if(parseInt(check_date)<=parseInt("20240215")) {
			if (getCookie("ncook20240202") != "done20240202") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240202.htm","popup_20240202","width=530, height=500, scrollbars = no");
				noticeWindow.opener = self;
			}		
	}
}
//SR24001353 MRO사업1팀 서동욱
function popup_20240205() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRDONG0832"||buyer=="KRDONG0834"){
		if (getCookie("ncook20240205") != "done20240205") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20240205.htm","popup_20240205","width=450, height=315, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR24002054 MRO사업1팀 윤성찬
function popup_20240229() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHUGE0001"){
		if(parseInt(check_date)<=parseInt("20240331")) {
			if (getCookie("ncook20240229") != "done20240229") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240229.htm","popup_20240229","width=480, height=250, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR24002297 MRO사업1팀 최영욱
function popup_20240307() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRSPC-0002"||buyer=="KRSECT0001"||buyer=="KRPARI0002"||buyer=="KRPARI0003"||buyer=="KRPARI0004"||buyer=="KRKSP-0003"||buyer=="KRSPCS0001"
			||buyer=="KRSPCS0002"||buyer=="KRSPCS0003"||buyer=="KRSPCS0004"||buyer=="KRSPCS0005"||buyer=="KRSPCS0006"||buyer=="KRSPCS0007"||buyer=="KRSPCS0008"
			||buyer=="KRSPCS0009"||buyer=="KRSANG0122"||buyer=="KRSHAN0003"||buyer=="KRSHAN0004"||buyer=="KRBRKO0001"||buyer=="KRBRKO0002"||buyer=="KRBRKO0003"
			||buyer=="KRBRKO0004"||buyer=="KRSHAN0005"||buyer=="KRSHAN0006"||buyer=="KRSAND0011"||buyer=="KRSAND0012"||buyer=="KRHOJI0005"||buyer=="KRSPL-0001"
			||buyer=="KRSPC-0003"||buyer=="KRSPC-0004"){
		if(parseInt(check_date)<=parseInt("20240430")) {
			if (getCookie("ncook20240307") != "done20240307") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240307.htm","popup_20240307","width=520, height=420, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR24004389 MRO사업1팀 최영욱
function popup_20240521_1() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRSPC-0002"||buyer=="KRSECT0001"||buyer=="KRPARI0002"||buyer=="KRPARI0003"||buyer=="KRPARI0004"||buyer=="KRKSP-0003"||buyer=="KRSPCS0001"
			||buyer=="KRSPCS0002"||buyer=="KRSPCS0003"||buyer=="KRSPCS0004"||buyer=="KRSPCS0005"||buyer=="KRSPCS0006"||buyer=="KRSPCS0007"||buyer=="KRSPCS0008"
			||buyer=="KRSPCS0009"||buyer=="KRSANG0122"||buyer=="KRSHAN0003"||buyer=="KRSHAN0004"||buyer=="KRBRKO0001"||buyer=="KRBRKO0002"||buyer=="KRBRKO0003"
			||buyer=="KRBRKO0004"||buyer=="KRSHAN0005"||buyer=="KRSHAN0006"||buyer=="KRSAND0011"||buyer=="KRSAND0012"||buyer=="KRHOJI0005"||buyer=="KRSPL-0001"
			||buyer=="KRSPC-0003"||buyer=="KRSPC-0004"){
		if(parseInt(check_date)<=parseInt("20241231")) {
			if (getCookie("ncook20240521_1") != "done20240521_1") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240521_1.htm","popup_20240521_1","width=660, height=590, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
// SR24002915 MRO사업2팀 유채연
function popup_20240329() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRLAND0003"){
		if(parseInt(check_date)<=parseInt("29991231")) {
			if (getCookie("ncook20240329") != "done20240329") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240329.htm","popup_20240329","width=555, height=345, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
} 
//SR24003207 MRO사업1팀 김은혜  
function popup_20240403() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRCOWA0001" || buyer=="KRCOWA0002" || buyer=="KRCOWA0003" || buyer=="KRCOWA0007" || buyer=="KRCOWA0008" || buyer=="KRCOWA0009" || buyer=="KRCOWA0006"
			|| buyer=="KRCOWA0005" || buyer=="KRWAPI0002" || buyer=="KRKORE0632"){
		if(parseInt(check_date)<=parseInt("20240510")) {
			if (getCookie("ncook20240403") != "done20240403") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240403_3.htm","popup_20240403_3","width=660, height=400, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR24003272 MRO사업1팀 윤성찬  
function popup_20240405() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHANL0014"){
		if(parseInt(check_date)<=parseInt("20240430")) {
			if (getCookie("ncook20240405") != "done20240405") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240405.htm","popup_20240405","width=470, height=220, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR24003301 MRO사업1팀 김연희  
function popup_20240408() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHANW0020"){
		if(parseInt(check_date)<=parseInt("20240430")) {
			if (getCookie("ncook20240408") != "done20240408") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240408.htm","popup_20240408","width=480, height=310, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR24003544 MRO사업1팀 윤성찬  
function popup_20240417() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRWHAN0001"||buyer=="KRWHAN0002"||buyer=="KRWHAN0004"){
		if(parseInt(check_date)<=parseInt("20240510")) {
			if (getCookie("ncook20240417") != "done20240417") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240417.htm","popup_20240417","width=470, height=220, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR24003645 MRO사업1팀 서동욱  
function popup_20240422() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRJOSU0003"){
		if(parseInt(check_date)<=parseInt("20240423")) {
			if (getCookie("ncook20240422") != "done20240422") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240422.htm","popup_20240422","width=520, height=305, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR24003830 MRO사업1팀 윤성찬 
function popup_20240429() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHUGE0001"){
		if(parseInt(check_date)<=parseInt("20240531")) {
			if (getCookie("ncook20240429") != "done20240429") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240429.htm","popup_20240429","width=550, height=480, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR24003924 MRO사업1팀 윤성찬 
function popup_20240431() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRYUYU0005"){
		if(parseInt(check_date)<=parseInt("20240517")) {
			if (getCookie("ncook20240431") != "done20240431") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240431.htm","popup_20240431","width=450, height=220, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR24003946 MRO사업1팀 윤성찬 
function popup_20240502() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRSGS-0001"){
		if(parseInt(check_date)<=parseInt("20240517")) {
			if (getCookie("ncook20240502") != "done20240502") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240502.htm","popup_20240502","width=450, height=220, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR24004725 MRO사업3팀 여상현  
function popup_20240603() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKUMH0043"||buyer=="KRKUMH0044"||buyer=="KRKUMH0045"||buyer=="KRKUMH0046"||buyer=="KRKUMH0047"||buyer=="KRKUMH0048"||buyer=="KRKUMH0049"
			||buyer=="KRKUMH0050"||buyer=="KRKUMH0051"||buyer=="KRKUMH0052"||buyer=="KRKUMH0053"){
		if(parseInt(check_date)<=parseInt("20240612")) {
			if (getCookie("ncook20240603") != "done20240603") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240603.htm","popup_20240603","width=540, height=340, scrollbars = no");
				noticeWindow.opener = self;
			}
		}		
	}
}

//SR25006336 MRO사업1팀 배수빈 
function popup_20250731() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRDONG1104"||buyer=="KRDONG1285"){
		if (getCookie("ncook20250731") != "done20250731") {
			noticeWindow = window.open("/resources/html/main/notice/popup_KRDONG.htm","popup_KRDONG","width=710, height=670, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}

//SR24004725 MRO사업3팀 여상현  
function popup_20240710() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRDONG0834"||buyer=="KRDONG0835"||buyer=="KRDONG0832"||buyer=="KRDONG0833"||buyer=="KRDONG1144"||buyer=="KRDONG0838"||buyer=="KRDONG0841"
		||buyer=="KRDONG0837"||buyer=="KRDONG1188"||buyer=="KRDONG0903"||buyer=="KRNEXT0024"||buyer=="KRDONG1104"||buyer=="KRDONG1285"||buyer=="KRDONG0831"
		||buyer=="KRHONG0020"||buyer=="KRMEGA0005"||buyer=="KRNC-S0001"||buyer=="KRSYSR0001"||buyer=="KRWOOS0062"||buyer=="KRFAGB0001"||buyer=="KRSYS-0001"){
		if(parseInt(check_date)<=parseInt("20240712")) {
			if (getCookie("ncook20240710") != "done20240710") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240710.htm","popup_20240710","width=480, height=340, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR24005973 MRO사업1팀 김연희
function popup_20240711() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRDONG1108"||buyer=="KRSUNR0004"||buyer=="KRDONG1107"||buyer=="KRDONG1109"){
		if(parseInt(check_date)<=parseInt("20241231")) {
			if (getCookie("ncook20240711") != "done20240711") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240711.htm","popup_20240711","width=1030, height=590, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR24006089 MRO사업1팀 임효정
function popup_20240716() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHANW0020"){
		if(parseInt(check_date)<=parseInt("20240805")) {
			if (getCookie("ncook20240716") != "done20240716") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240716.htm","popup_20240716","width=550, height=350, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR24006364 MRO사업1팀 윤성찬
function popup_20240726() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHUON0001"||buyer=="KRHUME0001"||buyer=="KRHUON0006"||buyer=="KRHUON0005"||buyer=="KRHUON0010"||buyer=="KRHUON0011"||buyer=="KRUONS0001"||buyer=="KRHUON0003"||buyer=="KRCRYS0005"||buyer=="KRFOOD0005"){
		if(parseInt(check_date)<=parseInt("20240809")) {
			if (getCookie("ncook20240726") != "done20240726") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240726.htm","popup_20240726","width=500, height=340, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR24006364 MRO사업1팀 윤성찬
function popup_20240729() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHUGE0001"){
		if(parseInt(check_date)<=parseInt("20241031")) {
			if (getCookie("ncook20240734") != "done20240734") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240734.htm","popup_20240734","width=600, height=340, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR24006613 MRO사업1팀 김은혜	2018.09.13~
function popup_20240801() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHYOS0049"||buyer=="KRHYOS0051"||buyer=="KRHYOS0053"||buyer=="KRHYOS0052"||buyer=="KRHYOS0054"||buyer=="KRHYOS0055"||buyer=="KRHYOS0061"){
		if(parseInt(check_date)<=parseInt("29991231")) {
			if (getCookie("ncook20240801") != "done20240801") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240801.htm","popup_20240801","width=380, height=285, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}

//SR24007043 MRO사업1팀 배수빈
function popup_20240819() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRDONG1144"){
		if(parseInt(check_date)<=parseInt("29991231")) {
			if (getCookie("ncook20240819") != "done20240819") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240819.htm","popup_20240819","width=520, height=370, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR24007445 MRO사업1팀 임효정
//SR24007531 MRO사업1팀 임효정
function popup_20240829() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHANW0020"){
		if(parseInt(check_date)<=parseInt("20240918")) {
			if (getCookie("ncook20240829") != "done20240829") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240829.htm","popup_20240829","width=530, height=380, scrollbars = no");
				noticeWindow.opener = self;
			}
			if (getCookie("ncook20240902") != "done20240902") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240902.htm","popup_20240902","width=540, height=350, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR24006723 MRO사업1팀 배수빈
//SR24006893 MRO사업1팀 지윤소 (추가)
function popup_20240805() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20240820")) {
		if (getCookie("ncook20240805") != "done20240805") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20240805.htm","popup_20240805","width=570, height=520, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}

//SR24007465 MRO사업1팀 김연희
function popup_20240830_1() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRBGF-0001" || buyer=="KRBGFR0001"){
		if(parseInt(check_date)<=parseInt("20241231")) {
			if (getCookie("ncook20240830_1") != "done20240830_1") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240830_1.htm","popup_20240830_1","width=660, height=380, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR24007579 MRO사업1팀 김연희
function popup_20240904() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRBGF-0002"){
		if(parseInt(check_date)<=parseInt("20241231")) {
			if (getCookie("ncook20240904") != "done20240904") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240904.htm","popup_20240904","width=480, height=450, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR24007687 MRO사업1팀 배수빈
function popup_20240905() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20240920")) {
		if (getCookie("ncook20240905") != "done20240905") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20240905.htm","popup_20240905","width=490, height=480, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}

//SR24007721 MRO사업1팀 윤성찬
function popup_20240906() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHUGE0001"){
		if(parseInt(check_date)<=parseInt("20241031")) {
			if (getCookie("ncook20240906") != "done20240906") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20240906.htm","popup_20240906","width=470, height=200, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR24007852 SMART팀 고은해
function popup_20240910() {	
	var check_date = "<%=check_date%>";	
	if(parseInt(check_date)<=parseInt("20240920")) {
		if (getCookie("ncook20240910") != "done20240910") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20240910.htm","popup_20240910","width=520, height=500, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
	
}
//SR24010471 MRO1팀 김연희
function popup_20241207() {
	var buyer="<%=sessionComCode%>";
	if(buyer=="KRSK--0001"||buyer=="KRSK--0002"||buyer=="KRSK--0003"||buyer=="KRSK--0004"){
		if (getCookie("ncook20241207") != "done20241207") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20241207.htm","popup_20241207","width=480, height=380, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}

//SR24010688 MRO사업1팀 김연희
function popup_20241216() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRSCK-0002"){
		if(parseInt(check_date)<=parseInt("20250130")) {
			if (getCookie("ncook20241216") != "done20241216") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20241216.htm","popup_20241216","width=500, height=410, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR24011015 SMART팀 고은해
function popup_20241230() {	
	var check_date = "<%=check_date%>";	
	if(parseInt(check_date)<=parseInt("20250103")) {
		if (getCookie("ncook20241230") != "done20241230") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20241230.htm","popup_20241230","width=500, height=420, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}	
}

//SR25000473 SR25000529 MRO1팀 배수빈
function popup_20250117() {
	var check_date = "<%=check_date%>";	
	if(parseInt(check_date)<=parseInt("20250207")) {
		if (getCookie("ncook20250117") != "done20250117") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250117_1.htm","popup_20250117","width=590, height=570, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR25000477 MRO1팀 최영욱
function popup_20250118() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";	
	if(parseInt(check_date)<=parseInt("20250117")) {
		if(buyer=="KRLOTT0102" || buyer=="KRLOTT0084" || buyer=="KRLOTT0093" || buyer=="KRLOTT0088" || buyer=="KRLOTT0089" || buyer=="KRLOTT0090" || buyer=="KRLOTT0096"
				|| buyer=="KRLOTT0086" || buyer=="KRLOTT0085" || buyer=="KRLOTT0091" || buyer=="KRLOTT0092" || buyer=="KRLOTT0094" || buyer=="KRLOTT0087" || buyer=="KRLOTT0097"
				|| buyer=="KRLOTT0095" || buyer=="KRLOTT0098" || buyer=="KRLOTT0099" || buyer=="KRLOTT0100" || buyer=="KRLOTT0101"){
			if (getCookie("ncook20250118") != "done20250118") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250118_1.htm","popup_20250118","width=540, height=590, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR25000460 SMART팀 고은해
function popup_20250116() {	
	var check_date = "<%=check_date%>";	
	if(parseInt(check_date)<=parseInt("20250203")) {
		if (getCookie("ncook20250116") != "done20250116") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250116.htm","popup_20250116","width=500, height=470, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}
//SR25000460 MRO1팀 김미경
function popup_20250119() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";	
	if(buyer=="KRINNO0067"){
		if(parseInt(check_date)<=parseInt("20251231")) {
			if (getCookie("ncook20250119") != "done20250119") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250119.htm","popup_20250119","width=450, height=300, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR25000460 MRO3팀 진나영
function popup_20250123() {	
	var buyer="<%=sessionComCode%>";	
	if(buyer=="KRKGDO0002"){		
		if (getCookie("ncook20250123") != "done20250123") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250123.htm","popup_20250123","width=440, height=290, scrollbars = no");
			noticeWindow.opener = self;
		 }		
	}
}



//SR25000581 MRO1팀 홍가영
function popup_20250122() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";	
	if(buyer=="KRHUGE0001"){
		if(parseInt(check_date)<=parseInt("20251231")) {
			if (getCookie("ncook20250122") != "done20250122") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250122.htm","popup_20250122","width=590, height=380, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}


//SR25000581 MRO1팀 윤성찬
function popup_20250124() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";	
	if(buyer=="KRHUGE0002"){
		if(parseInt(check_date)<=parseInt("20251231")) {
			if (getCookie("ncook20250124") != "done20250124") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250124.htm","popup_20250124","width=570, height=320, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}



//SR25000581 MRO1팀 임효정
function popup_20250127() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";	
	if(buyer=="KRHANW0020"){
		if(parseInt(check_date)<=parseInt("20250202")) {
			if (getCookie("ncook20250127") != "done20250127") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250127.htm","popup_20250127","width=450, height=380, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}


//SR25000792 MRO1팀 윤성찬
function popup_20250130() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";	
	if(buyer=="KRINNO0066"){
		if(parseInt(check_date)<=parseInt("20250214")) {
			if (getCookie("ncook20250130") != "done20250130") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250130.htm","popup_20250130","width=370, height=240, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR25000792 MRO1팀 윤성찬
function popup_20250132() {		
	var check_date = "<%=check_date%>";		
	if(parseInt(check_date)<=parseInt("20250531")) {
		if (getCookie("ncook20250132") != "done20250132") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250132.htm","popup_20250132","width=480, height=370, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}	
}
//SR25000460 -> SR25001183 SMART팀 고은해
function popup_20250207() {	
	var check_date = "<%=check_date%>";	
	if(parseInt(check_date)<=parseInt("20250214")) {
		if (getCookie("ncook20250207") != "done20250207") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250207.htm","popup_20250207","width=500, height=360, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}
//SR25001396 -> SR25001401 MRO1팀 윤성찬
function popup_20250214() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";	
	if(buyer=="KRHUGE0001" || buyer=="KRACRO0006"){
		if(parseInt(check_date)<=parseInt("20251231")) {
			if (getCookie("ncook20250214") != "done20250214") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250214.html","popup_20250214","width=500, height=370, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR25000460 -> SR25001183 SMART팀 고은해
function popup_20250218() {	
	var check_date = "<%=check_date%>";	
	if(parseInt(check_date)<=parseInt("20250224")) {
		if (getCookie("ncook20250218") != "done20250218") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250218.html","popup_20250218","width=500, height=375, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}

//SR25001596 SMART팀 신준호
function popup_20250222() {	
	var check_date = "<%=check_date%>";	
	if(parseInt(check_date)<=parseInt("20250531")) {
		if (getCookie("ncook20250222") != "done20250222") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250222.htm","popup_20250222","width=500, height=480, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}
//SR25002088 MRO1팀 최영욱
function popup_20250311() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";	
	if(buyer=="KRSHAN0005" || buyer=="KRSHAN0006"){
		if(parseInt(check_date)<=parseInt("20250320")) {
			if (getCookie("ncook20250311") != "done20250311") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250311.htm","popup_20250311","width=510, height=440, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR25002361 MRO1팀 윤성찬
function popup_20250321() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";	
	if(buyer=="KRINNO0066" || buyer=="KRINNO0067" || buyer=="KRINNO0068" || buyer=="KRINNO0069"){
		if(parseInt(check_date)<=parseInt("20250411")) {
			if (getCookie("ncook20250321") != "done20250321") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250321.htm","popup_20250321","width=400, height=320, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR25002918 SMART팀 신준호
function popup_20250404() {	
	var check_date = "<%=check_date%>";	
	if(parseInt(check_date)<=parseInt("20250410")) {
		if (getCookie("ncook20250404") != "done20250404") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250404.html","popup_20250404","width=440, height=330, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}

//SR25003051 MRO1팀 김은혜
function popup_20250409() {	
	var buyer="<%=sessionComCode%>";
	if(buyer=="KRDONG1108" || buyer=="KRDONG1109" || buyer=="KRDONG1107" || buyer=="KRSUNR0004"){
		if (getCookie("ncook20250409") != "done20250409") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250409.htm","popup_20250409","width=890, height=640, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}

//SR25003089 MRO1팀 윤성찬
function popup_20250410() {	
	var buyer="<%=sessionComCode%>";
	if(buyer=="KRHUON0001" || buyer=="KRHUON0006" || buyer=="KRHUON0010" || buyer=="KRUONS0001"){
		if (getCookie("ncook20250410") != "done20250410") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250410.htm","popup_20250410","width=490, height=310, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}

//SR25003502 판촉사업팀 서현정
function popup_20250428() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";	
	if(parseInt(check_date)<=parseInt("20250428")) {
		if(buyer=="KRHANS0308"){
			if (getCookie("ncook20250428") != "done20250428") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250428.htm","popup_20250428","width=430, height=330, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR25003547 MRO1팀 최영욱
function popup_20250431() {	
	var check_date = "<%=check_date%>";	
	if(parseInt(check_date)<=parseInt("20251231")) {
		if (getCookie("ncook20250431") != "done20250431") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250431.htm","popup_20250431","width=600, height=580, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}

//SR25003613 MRO1팀 장지석
function popup_20250432() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";	
	if(parseInt(check_date)<=parseInt("20250503")) {
		if(buyer=="KRSCK-0002"){
			if (getCookie("ncook20250432") != "done20250432") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250432.htm","popup_20250432","width=500, height=400, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR25003712 SMART팀 신준호
function popup_20250507() {	
	var check_date = "<%=check_date%>";	
	if(parseInt(check_date)<=parseInt("20250512")) {
		if (getCookie("ncook20250507") != "done20250507") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250507.htm","popup_20250507","width=480, height=340, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}

// SR25004050 MRO1팀 장지석
function popup_20250520() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";	
	if(parseInt(check_date)<=parseInt("20250530")) {
		if(buyer=="KRSCK-0002"){
			if (getCookie("ncook20250520") != "done20250520") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250520.htm","popup_20250520","width=670, height=590, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

// SR25004143 MRO1 장지석
function popup_20250522() {	
	var buyer="<%=sessionComCode%>";
	if(buyer=="KRNEXU0002"){
		if (getCookie("ncook20250522") != "done20250522") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250522.htm","popup_20250522","width=490, height=380, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}

//SR25004143 MRO1 장지석
function popup_20250523() {	
	var buyer="<%=sessionComCode%>";
	if(buyer=="KRHANS0310"){
		if (getCookie("ncook20250523") != "done20250523") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250523.htm","popup_20250523","width=490, height=380, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR25004675 판촉사업파트 서현정
function popup_20250610() {
	var buyer="<%=sessionComCode%>";
	if(buyer=="KRHANS0308"){
		if (getCookie("ncook20250610") != "done20250610") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250610.htm","popup_20250610","width=450, height=450, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}
//SR25004925 금호석유화학 임태헌
function popup_20250619(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKUMH0043"||buyer=="KRKUMH0044"||buyer=="KRKUMH0045"||buyer=="KRKUMH0046"||buyer=="KRKUMH0047"||buyer=="KRKUMH0048"||buyer=="KRKUMH0049"||buyer=="KRKUMH0052"||buyer=="KRKUMH0053"){
		if(parseInt(check_date)<=parseInt("20251231")) {
			if (getCookie("ncook20250619") != "done20250619") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250619.htm","popup_20250619","width=520, height=660, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}

//SR25005267 금호석유화학 임태헌
function popup_20250627(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKUMH0043"||buyer=="KRKUMH0044"||buyer=="KRKUMH0045"||buyer=="KRKUMH0046"||buyer=="KRKUMH0047"||buyer=="KRKUMH0048"||buyer=="KRKUMH0049"||buyer=="KRKUMH0052"||buyer=="KRKUMH0053"){
		if(parseInt(check_date)<=parseInt("20250707")) {
			if (getCookie("ncook20250627") != "done20250627") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250627.htm","popup_20250627","width=620, height=540, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}

//SR25005380 MRO1 윤성찬
function popup_20250701() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHUON0001" || buyer=="KRHUME0001" || buyer=="KRHUON0006" || buyer=="KRHUON0010"){
		if(parseInt(check_date)<=parseInt("20250718")) {
			if (getCookie("ncook20250701") != "done20250701") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250701.htm","popup_20250701","width=400, height=250, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR25005733, SR25005734, SR25005735, SR25005737 MRO1
function popup_20250709() {	
	if (getCookie("ncook20250709") != "done20250709") {
		noticeWindow = window.open("/resources/html/main/notice/popup_20250709.htm","popup_20250709","width=450, height=360, scrollbars = no");
		noticeWindow.opener = self;
	}
}





//SR25005896 MRO1 김준희
function popup_20250723() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRRP-B0002" ){
		if(parseInt(check_date)<=parseInt("20250808")) {
			if (getCookie("ncook20250723") != "done20250723") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250723.htm","popup_20250723","width=500, height=450, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR25005973 MRO1 김준희
function popup_20250725() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRRP-B0003" ){
		if(parseInt(check_date)<=parseInt("20250808")) {
			if (getCookie("ncook20250725") != "done20250725") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250725.htm","popup_20250725","width=500, height=350, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR25005989 MRO1 임효정
function popup_20250726() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHANW0020"){
		if(parseInt(check_date)<=parseInt("20250804")) {
			if (getCookie("ncook20250726") != "done20250726") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250726.htm","popup_20250726","width=500, height=390, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR25006094 MRO1 조현주
function popup_20250730() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRETUD0002" || buyer=="KRAMOR0003" || buyer=="KRINNI0002" || buyer=="KRAMOR0005" || buyer=="KRESPO0003" || buyer=="KROSUL0002" || buyer=="KRAMOR0004" || buyer=="KRAMOS0006"){
		if(parseInt(check_date)<=parseInt("20250731")) {
			if (getCookie("ncook20250730") != "done20250730") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250730.htm","popup_20250730","width=510, height=540, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}




//SR25006183 MRO1 임수정
function popup_20250733() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHANW0020" ){
		if(parseInt(check_date)<=parseInt("20250805")) {
			if (getCookie("ncook20250733") != "done20250733") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250733.htm","popup_20250733","width=500, height=380, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR25006642 MRO1 배인영
function popup_20250813(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRCRYS0005"||buyer=="KRHUON0001"||buyer=="KRHUON0003"||buyer=="KRHUON0005"||buyer=="KRHUON0006"||buyer=="KRPANG0001"
			||buyer=="KRUONS0001"||buyer=="KRHUME0001"||buyer=="KRFOOD0005"||buyer=="KRHUON0011"||buyer=="KRHUON0010"){
		if(parseInt(check_date)<=parseInt("20250930")) {
			if (getCookie("ncook20250813") != "done20250813") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250813.htm","popup_20250813","width=420, height=390, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}

//SR25006898 MRO1 윤성찬
function popup_20250826(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHUON0001"||buyer=="KRHUME0001"||buyer=="KRHUON0006"||buyer=="KRHUON0010"||buyer=="KRHUON0005"||buyer=="KRFOOD0005"||buyer=="KRPANG0001"
			||buyer=="KRUONS0001"||buyer=="KRHUON0003"||buyer=="KRCRYS0005"||buyer=="KRHUON0011"||buyer=="KRHUON0001"){
		if(parseInt(check_date)<=parseInt("20250930")) {
			if (getCookie("ncook20250826") != "done20250826") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250826.htm","popup_20250826","width=450, height=300, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}

//SR25006985 SMART팀 신준호 -> SR25007269
function popup_20250904() {	
	var check_date = "<%=check_date%>";	
	if(parseInt(check_date)<=parseInt("20250906")) {
		if (getCookie("ncook20250904") != "done20250904") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250904.htm","popup_20250904","width=430, height=330, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}

//SR25007400 SMART팀 신준호
function popup_20250910() {	
	var check_date = "<%=check_date%>";		
	if(parseInt(check_date)<=parseInt("20250918")) {
		if (getCookie("ncook20250908") != "done20250908") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250910.htm","popup_20250910","width=480, height=360, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}

//SR25007517 Bio Lab사업팀 조현주
function popup_20250915() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRETUD0002"||buyer=="KRAMOR0003"||buyer=="KRINNI0002"||buyer=="KRAMOR0005"||buyer=="KRESPO0003"||buyer=="KROSUL0002"||
			buyer=="KRAMOR0004"||buyer=="KRAMOS0006"){
		if(parseInt(check_date)<=parseInt("20250930")) {
			if (getCookie("ncook20250915") != "done20250915") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250915.html","popup_20250915","width=550, height=500, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR25007588 MRO1 배수빈
function popup_20250918() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRSYSR0001"){
		if(parseInt(check_date)<=parseInt("20251001")) {
			if (getCookie("ncook20250918") != "done20250918") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250918_1.htm","popup_20250918","width=600, height=550, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}
//SR25007692 MRO1팀 임효정
function popup_20250923() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";		
	if(buyer=="KRHANW0020"){
		if(parseInt(check_date)<=parseInt("20251010")) {
			if (getCookie("ncook20250923") != "done20250923") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250923.htm","popup_20250923","width=500, height=410, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}
//SR25007709 SMART팀 신준호
function popup_20250924() {	
	var check_date = "<%=check_date%>";		
	if(parseInt(check_date)<=parseInt("20250925")) {
		if (getCookie("ncook20250924") != "done20250924") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250924.htm","popup_20250924","width=480, height=360, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}
//SR25007772 SMART팀 신준호
function popup_20250926() {	
	var check_date = "<%=check_date%>";		
	if(parseInt(check_date)<=parseInt("20251011")) {
		if (getCookie("ncook20250926") != "done20250926") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20250926.htm","popup_20250926","width=820, height=430, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}

//SR25006256 금호석유화학 임태헌 -> SR25007814
function popup_20250927(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKUMH0043"||buyer=="KRKUMH0044"||buyer=="KRKUMH0045"||buyer=="KRKUMH0046"||buyer=="KRKUMH0047"||buyer=="KRKUMH0048"||buyer=="KRKUMH0049"||buyer=="KRKUMH0052"||buyer=="KRKUMH0053"){
		if(parseInt(check_date)<=parseInt("20260630")) {
			if (getCookie("ncook20250927") != "done20250927") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250927.htm","popup_20250927","width=770, height=630, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}
//SR25007902 Bio Lab사업팀 김혜란
function popup_20250931(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRRP-B0001"||buyer=="KRRP-B0002"||buyer=="KRRP-B0003"){
		if(parseInt(check_date)<=parseInt("20251010")) {
			if (getCookie("ncook20250931") != "done20250931") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250931.htm","popup_20250931","width=480, height=410, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}

//SR25008146 Bio Lab사업팀 조현주
function popup_20251015(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRETUD0002"||buyer=="KRAMOR0003"||buyer=="KRINNI0002"||buyer=="KRAMOR0005"||buyer=="KRESPO0003"||buyer=="KROSUL0002"||buyer=="KRAMOR0004"||buyer=="KRAMOS0006"){
		if(parseInt(check_date)<=parseInt("20251031")) {
			if (getCookie("ncook20251015") != "done20251015") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20251015.htm","popup_20251015","width=600, height=480, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}

//SR25008693 MRO1 최영욱
function popup_20251104(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRLOTT0084"||buyer=="KRLOTT0085"||buyer=="KRLOTT0086"||buyer=="KRLOTT0088"||buyer=="KRLOTT0090"){
		if(parseInt(check_date)<=parseInt("20251114")) {
			if (getCookie("ncook20251104") != "done20251104") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20251104.htm","popup_20251104","width=570, height=600, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}

//SR25008871 MRO3 박경미
function popup_20251107(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRNEXE0009"){
		if(parseInt(check_date)<=parseInt("20251130")) {
			if (getCookie("ncook20251104") != "done20251104") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20251107.htm","popup_20251107","width=500, height=390, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}

//SR25009030 MRO1 윤성찬
function popup_20251114(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHUON0001"||buyer=="KRHUME0001"||buyer=="KRHUON0006"||buyer=="KRHUON0010"||buyer=="KRHUON0005"||buyer=="KRFOOD0005"||buyer=="KRPANG0001"||buyer=="KRUONS0001"
			||buyer=="KRHUON0003"||buyer=="KRCRYS0005"||buyer=="KRHUON0011"){
		if(parseInt(check_date)<=parseInt("20251128")) {
			if (getCookie("ncook20251114") != "done20251114") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20251114.htm","popup_20251114","width=440, height=340, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR25009204 IT사업그룹 전지수
function popup_20251121(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHANS0308"){
		if(parseInt(check_date)<=parseInt("20260131")) {
			if (getCookie("ncook20251121") != "done20251121") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20251121.htm","popup_20251121","width=650, height=460, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR25009316 MRO1 배수빈
function popup_20251127(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRSCK-0002"){
		if(parseInt(check_date)<=parseInt("20251205")) {
			if (getCookie("ncook20251127") != "done20251127") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20251127.htm","popup_20251127","width=390, height=320, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR25004925 SR25008098 임태헌
function popup_kkpc_guide(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKUMH0043"||buyer=="KRKUMH0044"||buyer=="KRKUMH0045"||buyer=="KRKUMH0046"||buyer=="KRKUMH0047"||buyer=="KRKUMH0048"||buyer=="KRKUMH0049"||
			buyer=="KRKUMH0050"||buyer=="KRKUMH0051"||buyer=="KRKUMH0052"||buyer=="KRKUMH0053"){
		
		if (getCookie("ncook20251015") != "done20251015") {
			noticeWindow = window.open("/resources/html/main/notice/kkpc_Guide.htm","kkpc_Guide","width=570, height=430, scrollbars = no");
			noticeWindow.opener = self;
		}
		
	}
}

//SR25009422 MRO2 송기원
function popup_20251128(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRMERT0001"||buyer=="KRMERT0002"||buyer=="KRMERT0003"||buyer=="KRMERT0004"||buyer=="KRSOLB0005"||buyer=="KRSOLB0012"||buyer=="KRSOUL0002"||
			buyer=="KRSOLB0011"||buyer=="KRSOLB0009"||buyer=="KRSOLB0013"||buyer=="KRSOLB0008"||buyer=="KRMCSO0001"||buyer=="KRCMDL0001"){
		if(parseInt(check_date)<=parseInt("20251231")) {
			if (getCookie("ncook20251128") != "done20251128") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20251128.htm","popup_20251128","width=530, height=460, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR25009437 SMART팀 신준호
function popup_20251201() {	
	var check_date = "<%=check_date%>";		
	if(parseInt(check_date)<=parseInt("20251208")) {
		if (getCookie("ncook20251201") != "done20251201") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20251201.htm","popup_20251201","width=440, height=330, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}

function showCommonCoCoVocBuyerReqCreateRegPop(st_user_id, st_dept){	
	openSearchPopup('/coco/showCommonCoCoVocBuyerReqCreateRegPop.do','?st_ds_user_id='+st_user_id+'&st_ds_dept='+st_dept,'560,540,no');    
}
function showDetailPop(value1,value2,value3,value4){	
	if(value3 =="A"){//고객공지사항
		openSearchPopup("/none/showBuyerNoNeNoticeDetailPop.do", "?st_btype="+value1+"&st_bid="+value2+"&st_buyer="+value4, "800,600,no");
	}else{//기본값 kep공지사항
		openSearchPopup("/none/showSellerNoNeNoticeDetailPop.do", "?st_btype="+value1+"&st_bid="+value2, "800,600,no");
	}
}
function showNoticeListPop(){
	openSearchPopup('/common/getCoCoNoticeListPop.do','','700,455,no');
}
function showSearchDetailPop(){
	openSearchPopup('/coco/showCommonCoCoCateSearchDetailPop.do','','600,180,no');
}
function setDetailSearch(st_description , st_specification , st_maker , st_categoty_name){ 
	
	document.forms.searchDiDetailForm.st_description.value = st_description;  
	document.forms.searchDiDetailForm.st_specification.value = st_specification;
	document.forms.searchDiDetailForm.st_maker.value = st_maker;
	document.forms.searchDiDetailForm.st_categoty_name.value = st_categoty_name;
	document.searchDiForm.st_research_flag.value = "N";
	document.searchDiDetailForm.searchTargetIDX_CATEGORY_NO.value = "";	 
	document.searchDiDetailForm.onepagerow.value = "10";
	document.searchDiDetailForm.curPage.value = "1";
	document.searchDiDetailForm.st_image_status.value = "";
	document.searchDiDetailForm.groupCategoryText.value = "";
	document.searchDiDetailForm.groupMakerName.value = "";
	document.searchDiDetailForm.searchSort.value = "";
	document.searchDiDetailForm.st_sort_change.value = "";	 
	document.searchDiDetailForm.upperId.value = "b00100000000";
	document.searchDiDetailForm.action = "/mdcm/getBuyerMdCmGoodsDiLisList.do";
	document.searchDiDetailForm.submit();
	
}

function kepEditForm(bid,btype){ 
	
	document.forms.searchCondition.BID.value = bid;
	document.forms.searchCondition.BTYPE.value = btype;
	$('#searchCondition').attr("action", "/mdam/getBuyerMdAmNoticeManageDetail.do").submit();    
} 
		
//쿠키정보가져오기
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

//VOC 페이지 이동링크 — 1:1 문의 조회 화면(buyerMcScCustomerCenter_v2 tab1)
function getCustomerCenterList(){
	location.href = "/mcsc/showBuyerMcScCustomerCenter.do?tabIndex=1";
}

//팝업 함수호출
function doPopMain(str,value1, value2, value3, value4, value5) {
	switch (str) {
		case "commonCatalogDetailPop": // 카탈로그 상세 팝업
			var src = "/common/catalogDetailPop.do?open=Y&BUYER="+value1+"&BUYER_ITEM_NO="+escape(value2)+"&CONTRACT_NO="+value3+"&CONTRACT_SEQ="+value4+"&popupCheck=N";
			openLayerPop(src,"650px","600px");
			break;
		case "buyerMdCmGoodsLisDetailPop": //상품상세팝업
			popupSel = "buyerMdCmGoodsLisDetailPop";
			if(value4 == "Y"){
				//해당 품목은 단종되었습니다.
		        var text = "<%=CommonLang.msg("MSG117") %>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
// 			var src = "/mdcm/getBuyerMdCmGoodsLisDetailPop_v2.do?stdcateg_id="+value1+"&buyer="+value2+"&buyer_tem_no="+value3;
// 			openLayerPop(src,"875px","880px");
			openSearchPopup('/mdcm/getBuyerMdCmGoodsLisDetailPop_v2.do','?stdcateg_id='+value1+'&buyer='+value2+'&buyer_tem_no='+value3,'875,880,no');
			break;
	}
}

function doActionMain(str,index){
	switch (str) {
	case "cartItem": // 최근구매상품 내 > 장바구니 담기
		saveProcess("C",index,"");
		break;
	case "my_cartItem": // 관심상품 내 > 장바구니 담기
		saveProcess("C",index,"_my");
		break;
	}
}
	

function saveProcess(flag,index,gubun){    
    var query   = "";
    
    var order_qty     = 1;
    var st_item_no   = $("#st_item_no"+gubun+index).val();
	var st_order_qty = $("#st_min_order_qty"+gubun+index).val();
	var st_agent     = $("#st_agent"+gubun+index).val();
	var st_contract_no  = $("#st_contract_no"+gubun+index).val();
	var st_contract_seq = $("#st_contract_seq"+gubun+index).val();
	var st_byit_comorg_code = $("#st_byit_comorg_code"+gubun+index).val();
	//단종여부 
	var st_product_close_flag = $("#st_product_close_flag"+gubun+index).val();
    if(st_contract_no == null || st_contract_no ==""|| st_contract_no =="PC"){
    	//계약정보 없는 품목은 등록이 불가능 합니다.
		var text = "<%=CommonLang.msg("MSG344") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
    	return;
    }
    //단종이고 단종일때 단가 비노출이면 처리 불가능.
    if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
    	//해당 품목은 단종되었습니다.
		var text = "<%=CommonLang.msg("MSG117") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
    	return;
    }else{
		query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + st_contract_no  + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "&&";
		document.forms["processForm"].st_query2.value = query;
		document.forms["processForm"].st_use_flag.value = flag;
		document.forms["processForm"].st_dup_add_flag.value = "<%=dup_add_posb_yn%>";
		
		kepAjaxFormCall("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm","CsaveProcess");
    }
}

function goCart(){
	closePopText1();
	location.href = "<%=p060000036%>";
}
function getBuyerCatalogDisplay(stdcateg_id,stdcatlg_id,buyer,org_buyer_item_no,category_no,key_flag,cata,image_dir,image_file, product_close_flag,description){
	//최근본상품저장
	if(product_close_flag == "Y"){
    	//해당 품목은 단종되었습니다.
<%--         alert(" <%=CommonLang.msg("MSG117") %>     "); --%>
        var text = "<%=CommonLang.msg("MSG117") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	var searchMyItemList = getKePCookie("searchMyItemList"); 
	searchMyItemList = stdcateg_id+"@@"+stdcatlg_id+"@@"+buyer+"@@"+org_buyer_item_no+"@@"+category_no+"@@"+key_flag+"@@"+cata+"@@"+image_dir+"@@"+image_file+"@@"+description+"&&"+searchMyItemList;
	setKePCookie("searchMyItemList", searchMyItemList ,1);
    var key_flag     = key_flag.substr(0,2);
    if(key_flag == "MULTI_AGENT"){
    
        var st_key_flag = "Y";
    }else{
        var st_key_flag = "N";
    }    
    
	document.locationForm.stdcateg_id.value = stdcateg_id; // 표준카테고리ID
	document.locationForm.stdcatlg_id.value = stdcatlg_id; // 표준카탈로그ID
	document.locationForm.buyer.value = buyer;
	document.locationForm.com_code.value = buyer;
	document.locationForm.buyer_tem_no.value = org_buyer_item_no;
	document.locationForm.category_no.value = category_no; // 카테고리번호
	document.locationForm.key_flag.value = st_key_flag;
	document.locationForm.cata.value = cata;

	$('#locationForm').attr("action", "/mdcm/getBuyerMdCmGoodsLisDetail.do").submit();   
}
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7){
	if(popupSel == "buyerMdCmGoodsLisDetailPop"){
		location.href=value1;
	}
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	
	var sMsg = response.msg.MSG;  
	
    if(sMsg == "CREATE_OK"){
    	
        if(pMethod == "CsaveProcess")
        {
        	var text = "<%=CommonLang.msg("MSG695")%>";//장바구니에 저장하였습니다. 장바구니 화면으로 이동하시겠습니까?
        	var but1textC = "<%=CommonLang.get("HTITLE1121")%>"; //쇼핑 계속하기
        	var but2textC = "<%=CommonLang.get("HTITLE1122")%>"; //장바구니 가기
        	var but1funcC = "javascript:closePopText1(); return false;";
        	var but2funcC = "javascript:goCart(); return false;";
        	var but1widthC = "120px";
        	var but2widthC = "120px";
        	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
        	
       }
      }else{
    	  
         if(pMethod == "CsaveProcess")
          {
        	 //품목코드 () 은 이미 장바구니에 저장된 항목입니다.
<%--             alert("<%=CommonLang.msg("MSG352") %>" + sMsg + "<%=CommonLang.msg("MSG353") %>  "); --%>
            var text = "<%=CommonLang.msg("MSG352") %>" + sMsg + "<%=CommonLang.msg("MSG353") %>";
			openLayerPopText2(text,but1text,but1func,but1width);
          }
      }  
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	
	if (pMethod == "CsaveProcess"){ 
		//장바구니담기 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
		 var text = "<%=CommonLang.msg("MSG26") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	 
	
} 
</script>

<div id="wrapper">
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%-- <%@ include file="/WEB-INF/views/common/include/buyerHeader_v2.jsp" %>    --%>
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerHeader_v2"/>
<c:param name="part" value="buyerHeader_v2"/>
</c:import>
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<div id="container2">
<%-- <c:import charEncoding="utf-8" url="/menu/buyerMainMenu.do"> --%>
<%-- <c:param name="page" value="buyerMainMenu"/> --%>
<%-- <c:param name="part" value="b00000000000"/> --%>
<%-- </c:import> --%>
        <div class="containerBox_Main"   >
    <div class="container_Main pt35" >
      <div class="BuyerTodo" >
        <div class="Hello"><span>${sessionInfo.userNameLoc} <%=CommonLang.get("HTITLE1003") %><!-- 고객님 --></span><br/> <%=CommonLang.msg("MSG602") %><!-- 안녕하세요! --> <p><%=CommonLang.get("HTITLE930") %><!-- 최종접속 --> ${sessionInfo.lastLoginDate}</p></div>
        <div class="RecentMonth"><%=CommonLang.get("HTITLE1503") %><!-- 최근 1개월 기준 --></div>
        <div class="TodoView">
       			<% if ("Y".equals(QA_FLAG)) {%>
		        <div class="TodoViewBox"><a class="TodoViewLink" href="/mprq/showBuyerMpRqQuotaList_v2.do?menuId=br00102000000&tabIndex=3" /><img src="/resources/imgs/buyerTodo01.png" /><p><%=CommonUtil.bnvl(_statusCountData.get("AGMT_CNT"))%></p> <%=CommonLang.get("HTITLE1004") %> <!-- 견적합의 --></a></div>
		        <%} %>
		        <% if ("Y".equals(GR_FLAG)) {%>
		        <div class="TodoViewBox"><a class="TodoViewLink" href="/wmgr/getBuyerWmGrWarehousingLis_v2.do?menuId=br00301000000&tabIndex=2" /><img src="/resources/imgs/buyerTodo02.png" /><p><%=CommonUtil.bnvl(_statusCountData.get("GR_CNT"))%></p> <%=CommonLang.get("HTITLE269") %> <!-- 입고등록 --></a> </div>
        		<%} %>
        		<% if ("Y".equals(PASS_FLAG)) { %>
        			<div class="TodoViewBox"><a class="TodoViewLink" href="/mdap/showBuyerNewPassList_v2.do?menuId=br00401000000&tabIndex=2" /><img src="/resources/imgs/buyerTodo03.png" /><p><%=CommonUtil.bnvl(_statusCountData.get("RECV_CNT"))%></p><%=CommonLang.get("HTITLE310") %> <!-- 결재 --></a></div>
        		<%}%>
        		<% if ("Y".equals(PO_FLAG)) { %>  
		            <div class="TodoViewBox"><a class="TodoViewLink" href="/mppo/showBuyerMpPoOrderReq_v2.do?menuId=br00203000000&tabIndex=2" /><img src="/resources/imgs/buyerTodo04.png" /><p><%=CommonUtil.bnvl(_statusCountData.get("PO_CNT"))%></p> <%=CommonLang.get("HTITLE194") %> <!-- 주문요청 --></a></div>
		        <%}%>
        </div>      
      </div> <!--/BuyerTodo -->
	  <div class="OrderProduct">
        <div class="TodoBox01">
          <div class="TodoBoxTit"> <%=CommonLang.get("HTITLE524") %><!-- 주문진행현황 --></div>
          <div class="RecentMonth"><%=CommonLang.get("HTITLE1503") %><!-- 최근 1개월 기준 --></div>
          <div class="StatusContainer">
            <a class="StatusBox" href="/mpso/showBuyerMpSoOrderProgress.do?menuId=br00201000000&tabIndex=1&selStatus=PX10"><span><%=CommonUtil.bnvl(_statusCountData.get("PR_1_CNT"))%></span><br><%=CommonLang.get("HTITLE1005") %><!-- 주문완료 --></a>
            <div class="Arrow"><img src="/resources/imgs/arrow_right.png" /></div>
            <a class="StatusBox" href="/mpso/showBuyerMpSoOrderProgress.do?menuId=br00201000000&tabIndex=1&selStatus=PX20"><span><%=CommonUtil.bnvl(_statusCountData.get("PR_2_CNT"))%></span><br><%=CommonLang.get("HTITLE1006") %><!-- 상품준비중 --></a>
            <div class="Arrow"><img src="/resources/imgs/arrow_right.png" /></div>
            <a class="StatusBox" href="/mpso/showBuyerMpSoOrderProgress.do?menuId=br00201000000&tabIndex=1&selStatus=PX30,PX40,PX50,PX60"><span><%=CommonUtil.bnvl(_statusCountData.get("PR_3_CNT"))%></span><br><%=CommonLang.get("HTITLE1007") %><!-- 배송중 --></a>
            <div class="Arrow"><img src="/resources/imgs/arrow_right.png" /></div>
            <a class="StatusBox" href="/mpso/showBuyerMpSoOrderProgress.do?menuId=br00201000000&tabIndex=1&selStatus=PX70"><span><%=CommonUtil.bnvl(_statusCountData.get("PR_4_CNT"))%></span><br><%=CommonLang.get("HTITLE1008") %><!-- 배송완료 --></a>
          </div>  
        </div>          
        <div class="TodoBox02">
          <div class="TodoBoxTit"><%=CommonLang.get("HTITLE1009") %> <!-- 신규상품 진행현황 --></div>
          <div class="RecentMonth"><%=CommonLang.get("HTITLE1503") %><!-- 최근 1개월 기준 --></div>
          <div class="StatusContainer">
            <a class="StatusBox" href="/mprq/showBuyerMpRqQuotaList_v2.do?menuId=br00102000000&tabIndex=1&selStatus=RQ10"><span><%=CommonUtil.bnvl(_statusCountData.get("SOUR_CNT"))%></span><br><%=CommonLang.get("HTITLE1010") %><!-- 견적요청 --></a>
            <div class="Arrow"><img src="/resources/imgs/arrow_right.png" /></div>
            <a class="StatusBox" href="/mprq/showBuyerMpRqQuotaList_v2.do?menuId=br00102000000&tabIndex=1&selStatus=RQ05"><span><%=CommonUtil.bnvl(_statusCountData.get("SOUR_ING_CNT"))%></span><br><%=CommonLang.get("HTITLE154") %><!-- 견적진행중 --></a>
            <div class="Arrow"><img src="/resources/imgs/arrow_right.png" /></div>
            <a class="StatusBox" href="/mprq/showBuyerMpRqQuotaList_v2.do?menuId=br00102000000&tabIndex=1&selStatus=RQ04"><span><%=CommonUtil.bnvl(_statusCountData.get("SOUR_END_CNT"))%></span><br><%=CommonLang.get("HTITLE1011") %><!-- 견적완료 --></a>
          </div>  
        </div>      
      </div><!--/OrderProduct -->        
	  <div class="CustomerCenter"> 
        <div class="ServicTit"><%=CommonLang.get("HTITLE1012")%><!-- 고객지원 --></div>
        <div class="Service01">
          <div class="ServicTit01Box"><%=CommonLang.get("HTITLE949") %><!-- 운영 --></div>
          <% if (_vocUserData2 != null){ %>
          <div class="ServicTitTxt"><%=CommonUtil.nvl(_vocUserData2.get("USER_NAME_LOC"))%> <%=CommonUtil.nvl(_vocUserData2.get("POSITION_NAME"))%>&nbsp;  <button class="ButSmall_Outline" onclick="location.href='/mcsc/showBuyerMcScInquiryWrite.do?st_ds_user_id=<%=CommonUtil.nvl(_vocUserData2.get("USER_ID"))%>&st_ds_dept=<%=CommonUtil.nvl(_vocUserData2.get("DEPARTMENT"))%>'; return false;"><%=CommonLang.get("HTITLE970") %><!-- 요청 --></button> <button class="ButSmall_Outline" onclick="javascript:getCustomerCenterList();"><%=CommonLang.get("HTITLE923") %><!-- 처리결과 --></button><br/><p><a href="mailto:<%=CommonUtil.nvl(_vocUserData2.get("EMAIL"))%>"><%=CommonUtil.nvl(_vocUserData2.get("EMAIL"))%></a> <%=CommonUtil.nvl(_vocUserData2.get("PHONE_NUMBER"))%></p></div>
           <%} %>
        </div>
        <div class="Service02">
          <div class="ServicTit02Box"><%=CommonLang.get("HTITLE950") %><!-- 영업 --></div>
          <% if (_vocUserData1 != null){ %>
          <div class="ServicTitTxt"><%=CommonUtil.nvl(_vocUserData1.get("USER_NAME_LOC"))%> <%=CommonUtil.nvl(_vocUserData1.get("POSITION_NAME"))%>&nbsp;   <button class="ButSmall_Outline" onclick="location.href='/mcsc/showBuyerMcScInquiryWrite.do?st_ds_user_id=<%=CommonUtil.nvl(_vocUserData1.get("USER_ID"))%>&st_ds_dept=<%=CommonUtil.nvl(_vocUserData1.get("DEPARTMENT"))%>'; return false;"><%=CommonLang.get("HTITLE970") %><!-- 요청 --></button> <button class="ButSmall_Outline" onclick="javascript:getCustomerCenterList();"><%=CommonLang.get("HTITLE923") %><!-- 처리결과 --></button><br/><p><a href="mailto:<%=CommonUtil.nvl(_vocUserData1.get("EMAIL"))%>"><%=CommonUtil.nvl(_vocUserData1.get("EMAIL"))%></a> <%=CommonUtil.nvl(_vocUserData1.get("PHONE_NUMBER"))%></p></div>
          <%} %>
        </div>
      </div><!--/CustomerCenter -->       
<!-- 	  <div class="BeltBanner"><a href="#"><img src="/resources/imgs/Buyer_MBeltBanner.png" /></a></div> -->
      <%if(budget_flag.equals("Y")){ %>
      	<%if(_bdgtAmtList.size() != 0 && _bdgtAmtList != null) {%>
	      <div class="BudgetCheck">
	        <div class="BudgetTit"><%=CommonLang.get("HTITLE431") %><!-- 예산조회 -->
<%-- 	        <%if(ADMIN_FLAG.equals("Y")) {%>  --%>
<%-- 	        	<button class="ButSmall_Outline_RightIcon" style="border:none;" onclick="location.href='/mdam/showBuyerMdAmBudgetCompilation_v2.do?menuId=br00506000000&tabIndex=2'; return false;"><%=CommonLang.get("HTITLE1013") %><!-- 전체보기 --></button>  --%>
	        	<button class="ButSmall_Outline_RightIcon" style="border:none;" onclick="javaScript:openSearchPopup('/home/showBuyerHomeDeptBudgetPop.do', '', '1260,645,no'); return false;"><%=CommonLang.get("HTITLE1013") %><!-- 전체보기 --></button> 
	        	
<%-- 	        <%} %> --%>
	        </div>
			<div class="BudgetList">
          		<%for(int i = 0; i<_bdgtAmtList.size(); i++){ 
          			Map<String,String> rowData = _bdgtAmtList.get(i);
          		%>
	          		<div class="BudgetListBox"><p><%=CommonUtil.nvl(rowData.get("ACCOUNT_TEXT"))%></p><p><%=CommonUtil.formatNumber(rowData.get("PLAN_AMT"),true,0,3)%><%=CommonLang.get("HTITLE660") %><!-- 원 --></p><p><%=CommonUtil.formatNumber(rowData.get("TEMP_AMT"),true,0,3)%><%=CommonLang.get("HTITLE1014") %><!-- 원 남음 --></p></div>
	        	<%} %>
			</div>
	      </div><!--/BudgetCheck -->
	    <%} %>
      <%} %>      
	  <div class="BoardMain01">
        <div class="BoardBox01" style="height:285px; ">
          <div class="BoardBoxTit"> <%=CommonLang.get("HTITLE1094")%><!--최근구매상품--> <button class="ButSmall_Outline_RightIcon" onclick="location.href='/mdcm/getBuyerMdCmHistoryGoodsSearchList.do'; return false;"><%=CommonLang.get("HTITLE1013") %><!-- 전체보기 --></button></div>
          <div class="BoardContainer">
          <%if(_historyGoodsList.size() != 0 && _historyGoodsList != null) {%>
          	<%for(int i = 0; i<_historyGoodsList.size(); i++){ 
          		Map<String,String> rowData = _historyGoodsList.get(i);
          	%>
          	
            <div class="BoardList">
            <input type="hidden" name="st_item_no" id="st_item_no<%=i %>" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>">
            <input type="hidden" name="st_min_order_qty" id="st_min_order_qty<%=i %>" value="<%=CommonUtil.nvl(String.valueOf(rowData.get("MIN_ORDER_QTY")))%>">
            <input type="hidden" name="st_contract_no" id="st_contract_no<%=i %>" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
            <input type="hidden" name="st_contract_seq" id="st_contract_seq<%=i %>" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
            <input type="hidden" name="st_byit_comorg_code" id="st_byit_comorg_code<%=i %>" value="<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>">
            <input type="hidden" name="st_agent" id="st_agent<%=i %>" value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
              <span><%=CommonUtil.bnvl(rowData.get("PR_SEQ"))%><%=CommonLang.get("HTITLE1027") %><!-- 회 구매 --></span><p class="Code"><a href="javascript:doPopMain('buyerMdCmGoodsLisDetailPop','<%=CommonUtil.nvl(rowData.get("STDCATEG_ID"))%>','<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>');"><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></a></p><p class="TxtLink"><a href="javascript:getBuyerCatalogDisplay('<%=CommonUtil.nvl(rowData.get("STDCATEG_ID"))%>','<%=CommonUtil.nvl(rowData.get("STDCATLG_ID"))%>','<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CATEG_ID"))%>', '','ITEM','<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>', '<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>', '<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>','<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>');"><%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%></a></p>
              <div class="ImgLink"><div class="ImgLink02" onclick="javascript:doActionMain('cartItem','<%=i%>')"><%=CommonLang.get("HTITLE161") %><!-- 장바구니 --></div></div>
            </div>
            <%} %>
          <%}else{ %>
          	<div class="NoData mt50"><img src="/resources/imgs/Icon_Warning01.png" /><br/><%=CommonLang.msg("MSG645")%><!--최근구매상품이 없습니다.--></div>
          <%} %>
          </div>  
        </div>          
        <div class="BoardBox02" style="height:285px; ">
          <div class="BoardBoxTit"><%=CommonLang.get("HTITLE1016") %> <!-- 관심상품 --> <button class="ButSmall_Outline_RightIcon" onclick="location.href='/mdcm/getBuyerMdCmMyGoodsSearchList.do'; return false;"><%=CommonLang.get("HTITLE1013") %><!-- 전체보기 --></button></div>
          <div class="BoardContainer">
          <%if(_myGoodsList.size() != 0 && _myGoodsList != null) {%>
          	<%for(int i = 0; i<_myGoodsList.size(); i++){ 
          		Map<String,String> rowData = _myGoodsList.get(i);
          	%>
            <div class="BoardList">
            <input type="hidden" name="st_item_no" id="st_item_no_my<%=i %>" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>">
            <input type="hidden" name="st_min_order_qty" id="st_min_order_qty_my<%=i %>" value="<%=CommonUtil.nvl(String.valueOf(rowData.get("MIN_ORDER_QTY")))%>">
            <input type="hidden" name="st_contract_no" id="st_contract_no_my<%=i %>" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
            <input type="hidden" name="st_contract_seq" id="st_contract_seq_my<%=i %>" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
            <input type="hidden" name="st_byit_comorg_code" id="st_byit_comorg_code_my<%=i %>" value="<%=CommonUtil.nvl(rowData.get("BYCA_COMORG_CODE"))%>">
            <input type="hidden" name="st_product_close_flag" id="st_product_close_flag_my<%=i %>" value="<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>">
            <input type="hidden" name="st_agent" id="st_agent_my<%=i %>" value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
              <p class="Code"><a href="javascript:doPopMain('buyerMdCmGoodsLisDetailPop','<%=CommonUtil.nvl(rowData.get("STDCATEG_ID"))%>','<%=CommonUtil.nvl(rowData.get("BYCA_COMORG_CODE"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>');"><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></a></p><p class="TxtLink"><a href="javascript:getBuyerCatalogDisplay('<%=CommonUtil.nvl(rowData.get("STDCATEG_ID"))%>','<%=CommonUtil.nvl(rowData.get("STDCATLG_ID"))%>','<%=CommonUtil.nvl(rowData.get("BYCA_COMORG_CODE"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CATEG_ID"))%>', '','ITEM','<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>', '<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>', '<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>','<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>');"><%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%></a></p>
              <div class="ImgLink"><div class="ImgLink02" onclick="javascript:doActionMain('my_cartItem','<%=i%>')"><%=CommonLang.get("HTITLE161") %><!-- 장바구니 --></div></div>
            </div>
            <%} %>
          <%}else{ %>
          	<div class="NoData mt50"><img src="/resources/imgs/Icon_Warning01.png" /><br/><%=CommonLang.msg("MSG615") %><!-- 관심상품이 없습니다. --></div>
          <%} %>
          </div>  
        </div>  
      </div> <!--/Board -->   
	  <div class="BoardMain02 pb80 ">
        <div class="BoardBox03 " style="height: 225px;">
          <div class="BoardBoxTit"><%=CommonLang.get("HTITLE730") %> <!-- 공지사항 --> <button class="ButSmall_Outline_RightIcon" onclick="location.href='/mcsc/showBuyerMcScCustomerCenter.do?tabIndex=2&menuId=br00602000000'; return false;"><%=CommonLang.get("HTITLE1013") %><!-- 전체보기 --></button></div>
          <div class="BoardContainer">
<!--           <img src="/resources/imgs/seller_new.png" /> -->
          	<% 
                		Map<String,String> _ntBoardData = null;
                		if (_ntBoard == null || _ntBoard.size() == 0){%>
          	<div class="NoData mt50"><img src="/resources/imgs/Icon_Warning01.png" /><br/><%=CommonLang.msg("MSG616") %><!-- 공지사항이 없습니다. --></div>
            <%    		}else{
                			for (int i=0; i<_ntBoard.size(); i++){
                				if(i == 3)
                					break;
                				_ntBoardData = _ntBoard.get(i);  
             %>
            <div class="BoardList"><p class="TxtLink"><a href="javascript:location.href='/mcsc/showBuyerMcScCustomerCenter.do?tabIndex=2&menuId=br00602000000';"><%=CommonUtil.nvl(_ntBoardData.get("SUBJECT"))%></a></p><p class="Date"><%=CommonUtil.nvl(_ntBoardData.get("REG_DATE_DIS"))%></p></div>
          
          			<% }
                    		}
                    %>
          </div>  
        </div>          
        <div class="BoardBox03" style="height: 225px;float:right;">
          <div class="BoardBoxTit"> <%=CommonLang.get("HTITLE1463") %><!-- 내부 공지사항 --> <button class="ButSmall_Outline_RightIcon" onclick="location.href='/mcsc/showBuyerMcScCustomerCenter.do?tabIndex=3&menuId=br00602000000'; return false;"><%=CommonLang.get("HTITLE1013") %><!-- 전체보기 --></button></div>
          <div class="BoardContainer">
          	<%
          		Map<String,String> _internalNtBoardData = null;
          		if (_internalNtBoard == null || _internalNtBoard.size() == 0){%>
          	<div class="NoData mt50"><img src="/resources/imgs/Icon_Warning01.png" /><br/><%=CommonLang.msg("MSG616") %><!-- 공지사항이 없습니다. --></div>
            <%    		}else{
                			for (int i=0; i<_internalNtBoard.size(); i++){
                				if(i == 3)
                					break;
                				_internalNtBoardData = _internalNtBoard.get(i);
             %>
            <div class="BoardList"><p class="TxtLink"><a href="javascript:location.href='/mcsc/showBuyerMcScCustomerCenter.do?tabIndex=3&menuId=br00602000000';"><%=CommonUtil.nvl(_internalNtBoardData.get("SUBJECT"))%></a></p><p class="Date"><%=CommonUtil.nvl(_internalNtBoardData.get("REG_DATE_DIS"))%></p></div>
          			<% }
                    		}
                    %>
          </div>
        </div>  
      </div> <!--/Board -->  
    </div><!--/container_Main -->
  </div><!--/containerBox_Main -->
<form name="processForm" id="processForm" method="post">
			<input type="hidden" name="st_query2" id="st_query2" value="" /> 
			<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
			<input type="hidden" name="st_dup_add_flag" id="st_dup_add_flag" value="" />
</form> 
<form name="searchCondition" id="searchCondition" method="post">
		<input type="hidden" id="st_user_id" name="st_user_id"  value="<%=sessionUserId%>">
			<input type="hidden" id="st_byca_comorg_code" name="st_byca_comorg_code"  value="<%=sessionBycaComorgCode%>">
			<input type="hidden" name="curPage" id="curPage" value="1" />
			<input type="hidden" id="upperId"  name="upperId" value="b00000000000">   
			<input type="hidden" name="BID" id="BID" value="" />
			<input type="hidden" name="BTYPE" id="BTYPE" value="" />  
</form> 
 
<form name="searchDiDetailForm"  id="searchDiDetailForm"method="post">
       <input type="hidden" name="onepagerow" value="" /> 
       <input type="hidden" name="curPage" value="" /> 
       <input type="hidden" name="st_image_status" value="" /> 
       <input type="hidden" name="st_sort_change" value="" /> 
<input type="hidden" name="upperId" id="upperId"  value="b00100000000" /> 
<input type="hidden" name="groupCategoryText" id="groupCategoryText" />
<input type="hidden" name="groupMakerName" id="groupMakerName" />
<input type="hidden" name="searchSort" id="searchSort"  /> 
<input type="hidden" name="searchTarget" id="searchTarget"  value="ALL" />  
<input type="hidden"  name="searchTargetIDX_CATEGORY_NO"  id="searchTargetIDX_CATEGORY_NO"  value=""   /> <!--   IDX_CATEGORY_NO  로 바뀌면, 카테고리번호에 해당하는 정보만 가져올 수 있을 듯 합니다. -->
<input type="hidden"  name="searchTerm"  id="searchTerm"  /> 
<input type="hidden"  name="st_description"  id="st_description"  /> 
<input type="hidden"  name="st_specification"  id="st_specification"  /> 
<input type="hidden"  name="st_maker"  id="st_maker"  /> 
<input type="hidden"  name="st_categoty_name"  id="st_categoty_name"  /> 
<input type="hidden"  name="searchMode"  id="searchMode" value="detail"  /> 
</form>
<form name="locationForm" id="locationForm" method="post">	
	<input type="hidden" name="stdcateg_id" id="stdcateg_id" value="" />
	<input type="hidden" name="stdcatlg_id" id="stdcatlg_id" value="" />
	<input type="hidden" name="buyer" id="buyer" value="" />
	<input type="hidden" name="com_code" id="com_code" value="" />
	<input type="hidden" name="buyer_tem_no" id="buyer_tem_no" value="" />
	<input type="hidden" name="category_no" id="category_no" value="" />
	<input type="hidden" name="key_flag" id="key_flag" value="" />
	<input type="hidden" name="cata" id="cata" value="" />
</form>
<form name="locationForm2" id="locationForm2" method="post">	
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	 
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> 	
	
	<input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no" value="">
	<input type="hidden" name="st_description" id="st_description" value="">
	<input type="hidden" name="st_specification" id="st_specification" value="">
	<input type="hidden" name="st_maker_name" id="st_maker_name" value="">		
</form>
<!-----------------------------------------------------------------------------------------------footer------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>
<!-----------------------------------------------------------------------------------------------footer------------------------------------------------------------------------------------------------------->
    
</div> 
</body>
</html>