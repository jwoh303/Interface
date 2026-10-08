<%--
**********************************************
* 메뉴 : 상품관리>고객사 카탈로그 관리>카탈로그 소싱 진행
* 화면 : 카탈로그 소싱 진행
* 기능 : 조직효율화 후 카탈로그 소싱 진행
* 프로그램 ID : 
* 담당자 : HSJ ( 설계 : HMH )
* 착수일 : 2022-09-19
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<script src="/resources/js/kep_common.js"></script>
<%
	String st_user_id = _sessionInfo.getUserId();
	String st_user_dept = _sessionInfo.getDepartment();
	
	//소싱부서 여부
	String st_sour_dept_yn = "";
	boolean st_sour_dept = CommonUtil.getCodeCheckReturn("SOURDEPT",st_user_dept);
	if(st_sour_dept == true){
		st_sour_dept_yn = "Y";
	}else{
		st_sour_dept_yn = "N";
	}
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var excelLoadType = "";
var approvalType = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.HeaderMode = {Sort : 0};
	initsheet.Cols = [ 
						 { Align:"Center",	Width:60,	Edit:false,	Type:"Status",		Header:"상태",			SaveName:"sStatus",	Hidden : true}
						,{ Align:"Center",	Width:40,	Edit:true,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"요청번호",			SaveName:"CA_REQ_NO"}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"요청순번",			SaveName:"CA_REQ_SEQ"}
						,{ Align:"Center",	Width:40,	Edit:false,	Type:"Text",		Header:"차수",			SaveName:"CA_REQ_REVISION"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"소싱요청번호",		SaveName:"CT_NO"}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"요청타입코드",		SaveName:"REQ_TYPE",	Hidden : true}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"요청타입",			SaveName:"REQ_TYPE_TEXT"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"기등록여부",		SaveName:"K_REG_YN"}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"진행상태",			SaveName:"STATUS",	Hidden : true}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Text",		Header:"진행상태",			SaveName:"STATUS_TEXT"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"카탈로그상태",		SaveName:"CQDT_STATUS",	Hidden : true}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"카탈로그상태",		SaveName:"CQDT_STATUS_TEXT"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"카탈로그관리코드",	SaveName:"BUYER"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"계약서번호",		SaveName:"CONTRACT_NO"}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"계약서항번",		SaveName:"CONTRACT_SEQ"}
						,{ Align:"Left",	Width:120,	Edit:false,	Type:"Text",		Header:"품목코드",			SaveName:"BUYER_ITEM_NO"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"대체제안사유코드",	SaveName:"ANOTHER_OFFER_FLAG",	Hidden : true}
						,{ Align:"Left",	Width:180,	Edit:false,	Type:"Text",		Header:"대체제안사유",		SaveName:"ANOTHER_OFFER_FLAG_TEXT"}
						,{ Align:"Left",	Width:180,	Edit:false,	Type:"Text",		Header:"대체제안내용",		SaveName:"ANOTHER_OFFER_NOTE"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"갱신구분",			SaveName:"ITEM_FLAG",	Hidden : true}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"갱신구분",			SaveName:"ITEM_FLAG_TEXT"}
						,{ Align:"Left",	Width:200,	Edit:false,	Type:"Text",		Header:"품목명",			SaveName:"DESCRIPTION"}
						,{ Align:"Left",	Width:200,	Edit:false,	Type:"Text",		Header:"품목명_영문",		SaveName:"DESCRIPTION_ENG"}
						,{ Align:"Left",	Width:300,	Edit:false,	Type:"Text",		Header:"규격",			SaveName:"SPECIFICATION"}
						,{ Align:"Left",	Width:300,	Edit:false,	Type:"Text",		Header:"규격_영문",		SaveName:"SPECIFICATION_ENG"}
						,{ Align:"Left",	Width:120,	Edit:false,	Type:"Text",		Header:"모델번호",			SaveName:"MAKER_PART_NO"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"제조사코드",		SaveName:"MAKER_CODE"}
						,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",		Header:"제조사명",			SaveName:"MAKER_CODE_TEXT"}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"단위",			SaveName:"UNIT_MEASURE"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"원산지코드",		SaveName:"ORIGIN_CODE"}
						,{ Align:"Left",	Width:80,	Edit:false,	Type:"Text",		Header:"원산지",			SaveName:"ORIGIN_CODE_TEXT"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT_CODE"}
						,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",		Header:"협력사명",			SaveName:"AGENT_CODE_TEXT"}
						,{ Align:"Right",	Width:80,	Edit:false,	Type:"Float",		Header:"매출단가",			SaveName:"UNIT_PRICE",	Format:"${priceFormat}"}
						,{ Align:"Right",	Width:80,	Edit:false,	Type:"Float",		Header:"매입단가",			SaveName:"LIST_PRICE",	Format:"${priceFormat}"}
						,{ Align:"Right",	Width:60,	Edit:false,	Type:"Text",		Header:"조달일수",			SaveName:"DELIVERY_LT"}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"MOQ",			SaveName:"MIN_ORDER_QTY"}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"발주배수",			SaveName:"PUR_UNIT_QTY"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Date",		Header:"매출단가유효일",	SaveName:"TO_DATE"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Date",		Header:"매입단가유효일",	SaveName:"BUY_CLOSE_DATE"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"거래유형코드",		SaveName:"PROCESS_TYPE", Hidden : true}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"거래유형",			SaveName:"PROCESS_TYPE_TEXT"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"물류센터공급사",	SaveName:"ORIGIN_AGENT"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"물류센터공급사오류",	SaveName:"ORIGIN_AGENT_ERR", Hidden : true}
						,{ Align:"Right",	Width:80,	Edit:false,	Type:"Text",		Header:"물류수수료",		SaveName:"LOGISTICS_FEE"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"물류비사유코드",	SaveName:"LOGIS_RATE_STATUS"}
						,{ Align:"Left",	Width:120,	Edit:false,	Type:"Text",		Header:"물류비사유",		SaveName:"LOGIS_RATE_STATUS_TEXT"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"카테고리코드",		SaveName:"CATEGORY_NO"}
						,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",		Header:"카테고리명",		SaveName:"CATEG_NAME"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"표준카테고리ID",	SaveName:"CMS_CATEG_ID"}
						,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",		Header:"표준카테고리명",	SaveName:"CMS_CATEG_TEXT"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"표준카탈로그ID",	SaveName:"CMS_CATLG_ID"}
						,{ Align:"Left",	Width:120,	Edit:false,	Type:"Text",		Header:"이미지파일",		SaveName:"IMGFILE_NAME"}
						,{ Align:"Left",	Width:200,	Edit:false,	Type:"Text",		Header:"이미지경로",		SaveName:"IMGFILE_DIR"}
						,{ Align:"Left",	Width:120,	Edit:false,	Type:"Text",		Header:"협력사품목코드",	SaveName:"SELLER_ITEM_NO"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"품목구분코드",		SaveName:"ITEM_MAKE_TYPE"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"품목구분",			SaveName:"ITEM_MAKE_TYPE_TEXT"}
						
						,{ Align:"Left",	Width:200,	Edit:false,	Type:"Text",		Header:"전_품목명",		SaveName:"BF_DESCRIPTION"}
						,{ Align:"Left",	Width:300,	Edit:false,	Type:"Text",		Header:"전_규격",			SaveName:"BF_SPECIFICATION"}
						,{ Align:"Left",	Width:120,	Edit:false,	Type:"Text",		Header:"전_모델번호",		SaveName:"BF_MAKER_PART_NO"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"전_제조사코드",		SaveName:"BF_MAKER_CODE"}
						,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",		Header:"전_제조사명",		SaveName:"BF_MAKER_CODE_TEXT"}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"전_단위",			SaveName:"BF_UNIT_MEASURE"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"전_원산지코드",		SaveName:"BF_ORIGIN_CODE"}
						,{ Align:"Left",	Width:80,	Edit:false,	Type:"Text",		Header:"전_원산지",		SaveName:"BF_ORIGIN_CODE_TEXT"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"전_협력사코드",		SaveName:"BF_AGENT_CODE"}
						,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",		Header:"전_협력사명",		SaveName:"BF_AGENT_CODE_TEXT"}
						,{ Align:"Right",	Width:80,	Edit:false,	Type:"Float",		Header:"전_매출단가",		SaveName:"BF_UNIT_PRICE",	Format:"${priceFormat}"}
						,{ Align:"Right",	Width:80,	Edit:false,	Type:"Float",		Header:"전_매입단가",		SaveName:"BF_LIST_PRICE",	Format:"${priceFormat}"}
						,{ Align:"Right",	Width:80,	Edit:false,	Type:"Text",		Header:"전_조달일수",		SaveName:"BF_DELIVERY_LT"}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"전_MOQ",			SaveName:"BF_MIN_ORDER_QTY"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"전_발주배수",		SaveName:"BF_PUR_UNIT_QTY"}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Date",		Header:"전_매출단가유효일",	SaveName:"BF_TO_DATE"}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Date",		Header:"전_매입단가유효일",	SaveName:"BF_BUY_CLOSE_DATE"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"전_거래유형코드",	SaveName:"BF_PROCESS_TYPE", Hidden : true}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"전_거래유형",		SaveName:"BF_PROCESS_TYPE_TEXT"}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Text",		Header:"전_물류센터공급사",	SaveName:"BF_ORIGIN_AGENT"}
						,{ Align:"Right",	Width:100,	Edit:false,	Type:"Text",		Header:"전_물류수수료",		SaveName:"BF_LOGISTICS_FEE"}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Text",		Header:"전_물류비사유코드",	SaveName:"BF_LOGIS_RATE_STATUS"}
						,{ Align:"Left",	Width:120,	Edit:false,	Type:"Text",		Header:"전_물류비사유",		SaveName:"BF_LOGIS_RATE_STATUS_TEXT"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"전_카테고리코드",	SaveName:"BF_CATEGORY_NO"}
						,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",		Header:"전_카테고리명",		SaveName:"BF_CATEG_NAME"}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Text",		Header:"전_표준카테고리ID",	SaveName:"BF_CMS_CATEG_ID"}
						,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",		Header:"전_표준카테고리명",	SaveName:"BF_CMS_CATEG_TEXT"}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Text",		Header:"전_표준카탈로그ID",	SaveName:"BF_CMS_CATLG_ID"}
						,{ Align:"Left",	Width:120,	Edit:false,	Type:"Text",		Header:"전_이미지파일",		SaveName:"BF_IMGFILE_NAME"}
						,{ Align:"Left",	Width:200,	Edit:false,	Type:"Text",		Header:"전_이미지경로",		SaveName:"BF_IMGFILE_DIR"}
						,{ Align:"Left",	Width:120,	Edit:false,	Type:"Text",		Header:"전_협력사품목코드",	SaveName:"BF_SELLER_ITEM_NO"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"전_품목구분코드",	SaveName:"BF_ITEM_MAKE_TYPE"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"전_품목구분",		SaveName:"BF_ITEM_MAKE_TYPE_TEXT"}
						
						,{ Align:"Left",	Width:100,	Edit:false,	Type:"Text",		Header:"납품지역",			SaveName:"SELLER_AREA"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"적용구분",			SaveName:"BELOW_COMORG_CODE"}
						,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",		Header:"고객사명",			SaveName:"BUYER_TEXT"}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"단종여부",			SaveName:"PRODUCT_CLOSE_FLAG"}
						,{ Align:"Left",	Width:200,	Edit:false,	Type:"Text",		Header:"비고",			SaveName:"REMARK"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"과세구분코드",		SaveName:"TAX_TYPE", Hidden : true}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"과세구분",			SaveName:"TAX_TYPE_TEXT"}
						
						,{ Align:"Left",	Width:120,	Edit:false,	Type:"Text",		Header:"녹색구매제품_명칭",	SaveName:"BUY_GREEN_ITEM_NM"}
						,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",		Header:"녹색구매제품_인증번호",	SaveName:"BUY_GREEN_ITEM_CNO"}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Date",		Header:"녹색구매제품_시작일",	SaveName:"BUY_GREEN_ITEM_FROM_DATE"}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Date",		Header:"녹색구매제품_종료일",	SaveName:"BUY_GREEN_ITEM_TO_DATE"}
						
						,{ Align:"Left",	Width:60,	Edit:false,	Type:"Text",		Header:"KEP품목명",		SaveName:"KEP_DESCRIPTION", Hidden : true}
						,{ Align:"Left",	Width:60,	Edit:false,	Type:"Text",		Header:"KEP규격",			SaveName:"KEP_SPECIFICATION", Hidden : true}
						,{ Align:"Left",	Width:60,	Edit:false,	Type:"Text",		Header:"KEP단위",			SaveName:"KEP_UNIT_MEASURE", Hidden : true}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"KEP제조사코드",	SaveName:"KEP_MAKER_CODE", Hidden : true}
						,{ Align:"Left",	Width:60,	Edit:false,	Type:"Text",		Header:"KEP제조사명",		SaveName:"KEP_MAKER_NAME", Hidden : true}
						,{ Align:"Center",	Width:60,	Edit:false,	Type:"Text",		Header:"KEP원산지코드",	SaveName:"KEP_ORIGIN_CODE", Hidden : true}
						,{ Align:"Left",	Width:60,	Edit:false,	Type:"Text",		Header:"KEP원산지",		SaveName:"KEP_ORIGIN_NAME", Hidden : true}
						,{ Align:"Left",	Width:60,	Edit:false,	Type:"Text",		Header:"KEP모델번호",		SaveName:"KEP_MAKER_PART_NO", Hidden : true}
						
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"요청자ID",		SaveName:"REQ_USER_ID"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"요청자명",			SaveName:"REQ_USER_NAME"}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Text",		Header:"요청일시",			SaveName:"REQ_DATE"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"접수자ID",		SaveName:"RECV_USER_ID"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"접수자명",			SaveName:"RECV_USER_NAME"}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Text",		Header:"접수일시",			SaveName:"RECV_DATE"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"소싱제출자ID",		SaveName:"SO_SEND_USER_ID"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"소싱제출자명",		SaveName:"SO_SEND_USER_NAME"}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Text",		Header:"소싱제출일시",		SaveName:"SO_SEND_DATE"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"재소싱요청자ID",	SaveName:"RSO_REQ_USER_ID"}
						,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",		Header:"재소싱요청자명",	SaveName:"RSO_REQ_USER_NAME"}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Text",		Header:"재소싱요청일시",	SaveName:"RSO_REQ_DATE"}
						,{ Align:"Left",	Width:180,	Edit:false,	Type:"Text",		Header:"재소싱요청사유",	SaveName:"RSO_REQ_NOTE"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"판가담당자ID",		SaveName:"UNIT_USER_ID"}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"판가담당자명",		SaveName:"UNIT_USER_NAME"}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Text",		Header:"판가제출일시",		SaveName:"SEL_SEND_DATE"}
						,{ Align:"Center",	Width:120,	Edit:false,	Type:"Text",		Header:"취소사유",			SaveName:"CANCLE_REMARK",	Hidden : true}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"등록자ID",		SaveName:"ADD_USER_ID",	Hidden : true}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"등록자명",			SaveName:"ADD_USER_NAME",	Hidden : true}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"등록일시",			SaveName:"ADD_DATE",	Hidden : true}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"변경자ID",		SaveName:"CHANGE_USER_ID",	Hidden : true}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"변경자명",			SaveName:"CHANGE_USER_NAME",	Hidden : true}
						,{ Align:"Center",	Width:80,	Edit:false,	Type:"Text",		Header:"변경일시",			SaveName:"CHANGE_DATE",	Hidden : true}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:5};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	// 콤보데이터 셋팅 조회조건 : 진행상태
	kepAjaxCommonQueryIdSearchCombo('st_status','getCombo1_ordbyValue1','PRDTST','ALL');
	
	// 콤보데이터 셋팅 조회조건 : 품목타입
	kepAjaxCommonQueryIdSearchCombo('st_req_type','getCombo1_ordbyValue1','PRDTREQ','ALL');
}
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	var maxRow  = mySheet.RowCount();
	
	//선택된 항목 유무 체크
	if ((str == "del" || str == "sourcingSend" || str == "unitPriceSend" || str == "sourcingReSend") && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
		//소싱부서가 아닐 경우 고객사코드 필수 값.
		if($("#st_sour_dept_yn").val() == "N"){
			if($("#st_buyer_code").val() == null||$("#st_buyer_code").val() == ""){
				alert("고객사은(는) 필수입력 항목입니다.");
				return;
			}
		}
	
		var diff = kepGetDateDiff('st_from_date','st_to_date','D');
		if (eval(diff)>92){
			alert("3개월내 조회만 가능합니다.");
			return;
		}
		
		current_page = -1;
		pagingMode = "N";
		kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmCatalogRegProgressList.do" , pagingMode );
		
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		
		$("#st_buyer_code").val("");
		$("#st_from_date").val( kepToMonthAdd("1","M") );
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
		$("#st_approval_gubun").val("");
		approvalType = "";
		excelLoadType = "";
		break;
	
	case "loadExcelSourcing": // 소싱변경양식 업로드
		excelLoadType = str;
		mySheet.RemoveAll();
		var params = { Mode : "HeaderMatch" };
		//var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"|||1||2|3||4|||5|6|7|8|9|10|11||12|32|33|13||14||15||16||17||18||19|20|21|22||24||25||26|23|27|28|29|30|31||||5|7|10|24||25||9|||||||"};
		mySheet.LoadExcel(params);

		break;
		
	case "loadExcelUnitPrice": // 판가변경양식 업로드
		//소싱부서가 아닐 경우 고객사코드 필수 값.
		if($("#st_sour_dept_yn").val() == "N"){
			if($("#st_buyer_code").val() == null||$("#st_buyer_code").val() == ""){
				alert("고객사은(는) 필수입력 항목입니다.");
				return;
			}
		}
	
		excelLoadType = str;
		mySheet.RemoveAll();
		var params = { Mode : "HeaderMatch" };
		//var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"|||1||2|3|4|5||||||||||||||||||||||||||||||||||||||||||6||8|||||||||||||||"};
		mySheet.LoadExcel(params);

		break;
		
	case "excelDown":
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		
		//소싱부서가 아닐 경우 고객사코드 필수 값.
		if($("#st_sour_dept_yn").val() == "N"){
			if($("#st_buyer_code").val() == null||$("#st_buyer_code").val() == ""){
				alert("고객사은(는) 필수입력 항목입니다.");
				return;
			}
		}
	
		var diff = kepGetDateDiff('st_from_date','st_to_date','D');
		if (eval(diff)>92){
			alert("3개월내 조회만 가능합니다.");
			return;
		}
		
	    $("#pageflag").val('0');
		var param = {FileName:"카탈로그등록진행.xlsx",Merge:1,SheetDesign:1,DownCols:"CA_REQ_NO|CA_REQ_SEQ|CA_REQ_REVISION|BUYER|CONTRACT_NO|CONTRACT_SEQ|BUYER_ITEM_NO|CT_NO|REQ_TYPE|REQ_TYPE_TEXT|STATUS_TEXT|CQDT_STATUS_TEXT|ITEM_FLAG_TEXT|ANOTHER_OFFER_FLAG|ANOTHER_OFFER_FLAG_TEXT|ANOTHER_OFFER_NOTE|DESCRIPTION|DESCRIPTION_ENG|SPECIFICATION|SPECIFICATION_ENG|MAKER_PART_NO|MAKER_CODE|MAKER_CODE_TEXT|UNIT_MEASURE|ORIGIN_CODE|ORIGIN_CODE_TEXT|AGENT_CODE|AGENT_CODE_TEXT|UNIT_PRICE|LIST_PRICE|DELIVERY_LT|MIN_ORDER_QTY|PUR_UNIT_QTY|TO_DATE|BUY_CLOSE_DATE|PROCESS_TYPE|PROCESS_TYPE_TEXT|ORIGIN_AGENT|LOGISTICS_FEE|LOGIS_RATE_STATUS|LOGIS_RATE_STATUS_TEXT|CATEGORY_NO|CATEG_NAME|CMS_CATEG_ID|CMS_CATEG_TEXT|CMS_CATLG_ID|IMGFILE_NAME|IMGFILE_DIR|SELLER_ITEM_NO|ITEM_MAKE_TYPE|ITEM_MAKE_TYPE_TEXT|BF_DESCRIPTION|BF_SPECIFICATION|BF_MAKER_PART_NO|BF_MAKER_CODE|BF_MAKER_CODE_TEXT|BF_UNIT_MEASURE|BF_ORIGIN_CODE|BF_ORIGIN_CODE_TEXT|BF_AGENT_CODE|BF_AGENT_CODE_TEXT|BF_UNIT_PRICE|BF_LIST_PRICE|BF_DELIVERY_LT|BF_MIN_ORDER_QTY|BF_PUR_UNIT_QTY|BF_TO_DATE|BF_BUY_CLOSE_DATE|BF_PROCESS_TYPE|BF_PROCESS_TYPE_TEXT|BF_ORIGIN_AGENT|BF_LOGISTICS_FEE|BF_LOGIS_RATE_STATUS|BF_LOGIS_RATE_STATUS_TEXT|BF_CATEGORY_NO|BF_CATEG_NAME|BF_CMS_CATEG_ID|BF_CMS_CATEG_TEXT|BF_CMS_CATLG_ID|BF_IMGFILE_NAME|BF_IMGFILE_DIR|BF_SELLER_ITEM_NO|BF_ITEM_MAKE_TYPE|BF_ITEM_MAKE_TYPE_TEXT|SELLER_AREA|BELOW_COMORG_CODE|BUYER_TEXT|PRODUCT_CLOSE_FLAG|REMARK|TAX_TYPE_TEXT|BUY_GREEN_ITEM_NM|BUY_GREEN_ITEM_CNO|BUY_GREEN_ITEM_FROM_DATE|BUY_GREEN_ITEM_TO_DATE|REQ_USER_ID|REQ_USER_NAME|REQ_DATE|RECV_USER_ID|RECV_USER_NAME|RECV_DATE|SO_SEND_USER_ID|SO_SEND_USER_NAME|SO_SEND_DATE|RSO_REQ_USER_ID|RSO_REQ_USER_NAME|RSO_REQ_DATE|RSO_REQ_NOTE|UNIT_USER_ID|UNIT_USER_NAME|SEL_SEND_DATE"};
		kepDownExcel(document.searchCondition ,mySheet , "/mprq/excelMasterMdCmCatalogRegProgressList.do", param);
		$("#pageflag").val('1');
		break;
		
	case "sourcingSend": // 소싱제출
		for(var i=0; i<arrRow.length; i++){
			var item_flag = mySheet.GetCellValue(arrRow[i],"STATUS");
			if(item_flag != "R"){
				mySheet.SelectCell(arrRow[i], "STATUS_TEXT");
				alert("진행상태 : 접수 건만 가능합니다.");
				return;
			}

			var buyer = mySheet.GetCellValue(arrRow[i], "BUYER");
			if(buyer == "" || kepIsValueNull(buyer)){
				alert("카탈로그관리코드를 확인하여 주십시오");
				mySheet.SelectCell(arrRow[i], "BUYER");
				return;
			}
			
			var contract_no = mySheet.GetCellValue(arrRow[i], "CONTRACT_NO");
			if(contract_no == "" || kepIsValueNull(contract_no)){
				alert("계약서번호를 확인하여 주십시오");
				mySheet.SelectCell(arrRow[i], "CONTRACT_NO");
				return;
			}
			
			var buyer_item_no = mySheet.GetCellValue(arrRow[i], "BUYER_ITEM_NO");
			if(buyer_item_no == "" || kepIsValueNull(buyer_item_no)){
				alert("품목코드를 확인하여 주십시오");
				mySheet.SelectCell(arrRow[i], "BUYER_ITEM_NO");
				return;
			}
			
			var description = mySheet.GetCellValue(arrRow[i], "DESCRIPTION");
			if(description == "" || kepIsValueNull(description)){
				alert("폼목명을 확인하여 주십시오");
				mySheet.SelectCell(arrRow[i], "DESCRIPTION");
				return;
			}
			
			var specification = mySheet.GetCellValue(arrRow[i], "SPECIFICATION");
			if(specification == "" || kepIsValueNull(specification)){
				alert("규격을 확인하여 주십시오");
				mySheet.SelectCell(arrRow[i], "SPECIFICATION");
				return;
			}
			
			var agent = mySheet.GetCellValue(arrRow[i], "AGENT_CODE_TEXT");
			if(agent == "" || kepIsValueNull(agent)){
				alert("협력사를 확인하여 주십시오");
				mySheet.SelectCell(arrRow[i], "AGENT_CODE");
				return;
			}
			
			var list_price = mySheet.GetCellValue(arrRow[i], "LIST_PRICE");
			if(list_price == "" || kepIsValueNull(list_price)){
				alert("매입단가를 확인하여 주십시오");
				mySheet.SelectCell(arrRow[i], "LIST_PRICE");
				return;
			}
			
			var unit_measure = mySheet.GetCellValue(arrRow[i], "UNIT_MEASURE");
			if(unit_measure == "" || kepIsValueNull(unit_measure)){
				alert("단위를 확인하여 주십시오");
				mySheet.SelectCell(arrRow[i], "UNIT_MEASURE");
				return;
			}
			
			var process_type_text = mySheet.GetCellValue(arrRow[i], "PROCESS_TYPE_TEXT");
			if(process_type_text == "" || kepIsValueNull(process_type_text)){
				alert("거래유형을 확인하여 주십시오");
				mySheet.SelectCell(arrRow[i], "PROCESS_TYPE_TEXT");
				return;
			}
			
			var process_type = mySheet.GetCellValue(arrRow[i], "PROCESS_TYPE");
			var origin_agent_err = mySheet.GetCellValue(arrRow[i], "ORIGIN_AGENT_ERR");
			if(process_type == "2" && origin_agent_err == "Y"){
				alert("물류센터공급사를 확인하여 주십시오");
				mySheet.SelectCell(arrRow[i], "ORIGIN_AGENT");
				return;
			}
			
			var categ = mySheet.GetCellValue(arrRow[i], "CATEG_NAME");
			if(categ == "" || kepIsValueNull(categ)){
				alert("카테고리를 확인하여 주십시오");
				mySheet.SelectCell(arrRow[i], "CATEG_NAME");
				return;
			}
			
			var cmsCateg = mySheet.GetCellValue(arrRow[i], "CMS_CATEG_TEXT");
			if(cmsCateg == "" || kepIsValueNull(cmsCateg)){
				alert("표준카테고리를 확인하여 주십시오");
				mySheet.SelectCell(arrRow[i], "CMS_CATEG_TEXT");
				return;
			}
			
			var item_make_type = mySheet.GetCellValue(arrRow[i], "ITEM_MAKE_TYPE_TEXT");
			if(item_make_type == "" || kepIsValueNull(item_make_type)){
				alert("품목구분을 확인하여 주십시오");
				mySheet.SelectCell(arrRow[i], "ITEM_MAKE_TYPE_TEXT");
				return;
			}
			
			var below_comorg_code = mySheet.GetCellValue(arrRow[i], "BELOW_COMORG_CODE");
			if(below_comorg_code == "" || kepIsValueNull(below_comorg_code)){
				alert("고객사를 확인하여 주십시오");
				mySheet.SelectCell(arrRow[i], "BELOW_COMORG_CODE");
				return;
			}
		}

		cc = confirm("선택된 내역으로 소싱제출 하시겠습니까?");
		
		if(cc){
			approvalType = str;
			$("#st_approval_gubun").val("CRS");
			kepSave(document.searchCondition ,  mySheet , "/mdcm/sendMasterMdCmCatalogReg.do" , "SELECTED" );
		}else {
			return;
		}
		break;
		
	case "unitPriceSend": // 판가제출
		for(var i=0; i<arrRow.length; i++){
			var item_flag = mySheet.GetCellValue(arrRow[i],"STATUS");
			if(item_flag != "S"){
				mySheet.SelectCell(arrRow[i], "STATUS_TEXT");
				alert("진행상태 : 소싱제출 건만 가능합니다.");
				return;
			}

			var unit_price = mySheet.GetCellValue(arrRow[i], "UNIT_PRICE");
			if(unit_price == "" || kepIsValueNull(unit_price)){
				alert("매출단가를 업로드하여 주십시오");
				mySheet.SelectCell(arrRow[i], "UNIT_PRICE");
				return;
			}
			
			var to_date = mySheet.GetCellValue(arrRow[i], "TO_DATE");
			if(to_date == "" || kepIsValueNull(to_date)){
				alert("매출단가유효일을 업로드하여 주십시오");
				mySheet.SelectCell(arrRow[i], "TO_DATE");
				return;
			}
		}

		cc = confirm("선택된 내역으로 판가제출 하시겠습니까?");
		
		if(cc){
			approvalType = str;
			$("#st_approval_gubun").val("CRU");
			kepSave(document.searchCondition ,  mySheet , "/mdcm/sendMasterMdCmCatalogReg.do" , "SELECTED" );
		}else {
			return;
		}
		break;
		
	case "sourcingReSend":	// 재소싱요청
		if (mySheet.RowCount() == 0){
			alert("조회된 데이터가 없습니다.  ");
			return;
		}
		
		if (selectedGrid.length == 0){
			alert("재소싱할 대상을 선택해 주십시요. ");
			return;
		}
		
		for(var i=0; i<arrRow.length; i++){
			var status = mySheet.GetCellValue(arrRow[i], "STATUS");
			
			if(status == "C"){
				alert("진행상태 : 완료 건은 처리할 수 없습니다.");
				mySheet.SelectCell(arrRow[i], "STATUS_TEXT");
				return;
			} 
			if(status == "U" || status == "G"){
				alert("진행상태 : 결재중인 건은 처리할 수 없습니다.");
				mySheet.SelectCell(arrRow[i], "STATUS_TEXT");
				return;
			}
			if(status != "S"){
				alert("진행상태 : 소싱제출이 아닌 건은 처리할 수 없습니다.");
				mySheet.SelectCell(arrRow[i], "STATUS_TEXT");
				return;
			}
		}
		
		if (!confirm("선택된 내역을 재소싱요청 하시겠습니까?  ")) {
			return;
		}else{
			popupSel = "sourcingReSend";
			openSearchPopup("/common/remarkCancelPop.do",'?viewType=catalogRegReSourcing',"500,230,no");
		}
		
		break;
		
	case "del":	// 취소
		if (mySheet.RowCount() == 0){
			alert("조회된 데이터가 없습니다.  ");
			return;
		}
		
		if (selectedGrid.length == 0){
			alert("취소할 대상을 선택해 주십시요. ");
			return;
		}
		
		for(var i=0; i<arrRow.length; i++){
			var status = mySheet.GetCellValue(arrRow[i], "STATUS");
			
			if(status == "C"){
				alert("진행상태 : 완료 건은 취소할 수 없습니다.");
				mySheet.SelectCell(arrRow[i], "STATUS_TEXT");
				return;
			} 
			if(status == "U" || status == "G"){
				alert("진행상태 : 결재중인 건은 취소할 수 없습니다.");
				mySheet.SelectCell(arrRow[i], "STATUS_TEXT");
				return;
			} 
		}
		
		if (!confirm("선택된 내역을 취소 하시겠습니까?  ")) {
			return;
		}else{
			popupSel = "cancelRemark";
			openSearchPopup("/common/remarkCancelPop.do",'?viewType=catalogRegReqCancel',"500,230,no");
		}
		
		break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
		,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
		,value21,value22,value23,value24,value25,value26,value27,value28,value29){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 고객사
		//그룹을 선택할 수 없도록 처리.
		if(value4 == "1"){
			alert("그룹은 선택할 수 없습니다.");
			return;
		}
		
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
		mySheet.RemoveAll();
	} else if(popupSel == "cancelRemark") {	// 취소
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow = selectedGrid.split("|");
		
		for(var i=0; i<arrRow.length; i++){
			mySheet.SetCellValue(arrRow[i], "CANCLE_REMARK", value1);
		}
		
		kepSave(document.searchCondition ,  mySheet , "/mdcm/delMasterMdCmCatalogRegProgressList.do" , "SELECTED" );
	} else if(popupSel == "sourcingReSend") {	// 재소싱요청
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow = selectedGrid.split("|");
		
		for(var i=0; i<arrRow.length; i++){
			mySheet.SetCellValue(arrRow[i], "RSO_REQ_NOTE", value1);
		}
		
		kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMdCmCatalogRegReSourcingList.do" , "SELECTED" );
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

function mySheet_OnLoadExcel() {
	var maxRow  = mySheet.RowCount();
	if(maxRow == 0){
		  return;
	}
	
	if (5001 < maxRow + 1) {
		alert("5000건이하의 파일만 업로드하여 주세요.");
		mySheet.RemoveAll();
		return;
	}
	
	for(var i=1; i<=maxRow; i++){
		mySheet.SetCellValue(i,"SELECTED","1");
		
		var ca_req_no = mySheet.GetCellValue(i, "CA_REQ_NO");
		if(kepIsValueNull(ca_req_no)){
			mySheet.RemoveAll();
			alert("요청번호는 필수 입력 사항입니다.");
			return;
		}
		
		var ca_req_seq = mySheet.GetCellValue(i, "CA_REQ_SEQ");
		if(kepIsValueNull(ca_req_seq)){
			mySheet.RemoveAll();
			alert("요청순번은 필수 입력 사항입니다.");
			return;
		}
		
		var ca_req_revision = mySheet.GetCellValue(i, "CA_REQ_REVISION");
		if(kepIsValueNull(ca_req_seq)){
			mySheet.RemoveAll();
			alert("차수는 필수 입력 사항입니다.");
			return;
		}
	}
	
	if(excelLoadType == "loadExcelSourcing"){ // 소싱변경
		kepSave(document.searchCondition ,  mySheet , "/mdcm/batchMasterMdCmCatalogRegSourcingList.do" , "SELECTED" );
	}else{ // 판가변경
		kepSave(document.searchCondition ,  mySheet , "/mdcm/batchMasterMdCmCatalogRegUnitPriceList.do" , "SELECTED" );
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}
	
	for(var i=1; i<=totRow;i++){
		var revision = mySheet.GetCellValue(i,"CA_REQ_REVISION");
		if(revision > 1){
			mySheet.SetCellFontColor(i,"CA_REQ_REVISION","blue");
			mySheet.SetCellFontBold(i, "CA_REQ_REVISION",1);
			mySheet.SetDataLinkMouse("CA_REQ_REVISION", 1);
		}
	}
	
	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	//mode, product_close_flag 초기화
	if (msg != "") {
		if(typeof(msg) == "object"){
			alert(msg.msg);			
		}else{
			alert(msg);
		}
	}

	if(code == 1 && msg.usrmsg != "" && msg.usrmsg != "undefined" && msg.usrmsg != "N"){
		if(approvalType == "sourcingSend"){
			var type = "CRS";
		}else if(approvalType == "unitPriceSend"){
			var type = "CRU";
		}
		
		//결재
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE='+type+'&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg.usrmsg+'&PARAM1=KRKORE0001', "1000,500,no");
	//}else if(code>0){
	}else{
		//저장 성공시 재조회
		doAction('search');
	}
	
	approvalType = ""; // 상태 초기화
	excelLoadType = ""; // 상태 초기화
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;
	}
}

