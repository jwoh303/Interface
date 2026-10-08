<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	SessionInfo _f_sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String fsslurl = CommonUtil.getSslURL(request, "http");
	String footer_session_user_lang = "";//로그인 사용자 언어 정보
	String footer_session_com_code = ""; //로그인 사용자 고객사 코드 정보
	if (_f_sessionInfo != null){
		footer_session_user_lang = CommonUtil.nvl((String)_f_sessionInfo.getLang());
		footer_session_com_code = CommonUtil.nvl((String) _f_sessionInfo.getComCode());
	}
%>
<script type="text/javascript">
//팝업함수호출
function doPopFooter(str) {
	popupSel = str;
	
	switch (str) {
		case "privacy": // 개인정보취급
			window.open("/common/pop_privacy.do","pop_privacy","width=1000, height=600, scrollbars =yes");
			break;
	}
}
function manualDown(type){
	if("<%=footer_session_com_code%>" == "KRCHOK0003" || "<%=footer_session_com_code%>" == "KRCHOK0004" || "<%=footer_session_com_code%>" == "KRCHOK0005"
			|| "<%=footer_session_com_code%>" == "KRCHOK0006"){
		location.href="/resources/excel/work/MAIN/Buyer_Manual_CHOKWANG_PAINT_V2.zip";
	}else if("<%=footer_session_com_code%>" == "KRS-OI0002"){
		//에쓰오일 매뉴얼 다운로드
		location.href="/resources/excel/work/MAIN/Buyer_Manual_SOIL_V1.0.zip";	
	}else{
		if(type=="A"){location.href="/resources/excel/work/MAIN/Buyer_Manual_PR_v2_1.zip";}
		else if(type=="B"){location.href="/resources/excel/work/MAIN/Buyer_Manual_PO_v2_1.zip";}
		else if(type=="C"){location.href="/resources/excel/work/MAIN/Buyer_Manual_Sourcing_v2_1.zip";}
		else if(type=="D"){location.href="/resources/excel/work/MAIN/Buyer_Manual_MASTER_v2_1.zip";}
		else if(type=="E"){location.href="/resources/excel/work/MAIN/2018_Hanhwa_Calendars_Description_Manual.zip";}
		else if(type=="F"){location.href="/resources/excel/work/MAIN/2020_HwanIn_Manual.zip";}
		else if(type=="G"){location.href="/resources/excel/work/MAIN/Chung-AngUniv_Buyer_Manual_PR.zip";}
		else if(type=="H"){location.href="/resources/excel/work/MAIN/Chung-AngUniv_Buyer_Manual_PO.zip";}
		else if(type=="I"){location.href="/resources/excel/work/MAIN/2022_Lottechilsung_PR.zip";}
		else if(type=="J"){location.href="/resources/excel/work/MAIN/2022_AEKYUNG_USER.zip";}
		else if(type=="K"){location.href="/resources/excel/work/MAIN/2022_AEKYUNG_ADMIN.zip";}
		else if(type=="L1"){location.href="/resources/excel/work/MAIN/2023_KUMHO_PR.zip";}
		else if(type=="L2"){location.href="/resources/excel/work/MAIN/2023_KUMHO_PO.zip";}
		else if(type=="L3"){location.href="/resources/excel/work/MAIN/2023_KUMHO_SOURCING.zip";}
		else if(type=="L4"){location.href="/resources/excel/work/MAIN/2023_KUMHO_ADMIN.zip";}
	}
	    
} 
function manualDown_v2(){
// 	location.href="/resources/excel/work/MAIN/Manual.zip";
	window.open('/resources/html/main/notice/고객사매뉴얼_통합_v3.1.pdf', '_blank');
}
function sgsManualDown(type){ 

		if(type=="A"){
			location.href="/resources/excel/work/MAIN/SGS_Manual_PO_v2019.zip";
		}else if(type=="B"){
			location.href="/resources/excel/work/MAIN/SGS_Manual_SO_v2019.zip";
		}
	    
}
</script>
<footer class="footer" id="footer">
	<div class="footer_wrap">
			<%//사용자 언어타입이 영어일 경우 주소만 표기
			if(footer_session_user_lang.equals("EN")) {%>
				<section>
					<h2><img src="/resources/imgs/logo.png" /></h2>
		            <address>   
		                <ul>
		                    <li>Seoul Gangnam Post Office Bld 7th floor, Gaepo-Ro 619, Gangnam-Gu, Seoul-Si, Korea │CEO : Bae Sung Bae <br/> Business Registration No : 107-81-85880  │  Online Marketing Business Registration 2015-서울강남-02012 │ Tel +82-2-3016-8989 │ Fax +82-2-569-6724</li>
		                </ul>
		            </address>
		            <div class="copy">CopyrightⓒKorea e Platform. All Right Reserbed. </div>
		            <!--div class="isms"><img src="/resources/imgs/isms.png"></img><p>[인증범위] 온라인 구매대행 서비스 운영(코리아비투비)<br />[유효기간] 2021.11.03 ~ 2024.11.02</p></div-->           
		        </section>
			<%}else{ %>
				<section>
		            <h2><img src="/resources/imgs/logo.png" /></h2>
		            
		            <div class="Manual-wrapper" id="downloadArea">
			                <button class="Manual-button" id="downloadBtn"> <%=CommonLang.get("HTITLE774")%><!-- 매뉴얼 다운로드 --><span class="arrow" id="arrowIcon" style="cursor: pointer;">  <img src="/resources/imgs/manual_icon.png" alt="화살표" style=" vertical-align:middle;"/></span></button>
			                <div class="Manual-list" id="dropdownList">
			                  <div class="ManualTit"> <%=CommonLang.get("HTITLE774")%><!-- 매뉴얼 다운로드 --></div>
			                  <div class="close-btn" id="closeBtnFooter"><img src="/resources/imgs/manual_icon2.png" alt="화살표" style=" vertical-align:middle;"/></div>
			                  <ul>
			                    <!-- 매뉴얼1 -->
			                		<a href="javascript:manualDown_v2()"><li><%=CommonLang.get("HTITLE1502")%><!-- 매뉴얼 --> <img src="/resources/imgs/Icon_Download.png" /></li></a>
			                  </ul>
			                </div>
		            </div>
		            <script>
		                const downloadBtn = document.getElementById('downloadBtn');
		                const dropdownList = document.getElementById('dropdownList');
		                const arrowIcon = document.getElementById('arrowIcon');
		                const downloadArea = document.getElementById('downloadArea');
		                const closeBtnFooter = document.getElementById('closeBtnFooter');
		                const arrowImg = arrowIcon.querySelector('img');
		
		                // 마우스 클릭 시 열기
		                arrowIcon.addEventListener('click', function(){
		                  dropdownList.classList.add('active');
		                  arrowIcon.classList.add('up');
		                  arrowImg.src = '/resources/imgs/manual_icon.png'; // 위 화살표 이미지 경로
		                });
		                
// 		                // 마우스 벗어나면 닫기
// 		                downloadArea.addEventListener('mouseleave', function() {
// 		                  dropdownList.classList.remove('active');
// 		                  arrowIcon.classList.remove('up');
// 		                  arrowImg.src = '/resources/imgs/manual_icon.png'; // 아래 화살표 이미지 경로
// 		                });
		                
		                // 닫기 버튼 클릭 시
		                closeBtnFooter.addEventListener('click', function(){
		                  dropdownList.classList.remove('active');
		                  arrowIcon.classList.remove('up');
		                  arrowImg.src = '/resources/imgs/manual_icon.png';
		                });
		
		            </script>           
		        </section>
		        <section>
		            <div class="boardinfo">
		              <ul>
		                <li><a href="javascript:doPopFooter('privacy');"><%=CommonLang.get("HTITLE995")%><!-- 개인정보처리방침 --></a></li>
		                <li><a href="#" onClick="poptype01('<%=fsslurl%>');"><%=CommonLang.get("HTITLE996")%><!-- 이메일무단수집거부 --></a></li>
		                <li><a href="https://www.tradesign.net/ra/koreab2b" target="_blank"><%=CommonLang.get("HTITLE997")%><!-- 공인인증서 발급안내 --></a></li>
		                <li><a href="https://www.ftc.go.kr/bizCommPop.do?wrkr_no=1078185880" target="_blank"><%=CommonLang.get("HTITLE998")%><!-- 사업자정보확인 --></a></li>
                <li><a href="https://www.ekdp.com/ethics/main/main.do" target="_blank"><%=CommonLang.get("HTITLE1002") %><!-- 윤리경영제보 --></a></li>
              </ul>
              <div class="Callcenter" ><p><span><%=CommonLang.get("HTITLE739")%><!-- 고객센터 --></span>02-3016-8989</p>  <p><span><%=CommonLang.get("HTITLE999") %><!-- 팩스 --></span>02-569-9724</p></div>
            </div>
        </section>
		        <section>
		            <address>   
		                <ul>
		                    <li><span><%=CommonLang.get("HTITLE1000") %><!-- 대표이사 --></span>오승엽</li>
		                    <li><span><%=CommonLang.get("HTITLE345") %><!-- 주소 --></span>서울특별시 강남구 개포로 619 서울강남우체국빌딩 7층</li>
		                    <li><span><%=CommonLang.get("HTITLE335") %><!-- 사업자등록번호 --></span>107-81-85880</li>
		                    <li><span><%=CommonLang.get("HTITLE1001") %><!-- 통신판매업신고번호 --></span>2015-서울강남-03012 </li>
		                </ul>
		            </address>
		            <div class="copy">CopyrightⓒKorea e Platform. All Right Reserbed. </div>
		            <!--div class="isms"><img src="/resources/imgs/isms.png"></img><p>[인증범위] 온라인 구매대행 서비스 운영(코리아비투비)<br />[유효기간] 2021.11.03 ~ 2024.11.02</p></div-->           
		        </section>
			<%} %>
        
    </div>
  </footer>