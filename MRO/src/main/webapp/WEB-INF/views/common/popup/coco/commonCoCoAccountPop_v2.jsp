<%--
**********************************************
* 메뉴 : 계정 팝업
* 화면 : 계정 팝업
* 기능 : 
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-05-11
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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  //  (조회조건)
String st_account_name = CommonUtil.nvl((String) request.getParameter("st_account_name"),"");  //  (조회조건)
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건) 
String st_tab_id = CommonUtil.nvl((String) request.getParameter("st_tab_id"),"");  //  (조회조건) 
%>

<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			{ Align:"Center",	SaveName:"CODE",		Header:"<%=CommonLang.get("HTITLE386") %>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*계정코드*/
			,{ Align:"Left",	SaveName:"TEXT1",			Header:"<%=CommonLang.get("HTITLE267") %>",				Type:"Text",		Width:250,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*계정명*/
	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
	
	mySheet.SetTheme("DB", "DeepBlue");
	
	doAction('search');
}
function doAction(str) {
	switch (str) {
		case "search":	 // 조회
			kepSearch(document.commonCoCoAccountPop, mySheet, "/coco/getCommonCoCoAccountPop_v2.do" , pagingMode);
			break;
		case "reload": //초기화
			kepReload_v2('commonCoCoAccountPop');
			mySheet.RemoveAll();
			break;
	}
}
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	

}
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	var value1 = mySheet.GetCellValue(Row,"CODE");
	var value2 = mySheet.GetCellValue(Row,"TEXT1");
	
	if(column == "TEXT1" || column == "CODE"){
		var tab_id = "<%=st_tab_id%>";
		if(tab_id == ""){
			opener.setPopupReturn(value1,value2);
		}else{
			opener.tabs[tab_id]["setPopupReturn"](value1,value2);
		}
		this.close();
	}
}

 //-->
</script> 
<body onload="kep_onload_view();">
<form name="commonCoCoAccountPop" id="commonCoCoAccountPop" method=post >
<input type="hidden" name="st_com_code" id="st_com_code"  value="<%=st_com_code%>">
<input type="hidden" name="s_SAVENAME" />
<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE1271") %><!-- 계정 리스트 --><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <table class="PopupSearchTable mt10" width="100%">
    <colgroup>
      <col width="90px" />
      <col width="*" /> 
	</colgroup>
	<tr>
      <th><%=CommonLang.get("HTITLE267") %><!-- 계정명 --></th>
      <td><div class="SearchPopupInput" style="width:325px;">
        <input type="text" name="st_account_name" id="st_account_name" value="" onKeyDown="kepEnter_v2()" style=" width:85%; ">
      	<input type=text name="tem_input_h" id="tem_input_h" style="display: none;" />
      </div>     </td>
    </tr>
  </table>
  		<div class="PopupListBtnBox_Center mt15">
			<button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:doAction('search'); return false;"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
  			<button class="ButOutline_Medium" style="width:120px" onclick="javascript:doAction('reload'); return false;"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
  		</div>
  		<div class="h15"></div>
  		<div style="height:270px; width: 450px;">
        	<script type="text/javascript">
				createIBSheet("mySheet", "100%", "100%");
			</script>
		</div>
</div><!-- warp 끝-->
</form> 
</body>
</html>
