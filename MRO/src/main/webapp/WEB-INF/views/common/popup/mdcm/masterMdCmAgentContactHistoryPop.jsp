<%--
**********************************************
* 메뉴 : 회원사관리>협력사관리>협력사 연락처관리>이력관리
* 화면 : 이력관리
* 기능 : 
* 프로그램 ID : 
* 담당자 : 임태성
* 착수일 : 2024-03-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<% 
	String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");//(st_com_code)
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
 
</head>
<style type="text/css">
<!--
	h2 { 
		width: 500px;
		font-family: "맑은 고딕";
		font-weight: bold;
		font-size: 18px;
		color: #333333;
		text-align: left;
		letter-spacing: -1px;
		margin-bottom: 10px; 
	}
	.cont_t_list02 td,th{
		border: 1px solid #cdcdcd;
	}
-->
</style>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
					{ Align:"Center",	Width:50,	Edit:false,					Hidden:false,	Type:"Text",	Header:"상태|상태",		SaveName:"STATUS"}
					,{ Align:"Center",	Width:170,	Edit:false,					Hidden:false,	Type:"Text",	Header:"이메일|변경전",		SaveName:"RE_EMAIL"}
					,{ Align:"Center",	Width:170,	Edit:false,					Hidden:false,	Type:"Text",	Header:"이메일|변경후",		SaveName:"CH_EMAIL"}
					,{ Align:"Center",	Width:100,	Edit:false,					Hidden:false,	Type:"Text",	Header:"모바일|변경전",		SaveName:"RE_MOBILE"}
					,{ Align:"Center",	Width:100,	Edit:false,					Hidden:false,	Type:"Text",	Header:"모바일|변경후",		SaveName:"CH_MOBILE"}
					,{ Align:"Center",	Width:80,	Edit:false,					Hidden:false,	Type:"Text",	Header:"사용자명|변경전",	SaveName:"RE_NAME"}
					,{ Align:"Center",	Width:80,	Edit:false,					Hidden:false,	Type:"Text",	Header:"사용자명|변경후",	SaveName:"CH_NAME"}
					,{ Align:"Center",	Width:160,	Edit:false,					Hidden:false,	Type:"Text",	Header:"비고|변경전",		SaveName:"RE_REMARK"}
					,{ Align:"Center",	Width:160,	Edit:false,					Hidden:false,	Type:"Text",	Header:"비고|변경후",		SaveName:"CH_REMARK"}
					,{ Align:"Center",	Width:50,	Edit:false,					Hidden:false,	Type:"Text",	Header:"수신설정|변경전",	SaveName:"RE_RECV_YN"}
					,{ Align:"Center",	Width:50,	Edit:false,					Hidden:false,	Type:"Text",	Header:"수신설정|변경후",	SaveName:"CH_RECV_YN"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"수정자|수정자",		SaveName:"CHANGE_USER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"수정일시|수정일시",	SaveName:"CHANGE_DATE"}
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4);
	doAction('search');
}
//기능함수
function doAction(str) {
	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			var st_com_code = $("#st_com_code").val();
			kepSearch(document.searchCondition, mySheet , "/mdcp/getMasterMdCpAegntContactHistoryList.do" ,"?st_com_code="+st_com_code);
			break;
	}
}

//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
}
</script> 
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:500px;">
		<div id="popHeader">
			<h1 class="title">이력관리</h1>
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
				<input type="hidden" id="st_user_id" name="st_user_id"value="${sessionInfo.userId}">
				<input type="hidden" name="st_com_code" id="st_com_code" value="<%=st_com_code%>">

				<!-- 수신 정보 -->
				<!--grid-->
				<div class="ib_product">
					<script type="text/javascript">
						createIBSheet("mySheet", "100%", "550px");
					</script>
				</div>
			</form>
		</div>
	</div>
</body>
</html>
