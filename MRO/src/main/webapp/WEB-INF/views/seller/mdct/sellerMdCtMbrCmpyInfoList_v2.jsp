<%--
**********************************************
* 메뉴 : 회원사관리>회원사정보
* 화면 : 회원사정보
* 기능 : 협력사 회원사 정보 관리
* 프로그램 ID : 
* 담당자 : 원지성
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf" %>

<%
// 세션 정보만 필요
String com_code = _sessionInfo.getComCode();
//계좌번호 수정 기능.
boolean p01102003 = CommonUtil.getSpecialCheckReturn(com_code,"P01-1020-03");
%>
<style>

.Select {
  padding: 0 0px 0 12px  !important;
}
.Select option {
  color: #24252B !important;
  background-color: #fff !important;
}
select.Select {
  color: #24252B !important;
}
/* 전화번호/팩스번호 셀렉트박스 */
#st_tel_no1, #st_fax_no1 {
  min-width: 80px !important;
  width: 80px !important;
  padding: 0 30px 0 12px !important;
}
/* 전화번호/팩스번호 입력 필드 한 줄 정렬 */
.phone-number-wrapper {
  display: flex;
  align-items: center;
  gap: 8px;
  white-space: nowrap;
  width: 305px;
  box-sizing: border-box;
}
.phone-number-wrapper .separator {
  color: #24252B;
  font-size: 14px;
  padding: 0;
  margin: 0;
}
/* 테이블 반응형 고정 - 기본정보 테이블 최소 너비 설정 */
.TableThLTdL {
  min-width: 1290px;
  table-layout: fixed;
}
/* td 내부 요소 줄바꿈 방지 */
.TableThLTdL td {
  white-space: nowrap;
  overflow: visible;
}
/* 설립일자 달력 컴포넌트 - MonthNew.js 사용 (base.css에 스타일 정의됨) */
/* datepicker-wrap 전체 너비 및 높이 기준 정렬 */
.datepicker-wrap {
  display: flex !important;
  align-items: center !important;
  width: 305px !important;
  height: 100% !important;
  box-sizing: border-box !important;
  overflow: hidden !important;
}
.datepicker-wrap .date-input {
  position: relative !important;
  display: flex !important;
  align-items: center !important;
  width: 100% !important;
  height: 100% !important;
}
/* 설립일자 입력 필드 - 왼쪽 정렬 및 오른쪽 아이콘 공간 */
.datepicker-wrap .date-input input {
  text-align: left !important;
  width: 100% !important;
  height: 100% !important;
  padding-left: 12px !important;
  padding-right: 40px !important; /* 아이콘 공간 확보 */
  box-sizing: border-box !important;
  border-radius: 4px !important;
}
/* 달력 아이콘 오른쪽 정렬 */
.datepicker-wrap .date-input span {
  position: absolute !important;
  right: 12px !important;
  top: 50% !important;
  transform: translateY(-50%) !important;
  pointer-events: none !important;
}
/* Select 요소 반응형 처리 - 크기 고정, overflow 처리만 적용 */
.TableThLTdL td {
  overflow: hidden; /* td 범위를 벗어나는 내용 숨김 */
}
.Select {
  max-width: 100%; /* td 범위 내에서만 표시 */
  box-sizing: border-box;
}
/* Input 요소 반응형 처리 - 크기 고정, overflow 처리 */
.TableThLTdL td input.input30 {
  max-width: 100%; /* td 범위 내에서만 표시 */
  box-sizing: border-box;
}
/* 주요취급품목 파일첨부 버튼 비활성화 스타일 */
button.disabled {
  opacity: 0.5;
  cursor: not-allowed !important;
}
</style>
<!-- PopupUtil (리뉴얼 - 팝업 유틸리티) -->
<script src="/resources/js/common/PopupUtil.js" type="text/javascript"></script>

<!-- ValidationManager (입력 필드 검증 모듈) -->
<script src="/resources/js/ValidationManager.js" type="text/javascript"></script>

<script type="text/javascript">
// 전역 데이터 저장 변수
var companyData = null;
var delyAreaData = null;

// 최초 화면 로딩 함수
function kep_onload_view() {
	// 화면 진입 시 데이터 조회
	kepSearch();

	// 저장 버튼 이벤트 핸들러
	$('#saveButton').on('click', function() {
		doAction('save');
	});

	// ValidationManager 초기화
	ValidationManager.init({
		autoValidate: true,   // blur 시 자동 검증
		realtime: true,       // input 시 실시간 검증
		scrollOnError: true,  // 에러 시 스크롤
		showSuccessState: false
	});

	// 숫자만 입력 가능하도록 설정 (전화번호, 팩스번호)
	var numericFields = ['st_tel_no2', 'st_tel_no3', 'st_fax_no2', 'st_fax_no3'];

	numericFields.forEach(function(fieldId) {
		var field = document.getElementById(fieldId);
		if (field) {
			// input 이벤트: 입력 중 숫자가 아닌 문자 제거
			field.addEventListener('input', function(e) {
				this.value = this.value.replace(/[^0-9]/g, '');
			});

			// keypress 이벤트: 숫자 키만 허용
			field.addEventListener('keypress', function(e) {
				var charCode = e.which || e.keyCode;
				// 숫자(48-57), 엔터(13), 백스페이스(8), 탭(9)만 허용
				if (charCode > 31 && (charCode < 48 || charCode > 57)) {
					e.preventDefault();
					return false;
				}
				return true;
			});

			// paste 이벤트: 붙여넣기 시 숫자만 허용
			field.addEventListener('paste', function(e) {
				e.preventDefault();
				var pastedText = (e.clipboardData || window.clipboardData).getData('text');
				var numericText = pastedText.replace(/[^0-9]/g, '');
				this.value = numericText.substring(0, parseInt(this.getAttribute('maxlength') || '999'));
			});
		}
	});
}


function doAction(str) {
	switch (str) {
	case "search":	 // 조회
		kepSearch();
		break;
	case "reload":	// 초기화
		location.reload();
		break;
	case "econtViewer":	// 전자계약 전문 보기
		if (isEmpty(kepTrimStr($("#st_doc_id").val()))) {
			alert("전자계약 정보가 존재하지 않습니다.");
			return;
		}
		// contentForm이 없으므로 직접 st_doc_id를 전달
		$.ajax({
			type: "POST",
			dataType: "json",
			url: "/mdcp/getMasterMdCpEcontEmbeddedUrl.do",
			data: {
				st_doc_id: $("#st_doc_id").val()
			},
			success: function(response) {
				if (typeof response.Message != 'undefined') {
					kepAjaxError("econtViewer", response);
					return;
				}
				kepAjaxSuccess("econtViewer", response);
			},
			error: function(response) {
				kepAjaxError("econtViewer", response);
			}
		});
		break;
	case "save":	// 저장
		if (checkSubmit()) {
			saveCompanyInfo();
		}
		break;
	}
}

// 팝업 함수
function doPop(str) {
	switch (str) {
	case "newzipcode":
		openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");
		break;
	}
}

// 우편번호 검색 콜백 함수
function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn) {
	$("#st_zip_code").val(zipNo.replace(/[^0-9]/gi, ''));
	$("#st_zip_key").val(bdMgtSn);
	$("#st_address").val(roadAddrPart1 + " " + roadAddrPart2);
	$("#st_address_dt").val(addrDetail);
}

// 조회 함수 (JSON API 호출)
function kepSearch() {
	$.ajax({
		url: '/mdct/getSellerMdCtMbrCmpyInfoJson.do',
		type: 'POST',
		data: {
			st_com_code: '${sessionInfo.comCode}'
		},
		dataType: 'json',
		success: function(result) {
			companyData = result.data && result.data.length > 0 ? result.data[0] : null;
			delyAreaData = result.dataDelyArea || [];

			// 화면에 데이터 바인딩
			bindCompanyData();
		},
		error: function(xhr, status, error) {
			alert('데이터 조회 중 오류가 발생했습니다.');
			console.error('Error:', error);
		}
	});
}

/*
* ajax 공통 호출후 성공시 처리 함수
*/
function kepAjaxSuccess(pMethod, response) {
	if (pMethod == "econtViewer") {
		var url = response.url;
		window.open(url, "", "width=770,height=800,resizable=YES");
	}
}

/*
* ajax 공통 호출후 에러시 처리 함수
*/
function kepAjaxError(pMethod, response) {
	if (pMethod == "econtViewer") {
		alert("전자계약 파일이 존재하지 않습니다.\n협력사 담당자(02-3016-7251)에게 문의하시기 바랍니다.");
	} else {
		alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.");
	}
}

