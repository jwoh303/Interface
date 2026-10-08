<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<%@ include file="/WEB-INF/views/common/include/mainHeader_v2.jsp" %>
</head>
<body>
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
      <div class="h80"></div>
      <div class="ComJoinTitLarge" >사용자 등록 요청</div>
      <div class="ComJoinTitMedium">회사 정보</div>
	  <input type="hidden" id="st_com_code" name="st_com_code" value="${param.com_code}" />
	  <table class="ThLTdL" width="100%">
        <colgroup>
          <col width="150px" />
          <col width="400px" />
          <col width="150px" />
          <col width="210px" />
          <col width="150px" />
          <col width="210px" />
        </colgroup>
        <tr>
          <th>회사</th>
          <td><input class="input30" style="width:350px; background-color:#f5f5f5;" id="st_com_name" type="text" readonly="readonly" /></td>
          <th>부서</th>
          <td><input class="input30" style="width:165px" id="st_usr_department" name="st_usr_department" type="text" /></td>
          <th>직급</th>
          <td><input class="input30" style="width:165px" id="st_usr_position" name="st_usr_position" type="text" /></td>
        </tr>
	  </table>
      <div class="ComJoinTitMedium mt50">사용자 정보</div> 
	  <table class="ThLTdL" width="100%">
        <colgroup>
          <col width="150px" />
          <col width="400px" />
          <col width="150px" />
          <col width="210px" />
          <col width="150px" />
          <col width="210px" />
        </colgroup>
        <tr>
          <th><span class="f2f7ff">*</span> ID</th>
          <td> <input class="input30" style="width:140px" id="st_user_id" name="st_user_id" value="" type="text" autocomplete="one-time-code" readonly onfocus="this.removeAttribute('readonly');" /> <button class="ButDarkGray_Small" onclick="checkIdDup()">중복확인</button>
           <span id="idCheckMsg" style="font-size:85%; margin-left:15px; display:none;">사용가능한 ID 입니다.</span>
          </td>
          <th><span class="F6495F">*</span> 이름</th>
          <td><input class="input30" style="width:165px" id="st_usr_name_loc" name="st_usr_name_loc" type="text" /></td>
          <th><span class="f2f7ff">*</span> 사번</th>
          <td><input class="input30" style="width:165px" id="st_user_com_id" name="st_user_com_id" type="text" /></td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> 비밀번호</th>
          <td colspan="5">
            <p style="width:110px; float:left; font-size:95%; ">비밀번호</p>
            <input class="input30" style="width:240px;" id="st_password" name="st_password" type="password" autocomplete="new-password" readonly onfocus="this.removeAttribute('readonly');" />
            <span id="pwdGuideMsg" style="font-size:85%; margin-left:15px">비밀번호는 영문, 숫자, 특수문자 조합으로 8자 이상 사용해야 합니다.</span>
            <p class="h5"></p>
            <p style="width:110px; float:left; font-size:95%; ">비밀번호 확인</p>
            <input class="input30" style="width:240px;" id="st_confirmpasswd" name="st_confirmpasswd" type="password" autocomplete="new-password" readonly onfocus="this.removeAttribute('readonly');" />
            <span id="pwMatchMsg" style="font-size:85%; margin-left:15px; font-weight:600; color:#F6495F; display:none;">불일치</span>
          </td>
        </tr>
        <tr>
          <th><span class="F6495F">*</span> 휴대폰</th>
          <td><input class="input30" style="width:80px" id="st_usr_mobile1" name="st_usr_mobile1" type="text" maxlength="3" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /> - <input class="input30" style="width:100px" id="st_usr_mobile2" name="st_usr_mobile2" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /> - <input class="input30" style="width:100px" id="st_usr_mobile3" name="st_usr_mobile3" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /></td>
          <th><span class="F6495F">*</span> 전화번호</th>
          <td colspan="3"><input class="input30" style="width:150px" id="st_phone1" name="st_phone1" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /> - <input class="input30" style="width:150px" id="st_phone2" name="st_phone2" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /> - <input class="input30" style="width:158px" id="st_phone3" name="st_phone3" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /></td>
        </tr>
        <tr>
          <th><span class="f2f7ff">*</span> 팩스번호</th>
          <td><input class="input30" style="width:80px" id="st_fax_no1" name="st_fax_no1" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /> - <input class="input30" style="width:100px" id="st_fax_no2" name="st_fax_no2" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /> - <input class="input30" style="width:100px" id="st_fax_no3" name="st_fax_no3" type="text" maxlength="4" oninput="this.value=this.value.replace(/[^0-9]/g,'')" /></td>
          <th><span class="F6495F">*</span> 이메일</th>
          <td colspan="3">
            <input class="input30" style="width:210px" id="st_usr_email1" name="st_usr_email1" value="" type="text" placeholder="이메일" /> @
            <input class="input30" style="width:150px" id="st_usr_email2" name="st_usr_email2" value="" type="text" />
            <select id="st_email_domain" class="Select" style="width:122px" onchange="selectEmailDomain(this)">
              <option value="">직접입력</option>
              <option value="naver.com">naver.com</option>
              <option value="gmail.com">gmail.com</option>
              <option value="daum.net">daum.net</option>
              <option value="hanmail.net">hanmail.net</option>
              <option value="nate.com">nate.com</option>
            </select>
          </td>
        </tr>
        <tr>
          <th><span class="f2f7ff">*</span> 알림 수신 여부</th>
          <td colspan="5">
            <label class="CheckMediumLabel"><input type="checkbox" id="st_mail_recv_flag" name="st_mail_recv_flag" value="Y" checked><span class="CheckMediumCustom"></span>E-mail 수신 동의</label>
            <label class="CheckMediumLabel"><input type="checkbox" id="st_sms_recv_flag" name="st_sms_recv_flag" value="Y" checked><span class="CheckMediumCustom"></span>휴대폰 문자 수신 동의</label>
            <p class="Smalltxt F6495F" style="float:right">※ 수신을 미동의 하실 경우 계정 분실 시 정보공유 및 수주/견적요청에 대한 피드백을 받으실 수 없습니다.</p>
          </td>
        </tr>
