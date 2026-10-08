<%@page import="com.diquest.ir.util.common.DateUtil"%>
<%@page import="com.ctc.wstx.util.DataUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../common/include/head.jspf"  %>
</head>
<%  
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _buyerBoard = (List<Map<String,String>>) request.getAttribute("buyerBoard"); // 조회된 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _ntBoard = (List<Map<String,String>>) request.getAttribute("ntBoard"); // 조회된 결과
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
	
	String currentDate = DateTimeUtil.getFormatString("yyyyMMdd");
	String currentYear = currentDate.substring(0,4);
	String currentMonth = currentDate.substring(4,6);
	String currentDay = currentDate.substring(6,8);
	String check_date					= currentDate;
	
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
	if (sessionInfo != null){ 
		sessionUserName =  CommonUtil.nvl((String)sessionInfo.getComNameLoc());  
		sessionUserId =  CommonUtil.nvl((String)sessionInfo.getUserId());  
		sessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode());  
		sessionBycaComorgCode =  CommonUtil.nvl((String)sessionInfo.getBycaComorgCode());
		sessionRole =  CommonUtil.nvl((String)sessionInfo.getRole());
		budget_flag =  CommonUtil.nvl((String)sessionInfo.getBudgetFlag());
		sessionUserAuth = CommonUtil.nvl((String)sessionInfo.getUserAuth());
	}  
	
	// 발주대상 접근권한 제어
	String PO_FLAG = "Y";
	
	if(sessionRole.indexOf("U")>-1 || sessionRole.indexOf("G")>-1){
		PO_FLAG = "N";
	}
			
	 //SLOGIC-BEGIN(P06-0000036)
	String defaultUrl = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
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
    
    //SLOGIC-BEGIN(P15-0000003) - 고객사 다수 들어올 경우
    boolean p150000003 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000003"); //VMI 고객사
    boolean p150000004 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000004"); //2022년 12월09일까지 SR22011413
    boolean p150000005 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000005"); //2023년 1월26일까지 SR23000181
    boolean p150000006 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000006"); //2022년 5월16일까지 SR22004483
    boolean p150000007 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000007"); //2023년 6월06일까지 SR23005175
    boolean p150000008 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000008"); //2023년 7월16일까지 SR23006472
    boolean p150000009 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000009"); //2023년 7월14일까지 SR23006572
    boolean p150000010 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000010"); //2023년 8월15일까지 SR23007557
    boolean p150000011 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000011"); //2023년 10월06일까지 SR23008610
    boolean p150000012 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000012"); //2023년 10월06일까지 SR23008898
    boolean p150000013 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000013"); //2024년 02월14일까지 SR24001011, SR24001251    
    boolean p150000014 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000014"); //2024년 08월20일까지 SR24006723, SR24006893
	boolean p150000015 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000015"); //2024년 09월20일까지 SR24007687
	boolean p150000016 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000016"); //2025년 02월07일까지 SR25000529
	boolean p150000018 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000018"); //2025년 12월31일까지 SR25003547
	boolean p150000019 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000019"); //2025년 07월11일까지 SR25005733, SR25005734, SR25005735, SR25005737
	boolean p150000020 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000020"); //2026년 07월10일까지 SR26005698
	boolean p150000021 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000021"); //리뉴얼 공지 팝업 대상 고객사
	boolean p150000022 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P15-0000022"); //리뉴얼 공지 팝업 제외 고객사
	//SLOGIC-END
	
%>




