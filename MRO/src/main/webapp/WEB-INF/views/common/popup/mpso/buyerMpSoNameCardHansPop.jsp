<%--
**********************************************
* 메뉴 : 
* 화면 : 장바구니 > 명함 정보 입력 팝업
* 기능 : 한샘 명함 정보 입력 팝업
* 프로그램 ID :
* 담당자 : 2239067
* 착수일 : 2025-02-06
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css"
	type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js"
	type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js"
	type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
</head>
<%
@SuppressWarnings (value="unchecked")
Map<String,String> _dataList = (Map<String,String>) request.getAttribute("data"); 
Map<String,String> user_data = (Map<String,String>) request.getAttribute("user_data"); 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode());
String st_user_id =  CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId());
String st_seq = CommonUtil.nvl((String) request.getParameter("st_seq"),"");
String st_address = CommonUtil.nvl((String) request.getParameter("param_text"),"");
String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"");
%>
<script type="text/javascript">

const now_type = "<%=st_type%>";
const view_option = {
		// 본사 임직원(국문)
		'HANS_1' : {
			'st_name' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'lang_flg' : true, // true : 국문, false : 영문
			},
			'st_position' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'pop_code_map' : {
					'POST' : 'POST', // 직책
					'LEVL' : 'LEVL', // 직급
				},
				'dynamic_pop_flg' : true,
				'dynamic_pop_source' : 'st_position_column_name',
				'default_position_type' : '',
				'hint_text' : '선택하여 입력',
				'empty_alert_flg' : true,
				'empty_alert_text' : '※ 직책자 → 직책 선택 필수 / 비직책자 → 직급 선택 필수',
				'select_change_alert_flg' : false,
				'select_change_alert_text' : '',
				'change_alert_map' : {
					'POST->LEVL' : '직책자는 직책을 선택해주세요.',
				},
			},
			'st_division' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'pop_code' : 'DIVI', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
				'hint_text' : '선택하여 입력',
			},
			'st_department' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'pop_code' : 'TEAM', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
				'hint_text' : '선택하여 입력',
			},
			'st_phone_no' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : false,
				'fix_text' : null,
				'hint_text' : '02 0000 0000 형식으로 입력',
				'auto_conv_flg' : /[-–—]+/g,
				'auto_conv_text' : ' ',
			},
			'st_mobile_no' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : '010 0000 0000 형식으로 입력',
				'auto_conv_flg' : /[-–—]+/g,
				'auto_conv_text' : ' ',
			},
			'st_email' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
			},
			'st_address' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'pre_fix'  : '',
				'hint_text' : '선택하여 입력',
				'pop_code' : 'ADDR', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
			},
			'st_url' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : 'www.hanssem.com',
			},
		},
		// SC명함 (국문)
		'HANS_3' : {
			'st_name' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'lang_flg' : true, // true : 국문, false : 영문
			},
			'st_position' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'pop_code_map' : {
					'POST' : 'POST',
					'LEVL' : 'LEVL',
				},
				'dynamic_pop_flg' : true,
				'dynamic_pop_source' : 'st_position_column_name',
				'default_position_type' : '',
				'hint_text' : '선택하여 입력',
				'empty_alert_flg' : true,
				'empty_alert_text' : '※ 직책자 → 직책 선택 필수 / 비직책자 → 직급 선택 필수',
				'select_change_alert_flg' : false,
				'select_change_alert_text' : '',
				'change_alert_map' : {
					'POST->LEVL' : '직책자는 직책을 선택해주세요.',
				},
			},
			'st_division' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : '한샘홈퍼니싱 디자이너',
			},
			'st_department' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'col_change_before' : '팀명',
				'col_change_after' : '매장명',
				'hint_text' : '선택하여 입력',
				'pop_code' : 'HSBR', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
			},
			'st_phone_no' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : false,
				'fix_text' : null,
				'hint_text' : '02 0000 0000 형식으로 입력',
				'auto_conv_flg' : /[-–—]+/g,
				'auto_conv_text' : ' ',
			},
			'st_mobile_no' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : '010 0000 0000 형식으로 입력',
				'auto_conv_flg' : /[-–—]+/g,
				'auto_conv_text' : ' ',
			},
			'st_email' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
			},
			'st_address' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : '선택하여 입력',
				'pop_code' : 'ADDR', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
			},
			'st_url' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : 'www.hanssem.com',
			},
		},
		// SC스티커
		'HANS_5' : {
			'st_name' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'lang_flg' : true, // true : 국문, false : 영문
			},
			'st_position' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'pop_code_map' : {
					'POST' : 'POST',
					'LEVL' : 'LEVL',
				},
				'dynamic_pop_flg' : true,
				'dynamic_pop_source' : 'st_position_column_name',
				'default_position_type' : '',
				'hint_text' : '선택하여 입력',
				'empty_alert_flg' : true,
				'empty_alert_text' : '※ 직책자 → 직책 선택 필수 / 비직책자 → 직급 선택 필수',
				'select_change_alert_flg' : false,
				'select_change_alert_text' : '',
				'change_alert_map' : {
					'POST->LEVL' : '직책자는 직책을 선택해주세요.',
				},
			},
			'st_division' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : '한샘홈퍼니싱 디자이너',
			},
			'st_department' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'col_change_before' : '팀명',
				'col_change_after' : '매장명',
				'hint_text' : '선택하여 입력',
				'pop_code' : 'HSBR', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
			},
			'st_phone_no' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : false,
				'fix_text' : null,
				'hint_text' : '02 0000 0000 형식으로 입력',
				'auto_conv_flg' : /[-–—]+/g,
				'auto_conv_text' : ' ',
			},
			'st_mobile_no' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : '010 0000 0000 형식으로 입력',
				'auto_conv_flg' : /[-–—]+/g,
				'auto_conv_text' : ' ',
			},
			'st_email' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
			},
			'st_address' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : '선택하여 입력',
				'pop_code' : 'ADDR', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
			},
			'st_url' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : 'www.hanssem.com',
			},
		},
		// TR명함(국문) 
		'HANS_6' : {
			'st_name' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'lang_flg' : true, // true : 국문, false : 영문
			},
			'st_position' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : false,
				'fix_text' : null,
				'pop_code_map' : {
					'POST' : 'POST',
					'LEVL' : 'LEVL',
				},
				'dynamic_pop_flg' : true,
				'dynamic_pop_source' : 'st_position_column_name',
				'default_position_type' : '',
				'hint_text' : '선택하여 입력',
				'empty_alert_flg' : true,
				'empty_alert_text' : '※ 직책자 → 직책 선택 필수 / 비직책자 → 직급 선택 필수',
				'select_change_alert_flg' : false,
				'select_change_alert_text' : '',
				'change_alert_map' : {
					'POST->LEVL' : '직책자는 직책을 선택해주세요.',
				},
			},
			'st_department' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'pop_code' : 'TEAM', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
				'hint_text' : '선택하여 입력',
			},
			'st_division' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : false,
				'fix_text' : null,
				'hint_text' : '선택하여 입력',
				'pop_code' : 'DIVI', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
			},
			'st_phone_no' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : false,
				'fix_text' : null,
				'hint_text' : '02 0000 0000 형식으로 입력',
				'auto_conv_flg' : /[-–—]+/g,
				'auto_conv_text' : ' ',
			},
			'st_mobile_no' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : '010 0000 0000 형식으로 입력',
				'auto_conv_flg' : /[-–—]+/g,
				'auto_conv_text' : ' ',
			},
			'st_email' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
			},
			'st_address' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : '선택하여 입력',
				'pop_code' : 'ADDR', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
			},
			'st_url' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : 'www.hanssem.com',
			},
		},
		// TR스티커
		'HANS_8' : {
			'st_name' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'lang_flg' : true, // true : 국문, false : 영문
			},
			'st_position' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : false,
				'fix_text' : null,
				'pop_code_map' : {
					'POST' : 'POST',
					'LEVL' : 'LEVL',
				},
				'dynamic_pop_flg' : true,
				'dynamic_pop_source' : 'st_position_column_name',
				'default_position_type' : '',
				'hint_text' : '선택하여 입력',
				'empty_alert_flg' : true,
				'empty_alert_text' : '※ 직책자 → 직책 선택 필수 / 비직책자 → 직급 선택 필수',
				'select_change_alert_flg' : false,
				'select_change_alert_text' : '',
				'change_alert_map' : {
					'POST->LEVL' : '직책자는 직책을 선택해주세요.',
				},
			},
			'st_department' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'pop_code' : 'TEAM', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
				'hint_text' : '선택하여 입력',
			},
			'st_division' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : false,
				'fix_text' : null,
				'hint_text' : '선택하여 입력',
				'pop_code' : 'DIVI', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
			},
			'st_phone_no' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : false,
				'fix_text' : null,
				'hint_text' : '02 0000 0000 형식으로 입력',
				'auto_conv_flg' : /[-–—]+/g,
				'auto_conv_text' : ' ',
			},
			'st_mobile_no' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : '010 0000 0000 형식으로 입력',
				'auto_conv_flg' : /[-–—]+/g,
				'auto_conv_text' : ' ',
			},
			'st_email' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
			},
			'st_address' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : '선택하여 입력',
				'pop_code' : 'ADDR', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
			},
			'st_url' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : 'www.hanssem.com',
			},
		},
		// 한샘개발
		'HAND' : {
			'st_name' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
			},
			'st_position' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
			},
			'st_department' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'pop_code' : 'TEAM', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
				'hint_text' : '선택하여 입력',
			},
			'st_division' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
			},
			'st_phone_no' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
			},
			'st_mobile_no' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
			},
			'st_email' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
			},
			'st_address' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : '서울시 관악구 신림로 318, 7층',
			},
			'st_url' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
			},
		},
	};

