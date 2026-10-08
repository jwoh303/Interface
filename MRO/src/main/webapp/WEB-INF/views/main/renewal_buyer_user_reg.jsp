<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<%@ include file="/WEB-INF/views/common/include/mainHeader_v2.jsp" %>
<script type="text/javascript" src="/resources/js/common/HttpUtil.js"></script>
<script type="text/javascript" src="/resources/js/common/PopupUtil.js"></script>
<style>
.ThLTdL th, .ThLTdL td { border-bottom:1px solid #e2e8f0; }
.input-error { border: 2px solid #F6495F !important; background-color: #FFF5F5 !important; }
.select-error { border: 2px solid #F6495F !important; background-color: #FFF5F5 !important; }
</style>
</head>
<body onload="kep_onload_view()">
<form id="contentForm" name="contentForm" method="post" autocomplete="off">
<!-- hidden 필드 (레거시 동일) -->
<input type="hidden" id="id_check_flag" name="id_check_flag" value="N" />
<input type="hidden" name="chkPassword1" id="chkPassword1" value="N" />
<input type="hidden" name="chkPassword2" id="chkPassword2" value="N" />
<input type="hidden" id="st_business_cond" name="st_business_cond" value="B" />
<input type="hidden" id="st_ceo_reg_no" name="st_ceo_reg_no" value="" />
<input type="hidden" id="st_com_code" name="st_com_code" value="" />
<input type="hidden" id="st_role" name="st_role" value="" />
<input type="hidden" id="st_zip_code" name="st_zip_code" value="" />
<input type="hidden" id="st_zip_key" name="st_zip_key" value="" />
<input type="hidden" id="st_address" name="st_address" value="" />
<input type="hidden" id="st_address_dt" name="st_address_dt" value="" />
<input type="hidden" id="st_address_eng" name="st_address_eng" value="" />
<input type="hidden" id="st_country" name="st_country" value="KR" />
<input type="hidden" id="st_city" name="st_city" value="KRSEL" />
<!-- 스켈레톤 UI에 없는 레거시 필드 → hidden 기본값 -->
<input type="hidden" id="st_user_type" name="st_user_type" value="U" />
<input type="hidden" id="st_lang" name="st_lang" value="KR" />
<input type="hidden" id="st_user_name_eng" name="st_user_name_eng" value="" />
<input type="hidden" id="st_purchase_dept" name="st_purchase_dept" value="" />
<input type="hidden" id="st_purchase_dept_text" name="st_purchase_dept_text" value="" />
<input type="hidden" id="st_sms_recv_flag" name="st_sms_recv_flag" value="N" />
<input type="hidden" id="st_mail_recv_flag" name="st_mail_recv_flag" value="" />
<!-- UI 분할 입력 → JS에서 합쳐서 저장할 hidden -->
<input type="hidden" id="st_email" name="st_email" value="" />
<input type="hidden" id="st_phone_number" name="st_phone_number" value="" />
<input type="hidden" id="st_fax_number" name="st_fax_number" value="" />
<input type="hidden" id="st_mobile_phone" name="st_mobile_phone" value="" />
<input type="hidden" id="st_department" name="st_department" value="" />
<input type="hidden" id="st_position" name="st_position" value="" />
<input type="hidden" id="st_dely_to_location" name="st_dely_to_location" value="" />

<div class="wrap">

	<div class="ComNavigation">
      <div class="navigationBar">
        <ul>
        <li onclick="location.href='/main/renewal_buyer_join.do'" class="ON">고객사 가입 안내</li>
        <li onclick="location.href='/main/renewal_seller_join.do'">협력사 가입 안내</li>
        <li onclick="location.href='/main/renewal_faq.do'">자주 묻는 질문</li>
        </ul>
      </div>
    </div>
	<!-- 컨텐츠 -->
    <div class="containerSub">
      <div class="h80"></div>
      <div class="ComJoinTitLarge" >사용자 등록 요청</div>
      <div class="ComJoinTitMedium">회사 정보 <span class="F6495F">*표시는 필수 입력사항입니다.</span></div>
	  <table class="ThLTdL" width="100%">
        <colgroup>
          <col width="150px" />
          <col width="280px" />
          <col width="150px" />
          <col width="270px" />
          <col width="140px" />
          <col width="280px" />
        </colgroup>
        <tr>
          <th><span class="F6495F">*</span> 회사</th>
          <td><div class="SearchBuyer" style="width:250px; height:auto" id="st_com_div">
              <input type="text" id="st_com_name_loc" name="st_com_name_loc" style="width:85%; cursor:pointer;" readonly value="" onclick="doPop('com','','')" />
              <button type="button" onclick="doPop('com','','')">검색버튼</button>
            </div>
          </td>
          <th><span class="F6495F">*</span> 부서</th>
          <td><div class="SearchBuyer" style="width:240px;  height:auto" id="st_dept_div">
              <input type="text" id="st_department_text" name="st_department_text" style="width:85%; cursor:pointer;" readonly value="" onclick="doPop('dept','','')" />
              <button type="button" onclick="doPop('dept','','')">검색버튼</button>
            </div>
          </td>
          <th><span class="F6495F">*</span> 직급</th>
          <td><div class="SearchBuyer" style="width:240px;  height:auto" id="st_pos_div">
              <input type="text" id="st_position_text" name="st_position_text" style="width:85%; cursor:pointer;" readonly value="" onclick="doPop('position','','')" />
              <button type="button" onclick="doPop('position','','')">검색버튼</button>
            </div>
          </td>
        </tr>
	  </table>
      <div class="ComJoinTitMedium mt50">사용자 정보</div>
	  <table class="ThLTdL" width="100%">
        <colgroup>
          <col width="150px" />
          <col width="700px" />
          <col width="140px" />
          <col width="280px" />
        </colgroup>
        <tr>
          <th><span class="F6495F">*</span> ID</th>
          <td><input class="input30" style="width:270px;ime-mode:disabled;" id="st_user_id" name="st_user_id" maxlength="20" value="" type="text" onkeyup="idKeyUp()" /> <button type="button" class="ButDarkGray_Small" onclick="doAction('idCheck')">중복확인</button>
           <span id="idCheckMsg" style="font-size:85%; display:none;">사용가능한 ID 입니다.</span>
          </td>
          <th><span class="F6495F">*</span> 이름</th>
          <td><input class="input30" style="width:230px" id="st_user_name_loc" name="st_user_name_loc" maxlength="40" type="text" autocomplete="off" onkeyup="fnCheckInputByte(this, 40);" onchange="fnCheckInputByte(this, 40);" /></td>
        </tr>
        <tr>
          <th rowspan="2"><span class="F6495F">*</span> 비밀번호</th>
          <td rowspan="2">
            <p style="width:110px; float:left; font-size:95%; ">비밀번호</p>
            <input class="input30" style="width:160px;ime-mode:disabled;" id="st_password" name="st_password" maxlength="20" type="password" autocomplete="new-password" onchange="doAction('pwdCheck1')" />
            <span style="font-size:85%; margin-left:5px">비밀번호는 영문, 숫자, 특수문자 조합으로 8자 이상 사용해야 합니다.</span>
            <p class="h5"></p>
            <p style="width:110px; float:left; font-size:95%; ">비밀번호 확인</p>
            <input class="input30" style="width:160px;ime-mode:disabled;" id="st_password_confirm" name="st_password_confirm" maxlength="20" type="password" autocomplete="new-password" onchange="doAction('pwdCheck2')" onkeyup="validatePassword()" />
            <span id="pwdMatchMsg" style="font-size:85%; margin-left:5px; font-weight:600; color:#F6495F; display:none;">불일치</span>
          </td>
          <th><span id="legacy_span1" class="f2f7ff">*</span> <span id="legacy_span2">사번</span></th>
          <td><input class="input30" style="width:230px" id="st_legacy_user_id" name="st_legacy_user_id" maxlength="20" type="text" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" /></td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> 휴대폰</th>
          <td><input class="input30" style="width:52px" id="st_mobile_phone1" name="st_mobile_phone1" maxlength="3" type="text" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> - <input class="input30" style="width:52px" id="st_mobile_phone2" name="st_mobile_phone2" maxlength="4" type="text" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> - <input class="input30" style="width:55px" id="st_mobile_phone3" name="st_mobile_phone3" maxlength="4" type="text" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /></td>
        </tr>
        <tr>
          <th rowspan="2"><span class="F6495F">*</span> 이메일</th>
          <td rowspan="2">
            <input class="input30" style="width:270px;ime-mode:disabled;" id="st_email1" name="st_email1" type="text" value="" /> @
            <input class="input30" style="width:140px;ime-mode:disabled;" id="st_email2" name="st_email2" type="text" value="" />
            <select id="st_email_domain" name="st_email_domain" class="Select" style="width:190px" onchange="setEmailDomain()">
              <option value="">직접입력</option>
              <option value="naver.com">naver.com</option>
              <option value="gmail.com">gmail.com</option>
              <option value="daum.net">daum.net</option>
              <option value="hanmail.net">hanmail.net</option>
              <option value="nate.com">nate.com</option>
              <option value="hotmail.com">hotmail.com</option>
              <option value="yahoo.co.kr">yahoo.co.kr</option>
            </select><br/>
            <label class="CheckMediumLabel" style="margin:0px;"><input type="checkbox" id="mail_recv_chk" name="mail_recv_chk" value="Y" checked /><span class="CheckMediumCustom"></span>이메일 수신</label>
            <p class="Smalltxt F6495F ml15" style="display:inline;">※ 수신 미동의 시 계정 분실 확인을 위한 정보공유 및 요청에 대한 피드백을 받으실 수 없습니다.</p>
          </td>
          <th><span class="F6495F">*</span> 전화번호</th>
          <td><input class="input30" style="width:52px" id="st_phone_number1" name="st_phone_number1" maxlength="4" type="text" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> - <input class="input30" style="width:52px" id="st_phone_number2" name="st_phone_number2" maxlength="4" type="text" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> - <input class="input30" style="width:55px" id="st_phone_number3" name="st_phone_number3" maxlength="4" type="text" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /></td>
        </tr>
        <tr>
          <th><span class="f2f7ff">*</span>팩스번호</th>
          <td><input class="input30" style="width:52px" id="st_fax_number1" name="st_fax_number1" maxlength="4" type="text" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> - <input class="input30" style="width:52px" id="st_fax_number2" name="st_fax_number2" maxlength="4" type="text" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> - <input class="input30" style="width:55px" id="st_fax_number3" name="st_fax_number3" maxlength="4" type="text" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /></td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> 배송지 정보</th>
          <td colspan="3"><input class="input30" style="width:573px" id="st_dely_text" name="st_dely_text" type="text" readonly value="" />
            <button type="button" class="ButDarkGray_Small" style="width:70px" onclick="doPop('location','','')">검색</button>
          </td>
        </tr>
	  </table>

      <!-- 이용약관 섹션 -->
      <div class="ComJoinTitMedium mt50">이용약관</div>
      <div class="LawGray" style="height:158px">
          총칙<br />
          <br />
          - 목적<br />
          <p>이 약관은 전기통신사업법 등 관련 법령에 의하여 코리아이플랫폼㈜가 운영하는 전자상거래 www.KoreaB2B.com 사이트

            (이하 "회사"라고 합니다.)가 제공하는 전자상거래의 이용조건 및 절차에 관한 사항을 규정함을 목적으로 합니다.</p>
          - 약관의 효력 및 게시,변경
          <p>1) 이 약관은 회사가 제공하는 서비스 화면에 게시하거나 기타의 방법으로 이용 고객 또는 회원에게 공지함으로써 효력을

            발생합니다.<br />
            2) 회사는 영업상 중요 사유 등 합리적인 사유가 발생하여 필요하다고 인정되는 경우 이 약관을 변경할 수 있으며, 변경된

            약관은 제 1항과 같은 방법으로 공지함으로써 효력을 발생합니다.</p>
          - 약관 외 준칙 및 관련 법령과의 관계
          <p>1) 이 약관에 명시되지 않은 사항은 전기통신기본법, 전기통신사업법,약관의 규제 등에 관한 법령, 전자상거래 기본법, 전자

            서명법, 정보통신망 이용촉진 등에 관한 법률, 방문판매등에 관한 법률, 소비자보호법 등 관련 법령의 규정과 일반

            상관례에 의합니다.<br />
            2) 회사가 제공하는 서비스를 통하여 회원 상호간에 이루어진 거래에 관하여는 방문판매 등에 관한 법률, 전자상거래기본법,

            소비자보호법 등 관련 법령이 우선적으로 적용되고, 회원은 이 약관 규정을 들어 거래상대방에 대하여 면책을 주장 할

            수는 없습니다.</p>
          - 용어의 정의
          <p>1) 이용자 : 회사가 제공하는 서비스에 접속하여 이 약관에 따라 서비스를 제공받는 회원 및 비회원을 말합니다.<br />
            2) 회원 : 서비스를 제공받기 위하여 회사의 승낙하에 회원ID를 부여받은 자를 말하며, 회사의 정보를 지속적으로 제공받으며

            회사가 제공하는 서비스를 계속적으로 이용할 수 있는 자로서기업회원을 말합니다.<br />
            3) 비회원 : 회원에 가입하지 않고 서비스를 이용하는 자를 말합니다.<br />
            4) ID : 회원의 식별과 회원의 서비스 이용을 위하여 회원이 선정하고 회사가 승인하여 회사에 등록된 문자와 숫자의 조합을

            말합니다.<br />
            5) 비밀번호(Password) : 회원의 동일성 확인과 회원의 권익 및 비밀보호를 위하여 회원 스스로가 설정하여 회사에 등록한

            문자와 숫자의 조합을 말합니다.<br />
            6) 검수 : 제공된 물품, 상품 및 용역등에 대한 변질, 파손, 하자, 등을 외관으로 검사하는 것을 말합니다.<br />
            7) 구매자 : 회사의 서비스를 통하여 물품을 구입할 의사로 소정의 양식(EDI)에 맞춰 등록한 회원을 말합니다.<br />
            8) 판매자 : 회사의 서비스를 통하여 물품을 판매할 의사로 소정의 양식(EDI)에 맞춰 등록한 회원을 말합니다.<br />
            9) 서비스 중지 : 공공의 이익 또는 회사내의 규정에 위배되었을 경우 회사가 이용자서비스를 제한 하는 것<br />
            10) 해지 : 회사 또는 이용자가 이용계약 체결 후 서비스 이용계약을 해약하는 것<br />
            11) 기타 이 약관에서 사용하는 용어의 정의는 동조에서 정하는 것을 제외하고는 일반적인 상관례 및 관계법령에 따릅니다.</p>
          회원의 가입 및 해지<br />
          <br />
          - 회원 가입 및 자격
          <p>1) 회원가입은 무료이며 업체회원에 한하여 등록할 수 있고, 회원의 의사에 의하여 소정의 양식을 기재하여 등록하며

            회사에서 등록처리를 함으로서 성립됩니다.<br />
            2) 업체회원은 법인 및 개인을 막론하고 사업자등록을 하여 해당기관으로부터 증명서를 교부받은 업체(단체포함)로서

            정당한 상거래를 행하는 자를 말합니다.<br />
            3) 이용신청자가 회원으로 등록하기 위해서는 이 약관의 내용과 이 약관이 이용 계약의 일부가 됨을 동의하여야 합니다.<br />
            4) 회사는 다음의 사유가 있을 시 회원의 가입을 거절하거나 자격을 박탈할 수 있습니다.<br />
            1. 기재내용을 허위로 기록할 경우<br />
            2. 서비스를 이용함에 있어 부당한 방법으로 허용된 목적범위 외의 행위를 할 경우<br />
            3. 다른 회원의 서비스 이용에 현저한 지장을 초래하는 경우<br />
            4. 사회의 안녕 질서 혹은 미풍양속을 저해하는 경우<br />
            5. 본 약관을 위반하는 경우<br />
            6. 이미 가입된 회원의 이름 및 주민등록번호와 동일한 경우<br />
            7. 기타 관계법령 등이 정한 경우나 회원으로서의 자격을 유지하는 것이 부적절 하다고 판단되는 경우<br />
            8. 이용신청고객이 미성년자, 한정치산자, 금치산자인 경우</p>
          - 회원ID부여 및 변경 등
          <p>1) 회사는 회원에 대하여 회사의 공지, 서비스 이용안내에서 정하는 바에 따라 회원ID를 부여합니다.<br />
            2) 회원ID는 다음 각 호의 1에 해당하는 경우에 회원은 회사에 회원ID 변경을 요청할 수 있습니다.<br />
            1. 회원ID가 회원의 전화번호 또는 주민등록번호 등으로 등록되어 사생활 침해가 우려되는 경우<br />
            2. 타인에게 혐오감을 주거나 미풍양속을 해치는 경우<br />
            3. 기타 합리적인 사유가 있는 경우<br />
            3) 회사는 전항 제1호 또는 제2호에 해당하는 경우에 회원에게 회원ID의 변경을 요구할 수 있습니다.<br />
            4) 이용자는 이용 신청시 기재한 사항이 변경되었을 경우에는 온라인을 통해 수정을 해야 합니다.<br />
            수정을 하지 않아서 발생하는 이용자의 피해에 대한 책임은 이용자에게 있습니다.</p>
          - 회원ID등의 관리
          <p>1) 회원ID 및 비밀번호의 관리는 회원의 책임으로 합니다.<br />
            2) 회사는 회원ID에 의하여 요금청구 등 제반 이용자 관리업무를 수행합니다.<br />
            3) 회원에게 통보된 회원ID 및 비밀번호에 의하여 발생되는 사용상의 과실 또는 제 3자에 의한 부정사용 등에 대한 모든

            책임은 이용자번호를 소유한 이용자에게 있습니다. 다만, 회사에 고의또는 중대한 과실이 있는 경우는 그러하지 아니합니다.</p>
          - 회원정보의 취득, 보호
          <p>1) 회사는 회원으로부터 각종 개인신상에 관한 정보를 제공받을 수 있습니다.<br />
            2) 본 서비스와 관련한 당사가 귀하로부터 취득한 (개인 및 법인에 관한 정보는 기업신용평가 및 정보 서비스 전문기관인

            한국신용정보(주)와 공동으로 구축·활용되며, 신용정보의 이용 및 보호에 관한 법률 제 23조에 의거 하여 보호됩니다.<br />
            3) 회사는 서비스 화면을 통하여 공개된 정보를 제외하고는 회원의 개인정보를 타 용도로 사용하거나 회원의 사전 동의

            없이 제3자에게 제공하지 않습니다. 단, 다음과 같이 법령에서 정보의 공개를 요구하거나 법령에 의하여 정보의 제공이

            가능한 경우 등에는 예외로 하고, 제공된 정보는 회원에게 통보됩니다.<br />
            ○ 전기통신기본법 등 관계법령에 의하여 국가기관 등의 요구가 있는 경우<br />
            ○ 범죄에 대한 수사상의 목적이 있거나 정보통신윤리위원회의 요청이 있는 경우<br />
            ○ 배송 업무상 배송 업체에 고객의 정보를 알려주는 경우<br />
            ○ 은행업무상 관련사항에 한하여 일부 정보를 공유하는 경우<br />
            ○ 통계작성, 홍보자료, 학술연구 또는 시장조사를 위하여 필요한 경우로서 특정개인을 식별할 수 없는 형태로 제공되는 경우<br />
            ○ 회원이 신용정보의 제공 및 활용에 대한 동의를 한 경우<br />
            4) 회원은 언제든지 자신의 정보를 열람할 수 있고 회사 또는 정보관리책임자에게 잘못된

            정보에 대한 수정을 요청할 수 있습니다.</p>
          - 개인정보 및 제공된 정보의 변경
          <p>1) 회원 가입시 제공된 모든 정보는 회원 본인의 동의없이 외부에 누출되지 않으며, 관계법령에 따른 보호를 받습니다.<br />
            2) 정보의 수집 및 이용목적<br />
            1. 회사에서 제공되는 회원의 특전을 활용하기 위하여 회원에 가입하며 가입시 개인신상에 대한 기본정보를 입력하여야 합니다.<br />
            2. 제공된 정보를 기준으로 회원임을 확인하여 회사에서 제공되는 서비스 및 회원특전의혜택을 부여 받을 수 있습니다.<br />
            3. 회원 본인임을 확인하는 절차로써 이용되며 상품의 배송, 메일의 전송, 한정된 전화연락등의 회원을 위한 서비스로만

            사용됩니다.<br />
            4. 허위 기재시 제공되는 서비스의 규제를 받게 됩니다.<br />
            3) 열람 및 수정<br />
            A. 제공된 정보는 회원 본인 이외에 임의로 열람 및 수정할 수 없습니다.<br />
            B. 회원은 온라인을 통해서 수시로 본인의 신상정보를 열람, 정정 또는 삭제할 수 있습니다.<br />
            C. 실제 본인임을 확인할 필요가 있는 경우는 공지사항 등에 필요절차를 공지하며, 유선, 메일, 전송 등으로 정보관리 책임자

            에게 연락하면 입력된 정보를 근거로 본인 여부를확인하여 조치하여 드립니다.<br />
            4) 해지(탈퇴)<br />
            A. 회원의 가입 및 탈퇴는 본인의 자유의사에 따릅니다.<br />
            B. 가입 및 해지(탈퇴)는 회원본인이 해지의사를 표현한 유선,전송,메일 등으로정보관리자에게 연락하면 해지(탈퇴) 처리됩니다.<br />
            C. 제공받는 서비스 또는 혜택 중 종결되지 아니한 내용이 있을 경우 종결 처리 후 해지하게됩니다.<br />
            D. 실제 본인임을 확인할 필요가 있는 경우는 공지사항 등에 필요절차를 공지하며, 유선,메일, 전송 등으로 정보관리 책임자

            에게 연락하면 입력된 정보를 근거로 본인 여부를 확인하여 진행사항을 종결 후 해지(탈퇴)하여 드립니다. 이경우, 회원은

            동일성 증명을 위하여 반드시 회원번호(ID)와 비밀번호, 사업자등록번호를 밝혀야 합니다.<br />
            E. 해지(탈퇴)되면 제공되었던 개인정보는 반드시 삭제되며 어떠한 다른 방법으로도관리되지 않습니다.<br />
            F. 해지(탈퇴)되면 회원으로써 제공받았던 서비스 또는 혜택을 제공받을 수 없으며 필요시 재 가입하여야 합니다.<br />
            5) 정보의 보유 및 이용기간<br />
            A. 제공된 정보는 회원 본인이 해지(탈퇴)의 의사를 밝혀 해지 및 탈퇴되는 시점까지 보유하게 됩니다.<br />
            B. 보유한 정보를 바탕으로 회원이 서비스를 이용 시 활용됩니다.<br />
            C. 회원 본인이 해지(탈퇴)의 의사를 밝혀 필요한절차를 거쳐해지 및 탈퇴 이후에는 제공되었던 정보를 보유 및 이용할

            수 없습니다.<br />
            6) 기타 개인정보에 대한 사항을 정보관리자에게 문의하실 수 있습니다.</p>
          - 회원의 이용범위
          <p>1) 회원은 ID와 비밀번호를 통하여 언제든지 회사가 제공하는 서비스에 접속할 수 있고, 자유롭게 회사의 서비스를 이용하여

            물품을 판매하거나 구매할 수 있습니다.<br />
            2) 회원은 회원번호 및 비밀번호를 스스로의 책임아래 관리하여야 합니다. 회원은 ID 및 비밀번호를 타인에게 양도하거나

            사용 승낙 할 수 없습니다. 회사는 회원본인에 의한 ID또는 비밀번호의 유출 및 사용승낙으로 인한 어떠한 손실이나

            손해에 대하여도 책임을 지지않습니다.<br />
            3) 회원은 회사가 제공하는 서비스를 통하여 판매 및 구매하는 경우, 회사가 마련한 매매서비스 프로그램을 통하여 거래를 완료

            하여야 합니다.</p>
          서비스제공 및 이용<br />
          <br />
          - 이용 계약의 성립
          <p>이용계약은 이용자의 서비스 이용신청에 대한 회사의 이용승낙에 의하여 성립됩니다.</p>
          - 이용 신청
          <p>서비스 가입신청은 인터넷상에서 http://www.KoreaB2B.com/으로 접속하여 소정양식에 의하여 등록신청을 한 후 필요서류를

            송부하여야 합니다.</p>
          - 이용 신청의 승낙
          <p>1) 회사는 이용자의 이용신청 후 해당하는 조건이 갖추어진 신청자에게는 소정의 심사절차를 거쳐 메일 혹은 유선으로 등록사실

            을 통보합니다.<br />
            2) 회사는 이용자가 이용계약 내용을 허위로 기재하였을 경우 이를 승낙하지 아니할 수 있습니다.</p>
          - 서비스 구분 및 이용시간
          <p>1) 회사가 회원에게 제공하는 서비스는 회사에서 별도의 공시를 하지 아니하는 한 무료입니다.<br />
            2) 서비스 이용은 회사의 업무상 또는 기술상 특별한 지장이 없는 한 연중 무휴, 1일 24시간을 원칙으로 합니다.<br />
            3) 전항의 규정에도 불구하고 정기점검 등의 필요로 회사가 정한 날 또는 시간은 예외적으로 서비스 이용을 제한하거나 일시

            중단할 수 있습니다.</p>
          계약당사자의 의무<br />
          <br />
          - 회사의 의무 및 권한
          <p>1) 회사는 전조에서 정한 사유 외 그밖에 부득이한 경우에는 그 서비스를 일시 중단하거나 중지할 수 있습니다.<br />
            2) 회사는 회원이 서비스 이용 중 필요가 있다고 인정되는 다양한 정보에 대해서 회사 후원사의 다양한 상품정보 등을 전자우편

            이나 서신우편 및 실시간 메시지 전송 등을 통해서 제공할 수 있습니다.<br />
            3) 회사는 회원에게 당사 후원사의 설문, 시연 등을 의뢰할 수 있으며 회원은 최대한 협조하며 회사는 이에 따른 경품 등의

            제공을 실시 할 수 있습니다.<br />
            4) 본 서비스를 통하여 회사로 제출된 아이디어, 원고, 사진 등에 대한 저작권, 초상권, 지적재산권 등은 회사에 귀속하며,

            제출자에 대한 보상은 사전 공시된 내용에 따릅니다.</p>
          - 이용자의 의무
          <p>1) 회원은 이 약관 및 관계법령을 준수하여야 하며, 기타 회사의 서비스 제공에 지장을 초래하는 행위를 하여서는 아니됩니다.<br />
            2) 회원은 주소 및 연락처 등 회원가입신청사항이 변경된 경우에는 서비스 또는

            전화 등을 통하여 이를 즉시 회사에 알려야 합니다.<br />
            3) 회원은 서비스를 이용하여 얻은 정보를 회사의 승낙없이 복사, 복제, 개조, 번역하여 타인에게 제공하여서는 아니되며,

            이로 인해 회사에 피해 손실이 발생한 경우 회사는 회원에게 손해배상을 청구할 수 있습니다.</p>
          - 서비스 이용책임
          <p>1) 회원은 자기 책임하에 서비스를 이용하며, 서비스 자료의 취사선택 또는 서비스 이용으로 불이익이 발생하더라도 이에 대한

            책임은 회원에게 있습니다.<br />
            2) 회원이 서비스를 통하여 게시 또는 전송한 자료의 내용에 관하여 발생되는 책임은 회원에게 있습니다.<br />
            3) 회원에게 통보된 회원ID와 비밀번호의 관리 및 이용상의 부주의로 인하여 발생되는 과실 또는 제3자에 의한 부정사용 등에

            대한 책임은 회원에게 있습니다. 다만, 회사의 관리상 중과실이 있는 경우에는 그러하지 아니합니다.<br />
            4) 회원등록시 거짓정보/오정보로 인한 문제는 이용자의 책임입니다.</p>
          - 물품매매에 관한 규정(판매/구매)
          <p>1) 회사가 제공하는 서비스를 통하여 물품을 구매 및 판매하고자 하는 회원은 회사가 제공하는 등록양식에 따라 물품을

            등록하여야 합니다.<br />
            2) 제공되는 소정의 서식을 통하여 필요사항을 기재하여 등록하며 등록된 내용은 서비스 화면을 통하여 제공되며 상호

            메일로 발송됩니다.<br />
            3) 부득이 필요할 경우 중간과정을 생략하고 필요한 서식을 사용하거나 메일 등을 통하여 문제점을 해결할 수 있습니다.

            4) 회사가 정하는 양식에 어긋난 기록은 등록되지 않으며, 허위등록으로 인한 손해 또는 손실에 대한 책임은 등록한 회원이

            부담해야 합니다.<br />
            5) 물품의 상세정보에는 사실대로 기재하여야 하며, 거짓정보를 기재한 것이 밝혀지면 바로 등록이 취소되며 이로 인한 책임은

            등록회원이 부담해야 합니다.<br />
            6) 매매제한물품은 해당 기관의 허가 및 신고의 절차를 해당법령에 의하여 필하고 이를 증명할 수 있을 시에 한하여 가능하며

            이로 인한 문제발생의 책임은 당해 회원에 있습니다.</p>
          - 상호신뢰
          <p>온라인 상거래이므로 상호신뢰를 바탕으로 이루어지는 선납품 후결제의 방식이므로 상호 신뢰를 조성하여야 하며, 판매자가

            구매자에 대한 신뢰를 조성하여야 하며, 판매자가 구매자에 대한 신뢰 부족시 사전에 대금의 결제방법이나 회사에 정보를 요구할

            수 있으며, 구매자는 이에 대한 적절한 조치를 취하여 원만한 거래가 성사될 수 있도록 협조하여야 합니다.</p>
          - 반품등에 관한 규정
          <p>1) 판매자는 물품을 수령한 구매자가 검수과정에서 상당한 문제의 발견시 물품을 반품하며 이에 대한 제반 비용은 판매자가

            부담합니다.<br />
            2) 구매자가 부당하게 반품을 요구할 경우, 판매자는 소송 등으로 반품을 중지시킬 수 있으며 판매자의 선의의 피해를 방지하기

            위하여 회사에서 합의된 공탁제도나 사전 입금제 등을 실시할 수 있습니다.</p>
          - 정보보호 장치
          <p>회사는 서비스를 통하여 이루어지는 물품매매에 관한 정보 및 처리과정을 위하여 적절한 보호장치를 설정하여야 합니다.

            따라서 정보등록시 매매보호장치를 통하지 않고 직거래를 유도하는 사항에 대하여는 회사에서 책임지지 않습니다.</p>
          - 수수료 등(서비스이용요금)
          <p>1) 회사의 서비스를 이용하여 매매가 성립된 경우 소정의 수수료를 납부하여야 합니다.<br />
            2) 수수료를 납부하지 않을 시 회원의 자격 등을 박탈하여 서비스를 이용할 수 없도록 합니다.<br />
            3) 회사는 필요한 경우 서비스수수료를 변경할 수 있으며, 변경사항은 공지 사항란 및 전체메일을 통하여 공지합니다.<br />
            변경된 수수료는 공지된 이후부터 적용됩니다.</p>
          - 이용요금의 연체, 미납
          <p>1) 회사가 이용요금 납입자에게 청구한 금액을 납입기일내에 납입하지 않는 경우 서비스 이용을 중지할 수 있습니다.<br />
            2) 서비스 요금이 완납된 경우 서비스 이용이 가능합니다.</p>
          - 이용요금에 대한 이의 신청
          <p>1) 이용요금 청구에 이용자의 이의가 제기된 경우에 회사는 상세한 청구내역을 구두, E-Mail, FAX 등으로 제공합니다.<br />
            2) 회사는 이용요금청구 등에 오류가 있는 경우 이용자의 요청(이의신청)에 따라 다음 각 호에 해당하는 조치를 합니다.<br />
            (1) 과다 납입한 요금에 대해서는 그 금액을 반환합니다. 반환에 필요한 수수료는 과다 납입한 이용자가 부담합니다.<br />
            (2) 회사는 과소 청구액에 대해서는 미수금을 재청구하며, 미수금이 완납될 때까지 서비스의 이용을 제한할 수 있습니다.<br />
            (3) 제 2항의 규정에 의한 요금 등의 이의신청은 사유가 발생한 날로부터 1년이 경과한 때에는 이의신청을 할 수 없습니다.</p>
                         - 결제수단
          <p>1) 회사가 운영하는 서비스 내에서의 대금결제는 현금, 신용카드, 무통장입금, 구매카드 기타 회사가 인정하는 결제수단으로

            할 수 있습니다.<br />
            2) 회원간의 거래에서 생기는 금전적인 피해에 대해서는 회사는 법적책임이 없습니다. 다만, 그런 상황이 발생하였을 경우에는

            해당 회원에 대해 회원자격을 해지할 수 있습니다.</p>
          - 회사의 면책
          <p>1) 회사는 서비스를 통한 거래와 관련하여 회원에게 발생한 어떠한 손해에 대하여도 책임을 지지 않습니다.<br />
            2) 회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이

            면제됩니다.<br />
            3) 회사는 회원의 귀책사유로 인한 서비스 이용의 장애에 대하여 책임을 지지 않습니다.<br />
            4) 회원이 게재한 정보, 자료, 사실의 정확성 등을 신뢰함으로써 입은 손해에 대하여 회사는 책임을 지지 않습니다.</p>
          - 손해배상
          <p>회사는 회사의 귀책사유로 이용자가 전체서비스를 이용하지 못함으로써 발생하는 손해에 대하여, 이용자가 그 사실을 회사에

            통보하여 확인되거나 또는 회사가 알게 된 날로부터 계산하여 48시간 이상 연속적으로 그 상태가 계속될 때에 한해 이용자의

            청구에 대하여 손해배상 책임이 있습니다.</p>
          - 분쟁해결 관할법원 및 준거법
          <p>1) 회사가 제공하는 서비스와 관련하여 회사와의 사이에 발생한 분쟁에 대해 소송이 제기될 경우 회사의 본사 소재지를 관할하는

            법원을 관할법원으로 합니다.<br />
            2) 회사와 회원간에 제기된 소송에는 한국법을 적용합니다.</p>
          - 기타조항
          <p>1) 본 약관에 상세한 명시가 없는 사항은 제공되는 서비스 화면을 통하여 안내되며 안내되는 내용에 대하여도 본 약관과 동일한

            효력을 가지게 됩니다.<br />
            2) 회사는 공지 또는 통지함이 없이, 일시 또는 영구적으로 서비스를 수정하거나 중단할 수 있으며, 그에 따라 본 서비스 약관도

            통지 없이 소멸될 수 있습니다.</p>
          부칙<br />
          <br />
          본 약관은 2008년 9월 22일부터 시행합니다.
	  </div>
      <div class="h10"></div>
      <div class="LawGrayCheck"><label class="CheckLargeLabel" style="margin:0;"><input type="checkbox" id="agree_terms" name="agree_terms" value="Y" /><span class="CheckLargeCustom"></span> 상기 이용약관에 동의함. </label></div>
      <div class="h50"></div>

      <!-- 개인정보 수집 및 이용안내 섹션 -->
	  <div class="ComJoinTitMedium">개인정보 수집 및 이용안내(필수)</div>
      <div class="LawGray" style="height:158px">
          가. 회사는 회원가입, 상담, 서비스 신청 등을 위해 아래와 같은 개인정보를 수집하고 있습니다.<br />
          나. 수집항목 : <br />
          1) 고객회원사<br/>
          - 필수항목 : 회사명, 대표자명, 대표전화번호, 입고담당자명, 입고담당자 연락처, 경리담당자명, 경리담당자 연락처, 관리자 사용자명, 관리자 아이디, 관리자 비밀번호, 관리자 이메일, 관리자 전화번호, 관리자 휴대전화<br/>
          2) 협력회원사<br/>
          - 필수항목 : 회사명, 경리담당자, 경리담당자 연락처, 경리담당자 휴대폰, 경리담당자 이메일, 영업담당자, 영업담당자 연락처, 영업담당자 휴대폰, 영업담당자 이메일, 영업담당자법인 계좌번호, 관리자 사용자명, 관리자 아이디,
          관리자 비밀번호, 관리자 이메일, 관리자 전화번호, 관리자 휴대전화<br/>
          3) 사용자<br/>
          - 필수항목 : 아이디, 비밀번호, 이름, 이메일, 전화번호, 핸드폰<br/>
          - 선택항목 : 사번, 도착지<br/>
          다. 개인정보 수집방법 : 홈페이지(회원가입), 서면양식, 배송 요청, 제휴사로부터의 제공, 생성정보 수집 툴을 통한 수집<br />
          라. 전자상거래 등에서의 소비자보호에 관한 법률 시행령 제11조2항에 의거 사업자회원의 수집항목이 추가될 수 있습니다.<br />
          마. 소득세법 제 145조 및 제 164조, 동법 시행령 제 193조 및 제 213조(대금 지급의 경우, 원청징수 영수증 발급용도)에 따라 회원의 주민등록번호가 수집될 수 있습니다.<br/><br/>

          <b>회사는 수집한 개인정보를 다음의 목적을 위해 활용합니다.</b><br />
          가. 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산 콘텐츠 제공, 구매 및 요금 결제, 물품배송 또는 청구서 등 발송, 요금추심<br />
          나. 회원 관리 -  회원제 서비스 이용에 따른 본인확인, 개인 식별, 불량회원의 부정 이용 방지와 비인가 사용 방지, 가입 의사 확인, 불만처리 등 민원처리, 고지사항 전달, 회원탈퇴 의사의 확인<br />
          다. 기타 - 서비스의 유효성 확인, 원활한 양질의 서비스 제공 <br /><br />

          <b>회사는 목적이 달성된 개인정보에 대해서 안전하게 분리보관 하고 파기합니다.</b><br />
          가. 회원 탈퇴시 개인정보는 분리보관 후 파기합니다.<br />
          나. 1년간 사이트 접속하지 않은 경우 장기미사용 분리보관 메일 발송 후 안내일까지 접속이력이 없을 경우 분리보관 후 파기합니다.<br />
          다. 거래가 종료된 회원은 절차에 따라서 일괄 개인정보를 분리보관 후 파기합니다.<br />
          라. 분리보관된 개인정보는 <u>내부 방침에 따라 일정 기간 보관 후 파기됩니다.</u><br /><br />

          <b>제2조 개인정보 처리 항목 및 보유기간</b><br/>
          가. 회사는 다음의 목적을 위하여 최소한의 개인정보를 수집하여 처리합니다.<br/>
          나. 개인정보의 항목은 특성 및 목적에 따라 달리 규정하고 있으며, 관련 법령 또는 정보주체의 동의를 받은 보유·이용기간 내에서 개인정보를 처리·보유합니다.<br/><br/>
          1. 개인정보보호법 제15조(개인정보의 수집·이용) 제1항 제2호, 제17조(개인정보의 제공) 제1항 제2호, 제18조(개인정보의 목적 외 이용·제공 제한) 제2항 제2호에 법률에 따라 정보주체의 동의 없이 개인정보를 수집, 이용, 제공 할 수 있습니다.<br/>
          <table class="PInfoList">
            <colgroup>
            <col width="7%" />
            <col width="10%" />
            <col width="29%" />
            <col width="23%" />
            <col width="15%" />
            <col width="16%" />
            </colgroup>
            <tbody>
              <tr>
                <th>서비스</th>
                <th>구분</th>
                <th>수집항목</th>
                <th>처리 목적</th>
                <th>처리 및 보유기간</th>
                <th>처리근거</th>
              </tr>
              <tr>
                <td rowspan="3" class="tit_B_C">구매대행</td>
                <td class="tit_B_C">고객사</td>
                <td>회사명, 대표자명, 대표전화번호, 입고담당자명, 입고담당자 연락처, 경리담당자명, 경리담당자 연락처, 관리자 사용자명, 관리자 아이디, 관리자 비밀번호, 관리자 이메일, 관리자 전화번호, 관리자 휴대전화번호</td>
                <td> 거래처 식별<br/>
                  신용정보 확인<br/>
                  물품배송<br/>
                  매출세금계산서 발행 </td>
                <td>회원 탈퇴 또는 계약 종료시 지체없이 파기</td>
                <td>개인정보보호법 제15조 제1항 제4호 (계약의 이행)</td>
              </tr>
              <tr>
                <td class="tit_B_C">협력사</td>
                <td>회사명, 경리담당자, 경리담당자 연락처, 경리담당자 휴대전화번호, 경리담당자 이메일, 영업담당자, 영업담당자 연락처, 영업담당자 휴대전화번호, 영업담당자 이메일, 계약담당자, 계약담당자 연락처, 계약담당자 휴대전화번호, 계약담당자 이메일법인, 계좌번호, 예금주, 관리자 담당자명, 담당자 아이디, 관리자 비밀번호, 관리자 이메일, 관리자 전화번호, 관리자 휴대전화번호, 납기담당자, 납기담당자 휴대전화번호</td>
                <td> 거래처 식별<br/>
                  신용정보 확인<br/>
                  매입세금계산서 발행<br/>
                  영업관련 문의<br/>
                  대금지불 </td>
                <td>회원 탈퇴 또는 계약 종료시 지체없이 파기</td>
                <td>개인정보보호법 제15조 제1항 제4호 (계약의 이행)</td>
              </tr>
              <tr>
                <td class="tit_B_C">사용자</td>
                <td>아이디, 비밀번호, 이름, 이메일, 전화번호, 휴대전화번호</td>
                <td> 개인식별<br/>
                  주문이력 관리<br/>
                  배송 및 납기관련 응대<br/>
                  VOC(Voice of Customer) 및 사용방법 문의 </td>
                <td> 회원 탈퇴 또는 계약 종료시 지체없이 분리보관<br/>
                  3년 경과 후 지체 없이 파기 </td>
                <td>개인정보보호법 제15조 제1항 제4호 (계약의 이행)</td>
              </tr>
              <tr>
                <td rowspan="3" class="tit_B_C">건설<br/>
                  구매대행</td>
                <td class="tit_B_C">고객사</td>
                <td>회사명, 대표자명, 대표전화번호, 아이디, 비밀번호, 이름, 이메일, 전화번호, 휴대전화번호, 경리담당자, 경리담당자연락처</td>
                <td> 거래처 식별<br/>
                  신용정보 확인<br/>
                  매출세금계산서 발행 </td>
                <td>회원 탈퇴 또는 계약 종료시 지체없이 파기</td>
                <td>개인정보보호법 제15조 제1항 제4호 (계약의 이행)</td>
              </tr>
              <tr>
                <td class="tit_B_C">협력사</td>
                <td>회사명, 대표전화번호, 아이디, 비밀번호, 이름, 이메일, 회사전화번호, 휴대전화번호, 경리담당자, 경리담당자연락처</td>
                <td> 거래처 식별<br/>
                  신용정보 확인<br/>
                  매입세금계산서 발행<br/>
                  대금지불 </td>
                <td>회원 탈퇴 또는 계약 종료시 지체없이 파기</td>
                <td>개인정보보호법 제15조 제1항 제4호 (계약의 이행)</td>
              </tr>
              <tr>
                <td class="tit_B_C">사용자</td>
                <td>아이디, 비밀번호, 이름, 이메일, 회사전화번호, 휴대전화번호</td>
                <td> 개인식별<br/>
                  주문이력 관리<br/>
                  배송 및 납기관련 응대<br/>
                  VOC(Voice of Customer) 및 사용방법 문의 </td>
                <td> 회원 탈퇴 또는 계약 종료시 지체없이 분리보관<br/>
                  3년 경과 후 지체 없이 파기 </td>
                <td>개인정보보호법 제15조 제1항 제4호 (계약의 이행)</td>
              </tr>
              <tr>
                <td rowspan="3" class="tit_B_C">유통</td>
                <td class="tit_B_C">고객사</td>
                <td>구매사명, 대표자명, 경리담당자, 사용자ID, 비밀번호, 사용자명, 주소, 전화번호, 휴대전화번호, 이메일</td>
                <td> 거래처 식별<br/>
                  신용정보 확인<br/>
                  매출세금계산서 발행 </td>
                <td>회원 탈퇴 또는 계약 종료시 지체없이 파기</td>
                <td>개인정보보호법 제15조 제1항 제4호 (계약의 이행)</td>
              </tr>
              <tr>
                <td class="tit_B_C">협력사</td>
                <td>협력사명, 협력사전화, 이메일, 사용자ID, 비밀번호, 이름, 주소, 전화번호, 휴대전화번호</td>
                <td> 거래처 식별<br/>
                  신용정보 확인<br/>
                  매입세금계산서 발행<br/>
                  대금지불 </td>
                <td>회원 탈퇴 또는 계약 종료시 지체없이 파기</td>
                <td>개인정보보호법 제15조 제1항 제4호 (계약의 이행)</td>
              </tr>
              <tr>
                <td class="tit_B_C">사용자</td>
                <td>회사명, 사용자ID, 비밀번호, 사용자명, 이메일, 휴대전화번호, 수령자명, 수령자 휴대전화번호</td>
                <td> 개인식별<br/>
                  주문이력 관리<br/>
                  배송 및 납기관련 응대<br/>
                  VOC(Voice of Customer) 및 사용방법 문의 </td>
                <td> 회원 탈퇴 또는 계약 종료시 지체없이 분리보관<br/>
                  3년 경과 후 지체 없이 파기 </td>
                <td>개인정보보호법 제15조 제1항 제4호 (계약의 이행)</td>
              </tr>
              <tr>
                <td rowspan="4" class="tit_B_C">판촉</td>
                <td class="tit_B_C">고객사</td>
                <td>회사명, 대표자명, 대표전화번호, 입고담당자명, 입고담당자 연락처, 경리담당자명, 경리담당자 연락처, 관리자 사용자명, 관리자 아이디, 관리자 비밀번호, 관리자 이메일, 관리자 전화번호, 관리자 휴대전화번호</td>
                <td> 거래처 식별<br/>
                  신용정보 확인<br/>
                  매출세금계산서 발행 </td>
                <td>회원 탈퇴 또는 계약 종료시 지체없이 파기</td>
                <td>개인정보보호법 제15조 제1항 제4호 (계약의 이행)</td>
              </tr>
              <tr>
                <td class="tit_B_C">협력사</td>
                <td>회사명, 대표전화번호, 아이디, 비밀번호, 이름, 이메일, 회사전화번호, 휴대전화번호, 경리담당자, 경리담당자연락처</td>
                <td> 거래처 식별<br/>
                  신용정보 확인<br/>
                  매입세금계산서 발행<br/>
                  대금지불 </td>
                <td>회원 탈퇴 또는 계약 종료시 지체없이 파기</td>
                <td>개인정보보호법 제15조 제1항 제4호 (계약의 이행)</td>
              </tr>
              <tr>
                <td class="tit_B_C">사용자</td>
                <td>회사명, ID, 이름, 이메일, 전화번호, 휴대전화번호, 주소, 사번, 부서명</td>
                <td> 개인식별<br/>
                  주문이력 관리<br/>
                  배송 및 납기관련 응대<br/>
                  VOC(Voice of Customer) 및 사용방법 문의 </td>
                <td> 회원 탈퇴 또는 계약 종료시 3년 경과 후 지체 없이 파기 </td>
                <td>개인정보보호법 제15조 제1항 제4호 (계약의 이행)</td>
              </tr>
              <tr>
                <td class="tit_B_C">사용자<br/>
                  (한국교직원공제회)</td>
                <td>공제회 회원번호, 생년월일</td>
                <td> 개인식별<br/>
                  주문이력 관리<br/>
                  배송 및 납기관련 응대<br/>
                  VOC(Voice of Customer) 및 사용방법 문의 </td>
                <td> 회원 탈퇴 또는 계약 종료시 3년 경과 후 지체 없이 파기 </td>
                <td>개인정보보호법 제15조 제1항 제4호 (계약의 이행)</td>
              </tr>
              <tr>
                <td class="tit_B_C">인사</td>
                <td class="tit_B_C">지원자</td>
                <td>성명(한글), 전화번호, 휴대전화번호, 이메일, 사진, 생년월일, 성별, 주소, 병역사항(남자의 경우), 학력사항(학교명, 기간, 전공, 소재지, 학점), 경력기술서</td>
                <td> 입사지원자 식별<br/>
                  결과통보<br/>
                  업무관련 기초정보 수집 </td>
                <td>180일 보관 후 파기</td>
                <td>채용절차의 공정화에 관한 법률<br/>
                  개인정보보호법 제15조 제1항 제4호 (계약의 이행)</td>
              </tr>
            </tbody>
          </table><br/>
          <p> 2. 정보주체의 동의를 받아 처리하는 개인정보 항목<br/>
            개인정보 보호법 제15조(개인정보의 수집·이용) 제1항 제1호 따라 아래의 개인정보 항목을 정보주체의 동의를 받아 처리하고 있습니다. 또한, 수집된 개인정보를 아래의 목적으로 처리합니다. 수집된 개인정보는 아래의 목적 이외로는 이용되지 않으며 이용 목적이 변경되는 경우는 반드시 사전 동의를 구합니다.<br/>
          <table class="PInfoList">
            <colgroup>
            <col width="10%" />
            <col width="10%" />
            <col width="30%" />
            <col width="15%" />
            <col width="25%" />
            </colgroup>
            <tbody>
              <tr>
                <th>서비스</th>
                <th>구분</th>
                <th>수집항목</th>
                <th>처리 목적</th>
                <th>처리 및 보유기간</th>
              </tr>
              <tr>
                <td rowspan="3" class="tit_B_C">구매대행</td>
                <td class="tit_B_C">고객사</td>
                <td>사번</td>
                <td>거래처 내부 식별 용도</td>
                <td>회원 탈퇴 또는 계약 종료시 지체없이 파기</td>
              </tr>
              <tr>
                <td class="tit_B_C">협력사</td>
                <td>사번</td>
                <td>거래처 내부 식별 용도</td>
                <td>회원 탈퇴 또는 계약 종료시 지체없이 파기</td>
              </tr>
              <tr>
                <td class="tit_B_C">사용자</td>
                <td>사번, 도착지</td>
                <td> 거래처 내부 식별 용도<br/>
                  물품배송 기본 주소(도착지) </td>
                <td> 회원 탈퇴 또는 계약 종료시 지체없이 분리보관<br/>
                  3년 경과 후 지체 없이 파기 </td>
              </tr>
              <tr>
                <td class="tit_B_C">인사</td>
                <td class="tit_B_C">지원자</td>
                <td>보훈대상여부, 장애여부, 외국어사항, 자격사항, 경력사항, 프로젝트사항, 가족사항, 외국거주경험, 수상경력, IT활용능력, 학내외 활동사항, 봉사활동, 해외연수, 교내/외 활동, 교육이수사항</td>
                <td> 우대사항 대상여부 확인<br/>
                  업무적성 및 능력 분석<br/>
                  면접에 활용 </td>
                <td> 180일 보관 후 파기<br/>
                  (채용절차의 공정화에 관한 법률 11조 3항) </td>
              </tr>
            </tbody>
          </table>
          <br/>
          다. 개인정보 수집방법 : 홈페이지(회원가입), 서면양식, 배송 요청, 제휴사로부터의 제공, 생성정보 수집 툴을 통한 수집<br />
          라. 전자상거래 등에서의 소비자보호에 관한 법률 시행령 제11조2항에 의거 사업자회원의 수집항목이 추가될 수 있습니다.<br />
          마. 소득세법 제 145조 및 제 164조, 동법 시행령 제 193조 및 제 213조(대금 지급의 경우, 원청징수 영수증 발급용도)에 따라 회원의 주민등록번호가 수집될 수 있습니다.
      </div>
      <div class="h10"></div>
      <div class="LawGrayCheck">
        <label class="CheckLargeLabel" style="margin:0;"><input type="checkbox" id="agree_privacy" name="agree_privacy" value="Y" /><span class="CheckLargeCustom"></span> 상기 개인정보 수집 및 이용안내에 동의함.(필수)</label><br/>
        <label class="CheckLargeLabel" style="margin:0;"><input type="checkbox" id="agree_privacy_optional" name="agree_privacy_optional" value="Y" /><span class="CheckLargeCustom"></span> 상기 개인정보 수집 및 이용안내에 동의함.(선택)</label> &nbsp; &nbsp;
        ※ 선택항목에 동의하지 않으셔도 사이트 이용은 가능합니다.
	  </div>

      <div class="h80"></div>
      <div class="ComButtonArea"><button type="button" class="ButtonMedium" onclick="submitRegistration()">확인</button></div>
      <div class="h80"></div>
    </div><!-- containerSub 끝 -->

    <%@ include file="/WEB-INF/views/common/include/mainFooter_v2.jsp" %>
