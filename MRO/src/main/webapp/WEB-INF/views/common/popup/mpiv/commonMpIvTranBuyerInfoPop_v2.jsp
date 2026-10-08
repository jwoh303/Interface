<%--
**********************************************
* 메뉴 : 
* 화면 : 담당자 찾기 고객사 팝업
* 기능 : 
* 프로그램 ID : 
* 담당자 :  최찬규
* 착수일 : 2025-10-22
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
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<%
	@SuppressWarnings (value="unchecked")
	
	String comCode = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  //  (조회조건)
	String buyerName = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");  //  (조회조건)
	String popup_flag = CommonUtil.nvl((String) request.getParameter("popup_flag"),"");  //  (조회조건)
%>

<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	$("#st_buyer_name").focus();
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			{ Align:"Left",	SaveName:"BUYER",				Header:"고객사코드",				Type:"Text",	Cursor:"Pointer",	Width:150,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"COM_NAME_LOC",		Header:"고객사명",				Type:"Text",		Cursor:"Pointer",Width:250,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"KEP_USER_NAME",		Header:"KeP담당자",			Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"KEP_USER_PHONE",		Header:"연락처",				Type:"Text",		Width:120,	Edit:false,	EditLen:100, 	Hidden:true}
			,{ Align:"Center",	SaveName:"KEP_USER_EMAIL",		Header:"이메일",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}							
			
	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet.SetTheme("DB", "DeepBlue");
	
}

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		alert(msg);
	}
}
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var buyer = mySheet.GetCellValue(Row,"BUYER");
	var com_name_loc = mySheet.GetCellValue(Row,"COM_NAME_LOC");
	var popup_flag = '<%=popup_flag%>';
	
	if(column == "BUYER" || column == "COM_NAME_LOC"){
		if(popup_flag == "1"){ //담당자찾기 팝업
// 			var src = "/common/agentInfoDisplayPop.do?st_com_code="+buyer; 
// 			openLayerPop(src,"825px","700px");
// 			openSearchPopup("/common/agentInfoDisplayPop.do", '?st_com_code='+buyer+"&st_popup_check=N", "825,700,no");
			openSearchPopup("/common/agentUserInfoDisplayPop_v2.do", '?st_com_code='+buyer+"&st_popup_check=N"+"&codeGubun=agentUserInfoDisplayPop_v2", "825,290,no");
		}else if(popup_flag == "2"){ //거래명세서 양식 고객사 검색 팝업
			var seller = "<%=_sessionInfo.getComCode()%>";
			var reportId = "";
			
			if(buyer == "KRDAEW0016"){
				reportId = "RD_06_S_003_13";
			} else if(buyer=="KRDONG0110" || buyer=="KRDONG0107" || buyer=="KRDONG0128" || buyer=="KRDONG0099" || buyer=="KRDONG0153") {
				reportId = "RD_06_S_003_14";
			} else if(buyer=="KRDONG0119") {
				reportId = "RD_06_S_003_15";
			} else if(buyer=="KRDOOS0046") {
				reportId = "RD_06_S_003_16";
			} else {
				reportId = "RD_06_S_001_90";
			} 
			if(buyer=="KRKORE0212" || buyer=="KRKEPB0004"){
				if(confirm("품질보증서 양식을 다운로드 하시겠습니까?")){
					document.location.href = "/resources/excel/work/INVOICE/sellerWarrantyForm.doc";
				}
			}
			reportOpen(reportId, "["+buyer+"]["+seller+"]");
		}
	}
	
	return;
}
//기능함수
function doAction(str) {

	switch (str) {
		case "search":	 // 조회
			kepSearch(document.commonMpIvTranBuyerChoicePop, mySheet, "/mpiv/getCommonMpIvTranBuyerChoicePopList.do" , pagingMode);
// 			$('#commonMpIvTranBuyerChoicePop').attr("action", "/mpiv/getCommonMpIvTranBuyerChoicePop.do").submit();
			break;
	
	}
}

function doPop(str, value1) {
	switch (str) {
		case "agent": // 고객사
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
			break;
	}
}

function setReturn(buyer, com_name){
	opener.setBuyerChoiceReturn(buyer, com_name);
	self.close();
}


</script> 
 
<body onload="kep_onload_view()">
<form name="commonMpIvTranBuyerChoicePop" id="commonMpIvTranBuyerChoicePop" method="post">
<input type="hidden" name="s_SAVENAME" />
	<input type="hidden" name="st_com_code" value="<%=comCode%>" />
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup">
  <div class="PopupTit">
  <%if(popup_flag.equals("1")){ %>
  	고객사별 담당자 찾기
  <%}else if(popup_flag.equals("2")){ %>
  	고객사 조회
  <%} %>
  <span></span></div>
  <div class="h15"></div>
<!--   <div class="Importance_Popup"  style="width:380px"><img src="/resources/imgs/Icon_Importance01.png" /> 거래중인 고객사를 확인하여 선택할 수 있습니다. </div> -->
  <div class="h10"  style="width:380px"></div> 
  <div class="SearchPopupInputBox"  style="width:400px">
    <div class="SearchPopupInput" onSubmit=" "  style="width:400px">
      <input type="text" placeholder="고객사명 " id="st_buyer_name" name="st_buyer_name" style=" width:95%; " onKeyDown="kepEnter_v2()">
      <button type="button" onclick="javascript:doAction('search'); return false;">고객사검색버튼</button>
    </div>    
  </div>
  <div class="PopTableThCTdL" style="width:405px; height: 300px;">
  	<script type="text/javascript">
		createIBSheet("mySheet", "100%", "100%");
	</script>
  </div>
  <!--div class="h30"></div-->
  <!--div class="PopupListBtnBox_Center">
    <button class="ButQuaternary_large" >취소</button>
    <button class="ButPrimary_large" >확인</button>
  </div-->  
</div><!-- warp 끝-->
 
</form> 
</body>
</html>
