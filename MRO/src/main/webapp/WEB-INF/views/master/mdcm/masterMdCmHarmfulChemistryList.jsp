<%--
**********************************************
* 메뉴 : 카탈로그관리 >물질정보 관리 > 유해화학물질 실적
* 화면 : 유해화학물질 실적
* 기능 : 
* 프로그램 ID :
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.text.SimpleDateFormat"%> 
<%@ page import="java.util.Calendar"%> 
<%@ page import="java.util.Date"%> 
<%@ page import="java.util.Locale"%> 
<%
	Calendar _calendar = Calendar.getInstance();
	Date _currentDate = new Date();
	SimpleDateFormat _formatter = new SimpleDateFormat( "yyyyMMdd", Locale.KOREA );
	String _toDay = _formatter.format ( _currentDate ); // 현재일자
	_calendar.setTime( _currentDate );        
	
	String[] _closeDate = new String[5];
	int[] _closeDay = new int[5];
	
	_calendar.add( Calendar.MONTH, -4 ); // 4개월전
	_closeDate[0] = _formatter.format( _calendar.getTime() );
	_closeDay[0] = _calendar.getActualMaximum( Calendar.DAY_OF_MONTH );
	
	String _closeRevisionDate_1 = _closeDate[0].substring(0, 6) + String.valueOf( _closeDay[0] );
	
	_calendar.add( Calendar.MONTH, 1 ); // 3개월전
	_closeDate[1] = _formatter.format( _calendar.getTime() );
	_closeDay[1] = _calendar.getActualMaximum( Calendar.DAY_OF_MONTH );
	
	String _closeRevisionDate_2 = _closeDate[1].substring(0, 6) + String.valueOf( _closeDay[1] );
	
	_calendar.add( Calendar.MONTH, 1 ); // 2개월전
	_closeDate[2] = _formatter.format( _calendar.getTime() );
	_closeDay[2] = _calendar.getActualMaximum( Calendar.DAY_OF_MONTH );
	
	String _closeRevisionDate_3 = _closeDate[2].substring(0, 6) + String.valueOf( _closeDay[2] );
	
	_calendar.add( Calendar.MONTH, 1 ); // 1개월전
	_closeDate[3] = _formatter.format( _calendar.getTime() );
	_closeDay[3] = _calendar.getActualMaximum( Calendar.DAY_OF_MONTH );
	
	String _closeRevisionDate_4 = _closeDate[3].substring(0, 6) + String.valueOf( _closeDay[3] );
	
	_calendar.add( Calendar.MONTH, 1 ); // 현재월
	_closeDate[4] = _formatter.format( _calendar.getTime() );
	_closeDay[4] = _calendar.getActualMaximum( Calendar.DAY_OF_MONTH );
	
	String _closeRevisionDate_5 = _closeDate[4].substring(0, 6) + String.valueOf( _closeDay[4] );
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %> 
<style type="text/css">
<!--
	table.ui-datepicker-calendar { display:none; }