</div><!-- wrap 끝-->
</form>
<form name="slgForm" id="slgForm" method="post">
	<input type="hidden" id="comCode" name="comCode" value="" />
	<input type="hidden" id="slgId" name="slgId" value="" />
	<input type="hidden" id="returnColumn" name="returnColumn" value="" />
</form>
</body>
<script type="text/javascript">
function kep_onload_view(){
	$("#contentForm").on("input change", "input, select, textarea", function() {
		clearError(this);
	});
}

var popupSel = "";

// 이메일 도메인 선택
function setEmailDomain() {
	var domain = $("#st_email_domain").val();
	if (domain != "") {
		$("#st_email2").val(domain).trigger("change");
		$("#st_email2").attr("readonly", true);
	} else {
		$("#st_email2").val("").trigger("change");
		$("#st_email2").attr("readonly", false);
		$("#st_email2").focus();
	}
}

// 비밀번호 실시간 일치 검증 표시
function validatePassword() {
	var pwd = $("#st_password").val();
	var pwdConfirm = $("#st_password_confirm").val();
	if (pwdConfirm.length > 0) {
		if (pwd !== pwdConfirm) {
			$("#pwdMatchMsg").show().text("불일치").css("color", "#F6495F");
		} else {
			$("#pwdMatchMsg").show().text("일치").css("color", "#2f7ff1");
		}
	} else {
		$("#pwdMatchMsg").hide();
	}
}

