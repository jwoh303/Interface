<%--
**********************************************
* 메뉴 : 운영사 > 회원사관리> 재계약 신규고객 현황(전체/개인) > 고객사 상세 팝업
* 화면 : 고객사 상세 팝업
* 기능 : 
* 프로그램 ID :
* 담당자 : HSJ
* 생성일 : 2023-12-22
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
	String st_process_status = CommonUtil.nvl((String) request.getParameter("st_process_status"), ""); //
	String st_contract_type = CommonUtil.nvl((String) request.getParameter("st_contract_type"), ""); //
	String st_contract_kind = CommonUtil.nvl((String) request.getParameter("st_contract_kind"), ""); //
	String st_team_code = CommonUtil.nvl((String) request.getParameter("st_team_code"), ""); //
	String st_main_clerk = CommonUtil.nvl((String) request.getParameter("st_main_clerk"), ""); //
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>

<script>
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
	var popupSel = "";
	var grbRow;
	
	//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function initPage() {
		var initsheet = {};
		initsheet.Cols = [  
		      			{Align : "Center",	SaveName : "sStatus",		Header : "상태",		Type : "Status",		Width : 50,		Hidden : true}, 
		    			{Align : "Center",	SaveName : "SELECTED",		Header : "",		Type : "DummyCheck",	Width : 50,		Hidden : true}, 
		    			{Align : "Center",	SaveName : "ORG_CODE",		Header : "사업장코드",	Type : "Text",			Width : 90,		Hidden : false,	Edit:false},
		    			{Align : "Left",	SaveName : "ORG_NAME",		Header : "사업장명",	Type : "Text",			Width : 150,	Hidden : false,	Edit:false},
		    			{Align : "Center",	SaveName : "BUYER",			Header : "고객사코드",	Type : "Text",			Width : 90,		Hidden : false,	Edit:false},
		    			{Align : "Left",	SaveName : "BUYER_NAME",	Header : "고객사명",	Type : "Text",			Width : 200,	Hidden : false,	Edit:false},
		    			{Align : "Center",	SaveName : "TEAM_CODE",		Header : "담당팀코드",	Type : "Text",			Width : 90,		Hidden : true,	Edit:false},
		    			{Align : "Center",	SaveName : "TEAM_NAME",		Header : "담당팀",	Type : "Text",			Width : 120,	Hidden : false,	Edit:false},
		    			{Align : "Center",	SaveName : "KEP_USER_ID",	Header : "영업담당자",	Type : "Text",			Width : 90,		Hidden : true,	Edit:false},
		    			{Align : "Center",	SaveName : "MAIN_CLERK",	Header : "영업담당자",	Type : "Text",			Width : 90,		Hidden : false,	Edit:false}
		];
		
		IBS_InitSheet(mySheet, initsheet,pagingMode);

		kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdCtNewReBuyerDetailPop.do" , pagingMode );
	}
	
	var st;
	var mt;
	//기능함수
	function doAction(str) {
		st = new Date();
		switch (str) {
			case "search": //조회
				current_page = -1;
				kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdCtNewReBuyerDetailPop.do" , pagingMode );
				break;
			case "reload":
				kepReload('searchCondition');
				break;
		}

	}
	function mySheet_OnLoadData(DATA) {
		mt = new Date();
		return DATA;
	}
	
	function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

    	
    	
		if (msg != "") {
			alert(msg);
		}

		if(current_page==-1){
			makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		}else{
			makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
		}
		
	}
	
	//페이지 인덱스 눌렀을 경우 조회
	function pageSearch(param){
		//조회
		current_page = param.page;
		kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdCtNewReBuyerDetailPop.do?page="+current_page , pagingMode );
	}

	//그리드 셀클릭 이벤트
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if ( Row  < 1) return;
		var column = mySheet.ColSaveName(mySheet.GetSelectCol());
		
		grbRow = Row;
	}
</script>
<title>코리아 e 플랫폼</title>
</head>

<body onload="initPage();">
<!--조회영역-->
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="500">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_process_status"  name="st_process_status" value="<%=st_process_status%>">
	<input type="hidden" id="st_contract_type"  name="st_contract_type" value="<%=st_contract_type%>">
	<input type="hidden" id="st_contract_kind"  name="st_contract_kind" value="<%=st_contract_kind%>">
	<input type="hidden" id="st_team_code"  name="st_team_code" value="<%=st_team_code%>">
	<input type="hidden" id="st_main_clerk"  name="st_main_clerk" value="<%=st_main_clerk%>">

	<div id="popWrapper" style="height:350px;">
    	<div id="popHeader">
        	<h1 class="title">고객사 상세 정보</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
		<!--팝업내용입니다-->
        <div id="popContainer">
        	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "350px");
				</script>
			</div>
			<div id="pageindex"></div>
			
			<!--버튼영역-->
	        <div class="btnArea mr25">
				<span class="fl text11 ml20">
					※ 담당자 및 회원사 정보가 정확하지 않는 경우, 명칭이 표시되지 않습니다.
				</span>
	        </div>
		</div>
		
    </div>
	</form>
</body>
</html>
