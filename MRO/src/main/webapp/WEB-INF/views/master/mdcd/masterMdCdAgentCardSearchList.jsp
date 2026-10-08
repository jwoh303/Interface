<%--
**********************************************
* 메뉴 : 고객카드관리>협력사 관리(조회)
* 화면 : 협력사 카드관리
* 기능 : 협력사 조회
* 프로그램 ID : PG_01_M_015_04
* 담당자 : 최철규
* 착수일 : 2017-02-09
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
		 { Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태",			SaveName:"sStatus"}
		,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사코드",	SaveName:"AGENT"}
		,{ Align:"Left",		Width:180,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사명",		SaveName:"COM_NAME_LOC"}
		,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사코드",	SaveName:"BUYER"}
		,{ Align:"Left",		Width:180,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사명",		SaveName:"BUYER_NAME_LOC"}
		,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"방문유형",		SaveName:"VISIT_TEXT"} 
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"등록자",			SaveName:"ADD_USER_NM"} 
		,{ Align:"Center",		Width:140,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"방문일",		SaveName:"VISIT_DATE"} 
		,{ Align:"Left",		Width:480,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"활동결과",		SaveName:"VISIT_NOTE"} 
		,{ Align:"Center",		Width:60,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"첨부",			SaveName:"IMAGE_KEY_IMG"}
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"첨부",			SaveName:"IMAGE_KEY"}
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"첨부",			SaveName:"ADD_DATE"}
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"첨부",			SaveName:"ADD_TIME"}
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"첨부",			SaveName:"ADD_USER_DEPT"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "VISIT_NOTE");					//고객사코드
	setLinkCol(mySheet, "IMAGE_KEY_IMG");
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	mySheet.SetImageList(1, diskOn);
	mySheet.SetImageList(2, diskOff);
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));

}

var st;
var mt;
// 기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search":	 // 조회
			var agent_name = $("#st_agent_name").val();
			var buyer_code = $("#st_buyer_code").val();
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdcd/getMasterMdCdAgentCardSearchList.do" , pagingMode );
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_buyer_code").val("");
			$("#st_buyer_name").val("");
			$("#st_agent_code").val("");
			$("#st_agent_name").val("");
			$("#st_kep_user_id").val('${sessionInfo.userId}');
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			mySheet.RemoveAll();
			break;
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'IMAGE_KEY_IMG') { // 요청자
		if (mySheet.GetCellValue(Row, "IMAGE_KEY") != "") {
			doPop('fileUpload', 	mySheet.GetCellValue(Row, "IMAGE_KEY"));
		}
	} else if (column == 'VISIT_NOTE') {				// 활동내용
		doPop("remark", mySheet.GetCellValue(Row, "AGENT"), mySheet.GetCellValue(Row, "ADD_DATE"), mySheet.GetCellValue(Row, "ADD_TIME"));
	}
	return;
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
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcd/getMasterMdCdAgentCardSearchList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val1, val2, val3) {
	popupSel = str;
	
	switch (str) {
		case "buyer":
			openSearchPopup("/coco/showCommonCoCoCompanyPop.do", "?com_type=B&safety_flag=Y", "500,500,no");
			break;
		case "agent":
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			break;
		case "remark":			// 활동내용 수정
			openSearchPopup("/mdcd/showMasterMdCdAgentPrimaryActivityDetailRegPop.do","?com_code=" + val1 + "&add_date=" + val2 + "&add_time=" + val3, "1000, 500,no");
			break;
		case "fileUpload":		//파일업로드	
			openSearchPopup("/common/fileUploadPop.do","?type=PO&viewType=R&DOC_NO="+val1, "500,430,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	if (popupSel == "buyer") {
		$("#st_buyer_code").val(code); 
		$("#st_buyer_name").val(text);	
	}
	if (popupSel == "agent") {
		$("#st_agent_code").val(code); 
		$("#st_agent_name").val(text);	
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	
	if (pMethod == "save") {
		if (sMsg == 'OK') {
			alert("등록이 완료 되었습니다.");
         // 처리후 재조회
    		doAction("search");
		} else if (sMsg == 'DUP') {
			alert("이미 등록이 되어있습니다.");
            return;
		} else {
			alert("고객카드 등록이 실패 하였습니다.\n다시 확인하여 주십시요!");
            return;
		}
	}
}

function  kepAjaxError(pMethod , response) {
	Company_Create_flag = "N"; 	
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
} 
</script>
</head>
<body onload="kep_onload_view()">

	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>협력사 관리 조회</h3>
		<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	</div>        	
	<!--조회영역-->
	<form id ="searchCondition" name="searchCondition" method = "post" onsubmit="return false" >
	<div id="cont_searchA">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" name="s_SAVENAME">
		<input type="hidden" id="pageflag" name="pageflag" value="1">
		<!-- 화면 내 정의 -->
		<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
		<input type="hidden" id="st_com_code" name="st_com_code"  value="" />
			
			<table  class="cont_t_list01" >
				<caption>협력사 관리</caption> 
				<colgroup> 
					<col width="8%" /> 
					<col width="17%" />
					<col width="8%" /> 
					<col width="17%" />
					<col width="8%" /> 
					<col width="17%" />
					<col width="8%" /> 
					<col width="17%" />
					<col width="*" />	
				</colgroup> 
				<tbody>
					<tr>
						<td>협력사</td>
						<td>
							<input type="hidden" id="st_agent_code" name="st_agent_code" value=""/>
							<input type="text" id="st_agent_name" name="st_agent_name" style="width:60%" value = "" class="input_type_text" readonly/>
							<a href="javascript:doPop('agent');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>							
						</td>
						<td>방문유형</td>
						<td>
							<select id="st_visit_kind" name="st_visit_kind" style="width:80%;height:20px">
							<script type="text/javascript">kepAjaxCommonComboDataValue('st_visit_kind', 'K003', 'ALL', '');</script>
							</select>
						</td>
						<td>등록자</td>
						<td>
							<select id="st_kep_user_id" name="st_kep_user_id" style="width:80%;height:20px">
							<script>kepAjaxCommonQueryIdCombo('st_kep_user_id','master.mdcd.selectMasterMdCdAgentCardSearchKepuserList','ALL', '${sessionInfo.userId}');</script>
							</select>
						</td>
						<td>방문내용</td>
						<td><input type="text" id="st_visit_note" name="st_visit_note" style="width:80%" value = "" class="input_type_text"  onkeydown="kepEnter()"/></td>
					</tr>
					<tr>	
						<td>방문일</td>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>				
							</td>
						<td>고객사</td>
						<td colspan="2">
							<input type="hidden" id="st_buyer_code" name="st_buyer_code" value=""/>
							<input type="text" id="st_buyer_name" name="st_buyer_name" style="width:70%" value = "" class="input_type_text"  readonly />
							<a href="javascript:doPop('buyer');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>		
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
		<br>
	</form>
					
	<!--grid-->
	<div class="ib_product" style="border-top:2px solid #3c639c">
		<script type="text/javascript">
		createIBSheet("mySheet", "100%", "354px");
		</script>
	</div>
	<p class="paging" id="pageindex"></p>

	<!--버튼영역-->
	
</body>
</html>
