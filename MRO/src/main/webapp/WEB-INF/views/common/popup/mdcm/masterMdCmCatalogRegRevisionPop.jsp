<%--
**********************************************
* 메뉴 : 
* 화면 : 카탈로그 등록 차수 팝업
* 기능 : 
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<%
String st_ca_req_no = CommonUtil.nvl((String) request.getParameter("st_ca_req_no"),"");  //  (조회조건)  
String st_ca_req_seq = CommonUtil.nvl((String) request.getParameter("st_ca_req_seq"),"");  //  (조회조건)  
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
	
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.HeaderMode = {Sort : 0};
	initsheet.Cols = [  
		 { Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Type:"Status",		Header:"상태",			SaveName:"sStatus",	Hidden : true}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED",	Hidden:true}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Type:"Text",		Header:"요청번호",			SaveName:"CA_REQ_NO",	Hidden:true}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Type:"Text",		Header:"요청순번",			SaveName:"CA_REQ_SEQ",	Hidden:true}
		,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Type:"Text",		Header:"차수",			SaveName:"CA_REQ_REVISION"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Type:"Text",		Header:"매출단가",			SaveName:"UNIT_PRICE"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Type:"Text",		Header:"매입단가",			SaveName:"LIST_PRICE"}
		,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Type:"Text",		Header:"SM담당자",		SaveName:"SO_SEND_USER_NAME"}
		,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Type:"Text",		Header:"판가담당자",		SaveName:"RSO_REQ_USER_NAME"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",		Header:"소싱제출일",		SaveName:"SO_SEND_DATE"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",		Header:"재소싱요청일",		SaveName:"RSO_REQ_DATE"}
		,{ Align:"Left",	Width:210,	Edit:false,	EditLen:100,	Type:"Text",		Header:"재소싱요청사유",	SaveName:"RSO_REQ_NOTE"}
		];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmCatalogRegRevisionPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmCatalogRegRevisionPop.do" , pagingMode );
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

   	if(mySheet.RowCount() <= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}
function mySheet_OnSaveEnd(code, msg) {
	loader_obj("N");
	if (msg != "") {
		alert(msg);
		doAction("search");
	}
}
//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmCatalogRegRevisionPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;

	return;
}

</script>
<title>코리아 e 플랫폼</title>
</head>

<body onload="kep_onload_view();">
<!--조회영역-->
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">	
	<input type="hidden" id="st_ca_req_no"  name="st_ca_req_no" value="<%=st_ca_req_no%>">
	<input type="hidden" id="st_ca_req_seq"  name="st_ca_req_seq" value="<%=st_ca_req_seq%>">	
	<!-- 500*350 -->
	<div id="popWrapper" style="height:348px;">
    	<div id="popHeader">
        	<h1 class="title">카탈로그 등록 차수</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
		<!--팝업내용입니다-->
        <div id="popContainer">
        	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "280px");
				</script>
			</div>
			<div id="pageindex"></div>
		</div>
    </div>
					
	</form>
		
</body>
</html>
