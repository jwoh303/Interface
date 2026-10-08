<%--
**********************************************
* 메뉴 : 재고현황 모니터링 > 재고현황관리 > 재고현황 추이
* 화면 : 재고현황 추이
* 기능 :
* 프로그램 ID : 
* 담당자 : 한승준 ( 설계 : 김승우 )
* 착수일 : 2015-11-12
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
	              	 { Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",			Header:"구분",		SaveName:"STCK_TYPE",	ColMerge:1}
	              	,{ Align:"Center",	Width:30,	Edit:false,	EditLen:30,		Hidden:false,	Type:"Text",			Header:"구분",		SaveName:"ITEM_TYPE",	ColMerge:1}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"1월",		SaveName:"JAN_AMT"}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"2월",		SaveName:"FEB_AMT"}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"3월",		SaveName:"MAR_AMT"}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"4월",		SaveName:"APR_AMT"}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"5월",		SaveName:"MAY_AMT"}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"6월",		SaveName:"JUN_AMT"}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"7월",		SaveName:"JUL_AMT"}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"8월",		SaveName:"AUG_AMT"}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"9월",		SaveName:"SEP_AMT"}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"10월",	SaveName:"OCT_AMT"}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"11월",	SaveName:"NOV_AMT"}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"12월",	SaveName:"DEC_AMT"}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"평균",		SaveName:"AVG_AMT"}
];
	
	var info = [ {StdCol:"STCK_TYPE", SumCols:"JAN_AMT|FEB_AMT|MAR_AMT|APR_AMT|MAY_AMT|JUN_AMT|JUL_AMT|AUG_AMT|SEP_AMT|OCT_AMT|NOV_AMT|DEC_AMT|AVG_AMT",
		CaptionCol:"STCK_TYPE", ShowCumulate:0, CaptionText:"- 소 계 -"} ];
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	
	//var cfg = {MergeSheet:msAll};
	var cfg = {MergeSheet:msPrevColumnMerge + msHeaderOnly};
	mySheet.SetConfig(cfg);
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	mySheet.ShowSubSum(info);
	
	// 사업팀 콤보박스
	kepAjaxCommonQueryIdCombo('st_dept','master.mdcd.selectMasterMdCdBuyerCardManageDeptList99','ALL','');
	
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(0);
}

// 기능함수
function doAction(str) {
	switch (str) {
	case "search":	 // 조회
		//kepSearch()
		IBS_SaveName(document.searchCondition,mySheet);
		//조회조건 묶기
		var param = FormQueryStringEnc2(document.searchCondition);
		//조회
		mySheet.DoSearch("/mpst/getMasterMpStLongTermStckFlowList.do", param);
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		$("#st_year").val("<%=nowYear%>");
		break;
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
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
	
	if(!checkedSession(stCode)){
		return;
		}	

	if (msg != ""){
		alert(msg);
	}
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	
	if(!checkedSession(stCode)){
		return;
	}
	
	if (msg != ""){
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

function mySheet_OnDownFinish(downloadType, result){
	loader_obj("N");
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA">
			<h3>재고현황 추이</h3>
			(단위 : 천원)
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
        	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span> 
   		</div>        	
        <!--조회영역-->
       	<form id = "searchCondition" name = "searchCondition" method = "post">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>재고현황 추이</caption>
					<colgroup>
						<col width="30px" />
						<col width="25%" />
						<col width="30px" />
						<col width="25%" />
						<col width="30px" />
						<col width="25%" />
					</colgroup>
					<tbody>
					<tr>
						<th>기준년도</th>
						<td>
							<select id="st_year" name="st_year" style="width:60px;">
								<% 
								  	for (int i=startYear ; i<=nowYear; i++) {
								  		out.println("<option value='"+i+"'" + ((i == nowYear) ? " selected>" : ">")+i);
								  	} 
								 %>
								</select>
						</td>
						<th>사업팀명</th>
						<td>
							<select id="st_dept" name="st_dept" style="width:120px; height:20px"></select>
						</td>
						<th>재고구분</th>
						<td>
							<select id="st_stck_type" name="st_stck_type" style="width:120px;">
								<option value="ALL">전체</option>
								<option value="N">정상재고</option>
								<option value="L">장기재고</option>
								<option value="F">불용재고</option>
							</select>
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
	      	createIBSheet("mySheet", "100%", "300px");
			</script>
		</div>

		<b>-불변 그룹 : 체류 경과기간에 관계없이 판매 가능한 제품 그룹</b>
		<br>
		<b>-가변 그룹 : 체류 기간에 따라 품질이상이 발생할 수 있는 제품 그룹</b>
<!--내용 종료-->	                 
</body>
</html>
