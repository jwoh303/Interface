<%--
**********************************************
* 메뉴 : 
* 화면 : 장바구니 > 명함 정보 입력 팝업
* 기능 : 한샘 명함 정보 입력 팝업
* 프로그램 ID :
* 담당자 : 최찬규
* 착수일 : 2025-05-26
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
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>

<%
@SuppressWarnings (value="unchecked")
Map<String,String> _dataList = (Map<String,String>) request.getAttribute("data"); 
Map<String,String> user_data = (Map<String,String>) request.getAttribute("user_data"); 
SessionInfo _sessionInfoPop = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfoPop.getComCode());
String st_user_id =  CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfoPop.getUserId());
String st_seq = CommonUtil.nvl((String) request.getParameter("st_seq"),"");
String st_address = CommonUtil.nvl((String) request.getParameter("param_text"),"");
String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"");
%>
<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

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
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
				'empty_alert_flg' : true,
				'empty_alert_text' : '<%=CommonLang.get("HTITLE1410")%>', //※ 직책자 → 직책 선택 필수 / 비직책자 → 직급 선택 필수
				'select_change_alert_flg' : false,
				'select_change_alert_text' : '',
				'change_alert_map' : {
					'POST->LEVL' : '<%=CommonLang.msg("MSG872")%>', //직책자는 직책을 선택해주세요.
				},
			},
			'st_division' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'pop_code' : 'DIVI', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
			},
			'st_department' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'pop_code' : 'TEAM', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
			},
			'st_phone_no' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : false,
				'fix_text' : null,
				'hint_text' : '02 0000 0000 <%=CommonLang.get("HTITLE1411")%>', //형식으로 입력
				'auto_conv_flg' : /[-–—]+/g,
				'auto_conv_text' : ' ',
			},
			'st_mobile_no' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : '010 0000 0000 <%=CommonLang.get("HTITLE1411")%>', //형식으로 입력
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
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
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
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
				'empty_alert_flg' : true,
				'empty_alert_text' : '<%=CommonLang.get("HTITLE1410")%>', //※ 직책자 → 직책 선택 필수 / 비직책자 → 직급 선택 필수
				'select_change_alert_flg' : false,
				'select_change_alert_text' : '',
				'change_alert_map' : {
					'POST->LEVL' : '<%=CommonLang.msg("MSG872")%>', //직책자는 직책을 선택해주세요.
				},
			},
			'st_division' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : '<%=CommonLang.get("HTITLE1412")%>', //한샘홈퍼니싱 디자이너
			},
			'st_department' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'col_change_before' : '<%=CommonLang.get("HTITLE1395")%>', //팀명
				'col_change_after' : '<%=CommonLang.get("HTITLE1413")%>', //매장명
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
				'pop_code' : 'HSBR', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
			},
			'st_phone_no' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : false,
				'fix_text' : null,
				'hint_text' : '02 0000 0000 <%=CommonLang.get("HTITLE1411")%>', //형식으로 입력
				'auto_conv_flg' : /[-–—]+/g,
				'auto_conv_text' : ' ',
			},
			'st_mobile_no' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : '010 0000 0000 <%=CommonLang.get("HTITLE1411")%>', //형식으로 입력
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
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
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
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
				'empty_alert_flg' : true,
				'empty_alert_text' : '<%=CommonLang.get("HTITLE1410")%>', //※ 직책자 → 직책 선택 필수 / 비직책자 → 직급 선택 필수
				'select_change_alert_flg' : false,
				'select_change_alert_text' : '',
				'change_alert_map' : {
					'POST->LEVL' : '<%=CommonLang.msg("MSG872")%>', //직책자는 직책을 선택해주세요.
				},
			},
			'st_division' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : '<%=CommonLang.get("HTITLE1412")%>',//한샘홈퍼니싱 디자이너
			},
			'st_department' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'col_change_before' : '<%=CommonLang.get("HTITLE1395")%>',//팀명
				'col_change_after' : '<%=CommonLang.get("HTITLE1413")%>',//매장명
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
				'pop_code' : 'HSBR', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
			},
			'st_phone_no' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : false,
				'fix_text' : null,
				'hint_text' : '02 0000 0000 <%=CommonLang.get("HTITLE1411")%>', //형식으로 입력
				'auto_conv_flg' : /[-–—]+/g,
				'auto_conv_text' : ' ',
			},
			'st_mobile_no' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : '010 0000 0000 <%=CommonLang.get("HTITLE1411")%>', //형식으로 입력
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
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
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
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
				'empty_alert_flg' : true,
				'empty_alert_text' : '<%=CommonLang.get("HTITLE1410")%>', //※ 직책자 → 직책 선택 필수 / 비직책자 → 직급 선택 필수
				'select_change_alert_flg' : false,
				'select_change_alert_text' : '',
				'change_alert_map' : {
					'POST->LEVL' : '<%=CommonLang.msg("MSG872")%>', //직책자는 직책을 선택해주세요.
				},
			},
			'st_department' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'pop_code' : 'TEAM', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
			},
			'st_division' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : false,
				'fix_text' : null,
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
				'pop_code' : 'DIVI', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
			},
			'st_phone_no' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : false,
				'fix_text' : null,
				'hint_text' : '02 0000 0000 <%=CommonLang.get("HTITLE1411")%>', //형식으로 입력
				'auto_conv_flg' : /[-–—]+/g,
				'auto_conv_text' : ' ',
			},
			'st_mobile_no' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : '010 0000 0000 <%=CommonLang.get("HTITLE1411")%>', //형식으로 입력
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
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
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
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
				'empty_alert_flg' : true,
				'empty_alert_text' : '<%=CommonLang.get("HTITLE1410")%>', //※ 직책자 → 직책 선택 필수 / 비직책자 → 직급 선택 필수
				'select_change_alert_flg' : false,
				'select_change_alert_text' : '',
				'change_alert_map' : {
					'POST->LEVL' : '<%=CommonLang.msg("MSG872")%>', //직책자는 직책을 선택해주세요.
				},
			},
			'st_department' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'pop_code' : 'TEAM', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
			},
			'st_division' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : false,
				'fix_text' : null,
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
				'pop_code' : 'DIVI', // 직급 : LEVL, 본부 : DIVI, 주소 : ADDR
			},
			'st_phone_no' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : false,
				'fix_text' : null,
				'hint_text' : '02 0000 0000 <%=CommonLang.get("HTITLE1411")%>', //형식으로 입력
				'auto_conv_flg' : /[-–—]+/g,
				'auto_conv_text' : ' ',
			},
			'st_mobile_no' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : '010 0000 0000 <%=CommonLang.get("HTITLE1411")%>', //형식으로 입력
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
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
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
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
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
				'fix_text' : '<%=CommonLang.get("HTITLE1414")%>', //서울시 관악구 신림로 318, 7층
			},
			'st_url' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
			},
		},
		// 도무스 매니저 명함 (한샘 신규조직) - 아래 tblHansOrg 테이블을 쓰는 유형이라 필드 id가 st_org_* 로 다름
		'HANS_9' : {
			'st_org_name' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
			},
			'st_org_name_eng' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : 'Domus Kim', // 작성 예시만 안내하고 자율 기재
			},
			// 도무스는 직급/영문직급이 전 인원 공통이라 고정값으로 박고 수정 못하게 한다
			'st_org_position' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : '<%=CommonLang.get("HTITLE1536")%>', //매니저
			},
			'st_org_position_eng' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : 'Store Manager',
			},
			// 매장을 고르면 코드팝업이 같이 내려주는 TEXT2(주소)가 st_org_address 에 자동으로 들어간다
			'st_org_store' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'pop_code' : 'DMBR', // 도무스 매장
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
				'link_map' : {
					'st_org_address' : 2, // TEXT2 = 매장 주소
				},
			},
			'st_org_phone_no' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : false,
				'fix_text' : null,
				'hint_text' : '02 0000 0000 <%=CommonLang.get("HTITLE1411")%>', //형식으로 입력
			},
			'st_org_mobile_no' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : '010 0000 0000 <%=CommonLang.get("HTITLE1411")%>', //형식으로 입력
				'auto_conv_flg' : /[-–—]+/g,
				'auto_conv_text' : ' ',
				'valid_pattern' : /^(02|0\d{2})\s\d{4}\s\d{4}$/,
			},
			'st_org_email' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
			},
			'st_org_address' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'hint_text' : '<%=CommonLang.get("HTITLE1537")%>', //매장 선택시 자동입력
				'fix_text' : null,
			},
			'st_org_url' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : 'domus-official.com',
			},
		},
		// 넥서스 플래그십 명함 (한샘 신규조직)
		'HANS_10' : {
			'st_org_name' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
			},
			'st_org_name_eng' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : 'Nexus Kim', // 작성 예시만 안내하고 자율 기재
			},
			// 국문직급을 고르면 코드팝업이 같이 내려주는 TEXT2(영문직급)가 자동으로 들어간다
			'st_org_position' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'pop_code' : 'NXLV', // 넥서스 직급
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
				'link_map' : {
					'st_org_position_eng' : 2, // TEXT2 = 영문직급
				},
			},
			'st_org_position_eng' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
			},
			// 넥서스는 매장명 항목이 없다(도무스만 매장 선택이 있음).
			// 주소를 고르면 내선번호까지 자동으로 채워지지만, 개인 직통번호가 따로 있으면 고칠 수 있게 열어둔다.
			// 자동값이 대표번호(1670-1950)/하이픈 형식이라 형식검증(valid_pattern)은 일부러 걸지 않는다.
			'st_org_phone_no' : {
				'auto_flg' : false,
				'update_flg' : true,
				'require_flg' : false,
				'fix_text' : null,
				'hint_text' : '02 0000 0000 <%=CommonLang.get("HTITLE1411")%>', //형식으로 입력
			},
			'st_org_mobile_no' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
				'hint_text' : '010 0000 0000 <%=CommonLang.get("HTITLE1411")%>', //형식으로 입력
				'auto_conv_flg' : /[-–—]+/g,
				'auto_conv_text' : ' ',
				'valid_pattern' : /^(02|0\d{2})\s\d{4}\s\d{4}$/,
			},
			'st_org_email' : {
				'auto_flg' : true,
				'update_flg' : true,
				'require_flg' : true,
				'fix_text' : null,
			},
			'st_org_address' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
				'pop_code' : 'NXAD', // 넥서스 주소
				'hint_text' : '<%=CommonLang.get("HTITLE1409")%>', //선택하여 입력
				'link_map' : {
					'st_org_address_eng' : 2, // TEXT2 = 영문주소
					'st_org_phone_no'     : 3, // TEXT3 = 내선번호
				},
			},
			'st_org_address_eng' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : null,
			},
			'st_org_url' : {
				'auto_flg' : false,
				'update_flg' : false,
				'require_flg' : true,
				'fix_text' : 'nexus-official.com',
			},
		},
	};

