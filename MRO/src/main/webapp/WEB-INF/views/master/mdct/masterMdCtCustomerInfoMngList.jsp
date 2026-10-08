<%--
**********************************************
* 메뉴 : 기업정보관리
* 화면 : 기업정보관리
* 기능 : 기업정보관리
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String SessionUserId         = sessionInfo.getUserId();
	//엑셀업로드 권한체크
	boolean getRoleYn = CommonUtil.getCodeCheckReturn("CP14",SessionUserId);
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	var initsheet = {};
	initsheet.Cols = [
			 { Align:"Center",	SaveName :"SELECTED",		Header:"선택",		Type:"Radio",	Width:30,	Edit:true}
			,{ Align:"Center",	SaveName:"IRS_NO",			Header:"사업자번호",	Type:"Text",	Width:100,	Edit:false,	EditLen:300,	Sort:1,		Hidden:false}
			,{ Align:"Center",	SaveName:"YYYY",			Header:"기준년도",		Type:"Text",	Width:60,	Edit:false,	EditLen:300,	Sort:1,		Hidden:false}
			,{ Align:"Left",	SaveName:"COM_NAME_LOC",	Header:"기업명",		Type:"Text",	Width:150,	Edit:false,	EditLen:300,	Sort:1,		Hidden:false}
			,{ Align:"Center",	SaveName:"CEO_NAME_LOC",	Header:"대표자명",		Type:"Text",	Width:60,	Edit:false,	EditLen:300,	Sort:1,		Hidden:false}
			,{ Align:"Left",	SaveName:"CONGLOMERATE",	Header:"기업집단",		Type:"Text",	Width:150,	Edit:false,	EditLen:300,	Sort:1,		Hidden:false}
			,{ Align:"Center",	SaveName:"CREDIT_RATING",	Header:"신용등급",		Type:"Text",	Width:60,	Edit:false,	EditLen:300,	Sort:1,		Hidden:false}
			,{ Align:"Right",	SaveName:"YEAR_AMT",		Header:"매출액",		Type:"Float",	Width:100,	Edit:false,	EditLen:300,	Sort:1,		Hidden:false, Format:"${priceFormat}"}
			,{ Align:"Right",	SaveName:"EMP_CNT",			Header:"종업원수",		Type:"Float",	Width:80,	Edit:false,	EditLen:300,	Sort:1,		Hidden:false, Format:"${priceFormat}"}
			,{ Align:"Center",	SaveName:"INDUSTRY_CODE",	Header:"산업분류코드",	Type:"Text",	Width:100,	Edit:false,	EditLen:300,	Sort:1,		Hidden:false}
			,{ Align:"Left",	SaveName:"INDUSTRY_TEXT",	Header:"산업분류명",	Type:"Text",	Width:150,	Edit:false,	EditLen:300,	Sort:1,		Hidden:false}
			,{ Align:"Center",	SaveName:"TEL_NO",			Header:"본사전화번호",	Type:"Text",	Width:100,	Edit:false,	EditLen:300,	Sort:1,		Hidden:false}
			,{ Align:"Left",	SaveName:"ADDRESS_LOC",		Header:"본사주소",		Type:"Text",	Width:300,	Edit:false,	EditLen:300,	Sort:1,		Hidden:false}
			,{ Align:"Center",	SaveName:"ADD_DATE",		Header:"등록일",		Type:"Date",	Width:70,	Edit:false,	EditLen:300,	Sort:1,		Hidden:false}
			,{ Align:"Center",	SaveName:"ADD_USER_NM",		Header:"등록자",		Type:"Text",	Width:80,	Edit:false,	EditLen:300,	Sort:1,		Hidden:false}
			,{ Align:"Center",	SaveName:"CHANGE_DATE",		Header:"수정일",		Type:"Date",	Width:70,	Edit:false,	EditLen:300,	Sort:1,		Hidden:false}
			,{ Align:"Center",	SaveName:"CHANGE_USER_NM",	Header:"수정자",		Type:"Text",	Width:80,	Edit:false,	EditLen:300,	Sort:1,		Hidden:false}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	resetValue();
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	kepSetCalender("st_modify_from_date");
	kepSetCalender("st_modify_to_date");
}