// 확인 버튼 핸들러
function submitRegistration() {
	doAction('save');
}

// 기능함수
function doAction(str) {
	switch (str) {
		case "reload":
			kepReload('contentForm');
			break;
		case "save":
			if (checkSubmit()) {
				kepAjaxFormCall("/mdam/saveMasterMdAmUserRegList.do","contentForm","save");
			}
			break;
		case "idCheck":
			if (isEmpty($("#st_user_id").val())) {
				alert("사용자 ID를 입력해 주십시요");
				showError("#st_user_id"); 
				$("#st_user_id").focus();
				return;
			} else if (kepIsSpecialChar("st_user_id")) {
				alert("사용자 ID는 특수문자를 포함할 수 없습니다.");
				$("#st_user_id").focus();
				return;
			} else if (kepTrim("st_user_id") != $("#st_user_id").val() || containsWhitespace($("#st_user_id").val())){
				alert("사용자 ID는 공백을 포함할 수 없습니다.");
				$("#st_user_id").focus();
				return;
			} else {
				kepAjaxFormCall("/mdam/getMasterMdAmUserRegIDCheck.do","contentForm","idCheck");
			}
			break;
		case "pwdCheck1":
			if (passwordValidCheck1()) {
				kepAjaxFormCall("/mdam/getMasterMdAmUserRegPwdValidCheck.do","contentForm","pwdCheck1");
			}
			break;
		case "pwdCheck2":
			if (passwordValidCheck2()) {
				kepAjaxFormCall("/mdam/getMasterMdAmUserRegPwdValidCheck.do","contentForm","pwdCheck2");
			}
			break;
	}
}