//그리드 셀 변경시 이벤트
//SLOGIC-BEGIN(P03-3010-01)
function mySheet_OnChange(Row, Col, Value) {
	var column = mySheet.ColSaveName(Col);
	grbRow = Row; //현재 Row를 전역변수에 셋팅
	
	if(column == "DESCRIPTION"){    //품목명 입력시
		mySheet.SetCellValue(Row,"DESCRIPTION", FilterString(Value));
		mySheet.SetCellValue(Row,"DESCRIPTION_ENG", FilterString(Value));
		mySheet.SetCellValue(Row,"KEP_DESCRIPTION", FilterString(Value));
	}
	
	if(column == "SPECIFICATION"){ //규격 입력시
		mySheet.SetCellValue(Row,"SPECIFICATION", FilterString(Value));
		mySheet.SetCellValue(Row,"SPECIFICATION_ENG", FilterString(Value));
		mySheet.SetCellValue(Row,"KEP_SPECIFICATION", FilterString(Value));
	}
}
//SLOGIC-END

function FilterString(val){

    var str= "";
    // 특수문자 아스키코드 값
    // $    ==> 36
    // '    ==> 39
    // "    ==> 34
    // ^    ==> 94
    for(var i=0;i<val.length;i++){
        if(val.charCodeAt(i) == 36){
		      str+=val.charAt(i).replace("$", "＄");
			}else if(val.charCodeAt(i) == 39) {
				  str+=val.charAt(i).replace("'", "′");
			}else if(val.charCodeAt(i) == 34) {
				  str+=val.charAt(i).replace("\"", "″");
			}else if(val.charCodeAt(i) == 94) {
				  str+=val.charAt(i).replace("^", "＾");
			}else if(val.charCodeAt(i) == 60) {
				  str+=val.charAt(i).replace("<", "〈");
			}else if(val.charCodeAt(i) == 62) {
				  str+=val.charAt(i).replace(">", "〉");
			}else {
				  str+=val.charAt(i);
			}
    }
    return str;
}