const now_view_option = view_option[now_type];
const user_view_info = {
		'st_name' : "<%=CommonUtil.nvl(user_data.get("USER_NAME_LOC"))%>",
		'st_name_eng' : "<%=CommonUtil.nvl(user_data.get("USER_NAME_ENG"))%>",
		'st_position' : "<%=CommonUtil.nvl(user_data.get("POSITION"))%>",
		'st_department' : "<%=CommonUtil.nvl(user_data.get("DEPARTMENT"))%>",
		'st_division' : "",
		'st_phone_no' : "<%=CommonUtil.nvl(user_data.get("PHONE_NUMBER"))%>",
		'st_mobile_no' : "<%=CommonUtil.nvl(user_data.get("MOBILE_PHONE"))%>",
		'st_email' : "<%=CommonUtil.nvl(user_data.get("EMAIL"))%>",
		'st_address' : "<%=CommonUtil.nvl(user_data.get("DELY_TO_LOCATION"))%>",
	};

let nowPopUpTarget = null;
var popupSel = "";
function kep_onload(){

	initDynamicPopupControls();

	if(!isEmpty(now_view_option)){
		// 옵션에 따라 먼저 동작
		Object.entries(now_view_option).forEach(([key, value]) => {
			let target = document.getElementById(key);
			if(!target) return;
	
			// 필수 옵션 통제 
			let nowColumnName = null;
			let prevSiblingOfParent = target.parentElement.previousElementSibling;
			if (prevSiblingOfParent && prevSiblingOfParent.firstElementChild) {
				const nodes = prevSiblingOfParent.childNodes;
				nodes.forEach((node) => {
					if (node.nodeType === Node.TEXT_NODE) {
						// 컬럼명 변경처리
						if(!isEmpty(value.col_change_after) && !isEmpty(value.col_change_before)){
							node.textContent = node.textContent.replace(value.col_change_before, value.col_change_after);
						}
						nowColumnName = safeTrim(node.textContent);
					}
				});
	
				if(value.require_flg){
				}else{
					prevSiblingOfParent.firstElementChild.remove();
				}
	
			}
			
			// 수정가능여부 통제
			if(value.update_flg){
			}else{
				target.readOnly = true;
			}
			
			// 자동기입요소 통제
			if(value.auto_flg){
				let auto_value = '';
	
				// 성명의 경우 국문/영문 구분 필요
				if(key == 'st_name'){
					target_name = value.lang_flg ? "<%=CommonUtil.nvl(user_data.get("USER_NAME_LOC"))%>" : "<%=CommonUtil.nvl(user_data.get("USER_NAME_ENG"))%>";
					auto_value = target_name;
				}else{
					auto_value = user_view_info[key];
				}
				
				// 변환 flg가 존재한다면
				if(!isEmpty(value.auto_conv_flg)){
					auto_value = removeParentheses(auto_value, value.auto_conv_flg, value.auto_conv_text??'')
				}
				target.value = (value.pre_fix ?? "") + auto_value;
			}
	
			// 고정형 문구가 설정되어있는 경우 변경
			if(!isEmpty(value.fix_text)){
				target.value = value.fix_text;
			}
			
			// 비표시용 flg가 설정되어있다면 비표시 적용
			if(!isEmpty(value.blind_flg) && value.blind_flg){
				prevSiblingOfParent.style = 'display: none';
				target.style = 'display: none';
			}
			
			// 팝업 호출 코드가 존재한다면
			bindPopupEvent(target, key, value, nowColumnName);
			
			// 힌트 기입이 존재한다면 추가
			if(!isEmpty(value.hint_text)){
				target.placeholder = value.hint_text;
			}
	
		});
	}
<%	
	if(_dataList != null && _dataList.size() > 0){
%>
		var st_remark = "<%=CommonUtil.nvl(_dataList.get("CART_REMARK"))%>";
		var remark_arr = st_remark.split(";");
		if(remark_arr.length == 9){
			for(var i=0; i<remark_arr.length; i++){
				if(i == 0){ // 성함
					document.forms.contentForm.st_name.value = remark_arr[i];
				}else if(i == 1){ // 직급
					document.forms.contentForm.st_position.value = remark_arr[i];
				}else if(i == 2){ // 부서
					document.forms.contentForm.st_division.value = remark_arr[i];
				}else if(i == 3){ // 팀명
					document.forms.contentForm.st_department.value = remark_arr[i];
				}else if(i == 4){ // 전화번호
					document.forms.contentForm.st_phone_no.value = remark_arr[i];
				}else if(i == 5){ // 휴대폰번호
					document.forms.contentForm.st_mobile_no.value = remark_arr[i];
				}else if(i == 6){ // 메일주소
					document.forms.contentForm.st_email.value = remark_arr[i];
				}else if(i == 7){ // 주소
					document.forms.contentForm.st_address.value = remark_arr[i];
				}else if(i == 8){ // 사이트주소
					document.forms.contentForm.st_url.value = remark_arr[i];
				}
			}
		}else if(remark_arr.length != 1){
			alert("<%=CommonLang.msg("MSG435")%>"); // 명함정보가 올바르지 않습니다. KEP관리자에게 문의해주시기 바랍니다.
			this.close();
			return;
		}
<%
	}
%>
	resolveSavedPositionType('NCIF', now_view_option.st_position.pop_code_map);
}

