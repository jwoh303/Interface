<%--
**********************************************
* 메뉴 : 주문관리>주문 정보수정 (환율)
* 화면 : 주문 정보수정 (환율)
* 기능 : 주문목록을 조회한다.
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 
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
			 { Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"선택",			SaveName:"SELECTED"}
			,{ Align:"Left",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"고객사명",			SaveName:"COM_NAME_LOC"}
			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사코드",		SaveName:"BUYER"}
			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주번호",			SaveName:"PO_NO"}
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주항번",			SaveName:"PO_SEQ"}
			,{ Align:"Left",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품목코드",			SaveName:"BUYER_ITEM_NO"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"신고번호",			SaveName:"EXP_GR_NO"}
			,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"선적일자",			SaveName:"EXP_DATE_OF_SHIPMENT"}
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"입고여부",			SaveName:"GR_YN"}
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"마감여부",			SaveName:"AR_BILL_FLAG"}
			,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"통화단위",			SaveName:"EXP_CUR"}
			,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"환율",			SaveName:"EXP_CUR_PRICE"}
			,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"외화단가",			SaveName:"EXP_FOR_UNIT_PRICE",		Format:"${qtyFormat}"}
			,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"AutoSum",		Header:"외화금액",			SaveName:"EXP_FOR_ITEM_AMT",		Format:"${qtyFormat}"}
			,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"입고수량",			SaveName:"ITEM_QTY",				Format:"${qtyFormat}"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"변경전매출단가",	SaveName:"AS_UNIT_PRICE",			Format:"${qtyFormat}"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"변경전매출금액",	SaveName:"AS_ITEM_AMT",				Format:"${qtyFormat}"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"변경후매출단가",	SaveName:"UNIT_PRICE",				Format:"${qtyFormat}"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"AutoSum",		Header:"변경후매출금액",	SaveName:"ITEM_AMT",				Format:"${qtyFormat}"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float",		Header:"AGENT_PRICE",	SaveName:"AGENT_PRICE",				Format:"${qtyFormat}"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"REASON10",		SaveName:"REASON10"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"REASON6",		SaveName:"REASON6"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"BYIT_COMORG_CODE",	SaveName:"BYIT_COMORG_CODE"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"CONTRACT_NO",	SaveName:"CONTRACT_NO"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"CONTRACT_SEQ",	SaveName:"CONTRACT_SEQ"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"PROCESS_TYPE",	SaveName:"PROCESS_TYPE"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"IMPORT_FLAG",	SaveName:"IMPORT_FLAG"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP_PRICE",		SaveName:"KEP_PRICE"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"DS_FLAG",		SaveName:"DS_FLAG"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"CLSD_FLAG",		SaveName:"CLSD_FLAG"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"WAREHOUSE_CODE",SaveName:"WAREHOUSE_CODE"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"CMS_CATLG_ID",	SaveName:"CMS_CATLG_ID"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"PR_NO",			SaveName:"PR_NO"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"PR_SEQ",		SaveName:"PR_SEQ"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"AGENT",			SaveName:"AGENT"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"DOC_TYPE",		SaveName:"DOC_TYPE"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"RS_FLAG",		SaveName:"RS_FLAG"}
			,{ Align:"Center",	Width:10,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"CA_EXCEPT_REASON",	SaveName:"CA_EXCEPT_REASON"}
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:5};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

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
		kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoOrderExchangeRateList.do" , pagingMode );
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
		location.href = "/resources/excel/work/ORDER/masterMpSoOrderExchangeRateAlterList.xlsx";
		break;		
 
		
	case "del":	// 삭제 
	    if (confirm("선택된 내역을 정말로 삭제하시겠습니까?")==false) return;
		kepSave(document.searchCondition ,  mySheet , "/mpso/delMasterMpSoOrderExchangeRateList.do" , "SELECTED" );
		break;
		
	case "orderCreate":	//  orderCreate 	
	 
		var title = "";
	    var cnt = 0;
		for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
			if (mySheet.GetCellValue(i, "SELECTED") == "1"){
				var st_com_name_loc = mySheet.GetCellValue(i, "COM_NAME_LOC");
				var st_po_no = mySheet.GetCellValue(i, "PO_NO");
				var st_po_seq = mySheet.GetCellValue(i, "PO_SEQ");
				var st_gr_yn = mySheet.GetCellValue(i, "GR_YN"); 
				var st_ar_bill_flag = mySheet.GetCellValue(i, "AR_BILL_FLAG");
				var st_agent_price = mySheet.GetCellValue(i, "AGENT_PRICE");
				var st_exp_price = mySheet.GetCellValue(i, "EXP_FOR_UNIT_PRICE"); 
				var st_exp_amt = mySheet.GetCellValue(i, "EXP_FOR_ITEM_AMT"); 

				if(st_ar_bill_flag == "Y"){
					alert(st_com_name_loc+"["+st_po_no+"/"+st_po_seq+"]"+ " 매출 세금계산서가 발행되어 변경 불가능 합니다.");
					return;
				}
				if(st_agent_price ==""|| st_agent_price == null){
					alert(st_com_name_loc+"["+st_po_no+"/"+st_po_seq+"]"+ " 매출 세금계산서가 발행되어 변경 불가능 합니다.");
					return;					
				}
				if(st_exp_price ==""|| st_exp_price == null){
					alert(st_com_name_loc+"["+st_po_no+"/"+st_po_seq+"]"+ " 외화단가 정보가 없어 변경 불가능 합니다.");
					return;					
				}
				if(st_exp_amt ==""|| st_exp_amt == null){
					alert(st_com_name_loc+"["+st_po_no+"/"+st_po_seq+"]"+ " 외화금액 정보가 없어 변경 불가능 합니다.");
					return;					
				}
				//CA_EXCEPT_REASON 카탈로그 미반영 문구입력
				mySheet.SetCellValue(i, "CA_EXCEPT_REASON","주문정보수정(환율)_카탈로그미반영");
			}
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
   	var C007 = "N"; // 발주초기화
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
	 
	if (2000 < mySheet.RowCount() + 1) {
		alert("2000건이하의 파일만 업로드하여 주세요.");
		mySheet.RemoveAll();
		return;
	} 
	setSaveGridtoDB();
}


function setSaveGridtoDB(){	  
	var maxRow = mySheet.RowCount() + 1;     
	 
    for(var i =1; i<=maxRow; i++){
    	mySheet.SetCellValue(i,"SELECTED","1");
    }   
	kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoOrderExchangeRateList.do" , "SELECTED" );
}

	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N"); 
   	 
	if (msg != "") {
		alert(msg);
	}
	
	// 합계 행 다듬기
	mySheet.SetSumValue(0,"- 합 계 -");
	mySheet.SetCellAlign(mySheet.LastRow(),1,"Center");
	mySheet.SetMergeCell (mySheet.LastRow(), 0, 1, 4);
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

	return;
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>주문 정보수정 (환율)</h3>
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
			        <td height="25" align="left">
	  					<span class="btn_05 mr04"><a href="javascript:doAction('excelUpload');">엑셀업로드</a></span>
	  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">양식다운로드</a></span> 
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
