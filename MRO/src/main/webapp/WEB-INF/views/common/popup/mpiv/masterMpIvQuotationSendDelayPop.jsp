<%--
**********************************************
* 메뉴 : 
* 화면 : 견적제출지연건조회
* 기능 : 견적제출지연건조회
* 프로그램 ID : 
* 담당자 : 고영일 ( 설계 : 권우재 )
* 착수일 : 2014-09-29
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
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 

String st_buyer			= CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String st_item_group    = CommonUtil.nvl((String) request.getParameter("st_item_group"),"");
%>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var reasonOn = "/resources/images/icon.gif";
var reasonOff = "/resources/images/icon2.gif";
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [    
	    			{Align : "Center"	,SaveName : "BUYER_NAME",				Header : "고객사명",	Type : "Text",	Width : 150, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",	SaveName : "QUOTATION_NO",			Header : "견적번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",	SaveName : "SOURCING_STATUS",		Header : "견적상태",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",	SaveName : "BUYER_ITEM_NO",			Header : "품목코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",		SaveName : "DESCRIPTION",				Header : "품목명",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",		SaveName : "SPECIFICATION",			Header : "규격",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",	SaveName : "MAKER_NAME",				Header : "제조사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",	SaveName : "ORIGIN_NAME",				Header : "원산지",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",	SaveName : "UNIT_MEASURE",			Header : "단위",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",	SaveName : "ITEM_QTY",					Header : "수량",	Type : "Float",  Format:"${qtyFormat}",	Width : 70, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",	SaveName : "BTOA_DATE",				Header : "견적의뢰일",	Type : "Date",	Width : 100, EditLen : 110,	Edit : false, Hidden : false}, 
	    			{Align : "Center",	SaveName : "BTOA_END_DATE",			Header : "회신요청일",	Type : "Date",	Width : 100, EditLen : 110,	Edit : false, Hidden : false}, 
	    			{Align : "Center",	SaveName : "BTOA_USER_NAME",		Header : "요청자",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},  
	    			{Align : "Center",	SaveName : "BTOA_USER_TEL",			Header : "연락처",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false} ,
	    			{Align : "Center",	SaveName : "KEP_USER_NAME",			Header : "KeP담당자",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false}, 
	    			{Align : "Center",	SaveName : "ATOS_END_DATE",			Header : "고객사마감일",	Type : "Date",	Width : 100, EditLen : 110,	Edit : false, Hidden : false}, 
	    			{Align : "Center",	SaveName : "DELAY_DAY",				Header : "지연일수",	Type : "Int",	Width : 60, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "DELAY_REASON_IMG",	Header : "지연사유",	Type : "Image",	Width : 60,	EditLen : 110,	Edit : false},
	    			
	    			{Align : "Center",	SaveName : "BUYER",						Header : "고객사코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true} ,
	    			{Align : "Center",	SaveName : "REVISION",					Header : "REVISION",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true} ,
	    			{Align : "Center",	SaveName : "QUOTATION_SEQ",			Header : "견전순서",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true} ,
	    			{Align : "Center",	SaveName : "DELAY_REASON_CODE",			Header : "DELAY_REASON_CODE",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",	SaveName : "DELAY_RESION_NOTE",			Header : "DELAY_RESION_NOTE",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",	SaveName : "DELAY_SEND_MAIL_FLAG",			Header : "DELAY_SEND_MAIL_FLAG",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true}
	];
	
	initsheet.Cfg = {FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "DELAY_REASON_IMG");		// 사유변경
	mySheet.SetImageList(1, reasonOn);
	mySheet.SetImageList(0, reasonOff);
	doAction("search");
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mpiv/getMasterMpIvQuotationSendDelayPopList.do" , pagingMode );
			break;
		case "reload":
			searchCondition.reset();
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
	kepSearch(document.searchCondition ,  mySheet , "/mpiv/getMasterMpIvQuotationSendDelayPopList.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());

	if (column == "DELAY_REASON_IMG" ){
		var st_buyer = mySheet.GetCellValue(Row,"BUYER");
		var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
		var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
		var st_revision = mySheet.GetCellValue(Row,"REVISION");
		var st_mail_flag =  mySheet.GetCellValue(Row,"DELAY_SEND_MAIL_FLAG");
		var st_modify = "";
		if(st_mail_flag=="Y"){
			st_modify = "N";
		}else{
			st_modify = "Y";
		}
		openSearchPopup('/mpiv/getMasterMpIvQuotationSendDelayReasonPop.jsp.do','?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_modify='+st_modify,'550,350,no');
		return;
	}
	
	return;
}
 
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="50">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=st_buyer%>">
	<input type="hidden" id="st_item_group"  name="st_item_group" value="<%=st_item_group%>">
	
	<div id="popWrapper" style="height:510px;">
    	<div id="popHeader">
        	<h1 class="title">제출지연건</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "300px");
				</script>
			</div>
			<div id="pageindex"></div>
		</div>	
  
    </div>
</form> 
</body>
</html>