function initDynamicPopupControls(){
	Object.entries(now_view_option ?? {}).forEach(([key, value]) => {
		if(!value.dynamic_pop_flg) return;

		const sourceTarget = document.getElementById(value.dynamic_pop_source);
		const fieldTarget = document.getElementById(key);
		if(!sourceTarget) return;

		if(Object.prototype.hasOwnProperty.call(value, 'default_position_type')){
			sourceTarget.value = value.default_position_type;
		}

		let prevValue = sourceTarget.value;

		sourceTarget.addEventListener('change', function(){
			const currentValue = this.value;
			const changeKey = prevValue + '->' + currentValue;

			if(fieldTarget){
				fieldTarget.value = '';
			}

			if(value.select_change_alert_flg && !isEmpty(currentValue) && !isEmpty(value.select_change_alert_text)){
				alert(value.select_change_alert_text);
			}

			if(!isEmpty(value.change_alert_map) && !isEmpty(value.change_alert_map[changeKey])){
				alert(value.change_alert_map[changeKey]);
			}

			prevValue = currentValue;
		});
	});
}

function bindPopupEvent(target, key, value, defaultColumnName){
	if(!target || isEmpty(value)) return;

	if(!isEmpty(value.dynamic_pop_flg) && value.dynamic_pop_flg){
		target.addEventListener('click', function(){
			const sourceId = value.dynamic_pop_source;
			const sourceTarget = document.getElementById(sourceId);

			if(!sourceTarget || isEmpty(sourceTarget.value)){
				if(value.empty_alert_flg && !isEmpty(value.empty_alert_text)){
					alert(value.empty_alert_text);
				}
				return;
			}

			const dynamicColumnName = getDynamicColumnName(value, defaultColumnName);
			const dynamicPopCode = getDynamicPopCode(value);

			if(isEmpty(dynamicPopCode)){
				alert("팝업 호출 코드가 올바르지 않습니다.");
				return;
			}

			doPop(dynamicColumnName, dynamicPopCode, key);
		});
	}else if(!isEmpty(value.pop_code)){
		target.addEventListener('click', function(){
			doPop(defaultColumnName, value.pop_code, key);
		});
	}
}

