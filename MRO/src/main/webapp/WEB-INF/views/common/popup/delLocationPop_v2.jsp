<%--
**********************************************
* 메뉴 : 배송주소(도착지) 팝업
* 화면 : 배송주소(도착지) 팝업
* 기능 : 배송주소(도착지) 팝업
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
<%@ include file="../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
String com_code = CommonUtil.nvl((String) request.getParameter("com_code"),"");  //  (조회조건) 
String del_code = CommonUtil.nvl((String) request.getParameter("del_code"),"");  //  (조회조건) 
String del_name = CommonUtil.nvl((String) request.getParameter("del_name"),"");  //  (조회조건) 
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)
String st_delyto_field = CommonUtil.nvl((String) request.getParameter("st_delyto_field"),"");  //결과내재검색
String st_check = CommonUtil.nvl((String) request.getParameter("st_check"),"");  //결과내재검색

%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			{ Align:"Center",	SaveName:"CODE",		Header:"<%=CommonLang.get("HTITLE1359") %>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*배송지코드*/
			,{ Align:"Left",	SaveName:"TEXT1",			Header:"<%=CommonLang.get("HTITLE1360") %>",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*배송지명*/
			,{ Align:"Left",	SaveName:"TEXT2",			Header:"<%=CommonLang.get("HTITLE1361") %>",				Type:"Text",		Width:550,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*배송지주소*/
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
			kepSearch(document.delLocationPop, mySheet, "/common/commonDlyLocationList_v2.do" , pagingMode);
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
	var value3 = mySheet.GetCellValue(Row,"TEXT2");
	if(column == "TEXT1" || column == "CODE" || column == "TEXT2"){
		opener.setPopupReturn(value1,value3,value2);
		this.close();
	}
}
</script>

<body onload="kep_onload_view();">
	 <form name="delLocationPop" id="delLocationPop" method=post >
	 <input type="hidden" name="s_SAVENAME" />
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="delLocationPop"> 
	 <input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>"> 	 
	 <input type="hidden" id="st_delyto_field" name="st_delyto_field" value="<%=st_delyto_field%>">
	 <input type="hidden" id="st_check" name="st_check" value="N">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE1087") %><!-- 배송주소 --><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <table  class="PopupSearchTable mt10" width="100%">
	<colgroup>
      <col width="50px" />
      <col width="340px" />
      <col width="120px" />
      <col width="390px" />
	</colgroup>
	<tr>
      <th><%=CommonLang.get("HTITLE371") %><!-- 코드 --></th>
      <td><div class="SearchPopupInput" style="width:260px;">
        <input type="text" name="del_code" id="del_code" value="" onKeyDown="kepEnter_v2()" style=" width:85%; ">
      </div>     </td>
      <th><%=CommonLang.get("HTITLE488") %><!-- 도착지(명,주소) --></th>
      <td><div class="SearchPopupInput" style="width:390px;">
        <input type="text" name="del_name" id="del_name" value="" onKeyDown="kepEnter_v2()" style=" width:85%; ">
      </div>    </td>
    </tr>
  </table>
  <div class="PopupListBtnBox_Center mt15">
    <!--button class="ButOutline_Medium" style="width:120px" >초기화</button--> 
    <button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:doAction('search');return false;"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
  </div> 
  <div class="h15"></div>
  	<div style="height:350px; width: 890px;">
        	<script type="text/javascript">
				createIBSheet("mySheet", "100%", "100%");
			</script>
		</div>
</div><!-- warp 끝-->
</form> 
</body>
</html>