// 데이터 바인딩 함수
function bindCompanyData() {
	if (!companyData) {
		console.log('조회된 데이터가 없습니다.');
		return;
	}

	// 기본정보 - 정적 표시 필드
	$('#display_com_name_loc').text(companyData.COM_NAME_LOC || '');
	$('#display_irs_no').text(
		(companyData.IRS_NO1 || '') + '-' +
		(companyData.IRS_NO2 || '') + '-' +
		(companyData.IRS_NO3 || '')
	);
	$('#display_ceo_name').text(companyData.CEO_NAME_LOC || '');
	$('#display_corp_reg_no').text(companyData.CORP_REG_NO || '');
	$('#display_kep_man').text(companyData.KEP_MAN_LOC || '');

	// 기본정보 - 입력 필드
	$('#st_com_name_eng').val(companyData.COM_NAME_ENG || '');
	kepAjaxCommonComboDataValue('st_reg_type', 'M109', 'SEL', companyData.REG_TYPE || '');

	// 설립일자 포맷 변환 (YYYYMMDD -> YYYY/MM/DD)
	var establishDate = companyData.ESTABLISH_DATE || '';
	if (establishDate && establishDate.length === 8) {
		establishDate = establishDate.substring(0, 4) + '/' +
		                establishDate.substring(4, 6) + '/' +
		                establishDate.substring(6, 8);
	}
	$('#st_establish_date').val(establishDate);

	$('#st_industry_type').val(companyData.INDUSTRY_TYPE || '');
	$('#st_business_items').val(companyData.BUSINESS_ITEMS || '');

	// 전화번호 분리
	var telNo = (companyData.TEL_NO || '').split('-');
	console.log('TEL_NO:', companyData.TEL_NO, 'Split:', telNo);
	if (telNo.length >= 3) {
		$('#st_tel_no1').val(telNo[0]);
		$('#st_tel_no2').val(telNo[1]);
		$('#st_tel_no3').val(telNo[2]);
		console.log('Tel binding - st_tel_no1:', telNo[0], 'Selected:', $('#st_tel_no1').val());
	}

	// 팩스번호 분리
	var faxNo = (companyData.FAX_NO || '').split('-');
	console.log('FAX_NO:', companyData.FAX_NO, 'Split:', faxNo);
	if (faxNo.length >= 3) {
		$('#st_fax_no1').val(faxNo[0]);
		$('#st_fax_no2').val(faxNo[1]);
		$('#st_fax_no3').val(faxNo[2]);
		console.log('Fax binding - st_fax_no1:', faxNo[0], 'Selected:', $('#st_fax_no1').val());
	}

	$('#st_hp_address').val(companyData.HP_ADDRESS || '');
	$('#st_zip_code').val(companyData.ZIP_CODE || '');
	$('#st_zip_key').val(companyData.ZIP_KEY || '');
	$('#st_address').val(companyData.ADDRESS_LOC1 || '');
	$('#st_address_dt').val(companyData.ADDRESS_LOC2 || '');

	// 업체현황
	kepAjaxCommonComboDataValue('st_biz_type', 'M110', 'SEL', companyData.BIZ_TYPE || '');
	kepAjaxCommonComboDataValue('st_capt_amt', 'M129', 'SEL', companyData.CAPT_AMT || '');
	kepAjaxCommonComboDataValue('st_iso_yn', 'M112', 'SEL', companyData.ISO_YN || '');
	kepAjaxCommonComboDataValue('st_year_amt', 'M114', 'SEL', companyData.YEAR_AMT || '');
	kepAjaxCommonComboDataValue('st_license_yn', 'M113', 'SEL', companyData.LICENSE_YN || '');
	kepAjaxCommonComboDataValue('st_deliv_equip_cnt', 'M115', 'SEL', companyData.DELIV_EQUIP_CNT || '');
	kepAjaxCommonComboDataValue('st_ceo_career', 'M128', 'SEL', companyData.CEO_CAREER || '');
	kepAjaxCommonComboDataValue('st_emp_cnt', 'M111', 'SEL', companyData.EMP_CNT || '');

	// 등록구분 select box validation 초기화
	initRegTypeSelectValidation();

	// 납품가능 지역 체크박스 동적 생성
	var delyArea = companyData.DELY_AREA || '';
	$('#st_cmpy_dely_area').val(delyArea);
	$('#st_cmpy_dely_cnt').val(delyAreaData.length);

	var container = $('#dely_area_container');
	// 기존 체크박스 제거 (hidden input은 유지)
	container.find('label').remove();

	// "전체" 체크박스 추가
	var allLabel = $('<label class="CheckMediumLabel"></label>');
	var allCheckbox = $('<input type="checkbox" name="st_dely_area_all" id="st_dely_area_all">');
	var allSpan = $('<span class="CheckMediumCustom"></span>');
	allLabel.append(allCheckbox).append(allSpan).append('전체');
	container.append(allLabel);

	// 새로운 체크박스 동적 생성
	var allChecked = true; // 전체 체크박스 상태 확인용
	for (var i = 0; i < delyAreaData.length; i++) {
		var checked = delyArea.length > i && delyArea.charAt(i) == 'Y';
		if (!checked) allChecked = false;

		var areaName = delyAreaData[i].TEXT1 || '';

		var label = $('<label class="CheckMediumLabel"></label>');
		var checkbox = $('<input type="checkbox" name="st_dely_area_flag' + i + '" id="st_dely_area_flag' + i + '">');
		if (checked) checkbox.prop('checked', true);

		var span = $('<span class="CheckMediumCustom"></span>');

		label.append(checkbox).append(span).append(areaName);
		container.append(label);
	}

	// 전체 체크박스 초기 상태 설정
	$('#st_dely_area_all').prop('checked', allChecked);

	// 전체 체크박스 이벤트 핸들러
	initDelyAreaCheckboxEvents();

	// 결제정보 - 정적 표시 필드
	$('#display_pay_terms').text(companyData.PAY_TERMS || '');
	$('#display_pay_type').text(companyData.PAY_TYPE || '');

	// 계좌번호 - 권한에 따라 처리 (마스킹 제거: 모든 사용자에게 원본 표시)
	var bankAccountNo = companyData.BANK_ACCOUNT_NO || '';
	var hasEditPermission = <%= p01102003 %>;

	if (hasEditPermission) {
		// 수정 가능: input 필드 표시 (원본 계좌번호)
		$('#display_bank_info').hide();
		$('#edit_bank_account_no').val(bankAccountNo).show();
	} else {
		// 읽기 전용: 원본 계좌번호 표시 (마스킹 제거)
		$('#display_bank_info').text(
			(companyData.BANK_NAME || '') + ' ' + bankAccountNo
		).show();
		$('#edit_bank_account_no').hide();
		$('#st_bank_account_no').val(bankAccountNo); // hidden 필드에는 원본 저장
	}

	$('#display_depositor').text(companyData.DEPOSITOR || '');

	// 담당자정보 - 관리자 (ICOMLUSR)
	$('#st_ac_emp_nm').val(companyData.USER_NAME_LOC || '');
	$('#st_ac_emp_tel_full').val(companyData.PHONE_NUMBER || '');
	$('#st_ac_emp_mobile_full').val(companyData.MOBILE_PHONE || '');

	var acEmail = (companyData.EMAIL || '').split('@');
	$('#st_ac_emp_email1').val(acEmail[0] || '');
	$('#st_ac_emp_email2').val(acEmail[1] || '');

	// 담당자정보 - 영업담당자
	$('#st_gr_emp_nm').val(companyData.GR_EMP_NM || '');
	$('#st_gr_emp_tel_full').val(companyData.GR_EMP_TEL || '');
	$('#st_gr_emp_mobile_full').val(companyData.GR_EMP_MOBILE || '');

	var grEmail = (companyData.GR_EMP_EMAIL || '').split('@');
	$('#st_gr_emp_email1').val(grEmail[0] || '');
	$('#st_gr_emp_email2').val(grEmail[1] || '');

	/* 출고담당 데이터 로드 부분 주석 처리
	// 담당자정보 - 출고담당자 (레거시 납기담당자)
	// DB에는 이름(DE_EMP_NM)과 전화번호(DE_EMP_TEL)만 저장되어 있음
	$('#st_ship_emp_nm').val(companyData.DE_EMP_NM || '');
	$('#st_ship_emp_tel_full').val(companyData.DE_EMP_TEL || '');
	// 휴대폰과 이메일은 DB에 컬럼이 없으므로 빈 값으로 초기화
	$('#st_ship_emp_mobile_full').val('');
	$('#st_ship_emp_email1').val('');
	$('#st_ship_emp_email2').val('');
	*/

	// 담당자정보 - 세금계산서 담당 (ICOMCMPY.AC_EMP_*)
	$('#st_tax_emp_nm').val(companyData.AC_EMP_NM || '');
	$('#st_tax_emp_tel_full').val(companyData.AC_EMP_TEL || '');
	$('#st_tax_emp_mobile_full').val(companyData.AC_EMP_MOBILE || '');

	var taxEmail = (companyData.AC_EMP_EMAIL || '').split('@');
	$('#st_tax_emp_email1').val(taxEmail[0] || '');
	$('#st_tax_emp_email2').val(taxEmail[1] || '');

	// 전자계약 체결 여부 (EC_DOC_ID 존재 시 Y 처리)
	var ecDocId = companyData.EC_DOC_ID || '';
	$('#st_doc_id').val(ecDocId);

	var contractYn = ecDocId ? 'Y' : 'N';
	if (contractYn == 'Y') {
		$('input[name="contract_yn"][value="Y"]').prop('checked', true);
	} else {
		$('input[name="contract_yn"][value="N"]').prop('checked', true);
	}

	// 전자계약 체결 라디오 버튼 읽기 전용 설정
	$('input[name="contract_yn"]').prop('disabled', true);

	/* 정보수신여부 데이터 로드 부분 주석 처리
	// 정보수신여부 (각각 독립적으로 체크)
	var mailSendFlag = companyData.MAIL_SEND_FLAG || '';
	var smsRecvFlag = companyData.SMS_RECV_FLAG || '';
	$('#st_mail_send_flag').val(mailSendFlag);
	$('#st_sms_recv_flag').val(smsRecvFlag);

	// 각각 독립적으로 체크/해제
	$('#recv_type_mail').prop('checked', mailSendFlag == 'Y');
	$('#recv_type_sms').prop('checked', smsRecvFlag == 'Y');

	// 알림 수신 여부 체크박스 이벤트 핸들러
	initRecvTypeCheckboxEvents();
	*/

	// MRO 거래 유무 체크박스 바인딩
	$('#st_mp_business_yn').prop('checked', (companyData.MP_BUSINESS_YN || '') == 'Y');
	$('#st_mp1_business_yn').prop('checked', (companyData.MP1_BUSINESS_YN || '') == 'Y');
	$('#st_mp2_business_yn').prop('checked', (companyData.MP2_BUSINESS_YN || '') == 'Y');
	$('#st_mp3_business_yn').prop('checked', (companyData.MP3_BUSINESS_YN || '') == 'Y');
	$('#st_mp4_business_yn').prop('checked', (companyData.MP4_BUSINESS_YN || '') == 'Y');
	$('#st_mp5_business_yn').prop('checked', (companyData.MP5_BUSINESS_YN || '') == 'Y');

	// MRO 거래 유무 체크박스 이벤트 핸들러
	initMroBusinessCheckboxEvents();

	// 주요취급 품목 바인딩
	bindMainProducts();
}

