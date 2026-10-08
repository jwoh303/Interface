<%--
**********************************************
* 메뉴 : 통계>경영실적통계>협력사별 매입실적
* 화면 : 협력사별 매입실적
* 기능 : 협력사별로 팀당 매입실적을 집계하여 보여주는 화면
* 프로그램 ID :
* 담당자 : 한승준 ( 설계 : 김승우 )
* 착수일 : 2016-08-18
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String check_date       = DateTimeUtil.getFormatString("yyyyMMddHHmm");
int nowYear             = Integer.parseInt(check_date.substring(0,4));
int startYear = 2010;
%>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Left",	Width:140,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:1,	Type:"Text",		Header:"협력사명",	SaveName:"AGENT_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:1,	Type:"Text",		Header:"부서명",		SaveName:"TEAM_NAME"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:17,		Hidden:false,	ColMerge:0,	Type:"AutoSum",	Header:"계",			SaveName:"TOTAL",	ToolTip:1}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,		Hidden:false,	ColMerge:0,	Type:"AutoSum",	Header:"1월",			SaveName:"JAN",	ToolTip:1}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,		Hidden:false,	ColMerge:0,	Type:"AutoSum",	Header:"2월",			SaveName:"FEB",	ToolTip:1}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,		Hidden:false,	ColMerge:0,	Type:"AutoSum",	Header:"3월",			SaveName:"MAR",	ToolTip:1}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,		Hidden:false,	ColMerge:0,	Type:"AutoSum",	Header:"4월",			SaveName:"APR",	ToolTip:1}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,		Hidden:false,	ColMerge:0,	Type:"AutoSum",	Header:"5월",			SaveName:"MAY",	ToolTip:1}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,		Hidden:false,	ColMerge:0,	Type:"AutoSum",	Header:"6월",			SaveName:"JUN",	ToolTip:1}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,		Hidden:false,	ColMerge:0,	Type:"AutoSum",	Header:"7월",			SaveName:"JUL",	ToolTip:1}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,		Hidden:false,	ColMerge:0,	Type:"AutoSum",	Header:"8월",			SaveName:"AUG",	ToolTip:1}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,		Hidden:false,	ColMerge:0,	Type:"AutoSum",	Header:"9월",			SaveName:"SEP",	ToolTip:1}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,		Hidden:false,	ColMerge:0,	Type:"AutoSum",	Header:"10월",		SaveName:"OCT",	ToolTip:1}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,		Hidden:false,	ColMerge:0,	Type:"AutoSum",	Header:"11월",		SaveName:"NOV",	ToolTip:1}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,		Hidden:false,	ColMerge:0,	Type:"AutoSum",	Header:"12월",		SaveName:"DEC",	ToolTip:1}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	ColMerge:0,	Type:"Text",		Header:"협력사코드", SaveName:"AGENT"}
	];

	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};

	var cfg = {MergeSheet:msPrevColumnMerge};

	mySheet.SetConfig(cfg);

	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');

	kepAjaxCommonQueryIdCombo('st_user_dept','master.mdcd.selectMasterMdCdBuyerCardManageDeptList99','ALL', '${sessionInfo.department}');
}
	
// 기능함수
function doAction(str) {
	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpst/getMasterMpStSellerApResultList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		
		$("#st_year").val("<%=nowYear%>");
		$("#st_agent_code").val("");		
		break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	
	if(!checkedSession(stCode)){
		return;
	}
	
   	if(mySheet.RowCount() <= 0){
   		return;
   	}
	
   	// 협력사코드를 금액에 툴팁으로 보여줌
   	for(var i=1; i<mySheet.RowCount(); i++){
		for(var j=2; j<mySheet.LastCol(); j++){ // 계~12월 컬럼
			mySheet.SetToolTipText(i, j, mySheet.GetCellValue(i, "AGENT"));	
		}
	}
	
 	// 합계 행 다듬기
	mySheet.SetSumValue(0, "- 합     계 -");
	mySheet.SetCellAlign(mySheet.LastRow(), 0, "Center");
	mySheet.SetMergeCell (mySheet.LastRow(), 0, 1, 2);
	
   	if (msg != "") {
		alert(msg);
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpst/getMasterMpStSellerApResultList.do?page="+current_page , pagingMode );
}

//팝업함수호출
function doPop(str,key) {
	popupSel = str;
	
	switch (str) {
		case "agent_single": // 협력사
			openSearchPopup("/common/icomcmpyPop.do", '?BUSINESS_COND=S&MULTI=N', "500,466,no");
			popupSel = "agent_single";
			break;	
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "agent_single") {	// 협력사
		$("#st_agent_code").val(code);
		$("#st_agent_name").val(text);
	}
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>협력사별 매입실적</h3>
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
			
            	<table  class="cont_t_list01" >
					<caption>협력사별 매입실적</caption>
					<colgroup>
						<col width="5%" />
					    <col width="10%" />
					    <col width="5%" />
					    <col width="25%" />
					    <col width="5%" />
					    <col width="20%" />
					    <col width="5%" />
					    <col width="20%" />
					    <col width="*" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>년도</th>
							<td>
								<select id="st_year" name="st_year" style="width:60px;">
								<% 
								  	for (int i=startYear ; i<=nowYear; i++) {
								  		out.println("<option value='"+i+"'" + ((i == nowYear) ? " selected>" : ">")+i);
								  	} 
								 %>
								</select>							
							</td>
							
							<th>협력사</th>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:65%" onclick="doPop('agent_single');" readonly>
								<input type="hidden" name="st_agent_code" id="st_agent_code">
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							
							<th>부서</th>
							<td>
								<select id="st_user_dept" name="st_user_dept" style="width:150px;"></select>
							</td>
							
							<th></th>
							<td colspan="2"></td>
						</tr>
					</tbody>
				</table>
            </div>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "450px");
  				</script>
  			</div>
<!--내용 종료-->	                 

</body>
</html>