// 팝업함수호출
function doPop(str, val, val2) {
	popupSel = str;
	var comCode = $("#st_com_code").val();

	switch (str) {
		case "com":
			PopupUtil.open({
				url: '/resources/html/common/popup/com_code_list.html',
				onInit: function(api) {
					api.$container.data('businessCond', 'B');
					api.onSelect(function(row) {
						$("#st_com_code").val(row.COM_CODE);
						$("#st_com_name_loc").val(row.COM_NAME_LOC);
						if (row.BUSINESS_COND) {
							$("#st_business_cond").val(row.BUSINESS_COND);
						}
						// 회사 변경 시 부서/직급/도착지 초기화
						$("#st_department").val("");
						$("#st_department_text").val("");
						$("#st_position").val("");
						$("#st_position_text").val("");
						$("#st_dely_to_location").val("");
						$("#st_dely_text").val("");
						clearError("#st_com_div");
						
						//고객사 선택 후 해당 고객사로 사번컬럼명 특수로직 확인
						specialCheck($("#st_com_code").val());
					});
				}
			});
			break;
		case "dept":
			if (isEmpty(comCode)) {
				alert("회사를 먼저 선택해 주세요.");
				showError("#st_com_div");
				return;
			}
			PopupUtil.open({
				url: '/resources/html/common/popup/dept_code_list.html',
				data: { com_code: comCode },
				onInit: function(api) {
					api.onSelect(function(row) {
						$("#st_department").val(row.CODE);
						$("#st_department_text").val(row.TEXT1);
						clearError("#st_dept_div");
					});
				}
			});
			break;
		case "position":
			if (isEmpty(comCode)) {
				alert("회사를 먼저 선택해 주세요.");
				showError("#st_com_div");
				return;
			}
			PopupUtil.open({
				url: '/resources/html/common/popup/position_code_list.html',
				data: { com_code: comCode, type: 'C003' },
				onInit: function(api) {
					api.onSelect(function(row) {
						$("#st_position").val(row.CODE);
						$("#st_position_text").val(row.TEXT1);
						clearError("#st_pos_div");
					});
				}
			});
			break;
		case "location":
			if (isEmpty(comCode)) {
				alert("회사를 먼저 선택해 주세요.");
				showError("#st_com_div");
				return;
			}
			PopupUtil.open({
				url: '/resources/html/common/popup/del_location_list.html',
				data: { com_code: comCode },
				onInit: function(api) {
					api.onSelect(function(row) {
						$("#st_dely_to_location").val(row.CODE);
						$("#st_dely_text").val(row.TEXT2).trigger("change");
					});
				}
			});
			break;
	}
}