// 납품가능지역 체크박스 이벤트 핸들러 초기화
function initDelyAreaCheckboxEvents() {
	var delyAreaCnt = parseInt($('#st_cmpy_dely_cnt').val()) || 0;

	// 납품가능 지역 validation 체크 함수
	function validateDelyArea() {
		var hasChecked = false;
		for (var i = 0; i < delyAreaCnt; i++) {
			if ($('#st_dely_area_flag' + i).is(':checked')) {
				hasChecked = true;
				break;
			}
		}

		var container = $('#dely_area_container');
		if (!hasChecked) {
			// 하나도 선택되지 않음 -> 빨간 테두리 (box-shadow 사용)
			container.css({
				'box-shadow': 'inset 0 0 0 2px #dc3545',
				'border-radius': '4px',
				'padding': '8px',
				'background-color': '#fff5f5'
			});
		} else {
			// 하나라도 선택됨 -> 테두리 제거
			container.css({
				'box-shadow': '',
				'border-radius': '',
				'padding': '',
				'background-color': ''
			});
		}
	}

	// "전체" 체크박스 클릭 이벤트
	$('#st_dely_area_all').on('change', function() {
		var isChecked = $(this).is(':checked');
		// 모든 지역 체크박스를 전체 체크박스 상태에 맞춤
		for (var i = 0; i < delyAreaCnt; i++) {
			$('#st_dely_area_flag' + i).prop('checked', isChecked);
		}
		validateDelyArea();
	});

	// 개별 지역 체크박스 클릭 이벤트
	for (var i = 0; i < delyAreaCnt; i++) {
		$('#st_dely_area_flag' + i).on('change', function() {
			// 모든 지역이 체크되어 있는지 확인
			var allChecked = true;
			for (var j = 0; j < delyAreaCnt; j++) {
				if (!$('#st_dely_area_flag' + j).is(':checked')) {
					allChecked = false;
					break;
				}
			}
			// 전체 체크박스 상태 업데이트
			$('#st_dely_area_all').prop('checked', allChecked);
			validateDelyArea();
		});
	}
}

// 알림 수신 여부 체크박스 이벤트 핸들러 초기화
function initRecvTypeCheckboxEvents() {
	// 알림 수신 여부 validation 체크 함수
	function validateRecvType() {
		var hasChecked = $('#recv_type_mail').is(':checked') || $('#recv_type_sms').is(':checked');
		var container = $('#recv_type_container');

		if (!hasChecked) {
			// 하나도 선택되지 않음 -> 빨간 테두리 (box-shadow 사용)
			container.css({
				'box-shadow': 'inset 0 0 0 2px #dc3545',
				'border-radius': '4px',
				'padding': '8px',
				'background-color': '#fff5f5'
			});
		} else {
			// 하나라도 선택됨 -> 테두리 제거
			container.css({
				'box-shadow': '',
				'border-radius': '',
				'padding': '',
				'background-color': ''
			});
		}
	}

	// 이메일 체크박스 이벤트
	$('#recv_type_mail').on('change', function() {
		validateRecvType();
	});

	// SMS 체크박스 이벤트
	$('#recv_type_sms').on('change', function() {
		validateRecvType();
	});
}

// 등록구분 select box validation 초기화
function initRegTypeSelectValidation() {
	// 등록구분 validation 체크 함수
	function validateRegType() {
		var regTypeValue = $('#st_reg_type').val();
		var selectElement = $('#st_reg_type');

		// 값이 없거나 기본값 'SEL'인 경우 validation-error 클래스 추가
		if (!regTypeValue || regTypeValue === '' || regTypeValue === 'SEL') {
			selectElement.addClass('validation-error');
		} else {
			// 유효한 값이 선택된 경우 클래스 제거
			selectElement.removeClass('validation-error');
		}
	}

	// 등록구분 select box change 이벤트
	$('#st_reg_type').on('change', function() {
		validateRegType();
	});
}

// MRO 거래 유무 체크박스 이벤트 핸들러 초기화
function initMroBusinessCheckboxEvents() {
	// "해당없음" 체크박스 이벤트
	$('#st_mp_business_yn').on('change', function() {
		if ($(this).is(':checked')) {
			// 해당없음 체크 시 나머지 5개 체크박스 해제
			$('#st_mp1_business_yn').prop('checked', false);
			$('#st_mp2_business_yn').prop('checked', false);
			$('#st_mp3_business_yn').prop('checked', false);
			$('#st_mp4_business_yn').prop('checked', false);
			$('#st_mp5_business_yn').prop('checked', false);
		}
	});

	// 나머지 체크박스들 이벤트 (하나라도 체크되면 "해당없음" 해제)
	$('#st_mp1_business_yn, #st_mp2_business_yn, #st_mp3_business_yn, #st_mp4_business_yn, #st_mp5_business_yn').on('change', function() {
		if ($(this).is(':checked')) {
			// 다른 체크박스 체크 시 "해당없음" 해제
			$('#st_mp_business_yn').prop('checked', false);
		}
	});
}

// 주요취급 품목 바인딩
function bindMainProducts() {
	var hasData = false;

	// 10개 로우 순회
	for (var i = 1; i <= 10; i++) {
		var itmgNm = companyData['ITMG' + i + '_NM'] || '';
		var itmMkNm = companyData['ITM_MK' + i + '_NM'] || '';
		var agencyYn = companyData['ITM_MK' + i + '_AGENCY_YN'] || '';
		var imageKey = companyData['ITM_MK' + i + '_IMAGE_KEY'] || '';

		// 데이터 있으면 로우 표시
		if (itmgNm || itmMkNm) {
			hasData = true;
			$('#product_row_' + i).show();
			$('#itmg_nm_' + i).text(itmgNm || '-');
			$('#itm_mk_nm_' + i).text(itmMkNm || '-');
			$('#agency_yn_' + i).text(getAgencyYnName(agencyYn));

			// 파일첨부 버튼 텍스트 및 다운로드 기능
			if (imageKey) {
				$('#file_btn_' + i)
					.text('파일첨부(1)')
					.removeClass('disabled')
					.attr('onclick', 'downloadProductFile(' + i + ')')
					.css('cursor', 'pointer');
			} else {
				$('#file_btn_' + i)
					.text('파일첨부')
					.addClass('disabled')
					.removeAttr('onclick')
					.css('cursor', 'not-allowed');
			}
		} else {
			// 데이터 없으면 숨김
			$('#product_row_' + i).hide();
		}
	}

	// 모든 데이터 없으면 첫 번째 로우만 빈 값으로 표시
	if (!hasData) {
		$('#product_row_1').show();
		$('#itmg_nm_1').text('-');
		$('#itm_mk_nm_1').text('-');
		$('#agency_yn_1').text('-');
		$('#file_btn_1')
			.text('파일첨부')
			.addClass('disabled')
			.removeAttr('onclick')
			.css('cursor', 'not-allowed');
	}
}

// 주요취급품목 파일 다운로드
function downloadProductFile(rowIndex) {
	var imageKey = companyData['ITM_MK' + rowIndex + '_IMAGE_KEY'] || '';

	if (imageKey && imageKey !== '') {
		location.href = '/common/download_v2.do?DOC_NO=' + imageKey;
	} else {
		PopupUtil.showConfirmLegacy('다운로드할 파일이 없습니다.');
	}
}

// 유통레벨 코드 변환
function getAgencyYnName(code) {
	var map = {
		'C': '대리점',
		'D': '총판',
		'M': '제조사'
	};
	return map[code] || code || '-';
}

