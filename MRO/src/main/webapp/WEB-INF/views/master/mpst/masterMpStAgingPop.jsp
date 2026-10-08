<%--
**********************************************
* 메뉴 : 
* 화면 : 재고에이징 상세팝업
* 기능 : 선택된 상품에 대한 입고, 재고경과수량에 대해서 2년치 데이터를 조회한다.
* 프로그램 ID : 
* 담당자 : 최진수 ( 요청 : 황태호 과장 )
* 착수일 : 2015-12-18
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
String st_site		= CommonUtil.nvl(request.getParameter("st_site"), "");
String st_yyyymm	= CommonUtil.nvl(request.getParameter("st_yyyymm"), "");
String st_item_no	= CommonUtil.nvl(request.getParameter("st_item_no"), "");

@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 

Map<String,String> rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	rowData = _dataList.get(0);
}
%>

<script type="text/javascript">
<!--
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var g_doc_type = ""; // doc_Type

var pre_process_type = new Array();
var process_source  = new Array();

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
/*
	var productGbn = KepSheetComboData("M132","SEL");
    var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};
*/
    var initsheet = {};
	initsheet.Cols = [  
	    			{Align : "Center",	SaveName : "YYYYMM",	Header : "기준년월",		Type : "Text",	Width : 80,  EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",	SaveName : "GR",		Header : "입고수량",		Type : "Float",	Width : 150, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",	SaveName : "AGING",		Header : "재고경과수량",	Type : "Float",	Width : 150, EditLen : 110,	Edit : false, Hidden : false}
	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	<% if (_dataList!=null && _dataList.size() > 0) { %>
		doAction('search');
	<% }else{ %>
		alert("재고에이징 상세 정보가 없습니다.\n\n관리자에게 문의 하십시요.");
		this.close();
	<% }%>
}


var st;
var mt;
// 기능함수
function doAction(str, flag) {
	
	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpst/getMasterMpStAgingPopupDT.do" , pagingMode );
		break;
		
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	return;
}

//그리드 셀 편집한 직후에 이벤트
function mySheet_OnAfterEdit(Row, Col) {
	var column = mySheet.ColSaveName(Col);
	grbRow = Row; //현재 Row를 전역변수에 셋팅
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg.msg != "") {
		alert(msg.msg);
	}	
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "delImage"){
		alert("이미지가 삭제되었습니다.");
		location.reload();
		return;
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	if(pMethod == "delImage"){
		alert("이미지 삭제 중 오류가 발생하였습니다.");
		return;
	}
} 

//그리드 셀 변경시 이벤트
function mySheet_OnChange(Row, Col, Value) {
	var column = mySheet.ColSaveName(Col);
	grbRow = Row; //현재 Row를 전역변수에 셋팅
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	


	if (msg != "") {
		alert(msg);
	}
}

 //-->
</script> 
<body onload="kep_onload_view();" onunload="winClose();">
<iframe name="account_work" id="account_work" style="display:none;" scrolling="no" frameborder="0" width="100%" height="100%"></iframe>
<form name="searchCondition" id="searchCondition" method=post  modelAttribute="uploadForm" enctype="multipart/form-data">
	<!--HIDDEN-->
	<!-- 공통 -->
	<input type="hidden" name="s_SAVENAME">
	<!-- input type="hidden" id="pageflag" name="pageflag" value="1" -->
	<input type="hidden" id="st_site" name="st_site" value="<%=st_site%>">	
	<input type="hidden" id="st_yyyymm" name="st_yyyymm" value="<%=st_yyyymm%>">	
	<input type="hidden" id="st_item_no" name="st_item_no" value="<%=st_item_no%>">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:650px;">
    	<div id="popHeader">
        	<h1 class="title">재고에이징 상세내역</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
		<div id="popContainer">
			<div id="ContArea" style="width:400px;margin-left:0;" >
			
			<% if (rowData != null) {  %>
        	<!--데이타그리드-->
        	<table class="cont_t_list06">
            	<caption>리스트</caption>
                <colgroup>
                    <col width="25px" />
                    <col width="25%" />
                    <col width="25px" />
                    <col width="25%" />
                </colgroup>
                <tbody>
                    <tr>
                      <th>사이트</th>
                      <td><%=rowData.get("SITE_NAME") %></td>
                      <th>상품코드</th>
                      <td><%=rowData.get("ITEM_NO") %></td>
                    </tr>
                    <tr>
                      <th>재고수량</th>
                      <td><%=rowData.get("STOCK_QTY") %></td>
                      <th>재고금액</th>
                      <td><%=rowData.get("STOCK_AMT") %></td>
                    </tr>
                </tbody>
            </table>
        	<% }%>
        	</div>
        	<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "500px");
  				</script>
  			</div>
    	</div>
	</div>
</form> 
</body>
</html>