//품목명,규격 좌우 공백 제거
function trimValue(row){ 
	  var ch_desc = $.trim(mySheet.GetCellValue(row,"DESCRIPTION"));
	  var ch_spec = $.trim(mySheet.GetCellValue(row,"SPECIFICATION"));
	  mySheet.SetCellValue(row, "DESCRIPTION", ch_desc);
	  mySheet.SetCellValue(row, "SPECIFICATION", ch_spec);
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if(column == "CA_REQ_REVISION" ){ // 등록 차수
		var ca_req_no = mySheet.GetCellValue(Row, "CA_REQ_NO");
		var ca_req_seq = mySheet.GetCellValue(Row, "CA_REQ_SEQ");
		var ca_req_revision = mySheet.GetCellValue(Row, "CA_REQ_REVISION");
		
		if(ca_req_revision > 1){
			//post 팝업 파라미터 설정
			var st_form_name = "revisionPopForm";
			var st_popup_url = "/mdcm/showMasterMdCmCatalogRegRevisionPop.do";
			var st_popup_param = "st_ca_req_no@@"+ca_req_no+"^||^"+"st_ca_req_seq@@"+ca_req_seq;
			var st_popup_option = "850,400,no";
			//post 팝업 호출
			openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
		}else{
			return;
		}
	}
}