function specialCheck(com_code){
	$("#comCode").val(com_code);
	$("#slgId").val("P01-1010-05");
	$("#returnColumn").val("COL01_DATA");
	kepAjaxFormCallNoBar("/mdam/getSpecialCheckReturn.do","slgForm","specialCheck");
}
// 콜백함수(팝업에서 호출)
function setPopupReturn(code, text, val3) {
	switch (popupSel) {
		case "com":
			$("#st_com_code").val(code);
			$("#st_com_name_loc").val(text);
			if (val3) {
				$("#st_business_cond").val(val3);
			}
			// 회사 변경 시 부서/직급/도착지 초기화
			$("#st_department").val("");
			$("#st_department_text").val("");
			$("#st_position").val("");
			$("#st_position_text").val("");
			$("#st_dely_to_location").val("");
			$("#st_dely_text").val("");
			alert("실행");
			clearError("#st_com_div");
			break;
		case "dept":
			$("#st_department").val(code);
			$("#st_department_text").val(text);
			clearError("#st_dept_div");
			break;
		case "position":
			$("#st_position").val(code);
			$("#st_position_text").val(text);
			clearError("#st_pos_div");
			break;
		case "location":
			$("#st_dely_to_location").val(code);
			$("#st_dely_text").val(text).trigger("change");
			break;
	}
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod, response) {
	var sMsg = response.msg;
	if (pMethod == "pwdCheck1") {
		if (sMsg != 'OK') {
			alert(sMsg);
			$("#st_password").val("");
			$("#st_password").focus();
			return;
		} else {
			$("#chkPassword1").val("Y");
			return;
		}
	} else if (pMethod == "pwdCheck2") {
		if (sMsg != 'OK') {
			alert(sMsg);
			$("#st_password").val("");
			$("#st_password").focus();
			return;
		} else {
			$("#chkPassword2").val("Y");
			return;
		}
	} else if (pMethod == "idCheck") {
		if (sMsg == 'OK') {
			alert("사용가능한 ID 입니다.");
			$("#id_check_flag").val("Y");
			$("#idCheckMsg").show().text("사용가능한 ID 입니다.").css("color", "#2f7ff1");
			return;
		} else if (sMsg == 'NO') {
			alert("이미 사용하고 있는 ID 입니다. 다른 ID를 입력하세요.");
			$("#id_check_flag").val("N");
			$("#idCheckMsg").show().text("사용할 수 없는 ID 입니다.").css("color", "#F6495F");
			$("#st_user_id").val("");
			$("#st_user_id").focus();
			return;
		} else {
			alert("ID에 금지어(" + sMsg + ")가 포함되어 있습니다. 다른 ID를 입력하세요.");
			$("#id_check_flag").val("N");
			$("#idCheckMsg").show().text("사용할 수 없는 ID 입니다.").css("color", "#F6495F");
			$("#st_user_id").val("");
			$("#st_user_id").focus();
			return;
		}
	} else if (pMethod == "save") {
		if (sMsg == "OK") {
			location.href = "/mdam/showRenewalBuyerUserRegEnd.do?type=U";
			return;
		} else {
			if (sMsg == "Err") {
				alert("사용자 등록에 실패 하였습니다\n\n확인한 후 다시 입력 해 주시기 바랍니다.");
			} else if (sMsg == "dup") {
				alert("이미 다른 사용자가 사용중인 ID입니다.\n\n확인한 후 다시 입력 해 주시기 바랍니다.");
				return;
			}
		}
		doAction("reload");
	} else if (pMethod == "specialCheck"){
		var data = response.data;
		//사번 컬럼명 특수로직
		if(data.length != 0){
			var col01_data = data[0].COL01_DATA;
			$("#legacy_span1").removeClass("f2f7ff").addClass("F6495F");
			$("#legacy_span2").text(col01_data);
		}else{
			$("#legacy_span1").removeClass("F6495F").addClass("f2f7ff");
			$("#legacy_span2").text("사번");
		}
		
	}
}

