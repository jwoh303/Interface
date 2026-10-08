<%--
**********************************************
* 메뉴 : 정산관리 > 물류비 상세 발행내역
* 화면 : 물류비 상세 발행내역 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	String st_com_code = "";
	String st_user_id = "";

	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		st_com_code =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		st_user_id =  CommonUtil.nvl((String)sessionInfo.getUserId());
	}
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"%>
<script src="/resources/js/common.js"></script>
<style type="text/css">
<!--
table.ui-datepicker-calendar {
	display: none;
}
-->
</style>

<script>
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; // Y: 번호 페이징, N : 스크롤
	var popupSel = "";

	// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function kep_onload_view() {
		var initsheet = {};
		initsheet.Cols = [
			 { Align:"Left",  Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			    Header:"상태",	SaveName:"sStatus"}			
			,{ Align:"Left",	Width:190,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",				Header:"물류센터명",		SaveName:"WAREHOUSE_CODE_TEXT"}
			,{ Align:"Left",	Width:190,	Edit:false,	EditLen:80,	    Hidden:false,	Type:"Text",				Header:"고객사명",		SaveName:"BUYER_NAME"}
			,{ Align:"Left",	Width:140,	Edit:false,	EditLen:80,	    Hidden:true,	Type:"Text",				Header:"고객사코드",		SaveName:"BUYER"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:80,	    Hidden:false,	Type:"Text",				Header:"발행일",		SaveName:"ISSUE_DATE"}
			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:80,	    Hidden:false,	Type:"Text",				Header:"발주번호",		SaveName:"PO_NO"}
			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:90,	    Hidden:false,	Type:"Text",				Header:"발주항번",		SaveName:"PO_SEQ"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:90,	    Hidden:false,	Type:"Text",				Header:"품목코드",		SaveName:"BUYER_ITEM_NO"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"품명",		SaveName:"DESCRIPTION"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",				Header:"규격",		SaveName:"SPECIFICATION"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Float",				Header:"단가",		SaveName:"AGENT_PRICE", Format:"${priceFormat}"}
			,{ Align:"Center",	Width:80,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",				Header:"단위",		SaveName:"UNIT_MEASURE"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:10,		Hidden:false,	Type:"Text",				Header:"입고 수량",	SaveName:"GR_QTY"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:140,	Hidden:false,	Type:"Float",				Header:"입고 금액",	SaveName:"AGENT_ITEM_AMT", Format:"${priceFormat}"}
			,{ Align:"Right",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"물류 위탁 수수료",	SaveName:"LOGIS_AMT", Format:"${priceFormat}"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",				Header:"담당자",	SaveName:"KEP_USER_NAME"}
			,{ Align:"Center",	Width:120,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",				Header:"연락처",	SaveName:"KEP_USER_PHONE"}
			,{ Align:"Center",	Width:80,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",				Header:"구분",	SaveName:"LOGIS_TYPE"}
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
	$("#st_buyer_name").val("");
	$("#st_warehouse_name").val("");
	$("#st_po_no").val("");
	$("#st_logis_type").val("ALL");	
	$("#LgstTotAmt").html("0");		
	mySheet.RemoveAll();
	
}

//금액정보 설정
function setSumAmt() {
	
	var LgstTotAmt = 0;	
	for( var i = 1; i <= mySheet.RowCount(); i++ ) {
			LgstTotAmt = LgstTotAmt + Number( kepFilterNum( String( mySheet.GetCellValue(i, "LOGIS_AMT") ) ) );
    }

	$("#LgstTotAmt").html( kepCommaNum(LgstTotAmt) );
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
		kepSearch(document.searchCondition, mySheet, "/mpcl/getSellerMpClLogisRateDetailList.do", pagingMode);
		break;

	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
		var param = {FileName:"물류비 상세 발행내역.xlsx",DownCols:"WAREHOUSE_CODE_TEXT|BUYER_NAME|ISSUE_DATE|PO_NO|PO_SEQ|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|AGENT_PRICE|UNIT_MEASURE|GR_QTY|AGENT_ITEM_AMT|LOGIS_AMT|KEP_USER_NAME|KEP_USER_PHONE|LOGIS_TYPE|"};
		kepDownExcel(document.searchCondition ,mySheet , "/mpcl/excelSellerMpClLogisRateDetailList.do", param);
		$("#pageflag").val('1');
		break;
	}
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	switch (str) {
		
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7, value8){	
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
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="sellerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>물류비 발행내역</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
		<h3>물류비 발행내역</h3>
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
			<input type="hidden" id="st_com_code" name="st_com_code" value="<%=st_com_code%>">

			<table class="cont_t_list01">
				<caption>물류비 상세 발행내역</caption>
				<colgroup>
					<col width="7%" />
					<col width="23%" />
					<col width="8%" />
					<col width="23%" />
					<col width="10%" />
					<col width="23%" />
					<col width="7%" />
					<col width="13%" />
				</colgroup>

				<tbody>
					<tr>
						<td><font color="#FF6600">*</font>마감월</td>
						<td colspan="7">
						<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:70px; text-align:center;" >
						<span class="btn_month"><a href="javascript:chFromDate('st_from_date','1')">-1개월</a></span> 
						<span class="btn_month"><a href="javascript:chFromDate('st_from_date','0')">당월</a></span>
						</td>						
					</tr>
					<tr>
						<th>고객사명</th>
						<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" value="" onkeydown="kepEnter()">								 
						</td>
						<th>물류센터명</th>
							<td>
								<input type="text" class="input_type_text" name="st_warehouse_name" id="st_warehouse_name" value="" onkeydown="kepEnter()">
								 
							</td>						
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<th>구분</th>
						<td>
								<select id="st_logis_type" name="st_logis_type" style="width:35%">
									<option value='ALL' selected>전체</option>
									<option value='A'>자동</option>
									<option value='B'>수기</option>
								</select>
						</td>
						<th>발주번호</th>
						<td><input type="text" class="input_type_text" id="st_po_no" name="st_po_no" style="width: 64%;" value="" onkeydown="kepEnter()"></td>
						<th></th>
						<td></td>
						<th></th>
						<td></td>
					</tr>
				</tbody>
			</table>
		</div>
		<span class="fl" style="font-weight: bold;">* 물류 위탁 수수료 협의 관련 문의 - SM 담당자 연락처 참조 / * 세금계산서 발행 관련 문의 - 박지수 프로(02-3016-7251)</span>
	</form>
	
	<!--grid-->
	<div class="ib_product" style="border-top: 2px solid #3c639c">
		<script type="text/javascript">
			createIBSheet("mySheet", "100%", "454px");
		</script>
	</div>

	<!--카운트영역-->
	<p class="paging3" id="count"></p>	
	<br>
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
						총 물류비 수수료금액:<span id="LgstTotAmt" style="font-weight:bold; color:orange;">0</span>원
					</td>
				</tr>
			</table>
		</span>
	</div>
</form>


</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>   
</div>
</body>
</html>