// 저장 validation 체크
function checkSubmit() {
	// ValidationManager 전체 검증 (저장 시)
	if (!ValidationManager.validateAll()) {
		PopupUtil.showConfirmLegacy('입력값을 확인하세요.');
		return false;
	}

	// === 기본정보 validation ===

	// 회사명(영문)
	if (!$('#st_com_name_eng').val() || $('#st_com_name_eng').val().trim() === '') {
		PopupUtil.showConfirmLegacy('회사명(영문)을 입력하세요.');
		$('#st_com_name_eng').focus();
		return false;
	}

	// 등록구분
	if (!$('#st_reg_type').val() || $('#st_reg_type').val() === '') {
		PopupUtil.showConfirmLegacy('등록구분을 선택하세요.');
		$('#st_reg_type').focus();
		return false;
	}

	// 설립일자
	if (!$('#st_establish_date').val() || $('#st_establish_date').val().trim() === '') {
		PopupUtil.showConfirmLegacy('설립일자를 입력하세요.');
		$('#st_establish_date').focus();
		return false;
	}

	// 업태
	if (!$('#st_industry_type').val() || $('#st_industry_type').val().trim() === '') {
		PopupUtil.showConfirmLegacy('업태를 입력하세요.');
		$('#st_industry_type').focus();
		return false;
	}

	// 대표 전화번호
	if (!$('#st_tel_no1').val() || $('#st_tel_no1').val() === '') {
		PopupUtil.showConfirmLegacy('대표 전화번호를 입력하세요.');
		$('#st_tel_no1').focus();
		return false;
	}
	if (!$('#st_tel_no2').val() || $('#st_tel_no2').val().trim() === '') {
		PopupUtil.showConfirmLegacy('대표 전화번호를 입력하세요.');
		$('#st_tel_no2').focus();
		return false;
	}
	if (!$('#st_tel_no3').val() || $('#st_tel_no3').val().trim() === '') {
		PopupUtil.showConfirmLegacy('대표 전화번호를 입력하세요.');
		$('#st_tel_no3').focus();
		return false;
	}
	// 전화번호 숫자 형식 체크
	if (!/^\d+$/.test($('#st_tel_no2').val()) || !/^\d+$/.test($('#st_tel_no3').val())) {
		PopupUtil.showConfirmLegacy('대표 전화번호는 숫자만 입력 가능합니다.');
		return false;
	}

	// 대표 팩스번호
	if (!$('#st_fax_no1').val() || $('#st_fax_no1').val() === '') {
		PopupUtil.showConfirmLegacy('대표 팩스번호를 입력하세요.');
		$('#st_fax_no1').focus();
		return false;
	}
	if (!$('#st_fax_no2').val() || $('#st_fax_no2').val().trim() === '') {
		PopupUtil.showConfirmLegacy('대표 팩스번호를 입력하세요.');
		$('#st_fax_no2').focus();
		return false;
	}
	if (!$('#st_fax_no3').val() || $('#st_fax_no3').val().trim() === '') {
		PopupUtil.showConfirmLegacy('대표 팩스번호를 입력하세요.');
		$('#st_fax_no3').focus();
		return false;
	}
	// 팩스번호 숫자 형식 체크
	if (!/^\d+$/.test($('#st_fax_no2').val()) || !/^\d+$/.test($('#st_fax_no3').val())) {
		PopupUtil.showConfirmLegacy('대표 팩스번호는 숫자만 입력 가능합니다.');
		return false;
	}

	// 사업장주소
	if (!$('#st_zip_code').val() || $('#st_zip_code').val().trim() === '') {
		PopupUtil.showConfirmLegacy('우편번호를 검색하여 주소를 입력하세요.');
		return false;
	}
	if (!$('#st_address').val() || $('#st_address').val().trim() === '') {
		PopupUtil.showConfirmLegacy('주소를 입력하세요.');
		return false;
	}

	// === 업체현황 validation ===

	// 유통 레벨
	if (!$('#st_biz_type').val() || $('#st_biz_type').val() === '') {
		PopupUtil.showConfirmLegacy('유통 레벨을 선택하세요.');
		$('#st_biz_type').focus();
		return false;
	}

	// 총 자본금
	if (!$('#st_capt_amt').val() || $('#st_capt_amt').val() === '') {
		PopupUtil.showConfirmLegacy('총 자본금을 선택하세요.');
		$('#st_capt_amt').focus();
		return false;
	}

	// ISO 여부
	if (!$('#st_iso_yn').val() || $('#st_iso_yn').val() === '') {
		PopupUtil.showConfirmLegacy('ISO 여부를 선택하세요.');
		$('#st_iso_yn').focus();
		return false;
	}

	// 전년도 매출액
	if (!$('#st_year_amt').val() || $('#st_year_amt').val() === '') {
		PopupUtil.showConfirmLegacy('전년도 매출액을 선택하세요.');
		$('#st_year_amt').focus();
		return false;
	}

	// 특허여부
	if (!$('#st_license_yn').val() || $('#st_license_yn').val() === '') {
		PopupUtil.showConfirmLegacy('특허여부를 선택하세요.');
		$('#st_license_yn').focus();
		return false;
	}

	// 배송차량 수
	if (!$('#st_deliv_equip_cnt').val() || $('#st_deliv_equip_cnt').val() === '') {
		PopupUtil.showConfirmLegacy('배송차량 수를 선택하세요.');
		$('#st_deliv_equip_cnt').focus();
		return false;
	}

	// 대표자 동종업계 경력
	if (!$('#st_ceo_career').val() || $('#st_ceo_career').val() === '') {
		PopupUtil.showConfirmLegacy('대표자 동종업계 경력을 선택하세요.');
		$('#st_ceo_career').focus();
		return false;
	}

	// 상시 근로자 수
	if (!$('#st_emp_cnt').val() || $('#st_emp_cnt').val() === '') {
		PopupUtil.showConfirmLegacy('상시 근로자 수를 선택하세요.');
		$('#st_emp_cnt').focus();
		return false;
	}

	// 납품가능 지역 (최소 1개 체크)
	var delyAreaCnt = parseInt($('#st_cmpy_dely_cnt').val()) || 0;
	var hasDelyArea = false;
	for (var i = 0; i < delyAreaCnt; i++) {
		if ($('#st_dely_area_flag' + i).is(':checked')) {
			hasDelyArea = true;
			break;
		}
	}
	if (!hasDelyArea) {
		PopupUtil.showConfirmLegacy('납품가능 지역을 최소 1개 이상 선택하세요.');
		return false;
	}

	// === 담당자정보 validation ===

	// 관리자(경리담당자)
	if (!$('#st_ac_emp_nm').val() || $('#st_ac_emp_nm').val().trim() === '') {
		PopupUtil.showConfirmLegacy('관리자 담당자명을 입력하세요.');
		$('#st_ac_emp_nm').focus();
		return false;
	}
	if (!$('#st_ac_emp_tel_full').val() || $('#st_ac_emp_tel_full').val().trim() === '') {
		PopupUtil.showConfirmLegacy('관리자 전화번호를 입력하세요.');
		$('#st_ac_emp_tel_full').focus();
		return false;
	}
	if (!$('#st_ac_emp_mobile_full').val() || $('#st_ac_emp_mobile_full').val().trim() === '') {
		PopupUtil.showConfirmLegacy('관리자 휴대폰번호를 입력하세요.');
		$('#st_ac_emp_mobile_full').focus();
		return false;
	}
	// 관리자 이메일 체크
	var acEmail1 = $('#st_ac_emp_email1').val() || '';
	var acEmail2 = $('#st_ac_emp_email2').val() || '';
	if (acEmail1.trim() === '' || acEmail2.trim() === '') {
		PopupUtil.showConfirmLegacy('관리자 이메일을 입력하세요.');
		$('#st_ac_emp_email1').focus();
		return false;
	}
	// 이메일 형식 체크
	var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	if (!emailPattern.test(acEmail1 + '@' + acEmail2)) {
		PopupUtil.showConfirmLegacy('관리자 이메일 형식이 올바르지 않습니다.');
		$('#st_ac_emp_email1').focus();
		return false;
	}

	// 영업담당
	if (!$('#st_gr_emp_nm').val() || $('#st_gr_emp_nm').val().trim() === '') {
		PopupUtil.showConfirmLegacy('영업담당 담당자명을 입력하세요.');
		$('#st_gr_emp_nm').focus();
		return false;
	}
	if (!$('#st_gr_emp_tel_full').val() || $('#st_gr_emp_tel_full').val().trim() === '') {
		PopupUtil.showConfirmLegacy('영업담당 전화번호를 입력하세요.');
		$('#st_gr_emp_tel_full').focus();
		return false;
	}
	if (!$('#st_gr_emp_mobile_full').val() || $('#st_gr_emp_mobile_full').val().trim() === '') {
		PopupUtil.showConfirmLegacy('영업담당 휴대폰번호를 입력하세요.');
		$('#st_gr_emp_mobile_full').focus();
		return false;
	}
	// 영업담당 이메일 체크
	var grEmail1 = $('#st_gr_emp_email1').val() || '';
	var grEmail2 = $('#st_gr_emp_email2').val() || '';
	if (grEmail1.trim() === '' || grEmail2.trim() === '') {
		PopupUtil.showConfirmLegacy('영업담당 이메일을 입력하세요.');
		$('#st_gr_emp_email1').focus();
		return false;
	}
	if (!emailPattern.test(grEmail1 + '@' + grEmail2)) {
		PopupUtil.showConfirmLegacy('영업담당 이메일 형식이 올바르지 않습니다.');
		$('#st_gr_emp_email1').focus();
		return false;
	}

	// ========== 출고담당 validation (임시 주석 처리: 나중에 필수 항목으로 재추가 예정) ==========
	/*
	if (!$('#st_ship_emp_nm').val() || $('#st_ship_emp_nm').val().trim() === '') {
		PopupUtil.showConfirmLegacy('출고담당 담당자명을 입력하세요.');
		$('#st_ship_emp_nm').focus();
		return false;
	}
	if (!$('#st_ship_emp_tel_full').val() || $('#st_ship_emp_tel_full').val().trim() === '') {
		PopupUtil.showConfirmLegacy('출고담당 전화번호를 입력하세요.');
		$('#st_ship_emp_tel_full').focus();
		return false;
	}
	if (!$('#st_ship_emp_mobile_full').val() || $('#st_ship_emp_mobile_full').val().trim() === '') {
		PopupUtil.showConfirmLegacy('출고담당 휴대폰번호를 입력하세요.');
		$('#st_ship_emp_mobile_full').focus();
		return false;
	}
	// 출고담당 이메일 체크
	var shipEmail1 = $('#st_ship_emp_email1').val() || '';
	var shipEmail2 = $('#st_ship_emp_email2').val() || '';
	if (shipEmail1.trim() === '' || shipEmail2.trim() === '') {
		PopupUtil.showConfirmLegacy('출고담당 이메일을 입력하세요.');
		$('#st_ship_emp_email1').focus();
		return false;
	}
	if (!emailPattern.test(shipEmail1 + '@' + shipEmail2)) {
		PopupUtil.showConfirmLegacy('출고담당 이메일 형식이 올바르지 않습니다.');
		$('#st_ship_emp_email1').focus();
		return false;
	}
	*/
	// ========== 출고담당 validation 끝 ==========

	// 세금계산서 담당
	if (!$('#st_tax_emp_nm').val() || $('#st_tax_emp_nm').val().trim() === '') {
		PopupUtil.showConfirmLegacy('세금계산서 담당자명을 입력하세요.');
		$('#st_tax_emp_nm').focus();
		return false;
	}
	if (!$('#st_tax_emp_tel_full').val() || $('#st_tax_emp_tel_full').val().trim() === '') {
		PopupUtil.showConfirmLegacy('세금계산서 담당 전화번호를 입력하세요.');
		$('#st_tax_emp_tel_full').focus();
		return false;
	}
	if (!$('#st_tax_emp_mobile_full').val() || $('#st_tax_emp_mobile_full').val().trim() === '') {
		PopupUtil.showConfirmLegacy('세금계산서 담당 휴대폰번호를 입력하세요.');
		$('#st_tax_emp_mobile_full').focus();
		return false;
	}
	// 세금계산서 담당 이메일 체크
	var taxEmail1 = $('#st_tax_emp_email1').val() || '';
	var taxEmail2 = $('#st_tax_emp_email2').val() || '';
	if (taxEmail1.trim() === '' || taxEmail2.trim() === '') {
		PopupUtil.showConfirmLegacy('세금계산서 담당 이메일을 입력하세요.');
		$('#st_tax_emp_email1').focus();
		return false;
	}
	if (!emailPattern.test(taxEmail1 + '@' + taxEmail2)) {
		PopupUtil.showConfirmLegacy('세금계산서 담당 이메일 형식이 올바르지 않습니다.');
		$('#st_tax_emp_email1').focus();
		return false;
	}

	/* 정보수신여부 validation 주석 처리
	// === 정보수신여부 validation ===
	if (!$('#recv_type_mail').is(':checked') && !$('#recv_type_sms').is(':checked')) {
		PopupUtil.showConfirmLegacy('알림 수신 여부를 최소 1개 이상 선택하세요.');
		// 시각적 피드백 (box-shadow 사용)
		$('#recv_type_container').css({
			'box-shadow': 'inset 0 0 0 2px #dc3545',
			'border-radius': '4px',
			'padding': '8px',
			'background-color': '#fff5f5'
		});
		return false;
	}
	*/

	// === 납품가능 지역 validation ===
	var delyAreaCnt = parseInt($('#st_cmpy_dely_cnt').val()) || 0;
	var hasCheckedDelyArea = false;
	for (var i = 0; i < delyAreaCnt; i++) {
		if ($('#st_dely_area_flag' + i).is(':checked')) {
			hasCheckedDelyArea = true;
			break;
		}
	}
	if (!hasCheckedDelyArea) {
		PopupUtil.showConfirmLegacy('납품가능 지역을 최소 1개 이상 선택하세요.');
		// 시각적 피드백 (box-shadow 사용)
		$('#dely_area_container').css({
			'box-shadow': 'inset 0 0 0 2px #dc3545',
			'border-radius': '4px',
			'padding': '8px',
			'background-color': '#fff5f5'
		});
		return false;
	}

	// 모든 validation 통과
	return true;
}

