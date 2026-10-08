<%--
**********************************************
* 메뉴 : 마감관리 > 물류비 상세 발행내역
* 화면 : 물류비 상세 발행내역 
* 기능 : 
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-09-17
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	String user_dept = "";
	String st_user_id = "";

	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		user_dept =  CommonUtil.nvl((String)sessionInfo.getDepartment()); 
		st_user_id =  CommonUtil.nvl((String)sessionInfo.getUserId());
	}
%>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
<!--
table.ui-datepicker-calendar {
	display: none;
}
-->
</style>
<%@ include file="../../common/include/head.jspf"%>
<script src="/resources/js/common.js"></script>

<script>
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; // Y: 번호 페이징, N : 스크롤
	var popupSel = "";

	// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function kep_onload_view() {
		var initsheet = {};
		initsheet.Cols = [
			 { Align:"Center",  Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			    Header:"상태",	SaveName:"sStatus"}
			,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,		Hidden:false,	Type:"DummyCheck",	ColMerge:0,	Header:"",	SaveName:"SELECTED"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",				Header:"고객사코드",		SaveName:"BUYER"}
			,{ Align:"Left",	Width:140,	Edit:false,	EditLen:80,	    Hidden:false,	Type:"Text",				Header:"고객사명",		SaveName:"BUYER_NAME"}
			,{ Align:"Center",	Width:130,	Edit:false,	EditLen:80,	    Hidden:false,	Type:"Text",				Header:"협력사\n사업자등록번호",		SaveName:"AGENT_IRS_NO"}
			,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,	    Hidden:true,	Type:"Text",				Header:"협력사코드",		SaveName:"AGENT"}
			,{ Align:"Left",	Width:140,	Edit:false,	EditLen:90,	    Hidden:false,	Type:"Text",				Header:"협력사명",		SaveName:"AGENT_NAME"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:90,	    Hidden:false,	Type:"Float",				Header:"실적등록금액",		SaveName:"INV_AMT" , Format:"${priceFormat}"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"물류Fee",		SaveName:"LOGIS_PRICE", Format:"${priceFormat}"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",				Header:"공급가액",		SaveName:"SUPP_PRICE", Format:"${priceFormat}"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Float",				Header:"세액",		SaveName:"TAX_PRICE", Format:"${priceFormat}"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Float",				Header:"합계",		SaveName:"AMT"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:10,		Hidden:false,	Type:"Text",				Header:"팀명",	SaveName:"DEPT_NAME"}
			,{ Align:"Center",	Width:80,	Edit:false,	EditLen:140,	Hidden:false,	Type:"Text",				Header:"구분",	SaveName:"LOGIS_TYPE"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"담당자명",	SaveName:"KEP_USER_NAME"}
			,{ Align:"Center",	Width:170,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",				Header:"AR번호",	SaveName:"LOGIS_TAX_BILL_NO"}
			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",				Header:"국내해외구분",	SaveName:"EXP_FLAG"}
		];

		initsheet.Cfg = {MergeSheet:msHeaderOnly};
		IBS_InitSheet(mySheet, initsheet, pagingMode);
		mySheet.SetCountPosition(4);	
		
		//조회조건 일자 초기화
		kepSetCalenderYearMonth("st_from_date");
		// 조회조건 일자 설정
		$("#st_from_date").val(kepGetNowTimeStr('YYYYMM', '/'));
		
		resetValue();

		
	}

// 초기화 설정
function resetValue() {
	//조회조건 일자 초기화
	kepSetCalenderYearMonth("st_from_date");
	// 조회조건 일자 설정
	$("#st_from_date").val(kepGetNowTimeStr('YYYYMM', '/'));
	// 기타 설정
	$("#st_buyer_code").val("");
	$("#st_buyer_name").val("");
	$("#st_agent_code").val("");
	$("#st_agent_name").val("");
	$("#st_logis_type").val("ALL");
	$("#st_user_name").val("");
	$("#LgstTotAmt").html("0");
	$("#LgstAmt").html("0");	
	mySheet.RemoveAll();
	
}

//금액정보 설정
function setSumAmt() {
	
	var LgstTotAmt = 0;
	var LgstAmt = 0;
	for( var i = 1; i <= mySheet.RowCount(); i++ ) {
			LgstTotAmt = LgstTotAmt + Number( kepFilterNum( String( mySheet.GetCellValue(i, "LOGIS_PRICE") ) ) );			
			LgstAmt = LgstAmt + Number( kepFilterNum( String( mySheet.GetCellValue(i, "TAX_PRICE") ) ) );		
    }

	$("#LgstTotAmt").html( kepCommaNum(LgstTotAmt) );
	$("#LgstAmt").html( kepCommaNum(LgstAmt) );
	
}

	

var st;
var mt;

