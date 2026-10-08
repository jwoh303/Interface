<%--
**********************************************
* 메뉴 : 상품관리>고객사 카탈로그 관리>카탈로그 품목정비 일괄수정
* 화면 : 카탈로그 품목정비 일괄수정
* 기능 : 고객사 카탈로그 수정
* 프로그램 ID :  
* 담당자 : 
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var grbRow = "";
var popupSel = "";
var buttonChk = "N";	// Y: 반영대상 확인, N: 반영대상 미확인(품의 불가)

var areaOn = "/resources/images/icon.gif";
var areaOff = "/resources/images/icon2.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var productGbn = KepSheetComboData("M132","SEL");
    var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};
	var initsheet = {};
	initsheet.Cols = [ 
				 
	     { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus" ,ColMerge:0}
	    ,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED" ,ColMerge:0}
	    ,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"* 카탈로그 관리코드",	SaveName:"BUYER" ,ColMerge:1}
	    ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"* 상품코드",	SaveName:"BUYER_ITEM_NO" ,ColMerge:1}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태",	SaveName:"STATUS_CODE_TEXT" ,ColMerge:1}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"상태코드",	SaveName:"STATUS_CODE" ,ColMerge:0}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"구분",	SaveName:"CHECK_TEXT" ,ColMerge:0}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사명",	SaveName:"BELOW_COMORG_TEXT" ,ColMerge:0}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사명",	SaveName:"AGENT_TEXT" ,ColMerge:0}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"계약번호",	SaveName:"CONTRACT_NO" ,ColMerge:0}       
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"계약항번",	SaveName:"CONTRACT_SEQ" ,ColMerge:0}
		,{ Align:"Left",	Width:140,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품명",	SaveName:"DESCRIPTION" ,ColMerge:0}
		,{ Align:"Center",	Width:140,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준카탈로그",	SaveName:"CMS_CATLG_ID" ,ColMerge:0}     
		,{ Align:"Left",	Width:140,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION" ,ColMerge:0}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사코드",	SaveName:"MAKER_CODE" ,ColMerge:0}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사명",	SaveName:"MAKER_NAME" ,ColMerge:0}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"원산지코드",	SaveName:"ORIGIN_CODE" ,ColMerge:0}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"모델번호",	SaveName:"MAKER_PART_NO" ,ColMerge:0}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사코드",	SaveName:"BELOW_COMORG_CODE" ,ColMerge:0}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사코드",	SaveName:"AGENT" ,ColMerge:0}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준카테고리",	SaveName:"CH_CMS_CATEG_ID" ,ColMerge:0}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준카테고리명",	SaveName:"CH_CMS_CATEG_NAME" ,ColMerge:0}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"GBN",	SaveName:"GBN" ,ColMerge:0}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SEQ",	SaveName:"SEQ" ,ColMerge:0}
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	var initsheet2 = {};
	initsheet2.Cols = [  
	      			 {Align : "Left",SaveName : "CMS_CATEG_ID",		Header : "표준카테고리코드",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			,{Align : "Left",SaveName : "STATUS",		Header : "상태",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			,{Align : "Left",SaveName : "CATEG_NAME",		Header : "표준카테고리명",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			,{Align : "Left",SaveName : "CATEG_SYS_ID",		Header : "시스템코드",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			,{Align : "Left",SaveName : "CATEG_TYPE",		Header : "카테고리유형",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			,{Align : "Left",SaveName : "PID",		Header : "상위카테고리코드",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			,{Align : "Left",SaveName : "DEPTH",		Header : "깊이",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			,{Align : "Left",SaveName : "SG_ID",		Header : "SG_ID",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			,{Align : "Left",SaveName : "CATEG_PATH",		Header : "카테고리경로",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			,{Align : "Left",SaveName : "DESCRIPT",		Header : "설명",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			
	];
	
	IBS_InitSheet(mySheet2, initsheet2,pagingMode);
}
	
// 기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && str !="excelUpload" && str !="check" && str !="modify" && str != "cmsExcelDown" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	} 

	switch (str) {
	case "search":	 // 조회 

	 	buttonChk = "N";
		pagingMode = "N";
		kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmCatalogInfoMultiAlter.do" , pagingMode );
		
		break;

	case "excelUpload":	// 엑셀업로드

	 	buttonChk = "N";
		mySheet.RemoveAll();
		var params = {
			Mode : "HeaderMatch"
		};
		mySheet.LoadExcel(params); 
		break;

	case "excelDown":	// 양식다운로드 
		location.href = "/resources/excel/work/ORDER/masterMdCmCatalogInfoMultiExcel.xlsx";
		break;		
		
	case "del":	// 삭제 
		for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
			if (mySheet.GetCellValue(i, "SELECTED") == "1"){
				var st_check = mySheet.GetCellValue(i, "GBN");	// 구분 체크 (0: 변경후, 1: 변경전)
				if (st_check != "0"){
					alert(i+"행은 삭제 대상건이 아닙니다.");
					return;
	    		}
			}
    	}
	    
		if (confirm("선택된 내역을 삭제하시겠습니까?")==false) return;
		buttonChk = "N";
		kepSave(document.searchCondition ,  mySheet , "/mdcm/delMasterMdCmCatalogInfoMultiAlter.do" , "SELECTED" );
		break;
		
	case "check":	// 반영대상
		
	    if (confirm("반영대상을 검증 하시겠습니까?")==false) return;
	    buttonChk = "Y";
	    kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmCatalogInfoBeforeAfter.do" , "SELECTED" );
		break;		
				
	case "modify":	// 품의
    	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
				if (buttonChk != "Y"){	// 반영대상 버튼 눌렀는지 체크
					alert(i+"행은 반영대상 확인되어야만 수정 가능합니다.");
					return;
	    		}
				var st_status = mySheet.GetCellValue(i, "STATUS_CODE");	// 등록가능 상태 체크
				if (st_status != "C"){
					alert(i+"행은 등록가능 상태가 아닙니다. 등록가능 상태만 수정 가능합니다.");
					return;
	    		}

    	} 
	    if (confirm("선택된 내용으로 품의 상신하시겠습니까?")==false) return;
	    buttonChk = "N";
	    kepSaveAll(document.searchCondition ,  mySheet , "/mdcm/requestMasterMdCmCatalogInfoSearchPop.do" );
		break;
	case "cmsExcelDown": // 표준카테고리 엑셀다운로드
		$("#pageflag").val('0');
		var param = {FileName:"표준카테고리.xlsx"};
		kepDownExcel(document.searchCondition ,mySheet2 , "/mdcm/excelMasterMdCmCmsCatalogAlterList.do", param);
		loader_obj("N");
		break;
	 
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	loader_obj("N");
	return DATA;
}
// 엑셀 업로드 후처리
function mySheet_OnLoadExcel() {
	loader_obj("N");
	
	setSaveGridtoDB();
}

function setSaveGridtoDB(){	  
	var maxRow = mySheet.RowCount() + 1;     
	 
    for(var i =1; i<=maxRow; i++){
    	mySheet.SetCellValue(i,"SELECTED","1");
    }   
    kepSave(document.searchCondition ,  mySheet , "/mdcm/batchMasterMdCmCatalogInfoMultiAlter.do" , "SELECTED" );
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
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	
	if(!checkedSession(stCode)){return;}  
	
	var msgType = msg.substring(0,2);
	if (msgType == "PM"){	// 품의 버튼 후 처리 
		openSearchPopup('/common/approval/buyerCommonApprovalPop.do','?DOC_TYPE=IM&BIZ_DOCU_NO='+msg, "1000,500,no");
	}else{
		if (msg != "") {
			alert(msg);
		}
	}
	
   	doAction('search');
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	
	var sMsg = response.msg.MSG;    
               
   	 // 처리후 재조회
   	doAction('search');
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {

	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");  
	 
	
} 

function kepApprovalReturn(ERR,GW_NO){ 
   	doAction('search');
}
 
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>카탈로그 품목정비 일괄수정</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
   		</div>
   		<div style="display:none;">
  				<script type="text/javascript">
  					createIBSheet("mySheet2", "100%", "354px");
  				</script>
  			</div>        	
        <!--조회영역-->
       	<form name = "searchCondition"  id="searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
			<input type="hidden" id="trxl_gubun" name="trxl_gubun"  value="IM">
			<input type="hidden" id="onepagerow" name="onepagerow"  value="1000">
			<input type="hidden" id="st_query" name="st_query"  value="">			
			
            	<table  class="cont_t_list01" >
					<caption>카탈로그 품목정비 일괄수정</caption>
					<colgroup>
						<col width="5%" />
						<col width="*" /> 
					</colgroup>
						
					<tbody>
						<tr>
							<th>상태</th>
							<td>
								<select id="st_status_text" name="st_status_text" style="width:20%">
									<option value = "ALL"  selected>전체</option>
									<option value = "C">등록가능</option>
									<option value = "D1">품목정보 없음</option>
									<option value = "D2">담당고객사 아님</option>
									<option value = "D3">상품 중복등록</option>
					            </select>
							</td>
						</tr>							
					</tbody>
				</table>
            </div>
  
		</form>
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div> 
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea02">
  	          	<span class="fl">
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelUpload');">엑셀업로드</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀양식</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('cmsExcelDown');">표준카테고리</a></span>
  				</span>
  	          	<span class="fr">
  					<span class="btn_05 mr04"><a href="javascript:doAction('del');">삭제</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('check');">반영대상</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('modify');">품의</a></span>
  				</span>  				
  			 </div>
<br>
<font color="red">* 주의사항  <br>  
1. 엑셀양식에는 변경할 항목만 기재하고 변경사항이 없으면 공란으로 두면 됩니다.<br>
2. 그룹카탈로그 사용 고객회원사는 전부 변경되오니, 반영대상 조회하여 변경 전 데이터 확인 바랍니다.<br>
3. 엑셀 업로드한 내용 중 필요없는 것은 선택하여 삭제 후 진행하시면 됩니다.<br>
4. 엑셀 업로드 후에 반영대상 클릭하여 상태가 전부 등록가능해야 품의진행이 가능합니다.<br>
5. 표준카테고리 업로드 시 기존 매핑되어 있는 MSDS가 해제됩니다.<br>
6. 표준카탈로그코드(M코드) 매핑이 해제되오니, 필요한 후속조치를 준비하시기 바랍니다.(재고/VMI 유형 등)
</font>
<!--내용 종료-->	                 

</body>
</html>
