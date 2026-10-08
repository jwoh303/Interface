<%--
**********************************************
* 메뉴 : 매출세금계산서>매출세금계산서메일수신자업로드
* 화면 : 매출계산서메일수신자업로드
* 기능 : 
* 프로그램 ID : 
* 담당자 : KJW
* 착수일 : 2021-12-22
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
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var grbRow = "";
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
				 
	     { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus"}
		,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:true,	Type:"DummyCheck",	Header:"",			SaveName:"SELECTED"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:90,		Hidden:false,	Type:"Text",		Header:"번호",		SaveName:"KEY_8"}
		,{ Align:"Center",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"검증상태",		SaveName:"STATUS"}
		,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"세금계산서",	SaveName:"TARGET"}
		,{ Align:"Center",	Width:350,	Edit:false,	EditLen:370,	Hidden:false,	Type:"Text",		Header:"변경전 메일수신자",	SaveName:"KEY_1"}
		,{ Align:"Center",	Width:350,	Edit:false,	EditLen:370,	Hidden:false,	Type:"Text",		Header:"변경후 메일수신자",	SaveName:"KEY_2"}
		,{ Align:"Center",	Width:350,	Edit:false,	EditLen:370,	Hidden:false,	Type:"Text",		Header:"변경전 수신자이메일",	SaveName:"KEY_3"}
		,{ Align:"Center",	Width:350,	Edit:false,	EditLen:370,	Hidden:false,	Type:"Text",		Header:"변경후 수신자이메일",	SaveName:"KEY_4"}
	];

	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
}
	
// 기능함수
function doAction(str) {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	
	switch (str) {
	case "search":	 // 조회 
		pagingMode = "N";
		kepSearch(document.searchCondition,  mySheet , "/cmcl/getMasterCmClSalesReceiverUploadList.do" , pagingMode );
		break;
		
	case "reload":	// 초기화
		kepReload('searchCondition');
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
		location.href = "/resources/excel/work/CLOSE/masterCmClSalesReceiverUploadExcel.xlsx";
		break;		
		
	case "modify":	// 일괄수정
		var totRow = mySheet.RowCount();
		if( totRow <= 0){
			alert("조회 후 클릭하시기 바랍니다.");
			return;
		}
		
    	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
    		mySheet.SetCellValue(i,"SELECTED","1");
    		
    		var STATUS = mySheet.GetCellValue(i, "STATUS"); 
			if (STATUS != "정상"){
				alert(i + " 행은 수정할 수 없습니다.\n[ " + STATUS + " ]");
				return;
			}
    	} 
		
	    if (confirm("업로드 내역을 수정하시겠습니까?")==false) return;
		
		kepSave(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClSalesReceiverUpload.do" , "SELECTED" );
		break;		 
	}
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	loader_obj("N");
	return DATA;
}

function mySheet_OnLoadExcel() {
	loader_obj("N");
	
	if (4001 < mySheet.RowCount() + 1) {
		alert("4000건 이하의 파일만 업로드하여 주세요.");
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
	kepSave(document.searchCondition ,  mySheet , "/cmcl/batchMasterCmClSalesReceiverUpload.do" , "SELECTED" );
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
	
	if (msg != "") {
		alert(msg);
	}
	
   	doAction('search');
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	pagingMode = "P"; 
	kepSearch(document.searchCondition ,  mySheet , "/cmcl/getMasterCmClSalesReceiverUploadList.do?page=1" , pagingMode );
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
   	doAction('search');
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.");  
} 
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>매출계산서메일수신자업로드</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition"  id="searchCondition" method = "post" onsubmit="return false" >
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="onepagerow" name="onepagerow"  value="1000">
			<input type="hidden" id="st_query" name="st_query"  value="">
		</form>
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			
  			<!--버튼영역-->
  			<div class="btnArea02">
  				<span class="fl">
  					<font size:"12px"; color="red";></font>
  	          	</span>
  	          	<br>
  				<span class="fl">
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelUpload');">엑셀업로드</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀양식</a></span>
  				</span>
  				
  	          	<span class="fr">
  					<span class="btn_05 mr04"><a href="javascript:doAction('modify');">일괄수정</a></span>
  				</span>
  			 </div>

<!--내용 종료-->
</body>
</html>
