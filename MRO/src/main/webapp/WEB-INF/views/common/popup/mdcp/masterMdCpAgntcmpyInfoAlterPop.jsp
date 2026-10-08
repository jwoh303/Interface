<%--
**********************************************
* 메뉴 : 
* 화면 : 협력사정보 수정 
* 기능 : 협력사정보 수정 
* 프로그램 ID : PG_01_M_005_01
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-03
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
<script src="/resources/js/common.js"></script>
</head>
<%
// 공통
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
List<Map<String,String>> _dataAreaList = (List<Map<String,String>>) request.getAttribute("dataDelyArea"); // 조회된 납품가능 지역

String user_id =  CommonUtil.nvl((String) request.getParameter("user_id"), _sessionInfo.getUserId());
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String simsaLevel = CommonUtil.nvl((String) request.getParameter("simsaLevel"),"1");
String sessionEmpNo = _sessionInfo.getEmpNo();
String sessionDept = _sessionInfo.getDepartment();
String st_sp_type ="";
String st_reg_reason_type ="";

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
	st_sp_type = CommonUtil.nvl(_rowData.get("SP_TYPE"), "N");
}
%> 

<script type="text/javascript">
<!--
var popupSel = "";
var popupItem = "";
var actionFlag = "";

//최초 화면 함수 
function kep_onload_view() {
	<% if (_dataList.size()==0) { %>
		alert("협력사 정보가 없습니다.\n\n관리자에게 문의 하십시요.");
		self.close();
	<% }else{ %>
		var sp_type = "<%=st_sp_type%>";
	<%}%>
	//납품가능지역 데이터 셋팅
	var st_cmpy_dely_area = $("#st_cmpy_dely_area").val();
	if(st_cmpy_dely_area == null || st_cmpy_dely_area ==""){
	}else{
		var str_area_list = st_cmpy_dely_area.split("");
		var tot_cnt = $("#st_cmpy_dely_cnt").val();
		// 파라미터 선택된 값 체크하기
		for(var i=0; i< tot_cnt; i++){
			if(str_area_list[i] == "Y"){
				document.getElementById("st_dely_area_flag"+i).checked = true;
			}else{
				document.getElementById("st_dely_area_flag"+i).checked = false;
			}
		}
	}
	
	// 평가기준에 영향이 있어 설립일자 변경 못하도록 막음
	//kepSetCalender("establish_date");
	kepSetCalender("st_e_contract_date");
	
	<%if (simsaLevel.equals("1") && (CommonUtil.nvl(_rowData.get("STATUS")).equals("S") || CommonUtil.nvl(_rowData.get("STATUS")).equals("B") || CommonUtil.nvl(_rowData.get("STATUS")).equals("E"))) { %>
		$("input[name=sp_type]").attr("disabled", false);
		
	<%}else{%>
		$("input[name=sp_type]").attr("disabled", true);
	<%}%>
}

function kepSearch() {
	$('#searchForm').attr("action", "/mdcp/getMasterMdCpAgntcmpyInfoAlterPop.do").submit();    
}

var st;
//기능함수
function doAction(str, tag) {
	actionFlag = tag;
	switch (str) {
		case "search":	 //조회
			kepSearch();
			break;
		case "reload":	//초기화
			kepReload("searchForm");
			break;
		case "save": // 저장	
			if (checkSubmit(tag)) {
				if(actionFlag == "T"){
					if(!$("#st_bill_yn").is(":checked")){
						alert("협력사와 합의 여부를 확인해주십시오.");
						$("#st_bill_yn").focus();
						return false;
					}
					
					gw_aprv();
				}
				$("#st_e_contract_kind").removeAttr("disabled"); // selectBox는 disabled 시 값 전송이 안되므로 저장 전 disabled 속성 삭제
				$("#st_lgst_end_date").removeAttr("disabled"); // selectBox는 disabled 시 값 전송이 안되므로 저장 전 disabled 속성 삭제
				kepAjaxFormCall("/mdcp/saveMasterMdCpAgntcmpyInfoAlterPop.do", "contentForm", str); 	
			}
			break;
		case "avl" :
			if (setAvl(tag)) {
				kepAjaxFormCall("/mdcp/saveMasterMdCpAgntcmpyInfoAlterPopAvl.do", "contentForm", str); 	
			}
			break;	
		case "del" :
			if (confirm("협력사 정보를 삭제 하시겠습니까?")) {
				kepAjaxFormCall("/mdcp/deleteMasterMdCpAgntcmpyInfoAlterPop.do", "contentForm", str); 	
			}
			break;
	}
}

function gw_aprv(){
	var value1 = eval($("input[name=st_value1]").val());
	var value2 = eval($("input[name=st_value2]").val());
	var value3 = eval($("input[name=st_value3]").val());
	var value4 = eval($("input[name=st_value4]").val());
	var value5 = eval($("input[name=st_value5]").val());
	var value6 = eval($("input[name=st_value6]").val());
	var value_tot = eval($("input[name=st_value_tot]").val());
	
	var reg_reason = document.getElementById("st_reg_reason_type");
	
	var sp_type = $("input[name=st_sp_type]").val();
	var sp_type_nm = "";
	
	// 회사정보
	var gw_com_name_loc = $("input[name=st_com_name_loc]").val();
	var gw_ceo_name_loc = $("input[name=st_ceo_name_loc]").val();
	var gw_irs_no = $("input[name=st_irs_no1]").val() + "-" + $("input[name=st_irs_no2]").val() + "-" + $("input[name=st_irs_no3]").val();
	var gw_business_items = $("input[name=st_business_items]").val();
	var gw_industry_type = $("input[name=st_industry_type]").val();
	var gw_establish_date = $("input[name=st_establish_date]").val();
	
	// 계좌정보
	var gw_bank_name = $("input[name=st_bank_name]").val();
	var gw_bank_account_no = $("input[name=st_bank_account_no]").val();

	// 경리담당자 정보
	var gw_ac_emp_nm = $("input[name=st_ac_emp_nm]").val();
	var gw_ac_emp_tel = $("input[name=st_ac_emp_tel]").val();
	var gw_ac_emp_email = $("input[name=st_ac_emp_email]").val();
	var gw_ac_emp_mobile1 = document.getElementById("st_ac_emp_mobile1");
	var gw_ac_emp_mobile1_type = gw_ac_emp_mobile1.options[gw_ac_emp_mobile1.selectedIndex].text;
	var gw_ac_emp_mobile = gw_ac_emp_mobile1_type + "-" + $("input[name=st_ac_emp_mobile2]").val() + "-" + $("input[name=st_ac_emp_mobile3]").val();
	
	// 영업담당자 정보
	var gw_gr_emp_nm = $("input[name=st_gr_emp_nm]").val();
	var gw_gr_emp_tel = $("input[name=st_gr_emp_tel]").val();
	var gw_gr_emp_email = $("input[name=st_gr_emp_email]").val();
	var gw_gr_emp_mobile1 = document.getElementById("st_gr_emp_mobile1");
	var gw_gr_emp_mobile1_type = gw_gr_emp_mobile1.options[gw_gr_emp_mobile1.selectedIndex].text;
	var gw_gr_emp_mobile = gw_gr_emp_mobile1_type + "-" + $("input[name=st_gr_emp_mobile2]").val() + "-" + $("input[name=st_gr_emp_mobile3]").val();
	
	// 물류수수료율 및 협의기한, 사유
	var gw_gr_emp_mobile = gw_gr_emp_mobile1_type + "-" + $("input[name=st_gr_emp_mobile2]").val() + "-" + $("input[name=st_gr_emp_mobile3]").val();
	var gw_st_lgst_end_date = $("input[name=st_lgst_end_date]").val();
	var gw_st_lgstrate_end_date = $("input[name=st_lgstrate]").val() + "%" + ", " + gw_st_lgst_end_date.substr(0,4) + "년" + gw_st_lgst_end_date.substr(4,2) + "월";
	var gw_st_sg_name = $("input[name=st_sg_name]").val();
	
	var gw_st_lgstrate_remark = $("input[name=st_lgstrate_remark]").val();
	
	var st_dept = "<%=sessionDept%>";
	var buyer_ho_yn = $("input[name=buyer_ho_yn]:checked").val();
	
	
	if(sp_type == "N"){
		sp_type_nm = "정규";
	}else if(sp_type == "S"){
		sp_type_nm = "정규(특별계약)";	
	}else if(sp_type == "T"){
		sp_type_nm = "임시";	
	}else if(sp_type == "E"){
		sp_type_nm ="계약제외";
	}
	
	var itm_chk = "N";
	
	for (var i=1; i < 11; i++) {
		if ($("#st_itm_mk" + i).val() != "") {
			itm_chk = "Y";
		}
	}
	
	var bodyContents =
		"<style> .SmallTB{border:1px solid #000; font-size:12px} .SmallTB th{ text-align:center; background-color:#e8f3f9;border-right:1px solid #000;border-bottom:1px solid #000;} .SmallTB td{ height:25px;border-bottom:1px solid #000; padding-left:5px}</style>"+
		"<body>"+
		"<table class=\"SmallTB\" cellSpacing=\"0\" cellPadding=\"0\" width=\"100%\">"+
	  	"<tbody>"+
	  	"<colgroup>"+
	  	"<col width=\"15%\" />"+
	  	"<col width=\"14%\" />"+
	  	"<col width=\"28%\" />"+
	  	"<col width=\"15%\" />"+
	  	"<col width=\"28%\" />"+
	  	"</colgroup>"+
	  	"<tr >"+
	    "<th rowSpan=\"5\" >회사정보</th>"+
	    "<th >회사명</th>"+
	    "<td style=\"border-right:1px solid #000;\" >" + gw_com_name_loc + "</td>"+
	    "<th >회사코드</th>"+
	    "<td ><%=com_code%></td>"+
	  	"</tr>"+
	  	"<tr >"+
	    "<th >대표자명</th>"+
	    "<td style=\"border-right:1px solid #000;\" >" + gw_ceo_name_loc + "</td>"+
	    "<th >사업자번호</th>"+
	    "<td >" + gw_irs_no + "</td>"+
	  	"</tr>"+
	  	"<tr >"+
	    "<th >업태</th>"+
	    "<td style=\"border-right:1px solid #000;\" >" + gw_industry_type + "</td>"+
	    "<th >설립년도</th>"+
	    "<td >" + gw_establish_date + "</td>"+
	  	"</tr>"+
	  	"<tr >"+
	    "<th>종목</th>"+
	    "<td style=\"border-right:1px solid #000;\" >" + gw_business_items + "</td>"+
	    "<th >총판/대리점</th>"+
	    "<td>"+ itm_chk + "</td>"+
	  	"</tr>"+
	  	"<tr >"+
	    "<th>협력사구분</th>"+
	    "<td style=\"border-right:1px solid #000;\" >" + sp_type_nm + "</td>"+
	    "<th></th>"+
	    "<td></td>"+
	  	"</tr>"+
	  	"<tr >"+
	    "<th >계좌정보</th>"+
	    "<th >은행명</th>"+
	    "<td style=\"border-right:1px solid #000;\" >" + gw_bank_name + "</td>"+
	    "<th >계좌번호</th>"+
	    "<td  >" + gw_bank_account_no + "</td>"+
	  	"</tr>"+
	  	"<tr >"+
	    "<th >담당정보</th>"+
	    "<th>담당부서</th>"+
	    "<td style=\"border-right:1px solid #000;\" ></td>"+
	    "<th >담당자</th>"+
	    "<td ></td>"+
	  	"</tr>"+
	  	"<tr >"+
	  	"<th rowSpan=\"2\">경리담당자정보</th>"+
	  	"<th >이름</th>"+
	  	"<td style=\"border-right:1px solid #000;\" >" + gw_ac_emp_nm + "</td>"+
	  	"<th >이메일</th>"+
	  	"<td >" + gw_ac_emp_email + "</td>"+
	  	"</tr>"+
	  	"<tr >"+
	  	"<th >전화번호</th>"+
	  	"<td style=\"border-right:1px solid #000;\" >" + gw_ac_emp_tel + "</td>"+
	  	"<th >휴대폰번호</th>"+
	  	"<td >" + gw_ac_emp_mobile + "</td>"+
	  	"</tr>"+
	  	"<tr >"+
	  	"<th rowSpan=\"2\">영업담당자정보</th>"+
	  	"<th >이름</th>"+
	  	"<td style=\"border-right:1px solid #000;\" >" + gw_gr_emp_nm + "</td>"+
	  	"<th >이메일</th>"+
	  	"<td >" + gw_gr_emp_email + "</td>"+
	  	"</tr>"+
	  	"<tr >"+
	  	"<th >전화번호</th>"+
	  	"<td style=\"border-right:1px solid #000;\" >" + gw_gr_emp_tel + "</td>"+
	  	"<th >휴대폰번호</th>"+
	  	"<td >" + gw_gr_emp_mobile + "</td>"+
	  	"</tr>"+
	  	"<tr >"+
	    "<th colSpan=\"3\" style=\"height:25px;\">평가항목</th>"+
	    "<th>배점</th>"+
	    "<th>항목 점수</th>"+
	  	"</tr>"+
	  	"<tr >"+
	    "<td colSpan=\"3\" style=\"border-right:1px solid #000;\">1. 설립일자</td>"+
	    "<td style=\"border-right:1px solid #000; text-align:center;\">20</td>"+
	    "<td style=\"text-align:center;\" readOnly>"+value1+"</td>"+
	  	"</tr>"+
	  	"<tr >"+
	    "<td colSpan=\"3\" style=\"border-right:1px solid #000;\">2. 자본금 총액</td>"+
	    "<td style=\"border-right:1px solid #000; text-align:center;\">10</td>"+
	    "<td style=\"text-align:center;\">"+value2+"</td>"+
	  	"</tr>"+
	  	"<tr >"+
	    "<td colSpan=\"3\" style=\"border-right:1px solid #000;\">3. 연간 매출액</td>"+
	    "<td style=\"border-right:1px solid #000; text-align:center;\">25</td>"+
	    "<td style=\"text-align:center;\">"+value3+"</td>"+
	  	"</tr>"+
	  	"<tr >"+
	    "<td colSpan=\"3\" style=\"border-right:1px solid #000;\">4. 상시근로자수</td>"+
	    "<td style=\"border-right:1px solid #000; text-align:center;\">20</td>"+
	    "<td style=\"text-align:center;\">"+value4+"</td>"+
	  	"</tr>"+
	  	"<tr >"+
	    "<td colSpan=\"3\" style=\"border-right:1px solid #000;\">5. 대표자 동종업계 경력</td>"+
	    "<td style=\"border-right:1px solid #000; text-align:center;\">20</td>"+
	    "<td style=\"text-align:center;\">"+value5+"</td>"+
	  	"</tr>"+
	  	"<tr >"+
	    "<td colSpan=\"3\" style=\"border-right:1px solid #000;\">6. 등록구분</td>"+
	    "<td style=\"border-right:1px solid #000; text-align:center;\">5</td>"+
	    "<td style=\"text-align:center;\">"+value6+"</td>"+
	  	"</tr>"+
	  	"<tr >"+
	    "<td colSpan=\"3\" style=\"border-right:1px solid #000; font-weight:bold; text-align:center;\">점수 합계</td>"+
	    "<td style=\"border-right:1px solid #000; font-weight:bold; text-align:center;\">100</td>"+
	    "<td style=\"font-weight:bold; text-align:center;\">"+value_tot+"</td>"+
	  	"</tr>"+
	  	"<tr >"+
	    "<th >대표SG</th>"+	    
	    "<td style=\"border-right:1px solid #000;\" >" + gw_st_sg_name + "</td>"+
	    "<th >수수료율(%), 협의기한</th>"+
	    "<td colSpan=\"2\" >" + gw_st_lgstrate_end_date + "</td>"+
	  	"</tr>"+
	  	"<tr >"+
	    "<th >수수료율<br>변경사유</th>"+	    
	    "<td colSpan=\"4\" style=\"border-right:1px solid #000;\" >" + gw_st_lgstrate_remark + "</td>"+	    
	  	"</tr>"+
	  	"<tr>"+
	  	"<th style=\"border-bottom:0px solid #000;\">비 고</th>"+
	    "<td style=\"height:100px; vertical-align:top;border-bottom:0px solid #000;\" colspan=\"4\" ></td>"+
	  	"</tr>"+
	  	"</tbody>"+
		"</table>"
		;
	
	var form = document.createElement("form");
	form.setAttribute("method", "post");
	form.setAttribute("target", "_blank");
	form.setAttribute("action", "https://gw.koreab2b.com/jsp/kep_linkage/InQdbData.jsp");

	var hiddenField01 = document.createElement("input");
	hiddenField01.setAttribute("type", "hidden");
	hiddenField01.setAttribute("name", "DrafterCode");
	hiddenField01.setAttribute("value", "<%=sessionEmpNo%>");	
	form.appendChild(hiddenField01);
	
	var hiddenField02 = document.createElement("input");
	hiddenField02.setAttribute("type", "hidden");
	hiddenField02.setAttribute("name", "FormID");
	hiddenField02.setAttribute("value", "JHOMS160070008591000,LINK001");
	form.appendChild(hiddenField02);
	
	var hiddenField03 = document.createElement("input");
	hiddenField03.setAttribute("type", "hidden");
	hiddenField03.setAttribute("name", "LinkageKey");
	hiddenField03.setAttribute("value", "B02");
	form.appendChild(hiddenField03);
	
	var hiddenField04 = document.createElement("input");
	hiddenField04.setAttribute("type", "hidden");
	hiddenField04.setAttribute("name", "LinkageSub1");
	hiddenField04.setAttribute("value", "<%=com_code%>");
	form.appendChild(hiddenField04);
	
	var LinkageSub2 = document.createElement("input");
	LinkageSub2.setAttribute("type", "hidden");
	LinkageSub2.setAttribute("name", "LinkageSub2");
	LinkageSub2.setAttribute("value", "<%=CommonUtil.nvl(_rowData.get("USR_USER_ID"))%>");
	form.appendChild(LinkageSub2);
	
	var LinkageSub3 = document.createElement("input");
	LinkageSub3.setAttribute("type", "hidden");
	LinkageSub3.setAttribute("name", "LinkageSub3");
	LinkageSub3.setAttribute("value", "");
	form.appendChild(LinkageSub3);
	
	var LinkageSub4 = document.createElement("input");
	LinkageSub4.setAttribute("type", "hidden");
	LinkageSub4.setAttribute("name", "LinkageSub4");
	LinkageSub4.setAttribute("value", "");
	form.appendChild(LinkageSub4);
	
	var LinkageSub5 = document.createElement("input");
	LinkageSub5.setAttribute("type", "hidden");
	LinkageSub5.setAttribute("name", "LinkageSub5");
	LinkageSub5.setAttribute("value", "");
	form.appendChild(LinkageSub5);			
	
	var hiddenField05 = document.createElement("input");
	hiddenField05.setAttribute("type", "hidden");
	hiddenField05.setAttribute("name", "SancTitle");
	if(st_dept == '123' && buyer_ho_yn == 'Y') { // 스마트팀의 경우 고객사 지정 품의 시 제목변경
		hiddenField05.setAttribute("value", "[koreab2b] 지정협력사 등록 품의");	
	} else {
		hiddenField05.setAttribute("value", "[koreab2b] 신규협력사 등록 품의");	
	}
	form.appendChild(hiddenField05);
	
	var SacnBodyType = document.createElement("input");
	SacnBodyType.setAttribute("type", "hidden");
	SacnBodyType.setAttribute("name", "SacnBodyType");
	SacnBodyType.setAttribute("value", "TEXT");
	form.appendChild(SacnBodyType);	
	
	var hiddenField06 = document.createElement("input");
	hiddenField06.setAttribute("type", "hidden");
	hiddenField06.setAttribute("name", "SancBody");
	hiddenField06.setAttribute("value", bodyContents);
	form.appendChild(hiddenField06);
	
	var AttachYN = document.createElement("input");
	AttachYN.setAttribute("type", "hidden");
	AttachYN.setAttribute("name", "AttachYN");
	AttachYN.setAttribute("value", "N");
	form.appendChild(AttachYN);
	
	var AttachInfo = document.createElement("input");
	AttachInfo.setAttribute("type", "hidden");
	AttachInfo.setAttribute("name", "AttachInfo");
	AttachInfo.setAttribute("value", "");
	form.appendChild(AttachInfo);
	
	document.charset="UTF-8";
	document.body.appendChild(form);
	form.submit();
	
	// 그룹웨어 전송 후 캐릭터 셋 복원
	document.charset="utf-8";
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}

