<%--
**********************************************
* 메뉴 : 통계 > 재고현황 모니터링 > 재고현황 요약 > 재고현황 상세 팝업
* 화면 : 재고현황 상세 팝업
* 기능 : 재고현황 상세 팝업
* 프로그램 ID : 
* 담당자 :  한승준
* 착수일 : 2015-12-03
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<% 
	String st_group_type = CommonUtil.nvl((String) request.getParameter("st_group_type"),"");
	String st_dept = CommonUtil.nvl((String) request.getParameter("st_dept"),"");
	String st_long_term_type = CommonUtil.nvl((String) request.getParameter("st_long_term_type"),"");
	String st_center_code = "";
	String st_item_code = "";
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
<script src="/resources/js/common.js"></script>
 
</head>

<script type="text/javascript">
// <!--
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
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');

	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(4);
	
	$("#st_group_type").val('<%=st_group_type %>');
	$("#st_dept").val('<%=st_dept%>');
	$("#st_long_term_type").val('<%=st_long_term_type %>');
}

//기능함수
function doAction(str) {
	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpst/getMasterMpStLongTermStckDetailPopList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
	}
}

//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	
	return DATA;
}
	
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	
	if(!checkedSession(stCode)){
		return;
		}	

	if (msg != ""){
		alert(msg);
	}
}

//트랜젝션(저장,삽입등) 후처리
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

 //-->
</script> 
<body onload="kep_onload_view();doAction('search');">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:550px;">
    	<div id="popHeader">
        	<h1 class="title">재고현황 상세 팝업</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <form name="searchCondition" id="searchCondition" method=post >
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="pageflag" name="pageflag" value="1">
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
				<input type="hidden" id="st_center_code" name="st_center_code"  value="">
				<input type="hidden" id="st_item_code" name="st_item_code"  value="">
	            <!--조회영역-->
	            <div id="cont_searchA">
	            	<table class="cont_t_list01" style="width:100%">
						<caption>재고현황 상세 팝업</caption>
						<colgroup>
							<col width="90px" />
							<col width="25%" />
							<col width="90px" />
							<col width="25%" />
							<col width="90px" />
	                        <col width="25%" />
						</colgroup>
						<tbody>
							<tr>
								<th>사업팀</th>
								<td>
									<select id="st_dept" name="st_dept" style="width:50%;height:20px" disabled></select>
								</td>
								<th>그룹유형</th>
								<td>
									<select id="st_group_type" name="st_group_type" style="width:120px;" disabled>
										<option value="ALL">전체</option>
										<option value="A">불변</option>
										<option value="B">가변</option>
									</select>
								</td>
								<th>재고구분</th>
								<td>
									<select id="st_long_term_type" name="st_long_term_type" style="width:120px;" disabled>
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
            </form>
            
           	<!--grid-->
            <div>
            	<div class="ib_product" style="border-top:2px solid #3c639c">
	  				<script type="text/javascript">
	  					createIBSheet("mySheet", "100%", "380px");
	  				</script>
	  			</div>
	  			<p class="paging" id="pageindex"></p>
        	</div>
        	<b>-불변 그룹 : 체류 경과기간에 관계없이 판매 가능한 제품 그룹</b>
			<br>
			<b>-가변 그룹 : 체류 기간에 따라 품질이상이 발생할 수 있는 제품 그룹</b>
    	</div>
	</div>
</body>
</html>
