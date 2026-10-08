<%--
**********************************************
* 메뉴 : 
* 화면 : 관리번호 팝업(form1)
* 기능 : 관리번호 팝업(form1)
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-05-06
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")

SessionInfo popSessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_buyer=  CommonUtil.nvl((String) request.getParameter("st_buyer"), popSessionInfo.getComCode()); 
String st_row      = CommonUtil.nvl((String) request.getParameter("st_row"),"");

String st_title = CommonUtil.nvl((String) request.getParameter("st_title"),"");  //  (조회조건)
String st_gbn = CommonUtil.nvl((String) request.getParameter("st_gbn"),"");  //  (조회조건) 
String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"");  //  (조회조건)
String st_pop_type = CommonUtil.nvl((String) request.getParameter("st_pop_type"),"");  //  (조회조건)
String st_tab_id = CommonUtil.nvl((String) request.getParameter("st_tab_id"),"");  //  (조회조건)
String st_ref_no=  CommonUtil.nvl((String) request.getParameter("st_ref_no"), ""); 
String userDept = "";
if(st_pop_type.equals("TYPE5")){ //KRJINR0005	하이트진로(주) 이천공장
	userDept       = popSessionInfo.getDepartment();
}
String st_code = CommonUtil.nvl((String) request.getParameter("st_code"),"");  //  (조회조건)
String st_text = CommonUtil.nvl((String) request.getParameter("st_text"),"");  //  (조회조건)
String st_text4 = CommonUtil.nvl((String) request.getParameter("st_text4"),"");  //  (조회조건)
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)
%>
<script>
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var popupSel = "";

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			{ Align:"Center",	SaveName:"CODE",		Header:"<%=CommonLang.get("HTITLE371") %>",				Type:"Text",		Width:215,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*코드*/
			,{ Align:"Left",	SaveName:"TEXT1",			Header:"<%=st_gbn %>",				Type:"Text",		Width:405,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}
	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
	
	mySheet.SetTheme("DB", "DeepBlue");
	
	doAction('search');
}
//기능함수
function doAction(str) {
	

	switch (str) {
		case "search":	 // 조회
			kepSearch(document.buyerRefPrNoPopFORM1Form, mySheet, "/common/buyerRefPrNoPopList_v2.do" , pagingMode);
			break;
		case "reload": //초기화
			kepReload_v2('buyerRefPrNoPopFORM1Form');
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
	var st_row = "<%=st_row%>";
	
	var return_value = "";
	var st_pop_type = "<%=st_pop_type%>";
	
	if(st_pop_type == "TYPE7"){ //TYPE7은 텍스트를 return값으로 보냄
		return_value = value2;
	}else if(st_pop_type == "TYPE4" || st_pop_type == "TYPE5"){ //code만 return값으로 보냄
		return_value = value1;
	}
	if(column == "TEXT1" || column == "CODE"){
		var tab_id = "<%=st_tab_id%>";
		if(tab_id == ""){
			if(return_value == ""){ // code,text return 보냄
				opener.setPopupReturn(st_row,value1,value2);
			}else{
				opener.setPopupReturn(st_row,return_value);
			}
		}else{
			if(return_value == ""){
				opener.tabs[tab_id]["setPopupReturn"](st_row,value1,value2);
			}else{
				opener.tabs[tab_id]["setPopupReturn"](st_row,return_value);
			}
		}
		this.close();
	}
}
</script>
</head>
<body onload="kep_onload_view()">
<form name="buyerRefPrNoPopFORM1Form" id="buyerRefPrNoPopFORM1Form" method=post > 
<div class="wrapPopup"  >
<input type="hidden" name="s_SAVENAME" />
	<input type="hidden" name="st_buyer" id="st_buyer"  value="<%=st_buyer%>">
	<input type=hidden name="st_ref_no" id="st_ref_no"  value="<%=st_ref_no%>">
	<input type=hidden name="st_type" id="st_type"  value="<%=st_type%>">
	<input type=hidden name="codeGubun" id="codeGubun"  value="buyerRefPrNoPopFORM1_v2">
	<input type=hidden name="st_userDept" id="st_userDept"  value="<%=userDept%>">

  <div class="PopupTit"><%=st_title %> </div>
  <table  class="PopupSearchTableNoline mt10" width="100%">
	<colgroup>
      <col width="50px" />
      <col width="190px" />
      <col width="150px" />
      <col width="240px" />
	</colgroup>
    <tr>
      <th><%=CommonLang.get("HTITLE371") %><!-- 코드 --></th>
      <td><div class="SearchPopupInput" onSubmit=" " style="width:200px;">
        <input type="text" name="st_code" id="st_code" value="" onKeyDown="kepEnter_v2()" style=" width:85%; ">
      </div>     </td>
      <th style="text-align: center"><%=st_gbn %></th>
      <td><div class="SearchPopupInput" onSubmit=" " style="width:240px;">
        <input type="text" name="st_text" id="st_text" value="" onKeyDown="kepEnter_v2()" style=" width:85%; ">
      </div>    </td>
    </tr>
	</table>
	<div class="PopupListBtnBox_Center mt15">
	<button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:doAction('search'); return false;"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
  	<button class="ButOutline_Medium" style="width:120px" onclick="javascript:doAction('reload'); return false;"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
  </div> 
	<div class="h15"></div>
  	<div style="height:270px; width: 650px;">
        	<script type="text/javascript">
				createIBSheet("mySheet", "100%", "100%");
			</script>
		</div>
</div><!-- wrapPopup 끝-->  
</form>
</body>
</html>