function getDynamicPopCode(option){
	if(isEmpty(option) || isEmpty(option.pop_code_map)) return null;

	const sourceId = option.dynamic_pop_source;
	if(isEmpty(sourceId)) return null;

	const sourceTarget = document.getElementById(sourceId);
	if(!sourceTarget) return null;

	return option.pop_code_map[sourceTarget.value] ?? null;
}

function getDynamicColumnName(option, defaultName){
	if(isEmpty(option)) return defaultName ?? '';

	const sourceId = option.dynamic_pop_source;
	if(isEmpty(sourceId)) return defaultName ?? '';

	const sourceTarget = document.getElementById(sourceId);
	if(!sourceTarget) return defaultName ?? '';

	if(sourceTarget.tagName == 'SELECT'){
		const selectedIndex = sourceTarget.selectedIndex;
		if(selectedIndex >= 0){
			if(isEmpty(sourceTarget.value)){
				return '';
			}
			return safeTrim(sourceTarget.options[selectedIndex].text);
		}
	}

	return defaultName ?? '';
}

function setReturn(){
	var st_name = document.forms.contentForm.st_name.value; // 성함
	var st_position = document.forms.contentForm.st_position.value; // 직급/직책
	var st_department = document.forms.contentForm.st_department.value; // 부서
	var st_division = document.forms.contentForm.st_division.value; // 팀명 OR 매장명
	var st_phone_no = document.forms.contentForm.st_phone_no.value; // 전화번호
	var st_mobile_no = document.forms.contentForm.st_mobile_no.value; // 휴대폰번호
	var st_email = document.forms.contentForm.st_email.value; // 메일주소
	var st_address = document.forms.contentForm.st_address.value; // 주소
	var st_url = document.forms.contentForm.st_url.value; // 사이트주소

	let break_flg = false;
	if(!isEmpty(now_view_option)){
		Object.entries(now_view_option).some(([key, value]) => {
			// 필수 값 체크 
			if(!isEmpty(value.require_flg) && value.require_flg){
				if(isEmpty(document.getElementById(key).value)){
					alert("* 표시된 필수 명함정보를 모두 입력하여 주십시오.");
					break_flg = true;
					return true;
				}
			}
			// 전화번호, 휴대폰번호 양식 체크 
			if(key == 'st_phone_no' || key == 'st_mobile_no'){
				let target_text = '휴대폰';
				if(key == 'st_phone_no') target_text = '전화번호'
				if(!isEmpty(document.getElementById(key).value) && !isValidPhoneNumber(document.getElementById(key).value, key)){
					alert(target_text + " 양식에 문제가 있습니다. 내용 확인 후 입력 바랍니다.");
					break_flg = true;
					return true;
				}
			}
		});
	}
	if(break_flg) return;

	remark	=	st_name + ";"
			+	st_position + ";"
			+	st_division + ";"
			+	st_department + ";"
			+	st_phone_no + ";"
			+	st_mobile_no + ";"
			+	st_email + ";"
			+	st_address + ";"
			+	st_url	;

	document.forms.searchCondition.st_remark.value = remark;
	kepAjaxFormCall("/mpso/saveBuyerMpSoCartRemarkNameCard.do","searchCondition","");
}