// ajax 공통 호출후 에러시 처리 함수
function kepAjaxError(pMethod, response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다. ");
}

function passwordValidCheck1() {
	$("#chkPassword1").val("N");

	if (isEmpty($("#st_user_id").val())) {
		alert("사용자 ID를 입력해 주십시요");
		$("#st_user_id").focus();
		return false;
	}

	if ($("#st_user_id").val().length < chkKorea($("#st_user_id").val())) {
		alert("사용자 ID를 영문으로 입력해 주십시요.");
		$("#st_user_id").focus();
		return false;
	}

	if ($("#id_check_flag").val() == "N") {
		alert("사용자 ID 중복 검사를 먼저 해 주십시요");
		return false;
	}

	if ($("#st_password").val().length == 0) {
		alert("비밀번호가 입력되지 않았습니다. ");
		$("#st_password_confirm").focus();
		$("#st_password").focus();
		showError("#st_password");
		return false;
	}

	if (checkSpace($("#st_password").val()) && $("#st_password").val() != "") {
		alert("비밀번호에 공백문자은 입력할 수 없습니다.   ");
		$("#st_password").val("");
		$("#st_password").focus();
		showError("#st_password");
		return false;
	}

	if ($("#st_password").val().length < 8) {
		alert("비밀번호는 8 자리 이상 사용해야 합니다.");
		$("#st_password_confirm").focus();
		$("#st_password").focus();
		showError("#st_password");
		$("#st_password").select();
		return false;
	}

	if ($("#st_password").val().length < chkKorea($("#st_password").val())) {
		alert("비밀번호는 영문으로 입력해 주십시요.");
		$("#st_password_confirm").focus();
		$("#st_password").focus();
		showError("#st_password");
		return false;
	}

	return true;
}

