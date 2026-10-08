<%--
**********************************************
* 메뉴 : 주문진행상세 > 이슈내역 팝업
* 화면 : 이슈 내역 팝업
* 기능 : 
*****************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>

<!doctype html>
<html>
<head>
<!-- <script src="/resources/js/common.js"></script> -->
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
</head>
<%

String st_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");
String st_po_seq = CommonUtil.nvl((String) request.getParameter("st_po_seq"),"");
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");

%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤


function kep_onload_view(){

	// mySheet1 업무처리 내역 목록
	var initsheet = {};
	initsheet.Cols = [ 
		 { Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Date",		Header:"이슈등록일",		SaveName:"ADD_DATE"}
		,{ Align:"Center",	Width:120,	Edit:true,	Hidden:false,	Type:"Text",		Header:"이슈상태",			SaveName:"TYPE_NAME"}
		,{ Align:"Left",	Width:440,	Edit:false,	Hidden:false,	Type:"Text",		Header:"내용",			SaveName:"KEP_REMARK"}
		,{ Align:"Center",	Width:50,	Edit:false,	Hidden:false,	Type:"Text",		Header:"작성자",			SaveName:"ADD_USER"}
		,{ Align:"Center",	Width:50,	Edit:false,	Hidden:false,	Type:"Text",		Header:"처리자",			SaveName:"CONFIRM_USER"}
		,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Date",		Header:"운영자처리일",		SaveName:"CONFIRM_DATE"}
		,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Date",		Header:"재확인일자",		SaveName:"NOTICE_DATE"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	kepSearchNoBar(document.searchCondition,  mySheet , "/coco/getMasterMpSoPoMngHistList.do" , pagingMode );
}

function mySheet_OnSearchEnd(code, msg) {
	loader_obj("N");

	if (msg != "") {
		alert(msg);
	}
	
}

</script> 
<body onload="kep_onload_view()">
	<form name="searchCondition" id="searchCondition" method="post">
		<input type="hidden" id="s_SAVENAME" name="s_SAVENAME" value="">
		<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=st_buyer%>"> 
		<input type="hidden" id="st_po_no"  name="st_po_no" value="<%=st_po_no%>"> 
		<input type="hidden" id="st_po_seq"  name="st_po_seq" value="<%=st_po_seq%>">
	</form>
	 
	<div id="popWrapper" >
		<div id="popHeader">
		   	<h1 class="title">이슈 내역</h1>
		    <p class="popClose"><a href="javascript:self.close()">
 			    <img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
		    </a></p>
		</div>
        <!--팝업내용입니다-->
        <div id="popContainer" >
			<div style="border-top:2px solid #3c639c; left:0;">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "100px");
  				</script>
			</div>
        </div>
	</div>
</body>
</html>