function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	var remark = document.forms.searchCondition.st_remark.value;
	
	if (!isEmpty(msg)){
		alert("명함정보가 정상적으로 저장되었습니다.");
		opener.setPopupReturn(remark);
		this.close();	
	}
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
		alert(msg);
	}
	return;
}

function isValidPhoneNumber(input, key) {
	// 정규식 설명:
	// ^ 시작
	// (02|0\d{2}) => 지역번호: 02 또는 010~099 형식
	// - 하이픈
	// \s 공백스페이스 1개
	// \d{3,4} => 중간번호는 3~4자리
	// -
	// \d{4} => 끝번호는 4자리
	// $ 끝
	let pattern = null;
	let result = true;
	if(now_type == 'HAND'){
		pattern = /^(02|0\d{2})-\d{3,4}-\d{4}$/;
		result = pattern.test(input);
	}else if(now_type.includes('HANS')){
		if(key == 'st_phone_no'){
			pattern = /^(02|0\d{2})\s\d{3,4}\s\d{4}$/;
		}else{
			pattern = /^(02|0\d{2})\s\d{4}\s\d{4}$/;
		}
		result = pattern.test(input);
	}
	return result;
}

function safeTrim(value) {
	if (typeof value === 'string') {
		return value.trim();
	}
	return value; // 문자열이 아니면 그대로 반환
}

