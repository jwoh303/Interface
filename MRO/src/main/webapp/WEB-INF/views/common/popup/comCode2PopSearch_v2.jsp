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
String st_title = CommonUtil.nvl((String) request.getParameter("st_title"),st_gbn);  //  (조회조건) 
String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"");  //  (조회조건)
String st_code = CommonUtil.nvl((String) request.getParameter("st_code"),"");  //  (조회조건)
String st_text = CommonUtil.nvl((String) request.getParameter("st_text"),"");  //  (조회조건)
String st_text4 = CommonUtil.nvl((String) request.getParameter("st_text4"),"");  //  (조회조건)
String st_tab_id = CommonUtil.nvl((String) request.getParameter("st_tab_id"),"");  //  (조회조건)
Map<String, String> p060000029_map = CommonUtil.getSpecialCheckReturnMap(st_buyer,"P06-0000029");
String p060000029 = "";
if (p060000029_map != null){
	p060000029= CommonUtil.nvl(p060000029_map.get("COL01_DATA"),""); // 관리번호 팝업 연결(TYPE)	
}
%>
<script type="text/javascript">
<!--

var p060000029 = "<%=p060000029%>";

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			{ Align:"Center",	SaveName:"CODE",		Header:"<%=CommonLang.get("HTITLE371") %>",				Type:"Text",		Width:230,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*코드*/
			,{ Align:"Left",	SaveName:"TEXT1",			Header:"<%=st_gbn %>",				Type:"Text",		Width:400,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}
			,{ Align:"Left",	SaveName:"TEXT2",			Header:"<%=st_gbn %>",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:true,FontColor:"#3a72c7", Cursor:"Pointer"}
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
			kepSearch(document.comCode2PopSearch, mySheet, "/common/commonList_v3.do" , pagingMode);
// 			$('#comCode2PopSearch').attr("action", "/common/commonList.do").submit();   
			break;
		case "reload": //초기화
			kepReload_v2('comCode2PopSearch');
			mySheet.RemoveAll();
			break;
	}
}
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	var st_type = "<%=st_type%>";
	var p060000029 = "<%=p060000029%>";
	
	if(st_type == "C023"){
		mySheet.SetColWidth("TEXT1",200);
		mySheet.SetColHidden("TEXT2",false);
	}else if(p060000029 == "TYPE28"){
		for(var i = 1; i<=mySheet.RowCount(); i++){
			var codeTmp = mySheet.GetCellValue(i,"CODE");
			if(codeTmp[0] == "1"){
				mySheet.SetCellValue(i,"CODE","100");
			}else{
				mySheet.SetCellValue(i,"CODE","200");
			}
		}
	}

}
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	var value1 = mySheet.GetCellValue(Row,"CODE");
	var value2 = mySheet.GetCellValue(Row,"TEXT1");
	var value3 = mySheet.GetCellValue(Row,"TEXT2");
	
	var st_type = "<%=st_type%>";
	var p060000029 = "<%=p060000029%>";
	
	if(column == "TEXT1" || column == "CODE" || column == "TEXT2"){
		var tab_id = "<%=st_tab_id%>";
		if(tab_id == ""){
			if(st_type == "C023"){
				opener.setPopupReturn(st_type,value1,value2,value3);
			}else if(st_type == "HQBR"){
				opener.setPopupReturn(st_type,value2,value3,'');
			}else if(p060000029 == "TYPE28"){
				opener.setPopupReturn(st_type,value1,value2,'');
			}else{
				opener.setPopupReturn(st_type,value1,value2,'');
			}
		}else{
			if(st_type == "C023"){
				opener.tabs[tab_id]["setPopupReturn"](st_type,value1,value2,value3);
			}else if(st_type == "HQBR"){
				opener.tabs[tab_id]["setPopupReturn"](st_type,value2,value3,'');
			}else if(p060000029 == "TYPE28"){
				opener.tabs[tab_id]["setPopupReturn"](st_type,value1,value2,'');
			}else{
				opener.tabs[tab_id]["setPopupReturn"](st_type,value1,value2,'');
			}
		}
		this.close();
	}
}

 //-->
</script> 
<body onload="kep_onload_view()">
	 <form name=comCode2PopSearch  id=comCode2PopSearch method=post >
	 <%if(p060000029.equals("TYPE28")){ %>
	 		<input type="hidden" name="codeGubun" id="codeGubun"  value="comCode2PopHaev">
	 <% } else { %>
	 		<input type="hidden" name="codeGubun" id="codeGubun"  value="comCode2PopSearch">
	 <% } %>	 
	 <input type="hidden" name="s_SAVENAME" />
	 <input type="hidden" name="st_buyer" id="st_buyer"  value="<%=st_buyer%>">
	 <input type="hidden" name="st_type" id="st_type"  value="<%=st_type%>">
	 <input type="hidden" name="st_gbn" id="st_gbn"  value="<%=st_gbn%>">  
	 <input type="hidden" name="st_text4" id="st_text4"  value="<%=st_text4%>">  
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
<div class="wrapPopup"  >
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
	      <td><div class="SearchPopupInput" style="width:200px;">
	        <input type="text" name="st_code" id="st_code" value="<%=st_code%>" onKeyDown="kepEnter_v2()" style=" width:85%; ">
	      </div>     </td>
	      <th style="text-align: center">
	      	<%if(st_type.equals("C021")){ %>
 				<%=st_gbn%>
  			<%}else if(st_type.equals("C020")){%>
  				<%=st_gbn%>
  			<%}else if(st_type.equals("M014")){%>
				<%=st_gbn%>
			<%}else{%>
  				<%=CommonLang.get("HTITLE1272")%><!--텍스트-->
  			<%}%>
  			</th>
	      <td><div class="SearchPopupInput" style="width:240px;">
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
</div>
</form> 
</body>
</html>
