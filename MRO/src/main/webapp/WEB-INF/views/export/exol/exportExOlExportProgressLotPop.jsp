<%--
**********************************************
* 메뉴 : Lot 상세정보 팝업
* 화면 : Lot 상세정보 팝업
* 기능 : 
* 프로그램 ID :
* 담당자 : 한승준
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	String st_buyer = CommonUtil.nvl((String)request.getParameter("st_buyer"),"");
	String st_ci_no = CommonUtil.nvl((String)request.getParameter("st_ci_no"),"");
	String st_ci_seq = CommonUtil.nvl((String)request.getParameter("st_ci_seq"),"");
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Lot 상세정보 팝업</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	initsheet.Cols = [
		 {Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"C/I No",		SaveName:"CI_NO"}
		,{Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"C/I Seq",		SaveName:"CI_SEQ"}
		,{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
		,{Align:"Left",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품명",			SaveName:"DESCRIPTION"}
		,{Align:"Left",		Width:140,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"규격",			SaveName:"SPECIFICATION"}
		,{Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"단위",			SaveName:"UNIT_MEASURE"}
		,{Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"Lot No",		SaveName:"LOT_NO"}
		,{Align:"right",		Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"Lot QTY",	SaveName:"LOT_QTY"}
		,{Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"Prd Date",	SaveName:"PRD_DATE", Format:"Ymd"}
	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	kepSearch(document.searchCondition,  mySheet , "/exol/getExportExOlExportProgressLotList.do" , pagingMode );
}

var st;
var mt;

// 그리드 표시후 처리
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	if (msg != "") {
		alert(msg);
	}
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg);
	}
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	
	grbRow = Row;
	
	return;
}

</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="st_pkg_cmpy_no" name="st_pkg_cmpy_no"  value="${sessionInfo.comCode}">
	<input type="hidden" id="st_buyer" name="st_buyer"  value="<%=st_buyer%>">
	<input type="hidden" id="st_ci_no" name="st_ci_no"  value="<%=st_ci_no%>">
	<input type="hidden" id="st_ci_seq" name="st_ci_seq"  value="<%=st_ci_seq%>">
	<div id="popWrapper" style="height:250px;">
    	<div id="popHeader">
        	<h1 class="title">Lot 상세정보</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <div id="searchBtnA02"></div>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "200px");
				</script>
			</div>
		</div>	
    </div>
</form> 
</body>
</html>