function removeParentheses(text, regex, next = '') {
	if (typeof text !== 'string') return '';
	return text.replace(regex, next);
}

//팝업함수호출
function doPop(str, code, target, width='500', height='450', type = 'NCIF'){
	popupSel = str;
	nowPopUpTarget = target;
	var st_buyer = "<%=st_buyer%>";
	var st_type = type;
	var st_gbn = str;
	var st_code1 = code;
	openSearchPopup("/common/getCode4PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code1="+st_code1, width + "," + height + ",no");
}

function setPopupReturn(value1,value2,value3,value4,value5,value6){
	document.getElementById(nowPopUpTarget).value = value1;
}

function resolveSavedPositionType(type = 'NCIF', codeArray = {}){
	var positionValue = document.getElementById('st_position').value;
	const codeArrayValues = Object.values(codeArray)
	const codeArrayStr = codeArrayValues.join(',');
	if(isEmpty(positionValue)) return;

	$.ajax({
		url : '/mpso/getNameCardPositionType.do',
		type : 'POST',
		dataType : 'json',
		data : {
			st_buyer : '<%=st_buyer%>',
			st_position : positionValue,
			type : 'NCIF',
			code1Csv : codeArrayStr
		},
		success : function(response){
			var positionColumnName = '';
			if(response.result == 'success'){
				positionColumnName = response.columnInfo.CODE1 || '';
			}

			if(codeArrayValues.includes(positionColumnName)){
				$('#st_position_column_name').val(positionColumnName).trigger('change');
			}
		},
		error : function(){
			console.log('POST,LEVL 자동판별 API 호출 실패');
		}
	});
}