<!-- 리뉴얼 관련 공지 팝업 START -->
<style>
	#renewalPopup {position: fixed;inset: 0;display: none;align-items: center;justify-content: center;padding: 20px;background: rgba(0, 0, 0, 0.65);z-index: 99999; font-family: 'Pretendard', sans-serif;}
	#renewalPopup.show {display: flex;}
	.renewal-popup-box {position: relative;width: 100%;max-width:650px;border-radius:18px;overflow: hidden;box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);}
	.renewal-visual {width: 100%; padding:50px 0 30px 0; background: linear-gradient(85.36deg, #823EEE -42.41%, #2172EC 111.92%);color: #fff; align-items: center;justify-content: center;text-align: center;}
	.renewal-visual h2 {margin: 0;font-size:38px;line-height: 1.3;}
	.renewal-visual .txt { margin-top:15px; font-size:20px; font-weight:300; color:#fff; letter-spacing:-0.2px; line-height: 26px;}
	.renewal-visual .date{ margin:0 auto; margin-top:10px; width:390px; padding:13px 10px;font-size:22px;line-height:21px;font-weight:700;text-align:center;border-radius:50px; letter-spacing:0px;background-color:#303ec0; color:#fff;}
	.renewal-content {padding: 28px 24px 20px;text-align: center;background: #fff;}
	.renewal-content p {margin: 0;font-size: 16px;line-height: 1.6;color: #555;}
	.renewal-content .manual{ margin:0 auto; margin-top:10px; width:300px; height: 58px;line-height:58px;font-size:20px;font-weight:700;text-align:center;border-radius:50px; letter-spacing:-0.5px;background-color:#dfeaff; color:#24252B; cursor: pointer;}
	.renewal-close-x {position: absolute;top:20px;right:20px;width:50px;height:50px;border: 0;border-radius: 50%;background: rgba(0, 0, 0, 0.5);color: #fff;font-size: 22px;cursor: pointer;z-index: 2;}
	.renewal-footer {display: flex;justify-content: space-between;align-items: center;gap: 12px;padding: 15px 20px 15px;border-top: 1px solid #eee; background: #fff;}
	.renewal-check {display: inline-flex;align-items: center;gap: 8px;font-size: 14px;color: #333;cursor: pointer;user-select: none;}
	.renewal-check input {margin: 0;width: 18px;height: 18px;cursor: pointer;}
	.renewal-close-btn {min-width: 100px;height:35px;border: 0;border-radius: 10px;background: #272e47;color: #fff;font-size: 15px;cursor: pointer;}
	.renewal-close-btn:hover {opacity: 0.92;}
</style>

<!-- 팝업 -->
<div style='display:<%=p150000021 == false && p150000022 == true ? "none" : "block" %>'>
	<div id="renewalPopup">
		<div class="renewal-popup-box" role="dialog" aria-modal="true" aria-labelledby="popupTitle">
			<button type="button" class="renewal-close-x" id="popupCloseX" aria-label="팝업 닫기">×</button>
			
			<div class="renewal-visual">
	        	<h2 id="popupTitle">사이트 리뉴얼 오픈</h2>
	        
	        	<div class="txt">더 편리해진 구매 환경으로 찾아갑니다. <br>귀사가 이용 중인 구매 사이트가 아래 일정으로 새롭게 오픈됩니다.<br><b>※ 오픈 일정은 KeP 내부 사정에 따라 변경될 수 있습니다.</b></div>
	        	<div class="date" >오픈예정일 2026년 09월 01일(화)</div>
	        	<img src="/resources/html/main/notice/RenewalPopup.png" style="width:320px; margin-top:20px;" />
	        </div>
	        
	        <div class="renewal-content">
	        	<p>자세한 이용 방법은 사용자 매뉴얼을 통해 확인하실 수 있습니다.</p>
	        	<div class="manual" onclick="window.open('/resources/html/main/notice/고객사매뉴얼_통합_v3.1.pdf', '_blank');" ><img src="/resources/html/main/notice/RenewalPopup_down.png" style="width:30px; vertical-align: middle; margin-right: 10px;"> 매뉴얼 다운로드</div>
	        </div>
	        
	        <div class="renewal-footer">
	        	<label class="renewal-check">
	        		<input type="checkbox" id="hideToday">
	        			<span>오늘 하루 보지 않기</span>
	        	</label>
	        	
	        	<button type="button" class="renewal-close-btn" id="popupCloseBtn">닫기</button>
	        </div>
		</div>
	</div>
</div>

<script>
	(function () {
		const popup = document.getElementById('renewalPopup');
		const closeX = document.getElementById('popupCloseX');
		const closeBtn = document.getElementById('popupCloseBtn');
		const hideToday = document.getElementById('hideToday');
		
		const STORAGE_KEY = 'renewalPopupHideDate';
		
		function getToday() {
			const d = new Date();
			const yyyy = d.getFullYear();
			const mm = String(d.getMonth() + 1).padStart(2, '0');
			const dd = String(d.getDate()).padStart(2, '0');
			
			return `${yyyy}-${mm}-${dd}`;
		}
		
		function openPopup() {
			popup.classList.add('show');
			document.body.style.overflow = 'hidden';
		}
		
		function closePopup() {
			if (hideToday.checked) {
				localStorage.setItem(STORAGE_KEY, getToday());
			}
			
			popup.classList.remove('show');
			document.body.style.overflow = '';
		}
		
		// 오늘 하루 보지 않기 확인
		const hiddenDate = localStorage.getItem(STORAGE_KEY);
		if (hiddenDate !== getToday()) {
			openPopup();
		}
		
		// 닫기 버튼 / X 버튼으로만 닫기
		closeX.addEventListener('click', closePopup);
		closeBtn.addEventListener('click', closePopup);
		
		// ESC 키 닫기
		document.addEventListener('keydown', function (e) {
			if (e.key === 'Escape' && popup.classList.contains('show')) {
				closePopup();
			}
		});
	})();
</script>
<!-- 리뉴얼 관련 팝업 END -->






<body onload="kep_onload_view();">

<script type="text/javascript">

 
//최초 화면 함수 
function kep_onload_view(){  
	$('#top_cart_cnt').html($('#main_cart_cnt').val());
<%if(p150000003 == true){%>
	//81개 고객사 공지 팝업 SR20001556  에스원 보안공사 고객사 대상 VMI운영안내 팝업 등록 요청의 건 신수옥
	popup_20200902();//2020년 9월 29일까지
	popup_20200925();//2020년 9월 29일까지 SR20007518
	popup_20201230();//2021년 1월 6일까지 SR20009968
	popup_20210201();//2021년 2월 18일까지 SR21000979
	popup_20210226();//2021년 3월 5일까지 SR21001806
	popup_20210322();//2021년 4월 5일까지 SR21002508
	popup_20210621();//2021년 6월 23일까지 SR21005182
	popup_20210630();//2021년 7월 20일까지 SR21005431
	popup_20210631();//2021년 7월 20일까지 SR21005431
	popup_20210913();//2021년 9월 27일까지 SR21007541
	popup_20211203();//2022년 1월 10일까지 SR21009587
	popup_20211213();//2021년 12월 17일까지 SR21009798
	popup_20211229();//2022년 1월 3일까지 SR21010088
	popup_20220125();//2022년 2월 3일까지 SR22000736
	popup_20220228();//2022년 03월 31일까지 SR22001697
	popup_20220303(); //2022년 03월 20일까지 SR22001746
	popup_20220906(); //2022년 09월 13일까지 SR22008318
	popup_20220930(); //2022년 10월 14일까지 SR22009070
	popup_20221230(); //2023년 1월 20일까지 SR22012129
	popup_20230110(); //2023년 1월 25일까지 SR23000391	
	popup_20230714(); //2023년 7월 14일까지 SR23006645
	popup_20230918(); //2023년 10월 6일까지 SR23008800
	popup_20231204(); //2024년 12월 31일까지 SR23010949
	popup_20240202(); //2024년 02월 15일까지 SR24001318	
	popup_20240910(); //2024년 09월 20일까지 SR24007852
	popup_20241230(); //2025년 01월 03일까지 SR24011015
	popup_20250116(); //2025년 02월 03일까지 SR25000460
	popup_20250132(); //2025년 05월 31일까지 SR25000882
	popup_20250207(); //2025년 02월 10일까지 SR25001095 -> SR25001183 교체
	popup_20250218(); //2025년 02월 24일까지 SR25001484
	popup_20250222(); //2025년 05월 31일까지 SR25001596
	popup_20250404(); //2025년 04월 10일까지 SR25002918
	popup_20250507(); //2025년 05월 12일까지 SR25003712
	popup_20250904(); //2025년 09월 06일까지 SR25006985 -> SR25007269
	popup_20250910(); //2025년 09월 18일까지 SR25007400
	popup_20250924(); //2025년 09월 25일까지 SR25007709		
	popup_20250926(); //2025년 10월 11일까지 SR25007772
	popup_20251201(); //2025년 12월 08일까지 SR25009437
	popup_20251212(); //2025년 12월 19일까지 SR25009896
	popup_20251230(); //2025년 12월 31일까지 SR25010275
	popup_20260102(); //2026년 01월 09일까지 SR26000006
	popup_20260109(); //2026년 01월 20일까지 SR26000293
	popup_20260112(); //2026년 01월 23일까지 SR26000337
	popup_20260204(); //2026년 02월 12일까지 SR26001125
	popup_20260206(); //2026년 03월 30일까지 SR26001256
	popup_20260209(); //2026년 02월 18일까지 SR26001297
	popup_20260422(); //2026년 05월 09일까지 SR26003446
	popup_20260715(); //2026년 08월 10일까지 SR26006097
<%}%>
<%if(p150000005 == true){%>
	popup_20230105();//2023년 1월26일까지 SR23000181
<%}%>
<%if(p150000006 == true){%>
	popup_20220512();//2022년 5월16일까지 SR22004483
<%}%>
  popup_coway(); //매월 24 ~ 매월 27
  popup_20171109(); //2999년 12월 31일까지
  popup_20180529(); //2999년 12월 31일까지  
  popup_20190121(); //2999년 12월 31일까지
  popup_20190717(); //2999년 12월 31일까지
  popup_20190911(); //2999년 12월 31일까지
  popup_20191231(); //2999년 12월 31일까지
  popup_20230523(); //2999년 12월 31일까지
  popup_20200124(); //2999년 12월 31일까지
  popup_20200629(); //2999년 12월 31일까지
  popup_20200831(); //2999년 12월 31일까지
  popup_20201125(); //2021년 12월 31일까지
  popup_20210225(); //2021년 12월 31일까지
  popup_20210330(); //2021년 12월 30일까지
  // popup_20210430(); //2999년 12월 31일까지 -> SR26006304 삭제처리
  popup_20210512(); //2022년 12월 30일까지
  popup_20210524(); //2022년 12월 30일까지
  popup_20210632(); //2021년 12월 31일까지
  popup_20210712(); //2022년 12월 31일까지
  popup_20210722(); //2022년 12월 31일까지
  popup_20210722_1(); //2022년 12월 31일까지
  popup_20211122(); //2022년 11월 22일까지
  popup_20211201(); //2021년 12월 3일까지
  popup_20220112(); //2022년 1월 31일까지
  popup_20220126(); //2022년 4월 25일까지
  popup_20220208(); //2022년 3월 20일까지 SR22001189 
  popup_20220210(); //2022년 5월 6일까지
  popup_20220217(); //2022년 3월 31일까지
  popup_20220227(); //2022년 3월 3일까지 SR22001619
  popup_20220302(); //2022년 2월 24일까지 SR22001739  
  popup_20220305(); //2022년 3월 17일까지 SR22002068
  popup_20220310(); //2022년 3월 31일까지 SR22002556
  popup_20220316(); //2022년 4월 28일까지 SR22002853
  popup_20220401(); //2022년 5월 31일까지 SR22003372
  popup_20220614(); //2999년 12월 31일까지
  popup_20220621(); //2022년 09월 21일까지
  popup_20220716(); //2022년 07월 15일까지
  popup_20220809(); //2022년 08월 19일까지
  popup_20220829(); //2022년 09월 2일까지
  popup_20220901(); //2022년 09월 12일까지
  popup_20220905(); //2022년 09월 16일까지
  popup_20220928(); //2022년 10월 07일까지
  popup_20221007(); //2022년 10월 21일까지
  popup_20221101(); //2999년 12월 31일까지
  popup_20221208(); //2022년 12월 09일까지
  <%if(p150000004 == true){%>
	popup_20221209();//2022년12월09일까지 SR22011413
<%}%>
  popup_20221210(); //2022년 12월 14일까지
  popup_20221217(); //2999년 12월 31일까지
  popup_20221222(); //2023년 1월 6일까지
  popup_20221224(); //2022년 12월 30일까지
  popup_20230106(); //2023년 01월 31일까지
  popup_20230111(); //2023년 01월 31일까지 SR23000451
  popup_20230116(); //2023년 01월 24일까지 SR23000605
  popup_20230125(); //2023년 01월 29일까지 SR23000787
  popup_20230126(); //2099년 12월 31일까지 SR23000803
  popup_20230128(); //2023년 02월 28일까지 SR23000863
  popup_20230323(); //2023년 04월 07일까지 SR23002837
  popup_20230411(); //2023년 05월 31일까지 SR23003466
  popup_20230418(); //2023년 05월 20일까지 SR23003768
  popup_20230530(); //2023년 06월 16일까지 SR23005168
  popup_20230602(); //2023년 08월 31일까지 SR23005417
  popup_20230603(); //2023년 08월 31일까지 SR23005438
  <%if(p150000007== true) { %>
  popup_20230531(); //2023년 06월 06일까지 SR23005175
  <% } %>
  popup_20230614(); //2023년 06월 16일까지 SR23005725
  popup_20230615(); //2023년 06월 16일까지 SR23005725
  popup_20230616(); //2023년 09월 30일까지 SR23005759
  popup_20230620(); //2023년 09월 30일까지 SR23005873
  popup_20230621(); //2023년 06월 28일까지 SR23005998
  <%if(p150000008== true) { %>
  popup_20230706(); //2023년 07월 16일까지 SR23006472
  <% } %>
  <%if(p150000009== true) { %>
  popup_20230711(); //2023년 07월 14일까지 SR23006572
  <% } %>
  popup_20230717(); //2023년 07월 31일까지 SR23006721
  popup_20230720(); //2023년 09월 20일까지 SR23006887
  popup_20230726(); //2999년 12월 31일까지 SR23007072
  <%if(p150000010== true) { %>
  popup_20230807(); //2023년 08월 15일까지 SR23007557
  <% } %>
  popup_20230816(); //2023년 09월 30일까지 SR23007751
  popup_20230904(); //2023년 09월 27일까지 SR23008394
  <%if(p150000011== true) { %>
  popup_20230911(); //2023년 10월 06일까지 SR23008610
  <% } %>
  popup_20230919();
  <%if(p150000012== true) { %>
  popup_20230921(); //2023년 10월 06일까지 SR23008898
  <% } %>
  popup_20231005(); //2023년 12월 31일까지 SR23009208
  popup_20231030(); //2023년 12월 31일까지 SR23009825
  popup_20231031(); //2023년 12월 31일까지 SR23009866
  popup_20231117(); //2023년 11월 26일까지 SR23010433
  popup_20231118(); //2023년 11월 26일까지 SR23010433
  popup_20231123(); //2023년 12월 01일까지 SR23010593
  popup_20231229(); //2024년 06월 30일까지 SR23011665
  popup_20240104(); //2024년 01월 31일까지 SR24000213
  popup_20240124(); //요청시까지 무기한 SR24000858
  <%if(p150000013 == true) { %>
  popup_20240130(); //2024년 02월 14일까지 SR24001011, SR24001251
  <% } %>
  popup_20240131(); //2024년 04월 30일까지 SR24001157
  popup_20240205(); //요청시까지 무기한 SR24001358
  popup_20240229(); //2024년 03월 31일까지 SR24002054  
  popup_20240307(); //2024년 04월 30일까지 SR24002297
  popup_20240329(); //2999년 12월 31일까지 SR24002915
  popup_20240403(); //2024년 05월 10일까지 SR24003207
  popup_20240405(); //2024년 04월 30일까지 SR24003279
  popup_20240408(); //2024년 04월 30일까지 SR24003301
  popup_20240417(); //2024년 05월 10일까지 SR24003544
  popup_20240422(); //요청시까지 무기한 SR24003645
  popup_20240429(); //2024년 05월 31일까지 SR24003830
  popup_20240431(); //2024년 05월 17일까지 SR24003924
  popup_20240502(); //2024년 05월 17일까지 SR24003946
  popup_20250731(); //요청시까지 무기한 매월갱신
  popup_20240521_1(); //2024년 12월 31일까지 SR24004389
  popup_20240603();
  popup_20240710(); // 2024년 07월 12일까지 SR24005914
  popup_20240711(); // 2024년 12월 31일까지 SR24005973
  popup_20240716(); // 2024년 8월 05일까지 SR24006089
  popup_20240726(); // 2024년 08월 09일까지 SR24006364
  popup_20240729(); // 2024년 10월 31일까지 SR24006501
  popup_20240801(); //2999년 12월 31일까지 SR24006613
  <%if(p150000014 == true) { %>
  	popup_20240805(); // 2024년 08월 20일까지 SR24006656, SR24006893
  <% } %>
  popup_20240819(); //요청시까지 무기한 SR24007043
  popup_20240829(); // 2024년 09월 18일까지 SR24007445, SR24007531
  popup_20240830_1(); //2024년 12월 31일까지 SR24007465
  popup_20240904(); //2024년 12월 31일까지 SR24007579
  <%if(p150000015 == true) { %>
	popup_20240905(); // 2024년 09월 20일까지 SR24007687
  <% } %>
  popup_20240906(); // 2024년 10월 31일까지 SR24007721
  popup_20241207(); // 프로그램 개발될때까지 지속
  popup_20241216(); // 2024년 1월 30일까지 SR24010688
  <%if(p150000016 == true) { %>
	popup_20250117(); // 요청시까지 무기한 SR25000473
<% } %>
  popup_20250118(); // 요청시까지 무기한 SR25000477
  popup_20250119(); // 2025년 12월 31일까지 SR25000526
  popup_20250123(); // 요청시까지 무기한 SR25000568
  
  popup_20250122(); // 2025년 12월 31일까지 SR25000581
  popup_20250124(); // 2025년 12월 31일까지 	SR25000583 
  popup_20250127(); // 2025년 02월 02일까지 	SR25000636 
  
  
  
  popup_20250130(); // 2025년 02월 14일까지 	SR25000792 
  popup_20250214(); // 2025년 12월 31일까지	SR25001401 
  popup_20250311(); // 2025년 03월 20일까지 SR25002088
  popup_20250321(); // 2025년 04월 11일까지 SR25002361
  popup_20250409(); // 요청시까지 무기한 SR25003051
  popup_20250410(); // 2025년 04월 11일까지 SR25002361
  popup_20250428(); // 2025년 04월 28일까지 SR25003502
  <%if(p150000018 == true) { %>
  popup_20250431(); // 2025년 12월 31일까지 SR25003547
  <% } %>
  popup_20250432(); // 2025년 05월 03일까지 SR25003613
  popup_20250520(); // 2025년 05월 30일까지 SR25004050
  popup_20250522(); // 요청시까지 무기한 SR25004143
  popup_20250523(); // 요청시까지 무기한 SR25004143
  popup_20250610(); // 요청시까지 무기한 SR25004675
  popup_20250619(); // 2025년 12월 31일까지 SR25004925
  popup_20250627(); // 2025년 07월 07일까지 SR25005267
  
  popup_20250701(); // 2025년 7월 18일 SR25005380
  <%if(p150000019 == true){ %>
  popup_20250709(); // 2025년 7월 11일까지 SR25005733, SR25005734, SR25005735, SR25005737
  <% } %>
  
  popup_20250723(); // 2025년 7월 16일 	SR25005896
  popup_20250725(); // 2025년 7월 21일 	SR25005973
  popup_20250726(); // 2025년 8월 04일까지  SR25005989
  popup_20250730(); // 2025년 7월 31일		SR25006094
  popup_20250733(); // 2025년 8월 05일까지  SR25006183 
  popup_20250813(); // 2025년 9월 30일까지  SR25006649
  popup_20250826(); // 2025년 9월 30일까지  SR25006898
  popup_20250915(); // 2025년 9월 30일까지 SR25007517
  popup_20250918(); // 2025년 10월 1일까지 SR25007588
  popup_20250923(); // 2025년 10월 10일까지 SR25007692
  popup_20250927(); // 2026년 6월 30일까지  SR25006256 -> SR25007814 -> SR26005286
  popup_20250931(); // 2025년 10월 10일까지  SR25007902
  popup_20251015(); // 2025년 10월 31일까지  SR25008146
  popup_20251104(); // 2025년 11월 14일까지  SR25008693
  popup_20251107(); // 2025년 11월 30일까지  SR25008871
  popup_20251114(); // 2025년 11월 28일까지  SR25009030
  popup_20251127(); // 2026년 01월 31일까지 SR25009316
  popup_kkpc_guide(); // 영구  SR25008098
  popup_20251128(); // 2025년 12월 31일까지 SR25009422
  // popup_20260105(); // 요청시까지 무기한 SR26000131   -> SR26006304 삭제처리
  popup_20260107(); // 2026년 12월 31일까지 SR26000195
  popup_20260126(); // 2026년 02월 27일까지 SR26000796 -> SR26000822 -> SR26000962
  popup_20260205(); // 2026년 02월 19일까지 SR26001160
  popup_20260313(); // 2026년 05월 13일까지 SR26002196
  popup_20260317(); // 2026년 04월 30일까지 SR26002279
  popup_20260324(); // 2026년 06월 30일까지 SR26002522
  popup_20260331(); // 요청시까지 무기한 SR26002734
  popup_20260407(); // 2026년 04월 30일까지
  popup_20260508(); // 2026년 05월 31일까지 SR26003997
  popup_20260512(); // 요청시까지 무기한  SR26004072
  popup_20260527(); // 2026년 06월 10일까지  SR26004466
  popup_20260601(); // 2026년 06월 30일까지 SR26004670
  popup_20260605(); // 요청시까지 무기한  SR26004828
  popup_20260617(); // 2026년 06월 30일까지 SR26005189
  popup_20260618(); // 2026년 06월 26일까지 SR26005213
  popup_20260619(); // 2026년 06월 26일까지 SR26005269
  popup_20260624(); // 요청시까지 무기한 SR26005370
  popup_20260716(); // 2026년 08월 15일까지 SR26006152
  <%if(p150000020 == true){ %>
  popup_20260701(); // 2026년 7월 10일까지 SR26005698
  <% } %>
  
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

//SR26004539 수도권사업팀 배수빈 
function popup_20250731() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRDONG1104"||buyer=="KRDONG1285"){
		if (getCookie("ncook20250731") != "done20250731") {
			noticeWindow = window.open("/resources/html/main/notice/popup_KRDONG.htm","popup_KRDONG","width=700, height=670, scrollbars = no");
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
	var check_date = "<%=check_date%>";	
	if(buyer=="KRHUON0001" || buyer=="KRHUON0006" || buyer=="KRHUON0010" || buyer=="KRUONS0001"){
		if(parseInt(check_date)<=parseInt("20250411")) {
			if (getCookie("ncook20250410") != "done20250410") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250410.htm","popup_20250410","width=490, height=310, scrollbars = no");
				noticeWindow.opener = self;
			}
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

//SR25006256 금호석유화학 임태헌 -> SR25007814 -> SR26005290
function popup_20250927(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKUMH0043"||buyer=="KRKUMH0044"||buyer=="KRKUMH0045"||buyer=="KRKUMH0046"||buyer=="KRKUMH0047"||buyer=="KRKUMH0048"||buyer=="KRKUMH0049"||buyer=="KRKUMH0052"||buyer=="KRKUMH0053"){
		if(parseInt(check_date)<=parseInt("20270630")) {
			if (getCookie("ncook20250927") != "done20250927") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20250927_2.htm","popup_20250927_2","width=770, height=630, scrollbars = no");
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

//SR25009437 SMART팀 신준호
function popup_20251212() {	
	var check_date = "<%=check_date%>";		
	if(parseInt(check_date)<=parseInt("20251219")) {
		if (getCookie("ncook20251212") != "done20251212") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20251212.htm","popup_20251212","width=420, height=330, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}

//SR25009437 SMART팀 신준호
function popup_20251230() {	
	var check_date = "<%=check_date%>";		
	if(parseInt(check_date)<=parseInt("20251231")) {
		if (getCookie("ncook20251230") != "done20251230") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20251230.htm","popup_20251230","width=570, height=380, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}

//SR26000006 SMART팀 신준호
function popup_20260102() {	
	var check_date = "<%=check_date%>";		
	if(parseInt(check_date)<=parseInt("20260109")) {
		if (getCookie("ncook20260102") != "done20260102") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20260102.htm","popup_20260102","width=500, height=310, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}


//SR26000131 남부사업팀 전선미 -> SR26000171 문구수정
function popup_20260105() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRNEXE0010"){		
		if (getCookie("ncook20260105") != "done20260105") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20260105_2.htm","popup_20260105_2","width=630, height=590, scrollbars = no");
			noticeWindow.opener = self;
		}		
	}
}

//SR26000195 Bio Lab사업팀 김혜란
function popup_20260107() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHUGE0001"||buyer=="KRACRO0006"){	
		if(parseInt(check_date)<=parseInt("20261231")) {
			if (getCookie("ncook20260107") != "done20260107") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20260107.htm","popup_20260107","width=730, height=390, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR26000293 SMART팀 신준호
function popup_20260109() {	
	var check_date = "<%=check_date%>";		
	if(parseInt(check_date)<=parseInt("20260120")) {
		if (getCookie("ncook20260109") != "done20260109") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20260109.htm","popup_20260109","width=510, height=420, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}

//SR26000337 SMART팀 신준호
function popup_20260112() {	
	var check_date = "<%=check_date%>";		
	if(parseInt(check_date)<=parseInt("20260123")) {
		if (getCookie("ncook20260112") != "done20260112") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20260112.htm","popup_20260112","width=480, height=410, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}

//SR26000796 -> SR26000822 -> SR26000962 중부사업팀 김수나
function popup_20260126(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRMERT0001"||buyer=="KRMERT0002"||buyer=="KRMERT0003"||buyer=="KRMERT0004"||buyer=="KRSOLB0005"||buyer=="KRSOLB0012"||buyer=="KRSOUL0002"||
			buyer=="KRSOLB0011"||buyer=="KRSOLB0009"||buyer=="KRSOLB0013"||buyer=="KRSOLB0008"||buyer=="KRMCSO0001"){
		if(parseInt(check_date)<=parseInt("20260227")) {
			if (getCookie("ncook20260126") != "done20260126") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20260126_4.htm","popup_20260126_4","width=500, height=420, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR26000337 SMART팀 신준호
function popup_20260204() {	
	var check_date = "<%=check_date%>";		
	if(parseInt(check_date)<=parseInt("20260212")) {
		if (getCookie("ncook20260204") != "done20260204") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20260204.htm","popup_20260204","width=500, height=360, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}

//SR26001160 특판사업팀.판촉사업그룹 김은비
function popup_20260205() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHANS0308"){	
		if(parseInt(check_date)<=parseInt("20260219")) {
			if (getCookie("ncook20260205") != "done20260205") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20260205.htm","popup_20260205","width=550, height=520, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR26002196 수도권사업팀 배수빈
function popup_20260313() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRSCK-0002"){	
		if(parseInt(check_date)<=parseInt("20260513")) {
			if (getCookie("ncook20260313") != "done20260313") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20260313.htm","popup_20260313","width=500, height=370, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR26002279 특판사업팀.IT사업그룹 전지수
function popup_20260317() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRHANS0308"){	
		if(parseInt(check_date)<=parseInt("20260430")) {
			if (getCookie("ncook20260317") != "done20260317") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20260317.htm","popup_20260317","width=720, height=440, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
}

//SR26001256 SMART팀 신준호
function popup_20260206() {	
	var check_date = "<%=check_date%>";		
	if(parseInt(check_date)<=parseInt("20260330")) {
		if (getCookie("ncook20260206") != "done20260206") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20260206.htm","popup_20260206","width=460, height=390, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}

//SR26001297 SMART팀 신준호
function popup_20260209() {	
	var check_date = "<%=check_date%>";		
	if(parseInt(check_date)<=parseInt("20260218")) {
		if (getCookie("ncook20260209") != "done20260209") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20260209.htm","popup_20260209","width=600, height=420, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}

//SR26002524 김명선 
function popup_20260324() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRINTE0099"){
		if(parseInt(check_date)<=parseInt("20260630")) {
			if (getCookie("ncook20260324") != "done20260324") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20260324.htm","popup_20260324","width=500, height=400, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR26002734 이종우 
function popup_20260331() {
	var buyer="<%=sessionComCode%>";	
	if(buyer=="KRAMOR0003"||buyer=="KRAMOR0004"||buyer=="KRAMOR0005"||buyer=="KRAMOS0006"||buyer=="KRETUD0002"||buyer=="KRESPO0003"||
			buyer=="KRINNI0002"||buyer=="KROSUL0002"||buyer=="KROSUL0003"||buyer=="KRCOSV0002"||buyer=="KRWE-D0001"||buyer=="KRPACI0008"||
			buyer=="KRHANG0052"||buyer=="KRJENI0004"||buyer=="KRTHE-0052"||buyer=="KRAMOR0011") {	  
		
			if (getCookie("ncook20260331") != "done20260331") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20260331.htm","popup_20260331","width=510, height=500, scrollbars = no");
				noticeWindow.opener = self;
			}
		
	}
}

function popup_20260407() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRSOLB0008"||buyer=="KRMCSO0001"||buyer=="KRSOLB0009"||buyer=="KRSOLB0011"||buyer=="KRMERT0001"||
			buyer=="KRMERT0002"||buyer=="KRMERT0003"||buyer=="KRMERT0004"||buyer=="KRSOLB0012"||buyer=="KRSOLB0013"||
			buyer=="KRSOUL0002"|| buyer ==  'KRSOLB0005'){
		if(parseInt(check_date)<=parseInt("20260430")) {
			if (getCookie("ncook20260407") != "done20260407") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20260407.htm","popup_20260407","width=470, height=450, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR26001297 SMART팀 신준호
function popup_20260422() {	
	var check_date = "<%=check_date%>";		
	if(parseInt(check_date)<=parseInt("20260506")) {
		if (getCookie("ncook20260422") != "done20260422") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20260422.htm","popup_20260422","width=500, height=360, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}
//SR26003997 Bio Lab사업팀 이홍경
function popup_20260508() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRINNO0066"||buyer=="KRINNO0067"||buyer=="KRINNO0068"||buyer=="KRINNO0069"){
		if(parseInt(check_date)<=parseInt("20260531")) {
			if (getCookie("ncook20260508") != "ncook20260508") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20260508.htm","popup_20260508","width=670, height=500, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR26004072 수도권사업팀 배수빈
function popup_20260512() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRSCK-0002"){
		if (getCookie("ncook20260512") != "ncook20260512") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20260512.htm","popup_20260512","width=520, height=390, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}

//SR26004466 수도권사업팀 최영욱
function popup_20260527() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20260610")) {
		if(buyer=="KRLOTT0102"||buyer=="KRLOTT0084"||buyer=="KRLOTT0093"||buyer=="KRLOTT0088"||buyer=="KRLOTT0089"||buyer=="KRLOTT0090"||buyer=="KRLOTT0096"||buyer=="KRLOTT0086"
			||buyer=="KRLOTT0085"||buyer=="KRLOTT0091"||buyer=="KRLOTT0092"||buyer=="KRLOTT0094"||buyer=="KRLOTT0087"||buyer=="KRLOTT0097"||buyer=="KRLOTT0095"
				||buyer=="KRLOTT0098"||buyer=="KRLOTT0099"||buyer=="KRLOTT0100"||buyer=="KRLOTT0101"){
			if (getCookie("ncook20260527") != "ncook20260527") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20260527.htm","popup_20260512","width=730, height=550, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR26004670 수도권사업팀 조현주
function popup_20260601() {
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(parseInt(check_date)<=parseInt("20260630")) {
		if(buyer=="KRETUD0002"||buyer=="KRAMOR0003"||buyer=="KRINNI0002"||buyer=="KRAMOR0005"||buyer=="KRESPO0003"||buyer=="KROSUL0002"||buyer=="KRAMOR0004"||buyer=="KRAMOS0006"){
			if (getCookie("ncook20260601") != "ncook20260601") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20260601.htm","popup_20260601","width=480, height=320, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}
//SR26004828 수도권사업팀 김혜란
function popup_20260605() {
	var buyer="<%=sessionComCode%>";
	if(buyer=="KRHUGE0001"){
		if (getCookie("ncook20260605") != "ncook20260605") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20260605.htm","popup_20260605","width=550, height=370, scrollbars = no");
			noticeWindow.opener = self;
		}
	}
}

//SR26005189 금호석유화학 최원철
function popup_20260617(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRKUMH0043"||buyer=="KRKUMH0044"||buyer=="KRKUMH0045"||buyer=="KRKUMH0046"||buyer=="KRKUMH0047"||buyer=="KRKUMH0048"||buyer=="KRKUMH0049"||buyer=="KRKUMH0052"||buyer=="KRKUMH0053"){
		if(parseInt(check_date)<=parseInt("20260630")) {
			if (getCookie("ncook20260617") != "done20260617") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20260617.htm","popup_20260617","width=660, height=590, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}

//SR26005213 넥센타이어(주) 양산공장 전선미
function popup_20260618(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRNEXE0008"){
		if(parseInt(check_date)<=parseInt("20260626")) {
			if (getCookie("ncook20260618") != "done20260618") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20260618.htm","popup_20260618","width=600, height=640, scrollbars = no");
				noticeWindow.opener = self;
				 }
			}
	}
}

//SR26005269 Bio Lab사업팀 배인영
function popup_20260619(){
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRCRYS0005"||buyer=="KRBIOR0001"){
		if(parseInt(check_date)<=parseInt("20260630")) {
			if (getCookie("ncook20260619") != "done20260619") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20260619.htm","popup_20260619","width=500, height=390, scrollbars = no");
				noticeWindow.opener = self;
			}
		}
	}
}

//SR26005370 남부사업팀 전선미
function popup_20260624(){
	var buyer="<%=sessionComCode%>";	
	if(buyer=="KRNEXE0008"){	
			if (getCookie("ncook20260624") != "done20260624") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20260624.htm","popup_20260624","width=550, height=420, scrollbars = no");
				noticeWindow.opener = self;
			}
	}	
}

//SR26005269 Bio Lab사업팀 배인영
function popup_20260701(){
	if (getCookie("ncook20260701") != "done20260701") {
		noticeWindow = window.open("/resources/html/main/notice/popup_20260701.htm","popup_20260701","width=610, height=640, scrollbars = no");
		noticeWindow.opener = self;
	}
}


//SR26006097 SMART팀 신준호
function popup_20260715() {	
	var check_date = "<%=check_date%>";	
	if(parseInt(check_date)<=parseInt("20260810")) {
		if (getCookie("ncook20260715") != "done20260715") {
			noticeWindow = window.open("/resources/html/main/notice/popup_20260715.htm","popup_20260715","width=510, height=440, scrollbars = no");
			noticeWindow.opener = self;
		 }
	}
}

//SR26006152 남부사업팀 전선미
function popup_20260716() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRNEXE0010"){
		if(parseInt(check_date)<=parseInt("20260815")) {
			if (getCookie("ncook20260716") != "done20260716") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20260716.htm","popup_20260716","width=850, height=430, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}	
}

//SR26006305 남부사업팀 전선미
function popup_20260722() {	
	var buyer="<%=sessionComCode%>";
	var check_date = "<%=check_date%>";
	if(buyer=="KRNEXE0008"||buyer=="KRNEXE0010"){
		if(parseInt(check_date)<=parseInt("20260803")) {
			if (getCookie("ncook20260722") != "done20260722") {
				noticeWindow = window.open("/resources/html/main/notice/popup_20260722.htm","popup_20260722","width=520, height=400, scrollbars = no");
				noticeWindow.opener = self;
			 }
		}
	}
	
}

function showCommonCoCoVocBuyerReqCreateRegPop(st_user_id, st_dept){	
	openSearchPopup('/coco/showCommonCoCoVocBuyerReqCreateRegPop.do','?st_ds_user_id='+st_user_id+'&st_ds_dept='+st_dept,'800,380,no');    
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

function manualDown(type){
	if("<%=sessionComCode%>" == "KRCOWA0001" || "<%=sessionComCode%>" == "KRCOWA0004" || "<%=sessionComCode%>" == "KRCOWA0005"|| "<%=sessionComCode%>" == "KRCOWA0006"){
		location.href="/resources/excel/work/MAIN/Buyer_Manual_COWAY_v1.5.zip";
	} else if ("<%=sessionComCode%>" == "KRCOWA0002"||"<%=sessionComCode%>" == "KRCOWA0007") {
		location.href="/resources/excel/work/MAIN/Buyer_Manual_COWAY_CL_v1.0.zip";
	}else if("<%=sessionComCode%>" == "KRCOWA0003"){
		location.href="/resources/excel/work/MAIN/Buyer_Manual_COWAY_CS_V1.0.zip";		
	}else if("<%=sessionComCode%>" == "KRCOWA0008"){
		location.href="/resources/excel/work/MAIN/Buyer_Manual_COWAY_W_V1.0.zip";
	}else if("<%=sessionComCode%>" == "KRLOTT0019" || "<%=sessionComCode%>" == "KRLOTT0020" || "<%=sessionComCode%>" == "KRLOTT0021"
			|| "<%=sessionComCode%>" == "KRLOTT0022" || "<%=sessionComCode%>" == "KRLOTT0023" || "<%=sessionComCode%>" == "KRLOTT0024"
			|| "<%=sessionComCode%>" == "KRLOTT0025" || "<%=sessionComCode%>" == "KRLOTT0026" || "<%=sessionComCode%>" == "KRLOTT0027"){
		location.href="/resources/excel/work/MAIN/Buyer_Manual_LOTTE_CONF_V2.0.zip";
	}else if("<%=sessionComCode%>" == "KRCHOK0003" || "<%=sessionComCode%>" == "KRCHOK0004" || "<%=sessionComCode%>" == "KRCHOK0005"
			|| "<%=sessionComCode%>" == "KRCHOK0006"){
		location.href="/resources/excel/work/MAIN/Buyer_Manual_CHOKWANG_PAINT_V2.zip";
	}else if("<%=sessionComCode%>" == "KRS-OI0002"){
		//에쓰오일 매뉴얼 다운로드
		location.href="/resources/excel/work/MAIN/Buyer_Manual_SOIL_V1.0.zip";	
	}else{
		if(type=="A"){location.href="/resources/excel/work/MAIN/Buyer_Manual_PR_v2_1.zip";}
		else if(type=="B"){location.href="/resources/excel/work/MAIN/Buyer_Manual_PO_v2_1.zip";}
		else if(type=="C"){location.href="/resources/excel/work/MAIN/Buyer_Manual_Sourcing_v2_1.zip";}
		else if(type=="D"){location.href="resources/excel/work/MAIN/Buyer_Manual_MASTER_v2_1.zip";}
		else if(type=="E"){location.href="resources/excel/work/MAIN/2018_Hanhwa_Calendars_Description_Manual.zip";}
		else if(type=="F"){location.href="resources/excel/work/MAIN/2020_HwanIn_Manual.zip";}
		else if(type=="G"){location.href="resources/excel/work/MAIN/Chung-AngUniv_Buyer_Manual_PR.zip";}
		else if(type=="H"){location.href="resources/excel/work/MAIN/Chung-AngUniv_Buyer_Manual_PO.zip";}
		else if(type=="I"){location.href="resources/excel/work/MAIN/2022_Lottechilsung_PR.zip";}
		else if(type=="J"){location.href="resources/excel/work/MAIN/2022_AEKYUNG_USER.zip";}
		else if(type=="K"){location.href="resources/excel/work/MAIN/2022_AEKYUNG_ADMIN.zip";}
		else if(type=="L1"){location.href="resources/excel/work/MAIN/2023_KUMHO_PR.zip";}
		else if(type=="L2"){location.href="resources/excel/work/MAIN/2023_KUMHO_PO.zip";}
		else if(type=="L3"){location.href="resources/excel/work/MAIN/2023_KUMHO_SOURCING.zip";}
		else if(type=="L4"){location.href="resources/excel/work/MAIN/2023_KUMHO_ADMIN.zip";}
	}
	    
} 
function sgsManualDown(type){ 

		if(type=="A"){
			location.href="/resources/excel/work/MAIN/SGS_Manual_PO_v2019.zip";
		}else if(type=="B"){
			location.href="/resources/excel/work/MAIN/SGS_Manual_SO_v2019.zip";
		}
	    
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

//VOC 페이지 이동링크
function getCustomerCenterList(){
	location.href = "/main/getCustomerCenterList.do?upperId=b00000000000";
}

//리뉴얼 변경 팝업 시 스크롤 안됨 이슈(추후 제거예정)
<%if(p150000021 == false && p150000022 == true) { %> 
	var re_popup = document.getElementById('renewalPopup');
	re_popup.classList.remove('show');
	document.body.style.overflow = '';
<% } %>
</script>

<div id="wrapper">
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="b00000000000"/>
</c:import>
<div id="container2">
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<c:import charEncoding="utf-8" url="/menu/buyerMainMenu.do">
<c:param name="page" value="buyerMainMenu"/>
<c:param name="part" value="b00000000000"/>
</c:import>
        <div class="MyPageBox"> 
            <div class="MyWelcome">
            	<div>
					<span>${sessionInfo.userNameLoc} </span> <%=CommonLang.get("HTITLE736")%><!-- 님 -->&nbsp;  ${sessionInfo.comNameLoc}<br/>
                    <a href="<%=h_sslurl2%>/mdam/showBuyerMdAmUserInfo.do?upperId=b00000000000&leftMenu=N"><p class="BtnModify"><%=CommonLang.get("HTITLE445")%> <%=CommonLang.get("HTITLE781")%><!-- 개인정보 수정 --></p></a>
                    <a href="/mdam/showBuyerMdAmCmpyInfo.do?upperId=b00000000000&leftMenu=N"><p class="BtnModify"> <%=CommonLang.get("HTITLE737")%><%=CommonLang.get("HTITLE781")%><!-- 회사정보 수정 --></p></a>
	                <% if (cowayFlag == true) { %>                 
		                <% if("KRCOWA0001".equals(sessionComCode) || "KRCOWA0009".equals(sessionComCode)){  %>
		              	<a href="javascript:setDetailSearch('상조','','','');"><p class="BtnModifyCoway"><%=CommonLang.get("HTITLE763")%><!-- 상조물품신청 --></p></a>  
		              	<a href="javascript:setDetailSearch('명함','','','');"><p class="BtnModifyCoway"><%=CommonLang.get("HTITLE764")%><!-- 명함신청하기 --></p></a>
		              	<%   }  %>
	                <%} %>
                </div>
                 		<%if(budget_flag.equals("Y")){ %>
                 		<div class="FavoritesList_5" >
                		<ul>
							<a href="javaScript:openSearchPopup('<%=h_sslurl2%>/home/showBuyerHomeDeptBudgetPop.do', '', '1200,620,no');"><li><img src="/resources/images/searchList_05.gif" /><br/><%=CommonLang.get("HTITLE431")%><!-- 예산조회 --></li></a>
							<a href="/mdcm/showBuyerMdCmCategoryGoodsSearch.do?upperId=b00100000000"><li><img src="/resources/images/searchList_01.gif" /><br/><%=CommonLang.get("HTITLE765")%><!-- 카테고리상품 --></li></a>
						<%}else{ %>
                 		<div class="FavoritesList_4" >
                		<ul>
							<a href="/mdcm/showBuyerMdCmCategoryGoodsSearch.do?upperId=b00100000000"><li><img src="/resources/images/searchList_01.gif" /><br/><%=CommonLang.get("HTITLE765")%><!-- 카테고리상품 --></li></a>
						<%} %>
        	            <a href="/mdcm/getBuyerMdCmHistoryGoodsSearchList.do?upperId=b00100000000"><li><img src="/resources/images/searchList_02.gif" /><br/><%=CommonLang.get("HTITLE766")%><!-- 이력상품 --></li></a>
    	                <a href="/mdcm/getBuyerMdCmMyGoodsSearchList.do?upperId=b00100000000"><li><img src="/resources/images/searchList_03.gif" /><br/><%=CommonLang.get("HTITLE593")%><!-- 나의상품 --></li></a>
	                    <a href="javascript:showSearchDetailPop()"><li><img src="/resources/images/searchList_04.gif" /><br/><%=CommonLang.get("HTITLE767")%><!-- 상세검색 --></li></a>
                    </ul>
                </div>
            </div> 
			<div class="MyService">
    	        <h2>Customer Service</h2>
                <table>
                	<tr>
                		<td class="leftsideT" style="width:45px; height:98px; border-bottom:1px solid #999;"><%=CommonLang.get("HTITLE949")%><!-- 운영--><br/><%=CommonLang.get("HTITLE951")%><!-- 담당--></th>
                		<% if (_vocUserData2 != null){ %>
	                        <td class="centersideT" style="width:230px; border-bottom:1px solid #999;">
	                        	<%=CommonUtil.nvl(_vocUserData2.get("USER_NAME_LOC"))%>   <%=CommonUtil.nvl(_vocUserData2.get("POSITION_NAME"))%>[<%=CommonUtil.nvl(_vocUserData2.get("DEPARTMENT_NM"))%>]<br/>
	                        	<%=CommonUtil.nvl(_vocUserData2.get("EMAIL"))%><br/>
	                        	<%=CommonUtil.nvl(_vocUserData2.get("PHONE_NUMBER"))%>
	                        </td>
	                        <td class="rightsideT" style="width:45px; border-bottom:1px solid #999;">
	                        	<button id="ServiceBtn01" onclick="javascript:showCommonCoCoVocBuyerReqCreateRegPop('<%=CommonUtil.nvl(_vocUserData2.get("USER_ID"))%>','<%=CommonUtil.nvl(_vocUserData2.get("DEPARTMENT"))%>');"><%=CommonLang.get("HTITLE500")%><!-- 요청 --></button><br/>
		                        <button id="ServiceBtn02" onclick="javascript:getCustomerCenterList()"><%=CommonLang.get("HTITLE923")%><!-- 처리결과 --></button>
	                        </td>
	                    <%} %>
                    </tr>
                    <tr>
                    	<td class="leftsideB" style="height:98px;"><%=CommonLang.get("HTITLE950")%><!-- 영업--><br/><%=CommonLang.get("HTITLE951")%><!-- 담당--></th>
                    	<% if (_vocUserData1 != null){ %>
                    		
                        	<td class="centersideB">
                        		<%=CommonUtil.nvl(_vocUserData1.get("USER_NAME_LOC"))%>   <%=CommonUtil.nvl(_vocUserData1.get("POSITION_NAME"))%>[<%=CommonUtil.nvl(_vocUserData1.get("DEPARTMENT_NM"))%>]
	                        	<br/><%=CommonUtil.nvl(_vocUserData1.get("EMAIL"))%>
	                        	<br/><%=CommonUtil.nvl(_vocUserData1.get("PHONE_NUMBER"))%>
                        	</td>
                        	<td class="rightsideB">
	                        	<button id="ServiceBtn01" onclick="javascript:showCommonCoCoVocBuyerReqCreateRegPop('<%=CommonUtil.nvl(_vocUserData1.get("USER_ID"))%>','<%=CommonUtil.nvl(_vocUserData1.get("DEPARTMENT"))%>');"><%=CommonLang.get("HTITLE500")%><!-- 요청 --></button><br/>
		                        <button id="ServiceBtn02" onclick="javascript:getCustomerCenterList()"><%=CommonLang.get("HTITLE923")%><!-- 처리결과 --></button>
                        	</td>
                        <%} %>
                    </tr>
                </table>
            </div>
<%if("KRWHAN0001".equals(sessionComCode) || "KRWHAN0002".equals(sessionComCode)){ %>
            <div class="MyListBox_04">
                <ul>
                    <li><span><a href="<%=p060000036%>"><%=CommonUtil.bnvl(_statusCountData.get("CART_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE161")%><!-- 장바구니 --></li>
					<% if ("Y".equals(PO_FLAG)) { %>
                    	<li><span><a href="/mppo/showBuyerMpPoOrderReqReceipt.do?upperId=b00100000000"><%=CommonUtil.bnvl(_statusCountData.get("PO_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE772")%><!-- 발주대상 --></li>
                    <%}else{ %>
                    	<li><span><a href="javascript:alert('<%=CommonLang.msg("MSG434")%>')"><!-- 선택하신 메뉴에 대한 권한이 없습니다.\n\n관리자에게 문의 바랍니다. --><%=CommonUtil.bnvl(_statusCountData.get("PO_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE772")%><!-- 발주대상 --></li>
                    <%}%>
					<li><span><a href="/mprq/showBuyerMpRqQuotaProceStateList.do?upperId=b00100000000"><%=CommonUtil.bnvl(_statusCountData.get("SOUR_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE773")%><!-- 신규상품요청 --></li>
                    <li><span><a href="/mprq/showBuyerMpRqUnitpriceAgrmntNegoReq.do?upperId=b00100000000"><%=CommonUtil.bnvl(_statusCountData.get("AGMT_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE155")%><!-- 단가합의대상 --></li>
                    <input type="hidden" name="main_cart_cnt" id="main_cart_cnt" value="<%=CommonUtil.bnvl(_statusCountData.get("CART_CNT"))%>">
					<%
   						request.getSession().setAttribute("session_CART_CNT", CommonUtil.bnvl(_statusCountData.get("CART_CNT")));
					%> 
                </ul>
            </div>
<%}else{%>
			<div class="MyListBox">
                <ul>
                	<!--중앙대학교 A001  -->
                	<%if(p060000106_type.equals("A001")){ %>
	                    <li><span><a href="<%=p060000036%>"><%=CommonUtil.bnvl(_statusCountData.get("CART_CNT"))%></a></span><br/> <%=CommonLang.get("HTITLE161")%><!-- 장바구니 --></li>
                    	<li><span><a href="/mdap/showNewPassSendList.do?upperId=b00100000000"><%=CommonUtil.bnvl(_statusCountData.get("SEND_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE702")%><!-- 결재상신 --></li>
                    	<li><span><a href="/mdap/showNewPassRecvList.do?upperId=b00100000000&st_appr_gbn=PR"><%=CommonUtil.bnvl(_statusCountData.get("PR_RECV_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE945")%><!-- 구매요청결재 --></li>
						<li><span><a href="/mdap/showNewPassRecvList.do?upperId=b00100000000&st_appr_gbn=PX"><%=CommonUtil.bnvl(_statusCountData.get("PX_RECV_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE946")%><!-- 발주결재 --></li>
	                    <li><span><a href="/mprq/showBuyerMpRqQuotaProceStateList.do?upperId=b00100000000"><%=CommonUtil.bnvl(_statusCountData.get("SOUR_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE773")%><!-- 신규상품요청 --></li>
	                    <li><span><a href="/mprq/showBuyerMpRqUnitpriceAgrmntNegoReq.do?upperId=b00100000000"><%=CommonUtil.bnvl(_statusCountData.get("AGMT_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE155")%><!-- 단가합의대상 --></li>
	                    <input type="hidden" name="main_cart_cnt" id="main_cart_cnt" value="<%=CommonUtil.bnvl(_statusCountData.get("CART_CNT"))%>">
                	<%}else{ %>
	                    <li><span><a href="<%=p060000036%>"><%=CommonUtil.bnvl(_statusCountData.get("CART_CNT"))%></a></span><br/> <%=CommonLang.get("HTITLE161")%><!-- 장바구니 --></li>
	                    <% if ("Y".equals(PASS_FLAG)) { %>
	                    	<li><span><a href="/mdap/showNewPassSendList.do?upperId=b00100000000"><%=CommonUtil.bnvl(_statusCountData.get("SEND_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE702")%><!-- 결재상신 --></li>
	                    	<li><span><a href="/mdap/showNewPassRecvList.do?upperId=b00100000000"><%=CommonUtil.bnvl(_statusCountData.get("RECV_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE770")%><!-- 결재대상 --></li>
	                    <%}else{ %>
	                    	<li><span><a href="javascript:alert('<%=CommonLang.msg("MSG434")%>')"><!-- 선택하신 메뉴에 대한 권한이 없습니다.\n\n관리자에게 문의 바랍니다. --><%=CommonUtil.bnvl(_statusCountData.get("SEND_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE702")%><!-- 결재상신 --></li>
	                    	<li><span><a href="javascript:alert('<%=CommonLang.msg("MSG434")%>')"><!-- 선택하신 메뉴에 대한 권한이 없습니다.\n\n관리자에게 문의 바랍니다. --><%=CommonUtil.bnvl(_statusCountData.get("RECV_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE770")%><!-- 결재대상 --></li>
	                    <%}%>
	                    <% if ("Y".equals(PO_FLAG)) { %>
	                    	<li><span><a href="/mppo/showBuyerMpPoOrderReqReceipt.do?upperId=b00100000000"><%=CommonUtil.bnvl(_statusCountData.get("PO_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE772")%><!-- 발주대상 --></li>
	                    <%}else{ %>
	                    	<li><span><a href="javascript:alert('<%=CommonLang.msg("MSG434")%>')"><!-- 선택하신 메뉴에 대한 권한이 없습니다.\n\n관리자에게 문의 바랍니다. --><%=CommonUtil.bnvl(_statusCountData.get("PO_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE772")%><!-- 발주대상 --></li>
	                    <%}%>
	                    <li><span><a href="/mprq/showBuyerMpRqQuotaProceStateList.do?upperId=b00100000000"><%=CommonUtil.bnvl(_statusCountData.get("SOUR_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE773")%><!-- 신규상품요청 --></li>
	                    <% if ("ROLE_BSAMYANG_ALL_GE".equals(sessionUserAuth)) { %>
	                    	<li><span><a href="/mprq/showBuyerMpRqUnitpriceAgrmntNegoReqMulti.do?upperId=b00100000000"><%=CommonUtil.bnvl(_statusCountData.get("AGMT_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE155")%><!-- 단가합의대상 --></li>
	                    <%}else{%>
	                    	<li><span><a href="/mprq/showBuyerMpRqUnitpriceAgrmntNegoReq.do?upperId=b00100000000"><%=CommonUtil.bnvl(_statusCountData.get("AGMT_CNT"))%></a></span><br/><%=CommonLang.get("HTITLE155")%><!-- 단가합의대상 --></li>
	                    <%}%>
	                    <input type="hidden" name="main_cart_cnt" id="main_cart_cnt" value="<%=CommonUtil.bnvl(_statusCountData.get("CART_CNT"))%>">
                	<%} %>
	                   <%
	   						request.getSession().setAttribute("session_CART_CNT", CommonUtil.bnvl(_statusCountData.get("CART_CNT")));
	   					%>
                </ul>
            </div>
<%}%>
					<%if("KRLOTT0019".equals(sessionComCode) || "KRLOTT0020".equals(sessionComCode) || "KRLOTT0021".equals(sessionComCode) ||
							"KRLOTT0022".equals(sessionComCode) || "KRLOTT0023".equals(sessionComCode) || "KRLOTT0024".equals(sessionComCode) ||
							"KRLOTT0025".equals(sessionComCode) || "KRLOTT0026".equals(sessionComCode) || "KRLOTT0027".equals(sessionComCode) ||
							"KRCHOK0003".equals(sessionComCode) || "KRCHOK0004".equals(sessionComCode) || "KRCHOK0005".equals(sessionComCode) ||
							"KRCHOK0006".equals(sessionComCode) || "KRS-OI0002".equals(sessionComCode)){ %>
			            <div class="DownLoadList01">
			            	<h2><%=CommonLang.get("HTITLE774")%><!-- 매뉴얼 다운로드 --></h2>
			            	<div><p>매뉴얼</p><p><a href="javascript:manualDown('')"><img src="/resources/images/Down02.png" /> <br/><span>다운로드</span></a></p></div>
			            </div>
                      <% }else if("KRSGS-0001".equals(sessionComCode)){%>
			            <div class="DownLoadList02">
			            	<h2><%=CommonLang.get("HTITLE774")%><!-- 매뉴얼 다운로드 --></h2>
			                <ul>
	                      		<a href="javascript:sgsManualDown('A')"><li><p><%=CommonLang.get("HTITLE237")%><!-- 구매발주 --></p> <img src="/resources/images/Down01.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
    	                  		<a href="javascript:sgsManualDown('B')"><li><p><%=CommonLang.get("HTITLE777")%><!-- 신규소싱 --></p> <img src="/resources/images/Down02.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
			                </ul>
			            </div>
                       <% }else if("KRWHAN0001".equals(sessionComCode) || "KRWHAN0002".equals(sessionComCode)){%>
			            <div class="DownLoadList02">
			            	<h2><%=CommonLang.get("HTITLE774")%><!-- 매뉴얼 다운로드 --></h2>
			                <ul>
	                      		<a href="javascript:manualDown('F')"><li><p><%=CommonLang.get("HTITLE459")%><!-- 일반사용자 --></p> <img src="/resources/images/Down01.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
    	                  		<a href="javascript:manualDown('D')"><li><p><%=CommonLang.get("HTITLE526")%><!-- 관리자 --></p> <img src="/resources/images/Down02.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
			                </ul>
			            </div>
                      <% }else if("KRCHUN0208".equals(sessionComCode)){%>
			            <div class="DownLoadList02">
			            	<h2><%=CommonLang.get("HTITLE774")%><!-- 매뉴얼 다운로드 --></h2>
			                <ul>
	                      		<a href="javascript:manualDown('G')"><li><p><%=CommonLang.get("HTITLE479")%><!-- 구매요청자 --></p> <img src="/resources/images/Down01.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
    	                  		<a href="javascript:manualDown('H')"><li><p><%=CommonLang.get("HTITLE775")%><!-- 구매발주자 --></p> <img src="/resources/images/Down02.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
			                </ul>
			            </div>
			            <% }else if("KRAEKY0006".equals(sessionComCode)){%>
			            <div class="DownLoadList04">
			            	<h2><%=CommonLang.get("HTITLE774")%><!-- 매뉴얼 다운로드 --></h2>
			                <ul>
	                      		<a href="javascript:manualDown('J')"><li><p><%=CommonLang.get("HTITLE459")%><!-- 일반사용자 --></p> <img src="/resources/images/Down01.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
	                      		<a href="javascript:manualDown('C')"><li><p><%=CommonLang.get("HTITLE777")%><!-- 신규소싱 --></p><img src="/resources/images/Down03.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
    	                  		<a href="javascript:manualDown('K')"><li><p><%=CommonLang.get("HTITLE526")%><!-- 관리자 --></p> <img src="/resources/images/Down02.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
			                </ul>
			            </div>
                       <% }else{%>
			            <div class="DownLoadList04"><!--다운로드 4개-->
			            	<h2><%=CommonLang.get("HTITLE774")%><!-- 매뉴얼 다운로드 --></h2>
			                <ul>
			                <!-- 매뉴얼1 -->
			                <% if("KRLOTT0058".equals(sessionComCode)){%>
			                	<a href="javascript:manualDown('I')"><li><p><%=CommonLang.get("HTITLE479")%><!-- 구매요청자 --></p> <img src="/resources/images/Down01.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
			                <% }else if("KRKUMH0043".equals(sessionComCode)||"KRKUMH0044".equals(sessionComCode)||"KRKUMH0045".equals(sessionComCode)||"KRKUMH0046".equals(sessionComCode)||"KRKUMH0047".equals(sessionComCode)
			                		||"KRKUMH0048".equals(sessionComCode)||"KRKUMH0049".equals(sessionComCode)||"KRKUMH0050".equals(sessionComCode)||"KRKUMH0051".equals(sessionComCode)||"KRKUMH0052".equals(sessionComCode)
			                		||"KRKUMH0053".equals(sessionComCode)){%>
			                	<a href="javascript:manualDown('L1')"><li><p><%=CommonLang.get("HTITLE479")%><!-- 구매요청자 --></p> <img src="/resources/images/Down01.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
			                <% }else{%>
			                	<a href="javascript:manualDown('A')"><li><p><%=CommonLang.get("HTITLE479")%><!-- 구매요청자 --></p> <img src="/resources/images/Down01.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
			                <% }%>
			                
			                <!-- 매뉴얼2 -->
			                <% if("KRKUMH0043".equals(sessionComCode)||"KRKUMH0044".equals(sessionComCode)||"KRKUMH0045".equals(sessionComCode)||"KRKUMH0046".equals(sessionComCode)||"KRKUMH0047".equals(sessionComCode)
			                		||"KRKUMH0048".equals(sessionComCode)||"KRKUMH0049".equals(sessionComCode)||"KRKUMH0050".equals(sessionComCode)||"KRKUMH0051".equals(sessionComCode)||"KRKUMH0052".equals(sessionComCode)
			                		||"KRKUMH0053".equals(sessionComCode)){%>
			                	<a href="javascript:manualDown('L2')"><li><p><%=CommonLang.get("HTITLE775")%><!-- 구매발주자 --></p> <img src="/resources/images/Down02.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
							<% }else{%>
			                	<a href="javascript:manualDown('B')"><li><p><%=CommonLang.get("HTITLE775")%><!-- 구매발주자 --></p> <img src="/resources/images/Down02.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
			                <% }%>
			                
		                    <!-- 매뉴얼3 -->
		                    <% if("KRLTD.0001".equals(sessionComCode)){%>
		                    	<a href="javascript:manualDown('B')"><li><p><%=CommonLang.get("HTITLE775")%><!-- 구매발주자 --></p> <img src="/resources/images/Down03.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
		                    <%}else if("KRKUMH0043".equals(sessionComCode)||"KRKUMH0044".equals(sessionComCode)||"KRKUMH0045".equals(sessionComCode)||"KRKUMH0046".equals(sessionComCode)||"KRKUMH0047".equals(sessionComCode)
			                		||"KRKUMH0048".equals(sessionComCode)||"KRKUMH0049".equals(sessionComCode)||"KRKUMH0050".equals(sessionComCode)||"KRKUMH0051".equals(sessionComCode)||"KRKUMH0052".equals(sessionComCode)
			                		||"KRKUMH0053".equals(sessionComCode)){%>
			                	<a href="javascript:manualDown('L3')"><li><p><%=CommonLang.get("HTITLE777")%><!-- 신규소싱 --></p><img src="/resources/images/Down03.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>	
		                    <%}else{%>
		                    	<a href="javascript:manualDown('C')"><li><p><%=CommonLang.get("HTITLE777")%><!-- 신규소싱 --></p><img src="/resources/images/Down03.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
		                    <%}%>
		                    
		                    <!-- 매뉴얼4 -->
		                    <% if("KRLTD.0001".equals(sessionComCode)){%>
		                    	<a href="javascript:manualDown('E')"><li><p> <%=CommonLang.get("HTITLE776")%><!-- 한화캘린더 설명서 --></p> <img src="/resources/images/Down04.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
		                    <%}else if("KRKUMH0043".equals(sessionComCode)||"KRKUMH0044".equals(sessionComCode)||"KRKUMH0045".equals(sessionComCode)||"KRKUMH0046".equals(sessionComCode)||"KRKUMH0047".equals(sessionComCode)
			                		||"KRKUMH0048".equals(sessionComCode)||"KRKUMH0049".equals(sessionComCode)||"KRKUMH0050".equals(sessionComCode)||"KRKUMH0051".equals(sessionComCode)||"KRKUMH0052".equals(sessionComCode)
			                		||"KRKUMH0053".equals(sessionComCode)){%>
								<a href="javascript:manualDown('L4')"><li><p><%=CommonLang.get("HTITLE526")%><!-- 관리자 --></p> <img src="/resources/images/Down04.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>			                		
		                    <%}else{%>
		                    	<a href="javascript:manualDown('D')"><li><p><%=CommonLang.get("HTITLE526")%><!-- 관리자 --></p> <img src="/resources/images/Down04.png" /> <br/><span><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></span></li></a>
		                    <%}%>
			                </ul>
			            </div>
                       <% }%>
            <div class="NoticeList">
            	<h2>KeP <%=CommonLang.get("HTITLE730")%><!-- 공지사항 --><a href="javascript:showNoticeListPop()"><img src="/resources/images/NoticeMore.gif" /></a></h2>
                <ul>
                   <% 
                		Map<String,String> _ntBoardData = null;
                		if (_ntBoard == null || _ntBoard.size() == 0){
                		}else{
                			for (int i=0; i<_ntBoard.size(); i++){
                				_ntBoardData = _ntBoard.get(i);  
                    %>
                            	<li><p><a href="javascript:showDetailPop('<%=CommonUtil.bnvl(_ntBoardData.get("BTYPE"))%>','<%=CommonUtil.bnvl(_ntBoardData.get("BID"))%>','<%=CommonUtil.bnvl(_ntBoardData.get("GBN"))%>','<%=CommonUtil.bnvl(_ntBoardData.get("COMPANY"))%>');"><%=CommonUtil.nvl(_ntBoardData.get("SUBJECT"))%></a></p><p><%=CommonUtil.nvl(_ntBoardData.get("REG_DATE"))%></p></li>
                       <% }
                    }
                    %> 
                </ul>
            </div>
        </div>
     </div>
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
<!-----------------------------------------------------------------------------------------------footer------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
<!-----------------------------------------------------------------------------------------------footer------------------------------------------------------------------------------------------------------->
    
</div> 
</body>
</html>