function kepApprovalReturn(flag,docu_no){
	doAction('search');
}

//페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmCatalogRegProgressList.do?page="+current_page , pagingMode );
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA">
			<h3>카탈로그 소싱 진행</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
			<input type="hidden" id="st_user_name" name="st_user_name"  value="${sessionInfo.userNameLoc}">
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
			<input type="hidden" id="st_warehouse_code" name="st_warehouse_code" value="">
			<input type="hidden" id="st_below_comorg_code" name="st_below_comorg_code" value="">
			<input type="hidden" name="st_sour_dept_yn"  id="st_sour_dept_yn" value ="<%=st_sour_dept_yn%>">
            <input type="hidden" name="st_approval_gubun"  id="st_approval_gubun" value ="">
			
            	<table  class="cont_t_list01" >
					<caption>카탈로그 소싱 진행</caption>
					<colgroup>
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>요청일</th>
							<td colspan="3">
								<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" > - 
								<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" >
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
							</td>
							
						<%if(st_sour_dept_yn.equals("Y")){%>
							<th>고객사</th>
						<%}else{%>
							<th><font color="red"><b>*</b></font>고객사</th>
						<%}%>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:55%" value="" readonly onclick="doPop('buyer_single');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
						<tr> 
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:80%;" value="" onkeydown="kepEnter()">
							</td>
							<th>품목명</th>
				      		<td>
				      			<input type="text" class="input_type_text"  name="st_description" id="st_description" style="width:80%;" value="" onKeyDown="kepEnter()">
				      		</td>
				      		<th>규격</th>
				      		<td>
				      			<input type="text" class="input_type_text"  name="st_specification" id="st_specification" style="width:80%;" value="" onKeyDown="kepEnter()">
				      		</td>
						</tr>
						<tr>
							<th>요청타입</th>
				      		<td>
				      			<select id="st_req_type" name="st_req_type" style="width:80%;height:20px"></select>
				      		</td>
				      		<th>진행상태</th>
							<td>
								<select id="st_status" name="st_status" style="width:80%;height:20px"></select>
							</td>
							<th>소싱요청번호</th>
				      		<td>
				      			<input type="text" class="input_type_text"  name="st_contract_no" id="st_contract_no" style="width:80%;" value="" onKeyDown="kepEnter()">
				      		</td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span style="position:absolute; left:0;"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
				<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="50">50건</option>
					<option value="100">100건</option>
					<option value="500">500건</option>
					<option value="1000">1000건</option>
					<option value="5000">5000건</option>
				</select>
			</span>
			<br/>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea" style="margin-bottom:0px;">
  	          	<span class="fl">
  				<%if(st_sour_dept_yn.equals("Y") && !st_user_id.equals("KEP2119104")){%>
  					<span class="btn_04 mr04"><a href="/resources/excel/work/CATALOG/masterMdCmCatalogRegSourcing.xls">소싱변경양식</a></span>
  					<span class="btn_04 mr04"><a href="javascript:doAction('loadExcelSourcing');">일괄업로드</a></span>
  				<%}else{%>
  					<span class="btn_04 mr04"><a href="/resources/excel/work/CATALOG/masterMdCmCatalogRegUnitPrice.xls">판가변경양식</a></span>
  					<span class="btn_04 mr04"><a href="javascript:doAction('loadExcelUnitPrice');">일괄업로드</a></span>
  				<%}%>
  				</span>
  				
  				<span class="fr">
  					<span class="btn_04 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				<%if(st_sour_dept_yn.equals("Y") && !st_user_id.equals("KEP2119104")){%>
  					<span class="btn_02 mr04"><a href="javascript:doAction('sourcingSend');">소싱제출</a></span>
				<%}else{%>
  					<span class="btn_02 mr04"><a href="javascript:doAction('unitPriceSend');">판가제출</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('sourcingReSend');">재소싱 요청</a></span>
				<%}%>
					<span class="btn_02 mr04"><a href="javascript:doAction('del');">취소</a></span>
  				</span>
  			 </div>
  			 <br>
  			 <b><font color="red">※ 업로드 전 현재 내역을 다운받아 최신 내용을 기준으로 업로드하시기 바랍니다.</font></b><br>
  			 <b><font color="red">※ 모든 처리 전에 입력값이 제대로 들어갔는지 꼭 확인하시기 바랍니다.</font></b><br>
  			 <b><font color="red">※ 계약서항번이 없는 품목은 신규 등록으로 처리됩니다.</font></b>

<!--내용 종료-->	                 
</body>
</html>
