<%--
**********************************************
* 메뉴 : 
* 화면 : MSDS 등록 팝업
* 기능 : MSDS 등록 팝업
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 2015-08-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
String p_description = CommonUtil.nvl((String) request.getParameter("p_description"),"");  //  (st_description)
String p_specification = CommonUtil.nvl((String) request.getParameter("p_specification"),"");  //  (st_specification)
String p_maker_name = CommonUtil.nvl((String) request.getParameter("p_maker_name"),"");  //  (st_maker_name)

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}
%>

<script type="text/javascript">
//최초 화면 함수 
function kep_onload_view() {
	<% if (_dataList==null || _dataList.size()==0) { %>
	kepSearch();
	<% } %>
	kepSetCalender("p_last_revision_date");
}

function kepSearch()
{  
  $('#masterCoCoMsdsDetailViewPop').attr("action", "/mdcm/getMasterMsdsRegList.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
		case "search":	 //조회
			kepSearch();
			break;
		case "save": // 저장
			var tot_cnt = document.forms.masterCoCoMsdsDetailViewPop.display_item_cnt.value;
			var query=  "";
			var pass = "N";
		    
			// 무조건 히든 체크로 첨부파일 개수 만큼 반복
			for(var k=0; k<tot_cnt; k++){
				var box = eval("document.forms.masterCoCoMsdsDetailViewPop.InCheck" +k);
				
				if(box.checked == true){
					// 첨부 파일 부분
					var st_file_no = document.forms.masterCoCoMsdsDetailViewPop.st_file_no[k].value;
					var st_revision = document.forms.masterCoCoMsdsDetailViewPop.st_revision[k].value;
					var st_image_key = document.forms.masterCoCoMsdsDetailViewPop.st_image_key[k].value;
					var st_note = document.forms.masterCoCoMsdsDetailViewPop.st_note[k].value;
					
					// 필수 파일 첨부 확인
					if(st_file_no == "R1" && st_image_key != ""){
						pass = "Y";
					}
					if(pass == "N"){
						alert("MSDS(필수) 항목의 첨부파일이 필요합니다.");
						return;
					}
					
					//기본 정보 부분
					var st_msds_no = "";
					var p_description = document.forms.masterCoCoMsdsDetailViewPop.p_description.value;
					var p_specification = document.forms.masterCoCoMsdsDetailViewPop.p_specification.value;
					var p_maker_name = document.forms.masterCoCoMsdsDetailViewPop.p_maker_name.value;
					var p_last_revision_date = $("#p_last_revision_date").val().replace(/\//gi, "");
					var st_harmful_yn = document.forms.masterCoCoMsdsDetailViewPop.st_harmful_yn.value;
					var st_submission_number = document.forms.masterCoCoMsdsDetailViewPop.st_submission_number.value;
					
					// 기본 정보 입력 확인
					if(p_description == ""){
						alert("품명 입력 필수입니다.");
						document.forms.masterCoCoMsdsDetailViewPop.p_description.focus();
						return;
					}
					
					if(p_specification == ""){
						alert("규격 입력 필수입니다.");
						document.forms.masterCoCoMsdsDetailViewPop.p_specification.focus();
						return;
					}
					
					if(p_maker_name == ""){
						alert("제조사 입력 필수입니다.");
						document.forms.masterCoCoMsdsDetailViewPop.p_maker_name.focus();
						return;
					}
					
					if(st_harmful_yn == ""){
						alert("유해화학물질 여부 입력 필수입니다.");
						document.forms.masterCoCoMsdsDetailViewPop.st_harmful_yn.focus();
						return;
					}
					
					if(st_submission_number == ""){
						alert("MSDS 제출번호 입력 필수입니다.");
						document.forms.masterCoCoMsdsDetailViewPop.st_submission_number.focus();
						return;
					}
					
					// CAS번호, MAX값, 화관법 존재 확인
					var cas_null_check = "Y";
					var cas_max_null_check = "Y";
					var cas_acut_null_check = "Y";
					var cas_chro_null_check = "Y";
					var cas_ecol_null_check = "Y";
					var cas_harmful_null_check = "Y";
					var cas_prepare_null_check = "Y";
					var cas_limit_null_check = "Y";
					
					var st_cas_no = "";
					var st_cas_no_min = "";
					var st_cas_no_max = "";
					var st_cas_no_acut = "";
					var st_cas_no_chro = "";
					var st_cas_no_ecol = "";
					var st_cas_no_harmful = "";
					var st_cas_no_prepare = "";
					var st_cas_no_limit = "";
					
					var i = 1;
					var last_i = 1;
					
					for(i=1; i<21; i++){
						st_cas_no = eval("document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_" + i);
						st_cas_no_min = eval("document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_" + i);
						st_cas_no_max = eval("document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_" + i);
						st_cas_no_acut = eval("document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_" + i);
						st_cas_no_chro = eval("document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_" + i);
						st_cas_no_ecol = eval("document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_" + i);
						st_cas_no_harmful = eval("document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_" + i);
						st_cas_no_prepare = eval("document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_" + i);
						st_cas_no_limit = eval("document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_" + i);
						
						// 유해화학물질 = Y
						if(st_harmful_yn == "Y"){
							// CAS 번호 하나라도 채워져 있으면
							if(st_cas_no.value != ""){
								if(st_cas_no_min.value != "" && st_cas_no_max.value == ""){
									alert("유해화학물질 함량정보를 완성하여 주시기 바랍니다.");
									eval("document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_" + i).focus();
									return;
								}
								
								if(st_cas_no_max.value != ""){
									if(st_cas_no_acut.checked == false && st_cas_no_chro.checked == false && st_cas_no_ecol.checked == false && st_cas_no_harmful.checked == false && st_cas_no_prepare.checked == false && st_cas_no_limit.checked == false){
										alert("유해화학물질은 화관법이 하나라도 입력되어야 합니다.");
										eval("document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_" + i).focus();
										return;
									}
									
									// CAS MAX 값 NULL 체크 고정
									if(cas_max_null_check == "Y"){
										cas_max_null_check = "N";
									}
								}
								
								// CAS 번호 NULL 체크 고정
								if(cas_null_check == "Y"){
									cas_null_check = "N";
								}
								
								last_i = i;
							}
				        
						// 유해화학물질 = N
						}else{
							if(st_cas_no.value != ""){
								cas_null_check = "N";
								break;
							}
						}
					}
						
					if(cas_null_check == "Y"){
						alert("CAS번호는 필수입니다.");
						document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_1.focus();
						return;
					}

					if(st_harmful_yn == "Y"){
						if(cas_max_null_check == "Y"){
							alert("유해화학물질은 MAX값이 하나라도 입력되어야 합니다.");
							eval("document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_" + last_i).focus();
							return;
						}
					}
					
					// 물질정보
					var st_use_cd = document.forms.masterCoCoMsdsDetailViewPop.st_use_cd.value;
					var st_info_cd = document.forms.masterCoCoMsdsDetailViewPop.st_info_cd.value;
					var st_use_note = document.forms.masterCoCoMsdsDetailViewPop.st_use_note.value;
					var st_info_level = document.forms.masterCoCoMsdsDetailViewPop.st_info_level.value;
					
					// 유해화학물질 = Y 일 때 물질정보 입력 확인
					if(st_harmful_yn == "Y"){
						if(st_use_cd == ""){
							alert("품목용도 입력 필수입니다.");
							document.forms.masterCoCoMsdsDetailViewPop.st_use_cd.focus();
							return;
						}
						
						if(st_info_cd == ""){
							alert("물질상태 입력 필수입니다.");
							document.forms.masterCoCoMsdsDetailViewPop.st_info_cd.focus();
							return;
						}
						
						if(st_use_cd == "A85" && st_use_note == ""){
							alert("품목용도 기타 선택 시 용도비고 입력 필수입니다.");
							document.forms.masterCoCoMsdsDetailViewPop.st_use_note.focus();
							return;
						}
						
						if((st_info_cd == "A02" || st_info_cd == "A03") && st_info_level == ""){
							alert("물질상태 액체나 기체 선택 시 밀도 입력 필수입니다.");
							document.forms.masterCoCoMsdsDetailViewPop.st_info_level.focus();
							return;
						}
						
						if(st_info_level != ""){
							if(!kepIsNumChkStr(st_info_level, 2)){
								alert("입력양식이 올바르지 않습니다.");
								document.forms.masterCoCoMsdsDetailViewPop.st_info_level.focus();
								return;
							}
						}
					}
					
					// MIN, MAX 숫자만 입력 체크
					for(var j=1; j<21; j++){
						var number_min = eval("document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_" + j);
						var number_max = eval("document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_" + j);
						
						if(number_min.value != ""){
							if(!kepIsNumChkStr(number_min.value, 2)){
								alert("입력양식이 올바르지 않습니다.");
								number_min.focus();
								return;
							}
						}
						
						if(number_max.value != ""){
							if(!kepIsNumChkStr(number_max.value, 2)){
								alert("입력양식이 올바르지 않습니다.");
								number_max.focus();
								return;
							}
						}
					}
					
					// CAS번호
					var st_cas_no_1 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_1.value;
					var st_cas_no_2 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_2.value;
					var st_cas_no_3 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_3.value;
					var st_cas_no_4 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_4.value;
					var st_cas_no_5 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_5.value;
					var st_cas_no_6 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_6.value;
					var st_cas_no_7 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_7.value;
					var st_cas_no_8 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_8.value;
					var st_cas_no_9 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_9.value;
					var st_cas_no_10 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_10.value;
					var st_cas_no_11 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_11.value;
					var st_cas_no_12 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_12.value;
					var st_cas_no_13 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_13.value;
					var st_cas_no_14 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_14.value;
					var st_cas_no_15 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_15.value;
					var st_cas_no_16 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_16.value;
					var st_cas_no_17 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_17.value;
					var st_cas_no_18 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_18.value;
					var st_cas_no_19 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_19.value;
					var st_cas_no_20 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_20.value;
					var st_cas_no_list = st_cas_no_1+"/"+st_cas_no_2+"/"+st_cas_no_3+"/"+st_cas_no_4+"/"+st_cas_no_5+"/"+st_cas_no_6+"/"+st_cas_no_7+"/"+st_cas_no_8+"/"+st_cas_no_9+"/"+st_cas_no_10+"/"+st_cas_no_11+"/"+st_cas_no_12+"/"+st_cas_no_13+"/"+st_cas_no_14+"/"+st_cas_no_15+"/"+st_cas_no_16+"/"+st_cas_no_17+"/"+st_cas_no_18+"/"+st_cas_no_19+"/"+st_cas_no_20;
					
					// 화관법
					var st_cas_no_min_1 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_1.value;
					var st_cas_no_min_2 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_2.value;
					var st_cas_no_min_3 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_3.value;
					var st_cas_no_min_4 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_4.value;
					var st_cas_no_min_5 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_5.value;
					var st_cas_no_min_6 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_6.value;
					var st_cas_no_min_7 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_7.value;
					var st_cas_no_min_8 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_8.value;
					var st_cas_no_min_9 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_9.value;
					var st_cas_no_min_10 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_10.value;
					var st_cas_no_min_11 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_11.value;
					var st_cas_no_min_12 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_12.value;
					var st_cas_no_min_13 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_13.value;
					var st_cas_no_min_14 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_14.value;
					var st_cas_no_min_15 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_15.value;
					var st_cas_no_min_16 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_16.value;
					var st_cas_no_min_17 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_17.value;
					var st_cas_no_min_18 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_18.value;
					var st_cas_no_min_19 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_19.value;
					var st_cas_no_min_20 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_min_20.value;
					var st_cas_no_min_list = st_cas_no_min_1+"/"+st_cas_no_min_2+"/"+st_cas_no_min_3+"/"+st_cas_no_min_4+"/"+st_cas_no_min_5+"/"+st_cas_no_min_6+"/"+st_cas_no_min_7+"/"+st_cas_no_min_8+"/"+st_cas_no_min_9+"/"+st_cas_no_min_10+"/"+st_cas_no_min_11+"/"+st_cas_no_min_12+"/"+st_cas_no_min_13+"/"+st_cas_no_min_14+"/"+st_cas_no_min_15+"/"+st_cas_no_min_16+"/"+st_cas_no_min_17+"/"+st_cas_no_min_18+"/"+st_cas_no_min_19+"/"+st_cas_no_min_20;
					
					var st_cas_no_max_1 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_1.value;
					var st_cas_no_max_2 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_2.value;
					var st_cas_no_max_3 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_3.value;
					var st_cas_no_max_4 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_4.value;
					var st_cas_no_max_5 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_5.value;
					var st_cas_no_max_6 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_6.value;
					var st_cas_no_max_7 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_7.value;
					var st_cas_no_max_8 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_8.value;
					var st_cas_no_max_9 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_9.value;
					var st_cas_no_max_10 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_10.value;
					var st_cas_no_max_11 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_11.value;
					var st_cas_no_max_12 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_12.value;
					var st_cas_no_max_13 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_13.value;
					var st_cas_no_max_14 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_14.value;
					var st_cas_no_max_15 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_15.value;
					var st_cas_no_max_16 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_16.value;
					var st_cas_no_max_17 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_17.value;
					var st_cas_no_max_18 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_18.value;
					var st_cas_no_max_19 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_19.value;
					var st_cas_no_max_20 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_max_20.value;
					var st_cas_no_max_list = st_cas_no_max_1+"/"+st_cas_no_max_2+"/"+st_cas_no_max_3+"/"+st_cas_no_max_4+"/"+st_cas_no_max_5+"/"+st_cas_no_max_6+"/"+st_cas_no_max_7+"/"+st_cas_no_max_8+"/"+st_cas_no_max_9+"/"+st_cas_no_max_10+"/"+st_cas_no_max_11+"/"+st_cas_no_max_12+"/"+st_cas_no_max_13+"/"+st_cas_no_max_14+"/"+st_cas_no_max_15+"/"+st_cas_no_max_16+"/"+st_cas_no_max_17+"/"+st_cas_no_max_18+"/"+st_cas_no_max_19+"/"+st_cas_no_max_20;
					
					var st_cas_no_acut_1 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_1.checked;
					var st_cas_no_acut_2 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_2.checked;
					var st_cas_no_acut_3 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_3.checked;
					var st_cas_no_acut_4 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_4.checked;
					var st_cas_no_acut_5 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_5.checked;
					var st_cas_no_acut_6 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_6.checked;
					var st_cas_no_acut_7 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_7.checked;
					var st_cas_no_acut_8 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_8.checked;
					var st_cas_no_acut_9 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_9.checked;
					var st_cas_no_acut_10 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_10.checked;
					var st_cas_no_acut_11 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_11.checked;
					var st_cas_no_acut_12 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_12.checked;
					var st_cas_no_acut_13 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_13.checked;
					var st_cas_no_acut_14 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_14.checked;
					var st_cas_no_acut_15 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_15.checked;
					var st_cas_no_acut_16 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_16.checked;
					var st_cas_no_acut_17 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_17.checked;
					var st_cas_no_acut_18 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_18.checked;
					var st_cas_no_acut_19 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_19.checked;
					var st_cas_no_acut_20 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_acut_20.checked;
					var st_cas_no_acut_list = st_cas_no_acut_1+"/"+st_cas_no_acut_2+"/"+st_cas_no_acut_3+"/"+st_cas_no_acut_4+"/"+st_cas_no_acut_5+"/"+st_cas_no_acut_6+"/"+st_cas_no_acut_7+"/"+st_cas_no_acut_8+"/"+st_cas_no_acut_9+"/"+st_cas_no_acut_10+"/"+st_cas_no_acut_11+"/"+st_cas_no_acut_12+"/"+st_cas_no_acut_13+"/"+st_cas_no_acut_14+"/"+st_cas_no_acut_15+"/"+st_cas_no_acut_16+"/"+st_cas_no_acut_17+"/"+st_cas_no_acut_18+"/"+st_cas_no_acut_19+"/"+st_cas_no_acut_20;
					st_cas_no_acut_list = st_cas_no_acut_list.replace(/true/g, "Y");
					st_cas_no_acut_list = st_cas_no_acut_list.replace(/false/g, "");
					
					var st_cas_no_chro_1 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_1.checked;
					var st_cas_no_chro_2 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_2.checked;
					var st_cas_no_chro_3 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_3.checked;
					var st_cas_no_chro_4 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_4.checked;
					var st_cas_no_chro_5 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_5.checked;
					var st_cas_no_chro_6 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_6.checked;
					var st_cas_no_chro_7 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_7.checked;
					var st_cas_no_chro_8 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_8.checked;
					var st_cas_no_chro_9 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_9.checked;
					var st_cas_no_chro_10 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_10.checked;
					var st_cas_no_chro_11 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_11.checked;
					var st_cas_no_chro_12 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_12.checked;
					var st_cas_no_chro_13 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_13.checked;
					var st_cas_no_chro_14 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_14.checked;
					var st_cas_no_chro_15 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_15.checked;
					var st_cas_no_chro_16 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_16.checked;
					var st_cas_no_chro_17 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_17.checked;
					var st_cas_no_chro_18 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_18.checked;
					var st_cas_no_chro_19 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_19.checked;
					var st_cas_no_chro_20 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_chro_20.checked;
					var st_cas_no_chro_list = st_cas_no_chro_1+"/"+st_cas_no_chro_2+"/"+st_cas_no_chro_3+"/"+st_cas_no_chro_4+"/"+st_cas_no_chro_5+"/"+st_cas_no_chro_6+"/"+st_cas_no_chro_7+"/"+st_cas_no_chro_8+"/"+st_cas_no_chro_9+"/"+st_cas_no_chro_10+"/"+st_cas_no_chro_11+"/"+st_cas_no_chro_12+"/"+st_cas_no_chro_13+"/"+st_cas_no_chro_14+"/"+st_cas_no_chro_15+"/"+st_cas_no_chro_16+"/"+st_cas_no_chro_17+"/"+st_cas_no_chro_18+"/"+st_cas_no_chro_19+"/"+st_cas_no_chro_20;
					st_cas_no_chro_list = st_cas_no_chro_list.replace(/true/g, "Y");
					st_cas_no_chro_list = st_cas_no_chro_list.replace(/false/g, "");
					
					var st_cas_no_ecol_1 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_1.checked;
					var st_cas_no_ecol_2 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_2.checked;
					var st_cas_no_ecol_3 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_3.checked;
					var st_cas_no_ecol_4 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_4.checked;
					var st_cas_no_ecol_5 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_5.checked;
					var st_cas_no_ecol_6 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_6.checked;
					var st_cas_no_ecol_7 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_7.checked;
					var st_cas_no_ecol_8 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_8.checked;
					var st_cas_no_ecol_9 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_9.checked;
					var st_cas_no_ecol_10 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_10.checked;
					var st_cas_no_ecol_11 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_11.checked;
					var st_cas_no_ecol_12 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_12.checked;
					var st_cas_no_ecol_13 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_13.checked;
					var st_cas_no_ecol_14 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_14.checked;
					var st_cas_no_ecol_15 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_15.checked;
					var st_cas_no_ecol_16 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_16.checked;
					var st_cas_no_ecol_17 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_17.checked;
					var st_cas_no_ecol_18 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_18.checked;
					var st_cas_no_ecol_19 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_19.checked;
					var st_cas_no_ecol_20 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_ecol_20.checked;
					var st_cas_no_ecol_list = st_cas_no_ecol_1+"/"+st_cas_no_ecol_2+"/"+st_cas_no_ecol_3+"/"+st_cas_no_ecol_4+"/"+st_cas_no_ecol_5+"/"+st_cas_no_ecol_6+"/"+st_cas_no_ecol_7+"/"+st_cas_no_ecol_8+"/"+st_cas_no_ecol_9+"/"+st_cas_no_ecol_10+"/"+st_cas_no_ecol_11+"/"+st_cas_no_ecol_12+"/"+st_cas_no_ecol_13+"/"+st_cas_no_ecol_14+"/"+st_cas_no_ecol_15+"/"+st_cas_no_ecol_16+"/"+st_cas_no_ecol_17+"/"+st_cas_no_ecol_18+"/"+st_cas_no_ecol_19+"/"+st_cas_no_ecol_20;
					st_cas_no_ecol_list = st_cas_no_ecol_list.replace(/true/g, "Y");
					st_cas_no_ecol_list = st_cas_no_ecol_list.replace(/false/g, "");
					
					var st_cas_no_harmful_1 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_1.checked;
					var st_cas_no_harmful_2 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_2.checked;
					var st_cas_no_harmful_3 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_3.checked;
					var st_cas_no_harmful_4 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_4.checked;
					var st_cas_no_harmful_5 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_5.checked;
					var st_cas_no_harmful_6 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_6.checked;
					var st_cas_no_harmful_7 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_7.checked;
					var st_cas_no_harmful_8 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_8.checked;
					var st_cas_no_harmful_9 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_9.checked;
					var st_cas_no_harmful_10 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_10.checked;
					var st_cas_no_harmful_11 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_11.checked;
					var st_cas_no_harmful_12 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_12.checked;
					var st_cas_no_harmful_13 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_13.checked;
					var st_cas_no_harmful_14 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_14.checked;
					var st_cas_no_harmful_15 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_15.checked;
					var st_cas_no_harmful_16 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_16.checked;
					var st_cas_no_harmful_17 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_17.checked;
					var st_cas_no_harmful_18 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_18.checked;
					var st_cas_no_harmful_19 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_19.checked;
					var st_cas_no_harmful_20 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_harmful_20.checked;
					var st_cas_no_harmful_list = st_cas_no_harmful_1+"/"+st_cas_no_harmful_2+"/"+st_cas_no_harmful_3+"/"+st_cas_no_harmful_4+"/"+st_cas_no_harmful_5+"/"+st_cas_no_harmful_6+"/"+st_cas_no_harmful_7+"/"+st_cas_no_harmful_8+"/"+st_cas_no_harmful_9+"/"+st_cas_no_harmful_10+"/"+st_cas_no_harmful_11+"/"+st_cas_no_harmful_12+"/"+st_cas_no_harmful_13+"/"+st_cas_no_harmful_14+"/"+st_cas_no_harmful_15+"/"+st_cas_no_harmful_16+"/"+st_cas_no_harmful_17+"/"+st_cas_no_harmful_18+"/"+st_cas_no_harmful_19+"/"+st_cas_no_harmful_20;
					st_cas_no_harmful_list = st_cas_no_harmful_list.replace(/true/g, "Y");
					st_cas_no_harmful_list = st_cas_no_harmful_list.replace(/false/g, "");
					
					var st_cas_no_prepare_1 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_1.checked;
					var st_cas_no_prepare_2 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_2.checked;
					var st_cas_no_prepare_3 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_3.checked;
					var st_cas_no_prepare_4 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_4.checked;
					var st_cas_no_prepare_5 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_5.checked;
					var st_cas_no_prepare_6 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_6.checked;
					var st_cas_no_prepare_7 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_7.checked;
					var st_cas_no_prepare_8 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_8.checked;
					var st_cas_no_prepare_9 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_9.checked;
					var st_cas_no_prepare_10 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_10.checked;
					var st_cas_no_prepare_11 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_11.checked;
					var st_cas_no_prepare_12 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_12.checked;
					var st_cas_no_prepare_13 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_13.checked;
					var st_cas_no_prepare_14 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_14.checked;
					var st_cas_no_prepare_15 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_15.checked;
					var st_cas_no_prepare_16 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_16.checked;
					var st_cas_no_prepare_17 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_17.checked;
					var st_cas_no_prepare_18 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_18.checked;
					var st_cas_no_prepare_19 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_19.checked;
					var st_cas_no_prepare_20 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_prepare_20.checked;
					var st_cas_no_prepare_list = st_cas_no_prepare_1+"/"+st_cas_no_prepare_2+"/"+st_cas_no_prepare_3+"/"+st_cas_no_prepare_4+"/"+st_cas_no_prepare_5+"/"+st_cas_no_prepare_6+"/"+st_cas_no_prepare_7+"/"+st_cas_no_prepare_8+"/"+st_cas_no_prepare_9+"/"+st_cas_no_prepare_10+"/"+st_cas_no_prepare_11+"/"+st_cas_no_prepare_12+"/"+st_cas_no_prepare_13+"/"+st_cas_no_prepare_14+"/"+st_cas_no_prepare_15+"/"+st_cas_no_prepare_16+"/"+st_cas_no_prepare_17+"/"+st_cas_no_prepare_18+"/"+st_cas_no_prepare_19+"/"+st_cas_no_prepare_20;
					st_cas_no_prepare_list = st_cas_no_prepare_list.replace(/true/g, "Y");
					st_cas_no_prepare_list = st_cas_no_prepare_list.replace(/false/g, "");
					
					var st_cas_no_limit_1 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_1.checked;
					var st_cas_no_limit_2 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_2.checked;
					var st_cas_no_limit_3 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_3.checked;
					var st_cas_no_limit_4 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_4.checked;
					var st_cas_no_limit_5 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_5.checked;
					var st_cas_no_limit_6 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_6.checked;
					var st_cas_no_limit_7 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_7.checked;
					var st_cas_no_limit_8 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_8.checked;
					var st_cas_no_limit_9 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_9.checked;
					var st_cas_no_limit_10 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_10.checked;
					var st_cas_no_limit_11 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_11.checked;
					var st_cas_no_limit_12 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_12.checked;
					var st_cas_no_limit_13 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_13.checked;
					var st_cas_no_limit_14 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_14.checked;
					var st_cas_no_limit_15 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_15.checked;
					var st_cas_no_limit_16 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_16.checked;
					var st_cas_no_limit_17 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_17.checked;
					var st_cas_no_limit_18 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_18.checked;
					var st_cas_no_limit_19 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_19.checked;
					var st_cas_no_limit_20 = document.forms.masterCoCoMsdsDetailViewPop.st_cas_no_limit_20.checked;
					var st_cas_no_limit_list = st_cas_no_limit_1+"/"+st_cas_no_limit_2+"/"+st_cas_no_limit_3+"/"+st_cas_no_limit_4+"/"+st_cas_no_limit_5+"/"+st_cas_no_limit_6+"/"+st_cas_no_limit_7+"/"+st_cas_no_limit_8+"/"+st_cas_no_limit_9+"/"+st_cas_no_limit_10+"/"+st_cas_no_limit_11+"/"+st_cas_no_limit_12+"/"+st_cas_no_limit_13+"/"+st_cas_no_limit_14+"/"+st_cas_no_limit_15+"/"+st_cas_no_limit_16+"/"+st_cas_no_limit_17+"/"+st_cas_no_limit_18+"/"+st_cas_no_limit_19+"/"+st_cas_no_limit_20;
					st_cas_no_limit_list = st_cas_no_limit_list.replace(/true/g, "Y");
					st_cas_no_limit_list = st_cas_no_limit_list.replace(/false/g, "");
					
					// 유해화학물질 = N 이면 모두 불필요 값 세팅
					if(st_harmful_yn == "N"){
						st_cas_no_min_list = "///////////////////";
						st_cas_no_max_list = "///////////////////";
						st_cas_no_acut_list = "///////////////////";
						st_cas_no_chro_list = "///////////////////";
						st_cas_no_ecol_list = "///////////////////";
						st_cas_no_harmful_list = "///////////////////";
						st_cas_no_prepare_list = "///////////////////";
						st_cas_no_limit_list = "///////////////////";
						st_use_cd = "";
						st_info_cd = "";
						st_use_note = "";
						st_info_level = "";
					}
					
					// 기타 첨부가 기본 체크되어 있어서 입력값 없으면 반복 불필요 break
					if(st_file_no != "R1" && st_image_key == "" && st_note == ""){
						break;
					}
                    
					query +=	st_msds_no + "@@" +
                    			st_file_no + "@@" +
                    			st_revision + "@@" +
                    			st_image_key + "@@" +
                    			st_note + "@@" +
                    			p_description + "@@" +
                    			p_specification + "@@" +
                    			p_maker_name + "@@" +
                    			st_cas_no_list + "@@" +
                    			st_cas_no_min_list + "@@" +
                    			st_cas_no_max_list + "@@" +
                    			st_cas_no_acut_list + "@@" +
                    			st_cas_no_chro_list + "@@" +
                    			st_cas_no_ecol_list + "@@" +
                    			st_cas_no_harmful_list + "@@" +
                    			st_cas_no_prepare_list + "@@" +
                    			st_cas_no_limit_list + "@@" +
                    			p_last_revision_date + "@@" +
                    			st_use_cd + "@@" +
                    			st_info_cd + "@@" +
                    			st_use_note + "@@" +
                    			st_info_level + "@@" +
                    			st_harmful_yn + "@@" +
                    			st_submission_number;
                    query += "|";
				}
			}
	    	
	        document.forms.processForm.st_query.value = query; 
	    	kepAjaxFormCall("/mdcm/insertMasterMsdsDetailList.do","processForm","SAVE"); 
			break;
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
    alert(" 정상적으로 처리되었습니다.");
    this.close();
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}

var g_Row = "";
var popupSel  ="";
//팝업함수호출
function doPop(str,value1, value2, value3) {
	popupSel = str;
	switch (str) {
	case "calendar": // 달력
		g_Row = value1;
		openSearchPopup('/common/calendarPop.do','','130,240,no');
		break;
	case "fileUpload": // 첨부
		g_Row = value1;
		var type="MSDS";
		var viewType="VI";
		var image_key= document.forms.masterCoCoMsdsDetailViewPop.st_image_key[value1].value
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');
		break;
	}
}

function setPopupCalendar(year,month,day){
    var box = eval("document.forms.masterCoCoMsdsDetailViewPop.InCheck"+g_Row );
    box.checked =true;
    document.forms.masterCoCoMsdsDetailViewPop.st_file_date_2[g_Row].value = year+"/"+month+"/"+day;
    document.forms.masterCoCoMsdsDetailViewPop.st_file_date[g_Row].value = year+month+day;
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
									,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
									,value21,value22,value23,value24,value25,value26,value27,value28,value29){
	if(popupSel == "fileUpload") {	//파일 첨부
		var diskOn = "/resources/images/disk_on.gif";
		var diskOff = "/resources/images/disk_off.gif";
		var tot_cnt  = $("#display_item_cnt").val();
		
		if(value1 != ''){
			if(eval(tot_cnt) < 2) {
				document.forms.masterCoCoMsdsDetailViewPop.st_image_key.value = value1;
				document.forms.masterCoCoMsdsDetailViewPop.Image2.src = diskOn;
	        }else{
	        	document.forms.masterCoCoMsdsDetailViewPop.st_image_key[g_Row].value = value1;
				document.forms.masterCoCoMsdsDetailViewPop.Image2[g_Row].src = diskOn;
	        }
	    }else{
	    	if(eval(tot_cnt) < 2) {
				document.forms.masterCoCoMsdsDetailViewPop.st_image_key.value = "";
				document.forms.masterCoCoMsdsDetailViewPop.Image2.src = diskOff;
	        }else{
	        	document.forms.masterCoCoMsdsDetailViewPop.st_image_key[g_Row].value = "";
				document.forms.masterCoCoMsdsDetailViewPop.Image2[g_Row].src = diskOff;
	        }
	    }
	}
}
// 더보기, 숨기기
var showMore_casNo_flag = "N";
function showMore(flag){
	// 숨겨져 있는 마지막 row 번호
	var casNo_remain_size = 10;

	if (flag==1){ // CAS NO
		if(showMore_casNo_flag == "N"){ // 더보기 비활성 -> 활성
			for(var i=6; i<=casNo_remain_size; i++){
				document.getElementById("cas_no_row_"+i).style.display = "";
			}
			
			if(showMore_casNoCmc_flag == "Y"){
				for(var i=1; i<=casNo_remain_size; i++){
					document.getElementById("cas_no_cmc_row_"+i).style.display = "";
				}
			}else{
				for(var i=6; i<=casNo_remain_size; i++){
					document.getElementById("cas_no_cmc_row_"+i).style.display = "none";
				}
			}
				
			showMore_casNo_flag = "Y";
			$("#casNo_add_btn").html("숨기기▲");
		}else{ // 더보기 활성 -> 비활성
			for(var i=6; i<=casNo_remain_size; i++){
				document.getElementById("cas_no_row_"+i).style.display = "none";
				document.getElementById("cas_no_cmc_row_"+i).style.display = "none";
			}
		
			showMore_casNo_flag = "N";
			$("#casNo_add_btn").html("더보기▼");
		}
	}
}

// 유해화학물질 선택에 따른 보이기, 숨기기
var showMore_casNoCmc_flag = "N";
function showMoreCmc(flag){
	// 숨겨져 있는 마지막 row 번호
	var casNoCmc_remain_size = 10;
	
	if(showMore_casNo_flag == "Y"){
		casNoCmc_remain_size = 10;
	}else{
		casNoCmc_remain_size = 5;
	}
	
	if(flag=="Y"){ // 유해화학물질여부
		for(var i=1; i<=casNoCmc_remain_size; i++){
			document.getElementById("cas_no_cmc_row_"+i).style.display = "";
		}
		//물질정보
		document.getElementById('popContainer1').style.display = "";
		
		showMore_casNoCmc_flag = "Y";
	}else{
		for(var i=1; i<=casNoCmc_remain_size; i++){
			document.getElementById("cas_no_cmc_row_"+i).style.display = "none";
		}
		//물질정보
		document.getElementById('popContainer1').style.display = "none";
		
		showMore_casNoCmc_flag = "N";
	}
}
</script> 
<body onload="kep_onload_view();">
<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_query" id="st_query"  value=""/>
</form>
<form name="masterCoCoMsdsDetailViewPop" id="masterCoCoMsdsDetailViewPop" method=post >
<%	if (_dataList != null && _dataList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_dataList.size() %>" >
<%	}	%>
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
    	<div id="popHeader">
        	<h1 class="title">MSDS 등록</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div class="scrollArea" style="height:480px;" >
	        	<table class="cont_t_list06" style="width:100%;">
	                <caption>회원사 정보관리</caption>
	                <colgroup>
	                    <col width="18%" />
	                    <col width="32%" />
	                    <col width="18%" />
	                    <col width="32%" />
	                </colgroup>
	                <tbody>
						<tr>
	                        <th scope="row">품명</th>
	                        <td ><input type="text" class="input_type_text" id="p_description" name="p_description" style="width:80%;" value="<%=p_description%>"  > </td>
	                        <th scope="row">규격</th>
	                        <td><input type="text" class="input_type_text" id="p_specification" name="p_specification" style="width:80%;" value="<%=p_specification%>"  ></td>
						</tr>
						<tr>
	                        <th scope="row">제조사</th>
	                        <td><input type="text" class="input_type_text" id="p_maker_name" name="p_maker_name" style="width:80%;" value="<%=p_maker_name%>"  ></td>
	                        <th scope="row">최종 개정일</th>
	                        <td><input type="text" class="input_type_text" name="p_last_revision_date" id="p_last_revision_date" readOnly style="width:50%; text-align:center;" value="">
								<a href="javascript:kepCalendar('p_last_revision_date')"></a>
								<a href="javascript:kepEraser('p_last_revision_date');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
						<tr>
							<th scope="row">유해화학물질 여부</th>
							<td>
								<select name="st_harmful_yn" id="st_harmful_yn" onchange="javascript:showMoreCmc(this.value);" style="height:20px; width: 60px;">
									<option value="" selected>선택</option>
									<option value="Y">Y</option>
									<option value="N">N</option>
			                	</select>
							</td>
							<th scope="row">MSDS 제출번호</th>
	                        <td ><input type="text" class="input_type_text" id="st_submission_number" name="st_submission_number" style="width:80%;" value=""></td>
						</tr>
						
						<tr id="cas_no_row_1">
							<th scope="row">CAS 번호1</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_1" name="st_cas_no_1" style="width:80%;" value=""  ></td>
							<th scope="row">CAS 번호2</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_2" name="st_cas_no_2" style="width:80%;" value=""  ></td>
						</tr>
						<tr id="cas_no_cmc_row_1" style="display:none;">
							<th scope="row">CAS 번호1<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_1" name="st_cas_no_min_1" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_1" name="st_cas_no_max_1" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_1" id="st_cas_no_acut_1" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_1" id="st_cas_no_chro_1" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_1" id="st_cas_no_ecol_1" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_1" id="st_cas_no_harmful_1" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_1" id="st_cas_no_prepare_1" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_1" id="st_cas_no_limit_1" style="vertical-align: middle;">&nbsp;제한
                        	</td>
							<th scope="row">CAS 번호2<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_2" name="st_cas_no_min_2" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_2" name="st_cas_no_max_2" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_2" id="st_cas_no_acut_2" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_2" id="st_cas_no_chro_2" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_2" id="st_cas_no_ecol_2" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_2" id="st_cas_no_harmful_2" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_2" id="st_cas_no_prepare_2" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_2" id="st_cas_no_limit_2" style="vertical-align: middle;">&nbsp;제한
	                        </td>
						</tr>
						
						<tr id="cas_no_row_2">
							<th scope="row">CAS 번호3</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_3" name="st_cas_no_3" style="width:80%;" value=""  ></td>
							<th scope="row">CAS 번호4</th>
							<td><input type="text" class="input_type_text" id="st_cas_no_4" name="st_cas_no_4" style="width:80%;" value=""  ></td>
						</tr>
						<tr id="cas_no_cmc_row_2" style="display:none;">
							<th scope="row">CAS 번호3<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_3" name="st_cas_no_min_3" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_3" name="st_cas_no_max_3" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_3" id="st_cas_no_acut_3" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_3" id="st_cas_no_chro_3" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_3" id="st_cas_no_ecol_3" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_3" id="st_cas_no_harmful_3" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_3" id="st_cas_no_prepare_3" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_3" id="st_cas_no_limit_3" style="vertical-align: middle;">&nbsp;제한
                        	</td>
							<th scope="row">CAS 번호4<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_4" name="st_cas_no_min_4" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_4" name="st_cas_no_max_4" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_4" id="st_cas_no_acut_4" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_4" id="st_cas_no_chro_4" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_4" id="st_cas_no_ecol_4" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_4" id="st_cas_no_harmful_4" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_4" id="st_cas_no_prepare_4" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_4" id="st_cas_no_limit_4" style="vertical-align: middle;">&nbsp;제한
	                        </td>
						</tr>
						
						<tr id="cas_no_row_3">
							<th scope="row">CAS 번호5</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_5" name="st_cas_no_5" style="width:80%;" value=""  ></td>
	                        <th scope="row">CAS 번호6</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_6" name="st_cas_no_6" style="width:80%;" value=""  ></td>
						</tr>
						<tr id="cas_no_cmc_row_3" style="display:none;">
							<th scope="row">CAS 번호5<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_5" name="st_cas_no_min_5" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_5" name="st_cas_no_max_5" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_5" id="st_cas_no_acut_5" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_5" id="st_cas_no_chro_5" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_5" id="st_cas_no_ecol_5" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_5" id="st_cas_no_harmful_5" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_5" id="st_cas_no_prepare_5" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_5" id="st_cas_no_limit_5" style="vertical-align: middle;">&nbsp;제한
                        	</td>
							<th scope="row">CAS 번호6<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_6" name="st_cas_no_min_6" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_6" name="st_cas_no_max_6" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_6" id="st_cas_no_acut_6" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_6" id="st_cas_no_chro_6" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_6" id="st_cas_no_ecol_6" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_6" id="st_cas_no_harmful_6" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_6" id="st_cas_no_prepare_6" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_6" id="st_cas_no_limit_6" style="vertical-align: middle;">&nbsp;제한
	                        </td>
						</tr>
						
						<tr id="cas_no_row_4">
							<th scope="row">CAS 번호7</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_7" name="st_cas_no_7" style="width:80%;" value=""  ></td>
	                        <th scope="row">CAS 번호8</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_8" name="st_cas_no_8" style="width:80%;" value=""  ></td>
						</tr>
						<tr id="cas_no_cmc_row_4" style="display:none;">
							<th scope="row">CAS 번호7<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_7" name="st_cas_no_min_7" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_7" name="st_cas_no_max_7" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_7" id="st_cas_no_acut_7" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_7" id="st_cas_no_chro_7" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_7" id="st_cas_no_ecol_7" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_7" id="st_cas_no_harmful_7" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_7" id="st_cas_no_prepare_7" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_7" id="st_cas_no_limit_7" style="vertical-align: middle;">&nbsp;제한
                        	</td>
							<th scope="row">CAS 번호8<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_8" name="st_cas_no_min_8" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_8" name="st_cas_no_max_8" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_8" id="st_cas_no_acut_8" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_8" id="st_cas_no_chro_8" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_8" id="st_cas_no_ecol_8" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_8" id="st_cas_no_harmful_8" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_8" id="st_cas_no_prepare_8" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_8" id="st_cas_no_limit_8" style="vertical-align: middle;">&nbsp;제한
	                        </td>
						</tr>
						
						<tr id="cas_no_row_5">
							<th scope="row">CAS 번호9</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_9" name="st_cas_no_9" style="width:80%;" value=""  ></td>
	                        <th scope="row">CAS 번호10</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_10" name="st_cas_no_10" style="width:80%;" value=""  ></td>
						</tr>
						<tr id="cas_no_cmc_row_5" style="display:none;">
							<th scope="row">CAS 번호9<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_9" name="st_cas_no_min_9" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_9" name="st_cas_no_max_9" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_9" id="st_cas_no_acut_9" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_9" id="st_cas_no_chro_9" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_9" id="st_cas_no_ecol_9" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_9" id="st_cas_no_harmful_9" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_9" id="st_cas_no_prepare_9" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_9" id="st_cas_no_limit_9" style="vertical-align: middle;">&nbsp;제한
                        	</td>
							<th scope="row">CAS 번호10<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_10" name="st_cas_no_min_10" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_10" name="st_cas_no_max_10" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_10" id="st_cas_no_acut_10" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_10" id="st_cas_no_chro_10" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_10" id="st_cas_no_ecol_10" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_10" id="st_cas_no_harmful_10" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_10" id="st_cas_no_prepare_10" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_10" id="st_cas_no_limit_10" style="vertical-align: middle;">&nbsp;제한
	                        </td>
						</tr>
						
						<tr id="cas_no_row_6" style="display:none;">
							<th scope="row">CAS 번호11</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_11" name="st_cas_no_11" style="width:80%;" value=""  ></td>
							<th scope="row">CAS 번호12</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_12" name="st_cas_no_12" style="width:80%;" value=""  ></td>
						</tr>
						<tr id="cas_no_cmc_row_6" style="display:none;">
							<th scope="row">CAS 번호11<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_11" name="st_cas_no_min_11" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_11" name="st_cas_no_max_11" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_11" id="st_cas_no_acut_11" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_11" id="st_cas_no_chro_11" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_11" id="st_cas_no_ecol_11" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_11" id="st_cas_no_harmful_11" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_11" id="st_cas_no_prepare_11" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_11" id="st_cas_no_limit_11" style="vertical-align: middle;">&nbsp;제한
                        	</td>
							<th scope="row">CAS 번호12<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_12" name="st_cas_no_min_12" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_12" name="st_cas_no_max_12" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_12" id="st_cas_no_acut_12" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_12" id="st_cas_no_chro_12" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_12" id="st_cas_no_ecol_12" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_12" id="st_cas_no_harmful_12" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_12" id="st_cas_no_prepare_12" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_12" id="st_cas_no_limit_12" style="vertical-align: middle;">&nbsp;제한
	                        </td>
						</tr>
						
						<tr id="cas_no_row_7" style="display:none;">
							<th scope="row">CAS 번호13</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_13" name="st_cas_no_13" style="width:80%;" value=""  ></td>
							<th scope="row">CAS 번호14</th>
							<td><input type="text" class="input_type_text" id="st_cas_no_14" name="st_cas_no_14" style="width:80%;" value=""  ></td>
						</tr>
						<tr id="cas_no_cmc_row_7" style="display:none;">
							<th scope="row">CAS 번호13<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_13" name="st_cas_no_min_13" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_13" name="st_cas_no_max_13" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_13" id="st_cas_no_acut_13" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_13" id="st_cas_no_chro_13" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_13" id="st_cas_no_ecol_13" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_13" id="st_cas_no_harmful_13" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_13" id="st_cas_no_prepare_13" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_13" id="st_cas_no_limit_13" style="vertical-align: middle;">&nbsp;제한
                        	</td>
							<th scope="row">CAS 번호14<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_14" name="st_cas_no_min_14" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_14" name="st_cas_no_max_14" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_14" id="st_cas_no_acut_14" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_14" id="st_cas_no_chro_14" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_14" id="st_cas_no_ecol_14" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_14" id="st_cas_no_harmful_14" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_14" id="st_cas_no_prepare_14" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_14" id="st_cas_no_limit_14" style="vertical-align: middle;">&nbsp;제한
	                        </td>
						</tr>
						
						<tr id="cas_no_row_8" style="display:none;">
							<th scope="row">CAS 번호15</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_15" name="st_cas_no_15" style="width:80%;" value=""  ></td>
	                        <th scope="row">CAS 번호16</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_16" name="st_cas_no_16" style="width:80%;" value=""  ></td>
						</tr>
						<tr id="cas_no_cmc_row_8" style="display:none;">
							<th scope="row">CAS 번호15<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_15" name="st_cas_no_min_15" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_15" name="st_cas_no_max_15" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_15" id="st_cas_no_acut_15" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_15" id="st_cas_no_chro_15" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_15" id="st_cas_no_ecol_15" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_15" id="st_cas_no_harmful_15" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_15" id="st_cas_no_prepare_15" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_15" id="st_cas_no_limit_15" style="vertical-align: middle;">&nbsp;제한
                        	</td>
							<th scope="row">CAS 번호16<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_16" name="st_cas_no_min_16" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_16" name="st_cas_no_max_16" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_16" id="st_cas_no_acut_16" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_16" id="st_cas_no_chro_16" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_16" id="st_cas_no_ecol_16" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_16" id="st_cas_no_harmful_16" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_16" id="st_cas_no_prepare_16" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_16" id="st_cas_no_limit_16" style="vertical-align: middle;">&nbsp;제한
	                        </td>
						</tr>
						
						<tr id="cas_no_row_9" style="display:none;">
							<th scope="row">CAS 번호17</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_17" name="st_cas_no_17" style="width:80%;" value=""  ></td>
	                        <th scope="row">CAS 번호18</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_18" name="st_cas_no_18" style="width:80%;" value=""  ></td>
						</tr>
						<tr id="cas_no_cmc_row_9" style="display:none;">
							<th scope="row">CAS 번호17<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_17" name="st_cas_no_min_17" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_17" name="st_cas_no_max_17" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_17" id="st_cas_no_acut_17" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_17" id="st_cas_no_chro_17" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_17" id="st_cas_no_ecol_17" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_17" id="st_cas_no_harmful_17" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_17" id="st_cas_no_prepare_17" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_17" id="st_cas_no_limit_17" style="vertical-align: middle;">&nbsp;제한
                        	</td>
							<th scope="row">CAS 번호18<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_18" name="st_cas_no_min_18" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_18" name="st_cas_no_max_18" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_18" id="st_cas_no_acut_18" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_18" id="st_cas_no_chro_18" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_18" id="st_cas_no_ecol_18" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_18" id="st_cas_no_harmful_18" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_18" id="st_cas_no_prepare_18" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_18" id="st_cas_no_limit_18" style="vertical-align: middle;">&nbsp;제한
	                        </td>
						</tr>
						
						<tr id="cas_no_row_10" style="display:none;">
							<th scope="row">CAS 번호19</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_19" name="st_cas_no_19" style="width:80%;" value=""  ></td>
	                        <th scope="row">CAS 번호20</th>
	                        <td><input type="text" class="input_type_text" id="st_cas_no_20" name="st_cas_no_20" style="width:80%;" value=""  ></td>
						</tr>
						<tr id="cas_no_cmc_row_10" style="display:none;">
							<th scope="row">CAS 번호19<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_19" name="st_cas_no_min_19" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_19" name="st_cas_no_max_19" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_19" id="st_cas_no_acut_19" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_19" id="st_cas_no_chro_19" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_19" id="st_cas_no_ecol_19" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_19" id="st_cas_no_harmful_19" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_19" id="st_cas_no_prepare_19" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_19" id="st_cas_no_limit_19" style="vertical-align: middle;">&nbsp;제한
                        	</td>
							<th scope="row">CAS 번호20<br>함량정보 화관법</th>
	                        <td>
	                        	<input type="text" class="input_type_text" id="st_cas_no_min_20" name="st_cas_no_min_20" style="height:15px; width:60px;" value=""  >
	                        	~
	                        	<input type="text" class="input_type_text" id="st_cas_no_max_20" name="st_cas_no_max_20" style="height:15px; width:60px;" value=""  >
	                        	%
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_acut_20" id="st_cas_no_acut_20" style="vertical-align: middle;">&nbsp;급성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_chro_20" id="st_cas_no_chro_20" style="vertical-align: middle;">&nbsp;만성
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_ecol_20" id="st_cas_no_ecol_20" style="vertical-align: middle;">&nbsp;생태
	                        	<br>
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_harmful_20" id="st_cas_no_harmful_20" style="vertical-align: middle; display: none;">
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_prepare_20" id="st_cas_no_prepare_20" style="vertical-align: middle;">&nbsp;사고대비
	                        	<input type="checkbox" class="Noborder" name="st_cas_no_limit_20" id="st_cas_no_limit_20" style="vertical-align: middle;">&nbsp;제한
	                        </td>
						</tr>
					</tbody>
				</table>
				
				<div style="height: 25px;">
					<a href="javascript:showMore('1')"><p id="casNo_add_btn" style=" float:right;height:20px; line-height:23px; width:65px; border:1px solid #f62401; background:#f62401;background:url(/resources/images/b_btn_order.gif); color:#fff; text-align:center; font-size:11px">더보기 ▼</p></a>
				</div>
				
				<div id="popContainer1"  style="display:none;">
					<h4>물질정보</h4>
					<table class="cont_t_list06" style="width:100%">
						<colgroup>
							<col width="15%"/>
							<col width="35%" />
							<col width="15%" />
							<col width="35%" />
						</colgroup>
						<tbody>
							<tr>
								<th>폼목용도</th>
								<td>
									<select name="st_use_cd"  id="st_use_cd" style="width:80%">
										<%= CommonUtil.getCode3ComboList("", "SEL", "CM02","", "ICOMCOD1", "", "") %>           
					         		</select>
								</td>
								<th>물질상태</th>			
								<td>
									<select name="st_info_cd"  id="st_info_cd" style="width:80%">
										<%= CommonUtil.getCode3ComboList("", "SEL", "CM06","", "ICOMCOD1", "", "") %>           
					         		</select>
					         	</td>
							</tr>
					  		<tr>
					  			<th>용도 비고
					  				<img src="/resources/images/but_query.png" style="vertical-align: middle;" title="해당 용도는 대표로 사용하는 용도입니다&#10;기타로 선택할 경우, 상세 용도 작성 부탁드립니다">
					  			</th>			
								<td>
									<input type="text" name="st_use_note" id="st_use_note" class="input_type_text" title="" style="width:80%;" value=""/>
								</td>
								<th>밀도
									<img src="/resources/images/but_query.png" style="vertical-align: middle;" title="밀도 정보가 없을 경우, 1로 작성">
								</th>			
								<td>
									<input type="text" name="st_info_level" id="st_info_level" class="input_type_text" title="" style="width:80%;" value=""/>
								</td>
							</tr>
						</tbody>
					</table>	
				</div>
				
				<table class="cont_t_list02" style="width:100%">
					<colgroup>
						<col width="20%" />
						<col width="10%" />
						<col width="*" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">항목</th>
							<th scope="col">첨부파일</th>
							<th scope="col">비고</th>
						</tr>
					</thead>
					<tbody>
					<% if (_dataList == null || _dataList.size() == 0) { %>
						<tr>
							<td colspan="15" align="center" height = "50"> 
								<span>조회된 데이타가 없습니다.</span>
							</td>
						</tr>
					<%
					} else {
						for (int j=0; j<_dataList.size(); j++) {
							Map<String,String> rowData2 = _dataList.get(j);
							String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
					%> 
						<tr align="center" bgcolor="<%=tclass%>">
							<td title="항목" align="left">
								<input type="checkbox" class="input_noline" name="InCheck<%=j%>" checked style="display: none">
								<input type="hidden" name="st_msds_no_2" id="st_msds_no_2"  value="">
								<input type="hidden" name="st_text1" id="st_text1"  value="<%=String.valueOf(CommonUtil.nvl(rowData2.get("TEXT1")))%>">
								<input type="hidden" name="st_revision" id="st_revision"  value="">
								<%=String.valueOf(CommonUtil.nvl(rowData2.get("TEXT1")))%>
							</td>							
							<td title="첨부파일">
								<input type="hidden" name="st_file_no" id="st_file_no"   value="<%=String.valueOf(CommonUtil.nvl(rowData2.get("FILE_NO")))%>">
								<input type="hidden" name="st_image_key" id="st_image_key"  value="">
								<a href="javascript:doPop('fileUpload','<%=j%>');"><img src="/resources/images/disk_off.gif" id="Image2" name="Image2" border="0"></a>
							</td>
							<td title="비고란">
								<input type="text" class="input_type_text" id="st_note" name="st_note" style="width:95%;" value="" >
							</td>
						</tr>
					<%
						} 
					}
					%>
					</tbody>
				</table>
  			
        	</div>
        	<br/>
        	<!--버튼영역-->
			<div class="btnArea02" >
  	          	<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
  				</span>
  			 </div>
				</div>
			</div>
		</div>
</form> 
</body>
</html>
