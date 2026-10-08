<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="keywords" content="" />
<meta name="description" content="" />
<title>Welcome to KoreaB2B.com</title>
<link rel="stylesheet" href="/resources/styles/2016_koreab2b_base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/2021_koreab2b.css" type="text/css">
<%
	String st_gbn = CommonUtil.nvl((String)request.getParameter("st_gbn"),"MRO");
%>
<script src="/resources/js/kep_common.js"></script>
</head>
<body>
<div id="pop_wrap">
  <div class="NPopTit" >개인정보처리방침 안내 </div>
  <div class="NPopSTit" >코리아이플랫폼(주)은(이하 회사는) 고객님의 개인정보를 중요시하며, 정보통신망용촉진 및 정보보호에 관한 법률을 준수하고 있습니다. 
    회사는 개인정보처리방침을 통하여 고객님께서 제공하시는 개인정보가 어떠한 용도와 방식으로 이용되고 있으며, 개인정보보호를 위해 어떠한 조치가 취해지고 있는지 알려드립니다. 
    회사는 개인정보처리방침을 개정하는 경우 웹사이트 공지사항(또는 개별공지)을 통하여 공지할 것입니다. </div>
  <div class="pop_privacy">
    <div id="00" name="#00" class="NPopSSTit">
      <ul>
        <li>1. <a href="#01">수집하는 개인정보 항목</a></li>
        <li>2. <a href="#02">개인정보의 수집 및 이용목적</a></li>
        <li>3. <a href="#03">개인정보의 보유 및 이용기간</a></li>
        <li>4. <a href="#04">개인정보의 파기절차 및 방법</a></li>
        <li>5. <a href="#05">개인정보 제공</a></li>
        <li>6. <a href="#06">수집한 개인정보의 위탁</a></li>
        <li>7. <a href="#07">이용자 및 법정대리인의 권리와 그 행사방법</a></li>
        <li>8. <a href="#08">개인정보 자동수집 장치의 설치, 운영 및 그 거부에 관한 사항</a></li>
        <li>9. <a href="#09">개인정보에 관한 민원서비스</a></li>
      </ul>
    </div>
    <br/>
    <br/>
    <br/>
    <div id="01" name="#01">
      <p class="NPopSSTit">1. 수집하는 개인정보 항목</p>
      <p> 회사는 회원가입, 상담, 서비스 신청 등을 위해 아래와 같은 개인정보를 수집하고 있습니다. <br />
        * 수집항목 이름 , 로그인ID , 휴대전화번호 , 이메일 , 회사명 , 부서 , 직책 , 회사전화번호 <br />
        * 개인정보 수집방법<br />
        홈페이지(회원가입) , 서면양식 , 전화/팩스를 통한 회원가입 </p>
    </div>
    <br/>
    <br/>
    <br/>
    <div id="02"  name="#02">
      <p class="NPopSSTit">2. 개인정보의 수집 및 이용목적</p>
      <p> 회사는 수집한 개인정보를 다음의 목적을 위해 활용합니다. <br />
        * 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산, 콘텐츠 제공, 구매 및 요금 결제, 물품배송 또는 청구지 등 발송 <br />
        * 회원관<br />
        회원제 서비스 이용에 따른 본인확인, 개인 식별, 불량회원의 부정 이용 방지와 비인가 사용 방지, 가입 의사 확인, 불만처리 등 민원처리, 고지사항 전달 </p>
    </div>
    <br/>
    <br/>
    <br/>
    <div id="03"  name="#03">
      <p class="NPopSSTit">3. 개인정보의 보유 및 이용기간</p>
      <p> 원칙적으로, 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 
        단, 관계법령의 규정에 의하여 보존할 필요가 있는 경우 회사는 아래와 같이
        관계법령에서 정한 일정한 기간 동안 회원정보를 보관합니다.<br />
        - 보존 항목 : 이름 , 로그인ID , 이메일 , 회사명 , 부서 , 직책 , 회사전화번호 <br />
        - 보존 근거 : 전자상거래등에서의 소비자보호에 관한 법률<br />
        - 보존 기간 : 5년 </p>
    </div>
    <br/>
    <br/>
    <br/>
    <div id="04"  name="#04">
      <p class="NPopSSTit">4. 개인정보 파기절차 및 방법</p>
      <p> 회사는 원칙적으로 개인정보 수집 및 이용목적이 달성된 후에는 해당정보를 지체없이 파기합니다. 파기절차 및 방법은 다음과 같습니다.<br />
        * 파기절차<br />
        회원님이 회원가입 등을 위해 입력하신 정보는 목적이 달성된 후 별도의 DB로옮겨져(종이의 경우 별도의 서류함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조) 일정 기간 저장된 후 파기되어집니다.
        별도 DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 보유되어지는 이외의 다른 목적으로 이용되지 않습니다.<br />
        * 파기방법<br />
        전자적 파일형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다. </p>
    </div>
    <br/>
    <br/>
    <br/>
    <div id="05" name="#05">
      <p class="NPopSSTit">5. 개인정보 제공</p>
      <p> 회사는 이용자의 개인정보를 원칙적으로 외부에 제공하지 않습니다.다만, 아래의 경우에는 예외로 합니다.<br />
        - 이용자들이 사전에 동의한 경우<br />
        - 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라<br />
        - 수사기관의 요구가 있는 경우 </p>
    </div>
    <br/>
    <br/>
    <br/>
    <div id="06"  name="#06">
      <p class="NPopSSTit">6. 수집한 개인정보의 위탁 </p>
      <p> 회사는 고객님의 동의없이 고객님의 정보를 외부 업체에 위탁하지 않습니다. 향후 그러한 필요가 생길 경우, 위탁 대상자와 위탁 업무 내용에 대해 고객님에게 통지하고 필요한 경우 사전 동의를 받도록 하겠습니다. </p>
    </div>
    <br/>
    <br/>
    <br/>
    <div id="07"  name="#07">
      <p class="NPopSSTit">7. 이용자 및 법정대리인의 권리와 그 행사방법</p>
      <p> 이용자 및 법정 대리인은 언제든지 등록되어 있는 자신 혹은 당해 만 14세(미만) 아동의 개인정보를 조회하거나 수정할 수 있으며 가입해지를 요청할 수도 있습니다.<br />
        <br />
        이용자 혹은 만 14세 미만 아동의 개인정보 조회, 수정을 위해서는 '개인정보변경'(또는 '회원정보수정' 등)을 가입해지(동의철회)를 위해서는 "회원탈퇴"를 클릭하여 본인 확인 절차를 거치신 후 직접 열람, 정정 또는 탈퇴가 가능합니다.
        혹은 개인정보관리책임자에게 서면, 전화 또는 이메일로 연락하시면 지체없이 조치하겠습니다.<br />
        <br />
        귀하가 개인정보의 오류에 대한 정정을 요청하신 경우에는 정정을 완료하기 전까지 당해 개인정보를 이용 또는 제공하지 않습니다. 또한 잘못된 개인정보를 제3자에게 이미 제공한 경우에는 정정 처리결과를 제3자에게 
        지체없이 통지하여 정정이 이루어지도록 하겠습니다.<br />
        <br />
        코리아이플랫폼(주)는 이용자 혹은 법정 대리인의 요청에 의해 해지 또는 삭제된 개인정보는 "코리아이플랫폼(주)가 수집하는 개인정보의 보유 및 이용기간"에 명시된 바에 따라 처리하고 그 외의 용도로 열람 또는 이용할 수 없도록 처리하고 있습니다.<br />
        <br />
      </p>
    </div>
    <br/>
    <br/>
    <br/>
    <div id="08"  name="#08">
      <p class="NPopSSTit">8. 개인정보 자동수집 장치의 설치, 운영 및 그 거부에 관한 사항</p>
      <p> 쿠키 등 인터넷 서비스 이용 시 자동 생성되는 개인정보를 수집하는 장치를 운영하지 않습니다.<br />
      </p>
    </div>
    <br/>
    <br/>
    <br/>
    <div id="09"  name="#09">
      <p class="NPopSSTit">9. 개인정보에 관한 민원서비스</p>
      <p> 회사는 고객의 개인정보를 보호하고 개인정보와 관련한 불만을 처리하기 위하여 아래와 같이 관련 부서 및 개인정보관리책임자를 지정하고 있습니다. </p>
    </div>
    <br/>
    <br/>
    <br/>
    <div id="10"  name="#10">
      <ul class="mgb_30" >
        <li>* 고객서비스담당 부서 : TPSP팀</li>
        <li>* 전화번호 : 02-3016-8989</li>
        <li>* 이메일 : leeshkep@koreab2b.com</li>
        <li>* 개인정보관리책임자 성명 : 이철</li>
        <li>* 전화번호 : 02-3016-8910</li>
        <li>* 이메일 : leechul@kolon.com</li>
      </ul>
      <p > * 귀하께서는 회사의 서비스를 이용하시며 발생하는 모든 개인정보보호 관련 민원을 개인정보관리책임자 혹은 담당부서로 신고하실 수 있습니다. 회사는 이용자들의 신고사항에 대해 신속하게 충분한 답변을 드릴 것입니다. </p>
    </div>
    <br/>
    <br/>
    <br/>
    <div name="#09">
      <p class="NPopSSTit">개인정보 처리방침 변경</p>
      <p> 
        <a href="javascript:doPopPrivacy('pop_privacy', '<%=st_gbn%>');">현 정책(클릭)</a> 
      </p>
    </div>
  </div>
  <div class="NPopbtnBox"><a href="javascript: window.close();" />
    <div class="NPopbtn" > 닫기 </div>
    </a></div>
</div>
<script type="text/javascript">

function doPopPrivacy(str, value1) {
	popupSel = str;
	
	//post 팝업 호출 정보
	var st_form_name = "pop_privacy";
	var st_popup_param = "st_gbn@@"+value1;
	var st_popup_option = "600,500,yes";
	var st_popup_url = "";
	
	switch (str) {
	case "pop_privacy_201408": // 개인정보취급 pop_privacy_201408
		st_popup_url = "/common/pop_privacy_201408.do";
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
		break;
	case "pop_privacy_201509": // 개인정보취급 pop_privacy_201509
		st_popup_url = "/common/pop_privacy_201509.do";
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
		break;
	case "pop_privacy_201604": // 개인정보취급 pop_privacy_201604
		st_popup_url = "/common/pop_privacy_201604.do";
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
		break;
	case "pop_privacy_201607": // 개인정보취급 pop_privacy_201607
		st_popup_url = "/common/pop_privacy_201607.do";
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
		break;
	}
}
</script>
</body>
</html>
