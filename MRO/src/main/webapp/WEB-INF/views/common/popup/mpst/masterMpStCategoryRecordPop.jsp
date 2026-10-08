<%--
**********************************************
* 메뉴 : 통계>경영실적통계>SG실적>카테고리 실적조회 팝업
* 화면 : 카테고리 실적조회 팝업
* 기능 : SG내 카테고리 실적을 조회한다.
* 프로그램 ID : PG_90_C_600_10
* 담당자 : 홍석규 ( 설계 : 공통 )
* 착수일 : 2014-08-14
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>

<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
</head>
<%
String st_yyyy = CommonUtil.nvl((String) request.getParameter("st_yyyy"),"");  //  (조회조건)
String st_team_cd = CommonUtil.nvl((String) request.getParameter("st_team_cd"),"");  //  (조회조건)
String st_law_group_cd = CommonUtil.nvl((String) request.getParameter("st_law_group_cd"),"");  //  (조회조건)
String st_group_cd = CommonUtil.nvl((String) request.getParameter("st_group_cd"),"");  //  (조회조건)
String st_sg_cd = CommonUtil.nvl((String) request.getParameter("st_sg_cd"),"");  //  (조회조건)
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit:false,	EditLen:110,	Type:"Seq",	Header:"순번",	SaveName:"NO"}
					,{ Align:"Center",	Width:200,	Edit:false,	EditLen:100,	ColMerge:1, Type:"Text",	Header:"표준카테고리명",	SaveName:"SG_NM"}
					,{ Align:"Right",	Width:150,	Edit:false,	EditLen:17,	ColMerge:0, Type:"Float",	Format:"#,###",	Header:"매출",	SaveName:"SALES_AMT"}
					,{ Align:"Right",	Width:150,	Edit:false,	EditLen:17,	ColMerge:0, Type:"Float",	Format:"#,###",	Header:"매출이익",	SaveName:"SALES_PROFIT"}
					,{ Align:"Right",	Width:150,	Edit:false,	EditLen:17,	ColMerge:0, Type:"Text",	Header:"매익율",	SaveName:"SALES_PROFIT_RATE"}
	];
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	var cfg = {MergeSheet:msAll};
	mySheet.SetConfig(cfg);
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);	
	
	doAction('search');
}
	
	
// 기능함수
function doAction(str) {
	
	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpst/getMasterMpStCategoryRecordPopList.do" , pagingMode );
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
	if(!checkedSession(stCode)){return;}	

   	if(mySheet.RowCount() <= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}

	
}

</script>
<body onload="kep_onload_view();">
<!--조회영역-->
<form name = "searchCondition" method = "post">
	<!-- 공통 -->
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag" name="pageflag" value="1">
	<input type="hidden" id="st_yyyy" name="st_yyyy" value="<%=st_yyyy%>">
	<input type="hidden" id="st_team_cd" name="st_team_cd" value="<%=st_team_cd%>">
	<input type="hidden" id="st_law_group_cd" name="st_law_group_cd" value="<%=st_law_group_cd%>">
	<input type="hidden" id="st_group_cd" name="st_group_cd" value="<%=st_group_cd%>">
	<input type="hidden" id="st_sg_cd" name="st_sg_cd" value="<%=st_sg_cd%>">
</form>

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:760px;">
		<div id="popHeader">
        	<h1 class="title">카테고리 실적조회</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <div id="popContainer">
        	<div class="scrollArea" style="height:525px">
      	<!--grid-->
 			<div class="ib_product" style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "100%", "520px");
				</script>
			</div>
			</div>
		</div>
	</div>

<!--내용 종료-->	                 

</body>
</html>
