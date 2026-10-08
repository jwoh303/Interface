<%--
**********************************************
* 메뉴 : 재고현황 모니터링 > 재고현황관리 > 재고현황 상세
* 화면 : 재고현황 상세
* 기능 :
* 프로그램 ID : 
* 담당자 : 한승준 ( 설계 : 김승우 )
* 착수일 : 2015-11-12
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ include file="../../common/include/head.jspf"  %>
<%
	String buyer = "";
	String st_center_code = ""; 
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
	}
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
	              	 { Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:true,	Type:"Text",			Header:"센터코드",				SaveName:"TR_CODE"}
	              	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"센터명",					SaveName:"TR_NAME"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:true,	Type:"Text",			Header:"부서코드",				SaveName:"DEPT_CODE"}
					,{ Align:"Center",	Width:110,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",			Header:"사업팀",					SaveName:"DEPT_NAME"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:60,		Hidden:false,	Type:"Text",			Header:"그룹유형",				SaveName:"GROUP_TYPE"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:60,		Hidden:false,	Type:"Text",			Header:"재고구분",				SaveName:"LONG_TERM_TYPE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"상품코드",				SaveName:"ITEM_CODE"}
					,{ Align:"left",		Width:150,	Edit:false,	EditLen:150,	Hidden:false,	Type:"Text",			Header:"상품명",					SaveName:"ITEM_NAME"}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Float",		Header:"수량",						SaveName:"QTY"}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"AutoSum",	Header:"금액",						SaveName:"AMT"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",			Header:"최종입고일",			SaveName:"GR_DATE"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",			Header:"최종출고일",			SaveName:"IV_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"최종입고일(조립)",	SaveName:"GR_DATE_ASMB"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",			Header:"최종출고일(조립)",	SaveName:"IV_DATE_ASMB"}
];
	
	// 사업팀 콤보박스
	kepAjaxCommonQueryIdCombo('st_dept','master.mdcd.selectMasterMdCdBuyerCardManageDeptList99','ALL','');
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(4);
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
		mySheet.DoSearch("/mpst/getMasterMpStLongTermStckDtList.do", param);
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
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
       	<div id="searchBtnA"  >
			<h3>재고현황 상세</h3>
			(단위 : 원)
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
        	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span> 
   		</div>        	
        <!--조회영역-->
       	<form id = "searchCondition" name = "searchCondition" method = "post" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>재고현황 상세</caption> 
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
						<th>센터명</th>
						<td>
							<select id="st_center_code" name="st_center_code" style="width:80%;height:20px">
							<%
								Map<String, String> _map = new HashMap<String, String>();
					 			_map.put("BUYER",buyer);
							%>
							<%= CommonUtil.getCodeComboQueryIdList("common.getWareHouseIdSchStockList","ALL",_map,st_center_code) %>
							</select>
						</td>
						<th>그룹유형</th>
						<td>
							<select id="st_group_type" name="st_group_type" style="width:120px;">
								<option value="ALL">전체</option>
								<option value="A">불변</option>
								<option value="B">가변</option>
							</select>
						</td>
						<th>상품코드</th>
						<td>
							<input type="text"   class="input_type_text" name="st_item_code" id="st_item_code" style="width:70%" value="" onKeyDown="kepEnter()">
						</td>
					</tr>
					<tr>
						<th>사업팀</th>
						<td>
							<select id="st_dept" name="st_dept" style="width:50%;height:20px"></select>
						</td>
						<th>재고구분</th>
						<td>
							<select id="st_long_term_type" name="st_long_term_type" style="width:120px;">
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
	      	createIBSheet("mySheet", "100%", "400px");
			</script>
		</div>

		<b>-불변 그룹 : 체류 경과기간에 관계없이 판매 가능한 제품 그룹</b>
		<br>
		<b>-가변 그룹 : 체류 기간에 따라 품질이상이 발생할 수 있는 제품 그룹</b>
<!--내용 종료-->	                 
</body>
</html>
