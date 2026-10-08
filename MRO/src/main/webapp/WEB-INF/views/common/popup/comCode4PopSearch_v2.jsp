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
String st_code1 = CommonUtil.nvl((String) request.getParameter("st_code1"),"");  //  (조회조건)
String st_code2 = CommonUtil.nvl((String) request.getParameter("st_code2"),"");  //  (조회조건)
String st_text1 = CommonUtil.nvl((String) request.getParameter("st_text1"),"");  //  (조회조건)
String st_text2 = CommonUtil.nvl((String) request.getParameter("st_text2"),"");  //  (조회조건)

String st_tab_id = CommonUtil.nvl((String) request.getParameter("st_tab_id"),"");  //  (조회조건)

// 명함(NCIF) 참조데이터 중 "TEXT1 한 컬럼만 보여주고 TEXT2~TEXT4는 숨긴 채 같이 돌려주는" 코드그룹.
// 호출한 명함 팝업이 TEXT2~TEXT4를 받아 연동 항목(주소/영문직급/영문주소/내선번호 등)을 자동으로 채운다.
boolean isNcifCodeList = st_code1.equals("LEVL") || st_code1.equals("ADDR") || st_code1.equals("DIVI")
		|| st_code1.equals("TEAM") || st_code1.equals("POST") || st_code1.equals("HSBR")
		// 한샘 신규조직 - DMBR:도무스 매장, NXLV:넥서스 직급, NXAD:넥서스 주소
		|| st_code1.equals("DMBR") || st_code1.equals("NXLV") || st_code1.equals("NXAD");
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
		<%if(st_code1.equals("BRAN")){%>       
			{ Align:"Left",	SaveName:"TEXT1",		Header:"<%=CommonLang.get("HTITLE1406") %>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*지사*/
			,{ Align:"Left",	SaveName:"TEXT2",			Header:"<%=CommonLang.get("HTITLE1374") %>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*지점명*/
			,{ Align:"Center",	SaveName:"TEXT3",			Header:"<%=CommonLang.get("HTITLE1377") %>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*지점번호*/
			,{ Align:"Center",	SaveName:"TEXT4",			Header:"<%=CommonLang.get("HTITLE43") %>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*팩스번호*/
			,{ Align:"Left",	SaveName:"TEXT5",			Header:"<%=CommonLang.get("HTITLE345") %>",				Type:"Text",		Width:300,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*주소*/
			,{ Align:"Left",	SaveName:"TEXT6",			Header:"<%=CommonLang.get("HTITLE1407") %>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*은행명*/
			,{ Align:"Left",	SaveName:"TEXT7",			Header:"<%=CommonLang.get("HTITLE1408") %>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*계좌번호*/
		<%}else if(st_code1.equals("HMDT")){%>
			{ Align:"Left",	SaveName:"TEXT1",		Header:"<%=CommonLang.get("HTITLE1405") %>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*센터명*/
			,{ Align:"Center",	SaveName:"TEXT2",			Header:"<%=CommonLang.get("HTITLE1377") %>",				Type:"Text",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*지점번호*/
			,{ Align:"Center",	SaveName:"TEXT3",			Header:"<%=CommonLang.get("HTITLE43") %>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*팩스번호*/
			,{ Align:"Left",	SaveName:"TEXT4",			Header:"<%=CommonLang.get("HTITLE345") %>",				Type:"Text",		Width:500,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*주소*/
		<%}else if(isNcifCodeList){%>
			{ Align:"Left",	SaveName:"TEXT1",		Header:"<%=st_gbn%>",				Type:"Text",		Width:930,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}
			,{ Align:"Left",	SaveName:"TEXT2",			Header:"TEXT2",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:true,FontColor:"#3a72c7", Cursor:"Pointer"}
			,{ Align:"Left",	SaveName:"TEXT3",			Header:"TEXT3",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:true,FontColor:"#3a72c7", Cursor:"Pointer"}
			,{ Align:"Left",	SaveName:"TEXT4",			Header:"TEXT4",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:true,FontColor:"#3a72c7", Cursor:"Pointer"}
		<%}%>
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
			kepSearch(document.comCode4PopSearch, mySheet, "/common/commonList_v3.do" , pagingMode);
// 			$('#comCode2PopSearch').attr("action", "/common/commonList.do").submit();   
			break;
		case "reload": //초기화
			kepReload_v2('comCode4PopSearch');
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
	
	var value1 = mySheet.GetCellValue(Row,"TEXT1");
	var value2 = mySheet.GetCellValue(Row,"TEXT2");
	var value3 = mySheet.GetCellValue(Row,"TEXT3");
	var value4 = mySheet.GetCellValue(Row,"TEXT4");
	var value5 = mySheet.GetCellValue(Row,"TEXT5");
	var value6 = mySheet.GetCellValue(Row,"TEXT6");
	var value7 = mySheet.GetCellValue(Row,"TEXT7");
	
	
	if(column == "TEXT1" || column == "TEXT2" || column == "TEXT3" || column == "TEXT4" || column == "TEXT5" || column == "TEXT6" || column == "TEXT7"){
		var tab_id = "<%=st_tab_id%>";
		if(tab_id == ""){
			<%if(st_code1.equals("BRAN")){%>
				opener.setPopupReturn(value2,value3,value4,value5,value6,value7);
			<%}else if(st_code1.equals("HMDT")){%>
				opener.setPopupReturn(value1,value2,value3,value4);
			<%}else if(isNcifCodeList){%>
				opener.setPopupReturn(value1,value2,value3,value4);
			<%}%>
		}else{
			<%if(st_code1.equals("BRAN")){%>
				opener.tabs[tab_id]["setPopupReturn"](value2,value3,value4,value5,value6,value7);
			<%}else if(st_code1.equals("HMDT")){%>
				opener.tabs[tab_id]["setPopupReturn"](value1,value2,value3,value4);
			<%}else if(isNcifCodeList){%>
				opener.tabs[tab_id]["setPopupReturn"](value1,value2,value3,value4);
			<%}%>
		}
		this.close();
	}
}
</script> 
<body onload="kep_onload_view()">
	 <form name=comCode4PopSearch  id=comCode4PopSearch method=post >
	 <input type="hidden" name="s_SAVENAME" />
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="comCode4PopSearch">
	 <input type="hidden" name="st_buyer" id="st_buyer"  value="<%=st_buyer%>">
	 <input type="hidden" name="st_gbn" id="st_gbn"  value="<%=st_gbn%>">
	 <input type="hidden" name="st_type" id="st_type"  value="<%=st_type%>">
	 <input type="hidden" name="st_code1" id="st_code1"  value="<%=st_code1%>">
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup"  >
    	<div class="PopupTit"><%=st_gbn %> </div>
    	<!-- SYS리테일 명함용 -->
		<%if(st_type.equals("NCIF")){%>
	    	<table  class="PopupSearchTableNoline mt10" width="100%">
			<colgroup>
		      <col width="100px" />
		      <col width="*" />
			</colgroup>
		    <tr>
			<!-- 지점용 -->
			<%if(st_code1.equals("BRAN")){%>
		      <th><%=CommonLang.get("HTITLE1374") %><!-- 지점명 --></th>
		      <td><div class="SearchPopupInput" style="width:850px;">
		        <input type="text" name="st_text2" id="st_text2" value="<%=st_text2%>" onKeyDown="kepEnter_v2()" style=" width:85%; ">
		      </div>     </td>
	     	<%}else if(st_code1.equals("HMDT")){%>
	     	  <th><%=CommonLang.get("HTITLE1405") %><!-- 센터명 --></th>
		      <td><div class="SearchPopupInput" style="width:850px;">
		        <input type="text" name="st_text1" id="st_text1" value="<%=st_text1%>" onKeyDown="kepEnter_v2()" style=" width:85%; ">
		      </div>     </td>
		    <%}else if(isNcifCodeList){%>
		      <th><%=st_gbn%></th>
		      <td><div class="SearchPopupInput" style="width:850px;">
		        <input type="text" name="st_text1" id="st_text1" value="<%=st_text1%>" onKeyDown="kepEnter_v2()" style=" width:85%; ">
		      </div>     </td>
		    <%} %>
	    	</tr>
			</table>
			<div class="PopupListBtnBox_Center mt15">
				<button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:doAction('search'); return false;"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
	  		</div>
	  		<div class="h15"></div>
	  		<div style="height:270px; width: 950px;">
	        	<script type="text/javascript">
					createIBSheet("mySheet", "100%", "100%");
				</script>
			</div>
		<%} %>
</div>
</form> 
</body>
</html>