function passwordValidCheck2() {
	$("#chkPassword2").val("N");

	if (isEmpty($("#st_user_id").val())) {
		alert("사용자 ID를 입력해 주십시요");
		$("#st_user_id").focus();
		showError("#st_user_id");
		return false;
	}

	if ($("#st_user_id").val().length < chkKorea($("#st_user_id").val())) {
		alert("사용자 ID를 영문으로 입력해 주십시요.");
		$("#st_user_id").focus();
		showError("#st_user_id");
		return false;
	}

	if ($("#id_check_flag").val() == "N") {
		alert("사용자 ID 중복 검사를 먼저 해 주십시요");
		return false;
	}

	if ($("#st_password").val().length == 0) {
		alert("비밀번호가 입력되지 않았습니다. ");
		$("#st_password_confirm").focus();
		$("#st_password").focus();
		showError("#st_password");
		return false;
	}

	if (checkSpace($("#st_password").val()) && $("#st_password").val() != "") {
		alert("비밀번호에 공백문자은 입력할 수 없습니다.   ");
		$("#st_password").val("");
		$("#st_password").focus();
		showError("#st_password");
		return false;
	}

	if ($("#st_password").val().length < 8) {
		alert("비밀번호는 8 자리 이상 사용해야 합니다.");
		$("#st_password_confirm").focus();
		$("#st_password").focus();
		$("#st_password").select();
		showError("#st_password");
		return false;
	}

	if ($("#st_password").val().length < chkKorea($("#st_password").val())) {
		alert("비밀번호는 영문으로 입력해 주십시요.");
		$("#st_password_confirm").focus();
		$("#st_password").focus();
		showError("#st_password");
		return false;
	}

	if ($("#st_password_confirm").val().length == 0) {
		alert("비밀번호가 입력되지 않았습니다. ");
		$("#st_password").focus();
		$("#st_password_confirm").focus();
		showError("#st_password_confirm");
		return false;
	}

	if (checkSpace($("#st_password_confirm").val()) && $("#st_password_confirm").val() != "") {
		alert("비밀번호에 공백문자은 입력할 수 없습니다.   ");
		$("#st_password_confirm").val("");
		$("#st_password").focus();
		$("#st_password_confirm").focus();
		showError("#st_password_confirm");
		return false;
	}

	if ($("#st_password_confirm").val().length < 8) {
		alert("비밀번호는 8 자리 이상 사용해야 합니다.");
		$("#st_password").focus();
		$("#st_password_confirm").focus();
		return false;
	}

	if ($("#st_password_confirm").val().length < chkKorea($("#st_password_confirm").val())) {
		alert("비밀번호는 영문으로 입력해 주십시요.");
		$("#st_password").focus();
		$("#st_password_confirm").focus();
		return false;
	}

	if ($("#st_password").val() != $("#st_password_confirm").val()) {
		alert("비밀번호가 일치하지 않습니다.\n다시 한번 입력하시기 바랍니다.");
		$("#st_password").focus();
		$("#st_password_confirm").focus();
		return false;
	}

	return true;
}

// 아이디 칸에 키 입력 시
function idKeyUp() {
	kepToUpper('st_user_id');
	$("#id_check_flag").val("N");
	$("#idCheckMsg").hide();
}

