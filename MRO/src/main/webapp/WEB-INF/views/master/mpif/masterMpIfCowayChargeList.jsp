<%--
**********************************************
* 메뉴 : IF관리 > 코웨이 > 수수료관리
* 화면 : 수수료관리
* 기능 : 수수료내역 조회 및 전송 대기 상태로 변경.
* 프로그램 ID : 
* 담당자 : 최진수
* 착수일 : 2016-05-08
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
	String _yyyymm = CommonUtil.nvl(request.getParameter("st_yyyymm"));
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
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"구매사",	SaveName:"COM_NAME_LOC"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"마감년월",	SaveName:"CLOSE_MONTH"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"공제구분",	SaveName:"CMITM_NAME"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주번호",	SaveName:"PO_NO"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주항번",	SaveName:"PO_SEQ"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"주문번호",	SaveName:"PR_NO"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"주문항번",	SaveName:"PR_SEQ"}
		,{ Align:"Left",	Width:150,	Edit:false,	EditLen:150,	Hidden:false,	Type:"Text",		Header:"부서명",	SaveName:"DEPT_NAME"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"사용자명",	SaveName:"USER_NAME_LOC"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"AutoSum",		Header:"금액",	SaveName:"AMOUNT"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Left",	Width:250,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"품명",	SaveName:"DESCRIPTION"}
		
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"고객사코드",	SaveName:"BUYER"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"사용자사번",	SaveName:"LEGACY_USER_ID"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"부서코드",	SaveName:"DEPT_CODE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"공제구분코드",	SaveName:"CMITM"}
	];
	
			
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	var info = [ {StdCol:"CMITM_NAME", SumCols:"AMOUNT", CaptionCol:"CMITM_NAME", ShowCumulate:0, CaptionText:"- 소 계 -"} ];
	mySheet.ShowSubSum(info);
	mySheet.SetSumBackColor("#f0f0f0");

	//합계행을 감춘다.
	//mySheet.SetRowHidden(mySheet.LastRow(),1);
	
	var _yyyymm = "<%=_yyyymm%>";
	
	// 조회조건 일자 초기화
	kepSetCalenderYearMonth("st_yyyymm");
	
	// 조회조건 일자 설정
	if ( _yyyymm == '' ) {
		$("#st_yyyymm").val( kepGetNowTimeStr('YYYYMM','/') );
	} else {
		$("#st_yyyymm").val( _yyyymm );
	}
}

// 기능함수
function doAction(str) {

	switch (str) {
	case "search":	 // 조회 
	
		pagingMode = "N";
		kepSearch(document.searchCondition,  mySheet , "/mpif/getMasterMpIfCowayChargeList.do" , pagingMode );
		
		break;
		
	case "reload":	// 초기화
		mySheet.RemoveAll();
		break;
		
	case "del":	// 삭제
	
		if ( !validationDelete() ) return;
	
	    if (confirm("선택된 내역을 삭제하시겠습니까?")==false) return;
	
		kepSave(document.searchCondition ,  mySheet , "/mpif/delMasterMpIfCowayChargeList.do" , "SELECTED" );
		break;
		
	case "send":	// 전송
		// 전송 데이터 
		break;
		
	case "excelUpload":	// 엑셀업로드
	
		mySheet.RemoveAll();
		var params = {
			Mode : "HeaderMatch"
		};
		mySheet.LoadExcel(params); 
		break;

	case "excelDown":	// 양식다운로드 
		location.href = "/resources/excel/work/MPIF/masterMpIfCowayChargeExcel.xlsx";
		break;

	}
}

function validationDelete() {

	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
        if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
        	var if_flag		= mySheet.GetCellValue(i,"IF_FLAG");
        	
        	if ( "Y".indexOf(if_flag) > -1 ) {
        		alert("전송완료건은 삭제할 수 없습니다.");
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
	kepSave(document.searchCondition ,  mySheet , "/mpif/batchMasterMpIfCowayChargeList.do" , "SELECTED" );
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

   	doAction('search');
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
}



//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
}

function mySheet_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
}


//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;  
	
	var column = mySheet.ColSaveName(0 ,Col );  
	
	popupSel = column;	  
	grbRow = Row;
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
			<h3>수수료관리</h3>
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
					<colgroup>
						<col width="15%" />
						<col width="85%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>발송월</th>
							<td>
								<input type="text" class="input_type_text" name="st_yyyymm" id="st_yyyymm" readOnly style="width:100px; text-align:center;" value="">
							</td>
						</tr>
					</tbody>
				</table>
            </div>
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div> 
  			<p class="paging" id="pageindex"></p>

			<table style="width:100%;">
				<tr>
					<td colspan="2" height="25" align="left">
			            &nbsp;
			        </td>
				</tr>
			    <tr>
			        <td height="25" align="left">
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelUpload');">엑셀업로드</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀양식</a></span>
			        </td>
			        <td height="25" align = "right" valign="middle">
  					<span class="btn_05 mr04"><a href="javascript:doAction('del');">삭제</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('send');">전송</a></span>
			        </td>
			    </tr>
			</table>
  
		</form>
			
<!--내용 종료-->	                 

</body>
</html>
