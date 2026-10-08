<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	// 앞단 약관동의 화면(masterMdAmMbrcmpyRegList_v2)에서 넘어온 개인정보 수집·이용(선택) 동의 여부.
	// 값은 'Y' 아니면 'N' 으로만 확정한다 (직접 진입 등으로 파라미터가 없으면 미동의로 간주).
	String _infoAgreeFlag = "Y".equals(CommonUtil.nvl(request.getParameter("info_agree"))) ? "Y" : "N";
%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<%@ include file="/WEB-INF/views/common/include/mainHeader_v2.jsp" %>
<link rel="stylesheet" href="/resources/css/flatpickr.min.css" type="text/css" />
<script src="/resources/js/flatpickr.js" type="text/javascript"></script>
<script src="/resources/js/ko.js" type="text/javascript"></script>
<script type="text/javascript" src="/resources/js/common/HttpUtil.js"></script>
<script type="text/javascript" src="/resources/js/common/PopupUtil.js"></script>
</head>
<body onload="kep_onload()">
<div class="wrap">

	<div class="ComNavigation">
      <div class="navigationBar">
        <ul>
        <li onclick="location.href='/main/renewal_buyer_join.do'">고객사 가입 안내</li>
        <li onclick="location.href='/main/renewal_seller_join.do'" class="ON">협력사 가입 안내</li>
        <li onclick="location.href='/main/renewal_faq.do'">자주 묻는 질문</li>
        </ul>
      </div>
    </div>
	<!-- 컨텐츠 -->
    <div class="containerSub">
    <form name="contentForm" id="contentForm" method="post">
      <!-- hidden 필드 -->
      <input type="hidden" id="id_check_flag" name="id_check_flag" value="N" />
      <input type="hidden" id="chkPassword" name="chkPassword" value="N" />
      <input type="hidden" id="st_zip_key" name="st_zip_key" value="" />
      <input type="hidden" id="st_establish_date" name="st_establish_date" value="" />
      <input type="hidden" id="st_usr_zip_key" name="st_usr_zip_key" value="" />
      <input type="hidden" id="st_bank_cd" name="st_bank_cd" value="" />
      <input type="hidden" id="st_mail_send_flag" name="st_mail_send_flag" value="" />
      <input type="hidden" id="st_sms_recv_flag" name="st_sms_recv_flag" value="" />
      <input type="hidden" id="st_itmg1_cd" name="st_itmg1_cd" value="" />
      <input type="hidden" id="st_itmg2_cd" name="st_itmg2_cd" value="" />
      <input type="hidden" id="st_itmg3_cd" name="st_itmg3_cd" value="" />
      <input type="hidden" id="st_itmg4_cd" name="st_itmg4_cd" value="" />
      <input type="hidden" id="st_itmg5_cd" name="st_itmg5_cd" value="" />
      <input type="hidden" id="st_itm_mk1" name="st_itm_mk1" value="" />
      <input type="hidden" id="st_itm_mk2" name="st_itm_mk2" value="" />
      <input type="hidden" id="st_itm_mk3" name="st_itm_mk3" value="" />
      <input type="hidden" id="st_itm_mk4" name="st_itm_mk4" value="" />
      <input type="hidden" id="st_itm_mk5" name="st_itm_mk5" value="" />
      <input type="hidden" id="st_itm_mk1_image_key" name="st_itm_mk1_image_key" value="" />
      <input type="hidden" id="st_itm_mk2_image_key" name="st_itm_mk2_image_key" value="" />
      <input type="hidden" id="st_itm_mk3_image_key" name="st_itm_mk3_image_key" value="" />
      <input type="hidden" id="st_itm_mk4_image_key" name="st_itm_mk4_image_key" value="" />
      <input type="hidden" id="st_itm_mk5_image_key" name="st_itm_mk5_image_key" value="" />
      <input type="hidden" id="st_image_key" name="st_image_key" value="" />
      <input type="hidden" id="st_image_key_org" name="st_image_key_org" value="" />
      <input type="hidden" id="st_pay_date_type" name="st_pay_date_type" value="" />
      <input type="hidden" id="st_kep_damdang_id" name="st_kep_damdang_id" value="" />
      <input type="hidden" id="st_kep_system_ed_year" name="st_kep_system_ed_year" value="2026" />
      <input type="hidden" id="st_kep_system_ed_month" name="st_kep_system_ed_month" value="12" />
      <%-- 앞단 약관동의 화면에서 넘겨받은 개인정보 수집·이용(선택) 동의 여부 --%>
      <input type="hidden" id="st_info_agree_flag" name="st_info_agree_flag" value="<%=_infoAgreeFlag%>" />

      <div class="h80"></div>
      <div class="ComJoinTitLarge" >협력사 회원가입</div>
      <div class="ComJoinTitMedium">기본정보 <span class="F6495F">*표시는 필수 입력사항입니다.</span></div>
	  <table class="ThLTdL" width="100%">
        <colgroup>
          <col width="155px" />
          <col width="275px" />
          <col width="150px" />
          <col width="275px" />
          <col width="150px" />
          <col width="275px" />
        </colgroup>
        <tr>
          <th><span class="F6495F">*</span> 등록구분</th>
          <td><select name="st_reg_type" id="st_reg_type" class="Select" style="width:262px">
              </select>
          </td>
          <th><span class="F6495F">*</span> 사업자등록번호</th>
          <td><input class="input30" style="width:240px" id="st_irs_no" name="st_irs_no" type="text" maxlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'')" />
            <!-- 레거시 사업자등록번호 분할 hidden -->
            <input type="hidden" id="st_irs_no1" name="st_irs_no1" value="" />
            <input type="hidden" id="st_irs_no2" name="st_irs_no2" value="" />
            <input type="hidden" id="st_irs_no3" name="st_irs_no3" value="" /></td>
          <th><span class="F6495F" style="visibility:hidden">*</span> 법인번호</th>
          <td><input class="input30" style="width:240px" id="st_corp_no" name="st_corp_no" type="text" maxlength="13" oninput="this.value=this.value.replace(/[^0-9]/g,'')" />
            <!-- 저장용 법인번호 결합 hidden (XXXXXX-XXXXXXX) -->
            <input type="hidden" id="st_corp_reg_no" name="st_corp_reg_no" value="" /></td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> 회사명(국문)</th>
          <td><input class="input30" style="width:240px" id="st_com_name_loc" name="st_com_name_loc" type="text" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" /></td>
          <th><span class="F6495F">*</span> 회사명(영문)</th>
          <td><input class="input30" style="width:240px" id="st_com_name_eng" name="st_com_name_eng" type="text" maxlength="50" style="ime-mode:disabled;" onkeyup="fnCheckInputByte(this, 50);" /></td>
          <th><span class="F6495F">*</span> 대표자</th>
          <td><input class="input30" style="width:240px" id="st_ceo_name_loc" name="st_ceo_name_loc" type="text" maxlength="40" /></td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> 설립일자</th>
          <td>
            <div class="MonthBtnBox" style="width:262px;" >
              <div class="date-range"  >
                <div class="date-picker"><input type="text" placeholder="" id="establish_date" readonly style="width:200px;" ><div class="calendar-btn" style="left:235px"></div></div>
              </div>
            </div>
          </td>
          <th><span class="F6495F">*</span> 업태</th>
          <td><input class="input30" style="width:240px" id="st_industry_type" name="st_industry_type" type="text" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" /></td>
          <th><span class="F6495F">*</span> 업종</th>
          <td><input class="input30" style="width:240px" id="st_business_items" name="st_business_items" type="text" maxlength="100" onkeyup="fnCheckInputByte(this, 100);" /></td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> 대표 전화번호</th>
          <td style="white-space:nowrap"><input class="input30" style="width:45px" id="st_tel_no1" name="st_tel_no1" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /> - <input class="input30" style="width:62px" id="st_tel_no2" name="st_tel_no2" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /> - <input class="input30" style="width:62px" id="st_tel_no3" name="st_tel_no3" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /></td>
          <th><span class="F6495F">*</span> 대표 팩스번호</th>
          <td style="white-space:nowrap"><input class="input30" style="width:45px" id="st_fax_no1" name="st_fax_no1" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /> - <input class="input30" style="width:62px" id="st_fax_no2" name="st_fax_no2" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /> - <input class="input30" style="width:62px" id="st_fax_no3" name="st_fax_no3" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /></td>
          <th><span class="f2f7ff">*</span> 홈페이지</th>
          <td><input class="input30" style="width:240px" id="st_hp_address" name="st_hp_address" type="text" maxlength="50" /></td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> KeP 담당자</th>
          <td colspan="5">
            <input class="input30" style="width:200px" id="st_kep_damdang_nm" name="st_kep_damdang_nm" type="text" value="" readonly />
            <button type="button" class="ButDarkGray_Small" onclick="doPop('kepManagerPop')">검색</button>
          </td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> 사업장주소</th>
          <td colspan="5" style="white-space:nowrap">
            <input class="input30" style="width:166px" id="st_zip_code" name="st_zip_code" type="text" readonly value="" />
            <button type="button" class="ButDarkGray_Small" onclick="doPop('newzipcode', 'COM')">우편번호</button>
            <input class="input30" style="width:462px" id="st_address" name="st_address" type="text" readonly value="" />
            <input class="input30" style="width:338px" id="st_address_dt" name="st_address_dt" type="text" maxlength="100" value="" />
          </td>
        </tr>
	  </table>
      <div class="ComJoinTitMedium mt50">업체현황</div>
	  <table class="ThLTdL" width="100%">
        <colgroup>
          <col width="155px" />
          <col width="275px" />
          <col width="150px" />
          <col width="275px" />
          <col width="150px" />
          <col width="275px" />
        </colgroup>
        <tr>
          <th><span class="F6495F">*</span> 유통 레벨</th>
          <td><select name="st_biz_type" id="st_biz_type" class="Select" style="width:262px">
              </select>
          </td>
          <th><span class="F6495F">*</span> 총 자본금</th>
          <td><select name="st_capt_amt" id="st_capt_amt" class="Select" style="width:262px">
              </select>
          </td>
          <th><span class="F6495F">*</span> ISO 여부</th>
          <td><select name="st_iso_yn" id="st_iso_yn" class="Select" style="width:262px">
              </select>
          </td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> 전년도 매출액</th>
          <td><select name="st_year_amt" id="st_year_amt" class="Select" style="width:262px">
              </select>
          </td>
          <th><span class="F6495F">*</span> 특허여부</th>
          <td><select name="st_license_yn" id="st_license_yn" class="Select" style="width:262px">
              </select>
          </td>
          <th><span class="F6495F">*</span> 배송차량 수</th>
          <td><select name="st_deliv_equip_cnt" id="st_deliv_equip_cnt" class="Select" style="width:262px">
              </select>
          </td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> <span style="font-size:92%">대표자 동종업계 경력</span></th>
          <td><select name="st_ceo_career" id="st_ceo_career" class="Select" style="width:262px">
              </select>
          </td>
          <th><span class="F6495F">*</span> 상시 근로자 수</th>
          <td colspan="3"><select name="st_emp_cnt" id="st_emp_cnt" class="Select" style="width:262px">
              </select>
          </td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> 납품가능 지역</th>
          <td colspan="5">
            <label class="CheckMediumLabel"><input type="checkbox" id="st_dr_b_all" name="st_dr_b_all" value="Y"><span class="CheckMediumCustom"></span>전체</label>
            <label class="CheckMediumLabel"><input type="checkbox" id="st_dr_b_soodo" name="st_dr_b_soodo" value="Y"><span class="CheckMediumCustom"></span>서울</label>
            <label class="CheckMediumLabel"><input type="checkbox" id="st_dr_b_gyeonggi" name="st_dr_b_gyeonggi" value="Y"><span class="CheckMediumCustom"></span>경기</label>
            <label class="CheckMediumLabel"><input type="checkbox" id="st_dr_b_chungnam" name="st_dr_b_chungnam" value="Y"><span class="CheckMediumCustom"></span>충남</label>
            <label class="CheckMediumLabel"><input type="checkbox" id="st_dr_b_chungbuk" name="st_dr_b_chungbuk" value="Y"><span class="CheckMediumCustom"></span>충북</label>
            <label class="CheckMediumLabel"><input type="checkbox" id="st_dr_b_gyeongnam" name="st_dr_b_gyeongnam" value="Y"><span class="CheckMediumCustom"></span>경남</label>
            <label class="CheckMediumLabel"><input type="checkbox" id="st_dr_b_gyeongbuk" name="st_dr_b_gyeongbuk" value="Y"><span class="CheckMediumCustom"></span>경북</label>
            <label class="CheckMediumLabel"><input type="checkbox" id="st_dr_b_jeonnam" name="st_dr_b_jeonnam" value="Y"><span class="CheckMediumCustom"></span>전남</label>
            <label class="CheckMediumLabel"><input type="checkbox" id="st_dr_b_jeonbuk" name="st_dr_b_jeonbuk" value="Y"><span class="CheckMediumCustom"></span>전북</label>
            <label class="CheckMediumLabel"><input type="checkbox" id="st_dr_b_kangwon" name="st_dr_b_kangwon" value="Y"><span class="CheckMediumCustom"></span>강원</label>
            <label class="CheckMediumLabel"><input type="checkbox" id="st_dr_b_jeju" name="st_dr_b_jeju" value="Y"><span class="CheckMediumCustom"></span>제주</label>
          </td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> MRO 거래 유무</th>
          <td colspan="5">
            <label class="CheckMediumLabel"><input type="checkbox" id="st_mp_business_yn" name="st_mp_business_yn" value="Y" onclick="checkMp(this)"><span class="CheckMediumCustom"></span>해당없음</label>
            <label class="CheckMediumLabel"><input type="checkbox" id="st_mp2_business_yn" name="st_mp2_business_yn" value="Y"><span class="CheckMediumCustom"></span>서브원</label>
            <label class="CheckMediumLabel"><input type="checkbox" id="st_mp1_business_yn" name="st_mp1_business_yn" value="Y"><span class="CheckMediumCustom"></span>아이엠케이</label>
            <label class="CheckMediumLabel"><input type="checkbox" id="st_mp3_business_yn" name="st_mp3_business_yn" value="Y"><span class="CheckMediumCustom"></span>엔투비</label>
            <label class="CheckMediumLabel"><input type="checkbox" id="st_mp4_business_yn" name="st_mp4_business_yn" value="Y"><span class="CheckMediumCustom"></span>케이티커머스</label>
            <label class="CheckMediumLabel"><input type="checkbox" id="st_mp5_business_yn" name="st_mp5_business_yn" value="Y"><span class="CheckMediumCustom"></span>행복나래</label>
          </td>
        </tr>
      </table>
      <div class="ComJoinTitMedium mt50">결제정보</div>
      <table class="ThLTdL" width="100%">
        <colgroup>
          <col width="150px" />
          <col width="490px" />
          <col width="150px" />
          <col width="490px" />
        </colgroup>
        <tr>
          <th><span class="F6495F">*</span> 대금 지급조건</th>
          <td><select name="st_pay_terms" id="st_pay_terms" class="Select" style="width:465px">
              </select>
          </td>
          <th><span class="f2f7ff">*</span> 지급형태</th>
          <td><select id="st_pay_type" name="st_pay_type" class="Select" style="width:465px">
			  </select>
		  </td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> 계좌정보</th>
          <td style="white-space:nowrap">
            <input class="input30" style="width:116px" id="st_bank_name" name="st_bank_name" type="text" readonly value="" />
            <button type="button" class="ButDarkGray_Small" onclick="doPop('bankcode')">은행검색</button>
            <input class="input30" style="width:228px" id="st_bank_account_no" name="st_bank_account_no" type="text" maxlength="30" placeholder="계좌번호" oninput="this.value=this.value.replace(/[^0-9\-]/g,'')" />
           </td>
          <th><span class="F6495F">*</span> 예금주</th>
          <td><input class="input30" style="width:445px" id="st_depositor" name="st_depositor" type="text" maxlength="50" /></td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span><span style="font-size:90%"> 세금계산서발행 동의</span></th>
          <td colspan="3"><label class="CheckMediumLabel"><input type="checkbox" id="st_bill_agree" name="st_bill_agree" value="Y"><span class="CheckMediumCustom"></span>코리아이플랫폼이 스마트빌을 통해 세금계산서를 역발행하는 것에 동의합니다.</label></td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> 물류 수수료 동의</th>
          <td colspan="3"><label class="CheckMediumLabel"><input type="checkbox" id="st_logistics_agree" name="st_logistics_agree" value="Y"><span class="CheckMediumCustom"></span>코리아이플랫폼 물류센터 이용 시 수수료(2%) 부과에 동의합니다.</label></td>
        </tr>
      </table>
      <div class="ComJoinTitMedium mt50">담당자 정보</div>
	  <table class="ThLTdL" width="100%">
        <colgroup>
          <col width="155px" />
          <col width="275px" />
          <col width="150px" />
          <col width="275px" />
          <col width="150px" />
          <col width="275px" />
        </colgroup>
        <tr>
          <th><span class="F6495F">*</span> 관리자명</th>
          <td><input class="input30" style="width:230px" id="st_usr_name_loc" name="st_usr_name_loc" type="text" maxlength="40" /></td>
          <th><span class="F6495F">*</span> 관리자ID</th>
          <td><input class="input30" style="width:153px" id="st_user_id" name="st_user_id" type="text" maxlength="20" autocomplete="off" style="ime-mode:disabled;" onkeyup="kepToUpper('st_user_id'); $('#id_check_flag').val('N'); $('#idCheckMsg').show();" /> <button type="button" class="ButDarkGray_Small" onclick="doAction('idCheck')">중복확인</button> <span id="idCheckMsg" style="font-size:85%; font-weight:600; color:#F6495F; display:none;">중복확인 필요</span> </td>
          <th><span class="F6495F">*</span> 이메일</th>
          <td><input class="input30" style="width:240px" id="st_usr_email" name="st_usr_email" type="text" maxlength="100" /></td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> 비밀번호</th>
          <td colspan="5">
            <p style="width:100px; float:left; font-size:95%; ">비밀번호</p>
            <input class="input30" style="width:210px;" id="st_password" name="st_password" type="password" maxlength="20" autocomplete="new-password" onchange="checkPwdMatch()" oninput="checkPwdFormat()" style="ime-mode:disabled;" />
            <span id="pwdGuideMsg" style="font-size:85%; margin-left:15px">비밀번호는 영문, 숫자, 특수문자 조합으로 8자 이상 사용해야 합니다.</span>
            <p class="h5"></p>
            <p style="width:100px; float:left; font-size:95%; ">비밀번호 확인</p>
            <input class="input30" style="width:210px;" id="st_confirmpasswd" name="st_confirmpasswd" type="password" maxlength="20" autocomplete="new-password" onkeyup="checkPwdMatch()" style="ime-mode:disabled;" />
            <span id="pwdMatchMsg" style="font-size:85%; margin-left:15px; font-weight:600; color:#F6495F; display:none;">불일치</span>
          </td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> 대표 전화번호</th>
          <td style="white-space:nowrap"><input class="input30" style="width:45px" id="st_phone1" name="st_phone1" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /> - <input class="input30" style="width:50px" id="st_phone2" name="st_phone2" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /> - <input class="input30" style="width:62px" id="st_phone3" name="st_phone3" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /></td>
          <th><span class="F6495F">*</span> 휴대폰</th>
          <td style="white-space:nowrap"><input class="input30" style="width:45px" id="st_usr_mobile1" name="st_usr_mobile1" type="text" maxlength="3" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /> - <input class="input30" style="width:45px" id="st_usr_mobile2" name="st_usr_mobile2" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /> - <input class="input30" style="width:62px" id="st_usr_mobile3" name="st_usr_mobile3" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /></td>
           <th><span class="f2f7ff">*</span> 팩스번호</th>
          <td style="white-space:nowrap"><input class="input30" style="width:45px" id="st_usr_fax_no1" name="st_usr_fax_no1" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /> - <input class="input30" style="width:60px" id="st_usr_fax_no2" name="st_usr_fax_no2" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /> - <input class="input30" style="width:62px" id="st_usr_fax_no3" name="st_usr_fax_no3" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /></td>
        </tr>
        <!-- <tr>
          <th><span class="F6495F">*</span> 주소</th>
          <td colspan="5" style="white-space:nowrap">
            <input class="input30" style="width:166px" id="st_usr_zip_code" name="st_usr_zip_code" type="text" readonly value="" />
            <button type="button" class="ButDarkGray_Small" onclick="doPop('newzipcode', 'USR')">우편번호</button>
            <input class="input30" style="width:462px" id="st_usr_address" name="st_usr_address" type="text" readonly value="" />
            <input class="input30" style="width:330px" id="st_usr_address_dt" name="st_usr_address_dt" type="text" maxlength="100" value="" />
          </td>
        </tr> -->
      </table>
      <table class="ThLTdL mt15" width="100%">
        <colgroup>
          <col width="151px" />
          <col width="1125px" />
        </colgroup>
        <tr>
          <th><span class="F6495F">*</span> 영업담당</th>
          <td>
            <label class="CheckMediumLabel"><input type="checkbox" id="chk_sales_same" onclick="copyAdminInfo('sales')"><span class="CheckMediumCustom"></span>관리자와 동일</label>
            <input class="input30" style="width:135px" id="st_gr_emp_nm" name="st_gr_emp_nm" type="text" maxlength="20" placeholder="담당자명" />
            <input class="input30" style="width:135px" id="st_gr_emp_tel" name="st_gr_emp_tel" type="text" maxlength="20" placeholder="전화번호" oninput="this.value=this.value.replace(/[^0-9\-]/g,'')" />
            <input class="input30" style="width:135px" id="st_gr_emp_mobile" name="st_gr_emp_mobile" type="text" maxlength="20" placeholder="휴대폰" oninput="this.value=this.value.replace(/[^0-9\-]/g,'')" />
            <input class="input30" style="width:140px" id="st_gr_emp_email1" name="st_gr_emp_email1" type="text" placeholder="이메일" /> @
            <input class="input30" style="width:140px" id="st_gr_emp_email2" name="st_gr_emp_email2" type="text" />
            <select id="st_gr_email_domain" class="Select" style="width:140px" onchange="setEmailDomain(this, 'st_gr_emp_email2')">
              <option value="">직접입력</option>
              <option value="naver.com">naver.com</option>
              <option value="gmail.com">gmail.com</option>
              <option value="daum.net">daum.net</option>
              <option value="hanmail.net">hanmail.net</option>
            </select>
            <!-- 레거시 영업담당자 전화/휴대폰 분할, 이메일 결합 hidden -->
            <input type="hidden" id="st_gr_emp_tel1" name="st_gr_emp_tel1" value="" />
            <input type="hidden" id="st_gr_emp_tel2" name="st_gr_emp_tel2" value="" />
            <input type="hidden" id="st_gr_emp_tel3" name="st_gr_emp_tel3" value="" />
            <input type="hidden" id="st_gr_emp_mobile1" name="st_gr_emp_mobile1" value="" />
            <input type="hidden" id="st_gr_emp_mobile2" name="st_gr_emp_mobile2" value="" />
            <input type="hidden" id="st_gr_emp_mobile3" name="st_gr_emp_mobile3" value="" />
            <input type="hidden" id="st_gr_emp_email" name="st_gr_emp_email" value="" />
          </td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> 출고담당</th>
          <td>
            <label class="CheckMediumLabel"><input type="checkbox" id="chk_delivery_same" onclick="copyAdminInfo('delivery')"><span class="CheckMediumCustom"></span>관리자와 동일</label>
            <input class="input30" style="width:135px" id="st_de_emp_nm" name="st_de_emp_nm" type="text" maxlength="50" placeholder="담당자명" />
            <input class="input30" style="width:135px" id="st_de_emp_tel_full" name="st_de_emp_tel_full" type="text" maxlength="20" placeholder="전화번호" oninput="this.value=this.value.replace(/[^0-9\-]/g,'')" />
            <input class="input30" style="width:135px" id="st_de_emp_mobile" name="st_de_emp_mobile" type="text" maxlength="20" placeholder="휴대폰" oninput="this.value=this.value.replace(/[^0-9\-]/g,'')" />
            <input class="input30" style="width:140px" id="st_de_emp_email1" name="st_de_emp_email1" type="text" placeholder="이메일" /> @
            <input class="input30" style="width:140px" id="st_de_emp_email2" name="st_de_emp_email2" type="text" />
            <select id="st_de_email_domain" class="Select" style="width:140px" onchange="setEmailDomain(this, 'st_de_emp_email2')">
              <option value="">직접입력</option>
              <option value="naver.com">naver.com</option>
              <option value="gmail.com">gmail.com</option>
              <option value="daum.net">daum.net</option>
              <option value="hanmail.net">hanmail.net</option>
            </select>
            <!-- 레거시 납기담당자 핸드폰 분할 hidden -->
            <input type="hidden" id="st_de_emp_tel1" name="st_de_emp_tel1" value="" />
            <input type="hidden" id="st_de_emp_tel2" name="st_de_emp_tel2" value="" />
            <input type="hidden" id="st_de_emp_tel3" name="st_de_emp_tel3" value="" />
          </td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> 세금계산서 담당</th>
          <td>
            <label class="CheckMediumLabel"><input type="checkbox" id="chk_tax_same" onclick="copyAdminInfo('tax')"><span class="CheckMediumCustom"></span>관리자와 동일</label>
            <input class="input30" style="width:135px" id="st_ac_emp_nm" name="st_ac_emp_nm" type="text" maxlength="20" placeholder="담당자명" />
            <input class="input30" style="width:135px" id="st_ac_emp_tel" name="st_ac_emp_tel" type="text" maxlength="20" placeholder="전화번호" oninput="this.value=this.value.replace(/[^0-9\-]/g,'')" />
            <input class="input30" style="width:135px" id="st_ac_emp_mobile" name="st_ac_emp_mobile" type="text" maxlength="20" placeholder="휴대폰" oninput="this.value=this.value.replace(/[^0-9\-]/g,'')" />
            <input class="input30" style="width:140px" id="st_ac_emp_email1" name="st_ac_emp_email1" type="text" placeholder="이메일" /> @
            <input class="input30" style="width:140px" id="st_ac_emp_email2" name="st_ac_emp_email2" type="text" />
            <select id="st_ac_email_domain" class="Select" style="width:140px" onchange="setEmailDomain(this, 'st_ac_emp_email2')">
              <option value="">직접입력</option>
              <option value="naver.com">naver.com</option>
              <option value="gmail.com">gmail.com</option>
              <option value="daum.net">daum.net</option>
              <option value="hanmail.net">hanmail.net</option>
            </select>
            <!-- 레거시 경리담당자 전화/휴대폰 분할, 이메일 결합 hidden -->
            <input type="hidden" id="st_ac_emp_tel1" name="st_ac_emp_tel1" value="" />
            <input type="hidden" id="st_ac_emp_tel2" name="st_ac_emp_tel2" value="" />
            <input type="hidden" id="st_ac_emp_tel3" name="st_ac_emp_tel3" value="" />
            <input type="hidden" id="st_ac_emp_mobile1" name="st_ac_emp_mobile1" value="" />
            <input type="hidden" id="st_ac_emp_mobile2" name="st_ac_emp_mobile2" value="" />
            <input type="hidden" id="st_ac_emp_mobile3" name="st_ac_emp_mobile3" value="" />
            <input type="hidden" id="st_ac_emp_email" name="st_ac_emp_email" value="" />
          </td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> 전자계약 담당</th>
          <td>
            <label class="CheckMediumLabel"><input type="checkbox" id="chk_econt_same" onclick="copyAdminInfo('econt')"><span class="CheckMediumCustom"></span>관리자와 동일</label>
            <input class="input30" style="width:135px" id="st_econt_name" name="st_econt_name" type="text" maxlength="20" placeholder="담당자명" />
            <input class="input30" style="width:135px" id="st_econt_tel" type="text" maxlength="20" placeholder="전화번호" oninput="this.value=this.value.replace(/[^0-9\-]/g,'')" />
            <input class="input30" style="width:135px" id="st_econt_mobile" name="st_econt_mobile" type="text" maxlength="20" placeholder="휴대폰" oninput="this.value=this.value.replace(/[^0-9\-]/g,'')" />
            <input class="input30" style="width:140px" id="st_econt_email1" name="st_econt_email1" type="text" placeholder="이메일" /> @
            <input class="input30" style="width:140px" id="st_econt_email2" name="st_econt_email2" type="text" />
            <select id="st_econt_email_domain" class="Select" style="width:140px" onchange="setEmailDomain(this, 'st_econt_email2')">
              <option value="">직접입력</option>
              <option value="naver.com">naver.com</option>
              <option value="gmail.com">gmail.com</option>
              <option value="daum.net">daum.net</option>
              <option value="hanmail.net">hanmail.net</option>
            </select>
            <!-- 레거시 전자계약담당자 휴대폰 분할, 이메일 결합 hidden -->
            <input type="hidden" id="st_econt_mobile1" name="st_econt_mobile1" value="" />
            <input type="hidden" id="st_econt_mobile2" name="st_econt_mobile2" value="" />
            <input type="hidden" id="st_econt_mobile3" name="st_econt_mobile3" value="" />
            <input type="hidden" id="st_econt_email" name="st_econt_email" value="" />
          </td>
        </tr>
      </table>
      <p class="Smalltxt" style="margin:8px 0 0">※ 최종승인 전 전자계약이 발송되며, 전자계약 진행 시에는 기업용 공동인증서가 필요합니다.</p>
      <table class="ThLTdL mt15" width="100%">
        <colgroup>
          <col width="155px" />
          <col width="1125px" />
        </colgroup>
        <tr>
          <th><span class="F6495F">*</span> 알림 수신 여부</th>
          <td>
            <label class="CheckMediumLabel"><input type="checkbox" id="mail_send_flag1" name="mail_send_flag" value="Y" checked><span class="CheckMediumCustom"></span>E-mail</label>
            <label class="CheckMediumLabel"><input type="checkbox" id="sms_recv_flag1" name="sms_recv_flag" value="Y"><span class="CheckMediumCustom"></span>휴대폰 문자 메시지</label>
            <p class="Smalltxt"  style="float:right">원활한 업무 처리를 위해 알림 수신에 동의해 주세요.  수신 거부 시 견적의뢰나 발주 안내를 받으실 수 없습니다.</p>
          </td>
        </tr>
      </table>
      <div class="ComJoinTitMedium mt50">
        주요취급 품목
        <span class="Small">*첫행은 대표품목을 등록해주세요. 최대 5까지 등록 가능합니다.</span>
        <p style="float:right"><button type="button" class="ButOutline_Small" onclick="addItemRow()">행추가</button> <button type="button" class="ButOutline_Small" onclick="removeItemRow()">행삭제</button></p>
      </div>
      <table class="ThCTd_ex" id="itemTable" width="100%">
        <colgroup>
          <col width="100px" />
          <col width="340px" />
          <col width="340px" />
          <col width="250px" />
          <col width="250px" />
        </colgroup>
        <thead>
        <tr>
          <th colspan="2"><span class="F6495F">*</span> SG</th>
          <th>제조사</th>
          <th><span class="F6495F">*</span> 유통레벨</th>
          <th>유통레벨 증빙 <p class="Smalltxt">(예.대리점권 계약서류)</p></th>
        </tr>
        </thead>
        <tbody id="itemTableBody">
        <tr data-row="1">
          <td><p class="represent">대표품목</p></td>
          <td>
            <div class="SearchBuyer" style="width:300px; display:inline-block;height:auto;">
              <input type="text" id="st_itmg1_nm" name="st_itmg1_nm" placeholder=" " readonly style="width:85%;">
              <button type="button" onclick="doPop('itmg', '1')">SG검색버튼</button>
            </div>
          </td>
          <td><input class="input30" style="width:290px" id="st_itm_mk1_nm" name="st_itm_mk1_nm" type="text" /></td>
          <td><select name="st_itm_mk1_yn" id="st_itm_mk1_yn" class="Select" style="width:220px" disabled>
            </select>
          </td>
          <td style="white-space:nowrap">
            <input class="input30" style="width:130px" id="st_itm_mk1_file_nm" type="text" readonly />
            <button type="button" class="ButDarkGray_Small" onclick="openItemFileAttach('1')">파일찾기</button>
          </td>
        </tr>
        <tr data-row="2">
          <td></td>
          <td>
            <div class="SearchBuyer" style="width:300px; display:inline-block; height:auto;">
              <input type="text" id="st_itmg2_nm" name="st_itmg2_nm" placeholder=" " readonly style="width:85%;">
              <button type="button" onclick="doPop('itmg', '2')">SG검색버튼</button>
            </div>
          </td>
          <td><input class="input30" style="width:290px" id="st_itm_mk2_nm" name="st_itm_mk2_nm" type="text" /></td>
          <td><select name="st_itm_mk2_yn" id="st_itm_mk2_yn" class="Select" style="width:220px" disabled>
            </select>
          </td>
          <td style="white-space:nowrap">
            <input class="input30" style="width:130px" id="st_itm_mk2_file_nm" type="text" readonly />
            <button type="button" class="ButDarkGray_Small" onclick="openItemFileAttach('2')">파일찾기</button>
          </td>
        </tr>
        </tbody>
      </table>
      <div class="ComJoinTitMedium mt50">제출서류 등록</div>
      <table class="ThCTd" width="100%">
        <colgroup>
          <col width="480px" />
          <col width="100px" />
          <col width="700px" />
        </colgroup>
        <tr>
          <th>문서유형</th>
          <th>파일 업로드</th>
          <th>파일명</th>
        </tr>
        <tr>
          <td><input type="hidden" id="st_biz_licence_doc_yn" name="st_biz_licence_doc_yn" value="Y"><span class="F6495F">*</span> 사업자등록증</td>
          <td align="center"><button type="button" class="ButDarkGray_Small" onclick="openDocAttach(1)">파일첨부</button></td>
          <td><span id="st_image_key_text"></span></td>
        </tr>
        <tr>
          <td><input type="hidden" id="st_bankbook_copy_yn" name="st_bankbook_copy_yn" value="Y"><span class="F6495F">*</span> 통장사본</td>
          <td align="center"><button type="button" class="ButDarkGray_Small" onclick="openDocAttach(2)">파일첨부</button></td>
          <td><span id="st_image_key_text2"></span></td>
        </tr>
        <tr>
          <td><input type="hidden" id="st_seal_cert_doc_yn" name="st_seal_cert_doc_yn" value="Y"><span class="F6495F">*</span> 인감증명서</td>
          <td align="center"><button type="button" class="ButDarkGray_Small" onclick="openDocAttach(3)">파일첨부</button></td>
          <td><span id="st_image_key_text3"></span></td>
        </tr>
        <tr>
          <td><input type="hidden" id="st_using_seal_doc_yn" name="st_using_seal_doc_yn" value="Y"><span class="F6495F">*</span> 사용인감계(통장 사용인감 사용 시 필수)</td>
          <td align="center"><button type="button" class="ButDarkGray_Small" onclick="openDocAttach(4)">파일첨부</button></td>
          <td><span id="st_image_key_text4"></span></td>
        </tr>

      </table>
      <div class="h80"></div>
      <div class="ComButtonArea"><button type="button" class="ButtonMedium" onclick="doAction('save')">가입 신청하기</button></div>
      <div class="h80"></div>
    </form>
    </div><!-- containerSub 끝 -->

    <%@ include file="/WEB-INF/views/common/include/mainFooter_v2.jsp" %>
