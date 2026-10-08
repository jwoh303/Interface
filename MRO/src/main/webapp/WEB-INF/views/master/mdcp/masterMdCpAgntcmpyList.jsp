<%--
**********************************************
* 메뉴 : 회원사관리>협력사관리>협력사조회
* 화면 : 협력사조회
* 기능 : 등록된 모든 협력사를 조회하고 제재업체를 등록하거나 고객사지정 처리
* 프로그램 ID : PG_01_M_005_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-07
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String SessionUserId         = sessionInfo.getUserId();
//엑셀다운로드 권한체크
boolean getRoleYn = CommonUtil.getCodeCheckReturn("M162",SessionUserId);
//전자계약 전송 권한 체크
boolean getEcontRoleYn = CommonUtil.getCodeCheckReturn("M165",SessionUserId);
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var creditRow = "";
var kcbImg="/resources/images/KCB.jpg";
var ecrImg="/resources/images/ECR.png";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",		Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus"}
					,{ Align:"Center",		Width:40,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Radio",		Header:"선택",			SaveName:"SELECTED"}
					,{ Align:"Left",		Width:260,	Edit:false,	EditLen:260,	Hidden:false,	Type:"Text",		Header:"협력사명",			SaveName:"COM_NAME_LOC"}
					,{ Align:"Left",		Width:260,	Edit:false,	EditLen:260,	Hidden:true,	Type:"Text",		Header:"회사코드",			SaveName:"COM_CODE"}
					,{ Align:"Center",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Html",		Header:"상태",			SaveName:"CM_STATUS"}
					,{ Align:"Center",		Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Html",		Header:"상태",			SaveName:"STATUS"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"사업자번호",		SaveName:"IRS_NO"}
					,{ Align:"Center",		Width:50,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Image",		Header:"신용평가",			SaveName:"WEB_LINK_KCB"}
					,{ Align:"Center",		Width:50,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Image",		Header:"신용평가",			SaveName:"WEB_LINK_ECR"}
					,{ Align:"Center",		Width:50,	Edit:false,	EditLen:95,		Hidden:true,	Type:"Text",		Header:"신용평가",			SaveName:"WEB_LINK_KCB_NO"}
					,{ Align:"Center",		Width:50,	Edit:false,	EditLen:95,		Hidden:true,	Type:"Text",		Header:"신용평가",			SaveName:"WEB_LINK_ECR_NO"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Html",		Header:"대표자명",			SaveName:"CEO_NAME_LOC"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"대표자명",			SaveName:"CEO_NAME_LOC_TEMP"}
					,{ Align:"Left",		Width:380,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"주소",			SaveName:"ADDRESS_LOC"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"대표번호",			SaveName:"TEL_NO"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"팩스번호",			SaveName:"FAX_NO"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"담당자명",			SaveName:"USER_NAME_LOC"}
					,{ Align:"Center",		Width:160,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"이메일",			SaveName:"EMAIL"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"휴대전화",			SaveName:"MOBILE_PHONE"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"대표SG",			SaveName:"SG_ID"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KEP담당자",		SaveName:"KEP_DAMDANG"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"서류접수",			SaveName:"CONTRACT_DOC_YN"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사구분",		SaveName:"INFO_SP_TYPE"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"휴/폐업",			SaveName:"CM_CMP_FLAG"}
					,{ Align:"Left",		Width:160,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"휴/폐업내역",		SaveName:"CMP_CLOSE_NOTE"}
					,{ Align:"Left",		Width:160,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"삭제사유",			SaveName:"REJECT_REASON"}
					,{ Align:"Left",		Width:160,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"삭제자",			SaveName:"REJECT_USER_ID"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"가입일",			SaveName:"ADD_DATE"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"만기일",			SaveName:"CREDIT_EXPIRE_DATE"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"신용평가등급",		SaveName:"CREDIT_RATING"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"신용평가여부",		SaveName:"CM_CREDIT_STATUS"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"신용평가여부",		SaveName:"CREDIT_AGENT_CNT"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"신용평가여부",		SaveName:"WIDUS"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"대리점권 1",		SaveName:"ITM_MK1_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"대리점권 2",		SaveName:"ITM_MK2_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"대리점권 3",		SaveName:"ITM_MK3_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"대리점권 4",		SaveName:"ITM_MK4_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"대리점권 5",		SaveName:"ITM_MK5_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"대리점권 6",		SaveName:"ITM_MK6_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"대리점권 7",		SaveName:"ITM_MK7_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"대리점권 8",		SaveName:"ITM_MK8_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"대리점권 9",		SaveName:"ITM_MK9_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"대리점권 10",		SaveName:"ITM_MK10_NM"}
					,{ Align:"Left",		Width:250,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",		Header:"대리점권",			SaveName:"ITM_MK_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"유통레벨 1",		SaveName:"ITM_MK1_AGENCY_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"유통레벨 2",		SaveName:"ITM_MK2_AGENCY_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"유통레벨 3",		SaveName:"ITM_MK3_AGENCY_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"유통레벨 4",		SaveName:"ITM_MK4_AGENCY_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"유통레벨 5",		SaveName:"ITM_MK5_AGENCY_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"유통레벨 6",		SaveName:"ITM_MK6_AGENCY_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"유통레벨 7",		SaveName:"ITM_MK7_AGENCY_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"유통레벨 8",		SaveName:"ITM_MK8_AGENCY_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"유통레벨 9",		SaveName:"ITM_MK9_AGENCY_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"유통레벨 10",		SaveName:"ITM_MK10_AGENCY_NM"}
					,{ Align:"Left",		Width:250,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",		Header:"유통레벨",			SaveName:"ITM_MK_AGENCY_NM"}
 					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",		Header:"전년 협력사유형",	SaveName:"TYPE_BEFORE_ONE"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",		Header:"전전년 협력사유형",	SaveName:"TYPE_BEFORE_TWO"}
					,{ Align:"Left",		Width:120,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",		Header:"지급조건",			SaveName:"PAY_TERMS_NM"}
					,{ Align:"Left",		Width:200,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",		Header:"지급형태",			SaveName:"PAY_TYPE_NM"}
					,{ Align:"Right",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"거래금액",			SaveName:"ITEM_AMT",		Format:"${priceFormat}"}
					,{ Align:"Right",		Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"고정매입수수료율",	SaveName:"SALE_PRFT_RATE",	Format:"${priceFormat}"}
					,{ Align:"Center",		Width:80,	Edit:false,	EditLen:80,		Hidden:true,	Type:"Text",		Header:"전자계약상태코드",	SaveName:"E_CONTRACT_STATUS_CODE"}
					,{ Align:"Center",		Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"물류계약여부",		SaveName:"E_CONTRACT_WMS_YN"}
					,{ Align:"Center",		Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"전자계약상태",		SaveName:"E_CONTRACT_STATUS"}
					,{ Align:"Center",		Width:80,	Edit:false,	EditLen:80,		Hidden:true,	Type:"Text",		Header:"전자계약서ID",		SaveName:"EC_DOC_ID"}
					,{ Align:"Center",		Width:80,	Edit:false,	EditLen:80,		Hidden:true,	Type:"Text",		Header:"계약담당자이메일",	SaveName:"EC_USER_EMAIL"}
					,{ Align:"Center",		Width:80,	Edit:false,	EditLen:80,		Hidden:true,	Type:"Text",		Header:"계약담당자",		SaveName:"EC_USER_NAME"}
					,{ Align:"Center",		Width:80,	Edit:false,	EditLen:80,		Hidden:true,	Type:"Text",		Header:"계약일자",			SaveName:"EC_DATE"}
					,{ Align:"Center",		Width:80,	Edit:false,	EditLen:80,		Hidden:true,	Type:"Text",		Header:"계약종료일자",		SaveName:"EC_TO_DATE"}
					,{ Align:"Center",		Width:80,	Edit:false,	EditLen:80,		Hidden:true,	Type:"Text",		Header:"KEP주소",			SaveName:"KEP_ADDRESS"}
					,{ Align:"Center",		Width:80,	Edit:false,	EditLen:80,		Hidden:true,	Type:"Text",		Header:"KEP대표자",		SaveName:"KEP_CEO"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	//하이퍼링크 설정
	setLinkCol(mySheet, "COM_NAME_LOC");		//회사명
	setLinkCol(mySheet, "WEB_LINK_KCB");	//링크
	setLinkCol(mySheet, "WEB_LINK_ECR");	//링크
	mySheet.SetImageList(1, kcbImg);
	mySheet.SetImageList(2, ecrImg);
	
	
	// 엑셀다운로드 시 이용 그리드
	var initsheet2 = {};
	initsheet2.Cols = [ 
					 { Align:"Left",		Width:260,	Edit:false,	EditLen:260,	Hidden:false,	Type:"Text",		Header:"업체명",			SaveName:"COM_NAME_LOC"}
					,{ Align:"Left",		Width:100,	Edit:false,	EditLen:260,	Hidden:true,	Type:"Text",		Header:"업체코드",			SaveName:"COM_CODE"}
					,{ Align:"Left",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"사업자번호",		SaveName:"IRS_NO"}
					,{ Align:"Left",		Width:260,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"업태",			SaveName:"INDUSTRY_TYPE"}
					,{ Align:"Left",		Width:260,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"종목",			SaveName:"BUSINESS_ITEMS"}
					,{ Align:"Left",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Html",		Header:"대표자명",			SaveName:"CEO_NAME_LOC"}
					,{ Align:"Left",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"대표자명",			SaveName:"CEO_NAME_LOC_TEMP"}
					,{ Align:"Left",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KEP담당자",		SaveName:"KEP_DAMDANG_NAME"}
					,{ Align:"Left",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"전화번호",			SaveName:"TEL_NO"}
					,{ Align:"Left",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"우편번호",			SaveName:"ZIP_CODE"}
					,{ Align:"Left",		Width:380,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"주소",			SaveName:"ADDRESS_LOC"}
					,{ Align:"Left",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"계좌번호",			SaveName:"BANK_ACCOUNT_NO"}
					,{ Align:"Left",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"은행명",			SaveName:"BANK_NAME"}
					,{ Align:"Left",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"예금주명",			SaveName:"DEPOSITOR"}
					,{ Align:"Left",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"유통레벨",			SaveName:"BIZ_TYPE_TEXT"}
					,{ Align:"Center",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Html",		Header:"상태",			SaveName:"CM_STATUS"}
					,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"전자계약상태",		SaveName:"E_CONTRACT_STATUS"}
	];
	
	IBS_InitSheet(mySheet2, initsheet2, pagingMode);
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && str != "creditSearch" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			var st_user_id = $("#st_user_id").val();
			if(check_search() == false){
				alert("협력사명, 사업자번호, 대표자명, 상태, 구분, 대리점권, 취급품목, 주소 중 하나 이상 조회조건이 필요합니다.");
				return;
			}
			kepSearch(document.searchCondition,  mySheet , "/mdcp/getMasterMdCpAgntcmpyList.do" , pagingMode );
			break;
		case "reload":	// 초기화
			$("#st_kep_damdang_id").val("");
			$("#st_itm_mk_cd").val("");
			$("#st_itmg_cd").val("");
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case "save": // 저장
			if (!confirm('선택한 항목을 저장 하시겠습니까?'))
				return;
			kepSave(document.searchCondition,  mySheet , "/mdcp/saveMasterMdCpAgntcmpyList.do" , "SELECTED" );
			break;
		case "del": // 취소
			if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
				return;
			kepSave(document.searchCondition,  mySheet , "/mdcp/delMasterMdCpAgntcmpyList.do" , "SELECTED" );
			break;
		case "excelDown": // 엑셀다운로드
			$("#pageflag").val('0');
			if(check_search() == false){
				alert("협력사명, 사업자번호, 대표자명, 상태, 구분, 대리점권, 취급품목, 주소 중 하나 이상 조회조건이 필요합니다.");
				return;
			}
			var param = {FileName:"공급사정보.xlsx",Merge:1,SheetDesign:1,DownCols:"COM_NAME_LOC|COM_CODE|IRS_NO|INDUSTRY_TYPE|BUSINESS_ITEMS|CEO_NAME_LOC_TEMP|ZIP_CODE|ADDRESS_LOC|BANK_ACCOUNT_NO|BANK_NAME|DEPOSITOR|CM_STATUS"};
			kepDownExcel(document.searchCondition, mySheet2 , "/mdcp/excelMasterMdCpAgntcmpyList.do", param);
			$("#pageflag").val('1');
			break;
		case "econtSend": // 전자계약전송
			if(sendStatusChk(selectedGrid) == false){
				alert("현재 전자계약상태는 새로운 전자계약을 전송불가합니다.");
				return;
			}
			if(sendAbleChk(selectedGrid) == false){
				alert("협력사구분:정규 및 계약담당자 정보 입력여부를 확인하여 주세요.");
				return;
			}
			if (!confirm('선택한 항목을 전자계약 전송하시겠습니까?'))
				return;
			kepSave(document.searchCondition,  mySheet , "/mdcp/saveMasterMdCpEcontSend.do" , "SELECTED" );
			break;
		case "econtSearch": // 전자계약상태조회
			if (!confirm('선택한 항목을 전자계약 상세조회하시겠습니까?'))
				return;
			kepSave(document.searchCondition,  mySheet , "/mdcp/getMasterMdCpEcontStatus.do" , "SELECTED" );
			break;
	}
}

function check_search(){
	var com_name = document.forms.searchCondition.st_com_name.value;
	var irs_no = document.forms.searchCondition.st_irs_no.value;
	var ceo_name = document.forms.searchCondition.st_ceo_name.value;
	var supplier_status = document.forms.searchCondition.st_supplier_status.value;
	var sp_type = document.forms.searchCondition.st_sp_type.value;
	var itm_mk_nm = document.forms.searchCondition.st_itm_mk_nm.value;
	var itmg_nm = document.forms.searchCondition.st_itmg_nm.value;
	var address_loc = document.forms.searchCondition.st_address_loc.value;
	
	if(com_name == "" && irs_no == "" && ceo_name == "" && supplier_status == "ALL" && sp_type == "ALL" && itm_mk_nm == "" && itmg_nm == "" && address_loc == ""){
		return false;
	}
}

// 그 리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
function mySheet2_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		alert(msg);
	}

	if (current_page==-1) {
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	} else {
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}

	for (var i=1; i <= mySheet.RowCount(); i++ ) {
		// [ISMS 결함조치] 마스킹 보완 2025.07.01
		mySheet.SetCellValue(i, "USER_NAME_LOC", kepMaskingName(mySheet.GetCellValue(i, "USER_NAME_LOC")));
		mySheet.SetCellValue(i, "EMAIL", kepMaskingEmail(mySheet.GetCellValue(i, "EMAIL")));
		mySheet.SetCellValue(i, "MOBILE_PHONE", kepMaskingPhone(mySheet.GetCellValue(i, "MOBILE_PHONE")));
		
		var itmMkNm = "";
		var itmMkAgencyNm = "";
		
		if ($.trim(mySheet.GetCellValue(i, "CM_STATUS")) == "제재업체") {
			var cmStatus =  "<a href=\"javascript:doPop('release', '" + mySheet.GetCellValue(i,"COM_CODE") + "');\" style='color:#0100FF;' >" +  mySheet.GetCellValue(i, "CM_STATUS") + "</a>";
			mySheet.SetCellValue(i, "CM_STATUS", cmStatus);
		} 
		
		if (mySheet.GetCellValue(i, "CREDIT_AGENT_CNT") == "Y") {
			var ceoName =  "<font color='red'>ⓒ</font> <a href=\"javascript:doPop('creditRelease', '" + mySheet.GetCellValue(i,"COM_CODE") + "');\" style='color:#0100FF;' >" +  mySheet.GetCellValue(i, "CEO_NAME_LOC") + "</a>";
			mySheet.SetCellValue(i, "CEO_NAME_LOC", ceoName);
		}
		for (var j = 1; j < 10; j++) {
			if (mySheet.GetCellValue(i,"ITM_MK"+j+"_NM") != "") {
				if (itmMkNm != "") {
					itmMkNm += ", ";
				}
				itmMkNm += mySheet.GetCellValue(i,"ITM_MK"+j+"_NM");
			}
		}
		mySheet.SetCellValue(i, "ITM_MK_NM", itmMkNm);
		
		for (var j = 1; j < 10; j++) {
			if (mySheet.GetCellValue(i,"ITM_MK"+j+"_AGENCY_NM") != "") {
				if (itmMkAgencyNm != "") {
					itmMkAgencyNm += ", ";
				}
				itmMkAgencyNm += mySheet.GetCellValue(i,"ITM_MK"+j+"_AGENCY_NM");
			}
		}
		mySheet.SetCellValue(i, "ITM_MK_AGENCY_NM", itmMkAgencyNm);
		
		if (mySheet.GetCellValue(i, "E_CONTRACT_STATUS_CODE") == "C" || mySheet.GetCellValue(i, "E_CONTRACT_STATUS_CODE") == "D" || mySheet.GetCellValue(i, "E_CONTRACT_STATUS_CODE") == "E" || mySheet.GetCellValue(i, "E_CONTRACT_STATUS_CODE") == "F") {
			mySheet.SetCellFontColor(i,"E_CONTRACT_STATUS","blue");
		}
	}
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcp/getMasterMdCpAgntcmpyList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val1, val2, val3, val4) {
	popupSel = str;
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	// 선택된 항목 유무 체크
	if ((str =="restrc" || (str == "credit" && val1 == "A") || str =="agentCommunity") && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	switch (str) {
		case "kepManagerPop":				// Kep담당자
			openSearchPopup("/mdcp/getMasterMdCpUserChoicePop.do", "?st_buyer=" + val1, "500,500,no");
			break;
		case "aprroval":							// 협력사 승인반려
			openSearchPopup("/mdcp/showMasterMdCpAgntcmpyInfoAlterPop.do", "?com_code=" + val1 + "&simsaLevel=3", "950,670,no");
			break;
		case "creditEvaluation":					// 신용평가 정보
			// u : 인코딩된 사용자 아이디
			// p : 인코딩된 사용자 암호
			// i : 협력업체사업자번호 - 본사사업자번호
			// k : 인코딩된 협력업체본사번호 - 본사사업자번호
			// c : 암호화방법
			//      1(암호화안함), 2(base64), 7:(128bit, 인증정보 고정, 사업자번호암호화 X)
			// m : 통합인증서 기본 섹션
			//      1(업체검색), 2(Watch메인), 3(전자인증서메인), 4(건설실적메인), 5(거래위험메인)
			// g : 고정파라미터
			var c ="7";
			var m ="3";
			
			var link ='http://www.esrm.co.kr/esrm/SrmplusLogin?u=' + val1 + '&p=' + val2 + '&i=' + val3 + '&k=' + val4 + '&c=' + c + '&m=' + m +'&g=2';
	        var features ='height=768, width=1024, status=no, scrollbars=auto, resizable=yes';
	        window.open(link, 'watchwin', features);
			break;
		case "bizwireWeblink":
			var form = document.forms.tokenForm;			
			form.token.value = val2;
			form.userId.value = "kep01";
			form.action = val1;
			form.target = "bizWebPopup";			
			var features ='height=768, width=1024, status=no, scrollbars=auto, resizable=yes';
	        window.open("", 'bizWebPopup', features);	        
			form.submit();
			break;
		case "newRegAgntcmpy":			// 신규등록 협력사 정보 
			openSearchPopup("/mdcp/showMasterMdCpNewRegAgntcmpyInfoPop.do", "?com_code=" + val1 + "&mdm_confirm_type=" + val2, "960,670,no");
			break;
		case "widusPool":					// 신규등록 협력사 정보 
			window.open('http://www.widuspool.com','new','resizable=yes,scrollbars=yes,width=800,height=600', 'widusPool');
			break;
		case "restrc":							// 제재업체등록
			if (mySheet.GetCellValue(selectedGrid, "STATUS") == "T" || mySheet.GetCellValue(selectedGrid, "STATUS") == "D" || mySheet.GetCellValue(selectedGrid, "STATUS") == "B") {
				alert("삭제, 1차승인, 반려된 협력사는 제제업체 등록을 할수 없습니다.");
				return;
			}
			openSearchPopup("/mdcp/showMasterMdCpRestrcCompanyPop.do", "?com_code=" + mySheet.GetCellValue(selectedGrid, "COM_CODE"), "550,300,no");
			break;	
		case "release":						// 제재업체해제 
			openSearchPopup("/mdcp/showMasterMdCpRestrcCompanyReleasePop.do", "?com_code=" + val1, "610,400,no");
			break;		
		case "credit":							// 신용평가면제 지정
			if (mySheet.GetCellValue(selectedGrid, "STATUS") == "T" || mySheet.GetCellValue(selectedGrid, "STATUS") == "D" || mySheet.GetCellValue(selectedGrid, "STATUS") == "B") {
				alert("삭제, 1차승인, 반려된 협력사는 신용평가면제 지정을 할수 없습니다.");
				return;
			}
			com_code = mySheet.GetCellValue(selectedGrid, "COM_CODE");
			openSearchPopup("/mdcp/showMasterMdCpCreditEvaluationExemptionCompanyPop.do", "?com_code=" + com_code, "550,300,no");
			break;
		case "creditRelease":							// 신용평가면제 해제
			openSearchPopup("/mdcp/showMasterMdCpCreditEvaluationExemptionCompanyReleasePop.do", "?com_code=" + val1, "410,400,no");
			break;	
		case "itmMk":					// 대리점권보유 메이커명
			openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
			break;
		case "itmg":						// 대리점권보유품목
			openSearchPopup("/coco/getCommonCoCoTranGoodsPop.do", "", "600,500,no");
			break;	
		case "agentCommunity": // 협력사 커뮤니티
			openSearchPopup('/mdcp/getMasterMdCpAgentCommunityInfoList.do','?com_code='+mySheet.GetCellValue(selectedGrid, "COM_CODE"), '800,680,no');
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'COM_NAME_LOC') { // 요청자
		doPop("aprroval", mySheet.GetCellValue(Row,"COM_CODE"));
	} else if (column == 'WEB_LINK_ECR') { // 품목코드		
		var u="2d2d424547494e204349504845522d2d313131310000000b30303030303030308adcf2427727cb3c99f88cbb5d286f9feff44841390eea46e5459dd5012f1cfd25981f4352e8405c547bb1d999ae621930302d2d454e44204349504845522d2d";
		var p="2d2d424547494e204349504845522d2d313131310000000430303030303030308c39583fe0484e0f8fdb85524415eb1d8c0a5b801b3bda99d0389636bc5e7db086062756a066c45b41e8566fdf18764530302d2d454e44204349504845522d2d";
		var i = mySheet.GetCellValue(Row,"WIDUS").replace(/-/gi,"");
		var k ="";
		
		doPop("creditEvaluation", u, p, i, k);
	} else if(column == 'WEB_LINK_KCB'){		
		document.forms.processForm.st_doc_id.value = mySheet.GetCellValue(Row,"IRS_NO");		
		var pMethod = "getBizInfo";
		kepAjaxFormCall("/mdcp/bizwireWeblink.do","processForm", pMethod);		
	}else if(column == 'E_CONTRACT_STATUS'){
		var pMethod = "";
		if(mySheet.GetCellValue(Row,"E_CONTRACT_STATUS_CODE") == "F"){
			document.forms.processForm.st_doc_id.value = mySheet.GetCellValue(Row,"EC_DOC_ID");
			pMethod = "getUrl";
			kepAjaxFormCall("/mdcp/getMasterMdCpEcontEmbeddedUrl.do","processForm", pMethod);
		}else if(mySheet.GetCellValue(Row,"E_CONTRACT_STATUS_CODE") == "C" || mySheet.GetCellValue(Row,"E_CONTRACT_STATUS_CODE") == "D" || mySheet.GetCellValue(Row,"E_CONTRACT_STATUS_CODE") == "E"){
			document.forms.processForm.st_doc_id.value = mySheet.GetCellValue(Row,"EC_DOC_ID");
			pMethod = "getRejectReason";
			kepAjaxFormCall("/mdcp/getMasterMdCpEcontStatusWithId.do","processForm", pMethod);
		}else{
			return;
		}
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	//팝업 조회후 해당 항목에 값을 셋팅
	switch (popupSel) {
		case "aprroval":
		case "restrc":
		case "release":
		case "credit":
			if (code == 'OK') {
				doAction('search');
			}
			break;
		case "itmMk":
			$("#st_itm_mk_cd").val(code);
			$("#st_itm_mk_nm").val(text);
			break;
		case "itmg":
			$("#st_itmg_cd").val(code);
			$("#st_itmg_nm").val(text);
			break;
	}
	
	grbRow="";	//초기화
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	if (pMethod == "creditSearch") {
		mySheet.SetCellValue(creditRow, 'CREDIT_AGENT_CNT', sMsg );
	}else if(pMethod == "getBizInfo"){
		var callUrl = response.callUrl;
		var token = response.token;		
		doPop("bizwireWeblink",callUrl,token);
	}else if(pMethod == "getUrl"){
		var url = response.url;
		window.open(url, "", "width=770,height=800,resizable=YES");
	}else if(pMethod == "getRejectReason"){
		popupSel = "cancelRemark";
		var viewType="eContReject";
		var cancel_remark = response.reason;
		openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType,"500,230,no");
	}
}

//ajax 공통 호출후 에러시 처리 함수
function  kepAjaxError(pMethod , response) {
	alert("처리중 오류가 발생 하였습니다.");		//처리중 오류가 발생 하였습니다.\n\n확인 후 다시 시도하여 주십시요
}

function sendStatusChk(row){
	if(mySheet.GetCellValue(row, "E_CONTRACT_STATUS_CODE") == "C" || mySheet.GetCellValue(row, "E_CONTRACT_STATUS_CODE") == "E" || mySheet.GetCellValue(row, "E_CONTRACT_STATUS_CODE") == "T" || mySheet.GetCellValue(row, "E_CONTRACT_STATUS_CODE") == ""){
		return true;
	}
	return false;
}
function sendAbleChk(row){
	if(mySheet.GetCellValue(row, "INFO_SP_TYPE") == "정규" && mySheet.GetCellValue(row, "EC_USER_EMAIL") != "" && mySheet.GetCellValue(row, "EC_USER_NAME") != "" && mySheet.GetCellValue(row, "EC_DATE") != ""){
		return true;
	}
	return false;
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>협력사조회</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition" name="searchCondition" method="post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1" />
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}" />
			<input type="hidden" id="st_com_code" name="st_com_code"  value="" />
			
            	<table  class="cont_t_list01" >
					<caption>협력사조회</caption>
					<colgroup>
						<col width="8%" />
						<col width="14%" />
						<col width="8%" />
						<col width="14%" />
						<col width="8%" />
                        <col width="14%" />
                        <col width="8%" />
                        <col width="10%" />
                        <col width="8%" />
                        <col width="*" />
					</colgroup>
						
					<tbody>
						<tr>
							<td>협력사명</td>
							<td>
								<input type="text" id="st_com_name" name="st_com_name" class="input_type_text" title="" style="width:80%;" value=""  onkeydown="kepEnter();" />
							</td>
							<td>사업자번호</td>
							<td>
								<input type="text" id="st_irs_no" name="st_irs_no" class="input_type_text" title="" style="width:80%;" value=""  onkeydown="kepEnter();" />
							</td>
							<td>대표자명</td>
							<td>
								<input type="text" id="st_ceo_name" name="st_ceo_name" class="input_type_text" title="" style="width:80%;" value=""  onkeydown="kepEnter();" />
							</td>
							<td>상태</td>
							<td>
								<select id="st_supplier_status" name="st_supplier_status" style="width:80%;">
									<option value="ALL">전체</option>
									<option value="F">제재업체</option>
									<option value="D">삭제</option>
									<option value="R">등록</option>
									<option value="T">결재중</option>
									<option value="S">요청</option>
									<option value="E">결재선오류</option>
									<option value="B">반려</option>
									<option value="G">결재완료</option>
								</select>
							</td>
							<td>협력사구분</td>
							<td>
								<select id="st_sp_type" name="st_sp_type" style="width:80%;">
									<option value="ALL">전체</option>
									<option value="N">정규</option>
									<option value="S">정규(특별계약)</option>
									<option value="T">임시</option>
									<option value="E">계약제외</option>							
								</select>
							</td>
						</tr>
						<tr>
							<td>대표전화번호</td>
							<td>
								<input type="text" id="st_tel_no" name="st_tel_no" class="input_type_text" title="" style="width:80%;" value=""  onkeydown="kepEnter();" />
							</td>
							<td>휴대전화</td>
							<td>
								<input type="text" id="st_mobile_phone" name="st_mobile_phone" class="input_type_text" title="" style="width:80%;" value=""  onkeydown="kepEnter();" />
							</td>
							<td>이메일</td>
							<td>
								<input type="text" id="st_email" name="st_email" class="input_type_text" title="" style="width:80%;" value=""  onkeydown="kepEnter();" />
							</td>
							<td>신용평가여부</td>
							<td>
								<select id="st_credit_status" name="st_credit_status" style="width:80%;">
									<option value="ALL">전체</option>
									<option value="A">B-이상</option>
									<option value="B">등급미달</option>
									<option value="C">면제</option>							
								</select>
							</td>
							<td>신용평가등급</td>
							<td>
								<select name="st_credit_rating" style="width:80%;">
									<option value="ALL">전체</option>
									<option value="AAA">AAA</option>
									<option value="AA+">AA+</option>
									<option value="AA">AA</option>
									<option value="AA-">AA-</option>
									<option value="A">A</option>
									<option value="A-">A-</option>
									<option value="BBB+">BBB+</option>
									<option value="BBB">BBB</option>
									<option value="BBB-">BBB-</option>
									<option value="BB+">BB+</option>
									<option value="BB">BB</option>
									<option value="BB-">BB-</option>
									<option value="B+">B+</option>
									<option value="B">B</option>
									<option value="B-">B-</option>
									<option value="CCC+">CCC+</option>
									<option value="CCC">CCC+</option>
									<option value="CCC-">CCC-</option>
									<option value="CC">CC</option>
									<option value="C">C</option>
									<option value="D">D</option>
								</select>
							</td>
						</tr>
						<tr>
							<td>담당자명</td>
							<td>
								<input type="text" id="st_kep_damdang_id" name="st_kep_damdang_id" class="input_type_text" style="width:48%;" value=""  onkeydown="kepEnter();">
							</td>
							<td>대리점권</td>
							<td>
								<input type="text" id="st_itm_mk_nm" name="st_itm_mk_nm" class="input_type_text" style="width:48%;" value=""  readonly onclick="javascript:doPop('itmMk');" />
								<input type="hidden" name="st_itm_mk_cd" id="st_itm_mk_cd" style="width:70%" value="">
								<a href="javascript:doPop( 'itmMk');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itm_mk_cd','st_itm_mk_nm');" ><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
							<td>취급품목</td>
							<td>
								<input type="text" id="st_itmg_nm" name="st_itmg_nm" class="input_type_text" title="" style="width:48%;" value="" readonly onclick="javascript:doPop('itmg');" />
								<input type="hidden" id="st_itmg_cd" name="st_itmg_cd" value="" />
								<a href="javascript:doPop( 'itmg');"><img src="/resources/images/btn_search03.gif" /></a>
								<a href="javascript:kepEraser('st_itmg_cd','st_itmg_nm');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<td>서류접수</td>
							<td>
								<select id="st_deal_contract_doc" name="st_deal_contract_doc" style="width:80%;">
									<option value="ALL">전체</option>
									<option value="YYYYYY">Y</option>
									<option value="NNNNNN">N</option>
									<option value="E">보완필요</option>							
								</select>
							</td>
							<td>휴/폐업정보</td>
							<td>
								<select id="st_cmp_flag" name="st_cmp_flag" style="width:80%;">
									<option value="ALL">전체</option>
									<option value="N">정상</option>
									<option value="C">휴업</option>
									<option value="E">폐업</option>							
								</select>
							</td>
						</tr>
						<tr>
							<td>주소</td>
							<td colspan="3">
								<input type="text" id="st_address_loc" name="st_address_loc" class="input_type_text" title="" style="width:95%;" value="" onkeydown="kepEnter();" />
							</td>
							<td>전자계약체결</td>
							<td>
								<select id="st_e_contract_status" name="st_e_contract_status" style="width:50%;">
									<option value="ALL">전체</option>
									<option value="Y">체결</option><!-- 전자계약 상태가 계약완료 F 일 때 -->
									<option value="N">미체결</option><!-- 상태코드 F 이외 -->
								</select>
							</td>
							<td colspan="6"></td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
				</select>
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
	  				createIBSheet("mySheet", "100%", "354px");
	  				
  				</script>
  			</div>
	  		<div style="display:none">
				<script type="text/javascript">
					createIBSheet("mySheet2", "100%", "0px");
				</script>
			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
  	          	<%if(getRoleYn== true){ %>
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				<%} %>
  					<span class="btn_05 mr04"><a href="javascript:doPop('restrc');">제재업체 등록</a></span>
  					<span class="btn_07 mr04"><a href="javascript:doPop('credit');">신용평가면제지정</a></span>
  					<span class="btn_08 mr04"><a href="javascript:doPop('widusPool');">위더스풀(신용정보)</a></span>
					<span class="btn_05 mr04"><a href="javascript:doPop('agentCommunity');">협력사 커뮤니티</a></span>
				<%if(getEcontRoleYn== true){ %>
					<span class="btn_05 mr04"><a href="javascript:doAction('econtSend');">전자계약전송</a></span>
					<!--span class="btn_05 mr04"><a href="javascript:doAction('econtSearch');">전자계약상세조회</a></span-->
				<%} %>
  				</span>
  			 </div>

<!--내용 종료-->

<form id="processForm" name="processForm" method="post">
	<input type="hidden" id="st_doc_id" name="st_doc_id"  value="" />
</form>
<form id="tokenForm" method="POST">
	<input type="hidden" name="token"/>
	<input type="hidden" name="userId"/>
</form>
</body>
</html>