// 한샘 신규조직(도무스/넥서스) 명함의 REMARK 필드 순서(';' 구분)는 now_view_option(=
// view_option[now_type])의 key 순서를 그대로 쓴다 - 도무스(매장명 있음/영문주소 없음)와
// 넥서스(매장명 없음/영문주소 있음)는 넘겨야 하는 필드 개수·구성 자체가 달라서, 두 유형이
// 공유하는 고정 배열에 안 쓰는 자리를 빈 값으로 채워 맞추면 안 된다(빈 칸이 있어도 없어도
// ';' 순서가 안 맞으면 값이 밀려서 전체 데이터가 깨짐). 대신 실제로 쓰는 필드만 정의된
// view_option 순서를 그대로 REMARK 순서로 사용한다.
// buyerMpSoCartList_v2.jsp의 nameCardView() arr_length 도 이 필드 개수와 항상 같이 맞출 것.
function getOrgRemarkFields(){
	return Object.keys(now_view_option ?? {});
}

// 유형별로 안 쓰는 행은 감춘다(도무스=영문주소 없음, 넥서스=매장명 없음).
// 안 쓰는 필드는 view_option 자체에 키가 없으므로 REMARK에도 포함되지 않는다.
const ORG_OPTIONAL_ROWS = {
		'st_org_store' : 'orgRowStore',
		'st_org_address_eng' : 'orgRowAddrEng',
	};

