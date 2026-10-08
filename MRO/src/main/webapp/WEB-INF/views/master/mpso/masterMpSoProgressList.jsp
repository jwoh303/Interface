<%--
**********************************************
* 메뉴 :    
* 화면 : 주문진행관리
* 기능 : 
* 프로그램 ID : PG_06_M_002_00
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-07-08
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String st_user_dept = ""; //사용자 부서
if (_sessionInfo != null){
	st_user_dept = _sessionInfo.getDepartment();
} 
%>
<!-- 다중선택콤보(공통) - 사용시 필수 선언 start -->
<script src="/resources/js/jquery.multiple.select.js"></script>
<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<!-- 다중선택콤보(공통) - 사용시 필수 선언 end -->

<title>Insert title here</title>
<script>
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
	var popupSel = "";
	var grbRow;
	var diskOn = "/resources/images/disk_on.gif";
	var diskOff = "/resources/images/disk_off.gif";
	var remarkOn="/resources/images/but_icon01.gif";
	var remarkOff="/resources/images/but_icon02.gif";
	
	
	//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function initPage() {
		
		var initsheet = {};
		initsheet.Cols = [ 
			
			{Align : "Center", SaveName :"SELECTED",          Header:"|",				Type : "Radio",     Width : 30,      Edit : true}
			,{Align : "Center", SaveName : "SCM_REMARK",            Header : "SCM\n비고|SCM\n비고",	Type : "Text",		EditLen : 60,              Width : 40,		Edit : false}
			,{Align : "Center", SaveName : "ISSUE",            Header : "운영\n이슈|운영\n이슈",	Type : "Text",		EditLen : 60,              Width : 40,		Edit : false}
			,{Align : "Center", SaveName : "BUYER_NAME",          Header : "고객사|고객사",			Type : "Text",		EditLen : 100,             Width : 110,		Edit : false}
			,{Align : "Center", SaveName : "STATUS_TEXT",				Header : "진행상태|진행상태",			Type : "Text",		EditLen : 100,             Width : 80,		Edit : false, ToolTip:true}
			,{Align : "Left", SaveName : "AGENT_NAME",          Header : "협력사명|협력사명",       Type : "Text",		EditLen : 100,             Width : 110,		Edit : false, ToolTip:true}
			
			,{Align : "Center", SaveName : "PO_NO",				Header : "발주정보|발주번호",			Type : "Text",		EditLen : 100,             Width : 80,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "PO_SEQ",			 Header : "발주정보|발주항번",			Type : "Text",		EditLen : 100,             Width : 60,		Edit : false}
			,{Align : "Right", SaveName : "PO_QTY",				Header : "발주정보|발주수량",			Type : "AutoSum",		EditLen : 100,             Width : 60,		Edit : false,Format:"Float"}
			,{Align : "Center", SaveName : "LEGACY_PO_NO",        Header : "발주정보|IF발주번호",       Type : "Text",		EditLen : 100,             Width : 60,		Edit : false}
			,{Align : "Center", SaveName : "LEGACY_PO_SEQ",    Header : "발주정보|주문항번",			Type : "Text",		EditLen : 100,             Width : 60,		Edit : false}
			,{Align : "Center", SaveName : "ADD_DATE",			Header : "발주정보|생성일",			Type : "Date",		EditLen : 100,             Width : 80,		Edit : false}
			,{Align : "Center", SaveName : "PO_DATE",			Header : "발주정보|발주일",			Type : "Date",		EditLen : 100,             Width : 80,		Edit : false}
			,{Align : "Center", SaveName : "PO_DEPT_NAME",   Header : "발주정보|발주부서",			Type : "Text",		EditLen : 100,            Width : 100,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "PO_USER_NAME",   Header : "발주정보|발주자",			Type : "Text",		EditLen : 100,            Width : 60,		Edit : false,	Hidden : true}
			,{Align : "Center", SaveName : "PO_USER_NAME_MASK",   Header : "발주정보|발주자",			Type : "Text",		EditLen : 100,            Width : 60,		Edit : false, ToolTip:true}

			,{Align : "Center", SaveName : "BUYER_ITEM_NO",       Header : "상품정보|품목코드",			Type : "Text",		EditLen : 50,             Width : 80,		Edit : false, ToolTip:true}
			,{Align : "Left", SaveName : "DESCRIPTION",        Header : "상품정보|품목명",				Type : "Text",		EditLen : 250,             Width : 130,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "SPECIFICATION",      Header : "상품정보|규격",				Type : "Text",		EditLen : 100,             Width : 150,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "MAKER_NAME",         Header : "상품정보|제조사",			Type : "Text",		EditLen : 100,             Width : 100,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "ORIGIN_TEXT",         Header : "상품정보|원산지",			Type : "Text",		EditLen : 100,             Width : 150,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "UNIT_MEASURE",       Header : "상품정보|단위",				Type : "Text",		EditLen : 100,             Width : 55,		Edit : false, ToolTip:true}
			
			,{Align : "Right", SaveName : "UNIT_PRICE",         Header : "매출정보|매출단가",			Type : "Float",		Format:"${priceFormat}", EditLen : 100,             Width : 70,		Edit : false}
			,{Align : "Right", SaveName : "UNIT_SUM",			Header : "매출정보|매출금액",			Type : "AutoSum",	Format:"${priceFormat}", EditLen : 100,             Width : 80,		Edit : false}
			,{Align : "Right", SaveName : "AGENT_PRICE",        Header : "매입정보|매입단가",			Type : "Float",		Format:"${priceFormat}", EditLen : 100,             Width : 70,		Edit : false}
			,{Align : "Right", SaveName : "AGENT_SUM",          Header : "매입정보|매입금액",			Type : "AutoSum",	Format:"${priceFormat}",	EditLen : 100,             Width : 80,		Edit : false}

			,{Align : "Center", SaveName : "REF_PR_NO",           Header : "관리번호|관리번호",			Type : "Text",		EditLen : 100,             Width : 70,		Edit : false}


			,{Align : "Center", SaveName : "RD_DATE",			Header : "납품정보|납기요청일",       Type : "Date",		EditLen : 100,             Width : 100,		Edit : false}
			,{Align : "Center", SaveName : "HA_DATE",			Header : "납품정보|납품합의일",       Type : "Text",		EditLen : 100,             Width : 100,		Edit : false}
			,{Align : "Center", SaveName : "CD_DATE",			Header : "납품정보|협력사납품예정일",       Type : "Date",		EditLen : 100,             Width : 100,		Edit : false}
			,{Align : "Center", SaveName : "BUYER_DS_DATE",			Header : "납품정보|KeP납품예정일",       Type : "Date",		EditLen : 100,             Width : 100,		Edit : false}
			,{Align : "Center", SaveName : "ST_DATE",			Header : "납품정보|표준납기일",       Type : "Date",		EditLen : 100,             Width : 100,		Edit : false}
			,{Align : "Center", SaveName : "INVOICE_DATE",       Header : "납품정보|납품일",			Type : "Date",		EditLen : 100,             Width : 100,		Edit : false}
			,{Align : "Right", SaveName : "INV_QTY",			Header : "납품정보|납품수량",			Type : "AutoSum",		EditLen : 100,             Width : 70,		Edit : false,Format:"Float"}

			,{Align : "Center", SaveName : "DELIVERY_ADD_DATE", Header : "배송정보|확정등록일",		Type : "Date",		EditLen : 200,             Width : 100,		Edit : false}
			,{Align : "Center", SaveName : "DELIVERY_DATE",     Header : "배송정보|확정일",			Type : "Date",		EditLen : 200,             Width : 100,		Edit : false}
			,{Align : "Right", SaveName : "DELIVERY_QTY",       Header : "배송정보|확정수량",			Type : "AutoSum",		EditLen : 100,             Width : 70,		Edit : false,Format:"Float"}

			,{Align : "Center", SaveName : "GR_DATE",			Header : "입고정보|입고일",			Type : "Date",		EditLen : 100,             Width : 100,		Edit : false}
			,{Align : "Right", SaveName : "GR_QTY1",			Header : "입고정보|입고수량",			Type : "AutoSum",	EditLen : 100,             Width : 70,		Edit : false,Format:"Float"}
			,{Align : "Right", SaveName : "GR_UNIT_SUM",		Header : "입고정보|입고매출금액",		Type : "Float",		Format:"${priceFormat}", EditLen : 100,             Width : 80,		Edit : false}
			,{Align : "Right", SaveName : "GR_AGENT_SUM",		Header : "입고정보|입고매입금액",		Type : "Float",		Format:"${priceFormat}", EditLen : 100,             Width : 80,		Edit : false}

			,{Align : "Center", SaveName : "BUYER_CATEG_ID",		Header : "카테고리|카테고리ID",		Type : "Text",		EditLen : 150,            Width : 100,      Edit : false}
			,{Align : "Center", SaveName : "BUYER_CATEG_NAME", 	Header : "카테고리|카테고리명",		Type : "Text",		EditLen : 150,            Width : 100,      Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "BUYER_CATEG_PATH",	    Header : "카테고리|카테고리경로",		Type : "Text",		EditLen : 150,            Width : 150,      Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "CMS_CATEG_ID",		  Header : "카테고리|표준카테고리ID",	Type : "Text",		EditLen : 150,            Width : 100,      Edit : false}
			,{Align : "Center", SaveName : "CATEG_PATH",		  Header : "카테고리|표준카테고리경로",	Type : "Text",		EditLen : 150,            Width : 150,      Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "SOUR_MNG",		  Header : "카테고리|SG담당자",	Type : "Text",		EditLen : 80,            Width : 80,      Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "REQ_DEPT_NAME",      Header : "요청부서|요청부서",			Type : "Text",		EditLen : 100,             Width : 70,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "REQ_USER_NAME_MASK",      Header : "요청자|요청자",			Type : "Text",		EditLen : 100,             Width : 60,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "REQ_USER_NAME",      Header : "요청자|요청자",			Type : "Text",		EditLen : 100,             Width : 60,		Edit : false,	Hidden : true}
			,{Align : "Center", SaveName : "CANCEL_REMARK",  Header : "발주삭제사유|발주삭제사유",     Type : "Text",		EditLen : 150,            Width : 100,      Edit : false}
			
			,{Align : "Center", SaveName : "REF_IF_NO",			 Header : "I/F관리번호|I/F관리번호",		Type : "Text",		EditLen : 150,            Width : 100,      Edit : false}
			,{Align : "Left", SaveName : "PO_REMARK",		    Header : "비고|비고",				Type : "Text",		EditLen : 150,            Width : 100,      Edit : false}
			,{Align : "Center", SaveName : "PROCESS_TEXT",		    Header : "거래유형|거래유형",			Type : "Text",		EditLen : 150,            Width : 100,      Edit : false}
		
			,{Align : "Center", SaveName : "AGENT_CODE", Hidden : true,        Header : "AGENT_CODE|AGENT_CODE",       Type : "Text",		EditLen : 100,			 Width : 80,      Edit : false}
			,{Align : "Center", SaveName : "AGENT_IRS_NO",	Header : "협력사|협력사사업자번호", Type : "Text",		EditLen : 150,            Width : 100,      Edit : false}
			,{Align : "Left", SaveName : "ORIGIN_AGENT",		    Header : "협력사|실협력사코드",		Type : "Text",		EditLen : 150,            Width : 150,      Edit : false}
			,{Align : "Center", SaveName : "ORIGIN_AGENT_NAME",	    Header : "협력사|실협력사명",		Type : "Text",		EditLen : 150,            Width : 100,      Edit : false}

			,{Align : "Left", SaveName : "WAREHOUSE_NAME",		   Header : "물류센터명|물류센터명",		Type : "Text",		EditLen : 150,            Width : 150,      Edit : false, ToolTip:true}
			,{Align : "Left", SaveName : "PO_REMARK_HD_MASK",		   Header : "비고2|비고2",			Type : "Text",		EditLen : 4000,            Width : 100,      Edit : false, ToolTip:true}
			,{Align : "Left", SaveName : "PO_REMARK_HD",		   Header : "비고2|비고2",			Type : "Text",		EditLen : 4000,            Width : 100,      Edit : false, ToolTip:true,	Hidden : true}
			,{Align : "Right", SaveName : "UNIT_TAX",			   Header : "목표가|목표가",			Type : "Int",		EditLen : 150,            Width : 100,      Edit : false}
			,{Align : "Left", SaveName : "LOG_TEXT",	   Header : "도착지|도착지",			Type : "Text",		EditLen : 150,            Width : 150,      Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "ACCOUNT_TYPE",	   Header : "예산계정|예산계정",			Type : "Text",		EditLen : 100,            Width : 100,      Edit : false}
		
			,{Align : "Center", SaveName : "PR_NO",				  Header : "요청번호\n(주문이력)|요청번호\n(주문이력)",			Type : "Text",		EditLen : 100,             Width : 80,		Edit : false}
			,{Align : "Center", SaveName : "PR_SEQ",				   Header : "요청항번|요청항번",			Type : "Text",		EditLen : 100,             Width : 70,		Edit : false}
			,{Align : "Center", SaveName : "CARD_USE_FLAG",		  Header : "카드사용여부|카드사용여부",		Type : "Text",		EditLen : 120,             Width : 80,		Edit : false}
			,{Align : "Center", SaveName : "CARD_CONFIRM_NO",	    Header : "카드승인번호|카드승인번호",		Type : "Text",		EditLen : 160,             Width : 70,		Edit : false}
			,{Align : "Center", SaveName : "IMAGE_KEY_YN",			   Header : "첨부|첨부",			Type : "Image",		EditLen : 160,             Width : 70,		Edit : false}
			,{Align : "Center", SaveName : "ITEM_MAKE_TYPE",			   Header : "품목구분|품목구분",			Type : "Text",		EditLen : 160,             Width : 100,		Edit : false}
			,{Align : "Center", SaveName : "IMAGE_KEY",			Hidden : true,	    Header : "첨부|첨부",			Type : "Text",		EditLen : 160,             Width : 0,		Edit : false }
			,{Align : "Center", SaveName : "PO_IMAGE_KEY_YN",			   Header : "운영자첨부|운영자첨부",			Type : "Image",		EditLen : 160,             Width : 70,		Edit : false}
			,{Align : "Center", SaveName : "PO_IMAGE_KEY",			Hidden : true,	    Header : "운영자첨부|운영자첨부",			Type : "Text",		EditLen : 160,             Width : 0,		Edit : false }
			,{Align : "Center", SaveName : "CONTRACT_NO",	Hidden : true,	    Header : "계약서번호|계약서번호",		Type : "Text",		EditLen : 100,             Width : 60,      Edit : false}
			,{Align : "Center", SaveName : "CONTRACT_SEQ", Hidden : true,      Header : "계약서항번|계약서항번",		Type : "Text",		EditLen : 100,             Width : 60,      Edit : false}
			,{Align : "Center", SaveName : "BUYER",		Hidden : true,		Header : "고객사코드|고객사코드",		Type : "Text",		EditLen : 100,             Width : 60,      Edit : false}
			,{Align : "Center", SaveName : "BYIT_COMORG_CODE", Hidden : true,  Header : "카탈로그관리코드|카탈로그관리코드", Type : "Text",		EditLen : 100,             Width : 60,      Edit : false}
			,{Align : "Center", SaveName : "PO_USER_ID",      Hidden : true,   Header : "발주자|발주자",			Type : "Text",		EditLen : 100,             Width : 60,      Edit : false}
			,{Align : "Center", SaveName : "REQ_USER_ID",     Hidden : true,   Header : "요청자|요청자",			Type : "Text",		EditLen : 100,             Width : 60,      Edit : false}
			,{Align : "Left", SaveName : "DS_REMARK",      Hidden : true,    Header : "DS_REMARK|DS_REMARK",        Type : "Text",		EditLen : 100,              Width : 0,      Edit : false}
			,{Align : "Center", SaveName : "DOC_TYPE",        Hidden : true, Header : "DOC_TYPE|DOC_TYPE",        Type : "Text",		EditLen : 100,              Width : 100,      Edit : false}
			,{Align : "Center", SaveName : "MAKER_PART_NO",	Header : "모델명|모델명",	Type : "Text",	EditLen : 160,	Width : 100,	Edit : false}
			,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"PLANT담당자|PLANT담당자",	SaveName:"PLANT_USER_NM"}
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"외화정보|통화단위",	SaveName:"EXP_CUR"}
			,{Align : "Right", SaveName : "EXP_CUR_PRICE",		Header : "외화정보|환율",		Type : "Float",		Format:"${priceFormat}", EditLen : 100,             Width : 80,		Edit : false}
			,{Align : "Right", SaveName : "EXP_FOR_UNIT_PRICE",		Header : "외화정보|매출단가",		Type : "Float",		Format:"${priceFormat}", EditLen : 100,             Width : 80,		Edit : false}
			,{Align : "Right", SaveName : "EXP_FOR_ITEM_AMT",		Header : "외화정보|매출금액",		Type : "Float",		Format:"${priceFormat}", EditLen : 100,             Width : 80,		Edit : false}
			,{Align : "Center", SaveName : "CHANGE_USER_DEPT",	Header : "발주부서|발주부서",	Type : "hidden",	EditLen : 160,	Width : 100,	Edit : false}
		];
		
		initsheet.Cfg = {MergeSheet:msHeaderOnly};
		IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
		mySheet.SetCountPosition(4);
		
		//합계행을 감춘다.
		mySheet.SetRowHidden(mySheet.LastRow(),1);
		//조회조건 초기값 설정
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		$("#st_from_date").val( kepToMonthAdd("1","M") );
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );

		//파일첨부이미지설정
		mySheet.SetImageList(2, diskOff);
		mySheet.SetImageList(3, diskOn);
		//콤보데이터 셋팅		
		kepAjaxCommonQueryIdCombo('st_kep_user_id','getSgKepUserList','ALL2','');
		//PLANT담당자 콤보데이터 셋팅. 로그인  부서 기준 사용자 리스트
		var st_user_dept = "<%=st_user_dept%>";
		kepAjaxCommonQueryIdSearchTwoCombo('st_plant_user_id','common.masterDepartmentUserList','',st_user_dept,'ALL','');
		setLinkCol(mySheet, "SCM_REMARK"); // SCM비고
		setLinkCol(mySheet, "BUYER_NAME");
		setLinkCol(mySheet, "PR_NO");
		setLinkCol(mySheet, "PO_NO");
		setLinkCol(mySheet, "PO_USER_NAME");
		setLinkCol(mySheet, "AGENT_NAME");
		setLinkCol(mySheet, "BUYER_ITEM_NO");
		setLinkCol(mySheet, "HA_DATE");
		setLinkCol(mySheet, "GR_DATE"); //일고일
		setLinkCol(mySheet, "CD_DATE"); //납품예정일
		setLinkCol(mySheet, "INVOICE_DATE"); // 납품일
		setLinkCol(mySheet, "REQ_USER_NAME");
		setLinkCol(mySheet, "IMAGE_KEY_YN");
		setLinkCol(mySheet, "PO_IMAGE_KEY_YN");
		setLinkCol(mySheet, "ISSUE"); // 운영이슈
		
		if("<%=st_user_dept%>" == "095" || $("#SessionUserId").val() == "KEP2179027"){
			setLinkCol(mySheet, "LEGACY_PO_NO");
		}
		
		// 다중선택콤보(공통) - 생성
