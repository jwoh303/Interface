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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   ;

String st_buyer=  CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode()); 
String st_gbn = CommonUtil.nvl((String) request.getParameter("st_gbn"),"");  //  (조회조건) 
String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"");  //  (조회조건)
String st_legacy_user_id = CommonUtil.nvl((String) request.getParameter("st_legacy_user_id"),"");  //  (조회조건 사번)
String st_user_name = CommonUtil.nvl((String) request.getParameter("st_user_name"),"");  //  (조회조건)
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)
String st_tab_id = CommonUtil.nvl((String) request.getParameter("st_tab_id"),"");  //  (조회조건) 

Map<String, String> p060000029_map = CommonUtil.getSpecialCheckReturnMap(st_buyer,"P06-0000029");
String p060000029 = "";
if (p060000029_map != null){
	p060000029= CommonUtil.nvl(p060000029_map.get("COL01_DATA"),""); // 관리번호 팝업 연결(TYPE)	
}
%>
<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var p060000029 = "<%=p060000029%>";
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			{ Align:"Center",	SaveName:"DEPT_TEXT",		Header:"<%=CommonLang.get("HTITLE329") %>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*부서*/
			,{ Align:"Left",	SaveName:"USER_NAME",		Header:"<%=CommonLang.get("HTITLE325") %>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*이름*/
			,{ Align:"Center",	SaveName:"MOBILE_PHONE",		Header:"<%=CommonLang.get("HTITLE828") %>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*휴대폰*/
			,{ Align:"Center",	SaveName:"PHONE_NUMBER",		Header:"<%=CommonLang.get("HTITLE326") %>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*전화번호*/
			,{ Align:"Left",	SaveName:"EMAIL",		Header:"<%=CommonLang.get("HTITLE41") %>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*이메일*/
			,{ Align:"Left",	SaveName:"LEGACY_USER_ID",		Header:"LEGACY_USER_ID",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
	
	mySheet.SetTheme("DB", "DeepBlue");
	
}

function doAction(str) {
	switch (str) {
		case "search":	 // 조회
			var legacy_user_id_params = document.getElementById("st_legacy_user_id").value;
			var user_name_params = document.getElementById("st_user_name").value;
			if(isEmpty(legacy_user_id_params) && isEmpty(user_name_params)){ // 사번 or 이름 한개의 파라미터는 필요
				//최소 1개 이상의 검색 파라미터를 입력 해주세요
				var text = "<%=CommonLang.msg("MSG855")%>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			
			kepSearch(document.getUserPopSearch, mySheet, "/common/getUserList_v2.do" , pagingMode);
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
	
	var value1 = mySheet.GetCellValue(Row,"LEGACY_USER_ID");
	var value2 = mySheet.GetCellValue(Row,"USER_NAME");
	
	if(column == "DEPT_TEXT" || column == "USER_NAME" || column == "MOBILE_PHONE" || column == "PHONE_NUMBER" || column == "EMAIL"){
		var tab_id = "<%=st_tab_id%>";
		var st_type = "<%=st_type%>";
		
		if(tab_id == ""){
			opener.setPopupReturn(st_type,value1,value2,'');
		}else{
			opener.tabs[tab_id]["setPopupReturn"](st_type,value1,value2,'');
		}
		this.close();
	}
}

function setQuery()
{	
	var legacy_user_id_params = document.getElementById("st_legacy_user_id").value;
	var user_name_params = document.getElementById("st_user_name").value;
	if(isEmpty(legacy_user_id_params) && isEmpty(user_name_params)){ // 사번 or 이름 한개의 파라미터는 필요
		alert('최소 1개 이상의 검색 파라미터를 입력 해주세요.');
		return;
	}
  $('#getUserPopSearch').attr("action", "/common/getUserList.do").submit();   
}

function kepEnter() {	
	if (event.keyCode == 13) {		
		setQuery();
	}		
}

function setReturn(value1,value2,value3)
{
  var st_type = "<%=st_type%>";
  opener.setPopupReturn(st_type,value1,value2,value3);
  this.close();
}

 //-->
</script> 
<body onload="kep_onload_view()">
	<form name=getUserPopSearch  id=getUserPopSearch method=post >
	<input type="hidden" name="s_SAVENAME" />
	<input type="hidden" name="st_buyer" id="st_buyer"  value="<%=st_buyer%>">
	<input type="hidden" name="st_type" id="st_type"  value="<%=st_type%>">
	<input type="hidden" name="st_gbn" id="st_gbn"  value="<%=st_gbn%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup"  >
    	<div class="PopupTit"><%=st_gbn %> </div>
    	<table  class="PopupSearchTableNoline mt10" width="100%">
		<colgroup>
	      <col width="50px" />
	      <col width="190px" />
	      <col width="50px" />
	      <col width="190px" />
		</colgroup>
	    <tr>
	      <th><%=CommonLang.get("HTITLE454") %><!-- 사번 --></th>
	      <td><div class="SearchPopupInput" style="width:200px;">
	        <input type="text" name="st_legacy_user_id" id="st_legacy_user_id" value="" onKeyDown="kepEnter_v2()" style=" width:85%; ">
	      </div>     </td>
	      <th><%=CommonLang.get("HTITLE325") %><!-- 이름 --></th>
	      <td><div class="SearchPopupInput" style="width:200px;">
	        <input type="text" name="st_user_name" id="st_user_name" value="" onKeyDown="kepEnter_v2()" style=" width:85%; ">
	      </div>    </td>
	    </tr>
		</table>
		<div class="PopupListBtnBox_Center mt15">
			<button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:doAction('search'); return false;"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
  		</div>
  		<div class="h15"></div>
  		<div style="height:270px; width: 560px;">
        	<script type="text/javascript">
				createIBSheet("mySheet", "100%", "100%");
			</script>
		</div>
</div>
</form> 
</body>
</html>