// 신규조직(도무스/넥서스) 명함인지 - 기존 한샘 유형과 화면/REMARK 규약이 달라서 계속 갈라야 한다
function isOrgType(){
	return now_type == 'HANS_9' || now_type == 'HANS_10';
}

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
		// 한샘 신규조직(도무스/넥서스) - 성함/휴대폰/이메일만 인사정보 연동(나머지는 선택 또는 고정값)
		'st_org_name' : "<%=CommonUtil.nvl(user_data.get("USER_NAME_LOC"))%>",
		'st_org_mobile_no' : "<%=CommonUtil.nvl(user_data.get("MOBILE_PHONE"))%>",
		'st_org_email' : "<%=CommonUtil.nvl(user_data.get("EMAIL"))%>",
	};

let nowPopUpTarget = null;
var popupSel = "";
function kep_onload(){

	// 신규조직(도무스/넥서스)은 입력 항목 구성이 달라 전용 테이블(tblHansOrg)을 쓴다.
	// 기존 한샘 유형들의 화면(tblHansBase)과 9필드 REMARK 규약은 그대로 둔다.
	if(isOrgType()){
		document.getElementById('tblHansBase').style.display = 'none';
		document.getElementById('tblHansOrg').style.display = '';
		Object.entries(ORG_OPTIONAL_ROWS).forEach(([fieldKey, rowId]) => {
			if(isEmpty(now_view_option[fieldKey])){
				document.getElementById(rowId).style.display = 'none';
			}
		});
	}

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
		if(isOrgType()){
			// 신규조직(도무스/넥서스)은 유형별 실제 필드 순서(getOrgRemarkFields()) 그대로 되돌린다
			var orgRemarkFields = getOrgRemarkFields();
			if(remark_arr.length == orgRemarkFields.length){
				for(var i=0; i<orgRemarkFields.length; i++){
					var orgTarget = document.getElementById(orgRemarkFields[i]);
					if(orgTarget){
						orgTarget.value = remark_arr[i];
					}
				}
			}else if(remark_arr.length != 1){
				// 명함정보가 올바르지 않습니다. KEP관리자에게 문의해주시기 바랍니다.
				var text = "<%=CommonLang.msg("MSG435") %>  ";
		     	openLayerPopText2(text,but1text,"javasciprt:thisPopClose2();return false;",but1width);
				return;
			}
		}else if(remark_arr.length == 9){
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
			// 명함정보가 올바르지 않습니다. KEP관리자에게 문의해주시기 바랍니다.
			var text = "<%=CommonLang.msg("MSG435") %>  ";
	     	openLayerPopText2(text,but1text,"javasciprt:thisPopClose2();return false;",but1width);
// 			this.close();
			return;
		}
<%
	}