//팝업 함수호출
function doPop(str, item, val1, val2, val3, val4, val5) {
	popupSel = str;
	popupItem = item;
	switch (str) {
		/* case "zipcode":					// ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
			openSearchPopup("/common/zipCodeSearchPop.do", "?1=1", "500,666,no");			
			break; */
		case "newzipcode":					//우편번호 검색
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");			
			break;
		case "itmg":						// 대리점권보유품목
			// 강수미 or 박지수
			if ($("#st_user_id").val() != "KEP2129083" && $("#st_user_id").val() != "KEP2239041") {
				alert("취급가능 품목 변경 불가능 합니다.");
				return;
			}
			openSearchPopup("/coco/getCommonCoCoTranGoodsPop.do", "", "600,500,no");
			break;
		case "kepBuyer":				//Kep 경우협력사선택
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;	
		case "itmMk":					// 대리점권보유 메이커명
			// 강수미 or 박지수
			if ($("#st_user_id").val() != "KEP2129083" && $("#st_user_id").val() != "KEP2239041") {
				alert("대리점권 보유 메이커명 변경 불가능 합니다.");
				return;
			}
			if ($("#st_itm_mk_yn").is(":checked")) {
				alert("대리점권 보유 메이커 해당없음을 해제 하십시오");
				return;
			}
			openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
			break;
		case "bankcode":				// 은행조회
			openSearchPopup("/common/bankCodePop.do", "", "500,500,no");
			break;	
		case "fileUpload":				//파일업로드
			if ($("#st_itm_mk_yn").is(":checked")) {
				alert("대리점권 보유 메이커 해당없음을 해제 하십시오");
				return;
			}
			
			if ($("#st_itm_mk"+popupItem).val() == "") {
				alert("대리점권 보유 메이커를 선택하여 주십시요.");
				return;
			}
			openSearchPopup("/common/fileUploadPop.do","?DOC_NO="+$("#st_itm_mk"+popupItem+"_image_key").val(), "500,430,no");	
			break;
		case "fileUpload2":				//파일업로드
			openSearchPopup("/common/fileUploadPop.do","?DOC_NO="+$("#st_image_key").val(), "500,430,no");
			break;
		case "sg_name": // SG지정
			openSearchPopup("/mprq/showMasterMpRqSgChoicePop.do", "", "500,500,no");
			break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	switch (popupSel) {
		case "itmg":				// 대리점권보유품목
			$("#st_itmg" + popupItem + "_cd").val(code);
			$("#st_itmg" + popupItem + "_nm").val(text);
			break;
		case "itmMk":			// 대리점권보유 메이커명
			$("#st_itm_mk" + popupItem).val(code);
			$("#st_itm_mk" + popupItem + "_nm").val(text);
			$("#st_itm_mk" + popupItem + "_yn").attr("disabled", false);
			break;	
		case "kepBuyer":		//Kep 경우협력사선택
			$("#st_kep_buyer" + popupItem).val(code);
			$("#st_kep_buyer_name" + popupItem).val(text);
			break;	
		case "bankcode":			//은행 검색
			$("#st_bank_cd").val(code);
			$("#st_bank_name").val(text);
			break;
		case "fileUpload":					//파일업로드
			$("#st_itm_mk" +popupItem + "_image_key").val(code);
			break;
		case "fileUpload2":					//파일업로드
			$("#st_image_key").val(code);
			break;
		case "sg_name":					// SG지정
			$("#st_sg_code").val(code);
			$("#st_sg_name").val(text);
			break;
	}
}

function setItmMkYn(str) {
	$("#st_itm_mk" + str + "_yn").attr("disabled", true);
}
/* // ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
function setZipPopupReturn(str_zipcode, str_zip_key, str_sido, str_gugun, str_roadNm, str_buildingNo, str_buildingName, str_dong) {
	if (popupItem == "COM") {
		$("#st_zip_code").val(str_zipcode);
		$("#st_zip_key").val(str_zip_key);
		$("#st_address").val(str_sido + " " + str_gugun + " " + str_roadNm + " " + str_buildingNo);
		$("#st_address_dt").val(str_buildingName);
	} else {
		$("#st_usr_zip_code").val(str_zipcode);
		$("#st_usr_zip_key").val(str_zip_key);
		$("#st_usr_address").val(str_sido + " " + str_gugun + " " + str_roadNm + " " + str_buildingNo);
		$("#st_usr_address_dt").val(str_buildingName);
	}
}
 */
 
function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
	if (popupItem == "COM") {
		$("#st_zip_code").val(zipNo.replace(/[^0-9]/gi, ''));
		$("#st_zip_key").val(bdMgtSn);
		$("#st_address").val(roadAddrPart1 + " " + roadAddrPart2);
		$("#st_address_dt").val(addrDetail);
		$("#st_address_loc").val(roadAddrPart1 + " " + roadAddrPart2 +  " "+ addrDetail);
	} else {
		$("#st_usr_zip_code").val(zipNo.replace(/[^0-9]/gi, ''));
		$("#st_usr_zip_key").val(bdMgtSn);
		$("#st_usr_address").val(roadAddrPart1 + " " + roadAddrPart2);
		$("#st_usr_address_dt").val(addrDetail);
	}
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	
	if (pMethod == "save") {
		if (sMsg == 'OK') {
			if (actionFlag == 'T') {
				opener.setPopupReturn("OK");
				window.close();
				return;
			}
			alert("저장 되었습니다");
			opener.setPopupReturn("OK");
			window.close();
            return;
		} else {
			alert("저장중 오류가 발생 했습니다\n\n관리자에게 문의 하세요!");
            return;
		}
	} else if (pMethod == "del") {
		if (sMsg == 'OK') {
			alert("공급사 삭제 처리 하였습니다");
			opener.setPopupReturn("OK");
			self.close();
		} else {
			alert("공급사 삭제중 오류가 발생 하였습니다\n\n관리자에게 문의 하시기 바랍니다");
		}
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}

function setAvl(type) {
	var type_text = "";

	if (type == "C") {
		type_text="승인";
	} else if (type == "D") {
		type_text="취소";
	}  

   return confirm("해당 공급사를, AVL"+type_text+" 하시겠습니까?");
}  

function checkPhoneNumber(str) {
	for(var i=2; i <= 3 ; i++){
		if (isEmpty($("#"+str+i).val())) {
			alert("전화번호를 입력 하여 주십시오");
			$("#"+str+i).focus();
			return false;
		}

		if (i == 2 && $("#"+str+i).val().length < 3 ) {
			alert("국번을 정확히 입력 해주세요");
			$("#"+str+i).val().focus();
			return false;

		} else if (i == 3 && $("#"+str+i).val().length != 4 ) {
			alert("전화번호를 정확히 입력 해주세요");
			$("#"+str+i).val().focus();
			return false;
		}
	}
	return true;
}

function checkUserInfo() {

	if (isEmpty($("#st_usr_name_loc").val())) {
		alert("사용자 명을 입력 하여 주십시오.");
		$("#st_usr_name_loc").focus();
		return false;
	}

	if (!checkPhoneNumber("st_phone")) { return false; }
	if (!checkPhoneNumber("st_fax_no")) { return false; }

	if (isEmpty($("#st_usr_email").val())) {
		alert("E-Mail 주소를 입력해 주십시오.");
		$("#st_usr_email").focus();
		return false;
	}
	
	if (!checkemail("st_usr_email")) { return false; }
	if (!checkPhoneNumber("st_usr_mobile")) { return false; }

	if (isEmpty($("#st_de_emp_nm").val())) {
		alert("납기관리 담당자명을 입력 하여 주십시오.");
		$("#st_de_emp_nm").focus();
		return  false;
	}

	if (!checkPhoneNumber("st_de_emp_tel")) { return false; }
	
	if (isEmpty($("#st_usr_zip_code").val())) {
		alert("사용자주소 우편번호를 입력 하세요.");
		$("#st_usr_zip_code").focus();
		return false;
	}

	if (isEmpty($("#st_usr_zip_key").val())) {
		alert("사용자주소를 도로명 주소로 변경 바랍니다.");
		$("#st_usr_zip_code").focus();
		return false;
	}

	if (isEmpty($("#st_usr_address").val())) {
		alert("사용자 주소를 입력 하세요.");
		$("#st_usr_address").focus();
		return false;
	}

	return true;
}

function checkCompanyInfo() {

	if (isEmpty($("#st_com_name_loc").val())){
		alert("한글 회사명을 입력해주세요.");
		$("#st_com_name_loc").select();
		return false;
	}

	if (isEmpty($("#st_com_name_eng").val())){
		alert("영문 회사명을 입력해주세요.");
		$("#st_com_name_eng").select();
		return false;
	}
	
	if (kepTrimStr($("#st_com_name_eng").val()).length < chkKorea(kepTrimStr($("#st_com_name_eng").val()))) {
		alert("영문회사명을 영문으로 입력해 주십시요.");
		$("#st_com_name_eng").select();
		return false;
	}

	if (kepTrimStr($("#st_com_name_eng").val()).length < 1) {
		alert("영문 회사명을 입력해 주십시오");
		$("#st_com_name_eng").select();
		return false;
	}

	if (!checkSpecialChar(kepTrimStr($("#st_com_name_eng").val()))) {
		alert("영문 회사명에 특수기호(%,$,&,*,@,!,#)를 사용 할수 없습니다.");
		$("#st_com_name_eng").select();
		return false;
	}
	
	<% if (!simsaLevel.equals("3")) { %>
	var irsLength = new Array();
	irsLength[0] = 3;
	irsLength[1] = 2;
	irsLength[2] = 5;

	for (var i=1; i <= 3 ; i++) {
		if(isEmpty($("#st_irs_no"+i).val())){
			alert('사업자 등록 번호를 입력 하여 주십시오');
			$("#st_irs_no"+i).focus();
			return false;
		}
		

		if($("#st_irs_no"+i).val().length != irsLength[i-1] ) { 
			alert("사업자등록번호 "+i+"번째는 숫자로 "+irsLength[i-1]+"자리 입니다.");
			$("#st_irs_no"+i).val("");
			$("#st_irs_no"+i).focus();
			return false;
		}
	}
	
//	if (!KepBizNoCheckStr2($("#st_irs_no1").val() + $("#st_irs_no2").val() + $("#st_irs_no3").val())) {
// 	if (KepBizNoCheckStr($("#st_irs_no1").val() + $("#st_irs_no2").val() + $("#st_irs_no3").val())) {
//		alert("사업자 등록번호가 유효하지 않습니다.");
//		$("#st_irs_no1").focus();
//		return false;
//	} 
	
	<% } %>
	if(["80", "81", "82", "86", "87"].includes($("#st_irs_no2").val()) && $("#st_reg_type").val() == "P") {
		alert("입력하신 사업자등록번호는 법인사업자 번호입니다.\n등록구분을 법인으로 변경해주세요.");
		$("#st_irs_no2").focus();
		return false;
	}
	
	if(isEmpty($("#st_industry_type").val()))  {
		alert("업태를 입력해 주십시요.");
		$("#st_industry_type").focus();
		return false;
	}

	if(isEmpty($("#st_business_items").val())) {
		alert("종목을 입력해 주십시요.");
		$("#st_business_items").focus();
		return false;
	}

	if(isEmpty($("#st_ceo_name_loc").val()))  {
		alert("대표자명을 입력해주세요.");
		$("#st_ceo_name_loc").focus();
		return false;
	}
	
	$("#st_establish_date").val( $("#establish_date").val().replace(/[/]/gi, ""));

	for (i=1; i <= 3 ; i++) {
		if (isEmpty($("#st_tel_no"+i).val())) {
			alert('대표번호를 입력 하여 주십시오');
			$("#st_tel_no"+i).focus();
			return false;
		}
	}

// 	if (isEmpty($("#st_kep_damdang_id").val())) {
// 		alert("KEP 담당자를 선택 하여주십시오");
// 		return false;
// 	}

	if(isEmpty($("#st_zip_code").val())){
		alert("본사 우편번호를 선택 하여주십시오");
		$("#st_zip_code").focus();
		return false;
	}

	if (isEmpty($("#st_zip_key").val())) {
		alert("본사 주소를 도로명 주소로 변경 바랍니다.");
		$("#st_zip_code").focus();
		return false;
	}

	if (isEmpty($("#st_address").val())) {
		alert("본사 우편번호를 선택 하여주십시오");
		$("#st_address").focus();
		return false;
	}

	return true;
}

function checkSubmit(Flag) {

	$("#st_SaveFlag").val(Flag);
	
	if (!checkCompanyInfo()) { // 회사정보 체크
		return false;
	}
	
	if ($("#simsaLevel").val() != "3") {
		if (!checkUserInfo()) { //사용자 정보체크
			return false;
		}	
	}

	var itmgSelectCount = 0;
	for (var i=1; i <= 5; i++) {
		if (!isEmpty($("#st_itmg"+i+"_cd").val())) {
			itmgSelectCount++;
		}
	}
	
	var makerSelectCount = 0;
	if (!$("#st_itm_mk_yn").is(":checked")) {
		
		for (var i=1; i < 11; i++) {
			if ($("#st_itm_mk" + i).val() != "") {
				makerSelectCount++;
			}
		}

		if (makerSelectCount < 1 ) {
			alert("대리점권 보유 메이커를 1개 이상 선택 해주십시오");
			return false;
		}
	}

	for (var i=1; i < 11; i++) {
		if (!isEmpty($("#st_itm_mk"+i).val())) {
			if ($("#st_itm_mk"+i+"_yn option:selected").val() == "") {
				alert($("#st_itm_mk"+i+"_nm").val() + "의 대리점권보유메이커명을 선택하십시오");
				$("#st_itm_mk"+i+"_nm").focus();
				return false;
			}   
		}
	}
	
// 	if ( !$("#st_mp_business_yn").is(":checked")	&& !$("#st_mp1_business_yn").is(":checked") && !$("#st_mp2_business_yn").is(":checked") && !$("#st_mp3_business_yn").is(":checked") && !$("#st_mp4_business_yn").is(":checked") && 
// 		!$("#st_mp5_business_yn").is(":checked")	) {
// 		alert("타 마켓 플레이스 거래 여부를 체크 해 주십시오");
// 		return false;
// 	}
	
	if (!$("#mail_send_flag1").is(":checked") && !$("#mail_send_flag2").is(":checked")) {
		alert("메일 수신 여부를 선택 해주세요");
		return false;
	}
	
	$("#st_mail_send_flag").val($("input[name=mail_send_flag]:checked").val());

	if(!$("#sms_recv_flag1").is(":checked") && !$("#sms_recv_flag2").is(":checked")) {
		alert("SMS 메세지 수신 여부를 선택 해주세요");
		return false;
	}

	$("#st_sms_recv_flag").val($("input[name=sms_recv_flag]:checked").val());
	
	if ($("#st_ceo_career option:selected").val() == "") {
		alert("대표자 동종업계 경력을 선택 하세요");
		return false;
	}
	
	if ($("#st_biz_type option:selected").val() == "") {
		alert("유통레벨을 선택 하세요");
		return false;
	}

	if ($("#st_emp_cnt option:selected").val() == "" ) {
		alert("상시근로자수를 선택 하세요");
		return false;
	}
	
	/*
	if ($("#st_agency_yn option:selected").val() == "" ) {
		alert("대리점권 여부를 선택 하세요");
		return false;
	}
	*/
	
	if ($("#st_iso_yn option:selected").val() == "" ) {
		alert("ISO 보유여부를 선택 하세요");
		return false;
	}

	if ($("#st_license_yn option:selected").val() == "" ) {
		alert("특허 보유여부를 선택 하세요");
		return false;
	}

	if ($("#st_year_amt option:selected").val() == "" ) {
		alert("전년도 매출액을 선택 하세요");
		return false;
	}
	
	if ($("#st_capt_amt option:selected").val() == "" ) {
		alert("총자본금을 선택 하세요");
		return false;
	}

	if ($("#st_deliv_equip_cnt option:selected").val() == "") {
		alert("배송차량 수를 선택 하세요");
		return false;
	}
	
	if (isEmpty(kepTrimStr($("#st_ac_emp_nm").val()))) {
		alert("경리 담당자를 입력 해주십시오");
		$("#st_ac_emp_nm").focus();
		return;
	}

	if (isEmpty(kepTrimStr($("#st_ac_emp_tel").val()))) {
		alert("경리 담당자 전화번호를 입력 해주십시오");
		$("#st_ac_emp_tel").focus();
		return;
	}
	
	if (isEmpty(kepTrimStr($("#st_gr_emp_nm").val()))) {
		alert("영업 담당자를 입력 해주십시오");
		$("#st_gr_emp_nm").focus();
		return;
	}

	if (isEmpty(kepTrimStr($("#st_gr_emp_tel").val()))) {
		alert("영업 담당자 전화번호를 입력 해주십시오");
		$("#st_gr_emp_tel").focus();
		return;
	}
	
	if ($("#st_pay_terms").val() == "") {
		alert("지급조건을 선택해 주십시요.");
		$("#st_pay_terms").focus();
		return false;
	}
	
	if ($("#st_pay_type").val() == "") {
		alert("지급형태를 선택해 주십시요.");
		$("#st_pay_type").focus();
		return false;
	}

	if (isEmpty(kepTrimStr($("#st_bank_cd").val()))) {
		alert("은행을 선택 해주십시오");
		return;
	}

	if (isEmpty(kepTrimStr($("#st_bank_account_no").val()))) {
		alert("계좌번호를 입력 해주십시오");
		$("#st_bank_account_no").focus();
		return;
	}

	if (isEmpty(kepTrimStr($("#st_depositor").val()))) {
		alert("예금주명을 입력 해주십시오");
		$("#st_depositor").focus();
		return;
	}

	if (($("#simsaLevel").val() ==2 || $("#simsaLevel").val() == 3) && ($("#st_user_id").val() =="KEP200507" || $("#st_user_id").val()=="MASTER1" || $("#st_user_id").val()=="KEP200125")) {
		
		if ($("input[name=buyer_ho_yn]:checked").val() == "") {
			alert("고객사 지정여부를 선택 하세요");
			return false;
		}
		
		$("#st_buyer_ho_yn").val($("input[name=buyer_ho_yn]:checked").val());
	}
	
	if ($("#st_evl_user").val() == "Y") {
		
		if ( !$("#sp_type1").is(":checked") && !$("#sp_type2").is(":checked") && !$("#sp_type3").is(":checked") && !$("#sp_type4").is(":checked")) {
			alert("협력사 구분을 선택 하세요.  ");
			return false;
		}
		
		if ( !$("#credit_status1").is(":checked") && !$("#credit_status2").is(":checked") && !$("#credit_status3").is(":checked")) {
			alert("신용평가 여부를 선택 하세요.  ");
			return false;
		}
		
		if (isEmpty(kepTrimStr($("#st_sg_code").val()))) {
			alert("대표SG를 선택하세요.");
			$("#st_sg_code").focus();
			return;
		}
		if (isEmpty(kepTrimStr($("#st_lgstrate").val()))) {
			alert("물류수수료율을 입력하세요.");
			$("#st_lgstrate").focus();
			return;
		}
		if (!kepIsNumChkStr(kepTrimStr($("#st_lgstrate").val()),2)) {
			alert("물류수수료는 숫자만 입력가능합니다.");
			$("#st_lgstrate").focus();
			return;
		}
		
		if(Number(kepTrimStr($("#st_lgstrate").val())) < 2) {
			if(isEmpty(kepTrimStr($("#st_lgstrate_remark").val()))) {
				alert("수수료율이 2% 미만인 경우 수수료율 변경사유 입력 필수입니다.");
				$("#st_lgstrate_remark").focus();
				return false;
			}
		}
		if ( $("#st_end_date1").is(":checked")) {			
			if (isEmpty(kepTrimStr($("#st_lgst_end_date").val()))) {
				alert("협의기한 구분이 기한인 경우 협의 기한 입력바랍니다.");
				$("#st_lgst_end_date").focus();
				return false;
			}			
			if (!kepIsNumChkStr(kepTrimStr($("#st_lgst_end_date").val()),2)) {
				alert("협의 기한은 숫자만 입력가능합니다.");
				$("#st_lgst_end_date").focus();
				return;
			}
			if (kepTrimStr($("#st_lgst_end_date").val()).length != 6) {
				alert("협의 기한 형식 오류.");
				$("#st_lgst_end_date").focus();
				return;
			}
			if(Number(kepTrimStr($("#st_lgst_end_date").val())) < Number(toCompactDate()) ) {
				alert("협의기한이 과거날짜입니다.");
				return;
			}
			var end_date_mm = Number(kepTrimStr($("#st_lgst_end_date").val()).substr(4,2));	
			if(end_date_mm < 1 || end_date_mm > 12) {
				alert("협의기한 월 확인바랍니다.");				
				return;
			}
		}
		
		if ($("#sp_type1").is(":checked")){
			if(isEmpty(kepTrimStr($("#st_e_contract_date").val()))){
				alert("전자계약 계약일자를 입력하시기 바랍니다.");
				$("#st_e_contract_date").focus();
				return false;
			}
		}		
		
		if (isEmpty(kepTrimStr($("#st_e_contract_user").val()))) {
			alert("계약담당자를 입력 해주십시오");
			$("#st_e_contract_user").focus();
			return;
		}
		
		if (isEmpty(kepTrimStr($("#st_e_contract_mail").val()))) {
			alert("계약담당자 이메일을 입력 해주십시오");
			$("#st_e_contract_mail").focus();
			return;
		}
		
		if (!checkemail("st_e_contract_mail")) { return; }
		if (!checkPhoneNumber("st_cont_emp_mobile")) { return; }
		
		$("#st_sp_type").val($("input[name=sp_type]:checked").val());
		$("#st_credit_status").val($("input[name=credit_status]:checked").val());
	}
	
	<% if (!simsaLevel.equals("1")) { %>
		if($("input[name=sp_type]:checked").val() == "T" || $("input[name=sp_type]:checked").val() == "E"){
			// 박지수(KEP2129083) 변경 2024.09.13 by HSJ
			// 강수미(KEP2239041) 추가 2025.11.28 by HSJ
			if($("#st_user_id").val() != "KEP2129083" && $("#st_user_id").val() != "KEP2239041"){
				alert("정규 외 선택은 협력사관리자에게 문의 바랍니다.");
				return false;
			}
		}
	<%}%>
	
	//납품가능 지역 데이터 셋팅
	var tmpChoiceArea = "";
	var tot_cnt = $("#st_cmpy_dely_cnt").val();
	for(var i = 0; i < tot_cnt; i++){
		var box = eval("document.forms.contentForm.st_dely_area_flag"+i);
		if(box.checked == true){
			tmpChoiceArea += "Y";
		}else{
			tmpChoiceArea += "N";
		}
	}
	//납품가능지역 데이터 셋팅
	$("#st_cmpy_dely_area").val(tmpChoiceArea);
	var confir = "";
    if (Flag == "T") {
    	if (isEmpty(kepTrimStr($("#st_ac_emp_email").val()))) {
			alert("경리 담당자 이메일을 입력 해주십시오");
			$("#st_ac_emp_email").focus();
			return;
		}

		if (!checkemail("st_ac_emp_email")) { return; }
		if (!checkPhoneNumber("st_ac_emp_mobile")) { return; }

		if (isEmpty(kepTrimStr($("#st_gr_emp_email").val()))) {
			alert("영업 담당자 이메일을 입력 해주십시오");
			$("#st_gr_emp_email").focus();
			return;
		}

		if (!checkemail("st_gr_emp_email")) { return; }
		if (!checkPhoneNumber("st_gr_emp_mobile")) { return; }
		confir = confirm("협력사 승인 품의를 진행하시겠습니까?");
    } else {
    	confir = confirm("협력회원사 및 Admin 사용자를 수정 하시겠습니까?");
    }

	return confir;
}

function checkMp (obj) {
	if (obj.checked) {
		for (var i=1; i <=5 ; i++) {
			$("#st_mp"+i+"_business_yn").attr("checked", false);
			$("#st_mp"+i+"_business_yn").attr("disabled", true);
		}
	} else {
		for (var i=1; i <=5 ; i++) {
			$("#st_mp"+i+"_business_yn").attr("checked", false);
			$("#st_mp"+i+"_business_yn").attr("disabled", false);
		}
	}
}

function checkSpecialChar(str) {
	for (var i=0 ; i < str.length; i++) {
		if (str.charAt(i) == '%' || str.charAt(i) == '$' || str.charAt(i) == '&' || str.charAt(i) == '*' || str.charAt(i) == '@' || str.charAt(i) == '! '|| str.charAt(i) == '#') {
			return false;
		}
	}
	return true;
}

function itmMkYn_chk() {
	if ($("#st_itm_mk_yn").is(":checked")) {
		for (var i = 1; i < 11; i++) {
			$("#st_itm_mk" + i + "_nm").val("");
			$("#st_itm_mk" + i).val("");
			$("#st_itm_mk" + i + "_yn").val("");
			$("#st_itm_mk" + i + "_yn").attr("disabled", true);
			$("#st_itm_mk" + i + "_image_key").val("");
		}
	}
}

function evaluation(){
	var item1 = $("input[name=st_value1]").val(); // 설립일자는 유지(DB에서 계산해오기 때문에)
	var item2 = $("#st_capt_amt").val();
	var item3 = $("#st_year_amt").val();
	var item4 = $("#st_emp_cnt").val();
	var item5 = $("#st_ceo_career").val();
	var item6 = $("#st_reg_type").val();
	
	// 자본금
	if(item2 == "CM01"){
		$("#captAmtPoint").html(5);
		$("input[name=st_value2]").val(5);
	}else if(item2 == "CM02"){
		$("#captAmtPoint").html(7);
		$("input[name=st_value2]").val(7);
	}else if(item2 == "CM03"){
		$("#captAmtPoint").html(9);
		$("input[name=st_value2]").val(9);
	}else if(item2 == "CM04"){
		$("#captAmtPoint").html(10);
		$("input[name=st_value2]").val(10);
	}
	
	// 매출액
	if(item3 == "YA01"){
		$("#salesAmtPoint").html(10);
		$("input[name=st_value3]").val(10);
	}else if(item3 == "YA02"){
		$("#salesAmtPoint").html(15);
		$("input[name=st_value3]").val(15);
	}else if(item3 == "YA03"){
		$("#salesAmtPoint").html(20);
		$("input[name=st_value3]").val(20);
	}else if(item3 == "YA04"){
		$("#salesAmtPoint").html(25);
		$("input[name=st_value3]").val(25);
	}
	
	// 상시근로자수
	if(item4 == "AA"){
		$("#empPoint").html(5);
		$("input[name=st_value4]").val(5);
	}else if(item4 == "AB"){
		$("#empPoint").html(12);
		$("input[name=st_value4]").val(12);
	}else if(item4 == "AC"){
		$("#empPoint").html(16);
		$("input[name=st_value4]").val(16);
	}else if(item4 == "AD"){
		$("#empPoint").html(20);
		$("input[name=st_value4]").val(20);
	}
	
	// 대표자 동종업계 경력
	if(item5 == "CC01"){
		$("#ceo_career_point").html(10);
		$("input[name=st_value5]").val(10);
	}else if(item5 == "CC02"){
		$("#ceo_career_point").html(12);
		$("input[name=st_value5]").val(12);
	}else if(item5 == "CC03"){
		$("#ceo_career_point").html(16);
		$("input[name=st_value5]").val(16);
	}else if(item5 == "CC04"){
		$("#ceo_career_point").html(20);
		$("input[name=st_value5]").val(20);
	}
	
	// 등록구분
	if(item6 == "P"){
		$("#reg_type_point").html(3);
		$("input[name=st_value6]").val(3);
	}else{
		$("#reg_type_point").html(5);
		$("input[name=st_value6]").val(5);
	}
	
	var new_item1 = eval($("input[name=st_value1]").val());
	var new_item2 = eval($("input[name=st_value2]").val());
	var new_item3 = eval($("input[name=st_value3]").val());
	var new_item4 = eval($("input[name=st_value4]").val());
	var new_item5 = eval($("input[name=st_value5]").val());
	var new_item6 = eval($("input[name=st_value6]").val());
	var new_total = eval($("input[name=st_value_tot]").val());
	
	new_total = new_item1 + new_item2 + new_item3 + new_item4 + new_item5 + new_item6;
	$("#totPoint").html(new_total);
	$("input[name=st_value_tot]").val(new_total);
	
}

function change_sp_type() {
	if ($("#sp_type3").is(":checked") || $("#sp_type4").is(":checked")) {
		$("#st_e_contract_kind").val("N");
		$("#st_e_contract_kind").attr("disabled", true);
	}else{
		$("#st_e_contract_kind").attr("disabled", false);
	}
}

function change_lgst_end_date() {
	if ($("#st_end_date2").is(":checked")) {
		$("#st_lgst_end_date").val("299912");
		$("#st_lgst_end_date").attr("disabled", true);
	}else{		
		$("#st_lgst_end_date").val("");
		$("#st_lgst_end_date").attr("disabled", false);
	}
}

function toCompactDate() { // 오늘날짜 yyyymm 형태로 구하기	
	var today = new Date();
	var yyyy = today.getFullYear();	
	var mm = String(today.getMonth() + 1).padStart(2, "0");		
	return yyyy+mm;
}

function handleChange(event) { // 고객지정 여부 변경 시(스마트팀 전용) 
	var st_dept = "<%=sessionDept%>";
	if(st_dept != null && st_dept == '123') { // 스마트팀만(123)
		if(event.target.value == 'Y') { // 고객지정 여부 지정으로 변경 시
			alert("삼성전자 지정협력사의 경우 관련 임직원 품의서 첨부 필수입니다.\n기안 품의 시 확인 바랍니다.")		
		}
	}
			
}


 //-->
</script> 
<body onload="kep_onload_view();">
<form name = "searchForm" id="searchForm" method = "post">
<!--HIDDEN-->
<!-- 공통 -->
<input type="hidden" id="upperId"  name="upperId" value="${param.upperId}">    	
<!-- 화면 내 정의 -->
<input type="hidden" name="com_code" id="com_code" value="<%=com_code%>">
<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
<input type="hidden" name="simsaLevel" id="simsaLevel" value = "<%=simsaLevel%>" />
</form>
	
<form name = "contentForm" id="contentForm" method = "post">
<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}" />
<input type="hidden" name="st_user_name" id="st_user_name" value="${sessionInfo.userNameLoc}" />
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>" />
<input type="hidden" name="simsaLevel" id="simsaLevel" value = "<%=simsaLevel%>" />
<input type="hidden" name="st_SaveFlag" id="st_SaveFlag"  value="" />

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:1000px;">
    	<div id="popHeader">
        	<h1 class="title">협력사정보 수정 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <% if (_rowData != null) { %>
        <div id="popContainer">
           	<!--grid-->
		  	<span class="text11 b">1. 일반사항(<span style="background:url(/resources/images/icn_star.gif) 10px 8px no-repeat; padding-left:20px;"></span>는 필수 입력사항입니다)</span><br>
		  	<p style="font-weight:bold;width:20%;float:left;">[회사현황]</p><p class="right pr10" style="font-weight:bold;float:right;">회사코드 : <%=com_code %></p>
	        	<table class="cont_t_list06" style="width:100%;">
					<caption>회사법인 정보관리 리스트</caption>
					<colgroup>
						<col width="160px" />
						<col width="300px" />
						<col width="150px" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="star">회원명(국문)</th>
							<td><input type="text" id="st_com_name_loc" name="st_com_name_loc" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC"))%>"  maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" /></td>
							<th scope="row" class="star">회원명(영문)</th>
							<td><input type="text" id="st_com_name_eng" name="st_com_name_eng" class="input_type_text"  title="" style="width:80%; ime-mode:disabled;" value="<%=CommonUtil.nvl(_rowData.get("COM_NAME_ENG"))%>" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" /></td>
						</tr>
						<tr>
							<th scope="row" class="star">사업자등록번호</th>
							<td>
							<% if (simsaLevel.equals("3")) { %>
								<%=CommonUtil.nvl(_rowData.get("IRS_NO1"))%>-<%=CommonUtil.nvl(_rowData.get("IRS_NO2"))%>-<%=CommonUtil.nvl(_rowData.get("IRS_NO3"))%>
								<input type="hidden"  id="st_irs_no1" name="st_irs_no1" value="<%=CommonUtil.nvl(_rowData.get("IRS_NO1"))%>" />
								<input type="hidden"  id="st_irs_no2" name="st_irs_no2" value="<%=CommonUtil.nvl(_rowData.get("IRS_NO2"))%>" />
								<input type="hidden"  id="st_irs_no3" name="st_irs_no3" value="<%=CommonUtil.nvl(_rowData.get("IRS_NO3"))%>" />
							<% } else { %>
								<input type="text" id="st_irs_no1" name="st_irs_no1" class="input_type_text" title="" style="width:18%;" value="<%=CommonUtil.nvl(_rowData.get("IRS_NO1"))%>"  maxlength="3" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
								-
								<input type="text" id="st_irs_no2" name="st_irs_no2" class="input_type_text" title="" style="width:15%;" value="<%=CommonUtil.nvl(_rowData.get("IRS_NO2"))%>"  maxlength="2" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
								-
								<input type="text" id="st_irs_no3" name="st_irs_no3" class="input_type_text" title="" style="width:21%;" value="<%=CommonUtil.nvl(_rowData.get("IRS_NO3"))%>"  maxlength="5" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
							<% } %>		
							</td>
							<th scope="row" class="star">등록구분</th>
							<td>
								<label for="st_reg_type" class="hidden">등록구분</label>
								<select name="st_reg_type" id="st_reg_type" style="width:100px;" onChange="evaluation()">
									<script type="text/javascript">kepAjaxCommonComboDataValue('st_reg_type', 'M109', '', '<%=CommonUtil.nvl(_rowData.get("REG_TYPE")) %>');</script>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row" class="star">업태</th>
							<td><input type="text" id="st_industry_type" name="st_industry_type" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("INDUSTRY_TYPE"))%>"  maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" /></td>
							<th scope="row" class="star">품목</th>
							<td><input type="text" id="st_business_items" name="st_business_items" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("BUSINESS_ITEMS"))%>" maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" /></td>
						</tr>
						<tr>
							<th scope="row" class="star">대표자명</th>
							<td><input type="text" id="st_ceo_name_loc" name="st_ceo_name_loc" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("CEO_NAME_LOC"))%>"  maxlength="40" onkeyup="fnCheckInputByte(this, 40);" onchange="fnCheckInputByte(this, 40);" /></td>
							<th scope="row" class="star">설립년도</th>
							<td>
								<input type="text" id="establish_date" name="establish_date" class="input_type_text" title="" style="width:50%;" maxlength="8" value="<%=CommonUtil.formatDate(_rowData.get("ESTABLISH_DATE"))%>" readonly />
								<input type="hidden" id="st_establish_date" name="st_establish_date" class="input_type_text" title="" style="width:80%;" maxlength="8" value="<%=CommonUtil.nvl(_rowData.get("ESTABLISH_DATE"))%>" readonly />
							</td>
						</tr>
						<tr>
							<th scope="row" class="star">대표자 동종업계 경력</th>
							<td>
								<label for="st_ceo_career" class="hidden">대표자 동종업계 경력</label>
								<select name="st_ceo_career" id="st_ceo_career" style="width:150px;" onChange="evaluation()">
									<script type="text/javascript">kepAjaxCommonComboDataValue('st_ceo_career', 'M128', 'SEL', '<%=CommonUtil.nvl(_rowData.get("CEO_CAREER")) %>');</script>
								</select>
							</td>
							<th scope="row" class="star">KeP담당자</th>
							<td>
								<input type="text" id="st_kep_damdang_id" name="st_kep_damdang_id" class="input_type_text" title="" style="width:50%;" value="<%=CommonUtil.nvl(_rowData.get("KEP_MAN_LOC"))%>" readonly  />
							</td>
						</tr>
						<tr>
							<th scope="row" class="star">대표전화번호</th>
							<td>
								<% 
		                      	String _telNo1 = "";
	                  			String _telNo2 = "";
	                  			String _telNo3 = "";	
		                      	if (!CommonUtil.nvl(_rowData.get("TEL_NO")).equals("")) {
		                      		_telNo1 = CommonUtil.nvl(_rowData.get("TEL_NO")).split("\\-")[0];
		                      		_telNo2 = CommonUtil.nvl(_rowData.get("TEL_NO")).split("\\-")[1];
		                      		_telNo3 = CommonUtil.nvl(_rowData.get("TEL_NO")).split("\\-")[2];
		                      	}
		                      	%>
								<select id="st_tel_no1" name="st_tel_no1" style="width:50px;">
									<option value="02"  <%=_telNo1.equals("02") ?"selected":""%>>02</option>
									<option value="031" <%=_telNo1.equals("031")?"selected":""%>>031</option>
									<option value="032" <%=_telNo1.equals("032")?"selected":""%>>032</option>
									<option value="033" <%=_telNo1.equals("033")?"selected":""%>>033</option>
									<option value="041" <%=_telNo1.equals("041")?"selected":""%>>041</option>
									<option value="042" <%=_telNo1.equals("042")?"selected":""%>>042</option>
									<option value="043" <%=_telNo1.equals("043")?"selected":""%>>043</option>
									<option value="044" <%=_telNo1.equals("044")?"selected":""%>>044</option>
									<option value="051" <%=_telNo1.equals("051")?"selected":""%>>051</option>
									<option value="052" <%=_telNo1.equals("052")?"selected":""%>>052</option>
									<option value="053" <%=_telNo1.equals("053")?"selected":""%>>053</option>
									<option value="054" <%=_telNo1.equals("054")?"selected":""%>>054</option>
									<option value="055" <%=_telNo1.equals("055")?"selected":""%>>055</option>
									<option value="061" <%=_telNo1.equals("061")?"selected":""%>>061</option>
									<option value="062" <%=_telNo1.equals("062")?"selected":""%>>062</option>
									<option value="063" <%=_telNo1.equals("063")?"selected":""%>>063</option>
									<option value="064" <%=_telNo1.equals("064")?"selected":""%>>064</option>
									<option value="070" <%=_telNo1.equals("070")?"selected":""%>>070</option>
									<option value="0303" <%=_telNo1.equals("0303")?"selected":""%>>0303</option>
									<option value="0502" <%=_telNo1.equals("0502")?"selected":""%>>0502</option>
									<option value="0504" <%=_telNo1.equals("0504")?"selected":""%>>0504</option>
									<option value="0505" <%=_telNo1.equals("0505")?"selected":""%>>0505</option>
									<option value="0506" <%=_telNo1.equals("0506")?"selected":""%>>0506</option>
									<option value="0507" <%=_telNo1.equals("0507")?"selected":""%>>0507</option>
								</select>
								- 
								<input type="text" id="st_tel_no2" name="st_tel_no2" class="input_type_text" title="" style="width:20%;" value="<%=_telNo2%>"  maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
								- 
								<input type="text" id="st_tel_no3" name="st_tel_no3" class="input_type_text" title="" style="width:20%;" value="<%=_telNo3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
							</td>
							<th scope="row" class="star">상시근로자수</th>
							<td>
								<label for="st_emp_cnt" class="hidden">상시근로자수</label>
								<select name="st_emp_cnt" id="st_emp_cnt" style="width:150px;" onChange="evaluation()">
									<script type="text/javascript">kepAjaxCommonComboDataValue('st_emp_cnt', 'M111', 'SEL', '<%=CommonUtil.nvl(_rowData.get("EMP_CNT")) %>');</script>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row" class="star">유통레벨</th>
							<td>
								<label for="st_biz_type" class="hidden">유통레벨</label>
								<select name="st_biz_type" id="st_biz_type" style="width:150px;">
									<script type="text/javascript">kepAjaxCommonComboDataValue('st_biz_type', 'M110', 'SEL', '<%=CommonUtil.nvl(_rowData.get("BIZ_TYPE")) %>');</script>
								</select>
							</td>
							<th></th>
							<td></td>
						</tr>
						<tr>
							<th class="padding">홈페이지주소</th>
							<td colspan="3"><input type="text" id="st_hp_address" name="st_hp_address" class="input_type_text" title="" style="width:92%;" value="<%=CommonUtil.nvl(_rowData.get("HP_ADDRESS")) %>" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" /></td>
						</tr>
						<tr>
							<th scope="row" class="star">우편번호</th>
							<td colspan="3">
								<input type="text" id="st_zip_code" name="st_zip_code" class="input_type_text" title="" style="width:70px;" readonly value="<%=CommonUtil.nvl(_rowData.get("ZIP_CODE")) %>" />
								<input type="hidden" id="st_zip_key" name="st_zip_key" value="<%=CommonUtil.nvl(_rowData.get("ZIP_KEY"))%>"/>
								<!-- <span class="btn_gray_05"  title="우편번호" ><a href="javascript:doPop('zipcode', 'COM');">우편번호 검색</a></span>	ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 -->
								<span class="btn_gray_05"  title="우편번호" ><a href="javascript:doPop('newzipcode', 'COM');">우편번호 검색</a></span>
							</td>
						</tr>
						<tr>
							<th scope="row" class="star">본사주소</th>
							<td colspan="3"><input type="text" id="st_address_loc" name="st_address_loc" class="input_type_text" title="" style="width:600px;" value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC")) %>" /></td>
							<td colspan="3"><input type="hidden" id="st_address" name="st_address" class="input_type_text" title="" style="width:600px;" value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC1")) %>" readonly /></td>
							<td colspan="3"><input type="hidden" id="st_address_dt" name="st_address_dt" class="input_type_text" title="" style="width:600px;" val ue="<%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC2")) %>" maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);"/></td>
						</tr>
					</tbody>
				</table>
				<% if (!simsaLevel.equals("3")) { %>
	            <p style="font-weight:bold;">[사용자 정보]</p>
	            <table class="cont_t_list06" style="width:100%;">
					<caption>사용자 정보</caption>
					<colgroup>
						<col width="130px" />
						<col width="30%" />
						<col width="130px" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="star">담당자명</th>
							<td>
								<input type="hidden" id="st_usr_user_id" name="st_usr_user_id" value="<%=CommonUtil.nvl(_rowData.get("USR_USER_ID")) %>"  />
								<input type="text" id="st_usr_name_loc" name="st_usr_name_loc" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("USER_NAME_LOC")) %>" maxlength="40" onkeyup="fnCheckInputByte(this, 40);" onchange="fnCheckInputByte(this, 40);"/>
							</td>
							<th scope="row" class="star">담당자 ID</th>
							<td><%=CommonUtil.nvl(_rowData.get("USR_USER_ID"))%></td>
						</tr>
						<tr>
							<th scope="row" class="star">전화번호</th>
							<td>
								<% 
		                      	String _phone1 = "";
	                  			String _phone2 = "";
	                  			String _phone3 = "";	
		                      	if (!CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).equals("")) {
		                      		_phone1 = CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-")[0];
		                      		_phone2 = CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-")[1];
		                      		_phone3 = CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-")[2];
		                      	}
		                      	%>
								<select id="st_phone1" name="st_phone1" style="width:50px;">
									<option value="02"  <%=_phone1.equals("02") ?"selected":""%>>02</option>
									<option value="031" <%=_phone1.equals("031")?"selected":""%>>031</option>
									<option value="032" <%=_phone1.equals("032")?"selected":""%>>032</option>
									<option value="033" <%=_phone1.equals("033")?"selected":""%>>033</option>
									<option value="041" <%=_phone1.equals("041")?"selected":""%>>041</option>
									<option value="042" <%=_phone1.equals("042")?"selected":""%>>042</option>
									<option value="043" <%=_phone1.equals("043")?"selected":""%>>043</option>
									<option value="044" <%=_phone1.equals("044")?"selected":""%>>044</option>
									<option value="051" <%=_phone1.equals("051")?"selected":""%>>051</option>
									<option value="052" <%=_phone1.equals("052")?"selected":""%>>052</option>
									<option value="053" <%=_phone1.equals("053")?"selected":""%>>053</option>
									<option value="054" <%=_phone1.equals("054")?"selected":""%>>054</option>
									<option value="055" <%=_phone1.equals("055")?"selected":""%>>055</option>
									<option value="061" <%=_phone1.equals("061")?"selected":""%>>061</option>
									<option value="062" <%=_phone1.equals("062")?"selected":""%>>062</option>
									<option value="063" <%=_phone1.equals("063")?"selected":""%>>063</option>
									<option value="064" <%=_phone1.equals("064")?"selected":""%>>064</option>
									<option value="070" <%=_phone1.equals("070")?"selected":""%>>070</option>
									<option value="0303" <%=_phone1.equals("0303")?"selected":""%>>0303</option>
									<option value="0502" <%=_phone1.equals("0502")?"selected":""%>>0502</option>
									<option value="0504" <%=_phone1.equals("0504")?"selected":""%>>0504</option>
									<option value="0505" <%=_phone1.equals("0505")?"selected":""%>>0505</option>
									<option value="0506" <%=_phone1.equals("0506")?"selected":""%>>0506</option>
									<option value="0507" <%=_phone1.equals("0507")?"selected":""%>>0507</option>
								</select>
								- 
								<input type="text" id="st_phone2" name="st_phone2" class="input_type_text" title="" style="width:20%;" value="<%=_phone2%>"  maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
								- 
								<input type="text" id="st_phone3" name="st_phone3" class="input_type_text" title="" style="width:20%;" value="<%=_phone3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
							</td>
							<th scope="row" class="star">팩스번호</th>
							<td>
								<% 
		                      	String _faxNo1 = "";
	                  			String _faxNo2 = "";
	                  			String _faxNo3 = "";	
		                      	if (!CommonUtil.nvl(_rowData.get("FAX_NO")).equals("")) {
		                      		_faxNo1 = CommonUtil.nvl(_rowData.get("FAX_NO")).split("\\-")[0];
		                      		_faxNo2 = CommonUtil.nvl(_rowData.get("FAX_NO")).split("\\-")[1];
		                      		_faxNo3 = CommonUtil.nvl(_rowData.get("FAX_NO")).split("\\-")[2];
		                      	}
		                      	%>
								<select id="st_fax_no1" name="st_fax_no1" style="width:50px;">
									<option value="02"  <%=_faxNo1.equals("02") ?"selected":""%>>02</option>
									<option value="031" <%=_faxNo1.equals("031")?"selected":""%>>031</option>
									<option value="032" <%=_faxNo1.equals("032")?"selected":""%>>032</option>
									<option value="033" <%=_faxNo1.equals("033")?"selected":""%>>033</option>
									<option value="041" <%=_faxNo1.equals("041")?"selected":""%>>041</option>
									<option value="042" <%=_faxNo1.equals("042")?"selected":""%>>042</option>
									<option value="043" <%=_faxNo1.equals("043")?"selected":""%>>043</option>
									<option value="044" <%=_faxNo1.equals("044")?"selected":""%>>044</option>
									<option value="051" <%=_faxNo1.equals("051")?"selected":""%>>051</option>
									<option value="052" <%=_faxNo1.equals("052")?"selected":""%>>052</option>
									<option value="053" <%=_faxNo1.equals("053")?"selected":""%>>053</option>
									<option value="054" <%=_faxNo1.equals("054")?"selected":""%>>054</option>
									<option value="055" <%=_faxNo1.equals("055")?"selected":""%>>055</option>
									<option value="061" <%=_faxNo1.equals("061")?"selected":""%>>061</option>
									<option value="062" <%=_faxNo1.equals("062")?"selected":""%>>062</option>
									<option value="063" <%=_faxNo1.equals("063")?"selected":""%>>063</option>
									<option value="064" <%=_faxNo1.equals("064")?"selected":""%>>064</option>
									<option value="070" <%=_faxNo1.equals("070")?"selected":""%>>070</option>
									<option value="0303" <%=_faxNo1.equals("0303")?"selected":""%>>0303</option>
									<option value="0502" <%=_faxNo1.equals("0502")?"selected":""%>>0502</option>
									<option value="0504" <%=_faxNo1.equals("0504")?"selected":""%>>0504</option>
									<option value="0505" <%=_faxNo1.equals("0505")?"selected":""%>>0505</option>
									<option value="0506" <%=_faxNo1.equals("0506")?"selected":""%>>0506</option>
									<option value="0507" <%=_faxNo1.equals("0507")?"selected":""%>>0507</option>
								</select>
								- 
								<input type="text" id="st_fax_no2" name="st_fax_no2" class="input_type_text" title="" style="width:20%;" value="<%=_faxNo2%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
								- 
								<input type="text" id="st_fax_no3" name="st_fax_no3" class="input_type_text" title="" style="width:20%;" value="<%=_faxNo3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
							</td>
								
						</tr>
						<tr>
							<th class="star">이메일</th>
							<td><input type="text" id="st_usr_email" name="st_usr_email" class="input_type_text" title="" style="width:92%;" value="<%=CommonUtil.nvl3(_rowData.get("EMAIL"), "") %>" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" /></td>
							<th scope="row" class="star">핸드폰번호</th>
							<td>
								<% 
		                      	String _mobile1 = "";
	                  			String _mobile2 = "";
	                  			String _mobile3 = "";	
		                      	if (!CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).equals("")) {
		                      		_mobile1 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[0];
		                      		_mobile2 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[1];
		                      		_mobile3 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[2];
		                      	}
		                      	%>
								<select id="st_usr_mobile1" name="st_usr_mobile1" style="width:50px;">
									<option value="010" <%=_mobile1.equals("010")?"selected":""%>>010</option>
									<option value="011" <%=_mobile1.equals("011")?"selected":""%>>011</option>
									<option value="016" <%=_mobile1.equals("016")?"selected":""%>>016</option>
									<option value="017" <%=_mobile1.equals("017")?"selected":""%>>017</option>
									<option value="018" <%=_mobile1.equals("018")?"selected":""%>>018</option>
									<option value="019" <%=_mobile1.equals("019")?"selected":""%>>019</option>

								</select>
								- 
								<input type="text" id="st_usr_mobile2" name="st_usr_mobile2" class="input_type_text" title="" style="width:20%;" value="<%=_mobile2%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
								- 
								<input type="text" id="st_usr_mobile3" name="st_usr_mobile3" class="input_type_text" title="" style="width:20%;" value="<%=_mobile3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
							</td>
						</tr>
						<tr>
							<th class="star">납기담당자</th>
							<td><input type="text" id="st_de_emp_nm" name="st_de_emp_nm" class="input_type_text" title="" style="width:92%;" value="<%=CommonUtil.nvl(_rowData.get("DE_EMP_NM")) %>" maxlength="20" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" /></td>
							<th scope="row" class="star">핸드폰번호</th>
							<td>
								<% 
		                      	String _empTel1 = "";
	                  			String _empTel2 = "";
	                  			String _empTel3 = "";	
		                      	if (!CommonUtil.nvl(_rowData.get("DE_EMP_TEL")).replaceAll("\\--","").equals("")) {
		                      		_empTel1 = CommonUtil.nvl(_rowData.get("DE_EMP_TEL")).split("\\-")[0];
		                      		_empTel2 = CommonUtil.nvl(_rowData.get("DE_EMP_TEL")).split("\\-")[1];
		                      		_empTel3 = CommonUtil.nvl(_rowData.get("DE_EMP_TEL")).split("\\-")[2];
		                      	}
		                      	%>
								<select id="st_de_emp_tel1" name="st_de_emp_tel1" style="width:50px;">
									<option value="010" <%=_empTel1.equals("010")?"selected":""%>>010</option>
									<option value="011" <%=_empTel1.equals("011")?"selected":""%>>011</option>
									<option value="016" <%=_empTel1.equals("016")?"selected":""%>>016</option>
									<option value="017" <%=_empTel1.equals("017")?"selected":""%>>017</option>
									<option value="018" <%=_empTel1.equals("018")?"selected":""%>>018</option>
									<option value="019" <%=_empTel1.equals("019")?"selected":""%>>019</option>

								</select>
								- 
								<input type="text" id="st_de_emp_tel2" name="st_de_emp_tel2" class="input_type_text" title="" style="width:20%;" value="<%=_empTel2%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
								- 
								<input type="text" id="st_de_emp_tel3" name="st_de_emp_tel3" class="input_type_text" title="" style="width:20%;" value="<%=_empTel3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
							</td>
						</tr>
						<tr>
							<th scope="row" class="star">사용자 우편번호</th>
							<td colspan="5">
								<input type="text" id="st_usr_zip_code" name="st_usr_zip_code" class="input_type_text" title="" style="width:70px;" readonly value="<%=CommonUtil.nvl(_rowData.get("USR_ZIP_CODE")) %>" />
								<input type="hidden" id="st_usr_zip_key" name="st_usr_zip_key" value="<%=CommonUtil.nvl(_rowData.get("USR_ZIP_KEY"))%>"/>
								<span class="btn_gray_05"  title="우편번호" ><a href="javascript:doPop('newzipcode', 'USR');">우편번호 검색</a></span>
							</td>
						</tr>
						<tr>
							<th scope="row" class="star">사용자 주소</th>
							<td colspan="5"><input type="text" id="st_usr_address" name="st_usr_address" class="input_type_text" title="" style="width:600px;" value="<%=CommonUtil.nvl(_rowData.get("USR_ADDRESS_LOC1")) %>" readonly /></td>
						</tr>
						<tr>
							<th scope="row" class="padding">사용자 상세주소</th>
							<td colspan="5"><input type="text" id="st_usr_address_dt" name="st_usr_address_dt" class="input_type_text" title="" style="width:600px;" value="<%=CommonUtil.nvl(_rowData.get("USR_ADDRESS_LOC2")) %>" maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);"/></td>
						</tr>
					</tbody>
				</table>
				<% } %>
				<span class="text11 b">2. 업체현황(<span style="background:url(/resources/images/icn_star.gif) 10px 8px no-repeat; padding-left:20px;"></span>는 필수 입력사항입니다)</span><br>
	        	<table  class="cont_t_list06" style="width:100%;">
					<caption>회사법인 정보관리 리스트</caption>
					<colgroup>
						<col width="145px" />
						<col width="147px" />
						<col width="147px" />
						<col width="147px" />
						<col width="147px" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
	                    	<th scope="row">첨부파일</th>
	                      	<td colspan="5">
	                      		<input type="hidden" id="st_image_key" name="st_image_key" class="input_type_text" title="" style="width:110px;" value="<%=CommonUtil.nvl(_rowData.get("IMAGE_KEY")) %>" />
	                      		<input type="hidden" id="st_image_key_Text" name="st_image_key_Text" class="input_type_text" title="" style="width:110px;" value="<%=CommonUtil.nvl(_rowData.get("IMAGE_KEY_TEXT")) %>" />
	                      		<span class="btn_gray_03"  title="파일첨부" ><a href="javascript:doPop('fileUpload2','<%=CommonUtil.nvl(_rowData.get("IMAGE_KEY")) %>')">파일첨부</a></span>
	                      		
	                      	</td>
	                    </tr>
	                    <tr>
							<th scope="row" class="padding">서류접수현황</th>
							<td colspan="5">
								<input type="checkbox" id="st_deal_contract_doc_yn_tmp"		name="st_deal_contract_doc_yn_tmp"	value="Y"	 <%=simsaLevel.equals("1") ? "disabled" : "" %> <%=_rowData.get("DEAL_CONTRACT_DOC_YN").equals("Y")?"checked":""%>> 물품거래기본계약서
								<input type="checkbox" id="st_biz_licence_doc_yn_tmp"		name="st_biz_licence_doc_yn_tmp"	value="Y"	 <%=simsaLevel.equals("1") ? "disabled" : "" %> <%=_rowData.get("BIZ_LICENCE_DOC_YN").equals("Y")?"checked":""%>> 사업자등록증
								<input type="checkbox" id="st_account_doc_yn_tmp"			name="st_account_doc_yn_tmp"		value="Y"	 <%=simsaLevel.equals("1") ? "disabled" : "" %> <%=_rowData.get("ACCOUNT_DOC_YN").equals("Y")?"checked":""%>> 결제계좌신고서
								<input type="checkbox" id="st_bankbook_copy_yn_tmp"			name="st_bankbook_copy_yn_tmp"		value="Y"	 <%=simsaLevel.equals("1") ? "disabled" : "" %> <%=_rowData.get("BANKBOOK_COPY_YN").equals("Y")?"checked":""%>> 통장사본
								<input type="checkbox" id="st_seal_cert_doc_yn_tmp"			name="st_seal_cert_doc_yn_tmp"		value="Y"	 <%=simsaLevel.equals("1") ? "disabled" : "" %> <%=_rowData.get("SEAL_CERT_DOC_YN").equals("Y")?"checked":""%>> 인감증명서 
								<input type="checkbox" id="st_using_seal_doc_yn_tmp"		name="st_using_seal_doc_yn_tmp"		value="Y"	 <%=simsaLevel.equals("1") ? "disabled" : "" %> <%=_rowData.get("USING_SEAL_DOC_YN").equals("Y")?"checked":""%>> 사용인감계
								
								<input type="hidden" id="st_deal_contract_doc_yn"		name="st_deal_contract_doc_yn"	value="<%=_rowData.get("DEAL_CONTRACT_DOC_YN").equals("Y")?"Y":""%>"> 
								<input type="hidden" id="st_biz_licence_doc_yn"			name="st_biz_licence_doc_yn"	value="<%=_rowData.get("BIZ_LICENCE_DOC_YN").equals("Y")?"Y":""%>"> 
								<input type="hidden" id="st_account_doc_yn"				name="st_account_doc_yn"		value="<%=_rowData.get("ACCOUNT_DOC_YN").equals("Y")?"Y":""%>"> 
								<input type="hidden" id="st_bankbook_copy_yn"			name="st_bankbook_copy_yn"		value="<%=_rowData.get("BANKBOOK_COPY_YN").equals("Y")?"Y":""%>"> 
								<input type="hidden" id="st_seal_cert_doc_yn"			name="st_seal_cert_doc_yn"		value="<%=_rowData.get("SEAL_CERT_DOC_YN").equals("Y")?"Y":""%>">  
								<input type="hidden" id="st_using_seal_doc_yn"			name="st_using_seal_doc_yn"		value="<%=_rowData.get("USING_SEAL_DOC_YN").equals("Y")?"Y":""%>"> 
							</td>
						</tr>
						<tr>
							<th scope="row" class="star">대리점권보유품목</th>
							<td>
								<input type="text" id="st_itmg1_nm" name="st_itmg1_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG1_NM")) %>" readonly />
								<input type="hidden" id="st_itmg1_cd" name="st_itmg1_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG1_CD")) %>" />
								<a href="javascript:doPop( 'itmg',  '1');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itmg1_cd','st_itmg1_nm');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
							<td>
								<input type="text" id="st_itmg2_nm" name="st_itmg2_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG2_NM")) %>"  readonly />
								<input type="hidden" id="st_itmg2_cd" name="st_itmg2_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG2_CD")) %>" />
								<a href="javascript:doPop( 'itmg',  '2');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itmg2_cd','st_itmg2_nm');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
							<td>
								<input type="text" id="st_itmg3_nm" name="st_itmg3_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG3_NM")) %>"  readonly />
								<input type="hidden" id="st_itmg3_cd" name="st_itmg3_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG3_CD")) %>" />
								<a href="javascript:doPop( 'itmg',  '3');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itmg3_cd','st_itmg3_nm');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
							<td>
								<input type="text" id="st_itmg4_nm" name="st_itmg4_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG4_NM")) %>"  readonly />
								<input type="hidden" id="st_itmg4_cd" name="st_itmg4_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG4_CD")) %>" />
								<a href="javascript:doPop( 'itmg',  '4');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itmg4_cd','st_itmg4_nm');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
							<td>
								<input type="text" id="st_itmg5_nm" name="st_itmg5_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG5_NM")) %>"  readonly  />
								<input type="hidden" id="st_itmg5_cd" name="st_itmg5_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG5_CD")) %>" />
								<a href="javascript:doPop( 'itmg',  '5');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itmg5_cd','st_itmg5_nm');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
						</tr>
						<tr>
							<th scope="row" class="star">대리점권보유<br>메이커명</th>
							<td>
								<input type="text"  id="st_itm_mk1_nm" name="st_itm_mk1_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK1_NM")) %>" />
								<input type="hidden"  id="st_itm_mk1" name="st_itm_mk1" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK1")) %>" />
								<a href="javascript:doPop( 'itmMk',  '1');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itm_mk1','st_itm_mk1_nm'); setItmMkYn('1');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
							<td>
								<input type="text" id="st_itm_mk2_nm" name="st_itm_mk2_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK2_NM")) %>" />
								<input type="hidden"  id="st_itm_mk2" name="st_itm_mk2" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK2")) %>" />
								<a href="javascript:doPop( 'itmMk',  '2');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itm_mk2','st_itm_mk2_nm'); setItmMkYn('2');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
							<td>
								<input type="text" id="st_itm_mk3_nm" name="st_itm_mk3_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK3_NM")) %>" />
								<input type="hidden"  id="st_itm_mk3" name="st_itm_mk3" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK3")) %>" />
								<a href="javascript:doPop( 'itmMk',  '3');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itm_mk3','st_itm_mk3_nm'); setItmMkYn('3');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
							<td>
								<input type="text" id="st_itm_mk4_nm" name="st_itm_mk4_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK4_NM")) %>" />
								<input type="hidden"  id="st_itm_mk4" name="st_itm_mk4" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK4")) %>" />
								<a href="javascript:doPop( 'itmMk',  '4');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itm_mk4','st_itm_mk4_nm'); setItmMkYn('4');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
							<td>
								<input type="text" id="st_itm_mk5_nm" name="st_itm_mk5_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK5_NM")) %>" />
								<input type="hidden"  id="st_itm_mk5" name="st_itm_mk5" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK5")) %>" />
								<a href="javascript:doPop( 'itmMk', '5');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itm_mk5','st_itm_mk5_nm'); setItmMkYn('5');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
						</tr>
						<tr>
							<th scope="row" class="star">유통레벨/대리점<br>계약서류</th>
							<td>
								
								<label for="st_itm_mk1_yn" class="hidden">--선택--</label>
								<select id="st_itm_mk1_yn" name="st_itm_mk1_yn" style="width:55%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK1_AGENCY_YN")).replaceAll("N","").equals("") ? "disabled":""%>>
									<script>kepAjaxCommonComboDataValue('st_itm_mk1_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK1_AGENCY_YN")) %>');</script>
								</select>
								<input type="hidden"  id="st_itm_mk1_image_key" name="st_itm_mk1_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK1_IMAGE_KEY")) %>" />
								<span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '1', '<%=CommonUtil.nvl(_rowData.get("ITM_MK1_IMAGE_KEY")) %>' ) ;">첨부등록</a></span>
							</td>
							<td>
								<label for="st_itm_mk2_yn" class="hidden">--선택--</label>
								<select name="st_itm_mk2_yn" id="st_itm_mk2_yn" style="width:55%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK2_AGENCY_YN")).replaceAll("N","").equals("") ? "disabled":""%>>
									<script>kepAjaxCommonComboDataValue('st_itm_mk2_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK2_AGENCY_YN")) %>');</script>
								</select>
								<input type="hidden"  id="st_itm_mk2_image_key" name="st_itm_mk2_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK2_IMAGE_KEY")) %>" />
								<span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '2', '<%=CommonUtil.nvl(_rowData.get("ITM_MK2_IMAGE_KEY")) %>' ) ;">첨부등록</a></span>
							</td>
							<td>
								<label for="st_itm_mk3_yn" class="hidden">--선택--</label>
								<select name="st_itm_mk3_yn" id="st_itm_mk3_yn" style="width:55%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK3_AGENCY_YN")).replaceAll("N","").equals("") ? "disabled" : ""%>>
									<script>kepAjaxCommonComboDataValue('st_itm_mk3_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK3_AGENCY_YN")) %>');</script>
								</select>
								<input type="hidden"  id="st_itm_mk3_image_key" name="st_itm_mk3_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK3_IMAGE_KEY")) %>" />
								<span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '3', '<%=CommonUtil.nvl(_rowData.get("ITM_MK3_IMAGE_KEY")) %>' ) ;">첨부등록</a></span>
							</td>
							<td>
								<label for="st_itm_mk4_yn" class="hidden">--선택--</label>
								<select name="st_itm_mk4_yn" id="st_itm_mk4_yn" style="width:55%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK4_AGENCY_YN")).replaceAll("N","").equals("") ? "disabled":""%>>
									<script>kepAjaxCommonComboDataValue('st_itm_mk4_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK4_AGENCY_YN")) %>');</script>
								</select>
								<input type="hidden"  id="st_itm_mk4_image_key" name="st_itm_mk4_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK4_IMAGE_KEY")) %>" />
								<span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '4', '<%=CommonUtil.nvl(_rowData.get("ITM_MK4_IMAGE_KEY")) %>' ) ;">첨부등록</a></span>
							</td>
							<td>
								<label for="st_itm_mk5_yn" class="hidden">--선택--</label>
								<select name="st_itm_mk5_yn" id="st_itm_mk5_yn" style="width:55%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK5_AGENCY_YN")).replaceAll("N","").equals("") ? "disabled":""%>>
									<script>kepAjaxCommonComboDataValue('st_itm_mk5_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK5_AGENCY_YN")) %>');</script>
								</select>
								<input type="hidden"  id="st_itm_mk5_image_key" name="st_itm_mk5_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK5_IMAGE_KEY")) %>" />
								<span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '5', '<%=CommonUtil.nvl(_rowData.get("ITM_MK5_IMAGE_KEY")) %>' ) ;">첨부등록</a></span>
							</td>
						</tr>
						<tr>
							<th scope="row" class="star">대리점권보유품목</th>
							<td>
								<input type="text" id="st_itmg6_nm" name="st_itmg6_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG6_NM")) %>" readonly />
								<input type="hidden" id="st_itmg6_cd" name="st_itmg6_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG6_CD")) %>" />
								<a href="javascript:doPop( 'itmg',  '6');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itmg6_cd','st_itmg6_nm');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
							<td>
								<input type="text" id="st_itmg7_nm" name="st_itmg7_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG7_NM")) %>"  readonly />
								<input type="hidden" id="st_itmg7_cd" name="st_itmg7_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG7_CD")) %>" />
								<a href="javascript:doPop( 'itmg',  '7');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itmg7_cd','st_itmg7_nm');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
							<td>
								<input type="text" id="st_itmg8_nm" name="st_itmg8_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG8_NM")) %>"  readonly />
								<input type="hidden" id="st_itmg8_cd" name="st_itmg8_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG8_CD")) %>" />
								<a href="javascript:doPop( 'itmg',  '8');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itmg8_cd','st_itmg8_nm');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
							<td>
								<input type="text" id="st_itmg9_nm" name="st_itmg9_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG9_NM")) %>"  readonly />
								<input type="hidden" id="st_itmg9_cd" name="st_itmg9_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG9_CD")) %>" />
								<a href="javascript:doPop( 'itmg',  '9');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itmg9_cd','st_itmg9_nm');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
							<td>
								<input type="text" id="st_itmg10_nm" name="st_itmg10_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITMG10_NM")) %>"  readonly  />
								<input type="hidden" id="st_itmg10_cd" name="st_itmg10_cd" value="<%=CommonUtil.nvl(_rowData.get("ITMG10_CD")) %>" />
								<a href="javascript:doPop( 'itmg',  '10');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itmg10_cd','st_itmg10_nm');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
						</tr>
						<tr>
						<tr>
							<th scope="row" class="star">대리권점보유<br>메이커명</th>
							<td>
								<input type="text"  id="st_itm_mk6_nm" name="st_itm_mk6_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK6_NM")) %>" />
								<input type="hidden"  id="st_itm_mk6" name="st_itm_mk6" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK6")) %>" />
								<a href="javascript:doPop( 'itmMk', '6');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itm_mk6','st_itm_mk6_nm'); setItmMkYn('6');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
							<td>
								<input type="text" id="st_itm_mk7_nm" name="st_itm_mk7_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK7_NM")) %>" />
								<input type="hidden"  id="st_itm_mk7" name="st_itm_mk7" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK7")) %>" />
								<a href="javascript:doPop( 'itmMk', '7');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itm_mk7','st_itm_mk7_nm'); setItmMkYn('7');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
							<td>
								<input type="text" id="st_itm_mk8_nm" name="st_itm_mk8_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK8_NM")) %>" />
								<input type="hidden"  id="st_itm_mk8" name="st_itm_mk8" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK8")) %>" />
								<a href="javascript:doPop( 'itmMk', '8');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itm_mk8','st_itm_mk8_nm'); setItmMkYn('8');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
							<td>
								<input type="text" id="st_itm_mk9_nm" name="st_itm_mk9_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK9_NM")) %>" />
								<input type="hidden"  id="st_itm_mk9" name="st_itm_mk9" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK9")) %>" />
								<a href="javascript:doPop( 'itmMk', '9');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itm_mk9','st_itm_mk9_nm'); setItmMkYn('9');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
							<td>
								<input type="text" id="st_itm_mk10_nm" name="st_itm_mk10_nm" class="input_type_text" title="" style="width:49%;" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK10_NM")) %>" />
								<input type="hidden"  id="st_itm_mk10" name="st_itm_mk10" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK10")) %>" />
								<a href="javascript:doPop( 'itmMk', '10');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itm_mk10','st_itm_mk10_nm'); setItmMkYn('10');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
						</tr>
						<tr>
							<th scope="row" class="star">유통레벨/대리점<br>계약서류</th>
							<td>
								<label for="st_itm_mk6_yn" class="hidden">--선택--</label>
								<select name="st_itm_mk6_yn" id="st_itm_mk6_yn" style="width:55%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK6_AGENCY_YN")).replaceAll("N","").equals("")?"disabled":""%>>
									<script>kepAjaxCommonComboDataValue('st_itm_mk6_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK6_AGENCY_YN")) %>');</script>
								</select>
								<input type="hidden"  id="st_itm_mk6_image_key" name="st_itm_mk6_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK6_IMAGE_KEY")) %>" />
								<span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '6', '<%=CommonUtil.nvl(_rowData.get("ITM_MK6_IMAGE_KEY")) %>' ) ;">첨부등록</a></span>
							</td>
							<td>
								<label for="st_itm_mk7_yn" class="hidden">--선택--</label>
								<select name="st_itm_mk7_yn" id="st_itm_mk7_yn" style="width:55%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK7_AGENCY_YN")).replaceAll("N","").equals("")?"disabled":""%>>
									<script>kepAjaxCommonComboDataValue('st_itm_mk7_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK7_AGENCY_YN")) %>');</script>
								</select>
								<input type="hidden"  id="st_itm_mk7_image_key" name="st_itm_mk7_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK7_IMAGE_KEY")) %>" />
								<span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '7', '<%=CommonUtil.nvl(_rowData.get("ITM_MK7_IMAGE_KEY")) %>' ) ;">첨부등록</a></span>
							</td>
							<td>
								<label for="st_itm_mk8_yn" class="hidden">--선택--</label>
								<select name="st_itm_mk8_yn" id="st_itm_mk8_yn" style="width:55%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK8_AGENCY_YN")).replaceAll("N","").equals("")?"disabled":""%>>
									<script>kepAjaxCommonComboDataValue('st_itm_mk8_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK8_AGENCY_YN")) %>');</script>
								</select>
								<input type="hidden"  id="st_itm_mk8_image_key" name="st_itm_mk8_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK8_IMAGE_KEY")) %>" />
								<span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '8', '<%=CommonUtil.nvl(_rowData.get("ITM_MK8_IMAGE_KEY")) %>' ) ;">첨부등록</a></span>
							</td>
							<td>
								<label for="st_itm_mk9_yn" class="hidden">--선택--</label>
								<select name="st_itm_mk9_yn" id="st_itm_mk9_yn" style="width:55%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK9_AGENCY_YN")).replaceAll("N","").equals("")?"disabled":""%>>
									<script>kepAjaxCommonComboDataValue('st_itm_mk9_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK9_AGENCY_YN")) %>');</script>
								</select>
								<input type="hidden"  id="st_itm_mk9_image_key" name="st_itm_mk9_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK9_IMAGE_KEY")) %>" />
								<span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '9', '<%=CommonUtil.nvl(_rowData.get("ITM_MK9_IMAGE_KEY")) %>' ) ;">첨부등록</a></span>
							</td>
							<td>
								<label for="st_itm_mk10_yn" class="hidden">--선택--</label>
								<select name="st_itm_mk10_yn" id="st_itm_mk10_yn" style="width:55%;" <%=CommonUtil.nvl(_rowData.get("ITM_MK10_AGENCY_YN")).replaceAll("N","").equals("")?"disabled":""%>>
									<script>kepAjaxCommonComboDataValue('st_itm_mk10_yn', 'M067', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ITM_MK10_AGENCY_YN")) %>');</script>
								</select>
								<input type="hidden"  id="st_itm_mk10_image_key" name="st_itm_mk10_image_key" value="<%=CommonUtil.nvl(_rowData.get("ITM_MK10_IMAGE_KEY")) %>" />
								<span class="btn_gray_02"><a href="javascript:doPop('fileUpload', '10', '<%=CommonUtil.nvl(_rowData.get("ITM_MK10_IMAGE_KEY")) %>' ) ;">첨부등록</a></span>
							</td>
						</tr>
						<tr>
							<td colspan="6" style="height:25px;"><span style="font-size:13px; color:red; font-weight:bold;">※ 대리권점 보유 메이커 해당 없음</span>&nbsp;<input type="checkbox" id="st_itm_mk_yn"  name="st_itm_mk_yn" value="Y" <%=CommonUtil.nvl(_rowData.get("ITM_MK_YN")).equals("Y")?"checked":""%> onclick="itmMkYn_chk();" /></td>
						</tr>
<!-- 						<tr> -->
<!-- 							<th scope="row" class="padding">타마켓플레이스 거래</th> -->
<!-- 							<td colspan="5"> -->
<%-- 								<input type="checkbox" id="st_mp1_business_yn" name="st_mp1_business_yn" <%=CommonUtil.nvl(_rowData.get("MP_BUSINESS_YN")).equals("Y")?"disabled":""%> <%=CommonUtil.nvl(_rowData.get("MP1_BUSINESS_YN")).equals("Y")?"checked":""%> value="Y" />&nbsp;IMK&nbsp;&nbsp;&nbsp;  --%>
<%-- 								<input type="checkbox" id="st_mp2_business_yn" name="st_mp2_business_yn" <%=CommonUtil.nvl(_rowData.get("MP_BUSINESS_YN")).equals("Y")?"disabled":""%> <%=CommonUtil.nvl(_rowData.get("MP2_BUSINESS_YN")).equals("Y")?"checked":""%> value="Y" />&nbsp;서브원&nbsp;&nbsp;&nbsp; --%>
<%-- 								<input type="checkbox" id="st_mp3_business_yn" name="st_mp3_business_yn" <%=CommonUtil.nvl(_rowData.get("MP_BUSINESS_YN")).equals("Y")?"disabled":""%> <%=CommonUtil.nvl(_rowData.get("MP3_BUSINESS_YN")).equals("Y")?"checked":""%> value="Y" />&nbsp;NtoB&nbsp;&nbsp;&nbsp; --%>
<%-- 								<input type="checkbox" id="st_mp4_business_yn" name="st_mp4_business_yn" <%=CommonUtil.nvl(_rowData.get("MP_BUSINESS_YN")).equals("Y")?"disabled":""%> <%=CommonUtil.nvl(_rowData.get("MP4_BUSINESS_YN")).equals("Y")?"checked":""%> value="Y" />&nbsp;Biz MRO&nbsp;&nbsp;&nbsp; --%>
<%-- 								<input type="checkbox" id="st_mp5_business_yn" name="st_mp5_business_yn" <%=CommonUtil.nvl(_rowData.get("MP_BUSINESS_YN")).equals("Y")?"disabled":""%> <%=CommonUtil.nvl(_rowData.get("MP5_BUSINESS_YN")).equals("Y")?"checked":""%> value="Y" />&nbsp;행복나래&nbsp;&nbsp;&nbsp; --%>
<%-- 								<input type="checkbox" id="st_mp_business_yn" name="st_mp_business_yn" <%=CommonUtil.nvl(_rowData.get("MP_BUSINESS_YN")).equals("Y")?"checked":""%> onclick="checkMp(this);" value="Y"/>&nbsp;해당없음&nbsp;&nbsp;&nbsp; --%>
<!-- 							</td> -->
<!-- 						</tr> -->
						<tr>
							<th scope="row" class="star">ISO여부</th>
							<td colspan="2">
								<label for="st_iso_yn" class="hidden">없음</label>
								<select name="st_iso_yn" id="st_iso_yn">
									<script>kepAjaxCommonComboDataValue('st_iso_yn', 'M112', 'SEL', '<%=CommonUtil.nvl(_rowData.get("ISO_YN")) %>');</script>
								</select>
							</td>
							<th scope="row" class="star">특허여부</th>
							<td colspan="2">
								<label for="st_license_yn" class="hidden">미보유</label>
								<select name="st_license_yn" id="st_license_yn">
									<script>kepAjaxCommonComboDataValue('st_license_yn', 'M113', 'SEL', '<%=CommonUtil.nvl(_rowData.get("LICENSE_YN")) %>');</script>
								</select>
							</td>
							
						</tr>
						<tr>
							<th scope="row" class="star">전년도 매출액</th>
							<td colspan="2">
								<label for="st_year_amt" class="hidden">전년도 매출액</label>
								<select name="st_year_amt" id="st_year_amt" onChange="evaluation()">
									<script>kepAjaxCommonComboDataValue('st_year_amt', 'M114', 'SEL', '<%=CommonUtil.nvl(_rowData.get("YEAR_AMT")) %>');</script>
								</select>
							</td>
							<th scope="row" class="star">총자본금</th>
							<td colspan="2">
								<label for="st_capt_amt" class="hidden">총자본금</label>
								<select name="st_capt_amt" id="st_capt_amt" onChange="evaluation()">
									<script>kepAjaxCommonComboDataValue('st_capt_amt', 'M129', 'SEL', '<%=CommonUtil.nvl(_rowData.get("CAPT_AMT")) %>');</script>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row" class="padding">주요거래처</th>
							<td colspan="5"><input type="text" id="st_major_com" name="st_major_com" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("MAJOR_COM"))%>"  maxlength="250" onkeyup="fnCheckInputByte(this, 250);" onchange="fnCheckInputByte(this, 250);"/></td>
						</tr>
						<tr>
							<th scope="row" class="padding">직납가능지역</th>
								<td colspan="5">
									<input type="hidden" id="st_cmpy_dely_area" name="st_cmpy_dely_area" value="<%=CommonUtil.nvl(_rowData.get("DELY_AREA"))%>" />
									<input type="hidden" id="st_cmpy_dely_cnt" name="st_cmpy_dely_cnt" value="<%=_dataAreaList.size()%>" />
								<%
									for (int j=0; j<_dataAreaList.size(); j++) {
										Map<String,String> rowDataAreaList = _dataAreaList.get(j);
								%>
										<input id="st_dely_area_flag<%=j%>" name="st_dely_area_flag<%=j%>" type="checkbox" value="" style="vertical-align:middle"> <%=CommonUtil.nvl(rowDataAreaList.get("TEXT1"))%>&nbsp;&nbsp;&nbsp;
										<%if((j > 0) && ((j+1)%6 == 0)){%>
											<br>
										<%}%>
									<%}%>
								</td>
						</tr>
						<tr>
							<th scope="row" class="padding">배송차량 수</th>
							<td colspan="2">
								<label for="st_deliv_equip_cnt" class="hidden">1~2대</label>
								<select name="st_deliv_equip_cnt" id="st_deliv_equip_cnt" style="width:100px;">
									<script>kepAjaxCommonComboDataValue('st_deliv_equip_cnt', 'M115', 'SEL', '<%=CommonUtil.nvl(_rowData.get("DELIV_EQUIP_CNT")) %>');</script>
								</select>
							</td>
							<th scope="row" class="padding">Kep시스템 교육희망시기</th>
							<td colspan="2">
								<label for="st_kep_system_ed_year" class="hidden">1~2대</label>
								<%
								int kepEdYear = Integer.parseInt(CommonUtil.nvl(_rowData.get("KEP_SYSTEM_ED"), "0").substring(0, 4));
								int kepEdMonth = Integer.parseInt(CommonUtil.nvl(_rowData.get("KEP_SYSTEM_ED"), "0").substring(4, 6));		
								%>
								<select name="st_kep_system_ed_year" id="st_kep_system_ed_year" style="width:60px;">
									<% for (int i=kepEdYear; i <= kepEdYear+4; i++) { %>
									<option value="<%=i%>" <%=kepEdYear == i ? "selected" : ""%>><%=i%></option>
									<% } %>
								</select>
								<select name="st_kep_system_ed_month" id="st_kep_system_ed_month" style="width:40px;">
									<% for (int i=1; i <= 12; i++) { %>
									<option value="<%=i%>" <%=kepEdMonth == i ? "selected" : ""%>><%=i%></option>
									<% } %>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
	            
				<span class="text11 b">3.결제정보</span>
				<!-- 계좌번호 암호화 테스트용 -->
				<%if(user_id.equals("KEP2159512") || user_id.equals("KEP2209002")) {%>
					<input type="text" id="st_bank_account_no_test" name="st_bank_account_no_test" class="input_type_text" title="" style="width:20%;" value="<%=CommonUtil.nvl(_rowData.get("BANK_ACCOUNT_NO_TEST"))%>" readonly="readonly"/>
				<%} %>
				<br>
	        	<table  class="cont_t_list06" style="width:100%;">
					<caption>회사법인 정보관리 리스트</caption>
					<colgroup>
						<col width="150px" />
						<col width="36%" />
						<col width="150px" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="star">경리담당자</th>
							<td><input type="text" id="st_ac_emp_nm" name="st_ac_emp_nm" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("AC_EMP_NM"))%>"  maxlength="20" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);"/></td>
							<th scope="row" class="star">경리담당자전화번호</th>
							<td><input type="text" id="st_ac_emp_tel" name="st_ac_emp_tel" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("AC_EMP_TEL"))%>"  maxlength="20" onkeyup="fnPhoneNumberCheck('st_ac_emp_tel');" onchange="fnPhoneNumberCheck('st_ac_emp_tel');"/></td>
						</tr>
						<tr>
							<th scope="row">경리담당자휴대폰</th>
							<td>
							<% 
	                      	String _ac_emp_mobile1 = "";
                  			String _ac_emp_mobile2 = "";
                  			String _ac_emp_mobile3 = "";	
	                      	if (!CommonUtil.nvl(_rowData.get("AC_EMP_MOBILE")).equals("")) {
	                      		_ac_emp_mobile1 = CommonUtil.nvl(_rowData.get("AC_EMP_MOBILE")).split("\\-")[0];
	                      		_ac_emp_mobile2 = CommonUtil.nvl(_rowData.get("AC_EMP_MOBILE")).split("\\-")[1];
	                      		_ac_emp_mobile3 = CommonUtil.nvl(_rowData.get("AC_EMP_MOBILE")).split("\\-")[2];
	                      	}
	                      	%>
							<select id="st_ac_emp_mobile1" name="st_ac_emp_mobile1" style="width:50px;">
								<option value="010" <%=_ac_emp_mobile1.equals("010")?"selected":""%>>010</option>
								<option value="011" <%=_ac_emp_mobile1.equals("011")?"selected":""%>>011</option>
								<option value="016" <%=_ac_emp_mobile1.equals("016")?"selected":""%>>016</option>
								<option value="017" <%=_ac_emp_mobile1.equals("017")?"selected":""%>>017</option>
								<option value="018" <%=_ac_emp_mobile1.equals("018")?"selected":""%>>018</option>
								<option value="019" <%=_ac_emp_mobile1.equals("019")?"selected":""%>>019</option>

							</select>
							- 
							<input type="text" id="st_ac_emp_mobile2" name="st_ac_emp_mobile2" class="input_type_text" title="" style="width:20%;" value="<%=_ac_emp_mobile2%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
							- 
							<input type="text" id="st_ac_emp_mobile3" name="st_ac_emp_mobile3" class="input_type_text" title="" style="width:20%;" value="<%=_ac_emp_mobile3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
							</td>
							<th scope="row">경리담당자이메일</th>
							<td><input type="text" id="st_ac_emp_email" name="st_ac_emp_email" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl3(_rowData.get("AC_EMP_EMAIL"), "")%>"  maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);"/></td>
						</tr>
						<tr>
							<th scope="row" class="star">영업담당자</th>
							<td><input type="text" id="st_gr_emp_nm" name="st_gr_emp_nm" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("GR_EMP_NM"))%>"  maxlength="20" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);"/></td>
							<th scope="row" class="star">영업담당자전화번호</th>
							<td><input type="text" id="st_gr_emp_tel" name="st_gr_emp_tel" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("GR_EMP_TEL"))%>"  maxlength="20" onkeyup="fnPhoneNumberCheck('st_gr_emp_tel');" onchange="fnPhoneNumberCheck('st_gr_emp_tel');"/></td>
						</tr>
						<tr>
							<th scope="row">영업담당자휴대폰</th>
							<td>
							<% 
	                      	String _gr_emp_mobile1 = "";
                  			String _gr_emp_mobile2 = "";
                  			String _gr_emp_mobile3 = "";	
	                      	if (!CommonUtil.nvl(_rowData.get("GR_EMP_MOBILE")).equals("")) {
	                      		_gr_emp_mobile1 = CommonUtil.nvl(_rowData.get("GR_EMP_MOBILE")).split("\\-")[0];
	                      		_gr_emp_mobile2 = CommonUtil.nvl(_rowData.get("GR_EMP_MOBILE")).split("\\-")[1];
	                      		_gr_emp_mobile3 = CommonUtil.nvl(_rowData.get("GR_EMP_MOBILE")).split("\\-")[2];
	                      	}
	                      	%>
							<select id="st_gr_emp_mobile1" name="st_gr_emp_mobile1" style="width:50px;">
								<option value="010" <%=_gr_emp_mobile1.equals("010")?"selected":""%>>010</option>
								<option value="011" <%=_gr_emp_mobile1.equals("011")?"selected":""%>>011</option>
								<option value="016" <%=_gr_emp_mobile1.equals("016")?"selected":""%>>016</option>
								<option value="017" <%=_gr_emp_mobile1.equals("017")?"selected":""%>>017</option>
								<option value="018" <%=_gr_emp_mobile1.equals("018")?"selected":""%>>018</option>
								<option value="019" <%=_gr_emp_mobile1.equals("019")?"selected":""%>>019</option>

							</select>
							- 
							<input type="text" id="st_gr_emp_mobile2" name="st_gr_emp_mobile2" class="input_type_text" title="" style="width:20%;" value="<%=_gr_emp_mobile2%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
							- 
							<input type="text" id="st_gr_emp_mobile3" name="st_gr_emp_mobile3" class="input_type_text" title="" style="width:20%;" value="<%=_gr_emp_mobile3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
							</td>
							<th scope="row">영업담당자이메일</th>
							<td><input type="text" id="st_gr_emp_email" name="st_gr_emp_email" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl3(_rowData.get("GR_EMP_EMAIL"), "")%>"  maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);"/></td>
						</tr>
						<tr>
							<th scope="row" class="star">지급조건</th>
							<td>
								<select id="st_pay_terms" name="st_pay_terms" style="width:55%;">
									<script>kepAjaxCommonComboDataValue('st_pay_terms', 'SA01', 'SEL', '<%=CommonUtil.nvl(_rowData.get("PAY_TERMS"))%>');</script>
								</select>
							</td>
							<th scope="row" class="star">지급형태</th>
							<td>
								<select id="st_pay_type" name="st_pay_type" style="width:55%;">
									<script>kepAjaxCommonComboDataValue('st_pay_type', 'SA03', 'SEL', '<%=CommonUtil.nvl(_rowData.get("PAY_TYPE"))%>');</script>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">발행조건</th>
							<td colspan="3">
								<select id="st_bill_type" name="st_bill_type" >
									<script>kepAjaxCommonComboDataValue('st_bill_type', 'TX03', 'SEL', '<%=CommonUtil.nvl(_rowData.get("BILL_TYPE"))%>');</script>
								</select>
								<input type="checkbox" id="st_bill_yn"  name="st_bill_yn" value="Y" class="noborder" style=" vertical-align:middle" />&nbsp;
                         	<span class="FontRed">* 협력사와 계산서 발행조건에 대한 협의를 하였습니다.</span> 
							</td>
						</tr>
						<tr>
							<th scope="row" class="star">은행명</th>
							<td>
								<input type="hidden" id="st_bank_cd" name="st_bank_cd" value="<%=CommonUtil.nvl(_rowData.get("BANK_CD"))%>"  />
								<input type="text" id="st_bank_name" name="st_bank_name" class="input_type_text" title="" style="width:75%;" value="<%=CommonUtil.nvl(_rowData.get("BANK_NAME"))%>"  readonly />
								<a href="javascript:doPop( 'bankcode');"><img src="/resources/images/btn_search03.gif" /></a>
								<input type="hidden" id="st_pay_type" name="st_pay_type" value="<%=CommonUtil.nvl(_rowData.get("PAY_TYPE"))%>"  />
								<input type="hidden" id="st_pay_date_type" name="st_pay_date_type" value="<%=CommonUtil.nvl(_rowData.get("PAY_DATE_TYPE"))%>"  />
							</td>
						
							<th scope="row" class="star">계좌번호</th>
							<td><input type="text" id="st_bank_account_no" name="st_bank_account_no" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("BANK_ACCOUNT_NO"))%>"  maxlength="30" onkeyup="fnPhoneNumberCheck('st_bank_account_no');" onchange="fnPhoneNumberCheck('st_bank_account_no');"/></td>
						</tr>
						<tr>	
							<th scope="row" class="star">예금주</th>
							<td colspan="3"><input type="text" id="st_depositor" name="st_depositor" class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("DEPOSITOR"))%>"  maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);"/></td>
						</tr>
					</tbody>
				</table>
	            
				<span class="text11 b">4.SMS 및 이메일 수신여부</span><br>
	        	<table  class="cont_t_list06" style="width:100%;">
					<caption>회사법인 정보관리 리스트</caption>
						<colgroup>
						<col width="130px" />
						<col width="36%" />
						<col width="130px" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="star">이메일 수신여부</th>
							<td>
								<input type="radio" id="mail_send_flag1" name="mail_send_flag" value="Y" <%=CommonUtil.nvl(_rowData.get("MAIL_SEND_FLAG")).equals("Y") ? "checked" : "" %> />&nbsp;수신&nbsp;&nbsp;&nbsp;
								<input type="radio" id="mail_send_flag2" name="mail_send_flag" value="N" <%=CommonUtil.nvl(_rowData.get("MAIL_SEND_FLAG")).equals("N") ? "checked" : ""%> />&nbsp;미수신&nbsp;&nbsp;&nbsp;
								<input type="hidden" id="st_mail_send_flag" name="st_mail_send_flag" value="<%=CommonUtil.nvl(_rowData.get("MAIL_SEND_FLAG"))%>" />
							</td>
							<th scope="row" class="star">SMS 수신여부</th>
							<td>
								<input type="radio" id="sms_recv_flag1" name="sms_recv_flag" value="Y" <%=CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG")).equals("Y") ? "checked" : ""%> />&nbsp;수신&nbsp;&nbsp;&nbsp;
								<input type="radio" id="sms_recv_flag2" name="sms_recv_flag" value="N" <%=CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG")).equals("N") ? "checked" : ""%> />&nbsp;미수신&nbsp;&nbsp;&nbsp;
								<input type="hidden" id="st_sms_recv_flag" name="st_sms_recv_flag" value="<%=CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG"))%>" />
							</td>
						</tr>
					</tbody>
				</table>
				<% /* 평가점수 계산 */
				double DByearOldPoint = Double.parseDouble(CommonUtil.nvl(_rowData.get("VALUE1"), "0"));
				double DBcaptAmtPoint = Double.parseDouble(CommonUtil.nvl(_rowData.get("VALUE2"), "0"));
				double DBsalesAmtPoint = Double.parseDouble(CommonUtil.nvl(_rowData.get("VALUE3"), "0"));
				double DBempPoint = Double.parseDouble(CommonUtil.nvl(_rowData.get("VALUE4"), "0"));
				double DBceoCareerPoint = Double.parseDouble(CommonUtil.nvl(_rowData.get("VALUE5"), "0"));
				double DBregTypePoint = Double.parseDouble(CommonUtil.nvl(_rowData.get("VALUE6"), "0"));
				double DBtotPoint = Double.parseDouble(CommonUtil.nvl(_rowData.get("VALUE_TOT"), "0"));
				
				double totPoint = 0f;
				double yearOldPoint = 0f;
				double captAmtPoint = 0f;
				double salesAmtPoint = 0f;
				double empPoint = 0f;
				double ceoCareerPoint = 0f;
				double regTypePoint = 0f;
				
				String evl_user = "";
				String sp_type = "";
				String sp_type_text = "";
				
				// 강수미 or 박지수
				if (simsaLevel.equals("1") || user_id.equals("KEP2129083") || user_id.equals("KEP2239041")) {
					evl_user = "Y";
				} else {
					evl_user = "N";
				}
				
				if (DBtotPoint != 0 ) {
					yearOldPoint = DByearOldPoint;
					captAmtPoint = DBcaptAmtPoint;
					salesAmtPoint = DBsalesAmtPoint;
					empPoint = DBempPoint;
					ceoCareerPoint = DBceoCareerPoint;
					regTypePoint = DBregTypePoint;
					totPoint = DBtotPoint;
					
				} else {
					// 설립일자 계산
					double year_old = Double.parseDouble(CommonUtil.nvl(_rowData.get("YEAR_OLD"), "0"));
					
					if(year_old >= 0 && year_old < 3){
						yearOldPoint = 5;
					}else if(year_old >= 3 && year_old < 10){
						yearOldPoint = 12;
					}else if(year_old >= 10 && year_old < 15){
						yearOldPoint = 16;
					}else if(year_old >= 15){
						yearOldPoint = 20;
					}
					
					// 자본금 총액 계산
					if(_rowData.get("CAPT_AMT").equals("CM01")){
						captAmtPoint = 5;
					}else if(_rowData.get("CAPT_AMT").equals("CM02")){
						captAmtPoint = 7;
					}else if(_rowData.get("CAPT_AMT").equals("CM03")){
						captAmtPoint = 9;
					}else if(_rowData.get("CAPT_AMT").equals("CM04")){
						captAmtPoint = 10;
					}
					
					// 연간매출액
					if(_rowData.get("YEAR_AMT").equals("YA01")){
						salesAmtPoint = 10;
					}else if(_rowData.get("YEAR_AMT").equals("YA02")){
						salesAmtPoint = 15;
					}else if(_rowData.get("YEAR_AMT").equals("YA03")){
						salesAmtPoint = 20;
					}else if(_rowData.get("YEAR_AMT").equals("YA04")){
						salesAmtPoint = 25;
					}
					
					// 상시근로자수
					if(_rowData.get("EMP_CNT").equals("AA")){
						empPoint = 5;
					}else if(_rowData.get("EMP_CNT").equals("AB")){
						empPoint = 12;
					}else if(_rowData.get("EMP_CNT").equals("AC")){
						empPoint = 16;
					}else if(_rowData.get("EMP_CNT").equals("AD")){
						empPoint = 20;
					}
					
					// 대표자 동종업계 경력
					if(_rowData.get("CEO_CAREER").equals("CC01")){
						ceoCareerPoint = 10;
					}else if(_rowData.get("CEO_CAREER").equals("CC02")){
						ceoCareerPoint = 12;
					}else if(_rowData.get("CEO_CAREER").equals("CC03")){
						ceoCareerPoint = 16;
					}else if(_rowData.get("CEO_CAREER").equals("CC04")){
						ceoCareerPoint = 20;
					}
					
					// 등록 구분
					if(_rowData.get("REG_TYPE").equals("P")){
						regTypePoint = 3;
					}else{
						regTypePoint = 5;
					}
					
					totPoint = yearOldPoint + captAmtPoint + salesAmtPoint + empPoint + ceoCareerPoint + regTypePoint;
					
				}
				%>
				<input type="hidden" id="st_evl_user" name="st_evl_user" value="<%=evl_user %>" />
				<% if ("Y".equals(evl_user)) { %>
				<span class="text11 b">5.평가</span><br>
	        	<table class="cont_t_list03" style="width:100%;">
					<caption>회사법인 정보관리 리스트</caption>
					<colgroup>
						<col width="12%" />
						<col width="20%" />
						<col width="12%" />
						<col width="*" />
						<col width="12%" />
						<col width="12%" />
						<col width="12%" />
					</colgroup>
					<thead>
						<tr>
							<th>심사<br>구분</th>
							<th>평가<br>항목</th>
							<th>총<br>배점</th>
							<th>구간</th>
							<th>점수</th>
							<th>항목<br>점수</th>
							<th>점수<br>합계</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td rowspan="22">100점</td>
							<td rowspan="4">설립일자</td>
							<td rowspan="4">20</td>
							<td>3년 미만</td>
							<td>5</td>
							<td rowspan="4"><div id="yearOldPoint"><%=yearOldPoint%></div><input type="hidden" name="st_value1" value="<%=yearOldPoint%>"></td>
							<td rowspan="22"><div id="totPoint"><%=totPoint%></div><input type="hidden" name="st_value_tot" value="<%=totPoint%>"></td>
						</tr>
						<tr>
							<td>3년 이상</td>
							<td><p>12</p></td>
						</tr>
						<tr>
							<td>10년 이상</td>
							<td>16</td>
						</tr>
						<tr>
							<td>15년 이상</td>
							<td>20</td>
						</tr>
						
						<tr>
							<td rowspan="4">자본금 총액</td>
							<td rowspan="4">10</td>
							<td>5천만원 미만</td>
							<td>5</td>
							<td rowspan="4"><div id="captAmtPoint"><%=captAmtPoint%></div><input type="hidden" name="st_value2" value="<%=captAmtPoint%>" /></td>
						</tr>
						<tr>
							<td>5천만원 이상</td>
							<td>7</td>
						</tr>
						<tr>
							<td>5억원 이상</td>
							<td>9</td>
						</tr>
						<tr>
							<td>10억원 이상</td>
							<td>10</td>
						</tr>
						
						<tr>
							<td rowspan="4">연간매출액</td>
							<td rowspan="4">25</td>
							<td>5억원 미만</td>
							<td>10</td>
							<td rowspan="4"><div id="salesAmtPoint"><%=salesAmtPoint%></div><input type="hidden" name="st_value3" value="<%=salesAmtPoint%>"></td>
						</tr>
						<tr>
							<td>5억원 이상</td>
							<td>15</td>
						</tr>
						<tr>
							<td>20억원 이상</td>
							<td>20</td>
						</tr>
						<tr>
							<td>50억원 이상</td>
							<td>25</td>
						</tr>
						
						<tr>
							<td rowspan="4">상시근로자수</td>
							<td rowspan="4">20</td>
							<td>5명 미만</td>
							<td>5</td>
							<td rowspan="4"><div id="empPoint"><%=empPoint%></div><input type="hidden" name="st_value4" value="<%=empPoint%>"></td>
						</tr>
						<tr>
							<td>5명 이상</td>
							<td>12</td>
						</tr>
						<tr>
							<td>20명 이상</td>
							<td>16</td>
						</tr>
						<tr>
							<td>50명 이상</td>
							<td>20</td>
						</tr>
						
						<tr>
							<td rowspan="4">대표자<br/>동종업계 경력</td>
							<td rowspan="4">20</td>
							<td>3년 미만</td>
							<td>10</td>
							<td rowspan="4"><div id="ceo_career_point"><%=ceoCareerPoint%></div><input type="hidden" name="st_value5" value="<%=ceoCareerPoint%>"></td>
						</tr>
						<tr>
							<td>3년 이상</td>
							<td>12</td>
						</tr>
						<tr>
							<td>10년 이상</td>
							<td>16</td>
						</tr>
						<tr>
							<td>20년 이상</td>
							<td>20</td>
						</tr>
						
						<tr>
							<td rowspan="2">등록 구분</td>
							<td rowspan="2">5</td>
							<td>개인</td>
							<td>3</td>
							<td rowspan="2"><div id="reg_type_point"><%=regTypePoint%></div><input type="hidden" name="st_value6" value="<%=regTypePoint%>"></td>
						</tr>
						<tr>
							<td>법인</td>
							<td>5</td>
						</tr>
					</tbody>
				</table>
				
				<span class="text11 b">6. KeP 담당자 입력사항</span><br>
	        	<table  class="cont_t_list06" style="width:100%;">
					<caption>KeP 담당자 입력사항</caption>
					<colgroup>
						<col width="145PX" />
						<col width="16%" />
						<col width="16%" />
						<col width="16%" />
						<col width="16%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="padding">주거래품목</th>
							<td colspan="2">
								<label for="st_major_deal_item" class="hidden">--선택--</label>
								<select name="st_major_deal_item" id="st_major_deal_item" style="width:55%;">
									<script>kepAjaxCommonComboDataValue('st_major_deal_item', 'M116', 'SEL', '<%=CommonUtil.nvl(_rowData.get("MAJOR_DEAL_ITEM")) %>');</script>
								</select>
							</td>
							<th scope="row" class="padding">고객지정여부</th>
							<td colspan="2">
								<input type="radio" id="buyer_ho_yn1" name="buyer_ho_yn" value="Y" onchange="handleChange(event)" <%=CommonUtil.nvl(_rowData.get("BUYER_HO_YN")).equals("Y") ? "checked" : ""%> />&nbsp;지정&nbsp;&nbsp;&nbsp;
								<input type="radio" id="buyer_ho_yn2" name="buyer_ho_yn" value="N" onchange="handleChange(event)" <%=CommonUtil.nvl(_rowData.get("BUYER_HO_YN")).equals("N") ? "checked" : "" %> />&nbsp;미지정
								
								<input type="hidden" id="st_buyer_ho_yn" name="st_buyer_ho_yn" value="<%=CommonUtil.nvl(_rowData.get("BUYER_HO_YN"))%>" />
							</td>
						</tr>
						<tr>
							<th scope="row" class="padding">KeP경유고객사</th>
							<td>
								<input type="text" id="st_kep_buyer_name1" name="st_kep_buyer_name1" class="input_type_text" title="" style="width:70%;" value="<%=CommonUtil.nvl(_rowData.get("KEP_BUYER_NAME1")) %>" readonly />
								<input type="hidden" id="st_kep_buyer1" name="st_kep_buyer1" value="<%=CommonUtil.nvl(_rowData.get("KEP_BUYER1")) %>" />
								<a href="javascript:doPop( 'kepBuyer',  '1');"><img src="/resources/images/btn_search03.gif" /></a>
							</td>
							<td>
								<input type="text" id="st_kep_buyer_name2" name="st_kep_buyer_name2" class="input_type_text" title="" style="width:70%;" value="<%=CommonUtil.nvl(_rowData.get("KEP_BUYER_NAME2")) %>"  readonly />
								<input type="hidden" id="st_kep_buyer2" name="st_kep_buyer2" value="<%=CommonUtil.nvl(_rowData.get("KEP_BUYER2")) %>" />
								<a href="javascript:doPop( 'kepBuyer',  '2');"><img src="/resources/images/btn_search03.gif" /></a>
							</td>
							<td>
								<input type="text" id="st_kep_buyer_name3" name="st_kep_buyer_name3" class="input_type_text" title="" style="width:70%;" value="<%=CommonUtil.nvl(_rowData.get("KEP_BUYER_NAME3")) %>"  readonly />
								<input type="hidden" id="st_kep_buyer3" name="st_kep_buyer3" value="<%=CommonUtil.nvl(_rowData.get("KEP_BUYER3")) %>" />
								<a href="javascript:doPop( 'kepBuyer',  '3');"><img src="/resources/images/btn_search03.gif" /></a>
							</td>
							<td>
								<input type="text" id="st_kep_buyer_name4" name="st_kep_buyer_name4" class="input_type_text" title="" style="width:70%;" value="<%=CommonUtil.nvl(_rowData.get("KEP_BUYER_NAME4")) %>"  readonly />
								<input type="hidden" id="st_kep_buyer4" name="st_kep_buyer4" value="<%=CommonUtil.nvl(_rowData.get("KEP_BUYER4")) %>" />
								<a href="javascript:doPop( 'kepBuyer',  '4');"><img src="/resources/images/btn_search03.gif" /></a>
							</td>
							<td>
								<input type="text" id="st_kep_buyer_name5" name="st_kep_buyer_name5" class="input_type_text" title="" style="width:75%;" value="<%=CommonUtil.nvl(_rowData.get("KEP_BUYER_NAME5")) %>"  readonly  />
								<input type="hidden" id="st_kep_buyer5" name="st_kep_buyer5" value="<%=CommonUtil.nvl(_rowData.get("KEP_BUYER5")) %>" />
								<a href="javascript:doPop( 'kepBuyer',  '5');"><img src="/resources/images/btn_search03.gif" /></a>
							</td>
						</tr>
						<tr>
							<th scope="row" class="star">협력사 구분</th>
							<td colspan="2">
								<input type="radio" id="sp_type1" name="sp_type" value="N" <%=CommonUtil.nvl(_rowData.get("SP_TYPE")).equals("N") ? "checked" : ""%> onChange="javascript:change_sp_type();"/>
								<label for="sp_type1">정규</label>
								<input type="radio" id="sp_type2" name="sp_type" value="S" <%=CommonUtil.nvl(_rowData.get("SP_TYPE")).equals("S") ? "checked" : ""%> onChange="javascript:change_sp_type();"/>
								<label for="sp_type2">정규(특별계약)</label>
								<input type="radio" id="sp_type3" name="sp_type" value="T" <%=CommonUtil.nvl(_rowData.get("SP_TYPE")).equals("T") ? "checked" : ""%> onChange="javascript:change_sp_type();"/>
								<label for="sp_type3">임시</label>
								<input type="radio" id="sp_type4" name="sp_type" value="E" <%=CommonUtil.nvl(_rowData.get("SP_TYPE")).equals("E") ? "checked" : ""%> onChange="javascript:change_sp_type();"/>
								<label for="sp_type4">계약제외</label>
								<input type="hidden" id="st_sp_type" name="st_sp_type" value="<%=CommonUtil.nvl(_rowData.get("SP_TYPE"))%>" />
							</td>
							<th scope="row" class="star">물류계약여부</th>
							<td colspan="2">
								<select name="st_e_contract_kind" id="st_e_contract_kind" style="width:15%;" <%=CommonUtil.nvl(_rowData.get("SP_TYPE")).equals("T")?"disabled":CommonUtil.nvl(_rowData.get("SP_TYPE")).equals("E")?"disabled":""%>>
									<option value="Y" <%=CommonUtil.nvl(_rowData.get("E_CONTRACT_FLAG")).equals("Y") ? "selected" : "" %>>Y</option>
									<option value="N" <%=CommonUtil.nvl(_rowData.get("E_CONTRACT_FLAG")).equals("N") ? "selected" : "" %>>N</option>
								</select>
							</td>
						</tr>
						<tr>							
							<th scope="row" class="star">대표SG</th>
							<td colspan="2">
								<input type="text" id="st_sg_name" name="st_sg_name" class="input_type_text" title="" value="<%=CommonUtil.nvl(_rowData.get("SG_NAME"))%>" readonly />
								<input type="hidden" id="st_sg_code" name="st_sg_code" value="<%=CommonUtil.nvl(_rowData.get("SG_ID"))%>" />
								<a href="javascript:doPop( 'sg_name');"><img src="/resources/images/btn_search03.gif" /></a>
							</td>
							<th scope="row" class="star">수수료율(%)</th>
							<td colspan="2">
								<input type="text" id="st_lgstrate" name="st_lgstrate" class="input_type_text" title="" style="width:20%;" value = "<%=CommonUtil.nvl(_rowData.get("LOGIS_RATE"))%>"  />
							</td>
							
						</tr>
						<tr>
							<th scope="row" class="star">협의기한 구분</th>
							<td colspan="2">
									<input type="radio" id="st_end_date1" name="st_end_date" checked onChange="javascript:change_lgst_end_date();"/>
									<label for="st_end_date1">기한</label>
									<input type="radio" id="st_end_date2" name="st_end_date" onChange="javascript:change_lgst_end_date();"/>
									<label for="st_end_date2">영구</label>
																	
							</td>
							<th scope="row" class="star">협의기한</th>
							<td colspan="2">
									<input type="text" id="st_lgst_end_date" name="st_lgst_end_date" class="input_type_text" style="width:20%;" title="" value="<%=CommonUtil.nvl(_rowData.get("END_DATE"))%>" />								
							</td>
						</tr>
						<tr>
						<th scope="row" class="star">수수료율 변경사유</th>
							<td colspan="5">
								<input type="text" id="st_lgstrate_remark" name="st_lgstrate_remark" class="input_type_text" value ="<%=CommonUtil.nvl(_rowData.get("LOGIS_REMARK"))%>" title="" style="width:100%;"   />
							</td>
						</tr>	
						<tr>						
							<th scope="row" class="star">신용평가 여부</th>
							<td colspan="2">
								<input type="radio" id="credit_status1" name="credit_status" value="A" <%=CommonUtil.nvl(_rowData.get("CREDIT_STATUS")).equals("A") ? "checked" : "" %> />&nbsp;B-이상&nbsp;&nbsp;&nbsp;
								<input type="radio" id="credit_status2" name="credit_status" value="B" <%=CommonUtil.nvl(_rowData.get("CREDIT_STATUS")).equals("B") ? "checked" : ""%> />&nbsp;등급미달&nbsp;&nbsp;&nbsp;
								<input type="radio" id="credit_status3" name="credit_status" value="C" <%=CommonUtil.nvl(_rowData.get("CREDIT_STATUS")).equals("C") ? "checked" : ""%> />&nbsp;면제
								<input type="hidden" id="st_credit_status" name="st_credit_status" value="<%=CommonUtil.nvl(_rowData.get("CREDIT_STATUS"))%>" />
							</td>
							<th scope="row" class="star">전자계약 계약일자</th>
							<td colspan="2">
								<input type="text" class="input_type_text" name="st_e_contract_date" id="st_e_contract_date" readOnly style="width:100px; text-align:center;" value="<%=CommonUtil.nvl(_rowData.get("EC_DATE"))%>">
								<a href="javascript:kepCalendar('st_e_contract_date')"></a>
							</td>
						</tr>
						<tr>
							<th scope="row" class="star">계약담당자 휴대폰</th>
							<td colspan="2">
								<% 
		                      	String _cont_emp_mobile1 = "";
	                  			String _cont_emp_mobile2 = "";
	                  			String _cont_emp_mobile3 = "";	
		                      	if (!CommonUtil.nvl(_rowData.get("EC_USER_TEL")).equals("")) {
		                      		_cont_emp_mobile1 = CommonUtil.nvl(_rowData.get("EC_USER_TEL")).split("\\-")[0];
		                      		_cont_emp_mobile2 = CommonUtil.nvl(_rowData.get("EC_USER_TEL")).split("\\-")[1];
		                      		_cont_emp_mobile3 = CommonUtil.nvl(_rowData.get("EC_USER_TEL")).split("\\-")[2];
		                      	}
		                      	%>
								<select id="st_cont_emp_mobile1" name="st_cont_emp_mobile1" style="width:50px;">
									<option value="010" <%=_cont_emp_mobile1.equals("010")?"selected":""%>>010</option>
									<option value="011" <%=_cont_emp_mobile1.equals("011")?"selected":""%>>011</option>
									<option value="016" <%=_cont_emp_mobile1.equals("016")?"selected":""%>>016</option>
									<option value="017" <%=_cont_emp_mobile1.equals("017")?"selected":""%>>017</option>
									<option value="018" <%=_cont_emp_mobile1.equals("018")?"selected":""%>>018</option>
									<option value="019" <%=_cont_emp_mobile1.equals("019")?"selected":""%>>019</option>

								</select>
								- 
								<input type="text" id="st_cont_emp_mobile2" name="st_cont_emp_mobile2" class="input_type_text" title="" style="width:20%;" value="<%=_cont_emp_mobile2%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
								- 
								<input type="text" id="st_cont_emp_mobile3" name="st_cont_emp_mobile3" class="input_type_text" title="" style="width:20%;" value="<%=_cont_emp_mobile3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
								
							</td>
							<th scope="row" class="star">계약담당자/이메일</th>
							<td colspan="2">
								<input type="text" class="input_type_text" name="st_e_contract_user" id="st_e_contract_user" style="width:25%; text-align:left;" value="<%=CommonUtil.nvl(_rowData.get("EC_USER_NAME"))%>">&nbsp;/&nbsp;
								<input type="text" class="input_type_text" name="st_e_contract_mail" id="st_e_contract_mail" style="width:60%; text-align:left;" value="<%=CommonUtil.nvl3(_rowData.get("EC_USER_EMAIL"),"")%>">
							</td>
						</tr>
						<tr>
							<th scope="row">전자계약 비고</th>
							<td colspan="5">
								<input type="text" class="input_type_text" name="st_e_contract_remark" id="st_e_contract_remark" style="width:97%; text-align:left;" value="<%=CommonUtil.nvl(_rowData.get("EC_REMARK"))%>" <%=!evl_user.equals("Y")?"readonly":""%>>
							</td>
						</tr>
						<tr>
							<th scope="row" class="star">비고<br />1차 승인자</th>
							<td colspan="5">
								<textarea rows="4" style="width:98%" id="st_kep_damdang_remark" name="st_kep_damdang_remark" <%=!simsaLevel.equals("1")?"readonly":""%> maxlength="200" onkeyup="fnCheckInputByte(this, 200);" onchange="fnCheckInputByte(this, 200);"><%=CommonUtil.nvl(_rowData.get("KEP_DAMDANG_REMARK"))%></textarea>
							</td>
						</tr>
						<% if (!simsaLevel.equals("1")) { %>
						<tr>
							<th scope="row" class="star">비고<br />2차 승인자</th>
							<td colspan="5">
								<textarea rows="4" style="width:98%" id="st_kep_damdang_remark2" name="st_kep_damdang_remark2" <%=!simsaLevel.equals("2")?"readonly":""%> maxlength="200" onkeyup="fnCheckInputByte(this, 200);" onchange="fnCheckInputByte(this, 200);"><%=CommonUtil.nvl(_rowData.get("KEP_DAMDANG_REMARK2"))%></textarea>
							</td>
						</tr>
						<% } %>
					</tbody>
				</table>		
				<% } %>
			</div>
			<!--버튼영역-->
			<div class="btnArea pt10 mb05">
				<div class="fr">
					<% if (simsaLevel.equals("1") && (CommonUtil.nvl(_rowData.get("STATUS")).equals("S") || CommonUtil.nvl(_rowData.get("STATUS")).equals("B") || CommonUtil.nvl(_rowData.get("STATUS")).equals("E"))) { %>
						<span class="btn_02"><a href="javascript:doAction('save', 'T');">품의</a></span>
					<% }  %>
					
					<% if (simsaLevel.equals("3")) {%>
					<input type="hidden" id="st_avl_flag" name="st_avl_flag" value="<%=CommonUtil.nvl(_rowData.get("AVL_FLAG"))%>" />  
						<% if (_rowData.get("AVL_USER").equals("OK")) { %> 
							<% if (_rowData.get("AVL_FLAG").equals("Y")) {%>
							<span class="btn_02"><a href="javascript:doAction('avl', 'D');">AVL 취소</a></span>
							<% } else if (_rowData.get("AVL_FLAG").equals("N")) {%>  
							<span class="btn_02"><a href="javascript:doAction('avl', 'C');">AVL 승인</a></span>
							<% } %>
						<% } %>  
					<% } %> 		
						<%if(sessionDept.equals("004") || sessionDept.equals("005") || sessionDept.equals("095")){%>
							<span class="btn_02"><a href="javascript:doAction('save', 'R');">저장</a></span>
						<%}%>
						<%if(user_id.equals("KEP2129083") || user_id.equals("KEP2239041")){%>
							<span class="btn_02"><a href="javascript:doAction('save', 'R');">저장</a></span>
						<%}%>
				</div>
			</div>
			<% } %>
	</div>
</form> 
</body>
</html>
