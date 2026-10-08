<%--
**********************************************
* 메뉴 : 관리자>로그관리
* 화면 : 로그관리
* 기능 : 
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 2015-11-11
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<!-- 다중선택콤보(공통) - 사용시 필수 선언 start -->
<script src="/resources/js/jquery.multiple.select.js"></script>
<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<!-- 다중선택콤보(공통) - 사용시 필수 선언 end -->

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var iconR="/resources/images/icon_r.gif";
var iconY="/resources/images/icon_y.gif";
var iconG="/resources/images/icon_g.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
// 	initsheet.HeaderMode = {			Sort : 0,			ColMove : 1,			ColResize : 1		};
	initsheet.Cols = [ 
	{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,		Type:"Text",	Header:"시스템",	SaveName:"SYSTEM"}
	,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,		Type:"Text",	Header:"화면구분",	SaveName:"MENU"}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"로그구분",	SaveName:"LOG_TYPE"}
	,{ Align:"Left",	Width:650,	Edit:false,	EditLen:100,	Type:"Text",	Header:"SQL",	SaveName:"ATTR_01"}
	,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Type:"Text",	Header:"공용필드1",	SaveName:"ATTR_02"}
	,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Type:"Text",	Header:"공용필드2",	SaveName:"ATTR_03"}
	,{ Align:"Center",	Width:200,	Edit:false,	EditLen:100,	Type:"Text",	Header:"등록자IP",	SaveName:"REG_IP"}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Type:"Text",	Header:"등록자명",	SaveName:"REG_NM"}
	,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",	Header:"등록일시",	SaveName:"ADD_DATE"}
	
	];
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
}

//페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdam/getMasterMdAmLogManageList.do?page="+current_page , pagingMode );
}
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");

	switch (str) {
	case "search":	 // 조회	
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		if ($("#st_system").val() == "KOREAB2B" && $("#st_menu").val() == "SEL"){
			alert("화면구분을 선택하여 주시기 바랍니다.");
			return;
		}
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdam/getMasterMdAmLogManageList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		$("#st_from_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
		$("#st_from_time1").val("09");
		$("#st_from_time2").val("00");
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
		$("#st_to_time1").val("09");
		$("#st_to_time2").val("10");
		$("#st_system").val("KOREAB2B");
		break;
	case	"excelDown": //엑셀다운로드
		$("#pageflag").val('0');
		var param = {FileName:"로그관리.xlsx",Merge:1,SheetDesign:1,DownCols:"SYSTEM|MENU|IRS_NO|LOG_TYPE|ATTR_01|ATTR_02|ATTR_03|REG_IP|REG_NM|ADD_DATE"};
		kepDownExcel(document.searchCondition, mySheet , "/mdam/excelMasterMdAmLogManageList.do", param);
		$("#pageflag").val('1');
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

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;

	if (msg != "") {
		alert(msg);
	}
	
}

function mySheet_OnMouseMove(Button, Shift, X, Y) { 
	var row = mySheet.MouseRow();

}
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
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

// 팝업함수호출
function doPop(str , val1) {
	popupSel = str;
	
	switch (str) {	
	}
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	return;
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
			<h3>로그 관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01">
					<caption>로그관리</caption>
					<colgroup>
						<col width="8%" />
						<col width="17%" />
						<col width="8%" />
						<col width="17%" />
						<col width="8%" />
                        <col width="14%" />
                        <col width="8%" />
                        <col width="20%" />
					</colgroup>
						
					<tbody>
						<tr> 
							<td>등록일시</td>
							<td colspan="3">
								<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:80px; text-align:center;" >
								<select name="st_from_time1" id="st_from_time1" style="width:40px; height:24px">
									<option value="00">00</option>
									<option value="01">01</option>
									<option value="02">02</option>
									<option value="03">03</option>
									<option value="04">04</option>
									<option value="05">05</option>
									<option value="06">06</option>
									<option value="07">07</option>
									<option value="08">08</option>
									<option value="09" selected="selected">09</option>
									<option value="10">10</option>
									<option value="11">11</option>
									<option value="12">12</option>
									<option value="13">13</option>
									<option value="14">14</option>
									<option value="15">15</option>
									<option value="16">16</option>
									<option value="17">17</option>
									<option value="18">18</option>
									<option value="19">19</option>
									<option value="20">20</option>
									<option value="21">21</option>
									<option value="22">22</option>
									<option value="23">23</option>
								</select> :
								<select name="st_from_time2" id="st_from_time2" style="width:40px; height:24px">
									<option value="00" selected="selected">00</option>
									<option value="10">10</option>
									<option value="20">20</option>
									<option value="30">30</option>
									<option value="40">40</option>
									<option value="50">50</option>
								</select> -
								<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:80px; text-align:center;" >
								<select name="st_to_time1" id="st_to_time1" style="width:40px; height:24px">
									<option value="00">00</option>
									<option value="01">01</option>
									<option value="02">02</option>
									<option value="03">03</option>
									<option value="04">04</option>
									<option value="05">05</option>
									<option value="06">06</option>
									<option value="07">07</option>
									<option value="08">08</option>
									<option value="09" selected="selected">09</option>
									<option value="10">10</option>
									<option value="11">11</option>
									<option value="12">12</option>
									<option value="13">13</option>
									<option value="14">14</option>
									<option value="15">15</option>
									<option value="16">16</option>
									<option value="17">17</option>
									<option value="18">18</option>
									<option value="19">19</option>
									<option value="20">20</option>
									<option value="21">21</option>
									<option value="22">22</option>
									<option value="23">23</option>
								</select> :
								<select name="st_to_time2" id="st_to_time2" style="width:40px; height:24px">
									<option value="00">00</option>
									<option value="10" selected="selected">10</option>
									<option value="20">20</option>
									<option value="30">30</option>
									<option value="40">40</option>
									<option value="50">50</option>
								</select>
							</td>
							<td>시스템구분</td>
							<td>
					  			<select name="st_system" id="st_system" style="width:90%; height:24px" class="TitSelect">
						      		<option value="">전체</option>
									<option value="KOREAB2B" selected="selected">구매대행MRO</option>
									<option value="CMRO">건설MRO</option>
									<option value="KWAY">유통</option>
	                           </select>
							</td>
							<td>화면구분</td>
							<td>
								<select name="st_menu" id="st_menu" style="width:90%;">
									<option value="SEL" selected="selected">선택</option>
									<option value="ALL">전체</option>
									<option value="PO">주문메뉴접근</option>
									<option value="ADMIN">관리자메뉴접근</option>
									<option value="USER_BUYER">사용자조회(고객사)</option>
									<option value="USER_KEP">사용자조회(운영사)</option>
									<option value="COMPANY">회원사조회</option>
								</select>
							</td>
							
						</tr>
						<tr>
							<td>등록자명</td>
							<td>
								<input type="text" name="st_add_name" id="st_add_name" style="width:90%" value="" onkeydown="kepEnter()" />								
							</td>
							<td>등록자IP</td>
							<td>
								<input type="text" name="st_add_ip" id="st_add_ip" style="width:90%" value="" onkeydown="kepEnter()" />								
							</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="50" selected>50건</option>
					<option value="100">100건</option>
					<option value="500">500건</option>
				</select>
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "490px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fr">
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  			 </div>
<!--내용 종료-->	                 

</body>
</html>
