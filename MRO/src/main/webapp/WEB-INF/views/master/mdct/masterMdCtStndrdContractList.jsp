<%--
**********************************************
* 메뉴 : 회원사관리>계약관리>표준계약서조회
* 화면 : 표준계약서조회
* 기능 : 
* 프로그램 ID : PG_02_M_001_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-30
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

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태",			SaveName:"sStatus"}
					,{ Align:"Center",		Width:60,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"순번",			SaveName:"NUM"}
					,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"서식번호",		SaveName:"FORM_NO"}
					,{ Align:"Left",		Width:280,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"서식이름",		SaveName:"FORM_NAME"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"서식분류",		SaveName:"FORM_TYPE"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"회원사유형",	SaveName:"COMPANY_TYPE"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"사업구분",		SaveName:"BIZ_TYPE"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"생성일",			SaveName:"ADD_DATE"}
					,{ Align:"Center",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"사용여부",		SaveName:"USE_YN"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "FORM_NAME");	//요청자
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdct/getMasterMdCtStndrdContractList.do" , pagingMode );
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			mySheet.RemoveAll();
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
	if (!checkedSession(stCode)) { return;}	

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
function pageSearch(param) {
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdCtStndrdContractList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val) {
	popupSel = str;

	switch (str) {
		case "contract": // 고객사 M
			openSearchPopup("/mdct/showMasterMdCtStndrdContractDetailPop.do", "?st_form_no=" + val, "820,700,no");
			break;
		case "write": // 고객사 M
			openSearchPopup("/mdct/showMasterMdCtStndrdContractWritePop.do", "", "820, 700,no");
			break;	
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'FORM_NAME') { // 요청자
		doPop('contract', mySheet.GetCellValue(Row,"FORM_NO"));
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "write" || popupSel == "contract") {	// 다중 고객사
		if (value1 == "OK") {
			kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdCtStndrdContractList.do?page="+current_page , pagingMode );
		}
	}
	grbRow="";	//초기화
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>표준계약서조회</h3>
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
			
            	<table  class="cont_t_list01" >
					<caption>표준계약서조회</caption>
					<colgroup>
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
                        <col width="*" />
					</colgroup>
						
					<tbody>
						<tr>
							<td>사업구분</td>
							<td>
								<select id="st_biz_type" name="st_biz_type" style="width:80%;height:20px">
									<option value="C001">구매대행</option>
									<option value="C002">유통</option>
								</select>
							</td>
							<td>회원사유형</td>
							<td>
								<select id="st_company_type" name="st_company_type" style="width:80%;height:20px">
									<option value="">전체</option>
									<option value="C001">고객사</option>
									<option value="C002">협력사</option>
								</select>
							</td>
							<td>서식분류</td>
							<td>
								<select id="st_form_type" name="st_form_type" style="width:80%;height:20px">
									<option value="">전체</option>
									<option value="C">거래약정</option>
									<option value="E">기타</option>
									<option value="P">프로모션</option>
									<option value="S">시즌</option>
								</select>
							</td>
						</tr>
						<tr> 
							<td>서식이름</td>
							<td>
								<input type="text" class="input_type_text" name="st_form_name" id="st_form_name" style="width:80%" value="" onkeydown="kepEnter()" />
							</td>
							<td>사용여부</td>
							<td>
								<select id="st_use_yn" name="st_use_yn" style="width:80%;height:20px">
									<option value="">전체</option>
									<option value="Y">사용</option>
									<option value="N">미사용</option>
								</select>
							</td>
							<td>생성일</td>
							<td>
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="" />
								<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="" />
								<a href="javascript:kepCalendar('st_to_date')"></a>
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
		<!--내용 종료-->	
		<!--버튼영역-->
		<div class="btnArea">
			<span class="fr">
				<span class="btn_06"><a href="javascript:doPop('write');">표준계약서작성</a></span>
			</span>
		</div>                 
</body>
</html>