<!--         <tr>
          <th><span class="F6495F">*</span> 주소</th>
          <td colspan="5"><input class="input30" style="width:166px" id="st_usr_zip_code" name="st_usr_zip_code" value="" type="text" readonly />
            <button class="ButDarkGray_Small" onclick="openZipCodePop()">우편번호</button>
            <input class="input30" style="width:462px" id="st_usr_address" name="st_usr_address" value="" type="text" readonly />
            <input class="input30" style="width:330px" id="st_usr_address_dt" name="st_usr_address_dt" value="" type="text" placeholder="상세주소 입력" />
          </td>
        </tr>   -->        
               
      </table>                   
 
	   
       
                     
      <div class="h80"></div>
      <div class="ComButtonArea"><button class="ButtonMedium" onclick="doRegister()">등록하기</button></div> 
      <div class="h80"></div>  
    </div><!-- containerSub 끝 -->
    
      
    
    <%@ include file="/WEB-INF/views/common/include/mainFooter_v2.jsp" %>
</div><!-- wrap 끝-->

<script>
// 아이디 중복 체크 플래그
var idChecked = false;

// 아이디 변경 시 체크 플래그 리셋
$(function() {
  // URL 파라미터에서 회사명 세팅
  var urlParams = new URLSearchParams(window.location.search);
  var comName = urlParams.get('com_name');
  if (comName) {
      $("#st_com_name").val(comName);
  }

  $("#st_user_id").on("input", function() {
    // ID 소문자 입력 시 대문자 자동 전환
    var up = this.value.toUpperCase();
    if (this.value !== up) this.value = up;
    idChecked = false;
    $("#idCheckMsg").hide();
  });

  // 비밀번호 양식 실시간 검증 (가이드 문구 색상 강조)
  $("#st_password").on("input", function() {
    var pw = $("#st_password").val();
    var pwRegex = /^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[~!@#$%^&*()_+\-={}\[\]:";'<>?,.\/]).{8,}$/;
    if (pw.length === 0) {
      $("#pwdGuideMsg").css({ "color": "", "font-weight": "" });
    } else if (!pwRegex.test(pw)) {
      $("#pwdGuideMsg").css({ "color": "#F6495F", "font-weight": "600" });
    } else {
      $("#pwdGuideMsg").css({ "color": "#4CAF50", "font-weight": "600" });
    }
  });

  // 비밀번호 일치 여부 실시간 체크
  $("#st_confirmpasswd, #st_password").on("input", function() {
    var pw = $("#st_password").val();
    var pwConfirm = $("#st_confirmpasswd").val();
    if (pwConfirm.length > 0) {
      if (pw === pwConfirm) {
        $("#pwMatchMsg").css("color","#2172EC").text("일치").show();
      } else {
        $("#pwMatchMsg").css("color","#F6495F").text("불일치").show();
      }
    } else {
      $("#pwMatchMsg").hide();
    }
  });
});

// 이메일 도메인 셀렉트 변경
function selectEmailDomain(sel) {
  var val = sel.value;
  if (val) {
    $("#st_usr_email2").val(val).attr("readonly", true);
  } else {
    $("#st_usr_email2").val("").attr("readonly", false).focus();
  }
}

// 아이디 중복 체크 (기존 Seller 엔드포인트 재사용)
function checkIdDup() {
  var userId = $.trim($("#st_user_id").val());
  if (!userId) {
    alert("ID를 입력해 주세요.");
    $("#st_user_id").focus();
    return;
  }
  var data = { st_user_id: userId };
  kepAjaxCallMain("/mdam/getMasterMdAmSellerMbrcmpyRegIDCheck.do", data, "checkIdDup");
}

/* // 우편번호 팝업 (기존 newZipCodeSearchPop 재사용)
function openZipCodePop() {
  var url = "/common/newZipCodeSearchPop.do";
  var options = "width=570,height=520,top=100,left=300,resizable=no,scrollbars=yes";
  window.open(url, "jusoPopup", options);
} */

// 우편번호 팝업 콜백 (팝업에서 호출)
function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn) {
  $("#st_usr_zip_code").val(zipNo.replace(/[^0-9]/gi, ''));
  $("#st_usr_address").val(roadAddrPart1 + " " + roadAddrPart2);
  $("#st_usr_address_dt").val(addrDetail).focus();
}