function checkSubmit() {
	$("#st_user_name_loc").val(kepTrimStr($("#st_user_name_loc").val()));
	$("#st_email1").val(kepTrimStr($("#st_email1").val()));
	$("#st_email2").val(kepTrimStr($("#st_email2").val()));

	// 회사 선택 체크
	if (isEmpty($("#st_com_code").val())) {
		alert("회사를 선택해 주세요.");
		showError("#st_com_div");
		return false;
	}

	// ID 체크
	if (isEmpty($("#st_user_id").val())) {
		alert("사용자 ID를 반드시 입력하세요.");
		showError("#st_user_id");
		$("#st_user_id").val("");
		$("#st_user_id").focus();
		return false;
	}

	if ($("#st_user_id").val().length < chkKorea($("#st_user_id").val())) {
		alert("사용자 ID를 영문으로 입력해 주십시요.");
		showError("#st_user_id");
		$("#st_user_id").focus();
		return false;
	}

	if (kepTrim("st_user_id") != $("#st_user_id").val()) {
		alert("사용자 ID는 공백을 포함할 수 없습니다.");
		showError("#st_user_id");
		$("#st_user_id").focus();
		return false;
	}

	if ($("#id_check_flag").val() == "N") {
		alert("사용자 ID 중복 검사를 먼저 해 주십시요");
		showError("#st_user_id");
		return false;
	}

	// 비밀번호 체크
	if ($("#chkPassword1").val() != "Y") {
		doAction("pwdCheck1");
		return false;
	}

	if ($("#chkPassword2").val() != "Y") {
		doAction("pwdCheck2");
		return false;
	}

	// 이름 체크
	if (isEmpty($("#st_user_name_loc").val())) {
		alert("사용자 이름이 입력되지 않았습니다.");
		showError("#st_user_name_loc");
		$("#st_user_name_loc").val("");
		$("#st_user_name_loc").focus();
		return false;
	}

	// 이메일 합치기
	if (isEmpty($("#st_email1").val())) {
		alert("이메일 주소를 입력해 주세요.");
		showError("#st_email1");
		$("#st_email1").focus();
		return false;
	}
	if (isEmpty($("#st_email2").val())) {
		alert("이메일 도메인을 입력해 주세요.");
		showError("#st_email2");
		$("#st_email2").focus();
		return false;
	}
	var emailFull = $("#st_email1").val() + "@" + $("#st_email2").val();
	$("#st_email").val(emailFull);

	if (!checkemail("st_email")) {
		return false;
	}

	// 전화번호 합치기
	if (isEmpty($("#st_phone_number1").val()) || isEmpty($("#st_phone_number2").val()) || isEmpty($("#st_phone_number3").val())) {
		alert("전화번호가 입력되지 않았습니다.");
		if (isEmpty($("#st_phone_number1").val())) {showError("#st_phone_number1"); $("#st_phone_number1").focus(); }
		else if (isEmpty($("#st_phone_number2").val())) {showError("#st_phone_number2"); $("#st_phone_number2").focus(); }
		else {showError("#st_phone_number3"); $("#st_phone_number3").focus(); }
		return false;
	}
	var phoneFull = $("#st_phone_number1").val() + "-" + $("#st_phone_number2").val() + "-" + $("#st_phone_number3").val();

	// 전화번호에 휴대폰 번호 입력 체크
	var dial = $("#st_phone_number1").val().substring(0,2);
	if (dial == '01') {
		alert("전화번호에 휴대폰 번호는 입력하실 수 없습니다.");
		showError("#st_phone_number1");
		return false;
	}
	$("#st_phone_number").val(phoneFull);

	// 휴대폰 합치기
	if (isEmpty($("#st_mobile_phone1").val()) || isEmpty($("#st_mobile_phone2").val()) || isEmpty($("#st_mobile_phone3").val())) {
		alert("휴대폰 번호가 입력되지 않았습니다.");
		if (isEmpty($("#st_mobile_phone1").val())) {showError("#st_mobile_phone1"); $("#st_mobile_phone1").focus(); }
		else if (isEmpty($("#st_mobile_phone2").val())) {showError("#st_mobile_phone2"); $("#st_mobile_phone2").focus(); }
		else {showError("#st_mobile_phone3"); $("#st_mobile_phone3").focus(); }
		return false;
	}

	if ($("#st_mobile_phone1").val().length != 3 || $("#st_mobile_phone2").val().length < 3 || $("#st_mobile_phone3").val().length != 4) {
		alert("휴대폰 번호를 정확히 입력하세요.");
		showError("#st_mobile_phone1");
		$("#st_mobile_phone1").focus();
		return false;
	}
	$("#st_mobile_phone").val($("#st_mobile_phone1").val() + "-" + $("#st_mobile_phone2").val() + "-" + $("#st_mobile_phone3").val());

	// 팩스번호 합치기 (선택사항이므로 입력된 경우만)
	if (!isEmpty($("#st_fax_number1").val()) || !isEmpty($("#st_fax_number2").val()) || !isEmpty($("#st_fax_number3").val())) {
		$("#st_fax_number").val($("#st_fax_number1").val() + "-" + $("#st_fax_number2").val() + "-" + $("#st_fax_number3").val());
	}
	//배송지 정보
	if(isEmpty($("#st_dely_text").val())){
		alert("배송지 정보를 입력하세요.");
		showError("#st_dely_text");
		return false; 
	}

	// 사번 공백 체크
	if (!isEmpty($("#st_legacy_user_id").val())) {
		if (kepTrim("st_legacy_user_id") != $("#st_legacy_user_id").val()) {
			alert("사번은 공백을 포함할 수 없습니다.");
			showError("#st_legacy_user_id");
			$("#st_legacy_user_id").focus();
			return false;
		}
	}

	// 부서 체크
	if (isEmpty($("#st_department_text").val())) {
		alert("부서를 반드시 선택하세요.");
		showError("#st_dept_div");
		return false;
	}

	// 직급 체크
	if (isEmpty($("#st_position_text").val())) {
		alert("직급을 반드시 선택하세요.");
		showError("#st_pos_div");
		return false;
	}

	// 이메일 수신 여부
	if ($("#mail_recv_chk").is(":checked")) {
		$("#st_mail_recv_flag").val("Y");
	} else {
		$("#st_mail_recv_flag").val("N");
	}

	// 약관 동의 체크
	if (!$("#agree_terms").is(":checked")) {
		alert("이용약관에 동의해 주세요.");
		return false;
	}

	// 개인정보 동의 체크
	if (!$("#agree_privacy").is(":checked")) {
		alert("개인정보 수집 및 이용에 동의해 주세요.");
		return false;
	}

	// role 설정
	$("#st_role").val($("#st_user_type").val() + "+");

	return confirm("현재 사용자 정보를 등록하겠습니까 ?");
}
function showError(el) {
	var $el = (el instanceof jQuery) ? el : $(el);
	$el.addClass($el.is("select") ? "select-error" : "input-error");
	if ($el.length > 0 && $el[0].getBoundingClientRect) {
		var rect = $el[0].getBoundingClientRect();
		if (rect.top < 0 || rect.top > window.innerHeight) {
			$('html, body').animate({
				scrollTop: $el.offset().top - (window.innerHeight / 2)
			}, 300);
		}
	}
}
function clearError(el) {
	var $el = (el instanceof jQuery) ? el : $(el);
	$el.removeClass("input-error select-error");
}
function clearAllErrors() {
	$(".input-error, .select-error").removeClass("input-error select-error");
}

//이메일 앞부분에 @ 안들어가도록 수정
const emailInput = document.getElementById("st_email1");
emailInput.addEventListener('keydown',function(e){
	if(e.key === "@") e.preventDefault();
});
emailInput.addEventListener("input",function(){
	this.value = this.value.replace(/@/g,'');
})

// F2 테스트 데이터 자동 주입
$(document).on('keydown', function(e) {
	if (e.keyCode === 113) { // F2
		e.preventDefault();
		// 회사 정보
		$("#st_com_code").val("KRFAGB0003");
		$("#st_com_name_loc").val("코리아이플랫폼(주)");
		$("#st_department").val("D001");
		$("#st_department_text").val("개발팀");
		$("#st_position").val("P003");
		$("#st_position_text").val("대리");
		// 사용자 정보
		var ts = new Date().getTime().toString().slice(-6);
		$("#st_user_id").val("testuser" + ts);
		$("#id_check_flag").val("Y");
		$("#st_user_name_loc").val("테스트사용자");
		$("#st_password").val("Test1234!@");
		$("#st_password_confirm").val("Test1234!@");
		$("#chkPassword1").val("Y");
		$("#chkPassword2").val("Y");
		$("#st_legacy_user_id").val("EMP" + ts);
		// 휴대폰
		$("#st_mobile_phone1").val("010");
		$("#st_mobile_phone2").val("1234");
		$("#st_mobile_phone3").val("5678");
		// 이메일
		$("#st_email1").val("testuser" + ts);
		$("#st_email2").val("gmail.com");
		// 전화번호
		$("#st_phone_number1").val("02");
		$("#st_phone_number2").val("1234");
		$("#st_phone_number3").val("5678");
		// 팩스번호
		$("#st_fax_number1").val("02");
		$("#st_fax_number2").val("1234");
		$("#st_fax_number3").val("5679");
		// 배송지
		$("#st_dely_to_location").val("TEST01");
		$("#st_dely_text").val("서울특별시 강남구 테헤란로 123");
		// 이용약관
		$("#agree_check_all").prop("checked", true);
		$("input[name='agree_check']").prop("checked", true);

		alert("[F2] 테스트 데이터가 입력되었습니다.");
	}
});
</script>
</html>
