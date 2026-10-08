<%--
**********************************************
* 메뉴 : 주문관리>주문 정보수정 (일괄)
* 화면 : 주문 정보수정
* 기능 : 주문목록을 조회한다.
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-09-16
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %> 
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
					 { Align:"Center",	Width:50,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:50,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"} 
					
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"업로드_상태",	SaveName:"STATUS"}    
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"마감상태",	SaveName:"STATUS_TEXT2"}     
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태",	SaveName:"STATUS_TEXT"}     					
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"수주접수",	SaveName:"RS_FLAG"}     
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객회사명",	SaveName:"COM_NAME_LOC"}     
					,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객회사코드",	SaveName:"BUYER"}     
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주번호",	SaveName:"PO_NO"}     
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주항번",	SaveName:"PO_SEQ"}     
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}     
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"변경후_매출단가",	SaveName:"UNIT_PRICE"}     
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"변경후_매입단가",	SaveName:"AGENT_PRICE"}    	
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"변경전_매출단가",	SaveName:"BEFR_UNIT_PRICE"}     
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"변경전_매입단가",	SaveName:"BEFR_AGENT_PRICE"}     
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${rateFormat}",	Header:"변경전_매익률",	SaveName:"BEFR_RATE"}     
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${rateFormat}",	Header:"변경후_매익률",	SaveName:"AFTR_RATE"}     	
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}     
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}     
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"발주수량",	SaveName:"ITEM_QTY"}       
					
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BYIT_COMORG_CODE",	SaveName:"BYIT_COMORG_CODE"}    
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CONTRACT_NO",	SaveName:"CONTRACT_NO"}   
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CONTRACT_SEQ",	SaveName:"CONTRACT_SEQ"}     
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PR_NO",	SaveName:"PR_NO"}   
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PR_SEQ",	SaveName:"PR_SEQ"}    
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"IMPORT_FLAG",	SaveName:"IMPORT_FLAG"}    
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"KEP_PRICE",	SaveName:"KEP_PRICE"}    
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"DS_FLAG",	SaveName:"DS_FLAG"}    
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CLSD_FLAG",	SaveName:"CLSD_FLAG"}    
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"WAREHOUSE_CODE",	SaveName:"WAREHOUSE_CODE"}    
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CMS_CATLG_ID",	SaveName:"CMS_CATLG_ID"}    
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AGENT",	SaveName:"AGENT"}    
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"DOC_TYPE",	SaveName:"DOC_TYPE"}    
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"USER_ID",	SaveName:"USER_ID"}     
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PROCESS_TYPE",	SaveName:"PROCESS_TYPE"}     
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"REASON6",	SaveName:"REASON6"}     
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"REASON10",	SaveName:"REASON10"}     
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AP_BILL_FLAG_STATUS",	SaveName:"AP_BILL_FLAG_STATUS"}    // 매입마감|매입단가변경불가
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AR_BILL_FLAG_STATUS",	SaveName:"AR_BILL_FLAG_STATUS"}   // 매출마감|매출단가변경불가
					,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CA_EXCEPT_REASON",	SaveName:"CA_EXCEPT_REASON"}
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:9};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
 
	//하이퍼링크 설정
	setLinkCol(mySheet, "PO_NO");	 
	setLinkCol(mySheet, "BUYER_ITEM_NO");	 
	
	// 조회조건 초기화
	kepSetCalender("START_ADD_DATE");
	kepSetCalender("END_ADD_DATE");
	
	$("#START_ADD_DATE").val( kepToMonthAdd("1","M"));
	$("#END_ADD_DATE").val( kepGetNowTimeStr('YYYYMMDD','/'));
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	  
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|"); 
	 if (str == "search1"){
		 str = "search";
	 }

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && str !="excelUpload"  && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		 
		pagingMode = "N";
		kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoOrderInfoAlterMultiList_v2.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		searchCondition.reset();		
		$("#START_ADD_DATE").val( kepToMonthAdd("1","M"));
		$("#END_ADD_DATE").val( kepGetNowTimeStr('YYYYMMDD','/'));
		mySheet.RemoveAll();
		break;
		
	case "excelUpload":	// 엑셀업로드
		mySheet.RemoveAll();
		var params = {
			Mode : "HeaderMatch"
		};
		mySheet.LoadExcel(params); 
		break;

	case "excelDown":	// 양식다운로드 
		location.href = "/resources/excel/work/ORDER/buyerMultiExcel.xlsx";
		break;		
 
		
	case "del":	// 삭제 
	    if (confirm("선택된 내역을 정말로 삭제하시겠습니까?")==false) return;
		kepSave(document.searchCondition ,  mySheet , "/mpso/delMasterMpSoOrderInfoAlterMultList.do" , "SELECTED" );
		break;
		
	case "orderCreate":	//  orderCreate 	
	 
		var title = "";
	    var cnt = 0;
		for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
			if (mySheet.GetCellValue(i, "SELECTED") == "1"){
				var STATUS = mySheet.GetCellValue(i, "STATUS");
				var STATUS_TEXT2 = mySheet.GetCellValue(i, "STATUS_TEXT2");
				var AP_BILL_FLAG_STATUS = mySheet.GetCellValue(i, "AP_BILL_FLAG_STATUS"); // 매입
				var AR_BILL_FLAG_STATUS = mySheet.GetCellValue(i, "AR_BILL_FLAG_STATUS"); // 매출
				var BEFR_UNIT_PRICE = mySheet.GetCellValue(i, "BEFR_UNIT_PRICE"); // 매출전
				var UNIT_PRICE = mySheet.GetCellValue(i, "UNIT_PRICE"); // 매출후
				var BEFR_AGENT_PRICE = mySheet.GetCellValue(i, "BEFR_AGENT_PRICE"); // 매입전
				var AGENT_PRICE = mySheet.GetCellValue(i, "AGENT_PRICE"); // 매입후			
				 
/*				
----------------------------------------------------------------------------------------
마감상태       |     마감  전    |     매입마감    |     매출마감     |  매입&매출마감
변경가능항목                     
----------------------------------------------------------------------------------------
매입단가       |        O        |        X        |        O         |       X
----------------------------------------------------------------------------------------
매출단가       |        O        |        O        |        X         |       X
----------------------------------------------------------------------------------------


매입마감 : AP_BILL_FLAG = 'Y'
매출마감 : AR_BILL_FLAG = 'Y'


*/				
				// 매출변경있음
				if (BEFR_UNIT_PRICE != UNIT_PRICE){
					if (AR_BILL_FLAG_STATUS != ""){
						title = title + i + "행  ["+AR_BILL_FLAG_STATUS + "마감|매출단가변경불가] \n";
						cnt = 1;
					}
				}
				// 매입변경있음
				if (BEFR_AGENT_PRICE != AGENT_PRICE){
					if (AP_BILL_FLAG_STATUS != ""){
						title = title + i + "행  ["+AP_BILL_FLAG_STATUS + "마감|매입단가변경불가] \n";
						cnt = 2;
					}
				}
				
				if (cnt ==0 || cnt ==3) {
					if (STATUS.indexOf("매익율") > -1 
							|| STATUS == "정상" 
					){			
					} else { 				 
							title = title + i + "행  ["+STATUS + "] \n";
							cnt = 3; 
					}
				}
				// 매출단가 0원 변경 불가능.
				if(!chkDecimal(UNIT_PRICE,3) || (UNIT_PRICE < 1) ){
					title = title + i + "행  [매출단가 0원 및 공백으로 변경 불가] \n";
					cnt = 4;
				}
				// 매입단가 0원 변경 불가능.
				if( !chkDecimal(AGENT_PRICE,3) || (AGENT_PRICE < 1) ){
					title = title + i + "행  [매입단가 0원 및 공백으로 변경 불가] \n";
					cnt = 4;
				}
				//CA_EXCEPT_REASON 카탈로그 미반영 문구입력
				mySheet.SetCellValue(i, "CA_EXCEPT_REASON","주문정보수정(일괄)_카탈로그미반영");
			}
		}  
		
		if (cnt != 0){ 
			title = title + "수정 대상이 아닙니다.";
			alert(title);
			return;
		}
		
	    if (confirm("선택된 내역을 저장하시겠습니까?")==false) return;  
        openSearchPopup('/mppo/showBuyerMpPoRejectReasonPop.do','?openYn=O',"500,280,no");		 		 
		break;
		
	case "realSave":	//  realSave 
		 
		kepSave(document.searchCondition ,  mySheet , "/mpso/saveOrderChangeCombineLogic.do" , "SELECTED" );		 
		break;
		
	}
}


