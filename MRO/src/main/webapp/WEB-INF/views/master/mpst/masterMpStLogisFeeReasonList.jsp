<%--
**********************************************
* 메뉴 : 물류수수료 통계 > 물류수수료(사유별)
* 화면 : 물류수수료(사유별)
* 기능 :
* 프로그램 ID : 
* 담당자 : HSJ ( 설계 : 김승우 )
* 착수일 : 2017-04-07
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
	              	 { Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"사업팀|사업팀코드",		SaveName:"TEAM_CODE",					ColMerge:1}
	              	,{ Align:"Center",	Width:110,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",		Header:"사업팀|사업팀",			SaveName:"TEAM_NAME",					ColMerge:1}
	              	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",		Header:"구분|구분",					SaveName:"TYPE_NAME",					ColMerge:1}
	              	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"사유|사유코드",			SaveName:"REASON_CODE",				ColMerge:0}
	              	,{ Align:"Center",	Width:110,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",		Header:"사유|사유",					SaveName:"REASON_NAME",				ColMerge:0}
	              	
	              	,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"누계|수수료\n합계",	SaveName:"TOTAL_SUM_FEE",			ColMerge:0}
					,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"누계|수수료\n요율",	SaveName:"TOTAL_FEE_RATE",			ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"누계|전체\n금액",	SaveName:"TOTAL_AMT",					ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"누계|TR\n금액",		SaveName:"TOTAL_TR_AMT",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"누계|VMI\n금액",		SaveName:"TOTAL_VMI_AMT",			ColMerge:0}
					
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"1월|수수료\n합계",	SaveName:"JAN_SUM_FEE",				ColMerge:0}
					,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"1월|수수료\n요율",	SaveName:"JAN_FEE_RATE",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"1월|전체\n금액",		SaveName:"JAN_AMT",						ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"1월|TR\n금액",		SaveName:"JAN_TR_AMT",					ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"1월|VMI\n금액",		SaveName:"JAN_VMI_AMT",				ColMerge:0}
					
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"2월|수수료\n합계",	SaveName:"FEB_SUM_FEE",				ColMerge:0}
					,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"2월|수수료\n요율",	SaveName:"FEB_FEE_RATE",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"2월|전체\n금액",		SaveName:"FEB_AMT",						ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"2월|TR\n금액",		SaveName:"FEB_TR_AMT",					ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"2월|VMI\n금액",		SaveName:"FEB_VMI_AMT",				ColMerge:0}
					
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"3월|수수료\n합계",	SaveName:"MAR_SUM_FEE",				ColMerge:0}
					,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"3월|수수료\n요율",	SaveName:"MAR_FEE_RATE",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"3월|전체\n금액",		SaveName:"MAR_AMT",					ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"3월|TR\n금액",		SaveName:"MAR_TR_AMT",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"3월|VMI\n금액",		SaveName:"MAR_VMI_AMT",				ColMerge:0}
					
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"4월|수수료\n합계",	SaveName:"APR_SUM_FEE",				ColMerge:0}
					,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"4월|수수료\n요율",	SaveName:"APR_FEE_RATE",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"4월|전체\n금액",		SaveName:"APR_AMT",						ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"4월|TR\n금액",		SaveName:"APR_TR_AMT",					ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"4월|VMI\n금액",		SaveName:"APR_VMI_AMT",				ColMerge:0}
					
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"5월|수수료\n합계",	SaveName:"MAY_SUM_FEE",				ColMerge:0}
					,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"5월|수수료\n요율",	SaveName:"MAY_FEE_RATE",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"5월|전체\n금액",		SaveName:"MAY_AMT",					ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"5월|TR\n금액",		SaveName:"MAY_TR_AMT",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"5월|VMI\n금액",		SaveName:"MAY_VMI_AMT",				ColMerge:0}
					
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"6월|수수료\n합계",	SaveName:"JUN_SUM_FEE",				ColMerge:0}
					,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"6월|수수료\n요율",	SaveName:"JUN_FEE_RATE",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"6월|전체\n금액",		SaveName:"JUN_AMT",						ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"6월|TR\n금액",		SaveName:"JUN_TR_AMT",					ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"6월|VMI\n금액",		SaveName:"JUN_VMI_AMT",				ColMerge:0}
					
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"7월|수수료\n합계",	SaveName:"JUL_SUM_FEE",				ColMerge:0}
					,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"7월|수수료\n요율",	SaveName:"JUL_FEE_RATE",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"7월|전체\n금액",		SaveName:"JUL_AMT",						ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"7월|TR\n금액",		SaveName:"JUL_TR_AMT",					ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"7월|VMI\n금액",		SaveName:"JUL_VMI_AMT",				ColMerge:0}
					
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"8월|수수료\n합계",	SaveName:"AUG_SUM_FEE",				ColMerge:0}
					,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"8월|수수료\n요율",	SaveName:"AUG_FEE_RATE",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"8월|전체\n금액",		SaveName:"AUG_AMT",						ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"8월|TR\n금액",		SaveName:"AUG_TR_AMT",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"8월|VMI\n금액",		SaveName:"AUG_VMI_AMT",				ColMerge:0}
					
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"9월|수수료\n합계",	SaveName:"SEP_SUM_FEE",				ColMerge:0}
					,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"9월|수수료\n요율",	SaveName:"SEP_FEE_RATE",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"9월|전체\n금액",		SaveName:"SEP_AMT",						ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"9월|TR\n금액",		SaveName:"SEP_TR_AMT",					ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"9월|VMI\n금액",		SaveName:"SEP_VMI_AMT",				ColMerge:0}
					
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"10월|수수료\n합계",	SaveName:"OCT_SUM_FEE",				ColMerge:0}
					,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"10월|수수료\n요율",	SaveName:"OCT_FEE_RATE",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"10월|전체\n금액",	SaveName:"OCT_AMT",						ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"10월|TR\n금액",		SaveName:"OCT_TR_AMT",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"10월|VMI\n금액",	SaveName:"OCT_VMI_AMT",				ColMerge:0}
					
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"11월|수수료\n합계",	SaveName:"NOV_SUM_FEE",				ColMerge:0}
					,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"11월|수수료\n요율",	SaveName:"NOV_FEE_RATE",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"11월|전체\n금액",	SaveName:"NOV_AMT",					ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"11월|TR\n금액",		SaveName:"NOV_TR_AMT",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"11월|VMI\n금액",	SaveName:"NOV_VMI_AMT",				ColMerge:0}
					
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"12월|수수료\n합계",	SaveName:"DEC_SUM_FEE",				ColMerge:0}
					,{ Align:"right",	Width:60,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"12월|수수료\n요율",	SaveName:"DEC_FEE_RATE",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"12월|전체\n금액",	SaveName:"DEC_AMT",						ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"12월|TR\n금액",		SaveName:"DEC_TR_AMT",				ColMerge:0}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:80,		Hidden:false,	Type:"AutoSum",	Header:"12월|VMI\n금액",	SaveName:"DEC_VMI_AMT",				ColMerge:0}
];
	
