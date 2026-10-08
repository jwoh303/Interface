<%--
**********************************************
* 메뉴 : 회원사관리>고객사 프로파일
* 화면 : 고객사 프로파일
* 기능 :
* 프로그램 ID :
* 담당자 : HSJ ( 설계 : HMH )
* 착수일 : 2022-11-08
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

var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	SaveName:"sStatus",						Header:"상태",			Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELECTED",					Header:"",				Type:"DummyCheck",	Width:40,	Edit:true}
					,{ Align:"Center",	SaveName:"ORG_CODE",					Header:"사업장코드",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"ORG_NAME",					Header:"사업장명",			Type:"Text",		Width:300,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"CONTRACT_FIRST_DATE",			Header:"최초계약일",		Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"CONTRACT_START_DATE",			Header:"현계약시작일",		Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"CONTRACT_END_DATE",			Header:"현계약종료일",		Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"CONTRACT_VALIDITY_DATE",		Header:"계약유효일자",		Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"CONTRACT_IMAGE_KEY",			Header:"계약서",			Type:"Text",		Width:100,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"CONTRACT_IMAGE_KEY_IMG",		Header:"계약서",			Type:"Image",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"CONTRACT_TYPE_TEXT",			Header:"계약유형",			Type:"Text",		Width:80,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"CONTRACT_NOTE",				Header:"계약서특이사항",	Type:"Text",		Width:100,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"PROCESS_STATUS_TEXT",			Header:"진행상태",			Type:"Text",		Width:100,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"CONTRACT_KIND_TEXT",			Header:"계약구분",			Type:"Text",		Width:100,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"SALES_MAP_IMAGE_KEY",			Header:"영업MAP",			Type:"Text",		Width:100,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"SALES_MAP_IMAGE_KEY_IMG",		Header:"영업MAP",			Type:"Image",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"ORG_CHART_IMAGE_KEY",			Header:"조직도",			Type:"Text",		Width:100,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"ORG_CHART_IMAGE_KEY_IMG",		Header:"조직도",			Type:"Image",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"SYS_PROCESS_IMAGE_KEY",		Header:"시스템프로세스",	Type:"Text",		Width:100,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"SYS_PROCESS_IMAGE_KEY_IMG",	Header:"시스템프로세스",	Type:"Image",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"ADD_USER_ID",					Header:"등록자",			Type:"Text",		Width:100,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"ADD_USER_NAME",				Header:"등록자",			Type:"Text",		Width:80,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"ADD_DATE",					Header:"등록일시",			Type:"Text",		Width:120,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"CHANGE_USER_ID",				Header:"수정자",			Type:"Text",		Width:100,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"CHANGE_USER_NAME",			Header:"수정자",			Type:"Text",		Width:80,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"CHANGE_DATE",					Header:"수정일시",			Type:"Text",		Width:120,	Edit:false,	EditLen:0,		Hidden:false}
					
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "ORG_NAME");	//고객사명
	
	//파일첨부이미지설정
	mySheet.SetImageList(0, diskOff);
	mySheet.SetImageList(1, diskOn);
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdct/getMasterMdCtBuyerProfileList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
			
		case "del": // 삭제
			if (confirm("선택한 건을 삭제하겠습니까?")) {
				kepSave(document.searchCondition, mySheet, "/mdct/delMasterMdCtBuyerProfileList.do", "SELECTED");
			}
			break;
		}
	
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

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdCtBuyerProfileList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val) {
	popupSel = str;
	
	switch (str) {
		case "cominfo": // 고객사 M
			openSearchPopup("/mdct/showMasterMdCtBuyerProfilePop.do", "", "900,800,no");
			break;	
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'ORG_NAME') { // 고객사명
		//post 팝업 파라미터 설정
		var st_form_name = "buyerProfileForm";
		var st_popup_url = "/mdct/getMasterMdCtBuyerProfilePopList.do";
		var st_popup_param = "org_code@@"+mySheet.GetCellValue(Row,"ORG_CODE");
		var st_popup_option = "900,800,no";
		//post 팝업 호출
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}
	return;
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if (code > 0) {
		//저장 성공시 재조회
		doAction("search");
	}
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction("search");
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {

	if (popupSel == "cominfo") {
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdct/getMasterMdCtBuyerProfileList.do" , pagingMode );
	}
	
	if (code == "CREATE"){
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdct/getMasterMdCtBuyerProfileList.do" , pagingMode );
	}

	grbRow="";	//초기화
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>고객사 프로파일</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition" name="searchCondition" method="post" onsubmit="return false;" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>고객사 프로파일</caption>
					<colgroup>
						<col width="10%" />
						<col width="90%" />
					</colgroup>
						
					<tbody>
						<tr> 
							<td>사업장</td>
							<td style="text-align:left;">
								<input type="text" class="input_type_text" name="st_org_name" id="st_org_name" style="width:30%" value=""  onkeydown="kepEnter();" />
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
			<div class="btnArea" style="margin-bottom:0px;">
  				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:doPop('cominfo');">등록</a></span>
					<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
				</span>
			</div>
<!--내용 종료-->	                 

</body>
</html>
