<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
	String fsslurl = CommonUtil.getSslURL(request, "http"); 
%>
<script type="text/javascript">
$(function(){
// 셀렉트박스
	$('.FAMILY_select p a').click(function(e){
			if($(".FAMILY_select p").hasClass("on") == true){
				$('.FAMILY_select ul').hide();
				$('.FAMILY_select p').removeClass('on');
			}else{
				$('.FAMILY_select ul').show();
				$('.FAMILY_select p').addClass('on');
			};
			e.preventDefault();
	});
	$('.FAMILY_select li').click(function(){
		$('.FAMILY_select ul').hide();
		$('.FAMILY_select p').removeClass('on');
	});

});
//팝업함수호출
function doPopFooter(str) {
	popupSel = str;
	
	switch (str) {
		case "privacy": // 개인정보취급
			window.open("/common/pop_privacy.do","pop_privacy","width=1000, height=600, scrollbars =yes");
			break;
		case "email": // 메일
			openSearchPopup("/common/pop_email.do","", "400,250,no");
			break;
		case "isms": // isms
			openSearchPopup("/common/pop_isms.do","", "600,520,no");
			break;
	}
}
function uiOpen(){
	var ui = document.getElementById("uiSelect");
	ui.style.display = "block";
}
</script>
	<div id="footWrap">
   	 	 <div id="footer">
            <ul class="article">
                <li><a href="javascript:doPopFooter('privacy');"><span style="color:#ee3212">개인정보처리방침</span></a></li><!--pop_privacy.html-->
                <li><a href="javascript:MovePage_2016('<%=httpurl%>','04', '02');">이용약관안내</a></li><!--sub04_join.html-->
                <li><a href="javascript:doPopFooter('email');">이메일무단수집거부</a></li><!--pop_email.html-->
                <li><a href="https://www.tradesign.net/ra/koreab2b" target="_blank">공동인증서발급안내</a></li>
            	<li><a href="https://www.ftc.go.kr/bizCommPop.do?wrkr_no=1078185880" target="_blank">사업자정보확인</a></li>
                <li><a href="http://www.ekdp.com/ethics/main/main.do"  target="_blank">윤리경영제보</a></li>
            </ul>
            <address> 서울 강남구 개포로 619 서울강남우체국빌딩 7층 │ 대표이사:오승엽 │ 사업자등록번호 107-81-85880 </br>
            통신판매업신고번호 2015-서울강남-03012 │ 전화 02.3016.8989 │ 팩스 02.569.6724 </address>
            <div class="footCate">
            	<div class="ISMS">
                	<a href="javascript:doPopFooter('isms');"><img src="/resources/images/2016/isms.png" alt="verisign" ></a>
                	<p>[인증범위] 온라인 구매대행 서비스 운영(코리아비투비)</br>[유효기간] 2024.11.03 ~ 2027.11.02</p>                 
                </div>
                <!--FamilySite-->
                <div class="FamilySite">
                    <div id="FAMILY">
                        <div class="FAMILY_select">
                            <p><a href="#">FAMILY SITE <span><img src="/resources/images/2016/br01.png" alt="" /></span></a>
                            <ul>
                                <li><a href="https://safety.koreab2b.com" target="_blank">건설MRO</a></li>
                                <li><a href="https://kway.koreab2b.com" target="_blank">Kway</a></li>
                                <li><a href="http://www.kepchina.cn" target="_blank">중국법인</a></li>
                                <li><a href="http://www.koreab2b-eu.com" target="_blank">유럽법인</a></li>
<!--                                 <li><a href="#" onclick="javascript:uiOpen();"></a></li> -->
                            </ul>
                        </div>
                    </div>
                </div>
                <!--FamilySite끝-->
            </div>
        </div>
    </div>