/*	var info = [ {StdCol:"STCK_TYPE", SumCols:"JAN_AMT|FEB_AMT|MAR_AMT|APR_AMT|MAY_AMT|JUN_AMT|JUL_AMT|AUG_AMT|SEP_AMT|OCT_AMT|NOV_AMT|DEC_AMT|AVG_AMT",
		CaptionCol:"STCK_TYPE", ShowCumulate:0, CaptionText:"- 소 계 -"} ];
*/		
//	mySheet.ShowSubSum(info);
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	
	//var cfg = {MergeSheet:msAll};
	var cfg = {MergeSheet:msPrevColumnMerge + msHeaderOnly};
	mySheet.SetConfig(cfg);
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	
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
		mySheet.DoSearch("/mpst/getMasterMpStLogisFeeReasonList.do", param);
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		$("#st_year").val("<%=nowYear%>");
		$("#st_buyer_code").val("");
		$("#st_buyer_name").val("");
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
	
	// 합계 행 다듬기
	mySheet.SetSumValue(1, "- 합     계 -");
	mySheet.SetMergeCell(mySheet.LastRow(), 1, 1, 4);
	mySheet.SetCellAlign(mySheet.LastRow(), 0, "Center");
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

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer") {	// 구매회원사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);	
	}
	
	grbRow="";	//초기화
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA">
			<h3>물류수수료(사유별)</h3>
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
					<caption>물류수수료(사유별)</caption>
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
						<th>조회년도</th>
						<td>
							<select id="st_year" name="st_year" style="width:60px;">
								<% 
								  	for (int i=startYear ; i<=nowYear; i++) {
								  		out.println("<option value='"+i+"'" + ((i == nowYear) ? " selected>" : ">")+i);
								  	} 
								 %>
								</select>
						</td>
						<th>부서</th>
						<td>
							<select id="st_dept" name="st_dept" style="width:120px; height:20px"></select>
						</td>
						<th>고객사</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:70%;" value = "" READONLY>
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:100px;" value ="">
							<a href="javascript:doPop('buyer');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
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
	      	createIBSheet("mySheet", "100%", "340px");
			</script>
		</div>
<!--내용 종료-->	                 
</body>
</html>