</div><!-- wrap 끝-->

</body>
</html>
<style>
.input-error { border: 2px solid #F6495F !important; background-color: #FFF5F5 !important; }
.select-error { border: 2px solid #F6495F !important; background-color: #FFF5F5 !important; }
</style>
<script type="text/javascript">
<!--
var popupSel = "";
var popupItem = "";

// 에러 표시/해제 유틸
function showError(el) {
	var $el = (el instanceof jQuery) ? el : $(el);
	$el.addClass($el.is("select") ? "select-error" : "input-error");
	if ($el.length > 0 && $el[0].getBoundingClientRect) {
		var rect = $el[0].getBoundingClientRect();
		if (rect.top < 0 || rect.top > window.innerHeight || $el.is("td")) {
			// TD(체크박스/라디오영역) 거나 화면 밖에 있으면 무조건 스크롤
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

function kep_onload() {
	// 공통코드 기반 select 옵션 동적 로딩
	kepAjaxCommonComboDataValue('st_reg_type', 'M109', '', '');
	kepAjaxCommonComboDataValue('st_biz_type', 'M110', 'SEL', '');
	kepAjaxCommonComboDataValue('st_emp_cnt', 'M111', 'SEL', '');
	kepAjaxCommonComboDataValue('st_iso_yn', 'M112', 'SEL', '');
	kepAjaxCommonComboDataValue('st_license_yn', 'M113', 'SEL', '');
	kepAjaxCommonComboDataValue('st_year_amt', 'M114', 'SEL', '');
	kepAjaxCommonComboDataValue('st_deliv_equip_cnt', 'M115', 'SEL', '');
	kepAjaxCommonComboDataValue('st_capt_amt', 'M129', 'SEL', '');
	kepAjaxCommonComboDataValue('st_ceo_career', 'M128', 'SEL', '');
	kepAjaxCommonComboDataValue('st_pay_terms', 'SA01', 'SEL', '');
	kepAjaxCommonComboDataValue('st_pay_type', 'SA03', 'SEL', '');
	kepAjaxCommonComboDataValue('st_itm_mk1_yn', 'M067', 'SEL', '');
	kepAjaxCommonComboDataValue('st_itm_mk2_yn', 'M067', 'SEL', '');

	// flatpickr 설립일자 초기화
	var fpEstablish = flatpickr("#establish_date", {
		dateFormat: "Y.m.d",
		locale: "ko",
		onChange: function(selectedDates, dateStr) {
			// YYYYMMDD 형식으로 hidden 필드에 세팅
			if (selectedDates.length > 0) {
				var d = selectedDates[0];
				var yyyy = d.getFullYear();
				var mm = String(d.getMonth() + 1).padStart(2, '0');
				var dd = String(d.getDate()).padStart(2, '0');
				$("#st_establish_date").val(yyyy + mm + dd);
			}
		}
	});

	// 달력 버튼 클릭 시 달력 열기
	$(".calendar-btn").on("click", function() {
		fpEstablish.open();
	});

	// 납품가능 지역 - 전체 선택 시 나머지 체크박스 자동 체크/해제
	$("#st_dr_b_all").on("change", function() {
		var isChecked = $(this).is(":checked");
		$("[id^='st_dr_b_']:not(#st_dr_b_all)").prop("checked", isChecked);
	});
	// 납품가능 지역 - 개별 해제 시 전체 체크박스도 해제
	$("[id^='st_dr_b_']:not(#st_dr_b_all)").on("change", function() {
		if (!$(this).is(":checked")) {
			$("#st_dr_b_all").prop("checked", false);
		}
	});

	// 입력/변경 시 에러 테두리 자동 해제
	$("#contentForm").on("input change", "input, select, textarea", function() {
		clearError(this);
		if ($(this).is(":checkbox, :radio")) {
			clearError($(this).closest("td"));
		}
	});
	
	//대금 지급조건 변경 시 지급형태 변경
	$("#st_pay_terms").on("change", function() {
		var st_pay_terms = $(this).val();
		$("#st_pay_type").val(st_pay_terms.charAt(0));
	});
}

// 메인 액션 라우터
function doAction(str) {
	switch (str) {
		case "reload":
			kepReload("contentForm");
			break;
		case "save":
			if (checkSubmit()) {
				uploadAllDocFiles(function() {
					kepAjaxFormCall("/mdam/getMasterMdAmSellerMbrcmpyRegPwdValidCheck.do", "contentForm", "pwdCheckAndSave");
				});
			}
			break;
		case "idCheck":
			if (isEmpty($("#st_user_id").val())) {
				alert("사용자 ID를 입력해 주십시요");
				$("#st_user_id").focus();
				return;
			}
			kepAjaxFormCall("/mdam/getMasterMdAmSellerMbrcmpyRegIDCheck.do", "contentForm", "idCheck");
			break;
		case "pwdCheck":
			if (passwordValidCheck()) {
				kepAjaxFormCall("/mdam/getMasterMdAmSellerMbrcmpyRegPwdValidCheck.do", "contentForm", "pwdCheck");
			}
			break;
	}
}

// 팝업 함수호출
function doPop(str, item) {
	popupSel = str;
	popupItem = item;
	switch (str) {
		case "newzipcode":
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");
			break;
		case "kepManagerPop":
			PopupUtil.open({
				url: '/resources/html/common/popup/kep_manager_list.html',
				onInit: function(api) {
					api.onSelect(function(row) {
						$("#st_kep_damdang_id").val(row.USER_ID);
						$("#st_kep_damdang_nm").val(row.USER_NAME_LOC);
					});
				}
			});
			break;
		case "itmg":
			PopupUtil.open({
				url: '/resources/html/common/popup/sg_code_list.html',
				onInit: function(api) {
					api.onSelect(function(row) {
						$("#st_itmg" + popupItem + "_cd").val(row.SG_ID);
						$("#st_itmg" + popupItem + "_nm").val(row.SG_NAME);
						$("#st_itm_mk" + popupItem + "_yn").removeAttr("disabled");
					});
				}
			});
			break;
		case "itmMk":
			openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
			break;
		case "bankcode":
			PopupUtil.open({
				url: '/resources/html/common/popup/bank_code_list.html',
				onInit: function(api) {
					api.onSelect(function(row) {
						$("#st_bank_cd").val(row.CODE);
						$("#st_bank_name").val(row.TEXT1);
					});
				}
			});
			break;
	}
}

// 서류별 첨부파일 임시 저장소 (File 객체, 가입 신청 시 일괄 업로드)
var docFiles = { 1: null, 2: null, 3: null, 4: null };

// 제출서류 파일첨부 (PopupUtil 레이어 팝업) - 서류별 개별 첨부
function openDocAttach(idx) {
	PopupUtil.callback(function(api) {
		if (api.setDeferUpload) api.setDeferUpload(true);
		api.onConfirm(function(result) {
			docFiles[idx] = result.files;
			var textId = idx === 1 ? "#st_image_key_text" : "#st_image_key_text" + idx;
			$(textId).text(result.fileNames);
		});
	}).show(PopupUtil.POPUP_URLS.FILE_ATTACH2);
}

// 전체 서류 일괄 업로드 (가입 신청 시 호출)
function uploadAllDocFiles(callback) {
	var formData = new FormData();
	var hasFiles = false;
	for (var idx = 1; idx <= 4; idx++) {
		if (docFiles[idx]) {
			for (var i = 0; i < docFiles[idx].length; i++) {
				formData.append('files', docFiles[idx][i].file || docFiles[idx][i]);
				hasFiles = true;
			}
		}
	}
	if (!hasFiles) { callback(); return; }

	var existingDocNo = $("#st_image_key").val();
	if (existingDocNo) formData.append('DOC_NO', existingDocNo);
	formData.append('TYPE', 'REG');

	$.ajax({
		url: '/common/multiFileUploadAjax_v2.do',
		type: 'POST',
		data: formData,
		processData: false,
		contentType: false,
		dataType: 'json',
		success: function(res) {
			if (res.success) {
				$("#st_image_key").val(res.fileKey);
				$("#st_image_key_org").val(res.fileKey);
				callback();
			} else { alert(res.message || '파일 업로드에 실패했습니다.'); }
		},
		error: function() { alert('파일 업로드 중 오류가 발생했습니다.'); }
	});
}

// 주요취급 품목 유통레벨 증빙 파일첨부 (PopupUtil 레이어 팝업)
function openItemFileAttach(idx) {
	PopupUtil.callback(function(api) {
		var docNo = $("#st_itm_mk" + idx + "_image_key").val();
		if (api.loadExistingDoc && docNo) {
			api.loadExistingDoc(docNo);
		}
		api.onConfirm(function(result) {
			$("#st_itm_mk" + idx + "_image_key").val(result.docNo);
			$("#st_itm_mk" + idx + "_file_nm").val(result.fileNames);
		});
	}).show(PopupUtil.POPUP_URLS.FILE_ATTACH);
}

// 팝업 콜백
function setPopupReturn(code, text) {
	switch (popupSel) {
		case "itmg":
			$("#st_itmg" + popupItem + "_cd").val(code);
			$("#st_itmg" + popupItem + "_nm").val(text);
			$("#st_itm_mk" + popupItem + "_yn").removeAttr("disabled");
			break;
		case "itmMk":
			$("#st_itm_mk" + popupItem).val(code);
			$("#st_itm_mk" + popupItem + "_nm").val(text);
			$("#st_itm_mk" + popupItem + "_yn").removeAttr("disabled");
			break;
		case "bankcode":
			$("#st_bank_cd").val(code);
			$("#st_bank_name").val(text);
			break;
	}
}

// 우편번호 콜백
function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn) {
	if (popupItem == "COM") {
		$("#st_zip_code").val(zipNo.replace(/[^0-9]/gi, ''));
		$("#st_zip_key").val(bdMgtSn);
		$("#st_address").val(roadAddrPart1 + " " + roadAddrPart2);
		$("#st_address_dt").val(addrDetail);
	} else {
		$("#st_usr_zip_code").val(zipNo.replace(/[^0-9]/gi, ''));
		$("#st_usr_zip_key").val(bdMgtSn);
		$("#st_usr_address").val(roadAddrPart1 + " " + roadAddrPart2);
		$("#st_usr_address_dt").val(addrDetail);
	}
}

// AJAX 성공 처리
function kepAjaxSuccess(pMethod, response) {
	var sMsg = response.msg;
	if (pMethod == "pwdCheck") {
		if (sMsg != 'OK') {
			alert(sMsg);
			$("#st_password").val("");
			$("#st_password").focus();
			return;
		} else {
			$("#chkPassword").val("Y");
			return;
		}
	} else if (pMethod == "pwdCheckAndSave") {
		if (sMsg != 'OK') {
			alert(sMsg);
			$("#st_password").val("");
			$("#st_password").focus();
			return;
		} else {
			$("#chkPassword").val("Y");
			kepAjaxFormCall("/mdam/saveMasterMdAmSellerMbrcmpyRegList.do", "contentForm", "save");
			return;
		}
	} else if (pMethod == "idCheck") {
		if (sMsg == 'OK') {
			alert("사용가능한 ID 입니다.");
			$("#id_check_flag").val("Y");
			$("#idCheckMsg").hide();
			clearError("#st_user_id");
			return;
		} else {
			alert("이미 사용하고 있는 ID 입니다. 다른 ID를 입력하세요.");
			$("#id_check_flag").val("N");
			$("#idCheckMsg").show();
			$("#st_user_id").val("");
			$("#st_user_id").focus();
			return;
		}
	} else if (pMethod == "save") {
		if (sMsg == "OK") {
			location.href = "/mdam/showMasterMdAmMbrcmpyRegEnd_v2.do?type=B&com_code=" + response.com_code;
			return;
		} else {
			if (sMsg == "Err") {
				alert("협력사 및 Admin 사용자 등록이 실패 하였습니다.\n다시 확인하여 주십시요!");
			} else if (sMsg == "irs") {
				alert("이미 등록된 업체입니다.\n다시 확인하여 주십시요!");
				return;
			} else if (sMsg == "9999") {
				alert("한 회사에서 9999건 이상 초과해서 등록할 수 없습니다.");
				return;
			}
		}
	}
}

// AJAX 에러 처리
function kepAjaxError(pMethod, response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.");
}

// ==============================
// 유효성 검증
// ==============================

function checkSubmit() {
	$("#st_com_name_loc").val(kepTrimStr($("#st_com_name_loc").val()));
	$("#st_com_name_eng").val(kepTrimStr($("#st_com_name_eng").val()));
	$("#st_ceo_name_loc").val(kepTrimStr($("#st_ceo_name_loc").val()));
	$("#st_usr_name_loc").val(kepTrimStr($("#st_usr_name_loc").val()));
	$("#st_usr_email").val(kepTrimStr($("#st_usr_email").val()));
	$("#st_gr_emp_nm").val(kepTrimStr($("#st_gr_emp_nm").val()));
	$("#st_de_emp_nm").val(kepTrimStr($("#st_de_emp_nm").val()));
	$("#st_ac_emp_nm").val(kepTrimStr($("#st_ac_emp_nm").val()));
	$("#st_econt_name").val(kepTrimStr($("#st_econt_name").val()));
	clearAllErrors();
	if (!checkCompanyInfo()) return false;
	if (!checkUserInfo()) return false;
	if (!checkBusinessInfo()) return false;
	if (!checkPaymentInfo()) return false;
	if (!checkNotificationInfo()) return false;
	if (!checkDocumentInfo()) return false;

	// 출고담당자 핸드폰 분할 세팅
	splitDeliveryTel();

	// 레거시 파라미터명 hidden 동기화
	syncLegacyFields();

	return confirm("협력회원사 및 Admin 사용자를 등록 하시겠습니까?");
}

// 회사정보 체크
function checkCompanyInfo() {
	if ($("#st_reg_type").val() == "") {
		alert("등록구분을 선택해 주세요.");
		showError("#st_reg_type");
		$("#st_reg_type").focus();
		return false;
	}
	if (isEmpty($("#st_com_name_loc").val())) {
		alert("한글 회사명을 입력해주세요.");
		showError("#st_com_name_loc");
		$("#st_com_name_loc").focus();
		return false;
	}
	if (isEmpty($("#st_com_name_eng").val())) {
		alert("영문 회사명을 입력해주세요.");
		showError("#st_com_name_eng");
		$("#st_com_name_eng").focus();
		return false;
	}
	if (kepTrimStr($("#st_com_name_eng").val()).length < chkKorea(kepTrimStr($("#st_com_name_eng").val()))) {
		alert("영문회사명을 영문으로 입력해 주십시요.");
		showError("#st_com_name_eng");
		$("#st_com_name_eng").focus();
		return false;
	}
	if (kepTrimStr($("#st_com_name_eng").val()).length < 4) {
		alert("영문 회사명을 4자리 이상 입력해 주십시오");
		showError("#st_com_name_eng");
		$("#st_com_name_eng").focus();
		return false;
	}
	if (!checkSpecialChar(kepTrimStr($("#st_com_name_eng").val()))) {
		alert("영문 회사명에 특수기호(%,$,&,*,@,!,#)를 사용 할수 없습니다.");
		showError("#st_com_name_eng");
		$("#st_com_name_eng").focus();
		return false;
	}
	// 사업자등록번호 검증
	var irsNo = $("#st_irs_no").val().replace(/[^0-9]/g, '');
	if (isEmpty(irsNo)) {
		alert('사업자 등록 번호를 입력 하여 주십시오');
		showError("#st_irs_no");
		$("#st_irs_no").focus();
		return false;
	}
	if (irsNo.length != 10) {
		alert("사업자등록번호는 숫자 10자리 입니다.");
		showError("#st_irs_no");
		$("#st_irs_no").focus();
		return false;
	}
	$("#st_irs_no").val(irsNo);
	if (!KepBizNoCheckStr2(irsNo)) {
		alert("사업자 등록번호가 유효하지 않습니다.");
		showError("#st_irs_no");
		$("#st_irs_no").focus();
		return false;
	}
	if (isEmpty($("#st_industry_type").val())) {
		alert("업태를 입력해 주십시요.");
		showError("#st_industry_type");
		$("#st_industry_type").focus();
		return false;
	}
	if (isEmpty($("#st_business_items").val())) {
		alert("업종을 입력해 주십시요.");
		showError("#st_business_items");
		$("#st_business_items").focus();
		return false;
	}
	if (isEmpty($("#st_ceo_name_loc").val())) {
		alert("대표자명을 입력해주세요.");
		showError("#st_ceo_name_loc");
		$("#st_ceo_name_loc").focus();
		return false;
	}
	if (isEmpty($("#establish_date").val())) {
		alert("설립일자를 선택해 주십시요.");
		showError("#establish_date");
		$("#establish_date").focus();
		return false;
	}
	// 설립일자 hidden 세팅
	$("#st_establish_date").val($("#establish_date").val().replace(/[.]/gi, ""));

	if (isEmpty($("#st_tel_no1").val()) || isEmpty($("#st_tel_no2").val()) || isEmpty($("#st_tel_no3").val())) {
		alert('대표번호를 입력 하여 주십시오');
		showError("#st_tel_no1"); showError("#st_tel_no2"); showError("#st_tel_no3");
		if (isEmpty($("#st_tel_no1").val())) { $("#st_tel_no1").focus(); }
		else if (isEmpty($("#st_tel_no2").val())) { $("#st_tel_no2").focus(); }
		else { $("#st_tel_no3").focus(); }
		return false;
	}
	if (isEmpty($("#st_fax_no1").val()) || isEmpty($("#st_fax_no2").val()) || isEmpty($("#st_fax_no3").val())) {
		alert('대표 팩스번호를 입력 하여 주십시오');
		showError("#st_fax_no1"); showError("#st_fax_no2"); showError("#st_fax_no3");
		if (isEmpty($("#st_fax_no1").val())) { $("#st_fax_no1").focus(); }
		else if (isEmpty($("#st_fax_no2").val())) { $("#st_fax_no2").focus(); }
		else { $("#st_fax_no3").focus(); }
		return false;
	}
	if (isEmpty($("#st_kep_damdang_id").val())) {
		alert("KEP 담당자를 선택 하여주십시오");
		showError("#st_kep_damdang_nm");
		return false;
	}
	if ($("#st_ceo_career").val() == "") {
		alert("대표자 동종업계 경력을 선택 하세요");
		showError("#st_ceo_career");
		$("#st_ceo_career").focus();
		return false;
	}
	if ($("#st_biz_type").val() == "") {
		alert("유통레벨을 선택 하세요");
		showError("#st_biz_type");
		$("#st_biz_type").focus();
		return false;
	}
	if ($("#st_emp_cnt").val() == "") {
		alert("상시 근로자 수를 선택 하세요");
		showError("#st_emp_cnt");
		$("#st_emp_cnt").focus();
		return false;
	}
	if (isEmpty($("#st_zip_code").val())) {
		alert("사업장 우편번호를 선택 하여주십시오");
		showError("#st_zip_code");
		$("#st_zip_code").focus();
		return false;
	}
	if (isEmpty($("#st_zip_key").val())) {
		alert("사업장 주소를 도로명 주소로 변경 바랍니다.");
		showError("#st_zip_code");
		$("#st_zip_code").focus();
		return false;
	}
	if (isEmpty($("#st_address").val())) {
		alert("사업장 주소를 선택 하여주십시오");
		showError("#st_address");
		$("#st_address").focus();
		return false;
	}
	return true;
}

// 사용자정보 체크
function checkUserInfo() {
	if (isEmpty($("#st_usr_name_loc").val())) {
		alert("관리자명을 입력 하여 주십시오.");
		showError("#st_usr_name_loc");
		$("#st_usr_name_loc").focus();
		return false;
	}
	if (!/^[가-힣a-zA-Z\s]+$/.test($.trim($("#st_usr_name_loc").val()))) {
		alert("관리자명은 완성형 한글 또는 영문만 입력 가능합니다.");
		showError("#st_usr_name_loc");
		$("#st_usr_name_loc").focus();
		return false;
	}
	if (isEmpty($("#st_user_id").val())) {
		alert("사용할 ID를 입력 하여 주십시오");
		showError("#st_user_id");
		$("#st_user_id").focus();
		return false;
	}
	if ($("#st_user_id").val().length < chkKorea($("#st_user_id").val())) {
		alert("사용자 ID를 영문으로 입력해 주십시요.");
		showError("#st_user_id");
		$("#st_user_id").focus();
		return false;
	}
	if (!checkSpecialChar(kepTrimStr($("#st_user_id").val()))) {
		alert("아이디에 특수기호(%,$,&,*,@,!,#)를 사용 할수 없습니다.");
		showError("#st_user_id");
		$("#st_user_id").focus();
		return false;
	}
	if (kepTrimStr($("#st_user_id").val()) != $("#st_user_id").val() || containsWhitespace($("#st_user_id").val())) {
		alert("사용자 ID는 공백을 포함할 수 없습니다.");
		showError("#st_user_id");
		$("#st_user_id").focus();
		return false;
	}
	if ($("#id_check_flag").val() != "Y") {
		alert("아이디 중복 검사를 해주십시오");
		showError("#st_user_id");
		$("#st_user_id").focus();
		return false;
	}
	if (!passwordValidCheck()) {
		return false;
	}
	if (isEmpty($("#st_phone1").val()) || isEmpty($("#st_phone2").val()) || isEmpty($("#st_phone3").val())) {
		alert("대표 전화번호를 입력 하여 주십시오");
		showError("#st_phone1"); showError("#st_phone2"); showError("#st_phone3");
		setTimeout(function() {
			if (isEmpty($("#st_phone1").val())) { $("#st_phone1").focus(); }
			else if (isEmpty($("#st_phone2").val())) { $("#st_phone2").focus(); }
			else { $("#st_phone3").focus(); }
		}, 10);
		return false;
	}
	if (isEmpty($("#st_usr_email").val())) {
		alert("E-Mail 주소를 입력해 주십시오.");
		showError("#st_usr_email");
		$("#st_usr_email").focus();
		return false;
	}
	if (!checkemail("st_usr_email")) return false;
	if (isEmpty($("#st_usr_mobile1").val()) || isEmpty($("#st_usr_mobile2").val()) || isEmpty($("#st_usr_mobile3").val())) {
		alert("휴대폰 번호를 입력 하여 주십시오");
		showError("#st_usr_mobile1"); showError("#st_usr_mobile2"); showError("#st_usr_mobile3");
		setTimeout(function() {
			if (isEmpty($("#st_usr_mobile1").val())) { $("#st_usr_mobile1").focus(); }
			else if (isEmpty($("#st_usr_mobile2").val())) { $("#st_usr_mobile2").focus(); }
			else { $("#st_usr_mobile3").focus(); }
		}, 10);
		return false;
	}
	/* if (isEmpty($("#st_usr_zip_code").val())) {
		alert("주소 우편번호를 입력 하세요.");
		showError("#st_usr_zip_code");
		$("#st_usr_zip_code").focus();
		return false;
	}
	if (isEmpty($("#st_usr_zip_key").val())) {
		alert("주소를 도로명 주소로 변경 바랍니다.");
		showError("#st_usr_zip_code");
		$("#st_usr_zip_code").focus();
		return false;
	}
	if (isEmpty($("#st_usr_address").val())) {
		alert("주소를 입력 하세요.");
		showError("#st_usr_address");
		$("#st_usr_address").focus();
		return false;
	} */
	// 출고담당자
	if (isEmpty($("#st_de_emp_nm").val())) {
		alert("출고담당 담당자명을 입력 하여 주십시오.");
		showError("#st_de_emp_nm");
		$("#st_de_emp_nm").focus();
		return false;
	}
	if (!validatePhone("st_de_emp_mobile", "출고담당 휴대폰을 입력 하여 주십시오.")) return false;
	if (!validateSplitEmail("st_de_emp_email1", "st_de_emp_email2", "출고담당")) return false;
	return true;
}

// 업체현황 체크
function checkBusinessInfo() {
	var itmgSelectCount = 0;
	for (var i = 1; i <= 5; i++) {
		if (!isEmpty($("#st_itmg" + i + "_cd").val())) itmgSelectCount++;
	}
	if (itmgSelectCount < 1) {
		alert("취급품목을 1개 이상 선택 해 주십시오");
		showError("#st_itmg1_nm");
		return false;
	}
	for (var i = 1; i <= 5; i++) {
		if (!isEmpty($("#st_itmg" + i + "_cd").val()) && isEmpty($("#st_itm_mk" + i + "_yn").val())) {
			alert("취급품목 " + i + "행의 유통레벨을 선택 해 주십시오");
			showError("#st_itm_mk" + i + "_yn");
			$("#st_itm_mk" + i + "_yn").focus();
			return false;
		}
	}
	if (!$("#st_mp_business_yn").is(":checked") && !$("#st_mp1_business_yn").is(":checked") && !$("#st_mp2_business_yn").is(":checked") && !$("#st_mp3_business_yn").is(":checked") && !$("#st_mp4_business_yn").is(":checked") && !$("#st_mp5_business_yn").is(":checked")) {
		alert("MRO 거래 유무를 체크 해 주십시오");
		showError($("#st_mp_business_yn").closest("td"));
		return false;
	}
	if ($("#st_iso_yn").val() == "") {
		alert("ISO 보유여부를 선택 하세요");
		showError("#st_iso_yn");
		$("#st_iso_yn").focus();
		return false;
	}
	if ($("#st_license_yn").val() == "") {
		alert("특허 보유여부를 선택 하세요");
		showError("#st_license_yn");
		$("#st_license_yn").focus();
		return false;
	}
	if ($("#st_year_amt").val() == "") {
		alert("전년도 매출액을 선택 하세요");
		showError("#st_year_amt");
		$("#st_year_amt").focus();
		return false;
	}
	if ($("#st_capt_amt").val() == "") {
		alert("총자본금을 선택 하세요");
		showError("#st_capt_amt");
		$("#st_capt_amt").focus();
		return false;
	}
	// 납품가능 지역 체크
	var regionChecked = false;
	$("[id^='st_dr_b_']").each(function() {
		if ($(this).is(":checked")) regionChecked = true;
	});
	if (!regionChecked) {
		alert("납품가능 지역을 하나 이상 선택 하십시오");
		showError($("#st_dr_b_all").closest("td"));
		return false;
	}
	if ($("#st_deliv_equip_cnt").val() == "") {
		alert("배송차량 수를 선택 하세요");
		showError("#st_deliv_equip_cnt");
		$("#st_deliv_equip_cnt").focus();
		return false;
	}
	return true;
}

// 결제정보 체크
function checkPaymentInfo() {
	if (isEmpty(kepTrimStr($("#st_ac_emp_nm").val()))) {
		alert("세금계산서 담당자를 입력 해주십시오");
		showError("#st_ac_emp_nm");
		$("#st_ac_emp_nm").focus();
		return false;
	}
	if (!validatePhone("st_ac_emp_tel", "세금계산서 담당자 전화번호를 입력 해주십시오")) return false;
	if (!validatePhone("st_ac_emp_mobile", "세금계산서 담당자 휴대폰을 입력 해주십시오")) return false;
	if (!validateSplitEmail("st_ac_emp_email1", "st_ac_emp_email2", "세금계산서 담당자")) return false;
	if (isEmpty(kepTrimStr($("#st_gr_emp_nm").val()))) {
		alert("영업 담당자를 입력 해주십시오");
		showError("#st_gr_emp_nm");
		$("#st_gr_emp_nm").focus();
		return false;
	}
	if (!validatePhone("st_gr_emp_tel", "영업 담당자 전화번호를 입력 해주십시오")) return false;
	if (!validatePhone("st_gr_emp_mobile", "영업 담당자 휴대폰을 입력 해주십시오")) return false;
	if (!validateSplitEmail("st_gr_emp_email1", "st_gr_emp_email2", "영업 담당자")) return false;
	if (isEmpty(kepTrimStr($("#st_econt_name").val()))) {
		alert("전자계약 담당자를 입력 해주십시오");
		showError("#st_econt_name");
		$("#st_econt_name").focus();
		return false;
	}
	if (!validatePhone("st_econt_mobile", "전자계약 담당자 휴대폰을 입력 해주십시오")) return false;
	if (!validateSplitEmail("st_econt_email1", "st_econt_email2", "전자계약 담당자")) return false;
	if ($("#st_pay_terms").val() == "") {
		alert("지급조건을 선택해 주십시요.");
		showError("#st_pay_terms");
		$("#st_pay_terms").focus();
		return false;
	}
	if (!$("#st_bill_agree").is(":checked")) {
		alert("세금계산서를 역발행하는것에 동의해주시기 바랍니다.");
		showError($("#st_bill_agree").closest("td"));
		return false;
	}
	if (!$("#st_logistics_agree").is(":checked")) {
		alert("물류수수료 징수에 동의해주시기 바랍니다.");
		showError($("#st_logistics_agree").closest("td"));
		return false;
	}
	if (isEmpty(kepTrimStr($("#st_bank_cd").val()))) {
		alert("은행을 선택 해주십시오");
		showError("#st_bank_name");
		$("#st_bank_name").focus();
		return false;
	}
	if (isEmpty(kepTrimStr($("#st_bank_account_no").val()))) {
		alert("계좌번호를 입력 해주십시오");
		showError("#st_bank_account_no");
		$("#st_bank_account_no").focus();
		return false;
	}
	if (isEmpty(kepTrimStr($("#st_depositor").val()))) {
		alert("예금주명을 입력 해주십시오");
		showError("#st_depositor");
		$("#st_depositor").focus();
		return false;
	}
	return true;
}

// 알림수신 체크
function checkNotificationInfo() {
	var mailChecked = $("input[name=mail_send_flag]:checked").length > 0;
	var smsChecked = $("input[name=sms_recv_flag]:checked").length > 0;

	if (!mailChecked && !smsChecked) {
		alert("메일 또는 SMS 중 하나이상을 수신하셔야 합니다.\n메일 수신 또는 SMS수신을 선택해 주세요");
		showError($("#mail_send_flag1").closest("td"));
		return false;
	}
	// hidden 필드에 세팅
	if (mailChecked) {
		$("#st_mail_send_flag").val($("input[name=mail_send_flag]:checked").val());
	} else {
		$("#st_mail_send_flag").val("N");
	}
	if (smsChecked) {
		$("#st_sms_recv_flag").val($("input[name=sms_recv_flag]:checked").val());
	} else {
		$("#st_sms_recv_flag").val("N");
	}
	return true;
}

// 제출서류 체크 (4개 전부 필수)
function checkDocumentInfo() {
	var labels = {1: '사업자등록증', 2: '통장사본', 3: '인감증명서', 4: '상용인감계'};
	for (var idx = 1; idx <= 4; idx++) {
		if (!docFiles[idx]) {
			alert(labels[idx] + '를 첨부해 주십시오.');
			return false;
		}
	}
	return true;
}

// 비밀번호 유효성 검증
function passwordValidCheck() {
	$("#chkPassword").val("N");

	if (isEmpty($("#st_user_id").val())) {
		alert("사용할 ID를 입력 하여 주십시오");
		showError("#st_user_id");
		$("#st_user_id").focus();
		return false;
	}
	if ($("#st_user_id").val().length < chkKorea($("#st_user_id").val())) {
		alert("사용자 ID를 영문으로 입력해 주십시요.");
		showError("#st_user_id");
		$("#st_user_id").focus();
		return false;
	}
	if (!checkSpecialChar(kepTrimStr($("#st_user_id").val()))) {
		alert("아이디에 특수기호(%,$,&,*,@,!,#)를 사용 할수 없습니다.");
		showError("#st_user_id");
		$("#st_user_id").focus();
		return false;
	}
	if ($("#id_check_flag").val() != "Y") {
		alert("아이디 중복 검사를 해주십시오");
		showError("#st_user_id");
		$("#st_user_id").focus();
		return false;
	}
	if ($("#st_password").val().length == 0) {
		alert("비밀번호가 입력되지 않았습니다.");
		showError("#st_password");
		$("#st_password").focus();
		return false;
	}
	if (checkSpace($("#st_password").val()) && $("#st_password").val() != "") {
		alert("비밀번호에 공백문자는 입력할 수 없습니다.");
		showError("#st_password");
		$("#st_password").val("");
		$("#st_password").focus();
		return false;
	}
	if ($("#st_password").val().length < 8) {
		alert("비밀번호는 8자리 이상 사용해야 합니다.");
		showError("#st_password");
		$("#st_password").focus();
		return false;
	}
	if ($("#st_password").val().length < chkKorea($("#st_password").val())) {
		alert("비밀번호는 영문으로 입력해 주십시요.");
		showError("#st_password");
		$("#st_password").focus();
		return false;
	}
	if (!/^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[~!@#$%^&*()_+\-={}\[\]:";'<>?,.\/]).{8,}$/.test($("#st_password").val())) {
		alert("비밀번호는 영문, 숫자, 특수문자를 모두 조합하여 8자 이상 입력해야 합니다.");
		showError("#st_password");
		$("#st_password").focus();
		return false;
	}
	if ($("#st_confirmpasswd").val().length == 0) {
		alert("비밀번호 확인이 입력되지 않았습니다.");
		showError("#st_confirmpasswd");
		$("#st_confirmpasswd").focus();
		return false;
	}
	if (checkSpace($("#st_confirmpasswd").val()) && $("#st_confirmpasswd").val() != "") {
		alert("비밀번호에 공백문자는 입력할 수 없습니다.");
		showError("#st_confirmpasswd");
		$("#st_confirmpasswd").val("");
		$("#st_confirmpasswd").focus();
		return false;
	}
	if ($("#st_confirmpasswd").val().length < 8) {
		alert("비밀번호는 8자리 이상 사용해야 합니다.");
		showError("#st_confirmpasswd");
		$("#st_confirmpasswd").focus();
		return false;
	}
	if ($("#st_confirmpasswd").val().length < chkKorea($("#st_confirmpasswd").val())) {
		alert("비밀번호는 영문으로 입력해 주십시요.");
		showError("#st_confirmpasswd");
		$("#st_confirmpasswd").focus();
		return false;
	}
	if ($("#st_password").val() != $("#st_confirmpasswd").val()) {
		alert("비밀번호가 일치하지 않습니다.\n다시 한번 입력하시기 바랍니다.");
		showError("#st_password"); showError("#st_confirmpasswd");
		$("#st_password").focus();
		return false;
	}
	return true;
}

// ==============================
// 유틸리티 함수
// ==============================

// 비밀번호 양식 실시간 검증 (가이드 문구 색상 강조)
function checkPwdFormat() {
	var pwd = $("#st_password").val();
	var pwdRegex = /^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[~!@#$%^&*()_+\-={}\[\]:";'<>?,.\/]).{8,}$/;
	if (pwd.length == 0) {
		// 빈 값: 기본(회색) 복원
		$("#pwdGuideMsg").css({ "color": "", "font-weight": "" });
	} else if (!pwdRegex.test(pwd)) {
		// 미충족: 빨강 강조
		$("#pwdGuideMsg").css({ "color": "#F6495F", "font-weight": "600" });
	} else {
		// 충족: 초록
		$("#pwdGuideMsg").css({ "color": "#4CAF50", "font-weight": "600" });
	}
}

// 비밀번호 실시간 일치 확인
function checkPwdMatch() {
	var pwd = $("#st_password").val();
	var confirm = $("#st_confirmpasswd").val();
	if (confirm.length == 0) {
		$("#pwdMatchMsg").hide();
	} else if (pwd != confirm) {
		$("#pwdMatchMsg").text("불일치").css("color", "#F6495F").show();
	} else {
		$("#pwdMatchMsg").text("일치").css("color", "#4CAF50").show();
	}
}

// 전화번호 체크
function checkPhoneNumber(str) {
	for (var i = 2; i <= 3; i++) {
		if (isEmpty($("#" + str + i).val())) {
			alert("전화번호를 입력 하여 주십시오");
			$("#" + str + i).focus();
			return false;
		}
		if (i == 2 && $("#" + str + i).val().length < 3) {
			alert("국번을 정확히 입력 해주세요");
			$("#" + str + i).focus();
			return false;
		} else if (i == 3 && $("#" + str + i).val().length != 4) {
			alert("전화번호를 정확히 입력 해주세요");
			$("#" + str + i).focus();
			return false;
		}
	}
	return true;
}

// 특수문자 체크
function checkSpecialChar(str) {
	for (var i = 0; i < str.length; i++) {
		if (str.charAt(i) == '%' || str.charAt(i) == '$' || str.charAt(i) == '&' || str.charAt(i) == '*' || str.charAt(i) == '@' || str.charAt(i) == '!' || str.charAt(i) == '#') {
			return false;
		}
	}
	return true;
}

// 분리 이메일 검증 헬퍼 (양쪽 모두 입력된 경우에만 검사)
// 3분할 번호를 하이픈으로 조립. 한 칸이라도 비면 빈 문자열을 돌려준다.
function joinTel3(id1, id2, id3) {
	var a = kepTrimStr($("#" + id1).val() || "");
	var b = kepTrimStr($("#" + id2).val() || "");
	var c = kepTrimStr($("#" + id3).val() || "");
	return (a && b && c) ? a + "-" + b + "-" + c : "";
}

// 전화/휴대폰 필수 검증. 숫자가 하나도 없으면(예: "--") 미입력으로 본다.
function validatePhone(id, msg) {
	var v = kepTrimStr($("#" + id).val() || "");
	if (isEmpty(v) || v.replace(/[^0-9]/g, "") === "") {
		alert(msg);
		showError("#" + id);
		$("#" + id).focus();
		return false;
	}
	return true;
}

function validateSplitEmail(id1, id2, label) {
	var p1 = $.trim($("#" + id1).val());
	var p2 = $.trim($("#" + id2).val());
	if (!p1 && !p2) return true; // 미입력(선택) → 통과
	if (p1.indexOf("@") !== -1) {
		alert(label + " 이메일 아이디(@ 앞)에는 @를 포함할 수 없습니다.");
		showError("#" + id1);
		$("#" + id1).focus();
		return false;
	}
	if (!/^[0-9a-zA-Z][_0-9a-zA-Z.\-]*@[_0-9a-zA-Z\-]+(\.[_0-9a-zA-Z\-]+){1,3}$/.test(p1 + "@" + p2)) {
		alert(label + " 이메일 형식이 올바르지 않습니다. 예) aaa@aaa.com");
		showError("#" + id1);
		$("#" + id1).focus();
		return false;
	}
	return true;
}

// MRO 거래 유무 - 해당없음 체크
function checkMp(obj) {
	if (obj.checked) {
		for (var i = 1; i <= 5; i++) {
			$("#st_mp" + i + "_business_yn").prop("checked", false).prop("disabled", true);
		}
	} else {
		for (var i = 1; i <= 5; i++) {
			$("#st_mp" + i + "_business_yn").prop("checked", false).prop("disabled", false);
		}
	}
}

// 관리자와 동일 체크 시 정보 복사
function copyAdminInfo(type) {
	var isChecked = false;
	if (type == 'sales') isChecked = $("#chk_sales_same").is(":checked");
	if (type == 'delivery') isChecked = $("#chk_delivery_same").is(":checked");
	if (type == 'tax') isChecked = $("#chk_tax_same").is(":checked");
	if (type == 'econt') isChecked = $("#chk_econt_same").is(":checked");

	if (isChecked) {
		var name = $("#st_usr_name_loc").val();
		// 세 칸이 모두 채워졌을 때만 조립한다. 하나라도 비면 "--" 같은 값이 복사돼
		// 필수 검증까지 통과해버리므로 빈 값으로 둔다.
		var tel = joinTel3("st_phone1", "st_phone2", "st_phone3");
		var mobile = joinTel3("st_usr_mobile1", "st_usr_mobile2", "st_usr_mobile3");
		var email = $("#st_usr_email").val();
		var emailParts = email.split("@");
		var emailId = emailParts[0] || "";
		var emailDomain = emailParts[1] || "";

		if (type == 'sales') {
			$("#st_gr_emp_nm").val(name);
			$("#st_gr_emp_tel").val(tel);
			$("#st_gr_emp_mobile").val(mobile);
			$("#st_gr_emp_email1").val(emailId);
			$("#st_gr_emp_email2").val(emailDomain);
		} else if (type == 'delivery') {
			$("#st_de_emp_nm").val(name);
			$("#st_de_emp_tel_full").val(tel);
			$("#st_de_emp_mobile").val(mobile);
			$("#st_de_emp_email1").val(emailId);
			$("#st_de_emp_email2").val(emailDomain);
		} else if (type == 'tax') {
			$("#st_ac_emp_nm").val(name);
			$("#st_ac_emp_tel").val(tel);
			$("#st_ac_emp_mobile").val(mobile);
			$("#st_ac_emp_email1").val(emailId);
			$("#st_ac_emp_email2").val(emailDomain);
		} else if (type == 'econt') {
			$("#st_econt_name").val(name);
			$("#st_econt_tel").val(tel);
			$("#st_econt_mobile").val(mobile);
			$("#st_econt_email1").val(emailId);
			$("#st_econt_email2").val(emailDomain);
		}
	} else {
		if (type == 'sales') {
			$("#st_gr_emp_nm, #st_gr_emp_tel, #st_gr_emp_mobile, #st_gr_emp_email1, #st_gr_emp_email2").val("");
		} else if (type == 'delivery') {
			$("#st_de_emp_nm, #st_de_emp_tel_full, #st_de_emp_mobile, #st_de_emp_email1, #st_de_emp_email2").val("");
		} else if (type == 'tax') {
			$("#st_ac_emp_nm, #st_ac_emp_tel, #st_ac_emp_mobile, #st_ac_emp_email1, #st_ac_emp_email2").val("");
		} else if (type == 'econt') {
			$("#st_econt_name, #st_econt_tel, #st_econt_mobile, #st_econt_email1, #st_econt_email2").val("");
		}
	}
}

// 이메일 도메인 select 변경
function setEmailDomain(sel, targetId) {
	var val = sel.value;
	if (val != "") {
		$("#" + targetId).val(val).prop("readonly", true);
	} else {
		$("#" + targetId).val("").prop("readonly", false);
	}
}

// 저장 SQL이 요구하는 레거시 파라미터명으로 hidden 동기화
function syncLegacyFields() {
	// 사업자등록번호 10자리 -> 3/2/5 분할
	var irs = $("#st_irs_no").val().replace(/[^0-9]/g, '');
	$("#st_irs_no1").val(irs.substr(0, 3));
	$("#st_irs_no2").val(irs.substr(3, 2));
	$("#st_irs_no3").val(irs.substr(5, 5));

	// 법인번호 13자리 -> 6-7 하이픈 형식 (선택 입력이므로 미입력/불완전 입력은 빈 값)
	var corp = $("#st_corp_no").val().replace(/[^0-9]/g, '');
	$("#st_corp_reg_no").val(corp.length == 13 ? corp.substr(0, 6) + "-" + corp.substr(6, 7) : "");

	splitTelTo3($("#st_gr_emp_tel").val(), "st_gr_emp_tel");
	splitTelTo3($("#st_gr_emp_mobile").val(), "st_gr_emp_mobile");
	splitTelTo3($("#st_ac_emp_tel").val(), "st_ac_emp_tel");
	splitTelTo3($("#st_ac_emp_mobile").val(), "st_ac_emp_mobile");
	splitTelTo3($("#st_econt_mobile").val(), "st_econt_mobile");

	$("#st_gr_emp_email").val(joinEmail("st_gr_emp_email1", "st_gr_emp_email2"));
	$("#st_ac_emp_email").val(joinEmail("st_ac_emp_email1", "st_ac_emp_email2"));
	$("#st_econt_email").val(joinEmail("st_econt_email1", "st_econt_email2"));
}

// 전화번호를 3분할해 {prefix}1/2/3 에 세팅
function splitTelTo3(value, prefix) {
	var v = kepTrimStr(value || "");
	var parts = v.split("-");
	if (parts.length != 3) {
		var d = v.replace(/[^0-9]/g, '');
		if (d.length < 9) {
			parts = [d, "", ""];
		} else if (d.indexOf("02") == 0) {
			parts = [d.substr(0, 2), d.substring(2, d.length - 4), d.substr(d.length - 4)];
		} else {
			parts = [d.substr(0, 3), d.substring(3, d.length - 4), d.substr(d.length - 4)];
		}
	}
	$("#" + prefix + "1").val(kepTrimStr(parts[0]));
	$("#" + prefix + "2").val(kepTrimStr(parts[1]));
	$("#" + prefix + "3").val(kepTrimStr(parts[2]));
}

// 분리 입력된 이메일을 하나로 결합
function joinEmail(id1, id2) {
	var a = kepTrimStr($("#" + id1).val() || "");
	var b = kepTrimStr($("#" + id2).val() || "");
	return (a && b) ? a + "@" + b : "";
}

// 출고담당 휴대폰 분할 (레거시 호환)
// DE_EMP_TEL 은 구버전의 '납기담당자 핸드폰' 칸이라 휴대폰을 넣는다.
function splitDeliveryTel() {
	splitTelTo3($("#st_de_emp_mobile").val(), "st_de_emp_tel");
}

// 주요취급 품목 행추가 (최대 5행)
var itemRowCount = 2; // 초기 2행
function addItemRow() {
	if (itemRowCount >= 5) {
		alert("최대 5개까지 등록 가능합니다.");
		return;
	}
	itemRowCount++;
	var n = itemRowCount;
	var tr = '<tr data-row="' + n + '">' +
		'<td></td>' +
		'<td>' +
		'  <div class="SearchBuyer" style="width:300px; display:inline-block; height:auto;">' +
		'    <input type="text" id="st_itmg' + n + '_nm" name="st_itmg' + n + '_nm" placeholder=" " readonly style="width:85%;">' +
		'    <button type="button" onclick="doPop(\'itmg\', \'' + n + '\')">SG검색버튼</button>' +
		'  </div>' +
		'</td>' +
		'<td><input class="input30" style="width:290px" id="st_itm_mk' + n + '_nm" name="st_itm_mk' + n + '_nm" type="text" /></td>' +
		'<td><select name="st_itm_mk' + n + '_yn" id="st_itm_mk' + n + '_yn" class="Select" style="width:220px" disabled></select></td>' +
		'<td style="white-space:nowrap">' +
		'  <input class="input30" style="width:130px" id="st_itm_mk' + n + '_file_nm" type="text" readonly />' +
		'  <button type="button" class="ButDarkGray_Small" onclick="openItemFileAttach(\'' + n + '\')">파일찾기</button>' +
		'</td>' +
		'</tr>';
	$("#itemTableBody").append(tr);
	// 유통레벨 콤보 로딩
	kepAjaxCommonComboDataValue('st_itm_mk' + n + '_yn', 'M067', 'SEL', '');
}

// 주요취급 품목 행삭제 (마지막 행, 대표품목 삭제 불가)
function removeItemRow() {
	if (itemRowCount <= 1) {
		alert("대표품목은 삭제할 수 없습니다.");
		return;
	}
	var n = itemRowCount;
	$("#itemTableBody tr[data-row='" + n + "']").remove();
	// hidden 필드 초기화
	$("#st_itmg" + n + "_cd").val("");
	$("#st_itm_mk" + n).val("");
	$("#st_itm_mk" + n + "_image_key").val("");
	itemRowCount--;
}

// 제출서류 전체선택
function toggleDocCheckAll(obj) {
	var checked = obj.checked;
	$("#st_biz_licence_doc_yn, #st_bankbook_copy_yn, #st_seal_cert_doc_yn, #st_using_seal_doc_yn").prop("checked", checked);
}

// ========== 테스트 데이터 자동입력 (F2 키) ==========
function fillTestData() {
	var ts = new Date().getTime().toString().slice(-4);

	// 기본정보
	$("#st_irs_no").val("1078185880");
	$("#st_corp_no").val("1101110096857");
	$("#st_com_name_loc").val("테스트회사");
	$("#st_com_name_eng").val("TestCompany");
	$("#st_ceo_name_loc").val("오승엽");
	$("#st_industry_type").val("도소매");
	$("#st_business_items").val("전자상거래");
	$("#st_tel_no1").val("02");
	$("#st_tel_no2").val("3016");
	$("#st_tel_no3").val("8989");
	$("#st_fax_no1").val("02");
	$("#st_fax_no2").val("3016");
	$("#st_fax_no3").val("8990");
	$("#st_pay_type").val("");
	$("#st_hp_address").val("www.koreab2b.com");

	// 설립일자
	$("#establish_date").val("2001.03.15");
	$("#st_establish_date").val("20010315");

	// 사업장주소
	$("#st_zip_code").val("06335");
	$("#st_zip_key").val("1168010700100010000");
	$("#st_address").val("서울특별시 강남구 개포로 619");
	$("#st_address_dt").val("강남우체국빌딩 7층");

	// KeP 담당자
	$("#st_kep_damdang_id").val("KEP2249039");
	$("#st_kep_damdang_nm").val("원지성");

	// 업체현황 (셀렉트박스는 동적 로딩 후 세팅)
	setTimeout(function() {
		$("#st_reg_type").val($("#st_reg_type option:eq(1)").val());     // 등록구분 첫번째
		$("#st_biz_type").val($("#st_biz_type option:eq(1)").val());     // 유통레벨
		$("#st_capt_amt").val($("#st_capt_amt option:eq(1)").val());     // 총 자본금
		$("#st_iso_yn").val($("#st_iso_yn option:eq(1)").val());         // ISO 여부
		$("#st_license_yn").val($("#st_license_yn option:eq(1)").val()); // 특허여부
		$("#st_year_amt").val($("#st_year_amt option:eq(1)").val());     // 전년도 매출액
		$("#st_deliv_equip_cnt").val($("#st_deliv_equip_cnt option:eq(1)").val()); // 배송차량 수
		$("#st_emp_cnt").val($("#st_emp_cnt option:eq(1)").val());       // 상시 근로자 수
		$("#st_ceo_career").val($("#st_ceo_career option:eq(1)").val()); // 대표자 경력
		$("#st_pay_terms").val($("#st_pay_terms option:eq(1)").val());   // 대금 지급조건
	}, 1000);
	// 납품가능 지역 - 전체 체크
	$("#st_dr_b_all").prop("checked", true);
	// MRO 거래 유무 - 해당없음
	$("#st_mp_business_yn").prop("checked", true);

	// 결제정보
	$("#st_bank_cd").val("020");
	$("#st_bank_name").val("우리은행");
	$("#st_bank_account_no").val("56013012345678");
	$("#st_depositor").val("테스트회사");
	// 동의 체크
	$("#st_bill_agree").prop("checked", true);
	$("#st_logistics_agree").prop("checked", true);

	// 담당자 정보
	$("#st_usr_name_loc").val("홍지수");
	$("#st_user_id").val("KEPDEV" + ts);
	$("#st_usr_email").val("test" + ts + "@koreab2b.com");
	$("#st_password").val("Test1234!@");
	$("#st_confirmpasswd").val("Test1234!@");
	$("#st_phone1").val("02");
	$("#st_phone2").val("3016");
	$("#st_phone3").val("7276");
	$("#st_usr_mobile1").val("010");
	$("#st_usr_mobile2").val("1234");
	$("#st_usr_mobile3").val(ts);
	$("#st_usr_fax_no1").val("02");
	$("#st_usr_fax_no2").val("3016");
	$("#st_usr_fax_no3").val("8990");
	// 담당자 주소
	$("#st_usr_zip_code").val("06335");
	$("#st_usr_zip_key").val("1168010700100010000");
	$("#st_usr_address").val("서울특별시 강남구 개포로 619");
	$("#st_usr_address_dt").val("강남우체국빌딩 7층");

	// 영업담당
	$("#st_gr_emp_nm").val("홍지수");
	$("#st_gr_emp_tel").val("02-3016-7276");
	$("#st_gr_emp_mobile").val("010-1234-" + ts);
	$("#st_gr_emp_email1").val("sales");
	$("#st_gr_emp_email2").val("koreab2b.com");

	// 출고담당
	$("#st_de_emp_nm").val("홍지수");
	$("#st_de_emp_tel_full").val("02-3016-7276");
	$("#st_de_emp_mobile").val("010-1234-" + ts);
	$("#st_de_emp_email1").val("delivery");
	$("#st_de_emp_email2").val("koreab2b.com");

	// 세금계산서 담당
	$("#st_ac_emp_nm").val("홍지수");
	$("#st_ac_emp_tel").val("02-3016-7276");
	$("#st_ac_emp_mobile").val("010-1234-" + ts);
	$("#st_ac_emp_email1").val("tax");
	$("#st_ac_emp_email2").val("koreab2b.com");

	// 전자계약 담당
	$("#st_econt_name").val("홍지수");
	$("#st_econt_tel").val("02-3016-7276");
	$("#st_econt_mobile").val("010-1234-" + ts);
	$("#st_econt_email1").val("econtract");
	$("#st_econt_email2").val("koreab2b.com");

	// 알림 수신
	$("input[name='mail_send_flag'][value='Y']").prop("checked", true);

	alert("테스트 데이터가 입력되었습니다.\n\n※ 셀렉트박스(등록구분, 유통레벨, 총자본금,\n   대표자경력 등)와 팝업 항목(KeP담당자,\n   은행, SG)은 직접 선택해 주세요.");
}

$(document).on("keydown", function(e) {
	if (e.key === "F2") {
		e.preventDefault();
		fillTestData();
	}
});
//-->
</script>
