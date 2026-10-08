<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="wc_cert_selection_form">
<div id="wc_cert_selection_layout" class="webcryptoLayout wcBlinder" style="display:none;">
  <div class="wcCertificateWrap"> <!-- 인증서 선택 UI 레이아웃 -->
    <div class="wcSection">
      <h1 class="wcHeader"></h1>
    </div>

    <div class="wcSection">
      <h2 class="wcTitle" id="TEXT_SELECT_DRIVE_TYPE">인증서 저장매체 선택</h2>
      <ul class="wcMediaTabs" id="wc_media_tabs">
        <li class=""> <!-- 기본 <li class=""> / 선택 <li class="wcSelcOn"> / 서비스안함 <li class="wcSelcOff"> -->
          <label for="wc_media_tab_web" class="wcMediaTabWEB">
            <input type="radio" name="wc_media_selection_radio" id="wc_media_tab_web" value="WEB" class="hide" checked />
            <span id="wc_media_tab_web_name">브라우저</span>
          </label>
        </li>
        <li class="">
          <label for="wc_media_tab_hdd" class="wcMediaTabHDD">
            <input type="radio" name="wc_media_selection_radio" id="wc_media_tab_hdd" value="HDD" class="hide" />
            <span id="wc_media_tab_hdd_name">하드디스크</span>
          </label>
        </li>
        <li class="">
          <label for="wc_media_tab_usb" class="wcMediaTabUSB">
            <input type="radio" name="wc_media_selection_radio" id="wc_media_tab_usb" value="USB" class="hide" />
            <span id="wc_media_tab_usb_name">이동식디스크</span>
          </label>
        </li>
        <li class="">
          <label for="wc_media_tab_phone" class="wcMediaTabPhone">
            <input type="radio" name="wc_media_selection_radio" id="wc_media_tab_phone" value="Phone" class="hide" />
            <span id="wc_media_tab_phone_name">휴대폰인증</span>
          </label>
        </li>
        <li class="">
          <label for="wc_media_tab_hsm" class="wcMediaTabHWToken">
            <input type="radio" name="wc_media_selection_radio" id="wc_media_tab_hsm" value="HSM" class="hide" />
            <span id="wc_media_tab_hsm_name">보안토큰</span>
          </label>
        </li>
      </ul>
    </div>

    <div class="wcSection">
      <h2 class="wcTitle" id="TEXT_SELECT_CERTIFICATE_TO_USE">사용할 인증서 선택</h2>
      <div id="wcCertList" class="wcCertList" style="overflow-y:hidden; overflow-x:hidden;"> <!-- 인증서가 6개 이상 될 경우 overflow-y:scroll; -->
        <table summary="구분, 사용자, 만료일, 발급자" style="width:auto;">
          <caption id="TEXT_CERTIFICATE_LIST">공인인증서 목록</caption>
          <thead id="wc_cert_list_thead">
          </thead>
          <tbody id="wc_cert_list_tbody">
          </tbody>
        </table>
      </div>
      <div class="wcBtnWrap">
        <span><input type="button" name="button" id="wc_import_cert" value="인증서 가져오기" /></span>
        <span><input type="button" name="button" id="wc_detail_view" value="인증서 보기" /></span>
        <span><input type="button" name="button" id="wc_cert_delete" value="인증서 삭제" /></span>
      </div>
      <div class="wcBtnWrap">
        <span><input type="button" name="button" id="wc_export_cert" value="인증서 내보내기" /></span>
        <span><input type="button" name="button" id="wc_cert_copy" value="인증서 복사" /></span>
        <span><input type="button" name="button" id="wc_password_change" value="비밀번호 변경" /></span>
      </div>
    </div>

    <div class="wcSection">
      <h2 class="wcTitle" id="wc_enter_password_main_window">인증서 비밀번호 입력</h2>
      <div class="wcPwWrap">
        <div class="wcPwInput">
          <label for=""><input type="password" name="wc_cert_selection_password" id="wc_cert_selection_password" title="인증서 비밀번호 입력" /></label>
        </div>
        <p class="wcTipText" id="wcTipTextMainWindow">인증서 비밀번호는 대소문자를 구분합니다.</p>
      </div>
    </div>

    <p class="wcProgBtnWrap">
      <span class="wcOkBtn"><input type="button" name="button" id="wc_cert_selection_ok" value="확인" /></span>
      <span class="cancelBtn"><input type="button" name="button" id="wc_cert_selection_cancel" value="취소" /></span>
    </p>
  </div>

  <!-- 보안토큰 드라이브 선택 창 -->
  <div id="wc_hsm_drive_selection_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcDriveSelectionWrap">
      <h3 class="wcTitleBar" id="TEXT_HSM_INFO">보안토큰 서비스 정보</h3>
      <div class="wcDriveSelectionCont">
        <h2 class="wcTitle" id="TEXT_SELECT_HSM_PROVIDER">보안토큰 서비스 제공자 선택</h2>
        <div id="wc_hsm_drive_selection" class="wcDriveSelection" style="overflow-y:hidden; overflow-x:hidden;"> <!-- driveID가 5개 초과 될 경우 overflow-y:scroll; -->
          <table summary="보안토큰 서비스 모듈" style="width:auto; margin:0;">
            <thead>
              <tr>
                <th scope="col" style="width:298px;">
                  <div class="wcDriveTit" id="TEXT_SELECT_HSM_MODULE">
                    보안토큰 서비스 모듈
                  </div>
                </th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
        </div>
      </div>

      <div class="wcBtnWrap02">
        <span><input type="button" name="button" id="wc_hsm_drive_selection_ok" value="확인" /></span>
        <span><input type="button" name="button" id="wc_hsm_drive_selection_cancel" value="취소" /></span>
      </div>

    </div>
  </div>

  <!-- 스마트인증 드라이브 선택 창 -->
  <div id="wc_usim_drive_selection_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcDriveSelectionWrap">
      <h3 class="wcTitleBar" id="TEXT_USIM_INFO">스마트인증 서비스 정보</h3>
      <div class="wcDriveSelectionCont">
        <h2 class="wcTitle" id="TEXT_SELECT_USIM_PROVIDER">스마트인증 서비스 제공자 선택</h2>
        <div id="wc_usim_drive_selection" class="wcDriveSelection" style="overflow-y:hidden; overflow-x:hidden;"> <!-- driveID가 4개 초과 될 경우 overflow-y:scroll; -->
          <table summary="스마트인증 서비스 모듈" style="width:auto; margin:0;">
            <thead>
              <tr>
                <th scope="col" style="width:298px;">
                  <div class="wcDriveTit" id="TEXT_SELECT_USIM_MODULE">
                    스마트인증 서비스 모듈
                  </div>
                </th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
        </div>
      </div>

      <div class="wcBtnWrap02">
        <span><input type="button" name="button" id="wc_usim_drive_selection_ok" value="확인" /></span>
        <span><input type="button" name="button" id="wc_usim_drive_selection_cancel" value="취소" /></span>
      </div>

    </div>
  </div>

  <!-- 보안토큰 PIN 입력창 -->
  <div id="wc_hsm_login_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcPkcs11LoginWrap">
      <h3 class="wcTitleBar" id="TEXT_HSM_LOGIN">보안토큰 로그인</h3>
      <div class="wcPkcs11LoginCont">
        <div class="wcSection">
          <h2 class="wcTitle" id="TEXT_ENTER_HSM_PASSWORD">보안토큰 비밀번호 입력</h2>
          <div class="wcPwWrap">
            <div class="wcPwInput">
              <label for=""><input type="password" name="wc_hsm_login_pin" id="wc_hsm_login_pin" title="보안토큰 비밀번호 입력" /></label>
            </div>
            <p class="wcTipText" id="MSG_HSM_PASSWORD_CASE_SENSITIVE">보안토큰 비밀번호는 대소문자를 구분합니다.</p>
          </div>
        </div>
      </div>

      <p class="wcProgBtnWrap">
        <span class="wcOkBtn"><input type="button" name="button" id="wc_hsm_login_ok" value="확인" /></span>
        <span class="cancelBtn"><input type="button" name="button" id="wc_hsm_login_cancel" value="취소" /></span>
      </p>
    </div>
  </div>

  <!-- 스마트인증 PIN 입력창 -->
  <div id="wc_usim_login_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcPkcs11LoginWrap">
      <h3 class="wcTitleBar" id="TEXT_SELECT_USIM_LOGIN">스마트인증 로그인</h3>
      <div class="wcPkcs11LoginCont">
        <div class="wcSection">
          <h2 class="wcTitle" id="TEXT_ENTER_USIM_PASSWORD">스마트인증 비밀번호 입력</h2>
          <div class="wcPwWrap">
            <div class="wcPwInput">
              <label for=""><input type="password" name="wc_usim_login_pin" id="wc_usim_login_pin" title="스마트인증 비밀번호 입력" /></label>
            </div>
            <p class="wcTipText" id="MSG_USIM_PASSWORD_CASE_SENSITIVE">스마트인증 비밀번호는 대소문자를 구분합니다.</p>
          </div>
        </div>
      </div>

      <p class="wcProgBtnWrap">
        <span class="wcOkBtn"><input type="button" name="button" id="wc_usim_login_ok" value="확인" /></span>
        <span class="cancelBtn"><input type="button" name="button" id="wc_usim_login_cancel" value="취소" /></span>
      </p>
    </div>
  </div>

  <!-- 인증서 비밀번호 입력창 -->
  <div id="wc_pw_input_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcPwLayoutWrap">
      <h3 class="wcTitleBar" id="TEXT_VERIFY_CERTIFICATE_PASSWORD">인증서 비밀번호 확인</h3>
      <div class="wcPwLayoutCont">
        <div class="wcSection">
          <h2 class="wcTitle" id="wc_enter_password_input_window">인증서 비밀번호 입력</h2>
          <div class="wcPwWrap">
            <div class="wcPwInput">
              <label for=""><input type="password" name="wc_pw_input_password" id="wc_pw_input_password" title="인증서 비밀번호 입력" /></label>
            </div>
            <p class="wcTipText" id="wcTipTextInputPasswordWindow">인증서 비밀번호는 대소문자를 구분합니다.</p>
          </div>
        </div>
      </div>

      <p class="wcProgBtnWrap">
        <span class="wcOkBtn"><input type="button" name="button" id="wc_pw_input_ok" value="확인" /></span>
        <span class="cancelBtn"><input type="button" name="button" id="wc_pw_input_cancel" value="취소" /></span>
      </p>
    </div>
  </div>

  <!-- 인증서 비밀번호 변경창 -->
  <div id="wc_pw_change_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcPwLayoutWrap">
      <h3 class="wcTitleBar" id="TEXT_CHANGE_CERT_PASSWORD">인증서 비밀번호 변경</h3>
      <div class="wcPwLayoutCont">
        <div class="wcSection">
          <h2 class="wcTitle" id="wc_enter_password_change_window">인증서 비밀번호 입력</h2>
          <div class="wcPwChangeWrap">
            <div class="wcPwChange">
              <label for="">
                <span id="TEXT_BEFORE_CHANGE_PASSWORD">변경전 비밀번호</span>
                <input type="password" name="wc_pw_change_old" id="wc_pw_change_old" title="변경전 비밀번호" />
              </label>
            </div>
            <div class="wcPwChange">
              <label for="">
                <span id="TEXT_AFTER_CHANGE_PASSWORD">변경후 비밀번호</span>
                <input type="password" name="wc_pw_change_new1" id="wc_pw_change_new1" title="변경후 비밀번호" />
              </label>
            </div>
            <div class="wcPwChange">
              <label for="">
                <span id="TEXT_REENTER_PASSWORD">비밀번호 재입력</span>
                <input type="password" name="wc_pw_change_new2" id="wc_pw_change_new2" title="비밀번호 재입력" />
              </label>
            </div>
            <p class="wcTipText" id="wcTipTextChangePassword">인증서 비밀번호는 대소문자를 구분합니다.</p>
          </div>
        </div>
      </div>

      <p class="wcProgBtnWrap">
        <span class="wcOkBtn"><input type="button" name="button" id="wc_pw_change_ok" value="확인" /></span>
        <span class="cancelBtn"><input type="button" name="button" id="wc_pw_change_cancel" value="취소" /></span>
      </p>
    </div>
  </div>

  <!-- 인증서 상세보기 -->
  <div id="wc_cert_detail_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcCretDetailWrap">
      <h3 class="wcTitleBar" id="TEXT_CERTIFICATE_INFO">인증서 정보</h3>
      <div class="wcCretDetailCont">
        <ul>
          <!-- 일반 | 선택시 : <li class="wcTap01 wcSelcOn"> -->
          <li class="wcTap01 wcSelcOn">
            <!--<a id="wc_detail_base_tab" href="#" class="wcTapTit">일반</a>-->
            <div id="wc_detail_base_tab" class="wcTapTit">일반</div>
            <div class="wcTapCont">
              <div class="wcBaseInfo">
                <p class="wcBaseInfoTit" id="wc_base_info_title"></p>
                <dl class="wcBaseInfoCont">
                  <dt id="TEXT_SUBJECT_DN">발급대상</dt>
                  <dd id="wc_detail_base_subject"></dd>
                  <dt id="TEXT_ISSUER_DN">발급자</dt>
                  <dd id="wc_detail_base_issuer"></dd>
                  <dt id="TEXT_VALIDATE">유효기간</dt>
                  <dd id="wc_detail_base_validity"></dd>
                  <dt id="TEXT_PC_TIME">PC 시간</dt>
                  <dd id="wc_detail_base_time"></dd>
                </dl>
              </div>
            </div>
          </li>

          <!-- 자세히 | 선택시 : <li class="wcTap02 wcSelcOn"> -->
          <li class="wcTap02 ">
            <!--<a id="wc_detail_contents_tab" href="#" class="wcTapTit">자세히</a>-->
            <div id="wc_detail_contents_tab" class="wcTapTit">자세히</div>
            <div class="wcTapCont">
              <div id="wc_detail_info" class="wcDetailInfo" style="overflow-y:auto; overflow-x:auto;">
                <table summary="인증서 상세 정보" style="width:auto; margin:0;">
                  <thead>
                    <tr>
                      <th scope="col" style="width:80px;">
                        <div class="wcDetailTit" id="wc_detail_header_name">
                          이름
                          <div class="wcMoveBar"></div>
                        </div>
                      </th>
                      <th scope="col" style="width:278px;">
                        <div class="wcDetailTit" id="wc_detail_header_value">
                          값
                          <div class="wcMoveBar"></div>
                        </div>
                      </th>
                    </tr>
                  </thead>
                  <tbody id="wc_detail_contents">
                  </tbody>
                </table>
              </div>

              <div id="wc_detail_contents_value" class="wcDetailInfo02">
              </div>
            </div>
          </li>
        </ul>
      </div>

      <div class="wcBtnWrap02">
        <span><input type="button" name="button" id="wc_cert_detail_ok" value="확인" /></span>
      </div>

    </div>
  </div>

  <!-- 인증서 가져오기 -->
  <div id="wc_import_cert_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcImportCertificateWrap">
      <h3 class="wcTitleBar" id="TEXT_IMPORT_CERTIFICATE">인증서 가져오기</h3>
      <div class="wcImportCertificateCont">
        <div class="wcSection" style="display:none;"> <!-- driveID 노출이 필요할 시 display:block -->
          <h2 class="wcTitle" id="TEXT_SELECT_PORTABLE_DISK">저장할 이동식디스크 선택</h2>
          <div id="wc_portable_drive_list" class="wcDriveSelection" style="overflow-y:hidden; overflow-x:hidden;"> <!-- driveID가 4개 초과 될 경우 height:105px; overflow-y:scroll; -->
            <table summary="이동식디스크 목록" style="width:auto;">
              <thead>
                <tr>
                  <th scope="col" style="width:318px;">
                    <div class="wcDriveTit" id="wc_select_drive_label_discname">
                      디스크명
                    </div>
                  </th>
                </tr>
              </thead>
              <tbody>
              </tbody>
            </table>
          </div>
        </div>

        <div class="wcSection">
          <h2 class="wcTitle" id="TEXT_ENTER_PFX_PASSWORD">PFX 비밀번호 입력</h2>
          <div class="wcPwWrap">
            <div class="wcPwInput">
              <label for=""><input type="password" name="wc_import_pfx_password" id="wc_import_pfx_password" title="PFX 비밀번호 입력" /></label>
            </div>
            <p class="wcTipText" id="MSG_PFX_PASSWORD_CASE_SENSITIVE">PFX 비밀번호는 대소문자를 구분합니다.</p>
          </div>
        </div>

        <div class="wcSection" id="wc_import_cert_password_input" style="display:none;">
          <h2 class="wcTitle" id="wc_import_cert_password_title">인증서 비밀번호 입력</h2>
          <div class="wcPwWrap">
            <p class="wcTipText" id="MSG_ENTER_PFX_PASSWORD_IF_DIFFERENT">비밀번호가 PFX와 다른 경우에 입력합니다.</p>
            <div class="wcPwInput">
              <label for=""><input type="password" name="wc_import_cert_password" id="wc_import_cert_password" title="인증서 비밀번호 입력" /></label>
            </div>
            <p class="wcTipText" id="wcTipTextImportCertificate">인증서 비밀번호는 대소문자를 구분합니다.</p>
          </div>
        </div>
      </div>

      <p class="wcProgBtnWrap">
        <span class="wcOkBtn"><input type="button" name="button" id="wc_import_cert_ok" value="확인" /></span>
        <span class="cancelBtn"><input type="button" name="button" id="wc_import_cert_cancel" value="취소" /></span>
      </p>
    </div>
  </div>

  <!-- 인증서 복사 -->
  <div id="wc_cert_copy_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcCertCopyWrap">
      <h3 class="wcTitleBar" id="wc_cert_copy_title">인증서 복사</h3>
      <div class="wcSection">
        <h2 class="wcTitle" id="TEXT_SELECT_TARGET_TO_COPY">인증서 복사 대상 저장매체 선택</h2>
        <ul class="wcMediaTabs" id="wc_target_media_tabs">
          <li class=""> <!-- 기본 <li class=""> / 선택 <li class="wcSelcOn"> / 서비스안함 <li class="wcSelcOff"> -->
            <label for="wc_target_media_tab_web" class="wcMediaTabWEB">
              <input type="radio" name="wc_target_media_radio" id="wc_target_media_tab_web" value="WEB" class="hide" checked />
              <span id="wc_target_media_tab_web_name">브라우저</span>
            </label>
          </li>
          <li class="">
            <label for="wc_target_media_tab_hdd" class="wcMediaTabHDD">
              <input type="radio" name="wc_target_media_radio" id="wc_target_media_tab_hdd" value="HDD" class="hide" checked />
              <span id="wc_target_media_tab_hdd_name">하드디스크</span>
            </label>
          </li>
          <li class="">
            <label for="wc_target_media_tab_usb" class="wcMediaTabUSB">
              <input type="radio" name="wc_target_media_radio" id="wc_target_media_tab_usb" value="USB" class="hide" />
              <span id="wc_target_media_tab_usb_name">이동식디스크</span>
            </label>
          </li>
          <li class="">
            <label for="wc_target_media_tab_phone" class="wcMediaTabPhone">
              <input type="radio" name="wc_target_media_radio" id="wc_target_media_tab_phone" value="Phone" class="hide" />
              <span id="wc_target_media_tab_phone_name">휴대폰인증</span>
            </label>
          </li>
          <li class="">
            <label for="wc_target_media_tab_hsm" class="wcMediaTabHWToken">
              <input type="radio" name="wc_target_media_radio" id="wc_target_media_tab_hsm" value="HSM" class="hide" />
              <span id="wc_target_media_tab_hsm_name">보안토큰</span>
            </label>
          </li>
        </ul>
      </div>

      <div class="wcSection">
        <h2 class="wcTitle" id="TEXT_SELECT_TARGET_DISK_AND_MODULE_TO_COPY">복사 대상 디스크 및 모듈 선택</h2>
        <div id="wc_target_drive_list" class="wcDriveSelection" style="overflow-y:hidden; overflow-x:hidden;"> <!-- driveID가 4개 초과 될 경우 height:105px; overflow-y:scroll; -->
          <table summary="장치드라이브 목록" style="width:auto;">
            <thead>
              <tr>
                <th scope="col" style="width:448px;">
                  <div class="wcDriveTit" id="wcDiskAndModuleForCopy">
                    디스크 및 모듈
                  </div>
                </th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
        </div>
      </div>

      <p class="wcProgBtnWrap">
        <span class="wcOkBtn"><input type="button" name="button" id="wc_cert_copy_ok" value="확인" /></span>
        <span class="cancelBtn"><input type="button" name="button" id="wc_cert_copy_cancel" value="취소" /></span>
      </p>
    </div>
  </div>

  <!-- 중계서버 인증서 가져오기-->
  <div id="wc_import_cert_relay_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcImportCertRelayWrap">
      <h3 class="wcTitleBar" id="TEXT_IMPORT_CERTIFICATE_FROM_RELAY">인증서 가져오기</h3>
      <div class="wcSection">
        <h2 class="wcTitle" id="TEXT_SELECT_TARGET_TO_IMPORT_FROM_RELAY">인증서 가져오기 대상 저장매체 선택</h2>
        <ul class="wcMediaTabs" id="wc_import_relay_media_tabs">
          <li class=""> <!-- 기본 <li class=""> / 선택 <li class="wcSelcOn"> / 서비스안함 <li class="wcSelcOff"> -->
            <label for="wc_import_relay_media_tab_web" class="wcMediaTabWEB">
            <input type="radio" name="wc_import_relay_media_radio" id="wc_import_relay_media_tab_web" value="WEB" class="hide" checked />
            <span id="wc_import_relay_media_tab_web_name">브라우저</span>
            </label>
          </li>
          <li class="">
            <label for="wc_import_relay_media_tab_hdd" class="wcMediaTabHDD">
              <input type="radio" name="wc_import_relay_media_radio" id="wc_import_relay_media_tab_hdd" value="HDD" class="hide" checked />
              <span id="wc_import_relay_media_tab_hdd_name">하드디스크</span>
            </label>
          </li>
          <li class="">
            <label for="wc_import_relay_media_tab_usb" class="wcMediaTabUSB">
              <input type="radio" name="wc_import_relay_media_radio" id="wc_import_relay_media_tab_usb" value="USB" class="hide" />
              <span id="wc_import_relay_media_tab_usb_name">이동식디스크</span>
            </label>
          </li>
          <li class="">
            <label for="wc_import_relay_media_tab_phone" class="wcMediaTabPhone">
              <input type="radio" name="wc_import_relay_media_radio" id="wc_import_relay_media_tab_phone" value="Phone" class="hide" />
              <span id="wc_import_relay_media_tab_phone_name">휴대폰인증</span>
            </label>
          </li>
          <li class="">
            <label for="wc_import_relay_media_tab_hsm" class="wcMediaTabHWToken">
              <input type="radio" name="wc_import_relay_media_radio" id="wc_import_relay_media_tab_hsm" value="HSM" class="hide" />
              <span id="wc_import_relay_media_tab_hsm_name">보안토큰</span>
            </label>
          </li>
          <li class="">
            <label for="wc_import_relay_media_tab_usim" class="wcMediaTabUSIM">
              <input type="radio" name="wc_import_relay_media_radio" id="wc_import_relay_media_tab_usim" value="USIM" class="hide" />
              <span id="wc_import_relay_media_tab_usim_name">스마트인증(USIM)</span>
            </label>
          </li>
        </ul>
      </div>

      <div class="wcSection">
        <h2 class="wcTitle" id="TEXT_SELECT_TARGET_DISK_AND_MODULE_TO_IMPORT">가져오기 대상 디스크 및 모듈 선택</h2>
        <div id="wc_import_relay_drive_list" class="wcDriveSelection" style="overflow-y:hidden; overflow-x:hidden;"> <!-- driveID가 4개 초과 될 경우 height:105px; overflow-y:scroll; -->
          <table summary="장치드라이브 목록" style="width:auto;">
            <thead>
              <tr>
                <th scope="col" style="width:448px;">
                  <div class="wcDriveTit" id="wcDiskAndModuleForImport">
                    디스크 및 모듈
                  </div>
                </th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
        </div>
      </div>

      <p class="wcProgBtnWrap">
        <span class="wcOkBtn"><input type="button" name="button" id="wc_import_relay_ok" value="확인" /></span>
        <span class="cancelBtn"><input type="button" name="button" id="wc_import_relay_cancel" value="취소" /></span>
      </p>
    </div>
  </div>
</div>
</form>
