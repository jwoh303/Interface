<%--
**********************************************
* 메뉴 : 견적관리>SG담당자별 견적관리
* 화면 : SG담당자별 견적관리
* 기능 : 
* 프로그램 ID :
* 담당자 : HSJ
* 착수일 : 2018-06-14
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>
<%
String user_dept =  _sessionInfo.getDepartment();
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var user_dept = "<%=user_dept%>";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",				SaveName:"sStatus",							Header:"상태|상태"}
					,{ Align:"Center",	Width:60,	Edit:true,		EditLen:100,	Hidden:true,	Type:"DummyCheck",	SaveName:"SELECTED",						Header:"|"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					SaveName:"KEP_USER_DEPT",				Header:"담당팀|담당팀"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					SaveName:"KEP_USER",						Header:"소싱담당자|소싱담당자"}
					,{ Align:"Right",	Width:180,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					SaveName:"QUOTATION_CNT",			Header:"견적 의뢰 접수\n(협력사 견적 미요청 건수)|견적 의뢰 접수\n(협력사 견적 미요청 건수)"}
					,{ Align:"Right",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					SaveName:"DELAY_CNT",					Header:"업체선정 및 견적제출|미선정 건수"}
					,{ Align:"Right",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					SaveName:"LONG_DELAY_CNT",			Header:"업체선정 및 견적제출|장기 미선정 건수"}
					,{ Align:"Right",	Width:180,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					SaveName:"NEGO_QUOTATION_CNT",	Header:"NEGO견적 접수\n(고객사 견적 미제출 건수)|NEGO견적 접수\n(고객사 견적 미제출 건수)"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	kepAjaxCommonQueryIdCombo('st_kep_dept','getKepDeptList','', '<%=user_dept%>'); // 조회조건 : 부서

	kep_init();
	
	doAction('search');
}

function kep_init(){
	var search_date = "";
	
	search_date = kepToMonthAdd("3", "M") + ' ~ ' + kepToMonthAdd("3", "P") + ' (매 2시간 집계)';
	$("#st_search_date").html(search_date);
	
	$("#st_kep_dept").val(user_dept);
	
	if(user_dept != "095"){ // 시스템운영팀은 담당부서 선택 가능
		$("#st_kep_dept").attr("disabled", true);
	}else{
		$("#st_kep_dept").attr("disabled", false);
	}
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
		kepSearch(document.searchCondition,  mySheet , "/mprq/getMasterMpRqSgUserMngList.do" , pagingMode);
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		kep_init();
		break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;
	
	if (msg != "") {
		alert(msg);
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
	kepSearch(document.searchCondition, mySheet, "/mprq/getMasterMpRqSgUserMngList.do?page="+current_page, pagingMode);
}

// 팝업함수호출
function doPop(str){
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH){
	if (Row < 1) return;
}

//헤더 더블클릭시 복사
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH){   
	if (Row > 0) return;
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	grbRow="";	//초기화
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>SG담당자별 견적관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<input type="hidden" id="onepagerow" name="onepagerow" value="50">
			<!-- 화면 내 정의 -->
			
            	<table  class="cont_t_list01" >
					<caption>SG담당자별 견적관리</caption>
					<colgroup>
						<col width="10%" />
						<col width="23%" />
						<col width="10%" />
						<col width="23%" />
						<col width="10%" />
						<col width="23%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>견적회신일자</th>
							<td colspan="3">
								<div id="st_search_date"></div>
							</td>
							
							<th>담당팀</th>
							<td>
								<select id="st_kep_dept" name="st_kep_dept" style="width:90%;height:20px"></select>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
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
			</div>

<!--내용 종료-->	                 

</body>
</html>