-->
</style>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/icon.gif";
var remarkOff="/resources/images/icon2.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
						 {Align:"Center",	SaveName:"sStatus",			Header:"상태",			Type:"Status",			Width:60,		Edit:false,	EditLen:0,		Sort:0,		Hidden:true}
							,{ Align:"Center",	SaveName:"YYYYMM",		Header:"입고월",		Type:"Text",				Width:70,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"BUYER",		Header:"고객사코드",		Type:"Text",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Left",	SaveName:"BUYER_NM",		Header:"고객사",		Type:"Text",				Width:140,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"AGENT",		Header:"협력사코드",		Type:"Text",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Left",	SaveName:"AGENT_NM",		Header:"협력사",		Type:"Text",				Width:140,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Left",	SaveName:"DESCRIPTION",		Header:"품명",		Type:"Text",				Width:180,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Right",			Width:90,	Edit:false,	EditLen:40,	Hidden:false,	Type:"Float",	Header:"취급량",	SaveName:"ITEM_QTY",	Format:"${qtyFormat}"}
							,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",		Type:"Text",				Width:50,	Edit:false,	EditLen:6, ColMerge:1,Sort:1,		Hidden:false}
							,{ Align:"Left",	SaveName:"USE_MAJOR_NM",		Header:"주요용도",		Type:"Text",				Width:150,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Left",	SaveName:"STORE_METHOD_NM",		Header:"보관방법",		Type:"Text",				Width:100,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"CAS_NO",		Header:"CAS-NO",		Type:"Text",				Width:110,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Right",			Width:60,	Edit:false,	EditLen:40,	Hidden:false,	Type:"Float",	Header:"MIN",	SaveName:"MIN_CONTENT_RATE",	Format:"${qtyFormat}"}
							,{ Align:"Right",			Width:60,	Edit:false,	EditLen:40,	Hidden:false,	Type:"Float",	Header:"MAX",	SaveName:"MAX_CONTENT_RATE",	Format:"${qtyFormat}"}
							,{ Align:"Center",	SaveName:"CMC_HARMFUL_YN",		Header:"유독물질 여부",		Type:"Text",				Width:100,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"PRE_TROUBLE_YN",		Header:"사고대비 여부",		Type:"Text",				Width:100,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"BAN_OBJECT_YN",		Header:"금지물질 여부",		Type:"Text",				Width:100,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"LIMIT_OBJECT_YN",		Header:"제한물질 여부",		Type:"Text",				Width:100,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"ADD_DATE",		Header:"등록일시",		Type:"Text",				Width:100,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NM");	//고객사
	setLinkCol(mySheet, "AGENT_NM");	//협력사
	// 조회조건 초기화
	kepSetCalenderYearMonth("st_from_date");
	kepSetCalenderYearMonth("st_to_date");
	$("#st_from_date").val(kepToMonthAdd("3","M").substr(0,7));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMM','/'));
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	switch (str) {
	case "search":	 // 조회
		pagingMode = "N";
		kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmHarmfulChemistryList.do" , pagingMode );
		break;
	case "reload":	// 초기화
		$("#re_current_page").val(1);
		$( '#searchCondition' )[0].reset();
		mySheet.RemoveAll();
		$("#st_buyer_code").val("");
		$("#st_agent_code").val("");
		break;
	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
		var param = {FileName:"유해화학물질실적조회.xlsx"};
		kepDownExcel(document.searchCondition ,mySheet , "/mdcm/excelMasterMdCmHarmfulChemistryList.do", param);
		$("#pageflag").val('1');
	case "create":	 // 생성
		if(!confirm("실적데이터 생성 하시겠습니까?")){ 
			return;	
		}
		kepAjaxFormCall("/mdcm/createMasterMdCmHarmfulChemistry.do","processForm","create");
		break;
	}
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	var sMsg = response.msg.MSG;
    if(sMsg == "UPDATE_OK"){
        if(pMethod == "create")  //재실행
        { 
     	   alert("재실행 처리했습니다 .");
        } 
    }
}
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	if (msg != "") {
		alert(msg);
	}
	if(current_page==-1){
		makePageIndex2(mySheet, 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2(mySheet, current_page , document.searchCondition.onepagerow.value);	
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
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmHarmfulChemistryList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
		case "seller": // 협력사
			openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=S&MULTI=N', "500,466,no");
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'BUYER_NM') { // 고객사
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+BUYER, '800,550,no');
	}else 	if (column == 'AGENT_NM') { // 협력사
		var AGENT = mySheet.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+AGENT, '800,550,no');
	}
	return;
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}else if(popupSel == "seller") {	// 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
	}
	grbRow="";	//초기화
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>유해화학물질 실적조회</h3>
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
			<input type="hidden" name="st_all_po"  id="st_all_po" value ="N">
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
					<th>요청일</th>
					<td colspan="3">
						<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:15%; text-align:center;" value=""> - 
						<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:15%; text-align:center;" value="">
					</td>
					<th>고객사</th>
					<td>
	                       <input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:67%;" value = "" READONLY>
	                       <input type="hidden" name="st_buyer_code" id="st_buyer_code" value ="">
	                       <a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
	                       <a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
					</td>
		      </tr>
		      <tr>
					<th>협력사</th>
					<td>
	                        <input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:60%;" value ="" READONLY>
	                        <input type="hidden" name="st_agent_code" id="st_agent_code" value ="">
	                        <a href="javascript:doPop('seller');"><img src="/resources/images/btn_search03.gif"></a>
	                        <a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
                    </td>
					<th>품명</th>
					<td>
						<input type="text" class="input_type_text" name="st_desc"  id="st_desc" style="width:87%;" value =""  onKeyDown="kepEnter()">
					</td>
					<th>CAS-NO</th>
					<td>
						<input type="text" class="input_type_text" name="st_cas_no"  id="st_cas_no" style="width:87%;" value =""  onKeyDown="kepEnter()">
					</td>
		      </tr>
		    </tbody>
		  </table>
            </div>
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
				</select>
				</label>
			</span>
			<br>
		</form>
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
			<span class="fl">
				<span class="btn_05 mr04" ><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
			</span>
			<form name="processForm" id="processForm" method="post">
  			<!--버튼영역-->
               <div class="btnArea">
				<!-- 마감차수영역 -->
				<span id="grMonth">
					<select id="st_close_month" name="st_close_month"  onChange="fnSetIssueDate();">
						<option value='<%=_closeRevisionDate_1%>'><%=_closeRevisionDate_1.substring(0,4)%>년 <%=_closeRevisionDate_1.substring(4,6)%>월</option>
						<option value='<%=_closeRevisionDate_2%>'><%=_closeRevisionDate_2.substring(0,4)%>년 <%=_closeRevisionDate_2.substring(4,6)%>월</option>
						<option value='<%=_closeRevisionDate_3%>'><%=_closeRevisionDate_3.substring(0,4)%>년 <%=_closeRevisionDate_3.substring(4,6)%>월</option>
						<option value='<%=_closeRevisionDate_4%>' selected><%=_closeRevisionDate_4.substring(0,4)%>년 <%=_closeRevisionDate_4.substring(4,6)%>월</option>
						<option value='<%=_closeRevisionDate_5%>'><%=_closeRevisionDate_5.substring(0,4)%>년 <%=_closeRevisionDate_5.substring(4,6)%>월</option>
					</select>
				</span>
			마감&nbsp;&nbsp;
				<span class="fr">
					<span class="btn_06 mr04"><a href="javascript:doAction('create');">실적데이터 생성</a></span>
  				</span>
  			 </div>
  			 </form>
<!--내용 종료-->	                 
</body>
</html>
