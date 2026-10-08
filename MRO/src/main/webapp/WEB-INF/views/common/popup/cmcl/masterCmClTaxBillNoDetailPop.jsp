<%--
**********************************************
* 메뉴 : 마감관리 > 매출세금계산서 > 발행/등록
* 화면 : 매출세금계산서 발행/등록
* 기능 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ page import="java.text.SimpleDateFormat"%> 
<%@ page import="java.util.Date"%> 
<%@ page import="java.util.Locale"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>

<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("_data"); // 조회된 결과 
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_user_id = "";
if (sessionInfo != null){
	st_user_id = sessionInfo.getUserId();
}
String st_tax_bill_no = request.getParameter("st_tax_bill_no");
String st_buyer = request.getParameter("st_buyer");
String st_site_type = request.getParameter("st_site_type");

%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [					 
			 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus"}			
			,{ Align:"Left",	Width:170,	Edit:false,	EditLen:170,	Hidden:true,	Type:"Text",		Header:"고객사코드",	SaveName:"BUYER"}
			,{ Align:"Left",	Width:170,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"고객사",		SaveName:"BUYER_NAME"}
			,{ Align:"Center",	Width:80,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"발주번호",		SaveName:"PO_NO"}
			,{ Align:"Center",	Width:70,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"발주항번",		SaveName:"PO_SEQ"}
			,{ Align:"Center",	Width:80,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"입고번호",		SaveName:"GR_NO"}
			,{ Align:"Center",	Width:70,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"입고항번",		SaveName:"GR_SEQ"}
			,{ Align:"Left",	Width:170,	Edit:false,	EditLen:170,	Hidden:true,	Type:"Text",		Header:"협력사코드",	SaveName:"AGENT"}
			,{ Align:"Left",	Width:170,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"협력사",		SaveName:"AGENT_NAME"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"품목코드",		SaveName:"BUYER_ITEM_NO"}
			,{ Align:"Left",	Width:170,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"품명",		SaveName:"DESCRIPTION"}
			,{ Align:"Left",	Width:170,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"규격",		SaveName:"SPECIFICATION"}
			,{ Align:"Right",	Width:80,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Float",		Header:"단가",		SaveName:"UNIT_PRICE"}
			,{ Align:"Right",	Width:60,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Float",		Header:"입고수량",		SaveName:"GR_QTY"}
			,{ Align:"Right",	Width:90,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Float",		Header:"입고금액",		SaveName:"ITEM_AMT"}
			,{ Align:"Center",	Width:80,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"I/F발주번호",	SaveName:"LEGACY_PO_NO"}
			,{ Align:"Center",	Width:70,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"I/F발주항번",	SaveName:"LEGACY_PO_SEQ"}
			,{ Align:"Center",	Width:80,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"I/F입고번호",	SaveName:"LEGACY_GR_NO"}
			,{ Align:"Center",	Width:70,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"I/F입고항번",	SaveName:"LEGACY_GR_SEQ"}
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"플랜트",		SaveName:"PLANT"}				
					
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	mySheet.SetCountPosition(4);
	kepSearch(document.searchCondition, mySheet, "/cmcl/getMasterCmClTaxBillNoDetailPop.do", pagingMode );
	
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	

	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/cmcl/getMasterCmClTaxBillNoDetailPop.do" , pagingMode );
			break;
		case "print":	 // 뷰어
			var params =  "["+"<%=st_tax_bill_no%>"+"]["+"<%=st_site_type%>"+"]";
			doPop("offPrint", params);
			break;			
			
	}
}


//팝업함수호출
function doPop(str, params) {
	popupSel = str;

	switch (str) {
		case "offPrint": // 고객사
			var rpt_url = "RD_10_M_001_00";
			openTranStatReportOpen(rpt_url, params, 1);
			break;
			
		
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}


function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
}
function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}


</script>
</head>
<body onload="kep_onload_view()">
<form name = "searchCondition" method = "post" onsubmit="return false" >
<input type="hidden" name="s_SAVENAME">
<input type="hidden" id="st_tax_bill_no" name="st_tax_bill_no" value="<%=st_tax_bill_no%>">
<input type="hidden" id="st_buyer" name="st_buyer" value="<%=st_buyer%>">
<input type="hidden" id="st_site_type" name="st_site_type" value="<%=st_site_type%>">
	<div id="popWrapper" style="height:250px;">
    	<div id="popHeader">
        	<h1 class="title">세금계산서 조회 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"> 
            <!--조회영역-->
            <div id="cont_searchA" class="mt10">
            	<b>세금계산서 번호 : <%=st_tax_bill_no %></b>
            </div>
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "450px");
				</script>
			</div>      
          <!--버튼영역-->
        <div class="btnArea">
			<span class="fr">
				<span class="btn_02"><a href="javascript:doAction('print')">출력</a></span>
			</span>
       </div>
    </div>        
</div>   
</form>              
</body>
</html>