function setReason(value){ 
	
	/*
	일괄변경은 단가변경만 가능하다
	*/
	
   	var C001 = "N"; // 단순항목변경
    var C002 = "N"; // 거래유형변경
   	var C003 = "N"; // 협력사변경
   	var C004 = "Y"; // 단가변경
   	var C005 = "N"; // 수량변경		            	
   	var C006 = "N"; // 발주삭제
   	var C007 = "N";  // 발주초기화
   	var C008 = "N"; // 발주종결
   	var C009 = "N"; // 종결복원
   	var C010 = "N"; // 수량분할 
	
	for ( var i = 1; i <= mySheet.RowCount() ; i++ ) { 
			 
			if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
				mySheet.SetCellValue(i , 'REASON10', C001+"/"+C002+"/"+C003+"/"+C004+"/"+C005+"/"+C006+"/"+C007+"/"+C008+"/"+C009+"/"+C010);
			}
		}
	

    $("#st_reason").val(value); //  사유
	$("#st_saveFlag").val(C001+"/"+C002+"/"+C003+"/"+C004+"/"+C005+"/"+C006+"/"+C007+"/"+C008+"/"+C009+"/"+C010);
	$("#st_saveFlag_code").val("C004^");
	
	doAction('realSave');
} 
	  
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}