// 납품가능 지역 데이터 수집
function collectDelyArea() {
	var delyAreaCnt = parseInt($('#st_cmpy_dely_cnt').val()) || 0;
	var delyArea = '';

	for (var i = 0; i < delyAreaCnt; i++) {
		if ($('#st_dely_area_flag' + i).is(':checked')) {
			delyArea += 'Y';
		} else {
			delyArea += 'N';
		}
	}

	return delyArea;
}

// 빈 문자열 처리 함수 (Oracle JDBC 호환성을 위해 null 대신 빈 문자열 반환)
// Oracle JDBC는 타입이 명시되지 않은 null을 처리할 수 없어서 Types.OTHER (1111) 에러 발생
// 빈 문자열('')을 전송하면 Oracle이 VARCHAR2로 처리 가능
function emptyToNull(value) {
	return (value === '' || value === null || value === undefined) ? '' : value;
}

// 계좌번호 마스킹 함수 (앞 4자리 제외하고 '*' 처리)
function maskAccountNumber(accountNo) {
	if (!accountNo || accountNo.length <= 4) {
		return accountNo; // 4자리 이하면 그대로 반환
	}

	var visible = accountNo.substring(0, 4); // 앞 4자리
	var masked = '*'.repeat(accountNo.length - 4); // 나머지는 '*'

	return visible + masked;
}

