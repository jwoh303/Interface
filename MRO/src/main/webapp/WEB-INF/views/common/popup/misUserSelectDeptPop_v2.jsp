<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과  
String com_code = CommonUtil.nvl((String) request.getParameter("com_code"),"");  //  (조회조건)
String user_id = CommonUtil.nvl((String) request.getParameter("user_id"),"");  //  (조회조건)
String user_name_loc = CommonUtil.nvl((String) request.getParameter("user_name_loc"),"");  //  (조회조건)
String dept_code = CommonUtil.nvl((String) request.getParameter("dept_code"),"");  //  (조회조건)
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)
String tab_id = CommonUtil.nvl((String) request.getParameter("tab_id"),"");
String result = CommonUtil.nvl((String)request.getAttribute("result")); // 조회된결과  
%>
<script type="text/javascript">
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
function kep_onload_view(){ 
	<%
	if(_sessionInfo == null){
	%>
		$('#misUserSelectDeptPop').attr("action", "http://www.koreab2b.com").submit();
	<%
	}else{
// 		if(_sessionInfo.getComCode().equals("KRKORE0001") == false){
// 			com_code = _sessionInfo.getComCode(); 
// 		}
	}
	%>
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			{ Align:"Center",	SaveName:"USER_ID",		Header:"<%=CommonLang.get("HTITLE697") %>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true,FontColor:"#3a72c7", Cursor:"Pointer"}/*사용자ID*/
			,{ Align:"Left",	SaveName:"USER_NAME_LOC",			Header:"<%=CommonLang.get("HTITLE322") %>",				Type:"Text",		Width:160,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*사용자명*/
			,{ Align:"Left",	SaveName:"DEPT_NAME",			Header:"<%=CommonLang.get("HTITLE329") %>",				Type:"Text",		Width:190,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*부서*/
			,{ Align:"Left",	SaveName:"PHONE_NUMBER",			Header:"<%=CommonLang.get("HTITLE326") %>",				Type:"Text",		Width:160,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*전화번호*/
			,{ Align:"Left",	SaveName:"EMAIL",			Header:"<%=CommonLang.get("HTITLE41") %>",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*이메일*/
			
			,{ Align:"Left",	SaveName:"DEPARTMENT",			Header:"DEPARTMENT",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true,FontColor:"#3a72c7", Cursor:"Pointer"}
			,{ Align:"Left",	SaveName:"FAX_NUMBER",			Header:"FAX_NUMBER",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true,FontColor:"#3a72c7", Cursor:"Pointer"}
			,{ Align:"Left",	SaveName:"LEGACY_USER_ID",			Header:"LEGACY_USER_ID",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true,FontColor:"#3a72c7", Cursor:"Pointer"}
			,{ Align:"Left",	SaveName:"MOBILE_PHONE",			Header:"MOBILE_PHONE",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true,FontColor:"#3a72c7", Cursor:"Pointer"}
			,{ Align:"Left",	SaveName:"ZIP_CODE",			Header:"ZIP_CODE",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true,FontColor:"#3a72c7", Cursor:"Pointer"}
			,{ Align:"Left",	SaveName:"ADDRESS_LOC",			Header:"ADDRESS_LOC",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true,FontColor:"#3a72c7", Cursor:"Pointer"}
	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
	
	mySheet.SetTheme("DB", "DeepBlue");
	
// 	doAction('search');
}
//기능함수
function doAction(str) {
	

	switch (str) {
		case "search":	 // 조회
			if (kepIsEmpty("st_user_keyword")==true){
				//검색조건을 입력하세요.
				var text = "<%=CommonLang.msg("MSG395")%>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			kepSearch(document.misUserSelectDeptPop, mySheet, "/common/commonList_v3.do" , pagingMode);
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
	var value1 = mySheet.GetCellValue(Row,"USER_ID");
	var value2 = mySheet.GetCellValue(Row,"USER_NAME_LOC");
	var value3 = mySheet.GetCellValue(Row,"DEPARTMENT");
	var value4 = mySheet.GetCellValue(Row,"DEPT_NAME");
	var value5 = mySheet.GetCellValue(Row,"PHONE_NUMBER");
	var value6 = mySheet.GetCellValue(Row,"EMAIL");
	var value7 = mySheet.GetCellValue(Row,"FAX_NUMBER");
	var value8 = mySheet.GetCellValue(Row,"LEGACY_USER_ID");
	var value9 = mySheet.GetCellValue(Row,"MOBILE_PHONE");
	var value10 = mySheet.GetCellValue(Row,"ZIP_CODE");
	var value11 = mySheet.GetCellValue(Row,"ADDRESS_LOC");
	if(column == "USER_ID" || column == "USER_NAME_LOC" || column == "DEPT_NAME" || column == "PHONE_NUMBER" || column == "EMAIL"){
		var tab_id = "<%=tab_id%>";
		if(tab_id == ""){
			opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11);
		}else{
			opener.tabs[tab_id]["setPopupReturn"](value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11);
		}
		this.close();
	}
}

function setReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11) // id,이름,부서코드,부서명,전화번호,email,fax,휴대폰,우편번호,주소
{ 
  opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11);
  this.close();
}

</script> 
<body onload="kep_onload_view();">
	 <form name=misUserSelectDeptPop id=misUserSelectDeptPop method=post >
	 <input type="hidden" name="s_SAVENAME" />
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="misUserSelectDeptPop_v2"> 
	 <input type="hidden" name="dept_code" id="dept_code" size=20 value="<%=dept_code%>" >
	 <input type="hidden" name="com_code" id="com_code" size=20 value="<%=com_code%>" style="ime-mode:active" >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE696") %><!-- 사용자검색 --><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="Popup_GrayBox mt10">
    <div class="tit mr30" ><%=CommonLang.get("HTITLE1184")%><!--사용자부서/사용자명--></div>
    <input class="input42" style="width:335px"  placeholder="<%=CommonLang.msg("MSG771")%>" name="st_user_keyword" id="st_user_keyword" type="text" onKeyDown="kepEnter_v2()" /><!-- 사용자부서나 사용자명으로 검색하세요. -->
    <button class="ButDarkGray_Medium"  style=" width:100px" onclick="javascript:doAction('search'); return false;"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button>   
  </div>
  
  <div class="h15"></div>
  	<div class="ScrollBox mt20" style="height:332px;">
        	<script type="text/javascript">
				createIBSheet("mySheet", "100%", "100%");
			</script>
		</div>
</div><!-- warp 끝-->
</form> 
</body>
</html>
