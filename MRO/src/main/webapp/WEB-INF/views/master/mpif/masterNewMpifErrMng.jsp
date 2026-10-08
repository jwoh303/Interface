<%--
**********************************************
* 메뉴 : I/F 관리>I/F진행현황>I/F모니터링(신)
* 화면 : I/F모니터링
* 기능 :
* 프로그램 ID : 
* 담당자 : 
* 착수일 :
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	String searchYn		= CommonUtil.nvl((String)request.getParameter("search_yn"));
	String buyerCode	= CommonUtil.nvl((String)request.getParameter("st_buyer_code"));
	String buyerName	= CommonUtil.nvl((String)request.getParameter("st_buyer_name"));
	String st_user_check = CommonUtil.nvl((String)request.getParameter("st_user_check"));
	String st_user_dept = CommonUtil.nvl((String)request.getParameter("st_user_dept"));
	String processYN = CommonUtil.nvl((String)request.getParameter("processYN"));
%>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var imageG="/resources/images/icon_g.gif";
var imageY="/resources/images/icon_y.gif";
var imageR="/resources/images/icon_r.gif";
var imageB="/resources/images/icon_b.gif";
var imageO="/resources/images/icon_o.gif";
var imageBl="/resources/images/icon_bl.gif";
var imagePrifC="/resources/images/icon_prif_c.gif";
var imagePrifR="/resources/images/icon_prif_r.gif";
var imagePrifCancel="/resources/images/icon_prif_cancel.gif";
var imagePrifDelete="/resources/images/icon_prif_delete.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var cancelRemarkOn="/resources/images/but_icon01.gif";
var cancelRemarkOff="/resources/images/but_icon02.gif";
var searchYn = "<%=searchYn%>";
var processYN ="<%=processYN%>";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 2};
	initsheet.HeaderMode = {			ColMove : 1,			ColResize : 1		};
	initsheet.Cols = [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,	Hidden:true,	Type:"Status",				Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,	Hidden:true,	Type:"DummyCheck",			Header:"",						SaveName:"SELECTED"}
		,{ Align:"Center",	Width:200,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"SEQ",			SaveName:"SEQ"}
		,{ Align:"Center",	Width:200,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"프로그램",			SaveName:"PGM_ID"}
		,{ Align:"Center",	Width:200,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"프로그램명",			SaveName:"PGM_NAME"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"발생일",			SaveName:"CREATE_DATE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"발생시간",			SaveName:"CREATE_TIME"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"유형",			SaveName:"ERR_TYPE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Image",				Header:"유형",			SaveName:"ERR_TYPEIMG"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Image",				Header:"상태",			SaveName:"STATUSIMG"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"오류제목",			SaveName:"ERR_TITLE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"오류내용",			SaveName:"ERR_NOTE"}
		,{ Align:"Center",	Width:200,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"처리",			SaveName:"JOB_NOTE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"비고",			SaveName:"STATUS",		FontColor:"#1e90ff"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"접수자",			SaveName:"RECEIPT_USER_ID"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"접수일시",			SaveName:"RECEIPT_DATE", Format:"Hms"}
		,{ Align:"left",	Width:90,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"완료자",			SaveName:"COMPLETE_USER_ID"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"완료일시",			SaveName:"COMPLETE_DATE", Format:"Hms"}
	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);

	// 상태이미지설정
	mySheet.SetImageList(1 , imageY);
	mySheet.SetImageList(0 , imageR);
	mySheet.SetImageList(2 , imageB);
	
	mySheet.SetImageList(3, imageBl);
	mySheet.SetImageList(2, imageO);
	mySheet.SetImageList(0, imageR);

	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	// 초기화 설정
	resetValue();
}

// 초기화 설정
function resetValue() {
	// 조회일자 설정
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	// 조회조건 hidden 설정
	$("#st_buyer_code").val("");

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

	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="all" && str !="reload" && selectedGrid.length == 0 ) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	if ( str == "search" ) {
		var isCheckDate = $("#st_date_flag").is(":checked");

		if ( isCheckDate ) {
			$("#st_date_flag").val("Y");
			$("#st_date_flag_value").val("Y");
		} else {
			$("#st_date_flag").val("N");
			$("#st_date_flag_value").val("N");
		}
		
	}

	switch (str) {
		case "search": // 조회
			// 조회조건 체크
			if ( !searchValidate() )
				return;
			current_page = -1;
			$("#job_kind").val("");
			kepSearch(document.searchCondition, mySheet, "/mpif/getMasterNewMpifErrMng.do", pagingMode);
			break;

		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;
	}
}