// 저장 데이터 수집
function collectFormData() {
	// 관리자 전화번호 분리
	var acTel = ($('#st_ac_emp_tel_full').val() || '').split('-');
	var acMobile = ($('#st_ac_emp_mobile_full').val() || '').split('-');

	// 영업담당자 전화번호 분리
	var grTel = ($('#st_gr_emp_tel_full').val() || '').split('-');
	var grMobile = ($('#st_gr_emp_mobile_full').val() || '').split('-');

	/* 출고담당자 전화번호 분리 주석 처리
	// 출고담당자 전화번호 분리
	var shipTel = ($('#st_ship_emp_tel_full').val() || '').split('-');
	*/

	// 세금계산서 담당 전화번호 분리
	var taxTel = ($('#st_tax_emp_tel_full').val() || '').split('-');
	var taxMobile = ($('#st_tax_emp_mobile_full').val() || '').split('-');

	// 이메일 결합
	var acEmail = ($('#st_ac_emp_email1').val() || '') + '@' + ($('#st_ac_emp_email2').val() || '');
	var grEmail = ($('#st_gr_emp_email1').val() || '') + '@' + ($('#st_gr_emp_email2').val() || '');
	var taxEmail = ($('#st_tax_emp_email1').val() || '') + '@' + ($('#st_tax_emp_email2').val() || '');

	// 계좌번호 수집 (권한에 따라)
	var hasEditPermission = <%= p01102003 %>;
	var bankAccountNo = hasEditPermission ? $('#edit_bank_account_no').val() : $('#st_bank_account_no').val();

	// 설립일자 포맷 변환 (YYYY/MM/DD -> YYYYMMDD)
	var establishDateValue = $('#st_establish_date').val() || '';
	if (establishDateValue) {
		establishDateValue = establishDateValue.replace(/\//g, '');
	}

	var data = {
		st_com_code: '${sessionInfo.comCode}',
		st_user_id: '${sessionInfo.userId}',
		st_bank_account_no: emptyToNull(bankAccountNo),

		// 기본정보 (ICOMCMPY)
		st_com_name_eng: emptyToNull($('#st_com_name_eng').val()),
		st_industry_type: emptyToNull($('#st_industry_type').val()),
		st_business_items: emptyToNull($('#st_business_items').val()),
		st_establish_date: emptyToNull(establishDateValue),
		st_tel_no1: emptyToNull($('#st_tel_no1').val()),
		st_tel_no2: emptyToNull($('#st_tel_no2').val()),
		st_tel_no3: emptyToNull($('#st_tel_no3').val()),
		st_fax_no1: emptyToNull($('#st_fax_no1').val()),
		st_fax_no2: emptyToNull($('#st_fax_no2').val()),
		st_fax_no3: emptyToNull($('#st_fax_no3').val()),
		st_hp_address: emptyToNull($('#st_hp_address').val()),
		st_zip_code: emptyToNull($('#st_zip_code').val()),
		st_zip_key: emptyToNull($('#st_zip_key').val()),
		st_address: emptyToNull($('#st_address').val()),
		st_address_dt: emptyToNull($('#st_address_dt').val()),

		// 관리자 - ICOMLUSR 테이블 업데이트용 (st_ac_emp_* HTML 필드 사용)
		st_user_name_loc: emptyToNull($('#st_ac_emp_nm').val()),
		st_phone_number: emptyToNull($('#st_ac_emp_tel_full').val()),
		st_mobile_phone: emptyToNull($('#st_ac_emp_mobile_full').val()),
		st_email: acEmail != '@' ? emptyToNull(acEmail) : null,

		// 영업담당자 - 분리된 형태로 전송
		st_gr_emp_nm: emptyToNull($('#st_gr_emp_nm').val()),
		st_gr_emp_tel1: emptyToNull(grTel[0]),
		st_gr_emp_tel2: emptyToNull(grTel[1]),
		st_gr_emp_tel3: emptyToNull(grTel[2]),
		st_gr_emp_mobile1: emptyToNull(grMobile[0]),
		st_gr_emp_mobile2: emptyToNull(grMobile[1]),
		st_gr_emp_mobile3: emptyToNull(grMobile[2]),
		st_gr_emp_email: grEmail != '@' ? emptyToNull(grEmail) : null,

		/* 출고담당자 데이터 전송 주석 처리
		// 출고담당자 - 분리된 형태로 전송 (DB에는 이름과 전화번호만 저장)
		st_ship_emp_nm: emptyToNull($('#st_ship_emp_nm').val()),
		st_ship_emp_tel1: emptyToNull(shipTel[0]),
		st_ship_emp_tel2: emptyToNull(shipTel[1]),
		st_ship_emp_tel3: emptyToNull(shipTel[2]),
		*/

		// 세금계산서 담당 - ICOMCMPY.AC_EMP_* 업데이트용 (st_tax_emp_* HTML 필드를 st_ac_emp_* 파라미터로 전송)
		st_ac_emp_nm: emptyToNull($('#st_tax_emp_nm').val()),
		st_ac_emp_tel1: emptyToNull(taxTel[0]),
		st_ac_emp_tel2: emptyToNull(taxTel[1]),
		st_ac_emp_tel3: emptyToNull(taxTel[2]),
		st_ac_emp_mobile1: emptyToNull(taxMobile[0]),
		st_ac_emp_mobile2: emptyToNull(taxMobile[1]),
		st_ac_emp_mobile3: emptyToNull(taxMobile[2]),
		st_ac_emp_email: taxEmail != '@' ? emptyToNull(taxEmail) : null,

		/* 정보수신여부 데이터 전송 주석 처리
		// 정보수신여부
		st_mail_send_flag: $('#recv_type_mail').is(':checked') ? 'Y' : 'N',
		st_sms_recv_flag: $('#recv_type_sms').is(':checked') ? 'Y' : 'N',
		*/

		// 납품가능 지역
		st_cmpy_dely_area: collectDelyArea(),

		// 업체현황 (SUPLINFO2) - 빈값은 null로 전송
		st_reg_type: emptyToNull($('#st_reg_type').val()),
		st_biz_type: emptyToNull($('#st_biz_type').val()),
		st_capt_amt: emptyToNull($('#st_capt_amt').val()),
		st_iso_yn: emptyToNull($('#st_iso_yn').val()),
		st_year_amt: emptyToNull($('#st_year_amt').val()),
		st_license_yn: emptyToNull($('#st_license_yn').val()),
		st_deliv_equip_cnt: emptyToNull($('#st_deliv_equip_cnt').val()),
		st_ceo_career: emptyToNull($('#st_ceo_career').val()),
		st_emp_cnt: emptyToNull($('#st_emp_cnt').val()),

		// MRO 거래 유무
		st_mp_business_yn: $('#st_mp_business_yn').is(':checked') ? 'Y' : '',
		st_mp1_business_yn: $('#st_mp1_business_yn').is(':checked') ? 'Y' : '',
		st_mp2_business_yn: $('#st_mp2_business_yn').is(':checked') ? 'Y' : '',
		st_mp3_business_yn: $('#st_mp3_business_yn').is(':checked') ? 'Y' : '',
		st_mp4_business_yn: $('#st_mp4_business_yn').is(':checked') ? 'Y' : '',
		st_mp5_business_yn: $('#st_mp5_business_yn').is(':checked') ? 'Y' : '',

		// 주요취급 품목 데이터 (읽기 전용이므로 companyData에서 원본 값 전송)
		st_itm_mk_yn: emptyToNull(companyData.ITM_MK_YN),

		// 취급가능품목 코드 (10개)
		st_itmg1_cd: emptyToNull(companyData.ITMG1_CD),
		st_itmg2_cd: emptyToNull(companyData.ITMG2_CD),
		st_itmg3_cd: emptyToNull(companyData.ITMG3_CD),
		st_itmg4_cd: emptyToNull(companyData.ITMG4_CD),
		st_itmg5_cd: emptyToNull(companyData.ITMG5_CD),
		st_itmg6_cd: emptyToNull(companyData.ITMG6_CD),
		st_itmg7_cd: emptyToNull(companyData.ITMG7_CD),
		st_itmg8_cd: emptyToNull(companyData.ITMG8_CD),
		st_itmg9_cd: emptyToNull(companyData.ITMG9_CD),
		st_itmg10_cd: emptyToNull(companyData.ITMG10_CD),

		// 대리점권 보유 메이커 코드 (10개)
		st_itm_mk1: emptyToNull(companyData.ITM_MK1),
		st_itm_mk2: emptyToNull(companyData.ITM_MK2),
		st_itm_mk3: emptyToNull(companyData.ITM_MK3),
		st_itm_mk4: emptyToNull(companyData.ITM_MK4),
		st_itm_mk5: emptyToNull(companyData.ITM_MK5),
		st_itm_mk6: emptyToNull(companyData.ITM_MK6),
		st_itm_mk7: emptyToNull(companyData.ITM_MK7),
		st_itm_mk8: emptyToNull(companyData.ITM_MK8),
		st_itm_mk9: emptyToNull(companyData.ITM_MK9),
		st_itm_mk10: emptyToNull(companyData.ITM_MK10),

		// 유통레벨/계약서류유무 (10개)
		st_itm_mk1_yn: emptyToNull(companyData.ITM_MK1_AGENCY_YN),
		st_itm_mk2_yn: emptyToNull(companyData.ITM_MK2_AGENCY_YN),
		st_itm_mk3_yn: emptyToNull(companyData.ITM_MK3_AGENCY_YN),
		st_itm_mk4_yn: emptyToNull(companyData.ITM_MK4_AGENCY_YN),
		st_itm_mk5_yn: emptyToNull(companyData.ITM_MK5_AGENCY_YN),
		st_itm_mk6_yn: emptyToNull(companyData.ITM_MK6_AGENCY_YN),
		st_itm_mk7_yn: emptyToNull(companyData.ITM_MK7_AGENCY_YN),
		st_itm_mk8_yn: emptyToNull(companyData.ITM_MK8_AGENCY_YN),
		st_itm_mk9_yn: emptyToNull(companyData.ITM_MK9_AGENCY_YN),
		st_itm_mk10_yn: emptyToNull(companyData.ITM_MK10_AGENCY_YN),

		// 계약서류첨부파일 키 (10개)
		st_itm_mk1_image_key: emptyToNull(companyData.ITM_MK1_IMAGE_KEY),
		st_itm_mk2_image_key: emptyToNull(companyData.ITM_MK2_IMAGE_KEY),
		st_itm_mk3_image_key: emptyToNull(companyData.ITM_MK3_IMAGE_KEY),
		st_itm_mk4_image_key: emptyToNull(companyData.ITM_MK4_IMAGE_KEY),
		st_itm_mk5_image_key: emptyToNull(companyData.ITM_MK5_IMAGE_KEY),
		st_itm_mk6_image_key: emptyToNull(companyData.ITM_MK6_IMAGE_KEY),
		st_itm_mk7_image_key: emptyToNull(companyData.ITM_MK7_IMAGE_KEY),
		st_itm_mk8_image_key: emptyToNull(companyData.ITM_MK8_IMAGE_KEY),
		st_itm_mk9_image_key: emptyToNull(companyData.ITM_MK9_IMAGE_KEY),
		st_itm_mk10_image_key: emptyToNull(companyData.ITM_MK10_IMAGE_KEY)
	};

	console.log('저장 데이터:', data);
	return data;
}

// 저장 함수
function saveCompanyInfo() {
	// 취소 버튼이 있는 확인 팝업 사용
	PopupUtil.showConfirmWithCancelLegacy(
		'수정한 정보로 저장하시겠습니까?',
		function() {
			// 확인 버튼 클릭 시 실행
			var formData = collectFormData();

			$.ajax({
				url: '/mdct/saveSellerMdCtMbrCmpyInfoList_v2.do',
				type: 'POST',
				data: formData,
				dataType: 'json',
				success: function(response) {
					console.log('저장 응답:', response);
					if (response.msg == 'OK') {
						PopupUtil.showConfirmLegacy('저장되었습니다.', function() {
							kepSearch(); // 재조회
						});
					} else {
						PopupUtil.showConfirmLegacy('저장 중 오류가 발생했습니다.');
					}
				},
				error: function(xhr, status, error) {
					PopupUtil.showConfirmLegacy('저장 중 오류가 발생했습니다.');
					console.error('Save error:', error);
					console.error('Response:', xhr.responseText);
				}
			});
		},
		function() {
			// 취소 버튼 클릭 시 실행
			console.log('저장 취소됨');
		}
	);
}
</script>
</head>


<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader_sub_v2"/>
<c:param name="part" value="header_v2"/>
</c:import>
<c:import charEncoding="utf-8" url="/main/leftMenuData.do">
<c:param name="page" value="sellerLeft_v2"/>
</c:import>



<div class="containerBoxSub" >
      <div class="PDleft50"><!--padding-left:50px; 시작 -->    
		<div class="SubTit">회원사 정보
          <div class="SummaryGuide">
      	    <ul>
        	  <li><img src="/resources/imgs/Icon_Home.png" /></li>
              <li>회원사관리</li>
              <li>회원사 정보</li>
            </ul>
          </div>
        </div>
        
		<div class="containerSub"><!--margin-right:50px; 설정 -->  
          <div class="SubTitStep3">기본정보 <span>*표시는 필수 입력사항입니다.</span></div>
		  <table class="TableThLTdL" width="100%">
            <colgroup>
              <col width="155px" />
              <col width="275px" />
              <col width="155px" />
              <col width="275px" />
              <col width="155px" />
              <col width="275px" />
            </colgroup>
            <tr>
              <th><span class="f2f7ff">*</span> 회사명(국문)</th>
              <td id="display_com_name_loc"></td>
              <th><span class="f2f7ff">*</span> 회사코드</th>
              <td><%=com_code%></td>
              <th><span class="F6495F">*</span> 회사명(영문)</th>
              <td>
                <input class="input30" style="width:305px" name="st_com_name_eng" id="st_com_name_eng" type="text"
                       data-validate="required|maxLength:25|pattern:^[a-zA-Z0-9\s&.,\-()]+$"
                       data-error-message="영문만 입력가능 (최대 25자)" />
                <span class="error-message" data-error-for="st_com_name_eng"></span>
              </td>
            </tr>
            <tr>
              <th><span class="F6495F">*</span> 등록구분</th>
              <td>
                <select name="st_reg_type" id="st_reg_type" class="Select" style="width:305px"></select>
              </td>
              <th><span class="f2f7ff">*</span> 사업자등록번호</th>
              <td id="display_irs_no"></td>
              <th><span class="f2f7ff">*</span> 법인번호</th>
              <td id="display_corp_reg_no"></td>
            </tr>
            <tr>
              <th><span class="f2f7ff">*</span> 대표자</th>
              <td id="display_ceo_name"></td>
              <th><span class="F6495F">*</span> 설립일자</th>
              <td>
                <div class="datepicker-wrap">
                  <div class="date-input"><input type="text" placeholder="" id="st_establish_date" name="st_establish_date" readonly /><span></span></div>
                </div>
                <script>
                  // DatePicker 달력 초기화 및 ValidationManager 초기화
                  // Note: inline script이므로 즉시 실행 (DOMContentLoaded 불필요 - 이미 input 요소 다음에 위치)
                  var establishDatePicker = null;

                  // setTimeout으로 초기화 타이밍 보장
                  setTimeout(function() {
                    // DatePicker 초기화 (설립일자)
                    if (typeof DatePicker !== 'undefined') {
                      var targetElement = document.getElementById('st_establish_date');
                      if (targetElement) {
                        establishDatePicker = new DatePicker({
                          type: 'single',
                          targetId: 'st_establish_date',
                          dateFormat: '/',
                          locale: 'ko'
                        });
                        establishDatePicker.init();
                        console.log('[회원사정보] DatePicker 초기화 완료');
                      } else {
                        console.error('[회원사정보] st_establish_date 요소를 찾을 수 없습니다.');
                      }
                    } else {
                      console.error('[회원사정보] DatePicker.js가 로드되지 않았습니다.');
                    }

                    // ValidationManager 초기화 (담당자 정보 validation)
                    if (typeof ValidationManager !== 'undefined') {
                      ValidationManager.init({
                        autoValidate: true,
                        realtime: false,
                        scrollOnError: true,
                        scrollOffset: 100,
                        showSuccessState: false
                      });
                      console.log('[회원사정보] ValidationManager 초기화 완료');
                    }
                  }, 100);
                </script>
              </td>
              <th><span class="F6495F">*</span> 업태</th>
              <td>
                <input class="input30" style="width:305px" name="st_industry_type" id="st_industry_type" type="text"
                       data-validate="required|maxLength:100|pattern:^[가-힣a-zA-Z0-9\s,.()\-/]+$"
                       data-error-message="한글, 영문, 숫자, 콤마(,) 최대 25자 가능" />
                <span class="error-message" data-error-for="st_industry_type"></span>
              </td>
            </tr>
            <tr>
              <th><span class="F6495F">*</span> 업종</th>
              <td>
                <input class="input30" style="width:305px" name="st_business_items" id="st_business_items" type="text"
                       placeholder="예: 도소매업, 제조업"
                       data-validate="required|maxLength:100|pattern:^[가-힣a-zA-Z0-9\s,.()\-/]+$"
                       data-error-message="한글, 영문, 숫자, 콤마(,) 최대 25자 가능" />
                <span class="error-message" data-error-for="st_business_items"></span>
              </td>
              <th><span class="F6495F">*</span> 대표 전화번호</th>
              <td>
                <div class="phone-number-wrapper">
                  <select id="st_tel_no1" name="st_tel_no1" class="Select" style="width:60px">
                    <option value="02">02</option>
                    <option value="031">031</option>
                    <option value="032">032</option>
                    <option value="033">033</option>
                    <option value="041">041</option>
                    <option value="042">042</option>
                    <option value="043">043</option>
                    <option value="044">044</option>
                    <option value="051">051</option>
                    <option value="052">052</option>
                    <option value="053">053</option>
                    <option value="054">054</option>
                    <option value="055">055</option>
                    <option value="061">061</option>
                    <option value="062">062</option>
                    <option value="063">063</option>
                    <option value="064">064</option>
                    <option value="070">070</option>
                    <option value="0303">0303</option>
                    <option value="0502">0502</option>
                    <option value="0504">0504</option>
                    <option value="0505">0505</option>
                    <option value="0506">0506</option>
                    <option value="0507">0507</option>
                  </select>
                  <span class="separator">-</span>
                  <input class="input30" style="width:90px" name="st_tel_no2" id="st_tel_no2" type="text" maxlength="4"
                         data-validate="required|minLength:3|maxLength:4|number"
                         data-error-message="3-4자리 숫자 입력" />
                  <span class="separator">-</span>
                  <input class="input30" style="width:93px" name="st_tel_no3" id="st_tel_no3" type="text" maxlength="4"
                         data-validate="required|length:4|number"
                         data-error-message="4자리 숫자 입력" />
                </div>
                <span class="error-message" data-error-for="st_tel_no2"></span>
                <span class="error-message" data-error-for="st_tel_no3"></span>
              </td>
              <th><span class="F6495F">*</span> 대표 팩스번호</th>
              <td>
                <div class="phone-number-wrapper">
                  <select id="st_fax_no1" name="st_fax_no1" class="Select" style="width:60px">
                    <option value="02">02</option>
                    <option value="031">031</option>
                    <option value="032">032</option>
                    <option value="033">033</option>
                    <option value="041">041</option>
                    <option value="042">042</option>
                    <option value="043">043</option>
                    <option value="044">044</option>
                    <option value="051">051</option>
                    <option value="052">052</option>
                    <option value="053">053</option>
                    <option value="054">054</option>
                    <option value="055">055</option>
                    <option value="061">061</option>
                    <option value="062">062</option>
                    <option value="063">063</option>
                    <option value="064">064</option>
                    <option value="070">070</option>
                    <option value="0303">0303</option>
                    <option value="0502">0502</option>
                    <option value="0504">0504</option>
                    <option value="0505">0505</option>
                    <option value="0506">0506</option>
                    <option value="0507">0507</option>
                  </select>
                  <span class="separator">-</span>
                  <input class="input30" style="width:90px" name="st_fax_no2" id="st_fax_no2" type="text" maxlength="4"
                         data-validate="required|minLength:3|maxLength:4|number"
                         data-error-message="3-4자리 숫자 입력" />
                  <span class="separator">-</span>
                  <input class="input30" style="width:92px" name="st_fax_no3" id="st_fax_no3" type="text" maxlength="4"
                         data-validate="required|length:4|number"
                         data-error-message="4자리 숫자 입력" />
                </div>
                <span class="error-message" data-error-for="st_fax_no2"></span>
                <span class="error-message" data-error-for="st_fax_no3"></span>
              </td>
            </tr>
            <tr>
              <th><span class="f2f7ff">*</span> 홈페이지</th>
              <td colspan="3"><input class="input30" style="width:calc(100% - 3.5px); padding-left:12px; padding-right:0px; box-sizing:border-box;" name="st_hp_address" id="st_hp_address" type="text" /></td>
              <th><span class="f2f7ff">*</span> KeP 담당자</th>
              <td id="display_kep_man"></td>
            </tr>
            <tr>
              <th><span class="F6495F">*</span> 사업장주소</th>
              <td colspan="5">
                <input class="input30" style="width:205px" name="st_zip_code" id="st_zip_code" type="text" readonly />
                <button class="ButDarkGray_Small" onclick="doPop('newzipcode'); return false;">우편번호</button>
                <input type="hidden" name="st_zip_key" id="st_zip_key" />
                <input class="input30" style="width:43%" name="st_address" id="st_address" type="text" readonly />
                <input class="input30" style="width:calc(31% + 63px)" name="st_address_dt" id="st_address_dt" type="text" />
              </td>
            </tr>                      
		  </table> 
          <div class="SubTitStep3">업체현황 </div>
		  <table class="TableThLTdL" width="100%">
            <colgroup>
              <col width="155px" />
              <col width="275px" />
              <col width="155px" />
              <col width="275px" />
              <col width="155px" />
              <col width="275px" />
            </colgroup>
            <tr>
              <th><span class="F6495F">*</span> 유통 레벨</th>
              <td>
                <select name="st_biz_type" id="st_biz_type" class="Select" style="width:305px"
                        data-validate="required"></select>
              </td>
              <th><span class="F6495F">*</span> 총 자본금</th>
              <td>
                <select name="st_capt_amt" id="st_capt_amt" class="Select" style="width:305px"
                        data-validate="required"></select>
              </td>
              <th><span class="F6495F">*</span> ISO 여부</th>
              <td>
                <select name="st_iso_yn" id="st_iso_yn" class="Select" style="width:305px"
                        data-validate="required"></select>
              </td>
            </tr>
            <tr>
              <th><span class="F6495F">*</span> 전년도 매출액</th>
              <td>
                <select name="st_year_amt" id="st_year_amt" class="Select" style="width:305px"
                        data-validate="required"></select>
              </td>
              <th><span class="F6495F">*</span> 특허여부</th>
              <td>
                <select name="st_license_yn" id="st_license_yn" class="Select" style="width:305px"
                        data-validate="required"></select>
              </td>
              <th><span class="F6495F">*</span> 배송차량 수</th>
              <td>
                <select name="st_deliv_equip_cnt" id="st_deliv_equip_cnt" class="Select" style="width:305px"
                        data-validate="required"></select>
              </td>
            </tr>
            <tr>
              <th><span class="F6495F">*</span> <span style="font-size:95%">대표자 동종업계 경력</span></th>
              <td>
                <select name="st_ceo_career" id="st_ceo_career" class="Select" style="width:305px"
                        data-validate="required"></select>
              </td>
              <th><span class="F6495F">*</span> 상시 근로자 수</th>
              <td colspan="3">
                <select name="st_emp_cnt" id="st_emp_cnt" class="Select" style="width:305px"
                        data-validate="required"></select>
              </td>
            </tr>
            <tr>
              <th><span class="F6495F">*</span> 납품가능 지역</th>
              <td colspan="5" id="dely_area_container">
                <input type="hidden" name="st_cmpy_dely_area" id="st_cmpy_dely_area" />
                <input type="hidden" name="st_cmpy_dely_cnt" id="st_cmpy_dely_cnt" />
                <!-- 동적 생성 영역 -->
              </td>
            </tr> 
            <tr>
              <th><span class="f2f7ff">*</span> MRO 거래 유무</th>
              <td colspan="5">
                <label class="CheckMediumLabel"><input type="checkbox" name="st_mp_business_yn" id="st_mp_business_yn"><span class="CheckMediumCustom"></span>해당없음</label>
                <label class="CheckMediumLabel"><input type="checkbox" name="st_mp1_business_yn" id="st_mp1_business_yn"><span class="CheckMediumCustom"></span>서브원</label>
                <label class="CheckMediumLabel"><input type="checkbox" name="st_mp2_business_yn" id="st_mp2_business_yn"><span class="CheckMediumCustom"></span>아이엠케이</label>
                <label class="CheckMediumLabel"><input type="checkbox" name="st_mp3_business_yn" id="st_mp3_business_yn"><span class="CheckMediumCustom"></span>엔투비</label>
                <label class="CheckMediumLabel"><input type="checkbox" name="st_mp4_business_yn" id="st_mp4_business_yn"><span class="CheckMediumCustom"></span>케이티커머스</label>
                <label class="CheckMediumLabel"><input type="checkbox" name="st_mp5_business_yn" id="st_mp5_business_yn"><span class="CheckMediumCustom"></span>행복나래</label>
              </td>
            </tr>                     
		  </table> 
          <div class="SubTitStep3">결제정보 </div>
		  <table class="TableThLTdL" width="100%">
            <colgroup>
              <col width="155px" />
              <col width="275px" />
              <col width="155px" />
              <col width="275px" />
              <col width="155px" />
              <col width="275px" />
            </colgroup>
            <tr>
              <th><span class="f2f7ff">*</span> 대금 지급조건</th>
              <td id="display_pay_terms"></td>
              <th><span class="f2f7ff">*</span> 세금계산서 발행조건</th>
              <td id="display_pay_type"></td>
              <th><span class="f2f7ff">*</span> 계좌정보</th>
              <td>
                <span id="display_bank_info"></span>
                <input class="input30" style="width:240px;display:none;" name="edit_bank_account_no" id="edit_bank_account_no" type="text" maxlength="30" />
                <input type="hidden" name="st_bank_account_no" id="st_bank_account_no" />
              </td>
            </tr>
            <tr>
              <th><span class="f2f7ff">*</span> 예금주</th>
              <td colspan="5" id="display_depositor"></td>
            </tr>
		  </table> 
          <div class="SubTitStep3">담당자 정보 </div>
		  <table class="TableThLTdL" width="100%">
            <colgroup>
              <col width="155px" />
              <col width="1125px" />
            </colgroup>
            <tr>
              <th><span class="F6495F">*</span> 관리자</th>
              <td>
                <input class="input30" style="width:150px" name="st_ac_emp_nm" id="st_ac_emp_nm" type="text" placeholder="담당자명"
                       data-validate="required|korean" />
                <input class="input30" style="width:150px" name="st_ac_emp_tel_full" id="st_ac_emp_tel_full" type="text" placeholder="전화번호"
                       data-validate="required|phone" />
                <input class="input30" style="width:150px" name="st_ac_emp_mobile_full" id="st_ac_emp_mobile_full" type="text" placeholder="휴대폰번호"
                       data-validate="required|mobile" />
                <input class="input30" style="width:150px" name="st_ac_emp_email1" id="st_ac_emp_email1" type="text" placeholder="이메일"
                       data-validate="required" /> @
                <input class="input30" style="width:150px" name="st_ac_emp_email2" id="st_ac_emp_email2" type="text"
                       data-validate="required" />
                <select name="st_ac_emp_email_domain" id="st_ac_emp_email_domain" class="Select" style="width:150px">
                  <option value="">직접입력</option>
                  <option value="naver.com">naver.com</option>
                  <option value="gmail.com">gmail.com</option>
                  <option value="daum.net">daum.net</option>
                </select>
              </td>
            </tr>
            <tr>
              <th><span class="F6495F">*</span> 영업담당</th>
              <td>
                <input class="input30" style="width:150px" name="st_gr_emp_nm" id="st_gr_emp_nm" type="text" placeholder="담당자명"
                       data-validate="required|korean" />
                <input class="input30" style="width:150px" name="st_gr_emp_tel_full" id="st_gr_emp_tel_full" type="text" placeholder="전화번호"
                       data-validate="required|phone" />
                <input class="input30" style="width:150px" name="st_gr_emp_mobile_full" id="st_gr_emp_mobile_full" type="text" placeholder="휴대폰번호"
                       data-validate="required|mobile" />
                <input class="input30" style="width:150px" name="st_gr_emp_email1" id="st_gr_emp_email1" type="text" placeholder="이메일"
                       data-validate="required" /> @
                <input class="input30" style="width:150px" name="st_gr_emp_email2" id="st_gr_emp_email2" type="text"
                       data-validate="required" />
                <select name="st_gr_emp_email_domain" id="st_gr_emp_email_domain" class="Select" style="width:150px">
                  <option value="">직접입력</option>
                  <option value="naver.com">naver.com</option>
                  <option value="gmail.com">gmail.com</option>
                  <option value="daum.net">daum.net</option>
                </select>
              </td>
            </tr>
            <!-- 출고담당 행 숨김 처리 -->
            <tr style="display:none">
              <th><!-- 임시 제거: 나중에 필수 항목으로 재추가 예정 <span class="F6495F">*</span> --> 출고담당</th>
              <td>
                <input class="input30" style="width:150px" name="st_ship_emp_nm" id="st_ship_emp_nm" type="text" placeholder="담당자명" />
                <input class="input30" style="width:150px" name="st_ship_emp_tel_full" id="st_ship_emp_tel_full" type="text" placeholder="전화번호" />
                <input class="input30" style="width:150px" name="st_ship_emp_mobile_full" id="st_ship_emp_mobile_full" type="text" placeholder="휴대폰번호" />
                <input class="input30" style="width:150px" name="st_ship_emp_email1" id="st_ship_emp_email1" type="text" placeholder="이메일" /> @
                <input class="input30" style="width:150px" name="st_ship_emp_email2" id="st_ship_emp_email2" type="text" />
                <select name="st_ship_emp_email_domain" id="st_ship_emp_email_domain" class="Select" style="width:150px">
                  <option value="">직접입력</option>
                  <option value="naver.com">naver.com</option>
                  <option value="gmail.com">gmail.com</option>
                  <option value="daum.net">daum.net</option>
                </select>
              </td>
            </tr>
            <tr>
              <th><span class="F6495F">*</span> 세금계산서 담당</th>
              <td>
                <input class="input30" style="width:150px" name="st_tax_emp_nm" id="st_tax_emp_nm" type="text" placeholder="담당자명"
                       data-validate="required|korean" />
                <input class="input30" style="width:150px" name="st_tax_emp_tel_full" id="st_tax_emp_tel_full" type="text" placeholder="전화번호"
                       data-validate="required|phone" />
                <input class="input30" style="width:150px" name="st_tax_emp_mobile_full" id="st_tax_emp_mobile_full" type="text" placeholder="휴대폰번호"
                       data-validate="required|mobile" />
                <input class="input30" style="width:150px" name="st_tax_emp_email1" id="st_tax_emp_email1" type="text" placeholder="이메일"
                       data-validate="required" /> @
                <input class="input30" style="width:150px" name="st_tax_emp_email2" id="st_tax_emp_email2" type="text"
                       data-validate="required" />
                <select name="st_tax_emp_email_domain" id="st_tax_emp_email_domain" class="Select" style="width:150px">
                  <option value="">직접입력</option>
                  <option value="naver.com">naver.com</option>
                  <option value="gmail.com">gmail.com</option>
                  <option value="daum.net">daum.net</option>
                </select>
              </td>
            </tr>                        
		  </table>          
          <div class="SubTitStep3">주요취급 품목 </div>
          <table class="TableThCTdL_ex" width="100%">
            <colgroup>
              <col width="100px" />
              <col width="390px" />
              <col width="390px" />
              <col width="200px" />
              <col width="200px" />
            </colgroup>
            <tr>
              <th colspan="2"><span class="F6495F">*</span>SG</th>
              <th>제조사</th>
              <th><span class="F6495F">*</span>유통레벨</th>
              <th>유통레벨 증빙 <p class="Smalltxt">(예.대리점권 계약서류)</p></th>
            </tr>
            <tr id="product_row_1" style="display:none">
              <td><p class="represent">대표품목</p></td>
              <td id="itmg_nm_1">-</td>
              <td id="itm_mk_nm_1">-</td>
              <td id="agency_yn_1">-</td>
              <td style="text-align:center"><button class="ButDarkGray_Small" id="file_btn_1">파일첨부</button></td>
            </tr>
            <tr id="product_row_2" style="display:none">
              <td></td>
              <td id="itmg_nm_2">-</td>
              <td id="itm_mk_nm_2">-</td>
              <td id="agency_yn_2">-</td>
              <td style="text-align:center"><button class="ButDarkGray_Small" id="file_btn_2">파일첨부</button></td>
            </tr>
            <tr id="product_row_3" style="display:none">
              <td></td>
              <td id="itmg_nm_3">-</td>
              <td id="itm_mk_nm_3">-</td>
              <td id="agency_yn_3">-</td>
              <td style="text-align:center"><button class="ButDarkGray_Small" id="file_btn_3">파일첨부</button></td>
            </tr>
            <tr id="product_row_4" style="display:none">
              <td></td>
              <td id="itmg_nm_4">-</td>
              <td id="itm_mk_nm_4">-</td>
              <td id="agency_yn_4">-</td>
              <td style="text-align:center"><button class="ButDarkGray_Small" id="file_btn_4">파일첨부</button></td>
            </tr>
            <tr id="product_row_5" style="display:none">
              <td></td>
              <td id="itmg_nm_5">-</td>
              <td id="itm_mk_nm_5">-</td>
              <td id="agency_yn_5">-</td>
              <td style="text-align:center"><button class="ButDarkGray_Small" id="file_btn_5">파일첨부</button></td>
            </tr>
            <tr id="product_row_6" style="display:none">
              <td></td>
              <td id="itmg_nm_6">-</td>
              <td id="itm_mk_nm_6">-</td>
              <td id="agency_yn_6">-</td>
              <td style="text-align:center"><button class="ButDarkGray_Small" id="file_btn_6">파일첨부</button></td>
            </tr>
            <tr id="product_row_7" style="display:none">
              <td></td>
              <td id="itmg_nm_7">-</td>
              <td id="itm_mk_nm_7">-</td>
              <td id="agency_yn_7">-</td>
              <td style="text-align:center"><button class="ButDarkGray_Small" id="file_btn_7">파일첨부</button></td>
            </tr>
            <tr id="product_row_8" style="display:none">
              <td></td>
              <td id="itmg_nm_8">-</td>
              <td id="itm_mk_nm_8">-</td>
              <td id="agency_yn_8">-</td>
              <td style="text-align:center"><button class="ButDarkGray_Small" id="file_btn_8">파일첨부</button></td>
            </tr>
            <tr id="product_row_9" style="display:none">
              <td></td>
              <td id="itmg_nm_9">-</td>
              <td id="itm_mk_nm_9">-</td>
              <td id="agency_yn_9">-</td>
              <td style="text-align:center"><button class="ButDarkGray_Small" id="file_btn_9">파일첨부</button></td>
            </tr>
            <tr id="product_row_10" style="display:none">
              <td></td>
              <td id="itmg_nm_10">-</td>
              <td id="itm_mk_nm_10">-</td>
              <td id="agency_yn_10">-</td>
              <td style="text-align:center"><button class="ButDarkGray_Small" id="file_btn_10">파일첨부</button></td>
            </tr>
		  </table>
          <div class="SubTitStep3">전자계약 체결 </div>
          <table class="TableThLTdL" width="100%">
            <colgroup>
              <col width="155px" />
              <col width="1125px" />
            </colgroup>
            <tr>
              <th><span class="F6495F">*</span> 체결 여부</th>
              <td>
                <input type="hidden" name="st_doc_id" id="st_doc_id" />
                <label class="RadioMediumLabel"><input type="radio" name="contract_yn" value="Y"><span class="RadioMediumTxt"></span>Y</label>
                <label class="RadioMediumLabel"><input type="radio" name="contract_yn" value="N"><span class="RadioMediumTxt"></span>N</label>
                <button class="ButDarkGray_Small" onclick="doAction('econtViewer'); return false;">전자계약 전문 보기</button>
              </td>
            </tr>
		  </table>
          <!-- 정보 수신 여부 섹션 숨김 처리 -->
          <div class="SubTitStep3" style="display:none">정보 수신 여부</div>
          <table class="TableThLTdL" width="100%" style="display:none">
            <colgroup>
              <col width="155px" />
              <col width="1125px" />
            </colgroup>
            <tr>
              <th><span class="F6495F">*</span> 알림 수신 여부</th>
              <td id="recv_type_container">
                <label class="CheckMediumLabel">
                  <input type="checkbox" name="recv_type_mail" id="recv_type_mail" value="Y">
                  <span class="CheckMediumCustom"></span>E-mail
                </label>
                <label class="CheckMediumLabel">
                  <input type="checkbox" name="recv_type_sms" id="recv_type_sms" value="Y">
                  <span class="CheckMediumCustom"></span>휴대폰 문자 메시지
                </label>
                <input type="hidden" name="st_mail_send_flag" id="st_mail_send_flag" />
                <input type="hidden" name="st_sms_recv_flag" id="st_sms_recv_flag" />
                <p class="Smalltxt"  style="float:right">원활한 업무 처리를 위해 알림 수신에 동의해 주세요.  수신 거부 시 견적의뢰나 발주 안내를 받으실 수 없습니다.</p>
              </td>
            </tr>
		  </table>
          <div class="h30"></div>
          <div class="ListBtnBoxcenter"><button class="ButPrimary_large" style="width:150px" id="saveButton">저장</button></div>
          <div class="h50"></div>
		</div><!-- containerSub 끝 -->
      </div> <!--padding-left:50px; 끝 -->
    </div><!--containerBoxSub-->







<%@ include file="/WEB-INF/views/common/include/sellerFooter_sub_v2.jsp" %>
</div><!-- warp 끝-->

</body>
</html>
