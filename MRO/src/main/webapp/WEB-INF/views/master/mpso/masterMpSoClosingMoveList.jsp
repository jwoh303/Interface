<%--
**********************************************
* 메뉴 : 주문관리 > 마감이월내역조회
* 화면 : 마감이월내역조회
* 기능 : 
* 프로그램 ID : 
* 담당자 : 한승준( 설계 : 김승우 )
* 착수일 : 2016-08-16
**********************************************
--%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<!-- 다중선택콤보(공통) - 사용시 필수 선언 start -->
<script src="/resources/js/jquery.multiple.select.js"></script>
<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<%
	// 현재 일자 구하기
	Calendar cal = Calendar.getInstance();

	int from_year = cal.get(cal.YEAR);
	int from_month = cal.get(cal.MONTH);
	
	int to_year = cal.get(cal.YEAR);
	int to_month = cal.get(cal.MONTH) + 1;
%>
<!-- 다중선택콤보(공통) - 사용시 필수 선언 end -->
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
						{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"고객사",			SaveName:"BUYER"}
	                  , { Align:"left",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"고객사명",		SaveName:"BUYER_NAME"}
	                  , { Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"발주번호",		SaveName:"PO_NO"}
	                  , { Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"발주항번",		SaveName:"PO_SEQ"}
	                  , { Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"품목코드",		SaveName:"BUYER_ITEM_NO"}
	                  , { Align:"left",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"품명",				SaveName:"DESCRIPTION"}
	                  , { Align:"left",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"규격",				SaveName:"SPECIFICATION"}
	                  , { Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"단위",				SaveName:"UNIT_MEASURE"}
	                  , { Align:"right",		Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"입고수량",		SaveName:"ITEM_QTY"}
	                  , { Align:"right",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"AutoSum",	Header:"매출금액",		SaveName:"ITEM_AMT"}
	                  , { Align:"right",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"AutoSum",	Header:"매입금액",		SaveName:"AGENT_ITEM_AMT"}
	                  , { Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"협력사코드",	SaveName:"AGENT"}
	                  , { Align:"left",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"협력사명",		SaveName:"AGENT_NAME"}
	                  , { Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"거래유형",		SaveName:"PROCESS_TYPE"}
	                  , { Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"등록일",			SaveName:"ADD_DATE"}
	                  , { Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"등록시간",		SaveName:"ADD_TIME"}
	                  , { Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"입고일",			SaveName:"GR_DATE"}
	                  , { Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"팀명",				SaveName:"KEP_DEPT_NAME"}
	                  , { Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"담당자명",		SaveName:"KEP_USER"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS'); 
	mySheet.SetCountPosition(4);
	
	kepAjaxCommonQueryIdCombo('st_dept', 'master.mdcd.selectMasterMdCdBuyerCardManageDeptList99', 'ALL', '${sessionInfo.department}');
}
	
var st;
var mt;
// 기능함수
function doAction(str) {
	switch (str){
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoClosingMoveList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_from_date").val("15");
			kepAjaxCommonQueryIdCombo('st_dept', 'master.mdcd.selectMasterMdCdBuyerCardManageDeptList99', 'ALL', '${sessionInfo.department}');
			
			$("#st_buyer_code").val("");
			$("#st_buyer_name").val("");
			
			// 다중선택콤보(공통) - 초기화
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
	if(!checkedSession(stCode)){return;}	
   	
	if (msg != "") {
		alert(msg);
	}
	
	// 합계 행 다듬기
	mySheet.SetSumValue(0,"- 금     액     합     계 -");
	mySheet.SetCellAlign(mySheet.LastRow(),1,"Center");
	mySheet.SetMergeCell (mySheet.LastRow(), 0, 1, 9);
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

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	switch (str) {
	case "buyer_single": // 고객사 M
		openSearchPopup("/common/safetyCompanyCodePop.do", "?COM_TYPE=B&MULTI=Y", "880,450,no"); 
		break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 고객사 
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@")); 
	}
	grbRow="";	//초기화
}

</script>
</head>

<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>마감이월내역조회</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" id="searchCondition" method = "post" onsubmit="return false">
		
		<div id="cont_searchA">
			<!--HIDDEN-->
			
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_buyer" name="st_buyer"  value="${sessionInfo.comCode}">
			
			<table class="cont_t_list01">
				<caption>마감이월내역조회</caption>
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
						<th>최초입고일</th>
						<td>
							<%=from_year%> 년 <%=from_month%> 월
							<select id="st_from_date" name="st_from_date" style="width:40px; height:20px">
								<option value="01">1</option>
								<option value="02">2</option>
								<option value="03">3</option>
								<option value="04">4</option>
								<option value="05">5</option>
								<option value="06">6</option>
								<option value="07">7</option>
								<option value="08">8</option>
								<option value="09">9</option>
								<option value="10">10</option>
								<option value="11">11</option>
								<option value="12">12</option>
								<option value="13">13</option>
								<option value="14">14</option>
								<option value="15" selected>15</option>
								<option value="16">16</option>
								<option value="17">17</option>
								<option value="18">18</option>
								<option value="19">19</option>
								<option value="20">20</option>
								<option value="21">21</option>
								<option value="22">22</option>
								<option value="23">23</option>
								<option value="24">24</option>
								<option value="25">25</option>
								<option value="26">26</option>
								<option value="27">27</option>
								<option value="28">28</option>
								<option value="29">29</option>
								<option value="30">30</option>
								<option value="31">31</option>
							</select> 일 이전
						</td>
						<th>변경입고일</th>
						<td>
							<%=to_year%> 년 <%=to_month%> 월 1 일 이후
						</td>
					</tr>
					<tr> 
						<th>고객사</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:50%;" value = "" READONLY onkeydown="kepEnter()">
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" value ="">
							<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th>사업팀</th>
						<td>
							<select id="st_dept" name="st_dept" style="width:50%;height:20px"></select>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<input type="hidden"' name="onepagerow" id="onepagerow" value="1000">
		</form>
      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "444px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
		<!--내용 종료-->	                 
</body>
</html>