</script>
<body onload="kep_onload()">
	<form id="searchCondition" name="searchCondition" method="post"
		onsubmit="return false">
		<input type="hidden" id="st_buyer" name="st_buyer"
			value="<%=st_buyer%>" /> <input type="hidden" name="st_user_id"
			id="st_user_id" value="<%=st_user_id%>"> <input type="hidden"
			name="st_seq" id="st_seq" value="<%=st_seq%>"> <input
			type="hidden" name="st_remark" id="st_remark" value="">
	</form>
	<form name="contentForm" id="contentForm" method=post>
		<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
		<div id="popWrapper">
			<div id="popHeader">
				<h1 class="title">명함 정보 입력</h1>
				<p class="popClose">
					<a href="javascript:self.close()"><img
						src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a>
				</p>
			</div>

			<!--팝업내용입니다-->
			<div id="popContainer">
				<div>
					<span style="color: red;">※인사정보와 다른 소속/직급 신청은 사전 협조전 및 완료 협조전 첨부 필수</span>
				</div>
				<div id="searchBtnA02"></div>

				<!--조회영역-->
				<div id="cont_searchA">
					<table class="cont_t_list01" style="width: 100%">
						<tr>
							<th scope="col" width="100px"><font color="#FF6600">*</font>
								성함</th>
							<td width="180px"><input type="text" name="st_name"
								id="st_name" value="" style="width: 90%"></td>
							<th scope="col" width="100px">
								<font color="#FF6600">*</font>
								<select name="st_position_column_name" id="st_position_column_name" style="width: 80%">
									<option value="">선택</option>
									<option value="LEVL">직급</option>
									<option value="POST">직책</option>
								</select>
							</th>
							<td><input type="text" name="st_position" id="st_position"
								value="" style="width: 90%"></td>
						</tr>

						<tr>
							<th scope="col" width="100px"><font color="#FF6600">*</font>
								부서</th>
							<td><input type="text" name="st_division" id="st_division" value=""
								style="width: 90%"></td>
							<th scope="col" width="100px"><font color="#FF6600">*</font>
								팀명</th>
							<td width="180px"><input type="text" name="st_department"
								id="st_department" value="" style="width: 90%"></td>
						</tr>
						<tr>
							<th scope="col " width="100px"><font color="#FF6600">*</font>
								전화번호</th>
							<td width="180px"><input type="text" name="st_phone_no"
								id="st_phone_no" value="" style="width: 90%"
								placeholder="02-0000-0000 형식으로 입력"></td>
							<th scope="col" width="100px"><font color="#FF6600">*</font>
								휴대폰번호</th>
							<td><input type="text" name="st_mobile_no" id="st_mobile_no"
								value="" style="width: 90%" placeholder="010-0000-0000 형식으로 입력"></td>
						</tr>

						<tr>
							<th scope="col" width="100px"><font color="#FF6600">*</font>
								메일주소</th>
							<td><input type="text" name="st_email" id="st_email"
								value="" style="width: 90%"
								placeholder="hanssem@hanssem.com 형식으로 입력"></td>
							<th scope="col" width="100px"><font color="#FF6600">*</font>
								주소</th>
							<td><input type="text" name="st_address" id="st_address"
								value="" style="width: 90%"></td>
						</tr>

						<tr>
							<th scope="col" width="100px"></th>
							<td></td>
							<th scope="col" width="100px"><font color="#FF6600">*</font>
								사이트주소</th>
							<td colspan="3"><input type="text" name="st_url" id="st_url"
								value="www.hanssem.com" style="width: 90%"></td>
						</tr>
					</table>
				</div>

				<!--버튼영역-->
				<div class="btnArea">
					<span class="fr"> <span class="btn_02 mr02" title="확인">
							<a href="javascript:setReturn();">확인</a>
					</span>
					</span>
				</div>
			</div>
		</div>
	</form>
</body>
</html>