// 폼 유효성 검사
function checkSubmit() {
  $("#st_usr_name_loc").val(kepTrimStr($("#st_usr_name_loc").val()));
  $("#st_usr_email1").val(kepTrimStr($("#st_usr_email1").val()));
  $("#st_usr_email2").val(kepTrimStr($("#st_usr_email2").val()));
  if (!idChecked) { alert("ID 중복확인을 해주세요."); $("#st_user_id").focus(); return false; }
  var nameVal = $.trim($("#st_usr_name_loc").val());
  if (!nameVal) { alert("이름을 입력해 주세요."); $("#st_usr_name_loc").focus(); return false; }
  if (!/^[가-힣a-zA-Z\s]+$/.test(nameVal)) {
    alert("이름은 완성형 한글 또는 영문만 입력 가능합니다.");
    $("#st_usr_name_loc").focus(); return false;
  }

  var pw = $("#st_password").val();
  var pwConfirm = $("#st_confirmpasswd").val();
  if (!/^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[~!@#$%^&*()_+\-={}\[\]:";'<>?,.\/]).{8,}$/.test(pw)) {
    alert("비밀번호는 영문, 숫자, 특수문자를 모두 조합하여 8자 이상 입력해야 합니다.");
    $("#st_password").focus(); return false;
  }
  if (pw !== pwConfirm) { alert("비밀번호가 일치하지 않습니다."); $("#st_confirmpasswd").focus(); return false; }

  if (!$.trim($("#st_usr_mobile1").val()) || !$.trim($("#st_usr_mobile2").val()) || !$.trim($("#st_usr_mobile3").val())) {
    alert("휴대폰 번호를 입력해 주세요."); $("#st_usr_mobile1").focus(); return false;
  }
  if (!$.trim($("#st_phone1").val()) || !$.trim($("#st_phone2").val()) || !$.trim($("#st_phone3").val())) {
    alert("전화번호를 입력해 주세요."); $("#st_phone1").focus(); return false;
  }
  var emailId = $.trim($("#st_usr_email1").val());
  var emailDomain = $.trim($("#st_usr_email2").val());
  if (!emailId || !emailDomain) { alert("이메일을 입력해 주세요."); $("#st_usr_email1").focus(); return false; }
  if (emailId.indexOf("@") !== -1) {
    alert("이메일 아이디(@ 앞)에는 @를 포함할 수 없습니다."); $("#st_usr_email1").focus(); return false;
  }
  if (!/^[0-9a-zA-Z][_0-9a-zA-Z.\-]*@[_0-9a-zA-Z\-]+(\.[_0-9a-zA-Z\-]+){1,3}$/.test(emailId + "@" + emailDomain)) {
    alert("이메일 형식이 올바르지 않습니다. 예) aaa@aaa.com"); $("#st_usr_email1").focus(); return false;
  }
/*   if (!$.trim($("#st_usr_zip_code").val()) || !$.trim($("#st_usr_address").val())) {
    alert("주소를 입력해 주세요."); openZipCodePop(); return false;
  } */

  return confirm("사용자 등록을 요청하시겠습니까?");
}

// 등록 실행
function doRegister() {
  if (!checkSubmit()) return;

  var data = {
    st_com_code: $("#st_com_code").val(),
    st_user_id: $.trim($("#st_user_id").val()),
    st_password: $("#st_password").val(),
    st_user_name_loc: $.trim($("#st_usr_name_loc").val()),
    st_user_name_eng: "",
    st_legacy_user_id: $.trim($("#st_user_com_id").val()),
    st_department: $.trim($("#st_usr_department").val()),
    st_position: $.trim($("#st_usr_position").val()),
    st_email: $.trim($("#st_usr_email1").val()) + "@" + $.trim($("#st_usr_email2").val()),
    st_phone_number: $("#st_phone1").val() + "-" + $("#st_phone2").val() + "-" + $("#st_phone3").val(),
    st_fax_number: $("#st_fax_no1").val() + "-" + $("#st_fax_no2").val() + "-" + $("#st_fax_no3").val(),
    st_mobile_phone: $("#st_usr_mobile1").val() + "-" + $("#st_usr_mobile2").val() + "-" + $("#st_usr_mobile3").val(),
/*     st_zip_code: $("#st_usr_zip_code").val(),
    st_zip_key: "",
    st_address: $("#st_usr_address").val(),
    st_address_dt: $("#st_usr_address_dt").val(),
    st_address_eng: "", */
    st_country: "KR",
    st_city: "",
    st_lang: "KR",
    st_user_type: "A",
    st_mail_recv_flag: $("input[name='st_mail_recv_flag']:checked").val() || "N",
    st_sms_recv_flag: $("input[name='st_sms_recv_flag']:checked").val() || "N",
    st_dely_to_location: ""
  };

  kepAjaxCallMain("/mdam/saveMasterMdAmUserRegList.do", data, "save");
}

// AJAX 성공 콜백
function kepAjaxSuccessMain(pMethod, response) {
  if (pMethod == "checkIdDup") {
    if (response.msg == "OK") {
      idChecked = true;
      alert("사용가능한 ID 입니다.");
      $("#idCheckMsg").css({"color":"#2172EC","font-weight":"600"}).text("사용가능한 ID 입니다.").show();
    } else {
      idChecked = false;
      alert("이미 사용하고 있는 ID 입니다. 다른 ID를 입력하세요.");
      $("#idCheckMsg").css({"color":"#F6495F","font-weight":"600"}).text("사용할 수 없는 ID 입니다.").show();
      $("#st_user_id").focus();
    }
  }
  if (pMethod == "save") {
    if (response.msg == "OK") {
      alert("사용자 등록 요청이 완료되었습니다.\n관리자 승인 후 로그인 가능합니다.");
      location.href = "/mdam/showMasterMdAmMbrcmpyRegEnd_v2.do?type=U";
    } else if (response.msg == "dup") {
      alert("이미 등록된 ID입니다. 다른 ID를 사용해 주세요.");
      $("#st_user_id").focus();
    } else {
      alert("등록에 실패하였습니다. 다시 확인해 주세요.");
    }
  }
}

// AJAX 에러 콜백
function kepAjaxErrorMain(pMethod, response) {
  if (pMethod == "checkIdDup") {
    alert("ID 중복 확인 중 오류가 발생하였습니다.");
  }
  if (pMethod == "save") {
    alert("사용자 등록 중 오류가 발생하였습니다.");
  }
}
</script>

</body>
</html>

