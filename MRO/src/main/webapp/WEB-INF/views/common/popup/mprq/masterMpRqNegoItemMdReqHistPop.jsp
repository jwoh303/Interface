<%--
**********************************************
* 메뉴 : 
* 화면 : 네고정비 이력 팝업
* 기능 : 
* 프로그램 ID : 
* 담당자 : HSJ
* 착수일 : 2024-04-26
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
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)  
String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");  //  (조회조건)  
String st_quotation_seq = CommonUtil.nvl((String) request.getParameter("st_quotation_seq"),"");  //  (조회조건)  
String st_revision = CommonUtil.nvl((String) request.getParameter("st_revision"),"");  //  (조회조건)  
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
	
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [  
		      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 50,	Hidden : 1}
		      			,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"차수",	SaveName:"ITEM_MD_REVISION", Sort:0}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",	SaveName:"ITEM_MD_REQ_USER_NM", Sort:0}
						,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청일시",	SaveName:"ITEM_MD_REQ_DATE", Sort:0}
						,{ Align:"Left",	Width:340,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청사유",	SaveName:"ITEM_MD_REQ_NOTE", Sort:0}
						,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"첨부",	SaveName:"ITEM_MD_REQ_IMAGE_KEY_IMG", Sort:0}
		    			,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"첨부",	SaveName:"ITEM_MD_REQ_IMAGE_KEY", Sort:0}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제출자",	SaveName:"ITEM_MD_USER_NM", Sort:0}
						,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제출일시",	SaveName:"ITEM_MD_DATE", Sort:0}
		];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqBuyerQuotationNegoItemMdreqHistPop.do" , pagingMode );
	
	mySheet.SetImageList(2, diskOff);
	mySheet.SetImageList(3, diskOn);
	setLinkCol(mySheet, "ITEM_MD_REQ_IMAGE_KEY_IMG"); //추가정비 첨부
}

var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqBuyerQuotationNegoItemMdreqHistPop.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
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

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqBuyerQuotationNegoItemMdreqHistPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;

	if(column == "ITEM_MD_REQ_IMAGE_KEY_IMG"){
		popupSel = "negoItemMdReqfileUpload";
		var type="RFQ";
		var viewType="R";
		var image_key=mySheet.GetCellValue(Row, "ITEM_MD_REQ_IMAGE_KEY");
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}
	
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
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">	
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=st_buyer%>">
	<input type="hidden" id="st_quotation_no"  name="st_quotation_no" value="<%=st_quotation_no%>">
	<input type="hidden" id="st_quotation_seq"  name="st_quotation_seq" value="<%=st_quotation_seq%>">	
	<input type="hidden" id="st_revision"  name="st_revision" value="<%=st_revision%>">
	<!-- 500*350 -->
	<div id="popWrapper" style="height:348px;">
    	<div id="popHeader">
        	<h1 class="title">네고정비 이력</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
		<!--팝업내용입니다-->
        <div id="popContainer">
        	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "220px");
				</script>
			</div>
			<div id="pageindex"></div>
		</div>
    </div>
</form>
</body>
</html>
