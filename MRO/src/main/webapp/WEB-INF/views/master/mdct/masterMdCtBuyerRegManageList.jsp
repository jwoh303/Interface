<%--
**********************************************
* 메뉴 : 회원사관리>고객사관리>고객사등록관리 조회
* 화면 : 고객사등록관리 조회
* 기능 : 고객사의 등록 상태별 목록 조회
* 프로그램 ID : PG_01_M_001_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-06-03
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
var reasonOn = "/resources/images/icon.gif";
var reasonOff = "/resources/images/icon2.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					{ Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",	Width:60,		Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"COM_CODE",			Header:"고객사코드",		Type:"Text"	,	Width:140,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"COM_NAME",			Header:"고객사명",			Type:"Text",		Width:260,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"IRS_NO",				Header:"사업자등록번호",	Type:"Text",		Width:160,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"ADD_DATE",			Header:"신청일자",			Type:"Date",		Width:160,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"TEL_NO",				Header:"전화번호",			Type:"Text",		Width:160,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"CEO_NAME",			Header:"대표자명",			Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"BUSINESS_COND",	Header:"회원사구분",		Type:"Text",		Width:100,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"STATUS_TEXT",		Header:"상태",					Type:"Text",		Width:100,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"리포트관리",	SaveName:"REPORT_MAP_IMG",	Sort:0}
					,{ Align:"Center",	SaveName:"REPORT_GROUP_CD",			Header:"REPORT_GROUP_CD",			Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
					
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetImageList(1, reasonOn);
	mySheet.SetImageList(2, reasonOff);

	//하이퍼링크 설정
	setLinkCol(mySheet, "COM_CODE");	//고객사코드
	setLinkCol(mySheet, "REPORT_MAP_IMG");
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
			current_page = -1;
			if(check_search() == false){
				alert("고객사명을 입력하여 주십시오.");
				return;
			}
			kepSearch(document.searchCondition,  mySheet , "/mdct/getMasterMdCtBuyerRegManageList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_ststus").val("요청");
			mySheet.RemoveAll();
			break;
		}
	
}

function check_search(){
	var check_status = document.forms.searchCondition.st_ststus.value;
	var buyer_name = document.forms.searchCondition.st_buyer_name.value;
	if((check_status == "ALL" || check_status == "승인") && (buyer_name == "")){
		return false;
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
	kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdCtBuyerRegManageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val, val2, val3) {
	popupSel = str;
	
	switch (str) {
		case "cominfo": // 고객사 M
			openSearchPopup("/mdct/showMasterMdCtBuyerJoinAlterRequestApprovalPop.do", "?com_code="+val,  "900,700,no");
			break;	
		case "reportMapping": // 리포트 관리 등록
			openSearchPopup("/mdct/showMasterMdcReportCustomerPop.do", "?com_code="+val+"&com_name="+val2+"&inert_yn="+val3,  "900,620,no");
			break;	
		case "comJoin": // 고객사 가입
			openSearchPopup("/mdct/showMasterMdCtBuyerJoinRegistrationPop.do", "",  "900,700,no");
			break;	
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'COM_CODE') { // 요청자
		doPop("cominfo", mySheet.GetCellValue(Row,"COM_CODE"));
	}else if (column == "REPORT_MAP_IMG") { // 리포트 관리
		if(mySheet.GetCellValue(Row,"REPORT_GROUP_CD") == ""){//리포트 관리 등록
			doPop("reportMapping", mySheet.GetCellValue(Row,"COM_CODE"), mySheet.GetCellValue(Row,"COM_NAME"),"Y");
		}else{ //리포트 관리 팝업 호출
			var st_form_name = "reportCustomerForm";
			var st_popup_url = "/mdct/getMasterMdCtReportCustomerManageHd.do";
			var st_popup_param = "st_group_cd@@"+mySheet.GetCellValue(Row,"REPORT_GROUP_CD");
			var st_popup_option = "900,650,no";
			//post 팝업 호출
			openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);			
		}
		
	}
	return;
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction("search");
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {

	if (popupSel == "cominfo") {
		kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdCtBuyerRegManageList.do?page="+current_page , pagingMode );
	}
	grbRow="";	//초기화
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>고객사 등록관리 조회</h3>
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
					<caption>고객사등록관리 조회</caption>
					<colgroup>
						<col width="8%" />
						<col width="42%" />
						<col width="8%" />
						<col width="42%" />
					</colgroup>
						
					<tbody>
						<tr> 
							<td>고객사</td>
							<td style="text-align:left;">
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:71%" value=""  onkeydown="kepEnter();" />
							</td>
							<td>상태</td>
							<td>
								<select id="st_ststus" name="st_ststus" style="width:40%;height:20px">
									<option value="ALL">전체</option>
									<option value="승인">승인</option>
									<option value="요청" selected>요청</option>
									<option value="결재중">결재중</option>
									<option value="반려">반려</option>
									<option value="결재선오류">결재선오류</option>
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
  			<p class="btnArea"> 
				<span class="btn_02"><a href="javascript:doPop('comJoin')">고객사 등록</a></span>
			</p>
<!--내용 종료-->	                 

</body>
</html>