// 조회조건 체크
function searchValidate() {
	var start_date = $("#st_from_date").val().replace(/[/]/gi,"");
	var end_date = $("#st_to_date").val().replace(/[/]/gi,"");
	
	if ( start_date > end_date ) {
		alert("오류 종료일은 시작일보다 작을 수 없습니다.");
		return false;
	}
	return true;
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}


	if (msg != "") {
		alert(msg);
	}

	if ( current_page == -1 ) {
		makePageIndex2(mySheet, 1, document.searchCondition.onepagerow.value);
	}
	else {
		makePageIndex2(mySheet, current_page, document.searchCondition.onepagerow.value);
	}
	
	for( var k = 1;  k<mySheet.GetTotalRows()+1 ; k++ ) {
		
		// 글자
		if ( mySheet.GetCellValue(k, "ERR_CNT") > 0 ) {
			mySheet.SetCellFontColor(k,"ERR_CNT","#FF0000");
			mySheet.SetCellFontBold(k,"ERR_CNT",1);
		}
	}
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if ( msg != "" ) {
		alert(msg);
	}

	if ( code >= 0 ) {
		doAction("search");
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param) {
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/mpif/getMasterNewMpifErrMng.do?page="+current_page , pagingMode);
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;

	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == "STATUS" ){ 
		var seq = mySheet.GetCellValue(Row, "SEQ");
		
		popupSel = "MpifNewErrMngPop";
		openSearchPopup("/mpif/showMpifNewErrMngPop.do","?seq="+seq,"900,830,no");
	} 

	return;
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>인터페이스 모니터링 관리</h3>
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
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_name_loc" name="st_user_name_loc"  value="${sessionInfo.userNameLoc}">
			<input type="hidden" id="job_kind" name="job_kind" value="">
			<input type="hidden" id="st_cancel_remark" name="st_cancel_remark" value="">
			<input type="hidden" id="st_suser_name" name="st_suser_name" value="">

           	<table  class="cont_t_list01">
				<caption>인터페이스 모니터링 현황</caption>
				<colgroup>
					<col width="5%" />
					<col width="27%" />
					<col width="8%" />
					<col width="20%" />
					<col width="8%" />
					<col width="20%" />
				</colgroup>

				<tbody>
					<tr>
						<th>오류일</th>
						<td>
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:80px; text-align:center;" value="">
							&nbsp;~&nbsp;
							<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:80px; text-align:center;" value="">
							<input type="checkbox" class="Noborder" id="st_date_flag" name="st_date_flag" value="N"> 기간 무시
							<input type="hidden" id="st_date_flag_value" name="st_date_flag_value" value="N">
						</td>
						<th>프로그램</th>
						<td>
							<input type="text" class="input_type_text" id="st_pgm_id" name="st_pgm_id" style="width:80%;" value="" onkeydown="kepEnter()">
						</td>
					</tr>
					<tr>
						<th>오류유형</th>
						<td>
							<select id="st_error_flag" name="st_error_flag" style="width:80%">
								<option value="">전체</option>
								<option value="A">장애</option>
								<option value="B">데이터</option>
								<option value="C">I/F오류</option>
							</select>
						</td>
						<th>오류상태</th>
						<td>
							<select id="st_if_status_flag" name="st_if_status_flag" style="width:80%">
								<option value="">전체</option>
								<option value="E">오류</option>
								<option value="R">접수</option>
								<option value="C">완료</option>
							</select>
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
		</span>
		<span class="fl">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;유형 :&nbsp;</span>
		<span class="fl">
			<img src="/resources/images/icon_r.gif" style="padding-top:3px;"/>&nbsp;<b>장애</b>&nbsp;&nbsp;
			<img src="/resources/images/icon_y.gif" style="padding-top:3px;"/>&nbsp;<b>데이타</b>&nbsp;&nbsp;
			<img src="/resources/images/icon_b.gif" style="padding-top:3px;"/>&nbsp;<b>I/F오류</b>&nbsp;&nbsp;
		</span>
			<span class="fl">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;상태 :&nbsp;</span>
		<span class="fl">
			<img src="/resources/images/icon_r.gif" style="padding-top:3px;"/>&nbsp;<b>오류</b>&nbsp;&nbsp;
			<img src="/resources/images/icon_o.gif" style="padding-top:3px;"/>&nbsp;<b>접수</b>&nbsp;&nbsp;
			<img src="/resources/images/icon_bl.gif" style="padding-top:3px;"/>&nbsp;<b>완료</b>&nbsp;&nbsp;
		</span>
		<br>
	</form>

    <!--grid-->
   	<div class="ib_product" style="border-top:2px solid #3c639c">
		<script type="text/javascript">
			createIBSheet("mySheet", "100%", "333px");
		</script>
  	</div>
  	<p class="paging" id="pageindex"></p>
</body>
</html>
