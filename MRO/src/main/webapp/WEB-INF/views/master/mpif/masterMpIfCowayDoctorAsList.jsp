<%--
**********************************************
* 메뉴 : IF관리 > 코웨이 > 코웨이 닥터 AS
* 화면 : 코웨이 닥터 AS 입력
* 기능 : 코웨이 닥터 AS 데이터 입력 및 조회
* 프로그램 ID : 
* 담당자 : 최진수
* 착수일 : 2016-04-05
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
	String _stDelda = CommonUtil.nvl(request.getParameter("st_delda"));
%>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var grbRow = "";
var popupSel = "";

var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 

   		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus"}
     	,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,		Hidden:false,	Type:"DummyCheck",	Header:"",			SaveName:"SELECTED"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"물품관리번호",	SaveName:"MBLNR"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"발송일",		SaveName:"DELDA"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"사번",		SaveName:"PERNR"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"수리부품",		SaveName:"REPAIR_NAME"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"공구명",		SaveName:"TOOL_NAME"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"모델명",		SaveName:"MODEL_NAME"}
		,{ Align:"Right",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"수리비용",		SaveName:"REPAIR_COST"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"송장번호",		SaveName:"INVOICE_NUM"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"비고",		SaveName:"BIGO_IMG",	ColMerge:0,	BackColor:"${optColor}",Sort:0}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"진행상태",		SaveName:"IF_FLAG_TEXT"}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"전송결과",		SaveName:"IF_MSG"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"수리코드",		SaveName:"REPAIR_CODE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"협력사비고",	SaveName:"BIGO",		ColMerge:0,	Sort:0}
		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"진행상태코드",	SaveName:"IF_FLAG"}
	];
	
			
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	mySheet.SetImageList(5, remarkOn);
	mySheet.SetImageList(6, remarkOff);

	setLinkCol(mySheet, "BIGO_IMG");
	mySheet.SetCellFontUnderline(0, "BIGO_IMG", true);

	var st_delda = "<%=_stDelda%>";
	
	// 조회조건 일자 초기화
	kepSetCalenderYearMonth("st_delda");
	
	// 조회조건 일자 설정
	if ( st_delda == '' ) {
		$("#st_delda").val( kepGetNowTimeStr('YYYYMM','/') );
	} else {
		$("#st_delda").val( st_delda );
	}
}
	
// 기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && str !="excelUpload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	} 

	switch (str) {
	case "search":	 // 조회 
	
		pagingMode = "N";
		kepSearch(document.searchCondition,  mySheet , "/mpif/getMasterMpIfCowayDoctorAsList.do" , pagingMode );
		
		break;
		
	case "reload":	// 초기화
		kepReload('searchCondition');
		$("#st_mblnr").val(""); 
		$("#st_pernr").val(""); 
		mySheet.RemoveAll();
		break;
		
	case "del":	// 삭제 
	
		if ( !validationDelete() ) return;
	
	    if (confirm("선택된 내역을 삭제하시겠습니까?")==false) return;
	
		kepSave(document.searchCondition ,  mySheet , "/mpif/delMasterMpIfCowayDoctorAsList.do" , "SELECTED" );
		break;
		
	case "save":	// 저장
	
		if ( !validationSave() ) return;
	
	    if (confirm("선택된 내역을 저장하시겠습니까?")==false) return;
	
		kepSave(document.searchCondition ,  mySheet , "/mpif/saveMasterMpIfCowayDoctorAsList.do" , "SELECTED" );
		break;
		
	case "send":	// 전송 
	
		if ( !validationSend() ) return;
	
	    if (confirm("선택된 내역을 전송하시겠습니까?")==false) return;
	
		kepSave(document.searchCondition ,  mySheet , "/mpif/sendMasterMpIfCowayDoctorAsList.do" , "SELECTED" );
		break;
		
	case "excelUpload":	// 엑셀업로드
	
		mySheet.RemoveAll();
		var params = {
			Mode : "HeaderMatch"
		};
		mySheet.LoadExcel(params); 
		break;

	case "excelDown":	// 양식다운로드 
		location.href = "/resources/excel/work/MPIF/masterMpIfCowayDoctorAsExcel.xlsx";
		break;	 
	}
}

function validationSave() {

	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
        if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
        	var repair_code	= mySheet.GetCellValue(i,"REPAIR_CODE");
        	var bigo		= mySheet.GetCellValue(i,"BIGO");
        	var if_flag		= mySheet.GetCellValue(i,"IF_FLAG");
        	
        	if ( "Y,N".indexOf(if_flag) > -1 ) {
        		alert("임시저장, 전송오류건만 저장 가능합니다.");
        		return false;
        	}
        	
        	if (repair_code == "99" && ( bigo == "" || bigo == null) ) {
        		alert("수리부품이 기타일 경우 비고란 입력하시기 바랍니다.");
        		return false;
        	}
		}
	}
	
	return true;
}

function validationDelete() {

	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
        if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
        	var if_flag		= mySheet.GetCellValue(i,"IF_FLAG");
        	
        	if ( "Y,N".indexOf(if_flag) > -1 ) {
        		alert("임시저장, 전송오류건만 삭제 가능합니다.");
        		return false;
        	}
		}
	}
	
	return true;
}

