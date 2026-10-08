<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<link rel="stylesheet" href="/resources/styles/koreab2b_base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/koreab2b.css" type="text/css">
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script type="text/javascript" src="/resources/js/kep_common.js"></script>
<% 
	String sslurl2 = CommonUtil.getSslURL(request, "https"); 
%>
<script type="text/javascript">
 
function nextTime(){
	$('#loginForm').attr("method", "post");
    $('#loginForm').attr("action", "<%=sslurl2%>/login/logincertificate.do");
    $('#loginForm').submit();
}

function openCrossCert(){
	
	window.open("https://www.tradesign.net/ra/koreab2b",'privacy' , 'toolbar=1, location=1, status=1, menubar=1, scrollbars=1, resizable=1, top=0, left=0, width=1024, height=768');
	

}
</script>
</head>
<body>
<div class="wrap" >
<form id="loginForm" id="loginForm"  name="loginForm" method="post">
	<input type = "hidden" id="userId" name = "userId" value="${userId}"/>
	<input type = "hidden" id="password" name = "password"  value="${password}"/>
	<input type = "hidden" id="pageFlag" name = "pageFlag"  value="imsi"/>
</form>
	<div class="Login_Certificate">
    	<div class="BTitle">협력사 <span class="FontBlue">공동인증서 시스템 도입</span> 관련 안내</div>
        <div class="CTxt">평소 귀사의 적극적인 협조와 지원에 깊은 감사를 드리며, 아울러 일익 번창하시기를 기원합니다. 당사는 투명한 견적 및 보안기능 강화, 공정성 제고 등을 위해서, </br>
        아래와 같이 공동인증서 시스템을 통한 로그인 체계로 변경 및 전자계약 시스템 도입을 추진하오니, 이점 확인하시길 바랍니다.</div>
         
        <div class="Layer01">
        	<p class="Layer01Tit" >◎ 공동인증서 및 전자계약 시스템 도입 안내</p>
            <p>1.  공인인증을 통한 전자계약 시행</br>
            <span class="FontBlue">2.  두산인프라코어 협력사분들은 견적 제출 시 공동인증서 시스템을 통한 인증 실시 후 기존 견적 제출 방식에서 통합 로그인으로 변경예정, 별도 전자공인 인증 신규발급 불필요</span> </p>
            <div class="SpecialBlue"><span class="FontYellow">정책시행일 : 2014년 2월 11일(화)부터 시행 (로그인 쳬계 변경 및 전자계약 시행)</span> &nbsp;※ 기업 범용 공동인증서를 보유하신 경우 사용 가능하오니, 인증서를 통한 로그인 진행 바랍니다. </div>
        </div>
        
        <div class="Layer01">
        	<p class="Layer01Tit" >◎ 인증서 발행 시 유의점 </p>
            <p>1. 발행 비용 : 기업범용 - 88,000원 / KeP 전용 - 9,900원(VAT포함)</br>
			   2. 구비서류 방문 접수 시 당일 발급 가능</br>
			   3. 서류 접수처 - 기업 범용 : 한국전자인증 또는 각 지역 상공회의소 (한국전자인증 홈페이지 서류접수처 참고)</br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
             - KeP 전용 : 서울 3곳 (교대, 충무로, 구로), 수원  그 외 지역의 경우 <b><span class="FontRed">찾아가는 서비스</span></b>를 통한 서류접수 진행</p> 
            
            <p>4. 인증서 발급 관련 문의 : 한국전자인증 고객센터 1566-0566  / 인증서 도입 관련 문의 : KeP 구매기획팀 박지수 선임 02-3016-7251 </p>
            <div class="SpecialGray"><span class="FontRed"><b>※ 찾아가는 서비스란?</b></span>
            &nbsp;&nbsp;인증서 신청자 분께서 구비서류를 준비하신 후 직접 우편발송을 하는 것이 아닌 찾아가는 서비스를 신청 (서비스 비용 3,470원) 하시면  우체국 집배원께서 직접 방문 후 서류 접수를 대행해주는 서비스 입니다.&nbsp;
             이 서비스를 신청하실 경우 구비 서류를 준비 하신 후 팩스번호  02-6919-1714/1716/1719로 전송을 먼저 해 주셔야 합니다. &nbsp;또한, <span class="FontRed">인증서 발급까지 약 6~9일의 시간이 소요됩니다.</span></div>
        </div>
        
        <div class="Layer02">
            <p class="Layer02Tit" >◎ 구비서류</p>
            <p><span class="FontBlue"><b>1. 공인인증 서비스 신규 신청서 원본 1부</b></span></br>
            &nbsp;&nbsp; - 대표자 제출시 : 대표자의 자필서명</br>
            &nbsp;&nbsp; - 대리인 제출시 : 위임장 작성 및 개인(대표) / 법인 인감증면서 동일 인감도장 날인</p>
            <p><span class="FontBlue"><b>2. 사업자등록증 사본 1부</b></span></p>
            <p><span class="FontBlue"><b>3. 대표자 신분증 앞 / 뒤 사본 1부(원본지참)</b></span></br>
            &nbsp;&nbsp; - 대리인 신청 시 대리인 신분증 앞/뒤 사본 1부(원본지참)</br>
            &nbsp;&nbsp; - 주민등록증, 운전면허증(구 운전면허증 불가), 여권 </p>
           <div class="L01">
                <p><span class="FontBlue"><b>4. 대리인 신청 시 법인인감증명서 원본 1부(최근 6개월 이내 발급)</b></span></br>
                &nbsp;&nbsp; - 대표자 2인이상 사업자 추가제출 서류</br>
                &nbsp;&nbsp; - 공동대표 : 신청서에 모든 대표의 인감날인(인감증명서상 동일도장날인), </br>
                &nbsp;&nbsp;&nbsp;&nbsp; 모든 대표의 인감증명서 원본, 모든대표의 신분증 앞/뒤 사본</br>
                &nbsp;&nbsp; - 각자대표 : 법인등기부등본 제출용 1부 첨부</p>
                <div class="SpecialBlack">비영리기관, 공공기관은 인감증명서 관련내용 고객센터(1566-0566)로 문의요망</div>
                <p><span class="FontRed"><b>※ 아직 인증서 발급 받지 않은 협력사는 신속히 발급 받아 인증 로그인으로 진행하시기 바랍니다.</br> 미인증에 따른 불이익이 발생할 수 있습니다.</b></span></p>
       		</div>
        </div>
        <div class="LayerBtn">
        	<a href="javascript:openCrossCert();"><span class="LayerBtnBlue">공동인증서 발급안내 >></span></a>&nbsp;
            <a href="javascript:nextTime();"><span class="LayerBtnRed">임시로그인하기 >></span></a>&nbsp;&nbsp; 
            <img src="/resources/images/main/login_certificate.png" />
        </div>
    </div>
</div>
</body>
</html>