// 그리드 표시후 처리
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {
	switch (str) {
	case "search": // 조회
		// 조회조건 체크
		current_page = -1;		
		kepSearch(document.searchCondition, mySheet, "/cmcl/getMasterCmClLogisRateDetailList_v2.do", pagingMode);
		break;

	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
		var param = {FileName:"물류비 상세 발행내역.xlsx",DownCols:"BUYER_NAME|AGENT_IRS_NO|AGENT_NAME|INV_AMT|LOGIS_PRICE|SUPP_PRICE|TAX_PRICE|AMT|DEPT_NAME|LOGIS_TYPE|KEP_USER_NAME|LOGIS_TAX_BILL_NO|EXP_FLAG|"};
		kepDownExcel(document.searchCondition ,mySheet , "/cmcl/excelMasterCmClLogisRateDetailList_v2.do", param);
		$("#pageflag").val('1');
		break;
	}
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "masterCmCoBuyerAgntcmpyPop1": // 고객사 팝업
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
			popupSel = "masterCmCoBuyerAgntcmpyPop1";
			break;			
		case "masterCmCoBuyerAgntcmpyPop2": // 협력사 팝업
			openSearchPopup("/cmco/showMasterCmCoBuyerAgntcmpyPop.do", "?st_com_type=S&st_sys_change_flag=N&st_sys_type=KA", "500,500,no");
			popupSel = "masterCmCoBuyerAgntcmpyPop2";
			break;	
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7, value8){

	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterCmCoBuyerAgntcmpyPop1") {	// 고객사, 협력사 팝업
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	} else if (popupSel == "masterCmCoBuyerAgntcmpyPop2") {	// 고객사, 협력사 팝업
		$("#st_agent_code").val(value2);
		$("#st_agent_name").val(value3);
	}
	
	grbRow="";	//초기화
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if (!checkedSession(stCode)) {
		return;
	}
	if (msg != "") {
		alert(msg);
	}
	setSumAmt();
}


//현재달의 마지막날(일자) 구하기
function lastDay(y , m , kind) {
	var d2, s = "";           
    var year, month, day;           

    d2 = new Date(y,m,"");
   
    year  = d2.getFullYear();                          
	month = (d2.getMonth()+1);
    day   = d2.getDate();
	
	if ( month < 10 ) {
		month = "0" + month;
    }
	if ( day < 10 ) {
		day = "0" + day;
    }

	s = String(year) + String(month) + String(day);

	return(s);                             
}

function chFromDate(value1, value2){
	var st_date = $('#'+value1).val();	
	var yyyy = st_date.substr(0,4);
	var mm =  st_date.substr(5,2);
	var tToday = new Date(yyyy,eval(mm + '-' + 1));
	yyyy = tToday.getFullYear();
	mm = tToday.getMonth();
	mm = "" +mm;
	if(value2 =='1') {
		 mm =(mm.length ==1)?"0"+mm: mm;
		 if(mm == "00"){
			 mm = "12";
			 yyyy = yyyy-1;
		 }
		 $('#'+value1).val(yyyy+"/"+mm);
	}	
	if(value2 =='0') {
		var today = kepGetNowTimeStr("YYYYMM","/"); // 오늘의 년 월
		$('#'+value1).val( today);
	}
	
}

</script>
</head>
<body onload="kep_onload_view()">
	<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA">
		<h3>물류비 상세 발행내역</h3>
		<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
		 <span class="btn_reset"><a	href="javascript:resetValue();">초기화</a></span>
	</div>
	<!--조회영역-->
	<form name="searchCondition" method="post" onsubmit="return false">
		<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id" value="${sessionInfo.userId}">

			<table class="cont_t_list01">
				<caption>물류비 상세 발행내역</caption>
				<colgroup>
					<col width="7%" />
					<col width="23%" />
					<col width="7%" />
					<col width="23%" />
					<col width="7%" />
					<col width="13%" />
					<col width="7%" />
					<col width="13%" />
				</colgroup>

				<tbody>
					<tr>
						<th><font color="#FF6600">*</font>실적등록월</th>
						<td><input type="text" name="st_from_date" id="st_from_date" readOnly style="width:30%; text-align:center;" >
							<span class="btn_month"><a href="javascript:chFromDate('st_from_date','1')">-1개월</a></span> 
							<span class="btn_month"><a href="javascript:chFromDate('st_from_date','0')">당월</a></span> 
							</td>							
					</tr>
					<tr>
						<th>협력사</th>
						<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" value="" readonly onclick="javascript:doPop('masterCmCoBuyerAgntcmpyPop2');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:80%" value="">								
								<a href="javascript:doPop('masterCmCoBuyerAgntcmpyPop2');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
						</td>
						<th>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" value="" readonly onclick="javascript:doPop('masterCmCoBuyerAgntcmpyPop1');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">								
								<a href="javascript:doPop('masterCmCoBuyerAgntcmpyPop1');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>						
						<td></td>
					</tr>
					<tr>
						<th>구분</th>
						<td>
								<select id="st_logis_type" name="st_logis_type" style="width:23%">
									<option value='ALL' selected>전체</option>
									<option value='A'>자동</option>
									<option value='B'>수기</option>
								</select>
						</td>
						<th>담당자명</th>
						<td><input type="text" class="input_type_text" id="st_user_name" name="st_user_name" style="width: 80%;" value="" onkeydown="kepEnter()"></td>
						<th></th>
						<td></td>
						<th></th>
						<td></td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>

	<!--grid-->
	<div class="ib_product" style="border-top: 2px solid #3c639c">
		<script type="text/javascript">
			createIBSheet("mySheet", "100%", "454px");
		</script>
	</div>

	<!--카운트영역-->
	<p class="paging3" id="count"></p>	
	<!--버튼영역-->
	<div class="btnArea">
		<span class="fl">
			<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
		</span>
		<span class="fr">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" border="1" bgcolor="#FFFFFF">
				<tr>
					<td height="35" align="right" style="font-weight:bold" align="center">
						&nbsp;
					</td>
					<td height="35" align="right" style="font-weight:bold" align="center">
						총 물류비 수수료금액:<span id="LgstTotAmt" style="font-weight:bold; color:orange;">0</span>원&nbsp;&nbsp;&nbsp;
						총 부가가치세액:<span id="LgstAmt" style="font-weight:bold; color:orange;">0</span>원
						 
					</td>
				</tr>
			</table>
		</span>
	</div>

	<!--내용 종료-->
</body>
</html>