function validationSend() {

	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
        if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
        	var if_flag		= mySheet.GetCellValue(i,"IF_FLAG");
        	
        	if ( "Y,N".indexOf(if_flag) > -1 ) {
        		alert("임시저장, 전송오류건만 전송 가능합니다.");
        		return false;
        	}
		}
	}
	
	return true;
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	loader_obj("N");
	return DATA;
}

function mySheet_OnLoadExcel() {
	loader_obj("N");
	if (2001 < mySheet.RowCount() + 1) {
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
	kepSave(document.searchCondition ,  mySheet , "/mpif/batchMasterMpIfCowayDoctorAsList.do" , "SELECTED" );
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
	
	alert(code + " / " + msg + " / " + stCode);

	/*
	if(!checkedSession(stCode)){return;}  
	
	var msgType = msg.substring(0,2);
	if (msgType == "PM"){
		openSearchPopup('/common/approval/buyerCommonApprovalPop.do','?DOC_TYPE=CAM&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg+'&PARAM1='+TrimCommon($("#st_buyer_code").val()), "1000,500,no");
	}else{
		if (msg != "") {
			alert(msg);
		}
	}
*/
   	doAction('search');
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
}



//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	if(popupSel == "bigoRemark") {	//견적 취소
		mySheet.SetCellValue(grbRow, 'BIGO', value1);
		mySheet.SetCellValue(grbRow, 'BIGO_IMG', (value1!="")? remarkOn : remarkOff);

	}
}

function mySheet_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
	/*
	if ( Row  < 1) return;  	
	var column = mySheet.ColSaveName(0 ,Col );   
	
	var AFTER_AGENT = Value;
	var AGENT = mySheet.GetCellValue(Row, 'AGENT');
	
	if (column == "AFTER_AGENT" ){  
		if (AGENT == AFTER_AGENT){
			mySheet.SetCellValue(Row, 'CHECK_STATUS_TEXT', "협력사변경없음");   
		}else{
			mySheet.SetCellValue(Row, 'CHECK_STATUS_TEXT', "정상");   
		}
		fn_AFTER_RATE(Row);
		setKepPricSubValue(Row);
	}
	
	if (RaiseFlag != "0") return; // 직접수정이 아니면 모두 return	
	
	if (column == "AFTER_UNIT_PRICE" ){   // 매출가
		 fn_AFTER_RATE(Row);
		 setKepPricSubValue(Row);
	} else 	if (column == "AFTER_LIST_PRICE" ){   // 매입가
		fn_AFTER_RATE(Row);
		setKepPricSubValue(Row);
	}
	
	*/
}


//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;  
	
	var column = mySheet.ColSaveName(0 ,Col );  
	
	popupSel = column;	  
	grbRow = Row; 
	
	if(column == "BIGO_IMG"){
		popupSel	= "bigoRemark";
		var cancel_remark	= mySheet.GetCellValue(Row, "BIGO");
		var if_flag			= mySheet.GetCellValue(Row, "IF_FLAG");
		var viewType	= "";
		
		if ( if_flag == "Y" || if_flag == "N") {
			viewType="ASRemark_READONLY";
		} else {
			viewType="ASRemark";
		}

		openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType,"500,230,no");
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	
	var sMsg = response.msg.MSG;    
    	
     if(pMethod == "POPBATCH")  // 카탈로그조회 등록 일괄 (팝업에서)
     { 
  	 	alert("등록 되었습니다.   ");        
     }           
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
			<h3>닥터AS관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
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
			<input type="hidden" id="trxl_gubun" name="trxl_gubun"  value="CAM">
			<input type="hidden" id="onepagerow" name="onepagerow"  value="1000">
			<input type="hidden" id="st_query" name="st_query"  value="">
			
            	<table  class="cont_t_list01" >
					<caption>카탈로그 조회 및 수정</caption>
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="15%" />
						<col width="35%" /> 
					</colgroup>
						
					<tbody>
						<tr>
							<th>발송월</th>
							<td>
								<input type="text" class="input_type_text" name="st_delda" id="st_delda" readOnly style="width:100px; text-align:center;" value="">
							</td>
							<th>진행상태</th>
							<td>
								<select id="st_if_flag" name="st_if_flag" style="width:80%;" >
									<option value="">--전체--</option>
									<option value="S">전송완료</option>
									<option value="E">전송오류</option>
									<option value="N">전송대기</option>
									<option value="T">임시저장</option>
								</select>
							</td>	 
						</tr>
						<tr>
							<th>물품관리번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_mblnr" name="st_mblnr" style="width:83%;" value="" onkeydown="kepEnter()">
							</td>
							<th>사번</th>
							<td>
								<input type="text" class="input_type_text" id="st_pernr" name="st_pernr" style="width:80%;" value="" onkeydown="kepEnter()">
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
  				</span>
  	          	<span class="fr">
  					<span class="btn_05 mr04"><a href="javascript:doAction('del');">삭제</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('save');">저장</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('send');">전송</a></span>
  				</span>  				
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