// 		var test = "PO10,PO30,PO50";		// 초기화 시 아이템 선택 값
		kepAjaxCommonTotalMultiComboMpso('st_status', 'C018', 'ALL', '');
		
	}

	var mt;
	//기능함수
	function doAction(str) {
		
		switch (str) {
		case "search":
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			
			if(!validCheck('true')){
				return;
			}
			
			// 마스킹 해제
			$("#st_non_masking_flag").val('N');
			
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpso/masterMpSoProgress.do" , pagingMode );
			
			break;
		case "save":

			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow     = selectedGrid.split("|");
			if (mySheet.RowCount() == 0){
				alert("품목이 없습니다.");
			}
			if (selectedGrid.length == 0){
				alert("선택하신 품목이 없습니다.");
				return;
			}
// 			if (!confirm('선택한 품목을 삭제 하시겠습니까?')){
// 				return;
// 			}
			if (!checkValidation('true')){
				return;
			}
			
			// 시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.
			IBS_SaveName(document.searchCondition,mySheet);

			// 조회조건 묶기
			var info = FormQueryStringEnc(document.searchCondition,true);
			if(info){
				// 저장
			 	 mySheet.DoSave("/mpso/saveMasterMpSoProgress.do",info,"SELECTED");
			}

			break;
		case "saveFile": //첨부파일 Save
			var info = FormQueryStringEnc(document.searchCondition,true);
			mySheet.DoSave("/mpso/saveFileMasterMpSoProgress.do",info,"SELECTED");		
			break;
		case "IKENGJ": // IKEN결재
			var user_id = $("#SessionUserId").val();
			
			if(user_id !="KEP200424" && user_id !="KEP200502" && user_id !="KEP2129070"  
					&& user_id !="KEP2109118"  && user_id !="KEP2149541"  && user_id !="KEP2129068"  
						&& user_id !="KEP200427" && user_id !="KEP2149532" && user_id !="KEP2149546" 
							&& user_id !="KEP2129067" && user_id !="KEP200427" && user_id !="KEP2129158") {

				alert("결재상신은 특정 DB Admin의 권한 입니다.\n\n시스템운영팀에 문의 바랍니다.(02-3016-8911)");
				return;
			}

			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow     = selectedGrid.split("|");
			if (mySheet.RowCount() == 0){
				alert("품목이 없습니다.");
				return;
			}
			if (selectedGrid.length == 0){
				alert("선택하신 품목이 없습니다.");
				return;
			}
// 			if (!confirm('선택한 품목을 삭제 하시겠습니까?')){
// 				return;
// 			}
// 			if (!checkValidation('true')){
// 				return;
// 			}
			
			// 시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.
			IBS_SaveName(document.searchCondition,mySheet);

			// 조회조건 묶기
			var info = FormQueryStringEnc(document.searchCondition,true);
			if(info){
				// 저장
			 	 mySheet.DoSave("/mpso/saveIKENMasterMpSoProgress.do",info,"SELECTED");
				
				setIKENGJ();
			}

			break;
		case "excelDown": // 엑셀다운로드
			if(!validCheck('true')){
				return;
			}
		
		    $("#pageflag").val('0');
	
// 		    mySheet.SetColHidden("SELECTED", true);
// 		    alert(mySheet.GetColHidden("SELECTED"));
		    
		    var downCol = "";
			for(var i=0;i<=mySheet.LastCol();i++){
				if(!mySheet.GetColHidden(i) && mySheet.ColSaveName(i) !="SELECTED"){
					downCol += "|"+i;	
				}
			}

			// 마스킹 해제
			$("#st_non_masking_flag").val('Y');
			
			var param = {FileName:"주문진행관리.xlsx",DownCols:downCol.substring(1)};

			kepDownExcel(document.searchCondition ,mySheet , "/mpso/excelMasterMpSoProgress.do", param);
			$("#pageflag").val('1');
			break;
		case "reload":
			kepReload('searchCondition');
			$("#st_buyer_code").val('');
			$("#st_agent_code").val('');
			$("#st_po_dept_code").val('');
			$("#st_req_dept_code").val('');			
			mySheet.RemoveAll();
			
			// 다중선택콤보(공통) - 초기화
			init_multiCombo("st_status");
			
			$("#st_from_date").val( kepToMonthAdd("1","M") );
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
			
			document.getElementById("st_checkbox").checked = false;
			document.getElementById("st_pocheckbox").checked = false;
			
			break;
		}
	}

	function mySheet_OnDownFinish(downloadType, result) {
		loader_obj("N");
	}
	
	function setIKENGJ() {
		
 		var Sessionkey = $("#sessionKey").val();
		sloagent.login("oldiken.kolon.com","80",Sessionkey);

		var kolon_username = sloagent.getvalue("username");
		var kolon_password = sloagent.getvalue("sessionpassword");		

		var userPW = kolon_password;
		var iken_id = kolon_username;

		var checkRows = mySheet.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		var checkedCnt = arrRow.length;

		if (checkRows == '' || arrRow.length == 0){
			alert("선택하신 품목이 없습니다.");
			return;
		}
		
		
		var buyer = "";
		var po_no = "";
		var po_seq = "";
		for ( var i = 0; i < checkedCnt; i++) {
			buyer            = mySheet.GetCellValue(arrRow[i], "BUYER");
			po_no            = mySheet.GetCellValue(arrRow[i], "PO_NO");
			po_seq           = mySheet.GetCellValue(arrRow[i], "PO_SEQ");
		}
		alert ("발주정보가 조회되지 않을 시 창을 닫고 재상신하시기 바랍니다.");
		var form= '구매 품의서';
		var link = 'http://203.225.2.137/mis_check_kep2.asp?form='+form+'&userID='+iken_id+'&userPW='+userPW+'&key01='+buyer+'&key02='+po_no+'&key03='+po_seq+'&exit=1';
		window.open(link);
	}
	
	function validCheck() {

	 	var buyer_code      = $("#st_buyer_code").val();
		var agent_code      = $("#st_agent_code").val();
		
		if(buyer_code == "" && agent_code == "") {
			alert("고객사 또는 협력사를 선택해 주십시요.");
			return false;
		}

		var buyer_item_no   = $("#st_buyer_item_no").val();//f.st_buyer_item_no.value;
		var if_po_no        = $("#st_if_po_no").val();//f.st_if_po_no.value;
		var po_no           = $("#st_po_no").val();
		var ref_no           = $("#st_ref_no").val();
	
		var checkAll = 'N';
		
		if(document.getElementById("st_pocheckbox").checked == true){
			 $("#st_doc_type").val('F');		
		}else{
			 $("#st_doc_type").val('N');					
		}

	    if(document.getElementById("st_checkbox").checked == true){
			if( buyer_item_no =="" &&  if_po_no =="" && po_no =="" && ref_no == ""){
				alert("기간을 무시하고 조회시\n\n고객사 선택후\n\n품목코드, I/F발주번호, 발주번호, 관리번호 중\n\n한가지 이상을 정확히(전체입력) 기입해야 조회가 됩니다.");	
				return false;
			}
			checkAll ="Y";
			$("#st_all_po").val('Y');
		}else{
// 			if (kepGetDateDiff('st_from_date','st_to_date','D') > 62 ){
// 				alert("조회기간을 2개월 단위로 조회가 가능합니다.\n\n2개월 이상의 데이타는 S/R 요청 바랍니다.");
// 				return false;
// 			}
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 31 ){
				alert("조회기간을 1개월 단위로 조회가 가능합니다.\n\n1개월 이상의 데이타는 S/R 요청 바랍니다.");
				return false;
			}
			checkAll = 'N';
			$("#st_all_po").val('N');
		}
		return true;
	}
	function mySheet_OnLoadData(DATA) {
		return DATA;
	}
	function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
		var totRow = mySheet.RowCount();
		var totRow = totRow+2;
		for(var i=2; i<= totRow;i++){
			mySheet.SetToolTipText(i, "PO_USER_NAME_MASK", mySheet.GetCellValue(i, "PO_USER_NAME"));
			mySheet.SetToolTipText(i, "REQ_USER_NAME_MASK", mySheet.GetCellValue(i, "REQ_USER_NAME"));
			mySheet.SetToolTipText(i, "PO_REMARK_HD_MASK", mySheet.GetCellValue(i, "PO_REMARK_HD"));
			
			var doc_type = mySheet.GetCellValue(i, 'DOC_TYPE'); 
			if(doc_type != 'DOC_TYPE'){
				if(doc_type == "F") { 
					mySheet.SetCellFontColor(i,"PO_NO","red");
				} 
			}
		}

		if (msg != "") {
			alert(msg);
		}
		document.forms.searchCondition.st_po_tot_cnt.value =  mySheet.GetCellText(mySheet.LastRow(),"PO_QTY"); //  kepCommaNum(po_tot_cnt);
		document.forms.searchCondition.st_gr_tot_cnt.value =  mySheet.GetCellText(mySheet.LastRow(),"GR_QTY1"); //kepCommaNum(gr_tot_cnt);
		document.forms.searchCondition.st_iv_tot_cnt.value =  mySheet.GetCellText(mySheet.LastRow(),"INV_QTY"); //kepCommaNum(iv_tot_cnt);
		document.forms.searchCondition.st_di_tot_cnt.value =  mySheet.GetCellText(mySheet.LastRow(),"DELIVERY_QTY"); //kepCommaNum(di_tot_cnt);
		document.forms.searchCondition.st_tot_item_amt.value =  mySheet.GetCellText(mySheet.LastRow(),"UNIT_SUM"); //kepCommaNum(tot_item_amt);
		document.forms.searchCondition.st_tot_agent_item_amt.value =  mySheet.GetCellText(mySheet.LastRow(),"AGENT_SUM"); //kepCommaNum(tot_agent_item_amt);
		
		//합계행을 감춘다.
 		mySheet.SetRowHidden(mySheet.LastRow(),1);
		
		
	}
	function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
		javascript:doAction('search');
		if (msg != "") {
			alert(msg);
		}
	}
	//팝업함수호출
	function doPop(str) {
		var st_buyer = kepReplaceAll("st_buyer_code","@","");

		switch (str) {
		case "prdept": // 요청부서
			if(st_buyer == "") {
				alert("고객사를 선택해 주십시요.");
				break;
			}
			var comCodeArr = st_buyer.split("@");
			openSearchPopup('/common/deptCodeAdminPop.do','?open=Y&com_code='+comCodeArr[0], '500,500,no');
			popupSel = "prdept";
			break;
		case "getTotalAmt": // 거래내역별집계
			var buyer_code      = $("#st_buyer_code").val();
			var agent_code      = $("#st_agent_code").val();
			
			if(buyer_code == "" && agent_code == "") {
				alert("고객사 또는 협력사를 선택해 주십시요.");
				break;
			}
			
			
			var date_type        = $("#st_date_type").val();//f.st_date_type.value;
			var status             = $("#st_status").val();//f.st_status.value;
			var buyer_code      = $("#st_buyer_code").val();
			var buyer_name     = $("#st_buyer_name").val();
			var agent_code      = $("#st_agent_code").val();
			var agent_name     = $("#st_agent_name").val();
			var buyer_item_no  = $("#st_buyer_item_no").val();
			var po_dept_name  = $("#st_po_dept_name").val();
			var po_dept_code   = $("#st_po_dept_code").val();
			var req_dept_name = $("#st_req_dept_name").val();
			var req_dept_code  = $("#st_req_dept_code").val();
			var if_po_no          = $("#st_if_po_no").val();
			var po_no             = $("#st_po_no").val();
			var ref_no             = $("#st_ref_no").val();
			var fromDate        = $("#st_from_date").val();
			var toDate            = $("#st_to_date").val();		
			var status_text       = $("#st_status"+ "_spare").multipleSelect("getSelects", "text");
			 
			openSearchPopup('/mpso/getMasterMpSoOrderTotalAmtMainPop.do','?st_date_type='+date_type+'&st_status='+status+'&st_buyer_code='+buyer_code+'&st_buyer_name='+buyer_name+'&st_agent_code='+agent_code+'&st_agent_name='+agent_name+'&st_buyer_item_no='+buyer_item_no+'&st_po_dept_name='+po_dept_name+'&st_po_dept_code='+po_dept_code+'&st_req_dept_name='+req_dept_name+'&st_req_dept_code='+req_dept_code+'&st_if_po_no='+if_po_no+'&st_po_no='+po_no+'&st_ref_no='+ref_no+'&st_from_date='+fromDate+'&st_to_date='+toDate+'&st_status_text='+status_text+'&st_sql_temp=BU', "840,600,yes");
			break;	
		case "podept": // 발주부서
			if(st_buyer == "") {
				alert("고객사를 선택해 주십시요.");
				break;
			}
			var comCodeArr = st_buyer.split("@");
			openSearchPopup('/common/deptCodeAdminPop.do','?open=Y&com_code='+comCodeArr[0], '500,500,no');
			popupSel = "podept";
			break;
		case "buyerMulti": // 고객사 S
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
			popupSel = "buyerMulti";
			break;
		case "buyerMultiPop": // 고객사 M
			openSearchPopup('/common/safetyCompanyCodePop.do','?COM_TYPE=B', '880,450,no');
			popupSel = "buyerMultiPop";
			break;	
		case "seller": // 협력사
			openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=S&MULTI=N', '500,466,no');
			popupSel = "seller";
			break;
		case "setStockReg": // 재고생성
			popupSel = "masterMpSoStockApplyPop";
			var user_id = $("#SessionUserId").val();
			
			if(user_id !="KEP2239014" && user_id !="KEP200012" && user_id !="KEP2119104" && user_id !="KEP200305" && user_id !="KEP2159512") {

				alert("구매대행 재고 생성은 DB Admin의 권한 입니다.\n\n시스템운영팀에 문의 바랍니다.(02-3016-8911)");
				return;
			}
			
			var checkRows = mySheet.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			var checkedCnt = arrRow.length;

			if (checkRows == '' || arrRow.length == 0){
				alert("선택하신 품목이 없습니다.");
				return;
			}
			
			var buyer = "";
			var po_no = "";
			var po_seq = "";
			var buyer_item_no = "";
			var byit_comorg_code = "";
			var status = "";
			for ( var i = 0; i < checkedCnt; i++) {
				buyer            = mySheet.GetCellValue(arrRow[i], "BUYER");
				po_no            = mySheet.GetCellValue(arrRow[i], "PO_NO");
				po_seq           = mySheet.GetCellValue(arrRow[i], "PO_SEQ");
				buyer_item_no    = mySheet.GetCellValue(arrRow[i], "BUYER_ITEM_NO");
				byit_comorg_code = mySheet.GetCellValue(arrRow[i], "BYIT_COMORG_CODE");
				status           = mySheet.GetCellValue(arrRow[i], "STATUS_TEXT");
			}

			if(status != "입고완료" && status != "부분입고") {
				alert("재고 반영건 또는 미입고 건은 재고생성을 하실 수 없습니다.");
				return;
			}
			
			openSearchPopup('/mpso/showMasterMpSoStockApplyPop.do',"?st_buyer="+buyer+"&st_po_no="+po_no+"&st_po_seq="+po_seq+"&st_buyer_item_no="+buyer_item_no+"&st_byit_comorg_code="+byit_comorg_code,'827,412,no');
			break;
		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=0000007zq&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
		}
		
		
		
	}

	function setStockReg() {

		var path = "/kr/sysop/proxbuy/common/popup/sysop_proxybuy_common_gr_stock_pop.jsp?";
			path = path + 

		window.open(path, 'setStockReg', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}
	
	function getBuyerTotalamtOpen() {
		
		var date_type        = $("#st_date_type").val();//f.st_date_type.value;
		var status             = $("#st_status").val();//f.st_status.value;
		var buyer_code      = $("#st_multi_buyer_code").val();
		var buyer_name     = $("#st_multi_buyer_name").val();
		var agent_code      = $("#st_agent_code").val();
		var agent_name     = $("#st_agent_name").val();
		var buyer_item_no  = $("#st_buyer_item_no").val();
		var po_dept_name  = $("#st_po_dept_name").val();
		var po_dept_code   = $("#st_po_dept_code").val();
		var req_dept_name = $("#st_req_dept_name").val();
		var req_dept_code  = $("#st_req_dept_code").val();
		var if_po_no          = $("#st_if_po_no").val();
		var po_no             = $("#st_po_no").val();
		var ref_no             = $("#st_ref_no").val();
		var fromDate        = $("#st_from_date").val();
		var toDate            = $("#st_to_date").val();	
		var status_text       = $("#st_status"+ "_spare").multipleSelect("getSelects", "text");
		 
		openSearchPopup('/mpso/getMasterMpSoOrderTotalBuyerAmtMainPop.do','?st_date_type='+date_type+'&st_status='+status+'&st_buyer_code='+buyer_code+'&st_buyer_name='+buyer_name+'&st_agent_code='+agent_code+'&st_agent_name='+agent_name+'&st_buyer_item_no='+buyer_item_no+'&st_po_dept_name='+po_dept_name+'&st_po_dept_code='+po_dept_code+'&st_req_dept_name='+req_dept_name+'&st_req_dept_code='+req_dept_code+'&st_if_po_no='+if_po_no+'&st_po_no='+po_no+'&st_ref_no='+ref_no+'&st_from_date='+fromDate+'&st_to_date='+toDate+'&st_status_text='+status_text+'&st_sql_temp=BU', "840,600,yes");
	}	
	
	//콜백함수(파일명은 모두 동일)
   function setPopupReturn(code,text){
		if (popupSel == "user") {	
			$("#st_buyer").val(code);
			$("#st_buyer_name").val(text);
		} else if (popupSel == "prdept") {	
			$("#st_req_dept_code").val(code);
			$("#st_req_dept_name").val(text);
		} else if (popupSel == "podept") {	
			$("#st_po_dept_code").val(code);
			$("#st_po_dept_name").val(text);
		} else if (popupSel == "buyerMulti") {	
			$("#st_buyer_code").val(code);
			$("#st_buyer_name").val(kepMultiName(text,"@"));
			$("#st_com_code").val(code);
		} else if (popupSel == "buyerMultiPop") {	
			$("#st_multi_buyer_code").val(code);
			$("#st_multi_buyer_name").val(kepMultiName(text,"@"));
			getBuyerTotalamtOpen() ;
		} else if (popupSel == "seller") {	
			$("#st_agent_code").val(code);
			$("#st_agent_name").val(text);
		} else if (popupSel == "masterMpSoStockApplyPop") {	
			javascript:doAction('search');
		}else if(popupSel == "fileUpload") {	//파일 첨부
			mySheet.SetCellValue(grbRow, "PO_IMAGE_KEY", code);
			doAction("saveFile");

		} 		
   }
	 //그리드 셀클릭 이벤트
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if ( Row  < 1) return;  
		grbRow = Row;		//현재 Row를 전역변수에 셋팅
		var column = mySheet.ColSaveName(Col);
		if (column == "SCM_REMARK") { // 비고
			var BUYER = mySheet.GetCellValue(Row,"BUYER");
			var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
			var PO_SEQ = mySheet.GetCellValue(Row,"PO_SEQ");
			openSearchPopup("/coco/getCommonCoCoScmActionDetailPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO+"&st_po_seq="+PO_SEQ, "520,500,no");
			
		}else if (column == 'BUYER_NAME') { // 고객사
			var BUYER = mySheet.GetCellValue(Row,"BUYER");
			openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+BUYER, '800,550,no');

		} else if (column == 'PR_NO') { // 요청번호
			var BUYER = mySheet.GetCellValue(Row,"BUYER");
			var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
			var PR_NO = mySheet.GetCellValue(Row,"PR_NO");
			openSearchPopup('/mpso/showMasterMpSoDlvyAgrmntHistoryManagePop.do','?st_buyer='+BUYER+'&st_po_no='+PO_NO+'&st_pr_no='+PR_NO, '750,380,no');

		} else if (column == 'PO_NO') { // 발주번호
			var BUYER = mySheet.GetCellValue(Row,"BUYER");
			var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
			openSearchPopup('/common/mpso/poDetailPop.do','?st_buyer='+BUYER+'&st_po_no='+PO_NO,'900,550,no');
			
		} else if (column == 'AGENT_NAME') { // 협력사
			var AGENT = mySheet.GetCellValue(Row,"AGENT_CODE");
			//openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+AGENT,'800,550,no');
			openSearchPopup('/common/agentPoMngPop.do','?st_com_code='+AGENT,'820,550,no');

		} else if (column == 'PO_USER_NAME') { // 발주자
			var ID = mySheet.GetCellValue(Row,"PO_USER_ID");
			openSearchPopup('/common/userDisplayPop.do','?user_id='+ID,'800,500,no');
			
		} else if (column == 'HA_DATE') { // 납품합의일
			var buyer = mySheet.GetCellValue(Row,"BUYER");
			var po_no = mySheet.GetCellValue(Row,"PO_NO");
			var po_seq = mySheet.GetCellValue(Row,"PO_SEQ");
			openSearchPopup('/mppo/showBuyerMpPoDvlyAgrmntHistoryPop.do', "?open=Y&st_buyer="+ buyer + "&st_po_no="+po_no + "&st_po_seq="+po_seq, '800,450,no');

		} else if (column == 'GR_DATE') { // 입고일
			var gr_date = mySheet.GetCellValue(Row,"GR_DATE");
			if(gr_date == "") {
				alert("해당 입고자료가 없습니다.");
				return;
			}
			var buyer = mySheet.GetCellValue(Row,"BUYER");
			var po_no = mySheet.GetCellValue(Row,"PO_NO");
			var po_seq = mySheet.GetCellValue(Row,"PO_SEQ");
			openSearchPopup('/mpiv/getCommonMpIvWarehousingDetailPop.do', "?open=Y&st_buyer="+ buyer + "&st_po_no="+po_no + "&st_po_seq="+po_seq,'840,500,no');

		} else if (column == 'CD_DATE'){ // 납품예정일
			var BUYER = mySheet.GetCellValue(Row,"BUYER");
			var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
			var PO_SEQ = mySheet.GetCellValue(Row,"PO_SEQ");
			
			var RD_DATE = mySheet.GetCellValue(Row,"RD_DATE");
			var ITEM_QTY = mySheet.GetCellValue(Row,"PO_QTY");
			
			var SELLER = mySheet.GetCellValue(Row,"AGENT_CODE");
			var ADD_USER_ID = mySheet.GetCellValue(Row,"PO_USER_ID");
			
			openSearchPopup("/mpiv/getMasterMpIvMultiDeliveryPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO+"&st_po_seq="+PO_SEQ+"&st_rd_date="+RD_DATE+"&st_item_qty="+ITEM_QTY+"&st_seller="+SELLER+"&st_add_user_id="+ADD_USER_ID, "550,600,no");
			
			
		} else if (column == 'INVOICE_DATE') { // 납품일
			var invoice_date = mySheet.GetCellValue(Row,"INVOICE_DATE");
			if(invoice_date == "") {
				alert("해당 거래명세서가 없습니다.");
				return;
			}
			var buyer = mySheet.GetCellValue(Row,"BUYER");
			var po_no = mySheet.GetCellValue(Row,"PO_NO");
			var po_seq = mySheet.GetCellValue(Row,"PO_SEQ");
			openSearchPopup('/wmgr/getMasterWmGrWarehousingNoPop.do', "?open=Y&st_buyer="+ buyer + "&st_po_no="+po_no + "&st_po_seq="+po_seq, '840,500,no');

		} else if (column == 'REQ_USER_NAME') { // 요청자
			var ID = mySheet.GetCellValue(Row,"REQ_USER_ID");
			openSearchPopup('/common/userDisplayPop.do','?user_id='+ID,'800,500,no');
		} else if (column == 'BUYER_ITEM_NO') { // 품목코드
			var buyer = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
			var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
			var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
			var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
			openSearchPopup('/common/catalogDetailPop.do','?BUYER='+buyer+'&BUYER_ITEM_NO='+buyerItemNo+'&CONTRACT_NO='+contractNo+'&CONTRACT_SEQ='+contractSeq,'800,290,no');
		} else if(column == "IMAGE_KEY_YN"){ // 파일첨부
			popupSel = "fileUpload";
			var type="PO";
			var viewType="R"; // 보기전용
			var image_key=mySheet.GetCellValue(Row, "IMAGE_KEY");			
			if (image_key != "") {
				openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
			}
		} else if(column == "PO_IMAGE_KEY_YN"){ // 파일첨부
			popupSel = "fileUpload";
			var type="PO";
			var viewType="VI";
			mySheet.SetCellValue(Row, "SELECTED", '1');			
			var image_key=mySheet.GetCellValue(Row, "PO_IMAGE_KEY");
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		} else if (column == "ISSUE") { // 운영이슈
			var BUYER = mySheet.GetCellValue(Row,"BUYER");
			var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
			var PO_SEQ = mySheet.GetCellValue(Row,"PO_SEQ");
			
        	openSearchPopup("/coco/showCommonCoCoIssueRegPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO+"&st_po_seq="+PO_SEQ, "1000,450,no");
		} else if(column == "LEGACY_PO_NO" && ("<%=st_user_dept%>" == "095" || $("#SessionUserId").val() == "KEP2179027")){ // IF발주번호
			var legacy_po_no = mySheet.GetCellValue(Row, "LEGACY_PO_NO");
			var legacy_po_seq = mySheet.GetCellValue(Row, "LEGACY_PO_SEQ");
			var po_create_date = mySheet.GetCellValue(Row, "PO_DATE");
			openSearchPopup("/common/get_pop_bqms_invoice.do?st_legacy_po_no=" + legacy_po_no + "&st_legacy_po_seq=" + legacy_po_seq + "&st_po_create_date=" + po_create_date, "", "1000,560,no");
		}
	}
	

	
</script>
</head>
<body onload="initPage()">
<object style="display: none;" id="sloagent" classid="CLSID:FFFBA243-D83A-4161-82AD-34FEFE185D04" width="10-%" height="100%" border="1"></object>
<!--내용 시작-->	
		<!--버튼영역-->
       	<div id="searchBtnA"  >
       			<h3>주문진행상세</h3>
				<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
				<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
				<span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
   		</div>             				
		<form name="searchCondition" id="searchCondition">
			<!-- HIDDEN -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" name="SessionUserId" id="SessionUserId"  value="${sessionInfo.userId}">
			<input type="hidden" name="sessionKey" id="sessionKey"  value="${sessionInfo.ikenSessionkey}">
			<input type="hidden" name="st_all_po"  id="st_all_po" value ="N">
			<input type="hidden" name="st_doc_type"  id="st_doc_type" value ="">
			<input type="hidden" name="st_multi_buyer_code" id="st_multi_buyer_code" style="width:100px;" value ="">
			<input type="hidden" name="st_multi_buyer_name" id="st_multi_buyer_name" style="width:100px;" value ="">
			<input type="hidden" name="st_com_code" id="st_com_code" style="width:100px;" value ="">
			<input type="hidden" name="st_non_masking_flag" id="st_non_masking_flag" value ="N">
			
			<div id="cont_searchA">
				<table  class="cont_t_list01"  >
					<caption>진행상태조회</caption>
					<colgroup>
						<col width="10%" />
						<col width="23%" />
						<col width="10%" />
						<col width="23%" />
						<col width="10%" />
                        <col width="23%" />
					</colgroup>
					
					<tbody>
					<tr>
						<th>
							<label for="b_code" class="hidden">기간선택</label>
				  			<select name = "st_date_type" id="st_date_type" style="height:20px" class="TitSelect">
					      		<option value="PO" selected="selected">발주일</option>
								<option value="GR" >입고일</option>
								<option value="RD" >요청일</option>
                           </select>
						</th>
						<td colspan="3">
							<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" > - 
							<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" >
<!-- 							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>  -->
<!-- 							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>  -->
								<span class="btn_month"><a href="javascript:kepFromMonth('st_from_date','st_to_date','1')">-1개월</a></span>
							<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox" >&nbsp;기간무시
							<input type="checkbox"  class="Noborder" name="st_pocheckbox" id="st_pocheckbox" >&nbsp;긴급발주
<!-- 							<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox" style="display:none;"> -->
						</td>
					    <th>진행상태</th>
					    <td>
                            	<label for="b_delivery" class="hidden">진행상태선택</label>
                 				<!-- 다중선택콤보(공통) - input박스의 type은 hidden으로 생성 할것 , style, class는 select 박스에 상속 됨. -->
                 				<input type="hidden" name="st_status" id="st_status" value ="" style="width:200px;">
		             	</td> 
	             	</tr>
					<tr>
						<th><font color="red"><b>*</b></font>고객사</th>
						<td>
	                        <input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:70%;" value = ""  readonly>
	                        <input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:100px;" value ="">
	                        <a href="javascript:doPop('buyerMulti');"><img src="/resources/images/btn_search03.gif"></a>
	                        <a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th><font color="red"><b>*</b></font>협력사</th>
							<td>
		                        <input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:70%;" value ="" READONLY>
		                        <input type="hidden" name="st_agent_code" id="st_agent_code" style="width:100px;" value ="">
		                        <a href="javascript:doPop('seller');"><img src="/resources/images/btn_search03.gif"></a>
		                        <a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
                            </td>
						<th>품목코드</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:80%;ime-mode:disabled; " value =""  maxlength="50"  onblur="kepToUpper('st_buyer_item_no')" onKeyDown="kepEnter()">
						</td>
					</tr>
					<tr>
						<th>발주부서</th>
	                    <td class ="font1_table_font">
	                        <input type="text" class="input_type_text" name="st_po_dept_name" id="st_po_dept_name" style="width:70%;" value ="" READONLY>
	                        <input type="hidden" name="st_po_dept_code" id="st_po_dept_code" style="width:100px;" value ="">
	                        <a href="javascript:doPop('podept');"><img src="/resources/images/btn_search03.gif"></a>
	                        <a href="javascript:kepEraser('st_po_dept_code','st_po_dept_name');"><img src="/resources/images/btn_eraser2.gif"></a>
	                    </td>
	                    <th>요청부서</th>
	                    <td class ="font1_table_font">
	                        <input type="text" class="input_type_text" name="st_req_dept_name" id="st_req_dept_name" style="width:70%;" value="" READONLY>
	                        <input type="hidden" name="st_req_dept_code" id="st_req_dept_code" value="">
	                        <a href="javascript:doPop('prdept');"><img src="/resources/images/btn_search03.gif"></a>
	                        <a href="javascript:kepEraser('st_req_dept_code','st_req_dept_name');"><img src="/resources/images/btn_eraser2.gif"></a>
	                    </td>
	                    <th>I/F 발주번호</th>
	                    <td class ="font1_table_font">
	                    	<input type="text" class="input_type_text" name="st_if_po_no" id="st_if_po_no" size="25" style="width:80%;ime-mode:disabled;" value ="" maxlength="30"  onblur="kepToUpper('st_if_po_no')" onKeyDown="kepEnter()">
	                    </td>
					</tr>
					<tr>
						<th>발주번호</th>
	                    <td class ="font1_table_font">
	                    	<input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:90%;ime-mode:disabled;" value ="" maxlength="20"  onblur="kepToUpper('st_po_no')" onKeyDown="kepEnter()">
	                    </td>
	                    <th>관리번호</th>
	                    <td class ="font1_table_font" >
	                    	<input type="text" class="input_type_text" name="st_ref_no" id="st_ref_no" style="width:90%;" value ="" onKeyDown="kepEnter()">
	                    </td>
						<th>I/F 관리번호</th>
	                    <td class ="font1_table_font" >
	                    	<input type="text" class="input_type_text" name="st_ref_if_no" id="st_ref_if_no" size="25"  style="width:80%;" value ="" onKeyDown="kepEnter()">
	                    </td>
					</tr>
					<tr>
						<th>전략SG담당자</th>
	                    <td class ="font1_table_font" >
	                    	<select id="st_kep_user_id" name="st_kep_user_id" style="width:90%;height:20px"></select>
	                    </td>
	                    <td>PLANT 담당자</td>
	                    <td class ="font1_table_font" >
	                    	<select id="st_plant_user_id" name="st_plant_user_id" style="width:90%;height:20px"></select>
	                    </td>
						<th></th>
	                    <td >
	                    </td>
					</tr>
					</tbody>
				</table>
			</div>
			
			<table style="width:100%;">
				<tr>
					<td align="left">
							&nbsp;&nbsp;<font color="red"><b>* 기간무시</b></font> : 고객사 선택후 품목코드, I/F발주번호, 발주번호, 관리번호 중 한가지 이상을 정확히(전체입력) 기입해야 조회가 됩니다.
					</td>
		   		</tr>
			</table>
			
			<div class="ib_product" style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "350px");
				</script>
			</div>
<!-- 			<div class="paging" id="pageindex"></div> -->
			
			<table style="width:100%;">
				<tr>
					<td colspan="2" height="25" align="left">
			            ■ 발주수량 합계 : <input type="text" class="input_type_text" name="st_po_tot_cnt" id="st_po_tot_cnt" style="border-width:0px;" value="0" size="10" readonly>
			            ■ 입고수량 합계 : <input type="text" class="input_type_text" name="st_gr_tot_cnt" id="st_gr_tot_cnt" style="border-width:0px;" value="0" size="10" readonly>
			            ■ 납품수량 합계 : <input type="text" class="input_type_text" name="st_iv_tot_cnt" id="st_iv_tot_cnt" style="border-width:0px;" value="0" size="10" readonly>
			            ■ 확정수량 합계 : <input type="text" class="input_type_text" name="st_di_tot_cnt" id="st_di_tot_cnt" style="border-width:0px;" value="0" size="10" readonly>
			            ■ 매출금액 합계 : <input type="text" class="input_type_text" name="st_tot_item_amt" id="st_tot_item_amt" style="border-width:0px;" value="0" size="11" readonly>
			            ■ 매입금액 합계 : <input type="text" class="input_type_text" name="st_tot_agent_item_amt" id="st_tot_agent_item_amt" style="border-width:0px;" value="0" size="11" readonly>
			        </td>
				</tr>
			    <tr>
			        <td height="25" align="left">
			            <font color="#666666">&nbsp;&nbsp;* 모든 금액은 VAT 별도입니다.</font>
			        </td>
			        <td height="25" align = "right" valign="middle">
						<span class="btn_06"><a href="javascript:doPop('buyerMultiPop');">고객사거래내역집계</a></span>
						<span class="btn_06"><a href="javascript:doPop('getTotalAmt');">거래내역집계</a></span>
			            <!--  span class="btn_02"><a href="javascript:doAction('IKENGJ');">결재상신</a></span>-->
			            <span class="btn_02"><a href="javascript:doPop('setStockReg');">재고생성</a></span>
 			            <span class="btn_06"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
			        </td>
			    </tr>
			</table>
			
		</form>
	
<!--내용 종료-->	       
	
</body>
</html>			
