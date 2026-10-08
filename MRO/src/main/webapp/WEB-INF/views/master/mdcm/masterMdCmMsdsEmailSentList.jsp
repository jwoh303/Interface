<%--
**********************************************
* 메뉴(운영사) : 카탈로그관리 >물질정보 관리 >MSDS 메일 전송이력 조회
* 화면 : MSDS 메일 전송이력 조회
* 기능 : MSDS 메일 전송이력 조회
* 프로그램 ID : 
* 담당자 : 한승준
* 착수일 : 2019-04-30
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
		{ Align:"Center",	Width:60,	Edit:false,		EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus"}
		,{ Align:"Center",	Width:60,	Edit:false,		EditLen:0,		Hidden:true,	Type:"Text",		Header:"순번",		SaveName:"SEQ"}
		,{ Align:"Center",	Width:150,	Edit:false,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"화면구분",		SaveName:"REG_TYPE_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"카탈로그관리코드",	SaveName:"BYIT_COMORG_CODE"}
		,{ Align:"Center",	Width:100,	Edit:false,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"고객사코드",		SaveName:"BUYER"}
		,{ Align:"Left",	Width:180,	Edit:false,		EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사명",		SaveName:"BUYER_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"발주번호",		SaveName:"PO_NO"}
		,{ Align:"Center",	Width:90,	Edit:false,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"발주항번",		SaveName:"PO_SEQ"}
		,{ Align:"Center",	Width:150,	Edit:false,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"품목코드",		SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Left",	Width:200,	Edit:false,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"품목명",		SaveName:"DESCRIPTION_LOC"}
		,{ Align:"Left",	Width:200,	Edit:false,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"규격",		SaveName:"SPECIFICATION"}
		,{ Align:"Left",	Width:150,	Edit:false,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"모델",		SaveName:"MAKER_PART_NO"}
		,{ Align:"Center",	Width:120,	Edit:false,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"제조사",		SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:120,	Edit:false,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"원산지",		SaveName:"ORIGIN_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"단위",		SaveName:"UNIT_MEASURE"}
		,{ Align:"Center",	Width:120,	Edit:false,		EditLen:20,		Hidden:false,	Type:"Text",		Header:"전송일",		SaveName:"SEND_DATE"}
		,{ Align:"Left",	Width:100,	Edit:false,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"수신자명",		SaveName:"RECV_NAME"}
		,{ Align:"Left",	Width:200,	Edit:false,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"수신자이메일",	SaveName:"RECV_EMAIL"}
		,{ Align:"Center",	Width:60,	Edit:false,		EditLen:200,	Hidden:false,	Type:"Text",		Header:"수신여부",		SaveName:"MAIL_RECV_YN"}
		,{ Align:"Center",	Width:120,	Edit:false,		EditLen:20,		Hidden:false,	Type:"Text",		Header:"수신일",		SaveName:"RECV_DATE"}
		,{ Align:"Center",	Width:100,	Edit:false,		EditLen:20,		Hidden:true,	Type:"Text",		Header:"등록자ID",		SaveName:"ADD_USER_ID"}
		,{ Align:"Center",	Width:100,	Edit:false,		EditLen:20,		Hidden:false,	Type:"Text",		Header:"등록자명",		SaveName:"ADD_USER_NAME"}
		,{ Align:"Center",	Width:120,	Edit:false,		EditLen:20,		Hidden:false,	Type:"Text",		Header:"등록일",		SaveName:"ADD_DATE"}
		,{ Align:"Center",	Width:100,	Edit:false,		EditLen:20,		Hidden:true,	Type:"Text",		Header:"수정자ID",		SaveName:"CHANGE_USER_ID"}
		,{ Align:"Center",	Width:100,	Edit:false,		EditLen:20,		Hidden:false,	Type:"Text",		Header:"수정자명",		SaveName:"CHANGE_USER_NAME"}
		,{ Align:"Center",	Width:120,	Edit:false,		EditLen:20,		Hidden:false,	Type:"Text",		Header:"수정일",		SaveName:"CHANGE_DATE"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val( kepToMonthAdd("1","M") );
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	
	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			var buyer_code = TrimCommon($("#st_buyer_code").val());
			
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				alert("조회기간은 최대 3개월 단위로 조회가 가능합니다.");
				return;
			}
			
			if(buyer_code == "")
	        {
	            alert("고객사를 선택해 주십시요.");
	            return;
	        }
			
			kepSearch(document.searchCondition, mySheet, "/mdcm/getMasterMdCmMsdsEmailSentList.do", pagingMode);
			break;
		case "reload":	// 초기화
			$("#re_current_page").val(1);
			$( '#searchCondition')[0].reset();
			mySheet.RemoveAll();
			$("#st_buyer_code").val("");
			$("#st_buyer_name").val("");
			$("#st_from_date").val( kepToMonthAdd("1","M") );
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
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
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
	
	if(code>=0){
		//저장 성공시 재조회
		doAction('search');
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
    pagingMode = "P";
	current_page = param.page;
	$("#re_current_page").val(current_page);
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmMsdsEmailSentList.do?page="+current_page , pagingMode );
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "buyer_single": // 조회조건 고객사 클릭
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
	}
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}
	grbRow="";	//초기화
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>MSDS 메일 전송이력 조회</h3>
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
			<input type="hidden" id="re_current_page" name="re_current_page"  value="">
			
			<table  class="cont_t_list01">
				<caption></caption>
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
		      			<th>전송일</th>
						<td colspan="3">
							<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:10%; text-align:center;" > - 
							<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:10%; text-align:center;" >
							&nbsp;&nbsp;
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span> 
							&nbsp;&nbsp;
						</td>
						<th>수신여부</th>
						<td>
							<select id="st_mail_recv_yn" name="st_mail_recv_yn">
								<option value = "ALL" selected>전체</option>
								<option value = "Y">Y</option>
								<option value = "N">N</option>
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
						<th>품목코드</th>
						<td><input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:87%;" value="" onkeydown="kepEnter()"></td>
						<th>수신자명</th>
						<td><input type="text" class="input_type_text" id="st_recv_name" name="st_recv_name" style="width:87%;" value="" onkeydown="kepEnter()"></td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;">
			<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" style="width: 70px;" >
				<option value="10" selected>10건</option>
				<option value="20">20건</option>
				<option value="30">30건</option>
				<option value="40">40건</option>
				<option value="50">50건</option>
			</select>
		</span>
		<br>
	</form>
	
	<!--grid-->
	<div class="ib_product" style="border-top:2px solid #3c639c">
		<script type="text/javascript">
			createIBSheet("mySheet", "100%", "400px");
		</script>
	</div>

	<p class="paging" id="pageindex"></p>
<!--내용 종료-->	                 
</body>
</html>
