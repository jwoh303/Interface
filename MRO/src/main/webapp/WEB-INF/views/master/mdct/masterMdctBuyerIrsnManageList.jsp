<%--
**********************************************
* 메뉴 : 회원사관리>고객사관리>고객사 사업자번호 관리
* 화면 : 고객사 사업자번호 관리
* 기능 : 고객사의 사업자번호 관리
* 프로그램 ID : PG_01_M_017_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-17
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="java.text.SimpleDateFormat"%> 
<%@ page import="java.util.Date"%> 
<%@ page import="java.util.Locale"%>
<%
String com_code =  _sessionInfo.getComCode();
String user_dept =  _sessionInfo.getDepartment();
Date _currentDate = new Date();
SimpleDateFormat _formatter = new SimpleDateFormat ( "yyyy", Locale.KOREA );
int _toYear = Integer.parseInt(_formatter.format ( _currentDate ));	// 현재년도
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var zipOn="/resources/images/btn_search03.gif";

var siteList = KepSheetComboQueryIdData('common.getMdctBuyerIrsnManageSiteList','SEL','');	// IBSHEET : 담당부서

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 2};
	initsheet.Cols = [
					 {Align:"Center",	SaveName:"sStatus",				Header:"상태",			Type:"Status",			Width:60,		Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELECTED",				Header:"",					Type:"DummyCheck",	Width:30,		Edit:true,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"SITE",					Header:"사이트구분",	Type:"Combo",			Width:110,	Edit:false,	EditLen:80,	Hidden:false,		KeyField:true,		BackColor:"${notnullColor}",		ComboText:siteList.ComboText, 	ComboCode:siteList.ComboCode}
					,{ Align:"Center",	SaveName:"COM_CODE",			Header:"대표 회원사코드",	Type:"Text",				Width:110,	Edit:false,	EditLen:10,	Hidden:false}
					,{ Align:"Center",	SaveName:"COM_CODE_TEXT",	Header:"대표 회원사코드",	Type:"Image",				Width:30,		Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"COM_NAME",			Header:"대표 회원사명",		Type:"Text",				Width:160,	Edit:false,	EditLen:100,	Hidden:false}

					,{ Align:"Center",	SaveName:"MAP_COM_CODE",			Header:"매핑 회원사코드",	Type:"Text",				Width:110,	Edit:false,	EditLen:10,	Hidden:false, KeyField:true}
					,{ Align:"Center",	SaveName:"MAP_COM_CODE_TEXT",			Header:"매핑 회원사코드",			Type:"Image",			Width:30,		Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"MAP_COM_NAME",			Header:"매핑 회원사명",		Type:"Text",				Width:160,	Edit:false,	EditLen:100,	Hidden:false}
					
					,{ Align:"Center",	SaveName:"IRS_NO",				Header:"사업자번호",	Type:"Text",				Width:110,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"IRS_NAME",			Header:"사업장명",		Type:"Text",				Width:260,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"CEO_NAME_LOC",		Header:"대표자명",		Type:"Text",				Width:90,		Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"SAP_CODE",			Header:"SAP 코드",		Type:"Text",				Width:100,	Edit:false,	EditLen:20,	Hidden:true}
					,{ Align:"Left",	SaveName:"INDUSTRY_TYPE",		Header:"업태",			Type:"Text",				Width:160,	Edit:false,	EditLen:50,	Hidden:false}
					,{ Align:"Left",	SaveName:"BUSINESS_ITEMS",	Header:"종목",			Type:"Text",				Width:160,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"ZIP_KEY",				Header:"우편번호",		Type:"Text",				Width:80,		Edit:false,	EditLen:30,	Hidden:true}
					,{ Align:"Center",	SaveName:"ZIP_CODE",				Header:"우편번호",		Type:"Text",				Width:80,		Edit:false,	EditLen:10,	Hidden:false}
					,{ Align:"Left",	SaveName:"ADDRESS_LOC",		Header:"주소",			Type:"Text",				Width:320,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"CHANGE_DATE",		Header:"수정일",			Type:"Date",				Width:100,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"CHANGE_USER_ID",	Header:"수정자",			Type:"Text",				Width:100,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"CHANGE_USER_NM",	Header:"수정자",			Type:"Text",				Width:80,		Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"AS_IS_IRS_NO",	Header:"TO_BE_IRS_NO",			Type:"Text",				Width:80,		Edit:false,	EditLen:100,	Hidden:true}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	//하이퍼링크 설정
	//검색 이미지설정
	mySheet.SetImageList(1, zipOn);
	setLinkCol(mySheet, "MAP_COM_CODE_TEXT");
	setLinkCol(mySheet, "COM_CODE_TEXT");
	
	kepAjaxCommonQueryIdCombo('st_kep_site','common.getMdctBuyerIrsnManageSiteList','ALL', 'KA');							// 조회조건 : 부서
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	
	// 선택된 항목 유무 체크
	if (str =="del"  && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			if(check_search() == false){
				alert("대표 회원사명, 사업자번호, 사업장명, 대표자명 중 하나 이상 조회조건이 필요합니다.");
				return;
			}
			kepSearch(document.searchCondition, mySheet, "/mdct/getMasterMdctBuyerIrsnManageList.do" , pagingMode );
			break;
		case "insert":	 // 행추가
			var rows = mySheet.DataInsert(-1);
			// 사용안함 var comCodeHtml =  "<a href=\"javascript:doPop('company');\"><img src='/resources/images/btn_search03.gif' /></a>";
			mySheet.SetCellValue(rows, "COM_CODE_TEXT", zipOn);
			mySheet.SetCellValue(rows, "MAP_COM_CODE_TEXT", zipOn);
			mySheet.SetCellEditable(rows, "SITE", 1);
			mySheet.SetCellValue(rows, "SITE","KA");
			break;	
		case "reload":				// 초기화
			kepReload('searchCondition');
			$("#st_kep_site").val("KA");
			mySheet.RemoveAll();
			break;
		case "save":					// 수정
			if (checkSubmit()) {
				kepSave(document.searchCondition, mySheet, "/mdct/saveMasterMdctBuyerIrsnManageList.do", -1 );
			}
			break;
		case "del":					// 고객사별 담당자 삭제
			if (confirm("고객사 사업자번호를 삭제하시겠습니까?")) {
				var delCnt = 0;

				for (var i = arrRow.length-1; i >= 0; i--) {
					if (mySheet.GetCellValue(arrRow[i], "sStatus") == "I") {
						mySheet.RowDelete(arrRow[i], 0);
					} else {
						delCnt++;
					}
				}

				if (delCnt > 0) {
					kepSave(document.searchCondition, mySheet, "/mdct/deleteMasterMdctBuyerIrsnManageList.do", 1);
				}
			}
			break;		
	}
}

function check_search(){
	var irs_no = document.forms.searchCondition.st_irs_no.value;
	var irs_name = document.forms.searchCondition.st_irs_name.value;
	var ceo_name = document.forms.searchCondition.st_ceo_name.value;
	var com_name = document.forms.searchCondition.st_com_name.value;
	
	if(irs_no == "" && irs_name == "" && ceo_name == "" && com_name ==""){
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
		makePageIndex2(mySheet, 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2(mySheet, current_page , document.searchCondition.onepagerow.value);	
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdctBuyerIrsnManageList.do?page="+current_page , pagingMode );
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "company": // 대표고객사
			openSearchPopup("/common/comCodePop.do","?flag=00", "600,500,no");
			break;
		case "mapping_company": // 매핑고객사 
			openSearchPopup("/common/comCodePop.do","?flag=00", "600,500,no");
			break;
	}
}
	
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'MAP_COM_CODE_TEXT') { // 매핑 고객사
		doPop('mapping_company');
	}
	if (column == 'COM_CODE_TEXT') { // 대표 회원사코드
		if(mySheet.GetCellValue(Row, 'COM_CODE_TEXT') == '/resources/images/btn_search03.gif') {
			doPop('company');
		}		
	}
	return;
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg);
	}

	if ( code > 0 ) {
		//저장 성공시 처리
		doAction("search");
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text,value3,value4,st_irs_no,st_business_items,st_industry_type,st_ceo_name,st_zip_code,st_adress_loc) {
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "company") {	// 대표고객사
		// 사용안함 var comCodeHtml =  "&nbsp;<a href=\"javascript:doPop('company');\"><img src='/resources/images/btn_search03.gif' /></a>";		
		mySheet.SetCellValue(grbRow,"COM_CODE", code);
		mySheet.SetCellValue(grbRow,"COM_NAME", text);
	}else if(popupSel == "mapping_company"){ //매핑 고객사
		mySheet.SetCellValue(grbRow, "SELECTED", "1");
		mySheet.SetCellValue(grbRow,"MAP_COM_CODE", code);
		mySheet.SetCellValue(grbRow,"MAP_COM_NAME", text);
		
		mySheet.SetCellValue(grbRow,"IRS_NO", st_irs_no);
		mySheet.SetCellValue(grbRow,"IRS_NAME", text);
		mySheet.SetCellValue(grbRow,"CEO_NAME_LOC", st_ceo_name);
		mySheet.SetCellValue(grbRow,"INDUSTRY_TYPE", st_industry_type);
		mySheet.SetCellValue(grbRow,"BUSINESS_ITEMS", st_business_items);
		mySheet.SetCellValue(grbRow,"ZIP_CODE", st_zip_code);
		mySheet.SetCellValue(grbRow,"ADDRESS_LOC", st_adress_loc);
	}

	grbRow="";	//초기화
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction("search");
	}
}