function mySheet_OnLoadExcel() {
	const rowCount = mySheet.RowCount();
	const headerRows = mySheet.HeaderRows();
	 
	if (500 < rowCount + 1) {
		alert("500건이하의 파일만 업로드하여 주세요.");
		mySheet.RemoveAll();
		return;
	} 
	
	for(var i = headerRows; i < headerRows + rowCount; i++) {
		const unitPrice = mySheet.GetCellValue(i, "UNIT_PRICE");
		const agentPrice = mySheet.GetCellValue(i, "AGENT_PRICE");
		
		if(unitPrice <= 0 && unitPrice != "") {
			alert("매출단가는 0원 이하일 수 없습니다.\n[" + i + "번째 항목의 매출단가 : " + unitPrice + "원]");
			mySheet.RemoveAll();
			return;
		}
		
		if(agentPrice <= 0 && agentPrice != "") {
			alert("매입단가는 0원 이하일 수 없습니다.\n[" + i + "번째 항목의 매입단가 : " + agentPrice + "원]");
			mySheet.RemoveAll();
			return;
		}
	}
	
	setSaveGridtoDB();
}


function setSaveGridtoDB(){	  
	var maxRow = mySheet.RowCount() + 1;     
	 
    for(var i =1; i<=maxRow; i++){
    	mySheet.SetCellValue(i,"SELECTED","1");
    }   
	kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoOrderInfoAlterMultiList.do" , "SELECTED" );
}

	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N"); 
   	 
	if (msg != "") {
		alert(msg);
	}    
}


