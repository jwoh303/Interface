<%--
**********************************************
* 메뉴 : 부서 팝업
* 화면 : 부서 팝업
* 기능 : 부서 팝업
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-03-12
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), "");
String po_dept = CommonUtil.nvl((String) request.getParameter("po_dept"),"");  //  (조회조건)
String req_dept_name = CommonUtil.nvl((String) request.getParameter("req_dept_name"),"");  //  (조회조건)
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)

%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			{ Align:"Center",	SaveName:"CODE",		Header:"<%=CommonLang.get("HTITLE380") %>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*부서코드*/
			,{ Align:"Left",	SaveName:"TEXT1",			Header:"<%=CommonLang.get("HTITLE490") %>",				Type:"Text",		Width:270,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*요약 부서명*/
			,{ Align:"Left",	SaveName:"TEXT2",			Header:"<%=CommonLang.get("HTITLE491") %>",				Type:"Text",		Width:260,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*상세 부서명*/
	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
	
	mySheet.SetTheme("DB", "DeepBlue");
	
	doAction('search');
}

// 기능함수
function doAction(str) {
	

	switch (str) {
		case "search":	 // 조회
			kepSearch(document.commonCoCoOrderDepartmentSearchPop, mySheet, "/coco/getCommonCoCoOrderDepartmentSearchPop_v2.do" , pagingMode);
			break;
	}
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

}
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	var value1 = mySheet.GetCellValue(Row,"CODE");
	var value2 = mySheet.GetCellValue(Row,"TEXT1");
	if(column == "TEXT1" || column == "CODE" || column == "TEXT2"){
		opener.setPopupReturn(value1,value2);
		this.close();
	}
}
</script>

<body onload="kep_onload_view();">
	 <form name=commonCoCoOrderDepartmentSearchPop id=commonCoCoOrderDepartmentSearchPop method=post >
	 <input type="hidden" name="s_SAVENAME" />
	 <input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
		<input type=hidden name="po_dept" id="po_dept"  value="<%=po_dept%>">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE188") %><!-- 발주부서 --><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <table class="PopupSearchTable mt10" width="100%">
    <colgroup>
      <col width="90px" />
      <col width="*" /> 
	</colgroup>
	<tr>
      <th><%=CommonLang.get("HTITLE323") %><!-- 부서명 --></th>
      <td><div class="SearchPopupInput" style="width:570px;">
        <input type="text" name="req_dept_name" id="req_dept_name" value="" onKeyDown="kepEnter_v2()" style=" width:85%; ">
      </div>     </td>
    </tr>
  </table>
  <div class="PopupListBtnBox_Center mt15">
    <!--button class="ButOutline_Medium" style="width:120px" >초기화</button--> 
    <button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:doAction('search');return false;" ><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
  </div>
  <div class="h15"></div>
  	<div style="height:350px; width: 650px;">
        	<script type="text/javascript">
				createIBSheet("mySheet", "100%", "100%");
			</script>
		</div>
		<div style="margin-top: 15px;"><%=CommonLang.get("HTITLE492") %><!-- ※ 발주부서가 없는 경우 관리자에게 문의하여 등록 바랍니다. --></div>
</div><!-- warp 끝-->
</form> 
</body>
</html>