//변경 여부 체크
function checkRow() {
	var check = true;

	for (var i = 1; i <= mySheet.RowCount(); i++ ) {
		if (mySheet.GetCellValue(i, "sStatus") != 'R' ) {
        	check = false;
        	break;
		}
	}
	if (check) {
		alert("변경된 항목이 없습니다.");
		return false;
	}
	return true;
}

function checkSubmit() {
	if (!checkRow()) return false;
	
	for (var i = 1; i <= mySheet.RowCount(); i++ ) {

		if (mySheet.GetCellValue(i, "sStatus") != 'R' ) {
			if (kepTrimStr(mySheet.GetCellValue(i, "SITE")) == "") {
				alert("사이트구분을 선택해주세요.");
				mySheet.SelectCell(i, "SITE");
				return false;
			}
			
			if (kepTrimStr(mySheet.GetCellValue(i, "IRS_NO")) == "") {
				alert("사업자번호를 입력해주세요.");
				mySheet.SelectCell(i, "IRS_NO");
				return false;
			}
			
			if (kepTrimStr(mySheet.GetCellValue(i, "IRS_NAME")) == "") {
				alert("매핑 사회원사를 입력해주세요.");
				mySheet.SelectCell(i, "IRS_NAME");
				return false;
			}
			
			if (kepTrimStr(mySheet.GetCellValue(i, "CEO_NAME_LOC")) == "") {
				alert("대표자명을 입력해주세요.");
				mySheet.SelectCell(i, "CEO_NAME_LOC");
				return false;
			}
			
			if (kepTrimStr(mySheet.GetCellValue(i, "COM_CODE")) == "") {
				alert("회원사를 선택해주세요.");
				mySheet.SelectCell(i, "COM_CODE");
				return false;
			}
			
			if (kepTrimStr(mySheet.GetCellValue(i, "MAP_COM_CODE")) == "") {
				alert("사업장명을 선택해주세요.");
				mySheet.SelectCell(i, "MAP_COM_CODE");
				return false;
			}
			
			if (kepTrimStr(mySheet.GetCellValue(i, "ZIP_CODE")) == "") {
				alert("우편번호를 선택해주세요.");
				mySheet.SelectCell(i, "ZIP_CODE");
				return false;
			}
			
			if (kepTrimStr(mySheet.GetCellValue(i, "ADDRESS_LOC")) == "") {
				alert("주소를 입력해주세요.");
				mySheet.SelectCell(i, "ADDRESS_LOC");
				return false;
			}
			if(mySheet.GetCellValue(i, "AS_IS_IRS_NO") != "" ){
				if (mySheet.GetCellValue(i, "IRS_NO") != mySheet.GetCellValue(i, "AS_IS_IRS_NO")) {
					alert("기존 등록 된 사업자 번호와 변경할 사업자 번호가 동일하지\n않아 수정 불가능합니다. 해당건 삭제 후 행추가 신규등록 진행 바랍니다.");
					mySheet.SelectCell(i, "IRS_NO");
					return false;
				}				
			}
		}
	}
	
	var conf = confirm("고객사 사업자번호를 저장하시겠습니까?");
	return conf;
}
</script>
</head>
<body onload="kep_onload_view()">
	<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>고객사 사업자번호 관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition" name="searchCondition" method="post" onsubmit="return false;" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME" />
			<input type="hidden" id="pageflag" name="pageflag" value="1" />
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}" />
			<input type="hidden" id="st_sap_code" name="st_sap_code" class="input_type_text" style="width:80%" value=""  onkeypress="kepEnter();"  />
            	<table  class="cont_t_list01" >
					<caption>고객사 사업자번호 관리</caption>
					<colgroup>
						<col width="10%" />
						<col width="23%" />
						<col width="10%" />
						<col width="23%" />
						<col width="10%" />
						<col width="*" />
					</colgroup>
						
					<tbody>
						<tr> 
							<td>사이트구분</td>
							<td style="text-align:left;">
								<select id="st_kep_site" name="st_kep_site" style="width:80%"></select>
							</td>
							<td>대표 회원사명</td>
							<td style="text-align:left;">
								<input type="text" id="st_com_name" name="st_com_name" class="input_type_text" style="width:80%" value=""  onkeypress="kepEnter();"  />
							</td>
							<td>사업장명</td>
							<td style="text-align:left;">
								<input type="text" id="st_irs_name" name="st_irs_name" class="input_type_text" style="width:80%" value=""  onkeypress="kepEnter();"  />
							</td>
						</tr>
						<tr>
							<td>사업자번호</td>
							<td style="text-align:left;">
								<input type="text" id="st_irs_no" name="st_irs_no" class="input_type_text" style="width:80%" value=""  onkeypress="kepEnter();"  />
							</td>
							<td>대표자명</td>
							<td style="text-align:left;">
								<input type="text" id="st_ceo_name" name="st_ceo_name" class="input_type_text" style="width:80%" value=""  onkeypress="kepEnter();"  />
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
  		<div class="btnArea">
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('insert');">행추가</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
				<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
				
			</span>
		</div>
		<!--내용 종료-->                 
</body>
</html>