%>
	// 신규조직(도무스/넥서스)은 직급/직책 구분 select(st_position_column_name) 자체가 없어 자동판별 대상이 아니다.
	// 가드 없이 부르면 now_view_option.st_position 이 undefined 라 TypeError 로 팝업이 죽는다.
	if(!isOrgType()){
		resolveSavedPositionType('NCIF', now_view_option.st_position.pop_code_map);
	}
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
				var text = value.select_change_alert_text;
		     	openLayerPopText2(text,but1text,but1func,but1width);
			}

			if(!isEmpty(value.change_alert_map) && !isEmpty(value.change_alert_map[changeKey])){
				var text = value.change_alert_map[changeKey];
		     	openLayerPopText2(text,but1text,but1func,but1width);
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
					var text = value.empty_alert_text;
			     	openLayerPopText2(text,but1text,but1func,but1width);
				}
				return;
			}

			const dynamicColumnName = getDynamicColumnName(value, defaultColumnName);
			const dynamicPopCode = getDynamicPopCode(value);

			if(isEmpty(dynamicPopCode)){
				//팝업 호출 코드가 올바르지 않습니다
				var text = "<%=CommonLang.msg("MSG871")%>";
		     	openLayerPopText2(text,but1text,but1func,but1width);
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

// th 셀의 항목명을 꺼낸다 - 검증 실패 메시지에서 어느 칸이 문제인지 알려주는 용도
function getColumnLabel(key){
	const target = document.getElementById(key);
	if(!target) return '';
	const th = target.parentElement.previousElementSibling;
	if(!th) return '';
	let label = '';
	th.childNodes.forEach((node) => {
		if(node.nodeType === Node.TEXT_NODE){
			label += node.textContent;
		}
	});
	return safeTrim(label);
}

// 입력값 검증(필수/세미콜론/양식) - 유형 공통.
// checkSemicolon 은 신규조직 유형에서만 켠다(기존 한샘 유형의 동작은 그대로 유지).
function validateNameCardInputs(checkSemicolon){
	let break_flg = false;
	if(!isEmpty(now_view_option)){
		Object.entries(now_view_option).some(([key, value]) => {
			const target = document.getElementById(key);
			if(!target) return false;

			// 필수 값 체크
			if(!isEmpty(value.require_flg) && value.require_flg){
				if(isEmpty(target.value)){
					//* 표시된 필수 명함정보를 모두 입력해주세요
					var text = "<%=CommonLang.msg("MSG863") %>  ";
					openLayerPopText2(text,but1text,but1func,but1width);
					break_flg = true;
					return true;
				}
			}

			// REMARK가 ';' 구분으로 저장/전달(협력사 확인용 엑셀까지 그대로 나감)되므로,
			// 입력값에 ';'가 섞이면 필드가 밀려서 전체 데이터가 깨진다 - 저장 전에 차단
			if(checkSemicolon && target.value.indexOf(";") != -1){
				// 에는 세미콜론(;)을 입력할 수 없습니다.
				var text = getColumnLabel(key) + "<%=CommonLang.msg("MSG1001") %>";
				openLayerPopText2(text,but1text,but1func,but1width);
				break_flg = true;
				return true;
			}

			// 양식 체크 - 유형별 패턴(valid_pattern)이 있으면 그걸 쓰고, 없으면 기존 한샘 규칙을 따른다
			if(!isEmpty(value.valid_pattern)){
				if(!isEmpty(target.value) && !value.valid_pattern.test(target.value)){
					//양식에 문제가 있습니다. 내용 확인 후 입력 바랍니다.
					var text = getColumnLabel(key) + " <%=CommonLang.msg("MSG870") %>";
					openLayerPopText2(text,but1text,but1func,but1width);
					break_flg = true;
					return true;
				}
			}else if(key == 'st_phone_no' || key == 'st_mobile_no'){
				let target_text = '휴대폰';
				if(key == 'st_phone_no') target_text = '전화번호'
				if(!isEmpty(target.value) && !isValidPhoneNumber(target.value, key)){
					//양식에 문제가 있습니다. 내용 확인 후 입력 바랍니다.
					var text = target_text + " <%=CommonLang.msg("MSG870") %>";
					openLayerPopText2(text,but1text,but1func,but1width);
					break_flg = true;
					return true;
				}
			}
		});
	}
	return !break_flg;
}

// 신규조직(도무스/넥서스) 저장 - getOrgRemarkFields() 순서대로(유형별로 실제 쓰는 필드만) ';'로 이어붙인다
function setReturnOrg(){
	if(!validateNameCardInputs(true)) return;

	var remark = getOrgRemarkFields().map(function(key){
		var target = document.getElementById(key);
		return target ? target.value : '';
	}).join(";");

	document.forms.searchCondition.st_remark.value = remark;
	kepAjaxFormCall("/mpso/saveBuyerMpSoCartRemarkNameCard.do","searchCondition","");
}

function setReturn(){
	if(isOrgType()){
		setReturnOrg();
		return;
	}

	var st_name = document.forms.contentForm.st_name.value; // 성함
	var st_position = document.forms.contentForm.st_position.value; // 직급/직책
	var st_department = document.forms.contentForm.st_department.value; // 부서
	var st_division = document.forms.contentForm.st_division.value; // 팀명 OR 매장명
	var st_phone_no = document.forms.contentForm.st_phone_no.value; // 전화번호
	var st_mobile_no = document.forms.contentForm.st_mobile_no.value; // 휴대폰번호
	var st_email = document.forms.contentForm.st_email.value; // 메일주소
	var st_address = document.forms.contentForm.st_address.value; // 주소
	var st_url = document.forms.contentForm.st_url.value; // 사이트주소

	if(!validateNameCardInputs(false)) return;

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
		//명함정보가 정상적으로 저장되었습니다.
		var text = "<%=CommonLang.msg("MSG864") %>  ";
     	openLayerPopText2(text,but1text,but1funcSearch,but1width);
	}
	return;
}
function thisPopClose(){
	closePopText2();
	
	var remark = document.forms.searchCondition.st_remark.value;
	opener.setPopupReturn(remark);
	this.close();
}
function thisPopClose2(){
	closePopText2();
	
	this.close();
}
//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
		var text = msg;
     	openLayerPopText2(text,but1text,but1func,but1width);
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
function doPop(str, code, target, width='1010', height='510', type = 'NCIF'){
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

	// 코드검색 팝업(comCode4PopSearch)은 TEXT1뿐 아니라 TEXT2~TEXT4도 같이 돌려준다.
	// 그 부가값을 link_map에 적힌 필드에 그대로 꽂아주면 매장→주소, 직급→영문직급,
	// 주소→영문주소+내선번호 자동입력이 전부 이 한 경로로 끝난다(별도 ajax 불필요).
	const linkMap = (now_view_option ?? {})[nowPopUpTarget]?.link_map;
	if(linkMap){
		const popupValues = [null, value1, value2, value3, value4, value5, value6];
		Object.entries(linkMap).forEach(([linkKey, valueIdx]) => {
			const linkTarget = document.getElementById(linkKey);
			if(linkTarget){
				linkTarget.value = popupValues[valueIdx] ?? '';
			}
		});
	}
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
		<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE1368")%><!--명함 정보 입력-->
  <span class="font500 font15px F6495F pt05">
  <%=CommonLang.get("HTITLE1415")%><!--※인사정보와 다른 소속/직급 신청은 사전 협조전 및 완료 협조전 첨부 필수-->
  </span>
  </div>
  <table id="tblHansBase" class="PopupSearchTableNoline mt10" width="820px"    >
	<colgroup>
      <col width="150px" />
      <col width="220px" />
      <col width="120px" />
      <col width="240px" />
	</colgroup>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1372")%><!--성함--></th>
      <td><input class="input40" style="width:210px" name="st_name" id="st_name" type="text" /></td>
      <th><span class="F6495F">*</span>
      	<select name="st_position_column_name" id="st_position_column_name" class="Select40" style="width:100px" >
			<option value=""><%=CommonLang.get("HTITLE178")%><!-- 선택 --></option>
			<option value="LEVL"><%=CommonLang.get("HTITLE476")%><!-- 직급 --></option>
			<option value="POST"><%=CommonLang.get("HTITLE1416")%><!--직책--></option>
        </select></th>
      <td><input class="input40" style="width:235px" name="st_position" id="st_position" type="text" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE329")%><!--부서--></th>
      <td><input class="input40" style="width:210px" name="st_division" id="st_division" type="text" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1395")%><!--팀명--></th>
      <td><input class="input40" style="width:235px" name="st_department" id="st_department" type="text" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE326")%><!--전화번호--></th>
      <td><input class="input40" style="width:210px" name="st_phone_no" id="st_phone_no" type="text" placeholder="02-0000-0000 <%=CommonLang.get("HTITLE1411")%>"/></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1378")%><!--휴대폰번호--></th>
      <td><input class="input40" style="width:235px" name="st_mobile_no" id="st_mobile_no" type="text" placeholder="010-0000-0000 <%=CommonLang.get("HTITLE1411")%>"/></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1379")%><!--이메일주소--></th>
      <td><input class="input40" style="width:210px" name="st_email" id="st_email" type="text" placeholder="hanssem@hanssem.com <%=CommonLang.get("HTITLE1411")%>" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE345")%><!--주소--></th>
      <td><input class="input40" style="width:235px" name="st_address" id="st_address" type="text" /></td>
    </tr>
    <tr>
		<th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1417")%><!--사이트주소--></th>
		<td colspan="3"><input class="input40" name="st_url" id="st_url" value="www.hanssem.com" style="width:620px" type="text" readOnly/></td>
	</tr>
	</table>
  <!-- 한샘 신규조직(도무스/넥서스) 명함 - 기존 유형과 입력 항목 구성이 달라 별도 테이블을 쓴다.
       어느 테이블을 보여줄지는 kep_onload()의 isOrgType() 분기가 정한다.
       필드 순서(=REMARK 순서)는 스크립트 상단 getOrgRemarkFields()(=view_option 정의 순서)를 따른다.
       매장명(도무스만)/영문주소(넥서스만)는 각각 유형에서 안 쓰면 자기 행 전체가 감춰진다(ORG_OPTIONAL_ROWS). -->
  <table id="tblHansOrg" class="PopupSearchTableNoline mt10" width="820px" style="display:none">
	<colgroup>
      <col width="150px" />
      <col width="220px" />
      <col width="120px" />
      <col width="240px" />
	</colgroup>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1372")%><!--성함--></th>
      <td><input class="input40" style="width:210px" name="st_org_name" id="st_org_name" type="text" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1538")%><!--영문성함--></th>
      <td><input class="input40" style="width:235px" name="st_org_name_eng" id="st_org_name_eng" type="text" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE476")%><!--직급--></th>
      <td><input class="input40" style="width:210px" name="st_org_position" id="st_org_position" type="text" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1516")%><!--직급(영문)--></th>
      <td><input class="input40" style="width:235px" name="st_org_position_eng" id="st_org_position_eng" type="text" /></td>
    </tr>
    <tr id="orgRowStore">
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1413")%><!--매장명--></th>
      <td colspan="3"><input class="input40" name="st_org_store" id="st_org_store" style="width:620px" type="text" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1534")%><!--내선번호--></th>
      <td><input class="input40" style="width:210px" name="st_org_phone_no" id="st_org_phone_no" type="text" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1378")%><!--휴대폰번호--></th>
      <td><input class="input40" style="width:235px" name="st_org_mobile_no" id="st_org_mobile_no" type="text" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1379")%><!--이메일주소--></th>
      <td colspan="3"><input class="input40" name="st_org_email" id="st_org_email" style="width:620px" type="text" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE345")%><!--주소--></th>
      <td colspan="3"><input class="input40" name="st_org_address" id="st_org_address" style="width:620px" type="text" /></td>
    </tr>
    <tr id="orgRowAddrEng">
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1535")%><!--주소(영문)--></th>
      <td colspan="3"><input class="input40" name="st_org_address_eng" id="st_org_address_eng" style="width:620px" type="text" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1417")%><!--사이트주소--></th>
      <td colspan="3"><input class="input40" name="st_org_url" id="st_org_url" style="width:620px" type="text" /></td>
    </tr>
	</table>
  <div class="PopupListBtnBox_Center mt15">
    <!--button class="ButOutline_Medium" style="width:120px" >초기화</button--> 
    <button class="ButDarkGray_Medium" style="width:150px" onclick="javascript:setReturn(); return false;" ><%=CommonLang.get("HTITLE1383")%><!--확인 후 시안보기--></button> 
  </div> 
</div><!-- wrapPopup 끝-->  
	</form>
</body>
</html>
