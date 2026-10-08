<%--
**********************************************
* 메뉴 : 회원사관리 > 여신한도관리 > 여신한도조회(사업팀) > 채권잔액
* 화면 : 미마감 발주상세
* 기능 : 미마감 발주상세
* 프로그램 ID : 
* 담당자 :  한승준
* 착수일 : 2015-11-26
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<% 
//	SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String st_irs_no = CommonUtil.nvl((String) request.getParameter("st_irs_no"),"");
	String st_kep_dept = CommonUtil.nvl((String) request.getParameter("st_dept_cd"),"");
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
						{ Align:"Center",	Width:90,	Edit:false,	EditLen:90,		Hidden:false,	Type:"Text",		Header:"사업자번호",	SaveName:"IRS_NO"}
						,{ Align:"left",		Width:180,	Edit:false,	EditLen:180,	Hidden:false,	Type:"Text",		Header:"사업장명",		SaveName:"IRS_NM"}
						,{ Align:"Center",	Width:90,	Edit:false,	EditLen:90,		Hidden:false,	Type:"Text",		Header:"사업팀",		SaveName:"DEPT_NM"}
						,{ Align:"Center",	Width:90,	Edit:false,	EditLen:90,		Hidden:false,	Type:"Text",		Header:"사업자번호(회계)",	SaveName:"ACCOUNT_IRS_NO"}
						,{ Align:"left",	Width:180,	Edit:false,	EditLen:180,		Hidden:false,	Type:"Text",		Header:"사업장명(회계)",	SaveName:"ACCOUNT_IRS_NM"}
						,{ Align:"Center",	Width:90,	Edit:false,	EditLen:90,		Hidden:false,	Type:"Text",		Header:"사업팀(회계)",		SaveName:"ACCOUNT_DEPT_NM"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:true,	Type:"Text",		Header:"사업팀코드(회계)",		SaveName:"ACCOUNT_DEPT"}
						,{ Align:"right",	Width:90,	Edit:false,	EditLen:90,		Hidden:false,	Type:"Float",	Header:"채권잔액",		SaveName:"BOND_BALANCE"}
						,{ Align:"right",	Width:90,	Edit:false,	EditLen:90,		Hidden:false,	Type:"Float",	Header:"어음잔액",	SaveName:"BILL_BALANCE"}
						,{ Align:"right",	Width:90,	Edit:false,	EditLen:90,		Hidden:false,	Type:"Float",	Header:"선수금",			SaveName:"P_RECV_AMT"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');

	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(4);

}

//기능함수
function doAction(str) {


	switch (str) {
		case "search":	 // 조회
			current_page = -1;

			kepSearch(document.searchCondition,  mySheet , "/mdct/getMasterMdCtCreditInfoPop.do" , pagingMode );
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
        	<h1 class="title">사업자별 잔액 상세</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
            <form name="searchCondition" id="searchCondition" method=post >
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="pageflag" name="pageflag" value="1">
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_irs_no" name="st_irs_no"  value="<%=st_irs_no%>">
				<input type="hidden" id="st_dept" name="st_dept"  value="<%=st_kep_dept%>">
            </form>
            <br/>
            
           	<!--grid-->
            <div>
            	<div class="ib_product" style="border-top:2px solid #3c639c">
	  				<script type="text/javascript">
	  					createIBSheet("mySheet", "99%", "300px");
	  				</script>
	  			</div>
	  			<p class="paging" id="pageindex"></p>
        	</div>
    	</div>
	</div>
</body>
</html>
