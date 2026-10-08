<%--
**********************************************
* 메뉴 : 주문관리>미마감내역
* 화면 : 미마감내역
* 기능 : 
* 프로그램 ID : PG_06_M_004_00
* 담당자 : CEJ( 설계 : 김지현 )
* 착수일 : 2014-08-25
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<!-- 다중선택콤보(공통) - 사용시 필수 선언 start -->
<script src="/resources/js/jquery.multiple.select.js"></script>
<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<!-- 다중선택콤보(공통) - 사용시 필수 선언 end -->
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"진행상태",	SaveName:"STATUS_TEXT"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주번호",	SaveName:"PO_NO"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"IF발주번호",	SaveName:"LEGACY_PO_NO"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"관리번호",	SaveName:"REF_PR_NO"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"발주일",	SaveName:"PO_DATE"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납기요청일",	SaveName:"RD_DATE"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"입고일",	SaveName:"GR_DATE"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납품예정일",	SaveName:"DS_DATE"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납품일",	SaveName:"INVOICE_DATE"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"확정일",	SaveName:"DELIVERY_DATE"} 
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품명",	SaveName:"DESCRIPTION"} 
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"} 
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"AutoSum",	Header:"발주수량",	SaveName:"PO_QTY"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"AutoSum",	Header:"입고수량",	SaveName:"GR_QTY1"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"AutoSum",	Header:"납품수량",	SaveName:"INV_QTY"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"AutoSum",	Header:"확정수량",	SaveName:"DELIVERY_QTY"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"AutoSum",	Header:"매출단가",	SaveName:"UNIT_PRICE"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"AutoSum",	Header:"매출금액",	SaveName:"UNIT_SUM"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"AutoSum",	Header:"매입단가",	SaveName:"AGENT_PRICE"}  
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"AutoSum",	Header:"매입금액",	SaveName:"AGENT_SUM"}  
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주부서",	SaveName:"CHANGE_USER_DEPT"}  
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주자",	SaveName:"CHANGE_USER_NAME"}  
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청부서",	SaveName:"REQ_DEPT_NAME"}  
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",	SaveName:"REQ_USER_NAME"}  
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주항번",	SaveName:"PO_SEQ"}  
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"주문항번",	SaveName:"LEGACY_PO_SEQ"}  
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AGENT_CODE",	SaveName:"AGENT_CODE"}   
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CONTRACT_NO",	SaveName:"CONTRACT_NO"}   
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CONTRACT_SEQ",	SaveName:"CONTRACT_SEQ"}   
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BUYER",	SaveName:"BUYER"}   
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BYIT_COMORG_CODE",	SaveName:"BYIT_COMORG_CODE"}   
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PO_USER_ID",	SaveName:"PO_USER_ID"}   
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"REQ_USER_ID",	SaveName:"REQ_USER_ID"}   
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"GR_NO",	SaveName:"GR_NO"}   
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"GR_SEQ",	SaveName:"GR_SEQ"}   
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"REG_NO",	SaveName:"REG_NO"}   
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PR_NO",	SaveName:"PR_NO"}   
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PR_SEQ",	SaveName:"PR_SEQ"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"GR_CNT",	SaveName:"GR_CNT"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CLOSE_DATE",	SaveName:"CLOSE_DATE"}    
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AR_BILL_FLAG",	SaveName:"AR_BILL_FLAG"}   
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AP_BILL_FLAG",	SaveName:"AP_BILL_FLAG"}    
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"H_GR_DATE",	SaveName:"H_GR_DATE"}    
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"H_CLOSE_DATE",	SaveName:"H_CLOSE_DATE"}    
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:5};
	IBS_InitSheet(mySheet, initsheet,pagingMode); 
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "PO_NO");	//발주번호
	setLinkCol(mySheet, "AGENT_NAME");	//협력사
	setLinkCol(mySheet, "BUYER_ITEM_NO");	//품목코드
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	// 다중선택콤보(공통) - 생성
	//var test = "PO10,PO30,PO50";		// 초기화 시 아이템 선택 값
	kepAjaxCommonTotalMultiCombo('st_status', 'C018', 'ALL', "");
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		var com_buyer =	$("#st_buyer_code").val();
		if (com_buyer == "") {
			alert("고객사를 선택하세요.");
			return;
		}
	 
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoClosingDetailList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화

		$( '#searchCondition' )[0].reset();
	
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));

		// 다중선택콤보(공통) - 초기화
		init_multiCombo("st_status");
		mySheet.RemoveAll();
		
		$("#st_buyer_code").val("");
		$("#st_agent_code").val(""); 

		break;

	case "cancel": // 입고취소
	
		var validCnt = 0;	
		var gridHeaderCount = mySheet.RowCount();
		for ( var i = 0; i <= gridHeaderCount; i++ ) {				 
				if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
					var ar_bill_flag  = mySheet.GetCellValue( i  , "AR_BILL_FLAG"); 				
					var ap_bill_flag  = mySheet.GetCellValue( i  , "AP_BILL_FLAG"); 				
					var buyer  = mySheet.GetCellValue( i  , "BUYER"); 				
					var gr_date  = mySheet.GetCellValue( i  , "H_GR_DATE"); 				
					var close_date  = mySheet.GetCellValue( i  , "H_CLOSE_DATE"); 				
					var status  = mySheet.GetCellValue( i  , "STATUS_TEXT"); 				
					var PO_NO  = mySheet.GetCellValue( i  , "PO_NO");
					var grCnt  = mySheet.GetCellValue( i  , "GR_CNT");
					
					if(grCnt > 1){
						 alert(PO_NO+ " 입고 분할건 입니다.\n\n입고취소 할 수 없습니다.");
						 validCnt = 1;
						 return ;
					}
					 if(ar_bill_flag=="Y"){
					        alert(PO_NO+ " 매출 세금계산서가 발행되었습니다.\n\n입고취소 할 수 없습니다.");
					        validCnt = 1;
					        return ;
				      }
					if(ap_bill_flag=="Y") {
					    alert(PO_NO+ " 매입 세금계산서가 발행되었습니다.\n\n입고취소 할 수 없습니다.");
					    validCnt = 1;
						 return ;
					} 
					if(buyer == "KRKORE0068"||buyer == "KRKORE0126"||buyer == "KRKORE0160"||buyer == "KRKORE0192"
						||buyer == "RKORE0234"||buyer == "KRKORE0236"||buyer == "KRKORE0246"||buyer == "KRKORE0266"){
						  alert(PO_NO+ " 물류센터는 입고 취소가 불가능 합니다.");
						  validCnt = 1;
						  return ;				
					}
					
					if(gr_date !=""){									 
						if (close_date!= ""){
							  if(eval(gr_date) > eval(close_date)){ 
										if(!(status == "입고완료" || status == "부분입고")){
												alert(PO_NO+ " 미입고 건은 입고취소 대상이 아닙니다.  ");
												validCnt = 1;
									      		return;
								    }
								}else{
										alert(PO_NO+ " 마감이 완료 되어 입고취소 할수 없습니다.");
										 validCnt = 1;
										return;
							  }
						}
				 	 }else{
							alert(PO_NO+ " 입고가 되지 않아 입고취소 할수 없습니다.");
							validCnt = 1;
							return;
					} 
					
					if ( status == "발주삭제") {
						alert(PO_NO+ " 이미 발주삭제 되었습니다.");
						 validCnt = 1;
						return;
						}			
					
				}		
		} 
		
		if ( validCnt == 1) return;
		
		if (!confirm('선택한 항목을 입고취소하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mpso/saveNewGrDelChange_Item.do" , "SELECTED" );
		break;
		
	case "del": // 발주삭제
	 
		var validCnt = 0;
		var gridHeaderCount = mySheet.RowCount();
		for ( var i = 0; i <= gridHeaderCount; i++ ) {				 
				if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) { 			
					var status  = mySheet.GetCellValue( i  , "STATUS_TEXT"); 				
					var PO_NO  = mySheet.GetCellValue( i  , "PO_NO"); 	
				    var gr_date    =  mySheet.GetCellValue( i  , "H_GR_DATE"); 	 
				    var close_date = mySheet.GetCellValue( i  , "H_CLOSE_DATE"); 		 
				    var buyer_name = mySheet.GetCellValue( i  , "BUYER_NAME"); 		 
				  
				    if(gr_date != ""){
					    	if (close_date!= ""){
							      if(eval(close_date) > eval(gr_date)){
								        alert(i +" 번째 목록은 "+buyer_name+" 의 입고 및 마감정산이 완료된 항목입니다.  \n\n  발주삭제는 관리자에게 문의하시기 바랍니다.   ");
								        validCnt = 1;
								        return;
							      } 
					    	}
					      alert(i +"번째 목록은 입고처리된 항목입니다.\n\n입고내역을 삭제하신 후 발주정보 수정이 가능합니다.");
					      validCnt = 1;
					      return;
				    }	
				    
					if ( status == "발주삭제") {
					alert(PO_NO+ " 이미 발주삭제 되었습니다.");
					validCnt = 1;
					return;
					}						 
				}
		}
		
		if ( validCnt == 1) return;
		
		if (!confirm('선택한 항목을 발주삭제 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mpso/delNewPODelete_Item.do" , "SELECTED" );
		break;

	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
		var param = {FileName:"미마감내역.xlsx",DownCols:"BUYER_NAME|STATUS_TEXT|PO_NO|LEGACY_PO_NO|AGENT_NAME|BUYER_ITEM_NO|REF_PR_NO|PO_DATE|RD_DATE|GR_DATE|DS_DATE|INVOICE_DATE|DELIVERY_DATE|DESCRIPTION|SPECIFICATION|MAKER_NAME|UNIT_MEASURE|PO_QTY|GR_QTY1|INV_QTY|DELIVERY_QTY|UNIT_PRICE|UNIT_SUM|AGENT_PRICE|AGENT_SUM|CHANGE_USER_DEPT|CHANGE_USER_NAME|REQ_DEPT_NAME|REQ_USER_NAME|PO_SEQ|LEGACY_PO_SEQ|"};
		kepDownExcel(document.searchCondition ,mySheet , "/mpso/excelMasterMpSoClosingDetailList.do", param);
		$("#pageflag").val('1');
		break;
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

   	
   	
	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}  
	
	
	// 합계 행 다듬기
	mySheet.SetSumValue(1,"- 합 계 -");
	mySheet.SetCellAlign(mySheet.LastRow(),1,"Center");
	mySheet.SetMergeCell (mySheet.LastRow(), 1, 1, 4);

	
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

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
// 	alert(downloadType + ' 다운이 완료되었습니다. \n 다운로드 결과 : ' + ((result==true)?'성공':'실패'));
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoClosingDetailList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	var com_buyer =	$("#st_buyer_code").val();
	switch (str) {
	case "buyer_single": // 고객사 M
		openSearchPopup("/common/safetyCompanyCodePop.do", "?COM_TYPE=B&MULTI=Y", "880,450,no"); 
		break;
		
	case "req_user_name": // 협력사
		if (com_buyer == "") {
			alert("고객사를 선택하세요.");
			return;
		}
		openSearchPopup('/common/icomcmpyPop.do', "?open=Y&BUSINESS_COND=S" ,"500,466,no");
		break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	if (Value == "") return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	var BUYER = mySheet.GetCellValue(Row,"BUYER");
	var STATUS_TEXT = mySheet.GetCellValue(Row,"STATUS_TEXT"); 
	
	if (BUYER == "") return;
	if (column == 'PO_NO') { // 발주번호
		
		if (STATUS_TEXT.indexOf("삭제")>-1){
			alert("발주삭제한 정보는 주문진행상세에서 확인부탁드립니다.");
			return;
		}
		
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		openSearchPopup('/mpiv/getCommonMpIvOrderDetailPop.do','?buyer='+BUYER+'&po_no='+PO_NO , "820,550,no");

	} else if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet.GetCellValue(Row,"AGENT_CODE");
		getAgentDisplayPop(agent); 

	} else if (column == 'BUYER_ITEM_NO') { // 품목코드
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
		var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		getBuyerCatalogDisplayPop(buyer,buyerItemNo,contractNo,contractSeq); 

	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 고객사 
		
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@")); 
		
	}else 	if (popupSel == "req_user_name") {	// 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2); 
	}
	grbRow="";	//초기화
}


function setCheckBox(){
    if(document.forms.searchCondition.st_gr_flag_check.checked == true){
        document.forms.searchCondition.st_gr_flag.value = "GR";
    }else{
        document.forms.searchCondition.st_gr_flag.value = "ALL";
    }
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>미마감내역(PO기준)</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" id="searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_buyer" name="st_buyer"  value="${sessionInfo.comCode}">
			
            	<table  class="cont_t_list01" >
					<caption>미마감내역</caption>
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
							<th>조회일</th>
							<td colspan="3">
							 <select name="st_date_type" style="width:10%" class="TitSelect">
	                            <option value = "PO">발주일</option>
	                            <option value = "GR">입고일</option>
                       	 	</select>
                        
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:80px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:80px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
							</td>
							<th>구분</th>
							<td>
		                        <select name = "st_off_status" style="width:50%">
		                            <option value = "ALL" selected>전체</option>
		                            <option value = "MR">MR자재</option>
		                            <option value = "OFFICE">사무용품</option>
		                        </select>
							</td>
						</tr>
						<tr> 
							<th><font color="red"><b>*</b></font>고객사</th>
							<td>
						 			<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:67%;" value = "" READONLY>
			                       <input type="hidden" name="st_buyer_code" id="st_buyer_code" value ="">
			                       <a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
			                       <a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>협력사</th>
							<td>
							    <input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:60%;" value ="" READONLY>
					        	<input type="hidden" name="st_agent_code" id="st_agent_code" value=""> 
		                        <a href="javascript:doPop('req_user_name');"><img src="/resources/images/btn_search03.gif"></a>
		                        <a href="javascript:kepEraser('st_req_user_id','st_req_user_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>진행상태</th>
							<td>
			                       <input type="hidden" name="st_status" id="st_status" value ="" style="width:200px;" class="TitSelect">
							</td>
						</tr>
				      <tr>	       
				       		<th>발주번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_search_po_no" name="st_search_po_no" style="width:80%;" value=""   onkeydown="kepEnter()">
							</td>
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_search_buyer_item_no" name="st_search_buyer_item_no" style="width:80%;" value=""  onkeydown="kepEnter()">
							</td>
							<th>품명규격</th>
							<td>
								<input type="text" class="input_type_text" id="st_search_desc_spec" name="st_search_desc_spec" style="width:80%;" value=""  onkeydown="kepEnter()">
							</td>							
						</tr>						
					</tbody>
				</table>
            </div>
            <!-- 
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
			 -->
			 <input type="hidden"' name="onepagerow" id="onepagerow" value="1000">
			<span class="fr">
			             <b><font color="#333333">입고완료제외</font></b>&nbsp;&nbsp;<input type="checkbox" name="st_gr_flag_check"  value="" checked onChange="setCheckBox();" >
            			<input type="hidden"   name="st_gr_flag" value="GR">
            </span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
  					<span class="btn_05 mr04" ><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  				
  				<span class="fr">
  				<!-- <span class="btn_02 mr04"><a href="javascript:doAction('del');">발주삭제</a></span> 주석처리 2014.09.19  -->	
  				<!-- <span class="btn_02"><a href="javascript:doAction('cancel');">입고취소</a></span> 주석처리 2018.01.23 입고관리 화면개발에 의한 기능 축소 -->
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