//초기화 설정
function resetValue() {
	// 콤보데이터 셋팅
	// 조회조건 : 등록자
	kepAjaxCommonQueryIdSearchTwoCombo('st_add_user_id','common.masterDepartmentUserList','','','ALL','');
	// 조회조건 : 수정자
	kepAjaxCommonQueryIdSearchTwoCombo('st_modify_user_id','common.masterDepartmentUserList','','','ALL','');

}
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if ((str == "del" || str == "saveCustomer") && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			if (kep_dateSearchCheck($("#st_modify_from_date").val(),$("#st_modify_to_date").val()) == false) return;
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mdct/getMasterMdCtCustomerInfoManageList.do" , pagingMode );
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			dateEraser();
			mySheet.RemoveAll();
			break;
		case "excelFormat":	// 양식다운로드 
			location.href = "/resources/excel/work/MDCT/masterMdCtCustomerInfoMngList.xlsx";
			break;
		case "excelDown": // 엑셀다운로드
		
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			if (kep_dateSearchCheck($("#st_modify_from_date").val(),$("#st_modify_to_date").val()) == false) return;
		    $("#pageflag").val('0');
		    var downCol = "";
			for(var i=0;i<=mySheet.LastCol();i++){
				if(!mySheet.GetColHidden(i) && mySheet.ColSaveName(i) !="SELECTED"){
					downCol += "|"+i;	
				}
			}
			var param = {FileName:"신규영업관리.xlsx",DownCols:downCol.substring(1)};
			kepDownExcel(document.searchCondition ,mySheet , "/mdct/excelMasterMdCtCustomerInfoManageList.do", param);
			$("#pageflag").val('1');
			break;
		case "excelUpload":	// 엑셀업로드
			mySheet.RemoveAll();
			var params = {
				Mode : "HeaderMatch"
			};
			mySheet.LoadExcel(params); 
			break;
		case "saveCustomer":	// 잠재고객등록
			var st_irs_no = "";  
			for(var i=1; i<mySheet.GetTotalRows()+1; i++){
				if (mySheet.GetCellValue(i, "SELECTED") == '1'){
					st_irs_no = mySheet.GetCellValue(i,"IRS_NO");
				}
			}
			openSearchPopupName("/mdct/getMasterMdCtCustomerInfo.do", "?st_irs_no=" + st_irs_no+"&insertFlag=Y","1000,800,yes","");
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
		makePageIndex2(mySheet, 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2(mySheet, current_page , document.searchCondition.onepagerow.value);	
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdCtCustomerInfoManageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val) {
	popupSel = str;
	
	switch (str) {
		case "saveCustomer": //잠재고객등록
			popupSel = "saveCustomer";
			openSearchPopup('/mdct/showMasterMdctNewCustomerPop.do', '?insertFlag=Y','1000,820,yes');
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	return;
}

function mySheet_OnChange(Row, Col, Value) {

	if ( Row  < 1) return;

	var column = mySheet.ColSaveName(Col);
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
}
//엑셀 업로드 후처리
function mySheet_OnLoadExcel() {
	
	loader_obj("N");
	
	if (4001 < mySheet.RowCount() + 1) {
		alert("4000건이하의 파일만 업로드하여 주세요.");
		mySheet.RemoveAll();
		return;
	}
	//엑셀업로드 후 처리
	kepSaveAll(document.searchCondition ,  mySheet , "/mdct/uploadMasterMdCtCustomerInfoManageList.do" , "SELECTED" );
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert("저장 되었습니다.");
	}

	if ( code > 0 ) {
		//저장 성공시 처리
		doAction("search");
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}



function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction("search");
	}
}

function dateEraser() {
	kepEraser('st_from_date','st_from_date');
	kepEraser('st_to_date','st_to_date');
}

function dateModifyEraser() {
	kepEraser('st_modify_from_date','st_modify_from_date');
	kepEraser('st_modify_to_date','st_modify_to_date');
}
//엑셀다운로드 
function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}
</script>
</head>
<%
@SuppressWarnings (value="unchecked")

String userID = _sessionInfo.getUserId();
%>
<body onload="kep_onload_view()">
	<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>기업정보관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition"  id="searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME" />
			<input type="hidden" id="pageflag" name="pageflag" value="1" />
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}" />
            	<table  class="cont_t_list01" >
					<caption>신규영업 관리</caption>
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
							<td>등록일</td>
							<td>
								<input type="text" id="st_from_date" name="st_from_date" readOnly style="width:20%; text-align:center;" >
								&nbsp;~&nbsp;
								<input type="text" id="st_to_date" name="st_to_date" readOnly style="width:20%; text-align:center;" >
								<a href="#" onClick="dateEraser()"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<td>기업명</td>
							<td>
								<input type="text" class="input_type_text" id="st_buyer" name="st_buyer" style="width:80%;" value=""  onkeydown="kepEnter()" />
							</td>
							<td>사업자번호</td>
							<td>
								<input type="text" class="input_type_text" id="st_irs_no" name="st_irs_no" style="width:80%;" value=""  onkeydown="kepEnter()" />
							</td>

						</tr>
						<tr>	
							<td>수정일</td>
							<td>
								<input type="text" id="st_modify_from_date" name="st_modify_from_date" readOnly style="width:20%; text-align:center;" >
								&nbsp;~&nbsp;
								<input type="text" id="st_modify_to_date" name="st_modify_to_date" readOnly style="width:20%; text-align:center;" >
								<a href="#" onClick="dateModifyEraser()"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<td>등록자</td>
							<td>
								<select id="st_add_user_id" name="st_add_user_id" style="width:80%;height:20px"></select>
							</td>
							<td>수정자</td>
							<td>
								<select id="st_modify_user_id" name="st_modify_user_id" style="width:80%;height:20px"></select>
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
			<span class="fl">
			<%if(getRoleYn== true){ %>
				<span class="btn_05 mr04"><a href="javascript:doAction('excelUpload');">엑셀업로드</a></span>
				<span class="btn_05 mr04"><a href="javascript:doAction('excelFormat');">엑셀양식</a></span>
			<%} %>					
			</span>
			<span class="fr">
				<span class="btn_06 mr04"><a href="javascript:doAction('saveCustomer');">잠재고객등록</a></span>
				<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
			</span>
		</div>
		<!--내용 종료-->                 
</body>
</html>
