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
//팝업함수호출400
function doPopFooter(str) {
	popupSel = str;
	
	switch (str) {
		case "privacy": // 개인정보취급
			window.open("/common/pop_privacy.do","pop_privacy","width=600, height=500, scrollbars =yes");
			break;
		case "email": // 메일
			openSearchPopup("/common/pop_email.do","", "400,250,no");
			break;
		case "isms": // isms
			openSearchPopup("/common/pop_isms.do","", "600,520,no");
			break;
	}
}
</script>
<div id="footWrap">
     <div id="footer">
        <address> Seoul Gangnam Post Office Bld 7th floor, Gaepo-Ro 619, Gangnam-Gu, Seoul-Si, Korea<br/>
        CEO : Bae Sung Bae │ Business Registration No : 107-81-85880 │ <br>Online Marketing Business Registration No : 2015-서울강남-03012 
        Tel : +82-2-3016-8989 │ Fax : +82-2-569-6724</address>
        <div class="FamilySite">
            <div id="FAMILY">
                <div class="FAMILY_select">
                    <p><a href="#">FAMILY SITE <span><img src="/resources/images/2016/br01.png" alt="" /></span></a>
                    <ul>
                        <li><a href="http://www.kepchina.cn">KePChina</a></li>
                        <li><a href="http://safety.koreab2b.com" >CMRO</a></li>
                        <li><a href="http://kway.koreab2b.com/jsp/index.jsp?null">Kway</a></li>
                        <li><a href="http://auction.koreab2b.com">KepAcution</a></li>
                    </ul>
                </div>
            </div>
        </div>
        <!--FamilySite끝-->
    </div>
</div>
    
    
    
    
