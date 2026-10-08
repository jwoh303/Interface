<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
String title = CommonUtil.nvl((String) request.getParameter("title"),"ICOMCOD2 리스트");
String type = CommonUtil.nvl((String) request.getParameter("type"),"");
String com_code = CommonUtil.nvl((String) request.getParameter("com_code"),"");
String st_tab_id = CommonUtil.nvl((String) request.getParameter("st_tab_id"),"");
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			{ Align:"Center",	SaveName:"CODE",		Header:"<%=CommonLang.get("HTITLE371") %>",				Type:"Text",		Width:130,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*코드*/
			,{ Align:"Left",	SaveName:"TEXT1",			Header:"<%=CommonLang.get("HTITLE314") %>1",				Type:"Text",		Width:310,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*구분1*/
			,{ Align:"Left",	SaveName:"TEXT2",			Header:"<%=CommonLang.get("HTITLE314") %>2",				Type:"Text",		Width:190,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*구분2*/
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
			kepSearch(document.geticomcod2Pop, mySheet, "/common/getIcomcod2List_v2.do" , pagingMode);
// 			$('#comCode2PopSearch').attr("action", "/common/commonList.do").submit();   
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
	var value3 = mySheet.GetCellValue(Row,"TEXT2");
	
	if(column == "TEXT1" || column == "CODE" || column == "TEXT2"){
		var tab_id = "<%=st_tab_id%>";
		if(tab_id == ""){
			opener.setPopupReturn(value1,value2,'');
		}else{
			opener.tabs[tab_id]["setPopupReturn"](value1,value2,'');
		}
		self.close();
	}
}

</script> 
<body onload="kep_onload_view();">
	 <form name=geticomcod2Pop id=geticomcod2Pop method=post >
	 <input type="hidden" name="s_SAVENAME" />
	 <input type="hidden" name="codeGubun" id="codeGubun" value="geticomcod2Pop"> 
	 <input type="hidden" name="type" id="type" value="<%=type%>">
	 <input type="hidden" name="title" id="title" value="<%=title%>">
	 <input type="hidden" name="com_code" id="com_code" value="<%=com_code%>"> 

	<div class="wrapPopup"  >
  <div class="PopupTit"><%=title %><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <table class="PopupSearchTable mt10" width="100%">
    <colgroup>
      <col width="90px" />
      <col width="*" /> 
	</colgroup>
	<tr>
      <th><%=CommonLang.get("HTITLE552") %><!-- 검색어 --></th>
      <td><div class="SearchPopupInput" style="width:570px;">
        <input type="text" name="st_text" id="st_text" value="" onKeyDown="kepEnter_v2()" style=" width:85%; ">
      </div>     </td>
    </tr>
  </table>
  <div class="PopupListBtnBox_Center mt15">
    <!--button class="ButOutline_Medium" style="width:120px" >초기화</button--> 
    <button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:doAction('search');return false;" ><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
  </div>
  <div class="h15"></div>
  	<div style="height:350px; width: 660px;">
        	<script type="text/javascript">
				createIBSheet("mySheet", "100%", "100%");
			</script>
		</div>
</div><!-- warp 끝-->
</form> 
</body>
</html>