//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	 
	if(code == 0){
		alert(msg);
		mySheet.RemoveAll();
		return;
	} 
	 
	if(code>0){
		if (msg != "") {
			var msgType = msg.substring(0,2);
			if (msgType == "TM"){
				openSearchPopup('/common/approval/buyerCommonApprovalPop.do','?DOC_TYPE=OEM&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg , "1000,500,no");
			}else{
				//저장 성공시 재조회
				doAction('search');
			}
		}
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

function kepApprovalReturn(ERR,GW_NO){ 
	//저장 성공시 재조회
	doAction('search');
}



//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
  
	var ORDERFLAG = "after";
	var STATUS_TEXT = mySheet.GetCellValue(Row, 'STATUS_TEXT'); 	
	if(STATUS_TEXT == "발주") { 
		ORDERFLAG = "before";		
	}
	
	if (column == 'PO_NO') { // 발주번호
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		openSearchPopup('/mpso/getMasterMpSoOrderInfoAlterBeforeMainPop.do','?st_buyer='+BUYER+'&st_po_no='+PO_NO+'&st_orderFlag='+ORDERFLAG , "1300,625,no");

	}  else if (column == 'BUYER_ITEM_NO') { // 품목코드
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
		var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		getBuyerCatalogDisplayPop(buyer,buyerItemNo,contractNo,contractSeq);

	}else if (column == 'SELECTED') {  

	}
	return;
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=0000007zs&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
	}
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>주문 정보수정 (일괄)</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
		    <span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 --> 
			<input type="hidden" id="st_reason" name="st_reason"  value="">
			<input type="hidden" id="st_saveFlag" name="st_saveFlag"  value="">
			<input type="hidden" id="st_saveFlag_code" name="st_saveFlag_code"  value="">
			<input type="hidden" id="onepagerow" name="onepagerow"  value="100"> 
			<input type="hidden" id="st_save_multi"  name="st_save_multi" value="Y"> <!-- 일괄임 -->
			<input type="hidden" id="st_po_change_user_id" name="st_po_change_user_id"  value="${sessionInfo.userId}"> 
				
		  <table  class="cont_t_list01">
		    <caption></caption>
		    <colgroup>
		    <col width="120px" />
		    <col width="25%" />
		    <col width="90px" />
		    <col width="25%" /> 
		    </colgroup>
		    <tbody>
		      <tr>
					<th>일괄 수정 생성일</th>
					<td colspan="3">
						<input type="text" class="input_type_text" name="START_ADD_DATE" id="START_ADD_DATE" readOnly style="width:10%; text-align:center;" value=""> - 
						<input type="text" class="input_type_text" name="END_ADD_DATE" id="END_ADD_DATE" readOnly style="width:10%; text-align:center;" value="">
						<span class="btn_month"><a href="javascript:kepMonth('START_ADD_DATE','END_ADD_DATE','3')">3개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('START_ADD_DATE','END_ADD_DATE','6')">6개월</a></span>							
					</td>
					<th></th>
					<td></td>
		      </tr>
		    </tbody>
		  </table>
            </div> 
 
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div> 
  			<br>
  			<!--버튼영역-->
			<table style="width:100%;">
				<tr>
					<td colspan="2" height="25" align="left">
			            &nbsp;&nbsp;* 엑셀파일 작성시 매출단가와 매입단가 중 변경되지 않는 항목이 존재하는 경우에도 <font color="red"><b>기존금액과 동일한 금액을 기입</b></font>하여 주시기 바랍니다.
			        </td>
				</tr>
			    <tr>
			        <td height="25" align="left">
	  					<span class="btn_05 mr04"><a href="javascript:doAction('excelUpload');">엑셀업로드</a></span>
	  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">양식다운로드</a></span> 
  					<!-- <span class="btn_07 mr04"><a href="javascript:doAction('save');">업로드검증결과저장</a></span> -->
			        </td>
			        <td height="25" align = "right" valign="middle">
	  					<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span> 
	  					<span class="btn_02"><a href="javascript:doAction('orderCreate');">정보수정</a></span>
			        </td>
			    </tr>
			</table>
			

<!--내용 종료-->	                 

</body>
</html>
