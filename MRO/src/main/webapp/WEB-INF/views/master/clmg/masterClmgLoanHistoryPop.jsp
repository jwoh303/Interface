<%--
**********************************************
* 메뉴 : 
* 화면 : 추가 여신상세
* 기능 : 추가 여신상세 
* 프로그램 ID :
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}
	      			, {Align : "Center",SaveName : "STATUS_NM",		Header : "진행상태",	Type : "Text",	Width : 60,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Right",SaveName : "CREDIT_LIMIT_AMT",		Header : "추가여신금액",	Type : "Float",  Format:"${qtyFormat}",	Width : 100,	EditLen : 110,	Hidden:false, Edit : false}
	    			, {Align : "Left",SaveName : "REMARK",		Header : "추가사유",	Type : "Text",	Width : 160,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "DEPT_NM",		Header : "부서",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "ADD_USER_NM",		Header : "등록자",	Type : "Text",	Width : 60,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "ADD_DATE",		Header : "등록일",	Type : "Date",	Width : 90,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "CHANGE_USER_NM",		Header : "수정자",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "CHANGE_DATE",		Header : "수정일",	Type : "Date",	Width : 90,	EditLen : 110,Hidden:false, Edit : false}

	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterClmgLoanHistoryPop.do" , pagingMode );

}

var st;
var mt;
function doAction(str) {
	switch (str) {

	}
}
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg) {
	loader_obj("N");
   	if(mySheet.RowCount() <= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}


</script>
<title>코리아 e 플랫폼</title>
</head>

<body onload="kep_onload_view();">
<!--조회영역-->
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">	
	<input type="hidden" id="st_loan_no"  name="st_loan_no" value="${param.st_loan_no}">	
	<input type="hidden" id="st_irs_no"  name="st_irs_no" value="${param.st_irs_no}">	
	<input type="hidden" id="st_dept_cd"  name="st_dept_cd" value="${param.st_dept_cd}">	

	<!-- 500*350 -->
	<div id="popWrapper" style="height:502px;">
    	<div id="popHeader">
        	<h1 class="title">추가 여신상세</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <div id="popContainer">
			<!--팝업내용입니다-->
	        <div id="a" class="mt10">
	        	<!--grid-->
	 			<div style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "", "250px");
					</script>
				</div>
			</div>
        </div>
    </div>
</form>
		
</body>
</html>
